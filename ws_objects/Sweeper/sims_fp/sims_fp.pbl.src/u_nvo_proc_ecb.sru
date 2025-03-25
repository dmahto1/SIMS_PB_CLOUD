$PBExportHeader$u_nvo_proc_ecb.sru
$PBExportComments$Process Emery Custom Brokerage Files
forward
global type u_nvo_proc_ecb from nonvisualobject
end type
end forward

global type u_nvo_proc_ecb from nonvisualobject
end type
global u_nvo_proc_ecb u_nvo_proc_ecb

type variables


end variables

forward prototypes
public function string uf_Return_Tag_value (long alTagRow)
public function integer uf_process_files (string asproject, string asfile, string asinifile, ref datastore adsxml)
public function integer uf_process_po (string asfile, ref datastore adsxml)
end prototypes

public function string uf_Return_Tag_value (long alTagRow);//return the tag data for the current row of the datastore

String	lsTag




Return lsTag


end function

public function integer uf_process_files (string asproject, string asfile, string asinifile, ref datastore adsxml);String	lsLogOut,	&
			lsStringData
			
Integer	liRC
Long		llRow,	&
			llRowPos,	&
			llRowCount

SetPointer(Hourglass!)

llRowCount = adsxml.RowCOunt()

//Determine file type and process accordingly 
lsStringData = ''
If llRowCount > 2 Then
	For llRowPos = 1 to 3 /*- look for the tag in the first 3 rows.*/
		lsStringData += Upper(Trim(adsxml.GetItemString(llRowPos,'tag_name')))
	Next
Else /* pretty much invalid file*/
End If

// look for tag of file type
If pos(Upper(lsStringData),'<SBI_XTRANS_1.0>') > 0 Then /* PO/ASN File */ 
	liRC = uf_process_po(asFile,adsxml)
Else /*invalid file type*/
	lsLogOut = "- ***Unable to determine file type to process for ECB. File will not be processed: " + asFile
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If


Return liRC
end function

public function integer uf_process_po (string asfile, ref datastore adsxml);//Extract PO data and save to SIMS Generic EDI tables

Long	llRowCOunt,	&
		llEntryStartPos,llEntryEndPos,	&
		llInvoiceStartPos, llInvoiceEndPos,	&
		llDetailStartPos, llDetailEndPos,	&
		llStart,	llEnd,			&
		llHeaderRow,	llDetailRow,	&
		llFindRow,	&
		llOrderSeq
		
Decimal	ldEDIBAtchSeq

String	lsLogOut,	&
			lsArrivalDate,	&
			lsShipDate,	&
			lsSUpplier,	lsProject,	lsWarehouse,	&
			lsOrderNo,	lsCustomsDoc,	lsTransPortMode,	&
			lsTemp
			
Integer	liRC

DataStore	ldsHeader,	ldsDetail

llRowCount = adsxml.RowCount()

ldsHeader = Create u_ds_datastore
ldsHeader.dataobject= 'd_po_header'
ldsHeader.SetTransObject(SQLCA)

ldsDetail = Create u_ds_datastore
ldsDetail.dataobject= 'd_po_detail'
ldsDetail.SetTransObject(SQLCA)

//Extract 'Entry Data' fields - Should only be 1 entry data tag per file

llEntryStartPos = adsxml.Find("upper(tag_name) = '<ENTRY_DATA>'",1,llRowCount) /*start of Tag*/
If llEntryStartPos <= 0 Then
	lsLogOut = "- XML Parsing Error - '<ENTRY_DATA> tag not found. File will not be processed."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

llEntryEndPos = adsxml.Find("upper(tag_name) = '</ENTRY_DATA>'",1,llRowCount) /*end of Tag*/
If llEntryEndPos <= 0 Then
	lsLogOut = "- XML Parsing Error - '</ENTRY_DATA> end tag not found. File will not be processed."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Find Entry Data fields between start and End - These fields will be used in 1 or more invoice header records created below

// <CUST_ID> -> Project ID
llFindRow = adsxml.Find("upper(tag_name) = '<CUST_ID>'",llEntryStartPos,llEntryEndPos)
If llFindRow > 0 Then
	lsProject = adsxml.GetITemString(llFindRow,'tag_data')
End If

//Customs Doc
llFindRow = adsxml.Find("upper(tag_name) = '<CUSTOMS_DOC>'",llEntryStartPos,llEntryEndPos)
If llFindRow > 0 Then
	lsCustomsDoc = adsxml.GetITemString(llFindRow,'tag_data')
End If

//Transport Mode
llFindRow = adsxml.Find("upper(tag_name) = '<TRANS_MODE>'",llEntryStartPos,llEntryEndPos)
If llFindRow > 0 Then
	lsTransportMode = adsxml.GetITemString(llFindRow,'tag_data')
End If


// <ARRIVAL_DATE> -> Scheduled Arrival Date
llFindRow = adsxml.Find("upper(tag_name) = '<ARRIVAL_DATE>'",llEntryStartPos,llEntryEndPos)
If llFindRow > 0 Then
	LsTemp = adsxml.GetITemString(llFindRow,'tag_data')
	lsArrivalDate = mid(lsTemp,3,2) + '-' + Right(lsTEmp,2) + '-' + '20' + left(lsTemp,2) /*format as valid date - YYMMDD -> MM-DD-YY*/
End If

// <EXPORT_DATE> -> Ship Date
llFindRow = adsxml.Find("upper(tag_name) = '<EXPORT_DATE>'",llEntryStartPos,llEntryEndPos)
If llFindRow > 0 Then
	LsTemp = adsxml.GetITemString(llFindRow,'tag_data')
	lsShipDate = mid(lsTemp,3,2) + '-' + Right(lsTEmp,2) + '-' + '20' + left(lsTemp,2) /*format as valid date - YYMMDD -> MM-DD-YY*/
End If

llFindRow = 0
// For now, Supplier ID is coming from <Manuf_Data> (we get it from Supplier_ID in Entry_Data)
llStart = adsxml.Find("upper(tag_name) = '<MANUF_DATA>'",llEntryStartPos,llEntryEndPos)
If llStart > 0 Then
	llEnd = adsxml.Find("upper(tag_name) = '</MANUF_DATA>'",llStart,llEntryEndPos)
	If llEnd > 0 Then
		llFindRow = adsxml.Find("upper(tag_name) = '<ID>'",llStart,llEnd)
	End If
End If

If llFindRow > 0 Then
	lsSupplier = adsxml.GetITemString(llFindRow,'tag_data')
Else
	lsSupplier = 'SS' /*default*/
End If

//Loop through Invoice Records and Build header/detail records

llFindRow = adsxml.Find("upper(tag_name) = '<INVOICE_DATA>'",llEntryEndPos,adsxml.RowCount()) /*make sure invoce data is present*/

If llFindRow <= 0 Then
	lsLogOut = "- No invoice Data found. File will not be processed."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//get Next SEQ Number for Header FIle
ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If ldEDIBatchSeq < 0 Then
	Return -1
End If
	
//Default Warehouse to project Default
Select wh_code into :lsWarehouse
From Project
Where Project_id = :lsProject;

If isnull(lsWarehouse) then lsWarehouse = ''
	
//Position to First Invoice
llInvoiceStartPos = adsxml.Find("upper(tag_name) = '<INVOICE>'",llFindRow,llRowCount) /*start of Tag*/

//Process Each Invoice
Do WHile llInvoiceStartPos > 0
	
	llInvoiceEndPos = adsxml.Find("upper(tag_name) = '</INVOICE>'",llInvoiceStartPos,llRowCount) /*end of Tag*/
	If llInvoiceEndPos <= 0 Then
		lsLogOut = "- XML Parsing Error - '</INVOICE> end tag not found. File will not be processed."
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Return -1
	End If
	
	//Header Information
	llEnd = adsxml.Find("upper(tag_name) = '</INVOICE_HEADER>'",llInvoiceStartPos,llInvoiceEndPos) /*only search until here for header info*/
	
	//Invoice Number
	llFindRow = adsxml.Find("upper(tag_name) = '<INV_NO>'",llInvoiceStartPos,llEnd)
	If llFindRow > 0 Then
		lsOrderNo = adsxml.GetITemString(llFindRow,'tag_data')
	Else /*not found*/
		lsOrderNo = ''
	End If
	
	//Create the EDI Header Record
	llheaderROw = ldsHeader.InsertRow(0)
	
	ldsHeader.SetItem(llheaderRow,'action_cd','A') /*Default to Add*/
	ldsHeader.SetItem(llheaderRow,'order_no',lsOrderNo)
	ldsHeader.SetITem(llheaderRow,'project_id',lsProject)
	ldsHeader.SetITem(llheaderRow,'wh_code',lsWarehouse)
	ldsHeader.SetITem(llheaderRow,'supp_code',lsSupplier) 
	ldsHeader.SetITem(llheaderRow,'customs_doc',lsCustomsDoc) 
	ldsHeader.SetITem(llheaderRow,'transport_mode',lsTransportMode) 
	ldsHeader.SetITem(llheaderRow,'Request_date',lsShipDate) /*request date in DB maps to Ship Date on RO screen*/
	ldsHeader.SetITem(llheaderRow,'Arrival_date',lsArrivalDate)
	ldsHeader.SetItem(llheaderRow,'Order_type','S') /*Supplier Order*/
	ldsHeader.SetItem(llheaderRow,'Inventory_Type','N') /*default to Normal*/
	ldsHeader.SetItem(llheaderRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
	ldsHeader.SetItem(llheaderRow,'order_seq_no',llHeaderRow) /*row number will act as unique file seq*/
	ldsHeader.SetItem(llheaderRow,'ftp_file_name',asfile) /*FTP File Name*/
	ldsHeader.SetItem(llheaderRow,'Status_cd','N')
	ldsHeader.SetItem(llheaderRow,'Last_user','SIMSEDI')
	
	//Process Details for Current Invoice
	
	//Position to First Detail
	llDetailStartPos = adsxml.Find("upper(tag_name) = '<DETAIL_LINE>'",llInvoiceStartPos,llInvoiceEndPos) /*start of Tag*/
	
	Do While llDetailStartPos > 0
		
		llDetailEndPos = adsxml.Find("upper(tag_name) = '</DETAIL_LINE>'",llDetailStartPos,llInvoiceEndPos) /*end of Tag*/
		If llDetailEndPos <= 0 Then
			lsLogOut = "- XML Parsing Error - '</DETAIL_ROW> end tag not found. File will not be processed."
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
		End If
		
		//Build EDI DEtail Record
		llDetailRow = ldsDetail.InsertRow(0)
		
		ldsDetail.SetItem(llDetailRow,'action_cd','A') /*Default to Add*/
		ldsDetail.SetItem(llDetailRow,'order_no',lsOrderNo)
		ldsDetail.SetItem(llDetailRow,'project_id',lsProject)
		ldsDetail.SetItem(llDetailRow,'Status_cd','N')
		ldsDetail.SetItem(llDetailRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		ldsDetail.SetItem(llDetailRow,'order_seq_no',llHeaderRow) /*header row number will act as unique file seq*/
		ldsDetail.SetItem(llDetailRow,"order_line_no",string(llDetailRow)) /*detail row will act as unique order line No*/
		
		//Line Item Number
		llFindRow = adsxml.Find("Upper(tag_name) = '<LINE_NO>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'line_item_no',Long(adsxml.GetItemString(llFindRow,'tag_data')))
		End If
		
		//SKU
		llFindRow = adsxml.Find("Upper(tag_name) = '<PART_NO>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'SKU',adsxml.GetItemString(llFindRow,'tag_data'))
		End If
		
		//Quantity
		llFindRow = adsxml.Find("Upper(tag_name) = '<PIECE_CNT>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'Quantity',adsxml.GetItemString(llFindRow,'tag_data'))
		End If
		
		//Lot No
		llFindRow = adsxml.Find("Upper(tag_name) = '<LOT_NO>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'lot_no',adsxml.GetItemString(llFindRow,'tag_data'))
		End If
		
		//Inventory Type
		llFindRow = adsxml.Find("Upper(tag_name) = '<INVENTORY_TYPE>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'inventory_type',adsxml.GetItemString(llFindRow,'tag_data'))
		End If
		
		//Alternate SKU
		llFindRow = adsxml.Find("Upper(tag_name) = '<ALT_REF_NO>'",llDetailStartPos,llDetailEndPos)
		If llFindRow > 0 Then
			ldsDetail.SetITem(llDetailRow,'alternate_sku',adsxml.GetItemString(llFindRow,'tag_data'))
		End If
		
		//Look for Next Detail Row
		llDetailStartPos = adsxml.Find("upper(tag_name) = '<DETAIL_LINE>'",llDetailEndPos,llInvoiceEndPos) /*start of Tag*/
		
	Loop /*Next Invoice Detail Record*/
	
	//Look for Next Invoice
	llInvoiceStartPos = adsxml.Find("upper(tag_name) = '<INVOICE>'",llInvoiceEndPos,llRowCount) /*start of Tag*/
	
Loop /*Next Invoice*/

//Save Header and DEtail records

	
lirc = ldsheader.Update()
If liRC = 1 then /*header Saved*/
	//Save Detail record to DB
	lirc = ldsdetail.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = "- ***System Error!  Unable to Save new Purchase Order Detail (EDI_Inbound_Detail) to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
	End If
Else
	Rollback;
	lsLogOut = "- ***System Error!  Unable to Save new Purchase Order Header to database (EDI_Inbound_Header)!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogout)
End If

If liRC < 0 Then Return -1
	
//Process the PO records
//liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 

Return liRC
end function

on u_nvo_proc_ecb.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ecb.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

