HA$PBExportHeader$u_nvo_proc_ironport.sru
$PBExportComments$Process Ironport files
forward
global type u_nvo_proc_ironport from nonvisualobject
end type
end forward

global type u_nvo_proc_ironport from nonvisualobject
end type
global u_nvo_proc_ironport u_nvo_proc_ironport

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 



end prototypes

type variables
datastore	idsPOHeader,	&
				idsPODetail

Long	ilDefaultOwner

end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_dboh (string asinifile, string asemail)
public function integer uf_process_weekly_shipment_file (string asinifile, string asemail)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileRC, liFileNo

Boolean	bRet, lbError

Long	llRow, llRowCount, llBatchSeqNo, llOrderSeq, llLineSeq, llFileSeq


Datastore	lu_ds

llFileSeq = 0


If Not isvalid(idsPOHEader) Then
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
	idsPOheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsPOdetail) Then
	idsPOdetail = Create u_ds_datastore
	idsPOdetail.dataobject= 'd_po_detail'
	idsPOdetail.SetTransObject(SQLCA)
End If


idsPoHeader.Reset()
idspoDetail.Reset()

//Process file based on type...
Choose Case Upper(Left(asFile,2))
	
			
	Case 'PM' /* PO File */
		
		liRC = uf_process_po(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//Process any added PO's
	//	If liRC >=0 THen
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
	//	End If
	
		If lbError Then liRC = -1
			
	Case Else /*Sales Order or Invalid file type*/
		
		If Upper(Left(asFile,22)) = "IRONPORT_MENLO_TO_SHIP" Then /*Sales Order file*/
			
			liRC = uf_process_So(asPath, asProject)
			
			// 05/08 - PCONKL - We still want to process any valid orders if one/some have errors but we will want to return -1 so the error file is generated
			If liRC < 0 Then lbError = True

		
			//Process any added SO's
			//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
			//If liRC >=0 THen
				liRC = gu_nvo_process_files.uf_process_delivery_order( asProject ) 
			//End If
			
			If lbError Then liRC = -1
		
		Else /*Invalid File Type*/
		
			lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
			
		End If
		
End Choose

Return lirc
end function

public function integer uf_process_po (string aspath, string asproject);
Datastore	lu_ds, ldsItem

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsREcData, lsRecType, lsDesc, lsSKU, lsSupplier
Integer	liRC,liFileNo
Long	llNewRow, llNewDetailRow, llFindRow, llBAtchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID
Boolean	lbError, lbDetailError
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

//Open and read the File In
lsLogOut = '      - Opening File for Ironport Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Ironport Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData)) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsREcType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow,'project_id',asProject)
			idsPOheader.SetItem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow,'Status_cd','N')
			idsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
			idsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
			idsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
			End If
						
			idsPOheader.SetItem(llNewRow,'action_cd',lstemp) 
		
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Order Type 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Type' field. Record will not be processed.")
			End If
			
			idsPOheader.SetItem(llNewRow,'Order_type',lstemp) 
		
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
					
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = lsTemp
			idsPOheader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//No more required fields after Supplier
			
			//Supplier 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
		
			If lsTemp > '' Then
				lsSupplier = lsTemp /*used to build item master below if necessary*/
				idsPOheader.SetITem(llNewRow,'supp_code',lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Arrival_Date',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//Warehouse 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPOheader.SetItem(llNewRow,'wh_Code',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Carrier',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'Awb_bol_no',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Transport Mode
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'transport_mode',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Remarks
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'remark',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
				
		CASE 'PD' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
				
			//ACtion Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'ACtion Code' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'action_cd',lsTemp) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
		
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			//Make sure we have a header for this Detail...
			If idsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1,idsPoHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbDetailError = True
			End If
			
			idsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(lsTemp))

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Line Item Number' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			If Not isnumber(lsTemp) Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - 'Line Item' is not numeric. Record will not be processed.")
				lbDetailError = True
			Else
				idsPODetail.SetItem(llNewDetailRow,'line_item_no',Dec(Trim(lsTemp)))
			End If
		
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

		
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			lsSKU = lsTemp /*used to build itemmaster below*/
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsTemp)
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*hecked for numerics in nvo_process_files.uf_process_purcahse_Order*/

							
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
		// *** No more required fields...
		
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			If lsTemp > '' Then /*override default if present*/	
				idsPODetail.SetItem(llNewDetailRow,'Inventory_Type',lsTemp)
			End If
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//lot No (LPN)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Lot_no',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'po_no2',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Serial No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'Serial_No',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Expiration date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
		//	idsPODetail.SetItem(llNewDetailRow,'expiration_date',dateTime(lsTemp))
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//If detail errors, delete the row...
			if lbDetailError Then
				lbError = True
				idsPoDetail.DeleteRow(llNewDetailRow)
				Continue
			End If
				
			//We may receive a detail row for a new sku//supplier combination. If we have the sku for another supplier and this supplier is also valid, copy existing item to new supplier
			llCount = ldsItem.Retrieve(asProject, lsSKU)
			If llCount > 0 Then
				
				llFindRow = ldsItem.Find("Upper(Supp_code) = '" + upper(lsSupplier) + "'",1,ldsItem.RowCount())
				If llFindRow = 0 Then /*doesnt exist for this supplier*/
					
					//validate Supplier and if valid, create an item for the new supplier
					Select Count(*) into :llCount
					From Supplier
					Where Project_id = :asProject and supp_code = :lsSupplier;
					
					If llCount > 0 Then
						
						//Get Owner for this supplier
						Select Owner_id into :llOwnerID
						From Owner
						Where Project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSUpplier;
						
						If ldsItem.RowsCopy(ldsItem.RowCount(),ldsItem.RowCount(),Primary!,ldsItem,99999,Primary!) = 1 Then
							
							ldsItem.SetItem(ldsitem.RowCount(),'supp_code',lsSupplier)
							ldsItem.SetItem(ldsitem.RowCount(),'owner_id',llOwnerID)
							ldsItem.SetItem(ldsitem.RowCount(),'last_update',ldtToday)
							ldsItem.SetItem(ldsitem.RowCount(),'last_user','SIMSFP')
							lirc = ldsItem.Update()
							If liRC = 1 then
								Commit;
							Else
								Rollback;
							End If
							
						End If
						
					End If /*valid supplier*/
					
				End If  /*doesnt exist for this supplier*/
				
			End If /*Item exists for some supplier*/
			
		CAse Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
//Save the Changes 
lirc = idsPOHeader.Update()
	
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If
	
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

If lbError Then
	Return -1
Else
	Return 0
End If


end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Ironport

Datastore	ldsDOHeader, ldsDODetail,	ldsDOAddress, 	lu_ds, ldsDONotes, ldsDOBOM
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lsSupplier,	lsChildSKU,	lsFind,	&
				lsOrdType, lsOrder, lsOrderSave, lsDay, lsMonth, lsMonthNum, lsYear, lsReqDate

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llNewheaderRow, llNewDetailRow, llCount, llQty, llChildQty, 	llNewBOMRow, llPos, llLineItemNo, &
				llNewAddressRow, llFindRow, llBatchSeq, llOrderSeq, llLineSeq,  lLDetailFindROw, llRC
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbBillToAddress


ldtToday = DateTime(today(),Now())


lu_ds = Create datastore
lu_ds.dataobject = 'd_import_generic_csv'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_mercator_do_address'
ldsDOAddress.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = lu_ds.ImportFile(csv!,asPath) 
lu_ds.DeleteRow(1) /*First row is headers */


//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/
lsOrderSave = ""

//Make sure we are sorted by Order Number (column 3) and LIne (Column 1)
lu_ds.SetSort("column3 A, column1 A")
lu_ds.Sort()

//Delete any extra rows...
If lu_ds.RowCount() > 0 Then
	Do While (isNull(lu_ds.getITemString(1, 'column1')) or lu_ds.getITemString(1, 'column1') = '')
		lu_ds.DeleteRow(1)
	Loop
End If

llRowCount = lu_ds.RowCount()

lsLogOut = '      - ' + String(llRowCount) + " Rows imported for processing."
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Process each Row - already parsed out into generic columns above
For llRowPos = 1 to llRowCount 
	
	//If Order Changed, Add a new header Row
	lsOrder = Trim(lu_ds.getITemString(llRowPos, 'column3'))
	
	//If at any point we don't have an order number, reject the entire file - we won't be able to reconile
	If lsOrder = "" or isnull(lsOrder) Then
		gu_nvo_process_files.uf_writeError("Row: " + String(llRowPos) + " - Order number is missing. ENTIRE FILE will not be processed")
		Return -1
	End If
	
	//Header and detail information is in the same row, we will create a new header when the order number changes
	If lsOrder <> lsOrderSave Then
		
		llnewHeaderRow = ldsDOHeader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		
		//Record Defaults
		ldsDOHeader.SetItem(llnewHeaderRow,'ACtion_cd','A') /*always a new Order*/
		ldsDOHeader.SetITem(llnewHeaderRow,'project_id',asProject) /*Project ID*/
		ldsDOHeader.SetItem(llnewHeaderRow,'Inventory_Type','N') /*default to Normal*/
		ldsDOHeader.SetItem(llnewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
		ldsDOHeader.SetItem(llnewHeaderRow,'order_seq_no',llOrderSeq) 
		ldsDOHeader.SetItem(llnewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
		ldsDOHeader.SetItem(llnewHeaderRow,'Status_cd','N')
		ldsDOHeader.SetItem(llnewHeaderRow,'Last_user','SIMSEDI')
		ldsDOHeader.SetItem(llnewHeaderRow,'action_Cd',"A") /*always Add*/
		
		//From Record
		ldsDOHeader.SetItem(llnewHeaderRow,'invoice_no',lsOrder) /*Order Nmber*/
		
		//Order Type needs to be converted
		Choose Case Upper(Trim(lu_ds.getITemString(llRowPos, 'column4')))
				
			Case 'SOS' /*Standard Sale */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','S')
			Case 'SOE' /*Priority Sale */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','P')
			Case 'EOS' /*Standard Eval */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','E')
			Case 'EOE' /*Priority Eval */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','F')
			Case 'ROS' /*Advanced Replacement (Standard) */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','A')
			Case 'ROE' /*Advanced Replacement (Priority) */
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type','R')
			Case Else /*will reject in next step*/
				ldsDOHeader.SetItem(llnewHeaderRow,'order_type',Trim(lu_ds.getITemString(llRowPos, 'column4')))
				
		End Choose
				
		ldsDOHeader.SetItem(llnewHeaderRow,'Order_No',Trim(lu_ds.getITemString(llRowPos, 'column5'))) /*Customer ORder NUmber */
		ldsDOHeader.SetItem(llnewHeaderRow,'Cust_Name',Trim(lu_ds.getITemString(llRowPos, 'column6'))) /*customer Name*/
		ldsDOHeader.SetItem(llnewHeaderRow,'Cust_Code',Trim(lu_ds.getITemString(llRowPos, 'column7'))) /*Customer COde */
		ldsDOHeader.SetItem(llnewHeaderRow,'Address_1',Trim(lu_ds.getITemString(llRowPos, 'column8'))) /*Ship to attention of */
		ldsDOHeader.SetItem(llnewHeaderRow,'Address_2',Trim(lu_ds.getITemString(llRowPos, 'column9'))) /*Ship to Label */
		ldsDOHeader.SetItem(llnewHeaderRow,'Address_3',Trim(lu_ds.getITemString(llRowPos, 'column10'))) /*Ship To Address 1*/
		ldsDOHeader.SetItem(llnewHeaderRow,'Address_4',Trim(lu_ds.getITemString(llRowPos, 'column11'))) /*Ship To Address 2*/
		ldsDOHeader.SetItem(llnewHeaderRow,'City',Trim(lu_ds.getITemString(llRowPos, 'column12'))) /*Ship to City*/
		ldsDOHeader.SetItem(llnewHeaderRow,'State',Trim(lu_ds.getITemString(llRowPos, 'column13'))) /*Ship to State*/
		ldsDOHeader.SetItem(llnewHeaderRow,'zip',Trim(lu_ds.getITemString(llRowPos, 'column14'))) /*Ship to Zip */
		ldsDOHeader.SetItem(llnewHeaderRow,'Country',Trim(lu_ds.getITemString(llRowPos, 'column15'))) /*Ship to Country */
		ldsDOHeader.SetItem(llnewHeaderRow,'tel',Trim(lu_ds.getITemString(llRowPos, 'column16'))) /*Phone */
		
		If isdate(Trim(lu_ds.getITemString(llRowPos, 'column26'))) Then
			ldsDOHeader.SetItem(llnewHeaderRow,'request_Date',String(Date(Trim(lu_ds.getITemString(llRowPos, 'column26'))),'mm/dd/yyyy')) /*Requested Ship Date*/
		Else /*try and format it */
			
			//Should be in DD-MMM-YY format - need to reformat to yyyy/mm/dd
			If mid(Trim(lu_ds.getITemString(llRowPos, 'column26')),3,1) = '-' and mid(Trim(lu_ds.getITemString(llRowPos, 'column26')),7,1) = '-' Then
				
				lsDay = Left(lu_ds.getITemString(llRowPos, 'column26'),2)
				lsMonth = Mid(lu_ds.getITemString(llRowPos, 'column26'),4,3)
				lsYear = Mid(lu_ds.getITemString(llRowPos, 'column26'),8)
				
				Choose Case Upper(lsMonth)
					Case 'JAN'
						lsMonthNum = '01'
					Case 'FEB'
						lsMonthNum = '02'
					Case 'MAR'
						lsMonthNum = '03'
					Case 'APR'
						lsMonthNum = '04'
					Case 'MAY'
						lsMonthNum = '05'
					Case 'JUN'
						lsMonthNum = '06'
					Case 'JUL'
						lsMonthNum = '07'
					Case 'AUG' 
						lsMonthNum = '08'
					Case 'SEP'
						lsMonthNum = '09'
					Case 'OCT'
						lsMonthNum = '10'
					Case 'NOV'
						lsMonthNum = '11'
					Case 'DEC'
						lsMonthNum = '12'
					Case Else
						lsMonthNum = '00'
				End Choose
				
				If Len(lsyear) = 2 Then
					lsyear = '20' + lsyear
				End If
				
				lsReqdate = lsYear + '/' + lsMonthNum + '/' + lsDay
				
				If isdate(lsReqdate) Then
					ldsDOHeader.SetItem(llnewHeaderRow,'request_Date',lsReqdate) /*Requested Ship Date*/
				End If
				
			End If
			
		End If
		
		ldsDOHeader.SetItem(llnewHeaderRow,'Carrier',Trim(lu_ds.getITemString(llRowPos, 'column27'))) /*Carrier*/
		
		ldsDOHeader.SetItem(llnewHeaderRow,'User_field8',Trim(lu_ds.getITemString(llRowPos, 'column28'))) /*Carrier Service Level -> UF 8*/
		ldsDOHeader.SetItem(llnewHeaderRow,'User_Field9',Trim(lu_ds.getITemString(llRowPos, 'column29'))) /*3rd party carrier Account (UF9) */
		ldsDOHeader.SetItem(llnewHeaderRow,'Shipping_Instructions_text',Trim(lu_ds.getITemString(llRowPos, 'column31'))) /*Special Instructions */
		ldsDOHeader.SetItem(llnewHeaderRow,'wh_code',Trim(lu_ds.getITemString(llRowPos, 'column46')))
		ldsDOHeader.SetItem(llnewHeaderRow,'Freight_Terms',Trim(lu_ds.getITemString(llRowPos, 'column47')))
		
		
		//If we have Bill To Information create the Alt Address record
		If Trim(lu_ds.getITemString(llRowPos, 'column18')) > "" or & 
			Trim(lu_ds.getITemString(llRowPos, 'column19')) > "" or &
			Trim(lu_ds.getITemString(llRowPos, 'column20')) > "" or &
			Trim(lu_ds.getITemString(llRowPos, 'column21')) > "" or &
			Trim(lu_ds.getITemString(llRowPos, 'column22')) > "" or &
			Trim(lu_ds.getITemString(llRowPos, 'column23')) > ""  		Then
			
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
		
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lu_ds.getITemString(llRowPos, 'column18'))
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lu_ds.getITemString(llRowPos, 'column19'))
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lu_ds.getITemString(llRowPos, 'column20'))
				ldsDOAddress.SetItem(llNewAddressRow,'address_3',lu_ds.getITemString(llRowPos, 'column21'))
				ldsDOAddress.SetItem(llNewAddressRow,'address_4',"")
				ldsDOAddress.SetItem(llNewAddressRow,'City',lu_ds.getITemString(llRowPos, 'column22'))
				ldsDOAddress.SetItem(llNewAddressRow,'State',lu_ds.getITemString(llRowPos, 'column23'))
				ldsDOAddress.SetItem(llNewAddressRow,'Zip',lu_ds.getITemString(llRowPos, 'column24'))
				ldsDOAddress.SetItem(llNewAddressRow,'Country',lu_ds.getITemString(llRowPos, 'column25'))
				ldsDOAddress.SetItem(llNewAddressRow,'tel',"")
				
		End If /*alt address exists*/
		
		
	End If /* New ORder*/
	
	lsOrderSave = lsOrder
	
	
	//Always adding a new detail row...
	
	llnewDetailRow = ldsDODetail.InsertRow(0)
	llLineSeq ++ 
						
	//Add detail level llnewDetailRow
	ldsDODetail.SetITem(llnewDetailRow,'project_id', asproject) /*project*/
	ldsDODetail.SetITem(llnewDetailRow,'Inventory_Type', 'N')
	ldsDODetail.SetITem(llnewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
	ldsDODetail.SetITem(llnewDetailRow,'order_seq_no',llOrderSeq) 
	ldsDODetail.SetITem(llnewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
	ldsDODetail.SetITem(llnewDetailRow,'Status_cd','N')
	ldsDODetail.SetItem(llNewDetailRow,'invoice_no',Trim(lsOrder))
	
	//Commercial Invoice Value (UF1)
	ldsDODetail.SetItem(llnewDetailRow,'User_Field1',Trim(lu_ds.getITemString(llRowPos, 'column30')))
	
	//Line Item Number
	If isNumber(Trim(lu_ds.getITemString(llRowPos, 'column1'))) Then
		ldsDODetail.SetItem(llnewDetailRow,'line_item_no',Long(Trim(lu_ds.getITemString(llRowPos, 'column1')))) /*sequential number per order*/
		llLineItemNo = Long(Trim(lu_ds.getITemString(llRowPos, 'column1'))) /*used to create BOM below*/
	Else
		gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Line Item Number is not numeric. Order will not be processed ")
		lbError = True
		ldsDODetail.SetItem(llnewDetailRow,'status_cd','E') /*Don't want to process record in next step*/
	End If
			
	
	//SKU (Parent)
	ldsDODetail.SetItem(llNewDetailRow,'SKU',Trim(lu_ds.getITemString(llRowPos, 'column32')))
	lsSKU = Trim(lu_ds.getITemString(llRowPos, 'column32'))
			
	
	//Quantity (Parent)
	If isNumber(Trim(lu_ds.getITemString(llRowPos, 'column34'))) Then
		ldsDODetail.SetItem(llNewDetailRow,'quantity',Trim(lu_ds.getITemString(llRowPos, 'column34')))
		llqty = long(Trim(lu_ds.getITemString(llRowPos, 'column34')))
	Else
		gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - (Parent) Quantity is not numeric. Order will not be processed")
		ldsDODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process record in next step*/
		lbError = True
	End If
	
	//SKU (Child)
	lsChildSKU = Trim(lu_ds.getITemString(llRowPos, 'column35'))
		
	//Quantity (Child) - This is the total child qty (Not the Unit qty per parent)
	If isNumber(Trim(lu_ds.getITemString(llRowPos, 'column37'))) Then
		
		//Convert to unit qty (total child qty/ parent qty)
		If llQty > 0 Then
			llChildqty = long(Trim(lu_ds.getITemString(llRowPos, 'column37'))) / llQty
		End If
	Else
		gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - (Child) Quantity is not numeric. Order will not be processed")
		ldsDODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process record in next step*/
		lbError = True
	End If
	
	// 05/08 - PCONKL - Sales Order Line (needed on the GI) -> UF2
	ldsDODetail.SetItem(llNewDetailRow,'user_Field2',Trim(lu_ds.getITemString(llRowPos, 'column48')))
	
	//If Child SKU <> Parent SKU, we need to create a A delivery_Bom record for the child...
	If lsChildSku <> lsSKu Then
		
		llNewBOMRow = ldsDOBOM.InsertRow(0)
		ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
		ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
		ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
		ldsDOBOM.SetItem(llNewBOMRow,'line_item_no',llLineItemNo) 
		ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsSKU) 
		ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsChildSku) 
		ldsDOBOM.SetItem(llNewBOMRow,'child_Qty',llChildQty) 
						
		//We need both the parent/child supplier - any will do...
		Select Min(supp_Code) into :lsSupplier
		From Item_MAster
		Where PRoject_ID = :asProject and sku = :lsSku;
		
		If lsSupplier > "" Then
			ldsDOBOM.SetItem(llNewBOMRow,'supp_code_parent',lsSupplier) 
		End If
				
		Select Min(supp_Code) into :lsSupplier
		From Item_MAster
		Where PRoject_ID = :asProject and sku = :lsChildSku;
		
		If lsSupplier > "" Then
			ldsDOBOM.SetItem(llNewBOMRow,'supp_code_child',lsSupplier) 
		Else /*Child ITem does not exist*/
			gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Child SKU: '" + lsChildSku + "' Does not exist. Record will not be processed.")
			ldsDODetail.SetItem(llNewDetailRow,'status_cd','E') /*Don't want to process record in next step*/
			ldsDOBOM.DeleteRow(llNewBomRow)
			lbError = True
			Continue /*Process Next Record */
		End If
					
	End If /*Child SKU exists */
	
	
Next /*import record */



//Save Changes
liRC = ldsDOHeader.Update()

If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If

If liRC = 1 Then
	liRC = ldsDOAddress.Update()
End If

If liRC = 1 Then
	liRC = ldsDOBOM.Update()
End If



If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new SO Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

If lbError Then Return -1




Return 0
end function

public function integer uf_process_dboh (string asinifile, string asemail);Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsInv

	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Ironport Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

//Create the Datastore...
sql_syntax = "SELECT WH_Code, SKU, inventory_type, l_code,  Sum( Avail_Qty  ) + Sum( alloc_Qty  ) as total_qty   " 
sql_syntax += "from Content_Summary"
sql_syntax += " Where Content_Summary.Project_ID = 'IRONPORT' and l_code <> 'N/A' " /*l_Code = N/A is parent placeholder, don't want to include */
sql_syntax += " Group by Wh_Code, SKU, Inventory_Type, l_code "
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  ) > 0; "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Ironport Inventory Snapshot ID data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)


//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llRowCount < 1 Then 
	Return 0
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("IRONPORT",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Ironport BOH file. Confirmation will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write to archive file 
lsFileName = ProfileString(asInifile,"Ironport","archivedirectory","") + '\' + "BH" + String(ldBatchSeq,"0000000000")  + ".csv"

//Open and spool the file
liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Ironport Daily Inventory Snapshot file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write a header record...
lsOutString = "Warehouse,SKU,Inventory Type,Location,Qty"
FileWrite(liFileNo,lsOutString)

//For each INventory Row, write a csv record
For llRowPos = 1 to llRowCount
	
	lsOutstring = ""
	
	lsOutString += ldsInv.GetITemString(llRowPos,'wh_code') + ","
	lsOutString += ldsInv.GetITemString(llRowPos,'SKU') + ","
	lsOutString += ldsInv.GetITemString(llRowPos,'inventory_type') + ","
	lsOutString += ldsInv.GetITemString(llRowPos,'l_code') + ","
	lsOutString += String(ldsInv.GetITemNumber(llRowPos,'total_qty'),'##########')
	
	FileWrite(liFileNo,lsOutString)
	
Next /*Inventory Record */

//Close the file and email...
FileClose(liFileNo)

If pos(asEmail,"@") > 0 Then
	gu_nvo_process_files.uf_send_email("Ironport",asEmail,"XPO Logistics WMS - Daily Inventory Snaphot File","  Attached is the Daily Inventory Snapshot file...",lsFileName)
Else /*no valid email, send an email to the file transfer error dist list*/
	gu_nvo_process_files.uf_send_email("Ironport",'FILEXFER',"Unable to email Daily shipment file to Ironport","Unable to email Daily Inventory Snaphot file to Ironport - no email address found - file is still archived","")
End If

Return llrowCount
end function

public function integer uf_process_weekly_shipment_file (string asinifile, string asemail);Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty
String	lsOutString,  lsLogOut,  lsFIleName
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsOrders

	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Ironport Weekly Orders Shipped and Open Orders File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsOrders = Create Datastore

//Create the Datastore...

// Picked or completed orders not previously transmitted
sql_syntax = " SELECT Request_Date as 'Request_Date', Ord_Date as 'Ord_Date', Complete_Date as 'Complete_Date', "
sql_syntax += " Ord_Status as 'Ord_Status', Cust_Name as 'Cust_Name', Address_1 as 'Address_1', Address_2 as 'Address_2', "
sql_syntax += " Address_3 as 'Address_3', Address_4 as 'Address_4', City as 'City', State as 'State',  "
sql_syntax += " Zip as 'Zip',Country as 'Country',Invoice_No as 'Invoice_no', Cust_Order_No as 'Cust_Order_No', "
sql_syntax += " Carrier as 'Carrier',Freight_Terms as 'Freight_Terms', dbo.Delivery_Master.User_Field8 as 'User_Field8', Shipping_Instructions as 'Shipping_instructions', "
sql_syntax += " Serialized_ind as 'Serialized_ind', Case When delivery_serial_Detail.Serial_no > '' Then 1 Else dbo.Delivery_Picking_Detail.Quantity  End as 'ship_qty', "
sql_syntax += " dbo.Delivery_Picking_Detail.SKU as 'SKU', dbo.Delivery_Serial_Detail.Serial_No as 'Serial_No', "
sql_syntax += " (Select Max(shipper_tracking_id) from Delivery_PAcking where do_no = delivery_picking_detail.do_no and Line_item_no = Delivery_picking_detail.Line_item_no and carton_no = delivery_serial_Detail.carton_no) as 'shipper_tracking_ID' "
sql_syntax += " FROM dbo.Delivery_Picking_Detail LEFT OUTER JOIN dbo.Delivery_Serial_Detail ON dbo.Delivery_Picking_Detail.ID_No = dbo.Delivery_Serial_Detail.ID_No, "
sql_syntax += " dbo.Delivery_Master, dbo.ITem_MAster "
sql_syntax += " WHERE ( dbo.Delivery_Picking_Detail.DO_No = dbo.Delivery_Master.DO_No ) and Item_MAster.PRoject_id = Delivery_MASter.Project_ID and "
sql_syntax += " Item_MAster.SKU = DElivery_Picking_Detail.SKU and	ITem_MAster.Supp_Code = Delivery_Picking_Detail.Supp_Code "
sql_syntax += " and Delivery_MAster.Project_ID = 'Ironport' and ord_status <> 'V' and (complete_date is null or (complete_date is not null and file_transmit_ind is null)) "

//Union with open non picked orders
sql_syntax += " Union "

sql_syntax += " SELECT Request_Date as 'Request_Date',Ord_Date as 'Ord_Date', Complete_Date as 'Complete_Date', Ord_Status as 'Ord_Status', "
sql_syntax += " Cust_Name as 'Cust_Name',Address_1 as 'Address_1', Address_2 as 'Address_2', Address_3 as 'Address_3', Address_4 as 'Address_4', "
sql_syntax += " City as 'City',State as 'State',Zip as 'Zip',Country as 'Country', "
sql_syntax += " Invoice_No as 'Invoice_No',Cust_Order_No as 'Cust_Order_No',Carrier as 'Carrier', Freight_Terms as 'Freight_Terms', "
sql_syntax += " dbo.Delivery_Master.User_Field8 as 'user_Field8', Shipping_Instructions as 'Shipping_instructions',Serialized_ind as 'Serialized_Ind',	dbo.Delivery_Detail.Req_Qty as 'ship_qty', "
sql_syntax += " dbo.Delivery_Detail.SKU as 'SKU', '' as 'serial_no', '' as 'shipper_tracking_ID' "
sql_syntax += " FROM dbo.Delivery_Master, Delivery_Detail,	Item_MAster "
sql_syntax += " WHERE ( dbo.Delivery_Master.DO_No = dbo.Delivery_Detail.DO_No ) and delivery_Detail.alloc_qty = 0 and "
sql_syntax += " Item_MAster.PRoject_id = Delivery_MASter.Project_ID and Item_MAster.SKU = DElivery_Detail.SKU and "
sql_syntax += " ITem_MAster.Supp_Code = Delivery_Detail.Supp_Code "
sql_syntax += " and Delivery_MAster.Project_ID = 'Ironport' and ord_status <> 'V'"

ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Ironport Weekly Orders Shipped and open Orders data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsOrders.SetTransobject(sqlca)


//Retrieve the Inv Data
lsLogout = 'Retrieving Order Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsOrders.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llRowCount < 1 Then 
	Return 0
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("IRONPORT",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Ironport Orders Shipped file. "
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write to archive file 
lsFileName = ProfileString(asInifile,"Ironport","archivedirectory","") + '\' + "Ironport Shipments" + String(ldBatchSeq,"0000000000")  + ".csv"

//Open and spool the file
liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Ironport Weekly Shipment file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write a header record...
lsOutString = "Schedule Date,Order Date, Complete Date, Order Status, Customer Name, Sold To, Address 1, Address 2, City, State,"
lsOutString += "Zip, Country, Order Number,Customer PO, Carrier, Freight Terms, Shipment Method,Shipping Instructions, Serial Req, Qty,"
lsOutString += "SKU, Serial Number, Tracking ID"

FileWrite(liFileNo,lsOutString)

//For each Shipment Row, write a csv record
For llRowPos = 1 to llRowCount
	
	lsOutstring = ""
	
	If not isNUll(ldsOrders.GetITemDateTime(llRowPos,'request_date')) Then
		lsOutString += String(ldsOrders.GetITemDateTime(llRowPos,'request_date'),'mm/dd/yyyy') + ","
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemDateTime(llRowPos,'ord_date')) Then
		lsOutString += String(ldsOrders.GetITemDateTime(llRowPos,'ord_date'),'mm/dd/yyyy') + ","
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemDateTime(llRowPos,'complete_date')) Then
		lsOutString += String(ldsOrders.GetITemDateTime(llRowPos,'complete_date'),'mm/dd/yyyy') + ","
	Else
		lsOutString += ","
	End If
	
	Choose Case ldsOrders.getITemString(llRowPos, 'ord_status')
		Case 'N'
			lsOutString += "New,"
		Case 'P'
			lsOutString += "Process,"
		Case 'I'
			lsOutString += "Picking,"
		Case 'A'
			lsOutString += "Packing,"
		Case 'C'
			lsOutString += "Complete,"
		Case 'R'
			lsOutString += "Ready,"
		Case else
			lsOutString += ","
	End Choose
			
	If not isNUll(ldsOrders.GetITemString(llRowPos,'Cust_name')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Cust_name') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'address_2')) Then /*Sold To*/
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'address_2') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'address_3')) Then 
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'address_3') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'address_4')) Then 
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'address_4') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'city')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'city') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'state')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'state') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'zip')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'zip') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'country')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'country') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'invoice_no')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'invoice_no') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'cust_order_no')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'cust_order_no') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'carrier')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'carrier') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'freight_terms')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'freight_terms') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'user_Field8')) Then /*Shipment Method*/
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'user_Field8') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'shipping_instructions')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'shipping_instructions') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'serialized_ind')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'serialized_ind') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemNumber(llRowPos,'ship_qty')) Then
		lsOutString +=  String(ldsOrders.GetITemNumber(llRowPos,'ship_qty'),'#########') + ","
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'SKU')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'SKU') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'serial_no')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'serial_no') + '",'
	Else
		lsOutString += ","
	End If
	
	If not isNUll(ldsOrders.GetITemString(llRowPos,'shipper_tracking_id')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'shipper_tracking_id') + '"'
//	Else
//		lsOutString += ","
	End If
	
	
	FileWrite(liFileNo,lsOutString)
	
Next /*Shipment Record */

//Close the file and email...
FileClose(liFileNo)

If pos(asEmail,"@") > 0 Then
	gu_nvo_process_files.uf_send_email("Ironport",asEmail,"XPO Logistics WMS - Weekly Shipment and Open Orders File","  Attached is the Daily Inventory Snapshot file...",lsFileName)
Else /*no valid email, send an email to the file transfer error dist list*/
	gu_nvo_process_files.uf_send_email("Ironport",'FILEXFER',"Unable to email Weekly shipment file to Ironport","Unable to email Weekly Shipment file to Ironport - no email address found - file is still archived","")
End If


//TODO - Update the File Transmit INdicator



Return llrowCount
end function

on u_nvo_proc_ironport.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ironport.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
Destroy	idsPoHeader
Destroy idsPODetail

end event

