HA$PBExportHeader$u_nvo_proc_epson.sru
forward
global type u_nvo_proc_epson from nonvisualobject
end type
end forward

global type u_nvo_proc_epson from nonvisualobject
end type
global u_nvo_proc_epson u_nvo_proc_epson

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

forward prototypes
public function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_userfields (integer al_totaluserfields, string as_recdata, ref datastore adw_destdw, integer adw_destdwcurrentrow)
end prototypes

public function integer uf_process_delivery_order (string aspath, string asproject);


//Process Sales Order (DM) Transaction for Baseline Unicode Client

STRING lsTemp, lsProject, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsorder, lsNoteType
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo, llNewAddressRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsCustomerCode
STRING ls_OrderDate, ls_DeliveryDate, ls_GI_Date
BOOLEAN lbBillToAddress
STRING lsBillToAddr1, lsBillToAddr2, lsBillToAddr3, lsBillToAddr4, lsBillToCity
STRING	lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel, lsBillToName
STRING ls_InventoryType
STRING ls_Carrier, lsEpsonCustCode, lsNull

STRING lsRecData, lsRecType
LONG liFileNo, llRowCount, llRowPos, llNoteLine, llNoteSeq, llNewNotesRow
String lsNoteText

SetNull(lsNull)

u_ds_datastore 	ldsSOheader,	&
				ldsSOdetail, &
				ldsDOAddress, ldsDONotes
			
datastore lu_ds
				
u_ds_datastore ldsImport

//DateTime	ldtToday

//ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'


ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_baseline_unicode_do_address'
ldsDOAddress.SetTransObject(SQLCA)


ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
//liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Epson Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileReadEx(liFileNo,lsRecData)

Do While liRC > 0
	llRowPos = lu_ds.InsertRow(0)
	lu_ds.SetItem(llRowPos,'rec_data',lsRecData) 
	liRC = FileReadEx(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//
//if liRtnImp < 0 then
//	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
//	FileWrite(giLogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
//end if

//
//llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
// 03/09 llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
// 03/09 -  using edi_INbound_header because web does and it will crash when trying to re-use a sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

//
//Delivery Order Master
//

//
//* - Either the Delivery Date or the Goods issue Date is required. If neither is present, the order drop date will be the default ship date.
//
//

llRowCount = lu_ds.RowCount()

for llRowPos = 1 to llRowCount

	w_main.SetMicroHelp("Processing Sales Order Record " + String(llRowPos) + " of " + String(llRowCount))

	lsRecData = lu_ds.GetITemString(llRowpos, 'rec_data')

	//Field Name	Type	Req.	Default	Description
	//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$DM$$HEX2$$1d200900$$ENDHEX$$Delivery order master identifier
	//Record ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$DD$$HEX2$$1d200900$$ENDHEX$$Delivery order detail identifier

//	//Validate Rec Type is PM OR PD
//	lsTemp = Trim(ldsImport.GetItemString(llRowPos, "col1"))
//	If NOT (lsTemp = 'DM' OR lsTemp = 'DD') Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
//		lbError = True
//		//Continue /*Process Next Record */
//	End If

	lsRecType = Left(lsRecData,2)

	lsTemp = lsRecType

	Choose Case Upper(lsRecType)
	
		//Purchase Order Master
	
		//HEADER RECORD
		Case 'DM' /* Header */

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Change ID	C(1)	Yes	N/A	
				//A $$HEX2$$13202000$$ENDHEX$$Add
				//U $$HEX2$$13202000$$ENDHEX$$Update
				//D $$HEX2$$13202000$$ENDHEX$$Delete
				//X $$HEX2$$13202000$$ENDHEX$$Ignore (Add or update regardless)
				
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If					
	
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Project ID	C(10)	Yes	N/A	Project identifier
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Project is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
				lsProject = asproject
//			End If					
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */	
				
			//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsWarehouse = lsTemp
			End If					
							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */				
			
			//Delivery Number	C(20)	Yes	N/A	Delivery Order Number

			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
			End If					
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */	
				
							
			//Order Date	Date	No	N/A	Order Date
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_OrderDate = left(lsTemp,4) + "/" + mid(lsTemp, 5,2) + "/" + mid(lsTemp, 7,2) + " 00:00:00"
			End If				
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery Date	Date	No*	*	Date for delivery to Customer

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_DeliveryDate = lsTemp
			End If				
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//GI Date	Date	No*	*	Planned goods ship date from warehouse
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_GI_Date = lsTemp
			End If				
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Code	C(20)	Yes	N/A	Customer ID
		
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Customer Code is required. Record will not be processed.")
//				lbError = True
//				Continue		
			Else

			lsEpsonCustCode = trim(lsTemp)
			lsCustomerCode = trim(left(lsTemp,9))
			
			Select Cust_Code into :lsCustomerCode
				From Customer
				Where project_id = :asProject and (user_field1 = :lsCustomerCode or  user_field2 = :lsCustomerCode or user_field3 = :lsCustomerCode );
			
			

			End If		

			/* End Required */		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			liNewRow = 	ldsSOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0			
			
			//New Record Defaults
			ldsSOheader.SetItem(liNewRow,'project_id',lsProject)
			ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
//			ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsSOheader.SetItem(liNewRow,'status_cd','N')
			ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsSOheader.SetItem(liNewRow,'invoice_no',lsOrderNumber)			

//			ldsSOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/

			ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
	
			ldsSOheader.SetItem(liNewRow,'user_field10',lsEpsonCustCode)
	
			ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

//			1.	Map Delivery Date on DM to $$HEX1$$1c20$$ENDHEX$$Delivery Date$$HEX2$$1d202000$$ENDHEX$$in SIMS
//			2.	Map GI Date on DM to $$HEX1$$1c20$$ENDHEX$$Schedule Date$$HEX2$$1d202000$$ENDHEX$$in SIMS
//			
			
			ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)
			ldsSOheader.SetItem(liNewRow,'delivery_date',ls_DeliveryDate)
			ldsSOheader.SetItem(liNewRow,'schedule_date',ls_GI_Date)
		
			//Order Type	C(1)	No	N/A	Order Type
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				lsTemp = "S"	
			Else
				lsOrderType = lsTemp
				
				ldsSOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Type*/	
								
			End If					
				
				
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
				
			//Customer Order #	C(20)	No	N/A	Customer Order Number
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'order_no', lsTemp)
			End If		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
						
			
			//Carrier	C(20)	No	N/A			
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				
				
				lsTemp = trim(lsTemp)
//				
//				select carrier_name INTO :ls_Carrier from carrier_master
//					where project_id = :asproject AND carrier_code = :lsTemp ;
//					
//				IF SQLCA.SQLCode = 100 OR SQLCA.SQLCode < 0 THEN
//					ls_Carrier = lsTemp
//				END IF
//				
//				CHOOSE CASE trim(lsTemp)
//				
//				CASE "OD"
//					ls_Carrier = "Old Dominion"
//				CASE "CD"	
//					ls_Carrier =  "Celadon"
//				CASE "NP"
//					ls_Carrier = "New Penn"
//				CASE "TR"	
//					ls_Carrier =  "Generic Truck	"
//				CASE "OL"	
//					ls_Carrier = "Oliver Trucking"
//				CASE "T"
//					ls_Carrier = "Transport Connection"
//				CASE "OT"
//					ls_Carrier = "UPS Freight"	
//				CASE "VL"
//					ls_Carrier = "Venture Logistics"
//				CASE "P1"
//					ls_Carrier = "Pilot"
//				CASE "P2"
//					ls_Carrier =	"Pilot"				
//				CASE "P3"
//					ls_Carrier = "Pilot"
//				CASE "WA"
//					ls_Carrier = "FedEx National"
//				CASE "VI"
//					ls_Carrier = "Viking"
//				CASE "YF"	
//					ls_Carrier = "Yellow"
//				CASE ELSE
//					ls_Carrier = lsTemp
//				END CHOOSE
				
//				ldsSOheader.SetItem(liNewRow,'carrier', ls_Carrier)
			End If		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//Transport Mode	C10)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'transport_mode', lsTemp)
			End If		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship Via	C(15)	No	N/A	

				If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If
	
			select carrier_name INTO :ls_Carrier from carrier_master
				where project_id = :asproject AND carrier_code = :lsTemp ;
				
			IF SQLCA.SQLCode = 100 OR SQLCA.SQLCode < 0 THEN
				ls_Carrier = lsTemp
			END IF


			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'carrier', ls_Carrier)
//				ldsSOheader.SetItem(liNewRow,'ship_via', ls_Carrier)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			//Freight Terms	C(20)	No	N/A	

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				
				string ls_Terms_short_desc
				
				select Terms_short_desc INTO :ls_Terms_short_desc from Terms_Codes
					where project_id = :asproject AND Terms_Code = :lsTemp and WH_Code = 'EPSON';
				
				IF ISNull(ls_Terms_short_desc) OR Trim(ls_Terms_short_desc) = '' THEN
					ls_Terms_short_desc = lsTemp
				END IF
				
				ldsSOheader.SetItem(liNewRow,'freight_terms', ls_Terms_short_desc)
	
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Agent Info	C(30)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'agent_info', lsTemp)
			End If				
			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship To Name	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'cust_name', lsTemp)
			End If				


			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
				
			
			//Ship Address 1	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_1', lsTemp)
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship Address 2	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_2', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship Address 3	C(60)	No	N/A	
	
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_3', lsTemp)
			End If	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship Address 4	C6)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_4', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship City	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'city', lsTemp)
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship State	C(50)	No	N/A
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'state', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			//Ship Postal Code	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			//Ship Country	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'country', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Ship Tel	C(20)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'tel', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			//If we have Bill to information, we will need to build an Alt Address record
		 	lbBillToAddress = False		
				
			//Bill To Name	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToName = Trim(lsTemp)
			ELSE
				lsBillToName = ''
			End If				
			
			//Bill Address 1	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr1 = Trim(lsTemp)
			ELSE
				lsBillToADdr1 = ''
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill Address 2	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr2 = Trim(lsTemp)
			ELSE
				lsBillToADdr2 = ''
			End If					

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill Address 3	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr3 = Trim(lsTemp)
			ELSE
				lsBillToADdr3 = ''
			End If					

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill Address 4	C(60)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToADdr4 = Trim(lsTemp)
			ELSE
				lsBillToADdr4 = ''
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Bill City	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToCity = Trim(lsTemp)
			ELSE
				lsBillToCity = ''
			End If	

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill State	C(50)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToState = Trim(lsTemp)
			ELSE
				lsBillToState = ''
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill Postal Code	C(50)	No	N/A
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToZip = Trim(lsTemp)
			ELSE
				lsBillToZip = ''
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Bill Country	C(50)	No	N/A
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToCountry = Trim(lsTemp)
			ELSE
				lsBillToCountry = ''
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

					
			//Bill Tel	C(20)	No	N/A	
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				lbBillToAddress = True
				lsBillToTel = Trim(lsTemp)
			ELSE
				lsBillToTel = ''
			End If				
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Remarks	C(255)	No	N/A	
		
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'remark', lsTemp)
			End If		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Shipping Instructions	C(255)	No	N/A	
		
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'shipping_instructions_Text', lsTemp)
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Packlist Notes	C(255)	No	N/A
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'packlist_notes_Text', lsTemp)
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//User Field2	C(10)	No	N/A	User Field
			//User Field3	C(10)	No	N/A	User Field
			//User Field4	C(20)	No	N/A	User Field
			//User Field5	C(20)	No	N/A	User Field
			//User Field6	C(20)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(60)	No	N/A	User Field
			//User Field9	C(30)	No	N/A	User Field
			//User Field10	C(30)	No	N/A	User Field
			//User Field11	C(30)	No	N/A	User Field
			//User Field12	C(50)	No	N/A	User Field
			//User Field13	C(50)	No	N/A	User Field
			//User Field14	C(50)	No	N/A	User Field
			//User Field15	C(50)	No	N/A	User Field
			//User Field16	C(100)	No	N/A	User Field
			//User Field17	C(100)	No	N/A	User Field
			//User Field18	C(100)	No	N/A	User Field
			
			uf_process_userfields(18, lsRecData, ldsSOheader, liNewRow)	
	

			
			//If we have Bill To Information, create the Alt Address record
			If lbBillToAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id', lsProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsBillToName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsBillToAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsBillToAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lsBillToAddr3)
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',lsBillToAddr4)
				ldsDOAddress.SetItem(llNewAddressRow,'City',lsBillToCity)
				ldsDOAddress.SetItem(llNewAddressRow,'State',lsBillToState)
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lsBillToZip)
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lsBillToCountry)
				ldsDOAddress.SetItem(llNewAddressRow,'tel',lsBillToTel)
				
			End If /*alt address exists*/
								
		// DETAIL RECORD

		Case 'DD' /*Detail */

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Delivery Order Detail


			//Change ID	C(1)	Yes	N/A	
				//A $$HEX2$$13202000$$ENDHEX$$Add
				//U $$HEX2$$13202000$$ENDHEX$$Update
				//D $$HEX2$$13202000$$ENDHEX$$Delete

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If


			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Change ID is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsChangeID = lsTemp
			End If		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Project is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
				lsProject = asproject
//			End If									

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			//Delivery Number	C(20)	Yes	N/A	Delivery Order Number (must match header)

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			lsLogOut = 'Delivery Number:' +lsTemp 
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
		
				//Make sure we have a header for this Detail...
				If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			
			//Supplier Code	C(20)	Yes	N/A	

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			lsLogOut = 'Supplier:' +lsTemp 
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier Code is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
			lsSupplier = "EPSONINC" //lsTemp
//			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


		
			//Line Number	N(6,0)	Yes	N/A	Delivery line item number

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If


			lsLogOut = 'Line Number:' +lsTemp + ":" + string(llRowPos)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If					

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//SKU	C(50)	Yes	N/A	Material number

	
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			lsLogOut = 'SKU:' +lsTemp 
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Quantity	N(15,5)	Yes	N/A	Requested delivery quantity

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			//Inventory Type	C(1)	Yes	N/A	Inventory Type		
	
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Inventory Type is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ls_InventoryType = lsTemp
			End If		
	
			/* End Required */

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		
			lbDetailError = False
			llNewDetailRow = 	ldsSODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsSODetail.SetItem(llNewDetailRow,'project_id', lsProject) /*project*/
			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', ls_InventoryType) 
			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrderNumber)			
//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			

			//Customer  Line Item Number	C(20)	No	N/A	Customer Line Item Number

			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'', lsTemp)
			End If		

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


			//Alternate SKU	C(50)	No	N/A	Alternate SKU
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'alternate_sku', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Customer SKU	C(35)	No	N/A	Customer/Alternate SKU
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
			//	ldsSODetail.SetItem(liNewRow,'cust_sku', lsTemp)
				ldsSODetail.SetItem(llNewDetailRow,'user_field3', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'lot_no', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'po_no', lsTemp)
			End If			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'po_no2', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'serial_no', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Item Text	C(255)	No	N/A	Notes / remarks
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = ''
			End If

	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSODetail.SetItem(llNewDetailRow,'line_item_notes', lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//User Field1	C(20)	No	N/A	User Field
			//User Field2	C(20)	No	N/A	User Field
			//User Field3	C(30)	No	N/A	User Field
			//User Field4	C(30)	No	N/A	User Field
			//User Field5	C(30)	No	N/A	User Field
			//User Field6	C(30)	No	N/A	User Field
			//User Field7	C(30)	No	N/A	User Field
			//User Field8	C(30)	No	N/A	User Field, not viewable on screen

			uf_process_userfields(8, lsRecData, ldsSODetail, llNewDetailRow)	
			
			ldsSODetail.SetItem(llNewDetailRow,'user_field5', 	ldsSODetail.GetItemString(llNewDetailRow,'user_field1'))
	
	
			
	Case	"DN" /*Delivery NOtes*/
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			lsOrder = lsTemp
			
			//Make sure we have a header for this Detail...
			If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "'",1,ldsSOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header ORder Number. Note Record will not be processed (Delivery Order will still be loaded)..")
				Continue
			End If
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			End If

			If isNumber(lsTemp) Then
				llNoteLine = 0
			End If
					
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Note Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				lsNoteType = lsTemp
			Else /*error*/
				lsTemp = ""
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			
			
			//Note Sequence
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Note Seq Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteSeq = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes Seq Number' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Note Text
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If

			
			//Each Note row may get broken into multiple rows if we encounter a ~
			lsNoteText = lsTemp
			
			If lsNoteText > "" Then 
			
				llNewNotesRow = ldsDONotes.InsertRow(0)
				ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
				ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
				ldsDONotes.SetItem(llNewNotesRow,'note_type',lsNoteType)
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',llNoteLine)
				ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsNoteText)
				
			End If
			
			
	Case Else /*Invalid rec type */
			
			If llRowPos < llRowCount Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed (Delivery Order will still be loaded).")
				lbError = True
			End If
			
//			Return -1
						

	End Choose /*Header, Detail or Notes */
	
	
Next /*File record */
	
//Save the Changes 
lirc = ldsSOheader.Update()

If liRC = 1 Then
	liRC = ldsDONotes.Update()
End If

	
If liRC = 1 Then
	liRC = ldsSOdetail.Update()	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



If liRC = 1 Then
	
//	Execute Immediate "COMMIT" using SQLCA; COMMIT USING SQLCA;
	liRC = ldsDOAddress.Update()
ELSE	
//	Execute Immediate "ROLLBACK" using SQLCA;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Detail Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



	
If liRC = 1 then
//	Commit;
Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If Left(asFile,4) = 'N940' Then /* PO File*/
	
		liRC = uf_process_delivery_order(asPath, asProject)
		
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		

Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End If

Return liRC


////Process the correct file type based on the first 4 characters of the file name
//
//String	lsLogOut,	&
//			lsSaveFileName, &
//			lsPOLineCountFileName
//			
//Integer	liRC
//
//Boolean	bRet
//
//Choose Case Upper(Left(asFile,4))
//		
//	Case  'PM'  
//		
//		liRC = uf_process_purchase_order(asPath, asProject)
//	
//		//Process any added PO's
//		//We need to change to project. This will be changed after testing.
//		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
//
//	Case  'N940'  
//		
//		liRC = uf_process_delivery_order(asPath, asProject)
//		
//		
//		//Process any added SO's
//		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject )
//
//		
//	Case 'IM'
//		
//		liRC = uf_Process_ItemMaster(asPath, asProject)
//		
//
//	Case  'RM'  
//		
//		liRC = uf_return_order(asPath, asProject)
//	
//		//Process any added PO's
//		//We need to change to project. This will be changed after testing.
//		liRC = gu_nvo_process_files.uf_process_purchase_order('CHINASIMS')  //asProject
//		
//		
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
//Return liRC
end function

public function integer uf_process_userfields (integer al_totaluserfields, string as_recdata, ref datastore adw_destdw, integer adw_destdwcurrentrow);
integer li_UFIdx
string lsTemp, lsRecData	

lsRecData = as_recdata	

//Handle User Fields

For li_UFIdx = 1 to al_TotalUserFields

	//Packlist Notes	C(255)	No	N/A
	
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else
		lsTemp = ''
	End If

	
	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
		adw_DestDW.SetItem(adw_DestDWCurrentRow,'User_Field' + string(li_UFIdx), lsTemp)
	End If			

	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */


	
Next

RETURN 0
end function

on u_nvo_proc_epson.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_epson.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

