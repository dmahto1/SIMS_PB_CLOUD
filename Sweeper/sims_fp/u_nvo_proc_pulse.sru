HA$PBExportHeader$u_nvo_proc_pulse.sru
$PBExportComments$Process Pulse Files
forward
global type u_nvo_proc_pulse from nonvisualobject
end type
end forward

global type u_nvo_proc_pulse from nonvisualobject
end type
global u_nvo_proc_pulse u_nvo_proc_pulse

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
public function integer uf_process_suppliers (string aspath, string asproject)
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_dboh (string asinifile)
public function integer uf_process_daily_receipts (string asinifile)
public function integer uf_process_dsf (string asinifile)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_customer (string aspath, string asproject)
public function integer uf_process_itemmaster (string aspath, string asproject)
public function integer uf_process_po (string aspath, string asproject, string asfile, ref string aspolinecountfilename)
end prototypes

public function integer uf_process_suppliers (string aspath, string asproject);
// 11/02 PCONKL

//Process Supplier Master Transaction for Pulse

u_ds_datastore	ldsSupplier
DAtastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsSupplier
			
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
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Supplier Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Supplier Master File for Pulse Processing: " + asPath
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
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
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
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
	/*** Fields after this point will not validate for another delimiter, since the rest of the fields are optional***/
	/*** If any more required fields are added later, we should check for a delimeter up to that point*/
		
	//Supplier Name 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsDAta
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
	
	//Harmonized Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'harmonized_code',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//VAT ID
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsSupplier.SetItem(1,'vat_id',lsTemp)
			
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

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 4 characters of the file name

String	lsLogOut,	&
			lsSaveFileName, &
			lsPOLineCountFileName
			
Integer	liRC

Boolean	bRet

Choose Case Upper(Left(asFile,6))
		
	Case  'POSHIP'   //  'SIMSPO', 'PULSEP' /*Processed PO File from GLS */
		
		liRC = uf_process_po(asPath, asProject, asFile, lsPOLineCountFileName)
	
//		If trim(lsPOLineCountFileName) <> '' then
//			//If file was processed successfully, move to archive directory, otherwise move to error directory
//			If liRC = 0 Then
//				
//				lsSaveFileName = ProfileString(gsinifile,"PULSE","archivedirectory","") + '\' + lsFiles[llFilePos] + '.txt'
//				
//				//Check for existence of the file in the archive directory already - rename if duplicated
//				If FileExists(lsSaveFileNAme) Then
//					
//					lsTemp =  lsFiles[llFilePos]
//					
//					// 03/04 - PCONKL - rename with timestap at end instead of X
//					lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsTemp + '.' + String(DateTime(Today(),Now()),'yyyymmddhhmmss') + '.txt'
//					
//				End If /*file already exists*/
//				
//				bret=MoveFile(lsFileToProc,lsSaveFileName)
//			
//				If bret Then
//					lsLogOut = '          File was processed successfully and moved to: ' + lsSaveFileName
//					FileWrite(giLogFileNo,lsLogOut)
//					uf_write_log(lsLogOut)
//				Else /*unable to archive file*/
//					lsLogOut = '             *** File was processed successfully but was NOT archived: ' + lsSaveFileName
//					FileWrite(giLogFileNo,lsLogOut)
//					uf_write_log(lsLogOut)
//				End If
//			
//			Elseif liRC = -1 Then  /*validation error = -1, unable to open file = -99*/
//				
//				lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsFiles[llFilePos] + '.txt'
//				// 03/02 - Pconkl - Check for existence of the file in the Error directory already - rename if duplicated
//				If FileExists(lsSaveFileName) Then
//					lsTemp = + lsFiles[llFilePos]
//					Do While FileExists(lsSaveFileNAme)
//						lsTemp = 'X' + LsTemp
//						lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsTemp
//						lsSaveFileName = lsSaveFileName + '.txt' // add TXT as default for notepad
//					Loop
//				End If /*file already exists*/
//			
//					//lsSaveFileName = lsSaveFileName + '.txt' // add TXT as default for notepad
//					bret=MoveFile(lsFileToProc,lsSaveFileName)
//					
//					If bret Then
//						lsLogOut = '          ** File had errors and was moved to: ' + lsSaveFileName
//						FileWrite(giLogFileNo,lsLogOut)
//						uf_write_log(lsLogOut)
//					Else /*unable to archive file*/
//						lsLogOut = '             *** File had errors but was NOT archived: ' + lsSaveFileName
//						FileWrite(giLogFileNo,lsLogOut)
//						uf_write_log(lsLogOut)
//					End If
//				
//				
//			Elseif liRC = -99 then /*unable to open file, leave in directory, we'll try and process again*/
//			
//			End If
//
//		End If
	
		if liRC <>  -1 then
	
			//Process any added PO's
			liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
		
		end if
		
	Case 'IM_200', 'IM_201' /*Item Master File (200 is beginning of datestamp)*/
		
		liRC = uf_Process_ItemMaster(asPath, asProject)
		
	Case 'VM_200', 'VM_201' /*Supplier Master File (200 is beginning of datestamp)*/
		
		liRC = uf_Process_Suppliers(asPath, asProject)
		
	Case 'CM_200',  'CM_201' /*Customer Master File (200 is beginning of datestamp)*/
		
		liRC = uf_Process_Customer(asPath, asProject)
		
	Case  'POLINE'
		
		liRC = -99
		
		//Moved to archive in 'POSHIP' process
		
//	Case 'DM_200','DM_201' /* Sales Order Files*/ - NOT USED IN NEW PULSE
//		
//		liRC = uf_process_so(asPath, asProject)
//		
//		//Process any added SO's
//		liRC = gu_nvo_process_files.uf_process_Delivery_order() 
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

////Some files will be sent to GLS for processing
//If Upper(left(asFile,4)) = 'POSH' 	or 	Upper(left(asFile,4)) = 'POLI'		or &
//	Upper(left(asFile,4)) = 'POCO' 	or 	Upper(left(asFile,4)) = 'VM_2'		or &
//	Upper(left(asFile,4)) = 'IM_2'	or 	Upper(left(asFile,4)) = 'CM_2'						Then
//			
//		// PO & MAster files go to different  directories
//		//Master files need to have the trailing spaces removed so instead of copying to new folder, we will Open, read, trim and write to the new directory
//		If Upper(left(asFile,4)) = 'POSH' or Upper(left(asFile,4)) = 'POLI' or Upper(left(asFile,4)) = 'POCO' Then
//			lsSaveFileName = ProfileString(gsInifile,asProject,"glsoutdirectory-po","") + '\' + asFile
//			bret=gu_nvo_process_files.CopyFile(asPath,lsSaveFileName,True)
//		Else
//			lsSaveFileName = ProfileString(gsInifile,asProject,"glsoutdirectory-master","") + '\' + asFile
//			lsLogOut = Space(10) + "Trimming Master file data for GLS: " + lsSaveFileName
//			FileWrite(giLogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_Log(lsLogOut)
//			bRet = gu_nvo_process_files.uf_trim_File(aspath, lsSaveFileName) /*Trim any spaces and output to new file*/
//		End If
//				
//		If Bret Then
//			lsLogOut = Space(10) + "File copied to GLS for processing: " + lsSaveFileName
//			FileWrite(giLogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_Log(lsLogOut)
//		Else /*unable to Copy*/
//			lsLogOut = Space(10) + "*** Unable to copy file to GLS for processing: " + asPath
//			FileWrite(giLogFileNo,lsLogOut)
//			gu_nvo_process_files.uf_write_Log(lsLogOut)
//		End If
//	
//End If /*send to GLS */

Return liRC
end function

public function integer uf_process_dboh (string asinifile);

//Process the Pulse Daily Balance on Hand Confirmation File - Create by wason 07/03


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run


lsNextRunDate = ProfileString(asIniFile,'Pulse','DBOHNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'Pulse','DBOHNEXTTIME','')

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	//Messagebox("NOt Valid",lsNextRunTime)
	Return 0
Else /*valid date*/
	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	//Messagebox('next/Current',string(ldtNextRunTime) + '/' + String(dateTime(today(),now())))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		//Messagebox("NOt tIME",lsNextRunTime)
		Return 0
	End If
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_pulse_boh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: Pulse Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'Pulse',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for Pulse BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by '|'
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'BH|' /*rec type = balance on Hand Confirmation*/
	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + '|'
	lsOutString += left(ldsboh.GetItemString(llRowPos,'supp_code'),20) + '|'
  	lsOutString += left(ldsboh.GetItemString(llRowPos,'owner_cd'),20) + '|'
	lsOutString += left(ldsboh.GetItemString(llRowPos,'wh_code'),10) + '|'
	lsOutString += left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += left(ldsboh.GetItemString(llRowPos,'lot_no'),20) + '|'
	
	if IsNull(ldsboh.GetItemString(llRowPos,'container_ID')) then
		lsOutString +='|'
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'container_ID') + '|'
	end if
			
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + '|'
	
	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY')
	End If
	
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'Pulse','DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'Pulse','DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'Pulse','DBOHNEXTDATE','')
End If

Return 0
end function

public function integer uf_process_daily_receipts (string asinifile);//Process the Pulse Daily Balance on Hand Confirmation File -create by wason 07/03

Datastore	ldsOut,	&
				ldsrfm,  &
				ldsrfd
				
Long			llRowPos,	&
            llRowPoss,  &
				llRowCount,	&
				llRowCounts,&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsRo_No,&
				lstype

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'Pulse','DRFNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'Pulse','DRFNEXTTIME','')

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	//Messagebox("NOt Valid",lsNextRunTime)
	Return 0
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	//Messagebox('next/Current',string(date(lsNextRunDate)) + '/' + String(dateTime(today(),now())))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		//Messagebox("NOt tIME",lsNextRunTime)
		Return 0
	End If
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsrfm = Create Datastore
ldsrfm.Dataobject = 'd_daily_receive_master'
lirc = ldsrfm.SetTransobject(sqlca)

ldsrfd = Create Datastore
ldsrfd.Dataobject = 'd_daily_receive_detail'
lirc = ldsrfd.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: Pulse Daily Recipts File"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile,'Pulse',"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for Pulse daily receipt data confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the daily receipt Data
gu_nvo_process_files.uf_write_log('Retrieving daily receipt data on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsrfm.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by '|'
gu_nvo_process_files.uf_write_log('Processing daily receipt data on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt   
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'RH|' /*rec type = balance on Hand Confirmation*/
   
	lsOutString += ldsrfm.GetItemString(llRowPos,'RO_NO') + '|'
    
	lsOutString += ldsrfm.GetItemString(llRowPos,'Supp_Invoice_No')+ '|'
		
	if IsNull(String(ldsrfm.GetItemDatetime(llRowPos,'Ord_date'))) then
		lsOutString +='|'
	else	
	   lsOutString += String(ldsrfm.GetItemDatetime(llRowPos,'Ord_date')) + '|'
	end if
		
	lsOutString += string(ldsrfm.GetItemDatetime(llRowPos,'Arrival_Date')) + '|'
	lsOutString += string(ldsrfm.GetItemDatetime(llRowPos,'Complete_Date')) + '|'

	if IsNull(ldsrfm.GetItemString(llRowPos,'Ord_Type')) then
		lsOutString +='|'
	else	
	   lsOutString += ldsrfm.GetItemString(llRowPos,'Ord_Type') + '|'
	end if

		lsOutString += ldsrfm.GetItemString(llRowPos,'WH_Code') + '|'
		lsOutString += ldsrfm.GetItemString(llRowPos,'Inventory_Type') + '|'
		lsOutString += ldsrfm.GetItemString(llRowPos,'Supp_Code') + '|'
				
	if IsNull(ldsrfm.GetItemString(llRowPos,'supplier_Supp_Name')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'supplier_Supp_Name') + '|'
	end if
		
	if IsNull(ldsrfm.GetItemString(llRowPos,'Ship_Via')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'Ship_Via') + '|'
	end if
	
	if IsNull(ldsrfm.GetItemString(llRowPos,'Ship_Ref')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'Ship_Ref') + '|'
	end if
	
   if IsNull(ldsrfm.GetItemString(llRowPos,'User_Field1')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'User_Field1') + '|'
	end if
	
	 if IsNull(ldsrfm.GetItemString(llRowPos,'User_Field4')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'User_Field4') + '|'
	end if
	
   if IsNull(ldsrfm.GetItemString(llRowPos,'User_Field6')) then
		lsOutString +='|'
	else	
		lsOutString += ldsrfm.GetItemString(llRowPos,'User_Field6') + '|'
	end if
   
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsro_no = ldsrfm.GetItemString(llRowPos,'RO_NO')
	llRowCounts = ldsrfd.Retrieve(lsproject,lsro_no)
	
		 For llRowPoss = 1 to llRowCounts
		
		 llNewRow = ldsOut.insertRow(0)
       lsOutString = 'RD|' /*rec type = receipt detail data on Hand Confirmation*/
	    lsOutString += ldsrfd.GetItemString(llRowPoss,1) + '|'  //container_id
		 lsOutString += ldsrfd.GetItemString(llRowPoss,2) + '|'  //ro_no
		 lsOutString += string(ldsrfd.GetItemNumber(llRowPoss,3)) + '|'//line_item_no
		 lsOutString += ldsrfd.GetItemString(llRowPoss,4) + '|'        //user_line_item_no
		 lsOutString += ldsrfd.GetItemString(llRowPoss,5) + '|'        //sku
		 lsOutString += ldsrfd.GetItemString(llRowPoss,6) + '|'        //alterate_sku
		 lsOutString += ldsrfd.GetItemString(llRowPoss,7) + '|'        //description
		 lsOutString += ldsrfd.GetItemString(llRowPoss,8) + '|'        //owner_id
		 lsOutString += ldsrfd.GetItemString(llRowPoss,9) + '|'        //coo
		 lsOutString += ldsrfd.GetItemString(llRowPoss,10) + '|'       //location
		 lsOutString += ldsrfd.GetItemString(llRowPoss,11) + '|'       //inventory_type
		 lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,12)) + '|'//quantity
		 lsOutString += ldsrfd.GetItemString(llRowPoss,13) + '|'        //uom

       if IsNull(ldsrfd.GetItemString(llRowPoss,14)) then
		   lsOutString +='|'
	    else	
		   lsOutString += ldsrfd.GetItemString(llRowPoss,14) + '|'      //UOM_conversion,user_field5
	    end if
       
		 if IsNull(string(ldsrfd.GetItemNumber(llRowPoss,15))) then
		   lsOutString +='|'
	    else	
		   lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,15)) + '|' //cost
	    end if
   
		 lsOutString += ldsrfd.GetItemString(llRowPoss,16) + '|'           //storage_cd
		 
		 if IsNull(ldsrfd.GetItemString(llRowPoss,17)) then
			lsOutString +='|'
		 else
		   lsOutString += ldsrfd.GetItemString(llRowPoss,17) + '|'           //Inspection code
		 end if
		 
		 lsOutString += ldsrfd.GetItemString(llRowPoss,18) + '|'           //IMI ID
		 lsOutString += ldsrfd.GetItemString(llRowPoss,19) + '|'           //PO_Nomber
		 lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,20)) + '|'   //length
		 lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,21)) + '|'   //width
		 lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,22)) + '|'   //height
		 lsOutString += String(ldsrfd.GetItemNumber(llRowPoss,23)) + '|'   //weight_gross
		 If string(ldsrfd.GetItemDatetime(llRowPoss,24),'MM/DD/YYYY') <> "12/31/2999" Then
			 lsOutString += String(ldsrfd.GetItemDatetime(llRowPoss,24),'MM/DD/YYYY')  //expiration_date
		 End If
		 
		 ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	    ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	    ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	    ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
       
	next/*next detail output record*/
	
next /*next master output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'Pulse','DRFFREQ','')
If isnumber(lsRunFreq) Then
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'Pulse','DRFNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'Pulse','DRFNEXTDATE','')
End If

//update Receive_master.file_transmit_ind to "Y"
For llRowPos = 1 to llRowCOunt
ldsrfm.setitem(llRowPos,"file_transmit_ind",'Y')
Next

liRC=ldsrfm.update()
If liRC > 0 then
	commit;
Else
	Rollback;
End if

Return 0
end function

public function integer uf_process_dsf (string asinifile);// GAP 7/2003 - Process the PULSE Daily Shipment File
datastore	Uds, uds_serial

Long			llRowCount,	&
				lLRowPos,	&
				llRowCount2,	&
				lLRowPos2,		&
				lLRC,				&
				llRowsProcessed
		
String		lsOutString,	&
				lsData,			&
				lsSupplier,		&
				lsSerialInd,	&
				lsSerialArray,	&
				lsOrder,			&
				lsSerial,		&
				lsSku,			&
				lsFileName,		&
				lsLogOut,		&
				lsProject,		&
				lsSaveFileNAme,	&
				lsSaveFileOut,		&
				lsTemp,				&
				lsNextRunDate,		&
				lsNextRunTime,		&
				lsRunFreq,			&
				lsDAyName,			&
				lsDaysToRun
				
Integer	liFileNo,	&
			liRC

ulong ll_hopen
ulong ll_hConnection
ulong ll_null
ulong ll_dwcontext
boolean lb_currentdir,bRet
string ls_null,ls_password,ls_username,ls_servername
string ls_current_dir,ls_curdir,ls_local
ulong l_buf

DateTime	ldtNextRunTIme
Date		ldtNextRunDate
			
//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

lsNextRunDate = ProfileString(asIniFile,'PULSE','DSFNEXTDATE','')
lsNextRunTime = ProfileString(asIniFile,'PULSE','DSFNEXTTIME','')
lsDaysToRun = ProfileString(asIniFile,'PULSE','DSFDAYSTORUN','') /*days of week to run*/

If trim(lsNextRunDate) = '' or trim(lsNextRunTIme) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/
	ldtNextRunTIme = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		Return 0
	End If
End If

//WE may skip certain days (weekends, etc.)
lsDAyName = Upper(DayName(Today()))
If pos(Upper(lsDaysToRun),lsDAyName) <=0 Then
	
	lsLogOut = Space(5) + "- SKIPPING FUNCTION: DAILY PULSE SHIPMENT FILE - Not scheduled to run on this day of the week."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	//Set the next time to run if freq is set in ini file
	lsRunFreq = ProfileString(asIniFile,'PULSE','DSFFREQ','')
	If isnumber(lsRunFreq) Then
		//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
		ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
		SetProfileString(asIniFile,'PULSE','DSFNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
	End If
	
	Return 0
	
End If /*run for current day of week */

llRowsProcessed = 0

lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  '- PROCESSING FUNCTION: Daily PULSE Shipment File.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut =  ''
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//This Function will create and send the PULSE Daily Shipment File

UDS = Create Datastore
uds.Dataobject = 'd_pulse_dsf'
uds.SetTransObject(SQLCA)

//retrieve all complete Transactions for PULSE That have not already been transmitted
lsProject = ProfileString(asIniFile,"PULSE","project","")
llRowCount = uds.Retrieve(lsProject)

lsLogOut = Space(5) + '- ' + String(llRowCount) + ' Line Items Retrieved for processing.'
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

If llRowCount < 0 Then
	lsLogOut = Space(5) + "*** Unable to Retrieve Daily SHipment File records"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Open a File in the local directory for outputting file
If llRowCount > 0 Then
	
	lsFileName = 'PULSEDSF' + String(Today(),'mmddyy') + '.dat' /*file name + current Date*/

	lsLogOut = Space(5) + "- Opening File : '" + lsFileName + "'"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

	liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockReadWrite!,Append!)
	If liFileNo < 0 Then
		lsLogOut = Space(5) + "*** Unable to open File : '" + lsFileName + "'"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
		Return -1
	End If
	
End If /*records retrieved*/

For llRowPos = 1 to llRowCount /*Process each order picking row*/
	
	lsOutstring = 'GI|' //Default
	
	// Invoice_NO 
	lsData = Trim(uds.GetITemString(llRowPos,"invoice_no"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"
	
	// Cust Order NO 
	lsData = Trim(uds.GetITemString(llRowPos,"cust_order_no"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"
		
	// Order Date 
	lsData =  String(uds.GetITemDateTime(llRowPos,"ord_date"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"
	
	// Complete Date
	lsData =  String(uds.GetITemDateTime(llRowPos,"complete_date"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"		
	
	// Order Type
	lsData = Trim(uds.GetITemString(llRowPos,"ord_type"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//Shipped From -  wh_code
	lsData = Trim(uds.GetITemString(llRowPos,"wh_code"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// cust_code 
	lsData = Trim(uds.GetITemString(llRowPos,"cust_code"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// line_item_no
	lsData = String(uds.GetITemNumber(llRowPos,"line_item_no")) 
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	

	// SKU
	lssku = Trim(uds.GetITemString(llRowPos,"sku"))
	If isnull(lssku) Then lssku = ''
	If isnull(lsData) Then lssku = ''
	lsOutString += lssku +"|"	

	// supp_code
	lsData = Trim(uds.GetITemString(llRowPos,"supp_code"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// owner_cd
	lsData = Trim(uds.GetITemString(llRowPos,"owner_cd"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// country_of_origin
	lsData = Trim(uds.GetITemString(llRowPos,"country_of_origin"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// inventory type
	lsData = Trim(uds.GetITemString(llRowPos,"inventory_type"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"		
	
	//Qty  - taken from picking -
	lsData = String(uds.GetITemNumber(llRowPos,"quantity")) 
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	lot no 
	lsData = Trim(uds.GetITemString(llRowPos,"lot_no"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	PO no 
	lsData = Trim(uds.GetITemString(llRowPos,"po_no"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	container_id
	lsData = Trim(uds.GetITemString(llRowPos,"container_id"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	cntnr Length
	lsData = String(uds.GetITemNumber(llRowPos,"cntnr_length"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	cntnr width
	lsData = String(uds.GetITemNumber(llRowPos,"cntnr_width"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	cntnr_height
	lsData = String(uds.GetITemNumber(llRowPos,"cntnr_height"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	cntnr weight
	lsData = String(uds.GetITemNumber(llRowPos,"cntnr_weight"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	//	user_field1
	lsData = Trim(uds.GetITemString(llRowPos,"user_field1"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"	
	
	// Expiration Date 
	lsData = String(uds.GetITemDateTime(llRowPos,"expiration_date"))
	If isnull(lsData) Then lsData = ''
	lsOutString += lsData +"|"
	
	// 08/03 - PCONKL - RPO Number/Line are concatonated in Delivery Detail User Field 2
	lsData = Trim(uds.GetItemString(llRowPos,'delivery_detail_user_field2'))
	If isnull(lsData) or lsData = '' Then
		lsOutString += '||' /*2 empty columns on export*/
	Else
		If Pos(lsData,'/') = 0 or Pos(lsData,'/') = 1 Then 
			lsOutString += '|' + lsData + '|' /* only one field present, put in RPO Nbr Field*/
		Else
			lsOutString += Right(lsData,(len(lsData) - Pos(lsData,'/'))) + '|' + left(lsData,(Pos(lsData,'/') - 1)) + '|' /*RPO Line + RPO Nbr*/
		End If
	End If
	
	
	// Write out the row - Upper Case
	FileWrite(liFileNo,Upper(lsOutString))
	
	llRowsProcessed ++
	
Next /*Next Pick Row*/

//Close the File
If liFileNo > 0 Then
	FileCLose(liFileNo)
End If

//balance rows retrieved vs rows processed
If llRowCount > 0 Then
	
	If llRowsProcessed < llRowCount Then
		lsLogOut = Space(5) + '- *** Only ' + String(llRowsProcessed) + ' Of ' + string(llRowCount) + ' Rows were processed!'
	Else
		lsLogOut = Space(5) + '- '+ String(llRowsProcessed) + ' Line Items successfully processed.'
	End If
	
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
End If

//Mark the records as extracted
For llRowPos = 1 to llRowCount
	uds.SetITem(llRowPos,'file_transmit_ind','Y')	
Next

//Save changes back to DB
liRC = uds.Update()
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut = Space(5) + "- *** Unable to commit File_transmit_ind on Delivery_Master"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//put file in directories
If llRowCount > 0 Then /*Rows were retrieved*/
	lsSaveFileName = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName
	lsSaveFileOut = ProfileString(asInifile,lsProject,"flatfiledirout","") + '\' + lsFileName		
	//lsSaveFileOut = ProfileString(asInifile,lsProject,"ftpfiledirout","") + '\' + lsFileName	
	
	//Check for existence of the file in the archive directory already - rename if duplicated
	If FIleExists(lsSaveFileNAme) Then
		lsTemp = lsFileName
		Do While FIleExists(lsSaveFileNAme)
			lsTemp = 'X' + LsTemp
			lsSAveFileName = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsTemp
			lsSaveFileOut = ProfileString(asInifile,lsProject,"flatfiledirout","") + '\' + lsTemp	
		Loop
	End If /*file already exists*/
	
	// copy file to Flat File Directory	
	bret=gu_nvo_process_files.CopyFile(lsFileName,lsSaveFileOut,True)
	If bret Then
		lsLogOut = Space(5) + 'File was processed successfully and copied to: ' + lsSaveFileOut
	Else /*unable to archive file*/
		lsLogOut = Space(5) + '** File was processed successfully but was NOT copied to: ' + lsSaveFileOut
	End If
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	// Arhive file 
	bret=gu_nvo_process_files.MoveFile(lsFileName,lsSaveFileName)		
	If bret Then
		lsLogOut = Space(5) + 'File was processed successfully and moved to: ' + lsSaveFileName
	Else /*unable to archive file*/
		lsLogOut = Space(5) + '** File was processed successfully but was NOT archived: ' + lsSaveFileName
	End If
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
End If /*rows were retrieved*/

//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile,'PULSE','DSFFREQ','')
If isnumber(lsRunFreq) Then
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile,'PULSE','DSFNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile,'PULSE','DSFNEXTDATE','')
End If

Return 0
end function

public function integer uf_process_so (string aspath, string asproject);//Process Sales Order files for Pulse

Datastore	ldsDOHeader,	&
				ldsDODetail,	&
				lu_ds
				
String		lsLogout,lsRecData,lsTemp,	lsSupplier,	lsOrdType, lsFileOrdType,	&
				lswarehouse,lsTOWH,lsErrText,	lsConSolNo,	lsHouseAWB,	lsConsolType,	&
				lsMode, lsNewRONO, lsInvoiceNO, lsSKU, lsDateTemp, lsRPO

Integer		liFileNo,liRC
				
Long			llRowCount,	llRowPos,llNewRow,llOrderSeq,	llBatchSeq,	llLineSeq,llCount,		&
				llCONO, llRoNO, llLineItemNo,  llOwner, llPalletCount
				
Decimal		ldQty, ldExistingQTY
				
DateTime		ldtToday
Date			ldtShipDate
Boolean		lbError

ldtToday = DateTime(today(),Now())
				
lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

//Open the File
lsLogOut = '      - Opening File for Sales Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Pulse Processing: " + asPath
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

////Warehouse will have to be defaulted from project master default warehouse
//Select wh_code into :lswarehouse
//From Project
//Where Project_id = :asProject;

//03/04 - PCONKL - hardcode warehouse for now - users were removing fom SIMS.
lsWarehouse = 'PULSE-LIA'

//Get Default owner for Pulse (Supplier) in case we are creating any Non Consolidated FG to Inv Receive Detail records
Select owner_id into :llOwner
From OWner
Where project_id = :asProject and Owner_cd = 'PULSE' and owner_type = 'S';

If isNull(llOwner) Then
	Select owner_id into :llOwner
	From OWner
	Where project_id = :asProject and Owner_cd = 'SS' and owner_type = 'S';
End If

//Get the next available file sequence number
llBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If llBatchSeq <= 0 Then Return -1

llOrderSeq = 0 /*order seq within file*/

llRowCount = lu_ds.RowCount()

//Process each Row
For llRowPos = 1 to llRowCount
	
	lsRecData = lu_ds.GetITemString(llRowPos,'rec_data')
	
	lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1)) /*should be record Type (header or Detail) */
	
	//Process header or Detail */
	Choose Case Upper(lsTemp)
			
		//HEADER RECORD
		Case 'DM' /* Header */
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
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
						
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				lsInvoiceNO = lsTemp /*Inbound ORder # if necessary */
				ldsDOHeader.SetItem(llNewRow,'invoice_no',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Project Number, not mapped for now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Project Number' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'delivery_Date',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Date' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Goods Issue Date
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'schedule_Date',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Goods Issue Date' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Cust Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDOHeader.SetItem(llNewRow,'cust_Code',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'Customer Code' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery ORder Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				lsFileOrdType = lsTemp
				//Set Order Type based on value
				Choose Case Upper(lsFileOrdType)
					Case 'FGC-AM', 'FGC-OM' /*consolidated Finished Goods through AMS or OTEY (AIR)*/
						lsOrdType = 'O'
						lsMode = 'AIR'
					Case 'FGCSAM', 'FGCSOM' /*consolidated Finished Goods through AMS or OTEY (OCEAN)*/
						lsOrdType = 'O'
						lsMode = 'OCEAN'
					Case 'FGD' /*Direct Ship FG - AIR*/
						lsOrdType = 'D'
						lsMode = 'AIR'
					Case 'FGDS' /*Direct Ship FG - OCEAN*/
						lsOrdType = 'D'
						lsMode = 'OCEAN'
					Case 'FGI-AM', 'FGI-OM', 'FGI-HK' /*FG stored in Inventory in Amsterdam, Otey, or HK (AIR) */
						lsOrdType = 'I'
						lsMode = 'AIR'
					Case 'FGISAM', 'FGISOM', 'FGISHK' /*FG stored in Inventory in Amsterdam, Otey, or HK (OCEAN) */
						lsOrdType = 'I'
						lsMode = 'OCEAN'
					Case 'PULL' /*Pull from Inventory (default warehouse)*/
						lsOrdType = 'P'
						lsMode = ''
					Case 'PULL-HK' /*Pull from Inventory - HKG*/
						lsOrdType = 'P'
						lsMode = ''
						lsWarehouse = 'PULSE-LIA'
					Case 'PULL-AM' /*Pull from Inventory - Amsterdam*/
						lsOrdType = 'P'
						lsMode = ''
						lsWarehouse = 'AMS'
					Case 'PULL-OM' /*Pull from Inventory - Otay Mesa */
						lsOrdType = 'P'
						lsMode = ''
						lsWarehouse = 'OTAY'
					Case 'RTNI' /*return to Inventory*/
						lsOrdType = 'R'
						lsMode = ''
					Case 'CITP' /* interplant transfer */
						lsOrdType = 'T'
						lsMode = ''
					Case Else
						gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Delivery Order Type: '" + lsFileOrdType + "'.  Record will not be processed.")
						lbError = True
						Continue /*Next Record */
				End Choose
				
				ldsDOHeader.SetITem(llNewRow,'wh_code',lswarehouse)
				ldsDOHeader.SetItem(llNewRow,'order_Type',lsOrdType)
				ldsDOHeader.SetItem(llNewRow,'ship_via',lsMode)
				
			Else /*error*/
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - No delimiter found after 'delivery Order Type' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// *** No more required Fields, not an error if no delimeters
			
			//Shipping Instructions
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'shipping_instructions_Text',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PackList Notes
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'packlist_notes_text',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer Contract - Leave blank for Now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Job Number - Leave blank for Now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Quote Number - User 4 ??
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'User_field4',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer PO - Customer ORder NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Order_No',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Customer PO Date - Blank
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//carrier
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Carrier',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Name
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'cust_name',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_1',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_2',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_3',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Address 4
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'address_4',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to Street - Blank
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Ship to District
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'district',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Postal Code
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'zip',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//City
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'City',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//State
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'state',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Country
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Country',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Telephone
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'tel',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'house_awb_bol_no',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Delivery AWB
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'awb_bol_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated Invoce No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'Consolidation_No',lsTemp)
										
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated Ship Date - User 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'user_field2',lsTemp)
			
			//For Consolidaiton Header (Order date) - if present and valid
			lsDateTemp = lsTemp
			//lsDateTemp = mid(lsDateTemp,5,2) + '/' +   Right(lsDateTEmp,2) + '/' + left(lsDateTemp,4)      /*format as valid date*/
			lsDAteTemp = left(lsDateTemp,4) + '-' + mid(lsDateTemp,5,2) + '-' +  Right(lsDateTEmp,2)
			If isDAte(lsDateTemp) then
				ldtShipDate = Date(lsDateTemp)
			Else
				ldtShipDate = Date(ldtToday)
			End If
									
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated Pallet Count - User 3
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			//ldsDOHeader.SetItem(llNewRow,'user_field3',String(Long(lsTemp),'########'))
			
			if isnumber(lsTemp) then 
				llPalletCount = Long(lsTemp) /*for Consolidation header*/
			Else
				llPalletCount = 0
			End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated Carton Count
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			//ldsDOHeader.SetItem(llNewRow,'ctn_cnt',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Consolidated Weight
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
		//	ldsDOHeader.SetItem(llNewRow,'weight',lsTemp)
		
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
		
			//Invoice Carton Count
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'ctn_cnt',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Invoice Weight
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = lsRecData
			End If
			ldsDOHeader.SetItem(llNewRow,'weight',lsTemp)
			
			//If there is any left over data, the record is probably off
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			If Len(Trim(lsRecData)) > 1 Then
				gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Data was found after 'Invoice Weight' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
					
			//If this is a consolidated FG Order, we will want to make sure we have a Consolidtion Master
			
			lsConSolNo = ldsDOHeader.GetItemString(llNewRow,'consolidation_No')
			lsHouseAWB = ldsDOHeader.GetItemString(llNewRow,'house_awb_bol_no') 
			
			// Direct shipments may be a consolidation (multiple orers going directly to customer) if Consolidation # is present
			If lsConSolNo > '' Then
				
				Select Count(*) into :llCount
				From Consolidation_MAster
				where Project_Id = :asProject and Consolidation_No = :lsConSolNo;
				
				If llCount <= 0 Then /* create a new consolidation master */
				
					//get the next available CO_NO
					llCONO = gu_nvo_process_files.uf_get_next_seq_no(asProject,'Consolidation_Master','CO_No')
					If llCONO > 0 Then
						
						//Consolidation through Warehouse is based on the Original Order type in the File
						If Upper(lsFileOrdType) = 'FGC-AM' or Upper(lsFileOrdType) = 'FGCSAM' Then /*air or Ocean Consolidations to Amsterdam */
							lsTOWH = 'AMS'
						Else
							lsTOWH = 'OTAY'
						End If
						
						//We'll either be consolidating through a warehouse (W) or direct to Customer (C) 
						//If FG Direct then we're going directly to customer, otherwise going through warehouse)
						If ldsDOHeader.GetItemString(llNewRow,'order_type') = 'D' Then /*Direct*/
						lsConsolType = 'C'
						Else /*Through warehouse*/
							lsConsolType = 'W'
						End If
						
						Insert Into Consolidation_MAster 
										(co_no, project_id, consolidation_no, from_wh_code, to_wh_code, ord_date, ord_Status, ord_Type, Carrier, awb_bol_nbr, pallet_cnt, last_USer, last_Update)
								Values (:llCoNo, :asProject, :lsConSolNo, 'PULSE-LIA', :lsTOWH, :ldtShipDAte, 'I', :lsConsolType, 'MWW', :lsHouseAWB, :llPalletCount, 'SIMSFP', :ldtToday)
						Using SQLCA;
												
						If SQLCA.sqlCode < 0 Then
							lsErrText = sqlca.sqlErrText
							Rollback;
							lsLogOut =  "       ***System Error!  Unable to Save new Consolidation Master Records to database:  " + lsErrText
							FileWrite(gilogFileNo,lsLogOut)
							gu_nvo_process_files.uf_writeError(lsLogOut)
							lbError = True
						End If
						
					End If /*sys number generated OK */
					
				End If /*Consolidation master didn't exist */
				
			Else /* Not Consolidation*/
				
				//If it's not a consolidation and it is FG to Inventory, Create an Inbound Order for the Receiving Warehouse
				If lsOrdType = 'I' Then
					
					//Create a Receive Master Record
					
					//Get the next available RONO
					llROno = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Receive_Master','RO_No')
					If llROno > 0 Then 
					
						lsNewRONO = Trim(Left(asproject,9)) + String(llROno,"0000000")
						
						//To warehouse is based on the File Order Type
						If Upper(lsFileOrdType) = 'FGI-AM' or Upper(lsFileOrdType) = 'FGISAM' Then /*air or Ocean FG to Inventory to Amsterdam */
							lsTOWH = 'AMS'
						Else
							lsTOWH = 'OTAY'
						End If
										
						Insert Into Receive_Master
								(ro_no, Project_id, wh_Code, Supp_code, supp_invoice_No, Ord_Type, ord_status, Ord_Date, Inventory_Type, Last_User, Last_Update)
						Values (:lsNewRONO, :asProject, :lsToWH, 'PULSE', :lsInvoiceNo, 'F', 'N', :ldtToday, 'F', 'SIMSFP', :ldtToday)
						Using SQLCA;
					
						If SQLCA.sqlCode < 0 Then
							lsErrText = sqlca.sqlErrText
							Rollback;
							lsLogOut =  "       ***System Error!  Unable to Save new Receive Master Records (Non-Consolidated FG to Inventory in Receiving WH) to database:  " + lsErrText
							FileWrite(gilogFileNo,lsLogOut)
							gu_nvo_process_files.uf_writeError(lsLogOut)
							lbError = True
						End If
						
					End If /*Valid new RO_NO */
					
				End If /*FG to Inventory*/
				
			End If /*Consolidated FG */
			
			
		// DETAIL RECORD
		Case 'DD' /*Detail */
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			llnewRow = ldsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			ldsDODetail.SetITem(llNewRow,'project_id', asproject) /*project*/
			ldsDODetail.SetITem(llNewRow,'status_cd', 'N') 
			ldsDODetail.SetITem(llNewRow,'edi_batch_seq_no',llbatchseq) /*batch seq No*/
			ldsDODetail.SetITem(llNewRow,'order_seq_no',llOrderSeq) 
			ldsDODetail.SetITem(llNewRow,"order_line_no",string(llLineSeq)) /*next line seq within order*/
			ldsDODetail.SetITem(llNewRow,'Status_cd','N')
						
			//Order Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'invoice_no',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Delivery Order Number' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Line Item Number
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'line_item_no',Long(lsTemp))
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Line Item Number is not numeric. Row will not be processed")
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Number' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			llLineItemNo = Long(lsTemp) /*used in Receive Detail record */
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'SKU',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'SKU' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsSKU = LsTemp /*used in Receive Detail Record*/
			
			//Set supplier to 'SS' - we will allow to pick by alt supplier
			ldsDODetail.SetITem(llNewRow,'supp_code', 'SS')
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Quantity
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				If isNumber(lsTemp) Then
					ldsDODetail.SetItem(llNewRow,'quantity',lsTemp)
				Else
					gu_nvo_process_files.uf_writeError("(Detail) Row: " + String(llRowPos) + " - Quantity is not numeric. Row will not be processed")
				End If
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Quantity' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			ldQTY = Long(lsTemp) /*used in Receive Detail record */
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Note Text
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'line_item_notes',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Line Item Notes' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
						
			//Inventory Type
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsRecData,'|') - 1))
				ldsDODetail.SetItem(llNewRow,'Inventory_type',lsTemp)
			Else /*error*/
				gu_nvo_process_files.uf_writeError("(Detail) Row: " + string(llRowPos) + " - No delimiter found after 'Inventory Type' field. Record will not be processed.")
				lbError = True
				Continue /*Next Record */
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// No more required fields after this point
			
			//Customer PO Line - Mapped to USer Field 1
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'user_field1',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Alternate SKU
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'alternate_sku',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Lot No
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'lot_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//PO NO 2
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'po_no2',lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Serial NO
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			ldsDODetail.SetItem(llNewRow,'serial_no',lsTemp)
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Carton Count - blank for now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//Weight - blank for now
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			// 08/03 - PCONKL - RPO Line and RPO NUmber will be concatonated into Delivery Detail UF2
			
			//RPO Line
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = trim(lsRecData)
			End If
			
			lsRPO = Trim(lsTemp)
						
			lsRecData = Right(lsRecData,(len(lsRecData) - (Len(lsTemp) + 1))) /*strip off to next Column */
			
			//RPO #
			If Pos(lsRecData,'|') > 0 Then
				lsTemp = Left(lsRecData,(pos(lsrecData,'|') - 1))
			Else
				lsTEmp = Trim(lsRecData)
			End If
			
			lsRpo = lsTemp + '/' + lsRPO /* format is RPO NUmber + '/' + RPO Line in UF2 */
			If lsRPO = '/' Then lsRPO = ''
			ldsDODetail.SetItem(llNewRow,'user_field2',lsRPO)
						
			//If this is a Non-Consolidated FG to Inventory, Create the Receive Dedatil Record - Header was created above
			If (lsConsolNo = '' or isnull(lsConsolNo)) and lsOrdType = 'I' Then
				
				ldExistingQTY = 0
				
				//See if we already have a Detail Row, If so add qty, otherwise create a new one
				Select Req_qty into :ldExistingQTY
				From REceive_Detail
				Where ro_no = :lsNewRONO and line_Item_NO = :llLineItemNo and SKU = :lsSKU;
				
				If ldExistingQTY > 0 Then /*line item already exists, add new amount*/
				
					ldExistingQTY += ldQTY
					
					Update Receive_Detail
					Set req_qty = :ldExistingQTY 
					Where ro_no = :lsNewRONO and line_Item_NO = :llLineItemNo and SKU = :lsSKU;
					
				Else /*Create a new Receive DEtail Record */
					
					Insert Into Receive_Detail
						(ro_no, SKU, supp_code, owner_id, Country_of_Origin, alternate_sku, req_qty, alloc_qty,
							damage_qty, line_item_no, user_line_Item_no)
					Values (:lsNewRoNo, :lsSKU, 'PULSE', :llOwner, 'XXX', :lsSKU, :ldQTY, 0,0, :llLineItemNo, :llLineItemNo);
					
					If SQLCA.sqlCode < 0 Then
						lsErrText = sqlca.sqlErrText
						Rollback;
						lsLogOut =  "       ***System Error!  Unable to Save new Receive Detail Records (Non-Consolidated FG to Inventory in Receiving WH) to database:  " + lsErrText
						FileWrite(gilogFileNo,lsLogOut)
						gu_nvo_process_files.uf_writeError(lsLogOut)
						lbError = True
					End If
						
				End If /*new/updated receive detail rec */
				
			End If /*Non consolidated FG to Inv */
							
		Case Else /*Invalid rec type */
			
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
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

public function integer uf_process_customer (string aspath, string asproject);
// 11/02 PCONKL

//Process Customer Master Transaction for Pulse

u_ds_datastore	ldsCustomer
DAtastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsCustomer
			
Integer	liRC,	&
			liFileNo
			
Long		llCount,				&
			llNew,				&
			llExist,				&
			llNewRow,			&
			llFileRowCount,	&
			llFileRowPos

Boolean	lbError

ldsCustomer = Create u_ds_datastore
ldsCustomer.dataobject= 'd_Customer_master'
ldsCustomer.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Customer Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Customer Master File for Pulse Processing: " + asPath
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
	
	w_main.SetMicroHelp("Processing Customer Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
		
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is SM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'CM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate Customer and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsCustomer = lsTemp
	
		//Retrieve the DS to pupulate existing SKU if it exists, other wise insert new
		llCount = ldsCustomer.Retrieve(asProject, lsCustomer)
		If llCount <= 0 Then
			
			llNew ++ /*add to new count*/
			ldsCustomer.InsertRow(0)
			ldsCustomer.SetItem(1,'project_id',asProject)
			ldsCustomer.SetItem(1,'cust_code',lsCustomer)
			ldsCustomer.SetItem(1,'customer_Type','CU') /*Default Customer Type*/
				
		Else /*Customer Master exists */
		
			llExist += llCount /*add to existing Count*/
					
		End If
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Customer' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
			
	/*** Fields after this point will not validate for another delimiter, since the rest of the fields are optional***/
	/*** If any more required fields are added later, we should check for a delimeter up to that point*/
		
	//Customer Name 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsDAta
	End If

	ldsCustomer.SetItem(1,'cust_name',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_1',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 2
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_2',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 3
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_3',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Address 4
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'address_4',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//City
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'City',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//State
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'State',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Zip
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Zip',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//Country
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Country',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Contact
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Contact_Person',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//telephone
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'tel',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Fax
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'fax',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Email
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'email_Address',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Harmonized Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'harmonized_code',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//VAT ID
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'vat_id',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//Price Class
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	ldsCustomer.SetItem(1,'Price_Class',lsTemp)
			
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	
	//*** If we still have data after the last field, something is wrong with the record
	If lsData > ' ' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data found after expected last column. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
	
	
	//Update any record defaults
	ldsCustomer.SetItem(1,'Last_user','SIMSFP')
	ldsCustomer.SetItem(1,'last_update',today())

	//Save Customer to DB
	lirc = ldsCustomer.Update()
	If liRC = 1 then
		Commit;
	Else
		Rollback;
		lsLogOut = Space(17) + "- ***System Error!  Unable to Save Customer Master Record to database!"
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save Customer Master Record to database!")
		//Return -1
		Continue
	End If

Next /*File row to Process */

w_main.SetMicroHelp("")

lsLogOut = Space(10) + String(llNew) + ' Customer Records were successfully added and ' + String(llExist) + ' Records were updated.'
FileWrite(gilogFileNo,lsLogOut)

Destroy ldsCustomer

If lbError then
	Return -1
Else
	Return 0
End If
end function

public function integer uf_process_itemmaster (string aspath, string asproject);// 11/02 PCONKL

//Process Item Master (IM) Transaction for Pulse

u_ds_datastore	ldsItem
datastore	lu_DS

String	lsData,			&
			lsTemp,			&
			lsLogOut, 		&
			lsStringData,	&
			lsSKU,			&
			lsCOO
			
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
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening Item Master File: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open Item Master File for Pulse Processing: " + asPath
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

//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
//Owner defaults to owner ID created for Supplier SS

Select owner_id into :llDefaultOwner
From Owner
Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'SS';
			
//Process each Row
llFileRowCOunt = lu_ds.RowCount()

For llfileRowPos = 1 to llFileRowCOunt
	
	w_main.SetMicroHelp("Processing Item Master Record " + String(llFileRowPos) + " of " + String(llFilerowCOunt))
	
	lsData = Trim(lu_ds.GetITemString(llFileRowPos,'rec_Data'))
	
	//Remove any previous filter
	ldsItem.SetFilter('')
	ldsItem.Filter()
	
	//Make sure first Char is not a delimiter
	If Left(lsData,1) = '|' Then
		lsData = Right(lsDAta,Len(lsData) - 1)
	End If
	
	//Validate Rec Type is IM
	lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	If lsTemp <> 'IM' Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Invalid Record Type: '" + lsTemp + "'. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Validate SKU and retrieve existing or Create new Row
	If Pos(lsData,'|') > 0 Then
	
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		lsSKU = lsTemp
	
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
			
	Else /*error*/
		
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'SKU' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
		
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Supplier
	If Pos(lsData,'|') > 0 Then
		
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
				
		//If Supplier is Present (probably wont happen!), Validate. If valid, we will only update Item Master record for this Supplier
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
			
			//If a new record, then we need to default the Supplier and Owner to 'SS'
			If lbNew Then
				ldsItem.SetItem(1,'Supp_code', 'SS') 
				ldsItem.SetItem(1,'owner_id', llDefaultOWner) 
			End If
			
		End If /*Supplier Present? */
		
	Else /*error - no data found after supplier*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Supplier' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	llSkuRowCount = ldsItem.RowCount() /*we will loop to update each iteration of this SKU (multiple Suppliers) or current supplier if filtered (present in File)*/
	
	//Description
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
		If lsTEmp > '' Then
			For llSkuRowPos = 1 to llSkuRowCount
				ldsItem.SetItem(llSkuRowPos,'Description',left(lsTemp,70))
			next
		End If
	Else /*error*/
		gu_nvo_process_files.uf_writeError("Row: " + string(llFileRowPos) + " - Data expected after 'Description' field. Record will not be processed.")
		lbError = True
		Continue /*Process Next Record */
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	
	/*** Fields after this point will not validate for another delimiter, since the rest of the fields are optional***/
	/*** If any more required fields are added later, we should check for a delimeter up to that point*/
	
	//base UOM maps to UOM 1 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTEmp = lsDAta
	End If

	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'uom_1',left(lsTemp,4))
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Net Weight maps to Weight 1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If

	If isnumber(lsTEmp) Then /*only map if numeric*/
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'weight_1',Dec(lsTemp))
		Next
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter

	//Cycle Count Indicator 
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else
		lsTemp = lsData
	End If

	For llSkuRowPos = 1 to llSkuRowCount
		If isnumber(lsTEmp) Then
			ldsItem.SetItem(llSkuRowPos,'cc_freq',Long(lsTemp))
		Else
			ldsItem.SetItem(llSkuRowPos,'cc_freq',0)
		End If
	Next
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Item Delete Ind
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'item_delete_ind',lsTemp)
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Freight Class
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'freight_Class',lsTemp)
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Storage Code
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'storage_Code',lsTemp)
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Inventory Class
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'inventory_Class',lsTemp)
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//Expiration Date Tracked
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			Choose Case Upper(lsTemp)
				Case "A", "B", "C" /* expiration tracking types */
					ldsItem.SetItem(llSkuRowPos,'expiration_Tracking_Type',lsTemp)
					ldsItem.SetItem(llSkuRowPos,'expiration_Controlled_Ind','Y')
				Case Else /*not tracking */
					ldsItem.SetItem(llSkuRowPos,'expiration_Tracking_Type','')
					ldsItem.SetItem(llSkuRowPos,'expiration_Controlled_Ind','N')
			End Choose
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//COO
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
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
			Continue /*Process Next Record */
			End If
	End If
	
	For llSkuRowPos = 1 to llSkuRowCount
		ldsItem.SetItem(llSkuRowPos,'country_of_origin_Default',lsCOO)
	Next
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Alternate SKU
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'Alternate_Sku',lsTemp)
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
	//IMI Inspection Code -> User Field1
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
// MEA -4/10 - Commented out for new DMA.
//	If lsTEmp > '' Then
//		For llSkuRowPos = 1 to llSkuRowCount
//			ldsItem.SetItem(llSkuRowPos,'user_Field1',lsTemp)
//		Next
//	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//Shelf Life
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If isnumber(lsTemp) Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'Shelf_Life',Long(lsTemp))
		Next
	End If
		
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
	
	//CC3 -> User Field1    
	If Pos(lsData,'|') > 0 Then
		lsTemp = Left(lsData,(pos(lsData,'|') - 1))
	Else /*error*/
		lsTemp = lsData
	End If
	
	If lsTEmp > '' Then
		For llSkuRowPos = 1 to llSkuRowCount
			ldsItem.SetItem(llSkuRowPos,'user_Field1',lsTemp)
		Next
	End If
	
	lsData = Right(lsData,(len(lsData) - (Len(lsTemp) + 1))) //Strip off until the next delimeter
		
		
	
	//Update any record defaults
	For llSkuRowPos = 1 to llSkuRowCount	
		
		ldsItem.SetItem(llSkuRowPos,'project_id',asProject)
		ldsItem.SetItem(llSkuRowPos,'Last_user','SIMSFP')
		ldsItem.SetItem(llSkuRowPos,'last_update',today())
		
		//If record is new...
		If lbNew Then
			ldsItem.SetItem(llSkuRowPos,'lot_controlled_ind','Y') /* always tracking by IMI ID # (lot No) */
			ldsItem.SetItem(llSkuRowPos,'po_controlled_ind','Y') /* 02/03 - PCONKL - always tracking by PO NO*/
			ldsItem.SetItem(llSkuRowPos,'serialized_ind','N')
			ldsItem.SetItem(llSkuRowPos,'po_no2_controlled_ind','N')
			ldsItem.SetItem(llSkuRowPos,'container_tracking_ind','Y') /*always tracking by Container ID*/
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
			lsDesc,					&
			lsArrivalDate,			&
			lsTemp,					&
			lsDest,					&
			lsOWnerCd,				&
			lsPOUOM,					&
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
			lsStockDueDate

Integer	liFileNo,	&
			liRC, &
			liFileNoPOLine, &
			liRCPOLine, &
			liFileRowCount



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
		llShelfLife
		
Decimal	ldEDIBAtchSeq,	&
			ldPOQTY,			&
			ldConvFactor,	&
			ldSIMSQTY,		&
			ldWeight
			
Boolean	lbError, lb_ISPOLIneCountFile = false

DateTime	ldtToday

ldtToday = DateTime(Today(),Now())

ldsPOheader = Create u_ds_datastore
ldsPOheader.dataobject= 'd_po_header'
ldsPOheader.SetTransObject(SQLCA)

ldsPOdetail = Create u_ds_datastore
ldsPOdetail.dataobject= 'd_po_detail'
ldsPOdetail.SetTransObject(SQLCA)

lu_ds = Create datastore
lu_ds.dataobject = 'd_generic_import'

//Open and read the FIle In
lsLogOut = '      - Opening File for Purchase Order Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

integer li_pos
string ls_POLinePath

li_pos = Pos(Upper(asPath), 'POSHIP')

if li_pos > 0 then
	
	ls_POLinePath = Left( asPath, li_pos -1) + 'POLINECOUNT' + Mid( asPath, li_pos + 6)

	lsLogOut = "Path:" + ls_POLinePath
	FileWrite(giLogFileNo,lsLogOut)
	
	if Not FileExists(ls_POLinePath) then
		lsLogOut = "-       ***NO Matching POLINECOUNT File ("+ls_POLinePath+") for " + asFile
		FileWrite(giLogFileNo,lsLogOut)

		gu_nvo_process_files.uf_send_email("PULSE", "POLineErrorEmail", "NO Matching POLINECOUNT File for " + asFile, "NO Matching POLINECOUNT File for " + asFile, "")

		Return -1 

	else

		//Get the total count.
	
		liFileNoPOLine = FileOpen(ls_POLinePath,LineMode!,Read!,LockReadWrite!)
	
		If liFileNoPOLine < 0 Then
			lsLogOut = "-       ***Unable to Open File for Pulse Processing: " + ls_POLinePath
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
			Return -99 /* we wont move to error directory if we can't open the file here*/
		End If
		
		String lsPOLineStringData
		INTEGER liPOLineCount
		
		liRCPOLine = FileRead(liFileNoPOLine,lsPOLineStringData)
	
		liPOLineCount = Integer(Trim(Mid(lsPOLineStringData, 18)))
		
		lb_ISPOLIneCountFile = true

		asPOLineCountFileName = ls_POLinePath
		
		FileClose(liFileNoPOLine)

	end if

end if


liFileNo = FileOpen(asPath,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "-       ***Unable to Open File for Pulse Processing: " + asPath
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return -99 /* we wont move to error directory if we can't open the file here*/
End If

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsStringData)

Do While liRC > 0
	llNewRow = lu_ds.InsertRow(0)
	lu_ds.SetItem(llNewRow,'rec_data',lsStringData) /*record data is the rest*/
	liRC = FileRead(liFileNo,lsStringData)
Loop /*Next File record*/

FileClose(liFileNo)

////Warehouse defaulted from project master default warehouse - only need to retrieve once
//Select wh_code into :lsWarehouse
//From Project
//Where Project_id = :asProject;

//03/04 - PCONKL - hardcode warehouse for now - users were removing fom SIMS.
lsWarehouse = 'PULSE-LIA'
		
//Process each row of the File
llRowCount = lu_ds.RowCount()

For llRowPos = 1 to llRowCount
	
	//Check for Valid length of file, we should at least have everything up to change flag (669)
	If Len(lu_ds.GetItemString(llRowPos,'rec_data')) >= 669 Then
		liFileRowCount = liFileRowCount + 1
	End If

Next

IF (liFileRowCount <> liPOLineCount) AND lb_ISPOLIneCountFile  THEN
	
	lsLogOut = "POLineCount:" + string(liPOLineCount)
	FileWrite(giLogFileNo,lsLogOut)

	lsLogOut = "-       ***Number of lines in: " + asFile + "(" + string(llRowCount) + " Rows) does not match corresponding POLINECOUNT ("+string(liPOLineCount)+" Rows) file."
	FileWrite(giLogFileNo,lsLogOut)

	gu_nvo_process_files.uf_send_email("PULSE", "POLineErrorEmail", "Number of lines in: " + asFile + " does not match corresponding POLINECOUNT file.", "Number of lines in: " + asFile + " (" + string(liFileRowCount) + " Rows) does not match corresponding POLINECOUNT  ("+string(liPOLineCount)+" Rows) file.", "")

	Return -1
	
END IF

For llRowPos = 1 to llRowCount
	
	//Check for Valid length of file, we should at least have everything up to change flag (669)
	If Len(lu_ds.GetItemString(llRowPos,'rec_data')) < 669 Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Record length too short. Record will not be processed.")
		lbError = True
		Continue /*Next record */
	End If
	
	//Header and detail info in the same records
	
	lsOrder = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),5,35)) /*Pos 1 - 35*/
	
	// See if we already have a header, if not, create one
	If ldsPOHeader.Find("Order_no = '" + lsOrder + "'",1,ldsPoHeader.RowCount()) <= 0 Then
		
		llNewRow = ldsPoHeader.InsertRow(0)
					
		//Get the next available Seq #
		ldEDIBAtchSeq = gu_nvo_process_files.uf_get_next_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No')
		If ldEDIBatchSeq < 0 Then
			Return -1
		End If
			
	 // From File...
		
		//Order Number
		ldsPoHeader.SetITem(llNewRow,'order_no',lsOrder)
		
//		//GLS TR ID -    NOT USED ANYMORE
//		ldsPoHeader.SetITem(llNewRow,'gls_tr_id',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),1,35)))
	
		//Supplier
		ldsPoHeader.SetITem(llNewRow,'supp_code',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),61,35)))  
		lsSupplier = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),61,35))  /*used to update Item Master*/		

		
		//Transportation Mode
		ldsPoHeader.SetITem(llNewRow,'ship_via',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),553,35))) 
		
		//Arrival Date - format to mm/dd/yyyy
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),513,8))    
		lsArrivalDate = Mid(lsTemp,1,4) + '/' + Mid(lsTemp,5,2) + '/' + Right(lsTemp,7) 
		ldsPoHeader.SetITem(llNewRow,'arrival_date',lsArrivalDate)
			
		//20100428	
			
		//Stock Due Date - format to mm/dd/yyyy
		lsTemp = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),521 ,8))    
		lsStockDueDate   = Mid(lsTemp,1,4) + '/' + Mid(lsTemp,5,2) + '/' + Right(lsTemp,7)
		ldsPoHeader.SetITem(llNewRow,'user_field2',lsStockDueDate)

		//20100428
		
		//BOL Nbr
//		ldsPoHeader.SetITem(llNewRow,'ship_ref',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),411,35)))   //493
		
		//Destination WareHouse -> User Field 1 (Master)
		lsDest = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),732,35))     //573
		ldsPoHeader.SetITem(llNewRow,'user_Field1',lsDest)

		
		//If Dest is one of the China Plants, retrieve the Owner - it will be set on Detail/Putaway if Present
		Choose Case lsDest
			Case '01' /* 12/03 - PCONKL */
				lsOwnerCd = 'PTO'
			Case '02' /* 12/03 - PCONKL */
				lsOWnerCd = 'SLO'
			Case '04' 
				lsOwnerCd = 'CSM'
			Case '05' 
				lsOwnerCd = 'CPO'
			Case '11'
				lsOwnerCd = 'HPO'
			Case '15'
				lsOwnerCd = 'MPO'
//			Case '16'
//				lsOwnerCd = 'ZLO'
//			Case '13'
//				lsOwnerCd = 'HMLV'
//			Case '19'
//				lsOwnerCd = 'WPO'
			Case '20' /*Central Purchasing*/
				lsownerCd = '20'
			Case Else
				lsOwnerCd = 'PULSE'
		End Choose
		
		Select Min(Owner_ID) into :llOwner
		From Owner
		Where Project_id = 'Pulse' and Owner_cd = :lsOwnerCd;
	
	//Defaults
			
		ldsPOheader.SetITem(llNewRow,'wh_code',lsWarehouse) /*default WH for Project */
		ldsPOheader.SetITem(llNewRow,'project_id',asProject)
		ldsPOheader.SetITem(llNewRow,'action_cd','X') /*no action code - will not be validated and will create/update header as necessary*/
		ldsPOheader.SetITem(llNewRow,'Request_date',String(Today(),'YYMMDD'))
		ldsPOheader.SetItem(llNewRow,'Order_type','S') /*Supplier Order*/
		ldsPOheader.SetItem(llNewRow,'Inventory_Type','N') /*default to Normal*/
		ldsPOheader.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
		llOrderSeq = llNewRow
		ldsPOheader.SetItem(llNewRow,'order_seq_no',llOrderSeq) 
		ldsPOheader.SetItem(llNewRow,'ftp_file_name',asPath) /*FTP File Name*/
		ldsPOheader.SetItem(llNewRow,'Status_cd','N')
		ldsPOheader.SetItem(llNewRow,'Last_user','SIMSEDI')
		
		llDetailSeq = 0 /*detail seq within order for detail recs */
		
	End If /* No header for this ORder*/
	
	//Insert Detail Row
	llNewRow = ldsPODetail.InsertRow(0)
	
	//From File
//	ldsPODetail.SetItem(llNewRow,'gls_so_id',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),36,35))) /*GLS SO ID  */
//	ldsPODetail.SetItem(llNewRow,'gls_so_line',Long(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),528,10)))) /*GLS SO Line */
	ldsPODetail.SetItem(llNewRow,'order_no',lsOrder) /*Order Number */
	ldsPODetail.SetITem(llNewRow,'sku',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),693,35)))    //538
	lsSKU = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),693,35))   
	lsDesc = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),446,35)) /*used to update Item Master*/    //414
	ldsPODetail.SetITem(llNewRow,'line_item_no',Long(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),40,10))))   // 386
		
	//We need to get the Stock Keeping UOM for the Order Detail
	lsUOM = ''
	
	Select uom_1 into :lsuom
	From ITem_Master
	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
		
	//If not present, take from 'SS' - We will be creating a new IM for this supplier down below, copy relevent fields from SS
	If isnull(lsUOM) or lsUOM = '' Then
		/* dts - 4/27/04
				added Expiration_Tracking_Type and Shelf_Life
				and now Grabbing ANY (single) record instead of 'SS' record
				(in case there is no 'SS' record but an update has occurred via uf_process_itemMaster)		*/
		/*
		Select uom_1, weight_1, cc_freq, freight_Class, storage_code, Inventory_Class, expiration_controlled_ind, 
					Alternate_SKU, po_controlled_Ind, po_no2_Controlled_Ind, Serialized_Ind, Country_Of_Origin_Default
		into :lsuom, :ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, :lsExpInd,
				:lsAltSKU, :lsPOInd, :lsPO2Ind, :lsSerializedInd, :lsCOO
		*/
		Select min(uom_1), min(weight_1), min(cc_freq), min(freight_Class), min(storage_code), min(Inventory_Class),
			min(expiration_controlled_ind), min(expiration_Tracking_Type), min(Alternate_SKU), min(po_controlled_Ind), 
			min(po_no2_Controlled_Ind), min(Serialized_Ind), min(Country_Of_Origin_Default), min(Shelf_Life)
		into :lsuom, :ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, 
			:lsExpInd, :lsExpTrack, :lsAltSKU, :lsPOInd,
			:lsPO2Ind, :lsSerializedInd, :lsCOO, :llShelfLife
		From Item_Master
		Where Project_id = :asProject and sku = :lsSKU; //4/27/04 and Supp_code = 'SS';
				
	End If
	
	ldsPODetail.SetItem(llNewRow,'UOM',lsUOM) /*Stock Keeping UOM */
	
	ldsPODetail.SetItem(llNewRow,'Cost',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),497,17))) /*Cost*/
	
	//We need to convert the QTY from the PO Qty to the SIMS QTY using the included conversion factor
	
	//Validate QTY for Numerics
	If Not isnumber(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),481,16))) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - PO QTY is not numeric. Qty has been set to 0.")
		lbError = True
		ldPOQTY = 0
		//Continue /*Next record */
	Else
		ldPOQTY = Dec(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),481,16)))
	End If
	
	//Validate Conversion Factor for Numerics
	If Not isnumber(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),537,16))) Then
		gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - QTY Conversion Factor is not numeric - defaulted to '1'.")
		lbError = True
		ldConvFactor = 1
		//Continue /*Next record */
	Else
		ldConvFactor = Dec(Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),537,16)))
	End If
	ldsPODetail.SetITem(llNewRow,'uom_conversion_factor',ldConvFactor)
	
	//Set Detail UF 1 to PO QTY/UOM
	lsPOUOM = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),588,3)) /* Purchase UOM */
	ldsPODetail.SetITem(llNewRow,'User_field1',String(ldPOQTY,'#######.#####') + '/' + lsPOUOM)
	
	//Calculate and set SIMS Stockkeeping qty
	ldSIMSQTY = ldPOQTY * ldConvFactor
	ldsPODetail.SetITem(llNewRow,'quantity',String(ldSIMSQTY,'##########.#####'))
	
	//HArmonized Code - Used to Update Item MAster Record
//	lsHarmonizedCd = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),624,35))
	
//What is the Harmonized Code?
	
	//Inspection CLass - Used to Update Item MAster Record
	//01/03 - PCONKL - Inspection Class now going on the ORder Detail Record
	//lsInspectionClass = Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),887,4))
	
	ldsPODetail.SetItem(llNewRow,'user_field3',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),887,4))) 
	
	/*User LIne ITem No  */
	ldsPODetail.SetItem(llNewRow,'user_line_Item_No',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),891,16))) 


//	//User Field4 - CC3 - Decided not to use yet.
//
//	ldsPODetail.SetItem(llNewRow,'user_field4',Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),907,5))) 	
//	
	
	
	//Action Code - Unless it is Delete, set to update
//	If Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),907,1)) <> 'D' Then
	If Trim(Mid(lu_ds.GetItemString(llRowPos,'rec_data'),912,1)) <> 'D' Then

		ldsPODetail.SetItem(llNewRow,'action_cd','U')
	Else
		ldsPODetail.SetItem(llNewRow,'action_cd','D') 
	End If
	
	//OwnerID if Present
	ldsPODetail.SetItem(llNewRow,'owner_id',string(llOwner)) 
	
	//Defaults
	//ldsPODetail.SetItem(llNewRow,'action_cd','U') /*No action CD - treat as an update (will still create new rec if doesn't exist */
	ldsPODetail.SetItem(llNewRow,'project_id', asproject) /*project*/
	ldsPODetail.SetItem(llNewRow,'status_cd', 'N') 
	ldsPODetail.SetItem(llNewRow,'Inventory_Type', 'N') 
	ldsPODetail.SetItem(llNewRow,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
	lLDetailSeq ++
	ldsPODetail.SetItem(llNewRow,'order_seq_no',llORderSeq) 
	ldsPODetail.SetItem(llNewRow,"order_line_no",string(lLDetailSeq)) 
	
	//We may need to create a new Item Master for this Supplier or update an existing rec with Desc, Harmonozed Code, Inspection Class
	Select Count(*) into :llCount
	From Item_MAster
	Where Project_id = :asProject and SKU = :lsSKU and supp_code = :lsSupplier;
		
	If llCount <= 0  Then /*Create a new Item MAster*/
		
		//Supplier needs to be validated since we are creating a new Item
		Select Count(*) Into :llCount
		From Supplier
		Where Project_id = :AsProject and Supp_code = :lsSupplier;
	
		If llCount <= 0 Then
			gu_nvo_process_files.uf_writeError("Row: " + string(llRowPos) + " - Supplier Not Found: '" + lsSupplier + "'. Record will not be processed.")
			lbError = True
			Continue /*Next record */
		End If /*Supplier not found*/
	
		//Get the Default Owner for this Supplier
		Select owner_id into :llDefaultOwner
		From Owner
		Where project_id = :asProject and owner_type = 'S' and Owner_cd = :lsSupplier;
		
		//Default values for 'SS' may have been retrived above, use those if present, otherwise default
		If isNull(lsSerializedInd) or lsSerializedInd = '' Then lsSerializedInd = 'N'
		If isNull(lsPOInd) or lsPOInd = '' Then lsPOInd = 'Y' /* 02/03 - PCONKL - will be setting PO IND to yes for all items */
		If isNull(lsPO2Ind) or lsPO2Ind = '' Then lsPO2Ind = 'N'
		If isNull(lsExpInd) or lsExpInd = '' Then lsExpInd = 'N'
		If isNull(lsCOO) or lsCoo = '' Then lsCOO = 'XXX'
		//dts - added Expiration_Tracking_Type and Shelf_life to insert...
		Insert Into Item_MAster (Project_ID, SKU, Supp_code, Owner_ID, Description, Country_Of_Origin_Default, LAst_User,
										Last_Update, lot_Controlled_Ind, po_controlled_Ind, Serialized_Ind, po_no2_controlled_ind,
										expiration_controlled_ind, expiration_tracking_type, shelf_life, container_tracking_ind, hs_Code,  uom_1,
										Weight_1, cc_Freq, freight_Class, Storage_code, Inventory_Class, AlterNate_SKU)
		Values						(:asProject, :lsSKU, :lsSupplier, :llDefaultOwner, :lsDesc, :lsCOO, 'SIMSFP',
											:ldtTODAY, 'Y', :lsPoInd, :lsSerializedInd, :lsPO2Ind, 
											:lsExpInd, :lsExpTrack, :llShelfLife, 'Y', :lsharmonizedCd, :lsUOM,
											:ldWeight, :llCCFreq, :lsFreightClass, :lsStorageCD, :lsInvClass, :lsAltSKU);
				
	Else /*Update the current SKU/Supplier record */
		
		Update Item_MAster
		Set Description = :lsDesc, hs_Code = :lsharmonizedCd
		Where Project_id = :AsProject and SKU = :lsSKU and Supp_Code = :lsSupplier;
		
	End If /*Create/Update Item MAster Record */
		
Next /*File Row */

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

If lbError Then
	Return -1
Else
	Return 0
End If
end function

on u_nvo_proc_pulse.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_pulse.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

