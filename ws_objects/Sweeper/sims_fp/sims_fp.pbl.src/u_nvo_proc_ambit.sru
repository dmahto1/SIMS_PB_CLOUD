$PBExportHeader$u_nvo_proc_ambit.sru
$PBExportComments$Process Ambit Files
forward
global type u_nvo_proc_ambit from nonvisualobject
end type
end forward

global type u_nvo_proc_ambit from nonvisualobject
end type
global u_nvo_proc_ambit u_nvo_proc_ambit

type variables
Datastore	iu_ds

end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject)
end prototypes

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
lsLogOut = '      - Opening File for  Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for AMBIT Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
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
	Choose Case Upper(Right(Trim(iu_ds.GetITemString(1,'rec_data')),4)) 
			
		Case 'ZLF1' /* Sales Order Files*/
		
			liRC = uf_process_so(asPath, asProject)
		
			//Process any added SO's
			//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
			If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
			End If
			
		Case 'ZNLC' /* PO Files*/
		
			liRC = uf_process_po(asPath, asProject)
		
			//Process any added PO's
			If liRC >= 0 Then
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			End If
	
		Case Else /*Invalid file type*/
		
			lsLogOut = "        - Invalid Document Type in first record: " + Upper(Right(Trim(iu_ds.GetITemString(1,'rec_data')),4))  + " - File will not be processed."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogout)
			Return -1
		
	End Choose
	
Else /*No Rows*/
	
	lsLogOut = "        - No records found in file"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogout)
			
End IF



Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for AMBIT

Datastore	ldsDOHeader, ldsDODetail
				
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsAddress, lsCity, lsSHipDAte

Integer		liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow,   llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

ldtToday = DateTime(today(),Now())
				
//formatted for Mercator Input - fields can be manually set for others
ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_mercator_do_Header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_mercator_do_Detail'
ldsDODetail.SetTransObject(SQLCA)

lsLogOut = '      - Processing Sales Order File...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Default Warehouse if not valid warehouse on import 
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//All records will be loaded with Ambit as the owner 
Select owner_id into :llOwner
From Owner
Where Owner_Cd = 'Ambit' and owner_type = 'S' and Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then
	Return -1
End If

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//Loop thru datastore loaded in main driver
llRowCount = iu_ds.RowCOunt()

For llRowPos = 1 to llRowCount /* Each Column is a seperate row in the import file*/
	
	lsRecData = iu_ds.GetITemString(llRowPos,'rec_Data')
	lsRecType = Left(lsRecData,3) /* rec type should be first 3 char of file*/
		
	Choose Case Upper(lsRecType)
		
		//Header Fields 
		
		Case 'H01' /* should always be 'ZLF1' for Sales Order in this function */
			
			If Mid(lsRecData,4,4) <> 'ZLF1' Then
				
				lsLogOut = '      - Document Type is not "ZLF1", file will not be processed.'
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return -1
				
			End If
		
		Case 'H02' /* Invoice No */
			
			//ORder NUmber is changing, add a new header
			llNewHeaderRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Invoice_No',Trim(Mid(lsRecData,4,10)))
			
			//Header level record defaults
			ldsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			//ldsDOHeader.SetITem(llNewHeaderRow,'wh_Code',lsWarehouse) /*Default warehouse for project*/
			ldsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewHeaderRow,'Order_Type','S')
//			ldsDOHeader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')
			
		Case 'H03' /*Customer Order Nbr */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Order_no',Mid(lsRecData,4,15))
			
		Case 'H04' /* Cust Code */
			
			//If first char of cust code is a zero, trim
			If Mid(lsRecData,4,1) = '0' Then
				ldsDOHeader.SetItem(llNewHeaderRow,'cust_Code',Mid(lsRecData,5,5)) /*start with 5th instead of 4th char*/
			Else
				ldsDOHeader.SetItem(llNewHeaderRow,'cust_Code',Mid(lsRecData,4,6)) /*start with 5th instead of 4th char*/
			End If
			
		Case 'H05' /*Customer Name */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Cust_Name',Mid(lsRecData,4,40))
			
		Case 'H06' /* Attention (Address 1) */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Address_1',Mid(lsRecData,4,40))
			
		Case 'H08' /*Ship to Address - We'll strip off the city, state zip after we have loaded them below*/
			
			lsAddress = Mid(lsRecData,4,90)
			
		Case 'H09' /* State */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'State',Mid(lsRecData,4,3))
			
		Case 'H10' /* Zip */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Zip',Mid(lsRecData,4,9))
			
		Case 'H11' /* Country */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Country',Mid(lsRecData,4,4))
			
		Case 'H12' /* City*/
			
			lsCity = Mid(lsRecData,4,30)
			ldsDOHeader.SetItem(llNewHeaderRow,'City',lsCity)
			
			//Take the address up to City and load into address 2 field (address has address + city, state zip - strip out)
			lsAddress = Left(lsAddress,(Pos(Upper(lsaddress),Trim(Upper(lsCity))) - 1))
			ldsDOHeader.SetItem(llNewHeaderRow,'Address_2',Left(lsAddress,40))
			
		Case 'H13' /* Phone */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'tel',Mid(lsRecData,4,15))
			
		Case 'H14' /* Ship VIA */
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Ship_Via',Mid(lsRecData,4,10))
			
		Case 'H15' /* Carrier*/
			
			ldsDOHeader.SetItem(llNewHeaderRow,'Carrier',Mid(lsRecData,4,10))
			
		Case 'H16' /* Warehouse */
			
//			Choose Case Upper(Mid(lsRecData,4,2))
//			
//				Case 'FD' /*Dayton*/
//					
//					lsWarehouse = 'AMBIT-WDY'
//					
//				Case 'FE'
//					
//					lsWarehouse = 'AMBIT-OTAY'
//					
//				CASe Else /*take DEfault retrieved above*/
//					
//			End Choose

			Choose Case Upper(Mid(lsRecData,5,1))
			
				Case 'D' /*Dayton*/
					
					lsWarehouse = 'AMBIT-WDY'
					
				Case 'S'
					
					lsWarehouse = 'AMBIT-OTAY'
					
				Case Else /*take DEfault retrieved above*/
					
			End Choose
			
			ldsDOHeader.SetITem(llNewHeaderRow,'wh_Code',lsWarehouse)
			
		Case 'H17' /*Expected (Schedule) Ship Date */
			
			lsShipDate = Mid(lsRecData,4,4) + '-' + Mid(lsRecData,8,2) + '-' + Mid(lsRecData,10,2)
			ldsDOHeader.SetItem(llNewHeaderRow,'schedule_Date',lsShipDAte)
			
		// Detail Fields
		
		Case 'D01' /* Line Number */
			
			//Add a new Detail Row 
			llNewDetailRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Record Defaults
			ldsDODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			ldsDODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewDetailRow,"Invoice_No",ldsDOHeader.GetITemString(llnewheaderRow,'Invoice_no'))
			ldsDODetail.SetITem(llNewDetailRow,"inventory_type",'N')
			
			ldsDODetail.SetITem(llNewDetailRow,'Line_Item_No',Long(Trim(Mid(lsRecData,4,3))))
			
		Case 'D02' /* SKU */
			
			ldsdoDetail.SetITem(llNewDetailRow,'SKU',Mid(lsRecData,4,15))
			
		Case 'D03' /*Quantity*/
			
			ldsDODetail.SetITem(llNewDetailRow,'Quantity',Trim(Mid(lsRecData,4,10)))
			
	End Choose
		
next /*Next File record*/

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

public function integer uf_process_po (string aspath, string asproject);
String	lsWarehouse, lsRecData, lsRecType, lsLogOut, lsOrderType, lsShipDate, lsOrderNo
Long	llOwner, llBatchSeq, llRowCOunt, llRowPos, llOrderSeq, llNewheaderROw, llNewDetailRow, llLineSeq
Integer	liRC
Datastore	ldsPOheader, ldsPOdetail


ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

lsLogOut = '      - Processing PO File...'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


//Default Warehouse if not valid warehouse on import 
Select wh_code into :lswarehouse
From Project
Where Project_id = :asProject;

//All records will be loaded with Ambit as the owner and Supplier
Select owner_id into :llOwner
From Owner
Where Owner_Cd = 'Ambit' and owner_type = 'S' and Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then
	Return -1
End If

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//Loop thru datastore loaded in main driver
llRowCount = iu_ds.RowCOunt()
For llRowPos = 1 to llRowCount /* Each Column is a seperate row in the import file*/

	lsRecData = iu_ds.GetITemString(llRowPos,'rec_Data')
	lsRecType = Left(lsRecData,3) /* rec type should be first 3 char of file*/
	
	Choose Case Upper(lsRecType)
		
		//Header Fields 
		
		Case 'H01' /* should be 'ZNLC' for Purchase Order or 'ZLR1' for RMA in this function */
			
			If Mid(lsRecData,4,4) <> 'ZNLC'  Then
				
				lsLogOut = '      - Document Type is not "ZNLC", file will not be processed.'
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return -1
				
			Else
				
				lsOrderType = Mid(lsRecData,4,4) /* will either be supplier or RMS when we create header */
				
			End If
		
		Case 'H02' /*Order Number*/
			
			//ORder NUmber is changing, add a new header
			llNewHeaderRow = ldsPOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			ldsPOheader.SetITem(llNewHeaderRow,'project_id',asProject)
			ldsPOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			ldsPOheader.SetITem(llNewHeaderRow,'supp_code','AMBIT') 
			ldsPOheader.SetITem(llNewHeaderRow,'Request_date',String(Today(),'YYMMDD'))
			ldsPOheader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPOheader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			ldsPOheader.SetItem(llNewHeaderRow,'ftp_file_name',asPath) /*FTP File Name*/
			ldsPOheader.SetItem(llNewHeaderRow,'Status_cd','N')
			ldsPOheader.SetItem(llNewHeaderRow,'Last_user','SIMSEDI')
			
			ldsPOHeader.SetItem(llNewHeaderRow,'Order_No',Trim(Mid(lsRecData,4,10)))
			lsOrderNo = Trim(Mid(lsRecData,4,10)) /*used in Detail*/
			
			//Either Supplier or Return from Customer
			If lsOrderType = 'ZLR1' Then /*RMA*/
				ldsPOheader.SetItem(llNewHeaderRow,'Order_type','X') /*Return from Customer*/
				ldsPOheader.SetItem(llNewHeaderRow,'Inventory_Type','R') /*default to RMA Inventory*/
			Else
				ldsPOheader.SetItem(llNewHeaderRow,'Order_type','S') /*Supplier Order*/
				ldsPOheader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/
			End If
						
		Case 'H03' /* TO(Shipment) NO */
			
		Case 'H04' /*Customer PO Number*/
			
		Case 'H05' /*Customer/Supplier (???) Code */
			
		Case 'H06' /*Customer Name - Only in RMA ???*/
			
		Case 'H07' /*warehouse*/
			
			Choose Case Upper(Mid(lsRecData,4,2))
			
				Case 'FD' /*Dayton*/
					
					lsWarehouse = 'AMBIT-WDY'
					
				Case 'FE'
					
					lsWarehouse = 'AMBIT-OTAY'
					
				CASe Else /*take DEfault retrieved above*/
					
			End Choose
			
			ldsPOHeader.SetITem(llNewHeaderRow,'wh_Code',lsWarehouse)
			
		Case 'H08' /*Ship Date (request Date) */
			
			lsShipDate = Mid(lsRecData,4,4) + '-' + Mid(lsRecData,8,2) + '-' + Mid(lsRecData,10,2)
			ldsPOHeader.SetItem(llNewHeaderRow,'request_Date',lsShipDAte)
						
	//Detail Fields
	
		Case 'D01' /* Line Number */
			
			//Add a new Detail Row 
			llNewDetailRow = ldsPODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			ldsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
			ldsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			ldsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N')
			ldsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			ldsPODetail.SetItem(llNewDetailRow,'order_no',lsOrderNo) 
			ldsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
			
			ldsPODetail.SetITem(llNewDetailRow,'Line_Item_No',Long(Trim(Mid(lsRecData,4,3))))
			
		Case 'D02' /* SKU */
			
			ldsPODetail.SetITem(llNewDetailRow,'SKU',Trim(Mid(lsRecData,4,15)))
			
		Case 'D03' /* QTY */
			
			ldsPODetail.SetITem(llNewDetailRow,'quantity',Trim(Mid(lsRecData,4,10)))
			
	End Choose
	
Next

//Save the Changes 
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
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


Return 0


end function

on u_nvo_proc_ambit.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_ambit.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

