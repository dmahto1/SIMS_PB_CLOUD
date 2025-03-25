HA$PBExportHeader$u_nvo_proc_bobcat.sru
$PBExportComments$Process Bobcat Files
forward
global type u_nvo_proc_bobcat from nonvisualobject
end type
end forward

global type u_nvo_proc_bobcat from nonvisualobject
end type
global u_nvo_proc_bobcat u_nvo_proc_bobcat

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem

end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_supplier (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	bRet

//u_nvo_process_standard_gls	lu_gls

Choose Case Upper(Left(asFile,6))
		
	Case 'SIMSPO' /*Processed PO File from GLS */
		
	//	lu_gls = Create u_nvo_process_standard_gls
	//	liRC = lu_gls.uf_process_gls_po(asPath, asProject)
		
		//Process any added PO's
		lirc = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		
	Case 'SIMSIT', 'POITEM' /*Item Master File */
		
		liRC = uf_process_itemMaster(asPath, asProject)
		
	Case 'SIMSSU', 'POSUPP' /*Supplier Master*/
		
		liRC = uf_process_Supplier(asPath, asProject)
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose


Return liRC
end function

public function integer uf_process_itemmaster (string aspath, string asproject);
// 11/02 PCONKL

//Process Item Master Transaction for Bobcat

u_ds_datastore	ldsItem
datastore	lu_DS

String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, lsCOO, lsTrackByCOO
			
Integer	liRC,	liFileNo
			
Long		llCount,	llDefaultOwner, llOwner, llNew, llExist, llNewRow,	llFileRowCount,	&
			llFileRowPos, llSkuRowCount, llSkuRowPos

Boolean	lbNew, lbError

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
	lsLogOut = "-       ***Unable to Open Item Master File for Bobcat Processing: " + asPath
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

//Default Owner to Bobcat

Select owner_id into :llDefaultOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'Bobcat';
			
//Process each Row
llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	//Remove any previous filter
	ldsItem.SetFilter('')
	ldsItem.Filter()
			
	lsSKU = Trim(Left(lsData,50))
	
	//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
	llCount = ldsItem.Retrieve(asProject, lsSKU)
	If llCount <= 0 Then
			
		llNew ++ /*add to new count*/
		lbNew = True
		ldsItem.InsertRow(0)
		ldsItem.SetItem(1,'SKU',lsSKU)
				
	Else /*Item Master(s) exist */
		
		llExist += llCount /*add to existing Count*/
		lbNew = False
		
	End If
		
	//Supplier
		
	lsTemp = Trim(Mid(lsData,51,20))
				
	//If Supplier is Present  Validate. If valid, we will only update Item Master record for this Supplier
	If lsTemp > '' Then
			
		Select Count(*) into :llCount
		From Supplier
		Where Project_ID = :asProject and Supp_code = :lsTemp;
			
		If llCount <=0 Then /*Invalid Supplier*/
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Supplier: '" + lsTemp + "' . Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
				
		Else /*Supplier is Valid*/
				
			If lbNew Then /* A new record, set the supplier and owner for the new record*/
							
				//get the owner for this supplier
				Select owner_id into :llOwner
				From Owner
				Where project_id = :asProject and owner_type = 'S' and Owner_cd = :lsTemp;
					
				If isnull(llOwner) or llOwner = 0 Then llOwner = llDefaultOwner
					
				ldsItem.SetItem(1,'supp_code',lsTemp)
				ldsItem.SetItem(1,'owner_id',llOwner)
					
			Else /*existing record, we only want to update the record for this supplier, filter DW to reflect this*/
					
				ldsItem.SetFilter("supp_code = '" + lsTemp + "'")
				ldsItem.Filter()
					
				//If no records, then we don't have an Item Master for this Supplier, Insert one now
				If ldsitem.RowCOunt() = 0 Then
					llNew ++ /*add to new count*/
					lbNew = True
					llNewRow = ldsItem.InsertRow(0)
					ldsItem.SetItem(llNewRow,'SKU',lsSKU)
					ldsItem.SetItem(llNewRow,'supp_code',lsTemp)
					ldsItem.SetItem(llNewRow,'owner_id',llDefaultOwner)
				End If
			
			End If /*New or Existing item for this supplier? */
							
		End If /*Invalid Supplier*/
			
	Else /*Supplier Not present*/
			
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Supplier is not present. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
			
	End If /*Supplier Present? */
		
	llSkuRowCount = ldsItem.RowCount() /*we will loop to update each iteration of this SKU (multiple Suppliers) or current supplier if filtered (present in File)*/
	
	//Description
	lsTemp = Trim(Mid(lsData,71,70))
	If lsTemp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'Description',lsTemp)
		next
	End If
		
	//UOM 1 
	lsTemp = Trim(Mid(lsData,141,3))
	
	If lsTemp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'uom_1',lsTemp)
		Next
	End If
			
	//COO
	lsTemp = Trim(Mid(lsData,169,3))
	
	//Validate COO if present, otherwise Default to XXX
	If lstemp = '' Then
		lsCOO = 'XXX'
	Else
		// dts 06/06/05 - If track by COO is turned off, set COO to 'XXX'
		Select COO_Managed_Ind into :lsTrackByCOO
		From Project
		Where project_id = :asProject;
		if upper(lsTrackByCOO) = 'N' then
			lsCOO = 'XXX'
		ElseIf f_get_Country_name(lsTemp) > ' ' Then
			lsCOO = lsTemp
		Else /*invalid COO */
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Country of Origin: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			Continue /*Process Next Record */
		End If
	End If
	
	For llSkuRowPos = 1 to llSkuRowCount
		ldsItem.SetItem(llSkuRowPos,'country_of_origin_Default',lsCOO)
	Next
		
	//Cost 
	lsTemp = Trim(Mid(lsData,172,12))
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'std_Cost',Dec(lsTemp))
		Next
	End If
	
	//Update any record defaults
	For llSkuRowPos = 1 to llSkuRowCount	
		
		ldsItem.SetItem(llSkuRowPos,'project_id',asProject)
		ldsItem.SetItem(llSkuRowPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llSkuRowPos,'last_update',today())
		
		//If record is new...
		If lbNew Then
			ldsItem.SetItem(llSkuRowPos,'lot_controlled_ind','N') 
			ldsItem.SetItem(llSkuRowPos,'po_controlled_ind','N') 
			ldsItem.SetItem(llSkuRowPos,'serialized_ind','N')
			ldsItem.SetItem(llSkuRowPos,'po_no2_controlled_ind','N')
			ldsItem.SetItem(llSkuRowPos,'container_tracking_ind','N')
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


Return 0
end function

public function integer uf_process_supplier (string aspath, string asproject);
//Process Supplier Master Transaction for Bobcat

u_ds_datastore	ldsSupplier
DAtastore	lu_DS

String	lsData, lsTemp, lsLogOut, lsStringData, lsSupplier
			
Integer	liRC,	liFileNo
			
Long		llCount, llNew, llExist, llNewRow, llFileRowCount,	llFileRowPos

Boolean	lbError

ldsSupplier = Create u_ds_datastore
ldsSupplier.dataobject= 'd_supplier_master'
ldsSupplier.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Supplier Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Supplier Master File for Bobcat Processing: " + asPath
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
	
	w_main.SetMicroHelp("Processing Supplier Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
		
	//Validate Supplier and retrieve existing or Create new Row
	lsSupplier = Trim(Mid(lsData,1,20))
	
	//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
	llCount = ldsSupplier.Retrieve(asProject, lsSupplier)
	If llCount <= 0 Then
		
		llNew ++ /*add to new count*/
		ldsSupplier.InsertRow(0)
		ldsSupplier.SetItem(1,'project_id',asProject)
		ldsSupplier.SetItem(1,'supp_code',lsSupplier)
			
	Else /*Supplier Master exists */
	
		llExist += llCount /*add to existing Count*/
					
	End If
			
	//Supplier Name 
	lsTemp = Trim(Mid(lsData,21,40))
	ldsSupplier.SetItem(1,'supp_name',lsTemp)
			
		
	//Address 1
	lsTemp = Trim(Mid(lsData,61,40))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'address_1',lsTemp)
	End If
			
	//Address 2
	lsTemp = Trim(Mid(lsData,101,40))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'address_2',lsTemp)
	End If
		
	//Address 3
	lsTemp = Trim(Mid(lsData,141,40))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'address_3',lsTemp)
	End If
			
	//Address 4
	lsTemp = Trim(Mid(lsData,181,40))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'address_4',lsTemp)
	End If
			
	//City
	lsTemp = Trim(Mid(lsData,221,30))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'City',lsTemp)
	End If
	
	//State
	lsTemp = Trim(Mid(lsData,251,35))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'State',lsTemp)
	End If
	
	//Zip
	lsTemp = Trim(Mid(lsData,286,15))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'Zip',lsTemp)
	End If
		
	//Country
	//lsTemp = Trim(Mid(lsData,61,40))
	//ldsSupplier.SetItem(1,'Country',lsTemp)
	
	//Contact
	lsTemp = Trim(Mid(lsData,301,40))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'Contact_Person',lsTemp)
	End If
		
	//telephone
	lsTemp = Trim(Mid(lsData,341,20))
	If lsTemp > '' Then
		ldsSupplier.SetItem(1,'tel',lsTemp)
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

on u_nvo_proc_bobcat.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_bobcat.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

