HA$PBExportHeader$u_nvo_proc_ncr.sru
$PBExportComments$Process NCR EDI Files
forward
global type u_nvo_proc_ncr from nonvisualobject
end type
end forward

global type u_nvo_proc_ncr from nonvisualobject
end type
global u_nvo_proc_ncr u_nvo_proc_ncr

type variables
datastore	idsPOHeader,idsPODetail,idsDOheader,idsDODetail,idsDOAddress,idsdoNotes
				
datastore	ids_reports, idsXML, idsReceiveMaster, idsReceiveDetail,idsDeliveryMaster, idsDeliveryDetail				
datastore idsNCRContentSummary, iu_ds
string theProject
constant int success = 0
constant int failure = -1
long ilineSeq = 0
String	isEmailLogFile
string theWarehouse
string theSupplier


end variables

forward prototypes
public function integer uf_validstatuscode (string sa_code)
public function integer uf_process_862 (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_shipmentexists (string as_project, string as_shipment)
public function integer uf_updatestagetable (string astable, string asgroup, string astransaction, integer aivalue)
public function integer uf_process_214 (string asproject, string aspath)
public function integer uf_applystatus (string asproject, string aspath)
public function integer uf_process_inventory_snapshot ()
public subroutine setproject (string _project)
public function string getproject ()
public subroutine broadcast (string _message)
public subroutine uf_write_outline (ref datastore _dsout, decimal _batchseqnum, string _outputline, long _insertrow)
public function integer uf_writeerror (string aserrormsg)
public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments)
public function integer uf_process_855 (string thedono)
public function integer uf_process_do (string aspath, string asproject)
public subroutine setwarehouse ()
public function string getwarehouse ()
public function string getnextelement (ref string _recdata)
public subroutine setwarehouse (string _warehouse)
public function datetime uf_getearliestarrivaldate (string thesku, string thesupplier, decimal theowner, datetime thearrivaldate)
public function integer uf_process_delivery_order (string asproject)
end prototypes

public function integer uf_validstatuscode (string sa_code);string lsStatus

	Select status_code into :lsStatus
	From shipment_status_code
	Where status_code = :sa_code;
	//messagebox ("TEMPO", "Valid Status Code: " + lsStatus + ".")
	if isnull(sa_code) then
		return -1
	end if
return 0
end function

public function integer uf_process_862 (string aspath, string asproject);// This function will load a standard 862 layout from Mercator to SIMS

datastore	lu_ds,  ldsMaster, ldsLine, ldsForecast
String	lsLogout, lsRecData, lsTemp, lsDateTemp, lsFind
Integer	liRC, liFileNo
Long		llNewRow, llRowCount, llRowPos, llFileSeq, llLineSeq, llForecastSeq, llFindRow
Boolean	lbError

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsMaster = Create u_ds_datastore
ldsMaster.dataobject = 'd_shipping_sched_Master'
ldsMaster.SetTransObject(SQLCA)

ldsLine = Create u_ds_datastore
ldsLine.dataobject = 'd_shipping_sched_Detail'
ldsLine.SetTransObject(SQLCA)

ldsForecast = Create u_ds_datastore
ldsForecast.dataobject = 'd_shipping_sched_Forecast'
ldsForecast.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Shipping Schedule Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Processing (project/Path): " + asProject + ' - ' + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsRecData) 
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

llRowCount = lu_ds.RowCount()

lsLogOut = space(8) + String(llRowCount) + ' Rows were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Process each Row - Header, Detail or Forecast
For llRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetItemString(llRowPos,'rec_data')
	
	lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1)) /*should be record Type (header, Line or forecast) */
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	//Process header or Detail */
	Choose Case Upper(lsTemp)
			
		//HEADER RECORD
		Case 'SH' /* Header */
			
			llLineSeq = 0 /* reset line sequence for new header*/
			
			llNewRow = ldsMaster.InsertRow(0)
			
			//Get the next available file sequence number
			llFileSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'shipping_Schedule_Master','ss_no')
			If llFileSeq <= 0 Then Return -1

			//Defaults
			ldsMaster.SetItem(llNewRow,'ss_no',asProject + String(llfileSeq,'000000'))
			ldsMaster.SetItem(llNewRow,'project_id',asProject)		
			
			//Action Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'action_code',lsTemp)		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Schedule Issue Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDate(lsDateTemp) then
				ldsMaster.SetItem(llNewRow,'schedule_issue_date',Date(lsDateTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Forecast Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'forecast_type',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Schedule Begin Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDate(lsDateTemp) then
				ldsMaster.SetItem(llNewRow,'schedule_begin_date',Date(lsDateTemp))
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Schedule End Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDAte(lsDateTemp) then
				ldsMaster.SetItem(llNewRow,'schedule_end_date',Date(lsDateTemp))
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Release Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'forecast_release_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Reference Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'reference_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Contract Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'contract_Number',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'po_Number',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Forecast QTY Qualifier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'forecast_qty_Qualifier',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship From
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'ship_from_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to (UCCS Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'ship_to_uccs_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Seller
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'seller_code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Buyer
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'buyer_code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Intermediate Consignee
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsMaster.SetItem(llNewRow,'intermed_consignee_code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
		// Line Item Row
		Case 'SL' /*Line */
			
			llForecastSeq = 0 /*forecast sequence number within line item number*/
			
			llNewRow = ldsLine.InsertRow(0)
			
			//Release Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'forecast_release_no',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship From
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'ship_from_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to (UCCS Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'ship_to_uccs_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Product ID Qualifier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'part_number_Qualifier',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Part Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'part_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If this is the suppliers part, we will want to load the SKU as well. 
			// OTherwise we'll get the SKU from the customer SKU table
//			If ldsLine.GetITemString(llRowPos,'part_number_Qualifier') = 'SP' Then
//				ldsLine.SetItem(llNewRow,'SKU',ldsLine.GetITemString(lLRowPos,'part_no'))
//			Else
//				
//			End If
			
			//Line Item PO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'line_item_po_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//UOM
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'UOM',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Unit Price
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isNumber(lsTemp) Then
				ldsLine.SetItem(llNewRow,'Unit_Price',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Dock Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Dock_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Line Feed
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Line_Feed',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Reserve Line Feed
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Reserve_Line_Feed',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Contact Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Contact_Type',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Contact Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Contact_Name',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Contact Telephone
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'Contact_telephone',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//QTY from last ASN
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isnumber(lsTemp) Then
				ldsLine.SetItem(llNewRow,'last_shipment_qty',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Cumulative QTY
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isnumber(lsTemp) Then
				ldsLine.SetItem(llNewRow,'cumulative_ship_qty',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Challenge QTY
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isnumber(lsTemp) Then
				ldsLine.SetItem(llNewRow,'challenge_qty',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Pending QTY
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isnumber(lsTemp) Then
				ldsLine.SetItem(llNewRow,'pending_qty',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Cum Start Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDAte(lsDateTemp) then
				ldsLine.SetItem(llNewRow,'cumulative_start_date',Date(lsDateTemp))
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Last Shipped Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDAte(lsDateTemp) then
				ldsLine.SetItem(llNewRow,'last_Ship_date',Date(lsDateTemp))
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Last Received Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDAte(lsDateTemp) then
			//	ldsLine.SetItem(llNewRow,'last_Ship_date',lsDateTemp)
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Packing Slip Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'last_ship_ref_nbr',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Engineering Change Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsLine.SetItem(llNewRow,'engineering_Chg_cd',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			
			//Record Defaults
			llLineSeq ++
			ldsLine.SetITem(llNewRow,'line_item_No',llLineSeq)
			
			String lsSubFind
			
			//Find the header that has the SS_NO we want (for this release no, ship from and ship to)
			lsFind = "Upper(forecast_release_no) = '" + Upper(ldsLine.GetITemString(llNewRow,'forecast_release_no')) + & 
						"' and Upper(ship_from_code) = '" + Upper(ldsLine.GetITemString(llNewRow,'ship_from_code')) + &
						"' and Upper(ship_to_uccs_code) = '" + Upper(ldsLine.GetITemString(llNewRow,'ship_to_uccs_Code')) + "'"
			llFindRow = ldsMaster.Find(lsFind,1,ldsMaster.RowCount())
			If llFindRow > 0 Then
				ldsLine.SetItem(llNewRow,'ss_no',ldsMaster.GetITemString(llFindRow,'ss_no'))
			Else /*header not found - reject*/
			
				lsSubFind = "Upper(forecast_release_no) = '" + Upper(ldsLine.GetITemString(llNewRow,'forecast_release_no')) + & 
								"' and Upper(ship_from_code) = '" + Upper(ldsLine.GetITemString(llNewRow,'ship_from_code')) + "'"


						
				llFindRow = ldsMaster.Find(lsSubFind,1,ldsMaster.RowCount())		

//				gu_nvo_process_files.uf_writeError("Find: " + lsSubFind + ".")
//				gu_nvo_process_files.uf_writeError("Find Row: " + string(llFindRow) + ".")
				
				
				IF llFindRow > 0 THEN

					//Create another header record because there is only record created for multiple - ship tos.
	
					ldsMaster.RowsCopy(llFindRow, llFindRow, Primary!, ldsMaster, ldsMaster.RowCount() + 1, Primary!)

					llFileSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'shipping_Schedule_Master','ss_no')
					If llFileSeq <= 0 Then Return -1
					
					//Defaults
					ldsMaster.SetItem(ldsMaster.RowCount(),'ss_no',asProject + String(llfileSeq,'000000'))
	
					ldsLine.SetItem(llNewRow,'ss_no',ldsMaster.GetITemString(llFindRow,'ss_no'))
			

				ELSE /*header not found - reject*/
			
					ldsLine.SetItem(llNewRow,'ss_no','')
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No Header Record found for Line Format. Record will not be processed.")
					lbError = True
					Continue /*Next Record*/
		
				End If
							
			End If
			
		Case 'SF' /* ForeCast */
			
			llNewRow = ldsForecast.InsertRow(0)
			
			//Release Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			ldsForecast.SetItem(llNewRow,'forecast_release_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship From
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsForecast.SetItem(llNewRow,'ship_from_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to (UCCS Code)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsForecast.SetItem(llNewRow,'ship_to_uccs_Code',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Part Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsForecast.SetItem(llNewRow,'part_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Forecast QTY
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			If isnumber(lsTemp) Then
				ldsForecast.SetItem(llNewRow,'forecast_qty',Dec(lsTemp))
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Forecast qty qualifier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lsTemp = lsRecData
			End If
			ldsForecast.SetItem(llNewRow,'forecast_qualifier',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Forecast Ship Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsDateTemp = lsTemp
			lsDateTemp = mid(lsDateTemp,3,2) + '/' + Right(lsDateTEmp,2) + '/' + '20' + left(lsDateTemp,2)
			If isDate(lsDateTemp) then
				ldsForecast.SetItem(llNewRow,'forecast_Delivery_date',Date(lsDateTemp))
			End If
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Record level defaults
			llForecastSeq ++
			ldsForecast.SetItem(llNEwRow,'forecast_seq_No',llForecastSeq)
						
			//Find the matching Detail for SS-NO and Line ITem Number
			lsFind = "Upper(forecast_release_no) = '" + Upper(ldsForecast.GetITemString(llNewRow,'forecast_release_no')) + & 
						"' and Upper(ship_From_Code) = '" + Upper(ldsForecast.GetITemString(llNewRow,'ship_from_Code')) + &
						"' and Upper(ship_to_uccs_Code) = '" + Upper(ldsForecast.GetITemString(llNewRow,'ship_to_uccs_Code')) + &
						"' and Upper(part_no) = '" + Upper(ldsForecast.GetITemString(llNewRow,'part_no')) + "'"
			llFindRow = ldsLine.Find(lsFind,1,ldsLine.RowCount())
			If llFindRow > 0 Then
				ldsForecast.SetItem(llNewRow,'ss_no',ldsLine.GetITemString(llFindRow,'ss_no'))
				ldsForecast.SetItem(llNewRow,'line_item_no',ldsLine.GetITemNumber(llFindRow,'line_Item_No'))
			Else /*Detail not loaded - shouldn't happen - reject*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No Line Record found for Forecast Format. Record will not be processed.")
				lbError = True
				Continue /*Next Record*/
			End If
					
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */

	End Choose /*Record Type */

Next /*import Record */

//If no errors, save the records
If lbError Then 
	lsLogOut =  "       ***Errors were encountered with this file. No changes will be made to the database."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

liRC = ldsMaster.Update()
If liRC = 1 Then
	liRC = ldsLine.Update()
End If
If liRC = 1 Then
	liRC = ldsforecast.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new Shipping Schedule Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

Return 0
end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name\
// 10/04 - PCONKL - We need to open the file and read the first 4 characters of the first row to determine file type

String	lsLogOut, lsSaveFileName, lsRecData, lsProcessType
Integer	liRC, liFileNo
Long	llNewRow
Boolean	bRet

If not isvalid(iu_ds) Then
	iu_ds = Create datastore
	iu_ds.dataobject = 'd_generic_import'
End IF

iu_ds.Reset()

// Load the temp datastore and pass to appropriate function based on the first record type

//Open the File
broadcast( '      - Opening File for  Processing: ' + asPath)

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	broadcast( "-       ***Unable to Open File for NCR Processing: " + asPath)
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//Read the file and load the datastore
liRC = FileRead(liFileNo,lsRecData)
Do While liRC > 0
	llNewRow = iu_ds.InsertRow(0)
	iu_ds.SetITem(llNewRow,'rec_data',lsRecdata)
	liRC = FileRead(liFileNo,lsRecData)
Loop

FileClose(liFileNo)

If iu_ds.RowCount() > 0 Then
	
	//Processing is based on the record type of the first record in the file
	Choose Case Upper(Left(Trim(asFile),4)) 
		Case 'N940'  
			if  uf_process_do(asPath, asProject) = success then
				uf_process_Delivery_order( asProject ) 	
			end if
			
		Case Else /*Invalid file type*/
		
			broadcast( "        - Invalid Document Type in first record: " + Upper(Right(Trim(iu_ds.GetITemString(1,'rec_data')),4))  + " - File will not be processed.")
			Return failure
		
	End Choose
	
Else /*No Rows*/
	
	broadcast("        - No records found in file")
			
End IF

Return success			

end function

public function integer uf_shipmentexists (string as_project, string as_shipment);string lsShip
/* should this be part of ApplyStatus?
   We need to capture Ship_No and DeliveryDate.  Use Instance Var, str_Parms...
	 What if more than 1 record for as_Shipment? (Select Max(..)?)
	 Thinking that I should use a data store of the Shipment table
	   (may need to modify POD_Name, Freight_ATD, Freight_ETA, Freight_ATA, OSD_Flag, Pro_No? (if blank)
*/

if isnull(as_Shipment) then
	return -1
else
	select awb_bol_no into :lsShip
	from shipment
	where project_id = :as_Project and awb_bol_no = :as_Shipment;
	///messagebox ("TEMPO", "Existing Shipment?: " + lsShip + ".")
	if lsShip = "" then
		return -1
	end if
end if
return 0


end function

public function integer uf_updatestagetable (string astable, string asgroup, string astransaction, integer aivalue);/*update status_Import_1 //:asTable
set SIRS_ID = :aiValue
where SI1_GroupControlNbr = :asGroup and SI1_TransactionControlNbr = :asTransaction;
*/

string lsSQL, lsErrText

	lsSQL = "Update Status_Import_" + asTable + " set"
	lsSQL += " SIRS_ID = " + string(aiValue)
	lsSQl += " Where SI" + asTable + "_GroupControlNbr = '" + asGroup + "'"
	lsSQl += " and SI" + asTable + "_TransactionControlNbr = '" + asTransaction + "'"
	
	//messagebox ("TEMPO - SQL", lsSql)
		
	Execute Immediate :lsSQL Using SQLCA;
	commit;

/*
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Rollback;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If
	*/

	//If Sqlca.sqlnrows <> 1 Then /*Insert*/
return 0

end function

public function integer uf_process_214 (string asproject, string aspath);/* Process EDI 214 Files (Copied from u_nvo_proc_gm.uf_process_so) */

Datastore	ldsSI1, ldsSI2, ldsSI4, ldsSI5
				
string	lsLogOut, lsRecData, lsRecType, lsProject

string lsTDate, lsTTime

Integer	liFileNo, liRC
				
//Long		llRowCount,	llRowPos, llNewRow, llNewHeaderRow, llNewDetailRow, llOrderSeq,	llBatchSeq,	llLineSeq, &
//				llCount,llLineItemNo, llNewAddressRow, llNewNotesRow
	
Long		llRowCount,	llRowPos, llNewRow, llNewSI1Row, llNewSI2Row, llNewSI4Row, llNewSI5Row, llCount, &
				llBatchSeq

Boolean	lbError
			
/* variables to capture data common to each record type (approx. first 100 char.) 
    (what about calling a function, passing it the datastore (1,2,4 or 5), the data string, ...*/
string lsSetID, lsInternalID, lsSenderID, lsReceiverID, lsGroupControlNbr, lsTransactionControlNbr, &
			 lsCreateDate, lsCreateTime, lsReceivedDate, lsReceivedTime, lsRecordNbr
			 
date ldCreateDate, ldReceivedDate

ldsSI1 = Create u_ds_datastore
ldsSI1.dataobject = 'd_status_import_1'
ldsSI1.SetTransObject(SQLCA)

ldsSI2 = Create u_ds_datastore
ldsSI2.dataobject = 'd_status_import_2'
ldsSI2.SetTransObject(SQLCA)

ldsSI4 = Create u_ds_datastore
ldsSI4.dataobject = 'd_status_import_4'
ldsSI4.SetTransObject(SQLCA)

ldsSI5 = Create u_ds_datastore
ldsSI5.dataobject = 'd_status_import_5'
ldsSI5.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for 214 Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/ //dts - screen?

liFileNo = FileOpen(asPath, LineMode!, Read!, LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for 214 Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo, lsRecData)

Do While liRC > 0
	
	/*Process record (Status_Import_1,2,4 or 5) */
	
/* All record types share the first 100 (or so) characters: 
SetID = "1-6"
InternalID = "7-10"
SenderID = "11-25"
ReceiverID = "26-40"
GroupControlNbr = "41-49"
TransactionControlNbr = "50-58"
CreateDate = "59-66"
CreateTime = "67-72"
ReceivedDate = "73-80"
ReceivedTime = "81-86"
RecordNbr = "87-93"
RecordType = "94-95"
*/
   lsSetID = Mid(lsRecData,1,6) 
	lsInternalID = Mid(lsRecData,7,4) 
	lsSenderID = Mid(lsRecData,11,15) 
	lsReceiverID = Mid(lsRecData,26,15) 
	lsGroupControlNbr = Mid(lsRecData,41,9) 
	lsTransactionControlNbr = Mid(lsRecData,50,9) 
	lsCreateDate = Mid(lsRecData,59,8) 
	//ldCreateDate = date(mid(lsCreateDate,5,2) + "/" + mid(lsCreateDate,7,2) + "/" + left(lsCreateDate,4))
   ldCreateDate = date(left(lsCreateDate,4) + "-" + mid(lsCreateDate,5,2) + "-" + mid(lsCreateDate,7,2))
	lsCreateTime = Mid(lsRecData,67,6) 
	lsCreateTime = left(lsCreateTime,2) + ":" + mid(lsCreateTime,3,2) 
	lsReceivedDate = Mid(lsRecData,73,8)
	ldReceivedDate = date(left(lsReceivedDate,4) + "-" + mid(lsReceivedDate,5,2) + "-" + mid(lsReceivedDate,7,2))
	lsReceivedTime = Mid(lsRecData,81,6) 
   lsReceivedTime = left(lsReceivedTime,2) + ":" + mid(lsReceivedTime,3,2) 
	lsRecordNbr = Mid(lsRecData,87,7) 
	lsRecType = Mid(lsRecData,94,2) /*record Type*/
	If isNull(lsRecType) then lsRecType = ''
	
	//messagebox ("TEMPO","RecType: " + string(lsRecType))
	Choose Case Upper(lsRecType)
		/* SI1 */
		Case '01'
			llNewSI1Row = ldsSI1.InsertRow(0)

/*	?Make siq_seq (etc.) auto-increment?
		?How do we tell project in ApplyStatus?
		?Use next_seq_no to get project-specific sequence, and then concatenate project_id?
		?Should Customer be the Project_id (and not what's in the file)?  Looks like that's what ETMS was doing.
*/
			//Get the next available sequence number
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'Status_Import_1','SI1_Seq')
			If llBatchSeq <= 0 Then Return -1
			
			/* Fields Common to all Record Types... 		 (should we call a function to share this?) */			
			ldsSI1.SetItem(llNewSI1Row, 'SI1_Seq', llBatchSeq)
			ldsSI1.SetItem(llNewSI1Row, 'SIRS_ID',1) /* 1 ==> unprocessed */
			ldsSI1.SetItem(llNewSI1Row, 'SI1_SetID', lsSetID)			
			ldsSI1.SetItem(llNewSI1Row, 'SI1_ReceiverID', lsReceiverID)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_SenderID', lsSenderID)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_InternalID', lsInternalID)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_GroupControlNbr', lsGroupControlNbr)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_TransactionControlNbr', lsTransactionControlNbr)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_CreateDate', ldCreateDate)
			ldsSI1.SetItem(llNewSI1Row, 'SI1_ReceivedDate', ldReceivedDate)
			
			/* Type1-specific fields: */
			//lsTemp = Mid(lsRecData,113,15)
			//messagebox("Customer", lstemp + "!x")
			ldsSI1.SetItem(llNewSI1Row, 'SI1_Customer', Mid(lsRecData,113,15))
			//lsTemp = Mid(lsRecData,128,4)
			//messagebox("Carrier", lstemp + "!x")
			ldsSI1.SetItem(llNewSI1Row, 'SI1_Carrier', Mid(lsRecData,128,4))
			//lsTemp = Mid(lsRecData,132,22)
			//messagebox("CarrierRefNbr", lstemp + "!x")
			ldsSI1.SetItem(llNewSI1Row, 'SI1_CarrierRefNbr', Mid(lsRecData,132,22))
			//lsTemp = Mid(lsRecData,154,30)
			//messagebox("ShpperRefNbr", lstemp + "!x")
			ldsSI1.SetItem(llNewSI1Row, 'SI1_ShpperRefNbr', Mid(lsRecData,154,30))
			//lsTemp = Mid(lsRecData,184,30)
			//messagebox("PONumber", lstemp + "!x")
			ldsSI1.SetItem(llNewSI1Row, 'SI1_PONumber', Mid(lsRecData,184,30))

  		/*
		  dsDOHeader.SetItem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')
			*/


			/*
			//Order Number
			lsTemp = Trim(Mid(lsRecData,15,7))
			If lsTemp > '' Then
				ldsDOHeader.SetItem(llNewHeaderRow,'invoice_no',lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number not present. Order will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			*/
			
		Case '02'
			llNewSI2Row = ldsSI2.InsertRow(0)

			//Get the next available sequence number (See comments above)
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'Status_Import_2','SI2_Seq')
			If llBatchSeq <= 0 Then Return -1
			
			/* Fields Common to all Record Types... 		 (should we call a function to share this?) */
			ldsSI2.SetItem(llNewSI2Row, 'SI2_Seq', llBatchSeq)
			ldsSI2.SetItem(llNewSI2Row, 'SIRS_ID',1) /* 1 ==> unprocessed */
			ldsSI2.SetItem(llNewSI2Row, 'SI2_SetID', lsSetID)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_ReceiverID', lsReceiverID)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_SenderID', lsSenderID)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_InternalID', lsInternalID)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_GroupControlNbr', lsGroupControlNbr)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_TransactionControlNbr', lsTransactionControlNbr)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_CreateDate', ldCreateDate)
			ldsSI2.SetItem(llNewSI2Row, 'SI2_ReceivedDate', ldReceivedDate)
			
			/* Type2-specific fields: */			 
			ldsSI2.SetItem(llNewSI2Row,'SI2_EntityQualifier', Mid(lsRecData,113, 2))
			ldsSI2.SetItem(llNewSI2Row,'SI2_Name', Mid(lsRecData,115, 60))
			ldsSI2.SetItem(llNewSI2Row,'SI2_Address1', Mid(lsRecData,175, 55))
			ldsSI2.SetItem(llNewSI2Row,'SI2_Address2', Mid(lsRecData,230, 55))
			ldsSI2.SetItem(llNewSI2Row,'SI2_Address3', Mid(lsRecData,285, 55))
			ldsSI2.SetItem(llNewSI2Row,'SI2_City', Mid(lsRecData,340, 30))
			ldsSI2.SetItem(llNewSI2Row,'SI2_State', Mid(lsRecData,370, 2))
			ldsSI2.SetItem(llNewSI2Row,'SI2_PostalCode', Mid(lsRecData,372, 15))
			ldsSI2.SetItem(llNewSI2Row,'SI2_Country', Mid(lsRecData,387, 3))
					
		Case '04'
			llNewSI4Row = ldsSI4.InsertRow(0)

			//Get the next available sequence number (See comments above)
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'Status_Import_4','SI4_Seq')
			If llBatchSeq <= 0 Then Return -1
			
			/* Fields Common to all Record Types... 		 (should we call a function to share this?) */
			ldsSI4.SetItem(llNewSI4Row, 'SI4_Seq', llBatchSeq)
			ldsSI4.SetItem(llNewSI4Row, 'SIRS_ID',1) /* 1 ==> unprocessed */
			ldsSI4.SetItem(llNewSI4Row, 'SI4_SetID', lsSetID)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_ReceiverID', lsReceiverID)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_SenderID', lsSenderID)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_InternalID', lsInternalID)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_GroupControlNbr', lsGroupControlNbr)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_TransactionControlNbr', lsTransactionControlNbr)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_CreateDate', ldCreateDate)
			ldsSI4.SetItem(llNewSI4Row, 'SI4_ReceivedDate', ldReceivedDate)
			
			/* Type4-specific fields: */			 
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusCode', Mid(lsRecData,113, 3))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusReasonCode', Mid(lsRecData,116, 3))
			ldsSI4.SetItem(llNewSI4Row,'SI4_ApptStatusCode', Mid(lsRecData,119, 3))
			ldsSI4.SetItem(llNewSI4Row,'SI4_ApptReasonStatusCode', Mid(lsRecData,122, 3))
			//ldsSI4.SetItem(llNewSI4Row,'SI4_StatusDate', Mid(lsRecData,125, 8))
			//ldsSI4.SetItem(llNewSI4Row,'SI4_StatusTime', Mid(lsRecData,133, 6))
			//parse Date and time from file...
			lsTDate = Mid(lsRecData,125, 8)
      //lsTDate = Mid(lsTDate, 5, 2) + "/" + Mid(lsTDate, 7, 2) + "/" + Left(lsTDate, 4)
			lsTDate = Left(lsTDate, 4) + "-" + Mid(lsTDate, 5, 2) + "-" + Mid(lsTDate, 7, 2)
			lsTTime = Mid(lsRecData,133, 6)
      lsTTime = Left(lsTTime, 2) + ":" + Mid(lsTTime, 3, 2)
			//messagebox ("lsTDate + lsTTime", lsTDate + " " + lsTTime +".")
			//ldsSI4.SetItem(llNewSI4Row,'SI4_StatusDate', Date(lsTDate))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusDate', DateTime(date(lsTDate), time(lsTTime)))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusTimeZone', Mid(lsRecData,139, 2))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusCity', Mid(lsRecData,141, 30))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusState', Mid(lsRecData,171, 2))
			ldsSI4.SetItem(llNewSI4Row,'SI4_StatusCountry', Mid(lsRecData,173, 3))
			
		Case '05'
			llNewSI5Row = ldsSI5.InsertRow(0)

			//Get the next available sequence number (See comments above)
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'Status_Import_5','SI5_Seq')
			If llBatchSeq <= 0 Then Return -1
			
			/* Fields Common to all Record Types... 		 (should we call a function to share this?) */
			ldsSI5.SetItem(llNewSI5Row, 'SI5_Seq', llBatchSeq)
			ldsSI5.SetItem(llNewSI5Row, 'SIRS_ID',1) /* 1 ==> unprocessed */
			ldsSI5.SetItem(llNewSI5Row, 'SI5_SetID', lsSetID)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_ReceiverID', lsReceiverID)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_SenderID', lsSenderID)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_InternalID', lsInternalID)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_GroupControlNbr', lsGroupControlNbr)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_TransactionControlNbr', lsTransactionControlNbr)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_CreateDate', ldCreateDate)
			ldsSI5.SetItem(llNewSI5Row, 'SI5_ReceivedDate', ldReceivedDate)
			
			/* Type5-specific fields: */			 
			ldsSI5.SetItem(llNewSI5Row,'SI5_OSDFlag', Mid(lsRecData,113, 1))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentWeightQualifier', Mid(lsRecData,114, 2))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentWeightUOM', Mid(lsRecData,116, 1))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentWeight', Mid(lsRecData,117, 10))
			// ldsSI5.SetItem(llNewSI5Row,'PieceCount', Mid(lsRecData,127, 7))
			// ldsSI5.SetItem(llNewSI5Row,'VolumeUOM', Mid(lsRecData,134, 1))
			// ldsSI5.SetItem(llNewSI5Row,'Volume', Mid(lsRecData,135, 8))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentLadingQuantity', Mid(lsRecData,127, 7))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentServiceStandard', Mid(lsRecData,143, 4))
			ldsSI5.SetItem(llNewSI5Row,'SI5_ShipmentServiceLevel', Mid(lsRecData,147, 2))
			ldsSI5.SetItem(llNewSI5Row,'SI5_Signature', Mid(lsRecData,149, 35))
			

		Case Else /*Invalid rec type */
			
		  gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
		  lbError = True
		  //Continue /*Next Record */

	End Choose /*Header or Detail */
	
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//dts llOrderSeq = 0 /*order seq within file*/

//dts llRowCount = lu_ds.RowCount()

//Process each Row
//The columns are delimited but fixed length as well, we can go by position
/*dts
For llRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
	
	//If Record ID not 'ORDER' then Error
	If Upper(Left(lsRecData,5)) <> 'ORDER' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record ID: '" + Left(lsRecData,5) + "'. Record will not be processed.")
		lbError = True
		Continue /*Next Record */
	End If
		
			
	
Next /*file record */
dts*/

//Save Changes
liRC = ldsSI1.Update()
//commit; //tempo - for testing
If liRC = 1 Then
	liRC = ldsSI2.Update()
End If
If liRC = 1 Then
	liRC = ldsSI4.Update()
End If
If liRC = 1 Then
	liRC = ldsSI5.Update()
End If

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Problem saving 214 Staging records."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1
///messagebox ("TEMPO-Process_214", "Calling ApplyStatus.")
lirc = uf_ApplyStatus(asProject, asPath)
///messagebox ("TEMPO-Process_214", "Back from ApplyStatus.")
Return 0
end function

public function integer uf_applystatus (string asproject, string aspath);/*
 - Select Staged records
 
 - Scroll through records
   - Check for Shipment
	 - Check for duplicate status
	 - Insert into Shipment_Status
	 - Update Shipment
*/
Datastore	ldsSI1, ldsSI2, ldsSI4, ldsSI5, ldsShipStat, ldsShipment

string ls_sql_1, ls_sql_4, ls_sql_5, ls_sql_ship, ls_where, lsShipment, lsGroup, lsTrans, lsShipNo, lsShipNo_Prev
string lsStatus, lsStatusMod, lsTimeZone, lsCarrier, lsProNo, lsCity, lsState, lsCountryCd
//RecordType 5:
string lsSvcLvl, lsPODName, lsWgtUOM, lsWgtQual, lsCtnCnt, lsWgt, lsOSD

any laShipment

long llRowCount_1, llRowPos_1, llRowCount_4, llRowPos_4, llRowCount_5, llCurRow, llRowCount_Ship, llLine

integer liRC, liCount

DateTime ldStatusDate, ldTempDate

Boolean lbDelivered // 05/05/06 - now applying all status to shipment (but not over-writing a delivery status)
String lsPrevStatusCode, lsLastStatusCode
DateTime ldPrevStatusDate, ldLastStatusDate
				
ldsSI1 = Create u_ds_datastore
ldsSI1.dataobject = 'd_status_import_1'
ldsSI1.SetTransObject(SQLCA)
ls_sql_1 = ldsSI1.GetSQLSelect()

ldsSI4 = Create u_ds_datastore
ldsSI4.dataobject = 'd_status_import_4'
ldsSI4.SetTransObject(SQLCA)
ls_sql_4 = ldsSI4.GetSQLSelect()

ldsSI5 = Create u_ds_datastore
ldsSI5.dataobject = 'd_status_import_5'
ldsSI5.SetTransObject(SQLCA)
ls_sql_5 = ldsSI5.GetSQLSelect()

ldsShipment = Create u_ds_datastore
ldsShipment.dataobject = 'd_Shipment'
ldsShipment.SetTransObject(SQLCA)
ls_sql_Ship = ldsShipment.GetSQLSelect()

ldsShipStat = Create u_ds_datastore
ldsShipStat.dataobject = 'd_shipment_status'
ldsShipStat.SetTransObject(SQLCA)

/*TEMPO - May want to make this an argument (and pass 1 from EDI, and X from Client)
          ( - OR - pass the actual SI1_Seq from the Client) */
ls_where = 'where sirs_id=1'  
ldsSI1.SetSqlSelect(ls_sql_1 + ls_where)

//Scroll through unprocessed records in staging tables...
llRowCount_1 = ldsSI1.Retrieve()
If llRowCount_1 > 0 Then
  //messagebox ("ldsSI1", "Row Count: " + string(llRowCount_1))
	For llRowPos_1 = 1 to llRowCount_1
		//check if shipment exists...
		//7/9/04 laShipment = ldsSI1.GetITemString(llRowPos_1, 'SI1_ShpperRefNbr')
		laShipment = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr')
		lsGroup = ldsSI1.GetItemString(llRowPos_1, 'SI1_GroupControlNbr')  //moved from below
		lsTrans = ldsSI1.GetItemString(llRowPos_1, 'SI1_TransactionControlNbr')  //moved from below
		if isnull(laShipment) then
			//messagebox ("TEMPO-ApplyStatus", "Null CarrierRefNbr")
		else
			lsShipment = laShipment //tempo - necessary? (needed it to resolve nulls which shouldn't happen now that 'ShpperRefNbr' is fixed)
			//liRC = uf_ShipmentExists (asproject, lsShipment)
			ls_where = "where project_id = '" + asProject + "' and awb_bol_no = '" + lsShipment + "'"
			//messagebox ("TEMPO", ls_where)
			ldsShipment.SetSqlSelect(ls_sql_Ship + ls_where)			
			llRowCount_Ship = ldsShipment.Retrieve()
  			//messagebox ("ldsShipment", "Row Count: " + string(llRowCount_Ship))
			If llRowCount_Ship <= 0 Then
				//Shipment doesn't exist. Reject and set 'Shipment Doesn't Exist' message
				//TEMPO! - set SIRS_ID to ?
				//messagebox ("TEMPO-ApplyStatus", "Shipment Doesn't exist: " + lsShipment + ".")
				///messagebox ("TEMPO - ApplyStatus", "Update Staging tables as appropriate (24, Shipment doesn't exist)")
				/* 7/9/04 - added update to staging table. Still haven't applied a status
				   indicative of why the status isn't being applied (shipment doesn't exist, data error....) */
				lirc = uf_UpdateStageTable('1', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('2', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('4', lsGroup, lsTrans, 24)
				lirc = uf_UpdateStageTable('5', lsGroup, lsTrans, 24)
			else
				//TEMPO - What if more than 1 shipment meets criteria??
				lsShipNo = ldsShipment.GetItemString(1, 'Ship_No')
				
				///messagebox ("TEMPO-ApplyStatus", "Shipment DOES exist: " + lsShipment + ", ShipNo: " +lsShipNo + ".")
				
				//lsGroup = ldsSI1.GetItemString(llRowPos_1, 'SI1_GroupControlNbr')
				//lsTrans = ldsSI1.GetItemString(llRowPos_1, 'SI1_TransactionControlNbr') 
				lsCarrier = ldsSI1.GetItemString(llRowPos_1, 'SI1_Carrier')
				//7/9/04 lsProNo = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr')
				lsProNo = ldsSI1.GetItemString(llRowPos_1, 'SI1_CarrierRefNbr') // dts 3/24/06 - not sure why this was turned off....
				ls_where = "where SIRS_ID=1 and SI4_GroupControlNbr='" + lsGroup + "' and SI4_TransactionControlNbr = '" + lsTrans + "'"
				//messagebox ("where", ls_where)
				ldsSI4.SetSqlSelect(ls_sql_4 + ls_where)		
				llRowCount_4 = ldsSI4.Retrieve()
				//messagebox ("ldsSI4", "Row Count: " + string(llRowCount_4))
				//scroll through status records....

				/* 050506 - Look up ord_status for shipment and see if it's 'Delivered' (set lbDelivered to True)
						If it is, don't allow a status code/date change
						Make sure that while we're looping, if one is Delivered don't let a later
						one change status(set lbDelivered to True)
				*/
				lsPrevStatusCode = ldsShipment.GetItemString(1, 'ord_status')
				if upper(left(lsLastStatusCode, 1)) = 'D' then lbDelivered = true
				ldPrevStatusDate = ldsShipment.GetItemDateTime(1, 'Ord_Status_Date')
				if isnull(ldLastStatusDate) then 
					ldPrevStatusDate = datetime("1950-01-01")
				end if
				for llRowPos_4 = 1 to llRowCount_4
					lsStatus = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCode') 
					//TEMPO! lsStatusMod = ldsSI4.GetITemString(llRowPos_4, 'SI4_Status_Modifier') 					
					lsTimeZone = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusTimeZone')
					ldStatusDate = ldsSI4.GetItemDateTime(llRowPos_4, 'SI4_StatusDate')
					
					//050506
					if ldStatusDate > ldLastStatusDate and not lbDelivered then
						ldLastStatusDate = ldStatusDate
						lsLastStatusCode = lsStatus
					end if
					
					lsCity = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCity')
					lsState = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusState')
					lsCountryCd = ldsSI4.GetItemString(llRowPos_4, 'SI4_StatusCountry')
					//messagebox ("TEMPO - ApplyStatus", "StatusCode: " + lsStatus +", StatusModifier: " +lsStatusMod)
					//check if status code is valid...
					liRC = uf_ValidStatusCode(lsStatus)
/*  DTS 10/20/04 - Why are si4_statuscode = '' records being saved?
	 Should we stop them before they get this far (not let them in staging tables? */
					if liRC = -1 then //Invalid Status Code
						//status code not valid. Reject and set 'Invalid Status Code' message
						//messagebox ("TEMPO - ApplyStatus", "Invalid StatusCode: " + lsStatus +", StatusModifier: " +lsStatusMod)
					else
						//Save the status record...
						/*Check For duplicate.... (what should we do? Update? Delete/Insert? ...)
						  - don't check for dup. Just insert new status record. Check date for possible update to Shipment/DM tables
							-  What if there's a file problem and the same status records get submitted indefinitely?
							-   - then we may want to check duplicates (StatusCode/StatusDate)
						*/

						/*get the max 'ship_status_line_no' for given ship_no (should do only once per Ship_No)...
						   WHY IS 'ship_status_line_no' a char field?!?! ... 
							 - have to use 'convert' to have 'max' treat values as numbers (otherwise, 2 is greater than 10)
							 - will have trouble if something other than number is ever used!		*/
						if lsShipNo <> lsShipNo_Prev then //are these sorted by ShipNo?
							select max(convert(numeric, ship_status_line_no)) into :llLine from shipment_status where ship_no = :lsShipNo;
							lsShipNo_Prev = lsShipNo
							if isnull(llLine) then 
								llLine = 1
							else
								llLine += 1
							end if
  						//messagebox("TEMPO - ApplyStatus", "Max ship_status_line_no: " + string(llMaxLine))
						else
							llLine += 1
						end if
						
						//messagebox ("TEMPO-ApplyStatus", "Inserting row into ldsShipStat... ShipNo: " +lsShipNo +", lsStatus: " +lsStatus + "LineNo: " + string(llMaxLine + llRowPos_4) + ", Max ship_status_line_no: " + string(llMaxLine) + ", RowPos:" + string(llRowPos_4) )
						llCurRow = ldsShipStat.InsertRow(0)
						//ldsShipStat.SetItem(llCurRow, 'Ship_No', llBatchSeq)
						//messagebox ("TEMPO", "llcurRow: " + string(llCurRow))
						ldsShipStat.SetItem(llCurRow, 'Ship_No', lsShipNo)
						//ldsShipStat.SetItem(llCurRow, 'Ship_Status_line_no', string(llMaxLine + llRowPos_4)) 
						ldsShipStat.SetItem(llCurRow, 'Ship_Status_line_no', string(llLine)) 
						ldsShipStat.SetItem(llCurRow, 'Status_Code', lsStatus)
						//ldsShipStat.SetItem(llCurRow, 'Status_Modifier', lsStatusMod)
						ldsShipStat.SetItem(llCurRow, 'Status_Date', ldStatusDate)
						ldsShipStat.SetItem(llCurRow, 'Status_Source', lsCarrier)
						//7/9/04 ldsShipStat.SetItem(llCurRow, 'Pro_No', lsProNo)
						ldsShipStat.SetItem(llCurRow, 'Pro_No', lsProNo) // dts 3/24/06 - not sure why this was turned off....
						ldsShipStat.SetItem(llCurRow, 'City', lsCity)
						ldsShipStat.SetItem(llCurRow, 'State', lsState)
						ldsShipStat.SetItem(llCurRow, 'ISO_Country_Code', lsCountryCd)
						ldsShipStat.SetItem(llCurRow, 'Last_User', 'SIMSFP')
						ldsShipStat.SetItem(llCurRow, 'Last_Update', now())
						ldsShipStat.SetItem(llCurRow, 'Create_User', 'SIMSFP')
						ldsShipStat.SetItem(llCurRow, 'Create_User_date', now())
						ldsShipStat.SetItem(llCurRow, 'time_zone_id', lsTimeZone)
						liRC = ldsShipStat.Update()
						commit; //tempo(?) - for testing
						
						if ldStatusDate > datetime('1950-01-01') then //valid status date?
							//messagebox ("TEMPO", "StatusDate: " + string(ldStatusDate))

							/* applying status:
							- scroll thru inbound status records
							- keep track which is the latest (keep date and status code)
							- compare latest to currrent status on shipment
							- if it's a later status, update shipment
							  - make sure you don't over-write a 'Delivery' status.
							*/							
							
								choose case lsStatus 
									case 'D', 'D1'
										lbDelivered = True
										// Put this (update of shipment table) in a subroutine?...
										ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATA')
										if isnull(ldTempDate) or ldStatusDate < ldTempDate then
											//messagebox ("TEMP", "StatusDate ==> Freight_ATA: " + string(ldStatusDate))
											ldsShipment.SetItem(1, 'Freight_ATA', ldStatusDate)
											/* dts - 3/23/06 - now setting Ord_Status field (and date) upon delivery.
														Date should be set for other status codes (that affect ord_status) as well. */
											//050506 ldsShipment.SetItem(1, 'Ord_status', 'D') //Do we want to set Ord_Status on Order(s) also?  
											//050506 ldsShipment.SetItem(1, 'Ord_Status_Date', ldStatusDate)
										else
											//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
										end if
									case 'AD', 'AG', 'AJ'
										//AD - Delivery Appointment Date and Time
										//AG - Estimated Delivery
										//AJ - Tendered for Delivery 										
										ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ETA')
										if isnull(ldTempDate) or ldStatusDate < ldTempDate then
											//messagebox ("TEMP", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
											ldsShipment.SetItem(1, 'Freight_ETA', ldStatusDate)
										else
											//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
										end if
										/*
										if lsStatus = 'AG' then
											ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATD')
											if isnull(ldTempDate) or ldStatusDate < ldTempDate then
												//messagebox ("TEMP", "StatusDate ==> Freight_ATD: " + string(ldStatusDate))
												ldsShipment.SetItem(1, 'Freight_ATD', ldStatusDate)
											else
												//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
											end if
										end if
										*/
									case 'AF', 'P1' // dts added 05/05/06
										//AF - Departed Pick-up Location
										//P1 - Departed Origin
										ldTempDate = ldsShipment.GetItemDateTime(1, 'Freight_ATD')
										if isnull(ldTempDate) or ldStatusDate < ldTempDate then
											//messagebox ("TEMP", "StatusDate ==> Freight_ETA: " + string(ldStatusDate))
											ldsShipment.SetItem(1, 'Freight_ATD', ldStatusDate)
										else
											//messagebox ("TEMP", "TempDate: " + string(ldTempDate) + "StatusDate: " + string(ldStatusDate))
										end if
									case else
										//
								end choose
							//liRC = ldsShipment.Update()
							//commit; //tempo - where do we want the commit? (once per status rec?, once per Shipment?)
						else
							//messagebox ("TEMP", "Null/Invalid StatusDate: " + string(ldStatusDate))
							//Should we save without a Status Date?  What good would that be?
						end if
					end if
				next // Next SI4 Record
				//050506 now setting status for shipment to Latest status (not over-writing delivery)
				if lsPrevStatusCode <> lsLastStatusCode and upper(left(lsPrevStatusCode,1)) <> 'D' then //what if it's the same StatusCode but a new date (like a later estimated delivery or delivery appt.?)
					ldsShipment.SetItem(1, 'Ord_status', lsLastStatusCode) //Do we want to set Ord_Status on Order(s) also?  
					ldsShipment.SetItem(1, 'Ord_Status_Date', ldLastStatusDate)
				end if
				
				//process record type 5 (OSD, POD, wgts...)
				ls_where = "where SIRS_ID=1 and SI5_GroupControlNbr='" + lsGroup + "' and SI5_TransactionControlNbr = '" + lsTrans + "'"
				//messagebox ("where", ls_where)
				ldsSI5.SetSqlSelect(ls_sql_5 + ls_where)		
				llRowCount_5 = ldsSI5.Retrieve()
				//messagebox ("ldsSI5", "Row Count: " + string(llRowCount_5))
				//scroll through status records....
				If llRowCount_5 > 0 Then
					lsSvcLvl = ldsSI5.GetITemString(1, 'SI5_ShipmentServiceLevel')
					lsPODName = ldsSI5.GetITemString(1, 'si5_signature')
					lsCtnCnt = ldsSI5.GetITemString(1, 'si5_ShipmentLadingQuantity')
					lsWgt = ldsSI5.GetITemString(1, 'si5_ShipmentWeight') //TEMPO!! Decimal place??
					lsWgtUOM = ldsSI5.GetITemString(1, 'si5_ShipmentWeightUOM')
					lsWgtQual = ldsSI5.GetITemString(1, 'si5_ShipmentWeightQualifier')
					lsOSD = ldsSI5.GetITemString(1, 'si5_OSDFlag')
					//dts - 10/21/04 - added null string test in following....
					if not isnull(lsPODName) and lsPODName <> ''  then ldsShipment.SetItem(1, 'POD_Name', lsPODName)
					if not isnull(lsCtnCnt) then ldsShipment.SetItem(1, 'Ctn_Cnt', long(lsCtnCnt))
					// 8/4/04 dts - if not isnull(lsWgt) then ldsShipment.SetItem(1, 'Weight', double(lsWgt))
					if not isnull(lsWgt) and lsWgt <> ''  then ldsShipment.SetItem(1, 'Weight', double(lsWgt)/1000)
					if not isnull(lsWgtUOM) and lsWgtUOM <> ''  then ldsShipment.SetItem(1, 'Weight_UOM', lsWgtUOM)
					if not isnull(lsWgtQual) and lsWgtQual <> '' then ldsShipment.SetItem(1, 'Weight_Qualifier', lsWgtQual)
					If Not (IsNull(lsOSD) or lsOSD="") Then
						//bOSD = True
						//messagebox("TEMPO", "OSD:" + ldsSI5.GetITemString(1, 'si5_OSDFlag') + ".")
						///messagebox("TEMPO", "OSD:" + lsOSD + ".")
						ldsShipment.SetItem(1, 'OSD_Flag', 'Y')
					End If
			  //Else
			  //  lsSvcLvl = "AI" //TEMPO - what should default Service Level be?
				End If //Record Type 5 present
				if isnull(lsSvcLvl) then lsSvcLvl = 'AI' //TEMPO - what should default Service Level be?
				select count(service_level) into :liCount from Service_Level
				where project_id = :asProject and carrier_code = :lsCarrier and service_level = :lsSvcLvl;
				if liCount >0 then ldsShipment.SetItem(1, 'Service_Level', lsSvcLvl) 
				
				ldsShipment.SetItem(1, 'Last_User', 'SIMSFP')
				ldsShipment.SetItem(1, 'Last_Update', now())

				liRC = ldsShipment.Update()
				commit; //tempo - where do we want the commit? (once per status rec?, once per Shipment?)
				
				//update SIRS_ID for each record type (based on liRC?  Based on some other variable (reflecting import status)?)
				//TEMPO! - If success, set to 25, if failure, to 24(???)
				///messagebox ("TEMPO - ApplyStatus", "Update Staging tables as appropriate (25 success, other?)")
				lirc = uf_UpdateStageTable('1', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('2', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('4', lsGroup, lsTrans, 25)
				lirc = uf_UpdateStageTable('5', lsGroup, lsTrans, 25)
				//ls_where = "where SI4_GroupControlNbr='" + lsGroup + "' and SI4_TransactionControlNbr = '" + lsTrans + "'"
			end if //liRC = -1 (Shipment Exists)
		end if //Null Shipment
	Next // Next SI1 record
	
else
	///messagebox("ApplyStatus", "No records found!") //TEMPO!!
End If


return 0

end function

public function integer uf_process_inventory_snapshot ();//
// uf_process_inventory_snapshot
// Create the NCR Inventory Snapshot File
//
datastore ldsOut
long rows,insertrow
int rowIndex
datetime arrivalDate, earliestArrivalDate, latestReceiptDate
string theFilename
string pipe 
string skuBreak = '*'
string thesku
decimal theowner
string outputline
string outputline2
string whCode
string msg
string theSupplierNo
string thePlantName
string lsTemp

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started NCR Inventory Snapshot'
FileWrite(gilogFileNo,msg)
/*

The file name will be suphiv01_[plant name3]_[date, format = yymmdd], ie. suphiv01_budapest3_080318 
Please note this must be sent in lower case letters only. 
The plant name is specific for each supplier hub located in that city so for the Nippon supplier hub the designation is budapest 3.

Using the wh_code from project for this.

*/
string aProject
aProject = getProject()
whCode = getWarehouse()
pipe = '|'		 // pipe delimited file

theFilename =  "suphiv01_columbus_" +string(today(),"yymmdd")  + ".dat"
// Create the outbound datastore
ldsOut = f_datastoreFactory( 'd_edi_generic_out' )

// create a datastore to retrieve content summary
idsNCRContentSummary = f_datastoreFactory( 'd_ncr_content_summary' )
rows= idsNCRContentSummary.retrieve(aProject,whCode )
if rows <= 0 then  return 0 // nothing to see here...move along
/*

The OLDEST_RECEIPT_DATE is the first date the item was received in the HUB and is still on hand.$$HEX2$$a0002000$$ENDHEX$$
Once the entire quantity of the First Batch has been shipped, then the Oldest Receipt Date becomes 
the Date Received of the Second Batch of that same item.$$HEX2$$a0002000$$ENDHEX$$
This is using the FIFO (First In First Out) inventory concept.$$HEX2$$a0002000$$ENDHEX$$

The datastore is sorted sku, ro_no.arrival date asc.

*/

// Changed date columns to be oldest complete date and newest complete date.  Both values are returned 
// from the datawindow - no longer call function uf_getEarliestArrivalDate to get the values.  03/29/11


//MAS - 6/6/11 - change request P.Tibbits
//P. Tibbits - change supplier_owned_flag to $$HEX1$$1c20$$ENDHEX$$Y$$HEX4$$1d20200013202000$$ENDHEX$$everything in our(NCR) possession will be supplier owned
for rowIndex = 1 to rows
	
	// set supplier_owned_flag to 'Y' for all rows - added line below and commented code below
	If upper(theProject) = 'NCR' Then
		idsNCRContentSummary.object.supplier_owned_flag[rowIndex] = "Y"
	End If
	//*************************************************
	//MStuart - 6/6/11 - commented
	/*
	idsNCRContentSummary.object.supplier_owned_flag[rowIndex] = "N"
	if  idsNCRContentSummary.object.owner_cd[rowIndex] = 'NCR' then 
		idsNCRContentSummary.object.supplier_owned_flag[rowIndex] = "Y"
	end if
	**********end of MStuiart commented**************/
	
	
	
	theSku = idsNCRContentSummary.object.sku[rowIndex]
	thesupplier = idsNCRContentSummary.object.supp_code[rowIndex]
	
	// get the supplier number
	
	//BCR 16-FEB-2012: L12P042 - Customer request to move order logic from UF1 to UF2...
	theSupplierNo = ''
//	select user_field1 into :theSupplierNo
	select user_field2 into :theSupplierNo
	from supplier
	where supp_code = :theSupplier;
	if len(theSupplierNo) = 0 or isNull(theSupplierNo) then theSupplierNo = theSupplier
	theowner = idsNCRContentSummary.object.owner_id[rowIndex]
	// 03/29/2011 - Changed to just use complete date.
//	if theSku <> skuBreak then
//		// set the oldest receipt date to use
//		arrivalDate =	idsNCRContentSummary.object.arrival_date[rowIndex]	
//		earliestArrivalDate = arrivalDate
//		if isdate(string(date(arrivalDate))) then
//			earliestArrivalDate = uf_getEarliestArrivalDate( theSku,theSupplier,theOwner,arrivalDate)
//			if  isDate(string(date(earliestArrivalDate))) = false then
//				earliestArrivalDate = arrivalDate
//			end if
//		end if	
//		skuBreak = theSku
//		// get the latestReceiptDate
//		select max(rm.Arrival_date)
//		into :latestReceiptDate
//		from receive_master rm, receive_detail rd
//		where rm.ro_no = rd.ro_no
//		and rd.sku = :theSku
//		and rd.supp_code = :thesupplier
//		and rd.owner_id = :theOwner
//		and rm.project_id = :theProject;
//	end if
	// Arival Date already has the correct value - don't do this step  03/30/11
	//idsNCRContentSummary.object.arrival_date[rowIndex] = earliestArrivalDate
	// Create the outputline
	lsTemp = string(idsNCRContentSummary.object.diu_date[rowIndex],"yyyy-mm-dd")
	if isNull(lsTemp) then lsTemp = string(today(),"yyyy-mm-dd")
	outputline = trim(lsTemp) + pipe
	outputline += trim(idsNCRContentSummary.object.action[rowIndex] ) + pipe	
	outputline += trim(idsNCRContentSummary.object.instance_id[rowIndex]) + pipe
	outputline += trim(idsNCRContentSummary.object.hub_name[rowIndex]) + pipe
	// plant name is warehouse code.  If the warehouse code is NCR-COLUM then send 'COLUMBUS'
	thePlantName = getWarehouse()
	if Upper(thePlantName) = 'NCR-COLUM' then	thePlantName = 'COLUMBUS'
	outputline += trim( thePlantName) + pipe

	lsTemp = idsNCRContentSummary.object.sku[rowIndex]
	if isNull(lsTemp) then lsTemp =""
	outputline += trim( lsTemp ) + pipe
	
	lsTemp = trim(string(Integer(idsNCRContentSummary.object.avail_qty[rowIndex])))
	if isNull(lsTemp) then lsTemp =""
	outputline += trim( lsTemp) + pipe

	// Changed to use oldest complete date and newest complete date - 03/29/2011  - oldest
	// complete date is still called Arrival_Date on the datawindow
	earliestArrivalDate = idsNCRContentSummary.object.arrival_date[rowIndex]
	latestReceiptDate = idsNCRContentSummary.object.newest_receipt_date[rowIndex]

	outputline += trim(string(earliestArrivalDate,"yyyy-mm-dd")) + pipe	
	outputline += trim(string(latestReceiptDate,"yyyy-mm-dd")) + pipe	
	outputline += trim(theSupplierNo ) + pipe
	outputline += idsNCRContentSummary.object.supplier_owned_flag[rowIndex] + pipe
	// 255 character limit reached
	//outputline2 = left(idsNCRContentSummary.object.country_of_origin[rowIndex] + space(25),25) + pipe
	outputline2 = 'COL' 
	
	// insert an output record
	insertRow = ldsOut.insertrow(0)
	ldsOut.object.project_id[insertRow] = getproject()
	ldsOut.object.edi_batch_Seq_no[insertRow] = 1
	ldsOut.object.line_seq_no[insertRow] = rowIndex
	ldsOut.object.file_name[insertRow] = theFileName
	ldsOut.object.batch_data[insertRow]=outputline
	ldsOut.object.batch_data_2[insertRow]=outputline2
	ldsOut.accepttext()
next
msg = "Writing Outbound File: " + theFileName
FileWrite(gilogFileNo,msg)
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,getProject())
msg = 'NCR Inventory Snapshot Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)

return 0

end function

public subroutine setproject (string _project);theProject = _project

end subroutine

public function string getproject ();return theProject

end function

public subroutine broadcast (string _message);//
// broadcast a message to the sweeper and the log
//
FileWrite(gilogFileNo,_message)
gu_nvo_process_files.uf_write_log(_message) /*display msg to screen*/

end subroutine

public subroutine uf_write_outline (ref datastore _dsout, decimal _batchseqnum, string _outputline, long _insertrow);//
// int = uf_write_outline( dsOut _batchSeqNum, _outputline)
//

ilineSeq += 1
_dsout.object.project_id[_insertRow] = getproject()
_dsout.object.edi_batch_seq_no[_insertRow] = _batchseqnum
_dsout.object.line_seq_no[_insertRow] = ilineSeq
_dsout.object.batch_data[_insertRow] = _outputline
_dsout.accepttext()

return 

end subroutine

public function integer uf_writeerror (string aserrormsg);
//Write a message to the error file


//Create a new file if not already exists
If  Not FileExists(GSerrorfileName) Then
	giErrorFileNo = FileOpen(gsErrorFileNAME,LineMode!,Write!,LockWrite!)
End If

FileWrite(giErrorFileNo,asErrorMsg)

Return 0


end function

public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments);String	lsDistribList,	lsTemp, 	lsOutPut, lsReturn, lsCommand, lsAttachments, lsSubject
			
Long		llArrayPos

OleObject wsh
integer  li_rc

CONSTANT integer MINIMIZED = 2
CONSTANT boolean WAIT = TRUE


// 03/05 - PCONKL - Changed to use BLAT batch commands instead of going through Outlook.


//Get the Distrib LIst, replace any semi colons with commas

Choose Case Upper(AsDistriblist)
		
	Case 'SYSTEM' /*send message to the system distribution List*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","SYSEMAIL","")
	Case 'CUSTVAL' /*Send a customer validation message - including error files*/
		lsDistribList = ProfileString(gsinifile,asProject,"CUSTEMAIL","")
	Case 'FILEXFER' /*Send a msg to file transfer error list*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","FilexferMAIL","")
	Case Else /*Custom User or list passed in parm*/
		If Pos(AsDistriblist,'@') > 0 Then
			lsDistribList = AsDistribList
		Else
			lsDistribList = ProfileString(gsinifile,asProject,AsDistriblist,"")
		End If
		
End Choose

Do While Pos(lsDistribList,';') > 0
	lsDistribList = Replace(lsDistribList,Pos(lsDistribList,';'),1,',')
Loop

If isNull(lsDistribList) or lsDistribList = '' or lsDistribList = "No Email" Then
	lsOutput = "          - No entries in distribution list for this project. Email notification not sent."
	FileWrite(gilogFileNo,lsOutput)
	Broadcast(lsOutput) /*display msg to screen*/
	
	Return 0
End If

//Create the command line prompt
lsCommand = "blat -"

//Add From
lsCommand += ' -f "SIMS Sweeper SA <simssweeperSA@xpo.com>" '

//Add Subject
lsSubject = assubject + ' (' + gsEnvironment + '/' + asProject +  ')'
lsCommand += ' -s "' + lsSubject + '"'

//add dist list
lsCommand += ' -t "' + lsDistribList + '"'

//supress + servername
lsCommand += " -q -noh2 -server mailhost.cnf.com "

//Log File
lsCommand += " -log " + isEmailLogFile + " -timestamp "

//Body of Message
lsCommand += ' -body "' + asText + '"'

//Any attachments...
lsAttachments = asAttachments

/* 12/14/05 - commented out for check-in....
/* dts - create zip file here?
	Need some trigger (indicator?) to decide if we're zipping?
	Should we ALWAYS zip?
	Zip based on some size threshold?
	 - ?Do we want to scroll through list and add up file sizes? (i = FileLength(fn))
	Always zip if there are mulitple files?
	Zip data file but not ERR file?
	Some combination of the above (configurable?)?
	How will this impact customers?
	 - Does anybody automate processing e-mailed files?
	 
*/
string lsZipList, lsZipFile

//TEMP!!! ??? Need some trigger (indicator) to decide if we're zipping???
lsZipList = lsAttachments
//use the first filename (without extension) for zip file name...
//  ??? What if path has a '.'  ???
lsZipFile = left(lsZipList, Pos(lsZipList, '.') - 1) + '.zip'
Do While Pos(lsZipList,',') > 0
	// want list of attachments separated by space for zipping...
	lsZipList = Replace(lsZipList, Pos(lsZipList, ','), 1, ' ')	
Loop

if lsZipList > '' then
	li_rc = uf_zipper(lsZipList, lsZipFile)
	lsAttachments = lsZipFile
else
	Do While Pos(lsAttachments,';') > 0
		lsAttachments = Replace(lsAttachments,Pos(lsAttachments,';'),1,',')	
	Loop
end if
*/

Do While Pos(lsAttachments,';') > 0
	lsAttachments = Replace(lsAttachments,Pos(lsAttachments,';'),1,',')	
Loop

If lsAttachments > '' Then
	lsCommand += " -attach " + lsAttachments
End If


//Send the message
//TAM Send the message in sequence instead of parallel
//wsh = CREATE OleObject
//li_rc = wsh.ConnectToNewObject( "WScript.Shell" )
//li_rc = wsh.Run(lsCommand , Minimized, WAIT)

Run(lsCommand, minimized!)
sleep(10)

lsOutput = "          - Mail sent to: (" + asDistribList + "): " + lsDistribList
FileWrite(gilogFileNo,lsOutput)
Broadcast(lsOutput) /*display msg to screen*/


Return 0
end function

public function integer uf_process_855 (string thedono);//
//  Process NCR Purchase Order Acknowledgment
//
//  int = uf_process_855( string theDoNo, string InvAckStatus )
//
/*
	requirements doc: KRG_KRG855V4010_ERP.rtf
	
*/
constant string dateformat = 'YYYYMMDD'
constant string PurposCode = '00'
constant string AcknowledgmentType = 'AC'
constant string theTitle = 'NCR (855) Purchase Order Acknowledgment'


string dono  
string donoAssignedDate // the date assigned by the purchaser to purchase order
string donoSenderDate // is the date assigned by the sender to the acknowledgment.
string donoReleaseNo
string donoPromiseDate
string InvAckStatus = 'N' // default to normal
string lsFinish
string msg
string lsOutString
string theFilename
string sku
string supplier
string temp
decimal ldAllocateQty


// Get data for....
string thePO // purchase order number
string releaseNo // Release number
string requestRefNo // Request Reference Number
// End get data for

long RowCount
long DetailRowCount
long RowIndex
long InsertRow
int	liRc
decimal ldBatchSeq

Datastore	ldsOut
Datastore 	ldsDO
Datastore	ldsDODetail
Datastore	ldsInventoryCheck

// begin
lsFinish = "Ending " + theTitle
// broadcast writes to the log and the sweeper window.
broadcast("")
broadcast( Fill('*',40))
broadcast('Starting ' + theTitle)

// Create the outbound datastore
ldsOut 					= f_datastoreFactory( 'd_edi_generic_out' )
ldsDO 					= f_datastoreFactory('d_ncr_delivery_master')
ldsDODetail  			= f_datastoreFactory('d_ncr_delivery_detail')
ldsInventoryCheck  	= f_datastoreFactory('d_ncr_inv_check_avail')

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(getProject(),'EDI_inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	broadcast( "   ***Unable to retrive next available sequence number for " + theTitle)
	broadcast( " Batch Sequence Returned: " + string( ldBatchSeq ) )
	broadcast(lsfinish)
	broadcast( fill("*",40))
	Return Failure
End If

broadcast("Retrieving Data")

RowCount = ldsDO.Retrieve(getproject(),theDoNo ) 
choose case RowCount
	case is < 0
		broadcast("Error Retrieving " + theTitle + " data." )
		broadcast("Error Returned: " + string(RowCount) )
		return failure
	case 0
		broadcast( String(RowCount) + ' Header Rows were retrieved for processing.')
		broadcast( "No File Created. Exiting")
		broadcast( lsFinish)
		broadcast( fill("*",40))
		return success
end Choose

DetailRowCount = ldsDODetail.Retrieve(theDoNo ) 
choose case DetailRowCount
	case is < 0
		broadcast("Error Retrieving " + theTitle + " data." )
		broadcast("Error Returned: " + string(DetailRowCount) )
		return failure
	case 0
		broadcast( String(DetailRowCount) + ' Detail Rows were retrieved for processing.')
		broadcast( "No File Created. Exiting")
		broadcast( lsFinish)
		broadcast( fill("*",40))
		return success
end Choose	
broadcast( String(DetailRowCount) + ' Detail Rows were retrieved for order: ' + theDono)
//
// Wrtie the Beginning segment
//
thePO = ldsDODetail.object.user_field1[1]
requestRefNo = ldsDODetail.object.user_field2[1]	
donoPromiseDate = string( ldsDO.object.schedule_date[1] , 'yyyymmdd')
theFilename = '855' + left(String(ldBatchSeq) + fill('0',9),9) + '.dat'
insertRow = ldsOut.insertRow(0)
ldsOut.object.file_name[insertRow] = theFilename

lsOutstring = '00' // transaction set purpose code
lsOutstring +='AC' // acknowledgement Type
lsOutstring += left( thePO +fill(" ",22), 22 ) // purchase order number
lsOutstring += string(today(),"YYYYMMDD") // purchase order date ( system date)
lsOutstring += left( releaseNo + fill(" ",30),30 ) // release number
lsOutstring += left( requestRefNo + fill(" ",45),45 ) // request ref number
lsOutstring += string(today(),"YYYYMMDD") // today
uf_write_outline( ldsOut, ldBatchSeq, lsOutstring,insertRow)
// End of Beginning segment

For RowIndex = 1 to DetailRowCount
	// perform inventory check here.

	sku = ldsDODetail.object.sku[RowIndex]
	supplier = ldsDODetail.object.supp_code[RowIndex]	
	InvAckStatus = 'IH'
	ldAllocateQty = 0
	if ldsInventoryCheck.retrieve(getProject(),sku,supplier) > 0 then
		if ldsInventoryCheck.object.avail_qty[1] >= ldsDODetail.object.req_qty[RowIndex] then
			InvAckStatus = 'IA'
			ldAllocateQty =  ldsDODetail.object.req_qty[RowIndex]			
		end if
	end if
	// segment PO1	
	InsertRow = ldsOut.insertRow(0)
	temp = left( requestRefNo, len(requestRefNo) -3)
	lsOutString =  left(string(integer(right(temp,3)))+ fill(" ",20),20 ) 
	lsOutString +=  left(  string( ldsDODetail.object.req_qty[RowIndex])+ fill(" ",15),15 ) 	
	lsOutString +=  'EA'
	lsOutString +=  'BP'	
	lsOutString +=  left(  ldsDODetail.object.sku[RowIndex]  + fill(" ",48),48 )
	uf_write_outline( ldsOut, ldBatchSeq, lsOutstring,insertRow)
	// segment ACK	
	InsertRow = ldsOut.insertRow(0)
	lsOutString = InvAckStatus
	lsOutString +=  left(  string( ldsDODetail.object.req_qty[RowIndex])+ fill(" ",15),15 ) 	
	lsOutString +=  'EA'
	lsOutString +=  '083'	
	lsOutString +=	donoPromiseDate
	String(Integer(right(requestRefNo,3)))
	lsOutString +=  left(  String(Integer(right(requestRefNo,3))) + fill(" ",45),45 )
	uf_write_outline( ldsOut, ldBatchSeq, lsOutstring,insertRow)	
next
		
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,getProject())

broadcast( lsFinish)
broadcast( fill("*",40))
return success

end function

public function integer uf_process_do (string aspath, string asproject);// Process NCE Delivery Order

Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDOAddress, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText,	 lsSKU,	lsRecType,	&
				lsSoldToAddr1, lsSoldToADdr2, lsSoldToADdr3,  lsSoldToAddr4, lsSoldToStreet,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, lsDate, ls_invoice_no, ls_Note_Type, &
				ls_search,lsNotes,ls_temp,SupplierNumber, temp

Integer		liFileNo,liRC, li_line_item_no
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewAddressRow, llNewNotesRow, li_find
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
int               x
			

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_mercator_do_address'
ldsDOAddress.SetTransObject(SQLCA)

//Open the File
broadcast( '      - Opening File for Sales Order Processing: ' + asPath)
liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	broadcast( "-       ***Unable to Open File for Phoenix Processing: " + asPath)
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsRecData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
		
	//Process header & Detail
	lsRecType = Upper(Mid(lsRecData,1,2))
	lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to next Column */	
	
	Choose Case lsRecType
			
		//HEADER RECORD
		Case 'DM' /* Header */
									
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			// Action Code
			
			//	A DELJIT can be updated- the RFF ZZ codes $$HEX1$$1c20$$ENDHEX$$K$$HEX1$$1d20$$ENDHEX$$= Kanban (original), $$HEX1$$1c20$$ENDHEX$$A$$HEX2$$1d202000$$ENDHEX$$= add, $$HEX1$$1c20$$ENDHEX$$C$$HEX1$$1d20$$ENDHEX$$= change.  
// SIT Testing found that....
//	a.	K.  NRC noted that this signifies an original or new order.  Menlo is handling this per NCR latest instructions.
//	b.	A.  NRC noted that this signifies an amendment or change to an existing order.  Menlo is not handling this per NCR latest instructions.  Menlo is processing an A as a new order.  Please modify SIMS to process A as a change or update to existing order.
//	c.	C.  NRC noted that this signifies a cancel of an existing order.  NCR further noted that they should never send us a cancel.  However, if they do, the DELJIT will contain zero quantities.  Please look into this and determine how Menlo would handle a C DELJIT with zero quantities.
			string actionCode
			actionCode = getNextElement(lsRecData)
			choose case UPPER(actionCode)
				case "K"
					actionCode = "A"
				case "A"  
					actionCode = "U"
				case "C"
					actionCode = "D"
			end choose
			
			ldsDOHeader.SetItem(llNewRow,'action_cd', actionCode)	
			// Sims Defaults....
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
			ldsDOHeader.SetITem(llNewRow,'wh_code',getWarehouse()) 
			
//			//BCR 24-AUG-2011: Per Project L11P332, note that the value of Invoice_No is reset (below) after we extract the SupplierNumber...
//			temp = Trim(getNextElement(lsRecData))
//			ldsDOHeader.SetItem(llNewRow,'invoice_no',temp) /*Order Number*/	
			ls_invoice_no = Trim(getNextElement(lsRecData))
			
			temp = Trim(getNextElement(lsRecData))
			ldsDOHeader.SetItem(llNewRow,'ord_date',String(date(temp), "mm/dd/yyyy")) /*Order Date*/
			
			temp = Trim(getNextElement(lsRecData))
			ldsDOHeader.SetItem(llNewRow,'Schedule_Date',String(date(temp), "mm/dd/yyyy")) /*Schedule Date*/
			
			temp = Trim(getNextElement(lsRecData))		
			ldsDOHeader.SetITem(llNewRow,'cust_code', temp)
			
			temp = getNextElement(lsRecData) // skip empty field
			
			temp = Trim(getNextElement(lsRecData))
		     ldsDOHeader.SetItem(llNewRow,'Order_no',temp) /*Cust Order No*/
			 
			temp = getNextElement(lsRecData) // skip empty field
			
			temp = Trim(getNextElement(lsRecData))
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',temp) /*Ship to Name*/
			
			//temp = getNextElement(lsRecData) // skip empty field
			
			temp = Trim(getNextElement(lsRecData))			
			ldsDOHeader.SetItem(llNewRow,'Address_1',temp) /*Ship to Addr 1*/

			for x = 1 to 8
				temp = getNextElement(lsRecData) // skip empty field
			next
			// the supplier code is comming in the header
			// lookup the incomming value in the supplier table user field1
			
			//BCR 16-FEB-2012: L12P042 - Customer request to move order logic from UF1 to UF2...
			SupplierNumber = Trim(getNextElement(lsRecData))
			theSupplier = ''
			Select supp_code into :theSupplier
			from 	supplier
			where project_id = :asProject
//			and user_field1 = :SupplierNumber;
			and user_field2 = :SupplierNumber;
			if len(theSupplier) = 0 then	theSupplier = 'NCR-SUP'
			
			//BCR 24-AUG-2011: Per Project L11P332, note that the value of Invoice_No is reset here after we extract the SupplierNumber...
			ldsDOHeader.SetItem(llNewRow,'invoice_no',ls_invoice_no + "-" + theSupplier) /*Order Number*/
			//END BCR Modification
			
			// End of Record.
			//
			// This is here cause it may change, I'm just sayin'
			//
//			ldsDOHeader.SetItem(llNewRow,'Address_2',Trim(getNextElement(lsRecData))) /*Ship to Addr 2*/
//			ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(getNextElement(lsRecData))) /*Ship to Addr 3*/	
//			ldsDOHeader.SetItem(llNewRow,'City',Trim(getNextElement(lsRecData))) /*Ship to City*/
//			ldsDOHeader.SetItem(llNewRow,'State',Trim(getNextElement(lsRecData))) /*Ship to State 1*/
//			ldsDOHeader.SetItem(llNewRow,'Zip',Trim(getNextElement(lsRecData))) /*Ship to Zip*/
//			ldsDOHeader.SetItem(llNewRow,'Country',Trim(getNextElement(lsRecData))) /*Ship to country*/
//			ldsDOHeader.SetItem(llNewRow,'tel',Trim(getNextElement(lsRecData))) /*Ship to Tel*/

		
		// DETAIL RECORD
		Case 'DD' /*Detail */
									
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
			if len(theSupplier) = 0 then	theSupplier = 'NCR-SUP'
			ldsDODetail.SetITem(llNewRow,'supp_code', theSupplier)
			//
			//ldsDODetail.SetItem(llNewRow,'uom',getNextElement(lsRecData))				
			//
			// From the file
			
//			//BCR 24-AUG-2011: Per Project L11P332, note that the value of Invoice_No is reset (below) by appending the SupplierNumber...
			
//			ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(getNextElement(lsRecData)))		
			ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(getNextElement(lsRecData)) + "-" + theSupplier)
			//END BCR Modification
			
			ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(getNextElement(lsRecData))))
			ldsDODetail.SetItem(llNewRow,'SKU',Trim(getNextElement(lsRecData))) 
			ldsDODetail.SetItem(llNewRow,'quantity',Trim(getNextElement(lsRecData)))
			getNextElement(lsRecData)
			getNextElement(lsRecData)
			ldsDODetail.SetItem(llNewRow,'alternate_sku',Trim(getNextElement(lsRecData)))	// Customer Sku
			getNextElement(lsRecData)		
			
			ldsDODetail.SetItem(llNewRow,'user_field1',Trim(getNextElement(lsRecData)))	
			ldsDODetail.SetItem(llNewRow,'user_field2',Trim(getNextElement(lsRecData)))			
			//ldsDODetail.SetItem(llNewRow,'po_no',Trim(getNextElement(lsRecData)))	
			//ldsDODetail.SetItem(llNewRow,'po_no2',Trim(getNextElement(lsRecData)))
			
			ldsDODetail.SetItem(llNewRow,'uom',Trim(getNextElement(lsRecData)))
			
		case Else /*Invalid rec type */
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
	
	End Choose /*Header or Detail */
	
Next /*file record */

If lbError Then Return failure

//Save Changes
liRC = ldsDOHeader.Update()
If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If
If liRC = 1 Then
	Commit;
Else
	Rollback;
	broadcast(  "       ***System Error!  Unable to Save new SO Records to database ")
	Return failure
End If

Return success
end function

public subroutine setwarehouse ();//Warehouse will have to be defaulted from project master default warehouse

string lsWarehouse
string lsProject

lsProject =  getProject()

Select wh_code into :lsWarehouse
From Project
Where Project_id =:lsProject;

// set the default
theWarehouse = 'NCR-COLUM'
if len(lsWarehouse) > 0 then
	theWarehouse = lswarehouse
end if


end subroutine

public function string getwarehouse ();return theWarehouse
end function

public function string getnextelement (ref string _recdata);//
// string = getNextElement( ref string _recdata )
//
string temp

If Pos(_recdata,'|') > 0 Then
	temp = Left(_recdata,(pos(_recdata,'|') - 1))
Else
	temp = _recdata
End If
_recdata = Right(_recdata,(len(_recdata) - (Len(temp) + 1))) /*strip off to next Column */
			
return temp


end function

public subroutine setwarehouse (string _warehouse);theWarehouse = _warehouse
end subroutine

public function datetime uf_getearliestarrivaldate (string thesku, string thesupplier, decimal theowner, datetime thearrivaldate);//
// uf_getEarliestArrivalDate( string theSku, string theSupplier,decimal(8,0) theOwner, datetime theArrivalDate )
//
// Returns datatime earliestArrivalDate
//
datetime earliestArrivalDate, lastOrderDate, testdate
datastore ds_do_no_date_qty
long dateRows,rowIndex
int invQty	,ordQty
string		ls_date

theproject = getProject()
ds_do_no_date_qty = f_datastoreFactory('d_ncr_do_no_date_qty')
dateRows = ds_do_no_date_qty.retrieve( theArrivalDate, theSku,theSupplier, theOwner )
if dateRows <= 0 then return theArrivalDate

// get sum of the summary available qty for this sku

SELECT sum(avail_qty)  
INTO :invQty
from Content_Summary
where sku = :theSku
and Supp_Code = :thesupplier
and Owner_id = :theowner
and Project_id = :theproject;

if invQty <= 0 then return theArrivalDate

for rowIndex = 1 to dateRows
	lastOrderDate = ds_do_no_date_qty.object.ord_date[rowIndex]
	ordQty = ds_do_no_date_qty.object.alloc_qty[rowIndex]
  	invQty = ( invQty - ordQty )
	if invQty <= 0 then exit
next

if isDate(string(date(lastOrderDate))) then
	// Now based on the last order date get the earliestArrivalDate
	select MIN(rm.arrival_date)
	into :testDate
	from receive_master rm, receive_detail rd
	where rm.ro_no = rd.ro_no
	and rd.sku = :thesku
	and rd.supp_code = :theSupplier
	and rd.owner_id = :theOwner
	and rm.arrival_date > :lastOrderDate;
	
	ls_date = string(testDate,"yyyy-mm-dd")
	
	if isDate(ls_date) then 
		earliestArrivalDate = testDate
	else
		earliestArrivalDate = theArrivalDate
	end if
else
	return theArrivalDate
end if

return earliestArrivalDate
end function

public function integer uf_process_delivery_order (string asproject);
				
Long		llHeaderPos, llHeaderCount, llDetailCount, llDetailPos, llDMasterCount,	&
			llDDetailCount, llRowPos, llCount, llLineItem, llOwner, 				&
			llAllocQty,	llNewRow, llBatchSeq, llNewCount, llUpdateCount, llDeleteCount, &
			llOrderSeq, llCountPO

String	lsProject, lsOrderNo, lsCustPO,lsDoNo,	lstemp, lsProjectHold, lsInvoiceNo,		&
			lsSku, lsSupplier,lsHeaderErrorText, lsDetailErrorText,	lsLogOut, lsallowPOErrors

String	lsReleaseID //for LINKSYS...

Boolean	lbError,	lbValError, lbNewDO, lbDetailErrors
			
Decimal	lddono, ldQty
Integer	liRC


lsLogOut = '          - PROCESSING FUNCTION - Create/Update Outbound Delivery Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
Broadcast(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

If not isValid(idsDOHeader) Then
	idsDOHeader = Create u_ds_datastore
	idsDOHeader.dataobject= 'd_shp_header'
End If
idsDOHeader.SetTransObject(SQLCA)

If not isvalid(idsDeliveryMAster) Then
	idsDeliveryMAster = Create u_ds_datastore
	idsDeliveryMAster.dataobject= 'd_delivery_master'
End If
idsDeliveryMAster.SetTransObject(SQLCA)

If not isvalid(idsDODetail) Then
	idsDODetail = Create u_ds_datastore
	idsDODetail.dataobject= 'd_shp_detail'
End If
idsDODetail.SetTransObject(SQLCA)

If not isvalid(idsDeliveryDetail) Then
	idsDeliveryDetail = Create u_ds_datastore
	idsDeliveryDetail.dataobject= 'd_delivery_detail'
End If
idsDeliveryDetail.SetTransObject(SQLCA)

idsDOHEader.Reset()
idsDODetail.Reset()
idsDeliveryMaster.Reset()
idsDeliveryDetail.Reset()

//Retrieve the EDI Header and Detail based on status
llHeaderCount = idsDOHeader.Retrieve( asProject )

lsLogOut = '              ' + string(llHeaderCount) + ' Outbound Order headers were retrieved for processing.'
Broadcast(lsLogOut) /*write to Screen*/

If llHeaderCount =0 Then
	Return 0
ElseIf llHeaderCount < 0 Then /* 11/03 - PCONKL */
	uf_send_email("",'Filexfer'," - ***** Uf_Process_delivery_Order - Unable to read EDI Records!","Unable to read EDI Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//Process Each EDI Header Record
For llHeaderPos = 1 to llHeaderCount
	
	lbNewDO = False
	
	lsProject = idsDOHeader.GetItemString(llHeaderPos,'project_id')
	lsOrderNo = idsDOHeader.GetItemString(llHeaderPos,'Invoice_no')
	llBatchSeq = idsDOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
	llOrderSeq = idsDOHeader.GetItemNumber(llHeaderPos,'order_seq_no')
	
	//03/03 - PCONKL - for some projects, we will allow a DO to still be created if 1 or more detail lines have errors
	//						 Otherwise, we will delte the entire DO  if there are errors. Only need to retrieve if project changes (it shouldn't in this batch)
	If lsProject <> lsProjectHold Then
		lsallowPOErrors = ProfileString(gsinifile,lsProject,"allowpoerrors","")
		If isNull(lsAllowPOErrors) or lsAllowPOErrors = '' or lsAllowPOErrors <> 'Y' Then lsAllowPOErrors = 'N'
		lsProjectHold = lsProject
	End If
		
	llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsOrderNo)
		
	lsHeaderErrorText = ''
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
		
	//Validate action cd
	If idsDOHeader.GetItemString(llHeaderPos,'action_cd') = 'A' /* add a new Delivery Order */ Then
		
		If llDMasterCount > 0 Then /* record already exists, can't add*/
			uf_writeError("Order Nbr (Header) " + string(lsOrderNo) + " - Order Already Exists and action code is 'Add'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order Already Exists and action code is 'Add'"
			//Continue /*next header*/
		Elseif llDMasterCount = 0 Then /*insert a new row for the new record*/
			llNewRow=idsDeliveryMaster.InsertRow(0)
			lbNewDO = True
			sqlca.sp_next_avail_seq_no(lsproject,"Delivery_Master","DO_No" ,lddono)//get the next available RO_NO
			
			//  03/09 - PCONKL - for 10 char project ID, use 6 digit seq instead of 7 to keep within 16
			If Len(lsProject) = 10 Then
				lsDoNo = lsProject + String(Long(lddono),'000000') /*get rid of decimal place*/
			Else
				lsDoNo = lsProject + String(Long(lddono),'0000000') /*get rid of decimal place*/
			End If
			
			idsDeliveryMaster.SetItem(llNewRow,'Do_no',lsDoNo)
			idsDeliveryMaster.SetItem(llNewRow,'project_id',lsProject)
			
			// 11/03 - PCONKL - If lsOrderNo begins with "SYS-", we want to assign the next available order number, otherwise take from import
			If Left(lsOrderNo,4) = 'SYS-' Then
				lsInvoiceNo = String(Long(lddono),'0000000')
			Else
				lsInvoiceNo = lsOrderNo
			End If
			
			idsDeliveryMaster.SetItem(llNewRow,'invoice_no',lsInvoiceNo)
			
			idsDeliveryMaster.SetItem(llNewRow,'last_update',Today())
			idsDeliveryMaster.SetItem(llNewRow,'last_user','SIMSFP')
			idsDeliveryMaster.SetItem(llNewRow,'create_user','SIMSFP')			
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Delivery Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Delivery Order Record"
			//Continue /*next header*/
		End If
		
	ElseIf idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'U' Then /*update*/
		
		If llDMasterCount <=0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Order does not exist and action code is 'Update'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order does not exist and action code is 'Update'"
			//Continue /*next header*/
		else
			lsDoNo = idsDeliveryMaster.GetItemString(1,'DO_NO') //06/28/04 - dts
		End If
				
	ElseIf idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'D' Then /*If Status is New, Delete*/
		
		If llDMasterCount > 0 Then /*delete all Picking, detail and master records - If status is new*/
			If idsDeliveryMaster.GetITemString(1,'Ord_Status') <> 'N' Then
					uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Order is not in a new status and action Code is 'Delete'")
					lbError = True
					lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete'"
					//Continue /*next header*/
			Else /*delete*/
				lsDoNo = idsDeliveryMaster.GetItemString(1,'DO_NO')
				Delete from Delivery_Picking_Detail where do_no = :lsDoNo;
				Delete from Delivery_Picking where do_no = :lsDoNo;
				Delete from Delivery_detail where do_no = :lsDoNo;
				Delete from Delivery_notes where do_no = :lsDoNo; /* 09/03 - PCONKL */
				Delete from Delivery_bom where do_no = :lsDoNo; /* 10/06 - PCONKL */
				Delete from Delivery_alt_address where do_no = :lsDoNo; /* 09/03 - PCONKL */
				Delete From Delivery_master where do_no = :lsDoNo;
											
				llDeleteCount ++ /*update number of orders deleted*/
				Continue /*next header*/
			End If
			
		Else /*delete and no records exist - ignore*/
			Continue /*Next header*/
		End If
		
	Else /*invalid Action Type*/
		uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsDOHeader.GetITemString(llHeaderPos,'action_cd')) 
		lbError = True
		lsHeaderErrorText += ', ' + "Order Nbr (Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsDOHeader.GetITemString(llHeaderPos,'action_cd')
		//Continue /*next header*/
	End If /*Action Type*/
	
	llDMasterCount = idsDeliveryMaster.RowCount()
		
	//Validate Project
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'project_id')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Project
		Where Project_id = :lsTemp;
	
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Project: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid Project"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(1,'project_id',lsTemp)
		End If
	End If
	
	//Validate Warehouse
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'wh_code')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Warehouse
		Where wh_code = :lsTemp;
	
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Warehouse: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid Warehouse"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(1,'wh_code',lsTemp)
		End If
	End If
		
	//Validate Inventory Type
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'inventory_type')
		If isNull(lsTemp) Then lsTemp = 'N' // 09/09 - now setting lsTemp to 'N' instead of ''
		Select Count(*) into :llCount
		From inventory_type
		Where project_id = :lsProject and inv_type = :lsTemp;
	
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Inventory Type: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid Inventory Type"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(1,'inventory_type',lsTemp)
		End If
	End If
	
	//Validate Order Type
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetItemString(llHeaderPos,'order_type')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From delivery_order_type
		Where Ord_type = :lsTemp;
	
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Order Type: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid order Type"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(1,'ord_type',lsTemp)
		End If
	End If
			
	// If any header errors were encountered, update the edi record with status code and error text
	If lbError then
		
			idsDOHeader.SetITem(llHeaderPos,'status_cd','E')
			If Left(lsheaderErrorText,1) = ',' Then lsHeaderErrorText = Right(lsheaderErrorText,(len(lsHeaderErrorText) - 1)) /*strip first comma*/
			idsDOHeader.SetITem(llHeaderPos,'status_message',lsHeaderErrorText)
			idsDOHeader.Update()
			
			Update edi_outbound_detail
			Set Status_cd = 'E', status_message = 'Errors exist on Header.'
			Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
			Commit;
			
			Continue /*Next Header*/
						
	Else /* No errors */
		
		//Update other fields...
		If isDAte(idsDOHeader.GetITemString(llHeaderPos,'schedule_date')) Then
			idsDeliveryMaster.SetItem(1,'schedule_date',Date(idsDOHeader.GetITemString(llHeaderPos,'schedule_date')))
		Else
			idsDeliveryMaster.SetItem(1,'schedule_date',Today())
		End If
		
		If Isdate(idsDOHeader.GetITemString(llHeaderPos,'request_date')) Then
			idsDeliveryMaster.SetItem(1,'request_date',Date(idsDOHeader.GetITemString(llHeaderPos,'request_date')))
		End If
		
		If Not  isnull(idsDOHeader.GetITemString(llHeaderPos,'ord_date')) and idsDOHeader.GetITemString(llHeaderPos,'ord_date') > '' and  isDate(String(Date(idsDOHeader.GetITemString(llHeaderPos,'ord_date')))) Then /* order date may come in the file, otherwise set to today*/
			idsDeliveryMaster.SetItem(1,'ord_date',DateTime(idsDOHeader.GetITemString(llHeaderPos,'ord_date')))
		Else
			idsDeliveryMaster.SetItem(1,'ord_date',Today())
		End If
				
		idsDeliveryMaster.SetItem(1,'ord_status','N')
		idsDeliveryMaster.SetItem(1,'edi_batch_seq_no',idsDOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no'))
		idsDeliveryMaster.SetItem(1,'freight_cost',0)
		idsDeliveryMaster.SetItem(1,'address_code','DEFAULT')		
		
		If idsDOHeader.GetItemString(llHeaderPos,'Cust_code') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Cust_code',idsDOHeader.GetItemString(llHeaderPos,'Cust_Code'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Cust_Name') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Cust_Name',idsDOHeader.GetItemString(llHeaderPos,'Cust_Name'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_1') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Address_1',idsDOHeader.GetITemString(llHeaderPos,'Address_1'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_2') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Address_2',idsDOHeader.GetITemString(llHeaderPos,'Address_2'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_3') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Address_3',idsDOHeader.GetITemString(llHeaderPos,'Address_3'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_4') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Address_4',idsDOHeader.GetITemString(llHeaderPos,'Address_4'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'City') > ' ' Then
			idsDeliveryMaster.SetItem(1,'City',idsDOHeader.GetITemString(llHeaderPos,'City'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'State') > ' ' Then
			idsDeliveryMaster.SetItem(1,'State',idsDOHeader.GetITemString(llHeaderPos,'State'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Zip') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Zip',idsDOHeader.GetITemString(llHeaderPos,'Zip'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Country') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Country',idsDOHeader.GetITemString(llHeaderPos,'Country'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'District') > ' ' Then
			idsDeliveryMaster.SetItem(1,'District',idsDOHeader.GetITemString(llHeaderPos,'District'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'tel') > ' ' Then
			idsDeliveryMaster.SetItem(1,'tel',idsDOHeader.GetITemString(llHeaderPos,'tel'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Carrier') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Carrier',idsDOHeader.GetITemString(llHeaderPos,'Carrier'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Agent_Info') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Agent_Info',idsDOHeader.GetITemString(llHeaderPos,'Agent_Info'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Freight_Terms') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Freight_Terms',idsDOHeader.GetITemString(llHeaderPos,'Freight_Terms'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Ship_Via') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Ship_Via',idsDOHeader.GetITemString(llHeaderPos,'Ship_Via'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Remark') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Remark',idsDOHeader.GetITemString(llHeaderPos,'Remark'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Ship_Ref') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Ship_Ref',idsDOHeader.GetITemString(llHeaderPos,'Ship_Ref'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'om_note_code_text') > ' ' Then
			idsDeliveryMaster.SetItem(1,'om_note_code_text',idsDOHeader.GetITemString(llHeaderPos,'om_note_code_Text'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'packlist_notes_text') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Packlist_notes',idsDOHeader.GetITemString(llHeaderPos,'packlist_notes_text'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'shipping_instructions_text') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Shipping_Instructions',idsDOHeader.GetITemString(llHeaderPos,'shipping_instructions_text'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field1') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field1',idsDOHeader.GetITemString(llHeaderPos,'User_field1'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field2') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field2',idsDOHeader.GetITemString(llHeaderPos,'User_field2'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field3') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field3',idsDOHeader.GetITemString(llHeaderPos,'User_field3'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field4') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field4',idsDOHeader.GetITemString(llHeaderPos,'User_field4'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field5') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field5',idsDOHeader.GetITemString(llHeaderPos,'User_field5'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field6') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field6',idsDOHeader.GetITemString(llHeaderPos,'User_field6'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field7') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field7',idsDOHeader.GetITemString(llHeaderPos,'User_field7'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field8') > ' ' Then
			idsDeliveryMaster.SetItem(1,'User_field8',idsDOHeader.GetITemString(llHeaderPos,'User_field8'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field9') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field9',idsDOHeader.GetITemString(llHeaderPos,'User_field9'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field10') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field10',idsDOHeader.GetITemString(llHeaderPos,'User_field10'))
		End If
		// 04/16/2009 - added new user fields...
		If idsDOHeader.GetItemString(llHeaderPos,'User_field11') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field11',idsDOHeader.GetITemString(llHeaderPos,'User_field11'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field12') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field12',idsDOHeader.GetITemString(llHeaderPos,'User_field12'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field13') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field13',idsDOHeader.GetITemString(llHeaderPos,'User_field13'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field14') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field14',idsDOHeader.GetITemString(llHeaderPos,'User_field14'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field15') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'User_field15',idsDOHeader.GetITemString(llHeaderPos,'User_field15'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'ctn_cnt') > ' ' Then /* 03/02 - PCONKL - Add to existing ctn cnt if present*/
			idsDeliveryMaster.SetItem(1,'ctn_cnt',(idsDeliveryMaster.GetItemNumber(1,'ctn_cnt') + Long(idsDOHeader.GetITemString(llHeaderPos,'Ctn_Cnt'))))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'weight') > ' ' Then /* 04/03 - PCONKL - Add to existing weight if present*/
			idsDeliveryMaster.SetItem(1,'weight',(idsDeliveryMaster.GetItemNumber(1,'weight') + Long(idsDOHeader.GetITemString(llHeaderPos,'weight'))))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'consolidation_no') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'consolidation_no',idsDOHeader.GetITemString(llHeaderPos,'consolidation_no'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'awb_bol_no') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'awb_bol_no',idsDOHeader.GetITemString(llHeaderPos,'awb_bol_no'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'order_no') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'cust_order_No',idsDOHeader.GetITemString(llHeaderPos,'order_no'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'gls_tr_ID') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'gls_tr_ID',idsDOHeader.GetITemString(llHeaderPos,'gls_tr_ID'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'line_of_business') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'line_of_business',idsDOHeader.GetITemString(llHeaderPos,'line_of_business'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'export_control_commodity_no') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'export_control_commodity_no',idsDOHeader.GetITemString(llHeaderPos,'export_control_commodity_no'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'contact_Person') > ' ' Then 
			idsDeliveryMaster.SetItem(1,'contact_Person',idsDOHeader.GetITemString(llHeaderPos,'contact_Person'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'email_address') > ' ' Then /* 08/09 - PCONKL */
			idsDeliveryMaster.SetItem(1,'email_address',idsDOHeader.GetITemString(llHeaderPos,'email_address'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Transport_Mode') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Transport_Mode',idsDOHeader.GetITemString(llHeaderPos,'Transport_Mode'))
		End If
		If idsDOHeader.GetItemNumber(llHeaderPos,'priority') > 0 Then 
			idsDeliveryMaster.SetItem(1,'priority',idsDOHeader.GetITemNumber(llHeaderPos,'priority'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Vat_ID') > ' ' Then
			idsDeliveryMaster.SetItem(1,'Vat_ID',idsDOHeader.GetITemString(llHeaderPos,'Vat_ID'))
		End If
		
		//Update the Header Record
		SQLCA.DBParm = "disablebind =0"
		liRC = idsDeliveryMaster.Update()
		SQLCA.DBParm = "disablebind =1"
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			uf_writeError("- ***System Error!  Unable to Save Delivery Master Record to database!")
			lbError = True
			Continue /*Next Header*/
		End If
		
		//Update order insert/update count
		If idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'A' Then
			llNewCount ++
		Else
			llUpdateCOunt ++
		End if
				
	End If /* errors on header? */
	
	//Retrieve the EDI DEtail records for the current header (based on edi batch seq and Invoice_no)
	llDetailCount = idsDODetail.Retrieve(lsProject,llBatchSeq,lsOrderNo)

	//Once we have a detail error, we will still validate the detail rows but we wont save any new/changed detail rows to the DB
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
	lbDetailErrors = False /*we need to know if any details have errors, lberror may be reset for each detail row*/
		
	//process each Detail Record
	For llDetailPos = 1 to llDetailCOunt
		
		If lbError Then
			lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
			lbDetailErrors = True
		End If
		
		//04/03 - PCONKL, Only reset for each detail if we are allowing partial PO's
		If lsAllowPOErrors = 'Y' Then	lbError = False 
		
		lsDetailErrorText = ''
		lsSku = idsDODetail.GetItemString(llDetailPos,'sku')	
		lsSupplier = idsDODetail.GetItemString(llDetailPos,'supp_code')
		llLineItem = idsDODetail.GetItemNumber(llDetailPos,'line_item_no')
				
		// 10/06 - PCONKL - If an error was found on project specific NVO, don't process here
		If idsDODetail.GetITemString(llDetailPos,'status_cd') = 'E' Then
			lsDetailErrorText += ', ' + "Errors found in project specific validations"
			lbError = True
		End If
		
		//Validate Inventory Type - If pickable ind is 'N', there may not be an Inventory Type
		lsTemp = idsDODetail.GetITemString(llDetailPos,'inventory_type')
		If isNull(lsTemp) Then lsTemp = ''
		If lsTEmp > '' Then
			
			Select Count(*) into :llCount
			From inventory_type
			Where project_id = :lsProject and inv_type = :lsTemp;
		
			If llCount <=0 Then
				uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Inventory Type: " + lsTemp) 
				lsDetailErrorText += ', ' + "Invalid Inventory Type"
				lbError = True
			End If
			
		End If /*inv type present? */
		
		//Validate SKU
		lsTemp = idsDODetail.GetITemString(llDetailPos,'sku')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Item_Master
		Where project_id = :lsProject and sku = :lsTemp;
		
		If llCount <=0 Then
			uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid SKU: " + lsTemp) 
			lsDetailErrorText += ', ' + "Invalid SKU"
			lbError = True
		End If
		
		// 04/03 - PCONKL - Validate Supplier for current SKU if present, if not rpesent, retrieve from Item MAster 
		llCount = 0
		If (not isnull(lsSUpplier)) and lsSupplier > '' Then /*present - validate*/
			
			Select Count(*) into :llCount
			From Item_Master
			Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;
			
		Else /* not present, retrieve from Item Master */
			
			Select Min(supp_code) into :lsSupplier
			From Item_Master
			Where project_id = :lsProject and sku = :lsTemp;
			
		End If
		
		If llCount = 0 and (isnull(lsSupplier) or lsSupplier = '') Then
			uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid/Missing Supplier for this SKU: " + lsSupplier) 
			lsDetailErrorText += ', ' + "Invalid/Missing Supplier for this SKU."
			lbError = True
		End If
		
		
		//Quantity must be Numeric
		If not isNumber(idsDODetail.GetITemString(llDetailPos,'Quantity')) Then
			uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Quantity is not numeric: " ) 
			lsDetailErrorText += ', ' + "Quantity is not numeric"
			lbError = True
		Else
			ldQty = Dec(idsDODetail.GetITemString(llDetailPos,'Quantity')) /*used to validate against Serial # below*/
		End If
				
		
		//Validate COO if present
		lsTemp = idsDODetail.GetITemString(llDetailPos,'country_of_origin') 
		If isNull(lsTemp) Then lsTemp = ''
		If Trim(lsTEmp) > '' Then
			
			If f_get_Country_Name(lsTemp) > '' Then
			Else
				uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Country of Origin: " + lsTemp) 
				lsDetailErrorText += ', ' + "Invalid Country of Origin"
				lbError = True
			End If
			
		End If
		
		// 10/06 - PCONKL - If serial # is present, Qty must = 1
		If idsDODetail.GetITemString(llDetailPos,'Serial_no') > "" and idsDODetail.GetITemString(llDetailPos,'Serial_no') <> '-' and ldQty > 1 Then
			uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " If serial Number present, Qty Must equal 1") 
			lsDetailErrorText += ', ' + "If serial Number present, Qty Must equal 1"
			lbError = True
		End If
		
		
		
		//If no errors, apply the updates
		If Not lbError Then
						
			//llDDetailCount = idsDeliveryDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem)
			/*0628/04 - dts - now basing Retrieve on Do_No instead of Invoice_No */
			llDDetailCount = idsDeliveryDetail.Retrieve(lsDoNo,lsSku,lsSupplier,llLineItem)

			If llDDetailCount > 0 Then /*details exist */
							
				//update any other changed fields from edi detail to Delivery detail
				If idsDODetail.GetItemString(llDetailPos,'po_no') > ' ' Then
					idsDeliveryDetail.SetItem(1,'po_no',idsDODetail.GetItemString(llDetailPos,'po_no'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'po_no2') > ' ' Then
					idsDeliveryDetail.SetItem(1,'po_no2',idsDODetail.GetItemString(llDetailPos,'po_no2'))
				End If				
				If idsDODetail.GetItemString(llDetailPos,'user_field1') > ' ' Then
					idsDeliveryDetail.SetItem(1,'user_field1',idsDODetail.GetItemString(llDetailPos,'user_field1'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'user_field2') > ' ' Then
					idsDeliveryDetail.SetItem(1,'user_field2',idsDODetail.GetItemString(llDetailPos,'user_field2'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'user_field3') > ' ' Then
					idsDeliveryDetail.SetItem(1,'user_field3',idsDODetail.GetItemString(llDetailPos,'user_field3'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'user_field4') > ' ' Then 
					idsDeliveryDetail.SetItem(1,'user_field4',idsDODetail.GetItemString(llDetailPos,'user_field4'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'user_field5') > ' ' Then 
					idsDeliveryDetail.SetItem(1,'user_field5',idsDODetail.GetItemString(llDetailPos,'user_field5'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'currency_Code') > ' ' Then 
					idsDeliveryDetail.SetItem(1,'currency_Code',idsDODetail.GetItemString(llDetailPos,'currency_Code'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'Price') > ' ' Then 
					idsDeliveryDetail.SetItem(1,'Price',Dec(idsDODetail.GetItemString(llDetailPos,'Price')))
				End If
				If idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes') > ' ' Then
					idsDeliveryDetail.SetItem(1,'Line_Item_Notes',idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes'))
				End If
				If idsDODetail.GetItemString(llDetailPos,'gls_so_id') > ' ' Then 
					idsDeliveryDetail.SetItem(1,'gls_so_id',idsDODetail.GetItemString(llDetailPos,'gls_so_id'))
				End If
				If idsDODetail.GetItemNumber(llDetailPos,'gls_so_line') > 0 Then 
					idsDeliveryDetail.SetItem(1,'gls_so_line',idsDODetail.GetItemNumber(llDetailPos,'gls_so_Line'))
				End If
			
			ElseIf llDDetailCount = 0 Then /*no details exist, it's a new line item - create a new Delivery DEtail Record*/
				
				idsDeliveryDetail.InsertRow(0)
				idsDeliveryDetail.SetITem(1,'do_no',idsDeliveryMaster.GetItemString(1,'do_no'))
				idsDeliveryDetail.SetItem(1,'sku',idsDODetail.GetItemString(llDetailPos,'sku'))
				idsDeliveryDetail.SetItem(1,'supp_code',lsSupplier)
				
				idsDeliveryDetail.SetITem(1,'req_qty',long(idsDODetail.GetItemString(llDetailPos,'quantity')))
				idsDeliveryDetail.SetItem(1,'user_field1',idsDODetail.GetItemString(llDetailPos,'user_field1'))
				idsDeliveryDetail.SetItem(1,'user_field2',idsDODetail.GetItemString(llDetailPos,'user_field2'))
				idsDeliveryDetail.SetItem(1,'user_field3',idsDODetail.GetItemString(llDetailPos,'user_field3'))
				idsDeliveryDetail.SetItem(1,'user_field4',idsDODetail.GetItemString(llDetailPos,'user_field4')) 
				idsDeliveryDetail.SetItem(1,'user_field5',idsDODetail.GetItemString(llDetailPos,'user_field5')) 
				idsDeliveryDetail.SetItem(1,'user_field6',idsDODetail.GetItemString(llDetailPos,'user_field6'))
				idsDeliveryDetail.SetItem(1,'user_field7',idsDODetail.GetItemString(llDetailPos,'user_field7')) 
				idsDeliveryDetail.SetItem(1,'user_field8',idsDODetail.GetItemString(llDetailPos,'user_field8')) 
				idsDeliveryDetail.SetItem(1,'uom',idsDODetail.GetItemString(llDetailPos,'uom')) 
				idsDeliveryDetail.SetItem(1,'line_item_no',idsDODetail.GetItemNumber(llDetailPos,'Line_item_no'))
				idsDeliveryDetail.SetItem(1,'Line_Item_Notes',idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes'))
				idsDeliveryDetail.SetItem(1,'gls_so_id',idsDODetail.GetItemString(llDetailPos,'gls_so_id')) 
				idsDeliveryDetail.SetItem(1,'gls_so_line',idsDODetail.GetItemNumber(llDetailPos,'gls_so_line')) 
				idsDeliveryDetail.SetITem(1,'alloc_qty',0)
				idsDeliveryDetail.SetItem(1,'Price',Dec(idsDODetail.GetItemString(llDetailPos,'Price')))
// TAM 11/01/2010 -  If no value then skip PONO and PONO2.  PONO and PONO 2 is commented out when ithe 940 is processed in uf_process_do.  This causess a DW error.
				If idsDODetail.GetItemString(llDetailPos,'po_no') > ' '  Then 
					idsDeliveryDetail.SetItem(1,'po_no',idsDODetail.GetItemString(llDetailPos,'po_no'))	
				End If
				If idsDODetail.GetItemString(llDetailPos,'po_no2') > ' '  Then 
					idsDeliveryDetail.SetItem(1,'po_no2',idsDODetail.GetItemString(llDetailPos,'po_no2'))				
				End If
	
				
				If idsDODetail.GetITemString(llDetailPos,'alternate_sku') > ' ' Then
					idsDeliveryDetail.SetItem(1,'alternate_sku',idsDODetail.GetItemString(llDetailPos,'alternate_sku'))
				Else
					idsDeliveryDetail.SetItem(1,'alternate_sku',idsDODetail.GetItemString(llDetailPos,'sku'))
				End If
				// 10/01/09
				idsDeliveryDetail.SetItem(1,'currency_code',idsDODetail.GetItemString(llDetailPos,'currency_code')) 
				
				//Get default owner for SKU - 04/03 - PCONKL if not already set in file
				If idsDODetail.GetItemString(llDetailPos,'owner_ID') > '0' Then
					
					idsDeliveryDetail.SetItem(1,'owner_id',Long(idsDODetail.GetItemString(llDetailPos,'owner_ID')))
					
				Else /*get default from ITem Master*/
					
					Select Min(owner_id) into :llOwner
					From Item_Master
					Where  project_id = :lsProject and sku = :lsSku;
				
					idsDeliveryDetail.SetItem(1,'owner_id',llOwner)		
					
				End If
	
			Else /*system Error*/
				uf_writeError("Order Nbr (Detail): " + string(lsOrderNo) + " - System Error: Unable to retrieve Delivery Order Detail Records")
				lbError = True
				Continue /*next Detail*/
			End If /*Delivery detail records exist? ) */
			
			//Update the Detail Record
			liRC = idsDeliveryDetail.Update()
			If liRC = 1 then
				Commit;
			Else
				Rollback;
				uf_writeError("- ***System Error!  Unable to Save Delivery Detail Record to database!")
				lbError = True
				COntinue
			End If
				
		Else /* Errors exist on Detail, mark with status cd and error text*/
			
			idsDODetail.SetItem(llDetailPos,'status_cd','E')
			If Left(lsDetailErrorText,1) = ',' Then lsDetailErrorText = Right(lsDetailErrorText,(len(lsDetailErrorText) - 1)) /*strip first comma*/
			idsDODetail.SetItem(llDetailPos,'status_message',lsDetailErrorText)
			
		End If /*no errors on detail*/
		
	Next /*edi detail record*/
	
	//If there were errors on any of the details and this is a new order, we will delete the header and any details that
	//might have been saved. The header will have been saved before the details were processed but we dont want to keep it
	
	//save any changes made to edi records (status cd, error msg)
	idsDOHeader.Update()
	idsDODetail.Update()
	Commit;
	
	If lbError or lbDetailErrors Then 
		
		//04/03 - PCONKL - Don't delete if we are allowing errors on DO
		If lsallowPOErrors <> 'Y' Then
			
			If lbNewDO  Then /* new PO */
				Delete from Delivery_detail where do_no = :lsDOno;
				Delete from Delivery_Notes where do_no = :lsDOno; /* 09/03 - PCONKL*/
				Delete from Delivery_BOM where do_no = :lsDOno; /* 10/06 - PCONKL*/
				Delete from Delivery_Alt_Address where do_no = :lsDOno; /* 09/03 - PCONKL*/
				Delete from Delivery_master where Do_no = :lsDoNo;
				Commit;
			End If /* new PO with errors*/
		
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - No changes applied to this Order!")
			
		Else /*saving with errors */
			
			/* 05/07 - dts - Set the DO_NO for any Notes or Alt Address records associated with this order
						(this was already being done for orders without errors, but not for orders which are allowed errors) */
			Update Delivery_Notes set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			Update Delivery_Alt_Address set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			Update Delivery_BOM set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - Order saved with errors!")
			
		End If

		lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
		
		//Update any header/detail records with error status if we didn't catch an individual error on the detail level
		Update edi_outbound_header
		Set status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
		
		Update edi_outbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
		
		Commit;
		
	Else /* No errors on order*/
	
		// 09/03 - PConkl - Set the DO_NO for any Notes or Alt Address records associated with this order
		Update DElivery_Notes set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
		Update DElivery_Alt_Address set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
		Update DElivery_BOM set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq; 	//10/06 - PCONKL
		
		// do the NCR 855
		uf_process_855(lsDONO)
		
	End If /* any detail level errors*/
			
Next /* EDI Header Record*/

//mark any records as complete that might have been skipped (continued to next header)*/
For llHeaderPos = 1 to llHeaderCount
	
	lsProject = idsDOHeader.GetITemString(llHeaderPos,'project_id')
	lsOrderNo = idsDOHeader.GetITemString(llHeaderPos,'Invoice_no')
	llBatchSeq = idsDOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no')
	
	Update edi_Outbound_header
	Set status_cd = 'C' , status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
				
	Update edi_Outbound_detail
	Set Status_cd = 'C', status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
	
	commit;
	
Next

If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/

If lbValError Then 
	Return -1
Else
	Return 0
End If



end function

on u_nvo_proc_ncr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ncr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;setProject('NCR')
setWarehouse()

end event

