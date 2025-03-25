$PBExportHeader$u_nvo_proc_diebold.sru
$PBExportComments$Process Diebold files
forward
global type u_nvo_proc_diebold from nonvisualobject
end type
end forward

global type u_nvo_proc_diebold from nonvisualobject
end type
global u_nvo_proc_diebold u_nvo_proc_diebold

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsDONotes,		&
				idsDoAddress,	&
				iu_DS
				
u_ds_datastore	idsItem 

				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_dboh (string asinifile, string asemail)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet


If Left(asFile,2) = 'PM' Then /* PO File*/
	
		
		liRC = uf_process_po(asPath, asProject)
	
		//Process any added PO's
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
ElseIf Left(asFile,2) =  'DM' Then /* Sales Order Files from LMS to SIMS*/
		
		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 
		
ElseIf Left(asFile,2) =  'IM' Then /* Item Master File*/
		
		liRC = uf_process_itemMaster(asPath, asProject)
		
Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Diebold
				
String		lsLogout,lsRecData,lsRecType, lsWarehouse, lsDieboldWarehouse, lsOwner, lsNotes

String 		ls_carrier,ls_ship_ref,ls_ship_via,ls_transport_mode, lsNull
Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewHeaderRow,llNewDetailRow, llNewAddressRow, llNewNotesRow, llOrderSeq, &
				llBatchSeq,	llLineSeq, llRC, llOwner
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

ldtToday = DateTime(today(),Now())
SetNull(lsNull)

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

If Not isvalid(idsDONotes) Then
	idsDONotes = Create Datastore
	idsDONotes.dataobject = 'd_mercator_do_Notes'
	idsDONotes.SetTransObject(SQLCA)
End If

IF NOt isvalid(idsDOAddress) Then
	idsDOAddress = Create DataStore
	idsDOAddress.DataObject = 'd_mercator_do_address'
	idsDOAddress.SetTransObject(SQLCA)
End IF

idsDOHeader.reset()
idsDODetail.reset()
idsDONotes.reset()
idsDOAddress.reset() 


//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Diebold Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

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

llOrderSeq = 0 /*order seq within file*/
llRowPos = 0

//read file and load to proper datastore for processing depending on record type
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
	
	
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/
	llRowPos ++
	
	/*Process header, Detail, addresses or Notes */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */
						
			//llnewRow = idsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0 /*reset detail line seq*/
			
			//Tab seperated fields can be loaded into format
			llRC = idsDOHeader.ImportString(lsRecData,1,1,2,999,9) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 9th column on the DW */
			
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Header Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			//Record Defaults
			llNewHeaderRow = idsDOHeader.RowCount()		
			
			idsDOHeader.SetItem(llNewHeaderRow,'ACtion_cd','A') /*always a new Order*/
			idsDOHeader.SetITem(llNewHeaderRow,'project_id',asProject) /*Project ID*/
			
			idsDOHeader.SetItem(llNewHeaderRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDOHeader.SetItem(llNewHeaderRow,'order_seq_no',llOrderSeq) 
			idsDOHeader.SetItem(llNewHeaderRow,'ftp_file_name',aspath) /*FTP File Name*/
			idsDOHeader.SetItem(llNewHeaderRow,'Status_cd','N')
			idsDOHeader.SetItem(llNewHeaderRow,'Inventory_Type','N') /*default to Normal*/

			//COnvert Diebold CCMF Code into the SIMS Warehouse COde
			If lsDieboldWarehouse <> idsDOHeader.GetITemString(llNewHeaderRow,'wh_code') then
				
				lsDieboldWarehouse = idsDOHeader.GetITemString(llNewHeaderRow,'wh_code')

				Select warehouse.wh_Code into :lsWarehouse
				From Warehouse, Project_warehouse
				Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject and User_Field1 = :lsDieboldWarehouse;
				
			End If /*New Warehouse */
			
			idsDOHeader.SetITem(llNewHeaderRow,'wh_code',lswarehouse) /*Default WH for Project */
			
			// 07/08 - PCONKL - Move Request Date to Schedule Date and Clear out Request Date
			idsDOHeader.SetItem(llNewHeaderRow,'schedule_date',idsDoheader.getITemString(llNewHeaderRow,'request_date'))
			idsDOHeader.SetItem(llNewHeaderRow,'request_date',lsNull)
			
			//Default Order Type if not present in file
			If isNull(idsDOHeader.GetITemString(llNewHeaderRow,'order_Type')) Or idsDOHeader.GetITemString(llNewHeaderRow,'order_Type') = '' Then
				idsDOHeader.SetITem(llNewHeaderRow,'order_Type','S') /*Sale */
			End If
				
			//Store Order NUmber in Ship Ref field as well...
			idsDOHeader.SetITem(llNewHeaderRow,'ship_ref',idsDoHeader.GetITemString(llNewHeaderROw,'invoice_no'))
			
			//The header record has some address fields that we're storing in an Alt Address Table
			
			//BillTo Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code') > ''  or  idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_1') > '' Then /* Bill to address present*/
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','BT') /* Bill To Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'bill_to_tel'))
				
			End If /* Bill to Address Present */
			
			//Intermediary Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code') > '' Then /* Intemerd Consignee address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','IT') /* Intermediary Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_1'))
				idsDOAddress.SetItem(llNewAddressRow,'address_2',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_2'))
				idsDOAddress.SetItem(llNewAddressRow,'address_3',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_3'))
				idsDOAddress.SetItem(llNewAddressRow,'address_4',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_address_4'))
				idsDOAddress.SetItem(llNewAddressRow,'district',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_district'))
				idsDOAddress.SetItem(llNewAddressRow,'City',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_City'))
				idsDOAddress.SetItem(llNewAddressRow,'State',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_state'))
				idsDOAddress.SetItem(llNewAddressRow,'Zip',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Zip'))
				idsDOAddress.SetItem(llNewAddressRow,'Country',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_Country'))
				idsDOAddress.SetItem(llNewAddressRow,'tel',idsDOHeader.GetITemString(llNewHeaderROw,'intermediary_tel'))
				
			End If /* Intermed Consignee Address Present */
			
			//Sold To Address
			If idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code') > '' Then /* Sold To address present */
			
				llNewAddressRow = idsDOAddress.InsertRow(0)
				idsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				idsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				idsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				idsDOAddress.SetItem(llNewAddressRow,'address_type','ST') /* Sold TO Address */
				idsDOAddress.SetItem(llNewAddressRow,'Name',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_Code'))
				idsDOAddress.SetItem(llNewAddressRow,'address_1',idsDOHeader.GetITemString(llNewHeaderROw,'sold_to_address_1'))
								
			End If /* Sold To Address Present */
			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
					
			//Tab seperated fields can be loaded into format
			llRC = idsDODetail.ImportString(lsRecData,1,1,2,999,7) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 7th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Detail Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				gu_nvo_process_files.uf_writeError(lsLogOut)
				FileClose(liFileNo)
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			llLineSeq ++
			
			//Add detail level defaults
			llNewDetailRow = idsDODetail.RowCOunt()
			idsDODetail.SetITem(llNewDetailRow,'project_id', asproject) /*project*/
			idsDODetail.SetITem(llNewDetailRow,'status_cd', 'N') 
			idsDODetail.SetITem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDODetail.SetITem(llNewDetailRow,'order_seq_no',llOrderSeq) 
			idsDODetail.SetITem(llNewDetailRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			
			//Company Number is being sent in OWner field and needs to be moved to UF1
			idsDoDetail.SetItem(llNewDetailRow,'User_Field1',idsDoDetail.GetITemString(llNewDetailRow,'c_owner'))
			idsDoDetail.SetItem(llNewDetailRow,'c_owner','') /*isn't really an owner code*/
			
			// 07/08 - PCONKL - We don't want to map the SO line to the SIMS line Item Number since we may receive multiple DD rows for the same SO LIne
			//							Use Sequential number for SIMS Line ITem NUmber and store SO Line in UF2
			idsDoDetail.SetItem(llNewDetailRow,'User_Field2',String(idsDoDetail.GetITemNumber(llNewDetailRow,'line_Item_No')))
			idsDoDetail.SetItem(llNewDetailRow,'Line_ITem_No',llLineSeq)
			
											
		//Notes
		Case 'DN'
			
			//Tab seperated fields can be loaded into format
			llRC = idsDONotes.ImportString(lsRecData,1,1,2,999,5) /*start with the 2nd column on the import string (skip rec type) and start mapping in the 5th column on the DW */
			If llRC < 0 Then
				lsLogOut = "-       ***Unable to Import Notes Record (row " + String(llRowPos) + "). Return Code = " + String(lLRc) + ". File will not be processed"
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
				Return -1 /* we wont move to error directory if we can't open the file here*/
			End If
			
			llNewNotesRow = idsDONotes.RowCount()
			idsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
			idsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
			// 03/05 - PCONKL - REmove any double quotes from Notes - will cause setitem on Packlist to bomb
			lsNotes = Trim(idsDONotes.GetITemString(llNewNotesRow,'note_Text'))
			Do While Pos(lsNotes,'"') > 0
				lsNotes = Replace(lsNotes,Pos(lsNotes,'"'),1,"'")
			Loop
			
			idsDONotes.SetITem(llnewNotesRow,'note_text',lsNotes)
			
			//If Delivery Instructions (note_type = 'DI'), Map to Shipping Instructions
			If idsDONotes.GetITemString(llNewNotesRow,'note_type') = 'DI' Then
				If idsDOHeader.GetITemString(llNewHeaderRow,'Shipping_instructions_Text') > '' Then
					idsDOHeader.SetItem(llNewHeaderRow,'Shipping_instructions_Text',idsDOHeader.GetITemString(llNewHeaderRow,'Shipping_instructions_Text') + ' ' + lsNotes)
				Else
					idsDOHeader.SetItem(llNewHeaderRow,'Shipping_instructions_Text',lsNotes)
				End If
			End If
																
		Case Else /*Invalid rec type */
			
			// 10/07 - PCONKL - we want to reject the ntire file. An invalid rec type is probably indicative of a more serious problem with the file
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. *** THIS ENTIRE FILE will not be processed ***.")
			FileClose(liFileNo)
			Return -1
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsRecType + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next Record */
			
	End Choose /*Header, Detail or Notes */
	
	//Read the Next File record
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)


//Save Changes
liRC = idsDOHeader.Update()
If liRC = 1 Then
	liRC = idsDODetail.Update()
End If
If liRC = 1 Then
	liRC = idsDOAddress.Update()
End If
If liRC = 1 Then
	liRC = idsDONotes.Update()
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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Diebold


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, 	lsCOO, lsSupplier
			
Integer	liRC,	liFileNo
			
Long		llCount,	llPos, llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos 

Decimal ldtemp

Boolean	lbNew, lbError

u_ds_datastore	ldsItem 
datastore	lu_DS

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Diebold Processing: " + asPath
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

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))

	//Ignore EOF
	If lsData = "EOF" Then COntinue
	
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is IM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		//Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate SKU and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSKU = lsTemp
		
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Supplier
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = lsTemp
	Else
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue
	End If

	//Validate Supplier
	If lsSupplier > "" Then
		
		Select Count(*) into :llCount
		From Supplier 
		Where Project_id = :asProject and Supp_code = :lsSupplier;
		
		If llCount < 1 Then
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier: '" + lsSupplier + "'. Record will not be processed.")
			lbError = True
			Continue
		
		End If
		
	End If

	//Retrieve for SKU - We will be updating across Suppliers
	llCount = ldsItem.Retrieve(asProject, lsSKU)

	llCount = ldsItem.RowCount()
		
	If llCount <= 0 Then
			
		//If No Supplier, default to Diebold
		If lsSupplier = "" Then
			
			lsSupplier = 'DIEBOLD'
			
//			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier not present. Unable to Insert new Item Master record for SKU: '" + lsSKU + "'")
//			lbError = True
//			Continue
			
		End If
		
		llNew ++ /*add to new count*/
		lbNew = True
		llNewRow = ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'project_id',asProject)
		ldsItem.SetItem(1,'SKU',lsSKU)
		
		//Get Default owner for Supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :asProject and Owner_type = 'S' and owner_cd = :lsSupplier;
			
		ldsItem.SetItem(1,'supp_code',lsSupplier)
		ldsItem.SetItem(1,'owner_id',llOwner)
							
	Else /*exists*/
				
		llexist += llCount /*add to existing Count*/
		lbNew = False
	
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	For llPos = 1 to ldsItem.RowCount()
		ldsItem.SetItem(llPos,'Description',left(lsTemp,70))
	Next
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	// UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	For llPos = 1 to ldsItem.RowCount()
		If lsTEmp > '' Then
			ldsItem.SetItem(llPos,'uom_1',left(lsTemp,4))
		Else 
			ldsItem.SetItem(llPos,'uom_1','EA') //Default EA
		End If
	Next
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Weight maps to Weight 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'weight_1',Dec(Trim(lsTemp)))
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	
	

	//Length maps to Length 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Length',Dec(trim(lsTemp)))
		Next
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Width maps to Width 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Width_1',Dec(Trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Height maps to Height 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Height_1',Dec(Trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Standard Cost
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Std_Cost',dec(trim(lsTemp)))
		next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Cycle Count Frequency in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(trim(lsTEmp)) Then /*only map if numeric*/
		ldTemp = Dec(Trim(lsTemp) )
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'cc_freq',Trim(lsTemp))
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//UPC Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(lsTEmp) Then /*only map if numeric*/
		ldTemp = Dec(lsTemp) 
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Part_UPC_Code',ldTemp)
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Freight Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Freight_Class',left(lsTemp,10))
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Storage Code 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Storage_Code',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Inventory Class 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Inventory_Class',left(lsTemp,10))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Alternate SKU 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Alternate_SKU',left(lsTemp,50))
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Default COO 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	For llPos = 1 to ldsItem.RowCount()
		If lsTEmp > '' Then
			ldsItem.SetItem(llPos,'Country_Of_Origin_Default',left(lsTemp,3))
		Else
			ldsItem.SetItem(llPos,'Country_Of_Origin_Default','XXX')
		End If
	Next
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Shelf Life in Days
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If isnumber(Trim(lsTEmp)) Then /*only map if numeric*/
		ldTemp = Dec(trim(lsTemp) )
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'Shelf_Life',ldTemp)
		Next
	End If
	

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		

	//Item Delete Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'item_delete_ind',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//Factory Application Code (UF1)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field1',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Serial Numbers required
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
	Choose Case lsTemp
		Case "N" /*No tracking*/
			For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'serialized_ind',"N")
			Next
		Case "O" /*Outbound*/
			For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'serialized_ind',"O")
			Next
		Case "E" /*End To End (Inbound)*/
			For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'serialized_ind',"Y")
			Next
		Case Else
			For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'serialized_ind',"N")
			Next
	End Choose
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

		
	//Product Code (UF5)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field5',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Product Code DEsc (UF8)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field8',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//harmonized Code (UF6)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field6',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Product Group (UF7)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'user_field1',lsTemp)
		Next
	End If
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	// 11/08 - PCONKL - Signal Code -Mapping to Group if Valid
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > '' Then
		
		//Validate against Item_Group Table
		Select Count(*) into :lLCount
		From Item_Group
		Where Project_id = 'Diebold' and grp = :lsTemp;
		
		If llCount > 0 Then
			
			For llPos = 1 to ldsItem.RowCount()
				ldsItem.SetItem(llPos,'grp',lsTemp)
			Next
			
		End If
		
	End If
	
	
	//Update any record defaults
	For llPos = 1 to ldsItem.RowCount()
		ldsItem.SetItem(llPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llPos,'last_update',today())
	Next
		
	//If record is new...
	If lbNew Then
		ldsItem.SetItem(1,'lot_controlled_ind','Y') /*Sales Order Number on all items*/
		ldsItem.SetItem(1,'po_controlled_ind','Y') /*Sales Order Line on all items*/
		ldsItem.SetItem(1,'po_no2_controlled_ind','Y') /*Container Number on all items*/
		ldsItem.SetItem(1,'container_tracking_ind','N') 
	End If
			
	//Save NEw Item to DB
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

Next /*File row to Process */

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

protected function integer uf_process_po (string aspath, string asproject);//Process PO for Diebold

Datastore	lu_ds, ldsItem

String	lsLogout,lsStringData, lsOrder, lsWarehouse, lsTemp, lsRecData, lsRecType, lsDesc, lsSKU, lsSupplier, lsContainer, lsPOLine
Integer	liRC,liFileNo
Long		llNewRow, llNewDetailRow, llFindRow, llBatchSeq, llOrderSeq, llRowPos, llRowCount, llLineSeq, llCount, llOwnerID, llLineItemNo, llSeqID, llMaxLine
Boolean	lbError, lbDetailError
DateTime	ldtToday
Decimal	ldWeight, ldLineItemNo
String 	lsOrderNo

ldtToday = DateTime(Today(),Now())
llMaxLine = 0 

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

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
lsLogOut = '      - Opening File for Diebold Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Diebold Processing: " + asPath
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
llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

//Process Each Record in the file..

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsRecData = Trim(lu_ds.GetItemString(llRowPos,'rec_Data'))
	lsRecType = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	Choose Case Upper(lsRecType)
			
		Case 'PM' /*PO Header*/
			
			llNewRow = 	idsPOheader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			
			//New Record Defaults
			idsPOheader.SetItem(llNewRow, 'project_id',asProject)
			//idsPOheader.SetItem(llNewRow, 'wh_code',lsWarehouse)
			idsPOheader.SetItem(llNewRow, 'Request_date',String(Today(),'YYMMDD'))
			idsPOheader.SetItem(llNewRow, 'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			idsPOheader.SetItem(llNewRow, 'order_seq_no',llOrderSeq) 
			idsPOheader.SetItem(llNewRow, 'ftp_file_name',asPath) /*FTP File Name*/
			idsPOheader.SetItem(llNewRow, 'Status_cd','N')
			idsPOheader.SetItem(llNewRow, 'Last_user','SIMSEDI')
			idsPOheader.SetItem(llNewRow, 'Order_type', 'S') /*Order Type = Supplier */
			idsPOheader.SetItem(llNewRow, 'Inventory_Type','N') /*default to Normal*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
		
			//Action Code - 			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Action Code' field. Record will not be processed.")
			End If
						
			idsPOheader.SetItem(llNewRow, 'action_cd', lsTemp) 
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
									
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			lsOrderNo = trim(lsTemp)
			idsPOheader.SetItem(llNewRow,'order_no',Trim(lsTemp))
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		

			//Supplier Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
			End If
		
			lsSupplier = lsTemp /*used to build ITem master below*/
			idsPOheader.SetItem(llNewRow,'supp_code',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Expected Arrival Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Arrival Date' field. Record will not be processed.")
			End If
					
			idsPOheader.SetItem(llNewRow,'Arrival_Date',lsTemp)
			
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Warehouse - Needs to be translated into the SIMS WH Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
				
			Select warehouse.wh_Code into :lsWarehouse
			From Warehouse, Project_warehouse
			Where warehouse.wh_Code = project_warehouse.wh_Code and project_id = :asProject and User_Field1 = :lsTemp;
			

			If lsWarehouse = "" Then
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
			End If
			
			idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse)
						
					
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
		
			
			//Order Type - Override from default if present
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'order_type',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Buyer Name -> UF6
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
					
			idsPOheader.SetItem(llNewRow,'User_Field6',lsTemp)
					
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
				
			//Action Code
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
			lsOrderNo = trim(lsTemp)

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			
			//Line Item Number - This is sequential number from ICC - Real PO LIne is in UF 6 below
			// 						IF this is an update to an existing PO/Line, we need to retreive the real line number that was assigned to the order
			//							Since the same sequential line item numbers probably won't match between the add and the update
			//							We will do that after we have retreived the Container Number below - we will retreive based on PO/Line (UF6)/Container (PO_NO2)
			
			//We also need to know what the max line number is (on an update) if we are adding new lines to end (but seq Number in file restarts with 1)
			If llMaxLine = 0 Then
				
				Select MAx(line_Item_No) into :llMaxLine
				From Edi_InBound_Detail
				Where project_id = 'diebold' and order_no = :lsOrderNo;
				
				If isnull(llMaxLine) then llMaxLine = 0
				
			End If
			
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
		
			llLineItemNo = Dec(Trim(lsTemp))
			
			//Keep track of current max line incase we need to add a line at the end*/
			If llLineItemNo > llMaxLine Then llMaxLine = llLineItemNo
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Upper(Left(lsRecData,(pos(lsRecData,'|') - 1)))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
				lbDetailError = True
			End If
						
			lsSKU = trim(lsTemp) /*used to build itemmaster below*/				
			idsPODetail.SetItem(llNewDetailRow,'SKU',lsSKU)
		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Qty
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else
				lsTemp = lsRecData
			End If
		
			idsPODetail.SetItem(llNewDetailRow,'quantity',Trim(lsTemp)) /*checked for numerics in nvo_process_files.uf_process_purcahse_Order*/

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
			
			//lot No (Sales Order Number)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow, 'Lot_no', trim(lsTemp))
			idsPODetail.SetItem(llNewDetailRow, 'USer_Field4', trim(lsTemp)) /*want on detail record as well*/
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO - SO Line
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'PO_NO',lsTemp)
			idsPODetail.SetItem(llNewDetailRow,'User_Field5',lsTemp) /*want on detail record as well*/
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2 (Diebold Container Number)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'po_no2',lsTemp)
			lsContainer = lsTemp
					
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
						
			//Company NUmber (UF 3)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'User_Field3',lsTemp)
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Supplier PO LIne (Line_ITem_No from ICC is just sequential line to allow us to have multiple containers for the same SO/Line)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
						
			idsPODetail.SetItem(llNewDetailRow,'User_Field6',lsTemp)
			lsPOLine = lsTemp
					
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//The line item number we received was a just a sequential number so we could have multiple container numbers (po_no2 in SIMS) for the same Diebold PO LIne Number
			//We are storing the real PO LIne number in UF 6. HOwever, if we get an update to that PO LIne, we may get a new seqeuntial number so we need to
			//determine what LIne number we assigned on the original load so we can update it here instead of adding a new number
			//We will retreive the Sims line_ITem_No based on the PO/SKU/Container(po_no2) and real PO LIne (UF6)
			
			Select Max(edi_Batch_Seq_No) into :llSeqID
			from edi_inbound_Detail
			Where Project_id = 'Diebold' and order_no = :lsOrderNo and sku = :lsSKU and po_no2 = :lsContainer and user_Field6 = :lsPOLine;
			
			if llSEQID > 0 Then
				
				select Line_Item_No into :llLineItemNo
				from edi_inbound_Detail
				Where Project_id = 'Diebold' and edi_Batch_Seq_No =  :llSeqID and  order_no = :lsOrderNo and sku = :lsSKU and po_no2 = :lsContainer and user_Field6 = :lsPOLine;
				
				idsPODetail.SetItem(llNewDetailRow,'line_item_no',llLineItemNo)
				
			Else /* not found, try without Container ID for match*/
				
				//If not found, Try again without the Container ID, they may not be sending (or sending a different Container ID) on an update
				Select Max(edi_Batch_Seq_No) into :llSeqID
				from edi_inbound_Detail
				Where Project_id = 'Diebold' and order_no = :lsOrderNo and sku = :lsSKU  and user_Field6 = :lsPOLine;
				
				if llSEQID > 0 Then
				
					select Line_Item_No into :llLineItemNo
					from edi_inbound_Detail
					Where Project_id = 'Diebold' and edi_Batch_Seq_No =  :llSeqID and  order_no = :lsOrderNo and sku = :lsSKU and user_Field6 = :lsPOLine;
				
					idsPODetail.SetItem(llNewDetailRow,'line_item_no',llLineItemNo)
					
				Else  /*If this line number has already been assigned (but not for this line), assign a new line Item NUmber*/
				
					llLineItemNo = idsPODetail.GetITemNumber(llNewDetailRow,'line_item_no')
				
					Select Count(*) into :llCOunt
					From Edi_Inbound_Detail
					Where project_id = 'diebold' and Line_ITem_No = :llLineItemNo;
				
					If llCount > 0 Then
					
						llMaxLine ++
						idsPODetail.SetItem(llNewDetailRow,'line_item_no',llMaxLine)
					
					End If
					
				End If
				
			End If
			
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

public function integer uf_process_dboh (string asinifile, string asemail);Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow,  llQty, llOwner132
String	lsOutString,  lsLogOut,  lsFIleName, lsDieboldWarehouse, lsWarehouseSave, lsWarehouse
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsInv

	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Diebold Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

//Create the Datastore...
//11/08 - Exclude Grp = 'AIR"
sql_syntax = "SELECT WH_Code, Content_Summary.SKU, Content_Summary.inventory_type,  Content_Summary.Owner_ID, Sum( Avail_Qty  ) + Sum( alloc_Qty  ) + Sum(Wip_Qty) as total_qty   " 
sql_syntax += "from Content_Summary, Item_MAster"
sql_syntax += " Where Content_Summary.Project_ID = 'DIEBOLD' "
sql_syntax+= " and Content_Summary.Project_id = Item_Master.Project_id and Content_Summary.SKU = Item_MAster.SKU and Content_Summary.supp_code = item_MAster.Supp_Code "
sql_syntax += " and (grp is null or grp <> 'AIR') "
sql_syntax += " Group by Wh_Code, Content_Summary.SKU, Content_Summary.Inventory_Type, Content_Summary.Owner_ID"
sql_syntax += " Having Sum( Avail_Qty  ) + Sum( alloc_Qty  )  + Sum(Wip_Qty) > 0; "

ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Diebold Inventory Snapshot ID data.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)

//11/08 - PCONKL - We need to differentiate between company 132 and company 100. If Owner is Customer 132, set owner as 132, else it's 100.
Select Owner_id into :llOwner132
From Owner
Where Project_id = 'Diebold' and Owner_type = 'C' and Owner_cd = '132';


//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()

ldsInv.SetSort("wh_code A, sku A")
ldsInv.Sort()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llRowCount < 1 Then 
	Return 0
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("DIEBOLD",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Diebold BOH file. Confirmation will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write to archive file 
lsFileName = ProfileString(asInifile,"Diebold","archivedirectory","") + '\' + "BH" + String(ldBatchSeq,"0000000000")  + ".csv"

//Open and spool the file
liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Diebold Daily Inventory Snapshot file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create a column header record
lsOutString = "Warehouse,SKU,Inventory Type,Qty,Company"
FileWrite(liFileNo,lsOutString)

//For each INventory Row, Create a CSV record
For llRowPos = 1 to llRowCount
	
	//We need the Diebold Warehouse COde (UF1) - Only need to retreive if changed*/
	lsWarehouse = ldsInv.GetITemString(llRowPos,'wh_Code')
	
	If lsWarehouse  <> lswarehouseSave Then
		
		Select User_field1 into :lsDieboldWarehouse
		From Warehouse
		where wh_code = :lsWarehouse;
		
		If isNull(lsDieboldWarehouse) or lsDieboldWarehouse = "" Then lsDieboldWarehouse = lsWarehouse
		
		lsWarehouseSave = ldsInv.GetITemString(llRowPos,'wh_Code')
		
	End If
	
	
	lsOutstring = ""
	
	lsOutString += lsDieboldWarehouse + ","
	lsOutString += '"' + ldsInv.GetITemString(llRowPos,'SKU') + '",'
	lsOutString += ldsInv.GetITemString(llRowPos,'inventory_type') + ","
	lsOutString += String(ldsInv.GetITemNumber(llRowPos,'total_qty'),'##########') + ","
	
	//11/08 - PCONKL - We need to differentiate between company 132 and company 100. If Owner is Customer 132, set owner as 132, else it's 100.
	If ldsInv.GetITemNumber(llRowPos,'owner_id') = llOwner132 Then
		lsOutString += "132"
	Else
		lsOutString += "100"
	End If
	
	FileWrite(liFileNo,lsOutString)
	
Next /*Inventory Record */

//Close the file and email...
FileClose(liFileNo)

If pos(asEmail,"@") > 0 Then
	gu_nvo_process_files.uf_send_email("Diebold",asEmail,"XPO Logistics WMS - Daily Inventory Snaphot File","  Attached is the Daily Inventory Snapshot file...",lsFileName)
Else /*no valid email, send an email to the file transfer error dist list*/
	gu_nvo_process_files.uf_send_email("Diebold",'FILEXFER',"Unable to email Daily shipment file to Diebold","Unable to email Daily Inventory Snaphot file to Diebold - no email address found - file is still archived","")
End If

Return llrowCount
end function

on u_nvo_proc_diebold.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_diebold.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

