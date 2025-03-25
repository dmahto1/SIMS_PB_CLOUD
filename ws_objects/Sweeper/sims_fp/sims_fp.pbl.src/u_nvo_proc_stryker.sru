$PBExportHeader$u_nvo_proc_stryker.sru
forward
global type u_nvo_proc_stryker from nonvisualobject
end type
end forward

global type u_nvo_proc_stryker from nonvisualobject
end type
global u_nvo_proc_stryker u_nvo_proc_stryker

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

end variables

forward prototypes
public function integer uf_process_purchase_order (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_dboh (string asproject, string asinifile)
public function integer uf_process_itemmaster (string aspath, readonly string asproject)
public function string uf_convert_doc_type (string as_doc_type)
public function integer uf_update_delivery_order (string aspath, string asproject)
public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail)
public function integer uf_update_item_master_flags (string as_project, string as_sku, string as_supplier)
protected function integer uf_process_delivery_order (string aspath, string asproject)
public function integer uf_process_oc_file (string aspath, string asproject)
end prototypes

public function integer uf_process_purchase_order (string aspath, string asproject);

//Load Purchase Order - Transaction Type (IN) -Stock In


//1.	IN EDI – Inbound orders EDI
//a)	This EDI comes into Menlo AFTER Menlo ops scanned the SKUs, lot#/ serial#, expiry and MFG dates and uploaded into Stryker’s system (called the Barcode Web).
//b)	There are 3 sections in the EDI – header, detail and Lot detail.
//c)	The lot detail will be loaded into the putaway table once we generate it.
//d)	For the Lot Detail field 10 (Lot Barcode), this also contains the serial# if the SKU is a serialized item. We can load this field into the Lot# field in Putaway. Therefore, all items do not need to be setup as serialized in item master.
//e)	The field = Warehouse No. will indirectly determine the inventory types, which can be Saleable, Demo or Loaner. Stryker will provide this list soon.
//f)	For inbound, after we confirm the inbound orders, there’s no need to send back receipt confirmation. From pt #1 above, the scanned data serves as confirmation to Stryker that the receipt is completed.
//g)	So, for the entire inbound order process, only 1 EDI is involved.
//

// 04/14 - PCONKL - New file formats

STRING lsTemp, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsTempNote, lsStrykerWarehouse, lsUOM, lsFind
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo,llDetailFindRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsNull
DATE ld_ReceiptDate
STRING lsInventoryType
DATETIME ldtWHTime

SetNull(lsNull)

u_ds_datastore	ldsPOHeader,	&
				     ldsPODetail, &
					 ldsImport

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_baseline_unicode_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_baseline_unicode_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Purchase Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Purchase Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Loop through

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Purchase Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))



//Lot Detail				
//Sr#	File Column	DB Column	Data Type	
//1	Transaction Type	IN	Char(2) 	
//2	Record Type	LD	Char(2) 	
//3	Line No	Line No	Char(20) 	New
//4	Sub Line No	Sub Line No	Char(20) 	
//5	Document No	Doc Type + Doc No	Char(20) 	
//6	Item No	Stryker Item No	Char(30)	
//7	Quantity	Quantity	Number(38)	
//8	Lot No **	Lot No	Char(45)	
//9	Expiry Date		Date	
//10	MFG Date		Date	
//11	Lot Barcode	Lot barcode	Char(35)	
//12	Item Barcode	Item barcode	Char(35)	
//				

//				
//** Same Lot No could have different expiry date and MFG date				
//

	//1	Transaction Type	IN	Char(2)
	//1	Transaction Type	IN	Char(2) 
	//1	Transaction Type	IN	Char(2) 


	// 04/14 - PCONKL - Transaction Type should now be 'IC' instead of 'IN'
	
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
//	If NOT (lsTemp = 'IN') Then
	If NOT (lsTemp = 'IC') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Transaction Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If


	//2	Record Type	HD	Char(2)
	//2	Record Type	DT	Char(2) 		
	//2	Record Type	LD	Char(2) 	
	
	//Validate Rec Type is HD, DT OR LD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
	If NOT (lsTemp = 'HD' OR lsTemp = 'DT' OR lsTemp = 'LD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		Case 'HD' /*IN Header*/

			lsChangeID = "A"
			lsSupplier = "IN_STRYKER"

			//3	Detail Count	Detail Line Count	Number(6) 	

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col3")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Count	Detail Line Count is required. Record will not be processed.")
				lbError = True
				Continue		
			Else

				llOrderSeq = long(lsTemp)

			End If					
				
			//4	Document No	Doc Type + Doc No	Char(20) 	

			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col4")))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Document No is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
				
				lsOrderType = left(lsTemp, 2)
				
				lsOrderType = uf_convert_doc_type(lsOrderType)
		
			End If					
							
			
			//5	Receipt Date	ReceiptDate	Date	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " -	Receipt Date is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ld_ReceiptDate = date(lsTemp)
			End If					
				
				
			//6	Warehouse No	Warehouse No	Char(18) 	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " -	Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
				SELECT dbo.Lookup_table.User_Field1 INTO :lsInventoryType
				  	FROM dbo.Lookup_Table  
					  WHERE dbo.Lookup_Table.Project_ID = :asproject AND 
					  			dbo.Lookup_Table.Code_type = 'STRWH' AND 
								  dbo.Lookup_Table.Code_ID = :lsTemp
							USING SQLCA;
				
				if SQLCA.SQLCode = 100 OR SQLCA.SQLCode < 0 then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Warehouse No: '" + lsTemp + "'. Record will not be processed.")
					lbError = True
					Continue							
				end if
	
				
	//			lsInventoryType = "S"
				
				lsStrykerWarehouse = lsTemp
				
				lsWarehouse = "HSY_DELHI"
				
			End If		
		
				

			/* End Required */		
			
			liNewRow = 	ldsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsPOheader.SetItem(liNewRow,'project_id',asProject)
			ldsPOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
//			ldsPOheader.SetItem(liNewRow,'Request_date',String(ld_ReceiptDate,'YYMMDD'))


			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			ldsPOheader.SetItem(liNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
			
			ldsPOheader.SetItem(liNewRow,'arrival_date',String(ld_ReceiptDate,'YYMMDD'))
			
			ldsPOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(liNewRow,'Status_cd','N')
			ldsPOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsPOheader.SetItem(liNewRow,'Order_No',lsOrderNumber)			
			ldsPOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Typer*/
			ldsPOheader.SetItem(liNewRow,'Inventory_Type','N') /*default to Normal*/
		
			ldsPOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPOheader.SetItem(liNewRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			
			//04/014 - PCONKL - Column7 - Stryker Order No -> Rcv Slip Nbr (Ship_Ref)
			ldsPOheader.SetItem(liNewRow,'Ship_Ref',Trim(ldsImport.GetItemString(llFileRowPos, "col7")))
			
			
			// 04/14 - PCONKL - NOTES ARE NOW IN COLUMN 8
			
			//8Notes *	Notes	Char(2000)			
			//* For Warehouse No = Salesman Warehouse				
			//8	Notes	Notes		SIMS Order Information field

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
			//8.1	Salesteam Code	Sales Team	Char(4)	user field 4
			
			lsTempNote = left(lsTemp,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'user_field4', lsTempNote)
			End If			
			
			//With reference to the EDI format that I sent previously, for the IN worksheet on row 38 (as below), the salesman code may have some values (if Doc Type = TQ). In such cases, can we have the saleman code to be populated onto the location during putaway?

			//8.2	Salesman Code	Salesman Code	Char(4)	user field 5 
			
			
			//8.2	Salesman Code	Salesman Code	Char(4)	user field 5
			
			lsTempNote = mid(lsTemp,5,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'user_field5', lsTempNote)
			End If				
						
			//8.3	Salesman Name	Salesman Name	Char(40)	user field 6
	
			lsTempNote = mid(lsTemp,9,6)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'user_field6', lsTempNote)
			End If	
			
			//8.4	Salesman Address Line 1	Salesman Address Line 1	Char(40)	user field 7
			
			lsTempNote = mid(lsTemp,15,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'user_field7', lsTempNote)
			End If			
			
			//8.5	Salesman Address Line 2	Salesman Address Line 2	Char(40)	user field 8
			
			lsTempNote = mid(lsTemp,55,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'user_field8', lsTempNote)
			End If				
			
			
			//8.6	Notes	Notes	Char(1872)	Remark (char 255)
	
			lsTempNote = mid(lsTemp,95)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsPOheader.SetItem(liNewRow,'Remark', lsTempNote)
			End If		

			
			//04/014 - PCONKL - Column9 - Company Code ->UF1
			ldsPOheader.SetItem(liNewRow,'User_Field1',Trim(ldsImport.GetItemString(llFileRowPos, "col9")))
			
		//Detail				
				
		CASE 'DT' /* detail*/
		
		
		//1	Transaction Type	IN	Char(2) 
		//2	Record Type	DT	Char(2) 
		//3	Line No	Line No	Char(20) 
		//4	Document No	Doc Type + Doc No	Char(20) 
		//5	Item No	Stryker Item No	Char(30)
		//6	Quantity	Quantity	Number(38)
		//7	Item Description	Item Description	Char(45)
	
		// 04/14 - PCONKL - Layout changes changes
		//1	Transaction Type	IN	Char(2) 
		//2	Record Type	DT	Char(2) 
		//3	Line No	Line No	Char(20) 
		//5	Item No	Stryker Item No	Char(30)
		//6 Supplier Code (Sims SUpplier is Stryker Supplier + "-" + UOM
		//7Quantity	Quantity	Number(38)
		//8 UOM
		//9 GTIN
		
		// 04/14 - PCONKL - The EDI_INbound_Detail record is a combination of the DT and LD records but we don;t want to create EDI records for both
		//	We will stage them here so that when we write the LD records, we can get the info we need from the DT records (Supplier, UOM, GTIN)
		
		//	lsChangeID = "A"
		//	lsSupplier = "STRYKER" /* 04/14 - PCONKL - Supplier is Supplier + '-' + UOM

			//3	Line No	Line No	Char(20) 	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If			
					
			//5	Item No	Stryker Item No	Char(30)	
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Stryker Item No is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If			
			
//			//6	 Supplier /* 04/14 - PCONKL */
//	
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Stryker Supplier is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				lsSupplier = lsTemp
//			End If			
//					
//			//Strip any leading zeros off SUpplier
//			Do While Left(lsSupplier,1) = '0'
//				lsSupplier = Mid(lsSupplier,2,99)
//			Loop
			
			//6	Quantity	Quantity	Number(38)	

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			//7 UOM /* 04/14 - PCONKL */
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsUOM = lsTemp
			End If			
			
			
			/* End Required */
		
			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInventoryType) 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd','X')  /*We'll delete these before we save*/

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			
			//04/14 - PCONKL - Supplier is SRYKER + "-" + UOM
			ldsPODetail.SetItem(llNewDetailRow,'Supp_Code', "STRYKER-" + lsUOM) /*Supplier Code*/	
			ldsPODetail.SetItem(llNewDetailRow,'UOM',lsUOM) 
			
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			//8 GTIN /* 04/14 - PCONKL */
			ldsPODetail.SetItem(llNewDetailRow,'po_no2',Trim(ldsImport.GetItemString(llFileRowPos, "col8"))) 
			
			//Supplier going in DD UF1
			ldsPODetail.SetItem(llNewDetailRow,'User_Field1',lsSupplier) 
			
			
			
		CASE 'LD' /* Lot Detail */

			
			lsChangeID = "A"
			//lsSupplier = "STRYKER"

			//3	Line No	Line No	Char(20) 
	
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If			
			
			//4	Sub Line No	Sub Line No	Char(20) 
			
				lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - 	Sub Line No is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
//				llLineItemNo = Long(lsTemp)
			End If			
			
			
		
			//5	Document No	Doc Type + Doc No	Char(20) 
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
							
				//Make sure we have a header for this Detail...
				If ldsPoHeader.Find("Upper(order_no) = '" + Upper(lstemp) + "'",1, ldsPoHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
					Continue
				End If
					
				lsOrderNumber = lsTemp
				
			End If			
						
			//6	Item No	Stryker Item No	Char(30)
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Stryker Item No is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If			
					
			//7	Quantity	Quantity	Number(38)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			
		
			// 04/14 - PCONKL - we need fields from the DT record. Make sure it exists
			lsFind = "Upper(order_no) = '" + Upper(lsOrderNumber) +"' and line_item_No = " + string(llLineItemNo) + " and upper(SKU) = '" + upper(lsSKU) + "' and action_cd = 'X'"
			llDetailFindRow = ldsPODetail.Find(lsFind,1,ldsPoDetail.RowCount())
			If llDetailFindRow < 1 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - No DT record found for LD record. Record will not be processed.")
				lbDetailError = True
				Continue
			End If
			
			/* End Required */

			lbDetailError = False
			llNewDetailRow = 	ldsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInventoryType) 
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNumber)			
			ldsPODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsPODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			
			ldsPODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsPODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/			
			
			ldsPODetail.SetItem(llNewDetailRow,'PO_No', lsStrykerWarehouse)
			
			// 04/14 - PCONKL - We need tome fields from the DT record since they won't be written to EDI Inbound
			If llDetailFindRow > 0 Then
				
				ldsPODetail.SetItem(llNewDetailRow,'Supp_Code',ldsPoDetail.GetItemString(llDetailFindRow,'Supp_Code')) /*Supplier Code*/	
				ldsPODetail.SetItem(llNewDetailRow,'UOM',ldsPoDetail.GetItemString(llDetailFindRow,'UOM')) 
				ldsPODetail.SetItem(llNewDetailRow,'po_no2',ldsPoDetail.GetItemString(llDetailFindRow,'po_no2')) 
				ldsPODetail.SetItem(llNewDetailRow,'User_Field1',ldsPoDetail.GetItemString(llDetailFindRow,'User_Field1')) 
				
			End If
			
			//8	Lot No **	Lot No	Char(45)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Lot_No', lsTemp)
			End If				
			
			//9	Expiry Date		Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsPODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
				// TAM 2013/09/23 -  If the expiry Date is present the check the Item Master update fields where needed.	
			//	uf_update_item_master_flags (asproject, lssku, lssupplier)	/* 04/14 - PCONKL - no longer required*/			
	
			End If					
			
			//TODO - May need to add MFG Date, Lot and Item Barcodes to	Putaway User FIelds. not currently supported.

			
		CASE Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
			Continue
		
	End Choose /*record Type*/
	
Next /*File record */
	
IF lirc = -1 then lbError = true else lbError = false	
	
//Save the Changes 

//Delete the temporary DT records. The LD records are actually being written to EDI Detail with fields temporarily stored in the DT records
llFilerowCount = ldsPODetail.RowCount()
For llFileRowPos = llFileRowCOunt to 1 Step - 1
	If ldsPoDetail.GetITemString(llFileRowPos,'action_cd') = 'X' Then
		ldsPODetail.DeleteRow(llFileRowPos)
	End If
Next

SQLCA.DBParm = "disablebind =0"
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If
SQLCA.DBParm = "disablebind =1"	

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

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC
integer 	liLoadRet, liProcessRet
Boolean	bRet

Choose Case Upper(Left(asFile,2))
		
	//Case  'IN' 
	Case  'IC'  /* 04/14 - PCONKL - IC is new naming convention for Inboud Orders*/
		
		liRC = uf_process_purchase_order(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject)  
		
	//Case  'PK', 'OT'
	Case 'OO' /* 05/14 - PConkl - OO is new format */
		
		
		liLoadRet = uf_process_delivery_order(asPath, asProject)
			
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liProcessRet = gu_nvo_process_files.uf_process_Delivery_order( asProject )
		
		
		if liLoadRet = -1 OR liProcessRet = -1 then liRC = -1 else liRC = 0

	Case 'IM'
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		
	Case 'OC'
		
		liRC = uf_Process_oc_file(asPath, asProject)
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_dboh (string asproject, string asinifile);
//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse, &
				lsSku, lsLineItemNo, lsTemp, ls_Qty, lsSupplier,lsRONO, lsUOM, lsGTIN

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtWHTime

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_stryker_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//lsProject = ProfileString(asInifile, asproject,"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(asproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(asproject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/


lsWarehouse = "HSY_DELHI"
	
ldtWHTime = f_getLocalWorldTime(lsWarehouse)

// 07/14 - PCONKL - Changed file naming
//lsFilename = ("IB" + string(today(), "YYMMDDHH")  + ".txt")
lsFilename = ("IV_MENLO_" + string(today(), "YYYYMMDD_HHMMSS")  + ".txt")

For llRowPos = 1 to llRowCOunt

	// 05/14 - PCONKL - New format...
	
	
	llNewRow = ldsOut.insertRow(0)
	

	//K1TYPE	Type	2		1	2	Always mark 'IB'	Ok	"IB"
	lsOutString = 'IB' //+ lsDelimitChar
	
	//05/14 - PCONKL - Entity Code
	lsOutString += "00550"
	
	//K1MCU	Warehouse code	18		3	20		Warehouse code is 5 digits. Do you want this field to be padded with 13 0s in front, e.g. 000000000000055061?	Inventory PO Nbr
	lsWarehouse = ldsboh.GetItemString(llRowPos,'po_no')
	If IsNull(lsWarehouse) OR trim(lsWarehouse) = "-" then lsWarehouse = ""

	lsOutString +=   lsWarehouse +  Space ( 18 - len(lsWarehouse))  //+ lsDelimitChar
	
	//K1SLSM	Salesman 	4	0	21	24	No use. Reserve for future	Ok	<Blank>
	lsOutString += space(4) //+ lsDelimitChar
	
	//K1SLM2	SalesTeam	4	0	25	28	No use. Reserve for future	Ok	<Blank>
	lsOutString += space(4) //+ lsDelimitChar

	//K1LITM	Item Number	30		29	58	JDE Item number	Ok	Inventory SKU
	// 05/15 - PCONKL - Item now 25
	lsSku = ldsboh.GetItemString(llRowPos,'sku') //+ lsDelimitChar
	lsOutString +=  lsSku + Space ( 25 - len(lsSku))   // + lsDelimitChar
	
	
	// 05/14 - PCONKL - GTIN from PO_NO2 (30 char)
	lsGTIN = ldsboh.GetItemString(llRowPos,'po_no2')
	If isnull(lsGTIN) or lsGTIN = '-' Then lsGTIN = ""
	lsOutString +=  lsGTIN + Space ( 30 - len(lsGTIN)) 
	
	
	//K1PQOH	On hand quantity	15	0	59	74	No comma, decimal point, sign on right (e.g.'   1700-' to denote OUT)	For inventory balance, this is the qty on hand. We do not pass the qty that were shipped out or received in.	Inventory.Avail Qty+Alloc Qty+intransit qty

	Long	llTotalQty, llsit_qty, llalloc_qty, llavail_qty
	
	llavail_qty = ldsboh.GetItemNumber(llRowPos,'avail_qty') 
	llalloc_qty = ldsboh.GetItemNumber(llRowPos,'alloc_qty')
	llsit_qty = ldsboh.GetItemNumber(llRowPos,'sit_qty')
	
	If IsNull(llavail_qty) then llavail_qty = 0
	If IsNull(llalloc_qty) then llalloc_qty = 0
	If IsNull(llsit_qty) then llsit_qty = 0
	
	llTotalQty = llavail_qty -  (llalloc_qty + llsit_qty)
	
	if llTotalQty < 0 then
		ls_Qty = string(abs(llTotalQty)) + "-"
	else
		ls_Qty = string(llTotalQty)
	end if
		
	lsOutString +=  string(ls_Qty)  +  Space ( 15 - len(ls_Qty))  // + lsDelimitChar /*avail + alloc + sit */		
		
	
	//UOM - Has been concatonated with Supplier, strip from end
	lsSupplier = ldsboh.GetItemString(llRowPos,'supp_code')
	If pos(lsSUpplier,'-') > 0 Then
		lsUOM = Mid(lsSUpplier,pos(lsSUpplier,'-') + 1,99)
	Else
		lsUOM = ""
	End If
	
	lsOutString +=  lsUOM + Space ( 5 - len(lsUOM)) 
	
	
	//K1UPMJ	"As of" Date of the Inventory Balance	20		75	94	Format in YYYYMMDDHHMMSS	Ok	Date that the file generated in YYYYMMDDHHMMSS
	lsOutString +=  string(ldtWHTime, 'YYYYMMDDHHMMSS') + Space (6)  // + lsDelimitChar
	
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', asproject)
	
//	if lsLastWarehouse <> lsWarehouse then
//
//		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
//		commit;
//		
//		If ldBatchSeq <= 0 Then
//			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
//			FileWrite(gilogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//			 Return -1
//		End If
//		
//		lsLastWarehouse = lsWarehouse
//		
//	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */

////Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
//gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)
//
//// TAM 2011/09  Added ability to email the report
//
//lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
////gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
//


//Stock Movement

ldsboh.Dataobject = 'd_stryker_stock_movement'
lirc = ldsboh.SetTransobject(sqlca)

//ldsOut.Reset()

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Stock Movement Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//lsProject = ProfileString(asInifile, asproject,"project","")

////Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
//commit;
//
//If ldBatchSeq <= 0 Then
//	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' Stock Movement confirmation."
//	FileWrite(gilogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//	 Return -1
//End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Stock Movement Data.....') /*display msg to screen*/

	
lsWarehouse = "HSY_DELHI"

datetime ldt_start_date, ldt_end_date

ldtWHTime = f_getLocalWorldTime(lsWarehouse)

//RelativeDate (  
//, -1 )

//RelativeDate (
//, -1 )

	
ldt_start_date = datetime(  date(ldtWHTime), time( "00:00"))
ldt_end_date = datetime(  date(ldtWHTime), time( "23:59"))

//lsFilename = ("IL" + string(today(), "YYMMDD") + lsWarehouse + ".dat")


llRowCount = ldsBOH.Retrieve(asproject, ldt_start_date,ldt_end_date )


lsLogOut = 'IL Start Date: ' + String(ldt_start_date) + ' End Date: ' + String(ldt_end_date)  + ":" + string(llRowCOunt)
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

gu_nvo_process_files.uf_write_log('IL Start Date:' + String(ldt_start_date) + 'End Date:' + String(ldt_end_date) + ":" + string(llRowCOunt))




gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/
FileWrite(gilogFileNo,String(llRowCount) + ' Rows were retrieved for processing.')

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCount

	llNewRow = ldsOut.insertRow(0)
	

	//K2TYPE	Type	2		1	2	Always mark 'IL'	Ok	"IL"
	lsOutString = 'IL' //+ lsDelimitChar
	
	
	//05/14 - PCONKL - Entity Code - hardcoded
	lsOutString += "00550"
	
	
	//K2MCU	Warehouse Code	18		3	20		Warehouse code is 5 digits. Do you want this field to be padded with 13 0s in front, e.g. 000000000000055061?	"Inbound: 
	//Outbound:"
	lsWarehouse = ldsboh.GetItemString(llRowPos,'po_no')
	If IsNull(lsWarehouse) OR trim(lsWarehouse) = "-" then lsWarehouse = ""

	lsOutString +=   lsWarehouse +  Space ( 18 - len(lsWarehouse)) //+ lsDelimitChar

	
	//	K2SLSM	Salesman 	4	0	21	24	Salesman code	OK	"Inbound: Order Infor.User_Field5
	//	Outbound: Other Infor.User_Field5"
	//	
	lsTemp = left(ldsboh.GetItemString(llRowPos,'salesman'),4)
	If IsNull(lsTemp)  then lsTemp = ""
	lsOutString +=  lsTemp + Space ( 4 - len(lsTemp))   //+ lsDelimitChar

	//K2SLM2	SalesTeam	4	0	25	28	Salesteam code	OK	"Inbound: Order Infor.User_Field4
	//Outbound: Other Infor.User_Field4"
	lsTemp = left(ldsboh.GetItemString(llRowPos,'salesteam'), 4)
	If IsNull(lsTemp)  then lsTemp = ""	
	lsOutString  +=   lsTemp + Space ( 4 - len(lsTemp))   //+ lsDelimitChar
	
	//	K2TRAN	Transaction type	2		29	30	e.g. IN, OT,…	Ok	"Inbound: First 2 characters of order Nbr
	//	Outbound: First 2 characters of order Nbr"
	lsTemp = left(ldsboh.GetItemString(llRowPos,'order_no'),2)
	If IsNull(lsTemp) then lsTemp = ""
	lsOutString  +=  lsTemp + Space ( 2 - len(lsTemp))   //+ lsDelimitChar

	//	K2DOC	Document No	20		31	50	Doc Type ** + Doc No	Ok	"Inbound: Order infor.Order Nbr
	//	Outbound: Order infor.Order Nbr"
	lsTemp = ldsboh.GetItemString(llRowPos,'order_no')
	If IsNull(lsTemp)  then lsTemp = ""
	lsOutString  +=   lsTemp + Space ( 20 - len(lsTemp))  //+ lsDelimitChar


	//K2DOC1	3PL Document No.	20		51	70		this is the same as Document No (K2DOC). We use Stryker's document no. as the reference so that it's easier to reconcile.	<Blank>
	lsOutString  +=  Space ( 20  ) //+ lsDelimitChar


	//K2LNID	line number	10	0	71	80		Ok	Order Detail.Line Item #
	lsLineItemNo = string(ldsboh.GetItemNumber(llRowPos,'line_item_no')) //+ lsDelimitChar
	lsOutString +=  string(lsLineItemNo)  +  Space ( 10 - len(string(lsLineItemNo)))  // + lsDelimitChar
	

	//KWLITM	Item Number	30		81	110	JDE Item number	Ok	Order Detail.SKU
	// 05/14 - PCONKL - ITem Number now 25 instead of 30
	lsSku = ldsboh.GetItemString(llRowPos,'sku') //+ lsDelimitChar
	lsOutString +=  lsSku  + Space ( 25 - len(lsSku))  // + lsDelimitChar
	
	// 05/14 - PCONKL - GTIN - PO_NO2
	lsTemp = Trim(ldsboh.GetItemString(llRowPos,'po_no2'))
	If isnull(lsTemp) or lsTemp = '-' Then lsTemp = ""
	lsOutString +=  lsTemp  + Space ( 30 - len(lsTemp))
	
		
	//KWPQOH	On hand quantity	15	0	111	126	No comma, decimal point, sign on right (e.g.'   1700-' to denote OUT)	Ok	"Inbound: Order Detail.Rcv qty 
	//Outbound: Order Detail.Alloc Qty (show negative sign behind qty for outbound, e.g. 123-, 863-)"
	llalloc_qty = ldsboh.GetItemNumber(llRowPos,'quantity')
	If IsNull(llalloc_qty) then llalloc_qty = 0
	llTotalQty = llalloc_qty 
		
	if  ldsboh.GetItemString(llRowPos,'inbound_outbound') = "O" then
		ls_Qty = string(abs(llTotalQty)) + "-"
	else
		ls_Qty = string(llTotalQty)
	end if
		
	lsOutString +=  string(ls_Qty)  + Space ( 15 - len(ls_Qty))  // + lsDelimitChar /*avail + alloc + sit */		
	
	
	// 05/14 - PCONKL -UOM 5 - Sims Supplier COde has Supplier concatonated with UOM
	lsTemp = Trim(ldsboh.GetItemString(llRowPos,'supp_code'))
	
	If Pos(lsTemp,'-') > 0 Then
		lsSupplier = Left(lsTemp,Pos(lsTemp,'-') - 1)
		lsUOM = Mid(lsTemp,Pos(lsTemp,'-') + 1,99)
	Else
		lsSupplier = lsTemp
		lsUOM = ""
	End If
	
	lsOutString +=  lsUOM  + Space ( 5 - len(lsUOM))
	
	//KWUPMJ	update date / Time	20		127	146	Format in YYYYMMDDHHMMSS	Ok	Date that the file generated in YYYYMMDDHHMMSS
	lsOutString +=  string(ldtWHTime, 'YYYYMMDDHHMMSS')  + Space (6) // + lsDelimitChar
	
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', asproject)
	
//	if lsLastWarehouse <> lsWarehouse then
//
//		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
//		commit;
//		
//		If ldBatchSeq <= 0 Then
//			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
//			FileWrite(gilogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//			 Return -1
//		End If
//		
//		lsLastWarehouse = lsWarehouse
//		
//	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)

Next



//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
//gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,asproject)
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,asproject)


// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,asproject,"archivedirectory","") + '\' + lsFileName  + ".txt"
//gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)



Return 0
end function

public function integer uf_process_itemmaster (string aspath, readonly string asproject);
//Item Master EDI							
//							
//Seq	Field Name	Type	Length	Value/Sample	Description	Stryker Field	SIMS field
//IM_01	JDEItemNo	varchar	20	5820-010-630		JDEItemNo	SKU
//IM_02	JDEItemDesc	varchar	60	OPTI-PIN FIXING PIN 40MM 4/PK		JDEItemDesc	Description
//IM_03	PackSize	varchar	15	1		PackSize	UOM qty
//IM_04	UOM	varchar	5	EA		UOM	UOM
//IM_05	LastUpdateDate	date	8	YYYYMMDD	YYYYMMDD		
//IM_06	JDESupplierCode	varchar	8	99017		JDESupplierCode	user field 13
//IM_07	ABC Classification	Varchar	3			ABCCode	CC Class
//IM_08	Product Group Code	varchar	3	INS		ProductGroupCode	user field 7
//IM_09	Product Group Name	varchar	40	Instrument		ProductGroupName	user field 8
//IM_10	Product Line Code	varchar	3	SUR		ProductLineCode	user field 9
//IM_11	Product Line Name	varchar	40	Surgical		ProductLineName	user field 10
//IM_12	Product Category Code	varchar	3	300		ProductCategoryCode	user field 11
//IM_13	Product Category Name	varchar	40	Heavy Duty		ProductCategoryName	user field 12

//Other Fields
//1. user field 1 – this is used as MRP flag. For item that needs to print MRP label, this is “Y”, else “N”.						
//2. user field 4 – this is used for “Imp Lic No.”. 						
//3. user field 5 - Vendor Code. 						
//4. user field 6 – Vendor Name						


//Requirements:
//1.	SIMS will load the IN EDI file from Stryker as an inbound order.
//2.	Menlo Ops to generate putaway list and key in the locations.
//3.	Menlo ops to confirm the inbound order. MRP labels will then be printed out automatically if there are MRP items in the inbound order. The # of MRP labels printed is equal to the qty of MRP items in the inbound order.


// 04/14 - PCONKL - New format for Item Master

STRING lsTemp, lsSku, lsSupplier, lsUOM,lsStrykerSupplier, lsItemGroup
BOOLEAN lbError, lbNew
LONG llCount, llNew, llNewRow, llOwner, llexist, llFileRowCount, llFileRowPos
INTEGER lirc, liRtnImp
STRING lsLogOut
Integer	liFileNo
String lsStringData
datastore	lu_DS
integer li_row_idx, li_col_idx 
string lsdata, lsConvData
DateTime	ldtToday

ldtToday = dateTime(today(),now())

//Item Master

u_ds_datastore	ldsItem 

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_baseline_unicode_item_master'
ldsItem.SetTransObject(SQLCA)


lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Stryker Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

//Process each Row
llFileRowCOunt = lu_ds.RowCount()

string lsSize


//Loop through

//for llFileRowPos = 1 to llFilerowCount
//
//	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
//
//	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
//
//	lsSupplier = "IN_STRYKER"
//
//	//Field Name	Type	Req.	Default	Description
//	//Record ID	C(2)	Yes	“IM”	Item Master Identifier
//
//	
//	//IM_01	JDEItemNo	varchar	20	5820-010-630		JDEItemNo	SKU
//
//	lsTemp  = trim(left(lsData, 20))
//	lsData = mid(lsData, 21)
//	
//	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
//		lbError = True
//		Continue		
//	Else
//		lsSku = lsTemp
//	End If	
//	
//	
//
//	////Retrieve for SKU - We will be updating across Suppliers
//
//	llCount = ldsItem.Retrieve(asproject, lsSKU, lsSupplier)
//
//	
//	If llCount <= 0 Then
//
//		llNew ++ /*add to new count*/
//		lbNew = True
//		llNewRow = ldsItem.InsertRow(0)
//
//		ldsItem.SetItem(1,'SKU',lsSKU)
//		ldsItem.SetItem(1,'project_id', asproject)		
//		
//		ldsItem.SetItem(1,'Country_of_Origin_Default', 'XXX')
//
//		
//		//Get Default owner for Supplier
//		Select owner_id into :llOwner
//		From Owner
//		Where project_id = :asproject and Owner_type = 'S' and owner_cd = :lsSupplier;
//		
//		
//		If IsNull(llOwner) OR llOwner <= 0  Then
//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner for Supplier ("+lsSupplier+") not found in database.")
//			lbError = True
//			Continue			
//		End If
//		
//		ldsItem.SetItem(1,'supp_code',lsSupplier)
//		ldsItem.SetItem(1,'owner_id',llOwner)
//							
//	Else /*exists*/		
//		llexist += llCount /*add to existing Count*/
//		lbNew = False
//	End If
//	
//	
//	IF lbNew Then
//		
//			ldsItem.SetItem(1,'Lot_Controlled_Ind', 'Y')
//			ldsItem.SetItem(1,'PO_Controlled_Ind', 'Y')
//	
//			//default value added 19/12/2012 nxjain	
//			ldsItem.SetItem(1,'serialized_ind','N') 
//			ldsItem.SetItem(1,'po_no2_controlled_ind','N')
//			ldsItem.SetItem(1,'container_tracking_ind','N') 
//			ldsItem.SetItem(1,'Expiration_Controlled_Ind','N') 
//			ldsItem.SetItem(1,'standard_of_measure', 'M')
//			ldsItem.SetItem(1,'QA_Check_Ind', 'N')
//				//end 
//				
//	End IF
//	
//	
//	//IM_02	JDEItemDesc	varchar	60	OPTI-PIN FIXING PIN 40MM 4/PK		JDEItemDesc	Description
//
//	lsTemp  = trim(left(lsData, 60))
//	lsData = mid(lsData, 61)
//	
//	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Description is required. Record will not be processed.")
//		lbError = True
//		Continue		
//	Else
//		ldsItem.SetItem(1,'description', lsTemp)
//	End If	
//
//
//	//IM_03	PackSize	varchar	15	1		PackSize	UOM qty
//	
//	lsTemp  = trim(left(lsData, 15))
//	lsData = mid(lsData, 16)
//	
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'Qty_2', Dec(lsTemp))
//	End If			
//
//	//IM_04	UOM	varchar	5	EA		UOM	UOM
//
//	lsTemp  = trim(left(lsData, 5))
//	lsData = mid(lsData, 6)
//	
//	If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//		lsTemp = "EA"
//	End If	
//	
//	ldsItem.SetItem(1,'uom_1', lsTemp)
//
//	//IM_05	LastUpdateDate	date	8	YYYYMMDD	YYYYMMDD	
//	
//	//Last_Update
//	
//	lsTemp  = trim(left(lsData, 8))
//	lsData = mid(lsData, 9)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'last_update', date(left(lsTemp,4) + "-" + mid(lsTemp,5,2) +  "-" + mid(lsTemp,7,2)))
//	Else
//		ldsItem.SetItem(1,'last_update',today())	
//	End If		
//	
//	
//	
//	//IM_06	JDESupplierCode	varchar	8	99017		JDESupplierCode	user field 13
//	
//	lsTemp  = trim(left(lsData, 8))
//	lsData = mid(lsData, 9)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field13', lsTemp)
//	End If		
//	
//	//IM_07	ABC Classification	Varchar	3			ABCCode	CC Class
//	
//	//cc_class_code
//	
//	lsTemp  = trim(left(lsData, 3))
//	lsData = mid(lsData, 4)
//
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'cc_class_code', lsTemp)
//	End If				
//
//	//IM_08	Product Group Code	varchar	3	INS		ProductGroupCode	user field 7
//	
//	lsTemp  = trim(left(lsData, 3))
//	lsData = mid(lsData, 4)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field7', lsTemp)
//	End If			
//	
//	
//	//IM_09	Product Group Name	varchar	40	Instrument		ProductGroupName	user field 8
//	
//	lsTemp  = trim(left(lsData, 40))
//	lsData = mid(lsData, 41)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field8', lsTemp)
//	End If		
//	
//	
//	//IM_10	Product Line Code	varchar	3	SUR		ProductLineCode	user field 9
//	
//	lsTemp  = trim(left(lsData, 3))
//	lsData = mid(lsData, 4)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field9', lsTemp)
//	End If		
//		
//	//IM_11	Product Line Name	varchar	40	Surgical		ProductLineName	user field 10
//
//	lsTemp  = trim(left(lsData, 40))
//	lsData = mid(lsData, 41)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field10', lsTemp)
//	End If	
//	
//	
//	//IM_12	Product Category Code	varchar	3	300		ProductCategoryCode	user field 11
//	
//	lsTemp  = trim(left(lsData, 3))
//	lsData = mid(lsData, 4)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field11', lsTemp)
//	End If		
//	
//	//IM_13	Product Category Name	varchar	40	Heavy Duty		ProductCategoryName	user field 12	
//	
//	lsTemp  = trim(left(lsData, 40))
//	lsData = mid(lsData, 41)
//
//	If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//		ldsItem.SetItem(1,'user_field12', lsTemp)
//	End If		
//	
//	
//	ldsItem.SetItem(1,'Last_user','SIMSFP')
//
//		
////Note: 
////
////1.	If delete flag is set for “Y”, the item will not be available for further transactions.
////2.	If delete flag is set for “Y” and no warehouse transaction exist, the record will be physically deleted from database.
//
//
//	
//	//Save New Item to DB
////	SQLCA.DBParm = "disablebind =0"
//	lirc = ldsItem.Update()
////	SQLCA.DBParm = "disablebind =1"
//	
//	If liRC = 1 then
//		Commit;
//	Else
//		Rollback;
//		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!"
//		FileWrite(gilogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
//		Return -1
//		Continue
//	End If
//
//Next /*File row to Process */

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	//First 2 char must be IM
	If Left(lsData,2) <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - First 2 char of record must be 'IM'. Record will not be processed.")
		lbError = True
		Continue		
	End If	
	
	lsSKU = Trim(Mid(lsData,10,25))
	lsStrykerSupplier = Trim(Mid(lsData,145,8))
	lsUOM = Trim(Mid(lsData,140,5))
	
	//Trim any leading zeros from Supplier...
	Do While Left(lsStrykerSupplier,1) = '0'
		lsStrykerSupplier = Mid(lsStrykerSupplier,2,99)
	Loop
	
	If IsNull(lsSKU) OR trim(lsSKU) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
		lbError = True
		Continue		
	End If	
	
	If IsNull(lsStrykerSupplier) OR trim(lsStrykerSupplier) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier is required. Record will not be processed.")
		lbError = True
		Continue		
	End If	
	
	If IsNull(lsUOM) OR trim(lsUOM) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
		lbError = True
		Continue		
	End If	
	
	//SIMS Supplier Code is 'Stryker' + UOM. If it doesn't exist, create on the fly.
	lsSupplier =  "STRYKER-" + lsUOM
	
	Select COunt(*) into :llCount
	From Supplier
	Where Project_id = 'Stryker' and supp_code = :lsSUpplier;
	
	If llCount < 1 Then
		
		Insert Into Supplier
		(Project_id, Supp_code,last_update)
		Values ('Stryker',:lsSupplier, :ldtToday)
		Using SQLCA;
		
		Commit;
		
	End If
	
	
	//Retrieve for SKU/Supplier

	llCount = ldsItem.Retrieve(asproject, lsSKU, lsSupplier)

	If llCount <= 0 Then

		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)

		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'project_id', asproject)		
		
		ldsItem.SetItem(1,'Country_of_Origin_Default', 'XXX')
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :asproject and Owner_type = 'S' and owner_cd = :lsSupplier;
				
		If IsNull(llOwner) OR llOwner <= 0  Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Owner for Supplier ("+lsSupplier+") not found in database.")
			lbError = True
			Continue			
		End If
				
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/		
		llexist += llCount /*add to existing Count*/
		lbNew = False
	End If

	IF lbNew Then /* new record defaults */
		
		ldsItem.SetItem(1,'Lot_Controlled_Ind', 'Y')
		ldsItem.SetItem(1,'PO_Controlled_Ind', 'Y')
	
		//default value added 19/12/2012 nxjain	
		ldsItem.SetItem(1,'serialized_ind','N') 
		ldsItem.SetItem(1,'po_no2_controlled_ind','N')
		ldsItem.SetItem(1,'container_tracking_ind','N') 
		ldsItem.SetItem(1,'Expiration_Controlled_Ind','N') 
		ldsItem.SetItem(1,'standard_of_measure', 'M')
		ldsItem.SetItem(1,'QA_Check_Ind', 'N')
					
	End IF

	//Description
	If  trim(Mid(lsData,35,60)) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Description is required. Record will not be processed.")
		lbError = True
		Continue		
	Else
		ldsItem.SetItem(1,'description', trim(Mid(lsData,35,60)))
	End If	

	//GTIN - UF 17
	ldsItem.SetItem(1,'User_Field17', trim(Mid(lsData,95,30)))
	
	// 10/14 - PCONKL - Pack Size ->UF16 - remove leading zeros
	lsTemp = trim(Mid(lsData,125,15))
	Do While Left(lsTemp,1) = "0"
		lsTemp = Mid(lsTemp,2,15)
	Loop
	
	ldsItem.SetItem(1,'User_Field16', lsTemp)
	
	//UOM (1)
	ldsItem.SetItem(1,'UOM_1', trim(Mid(lsData,140,5)))
	
	//Stryker Supplier (without UOM) - UF 7
	ldsItem.SetItem(1,'User_Field7', lsStrykerSupplier)
	
	//Sellable - UF1
	ldsItem.SetItem(1,'User_Field1', trim(Mid(lsData,155,1)))
	
	//Product Division Code - UF19
	ldsItem.SetItem(1,'User_Field19', trim(Mid(lsData,156,3)))
	
	//product Division - UF20
	ldsItem.SetItem(1,'User_Field20', trim(Mid(lsData,159,40)))
	
	//Product Group Code - Item Group - If doesn't exist, need to add to Item_Group Table
	
	lsItemGroup =  trim(Mid(lsData,199,3))
	
	Select COunt(*) into :llCount
	From Item_Group
	Where Project_id = 'Stryker' and grp = :lsItemGroup;
	
	If llCount < 1 Then
		
		Insert Into Item_Group
		(Project_id, grp ,last_user, last_update)
		Values ('Stryker',:lsItemGroup,'SIMSFTP', :ldtToday)
		Using SQLCA;
		
		Commit;
		
	End If
	
	
	ldsItem.SetItem(1,'grp', lsItemGroup)
	
	//Product Group - UF8
	ldsItem.SetItem(1,'User_Field8', trim(Mid(lsData,202,40)))
	
	//Product Line Code - UF9
	ldsItem.SetItem(1,'User_Field9', trim(Mid(lsData,242,3)))
	
	//Product Line - Uf10
	ldsItem.SetItem(1,'User_Field10', trim(Mid(lsData,245,40)))
	
	//Product Category Code = UF11
	ldsItem.SetItem(1,'User_Field11', trim(Mid(lsData,285,3)))
	
	//Product Category - UF12
	ldsItem.SetItem(1,'User_Field12', trim(Mid(lsData,288,40)))
	
	//product Type - Uf13
	ldsItem.SetItem(1,'User_Field13', trim(Mid(lsData,328,1)))
	
	//Brand - UF14
	ldsItem.SetItem(1,'User_Field14', trim(Mid(lsData,329,30)))
	
	//Sub-Brand - UF15
	ldsItem.SetItem(1,'User_Field15', trim(Mid(lsData,359,30)))
	
	//Short Description (Native Desc)
	ldsItem.SetItem(1,'Native_Description', trim(Mid(lsData,389,60)))
	
	//Long Desc - UF18
	ldsItem.SetItem(1,'User_Field18', trim(Mid(lsData,449,100)))
	
	//Standard Cost
	ldsItem.SetItem(1,'Std_Cost', dec(trim(Mid(lsData,549,15))))
	
	//Standard Cost in local currency (previous cost)
	ldsItem.SetItem(1,'Std_Cost_old', dec(trim(Mid(lsData,567,15))))
	
	//Shelf Life
	ldsItem.SetItem(1,'Shelf_Life', long(trim(Mid(lsData,585,3))))
	
	//ABC Classification (CC Class) Life
	ldsItem.SetItem(1,'cc_class_code', trim(Mid(lsData,616,3)))
	
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'Last_Update',ldtToday)
		
	//Save New Item to DB
	lirc = ldsItem.Update()
	
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record(s) to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		Return -1
		Continue
	End If

Next
w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Item Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsItem

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

public function string uf_convert_doc_type (string as_doc_type);
string ls_SIMS_Doc_Type

CHOOSE CASE Upper(as_doc_type)
	Case "II" 	//Inventory Write 
		ls_SIMS_Doc_Type = "I"
	Case "IT"	//Warehouse Transfer
		ls_SIMS_Doc_Type = "Z"
	Case "OR"	//Purchase Return Note	
		ls_SIMS_Doc_Type = "P"
	Case "PL" 	//Sales Order / Consignment Pick
		ls_SIMS_Doc_Type = "S"
	Case "RN"	//Purchase Receive Note
		ls_SIMS_Doc_Type = "P"
	Case "SC" //Sales Return of Inter-company Sales
		ls_SIMS_Doc_Type = "C"
	Case "SR" //Sales Return of Customer Sales
		ls_SIMS_Doc_Type = "R"
	Case "SS" //Short Term Loaner Ship Out Advice
		ls_SIMS_Doc_Type = "L"
	Case "SX" //Short Term Loaner Return Advice	
		ls_SIMS_Doc_Type = "L"
	Case "TQ" //Warehouse Transfer 
		ls_SIMS_Doc_Type = "Z"
END CHOOSE

RETURN ls_SIMS_Doc_Type
end function

public function integer uf_update_delivery_order (string aspath, string asproject);//
//Process Transaction Type (OT) -Stock OUT

//3.	OT EDI  - Shipment confirmation EDI
//a)	Stryker will generate this EDI file to Menlo AFTER Menlo ops scanned the lot#/ Serial#, expiry and MFG dates and uploaded to Stryker’s Barcode Web.
//b)	Please advise if this is possible  The picked inventory’s lot # from 2d above to be updated into the inventory table.


STRING lsTemp, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsInventoryType, lsTempNote
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo 
LONG llNewAddressRow, llNoteSequence, llNewNotesRow
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
STRING  lsNoteType, lsNoteText


u_ds_datastore 	ldsSOheader,	&
				ldsSOdetail, &
				ldsDOAddress, ldsDONotes
				
u_ds_datastore ldsImport

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_baseline_unicode_do_address'
ldsDOAddress.SetTransObject(SQLCA)

//BCR 13-DEC-2011: Geistlich needs DeliveryNotes processing...
ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number

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


for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//1	Transaction Type	PK	Char(2)
	//1	Transaction Type	PK	Char(2)
		
	//Validate Transaction Type is PK
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT (lsTemp = 'PK') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Transation Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If



	//2	Record Type	HD	Char(2)
	//2	Record Type	DT	Char(2)	
	
	//Validate Rec Type is DM OR DD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
	If NOT (lsTemp = 'HD' OR lsTemp = 'DT') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Delivery Order Master
	
		//HEADER RECORD
		Case 'HD' /* Header */

			lsChangeID = "A"

			//3	Detail Count	Detail Line Count	Number(6)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))			
			
			//4	Document No	Doc Type + Doc No	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
				lsOrderType = uf_convert_doc_type(left(lsTemp, 2))
				
			End If					
			
			//5	Order Date	OrderDate	Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_OrderDate = lsTemp
			End If							
			
			//6	Warehouse No	Warehouse No	Char(18)
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col6")))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsInventoryType = "S"
				lsWarehouse = "HSY_DELHI"
			End If		
			
			//7	Delivery Date	DeliveryDate	Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_DeliveryDate = lsTemp
			End If		
						
			//8	Ship To 	Ship To Code	Char(18)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsCustomerCode = lsTemp
			End If	

			/* End Required */		
			
			
			liNewRow = 	ldsSOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0			
			
			//New Record Defaults
			ldsSOheader.SetItem(liNewRow,'project_id',asProject)
			ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
//			ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsSOheader.SetItem(liNewRow,'status_cd','N')
			ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			ldsSOheader.SetItem(liNewRow,'invoice_no',lsOrderNumber)			

			ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
	
			ldsSOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Type*/	
	
			ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	

//			1.	Map Delivery Date on DM to “Delivery Date” in SIMS
//			2.	Map GI Date on DM to “Schedule Date” in SIMS
//			
			
			ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)
			ldsSOheader.SetItem(liNewRow,'delivery_date',ls_DeliveryDate)
			ldsSOheader.SetItem(liNewRow,'schedule_date',ls_GI_Date)
		
		
			//9	Customer Name	Customer Name	Char(40)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'cust_name', lsTemp)
			End If				
			
			
			//10	Address1	address1	Char(40)	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_1', lsTemp)
			End If			
			
			//11	Address2	address2	Char(40)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_2', lsTemp)
			End If				
			
			//12	Address3	address3	Char(40)
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_3', lsTemp)
			End If	
			
			//13	Address4	address4	Char(40)	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_4', lsTemp)
			End If				
			
		
//			//Ship City	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'city', lsTemp)
//			End If			
//			
//			//Ship State	C(50)	No	N/A
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'state', lsTemp)
//			End If				
//			
//			//Ship Postal Code	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
//			End If				
//			
//			//Ship Country	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'country', lsTemp)
//			End If				
			
			//14	Contact	contact1	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'contact_person', lsTemp)
			End If						
			
			//15	Phone number	phone1	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'tel', lsTemp)
			End If				

			
			//16	Fax number	fax1	Char(20)
			//17	Notes *	Notes	Char(2000)	

			//Remarks	C(255)	No	N/A	
		
			//7	Notes *	Notes	Char(2000)			
			//* For Warehouse No = Salesman Warehouse				
			//7	Notes	Notes		SIMS Order Information field

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
			//7.1	Salesteam Code	Sales Team	Char(4)	user field 4
			
			lsTempNote = left(lsTemp,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field4', lsTempNote)
			End If			
			
			//7.2	Salesman Code	Salesman Code	Char(4)	user field 5
			
			lsTempNote = mid(lsTemp,5,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field5', lsTempNote)
			End If				
						
			//7.3	Salesman Name	Salesman Name	Char(40)	user field 6
	
			lsTempNote = mid(lsTemp,9,6)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field6', lsTempNote)
			End If	
			
			//7.4	Salesman Address Line 1	Salesman Address Line 1	Char(40)	user field 7
			
			lsTempNote = mid(lsTemp,15,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field7', lsTempNote)
			End If			
			
			//7.5	Salesman Address Line 2	Salesman Address Line 2	Char(40)	user field 8
			
			lsTempNote = mid(lsTemp,55,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field8', lsTempNote)
			End If				
			
			
			//7.6	Notes	Notes	Char(1872)	Remark (char 255)
	
			lsTempNote = mid(lsTemp,95)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'Remark', lsTempNote)
			End If		
			
				
//			//Ship To Email		C(50)	No	N/A
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'email_address', lsTemp)
//			End If			
			
								
		// DETAIL RECORD

		Case 'DT' /*Detail */

			lsChangeID = "A"
			lsSupplier = "IN_STRYKER"
			
			//3	Line No	Line Number	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If	
			
			//4	Document No	Doc Type + Doc No	Char(20)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
		
				//Make sure we have a header for this Detail...
				If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

		
			//5	Item No	Stryker Item No	Char(30)

	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
			//6	Quantity	Quantity	Number(38)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			

	
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsSODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsSODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInventoryType) 
			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrderNumber)			
//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			

//			//Customer  Line Item Number	C(20)	No	N/A	Customer Line Item Number
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
////				ldsSOheader.SetItem(liNewRow,'', lsTemp)
//			End If		
//
//			//Alternate SKU	C(50)	No	N/A	Alternate SKU
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'alternate_sku', lsTemp)
//			End If				
//			
//			
//			//Customer SKU	C(35)	No	N/A	Customer/Alternate SKU
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
////				ldsSODetail.SetItem(liNewRow,'cust_sku', lsTemp)
//			End If				
//			
//			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'lot_no', lsTemp)
//			End If				
//			
//			
//			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'po_no', lsTemp)
//			End If			
//			
//			
//			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'po_no2', lsTemp)
//			End If				
//			
//			//Serial Number	C(50)	No	N/A	Qty must be 1 if present
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'serial_no', lsTemp)
//			End If				
//			
//			//Line Item Text	C(255)	No	N/A	Notes / remarks
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'line_item_notes', lsTemp)
//			End If				
//			
//			
//			//User Field1	C(20)	No	N/A	User Field
//			//User Field2	C(20)	No	N/A	User Field
//			//User Field3	C(30)	No	N/A	User Field
//			//User Field4	C(30)	No	N/A	User Field
//			//User Field5	C(30)	No	N/A	User Field
//			//User Field6	C(30)	No	N/A	User Field
//			//User Field7	C(30)	No	N/A	User Field
//			//User Field8	C(30)	No	N/A	User Field, not viewable on screen
//	
//			uf_process_userfields(18, 8, ldsImport, llFileRowPos, ldsSODetail, llNewDetailRow)	
//
//			
//			//UnitOfMeasure	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col26"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'uom', lsTemp)
//			End If		
//			
//			//Unit Price
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col27"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'price', lsTemp)
//			End If					
//			
//			
	CASE Else /* Invalid Rec Type*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		Continue	

	End Choose /*Header or Detail */
	
	
Next /*File record */


//IF lirc = -1 then lbError = true else lbError = false	


//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



	
If liRC = 1 then
//	Commit;

//BCR 12-30-11 Geistlich UAT Session...
//why comment out this Commit? It is the cause of this UOM issue we have found in Geistlich UAT...
Commit;
//End

Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Notes Records to database!"
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

public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail);//28-May-2013 :Madhu - Generate Daily Inventory Report
//Process Daily Inventory Report

string lsFilename ="DailyInventoryReport-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inventory Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename

// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_stock_inquiry'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject,asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("STRYKER", asEmail, "Daily Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0
end function

public function integer uf_update_item_master_flags (string as_project, string as_sku, string as_supplier);// TAM 2013/09/23 - If the following values are not set to the defaults in the Item Master then Update the Item Master to the defaults per BoonHee.

String ls_expiry_ind, ls_expiry_track_type
Long ld_shelf_life


SELECT Item_Master.Expiration_Controlled_Ind,     Item_Master.Expiration_Tracking_Type,  Item_Master.Shelf_Life  
INTO :ls_expiry_ind, :ls_expiry_track_type,   :ld_shelf_life  
FROM Item_Master  
WHERE ( Item_Master.Project_Id = :as_project ) AND  ( Item_Master.SKU = :as_sku )  ;
			
If (ls_expiry_ind <> 'Y') or (ls_expiry_track_type <> 'D') or (ld_shelf_life <> 180) then
	UPDATE Item_Master  
	SET Expiration_Controlled_Ind = 'Y',   Expiration_Tracking_Type = 'D',  Shelf_Life = 180  
	WHERE ( Item_Master.Project_Id = :as_project ) AND  ( Item_Master.SKU = :as_sku )   ;
End If

return 0
end function

protected function integer uf_process_delivery_order (string aspath, string asproject);//
//Process Transaction Type (PK) -Stock OUT pick

//2.	PK EDI – Outbound orders
//a)	Stryker planner will generate this EDI to us, and the outbound order is to be created in SIMS based on this PK file.
//b)	Same as IN  The field = Warehouse No. will indirectly determine the inventory types, which can be Saleable, Demo or Loaner. Stryker will provide this list soon.
//c)	Since items are not serialized, we need not have serial# printed on the picking list. We’ll pick by FEFO, followed by FIFO.
//d)	If there are more than 2 inventory with the same expiry and receipt dates but different lot#, Menlo ops may pick any of these inventory. So the actual picked inventory’s lot# may be different from the picking list. The actual lot# will be scanned and uploaded into Stryker’s system.

STRING lsTemp, lsSku, lsSupplier, lsWarehouse, lsOrderNumber, lsOrderType, lsInventoryType, lsTempNote, lsStrykerWarehouse, lsUOM
Datetime ldtWHTime
BOOLEAN lbError, lbNew, lbDetailError
LONG llCount, llNew, llOwner, llexist, llOrderSeq, llLineSeq, llbatchseq, llLineItemNo 
LONG llNewAddressRow, llNoteSequence, llNewNotesRow
INTEGER lirc, liRtnImp, liNewRow, llNewDetailRow
STRING lsLogOut, lsChangeID
INTEGER li_StartCol
INTEGER li_UFIdx
DECIMAL ldQuantity
STRING lsCustomerCode
STRING ls_OrderDate, ls_DeliveryDate, ls_ScheduleDate
BOOLEAN lbBillToAddress
STRING lsBillToAddr1, lsBillToAddr2, lsBillToAddr3, lsBillToAddr4, lsBillToCity
STRING	lsBillToState, lsBillToZip, lsBillToCountry, lsBillToTel, lsBillToName
STRING  lsNoteType, lsNoteText, lsTransactionType,  lsShelflife_ind


u_ds_datastore 	ldsSOheader,	&
				ldsSOdetail, &
				ldsDOAddress, ldsDONotes
				
u_ds_datastore ldsImport

ldsSOheader = Create u_ds_datastore
ldsSOheader.dataobject= 'd_baseline_unicode_shp_header'
ldsSOheader.SetTransObject(SQLCA)

ldsSOdetail = Create u_ds_datastore
ldsSOdetail.dataobject= 'd_baseline_unicode_shp_detail'
ldsSOdetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_baseline_unicode_do_address'
ldsDOAddress.SetTransObject(SQLCA)

//BCR 13-DEC-2011: Geistlich needs DeliveryNotes processing...
ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening Sales Order File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open Sales Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

integer llFileRowPos
integer llFilerowCount

llFilerowCount = ldsImport.RowCount()

//Get the next available file sequence number

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

// 05/14 - PCONKL - Format changes...

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))

	//1	Transaction Type	PK	Char(2)
	//1	Transaction Type	PK	Char(2)
	//1	Transaction Type		Char(2) 
		
	//Validate Transaction Type is PK
	// 05/14 - PCONKL - Transaction Type now 'OO' or 'OC'
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	//If NOT (lsTemp = 'PK' OR lsTemp = 'OT') Then
	If NOT (lsTemp = 'OO' OR lsTemp = 'OC') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Transation Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	lsTransactionType = lsTemp

	//2	Record Type	HD	Char(2)
	//2	Record Type	DT	Char(2)	
	//2	Record Type	LD	Char(2) 
	
	//Validate Rec Type is DM OR DD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
	If NOT (lsTemp = 'HD' OR lsTemp = 'DT' OR lsTemp = 'LD') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
		//Delivery Order Master
	
		//HEADER RECORD
		Case 'HD' /* Header */

			// 05/14 - PCONKL - PK is now OO, OT is now OC
		//	If lsTransactionType = "PK" Then
			If lsTransactionType = "OO" Then
				lsChangeID = "A"
			End If

			//If lsTransactionType = "OT" Then
//			If lsTransactionType = "OC" Then
//				lsChangeID = "U"
//			End If

						
			//3	Detail Count	Detail Line Count	Number(6)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))			
			
			//4	Document No	Doc Type + Doc No	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsOrderNumber = lsTemp
				lsOrderType = uf_convert_doc_type(left(lsTemp, 2))
				
			End If					
			
			//5	Order Date	OrderDate	Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_ScheduleDate = lsTemp    //Changed to Schedule Date as per BoonHee
//				ls_OrderDate = lsTemp
			End If							
			
			//6	Warehouse No	Warehouse No	Char(18)
			
			lsTemp = Upper(Trim(ldsImport.GetItemString(llFileRowPos, "col6")))

			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Warehouse is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
				  SELECT dbo.Lookup_table.User_Field1 INTO :lsInventoryType
				  	FROM dbo.Lookup_Table  
					  WHERE dbo.Lookup_Table.Project_ID = :asproject AND 
					  			dbo.Lookup_Table.Code_type = 'STRWH' AND 
								  dbo.Lookup_Table.Code_ID = :lsTemp
							USING SQLCA;
				
				if SQLCA.SQLCode = 100 OR SQLCA.SQLCode < 0 then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Warehouse No: '" + lsTemp + "'. Record will not be processed.")
					lbError = True
					Continue							
				end if
	
				lsStrykerWarehouse = lsTemp
	
//				lsInventoryType = "S"
				lsWarehouse = "HSY_DELHI"
			End If		
			
			//7	Delivery Date	DeliveryDate	Date
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
			Else
				ls_DeliveryDate = lsTemp
			End If		
						
			//8	Ship To 	Ship To Code	Char(18)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Customer Code is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsCustomerCode = lsTemp
			End If	

			/* End Required */		
			
			
			liNewRow = 	ldsSOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0			
			
			//New Record Defaults
			ldsSOheader.SetItem(liNewRow,'project_id',asProject)
			ldsSOheader.SetItem(liNewRow,'wh_code',lsWarehouse)
//			ldsSOheader.SetItem(liNewRow,'Request_date',String(Today(),'YYMMDD'))
			ldsSOheader.SetItem(liNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSOheader.SetItem(liNewRow,'order_seq_no',llOrderSeq) 
			ldsSOheader.SetItem(liNewRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsSOheader.SetItem(liNewRow,'status_cd','N')
			ldsSOheader.SetItem(liNewRow,'Last_user','SIMSEDI')

			If lsTransactionType = "OT" Then
				ldsSOheader.SetItem(liNewRow,'ord_status','R')
			End IF

			ldsSOheader.SetItem(liNewRow,'invoice_no',lsOrderNumber)			

			ldsSOheader.SetItem(liNewRow,'cust_code',lsCustomerCode) /*Order Type*/
			
			//Jxlim 06/02/2014 End of ignore shelflife ind L14P220 Stryker
			Select User_field1 Into :lsShelflife_ind
			From Customer
			Where  Project_id = 'Stryker'
			And cust_Code =:lsCustomerCode
			Using SQLCA;
			
			If Trim(lsShelflife_ind) ='Y' Then
					ldsSOheader.SetItem(liNewRow,'ignore_Shelflife_ind',lsShelflife_ind ) /*ignore_Shelflife_ind*/	
			End If
			//Jxlim 06/02/2014 End of ignore shelflife ind L14P220 Stryker
	
			ldsSOheader.SetItem(liNewRow,'Order_type',lsOrderType) /*Order Type*/	
	
			ldsSOheader.SetItem(liNewRow,'action_cd',lsChangeID) /*Supplier Order*/	
			
			ldsSOheader.SetItem(liNewRow,'user_field18', lsStrykerWarehouse)			

//			1.	Map Delivery Date on DM to “Delivery Date” in SIMS
//			2.	Map GI Date on DM to “Schedule Date” in SIMS
//			
			
			//ls_OrderDate
			
			ldtWHTime = f_getLocalWorldTime(lsWarehouse)
			ldsSOheader.SetItem(liNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
			
//			ldsSOheader.SetItem(liNewRow,'ord_date',ls_OrderDate)

			ldsSOheader.SetItem(liNewRow,'schedule_date',ls_ScheduleDate)
		
		
			//9	Customer Name	Customer Name	Char(40)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'cust_name', lsTemp)
			End If				
			
			
			//10	Address1	address1	Char(40)	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col10"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_1', lsTemp)
			End If			
			
			//11	Address2	address2	Char(40)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col11"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_2', lsTemp)
			End If				
			
			//12	Address3	address3	Char(40)
	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col12"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_3', lsTemp)
			End If	
			
			//13	Address4	address4	Char(40)	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col13"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'address_4', lsTemp)
			End If				
			
		
//			//Ship City	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col22"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'city', lsTemp)
//			End If			
//			
//			//Ship State	C(50)	No	N/A
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col23"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'state', lsTemp)
//			End If				
//			
//			//Ship Postal Code	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col24"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
//			End If				
//			
//			//Ship Country	C(50)	No	N/A	
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col25"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'country', lsTemp)
//			End If				
			
			//14	Contact	contact1	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col14"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'contact_person', lsTemp)
			End If						
			
			//15	Phone number	phone1	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col15"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'tel', lsTemp)
			End If				

			//MEA 3/13 - Added Fax, City, Postal Code
			
			//16	Fax number	fax1	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'fax', lsTemp)
			End If				
			
			//17	City	Char(40)	
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col17"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'city', lsTemp)
			End If					
			
			//18	Postal Code	Char(40)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col18"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'zip', lsTemp)
			End If						

			//19 - Stryker Order Number -> UF12
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field12', lsTemp)
			End If		
			
			//20 - Customer PO
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col20"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'order_No', lsTemp)
			End If		
			
			// 05/14 - PCONKL, Notes now 21 - 	Notes *	Notes	Char(2000)

			//Remarks	C(255)	No	N/A	
		
			//7	Notes *	Notes	Char(2000)			
			//* For Warehouse No = Salesman Warehouse				
			//7	Notes	Notes		SIMS Order Information field

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col21"))
	
			//7.1	Salesteam Code	Sales Team	Char(4)	user field 4
			
			lsTempNote = left(lsTemp,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field4', lsTempNote)
			End If			
			
			//7.2	Salesman Code	Salesman Code	Char(4)	user field 5
			
			lsTempNote = mid(lsTemp,5,4)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field5', lsTempNote)
			End If				
						
			//7.3	Salesman Name	Salesman Name	Char(40)	user field 6
	
			lsTempNote = mid(lsTemp,9,6)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field6', lsTempNote)
			End If	
			
			//7.4	Salesman Address Line 1	Salesman Address Line 1	Char(40)	user field 7
			
			lsTempNote = mid(lsTemp,15,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field7', lsTempNote)
			End If			
			
			//7.5	Salesman Address Line 2	Salesman Address Line 2	Char(40)	user field 8
			
			lsTempNote = mid(lsTemp,55,40)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'user_field8', lsTempNote)
			End If				
			
			
			//7.6	Notes	Notes	Char(1872)	Remark (char 255)
	
			lsTempNote = mid(lsTemp,95,255)
			
			If NOT(IsNull(lsTempNote) OR trim(lsTempNote) = '') Then
				ldsSOheader.SetItem(liNewRow,'Remark', lsTempNote)
			End If		
			
			//22 - Company Code -> UF3
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col19"))
	
			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
				ldsSOheader.SetItem(liNewRow,'User_field3', lsTemp)
			End If	
				
//			//Ship To Email		C(50)	No	N/A
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col58"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSOheader.SetItem(liNewRow,'email_address', lsTemp)
//			End If			
			
								
		// DETAIL RECORD

		Case 'DT' /*Detail */

		//	lsSupplier = "IN_STRYKER"

		// 05/14 - PCONKL - PK is now OO
//			If lsTransactionType = "PK" Then
			If lsTransactionType = "OO" Then
				lsChangeID = "A"
			End If

			// 05/14 - PCONKL - In old format, we were ignoring OT records since we would be building the Detail/Pick records from the LD records
			// In the new format, we still don't need to build the detail records from the OC but we need to uild them because we need Supplier/UOM and any user fields that are only on the OC. They will be deleted at the end and not written to EDI Detail
			
//			If lsTransactionType = "OT" Then Continue
			
			
			//3	Line No	Line Number	Char(20)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				llLineItemNo = Long(lsTemp)
			End If	
			
			//4	Document No	Doc Type + Doc No	Char(20)

			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				
		
				//Make sure we have a header for this Detail...
				If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
					lbDetailError = True
				End If
					
				lsOrderNumber = lsTemp
			End If			

		
			//5	Item No	Stryker Item No	Char(30)

	
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsSku = lsTemp
			End If				
			
//			// 05/14 - PCONKL - Supplier 6 - will be concatonated with UOM for the SIMS Supplier
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				lsSupplier = lsTemp
//			End If				
//			
//			//Trim off any leading zeros in supplier
//			Do While left(lsSupplier,1) = '0'
//				lsSupplier = Mid(lsSupplier,2,99)
//			Loop
			
			// 05/14 - PCONKL  Qty now in 6 - 	Quantity	Quantity	Number(38)
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				ldQuantity = Dec(lsTemp)
			End If			

			// 05/14 - PCONKL - UOM 7 - will be concatonated with Supplier for the SIMS Supplier
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - UOM is required. Record will not be processed.")
				lbError = True
				Continue		
			Else
				lsUOM = lsTemp
			End If			
			
	
			/* End Required */
		
		
			lbDetailError = False
			llNewDetailRow = 	ldsSODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsSODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
//			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInventoryType) 
			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrderNumber)			
//			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	

			ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',"STRYKER-" + lsUOM) /*Supplier Code = Stryker + '-' + UOM*/	
			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
			
			ldsSODetail.SetItem(llNewDetailRow,'User_Field1',lsSupplier)
			
			ldsSODetail.SetItem(llNewDetailRow,'pick_po_no', lsStrykerWarehouse)
			
			//If Transaction Type OC, we will delete these records after we extract Supplier/UOM. DEtail rows created from LD record type
//			If lsTransactionType = "OC" Then 
//				ldsSODetail.SetItem(llNewDetailRow,'action_cd','X')
//			End If


	// 05/14 - PCONKL - LD only coming in on OC file which we're not processing
//	CASE 'LD'
//
//			//lsSupplier = "IN_STRYKER"
//			lsChangeID = "A"
//
//			//3	Line No	Line No	Char(20)
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col3"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Line Item Number is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				llLineItemNo = Long(lsTemp)
//			End If	
//			
//			//4	Sub Line No	Sub Line No	Char(20) 
//			
//			
//			//5	Document No	Doc Type + Doc No	Char(20) 
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col5"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				
//		
//				//Make sure we have a header for this Detail...
//				If ldsSOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1, ldsSOHeader.RowCount()) = 0 Then
//					gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
//					lbDetailError = True
//				End If
//					
//				lsOrderNumber = lsTemp
//			End If			
//
//		
//			//6	Product Code	SKU	Char(30)
//
//	
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col6"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Sku is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				lsSku = lsTemp
//			End If
//			
//			//7	Quantity	Quantity	Number(38)
//
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col7"))
//			
//			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
//				gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Quantity is required. Record will not be processed.")
//				lbError = True
//				Continue		
//			Else
//				ldQuantity = Dec(lsTemp)
//			End If			
//
//			//8	Lot No	Lot No	Char(45)
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col8"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'lot_no', lsTemp)
//// TAM 2013/10 -  Added to 'Pick_lot_no'  so operations can regenerate the picklist and override FEFO				
//				ldsSODetail.SetItem(llNewDetailRow,'pick_lot_no', lsTemp)
//			End If				
//
//// TAM 2013/10 -  Added to 'Pick_po_no'  from header user_field18 to allow picking from proper warehouse				
//			If NOT(IsNull(lsStrykerWarehouse) OR trim(lsStrykerWarehouse) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'pick_po_no', lsStrykerWarehouse)
//			End If				
//			
//			//9	Expiry Date		Date
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col9"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
////				ldsSODetail.SetItem(llNewDetailRow,'Expiration_Date', datetime(lsTemp))
//				ldsSODetail.SetItem(llNewDetailRow,'user_field2', lsTemp)
//			End If					
//			
//			//10	MFG Date		Date
//			
//			//11	Lot Barcode	Lot barcode	Char(45)
//			
//			//Serial Number	C(50)	No	N/A	Qty must be 1 if present
//			
//			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col16"))
//	
//			If NOT(IsNull(lsTemp) OR trim(lsTemp) = '') Then
//				ldsSODetail.SetItem(llNewDetailRow,'serial_no', lsTemp)
//			End If						
//			
//			
//			//12	Item Barcode	Item barcode	Char(45)
//			//		
//
//	
//			/* End Required */
//		
//		
//			lbDetailError = False
//			llNewDetailRow = 	ldsSODetail.InsertRow(0)
//			llLineSeq ++
//					
//			//Add detail level defaults
//			ldsSODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
//			ldsSODetail.SetItem(llNewDetailRow,'project_id', asProject) /*project*/
//			ldsSODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
////			ldsSODetail.SetItem(llNewDetailRow,'Inventory_Type', lsInventoryType) 
//			ldsSODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
//			ldsSODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
//			
//			ldsSODetail.SetItem(llNewDetailRow,'invoice_no',lsOrderNumber)			
////			ldsSODetail.SetItem(llNewDetailRow,'action_cd',lsChangeID) /*Supplier Order*/	
//
//			ldsSODetail.SetItem(llNewDetailRow,'sku',lsSku) /*Sku*/	
//			ldsSODetail.SetItem(llNewDetailRow,'Supp_Code',lsSupplier) /*Supplier Code*/	
//			ldsSODetail.SetItem(llNewDetailRow,'Line_Item_No',llLineItemNo) /*Line_Item_No*/	
//			ldsSODetail.SetItem(llNewDetailRow,'Quantity', String(ldQuantity)) /*Quantity*/				
//			
//
//

	CASE Else /* Invalid Rec Type*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type--: '" + lsTemp + "'. Record will not be processed.")
		Continue	

	End Choose /*Header or Detail */
	
	
Next /*File record */


//IF lirc = -1 then lbError = true else lbError = false	


//Save the Changes 
SQLCA.DBParm = "disablebind =0"
lirc = ldsSOheader.Update()
SQLCA.DBParm = "disablebind =1"

	
If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"
	liRC = ldsSOdetail.Update()
	SQLCA.DBParm = "disablebind =1"
	
ELSE
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new SO Header Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new SO Records to database!")
	Return -1
End If



	
If liRC = 1 then
//	Commit;

//BCR 12-30-11 Geistlich UAT Session...
//why comment out this Commit? It is the cause of this UOM issue we have found in Geistlich UAT...
Commit;
//End

Else
	
//	Execute Immediate "ROLLBACK" using SQLCA; 
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Delivery Notes Records to database!"
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

public function integer uf_process_oc_file (string aspath, string asproject);
// 07/14 - PCONKL - 'OC' file only used to set order status to "ready to Ship".

u_ds_datastore ldsImport
integer llFileRowPos
integer llFilerowCount

String	lsLogOut, lsTemp, lsDONO
Int		liRtnImp


ldsImport = Create u_ds_datastore
ldsImport.dataobject = 'd_baseline_unicode_generic_import'

//Open and read the File In
lsLogOut = '      - Opening OC File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Bring in File
liRtnImp =  ldsImport.ImportFile( Text!, aspath) 

if liRtnImp < 0 then
	lsLogOut = "-       ***Unable to Open OC Order File for "+asproject+" Processing: " + asPath + " Import Error: " + string(liRtnImp)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if


llFilerowCount = ldsImport.RowCount()

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing OC Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
		
	//Validate Transaction Type is OC
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col1"))
	If NOT ( lsTemp = 'OC') Then
		lsLogOut = "      - Row: " + string(llFileRowPos) + " - Invalid Transation Type: '" + lsTemp + "'. Record will not be processed."
		FileWrite(giLogFileNo,lsLogOut)
		Continue /*Process Next Record */
	End If

		
	//Validate Rec Type is DM OR DD
	lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col2"))
	If NOT (lsTemp = 'HD' OR lsTemp = 'DT' OR lsTemp = 'LD') Then
		lsLogOut = "      - Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed."
		FileWrite(giLogFileNo,lsLogOut)
		Continue /*Process Next Record */
	End If

	Choose Case Upper(lsTemp)
	
			
		//HEADER RECORD
		Case 'HD' /* Header */
					
			
			//Column 4 is the order number
			
			lsTemp = Trim(ldsImport.GetItemString(llFileRowPos, "col4"))
			
			If IsNull(lsTemp) OR trim(lsTemp) = '' Then
				gu_nvo_process_files.uf_writeError("      - Row: " + string(llFileRowPos) + " - Order Number is required. Record will not be processed.")
				Continue		
			End If				
			
			//will only update if currently in packing status
			
			lsDONO = ""
			
			Select max(do_no) into :lsdono
			From Delivery_MAster
			Where project_id = 'STRYKER' and invoice_no = :lsTemp and ord_status = 'A'
			Using SQLCA;
			
			If lsDONO > '' Then
				
				Update Delivery_Master
				Set ord_status = 'R'
				Where do_no = :lsDONO
				Using SQLCA;
				
				Commit;
				
				lsLogOut = "        - Stryker Order: '" + lsTemp + "'. Order Status changed to Ready to Ship."
				FileWrite(giLogFileNo,lsLogOut)
				
			Else
				
				lsLogOut = "        - Stryker Order: '" + lsTemp + "'. Order not found or order not in PAcking status. No updates applied."
				FileWrite(giLogFileNo,lsLogOut)
		
			End If
			
	End Choose
		
Next

Return 0
end function

on u_nvo_proc_stryker.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_stryker.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

