$PBExportHeader$u_nvo_proc_flextronics.sru
$PBExportComments$Process Pulse Files
forward
global type u_nvo_proc_flextronics from nonvisualobject
end type
end forward

global type u_nvo_proc_flextronics from nonvisualobject
end type
global u_nvo_proc_flextronics u_nvo_proc_flextronics

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem


datastore	idsReceiveMaster, &
				idsReceiveDetail
end variables

forward prototypes
public function integer uf_process_suppliers (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject, string asfile, ref string aspolinecountfilename)
public function integer uf_process_purchase_order (string asproject)
end prototypes

public function integer uf_process_suppliers (string aspath, string asproject);

//Process Supplier Master Transaction for Flextronics

u_ds_datastore	ldsSupplier
DAtastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsSupplier, lsSupplierName, lsCcty
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos

Boolean	lbError

ldsSupplier = Create u_ds_datastore
ldsSupplier.dataobject= 'd_supplier_master'
ldsSupplier.SetTransObject(SQLCA)

lu_ds = Create datastore
//lu_ds.dataobject = 'd_generic_import' nxjain 2013-10-09

lu_ds.dataobject = 'd_baseline_unicode_generic_import'	

//Open and read the FIle In
lsLogOut = '      - Opening Supplier Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!) nxjain 2013-10-09
liFileNo =  lu_ds.ImportFile( CSV!, aspath)   //.CSV

If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Supplier Master File for Flextronics Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//nxjain 2013-10-09 
////read file and load to datastore for processing
//liRC = FileRead(liFileNo,lsStringData)
//
//Do While liRC > 0
//	llNewRow = lu_ds.InsertRow(0)
//	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
//	liRC = FileRead(liFileNo,lsStringData)
//Loop /*Next File record*/
//
//FileClose(liFileNo)
//			
////Process each Row 

//end 2013-10-09

llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Supplier Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
//	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))

	//Validate Supplier and retrieve existing or Create new Row
	//If Len(lsData ) > 0 Then
//		lsTemp = Trim(Mid(lsData, 1, 10))

	//GailM - 11/30/2017 - Defect - Flextronics Supplier Not added
	lsTemp = Trim(lu_ds.GetItemString(llFileRowPos, "col1"))	
	If lsTemp = "Bpid" Then 
		//No nothing.  Move to next record
	Else
		lsSupplier = lsTemp
			
		if isnull(lsSupplier) or lsSupplier ='' then 
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier code' field. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		End If
			
		//lsTemp = Trim(Mid(lsData, 11, 50))
			lsTemp = Trim(lu_ds.GetItemString(llFileRowPos, "col2"))	
			lsSupplierName = lsTemp
			lsTemp = Trim(lu_ds.GetItemString(llFileRowPos, "col3"))	
			lsCcty = lsTemp
			
		if isnull(lsSupplierName) or lsSupplierName ='' then 
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier Name ' field. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		End If
			
	
			//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
			llCount = ldsSupplier.Retrieve(asProject, lsSupplier)
			If llCount <= 0 Then
				
				llNew ++ /*add to new count*/
				ldsSupplier.InsertRow(0)
				ldsSupplier.SetItem(1,'project_id',asProject)
				ldsSupplier.SetItem(1,'supp_code',lsSupplier)
				ldsSupplier.SetItem(1,'supp_name', lsSupplierName)			
				ldsSupplier.SetItem(1,'user_field1', lsCcty)			
					
					
			Else /*Supplier Master exists */
			
				llExist += llCount /*add to existing Count*/
	
				ldsSupplier.SetItem(1,'supp_name', lsSupplierName)			
				ldsSupplier.SetItem(1,'user_field1', lsCcty)			
						
			End If
				
	
		//Update any record defaults
		ldsSupplier.SetItem(1,'Last_user','SIMSFP')
		ldsSupplier.SetItem(1,'last_update',today())
	
		//Save Supplier to DB
		lirc = ldsSupplier.Update()
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			lsLogOut = Space(17) + "- ***System Error!  Unable to Save Supplier Master Record to database!"
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Supplier Master Record to database!")
			//Return -1
			Continue
		End If
	End If
Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Supplier Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsSupplier

If lbError then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName, lsTemp
			
			
Integer	liRC, liRC2

Boolean	bRet

Choose Case Upper(Left(asFile,2))
		
	Case  'PM'  /* PO Inbound Files */
		
		liRC = uf_process_po(asPath, asProject, asFile, lsPOLineCountFileName)

		//Not calling Baseline PO proc on purpose. 
		
	Case 'IM' /*Item Master File */
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		
	Case 'VM' /*Supplier Master File*/
		
		liRC = uf_Process_Suppliers(asPath, asProject)
	
	
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose


Return liRC
end function

public function integer uf_process_itemmaster (string aspath, string asproject);// 11/02 PCONKL

//Process Item Master (IM) Transaction for Flextronics

u_ds_datastore	ldsItem
datastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsSKU, lsDescription,ls_coo, ls_hscode 
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llDefaultOwner,	&
			llOwner,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos,		&
			llSkuRowCount,		&
			llSkuRowPos

Boolean	lbNew,	&
			lbError

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master'
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
// lu_ds.dataobject = 'd_generic_import' nxjain 2013-10-09
lu_ds.dataobject ='d_baseline_unicode_generic_import'


//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)  nxjain 2013-10-09

liFileNo =  lu_ds.Importfile(CSV!, aspath)   //.CSV

If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Flextronics Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//  nxjain 2013-10-09
////read file and load to datastore for processing  
//liRC = FileRead(liFileNo,lsStringData)
//
//Do While liRC > 0
//	llNewRow = lu_ds.InsertRow(0)
//	lu_ds.SetItem(llNewRow,'rec_data',Trim(lsStringData))
//	liRC = FileRead(liFileNo,lsStringData)
//Loop /*Next File record*/
//
//FileClose(liFileNo)
//
//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier SS

//end  nxjain 2013-10-09 

//lu_ds.SetSort("Col1 A")
//lu_ds.Sort()
//

Select owner_id into :llDefaultOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'FLEX';
			
//Process each Row
llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	
	lsTemp = Trim(lu_ds.GetItemString(llFileRowPos, "col1"))	
	lsSKU =lsTemp
	
	//SKU 
	If isnull(lsSKU)  or (lssku = ' ') Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
			
	lsTemp = Trim(lu_ds.GetItemString(llFileRowPos, "col2"))	
	lsDescription = lsTemp

	//Description 
	If isnull (lsDescription) or (lsDescription =' ' ) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Description' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
	
	//COO
	
//	//if COO is greate then 2 charcter , we are disgrad the row .
//	ls_coo = Trim(lu_ds.GetItemString(llFileRowPos, "col5"))	
//	if len(ls_coo) >2 then
//		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) +space(1)+ "country of origin' " +ls_coo+space(1)+ "exceed the column value .Record will not be processed.")
//		lbError = True
//		Continue 
//	end if 
//	
	// HS Code
//	ls_hscode = Trim(lu_ds.GetItemString(llFileRowPos, "col6"))
	
	
	//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
	llCount = ldsItem.Retrieve(asProject, lsSKU)
	If llCount <= 0 Then
		
		llNew ++ /*add to new count*/
		lbNew = True
		llSkuRowPos = ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'SKU',lsSKU)
		ldsItem.SetItem(1,'Supp_code', 'FLEX') 
		ldsItem.SetItem(1,'owner_id', llDefaultOWner) 
		ldsItem.SetItem(1,'Description', lsDescription)		
			
	Else /*Item Master(s) exist */
	
		llExist += llCount /*add to existing Count*/
		lbNew = False
	
		llSkuRowPos = 1
		ldsItem.SetItem(1,'Description', lsDescription)
		
	End If
			
	llSkuRowCount = ldsItem.RowCount() /*we will loop to update each iteration of this SKU (multiple Suppliers) or current supplier if filtered (present in File)*/


	//Update any record defaults
	For llSkuRowPos = 1 to llSkuRowCount	
		
		ldsItem.SetItem(llSkuRowPos,'project_id',asProject)
		ldsItem.SetItem(llSkuRowPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llSkuRowPos,'last_update',today())
		//if not isnull(ls_coo) then 
			//ldsItem.SetItem(1,'country_of_origin_default', ls_coo)
		//end if 
		//ldsItem.SetItem(1,'HS_Code', ls_hscode) 
		
		//If record is new...
		If lbNew Then
			ldsItem.SetItem(llSkuRowPos,'lot_controlled_ind','Y') /* always tracking by IMI ID # (lot No) */
			ldsItem.SetItem(llSkuRowPos,'po_controlled_ind','Y') 
			ldsItem.SetItem(llSkuRowPos,'serialized_ind','N')
			ldsItem.SetItem(llSkuRowPos,'po_no2_controlled_ind','Y')
			ldsItem.SetItem(llSkuRowPos,'container_tracking_ind','N') 
			ldsItem.SetItem(llSkuRowPos,'uom_1','EA')		
			ldsItem.SetItem(llSkuRowPos,'standard_of_measure','M')			
			ldsItem.SetItem(1,'country_of_origin_default', 'SG')
	
//			If isnull(ls_coo)  or (ls_coo = ' ') Then 
//				ldsItem.SetItem(1,'country_of_origin_default', 'SG')
//			else
//				ldsItem.SetItem(1,'country_of_origin_default', ls_coo)
//			end if	
//			
//			ldsItem.SetItem(1,'HS_Code', ls_hscode) 
		
		End If
		
	Next
	
	//Save NEw Item to DB
	lirc = ldsItem.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		//Return -1
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
end function

public function integer uf_process_po (string aspath, string asproject, string asfile, ref string aspolinecountfilename);Datastore	ldsPOHeader,	&
				ldsPODetail,	&
				lu_ds

String	lsLogout,				&
			lsStringData,			&
			lsOrder,					&
			lsWarehouse,			&
			lsHarmonizedCd,		&
			lsSKU,					&
			lsSUpplier,				&
			lsSupplierName,		&
			lsDesc,					&
			lsArrivalDate,			&
			lsTemp,					&
			lsDest,					&
			lsOWnerCd,				&
			lsPOUOM,				&
			lsUOM,					&
			lsFreightClass,		&
			lsStorageCD,			&
			lsInvClass,				&
			lsExpInd,				&
			lsExpTrack,			&
			lsPOInd,					&
			lsPO2Ind,				&
			lsSerializedInd,		&
			lsAltSKU,				&
			lsCOO,				&
			lsStockDueDate,   &
			lsLastSupplier,lsexpext

Integer	liFileNo,	&
			liRC, &
			liFileNoPOLine, &
			liRCPOLine, &
			liFileRowCount

Decimal ldrono


Long	llNewRow,			&
		llRowCount,			&
		llRowPos,			&
		llOrderSeq,			&
		llDetailSeq,		&
		llCount,				&
		llOwner,				&
		llDefaultOwner,	&
		llFindRow,			&
		llCCFreq,		  	&
		llShelfLife,		&
		llLastHeaderRow
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY,			&
			ldConvFactor,	&
			ldSIMSQTY,		&
			ldWeight
			
String lsrono		,ls_po	
			
Boolean	lbError, lb_ISPOLIneCountFile = false
Boolean  lb_ValidSupplier

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

lu_ds = Create datastore
//lu_ds.dataobject = 'd_generic_import' nxjain 2013-10-09

lu_ds.dataobject = 'd_baseline_unicode_generic_import'	//col

If not isvalid(idsReceiveMaster) Then
	idsReceiveMaster = Create u_ds_datastore
	idsReceiveMaster.dataobject= 'd_receive_master'
//	idsReceiveMaster.SetTransObject(SQLCA)
End If

idsReceiveMaster.SetTransObject(SQLCA)

If not isValid(idsReceiveDetail) Then
	idsReceiveDetail = Create u_ds_datastore
	idsReceiveDetail.dataobject= 'd_receive_detail'
//	idsReceiveDetail.SetTransObject(SQLCA)
End If

idsReceiveDetail.SetTransObject(SQLCA)

idsReceivemaster.Reset()
idsReceiveDetail.reset()



//Open and read the FIle In
lsLogOut = '      - Opening File for Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


//liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!) nxjain 2013-10-09

liFileNo =  lu_ds.ImportFile( CSV!, aspath)   //.CSV
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Pulse Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//nxjain 2013-10-09

////read file and load to datastore for processing
//liRC = FileRead(liFileNo,lsStringData)
//
//Do While liRC > 0
//	llNewRow = lu_ds.InsertRow(0)
//	lu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
//	liRC = FileRead(liFileNo,lsStringData)
//Loop /*Next File record*/
//
//FileClose(liFileNo)
//

//End 2013-10-09

lsWarehouse = 'FLEX-SIN'

Select Min(Owner_ID) into :llOwner
From Owner
Where Project_id = 'FLEX-SIN' and Owner_cd = 'FLEX';		
	
	
//Remove Open Record


DELETE FROM Receive_Detail WHERE  RO_NO IN (SELECT RO_NO FROM Receive_Master WHERE  project_id = 'FLEX-SIN' AND ord_status in ('N','P')) USING SQLCA;
DELETE FROM Receive_Putaway WHERE  RO_NO IN (SELECT RO_NO FROM Receive_Master WHERE  project_id = 'FLEX-SIN' AND ord_status in ('N','P')) USING SQLCA;
DELETE FROM Receive_Notes WHERE  RO_NO IN (SELECT RO_NO FROM Receive_Master WHERE  project_id = 'FLEX-SIN' AND ord_status in ('N','P')) USING SQLCA;
DELETE FROM Receive_Master WHERE project_id = 'FLEX-SIN' AND RO_NO IN (SELECT RO_NO FROM Receive_Master WHERE   project_id = 'FLEX-SIN' AND ord_status in ('N','P')) USING SQLCA;
	
	
//Process each row of the File
llRowCount = lu_ds.RowCount()

lsLogOut = Space(17) + "- ***Start" + string(now())
FileWrite(gilogFileNo,lsLogOut)


Integer li_line_item_no
datetime  ldtWHTime

ldtWHTime = f_getLocalWorldTime(lsWarehouse)


For llRowPos = 2 to llRowCount
	
	lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col1"))	
	lsOrder =lsTemp
	
	If IsNull(lsOrder) OR trim(lsOrder) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Order Nbr is required. Record will not be processed.")
		lbError = True
		Continue		
	end if 
	

//	lsSupplier = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),8,10))  /*used to update Item Master*/

	lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col2"))	
	lsSupplier =lsTemp

	If IsNull(lsSupplier) OR trim(lsSupplier) = '' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier is qeruired. Record will not be processed.")
		lbError = True
		Continue		
	end if 


	If lsSupplier <> lsLastSupplier Then

		//Validate Supplier
		Select Max(Supp_Name) into :lsSupplierName
		From Supplier
		Where project_id = :asProject and supp_code = :lsSupplier;
		
		If SQLCA.SQLCode = 100 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid Supplier: " + lsSupplier) 
				lbError = True
				lb_ValidSupplier = False
		Else
				lb_ValidSupplier = True
		End IF
	
//MA ADD		Select Max(Supp_Name) into :lsSupplierName
//		From Supplier
//		Where project_id = :asProject and supp_code = :lsSupplier;
//		
			
//		End If
//		
		lsLastSupplier = lsSupplier

	End If
	


	// See if we already have a header, if not, create one
	If ldsPOHeader.Find("Order_no = '" + lsOrder + "'",1,ldsPoHeader.RowCount()) <= 0 Then
		
		li_line_item_no = 0
		
		llNewRow = ldsPoHeader.InsertRow(0)
					
		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			Return -1
		End If
			
	 // From File...
		
		//Order Number
		ldsPoHeader.SetITem(llNewRow,'order_no',lsOrder)

//		8	10	*	Vendor Code	AN	ZP0021   	Yes
		
		//Supplier
//		ldsPoHeader.SetITem(llNewRow,'supp_code',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),61,35)))  

//		lsSKU = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),18,15))  

		lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col3"))	
		lsSKU =lsTemp
	

	//lsSupplierName


		
//		//Transportation Mode
//		ldsPoHeader.SetITem(llNewRow,'ship_via',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),553,35))) 
//		
		//42	8	*	Expected Date	Date	20100228	Yes

		//Arrival Date - format to mm/dd/yyyy
		
		//lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),42,8))     //999999
		
		
//		lsArrivalDate = Mid(lsTemp,1,4) + '/' + Mid(lsTemp,5,2) + '/' + Right(lsTemp,7) 
//		ldsPoHeader.SetITem(llNewRow,'arrival_date',lsArrivalDate)


		ldsPOheader.SetITem(llNewRow,'user_field4',lsSupplierName)
		ldsPOheader.SetITem(llNewRow,'user_field1',lsSupplier)
		

//			
//		//20100428	
//			
//		//Stock Due Date - format to mm/dd/yyyy
//		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),521 ,8))    
//		lsStockDueDate   = Mid(lsTemp,1,4) + '/' + Mid(lsTemp,5,2) + '/' + Right(lsTemp,7)
//		ldsPoHeader.SetITem(llNewRow,'user_field2',lsStockDueDate)
//
//		//20100428
//		
//		//BOL Nbr
////		ldsPoHeader.SetITem(llNewRow,'ship_ref',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),411,35)))   //493
//		
//		//Destination WareHouse -> User Field 1 (Master)
//		lsDest = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),732,35))     //573
//		ldsPoHeader.SetITem(llNewRow,'user_Field1',lsDest)
//
//		

	//Defaults
	
		ldsPOheader.SetITem(llNewRow,'ship_ref',lsOrder) 
	
			
		ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse) /*default WH for Project */
		
		
	// 4/2010  - now setting ord_date to local wh time



		ldsPOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm')) 
		ldsPOheader.SetITem(llNewRow,'arrival_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm')) 

//		ldsPOheader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy')) 
//		ldsPOheader.SetITem(llNewRow,'arrival_date', string(ldtWHTime, 'mm-dd-yyyy')) 
	
		
		
		ldsPOheader.SetITem(llNewRow,'project_id',asProject)
		ldsPOheader.SetITem(llNewRow,'supp_code', 'FLEX')
		ldsPOheader.SetITem(llNewRow,'action_cd','A') /*no action code - will not be validated and will create/update header as necessary*/
		ldsPOheader.SetITem(llNewRow,'Request_date',String(Today(),'YYYY/MM/DD'))
			
		ldsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
		ldsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
		ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llOrderSeq = llNewRow
		ldsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		ldsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
		IF lb_ValidSupplier THEN
			ldsPOheader.SetItem(llNewRow,'Status_cd','C')  //N
		Else
			ldsPOheader.SetItem(llNewRow,'Status_cd','E')  //N		
		End IF
		ldsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
		llLastHeaderRow = llNewRow
		
		llDetailSeq = 0 /*detail seq within order for detail recs */
		
		IF lb_ValidSupplier then
//--		
			llNewRow=idsReceiveMaster.InsertRow(0)
			sqlca.sp_next_avail_seq_no(asproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
			lsRoNO = asproject + String(Long(ldRoNo),"000000") 
			idsReceiveMaster.SetITem(llNewRow,'ship_ref',lsOrder) 
			idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
			idsReceiveMaster.SetItem(llNewRow,'project_id',asproject)
			idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrder)
			idsReceiveMaster.SetItem(llNewRow,'last_update',Today())
			idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
			idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')			
			idsReceiveMaster.SetItem(llNewRow,'ord_status','N')
			idsReceiveMaster.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			
			idsReceiveMaster.SetItem(llNewRow,'ord_date', datetime(ldtWHTime))  //Today())  
			idsReceiveMaster.SetItem(llNewRow,'arrival_date', datetime(ldtWHTime))  //Today())  

			idsReceiveMaster.SetITem(llNewRow,'user_field4',lsSupplierName)
			idsReceiveMaster.SetITem(llNewRow,'user_field1',lsSupplier)
		


			
			idsReceiveMaster.SetItem(llNewRow,'wh_code',lsWarehouse)
			
			idsReceiveMaster.SetItem(llNewRow,'supp_code','FLEX')
					
			
			idsReceiveMaster.SetItem(llNewRow,'inventory_type', 'N')
			
			idsReceiveMaster.SetItem(llNewRow,'ord_type','S')
		
		End IF
//--		
		
	End If /* No header for this ORder*/
	
	//Insert Detail Row
	llNewRow = ldsPODetail.InsertRow(0)
	
	//From File
	ldsPODetail.SetItem(llNewRow,'order_no',lsOrder) /*Order Number */

//	18	15	*	Part	AN	IX-1867	Yes

//	lsSKU = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),18,15))  

	ldsPODetail.SetITem(llNewRow,'sku',lsSKU) 
 	ldsPODetail.SetITem(llNewRow,'supp_code','FLEX') 
 
//	lsDesc = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),446,35)) /*used to update Item Master*/    //414

 	//33	9	*	Line#	N	30001	Yes


	ldsPODetail.SetITem(llNewRow,'user_field4',lsSupplierName)
	
	if llLastHeaderRow > 0 then
		ldsPOheader.SetItem(llLastHeaderRow,'user_field1', Trim(lsSupplier))
	end if	


	li_line_item_no = li_line_item_no + 1

	ldsPODetail.SetITem(llNewRow,'line_item_no', li_line_item_no) 

	string ls_line_no
	
 //	ls_line_no = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),33,9)) nxjain  2013-10-09 
 int ls_len , ls_row
 string ls_line_no_new
 
 lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col5"))
ls_line_no =lsTemp

ls_po = Trim(lu_ds.GetItemString(llRowPos, "col4"))
	
ls_line_no = trim(ls_po) + trim(ls_line_no)
	
	IF len(ls_line_no) > 9 THEN
		lstemp = Mid(ls_line_no,1,9)
 		ldsPODetail.SetITem(llNewRow,'User_field3', lstemp) 
	 	ldsPODetail.SetITem(llNewRow,'lot_no',Trim(lsSupplier) + "-" + lstemp)
	ELSEIF  len(ls_line_no)  < 9 THEN
			 	ls_len = len(ls_line_no)
				ls_line_no_new = ls_line_no 
					FOR  ls_row = 1 to (9 - ls_len )
						ls_line_no_new = ls_line_no_new +'0'
					NEXT
				ldsPODetail.SetITem(llNewRow,'User_field3', ls_line_no_new) 
			 	ldsPODetail.SetITem(llNewRow,'lot_no',Trim(lsSupplier) + "-" + ls_line_no_new)
	ELSE
		ldsPODetail.SetITem(llNewRow,'User_field3', ls_line_no) 
	 	ldsPODetail.SetITem(llNewRow,'lot_no',Trim(lsSupplier) + "-" + ls_line_no)
	END IF 
	
		
	//We need to get the Stock Keeping UOM for the Order Detail
	lsUOM = ''

//MA Comment1
//	Select uom_1 into :lsuom
//	From ITem_Master
//	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
//		
//	//If not present, take from 'SS' - We will be creating a new IM for this supplier down below, copy relevent fields from SS
//	If isnull(lsUOM) or lsUOM = '' Then
//		/* dts - 4/27/04
//				added Expiration_Tracking_Type and Shelf_Life
//				and now Grabbing ANY (single) record instead of 'SS' record
//				(in case there is no 'SS' record but an update has occurred via uf_process_itemMaster)		*/
//		/*
//		Select uom_1, weight_1, cc_freq, freight_Class, storage_code, Inventory_Class, expiration_controlled_ind, 
//					Alternate_SKU, po_controlled_Ind, po_no2_Controlled_Ind, Serialized_Ind, Country_Of_Origin_Default
//		into :lsuom, :ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, :lsExpInd,
//				:lsAltSKU, :lsPOInd, :lsPO2Ind, :lsSerializedInd, :lsCOO
//		*/
//		Select min(uom_1), min(weight_1), min(cc_freq), min(freight_Class), min(storage_code), min(Inventory_Class),
//			min(expiration_controlled_ind), min(expiration_Tracking_Type), min(Alternate_SKU), min(po_controlled_Ind), 
//			min(po_no2_Controlled_Ind), min(Serialized_Ind), min(Country_Of_Origin_Default), min(Shelf_Life)
//		into :lsuom, :ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, 
//			:lsExpInd, :lsExpTrack, :lsAltSKU, :lsPOInd,
//			:lsPO2Ind, :lsSerializedInd, :lsCOO, :llShelfLife
//		From Item_Master
//		Where Project_id = :asProject and sku = :lsSKU; //4/27/04 and Supp_code = 'SS';
//				
//	End If
//MA Comment2
	
	lsUOM = 'EA'
	
	ldsPODetail.SetItem(llNewRow,'UOM',lsUOM) /*Stock Keeping UOM */
	
//	63	16	*	Price	N(16,6)	2.945	Yes
	
// 	ldsPODetail.SetItem(llNewRow,'Cost',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),63,16))) /*Cost*/ nxjain 2013-10-09

ldsPODetail.SetItem(llNewRow,'Cost',Trim(lu_ds.GetItemString(llRowPos, "col9"))) /*Cost*/
	
	//We need to convert the QTY from the PO Qty to the SIMS QTY using the included conversion factor
	
	//Validate QTY for Numerics
//	50	11	*	Qty	N(11,3)	170	Yes

	lstemp =Trim(lu_ds.GetItemString(llRowPos,"col8")) // quntity check 
		
//	If Not isnumber(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),50,11))) Then
	If Not isnumber(lstemp) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to 0.")
		lbError = True
		ldPOQTY = 0
		//Continue /*Next record */
	Else
		ldPOQTY = Dec(Trim(lu_ds.GetItemString(llRowPos,"col8")))
	End If
	
	ldsPODetail.SetITem(llNewRow,'quantity',String(ldPOQTY,'##########.#####'))

//	//Set Detail UF 1 to PO QTY/UOM
//	lsPOUOM = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),588,3)) /* Purchase UOM */
//	ldsPODetail.SetITem(llNewRow,'User_field1',String(ldPOQTY,'#######.#####') + '/' + lsPOUOM)
//	
//	//Calculate and set SIMS Stockkeeping qty
//	ldSIMSQTY = ldPOQTY * ldConvFactor
//	
//	//HArmonized Code - Used to Update Item MAster Record
////	lsHarmonizedCd = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),624,35))
//	
////What is the Harmonized Code?
//	
//	//Inspection CLass - Used to Update Item MAster Record
//	//01/03 - PCONKL - Inspection Class now going on the ORder Detail Record
//	//lsInspectionClass = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),887,4))
//	
//	ldsPODetail.SetItem(llNewRow,'user_field3',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),887,4))) 
//	
//	/*User LIne ITem No  */
//	ldsPODetail.SetItem(llNewRow,'user_line_Item_No',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),891,16))) 
//
//
////	79	3	*	CUR Code	A	US$	Yes
//
//	
//	
	
//	ldsPODetail.SetITem(llNewRow,'User_field1',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),79,3))) nxjain 2013-10-09 
//	ldsPODetail.SetITem(llNewRow,'User_field2',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),42,8))) nxjain 2013-10-09

char ll_char


	ldsPODetail.SetITem(llNewRow,'User_field1',Trim(lu_ds.GetItemString(llRowPos,"col10")))
	
	lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col7"))
	
	ll_char =  Mid(lsTemp ,3,1)

	If (ll_char ='/') then 
			lsexpext = Mid(lsTemp,7,4)  + Mid(lsTemp,1,2)  + Mid(lsTemp,4,2) 
		else 
			lsexpext = Mid(lsTemp,1,4)  + Mid(lsTemp,6,2)  + Mid(lsTemp,9,2) 
		end if 

	ldsPODetail.SetITem(llNewRow,'User_field2', lsexpext) 
	

	//Action Code - set to update
	
	ldsPODetail.SetItem(llNewRow,'action_cd','A')
	
	//OwnerID if Present
	ldsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) 

	
	//	Inbound order without valid part master setup will be rejected by SIMS.

	//Validate Sku
	Select Count(*) into :llCount
	From Item_Master
	Where project_id = :asProject and sku = :lsSku;
	
	boolean lb_ValidSku
	
	If llCount <= 0 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " Invalid Sku: " + lsSKU) 
		lbError = True
		lb_ValidSku = False
	ELSE
		lb_ValidSku = True
	End If

		
		//	Inbound order without valid vendor master setup will be rejected by SIMS.	
		
	//Defaults
	//ldsPODetail.SetItem(llNewRow,'action_cd','A') /*No action CD - treat as an update (will still create new rec if doesn't exist */
	ldsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
	
	If lb_ValidSku AND lb_ValidSupplier then
		ldsPODetail.SetItem(llNewRow,'status_cd', 'C') 
	Else
		ldsPODetail.SetItem(llNewRow,'status_cd', 'E') 
	End If

	ldsPODetail.SetItem(llNewRow,'Inventory_Type', 'N') 
	ldsPODetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
	lLDetailSeq ++
	ldsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
	ldsPODetail.SetItem(llNewRow,"order_line_no",string(lLDetailSeq)) 
	
	
	//If no errors, apply the updates
	

	
	IF lb_ValidSku AND lb_ValidSupplier THEN

		llNewRow = idsReceiveDetail.InsertRow(0)
		idsReceiveDetail.SetITem(llNewRow,'ro_no', lsRoNO)
		idsReceiveDetail.SetItem(llNewRow,'sku',lsSKU)
		idsReceiveDetail.SetItem(llNewRow,'alternate_sku', lsSKU)
		
		idsReceiveDetail.SetItem(llNewRow,'supp_code', 'FLEX')
			
		idsReceiveDetail.SetItem(llNewRow,'uom',lsUOM)


//		idsReceiveDetail.SetITem(llNewRow,'User_field1',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),79,3)))
//		idsReceiveDetail.SetITem(llNewRow,'User_field2',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),42,8)))
//		idsReceiveDetail.SetITem(llNewRow,'User_field3',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),33,9))) 
//		
//		
		idsReceiveDetail.SetITem(llNewRow,'User_field1',Trim(lu_ds.GetItemString(llRowPos,"Col10")))
	//	idsReceiveDetail.SetITem(llNewRow,'User_field2',Trim(lu_ds.GetItemString(llRowPos,"col7")))
	
	//nxjain  

		
	lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col7"))

	If (ll_char ='/') then 
		lsexpext = Mid(lsTemp,7,4)  + Mid(lsTemp,1,2)  + Mid(lsTemp,4,2) 
	else 
		lsexpext = Mid(lsTemp,1,4)  + Mid(lsTemp,6,2)  + Mid(lsTemp,9,2) 
	end if 

	idsReceiveDetail.SetITem(llNewRow,'User_field2', lsexpext) 
		
		// line item no took only 9 char 
//		if len(ls_line_no) > 9 then
//			
//			lstemp = Mid(ls_line_no,1,9)
//			idsReceiveDetail.SetITem(llNewRow,'User_field3', lstemp) 
//		else
//			idsReceiveDetail.SetITem(llNewRow,'User_field3', ls_line_no) 
//		end if 
//	
	lsTemp = Trim(lu_ds.GetItemString(llRowPos, "col5"))
	ls_line_no =lsTemp
	
			
	ls_po = Trim(lu_ds.GetItemString(llRowPos, "col4"))
	
	ls_line_no = trim(ls_po) + trim(ls_line_no)
	
	if len(ls_line_no) > 9 then
		lstemp = Mid(ls_line_no,1,9)
		 idsReceiveDetail.SetITem(llNewRow,'User_field3', lstemp) 
		 
	elseif  len(ls_line_no)  < 9 then 
			ls_len = len(ls_line_no)
			ls_line_no_new = ls_line_no 
	
			for	  ls_row = 1 to (9 - ls_len )
				ls_line_no_new = ls_line_no_new +'0'
					
			next 
		idsReceiveDetail.SetITem(llNewRow,'User_field3', ls_line_no_new) 
	else
		idsReceiveDetail.SetITem(llNewRow,'User_field3', ls_line_no) 
	end if 
	
	
	
	
		
	//	idsReceiveDetail.SetITem(llNewRow,'User_field3',Trim(lu_ds.GetItemString(llRowPos,ls_line_no))) 
		
		idsReceiveDetail.SetITem(llNewRow,'req_qty', ldPOQTY)
		idsReceiveDetail.SetItem(llNewRow,'line_item_no', li_line_item_no)
		idsReceiveDetail.SetITem(llNewRow,'alloc_qty',0)
		idsReceiveDetail.SetITem(llNewRow,'damage_qty',0)
		
		idsReceiveDetail.SetItem(llNewRow,'country_of_origin','SG')

		//idsReceiveDetail.SetItem(llNewRow,'cost',Dec(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),63,16))))
		
		idsReceiveDetail.SetItem(llNewRow,'cost',Dec(Trim(lu_ds.GetItemString(llRowPos,"col9"))))
		
		idsReceiveDetail.SetItem(llNewRow,'owner_id', llOwner)		
				
	End If
		

	
	
	
//	//We may need to create a new Item Master for this Supplier or update an existing rec with Desc, Harmonozed Code, Inspection Class
//	Select Count(*) into :llCount
//	From Item_MAster
//	Where Project_id = :asProject and SKU = :lsSKU and supp_code = :lsSupplier;
//		
//	If llCount <= 0  Then /*Create a new Item MAster*/
//		
//		//Supplier needs to be validated since we are creating a new Item
//		Select Count(*) Into :llCount
//		From Supplier
//		Where Project_id = :AsProject and Supp_code = :lsSupplier;
//	
//		If llCount <= 0 Then
//			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier Not Found: '" + lsSupplier + "'. Record will not be processed.")
//			lbError = True
//			Continue /*Next record */
//		End If /*Supplier not found*/
//	
//		//Get the Default Owner for this Supplier
//		Select owner_id into :llDefaultOwner
//		From Owner
//		Where project_id = :asProject and owner_type = 'S' and Owner_cd = :lsSupplier;
//		
//		//Default values for 'SS' may have been retrived above, use those if present, otherwise default
//		If isNull(lsSerializedInd) or lsSerializedInd = '' Then lsSerializedInd = 'N'
//		If isNull(lsPOInd) or lsPOInd = '' Then lsPOInd = 'Y' /* 02/03 - PCONKL - will be setting PO IND to yes for all items */
//		If isNull(lsPO2Ind) or lsPO2Ind = '' Then lsPO2Ind = 'N'
//		If isNull(lsExpInd) or lsExpInd = '' Then lsExpInd = 'N'
//		If isNull(lsCOO) or lsCoo = '' Then lsCOO = 'XXX'
//		//dts - added Expiration_Tracking_Type and Shelf_life to insert...
//		Insert Into Item_MAster (Project_ID, SKU, Supp_code, Owner_ID, Description, Country_Of_Origin_Default, LAst_User,
//										Last_Update, lot_Controlled_Ind, po_controlled_Ind, Serialized_Ind, po_no2_controlled_ind,
//										expiration_controlled_ind, expiration_tracking_type, shelf_life, container_tracking_ind, hs_Code,  uom_1,
//										Weight_1, cc_Freq, freight_Class, Storage_code, Inventory_Class, AlterNate_SKU)
//		Values						(:asProject, :lsSKU, :lsSupplier, :llDefaultOwner, :lsDesc, :lsCOO, 'SIMSFP',
//											:ldtTODAY, 'Y', :lsPoInd, :lsSerializedInd, :lsPO2Ind, 
//											:lsExpInd, :lsExpTrack, :llShelfLife, 'Y', :lsharmonizedCd, :lsUOM,
//											:ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, :lsAltSKU);
//				
//	Else /*Update the current SKU/Supplier record */
//		
//		Update Item_MAster
//		Set Description = :lsDesc, hs_Code = :lsharmonizedCd
//		Where Project_id = :AsProject and SKU = :lsSKU and Supp_Code = :lsSupplier;
//		
//	End If /*Create/Update Item MAster Record */
		
Next /*File Row */

//Save the Changes 
lirc = ldsPOHeader.Update()
	
If liRC = 1 Then
	liRC = ldsPODetail.Update()
End If


liRC = idsReceiveMaster.Update()
liRC = idsReceiveDetail.Update()

		
	
If liRC = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

lsLogOut = Space(17) + "- ***End" + string(now())
FileWrite(gilogFileNo,lsLogOut)


If lbError Then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_purchase_order (string asproject);
// 11/02 - PCONKL - Chg Qty fields to Decimal
				
Long		llHeaderPos,	& 
			llHeaderCount,	&
			llDetailCount,	&
			llDetailPos,	&
			llRmasterCount,	&
			llRDetailCount,	&
			llRowPos,			&
			llCount,				&
			llLineItem,			&
			llOwner,				&
			llNewRow,			&
			llBatchSeq,			&
			llOrderSeq,			&
			llNewCount,			&
			llUpdateCount,		&
			llDeleteCount

String	lsProject, lsOrderNo, lsRoNo,	lstemp, lsSku,	lsSupplier,	lsHeaderErrorText,	&
			lsDetailErrorText, lsLogOut, lsAllowPOErrors, lsDefCOO, lsUOM, lsArrivalDate, lsSuppHeader, lsSuppLine, lsMultiSup
String lsErrText
Boolean	lbError,	lbValError, lbDetailErrors, lbMultiSup
			
Decimal{5}	ldRONO, ldQty,	ldAllocQty
Integer	liRC

lsLogOut = '          - PROCESSING FUNCTION - Create/Update Inbound Purchase Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

If not isvalid(idspoheader) Then
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
//	idsPOheader.SetTransObject(SQLCA)
End IF

idsPOheader.SetTransObject(SQLCA)

If Not isvalid(idsPODetail) Then
	idsPODetail = Create u_ds_datastore
	idsPODetail.dataobject= 'd_po_detail'
//	idsPODEtail.SetTransObject(SQLCA)
End If

idsPODetail.SetTransObject(SQLCA)

If not isvalid(idsReceiveMaster) Then
	idsReceiveMaster = Create u_ds_datastore
	idsReceiveMaster.dataobject= 'd_receive_master'
//	idsReceiveMaster.SetTransObject(SQLCA)
End If

idsReceiveMaster.SetTransObject(SQLCA)

If not isValid(idsReceiveDetail) Then
	idsReceiveDetail = Create u_ds_datastore
	idsReceiveDetail.dataobject= 'd_receive_detail'
//	idsReceiveDetail.SetTransObject(SQLCA)
End If

idsReceiveDetail.SetTransObject(SQLCA)

idsPoHeader.Reset()
idsPODetail.Reset()
idsReceivemaster.Reset()
idsReceiveDetail.reset()


//03/03 - PCONKL - for some projects, we will allow a PO to still be created if 1 or more detail lines have errors
//						 Otherwise, we will delete the entire PO  if there are errors.
lsallowPOErrors = ProfileString(gsinifile,asProject,"allowpoerrors","")
If isNull(lsAllowPOErrors) or lsAllowPOErrors = '' or lsAllowPOErrors <> 'Y' Then lsAllowPOErrors = 'N'

//Retrieve the EDI Header and Detail based on the batch seq no
llHeaderCount = idsPOHeader.Retrieve() /* all records with a new status will be retrieved*/

lsLogOut = '              ' + string(llHeaderCount) + ' Inbound PO Headers were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//If llHeaderCount <=0 Then Return 0
If llHeaderCount =0 Then
	Return 0
ElseIf llHeaderCount < 0 Then /* 11/03 - PCONKL */
	gu_nvo_process_files.uf_send_email("",'Filexfer'," - ***** Uf_Process_Purchase_Order - Unable to read EDI Records!","Unable to read Inbound EDI Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

lsLogOut = Space(17) + "- ***Start" + string(now())
FileWrite(gilogFileNo,lsLogOut)


//Process Each EDI Header Record
For llHeaderPos = 1 to llHeaderCount
	
	//Retrieve any existing Receive Master records for this EDI header - we may have multiple Receive records for the same Order Number (partial receipts)
	//When updating a header or detail, we should only be upating the open one (status not complete) - they will be sorted so that the most recent is the last row in the DW
	
	lsProject = idsPOHeader.GetItemString(llHeaderPos,'project_id')
	lsOrderNo = idsPOHeader.GetItemString(llHeaderPos,'order_no')
	lsSuppHeader = idsPOHeader.GetItemString(llheaderPos,'supp_code')
	llBatchSeq = idsPOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
	llOrderSeq = idsPOHeader.GetItemNumber(llHeaderPos,'order_seq_no')
	
	
	llRmasterCount = 0

//?- For COTY, need to retrieve based on Order/Shipment	
	lsHeaderErrorText = ''
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
	
	//Validate action cd
		
	llNewRow=idsReceiveMaster.InsertRow(0)
	sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
	lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
	idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
	idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
	idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
	idsReceiveMaster.SetItem(llNewRow,'last_update',Today())
	idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
	idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')			
	idsReceiveMaster.SetItem(llNewRow,'ord_status','N')

	idsReceiveMaster.SetItem(llNewRow,'ord_date',Today())
	
	//Validate Warehouse
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'wh_code')
		
	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'wh_code',lsTemp)
		
	//Validate Supplier
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'supp_code')

	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'supp_code',lsTemp)
				
	
	//Validate Inventory Type
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'inventory_type')

	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'inventory_type',lsTemp)

	
	//Validate Order Type
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'order_type')

	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ord_type',lsTemp)

	
	//Update other fields...
	If isDAte(idsPOHeader.GetITemString(llHeaderPos,'request_date')) Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'request_date',Date(idsPOHeader.GetITemString(llHeaderPos,'request_date')))
	End If
	
	If isDAte(idsPOHeader.GetITemString(llHeaderPos,'arrival_date')) Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'arrival_date',Date(idsPOHeader.GetITemString(llHeaderPos,'arrival_date')))
		lsArrivalDate = idsPOHeader.GetITemString(llHeaderPos,'arrival_date')
	End If
	
	If isDAte(String(Date(idsPOHeader.GetITemString(llHeaderPos,'ord_date')))) Then /* 03/09 - PCONKL - Override Order Date if present on the file*/
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ord_date',DateTime(idsPOHeader.GetITemString(llHeaderPos,'ord_date')))
	End If
	
	If idsPOHeader.GetITemString(llHeaderPos,'supp_order_no') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'supp_order_no',idsPOHeader.GetITemString(llHeaderPos,'supp_order_no'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'ship_via') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ship_via',idsPOHeader.GetITemString(llHeaderPos,'ship_via'))
	End if
	If idsPOHeader.GetITemString(llHeaderPos,'ship_ref') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ship_ref',idsPOHeader.GetITemString(llHeaderPos,'ship_ref'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'agent_info') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'agent_info',idsPOHeader.GetITemString(llHeaderPos,'agent_info'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'Carrier') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Carrier',idsPOHeader.GetITemString(llHeaderPos,'Carrier'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'customs_doc') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'customs_doc',idsPOHeader.GetITemString(llHeaderPos,'customs_doc'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'transport_mode') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'transport_mode',idsPOHeader.GetITemString(llHeaderPos,'transport_mode'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'Remark') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Remark',idsPOHeader.GetITemString(llHeaderPos,'Remark'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field1') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field1',idsPOHeader.GetITemString(llHeaderPos,'User_field1'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field2') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field2',idsPOHeader.GetITemString(llHeaderPos,'User_field2'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field3') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field3',idsPOHeader.GetITemString(llHeaderPos,'User_field3'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field4') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field4',idsPOHeader.GetITemString(llHeaderPos,'User_field4'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field5') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field5',idsPOHeader.GetITemString(llHeaderPos,'User_field5'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field6') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field6',idsPOHeader.GetITemString(llHeaderPos,'User_field6'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field7') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field7',idsPOHeader.GetITemString(llHeaderPos,'User_field7'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'User_field8') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field8',idsPOHeader.GetITemString(llHeaderPos,'User_field8'))
	End If
	// 02/09 - Pandora uses UF9, 10, 11
	If idsPOHeader.GetItemString(llHeaderPos,'User_field9') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field9',idsPOHeader.GetItemString(llHeaderPos,'User_field9'))
	End If
	If idsPOHeader.GetItemString(llHeaderPos,'User_field10') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field10',idsPOHeader.GetItemString(llHeaderPos,'User_field10'))
	End If
	If idsPOHeader.GetItemString(llHeaderPos,'User_field11') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field11',idsPOHeader.GetItemString(llHeaderPos,'User_field11'))
	End If
	// 2009/06/09 - TAM Pandora uses UF12, 13, 14,15)
	If idsPOHeader.GetItemString(llHeaderPos,'User_field12') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field12',idsPOHeader.GetItemString(llHeaderPos,'User_field12'))
	End If
	If idsPOHeader.GetItemString(llHeaderPos,'User_field13') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field13',idsPOHeader.GetItemString(llHeaderPos,'User_field13'))
	End If
	If idsPOHeader.GetItemString(llHeaderPos,'User_field14') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field14',idsPOHeader.GetItemString(llHeaderPos,'User_field14'))
	End If
	If idsPOHeader.GetItemString(llHeaderPos,'User_field15') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field15',idsPOHeader.GetItemString(llHeaderPos,'User_field15'))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'ctn_cnt') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ctn_cnt',Long(idsPOHeader.GetITemString(llHeaderPos,'ctn_cnt')))
	End If
	If idsPOHeader.GetITemString(llHeaderPos,'weight') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'weight',Dec(idsPOHeader.GetITemString(llHeaderPos,'weight')))
	End If
			
	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(), 'crossdock_ind', 'N')
			
	// 11/02 - PCONKL -  ADD GLS_TR_ID for Recon to GLS
	If idsPOHeader.GetITemString(llHeaderPos,'gls_tr_id') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'gls_tr_id',idsPOHeader.GetITemString(llHeaderPos,'gls_tr_id'))
	End If
	
	// 2005/05/13 - TAM -  ADDED AWB/BOL
	If idsPOHeader.GetITemString(llHeaderPos,'AWB_BOL_No') > ' ' Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'AWB_BOL_No',idsPOHeader.GetITemString(llHeaderPos,'AWB_BOL_No'))
	End If
	
	// 2010/01/17 - TAM -  Customer Sent Date
	If isDAte(idsPOHeader.GetItemString(llHeaderPos,'customer_sent_date')) Then
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'customer_sent_date',idsPOHeader.GetITemString(llHeaderPos,'customer_sent_date'))
	End If
	
	idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'edi_batch_seq_no',idsPOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no'))

	//Update the Header Record
//		SQLCA.DBParm = "disablebind =0"
	liRC = idsReceiveMaster.Update(True,False) /*we need rec status alter if we need to delete the order if errors*/
//		SQLCA.DBParm = "disablebind =1"
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Receive Master Record to database!")
		lbError = True
		Continue /*Next Header*/
	End If
	
	//Update order insert/update count
	If idsPOHeader.GetITemString(llHeaderPos,'action_cd') = 'A' Then
		llNewCount ++
	Else
		llUpdateCOunt ++
	End if
	
	
	//Retrieve the EDI DEtail records for the current header (based on edi batch seq and order_no)
	idsPODetail.SetFilter("")
	idsPoDetail.Filter()
	
	llDEtailCount = idsPODetail.Retrieve(asProject,llBatchSeq,lsOrderNo)
	

	// 10/06 - PCONKL - If there aren't any Detail records for this header, we will want to delete the header below...
	If lLDetailCount = 0 Then
		gu_nvo_process_files.uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " No valid Detail Records found for Header. " ) 
		lbError = True
	End If
	
	
	//Once we have a detail error, we will still validate the detail rows but we wont save any new/changed detail rows to the DB
	// 01/03 - PCONKL - This is no longer true - we will save any detail rows that are valid
	// 03/03 - PCONKL - Now, this will be project dependant as denoted in the .ini file 
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False /*Error on Current detail if allowing errors or any if not */
	lbDetailErrors = False /*error on any detail Row for Order */
		
	//process each Detail Record
	For llDetailPos = 1 to llDetailCOunt
		
		If lbError Then 
			lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
			lbDetailErrors = True
		End If
		
		//03/03 - PCONKL, Only reset for each detail if we are allowing partial PO's
		If lsAllowPOErrors = 'Y' Then	lbError = False 
	
		lsDetailErrorText = ''
		lsSku = idsPODetail.GetItemString(llDetailPos,'sku')		
		llLineItem = idsPODetail.GetItemNumber(llDetailPos,'line_item_no')
	
		//Validate Inventory Type
		lsTemp = idsPODetail.GetITemString(llDetailPos,'inventory_type')
	
		//Validate SKU - 10/03 - PCONKL - must validate against header supplier - all SKUS for order must have same supplier
		/* dts - 09/15/08 - Maquet needs supplier at the detail level (since single PO my contain multiple 'Suppliers' (actually SKU prefix))
		 - If the order type allows multiple suppliers...
		   and the supplier is present on the detail record, use the detail's supplier. */
		lsSupplier = lsSuppHeader  //use the Header-level Supplier unless otherwise indicated (immediately below)...

//MA
//		lsTemp = idsPODetail.GetITemString(llDetailPos,'sku')
//		If isNull(lsTemp) Then lsTemp = ''
//		Select Count(*) into :llCount
//		From Item_Master
//		Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;
//		
//		If llCount <=0 Then
//			gu_nvo_process_files.uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid SKU, or SKU not valid for this Supplier: " + lsTemp + " / " + lsSupplier) 
//			lsDetailErrorText += ', ' + "Invalid SKU or SKU not valid for this Supplier"
//			lbError = True
//		End If
		
	
		//Quantity must be Numeric
		If not isNumber(idsPODetail.GetITemString(llDetailPos,'Quantity')) Then
			gu_nvo_process_files.uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Quantity is not numeric: " ) 
			lsDetailErrorText += ', ' + "Quantity is not numeric"
			lbError = True
		End If
		
//		//Validate COO if present
//		//03/02 - Pconkl - validate against either 2 char or 3 char code
//		lsTemp = idsPODetail.GetITemString(llDetailPos,'country_of_origin') 
//		If isNull(lsTemp) Then lsTemp = ''
//		If Trim(lsTEmp) > '' Then
//			If f_get_country_Name(lsTemp) > '' Then
//			Else
//				gu_nvo_process_files.uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Country of Origin: " + lsTemp) 
//				lsDetailErrorText += ', ' + "Invalid Country of Origin"
//				lbError = True
//			End If
//			
//		End If
		
		//If no errors, apply the updates

		idsReceiveDetail.InsertRow(0)
		idsReceiveDetail.SetITem(1,'ro_no',idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'ro_no'))
		idsReceiveDetail.SetItem(1,'sku',idsPODetail.GetItemString(llDetailPos,'sku'))
		
		idsReceiveDetail.SetItem(1,'supp_code',lsSupplier)
		
//				// 03/04 - PCONKL - Load UOM From Item Master if not included on feed
//				If isnull(idsPODetail.GetItemString(llDetailPos,'uom')) or idsPODetail.GetItemString(llDetailPos,'uom') = '' Then
//					
//					lsSKU = idsPODetail.GetItemString(llDetailPos,'sku')
//					
//					Select uom_1 into :lsUOM
//					From Item_Master
//					Where Project_ID = :lsProject and SKU = :lsSKU and Supp_Code = :lsSupplier;
//					
//					idsReceiveDetail.SetItem(1,'uom',lsUOM)
//					
//				Else
			idsReceiveDetail.SetItem(1,'uom',idsPODetail.GetItemString(llDetailPos,'uom'))
//				End If
		
		idsReceiveDetail.SetITem(1,'req_qty',Dec(idsPODetail.GetItemString(llDetailPos,'quantity')))
		idsReceiveDetail.SetItem(1,'user_field1',idsPODetail.GetItemString(llDetailPos,'user_field1'))
		idsReceiveDetail.SetItem(1,'user_field2',idsPODetail.GetItemString(llDetailPos,'user_field2'))
		idsReceiveDetail.SetItem(1,'user_field3',idsPODetail.GetItemString(llDetailPos,'user_field3'))
		idsReceiveDetail.SetItem(1,'user_field4',idsPODetail.GetItemString(llDetailPos,'user_field4'))
		idsReceiveDetail.SetItem(1,'user_field5',idsPODetail.GetItemString(llDetailPos,'user_field5'))
		idsReceiveDetail.SetItem(1,'user_field6',idsPODetail.GetItemString(llDetailPos,'user_field6'))
		idsReceiveDetail.SetItem(1,'line_item_no',idsPODetail.GetItemNumber(llDetailPos,'Line_item_no'))
		idsReceiveDetail.SetITem(1,'alloc_qty',0)
		idsReceiveDetail.SetITem(1,'damage_qty',0)
		
//				If idsPODetail.GetITemString(llDetailPos,'country_of_origin') > ' ' Then
			idsReceiveDetail.SetItem(1,'country_of_origin','SG')
//				Else
//					// 03/04 - PCONKL - Should load default from ITem Master
//					Select Country_of_origin_default into :lsDefCoo
//					From Item_Master
//					Where project_id = :lsProject and sku = :lsSKU and supp_code = :lsSupplier;
//					
//					If lsDefCoo > '' Then
//						idsReceiveDetail.SetItem(1,'country_of_origin',lsDefCoo)
//					Else
//						idsReceiveDetail.SetItem(1,'country_of_origin','XXX')
//					End If
//					
//				End If
		
		
		If idsPODetail.GetITemString(llDetailPos,'alternate_sku') > ' ' Then
			idsReceiveDetail.SetItem(1,'alternate_sku',idsPODetail.GetItemString(llDetailPos,'alternate_sku'))
		Else
			idsReceiveDetail.SetItem(1,'alternate_sku',idsPODetail.GetItemString(llDetailPos,'sku'))
		End If
		If idsPODetail.GetITemString(llDetailPos,'Cost') > ' ' Then
			idsReceiveDetail.SetItem(1,'cost',Dec(idsPODetail.GetItemString(llDetailPos,'cost')))
		End If
		
		// 11/02 - PCONKL - ADD GLS_SO_ID and GLS_SO_LINE for recon with GLS
		If idsPODetail.GetItemString(llDetailPos,'gls_so_ID') > ' ' Then
			idsReceiveDetail.SetItem(1,'gls_so_ID',idsPODetail.GetItemString(llDetailPos,'gls_so_ID'))
		End If
		If idsPODetail.GetItemNumber(llDetailPos,'gls_so_line') > 0 Then
			idsReceiveDetail.SetItem(1,'gls_so_line',idsPODetail.GetItemNumber(llDetailPos,'gls_so_line'))
		End If
		
		// 11/02 - PCONKL - User Line ITem No used for Pulse
		If idsPODetail.GetItemString(llDetailPos,'user_line_ITem_No') > '' Then
			idsReceiveDetail.SetItem(1,'user_line_ITem_No',idsPODetail.GetITemString(llDetailPos,'user_line_ITem_No'))
		End If
		
		//08/07 - PCONKL in support of 3COM RMA
		If idsPODetail.GetItemString(llDetailPos,'exp_serial_No') > '' Then
			idsReceiveDetail.SetItem(1,'exp_serial_No',idsPODetail.GetITemString(llDetailPos,'exp_serial_No'))
		End If
		
		// 12/02 - PConkl - If owner present on edi file, set - otherwise get default
		If idsPODetail.GetItemString(llDetailPos,'Owner_ID') > '' Then
			idsReceiveDetail.SetItem(1,'Owner_ID',Long(idsPODetail.GetITemString(llDetailPos,'Owner_ID')))
		Else
			//Get default owner for SKU
//					Select Min(owner_id) into :llOwner
//					From Item_Master
//					Where  project_id = :lsProject and sku = :lsSku;
//				
			idsReceiveDetail.SetItem(1,'owner_id', 245310)		
		End If /*owner present*/					

		
		//Update the Detail Record
//			SQLCA.DBParm = "disablebind =0"
		liRC = idsReceiveDetail.Update()
//			SQLCA.DBParm = "disablebind =1"
		If liRC = 1 then
			Commit;
		Else
			lslogout = sqlca.sqlerrtext /*text will be lost after rollback*/
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Rollback;
			gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Receive Detail Record to database!")
			lbError = True
			COntinue
		End If
				
//		Else /* Errors exist on Detail, mark with status cd and error text*/
//			
//			idsPODetail.SetItem(llDetailPos,'status_cd','E')
//			If Left(lsDetailErrorText,1) = ',' Then lsDetailErrorText = Right(lsDetailErrorText,(len(lsDetailErrorText) - 1)) /*strip first comma*/
//			idsPODetail.SetItem(llDetailPos,'status_message',lsDetailErrorText)
//			
//		End If /*no errors on detail*/
		
	Next /*edi detail record*/
	
	//If there were errors on any of the details and this is a new order, we will delete the header and any details that
	//might have been saved. The header will have been saved before the details were processed but we dont want to keep it
	
	//save any changes made to edi records (status cd, error msg)
	
//	SQLCA.DBParm = "disablebind =0"
	idsPOHeader.Update(True,False) 
	idsPODetail.Update()
	
	idsReceiveMaster.Update()
	idsReceiveDetail.Update()
	
//	SQLCA.DBParm = "disablebind =1"

	Commit;
	
	If lbError or lbDetailErrors Then 
		
		gu_nvo_process_files.uf_writeError("Order Nbr: " + string(lsOrderNo) + " - Order saved with errors!")

		lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
		
		//Update any header/detail records with error status if we didn't catch an individual error on the detail level
		Update edi_inbound_header
		Set status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
		
		Update edi_inbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
		
		Commit;
	
	End If
	
	//We also want to delete a new header (on an update) if there are no details associated with it
	//lsrono should only be populated if we added a new row, if there is more than 1 header row, it has to be an update
	//If it is a new add and there were no detail rows, we don't want to delete it
//MA	If idsReceiveMaster.RowCount() > 1 and lsRoNo > ' ' Then
//		Select Count(*) into :llCount
//		From receive_detail
//		where ro_no = :lsRoNO;
//		
//		If llCount = 0 Then
//			DElete from receive_master where ro_no = :lsRoNo;
//			Commit;
//		End If
//		
//	End If
	
	idsReceiveMaster.REsetUpdate()
	
	// 10/03 - PCONKL - Update notes record with ro_no just created
	// 03/09 - PCONKL - Update any Receive_Alt_Address records just created
	If lsroNO > ' ' Then
		
		Update Receive_notes
		Set ro_no = :lsRONO 
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq;
		
		Commit;
		
//		Update Receive_alt_Address
//		Set ro_no = :lsRONO 
//		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llOrderSeq;
//		
//		Commit;
		
	End If
	
	//10/08 - PCONKL - If we don't have any details for latest header,delete. If we hit it at this point it would be because we deleted all of the detail records above...
//	If idsReceiveMaster.RowCount() > 0 Then
//		
//		lsRoNo = idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no')
//		
//		Select Count(*) into :llCount
//		From receive_detail
//		where ro_no = :lsRoNO;
//		
//		If llCount = 0 Then
//			DElete from receive_master where ro_no = :lsRoNo;
//			Commit;
//		End If
//				
//	End If
			
Next /* EDI Header Record*/

//mark any records as complete that might have been skipped (continued to next header*/


lsLogOut = Space(17) + "- ***END" + string(now())
FileWrite(gilogFileNo,lsLogOut)

For llHeaderPos = 1 to llHeaderCount
	
	lsProject = idsPOHeader.GetITemString(llHeaderPos,'project_id')
	lsOrderNo = idsPOHeader.GetITemString(llHeaderPos,'order_no')
	llBatchSeq = idsPOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no')
	
	Update edi_inbound_header
	Set status_cd = 'C' , status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
				
	Update edi_inbound_detail
	Set Status_cd = 'C', status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
	
	commit;
	
Next

lsLogOut = Space(17) + "- ***END" + string(now())
FileWrite(gilogFileNo,lsLogOut)



If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/

If lbValError Then 
	Return -1
Else
	Return 0
End If


end function

on u_nvo_proc_flextronics.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_flextronics.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

