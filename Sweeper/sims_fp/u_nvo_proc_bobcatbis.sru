HA$PBExportHeader$u_nvo_proc_bobcatbis.sru
$PBExportComments$Process Bobcat Files
forward
global type u_nvo_proc_bobcatbis from nonvisualobject
end type
end forward

global type u_nvo_proc_bobcatbis from nonvisualobject
end type
global u_nvo_proc_bobcatbis u_nvo_proc_bobcatbis

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem

Long	ilDefaultOwner, ilNewItems, ilUpdatedItems
end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_supplier (string aspath, string asproject)
public function integer uf_process_boh (string asinifile)
public function integer uf_process_itemmaster (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	lbOnce
lbOnce = false

Choose Case Upper(Left(asFile,2))
		
	Case 'SM' /*Supplier Master File*/
		
		liRC = uf_Process_Supplier(asPath, asProject)	
		
	Case 'IM' /*Item Master File*/
		
		liRC = uf_Process_ItemMaster(asPath, asProject)	
		
	Case 'PM' /*Processed PM File */
		
//x		liRC = uf_process_po(asPath, asProject)
		
		//Process any added PO's 
		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
			
	Case 'DM' /* Sales Order Files*/
		
//x		liRC = uf_process_so(asPath, asProject)
		
		//Process any added SO's
		//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - Add project parameter
		liRC = gu_nvo_process_files.uf_process_Delivery_order( asProject ) 

Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC



/*Code from Bobcat project object.....


//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName
Integer	liRC

Boolean	bRet

u_nvo_process_standard_gls	lu_gls

Choose Case Upper(Left(asFile,6))
		
	Case 'SIMSPO' /*Processed PO File from GLS */
		
		lu_gls = Create u_nvo_process_standard_gls
		liRC = lu_gls.uf_process_gls_po(asPath, asProject)
		
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
*/
end function

public function integer uf_process_supplier (string aspath, string asproject);
//Process Supplier Master Transaction for Bobcat

u_ds_datastore	ldsSupplier
Datastore	lu_DS

String	lsData, lsTemp, lsLogOut, lsStringData, lsSupplier
			
Integer	liRC,	liFileNo
			
Long		llCount, llNew, llExist, llNewRow, llFileRowCount,	llFileRowPos

Boolean	lbError

ldsSupplier = Create u_ds_datastore
ldsSupplier.dataobject= 'd_supplier_master'
ldsSupplier.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the File In
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
llFileRowCount = lu_ds.RowCount()

For llFileRowPos = 1 to llFileRowCount
	
	w_main.SetMicroHelp("Processing Supplier Master Record " + String(llFileRowPos) + " of " + String(llFileRowCount))
	
	lsData = Trim(lu_ds.GetItemString(llFileRowPos,'rec_Data'))
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
	End If

	//Validate Rec Type is SM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'SM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If

	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate Supplier and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupplier = lsTemp
	
		//Retrieve the DS to populate existing Supplier if it exists, otherwise insert new
		llCount = ldsSupplier.Retrieve(asProject, lsSupplier)
		If llCount <= 0 Then
			
			llNew ++ /*add to new count*/
			ldsSupplier.InsertRow(0)
			ldsSupplier.SetItem(1,'project_id',asProject)
			ldsSupplier.SetItem(1,'supp_code',lsSupplier)
				
		Else /*Supplier Master exists */
		
			llExist += llCount /*add to existing Count*/
					
		End If
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
	/*** Fields after this point will not validate for another delimiter, since the rest of the fields are optional***/
	/*** If any more required fields are added later, we should check for a delimeter up to that point*/
		
	//Supplier Name 
	//  For Bobcat Bismarck, Supplier is 'Supplier #'-'Site Name' (eg. 1000-BISMARCK)
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If

	ldsSupplier.SetItem(1,'supp_name',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 3
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_3',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'address_4',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//City
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'City',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//State
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'State',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Zip
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Zip',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Country
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Country',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Contact
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'Contact_Person',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//telephone
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'tel',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Fax
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'fax',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Email
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'email_Address',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
/* commented out for bobcat bismarck
	//Harmonized Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'harmonized_code',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
*/	
	//VAT ID
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'vat_id',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		

	//??? One too many '|' on incoming files?
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	//ldsSupplier.SetItem(1,'xxx',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//*** If we still have data after the last field, something is wrong with the record
	If lsData > ' ' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data found after expected last column. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
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

public function integer uf_process_boh (string asinifile);// Process the Bobcat Bismarck BOH File


Datastore	ldsOut, ldsboh
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail

Decimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'BOBCATBIS','DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'BOBCATBIS','DBOHNEXTTIME','')
If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		Return 0
	End If
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_nortel_boh' /* at the SKU/Inv Type level */
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Bobcat Bismarck Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'BOBCATBIS',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq < 0 Then Return -1

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
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString += Upper(ldsboh.GetItemString(llRowPos,'wh_code')) + '|'
	lsOutString += Upper(ldsboh.GetItemString(llRowPos,'inventory_type')) + '|'	
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),50) + '|'
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'total_qty'),'############0')
		
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,"BOBCATBIS")

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'BOBCATBIS','DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'BOBCATBIS','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'BOBCATBIS','DBOHNEXTDATE','')
End If



Return 0
end function

public function integer uf_process_itemmaster (string aspath, string asproject);//Process Item Master (IM) Transaction for Bobcat Bismarck (cloned from K&N Filters)


String	lsData, lsTemp, lsLogOut, lsStringData, lsSKU, lsCOO, lsSupp
			
Integer	liRC,	liFileNo
			
Long		llCount,	llOwner, llNew, llExist, llNewRow, llFileRowCount, llFileRowPos

Boolean	lbNew, lbError

datastore ldsItem, lu_DS

ldsItem = Create u_ds_datastore
ldsItem.dataobject= 'd_item_master_w_supp_cd'
ldsItem.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//passing path/file in instead of a single record...
//Open and read the File In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Bobcat Bismarck Processing: " + asPath
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
// done with the file now...


//setDefaultOwner( asProject , 'S', 	'LOGITECH'   )
//setProject( asProject )

/* Bobcat-Bismarck doesn't have a default owner...
//Retrieve default Owner for Bobcat if not already retrieved
If isnull(ilDefaultOwner) or ilDefaultOwner = 0 Then
	
	Select owner_id into :ilDefaultOwner
	From Owner
	Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'BOBCAT';
	
End If
*/
	
llFileRowCount = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	//xx
	//lsData = Trim(asRecData)
	lsData = Trim(lu_ds.GetItemString(llFileRowPos, 'rec_Data'))	
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsData,Len(lsData) - 1)
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
	
		lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSupp = lsTemp
		
		//Retrieve Owner for current supplier
		Select owner_id into :llOwner
		From Owner
		Where project_id = :asProject and owner_type = 'S' and Owner_cd = :lsSupp;

		//Retrieve the DS to populate existing SKU/Supplier if it exists, otherwise insert new
		llCount = ldsItem.Retrieve(asProject, lsSKU, lsSupp)
		If llCount <= 0 Then
				
			ilNewItems ++ /*add to new count*/
			lbNew = True
			llNewRow = ldsItem.InsertRow(0)
			ldsItem.SetItem(1,'project_id', asProject)
			ldsItem.SetItem(1,'SKU', lsSKU)
			ldsItem.SetItem(1,'supp_code', lsSupp)
			//ldsItem.SetItem(1,'owner_id', ilDefaultOwner)
			ldsItem.SetItem(1,'owner_id', llOwner)
								
		Else /*Item Master(s) exist */
			
			ilupdateditems += llCount /*add to existing Count*/
			lbNew = False
		
		End If
				
	Else /*error*/
			
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
			lbError = True
	//		Continue /*Process Next Record */
			
	End If
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
		
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTemp > '' Then
			ldsItem.SetItem(1,'Description',left(lsTemp,70))
		End If
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Description' field. Record will not be processed.")
		lbError = True
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//base UOM maps to UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'UOM' field. Record will not be processed.")
		lbError = True
	End If

	If lsTemp > '' Then
		ldsItem.SetItem(1,'uom_1',left(lsTemp,4))
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Net Weight maps to Weight 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Weight' field. Record will not be processed.")
		lbError = True
	End If

	If isnumber(lsTemp) Then /*only map if numeric*/
		ldsItem.SetItem(1,'weight_1',Dec(lsTemp))
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	
	//Item Delete Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Delete Flag' field. Record will not be processed.")
		lbError = True
	End If
	
	If lsTemp > '' Then
		ldsItem.SetItem(1,'item_delete_ind',lsTemp)
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Product Group
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Product Group' field. Record will not be processed.")
		lbError = True
	End If
	
	//Validate against foreign Key constraint
	If lsTemp > '' Then
		Select Count(*)  into :llCount
		From Item_Group
		Where Project_id = :asProject and grp = :lsTemp;
		
		If llCount > 0 Then
			ldsItem.SetItem(1,'grp',lsTemp)
		End If
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Inventory Class
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Inventory Class' field. Record will not be processed.")
		lbError = True
	End If
	
	If lsTemp > '' Then
		ldsItem.SetItem(1,'inventory_Class',lsTemp)
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//HS Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'HS CODE' field. Record will not be processed.")
		lbError = True
	End If
	
	If lsTemp > '' Then
		ldsItem.SetItem(1,'hs_Code',lsTemp)
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	
	//COO - LAST FIELD
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else 
		lsTemp = lsData
	End If
	
	//Validate COO if present, otherwise Default to XXX
	If Trim(lstemp) = '' Then
		lsCOO = 'XXX'
	Else
		If f_get_Country_name(lsTemp) > ' ' Then
			lsCOO = lsTemp
		Else /*invalid COO */
			gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Country of Origin: '" + lsTemp + "'. Record will not be processed.")
			lbError = True
			End If
	End If
	
	ldsItem.SetItem(1,'country_of_origin_Default',lsCOO)
	
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	
	//Update any record defaults
	ldsItem.SetItem(1,'Last_user','SIMSFP')
	ldsItem.SetItem(1,'last_update',today())
		
	//If record is new...
	If lbNew Then
		ldsItem.SetItem(1,'lot_controlled_ind','N') 
		ldsItem.SetItem(1,'po_controlled_ind','N') 
		ldsItem.SetItem(1,'serialized_ind','N')
		ldsItem.SetItem(1,'po_no2_controlled_ind','N')
		ldsItem.SetItem(1,'container_tracking_ind','N') 
	End If
			
	//Save New Item to DB
	lirc = ldsItem.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Master Record to database!")
		Return -1
//		Continue
	End If
next

w_main.SetMicroHelp("")

If lbError then
	Return -1
Else
	Return 0
End If

Return 0
end function

on u_nvo_proc_bobcatbis.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_bobcatbis.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

