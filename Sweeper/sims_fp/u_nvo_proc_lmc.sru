HA$PBExportHeader$u_nvo_proc_lmc.sru
$PBExportComments$Process LMC files
forward
global type u_nvo_proc_lmc from nonvisualobject
end type
end forward

global type u_nvo_proc_lmc from nonvisualobject
end type
global u_nvo_proc_lmc u_nvo_proc_lmc

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsDoAddress,	&
				iu_DS
				
u_ds_datastore	idsItem 

				



end variables

forward prototypes
public function integer uf_process_so (string aspath, string asproject, string aswarehouse)
protected function integer uf_process_po (string aspath, string asproject, string aswarehouse)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile, string asinisection)
public function integer uf_process_dboh (string asparmstring)
end prototypes

public function integer uf_process_so (string aspath, string asproject, string aswarehouse);//Process Sales Order files for LMC
				
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsDieboldWarehouse, lsOwner, lsNotes

String 		ls_carrier,ls_ship_ref,ls_ship_via,ls_transport_mode, lsNull, lsOrder, lsSKU, lsAltSku
Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow, llNewAddressRow, llNewRow, llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner
				
Decimal		ldQty
				
DateTime		ldtOrderDate, ldtNow
Date			ldtShipDate
Boolean		lbError, lbValidAddress
Datastore	lu_ds

//Order Date is Server Time (GMT) + 8 hours
ldtNow = DateTime(today(),Now())

select Max(dateAdd( hour, 8,:ldtNow )) into :ldtOrderDate
from sysobjects;

SetNull(lsNull)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

If Not isvalid(idsDOHeader) Then
	idsDoHeader = Create Datastore
	idsDOHeader.dataobject = 'd_mercator_do_Header'
	idsDOHeader.SetTransObject(SQLCA)
End If
	
If NOt isvalid(idsDoDetail) Then
	idsDODetail = Create Datastore
	idsDODetail.dataobject = 'd_mercator_do_Detail'
	idsDODetail.SetTransObject(SQLCA)
End If


IF NOt isvalid(idsDOAddress) Then
	idsDOAddress = Create DataStore
	idsDOAddress.DataObject = 'd_mercator_do_address'
	idsDOAddress.SetTransObject(SQLCA)
End IF

idsDOHeader.reset()
idsDODetail.reset()
idsDOAddress.reset() 


//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for LMC Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsRecData))
	liRC = FileRead(liFileNo,lsRecData)
Loop /*Next File record*/

FileClose(liFileNo)

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if

//MEA - 10/12 - Get warehouse from INI

lswarehouse = aswarehouse


////Warehouse will have to be defaulted from project master default warehouse
//Select wh_code into :lswarehouse
//From Project
//Where Project_id = :asProject;

llOrderSeq = 0 /*order seq within file*/


//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,4) /* rec type should be first 4 char of file*/
	
	/*Process Various Record Types*/
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'H001' /* Header */
						
			//llnewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			
			//Record Defaults
			llNewHeaderRow = idsDOHeader.InsertRow(0)		
			
			idsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			idsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			
			idsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			idsDOHeader.SetITem(llNewHeaderRow,'order_Type','S') /*Sale */
			idsDOHeader.SetITem(llNewHeaderRow,'wh_code',lswarehouse) /*Default WH for Project */
			
			//Order Number
			If Trim(Mid(lsRecData,25,14)) > '' Then
				lsOrder = Trim(Mid(lsRecData,25,14))
				idsDOheader.SetItem(llNewHeaderRow,'invoice_no',lsOrder)
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Order Number expected. Record will not be processed.")
			End If
			
			
			//Customer Order Number
			If Trim(Mid(lsRecData,39,20)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'order_no',Trim(Mid(lsRecData,39,20)))
			End If
			
			//Sell To Customer Nbr - Store in Alt Address table - Address will be populated in H006 record type
			If Trim(Mid(lsRecData,59,12)) > '' Then
				
				lbValidAddress = True
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
				idsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Sold To Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',Trim(Mid(lsRecData,59,12)))
				
				//Also Store in Cust_Code
				idsDOHeader.SetITem(llNewHeaderRow,'cust_Code',Trim(Mid(lsRecData,59,12)))
					
			Else
				
				lbValidAddress = False
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Sold To Customer Number expected. Record will not be processed.")
				
			End If
			
			
			//Sales Order Number (UF5)
			If Trim(Mid(lsRecData,81,20)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'User_Field5',Trim(Mid(lsRecData,81,20)))
			End If
			
			
		Case 'H002' /* More header (Dates) */
			
			
			//Order Date - Default to Server time (GMT)  + 8 hours - Calculated above
			idsDOheader.SetItem(llNewHeaderRow,'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
		
			//Shipment Date
			If Trim(Mid(lsRecData,27,8)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'Request_date',Mid(lsRecData,27,4) + "/" + Mid(lsRecData,31,2) + "/" + Mid(lsRecData,33,2))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Shipment Date  expected. Record will not be processed.")
			End If
			
			
		Case 'H003' /* more header (Ship To Info) */
			
			//Ship to Name
			If Trim(Mid(lsRecData,15,40)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'cust_name',Trim(Mid(lsRecData,15,40)))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Ship To Name expected. Record will not be processed.")
			End If
			
			//Ship to Address 1
			If Trim(Mid(lsRecData,55,40)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'address_1',Trim(Mid(lsRecData,55,40)))
			End If
			
			//Ship to Address 2
			If Trim(Mid(lsRecData,95,40)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'address_2',Trim(Mid(lsRecData,95,40)))
			End If
			
			//Ship to City
			If Trim(Mid(lsRecData,135,40)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'city',Trim(Mid(lsRecData,135,40)))
			End If
			
			
		Case 'H004' /*More header Address */
			
			//Ship to County (Address 4)
			If Trim(Mid(lsRecData,15,40)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'address_4',Trim(Mid(lsRecData,15,40)))
			End If
			
			
			//Ship to Country
			If Trim(Mid(lsRecData,135,3)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'Country',Trim(Mid(lsRecData,135,3)))
			End If
			
			
		Case 'H005' /* Header Ship To */
			
			//Ship to Zip Code
			If Trim(Mid(lsRecData,15,10)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'zip',Trim(Mid(lsRecData,15,10)))
			End If
			
			//Ship to Contact
			If Trim(Mid(lsRecData,25,25)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'Contact_person',Trim(Mid(lsRecData,25,25)))
			End If
			
			//tel
			If Trim(Mid(lsRecData,50,15)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'tel',Trim(Mid(lsRecData,50,15)))
			End If
			
			
		Case 'H006' /*Header - sell to Info */
			
			
			//Sell To Name (address 1)
			If Trim(Mid(lsRecData,15,40)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'address_1',Trim(Mid(lsRecData,15,40)))
			End If
			
			//Sell To Address 1 (address 2)
			If Trim(Mid(lsRecData,55,40)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'address_2',Trim(Mid(lsRecData,55,40)))
			End If
			
			//Sell To Address 2 (address 3)
			If Trim(Mid(lsRecData,95,40)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'address_3',Trim(Mid(lsRecData,95,40)))
			End If
			
			//Sell ToCity
			If Trim(Mid(lsRecData,135,40)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'city',Trim(Mid(lsRecData,135,40)))
			End If
			
			
			
		Case 'H007' /* Header - More Sell To */
			
			//Sell To County  (address 4)
			If Trim(Mid(lsRecData,15,40)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'address_4',Trim(Mid(lsRecData,15,40)))
			End If
			
			//Sell To Country
			If Trim(Mid(lsRecData,175,3)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'country',Trim(Mid(lsRecData,175,3)))
			End If
			
			//Sell To Zip
			If Trim(Mid(lsRecData,198,10)) > '' and lbValidAddress Then
				idsDOAddress.SetItem(llNewAddressRow,'Zip',Trim(Mid(lsRecData,198,10)))
			End If
			
			
		Case 'H008' /* Header */
			
			
			//Shipment Method (User Field 8) - Really Freight Terms
			If Trim(Mid(lsRecData,15,40)) > '' Then
				//idsDOheader.SetItem(llNewHeaderRow,'User_Field8',Trim(Mid(lsRecData,15,40)))
				idsDOheader.SetItem(llNewHeaderRow,'Freight_Terms',Trim(Mid(lsRecData,15,40)))
			End If
			
			//Shipping Agent (User Field 9) - Really Carrier
			If Trim(Mid(lsRecData,55,40)) > '' Then
				//dsDOheader.SetItem(llNewHeaderRow,'User_Field9',Trim(Mid(lsRecData,55,40)))
				idsDOheader.SetItem(llNewHeaderRow,'Carrier',Trim(Mid(lsRecData,55,40)))
			End If
			
			//Shipping Agent Service  (User Field 10) - Really Ship Via
			If Trim(Mid(lsRecData,95,40)) > '' Then
				//idsDOheader.SetItem(llNewHeaderRow,'User_Field10',Trim(Mid(lsRecData,95,40)))
				idsDOheader.SetItem(llNewHeaderRow,'Ship_Via',Trim(Mid(lsRecData,95,40)))
			End If
			
			
		Case "H009" /*nothing mapped*/
			
		Case 'H012'
			
			//Country Key (UF 2)
			If Trim(Mid(lsRecData,21,2)) > '' Then
				idsDOheader.SetItem(llNewHeaderRow,'User_Field2',Trim(Mid(lsRecData,21,2)))
			End If
			
			//Priority
			If Trim(Mid(lsRecData,23,1)) > ''  and isnumber(Trim(Mid(lsRecData,23,1))) Then
				idsDOheader.SetItem(llNewHeaderRow,'priority',Dec(Trim(Mid(lsRecData,23,1))))
			End If
			
			
		
		// DETAIL RECORD
		Case 'L001' /*Detail - IGNORE */
			
			
		Case 'L002' /* Detail */
					
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsDODetail.InsertRow(0)
			idsDODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsDODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			idsDODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			idsDODetail.SetITem(llNewDetailRow,"line_item_no",llLineSeq) /*generating Line item*/
			idsDODetail.SetITem(llNewDetailRow,'invoice_no',lsOrder) 
				
			//SKU
			If Trim(Mid(lsRecData,15,20)) > ''  Then
				
				lsSKU = Trim(Mid(lsRecData,15,20))
				idsDODetail.SetITem(llNewDetailRow,'SKU',lsSKU)
				
				//Load Alt SKU from Item Master
				lsAltSKU = ''
				
				Select Max(alternate_sku) into :lsAltSKU
				From Item_MAster where project_id = 'LMC' and sku = :lsSKU;
				
				If lsAltSku > '' Then
					idsDODetail.SetITem(llNewDetailRow,'Alternate_SKU',lsAltSku)
				End If
				
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " SKU  expected. Record will not be processed.")
			End If
			
			//MEA - 10/16/12 - Set Supp_Code
			
			if aswarehouse = 'LMC-MY' then
				idsDODetail.SetItem(llNewDetailRow,'supp_code','MYLMC')
			else
				idsDODetail.SetItem(llNewDetailRow,'supp_code','LMC')
			end if			
					
			
			
			//Qty
			If Trim(Mid(lsRecData,135,10)) > ''  Then
				idsDODetail.SetITem(llNewDetailRow,'quantity',Trim(Mid(lsRecData,135,10)))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Qty  expected. Record will not be processed.")
			End If
			
			
			
		Case Else /*Invalid rec type */
		
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
		
Next  /*Next File record*/


//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = idsDOAddress.Update()
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

protected function integer uf_process_po (string aspath, string asproject, string aswarehouse);//Process PO for LMC

Datastore	lu_ds

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType,  lsSKU, lsAltSKU,  lsSupplier
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount,  llLineItemNo
Boolean	lbError, lbDetailError
DateTime	ldtToday, ldtOrderDate
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

ldtToday = DateTime(Today(),Now())

//Order Date is GMT + 8 (SIN time)
select Max(dateAdd( hour, 8,:ldtToday )) into :ldtOrderDate
from sysobjects;

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'


If Not isvalid(idsPOHeader) Then
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
	idsPOheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsPOdetail) Then
	idsPOdetail = Create u_ds_datastore
	idsPOdetail.dataobject= 'd_po_detail'
	idsPOdetail.SetTransObject(SQLCA)
End If

//Open and read the File In
lsLogOut = '      - Opening File for LMC Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for LMC Processing: " + asPath
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


//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//MEA - 10/12 - Get warehouse from INI

lswarehouse = aswarehouse

////Warehouse will have to be defaulted from project master default warehouse
//Select wh_code into :lswarehouse
//From Project
//Where Project_id = :asProject;

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	
	
	Choose Case Upper(Left(lsRecData,4)) /* Rec type is first 4 characters of record */
			
		Case 'P021' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			idsPOheader.SetItem(llNewRow, 'wh_code',lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'ord_date',String(ldtOrderDate,'yyyy/mm/dd hh:mm'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
			if aswarehouse = 'LMC-MY' then
				idsPOheader.SetItem(llNewRow,'supp_code','MYLMC')
			else
				idsPOheader.SetItem(llNewRow,'supp_code','LMC')
			end if
			
			idsPOheader.SetItem(llNewRow,'action_cd','X') /*Add or Update*/
															
			//Order Number
			If Trim(Mid(lsRecData,21,8)) > '' Then
				lsOrder = Trim(Mid(lsRecData,21,8))
				idsPOheader.SetItem(llNewRow,'order_no',lsOrder)
				idsPOheader.SetItem(llNewRow,'ship_ref',lsOrder) /*set Rcv Slip Nbr as well */
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Order Number expected. Record will not be processed.")
			End If
		
			
			//Supplier Code - Defaulting to LMC for now
//			If Trim(Mid(lsRecData,49,10)) > '' Then
//				idsPOheader.SetItem(llNewRow,'supp_code',Trim(Mid(lsRecData,49,10)))
//			Else
//				lbError = True
//				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + "Supplier Code expected. Record will not be processed.")
//			End If
			
			
			//Expected Arrival Date
			If Trim(Mid(lsRecData,59,8)) > '' Then
				idsPOheader.SetItem(llNewRow,'Arrival_Date',Trim(Mid(lsRecData,59,4)) + "/" + Mid(lsRecData,63,2) + "/" + Mid(lsRecData,65,2))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + "Expected Arrival Date expected. Record will not be processed.")
			End If
							
			
			
		CASE 'P031' /* detail*/
			
			lbDetailError = False
			llNewDetailRow = 	idsPODetail.InsertRow(0)
			llLineSeq ++
					
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Action_cd', 'U') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(lsOrder)) /* Order Number from header*/
								
						
			//Line Item Number
			If Trim(Mid(lsRecData,25,3)) > '' Then
				idsPODetail.SetItem(llNewDetailRow,'line_item_no',Dec(Trim(Trim(Mid(lsRecData,25,3)))))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + "Line Item Number expected. Record will not be processed.")
			End If
			
		
			//SKU
			If Trim(Mid(lsRecData,28,20)) > '' Then	
				idsPODetail.SetItem(llNewDetailRow,'SKU',Trim(Mid(lsRecData,28,20)))
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + "SKU expected. Record will not be processed.")
			End If
							
			//Get and Set the Alternate SKU (GTIN Number)
			lsSKU = Trim(Mid(lsRecData,28,20))
			
			Select Max(Alternate_Sku) into :lsAltSKU
			FRom Item_Master
			Where Project_id = 'LMC' and Sku = :lsSKU;
			
			If lsAltSKU > '' Then
				idsPODetail.SetItem(llNewDetailRow,'Alternate_SKU',lsAltSKU)
			End If
			
			//MEA - 10/16/12 - Set Supp_Code
			
			if aswarehouse = 'LMC-MY' then
				idsPODetail.SetItem(llNewDetailRow,'supp_code','MYLMC')
			else
				idsPODetail.SetItem(llNewDetailRow,'supp_code','LMC')
			end if			
			
			
		
			//Qty
			If Trim(Mid(lsRecData,66,10)) > '' Then	
				idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(Mid(lsRecData,66,10))) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/
			Else
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + "Quantity expected. Record will not be processed.")
			End If
					
			
		Case Else /* Invalid Rec Type*/
		
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + Left(lsRecData,4) + "'. Record will not be processed.")
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

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile, string asinisection);
String	lsLogOut,lsSaveFileName, lsStringData, lswarehouse

Integer	liRC, liFileNo

Boolean	bRet


lswarehouse = ProfileString(asinifile, asINISection, "warehouse","")


If Left(asFile,2) = 'IS' Then /* PO File*/
	
		
		liRC = uf_process_po(asPath, asProject, lswarehouse)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
ElseIf Left(asFile,2) =  'PR' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject, lswarehouse)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		

		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_dboh (string asparmstring);

//Process the Daily Balance on Hand Report

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsFileName, lsProcessProject
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut

lsFileName = "LMC-Daily- BOH-" + asparmstring + String(today(),"mm-dd-yyyy") + ".csv"

lsLogOut = "      Creating LMC ("+asparmstring+") Daily Balance on Hand File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore


sql_syntax = "select complete_Date, Supp_Invoice_No,  Content_Summary.sku, Content_Summary.l_Code, Content_Summary.Lot_No, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type,  Sum(Content_Summary.Avail_Qty) as avail_qty , Sum(Content_Summary.alloc_Qty) as Alloc_Qty  "
sql_syntax += "  From Receive_Master, Content_Summary "
sql_syntax += "  Where Content_Summary.Project_id = 'LMC'  and Content_Summary.Wh_Code = '"+asparmstring+"' and "
sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no "
sql_syntax += " Group By complete_Date, Supp_Invoice_No,  Content_Summary.sku, Content_Summary.l_Code, Content_Summary.Lot_No, Content_Summary.Expiration_Date,  Content_Summary.Inventory_Type "
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) > 0 or  Sum( Content_Summary.alloc_Qty  ) > 0 "

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for LMC  (BOH Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a column Header Row*/
If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "SKU,Date Received,Order Nbr,Location,Lot Nbr,Exp Date,Inventory Type, Avail Qty,Alloc Qty"
	ldsOut.SetItem(llNewRow,'Project_id', 'LMC')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */
End If

For llRowPos = 1 to lLRowCount /*Each Inv Record*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = ldsBoh.GetITemString(llRowPos,'sku') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'supp_invoice_no') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'l_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'lot_no') + ","
	lsOutString += String(ldsBoh.GetITemDateTime(llRowPos,'expiration_date'),'mm/dd/yyyy') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'Inventory_Type') + ","
	lsOutString += String(ldsBoh.GetITemNumber(llRowPos,'avail_qty')) + ","
	lsOutString += String(ldsBoh.GetITemNumber(llRowPos,'alloc_qty'))
				
	ldsOut.SetItem(llNewRow,'Project_id', 'LMC')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'dest_cd', 'BOH') /* routed to different folder for processing */
		
Next /*Inventory Record*/

if asparmstring = "LMC-MY" then
	lsProcessProject = "LMC-MY"
else
	lsProcessProject = "LMC"
end if


If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProcessProject) //'LMC')
End If
		

REturn 0
end function

on u_nvo_proc_lmc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_lmc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

