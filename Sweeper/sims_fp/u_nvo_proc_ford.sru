HA$PBExportHeader$u_nvo_proc_ford.sru
$PBExportComments$Process NCR EDI Files
forward
global type u_nvo_proc_ford from nonvisualobject
end type
end forward

global type u_nvo_proc_ford from nonvisualobject
end type
global u_nvo_proc_ford u_nvo_proc_ford

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem
				
datastore idsFRDInventorySnap
datastore idsFRDWeeklyPick
string theProject


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
public function datetime uf_getearliestarrivaldate (string thesku, string thesupplier, decimal theowner, datetime thearrivaldate)
public function integer uf_process_weekly_pick_rpt ()
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

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);////Process the correct file type based on the first 4 characters of the file name
//
//String	lsLogOut,	&
//			lsSaveFileName
//Integer	liRC
//
//Boolean	bRet
//
//Choose Case Upper(Left(asFile,6))
//		
//	Case '' /* Sales Order Files*/
//		
//		liRC = uf_process_so(asPath, asProject)
//		
//		//Process any added SO's
//		liRC = gu_nvo_process_files.uf_process_Delivery_order() 
//		
//	Case Else /*Invalid file type*/
//		
//		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
//		FileWrite(gilogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_writeError(lsLogout)
//		Return -1
//		
//End Choose
//
Return 0
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
// Create the FRD Inventory Snapshot File
//
datastore ldsOut
string lsFilename ="invsnap"
string lsPath
long rows
long rowIndex
string msg
int returnCode
string skubreak 
string sku
long insertrow
decimal availTot ,allocTot,sitTot,costTot

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Ford Inventory Snapshot'
FileWrite(gilogFileNo,msg)

// Create our filename and path
lsFilename ="invsnap" + string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(gsinifile,getproject(),"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Snapshot Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

// Create our datastore
idsFRDInventorySnap = f_datastoreFactory( 'd_ford_inventory_snapshot_report' )
rows= idsFRDInventorySnap.retrieve(getProject())
if rows <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(rows)
	if rows = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	return 0 // nothing to see here...move along
end if
/*
	Since stupid powerbuilder does NOT export user defined bands
	I have to do it manually.  On a sku break I insert a row and populate
	it with the sku's totals
*/
skubreak = idsFRDInventorySnap.object.sku[1] // seed the break
For rowIndex = 1 to rows
	sku =  trim(idsFRDInventorySnap.object.sku[rowIndex])
	if skubreak <> sku then
		// Write the total line
		insertrow = idsFRDInventorySnap.insertRow(rowIndex)
		idsFRDInventorySnap.object.sku[insertrow] = skubreak+ " Totals: "
		idsFRDInventorySnap.object.description[insertrow] = " "
		idsFRDInventorySnap.object.supplier[insertrow] = " "
		idsFRDInventorySnap.object.location[insertrow] =  " "
		idsFRDInventorySnap.object.inv_type[insertrow] =  " "
		idsFRDInventorySnap.object.owner[insertrow] = " "
		idsFRDInventorySnap.object.uom[insertrow] = " "
		idsFRDInventorySnap.object.avail_qty[insertrow] = availTot
		idsFRDInventorySnap.object.alloc_qty[insertrow] = allocTot
		idsFRDInventorySnap.object.sit_qty[insertrow] = sitTot
		idsFRDInventorySnap.object.cost[insertrow] = costTot
		idsFRDInventorySnap.accepttext()
		rows  = idsFRDInventorySnap.rowCount()
		// reset stuff
		availTot=0
		allocTot=0
		SitTot=0
		CostTot=0
		skubreak = sku
	else
		// Accumultate totals
		availTot += idsFRDInventorySnap.object.avail_qty[rowIndex]
		allocTot += idsFRDInventorySnap.object.alloc_qty[rowIndex]
		SitTot +=    idsFRDInventorySnap.object.sit_qty[rowIndex]
		CostTot +=  idsFRDInventorySnap.object.cost[rowIndex]
	end if
next
// Export the data to the file location
returnCode = idsFRDInventorySnap.saveas(lsPath,CSV!,true)
msg = 'Ford Inventory Snapshot Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Ford Inventory Snapshot Complete'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)
return 0

	
end function

public subroutine setproject (string _project);theProject = _project

end subroutine

public function string getproject ();return theProject

end function

public function datetime uf_getearliestarrivaldate (string thesku, string thesupplier, decimal theowner, datetime thearrivaldate);//
// uf_getEarliestArrivalDate( string theSku, string theSupplier,decimal(8,0) theOwner, datetime theArrivalDate )
//
// Returns datatime earliestArrivalDate
//
datetime earliestArrivalDate, lastOrderDate, testdate
datastore ds_do_no_date_qty
long dateRows,rowIndex
int invQty	,ordQty

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
	ordQty = ds_do_no_date_qty.object.ord_date[rowIndex]
  	invQty = ( invQty - ordQty )
	if invQty <= 0 then exit
next

// Now based on the last order date get the earliestArrivalDate
select rm.arrival_date
into :testDate
from receive_master rm, receive_detail rd
where rm.ro_no = rd.ro_no
and rd.sku = :thesku
and rd.supp_code = :theSupplier
and rd.owner_id = :theOwner
and rm.arrival_date > :lastOrderDate;

if isDate(string(testDate)) then earliestArrivalDate = testDate

return earliestArrivalDate
end function

public function integer uf_process_weekly_pick_rpt ();//
// uf_process_weekly_pick_rpt
// Create the FRD Weekly Pick Report
//
string lsFilename ="wklypick"
string lsPath
string msg
int returnCode
long rows
datetime pickFrom,pickTo
date aweekago 
time zero1
date yesterday
time lastsec

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Ford Weekly Pick Report'
FileWrite(gilogFileNo,msg)

// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(gsinifile,getproject(),"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Snapshot Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

// Create our datastore

idsFRDWeeklyPick = f_datastoreFactory( 'd_ford_pick_complete' )
/*
From the requirements Doc...

2.3.	Report is to be run starting at 00:01 (CT) Sunday morning.
2.4.	Report Start and End times are:
2.4.1.	Start date = Sunday, midnight (CT)
2.4.2.	End date = Saturday, midnight (CT)

I'm assuming it's from the Sunday a week before the run time through midnight Saturday.
This runs every Sunday at 00:00:01

*/
aweekago = RelativeDate ( today(), -7 )
zero1 = time("00:00:01")
pickFrom = datetime( aweekago,zero1 )
yesterday = RelativeDate ( today(), -1 )
lastsec = time("23:59:59")
pickTo = datetime( yesterday,lastsec)
// Testing
pickFrom = datetime('01/01/01 00:00:01')
pickTo = datetime(today(),now())
// End Testing
msg = 'Pick Complete From: ' + string( pickFrom) + ' To: ' + string(PickTo)
FileWrite(gilogFileNo,msg)
rows= idsFRDWeeklyPick.retrieve(getProject(),pickFrom,PickTo)
if rows <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(rows)
	if rows = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = idsFRDWeeklyPick.saveas(lsPath,CSV!,true)
msg = 'Ford Weekly Pick Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Ford Weekly Pick Complete Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)
return 0


end function

on u_nvo_proc_ford.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ford.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;setProject('PRATT')
end event

