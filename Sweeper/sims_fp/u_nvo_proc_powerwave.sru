HA$PBExportHeader$u_nvo_proc_powerwave.sru
$PBExportComments$Process Powerwave files
forward
global type u_nvo_proc_powerwave from nonvisualobject
end type
end forward

global type u_nvo_proc_powerwave from nonvisualobject
end type
global u_nvo_proc_powerwave u_nvo_proc_powerwave

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
public function integer uf_process_dboh (string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_move_order (string aspath, string asproject)
public function integer uf_move_order_daily_summary ()
public function integer uf_daily_receipt_summary (string aswarehouse)
public function integer uf_daily_shipment_summary (string aswarehouse)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//We may have multiple record types in the same file

String	lsLogOut,lsSaveFileName, lsStringData

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
	
	Case 'IM' /* Item Master */
		
		liRC = uf_process_itemmaster(asPath, asProject)
		
	Case 'PM' /* PO File */
		
		liRC = uf_process_po(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//Process any added PO's
		//If liRC >=0 THen
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		//End If
		
		If lbError Then liRC = -1
		
	Case 'DM' /* Delivery Order File */
		
		liRC = uf_process_So(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
	//	If liRC >=0 THen
			liRC = gu_nvo_process_files.uf_process_delivery_order( asProject ) 
	//	End If
		
		If lbError Then liRC = -1
		
	Case 'MO' /* 12/07 - PCONKL - Move ORder from factory to warehouse */
		
		liRC = uf_process_move_order(asPath, asProject)
		
		If liRC < 0 Then lbError = True
		
		//Process any added orders
	//	If liRC >=0 THen
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
	//	End If
		
		If lbError Then liRC = -1
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
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
lsLogOut = '      - Opening File for Powerwave Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Powerwave Processing: " + asPath
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

//Warehouse defaulted from project master default warehouse - only need to retrieve once
Select wh_code into :lsWarehouse
From Project
Where Project_id = :asProject;

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
			idsPOheader.SetItem(llNewRow,'wh_code',lsWarehouse)
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
		
		
			// Unique order for Powerwave is Order/Receipt Date. Check for existence here. If doesn't exist, set action to 'Z'. This will force PO process
			// to create a new order regardless. Otherwise, we will append to same order when they should be 2.
			If idsPOHeader.GetITemString(llNewRow,'Action_cd') = 'A' and lsTemp > '' Then
				
				Select Count(*) into :lLCount
				From Receive_MAster 
				Where Project_id = 'Powerwave' and Supp_Invoice_No = :lsOrderNo and arrival_date = :lsTemp;
				
				If lLCount = 0 Then
					idsPoheader.SetITem(llNewRow,'action_cd','Z') /*add regardless*/
				End If
				
			End If
		
		
			//Warehouse - Ignore for now - get from project default
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else 
				lsTemp = lsRecData
			End If
			
			//Should be hardcoded as 'MER' for now...
   			//   If lsTemp <> 'MER' Then
			//    lbError = True
			//    gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
			//   End If
			
			//idsPOheader.SetItem(llNewRow,'wh_Code',lsTemp)
			
			//12/07 - PCONKL - 'MSZ' valid for Suzhou warehouse
			//6/12 - MEA - Added 'PCH'
			If lsTemp = 'MER'  Then
			 lsWarehouse = "PWAVE-FG" /*eersel*/
			ElseIf lsTemp = 'MSZ' Then /*Suzhou */
			 lsWarehouse = "PWAVE-SUZ"
			ElseIf lsTemp = 'PCH' Then  /*PCH*/
			 lsWarehouse = "PWAVE-SBLC"			 
			Else /*invalid*/
			 lsWarehouse = lsTemp
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

public function integer uf_process_dboh (string asinifile);

//Process the Powerwave Daily Balance on Hand Confirmation File


Datastore	ldsOut, ldsboh, ldsReady
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow, J
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	lsWarehouse,	lsPowerwaveWarehouse,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, sql_syntax, ERRORS

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

// 12/07 - Added loops  to suupport multiple warehouses - Suzhou added
For J = 1 to 3 /* 2 warehouses for now*/  /* MEA - 6/12 - Added PCH */

	Choose Case J
			
		Case 1 /*Eersel*/

			lsNextRunDate = ProfileString(asIniFile,'Powerwave','DBOHNEXTDATE','')
			lsNextRunTime = ProfileString(asIniFile,'Powerwave','DBOHNEXTTIME','')
			lsWarehouse = "'PWAVE-FG', 'PWAVE-USED'"
			lsPowerwaveWarehouse = 'MER'
			
		Case 2 /*Suzhou*/

			lsNextRunDate = ProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-SUZ','')
			lsNextRunTime = ProfileString(asIniFile,'Powerwave','DBOHNEXTTIME-SUZ','')
			lsWarehouse = "'PWAVE-SUZ'"
			lsPowerwaveWarehouse = 'MSZ'
			
		Case 3 /*PCH*/
			
			lsNextRunDate = ProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-PCH','')
			lsNextRunTime = ProfileString(asIniFile,'Powerwave','DBOHNEXTTIME-PCH','')
			lsWarehouse = "'PWAVE-SBLC'" 
			lsPowerwaveWarehouse = 'PCH'			
			
	End Choose

	If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
		//return 0
		Continue
	Else /*valid date*/
		ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
		If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
			//Return 0
			Continue
		End If
	End If

	lsLogOut = ""
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = "- PROCESSING FUNCTION: Powerwave Balance On Hand Confirmation! - Warehouse = " + lsWarehouse
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = ""
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	
	ldsOut = Create Datastore
	ldsOut.Dataobject = 'd_edi_generic_out'
	lirc = ldsOut.SetTransobject(sqlca)

	ldsboh = Create Datastore

	// 02/07 - PCONKL - Create dynamically - we want to rollup to project instead of warehouse
	//12/07 - PCONKL - now rolling up to warehouse(s) level
	sql_syntax = " SELECT Content_summary.SKU,  Content_summary.inventory_type, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty "
	sql_syntax += "  FROM Content_summary  Where project_id = 'Powerwave' and l_code <> 'N/A' " /* don't include parent placeholders (loc = 'N/A') */
	sql_syntax += " and Content_Summary.Wh_Code in (" + lsWarehouse + ") "
	sql_syntax += " Group By Sku, Inventory_type Having Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) > 0"
	
	ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

	IF Len(ERRORS) > 0 THEN
  	 lsLogOut = "        *** Unable to create datastore for Powerwave Balance on Hand (BOH Data).~r~r" + Errors
		FileWrite(gilogFileNo,lsLogOut)
  	 RETURN - 1
	END IF

	lirc = ldsboh.SetTransobject(sqlca)

	// 02/07 - PCONKL - Create the Ready To Ship Stock Datastore - added into Available stock below
	ldsReady = Create Datastore
	sql_syntax = "SELECT sku, Delivery_Picking.inventory_type, quantity  " 
	sql_syntax += " From Delivery_Master, Delivery_Picking"
	sql_syntax += " Where Delivery_Master.do_no = Delivery_Picking.do_no and Project_ID = 'Powerwave' and ord_status = 'R' and l_code <> 'N/A' " /* don't include parent placeholders (loc = 'N/A') */
	sql_syntax += " and Delivery_Master.Wh_Code in (" + lsWarehouse + ") "
	ldsReady.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

	IF Len(ERRORS) > 0 THEN
 	  lsLogOut = "        *** Unable to create datastore for Powerwave Balance on Hand (Ready to Ship Data).~r~r" + Errors
		FileWrite(gilogFileNo,lsLogOut)
 	  RETURN - 1
	END IF

	ldsReady.SetTransObject(SQLCA)
	
	lsProject = ProfileString(asInifile,'POWERWAVE',"project","")

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq < 0 Then Return -1

	//Retrive the BOH Data
	lsLogout = 'Retrieving Balance on Hand Data.....'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(giLogFileNo,lsLogOut)

	ldsBOH.Retrieve() /*does not include any Stock in Ready status */

	// 02/07 - PCONKL - Retrieve Pick Rows for orders in Ready To Ship and add to BOH data
	llRowCount = ldsReady.Retrieve()
	For llRowPos = 1 to llRowCount
	
		//See if we have a boh row
		lsFind = " Upper(SKU) = '" + Upper(ldsready.GetITemString(llRowPos, 'sku'))
		lsFind += "' and Upper(inventory_type) = '" + Upper(ldsready.GetITemString(llRowPos, 'inventory_type')) + "'"
		llFindRow = ldsBOH.Find(lsFind,1,ldsBOH.RowCount())
	
		If llFindRow > 0 Then /* add to qty*/
			ldsBOH.SetITem(llFindRow,'total_qty', ldsBOH.getITEmNumber(llFindRow,'total_qty') + ldsReady.GetItemNumber(lLRowPos,'quantity'))
		Else /*add a new BOH Row*/
		
			llnewRow = ldsBOH.InsertRow(0)
			ldsBOH.SetITem(llNewRow,'sku',ldsReady.getITemString(llRowPos,'sku'))
			ldsBOH.SetITem(llNewRow,'inventory_type',ldsReady.getITemString(llRowPos,'inventory_type'))
			ldsBOH.SetITem(llNewRow,'total_qty',ldsReady.getITemNumber(llRowPos,'quantity'))
		
		End If
	
	Next /* Ready to ship row */


	llRowCount = ldsBOH.RowCount()

	lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(gilogFileNo,lsLogOut)

	//Write the rows to the generic output table - delimited by '~t'
	lsLogOut = 'Processing Balance on Hand Data.....'
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	FileWrite(gilogFileNo,lsLogOut)


	For llRowPos = 1 to llRowCOunt
	
		llNewRow = ldsOut.insertRow(0)
		lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	//	lsOutString += 'MER|' /*Defaulting for now*/
		lsOutString += lsPowerwaveWarehouse + '|' /* 12/07 - PCONKL - supporting multiple warehouses */
		lsOutString += Upper(ldsboh.GetItemString(llRowPos,'inventory_type')) + '|'
	
		lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),50) + '|'
		lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'############0')
		
		ldsOut.SetItem(llNewRow,'Project_id', lsproject)
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		ldsOut.SetItem(llNewRow,'file_name', 'BH' + String(ldbatchSeq,'000000') + ".DAT")
	
	Next /*next output record */


	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"Powerwave")


	//Set the next time to run if freq is set in ini file
	
	Choose Case J
			
		Case 1 /*Eersel*/
			
			lsRunFreq = ProfileString(asIniFile,'Powerwave','DBOHFREQ','')
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE','')
			End If
				
		Case 2 /*Suzhou*/
			
			lsRunFreq = ProfileString(asIniFile,'Powerwave','DBOHFREQ-SUZ','')
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-SUZ',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-SUZ','')
			End If
		
		Case 3 /*PCH*/
			
			lsRunFreq = ProfileString(asIniFile,'Powerwave','DBOHFREQ-PCH','')
			If isnumber(lsRunFreq) Then
				ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-PCH',String(ldtNextRunDate,'mm-dd-yyyy'))
			Else
				SetProfileString(asIniFile,'Powerwave','DBOHNEXTDATE-PCH','')
			End If		
		
		
		
		End Choose
		
		Destroy	ldsOut
		Destroy ldsBOH
		Destroy LDSReady
	
	
Next /*warehouse to process*/



Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Powerwave

Datastore	ldsDOHeader, ldsDODetail,	ldsDOAddress, 	lu_ds, ldsDONotes, ldsDOBOM
				
String		lsLogout, lsRecData, lsTemp,lsErrText, lsSKU, lsRecType, lswarehouse, lsSupplier,	lsChildSKU,	lsFind,	&
				lsBillToName, lsBillToAddr1, lsBillToADdr2, lsBillToADdr3,  lsBillToAddr4, lsBillToStreet, lsDetailID,	&
				lsBillToZip, lsBillToCity, lsBillToState, lsBillToCountry, lsBillToTel, lsOrdType, lsNoteText,  lsTempNoteText, lsOrder, lsNoteType,	&
				lsCarrierCode, lsTransportMode, lsShipRef, lsShipVia, lsImporterName, lsImporterAddr1, lsImporteraddr2, lsImporterTel

String		 lsOnBehalfofName, lsOnBehalfofAddress1, lsOnBehalfofAddress2, lsOnBehalfofCity, lsOnBehalfofState, lsOnBehalfofPostal, lsOnBehalfofCountry, lsOnBehalfofTelephone



Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos, llNewRow, llCount, llQty, llChildQty, llNewNotesRow,	llNewBOMRow, llPos, llBOMLine, &
				llCONO, llRoNO,  llOwner, llNewAddressRow, llFindRow, llBatchSeq, llOrderSeq, llLineSeq, llNoteSeq, llOracleLine, llNoteLine, lLDetailFindROw
				
Decimal		ldQty
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError, lbBillToAddress, lbDM, lbDD, lbImporterAddress, lbOnBehalfofAddress
Blob			lbAnsiBlob, lblb_wide_chars

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

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)

ldsDOBOM = Create u_ds_datastore
ldsDOBOM.dataobject = 'd_delivery_bom'
ldsDOBOM.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//$$HEX2$$b7000900$$ENDHEX$$Append! - (Default) Write data to the end of the file$$HEX2$$b7000900$$ENDHEX$$Replace! - Replace all existing data in the fileWritemode is ignored if the fileaccess argument is Read!
//encoding 	Character encoding of the file you want to create. Specify this argument when you create a new text file using text or line mode. If you do not specify an encoding, the file is created with ANSI encoding. Values are:$$HEX2$$b7000900$$ENDHEX$$EncodingANSI! (default)$$HEX2$$b7000900$$ENDHEX$$EncodingUTF8!$$HEX2$$b7000900$$ENDHEX$$EncodingUTF16LE!$$HEX2$$b7000900$$ENDHEX$$EncodingUTF16BE!



liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Powerwave Processing: " + asPath
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

//Import file 
//llRowCount = lu_ds.ImportFile(text!,asPath,1,99999,1,99999,2)

////Warehouse will have to be defaulted from project master default warehouse
//12/07 - PCONKL - no longer defaulting since we have multiple mwarehouses (Suzhou added )

//Select wh_code into :lswarehouse
//From Project
//Where Project_id = :asProject;

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()


//Process each Row
For llRowPos = 1 to llRowCount 
	
	//Need to convert from Unicode to ANSI - First from utf-8 to utf-16 because FromUnicode() only works for utf-16
	
	//NOt sure if file is Unicode or not - only is if there are Swedish Characters
	//Unicode files have 2 char extra at beginning of file. Assume (I Know!) if first 2 chars are not 'DM', then it is a Unicode file and strip off those extra chars
	
	If llRowPos = 1 and left(lu_ds.GetITemString(llRowPos,'rec_data'),2) <> 'DM' Then 
		lsRecData = Mid(Trim(lu_ds.GetITemString(llRowPos,'rec_data')),3,99999)
	Else
		lsRecData = Trim(lu_ds.GetITemString(llRowPos,'rec_data'))
	End If
	
	
	// Convert utf-8 to utf-16 
	// Return the numbers of Wide Chars 
  	liRC = MultiByteToWideChar(65001, 0, lsRecData, -1, lblb_wide_chars, 0) 
  	IF liRC > 0 THEN 
		
			// Reserve Unicode Chars 
			lblb_wide_chars = blob( space( (liRC+1)*2 ) ) 
	
			// Convert UTF-8 to UTF-16 
			liRC = MultiByteToWideChar(65001, 0, lsRecData, -1, lblb_wide_chars, (liRC+1)*2 ) 
	
			// Convert UTF-16 to ANSI 
			lsRecData = FromUnicode( lblb_wide_chars )         
			
	
  	END IF 

//	if llRowPos = 1 then Messagebox ("ok2", lsRecData) 
	lsRecType = Left(lsRecData,2)
	
	//Process header or Detail */
	Choose Case Upper(lsRecType)
			
		//HEADER RECORD
		Case 'DM' /* Header */

			llnewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
						
			//Record Defaults
			ldsDOHeader.SetItem(llNewRow,'ACtion_cd','A') /*always a new Order*/
			ldsDOHeader.SetITem(llNewRow,'project_id',asProject) /*Project ID*/
			//ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse) /*Default WH for Project */
			ldsDOHeader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
			ldsDOHeader.SetItem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDOHeader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow,'ftp_file_name',aspath) /*FTP File Name*/
			ldsDOHeader.SetItem(llNewRow,'Status_cd','N')
			ldsDOHeader.SetItem(llNewRow,'Last_user','SIMSEDI')
						
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */
			
			//From File...
			
			// Action Code 
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Change ID' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'action_Cd',lsTemp)
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Warehouse
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Warehouse' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			//Should be hardcoded as 'MER' for now...
			//12/07 - PCONKL - 'MSZ' valid for Suzhou warehouse
			//6/12 - MEA - Added 'PCH'
			If lsTemp = 'MER'  Then
				lsWarehouse = "PWAVE-FG" /*eersel*/
			ElseIf lsTemp = 'MSZ' Then /*Suzhou */
				lsWarehouse = "PWAVE-SUZ"
			ElseIf lsTemp = 'PCH' Then /*PCH*/
				lsWarehouse = "PWAVE-SBLC"				
			Else /*invalid*/
				lsWarehouse = lsTemp
				lbError = True
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
			End If
			
			ldsDOHeader.SetItem(llNewRow,'wh_Code',lsWarehouse) 
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			lsOrder = lsTemp
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Sales Order Number -> UF6
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Sales Order Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'user_field6',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
						
			//Delivery Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Date' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'request_Date',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Goods Issue Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Goods Issue Date' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'schedule_Date',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
				
			
			//Cust Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'cust_Code',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Code' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery ORder Type - Validate from Table, If not valid, default to 'S'
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Type' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			lsOrdType = Trim(lsTemp)
			
			Select Count(*) into :llCount
			FRom Delivery_Order_Type
			Where Project_id = :asProject and ord_type = :lsOrdType;
			
			If llCount > 0 Then
				ldsDOHeader.SetItem(llNewRow,'order_Type',lsOrdType)
			Else
				ldsDOHeader.SetItem(llNewRow,'order_Type','S') /*default to SALE */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer PO - Customer Order NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer PO Number' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If

			ldsDOHeader.SetItem(llNewRow,'Order_No',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//carrier - This is actually the carrier Name, get the Carrier Code, Transport Mode, Ship VIA and Ship Ref
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Carrier' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			lsCarrierCOde = ""
			lsShipVia = ""
			lsShipRef = ""
			lsTransportMode = ""
			
			Select Carrier_Code, Ship_Via, Ship_ref, transport_Mode
			Into	:lsCarrierCode, :lsShipVia, :lsShipRef, :lsTransportMOde
			From Carrier_Master
			Where Project_id = "Powerwave" and Carrier_Name = :lsTemp;
			
			If lsCarrierCode > "" Then
				ldsDOHeader.SetItem(llNewRow,'Carrier',lsCarrierCode)
				ldsDOHeader.SetItem(llNewRow,'ship_via',lsShipVia)
				ldsDOHeader.SetItem(llNewRow,'ship_ref',lsShipRef)
				ldsDOHeader.SetItem(llNewRow,'Transport_Mode',lsTransportMode)
			Else
				ldsDOHeader.SetItem(llNewRow,'Carrier',"SEE ROUTING GUIDE") /*default to routing guide*/
				ldsDOHeader.SetItem(llNewRow,'Ship_ref',"SEE POWERWAVE ROUTING GUIDE") /*default to routing guide*/
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Incoterms -> UF7
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Incoterms' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'User_Field7',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Payment terms -> UF4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Payment Terms' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'User_Field4',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Freight Terms
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Freight Terms' field. Order will not be processed.")
				ldsDOHeader.SetItem(llNewRow,'status_cd','E') /*Don't want to process this header in the next step*/
				lbError = True
			End If
			
			ldsDOHeader.SetItem(llNewRow,'freight_terms',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
						
			//Ship to Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'Cust_Name',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			ldsDOHeader.SetItem(llNewRow,'address_1',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//*** No more required fields...
			
			
			//Ship to Address 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_3',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_4',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'City',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'state',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Postal Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'zip',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Country',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Telephone
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'tel',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			 //If we have Bill to information, we will need to build an Alt Address record
		 	lbBillToAddress = False
		 
		 	//Bill To Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToName = Trim(lsTemp)
			Else
				lsBillToName = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		 	//Bill To Addr1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr1 = Trim(lsTemp)
			Else
				lsBillToADdr1 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr2 = Trim(lsTemp)
			Else
				lsBillToADdr2 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr3 = Trim(lsTemp)
			Else
				lsBillToADdr3 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Addr4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToADdr4 = Trim(lsTemp)
			Else
				lsBillToADdr4 = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		 				
			//Bill To City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCity = Trim(lsTemp)
			Else
				lsBillToCity = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToState = Trim(lsTemp)
			Else
				lsBillToState = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Zip
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToZip = Trim(lsTemp)
			Else
				lsBillToZip = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillToCountry = Trim(lsTemp)
			Else
				lsBillToCountry = ''
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Bill To Tel
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbBillToAddress = True
				lsBillTotel = Trim(lsTemp)
			Else
				lsBillTotel = ''
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Shipping Instructions - Powerwave is replacing carriage returns with a tilde as to not f up our import 
			// To display in Delivery Order, replace with a space - no need for new lines.
			// For Pack list, we need to add lines - since we are already concatonating with Header Delivery Notes, just add a header Note here with the New Line
			
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				
				lsNoteText = lsTemp
			
				llPOs = Pos(lsNoteText,"~~")
				Do While llPos  > 0
				
					lsTempNoteText = Left(lsNoteText,(llPos - 1))
				
					llNewNotesRow = ldsDONotes.InsertRow(0)
					ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
					ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
					ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
					llNoteSeq ++
					ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
			
					ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
					ldsDONotes.SetItem(llNewNotesRow,'note_type',"H")
					ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
					ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsTempNoteText)
				
					lsNoteText = Right(lsNoteText,(len(lsNoteText) - llPos))
					llPOs = Pos(lsNoteText,"~~")
				
				Loop
			
				If lsNoteText > "" Then /*last/Only*/
			
					llNewNotesRow = ldsDONotes.InsertRow(0)
					ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
					ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
					ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
					llNoteSeq ++
					ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
			
					ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
					ldsDONotes.SetItem(llNewNotesRow,'note_type',"H")
					ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
					ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsNoteText)
				
				End If
				
				//For Shipping Instructions, Replace any Tildes (~) with blank.
				lsNoteText = lsTemp
				llPos = Pos(lsNoteText,"~~")
				Do While  llPos > 0
					lsNoteText = Replace(lsNoteText,llPos,1," ")
					llPos ++
					If llPos > Len(lsNoteText) Then
						llPos = 0
					Else
						llPos = Pos(lsNoteText,"~~",llPos)
					End If
				Loop
				
				ldsDOHeader.SetItem(llNewRow,'shipping_instructions_Text',lsNoteText)
				
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			 //If we have Importer information, we will need to build an Alt Address record
		 	lbImporterAddress = False
		 
		 	//Importer Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbImporterAddress = True
				lsImporterName = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		 	//Importer Addr1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbImporterAddress = True
				lsImporterADdr1 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Importer Addr2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbImporterAddress = True
				lsImporterADdr2 = Trim(lsTemp)
			End If
			
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Importer Tel
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbImporterAddress = True
				lsImporterTel = Trim(lsTemp)
			End If		
			

			//Start On Behalf of

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			 //If we have On Behalf of information, we will need to build an Alt Address record
		 	lbOnBehalfofAddress = False
		 
		 	//On Behalf of Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If

			
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofName = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
		 	//On Behalf of Addr1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofAddress1 = Trim(lsTemp)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//On Behalf of Addr2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofAddress2 = Trim(lsTemp)
			End If

			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//On Behalf of City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofCity = Trim(lsTemp)
			End If			
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//On Behalf of State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofState = Trim(lsTemp)
			End If				

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//On Behalf of Postal
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofPostal = Trim(lsTemp)
			End If						

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//On Behalf of Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofCountry = Trim(lsTemp)
			End If					

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//On Behalf of Telephone
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			If lsTemp > '' Then
				lbOnBehalfofAddress = True
				lsOnBehalfofTelephone = Trim(lsTemp)
			End If					
			
			//lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */			
			
					
			
			//If we have Bill To Information, create the Alt Address record
			If lbBillToAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
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
			
			//If we have Importer Information, create the Alt Address record
			If lbImporterAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','IM') /* Importer Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsImporterName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsImporterAddr1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsImporterAddr2)
				ldsDOAddress.SetItem(llNewAddressRow,'tel',lsImporterTel)
				
			End If /*alt address exists*/
	
				//If we have On Behalf of Information, create the Alt Address record
			If lbOnBehalfofAddress Then
				
				llNewAddressRow = ldsDOAddress.InsertRow(0)
				ldsDOAddress.SetITem(llNewAddressRow,'project_id',asProject) /*Project ID*/
				ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
				ldsDOAddress.SetItem(llNewAddressRow,'address_type','OB') /* Importer Address */
				ldsDOAddress.SetItem(llNewAddressRow,'Name',lsOnBehalfofName)
				ldsDOAddress.SetItem(llNewAddressRow,'address_1',lsOnBehalfofAddress1)
				ldsDOAddress.SetItem(llNewAddressRow,'address_2',lsOnBehalfofAddress2)
				ldsDOAddress.SetItem(llNewAddressRow,'city',lsOnBehalfofCity)
				ldsDOAddress.SetItem(llNewAddressRow,'state',lsOnBehalfofState)
				ldsDOAddress.SetItem(llNewAddressRow,'zip',lsOnBehalfofPostal)		
				ldsDOAddress.SetItem(llNewAddressRow,'country',lsOnBehalfofCountry)						
				ldsDOAddress.SetItem(llNewAddressRow,'tel',lsOnBehalfofTelephone)
			
				
				
			End If /*On Behalf of exists*/
	
	
				
		// DETAIL RECORD
		Case 'DD' /*Detail */

			
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++ /*also used for Line_Item_No in Detail record*/
						
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			//ldsDODetail.SetITem(llNewRow,'Inventory_Type', 'N')
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
									
			lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */

			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'invoice_no',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				Continue /*Process Next Record */
			End If
			
			
			//Make sure we have a header for this Detail...
			If ldsDOHeader.Find("Upper(invoice_no) = '" + Upper(lstemp) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Detail Order Number does not match header ORder Number. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Item Number - May be duplicate, assign a sequential number and store Oracle Line item in UF5
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					llOracleLine = Long(Trim(lsTemp))
					ldsDODetail.SetItem(llNewRow,'line_item_no',llLineSeq) /*sequential number per order*/
					ldsDODetail.SetItem(llNewRow,'User_field5',String(llOracleLine)) /*Oracle LIne Item Number*/
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Line Item Number is not numeric. Row will not be processed")
					lbError = True
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Number' field. Record will not be processed.")
				lbError = True
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//SKU (Parent)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'SKU',Trim(lsTemp))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Parent SKU' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
							
			lsSKU = Trim(lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//SKU (Child)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Child SKU' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsChildSKU = Trim(lsTemp)
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			
			//Quantity (Parent)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'quantity',Trim(lsTemp))
					llqty = long(lstemp)
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - (Parent) Quantity is not numeric. Row will not be processed")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after '(Parent) Quantity' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Quantity (Child) - This is the total child qty (Not the Unit qty per parent)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					
					//Convert to unit qty (total child qty/ parent qty)
					llChildqty = long(lstemp) / llQty
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - (Child) Quantity is not numeric. Row will not be processed")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after '(Child) Quantity' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Inventory _type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If Not isNull(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'Inventory_Type',Trim(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - No delimiter found after 'Inventory Type' field. Record will not be processed.")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Price (External)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'price',Trim(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Price is not numeric. Row will not be processed")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Price' field. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Currency (external) -> UF3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If Not isNull(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'user_Field3',Trim(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - No delimiter found after 'Currency' field. Record will not be processed.")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				End If
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			If lsTemp = "" Then
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - 'Currency' is Required. Record will not be processed.")
				ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
				lbError = True
				Continue /*Process Next Record */
			End If
			
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// No more required fields after this point
			
			//Customer PO Line - Mapped to User Field 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'user_field2',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer SKU - Mapped to User Field 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'User_Field1',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//"Delivery Detail ID" -> UF 8 - Also need to write it to Delivery BOM for children items
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'User_Field8',Trim(lsTemp))
			lsDetailID = lsTemp /*need to copy to Delivery BOM for kitted parts*/
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Lot No (LPN)
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'lot_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no',Trim(lsTemp))
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no2',Trim(lsTemp))
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */

			//Serial Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
					
			ldsDODetail.SetItem(llNewRow,'Serial_No',Trim(lsTemp))
			
			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//"legacy SKU" - UF4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
					
			ldsDODetail.SetItem(llNewRow,'user_field4',Trim(lsTemp))
			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//12/07 - PCONKL - Added Internal Price and Currency
			
			//Internal Price - UF6
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
					
			//If present, Must be numeric
			If lsTemp > "" Then
				
				If NOt isnumber(lsTemp) Then
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - 'Internal Price' is not numeric (" + lstemp + "). Record will not be processed.")
					ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
					lbError = True
					Continue /*Process Next Record */
				Else
					ldsDODetail.SetItem(llNewRow,'user_field6',Trim(lsTemp))
				End If
				
			End If
						

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			

			//"Internal Currency -> UF7
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
					
			ldsDODetail.SetItem(llNewRow,'user_field7',Trim(lsTemp))
			

			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//If Child SKU <> Parent SKU, we need to create a A delivery_Bom record for the child...
			If lsChildSku <> lsSKu Then
				
				// We want to use the Line ITem Nmber that we assigned and not the Oracle line - Use Oracle line in UF 5 to find our line
				//We want to reject this order if Oracle has split a kitted line (same Order/Line/parent & Child SKU)
				
				//Map the Oracle Line 
				llDetailFindRow =  ldsDODetail.Find("User_field5 = '" + string(llOracleLine) + "' and Upper(sku) = '" + Upper(lsSKU) + "' and upper(invoice_No) = '" + Upper(lsOrder) + "'",1,ldsDoDetail.RowCount()) 
				If llDetailFindRow > 0 Then
					
					llBomLine = ldsDoDetail.GetITemNumber(llDetailFindRow, 'Line_item_No')
					
					//See if BOM record is a Dup
					lsFind = "order_seq_no = " + String(llOrderSeq) + " and sku_parent = '" + lsSKU + "' and sku_child = '" + lsChildSku + "' and Line_item_No = " + String(llBomLine)
					
					If ldsDOBom.Find(lsFind,1,ldsDOBom.RowCount()) > 0 Then /*Dup*/
						
						gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) +  " Split BOM row detected. Order will not be processed.")
						ldsDOHeader.SetItem(ldsDOHeader.RowCount(),'status_cd','E') /*Don't want to process this header in the next step*/
						ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
						lbError = True
						Continue /*Process Next Record */
						
					Else
						
						//Insert a new BOM LIne
						llNewBOMRow = ldsDOBOM.InsertRow(0)
						ldsDOBOM.SetITem(llNewBOMRow,'project_id',asProject) 
						ldsDOBOM.SetItem(llNewBOMRow,'edi_batch_seq_no',llbatchseq) 
						ldsDOBOM.SetItem(llNewBOMRow,'order_seq_no',llOrderSeq) 
						ldsDOBOM.SetItem(llNewBOMRow,'line_item_no',llBomLine) 
						ldsDOBOM.SetItem(llNewBOMRow,'sku_parent',lsSKU) 
						ldsDOBOM.SetItem(llNewBOMRow,'sku_child',lsChildSku) 
						ldsDOBOM.SetItem(llNewBOMRow,'child_Qty',llChildQty) 
						ldsDOBOM.SetItem(llNewBOMRow,'user_field1',lsDetailID) /*Delivery Detail ID */
				
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
							ldsDODetail.SetItem(llNewRow,'status_cd','E') /*Don't want to process record in next step*/
							ldsDOBOM.DeleteRow(llNewBomRow)
							lbError = True
							Continue /*Process Next Record */
						End If
						
					End If /*BOM exists*/
					
					//We don't want to write more than 1 detail line per parent
					If ldsDODetail.RowCount() > 1 Then
						
						If ldsDoDetail.GetItemString(llNewRow,'invoice_no') = ldsDoDetail.GetItemString((llNewRow - 1),'invoice_no') and &
							ldsDoDetail.GetItemString(llNewRow,'Sku') = ldsDoDetail.GetItemString((llNewRow - 1),'Sku') and &
							ldsDoDetail.GetItemString(llNewRow,'User_Field5') = ldsDoDetail.GetItemString((llNewRow - 1),'User_Field5') Then
							
								ldsDoDetail.DeleteRow(llNewRow) 
							
						End If
						
					End If
							
				End If /*Detail exists*/
				
			End If /*Child SKU */
		
		

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
			If ldsDOHeader.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "'",1,ldsDOHeader.RowCount()) = 0 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Order Number does not match header ORder Number. Note Record will not be processed (Delivery Order will still be loaded)..")
				Continue
			End If
		
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Note Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Note Type' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			lsNoteType= lsTemp
			
			//Validate Note Type
			If lsNoteType = 'H' or lsNoteType = 'L' or lsNoteType = 'F' Then
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Note Type: '" + lsNoteType + "'. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
						
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Line Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If

			If isNumber(lsTemp) Then
				llNoteLine = Long(lsTemp)
			Else
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Delivery Notes 'Line Item' is not numeric: '" + lsTemp + "'. Note Record will not be processed (Delivery Order will still be loaded)..")
				lbError = True
				Continue
			End If
			
			//If a detail note, Make sure we have a detail record for this note (Oracle LIne ITem in UF5)...
			If lsNoteType = 'L' Then
				If ldsDODetail.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "' and User_Field5 = '" + String(llNoteLine) + "'",1,ldsDODetail.RowCount()) = 0 Then
					gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Notes Line Number does not match Detail Line Number. Note Record will not be processed (Delivery Order will still be loaded)..")
					Continue
				End If
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
			//Note Sequence - ignoring -using our sown seq so we can split lines if necessary
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Number' field. Note Record will not be processed (Delivery Order will still be loaded)..")
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
			
			//Oracle Line Item in UF 5, find corresponding Detail Row Line Number
			lLDetailFindRow = ldsDODEtail.Find("invoice_no = '" + lsOrder + "' and User_Field5 = '" + String(llNoteLine) + "'",1, ldsDODetail.RowCount())
			If lLDetailFindROw > 0 Then
				llNoteLine = Long(ldsDoDetail.GetITemString(lLDetailFindRow,'USer_Field5'))
			End If
			
			llPOs = Pos(lsNoteText,"~~")
			Do While llPos  > 0
				
				lsTempNoteText = Left(lsNoteText,(llPos - 1))
				
				llNewNotesRow = ldsDONotes.InsertRow(0)
				ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
				llNoteSeq ++
				ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNoteSeq) /*Using our own sequential number so we can start a new row when we hit a ~ */
			
				ldsDONotes.SetItem(llNewNotesRow,'invoice_no',lsOrder)
				ldsDONotes.SetItem(llNewNotesRow,'note_type',lsNoteType)
				ldsDONotes.SetItem(llNewNotesRow,'line_item_no',llNoteLine)
				ldsDONotes.SetItem(llNewNotesRow,'note_Text',lsTempNoteText)
				
				lsNoteText = Right(lsNoteText,(len(lsNoteText) - llPos))
				llPOs = Pos(lsNoteText,"~~")
				
			Loop
			
			If lsNoteText > "" Then /*last/Only*/
			
				llNewNotesRow = ldsDONotes.InsertRow(0)
				ldsDONotes.SetITem(llNewNotesRow,'project_id',asProject) /*Project ID*/
				ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
				ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			
				llNoteSeq ++
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
			
	End Choose /*Header or Detail */
	
Next

SQLCA.DBParm = "disablebind =0"

//Save Changes
liRC = ldsDOHeader.Update()

SQLCA.DBParm = "disablebind =1"

If liRC = 1 Then
	liRC = ldsDODetail.Update()
End If

If liRC = 1 Then
	SQLCA.DBParm = "disablebind =0"	
	liRC = ldsDOAddress.Update()
	SQLCA.DBParm = "disablebind =1"	
End If

If liRC = 1 Then
	liRC = ldsDONotes.Update()
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

public function integer uf_process_itemmaster (string aspath, string asproject);
//Process Item Master (IM) Transaction for Powerwave


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
	lsLogOut = "-       ***Unable to Open Item Master File for Powerwave Processing: " + asPath
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
	
//	ldsItem.SetFilter("")
//	ldsItem.Filter()
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))

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
		Where Project_id = :asProject and Supp_code = :lsTemp;
		
		If llCount < 1 Then
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue
		
		End If
		
	End If

	//Retrieve for SKU - We will be updating across Suppliers
	llCount = ldsItem.Retrieve(asProject, lsSKU)
	
//	ldsItem.SetFilter("Upper(supp_code) = '" + Upper(lsSupplier) + "'")
//	ldsItem.Filter()
	
	llCount = ldsItem.RowCount()
		
	If llCount <= 0 Then
			
		//If No Supplier, we can't create a new record
		If lsSupplier = "" Then
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier not present. Unable to Insert new Item Master record for SKU: '" + lsSKU + "'")
			lbError = True
			Continue
			
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
			
		ldsItem.SetItem(1,'supp_code',lsTemp)
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
		
	//base UOM maps to UOM 1 
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


	//Net Weight maps to Weight 1
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


	//Weight UOM Maps to ????? 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	//ldsItem.SetItem(1,'???',left(lsTemp,4))
		
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Dimension UOM Maps to ????? 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	//ldsItem.SetItem(1,'???',left(lsTemp,4))
		
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	

	//Net Length maps to Length 1
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
	

	//Net Width maps to Width 1
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


	//Net Height maps to Height 1
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


	//Serialized Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	For llPos = 1 to ldsItem.RowCount()
		If lsTEmp = 'Y' Then
			//ldsItem.SetItem(llPos,'serialized_ind','O') /* Outbound */
			
			//MEA - As Per Jeff 10-15-2012
			
			ldsItem.SetItem(llPos,'serialized_ind','B')
		Else
			ldsItem.SetItem(llPos,'serialized_ind','N') 
		End If
	NExt
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	
	//Rev Part Nbr - Ignore (or remove??)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
		
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter


	//HTS Code -> UF9
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > "" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'User_Field9',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//License Number -> UF4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > "" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'User_Field4',lsTemp)
		Next
	End If
	
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Plain Langaue Description -> UF14
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsData
	End If
	
	If lsTEmp > "" Then
		For llPos = 1 to ldsItem.RowCount()
			ldsItem.SetItem(llPos,'User_Field14',lsTemp)
		Next
	End If
	
	
	//Update any record defaults
	For llPos = 1 to ldsItem.RowCount()
		ldsItem.SetItem(llPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llPos,'last_update',today())
	Next
		
	//If record is new...
	If lbNew Then
		ldsItem.SetItem(1,'lot_controlled_ind','Y') /*LPN Tracking on all items*/
		ldsItem.SetItem(1,'po_controlled_ind','N') 
		ldsItem.SetItem(1,'po_no2_controlled_ind','N')
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

public function integer uf_process_move_order (string aspath, string asproject);
String	lsLogOut, lsStringData, lsWarehouse, lsTemp, lsRecData, lsOrderNo, lsSupplier, lsSKU
Long		llNewRow, llRowPos, llRowCount, llOrderSeq, llLineSeq, llBatchSeq, llCount, llFindRow, llOwnerID, llNewDetailRow
Integer	liRC, liFileNo
Boolean	lbError, lbDetailError
DateTime	ldtToday
Datastore	lu_ds, ldsItem

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

//Open and read the File In
lsLogOut = '      - Opening File for Move Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Powerwave Processing: " + asPath
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
If llBatchSeq <= 0 Then 
	// pvh - 09/26/06 - empty error file
	lsLogOut = "-       ***Batch Sequence Number Error, EDI Inbound get next sequence. Project: " + asProject + ". Process Aborted."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	FileClose(liFileNo)
	Return -1
end if

//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	lsrecData = Trim(lu_ds.GetITemString(llRowPos,'rec_Data'))
	lsTemp = Left(lsRecData,2) /* rec type should be first 2 char of file*/	
	
	//Rec TYpe must be "MO"
	If lsTemp <> 'MO' Then
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Rec Type must be 'MO': '" + lsTemp + "'. Record will not be processed.") 
		Continue
	End If
		
	lsRecData = Right(lsRecData,(len(lsRecData) - 3)) /*strip off to first column after rec type */	

	
	//Warehouse 
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else 
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Warehouse' field. Record will not be processed.")
		lbError = True
		Continue
	End If
					
	If lsTemp = 'MER'  Then
		lsWarehouse = "PWAVE-FG" /*eersel*/
	ElseIf (lsTemp = 'MSZ' or lsTemp = 'SUZ'  or lsTemp = 'PCH') Then /*Suzhou */   /* MEA - 6/12 - Added PCH */
		lsWarehouse = "PWAVE-SUZ"
	Else /*invalid*/
		lsWarehouse = lsTemp
		lbError = True
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Warehouse: '" + lsTemp + "'. Order will not be processed.") 
	End If
			
	// can't set warehouse until after order is processed. We are only inserting a row when we know the order doesn't exist.
//	idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse) 
			
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
					
	//Order Number
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else 
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Order Number' field. Record will not be processed.")
		lbError = True
		Continue
	End If
	
	lsOrderNo = lsTemp
	
	//If Order doesn't exist in header, add it now
	llFindRow = idsPOHeader.Find("Upper(order_no) = '" + lsOrderNo + "'",1, idsPoHeader.RowCount())
	If llFindRow <= 0 Then /* new header needed */
		
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
		idsPOheader.SetItem(llNewRow,'Order_type','O') /*Move Order*/
		idsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
		idsPOheader.SetItem(llNewRow,'action_cd','A') /*always Add*/
		idsPOheader.SetItem(llNewRow,'wh_Code',lsWarehouse) /*extracted above*/
		idsPOheader.SetItem(llNewRow,'order_no',Trim(lsOrderNo))
		
	End If /* NEw Header*/
		
		
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
	
	
	//Supplier 
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else 
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue
	End If
		
	If lsTemp > '' Then
		lsSupplier = lsTemp /*used to build item master below if necessary*/
		idsPOheader.SetITem(llNewRow,'supp_code',lsTemp)
	End If
			
	lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			
	/* detail Fields - Always add a new detail row*/
	lbDetailError = False
	llNewDetailRow = 	idsPODetail.InsertRow(0)
	llLineSeq ++
					
	//Add detail level defaults
	idsPODetail.SetItem(llNewDetailRow,'order_seq_no',llOrderSeq) 
	idsPODetail.SetItem(llNewDetailRow,'project_id', asproject) /*project*/
	idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
	idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
	idsPODetail.SetItem(llNewDetailRow,'Action_cd', 'A') /*always Add */
	idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
	idsPODetail.SetItem(llNewDetailRow,"order_line_no",string(llLineSeq))
	idsPODetail.SetItem(llNewDetailRow,'line_item_No',llLineSeq) /*Line Item NUmber - powerwave's Line Item NUmber going in UF2*/
	
	idsPODetail.SetItem(llNewDetailRow,'Order_No',Trim(lsOrderNo))
	
				
			
	//Line Item Number - Needs to go in UF2 since it might be larger than 6. We will sequentially assign our own line item number
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
		idsPODetail.SetItem(llNewDetailRow,'User_Field2',lsTemp)
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
			
			
	//lot No (LPN)
	If Pos(lsRecData,'|') > 0 Then
		lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
	Else 
		lsTemp = lsRecData
	End If
						
	idsPODetail.SetItem(llNewDetailRow,'Lot_no',lsTemp)
					
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

public function integer uf_move_order_daily_summary ();Datastore	ldsheader, ldsGR, ldsroputaway, ldsOut, ldsRoDetail
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsLogOut, lsRONO, lsFind, lsOutString, lsFileName, lsToday, lsLineItem
Date	ldToday
Long	llheaderRowCount, llheaderRowPos, llPutawayPos, llPutawayCount, llFindRow, llNewRow, llOutCount, llOutPos
Decimal	ldBatchSeq
ldToday = Date(today())
lsToday = String(ldToday,"yyyy/mm/dd")

lsLogOut = "- PROCESSING FUNCTION: Powerwave Daily Move Order Receipt Summary!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create Receive Header Datastore...
ldsheader = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select ro_no, supp_invoice_no, Complete_Date, Ord_type from Receive_MAster " 
lsSql += "Where project_id = 'Powerwave' and Ord_status = 'C' and Ord_Type = 'O' and (file_transmit_ind is null or file_transmit_ind <> 'Y') "
//lsSql += "Where project_id = 'Powerwave' and Ord_status = 'C' and Ord_Type = 'O' and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date < '" + lstoday + "'"

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsheader.Create( dwsyntax_str, lsErrText)
ldsheader.SetTransObject(SQLCA)

ldsGR = Create Datastore
ldsGR.Dataobject = 'd_gr_layout'

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsroDetail = Create Datastore
ldsroDetail.Dataobject = 'd_ro_Detail'
ldsroDetail.SetTransObject(SQLCA)

ldsroputaway = Create Datastore
ldsroputaway.Dataobject = 'd_ro_Putaway'
ldsroputaway.SetTransObject(SQLCA)

	
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('Powerwave','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Summary Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lLHeaderRowCount = ldsheader.Retrieve()

lsLogOut = "    - " + String(llheaderRowCount) + " Orders retrieved for summary processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


For llheaderRowPOs = 1 to llheaderRowCount /*Each Order*/
	
	lsRONO = ldsHeader.GetITEmString(llheaderRowPOs,'ro_no')
	
	ldsgr.Reset()
	
	//Retrieve the Detail and Putaway records for ths order
	ldsRODetail.Retrieve(lsRONO)
	llPutawayCount = ldsRoPutaway.Retrieve(lsRONO)
		
	For llPutawayPos = 1 to llPutawayCount
	
		//Line Item is coming from Detail UF2
		llFindRow = ldsRODetail.Find("Line_Item_No = " + String(ldsROPutaway.GetItemNumber(llPutawayPos,'line_item_no')),1,ldsRODetail.RowCount())
		If llFindRow > 0 Then
			If ldsRoDetail.GetITemString(llFindRow,'User_Field2') > '' Then
				lsLineItem = ldsRoDetail.GetITemString(llFindRow,'User_Field2')
			Else
				lsLineItem = String(ldsROPutaway.GetItemNumber(llPutawayPos,'line_item_no'))
			End If
		Else
			lsLineItem = String(ldsROPutaway.GetItemNumber(llPutawayPos,'line_item_no'))
		End If
		
		//Roll up to Line/Inventory_Type/Lot (LPN)
		lsFind = "user_Field2 = " + lsLineItem 
		lsFind += " and Inventory_Type = '" + ldsROPutaway.GetItemString(llPutawayPos,'Inventory_Type') + "'"
		
		If ldsROPutaway.GetItemString(llPutawayPos,'lot_no') <> '-' Then
			lsFind += " and lot_no = '" + ldsROPutaway.GetItemString(llPutawayPos,'lot_no') + "'"
		End If
		
		llFindRow = ldsGR.Find(lsFind,1,ldsGR.RowCOunt())
		
		If llFindRow > 0 Then /*row already exists, add the qty*/
	
			ldsGR.SetItem(llFindRow,'quantity', (ldsGR.GetItemNumber(llFindRow,'quantity') + ldsROPutaway.GetItemNumber(llPutawayPos,'quantity')))
		
		Else /*not found, add a new record*/
		
			llNewRow = ldsGR.InsertRow(0)
				
			ldsGR.SetItem(llNewRow,'quantity',ldsROPutaway.GetItemNumber(llPutawayPos,'quantity'))
			ldsGR.SetItem(llNewRow,'user_field2',lsLineItem)
			ldsGR.SetItem(llNewRow,'Inventory_Type',ldsROPutaway.GetItemString(llPutawayPos,'Inventory_Type'))
			ldsGR.SetItem(llNewRow,'sku',ldsROPutaway.GetItemString(llPutawayPos,'sku'))
			
			If ldsROPutaway.GetItemString(llPutawayPos,'lot_no') <> '-' Then
				ldsGR.SetItem(llNewRow,'lot_no',ldsROPutaway.GetItemString(llPutawayPos,'lot_no'))
			Else
				ldsGR.SetItem(llNewRow,'lot_no','')
			End If
			
		End If
	
	Next /*Putaway*/
	
	//Write to output file...
	llOutCount = ldsGR.RowCount()
		
	For llOutPos = 1 to llOutCount
	
		llNewRow = ldsOut.insertRow(0)
	
		lsOutString = 'OM|' /*rec type = Move Order receipt Summary*/
		lsOutString += 'MSZ|' /*warehouse hardcoded for Suzhou for now */
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'supp_invoice_no') + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'User_Field2') + '|' /*User Line Item */
		lsOutString += ldsGR.GetItemString(llOutPos,'sku') + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'Inventory_Type') + '|'
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'quantity')) + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'lot_no')  /* LPN */
		
		
		ldsOut.SetItem(llNewRow,'Project_id', 'POWERWAVE')
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'om' + String(ldBatchSeq,'00000000') + '.dat'
		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	Next /*Output record*/
	
Next /*Order*/

//write the data
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'POWERWAVE')
End If


//Update the file transmit ind to show sent
//Update Receive_Master set file_transmit_ind = 'Y' Where project_id = 'Powerwave' and Ord_status = 'C' and Ord_Type = 'O' and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date < :lsToday;
Update Receive_Master set file_transmit_ind = 'Y' Where project_id = 'Powerwave' and Ord_status = 'C' and Ord_Type = 'O' and (file_transmit_ind is null or file_transmit_ind <> 'Y');
Commit;

Return 0
end function

public function integer uf_daily_receipt_summary (string aswarehouse);Datastore	ldsheader, ldsGR, ldsroputaway, ldsOut
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsLogOut, lsRONO, lsFind, lsOutString, lsFileName, lsToday
Date	ldToday
Long	llheaderRowCount, llheaderRowPos, llPutawayPos, llPutawayCount, llFindRow, llNewRow, llOutCount, llOutPos
Decimal	ldBatchSeq
ldToday = Date(today())
lsToday = String(ldToday,"yyyy/mm/dd")

lsLogOut = "- PROCESSING FUNCTION: Powerwave Daily Receipt Summary!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create Receive Header Datastore...
ldsheader = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select ro_no, supp_invoice_no, Complete_Date, Ord_type from Receive_MAster " 
lsSql += "Where project_id = 'Powerwave' and Ord_status = 'C' and Ord_Type in('P', 'I') and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date < '" + lstoday + "'"
lsSql += " and wh_code = '" + asWarehouse + "'"

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
	
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('Powerwave','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Summary Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lLHeaderRowCount = ldsheader.Retrieve()

lsLogOut = "    - " + String(llheaderRowCount) + " Orders retrieved for summary processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


For llheaderRowPOs = 1 to llheaderRowCount /*Each Order*/
	
	lsRONO = ldsHeader.GetITEmString(llheaderRowPOs,'ro_no')
	
	ldsgr.Reset()
	
	//Retrieve the Putaway records for ths order
	llPutawayCount = ldsRoPutaway.Retrieve(lsRONO)
		
	For llPutawayPos = 1 to llPutawayCount
	
		//Roll up to Line/Lot (LPN)
		lsFind = "po_item_number = " + string(ldsROPutaway.GetItemNumber(llPutawayPos,'line_item_no'))
		If ldsROPutaway.GetItemString(llPutawayPos,'lot_no') <> '-' Then
			lsFind += " and lot_no = '" + ldsROPutaway.GetItemString(llPutawayPos,'lot_no') + "'"
		End If
		llFindRow = ldsGR.Find(lsFind,1,ldsGR.RowCOunt())
		
		If llFindRow > 0 Then /*row already exists, add the qty*/
	
			ldsGR.SetItem(llFindRow,'quantity', (ldsGR.GetItemNumber(llFindRow,'quantity') + ldsROPutaway.GetItemNumber(llPutawayPos,'quantity')))
		
		Else /*not found, add a new record*/
		
			llNewRow = ldsGR.InsertRow(0)
				
			ldsGR.SetItem(llNewRow,'quantity',ldsROPutaway.GetItemNumber(llPutawayPos,'quantity'))
			ldsGR.SetItem(llNewRow,'po_item_number',ldsROPutaway.GetItemNumber(llPutawayPos,'line_item_no'))
			
			If ldsROPutaway.GetItemString(llPutawayPos,'lot_no') <> '-' Then
				ldsGR.SetItem(llNewRow,'lot_no',ldsROPutaway.GetItemString(llPutawayPos,'lot_no'))
			Else
				ldsGR.SetItem(llNewRow,'lot_no','')
			End If
			
		End If
	
	Next /*Putaway*/
	
	//Write to output file...
	llOutCount = ldsGR.RowCount()
		
	For llOutPos = 1 to llOutCount
	
		llNewRow = ldsOut.insertRow(0)
	
		lsOutString = 'RG|' /*rec type = goods receipt Summary*/
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'yyyy-mm-dd') + '|'
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'supp_invoice_no') + '|'
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'po_item_number')) + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'lot_no') + '|'
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'quantity')) + '|'
		lsOutString += Right(lsRono,6) + '|'
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'ord_type') + '|'
		
		// 05/08 - Added Warehouse
		// 6/12 - MEA - Added 'PCH'
		
		CHOOSE CASE Upper(asWarehouse) 
		CASE 'PWAVE-SUZ' 
			lsOutString += 'MSZ'
		CASE 'PWAVE-SBLC' 
			lsOutString += 'PCH'			
		CASE Else
			lsOutString += 'MER'
		END Choose	
		
		ldsOut.SetItem(llNewRow,'Project_id', 'POWERWAVE')
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'rg' + String(ldBatchSeq,'00000000') + '.dat'
		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	Next /*Output record*/
	
Next /*Order*/

//write the data
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'POWERWAVE')
End If


//Update the file transmit ind to show sent
Update Receive_Master set file_transmit_ind = 'Y' Where project_id = 'Powerwave' and Ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date < :lsToday and wh_code = :asWarehouse;
Commit;

Return 0
end function

public function integer uf_daily_shipment_summary (string aswarehouse);
Datastore	ldsheader, ldsGR, ldsDODetail, ldsDOPicking, ldsDOPacking, ldsOut
String	presentation_str, lsSQl, dwsyntax_str, lsErrText, lsLogOut, lsDONO, lsFind, lsOutString, lsFileName, lsToday, lsLPN
Date	ldToday
Long	llheaderRowCount, llheaderRowPos, llPickPos, llPickCount, llFindRow, llNewRow, llOutCount, llOutPos
Decimal	ldBatchSeq
ldToday = Date(today())
lsToday = String(ldToday,"yyyy/mm/dd")

lsLogOut = "- PROCESSING FUNCTION: Powerwave Daily Shipment Summary!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create Delivery Header Datastore...
ldsheader = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select do_no, invoice_no, user_Field6, Complete_Date from Delivery_MAster " 
lsSql += "Where project_id = 'Powerwave' and Ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date <  '" + lstoday + "'"
lsSql  += " and wh_code = '" + asWarehouse + "'" /* 01/09 - PCONKL */

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

ldsDOPacking = Create Datastore
ldsDOPacking.Dataobject = 'd_do_Packing'
ldsDOPacking.SetTransObject(SQLCA)

ldsDODetail = Create Datastore
ldsDODetail.Dataobject = 'd_do_Detail'
ldsDODetail.SetTransObject(SQLCA)
	
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('Powerwave','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Summary Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lLHeaderRowCount = ldsheader.Retrieve()

lsLogOut = "    - " + String(llheaderRowCount) + " Orders retrieved for summary processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


For llheaderRowPOs = 1 to llheaderRowCount /*Each Order*/
	
	lsDONO = ldsHeader.GetITEmString(llheaderRowPOs,'do_no')
	
	ldsgr.Reset()
	
	//Retrieve the Detail, Picking and Packing records for this order
	ldsDoDetail.Retrieve(lsDONO)
	ldsDoPacking.Retrieve(lsDONO)
	
	llPickCount = ldsDOPicking.Retrieve(lsDONO)
		
	For llPickPos = 1 to llPickCount
		
		If ldsDOPicking.GetITemString(llPickPos,'Component_ind') <> 'Y' Then /*Don't include component Parents*/
	
			//LPN is coming from Packing Carton Nbr
			lsFind = "Line_Item_No = " + string(ldsDOPicking.GetItemNumber(llPickPos,'line_item_no'))
			llFindRow = ldsDoPacking.Find(lsFind,1,ldsDOPAcking.RowCount())
			If llFindRow > 0 Then
				lsLPN = ldsDOPacking.GetITemString(llFindRow,'carton_no')
			Else
				lsLPN = ""
			End If
			
			//Roll up to Line/Sku/Packing Carton (LPN)
			lsFind = "po_item_number = " + string(ldsDOPicking.GetItemNumber(llPickPos,'line_item_no'))
			lsFind += " and sku = '" + ldsDOPicking.GetItemString(llPickPos,'sku') + "'"
			lsFind += " and lot_no = '" + lsLPN + "'"
			
			llFindRow = ldsGR.Find(lsFind,1,ldsGR.RowCOunt())
		
			If llFindRow > 0 Then /*row already exists, add the qty*/
	
				ldsGR.SetItem(llFindRow,'quantity', (ldsGR.GetItemNumber(llFindRow,'quantity') + ldsDOPicking.GetItemNumber(llPickPos,'quantity')))
		
			Else /*not found, add a new record*/
		
				llNewRow = ldsGR.InsertRow(0)
				
				ldsGR.SetItem(llNewRow,'quantity',ldsDOPicking.GetItemNumber(llPickPos,'quantity'))
				ldsGR.SetItem(llNewRow,'po_item_number',ldsDOPicking.GetItemNumber(llPickPos,'line_item_no'))
				ldsGR.SetItem(llNewRow,'sku',ldsDOPicking.GetItemString(llPickPos,'sku'))
				ldsGR.SetItem(llNewRow,'lot_no',lsLPN)
							
			End If
			
		End If /*Not a component parent*/
	
	Next /*Pick*/
	
	//Write to output file...
	llOutCount = ldsGR.RowCount()
		
	For llOutPos = 1 to llOutCount
	
		llNewRow = ldsOut.insertRow(0)
	
		lsOutString = 'IG|' /*rec type = goods Issue Summary*/
		lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'invoice_no') + '|'
		
		If ldsHeader.GetItemString(llheaderRowPOs,'User_field6') > "" Then /*Powerwave SO Number*/
			lsOutString += ldsHeader.GetItemString(llheaderRowPOs,'User_field6') + '|' 
		Else
			lsOutString += "|"
		End If
		
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'po_item_number')) + '|'
		
		//Delivery Detail ID - coming from DD
		llFindRow = ldsDoDetail.Find("Line_Item_No = " + String(ldsGR.GetItemNumber(llOutPos,'po_item_number')),1, ldsDoPicking.RowCount())
		If llFindRow > 0 Then
			If ldsDoDetail.GetItemString(llFindRow,'User_Field8') > "" Then
				lsOutString += ldsDoDetail.GetItemString(llFindRow,'User_Field8') + "|"
			Else
				lsOutString += "|"
			End If
		Else
			lsOutString += "|"
		End If
				
		lsOutString += String(ldsHeader.GetITemDateTime(llheaderRowPOs,'complete_date'),'yyyy-mm-dd') + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'sku') + '|'
		lsOutString += String(ldsGR.GetItemNumber(llOutPos,'quantity')) + '|'
		lsOutString += ldsGR.GetItemString(llOutPos,'lot_no')  + '|'

		// 05/08 - Added Warehouse
		// 6/12 - MEA - Added 'PCH'
		
		CHOOSE CASE Upper(asWarehouse) 
		CASE 'PWAVE-SUZ' 
			lsOutString += 'MSZ'
		CASE 'PWAVE-SBLC' 
			lsOutString += 'PCH'			
		CASE Else
			lsOutString += 'MER'
		END Choose			
		
		
		ldsOut.SetItem(llNewRow,'Project_id', 'POWERWAVE')
		ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'ig' + String(ldBatchSeq,'00000000') + '.dat'
		ldsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	Next /*Output record*/
	
Next /*Order*/

//write the data
If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'POWERWAVE')
End If


//Update the file transmit ind to show sent
Update Delivery_Master set file_transmit_ind = 'Y' Where project_id = 'Powerwave' and Ord_status = 'C' and (file_transmit_ind is null or file_transmit_ind <> 'Y') and Complete_Date < :lsToday and wh_code = :asWarehouse;
Commit;

Return 0
end function

on u_nvo_proc_powerwave.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_powerwave.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
Destroy	idsPoHeader
Destroy idsPODetail

end event

