HA$PBExportHeader$u_nvo_proc_comcast.sru
$PBExportComments$Process Comcast files
forward
global type u_nvo_proc_comcast from nonvisualobject
end type
end forward

global type u_nvo_proc_comcast from nonvisualobject
end type
global u_nvo_proc_comcast u_nvo_proc_comcast

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsDONotes,		&
				idsDoAddress,	&
				iu_DS, &
				idsOut,			&
				idsITH,			&
				idsITD,  		&			
				idsEISResults
				
u_ds_datastore	idsItem 

				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer uf_import_carton_serial (string aspath, string asproject)
public function integer uf_process_dboh ()
public function integer uf_export_inbound_to_lms (string asinifile, string asemail)
public function integer uf_export_outbound_to_lms (string asinifile, string asemail)
public function integer uf_process_siv (string aspath, string asproject, string asinifile)
public function integer uf_load_itd (string aspath, string asproject)
public function integer uf_load_ith (string aspath, string asproject)
public function integer uf_eis_snapshot (string asinifile, string asemail)
public function integer uf_missing_serial (string asinifile, string asemail)
public function integer uf_import_carton_serial_old (string aspath, string asproject)
public function integer uf_process_serial_status_chg ()
public function integer uf_eis_weekly_ftp_file (string asinifile, string asbhfile)
public function integer zz_process_ith_itd ()
public function integer uf_process_dailyactivity_report (string asinifile, string asemail)
public function integer uf_process_dar_shipib_report (string asinifile, string asemail)
public function integer uf_process_dar_shipob_report (string asinifile, string asemail)
public function integer uf_process_eis_results (string aspath, string asproject)
public function integer uf_eis_monthly_ftp_file (string asinifile, string asbhfile)
public function integer uf_process_lms_so (string aspath, string asproject)
public function string uf_get_supplier (string assupplier, string assku)
public function string uf_get_sims_whcode (string aswhcode)
public function integer uf_process_dar_all_wh (string asinifile, string asemail)
public function string uf_get_forecast_group (string assupplier, string assku)
public function integer uf_process_sum_inv_rpt (string asinifile, string asemail)
public function integer uf_process_ith_itd (string asinifile, string asemail)
public function integer uf_check_for_multiple_mac_id (string as_macid, string as_serno, string as_email, string as_pallet)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet

//1 
lsLogOut = '  Start the function ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)



If Left(asFile,2) = 'PM' Then /* PO File*/
	
		
//2
lsLogOut = ' uf_process_po Start PM  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
		
		liRC = uf_process_po(asPath, asProject)
	
		//Process any added PO's
		
		
//3
lsLogOut = ' uf_process_purchase_order  Process any added PO   Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
		
		
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		
		//Process any added SO's - we may ave been creating matching Outbound Order
	//	If liRC = 0 Then
	
	
	
//4
lsLogOut = ' uf_process_Delivery_order   Process any added SO    Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
		
	
			liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
	//	End If
		
			
ElseIf Left(asFile,2) =  'DM' Then /* Sales Order File*/
	
	
	
	
//5
lsLogOut = ' uf_process_so  Start DM ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
		
		liRC = uf_process_so(asPath, asProject)
		

//6
lsLogOut = ' uf_process_Delivery_order  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
				
		
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
	
ElseIf Upper(Left(asFile,2)) =  'SN' Then /* Serial Number File*/

	
//7
lsLogOut = ' uf_import_carton_serial  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
				
	
	
	liRC = uf_import_carton_serial(asPath, asProject)
	
ElseIf Upper(Left(asFile,5)) =  'RV-SN' Then /* OLD 23 column format - Serial Number File*/
	
	
//7
lsLogOut = ' uf_import_carton_serial_old  RV-SN  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
				
	
	
	liRC = uf_import_carton_serial_old(asPath, asProject)
	
ElseIf Upper(Left(asFile,3)) =  'ITH' Then /* ITH */
	


//8
lsLogOut = ' uf_load_ith ITH   Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
				
	
	liRC = uf_load_ith(asPath, asProject)
	
ElseIf Upper(Left(asFile,3)) =  'ITD' Then /* ITD */
	
	
//9
lsLogOut = ' uf_load_itd ITD   Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
					
	
	liRC = uf_load_itd(asPath, asProject)
	
ElseIf Upper(Left(asFile,3)) =  'SIV' Then /* Inventory Snapshot from Comcast*/
	
	
//10
lsLogOut = ' uf_process_siv  SIV  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
		
	
	liRC = uf_process_siv(asPath, asProject,asiniFile)
	
//Jxlim 11/30/2010 call if EIS
ElseIf Upper(Left(asFile,3)) =  'EIS' Then /*Comcast EIS Results - Error visibility*/	
	
	

//11
lsLogOut = ' uf_process_EIS_Results  EIS  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
			
	
	
	liRC = uf_process_EIS_Results(aspath, asproject)		
	
ElseIf Left(asFile,4) =  'N940' Then /* Sales Order Files from LMS to SIMS*/
	
	
//12
lsLogOut = ' uf_process_lms_so  N940  Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)
			
		
		liRC = uf_process_lms_so(asPath, asProject)
		

//13
lsLogOut = ' uf_process_Delivery_order  Delivery   Start  ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)		
		
		//Process any added SO's
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

	
	
//1
lsLogOut = ' End   ' +  String(today(),'mm/dd/yyyy hh:mm:ss')
FileWrite(giLogFileNo,lsLogOut)		
	
	

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for COMCAST

Datastore	ldsDOHeader, ldsDODetail, 	lu_ds
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsSKUSave,  lsSupplier,	lsFind,	&
			 lsOrderNo, lsOrderSave, lsWarehouse, lsCustCode, lsCustName, lsAddr1, lsAddr2, lsAddr3,lsAddr4, lsCity, lsState, lsZip, lsCountry, lsTel, lsContact, lsEmail



Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty,   	 llBatchSeq, llOrderSeq, llLineSeq,  llRC, llNewDetailRow
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError


ldtToday = DateTime(today(),Now())


lu_ds = Create datastore
lu_ds.dataobject = 'd_import_generic_csv'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

//Open and read the File In - Importing CSV file
lsLogOut = '      - Opening File for Comcast Delivery Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = lu_ds.ImportFile(csv!,asPath) 

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Make sure we are sorted by Order Number (column 2) 
lu_ds.SetSort("column2 A")
lu_ds.Sort()

//Process each row of the File
llRowCount = lu_ds.RowCount()

lsLogOut = '      - ' + String(llRowCount) + '  Records retrieved for processing...'
FileWrite(giLogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	
	//If ORder Number has changed, create a new header
	lsOrderNo = Trim(lu_ds.getITemString(llRowPos, 'column2'))
	lsCustCode = Trim(lu_ds.getITemString(llRowPos, 'column6'))
	
	If lsOrderNo <> lsOrderSave Then
				
			llNewRow = 	ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			ldsDOHeader.SetItem(llNewRow, 'project_id',asProject)
			ldsDOHeader.SetItem(llNewRow, 'action_cd','A')
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow, 'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			ldsDOHeader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
					
			
			//From File
			ldsDOHeader.SetItem(llNewRow,'invoice_no',lsOrderNo)
			ldsDOHeader.SetItem(llNewRow,'wh_Code',Trim(lu_ds.getITemString(llRowPos, 'column1')))
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(lu_ds.getITemString(llRowPos, 'column9')))
			ldsDOHeader.SetItem(llNewRow,'freight_terms',Trim(lu_ds.getITemString(llRowPos, 'column10')))
			ldsDOHeader.SetItem(llNewRow,'schedule_date',Trim(lu_ds.getITemString(llRowPos, 'column4')))
			ldsDOHeader.SetItem(llNewRow,'request_date',Trim(lu_ds.getITemString(llRowPos, 'column5')))
			
			//We need to load the Customer Info
			lsCustName = ''
			lsAddr1 = ''
			lsAddr2 = ''
			lsAddr3 = ''
			lsAddr4 = ''
			lsCity = ''
			lsState = ''
			lsZip = ''
			lsCountry = ''
			lsTel = ''
			lsContact = ''
			lsEmail = ''
			
			Select Cust_name, Address_1, address_2, address_3, address_4, city, state, zip, country, tel, contact_person, email_address
			into	:lsCustName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsContact, :lsEmail
			From Customer
			Where Project_id = :asProject and Cust_Code = :lsCustCode;
		
			ldsDOHeader.SetItem(llNewRow,'cust_Code',lsCustCode)
			ldsDOHeader.SetItem(llNewRow,'cust_name',lsCustName)
			ldsDOHeader.SetItem(llNewRow,'address_1',lsAddr1)
			ldsDOHeader.SetItem(llNewRow,'address_2',lsAddr2)
			ldsDOHeader.SetItem(llNewRow,'address_3',lsAddr3)
			ldsDOHeader.SetItem(llNewRow,'address_4',lsAddr4)
			ldsDOHeader.SetItem(llNewRow,'city',lsCity)
			ldsDOHeader.SetItem(llNewRow,'state',lsState)
			ldsDOHeader.SetItem(llNewRow,'zip',lsZip)
			ldsDOHeader.SetItem(llNewRow,'Country',lsCountry)
			ldsDOHeader.SetItem(llNewRow,'tel',lsTel)
			ldsDOHeader.SetItem(llNewRow,'Contact_person',lsContact)
			//ldsDOHeader.SetItem(llNewRow,'email_address',lsEmail)
			
			
			lsOrderSave = lsOrderNo
					
	End If /* New Header*/
						
	//Always add a detail 
			
	lsSKU = Trim(lu_ds.getITemString(llRowPos, 'column7'))
	llQty = Long(Trim(lu_ds.getITemString(llRowPos, 'column8')))
	
	
	llNewDetailRow = 	ldsDODetail.InsertRow(0)
	llLineSeq ++
					
	//Add detail level defaults
	ldsDODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
	ldsDODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
	ldsDODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
	ldsDODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
	ldsDODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
	ldsDODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
	ldsDODetail.SetItem(llNewDetailRow,"line_item_no",llLineSeq)
		
	//From File
	ldsDODetail.SetItem(llNewDetailRow,'Invoice_No',lsOrderNo)
	ldsDODetail.SetItem(llNewDetailRow,'SKU',lsSKU)
	ldsDODetail.SetItem(llNewDetailRow,'quantity',String(llQty)) 
	
	//We need Supplier for SKU - hardcoded for now since there are only 3 SKU
	Choose case Upper(lsSKU)
		Case  '27900'
			lsSupplier = 'PACE'
		Case '28300'
			lsSupplier = 'THOMSON'
		Case '28400'
			lsSupplier = 'MOTOROLA'
		Case Else
			lsSupplier = ''
	End Choose
	
	ldsDODetail.SetItem(llNewDetailRow,'supp_code',lsSupplier)

Next /*File record */


//Save Changes
liRC = ldsDOHeader.Update()

If liRC = 1 Then
	liRC = ldsDODetail.Update()
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

protected function integer uf_process_po (string aspath, string asproject);//Process PO for Comcast

Datastore	lu_ds

String		lsLogout,lsStringData, lsWarehouse
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount,  llRC, llPalletQty, llRemainQty, llSetQty
Boolean	lbError, lbDetailError, lbSIK
DateTime	ldtToday

String 	lsOrderNo, lsOrderSave, lsSKU, lsSupplier

ldtToday = DateTime(Today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_import_generic_csv'

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

If Not isvalid(idsDoheader) Then
	idsDoheader = Create u_ds_datastore
	idsDoheader.dataobject = 'd_shp_header'
	idsDoheader.SetTransObject(SQLCA)
End If

If Not isvalid(idsDODetail) THen
	idsDODetail = Create u_ds_datastore
	idsDODetail.dataobject = 'd_shp_detail'
	idsDODetail.SetTransObject(SQLCA)
End If

//Open and read the File In - Importing CSV file
lsLogOut = '      - Opening File for Comcast Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = lu_ds.ImportFile(csv!,asPath) 

//Get the next available file sequence number
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Make sure we are sorted by Order Number (column 1) 
lu_ds.SetSort("column1 A")
lu_ds.Sort()

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	//If ORder Number has changed, create a new header
	lsOrderNo = Trim(lu_ds.getITemString(llRowPos, 'column1'))
	If lsOrderNo <> lsOrderSave Then
				
			lbSIK = False
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			idsPOheader.SetItem(llNewRow, 'action_cd','A')
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
					
			//From File
			idsPOheader.SetItem(llNewRow,'order_no',lsOrderNo)
			idsPOheader.SetItem(llNewRow,'supp_code',Trim(lu_ds.getITemString(llRowPos, 'column2')))
			idsPOheader.SetItem(llNewRow,'wh_Code',Trim(lu_ds.getITemString(llRowPos, 'column4')))
			idsPOheader.SetItem(llNewRow,'Carrier',Trim(lu_ds.getITemString(llRowPos, 'column6')))
			idsPOheader.SetItem(llNewRow,'Arrival_Date',Trim(lu_ds.getITemString(llRowPos, 'column7')))
			
			lsSupplier = Trim(lu_ds.getITemString(llRowPos, 'column2'))
		
			lsOrderSave = lsOrderNo
			
			//If this is an Inbound to a SIK warehouse, we will want to create a matching Outbound Order as well
			lsWarehouse = Trim(lu_ds.getITemString(llRowPos, 'column4'))
			
			Select Count(*) into :llCount
			From Warehouse
			Where wh_Code = :lsWarehouse and wh_type = 'S';
			
			If llCount > 0 Then /*SIK Warehouse */
			
				lbSIK = True
				
				//Create a matching Outbound Order Header
				
				//Record Defaults
				llnewRow = idsDoheader.InsertRow(0)
				idsDoheader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
				idsDoheader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
				idsDoheader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
				idsDoheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
				idsDoheader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDoheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
				idsDoheader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
				idsDoheader.SetItem(llNewRow,'Status_cd','N')
				idsDoheader.SetItem(llNewRow,'Last_user','SIMSEDI')	
				
				idsDoheader.SetItem(llNewRow,'wh_Code',lsWarehouse) 
				idsDoheader.SetItem(llNewRow,'cust_Code',lsWarehouse)  /*Cust Code is setup to match warehouse code*/
				idsDoheader.SetItem(llNewRow,'invoice_no',lsOrderNo) /*order number same as Inbound */
				idsDoheader.SetItem(llNewRow,'Carrier',Trim(lu_ds.getITemString(llRowPos, 'column6')))
				
			End If /*SIK Warehouse */
			
					
	End If /* New Header*/
						
	//Always add a detail - We want a sperate detail row for each pallet so we can assign Pallet ID's when received from OEM
			
	lsSKU = Trim(lu_ds.getITemString(llRowPos, 'column3'))
	lLRemainQty = Long(Trim(lu_ds.getITemString(llRowPos, 'column5')))
	
	Select qty_3 into : llpalletQty
	From Item_Master
	Where Project_id = 'Comcast' and SKU = :lsSKU and Supp_Code = :lsSupplier;
	
	If llPalletQty = 0 or isnull(llPalletQty) Then llPalletQty = llRemainQty /*default to 1 row if no pallet qty present*/
	
	Do While llRemainQty > 0
			
		llNewDetailRow = 	idsPODetail.InsertRow(0)
		llLineSeq ++
					
		//Add detail level defaults
		idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
		idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
		idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
		idsPODetail.SetItem(llNewDetailRow,'action_cd', 'A') 
		idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
		idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
		idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
		idsPODetail.SetItem(llNewDetailRow,"line_item_no",llLineSeq)
		
		//From File
		idsPODetail.SetItem(llNewDetailRow,'Order_No',lsOrderNo)
		idsPODetail.SetItem(llNewDetailRow,'SKU',lsSKU)
		
		//Full Pallet per row or remainder if less than a pallet left (should only be receiving full pallets)
		If llRemainQty > llPalletQty Then
			llSetQty = llPalletQty
		Else
			llSetQty = lLRemainQty
		End If
		
		idsPODetail.SetItem(llNewDetailRow,'quantity',String(llSetQty)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/
		
		
		
		llRemainQty = llRemainQty -  llSetQty

	Loop 
	
	//If this is an SIK warehouse, we are adding a matching Delivery Order, Header added above, add Delivery Detail Record
	If lbSIK Then
		
		llnewRow = idsDODetail.InsertRow(0)
						
		//Add detail level defaults
		idsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
		idsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
		idsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
		idsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
		idsDODetail.SetITem(llNewRow,'Status_cd','N')
					
		idsDODetail.SetItem(llNewRow,'invoice_no',lsOrderNo)
		idsDODetail.SetItem(llNewRow,'line_item_no',llLineSeq) 
		idsDODetail.SetItem(llNewRow,'SKU',lsSKU)
		idsDODetail.SetItem(llNewRow,'quantity',Trim(lu_ds.getITemString(llRowPos, 'column5')))
					
	End If /*SIK warehouse */

Next /*File record */
	
//Save the Changes 
lirc = idsPOHeader.Update()
	
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If
	
If liRC = 1 and idsDOHeader.RowCount() > 0 Then
	liRC = idsDOHeader.Update()
End IF

If liRC = 1 and idsDODetail.RowCount() > 0 Then
	liRC = idsDODetail.Update()
End IF

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

public function integer uf_import_carton_serial (string aspath, string asproject);
//Load Serial Number data (Pallet, Carton, MAC ID, Unit ID, Serial #)

//** 10/10 - PCONKL - All Address fields including Serial NUmber (STB and M-Card) are now mapped from the last 6 fields (just added) to the export from ReportStore - WE will not map based on Model Type


Integer		liFileNo,liRC, liCurrentFileCount, liCurrentFileNum, llPos
String			presentation_str, lsSQl, dwsyntax_str, lsErrText, lsModel, lsModelSave, sql_syntax, errors, lsSerial, lsAddress[], lsOutString, lsSupplierSave
string 		lsOEMModel, lsOEMModelSave, lsLogOut, lsRecData, lsTemp, lsSKU, lsOrder, lsRONO
String 		lsPallet, lsCarton, lsMac, lsSupplier, lsUF1, lsUF2, lsUF3, lsUF4, lsUF5
String			lsPalletSave, lsWarehouse, lsLoc,  ls_Error
Long			llNewRow, llRowPos, llRowCount, llCount, llBatchSeq, llEdiCount, llEdiPos, llSerialPos, llSerialCount
Dec			ldBatchSeq
DataStore	lu_ds, ldsPODetail, ldsPallet, ldsCartonSerial
Boolean		lbError, lbAnyErrors, lbPalletExists
DateTime	ldtToday

Long	llOwner, llQty

u_ds_datastore luCartonSerial

ldtToday = DateTime(today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

luCartonSerial = Create u_ds_datastore
luCartonSerial.Dataobject = 'd_carton_serial'
luCartonSerial.SetTransObject(SQLCA)

ldsPODetail = Create u_ds_datastore
ldsPODetail.dataobject= 'd_po_detail'
ldsPODEtail.SetTransObject(SQLCA)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//Open the File
lsLogOut = '      - Opening File for Serial Number Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Comcast Processing: " + asPath
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

//We need the Order number from the file and retreive the RO_NO from the Inbound Order that should already be loaded in SIMS. File naming format is "SN=Warehouse=Order.txt"
lsOrder = Mid(asPath,(LastPos(asPath,"=") + 1),99999)
lsOrder = Left(lsOrder,(Pos(lsOrder,".") - 1)) /*remove ".txt" */

If lsOrder > '' Then
	
	Select Max(ro_No), Max(edi_Batch_seq_No) into :lsRONO, :llBatchSeq
	From Receive_master
	Where Project_id = 'COMCAST' and supp_invoice_No = :lsOrder;
	
End If

If lsRONO = "" Then /*no order for this file */

	lsLogOut =  "       File: " + asPath +  ", Order number: " + lsOrder + " not found in SIMS. File will still be loaded (Warning Only)."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	
End If

llRowCount = lu_ds.RowCount()

lsLogOut = '      -  ' + String(llRowCount)  + " records retrieved for processing."
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


//Loop through each record and build a carton serial record...
For lLRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
	
	
	// 20/20 - PCONKL - CHeck for new file format (29 columns) on first record and get out if old format (23 columns)
	If llRowPos = 1 Then
		
		llCount = 0
		llPos = Pos(lsRecData,'|')
		Do WHile llPos > 0
			llCount ++
			If llCount = Len(lsRecData) Then
				llPos = 0
			Else 
				llPos ++
				llPos = Pos(lsRecData,'|', llPos)
			End If
		Loop
		
		//29 columns = 28 delimiters
		If llCount < 28 Then
			gu_nvo_process_files.uf_writeError("29 Columns expected (Address 1 ->5 at end), only " + String(llCount) + " delimiters found. File will not be processed.")
			REturn - 1
		End IF
		
	End If /*First record, check for correct # of columns */
	
	
	lbError = False
		
	llNewRow = luCartonSerial.InsertRow(0)
	
	
	//PAck List Number - Not Used (#1)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Packer List Number' field. Record will not be processed.")
		lbError = True
	End If

			
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Pallet ID (#2)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Pallet ID' field. Record will not be processed.")
		lbError = True
	End If

	lsPallet = lsTemp
	
	// 11/10 - PCONKL - If this is a new pallet, we want to check to see if we have any serial numbers already loaded for this pallet. If we do, we will do a preemptive delete to ensure we don't have dups.
	//							In the new setup, we are not mapping MAC ID to the MAC ID field so if it already exists with MAC, we will insert a duplicate
	If lsPallet <> lsPalletSave Then
		
		lbPalletExists = False
		
		Select Count(*) into :llCount
		FRom Carton_Serial
		Where project_id = 'Comcast' and Pallet_id = :lsPallet;
		
		If llCount > 0 Then
			lbPalletExists = True /* we will delete by serial for this pallet*/
		End If
				
		lsPalletSave = lsPallet	
		
	End If
	
	luCartonSerial.SetItem(llNewRow,'Pallet_id',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Model Number - Not Used (#3)
	//04/10 - PCONKL - May be used to map to SKU if OEM Part not found
	//10/10 - PCONKL - THis is the primary lookup now.
	
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Model Number' field. Record will not be processed.")
		lbError = True
	End If
	
	lsModel = lsTemp
	
	// SKU will be mapped after we have processed the Supplier - We might have the same model for different Suppliers
	
	//Get the SKU from the Model
//	If lsModel <> lsModelSave and lsModel > '' Then
//		
//		lsSKU = ''
//		
//		Select max(sku) into :lsSKU
//		from Item_Master
//		Where Project_id = 'COMCAST' and user_field10 = :lsModel;
//		
//		if isNull(lsSKU) THen lsSKU = ''
//		
//		lsModelSave = lsModel
//		
//	ENd If
//	
//	luCartonSerial.SetItem(llNewRow,'sku',trim(lsSKU))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Finished Goods Number - OEM Part Number, need to convert to our SKU (#4)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Finished Goods Number' field. Record will not be processed.")
		lbError = True
	End If
	
	
	//Only do the lookup if the SKU changes. We are probably only receiving a single SKU per file.
	lsOEMModel = lsTemp
	
//	if lsOEMModel <> lsOEMModelSave and lsSKU = '' then
//		
//		Select Max(sku) into :lsSKU
//		from Item_Master
//		Where Project_id = 'COMCAST' and user_field9 = :lsOEMModel;
//		
//		if isNull(lsSKU) THen lsSKU = ''
//		
//		 lsOEMModelSave = lsOEMModel
//		 		
//	end if
//	
//	
//	luCartonSerial.SetItem(llNewRow,'sku',trim(lsSKU))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Ship Date - Not Used (#5)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Ship Date' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Manufacturer (Supplier) (#6)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Manufacturer' field. Record will not be processed.")
		lbError = True
	End If
	
	//validate
	If lsTemp <> lsSupplierSave Then
		
		Select Count(*) into :llCount
		From Supplier
		Where project_id = 'COMCAST' and supp_code = :lsTemp;
	
		If llCount = 0 Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Supplier: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
		Else
			lsSUpplier = lsTemp
		End If
		
		lsSupplierSave = lsSupplier
		
	End If /*Supplier changed*/
	
	//Model mapped now that we have loaded the Supplier...
	If lsModel <> lsModelSave and lsModel > '' and lsSupplier > ''Then
		
		lsSKU = ''
		
		Select Max(SKU) into :lsSKU
		from Item_Master
		Where Project_id = 'COMCAST' and supp_code = :lsSupplier and user_field10 = :lsModel;
		
		//If no match on Supplier, try just SKU
		if isNull(lsSKU) or lsSKU = '' Then
			
			Select max(sku) into :lsSKU
			from Item_Master
			Where Project_id = 'COMCAST'  and user_field10 = :lsModel;
			
		End If
		
		if isNull(lsSKU) THen lsSKU = ''
		
		lsModelSave = lsModel
		
	ENd If
	
	//If not found on Model, Try OEM Part Number
	if lsOEMModel <> lsOEMModelSave and lsSKU = '' then
		
		Select Max(SKU) into :lsSKU
		from Item_Master
		Where Project_id = 'COMCAST' and Supp_Code = :lsSupplier and  user_field9 = :lsOEMModel;
		
		//If no match on Supplier, try just SKU
		if isNull(lsSKU) or lsSKU = '' Then
			
			Select Max(sku) into :lsSKU
			from Item_Master
			Where Project_id = 'COMCAST' and  user_field9 = :lsOEMModel;
			
		End If
		
		if isNull(lsSKU) THen lsSKU = ''
		
		 lsOEMModelSave = lsOEMModel
		 		
	end if
	
	//Reject record if we dont match on SKU
	If lsSKU = '' or isnull(lsSKU) Then
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Unable to match to ITem Master on EIS Model(#3) or OEM Part (#4): '" + lsModel + "/" + lsOEMModel + "'. Record will not be processed.")
		lbError = True
		
	End If
	
	luCartonSerial.SetItem(llNewRow,'sku',trim(lsSKU))
	
	luCartonSerial.SetItem(llNewRow,'supp_code',trim(lsSupplier))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Customer - Not Used (#7)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Name' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//City - Not Used (#8)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'City' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//State - Not Used (#9)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'State' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Serial Number (#10) - 10/10 - PCONKL - SERIAL NUMBER NOW ALWAYS COMING FROM COLUMN 24 FROM REPORTSTORE FILE
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Serial Number' field. Record will not be processed.")
		lbError = True
	End If
	
//	luCartonSerial.SetItem(llNewRow,'serial_no',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	

// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
	
//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   						DTA = MAC Address (MAC_ID)
//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)									DTA = Blank
//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)							DTA = Blank
//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)

//** 10/10 - PCONKL - All Address fields including Serial NUmber (STB and M-Card) are now mapped from the last 6 fields (just added) to the export from ReportStore - WE will not map based on Model Type

	
	//Unit ID (UF1) (#11)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Unit ID' field. Record will not be processed.")
		lbError = True
	End If
	
//	luCartonSerial.SetItem(llNewRow,'user_field1',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Host ID - (UF2) (#12)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Host ID' field. Record will not be processed.")
		lbError = True
	End If

//	luCartonSerial.SetItem(llNewRow,'user_field2',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//ECM MAC (UF4) (#13)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'ECM MAC ID' field. Record will not be processed.")
		lbError = True
	End If

//	luCartonSerial.SetItem(llNewRow,'user_field4',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Ethernet MAC - Not used (#14)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Ethernet MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Set Top MAC - USED (#15)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'STB MAC' field. Record will not be processed.")
		lbError = True
	End If
	
//	luCartonSerial.SetItem(llNewRow,'mac_id',trim(lsTemp))
		
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//USB MAC - Not USed (#16)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'USB MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//1394 MAC - Not USed (#17)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after '1394 MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Embedded MAC - Not USed (#18)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Embedded MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-Card Serial -(UF5)  (#19) - 
	// 05/10 - PCONKL - Added mapping for CPE product
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'm-card Serial' field. Record will not be processed.")
		lbError = True
	End If
	
//	luCartonSerial.SetItem(llNewRow,'user_field5',trim(lsTemp))	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-card unit Address - (UF3) (#20)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'm-Card Unit Address' field. Record will not be processed.")
		lbError = True
	End If

//	luCartonSerial.SetItem(llNewRow,'user_field3',trim(lsTemp))	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-Card  MAC - Not USed (#21)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'M-Card MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//M-Card cableCard ID - Not USed (#22)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'M-Card CableCard ID' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	
	//Master Pack Carton (#23)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'M-Card CableCard ID' field. Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'carton_id',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	
	// 10/10 - PCONKL - Serial NUmber and all 5 address fields have been added at the end. Takes us out of the mapping business (based on Product Group)
	
	//Serial No - Will either be STB or M-Card (#24)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Serial (#24).Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'Serial_No',trim(lsTemp))
	lsSerial = lsTemp
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//11/10 - PCONKL - If we already have records for this pallet, we will try a preemptive delete to avoid Dups
	If lbPalletExists Then
		
		Delete from Carton_serial where Project_id = 'Comcast' and Pallet_id = :lsPallet and Serial_no = :lsSerial;
		Commit;
		
	End IF
	
	
	
	//Address 1 - UF1 (#25)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Address 1 (#25).Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'User_Field1',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Address 2 - UF2 (#26)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Address 2 (#26).Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'User_Field2',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
		
		
	//Address 3 - UF3 (#27)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Address 3 (#27).Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'User_Field3',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	
	//Address 4 - UF1 (#28)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Address 4 (#28).Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'User_Field4',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	
	//Address 5 - UF1 (#29) - Should be last field
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else
		lsTemp = lsRecdata
	End If
	
	luCartonSerial.SetItem(llNewRow,'User_Field5',trim(lsTemp))
	
	//10/10 - PCONKL - They will be adding 5 new attribute fields that we will need to store as well
	
//	//If more fields, it is an error
//	If Pos(lsTemp,'|') > 0 or Pos(lsRecData,'|') > 0 Then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data found after expected last column. Record will not be processed.")
//		lbError = True
//	End If
	
	//Delete row if errors
	If lbError Then
		luCartonSerial.DeleteRow(llNewRow)
		lbAnyErrors = True
	End If
	
	//Record defaults...
	luCartonSerial.SetItem(llNewRow,'mac_id','-') /*required but no longer populated as of 10/10 */
	luCartonSerial.SetItem(llNewRow,'Source','REPORTSTORE') /* need to know that it is mapped while we are converting data*/
	luCartonSerial.SetItem(llNewRow,'last_update',ldtToday)
	luCartonSerial.SetItem(llNewRow,'Project_id','COMCAST')
	luCartonSerial.SetItem(llNewRow,'ro_no',lsRoNo)  /* used to link to Inbound Order */
	
Next /*serial row */

//Save Serials to DB
liRC = luCartonSerial.Update()
	
If liRC = 1 then
	Commit;
Else
	
	Rollback;
	
//	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Pallet Serial Numbers Records to database! - Will try to update row by row."
//	FileWrite(gilogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_writeError(lsLogout)


	//Loop through row by row.
	
	For lLRowPos = 1 to llRowCount
			
		lsPallet = luCartonSerial.GetItemString(lLRowPos,'Pallet_id')
		lsCarton = luCartonSerial.GetItemString(lLRowPos,'carton_id')
		lsSerial = luCartonSerial.GetItemString(lLRowPos,'serial_no') 
		lsMac = luCartonSerial.GetItemString(lLRowPos,'mac_id') 	
		lsSku = luCartonSerial.GetItemString(lLRowPos,'sku') 			
		lsSupplier = luCartonSerial.GetItemString(lLRowPos,'supp_code') 	
		lsRoNo = luCartonSerial.GetItemString(lLRowPos,'ro_no') 	
		lsUF1 = luCartonSerial.GetItemString(lLRowPos,'user_field1')
		lsUF2 = luCartonSerial.GetItemString(lLRowPos,'user_field2')
		lsUF3 = luCartonSerial.GetItemString(lLRowPos,'user_field3')
		lsUF4 = luCartonSerial.GetItemString(lLRowPos,'user_field4')
		lsUF5 = luCartonSerial.GetItemString(lLRowPos,'user_field5')

		INSERT INTO  dbo.Carton_Serial 
			(Carton_Serial.Project_ID,    
         	 Carton_Serial.Carton_ID,   
        		 Carton_Serial.Serial_No,   
              Carton_Serial.Mac_ID,    
              Carton_Serial.Pallet_ID,   
        		Carton_Serial.SKU,   
        		Carton_Serial.Supp_Code,   
         	Carton_Serial.RO_NO,   
         	Carton_Serial.Last_Update,   
         	Carton_Serial.User_field1,   
         	Carton_Serial.User_field2,   
         	Carton_Serial.User_field3,   
         	Carton_Serial.User_field4, 
		  	Carton_Serial.User_field5,
			 Carton_Serial.Source )
			VALUES  ( :asproject,
			:lsCarton,
			:lsSerial,
			:lsMac,
			:lsPallet,
			:lsSku,
			:lsSupplier,
			:lsRoNo,
			:ldtToday,
			:lsUF1,
			:lsUF2,
			:lsUF3,
			:lsUF4,
			:lsUF5,
			'REPORTSTORE')  USING SQLCA ;
	
	
	
		ls_Error = SQLCA.SQLErrText
	
		if SQLCA.SQLCode = 0 then
			
			COMMIT USING SQLCA;
			
		else
			
			ROLLBACK USING SQLCA;
			
			// 10/10 - PCONKL - If insert failed, try an Update to the 5 address fields
			Update Carton_Serial
			Set User_Field1 = :lsUF1, USer_Field2 = :lsUF2, User_Field3 = :lsUF3, User_Field4 = :lsUF4, User_Field5 = :lsUF5, Source = 'REPORTSTORE', ro_no = :lsRONO
			Where Project_id = 'Comcast' and Pallet_id = :lsPallet  and Serial_no = :lsSerial 
			//Where Project_id = 'Comcast' and Pallet_id = :lsPallet and Carton_id = :lsCarton and Serial_no = :lsSerial and Mac_id = :lsMac
			Using SQLCA;
			
			if SQLCA.SQLCode = 0 then
				COMMIT USING SQLCA;
			else
				ROLLBACK USING SQLCA;
			End If
						
		end if
	
	Next		
	
//	Return 0  // -1 Right now, don't error out if processing each row.
	
End If


//We want to apply the Pallet ID's to the EDI Inbound Detail records (Lot_No) so that they are included when the Putaway List is generated. We want to make sure we have the appropriate number of Pallets (based on Receipt Qty and Pallet Count)

//	01/11 - PCONKL - Retrieving edi_batch_seq_no currently associated with the Order (above).
//	The Max() may not be linkd to the order if a subsequent drop of the order is rejected but the EDI records still created

//Select Max(edi_batch_Seq_no) into :llbatchSeq
//From Edi_inbound_Header
//Where project_id = 'Comcast' and Order_no = :lsOrder;

If llBatchSeq > 0 Then
	
	llEdiCount = ldsPoDetail.Retrieve('Comcast', llBatchSeq, lsOrder)
	
	If llEdiCount > 0 and lsRONO > ""  Then
		
		//Retrieve a list of distinct Pallet ID's that we just saved for this order
		ldsPallet = Create Datastore
		presentation_str = "style(type=grid)"
		lsSQl = "Select Distinct Pallet_ID as Pallet_ID from Carton_serial " 
		lsSql += "Where project_id = 'Comcast ' and Ro_No = '" + lsRONO +  "'"

		dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
		ldsPallet.Create( dwsyntax_str, lsErrText)
		ldsPallet.SetTransObject(SQLCA)
		
		llRowCount = ldsPallet.Retrieve()
		
		//Hopefully, we have equal number of EDI rows and Pallets. If not, loop through the lesser amt and assign Pallets to Putaway Records
		If llRowCount >  llEdiCount Then llRowCount = llEdiCount
		
		For llRowPos = 1 to llRowCount
			ldsPoDetail.SetItem(llRowPos,'lot_no',ldsPallet.GetItemString(llRowPos,'pallet_id'))
		Next
		
		liRC = ldsPODetail.Update()
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save Pallet ID's to Inbound Orders!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
		End If

	End If
	
End If

// 05/10 - PCONKL - If we have loaded any pallets that we already have in Inventory with type 'S' (No Serial previoujsly loaded at receipt), Send TRC's for those pallets
uf_process_serial_status_chg()


If lbAnyerrors Then
	Return - 1
Else
	Return 0
End If
end function

public function integer uf_process_dboh ();

//Process the COMCAST Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nortel_boh' /* at the SKU/Inv Type level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "COMCAST"

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1


//lsfileName = "BH" + String(ldBatchSeq) + ".DAT"
lsFileName = "SIMSonhandinv.csv"

//Retrive the BOH Data
lsLogout = 'Retrieving Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsBOH.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing Balance on Hand Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = ""
	lsOutString += ldsboh.GetItemString(llRowPos,'wh_code') + ','
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),50) + ','
	lsOutString += ldsboh.GetItemString(llRowPos,'inventory_type') + ','
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'############0')
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'dest_cd', 'OPD') /*routed to OPD folder*/
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"COMCAST")

Return 0
end function

public function integer uf_export_inbound_to_lms (string asinifile, string asemail);Datastore	ldsheader, ldsGR, ldsroputaway, ldsOut
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsLogOut, lsRONO, lsFind, lsOutString, lsFileName, lsToday, lsSupplier, lsSKU
DateTime	ldToday
Long	llheaderRowCount, llheaderRowPos, llPutawayPos, llPutawayCount, llFindRow, llNewRow, llOutCount, llOutPos, llUnitQty, llTotalQty, llPalletCount
Decimal	ldBatchSeq, ldUnitWeight, ldGrossWeight
Integer	liFileNo

ldToday = DateTime(today(),Now())
lsToday = String(ldToday,"yyyy/mm/dd")

lsLogOut = "- PROCESSING FUNCTION: Comcast Daily Receipt Summary to LMS!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create Receive Header Datastore...
// 12/09 - PCONKL - Exclude warehouse transfers
// 05/10 - Include warehouse tansfers again
ldsheader = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select ro_no, Supp_Code, supp_invoice_no, supp_order_No, wh_code, Complete_Date, awb_bol_no, Ship_Via, Carrier  from Receive_MAster " 
lsSql += "Where project_id = 'Comcast ' and Ord_status = 'C'  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
//lsSql += "Where project_id = 'Comcast ' and Ord_status = 'C' and ord_type <> 'Z'  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsheader.Create( dwsyntax_str, lsErrText)
ldsheader.SetTransObject(SQLCA)

ldsGR = Create Datastore
ldsGR.Dataobject = 'd_gr_layout'

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsroputaway = Create Datastore
ldsroputaway.Dataobject = 'd_ro_Putaway'
ldsroputaway.SetTransObject(SQLCA)
	
//Write the file directly to the archive directory and email from there
lsFileName = ProfileString(asInifile,"Comcast","archivedirectory","") + '\' + 'SIMS-IB-' + String(ldToday,"yyyymmddhhmmss") + '.csv'

//Open and spool the file
liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Comcast Inbound Orders from SIMS to LMS. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


////Get the Next Batch Seq Nbr - Used for all writing to generic tables
//ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('Comcast','EDI_Generic_Outbound','EDI_Batch_Seq_No')
//If ldBatchSeq <= 0 Then
//	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Comcast Goods Receipt Summary Confirmation (LMS).~r~rConfirmation will not be sent to LMS!'"
//	FileWrite(gilogFileNo,lsLogOut)
//	Return -1
//End If

lLHeaderRowCount = ldsheader.Retrieve()

lsLogOut = "    - " + String(llheaderRowCount) + " Orders retrieved for summary processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a header row */
If lLHeaderRowCount > 0 Then
		
		lsOutString = "SOPOINDICATOR,REFA,CUSTPONUMBER,CARRIER,FREIGHTSERVICELEVEL,CARRIERPRONUMBER,DELIVERYDATE,DELIVERYTIME,SHIPPERCODE,CONSIGNEECODE,LINENUMBER,ITEMCODE,ATTRIBUTE,QUANTITY,QUANTITYUOM,WEIGHT,WEIGHTUOM"
		
		FileWrite(liFileNo, lsOutString)
		
//		llNewRow = ldsOut.insertRow(0)
//		ldsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
//		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
//		ldsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
		
End If
	
For llheaderRowPOs = 1 to llheaderRowCount /*Each Order*/
	
	lsRONO = ldsHeader.GetITEmString(llheaderRowPOs,'ro_no')
	lsSupplier = ldsHeader.GetITEmString(llheaderRowPOs,'supp_Code')
	
	ldsgr.Reset()
	
	//Retrieve the Putaway records for ths order
	llPutawayCount = ldsRoPutaway.Retrieve(lsRONO)
		
	For llPutawayPos = 1 to llPutawayCount
	
		//Roll up to SKU
		// 7/12/2011 - GXMOR - Roll up to SKU + Attributes
		lsFind = "Upper(SKU) =  '" + upper(ldsROPutaway.GetItemString(llPutawayPos,'SKU')) + "' and Upper(PO_No) = '" + upper(ldsROPutaway.GetItemString(llPutawayPos,'PO_No')) + "'"
		llFindRow = ldsGR.Find(lsFind,1,ldsGR.RowCOunt())
		
		If llFindRow > 0 Then /*row already exists, add the qty*/
	
			ldsGR.SetItem(llFindRow,'quantity', (ldsGR.GetItemNumber(llFindRow,'quantity') + ldsROPutaway.GetItemNumber(llPutawayPos,'quantity')))
		
		Else /*not found, add a new record*/
		
			llNewRow = ldsGR.InsertRow(0)
				
			ldsGR.SetItem(llNewRow,'quantity',ldsROPutaway.GetItemNumber(llPutawayPos,'quantity'))
			ldsGR.SetItem(llNewRow,'po_no',ldsROPutaway.GetItemString(llPutawayPos,'po_no'))
			ldsGR.SetItem(llNewRow,'po_item_number',1) /* 01/09 - PCONKL - rolling up SKU, default Line Item */
			ldsGR.SetItem(llNewRow,'sku',ldsROPutaway.GetItemString(llPutawayPos,'Sku'))
									
		End If
	
	Next /*Putaway*/
	
	//Write to output file...CSV format
	
	llOutCount = ldsGR.RowCount()
			
	For llOutPos = 1 to llOutCount
	
		llNewRow = ldsOut.insertRow(0)
	
		//Master level fields
		lsOutString = 'P,' /*SOPOINDICATOR - P for PO */
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'supp_invoice_no') + ',' /*REFA = Sims Order Number */
		
		 /*CUSTPONUMBER  = Customer Order Number (Comcast PO) */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'supp_order_no')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'supp_order_no') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CARRIER   */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'carrier')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'carrier') + ','
		Else
			lsOutString += ","
		End If
		
		 /*FREIGHTSERVICELEVEL   */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'ship_via')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'ship_via') + ','
		Else
			lsOutString += ","
		End If
		
		/*CARRIERPRONUMBER  = Carrier tracking Number */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'awb_bol_no')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'awb_bol_no') + ',' 
		Else
			lsOutString += ","
		End If
			
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'yyyymmdd') + ',' /* DELIVERYDATE */
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'hhmm') + ',' /* DELIVERYTIME */
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'supp_code') + ',' /*SHIPPERCODE   Supplier Code */
		
		 /*CONSIGNEECODE    Warehouse  - We want to strip off our "COM-" prefix*/
		 If Pos(Upper(ldsHeader.GetItemString(llheaderRowPOs,'wh_Code')),'COM-') > 0 Then
				lsOutString += Mid(ldsHeader.GetItemString(llheaderRowPOs,'wh_Code'),5,999) + ',' 
		Else
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'wh_Code') + ',' 
		End If
		
		//Detail/Putaway level fields
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'po_item_number')) + ',' /* LINENUMBER */
		lsOutString += ldsGR.GetItemString(llOutPos,'SKU') + ',' /*ITEMCODE */
		lsOutString += ldsGR.GetItemString(llOutPos,'PO_No') + ',' /*ATTRIBUTE*/
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'quantity')) + ',' /*QUANTITY */
		lsOutString += "EA," /*QUANTITYUOM*/
		
		//Need weight from Item Master - Should be receiving full pallets (level 3)
		lsSKU = ldsGR.GetItemString(llOutPos,'SKU')
		ldGrossWeight = 0
		
		Select Qty_3, Weight_3 into :llUnitQty, :ldUnitWeight
		from Item_Master
		Where Project_id = 'COMCAST' and sku = :lsSKU and Supp_Code = :lsSupplier;
				
		If llUnitQty > 0 Then
				
			llTotalQty = ldsGR.GetItemNumber(llOutPos,'quantity')
			llPalletCount = llTotalQty/llUnitQty
			ldGrossWeight = llPalletCount * ldUnitWeight
						
		End If
		
		If ldGrossWeight > 0 Then
			lsOutString += String(ldGrossWeight,"#############.##") + "," /* WEIGHT */
		Else
			lsOutString += "0,"
		End If
		
		lsOutString += "LBS" /*WEIGHTUOM*/
		
		FileWrite(liFileNo, lsOutString)
		
//		ldsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
//		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
//		ldsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
			
	Next /*Output record*/
	
Next /*Order*/

FileClose(liFileNo)

////write the data to file
//If ldsOut.RowCount() > 0 Then
//	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'COMCAST')
//End If

//Email the file
If llheaderRowCount > 0 Then
	
	If Pos(asEmail,"@")  > 0  Then
		gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Logistics WMS - Daily Inbound Orders from SIMS to LMS","  Attached are the Daily Inbound orders into SIMS for Comcast...",lsFileName)
	Else /*no valid email, send an email to the file transfer error dist list*/
		gu_nvo_process_files.uf_send_email("COMCAST",'FILEXFER',"Unable to email Inbound Orders for LMS","Unable to email Inbound Orders to LMS - no email address found - file is still archived","")
	End If
	
Else /*no Orders*/
	If Pos(asEmail,"@")  > 0  Then
		gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Logistics WMS - Daily Inbound Orders from SIMS to LMS","  There are no  Daily Inbound orders into SIMS for Comcast...","")
	End If
End If
	

//Update the file transmit ind to show sent
Update Receive_Master set file_transmit_ind = 'Y' Where project_id = 'Comcast' and Ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') ;
Commit;

Return 0
end function

public function integer uf_export_outbound_to_lms (string asinifile, string asemail);Datastore	ldsheader, ldsGR, ldsDOPicking, ldsOut
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsLogOut, lsDONO, lsFind, lsOutString, lsFileName, lsToday, lsSupplier, lsSKU
DateTime	ldToday
Long	llheaderRowCount, llheaderRowPos, llPickPos, llPickCount, llFindRow, llNewRow, llOutCount, llOutPos,  llTotalQty, llPalletCount,llCartonCount,  llremainQty, lllevel2Qty, llLevel3Qty
Decimal	ldBatchSeq,ldLevel1Weight, ldlevel2Weight,ldLevel3Weight, ldGrossWeight
Integer	liFileNo

ldToday = DateTime(today(),now())
lsToday = String(ldToday,"yyyy/mm/dd")

lsLogOut = "- PROCESSING FUNCTION: Comcast Daily Shipment Summary to LMS!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create DElivery Header Datastore... Exclude SIK Orders (Warehouse type = 'S')
// 12/09 - PCONKL - Exclude Warehouse Transfers
// 05/10 - PCONKL - Include warehouse transfers again

ldsheader = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select do_no, invoice_no,  Complete_Date, cust_order_no, freight_terms, Delivery_Master.wh_code, Cust_Code, Cust_Name, Delivery_Master.address_1, Delivery_Master.Address_2, Delivery_Master.city, Delivery_Master.state,"
lsSQL += "Delivery_Master.zip, Delivery_Master.country, Delivery_Master.contact_person, Delivery_Master.tel, Delivery_Master.fax,Delivery_Master.email_address, carrier, awb_bol_no, Ship_Via"
lsSQl += " from Delivery_MAster, warehouse " 
lsSql += "Where Delivery_Master.wh_code = Warehouse.wh_code and (wh_type is null or wh_type <> 'S') and project_id = 'Comcast' and Ord_status = 'C'  and (file_transmit_ind is null or file_transmit_ind <> 'Y') "
//lsSql += "Where Delivery_Master.wh_code = Warehouse.wh_code and (wh_type is null or wh_type <> 'S') and project_id = 'Comcast' and Ord_status = 'C' and Ord_Type <> 'Z' and (file_transmit_ind is null or file_transmit_ind <> 'Y') "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsheader.Create( dwsyntax_str, lsErrText)
ldsheader.SetTransObject(SQLCA)

ldsGR = Create Datastore
ldsGR.Dataobject = 'd_gr_layout'

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsDOPicking = Create Datastore
ldsDOPicking.Dataobject = 'd_do_Picking'
ldsDOPicking.SetTransObject(SQLCA)

	
lsFileName = ProfileString(asInifile,"Comcast","archivedirectory","") + '\' + 'SIMS-OB-' + String(ldToday,"yyyymmddhhmmss") + '.csv'

//Open and spool the file
liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Comcast Outbound Orders from SIMS to LMS. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


////Get the Next Batch Seq Nbr - Used for all writing to generic tables
//ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('Comcast','EDI_Generic_Outbound','EDI_Batch_Seq_No')
//If ldBatchSeq <= 0 Then
//	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Comcast Goods Issue Summary Confirmation (LMS).~r~rConfirmation will not be sent to LMS!'"
//	FileWrite(gilogFileNo,lsLogOut)
//	Return -1
//End If

lLHeaderRowCount = ldsheader.Retrieve()

lsLogOut = "    - " + String(llheaderRowCount) + " Orders retrieved for summary processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a header row */
If lLHeaderRowCount > 0 Then
		
	lsOutString = "SOPOINDICATOR,REFA,CUSTPONUMBER,SHIPDATE,SHIPTIME,SHIPPERCODE,CONSIGNEECODE,CONSIGNEENAME1,CONSIGNEEADDRESS1,CONSIGNEEADDRESS2,CONSIGNEECITY,CONSIGNEESTATE,"
	lsOutString += "CONSIGNEEZIPCODE,CONSIGNEECOUNTRY,CONSIGNEECONTACTNAME,CONSIGNEECONTACTNUMBER,CONSIGNEECONTACTFAX,CONSIGNEECONTACTEMAIL,CARRIER,CARRIERPRONUMBER,FREIGHTTERMS,FREIGHTSERVICELEVEL,"
	lsOutString +="LINENUMBER,ITEMCODE,ATTRIBUTE,QUANTITY,QUANTITYUOM, WEIGHT,WEIGHTUOM"
		
	FileWrite(liFileNo,lsOutString)
	
//	llNewRow = ldsOut.insertRow(0)
//	ldsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
//	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//	ldsOut.SetItem(llNewRow,'file_name', lsFileName)
//	ldsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
		
End If

For llheaderRowPOs = 1 to llheaderRowCount /*Each Order*/
	
	lsDONO = ldsHeader.GetITEmString(llheaderRowPOs,'do_no')
		
	ldsgr.Reset()
	
	//Retrieve the Picking records for ths order
	llPickCount = ldsDOPicking.Retrieve(lsDONO)
		
	For llPickPos = 1 to llPickCount
	
		//Roll up to SKU
		//7/12/2011 - GXMOR - Roll up to SKU + Attributes
		lsFind = "Upper(SKU) = '" + Upper(ldsDOPicking.GetItemString(llPickPos,'Sku')) + "' and po_no = '" + Upper(ldsDOPicking.GetItemString(llPickPos,'PO_No')) + "'"
		llFindRow = ldsGR.Find(lsFind,1,ldsGR.RowCOunt())
		
		If llFindRow > 0 Then /*row already exists, add the qty*/
	
			ldsGR.SetItem(llFindRow,'quantity', (ldsGR.GetItemNumber(llFindRow,'quantity') + ldsDOPicking.GetItemNumber(llPickPos,'quantity')))
		
		Else /*not found, add a new record*/
		
			llNewRow = ldsGR.InsertRow(0)
				
			ldsGR.SetItem(llNewRow,'quantity',ldsDOPicking.GetItemNumber(llPickPos,'quantity'))
			ldsGR.SetItem(llNewRow,'po_no',ldsDOPicking.GetItemString(llPickPos,'po_no'))
			ldsGR.SetItem(llNewRow,'po_item_number',1) /* 01/09 - PCONKL - Rolling up to SKU, set line item to 1*/
			ldsGR.SetItem(llNewRow,'sku',ldsDOPicking.GetItemString(llPickPos,'Sku'))
			ldsGR.SetItem(llNewRow,'supp_code',ldsDOPicking.GetItemString(llPickPos,'supp_code'))
									
		End If
	
	Next /*Pick*/
	
	//Write to output file...CSV format
	
	llOutCount = ldsGR.RowCount()
	
	
		
	For llOutPos = 1 to llOutCount
	
		llNewRow = ldsOut.insertRow(0)
	
		//Master level fields
		lsOutString = 'S,' /*SOPOINDICATOR - S for SO */
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'invoice_no') + ',' /*REFA = Sims Order Number */
		
		 /*CUSTPONUMBER  = Customer Order Number (Comcast order) */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'cust_order_no')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'cust_order_no') + ','
		Else
			lsOutString += ","
		End If
				
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'yyyymmdd') + ',' /* SHIPDATE */
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'hhmm') + ',' /* SHIPTIME */
		
	//	lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'wh_Code') + ',' /*SHIPPERCODE    Warehouse */
		
		 /*SHIPPERCODE    Warehouse   - We want to strip off our "COM-" prefix*/
		 If Pos(Upper(ldsHeader.GetItemString(llheaderRowPOs,'wh_Code')),'COM-') > 0 Then
				lsOutString += Mid(ldsHeader.GetItemString(llheaderRowPOs,'wh_Code'),5,999) + ',' 
		Else
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'wh_Code') + ',' 
		End If
		
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'cust_code') + ',' /*CONSIGNEECODE - Customer Code */
				
		 /*CONSIGNEENAME1  = Customer Name */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'cust_name')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'cust_name') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEEADDRESS1  = Customer address 1*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'address_1')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'address_1') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEEADDRESS2  = Customer address 2*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'address_2')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'address_2') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECity = Customer City*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'City')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'City') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEESTATE  = Custome State*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'state')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'state') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEEZIP  = Customer Zip*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'zip')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'zip') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECOUNTRY  = Customer Country*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'country')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'country') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECONTACT  = Customer Contact*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'contact_person')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'contact_Person') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECONTACTNUMBER  = Customer Tel*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'tel')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'tel') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECONTACTFAX  = Customer Fax*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'fax')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'fax') + ','
		Else
			lsOutString += ","
		End If
		
		 /*CONSIGNEECONTACTEMAIL  = Customer Email*/
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'email_address')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'email_address') + ','
		Else
			lsOutString += ","
		End If
		
		/*CARRIER */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'carrier')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'carrier') + ','
		Else
			lsOutString += ","
		End If
		
		/*CARRIERPRONUMBER  = Carrier tracking Number */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'awb_bol_no')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'awb_bol_no') + ',' 
		Else
			lsOutString += ","
		End If
			
		/*FREIGHTTERMS  */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'freight_terms')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'freight_terms') + ',' 
		Else
			lsOutString += ","
		End If
		
		/*FREIGHTSERVICELEVEL  */
		If Not isnull( ldsHeader.GetItemString(llheaderRowPOs,'ship_via')) Then
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'ship_via') + ',' 
		Else
			lsOutString += ","
		End If
				
		
		//Detail/Picking level fields
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'po_item_number')) + ',' /* LINENUMBER */
		lsOutString += ldsGR.GetItemString(llOutPos,'SKU') + ',' /*ITEMCODE */
		lsOutString += ldsGR.GetItemString(llOutPos,'PO_No') + ',' /*ATTRIBUTE*/
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'quantity')) + ',' /*QUANTITY */
		lsOutString += "EA," /*QUANTITYUOM*/
		
		//Need weight from Item Master - May be picking full pallets or cartons
		lsSKU = Trim(ldsGR.GetItemString(llOutPos,'SKU'))
		lsSupplier = Trim(ldsGR.GetItemString(llOutPos,'supp_Code'))
		ldGrossWeight = 0
				
		Select Qty_2,Qty_3, Weight_2, Weight_3 into :llLevel2Qty,:llLevel3Qty, :ldLevel2Weight, :ldLevel3WEight
		from Item_Master
		Where Project_id = 'COMCAST' and sku = :lsSKU and Supp_Code = :lsSupplier;
				
		If llLevel3Qty > 0 Then
				
			//See how many full pallets we have
			
			llTotalQty = ldsGR.GetItemNumber(llOutPos,'quantity')
			llPalletCount = llTotalQty/llLevel3Qty /*will truncate down to whole pallets*/
			
			ldGrossWeight = llPalletCount * ldLevel3Weight
			
			//See if we have any non pallet picks...
			llRemainQty = llTotalQty - (llPalletCount * llLevel3Qty) /*any remaining Qty will default to carton weight, not shipping individual units*/
			
		Else
			
			llRemainQty = ldsGR.GetItemNumber(llOutPos,'quantity')
						
		End If
		
		//See if we have any carton Picks
		If llRemainQty > 0 and  llLevel2Qty > 0 Then
			
			llCartonCount = llRemainQty/llLevel2Qty /*will truncate down to whole cartons*/
			ldGrossWeight += llCartonCount * ldLevel2Weight
			
			//See if we have any non carton picks - we shouldn't
			llRemainQty = llRemainQty - (llCartonCount * llLevel2Qty)
			
		End If
		
		//See if we have any each picks (we shouldn't)
		If llRemainQty > 0 Then
		
			ldGrossWeight += llRemainQty * ldLevel1Weight
		
		End If
		
		If ldGrossWeight > 0 Then
			lsOutString += String(ldGrossWeight,"#############.##") + "," /* WEIGHT */
		Else
			lsOutString += "0,"
		End If
		
		lsOutString += "LBS" /*WEIGHTUOM*/
		
		FileWrite(liFileNo,lsOutString)
		
//		ldsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
//		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
//		lsFileName = 'rg' + String(ldBatchSeq,'00000000') + '.dat'
//		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
//		ldsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
		
	Next /*Output record*/
	
Next /*Order*/

FileClose(liFileNo)

////write the data
//If ldsOut.RowCount() > 0 Then
//	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'COMCAST')
//End If

//Email the file
If llHeaderRowCount > 0 Then
	
	If Pos(asEmail,"@")  > 0  Then
		gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Logistics WMS - Daily Outbound Orders from SIMS to LMS","  Attached are the Daily Outbound  orders from  SIMS for Comcast...",lsFileName)
	Else /*no valid email, send an email to the file transfer error dist list*/
		gu_nvo_process_files.uf_send_email("COMCAST",'FILEXFER',"Unable to email Outbound Orders for LMS","Unable to email Outbound Orders to LMS - no email address found - file is still archived","")
	End If
	
Else /* No Orders */
	If Pos(asEmail,"@")  > 0  Then
		gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Logistics WMS - Daily Outbound Orders from SIMS to LMS","  There are no  Daily Outbound  orders from  SIMS for Comcast...","")
	End If
End If
	
//Update the file transmit ind to show sent
Update Delivery_Master set file_transmit_ind = 'Y' Where project_id = 'Comcast' and Ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') ;
Commit;

Return 0
end function

public function integer uf_process_siv (string aspath, string asproject, string asinifile);//Load the Serial Number Inventory list from EIS

String	lsLogout, sql_syntax,errors, lsFind, lsFileName, lsFileNamePath
Long	llRC, llInvPos, llInvCount, llFindRow, llNewRow
DataStore	ldsSIV, ldsSIMSInv
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

ldsSIV = Create Datastore
ldsSIV.DAtaObject = 'd_comcast_eis_inventory'
ldsSIV.SetTransObject(SQLCA)


//Delete Existing data
Delete from Comast_Eis_recon;
Commit;

//Open and read the File In - Importing CSV file
ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' Opening File for Comcast SIV Inventory load processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


//Import the file
llRC = ldsSIV.ImportFile(csv!,asPath) 
If llRC < 0 Then
	lsLogOut = "-       ***Unable to import Comcast SIV file: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 
End If

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Saving EIS inventory...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ldsSIV.Update()
Commit;

//Load EIS Inventory that doesnt exist in SIMS
ldsSIMSInv = Create Datastore
sql_syntax = "SELECT EIS_Site_ID,  EIS_Status, Pallet_id, Comast_EIS_Recon.Serial_No " 
sql_syntax += "FROM {oj dbo.Carton_Serial RIGHT OUTER JOIN dbo.Comast_EIS_Recon ON dbo.Carton_Serial.Serial_No = dbo.Comast_EIS_Recon.Serial_No and carton_serial.Project_id = 'Comcast' } "
sql_syntax += " Where Comast_EIS_Recon. Serial_no Not in "
sql_syntax += " (select serial_no from carton_serial where project_id = 'Comcast' and pallet_id in (select lot_no from content_summary where project_id = 'Comcast'));"

ldsSIMSInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Comcast EIS Inventory load (EIS Not in SIMS DS).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsSIMSInv.SetTransObject(SQLCA)

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Retrieving EIS Inventory not in SIMS...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llInvCount = ldsSIMSInv.Retrieve()

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' ' + String(llInvCount) + '  records retrieved...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write file...
lsFileName =  'EIS-Not-in-SIMS-' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, true )

Destroy ldsSIMSInv 


//Load the Inventory in SIMS that is not in EIS
ldsSIMSInv = Create Datastore
sql_syntax = "SELECT  Carton_serial.Serial_No, Content_Summary.WH_Code, Content_Summary.L_Code as Location, Content_Summary.Lot_No as Pallet_ID   " 
sql_syntax += " FROM  Carton_Serial,   Content_Summary  "
sql_syntax += "WHERE ( dbo.Carton_Serial.Project_ID = dbo.Content_Summary.Project_ID ) and  "
sql_syntax += 	"  ( dbo.Carton_Serial.Pallet_ID = dbo.Content_Summary.Lot_No )    and Carton_serial.Project_id = 'Comcast' and (alloc_qty > 0 or avail_qty > 0 or tfr_in > 0 or tfr_out > 0) "

//exclude loose serial numbers and cartons...
sql_syntax += 	" and carton_serial.serial_no Not in (Select Carton_Serial.Serial_NO From Delivery_MAster, DElivery_Picking_Detail, Delivery_Serial_Detail, Carton_Serial with (nolock) "
sql_syntax += 	" Where delivery_MAster.do_no = DElivery_picking_detail.do_no and Delivery_picking_detail.id_no = Delivery_serial_detail.id_no and Delivery_MAster.Project_id = Carton_serial.Project_id and "
sql_syntax += 	" Delivery_Master.Project_id = 'Comcast' and Delivery_Master.Ord_status in ('C','D') and Delivery_serial_Detail.serial_no = carton_serial.Serial_no) "

sql_syntax += 	" and carton_serial.serial_no Not in (Select Carton_Serial.Serial_NO From Delivery_MAster, DElivery_Picking_Detail, Delivery_Serial_Detail, Carton_Serial with (nolock) "
sql_syntax += 	" Where delivery_MAster.do_no = DElivery_picking_detail.do_no and Delivery_picking_detail.id_no = Delivery_serial_detail.id_no and Delivery_MAster.Project_id = Carton_serial.Project_id and "
sql_syntax += 	" Delivery_Master.Project_id = 'Comcast' and Delivery_Master.Ord_status in ('C','D') and Delivery_serial_Detail.serial_no = carton_serial.Carton_ID) "

sql_syntax += " and Carton_serial.Serial_no Not in (select serial_no from comast_eis_Recon); "

ldsSIMSInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Comcast EIS Inventory load (SIMS not in EIS DS).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsSIMSInv.SetTransObject(SQLCA)

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Retrieving SIMS Inventory not in EIS...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llInvCount = ldsSIMSInv.Retrieve()

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' ' + String(llInvCount) + '  records retrieved...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write file...
lsFileName =  'SIMS-Not-in-EIS-' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, true )

Destroy ldsSIMSInv 

Return 0


end function

public function integer uf_load_itd (string aspath, string asproject);//BCR 29-APR-11: Uncommented some existing codes to allow error logging and status update to 'E' when ITD data is bad/incomplete.

String			lsLogOut, lsModel, lsModelSave, lsTranNbr, lsTranNbrSave, lsAnyModel, lsBOL, lsRefNbr, lsPallet
String			lsAttr1, lsAttr2, lsAttr3, lsAttr4, lsAttr5, lsAttr1Save, lsAttr2Save, lsAttr3Save, lsAttr4Save, lsAttr5Save
Long			llRC, llRowpos, llRowCount, llNewRow, llCount
Integer		liRC
Boolean		lbError, lbMultiSKU, lbNoModel, lbMultiAttr

//The ITH/ITD records are loaded here and then will be processed as a scheduled function so we can process them all together. Each transaction is a seperate file but we may need to combine them.

If not isvalid(iu_DS) Then
	iu_DS = Create datastore
	iu_DS.dataobject = 'd_import_generic_csv'
End IF

If Not isvalid(idsITD) Then
	idsITD = Create Datastore
	idsITD.dataobject = 'd_comcast_itd' 
	idsITD.SetTransObject(SQLCA)
End If

iu_DS.Reset()

//Open and read the File In - Importing Tab  file
lsLogOut = '      - Opening File for Comcast ITD Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = iu_DS.ImportFile(text!,asPath) 

If llRC < 0 Then
	lsLogOut = "-       ***Unable to import Comcast ITD file: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 
End If

lbNoModel = True

//Process each row of the File
llRowCount = iu_DS.RowCount()

For llRowPos = 1 to llRowCount
		
	lsTranNbr = iu_DS.GetITemString(llRowPos,'column2')
	
	If lsTranNbr <> lsTranNbrSave Then /*Should only be 1 tran per file*/
		
		//Delete existing ITD records
		Delete from comcast_itd where tran_nbr = :lsTranNbr;
		Commit;
		
		lsTranNbrSave = lsTranNbr
	
	End If
	
			
	llNewRow = idsITD.InsertRow(0)
		
	idsITD.SetITem(llNewRow,'status','N')
	idsITD.SetITem(llNewRow,'tran_nbr',Trim(iu_DS.GetITemString(llRowPos,'column2')))
	idsITD.SetITem(llNewRow,'serial_no',Trim(iu_DS.GetITemString(llRowPos,'column3')))
	idsITD.SetITem(llNewRow,'address_1',Trim(iu_DS.GetITemString(llRowPos,'column5')))
	idsITD.SetITem(llNewRow,'address_2',Trim(iu_DS.GetITemString(llRowPos,'column6')))
	idsITD.SetITem(llNewRow,'address_3',Trim(iu_DS.GetITemString(llRowPos,'column7')))
	idsITD.SetITem(llNewRow,'address_4',Trim(iu_DS.GetITemString(llRowPos,'column8')))
	idsITD.SetITem(llNewRow,'address_5',Trim(iu_DS.GetITemString(llRowPos,'column9')))
	idsITD.SetITem(llNewRow,'attribute_1',Trim(iu_DS.GetITemString(llRowPos,'column10')))
	idsITD.SetITem(llNewRow,'attribute_2',Trim(iu_DS.GetITemString(llRowPos,'column11')))
	idsITD.SetITem(llNewRow,'attribute_3',Trim(iu_DS.GetITemString(llRowPos,'column12')))
	/* 7/18/2011 - GXMOR - Remove attributes 4 and 5 from upload.  Vendors using these for other purposes */
	//idsITD.SetITem(llNewRow,'attribute_4',Trim(iu_DS.GetITemString(llRowPos,'column13')))
	//idsITD.SetITem(llNewRow,'attribute_5',Trim(iu_DS.GetITemString(llRowPos,'column14')))
	
	//Validate Model (if changed)...
	lsModel = iu_DS.GetITemString(llRowPos,'column4')
	If isnull(lsModel) Then lsModel = ''
	
	idsITD.SetITem(llNewRow,'model_no',lsModel)
	
	If lsModel > '' Then 
		lsAnyModel = lsModel /* will use to update any blank rows*/
		lbNoModel = False
	End If
	
	
	//If we have already determined there is more more than 1 SKU in the file, flag as an error and continue
	// Or if we have already determined there are multiple attributes
	If lbMultiSKU or lbMultiAttr Then
		idsITD.SetITem(llNewRow,'status','C')  //hdc 01/07/2013  sync with daily SP using more discrete statuses
		Continue
	End If
	
	If lsModel = '' Then
		
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Model not present.  ITD Record will not be processed.")
		idsITD.SetITem(llNewRow,'status','C')  //hdc 01/07/2013  sync with daily SP using more discrete statuses
		Continue
			
	Else
		
		//WE should only have one model per pallet and only one pallet per transaction - so if more than 1 Model per file, reject entire file
		//GWM - Attributes 1 thru 5 must not change for a pallet
		//GWM - 10/10/2012 - Make an exception for Technicolor Kit that allows 2 models per pallet
		If llRowPos > 1 Then
			
			If lsModel <> iu_DS.GetITemString(llRowPos - 1,'column4') and lsModel > '' and  iu_DS.GetITemString(llRowPos - 1,'column4') > '' 	and iu_DS.GetItemString(llRowPos - 1, 'column4') <> 'ATPA-T' and iu_DS.GetItemString(llRowPos - 1, 'column4') <> 'CQ9ZZZ000' Then

				lbError = True
				lbMultiSKU = True
				
				//Report at the end of the file.
				gu_nvo_process_files.uf_writeError("** Multiple Models found in Transaction (pallet): " + lsTranNbr + " Transaction/Pallet will not be processed. **")
				idsITD.SetITem(llNewRow,'status','C')  //hdc 01/07/2013  sync with daily SP using more discrete statuses
				Continue
				
			End If
			
			If  (iu_DS.GetItemString(llRowPos, 'column10') <> lsAttr1Save or  iu_DS.GetItemString(llRowPos, 'column11')  <> lsAttr2Save &
				or  iu_DS.GetItemString(llRowPos, 'column12') <> lsAttr3Save) Then
				//or  iu_DS.GetItemString(llRowPos, 'column13') <> lsAttr4Save or  iu_DS.GetItemString(llRowPos, 'column14') <> lsAttr5Save) Then
				
				lbError = True
				lbMultiAttr = True
				
				//Report at the end of the file.
				gu_nvo_process_files.uf_writeError("** Multiple Attributes found in Transaction (pallet): " + lsTranNbr + " Transaction/Pallet will not be processed. **")
				idsITD.SetITem(llNewRow,'status','C')  //hdc 01/07/2013  sync with daily SP using more discrete statuses
				Continue
				
			End If
			
		Else	/* First Row */
			
			lsAttr1Save = iu_DS.GetItemString(llRowPos, 'column10')
			lsAttr2Save = iu_DS.GetItemString(llRowPos, 'column11')
			lsAttr3Save = iu_DS.GetItemString(llRowPos, 'column12')
			//lsAttr4Save = iu_DS.GetItemString(llRowPos, 'column13')
			//lsAttr5Save = iu_DS.GetItemString(llRowPos, 'column14')
			
		End If /* Not first row*/
		
		If lsModel <> lsModelSave Then
	
			Select Count(*) into :llCount
			From Item_Master
			Where Project_id = 'Comcast' and user_Field10 = :lsModel;
		
			lsModelSave = lsModel
		
		End If
	
		If llCount = 0 Then
		
			lbError = True
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " -Invalid Model: '" + lsModel + "'. ITD Record will not be processed.")
			idsITD.SetITem(llNewRow,'status','C')  //hdc 01/07/2013  sync with daily SP using more discrete statuses
			Continue
	
		End If
		
	End If
		
Next /* ITD Row*/

//If multiple SKU's or No SKU, write to error log
if lbMultiSKU or lbNoModel  Then
	
	//Get relevent info from Header if found
	Select Ref_nbr, bol_nbr, Pallet_ID
	into :lsRefNbr, :lsBOL, :lsPallet
	From Comcast_Ith
	Where Tran_Nbr = :lsTranNbr;
	
	If isnull(lsRefNbr) Then lsRefNbr = '(No Ref Nbr)'
	If isnull(lsBOL) Then lsBOL = '(No BOL)'
	If isnull(lsPallet) Then lsPallet = '(No Pallet)'
		
	If lbMultiSKU Then
		gu_nvo_process_files.uf_writeError("** Multiple Models found in Transaction/Ref Nbr/BOL/Pallet: " + lsTranNbr + "/" +lsRefNbr + "/" + lsBOL + "/" +  lsPallet +  " -  Transaction/Pallet will not be processed. **")
	Else
		gu_nvo_process_files.uf_writeError("** No Model found in Transaction/Ref Nbr/BOL/Pallet: " + lsTranNbr + "/" +lsRefNbr + "/" + lsBOL + "/" +  lsPallet +  " -  Transaction/Pallet will not be processed. **")
	End If
	
End If

//If we have any records with a model (and not mutiple models), update any blank rows - make the assumption that they should be the same as already preent on the transaction
If Not lbMultiSKU and lsAnyModel > '' Then
	
	llRowCount = idsITD.RowCount()
			
	For llRowPos = 1 to llRowCount
		
		If idsITD.GetITemString(llRowPos,'Model_no') = '' or isnull( idsITD.GetITemString(llRowPos,'Model_no')) Then
			idsITD.SetITem(llRowPos,'model_no',lsAnyModel)
		End If
		
	Next
	
End if

//Save Changes
liRC = idsITD.Update()

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new ITD Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

//Process any complete Transactions (we dont if the header or detail will load first
//uf_process_ith_itd()

If liRC < 0 or lbError Then
	REturn -1
Else
	Return 0
End IF



end function

public function integer uf_load_ith (string aspath, string asproject);String			lsLogOut, lsTransID, lsSite, lsWarehouse, lsTranNbr, lsPallet, lsBOL, lsWaybill, lsStatus, lsFromSite, lsRefNbr
Long			llRC, llRowpos, llRowCount, llNewRow, llCount,llRefCount
Integer		liRC
Boolean		lbError, lbMenloTran
DateTime	ldtToday

//The ITH/ITD records are loaded here and then will be processed as a scheduled function so we can process them all together. Each transaction is a seperate file but we may need to combine them.

ldtToday = DateTIme(Today(),Now())

If not isvalid(iu_DS) Then
	iu_DS = Create datastore
End IF

iu_DS.dataobject = 'd_import_generic_csv'
iu_DS.Reset()

If not isvalid(idsITH) Then
	idsITH = Create Datastore
	idsITH.dataobject = 'd_comcast_ith' 
	idsITH.SetTransObject(SQLCA)
End If

idsITH.Reset()

//Open and read the File In - Importing Tab  file
lsLogOut = '      - Opening File for Comcast ITH Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = iu_DS.ImportFile(text!,asPath) 

If llRC < 0 Then
	lsLogOut = "-       ***Unable to import Comcast ITH file: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 
End If

//Process each row of the File
llRowCount = iu_DS.RowCount()

For llRowPos = 1 to llRowCount
	
	lsTranNbr = Trim(iu_DS.GetITemString(llRowPos,'column2'))
	lsPallet = Trim(iu_DS.GetITemString(llRowPos,'column12'))
	lsBOL = Trim(iu_DS.GetITemString(llRowPos,'column11'))
	lsWayBill = Trim(iu_DS.GetITemString(llRowPos,'column14'))
	llRefCount = long(Trim(iu_DS.GetITemString(llRowPos,'column7')))
	lsFromSite = Trim(iu_DS.GetITemString(llRowPos,'column16'))
	lsRefNbr = Trim(iu_DS.GetITemString(llRowPos,'column6'))

	
	//If an ITH_header already exists, update...
	Select Count(*) into : llCount
	From comcast_ith
	where tran_nbr = :lsTranNbr;
	
	If llCount > 0 Then /*already exists, update*/
		
		//If from Site ID is Menlo, mark as complete, no need to process
		If Upper(Left(lsFromSite,4)) = 'VMEN' Then
			lsStatus = 'C'
		Else
			lsStatus = 'U'
		End If
		
		// 02/11 - PCONKL - We may have manually loaded records into the Carton_serial Table with good data that we don't want to overlay repeatedly with CRAP data. Check for Status CD of 'K' in Carton Serial for Pallet
		SElect Count(*) into :llCount
		From Carton_Serial
		Where PRoject_id = 'Comcast' and pallet_id = :lsPallet and status_cd = 'K'; /* K = Keep */
		
		//If exists witk a K, we won't process this ITH Header record for this pallet
		If llCount > 0 Then
			lsStatus = 'C'
		End If
		
		Update Comcast_ith
		set pallet_id = :lsPallet, bol_nbr = :lsBOL, waybill_nbr = :lsWaybill, ref_cnt = :llRefCount, Status = :lsStatus
		Where Tran_nbr = :lsTranNbr;
		
		Commit;
	
		Continue /*no need to write another header*/
		
	End If
		
	llNewRow = idsITH.InsertRow(0)
	
	//If from Site ID is Menlo, mark as complete, no need to process
	If Upper(Left(lsFromSite,4)) = 'VMEN' Then
		idsITH.SetITem(llNewRow,'status','C')
	Else
		idsITH.SetITem(llNewRow,'status','N')
	End If
		
	//Site ID needs to be converted to warehouse_Code
	lsSite = iu_DS.GetItemString(llRowPos,'column1')
	
	lsWarehouse = ''
	
	Select wh_code into :lsWarehouse
	From Warehouse
	Where  wh_code in (select wh_code from project_warehouse where project_id = 'Comcast') and User_Field1 = :lsSite;
	
	If lsWarehouse = '' Then
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + ", Tran Nbr: " + lstranNbr + " -Invalid Site ID: '" + lsSite + "'. ITH Record will not be processed.")
		idsITH.SetITem(llNewRow,'status','E')
	//	Continue
	End If
	
	//Pallet must be present...
	If lsPallet = '' or isnull( lsPallet) Then
		lsPallet = ''
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + ", Tran Nbr: " + lstranNbr + " - Pallet ID is required. ITH Record will not be processed.")
		idsITH.SetITem(llNewRow,'status','E')
	End IF
	
	// Ref Nnr, BOL and/or Waybill must be present
	If (lsRefNbr = '' or isnull(lsRefNbr)) and (lsBol = '' or isnull( lsBOL)) and (lsWaybill = '' or isnull(lsWayBill)) Then
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + ", Tran Nbr: " + lstranNbr + ", Pallet: " + lsPallet + " - BOL Nbr and/or Waybill Nbr is required. ITH Record will not be processed.")
		idsITH.SetITem(llNewRow,'status','E')
	End IF
	
	// IF Site IT not mapped to the SIMS warehouse, load what was sent so we can report errors on it
	If lsWarehouse > '' Then
		idsITH.SetITem(llNewRow,'wh_code',lsWarehouse)
	Else
		idsITH.SetITem(llNewRow,'wh_code',lsSite)
	End If
	
	idsITH.SetITem(llNewRow,'tran_nbr',lsTranNbr)
	idsITH.SetITem(llNewRow,'ref_nbr',lsRefNbr)
	idsITH.SetITem(llNewRow,'ref_cnt',llRefCount)
	idsITH.SetITem(llNewRow,'from_site_Id',Trim(iu_DS.GetITemString(llRowPos,'column8')))
	idsITH.SetITem(llNewRow,'container_temp_id',Trim(iu_DS.GetITemString(llRowPos,'column10')))
	idsITH.SetITem(llNewRow,'bol_nbr',lsBOL)
	idsITH.SetITem(llNewRow,'Pallet_ID',lsPallet)
	idsITH.SetITem(llNewRow,'carrier',Trim(iu_DS.GetITemString(llRowPos,'column13')))
	idsITH.SetITem(llNewRow,'waybill_nbr',lsWayBill)
	idsITH.SetITem(llNewRow,'create_date',ldtToday)
	
//	If isDate(iu_DS.GetITemString(llRowPos,'column5')) Then
//		idsITH.SetITem(llNewRow,'create_date',Date(Trim(iu_DS.GetITemString(llRowPos,'column8'))))
//	End IF
			
Next

//Save Changes
liRC = idsITH.Update()

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new ITH Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

//Process any complete Transactions (we dont if the header or detail will load first
//uf_process_ith_itd()

If lbError or liRC < 0 Then
	Return - 1
Else
	Return 0
End IF

end function

public function integer uf_eis_snapshot (string asinifile, string asemail);//Create a snapshot of Menlo Serial Numbers to send to EIS a single serial field by Reportstore. M-Card no longer in UF5
// 10/10 - PCONKL - Serial numbers should now be mapped into

String	lsLogout, sql_syntax,errors, lsFind, lsFileName, lsFileNamePath, lsEmail, lsText
Long	llRC, llInvPos, llInvCount, llFindRow, llNewRow
DataStore	 ldsSIMSInv
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' Processing function: Comcast EIS Serial Snapshot....'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Load the SIMS  Inventory
ldsSIMSInv = Create Datastore
//sql_syntax = "SELECT  Warehouse.User_Field1 as Site_ID , Case When Carton_serial.User_Field5 > '' Then Carton_serial.user_Field5 Else Carton_serial.Serial_No End as Serial_no   " 
//sql_syntax = "SELECT  Warehouse.User_Field1 as Site_ID ,Carton_serial.Serial_No    " 
sql_syntax = "SELECT  Warehouse.User_Field1 as Site_ID , Case Source When 'REPORTSTORE' Then Carton_serial.Serial_No When 'EIS' Then Carton_serial.Serial_No Else Case When Carton_serial.User_Field5 > '' Then Carton_serial.user_Field5 Else Carton_serial.Serial_No End End  as Serial_No "
sql_syntax += "FROM  Carton_Serial,   Content_Summary  , Warehouse With (nolock) "
sql_syntax += "WHERE  dbo.Carton_Serial.Project_ID = dbo.Content_Summary.Project_ID and Content_summary.Project_id = 'Comcast' and   "
sql_syntax += 	"  dbo.Carton_Serial.Pallet_ID = dbo.Content_Summary.Lot_No     and Carton_serial.Project_id = 'Comcast' and (alloc_qty > 0 or avail_qty > 0 or tfr_in > 0 or tfr_out > 0) and Content_Summary.wh_Code = Warehouse.wh_code "

//exclude loose serial numbers and cartons...
sql_syntax += 	" and carton_serial.serial_no Not in (Select Carton_Serial.Serial_NO From Delivery_MAster, DElivery_Picking_Detail, Delivery_Serial_Detail, Carton_Serial with (nolock) "
sql_syntax += 	" Where delivery_MAster.do_no = DElivery_picking_detail.do_no and Delivery_picking_detail.id_no = Delivery_serial_detail.id_no and Delivery_MAster.Project_id = Carton_serial.Project_id and "
sql_syntax += 	" Delivery_Master.Project_id = 'Comcast' and Delivery_Master.Ord_status in ('C','D') and Delivery_Master.Ord_Type in ('S','X') and Delivery_serial_Detail.serial_no = carton_serial.Serial_no) "

sql_syntax += 	" and carton_serial.serial_no Not in (Select Carton_Serial.Serial_NO From Delivery_MAster, DElivery_Picking_Detail, Delivery_Serial_Detail, Carton_Serial with (nolock) "
sql_syntax += 	" Where delivery_MAster.do_no = DElivery_picking_detail.do_no and Delivery_picking_detail.id_no = Delivery_serial_detail.id_no and Delivery_MAster.Project_id = Carton_serial.Project_id and "
sql_syntax += 	" Delivery_Master.Project_id = 'Comcast' and Delivery_Master.Ord_status in ('C','D') and Delivery_Master.Ord_Type in ('S','X') and Delivery_serial_Detail.serial_no = carton_serial.Carton_ID) "

//exclude loose M-Card serial numbers (UF5)
//sql_syntax += 	" and carton_serial.User_Field5 Not in (Select Carton_Serial.User_Field5 From Delivery_MAster, DElivery_Picking_Detail, Delivery_Serial_Detail, Carton_Serial with (nolock) "
//sql_syntax += 	" Where delivery_MAster.do_no = DElivery_picking_detail.do_no and Delivery_picking_detail.id_no = Delivery_serial_detail.id_no and Delivery_MAster.Project_id = Carton_serial.Project_id and "
//sql_syntax += 	" Delivery_Master.Project_id = 'Comcast' and Delivery_Master.Ord_status in ('C','D') and Delivery_serial_Detail.serial_no = carton_serial.User_Field5) "

ldsSIMSInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for SIMS Inventory (EIS Snapshot).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsSIMSInv.SetTransObject(SQLCA)

// Show microhelp on main window for long process
w_main.SetMicroHelp("Running Comcast weekly reconciliation snapshop")

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Retrieving SIMS Inventory...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llInvCount = ldsSIMSInv.Retrieve()

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' ' + String(llInvCount) + '  records retrieved...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Filter for each site and create a file of inventory for each

//VMEN01
ldsSIMSInv.SetFIlter("Upper(site_id) = 'VMEN01'")
ldsSIMSInv.Filter()

//Write file...
lsFileName =  'XPO_inventory_VMEN01_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )

//Email the file
lsText = "Attached is the XPO Serial Inventory for Site VMEN01 taken at " + String(ldtToday,'mm/dd/yyyy hh:mm') + " (GMT)"
If asEmail > '' Then
	gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Serial inventory for VMEN01",lsText,lsFileNamePath)
End If

//VMEN02
ldsSIMSInv.SetFIlter("Upper(site_id) = 'VMEN02'")
ldsSIMSInv.Filter()

//Write file...
lsFileName =  'XPO_inventory_VMEN02_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )

//Email the file
lsText = "Attached is the XPO Serial Inventory for Site VMEN02 taken at " + String(ldtToday,'mm/dd/yyyy hh:mm') + " (GMT)"
If asEmail > '' Then
	gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Serial inventory for VMEN02",lsText,lsFileNamePath)
End If

//VMEN03
ldsSIMSInv.SetFIlter("Upper(site_id) = 'VMEN03'")
ldsSIMSInv.Filter()

//Write file...
lsFileName =  'XPO_inventory_VMEN03_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )

//Email the file
lsText = "Attached is the XPO Serial Inventory for Site VMEN03 taken at " + String(ldtToday,'mm/dd/yyyy hh:mm') + " (GMT)"
If asEmail > '' Then
	gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Serial inventory for VMEN03",lsText,lsFileNamePath)
End If

//VMEN04
ldsSIMSInv.SetFIlter("Upper(site_id) = 'VMEN04'")
ldsSIMSInv.Filter()

//Write file...
lsFileName =  'XPO_inventory_VMEN04_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )

//Email the file
lsText = "Attached is the XPO Serial Inventory for Site VMEN04 taken at " + String(ldtToday,'mm/dd/yyyy hh:mm') + " (GMT)"
If asEmail > '' Then
	gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"XPO Serial inventory for VMEN04",lsText,lsFileNamePath)
End If

w_main.SetMicroHelp("Ready")
Destroy ldsSIMSInv 

Return 0


end function

public function integer uf_missing_serial (string asinifile, string asemail);//Create a report of Comcast pallets with missing serial numbers to send to Comcast

String	lsLogout, sql_syntax,errors, lsFind, lsFileName, lsFileNamePath, lsEmail, lsText
String lsFromDateTime, lsToDateTime
Long	llRC, llInvPos, llInvCount, llFindRow, llNewRow
DataStore	 ldsSIMSInv
DateTime	ldtToday
Date			ldDay1, ldDay2

ldtToday = DateTime(today(),Now())
ldDay1 = RelativeDate ( today(), -2 )
ldDay2 = RelativeDate ( today(), -1 )

lsFromDateTime = String(ldDay1) + " 1:00pm"
lsToDateTime = String(ldDay2) + " 12:59pm"

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' Processing function: Comcast Daily Missing Serials....'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Load the SIMS  datastore
ldsSIMSInv = Create Datastore
sql_syntax = "select rm.wh_code Warehouse,cast(rm.supp_invoice_no AS varchar(30)) Order_Nbr, "
sql_syntax += "convert(varchar(20),rm.complete_date),rp.sku SKU,  " 
sql_syntax += "	rp.lot_no Pallet,convert(varchar(8),convert(integer,rp.quantity)) Rcv_Qty, "
sql_syntax += "convert(varchar(8),convert(integer,count(cs.serial_no))) Serial_File_Qty "
sql_syntax += "from receive_master rm, receive_putaway rp  "
sql_syntax += "left outer join carton_serial cs ON rp.lot_no = cs.pallet_id  and cs.project_id = 'Comcast' "
sql_syntax += "where rm.project_id = 'Comcast' and rp.ro_no = rm.ro_no "
sql_syntax += "and rm.complete_date between '" + string(ldDay1) + " 13:00:00.000' and '" + string(ldDay2) + " 12:59:59.999' "
sql_syntax += "group by rm.wh_code,rm.supp_invoice_no,rm.complete_date,rp.sku,rp.lot_no,rp.quantity "
sql_syntax += "order by rm.wh_code,rm.supp_invoice_no,rp.sku,rp.lot_no "


ldsSIMSInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for SIMS Comcast Daily Missing Serial Numbers.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsSIMSInv.SetTransObject(SQLCA)

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Retrieving Missing Serial Numbers...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llInvCount = ldsSIMSInv.Retrieve()

// Insert a heading row in datastore
llNewRow = ldsSIMSInv.InsertRow(1)
ldsSIMSInv.SetItem(llNewRow,1,"Warehouse")
ldsSIMSInv.SetItem(llNewRow,2,"Order Nbr")
ldsSIMSInv.SetItem(llNewRow,3,"Complete Date")
ldsSIMSInv.SetItem(llNewRow,4,"SKU")
ldsSIMSInv.SetItem(llNewRow,5,"Pallet")
ldsSIMSInv.SetItem(llNewRow,6,"Rcv Qty")
ldsSIMSInv.SetItem(llNewRow,7,"Serial File Qty")

llNewRow = ldsSIMSInv.InsertRow(1)
ldsSIMSInv.SetItem(llNewRow,1,"Missing Serial Data for:")
ldsSIMSInv.SetItem(llNewRow,2,lsFromDateTime)
ldsSIMSInv.SetItem(llNewRow,3,lsToDateTime)

// No records for this period.  Show in report
IF llInvCount = 0 THEN
	llNewRow = ldsSIMSInv.InsertRow(0)
	ldsSIMSInv.SetItem(llNewRow,2,"No Records for this Period")
END IF

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' ' + String(llInvCount) + '  records retrieved...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write file...
//lsFileName =  'Comcast_Daily_Missing_Serials_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
//lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
//ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )
lsFileName =  'Comcast_Daily_Missing_Serials_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.xls'
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName
ldsSIMSInv.SaveAs ( lsFileNamePath, Excel!	, false )

//Email the file
lsText = "Attached is the Comcast Daily Missing Serial Numbers for " + String(ldtToday,'mm/dd/yyyy') + " (GMT)"
If asEmail > '' Then
	gu_nvo_process_files.uf_send_email("COMCAST",asEmail,"Comcast Daily Missing Serial Numbers",lsText,lsFileNamePath)
End If


Destroy ldsSIMSInv 

Return 0


end function

public function integer uf_import_carton_serial_old (string aspath, string asproject);
//Load Serial Number data (Pallet, Carton, MAC ID, Unit ID, Serial #)

//** Load the old 23 column format only - new 29 column format goes through uf_import_carton_serial ***

Integer		liFileNo,liRC, liCurrentFileCount, liCurrentFileNum
String			presentation_str, lsSQl, dwsyntax_str, lsErrText, lsModel, lsmodelSave, sql_syntax, errors, lsSerial, lsAddress[], lsOutString
Long			llNewRow, llRowPos, llRowCount, llCount, llBatchSeq, llEdiCount, llEdiPos, llSerialPos, llSerialCount, llPos
string 		lsOEMModel, lsOEMModelSave, lsSupplierSave
Dec			ldBatchSeq
String			lsLogOut, lsRecData, lsTemp, lsSKU, lsOrder, lsRONO
DataStore	lu_ds, ldsPODetail, ldsPallet, ldsCartonSerial
Boolean		lbError, lbAnyErrors, lbPalletexists
DateTime	ldtToday
String 		lsPallet, lsCarton, lsMac, lsSupplier, lsUF1, lsUF2, lsUF3, lsUF4, lsUF5
string ls_Error
String	lsPalletSave, lsWarehouse, lsLoc
Long	llOwner, llQty

u_ds_datastore luCartonSerial

ldtToday = DateTime(today(),Now())

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

luCartonSerial = Create u_ds_datastore
luCartonSerial.Dataobject = 'd_carton_serial'
luCartonSerial.SetTransObject(SQLCA)

ldsPODetail = Create u_ds_datastore
ldsPODetail.dataobject= 'd_po_detail'
ldsPODEtail.SetTransObject(SQLCA)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

ldsPODetail.Reset()
idsOut.Reset()

//Open the File
lsLogOut = '      - Opening File for Serial Number Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Comcast Processing: " + asPath
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

//We need the Order number from the file and retreive the RO_NO from the Inbound Order that should already be loaded in SIMS. File naming format is "SN=Warehouse=Order.txt"
lsOrder = Mid(asPath,(LastPos(asPath,"=") + 1),99999)
lsOrder = Left(lsOrder,(Pos(lsOrder,".") - 1)) /*remove ".txt" */

If lsOrder > '' Then
	
	Select Max(ro_No), Max(edi_Batch_seq_No) into :lsRONO, :llBatchSeq
	From Receive_master
	Where Project_id = 'COMCAST' and supp_invoice_No = :lsOrder;
	
End If

If lsRONO = "" Then /*no order for this file */

	lsLogOut =  "       File: " + asPath +  ", Order number: " + lsOrder + " not found in SIMS. File will still be loaded (Warning Only)."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	
End If

llRowCount = lu_ds.RowCount()

lsLogOut = '      -  ' + String(llRowCount)  + " records retrieved for processing."
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Loop through each record and build a carton serial record...

For lLRowPos = 1 to llRowCount
	
	lbError = False
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
	
	// 10/10 - PCONKL - CHeck for old file format (23 columns) on first record and get out if new format (29 columns)
	If llRowPos = 1 Then
		
		llCount = 0
		llPos = Pos(lsRecData,'|')
		Do WHile llPos > 0
			llCount ++
			If llCount = Len(lsRecData) Then
				llPos = 0
			Else 
				llPos ++
				llPos = Pos(lsRecData,'|', llPos)
			End If
		Loop
		
		//23 columns = 22 delimiters
		If llCount > 23 Then
			gu_nvo_process_files.uf_writeError("23 Columns expected  " + String(llCount) + " delimiters found. File will not be processed. If this is an OEM file, it should be prefixed with 'SN='")
			REturn - 1
		End IF
		
	End If /*First record, check for correct # of columns */
	
	
	llNewRow = luCartonSerial.InsertRow(0)
	luCartonSerial.SetItem(llNewRow,'Project_id','COMCAST')
	luCartonSerial.SetItem(llNewRow,'ro_no',lsRoNo)  /* used to link to Inbound Order */
	
	//PAck List Number - Not Used (#1)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Packer List Number' field. Record will not be processed.")
		lbError = True
	End If

			
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Pallet ID (#2)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Pallet ID' field. Record will not be processed.")
		lbError = True
	End If

	lsPallet = lsTemp
	
	// 11/10 - PCONKL - If this is a new pallet, we want to check to see if we have any serial numbers already loaded for this pallet. If we do, we will do a preemptive delete to ensure we don't have dups.
	//							In the new setup, we are not mapping MAC ID to the MAC ID field so if it already exists with MAC, we will insert a duplicate
	If lsPallet <> lsPalletSave Then
		
		lbPalletExists = False
		
		Select Count(*) into :llCount
		FRom Carton_Serial
		Where project_id = 'Comcast' and Pallet_id = :lsPallet;
		
		If llCount > 0 Then
			lbPalletExists = True /* we will delete by serial for this pallet*/
		End If
				
		lsPalletSave = lsPallet	
		
	End If
	
	luCartonSerial.SetItem(llNewRow,'Pallet_id',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Model Number 
	//04/10 - PCONKL - May be used to map to SKU if OEM Part not found
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Model Number' field. Record will not be processed.")
		lbError = True
	End If
	
	lsModel = lsTemp
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Finished Goods Number - OEM Part Number, need to convert to our SKU (#4)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Finished Goods Number' field. Record will not be processed.")
		lbError = True
	End If
	
	lsOEMModel = lsTemp
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	//There is currently a Case statement to hardcode the OEM Part Number to the SIMS SKU. 
	//I have added the OEM Part Number to the Item Master UF9. 
	//Please remove the Case statement and do a lookup against the Item Master to translate the OEM SKU to our SKU. 
	//Only do the lookup if the SKU changes. We are probably only receiving a single SKU per file.
	
//	string lsCurrentCheckOEMSku, ls_LastCheckOEMku, lsLastSKU
//	
//	lsCurrentCheckOEMSku = lsTemp
//	
//	if lsCurrentCheckOEMSku <> ls_LastCheckOEMku  then
//		
//		Select sku into :lsLastSKU
//		from Item_Master
//		Where Project_id = 'COMCAST' and user_field9 = :lsCurrentCheckOEMSku;
//		
//		 ls_LastCheckOEMku = lsCurrentCheckOEMSku
//		 
//		lsSKU = lsLastSKU		 
//		
//	else
//		lsSKU = lsLastSKU
//	end if
//	
//	// 04/10 - PCONKL - If SKU not found from OEM SKU (UF9), load it from UF10 (EIS Model). That's where most of them are coing from now.
//	If lsSKU = "" or isnull(lsSKU) Then
//		
//		Select sku into :lsSKU
//		from Item_Master
//		Where Project_id = 'COMCAST' and user_field10 = :lsModel;
//		
//	End If

//	luCartonSerial.SetItem(llNewRow,'sku',trim(lsSKU))
	

	
	
	//Ship Date - Not Used (#5)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Ship Date' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Manufacturer (Supplier) (#6)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Manufacturer' field. Record will not be processed.")
		lbError = True
	End If
	
	
	//validate
	If lsTemp <> lsSupplierSave Then
		
		Select Count(*) into :llCount
		From Supplier
		Where project_id = 'COMCAST' and supp_code = :lsTemp;
	
		If llCount = 0 Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Supplier: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
		Else
			lsSUpplier = lsTemp
		End If
		
		lsSupplierSave = lsSupplier
		
	End If /*Supplier changed*/
	
	
	//Model mapped now that we have loaded the Supplier...
	If lsModel <> lsModelSave and lsModel > '' and lsSupplier > ''Then
		
		lsSKU = ''
		
		Select Max(SKU) into :lsSKU
		from Item_Master
		Where Project_id = 'COMCAST' and supp_code = :lsSupplier and user_field10 = :lsModel;
		
		//If no match on Supplier, try just SKU
		if isNull(lsSKU) or lsSKU = '' Then
			
			Select max(sku) into :lsSKU
			from Item_Master
			Where Project_id = 'COMCAST'  and user_field10 = :lsModel;
			
		End If
		
		if isNull(lsSKU) THen lsSKU = ''
		
		lsModelSave = lsModel
		
	ENd If
	
	//If not found on Model, Try OEM Part Number
	if lsOEMModel <> lsOEMModelSave and lsSKU = '' then
		
		Select Max(SKU) into :lsSKU
		from Item_Master
		Where Project_id = 'COMCAST' and Supp_Code = :lsSupplier and  user_field9 = :lsOEMModel;
		
		//If no match on Supplier, try just SKU
		if isNull(lsSKU) or lsSKU = '' Then
			
			Select Max(sku) into :lsSKU
			from Item_Master
			Where Project_id = 'COMCAST' and  user_field9 = :lsOEMModel;
			
		End If
		
		if isNull(lsSKU) THen lsSKU = ''
		
		 lsOEMModelSave = lsOEMModel
		 		
	end if
	
	//Reject record if we dont match on SKU
	If lsSKU = '' or isnull(lsSKU) Then
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Unable to match to Item Master on EIS Model(#3) or OEM Part (#4): '" + lsModel + "/" + lsOEMModel + "'. Record will not be processed.")
		lbError = True
		
	End If
	
	luCartonSerial.SetItem(llNewRow,'sku',trim(lsSKU))
	luCartonSerial.SetItem(llNewRow,'supp_code',trim(lsTemp))
	
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Customer - Not Used (#7)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Name' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//City - Not Used (#8)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'City' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//State - Not Used (#9)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'State' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Serial Number (#10)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Serial Number' field. Record will not be processed.")
		lbError = True
	End If
	
	lsSerial = lsTemp
	luCartonSerial.SetItem(llNewRow,'serial_no',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	//11/10 - PCONKL - If we already have records for this pallet, we will try a preemptive delete to avoid Dups
	If lbPalletExists Then
		
		Delete from Carton_serial where Project_id = 'Comcast' and Pallet_id = :lsPallet and Serial_no = :lsSerial;
		Commit;
		
	End IF
	

// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
	
//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   						DTA = MAC Address (MAC_ID)
//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)									DTA = Blank
//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)							DTA = Blank
//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)

	
	//Unit ID (UF1) (#11)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Unit ID' field. Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'user_field1',trim(lsTemp))
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Host ID - (UF2) (#12)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Host ID' field. Record will not be processed.")
		lbError = True
	End If

	luCartonSerial.SetItem(llNewRow,'user_field2',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//ECM MAC (UF4) (#13)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'ECM MAC ID' field. Record will not be processed.")
		lbError = True
	End If

	luCartonSerial.SetItem(llNewRow,'user_field4',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Ethernet MAC - Not used (#14)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Ethernet MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Set Top MAC - USED (#15)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'STB MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'mac_id',trim(lsTemp))
	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//USB MAC - Not USed (#16)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'USB MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//1394 MAC - Not USed (#17)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after '1394 MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Embedded MAC - Not USed (#18)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Embedded MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-Card Serial -(UF5)  (#19) - 
	// 05/10 - PCONKL - Added mapping for CPE product
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'm-card Serial' field. Record will not be processed.")
		lbError = True
	End If
	
	luCartonSerial.SetItem(llNewRow,'user_field5',trim(lsTemp))	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-card unit Address - (UF3) (#20)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'm-Card Unit Address' field. Record will not be processed.")
		lbError = True
	End If

	luCartonSerial.SetItem(llNewRow,'user_field3',trim(lsTemp))	
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//m-Card  MAC - Not USed (#21)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'M-Card MAC' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//M-Card cableCard ID - Not USed (#22)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'M-Card CableCard ID' field. Record will not be processed.")
		lbError = True
	End If
	
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	
	//Master Pack Carton - Should be last field (#23)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else /*error*/
		lsTemp = lsRecData
	End If
	
	luCartonSerial.SetItem(llNewRow,'carton_id',trim(lsTemp))
		
	//Delete row if errors
	If lbError Then
		luCartonSerial.DeleteRow(llNewRow)
		lbAnyErrors = True
	End If
	
Next /*serial row */

//Save Serials to DB
liRC = luCartonSerial.Update()

	
If liRC = 1 then
	Commit;
Else
	
	Rollback;
	
//	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Pallet Serial Numbers Records to database! - Will try to update row by row."
//	FileWrite(gilogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_writeError(lsLogout)
	
	//Add check to only do for certain type of error?

	//Look through row by row.
	
	llRowCOunt = luCartonSerial.RowCount()
	
	For lLRowPos = 1 to llRowCount
			
		lsPallet = luCartonSerial.GetItemString(lLRowPos,'Pallet_id')
		lsCarton = luCartonSerial.GetItemString(lLRowPos,'carton_id')
		lsSerial = luCartonSerial.GetItemString(lLRowPos,'serial_no') 
		lsMac = luCartonSerial.GetItemString(lLRowPos,'mac_id') 	
		lsSku = luCartonSerial.GetItemString(lLRowPos,'sku') 			
		lsSupplier = luCartonSerial.GetItemString(lLRowPos,'supp_code') 	
		lsRoNo = luCartonSerial.GetItemString(lLRowPos,'ro_no') 	
		lsUF1 = luCartonSerial.GetItemString(lLRowPos,'user_field1')
		lsUF2 = luCartonSerial.GetItemString(lLRowPos,'user_field2')
		lsUF3 = luCartonSerial.GetItemString(lLRowPos,'user_field3')
		lsUF4 = luCartonSerial.GetItemString(lLRowPos,'user_field4')
		lsUF5 = luCartonSerial.GetItemString(lLRowPos,'user_field5')

		INSERT INTO  dbo.Carton_Serial 
			(Carton_Serial.Project_ID,    
         	 Carton_Serial.Carton_ID,   
        		 Carton_Serial.Serial_No,   
              Carton_Serial.Mac_ID,    
              Carton_Serial.Pallet_ID,   
        		Carton_Serial.SKU,   
        		Carton_Serial.Supp_Code,   
         	Carton_Serial.RO_NO,   
         	Carton_Serial.Last_Update,   
         	Carton_Serial.User_field1,   
         	Carton_Serial.User_field2,   
         	Carton_Serial.User_field3,   
         	Carton_Serial.User_field4, 
		  	Carton_Serial.User_field5)
			VALUES  ( :asproject,
			:lsCarton,
			:lsSerial,
			:lsMac,
			:lsPallet,
			:lsSku,
			:lsSupplier,
			:lsRoNo,
			getdate(),
			:lsUF1,
			:lsUF2,
			:lsUF3,
			:lsUF4,
			:lsUF5 )  USING SQLCA ;
	
	
	
		ls_Error = SQLCA.SQLErrText
	
		if SQLCA.SQLCode = 0 then
			
			COMMIT USING SQLCA;
			
		else
			
			ROLLBACK USING SQLCA;
			
			//Right now we are logging all errors.
			
			//Should we only log certain errors?
			
//			lsLogOut = Space(17) + "- ***System Error!  Unable to Save records to database Row: " +  &
//			+ string(lLRowPos) + "SN:" + lsSerial +  " (" + ls_Error + ")!"
//			FileWrite(gilogFileNo,lsLogOut)
			
		end if
	
	Next		
	
	//Return 0  // -1 Right now, don't error out if processing each row.
	
End If


//We want to apply the Pallet ID's to the EDI Inbound Detail records (Lot_No) so that they are included when the Putaway List is generated. We want to make sure we have the appropriate number of Pallets (based on Receipt Qty and Pallet Count)

//	01/11 - PCONKL - Retrieving edi_batch_seq_no currently associated with the Order (above).
//	The Max() may not be linkd to the order if a subsequent drop of the order is rejected but the EDI records still created

//Select Max(edi_batch_Seq_no) into :llbatchSeq
//From Edi_inbound_Header
//Where project_id = 'Comcast' and Order_no = :lsOrder;

If llBatchSeq > 0 Then
	
	llEdiCount = ldsPoDetail.Retrieve('Comcast', llBatchSeq, lsOrder)
	
	If llEdiCount > 0 and lsRONO > ""  Then
		
		//Retrieve a list of distinct Pallet ID's that we just saved for this order
		ldsPallet = Create Datastore
		presentation_str = "style(type=grid)"
		lsSQl = "Select Distinct Pallet_ID as Pallet_ID from Carton_serial " 
		lsSql += "Where project_id = 'Comcast ' and Ro_No = '" + lsRONO +  "'"

		dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
		ldsPallet.Create( dwsyntax_str, lsErrText)
		ldsPallet.SetTransObject(SQLCA)
		
		llRowCount = ldsPallet.Retrieve()
		
		//Hopefully, we have equal number of EDI rows and Pallets. If not, loop through the lesser amt and assign Pallets to Putaway Records
		If llRowCount >  llEdiCount Then llRowCount = llEdiCount
		
		For llRowPos = 1 to llRowCount
			ldsPoDetail.SetItem(llRowPos,'lot_no',ldsPallet.GetItemString(llRowPos,'pallet_id'))
		Next
		
		liRC = ldsPODetail.Update()
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save Pallet ID's to Inbound Orders!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
		End If

	End If
	
End If

// 05/10 - PCONKL - If we have loaded any pallets that we already have in Inventory with type 'S' (No Serial previoujsly loaded at receipt), Send TRC's for those pallets

//Create the Datastore
ldsCartonSerial = Create Datastore
sql_syntax =	 "Select Content.SKU, Content.Supp_Code, Content.wh_Code, Content.Owner_ID, Content.l_code, Content.Avail_qty, Content.Ro_no, Content.Lot_No,  Receive_MAster.Supp_invoice_no, Item_MAster.User_Field10 as eis_model, Item_Master.grp, "
sql_syntax +=	" Warehouse.user_Field1 as Site_ID, carton_serial.Serial_no, Mac_id, carton_serial.User_Field1, carton_serial.User_Field2, carton_serial.User_Field3,carton_serial.User_Field4,carton_serial.User_Field5 "
sql_syntax +=	" From Content,Receive_MAster, Carton_serial, Item_MASter, Warehouse "
sql_syntax +=	" Where Content.Project_id = carton_Serial.Project_id and content.Project_id = Item_MAster.Project_id and "
sql_syntax +=	" Content.Project_id = Receive_MAster.Project_id and Content.Ro_no = Receive_Master.RO_NO and "
sql_syntax +=	" Content.SKU = Item_MAster.SKU and Content.supp_code = Item_Master.Supp_Code and "
sql_syntax +=	" Content.Lot_NO = Carton_Serial.Pallet_id and Content.wh_code = Warehouse.Wh_Code and "
sql_syntax +=	" Content.Project_id = 'Comcast' and content.inventory_Type = 'S' "
sql_syntax +=   " Order by Content.Lot_No ; "

ldsCartonSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Carton_Serial Data" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsCartonSerial.SetTransObject(SQLCA)
llSerialCount = ldsCartonSerial.Retrieve()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

liCurrentFileCount = 0
liCurrentFileNum = 1
lsPalletSave = ''

//For each Serial Number, write a TRC
For llSerialPos = 1 to llSerialCount
		
		llNewRow = idsOut.insertRow(0)
		liCurrentFileCount ++
		
		lsOutString = 'TRC|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TRC$$HEX1$$1920$$ENDHEX$$
		lsOutString +=  "|"  //From Site ID - blanks
		
		If Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "site_id")) Then
			lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "site_id")	 + '|' //To Site ID -  Warehouse.User_Field1
		Else
			lsOutString += "|"
		End If
		
		lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "Supp_invoice_no") +  '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$SIMS Order Number
		lsOutString += '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		
		lsOutString+=  '|'  //Start Date

		// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
		lsOutString +=  '|'  //Status
		
		//Pallet ID 
		If ldsCartonSerial.GetItemString(llSerialPos, "lot_no")<> '-' and Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "lot_no")) Then
			lsOutString +=ldsCartonSerial.GetItemString(llSerialPos, "lot_no")	 + "|"
		Else
			lsOutString += '' + '|'
		End If
	
		lsOutString +=  '|'  /* BOL NO -  */
		
		// ***  End New Fields ***
	
		// 05/10 - Serial No is mapped differently depending on Product type (CPE vs DTA)
		Choose Case Upper(ldsCartonSerial.GetItemString(llSerialPos, "grp"))
			
			Case "CPE"
				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "user_field5")	/*field 19 - M-Card Serial*/
				
				If lsSerial = '' or isnull(lsSerial) then
					lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
				End If
				
			Case else /*Default to DTA */
				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
			
		End Choose
	
		If IsNull(lsserial) or lsSerial = '-' THEN lsserial = ''
	
		lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$Serial_No from Carton_Serial record 
		lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
		
		If Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "eis_model")) Then
			lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "eis_model") + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10
		Else
			lsOutString +=  '|'
		End If
		
		// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
	
		//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   				DTA = MAC Address (MAC_ID)
		//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
		//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)							DTA = Blank
		//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)					DTA = Blank
		//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)

		// 08/10 - Per Chris Smolen and Jim martin, Address 1 and 2 need to be swapped for DTA product.
		
		// 05/10 - PCONKL - Mapping different for CPE or DTA product
		Choose Case Upper(ldsCartonSerial.GetItemString(llSerialPos, "grp"))
			
			Case "CPE"
			
				lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field3")
				lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "serial_no")
				lsAddress[3] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
				lsAddress[4] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field4")
				lsAddress[5] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field2")

			Case Else /* Default to DTA */
			
				//lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
				//lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field1")
				
				lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field1")
				lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
				
				lsAddress[3] = ""
				lsAddress[4] = ""
				lsAddress[5] = ""
		
		End Choose
	
		if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
		if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
		if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
		if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
		if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
	
		lsOutString += lsAddress[1] + '|'  
		lsOutString += lsAddress[2] + '|' 
		lsOutString += lsAddress[3] + '|'  
		lsOutString += lsAddress[4] + '|' 
		lsOutString += lsAddress[5]   


		idsOut.SetItem(llNewRow,'Project_id', asProject)
		
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		//idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 

		//One file per pallet or 1000 record Max
		IF liCurrentFileCount >= 1000 or ldsCartonSerial.GetItemString(llSerialPos, "lot_no") <> lsPalletSave THEN

			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
			ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
			If ldBatchSeq <= 0 Then
				lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
				FileWrite(gilogFileNo,lsLogOut)
				Return -1
			End If	
	
			liCurrentFileCount = 0
		
			liCurrentFileNum = liCurrentFileNum + 1
		
		END IF
		
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 
		lsPalletSave = ldsCartonSerial.GetItemString(llSerialPos, "lot_no")
	
next /*Serial*/
	
//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


//Also Create a Stock Adjustment record to show the Inventory TYpe Change


lsPalletSave = ''

For llSerialPos = 1 to llSerialCount

	//One record per pallet
	lsPallet = ldsCartonSerial.GetItemString(llSerialPos, "lot_no")
	If lsPallet = lsPalletSave Then Continue
	
	lsSKU = ldsCartonSerial.GetItemString(llSerialPos, "SKU")
	lsSupplier = ldsCartonSerial.GetItemString(llSerialPos, "Supp_Code")
	llOWner = ldsCartonSerial.GetItemNumber(llSerialPos, "Owner_ID")
	lsWarehouse = ldsCartonSerial.GetItemString(llSerialPos, "wh_code")
	lsLoc = ldsCartonSerial.GetItemString(llSerialPos, "l_code")
	lsRONO = ldsCartonSerial.GetItemString(llSerialPos, "ro_no")
	llQty = ldsCartonSerial.GetItemNumber(llSerialPos, "avail_Qty")
	
	Insert Into Adjustment (Project_id, Sku, Supp_Code, Owner_id, Country_of_Origin, wh_Code, l_code,Inventory_type, Old_Inventory_Type, Serial_No,lot_no, ro_no, po_no, po_no2,old_quantity, quantity,reason, Container_ID, expiration_Date, Last_Update)
	Values					('COMCAST', :lsSKU, :lsSupplier, :llOwner, 'XXX', :lsWarehouse, :lsLoc, 'N','S','-',:lsPallet,:lsRONO,'-','-',:llQty,:llQty,'Carton Serial Load','-','2999/12/31', :ldtToday);
	
	
	lsPalletSave = lsPallet
	
Next /* Serial*/

//Update the Content Records
Update Content Set Inventory_Type = 'N'  
where project_id = 'Comcast' and inventory_Type = 'S' and lot_no in (select pallet_id from carton_serial where project_id = 'Comcast');

//Commit
Commit using SQLCA;

If lbAnyerrors Then
	Return - 1
Else
	Return 0
End If
end function

public function integer uf_process_serial_status_chg ();Integer		liFileNo,liRC, liCurrentFileCount, liCurrentFileNum, llPos
String			presentation_str, lsSQl, dwsyntax_str, lsErrText, lsModel, lsModelSave, sql_syntax, errors, lsSerial, lsAddress[], lsOutString, lsSupplierSave
string			 lsOEMModel, lsOEMModelSave
Long			llNewRow, llRowPos, llRowCount, llCount, llBatchSeq, llEdiCount, llEdiPos, llSerialPos, llSerialCount
Dec			ldBatchSeq
String			lsLogOut, lsRecData, lsTemp, lsSKU, lsOrder, lsRONO
DataStore	lu_ds, ldsPODetail, ldsPallet, ldsCartonSerial, luContentPallets
Boolean		lbError, lbAnyErrors
DateTime	ldtToday
String 		lsPallet, lsCarton, lsMac, lsSupplier, lsUF1, lsUF2, lsUF3, lsUF4, lsUF5
string ls_Error
String	lsPalletSave, lsWarehouse, lsLoc
Long	llOwner, llQty, llContentPos, llContentCount


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//For Serial Numbers we have loaded after the receipt, we need to reconcile and if necessary change the Inv Type in Content and send TRC to EIS

//Retrieve Content Pallets where Inv Type = 'S' and we have the serial numbers (joined by pallet)
luContentPallets = Create DataStore
sql_syntax = "Select Lot_no, Max(avail_Qty) as pallet_qty, Count(*) as Serial_qty from content, carton_serial with (nolock) "
sql_syntax += "Where Content.Project_id = 'Comcast' and  content.Project_id = carton_serial.Project_id and content.Lot_no = Carton_serial.Pallet_id and Inventory_Type = 'S' "
sql_syntax += "Group by Lot_no "
sql_syntax += " Having Max(avail_qty) <= Count(*); "

luContentPallets.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Content Pallet Data" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

luContentPallets.SetTransObject(SQLCA)
llContentCount = luContentPallets.Retrieve()

//For each pallet, create the TRC, change Inventory Type and create Adjustment
For llContentPos = 1 to llContentCount
	
	lsPallet = luContentPallets.GetITEmString(llContentPos,'lot_no')
	
	//Create the Serial Datastore
	ldsCartonSerial = Create Datastore
	sql_syntax =	 "Select Content.SKU, Content.Supp_Code, Content.wh_Code, Content.Owner_ID, Content.l_code, Content.Avail_qty, Content.Ro_no, Content.Lot_No,  Receive_MAster.Supp_invoice_no, Item_MAster.User_Field10 as eis_model, Item_Master.grp, "
	sql_syntax +=	" Warehouse.user_Field1 as Site_ID, carton_serial.Serial_no, Mac_id, carton_serial.User_Field1, carton_serial.User_Field2, carton_serial.User_Field3,carton_serial.User_Field4,carton_serial.User_Field5 "
	sql_syntax +=	" From Content,Receive_MAster, Carton_serial, Item_MASter, Warehouse "
	sql_syntax +=	" Where Content.Project_id = carton_Serial.Project_id and content.Project_id = Item_MAster.Project_id and "
	sql_syntax +=	" Content.Project_id = Receive_MAster.Project_id and Content.Ro_no = Receive_Master.RO_NO and "
	sql_syntax +=	" Content.SKU = Item_MAster.SKU and Content.supp_code = Item_Master.Supp_Code and "
	sql_syntax +=	" Content.Lot_NO = Carton_Serial.Pallet_id and Content.wh_code = Warehouse.Wh_Code and "
	sql_syntax +=	" Content.Project_id = 'Comcast' and content.Lot_no = '" + lsPallet + "';"
	
	ldsCartonSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

	IF Len(ERRORS) > 0 THEN
 	  	lsLogOut = "        *** Unable to create datastore for Carton_Serial Data" + Errors
		FileWrite(gilogFileNo,lsLogOut)
  		 RETURN - 1
	END IF

	ldsCartonSerial.SetTransObject(SQLCA)
	llSerialCount = ldsCartonSerial.Retrieve()
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	liCurrentFileCount = 0
	liCurrentFileNum = 1
	lsPalletSave = ''
	
	idsOut.Reset()
	
	//For each Serial Number, write a TRC
	For llSerialPos = 1 to llSerialCount
		
		llNewRow = idsOut.insertRow(0)
		liCurrentFileCount ++
		
		lsOutString = 'TRC|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TRC$$HEX1$$1920$$ENDHEX$$
		lsOutString +=  "|"  //From Site ID - blanks
		
		If Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "site_id")) Then
			lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "site_id")	 + '|' //To Site ID -  Warehouse.User_Field1
		Else
			lsOutString += "|"
		End If
		
		lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "Supp_invoice_no") +  '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$SIMS Order Number
		lsOutString += '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		
		lsOutString+=  '|'  //Start Date

		// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
		lsOutString +=  '|'  //Status
		
		//Pallet ID 
		If ldsCartonSerial.GetItemString(llSerialPos, "lot_no")<> '-' and Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "lot_no")) Then
			lsOutString +=ldsCartonSerial.GetItemString(llSerialPos, "lot_no")	 + "|"
		Else
			lsOutString += '' + '|'
		End If
	
		lsOutString +=  '|'  /* BOL NO -  */
		
		// ***  End New Fields ***
		
		lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
		If IsNull(lsserial) or lsSerial = '-' THEN lsserial = ''
	
		lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$Serial_No from Carton_Serial record 
		lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
		
		If Not isnull(ldsCartonSerial.GetItemString(llSerialPos, "eis_model")) Then
			lsOutString += ldsCartonSerial.GetItemString(llSerialPos, "eis_model") + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10
		Else
			lsOutString +=  '|'
		End If
		
		lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field1")
		lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field2")
		lsAddress[3] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field3")
		lsAddress[4] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field4")
		lsAddress[5] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field5")
		
		if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
		if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
		if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
		if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
		if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
	
		lsOutString += lsAddress[1] + '|'  
		lsOutString += lsAddress[2] + '|' 
		lsOutString += lsAddress[3] + '|'  
		lsOutString += lsAddress[4] + '|' 
		lsOutString += lsAddress[5]   

		idsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
		
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		//idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 

		//One file per pallet or 1000 record Max
		IF liCurrentFileCount >= 1000  THEN

			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
			ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Generic_Outbound','EDI_Batch_Seq_No')
			If ldBatchSeq <= 0 Then
				lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
				FileWrite(gilogFileNo,lsLogOut)
				Return -1
			End If	
	
			liCurrentFileCount = 0
		
			liCurrentFileNum = liCurrentFileNum + 1
		
		END IF
		
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 
		lsPalletSave = ldsCartonSerial.GetItemString(llSerialPos, "lot_no")
	
	next /*Serial*/
	
	//Write the Outbound File
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'COMCAST')
	

	//Also Create a Stock Adjustment record to show the Inventory TYpe Change
	lsSKU = ldsCartonSerial.GetItemString(1, "SKU")
	lsSupplier = ldsCartonSerial.GetItemString(1, "Supp_Code")
	llOWner = ldsCartonSerial.GetItemNumber(1, "Owner_ID")
	lsWarehouse = ldsCartonSerial.GetItemString(1, "wh_code")
	lsLoc = ldsCartonSerial.GetItemString(1, "l_code")
	lsRONO = ldsCartonSerial.GetItemString(1, "ro_no")
	llQty = ldsCartonSerial.GetItemNumber(1, "avail_Qty")
		
	Insert Into Adjustment (Project_id, Sku, Supp_Code, Owner_id, Country_of_Origin, wh_Code, l_code,Inventory_type, Old_Inventory_Type, Serial_No,lot_no, ro_no, po_no, po_no2,old_quantity, quantity,reason, Container_ID, expiration_Date, Last_Update)
	Values					('COMCAST', :lsSKU, :lsSupplier, :llOwner, 'XXX', :lsWarehouse, :lsLoc, 'N','S','-',:lsPallet,:lsRONO,'-','-',:llQty,:llQty,'Carton Serial Load','-','2999/12/31', :ldtToday);

	//Update the Content Records
	Update Content Set Inventory_Type = 'N'  
	where project_id = 'Comcast' and inventory_Type = 'S' and lot_no = :lsPallet;

	//Commit
	Commit using SQLCA;
		
	Destroy ldsCartonSerial
	
	
Next /*Content Pallet */

Return 0
end function

public function integer uf_eis_weekly_ftp_file (string asinifile, string asbhfile);// Cloned from uf_eis_snapshot

String	lsLogout, sql_syntax,errors, lsFind, lsFileName, lsFileNamePath, lsEmail, lsText
Long	llRC, llInvPos, llInvCount, llFindRow, llNewRow
DataStore	 ldsSIMSInv
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' Processing function: Comcast EIS Weekly FTP File....'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

lsFileName =  'BH_EIS_Inventory_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast-boh', "ftpfiledirout","") + '\' + lsFileName

//Load the SIMS  Inventory
ldsSIMSInv = Create Datastore
ldsSIMSInv.Dataobject = 'd_comcast_eis_snapshot'
llRC = ldsSIMSInv.SetTransobject(sqlca)

lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + '  Retrieving SIMS EIS FTP File...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llInvCount = ldsSIMSInv.Retrieve()

If llInvCount < 0 Then
	lsLogOut = "-       ***Unable to import Comcast EIS Snapshot file: " + lsFileNamePath + " / " + SQLCA.sqlerrtext
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 
End If

ldtToday = DateTime(today(),Now())
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' ' + String(llInvCount) + '  records retrieved...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Write file to \FlatFileOut staging area for FTP...
ldsSIMSInv.SaveAs ( lsFileNamePath, CSV!	, false )

Destroy ldsSIMSInv 

Return 0

end function

public function integer zz_process_ith_itd ();Datastore	ldsITH
String			lsSQl, presentation_str, lsErrText, dwsyntax_str, lsRONO, lsBOL, lsBOlSave, lsWaybill, lsWaybillSave, lsLogOut, lsWarehouse, lsOrder, lsModel, lsSKU, lsSUpplier, lsPallet,lsPalletSave, lsGroup, lsSerial, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsAddr5, lsTranNbr,	&
				lsCarrier, lsFromSite, lsOrdStatus, lsModelSave, lsDetailRONO
Long			llRowCount, llRowPos, llIDNo, llIDNOSave, llITDIDNO,  ll_no, llBatchSeq, llOwner, llQty, llLineItemNo, llCount, llPalletCount
DateTime	ldtToday

ldtToday = dateTime(today(),Now())

//Retrieve ITH/ITD joined on Tran_num where statuses are 'N' or 'U'

ldsITH = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select Comcast_ith.id_no as ith_id_no, Comcast_itd.id_no as itd_idno,  Comcast_ith.tran_nbr, ro_no, ref_nbr, ref_cnt, wh_code, bol_nbr, pallet_id, carrier, waybill_nbr, from_site_id, serial_no, model_no, address_1, address_2, address_3, address_4, address_5 " 
lsSql += " From Comcast_ith, comcast_itd "
lsSql += " Where comcast_ith.tran_nbr = Comcast_itd.tran_Nbr and comcast_ith.status in ('N', 'U')  and comcast_itd.status = 'N' "
lsSql += " Order by bol_nbr, waybill_nbr, Pallet_ID " /* Sort by BOL Nbr/Waybill and Pallet ID so we can process all the pallets for an order at the same time */

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsITH.Create( dwsyntax_str, lsErrText)
ldsITH.SetTransObject(SQLCA)

		
llRowCount = ldsIth.Retrieve()

For llRowPos = 1 to llRowCount

	//If the BOL NBR/Waybill combo has changed, we need to check to see if we already have an open Receive Master. If not, add one.
	llIDNO = ldsITH.GetITemNUmber(llRowPos,'ith_id_no')
	llITDIDNO =  ldsITH.GetITemNUmber(llRowPos,'itd_idno')
	lsBOL = ldsITH.GetITemString(lLRowPos,'bol_nbr')
	lsWaybill = ldsITH.GetITemString(lLRowPos,'waybill_nbr')
	lsModel = ldsITH.GetITemString(lLRowPos,'model_no')
	lsPallet = ldsITH.GetITemString(lLRowPos,'pallet_ID')
	lsTranNbr = ldsITH.GetITemString(lLRowPos,'tran_nbr')
	lsBOL = ldsITH.GetITemString(lLRowPos,'bol_nbr')
	lsWaybill = ldsITH.GetITemString(lLRowPos,'waybill_nbr')
	lswarehouse = ldsITH.GetITemString(lLRowPos,'wh_code')
		
	lsCarrier = ldsITH.GetITemString(lLRowPos,'carrier')
	lsFromSite = ldsITH.GetITemString(lLRowPos,'from_site_id')
	llQty = ldsITH.GetITemNUmber(llRowPos,'ref_cnt')
		
	
	//Get the SKU and Supplier if the MOdel has changed
	If lsModel <> lsModelSave then
					
		//If this is a (hardcoded) repair vendor, look for that specific SKU/Supplier, otherwise take any SKU/Supplier for the Model
		lsSKU = ''
		lsSupplier = ''
					
		If upper(left(lsFromSite,4)) = 'VTEL' Then
			lsSupplier = 'TELEPLAN'
		ElseIf upper(left(lsFromSite,4)) = 'VCON' Then
			lsSupplier = 'CONTEC'
		End If
				
		If lsSupplier > '' or isnull(lsSupplier) Then
					
			Select Max(SKU), Max(Owner_ID)
			into :lsSKU,  :llOwner
			From Item_MAster 
			Where Project_id = 'COMCAST' and supp_code = :lsSupplier and User_Field10 = :lsModel;	
				
		End If
					
		//If not found, find for any supplier
		If lsSKU = '' or isnull(lsSKU) Then
				
			Select Max(SKU), Max(Supp_code), Max(Owner_ID)
			into :lsSKU, :lsSupplier, :llOwner
			From Item_MAster 
			Where Project_id = 'COMCAST' and User_Field10 = :lsModel;	
					
		End If
								
	End If /*Model changed */
				
	//Process an Order Change based on BOL/Waybill combo changing
	If lsBol <> lsBOLSave or lsWaybill <> lsWayBillSave Then /* new Order*/
				
		//Look for an existing Receive_MAster based on AWB/Waybill (UF8)
		lsRONO = ''
		lsOrdStatus = ""
			
		//If a RO_NO exists on the ITH (and it still exists and is in a new status), we have created an order previously, no need to create a new one
		If ldsITH.GetITemString(lLRowPos,'ro_no') > '' Then
			
			lsRONO = ldsITH.GetITemString(lLRowPos,'ro_no') 
			
			select Count(*) into :llCount
			From Receive_Master
			Where ro_no = :lsRONO and ord_status in  ('N', 'P');
			
		End If
		
		If ldsITH.GetITemString(lLRowPos,'ro_no') > '' and llCount > 0  Then
						
			Select edi_batch_seq_no, Supp_Invoice_No
			into :llBatchSeq, :lsOrder
			From Receive_Master
			Where ro_no = :lsRONO;
			
		Else
			
			Select max(ro_no), Max(edi_batch_seq_no), Max(supp_invoice_no) into :lsRONO, :llbatchSeq, :lsOrder
			From Receive_MAster
			Where Project_id = 'Comcast' and Ord_status in  ('N', 'P') and awb_bol_no = :lsBOL and User_Field8 = :lsWaybill and edi_batch_seq_no > 0;
	
			If lsRONO = '' or isnull(lsRONO) Then /*no existing order, creat a new one*/
		
				//RO_NO
				ll_no = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','Receive_Master','RO_No')
				If ll_no <= 0 Then
					lsLogOut = "-       ***Unable to retrieve next available RO_NO***"
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 
				End If
	
				//Batch Sequence # 
				llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Inbound_Header','EDI_Batch_Seq_No')
				If llBatchSeq <= 0 Then
					lsLogOut = "-       ***Unable to retrieve next available EDI_Batch_Seq_No***"
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 
				End If

				lsRONO = 'COMCAST' + String(ll_no,"000000")
				lsOrder =  String(ll_no,"000000")
							
				Insert INto Receive_Master (Project_id, Ro_No, Ord_date, Ord_status, Ord_Type, Inventory_Type,wh_code, Supp_Code, Supp_invoice_No, AWB_BOL_No, User_Field8, last_user, Last_Update, Edi_Batch_Seq_No,Carrier,User_Field1)
				Values ('COMCAST', :lsRONO, :ldtToday, 'N', 'S','N',:lsWarehouse, :lsSupplier, :lsOrder, :lsBOL, :lsWayBill, 'SIMSFP', :ldtToday, :llBatchSeq,:lsCarrier,:lsFromSite)
				Using SQLCA;
			
				IF Sqlca.Sqlcode = 0 THEN
					Commit;
				Else
				
					Rollback;
				
					lsLogOut = "-       ***System Error. Unable to save new Receive Master records to database: " + Sqlca.SQlErrText
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 
				
				End If
			
				//Also need an EDI_Inbound_Header
				Insert Into Edi_Inbound_Header (Project_ID, EDI_Batch_Seq_No, Order_Seq_No,Order_No, Status_Cd)
				Values	('COMCAST', :llBatchSeq,1,:lsOrder,'C')
				Using SQLCA;
				
				IF Sqlca.Sqlcode = 0 THEN
					Commit;
				Else
				
					Rollback;
				
					lsLogOut = "-       ***System Error. Unable to save new EDI_Inbound_Detail records to database: " + Sqlca.SQlErrText
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 

				End If
				
			End If /*ro_no already exists in ith_header, receive master already created */
				
		End If /* new order being created*/
			
	End If /* New BOL/Waybill Combo*/

	//If the Pallet has changed, we either need to add/update the Receive Detail record - If the order number has also changed (last pallet on the order), update the previous order, otherwise update the current Order
	// We will have 1 receive detail record per pallet. This may span multiple Tran Nbr's if we get corrections after the original transaction. Pallet ID will be stored on the Receive Detail in UF1
	If lsPallet <> lsPalletSave Then
		
		//If not the first record, add/Update the Receive DEtail for the the ro_no on the previous record
		If llRowPos > 1 and llPalletCount > 0 Then
			
			lsDetailRONO = ldsITH.GetITemString(lLRowPos - 1,'ro_no') /*rono for the last record of the previous pallet (before it changed) */
			llLineItemNo = 0
			
			//Add a new Receive_Detail  row or update an existing one based on ro_no, SKU (from Model) and Pallet (UF1)
			Select Max(line_Item_No) into :llLineItemNo
			From Receive_Detail
			Where ro_no = :lsDetailRONO and Sku = :lsSKU and User_Field1 = :lsPalletSave;
		
			If llLineItemNo > 0 Then /*update existing Receive Detail. The only thing that might be changing is the qty*/
			
				Update Receive_Detail
				Set req_qty = :llPalletCount
				Where ro_no = :lsDetailRONO and Line_Item_No = :llLineItemNO and sku = :lsSKU;
						
				//Update the EDI_Inbound_Detail record as well
				Update edi_inbound_Detail
				set quantity = :llPalletCount
				Where Project_id = 'Comcast' and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrder and Line_Item_No = :llLineItemNO and sku = :lsSKU;
			
				Commit;
						
			Else
		
				//Need the next line item
				select Max(Line_item_No) into :llLineItemNo
				From Receive_Detail
				Where ro_no = :lsDetailRONO;
		
				If isnull(llLineItemNo) Then llLineItemNo = 0
				llLineItemNo ++
		
				Insert into Receive_Detail (ro_no, sku, supp_code, Owner_id,Country_of_Origin, Alternate_SKU, Req_Qty, Line_Item_No,User_Field1)
				Values (:lsDetailRONO, :lsSKU, :lsSupplier,:llOwner, 'XXX', :lsSKU, :llQty, :llLineItemNo,:lsPalletSave) /*storing Pallet in UF1 */
				Using SQLCA;
		
				IF Sqlca.Sqlcode = 0 THEN
					Commit;
				Else
			
					Rollback;
				
					lsLogOut = "-       ***System Error. Unable to save new Receive Detail records to database: " + Sqlca.SQlErrText
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 
			
				End If
		
				//Also need an EDI_Inbound_detail record so Pallet_Id (Lot_No) is populated at Putaway
				Insert into Edi_Inbound_Detail (Project_ID, EDI_Batch_Seq_No, Order_No, Order_Seq_No, Order_Line_No, SKU, Supp_Code, Lot_No, Line_Item_No,Quantity)
				Values ('COMCAST',:llBatchSeq, :lsOrder, 1,:llLineItemNo, :lsSKU, :lsSupplier, :lsPalletSave, :llLineItemNo, :llQty)
				Using SQLCA;
		
				IF Sqlca.Sqlcode = 0 THEN
					Commit;
				Else
			
					Rollback;
				
					lsLogOut = "-       ***System Error. Unable to save new EDI_Inbound_detail records to database: " + Sqlca.SQlErrText
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
					Return -1 
			
				End If
		
			End IF /*Detail already exists?*/
					
		End If /*Not first row*/
		
		llPalletCount = 0
		
	End If /* Pallet changed */

	
	// ** Add or Update the Serial record
	lsSerial =  ldsITH.GetITemString(lLRowPos,'serial_no')
	lsAddr1 =  ldsITH.GetITemString(lLRowPos,'Address_1')
	lsAddr2 =  ldsITH.GetITemString(lLRowPos,'Address_2')
	lsAddr3 =  ldsITH.GetITemString(lLRowPos,'Address_3')
	lsAddr4 =  ldsITH.GetITemString(lLRowPos,'Address_4')
	lsAddr5 =  ldsITH.GetITemString(lLRowPos,'Address_5')
	
	//Try an Insert, if it fails, we will do an update*/
	Insert into Carton_serial (project_id, Pallet_id,  sku, supp_code, carton_id, Serial_no, Mac_id,User_Field1, User_Field2, User_Field3, User_Field4, User_Field5, Source, last_update)
	Values ('COMCAST',:lsPallet,:lsSKU, :lsSupplier,'-',:lsSerial,'-', :lsAddr1, :lsAddr2, :lsAddr3,:lsAddr4,:lsAddr5, 'EIS', :ldtToday)
	Using SQLCA;
			
	IF Sqlca.Sqlcode = 0 THEN
		
		Commit;
		
	Else /*Update Address fields on existing record */
			
		Update Carton_serial
		Set User_Field1 = :lsAddr1, User_Field2 = :lsAddr2, USer_Field3 = :lsAddr3, User_Field4 = :lsAddr4, USer_Field5 = :lsAddr5, Source = 'EIS', Last_Update = :ldtToday
		Where Project_id = 'COMCAST' and Serial_no = :lsSerial;
				
		IF Sqlca.Sqlcode = 0 THEN
			Commit;
		Else
			Rollback;
		End If
		
	End If
		

	//Set the order number on the ITH and mark complete - All ITH with the same BOL/Waybill will get the same RO_NO (same Receive Master)
	ldsITH.SetITem(lLRowPos,'ro_no',lsRONO) 
	
	If llIDNO <> llIDNOSave or llRowPos = llRowCount Then /*Only update header when changed or last row*/
		
		UPdate comcast_ith set ro_no = :lsRONO, status = 'C'
		Where id_no = :llIDNO;
		
	End If
	
	UPdate comcast_itd set  status = 'C'
	Where id_no = :llITDIDNO;
	
	Commit;



	llPalletCount ++ /* Number of itd records on pallet will be the Req_qty */
	
	lsBOLSave = lsBOL
	lsWaybillSave = lsWayBill
	lsPalletSave = lsPallet
	lsModelSave = lsModel
	llIDNOSave = llIDNO

		
Next /* ITH/ITD */


// **  Write the last Receive Detail record for the last pallet
If llRowCount > 0 and lsRONO > '' and lsSKU > '' Then
	
	llLineItemNO = 0

	Select Max(line_Item_No) into :llLineItemNo
	From Receive_Detail
	Where ro_no = :lsRONO and Sku = :lsSKU and User_Field1 = :lsPalletSave;
		
	If llLineItemNo > 0 Then /*update existing Receive Detail. The only thing that might be changing is the qty*/
			
		Update Receive_Detail
		Set req_qty = :llPalletCount
		Where ro_no = :lsRONO and Line_Item_No = :llLineItemNO and sku = :lsSKU;
						
		//Update the EDI_Inbound_Detail record as well
		Update edi_inbound_Detail
		set quantity = :llPalletCount
		Where Project_id = 'Comcast' and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrder and Line_Item_No = :llLineItemNO and sku = :lsSKU;
			
		Commit;
						
	Else /*Line doesn't already exist for Pallet*/
		
		//Need the next line item
		select Max(Line_item_No) into :llLineItemNo
		From Receive_Detail
		Where ro_no = :lsRONO;
		
		If isnull(llLineItemNo) Then llLineItemNo = 0
	
		llLineItemNo ++
		
		Insert into Receive_Detail (ro_no, sku, supp_code, Owner_id,Country_of_Origin, Alternate_SKU, Req_Qty, Line_Item_No,User_Field1)
		Values (:lsRONO, :lsSKU, :lsSupplier,:llOwner, 'XXX', :lsSKU, :llQty, :llLineItemNo,:lsPalletSave) /*storing Pallet in UF1 */
		Using SQLCA;
		
		IF Sqlca.Sqlcode = 0 THEN
			Commit;
		Else
			
			Rollback;
				
			lsLogOut = "-       ***System Error. Unable to save new Receive Detail records to database: " + Sqlca.SQlErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1 
			
		End If
		
		//Also need an EDI_Inbound_detail record so Pallet_Id (Lot_No) is populated at Putaway
		Insert into Edi_Inbound_Detail (Project_ID, EDI_Batch_Seq_No, Order_No, Order_Seq_No, Order_Line_No, SKU, Supp_Code, Lot_No, Line_Item_No,Quantity)
		Values ('COMCAST',:llBatchSeq, :lsOrder, 1,:llLineItemNo, :lsSKU, :lsSupplier, :lsPalletSave, :llLineItemNo, :llQty)
		Using SQLCA;
		
		IF Sqlca.Sqlcode = 0 THEN
			Commit;
		Else
			
			Rollback;
			
			lsLogOut = "-       ***System Error. Unable to save new EDI_Inbound_detail records to database: " + Sqlca.SQlErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -1 
			
		End If
		
	End IF /*Detail already exists?*/
	
End If







	
	
	
	

REturn 0
end function

public function integer uf_process_dailyactivity_report (string asinifile, string asemail);//Jxlim 10/20/2010
//Process the COMCAST Daily Activity Report
//uf_process_dailyactivity_report string asinifile, asemail, asparmstring return Integer


Datastore	lds_DailyActivity_ext, 	lds_DailyActivity_report, lds_DailyAdjust
Long          llRowAdjust, ll_oldqty, ll_newqty, ll_FindAdj, e, ll_ext_rowcount
String	     ls_newinv, ls_Oinvtype,  ls_old_invtype, ls_new_invtype, lsLocalFromDate, lsLocalToDate, lsFindAdj
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
Long 		ll_find
String		ls_whcode, ls_sku, ls_supp, ls_Invtype, ls_cust, lsFileNamePath, ls_PONo, ls_ForecastGrp
Long			ll_eBalance, ll_sBalance, ll_receipts, ll_shipments, ll_adjust, ll_cbalance
Long			 ll_prev_ebalance, ll_prev_receipts, ll_prev_shipments, ll_prev_adjust, ll_req_qty_ib, ll_req_qty_ob

String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7

DEcimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtToday, ldtLocalFromDate, ldtLocalToDate

//jxlim Report contains info from previous date time to today run time, didn't use the asparmstring (&from&,&to&) because we do not want to get the default calculaton that is minus 2 days
ldtToday = DateTime(today(),Now())

ldtLocalFromDate = datetime(relativeDate(today(), -1), time('00:00:00')) /*relative based on today*/
ldtLocalToDate = datetime(relativeDate(today(),  - 1 ),time('23:59:59')) /*relative based on today*/
	
lsLocalFromDate= String(ldtLocalFromDate)
lsLocalToDate= String(ldtLocalToDate)

//jxlim for testing
//lsLocalFromDate= '12/01/2010 00:00:00'
//lsLocalToDate=  '12/01/2010 23:59:59'

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
//to be exported
lds_DailyActivity_ext = Create Datastore
lds_DailyActivity_ext.Dataobject = 'd_comcast_daily_activity_ext'
lirc = lds_DailyActivity_ext.SetTransobject(sqlca)

//Row data
lds_DailyActivity_report = Create Datastore
lds_DailyActivity_report.Dataobject = 'd_comcast_daily_activity_report'       /* at the wh/SKU/Inv Type level */
lirc = lds_DailyActivity_report.SetTransobject(sqlca)

// Inventory type adjusment
lds_DailyAdjust = Create Datastore
lds_DailyAdjust.Dataobject = 'd_comcast_daily_adjustment'       /* at the wh/SKU/Inv Type level, Inventory Adjustment */
lirc = lds_DailyAdjust.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST Daily Activity!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Comcast Daily Activity Data
lsLogout = 'Retrieving Comcast Daily Activity Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
llRowCount = lds_DailyActivity_report.Retrieve(lsLocalFromDate, lsLocalToDate) 

lsLogOut = 'Processing Comcast Daily Activity Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Inventory adjustment
llRowAdjust = lds_DailyAdjust.Retrieve(lsLocalFromDate, lsLocalToDate) 

For llRowPos = 1 to llRowCount
	  ls_whcode 	     	= lds_DailyActivity_report.GetItemString(llRowPos,'Wh_code') 
	  ls_sku			     = lds_DailyActivity_report.GetItemString(llRowPos,'Sku') 
	  ls_supp				= lds_DailyActivity_report.GetItemString(llRowPos,'Supp_Code') 
	  ls_ForecastGrp	= uf_get_forecast_group(ls_supp, ls_sku)
	  ls_invtype 	     	= lds_DailyActivity_report.GetItemString(llRowPos,'Inv_Type')	  
	  //ls_PONo		     = lds_DailyActivity_report.GetItemString(llRowPos,'PO_No')
	  ls_Oinvtype 	     = lds_DailyActivity_report.GetItemString(llRowPos,'OInv_Type')
	//  ls_cust			= lds_DailyActivity_report.GetItemString(llRowPos,'Cust_Code') 
	  ll_req_qty_ib    	= lds_DailyActivity_report.GetItemNumber(llRowPos,'req_qty_ib')
	  ll_req_qty_ob    	= lds_DailyActivity_report.GetItemNumber(llRowPos,'req_qty_ob')
	  
	  /*******************This Section is for existing record*****************************/
	
//		lsFind = "upper(Warehouse) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(Inv_Type) = '" + Upper( ls_invtype ) + " '  and Upper(PO_No) = '"	 + Upper(ls_PONo) + "'"
		lsFind = "upper(Warehouse) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(Inv_Type) = '" + Upper( ls_invtype ) + "'"	
		ll_Find = lds_DailyActivity_ext.Find(lsFind, 1, lds_DailyActivity_ext.Rowcount())				
		If ll_Find > 0 Then
			//If exisiting record bring in the value from previous row
			
			//  ls_cust			= lds_DailyActivity_report.GetItemString(llRowPos,'Cust_Code') 
			//New booking IB
			If	 ll_req_qty_ib > 0 Then
				lds_DailyActivity_ext.SetItem(ll_Find , "req_qty_ib", ll_req_qty_ib)	//Set value to the report IB
			End If
			//New booking Outbound
			If	 ll_req_qty_ob > 0 Then
				 lds_DailyActivity_ext.SetItem(ll_Find , "req_qty_ob", ll_req_qty_ob)	//Set value to the report OB
			End If
			
					//Begining Balance
					     ll_sbalance  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'starting_balance')	//value from previous row					
						
					//Ending Balance
					     ll_prev_ebalance  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'ending_balance')	//value from previous row
						ll_ebalance = lds_DailyActivity_report.GetItemNumber(llRowPos, 'ending_balance')	//current content ending balance
						ll_ebalance += ll_prev_ebalance
					
					//Receipts
						ll_prev_receipts  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Receipts' )		//value from previous row
						ll_receipts 	      = lds_DailyActivity_report.GetItemNumber(llRowPos, 'Receipts' )	//current
						ll_receipts 	    += ll_prev_receipts		
						lds_DailyActivity_ext.SetItem(ll_Find , "Receipts", ll_receipts)		//Set value to the report
				
						//shipments		
						ll_prev_shipments   = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Shipments')	//value from previous row
						ll_shipments 	 	  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Shipments')	//current		
						ll_shipments 	 	+= ll_prev_shipments
						lds_DailyActivity_ext.SetItem(ll_Find , "Shipments", ll_shipments)  //Set value to the report		
	
						 //Inventory Adjustment
						 ll_prev_adjust  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Adjust')	//value from previous row
						 ll_adjust 		    = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')	//current		
						 ll_adjust 		 +=  ll_prev_adjust 
						 
						 If  IsNull(ll_adjust) Then
							ll_adjust = 0
						End If
						 
						 If  ll_adjust <> 0 Then							
							lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	  
						Else	   //If net adjust = 0 then find the approriate qty for associate inv type
									//	Adjustment, Find if there is an inventory type change
										If   llRowAdjust > 0 Then											
											//Find the new quantity for new inventoryt type.  If adjust new inventory type = inventory type from row report then get the new quantity											
											lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and Upper(Inventory_Type) = '" + Upper(ls_invType) + "'"	
											ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
											If ll_FindAdj > 0 Then										
													ll_newqty  = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Quantity')	
													If 	ll_newqty <> 0 Then
														ll_adjust = +(ll_newqty)
														lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	
													End if
											End IF
											
											//Substruc old qty  //when adjustment old invtype = report new invtype substract oldqty
											//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and upper(Supp_Code) = '" + upper(ls_supp) +  "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
											lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
											ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, lds_DailyAdjust.Rowcount())				
											If ll_FindAdj > 0 Then
												ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
												If 	ll_oldqty <> 0 Then
														ll_adjust = -(ll_oldqty)
														lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	
												End if
											End If		
													
										End If   //End of Adjustment for inv-type change								
							End If								
							//End of Adjustment
							
		Else
			/*************************This Section is for new record ***********************************************/
			  //New row, SetItem to external dw			
			  ll_ebalance = 0
			  ll_sbalance = 0
			  llNewRow = lds_DailyActivity_ext.insertRow(0)		
				
				lds_DailyActivity_ext.SetItem(llNewRow, "Warehouse", ls_whCode)
				lds_DailyActivity_ext.SetItem(llNewRow, "Forecast_Group", ls_ForecastGrp)
				lds_DailyActivity_ext.SetItem(llNewRow, "Sku", ls_sku)
				lds_DailyActivity_ext.SetItem(llNewRow, "Supp_Code", ls_supp)
				lds_DailyActivity_ext.SetItem(llNewRow, "Inv_Type", ls_invType)				
				//lds_DailyActivity_ext.SetItem(llNewRow, "PO_No", ls_PONo)			/* GWM 6/7/2011 Add Attributes 7/14/2011 And take it out*/
				lds_DailyActivity_ext.SetItem(llNewRow, "req_qty_ib", ll_req_qty_ib)			
				lds_DailyActivity_ext.SetItem(llNewRow, "req_qty_ob", ll_req_qty_ob)			
				
				//Ending Balance  from content
				ll_ebalance  = lds_DailyActivity_report.GetItemNumber(llRowPos,'ending_balance')
				lds_DailyActivity_ext.SetItem(llNewRow, "ending_balance",  ll_ebalance)
				//Receipts
				 ll_receipts 	     = lds_DailyActivity_report.GetItemNumber(llRowPos,'Receipts')	
				 lds_DailyActivity_ext.SetItem(llNewRow, "Receipts", ll_receipts)		
				 //Shipments 
				 ll_shipments 	= lds_DailyActivity_report.GetItemNumber(llRowPos,'Shipments')				
				 lds_DailyActivity_ext.SetItem(llNewRow, "Shipments", ll_shipments)		
						 //Inventory Adjustment
						 ll_adjust  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')		
						 
						  If  IsNull(ll_adjust) Then
							ll_adjust = 0							
						End If
					
						 If  ll_adjust <> 0  Then
							ll_adjust  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')		
							//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
						Else	
								//	Adjustment, Find if there is an inventory type change
									If   llRowAdjust > 0 Then
										//Add new qty
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and Upper(Inventory_Type) = '" + Upper(ls_invType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then										
												ll_newqty  = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Quantity')	
												If 	ll_newqty <> 0 Then
													ll_adjust = +(ll_newqty)
												//	lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
												End if
										End IF
										
										//Substruc old qty
										//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then
											ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
											If 	ll_oldqty <> 0 Then
													ll_adjust = -(ll_oldqty)
													//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
											End if
										End If		
										
										//Substruc old qty
										//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_OinvType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then
											ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
											If 	ll_oldqty <> 0 Then
													ll_adjust = -(ll_oldqty)
													//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
											End if
										End If							
									
									End If								
						End If   
						lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
						//End of Adjustment
End If
Next

///////////////after////////////////////////////////////////////////////////////
//report on external dw
ll_ext_rowcount = lds_DailyActivity_ext.Rowcount()

lsLogOut = String(ll_ext_rowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//forming a report into external dw
For e = 1 to ll_ext_rowcount				
		 ll_receipts 		= lds_DailyActivity_ext.GetItemNumber(e, 'receipts')
		 ll_shipments 	= lds_DailyActivity_ext.GetItemNumber(e, 'shipments')		
		 ll_adjust  			= lds_DailyActivity_ext.GetItemNumber(e, 'adjust')						
		 ll_ebalance 		= lds_DailyActivity_ext.GetItemNumber(e, 'ending_balance')		 
		 If IsNull(ll_ebalance) Then
			ll_ebalance = 0
		End if
		
		 ll_sbalance = (ll_ebalance + ll_shipments -  ll_receipts - ll_adjust)
		 lds_DailyActivity_ext.SetItem(e, "Starting_Balance", ll_sBalance)			 
		
Next

lsFileName = 'Comcast_DAR' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName

lds_dailyActivity_ext.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the COMCAST  Daily Activity Report */
gu_nvo_process_files.uf_send_email("COMCAST", asEmail, "Comcast DAR  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the COMCAST Daily Activity Report From: " +  lsLocalFromDate  +  " To: " +  lsLocalToDate +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

Return 0
end function

public function integer uf_process_dar_shipib_report (string asinifile, string asemail);//Jxlim 11/29/2010
//Process the COMCAST Daily Activity Report
//uf_process_dar_shipib_report string asinifile, asemail return Integer


Datastore	lds_DarShipIB	
Long			llRowCount
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsFileNamePath, lsLocalFromDate, lsLocalToDate

//DEcimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtToday, ldtLocalFromDate, ldtLocalToDate

//jxlim Report contains info from previous date time to today run time, didn't use the asparmstring (&from&,&to&) because we do not want to get the default calculaton that is minus 2 days
ldtToday = DateTime(today(),Now())

ldtLocalFromDate = datetime(relativeDate(today(), -1), time('00:00:00')) /*relative based on today*/
ldtLocalToDate = datetime(relativeDate(today(),  - 1 ),time('23:59:59')) /*relative based on today*/
	
lsLocalFromDate= String(ldtLocalFromDate)
lsLocalToDate= String(ldtLocalToDate)

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
//DAR Shipment tInbound
lds_DarShipIB = Create Datastore
lds_DarShipIB.Dataobject = 'd_comcast_dar_shipment_ib_rpt'
lirc = lds_DarShipIB.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST DAR Shipment InBound Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Comcast DAR Shipment IO
lsLogout = 'Retrieving Comcast DAR Shipment InBound Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
llRowcount =  lds_DarShipIb.Retrieve(lsLocalFromDate, lsLocalToDate) 

lsLogOut = 'Processing Comcast DAR Shipment InBound Report...'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = String(llRowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'Comcast_DAR_ShipIB' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName

lds_darshipib.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the COMCAST  DAR Shipment InBound Report */
gu_nvo_process_files.uf_send_email("COMCAST", asEmail, "Comcast DAR Shipment InBound  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the COMCAST DAR Shipment Inbound Report From: " +  lsLocalFromDate  +  " To: " +  lsLocalToDate +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

Return 0
end function

public function integer uf_process_dar_shipob_report (string asinifile, string asemail);//Jxlim 11/29/2010
//Process the COMCAST Daily Activity Report
//uf_process_dar_shipib_report string asinifile, asemail return Integer


Datastore	lds_DarShipOB	
Long			llRowCount
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsFileNamePath, lsLocalFromDate, lsLocalToDate

//DEcimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtToday, ldtLocalFromDate, ldtLocalToDate

//jxlim Report contains info from previous date time to today run time, didn't use the asparmstring (&from&,&to&) because we do not want to get the default calculaton that is minus 2 days
ldtToday = DateTime(today(),Now())

ldtLocalFromDate = datetime(relativeDate(today(), -1), time('00:00:00')) /*relative based on today*/
ldtLocalToDate = datetime(relativeDate(today(),  - 1 ),time('23:59:59')) /*relative based on today*/
	
lsLocalFromDate= String(ldtLocalFromDate)
lsLocalToDate= String(ldtLocalToDate)

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
//DAR Shipment tInbound
lds_DarShipOB = Create Datastore
lds_DarShipOB.Dataobject = 'd_comcast_dar_shipment_ob_rpt'
lirc = lds_DarShipOB.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST DAR Shipment Outbount Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve main/row report
llRowcount =  lds_DarShipob.Retrieve(lsLocalFromDate, lsLocalToDate) 

//Retrive the Comcast DAR Shipment IO
lsLogout = 'Retrieving Comcast DAR Shipment OutBound Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

lsLogOut = 'Processing Comcast DAR Shipment OutBound Report...'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsLogOut = String(llRowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'Comcast_DAR_ShipOB' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName

lds_darshipob.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the COMCAST  DAR Shipment OutBound Report */
gu_nvo_process_files.uf_send_email("COMCAST", asEmail, "Comcast DAR Shipment OutBound  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the COMCAST DAR Shipment OutBound Report From: " +  lsLocalFromDate  +  " To: " +  lsLocalToDate +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

Return 0
end function

public function integer uf_process_eis_results (string aspath, string asproject);//Jxlim 11/30/2010   /*Comcast EIS Results - SIMS to EIS Error visibility*/	
//uf_process_EIS_Results(aspath, asproject) Return Integer clone from uf_load_ith
String		lsLogOut, lsTransID, lsSite, lsWarehouse, lsTranNbr, lsDetailType, lsResult, lsResult_msg, lsSerialNo,lsStatus, lsFromSite, lsRefNbr
Long			llRC, llRowpos, llRowCount, llNewRow, llCount,llRefCount
Integer		liRC
Boolean	lbError, lbMenloTran
DateTime	ldtToday
String		lsTranTotal, lsTranOK, lsTranExc
String     lsSiteId, lsTranType /*BCR - 03162011 - Add Site_Id and Tran_Type fields and extract them from Ref_Nbr*/ 

//The EIS Results records are loaded here and then will be processed as a scheduled function so we can process them all together. Each transaction is a seperate file but we may need to combine them.

ldtToday = DateTIme(Today(),Now())

If not isvalid(iu_DS) Then
	iu_DS = Create datastore
End IF

iu_DS.dataobject = 'd_import_generic_csv'
iu_DS.Reset()

If not isvalid(idsEISResults) Then
	idsEISResults = Create Datastore
	idsEISResults.dataobject = 'd_comcast_eis_results' 
	idsEISResults.SetTransObject(SQLCA)
End If

idsEISResults.Reset()

//Open and read the File In - Importing Tab  file
lsLogOut = '      - Opening File for Comcast EIS ResultsProcessing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llRC = iu_DS.ImportFile(text!,asPath) 

If llRC < 0 Then
	lsLogOut = "-       ***Unable to import Comcast EIS Result file: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1 
End If

//Process each row of the File
llRowCount = iu_DS.RowCount()

For llRowPos = 1 to llRowCount
	
	If llRowPos = 1 Then
		
		//For first row (Header)
		lsRefNbr = Trim(iu_DS.GetITemString(llRowPos,'column1'))
		lsTranNbr = Trim(iu_DS.GetITemString(llRowPos,'column2'))				
		lsTranTotal = Trim(iu_DS.GetITemString(llRowPos,'column3'))
		lsTranOk = Trim(iu_DS.GetITemString(llRowPos,'column4'))
		lsTranExc = Trim(iu_DS.GetITemString(llRowPos,'column5'))
		lsDetailType = 'H'
		//lsResult_msg = "Total Transactions = " +  lsTranTotal + ", successful = " + lsTranOk  + ", Exception = " + lsTranExc 
		lsResult_msg = ""
		lsResult = 'HDR'
		
	Else
		
		//not header	
		lsTranNbr = Trim(iu_DS.GetITemString(llRowPos,'column1'))
		lsRefNbr = Trim(iu_DS.GetITemString(llRowPos,'column2'))
		lsDetailType = Trim(iu_DS.GetITemString(llRowPos,'column3'))
		lsResult = Trim(iu_DS.GetITemString(llRowPos,'column4'))
		lsResult_msg = Trim(iu_DS.GetITemString(llRowPos,'column5'))
		lsSerialNo = Trim(iu_DS.GetITemString(llRowPos,'column6'))
		
	End IF
		
	llNewRow = idsEISResults.InsertRow(0)
	
	// 1/11 - PConkl - If header row, write out the totals
	If llRowPos = 1 Then
		
		idsEISResults.SetITem(llNewRow,'Total_Tran_Cnt',Long(lsTranTotal))
		idsEISResults.SetITem(llNewRow,'Success_Tran_Cnt',Long(lsTranOk))
		idsEISResults.SetITem(llNewRow,'Fail_Tran_Cnt',Long(lsTranExc))
		
	Else
		
		idsEISResults.SetITem(llNewRow,'Total_Tran_Cnt',0)
		idsEISResults.SetITem(llNewRow,'Success_Tran_Cnt',0)
		idsEISResults.SetITem(llNewRow,'Fail_Tran_Cnt',0)
		
	End If
	
	//////////////////
	/*BCR - 03162011 - Parse new Ref_Nbr data out into 3 different columns on dw and in table*/
	/*GXMOR - 05/17/2013 - Correct lsSiteId Mid statement syntax */
	If Pos(lsRefNbr,'_') > 0 Then
		lsTranType   = Left(lsRefNbr,(pos(lsRefNbr,'_') - 1))
		lsSiteId        = Mid(lsRefNbr,(pos(lsRefNbr,'_') + 1),(LastPos(lsRefNbr,'_') - pos(lsRefNbr,'_') - 1))
		lsRefNbr      = Mid(lsRefNbr,(LastPos(lsRefNbr,'_') + 1))
	END IF
	/////////////////////////////////
	
	idsEISResults.SetITem(llNewRow,'Tran_nbr',lsTranNbr)
	idsEISResults.SetITem(llNewRow,'Ref_nbr',lsRefNbr)
	/*BCR - 03162011 - Parse new Ref_Nbr data out into 3 different columns on dw and in table*/
	idsEISResults.SetITem(llNewRow,'Site_Id',lsSiteId)
	idsEISResults.SetITem(llNewRow,'Tran_Type',lsTranType)
	//
	idsEISResults.SetITem(llNewRow,'Detail_type',lsDetailType)
	idsEISResults.SetITem(llNewRow,'Result_cd',lsResult)
	idsEISResults.SetITem(llNewRow,'Result_Msg',lsresult_msg)
	idsEISResults.SetITem(llNewRow,'Serial_No',lsSerialNo)
	idsEISResults.SetITem(llNewRow,'Last_Update',ldtToday)		

Next

//Save Changes
liRC = idsEISResults.Update()

If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut =  "       ***System Error!  Unable to Save new EIS Results Records to database "
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	Return -1
End If

//Process any complete Transactions (we dont if the header or detail will load first
//uf_process_ith_itd()

If lbError or liRC < 0 Then
	Return - 1
Else
	Return 50 /* RC=50 will delete the file instead of archiving */
End IF

end function

public function integer uf_eis_monthly_ftp_file (string asinifile, string asbhfile);// If today is the last day of the month then this function will call the uf_eis_weekly_ftp_file 
// and generated the end-of-month EIS inventory snapshot to be FTPed to Mintek
DateTime	ldtToday
Date			ld_newdate, ld_previousmonthlastday
Integer 		li_thisday, li_lastday, li_Month, li_Year
String	lsLogout

ldtToday = DateTime(today(),Now())
li_month = Month(Date(ldtToday))
li_year = year(Date(ldtToday))

IF li_month < 12 THEN
   li_month ++
ELSE
   li_month = 1
   li_year ++
END IF

// build a new date
ld_newdate = date(li_year,li_month,1)
// extract the last day of the previous month
ld_previousmonthlastday = RelativeDate(ld_newdate, -1)

// Get day of the month
li_thisday = Day(Date(ldtToday))
li_lastday = Day(Date(ld_previousmonthlastday))

// Send a message out to show dates
lsLogOut = '      - ' +  String(ldtToday,'mm/dd/yyyy hh:mm:ss') + ' Processing function: Comcast EIS Monthly FTP File....' +&
				'with ThisDay=' + string(li_thisday) + ' and LastDay=' + string(li_lastday) + '.'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

// If it is the last day of the month then do the report
if li_thisday = li_lastday then
	uf_eis_weekly_ftp_file(asinifile,asbhfile)
end if

return 0

end function

public function integer uf_process_lms_so (string aspath, string asproject);// Cloned from Phoenix Brands for Comcast
// Process Sales Order files for Comcast
Datastore	ldsDOHeader, ldsDODetail, lu_ds, ldsDONotes
				
String		lsLogout,lsRecData,lsTemp,	lswarehouse, lsErrText,	 lsSKU,	lsRecType,	&
				lsSoldToAddr1, lsSoldToADdr2, lsSoldToADdr3,  lsSoldToAddr4, lsSoldToStreet,	&
				lsSoldToZip, lsSoldToCity, lsSoldToState, lsSoldToCountry, lsSoldToTel, lsDate, ls_invoice_no, ls_Note_Type, &
				ls_search,lsNotes,ls_temp,lsSupplier

Integer		liFileNo,liRC, li_line_item_no
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo,  llOwner, llNewAddressRow, llNewNotesRow, liFind
				
Decimal		ldQty, ldPrice
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbSoldToAddress 
			

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Comcast Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
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
		
	//Process header, Detail, or header/line notes */
	lsRecType = Upper(Mid(lsRecData,7,2))
	
	Choose Case lsRecType
			
		//HEADER RECORD
		Case 'OM' /* Header */
									
			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
		//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			ldsDOHeader.SetITem(llNewRow,'wh_code',uf_get_SIMS_WhCode( Trim(Mid(lsRecdata,10,6)) )) /*WarehouseCode*/
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
						
			ldsDOHeader.SetItem(llNewRow,'User_field16',Trim(Mid(lsRecData,2370,30))) /*Carrier Pro # */
			
			/* 01/18 - GXMOR - removed Delivery Appt Ref Code */
			//ldsDOHeader.SetItem(llNewRow,'User_field8',Trim(Mid(lsRecData,2400,30))) /*Delivery Appt Ref Code*/
			
			ldsDOHeader.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecData,30,30))) /*Order Number*/
						
			ldsDOHeader.SetItem(llNewRow,'User_field12',Trim(Mid(lsRecData,60,4))) /*Order Type - UF 12 - Order # + Plus order Type = Unique order # for LMS*/
			ldsDOHeader.SetItem(llNewRow,'Carrier',Trim(Mid(lsRecData,92,15))) 
			ldsDOHeader.SetItem(llNewRow,'User_field13',Trim(Mid(lsRecData,129,12))) /*End Leg Carrier for MAster Load (Group Code 2)*/
			ldsDOHeader.SetItem(llNewRow,'Priority',Trim(Mid(lsRecData,211,3))) /*Priority*/
			ldsDOHeader.SetItem(llNewRow,'User_field14',Trim(Mid(lsRecData,224,15))) /*LMS SHipment*/
			ldsDOHeader.SetItem(llNewRow,'User_field15',Trim(Mid(lsRecData,239,15))) /*LMS Master SHipment*/
			
			lsTemp = Trim(Mid(lsRecData,24,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			
			/*Schedule Date - reformat to mm/dd/yyyy*/
			lsTemp = Trim(Mid(lsRecData,288,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			ldsDOHeader.SetItem(llNewRow,'Schedule_Date',lsDate) 
			
			/*Request Date*/
			lsTemp = Trim(Mid(lsRecData,296,8))
			lsDate = Mid(lsTemp,5,2) + '/' + Right(lsTEmp,2) + '/' + Left(lsTemp,4)
			ldsDOHeader.SetItem(llNewRow,'Request_Date',lsDate) 
			
			ldsDOHeader.SetItem(llNewRow,'Order_no',Trim(Mid(lsRecData,773,30))) /*Cust Order No*/
			
			//MEA Only set the customer data if not an order type of 'Z'
			
			IF ldsDOHeader.GetItemString(llNewRow,'order_Type') <> 'Z' THEN 
			
				ldsDOHeader.SetItem(llNewRow,'Cust_Code',Trim(Mid(lsRecData,803,15))) /*Cust Code*/		
				
				//cust code may not be present...
				If isnull(ldsdoheader.GetITemString(llNewRow,'Cust_Code')) or ldsdoheader.GetITemString(llNewRow,'Cust_Code') = '' Then
					ldsDOHeader.SetItem(llNewRow,'Cust_Code','N/A')
				End If
				
			END IF	
				
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',Trim(Mid(lsRecData,818,40))) /*Cust Name*/
			ldsDOHeader.SetItem(llNewRow,'Address_1',Trim(Mid(lsRecData,978,40))) /*Ship to Addr 1*/
			ldsDOHeader.SetItem(llNewRow,'Address_2',Trim(Mid(lsRecData,1018,40))) /*Ship to Addr 2*/
			ldsDOHeader.SetItem(llNewRow,'Address_3',Trim(Mid(lsRecData,1058,40))) /*Ship to Addr 3*/
			ldsDOHeader.SetItem(llNewRow,'City',Trim(Mid(lsRecData,1098,35))) /*Ship to City*/
			ldsDOHeader.SetItem(llNewRow,'State',Trim(Mid(lsRecData,1168,2))) /*Ship to State 1*/
			ldsDOHeader.SetItem(llNewRow,'Zip',Trim(Mid(lsRecData,1170,10))) /*Ship to Zip*/
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(Mid(lsRecData,1180,20))) /*Ship to country*/
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(Mid(lsRecData,1200,20))) /*Ship to Tel*/
		//	ldsDOHeader.SetItem(llNewRow,'Fax',Trim(Mid(lsRecData,1220,20))) /*Ship to Fax*/
		
		// DETAIL RECORD
		Case 'OD' /*Detail */
									
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
		
		//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
		//	ldsDODetail.SetITem(llNewRow,'Action_cd', 'A') /*always Add*/
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
		//	ldsDODetail.SetItem(llNewRow,'Inventory_type','N') /*normal inventory*/
				
		//From File
			ls_temp = Trim(Mid(lsRecdata,30,30))
			ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(Mid(lsRecdata,30,30))) 

			//TAM 2007/05/09 Use Cust Line Number from position 251 
			If Trim(Mid(lsRecdata,251,6)) = '' or IsNull(Trim(Mid(lsRecdata,251,6)))  Then
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
			Else
				ldsDODetail.SetItem(llNewRow,'line_item_no',Long(Trim(Mid(lsRecdata,251,6))))
			End If
			
			//SKU
			lsSKU = Left(Mid(lsRecdata,70,20),Pos(Mid(lsRecdata,70,20),"^")-1)
			ldsDODetail.SetItem(llNewRow,'SKU',lsSKU) 
			
			//Supplier Code - May contain only partcial supp_code. Call ItemMaster
			lsSupplier = Trim(Right(Mid(lsRecdata,70,20),20 - Pos(Mid(lsRecdata,70,20),"^")))
			lsSupplier = uf_get_supplier(lsSupplier, lsSKU)
			ldsDODetail.SetITem(llNewRow,'supp_code',lsSupplier)
			
			//ldQty = Dec(Trim(Mid(lsRecdata,203,12)))
			ldsDODetail.SetItem(llNewRow,'quantity',Trim(Mid(lsRecdata,203,12)))
			
			ldsDODetail.SetItem(llNewRow,'uom',Trim(Mid(lsRecdata,215,6)))
			ldsDODetail.SetItem(llNewRow,'alternate_sku',Trim(Mid(lsRecdata,221,20)))
			/* 01/18 - GXMOR - Removed customer order for user_field1 */
			//ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(Mid(lsRecdata,241,10))) /* customer Order */
			
			ldQty = Dec(Trim(Mid(lsRecdata,270,8))) / 100
			ldsDODetail.SetItem(llNewRow,'price',Trim(Mid(lsRecdata,270,8)))		
			
			/* 01/18 - GXMOR - Removed UPCr for user_field2 */
			//ldsDODetail.SetItem(llNewRow,'User_Field2',Trim(Mid(lsRecdata,328,15))) /* UPC */
										
		Case  'DC' /* Header/Line Notes*/
			//This module is added by GWM 06/01/2011

			llNewNotesRow = ldsDONotes.InsertRow(0)
			
			//Defaults
			ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			//From File
			ldsDONotes.SetItem(llNewNotesRow,'note_type',lsRecType) /* Note Type */
			ldsDONotes.SetItem(llNewNotesRow,'invoice_no',Trim(Mid(lsRecdata,30,30)))
			
			ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',Long(Trim(Mid(lsRecdata,70,6))))
			ldsDONotes.SetItem(llNewNotesRow,'line_item_no',Long(Trim(Mid(lsRecdata,64,6))))
				
			ls_Note_Type = Upper(Trim(Mid(lsRecdata,76,6)))
				
			ls_invoice_no = Trim(Mid(lsRecdata,30,30))
			li_line_item_no = integer(Trim(Mid(lsRecdata,64,6)))

			liFind = ldsDODetail.Find("line_item_no="+string(li_line_item_no) + " and invoice_no = '" + ls_invoice_no +"'",1, ldsDODetail.RowCount())
			
				CHOOSE CASE ls_Note_Type
					CASE "YNNNNN"
						
						ls_temp = Trim(Mid(lsRecdata,82,40))
						ldsDONotes.SetItem(llNewNotesRow,'note_text',ls_temp)
						// Populate Detail PO No with Attributes
						ldsDODetail.SetItem(liFind, 'pick_po_no' ,ls_temp)
						
						//ldsDODetail.object.po_no[liFind] = ls_temp

					CASE ELSE
						//NOTHING
						//ldsDONotes.SetItem(llNewNotesRow,'note_text',Trim(Mid(lsRecdata,86,40)))

				END CHOOSE

		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Note Type: '" + ls_Note_Type + "'. Record will not be processed.")
			lbError = True
			Continue /*Next Record */
			
	End Choose /*Header or Detail */
	
Next /*file record */

//Save Changes
liRC = ldsDOHeader.Update()

If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If

If liRC = 1 Then
	liRC = ldsDONotes.Update()
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

public function string uf_get_supplier (string assupplier, string assku);String lsSuppCode, lsTemp, lsSQL, lsErrText

lsTemp = asSupplier + "%"

Select supp_code into :lsSuppCode 
From Item_Master 
Where SKU = :asSKU
and supp_code like (:lsTemp);

/* GXMOR - If supplier is not with SKU use supplier from Item Master */
If lsSuppCode = '' then
	Select supp_code into :lsSuppCode
	From Item_Master
	Where SKU = :asSKU;

	if lsSuppCode = '' then		
		lsSuppCode = asSupplier
	end if
	
end if

return lsSuppCode 

end function

public function string uf_get_sims_whcode (string aswhcode);String RetValue

RetValue = ""

/*
--Select wh_code into :RetValue
--From warehouse
--Where wh_code like ("%aswhcode%");
*/

/* Hard-coded warehouse codes */
CHOOSE CASE asWhCode
	case 'AURORA' 
		RetValue = 'COM-AURORA'
	case 'ATLNTA' 
		RetValue = 'COM-ATLNTA'
	case 'ATL' 									/* GXMOR 4/12/2013 New LMS WhCode to convert for Atlanta */
		RetValue = 'COM-ATLNTA'
	case 'FRMNT' 
		RetValue = 'COM-FREMNT'
	case 'FREMNT' 
		RetValue = 'COM-FREMNT'
	case 'MONROE' 
		RetValue = 'COM-MONROE'
	case 'MON' 
		RetValue = 'COM-MONROE'
	case 'DIRECT' 
		RetValue = 'COM-DIRECT'
	case LEFT('NASH',4) 
		RetValue = 'COM-NASH  '
	case else		/* Invalid wh code */
		RetValue = asWhCode
END CHOOSE


return RetValue

end function

public function integer uf_process_dar_all_wh (string asinifile, string asemail);//GXMOR 03/20/2011 Cloned from uf_process_dailyactivity_report function
//Process the COMCAST Daily Activity Report to include all Menlo warehouses (Corp, SIK, & Direct)
//uf_process_dar_all_wh string asinifile, asemail, asparmstring return Integer


Datastore	lds_DailyActivity_ext, 	lds_DailyActivity_report, lds_DailyAdjust
Long          	llRowAdjust, ll_oldqty, ll_newqty, ll_FindAdj, e, ll_ext_rowcount
String	    		ls_newinv, ls_Oinvtype,  ls_old_invtype, ls_new_invtype, lsLocalFromDate, lsLocalToDate, lsFindAdj
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
Long 			ll_find
String			ls_whcode, ls_sku, ls_supp, ls_Invtype, ls_cust, lsFileNamePath, ls_PONo, ls_ForecastGrp
Long			ll_eBalance, ll_sBalance, ll_receipts, ll_shipments, ll_adjust, ll_cbalance
Long			ll_prev_ebalance, ll_prev_receipts, ll_prev_shipments, ll_prev_adjust, ll_req_qty_ib, ll_req_qty_ob

String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7

DEcimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtToday, ldtLocalFromDate, ldtLocalToDate

//jxlim Report contains info from previous date time to today run time, didn't use the asparmstring (&from&,&to&) because we do not want to get the default calculaton that is minus 2 days
ldtToday = DateTime(today(),Now())

ldtLocalFromDate = datetime(relativeDate(today(), -1), time('00:00:00')) /*relative based on today*/
ldtLocalToDate = datetime(relativeDate(today(),  - 1 ),time('23:59:59')) /*relative based on today*/
	
lsLocalFromDate= String(ldtLocalFromDate)
lsLocalToDate= String(ldtLocalToDate)

//GXMOR for testing
//lsLocalFromDate= '03/08/2011 00:00:00'
//lsLocalToDate=  '03/08/2011 23:59:59'

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
//to be exported
lds_DailyActivity_ext = Create Datastore
lds_DailyActivity_ext.Dataobject = 'd_comcast_daily_activity_ext'
lirc = lds_DailyActivity_ext.SetTransobject(sqlca)

//Row data
lds_DailyActivity_report = Create Datastore
lds_DailyActivity_report.Dataobject = 'd_comcast_DAR_all_wh'       /* at the wh/SKU/Inv Type level */
lirc = lds_DailyActivity_report.SetTransobject(sqlca)

// Inventory type adjusment
lds_DailyAdjust = Create Datastore
lds_DailyAdjust.Dataobject = 'd_comcast_daily_adjustment'       /* at the wh/SKU/Inv Type level, Inventory Adjustment */
lirc = lds_DailyAdjust.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST DAR All Warehouses!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Comcast Daily Activity Data
lsLogout = 'Retrieving Comcast Daily Activity Report for all WH.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
llRowCount = lds_DailyActivity_report.Retrieve(lsLocalFromDate, lsLocalToDate) 

lsLogOut = 'Processing Comcast Daily Activity Report for all WH.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Inventory adjustment
llRowAdjust = lds_DailyAdjust.Retrieve(lsLocalFromDate, lsLocalToDate) 

For llRowPos = 1 to llRowCount
	  ls_whcode 	        = lds_DailyActivity_report.GetItemString(llRowPos,'Wh_code') 
	  ls_sku			   = lds_DailyActivity_report.GetItemString(llRowPos,'Sku') 
	  ls_supp			   = lds_DailyActivity_report.GetItemString(llRowPos,'Supp_Code') 		
	  ls_ForecastGrp  = uf_get_forecast_group(ls_supp, ls_sku)
	  ls_invtype 	        = lds_DailyActivity_report.GetItemString(llRowPos,'Inv_Type')
	 // ls_PONo		   = lds_DailyActivity_report.GetItemString(llRowPos,'PO_No')
	  ls_Oinvtype 	   = lds_DailyActivity_report.GetItemString(llRowPos,'OInv_Type')
	//  ls_cust			= lds_DailyActivity_report.GetItemString(llRowPos,'Cust_Code') 
	  ll_req_qty_ib     = lds_DailyActivity_report.GetItemNumber(llRowPos,'req_qty_ib')
	  ll_req_qty_ob    = lds_DailyActivity_report.GetItemNumber(llRowPos,'req_qty_ob')
	  
	  /*******************This Section is for existing record*****************************/
	
	//	lsFind = "upper(Warehouse) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(Inv_Type) = '" + Upper( ls_invtype ) + " '  and Upper(PO_No) = '"	 + Upper(ls_PONo) + "'"
		lsFind = "upper(Warehouse) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(Inv_Type) = '" + Upper( ls_invtype ) + "'"	
		ll_Find = lds_DailyActivity_ext.Find(lsFind, 1, lds_DailyActivity_ext.Rowcount())				
		If ll_Find > 0 Then
			//If exisiting record bring in the value from previous row
			
			//  ls_cust			= lds_DailyActivity_report.GetItemString(llRowPos,'Cust_Code') 
			//New booking IB
			If	 ll_req_qty_ib > 0 Then
				lds_DailyActivity_ext.SetItem(ll_Find , "req_qty_ib", ll_req_qty_ib)	//Set value to the report IB
			End If
			//New booking Outbound
			If	 ll_req_qty_ob > 0 Then
				 lds_DailyActivity_ext.SetItem(ll_Find , "req_qty_ob", ll_req_qty_ob)	//Set value to the report OB
			End If
			
					//Begining Balance
					     ll_sbalance  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'starting_balance')	//value from previous row					
						
					//Ending Balance
					     ll_prev_ebalance  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'ending_balance')	//value from previous row
						ll_ebalance = lds_DailyActivity_report.GetItemNumber(llRowPos, 'ending_balance')	//current content ending balance
						ll_ebalance += ll_prev_ebalance
					
					//Receipts
						ll_prev_receipts  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Receipts' )		//value from previous row
						ll_receipts 	      = lds_DailyActivity_report.GetItemNumber(llRowPos, 'Receipts' )	//current
						ll_receipts 	    += ll_prev_receipts		
						lds_DailyActivity_ext.SetItem(ll_Find , "Receipts", ll_receipts)		//Set value to the report
				
						//shipments		
						ll_prev_shipments   = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Shipments')	//value from previous row
						ll_shipments 	 	  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Shipments')	//current		
						ll_shipments 	 	+= ll_prev_shipments
						lds_DailyActivity_ext.SetItem(ll_Find , "Shipments", ll_shipments)  //Set value to the report		
	
						 //Inventory Adjustment
						 ll_prev_adjust  = lds_DailyActivity_ext.GetItemNumber(ll_Find, 'Adjust')	//value from previous row
						 ll_adjust 		    = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')	//current		
						 ll_adjust 		 +=  ll_prev_adjust 
						 
						 If  IsNull(ll_adjust) Then
							ll_adjust = 0
						End If
						 
						 If  ll_adjust <> 0 Then							
							lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	  
						Else	   //If net adjust = 0 then find the approriate qty for associate inv type
									//	Adjustment, Find if there is an inventory type change
										If   llRowAdjust > 0 Then											
											//Find the new quantity for new inventoryt type.  If adjust new inventory type = inventory type from row report then get the new quantity											
											lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and Upper(Inventory_Type) = '" + Upper(ls_invType) + "'"	
											ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
											If ll_FindAdj > 0 Then										
													ll_newqty  = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Quantity')	
													If 	ll_newqty <> 0 Then
														ll_adjust = +(ll_newqty)
														lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	
													End if
											End IF
											
											//Substruc old qty  //when adjustment old invtype = report new invtype substract oldqty
											//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and upper(Supp_Code) = '" + upper(ls_supp) +  "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
											lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku)  + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
											ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, lds_DailyAdjust.Rowcount())				
											If ll_FindAdj > 0 Then
												ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
												If 	ll_oldqty <> 0 Then
														ll_adjust = -(ll_oldqty)
														lds_DailyActivity_ext.SetItem(ll_Find, "Adjust", ll_adjust)	
												End if
											End If		
													
										End If   //End of Adjustment for inv-type change								
							End If								
							//End of Adjustment
							
		Else
			/*************************This Section is for new record ***********************************************/
			  //New row, SetItem to external dw			
			  ll_ebalance = 0
			  ll_sbalance = 0
			  llNewRow = lds_DailyActivity_ext.insertRow(0)		
				
				lds_DailyActivity_ext.SetItem(llNewRow, "Warehouse", ls_whCode)
				lds_DailyActivity_ext.SetItem(llNewRow, "Forecast_Group", ls_ForecastGrp)
				lds_DailyActivity_ext.SetItem(llNewRow, "Sku", ls_sku)
				lds_DailyActivity_ext.SetItem(llNewRow, "Supp_Code", ls_supp)
				lds_DailyActivity_ext.SetItem(llNewRow, "Inv_Type", ls_invType)				
				//lds_DailyActivity_ext.SetItem(llNewRow, "PO_No", ls_PONo)			/* GWM 6/7/2011 Add Attributes 7/14/2011 Take it out */
				lds_DailyActivity_ext.SetItem(llNewRow, "req_qty_ib", ll_req_qty_ib)			
				lds_DailyActivity_ext.SetItem(llNewRow, "req_qty_ob", ll_req_qty_ob)			
				
				//Ending Balance  from content
				ll_ebalance  = lds_DailyActivity_report.GetItemNumber(llRowPos,'ending_balance')
				lds_DailyActivity_ext.SetItem(llNewRow, "ending_balance",  ll_ebalance)
				//Receipts
				 ll_receipts 	     = lds_DailyActivity_report.GetItemNumber(llRowPos,'Receipts')	
				 lds_DailyActivity_ext.SetItem(llNewRow, "Receipts", ll_receipts)		
				 //Shipments 
				 ll_shipments 	= lds_DailyActivity_report.GetItemNumber(llRowPos,'Shipments')				
				 lds_DailyActivity_ext.SetItem(llNewRow, "Shipments", ll_shipments)		
						 //Inventory Adjustment
						 ll_adjust  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')		
						 
						  If  IsNull(ll_adjust) Then
							ll_adjust = 0							
						End If
					
						 If  ll_adjust <> 0  Then
							ll_adjust  = lds_DailyActivity_report.GetItemNumber(llRowPos,'Net_Adjust')		
							//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
						Else	
								//	Adjustment, Find if there is an inventory type change
									If   llRowAdjust > 0 Then
										//Add new qty
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and Upper(Inventory_Type) = '" + Upper(ls_invType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then										
												ll_newqty  = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Quantity')	
												If 	ll_newqty <> 0 Then
													ll_adjust = +(ll_newqty)
												//	lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
												End if
										End IF
										
										//Substruc old qty
										//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then
											ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
											If 	ll_oldqty <> 0 Then
													ll_adjust = -(ll_oldqty)
													//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
											End if
										End If		
										
										//Substruc old qty
										//lsFind = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and upper(Cust_Code) = '" + upper(ls_cust) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_invType) + "'"	
										lsFindAdj = "upper(Wh_code) = '" + upper(ls_whCode) +  "' and upper(SKU) = '" + upper(ls_sku) + "' and upper(Supp_Code) = '" + upper(ls_supp) + "' and Upper(old_Inventory_Type) = '" + Upper(ls_OinvType) + "'"	
										ll_FindAdj = lds_DailyAdjust.Find(lsFindAdj, 1, llRowAdjust)				
										If ll_FindAdj > 0 Then
											ll_oldqty 			   = lds_DailyAdjust.GetItemNumber(ll_FindAdj, 'Old_Quantity')		
											If 	ll_oldqty <> 0 Then
													ll_adjust = -(ll_oldqty)
													//lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
											End if
										End If							
									
									End If								
						End If   
						lds_DailyActivity_ext.SetItem(llNewRow, "Adjust", ll_adjust)	
						//End of Adjustment
End If
Next

///////////////after////////////////////////////////////////////////////////////
//report on external dw
ll_ext_rowcount = lds_DailyActivity_ext.Rowcount()

lsLogOut = String(ll_ext_rowcount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//forming a report into external dw
For e = 1 to ll_ext_rowcount				
		 ll_receipts 		= lds_DailyActivity_ext.GetItemNumber(e, 'receipts')
		 ll_shipments 	= lds_DailyActivity_ext.GetItemNumber(e, 'shipments')		
		 ll_adjust  			= lds_DailyActivity_ext.GetItemNumber(e, 'adjust')						
		 ll_ebalance 		= lds_DailyActivity_ext.GetItemNumber(e, 'ending_balance')		 
		 If IsNull(ll_ebalance) Then
			ll_ebalance = 0
		End if
		
		 ll_sbalance = (ll_ebalance + ll_shipments -  ll_receipts - ll_adjust)
		 lds_DailyActivity_ext.SetItem(e, "Starting_Balance", ll_sBalance)			 
		
Next

//Write file to \FlatFileOut staging area for FTP...
// 10/5/2011 - GWM - Added datetime to end of filename to save unique instances of report as request by OPS
lsFileName =  'DA_Comcast_Daily_Inventory_All_WH' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.csv'
lsFileNamePath = ProfileString(asInifile, 'Comcast-dar', "ftpfiledirout","") + '\' + lsFileName

lds_DailyActivity_ext.SaveAs ( lsFileNamePath, CSV!	, false )

Return 0

end function

public function string uf_get_forecast_group (string assupplier, string assku);String lsForecastGrp, lsTemp, lsSQL, lsErrText

lsTemp = asSupplier + "%"

Select user_field1 into :lsForecastGrp 
From Item_Master 
Where SKU = :asSKU
and supp_code like (:lsTemp);

if Isnull(lsForecastGrp) or lsForecastGrp = '' then		
	lsForecastGrp = "None"
end if

return lsForecastGrp

end function

public function integer uf_process_sum_inv_rpt (string asinifile, string asemail);//Process the COMCAST Daily Summary Inventory Report
//uf_process_sum_inv_rpt string asinifile, asemail return Integer

Datastore	lds_SumInv
Long			llRowCount
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsFileNamePath, lsLocalFromDate, lsLocalToDate

//Decimal	ldBatchSeq
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

DateTime	ldtToday, ldtLocalFromDate, ldtLocalToDate

//gwm Report contains info summary of inventory from overnight - same as Comcast Report #8 Inventory Summary in SIMS
ldtToday = DateTime(today(),Now())

ldtLocalFromDate = datetime(relativeDate(today(), -1), time('00:00:00')) /*relative based on today*/
ldtLocalToDate = datetime(relativeDate(today(),  - 1 ),time('23:59:59')) /*relative based on today*/
	
lsLocalFromDate= String(ldtLocalFromDate)
lsLocalToDate= String(ldtLocalToDate)

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
//DAR Shipment tInbound
lds_SumInv = Create Datastore
lds_SumInv.Dataobject = 'd_summary_inventory_rpt'
lirc = lds_SumInv.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: COMCAST Summary Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Comcast Summary Inventory Report
lsLogout = 'Retrieving Comcast Summary Inventory Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
//llRowCount = lds_SumInv.Retrieve() 
//BCR 20-MAR-2012: Modified datawindow by adding retrieval argument for Project, rather than the previous Comcast hardcode.
llRowCount = lds_SumInv.Retrieve('COMCAST') 
//

lsLogOut = 'Processing Comcast Summary Inventory.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

///////////////after////////////////////////////////////////////////////////////
//report on external dw

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'Comcast_Summary_Inventory_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
lsFileNamePath = ProfileString(asInifile, 'Comcast', "EIS-Recon-Directory","") + '\' + lsFileName

lds_SumInv.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the COMCAST Summary Inventory Report */
gu_nvo_process_files.uf_send_email("COMCAST", asEmail, "Comcast Summary Inventory  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the COMCAST Summary Inventory Report  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

return 0

end function

public function integer uf_process_ith_itd (string asinifile, string asemail);Datastore	ldsITH
String			lsSQl, presentation_str, lsErrText, dwsyntax_str, lsLogOut, lsWarehouse, lsModel, lsSKU, lsSUpplier, lsPallet, lsPalletSave, lsGroup, lsSerial,	&
				lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsAddr5, lsAttr1, lsAttr2, lsAttr3, lsAttr4, lsAttr5, lsTranNbr,	&
				lsModelSave, lsFromSite
Long			llRowCount, llRowPos, llIDNo, llIDNOSave, llITDIDNO,  ll_no, llBatchSeq, llCount, llMultiMacid
Long			llCounter, llCounterLoop		// Sweeper Microhelp to show progress of long processes
DateTime	ldtToday
Boolean		lbPalletExists

ldtToday = dateTime(today(),Now())

//Retrieve ITH/ITD joined on Tran_num where statuses are 'N' or 'U'

ldsITH = Create Datastore
presentation_str = "style(type=grid)"
lsSql    = "Select Comcast_ith.id_no as ith_id_no, Comcast_itd.id_no as itd_idno,  Comcast_ith.tran_nbr, ro_no, ref_nbr, ref_cnt, wh_code, "
lsSql += "bol_nbr, pallet_id, carrier, waybill_nbr, from_site_id, serial_no, model_no, address_1, address_2, address_3, address_4, address_5, " 
lsSql += "attribute_1, attribute_2, attribute_3, attribute_4, attribute_5 " 
lsSql += " From Comcast_ith, comcast_itd "
lsSql += " Where comcast_ith.tran_nbr = Comcast_itd.tran_Nbr and comcast_ith.status in ('N', 'U')  and comcast_itd.status = 'N' "
lsSql += "Order by Comcast_Ith.Tran_nbr, model_no "
//lsSql += " Order by bol_nbr, waybill_nbr, Pallet_ID " /* Sort by BOL Nbr/Waybill and Pallet ID so we can process all the pallets for an order at the same time */

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsITH.Create( dwsyntax_str, lsErrText)
ldsITH.SetTransObject(SQLCA)

		
llRowCount = ldsIth.Retrieve()

// Communicate with main window to show long process progress
w_main.SetMicroHelp("Processing Comcast ITH/ITD.  Completed 0 of " + String(llRowCount) + " Records.")
llCounterLoop = 0
Yield()

For llRowPos = 1 to llRowCount
	
	llIDNO = ldsITH.GetITemNUmber(llRowPos,'ith_id_no')
	llITDIDNO =  ldsITH.GetITemNUmber(llRowPos,'itd_idno')
	lsModel = ldsITH.GetITemString(lLRowPos,'model_no')
	lsPallet = ldsITH.GetITemString(lLRowPos,'pallet_ID')
	// 05/24/2011 - GXMOR - Added lsFromSite for supplier determination
	lsFromSite = ldsITH.GetITemString(lLRowPos,'from_site_id')
	
	// 11/10 - PCONKL - If this is a new pallet, we want to check to see if we have any serial numbers already loaded for this pallet. If we do, we will do a preemptive delete to ensure we don't have dups.
	//							In the new setup, we are not mapping MAC ID to the MAC ID field so if it already exists with MAC, we will insert a duplicate
	If lsPallet <> lsPalletSave Then
		
		lbPalletExists = False
		
		Select Count(*) into :llCount
		FRom Carton_Serial
		Where project_id = 'Comcast' and Pallet_id = :lsPallet;
		
		If llCount > 0 Then
			lbPalletExists = True /* we will delete by serial for this pallet*/
		End If
				
		lsPalletSave = lsPallet	
		
	End If
	
	//Get the SKU and Supplier if the MOdel has changed
	If lsModel <> lsModelSave then
					
		//If this is a (hardcoded) repair vendor, look for that specific SKU/Supplier, otherwise take any SKU/Supplier for the Model
		lsSKU = ''
		lsSupplier = ''
					
		If upper(left(lsFromSite,4)) = 'VTEL' Then
			lsSupplier = 'TELEPLAN'
		ElseIf upper(left(lsFromSite,4)) = 'VCON' Then
			lsSupplier = 'CONTEC'
		ElseIf upper(left(lsFromSite,4)) = 'VCTD' Then
			lsSupplier = 'CTDI'
		End If
				
		If lsSupplier > '' or isnull(lsSupplier) Then
					
			Select Max(SKU)
			into :lsSKU
			From Item_MAster 
			Where Project_id = 'COMCAST' and supp_code = :lsSupplier and User_Field10 = :lsModel
			And component_ind <> 'Y';	
				
		End If
					
		//If not found or not a repair vendor, find for any supplier
		//If not found or not a repair vendor, find for any supplier
		If lsSKU = '' or isnull(lsSKU) Then
				
			// 05/11 - PCONKL If coming from ReportStore, exclude Repair Suppliers
			// 06/30 - GXMOR	Even though Menlo WH-to-WH will not upload.  They can be forced, therefore, treat them like REPSTO
			// 03/08/2012 - GXMOR Added component_ind <> 'Y" to filter out parent SKU as Component Master
			If Upper(lsFromSite)  = 'REPSTO' or upper(left(lsFromSite,2)) = 'VM' Then
				
				Select Max(SKU), Max(Supp_code)
				into :lsSKU, :lsSupplier
				From Item_MAster 
				Where Project_id = 'COMCAST' and User_Field10 = :lsModel and supp_code not in ('TELEPLAN', 'CONTEC', 'CTDI')
				And component_ind <> 'Y';	
				
				//In case not found, try for any vendor...
				If isnull(lsSKU) or lsSKU = '' Then
					
					Select Max(SKU), Max(Supp_code)
					into :lsSKU, :lsSupplier
					From Item_MAster 
					Where Project_id = 'COMCAST' and User_Field10 = :lsModel 
					And component_ind <> 'Y';
					
				End If
				
			ElseIf Upper(left(lsFromSite,4)) = 'VREP' Then	 	/* Replico -  Use Comcast supplier code */
				
					Select Max(SKU), Max(Supp_code)
					into :lsSKU, :lsSupplier
					From Item_MAster 
					Where Project_id = 'COMCAST' and User_Field10 = :lsModel and supp_code not in ('TELEPLAN', 'CONTEC', 'CTDI')
					And component_ind <> 'Y';
				
			Else /*not reportstore*/
			
				Select Max(SKU), Max(Supp_code)
				into :lsSKU, :lsSupplier
				From Item_MAster 
				Where Project_id = 'COMCAST' and User_Field10 = :lsModel
				And component_ind <> 'Y';	
				
			End If
					
		End If
		
		If isNull(lsSKU) Then lsSKU = ''
								
	End If /*Model changed */
	
	
	// ** Add or Update the Serial record
	lsSerial =  ldsITH.GetITemString(lLRowPos,'serial_no')
	lsAddr1 =  ldsITH.GetITemString(lLRowPos,'Address_1')
	lsAddr2 =  ldsITH.GetITemString(lLRowPos,'Address_2')
	lsAddr3 =  ldsITH.GetITemString(lLRowPos,'Address_3')
	lsAddr4 =  ldsITH.GetITemString(lLRowPos,'Address_4')
	lsAddr5 =  ldsITH.GetITemString(lLRowPos,'Address_5')
	lsAttr1 =  ldsITH.GetITemString(lLRowPos,'Attribute_1')
	lsAttr2 =  ldsITH.GetITemString(lLRowPos,'Attribute_2')
	lsAttr3 =  ldsITH.GetITemString(lLRowPos,'Attribute_3')
	lsAttr4 =  ldsITH.GetITemString(lLRowPos,'Attribute_4')
	lsAttr5 =  ldsITH.GetITemString(lLRowPos,'Attribute_5')
	
	//11/10 - PCONKL - If we already have records for this pallet, we will try a preemptive delete to avoid Dups
	If lbPalletExists Then
		
		Delete from Carton_serial where Project_id = 'Comcast' and Pallet_id = :lsPallet and Serial_no = :lsSerial Using SQLCA;
		
		If SQLCA.Sqlcode = 0 Then
			Commit;
		Else
			Rollback;
		End If
	End IF
	
	// 11/10/11-GXMOR - Check for Multiple MacId in User_Field1 - Do not load SN and email error to Ops
	// 10/10/12-GWM - Do not check for multiple mac id if addr1 is blank or null  -- Example: CQ9ZZZ000
	If lsAddr1<> '' and not isnull(lsAddr1) then
		llMultiMacid = uf_check_for_multiple_mac_id( lsAddr1, lsSerial, asemail, lsPallet);
	End if
	
	If llMultiMacid = 0 Then
		//Try an Insert, if it fails, we will do an update*/
		Insert into Carton_serial (project_id, Pallet_id,  sku, supp_code, carton_id, Serial_no, Mac_id,
						User_Field1, User_Field2, User_Field3, User_Field4, User_Field5, 
						User_Field6, User_Field7, User_Field8, User_Field9, User_Field10, Source, last_update)
		Values ('COMCAST',:lsPallet,:lsSKU, :lsSupplier,'',:lsSerial,'-', :lsAddr1, :lsAddr2, :lsAddr3,:lsAddr4,:lsAddr5,
						:lsAttr1, :lsAttr2, :lsAttr3, :lsAttr4, :lsAttr5, 'EIS', :ldtToday)
		Using SQLCA;
				
		IF Sqlca.Sqlcode = 0 THEN
			
			Commit;
			
		Else /*Update Address fields on existing record */
				
			Update Carton_serial
			Set User_Field1 = :lsAddr1, User_Field2 = :lsAddr2, User_Field3 = :lsAddr3, User_Field4 = :lsAddr4, USer_Field5 = :lsAddr5, 
					User_Field6 = :lsAttr1, User_Field7 = :lsAttr2, User_Field8 = :lsAttr3, User_Field9 = :lsAttr4, User_Field10 = :lsAttr5, 
					Source = 'EIS', Last_Update = :ldtToday
			Where Project_id = 'COMCAST' and pallet_id = :lsPallet and Serial_no = :lsSerial;
					
			IF Sqlca.Sqlcode = 0 THEN
				Commit;
			Else
				Rollback;
			End If
			
		End If
	
		UPdate comcast_itd set  status = 'C'
		Where id_no = :llITDIDNO;
		
		Commit;
	Else
		UPdate comcast_itd set  status = 'E'
		Where id_no = :llITDIDNO;
	
		Commit;
	End if

	//If new header, update status
	If llIDNO <> llIDNOSave Then
		
		UPdate comcast_ith set  status = 'C'
		Where id_no = :llIDNO;
		
		Commit;
		
	End If
	
	lsModelSave = lsModel
	llIDNOSave = llIDNO
	
	// Communicate with main window with progress
	llCounterLoop++
	If llCounterLoop > 499 Then
		w_main.SetMicroHelp("Processing Comcast ITH/ITD.  Completed " + String(llRowPos) + " of " + String(llRowCount) + " Records.")
		llCounterLoop = 0
		Yield()
	end if

		
Next /* ITH/ITD */

//If we have loaded any pallets that we already have in Inventory with type 'S' (No Serial previoujsly loaded at receipt), Send TRC's for those pallets
uf_process_serial_status_chg()

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")


REturn 0
end function

public function integer uf_check_for_multiple_mac_id (string as_macid, string as_serno, string as_email, string as_pallet);/* Check in Carton/Serial table for a MAC ID already being used by a serial no that is still in inventory */

/* chg - 2012-03-08  by Ermine Todd
*	insert duplicates into temp table to processed by SIMS utility ComcastMultipleMACIDs
*/
//TimA just making a comment so I can re-save this nvo

int retval = 0;
long lcnt = 0;

select count(serial_no) into :retval from carton_serial 
where project_id = 'COMCAST'
and User_field1 = :as_macid
and Serial_No <> :as_serno;
/* Take out check for in inventory and check all Comcast SNs ** There is a new index on user_field1 for performance **
	and pallet_id in
 	( select lot_no from content where project_id = 'COMCAST' );
*/

if retval > 0 then

	/* Now e-mailing the COMCAST  Multiple Mac Id found in ITH/ITD upload. */
	gu_nvo_process_files.uf_send_email("COMCAST", as_email, "Comcast ITH/ITD Error -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Multiple Mac ID found when attempting to upload serial number: " + as_serno + " with Mac ID: " + as_macid + ".  Serial number not uploaded and pallet ID: " + as_pallet + " cannot be shipped until corrected.  Please validate and correct.","")

	/* Update content for this pallet if it exists and change inventory type to 'S'.  Serial count does not match */
	update content set inventory_type = 'S' where project_id = 'COMCAST' and lot_no = :as_pallet Using SQLCA;
	
	iF SQLCA.SqlCode = 0 Then
		Commit;
	Else
		Rollback;
	End if

	/* insert these rows into the temp table for processing */
	select count(*) into :lcnt from Comcast_Dupe where Serial_No = :as_serno and Pallet_ID = :as_pallet using SQLCA;
	
	IF lcnt > 0 THEN
		update Comcast_Dupe set User_field1 = :as_macid using SQLCA;
	ELSE
		insert into Comcast_Dupe values ( :as_serno , :as_macid , :as_pallet, '', 0, SYSDATETIME(), 'COMCAST' ) USING SQLCA;
	END IF

	IF SQLCA.SqlCode = 0 Then
		Commit;
	ELSE
		Rollback;
	END IF

end if

return retval

end function

on u_nvo_proc_comcast.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_comcast.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

