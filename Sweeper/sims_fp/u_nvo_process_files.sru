HA$PBExportHeader$u_nvo_process_files.sru
$PBExportComments$Process Inbound and Outbound SIMS files
forward
global type u_nvo_process_files from nonvisualobject
end type
type filetime from structure within u_nvo_process_files
end type
type str_win32_find_data from structure within u_nvo_process_files
end type
type str_ofstruct from structure within u_nvo_process_files
end type
type os_systemtime from structure within u_nvo_process_files
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type str_win32_find_data from structure
	unsignedlong		fileattributes
	filetime		creationfile
	filetime		lastaccesstime
	filetime		lastwritetime
	unsignedlong		filesizehigh
	unsignedlong		filesizelow
	unsignedlong		reserved0
	unsignedlong		reserved1
	character		filename[260]
	character		altfilename[14]
end type

type str_ofstruct from structure 
    long                cBytes 
    long                fFixedDisk 
    unsignedinteger     nErrCode 
    unsignedinteger     Reserved1 
    unsignedinteger     Reserved2 
    character           szPathName[512] 
end type 

type os_systemtime from structure
	unsignedinteger		ui_wyear
	unsignedinteger		ui_wmonth
	unsignedinteger		ui_wdayofweek
	unsignedinteger		ui_wday
	unsignedinteger		ui_whour
	unsignedinteger		ui_wminute
	unsignedinteger		ui_wsecond
	unsignedinteger		ui_wmilliseconds
end type

global type u_nvo_process_files from nonvisualobject
event ue_timer pbm_timer
event ue_sta ( )
end type
global u_nvo_process_files u_nvo_process_files

type prototypes
Function long  CompareFileTime (ref FILETIME lpFileTime1,ref FILETIME lpFileTime2) Library "KERNEL32.DLL" alias for "CompareFileTime;Ansi" 
Function ulong InternetConnect (ulong hInternet, ref string lpszServerName, long nServerPort, ref string lpszUserName, ref string lpszPassword, ulong dwService, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "InternetConnectA;Ansi"
Function Boolean InternetCloseHandle (ulong hInternet) Library "WININET.DLL"
Function ulong InternetOpen (ref string lpszAgent, ulong dwAccessType, ref string lpszProxy, ref string lpszProxyBypass, ulong dwFlags) Library "WININET.DLL" Alias for "InternetOpenA;Ansi"
Function boolean FtpPutFile (ulong hConnect, ref string lpszLocalFile, ref string lpszNewRemoteFile, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpPutFileA;Ansi"
FUNCTION ulong GetCurrentDirectoryA(ulong BufferLen, ref string currentdir) LIBRARY "Kernel32.dll" alias for "GetCurrentDirectoryA;Ansi"
FUNCTION boolean CopyFile(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" ALIAS for "CopyFileA;Ansi"
Function boolean FtpSetCurrentDirectory (ulong hConnect, ref string lpszDirectory) Library "WININET.DLL" Alias for "FtpSetCurrentDirectoryA;Ansi"
Function boolean FtpGetFile (ulong hConnect, ref string lpszRemoteFile, ref string lpszNewFile, boolean fFailIfExists, ulong dwFlagsAndAttributes,  ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" ALIAS for "FtpGetFileA;Ansi"
FUNCTION ulong FindFirstFile(ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindFirstFileA;Ansi"
FUNCTION boolean FindNextFile(ulong hfindfile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindNextFileA;Ansi"
Function ulong FtpFindFirstFile (ulong hConnect, ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpFindFileData, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpFindFirstFileA;Ansi"
Function boolean InternetFindNextFile (ulong hFind, ref STR_WIN32_FIND_DATA lpvFindData) Library "WININET.DLL" Alias for "InternetFindNextFileA;Ansi"
Function boolean FtpRenameFile (ulong hConnect, ref string lpszExisting, ref string lpszNew) Library "WININET.DLL" Alias for "FtpRenameFileA;Ansi"
Function boolean FtpDeleteFile (ulong hConnect, ref string lpszFileName) Library "WININET.DLL" Alias for "FtpDeleteFileA;Ansi"
Function boolean MoveFile (ref string lpExistingFileName, ref string lpNewFileName ) LIBRARY "kernel32.dll" ALIAS FOR "MoveFileA;Ansi"
Function boolean DeleteFile (ref string lpFileName) LIBRARY "kernel32.dll" ALIAS FOR "DeleteFileA;Ansi" 
Function boolean FtpCommand (ulong hConnect, boolean fExpectResponse, ulong dwFlagsAndAttributes, Ref string lpszCommand, ref ulong dwContext, ref ulong phFtpCommand) Library "WININET.DLL" Alias for "FtpCommandA;Ansi"

FUNCTION long FormatMessage (Long dwFlags, ref Any lpSource, Long dwMessageId, Long dwLanguageId, ref String lpBuffer, Long nSize, Long Arguments) LIBRARY "kernel32" ALIAS FOR "FormatMessageA;Ansi"

FUNCTION ulong CreateMutexA(ulong lpMutexAttributes, long bInitialOwner, ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi" 
FUNCTION ulong GetLastError() library "kernel32.dll" 
function boolean GetComputerNameA(ref string  lpBuffer, ref ulong nSize) library "KERNEL32.DLL" alias for "GetComputerNameA;Ansi"
//function boolean GetComputerNameA(ref string  lpBuffer, ref ulong nSize) library "KERNEL32.DLL" 


Function boolean FileTimeToSystemTime(ref FILETIME lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL"




end prototypes

type variables
string is_owner_ind, isCommandParms[]
string is_coo_ind
String	isEmailLogFile ,is_warehouse
long	ilDBConnectAttempts, ilFTPUploadAttempts
u_ds_datastore	ids_reports, idsXML, idsPOHeader, idsPODetail, idsReceiveMaster, idsReceiveDetail, &
				idsDOHeader, idsDODetail, idsDeliveryMaster, idsDeliveryDetail
ulong	il_hConnection, Il_hopen

Boolean	lbRestartRequested, ibAlreadyRunning, lbRestartScheduled
Private constant long MAX_PATH = 260
Date	idtLogChangeDate

// pvh gmt 12/27/05
u_nvo_dst_setdates	dstUtil

Protected boolean ib_dcmprocessed  // KZUV.COM - Flags if a DCM file has been processed this 'sweep'.

datastore ids_transaction_govenor		// LTK 20111117 govern the number of project transactions processed per sweep
long il_transaction_govenor_rows
boolean ib_refire_sweeper

//TimA 01/12/12 OTM Project
String isDeleteSkus[]  //Capture Sku's before the order is deleted
n_otm iu_otm  //TimA 01/04/12 OTM Project
//String is_OTM_Flag  //Y= Yes use OTM
String is_ProcessOTM_HOLD //Y=Look for Sweeper OTM holds

boolean ib_non_standard_dwo
boolean ib_non_standard_ro_dwo

//dts 2014-06-02 - running Monthly Transactions for both databases from just the non-Pandora scheduler sweeper
transaction Pandora_SQLCA

end variables

forward prototypes
public function integer uf_writeerror (string aserrormsg)
public function integer uf_write_log (string asmsg)
public function boolean uf_trim_file (string asfromfile, string astofile)
public function integer uf_ftp_ack (string asproject)
public function integer uf_process_xml_inbound ()
public function integer uf_close ()
public function integer uf_ftp_setdir (string asdirectory)
public function string uf_ftp_download (string as_directory, string as_filetodownload)
public function integer uf_ftpdirtoarray (string path, ref string lista[], ref string sizea[], unsignedlong al_connect)
public function long uf_get_next_seq_no (string asproject, string astable, string ascolumn)
public function integer uf_ftp_disconnect ()
public function integer uf_parse_xml_to_datastore (string asfile)
public function integer uf_process_flatfile_inbound ()
public function integer uf_process_purchase_order (string asproject)
public function integer uf_process_ftp_inbound ()
public function integer uf_process_flatfile_outbound ()
public function integer uf_process_daily_files (string asaction)
public function integer uf_process_flatfile_outbound (ref datastore adw_output, string asproject)
public function integer uf_open ()
public function integer uf_ftp_upload (string asfilename, string asremotefile, integer aitransfermode)
public function integer uf_process_ftp_outbound ()
public function integer uf_ftp_connect (string asfunction)
public function integer uf_check_restart ()
public function integer uf_process_transaction_file ()
public function integer uf_change_log ()
public function integer uf_check_db_connection ()
public function integer uf_main_file_driver ()
public function integer uf_process_email_outbound ()
public function integer uf_process_workorder (string asproject)
public function integer uf_process_scheduled_activity ()
public function integer uf_process_ftp_outbound (string asdirectory)
public function integer uf_monthly_transactions ()
public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments)
public function integer uf_check_running ()
public function integer uf_zipper (string asfilelist, string aszipfile)
public function integer uf_validate_batch_transactions ()
public function integer check_trans (string asin_out, string asproject, string aswh, string asdate_field, string astrans_type, string asdays)
public function integer uf_process_flatfile_outbound_unicode (ref datastore adw_output, string asproject)
public function integer uf_create_soc_from_po (datastore ads_header, long al_row)
public function integer uf_create_soc_from_po_error (datastore ads_header, long al_row, string as_error_message)
public function integer uf_create_soc_from_mim (datastore ads_header, long al_row)
public function integer uf_create_soc_from_mim_error (datastore ads_header, long al_row, string as_error_message)
public function boolean uf_max_trans_reached (string as_project_id)
public function long uf_max_trans_init ()
public function datetime uf_file_created_datetime (ref string as_filename)
public function integer uf_process_ftp_stuck_files (string asdirectory)
public function integer uf_check_running_ini ()
public function integer uf_process_archive_outbound (ref datastore adw_output, string asproject)
public function boolean uf_is_country_eu_to_eu (string asproject, string as_from_country, string as_to_country)
public subroutine uf_process_delivery_order_setup (string as_project_id)
public subroutine uf_process_purchase_order_setup (string as_project_id, string as_ftp_file_name)
public function integer uf_connect_to_pandora_db ()
public function long uf_process_import_server (string as_project, string as_xml)
public function integer uf_send_email_with_from_address (string asproject, string asdistrblist, string assubject, string astext, string asattachments, string asemail, string aslogo)
public function integer uf_process_om_inbound ()
public function integer uf_connect_to_om (string asproject)
public subroutine uf_disconnect_from_om ()
public function integer uf_process_om_inbound_update (ref datastore adsreceipt)
public function integer uf_process_omc_message (string asrecord, string astype, string assource, string asmessage, long alchangereqno)
public function integer uf_process_om_writeerror (string asproject, string asstatus, long alchangereqno, string asprocesstype, string aserrormsg)
public function integer uf_process_delivery_order (string asproject)
public function integer uf_process_om_warehouse_order (string asproject, ref datastore adsorderlist)
public function integer uf_process_om_outbound_update (ref datastore adsreceipt)
public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction)
public function integer uf_schedule_sweeper_restart ()
public function integer uf_process_om_item_master_update (str_parms astr_item_parm)
public function integer uf_process_load_plan_outbound_update (string asproject)
public function integer uf_create_system_serial_reconciliation (string asproject, string aswhcode, string aslocation, string assku)
end prototypes

public function integer uf_writeerror (string aserrormsg);
//Write a message to the error file


//Create a new file if not already exists
If  Not FileExists(GSerrorfileName) Then
	giErrorFileNo = FileOpen(gsErrorFileNAME,LineMode!,Write!,LockWrite!)
End If

FileWrite(giErrorFileNo,asErrorMsg)
//TimA 12/22/11
yield()

Return 0


end function

public function integer uf_write_log (string asmsg);
Long	llNewRow

w_main.dw_log.SetTransObject(SQLCA) //set Transaction object
llNewRow = w_main.dw_log.InsertRow(0)
w_main.dw_log.SetItem(llNewRow,'log_message',asMsg)
w_main.dw_log.SetRow(llNewRow)
w_main.dw_log.ScrollToRow(llNewRow)

If w_main.dw_log.RowCount() > 500 Then
	//w_main.dw_log.Reset()
	//w_main.TriggerEvent('ue_clear')
	w_main.dw_log.DeleteRow(1)
End If
//TimA 12/22/11
yield()

Return 0
end function

public function boolean uf_trim_file (string asfromfile, string astofile);
Boolean	Bret

String	lsLogOut,	&
			lsStringData
			
Integer	liFileNoIn,	&
			liFileNoOut,	&
			liRC
Long		llPos

//Open Input File
lsLogOut = '      - Opening Input File for Data Trimming: ' + asFromFile
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNoIn = FileOpen(asFromFile,LineMode!,Read!,LockReadWrite!)
If liFileNoIn < 0 Then
	lsLogOut = "-       ***Unable to Open input file for data trimming: " + asFromFile
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return False 
End If

//Open Output File
lsLogOut = '      - Opening Output File for Data Trimming: ' + asToFile
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

liFileNoOut = FileOpen(asToFile,LineMode!,Write!,LockReadWrite!,Replace!)
If liFileNoOut < 0 Then
	lsLogOut = "-       ***Unable to Open output file for data trimming: " + asFromFile
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return False 
End If

//Read and write the records
liRC = FileRead(liFileNoIn,lsStringData)

Do While liRC > 0
		
	lsStringData = Trim(lsStringData)
		
	FileWrite(liFileNoOut,lsStringData)
	liRC = FileRead(liFileNoIn,lsStringData)
	
Loop /*Next File record*/

//Close the Files
FileClose(liFileNoIn)

liRC = FileClose(liFileNoOut)
If liRC < 0 Then
	lsLogOut = "-       ***Unable to Close output file for data trimming: " + asToFile
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	Return False 
End If
//TimA 12/22/11
yield()


Return True
end function

public function integer uf_ftp_ack (string asproject);
	
Return 0
end function

public function integer uf_process_xml_inbound ();
// This function will process Inbound XML files 

String	lsCurDir,	&
			lsLogOut,	&
			lsFiles[],	&
			lsInitArray[],	&
			lsProject,	&
			lsDirectory,	&
			lsFiletoProc,	&
			lsSaveFileName,	&
			lsPath,	&
			lsPatharray[],	&
			lsPathList,	&
			lsDir[],	&
			lsDirList,	&
			lsErrorFIleName,	&
			lsAttach,	&
			lsTemp
			
ulong ll_dwcontext, l_buf
boolean lb_currentdir,	&
			bRet,				&
			lb_fin

long 	lul_handle,	&
		llArrayPos,	&
		llDirPos,	&
		llFilePos,	&
		llPathPos
		
integer liFilePos,	&
			liRC
		
l_buf = 300
lscurdir = space(l_buf)
str_win32_find_data str_find

u_nvo_proc_ecb	lu_ecb

SetPointer(Hourglass!)

//Get a list of all directories to process
lsDirList = ProfileString(gsinifile,'XMLINBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)
lsLogOut = '- PROCESSING FUNCTION: Extract Inbound XML Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)

//For each directory that we are processing, get a list of files to process. Process each file.
For llDirPos = 1 to Upperbound(lsDir)
	//TimA 12/22/11
	yield()
	
	//get a list of files in the directory we're processing 
	str_find.filename=space(MAX_PATH)
	str_find.altfilename=space(14)
	liFilePos = 0
		
	lsProject = ProfileString(gsinifile,lsDir[llDirPos],"project","")
	
	lsLogOut = '    Project: ' + lsProject
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	Choose Case Upper(lsProject) /*create proper UO for processing project specific files*/
		Case 'ECB'
			lu_ecb = Create u_nvo_proc_ecb
	End Choose
	
	//We may have multiple paths to process for a project - seperated by comma
	lsPathList = ProfileString(gsinifile,lsDir[llDirPos],"xmlfiledirin","")
	llPathPos = 0
	Do While Pos(lsPathList,',') > 0
		llPathPos ++
		lsPathArray[llPathPos] = Left(lsPathList,(Pos(lsPathList,',') - 1))
		lsPathList = Right(lsPathlist, (len(lsPathList) - Pos(lsPathList,',')))
	Loop

	llPathPos ++
	lsPathArray[llpathPos] = lsPathList /*get the last/only one*/
	
	//Process each path in list for project
	For llPathPos = 1 to Upperbound(lsPathArray)
	
		lsPath = lspathArray[llPathPos]
		
		lsLogOut = '      Path: ' + lspath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	
		lsFiles = lsInitarray /*reinitialize array*/
		liFilePos = 0
		lsDirectory = lsPath + '\' +  ProfileString(gsinifile,lsDir[llDirPos],"directorymask","")
		lul_handle = FindFirstFile(lsDirectory, str_find)
		If lul_handle > 0  Then/*first file found*/ 
			bREt = True
			do While  bret
				liFilePos ++
  				lsfiles[liFilePos] = str_find.filename
	  	 		bret = FindNextFile(lul_handle, str_find)	
			Loop
		Else /*No files found for processing*/
			lsLogOut = '        No files found to process in directory: ' + lsPath
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut)
		End If

		//Process each file in the current path
		For llFilePos = 1 to Upperbound(lsFiles)
				
			//create an error file to handle any file specific eerors - will have file name + .err
			gsErrorFileName = lsFiles[llFilePos] + '.err.txt'
			
			lsFileToProc = lsPath + '\' + lsFiles[llFilePos] /*file to process*/
			
			//Parse the XML file into the datastore for processing
			liRC = uf_parse_xml_to_datastore(lsFileToProc)
			
			If liRC = 0 Then /* if successfully parsed, process the file*/
		
				//Process for specific project
				Choose Case Upper(lsProject)
				
					Case 'ECB' /*Emery Custom Brokerage Files*/
					
						liRC = lu_ecb.uf_process_files(lsProject,lsFileToProc,gsinifile,idsxml)
				
				End Choose
				
			End If /*successfull parse*/
		
			//If file was processed successfully, move to archive directory, otherwise move to error directory
			If liRC = 0 Then
				lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsFiles[llFilePos]
				
				//Check for existence of the file in the archive directory already - rename if duplicated
				If FIleExists(lsSaveFileNAme) Then
					lsTemp = + lsFiles[llFilePos]
					Do While FIleExists(lsSaveFileNAme)
						lsTemp = 'X' + LsTemp
						lsSAveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsTemp
					Loop
				End If /*file already exists*/
				
				bret=MoveFile(lsFileToProc,lsSaveFileName)
			
				If bret Then
					lsLogOut = '        File was processed successfully and moved to: ' + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				Else /*unable to archive file*/
					lsLogOut = '        ** File was processed successfully but was NOT archived: ' + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				End If
			
			Else /*error*/
				
				lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsFiles[llFilePos]
			lsSaveFileName = lsSaveFileName + '.txt' // add TXT as default for notepad
				bret=MoveFile(lsFileToProc,lsSaveFileName)

				lsLogOut = '        ** File had errors and was moved to: ' + lsSaveFileName
				FileWrite(giLogFileNo,lsLogOut)
				uf_write_log(lsLogOut)
			
			End If
	
			
			//Close the Errorfile created for this file
			FileClose(giErrorFileNo)
		
			//If error file exists, place mesg in log and send email notification
			If FileExists(gsErrorFileName) Then
			
				lsLogOut = '    ** See Error File: ' + gsErrorFileName + ' for more information'
				FileWrite(giLogFileNo,lsLogOut)
				uf_write_log(lsLogOut)
			
				lsErrorFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + gsErrorFileName
				bret=MoveFile(gsErrorFileName,lsErrorFileName)
			
				//Error files will be mailed to distribution list for project - attachment are concatonated with a ';'

				lsLogOut = "   The attached .dat file was rejected by the Emery Worldwide WMS file processor because of validation errors. The attached .err file contains a description of the error(s)."
				lsAttach = lsSaveFileName + ';' + lsErrorFileName
				uf_send_email(lsProject,'CUSTVAL','Emery Worldwide WMS -  File Validation Error',lsLogOut,lsAttach) /*send an email mesg to the systems distribution list*/
			
			End If /*error file exists*/
		
		Next /*Process Next File within current path*/
		
	Next /*Process next path within project*/

Next /*Process next Project*/

Return 0
end function

public function integer uf_close ();String	lsOutPut, lsservice,ls_machine_name
Integer	liRC, li_rc
ulong lul_name_size =25 
 
ls_machine_name = space(lul_name_size)

Disconnect;

Timer(0,w_main) /*end sweep*/

lsOutput = Space(40)
FileWrite(giLogFileNo,lsOutput)

// 05/08 - PCONKL - Include Server Name in email
GetComputerNameA (ls_machine_name, lul_name_size)
	
lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + " (Server: " + ls_machine_Name +  ')  - SIMSFP.EXE processing complete (Normal shutdown).'
FileWrite(giLogFileNo,lsOutput)
uf_write_Log(lsOutPut) /*display msg to screen*/

//If a shceduled restart, don't send email 
If Not lbrestartrequested and not ibAlreadyRunning Then
	uf_send_email('','System','SIMSFP - *Shutdown*',lsOutput,'') /*send an email mesg to the systems distribution list*/
End If

lsOutput = Space(40)
FileWrite(giLogFileNo,lsOutput)

lsOutput = '*********************************************************************************'
FileWrite(giLogFileNo,lsOutput)

//FileClose(giLogFileNO)

//Close the internet connection if Open
If il_hopen > 0 Then
	InternetCLoseHandle(il_hopen)
End If



SetPointer(Arrow!)
Close(w_main)

//If a restart requested, start another instance of Sweeper
// 08/05 - PCONKL - If running as a service, just stop. Service manager will kick off another instance.
If lbrestartrequested Then
	lsservice = ProfileString(gsinifile,"sims3FP","RUNNINGASSERVICE","")
	if lsservice = 'Y' Then
		lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + ' - Running as as service. Service Control Manager will restart.'
		FileWrite(giLogFileNo,lsOutput)
	Else
		Run("sims3fp.exe")
	End If
End If

FileClose(giLogFileNO)

// If we are closing because another instance is already running then do not update the ini file
IF ibAlreadyRunning = FALSE THEN
	
	li_rc = SetProfileString(gsIniFile,'SIMS3FP','STATUS','STOPPED')
	
END IF

Halt
Return 0
end function

public function integer uf_ftp_setdir (string asdirectory);String	ls_Current_dir,	&
			lsLogOut
			
long ll_errcode
			
Boolean	lb_currentdir

//Set the directory from where you want to download the files
lb_currentdir=this.FtpSetCurrentDirectory(il_hConnection,  asdirectory)
ll_errcode = getlasterror()
IF not lb_currentdir THEN
	
	lsLogOut =  "      ***** Unable to change directory to: " + asdirectory
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(giLogFileNo,lsLogOut)
	Return -1
Else
	lsLogOut =  "      Directory changed to: " + asdirectory
	FileWrite(giLogFileNo,lsLogOut)
END IF

Return 0

end function

public function string uf_ftp_download (string as_directory, string as_filetodownload);String	lsLocalFile,	&
			lsCurrentFile,	&
			lsLogOut,	&
			lsNewFile
			
Boolean	bRet			
ULong	ll_dwContext, llErrorCode

lsCurrentFile = Trim(as_fileToDownload)

//Download
//lslocalFile = 
lsLogOut = Space(17) + "- Downloading File: '" + lsCurrentfile + "' to '" + lsLocalFile + "'."
FileWrite(gilogFileNo,lsLogOut)
			
//bRet =this.FtpgetFile(il_hConnection,lsCurrentFile,lslocalFile,false,0,0,ll_dwcontext)
bRet =this.FtpgetFile(il_hConnection,lsCurrentFile,lslocalFile,false,0,2147483648,ll_dwcontext) /*2147483648 = Internet_Flag_Reload, 67108864 = NoCache*/
IF not bRet THEN
	lsLogOut = Space(17) + "- ***Unable to download File : '" + lsCurrentfile + "', File will not be processed. "
	FileWrite(gilogFileNo,lsLogOut)
	Return ''
END IF
	//TimA 12/22/11
	yield()

Return lsLocalfile


end function

public function integer uf_ftpdirtoarray (string path, ref string lista[], ref string sizea[], unsignedlong al_connect);//This function takes two parameter
//1. Path of directory you want to list all the files
//2. All the filenames would be stored in array of strings

ulong l_n,lul_handle
str_win32_find_data str_find
String	lsNullArray[], lsLogOut

boolean lb_fin, bret

integer n


lista[] = lsNullarray[]

str_find.filename=space(MAX_PATH)

str_find.altfilename=space(14)

n = 0

lul_handle=FtpFindFirstFile(al_connect,path, str_find,67108864,l_n) /*67108864 = NoCache*/
//lul_handle=FtpFindFirstFile(al_connect,path, str_find,2214592512,l_n) /*2147483648 = Internet_Flag_Reload, 67108864 = NoCache*/

If isnull(lul_handle) Then
	
	lsLogOut = "           - *** Unable to Return Directory Listing!"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	uf_send_email('','Filexfer'," - ***** Unable to open FTP Connection",lsLogOut,'') /*send an email msg to the file transfer error list*/
	
End iF

do
		
	//dir list will also pick up dots for going up a directory
	// 05/03 - PCONKL - File attribute of 16 = directory
	
	If Trim(Str_find.FileName) > ' ' and left(Str_find.FileName,1) <> '.' and Pos(Str_find.FileName,'.') > 0 Then
	//If Trim(Str_find.FileName) > ' ' and str_find.fileattributes <> 16 Then
		N +=1
	   lista[n] = str_find.filename /*File Name*/
		sizea[n] = String( str_find.Filesizelow) /* 10/02 - Pconkl - Include File Size for ackowledgements*/
	End If
	
	lb_fin =  InternetFindNextFile(lul_handle, str_find)

loop while lb_fin

bRet=InternetCLoseHandle(lul_handle)


return n

 

end function

public function long uf_get_next_seq_no (string asproject, string astable, string ascolumn);
Decimal	llNextSeq
Long		llCount
string	lsproject, lsLogOut
Boolean 	lbSysError

lbSysError = False

sqlca.sp_next_avail_seq_no(asproject,astable,ascolumn,llnextSeq)


If SQLca.SQLCode < 0 Then
	rollback;
	gu_nvo_process_files.uf_writeError("***System Error - Unable to retrieve the Next Available Batch Seq No. File will not be processed.")
	lsLogOut = Space(17) + "-***Unable to retrieve the Next Available Batch Seq No. File will not be processed."
	FileWrite(gilogFileNo,lsLogOut)		
	//Return -1
	lbSysError = True
End If

// 05/02 - Pconkl - If row not, add and try again
If llNextSeq <=0 Then
	
	//See if it already exists, if so that's not the problem. If not, add it
	
	Select Count(*) into :llCount
	From next_sequence_no
	Where Project_id = :asproject and table_name = :astable and column_name = :ascolumn;
	
	If llCount > 0 Then
		
		rollback;
		gu_nvo_process_files.uf_writeError("***System Error - Unable to retrieve the Next Available Batch Seq No. File will not be processed.")
		lsLogOut = Space(17) + "-***Unable to retrieve the Next Available Batch Seq No. File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)	
		lbSysError = True
		//Return - 1
		
	Else /* insert a new row and try again*/
		
		insert Into Next_Sequence_NO
			(project_id, table_name, column_Name, Next_Avail_seq_no)
			Values (:asproject, :asTable, :asColumn, 1);
			
		Commit;
		
		sqlca.sp_next_avail_seq_no(asproject,astable,ascolumn,llnextSeq)
		If SQLca.SQLCode < 0 Then
			rollback;
			gu_nvo_process_files.uf_writeError("***System Error - Unable to retrieve the Next Available Batch Seq No. File will not be processed.")
			lsLogOut = Space(17) + "-***Unable to retrieve the Next Available Batch Seq No. File will not be processed."
			FileWrite(gilogFileNo,lsLogOut)	
			//Return -1
			lbSysError = True
		End If

	End If /*Row not found */
	
End If

// 12/06 - PCONKL - If unable to get a sequence number, DB is fuc*ked, get out!
If lbSysError Then
	//Notify the systems list - otherwise we'll keep resending the records
	uf_send_email('XX','System','***SIMSFP - System Error***',"Unable to get Next Available Sequence Number. Shutting Down!",'') /*send an email mesg to the systems distribution list*/
	uf_close()
End If

commit;
	//TimA 12/22/11
	yield()

Return llNextSeq



//String	lsLogout
//Decimal	ldBatchSeq
//
//sqlca.sp_next_avail_seq_no(asproject,asTable,asColumn,ldBatchSeq)
//commit;
//If ldBatchSeq <= 0 Then
//	gu_nvo_process_files.uf_writeError("***System Error - Unable to retrieve the Next Available Batch Seq No. File will not be processed.")
//	lsLogOut = Space(17) + "-***Unable to retrieve the Next Available Batch Seq No. File will not be processed."
//	FileWrite(gilogFileNo,lsLogOut)		
//	Return -1
//Else
//	Return Long(ldBatchSeq)
//End If
end function

public function integer uf_ftp_disconnect ();ulong ll_null, l_buf, ll_dwcontext, llErrorCode
boolean lb_currentdir,bRet
string ls_null,ls_password,ls_username,ls_servername, lsLogOut
string ls_curdir,ls_local
 


If (Not isnull(il_hConnection)) and il_hConnection > 0 Then
	
	lsLogOut =  '    - DisConnecting from FTP Server. Handle = ' + String(il_hConnection)
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)

	bRet=InternetCLoseHandle(il_hConnection)
	SetNull(il_hConnection)

	IF not bret THEN
		lsLogOut =  " - ***** Unable to disconnect from FTP. "
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End IF	
	
End If

//Close the internet connection if Open - hopefully, clear cache
If il_hopen > 0 Then
	
	lsLogOut =  '    - Closing Internet Connection. Handle = ' + String(il_hopen)
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	bRet=InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
	
	IF not bret THEN
		lsLogOut =  " - ***** Unable to Unable to close Internet Connection. "
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End IF	
	
End If

Return 0
end function

public function integer uf_parse_xml_to_datastore (string asfile);//This function will parse the XML file into generic DS for processing

String	lsLogout,	&
			lsRecData,	&
			lsStringData

Integer	liFileNo,	liRC
Long		llRowPos,	&
			llRow,	&
			llCharPos

lsLogOut = '- Opening File for XML Processing: ' + asFile
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

liFileNo = FileOpen(asFile,LineMode!,Read!,LockReadWrite!)
If liFileNo < 0 Then
	lsLogOut = "- ***Unable to Open File for XML Processing: " + asFile
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut) /*write to Screen*/
	Return -1
End If

//Create the DS if not already done
If NOt isvalid(idsXML) Then
	idsxml = Create datastore
	idsxml.dataobject = 'd_generic_xml_import'
	idsxml.SetTransObject(SQLCA)
End If

idsxml.Reset() 

//read file and load to datastore for processing
liRC = FileRead(liFileNo,lsRecData)

Do While liRC > 0
		
	lsStringData = Trim(lsRecData)
	
	//We also need to remove tabs
	Do While Pos(lsStringData,'~t') > 0
		lsStringData = Replace(lsStringData,Pos(lsStringData,'~t'),1,'')
	Loop
	
	llRowPos ++
	
	//Validate
	
	//First char should be tag beginning '<'
	If left(lsStringData,1) <> '<' Then
		lsLogOut = "- XML Parsing Error - Row: " + string(llRowPos) + ", First char not '<'. File will not be processed."
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut) /*write to Screen*/
		Return -1
	End If
	
	//If the second char is '?', we dont need to save this row
	If Mid(lsStringData,2,1) = '?' Then
		liRC = FileRead(liFileNo,lsRecData)
		Continue
	End If
	
	//Everything up to the first '>' is a tag. If not present, it's an error
	llCharPos = Pos(lsStringData,'>')
	If llCharPos = 0 Then
		lsLogOut = "- XML Parsing Error - Row: " + string(llRowPos) + ", End of Tag Char not found '>'. File will not be processed."
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut) /*write to Screen*/
		Return -1
	End If /*end tag not found*/
	
	llRow = idsxml.InsertRow(0)
	
	//Parse out the tag name to DW field
	idsxml.SetItem(llRow,'tag_name',Left(lsStringData,llCharPos))
	
	//If there is data after the tag, write the tag data to the DW
	If Len(lsStringDAta) > llCharPos Then
		
		//If end tag '</' not found, error*/
		If Pos(lsStringData,'</') <=0 Then
			lsLogOut = "- XML Parsing Error - Row: " + string(llRowPos) + ", End Tag not found after tag data'</'. File will not be processed."
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut) /*write to Screen*/
			Return -1
		End If /*no end tag*/
		
		//Set the tag data:  start - '>' + 1, end = '</' - 1
		idsxml.SetITem(llRow,'tag_data',Mid(lsStringData,(llCharPos + 1),((Pos(lsStringData,'</') - llCharPos) - 1 )))
		
	End If /*Tag data exists*/
		
	//Read the next row from the file
	liRC = FileRead(liFileNo,lsRecData)
	
Loop /*Next File record*/

FileClose(liFileNo)

Return 0
end function

public function integer uf_process_flatfile_inbound ();
// This function will process Inbound Flat files 

String	lsCurDir, lsLogOut,	lsFiles[],	lsInitArray[], lsProject,	lsDirectory, &
			lsFiletoProc,	lsSaveFileName, lsPath,	lsPatharray[],	lsPathList,	&
			lsDir[], lsDirList, lsErrorFIleName, lsAttach, lsTemp, lsArchDir, lsDistList ,aswarehouse 
			
datetime ldt_FileDateTime[]	
filetime lstr_filetime
			
ulong ll_dwcontext, l_buf, l_rec
boolean lb_currentdir,	&
			bRet,				&
			lb_fin

long 	lul_handle,	llArrayPos,	llDirPos, llFilePos,	llPathPos
		
integer liRC
Long	 liFilePos /* 10/08 - PCONKL - changed from INT to Long in case we receive a sh*tload of files. Left variable name the same since there is already a llFilePos */
	
os_systemtime lstr_SystemTime
date ad_filedate
string ls_time
time at_filetime	
datastore ldw_datesort
integer li_row, li_idx

SetNull(aswarehouse)   
	
ldw_datesort = CREATE datastore
//Need to Sort by Datetime
ldw_datesort.dataobject = "d_file_date_sort"	
	
l_buf = 300
lscurdir = space(l_buf)
str_win32_find_data str_find


u_nvo_proc_Hillman 		lu_Hillman
u_nvo_proc_gm			lu_GM
u_nvo_proc_phoenix		lu_phoenix
u_nvo_proc_Logitech		lu_Logitech
u_nvo_proc_solectron 	lu_solectron  //TAM 03/20/2006
u_nvo_proc_powerwave	lu_powerwave
u_nvo_proc_Maquet		lu_maquet
u_nvo_proc_Ironport 	lu_Ironport
u_nvo_proc_Sika			lu_sika // dts - 12/04/07
u_nvo_proc_Comcast 	lu_Comcast
u_nvo_proc_pandora 	lu_Pandora
u_nvo_proc_LMC 			lu_LMC
u_nvo_proc_philips_sg	lu_philips_sg
u_nvo_proc_philips_th		lu_philips_th
u_nvo_proc_nycsp			lu_nycsp //TAM 2009/08/19
u_nvo_proc_ncr			lu_ncr // pvh 12/03/09
u_nvo_proc_pulse			lu_pulse
u_nvo_proc_flextronics					lu_nvo_proc_flextronics
u_nvo_proc_baseline_unicode			lu_nvo_proc_baseline_unicode
u_nvo_proc_epson				lu_nvo_proc_epson
u_nvo_proc_ws					lu_nvo_proc_ws //TAM W&S 2011/04/22
u_nvo_proc_riverbed			lu_Riverbed //BCR 06-OCT-2011
u_nvo_proc_nike_ewms		lu_nike_ewms //MEA 01-NOV-2011
u_nvo_proc_stryker			lu_nvo_proc_stryker //MEA 05-2012
u_nvo_proc_klonelab			lu_nvo_proc_klonelab
u_nvo_proc_tpv				lu_nvo_proc_tpv
u_nvo_proc_physio			lu_nvo_proc_physio
u_nvo_proc_nyx				lu_nvo_proc_nyx  //TAM 2014/03
u_nvo_proc_starbucks_th	lu_nvo_proc_starbucks_th
u_nvo_proc_kinderdijk		lu_nvo_proc_kinderdijk 	//Jxlim 04/28/2013 
u_nvo_proc_funai				lu_nvo_proc_funai  //MEA 06/13
u_nvo_proc_gibson			lu_nvo_proc_gibson  //TAM 01/2015
u_nvo_proc_garmin  			lu_nvo_proc_garmin 	//Jxlim 04/30/2014 
u_nvo_proc_anki	  			lu_nvo_proc_anki 	//Jxlim 09/05/2014 
u_nvo_proc_honda_th		lu_nvo_proc_honda_th 	// LTK 20140915
u_nvo_proc_metro				lu_nvo_proc_metro		// gwm 20141105
//u_nvo_proc_loreal				lu_nvo_proc_loreal		// gwm 20150508 //TimA 05/26/15 Removed loreal to get build done
u_nvo_proc_h2o				lu_nvo_proc_h2o	//28-Dec-2015 :Madhu Added
u_nvo_proc_aspen  			lu_nvo_proc_aspen 	//2016/02/11 TAM 
u_nvo_proc_Kendo				lu_nvo_proc_Kendo
u_nvo_proc_coty				lu_nvo_proc_coty		// gwm 20180409
u_nvo_proc_fabercast		lu_nvo_proc_fabercast		//TAM 20180724
u_nvo_proc_philips_cls		lu_nvo_proc_philips_cls		//24-Jan-2019 :Madhu S28355 -Philips BlueHeart

SetPointer(Hourglass!)

// TAM 2005/04/21	Clear Global variable before processing inbound files file
setnull(gsemail) 


//Get a list of all directories to process
lsDirList = ProfileString(gsinifile,'FLATFILEINBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)
lsLogOut = '- PROCESSING FUNCTION: Extract Inbound Flat Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss") 
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut)

// Reset the ib_dcmprocessed flag.
ib_dcmprocessed = false

//For each directory that we are processing, get a list of files to process. Process each file.
For llDirPos = 1 to Upperbound(lsDir)
	//TimA 12/22/11
	yield()
	
	//get a list of files in the directory we're processing 
	str_find.filename=space(MAX_PATH)
	str_find.altfilename=space(14)
	liFilePos = 0
		
	lsProject = ProfileString(gsinifile,lsDir[llDirPos],"project","")
	
	lsLogOut = '    Directory/Project: ' + lsDir[llDirPos] + '/' + lsProject
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	//TimA 01/17/12 OTM Project
	//Set the OTM Flag
	
	//MEA - Pull from table
	
	Select Enable_OTM_Ind, OTM_Inbound_Order_Send_Ind, OTM_Delivery_Order_Send_Ind
		INTO :gs_OTM_Flag, :gsOTMSendInboundOrder, :gsOTMSendOutboundOrder
		FROM Project
		WHERE project_id = :lsProject USING SQLCA;
//Refre the warehouse to re-direct the failer file mais
	
//	gs_OTM_Flag = ProfileString(gsinifile,lsProject,"OTM_Flag","")
	If isNull(gs_OTM_Flag) Then	gs_OTM_Flag  = ''
	If isNull(gsOTMSendInboundOrder) Then	 gsOTMSendInboundOrder  = ''
	If isNull(gsOTMSendOutboundOrder) Then	gsOTMSendOutboundOrder  = ''	
	
	is_ProcessOTM_HOLD = ProfileString(gsinifile,lsProject,"ProcessOTM_HOLD","")
	If isNull(gs_OTM_Flag) Then	gs_OTM_Flag  = ''
	
	//TimA 06/07/12
	Select Code_id INTO :gs_method_log_flag from lookup_table where Project_ID = :lsProject and Code_type = 'LOG_Trace';
	If isNull(gs_method_log_flag) Then gs_method_log_flag  = 'N'

	if gs_OTM_Flag = 'Y' Then
		iu_otm = Create n_otm //TimA 01/04/12 OTM Project
	End if

	Choose Case Upper(lsProject) /*create proper UO for processing project specific files*/
		
		
		Case 'HILLMAN'
			lu_Hillman = Create u_nvo_proc_Hillman	
		Case 'GM_MI_DAT'
			lu_GM = Create u_nvo_proc_GM
		Case 'PHXBRANDS'
			lu_phoenix = Create u_nvo_proc_phoenix
		// TAM 07/04
		Case 'LOGITECH'
			lu_Logitech = Create u_nvo_proc_Logitech
		Case 'SOLECTRON'
			lu_solectron = Create u_nvo_proc_Solectron
		Case 'POWERWAVE'//PFC 09/06
			lu_powerwave = Create u_nvo_proc_powerwave
		Case 'MAQUET'//PFC 02/07
			lu_maquet = Create u_nvo_proc_maquet
		Case 'IRONPORT'
			lu_Ironport = Create u_nvo_proc_Ironport	
		Case 'SIKA'	//dts 12/07
			lu_Sika = Create u_nvo_proc_Sika
		Case 'COMCAST'	
			lu_Comcast = Create u_nvo_proc_Comcast
		Case 'PANDORA'

			lu_Pandora = Create u_nvo_proc_Pandora
			
			If is_ProcessOTM_HOLD = 'Y' then
				liRC = lu_Pandora.uf_process_holds(lsProject, 'S')
			End if

		Case 'LMC'	
			lu_LMC = Create u_nvo_proc_LMC
		Case 'PHILIPS-SG'	
			lu_philips_sg = Create u_nvo_proc_philips_sg
		Case 'PHILIPS-TH'	
			lu_philips_th = Create u_nvo_proc_philips_th
		Case 'NYCSP'	
			lu_nycsp = Create u_nvo_proc_nycsp
		// pvh - 12/03/09 - NCR
		Case 'NCR'
			lu_ncr = Create u_nvo_proc_ncr
		Case 'PULSE'
			lu_pulse = Create u_nvo_proc_pulse	
		Case 'FLEX-SIN'
			lu_nvo_proc_flextronics = Create u_nvo_proc_flextronics	
		Case 'CHINASTD' , 'BABYCARE', 'GEISTLICH', 'KARCHER','FRIEDRICH','BOSCH'//MSTUART 080811 added babycare //BCR 23-NOV-2011...added Geistlich //TAM 2012/07 added Karcher//TAM 2013/10 Addred Friedrich//TAM 2014/08 Addred BOSCH
			lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode		
		Case 'ASPEN'//TAM 2016/02 Moved Aspen to Custom Object
			lu_nvo_proc_aspen = Create u_nvo_proc_aspen		
		Case 'SMYRNA-MU'
			lu_nvo_proc_epson = Create u_nvo_proc_epson	
		Case 'WS-MHD'  //TAM W&S 2011/04/22
			lu_nvo_proc_ws = Create u_nvo_proc_ws	
		Case 'WS-PR'  //TAM W&S 2016/02
			lu_nvo_proc_ws = Create u_nvo_proc_ws	
		Case 'RIVERBED' //BCR 06-OCT-2011
			lu_Riverbed = Create u_nvo_proc_riverbed	
		Case 'NIKE-MY', 'NIKE-SG'  //MEA 26-OCT-2011
			lu_nike_ewms = Create u_nvo_proc_nike_ewms	
		Case 'STRYKER'  //MEA 5-2012
			lu_nvo_proc_stryker = Create u_nvo_proc_stryker	
		Case 'KLONELAB'  //MEA - 8/12 Added KloneLab
			lu_nvo_proc_klonelab = Create u_nvo_proc_klonelab		
		Case 'TPV'  // 01/13 - PCONKL
			lu_nvo_proc_tpv = Create u_nvo_proc_tpv		
		Case 'PHYSIO-MAA', 'PHYSIO-XD'  // 01/13 - PCONKL
			lu_nvo_proc_physio = Create u_nvo_proc_physio
		Case 'NYX'  //2014/03 - TAM
			lu_nvo_proc_nyx = Create u_nvo_proc_nyx
		Case 'STBTH'  // 04/13 - PCONKL
			lu_nvo_proc_starbucks_th = Create u_nvo_proc_starbucks_th
		Case 'KINDERDIJK'  // 04/28/2013 - Jxlim
			lu_nvo_proc_kinderdijk = Create u_nvo_proc_kinderdijk
		Case 'FUNAI'  // 01/13 - PCONKL
			lu_nvo_proc_funai = Create u_nvo_proc_funai
		Case 'GIBSON'  // 01/2015 - TAM
			lu_nvo_proc_gibson = Create u_nvo_proc_gibson
		Case 'GARMIN'  // 04/30/2014 - Jxlim
			lu_nvo_proc_garmin = Create u_nvo_proc_garmin
		Case 'ANKI'  // 09/06/2014 - Jxlim
			lu_nvo_proc_anki = Create u_nvo_proc_anki
		Case 'HONDA-TH'  // LTK 20140915
			lu_nvo_proc_honda_th = Create u_nvo_proc_honda_th
		Case 'METRO'	// gwm 20141105
			lu_nvo_proc_metro = Create u_nvo_proc_metro
		//Case 'LOREAL'	// gwm 20150508  //TimA 05/26/15 Remove to get build done
		//	lu_nvo_proc_loreal = Create u_nvo_proc_loreal
		
		Case	'H2O'	//28-Dec-2015 :Madhu Added
			lu_nvo_proc_h2o =Create u_nvo_proc_h2o
		Case	'KENDO'	//03/16 - PCONKL
			lu_nvo_proc_kendo =Create u_nvo_proc_kendo
		Case 'COTY'	// gwm 20180409
			lu_nvo_proc_coty = Create u_nvo_proc_coty
		Case 'FABER-CAST'	// TAM 20180724
			lu_nvo_proc_fabercast = Create u_nvo_proc_fabercast
		Case 'PHILIPSCLS'
			lu_nvo_proc_philips_cls = Create u_nvo_proc_philips_cls
	End Choose
	
	//We may have multiple paths to process for a project - seperated by comma
	lsPathArray = lsInitarray /*reinitialize array*/
	lsPathList = ProfileString(gsinifile,lsDir[llDirPos],"flatfiledirin","")
	llPathPos = 0
	Do While Pos(lsPathList,',') > 0
		llPathPos ++
		lsPathArray[llPathPos] = Left(lsPathList,(Pos(lsPathList,',') - 1))
		lsPathList = Right(lsPathlist, (len(lsPathList) - Pos(lsPathList,',')))
	Loop

	llPathPos ++
	lsPathArray[llpathPos] = lsPathList /*get the last/only one*/
	
	//Process each path in list for project
	For llPathPos = 1 to Upperbound(lsPathArray)
		
		// 06/21 - GXMOR - Reset record limit counter for next project/path
		l_rec = 0
	
		lsPath = lspathArray[llPathPos]
		
		lsLogOut = '      Path: ' + lspath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	
		If lsPath = '' or isnull(lsPath) Then Continue
		
		lsFiles = lsInitarray /*reinitialize array*/

		liFilePos = 0
		//lsDirectory = lsPath + '\' +  ProfileString(gsinifile,lsDir[llDirPos],"directorymask","")
		lsDirectory = lsPath + '\*.*'
		lul_handle = FindFirstFile(lsDirectory, str_find)
		
		If lul_handle > 0  Then/*first file found*/ 
		
			bRet = True
			
			do While bRet
				
				//12/03 - PCONKL - Ignore directories (str_find.fileattributes=16)
				If Trim(Str_find.FileName) > ' ' and &
					Trim(Str_find.FileName) <> '.' and Trim(Str_find.FileName) <> '..'  Then
					
						liFilePos ++
  						lsfiles[liFilePos] = str_find.filename
						  
						//Get the File Date
						
						lstr_filetime	=  str_find.lastwritetime //str_find.creationfile	
						 
						FileTimeToSystemTime(lstr_filetime, lstr_SystemTime) 

						// Convert to date
						ad_FileDate = Date(lstr_SystemTime.ui_wyear, lstr_SystemTime.ui_WMonth, lstr_SystemTime.ui_WDay)
						
						ls_Time = String(lstr_SystemTime.ui_wHour) + ":" + &
									 String(lstr_SystemTime.ui_wMinute) + ":" + &
									 String(lstr_SystemTime.ui_wSecond) + ":" + &
									 String(lstr_SystemTime.ui_wMilliseconds)
						at_FileTime = Time(ls_Time)

						ldt_FileDateTime[liFilePos] = datetime (ad_FileDate, at_FileTime)
						  
						  //10/08 - PCONKL - Limit to 5000 files per Sweep - this will kick us out of the loop
						  If liFilePos > 5000 Then bRet = False
						  
				End If
				
				If bRet Then /* if > 5000 files, bret has already been turned off*/
		  	 		bRet = FindNextFile(lul_handle, str_find)	
						
						
				End If
					
			Loop
			
		End If
		
		If liFilePos = 0 Then /*No files found for processing*/
			lsLogOut = '        No files found to process in directory: ' + lsPath
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut)
		End If

		ldw_datesort.Reset()
		
		//Populate the sort datawindow - Sort By Date.
		
		For li_idx = 1 to UpperBound(lsFiles)

			li_row = ldw_datesort.InsertRow(0)

			ldw_datesort.SetItem( li_row, "filename", lsFiles[li_idx] )
			ldw_datesort.SetItem( li_row, "filedatetime", ldt_FileDateTime[li_idx]   )
			
			
		NEXT
		
		//Sort by the date sequence
		
		ldw_datesort.SetSort("filedatetime A")
		ldw_datesort.Sort()
		
		//Set the Array to the new sort order.
		
		For llFilePos = 1 to ldw_datesort.RowCount()

			lsFiles[llFilePos] = ldw_datesort.GetItemString(llFilePos, "filename" )
			
		NEXT	

		//Process each file in the current path
		For llFilePos = 1 to Upperbound(lsFiles)
			
			// 06/21 - GXMOR - Limit the number of files processed to l_buf (currently 300)
			l_rec = l_rec + 1
			if l_rec > l_buf then
				lsLogOut = '             *** Limit of ' + string(l_buf) + ' files for this path has been reached.  Process will continue on next cycle. ' 
				FileWrite(giLogFileNo,lsLogOut)
				uf_write_log(lsLogOut)
				Exit
			end if
			//create an error file to handle any file specific eerors - will have file name + .err
			gsErrorFileName = lsFiles[llFilePos] + '.err.txt' 
			
			// 03/02 - Pconkl - Check for existing Error file already in Error Directory
			lsErrorFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + gsErrorFileName
			
			If FileExists(lsErrorFileName) Then
				
				lsTemp = lsFiles[llFilePos] + '.err.txt' 
				
				Do While FileExists(lsErrorFileName)
					lsTemp = 'X' + lsTemp
					lsErrorFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsTemp
				Loop
				
				gsErrorFileName = lsTemp
				
			End If /*Error file exists*/

			//25-Sep-2014 :Madhu- KLN- KLN B2B Conversion to SPS, IF FilePos ='SPS' instead of file name, don't send any error msg to user.  -START
			If lsFiles[llFilePos] ='SPS' and Upper(lsProject) ='KLONELAB' Then gsErrorFileName =""
			//25-Sep-2014 :Madhu- KLN- KLN B2B Conversion to SPS, IF FilePos ='SPS' instead of file name, don't send any error msg to user.  -END
		
			lsFileToProc = lsPath + '\' + lsFiles[llFilePos]
			
			//Process for specific project
			Choose Case Upper(lsProject)
				
				Case 'HILLMAN' /*Process for HILLMAN */
					liRC = lu_Hillman.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				Case 'PHXBRANDS' /*process for Phoenix Brands*/
					liRC = lu_phoenix.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				//TAM 07/04
				Case 'LOGITECH' /*process for Logitech*/
					liRC = lu_Logitech.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				Case 'SOLECTRON' /*process for SOLECTRON*/
					liRC = lu_solectron.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				Case 'POWERWAVE' /*process for Powerwave*/
					liRC = lu_powerwave.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				Case 'MAQUET' /*process for Maquet*/
					liRC = lu_maquet.uf_process_files(lsProject,lsFileToProc,lsFiles[llFilePos],gsinifile)
				
				Case 'IRONPORT' /*process for Ironport*/
					liRC = lu_ironport.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'SIKA' /*process for Sika*/
					liRC = lu_sika.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'COMCAST' /*process for Comcast*/
					liRC = lu_Comcast.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
					
				Case 'PANDORA' /* process for Pandora */	
			
					// KZUV.COM - Sometimes Pandora sends duplicate DCM files with duplicate records.
					// Only process a single 'DCM' file per sweep.  Then AutoSOC process will be able to filter out duplicates.
					
					//TimA 04/25/12
					//Remove the process that deletes dulplcate DCM files.  The problem is when Pandora drops more than one 
					//Ligitiment file they are deleted once the first one is processed.
					//*************************************************************
					// If this is a DCM file,
				//	If left(lower(lsFiles[llFilePos]), 3) = "dcm" then
						
						// If we've already processed a 'DCM' file this sweep,
				//		if ib_dcmprocessed then
							
							// Delete the duplicate DCM file.
				//			filedelete(lsFileToProc)
							
							// Continue processing with the next file.
				//			continue
				//		End If
					
						// Set the ib_dcmprocessed flag to true.
				//		ib_dcmprocessed = true
						
					// End If this is a DCM file,
				//	End If
					//End TimA 04/25/12 Comment from above
					//********************************************************
					// Process the Pandora file.
					liRC = lu_Pandora.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)

				Case 'LMC' /* process for LMC */
					liRC = lu_LMC.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile, lsDir[llDirPos])
				Case 'PHILIPS-SG' /* process for Philips Singapore */
					liRC = lu_philips_sg.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
			//nxjain		
			Case 'PHILIPS-TH' /* process for Philips Thailand*/
					liRC = lu_philips_th.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile,aswarehouse)
					// checking the warehouse , IF NC warehouse file failed , redirect the validation mail using lookup table
					if (liRC =-1) then
						if aswarehouse ='PHILIPS-NC' then
							Select Code_Descript into :gsEmail 
							from Lookup_Table
							where Project_Id =:lsProject and Code_Type =:aswarehouse ;
						end if 
					end if 
					//nxjain end -03-30-2015
				Case 'NYCSP' /* process for NYCSP */
					liRC = lu_Nycsp.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				// pvh - 12/03/09 - NCR
				Case 'NCR'
					liRC = lu_ncr.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				// End pvh - 12/03/09 - NCR	
				Case 'PULSE'
					liRC = lu_pulse.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'FLEX-SIN'
					liRC = lu_nvo_proc_flextronics.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)					
				Case 'CHINASTD' , 'BABYCARE', 'GEISTLICH', 'KARCHER' , 'FRIEDRICH','BOSCH'//MSTUART 080811 added babycare //BCR 23-NOV-2011...added Geistlich //TAM 2012/07 added Karcher //TAM 2013/10 Added Friedrich//TAM 2014/08 Addred BOSCH
					liRC = lu_nvo_proc_baseline_unicode.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)					
				Case 'ASPEN'//TAM 2016/02 Moved Aspen to Custom Object
					liRC = lu_nvo_proc_aspen.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)					
				Case 'SMYRNA-MU'
					liRC = lu_nvo_proc_epson.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)	
				Case 'WS-MHD' //TAM W&S 2011/04/22
					liRC = lu_nvo_proc_ws.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)	
				Case 'WS-PR' //TAM W&S 2016/02/
					liRC = lu_nvo_proc_ws.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)	
				Case 'RIVERBED' //BCR 06-OCT-2011
					liRC = lu_Riverbed.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'NIKE-MY', 'NIKE-SG'  //MEA 26-OCT-2011
					liRC = lu_nike_ewms.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)	
				Case 'STRYKER'  //MEA 5-2012
					liRC = lu_nvo_proc_stryker.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'KLONELAB'  //MEA - 8/12 Added KloneLab
					//25-Sep-2014 :Madhu- KLN- KLN B2B Conversion to SPS, IF FilePos ='SPS' instead of file name, don't send any error msg to user.  -START
					If lsFiles[llFilePos] = 'SPS' Then
						liRc=1
					ELSE 	//25-Sep-2014 :Madhu- KLN- KLN B2B Conversion to SPS, IF FilePos ='SPS' instead of file name, don't send any error msg to user.  -END
						liRC = lu_nvo_proc_klonelab.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
					END IF
				Case 'TPV'  // 01/13 - PCONKL
					liRC = lu_nvo_proc_tpv.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'PHYSIO-MAA', 'PHYSIO-XD'  // 02/13 - PCONKL
					liRC = lu_nvo_proc_physio.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'NYX'  // 03/14 - TAM
					liRC = lu_nvo_proc_nyx.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'STBTH'  // 04/13 - PCONKL
					liRC = lu_nvo_proc_starbucks_th.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'KINDERDIJK'  // 04/28/2013 Jxlim
					liRC = lu_nvo_proc_kinderdijk.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'FUNAI'  // 06/13 - PCONKL
					liRC = lu_nvo_proc_funai.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'GIBSON'  // 01/2015 - TAM
					liRC = lu_nvo_proc_gibson.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'GARMIN'  // 04/30/2014 Jxlim
					liRC = lu_nvo_proc_garmin.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'ANKI'  // 09/06/2014 Jxlim
					liRC = lu_nvo_proc_anki.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'HONDA-TH'	// LTK 20140915
					liRC = lu_nvo_proc_honda_th.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'METRO'	// gwm 20141105
					liRC = lu_nvo_proc_metro.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
			//	Case 'LOREAL'	// gwm 20150508  //TimA 05/26/15 Remove to get build done
			//		liRC = lu_nvo_proc_loreal.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'H2O'	// 28-Dec-2015 :Madhu Added
					liRC = lu_nvo_proc_h2o.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'KENDO'	// 03/16 - PCONKL
					liRC = lu_nvo_proc_kendo.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'COTY'	// gwm 20141105
					liRC = lu_nvo_proc_coty.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'FABER-CAST'	// TAM 20180724
					liRC = lu_nvo_proc_fabercast.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case 'PHILIPSCLS'
					liRC = lu_nvo_proc_philips_cls.uf_process_files(lsProject, lsFileToProc, lsFiles[llFilePos], gsinifile)
				Case Else /*Invalid Project*/
					lsLogOut = '             *** Invalid Project (' + lsProject + ') specified for file. File will not be processed'
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
					liRC = -99
			End Choose
		
			//If file was processed successfully, move to archive directory, otherwise move to error directory
			If liRC = 0 Then
				
				// GXMOR - 6/23 - Check for archive directory
				lsArchDir = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","")
				if isnull(lsArchDir) or lsArchDir = '' then
					lsLogOut = 'Could not find archive directory in FlatFile Inbound Process. Application Shutdown.'
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
					
					 /*Send an email mesg to custom distribution list for TSG and HP distribution list*/
					 /*Replaced jerieal.arun@con-way.com with tsg@con-way.com */
					 lsDistList = 'conwaywindowsteam@hp.com;tsg@con-way.com;morrison.gail@con-way.com'
					 
					uf_send_email('COMCAST',lsDistList,'SIMS Inbound Sweeper has failed and shutdown',lsLogOut,'')
					
					//Close the internet connection if Open
					If il_hopen > 0 Then
						InternetCLoseHandle(il_hopen)
					End If

					Close(w_main)
					/* Shutdown application */
					FileClose(giLogFileNO)

					Halt
					
				end if
				
				lsSaveFileName =  lsArchDir + '\' + lsFiles[llFilePos] + '.txt'
				
				//Check for existence of the file in the archive directory already - rename if duplicated
				If FileExists(lsSaveFileNAme) Then
					
					lsTemp =  lsFiles[llFilePos]
					
					// 03/04 - PCONKL - rename with timestap at end instead of X
					lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsTemp + '.' + String(DateTime(Today(),Now()),'yyyymmddhhmmss') + '.txt'
					
				End If /*file already exists*/
				//TODO TAM 2011/11 Riverbed wants the Delivery Order file sent back to them as an acknowledgment of receipt.
				IF Upper(lsProject) = 'RIVERBED' and left(lsFiles[llFilePos],2) = 'DM' Then
					lsTemp = lsFiles[llFilePos]
					lsTemp = Replace(lsTemp, pos(Upper(lsFiles[llFilePos]), '.DAT'),4,'_A.DAT')
					lsTemp = ProfileString(gsinifile,lsDir[llDirPos],"flatfiledirout","") + '\' + lstemp
					FileCopy(lsFileToProc,lsTemp)
				END IF
				
				bret=MoveFile(lsFileToProc,lsSaveFileName)
			
				If bret Then
					lsLogOut = '          File was processed successfully and moved to: ' + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				Else /*unable to archive file*/
					lsLogOut = '             *** File was processed successfully but was NOT archived: ' + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				End If
			//SARUNJAIS2016JULY28 : Adding -99 condition with -1
			Elseif  ( liRC = -1 Or  liRC = -99 ) Then  /*validation error = -1, unable to open file = -99*/ 
				
				
				lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsFiles[llFilePos] + '.txt'
				// 03/02 - Pconkl - Check for existence of the file in the Error directory already - rename if duplicated
				If FileExists(lsSaveFileName) Then
					lsTemp = + lsFiles[llFilePos]
					Do While FileExists(lsSaveFileNAme)
						lsTemp = 'X' + LsTemp
						lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + lsTemp
						lsSaveFileName = lsSaveFileName + '.txt' // add TXT as default for notepad
					Loop
				End If /*file already exists*/

				//TODO TAM 2011/11 Riverbed wants the Delivery order file sent back to them as an acknowledgment of receipt.
				IF Upper(lsProject) = 'RIVERBED' and left(lsFiles[llFilePos],2) = 'DM' Then
					lsTemp = lsFiles[llFilePos]
					lsTemp = Replace(lsTemp, pos(Upper(lsFiles[llFilePos]), '.DAT'),4,'_R.DAT')
					lsTemp = ProfileString(gsinifile,lsDir[llDirPos],"flatfiledirout","") + '\' + lstemp
					FileCopy(lsFileToProc,lsTemp)
				END IF
			
					//lsSaveFileName = lsSaveFileName + '.txt' // add TXT as default for notepad
					bret=MoveFile(lsFileToProc,lsSaveFileName)
					
					If bret Then
						lsLogOut = '          ** File had errors and was moved to: ' + lsSaveFileName
						FileWrite(giLogFileNo,lsLogOut)
						uf_write_log(lsLogOut)
					Else /*unable to archive file*/
						lsLogOut = '             *** File had errors but was NOT archived: ' + lsSaveFileName
						FileWrite(giLogFileNo,lsLogOut)
						uf_write_log(lsLogOut)
					End If
				
			ElseIf liRC = 50 Then /* 01/11 - PCONKL - Option to Delete the file instead of archiving it */
				
				bret = DeleteFile(lsFileToProc)
				
				If bret Then
					lsLogOut = '          File was processed successfully and Deleted (RC=50)'
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				Else /*unable to archive file*/
					lsLogOut = '             *** File was processed successfully but was NOT Deleted (RC=50)'
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_log(lsLogOut)
				End If
				
				
//			Elseif liRC = -99 then /*unable to open file, leave in directory, we'll try and process again*/
// 			Sarun2016July28 : As advise by Pete remvoing this condition from itteration.
			
			End If
		
			//Close the Errorfile created for this file
			FileClose(giErrorFileNo)
		
			//If error file exists, place mesg in log and send email notification
			If FileExists(gsErrorFileName) Then


				lsLogOut = '          ** See Error File: ' + gsErrorFileName + ' for more information'
				FileWrite(giLogFileNo,lsLogOut)
				uf_write_log(lsLogOut)
			
				lsErrorFileName = ProfileString(gsinifile,lsDir[llDirPos],"errordirectory","") + '\' + gsErrorFileName
				bret=MoveFile(gsErrorFileName,lsErrorFileName)
			
				//Error files will be mailed to distribution list for project - attachment are concatonated with a ';'
				lsLogOut = "   The attached .dat file was rejected by the XPO Logistics WMS file processor because of validation errors. The attached .err file contains a description of the error(s)."
				lsAttach = lsSaveFileName + ';' + lsErrorFileName
				//uf_send_email(lsProject,'CUSTVAL','XPO Logistics WMS -  File Validation Error',lsLogOut,lsAttach) /*send an email mesg to the systems distribution list*/
// TAM 2005/04/18 send out Email using address returned from function call if one exists
				If Not isnull(gsEmail) and gsEmail <> '' then
					uf_send_email(lsDir[llDirPos],gsEmail,'XPO Logistics WMS -  File Validation Error',lsLogOut,lsAttach) /*send an email mesg to the systems distribution list*/
				Else
					uf_send_email(lsDir[llDirPos],'CUSTVAL','XPO Logistics WMS -  File Validation Error',lsLogOut,lsAttach) /*send an email mesg to the systems distribution list*/
				End If
	
			End If
			// TAM 2005/04/21	Clear Global variable before processing next infile
			setnull(gsemail) 
		
		Next /*Process Next File within current path*/
		
	Next /*Process next path within project*/

Next /*Process next Project*/

Destroy ldw_datesort;
// GXMOR - 6/23 - Destroy Comcast object 
Destroy lu_Comcast;

Return liRC
end function

public function integer uf_process_purchase_order (string asproject);// 11/02 - PCONKL - Chg Qty fields to Decimal
				
Long		llHeaderPos,	& 
			llHeaderCount,	&
			llDetailCount,	&
			llDetailPos,	&
			llRmasterCount,	&
			llRDetailCount,	&
			llRowPos,			&
			llPos,					&
			llCount,				&
			llLineItem,			&
			llOwner,				&
			llNewRow,			&
			llBatchSeq,			&
			llOrderSeq,			&
			llNewCount,			&
			llUpdateCount,		&
			llDeleteCount,		&
			llRMFind

String	lsProject, lsOrderNo, lsSuppOrderNo, lsRoNo,	lstemp, lsSku,	lsSupplier,	lsHeaderErrorText,	&
			lsDetailErrorText, lsLogOut, lsAllowPOErrors, lsDefCOO, lsUOM, lsArrivalDate, lsSuppHeader, lsSuppLine, lsMultiSup
String lsErrText
String lsWH_Code  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
DateTime ldtWhTime // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
Boolean	lbError,	lbValError, lbDetailErrors, lbMultiSup, lbLPN, lbNSLpn		// GailM - 684 - NonSerialized LPN that is PONo2 and containerTracked
String ls_allow_dup_ro_numbers_ind
String	 ls_supp_code, lsStatus_cd
String lsDisplayOrderNo, lsSerialNo
String ls_replace_ro_no, lsAction_cd
String lsSerialized, lsPONo2Controlled, lsContainerTracked						// GailM - 684 - NonSerialized LPN that is PONo2 and containerTracked

String lsUserField15			// LTK 20131015  Added for STBTH
boolean lb_delete_records   // LTK 20131015  Added for STBTH

Decimal{5}	ldRONO, ldQty, ldAllocQty, tReqQty, ldPOQty
Integer	liRC

Long ll_last_line_item_no
String	lsMultiSupplier /* 05/14 - PCONKL */
String lsSkipProcess
String lsInactivesku //06-Oct-2015 :Madhu- Added to don't receive Inactive Sku's.

Boolean lb_process_detail_updates = TRUE // LTK 20151207;  LTK defaulted to TRUE on 20160301
Long ll_old_edi_batch_seq_no, ll_old_edi_batch_seq_no_non_back_order		// LTK 20160302
Boolean lb_receipts_processed_against_this_order, lb_pnd_error	// LTK 20160303
Long ll_rows, ll_detail_owner_id, ll_row	// LTK 20160303
String ls_sku, ls_uli_no, ls_former_owner_id, ls_former_shipment_distribution_no, ls_former_po_no, ls_order_line_no	// LTK 20160303
String ls_detail_owner_id, ls_previous_detail_owner_id, lsOwnerCD

Datastore lds_om_receipt_list //27-JUNE-2017 :Madhu Added for PINT- 856

lsLogOut = '          - PROCESSING FUNCTION - Create/Update Inbound Purchase Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

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

//27-JUNE-2017 :Madhu -Added for PINT -856 -START
//Store all Receipt Orders + Status Cd value
If not isValid(lds_om_receipt_list) Then
	lds_om_receipt_list =create Datastore
	lds_om_receipt_list.dataobject ='d_om_update_receipt_order_list'
End If
//27-JUNE-2017 :Madhu -Added for PINT -856 -END

idsPoHeader.Reset()
idsPODetail.Reset()
idsReceivemaster.Reset()
idsReceiveDetail.reset()

//TimA 12/02/14 add this lookup table because everything is OK in QA but not in production yet.
//Once ICC is done and this is ready for production the lookup table and If condition below can be deleted.
//This can be deleted once the new Shipment_Distribution_No is being used in production.
select User_Updateable_Ind
into :lsSkipProcess
from lookup_table
where project_id = 'PANDORA'
and code_type = 'SKIP_PROCESS'
and code_ID = 'Shipment_Distribution_No';

//03/03 - PCONKL - for some projects, we will allow a PO to still be created if 1 or more detail lines have errors
//						 Otherwise, we will delete the entire PO  if there are errors.
lsallowPOErrors = ProfileString(gsinifile,asProject,"allowpoerrors","")
If isNull(lsAllowPOErrors) or lsAllowPOErrors = '' or lsAllowPOErrors <> 'Y' Then lsAllowPOErrors = 'N'

//Retrieve the EDI Header and Detail based on the batch seq no
//GailM 08/09/2017 SIMSPEVS-783 Baseline - Allow multiple Inbound Sweeper for single customer migration from PDX->HiP - added project id
llHeaderCount = idsPOHeader.Retrieve( asProject ) /* all records with a new status will be retrieved*/

lsLogOut = '              ' + string(llHeaderCount) + ' Inbound PO Headers were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//If llHeaderCount <=0 Then Return 0
If llHeaderCount =0 Then
	Return 0
ElseIf llHeaderCount < 0 Then /* 11/03 - PCONKL */
	uf_send_email("",'Filexfer'," - ***** Uf_Process_Purchase_Order - Unable to read EDI Records!","Unable to read Inbound EDI Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//Process Each EDI Header Record
For llHeaderPos = 1 to llHeaderCount
	//TimA 12/22/11
	yield()

	// LTK 20131014  Method added for STBTH and allows other datawindow objects to be used for idsDeliveryMaster
//	uf_process_purchase_order_setup(idsPoHeader.GetItemString(llHeaderPos,'project_id'))
	uf_process_purchase_order_setup(idsPoHeader.GetItemString(llHeaderPos,'project_id'), idsPoHeader.GetItemString(llHeaderPos,'FTP_File_Name'))

//	// LTK 20111027	Pandora #305 - Create an SOC, as opposed to, and inbound order if the appropriate conditions are met.
//	if Upper(idsPOheader.GetItemString(llHeaderPos,'project_id')) = 'PANDORA' then
//		// The following method first checks, and then creates the SOC if the stars are aligned.  
//		// A zero is returned if conditions are *not* met and the PO will be processed below.
//		if uf_create_soc_from_po(idsPOheader, llHeaderPos) <> 0 then
//			Continue /*next header */
//		end if
//	end if

	//Retrieve any existing Receive Master records for this EDI header - we may have multiple Receive records for the same Order Number (partial receipts)
	//When updating a header or detail, we should only be upating the open one (status not complete) - they will be sorted so that the most recent is the last row in the DW
	
	lsProject = idsPOHeader.GetItemString(llHeaderPos,'project_id')
	//TimA 04/02/15 Because Pandora is using the user line item number as a non unique number we need to some up the quanitities.
	//This datawindow does that.  It is non updated able though but it is not needed unless there is an error and that is handled below.
	If lsProject = 'PANDORA' then
		idsPODetail.dataobject= 'd_po_detail_pandora'
		idsPODetail.SetTransObject(SQLCA)			
	End if
	lsOrderNo = idsPOHeader.GetItemString(llHeaderPos,'order_no')
	lsSuppOrderNo = idsPOHeader.GetItemString(llHeaderPos,'supp_order_no')
	lsSuppHeader = idsPOHeader.GetItemString(llheaderPos,'supp_code')
	llBatchSeq = idsPOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
	llOrderSeq = idsPOHeader.GetItemNumber(llHeaderPos,'order_seq_no')
	lsWH_Code = idsPOHeader.GetITemString(llHeaderPos,'wh_code')  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
	ldtWhTime = f_getLocalWorldTime(lsWh_Code) // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
	lsUserField15 = idsPOHeader.GetItemString(llHeaderPos,'user_field15')

	ls_supp_code = idsPOHeader.GetItemString(llHeaderPos,'supp_code')
		
	//cawikholm - 07/12/11 Get allow_dup_ro_numbers_ind from project table
	//06-FEB-2019 :Madhu S28685 Added PHILIPSCLS
	IF UPPER(lsProject) = 'PHILIPS-SG' OR UPPER(lsProject) = 'PHILIPSCLS' OR UPPER(lsProject) = 'PHILIPS-TH' THEN
		
		// Get allow_dup_ro_numbers_ind from project table
		// Check if existing records exists for supplier with an order status of not Void. If true then do not allow duplicate
		SELECT allow_dup_ro_numbers_ind
		   INTO :ls_allow_dup_ro_numbers_ind
		  FROM Project		
		 WHERE Project_Id = :lsProject
			AND NOT EXISTS ( SELECT 1
									  FROM Receive_Master	
									 WHERE Project_ID = :lsProject
										AND Supp_Invoice_No = :lsOrderNo
										AND Supp_Code = :ls_supp_code
										AND Ord_Status <> 'V' )
		 USING SQLCA;
		 
		 IF IsNull( ls_allow_dup_ro_numbers_ind ) = TRUE OR ls_allow_dup_ro_numbers_ind = '' THEN
			
			ls_allow_dup_ro_numbers_ind = 'N'
			
		END IF
			
	END IF
	
	// Added check for Philips and allow dup ro numbers ind - This may need to be changed to baseline 07/12/11 cawikholm
	//06-FEB-2019 :Madhu S28685 Added PHILIPSCLS
	if lsProject = "FLEX-SIN" OR (UPPER(lsProject) = 'PHILIPS-SG' AND ls_allow_dup_ro_numbers_ind = 'Y') OR (UPPER(lsProject) = 'PHILIPSCLS' AND ls_allow_dup_ro_numbers_ind = 'Y') OR (UPPER(lsProject) = 'PHILIPS-TH' AND ls_allow_dup_ro_numbers_ind = 'Y') then    /* MEA - 201009 - Do no need to check previous orders.  */
		llRmasterCount = 0
	else
		//llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsOrderNo)
		
		// LTK 20131014  Retrieve based on the standard or non standard datawindow.  Non standard introduced for STBTH
		if ib_non_standard_ro_dwo then
			llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsUserField15)
		else
			llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsOrderNo)
		end if
	

	end if
//?- For COTY, need to retrieve based on Order/Shipment	
	lsHeaderErrorText = ''

	//SEPT-2019 :MikeA S36895 F17741 - I2544 - PHILIPS-TH allow duplicate INBOUND order numbers in SIMS Sweeper - START
	IF llRmasterCount > 0 THEN
		llRMFind = idsReceiveMaster.find( "wh_code ='"+lsWH_Code+"'", 0, idsReceiveMaster.rowcount( ))
		IF llRMFind = 0 THEN llRmasterCount =0
		IF llRMFind >0 and upper(lsProject) ='PHILIPS-TH' and ls_allow_dup_ro_numbers_ind='Y' THEN ls_allow_dup_ro_numbers_ind ='N'
	END IF
	//SEPT-2019 :MikeA S36895 F17741 - I2544 - PHILIPS-TH allow duplicate INBOUND order numbers in SIMS Sweeper - END

	// LTK 20160303  If any receipts against this order, set flag here
	if lsProject = 'PANDORA' then
		SELECT COUNT(*)
		INTO :ll_rows
		FROM receive_master rm
		INNER JOIN receive_putaway rp ON rm.ro_no = rp.ro_no
		WHERE rm.project_id = 'PANDORA'
		AND supp_invoice_no = :lsOrderNo ;

		if ll_rows > 0 then
			lb_receipts_processed_against_this_order = TRUE
		end if
	end if

	// LTK 20131009	For Starbuck orders, if action code = 'R' for REPLACE then select and capture the ro_no, delete existing
	//						receive records and set action code to 'A' so that the order is processed as an Add.
	if lsProject = 'STBTH' and idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'R' and llRMasterCount > 0 then	

		// LTK 20131015  STBTH changes
		if ib_non_standard_ro_dwo  then

			select ro_no 
			into :ls_replace_ro_no
			from receive_master
			where project_id = :lsProject
			and user_field15 = :lsUserField15
			and ord_status = 'N';
	
			if sqlca.sqlcode <> 0 then
				uf_writeError("User_Field15 (Header): " + lsUserField15 + " Unable to retrieve a do_no in NEW status.") 
				lbError = True
				lsHeaderErrorText += "User_Field15 (Header): " + lsUserField15 + " Unable to retrieve a ro_no in NEW status."
				
			elseif sqlca.sqlcode = 0 then			
				lb_delete_records = true
			end if
		else
			
			select ro_no 
			into :ls_replace_ro_no
			from receive_master
			where project_id = :lsProject
			and supp_invoice_no = :lsOrderNo
			and ord_status = 'N';
	
			if sqlca.sqlcode <> 0 then
				uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Unable to retrieve a ro_no in NEW status.") 
				lbError = True
				lsHeaderErrorText += "Order Nbr (Header): " + string(lsOrderNo) + " Unable to retrieve a ro_no in NEW status."
				
			elseif sqlca.sqlcode = 0 then			
				lb_delete_records = true
			end if
			
		end if

		if lb_delete_records then
			
			// Should only be records in Receive_Master and Receive_Detail but will attempt to delete all receive tables
			Delete from Receive_Notes where ro_no = :ls_replace_ro_no;
			Delete from Receive_Packaging where ro_no = :ls_replace_ro_no;
			Delete from Receive_Putaway where ro_no = :ls_replace_ro_no;
			Delete from Receive_Alt_Address where ro_no = :ls_replace_ro_no;
			Delete from Receive_Detail where ro_no = :ls_replace_ro_no;
			Delete from DWG_Deleted_Entries where key_field = :ls_replace_ro_no;
			Delete From Receive_master where ro_no = :ls_replace_ro_no;
			Commit;
	
			// Now treat the order as an Add
			idsPOHeader.SetItem(llHeaderPos,'action_cd','A')
	
			//llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsOrderNo)
			
			if ib_non_standard_ro_dwo then
				llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsUserField15)
			else
				llRmasterCount = idsReceiveMaster.Retrieve(lsProject, lsOrderNo)
			end if
		end if
		lb_delete_records = false
	end if

	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
	
	//Validate action cd
	If idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'A' /* add a new PO */ Then

		///SEPT-2019 :MikeA S36895 F17741 - I2544 - PHILIPS-TH allow duplicate INBOUND order numbers in SIMS Sweeper - START
		IF llRmasterCount > 0 THEN
			llRMFind = idsReceiveMaster.find( "wh_code ='"+lsWH_Code+"'", 0, idsReceiveMaster.rowcount( ))
			IF llRMFind = 0 THEN llRmasterCount =0
			IF llRMFind >0 and upper(lsProject) ='PHILIPS-TH' and ls_allow_dup_ro_numbers_ind='Y' THEN ls_allow_dup_ro_numbers_ind ='N'
		END IF
		///SEPT-2019 :MikeA S36895 F17741 - I2544 - PHILIPS-TH allow duplicate INBOUND order numbers in SIMS Sweeper - END
		
		
		If llRMasterCount > 0 Then /* record already exists, can't add*/
			uf_writeError("Order Nbr (PO Header) " + string(lsOrderNo) + " - Order Already Exists and action code is 'Add'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order Already Exists and action code is 'Add'"
		Elseif llrMasterCount = 0 Then /*insert a new row for the new record*/
			llNewRow=idsReceiveMaster.InsertRow(0)
			
			// LTK 20131008  added logic to determine if the REPLACE ro_no was set, use it, else run original logic to create the ro_no
			if Len(ls_replace_ro_no) > 0 then
				lsRoNO = ls_replace_ro_no
				ls_replace_ro_no = ""
			else
				sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
				lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
			end if			
			
			idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
			idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
			idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
			idsReceiveMaster.SetItem(llNewRow,'last_update',ldtWHTime)  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
			idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
			idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')			
			idsReceiveMaster.SetItem(llNewRow,'ord_status','N')
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Receive Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Receive Order Record"
		End If
		
	ElseIf idsPOHeader.GetITemString(llHeaderPos,'action_cd') = 'U' Then /*update*/
		
		If llRMAsterCount <=0 Then
			uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Order does not exist and action code is 'Update'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order does not exist and action code is 'Update'"
		End If
		/* dts (6/16/04) For K&N (and All?) Update when no order exists...
		This is Failing the condition because lbError is true, causing Sweeper 
		to crash below when it does a GetItemString for row 0 (since idsReceiveMaster.RecordCount=0)
		Commented out the lbError part of condition - still not inserting Order, but not crashing either.
		*/

		//If we dont have an open PO, create a new one!
		//12/05 - PCONKL - If order is in process status, we will create a new one...
//		If idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) = 0 and &
//			idsReceiveMaster.Find("Ord_status = 'P'",1,idsReceiveMaster.RowCount()) = 0 then //and (not lbError) Then
		If idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) = 0 Then
				llNewRow=idsReceiveMaster.InsertRow(0)
				sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
				lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
				idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
				idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
				idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
				idsReceiveMaster.SetItem(llNewRow,'last_update',ldtWHTime)  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
				idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
				idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')				
				idsReceiveMaster.SetItem(llNewRow,'ord_date',ldtWHTime)   // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
			
				idsReceiveMaster.SetItem(llNewRow,'ord_status','N')

		End If
		
	ElseIf idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'D' Then /*If Status is New, Delete*/
		
		If llRmasterCount > 0 Then /*delete all putaway, detail and master records - If status is new*/
		
		// LTK 20110901	Pandora #254  Added the Pandora logic below.  Pandora wants to delete orders in new status even 
		//						if they are back orders.
		//											
		//	If idsReceiveMaster.Find("Ord_status = 'C'",1,idsReceiveMaster.RowCount()) > 0 or &
		//		idsReceiveMaster.Find("Ord_status = 'P'",1,idsReceiveMaster.RowCount()) > 0 or &
		//		idsReceiveMaster.Find("Ord_status = 'V'",1,idsReceiveMaster.RowCount()) > 0 Then

			If (idsReceiveMaster.Find("Ord_status = 'C'",1,idsReceiveMaster.RowCount()) > 0 or &
				idsReceiveMaster.Find("Ord_status = 'P'",1,idsReceiveMaster.RowCount()) > 0 or &
				idsReceiveMaster.Find("Ord_status = 'V'",1,idsReceiveMaster.RowCount()) > 0) and &
				UPPER(lsProject) <> 'PANDORA' Then
					
					uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Order is not in a new status and action Code is 'Delete'")
					lbError = True
					lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete'"

			ElseIf UPPER(lsProject) = 'PANDORA' and &
				idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) <= 0 then
				// If no orders are in New status, no action.
				// LTK 20110916  Pandora #300 Continue to next header so that order date and last udpate columns are not updated.
				continue
			Else /*delete*/
				
				For llRowPos = 1 to llRMasterCOunt
					// LTK 20110901  Pandora #254  Added Pandora branch.
					//lsRono = idsReceiveMaster.GetItemString(llRowPos,'RO_NO')
					if UPPER(lsProject) <> 'PANDORA' then
						lsRono = idsReceiveMaster.GetItemString(llRowPos,'RO_NO')
					else
						if Upper(Trim(idsReceiveMaster.GetItemString(llRowPos,'ord_status'))) = 'N' then
							lsRono = idsReceiveMaster.GetItemString(llRowPos,'RO_NO')
						else
							lsRono = ""
						end if
					end if
					
					if Len(lsRono) > 0 then
						if UPPER(lsProject) <> 'PANDORA' then								// LTK 20151214  Added the <> Pandora check
							Delete from Receive_Putaway where ro_no = :lsRono;
							Delete from Receive_detail where ro_no = :lsRoNo;
							Delete From Receive_master where ro_no = :lsRono;
							commit;
						else
							// LTK 20151214  Only set status to 'V' for these Pandora orders
							UPDATE Receive_Master
							SET Ord_Status = 'V'
							WHERE ro_no = :lsRono;
						end if
					end if					
				Next
							
				llDeleteCount ++ /*update number of orders deleted*/
				Continue /*next header*/
				
			End If
			
		Else /*delete and no records exist - ignore*/
			Continue /*Next header*/
		End If
		
	ElseIf idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'B' Then /*If Status is New, Delete Backorder*/
		
		If llRmasterCount > 0 Then /*delete all putaway, detail and master records - If status is new*/
		
			If idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) <= 0 Then
					
					uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Order is not in a new status and action Code is 'Delete Backorder'")
					lbError = True
					lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete Backorder'"
										
			Else /*delete*/
				
				For llRowPos = 1 to llRMasterCOunt

					If idsReceiveMaster.GetItemString(llRowPos,'Ord_status') = 'N' Then 
						lsRono = idsReceiveMaster.GetItemString(llRowPos,'RO_NO')
						Delete from Receive_Putaway where ro_no = :lsRono;
						Delete from Receive_detail where ro_no = :lsRoNo;
						Delete From Receive_master where ro_no = :lsRono;
						Commit;
					End If
				Next
							
				llDeleteCount ++ /*update number of orders deleted*/
				Continue /*next header*/
				
			End If
			
		Else /*delete and no records exist - ignore*/
			Continue /*Next header*/
		End If
		
	ElseIf idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'X' Then /* 10/02 - PCONKL - No status in file either add or update, create if it doesn't exist, update if it does*/
		
		If llRMasterCount > 0 Then /* record already exists, can't add*/
			
			//If we dont have an open PO, create a new one!
			//12/05 - PCONKL - If order is in process status, we will create a new one...
			//If idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) = 0 and &
			//	idsReceiveMaster.Find("Ord_status = 'P'",1,idsReceiveMaster.RowCount()) = 0 and (not lbError) Then
			If idsReceiveMaster.Find("Ord_status = 'N'",1,idsReceiveMaster.RowCount()) = 0 Then
			
				llNewRow=idsReceiveMaster.InsertRow(0)
				sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
				lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
				idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
				idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
				idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
				idsReceiveMaster.SetItem(llNewRow,'last_update',ldtWHTime)  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
				idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
				idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')				

				idsReceiveMaster.SetItem(llNewRow,'ord_date',ldtWHTime)   // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT

				idsReceiveMaster.SetItem(llNewRow,'ord_status','N')

			End If
			
		Elseif llrMasterCount = 0 Then /*insert a new row for the new record*/
			
			llNewRow=idsReceiveMaster.InsertRow(0)
			sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
			lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
			idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
			idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
			idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
			idsReceiveMaster.SetItem(llNewRow,'last_update',ldtWHTime)  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
			idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
			idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')


			idsReceiveMaster.SetItem(llNewRow,'ord_date',ldtWHTime)   // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
			
			idsReceiveMaster.SetItem(llNewRow,'ord_status','N')
			
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Receive Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Receive Order Record"
		End If
		
	ElseIf idsPOHeader.GetItemString(llHeaderPos,'action_cd') = 'Z' Then /* 10/06 - PCONKL - Add a new order regardless of existing or not - This should only be set in */
																								/*			   project specific NVO if you know that a duplicate is not present based on custom logic for what determines a duplicate*/
																								
		llNewRow=idsReceiveMaster.InsertRow(0)
		sqlca.sp_next_avail_seq_no(lsproject,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
		lsRoNO = lsProject + String(Long(ldRoNo),"000000") 
		idsReceiveMaster.SetItem(llNewRow,'ro_no',lsRoNo)
		idsReceiveMaster.SetItem(llNewRow,'project_id',lsProject)
		idsReceiveMaster.SetItem(llNewRow,'supp_invoice_no',lsOrderNo)
		idsReceiveMaster.SetItem(llNewRow,'last_update',ldtWHTime)  // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
		idsReceiveMaster.SetItem(llNewRow,'last_user','SIMSFP')
		idsReceiveMaster.SetItem(llNewRow,'create_user','SIMSFP')
		idsReceiveMaster.SetItem(llNewRow,'ord_status','N')
		
	Else /*invalid Action Type*/
		
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsPOHeader.GetITemString(llHeaderPos,'action_cd')) 
		lbError = True
		lsHeaderErrorText += ', ' + "Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsPOHeader.GetITemString(llHeaderPos,'action_cd')
				
	End If /*Action Type*/
		
	// 10/06 - PCONKL - If invalid action type or no orders retrieved, we need to get out at this point and continue with next header
	If	idsReceiveMaster.RowCount() = 0 or lbError Then
		
		idsPOHeader.SetITem(llHeaderPos,'status_cd','E')
		If Left(lsheaderErrorText,1) = ',' Then lsHeaderErrorText = Right(lsheaderErrorText,(len(lsHeaderErrorText) - 1)) /*strip first comma*/
		idsPOHeader.SetITem(llHeaderPos,'status_message',lsHeaderErrorText)
		idsPOHeader.Update()
			
		Update edi_inbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header.'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
		Commit;
		
		//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -START
		If idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			this.uf_process_om_writeerror( asproject, 'E', idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'), 'IB', lsHeaderErrorText) //write error log and trigger email alert
		End If
		//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -END		
		
		Continue /*Next Header*/
		
	End If
	
//	// All updates will be applied to most recent order - If there wasn't an open order, one was created. It will be deleted if no details are added to the new order
//	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'Ord_Date')
//	If Not IsNull(lstemp) Then
//		idsReceiveMaster.SetItem(llNewRow,'ord_date', lstemp)
//	Else

	idsReceiveMaster.SetItem(llNewRow,'ord_date',ldtWHTime)   // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
	

//	idsReceiveMaster.SetItem(llNewRow,'ord_date', today())
//	End If

	//Validate Warehouse
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'wh_code')
	
	If isNull(lsTemp) Then lsTemp = ''
	Select Count(*) into :llCount
	From Warehouse
	Where wh_code = :lsTemp;
	
	If llCount <= 0 Then
		
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Warehouse: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Warehouse"
		
	Else /*update the the newest header record*/
		
		//04/05 - PCONKL - We won't change on an existing order
		//10/08 - PCONKL - We will allow as long as in New Status
		
		//If we have more than 1 row, we might have just added one above if the existing order is not in new status. In this case, we need to compare against the existing record when comparing warehouses
		
		If idsReceiveMaster.RowCount()  = 1 Then
			
			If idsReceiveMaster.getItemString(idsReceiveMaster.RowCount(),'wh_code') = lsTemp  or &
				idsReceiveMaster.getItemString(idsReceiveMaster.RowCount(),'wh_code') = ''  or & 
				Isnull(idsReceiveMaster.getItemString(idsReceiveMaster.RowCount(),'wh_code')) Then
			
					idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'wh_code',lsTemp)
				
			ElseIf  idsReceiveMaster.getItemString(idsReceiveMaster.RowCount(),'wh_code') <> lsTemp Then  /*warehouse Changed */
			
				If idsReceiveMaster.getItemString(idsReceiveMaster.RowCount(),'ord_status') = 'N' Then /* new, update */
			
					idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'wh_code',lsTemp)
				
				else
				
					uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Order not in new status, warehouse code can not be updated: " + lsTemp) 
					lbError = True
					lsHeaderErrorText += ', ' + "Order not in new status, warehouse code can not be updated"
				
				End If
				
			End If
			
		Else /*more than 1 receive master record */
			
			If  idsReceiveMaster.getItemString(1,'wh_code') <> lsTemp Then  /*warehouse Changed */
						
				uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Order not in new status, warehouse code can not be updated: " + lsTemp) 
				lbError = True
				lsHeaderErrorText += ', ' + "Order not in new status, warehouse code can not be updated"
				
			Else
				
				idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'wh_code',lsTemp)
							
			End If
			
		End If /*1 or more master records */
			
	End If
	
	//Validate Supplier
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'supp_code')
	If isNull(lsTemp) Then lsTemp = ''
	Select Count(*) into :llCount
	From Supplier
	Where project_id = :lsProject and supp_code = :lsTemp;
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Supplier: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Supplier"
	Else /*update the the newest header record*/
		
		// 10/03 - PCONKL - Make sure the supplier hasn't changed on update!!
		If idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code') = lsTemp  or &
			idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code') = ''  or & 
			Isnull(idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code')) Then
			
				idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'supp_code',lsTemp)
				
		Else //Error
			uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Supplier can not be changed on update: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Supplier can not be changed on Update"
		End If
		
		
	End If
	
	//Validate Inventory Type
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'inventory_type')
	If isNull(lsTemp) Then lsTemp = 'N' // 10/09 - now setting to 'N' instead of ''
	Select Count(*) into :llCount
	From inventory_type
	Where project_id = :lsProject and inv_type = :lsTemp;
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Inventory Type: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Inventory Type"
	Else /*update the the newest header record*/
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'inventory_type',lsTemp)
	End If
	
	//Validate Order Type
	// 05/14 - PCONKL - Should be by Project as well
	lsTemp = idsPOHeader.GetITemString(llHeaderPos,'order_type')
	If isNull(lsTemp) Then lsTemp = ''
	Select Count(*) into :llCount
	From Receive_order_type
	Where  Project_id = :lsProject and ord_type = :lsTemp;
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Order Type: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Order Type"
	Else /*update the the newest header record*/
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'ord_type',lsTemp)
	End If
	
	//Check if the order type allows multiple suppliers...
	//05/14 - PCONKL - This should really be going against the Indicator on the Receive_Order_TYpe table which allows for multiple suppliers per order. This is not Maquet specific. The field has been there forever
	
	lbMultiSup = False
	
	If lsTemp > '' Then
		
		Select multiple_Supplier_Ind into :lsMultiSupplier
		From Receive_order_type
		Where  Project_id = :lsProject and ord_type = :lsTemp;
		
		If upper(lsMultiSupplier) = 'Y' Then
			lbMultiSup = True
		End If
		
	End If
	
	// If any header errors were encountered, update the edi record with status code and error text
	If lbError then
		
			idsPOHeader.SetITem(llHeaderPos,'status_cd','E')
			If Left(lsheaderErrorText,1) = ',' Then lsHeaderErrorText = Right(lsheaderErrorText,(len(lsHeaderErrorText) - 1)) /*strip first comma*/
			idsPOHeader.SetITem(llHeaderPos,'status_message',lsHeaderErrorText)
			idsPOHeader.Update()
			
			Update edi_inbound_detail
			Set Status_cd = 'E', status_message = 'Errors exist on Header.'
			Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
			Commit;
			
			//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -START
			If idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
				this.uf_process_om_writeerror( asproject, 'E', idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'), 'IB', lsHeaderErrorText) //write error log and trigger email alert
			End If
			//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -END		
		
			Continue /*Next Header*/
			
	Else /* No errors */
		
		//Jxlim03/08/2011 update last_update and user fields on modifed record/s when the record is being update from sweeper.
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'last_update',ldtWHTime) //Last Update reflect Local Wh not GMT
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'last_user','SIMSFP')
		//Jxlim 03/008/2011 End of code
		
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
		
//		If idsPOHeader.GetITemString(llHeaderPos,'User_field2') > ' ' Then
//			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field2',idsPOHeader.GetITemString(llHeaderPos,'User_field2'))
//		End If
//		LTK 20160307  Added the Pandora code below
		If lsProject <> 'PANDORA' then
			If idsPOHeader.GetITemString(llHeaderPos,'User_field2') > ' ' Then
				idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field2',idsPOHeader.GetITemString(llHeaderPos,'User_field2'))
			End If
		else
			// Pandora, don't allow the value to change if receipts exist against the order	
			if idsPOHeader.GetITemString(llHeaderPos,'User_field2') > ' ' then			
				if lb_receipts_processed_against_this_order then
					if Len( Trim( idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'User_field2') )) > 0 and  &
						idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'User_field2') <>  &
						idsPOHeader.GetITemString(llHeaderPos,'User_field2') then
							// Don't change the value of sub-inv location
					else
						idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field2',idsPOHeader.GetITemString(llHeaderPos,'User_field2'))
					end if
				else
					idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'User_field2',idsPOHeader.GetITemString(llHeaderPos,'User_field2'))
				end if			
			end if			
		end if

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
		
		// dts - 2010/10/04 - CrossDock_IND
		If idsPOHeader.GetItemString(llHeaderPos, 'CrossDock_IND') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(), 'CrossDock_IND', idsPOHeader.GetItemString(llHeaderPos,'CrossDock_IND'))
		End If
		
		// gwm - 2015/05/19 - Add named fields from EDI header record
		If idsPOHeader.GetITemString(llHeaderPos,'Client_Cust_PO_NBR') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Client_Cust_PO_NBR',idsPOHeader.GetITemString(llHeaderPos,'Client_Cust_PO_NBR'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Client_Invoice_Nbr') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Client_Invoice_Nbr',idsPOHeader.GetITemString(llHeaderPos,'Client_Invoice_Nbr'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Container_Nbr') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Container_Nbr',idsPOHeader.GetITemString(llHeaderPos,'Container_Nbr'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Client_Order_Type') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Client_Order_Type',idsPOHeader.GetITemString(llHeaderPos,'Client_Order_Type'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Container_Type') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Container_Type',idsPOHeader.GetITemString(llHeaderPos,'Container_Type'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'From_Wh_Loc') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'From_Wh_Loc',idsPOHeader.GetITemString(llHeaderPos,'From_Wh_Loc'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Seal_Nbr') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Seal_Nbr',idsPOHeader.GetITemString(llHeaderPos,'Seal_Nbr'))
		End If
		
		If idsPOHeader.GetITemString(llHeaderPos,'Vendor_Invoice_Nbr') > ' ' Then
			idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'Vendor_Invoice_Nbr',idsPOHeader.GetITemString(llHeaderPos,'Vendor_Invoice_Nbr'))
		End If
		
		// 12/15 - PCONKL - TODO - Add any new Header named fields
		
		// End adding named fields

		ll_old_edi_batch_seq_no = idsReceiveMaster.GetItemNumber(idsReceiveMaster.RowCount(),'edi_batch_seq_no')	// LTK 20160302
		
		idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'edi_batch_seq_no',idsPOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no'))
		
		 //23-JUNE-2017 Madhu Added for PINT-856 -START
		 If idsPOHeader.getitemstring(llHeaderPos, 'OM_Confirmation_Type') > ' ' Then
			idsReceiveMaster.setitem(idsReceiveMaster.RowCount(),'OM_Confirmation_Type', idsPOHeader.getitemstring( llHeaderPos, 'OM_Confirmation_Type'))
		else
			idsReceiveMaster.setitem(idsReceiveMaster.RowCount(),'OM_Confirmation_Type', 'R') //R -> Rosettanet - Regular File Process
		End If
		
		If idsPOHeader.getitemstring(llHeaderPos, 'OM_Order_Type') > ' ' Then
			idsReceiveMaster.setitem(idsReceiveMaster.RowCount(),'OM_Order_Type', idsPOHeader.getitemstring( llHeaderPos, 'OM_Order_Type'))
		End If		 
		 
		If idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			idsReceiveMaster.setitem(idsReceiveMaster.RowCount(),'om_change_request_nbr', idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'))
		End If
	 	//23-JUNE-2017 Madhu Added for PINT-856 -END
	 
		//Update the Header Record
		SQLCA.DBParm = "disablebind =0"
		liRC = idsReceiveMaster.Update(True,False) /*we need rec status alter if we need to delete the order if errors*/
		SQLCA.DBParm = "disablebind =1"
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			uf_writeError("- ***System Error!  Unable to Save Receive Master Record to database!")
			lbError = True
			Continue /*Next Header*/
		End If
		
		//Update order insert/update count
		If idsPOHeader.GetITemString(llHeaderPos,'action_cd') = 'A' Then
			llNewCount ++
		Else
			llUpdateCOunt ++
		End if
		
	End If /* errors on header? */
	
	//Retrieve the EDI DEtail records for the current header (based on edi batch seq and order_no)
	idsPODetail.SetFilter("")
	idsPoDetail.Filter()
	
	llDEtailCount = idsPODetail.Retrieve(asProject,llBatchSeq,lsOrderNo)
	
	//10/06 - PCONKL - If Action = Z, we may have multiple orders with the same order number - make sure we only load the lines for the current header and not all for order
	//02/14 - GailM - We can also have multiple orders if lbNSLpn.  PONo2s are added to the order if they are not already there.
	//There should be no harm in filtering on OrderSeqNo for any order.....  Validate this statement...
	//If idsPOHeader.GetITemString(llHeaderPos,'action_cd') = 'Z' or lbNSLpn Then
		idsPODetail.SetFilter("Order_seq_No = " + String(llOrderSeq))
		idsPoDetail.Filter()
		llDEtailCount = idsPODetail.RowCount()
	//End If

	// 10/06 - PCONKL - If there aren't any Detail records for this header, we will want to delete the header below...
	If lLDetailCount = 0 Then
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " No valid Detail Records found for Header. " ) 
		lbError = True
	End If
	
	/* GXMOR 598 Sort PODetail to logically pass through the records.  Report to log if sort fails.  This does change the outcome. */
	liRC = idsPODetail.SetSort("line_item_no A, serial_no D")
	if liRC >= 0 Then
		idsPODetail.Sort()
	Else
		lsLogOut = '              ' + string(llDetailCount) + ' DR did not sort properly.'
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut) /*write to Screen*/
	End If
	
	
	//Once we have a detail error, we will still validate the detail rows but we wont save any new/changed detail rows to the DB
	// 01/03 - PCONKL - This is no longer true - we will save any detail rows that are valid
	// 03/03 - PCONKL - Now, this will be project dependant as denoted in the .ini file 
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False /*Error on Current detail if allowing errors or any if not */
	lbDetailErrors = False /*error on any detail Row for Order */
	
	//process each Detail Record
	For llDetailPos = 1 to llDetailCOunt

		w_main.SetMicroHelp("Processing PO Rose detail record: " + String(llDetailPos) + " of " + String(llDetailCount) + " records.")
		
		If lbError Then 
			lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
			lbDetailErrors = True
		End If
		
		//03/03 - PCONKL, Only reset for each detail if we are allowing partial PO's
		If lsAllowPOErrors = 'Y' Then	lbError = False 
	
		lsDetailErrorText = ''
		lsSku = idsPODetail.GetItemString(llDetailPos,'sku')		
		llLineItem = idsPODetail.GetItemNumber(llDetailPos,'line_item_no')

		lbLPN = false 		//Is this an LPN sku?
		lbNSLpn = false	//Is this a nonSerialized GPN but PONo2 and Container tracked
		if lsProject = 'PANDORA' then		//LPN Pandora only
			select serialized_ind, po_no2_controlled_ind, container_tracking_ind, count(*) 
			into :lsSerialized, :lsPONo2Controlled, :lsContainerTracked, :liRC
			from item_master
			where project_id  ='PANDORA'
			and sku = :lsSku
			group by serialized_ind, po_no2_controlled_ind, container_tracking_ind;
			
			If lsSerialized = 'B' and lsPONo2Controlled = 'Y' and  lsContainerTracked = 'Y' Then
				lbLPN = true
			Elseif lsPONo2Controlled = 'Y' and  lsContainerTracked = 'Y' Then
				lbNSLpn = true
			End if
			
			if liRC > 1  then
									// Multiple SKUs for Pandora?  Should we check and what to do?
			end if
		end if
				
		
		// LTK 20131010  Reset the (R)eplace to (A)dd for Starbucks
		if lsProject = 'STBTH' and idsPODetail.GetITemString(llDetailPos,'action_cd') = 'R' then
			idsPODetail.SetItem(llDetailPos,'action_cd', 'A')
		end if
		
		//Validate Action Code - Dont worry about adds or updates - we can't delete if anything has been received for the line item
		If  idsPODetail.GetITemString(llDetailPos,'action_cd') = 'A' or  idsPODetail.GetITemString(llDetailPos,'action_cd') = 'U' Then
			
		ElseIf idsPODetail.GetITemString(llDetailPos,'action_cd') = 'D' Then
			
			Select Sum(alloc_qty) into :llCount
			FRom Receive_Detail
			Where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo);

			// LTK 20110916	Pandora #254B - Commented out the block below and replaced it with the following block.
			
//			If llCount > 0 Then /*we've already received against this sku, can't delete the line item*/
//				uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Action Code is Delete but there are already receipts against this line item" ) 
//				lbError = True
//				lsDetailErrorText += ', ' + "Action Code is Delete but there are already receipts against this line item"
//				//Continue
//			Else /*delete the detail row*/
//				Delete from Receive_Putaway where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo);
//				Delete from Receive_Detail where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo);
//				Commit;
//				Continue /*Next Detail Record*/
//			End If 

			// LTK 20110916	Pandora #254B - Added Pandora logic below.  Pandora wants to be able to delete line items 
			//						even if the line item has had previous receipts against it (still only deleting orders in new status).

			If llCount > 0 and Upper(lsProject) <> 'PANDORA' Then /*we've already received against this sku, can't delete the line item*/
				uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Action Code is Delete but there are already receipts against this line item" ) 
				lbError = True
				lsDetailErrorText += ', ' + "Action Code is Delete but there are already receipts against this line item"
				//Continue
			Else /*delete the detail row*/
				if Upper(lsProject) <> 'PANDORA' then
					Delete from Receive_Putaway where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo);
					Delete from Receive_Detail where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo);
					Commit;
				else
					// Pandora logic, only select ro_no's in new status so previously completed records are not deleted.
					Delete from Receive_Putaway where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo and ord_status = 'N');
					Delete from Receive_Detail where sku = :lsSku and line_item_no = :llLineItem and ro_no in (select ro_no from Receive_master where project_id = :lsProject and supp_invoice_no = :lsOrderNo and ord_status = 'N');
					Commit;
				end if

				Continue /*Next Detail Record*/
			End If 

			
		Else /*Invalid Action Type*/
			uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Action Type: '" + idsPODetail.GetITemString(llDetailPos,'action_cd') + "'") 
			lbError = True
		End If /*delete*/
		
		//Validate Inventory Type
		lsTemp = idsPODetail.GetITemString(llDetailPos,'inventory_type')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From inventory_type
		Where project_id = :lsProject and inv_type = :lsTemp;
		
		If llCount <=0 Then
			uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Inventory Type: " + lsTemp) 
			lsDetailErrorText += ', ' + "Invalid Inventory Type"
			lbError = True
		End If
		
		//Validate SKU - 10/03 - PCONKL - must validate against header supplier - all SKUS for order must have same supplier
		/* dts - 09/15/08 - Maquet needs supplier at the detail level (since single PO my contain multiple 'Suppliers' (actually SKU prefix))
		 - If the order type allows multiple suppliers...
		   and the supplier is present on the detail record, use the detail's supplier. */
		lsSupplier = lsSuppHeader  //use the Header-level Supplier unless otherwise indicated (immediately below)...
		if lbMultiSup = true then
		  //Validate Line-level Supplier (if present)
			lsTemp = idsPODetail.GetItemString(llDetailPos, 'supp_code')
			If isNull(lsTemp) Then lsTemp = ''
			if lsTemp <> '' then
				lsSuppLine = lsTemp
				Select Count(*) into :llCount
				From Supplier
				Where project_id = :lsProject and supp_code = :lsSuppLine;
				
				If llCount <= 0 Then
					uf_writeError("Order Nbr: " + string(lsOrderNo) + ", Line: " + string(llLineItem) +" Invalid Supplier: " + lsTemp) 
					lbError = True
					lsDetailErrorText += ', ' + "Invalid Supplier"
				Else /*update the the newest header record*/ 
					/*do we need to do this here (for the line-level supplier)???
					// 10/03 - PCONKL - Make sure the supplier hasn't changed on update!!
					If idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code') = lsTemp  or &
						idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code') = ''  or & 
						Isnull(idsReceiveMaster.getITemString(idsReceiveMaster.RowCount(),'supp_code')) Then
						idsReceiveMaster.SetItem(idsReceiveMaster.RowCount(),'supp_code',lsTemp)
					Else //Error
						uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Supplier can not be changed on update: " + lsTemp) 
						lbError = True
						lsHeaderErrorText += ', ' + "Supplier can not be changed on Update"
					End If
					*/
					lsSupplier = lsSuppLine
				End If
			end if //non-null detail supplier
		end if //order type allows multiple suppliers
//TEMPO!!! use line-level supplier for sku/supl validation (when appropriate)
/*NOTES:
 - if supplier changes for same line, update the line (unless it's already received).
 - what about 3COM? will there be new validation for them that they're not expecting? when is supp_code updated in edi_inbound_detail?
 
 - On 945, see PHX for CTN Number changes from Mike
 
  */
		lsTemp = idsPODetail.GetITemString(llDetailPos,'sku')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Item_Master
		Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;
		
		If llCount <=0 Then
			uf_writeError("Order Nbr/Line (PO detail): " + string(lsDisplayOrderNo) + '/' + string(llDetailPos) + " Invalid SKU, or SKU not valid for this Supplier: " + lsTemp + " / " + lsSupplier) 
			lsDetailErrorText += ', ' + "Invalid SKU or SKU not valid for this Supplier"
			lbError = True
		End If
		
		//06-Oct-2015 :Madhu - Don't receive Inactive sku -START
		Select Item_Delete_Ind into :lsInactivesku From Item_Master with(nolock)
		Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;

		If lsInactivesku ='Y' Then
			uf_writeError("Order Nbr/Line (PO detail): " + string(lsDisplayOrderNo) + '/' + string(llDetailPos) + " Inactive SKU, Can't receive an Inactive Sku: " + lsTemp) 
			lsDetailErrorText += ', ' + "Inactive SKU, Can't receive an Inactive Sku"
			lbError = True
		End If
		//06-Oct-2015 :Madhu - Don't receive Inactive sku -END
			
		//Quantity must be Numeric
		If not isNumber(idsPODetail.GetITemString(llDetailPos,'Quantity')) Then
			uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Quantity is not numeric: " ) 
			lsDetailErrorText += ', ' + "Quantity is not numeric"
			lbError = True
		End If
		
		//Validate COO if present
		//03/02 - Pconkl - validate against either 2 char or 3 char code
		lsTemp = idsPODetail.GetITemString(llDetailPos,'country_of_origin') 
		If isNull(lsTemp) Then lsTemp = ''
		If Trim(lsTEmp) > '' Then
			If f_get_country_Name(lsTemp) > '' Then
			Else
				uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Country of Origin: " + lsTemp) 
				lsDetailErrorText += ', ' + "Invalid Country of Origin"
				lbError = True
			End If
			
		End If
		
		//If no errors, apply the updates
		If Not lbError Then
			
			//Retrieve any existing Receive Details for this order number (may span multiple RO_NO's)
			//We want to update the newest line item for this PO - The line item may exist on multiple RO_NO's if the PO has been updated
			//or partially received. The DW is sorted by RO_NO so the last row should be the latest. That's the only one that needs updating.
			//We also need to determine if the qty has changed. The only way to do that is to count what we already have ordered.

			// LTK 20120606  Pandora #353 Retrieve Pandora Receive_Details rows by user_line_item_no
			//	llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem)

			if Upper(Trim(lsProject)) = 'PANDORA' then
					String ls_user_line_item_no, ls_Shipment_Distribution_No
//
//				If lsSkipProcess = 'N' then // "N" No do not skip the new Distibution line process
//					//TimA Pandora issue #904 use the line item number now because user line item number will be the same number for several records.
//					//idsReceiveDetail.dataobject= 'd_receive_detail_by_uli'
//					idsReceiveDetail.dataobject= 'd_receive_detail'
//					idsReceiveDetail.SetTransObject(SQLCA)			
//					idsReceiveDetail.Reset()
//	
//					Long ll_user_line_item_no
//					String lsShipMntDist
//					//ll_user_line_item_no = Long(idsPODetail.GetItemNumber(llDetailPos,'user_line_item_no'))
//					//ls_user_line_item_no = idsPODetail.GetItemString(llDetailPos,'user_line_item_no')
//					//TimA Pandora issue #904 use the line item number now because user line item number will be the same number for several records.
////					lsShipMntDist  =  
//					ls_user_line_item_no = String(idsPODetail.GetItemNumber(llDetailPos,'line_item_no') ) +  Nz(idsReceiveDetail.GetItemString(1,'shipment_distribution_no'),'')
//					ll_user_line_item_no = Long(ls_user_line_item_no)
//					
//					llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,ll_user_line_item_no,lsProject)
//					//llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,ls_user_line_item_no,lsProject)
//				Else
					//TimA 12/02/14
					//Only being used here because ICC is not ready yet.
					// "Y" Yes Skip. This is set in the lookup take to skip it and use the old process.
					idsReceiveDetail.dataobject= 'd_receive_detail_by_uli'
					idsReceiveDetail.SetTransObject(SQLCA)			
					idsReceiveDetail.Reset()
	
					//Long ll_user_line_item_no

					//ll_user_line_item_no = Long(idsPODetail.GetItemNumber(llDetailPos,'user_line_item_no'))
					ls_Shipment_Distribution_No = Nz(idsPODetail.GetItemString(llDetailPos,'shipment_distribution_no'),'')
					ls_user_line_item_no = idsPODetail.GetItemString(llDetailPos,'user_line_item_no')  
	
					//llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem)
					llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,ls_user_line_item_no,lsProject,ls_Shipment_Distribution_No)
//				End if
			else
				idsReceiveDetail.dataobject= 'd_receive_detail'
				idsReceiveDetail.SetTransObject(SQLCA)			
				idsReceiveDetail.Reset()

				llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem,lsProject)
				
				// Start MADE THE CJHANGES FOR TVP  PROJECT. NXJAIN -05/14/2013 
				if Upper(Trim(lsProject)) = 'TPV' then
					idsReceiveDetail.dataobject= 'd_receive_detail_tpv'
					idsReceiveDetail.SetTransObject(SQLCA)			
					idsReceiveDetail.Reset()
					llRDetailCount = idsReceiveDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem,lsProject)
				end if 
				
//				//MEA - 6/13 - Don't group.
//				
//				if Upper(Trim(lsProject)) = 'PHYSIO-XD' then
//					llRDetailCount = 0
//				end if
				
			//end 	 Nxjain .
			end if
			// End of Pandora #353

			If llRDetailCount > 0 Then /*details exist */
			
				//Get a count of the existing qty to determine whether it has changed
				//If it's not the last row, only include the Allocated - the rest have been copied forward. If it's the last row, only include the Req
				ldQty = 0
				ldAllocQty = 0
				For llRowPos = 1 to llRDetailCount
					If llRowPos = llRDetailCount Then
						ldQty += idsReceiveDetail.GetItemNumber(llRowPos,'req_qty') 
					Else
						ldQty += idsReceiveDetail.GetItemNumber(llRowPos,'alloc_qty')
					End If			
					ldAllocQty += idsReceiveDetail.GetItemNumber(llRowPos,'alloc_qty')
				Next
				
				//Get a count of PO qty to determine if count has increased or decreased for the line item number
				ldPOQty = 0
				For llRowPos = 1 to llDetailCount
					If idsReceiveDetail.GetItemNumber(1,'line_item_no') = llLineItem and idsReceiveDetail.GetItemString(1,'user_line_item_no') + Nz(idsReceiveDetail.GetItemString(1,'shipment_distribution_no'),'') =ls_user_line_item_no + ls_Shipment_Distribution_No then
						ldPOQty ++
					End If
				Next
				
				/* GXMOR 598 Determine total req qty for multiple serial number records for an line item number */
				tReqQty = 0
				for llPos = 1 to llDetailCount
					if idsPODetail.GetItemString(llPos,'user_line_item_no') + Nz(idsPODetail.GetItemString(llPos,'shipment_distribution_no'),'') = ls_user_line_item_no + ls_Shipment_Distribution_No Then
						tReqQty += Dec(idsPODetail.GetItemString(llPos,'quantity'))
					End If
				Next
				tReqQty = tReqQty - ldAllocQty  
					
				//If qty different than edi detail record, then we need to change the qty on the most recent open record
				//If the last record has been fully received, then we need to create a new PO (Receive header/detail) for the additional line item
				
				// 07/02 - Pconkl - If the action code for this record is Add, just add the qty to the current total. 
				//							If it is update, we need to reconcile with what has already been received previously

				If idsPODetail.GetITemString(llDetailPos,'action_cd') = 'A' Then /*add qty's regardless*/
					
					If idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no') = idsReceiveDetail.GetITemString(idsReceiveDetail.RowCount(),'ro_no') Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') + (Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')))))
					Else /*create a new detail*/
						liRC = idsReceiveDetail.RowsCopy(idsReceiveDetail.RowCount(),idsReceiveDetail.RowCount(),Primary!,idsReceiveDetail,(idsReceiveDetail.RowCount() + 1),Primary!) /* add a new row at the end*/
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'ro_no',idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no'))
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(Dec(idsPODetail.GetITemString(llDetailPos,'Quantity'))))
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'alloc_qty',0)
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'damage_qty',0)
					End If
						
				ElseIf idsPODetail.GetITemString(llDetailPos,'action_cd') = 'U' Then /*reconcile updated qty's */	
					/* GXMOR 598 For LPN detail received, determine total req qty.  Do not let req qty exceed total req qty for the line item */
					If lbLPN Then
						If idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') < tReqQty Then
							idsReceiveDetail.SetItem(idsReceiveDetail.Rowcount( ),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') + (Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')))))
							/* GXMOR 598 If we started with more than zero qty, the last entry would put us above the limit. Adjust to tReqQty */
							If idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') > tReqQty Then
								idsReceiveDetail.SetItem(idsReceiveDetail.Rowcount( ),'req_qty',tReqQty)
							End If
						ElseIf tReqQty <  idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') Then
							idsReceiveDetail.SetItem(idsReceiveDetail.Rowcount( ),'req_qty',tReqQty)	// ReqQty reduced
						End If
					ElseIf ldQty < Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')) Then /*Qty has been increased*/			
						//If there is a detail for the newest header, update it - otherwise create a new detail row for the latest header
						If DEC(idsPODetail.GetItemString(llDetailPos,'Quantity')) + ldQty = tReqQty Then
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',( DEC(idsPODetail.GetItemString(llDetailPos,'Quantity'))  + ldQty))
						ElseIf idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no') = idsReceiveDetail.GetITemString(idsReceiveDetail.RowCount(),'ro_no') Then
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') + (Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')) - ldQty)))
						Else /*create a new detail*/
							liRC = idsReceiveDetail.RowsCopy(idsReceiveDetail.RowCount(),idsReceiveDetail.RowCount(),Primary!,idsReceiveDetail,(idsReceiveDetail.RowCount() + 1),Primary!) /* add a new row at the end*/
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'ro_no',idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no'))
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')) - ldQty))
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'alloc_qty',0)
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'damage_qty',0)
						End If
					ElseIf ldQty > Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')) Then /*Qty has been decreased - decrement from the last row*/
						//We can't change the requested qty to be less than we've already received
						If DEC(idsPODetail.GetITemString(llDetailPos,'Quantity')) < ldAllocQty Then
							//uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " New Quantity is Less than the amount that has already been received. " ) 
							uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " New Quantity (" + idsPODetail.GetITemString(llDetailPos,'Quantity') +  ") is Less than the amount that has already been received (" + String(ldAllocQty,'#######.#####') + "). Qty will not be updated (Other updateable fields will still be modified)" ) 
							//lbError = True		// LTK 20151214  For Pandora, don't set this as an erroneous condition
							if Upper( lsProject ) <> 'PANDORA' then
								lbError = True
							end if

							// 01/03 - PCONKL - we still want to update other updatable fields on this record, jsut not the qty*/
							//Continue /*next detail*/
						ElseIf tReqQty > ldQty Then  //Testing    
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') + ( Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')))))
						Else
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') - (ldQty  - Dec(idsPODetail.GetITemString(llDetailPos,'Quantity')))))

							// LTK 20151207  Delete empty detail rows
							if lsProject = 'PANDORA' then
								if IsNull( idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') ) or idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') = 0 then
									idsReceiveDetail.DeleteRow( idsReceiveDetail.RowCount() )
									lb_process_detail_updates = FALSE
								end if
							end if
						End If
					ElseIf tReqQty > ldQty Then
							idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'req_qty',(idsReceiveDetail.GetItemNumber(idsReceiveDetail.RowCount(),'req_qty') + Dec(idsPODetail.GetITemString(llDetailPos,'Quantity'))))						
					End If /*qty changed*/

				End If /*Add/Update of Detail Record*/
				
				if lb_process_detail_updates then

					// LTK 20160303  Don't allow owner updates if there are any receipts against this order and don't allow po_no updates
					// if there are receipts against the specific line
					if lsProject = 'PANDORA' and ll_old_edi_batch_seq_no > 0 then

						// Get detail owner code (it is stored as owner id)
						ls_detail_owner_id = idsPODetail.GetITemString(llDetailPos,'Owner_ID')
						if ls_detail_owner_id <> ls_previous_detail_owner_id then
							ls_previous_detail_owner_id = ls_detail_owner_id
							ll_detail_owner_id = Long( ls_detail_owner_id )
							select owner_cd 
							into :lsOwnerCD
							from owner
							where project_id = :lsProject and 

							owner_id = :ll_detail_owner_id;

							if Len( String( nz( lsOwnerCD, "" ))) = 0 then
								// Error the file out when detail owner code cannot be retrieved
								uf_writeError("Order Nbr (PO Detail): " + string(lsOrderNo) + " - Owner code cannot be retrieved for owner ID: " + nz( ls_detail_owner_id, "") )
								lbError = True
								Continue /*next Detail*/
							end if
						end if
						
						// LTK 20160309  Check RM.UF2 contains the same value as the detail line owner, even if there are no receipts
						if Trim( idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'User_field2') ) <> Trim( lsOwnerCD )  then
							// Error the file out when the header owner RM.UF2 does not match the detail owner
							uf_writeError("Order Nbr (PO Detail): " + string(lsOrderNo) + " - Header owner (RM.UF2): " + Trim( idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'User_field2') ) + " does not match detail line owner: " + Trim( nz( lsOwnerCD, "") ) )
							lbError = True
							Continue /*next Detail*/
						end if

						ls_sku = idsPODetail.GetItemString(llDetailPos,'sku')
						ls_uli_no = idsPODetail.GetItemString(llDetailPos,'user_line_ITem_No')

						// Get the EDI Batch sequence number which isn't releated to the backorder (since no detail exists for back orders)
						select MAX( edi_batch_seq_no )
						into :ll_old_edi_batch_seq_no_non_back_order
						from EDI_Inbound_Header
						where Project_Id = :lsProject
						and EDI_Batch_Seq_No <= :ll_old_edi_batch_seq_no
						and Order_No = :lsOrderNo
						and Status_Message <> 'Backorder';

						if ll_old_edi_batch_seq_no_non_back_order > 0 then

							select Max(Owner_ID), Max(Po_No)
							into :ls_former_owner_id, :ls_former_po_no
							from EDI_Inbound_Detail
							where Project_Id = :lsProject
							and EDI_Batch_Seq_No = :ll_old_edi_batch_seq_no_non_back_order
							and SKU = :ls_sku
							and User_Line_Item_No = :ls_uli_no 
							using SQLCA;
	
							if sqlca.sqlcode = 0 then			
								// If receipts against this order exist, ensure that the owner sent for this line = the stored owner; 
								// Also check that the owner sent for this line = RM.UF2 (in case this is a new line to the order)
								if lb_receipts_processed_against_this_order then
									if Len( ls_former_owner_id ) > 0 then
										lb_pnd_error = ( Trim( ls_former_owner_id ) <> Trim( idsPODetail.GetITemString(llDetailPos,'Owner_ID') ) )
									end if
//									if NOT lb_pnd_error then
//										lb_pnd_error = ( Trim( idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'user_field2') ) <> Trim( lsOwnerCD ) )
//									end if
									if lb_pnd_error then
										// Error the file out, can't change owners if receipts against order
										uf_writeError("Order Nbr (PO Detail): " + string(lsOrderNo) + " - Owner cannot be changed once inventory has been received against this order.")
										lbError = True
										Continue /*next Detail*/
									end if
								end if
	
	
								if ldAllocQty > 0 and Trim( ls_former_po_no ) <> Trim( idsPODetail.GetItemString(llDetailPos,'Po_No') ) then
									lsLogOut = '              ' + 'Order: ' + lsOrderNo + '  User Line Item: ' + idsPODetail.GetItemString(llDetailPos,'user_line_ITem_No') + ' - Inventory already received against this line and project (po_no) does not match previous EDI record, skipping this detail line.'
									FileWrite(giLogFileNo,lsLogOut)
									
									// Set Po_No back to former value so that put-away generation will source the correct project.  The Pandora detail DW is not updateable so inline SQL here...
									update edi_inbound_detail
									set po_no = :ls_former_po_no
									where Project_Id = :lsProject
									and EDI_Batch_Seq_No = :llBatchSeq
									and SKU = :ls_sku
									and User_Line_Item_No = :ls_uli_no ;

									continue
								end if
							end if
						end if
					end if


					//update any other changed fields from edi detail to last receive detail
					If idsPODetail.GetItemString(llDetailPos,'user_field1') > ' ' Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field1',idsPODetail.GetItemString(llDetailPos,'user_field1'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_field2') > ' ' Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field2',idsPODetail.GetItemString(llDetailPos,'user_field2'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_field3') > ' ' Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field3',idsPODetail.GetItemString(llDetailPos,'user_field3'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_field4') > ' ' Then /* TAM 2007/08/02 */
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field4',idsPODetail.GetItemString(llDetailPos,'user_field4'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_field5') > ' ' Then /* TAM 2007/08/02 */
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field5',idsPODetail.GetItemString(llDetailPos,'user_field5'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_field6') > ' ' Then /* TAM 2007/08/02 */
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_field6',idsPODetail.GetItemString(llDetailPos,'user_field6'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'gls_so_ID') > ' ' Then /* 11/02 - PCONKL*/
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'gls_so_ID',idsPODetail.GetItemString(llDetailPos,'gls_so_ID'))
					End If
					
					If idsPODetail.GetItemNumber(llDetailPos,'gls_so_line') > 0 Then /* 11/02 - PCONKL*/
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'gls_so_line',idsPODetail.GetItemNumber(llDetailPos,'gls_so_line'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'user_line_ITem_No') > ' ' Then /* 11/02 - PCONKL*/
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'user_line_ITem_No',idsPODetail.GetItemString(llDetailPos,'user_line_ITem_No'))
					End If
					
					If idsPODetail.GetITemString(llDetailPos,'Owner_ID') > '' Then /*07/03 - PCONKL */
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'Owner_ID',Long(idsPODetail.GetITemString(llDetailPos,'Owner_ID')))
					End If
					
					If idsPODetail.GetItemString(llDetailPos,'exp_serial_No') > ' ' Then /* PCONKL - 08/07 - For 3COM RMA */
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'exp_serial_No',idsPODetail.GetItemString(llDetailPos,'exp_serial_No'))
					End If
					
					// 5/10/2010 - dts - Alternate SKU...
					If idsPODetail.GetItemString(llDetailPos, 'alternate_sku') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'alternate_sku', idsPODetail.GetItemString(llDetailPos, 'alternate_sku'))
					End If
					
					// 2015/05/19 - gwm - Add named fields from EDI detail
					If idsPODetail.GetItemString(llDetailPos, 'Currency_Code') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Currency_Code', idsPODetail.GetItemString(llDetailPos, 'Currency_Code'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Supplier_Order_Number') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Supplier_Order_Number', idsPODetail.GetItemString(llDetailPos, 'Supplier_Order_Number'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Cust_PO_Nbr') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Cust_PO_Nbr', idsPODetail.GetItemString(llDetailPos, 'Cust_PO_Nbr'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Line_Container_Nbr') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Line_Container_Nbr', idsPODetail.GetItemString(llDetailPos, 'Line_Container_Nbr'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Vendor_Line_Nbr') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Vendor_Line_Nbr', idsPODetail.GetItemString(llDetailPos, 'Vendor_Line_Nbr'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Client_Line_Nbr') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Client_Line_Nbr', idsPODetail.GetItemString(llDetailPos, 'Client_Line_Nbr'))
					End If
					
					If idsPODetail.GetItemString(llDetailPos, 'Client_Cust_PO_NBR') > ' ' Then 
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Client_Cust_PO_NBR', idsPODetail.GetItemString(llDetailPos, 'Client_Cust_PO_NBR'))
					End If
					
					// 12/15 - PCONKL - TODO - Add any new detail named fields
					If idsPODetail.GetItemString(llDetailPos,'SSCC_Nbr') >' ' Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'SSCC_Nbr',idsPODetail.GetItemString(llDetailPos,'SSCC_Nbr'))
					End If
					// End add named fields
					
					//23-JUNE-2017 :Madhu Added for PINT-856
					If idsPODetail.GetItemNumber(llDetailPos,'om_change_request_nbr') > 0 Then
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'om_change_request_nbr', idsPODetail.GetItemNumber(llDetailPos,'om_change_request_nbr'))
					End If
	
					// 9/10/2013 - gwm - Line Date...
					//TimA 09/03/14 No longer needed
					//If idsPODetail.GetItemString(llDetailPos, 'po_line_date') > ' ' Then 
					//	idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'po_line_date', idsPODetail.GetItemString(llDetailPos, 'po_line_date'))
					//End If
	
					//TimA 10/07/14 Pandora issue #889 Shipment_Distribution_No and Need_by_date...
					//If idsPODetail.GetItemString(llDetailPos,'Shipment_Distribution_No') > ' ' Then
					//TimA 03/23/15 In the staging tables the Distribution field is a blank space so the > '' did not work and was inserting a null value for Distr.
					//When we finely turn on Distribution field then we can search for a > ''
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'Shipment_Distribution_No',idsPODetail.GetItemString(llDetailPos,'Shipment_Distribution_No'))
					//End If
	
					//If string(idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'),'MM/DD/YYYY') <> "12/31/2999" and string(idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'),'MM/DD/YYYY') <> "01/01/1900" Then
					//TimA 03/23/14 In the staging tables the Need By Date field is a blank space so the > '' did not work and was inserting a null value for Need By
						idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'Need_By_Date',idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'))
					//End If
				else
					lb_process_detail_updates = TRUE
				end if

			ElseIf llRDetailCount = 0 Then /*no details exist, it's a new line item - create a new Receive DEtail Record*/
				
				idsReceiveDetail.InsertRow(0)
				idsReceiveDetail.SetITem(1,'ro_no',idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'ro_no'))
				idsReceiveDetail.SetItem(1,'sku',idsPODetail.GetItemString(llDetailPos,'sku'))
				
				idsReceiveDetail.SetItem(1,'supp_code',lsSupplier)
				
				// 03/04 - PCONKL - Load UOM From Item Master if not included on feed
				If isnull(idsPODetail.GetItemString(llDetailPos,'uom')) or idsPODetail.GetItemString(llDetailPos,'uom') = '' Then
					
					lsSKU = idsPODetail.GetItemString(llDetailPos,'sku')
					
					Select uom_1 into :lsUOM
					From Item_Master
					Where Project_ID = :lsProject and SKU = :lsSKU and Supp_Code = :lsSupplier;
					
					idsReceiveDetail.SetItem(1,'uom',lsUOM)
					
				Else
					idsReceiveDetail.SetItem(1,'uom',idsPODetail.GetItemString(llDetailPos,'uom'))
				End If
				
				idsReceiveDetail.SetITem(1,'req_qty', Dec(idsPODetail.GetItemString(llDetailPos,'quantity')))
				
				idsReceiveDetail.SetItem(1,'user_field1',idsPODetail.GetItemString(llDetailPos,'user_field1'))
				idsReceiveDetail.SetItem(1,'user_field2',idsPODetail.GetItemString(llDetailPos,'user_field2'))
				idsReceiveDetail.SetItem(1,'user_field3',idsPODetail.GetItemString(llDetailPos,'user_field3'))
				idsReceiveDetail.SetItem(1,'user_field4',idsPODetail.GetItemString(llDetailPos,'user_field4'))
				idsReceiveDetail.SetItem(1,'user_field5',idsPODetail.GetItemString(llDetailPos,'user_field5'))
				idsReceiveDetail.SetItem(1,'user_field6',idsPODetail.GetItemString(llDetailPos,'user_field6'))


				// LTK 20120606  Pandora #353 Find the max line item number and begin incrementing from there
				//
				//	idsReceiveDetail.SetItem(1,'line_item_no',idsPODetail.GetItemNumber(llDetailPos,'Line_item_no'))
				
				//17-Jan-2019 :Madhu DE8221 - Use EDI_Inbound_Detail.Line_Item_No as base Line - START
				//else Which is causing an Issue while Utility->Import->Inbound Orders.
//				if Upper(Trim(lsProject)) = 'PANDORA' then
//					if ll_last_line_item_no = 0 then
//						String ls_ro_no
//						ls_ro_no = idsReceiveMaster.GetItemString(idsReceiveMaster.RowCount(),'ro_no')
//						select Max(line_item_no)
//						into :ll_last_line_item_no
//						from receive_detail
//						where ro_no = :ls_ro_no;
//
//						if IsNull(ll_last_line_item_no) then
//							ll_last_line_item_no = 0
//						end if
//					end if	
//					ll_last_line_item_no++
//					idsReceiveDetail.SetItem(1,'line_item_no', ll_last_line_item_no)
//				else
//					idsReceiveDetail.SetItem(1,'line_item_no',idsPODetail.GetItemNumber(llDetailPos,'Line_item_no'))
//				end if
//				// End of Pandora #353
			
				idsReceiveDetail.SetItem(1,'line_item_no',idsPODetail.GetItemNumber(llDetailPos,'Line_item_no'))
				//17-Jan-2019 :Madhu DE8221 - Use EDI_Inbound_Detail.Line_Item_No - END
				
				idsReceiveDetail.SetITem(1,'alloc_qty',0)
				idsReceiveDetail.SetITem(1,'damage_qty',0)
				
				If idsPODetail.GetITemString(llDetailPos,'country_of_origin') > ' ' Then
					idsReceiveDetail.SetItem(1,'country_of_origin',idsPODetail.GetItemString(llDetailPos,'country_of_origin'))
				Else
					// 03/04 - PCONKL - Should load default from ITem Master
					Select Country_of_origin_default into :lsDefCoo
					From Item_Master
					Where project_id = :lsProject and sku = :lsSKU and supp_code = :lsSupplier;
					
					If lsDefCoo > '' Then
						idsReceiveDetail.SetItem(1,'country_of_origin',lsDefCoo)
					Else
						idsReceiveDetail.SetItem(1,'country_of_origin','XXX')
					End If
					
				End If
				
				
				If idsPODetail.GetITemString(llDetailPos,'alternate_sku') > ' ' Then
					idsReceiveDetail.SetItem(1,'alternate_sku',idsPODetail.GetItemString(llDetailPos,'alternate_sku'))
				Else
					idsReceiveDetail.SetItem(1,'alternate_sku',idsPODetail.GetItemString(llDetailPos,'sku'))
				End If
				If idsPODetail.GetITemString(llDetailPos,'Cost') > ' ' Then
					idsReceiveDetail.SetItem(1,'cost',Dec(idsPODetail.GetItemString(llDetailPos,'cost')))
				End If
				// 9/9/2013 - gwm - Add Line Date
				//TimA 09/03/14 No Longer needed
				//If idsPODetail.GetITemString(llDetailPos,'po_line_date') > ' ' Then
				//	idsReceiveDetail.SetItem(1,'po_line_date',idsPODetail.GetItemString(llDetailPos,'po_line_date'))
				//End If
				
				//TimA 08/28/14 Added Distribution_Line Pandora issue #889
				//If idsPODetail.GetITemNumber(llDetailPos,'Distribution_Line') > 0 Then
				//	idsReceiveDetail.SetItem(1,'Distribution_Line',idsPODetail.GetItemNumber(llDetailPos,'Distribution_Line'))
				//End If

				
				//If idsPODetail.GetItemString(llDetailPos,'Shipment_Distribution_No') > ' ' Then
				//TimA 03/23/15 In the staging tables the Distribution field is a blank space so the > '' did not work and was inserting a null value for Distr.
				//When we finely turn on Distribution field then we can search for a > ''
				if Upper(Trim(lsProject)) = 'PANDORA' then
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'Shipment_Distribution_No',idsPODetail.GetItemString(llDetailPos,'Shipment_Distribution_No'))
				//End If

				//If string(idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'),'MM/DD/YYYY') <> "12/31/2999" and string(idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'),'MM/DD/YYYY') <> "01/01/1900" Then
				//TimA 03/23/14 In the staging tables the Need By Date field is a blank space so the > '' did not work and was inserting a null value for Need By
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'Need_By_Date',idsPODetail.GetItemDateTime(llDetailPos,'Need_By_Date'))
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
					// 04/27/2012 - GXMOR - added supp_code to query for multiple suppliers per SKU
					Select Min(owner_id) into :llOwner
					From Item_Master
					Where  project_id = :lsProject and sku = :lsSku and supp_code = :lsSupplier;
				
					idsReceiveDetail.SetItem(1,'owner_id',llOwner)		
				End If /*owner present*/					

				// 2015/05/19 - gwm - Add named fields from EDI detail
				If idsPODetail.GetItemString(llDetailPos, 'Currency_Code') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Currency_Code', idsPODetail.GetItemString(llDetailPos, 'Currency_Code'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Supplier_Order_Number') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Supplier_Order_Number', idsPODetail.GetItemString(llDetailPos, 'Supplier_Order_Number'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Cust_PO_Nbr') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Cust_PO_Nbr', idsPODetail.GetItemString(llDetailPos, 'Cust_PO_Nbr'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Line_Container_Nbr') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Line_Container_Nbr', idsPODetail.GetItemString(llDetailPos, 'Line_Container_Nbr'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Vendor_Line_Nbr') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Vendor_Line_Nbr', idsPODetail.GetItemString(llDetailPos, 'Vendor_Line_Nbr'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Client_Line_Nbr') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Client_Line_Nbr', idsPODetail.GetItemString(llDetailPos, 'Client_Line_Nbr'))
				End If
				
				If idsPODetail.GetItemString(llDetailPos, 'Client_Cust_PO_NBR') > ' ' Then 
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(), 'Client_Cust_PO_NBR', idsPODetail.GetItemString(llDetailPos, 'Client_Cust_PO_NBR'))
				End If
				
				//18-Feb-2019 :Madhu S28685 DE8793 Update SSCC Nbr
				If idsPODetail.GetItemString(llDetailPos,'SSCC_Nbr') >' ' Then
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'SSCC_Nbr',idsPODetail.GetItemString(llDetailPos,'SSCC_Nbr'))
				End If
				
				//23-JUNE-2017 :Madhu Added for PINT-856
				If idsPODetail.GetItemNumber(llDetailPos,'om_change_request_nbr') > 0 Then
					idsReceiveDetail.SetItem(idsReceiveDetail.RowCount(),'om_change_request_nbr', idsPODetail.GetItemNumber(llDetailPos,'om_change_request_nbr'))
				End If
				// End add named fields

			Else /*system Error*/
				uf_writeError("Order Nbr (PO Detail): " + string(lsOrderNo) + " - System Error: Unable to retrieve Receive Order Detail Records")
				lbError = True
				Continue /*next Detail*/
			End If /*Receive detail records exist? ) */
			
			//Update the Detail Record
			SQLCA.DBParm = "disablebind =0"
			liRC = idsReceiveDetail.Update()
			SQLCA.DBParm = "disablebind =1"
			If liRC = 1 then
				Commit;
			Else
				lslogout = sqlca.sqlerrtext /*text will be lost after rollback*/
				FileWrite(giLogFileNo,lsLogOut)
				uf_write_log(lsLogOut) /*write to Screen*/
				Rollback;
				uf_writeError("- ***System Error!  Unable to Save Receive Detail Record to database!")
				lbError = True
				COntinue
			End If
				
		Else /* Errors exist on Detail, mark with status cd and error text*/
			

			//idsPODetail.SetItem(llDetailPos,'status_cd','E')
			If Left(lsDetailErrorText,1) = ',' Then lsDetailErrorText = Right(lsDetailErrorText,(len(lsDetailErrorText) - 1)) /*strip first comma*/
			//idsPODetail.SetItem(llDetailPos,'status_message',lsDetailErrorText)
			//TimA 04/02/15 changed this to a dynamic SQL because the order error updates are like this.  Also Pandora is using a different  idsPODetail becuase of grouping and summing qty
			Update edi_inbound_detail
			Set Status_cd = 'E', status_message = :lsDetailErrorText
			Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
			Commit;
			
		End If /*no errors on detail*/
		
	Next /*edi detail record*/
	
	w_main.SetMicroHelp("Ready..")
	
	//If there were errors on any of the details and this is a new order, we will delete the header and any details that
	//might have been saved. The header will have been saved before the details were processed but we dont want to keep it
	
	//save any changes made to edi records (status cd, error msg)
	
	SQLCA.DBParm = "disablebind =0"
	idsPOHeader.Update(True,False)
	//TimA 04/02/15 Pandora uses a different datawindow that does not allow updates. 
	If lsProject <> 'PANDORA' then
		idsPODetail.Update()
	End if
	SQLCA.DBParm = "disablebind =1"

	Commit;
	
// TAM 2013/12/02 -  Moved after the commits.  Not all address records are written to the DB before the OTM Post
//	//MEA - 3/13 - Added Send to OTM
//	
//	If gs_OTM_Flag = 'Y' and gsOTMSendInboundOrder = 'Y' Then
//
//		iu_otm.uf_process_inbound_order(lsProject, lsRoNo, idsPOHeader,  llHeaderPos, idsReceiveMaster, isDeleteSkus)
//
//	End if  //OTM Flag
//	
	
	If lbError or lbDetailErrors Then 
		
		// 03/03 - PCONKL - If not allowing orders with detail errors, delete any new records created if any details had errors
		If lsAllowPOErrors <> 'Y' Then
			
			If idsReceiveMaster.GetITemStatus(1,0,Primary!) = NewModified! /* new PO */ Then
				//lsRONO will contain the RO_NO of the records just created
				Delete from receive_detail where ro_no = :lsROno;
				Delete from receive_Notes where ro_no = :lsRoNo; /* 10/03 - PCONKL */
				Delete from receive_master where ro_no = :lsRoNo;
				Commit;
			End If /* new PO with errors*/
						
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - No changes applied to this Order!")
			
		Else /*saved with errors */
				
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - Order saved with errors!")
			
		End If

		lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
		
		//Update any header/detail records with error status if we didn't catch an individual error on the detail level
		Update edi_inbound_header
		Set status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
		
		Update edi_inbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
		
		//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -START
		If idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			this.uf_process_om_writeerror( asproject, 'E', idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'), 'IB', 'Errors exist on Header/Detail') //write error log and trigger email alert
		End If
		//07-JULY-2017 Madhu PINT-856 -Update respective tables of OM -END		
		
		Commit;
	
	End If
	
	//We also want to delete a new header (on an update) if there are no details associated with it
	//lsrono should only be populated if we added a new row, if there is more than 1 header row, it has to be an update
	//If it is a new add and there were no detail rows, we don't want to delete it
	If idsReceiveMaster.RowCount() > 1 and lsRoNo > ' ' Then
		Select Count(*) into :llCount
		From receive_detail
		where ro_no = :lsRoNO;
		
		If llCount = 0 Then
			DElete from receive_master where ro_no = :lsRoNo;
			Commit;
		End If
		
	End If
	
	idsReceiveMaster.REsetUpdate()
	
	// 10/03 - PCONKL - Update notes record with ro_no just created
	// 03/09 - PCONKL - Update any Receive_Alt_Address records just created
	If lsroNO > ' ' Then
		
		SQLCA.DBParm = "disablebind =0"
		
		Update Receive_notes
		Set ro_no = :lsRONO 
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq;
		
		Commit;
		
		Update Receive_alt_Address
		Set ro_no = :lsRONO 
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llOrderSeq;
		
		Commit;
		
		SQLCA.DBParm = "disablebind =1"
		
	End If
// TAM 2013/12/02 -  Moved after the commits.  Not all address records are written to the DB before the OTM Post
	//MEA - 3/13 - Added Send to OTM
	
	If gs_OTM_Flag = 'Y' and gsOTMSendInboundOrder = 'Y' Then

		iu_otm.uf_process_inbound_order(lsProject, lsRoNo, idsPOHeader,  llHeaderPos, idsReceiveMaster, isDeleteSkus)

	End if  //OTM Flag

	
	//10/08 - PCONKL - If we don't have any details for latest header,delete. If we hit it at this point it would be because we deleted all of the detail records above...
	If idsReceiveMaster.RowCount() > 0 Then
		
		lsRoNo = idsReceiveMaster.GetITemString(idsReceiveMaster.RowCount(),'ro_no')
		
		Select Count(*) into :llCount
		From receive_detail
		where ro_no = :lsRoNO;
		
		If llCount = 0 Then
			if lsProject <> 'PANDORA' then									
				DElete from receive_master where ro_no = :lsRoNo;
				Commit;
			else
				// LTK 20151207  Surrounded above delete with an "if" condition because Pandora is no longer deleting the RO, just setting status to Void
				UPDATE receive_master
				SET Ord_Status = 'V'
				WHERE ro_no = :lsRoNo;
				Commit;
			end if
		End If
				
	End If
	
	ll_last_line_item_no = 0		// LTK 20120606  Pandora #353
	
	//05-SEP-2017 Madhu PINT -856 - Write Inbound Acknowledge records into OMQ Table -START
	lsAction_cd =idsPOHeader.GetItemString(llHeaderPos,'action_cd')
	lsStatus_cd = idsPOHeader.GetITemString(llHeaderPos,'Status_Cd')
	If ((idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0) and (upper(lsStatus_cd) <> 'E')) Then 
		If lsAction_cd ='A' Then lsAction_cd ='I'
		this.uf_process_om_inbound_acknowledge( asproject, lsRoNo, lsAction_cd)
	End If
	//05-SEP-2017 Madhu PINT -856 - Write Inbound Acknowledge records into OMQ Table -END
	
Next /* EDI Header Record*/

//mark any records as complete that might have been skipped (continued to next header*/
For llHeaderPos = 1 to llHeaderCount
	
	lsProject = idsPOHeader.GetITemString(llHeaderPos,'project_id')
	lsOrderNo = idsPOHeader.GetITemString(llHeaderPos,'order_no')
	llBatchSeq = idsPOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no')
	lsStatus_cd = idsPOHeader.GetITemString(llHeaderPos,'Status_Cd')
	
	Update edi_inbound_header
	Set status_cd = 'C' , status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
				
	Update edi_inbound_detail
	Set Status_cd = 'C', status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
	
	commit;
	
	//15-JUNE-2017 Madhu PINT-856 -Add successfully loaded orders into an Array -START
	If idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
		ll_row =lds_om_receipt_list.insertrow( 0)	
		lds_om_receipt_list.setitem( ll_row, 'project_Id', lsProject)
		lds_om_receipt_list.setitem( ll_row, 'change_req_no', idsPOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'))
		lds_om_receipt_list.setitem( ll_row, 'status_cd', lsStatus_cd)
	End If
	//15-JUNE-2017 Madhu PINT-856 -Add successfully loaded orders into an Array - END
Next

//21-MAR-2018 :Madhu DE3461 - Removed lsStatus_cd <> 'E'
If (lds_om_receipt_list.rowcount( ) > 0 ) Then uf_process_om_inbound_update( lds_om_receipt_list) //15-JUNE-2017 Madhu PINT -856

destroy lds_om_receipt_list


If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/

If lbValError Then 
	If ls_supp_code ='THL0' then
		is_warehouse ='PHILIPS-NC'
	end if 
	Return -1
Else
	Return 0
End If

end function

public function integer uf_process_ftp_inbound ();
//This function will extract files from FTP and load them into folders on PC to be processed in the next step

Integer	liRC
Long		llArrayCount,	&
			llArrayPos,	&
			llArrayCount2,	&
			llArrayPos2,	&
			llCount,	&
			llFolderPos,	&
			I,					&
			llArrayFind

String	lsLogOut,	&
			lsDirList,	&
			lsDir[],		&
			lsFiles[],	&
			lsFileSize[],	&
			lsFiles2[],	&
			lsFileSize2[],	&
			lsNullArray[],	&
			lsCurrentFile,	&
			lsLocalFile,	&
			lsProject
			
ulong ll_dwcontext, l_buf
boolean lb_currentdir,bRet

l_buf = 300

//Get the current directory
//this.GetCurrentDirectoryA(l_buf, lscurdir)

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Downloading Inbound FTP Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//Get a list of all directories to process
lsDirList = ProfileString(gsinifile,'FTPINBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/
	
	
//Process the requested FTP Directories
For llFolderPos = 1 to UpperBound(lsDir) /*For each Folder*/
	//TimA 12/22/11
	yield()

	//Make Sure we're logged out of Current FTP server
	uf_ftp_disconnect()

	If lsDir[llFolderPos] = '' Then Continue
	
	lsLogOut = "  - Processing FTP Directory: '" + lsDir[llFolderPos] + "'"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get the project for the current folder from the profileString
	lsProject = ProfileString(gsinifile,lsDir[llFolderPos],"project","")
	
	//Connect to FTP
	If uf_ftp_connect(lsDir[llFolderPos]) < 0 Then
		Continue /* Next Project*/
	End If
	
	//Change directory
	If ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryin","") > ' ' Then
		If uf_ftp_setDir(ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryin","")) < 0 Then
			Continue /* with next projet */
		End If
	End If
	
	//reset file and size arrays
	lsFiles[] = lsNullarray[]
	lsFilesize[] = lsNullarray[]
	lsFiles2[] = lsNullarray[] /*size comparison arrays*/
	lsFilesize2[] = lsNullarray[] /*size comparison arrays*/
	
	//Get a list of all Files to process 
	lsLogOut = "         - Getting directory information (1st pass)"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	This.uf_ftpdirtoarray("",lsFiles[],lsFileSize[],il_hConnection)
	
	//wait aprox 15 seconds and get another snapshot - we will bypass any files that are still growing so we dont
	//download partial files
	//Get a list of all Files to process (second Pass) if files wre found in first path
	If UpperBound(lsFiles) > 0 Then
		
		lsLogOut = "         - Delay start for 2nd pass of directory information " + String(today(),'mm/dd/yyyy hh:mm:ss')
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		
		//TimA 12/22/11
		yield()
		lsLogOut = "          - PLEASE WAIT!!: " 
		uf_write_Log(lsLogOut) /*display msg to screen*/

		Sleep(15) //See Comment above
	
		lsLogOut = "         - Getting directory information (2nd pass) " + String(today(),'mm/dd/yyyy hh:mm:ss')
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		yield()
		This.uf_ftpdirtoarray("",lsFiles2[],lsFileSize2[],il_hConnection)
		
	End If

	//Download all files to the PC directory to be processed by the next step (process inbound flat files)
	llArrayCount = UpperBound(lsFiles)
	
	lsLogOut = Space(4) + "- " + String(llArrayCount) + " Files found in directory for processing."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Process each file in the current FTP Directory
	For llArrayPos = 1 to llArrayCount /*for each file in the FTP Folder*/
		//TimA 12/22/11
		yield()

		lsCurrentFile = Trim(lsFiles[llArrayPos])
		If Not lsCurrentFile > ' ' Then Continue
		
		//See if the file sizes are different between the 2 snapshots, skip file if they are
		
		//Find the Current file in the new array (it may not be in the same position)
		llArrayFind = 0
		llArrayCount2 = UpperBound(lsFiles2)
		For llArrayPos2 = 1 to llArrayCOunt2
			If lsCurrentFile = trim(lsFiles2[llArrayPos2]) Then
				llArrayFind = llArrayPos2
				Exit
			End If
		Next
		
		If llArrayFind > 0 Then
			
			If lsFileSize[llArrayPos] <> lsFileSize2[llArrayFind] Then /*file still being written, skip*/
			
				lsLogOut = Space(6) + "- Skipping File: '" + lsCurrentFile + " (File is still being written)."
				uf_write_log(lsLogOut) /*write to Screen*/
				FileWrite(gilogFileNo,lsLogOut)
				Continue /* Next file */
		
			End If
		
		End If
				
		lslocalFile = ProfileString(gsinifile,lsDir[llFolderPos],"ftpfiledirin","") + '\' + lsCurrentFile
						
		lsLogOut = Space(6) + "- Downloading FTP File: '" + lsCurrentFile + "'to " + lsLocalFile + "."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		
		bRet =FtpgetFile(il_hConnection,lsCurrentFile,lslocalFile,false,0,2147483648,ll_dwcontext) /* 2147483648 = INTERNET_FLAG_RELOAD (don't take from Cache) */
		//TimA 12/22/11
		yield()
		
		IF not bRet THEN
			lsLogOut = Space(6) + "- ***Unable to download FTP File : '" + lsCurrentfile + "', File will not be processed"
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			uf_send_email('XX','System','***SIMSFP - Unable to download FTP File Alert***', lsLogOut,'') //4/1/2015 :Madhu- Added to sent mail notification to all.
			Continue
		END IF
		
		// If file prcessed successfully, Delete File from FTP
		lsLogOut = Space(6) + "- Deleting FTP File: '" + lsCurrentFile + "'."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		bret = FtpDeleteFile(il_hConnection,lsCurrentFile)
		If Not Bret Then
			lsLogOut = Space(6) + "- ***Unable to Delete File : '" + lsCurrentFile + "'"
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			Continue
		End If
		
		//Acknowledge the File Receipt if requested
		uf_ftp_ack(lsDir[llfolDerPos])

	Next /*Next file in current FTP Folder*/
	
	//Logout of Current FTP server
	uf_ftp_disconnect()
	//TimA 12/22/11
	yield()
			
Next /* Next FTP Folder to process*/

//Make Sure we're logged out of Current FTP server
uf_ftp_disconnect()

//Close the internet connection if Open - hopefully, clear cache
If il_hopen > 0 Then
	InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
End If

Return 0
end function

public function integer uf_process_flatfile_outbound ();
//Process flatfile outbound files

String	lsLogOut, lsProject,	lsDir[],	lsDirList,	lsPathOut, 	lsDefPathOut, lsFileOut,	&
			lsData,	lsSaveFileName, lsOrigFileName, 	lsFilePrefix, lsFileSuffix, &
			lsFileExtension, lsFileSequence, lsDestCd, lsDestPath, lsFileName, lsTmpFileName, lsFileExt
			
Long		llArrayPos,	llDirPos	,	llRowCount,	llRowPos, llBatchSeq, llBatchSeqHold, llFileNo,	llRC
			
//Jxlim 02/02/2013 Changed Integer to Long
//Integer	liFileNo,	&
//			liRC
							
Boolean	bRet, lbProjectError

Datastore	ldsOut

ldsOut = Create u_ds_datastore
ldsOut.dataobject= 'd_edi_generic_out'
ldsOut.SetTransObject(SQLCA)

//Jxlim 02/02/2013 Sybase;FileWriteEx is maintained for backward compatibility. Use the FileWriteExEx function for new development.
lsLogOut = ''
FileWriteEx(giLogFileNo,lsLogOut)
uf_write_Log(lsLogOut) /*display msg to screen*/
lsLogOut = '- PROCESSING FUNCTION: Extract Outbound Flat Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWriteEx(giLogFileNo,lsLogOut)
uf_write_Log(lsLogOut) /*display msg to screen*/
lsLogOut = ''
FileWriteEx(giLogFileNo,lsLogOut)
uf_write_Log(lsLogOut) /*display msg to screen*/


//Get a list of all directories to process
lsDirList = ProfileString(gsinifile,'FLATFILEOUTBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/

//For each directory that we are processing, retrieve and process all records for that project
For llDirPos = 1 to Upperbound(lsDir)
	
	lbProjectError = False
	lsPathOut = ''
	
	lsProject = ProfileString(gsinifile,lsDir[llDirPos],"project","")
	lsDefPathOut = ProfileString(gsinifile,lsDir[llDirPos],"flatfiledirout","") +'\' /* 10/03 - PCONKL - default path for project may be overridden below */
	
	lsLogOut = '    Project: ' + lsProject
	FileWriteEx(giLogFileNo,lsLogOut)
	uf_write_Log(lsLogOut) /*display msg to screen*/
	
	//For each Project, retrieve any pending output records from DB - Create a new file and save to the directory listed in .INI file
	//The file name will be the batch Sequence number of the first DB data + .dat
	//we are assuming that there can be multiple transaction types (would have different batch seq no) in the same file
	// i.e we may have a receipt confirmation and a delivery confirmation - if they were both created before we proessed the first one'
	
	//Each transaction will be sent in a seperate file. 
	//The file name should include the transaction type in the name
	
	//TimA 02/04/14 Added Method trace to outbound logic
	Select Code_id INTO :gs_method_log_flag from lookup_table where Project_ID = :lsProject and Code_type = 'LOG_Trace';
	If isNull(gs_method_log_flag) Then gs_method_log_flag  = 'N'
	
	llRowCount = ldsOut.Retrieve(lsProject)
	
	lsLogOut = '      ' + string(llRowCount) + ' Rows were retrieved for output to Flat File...'
	uf_write_log(lslogOut)
	FileWriteEx(giLogFileNo,lsLogOut)
	
	llbatchSeqHold = 0
	
	If llRowCount > 0 Then
		//TimA 12/22/11
		yield()
				
		//For each row, stream the data to the output file
		For llRowPos = 1 to llRowCount
			llbatchSeq = ldsOut.GetItemNumber(llRowPos,'edi_batch_seq_no')
			If llBatchSeq <> llBatchSeqHold Then /*it's a new output file*/
				
				//Jxlim 02/02/2013 Use long intead of Interger 
				//Close the existing file (if it's the first time, fileno will be 0)
				//If liFileNo > 0 Then
				If llFileNo > 0 Then					
					FileClose(llFileNo) /*close the file*/
					
					//Jxlim 02/13/2013 Remove .TMP extension when file is closed due to BatchSeq has changed
					//Jxlim 02/13/2013 Baseline - Copy to lsFileOut. Remove .TMP ext and, use original file extension
					lsFileExt = Right(lsFileOut, 4)
					If Upper(Trim(lsFileExt)) ='.TMP' Then
						lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
						lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
						lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension							
						
						//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
						If FIleExists(lsOrigFileName) Then
							FileDelete(lsOrigFileName)
							lsLogOut = Space(10) + "File Sequence; Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."		
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End if
					
						//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.			
						bret=MoveFile(lsTmpFileName, lsOrigFileName)
						//Jxlim 01/23/2012 write message on rename status
						If Bret Then
							lsLogOut = Space(10) + "File sequence has changed and File data successfully replaced and renamed to Original: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to rename*/
							lsLogOut = Space(10) + "***File sequence has changed but Unable to replaced/renamed .TMP file data and .ext to Original File: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If		
						
						//Extract the file
						lsLogOut = Space(10) + "File sequence has changed and Flat File data successfully extracted to: " + lsPathOut + lsFileOut
						FileWriteEx(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
					
						//Archive the file
						lsOrigFileName = lsPathOut + lsFileOut
						//MA 12/08 - Added .txt to file
						lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsFileOut + '.txt'
																					
						If FIleExists(lsSaveFileName) Then
							lsSaveFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
						End IF
						
						bret=CopyFile(lsOrigFileName,lsSaveFileName,True)								
						//Jxlim 02/13/2012 write message on archive status
						If Bret Then
							lsLogOut = Space(10) + "File sequence has changed and File archived to: " + lsSaveFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to archive*/
							lsLogOut = Space(10) + "***File sequence has changed but Unable to archive File: " + lsSaveFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If														
							
					//delete records from edi_generic_outbound (needs to be done once at end for last Batch_Seq)
					// - this was previously done below by deleting from datastore, 
					//   but datastore was having trouble deleting if non-unique Batch/Line 
					//   combinations existed (they shouldn't, but somehow did/do)
					Delete FROM EDI_Generic_Outbound      
					WHERE Project_id = :lsProject
					and EDI_Batch_Seq_No = :llBatchSeqHold;
					commit;
					/* may want to test sqlcode for error....
					If sqlca.sqlcode = 0 Then
						commit;
					else
						//ls_ErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
						Rollback;
						lsLogOut = "      ***System Error!  Unable to delete records output to Flat File!"
						FileWriteEx(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
						
						//Notify the systems list - otherwise we'll keep resending the records
						uf_send_email('XX','Filexfer','***Unable to delete records***',lsLogOut,'') /*send an email mesg to the systems distribution list*/
						
						//Reduce the Sweep time to give time to catch before resending			
						w_main.sle_sweep_interval.Text = "3600" /*one hour */
						w_main.sle_sweep_interval.TriggerEvent("Modified")
					End If
					*/
					End If //Jxlim 02/13/2013  File Sequence has changed; closed the file; end of .TMP removed on this section		
				End If /*not first time*/
				
				// 10/03 - Pconkl - we may have different output paths depending on the dest_Cd field in the output file
				lsDestPath = ''
				If ldsOut.GetItemString(llRowPos,'Dest_cd') > '' Then
					lsDestCd = "flatfileout-" + 	ldsOut.GetItemString(llRowPos,'Dest_cd')
					lsDestPath = ProfileString(gsinifile,lsDir[llDirPos],lsDestCd,"")
				End IF
				
				If lsDestPath > '' Then
					lsPathOut = lsDestPAth + '\'
				Else
					lsPathOut = lsDefPathOut 
				End If
				
				//Create the file name from the record type of first rec and the batch seq no

				// 05/03 - PCONKL - we may have a specific prefix, suffix (after the seq #, or file extension
				lsFileSequence = String(ldsOut.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
				
				//Prefix
				lsFilePRefix = ProfileString(gsinifile,lsDir[llDirPos],"flatfileoutprefix","")
				If isNull(lsFilePrefix) or lsFilePrefix = '' Then
					lsFilePrefix  = Left(ldsOut.GetItemString(llRowPos,'batch_data'),2)
				End If
				
				//Suffix
				lsFilesuffix = ProfileString(gsinifile,lsDir[llDirPos],"flatfileoutsuffix","")
				If isNull(lsFilesuffix) Then	lsFilesuffix  = ''
				
				//Extension
				lsFileExtension = ProfileString(gsinifile,lsDir[llDirPos],"flatfileoutextension","")
				If isNull(lsFileExtension) or lsFileExtension = '' Then
					lsFileExtension  = ".dat"
				End If
				
				//Build file name
				//We may have a file name specified in the output data. If so, it ovverides the ini file			
				lsFileName = ldsOut.GetITemString(llRowpos,'file_name')
				If lsFileName > '' Then
					lsFileOut = lsFileName
				Else
					lsFileOut = lsFilePrefix + lsFileSequence + lsFileSuffix + lsFileExtension
				End If
					
				If lsFileOut = '' or isNull(lsFileOut) Then Continue
				
				
				//Jxlim 01/15/2013 Baseline changed - 
				//Notes: The file name exist on datastore but really the file has not exist on directory as yet.
				//During the process of writing flatfileout, we need to name the file ext with .TMP
				//to prevent file from grabbed by in the middle of writing. When is done writing we will have to remove .TMP 
				//so the file will be pick up by downstream as it should.				
				lsFileOut = lsFileOut + '.TMP'  
				llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
				//If (liFileNO < 0) OR isNull(liFileNo) or isnull(lsFileOut) Then
				If (llFileNO <=  0) OR isNull(llFileNo) or isnull(lsFileOut) Then	
					lsLogOut =  "      ***Unable to open file: "
					If not isnull(lsPathOut) Then lsLogOut += lsPathOut 
					If not isnull(lsFileOut) Then lsLogOut += lsFileOut
					lsLogOut += " For output to Flat File. - SKIPPING TO NEXT PROJECT."
					FileWriteEx(gilogFileNo,lsLogOut)		
					uf_write_Log(lsLogOut) /*display msg to screen*/
					lbProjectError = True
					uf_send_email(lsDir[llDirPos],'Filexfer'," - ***** Unable to open Flatfile Out",lsLogOut,'') /*send an email msg to the file transfer error list*/
					Exit /* Continue with next project*/
				//	Return -1
				End If
	
				lsLogOut = '      File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
				FileWriteEx(gilogFileNo,lsLogOut)	
				uf_write_log(lsLogout)
				
			End If /* new File? */
		
			//Stream the data for the current Row
			lsData = ldsOut.GetItemString(llRowPos,'batch_data')
			
			// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
			If (Not isnull(ldsOut.GetItemString(llRowPos,'batch_data_2'))) and ldsOut.GetItemString(llRowPos,'batch_data_2') > '' Then
				lsData += ldsOut.GetItemString(llRowPos,'batch_data_2')
			End If
			
			//Jxlim 02/02/2013 Use long intead of Interger and FileWriteExEX to speed up performance
			//liRC = FileWrite(liFileNo,lsData)
			llRC = FileWriteEx(llFileNo,lsData)
			//If liRC < 0 Then
			If llRC < 0 Then
				lsLogOut = "      ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
				FileWriteEx(gilogFileNo,lsLogOut)	
				uf_write_Log(lsLogOut) /*display msg to screen*/
				uf_send_email(lsDir[llDirPos],'Filexfer'," - ***** Unable to Write to File",lsLogOut,'') /*send an email msg to the file transfer error list*/
				
			End If
			
			llbatchSeqHold = llBatchSeq
			
		Next /*data row*/
		
		//If we were unable to open a file for this project, move on to next project
		If lbProjectError Then Continue
		
		//Jxlim 02/02/2013 Use long intead of Interger 
		//Close the Last file ...
		If llFileNo > 0 Then
			FileClose(llFileNo) /*close the file*/
			//... and delete last batch_seq's records
			Delete FROM EDI_Generic_Outbound      
			WHERE Project_id = :lsProject
			and EDI_Batch_Seq_No = :llBatchSeq;
			commit;
		End If 
					
		//Jxlim 02/13/2013 Remove .TMP extension after closing the file	
		lsFileExt = Right(lsFileOut, 4)
		If Upper(Trim(lsFileExt)) ='.TMP' Then
			lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
			lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
			lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
		End If
	
		//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
		If  FIleExists(lsOrigFileName) Then
			FileDelete(lsOrigFileName)
			//Jxlim 02/20/2013 this message just for testing
			lsLogOut = Space(10) + "***Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."	
			FileWriteEx(giLogFileNo,lsLogOut)
			uf_write_Log(lsLogOut)
		End if
		
		//bret=CopyFile(lsTmpFileName, lsOrigFileName,True)  //Copy file content from .TMP to the original file
		//bret=DeleteFile(lsTmpFileName)  //Delete .TMP file after copy to original
		//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
		bret=MoveFile(lsTmpFileName, lsOrigFileName)
		//Jxlim 01/23/2012 write message on rename status
		If Bret Then
			lsLogOut = Space(10) + "File data successfully replaced and renamed to Original extension: " + lsOrigFileName
			FileWriteEx(giLogFileNo,lsLogOut)
			uf_write_Log(lsLogOut)
		Else /*unable to rename*/
			lsLogOut = Space(10) + "*** Unable to replaced/renamed .TMP file data and extension to Original File: " + lsOrigFileName
			FileWriteEx(giLogFileNo,lsLogOut)
			uf_write_Log(lsLogOut)
		End If
		
		//Jxlim 01/15/2013 Baseline - Remove .TMP ext and, apply original file extension
		lsLogOut = Space(10) +"Flat File data successfully extracted to: " + lsPathOut + lsFileOut
		FileWriteEx(gilogFileNo,lsLogOut)
		uf_write_Log(lsLogOut) /*display msg to screen*/
			
		//Archive the file -
		lsOrigFileName = lsPathOut + lsFileOut
		//MA 12/08 - Added .txt to file
		lsSaveFileName = ProfileString(gsinifile,lsDir[llDirPos],"archivedirectory","") + '\' + lsFileOut + '.txt'		
		
		// 03/04 - PCONKL - Check for existence of the file in the archive directory already - rename if duplicated
		//							We are now sening constant file names to some users instead of unique names (peice of shit AS400)
		
		If FileExists(lsSaveFileNAme) Then
			lsSaveFileName += '.' + String(DateTime(Today(),Now()),'yyyymmddhhss') + '.txt'
		End IF
		
	    Bret=CopyFile(lsOrigFileName,lsSaveFileName,True)		
				//Jxlim 01/23/2012 write message on archive status
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsSaveFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsSaveFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
		
		//Delete the records from the databse after processing them
		/*dts - now deleting with in-line sql as we scroll through the datastore
		For llRowPos = llRowCount to 1 Step -1
			ldsOut.DeleteRow(llRowPos)
		Next
	
		lirc = ldsOut.Update()
		If liRC = 1 Then
			Commit;
			lsLogOut = "      Data successfully sent to Flat File! "
			FileWriteEx(gilogFileNo,lsLogOut)
			uf_write_Log(lsLogOut) /*display msg to screen*/
		Else
			Rollback;
			lsLogOut = "      ***System Error!  Unable to delete records output to Flat File!"
			FileWriteEx(gilogFileNo,lsLogOut)
			uf_write_Log(lsLogOut) /*display msg to screen*/
			
			//Notify the systems list - otherwise we'll keep resending the records
			uf_send_email('XX','Filexfer','***Unable to delete records***',lsLogOut,'') /*send an email mesg to the systems distribution list*/
			
			//Reduce the Sweep time to give time to catch before resending			
			w_main.sle_sweep_interval.Text = "3600" /*one hour */
			w_main.sle_sweep_interval.TriggerEvent("Modified")
			
			Return -1
			
		End If /*update*/
		*/
		
	Else /*no records to process for directory*/
		
		lsLogOut = "      There was no data to write for project: " + lsProject
		FileWriteEx(gilogFileNo,lsLogOut)
		uf_write_Log(lsLogOut) /*display msg to screen*/
		
	End If /*records exist to output*/
		
Next /*Process next directory*/

Destroy ldsout
gsFileName = lsSavefilename		//Sarun2014Mar20 : Record FileName to publish in batch_transaction Table

Return 0
end function

public function integer uf_process_daily_files (string asaction);//Process all of the daily files

Long	llRC

u_nvo_proc_3com	lu_nvo_proc_3com
u_nvo_proc_hillman lu_nvo_proc_hillman 

u_nvo_proc_phoenix lu_nvo_proc_phoenix 

u_nvo_proc_logitech lu_nvo_proc_logitech
u_nvo_proc_solectron lu_nvo_proc_solectron //TAM 2006/03/24
u_nvo_proc_gm lu_nvo_proc_gm //TAM 2006/03/24
u_nvo_proc_powerwave lu_nvo_proc_powerwave
u_nvo_proc_maquet lu_nvo_proc_maquet
u_nvo_proc_sika lu_nvo_proc_sika //12/07
u_nvo_proc_pandora lu_nvo_proc_pandora //01/09
u_nvo_proc_pulse lu_nvo_proc_pulse //03/10
u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode
u_nvo_proc_stryker lu_nvo_proc_stryker

If Pos(asAction,'3COMDBOH') > 0 Then /*process 3COM Nashville Daily Balance on Hand*/
	lu_nvo_proc_3com = Create u_nvo_proc_3com
	llrc = lu_nvo_proc_3com.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_3com
End If


If Pos(asAction,"HILLMANOR") > 0 Then /*HILLMAN Daily ORDER REPLENISHMENT File*/
	lu_nvo_proc_hillman = Create u_nvo_proc_hillman
	llRC = lu_nvo_proc_hillman.uf_process_or(gsinifile)
	Destroy lu_nvo_proc_hillman
	//if llRC >= 0 then llRC = gu_nvo_process_files.uf_process_purchase_order('HILLMAN') 
End If

If Pos(asAction,"HILLMANBOH") > 0 Then /*HILLMAN Daily BOH File*/
	lu_nvo_proc_hillman = Create u_nvo_proc_hillman
	llRC = lu_nvo_proc_hillman.uf_process_boh(gsinifile)
	Destroy lu_nvo_proc_hillman
End If

If Pos(asAction,'PHXDBOH') > 0 Then /*process Phoenix Brands Daily Balance on Hand*/
	lu_nvo_proc_phoenix = Create u_nvo_proc_phoenix
	llrc = lu_nvo_proc_phoenix.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_phoenix
End If


If Pos(asAction,'PHXEOMSHIPMTD') > 0 Then /*process Phoenix Brands MTD Shipment - EOM*/
	lu_nvo_proc_phoenix = Create u_nvo_proc_phoenix
	llrc = lu_nvo_proc_phoenix.uf_eom_shipment_mtd(gsinifile)
	Destroy lu_nvo_proc_phoenix
End If


// TAM 07/04
If Pos(asAction,'LOGITECHBOH') > 0 Then /*process LOGITECH Daily Balance on Hand*/
	lu_nvo_proc_logitech = Create u_nvo_proc_logitech
	llrc = lu_nvo_proc_logitech.uf_process_boh(gsinifile)
	Destroy lu_nvo_proc_logitech
End If

// TAM 03/20/06
If Pos(asAction,'SOLECTRONDBOH') > 0 Then /*process SOLECTRON Daily Balance on Hand*/
	lu_nvo_proc_solectron = Create u_nvo_proc_solectron
	llrc = lu_nvo_proc_solectron.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_solectron
End If

If Pos(asAction,'POWERWAVEDBOH') > 0 Then /*process powerwave Daily Balance on Hand*/
	lu_nvo_proc_powerwave = Create u_nvo_proc_powerwave
	llrc = lu_nvo_proc_powerwave.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_powerwave
End If


If Pos(asAction,'GMFEDEX') > 0 Then /*process GM FedEx File*/
	lu_nvo_proc_gm = Create u_nvo_proc_gm
	llrc = lu_nvo_proc_gm.uf_fedex_interface_out('GM_MI_DAT')
	Destroy lu_nvo_proc_gm
End If

If Pos(asAction,'MAQUETDBOH') > 0 Then /*process Maquet Daily Balance on Hand*/
	lu_nvo_proc_Maquet = Create u_nvo_proc_Maquet
	llrc = lu_nvo_proc_maquet.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_maquet
End If

If Pos(asAction,'SIKADBOH') > 0 Then /*process SIKA Daily Balance on Hand*/
//TEMPO - use Activity_schedule instead?
	lu_nvo_proc_sika = Create u_nvo_proc_sika
	llrc = lu_nvo_proc_sika.uf_process_dboh(gsinifile)
//	llrc = lu_nvo_proc_sika.uf_inv_snapshot(gsinifile, 'email')
	Destroy lu_nvo_proc_sika
End If


// TAM 2009/11/18  Change to run from Scheduled Activities
//If Pos(asAction,'PANDORADBOH') > 0 Then /*process PANDORA Daily Balance on Hand*/
//	lu_nvo_proc_pandora = Create u_nvo_proc_pandora
//	llrc = lu_nvo_proc_pandora.uf_process_boh_rose(gsinifile)
//	Destroy lu_nvo_proc_pandora
//End If

If Pos(asAction,'PULSEDBOH') > 0 Then /*process Pulse Daily Balance on Hand*/
	lu_nvo_proc_pulse = Create u_nvo_proc_pulse
	llrc = lu_nvo_proc_pulse.uf_process_dboh(gsinifile)
	Destroy lu_nvo_proc_pulse
End If

If Pos(asAction,'PULSEDSF') > 0 Then /*process Daily Shipment File*/
	lu_nvo_proc_pulse = Create u_nvo_proc_pulse
	llrc = lu_nvo_proc_pulse.uf_process_dsf(gsinifile)
	Destroy lu_nvo_proc_pulse
End If

If Pos(asAction,'CHINADBOH') > 0 Then 
	lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode
	llrc = lu_nvo_proc_baseline_unicode.uf_process_dboh('CHINASIMS', gsinifile)
	Destroy lu_nvo_proc_pulse
End If

If Pos(asAction,'RIVERBEDDBOH') > 0 Then // ADDED RIVERBED
	lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode
	llrc = lu_nvo_proc_baseline_unicode.uf_process_dboh('RIVERBED', gsinifile)
	Destroy lu_nvo_proc_pulse
End If

/*SARUN22MAY2013 : Requested by TanBoonhee*/
If Pos(asAction,'STRYKERDBOH') > 0 Then /*process stryker Daily Balance on Hand*/
	lu_nvo_proc_stryker = Create u_nvo_proc_stryker
	llrc = lu_nvo_proc_stryker.uf_process_dboh('STRYKER',gsinifile)
	Destroy lu_nvo_proc_stryker
End If
/*SARUN22MAY2013 : Requested by TanBoonhee*/
Return 0
end function

public function integer uf_process_flatfile_outbound (ref datastore adw_output, string asproject);//Process outbound Flat files - if passed in a datawindow, we dont need to retrieve becuase the DW is still in memory
//													and not saved to DB



String	lsLogOut, lsProject, 	lsDirList, lsPathOut, lsFileOut,lsErrorPath, lsDefaultPath,	&
			lsData, lsOrigFileName,	lsNewFileName,	lsFileSequence, lsFileSequenceHold, lsFilePrefix, &
			lsFileSuffix, lsFileExtension, lsDestPath, lsDestCD, lsTmpFileName, lsFileExt, lsFileCreated
			
Long		llArrayPos,	&
			llDirPos	,	&
			llRowCount,	&
			llRowPos,	&
			llFileNo,       &
			llRC

//Jxlim 02/02/2013 Changed Integer to Long
//Integer	liFileNo,	&
//			liRC

Boolean	bRet

//1
	lsLogOut = " Start the Uf_process flatfile outbound   - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut)

//Jxlim 02/02/2013 Sybase;FileWriteExEx is maintained for backward compatibility. Use the FileWriteExExEx function for new development.

//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = '- PROCESSING FUNCTION: Extract Outbound Flat Files'
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//
//lsLogOut = '   Project: ' + asProject 
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/

lsProject = asProject

lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'
	
llRowCount = adw_output.RowCount()
	
uf_write_log('     ' + string(llRowCount) + ' Rows were retrieved for flatfile output...')
	
If llRowCount > 0 Then
	
	adw_Output.Sort() /* make sure we're sorted by batch seq so we only open an output file once */
		
	lsFileSequenceHold = ''
	
	//For each row, stream the data to the output file
	For llRowPos = 1 to llRowCount
		//TimA 12/22/11
		yield()

		//If BatchSeq has changed, close current file and create a new one
		lsFileSequence = String(adw_output.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
		
		If lsFileSequence <> lsFileSequenceHold Then
			
				//Close the existing file (if it's the first time, fileno will be 0)
				//Jxlim 02/02/2013 Use Long Instead of Integer
				If llFileNo > 0 Then					
					FileClose(llFileNo) /*close the file*/
					
					//Jxlim 02/13/2013 Remove .TMP extension when file is closed due to BatchSeq has changed
					//Jxlim 02/13/2013 Baseline - Copy to lsFileOut. Remove .TMP ext and, use original file extension
					lsFileExt = Right(lsFileOut, 4)
					If Upper(Trim(lsFileExt)) ='.TMP' Then
						lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
						lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
						lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
						
						//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
						If FIleExists(lsOrigFileName) Then
							FileDelete(lsOrigFileName)
							lsLogOut = Space(10) + "***Datastore -File Sequence; Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."		
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End if
						
						//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
						bret=MoveFile(lsTmpFileName, lsOrigFileName)
						//Jxlim 01/23/2012 write message on rename status
						If Bret Then
							lsLogOut = Space(10) + "Datastore -File sequence has changed and File data successfully replaced and renamed to Original extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to rename*/
							lsLogOut = Space(10) + "*** Datastore -File sequence has changed but Unable to replaced/renamed .TMP file data to Original File extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If				
						
						lsLogOut = Space(10) + "Datastore -File sequence has changed and Flat File data successfully extracted to: " + lsPathOut + lsFileOut
						FileWriteEx(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
						
						//Archive the file
						lsOrigFileName = lsPathOut + lsFileOut
						//MA 12/08 - Added .txt to file
						lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + '.txt'
						
						If FIleExists(lsNewFileName) Then
							lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
						End IF						
						
						bret=CopyFile(lsOrigFileName,lsNewFileName,True)					
						//Jxlim 02/13/2012 write message on archive status
						If Bret Then
							lsLogOut = Space(10) + "Datastore -File sequence has changed and File archived to: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to archive*/
							lsLogOut = Space(10) + "***Datastore -File sequence has changed but Unable to archive File: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If				
						
					End If //Jxlim 02/13/2013  File Sequence has changed; closed the file; end of .TMP removed on this section
					
				End If /*not first time*/
				
				// 10/03 - Pconkl - we may have different output paths depending on the dest_Cd field in the output file
				lsDestPAth = ''
				If adw_output.GetItemString(llRowPos,'Dest_cd') > '' Then
					lsDestCd = "flatfileout-" + 	adw_output.GetItemString(llRowPos,'Dest_cd')
					lsDestPath = ProfileString(gsinifile,lsProject,lsDestCd,"")
				Else
					lsDestPath = ''
				End IF
	
				If lsDestPath > '' Then
					lsPAthout = lsDestPath + '\'
				Else
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'
				End If
		
				// 05/03 - PCONKL - we may have a specific prefix, suffix (after the seq #, or file extension
					
				//Prefix
				lsFilePRefix = ProfileString(gsinifile,lsProject,"flatfileoutprefix","")
				If isNull(lsFilePrefix) or lsFilePrefix = '' Then
					lsFilePrefix  = Left(adw_output.GetItemString(llRowPos,'batch_data'),2)
				End If
				
				//Suffix
				lsFilesuffix = ProfileString(gsinifile,lsProject,"flatfileoutsuffix","")
				If isNull(lsFilesuffix) Then	lsFilesuffix  = ''
	
				//Extension
				lsFileExtension = ProfileString(gsinifile,lsProject,"flatfileoutextension","")
				If isNull(lsFileExtension) or lsFileExtension = '' Then
					lsFileExtension  = ".dat"
				End If
				
				//Build file name
				lsFileOut = lsFilePrefix + lsFileSequence + lsFileSuffix + lsFileExtension
	
				//We may have the file name specified in the datastore
				If adw_output.GetItemString(llRowPos,'file_name') > '' Then
					lsFileOut = adw_output.GetItemString(llRowPos,'file_name')
				End If
	
				lsErrorPath = ""				
			
				//Jxlim 01/15/2013 Baseline changed - 
				//Notes: The file name exist on datastore but really the file has not exist on directory as yet.
				//During the process of writing flatfileout, we need to name the file ext with .TMP
				//to prevent file from grabbed by in the middle of writing. When is done writing we will have to remove .TMP so the file will be pick up by downstream as it should.				
				
				//Jxlim 05/27/2011If Pandora-Worlship Replace (Overwrite) for existing file			
				If  lsFileOut = 'UPSFREIGHTIN' + '.csv'	 Then  /*Replace existing records*/	
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Replace!) //Jxlim 02/12/2012 default Ansi! don't need UTF parameter					
				Else	
					//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!) //Jxlim 02/12/2012 only for unicode usage
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing	
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!) //Jxlim 02/12/2012 default Ansi! don't need UTF parameter
				End If			
				
				//Jxlim 02/02/2013 Use Long instead of Integer, <= 0
				If llFileNO <= 0 Then
					
					//10/08 - PCONKL - If we can't open the specified file, try to write out to a default directory - This probably only should happen if we are trying to write directly to a remote drive that might not be available.
					lsErrorPath =  lsPathOut + lsFileOut /*where we were trying to write to*/
					
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout-hold","") +'\' /*Where we store it locally until we can try again*/
					
					//Try to Open the backup file (local)
					//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
					If llFileNO < 0 or lsPAthOut = "\" Then
					
						lsLogOut = "     ***Unable to open file: " + lsPathOut + lsFileOut + " For output to Flat File."
						If lsErrorPath > "" Then
							lsLogOut += "  *** Attempted to open originally as: " + lsErrorPath + " ***"
						End If
						
						FileWriteEx(gilogFileNo,lsLogOut)		
						uf_write_Log(lsLogOut) /*display msg to screen*/
						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.",lsLogOut ,'') /*send an email msg to the file transfer error list*/
						Return -1
						
					Else /*backup is open, send email to file transfer to alert that it needs to be redropped*/
						
						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.","Unable to open file: " + lsErrorPath + " for remote copy. File stored locally as: " + lsPathOut + lsFileOut + " and needs to be copied manually." ,'') /*send an email msg to the file transfer error list*/
						
					End IF
					
				End If
	
				lsLogOut = '     File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
				FileWriteEx(gilogFileNo,lsLogOut)	
				uf_write_log(lsLogOut)
			
		End If /*File Changed*/
		
		lsData = adw_output.GetItemString(llRowPos,'batch_data')
		
		// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
		If (Not isnull(adw_output.GetItemString(llRowPos,'batch_data_2'))) and adw_output.GetItemString(llRowPos,'batch_data_2') > '' Then
			lsData += adw_output.GetItemString(llRowPos,'batch_data_2')
		End If
			
		llRC = FileWriteEx(llFileNo,lsData)
		
		If llRC < 0 Then
			lsLogOut = "     ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
			FileWriteEx(gilogFileNo,lsLogOut)	
			uf_write_Log(lsLogOut) /*display msg to screen*/
		End If
		
		lsFileSequenceHold = lsFileSequence
		
	Next /*data row*/
			
	If llFileNo > 0 Then
		FileClose(llFileNo) /*close the last/only file*/
	End If	
	
	//Jxlim 02/13/2013 Remove .TMP extension after closing the file	
	lsFileExt = Right(lsFileOut, 4)
	If Upper(Trim(lsFileExt)) ='.TMP' Then
		lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
		lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
		lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
	End If

	//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
	If  FIleExists(lsOrigFileName) Then
		FileDelete(lsOrigFileName)
		//Jxlim 02/20/2013 this message just for testing
		lsLogOut = Space(10) +  "***Datastore -Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."	
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End if
	//bret=CopyFile(lsTmpFileName, lsOrigFileName,True)  //Copy file content from .TMP to the original file
	//bret=DeleteFile(lsTmpFileName)  //Delete .TMP file after copy to original
	//Jxlim 02/03/2013 MoveFile() function does Copy data content, Rename to new file and Delete old file similar to replace file.
	bret=MoveFile(lsTmpFileName, lsOrigFileName)
	//Jxlim 01/23/2012 write message on rename status
	If Bret Then
		lsLogOut = Space(10) + "Datastore -File data successfully replaced and renamed to Original extension: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	Else /*unable to rename*/
		lsLogOut = Space(10) + "*** DataStore -Unable to replaced/renamed .TMP file data to Original File extension: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End If				
	
	//Jxlim 01/15/2013 Baseline - Remove .TMP ext and, use original file extension	
	lsLogOut = Space(10) + "DataStore -Flat File data successfully extracted to: " + lsPathOut + lsFileOut
	FileWriteEx(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut) /*display msg to screen*/
		
	//Archive the last/only file
	lsOrigFileName = lsPathOut + lsFileOut
	//MA 12/08 - Added .txt to file
	IF ( asproject = 'PANDORA_DECOM' ) Then
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut
	ElseIf asproject = 'PANDORA' and (Left(lsFileOut,3) = 'HRR' or Left(lsFileOut,3) = 'MDR') then
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + ".csv"
	Else 
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + ".txt"
	End If
	
	// 03/04 - PCONKL - Check for existence of the file in the archive directory already - rename if duplicated
	//								We are now sending constant file names to some users instead of unique names (peice of shit AS400)
	
	//04/10 - MEA - Since we are batching the records, we only want to send the final file to Archive. 
	// 					 Delete any itermediate files.
	
	IF asproject <> 'WARNER' THEN

		If FileExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		End IF
	
	ELSE
	
		If FileExists(lsNewFileName) Then
			FileDelete ( lsNewFileName )
		END IF
	
	END IF			
	
	Bret=CopyFile(lsOrigFileName,lsNewFileName,True)	
				//Jxlim 01/23/2012 write message on archive status
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
		
Else /*no records to process for directory*/
		
		lsLogOut = "     There was no data to write for project: " + lsProject
		FileWriteEx(gilogFileNo,lsLogOut)
		uf_write_Log(lsLogOut) /*display msg to screen*/
		
End If /*records exist to output*/

		
		
		
//2
	lsLogOut = " End  the Uf_process flatfile outbound   - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut)
		
		
		
		
gsFileName = lsNewFileName	  //Sarun2014Mar20 : Record FileName to publish in batch_transaction Table					
Return 0
end function

public function integer uf_open ();String	lsAction,	&
			lsOutput,	&
			lsCommand,	&
			lsLogName,	&
			ls_machine_name, &
			ls_machine_desc, &
			lsFunctionality

			
Long		llRC,	&
			llArrayPos,	&
			llLogRow,	&
			lLSweepTime

Integer	liRC

ulong lul_name_size =25 
 
ls_machine_name = space(lul_name_size)


mailMessage lmMailMsg
MailFileDescription	mAttach
//gsIniFile = 'c:\SIMS31FP\Sims3FP.ini'

gsIniFile = 'Sims3FP.ini'

lbrestartrequested = False
ilFTPUploadAttempts = 0 /* 04/04 - PCONKL - If we have a certain amount of bad upload attempts, we'll bounce the sweeper*/

SetPointer (HourGlass!)

Open(w_main)

uf_Change_log()

//// 09/05 - PCONKL - Check to see if already running
//liRC = uf_check_running()
//If liRC < 0 Then
//	
//	lsOutput = '**** Another instance of the Sweeper is already running ****'
//	FileWrite(gilogFileNo,lsOutput)
//	uf_write_Log(lsOutput) /*display msg to screen*/
//	
//	//Wait for 30 seconds to see if another instance was just shutting down (scheduled restart)
//	lsOutput = '**** Delaying for 30 seconds to see if other instance is shutting down (Scheduled restart) ****'
//	FileWrite(gilogFileNo,lsOutput)
//	uf_write_Log(lsOutput) /*display msg to screen*/
//	Sleep(30)
//	
//	liRC = uf_check_running()
//	If liRC < 0 Then /*still running...*/
//		lsOutput = '**** Still running, shutting down ****'
//		FileWrite(gilogFileNo,lsOutput)
//		uf_write_Log(lsOutput) /*display msg to screen*/
//		Sleep(3)
//		ibAlreadyRunning = True /*don't send email notification when stopping*/
//		Halt close
//		Return -1
//	End If
//	
//	
//End If

// 06/28/11 cawikholm - -Put check for another sweeper already running back in - Use code from above
liRC = uf_check_running_ini()   // Check entry on ini for running sweeper -
If liRC < 0 Then
	
	lsOutput = '**** Another instance of the Sweeper is already running ****'
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	
	//Wait for 30 seconds to see if another instance was just shutting down (scheduled restart)
	lsOutput = '**** Delaying for 30 seconds to see if other instance is shutting down ****'
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	Sleep(30)
	
	liRC = uf_check_running_ini()
	If liRC < 0 Then /*still running...*/
		// Open Messagebox and force user to Acknowledge
		lsOutput = '**** Still running, shutting down ****'
		MessageBox( 'WARNING','Another instance of the Sweeper is already running.  This instance will shut down once you press ok!',stopsign!,ok! )
		FileWrite(gilogFileNo,lsOutput)
		uf_write_Log(lsOutput) /*display msg to screen*/
		Sleep(3)
		ibAlreadyRunning = True /*don't send email notification when stopping*/
		Halt close
		Return -1
	End If
	
End If

lsOutput = Space(40)
FileWrite(gilogFileNo,lsOutput)

lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + ' - Starting SIMSFP.EXE'
FileWrite(gilogFileNo,lsOutput)
FileWrite(giLogFileNo,'')
uf_write_Log(lsOutput) /*display msg to screen*/

//Connect to DB
sqlca.DBMS       = ProfileString(gsinifile,"sims3FP","dbms","")
sqlca.database   = ProfileString(gsinifile,"sims3FP","database","")
sqlca.userid     = ProfileString(gsinifile,"sims3FP","userid","")
sqlca.dbpass     = ProfileString(gsinifile,"sims3FP","dbpass","")
sqlca.logid      = ProfileString(gsinifile,"sims3FP","logid","")
sqlca.logpass    = "#FTP2sims"

sqlca.servername = ProfileString(gsinifile,"sims3FP","servername","")
sqlca.dbparm	  = ProfileString(gsinifile,"sims3FP","dbparm","")

sqlca.AutoCommit = False

//sqlca.AutoCommit = True

lsOutput = 'Connecting to database: ' + sqlca.servername + '\' + sqlca.database
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

connect using sqlca;

IF sqlca.sqlcode <> 0 THEN
	lsOutput = '** Unable to connect to Database: ' + sqlca.sqlerrtext
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	Halt close
	Return -1
END IF

//Need to set the Ansi warnings off



EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING SQLCA;

gsEnvironment = ProfileString(gsinifile,"sims3FP","Environment","") /*get environment literal*/
If isNull(gsEnvironment) Then gsEnvironment = ''

// 11/10 - PCONKL - spiltting sweeper, want to tie functionality into sweeper name so we know which is which
lsFunctionality = ProfileString(gsinifile,"sims3FP","FUNCTIONALITY","")
If isnull(lsFunctionality) then lsFunctionality = ''

//Reflect Server/database and environment in Window name
//w_main.Title = w_main.Title + ' ' +  ProfileString(gsinifile,"sims3FP","servername","") + '/' + ProfileString(gsinifile,"sims3FP","database","") + '  (' + gsEnvironment + ')'
w_main.Title = w_main.Title + ' ' +  ProfileString(gsinifile,"sims3FP","servername","") + '/' + ProfileString(gsinifile,"sims3FP","database","") + '  (' + gsEnvironment + ')' + " - " + lsFunctionality

//Set Sweep interval and start sweeping
If isNumber(ProfileString(gsinifile,"sims3FP","SWEEPTIME","")) Then
	llSweepTime = Long(ProfileString(gsinifile,"sims3FP","SWEEPTIME",""))
Else
	llSweepTime = 300 /*default to 15 minutes*/
End If

//Send all's good msg...
//dts - 11/03/06 - don't want to send restart msg if this is a timed restart....

// 05/08 - We want to include the server name in the startup...

if upper(ProfileString(gsinifile,"sims3FP","RESTARTING","")) = 'N' then
	
	//not a scheduled restart - send message that we've fired the sweeper back up.
	
	//Get server name...
	GetComputerNameA (ls_machine_name, lul_name_size)
	
	// 06/03/08 - Check server name against list of valid sweeper servers...
	select code_descript into :ls_machine_desc
	from lookup_table where project_id = 'SWEEPER'
	and code_type = 'SERVR'
	and code_id = :ls_machine_name using sqlca;


	if isnull(ls_machine_desc) or ls_machine_desc = '' then
		lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + " Server " + ls_machine_name + ' is not an authorized Sweeper server! Sweeper shutting down...'
		uf_write_Log(lsOutPut) /*display msg to screen*/
		uf_send_email('','System','SIMSFP - * UNAUTHORIZED SWEEPER START! *',lsOutput,'') /*send an email mesg to the systems distribution list*/
		uf_close()
		return 0
	end if
	
	lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + " (Server: " + ls_machine_name + ') - SIMS Sweeper is up and running...go back to bed!'
	uf_send_email('','System','SIMSFP - *SWEEPER Started*',lsOutput,'') /*send an email mesg to the systems distribution list*/
else 
	//scheduled restart - don't send message and reset 'RESTARTING' parameter
	SetProfileString(gsIniFile,'SIMS3FP','RESTARTING','N')
end if

//Show sweep time on window
w_main.sle_sweep_interval.Text = String(llSweepTime)

// Set the window timer vars.
w_main.f_settimer(llSweepTime)

//lsOutput = 'Sweep Delay (seconds): ' + String(llSweepTime)
//FileWrite(gilogFileNo,lsOutput)
//uf_write_Log(lsOutput) /*display msg to screen*/

gbReady = True
uf_main_file_driver() /*first time before delay*/

////start the sweep by initializing the timer
//liRC = Timer(llSweepTime,w_main)

//TimA 12/22/11
yield()


return 1
//
end function

public function integer uf_ftp_upload (string asfilename, string asremotefile, integer aitransfermode);Boolean	bRet
String	lsFIleOut,	&
			lsLogOut,	&
			lsErrorTxt,	&
			lsFileExt, lsFilepre
ULong		ll_dwcontext, llErrorCode
//6/25/04 - dts adding ftp error logging...
string ls_err_str
long ll_last_error
Any temp
string lsRemoteFile, lsNewRemoteFile

//10/05/05 - dts - added rename step at the end of Put step (to prevent Mercator from grabbing file while still uploading)
//12/10 - PCONKL - Do rename for .TXT and  .DAT

//if upper(right(asRemoteFile, 4)) = '.DAT' then
//	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
//else
//	lsRemoteFile = asRemoteFile
//end if

lsFileExt = Right(asRemoteFile,4)
If upper(lsFileExt) = ".DAT" Then lsFileExt = ".DAT" /*make sure .DAT files are always uppercase*/

//Jxlim 04/24/2012 File Prefix first 3 letter
lsFilePre = left(asRemoteFile, 3) 

//Jxlim 04/19/2012 BOHYYYYMMDD Pandora file was truncated.  File was ftp out with incomplete content.
//Added .csv to the statement per Dave to prevent file being ftp while file creaton has not 100% completed.
//If Upper(lsFileExt) = '.DAT'  or upper(lsFileExt) = '.TXT' or upper(lsFileExt) = '.CSV' Then
//GXMOR 08/17/2012 added .XML to GI files to allow XML files to created before processing
If Upper(lsFileExt) = '.DAT'  or upper(lsFileExt) = '.TXT' Then
	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
//Jxlim 04/23/2012 Pandora BOH files	.csv
ElseIf  Upper(lsFileExt) = '.CSV' and lsFilePre = 'BOH' Then
	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
ElseIf Upper(lsFileExt) = '.XML' and Left(lsFilePre,2) = 'GI' Then
	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
//30-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Orders	
ElseIf Upper(lsFileExt) = '.CSV' and upper(lsFilePre) = 'INV' Then
	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
ElseIf Upper(lsFileExt) = '.CSV' and upper(lsFilePre) = 'CYC' Then
	lsRemoteFile = left(asRemoteFile, len(asRemoteFile) - 4) + '.TMP'
Else
	lsRemoteFile = asRemoteFile
End If

bRet =this.FtpPutFile(il_hConnection,asFileName,lsRemoteFile,aiTransferMode,ll_dwcontext) /* 03/04 - Mode passed in: 0-default, 1=ASCII */

If Not bret Then
	//lsLogOut = Space(10) + "***** Unable to upload file: " + asFileName + ' to remote server!. '
	lsLogOut = Space(10) + "***** Unable to upload file: " + lsRemoteFile + ' to remote server!. '
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_Log(lsLogOut)
	//uf_send_email('','Filexfer'," - ***** Unable to upload to FTP Server",lsLogOut,'') /*send an email msg to the file transfer error list*/
	Return -1
Else
//	lsLogOut = Space(10) + "File: " + asFileName + " was successfully uploaded to remote server."
	lsLogOut = Space(10) + "File: " + lsRemoteFile + " was successfully uploaded to remote server."
	If aitransfermode = 1 Then
		lsLogOut += " (ASCII MODE) "
	End If
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_Log(lsLogOut)

	//dts - 10/05/05 - add rename functionality at the end of Put step
	// 12/10 - PFC - Always renaming from .TMP for all extensions
	if upper(right(lsRemoteFile, 4)) = '.TMP' then
		//lsNewRemoteFile = left(lsRemoteFile, len(lsRemoteFile) - 4) + '.DAT'
		lsNewRemoteFile = left(lsRemoteFile, len(lsRemoteFile) - 4) +  lsFileExt
		bRet = this.FtpRenameFile(il_hConnection, lsRemoteFile, lsNewRemoteFile)
		If Not bret Then
			lsLogOut = Space(10) + "***** Unable to Rename file: " + lsRemoteFile + " to " + lsNewRemoteFile
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_Log(lsLogOut)
			//uf_send_email('','Filexfer'," - ***** Unable to upload to FTP Server",lsLogOut,'') /*send an email msg to the file transfer error list*/
			Return -1
		Else
			lsLogOut = Space(10) + "File: " + lsRemoteFile + " was successfully renamed to " + lsNewRemoteFile
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_Log(lsLogOut)
		end if

	end if
End If
	//TimA 12/22/11
	yield()

Return 0
end function

public function integer uf_process_ftp_outbound ();
//This function will move processed files from a directory to the appropriate FTP folder


Integer	liRC, liTransferMode
			
Long		llArrayCount, llArrayPos, llCount, llFolderPos, lul_handle,	llFilePos,	llFileCount

String	lsLogOut, lsDirList,	lsDir[],	lsFiles[], lsCurrentFile, lsSaveFileName,	lsProject,		&
			lsInitArray[],lsPath,lsDirectory,lsTemp, lsCommand, lsTransferMode
			
ulong ll_dwcontext, l_buf, llCrap
boolean lb_currentdir,bRet, lbFTPError
str_win32_find_data str_find

l_buf = 300

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Uploading Outbound FTP Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//Get a list of all Projects to process
lsDirList = ProfileString(gsinifile,'FTPOUTBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/
		
//Process the requested FTP Directories
For llFolderPos = 1 to UpperBound(lsDir) /*For each Folder*/
	//TimA 12/22/11
	yield()

	If lsDir[llFolderPos] = '' Then Continue
	
	lsLogOut = "  Processing FTP files for Project: '" + lsDir[llFolderPos] + "'"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get the project for the current folder from the profileString
	lsProject = ProfileString(gsinifile,lsDir[llFolderPos],"project","")
		
	//Get a list of the files to upload
	lsPath = ProfileString(gsinifile,lsDir[llFolderPos],"ftpfiledirout","")
		
	If isnull(lsPath) or lsPath = '' Then
		lsLogOut = "  No staging directory present - Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	lsLogOut = '      Upload Staging directory: ' + lspath
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	lsFiles = lsInitarray /*reinitialize array*/
	llFilePos = 0
	//lsDirectory = lsPath + '\' +  ProfileString(gsinifile,lsDir[llFolDerPos],"directorymask","")
	lsDirectory = lsPath + '\*.*' /* 12/03 - PCONKL */
	
	lul_handle = FindFirstFile(lsDirectory, str_find)
				
	If lul_handle > 0  Then/*first file found*/ 
		bREt = True
		do While  bret
			// 12/03 - PCONKL - Don't include directories in file listing (str_find.fileattributes = 16)
			If Trim(Str_find.FileName) > ' ' and  Pos(Str_find.FileName,'.') > 0 and &
				Trim(Str_find.FileName) <> '.' and Trim(Str_find.FileName) <> '..' Then
					llFilePos ++
  					lsfiles[llFilePos] = str_find.filename
			End If
			
	 		bret = FindNextFile(lul_handle, str_find)	
		Loop
	End If
	
	If llFilePos = 0 Then /*No files found for processing*/
		lsLogOut = '        No files found to process in directory: ' + lsPath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	End If
	
	llFileCount = UpperBound(lsFiles[])
	
	If llFileCount <= 0 Then Continue //Skip processing if there are no files to Upload
		
	lsLogOut = Space(6) + String(llFileCount) + " Files found in directory for uploading."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	// 03/04 - PCONKL - Check to see if we need to send in ASCII format (AS400, etc.)
	lsTransferMode = ProfileString(gsinifile,lsDir[llFolderPos],"ftptransfermode","")
	If lsTransferMode = "ASCII" Then
		liTransferMode = 1
	Else
		liTransferMode = 0
	End If
	
	//Connect to FTP
	If uf_ftp_connect(lsDir[llFolderPos]) < 0 Then
		lsLogOut = "  Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	//Change directory to Out directory
	If ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryout","") > ' ' Then
		uf_ftp_setDir(ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryout",""))
	End If
		
	//Upload Each File
	For llFilePos = 1 to llFileCount /*for each file in the FTP Folder*/
		
		lsCurrentFile = lsPath + '\' + lsFiles[llFilePos]
		
		liRC = uf_ftp_upload(lsCurrentFile,lsFiles[llFilePos],liTransferMode) /* 03/04 - PCONKL - added Trans Mode (Binary or ASCII) */
				
		//If uploaded successfully, move file to archive directory
		If liRC = 0 Then
			
			lsSaveFileName = ProfileString(gsinifile,lsDir[llFolDerPos],"archivedirectory","") + '\' + lsFiles[llFilePos] + '.txt'
			
			//Check for existence of the file in the archive directory already - it was probably already saved when written to the flat file in the last step, no need to save twice
			If Not FIleExists(lsSaveFileNAme) Then
							
				bret=MoveFile(lsCurrentFile,lsSaveFileName)
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
				
			Else /* File already exists, delete from output directory so we don't send it again */
				
				bret = DEleteFile(lsCurrentFile)
				If bret Then /*deleted*/
					lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
				Else /*not deleted */
					lsLogOut = Space(10) + "*** Unable to delete Local File (FTP Upload): " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
					
					//Notify the systems list - otherwise we'll keep resending the records
					uf_send_email('XX','System','***SIMSFP - System Error***',lsLogOut,'') /*send an email mesg to the systems distribution list*/
			
					//Reduce the Sweep time to give time to catch before resending			
					w_main.sle_sweep_interval.Text = "3600" /*one hour */
					w_main.sle_sweep_interval.TriggerEvent("Modified")
					
				End If
				
			End If /*file doesn't already exist*/
			
		Else /* NOt uploaded successfully*/
						
			lbFTPError = True /* At the end, if we've had upload errors, we'll increment the error count. We want the count to be per instance of error, not count of files */
			
		End If /*sucessfully uploaded to FTP */
				
	Next /*Next file to upload from current staging Folder */
	
	//Logout of Current FTP server
	uf_ftp_disconnect()
	
Next /* Next FTP Folder to process*/

//Make damn sure we're logged out!
uf_ftp_disconnect()

//Close the internet connection if Open - hopefully, clear cache
If il_hopen > 0 Then
	InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
End If

// 03/04 - PCONKL - If we have too many uplaod errors, we need to restart the sweeper
If lbFTPError Then
	ilFTPUploadAttempts ++ /* we'll Restart if we hit a certain point*/
	uf_send_email('','Filexfer'," - ***** Unable to upload to FTP Server","Errors wre encountered uploading FTP files. See log file for more details",'') /*send an email msg to the file transfer error list*/
End If

Return 0
end function

public function integer uf_ftp_connect (string asfunction);ulong ll_null
ulong ll_dwcontext
boolean lb_currentdir,bRet
string ls_null,ls_password,ls_username,ls_servername, lsLogOut
string ls_curdir,ls_local, lsPort
ulong l_buf, ll_hConnection, llErrorCode,llPort

ls_serverName = ProfileString(gsinifile,asFunction,"ftpserver","")
ls_username = ProfileString(gsinifile,asFunction,"ftpuserid","")
ls_password = ProfileString(gsinifile,asFunction,"ftppassword","")

// 03/04 - PCONKL - We may be connecting to a port other than the default*/
lsPort = ProfileString(gsinifile,asFunction,"ftpport","") /* 03/04 - PCONKL */
If isnull(lsPOrt) or lsPort = '' or Not isnumber(lsPOrt) Then
	llPOrt = 0
Else
	llPOrt = Long(lsPort)
End IF


SetNull(il_hConnection)  /* reset connection - it appears that sometimes it is never discconecting*/

lsLogOut =  '      Connecting to FTP Server: ' + ls_serverName + ' as: ' + ls_username
If llPOrt <> 0 Then lsLogOut += ", Port= " + String(llPort)

uf_write_log(lsLogOut) /*write to Screen*/
FileWrite(gilogFileNo,lsLogOut)

//Only need to connect once
IF Il_hopen = 0 or isnull(Il_hopen) THEN
	
	Il_hopen=this.internetOpen(ls_null,0,ls_null,ls_null,0)

	IF Il_hopen = 0 or isnull(Il_hopen) THEN
		lsLogOut =  " - ***** Unable to open FTP Connection."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		uf_send_email(asfunction,'Filexfer'," - ***** Unable to open FTP Connection",lsLogOut,'') /*send an email msg to the file transfer error list*/
		Return -1
	Else
		lsLogOut =  '        Internet Connection Opened. Handle = ' + String(il_hopen)
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
	End IF
	
End If

il_hConnection=this.InternetConnect(Il_hopen, ls_servername, llPort, ls_username, ls_password,1,67108864,ll_dwcontext) /* 67108864 = No Cache */
//il_hConnection=this.InternetConnect(Il_hopen, ls_servername, 0, ls_username, ls_password,1,2214592512,ll_dwcontext) /* 2147483648 = internet flag reload, 67108864 = No Cache */

IF il_hConnection = 0 or isnull(il_hConnection) THEN
	lsLogOut =  " - ***** Unable to connect to FTP Server. " 
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	uf_send_email(asfunction,'Filexfer'," - ***** Unable to connect to FTP Server",lsLogOut,'') /*send an email msg to the file transfer error list*/
	Return -1
Else
	lsLogOut =  '        Connected to Server. Handle = ' + String(il_hConnection)
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
End IF	
	//TimA 12/22/11
	yield()

Return 0
end function

public function integer uf_check_restart ();
String	lsNextRestartDate, lsNextReStartTime, lsRestartFreq, lsOutput
DateTime	ldtNextRestartTIme
Date	ldNextRestart
Long	llFTPErrorThresh
lbrestartrequested = False

lsNextRestartDate = ProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTDATE','')
lsNextReStartTime = ProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTTIME','')
llFTPErrorThresh = Long(ProfileString(gsIniFile,'SIMS3FP','FTPERRORTHRESHOLD',''))

// we'll restart if we hit a certain threshold of FTP Upload Errors
If llFTPErrorThresh > 0 Then
	
	If ilftpuploadattempts > llFTPErrorThresh Then
		
		lbrestartrequested = True
		
		lsOutput = ''
		FileWrite(giLogFileNo,lsOutput)
		lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + '*** - FTP Upload Error Threshold exceeded. Restart Requested'
		FileWrite(giLogFileNo,lsOutput)
		uf_send_email('','Filexfer'," *** - FTP Upload Error Threshold exceeded. Restart Requested",'','') /*send an email msg to the file transfer error list*/
		uf_write_Log(lsOutPut) /*display msg to screen*/
		
		Return 0
		
	End If
	
End If

//Check for Timed restart
If trim(lsNextRestartDate) = '' or trim(lsNextReStartTime) = '' or (not isdate(string(Date(lsNextRestartDate)))) or (not isTime(string(Time(lsNextReStartTime)))) Then /*not scheduled to restart*/
	Return 0
Else /*valid date*/
	ldtNextRestartTIme = DateTime(Date(lsNextRestartDate),Time(lsNextReStartTime))
	If ldtNextRestartTIme > dateTime(today(),now()) Then /*not yet time to run*/
		Return 0
	End If
End If


//Time for a restart
lsOutput = ''
FileWrite(giLogFileNo,lsOutput)
lsOutput = String(Today(), "mm/dd/yyyy hh:mm") + ' - Scheduled restart requested.'
FileWrite(giLogFileNo,lsOutput)
uf_write_Log(lsOutPut) /*display msg to screen*/

//set 'RESTARTING' ini setting so we don't get the start-up message
SetProfileString(gsIniFile,'SIMS3FP','RESTARTING','Y')

//Set the Next restart time
lsRestartFreq = ProfileString(gsIniFile,'SIMS3FP','RESTARTFREQ','')
If isnumber(lsRestartFreq) Then
	ldNextRestart = relativeDate(today(),Long(lsRestartFreq)) /*relative based on today*/
	SetProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTDATE',String(ldNextRestart,'mm-dd-yyyy'))
Else
	SetProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTDATE','')
End If

lbrestartrequested = True
lbRestartScheduled = False

Return 0
end function

public function integer uf_process_transaction_file ();
// 03/04 - PCONKL - Read the transaction file for confirmation requests created on the SIMS client and write the appropriate
//Confirmation message

u_nvo_edi_confirmations	lu_edi_confirm
Datastore	ldsTransFile
Long	llTranCount, llTranPos, llRC, llOrderID, llTransID
String	lsOrderID, lsProject, lsTranType, lsLogOut, lsStatus, lsTrans_parm
DateTime	ldtNow, ldtRecordCreateDate
Integer	liErrCount
String lsProcessBatch = ''
Boolean lbProcessBatch, lbError
String ls_WhCode, ls_LCode, ls_Sku
Long ll_Bosch_GI_Count

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Client Confirmation Transaction File. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

lu_edi_confirm = Create u_nvo_edi_confirmations

ldstransFile = Create Datastore
ldsTransFile.Dataobject = 'd_batch_transaction' 
ldsTransFile.SetTransObject(SQLCA)


/* MEA - 04/10 - Set the Batch Indicator 
					  Need to process every other sweeper pass */

	
lsProcessBatch = ProfileString(gsinifile,'WARNER',"ProcessBatch","")

/* Reset any BatchSeqNum */

SetProfileString(gsIniFile, 'WARNER', 'CurrentGIBatchSeqNum', '')
SetProfileString(gsIniFile, 'WARNER', 'CurrentGRBatchSeqNum', '')
SetProfileString(gsIniFile, 'WARNER', 'CurrentAdjustBatchSeqNum', '')

SetProfileString(gsIniFile, 'WARNER', 'CurrentPODBatchSeqNum', '')
SetProfileString(gsIniFile, 'WARNER', 'CurrentRTBatchSeqNum', '')
SetProfileString(gsIniFile, 'WARNER', 'CurrentBHBatchSeqNum', '')



IF Trim(lsProcessBatch) = 'Y' THEN  /* Process was run last sweeper cycle, so don't do anything. */

	SetProfileString(gsIniFile, 'WARNER', 'ProcessBatch', 'N')

	lbProcessBatch = false

ELSE

	SetProfileString(gsIniFile, 'WARNER', 'ProcessBatch', 'Y')

	lbProcessBatch = true

END IF
	


//Process each Transaction Record - only records with non complete status will be retrieved
llTranCount = ldsTransFile.Retrieve()

If lltranCount < 0 Then
	lsLogOut = " ***System Error!  Unable to Retrieve transaction records!"
	FileWrite(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut) /*display msg to screen*/
	Return -1
End If

lsLogOut = '   - ' + String(lLTranCount) +  ' Transaction records were retrieved for processing'
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

uf_max_trans_init()		// LTK 20111117	Initialize datastore counter for maximum project transactions
ib_refire_sweeper = FALSE

For llTranPos = 1 to llTranCount
	//TimA 12/22/11
	yield()
	
	lsProject = ldsTransFile.GetITemString(llTranPos,'project_ID')

	//TimA 02/04/14 Added Method trace to outbound logic
	Select Code_id INTO :gs_method_log_flag from lookup_table where Project_ID = :lsProject and Code_type = 'LOG_Trace';
	If isNull(gs_method_log_flag) Then gs_method_log_flag  = 'N'

	// LTK 20111117	Change to prevent project blocking during the transaction sweep.  This is decidedly not the optimal algorithm.  	
	//						However, it is a quick, data driven and somewhat efficient implementation.
	if uf_max_trans_reached(lsProject) then
		ib_refire_sweeper = TRUE					// More transactions queued up, set the refire sweeper flag
		continue
	end if
	
	lsTranType = ldsTransFile.GetITemString(llTranPos,'trans_Type')
	//lsProject = ldsTransFile.GetITemString(llTranPos,'project_ID')		// LTK 20111117	Project blocking sweeper change, now set above
	lsOrderID = ldsTransFile.GetITemString(llTranPos,'trans_order_ID')  //Jxlim 08/01/2013 ariens; trans_order_id is consolidation_no (shipment_ID) 
	lsTrans_parm = ldsTransFile.GetITemString(llTranPos,'trans_parm') 	   //Jxlim 08/01/2013 ariens; trans_parm is dono 
	llTransID = ldsTransFile.GetITemNumber(llTranPos,'trans_ID')  
	ldtRecordCreateDate = ldsTransFile.GetITemDatetime(llTranPos,'Record_Create_Date')

	lsLogOut = '- PROCESSING FUNCTION - uf_process_transaction_file() . - Trans_Id: ' + string(llTransID) + ' - Trans_Type: ' +lsTranType+ ' - SQLCA Code: '+string(sqlca.sqlcode)
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut) /*write to Screen*/

	//09/05 - PCONKL - Re-retrieve the status from the DB to make damn sure it hasn't already been processed.
	Select trans_status into :lsStatus
	from Batch_Transaction with(nolock)
	Where trans_id = :llTransID
	using sqlca;
	
	If lsStatus <> 'N' Then Continue


	//SEPT 2019 - MikeA : S38259 Feature F18585: Change Sweeper to Limit 945s from Site to 10 per Cycle  (Bosch only)

	IF lsProject = 'BOSCH'  AND lsTranType = 'GI' Then
		ll_Bosch_GI_Count = ll_Bosch_GI_Count + 1
				
		IF ll_Bosch_GI_Count > 10 Then Continue

	End IF


	// 04/10 - MEA - Check to see if we should process the batch.

	IF Upper(lsProject) = 'WARNER'  THEN
		
		IF NOT lbProcessBatch THEN

			continue
	
		END IF	
	
	END IF	
	
	Choose Case Upper(lsTranType)
			
		Case 'GR' /* Goods Receipt */
			
			llRC = lu_edi_Confirm.uf_goods_receipt_Confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm )
			
		Case 'GI' /* Goods Issue */
			//TimA 04/24/14 Added lsTrans_parm because the parm was added for Pandora issue #36.  Re-Confirm orders by line numbers
			//TimA 10/15/14 Pandora issue #903 pass the record create date to delay GIR Processing
			//ldtRecordCreateDate = DateTime(Today( ),RelativeTime(Now( ),-71140) ) //Testing 
			lLRC = lu_edi_Confirm.uf_goods_Issue_Confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm, ldtRecordCreateDate )
			
		Case 'GT' /* Marc GT Receipt Transaction Only */
			
			llRC = lu_edi_Confirm.uf_Marc_GT_Receipt_Confirmation(lsProject, lsOrderID, llTransID)
			
		Case 'GS' /* Marc GT Shipment Transaction Only */
			
			llRC = lu_edi_Confirm.uf_Marc_GT_Goods_Issue_Confirmation(lsProject, lsOrderID, llTransID)
			
		Case 'GU' /* Marc GT Stock Adjustment Transaction Only */
			
			llOrderID = Long(lsORderID)
			llRC = lu_edi_Confirm.uf_Marc_GT_Stock_Adjustment(lsProject, llOrderID, llTransID)
			
		Case 'MM' /* Material Movement */
			
			llOrderID = Long(lsORderID)
			lLRC = lu_edi_Confirm.uf_stock_adjustment(lsProject, llOrderID, llTransID)

		Case 'OC' /* Owner Change */
			
			llOrderID = Long(lsORderID)
			//TimA 05/05/14 Pandora issue #36 added lsTrans_parm
			lLRC = lu_edi_Confirm.uf_owner_change_confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm )

		Case 'WO' /* WorkORder COnfirmation */
			
			lLRC = lu_edi_Confirm.uf_workorder_Confirmation(lsProject, lsOrderID, llTransID)
						
// TAM 07/04
		Case 'WA' /* WorkOrder putaway Confirmation */
			
			lLRC = lu_edi_Confirm.uf_wo_putaway_Confirmation(lsProject, lsOrderID, llTransID)
						
// TAM 07/04
		Case 'WX' /* WorkOrder Component Issue */
			
			lLRC = lu_edi_Confirm.uf_wo_components_issue(lsProject, lsOrderID, llTransID)
			
		Case 'RS' /* 09/06 - PCONKL -  Ready To Ship*/
			
			lLRC = lu_edi_Confirm.uf_ready_to_ship_Confirmation(lsProject, lsOrderID, llTransID)
			
		Case 'IM' /* 02/07 - PCONKL - Item Master Update */
			
			lLRC = lu_edi_Confirm.uf_itemMaster_Confirmation(lsProject, llTransID)
						
		Case 'PD' /* 12/09  PCONKL - Proof of delivery Confirmation */
			
			llRC = lu_edi_Confirm.uf_proof_of_delivery_Confirmation(lsProject, lsOrderID, llTransID)
			
		Case 'CC' /* 06/10  dts - Cycle Count confirmation for Pandora */
			
			llRC = lu_edi_Confirm.uf_cycle_count_Confirmation(lsProject, lsOrderID, llTransID)
			
		Case 'SN' /* 06/10  dts - Serial Number Change confirmation for Pandora */
			
			llRC = lu_edi_Confirm.uf_serial_change_Confirmation(lsProject, lsOrderID, llTransID)

		Case 'CI' /* 08/16  dts - Commercial Invoice 3B18 for Pandora */
			//07-Sep-2017 :Madhu PINT-945-CI Added additional parms
			llRC = lu_edi_Confirm.uf_commercial_invoice_confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm, ldtRecordCreateDate)

		//Jxlim 04/06/2011 Added UP trans_type for UPS Load Tender confirmation for Pandora	
		Case 'UP' 
			
			llRC = lu_edi_Confirm.uf_ups_load_tender_confirmation(lsProject, lsOrderID)

	 //MEA 11/2011 Added VD trans_type for Void confirmation for Nike EWMS	
		Case 'VD' 
			
			llRC = lu_edi_Confirm.uf_delivery_void_confirmation(lsProject, lsOrderID, llTransID)

	 //MEA 12/2011 Added PK trans_type for DST (Picking) confirmation for Nike EWMS	
	 
		Case 'PK' 
			
			//Status - "AS" for Picking Type
			
			llRC = lu_edi_Confirm.uf_delivery_dst_confirmation(lsProject, lsOrderID, "AS")

		//GWM 10/2012 Added TH trans Type for Multiple MacId confirmation for Comcast
		Case 'TH'
	
			llRC = lu_edi_Confirm.uf_th_multiMacId_confirmation(lsProject, lsOrderID, llTransID)
			
		//Jxlim 08/01/2013 Added SI trans type for actual shipment confirmation for Ariens
		Case 'SI' /* Actual Shipment */  
			//TimA 04/24/14 Added lsTrans_parm because the parm was added for Pandora issue #36.  Re-Confirm orders by line numbers
			//TimA 10/15/14 Pandora issue #903 pass the record create date to delay GIR Processing
			lLRC = lu_edi_Confirm.uf_goods_Issue_Confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm, ldtRecordCreateDate )
	
		// TAM 2016/04  -  Added a shipment confirmation for Garmin
		Case 'SC' /* Shipment Confirmation */  
			//TimA 04/24/14 Added lsTrans_parm because the parm was added for Pandora issue #36.  Re-Confirm orders by line numbers
			//TimA 10/15/14 Pandora issue #903 pass the record create date to delay GIR Processing
			lLRC = lu_edi_Confirm.uf_shipment_Confirmation(lsProject, lsOrderID, llTransID, lsTrans_parm, ldtRecordCreateDate )
	
		// TAM 2018/08  -  S22532 Added a LWON(Load Lock) for Pandora
		Case 'LWON' /* Shipment Confirmation */  
			lLRC = lu_edi_Confirm.uf_lwon(lsProject, lsOrderID, llTransID, lsTrans_parm, ldtRecordCreateDate )
		
		//15-FEB-2019 :Madhu S29511 -PhilipsCLS BlueHeart OutboundDeliveryUpdateStatus	
		Case 'RD','SD'
			llRC = lu_edi_confirm.uf_rd_sd_change_confirmation( lsProject, lsTranType, lsOrderID)

		Case 'ES' //Event Status
			//TAM 2019/02/28 - S29919 - PhilipsBH_OutboundShipmentStatusUpdate 
			llRC = lu_edi_confirm.uf_event_status( lsProject, lsTranType, lsOrderID, lsTrans_parm)  
			
		Case 'VR' //13-MAY-2019 :Madhu S31437 -F14849 - Philips Customer Return Finish Cancellation
			llRC = lu_edi_confirm.uf_receipt_void_confirmation( lsProject, lsOrderID, llTransID, lsTrans_parm )

		Case 'SRCC' //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
			
			//Position in Trans Parm
			//WH_Code = 1-10
			//L_Code = 12-21
			//Sku = 23 -
				
			ls_WhCode = mid(lsTrans_parm, 1, 10)
			ls_LCode = mid( lsTrans_parm, 12, 10)
			ls_Sku = mid(lsTrans_parm , 23)
			
			llRC = uf_create_system_serial_reconciliation( lsProject, ls_WhCode, ls_LCode, ls_Sku )

			
			
		Case Else /*Invalid Trans Type*/
			
			lsLogOut = "      ***Invalid Transaction Type: '" + lsTranType + "'. Record will not be processed!"
			FileWrite(gilogFileNo,lsLogOut)
			uf_write_Log(lsLogOut) /*display msg to screen*/
			llRC = -1
			
	End Choose
	
	//If the transaction was successfull, update the status and complete date
	//08/05 - we need to save and commit to DB after each record in case we crap out before all records are processed

	// pvh - 12/04/06 - MARL
	// The marl adjustment record must wait 30 minutes..I've added a new return code
	// to handle transactions that need to wait.
	
	// 04/10 - PCONKL - Add error trapping for Commit and retry logic
	liErrCount = 0
	Do While liErrCount < 4
		
		choose case llRC
			
			case 1
			
				liErrCount = 999 /*No errors,get out */
				continue // do nothing

			case 2 //TimA 10/15/14 This return code was for skipping Pandora 3b13 GIR process for a cirtain amount of time.
					//Check u_nvo_edi_confirmations_Pandora.uf_gi_rose for more information
				//Return 0					// LTK 20160205  Changed this return to a Continue so the rest of the transactions 
												// would process after this condition was encountered
				liErrCount = 999
				Continue	
			case 0
			
				// 
				ldtNow = DateTime(Today(),Now())
			//Sarun2014Mar20 : Record FileName to publish in batch_transaction Table
				Update Batch_transaction
				Set trans_status = 'C', Trans_Complete_Date = :ldtNow,filename=:gsFileName
				Where trans_ID = :llTransID
				Using SQLCA;
			
				IF Sqlca.Sqlcode = 0 THEN
				
					Commit using SQLCA;	
				
					IF Sqlca.Sqlcode = 0 THEN
						liErrCount = 999 /*No errors,get out */
					Else
						
						liErrCount ++
						
						lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
						FileWrite(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
						
						Rollback using SQLCA;
						
					End IF
				
				Else
				
					liErrCount ++
				
					lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
					FileWrite(gilogFileNo,lsLogOut)
					uf_write_Log(lsLogOut) /*display msg to screen*/
				
					rollback using SQLCA;
					
				End If
			
			case 99
			
				Delete from Batch_Transaction 
				Where trans_ID = :llTransID
				Using SQLCA;
		
				IF Sqlca.Sqlcode = 0 THEN
				
					Commit using SQLCA;	
				
					IF Sqlca.Sqlcode = 0 THEN
						liErrCount = 999 /*No errors,get out */
					Else
						
						liErrCount ++
						
						lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
						FileWrite(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
						
						Rollback using SQLCA;
						
					End IF
				
				Else
				
					liErrCount ++
				
					lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
					FileWrite(gilogFileNo,lsLogOut)
					uf_write_Log(lsLogOut) /*display msg to screen*/
				
					rollback using SQLCA;
					
				End If
		
			case is < 0
			
				Update Batch_transaction
				Set trans_status = 'E'
				Where trans_ID = :llTransID Using SQLCA;
		
				IF Sqlca.Sqlcode = 0 THEN
				
					Commit using SQLCA;	
				
					IF Sqlca.Sqlcode = 0 THEN
						liErrCount = 999 /*No errors,get out */
					Else
						
						liErrCount ++
						
						lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
						FileWrite(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
						
						Rollback using SQLCA;
						
					End IF
				
				Else
				
					liErrCount ++
				
					lsLogOut = "      ***Unable to update status on Transaction ID: " + String(llTransID) + ". ErrorText: " + sqlca.SQLErrText + " attempt: " + String(liErrCount)
					FileWrite(gilogFileNo,lsLogOut)
					uf_write_Log(lsLogOut) /*display msg to screen*/
				
					rollback using SQLCA;
					
				End If
			
		end choose
	
		if liErrCount = 3 Then lbError = True
		
	Loop /* Error COunt */
	
	//If we have an error, notify the Syster Error DL...
	IF lbError THEN
		uf_send_email('XX','System','***SIMSFP - System Error***',"Unable to save/Commit Batch Transaction Record: " +  + String(llTransID) + ". See log file for more information " ,'') /*send an email mesg to the systems distribution list*/
	End If
	
Next /*Transaction record */
	//TimA 12/22/11
	yield()

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = "    Transaction file successfully processed! "
FileWrite(gilogFileNo,lsLogOut)
uf_write_Log(lsLogOut) /*display msg to screen*/

DEstroy lu_edi_confirm 

Return 0

end function

public function integer uf_change_log ();String	lsLogName

//If we already have a log open, close it
If giLogFileNo > 0 Then
	FileClose(giLogFileNo)
End If

//Open Log File
lsLogName =  ProfileString(gsinifile,"sims3FP","LogDirectory","") + '\SIMS3FP' + string(now(),'yyyymmddhhmm') + '.log' /*Create a new log file everytime we run with date/time stamp*/
giLogFileNo = FileOPen(lsLogName,LineMode!,Write!,Shared!)

uf_write_Log('Opening Log File: ' + lsLogName)

isEmailLogFile = ProfileString(gsinifile,"sims3FP","LogDirectory","") + '\SIMS3FP-EMAIL-' + string(now(),'yyyymmddhhmm') + '.log' /*Create a new Email log file everytime we run with date/time stamp*/

idtLogChangeDate = today() /*we'll want to change the log file once a day*/

Return 0
end function

public function integer uf_check_db_connection ();Long	llCOunt
String	lsOutput

//Test for DB Connection. If not connected, try reconnecting

//Do a dummy select and check return Code

lsOutput = ''
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

lsOutput = String(Today(), "mm/dd/yyyy hh:mm:ss") + ' - Checking DB connection...'
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

Select Count(*) into :llCount
from websphere_settings
//from edi_generic_outbound 
//Where project_id = '3com_NASH'
Using SQLCA;

If sqlca.SQLCode < 0 Then /* We're probably not connected - try reconnecting*/

	// 05/13 - PCONKL - Instead of disconnecting and reconnecting, we will do a restart. If initial connection fails, it will halt anyway

	//Disconnect;
	
//	lsOutput = '** Connection to database was lost. Attempting to Re-Connect to database: ' + sqlca.servername + '\' + sqlca.database
	lsOutput = '** Connection to database was lost. Error Code/Msg: ' + string(sqlca.SQLCode) + '/' + sqlca.sqlerrtext
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	
	//Send a system email
	uf_send_email('XX','System','***SIMSFP - Database connection lost ***',lsOutput,'') /*send an email mesg to the systems distribution list*/
	
	lsOutput = '** a scheduled restart will be requested **'
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	
	Return -1
	
//	connect using sqlca;
//
//	IF sqlca.sqlcode <> 0 THEN
//		lsOutput = '** Unable to Re-connect to Database: ' + sqlca.sqlerrtext
//		FileWrite(gilogFileNo,lsOutput)
//		uf_write_Log(lsOutput) /*display msg to screen*/
//		Return -1
//	Else
//		lsOutput = '- Connection successfully re-established to database: ' + sqlca.servername + '\' + sqlca.database
//		FileWrite(gilogFileNo,lsOutput)
//		uf_write_Log(lsOutput) /*display msg to screen*/
//	END IF
//
//	//Need to set the Ansi warnings off
//
//	EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING SQLCA;
//


End If

lsOutput = 'Successfully connected to Database...'
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/
	
	//TimA 12/22/11
	yield()

//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -START
String sql_syntax,lserrors
Datastore ldssweeper
long llrowcount, il_row,ll_WaitTime

ldssweeper = CREATE Datastore
sql_syntax ="SELECT * FROM Sweeper_Running_Status with (nolock) where Sweeper_Name='"+gsEnvironment+"' and Sweeper_Shutdown='N'";
ldssweeper.Create(SQLCA.syntaxfromsql(sql_syntax ,"", lsErrors) )

If len(lsErrors) > 0 Then
	return -1
else
	ldssweeper.setTransobject( SQLCA);
	llrowcount=ldssweeper.retrieve( );
end if

	If ( llrowcount > 0 and ll_WaitTime=0) Then
			//write to Log
			lsOutput ='Following Sweeper: ' +gsEnvironment+ ' is running  and Sweeper_Shutdown = N in db'
			FileWrite(gilogFileNo,lsOutput)
			uf_write_Log(lsOutput)
	END IF
destroy ldssweeper
//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -END

Return 0
end function

public function integer uf_main_file_driver ();//This is the main file driver - this process will be called everytime we 'wake up' - triggered by timer event and uf_open
//ET3 05-Apr-2012: setting WaitTime = 0 disables frequent check 
//ET3 07-May-2012: change order of calls so that stuck files check occurs after all other processing

String	lsAction,	&
			lsOutput,	&
			lsDAilyProc
			
Long		llRC,	&
			llArrayPos,	&
			llLogRow,	&
			llSweepTime
Long 		ll_WaitTime
DateTime ldtLastRunTime

//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -START
Datastore ldssweeper 
string sql_syntax,lsErrors
long llrowcount
//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -END

Yield() /*check for any stop commands*/
If gbhalt Then /*set in log window*/
	uf_close()
End If

/////////////////////////////////////////////////////////////////////

gbReady = False /*we dont want the timer to kick off another instance of this function while this is still running*/

// 08/05 - PCONKL - We want to make sure the log file is changed once a day - easiest to do when date changes
If day(today()) <> day(idtlogchangedate) Then
	uf_change_log()
End If

lsOutput = ''
FileWrite(giLogFileNo,lsOutPut)
uf_write_Log(lsOutput) /*display msg to screen*/
lsOutput = String(Today(), "mm/dd/yyyy hh:mm:ss") + ' - Alive and Kicking!'
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/
lsOutput = ''
FileWrite(giLogFileNo,lsOutPut)
uf_write_Log(lsOutput) /*display msg to screen*/

// 05/13 - PCONKL - Moved connection check from below...
llRC = uf_check_db_connection()
If llRC < 0 Then
	 lbrestartrequested  = True
	uf_close()
End If

//SARUN2013Feb07: Updating Sweeper_Running_Status table to latest date and time.
//SARUN2013Nov26: Modified the case statement to catch the new pandora sweeper too 
Choose Case gsEnvironment
                Case "Inbound/PROD","Inbound/PANDORA"
                                Update Sweeper_Running_Status set Last_Update = GETDATE() where Sweeper_Name = 'INBOUND';
                Case "Out-PROD","Out-PANDORA"
                                Update Sweeper_Running_Status set Last_Update = GETDATE() where Sweeper_Name = 'OUTBOUND';
                Case "Sch-PROD","SCHD-PANDORA"
                                Update Sweeper_Running_Status set Last_Update = GETDATE() where Sweeper_Name = 'SCHEDULAR';
               //Case else
                //                Update Sweeper_Running_Status set Last_Update = GETDATE(); //06-Jun-2014 :Madhu- As suggested by Pete/Dave -commented 
End Choose                                                         

commit;

lsOutPut = "Updated Sweeper Running Status " 
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/
lsOutput = ''
FileWrite(giLogFileNo,lsOutPut)
uf_write_Log(lsOutput) /*display msg to screen*/

//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -START
ldssweeper = CREATE Datastore
sql_syntax ="SELECT * FROM Sweeper_Running_Status with (nolock) where Sweeper_Name='"+gsEnvironment+"' and Sweeper_Shutdown='Y'";
ldssweeper.Create(SQLCA.syntaxfromsql(sql_syntax ,"", lsErrors) )

If len(lsErrors) > 0 Then
	return -1
else
	ldssweeper.setTransobject( SQLCA);
	llrowcount=ldssweeper.retrieve( );
end if

	If ( llrowcount > 0  and ll_WaitTime=0) Then
			//set Sweeper Flag to zero
			UPDATE Sweeper_Running_Status set Sweeper_Shutdown='N' where Sweeper_Name =:gsEnvironment using sqlca;
			
			//write to Log
			lsOutput ='Following Sweeper: ' +gsEnvironment+ ' is going to be Shutdown and set Sweeper_Shutdown = N in Sweeper_Running_Status table'
			FileWrite(gilogFileNo,lsOutput)
			uf_write_Log(lsOutput)

			uf_close() // shutdown the sweeper
	END IF

destroy ldssweeper
//14-May-2014 :Madhu- Added code for Auto-Start/Shutoff sweepers -END

////We dont want to connect/disconnect each loop due to resources but we want to ensure that we are connected to the DB
////We'll try to connect 3 times before we end the job and email support

// 05/13 - PCONKL - Moved above and also instead of reconnecting, we will request a scheduled restart

//
//llRC = uf_check_db_connection()
//
//If llRC < 0 Then
//	ilDBConnectAttempts ++
//	If ilDBConnectAttempts > 2 Then
//		//lsOutput = '*** Unable to re-connect to Database after 3 attempts. Application is being terminated'
//		lsOutput = '*** Unable to re-connect to Database after 3 attempts.'
//		FileWrite(gilogFileNo,lsOutput)
//		uf_write_Log(lsOutput) /*display msg to screen*/
//		uf_send_email('XX','System','***SIMSFP - System Error***',lsOutput,'') /*send an email mesg to the systems distribution list*/
//		//uf_close() /* 05/04 - PCONKL - Keep alive... */
//	End If
//	gbReady = True
//	Return -1
//Else
//	ilDBConnectAttempts = 0
//End If

//
// pvh gmt 12/27/05
//
// We want to set the daylight savings time automagically once a year
//
if month( today() ) = 1 and day( today() ) = 1 then
	if NOT isValid( dstUtil ) then dstUtil = CREATE u_nvo_dst_setdates
	if dstUtil.getLastRunDate() <> today() then
		dstUtil.setDates( )
		dstUtil.setLastRunDate()
	end if
end if
// pvh gmt eom

lsAction = ProfileString(gsinifile,"sims3FP","PROCESSFUNCTIONS","")

//Process functions each time through

//04/05 - PCONKL - added call to FTP Out at beginning with parm to different directory listing.
//This will allow us to delay files for a sweep if necessary.

If Pos(lsAction,'FIRSTFTPOUT') > 0 Then /*Process (Send) all outbound FTP files generated during last cycle- these files have been delayed a sweep*/
	lsOutput = '*** Process First FTP Out.'
	uf_write_Log(lsOutput) /*display msg to screen*/
//TimA 12/22/11
yield()
	llRC = uf_process_ftp_outbound("FIRSTFTPOUTBOUND") 
End If

// FTP files are moved to a flat file directory and will be actually processed in the INFLAT process below
If Pos(lsAction,'INFTP') > 0 Then /*Process all incoming FTP Orders*/
	lsOutput = '*** Process IN FTP.'
	uf_write_Log(lsOutput) /*display msg to screen*/

	//TimA 12/22/11
	yield()
	llRC = uf_process_ftp_inbound()
End If
	
If Pos(lsAction,'INFLAT') > 0 Then /*Process all incoming Flat Files - including FTP files retreived above*/
	lsOutput = '*** Process IN Flat.'
	uf_write_Log(lsOutput) /*display msg to screen*/

	//TimA 12/22/11
	yield()
	llRC = uf_process_flatfile_inbound()
End If

//30-MAY-2017 :Madhu -PINT - Pull Orders from Oracle DB -START
If Pos(lsAction, 'INFROMOM') > 0 Then
	yield()
	llRC = uf_process_om_inbound()
End If
//30-MAY-2017 :Madhu -PINT - Pull Orders from Oracle DB -END

If Pos(lsAction,'INXML') > 0 Then /*Process all incoming XML Files*/
	lsOutput = '*** Process In XML.'
	uf_write_Log(lsOutput) /*display msg to screen*/

	//TimA 12/22/11
	yield()
	llRC = uf_process_xml_inbound()
End If
	
// 03/04 - PCONKL - Process any confirmations generated by the transaction file
If Pos(lsAction,'TRANSFILE') > 0 Then 
//TimA 12/22/11
yield()	
	llRC = uf_process_transaction_file()
End If

If Pos(lsAction,'OUTFLAT') > 0 Then /*process outbound Flat Files*/
//TimA 12/22/11
yield()
	llRC = uf_process_flatfile_outbound()
End If

// FTP files are generated in OUTFLAT above and moved to the FTP staging directories. This step moves these files to 
// the Appropriate FTP server as determined by the .ini file entries

If Pos(lsAction,'OUTFTP') > 0 Then /*Process all outbound FTP files generated during this cycle*/
//TimA 12/22/11
yield()
	llRC = uf_process_ftp_outbound("FTPOUTBOUND") /* 04/05 - PCONKL - added parm so we can call function at beginning of sweep with a different set of directories to process*/
End If

If Pos(lsAction,'OUTEMAIL') > 0 Then /* 07/04 - PCONKL - Process all outbound Email files*/
//TimA 12/22/11
yield()
	llRC = uf_process_email_outbound()
End If

//process any daily files
If Pos(lsAction,'DAILYFILES') > 0 Then
	//TimA 12/22/11
	yield()
	lsDailyProc = ProfileString(gsinifile,"sims3FP","DAILYFUNCTIONS","")
	llRC = uf_process_daily_files(lsDAilyProc)
End If

//process any Scheduled Reports
If Pos(lsAction,'SCHEDULER') > 0 Then
	//TimA 12/22/11
	yield()
	llRC = uf_process_scheduled_activity()
End If

//process Monthly Transactions
If Pos(lsAction,'MONTHLYTRANS') > 0 Then
	//TimA 12/22/11
	yield()
	llRC = uf_monthly_transactions()
End If

//Validate Batch Transactions
If Pos(lsAction,'ValidateBatchTrans') > 0 Then
	//TimA 12/22/11
	yield()
	llRC = uf_validate_batch_transactions()
End If

// End of functions

//BCR 16-MAR-2012: FTPCHECKER Code Block.
//If LastRunTime plus WaitTime is greater than NOW, run again; and then reset LastRunTime. Else, skip.
ldtLastRunTime = DateTime(ProfileString(gsinifile,"FTPCHECKER","LastRunTime",""))
ll_WaitTime    = Long(ProfileString(gsinifile,"FTPCHECKER","WaitTime",""))

//Compare run times today. 
//ET 05-Apr-2012: setting WaitTime = 0 disables this 
IF (date(ldtLastRunTime) <> Today()) OR ( (ll_WaitTime <> 0) AND (RelativeTime(time(ldtLastRunTime), ll_WaitTime) <= Now()) ) THEN
	yield()
	llRC = uf_process_ftp_stuck_files("FTPOUTBOUND")
	//Reset LastRunTime.
	SetProfileString(gsIniFile,'FTPCHECKER','LastRunTime',string(dateTime(today(),now())))
	
END IF

Yield() /*check for any stop commands*/
If gbhalt Then /*set in log window*/
	uf_close()
End If

//We may stop and re-start based on a given schedule or due to errors encountered
If lbRestartScheduled =False Then this.uf_schedule_sweeper_restart( ) //14-Dec-2017 :Madhu Added to Schedule to Auto- Restart

uf_check_Restart()
If lbrestartrequested  Then
	uf_close()
End If

// 05/13 - PCONKL - added a connection check at end of Sweep as well
llRC = uf_check_db_connection()
If llRC < 0 Then
	 lbrestartrequested  = True
	uf_close()
End If

gbReady = True /* timer can kick off another instance anytime*/

lsOutput = ''
FileWrite(giLogFileNo,lsOutPut)
uf_write_Log(lsOutput) /*display msg to screen*/
lsOutput = String(Today(), "mm/dd/yyyy hh:mm:ss") + ' - Waiting...'
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

// LTK 20111117	If more transactions are queued up, return a 1 to the caller in order to refire the sweeper immediately.
// Return 0
if ib_refire_sweeper then
	Return 1
else
	Return 0
end if

end function

public function integer uf_process_email_outbound ();
// 07/04 - PCONKL
//This function will email processed files from a directory to the appropriate Dist List


Integer	liRC, liTransferMode
			
Long		llArrayCount, llArrayPos, llCount, llFolderPos, lul_handle,	llFilePos,	llFileCount

String	lsLogOut, lsDirList,	lsDir[],	lsFiles[], lsCurrentFile, lsSaveFileName,	lsProject,		&
			lsInitArray[],lsPath,lsDirectory,lsTemp, lsCommand, lsTransferMode
			
ulong ll_dwcontext, l_buf, llCrap
boolean lb_currentdir,bRet, lbEmailError
str_win32_find_data str_find

l_buf = 300

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Email Outbound Files. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//Get a list of all Projects to process
lsDirList = ProfileString(gsinifile,'EMAILOUTBOUND',"directorylist","")

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/
		
//Process the requested EMAIL Directories
For llFolderPos = 1 to UpperBound(lsDir) /*For each Folder*/

	If lsDir[llFolderPos] = '' Then Continue
	
	lsLogOut = "  Processing EMAIL files for Project: '" + lsDir[llFolderPos] + "'"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get the project for the current folder from the profileString
	lsProject = ProfileString(gsinifile,lsDir[llFolderPos],"project","")
		
	//Get a list of the files to upload
	lsPath = ProfileString(gsinifile,lsDir[llFolderPos],"emailfiledirout","")
		
	If isnull(lsPath) or lsPath = '' Then
		lsLogOut = "  No staging directory present - Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	lsLogOut = '      Upload Staging directory: ' + lspath
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	lsFiles = lsInitarray /*reinitialize array*/
	llFilePos = 0
	//lsDirectory = lsPath + '\' +  ProfileString(gsinifile,lsDir[llFolDerPos],"directorymask","")
	lsDirectory = lsPath + '\*.*' /* 12/03 - PCONKL */
	
	lul_handle = FindFirstFile(lsDirectory, str_find)
				
	If lul_handle > 0  Then/*first file found*/ 
		bREt = True
		do While  bret
			// 12/03 - PCONKL - Don't include directories in file listing (str_find.fileattributes = 16)
			If Trim(Str_find.FileName) > ' ' and  Pos(Str_find.FileName,'.') > 0 and &
				Trim(Str_find.FileName) <> '.' and Trim(Str_find.FileName) <> '..' Then
					llFilePos ++
  					lsfiles[llFilePos] = str_find.filename
			End If
			
	 		bret = FindNextFile(lul_handle, str_find)	
		Loop
	End If
	
	If llFilePos = 0 Then /*No files found for processing*/
		lsLogOut = '        No files found to process in directory: ' + lsPath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	End If
	
	llFileCount = UpperBound(lsFiles[])
	
	If llFileCount <= 0 Then Continue //Skip processing if there are no files to Upload
		
	lsLogOut = Space(6) + String(llFileCount) + " Files found in directory for emailing."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
		
		
	//Email Each File
	For llFilePos = 1 to llFileCount /*for each file in the FTP Folder*/
		//TimA 12/22/11
		yield()

		lsCurrentFile = lsPath + '\' + lsFiles[llFilePos]
		
		lirc = uf_send_email(lsProject,'TRANSACTIONEMAIL','XPO Logistics WMS - SIMS Transaction record','   Attached is a SIMS transactional record',lsCurrentFile) 
		
		//If emailed successfully, move file to archive directory
		If liRC = 0 Then
			
			lsSaveFileName = ProfileString(gsinifile,lsDir[llFolDerPos],"archivedirectory","") + '\' + lsFiles[llFilePos] + '.txt'
			
			//Check for existence of the file in the archive directory already - it was probably already saved when written to the flat file in the last step, no need to save twice
			If Not FIleExists(lsSaveFileNAme) Then
							
				bret=MoveFile(lsCurrentFile,lsSaveFileName)
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
				
			Else /* File already exists, delete from output directory so we don't send it again */
				
				bret = DEleteFile(lsCurrentFile)
				If bret Then /*deleted*/
					lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
				Else /*not deleted */
					lsLogOut = Space(10) + "*** Unable to delete Local File (EMAIL Upload): " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
					
					//Notify the systems list - otherwise we'll keep resending the records
					uf_send_email('XX','System','***SIMSFP - System Error***',lsLogOut,'') /*send an email mesg to the systems distribution list*/
			
					//Reduce the Sweep time to give time to catch before resending			
					w_main.sle_sweep_interval.Text = "3600" /*one hour */
					w_main.sle_sweep_interval.TriggerEvent("Modified")
					
				End If
				
			End If /*file doesn't already exist*/
			
		Else /* NOt emailed successfully*/
							
		End If /*sucessfully emailed */
				
	Next /*Next file to email from current staging Folder */
	
Next /* Next EMAIL Folder to process*/

Return 0
end function

public function integer uf_process_workorder (string asproject);// 11/02 - PCONKL - CHg Qty fields to Decimal

Datastore	ldsHeader,	&
				ldsDetail,	&
				ldsWorkorderMaster,	&
				ldsWorkorderDetail
				
Long		llHeaderPos,	& 
			llHeaderCount,	&
			llDetailCount,	&
			llDetailPos,	&
			llRmasterCount,	&
			llRDetailCount,	&
			llRowPos,			&
			llCount,				&
			llLineItem,			&
			llLineNo,			&
			llOwner,				&
			llNewRow,			&
			llBatchSeq,			&
			llNewCount,			&
			llUpdateCount,		&
			llDeleteCount

String	lsProject, lsOrderNo, lsWONO,	lstemp, lsSku,	lsSupplier,	lsHeaderErrorText,	&
			lsDetailErrorText, lsLogOut, lsAllowPOErrors, lsDefCOO, lsUOM, lsComponent_ind, lsSuppOrderNo 

Boolean	lbError,	lbValError, lbDetailErrors

Decimal	ldWONO			
Decimal{5}	ldQty,	ldAllocQty
Integer	liRC

lsLogOut = '          - PROCESSING FUNCTION - Create/Update Inbound Work Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

ldsheader = Create u_ds_datastore
ldsheader.dataobject= 'd_po_header'
ldsheader.SetTransObject(SQLCA)

ldsWorkorderMaster = Create u_ds_datastore
ldsWorkorderMaster.dataobject= 'd_workorder_master_2'
//ldsWorkorderMaster.dataobject= 'd_workorder_master'
ldsWorkorderMaster.SetTransObject(SQLCA)

ldsDetail = Create u_ds_datastore
ldsDetail.dataobject= 'd_po_detail'
ldsDetail.SetTransObject(SQLCA)

ldsWorkorderDetail = Create u_ds_datastore
ldsWorkorderDetail.dataobject= 'd_workorder_detail'
ldsWorkorderDetail.SetTransObject(SQLCA)

//03/03 - PCONKL - for some projects, we will allow a PO to still be created if 1 or more detail lines have errors
//						 Otherwise, we will delete the entire PO  if there are errors.
lsallowPOErrors = ProfileString(gsinifile,asProject,"allowpoerrors","")
If isNull(lsAllowPOErrors) or lsAllowPOErrors = '' or lsAllowPOErrors <> 'Y' Then lsAllowPOErrors = 'N'

//Retrieve the EDI Header and Detail based on the batch seq no
//10-Sep-2017 :Madhu PEVS-818 - Added "Project" as retrieval arg
llHeaderCount = ldsHeader.Retrieve(asproject) /* all records with a new status will be retrieved*/

lsLogOut = '              ' + string(llHeaderCount) + ' Inbound WO Headers were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//If llHeaderCount <=0 Then Return 0
If llHeaderCount =0 Then
	Return 0
ElseIf llHeaderCount < 0 Then /* 11/03 - PCONKL */
	uf_send_email("",'Filexfer'," - ***** Uf_Process_WorkOrder - Unable to read EDI Records!","Unable to read Inbound EDI Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//Process Each EDI Header Record
For llHeaderPos = 1 to llHeaderCount
	//TimA 12/22/11
	yield()

	//Retrieve any existing WorkOrder Master records for this EDI header - we may have multiple WorkOrder records for the same Order Number (partial receipts)
	//When updating a header or detail, we should only be upating the open one (status not complete) - they will be sorted so that the most recent is the last row in the DW
	
	lsProject = ldsHeader.GetItemString(llHeaderPos,'project_id')
	lsOrderNo = ldsHeader.GetItemString(llHeaderPos,'order_no')
	lsSupplier = ldsheader.GetItemString(llheaderPos,'supp_code')
	llBatchSeq = ldsHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
	lsSuppOrderNo = ldsHeader.GetItemString(llHeaderPos,'supp_order_no')//BCR 20-OCT-2011
	
	llRmasterCount = ldsWorkorderMaster.Retrieve(lsProject, lsOrderNo)
	
	lsHeaderErrorText = ''
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
	
	//Validate action cd
	If ldsHeader.GetITemString(llHeaderPos,'action_cd') = 'A' /* add a new PO */ Then
		
		If llRMasterCount > 0 Then /* record already exists, can't add*/
			uf_writeError("Order Nbr (PO Header) " + string(lsOrderNo) + " - Order Already Exists and action code is 'Add'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order Already Exists and action code is 'Add'"
		Elseif llrMasterCount = 0 Then /*insert a new row for the new record*/
			llNewRow=ldsWorkorderMaster.InsertRow(0)
			sqlca.sp_next_avail_seq_no(lsproject,"WorkOrder_Master","WO_NO" ,ldWONO)//get the next available WO_NO
			lsWONO = lsProject + String(Long(ldWONO),"0000000") /* 10/05 - TAM - pad too 7 zeros to avaoid having receive master and Workorder master with same internal number*/
			ldsWorkorderMaster.SetItem(llNewRow,'WO_NO',lsWONO)
			ldsWorkorderMaster.SetItem(llNewRow,'project_id',lsProject)
//			ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsOrderNo)
			//BCR 20-OCT-2011: Riverbed uses Del Inv Nbr. Don't know why it is commented out above. So I will code it for Riverbed ONLY...
			IF Upper(asproject) = 'RIVERBED' THEN 
				ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsSuppOrderNo)
			END IF
			//End
			ldsWorkorderMaster.SetItem(llNewRow,'Workorder_Number',lsOrderNo)
			ldsWorkorderMaster.SetItem(llNewRow,'last_update',Today())
			ldsWorkorderMaster.SetItem(llNewRow,'last_user','SIMSFP')
//TAM 06/04/2012 - If Riverbed Set Order Date to Local Time
			IF Upper(asproject) = 'RIVERBED' THEN 
				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',f_getLocalWorldTime(ldsHeader.GetITemString(llHeaderPos,'wh_code')))
			else
				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
			end if
//			ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())

			ldsWorkorderMaster.SetItem(llNewRow,'ord_status','N')
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Work Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Work Order Record"
		End If
		
	ElseIf ldsHeader.GetITemString(llHeaderPos,'action_cd') = 'U' Then /*update*/
		
		If llRMAsterCount <=0 Then
			uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " Order does not exist and action code is 'Update'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order does not exist and action code is 'Update'"
		End If
		/* dts (6/16/04) For K&N (and All?) Update when no order exists...
		This is Failing the condition because lbError is true, causing Sweeper 
		to crash below when it does a GetItemString for row 0 (since ldsWorkorderMaster.RecordCount=0)
		Commented out the lbError part of condition - still not inserting Order, but not crashing either.
		*/

		//If we dont have an open PO, create a new one!
		If ldsWorkorderMaster.Find("Ord_status = 'N'",1,ldsWorkorderMaster.RowCount()) = 0 and &
			ldsWorkorderMaster.Find("Ord_status = 'P'",1,ldsWorkorderMaster.RowCount()) = 0 then //and (not lbError) Then
				llNewRow=ldsWorkorderMaster.InsertRow(0)
				sqlca.sp_next_avail_seq_no(lsproject,"Work_Master","WO_NO" ,ldWONO)//get the next available WO_NO
				lsWONO = lsProject + String(Long(ldWONO),"0000000") /* 08/04 - PCONKL - pad too 7 zeros to avaoid having receive master and Workorder master with same internal number*/
				ldsWorkorderMaster.SetItem(llNewRow,'WO_NO',lsWONO)
				ldsWorkorderMaster.SetItem(llNewRow,'project_id',lsProject)
//				ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsOrderNo)
				ldsWorkorderMaster.SetItem(llNewRow,'Workorder_Number',lsOrderNo)
				ldsWorkorderMaster.SetItem(llNewRow,'last_update',Today())
				ldsWorkorderMaster.SetItem(llNewRow,'last_user','SIMSFP')
//TAM 06/04/2012 - If Riverbed Set Order Date to Local Time
				IF Upper(asproject) = 'RIVERBED' THEN 
					ldsWorkorderMaster.SetItem(llNewRow,'ord_date',f_getLocalWorldTime(ldsHeader.GetITemString(llHeaderPos,'wh_code')))
				else
					ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
				end if
//				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
				ldsWorkorderMaster.SetItem(llNewRow,'ord_status','N')
		Else
				lsWONO = ldsWorkorderMaster.GetItemString(ldsWorkorderMaster.RowCount(),'WO_NO')
		End If
		
	ElseIf ldsHeader.GetITemString(llHeaderPos,'action_cd') = 'D' Then /*If Status is New, Delete*/
		
		If llRmasterCount > 0 Then /*delete all putaway, detail and master records - If status is new*/
		
			If ldsWorkorderMaster.Find("Ord_status = 'C'",1,ldsWorkorderMaster.RowCount()) > 0 or &
				ldsWorkorderMaster.Find("Ord_status = 'P'",1,ldsWorkorderMaster.RowCount()) > 0 or &
				ldsWorkorderMaster.Find("Ord_status = 'V'",1,ldsWorkorderMaster.RowCount()) > 0 Then
					
					uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " Order is not in a new status and action Code is 'Delete'")
					lbError = True
					lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete'"
										
			Else /*delete*/
				
				For llRowPos = 1 to llRMasterCOunt
					lsWONO = ldsWorkorderMaster.GetItemString(llRowPos,'WO_NO')
					Delete From Delivery_BOM where WO_NO = :lsWONO;  //TAM 2011/11 Added Delivery BOM funtionality to the Workorders
					Delete from Workorder_detail where WO_NO = :lsWONO;
					Delete From Workorder_master where WO_NO = :lsWONO;
				Next
							
				llDeleteCount ++ /*update number of orders deleted*/
				Continue /*next header*/
				
			End If
			
		Else /*delete and no records exist - ignore*/
			Continue /*Next header*/
		End If
		
	ElseIf ldsHeader.GetITemString(llHeaderPos,'action_cd') = 'X' Then /* 10/02 - PCONKL - No status in file either add or update, create if it doesn't exist, update if it does*/
		
		If llRMasterCount > 0 Then /* record already exists, can't add*/
			
			//If we dont have an open PO, create a new one!
			If ldsWorkorderMaster.Find("Ord_status = 'N'",1,ldsWorkorderMaster.RowCount()) = 0 and &
				ldsWorkorderMaster.Find("Ord_status = 'P'",1,ldsWorkorderMaster.RowCount()) = 0 and (not lbError) Then
			
				llNewRow=ldsWorkorderMaster.InsertRow(0)
				sqlca.sp_next_avail_seq_no(lsproject,"WorkOrder_Master","WO_NO" ,ldWONO)//get the next available WO_NO
				lsWONO = lsProject + String(Long(ldWONO),"0000000") /* 08/04 - PCONKL - pad too 7 zeros to avaoid having receive master and Workorder master with same internal number*/
				ldsWorkorderMaster.SetItem(llNewRow,'WO_NO',lsWONO)
				ldsWorkorderMaster.SetItem(llNewRow,'project_id',lsProject)
//				ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsOrderNo)
				ldsWorkorderMaster.SetItem(llNewRow,'Workorder_Number',lsOrderNo)
				ldsWorkorderMaster.SetItem(llNewRow,'last_update',Today())
				ldsWorkorderMaster.SetItem(llNewRow,'last_user','SIMSFP')
//TAM 06/04/2012 - If Riverbed Set Order Date to Local Time
				IF Upper(asproject) = 'RIVERBED' THEN 
					ldsWorkorderMaster.SetItem(llNewRow,'ord_date',f_getLocalWorldTime(ldsHeader.GetITemString(llHeaderPos,'wh_code')))
				else
					ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
				end if
//				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
				ldsWorkorderMaster.SetItem(llNewRow,'ord_status','N')

			End If
			
		Elseif llrMasterCount = 0 Then /*insert a new row for the new record*/
			
			llNewRow=ldsWorkorderMaster.InsertRow(0)
			sqlca.sp_next_avail_seq_no(lsproject,"WorkOrder_Master","WO_NO" ,ldWONO)//get the next available WO_NO
			lsWONO = lsProject + String(Long(ldWONO),"0000000") /* 08/04 - PCONKL - pad too 7 zeros to avaoid having receive master and Workorder master with same internal number*/ 
			ldsWorkorderMaster.SetItem(llNewRow,'WO_NO',lsWONO)
			ldsWorkorderMaster.SetItem(llNewRow,'project_id',lsProject)
			ldsWorkorderMaster.SetItem(llNewRow,'Workorder_Number',lsOrderNo)
//			ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsOrderNo)
			//BCR 20-OCT-2011: Riverbed uses Del Inv Nbr. Don't know why it is commented out above. So I will code it for Riverbed ONLY...
			IF Upper(asproject) = 'RIVERBED' THEN 
				ldsWorkorderMaster.SetItem(llNewRow,'Delivery_Invoice_No',lsSuppOrderNo)
			END IF
			//End
			ldsWorkorderMaster.SetItem(llNewRow,'last_update',Today())
			ldsWorkorderMaster.SetItem(llNewRow,'last_user','SIMSFP')
//TAM 06/04/2012 - If Riverbed Set Order Date to Local Time
			IF Upper(asproject) = 'RIVERBED' THEN 
				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',f_getLocalWorldTime(ldsHeader.GetITemString(llHeaderPos,'wh_code')))
			else
				ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
			end if
//			ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
			ldsWorkorderMaster.SetItem(llNewRow,'ord_status','N')
			
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Work Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Work Order Record"
		End If
		
	Else /*invalid Action Type*/
		
		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Action Type: " + ldsHeader.GetITemString(llHeaderPos,'action_cd')) 
		lbError = True
		lsHeaderErrorText += ', ' + "Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Action Type: " + ldsHeader.GetITemString(llHeaderPos,'action_cd')
		
	End If /*Action Type*/
		
	// All updates will be applied to most recent order - If there wasn't an open order, one was created. It will be deleted if no details are added to the new order

//	lsTemp = ldsHeader.GetITemString(llHeaderPos,'Request_Date')
//	If isNull(lstemp) or lstemp = '' Then
//		ldsWorkorderMaster.SetItem(llNewRow,'ord_date',Today())
//	Else
//		ldsWorkorderMaster.SetItem(llNewRow,'ord_date',lsTemp)
//	End If	
//
	//Validate Warehouse
	lsTemp = ldsHeader.GetITemString(llHeaderPos,'wh_code')
	If isNull(lsTemp) Then lsTemp = ''
	Select Count(*) into :llCount
	From Warehouse
	Where wh_code = :lsTemp;
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " Invalid Warehouse: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Warehouse"
	Else /*update the the newest header record*/
		ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'wh_code',lsTemp)
	End If

	//Validate Supplier
	Select Count(*) into :llCount
	From Supplier
	Where project_id = :lsProject and supp_code = :lsSupplier;
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " Invalid Supplier: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Supplier"
	End If

////**** WORKORDER NEEDS INVENTORY TYPE	
//	//Validate Inventory Type
//	lsTemp = ldsHeader.GetITemString(llHeaderPos,'inventory_type')
//	If isNull(lsTemp) Then lsTemp = ''
//	Select Count(*) into :llCount
//	From inventory_type
//	Where project_id = :lsProject and inv_type = :lsTemp;
//	
//	If llCount <= 0 Then
//		uf_writeError("Order Nbr (PO Header): " + string(lsOrderNo) + " Invalid Inventory Type: " + lsTemp) 
//		lbError = True
//		lsHeaderErrorText += ', ' + "Invalid Inventory Type"
//	Else /*update the the newest header record*/
//		ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'inventory_type',lsTemp)
//	End If
//	
	
	/// ****** Change when new table is added
	//Validate Order Type
	lsTemp = ldsHeader.GetITemString(llHeaderPos,'order_type')
	If isNull(lsTemp) Then lsTemp = ''
	Select count(*)  into :llcount
	From Lookup_Table
	Where Code_ID = :lsTemp and
			Project_id = :asProject and 
   		Code_Type = 'WOTYP' ;     
	
	If llCount <= 0 Then
		uf_writeError("Order Nbr (WO Header): " + string(lsOrderNo) + " Invalid Order Type: " + lsTemp) 
		lbError = True
		lsHeaderErrorText += ', ' + "Invalid Order Type"
	Else /*update the the newest header record*/
		ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'ord_type',lsTemp)
	End If
	
	// If any header errors were encountered, update the edi record with status code and error text
	If lbError then
		
			ldsHeader.SetITem(llHeaderPos,'status_cd','E')
			If Left(lsheaderErrorText,1) = ',' Then lsHeaderErrorText = Right(lsheaderErrorText,(len(lsHeaderErrorText) - 1)) /*strip first comma*/
			ldsHeader.SetITem(llHeaderPos,'status_message',lsHeaderErrorText)
			ldsheader.Update()
			
			Update edi_inbound_detail
			Set Status_cd = 'E', status_message = 'Errors exist on Header.'
			Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
			Commit;
			
			Continue /*Next Header*/
			
	Else /* No errors */
		
		//Update other fields...
		
		If isDAte(ldsHeader.GetITemString(llHeaderPos,'Arrival_date')) Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'Sched_date',Date(ldsHeader.GetITemString(llHeaderPos,'Arrival_date')))
		ELSE
			//BCR 20-OCT-2011: Check if this is a Riverbed WO, which means the date string needs to be formatted as necessary...
			IF Upper(asproject) = 'RIVERBED' THEN
				lsTemp = ldsHeader.GetITemString(llHeaderPos,'Arrival_date')
				//Format to yyyy-mm-dd
				lsTemp = Left ( lsTemp, 4)+'-'+Mid ( lsTemp, 5, 2)+'-'+Mid ( lsTemp, 7, 2)
				
				IF isDAte(lsTemp) THEN
					ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'Sched_date',DateTime(lsTemp))
				END IF
			END IF
			//End
		End If
		If ldsHeader.GetITemString(llHeaderPos,'Remark') > ' ' Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'Remarks',ldsHeader.GetITemString(llHeaderPos,'Remark'))
		End If
		If ldsHeader.GetITemString(llHeaderPos,'User_field1') > ' ' Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'User_field1',ldsHeader.GetITemString(llHeaderPos,'User_field1'))
		End If
		If ldsHeader.GetITemString(llHeaderPos,'User_field2') > ' ' Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'User_field2',ldsHeader.GetITemString(llHeaderPos,'User_field2'))
		End If
		If ldsHeader.GetITemString(llHeaderPos,'User_field3') > ' ' Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'User_field3',ldsHeader.GetITemString(llHeaderPos,'User_field3'))
		End If
		//BCR 20-OCT-2011: Add code for User_Field4
		If ldsHeader.GetITemString(llHeaderPos,'User_field4') > ' ' Then
			ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'User_field4',ldsHeader.GetITemString(llHeaderPos,'User_field4'))
		End If
		//End
				
		
//		ldsWorkorderMaster.SetItem(ldsWorkorderMaster.RowCount(),'edi_batch_seq_no',ldsHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no'))
	
		//Update the Header Record
		liRC = ldsWorkorderMaster.Update(True,False) /*we need rec status alter if we need to delete the order if errors*/
		If liRC = 1 then
			Commit;
		Else
			Rollback;
			uf_writeError("- ***System Error!  Unable to Save WorkOrder Master Record to database!")
			lbError = True
			Continue /*Next Header*/
		End If
		
		//Update order insert/update count
		If ldsHeader.GetITemString(llHeaderPos,'action_cd') = 'A' Then
			llNewCount ++
		Else
			llUpdateCOunt ++
		End if
		
	End If /* errors on header? */
	
	//Retrieve the EDI DEtail records for the current header (based on edi batch seq and order_no)

	llDEtailCount = ldsDetail.Retrieve(asProject,llBatchSeq,lsOrderNo) /* 10/03 - PConkl - added Project ID to parm */

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
		lsSku = ldsDetail.GetItemString(llDetailPos,'sku')		
		llLineItem = ldsDetail.GetItemNumber(llDetailPos,'line_item_no')
		
		//Validate Action Code - Dont worry about adds or updates - we can't delete if anything has been received for the line item
		If ldsDetail.GetITemString(llDetailPos,'action_cd') = 'D' Then
			
			Select Sum(alloc_qty) into :llCount
			FRom Workorder_Detail
			Where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from WOrkorder_master where project_id = :lsProject and Workorder_Number = :lsOrderNo);
//			Where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from WOrkorder_master where project_id = :lsProject and Delivery_Invoice_No = :lsOrderNo);
			
			If llCount > 0 Then /*we've already received against this sku, can't delete the line item*/
				uf_writeError("Order Nbr/Line (WO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Action Code is Delete but there are already receipts against this line item" ) 
				lbError = True
				lsDetailErrorText += ', ' + "Action Code is Delete but there are already receipts against this line item"
				//Continue
			Else /*delete the detail row*/
//				Delete from Workorder_Putaway where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from Workorder_master where project_id = :lsProject and Delivery_Invoice_No = :lsOrderNo);
//				Delete from Workorder_Detail where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from Workorder_master where project_id = :lsProject and Delivery_Invoice_No = :lsOrderNo);
				Delete from Delivery_BOMl where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from Workorder_master where project_id = :lsProject and WorkOrder_Number = :lsOrderNo);  //TAM 2011/11 Added Delivery BOM funtionality to the Workorders
				Delete from Workorder_Putaway where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from Workorder_master where project_id = :lsProject and WorkOrder_Number = :lsOrderNo);
				Delete from Workorder_Detail where sku = :lsSku and line_item_no = :llLineItem and WO_NO in (select WO_NO from Workorder_master where project_id = :lsProject and WorkOrder_Number = :lsOrderNo);
				Commit;
				Continue /*Next Detail Record*/
			End If 
		End If /*delete*/
		
		//Validate Inventory Type
		lsTemp = ldsDetail.GetITemString(llDetailPos,'inventory_type')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From inventory_type
		Where project_id = :lsProject and inv_type = :lsTemp;
		
		If llCount <=0 Then
			uf_writeError("Order Nbr/Line (WO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Inventory Type: " + lsTemp) 
			lsDetailErrorText += ', ' + "Invalid Inventory Type"
			lbError = True
		End If
		
		
		//Validate SKU - 10/03 - PCONKL - must validate against header supplier - all SKUS for order must have same supplier
		lsTemp = ldsDetail.GetITemString(llDetailPos,'sku')
		If isNull(lsTemp) Then lsTemp = ''
		//BCR 17-OCT-2011: Encapsulate the hard-coding for Logitech ONLY...
		IF Upper(asproject) = 'LOGITECH' THEN
			Select Count(*) into :llCount
			From Item_Master
			Where project_id = :lsProject and sku = :lsTemp and supp_code = 'LOGITECH';
		ELSE
			Select Count(*) into :llCount
			From Item_Master
			Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;
		END IF
		
		If llCount <=0 Then
			uf_writeError("Order Nbr/Line (WO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid SKU, or SKU not valid for this Supplier: " + lsTemp) 
			lsDetailErrorText += ', ' + "Invalid SKU or SKU not valid for this Supplier"
			lbError = True
		End If
	
		//Quantity must be Numeric
		If not isNumber(ldsDetail.GetITemString(llDetailPos,'Quantity')) Then
			uf_writeError("Order Nbr/Line (WO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Quantity is not numeric: " ) 
			lsDetailErrorText += ', ' + "Quantity is not numeric"
			lbError = True
		End If
		
		//Validate COO if present
		//03/02 - Pconkl - validate against either 2 char or 3 char code
		lsTemp = ldsDetail.GetITemString(llDetailPos,'country_of_origin') 
		If isNull(lsTemp) Then lsTemp = ''
		If Trim(lsTEmp) > '' Then
			If f_get_country_Name(lsTemp) > '' Then
			Else
				uf_writeError("Order Nbr/Line (WO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Country of Origin: " + lsTemp) 
				lsDetailErrorText += ', ' + "Invalid Country of Origin"
				lbError = True
			End If
			
		End If
		
		//If no errors, apply the updates
		If Not lbError Then
			
			//Retrieve any existing Receive Details for this order number (may span multiple WO_NO's)
			//We want to update the newest line item for this PO - The line item may exist on multiple WO_NO's if the PO has been updated
			//or partially received. The DW is sorted by WO_NO so the last row should be the latest. That's the only one that needs updating.
			//We also need to determine if the qty has changed. The only way to do that is to count what we already have ordered.
			
			// pvh - 09/28/05 - replace lsOrderNo with lsWONO
			//llRDetailCount = ldsWorkorderDetail.Retrieve(lsOrderNo,lsSku,lsSupplier,llLineItem)
			llRDetailCount = ldsWorkorderDetail.Retrieve( lsWONO ,lsSku,lsSupplier,llLineItem)
			
			If llRDetailCount > 0 Then /*details exist */
			
				//Get a count of the existing qty to determine whether it has changed
				//If it's not the last row, only include the Allocated - the rest have been copied forward. If it's the last row, only include the Req
				ldQty = 0
				ldAllocQty = 0
				For llRowPos = 1 to llRDetailCount
					If llRowPos = llRDetailCount Then
						ldQty += ldsWorkorderDetail.GetItemNumber(llRowPos,'req_qty') 
					Else
						ldQty += ldsWorkorderDetail.GetItemNumber(llRowPos,'alloc_qty')
					End If			
					ldAllocQty += ldsWorkorderDetail.GetItemNumber(llRowPos,'alloc_qty')
				Next
				
				//If qty different then edi detail record, then we need to change the qty on the most recent open record
				//If the last record has been fully received, then we need to create a new PO (Receive header/detail) for the additional line item
				
				// 07/02 - Pconkl - If the action code for this record is Add, just add the qty to the current total. 
				//							If it is update, we need to reconcile with what has already been received previously
				string test
				test = ldsDetail.GetITemString(llDetailPos,'action_cd')

				If ldsDetail.GetITemString(llDetailPos,'action_cd') = 'A' Then /*add qty's regardless*/
					
					If ldsWorkorderMaster.GetITemString(ldsWorkorderMaster.RowCount(),'WO_NO') = ldsWorkorderDetail.GetITemString(ldsWorkorderDetail.RowCount(),'WO_NO') Then
						ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'req_qty',(ldsWorkorderDetail.GetItemNumber(ldsWorkorderDetail.RowCount(),'req_qty') + (Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')))))
					Else /*create a new detail*/
						liRC = ldsWorkorderDetail.RowsCopy(ldsWorkorderDetail.RowCount(),ldsWorkorderDetail.RowCount(),Primary!,ldsWorkorderDetail,(ldsWorkorderDetail.RowCount() + 1),Primary!) /* add a new row at the end*/
						ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'WO_NO',ldsWorkorderMaster.GetITemString(ldsWorkorderMaster.RowCount(),'WO_NO'))
						ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'req_qty',(Dec(ldsDetail.GetITemString(llDetailPos,'Quantity'))))
						ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'alloc_qty',0)
					End If
						
				ElseIf ldsDetail.GetITemString(llDetailPos,'action_cd') = 'U' Then /*reconcile updated qty's */
					
					If ldQty < Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')) Then /*Qty has been increased*/
						//If there is a detail for the newest header, update it - otherwise create a new detail row for the latest header
						If ldsWorkorderMaster.GetITemString(ldsWorkorderMaster.RowCount(),'WO_NO') = ldsWorkorderDetail.GetITemString(ldsWorkorderDetail.RowCount(),'WO_NO') Then
							ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'req_qty',(ldsWorkorderDetail.GetItemNumber(ldsWorkorderDetail.RowCount(),'req_qty') + (Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')) - ldQty)))
						Else /*create a new detail*/
							liRC = ldsWorkorderDetail.RowsCopy(ldsWorkorderDetail.RowCount(),ldsWorkorderDetail.RowCount(),Primary!,ldsWorkorderDetail,(ldsWorkorderDetail.RowCount() + 1),Primary!) /* add a new row at the end*/
							ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'WO_NO',ldsWorkorderMaster.GetITemString(ldsWorkorderMaster.RowCount(),'WO_NO'))
							ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'req_qty',(Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')) - ldQty))
							ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'alloc_qty',0)
						End If
					ElseIf ldQty > Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')) Then /*Qty has been decreased - decrement from the last row*/
						//We can't change the requested qty to be less than we've already received
						If DEC(ldsDetail.GetITemString(llDetailPos,'Quantity')) < ldAllocQty Then
							//uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " New Quantity is Less than the amount that has already been received. " ) 
							uf_writeError("Order Nbr/Line (PO detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " New Quantity (" + ldsDetail.GetITemString(llDetailPos,'Quantity') +  ") is Less than the amount that has already been received (" + String(ldAllocQty,'#######.#####') + "). Qty will not be updated (Other updateable fields will still be modified)" ) 
							lbError = True
							// 01/03 - PCONKL - we still want to update other updatable fields on this record, jsut not the qty*/
							//Continue /*next detail*/
						Else
							ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'req_qty',(ldsWorkorderDetail.GetItemNumber(ldsWorkorderDetail.RowCount(),'req_qty') - (ldQty  - Dec(ldsDetail.GetITemString(llDetailPos,'Quantity')))))
						End If
					End If /*qty changed*/
					
				End If /*Add/Update of Detail Record*/
				
				//update any other changed fields from edi detail to last workorder detail
				If ldsDetail.GetItemString(llDetailPos,'user_field1') > ' ' Then
					ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'user_field1',ldsDetail.GetItemString(llDetailPos,'user_field1'))
				End If
				If ldsDetail.GetItemString(llDetailPos,'user_field2') > ' ' Then
					ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'user_field2',ldsDetail.GetItemString(llDetailPos,'user_field2'))
				End If
				If ldsDetail.GetITemString(llDetailPos,'Owner_ID') > '' Then /*07/03 - PCONKL */
					ldsWorkorderDetail.SetItem(ldsWorkorderDetail.RowCount(),'Owner_ID',Long(ldsDetail.GetITemString(llDetailPos,'Owner_ID')))
				End If
				
			ElseIf llRDetailCount = 0 Then /*no details exist, it's a new line item - create a new Receive DEtail Record*/

				llLineItem = ldsDetail.GetItemNumber(llDetailPos,'Line_item_no')
				If llLineItem < 1 or isNull(llLineItem) Then
					llLineItem = 1
				End If
				
				ldsWorkorderDetail.InsertRow(0)
				ldsWorkorderDetail.SetITem(1,'WO_NO',ldsWorkorderMaster.GetItemString(ldsWorkorderMaster.RowCount(),'WO_NO'))
				ldsWorkorderDetail.SetItem(1,'sku',ldsDetail.GetItemString(llDetailPos,'sku'))
				ldsWorkorderDetail.SetItem(1,'supp_code',lsSupplier)
				ldsWorkorderDetail.SetITem(1,'req_qty',Dec(ldsDetail.GetItemString(llDetailPos,'quantity')))
				ldsWorkorderDetail.SetItem(1,'user_field1',ldsDetail.GetItemString(llDetailPos,'user_field1'))
				ldsWorkorderDetail.SetItem(1,'user_field2',ldsDetail.GetItemString(llDetailPos,'user_field2'))
				ldsWorkorderDetail.SetItem(1,'line_item_no',llLineItem)
//				ldsWorkorderDetail.SetItem(1,'line_item_no',ldsDetail.GetItemNumber(llDetailPos,'Line_item_no'))
				ldsWorkorderDetail.SetITem(1,'alloc_qty',0)
				
				//Get Component Indicator for SKU
					Select Component_Ind into :lsComponent_ind
					From Item_Master
					Where  project_id = :lsProject and sku = :lsSku;
				
					if not isnull(lscomponent_ind) then
						ldsWorkorderDetail.SetItem(1,'component_ind',lsComponent_ind)		
					else
						ldsWorkorderDetail.SetItem(1,'component_ind','Y')		
					end if

				
				
				// 12/02 - PConkl - If owner present on edi file, set - otherwise get default
				If ldsDetail.GetITemString(llDetailPos,'Owner_ID') > '' Then
					ldsWorkorderDetail.SetItem(1,'Owner_ID',Long(ldsDetail.GetITemString(llDetailPos,'Owner_ID')))
				Else
					//Get default owner for SKU
					Select Min(owner_id) into :llOwner
					From Item_Master
					Where  project_id = :lsProject and sku = :lsSku;
				
					ldsWorkorderDetail.SetItem(1,'owner_id',llOwner)		
				End If /*owner present*/					
	
			Else /*system Error*/
				uf_writeError("Order Nbr (WO Detail): " + string(lsOrderNo) + " - System Error: Unable to retrieve Work Order Detail Records")
				lbError = True
				Continue /*next Detail*/
			End If /*Receive detail records exist? ) */
			
			//Update the Detail Record
			liRC = ldsWorkorderDetail.Update()
			If liRC = 1 then
				Commit;
			Else
				Rollback;
				uf_writeError("- ***System Error!  Unable to Save Workorder Detail Record to database!")
				lbError = True
				COntinue
			End If
				
		Else /* Errors exist on Detail, mark with status cd and error text*/
			
			ldsDetail.SetItem(llDetailPos,'status_cd','E')
			If Left(lsDetailErrorText,1) = ',' Then lsDetailErrorText = Right(lsDetailErrorText,(len(lsDetailErrorText) - 1)) /*strip first comma*/
			ldsDetail.SetItem(llDetailPos,'status_message',lsDetailErrorText)
			
		End If /*no errors on detail*/
		
	Next /*edi detail record*/
	
	//If there were errors on any of the details and this is a new order, we will delete the header and any details that
	//might have been saved. The header will have been saved before the details were processed but we dont want to keep it
	
	//save any changes made to edi records (status cd, error msg)
	ldsheader.Update(True,False) 
	ldsDetail.Update()
	Commit;
	
	If lbError or lbDetailErrors Then 
		
		// 03/03 - PCONKL - If not allowing orders with detail errors, delete any new records created if any details had errors
		If lsAllowPOErrors <> 'Y' Then
			
			If ldsWorkorderMaster.GetITemStatus(1,0,Primary!) = NewModified! /* new PO */ Then
				//lsWONO will contain the WO_NO of the records just created
				Delete from Delivery_BOM where WO_NO = :lsWONO;  //TAM 2011/11 Added Delivery BOM funtionality to the Workorders
				Delete from Workorder_detail where WO_NO = :lsWONO;
				Delete from Workorder_Putaway where WO_NO = :lsWONO;
				Delete from Workorder_master where WO_NO = :lsWONO;
				Commit;
			End If /* new PO with errors*/
						
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - No changes applied to this Order!")
			
		Else /*saved with errors */
				
			Update Delivery_BOM set wo_no = :lsWONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq;
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - Order saved with errors!")
			
		End If

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
	//lsWONO should only be populated if we added a new row, if there is more than 1 header row, it has to be an update
	//If it is a new add and there were no detail rows, we don't want to delete it
	If ldsWorkorderMaster.RowCount() > 1 and lsWONO > ' ' Then
		Select Count(*) into :llCount
		From workorder_detail
		where WO_NO = :lsWONO;
		
		If llCount = 0 Then
			DElete from Workorder_master where WO_NO = :lsWONO;
			Commit;
		End If
		
	End If
	
	ldsWorkorderMaster.ResetUpdate()
	Update DElivery_BOM set wo_no = :lsWONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq; 	//2011/11 - PCONKL
	
//	// TAM - REMOVED Update notes record with WO_NO just created
//	If lsWONO > ' ' Then
//		
//		Update Workorder_notes
//		Set WO_NO = :lsWONO 
//		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq;
//		
//		Commit;
//		
//	End If
			
Next /* EDI Header Record*/

//mark any records as complete that might have been skipped (continued to next header*/
For llHeaderPos = 1 to llHeaderCount
	
	lsProject = ldsHeader.GetITemString(llHeaderPos,'project_id')
	lsOrderNo = ldsHeader.GetITemString(llHeaderPos,'order_no')
	llBatchSeq = ldsHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no')
	
	Update edi_inbound_header
	Set status_cd = 'C' , status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
				
	Update edi_inbound_detail
	Set Status_cd = 'C', status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_no = :lsOrderno and status_cd = 'N';
	
	commit;
	
Next

Destroy ldsHeader
Destroy ldsDetail
Destroy ldsWorkorderMaster
Destroy ldsWorkorderDetail

If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/

If lbValError Then 
	Return -1
Else
	Return 0
End If



end function

public function integer uf_process_scheduled_activity ();//Process all of the reports

Long	llRC
String lslogout

u_nvo_proc_scheduled_activity	lu_nvo_proc_scheduled_activity
lu_nvo_proc_scheduled_activity = Create u_nvo_proc_scheduled_activity

// Process Reports
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Scheduled Reports. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

llrc = lu_nvo_proc_scheduled_activity.uf_process_reports(gsinifile)



// Process Functions
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Scheduled Functions. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

llrc = lu_nvo_proc_scheduled_activity.uf_process_functions(gsinifile)

//TimA 12/22/11
yield()


Destroy lu_nvo_proc_scheduled_activity


Return 0
end function

public function integer uf_process_ftp_outbound (string asdirectory);
//This function will move processed files from a directory to the appropriate FTP folder
// 04/05 - PCONKL - ADded Paramter to determine which Outbound list to process
//							This function is now called at the beginning and end of the sweep to allow us to delay files for a sweep if necessary


Integer	liRC, liTransferMode
			
Long		llArrayCount, llArrayPos, llCount, llFolderPos, lul_handle,	llFilePos,	llFileCount

String	lsLogOut, lsDirList,	lsDir[],	lsFiles[], lsCurrentFile, lsSaveFileName,	lsProject,		&
			lsInitArray[],lsPath,lsDirectory,lsTemp, lsCommand, lsTransferMode
			
ulong ll_dwcontext, l_buf, llCrap
boolean lb_currentdir,bRet, lbFTPError
str_win32_find_data str_find

l_buf = 300

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Uploading Outbound FTP Files (' + asDirectory + '). - ' + String(Today(), "mm/dd/yyyy hh:mm:ss") 
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//Get a list of all Projects to process
// 04/05 - PCONKL - Loading list from directory passed in parm
//lsDirList = ProfileString(gsinifile,'FTPOUTBOUND',"directorylist","")
lsDirList = ProfileString(gsinifile,asDirectory,"directorylist","")

If isnull(lsDirList) or lsDirList = '' Then 
	lsLogOut = "  No projects found to process for " + asDirectory + "..."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	REturn 0
End If

llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/
		
//Process the requested FTP Directories
For llFolderPos = 1 to UpperBound(lsDir) /*For each Folder*/
	//TimA 12/22/11
	yield()

	If lsDir[llFolderPos] = '' Then Continue
	
	lsLogOut = "  Processing FTP files for Project: '" + lsDir[llFolderPos] + "'"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get the project for the current folder from the profileString
	lsProject = ProfileString(gsinifile,lsDir[llFolderPos],"project","")
		
	//Get a list of the files to upload
	lsPath = ProfileString(gsinifile,lsDir[llFolderPos],"ftpfiledirout","")
		
	If isnull(lsPath) or lsPath = '' Then
		lsLogOut = "  No staging directory present - Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	lsLogOut = '      Upload Staging directory: ' + lspath
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	lsFiles = lsInitarray /*reinitialize array*/
	llFilePos = 0
	//lsDirectory = lsPath + '\' +  ProfileString(gsinifile,lsDir[llFolDerPos],"directorymask","")
	lsDirectory = lsPath + '\*.*' /* 12/03 - PCONKL */
	
	lul_handle = FindFirstFile(lsDirectory, str_find)
				
	If lul_handle > 0  Then/*first file found*/ 
		bREt = True
		do While  bret
			// 12/03 - PCONKL - Don't include directories in file listing (str_find.fileattributes = 16)
			If Trim(Str_find.FileName) > ' ' and  Pos(Str_find.FileName,'.') > 0 and &
				Trim(Str_find.FileName) <> '.' and Trim(Str_find.FileName) <> '..' Then
					llFilePos ++
  					lsfiles[llFilePos] = str_find.filename
			End If
			
	 		bret = FindNextFile(lul_handle, str_find)	
		Loop
	End If
	
	If llFilePos = 0 Then /*No files found for processing*/
		lsLogOut = '        No files found to process in directory: ' + lsPath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	End If
	
	llFileCount = UpperBound(lsFiles[])
	
	If llFileCount <= 0 Then Continue //Skip processing if there are no files to Upload
		
	lsLogOut = Space(6) + String(llFileCount) + " Files found in directory for uploading."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	// 03/04 - PCONKL - Check to see if we need to send in ASCII format (AS400, etc.)
	lsTransferMode = ProfileString(gsinifile,lsDir[llFolderPos],"ftptransfermode","")
	If lsTransferMode = "ASCII" Then
		liTransferMode = 1
	Else
		liTransferMode = 0
	End If
	
	//Connect to FTP
	If uf_ftp_connect(lsDir[llFolderPos]) < 0 Then
		lsLogOut = "  Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	//Change directory to Out directory
	If ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryout","") > ' ' Then
		uf_ftp_setDir(ProfileString(gsinifile,lsDir[llFolderPos],"ftpdirectoryout",""))
	End If
		
	//Upload Each File
	For llFilePos = 1 to llFileCount /*for each file in the FTP Folder*/
		
		lsCurrentFile = lsPath + '\' + lsFiles[llFilePos]
		
		liRC = uf_ftp_upload(lsCurrentFile,lsFiles[llFilePos],liTransferMode) /* 03/04 - PCONKL - added Trans Mode (Binary or ASCII) */
				
		//If uploaded successfully, move file to archive directory
		If liRC = 0 Then
			
			lsSaveFileName = ProfileString(gsinifile,lsDir[llFolDerPos],"archivedirectory","") + '\' + lsFiles[llFilePos] + '.txt'
			
			//Check for existence of the file in the archive directory already - it was probably already saved when written to the flat file in the last step, no need to save twice
			If Not FIleExists(lsSaveFileNAme) Then
							
				bret=MoveFile(lsCurrentFile,lsSaveFileName)
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsSaveFileName
					FileWrite(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
				
			Else /* File already exists, delete from output directory so we don't send it again */
				
				bret = DEleteFile(lsCurrentFile)
				If bret Then /*deleted*/
					lsLogOut = Space(10) + "File deleted: " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
				Else /*not deleted */
					lsLogOut = Space(10) + "*** Unable to delete Local File (FTP Upload): " + lsCurrentFile
					uf_write_log(lsLogOut) /*write to Screen*/
					FileWrite(gilogFileNo,lsLogOut)
					
					//Notify the systems list - otherwise we'll keep resending the records
					uf_send_email('XX','System','***SIMSFP - System Error***',lsLogOut,'') /*send an email mesg to the systems distribution list*/
			
					//Reduce the Sweep time to give time to catch before resending			
					w_main.sle_sweep_interval.Text = "3600" /*one hour */
					w_main.sle_sweep_interval.TriggerEvent("Modified")
					
				End If
				
			End If /*file doesn't already exist*/
			
		Else /* NOt uploaded successfully*/
						
			lbFTPError = True /* At the end, if we've had upload errors, we'll increment the error count. We want the count to be per instance of error, not count of files */
			
		End If /*sucessfully uploaded to FTP */
				
	Next /*Next file to upload from current staging Folder */
	
	//Logout of Current FTP server
	uf_ftp_disconnect()
	
Next /* Next FTP Folder to process*/

//Make damn sure we're logged out!
uf_ftp_disconnect()

//Close the internet connection if Open - hopefully, clear cache
If il_hopen > 0 Then
	InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
End If

// 03/04 - PCONKL - If we have too many uplaod errors, we need to restart the sweeper
If lbFTPError Then
	ilFTPUploadAttempts ++ /* we'll Restart if we hit a certain point*/
	uf_send_email('','Filexfer'," - ***** Unable to upload to FTP Server","Errors wre encountered uploading FTP files. See log file for more details",'') /*send an email msg to the file transfer error list*/
End If

Return 0
end function

public function integer uf_monthly_transactions ();/*
** Need to check periodically (weekly) for null wh.transaction_group
   - if new w/h is added, uf3 needs to be set (sic, location name) for roll-up.

used sql from stored procedures sp_inbound_ship_status and sp_outbound_ship_status
to create datastores d_transactions_inbound and d_transactions_outbound
added transaction_group from warehouse table to roll up to locations

Could (should?) add a field to Warehouse to accomplish roll-up by location
 - Using w.user_field3 since no warehouse was using it (and it's not available to the users)
 - dts 07-08-08 - now using new field transaction_group for roll-up
 - Could (should?) add a field to apply a factor for interfaces (as in the old Excel version)

*/

/* What about new project/warehouses? Somebody will need to populate warehouse.uf3
	appropriately to roll it up correctly.
	** Should we run this function once per day, checking for new 
	warehouses (null UF3) and warning the SIMS distribution of new WH
	and only create the transaction files when it's appropriate?
	
	- Also need a mechanism to ignore some locations (PDX, Demo...)
	  - maybe the absence of data in wh.uf3 is sufficient
*/
//messagebox('Monthly Transactions', 'Here we go...')

datastore ldsTransOut, ldsTransIn, ldsMissingRollUps, ldsTotalTrans

DateTime	ldtNextRunTime
Date		ldtNextRunDate, ldtFrom, ldtTo
integer	liRC, liFileNo, liMonth, liYear, liDayOfWeek, liMissingRollUps
long		llRowCount, llRowPos, llRowCountOut, llFind, llTrans
string	lsProject, lsWH, lsInOrders, lsInLines, lsOutOrders, lsOutLines, lsRollUp, lsOut, lsTransactions, lsLogOut
string 	lsNextRunDate, lsNextRunTime, lsFrom, lsTo, lsDay, lsNextRunDate_RollUps, lsRollUpInterval, lsArchiveDir, lsFileName
boolean	lbRunTransactions, lbRunRollUps
integer i
long llNewRow, llTotalRows
//need to grab transactions from Wine & Spirit (grouped by Project.UF1) and replace the 'WS?' line in the counts
string lsSQL, lsError, lsSyntax
datastore ldsInboundUF1, ldsOutboundUF1

/*
//Zip Test: 
// - Now using WZZip.exe (had to install on my machine to use in development enviro.)
integer i
string lsZipTest //temporary for testing uf_zipper
lsZipTest = ProfileString(gsinifile,'MONTHLYTRANS',"ZipTest","")
if lsZipTest = 'YES' then
	i = filelength('c:\projects\sims\ValeoFLNotes.txt')
	uf_send_email("MonthlyTrans", "CustVal", "Testing Zipper", "Attached is a zipper test", "c:\projects\sims\ValeoFLNotes.txt; c:\projects\sims\SIMS_Environment.doc")
	lirc = uf_zipper('c:\projects\sims\ValeoFLNotes.txt', 'c:\projects\sims\xyz.zip')
end if
*/

lsLogOut = '- PROCESSING FUNCTION - Monthly Transactions. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

ldsTransIn = Create Datastore
ldsTransIn.Dataobject = 'd_transactions_inbound'
lirc = ldsTransIn.SetTransobject(sqlca)

ldsTransOut = Create Datastore
ldsTransOut.Dataobject = 'd_transactions_outbound'
lirc = ldsTransOut.SetTransobject(sqlca)

ldsTotalTrans = Create Datastore
ldsTotalTrans.Dataobject = 'd_transactions_inbound'

/* Need to grab dates from ini file */
lsNextRunDate = ProfileString(gsinifile,'MONTHLYTRANS',"NextRunDate","")
lsNextRunTime = ProfileString(gsinifile,'MONTHLYTRANS',"NextRunTime","")
lsNextRunDate_RollUps = ProfileString(gsinifile,'MONTHLYTRANS',"NextRunDate_RollUps","")
lsRollUpInterval = ProfileString(gsinifile,'MONTHLYTRANS',"RollUps_Interval","")

If trim(lsNextRunDate) = '' or trim(lsNextRunTime) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	//Return 0
	lbRunTransactions = False
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate), Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(), now()) Then /*not yet time to run*/
		//Return 0
		lbRunTransactions = False
	else
		lbRunTransactions = True
	End If
End If

//See if Roll-up data should be checked...
If trim(lsNextRunDate_RollUps) = '' or trim(lsNextRunTime) = '' or (not isdate(string(Date(lsNextRunDate_RollUps)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run roll-ups*/
	lbRunRollUps  = False
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate_RollUps), Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(), now()) Then /*not yet time to run roll-ups*/
		lbRunRollUps = False
	else
		lbRunRollUps = True
	End If
End If


//if DateTime(today(), now()) > DateTime(date(lsNextRunDate_RollUps), time(lsNextRunTime)) then
if lbRunRollUps then
	
	//uf_monthly_check_rollups()
	//select count(*) into :liMissingRollUps
	//from warehouse where transaction_group is null or transaction_group = '';

	ldsMissingRollUps = Create Datastore
	ldsMissingRollUps.Dataobject = 'd_monthly_trans_missing_rollup'
	lirc = ldsMissingRollUps.SetTransobject(sqlca)
	liMissingRollUps = ldsMissingRollUps.Retrieve()
	if liMissingRollUps > 0 then
		//Project, Distribution, Subject, Text
		lsRollUp = "There are " + string(liMissingRollUps) + " warehouse(s) with missing roll-up data (wh.transaction_group is null/empty)."
		lsRollUp += "  Enter SIC, Roll-Up into UF3 (where Roll-Up is the responsible location) or enter 'NONE' if it is to be ignored."
		lsRollUp += '~n' + '~n' + 'PROJECT    -  WAREHOUSE'
		lsRollUp += '~n' + '----------    ----------'
		For llRowPos = 1 to liMissingRollUps
			lsRollUp += '~n'
			lsProject = ldsMissingRollUps.GetItemString(llRowPos, 'Project_ID') 
			if isnull(lsProject) then lsProject = 'Null      '
			lsProject = lsProject + space(10 - len(lsProject))
			lsWH = ldsMissingRollUps.GetItemString(llRowPos, 'Wh_Code')
			if isnull(lsWH) then lsWH = 'Null'
			lsRollUp += lsProject + ' -  ' + lsWH
		next
		
		uf_send_email('XX','System','Monthly Transactions - Need Roll-up Info.', lsRollUp, '')
//		uf_send_email(lsDir[llDirPos],'Filexfer'," - ***** Unable to Write to File",lsLogOut,'') /*send an email msg to the file transfer error list*/
	end if
	lsRollUp = string(RelativeDate(Date(lsNextRunDate_RollUps), integer(lsRollUpInterval)))
	SetProfileString(gsIniFile, 'MONTHLYTRANS', 'NextRunDate_RollUps ', lsRollUp)
	
end if

//if DateTime(today(), now()) < DateTime(date(lsNextRunDate), time(lsNextRunTime)) then
if not lbRunTransactions then
	return 0
end if

lsFrom = ProfileString(gsinifile,'MONTHLYTRANS',"FromDate","")
ldtFrom = Date(lsFrom)
//'To' date should be first day of next month...
lsTo = ProfileString(gsinifile,'MONTHLYTRANS',"ToDate","")
ldtTo = Date(lsTo)

uf_write_Log('From: ' + String(ldtFrom) + ', To: ' + string(ldtTo)) /*display msg to screen*/
FileWrite(giLogFileNo,'From: ' + String(ldtFrom) + ', To: ' + string(ldtTo))
//dts 2014-06-02 now doing this for both Pandora db and Non-Pandora db from a single (non-pandora scheduler) sweeper (so need to do this part twice)
for i = 1 to 2
			//First time through is Non-Pandora. Then we'll connect to Pandora and grab those transactions....
			if i = 1 then
				uf_write_Log('First get the transaction counts for the non-Pandora database...')
				FileWrite(giLogFileNo,'First get the transaction counts for the non-Pandora database...')
			else
				uf_write_Log('Now get the transaction counts for the Pandora database...')
				FileWrite(giLogFileNo,'Now get the transaction counts for the Pandora database...')
				liRC = uf_connect_to_pandora_db()
				lirc = ldsTransIn.SetTransobject(Pandora_SQLCA)
				lirc = ldsTransOut.SetTransobject(Pandora_SQLCA)
			end if
			
			//Inbound...
			llRowCount = ldsTransIn.Retrieve(ldtFrom, ldtTo) /* retrieve Inbound Transactions */
			//llRowCount = ldsTransIn.Retrieve(lsFrom, lsTo) /* retrieve Inbound Transactions */
			
			//messagebox ('TEMPO - Inbound', 'Count: ' + string(llRowCount))
			uf_write_Log("Inbound Count: " + string(llRowCount))
			FileWrite(giLogFileNo,"Inbound Count: " + string(llRowCount))
			if llRowCount > 0 then
				//Outbound...
				llRowCountOut = ldsTransOut.Retrieve(ldtFrom, ldtTo) /* retrieve Outbound Transactions */	
				//llRowCountOut = ldsTransOut.Retrieve(lsFrom, lsTo) /* retrieve Outbound Transactions */	
				//messagebox ('TEMPO - Outbound', 'Count: ' + string(llRowCountOut))
				uf_write_Log("Outbound Count: " + string(llRowCountOut))
				FileWrite(giLogFileNo,"Outbound Count: " + string(llRowCountOut))
				
				if llRowCountOut > 0 then
					//add outbound data to inbound, and total the transactions
					For llRowPos = 1 to llRowCountOut
						lsOutOrders = string(ldsTransOut.GetItemNumber(llRowPos, 'Orders'))
						lsOutLines = String(ldsTransOut.GetItemNumber(llRowPos, 'Lines'))
						lsRollUp = ldsTransOut.GetItemString(llRowPos, 'RollUp')
						llFind = ldsTransIn.Find("RollUp = '" + lsRollUp + "'", 1, ldsTransIn.RowCount()) 
						/* need to search for correct record, and add one if it doesn't already exist (No inbound data, but there is outbound data)*/
						if llFind = 0 then
							llFind = ldsTransIn.InsertRow(0)
							ldsTransIn.SetItem(llFind,'RollUp', lsRollUp)
							ldsTransIn.SetItem(llFind, 'Orders', 0)
							ldsTransIn.SetItem(llFind, 'Lines', 0)
							//lsInOrders = '0'
							//lsInLines = '0'
							llRowCount += 1
						//else
							//lsInOrders = string(ldsTransIn.GetItemNumber(llRowPos, 'Orders'))
							//lsInLines = String(ldsTransIn.GetItemNumber(llRowPos, 'Lines'))				
						end if
						ldsTransIn.SetItem(llFind, 'OutOrders', lsOutOrders)
						ldsTransIn.SetItem(llFind, 'OutLines', lsOutLines)
						//llTrans = long(lsInOrders) + long(lsInLines) + long(lsOutOrders) + long(lsOutLines)
						//ldsTransIn.SetItem(llFind, 'Transactions', long(lsInOrders) + long(lsInLines) + long(lsOutOrders) + long(lsOutLines))
						//ldsTransIn.SetItem(llFind, 'Transactions', string(llTrans))
					
					next /*next output record */
				end if //llRowCountOut > 0
				//now we have a datastore for the current db with both inbound and outbound transaction counts. Create records in the 'Total' datastore
				for llRowPos = 1 to llRowCount
					lsRollUp = ldsTransIn.GetItemString(llRowPos, 'RollUp')
					lsInOrders = string(ldsTransIn.GetItemNumber(llRowPos, 'Orders'))  //the Orders/Lines for Inbound are Long while the OutOrders/OutLines are CHAR
					lsInLines = String(ldsTransIn.GetItemNumber(llRowPos, 'Lines'))
					lsOutOrders = ldsTransIn.GetItemString(llRowPos, 'OutOrders')
					lsOutLines = ldsTransIn.GetItemString(llRowPos, 'OutLines')
					llNewRow = ldsTotalTrans.InsertRow(0)
					ldsTotalTrans.SetItem(llNewRow,'RollUp', lsRollUp)
					ldsTotalTrans.SetItem(llNewRow, 'Orders', long(lsInOrders))
					ldsTotalTrans.SetItem(llNewRow, 'Lines', long(lsInLines))
					ldsTotalTrans.SetItem(llNewRow, 'OutOrders', lsOutOrders)
					ldsTotalTrans.SetItem(llNewRow, 'OutLines', lsOutLines)
				next
			end if //llRowCount > 0 (really should revisit this to make it cleaner since the database split)
next //get transactions for next database (Pandora)
disconnect using Pandora_SQLCA;
destroy Pandora_SQLCA
//if llRowCount > 0 then

FileWrite(giLogFileNo, 'Now grabbing the W&S transactions (grouped by Project.UF1)')
//Now add transaction records for Wine and Spirit. We need to group the transactions by Project.UF1.  Build two datastores; one for Inbound and one for Outbound and do the same thing we do for WH.Transaction_Group records
//Inbound ....
	lsSQL = "Select p.User_Field1 RollUp, sum(master.proj_cnt) Orders, sum(detail.items_cnt) Lines, '' OutOrders,'' OutLines from "
	lsSQL += "(SELECT Project_ID, WH_Code,count(*) proj_cnt FROM Receive_Master "
	lsSQL += "WHERE Ord_Status = 'C' and Complete_Date >= '" +lsFrom +"' and Complete_Date < '" + lsTo +"' "
	lsSQL += "group by project_id, WH_Code) master "
	lsSQL += "inner join "
	lsSQL += "(Select Project_ID, WH_Code, count(*) items_cnt "
	lsSQL += "from Receive_Detail inner join Receive_Master on Receive_Detail.RO_No = Receive_Master.RO_No "
	lsSQL += "Where Ord_Status = 'C' and Complete_Date >= '" + lsFrom + "' and Complete_Date < '" + lsTo + "' "
	lsSQL += "group by project_id, WH_Code) detail "
	lsSQL += "on master.Project_ID = detail.Project_ID and  master.WH_Code =  detail.WH_Code "
	lsSQL += "inner join warehouse w on detail.wh_code = w.wh_code "
	lsSQL += "inner join Project p on master.Project_ID = p.Project_ID "
	lsSQL += "where w.transaction_group = 'WS?' "
	lsSQL += "group by p.User_Field1 "

	lsSyntax = SQLCA.SyntaxFromSQL( lsSQL, "style (type=grid)", lsError)
	ldsInboundUF1 = Create datastore
	liRC = ldsInboundUF1.Create( lsSyntax, lsError)
	
	ldsInboundUF1.SetTransObject( SQLCA )
	llRowCount = ldsInboundUF1.Retrieve()

if llRowCount > 0 then
	//Outbound ....
	lsSQL = "Select p.User_Field1 RollUp, sum(master.proj_cnt) Orders, sum(detail.items_cnt) Lines from "
	lsSQL += "(SELECT Project_ID, WH_Code,count(*) proj_cnt FROM Delivery_Master "
	lsSQL += "WHERE Ord_Status = 'C' and Complete_Date >= '" +lsFrom +"' and Complete_Date < '" + lsTo +"' "
	lsSQL += "group by project_id, WH_Code) master "
	lsSQL += "inner join "
	lsSQL += "(Select Project_ID, WH_Code, count(*) items_cnt "
	lsSQL += "from Delivery_Detail inner join Delivery_Master on Delivery_Detail.DO_No = Delivery_Master.DO_No "
	lsSQL += "where Ord_Status = 'C' and Complete_Date >= '" + lsFrom + "' and Complete_Date < '" + lsTo + "' "
	lsSQL += "group by project_id, WH_Code) detail "
	lsSQL += "on master.Project_ID = detail.Project_ID and  master.WH_Code =  detail.WH_Code "
	lsSQL += "inner join warehouse w on detail.wh_code = w.wh_code "
	lsSQL += "inner join Project p on master.Project_ID = p.Project_ID "
	lsSQL += "where w.transaction_group = 'WS?' "
	lsSQL += "group by p.User_Field1 "

	lsSyntax = SQLCA.SyntaxFromSQL( lsSQL, "style (type=grid)", lsError)
	ldsOutboundUF1 = Create datastore
	liRC = ldsOutboundUF1.Create( lsSyntax, lsError)
	
	ldsOutboundUF1.SetTransObject( SQLCA )
	llRowCountOut = ldsOutboundUF1.Retrieve()

	if llRowCountOut > 0 then
		//add outbound data to inbound
		For llRowPos = 1 to llRowCountOut
			lsRollUp = ldsOutboundUF1.GetItemString(llRowPos, 'RollUp')
			lsOutOrders = string(ldsOutboundUF1.GetItemNumber(llRowPos, 'Orders'))
			lsOutLines = String(ldsOutboundUF1.GetItemNumber(llRowPos, 'Lines'))
			llFind = ldsInboundUF1.Find("RollUp = '" + lsRollUp + "'", 1, ldsInboundUF1.RowCount()) 
			/* need to search for correct record, and add one if it doesn't already exist (No inbound data, but there is outbound data)*/
			if llFind = 0 then
				llFind = ldsInboundUF1.InsertRow(0)
				ldsInboundUF1.SetItem(llFind,'RollUp', lsRollUp)
				ldsInboundUF1.SetItem(llFind, 'Orders', 0)
				ldsInboundUF1.SetItem(llFind, 'Lines', 0)
				llRowCount += 1
			end if
			ldsInboundUF1.SetItem(llFind, 'OutOrders', lsOutOrders)
			ldsInboundUF1.SetItem(llFind, 'OutLines', lsOutLines)
		
		next /*next output record */
	end if //llRowCountOut > 0
	//now we have a datastore for W&S with both inbound and outbound transaction counts. Create records in the 'Total' datastore
	// - may need to 'find' to see if the transaction group already exists (otherwise, we may end up with extra transaction line of the same SIC)
	for llRowPos = 1 to llRowCount
		lsRollUp = ldsInboundUF1.GetItemString(llRowPos, 'RollUp')
		lsInOrders = string(ldsInboundUF1.GetItemNumber(llRowPos, 'Orders'))  //the Orders/Lines for Inbound are Long while the OutOrders/OutLines are CHAR
		lsInLines = String(ldsInboundUF1.GetItemNumber(llRowPos, 'Lines'))
		lsOutOrders = ldsInboundUF1.GetItemString(llRowPos, 'OutOrders')
		lsOutLines = ldsInboundUF1.GetItemString(llRowPos, 'OutLines')
		llNewRow = ldsTotalTrans.InsertRow(0)
		ldsTotalTrans.SetItem(llNewRow,'RollUp', lsRollUp)
		ldsTotalTrans.SetItem(llNewRow, 'Orders', long(lsInOrders))
		ldsTotalTrans.SetItem(llNewRow, 'Lines', long(lsInLines))
		ldsTotalTrans.SetItem(llNewRow, 'OutOrders', lsOutOrders)
		ldsTotalTrans.SetItem(llNewRow, 'OutLines', lsOutLines)
	next
	//now we need to delete the 'WS?' line from the data
	llFind = ldsTotalTrans.Find("RollUp = 'WS?'", 1, ldsTotalTrans.RowCount()) 
	if llFind > 0 then
		ldsTotalTrans.DeleteRow(llFind)
	end if
end if //if llRowCount > 0 (for the Project.UF1 groups)

FileWrite(giLogFileNo, 'Now splitting Starbucks (WST) by Bakery and Non-Bakery')
long ll_BakeryInOrders, ll_BakeryInLines, ll_BakeryOutOrders, ll_BakeryOutLines
//2015-12-31 - need to split Starbucks (WST) for Bakery items. We'll grab the Transactions for Bakery (as described below) and split the WST record into two records (Bakery and Non-Bakery)
//	These are the orders for bakery items to be excluded from the SIMS Indirects:
//	1.	For inbound orders, all orders whereby supplier codes NOT EQUAL CTSUS01 are to be excluded from the SIMS indirects. These orders have SKUs starting with TL. 
//	2.	For outbound orders, order types = $$HEX1$$1c20$$ENDHEX$$C$$HEX2$$1d202000$$ENDHEX$$(Cross-dock; bakery items for stores within Bangkok) and $$HEX1$$1c20$$ENDHEX$$F$$HEX2$$1d202000$$ENDHEX$$(Frozen; bakery items for stores outside Bangkok) are to be excluded from the SIMS indirects.
//Grabbing Inbound 'Bakery' counts...
select count(Ro_No) into :ll_BakeryInOrders from Receive_Master with(nolock) 
where project_id in('STBTH')
and WH_Code in('STBTH')
and complete_date > :lsFrom
and complete_date < :lsTo
and supp_code <>'CTSUS01';

select count(rd.Ro_No) into :ll_BakeryInLines from Receive_Master rm with(nolock) inner join Receive_Detail rd with(nolock) on rm.RO_No=rd.ro_no
where project_id in('STBTH')
and WH_Code in('STBTH')
and complete_date > :lsFrom
and complete_date < :lsTo
and rm.supp_code <>'CTSUS01';

select count(DO_No) into :ll_BakeryoUTOrders from delivery_master with(nolock) 
where project_id in('STBTH')
and WH_Code in('STBTH')
and complete_date > :lsFrom
and complete_date < :lsTo
and ord_type in ('C', 'F');

select count(dd.DO_No) into :ll_BakeryOutLines from delivery_master dm with(nolock) inner join Delivery_Detail dd with(nolock) on dm.DO_No=dd.DO_No
where project_id in('STBTH')
and WH_Code in('STBTH')
and complete_date > :lsFrom
and complete_date < :lsTo
and ord_type in ('C', 'F');

llTotalRows = ldsTotalTrans.RowCount()

FileWrite(giLogFileNo, 'Total rows: ' + string(llTotalRows))
if llTotalRows > 0 then
	ldsTotalTrans.SetSort("#1 A")
	ldsTotalTrans.Sort()

	//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
	//TEMPO! change hard-coded path! - add date (and time?) to file name
	// - Create a 'MonthlyTrans' directory in outbound/archive?
	lsArchiveDir = ProfileString(gsinifile,'MONTHLYTRANS',"ArchiveDirectory","")
	if right(lsArchiveDir,1) <> '\' then
		lsArchiveDir += '\'
	end if
	lsFileName = lsArchiveDir + 'SIMSTrans' + string(today(),"yyyymmdd") +'.csv'
	//liFileNo = FileOpen('C:\projects\SIMS\MonthlyStats\SIMSTrans' + string(today(),"yyyymmdd") +'.csv', LineMode!, Write!, LockReadWrite!, Replace!)
	liFileNo = FileOpen(lsFileName, LineMode!, Write!, LockReadWrite!, Replace!)

	//Write header to file...
	liRC = FileWrite(liFileNo, "SIMS Transactions for " + string(ldtFrom, 'mmmm'))
	liRC = FileWrite(liFileNo, "(" + string(ldtFrom) + " to " + string(RelativeDate(ldtTo,-1)) + ")")
	liRC = FileWrite(liFileNo, "")
	//liRC = FileWrite(liFileNo, "SIC, Location, IB Orders, IB Lines, OB Orders, OB Lines, Transactions")
	//liRC = FileWrite(liFileNo, "SIC, IB Orders, IB Lines, OB Orders, OB Lines, Transactions")
	liRC = FileWrite(liFileNo, "SIC, IB Orders, IB Lines, OB Orders, OB Lines, Transactions, Comments")
	//Write the rows to file
	For llRowPos = 1 to llTotalRows //llRowCount
		lsRollUp = ldsTotalTrans.GetItemString(llRowPos, 'RollUp')
		if lsRollUp = 'WST' then //Need to Split Starbucks Transactions by Bakery and Non-Bakery
			//first, write the Non-Bakery transactions (the total WST transactions, minus the 'Bakery' items)
			lsInOrders = string(ldsTotalTrans.GetItemNumber(llRowPos, 'Orders') - ll_BakeryInOrders)
			lsInLines = String(ldsTotalTrans.GetItemNumber(llRowPos, 'Lines') - ll_BakeryInLines)
			lsOutOrders = string(long(ldsTotalTrans.GetItemString(llRowPos, 'OutOrders')) - ll_BakeryOutOrders)
			lsOutLines = string(long(ldsTotalTrans.GetItemString(llRowPos, 'OutLines')) - ll_BakeryOutLines)
			llTrans = long(lsInOrders) + long(lsInLines) + long(lsOutOrders) + long(lsOutLines)
			lsTransactions = String(llTrans)
			lsOut = lsRollUp + ', ' + lsInOrders + ', ' + lsInLines + ', ' + lsOutOrders + ', ' + lsOutLines + ', ' + lsTransactions + ', Non-Bakery'
			liRC = FileWrite(liFileNo, lsOut)
			//now the 'Bakery' transactions
			llTrans = ll_BakeryInOrders + ll_BakeryInLines + ll_BakeryOutOrders + ll_BakeryOutLines
			lsTransactions = String(llTrans)
			lsOut = lsRollUp + ', ' + string(ll_BakeryInOrders) + ', ' + string(ll_BakeryInLines) + ', ' + string(ll_BakeryOutOrders) + ', ' + string(ll_BakeryOutLines) + ', ' + lsTransactions + ', Bakery'
		else
			lsInOrders = string(ldsTotalTrans.GetItemNumber(llRowPos, 'Orders'))
			lsInLines = String(ldsTotalTrans.GetItemNumber(llRowPos, 'Lines'))
			lsOutOrders = ldsTotalTrans.GetItemString(llRowPos, 'OutOrders')
			lsOutLines = ldsTotalTrans.GetItemString(llRowPos, 'OutLines')
			llTrans = long(lsInOrders) + long(lsInLines) + long(lsOutOrders) + long(lsOutLines)
			lsTransactions = String(llTrans)
			//lsOut = lsProject + ', ' + lsWH + ', ' + lsRollUp + ', ' + lsInOrders + ', ' + lsInLines
			lsOut = lsRollUp + ', ' + lsInOrders + ', ' + lsInLines + ', ' + lsOutOrders + ', ' + lsOutLines + ', ' + lsTransactions
		end if
	
		liRC = FileWrite(liFileNo, lsOut)
	/*
		If liRC < 0 Then
			lsLogOut = "      ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
			FileWrite(gilogFileNo,lsLogOut)	
			uf_write_Log(lsLogOut) /*display msg to screen*/
			uf_send_email(lsDir[llDirPos],'Filexfer'," - ***** Unable to Write to File",lsLogOut,'') /*send an email msg to the file transfer error list*/
		End If
	*/
		//lsFileName = lsFilePrefix + String(ldBatchSeq,'000000') + '.DAT'
		//ldsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	next /*next output record */
	/* 12/01/05 - Having issues with the attachment. It worked at least once
		and works if I run the blat command from cmd prompt (in tBlat.bat). */
	FileClose(liFileNo) /*close the file*/
	uf_send_email("MonthlyTrans","CustVal","SIMS Transactions for " + string(ldtFrom, 'mmmm'), "Attached are the SIMS Transactions for " + string(ldtFrom, 'mmmm'), lsFileName)
end if

/*Need to find the first Business day of the next month.
  so far, just getting the first weekday of the next month (ignoring Holidays)
  - Maybe a NextMonthStart function (with some sort of Holiday indicator)
    to get the first day of the next month.
  */

//ldNextDate = ldNextDate
liMonth = month(Date(lsNextRunDate))
liYear = year(Date(lsNextRunDate))
if liMonth = 12 then
	liMonth = 1
	liYear = liYear + 1
else
	liMonth = liMonth + 1
end if
lsNextRunDate = string(liMonth) + '-01-' + string(liYear)
liDayOfWeek = DayNumber(date(lsNextRunDate))
//DayNumber returns 1-7 (Sunday - Saturday).
lsDay = '01'
if liDayOfWeek = 1 then
	lsDay = '02'
ElseIf liDayOfWeek = 7 then
	lsDay = '03'
end if
lsNextRunDate = string(liMonth) + '-' + lsDay +  '-' + string(liYear)
//Set 'From' and 'To' - Assume it's just the next month
lsFrom = lsTo //string(liMonth) + '-01-' + string(liYear)
liMonth = month(Date(lsTo))
liYear = year(Date(lsTo))
if liMonth = 12 then
	liMonth = 1
	liYear = liYear + 1
else
	liMonth = liMonth + 1
end if
lsTo = string(liMonth) + '-01-' + string(liYear)
//could loop until Month(tDate) changes...

//SetProfileString(asIniFile,'3com_NASH','DBOHNEXTDATE-HKG',String(ldtNextRunDate,'mm-dd-yyyy'))
SetProfileString(gsIniFile, 'MONTHLYTRANS', 'NextRunDate', lsNextRunDate)
SetProfileString(gsIniFile, 'MONTHLYTRANS', 'FromDate', lsFrom)
SetProfileString(gsIniFile, 'MONTHLYTRANS', 'ToDate', lsTo)
//08/24/05 */
Return 0

end function

public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments);String	lsDistribList,	lsTemp, 	lsOutPut, lsReturn, lsCommand, lsAttachments, lsSubject, lsmailhostServerName 
			
Long		llArrayPos

OleObject wsh
integer  li_rc

CONSTANT integer MINIMIZED = 2
CONSTANT boolean WAIT = TRUE


// 03/05 - PCONKL - Changed to use BLAT batch commands instead of going through Outlook.


//Get the Distrib LIst, replace any semi colons with commas

Choose Case Upper(AsDistriblist)
		
	Case 'SYSTEM' /*send message to the system distribution List*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","SYSEMAIL","")
	Case 'CUSTVAL' /*Send a customer validation message - including error files*/
		lsDistribList = ProfileString(gsinifile,asProject,"CUSTEMAIL","")
	Case 'FILEXFER' /*Send a msg to file transfer error list*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","FilexferMAIL","")
	Case Else /*Custom User or list passed in parm*/
		If Pos(AsDistriblist,'@') > 0 Then
			lsDistribList = AsDistribList
		Else
			lsDistribList = ProfileString(gsinifile,asProject,AsDistriblist,"")
		End If
		
End Choose

Do While Pos(lsDistribList,';') > 0
	lsDistribList = Replace(lsDistribList,Pos(lsDistribList,';'),1,',')
Loop

If isNull(lsDistribList) or lsDistribList = '' or lsDistribList = "No Email" Then
	lsOutput = "          - No entries in distribution list for this project. Email notification not sent."
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	
	Return 0
End If

//17-APR-2017 :Madhu -PEVS-582 Get MailHostServerName
lsmailhostServerName =ProfileString(gsinifile, "SIMS3FP","MailHostServerName","")

//Create the command line prompt
lsCommand = "blat -"

//Add From
lsCommand += ' -f "SIMS Sweeper SA <simssweeperSA@xpo.com>" '

//Add Subject

//2019/05/31  - S33973  - Added a global email subjuct line to allow customization within a process
If not isNull(gsEmailSubject) and  gsEmailSubject <> '' Then
	lsSubject = gsEmailSubject + ' (' + gsEnvironment + '/' + asProject +  ')'
	gsEmailSubject = ''
Else
	lsSubject = assubject + ' (' + gsEnvironment + '/' + asProject +  ')'
End If

lsCommand += ' -s "' + lsSubject + '"'

//add dist list
lsCommand += ' -t "' + lsDistribList + '"'

//supress + servername
// 3/11/10 lsCommand += " -q -noh2 -server mailhost.cnf.com "
//lsCommand += " -q -noh2 -server mailhost.con-way.com " //14-APR-2017 :Madhu -PEVS-582 Change mail host for Sweeper
lsCommand += " -q -noh2 -server "+lsmailhostServerName+" " //14-APR-2017 :Madhu -PEVS-582 Change mail host for Sweeper

//Log File
lsCommand += " -log " + isEmailLogFile + " -timestamp "

//Body of Message
lsCommand += ' -body "' + asText + '"'

//Any attachments...
lsAttachments = asAttachments

/* 12/14/05 - commented out for check-in....
/* dts - create zip file here?
	Need some trigger (indicator?) to decide if we're zipping?
	Should we ALWAYS zip?
	Zip based on some size threshold?
	 - ?Do we want to scroll through list and add up file sizes? (i = FileLength(fn))
	Always zip if there are mulitple files?
	Zip data file but not ERR file?
	Some combination of the above (configurable?)?
	How will this impact customers?
	 - Does anybody automate processing e-mailed files?
	 
*/
string lsZipList, lsZipFile

//TEMP!!! ??? Need some trigger (indicator) to decide if we're zipping???
lsZipList = lsAttachments
//use the first filename (without extension) for zip file name...
//  ??? What if path has a '.'  ???
lsZipFile = left(lsZipList, Pos(lsZipList, '.') - 1) + '.zip'
Do While Pos(lsZipList,',') > 0
	// want list of attachments separated by space for zipping...
	lsZipList = Replace(lsZipList, Pos(lsZipList, ','), 1, ' ')	
Loop

if lsZipList > '' then
	li_rc = uf_zipper(lsZipList, lsZipFile)
	lsAttachments = lsZipFile
else
	Do While Pos(lsAttachments,';') > 0
		lsAttachments = Replace(lsAttachments,Pos(lsAttachments,';'),1,',')	
	Loop
end if
*/

Do While Pos(lsAttachments,';') > 0
	lsAttachments = Replace(lsAttachments,Pos(lsAttachments,';'),1,',')	
Loop

If lsAttachments > '' Then
	lsCommand += " -attach " + lsAttachments
End If

//Send the message
//TAM Send the message in sequence instead of parallel
//wsh = CREATE OleObject
//li_rc = wsh.ConnectToNewObject( "WScript.Shell" )
//li_rc = wsh.Run(lsCommand , Minimized, WAIT)

Run(lsCommand, minimized!)

lsOutput = "          - Mail sent to: (" + asDistribList + "): " + lsDistribList
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

//TimA 12/22/11
yield()
lsOutput = "          - PLEASE WAIT!!: " 
uf_write_Log(lsOutput) /*display msg to screen*/

sleep(10)

Return 0
end function

public function integer uf_check_running ();
ulong ll_mutex, ll_err 
string ls_mutex_name 
Long ll_handle 

ll_handle = handle (GetApplication(), false) 

if ll_handle <> 0 then 
	
    ls_mutex_name =  "simsfp" + char (0)        //Application name = DisplayName from app object 


   // Create the mutex. Since we're not going to do anything with 
   // it, ignore the first two arguments 
      ll_mutex = CreateMutexA (0, 0, ls_mutex_name) 
      ll_err = GetLastError () 

	if ll_err = 183 then 
      return -1 
   end if 
	
end if 
	//TimA 12/22/11
	yield()

return 0 



end function

public function integer uf_zipper (string asfilelist, string aszipfile);string lsCommand, lsOutput

/*
//Parse file list ...
lsFileList = asFileList
Do While Pos(lsFileList,';') > 0
	lsFileList = Replace(lsFileList, Pos(lsFileList,';'),1,',')
Loop
If lsFileList > '' Then
	lsCommand += " -attach " + lsFileList
End If
*/

//Create the command line prompt
//lsCommand = "winzip32 -a " + asZipFile + " " + asFileList
//lsCommand = "wzzip -a " + asZipFile + " " + asFileList
lsCommand = '"c:\program files\winzip\wzzip" -a ' + asZipFile + ' ' + asFileList

Run(lsCommand, minimized!)

lsOutput = "          - File(s) zipped into " + asZipFile
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/
//TimA 12/22/11
yield()

return 0
end function

public function integer uf_validate_batch_transactions ();/*
Validate that the Order confirmation created an associated GR Batch Transaction record
AMS-MUSER experienced a situation where a GR file was not interfaced with MarcGT (because of no batch transaction)
We want to pro-actively catch this if it happens again.

If a batch transaction is missing, manually insert it...
	insert into batch_transaction(project_id, trans_type, trans_order_id, trans_status, trans_create_date, trans_parm)
	values('AMS-MUSER', 'GR', 'AMS-MUSER005153', 'N', getdate(), '')
	
09/11/07 - Now validating 'GI' and 'GS' transactions as appropriate (see w_do.ue_confirm for criteria)
 - 3COM 
   - Eersel (WH = 3COM-NL): Create 'GI' record at 'Ready To Ship' and 'GS' record at 'Complete' 
	- Nashville & Singapore: Create GI at 'Complete'
 - AMS-MUSER: create 'GS' records at Complete
 - ?What about other Projects? Are we only worried about those sending MarcGT files?
    - Should expand this to be configurable at Project (WH?) and for all those sending transactions!
*/

string 		lsLogOut, sql_syntax, lsWhereProjects, errors, lsNextRunDate, lsNextRunTime, lsInterval, lsMsg, lsDays, lsProjects
Datastore 	ldsTransactions
long			llRowCount, llRowPos
DateTime		ldtNextRunTime
Date			ldtNextRunDate
integer rc


/* Need to grab dates from ini file */
lsNextRunDate = ProfileString(gsinifile, 'ValidateBatchTrans', "NextRunDate", "")
lsNextRunTime = ProfileString(gsinifile, 'ValidateBatchTrans', "NextRunTime", "")
lsDays = ProfileString(gsinifile, 'ValidateBatchTrans', "Days", "")
lsProjects = ProfileString(gsinifile, 'ValidateBatchTrans', "Projects", "")
//leading and trailing apostrophes aren't making it to lsProjects from ini file. Add them here...
lsProjects = "'" + lsProjects + "'"
If trim(lsNextRunDate) = '' or trim(lsNextRunTime) = '' or (not isdate(string(Date(lsNextRunDate)))) or (not isTime(string(Time(lsNextRunTime)))) Then /*not scheduled to run*/
	Return 0
Else /*valid date*/
	ldtNextRunTime = DateTime(Date(lsNextRunDate),Time(lsNextRunTime))
	If ldtNextRunTime > dateTime(today(),now()) Then /*not yet time to run*/
		lsLogOut = "- PROCESSING FUNCTION: Validate Batch Transactions...Not scheduled to run at this time. - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		Return 0
	End If
End If
if lsDays = "" then lsDays = "3"

/*temp comment
// Check_Trans(In/Out, Project List, WH List, Date Field, Trans Type, Days)
//Inbound - Goods Receiptes...
rc = Check_Trans('IN', '3COM,AMS-MUSER', '', 'Complete_Date', 'GR', lsDays)
//Outbound
//Marc GT records for Eersel
rc = Check_Trans('OUT', '3COM', '3COM-NL', 'Carrier_Notified_Date', 'GI', lsDays)
//Ship Confirmations to 3COM for Eersel
rc = Check_Trans('OUT', '3COM', '3COM-NL', 'Complete_Date', 'GS', lsDays)
//Ship Confirmations to 3COM for Nashville & Singapore
rc = Check_Trans('OUT', '3COM', 'NASHVILLE, 3COM-SIN', 'Complete_Date', 'GI', lsDays)
//Ship Confirmations for AMS-MUSER
rc = Check_Trans('OUT', 'AMS-MUSER', '', 'Complete_Date', 'GS', lsDays)

 Implementing 'Check_Trans' subroutine...
temp comment (comment out below when turning on calls to Check_Trans*/
//Create the Transactions datastore dynamically (no physical datastore object)
ldsTransactions = Create Datastore

/*--------------------------------------------------------------------------------------
 - Inbound.... */
sql_syntax = "select Project_ID, count(project_id) MissingTrans from receive_master"
lsWhereProjects = " where project_id in (" + lsProjects + ")"
sql_syntax += lsWhereProjects
sql_syntax += " and complete_date > getdate() - " + lsDays
sql_syntax += " and complete_date < getdate() - .1" //(to prevent catching one for which the transaction is being created right now. one was caught in testing)
sql_syntax += " and ro_no not in(select trans_order_id from batch_transaction"
//test..sql_syntax += " and ro_no in(select trans_order_id from batch_transaction"
sql_syntax += lsWhereProjects
sql_syntax += " and trans_type = 'GR')"
sql_syntax += " group by project_id"

//messagebox("TEMPO", sql_syntax)
ldsTransactions.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
//	messagebox("TEMPO", "*** Unable to create datastore for Transactions.~r~r" + Errors)
   lsLogOut = "        *** Unable to create datastore for missing Batch Transactions.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
END IF

ldsTransactions.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo, lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Validate Batch Transactions. - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve the Batch Transaction Data
lsLogout = 'Retrieving Missing Batch Transaction Data for Inbound.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsTransactions.Retrieve()

lsLogOut = String(llRowCount) + ' Projects with Missing Batch Transaction Rows were found.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

if llRowCount > 0 then
	if llRowCount = 1 then
		lsMsg = '1 Project with Missing Batch Transaction Rows was found.' + '~n'
	else
		lsMsg = String(llRowCount) + ' Projects with Missing Batch Transaction Rows were found.' + '~n'
	end if
	For llRowPos = 1 to llRowCount		
		lsMsg += '~n' + ldsTransactions.GetItemString(llRowPos, 'project_id') + ': ' + string(ldsTransactions.GetItemNumber(llRowPos, 'MissingTrans'))
	next
	lsMsg += '~n~n----------------------------------------------------------'
	lsMsg += '~nModify query below to get details (eliminate the Group By):~n~n' + sql_syntax
	uf_send_email('XX', 'System', 'Missing Batch Transactions.', lsMsg, '')
end if


/*Temp - waiting to turn on Outbound Validation...
/* --------------------------------------------------------------------------------------
 - 09/11/07 - Added validation of Outbound transactions (GS, GI). 
  - 3COM 
   - Eersel (WH = 3COM-NL): Create 'GI' record at 'Ready To Ship' and 'GS' record at 'Complete' 
	- Nashville & Singapore: Create GI at 'Complete'
 - AMS-MUSER: create 'GS' record at Complete
*/

//Why are not all orders for ams-muser creating 'GS' records? BATCH PICKING/CONFIRMATION!!!
sql_syntax = "select Project_ID, count(project_id) MissingTrans from delivery_master"
//lsWhereProjects = " where project_id in (" + lsProjects + ")"
sql_syntax += lsWhereProjects
sql_syntax += " and complete_date > getdate() - " + lsDays
sql_syntax += " and complete_date < getdate() - .1" //(to prevent catching one for which the transaction is being created right now. one was caught in testing)
sql_syntax += " and do_no not in(select trans_order_id from batch_transaction"
//test..sql_syntax += " and do_no in(select trans_order_id from batch_transaction"
sql_syntax += lsWhereProjects
sql_syntax += " and trans_type = 'GI')"
sql_syntax += " group by project_id"

messagebox("TEMPO", sql_syntax)
ldsTransactions.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
IF Len(Errors) > 0 THEN
//	messagebox("TEMPO", "*** Unable to create datastore for Transactions.~r~r" + Errors)
   lsLogOut = "        *** Unable to create datastore for missing Batch Transactions.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
END IF

ldsTransactions.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo, lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Validate Batch Transactions. - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve the Batch Transaction Data
lsLogout = 'Retrieving Missing Batch Transaction Data for Inbound.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsTransactions.Retrieve()

lsLogOut = String(llRowCount) + ' Projects with Missing Batch Transaction Rows were found.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

if llRowCount > 0 then
	if llRowCount = 1 then
		lsMsg = '1 Project with Missing Batch Transaction Rows was found.' + '~n'
	else
		lsMsg = String(llRowCount) + ' Projects with Missing Batch Transaction Rows were found.' + '~n'
	end if
	For llRowPos = 1 to llRowCount		
		lsMsg += '~n' + ldsTransactions.GetItemString(llRowPos, 'project_id') + ': ' + string(ldsTransactions.GetItemNumber(llRowPos, 'MissingTrans'))
	next
	lsMsg += '~n~n----------------------------------------------------------'
	lsMsg += '~nModify query below to get details (eliminate the Group By):~n~n' + sql_syntax
	uf_send_email('XX', 'System', 'Missing Batch Transactions.', lsMsg, '')
end if
...Temp - waiting to turn on Outbound Validation...*/


/*--------------------------------------------------------------------------------------*/
//Set the next time to run if Interval is set in ini file
lsInterval = ProfileString(gsIniFile, 'ValidateBatchTrans', 'Interval', '')

If isnumber(lsInterval) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = RelativeDate(today(), Long(lsInterval)) /*relative based on today*/
	SetProfileString(gsIniFile, 'ValidateBatchTrans', 'NextRunDate', String(ldtNextRunDate, 'mm-dd-yyyy'))
Else
	SetProfileString(gsIniFile, 'ValidateBatchTrans', 'NextRunDate', '')
End If
//TimA 12/22/11
yield()

Return 0

end function

public function integer check_trans (string asin_out, string asproject, string aswh, string asdate_field, string astrans_type, string asdays);string lsSQL, lsTable, lsLogOut, lsMsg, Errors, lsOrderField
Datastore 	ldsTransactions
long			llRowCount, llRowPos

if asIn_Out = 'IN' then
	lsTable = 'receive_master'
	lsOrderField = 'ro_no'
else
	lsTable = 'Delivery_Master'
	lsOrderField = 'do_no'
end if
lsSQL = "select Project_ID, count(project_id) MissingTrans from " + lsTable
lsSQL += " where project_id in('" + asProject + "')"
if asWH <> '' then
	lsSQL += " and wh_code in ('" + asWH + "')"
end if
lsSQL += " and " + asDate_Field + " > getdate() - " + asDays
lsSQL += " and " + asDate_Field + " < getdate() - .1" //(to prevent catching one for which the transaction is being created right now. one was caught in testing)
lsSQL += " and " + lsOrderField + " not in(select trans_order_id from batch_transaction"
//to test... lsSQL += " and " + lsOrderField + " in(select trans_order_id from batch_transaction"
lsSQL += " where project_id in('" + asProject + "')"
lsSQL += " and trans_type = '" + asTrans_Type + "')"
lsSQL += " group by project_id"

ldsTransactions = Create Datastore
ldsTransactions.Create(SQLCA.SyntaxFromSQL(lsSQL, "", Errors))
IF Len(Errors) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for missing Batch Transactions.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
END IF

ldsTransactions.SetTransObject(SQLCA)

/*
lsLogOut = ""
FileWrite(gilogFileNo, lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Validate Batch Transactions. - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
*/

//Retrieve the Batch Transaction Data
lsLogout = "  Retrieving Missing Batch Transaction ('" + asTrans_Type + "') Data for " + asIn_Out + "-bound (Project: " + asProject
if asWH <> "" then lsLogOut += ", WH: " + asWH
lsLogOut += ")....."
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsTransactions.Retrieve()

lsLogOut = '  - ' + String(llRowCount) + ' Project(s) with Missing Batch Transaction Rows were found.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

if llRowCount > 0 then
	if llRowCount = 1 then
		lsMsg = '1 Project with Missing Batch Transaction Rows was found.' + '~n'
	else
		lsMsg = String(llRowCount) + ' Projects with Missing Batch Transaction Rows were found.' + '~n'
	end if
	For llRowPos = 1 to llRowCount		
		lsMsg += '~n' + ldsTransactions.GetItemString(llRowPos, 'project_id') + ': ' + string(ldsTransactions.GetItemNumber(llRowPos, 'MissingTrans'))
	next
	lsMsg += '~n~n----------------------------------------------------------'
	lsMsg += '~nModify query below to get details (eliminate the Group By):~n~n' + lsSQL
	uf_send_email('XX', 'System', 'Missing Batch Transactions.', lsMsg, '')
end if

return llRowCount

end function

public function integer uf_process_flatfile_outbound_unicode (ref datastore adw_output, string asproject);//Process outbound Flat files - if passed in a datawindow, we dont need to retrieve becuase the DW is still in memory
//													and not saved to DB



String	lsLogOut, lsProject, 	lsDirList, lsPathOut, lsFileOut,lsErrorPath, lsDefaultPath,	&
			lsData, lsOrigFileName,	lsNewFileName,	lsFileSequence, lsFileSequenceHold, lsFilePrefix, &
			lsFileSuffix, lsFileExtension, lsDestPath, lsDestCD, lsTmpFileName, lsFileExt

String   ls_userfield21,ls_userfield13, lsPathArray[]

Long		llArrayPos,	&
			llDirPos	,	&
			llRowCount,	&
			llRowPos,	&
			llFileNo,	&
			llRC
			
Long		llNextPathPos,llPos	,lldirlist		
//Jxlim 02/02/2013 Changed Integer to Long
//Integer	liFileNo,	&
//			liRC

Boolean	bRet

//Jxlim 02/02/2013 Sybase;FileWriteExEx is maintained for backward compatibility. Use the FileWriteExExEx function for new development.

//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = '- PROCESSING FUNCTION: Extract Outbound Flat Files'
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = ''
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//
//lsLogOut = '   Project: ' + asProject 
//FileWriteEx(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/

lsProject = asProject

lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'

//29-Sep-2014 :Madhu- KLN B2B Conversion to SPS - START
//If DM.UF21 =SPS then store o/p file into flatfiledirout\SPS
//If asProject ='KLONELAB' Then
//
//	select User_Field21 into :ls_userfield21
//	From Delivery_Master
//	Where Project_Id= :asProject
//	and Do_No=:gsdono;
//
//	select User_Field13 into :ls_userfield13
//	From Receive_Master
//	Where Project_Id= :asProject
//	and Ro_No=:gsRoNo;
//	
//	lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") //stripoff '\'
//	
//  //get all path lists into an array
//	Do While Pos(lsPathOut,',') > 0 
//		llNextPathPos++
//		lsPathArray[llNextPathPos] = Left(lsPathOut,(Pos(lsPathOut,',') - 1))
//		lsPathOut = Right(lsPathOut, (len(lsPathOut) - Pos(lsPathOut,',')))
//	Loop
//	
//	lsPathArray[llNextPathPos +1] = Right(lsPathOut, (len(lsPathOut) - Pos(lsPathOut,','))) //Append last path into array list
//	
//	//get required path
//	For lldirlist =1 to Upperbound(lsPathArray)
//		llPos = Pos(lsPathArray[lldirlist],'\SPS')
//		IF (ls_userfield21 ='SPS' or ls_userfield13 ='SPS') and llPos >0 Then
//			lsPathOut = lsPathArray[lldirlist] + '\'
//		ELSE 
//			IF (ls_userfield21 <> 'SPS' or ls_userfield13 <> 'SPS') and llPos =0 Then
//				lsPathOut = lsPathArray[lldirlist] + '\'
//			END IF
//		END IF
//	Next
//END IF
//29-Sep-2014 :Madhu- KLN B2B Conversion to SPS - END
	
llRowCount = adw_output.RowCount()
	
uf_write_log('     ' + string(llRowCount) + ' Rows were retrieved for flatfile output...')
	
If llRowCount > 0 Then
	
	adw_Output.Sort() /* make sure we're sorted by batch seq so we only open an output file once */
		
	lsFileSequenceHold = ''
	
	//For each row, stream the data to the output file
	For llRowPos = 1 to llRowCount
		
		//If BatchSeq has changed, close current file and create a new one
		lsFileSequence = String(adw_output.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
		
		If lsFileSequence <> lsFileSequenceHold Then
			
				//Close the existing file (if it's the first time, fileno will be 0)
				If llFileNo > 0 Then					
					FileClose(llFileNo) /*close the file*/					
					//Jxlim 02/13/2013 Remove .TMP extension when file is closed due to BatchSeq has changed
					//Jxlim 02/13/2013 Baseline - Copy to lsFileOut. Remove .TMP ext and, use original file extension
					lsFileExt = Right(lsFileOut, 4)
					If Upper(Trim(lsFileExt)) ='.TMP' Then
						lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
						lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
						lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension						
						
						//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
						If FIleExists(lsOrigFileName) Then
							FileDelete(lsOrigFileName)
							lsLogOut = Space(10) + "***Unicode -File Sequence; Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."		
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End if
						//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
						bret=MoveFile(lsTmpFileName, lsOrigFileName)
						//Jxlim 01/23/2012 write message on rename status
						If Bret Then
							lsLogOut = Space(10) + "Unicode -File sequence has changed and File data successfully replaced and renamed to Original Extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to rename*/
							lsLogOut = Space(10) + "***Unicode -File sequence has changed but Unable to replaced/renamed .TMP file data to Original Extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If		
						
						//Extract the file
						lsLogOut = Space(10) + "Unicode -File sequence has changed and Flat File data successfully extracted to: " + lsPathOut + lsFileOut
						FileWriteEx(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
					
						//Archive the file
						lsOrigFileName = lsPathOut + lsFileOut
						//MA 12/08 - Added .txt to file
						lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + '.txt'
						
						If FIleExists(lsNewFileName) Then
							lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
						End IF
						
						bret=CopyFile(lsOrigFileName,lsNewFileName,True)					
						//Jxlim 02/13/2012 write message on archive status
						If Bret Then
							lsLogOut = Space(10) + "Unicode -File sequence has changed and File archived to: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to archive*/
							lsLogOut = Space(10) + "***Unicode -File sequence has changed but Unable to archive File: " + lsNewFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If						
						
					End If //Jxlim 02/13/2013  File Sequence has changed; closed the file; end of .TMP removed on this section					
				End If /*not first time*/
				
				// 10/03 - Pconkl - we may have different output paths depending on the dest_Cd field in the output file
				lsDestPAth = ''
				If adw_output.GetItemString(llRowPos,'Dest_cd') > '' Then
					lsDestCd = "flatfileout-" + 	adw_output.GetItemString(llRowPos,'Dest_cd')
					lsDestPath = ProfileString(gsinifile,lsProject,lsDestCd,"")
				Else
					lsDestPath = ''
				End IF
	
				If lsDestPath > '' Then
					lsPAthout = lsDestPath + '\'
				Else
					//If asProject <> 'KLONELAB' Then //29-Sep-2014 :Madhu- KLN B2B Conversion to SPS -START
						lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout","") +'\'
					//END IF  //29-Sep-2014 :Madhu- KLN B2B Conversion to SPS - END
				End If
		
				// 05/03 - PCONKL - we may have a specific prefix, suffix (after the seq #, or file extension
					
				//Prefix
				lsFilePRefix = ProfileString(gsinifile,lsProject,"flatfileoutprefix","")
				If isNull(lsFilePrefix) or lsFilePrefix = '' Then
					lsFilePrefix  = Left(adw_output.GetItemString(llRowPos,'batch_data'),2)
				End If
				
				//Suffix
				lsFilesuffix = ProfileString(gsinifile,lsProject,"flatfileoutsuffix","")
				If isNull(lsFilesuffix) Then	lsFilesuffix  = ''
	
				//Extension
				lsFileExtension = ProfileString(gsinifile,lsProject,"flatfileoutextension","")
				If isNull(lsFileExtension) or lsFileExtension = '' Then
					lsFileExtension  = ".dat"
				End If
				
				//Build file name
				lsFileOut = lsFilePrefix + lsFileSequence + lsFileSuffix + lsFileExtension
	
				//We may have the file name specified in the datastore
				If adw_output.GetItemString(llRowPos,'file_name') > '' Then
					lsFileOut = adw_output.GetItemString(llRowPos,'file_name')
				End If
	
				lsErrorPath = ""				
				
				//Jxlim 01/15/2013 Baseline changed - 
				//Notes: The file name exist on datastore but really the file has not exist on directory as yet.
				//During the process of writing flatfileout, we need to name the file ext with .TMP
				//to prevent file from grabbed by in the middle of writing. When is done writing we will have to remove .TMP so the file will be pick up by downstream as it should.				
									
				//Jxlim 05/27/2011If Pandora-Worlship Replace (Overwrite) for existing file				
				If lsFileOut = 'UPSFREIGHTIN' + '.csv'	 Then  /*Replace existing records*/	
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Replace!)  //Jxlim 02/12/2012 default Ansi! don't need UTF parameter
				Else	
					//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)  //Jxlim 02/12/2012 for unicode use UTF8 parameter
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing		
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF8!)  // Jxlim 02/11/2013 per Pete changed from EncodingUTF16LE! toEncodingUTF8!)
				End If
							//Jxlim 02/02/2013 Used Long instead of Interger, and added <= 0
							If llFileNO <=  0 Then
								
								//10/08 - PCONKL - If we can't open the specified file, try to write out to a default directory - This probably only should happen if we are trying to write directly to a remote drive that might not be available.
								lsErrorPath =  lsPathOut + lsFileOut /*where we were trying to write to*/
								
								lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout-hold","") +'\' /*Where we store it locally until we can try again*/
														
								//Try to Open the backup file (local)
								//liFileNo = n(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)
								llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF8!)
								
								If llFileNO < 0 or lsPAthOut = "\" Then
								
									lsLogOut = "     ***Unable to open file: " + lsPathOut + lsFileOut + " For output to Flat File."
									If lsErrorPath > "" Then
										lsLogOut += "  *** Attempted to open originally as: " + lsErrorPath + " ***"
									End If
									
									FileWriteEx(gilogFileNo,lsLogOut)		
									uf_write_Log(lsLogOut) /*display msg to screen*/
									uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.",lsLogOut ,'') /*send an email msg to the file transfer error list*/
									Return -1
									
								Else /*backup is open, send email to file transfer to alert that it needs to be redropped*/
									
									uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.","Unable to open file: " + lsErrorPath + " for remote copy. File stored locally as: " + lsPathOut + lsFileOut + " and needs to be copied manually." ,'') /*send an email msg to the file transfer error list*/
									
								End IF
								
							End If
	
							lsLogOut = '     Unicode -File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
							FileWriteEx(gilogFileNo,lsLogOut)	
							uf_write_log(lsLogOut)		
			
		End If /*File Changed*/
		
		lsData = adw_output.GetItemString(llRowPos,'batch_data')		
		
		// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
		If (Not isnull(adw_output.GetItemString(llRowPos,'batch_data_2'))) and adw_output.GetItemString(llRowPos,'batch_data_2') > '' Then
			lsData += adw_output.GetItemString(llRowPos,'batch_data_2')
		End If
			
		llRC = FileWriteEx(llFileNo,lsData)
		
		If llRC < 0 Then
			lsLogOut = "     ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
			FileWriteEx(gilogFileNo,lsLogOut)	
			uf_write_Log(lsLogOut) /*display msg to screen*/
		End If
		
		lsFileSequenceHold = lsFileSequence
		
	Next /*data row*/
	

	If llFileNo > 0 Then
		FileClose(llFileNo) /*close the last/only file*/		
	End If
	
	//Jxlim 02/13/2013 Remove .TMP extension after closing the file	
	lsFileExt = Right(lsFileOut, 4)
	If Upper(Trim(lsFileExt)) ='.TMP' Then
		lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
		lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
		lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
	End If

	//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
	If  FIleExists(lsOrigFileName) Then
		FileDelete(lsOrigFileName)
		//Jxlim 02/20/2013 this message just for testing
		lsLogOut = Space(10) + "***Unicode - Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."	
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End if
	//bret=CopyFile(lsTmpFileName, lsOrigFileName,True)  //Copy file content from .TMP to the original file
	//bret=DeleteFile(lsTmpFileName)  //Delete .TMP file after copy to original
	//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
	bret=MoveFile(lsTmpFileName, lsOrigFileName)
	//Jxlim 01/23/2012 write message on rename status
	If Bret Then
		lsLogOut = Space(10) + "Unicode -File data successfully replaced and renamed to Original: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	Else /*unable to rename*/
		lsLogOut = Space(10) + "*** Unicode -Unable to replaced/renamed .TMP file data and .ext to Original File: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End If	

	//Jxlim 01/15/2013 Baseline - Remove .TMP ext and, use original file extension
	lsLogOut = Space(10) +"Unicode - Flat File data successfully extracted to: " + lsPathOut + lsFileOut
	FileWriteEx(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut) /*display msg to screen*/
		
	//Archive the last/only file
	lsOrigFileName = lsPathOut + lsFileOut
	//MA 12/08 - Added .txt to file
	IF ( asproject = 'PANDORA_DECOM' ) Then
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut
	Else 
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + ".txt"
	End If
	
	// 03/04 - PCONKL - Check for existence of the file in the archive directory already - rename if duplicated
	//								We are now sending constant file names to some users instead of unique names (peice of shit AS400)
	
	//04/10 - MEA - Since we are batching the records, we only want to send the final file to Archive. 
	// 					 Delete any itermediate files.
	
	IF asproject <> 'WARNER' THEN

		If FileExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		End IF
	
	ELSE
	
		If FileExists(lsNewFileName) Then
			FileDelete ( lsNewFileName )
		END IF
	
	END IF
	
	Bret=CopyFile(lsOrigFileName,lsNewFileName,True)
				//Jxlim 01/23/2012 write message on archive status
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
		
Else /*no records to process for directory*/
		
		lsLogOut = "     There was no data to write for project: " + lsProject
		FileWriteEx(gilogFileNo,lsLogOut)
		uf_write_Log(lsLogOut) /*display msg to screen*/
		
End If /*records exist to output*/
gsFileName = lsNewFileName		//Sarun2014Mar20 : Record FileName to publish in batch_transaction Table
Return 0
end function

public function integer uf_create_soc_from_po (datastore ads_header, long al_row);/*

	This function creates an SOC from an inbound 3B2 if the following conditions are met:
	
			The project is Pandora
			The order is an electronic order
			The From owner = *SOIMIM
			The From/To owner warehouses are the same
			The Ship To is a Menlo customer code mapped to a Menlo warehouse.

	The function returns:
	
			0 	indicates this PO is not an SOC candidate
			1 	successfully created an SOC
			-1	error attempting to create SOC

*/

Integer li_return = 0
Long ll_from_owner_id, ll_prev_from_owner_id, ll_to_owner_id, ll_prev_to_owner_id
Long llDetailCount, ll_row, i
Decimal ldTONO
Boolean lb_mim_same_warehouse
String ls_to_warehouse, ls_from_warehouse
String ls_to_owner_cd, ls_from_owner_cd
String lsToNO

ls_from_owner_cd = ads_header.Object.user_field6[al_row]

// From owner must be *SOIMIM to create the SOC
if Upper(Right(ls_from_owner_cd,6)) <> 'SOIMIM' then
	return 0
end if

// Get From owner id
select owner_id 
into :ll_from_owner_id
from owner
where project_id = 'PANDORA'
and owner_cd = :ls_from_owner_cd;
if sqlca.sqlcode <> 0 then
	return uf_create_soc_from_po_error(ads_header,al_row,"System Error: unable to retrieve owner id for owner code: " + String(ls_from_owner_cd) )
end if

// From owner warehouse
select user_field2 
into :ls_from_warehouse
from customer
where cust_code = :ls_from_owner_cd
and customer_type = 'WH';
if sqlca.sqlcode <> 0 then
	return uf_create_soc_from_po_error(ads_header,al_row,"System Error: unable to retrieve warehouse for customer: " + ls_from_owner_cd )
end if

//if lb_mim_same_warehouse then

u_ds_datastore lsDODetail
lsDODetail = Create u_ds_datastore
lsDODetail.dataobject= 'd_po_detail'
lsDODetail.SetTransObject(SQLCA)

datastore lds_transfer_master
lds_transfer_master = Create datastore
lds_transfer_master.dataobject = 'd_transfer_master'
lds_transfer_master.SetTransObject(SQLCA)

datastore lds_transfer_detail
lds_transfer_detail = Create datastore
lds_transfer_detail.dataobject = 'd_transfer_detail'
lds_transfer_detail.SetTransObject(SQLCA)

llDetailCount = lsDODetail.Retrieve( ads_header.Object.project_id[al_row], ads_header.Object.edi_batch_seq_no[al_row], ads_header.Object.order_no[al_row] )
if llDetailCount < 1 then
	return 0
end if

// Create Transfer Detail

for i = 1 to llDetailCount

	if IsNumber(lsDODetail.Object.owner_id[i]) then
		ll_to_owner_id = Long(lsDODetail.Object.owner_id[i])
	else
		return uf_create_soc_from_po_error(ads_header,al_row,"Data Error: Owner ID is not numeric: " + String(lsDODetail.Object.owner_id[i]) )
	end if

	if ll_to_owner_id <> ll_prev_to_owner_id then
		
		// Determine if an SOC should be created

		select owner_cd
		into :ls_to_owner_cd
		from owner
		where project_id = 'PANDORA'
		and owner_id = :ll_to_owner_id;
		if sqlca.sqlcode <> 0 then
			return uf_create_soc_from_po_error(ads_header,al_row,"System Error: unable to retrieve owner code for To owner ID: " + String(ll_to_owner_id) )
		end if

		// To owner warehouse
		select user_field2 
		into :ls_to_warehouse
		from customer
		where cust_code = :ls_to_owner_cd
		and customer_type = 'WH';
		if sqlca.sqlcode <> 0 then
			return uf_create_soc_from_po_error(ads_header,al_row,"System Error: unable to retrieve warehouse for customer: " + String(ls_to_owner_cd) )
		end if

		// If a warehouse code is null or empty string, do not create the SOC
		if Not (Len(ls_to_warehouse) > 0 and Len(ls_from_warehouse) > 0) then
			return 0
		end if

		// From/To owner warehouses must be the same to create the SOC
		if Upper(Trim(ls_to_warehouse)) <> Upper(Trim(ls_from_warehouse)) then
			return 0
		end if

		if lsToNO = "" then
			sqlca.sp_next_avail_seq_no(ads_header.Object.project_id[al_row],"Transfer_Master","TO_No" ,ldTONO)
			if ldTONO <= 0 then
				return uf_create_soc_from_po_error(ads_header,al_row,"System Error: unable to obtain next sequence number: " + String(ldTONO) )
			end if

			lsToNO = ads_header.Object.project_id[al_row] + String(Long(ldToNo),"000000") 
		end if

		//ll_prev_from_owner_id = ll_from_owner_id
		ll_prev_to_owner_id = ll_to_owner_id
	end if
	
	ll_row = lds_transfer_detail.insertRow(0)

	lds_transfer_detail.Object.to_no[ll_row] = lsToNO

	// Validate SKU
	long ll_count
	string ls_sku
	ls_sku = lsDODetail.Object.sku[i]

	select count(*) 
	into :ll_count
	from Item_Master
	where project_id = 'PANDORA' 
	and sku = :ls_sku;

	If ll_count <=0 Then
		return uf_create_soc_from_po_error(ads_header,al_row,"Order Nbr/Line (detail): " + string(idsDOHeader.GetItemString(al_row,'Invoice_no')) + '/' + string(lsDODetail.Object.line_item_no[i]) + " Invalid SKU: " + ls_sku )
	End If
	lds_transfer_detail.Object.sku[ll_row] = 	ls_sku

	lds_transfer_detail.Object.supp_code[ll_row] = 'PANDORA'

	// Fields below are set per the #305  BRD v1.4
	lds_transfer_detail.Object.country_of_origin[ll_row] = 'XXX'
	lds_transfer_detail.Object.serial_no[ll_row] = '-'
	lds_transfer_detail.Object.lot_no[ll_row] = '-'
	lds_transfer_detail.Object.po_no[ll_row] = lsDODetail.Object.po_no[i]				// 3rd position of the DD record
	lds_transfer_detail.Object.po_no2[ll_row] = '-'
	lds_transfer_detail.Object.s_location[ll_row] = '*'
	lds_transfer_detail.Object.d_location[ll_row] = '*'
	lds_transfer_detail.Object.inventory_type[ll_row] = 'N'
	lds_transfer_detail.Object.quantity[ll_row] = Dec(lsDODetail.Object.quantity[i])	// 5th position of the DD record
	lds_transfer_detail.Object.container_id[ll_row] = '-'
	lds_transfer_detail.Object.expiration_date[ll_row] = Date( '12/31/2999')				// 12/31/2999  12:00:00 AM
	lds_transfer_detail.Object.line_item_no[ll_row] = i
	lds_transfer_detail.Object.owner_id[ll_row] = ll_from_owner_id
	lds_transfer_detail.Object.new_po_no[ll_row] = lsDODetail.Object.po_no[i]			// 3rd position of the DD record	
	lds_transfer_detail.Object.new_owner_id[ll_row] = ll_to_owner_id  					// Using 4th position of the DM record as the Owner_CD, get the Owner_ID from the Owner table
	lds_transfer_detail.Object.new_inventory_type[ll_row] = 'N'
	lds_transfer_detail.Object.user_line_item_no[ll_row] = lsDODetail.Object.line_item_no[i]	// 6th position of the DD record
next

// Create Transfer Master

datetime  ldtWHTime
ldtWHTime = f_getLocalWorldTime(ls_to_warehouse)

ll_row = lds_transfer_master.insertRow(0)

// Fields below are set per the #305  BRD v1.4
lds_transfer_master.Object.to_no[ll_row] = lsToNO
lds_transfer_master.Object.project_id[ll_row] = ads_header.Object.project_id[al_row]
lds_transfer_master.Object.ord_date[ll_row] = ldtWHTime
//lds_transfer_master.Object.complete_date[ll_row] = 				// not set
lds_transfer_master.Object.ord_status[ll_row] = 'N'
lds_transfer_master.Object.ord_type[ll_row] = 'O'
lds_transfer_master.Object.s_warehouse[ll_row] = ls_from_warehouse
lds_transfer_master.Object.d_warehouse[ll_row] = ls_to_warehouse
//lds_transfer_master.Object.user_field1[ll_row] = 					// not set
lds_transfer_master.Object.user_field2[ll_row] = ls_to_owner_cd		// ads_header.Object.user_field2[al_row]
lds_transfer_master.Object.user_field3[ll_row] = ads_header.Object.order_no[al_row]
lds_transfer_master.Object.user_field4[ll_row] = ""
lds_transfer_master.Object.user_field5[ll_row] = ""
lds_transfer_master.Object.remark[ll_row] = ads_header.Object.remark[al_row]
lds_transfer_master.Object.last_user[ll_row] = 'SIMSFP'
lds_transfer_master.Object.last_update[ll_row] = ldtWHTime
//lds_transfer_master.Object.dwg_upload[ll_row] = 					// not set
//lds_transfer_master.Object.dwg_upload_timestamp[ll_row] = 	// not set

if lds_transfer_master.Update() = 1 then
	if lds_transfer_detail.Update() = 1 then
		li_return = 1
	else
		Rollback;
		return uf_create_soc_from_po_error(ads_header,al_row,"System Error: updating transfer_detail")
	end if
else
	Rollback;
	return uf_create_soc_from_po_error(ads_header,al_row,"System Error: updating transfer_master")
end if

Commit;
	
return li_return

end function

public function integer uf_create_soc_from_po_error (datastore ads_header, long al_row, string as_error_message);// Update EDI Header/Detail errors

String ls_project_id, ls_invoice_no
decimal ls_edi_batch_seq_no

ads_header.SetITem(al_row,'status_cd','E')
ads_header.SetITem(al_row,'status_message',as_error_message)
ads_header.Update()

ls_project_id = ads_header.object.project_id[al_row]
ls_edi_batch_seq_no = ads_header.object.edi_batch_seq_no[al_row]
ls_invoice_no = ads_header.object.invoice_no[al_row]

Update edi_outbound_detail
Set Status_cd = 'E', status_message = 'Errors exist on Header.'
Where project_id = :ls_project_id and edi_batch_seq_no = :ls_edi_batch_seq_no and invoice_no = :ls_invoice_no and status_cd = 'N';

Commit;

Return -1

end function

public function integer uf_create_soc_from_mim (datastore ads_header, long al_row);/*

	When an Outbound flat file is received from MIM, and the From Owner = **SOIMIM and the To Owner is in the 
	same Menlo warehouse.  Menlo will create an SOC in SIMS. When Menlo Ops processes the SOC and moves the 
	inventory into a new bin location in the warehouse, SIMS will submit a SOC ack to Oracle confirming the owner change.

*/

integer li_return = 0	// 0 indicates this is not an SOC candidate, 1 successfully created an SOC, -1 error attempting to create SOC
boolean lb_mim_same_warehouse
String ls_to_warehouse, ls_from_warehouse
String ls_to_owner, ls_from_owner
String ls_soimim_implented

ls_to_owner = ads_header.Object.cust_code[al_row]
ls_from_owner = ads_header.Object.user_field2[al_row]

// A database flag indicates if this enhancement is ready to be deployed.
// The customer had a few false starts on this enhancement.
select code_descript
into :ls_soimim_implented
from lookup_table
where project_id = 'PANDORA'
and code_type = 'FLAG'
and code_id = 'OB_SOIMIM';

if Pos(ls_from_owner,'SOIMIM') > 0 and Upper(Trim(ls_soimim_implented)) = 'Y' then
	
	// To owner warehouse
	select user_field2 into :ls_to_warehouse
	from customer
	where cust_code = :ls_to_owner
	and customer_type = 'WH';
	if sqlca.sqlcode <> 0 then
		//return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: unable to retrieve warehouse for customer: " + String(ls_to_owner) )
		// LTK 20111108 Don't return error code if customer is not warehouse, let the DO get created from the calling function.
		return 0
	end if
	
	// From owner warehouse
	select user_field2 into :ls_from_warehouse
	from customer
	where cust_code = :ls_from_owner
	and customer_type = 'WH';
	if sqlca.sqlcode <> 0 then
		//return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: unable to retrieve warehouse for customer: " + String(ls_from_owner) )
		// LTK 20111108 Don't return error code if customer is not warehouse, let the DO get created from the calling function.
		return 0
	end if
		
	if Len(Trim(ls_to_warehouse)) > 0 and Upper(Trim(ls_to_warehouse)) = Upper(Trim(ls_from_warehouse)) then
		lb_mim_same_warehouse = TRUE
	end if
	
end if

if lb_mim_same_warehouse then

	long llDetailCount, ll_row, i
	decimal ldTONO
	string lsToNO
	
	u_ds_datastore lsDODetail
	lsDODetail = Create u_ds_datastore
	lsDODetail.dataobject= 'd_shp_detail'
	lsDODetail.SetTransObject(SQLCA)
	
	datastore lds_transfer_master
	lds_transfer_master = Create datastore
	lds_transfer_master.dataobject = 'd_transfer_master'
	lds_transfer_master.SetTransObject(SQLCA)
	
	datastore lds_transfer_detail
	lds_transfer_detail = Create datastore
	lds_transfer_detail.dataobject = 'd_transfer_detail'
	lds_transfer_detail.SetTransObject(SQLCA)

	llDetailCount = lsDODetail.Retrieve(	ads_header.Object.project_id[al_row], ads_header.Object.edi_batch_seq_no[al_row], ads_header.Object.invoice_no[al_row] )

	datetime  ldtWHTime
	ldtWHTime = f_getLocalWorldTime(ls_to_warehouse)
	
	ll_row = lds_transfer_master.insertRow(0)
	
	sqlca.sp_next_avail_seq_no(ads_header.Object.project_id[al_row],"Transfer_Master","TO_No" ,ldTONO)
	if ldTONO <= 0 then
		return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: unable to obtain next sequence number: " + String(ldTONO) )
	end if
	
	lsToNO = ads_header.Object.project_id[al_row] + String(Long(ldToNo),"000000") 
	
	// Process Transfer Master
	
	// Fields below are set per the #305  BRD v1.2
	lds_transfer_master.Object.to_no[ll_row] = lsToNO
	lds_transfer_master.Object.project_id[ll_row] = ads_header.Object.project_id[al_row]
	lds_transfer_master.Object.ord_date[ll_row] = ldtWHTime
	////lds_transfer_master.Object.complete_date[ll_row] = 				// not set
	lds_transfer_master.Object.ord_status[ll_row] = 'N'
	lds_transfer_master.Object.ord_type[ll_row] = 'O'
	lds_transfer_master.Object.s_warehouse[ll_row] = ls_from_warehouse
	lds_transfer_master.Object.d_warehouse[ll_row] = ls_to_warehouse
	////lds_transfer_master.Object.user_field1[ll_row] = 						// not set
	lds_transfer_master.Object.user_field2[ll_row] = ads_header.Object.user_field2[al_row]
	lds_transfer_master.Object.user_field3[ll_row] = ads_header.Object.invoice_no[al_row]
	lds_transfer_master.Object.user_field4[ll_row] = ""
	lds_transfer_master.Object.user_field5[ll_row] = ""
	lds_transfer_master.Object.remark[ll_row] = ads_header.Object.remark[al_row]
	lds_transfer_master.Object.last_user[ll_row] = 'SIMSFP'
	lds_transfer_master.Object.last_update[ll_row] = ldtWHTime
	////lds_transfer_master.Object.dwg_upload[ll_row] = 					// not set
	////lds_transfer_master.Object.dwg_upload_timestamp[ll_row] = 	// not set
	
	// Get To owner id
	long ll_to_owner_id
	
	select owner_id 
	into :ll_to_owner_id
	from owner
	where project_id = 'PANDORA'
	and owner_cd = :ls_to_owner;
	if sqlca.sqlcode <> 0 then
		return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: unable to retrieve owner id for owner code: " + String(ls_to_owner) )
	end if
	
	// Process Transfer Detail
	
	for i = 1 to llDetailCount
		ll_row = lds_transfer_detail.insertRow(0)

		lds_transfer_detail.Object.to_no[ll_row] = lsToNO

		// Validate SKU
		long ll_count
		string ls_sku
		ls_sku = lsDODetail.Object.sku[i]

		select count(*) into :ll_count
		from Item_Master
		where project_id = 'PANDORA' 
		and sku = :ls_sku;

		If ll_count <=0 Then
			return uf_create_soc_from_mim_error(ads_header,al_row,"Order Nbr/Line (detail): " + string(idsDOHeader.GetItemString(al_row,'Invoice_no')) + '/' + string(lsDODetail.Object.line_item_no[i]) + " Invalid SKU: " + ls_sku )
		End If
		lds_transfer_detail.Object.sku[ll_row] = 	lsDODetail.Object.sku[i]

		lds_transfer_detail.Object.supp_code[ll_row] = 'PANDORA'

		if IsNumber(lsDODetail.Object.owner_id[i]) then
			lds_transfer_detail.Object.owner_id[ll_row] = Long(lsDODetail.Object.owner_id[i])	// 7th position of the DD record as the Owner_CD, get the Owner_ID from the Owner table
		else
			return uf_create_soc_from_mim_error(ads_header,al_row,"Data Error: non numeric owner ID: " + String(lsDODetail.Object.owner_id[i]) )
		end if
		
		lds_transfer_detail.Object.country_of_origin[ll_row] = 'XXX'
		lds_transfer_detail.Object.serial_no[ll_row] = '-'
		lds_transfer_detail.Object.lot_no[ll_row] = '-'
		lds_transfer_detail.Object.po_no[ll_row] = lsDODetail.Object.po_no[i]			// 3rd position of the DD record
		lds_transfer_detail.Object.po_no2[ll_row] = ""
		lds_transfer_detail.Object.s_location[ll_row] = '*'
		lds_transfer_detail.Object.d_location[ll_row] = '*'
		lds_transfer_detail.Object.inventory_type[ll_row] = 'N'
		lds_transfer_detail.Object.quantity[ll_row] = Dec(lsDODetail.Object.quantity[i])	// 5th position of the DD record
		lds_transfer_detail.Object.container_id[ll_row] = '-'
		lds_transfer_detail.Object.expiration_date[ll_row] = Date( '12/31/2999')			// 12/31/2999  12:00:00 AM
		lds_transfer_detail.Object.line_item_no[ll_row] = i
		lds_transfer_detail.Object.new_po_no[ll_row] = lsDODetail.Object.po_no[i]		// 3rd position of the DD record	
		lds_transfer_detail.Object.new_owner_id[ll_row] = ll_to_owner_id  				// Using 4th position of the DM record as the Owner_CD, get the Owner_ID from the Owner table
		lds_transfer_detail.Object.new_inventory_type[ll_row] = 'N'
		lds_transfer_detail.Object.user_line_item_no[ll_row] = lsDODetail.Object.line_item_no[i]	// 6th position of the DD record
	next
	
	if lds_transfer_master.Update() = 1 then
		if lds_transfer_detail.Update() = 1 then
			li_return = 1
		else
			return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: updating transfer_detail")
		end if
	else
		return uf_create_soc_from_mim_error(ads_header,al_row,"System Error: updating transfer_master")
	end if

	Commit;
	
end if
	//TimA 12/22/11
	yield()

return li_return

end function

public function integer uf_create_soc_from_mim_error (datastore ads_header, long al_row, string as_error_message);// Update EDI Header/Detail errors

String ls_project_id, ls_invoice_no
decimal ls_edi_batch_seq_no

ads_header.SetITem(al_row,'status_cd','E')
ads_header.SetITem(al_row,'status_message',as_error_message)
ads_header.Update()

ls_project_id = ads_header.object.project_id[al_row]
ls_edi_batch_seq_no = ads_header.object.edi_batch_seq_no[al_row]
ls_invoice_no = ads_header.object.invoice_no[al_row]

Update edi_outbound_detail
Set Status_cd = 'E', status_message = 'Errors exist on Header.'
Where project_id = :ls_project_id and edi_batch_seq_no = :ls_edi_batch_seq_no and invoice_no = :ls_invoice_no and status_cd = 'N';

Commit;

Return -1

end function

public function boolean uf_max_trans_reached (string as_project_id);// LTK 20111117	This function will determine if the running tally of a Project's transactions are equal to the 
//	governing value in the lookup table.  If the values are equal, return TRUE so that no more of this project's
//	transactions are processed during this sweep.  To govern the maximum transactions for a project, 
//	insert an entry in the lookup_table such as:
//
//									project_id	code_type	code_id					code_descript	
//									COMCAST	PARM 		MAX_NUM_TRANS		200

boolean lb_max_reached
long ll_found_row

ll_found_row = ids_transaction_govenor.Find("project_id = '" + as_project_id + "'", 1, il_transaction_govenor_rows)

if ll_found_row > 0 then
	if ids_transaction_govenor.Object.co_tally[ll_found_row] = ids_transaction_govenor.Object.co_max_trans[ll_found_row] then
		lb_max_reached = TRUE
	else
		ids_transaction_govenor.Object.co_tally[ll_found_row] = ids_transaction_govenor.Object.co_tally[ll_found_row] + 1
	end if
end if

return lb_max_reached
end function

public function long uf_max_trans_init ();// LTK 20111117	This function initializes the datastore from the lookup_table values.

if IsValid(ids_transaction_govenor) then
	DESTROY ids_transaction_govenor
end if

ids_transaction_govenor = create datastore
ids_transaction_govenor.dataObject = 'd_batch_transaction_govenor'
ids_transaction_govenor.SetTransObject(SQLCA)

long i
il_transaction_govenor_rows = ids_transaction_govenor.Retrieve('PARM','MAX_NUM_TRANS')

// Init computed column to use as numeric
for i = 1 to il_transaction_govenor_rows
	if IsNumber(ids_transaction_govenor.Object.Code_Descript[i]) then
		ids_transaction_govenor.Object.co_max_trans[i] = Long(ids_transaction_govenor.Object.Code_Descript[i])
	else
		// Non numeric data in lookup_table, default value
		ids_transaction_govenor.Object.co_max_trans[i] = 200
	end if
next

return il_transaction_govenor_rows

end function

public function datetime uf_file_created_datetime (ref string as_filename);//BCR 13-MAR-2012: Function to obtain the creation datetime for a flat file.
//Pass in full file path_name, and return creation datetime.

String ls_path, ls_file, ls_test
DateTime ldt_ret1, ldt_ret2
OLEObject obj_shell, obj_folder, obj_item

obj_shell = CREATE OLEObject
obj_shell.ConnectToNewObject( 'shell.application' )

ls_path = Left( as_filename, LastPos( as_filename, "\" ) )
ls_file = Mid( as_filename, LastPos( as_filename, "\" ) + 1 )

IF FileExists( as_filename ) THEN
    obj_folder = obj_shell.NameSpace( ls_path )
    
    IF IsValid( obj_folder ) THEN
        obj_item = obj_folder.ParseName( ls_file )
        
        IF IsValid( obj_item ) THEN
            ls_test = obj_folder.GetDetailsOf( obj_item, 3 )//Modified date...just in case we ever need this in the future.
            ldt_ret1 = DateTime( ls_test )
		   ls_test = obj_folder.GetDetailsOf( obj_item, 4 )//Created date
            ldt_ret2 = DateTime( ls_test )
        END IF
    END IF
END IF

DESTROY obj_shell
DESTROY obj_folder
DESTROY obj_item

RETURN ldt_ret2


end function

public function integer uf_process_ftp_stuck_files (string asdirectory);
//BCR 14-MAR-2012: This function will look in FTP folders and send email if it finds files 
//older than INI-specified WaitTime.  Cloned from uf_process_ftp_outbound.
//ET3 27-APR-2012: Modify to only send one email once an hour max (no matter how many files) 

Integer	liRC, liTransferMode
			
Long		llArrayCount, llArrayPos, llCount, llFolderPos, lul_handle,	llFilePos,	llFileCount

String	lsLogOut, lsDirList,	lsDir[],	lsFiles[], lsCurrentFile, lsSaveFileName,	lsProject,		&
			lsInitArray[],lsPath,lsDirectory,lsTemp, lsCommand, lsTransferMode
datetime ldt_dttime		
time 		lt_time
ulong 	ll_dwcontext, l_buf, llCrap
boolean 	lb_currentdir, bRet, lbFTPError
str_win32_find_data str_find

boolean  lb_sendStuckMailNotification = TRUE

l_buf = 300

lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = '- PROCESSING FUNCTION - Checking for stuck Outbound FTP Files (' + asDirectory + '). - ' + String(Today(), "mm/dd/yyyy hh:mm:ss") 
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = ''
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//Get a list of all Projects to process
lsDirList = ProfileString(gsinifile, asDirectory, "directorylist","")

If isnull(lsDirList) or lsDirList = '' Then 
	lsLogOut = "  No projects found to process for " + asDirectory + "..."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	REturn 0
End If

//TODO: deal with 'spaces' and the random trailing ','
llArrayPos = 0
Do While Pos(lsDirList,',') > 0
	llArrayPos ++
	lsDir[llArrayPos] = Left(lsDirList,(Pos(lsDirList,',') - 1))
	lsDirList = Right(lsDirlist, (len(lsDirList) - Pos(lsDirList,',')))
Loop

llArrayPos ++
lsDir[llArrayPos] = lsDirList /*get the last/only one*/
		
//Process the requested FTP Directories
For llFolderPos = 1 to UpperBound(lsDir) /*For each Folder*/
	//TimA 12/22/11
	yield()

	If lsDir[llFolderPos] = '' Then Continue
	
	lsLogOut = "  Checking for stuck FTP files for Project: '" + lsDir[llFolderPos] + "'"
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get the project for the current folder from the profileString
	lsProject = ProfileString(gsinifile,lsDir[llFolderPos],"project","")
		
	//Get a list of the files to upload
	lsPath = ProfileString(gsinifile,lsDir[llFolderPos],"ftpfiledirout","")
		
	If isnull(lsPath) or lsPath = '' Then
		lsLogOut = "  No staging directory present - Skipping to Next project to process..."
		uf_write_log(lsLogOut) /*write to Screen*/
		FileWrite(gilogFileNo,lsLogOut)
		Continue /*next project folder to process*/
	End If
	
	lsLogOut = '      Upload Staging directory: ' + lspath
	FileWrite(giLogFileNo,lsLogOut)
	uf_write_log(lsLogOut)
	
	lsFiles = lsInitarray /*reinitialize array*/
	llFilePos = 0

	lsDirectory = lsPath + '\*.*' /* 12/03 - PCONKL */
	
	lul_handle = FindFirstFile(lsDirectory, str_find)
				
	If lul_handle > 0  Then/*first file found*/ 
		bREt = True
		do While  bret
			
			If Trim(Str_find.FileName) > ' ' and  Pos(Str_find.FileName,'.') > 0 and &
				Trim(Str_find.FileName) <> '.' and Trim(Str_find.FileName) <> '..' Then
					llFilePos ++
  					lsfiles[llFilePos] = str_find.filename
			End If
			
	 		bret = FindNextFile(lul_handle, str_find)	
		Loop
	End If
	
	If llFilePos = 0 Then /*No files found for processing*/
		lsLogOut = '        No files found in directory: ' + lsPath
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
	End If
	
	llFileCount = UpperBound(lsFiles[])
	
	If llFileCount <= 0 Then Continue //Skip processing if there are no files to Upload
		
	lsLogOut = Space(6) + String(llFileCount) + " Files found in directory for verification of freshness."
	uf_write_log(lsLogOut) /*write to Screen*/
	FileWrite(gilogFileNo,lsLogOut)
	
	//Get each file's timestamp. See if it is older than 1 hour and send email alert.
	For llFilePos = 1 to llFileCount /*for each file in the FTP Folder*/
		
		lsCurrentFile = lsPath + '\' + lsFiles[llFilePos]
		
		//Get timestamp
		ldt_dttime = THIS.uf_file_created_datetime(lsCurrentFile)
		
		//Is it older than 1 hour?
		lt_time = time(ldt_dttime)
				
		//ET3 5-Apr-2012: Modify to only send one email per project though continue to log for each file
		IF lb_sendStuckMailNotification AND ( RelativeDate(date(ldt_dttime), 1) < Today() ) THEN  //More than one day old...
			//Log
			lsLogOut = Space(10) + "*** Stuck FTPOUTBOUND File Alert for: " + lsPath
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			//Send email alert
			uf_send_email('XX','System','***SIMSFP - Stuck FTPOUTBOUND File Alert***', lsLogOut,'')
			lb_sendStuckMailNotification = FALSE
		ELSEIF RelativeTime(lt_time, 3600) < Now() THEN //Not more than day old. Check time...
			//Log
			lsLogOut = Space(10) + "*** Stuck FTPOUTBOUND File Alert for: " + lsPath
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			//Send email alert
			uf_send_email('XX','System','***SIMSFP - Stuck FTPOUTBOUND File Alert***', lsLogOut,'')
			lb_sendStuckMailNotification = FALSE
		END IF

		
		// ET3 5-Apr-2012: Modify to Log each file but only send 1 email per project
		IF RelativeDate(date(ldt_dttime), 1) < Today() THEN  //More than one day old...
			//Log
			lsLogOut = Space(10) + "*** Stuck FTPOUTBOUND File Alert for: " + lsCurrentFile
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			//Send email alert
			//uf_send_email('XX','System','***SIMSFP - Stuck FTPOUTBOUND File Alert***',lsLogOut,'')
			
		ELSEIF RelativeTime(lt_time, 3600) < Now() THEN   //Not more than day old. Check time...
			//Log
			lsLogOut = Space(10) + "*** Stuck FTPOUTBOUND File Alert for: " + lsCurrentFile
			uf_write_log(lsLogOut) /*write to Screen*/
			FileWrite(gilogFileNo,lsLogOut)
			//Send email alert
			//uf_send_email('XX','System','***SIMSFP - Stuck FTPOUTBOUND File Alert***',lsLogOut,'')
		END IF
				
	Next /*Next file to upload from current staging Folder */
	
Next /* Next FTP Folder to process*/

//Close the internet connection if Open - hopefully, clear cache
If il_hopen > 0 Then
	InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
End If

Return 0

end function

public function integer uf_check_running_ini ();// Check for an entry on the ini file that the sweeper is running.
// If found then do not allow another sweeper instance to start.
// You can delete this entry or set it to anything but 'running' for another instance to open

string			ls_current_status
integer		li_return
integer		li_rc

ls_current_status = ProfileString(gsinifile,"sims3FP","STATUS","NOTFOUND") /*get current sweeper status*/

choose case Upper(ls_current_status)
	case 'RUNNING'
		li_return = -1
	case else
		li_rc = SetProfileString(gsIniFile,'SIMS3FP','STATUS','RUNNING')
		li_return = li_rc
end choose

RETURN li_return
end function

public function integer uf_process_archive_outbound (ref datastore adw_output, string asproject);//Process outbound Flat files to archive only.  File will not be sent through FlatFileOutbound.
//	GailM - 03/21/2013 - Clone of uf_process_flatfile_outbound 

String	lsLogOut, lsProject, 	lsDirList, lsPathOut, lsFileOut,lsErrorPath, lsDefaultPath,	&
			lsData, lsOrigFileName,	lsNewFileName,	lsFileSequence, lsFileSequenceHold, lsFilePrefix, &
			lsFileSuffix, lsFileExtension, lsDestPath, lsDestCD, lsTmpFileName, lsFileExt, lsFileCreated
			
Long		llArrayPos,	&
			llDirPos	,	&
			llRowCount,	&
			llRowPos,	&
			llFileNo,       &
			llRC

Boolean	bRet

lsProject = asProject

lsPathOut = ProfileString(gsinifile,lsProject,"archivedirectory","") +'\Outbound\'
	
llRowCount = adw_output.RowCount()
	
uf_write_log('     ' + string(llRowCount) + ' Rows were retrieved for archive output...')
	
If llRowCount > 0 Then
	
	adw_Output.Sort() /* make sure we're sorted by batch seq so we only open an output file once */
		
	lsFileSequenceHold = ''
	
	//For each row, stream the data to the output file
	For llRowPos = 1 to llRowCount
		yield()

		//If BatchSeq has changed, close current file and create a new one
		lsFileSequence = String(adw_output.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
		
		If lsFileSequence <> lsFileSequenceHold Then
			
				//Close the existing file (if it's the first time, fileno will be 0)
				If llFileNo > 0 Then					
					FileClose(llFileNo) /*close the file*/
					
					//Jxlim 02/13/2013 Remove .TMP extension when file is closed due to BatchSeq has changed
					//Jxlim 02/13/2013 Baseline - Copy to lsFileOut. Remove .TMP ext and, use original file extension
					lsFileExt = Right(lsFileOut, 4)
					If Upper(Trim(lsFileExt)) ='.TMP' Then
						lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
						lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
						lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
						
						//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
						If FIleExists(lsOrigFileName) Then
							FileDelete(lsOrigFileName)
							lsLogOut = Space(10) + "***Datastore -File Sequence; Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."		
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End if
						
						//Jxlim 02/03/2013 MoveFile() function does Rename to new file and delete old file similar to replace file.
						bret=MoveFile(lsTmpFileName, lsOrigFileName)
						//Jxlim 01/23/2012 write message on rename status
						If Bret Then
							lsLogOut = Space(10) + "Datastore -File sequence has changed and File data successfully replaced and renamed to Original extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						Else /*unable to rename*/
							lsLogOut = Space(10) + "*** Datastore -File sequence has changed but Unable to replaced/renamed .TMP file data to Original File extension: " + lsOrigFileName
							FileWriteEx(giLogFileNo,lsLogOut)
							uf_write_Log(lsLogOut)
						End If				
						
						lsLogOut = Space(10) + "Datastore -File sequence has changed and Archive data successfully extracted to: " + lsPathOut + lsFileOut
						FileWriteEx(gilogFileNo,lsLogOut)
						uf_write_Log(lsLogOut) /*display msg to screen*/
												
					End If //Jxlim 02/13/2013  File Sequence has changed; closed the file; end of .TMP removed on this section
					
				End If /*not first time*/
				
									
				//Prefix
				lsFilePRefix = ProfileString(gsinifile,lsProject,"flatfileoutprefix","")
				If isNull(lsFilePrefix) or lsFilePrefix = '' Then
					lsFilePrefix  = Left(adw_output.GetItemString(llRowPos,'batch_data'),2)
				End If
				
				//Suffix
				lsFilesuffix = ProfileString(gsinifile,lsProject,"flatfileoutsuffix","")
				If isNull(lsFilesuffix) Then	lsFilesuffix  = ''
	
				//Extension
				lsFileExtension = ProfileString(gsinifile,lsProject,"flatfileoutextension","")
				If isNull(lsFileExtension) or lsFileExtension = '' Then
					lsFileExtension  = ".dat"
				End If
				
				//Build file name
				lsFileOut = lsFilePrefix + lsFileSequence + lsFileSuffix + lsFileExtension
	
				//We may have the file name specified in the datastore
				If adw_output.GetItemString(llRowPos,'file_name') > '' Then
					lsFileOut = adw_output.GetItemString(llRowPos,'file_name')
				End If
	
				lsErrorPath = ""				
			
				//Jxlim 01/15/2013 Baseline changed - 
				//Notes: The file name exist on datastore but really the file has not exist on directory as yet.
				//During the process of writing flatfileout, we need to name the file ext with .TMP
				//to prevent file from grabbed by in the middle of writing. When is done writing we will have to remove .TMP so the file will be pick up by downstream as it should.				
				
				//Jxlim 05/27/2011If Pandora-Worlship Replace (Overwrite) for existing file			
				If  lsFileOut = 'UPSFREIGHTIN' + '.csv'	 Then  /*Replace existing records*/	
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Replace!) //Jxlim 02/12/2012 default Ansi! don't need UTF parameter					
				Else	
					//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!) //Jxlim 02/12/2012 only for unicode usage
					lsFileOut = lsFileOut + '.TMP'    //Jxlim 01/17/2013 Added .TMP during processing	
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!) //Jxlim 02/12/2012 default Ansi! don't need UTF parameter
				End If			
				
				//Jxlim 02/02/2013 Use Long instead of Integer, <= 0
				If llFileNO <= 0 Then
					
					//10/08 - PCONKL - If we can't open the specified file, try to write out to a default directory - This probably only should happen if we are trying to write directly to a remote drive that might not be available.
					lsErrorPath =  lsPathOut + lsFileOut /*where we were trying to write to*/
					
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout-hold","") +'\' /*Where we store it locally until we can try again*/
					
					//Try to Open the backup file (local)
					//liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!,EncodingUTF16LE!)
					llFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
					If llFileNO < 0 or lsPAthOut = "\" Then
					
						lsLogOut = "     ***Unable to open file: " + lsPathOut + lsFileOut + " For output to Flat File."
						If lsErrorPath > "" Then
							lsLogOut += "  *** Attempted to open originally as: " + lsErrorPath + " ***"
						End If
						
						FileWriteEx(gilogFileNo,lsLogOut)		
						uf_write_Log(lsLogOut) /*display msg to screen*/
						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.",lsLogOut ,'') /*send an email msg to the file transfer error list*/
						Return -1
						
					Else /*backup is open, send email to file transfer to alert that it needs to be redropped*/
						
						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.","Unable to open file: " + lsErrorPath + " for remote copy. File stored locally as: " + lsPathOut + lsFileOut + " and needs to be copied manually." ,'') /*send an email msg to the file transfer error list*/
						
					End IF
					
				End If
	
				lsLogOut = '     File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
				FileWriteEx(gilogFileNo,lsLogOut)	
				uf_write_log(lsLogOut)
			
		End If /*File Changed*/
		
		lsData = adw_output.GetItemString(llRowPos,'batch_data')
		
		// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
		If (Not isnull(adw_output.GetItemString(llRowPos,'batch_data_2'))) and adw_output.GetItemString(llRowPos,'batch_data_2') > '' Then
			lsData += adw_output.GetItemString(llRowPos,'batch_data_2')
		End If
			
		llRC = FileWriteEx(llFileNo,lsData)
		
		If llRC < 0 Then
			lsLogOut = "     ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
			FileWriteEx(gilogFileNo,lsLogOut)	
			uf_write_Log(lsLogOut) /*display msg to screen*/
		End If
		
		lsFileSequenceHold = lsFileSequence
		
	Next /*data row*/
			
	If llFileNo > 0 Then
		FileClose(llFileNo) /*close the last/only file*/
	End If	
	
	//Jxlim 02/13/2013 Remove .TMP extension after closing the file	
	lsFileExt = Right(lsFileOut, 4)
	If Upper(Trim(lsFileExt)) ='.TMP' Then
		lsTmpFileName = lsPathOut + lsFileOut		   //with .TMP ext	
		lsFileOut	 = left(lsFileOut	, len(lsFileOut) - 4)  //Remove .TMP	
		lsOrigFileName = lsPathOut + lsFileOut	//without .TMP extension aka keep the original file extension	
	End If

	//Jxlim 02/19/2013 If the original file exist then delete first; this happen when there is manual sweeper restart
	If  FIleExists(lsOrigFileName) Then
		FileDelete(lsOrigFileName)
		//Jxlim 02/20/2013 this message just for testing
		lsLogOut = Space(10) +  "***Datastore -Deleted existing File data successfully from: " + lsOrigFileName + " before moving file from .TMP to original extension."	
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End if
	//bret=CopyFile(lsTmpFileName, lsOrigFileName,True)  //Copy file content from .TMP to the original file
	//bret=DeleteFile(lsTmpFileName)  //Delete .TMP file after copy to original
	//Jxlim 02/03/2013 MoveFile() function does Copy data content, Rename to new file and Delete old file similar to replace file.
	bret=MoveFile(lsTmpFileName, lsOrigFileName)
	//Jxlim 01/23/2012 write message on rename status
	If Bret Then
		lsLogOut = Space(10) + "Datastore -File data successfully replaced and renamed to Original extension: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	Else /*unable to rename*/
		lsLogOut = Space(10) + "*** DataStore -Unable to replaced/renamed .TMP file data to Original File extension: " + lsOrigFileName
		FileWriteEx(giLogFileNo,lsLogOut)
		uf_write_Log(lsLogOut)
	End If				
	
	//Jxlim 01/15/2013 Baseline - Remove .TMP ext and, use original file extension	
	lsLogOut = Space(10) + "DataStore -Flat File data successfully extracted to: " + lsPathOut + lsFileOut
	FileWriteEx(gilogFileNo,lsLogOut)
	uf_write_Log(lsLogOut) /*display msg to screen*/
		
	//Archive the last/only file
	lsOrigFileName = lsPathOut + lsFileOut
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut 	//+ ".txt"
	
		// Copy file to archive folder with .txt extension
		If FileExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		Else
			lsNewFileName += '.txt'
		End IF
	
	Bret=CopyFile(lsOrigFileName,lsNewFileName,True)	
				//Jxlim 01/23/2012 write message on archive status
				If Bret Then
					lsLogOut = Space(10) + "File archived to: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsNewFileName
					FileWriteEx(giLogFileNo,lsLogOut)
					uf_write_Log(lsLogOut)
				End If
		
Else /*no records to process for directory*/
		
		lsLogOut = "     There was no data to write for project: " + lsProject
		FileWriteEx(gilogFileNo,lsLogOut)
		uf_write_Log(lsLogOut) /*display msg to screen*/
		
End If /*records exist to output*/
		
Return 0
end function

public function boolean uf_is_country_eu_to_eu (string asproject, string as_from_country, string as_to_country);boolean lb_return = FALSE
boolean lb_exception_found = FALSE
integer i
long    ll_row, ll_exception_rowcount
string  ls_sku, ls_find, ls_uf8, ls_uf9, ls_uf10, ls_msg
string  ls_sql_syntax, ERRORS

datastore lds_countries, lds_exceptions

lds_countries = create datastore

ls_sql_syntax = "SELECT EU_country_Ind, Designating_code, ISO_Country_Cd, Country_Name from country " + &
					"WHERE designating_code in ('" + as_to_country + "', '" + as_from_country + "');"

lds_countries.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
if Len(ERRORS) > 0 then
else
	if lds_countries.SetTransObject(SQLCA) = 1 then
		if lds_countries.retrieve() = 2 then			
			if Upper(Trim(lds_countries.getItemString(1, "EU_country_Ind"))) = 'Y' and Upper(Trim(lds_countries.getItemString(2, "EU_country_Ind"))) = 'Y' then
				lb_return = TRUE

				// ET3 2012-12-17  Modification to check for exceptions requiring CI even though EU to EU
				// Even if true - return false if exception found; need access to the DO and Item_Master
				// User_Field8 = HTS-EU, User_Field9 = ECCN, User_Field10 = License
				//ls_find = "Designating_code = '" + as_from_country + "'"				
//				ls_find = "Designating_code = '" + as_to_country + "'"				
//				ll_row = lds_countries.Find( ls_find, 1, lds_countries.rowcount( ) )
				
//				IF ll_row > 0 THEN 
				
//					lds_exceptions = create datastore
//					
//					ls_sql_syntax = "SELECT ISO_Country_Cd, User_Field8, User_Field9, User_Field10 " + &
//										 "FROM Intra_EU_CI_Required " + &
//										 "WHERE Project_Id = '" + asproject + "' " + &
//										 "AND ISO_Country_Cd = '" + lds_countries.getItemString(ll_row,'ISO_Country_Cd') + "';"
//					
//					lds_exceptions.Create(SQLCA.SyntaxFromSQL( ls_sql_syntax, "", ERRORS))
//					If LEN(ERRORS) > 0 Then
						// bummer - error; ignore
//					Else
//						lds_exceptions.SetTransobject( SQLCA )
//						ll_exception_rowcount = lds_exceptions.Retrieve( )
						
//						if ll_exception_rowcount > 0 then
							// we found some exceptions for the ship_to country ... now test the SKUs
//							FOR i = 1 to this.idw_pack.rowcount( ) 
//								ls_sku = this.idw_pack.getitemstring( i, 'sku' )
//								
//								SELECT User_Field8, User_Field9, User_Field10
//								INTO :ls_uf8, :ls_uf9, :ls_uf10
//								FROM Item_Master
//								WHERE Project_Id = :asproject
//								  AND SKU = :ls_sku
//								USING SQLCA;
//								
//								IF SQLCA.sqlcode <> 0 THEN
//									// error ... okay bail this one
//									CONTINUE
//								ELSE
//									// see if the specified exceptions are in the list
//									ls_find = "User_Field8 = '" + ls_uf8 + "' OR " + &
//												 "User_Field9 = '" + ls_uf9 + "' OR " + &
//												 "User_Field10 = '" + ls_uf10 + "' " 
//												 
//									lb_exception_found = ( lds_exceptions.Find(ls_find,1,ll_exception_rowcount) > 0 OR lb_exception_found )
//
//								END IF
//								
//							NEXT
							
//							If lb_exception_found Then 
//								// exception found - prompt user
//								lb_return = FALSE
//								
//								ls_msg = 'This EU to EU shipment requires a CI to be sent ~r~n' + &
//											'to the Pandora CI Tool. Please send CI, Retrieve/Generate CI ~r~n' + &
//											'and have the CI accompany the shipment.'
//											
//								MessageBox('EU to EU CI Exception', ls_msg, Information!, OK!) 
//								
//							End If  // exception found
							
//						end if	// country exceptions 
						
//					End If	// ERRORs - lds_exceptions
					
//				END IF	// Find
		
			end if	// EU countries
			
		end if	// Retrieve

	end if	// SetTransObject
	
end if  // ERRORs



return lb_return 

end function

public subroutine uf_process_delivery_order_setup (string as_project_id);// LTK 20131014  Added method to allow different retrieval criterial for delivery_master datastore during processing of delivery orders

if Upper(as_project_id) = 'STBTH' then
	
	// STBTH does not sent invoice numbers and uses DM.UF22 for unique order key
	ib_non_standard_dwo = true

	Destroy idsDeliveryMAster
	idsDeliveryMAster = Create u_ds_datastore
	idsDeliveryMAster.dataobject= 'd_delivery_master_stbth'
	idsDeliveryMAster.SetTransObject(SQLCA)

elseif ib_non_standard_dwo then
	
	// Previous project was STBTH and this one is not, set dwo to the standard one
	ib_non_standard_dwo = false

	Destroy idsDeliveryMAster
	idsDeliveryMAster = Create u_ds_datastore
	idsDeliveryMAster.dataobject= 'd_delivery_master'
	idsDeliveryMAster.SetTransObject(SQLCA)

end if

end subroutine

public subroutine uf_process_purchase_order_setup (string as_project_id, string as_ftp_file_name);// LTK 20131015  Added method to allow different retrieval criteria for receive_master datastore during processing of purchase orders


// LTK 20131230  Added logic to allow 2 STBTH file types to be processed as normal (use the standard PO datawindow)
boolean lb_project_dw
if Upper(as_project_id) = 'STBTH' then
	if Pos(Upper(as_ftp_file_name), '\PO') > 0 or Pos(Upper(as_ftp_file_name), '\PL') > 0 then
		// These two file types will use the standard PO datawindow for processing
	else
		lb_project_dw = true
	end if
end if

//if Upper(as_project_id) = 'STBTH' then
if lb_project_dw then

	// STBTH does not sent invoice numbers and uses DM.UF15 for unique order key
	ib_non_standard_ro_dwo = true

	Destroy idsReceiveMaster
	idsReceiveMaster = Create u_ds_datastore
	idsReceiveMaster.dataobject= 'd_receive_master_stbth'
	idsReceiveMaster.SetTransObject(SQLCA)

elseif ib_non_standard_ro_dwo then
	
	// Previous project was STBTH and this one is not, set dwo to the standard one
	ib_non_standard_ro_dwo = false

	Destroy idsReceiveMaster
	idsReceiveMaster = Create u_ds_datastore
	idsReceiveMaster.dataobject= 'd_receive_master'
	idsReceiveMaster.SetTransObject(SQLCA)

end if

end subroutine

public function integer uf_connect_to_pandora_db ();// 04/13  - PCONKL - Connect to the replication DB

String	lsServer

Pandora_SQLCA = Create Transaction

Pandora_SQLCA.DBMS       = "SNC SQL Native Client(OLE DB)" 

//Assume that login credentials are the same for Replicated server - *** For now database is hardcoded so test can point to Prod ***

Pandora_SQLCA.database = "SIMSPANPRD" //dts sqlca.database  

lsServer = "simsdb.menlolog.com"

Pandora_SQLCA.servername = lsServer //not getting this from lookup table or INI file yet...

Pandora_SQLCA.logID = sqlca.logid     
Pandora_SQLCA.logPass = sqlca.logPass

// Added string to turn off MARS  -- 04/29/11  cawikholm
Pandora_SQLCA.dbparm       = "Database='"+Pandora_SQLCA.database+"',TrimSpaces=1,ProviderString = 'MARS Connection=False'"

// 04/15/11 - PCONKL - Changed isolation from Read Committed to Read Uncommitted
//Replication-SQLCA.LOCK = "RC" 
Pandora_SQLCA.LOCK = "RU" 

//Replication-SQLCA.AutoCommit = False
Pandora_SQLCA.AutoCommit = TRUE /* 11/04 - PCONKL - Turned auto commit on to ellinate DB locks */

connect using Pandora_SQLCA;

//Need to set the Ansi warnings off

EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING Pandora_SQLCA;

//SQLCA.DBParm = "disablebind =0"

Return Pandora_SQLCA.sqlcode

end function

public function long uf_process_import_server (string as_project, string as_xml);String lsLogOut, lsDatasource, lsXMLResponse, lsReturnCode, lsReturnDesc
long llRc

//datasource is an optional override, may be present in the database or the .ini file. may not be present at all
lsDatasource = ProfileString(gsinifile,"WEBSPHERE","datasource","")
//If not present in gsinifile, get from DB
If isnull(lsDatasource) or lsDatasource = '' Then
	Select connection_datasource_name
	Into	:lsDatasource
	From  Websphere_settings
	Using SQLCA;	
End IF

// Set replacement variables
as_xml = Replace(as_xml,pos(as_xml,"*server*"),8,sqlca.servername)
as_xml = Replace(as_xml,pos(as_xml,"*database*"),10,sqlca.database)
as_xml = Replace(as_xml,pos(as_xml,"*userid*"),8,sqlca.logid)
as_xml = Replace(as_xml,pos(as_xml,"*dataSource*"),12,lsDatasource)
as_xml = Replace(as_xml,pos(as_xml,"*projectid*"),11,as_project)
as_xml = Replace(as_xml,pos(as_xml,"*requestaction*"),15,"Save") /*Save (will validate as well)*/

//Send to Server
u_nvo_websphere_post ln_websphere
ln_websphere = CREATE u_nvo_websphere_post
lsXMLResponse = ln_websphere.uf_post_url( as_xml )

//Process results from server
lsReturnCode = ln_websphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = ln_websphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		//19-Jan-2016 Madhu - Added code to move error out file- START
		//Messagebox("Websphere Operational Exception Error","Unable to Save Import: ~r~r" + lsReturnDesc,StopSign!)
		
		lsLogOut=" ***Unable to Save Import:, Server Error Code: "+ lsReturnCode + "  Server Error Message: " + lsReturnDesc
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut)
		uf_writeError(lsLogOut)
		//19-Jan-2016 Madhu - Added code to move error out file- END
		
		Return -99
		
	Case Else
		
		llRc = Long(lsReturnCode)
		
		If llRc > 0 Then /* Validation Error llrc contains row number with error */
			
			lsLogOut = "   ***Validation error, Server Error Code: " + String(llRC) + "  Server Error Message: " + lsReturnDesc
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut)
			uf_writeError(lsLogOut)
			return -1
			
		ElseIf llRC < 0 Then /* error */
			
			lsLogOut = "   ***Import error, Server Error Code: " + String(llRC) + "  Server Error Message: " + lsReturnDesc
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut)
			uf_writeError(lsLogOut)
			return -1

		Else
			
			lsLogOut = "   - Successfully imported PO file."
			FileWrite(giLogFileNo,lsLogOut)
			uf_write_log(lsLogOut)
			
		End If
					
End Choose

return llRc
end function

public function integer uf_send_email_with_from_address (string asproject, string asdistrblist, string assubject, string astext, string asattachments, string asemail, string aslogo);//16-Jan-2015 :Madhu- Send E-mail notification to user (HTML) for PHYSIO-CONTROL /XD

String	lsDistribList,	lsTemp, 	lsOutPut, lsReturn, lsCommand, lsAttachments, lsSubject, lsmailhostServerName
String 	old_str,ls_textfile,new_str,ls_filename
long 		start_pos,index,li_filenumber,li_bytes			

OleObject wsh
integer  li_rc

CONSTANT integer MINIMIZED = 2
CONSTANT boolean WAIT = TRUE
start_pos =1
old_str ="html"
new_str ="txt"

//Get the Distrib LIst, replace any semi colons with commas

Choose Case Upper(asdistrblist)
		
	Case 'SYSTEM' /*send message to the system distribution List*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","SYSEMAIL","")
	Case 'CUSTVAL' /*Send a customer validation message - including error files*/
		lsDistribList = ProfileString(gsinifile,asProject,"CUSTEMAIL","")
	Case 'FILEXFER' /*Send a msg to file transfer error list*/
		lsDistribList = ProfileString(gsinifile,"sims3FP","FilexferMAIL","")
	Case Else /*Custom User or list passed in parm*/
		If Pos(asdistrblist,'@') > 0 Then
			lsDistribList = asdistrblist
		Else
			lsDistribList = ProfileString(gsinifile,asProject,asdistrblist,"")
		End If
		
End Choose

Do While Pos(lsDistribList,';') > 0
	lsDistribList = Replace(lsDistribList,Pos(lsDistribList,';'),1,',')
Loop

If isNull(lsDistribList) or lsDistribList = '' or lsDistribList = "No Email" Then
	lsOutput = "          - No entries in distribution list for this project. Email notification not sent."
	FileWrite(gilogFileNo,lsOutput)
	uf_write_Log(lsOutput) /*display msg to screen*/
	
	Return 0
End If

ls_filename ="template.html" //create a html file and store the text into that
li_filenumber =FileOpen(ls_filename,StreamMode!,Write!,LockReadWrite!,Replace!)

If li_filenumber >=0 THEN
	li_bytes =FileWrite(li_filenumber, astext)
	FileClose(li_filenumber)
END IF


//17-APR-2017 :Madhu -PEVS-582 Get MailHostServerName
lsmailhostServerName =ProfileString(gsinifile, "SIMS3FP","MailHostServerName","")

//Create the command line prompt
lsCommand = "blat  "

//Add HTML file name to blat command
lsCommand += ls_filename 

//Add From
lsCommand += ' -f "' + asemail + '" '

//Add Subject
lsSubject = assubject
lsCommand += ' -s "' + lsSubject + '"'

//add dist list
lsCommand += ' -t "' + lsDistribList + '"'

//supress + servername
//lsCommand += " -q -noh2 -server mailhost.con-way.com " //14-APR-2017 :Madhu -PEVS-582 Change mail host for Sweeper
lsCommand += " -q -noh2 -server "+lsmailhostServerName+" " //14-APR-2017 :Madhu -PEVS-582 Change mail host for Sweeper

If isnull(isEmailLogFile) or isEmailLogFile='' THEN isEmailLogFile = ProfileString(gsinifile,"sims3FP","LogDirectory","") + '\SIMS3FP-EMAIL-' + string(now(),'yyyymmddhhmm') + '.log' /*Create a new Email log file everytime we run with date/time stamp*/

//Log File
lsCommand += " -log " + isEmailLogFile + " -timestamp "

//Add HTML to blat command
lsCommand +="-html"

//Replace html by txt in file name
start_pos =Pos(ls_filename,old_str,start_pos)

DO WHILE start_pos > 0
	 ls_textfile = Replace(ls_filename, start_pos,Len(old_str), new_str)
	 start_pos =Pos(ls_filename,old_str,start_pos+1)
LOOP

lsCommand += ' -alttextf  ' + ls_textfile

//Logo is present then add to blat command
If aslogo >'' THEN lsCommand += '  -embed '+aslogo

//Any attachments...
lsAttachments = asAttachments

Run(lsCommand, minimized!)

lsOutput = "          - Mail sent to: (" + asdistrblist + "): " + lsDistribList
FileWrite(gilogFileNo,lsOutput)
uf_write_Log(lsOutput) /*display msg to screen*/

yield()
lsOutput = "          - PLEASE WAIT!!: " 
uf_write_Log(lsOutput) /*display msg to screen*/

sleep(10)

FileDelete(ls_filename) //delete the file at the end
Return 0
end function

public function integer uf_process_om_inbound ();//30-MAY-2017 :Madhu -PINT -Process OM Inbound Orders
//Get a List of all projects from OMINBOUND section and Loop through them.

String lsdirList, lsdir[], lsproject
long llArrayPos, lldirPos, llRC

u_nvo_proc_pandora lu_pandora
u_nvo_proc_rema lu_rema

//Get a list of all directories to process
lsdirList = ProfileString(gsinifile, 'OMINBOUND', 'directorylist','')

llArrayPos =0
Do While Pos(lsdirList, ',') > 0 
	llArrayPos++
	lsdir[llArrayPos] = Left(lsdirList, (Pos(lsdirList, ',') - 1))
	lsdirList =Right(lsdirList, (len(lsdirList) - Pos(lsdirList, ',')))
Loop

llArrayPos++
lsdir[llArrayPos] = lsdirList //get the last one


For lldirPos =1 to Upperbound(lsdir)
	lsproject = lsdir[lldirPos]
	
	CHOOSE CASE upper(lsproject)
		CASE 'PANDORA'
			lu_pandora =create u_nvo_proc_pandora
			llRC =lu_pandora.uf_process_om_inbound( lsproject)
			
		CASE 'REMA'
			lu_rema =create u_nvo_proc_rema
			llRC =lu_rema.uf_process_om_inbound( lsproject)
			
	END CHOOSE

Next


Return llRC
end function

public function integer uf_connect_to_om (string asproject);//30-MAY-2017 :Madhu PINT- Connect to OM DB

String ls_dbname, ls_servername, ls_userId, ls_password, lsOutput

//Retrieve all required details from OM_Settings table
SELECT OM_DB_Name, OM_Server_Name, OM_UserId, OM_Password
	into :ls_dbname, :ls_servername, :ls_userId, :ls_password 
FROM OM_Settings with(nolock)
WHERE Project_Id =:asproject
USING sqlca;

//Write to File and Screen
lsOutput = '*** Connecting to Oracle database: *** '
FileWrite(giLogFileNo,lsOutput)
this.uf_write_log(lsOutput)

//create a transaction object for OM
om_sqlca = Create Transaction
//om_sqlca.dbms = "TRACE ORA Oracle"
om_sqlca.DBMS       = "ORA Oracle" 
om_sqlca.database = ls_dbname //OT29
om_sqlca.servername = ls_servername //OT29
om_sqlca.logID = ls_userId
om_sqlca.logPass = ls_password

om_sqlca.dbparm   = "Database='"+ om_sqlca.database +"',TrimSpaces=1,ProviderString = 'MARS Connection=False'"

//Read Uncommitted
om_sqlca.LOCK = "RU" 
om_sqlca.AutoCommit = FALSE 

connect using om_sqlca;

//Need to set the Ansi warnings off
//EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING om_sqlca;

//SQLCA.DBParm = "disablebind =0"
//Write to File and Screen
lsOutput = 'Connected to database:  (Server) ' + om_sqlca.servername + '\ (DB) ' + om_sqlca.database+' \ (Return Code) '+ string(om_sqlca.sqlcode)
FileWrite(giLogFileNo,lsOutput)
this.uf_write_Log(lsOutput)

Return om_sqlca.sqlcode

end function

public subroutine uf_disconnect_from_om ();//30-MAY-2017 :Madhu -PINT - Disconnect from OM DB

disconnect using om_sqlca;
destroy om_sqlca;
end subroutine

public function integer uf_process_om_inbound_update (ref datastore adsreceipt);//27-JUNE-2017 :Madhu -PINT -856 - Update Status to respective OM tables
//Update OMA_RECEIPT_QUEUE , OMC_RECEIPT tables.

string  ls_rq_sql, ls_rc_sql, ls_status_cd, lsLogOut, ls_orig_rq_sql, ls_orig_rc_sql, ls_project
long ll_row, ll_rc, ll_change_req_no, ll_rq_row, ll_rc_row, ll_count

Datastore ldsReceiptQueue, ldsReceipt

lsLogOut = '      - OM Inbound - Processing of uf_process_om_inbound_update() - Server Name: '+ nz(om_sqlca.servername, '-') + '\ (DB) ' + nz(om_sqlca.database,'-')+' \ (Return Code) '+ nz(string(om_sqlca.sqlcode),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If om_sqlca.sqlcode <> 0 Then
	//re-connect to respective DB
	select Project_Id into :ls_project from OM_Settings with(nolock) where OM_Server_Name =:om_sqlca.servername 	using sqlca;
	this.uf_connect_to_om( ls_project)
End If

If not isValid(ldsReceiptQueue) Then
	ldsReceiptQueue =create u_ds_datastore
	ldsReceiptQueue.dataobject='d_oma_receipt_queue'
End If
	ldsReceiptQueue.settransobject( om_sqlca)
	
If not isValid(ldsReceipt) Then
	ldsReceipt =create u_ds_datastore
	ldsReceipt.dataobject='d_omc_receipt'
End If
	ldsReceipt.settransobject( om_sqlca)

//Write to File and Screen
lsLogOut = '      - OM Inbound - Start Processing of uf_process_om_inbound_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Retrieve Original Query
ls_orig_rq_sql = ldsReceiptQueue.getsqlselect( )
ls_orig_rc_sql = ldsReceipt.getsqlselect( )

//Loop through Ref datastore to update OM tables.
For ll_row = 1 to adsreceipt.rowcount()
	ll_change_req_no = adsreceipt.getitemnumber(ll_row, 'change_req_no')
	ls_status_cd =adsreceipt.getitemstring(ll_row, 'status_cd')
	
	//OMA_Receipt_Queue
	ls_rq_sql =''
	ls_rq_sql = ls_orig_rq_sql
	ls_rq_sql += " AND " 
	ls_rq_sql += "OPS$OMAUTH.OMA_RECEIPT_QUEUE.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	
	ldsReceiptQueue.setsqlselect( ls_rq_sql)
	ll_count = ldsReceiptQueue.retrieve( )
	
	FOR ll_rq_row =1 to ldsReceiptQueue.rowcount( )
		IF upper(ls_status_cd) ='E' THEN
			ldsReceiptQueue.setitem( ll_rq_row, 'status', 'FAIL')
		else
			ldsReceiptQueue.setitem( ll_rq_row, 'status', 'SUCCESS')
		END IF
		
		ldsReceiptQueue.setitem( ll_rq_row, 'editwho', 'SIMSUSER')
	NEXT
	
	//OMC_Receipt
	ls_rc_sql =''
	ls_rc_sql = ls_orig_rc_sql
	ls_rc_sql += " WHERE " 
	ls_rc_sql += "OPS$OMAUTH.OMC_RECEIPT.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	
	ldsReceipt.setsqlselect( ls_rc_sql)
	ll_count = ldsReceipt.retrieve( )
	
	FOR ll_rc_row =1 to ldsReceipt.rowcount( )
		IF upper(ls_status_cd) ='E' THEN
			ldsReceipt.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'FAILED')
		else
			ldsReceipt.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'COMPLETED')
		END IF
		
		ldsReceipt.setitem( ll_rc_row, 'editwho', 'SIMSUSER')
	NEXT
	
	//storing into DB
	Execute Immediate "Begin Transaction" using om_sqlca;
	
	If ldsReceiptQueue.rowcount( ) > 0 Then
		ll_rc =ldsReceiptQueue.update( false, false);
	End IF
	
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
		
		if om_sqlca.sqlcode = 0 then
			ldsReceiptQueue.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			ldsReceiptQueue.reset( )
	  	     //MessageBox("ERROR", om_sqlca.SQLErrText)
			//Write to File and Screen
			lsLogOut = '      - OM Inbound - uf_process_om_inbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) +" Error:"+om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
		
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//MessageBox("ERROR", "System error, record save failed!")
		//Write to File and Screen
		lsLogOut = '      - OM Inbound - uf_process_om_inbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) +" Error:"+om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
	If ldsReceipt.rowcount( ) > 0 Then
		ll_rc =ldsReceipt.update( false, false);
	End IF
	
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
		
		if om_sqlca.sqlcode = 0 then
			ldsReceipt.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			ldsReceipt.reset( )
			// MessageBox("ERROR", om_sqlca.SQLErrText)
			//Write to File and Screen
			lsLogOut = '      - OM Inbound - uf_process_om_inbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) +" Error:"+om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
		
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//MessageBox("ERROR", "System error, record save failed!")
		//Write to File and Screen
		lsLogOut = '      - OM Inbound - uf_process_om_inbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) +" Error:"+om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound - uf_process_om_inbound_update() -Write Messages into OMC Table for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//update OMC_Message
	If  upper(ls_status_cd) ='E'  THEN
		ll_rc = uf_process_omc_message('IB ORDER', 'E', 'ASN_TO_SIMS_PROCESS',  'FAILED TO LOAD IB ORDER INTO SIMS', ll_change_req_no)
	else
		ll_rc = uf_process_omc_message('IB ORDER', 'I', 'ASN_TO_SIMS_PROCESS',  'SUCCESSFULLY LOADED IB ORDER INTO SIMS', ll_change_req_no)
	END IF

	//Reseting sql's
	ldsReceiptQueue.reset( )
	ldsReceipt.reset( )
Next

//Write to File and Screen
lsLogOut = '      - OM Inbound - End Processing of uf_process_om_inbound_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Destroy ldsReceiptQueue
Destroy ldsReceipt

Return ll_rc
end function

public function integer uf_process_omc_message (string asrecord, string astype, string assource, string asmessage, long alchangereqno);//27-JUNE-2017 :Madhu Added for PINT-856
//Insert Record into OMC_Message table

string lsLogOut
long ll_row, ll_rc
Datastore lds_omc_msg

lds_omc_msg =create u_ds_datastore
lds_omc_msg.dataobject ='d_omc_message'
lds_omc_msg.settransobject( om_sqlca)

ll_row =lds_omc_msg.insertrow( 0)
lds_omc_msg.setitem( ll_row, 'RECORD_DISCRIMINATOR', asrecord)
lds_omc_msg.setitem( ll_row, 'TYPE', astype)
lds_omc_msg.setitem( ll_row, 'SOURCE_EVENT', assource)
lds_omc_msg.setitem( ll_row, 'MESSAGE', asmessage)
lds_omc_msg.setitem( ll_row, 'CHANGE_REQUEST_NBR', alchangereqno)
lds_omc_msg.setitem( ll_row, 'ADDWHO', 'SIMSUSER')
lds_omc_msg.setitem( ll_row, 'EDITWHO', 'SIMSUSER')

//Write to File and Screen
lsLogOut = '      - OM Inbound - Start uf_process_omc_message() -Write Messages into OMC Table'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If lds_omc_msg.rowcount( ) > 0 Then
	ll_rc =lds_omc_msg.update( false, false);
End IF
	
If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;
	
	if om_sqlca.sqlcode = 0 then
		lds_omc_msg.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;

		//Write to File and Screen
		lsLogOut = '      - OM Inbound - Error uf_process_omc_message() -Write Messages into OMC Table ' +om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		lds_omc_msg.reset( )
		MessageBox("ERROR", om_sqlca.SQLErrText)
		Return -1
	end if
		
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	MessageBox("ERROR", "System error, record save failed!")
	Return -1
End If

//Write to File and Screen
lsLogOut = '      - OM Inbound - End uf_process_omc_message() -Write Messages into OMC Table'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
Return ll_rc
end function

public function integer uf_process_om_writeerror (string asproject, string asstatus, long alchangereqno, string asprocesstype, string aserrormsg);//29-JUNE-2017 :Madhu - Added for PINT -856
//Based on "OrderType" (IB/OB)- call appropriate method to update respective OM tables.

String lsLogOut, ls_project
long ll_row, ll_rc
Datastore lds_om_receipt_list

//Write to File and Screen
lsLogOut = '      - OM Inbound - Start Processing of uf_process_om_writeerror() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//21-MAR-2018 :Madhu DE3461 - Reconnect to OM DB
lsLogOut = '      - OM Inbound - Processing of uf_process_om_writeerror() - Server Name: '+ nz(om_sqlca.servername, '-') + '\ (DB) ' + nz(om_sqlca.database,'-')+' \ (Return Code) '+ nz(string(om_sqlca.sqlcode),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If om_sqlca.sqlcode <> 0 Then
	//re-connect to respective DB
	select Project_Id into :ls_project from OM_Settings with(nolock) where OM_Server_Name =:om_sqlca.servername 	using sqlca;
	this.uf_connect_to_om( ls_project)
End If

uf_writeError(aserrormsg) //write error log msg

If not isValid(lds_om_receipt_list) Then
	lds_om_receipt_list =create Datastore
	lds_om_receipt_list.dataobject ='d_om_update_receipt_order_list'
End If

ll_row =lds_om_receipt_list.insertrow( 0)	
lds_om_receipt_list.setitem( ll_row, 'project_Id', asproject)
lds_om_receipt_list.setitem( ll_row, 'change_req_no', alchangereqno)
lds_om_receipt_list.setitem( ll_row, 'status_cd', asstatus)

CHOOSE CASE upper(asprocesstype)
	CASE 'IB'
		ll_rc = uf_process_om_inbound_update( lds_om_receipt_list)
	CASE 'OB'
		ll_rc = uf_process_om_outbound_update( lds_om_receipt_list)
		
END CHOOSE

destroy lds_om_receipt_list

//send an email alert
If len(aserrormsg) > 0 and upper(asprocesstype) ='IB' Then
	uf_send_email("OMINBOUND",'CUSTVAL'," Change Req No: "+ string(alchangereqno)+" is failed to process Inbound Order (ASN) into SIMS from OM ",aserrormsg,'')
	Return -1
End If

//send an email alert
If len(aserrormsg) > 0 and upper(asprocesstype) ='OB' Then
	lsLogOut = '      - OM Outbound Error - Change Req No: ' + string(alchangereqno)+ ' is failed to process Outbound Order (940) into SIMS from OM: ' + aserrormsg
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	lsLogOut = '      -  	Error is: ' + aserrormsg
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)


	uf_send_email("OMINBOUND",'CUSTVAL'," Change Req No: "+ string(alchangereqno)+" is failed to process Outbound Order (940) into SIMS from OM ",aserrormsg,'')
	Return -1
End If

//Write to File and Screen
lsLogOut = '      - OM Inbound - End Processing of uf_process_om_writeerror() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

return ll_rc
end function

public function integer uf_process_delivery_order (string asproject);// ET3  2012-05-01: per Pandora 389, set OTM status to 'V' as well

Long		llHeaderPos, llHeaderCount, llDetailCount, llDetailPos, llDMasterCount,	&
llDDetailCount, llRowPos, llCount, llLineItem, llOwner, 				&
llAllocQty,	llNewRow, llBatchSeq, llNewCount, llUpdateCount, llDeleteCount, &
llOrderSeq, llCountPO, ll_row, llDMFind

String	lsProject, lsOrderNo, lsCustPO,lsDoNo,	lstemp, lsProjectHold, lsInvoiceNo,		&
lsSku, lsSupplier,lsHeaderErrorText, lsDetailErrorText,	lsLogOut, lsallowPOErrors, lsOrdStatus, lsDisplayOrderNo

String lsUserField22	// LTK 20131014  Added for STBTH
boolean lb_delete_records  // LTK 20131014  Added for STBTH

String	lsReleaseID //for LINKSYS...
String lsWH_Code  // 11/19/2010 ujh: ( LU Loc)  Last_Update reflect Local Wh not GMT
String  lsAllowMultDelNbrs		//03/13/2019 GailM Check project flag
DateTime ldtWhTime // 11/19/2010 ujh: ( LU Loc)  Last_Update reflect Local Wh not GMT
Boolean	lbError,	lbValError, lbNewDO, lbDetailErrors, lbSendDst

Decimal	lddono, ldQty
Integer	liRC
u_nvo_edi_confirmations_nike      lu_edi_confirmations_nike

//TimA 07/18/13
String lsDM_Country, lsCustCountry
String ls_to_country, ls_from_country
String lsStatus_cd // TAM 2017/07 Pint

// MEA- Moved to OTM NVO
string lsScheduleCode, lsfromwh, lsoutboundtype
String lsErrText

Integer llCustCodeOverride
String ls_replace_do_no	// LTK 20120215
String ls_ship_to_override_UF1, ls_ship_to_override_flag  // LTK 20120511

Datastore lds_om_receipt_list //2017/07 :TAM Added for PINT- 856

lsLogOut = '          - PROCESSING FUNCTION - Create/Update Outbound Delivery Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

If not isValid(idsDOHeader) Then
	idsDOHeader = Create u_ds_datastore
	idsDOHeader.dataobject= 'd_shp_header'
	//	idsDOHeader.SetTransObject(SQLCA)
End If

idsDOHeader.SetTransObject(SQLCA)

If not isvalid(idsDeliveryMAster) Then
	idsDeliveryMAster = Create u_ds_datastore
	idsDeliveryMAster.dataobject= 'd_delivery_master'
	//	idsDeliveryMAster.SetTransObject(SQLCA)
End If

idsDeliveryMAster.SetTransObject(SQLCA)

If not isvalid(idsDODetail) Then
	idsDODetail = Create u_ds_datastore
	idsDODetail.dataobject= 'd_shp_detail'
	//	idsDODetail.SetTransObject(SQLCA)
End If

idsDODetail.SetTransObject(SQLCA)

If not isvalid(idsDeliveryDetail) Then
	idsDeliveryDetail = Create u_ds_datastore
	idsDeliveryDetail.dataobject= 'd_delivery_detail'
	//	idsDeliveryDetail.SetTransObject(SQLCA)
End If

idsDeliveryDetail.SetTransObject(SQLCA)

//2017/07 :TAM Added for PINT- 856
//Store all Delivery Orders + Status Cd value
If not isValid(lds_om_receipt_list) Then
	lds_om_receipt_list =create Datastore
	lds_om_receipt_list.dataobject ='d_om_update_receipt_order_list'
End If
//2017/07 :TAM Added for PINT -856 -END

idsDOHEader.Reset()
idsDODetail.Reset()
idsDeliveryMaster.Reset()
idsDeliveryDetail.Reset()

//Retrieve the EDI Header and Detail based on status
llHeaderCount = idsDOHeader.Retrieve( asProject )

lsLogOut = '              ' + string(llHeaderCount) + ' Outbound Order headers were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

//GailM 03/13/2019 F14761 I2246 Check and respond to Allow dupe delivery order numbers from project flag
Select allow_dup_do_numbers_ind into  :lsAllowMultDelNbrs		//03/13/2019 GailM Check project flag
From project Where project_id = :asProject Using SQLCA;

If llHeaderCount =0 Then
	Return 0
ElseIf llHeaderCount < 0 Then /* 11/03 - PCONKL */
	uf_send_email("",'Filexfer'," - ***** Uf_Process_delivery_Order - Unable to read EDI Records!","Unable to read EDI Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//Process Each EDI Header Record
For llHeaderPos = 1 to llHeaderCount

	// LTK 20131014  Method added for STBTH and allows other datawindow objects to be used for idsDeliveryMaster
	uf_process_delivery_order_setup(idsDOHeader.GetItemString(llHeaderPos,'project_id'))
	
	// LTK 20111011	Pandora #305  For Pandora, create an SOC, rather than a DO, for certain SOIMIM orders.
	if Upper(idsDOHeader.GetItemString(llHeaderPos,'project_id')) = 'PANDORA' then
		// The following method checks first, and then creates the SOC if the stars are aligned.  
		// A zero is returned if conditions are *not* met and the DO needs to be processed below.
		if uf_create_soc_from_mim(idsDOHeader, llHeaderPos) <> 0 then
			Continue /*next header */
		end if
	end if
	
	lbNewDO = False
	
	lsProject = idsDOHeader.GetItemString(llHeaderPos,'project_id')
	lsOrderNo = idsDOHeader.GetItemString(llHeaderPos,'Invoice_no')
	llBatchSeq = idsDOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no')
	llOrderSeq = idsDOHeader.GetItemNumber(llHeaderPos,'order_seq_no')
	lsWH_Code = idsDOHeader.GetITemString(llHeaderPos,'wh_code')  // 11/19/2010 ujh: ( LU Loc)  Last_Update reflect Local Wh not GMT
	ldtWhTime = f_getLocalWorldTime(lsWh_Code) // 11/19/2010 ujh: ( LU Loc)  Last_Update reflect Local Wh not GMT	
	lsUserField22 = idsDOHeader.GetItemString(llHeaderPos,'user_field22')
	
	//03/03 - PCONKL - for some projects, we will allow a DO to still be created if 1 or more detail lines have errors
	//						 Otherwise, we will delte the entire DO  if there are errors. Only need to retrieve if project changes (it shouldn't in this batch)
	If lsProject <> lsProjectHold Then
		lsallowPOErrors = ProfileString(gsinifile,lsProject,"allowpoerrors","")
		If isNull(lsAllowPOErrors) or lsAllowPOErrors = '' or lsAllowPOErrors <> 'Y' Then lsAllowPOErrors = 'N'
		lsProjectHold = lsProject
	End If
	
	lsHeaderErrorText = ''	// LTK moved this line above the REPLACE logic
	
	//llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsOrderNo)
	// LTK 20131014  Retrieve based on the standard or non standard datawindow.  Non standard introduced for STBTH
	if ib_non_standard_dwo then
		llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsUserField22)
	else
		llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsOrderNo)
	end if
	
	//26-APR-2019 :Madhu S32797 F14761 - I2246 - PHILIPS-TH allow duplicate order numbers, if warehouse is different - START
	//05-JUNE-2019 :Madhu S34273 F16399 - I2246 - PHILIPS-TH allow duplicate order numbers
	IF llDMasterCount > 0 THEN
		llDMFind = idsDeliveryMaster.find( "wh_code ='"+lsWH_Code+"'", 0, idsDeliveryMaster.rowcount( ))
		IF llDMFind = 0 THEN llDMasterCount =0
		IF llDMFind >0 and upper(lsProject) ='PHILIPS-TH' and lsAllowMultDelNbrs='Y' THEN lsAllowMultDelNbrs ='N'
	END IF
	//26-APR-2019 :Madhu S32797 F14761 - I2246 - PHILIPS-TH allow duplicate order numbers, if warehouse is different - END
	
	boolean lb_process_replacements
	
	// LTK 20120215	For Pandora orders, if action code = 'R' for REPLACE then select and capture the do_no, delete existing
	//						delivery records and set action code to 'A' so that the order is processed as an Add.
	if lsProject = 'PANDORA' and idsDOHeader.GetItemString(llHeaderPos,'action_cd') = 'R' and llDMasterCount > 0 then
		lb_process_replacements = true
	end if
	
	if lsProject = 'STBTH' and idsDOHeader.GetItemString(llHeaderPos,'action_cd') = 'R' and llDMasterCount > 0 then		
		lb_process_replacements = true
	end if
	
	if lb_process_replacements then
	
		if ib_non_standard_dwo  then
		
			select do_no 
			into :ls_replace_do_no
			from delivery_master with(nolock)
			where project_id = :lsProject
			and user_field22 = :lsUserField22
			and ord_status in ('N', 'H');
		
			if sqlca.sqlcode <> 0 then
				uf_writeError("UserField22 (Header): " + string(lsUserField22) + " Unable to retrieve a do_no in NEW status.") 
				lbError = True
				lsHeaderErrorText += "UserField22 (Header): " + string(lsUserField22) + " Unable to retrieve a do_no in NEW status."
			else
				lb_delete_records = true
			end if
		else
			select do_no 
			into :ls_replace_do_no
			from delivery_master with(nolock)
			where project_id = :lsProject
			and invoice_no = :lsOrderNo
			and ord_status in ('N', 'H');
			
			if sqlca.sqlcode <> 0 then
				uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Unable to retrieve a do_no in NEW status.") 
				lbError = True
				lsHeaderErrorText += "Order Nbr (Header): " + string(lsOrderNo) + " Unable to retrieve a do_no in NEW status."
			else
				lb_delete_records = true
			end if
		
		end if //Non Standard DWO
	
		if lb_delete_records then
			// Should only be records in Delivery_Master and Delivery_Detail but will attempt to delete all delivery tables
			Delete from Delivery_Picking_Detail where do_no = :ls_replace_do_no;
			Delete from Delivery_Picking where do_no = :ls_replace_do_no;
			Delete from Delivery_detail where do_no = :ls_replace_do_no;
			Delete from Delivery_notes where do_no = :ls_replace_do_no;
			Delete from Delivery_bom where do_no = :ls_replace_do_no;
			Delete from Delivery_alt_address where do_no = :ls_replace_do_no;
			Delete From Delivery_master where do_no = :ls_replace_do_no;
			Commit;
		
			// Now treat the order as an Add
			idsDOHeader.SetItem(llHeaderPos,'action_cd','A')
			// LTK 20131014  Retrieve based on the standard or non standard datawindow.  Non standard introduced for STBTH
			if ib_non_standard_dwo then
				llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsUserField22)
			else
				llDMasterCount = idsDeliveryMaster.Retrieve(lsProject, lsOrderNo)
			end if
			
			//26-APR-2019 :Madhu S32797 F14761 - I2246 - PHILIPS-TH allow duplicate order numbers, if warehouse is different - START
			//05-JUNE-2019 :Madhu S34273 F16399 - I2246 - PHILIPS-TH allow duplicate order numbers
			IF llDMasterCount > 0 THEN
				llDMFind = idsDeliveryMaster.find( "wh_code ='"+lsWH_Code+"'", 0, idsDeliveryMaster.rowcount( ))
				IF llDMFind = 0 THEN llDMasterCount =0
				IF llDMFind >0 and upper(lsProject) ='PHILIPS-TH' and lsAllowMultDelNbrs='Y' THEN lsAllowMultDelNbrs ='N'
			END IF
			//26-APR-2019 :Madhu S32797 F14761 - I2246 - PHILIPS-TH allow duplicate order numbers, if warehouse is different - END
			
		end if
		lb_delete_records = false
	
	end if //lb_process_replacements
	
	// LTK 20120215 end of REPLACE logic
	
	/* dts 06/14/06 - dts - Hillman wants to reject order if the Customer Order Number
	already exists (and give a different message).	
	6/30/06 - dts - Now not rejecting orders with 'DISPLAY' for Customer Order */
	if lsProject = 'HILLMAN' and llDMasterCount = 0 then
		lsCustPO = idsDOHeader.GetItemString(llHeaderPos,'order_no')
		llCountPO = 0
		if upper(lsCustPO) <> 'DISPLAY' then
			if lsCustPO > ' ' then
				select count(do_no) into :llCountPO
				from delivery_master with(nolock)
				where project_id = :lsProject
				and ord_status <> 'V'
				and cust_order_no = :lsCustPO;
				llDMasterCount = llCountPO //set llDMasterCount to trigger rejection (if llCountPO > 0)
			end if
		end if
	end if
	
	//lsHeaderErrorText = ''	// LTK 20120215 moved above
	
	If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
	lbError = False
	
	//09-Feb-2017 :Madhu -SIMSPEVS-454 - Modified error message -START
	string lsOrigOrdstatus,lsOrdStatusDesc
	select ord_status into :lsOrigOrdstatus from Delivery_Master with(nolock) where Project_Id=:lsProject and Invoice_No=:lsOrderNo using sqlca;
	
	If upper(lsOrigOrdstatus) ='P' THEN
		lsOrdStatusDesc ='Process'
	ELSEIF upper(lsOrigOrdstatus) ='I'  THEN
		lsOrdStatusDesc ='Picking'
	ELSEIF upper(lsOrigOrdstatus) ='A'  THEN
		lsOrdStatusDesc ='Packing'
	ELSEIF upper(lsOrigOrdstatus) ='C'  THEN
		lsOrdStatusDesc ='Completed'	
	ELSEIF upper(lsOrigOrdstatus) ='D'  THEN
		lsOrdStatusDesc ='Delivered'	
	ELSEIF upper(lsOrigOrdstatus) ='V'  THEN
		lsOrdStatusDesc ='Void'	
	ELSEIF upper(lsOrigOrdstatus) ='R'  THEN
		lsOrdStatusDesc ='Ready'	
	ELSE
		lsOrdStatusDesc='New'
	END IF
	//09-Feb-2017 :Madhu -SIMSPEVS-454 - Modified error message - END
	
	//Validate action cd
	If idsDOHeader.GetItemString(llHeaderPos,'action_cd') = 'A' /* add a new Delivery Order */ Then
	
		//26-JUNE-2018 :Madhu S18653 - Back/Duplicate Order Process - Reset existing count =0
		If upper(asproject) ='REMA' and llDMasterCount > 0 Then llDMasterCount = 0
		// 03/13/2019 GailM F14761 I2246 Does the project want to allow duplicate delivery order numbers?
		If llDMasterCount > 0 and lsAllowMultDelNbrs = 'Y' and upper(asProject) <> 'HILLMAN' Then llDMasterCount = 0
		
		If llDMasterCount > 0 Then /* record already exists, can't add*/
			if llCountPO > 0 then 
				/* dts 6/14/06 - Hillman doesn't allow duplicate Customer POs and wants a different msg in that case */
				uf_writeError("Customer Order Nbr " + string(lsCustPO) + " - Attempt to duplicate PO")
				lbError = True
				lsHeaderErrorText += ', ' + "Attempt to duplicate PO"
			else
				//uf_writeError("Order Nbr (Header) " + string(lsOrderNo) + " - Order Already Exists and action code is 'Add'") //09-Feb-2017 :Madhu -SIMSPEVS-454 - Modified error message
				uf_writeError("Order Nbr (Header) " + string(lsOrderNo) + " - Order Already Exists and is in " + lsOrdStatusDesc +" stauts.  The requested action code is either  'Add' or 'Update'") //09-Feb-2017 :Madhu -SIMSPEVS-454 - Modified error message
				lbError = True
				lsHeaderErrorText += ', ' + "Order Already Exists and action code is 'Add'"
			end if
			//Continue /*next header*/
		Elseif llDMasterCount = 0 Then /*insert a new row for the new record*/
			llNewRow=idsDeliveryMaster.InsertRow(0)
		
			// LTK 2012 added logic to determine if the REPLACE do_no was set, use it, else run original logic to create the do_no
			if Len(ls_replace_do_no) > 0 then
				lsDoNo = ls_replace_do_no
				ls_replace_do_no = ""
			else
				lbNewDO = True
				sqlca.sp_next_avail_seq_no(lsproject,"Delivery_Master","DO_No" ,lddono)//get the next available RO_NO
				
				//  03/09 - PCONKL - for 10 char project ID, use 6 digit seq instead of 7 to keep within 16
				If Len(lsProject) = 10 Then
					lsDoNo = lsProject + String(Long(lddono),'000000') /*get rid of decimal place*/
				Else
					lsDoNo = lsProject + String(Long(lddono),'0000000') /*get rid of decimal place*/
				End If
			end if
		
			idsDeliveryMaster.SetItem(llNewRow,'Do_no',lsDoNo)
			idsDeliveryMaster.SetItem(llNewRow,'project_id',lsProject)
		
			// 11/03 - PCONKL - If lsOrderNo begins with "SYS-", we want to assign the next available order number, otherwise take from import
			If Left(lsOrderNo,4) = 'SYS-' Then
				lsInvoiceNo = String(Long(lddono),'0000000')
			Else
				if lsProject = 'WS-MHD'  then // TAM W&S 2011/04/22  -  WS-MHD has a formatted invoice number based on the dono
					lsInvoiceNo = lsOrderNo + Right(lsdono, 4)
				Else
					lsInvoiceNo = lsOrderNo
				End If
			End If
		
			idsDeliveryMaster.SetItem(llNewRow,'invoice_no',lsInvoiceNo)
			idsDeliveryMaster.SetItem(llNewRow,'last_update',ldtWhTime) // 11/19/2010 ujh: ( LU Loc)  Last_Update reflect Local Wh not GMT
			idsDeliveryMaster.SetItem(llNewRow,'last_user','SIMSFP')
			idsDeliveryMaster.SetItem(llNewRow,'create_user','SIMSFP')			
		
		Else /*error on Retreive*/
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " - System Error: Unable to retrieve Delivery Order Record")
			lbError = True
			lsHeaderErrorText += ', ' + "System Error: Unable to retrieve Delivery Order Record"
			//Continue /*next header*/
		End If
		IF (lsProject = 'NIKE-SG' OR lsProject = 'NIKE-MY') and Not lbError Then
			lbSendDst = true
		End IF
	
	ElseIf idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'U' Then /*update*/
	
		If llDMasterCount <=0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Order does not exist and action code is 'Update'")
			lbError = True
			lsHeaderErrorText += ', ' + "Order does not exist and action code is 'Update'"
			//Continue /*next header*/
		else
			lsDoNo = idsDeliveryMaster.GetItemString(1,'DO_NO') //06/28/04 - dts
		End If
	
	ElseIf idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'D' Then /*If Status is New, Delete*/
	
			//TimA 01/05/12 We no longer delete records .  we now put them in a void status.  Part of the OTM project
			If llDMasterCount > 0 Then /*delete all Picking, detail and master records - If status is new*/
			
				if Upper(idsDOHeader.GetItemString(llHeaderPos,'project_id')) = 'PANDORA' then
				
					If idsDeliveryMaster.GetITemString(1,'Ord_Status') <> 'N' And &
						idsDeliveryMaster.GetITemString(1,'Ord_Status') <> 'H' Then	// LTK 20120216 Added <> Hold
						uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Order is not in new status and action Code is 'Delete'")
						lbError = True
						lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete'"
					Else
						If idsDeliveryMaster.GetITemString(1,'Ord_Status') = 'N' OR &
							idsDeliveryMaster.GetITemString(1,'Ord_Status') = 'H' Then	// LTK 20120216 Added the Hold status
							lsDoNo = idsDeliveryMaster.GetItemString(1,'DO_NO')
							
							Long llSkuRowCount, llSkuRowPos
							datastore ldsDeliveryDetail
							
							If not isvalid(ldsDeliveryDetail) Then
								ldsDeliveryDetail = Create u_ds_datastore
								ldsDeliveryDetail.dataobject= 'd_delivery_detail_skus'
							End If
							
							ldsDeliveryDetail.SetTransObject(SQLCA)
							ldsDeliveryDetail.retrieve(lsDoNo )
							
							//TimA 01/05/12 OTM Project
							llSkuRowCount =  ldsDeliveryDetail.Rowcount()
							For llSkuRowPos = 1 to llSkuRowCount
								isDeleteSkus[llSkuRowPos] = ldsDeliveryDetail.GetItemString(llSkuRowPos,'sku')
							Next
							
							Update delivery_master
							Set ord_status = 'V'
							where project_id = :lsProject
							and do_no = :lsDoNo;
						
						End if
					  Continue /*next header*/
					End if
				
				else	
					If idsDeliveryMaster.GetITemString(1,'Ord_Status') <> 'N' Then
						uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Order is not in new status and action Code is 'Delete'")
						lbError = True
						lsHeaderErrorText += ', ' + "Order is not in a new status and action Code is 'Delete'"
						//Continue /*next header*/
					Else /*delete*/
						lsDoNo = idsDeliveryMaster.GetItemString(1,'DO_NO')
						Delete from Delivery_Picking_Detail where do_no = :lsDoNo;
						Delete from Delivery_Picking where do_no = :lsDoNo;
						Delete from Delivery_detail where do_no = :lsDoNo;
						Delete from Delivery_notes where do_no = :lsDoNo; /* 09/03 - PCONKL */
						Delete from Delivery_bom where do_no = :lsDoNo; /* 10/06 - PCONKL */
						Delete from Delivery_alt_address where do_no = :lsDoNo; /* 09/03 - PCONKL */
						Delete From Delivery_master where do_no = :lsDoNo;
						
						llDeleteCount ++ /*update number of orders deleted*/
						Continue /*next header*/
					End If //Ord Status
				end if //Pandora 
		Else /*delete and no records exist - ignore (llDMasterCount =0)*/
			Continue /*Next header*/
		End If
	
	Else /*invalid Action Type*/
		uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsDOHeader.GetITemString(llHeaderPos,'action_cd')) 
		lbError = True
		lsHeaderErrorText += ', ' + "Order Nbr (Header): " + string(lsOrderNo) + " Invalid Action Type: " + idsDOHeader.GetITemString(llHeaderPos,'action_cd')
		//Continue /*next header*/
	End If /*Action Type*/
	
	llDMasterCount = idsDeliveryMaster.RowCount()
	
	//Validate Project
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'project_id')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Project with(nolock)
		Where Project_id = :lsTemp;
		
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Project: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid Project"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'project_id',lsTemp)
		End If
	End If
	
	//Validate Warehouse
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'wh_code')
		If isNull(lsTemp) Then lsTemp = ''
		Select Count(*) into :llCount
		From Warehouse with(nolock)
		Where wh_code = :lsTemp;
		
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Warehouse: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid Warehouse"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'wh_code',lsTemp)
		End If
	End If
	
	//Validate Inventory Type
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetITemString(llHeaderPos,'inventory_type')		
		If isNull(lsTemp) Then lsTemp = 'N' // 09/09 - now setting lsTemp to 'N' instead of ''
		//Jxlim 05/08/2013 Kinderdijk- Inventory Type at header line doesn't mean anything for Kinderdijk. Treated as a blank inventory type.
		//This inventory type has no corelation with Order detail line, and it doens' exist in Inventory type code table in Kinderdijk.
		If Upper(lsProject) ='KINDERDIJK' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'inventory_type','')
		Else
			Select Count(*) into :llCount
			From inventory_type
			Where project_id = :lsProject and inv_type = :lsTemp;
			
				If llCount <= 0 Then
					uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Inventory Type: " + lsTemp) 
					lbError = True
					lsHeaderErrorText += ', ' + "Invalid Inventory Type"
					//Continue /*next header*/
				Else /*update the header record*/
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'inventory_type',lsTemp)
				End If
		End If   
	End If
	
	//Validate Order Type
	If llDMasterCount > 0 Then
		lsTemp = idsDOHeader.GetItemString(llHeaderPos,'order_type')
		If isNull(lsTemp) Then lsTemp = ''
		
		Select Count(*) into :llCount
		From delivery_order_type with(nolock)
		Where Ord_type = :lsTemp;
		
		If llCount <= 0 Then
			uf_writeError("Order Nbr (Header): " + string(lsOrderNo) + " Invalid Order Type: " + lsTemp) 
			lbError = True
			lsHeaderErrorText += ', ' + "Invalid order Type"
			//Continue /*next header*/
		Else /*update the header record*/
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_type',lsTemp)
		End If
	End If
	
	// If any header errors were encountered, update the edi record with status code and error text
	If lbError then
	
		idsDOHeader.SetITem(llHeaderPos,'status_cd','E')
		If Left(lsheaderErrorText,1) = ',' Then lsHeaderErrorText = Right(lsheaderErrorText,(len(lsHeaderErrorText) - 1)) /*strip first comma*/
		idsDOHeader.SetITem(llHeaderPos,'status_message',lsHeaderErrorText)
		idsDOHeader.Update()
		
		Update edi_outbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header.'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
		Commit;
		
		//2017/07 TAM PINT-856 -Update respective tables of OM -START
		If idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			this.uf_process_om_writeerror( lsproject, 'E', idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'), 'OB', lsHeaderErrorText) //write error log and trigger email alert
		End If
		//2017/07 TAM PINT-856 -Update respective tables of OM -END		
		
		Continue /*Next Header*/
		
	Else /* No errors */
	
		// LTK 20120217 Pandora no longer requires schedule_date to be set because it is being used for OTM.
		if lsProject <> 'PANDORA' then
			//Update other fields...
			If isDAte(idsDOHeader.GetITemString(llHeaderPos,'schedule_date')) Then
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'schedule_date',Date(idsDOHeader.GetITemString(llHeaderPos,'schedule_date')))
			Else
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'schedule_date',ldtWHTime)   // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
			End If
		Else
			//TAM 2917/04 - For Pandora Schedule date is now being set as a cutoff time
			string lsScheduleDateTime
			lsScheduleDateTime = idsDOHeader.GetItemString(llHeaderPos,'schedule_date')
			If Isdate(left(lsScheduleDateTime, 10)) Then
				if len(lsScheduleDateTime) > 10 then
					//Validate the time portion?...
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'schedule_date', datetime(lsScheduleDateTime))
				else
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'schedule_date', date(lsScheduleDateTime))
				end if
			end if
		
		end if
		
		// GailM = 07/21/2015 - Delivery date was taken out but NYX needs it.  Only set delivery date for project NYX
		if lsProject = 'NYX' then
			If Isdate(idsDOHeader.GetITemString(llHeaderPos,'delivery_date')) Then
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'delivery_date',Date(idsDOHeader.GetITemString(llHeaderPos,'delivery_date')))
			End If
		end if
		
		//dts 2015/12/01 - Pandora now (possibly) including the time portion (in format YYYY/MM/DD HH:MM)  //TAM 2015/12/14  - NYX also using Time
		if Upper(lsProject) = 'PANDORA'  or Upper(lsProject) = 'NYX'   then
			string lsRequestDateTime
			lsRequestDateTime = idsDOHeader.GetItemString(llHeaderPos,'request_date')
			If Isdate(left(lsRequestDateTime, 10)) Then
				if len(lsRequestDateTime) > 10 then
					//Validate the time portion?...
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'request_date', datetime(lsRequestDateTime))
				else
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'request_date', date(lsRequestDateTime))
				end if
			end if
			
			//TimA 07/31/12 Pandora issue #460 make the original RDD the same as the Required on all new orders.
			//idsDeliveryMaster.SetItem(1,'edm_generate_datetime',Date(idsDOHeader.GetITemString(llHeaderPos,'request_date')))
			//dts 2015/12/01 - Pandora now (possibly) including the time portion....
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'edm_generate_datetime',DateTime(idsDOHeader.GetItemString(llHeaderPos,'request_date')))
		else //not Pandora...
			If Isdate(idsDOHeader.GetITemString(llHeaderPos,'request_date')) Then
				if Upper(lsProject) = 'STBTH' then
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'request_date',DateTime(Date(idsDOHeader.GetITemString(llHeaderPos,'request_date')), now()))		// LTK 20131021
				else
					idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'request_date',Date(idsDOHeader.GetITemString(llHeaderPos,'request_date')))
				end if
			
			End If
		end if //is Pandora?
		
		
		If Not  isnull(idsDOHeader.GetITemString(llHeaderPos,'ord_date')) and idsDOHeader.GetITemString(llHeaderPos,'ord_date') > '' and  isDate(String(Date(idsDOHeader.GetITemString(llHeaderPos,'ord_date')))) Then /* order date may come in the file, otherwise set to today*/
			if len(trim( idsDOHeader.GetITemString(llHeaderPos,'ord_date') ) ) > 10 then //MEA - 9/12 Check to see if datetime included.
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_date',DateTime(idsDOHeader.GetITemString(llHeaderPos,'ord_date')))
			else
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_date',DateTime(Date(idsDOHeader.GetITemString(llHeaderPos,'ord_date')), Time("00:00")))
			end if
		Else
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_date',ldtWHTime)    // 11/19/2010 ujh: ( LU Loc)  Last Update reflect Local Wh not GMT
		End If
		
		if lsProject = 'STRYKER' THEN    //MEA - 6/12 - Do no update the status if STRYKER and Update
			if IsNull(idsDeliveryMaster.GetITemString(1,'Ord_Status')) THEN  
				idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_status','N')
			end if
		else
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ord_status','N')
		end if
		
		//mar 2010 - added ord_status.  set it if it's present in the edi staging table...
		lsOrdStatus = idsDOHeader.GetItemString(llHeaderPos, 'ord_status')
		if lsOrdStatus > '' then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'ord_status', lsOrdStatus)
		end if
		
		idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'edi_batch_seq_no',idsDOHeader.GetItemNumber(llHeaderPos,'edi_batch_seq_no'))
		idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'freight_cost',0)
		
		//27-JUNE-2018 :Madhu S19513  REMA Back Order - Order Type (No Idea!, how order_type set earlier)
		If idsDOHeader.GetItemString(llHeaderPos,'order_type') > ' ' Then
			idsDeliveryMaster.SetItem( idsDeliveryMaster.RowCount(), 'ord_type', idsDOHeader.GetItemString(llHeaderPos,'order_type'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'Cust_code') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Cust_code',idsDOHeader.GetItemString(llHeaderPos,'Cust_Code'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Cust_Name') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Cust_Name',idsDOHeader.GetItemString(llHeaderPos,'Cust_Name'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_1') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Address_1',idsDOHeader.GetITemString(llHeaderPos,'Address_1'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_2') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Address_2',idsDOHeader.GetITemString(llHeaderPos,'Address_2'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_3') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Address_3',idsDOHeader.GetITemString(llHeaderPos,'Address_3'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Address_4') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Address_4',idsDOHeader.GetITemString(llHeaderPos,'Address_4'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'City') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'City',idsDOHeader.GetITemString(llHeaderPos,'City'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'State') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'State',idsDOHeader.GetITemString(llHeaderPos,'State'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Zip') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Zip',idsDOHeader.GetITemString(llHeaderPos,'Zip'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Country') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Country',idsDOHeader.GetITemString(llHeaderPos,'Country'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'District') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'District',idsDOHeader.GetITemString(llHeaderPos,'District'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'tel') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'tel',idsDOHeader.GetITemString(llHeaderPos,'tel'))
		End If
		
		//MEA - 4/13 - Added Fax
		If idsDOHeader.GetItemString(llHeaderPos,'fax') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'fax',idsDOHeader.GetITemString(llHeaderPos,'fax'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'Carrier') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Carrier',idsDOHeader.GetITemString(llHeaderPos,'Carrier'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Agent_Info') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Agent_Info',idsDOHeader.GetITemString(llHeaderPos,'Agent_Info'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Freight_Terms') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Freight_Terms',idsDOHeader.GetITemString(llHeaderPos,'Freight_Terms'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'Ship_Via') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Ship_Via',idsDOHeader.GetITemString(llHeaderPos,'Ship_Via'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'Remark') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Remark',idsDOHeader.GetITemString(llHeaderPos,'Remark'))
		End if			
		
		If idsDOHeader.GetItemString(llHeaderPos,'Ship_Ref') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Ship_Ref',idsDOHeader.GetITemString(llHeaderPos,'Ship_Ref'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'om_note_code_text') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'om_note_code_text',idsDOHeader.GetITemString(llHeaderPos,'om_note_code_Text'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'packlist_notes_text') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Packlist_notes',idsDOHeader.GetITemString(llHeaderPos,'packlist_notes_text'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'shipping_instructions_text') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Shipping_Instructions',idsDOHeader.GetITemString(llHeaderPos,'shipping_instructions_text'))
		End If
		//SARUN2013DEC11 START: adding feild Freight_ETD,Freight_ETA,Freight_ATD,Freight_ATA	 http://team/sites/simsteam/wiki/Documents/Customers/KloneLab/Klone%20Changes%20-%20start%20and%20cancel%20date%20mapping.docx
		If not isnull(idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ETD'))  Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Freight_ETD',idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ETD'))
		End If
		If not isnull(idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ETA'))  Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Freight_ETA',idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ETA'))
		End If
		If not isnull(idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ATD'))  Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Freight_ATD',idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ATD'))
		End If
		If not isnull(idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ATA'))  Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Freight_ATA',idsDOHeader.GetItemDatetime(llHeaderPos,'Freight_ATA'))
		End If
		
		//SARUN2013DEC11 END :		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field1') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field1',idsDOHeader.GetITemString(llHeaderPos,'User_field1'))
			//TimA 01/24/12 OTM Project
			lsScheduleCode 	= idsDOHeader.GetItemString(llHeaderPos,'User_field1')
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field2') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field2',idsDOHeader.GetITemString(llHeaderPos,'User_field2'))
			//TimA 04/16/12 Pandora issue #396 Get the From Loc:
			lsFromWH = idsDOHeader.GetItemString(llHeaderPos,'User_field2')
		End If
		
		//Jxlim 05/09/2013 KINDERDIJK; C = Consignment Outbound Order Type; O =Outright Outbound Order Type
		//uses Outbound header user_field22 to store this value; it maybe use for future report requirments
		//ValidateOutbound Order Type	
		lsOutboundType = idsDOHeader.GetITemString(llHeaderPos,'user_field22') 
		If  lsOutboundType > ' ' Then					
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'User_field22', lsOutboundType)  /* Outbound Order Type*/ 	
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field3') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field3',idsDOHeader.GetITemString(llHeaderPos,'User_field3'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field4') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field4',idsDOHeader.GetITemString(llHeaderPos,'User_field4'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field5') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field5',idsDOHeader.GetITemString(llHeaderPos,'User_field5'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field6') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field6',idsDOHeader.GetITemString(llHeaderPos,'User_field6'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field7') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field7',idsDOHeader.GetITemString(llHeaderPos,'User_field7'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field8') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field8',idsDOHeader.GetITemString(llHeaderPos,'User_field8'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field9') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field9',idsDOHeader.GetITemString(llHeaderPos,'User_field9'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field10') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field10',idsDOHeader.GetITemString(llHeaderPos,'User_field10'))
		End If
		// 04/16/2009 - added new user fields...
		If idsDOHeader.GetItemString(llHeaderPos,'User_field11') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field11',idsDOHeader.GetITemString(llHeaderPos,'User_field11'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field12') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field12',idsDOHeader.GetITemString(llHeaderPos,'User_field12'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field13') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field13',idsDOHeader.GetITemString(llHeaderPos,'User_field13'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field14') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field14',idsDOHeader.GetITemString(llHeaderPos,'User_field14'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field15') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field15',idsDOHeader.GetITemString(llHeaderPos,'User_field15'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field16') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field16',idsDOHeader.GetITemString(llHeaderPos,'User_field16'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field17') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field17',idsDOHeader.GetITemString(llHeaderPos,'User_field17'))
		End If
		If idsDOHeader.GetItemString(llHeaderPos,'User_field18') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field18',idsDOHeader.GetITemString(llHeaderPos,'User_field18'))
		End If
		
		//TimA 08/04/11 Pandora issue #192
		//Needed to add user field19 but saw that there were more.  Per pete I added columns that are in delivery_master User fields 19,20,21,22
		If idsDOHeader.GetItemString(llHeaderPos,'User_field19') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field19',idsDOHeader.GetITemString(llHeaderPos,'User_field19'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field20') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field20',idsDOHeader.GetITemString(llHeaderPos,'User_field20'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field21') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field21',idsDOHeader.GetITemString(llHeaderPos,'User_field21'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'User_field22') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'User_field22',idsDOHeader.GetITemString(llHeaderPos,'User_field22'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'ctn_cnt') > ' ' Then /* 03/02 - PCONKL - Add to existing ctn cnt if present*/
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'ctn_cnt',(idsDeliveryMaster.GetItemNumber(1,'ctn_cnt') + Long(idsDOHeader.GetITemString(llHeaderPos,'Ctn_Cnt'))))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'weight') > ' ' Then /* 04/03 - PCONKL - Add to existing weight if present*/
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'weight',(idsDeliveryMaster.GetItemNumber(1,'weight') + Long(idsDOHeader.GetITemString(llHeaderPos,'weight'))))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'consolidation_no') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'consolidation_no',idsDOHeader.GetITemString(llHeaderPos,'consolidation_no'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'awb_bol_no') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'awb_bol_no',idsDOHeader.GetITemString(llHeaderPos,'awb_bol_no'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'order_no') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'cust_order_No',idsDOHeader.GetITemString(llHeaderPos,'order_no'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'gls_tr_ID') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'gls_tr_ID',idsDOHeader.GetITemString(llHeaderPos,'gls_tr_ID'))
		End If
	
		If idsDOHeader.GetItemString(llHeaderPos,'line_of_business') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'line_of_business',idsDOHeader.GetITemString(llHeaderPos,'line_of_business'))
		End If
	
		If idsDOHeader.GetItemString(llHeaderPos,'export_control_commodity_no') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'export_control_commodity_no',idsDOHeader.GetITemString(llHeaderPos,'export_control_commodity_no'))
		End If
	
		If idsDOHeader.GetItemString(llHeaderPos,'contact_Person') > ' ' Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'contact_Person',idsDOHeader.GetITemString(llHeaderPos,'contact_Person'))
		End If
	
		If idsDOHeader.GetItemString(llHeaderPos,'email_address') > ' ' Then /* 08/09 - PCONKL */
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'email_address',idsDOHeader.GetITemString(llHeaderPos,'email_address'))
		End If
	
		If idsDOHeader.GetItemString(llHeaderPos,'Transport_Mode') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Transport_Mode',idsDOHeader.GetITemString(llHeaderPos,'Transport_Mode'))
		End If
		
		If idsDOHeader.GetItemNumber(llHeaderPos,'priority') > 0 Then 
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'priority',idsDOHeader.GetITemNumber(llHeaderPos,'priority'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos,'Vat_ID') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'Vat_ID',idsDOHeader.GetITemString(llHeaderPos,'Vat_ID'))
		End If
		
		// 2010/01/17 - TAM -  Customer Sent Date
		If Isdate(idsDOHeader.GetITemString(llHeaderPos,'customer_sent_date')) Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'customer_sent_date',Date(idsDOHeader.GetITemString(llHeaderPos,'customer_sent_date')))
		End If
	
		// dts - 2010/10/04 - CrossDock_IND
		If idsDOHeader.GetItemString(llHeaderPos, 'CrossDock_IND') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'CrossDock_IND', idsDOHeader.GetItemString(llHeaderPos, 'CrossDock_IND'))
		End If
		
		// TAM - 2012/03/05 - Trax - Duty Terms and Account Numbers 
		If idsDOHeader.GetItemString(llHeaderPos, 'Trax_Acct_No') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Trax_Acct_No', idsDOHeader.GetItemString(llHeaderPos, 'Trax_Acct_No'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos, 'Trax_Duty_Terms') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Trax_Duty_Terms', idsDOHeader.GetItemString(llHeaderPos, 'Trax_Duty_Terms'))
		End If
		
		If idsDOHeader.GetItemString(llHeaderPos, 'Trax_Duty_Acct_No') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Trax_Duty_Acct_No', idsDOHeader.GetItemString(llHeaderPos, 'Trax_Duty_Acct_No'))
		End If
			
		//MEA - 9/12 - Added Trax_Pack_Location
		
		If idsDOHeader.GetItemString(llHeaderPos, 'trax_pack_location') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'trax_pack_location', idsDOHeader.GetItemString(llHeaderPos, 'trax_pack_location'))
		End If
		
		//Jxlim 06/02/2014 - Added ignore_Shelflife_ind	
		If idsDOHeader.GetItemString(llHeaderPos, 'ignore_shelflife_ind') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'ignore_shelflife_ind',  idsDOHeader.GetItemString(llHeaderPos, 'ignore_shelflife_ind'))
		End If
		
		// TAM - 2015/05/01 - Departments Code - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Department_Code') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Department_Code', idsDOHeader.GetItemString(llHeaderPos, 'Department_Code'))
		End If
		
		// TAM - 2015/05/01 - Departments Name - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Department_Name') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Department_Name', idsDOHeader.GetItemString(llHeaderPos, 'Department_Name'))
		End If
		// TAM - 2015/05/01 -  Division - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Division') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Division', idsDOHeader.GetItemString(llHeaderPos, 'Division'))
		End If
		// TAM - 2015/05/01 - Vendor - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Vendor') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Vendor', idsDOHeader.GetItemString(llHeaderPos, 'Vendor'))
		End If
		
		// TAM - 2015/06/24 - Routing Code - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Routing_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Routing_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Routing_Nbr'))
		End If
		
		// TAM - 2015/06/24 - Client Cust PO Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Client_Cust_PO_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Client_Cust_PO_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Client_Cust_PO_Nbr'))
		End If
		
		// TAM - 2015/06/24 - Client Cust SO Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Client_Cust_SO_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Client_Cust_SO_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Client_Cust_SO_Nbr'))
		End If
		
		
		// TAM - 2015/09/16 - Department_Name - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Department_Name') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Department_Name', idsDOHeader.GetItemString(llHeaderPos, 'Department_Name'))
		End If
		
		// TAM - 2015/09/16 - Account_Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Account_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Account_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Account_Nbr'))
		End If
		
		// TAM - 2015/09/16 - ASN_Number - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'ASN_Number') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'ASN_Number', idsDOHeader.GetItemString(llHeaderPos, 'ASN_Number'))
		End If
		
		// TAM - 2015/09/16 - Container_Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Container_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Container_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Container_Nbr'))
		End If
		
		// TAM - 2015/09/16 - Dock_Code - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Dock_Code') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Dock_Code', idsDOHeader.GetItemString(llHeaderPos, 'Dock_Code'))
		End If
		
		// TAM - 2015/09/16 - Document_Codes - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Document_Codes') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Document_Codes', idsDOHeader.GetItemString(llHeaderPos, 'Document_Codes'))
		End If
		
		// TAM - 2015/09/16 -  Equipment_Nbr - New Named Field
		If isNumber(idsDOHeader.GetItemstring(llHeaderPos, 'Equipment_Nbr')) Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Equipment_Nbr', dec(idsDOHeader.GetItemString(llHeaderPos, 'Equipment_Nbr')))
		End If
		
		// TAM - 2015/09/16 - Department_Name - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'FOB') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'FOB', idsDOHeader.GetItemString(llHeaderPos, 'FOB'))
		End If
		
		// TAM - 2015/09/16 - FOB_Bill_Duty_Acct - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Duty_Acct') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'FOB_Bill_Duty_Acct', idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Duty_Acct'))
		End If
		
		// TAM - 2015/09/16 - FOB_Bill_Duty_Party - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Duty_Party') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'FOB_Bill_Duty_Party', idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Duty_Party'))
		End If
		
		// TAM - 2015/09/16 - FOB_Bill_Freight_To_Acct - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Freight_To_Acct') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'FOB_Bill_Freight_To_Acct', idsDOHeader.GetItemString(llHeaderPos, 'FOB_Bill_Freight_To_Acct'))
		End If
		
		// TAM - 2015/09/16 - From_Wh_Loc - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'From_Wh_Loc') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'From_Wh_Loc', idsDOHeader.GetItemString(llHeaderPos, 'From_Wh_Loc'))
		End If
		
		// TAM - 2015/06/24 -  Seal Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Seal_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Seal_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'Seal_Nbr'))
		End If
		
		// TAM - 2015/06/24 - Shipping Route - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Shipping_Route') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Shipping_Route', idsDOHeader.GetItemString(llHeaderPos, 'Shipping_Route'))
		End If
		// TAM - 2015/06/24 -  SLI Nbr - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'SLI_Nbr') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'SLI_Nbr', idsDOHeader.GetItemString(llHeaderPos, 'SLI_Nbr'))
		End If
		
		// TAM - 2015/09/16 - Currency_Code - New Named Field
		If idsDOHeader.GetItemString(llHeaderPos, 'Currency_Code') > ' ' Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Currency_Code', idsDOHeader.GetItemString(llHeaderPos, 'Currency_Code'))
		End If
		
		// TAM - 2015/09/16 -  Order_Tax_Amt - New Named Field
		If idsDOHeader.GetItemNumber(llHeaderPos, 'Order_Tax_Amt') > 0 Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Order_Tax_Amt', idsDOHeader.GetItemNumber(llHeaderPos, 'Order_Tax_Amt'))
		End If
		
		// TAM - 2015/09/16 -  Order_Discount_Amt - New Named Field
		If idsDOHeader.GetItemNumber(llHeaderPos, 'Order_Discount_Amt') > 0 Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Order_Discount_Amt', idsDOHeader.GetItemNumber(llHeaderPos, 'Order_Discount_Amt'))
		End If
		
		// TAM - 2015/09/16 -  Shipping_Handling_Amt - New Named Field
		If idsDOHeader.GetItemNumber(llHeaderPos, 'Shipping_Handling_Amt') > 0 Then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'Shipping_Handling_Amt', idsDOHeader.GetItemNumber(llHeaderPos, 'Shipping_Handling_Amt'))
		End If
		
		// LTK 20131001  Default OTM status for Philips to resolve batch picking/confirm issue when otm_status was null
		//06-FEB-2019 :Madhu S28685 Added PHILIPSCLS
		if Upper(lsProject) = 'PHILIPS-SG' OR Upper(lsProject) = 'PHILIPSCLS' then
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(),'otm_status','R')
		end if
		
		//TAM 2019/04/12 - S25773 -DE9566 - For TMS enabled warehouses we Need to set OMS status(Set from EDI Value)
		String lsTmsFlag = 'N'
		String lsTmsWHFlag = ''

		select code_descript	into :lsTmsFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'FLAG' and code_id = 'TMS';
		select code_descript	into :lsTmsWHFlag from lookup_table	where project_id = 'PANDORA' and code_type = 'SKIP_TMS' and code_id = :lsWh_code; //Return blank means this warehouse is participating in TMS

		if lsTmsFlag = "Y" and lsTmsWHFlag = '' Then
			string lsotmsts
			lsotmsts= idsDOHeader.GetItemString(llHeaderPos, 'otm_status')
			idsDeliveryMaster.SetItem(idsDeliveryMaster.RowCount(), 'otm_status', idsDOHeader.GetItemString(llHeaderPos, 'otm_status'))
		End If
		
		//2017/07 TAM Added for PINT-856 -START
		If idsDOHeader.getitemstring(llHeaderPos, 'OM_Confirmation_Type') > ' ' Then
			idsDeliveryMaster.setitem(idsDeliveryMaster.RowCount(),'OM_Confirmation_Type', idsDOHeader.getitemstring( llHeaderPos, 'OM_Confirmation_Type'))
		else
			idsDeliveryMaster.setitem(idsDeliveryMaster.RowCount(),'OM_Confirmation_Type', 'R') //R -> Rosettanet - Regular File Process
		End If
		
		If idsDOHeader.getitemstring(llHeaderPos, 'OM_Order_Type') > ' ' Then
			idsDeliveryMaster.setitem(idsDeliveryMaster.RowCount(),'OM_Order_Type', idsDOHeader.getitemstring( llHeaderPos, 'OM_Order_Type'))
		End If		 
		
		If idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			idsDeliveryMaster.setitem(idsDeliveryMaster.RowCount(),'om_change_request_nbr', idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'))
		End If
		//2017/07 TAM Added for PINT-856 -END
		
		//22-FEB-2019 :Madhu F13501 PhilipsBlueHeart Delivery Order
		//27-APR-2019 :Madhu Since Shipment_Id doesn't exist in Pandora DB, wrapped around condition
		IF upper(asproject) <> 'PANDORA' THEN
			If idsDOHeader.getitemstring(llHeaderPos, 'Shipment_Id') > ' ' Then
				idsDeliveryMaster.setitem(idsDeliveryMaster.RowCount(),'Shipment_Id', idsDOHeader.getitemstring( llHeaderPos, 'Shipment_Id'))
			End If
		END IF
		
		//Update the Header Record
		SQLCA.DBParm = "disablebind =0"
		liRC = idsDeliveryMaster.Update()
		SQLCA.DBParm = "disablebind =1"
		If liRC = 1 then
			Commit;
		Else
			lsErrText = sqlca.sqlerrtext
			Rollback;
			uf_writeError("- ***System Error!  Unable to Save Delivery Master Record to database! " + lsErrText)
			lbError = True
			Continue /*Next Header*/
		End If
		
		//Update order insert/update count
		If idsDOHeader.GetITemString(llHeaderPos,'action_cd') = 'A' Then
			llNewCount ++
		Else
			llUpdateCOunt ++
		End if
		
		End If /* errors on header? */
		
		//Retrieve the EDI DEtail records for the current header (based on edi batch seq and Invoice_no)
		llDetailCount = idsDODetail.Retrieve(lsProject,llBatchSeq,lsOrderNo)
		
		//Once we have a detail error, we will still validate the detail rows but we wont save any new/changed detail rows to the DB
		If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
		lbError = False
		lbDetailErrors = False /*we need to know if any details have errors, lberror may be reset for each detail row*/
		
		//process each Detail Record
		For llDetailPos = 1 to llDetailCOunt
		
			If lbError Then
				lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
				lbDetailErrors = True
			End If
			
			//04/03 - PCONKL, Only reset for each detail if we are allowing partial PO's
			If lsAllowPOErrors = 'Y' Then	lbError = False 
			
			lsDetailErrorText = ''
			lsSku = idsDODetail.GetItemString(llDetailPos,'sku')	
			lsSupplier = idsDODetail.GetItemString(llDetailPos,'supp_code')
			llLineItem = idsDODetail.GetItemNumber(llDetailPos,'line_item_no')
			
			//MEA - 01/12 Order Number for Nike Set at Detail Level and stored in user_field1
			
			If lsProject = 'NIKE-SG' OR lsProject = 'NIKE-MY' Then
				lsDisplayOrderNo = idsDODetail.GetITemString(llDetailPos,'user_field1')
			Else	
				lsDisplayOrderNo = lsOrderNo
			End IF				
			
			// 10/06 - PCONKL - If an error was found on project specific NVO, don't process here
			If idsDODetail.GetITemString(llDetailPos,'status_cd') = 'E' Then
				lsDetailErrorText += ', ' + "Errors found in project specific validations"
				lbError = True
			End If
			
			//Validate Inventory Type - If pickable ind is 'N', there may not be an Inventory Type
			lsTemp = idsDODetail.GetITemString(llDetailPos,'inventory_type')
			If isNull(lsTemp) Then lsTemp = ''
		
			If lsTEmp > '' Then
			
				Select Count(*) into :llCount
				From inventory_type with(nolock)
				Where project_id = :lsProject and inv_type = :lsTemp;
				
				If llCount <=0 Then
					uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Inventory Type: " + lsTemp) 
					lsDetailErrorText += ', ' + "Invalid Inventory Type"
					lbError = True
				End If
			
			Else /*no Inventory type present*/
			
			End If /*inv type present? */
			
			//Validate SKU
			lsTemp = idsDODetail.GetITemString(llDetailPos,'sku')
			If isNull(lsTemp) Then lsTemp = ''
			Select Count(*) into :llCount
			From Item_Master with(nolock)
			Where project_id = :lsProject and sku = :lsTemp;
			
			If llCount <=0 Then
				uf_writeError("Order Nbr/Line (detail): " + string(lsDisplayOrderNo) + '/' + string(llDetailPos) + " Invalid SKU: " + lsTemp) 
				lsDetailErrorText += ', ' + "Invalid SKU"
				lbError = True
			End If
			
			// 04/03 - PCONKL - Validate Supplier for current SKU if present, if not rpesent, retrieve from Item MAster 
			llCount = 0
			If (not isnull(lsSUpplier)) and lsSupplier > '' Then /*present - validate*/
			
				Select Count(*) into :llCount
				From Item_Master with(nolock)
				Where project_id = :lsProject and sku = :lsTemp and supp_code = :lsSupplier;
				
			Else /* not present, retrieve from Item Master */
				
				Select Min(supp_code) into :lsSupplier
				From Item_Master with(nolock)
				Where project_id = :lsProject and sku = :lsTemp;
			End If
			
			If llCount = 0 and (isnull(lsSupplier) or lsSupplier = '') Then
				uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid/Missing Supplier for this SKU: " + lsSupplier) 
				lsDetailErrorText += ', ' + "Invalid/Missing Supplier for this SKU."
				lbError = True
			End If
			
			//Quantity must be Numeric
			If not isNumber(idsDODetail.GetITemString(llDetailPos,'Quantity')) Then
				uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Quantity is not numeric: " ) 
				lsDetailErrorText += ', ' + "Quantity is not numeric"
				lbError = True
			Else
				ldQty = Dec(idsDODetail.GetITemString(llDetailPos,'Quantity')) /*used to validate against Serial # below*/
			End If
			
			//Validate COO if present
			lsTemp = idsDODetail.GetITemString(llDetailPos,'country_of_origin') 
			If isNull(lsTemp) Then lsTemp = ''
			If Trim(lsTEmp) > '' Then
			
				If f_get_Country_Name(lsTemp) > '' Then
				Else
					uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " Invalid Country of Origin: " + lsTemp) 
					lsDetailErrorText += ', ' + "Invalid Country of Origin"
					lbError = True
				End If
			
			End If
			
			// 10/06 - PCONKL - If serial # is present, Qty must = 1
			If idsDODetail.GetITemString(llDetailPos,'Serial_no') > "" and idsDODetail.GetITemString(llDetailPos,'Serial_no') <> '-' and ldQty > 1 Then
				uf_writeError("Order Nbr/Line (detail): " + string(lsOrderNo) + '/' + string(llDetailPos) + " If serial Number present, Qty Must equal 1") 
				lsDetailErrorText += ', ' + "If serial Number present, Qty Must equal 1"
				lbError = True
			End If
			
			//If no errors, apply the updates
			If Not lbError Then
			
				/*0628/04 - dts - now basing Retrieve on Do_No instead of Invoice_No */
				llDDetailCount = idsDeliveryDetail.Retrieve(lsDoNo,lsSku,lsSupplier,llLineItem)
				
				If llDDetailCount > 0 Then /*details exist (llDDetailCount > 0) */
				
					//update any other changed fields from edi detail to Delivery detail
					If idsDODetail.GetItemString(llDetailPos,'user_field1') > ' ' Then
						idsDeliveryDetail.SetItem(1,'user_field1',idsDODetail.GetItemString(llDetailPos,'user_field1'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field2') > ' ' Then
						idsDeliveryDetail.SetItem(1,'user_field2',idsDODetail.GetItemString(llDetailPos,'user_field2'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field3') > ' ' Then
						idsDeliveryDetail.SetItem(1,'user_field3',idsDODetail.GetItemString(llDetailPos,'user_field3'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field4') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'user_field4',idsDODetail.GetItemString(llDetailPos,'user_field4'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field5') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'user_field5',idsDODetail.GetItemString(llDetailPos,'user_field5'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'currency_Code') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'currency_Code',idsDODetail.GetItemString(llDetailPos,'currency_Code'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Price') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Price',Dec(idsDODetail.GetItemString(llDetailPos,'Price')))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes') > ' ' Then
						idsDeliveryDetail.SetItem(1,'Line_Item_Notes',idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'gls_so_id') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'gls_so_id',idsDODetail.GetItemString(llDetailPos,'gls_so_id'))
					End If
					
					If idsDODetail.GetItemNumber(llDetailPos,'gls_so_line') > 0 Then 
						idsDeliveryDetail.SetItem(1,'gls_so_line',idsDODetail.GetItemNumber(llDetailPos,'gls_so_Line'))
					End If
					
					//TAM 2015/05/01 - Added New Named Fields
					If idsDODetail.GetItemString(llDetailPos,'Buyer_Part') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Buyer_Part',idsDODetail.GetItemString(llDetailPos,'Buyer_Part'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Vendor_Part') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Vendor_Part',idsDODetail.GetItemString(llDetailPos,'Vendor_Part'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'UPC') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'UPC',idsDODetail.GetItemString(llDetailPos,'UPC'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'EAN') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'EAN',idsDODetail.GetItemString(llDetailPos,'EAN'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'GTIN') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'GTIN',idsDODetail.GetItemString(llDetailPos,'GTIN'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Department_Name') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Department_Name',idsDODetail.GetItemString(llDetailPos,'Department_Name'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Division') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Division',idsDODetail.GetItemString(llDetailPos,'Division'))
					End If
					
					// TAM - 2015/06/02 - Packaging Characteristics - New Named Field
					If idsDODetail.GetItemString(llDetailPos,'Packaging_Characteristics') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Packaging_Characteristics',idsDODetail.GetItemString(llDetailPos,'Packaging_Characteristics'))
					End If
					
					// TAM - 2015/09/16 - Line_Total_Amt - New Named Field
					If idsDODetail.GetItemNumber(llDetailPos,'Line_Total_Amt') > 0 Then 
						idsDeliveryDetail.SetItem(1,'Line_Total_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Total_Amt'))
					End If
					
					// TAM - 2015/09/16 - Line_Tax_Amt - New Named Field
					If idsDODetail.GetItemNumber(llDetailPos,'Line_Tax_Amt') > 0 Then 
						idsDeliveryDetail.SetItem(1,'Line_Tax_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Tax_Amt'))
					End If
					
					// TAM - 2015/09/16 - Line_Discount_Amt - New Named Field
					If idsDODetail.GetItemNumber(llDetailPos,'Line_Discount_Amt') > 0 Then 
						idsDeliveryDetail.SetItem(1,'Line_Discount_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Discount_Amt'))
					End If
					
					// 12/15 - PCONKL - TODO - Add any new Detail named fields
					If idsDODetail.GetItemString(llDetailPos,'uom') > ' ' Then
						idsDeliveryDetail.SetItem(1,'uom',idsDODetail.GetItemString(llDetailPos,'uom')) 
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field6') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'user_field6',idsDODetail.GetItemString(llDetailPos,'user_field6'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'user_field7') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'user_field7',idsDODetail.GetItemString(llDetailPos,'user_field7'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Client_Cust_Line_No') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Client_Cust_Line_No',idsDODetail.GetItemString(llDetailPos,'Client_Cust_Line_No'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'CI_Value') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'CI_Value',idsDODetail.GetItemString(llDetailPos,'CI_Value'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'currency_code') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'currency_code',idsDODetail.GetItemString(llDetailPos,'currency_code'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Cust_Line_Nbr') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Cust_Line_Nbr',idsDODetail.GetItemString(llDetailPos,'Cust_Line_Nbr'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Client_Cust_Invoice') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Client_Cust_Invoice',idsDODetail.GetItemString(llDetailPos,'Client_Cust_Invoice'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Cust_PO_Nbr') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Cust_PO_Nbr',idsDODetail.GetItemString(llDetailPos,'Cust_PO_Nbr'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Delivery_Nbr') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Delivery_Nbr',idsDODetail.GetItemString(llDetailPos,'Delivery_Nbr'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Internal_Price') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Internal_Price',idsDODetail.GetItemString(llDetailPos,'Internal_Price'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Client_Inv_Type') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Client_Inv_Type',idsDODetail.GetItemString(llDetailPos,'Client_Inv_Type'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Permit_Nbr') > ' ' Then 
						idsDeliveryDetail.SetItem(1,'Permit_Nbr',idsDODetail.GetItemString(llDetailPos,'Permit_Nbr'))
					End If
					
					//12-Jan-2016 :Madhu added New Name Fields for H2O
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Name') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Name',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Name'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Address_1') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_1',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_1'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Address_2') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_2',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_2'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Address_3') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_3',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_3'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Address_4') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_4',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_4'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_City') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_City',idsDoDetail.GetItemString(llDetailPos,'Mark_For_City'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_State') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_State',idsDoDetail.GetItemString(llDetailPos,'Mark_For_State'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Zip') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Zip',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Zip'))
					End If
					
					If idsDODetail.GetItemString(llDetailPos,'Mark_For_Country') >' ' Then
						idsDeliveryDetail.SetItem(1,'Mark_For_Country',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Country'))
					End If
					
					//2017/07 :TAM Added for PINT-856
					If idsDODetail.GetItemNumber(llDetailPos,'om_change_request_nbr') > 0 Then
						idsDeliveryDetail.SetItem(1,'om_change_request_nbr', idsDODetail.GetItemNumber(llDetailPos,'om_change_request_nbr'))
					End If
					
					//22-FEB-2019 :Madhu F13501 PhilipsBlueHeart Delivery Order
					If idsDODetail.GetItemString(llDetailPos, 'VAT_Identifier') >' ' Then
						idsDeliveryDetail.SetItem(1, 'VAT_Identifier',idsDoDetail.GetItemString(llDetailPos, 'VAT_Identifier'))
					End If
				
				ElseIf llDDetailCount = 0 Then /*no details exist (, it's a new line item - create a new Delivery DEtail Record*/
					
						idsDeliveryDetail.InsertRow(0)
						idsDeliveryDetail.SetITem(1,'do_no', lsDoNo)
						idsDeliveryDetail.SetItem(1,'sku',idsDODetail.GetItemString(llDetailPos,'sku'))
						idsDeliveryDetail.SetItem(1,'supp_code',lsSupplier)
						//GailM 07/26/2018 S19739 Faber-Cast will be using the decimal in their outbound orders
						idsDeliveryDetail.SetITem(1,'req_qty',dec(idsDODetail.GetItemString(llDetailPos,'quantity')))
						idsDeliveryDetail.SetItem(1,'user_field1',idsDODetail.GetItemString(llDetailPos,'user_field1'))
						idsDeliveryDetail.SetItem(1,'user_field2',idsDODetail.GetItemString(llDetailPos,'user_field2'))
						idsDeliveryDetail.SetItem(1,'user_field3',idsDODetail.GetItemString(llDetailPos,'user_field3'))
						idsDeliveryDetail.SetItem(1,'user_field4',idsDODetail.GetItemString(llDetailPos,'user_field4')) 
						idsDeliveryDetail.SetItem(1,'user_field5',idsDODetail.GetItemString(llDetailPos,'user_field5')) 
						idsDeliveryDetail.SetItem(1,'user_field6',idsDODetail.GetItemString(llDetailPos,'user_field6'))
						idsDeliveryDetail.SetItem(1,'user_field7',idsDODetail.GetItemString(llDetailPos,'user_field7')) 
						idsDeliveryDetail.SetItem(1,'user_field8',idsDODetail.GetItemString(llDetailPos,'user_field8')) 
						idsDeliveryDetail.SetItem(1,'uom',idsDODetail.GetItemString(llDetailPos,'uom')) 
						idsDeliveryDetail.SetItem(1,'line_item_no',idsDODetail.GetItemNumber(llDetailPos,'Line_item_no'))
						idsDeliveryDetail.SetItem(1,'Line_Item_Notes',idsDODetail.GetItemString(llDetailPos,'Line_Item_Notes'))
						idsDeliveryDetail.SetItem(1,'gls_so_id',idsDODetail.GetItemString(llDetailPos,'gls_so_id')) 
						idsDeliveryDetail.SetItem(1,'gls_so_line',idsDODetail.GetItemNumber(llDetailPos,'gls_so_line')) 
						idsDeliveryDetail.SetITem(1,'alloc_qty',0)
						idsDeliveryDetail.SetItem(1,'Price',Dec(idsDODetail.GetItemString(llDetailPos,'Price')))
						If idsDODetail.GetITemString(llDetailPos,'alternate_sku') > ' ' Then
							idsDeliveryDetail.SetItem(1,'alternate_sku',idsDODetail.GetItemString(llDetailPos,'alternate_sku'))
						Else
							idsDeliveryDetail.SetItem(1,'alternate_sku',idsDODetail.GetItemString(llDetailPos,'sku'))
						End If
						// 10/01/09
						idsDeliveryDetail.SetItem(1,'currency_code',idsDODetail.GetItemString(llDetailPos,'currency_code')) 
						
						// 07/05/2011 GXMOR Add PickLotNo, PickPONo & PickPONo2 for Attribute Level Processing Project
						idsDeliveryDetail.SetItem(1,'pick_lot_no',idsDODetail.GetItemString(llDetailPos,'pick_lot_no'))
						idsDeliveryDetail.SetItem(1,'pick_po_no',idsDODetail.GetItemString(llDetailPos,'pick_po_no')) 
						idsDeliveryDetail.SetItem(1,'pick_po_no2',idsDODetail.GetItemString(llDetailPos,'pick_po_no2')) 
						
						//MEA - 8/12 - Added User_Line_Item_No and Customer_Sku
						idsDeliveryDetail.SetItem(1,'User_Line_Item_No',idsDODetail.GetItemString(llDetailPos,'User_Line_Item_No')) 
						idsDeliveryDetail.SetItem(1,'Customer_Sku',idsDODetail.GetItemString(llDetailPos,'Customer_Sku')) 
						//TAM 2015/05/01 - Added New Named Fields
						idsDeliveryDetail.SetItem(1,'Buyer_Part',idsDODetail.GetItemString(llDetailPos,'Buyer_Part'))
						idsDeliveryDetail.SetItem(1,'Vendor_Part',idsDODetail.GetItemString(llDetailPos,'Vendor_Part'))
						idsDeliveryDetail.SetItem(1,'UPC',idsDODetail.GetItemString(llDetailPos,'UPC'))
						idsDeliveryDetail.SetItem(1,'EAN',idsDODetail.GetItemString(llDetailPos,'EAN'))
						idsDeliveryDetail.SetItem(1,'GTIN',idsDODetail.GetItemString(llDetailPos,'GTIN'))
						idsDeliveryDetail.SetItem(1,'Department_Name',idsDODetail.GetItemString(llDetailPos,'Department_Name'))
						idsDeliveryDetail.SetItem(1,'Division',idsDODetail.GetItemString(llDetailPos,'Division'))
						// TAM - 2015/06/02 - Packaging Characteristics - New Named Field
						idsDeliveryDetail.SetItem(1,'Packaging_Characteristics',idsDODetail.GetItemString(llDetailPos,'Packaging_Characteristics'))
						// TAM - 2015/09/16 - New Fields
						idsDeliveryDetail.SetItem(1,'Line_Total_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Total_Amt'))
						idsDeliveryDetail.SetItem(1,'Line_Tax_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Tax_Amt'))
						idsDeliveryDetail.SetItem(1,'Line_Discount_Amt',idsDODetail.GetItemNumber(llDetailPos,'Line_Discount_Amt'))
						
						// 12/15 - PCONKL - TODO - Add any new Detail named fields
						idsDeliveryDetail.SetItem(1,'Client_Cust_Line_No',idsDODetail.GetItemString(llDetailPos,'Client_Cust_Line_No'))
						idsDeliveryDetail.SetItem(1,'CI_Value',idsDODetail.GetItemString(llDetailPos,'CI_Value'))
						idsDeliveryDetail.SetItem(1,'Cust_Line_Nbr',idsDODetail.GetItemString(llDetailPos,'Cust_Line_Nbr'))
						idsDeliveryDetail.SetItem(1,'Client_Cust_Invoice',idsDODetail.GetItemString(llDetailPos,'Client_Cust_Invoice'))
						idsDeliveryDetail.SetItem(1,'Cust_PO_Nbr',idsDODetail.GetItemString(llDetailPos,'Cust_PO_Nbr'))
						idsDeliveryDetail.SetItem(1,'Delivery_Nbr',idsDODetail.GetItemString(llDetailPos,'Delivery_Nbr'))
						idsDeliveryDetail.SetItem(1,'Internal_Price',idsDODetail.GetItemString(llDetailPos,'Internal_Price'))
						idsDeliveryDetail.SetItem(1,'Client_Inv_Type',idsDODetail.GetItemString(llDetailPos,'Client_Inv_Type'))
						idsDeliveryDetail.SetItem(1,'Permit_Nbr',idsDODetail.GetItemString(llDetailPos,'Permit_Nbr'))
						
						//12-Jan-2016 Madhu Added New Name Fields for H2O
						idsDeliveryDetail.SetItem(1,'Mark_For_Name',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Name'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_1',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_1'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_2',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_2'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_3',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_3'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Address_4',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Address_4'))
						idsDeliveryDetail.SetItem(1,'Mark_For_City',idsDoDetail.GetItemString(llDetailPos,'Mark_For_City'))
						idsDeliveryDetail.SetItem(1,'Mark_For_State',idsDoDetail.GetItemString(llDetailPos,'Mark_For_State'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Zip',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Zip'))
						idsDeliveryDetail.SetItem(1,'Mark_For_Country',idsDoDetail.GetItemString(llDetailPos,'Mark_For_Country'))
						
						//Get default owner for SKU - 04/03 - PCONKL if not already set in file
						If idsDODetail.GetItemString(llDetailPos,'owner_ID') > '0' Then
							idsDeliveryDetail.SetItem(1,'owner_id',Long(idsDODetail.GetItemString(llDetailPos,'owner_ID')))
						
						Else /*get default from ITem Master*/
						
							// 06/13 - MEA - added supp_code to query for multiple suppliers per SKU
							Select Min(owner_id) into :llOwner
							From Item_Master with(nolock)
							Where  project_id = :lsProject and sku = :lsSku and supp_code = :lsSupplier ;
							
							idsDeliveryDetail.SetItem(1,'owner_id',llOwner)		
						End If
						
						//2017/07 :TAM Added for PINT-856
						If idsDODetail.GetItemNumber(llDetailPos,'om_change_request_nbr') > 0 Then
							idsDeliveryDetail.SetItem(1,'om_change_request_nbr', idsDODetail.GetItemNumber(llDetailPos,'om_change_request_nbr'))
						End If
					
				Else /*system Error*/
						uf_writeError("Order Nbr (Detail): " + string(lsOrderNo) + " - System Error: Unable to retrieve Delivery Order Detail Records")
						lbError = True
						Continue /*next Detail*/
					End IF /*Delivery detail records exist? */
					
					//Update the Detail Record
					SQLCA.DBParm = "disablebind =0"
					liRC = idsDeliveryDetail.Update()
					SQLCA.DBParm = "disablebind =1"
					If liRC = 1 then
						Commit;
					Else
						Rollback;
						uf_writeError("- ***System Error!  Unable to Save Delivery Detail Record to database!")
						lbError = True
						Continue
					End IF
				
			Else /* Errors exist on Detail, mark with status cd and error text*/
					idsDODetail.SetItem(llDetailPos,'status_cd','E')
					If Left(lsDetailErrorText,1) = ',' Then lsDetailErrorText = Right(lsDetailErrorText,(len(lsDetailErrorText) - 1)) /*strip first comma*/
					idsDODetail.SetItem(llDetailPos,'status_message',lsDetailErrorText)
				End If /*no errors on detail*/
			
		Next /*edi detail record*/
		
		//save any changes made to edi records (status cd, error msg)
		SQLCA.DBParm = "disablebind =0"
		idsDOHeader.Update()
		idsDODetail.Update()
		SQLCA.DBParm = "disablebind =1"
		Commit;
		
		If lbError or lbDetailErrors Then 
		
			//04/03 - PCONKL - Don't delete if we are allowing errors on DO
			If lsallowPOErrors <> 'Y' Then
			
			If lbNewDO  Then /* new PO */
			Delete from Delivery_detail where do_no = :lsDOno;
			Delete from Delivery_Notes where do_no = :lsDOno; /* 09/03 - PCONKL*/
			Delete from Delivery_BOM where do_no = :lsDOno; /* 10/06 - PCONKL*/
			Delete from Delivery_Alt_Address where do_no = :lsDOno; /* 09/03 - PCONKL*/
			Delete from Delivery_master where Do_no = :lsDoNo;
			Commit;
			End If /* new PO with errors*/
			
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - No changes applied to this Order!")
		
		Else /*saving with errors */
		
			/* 05/07 - dts - Set the DO_NO for any Notes or Alt Address records associated with this order
			(this was already being done for orders without errors, but not for orders which are allowed errors) */
		
			Update Delivery_Notes set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			Update Delivery_Alt_Address set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			Update Delivery_BOM set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
			uf_writeError("Order Nbr: " + string(lsOrderNo) + " - Order saved with errors!")
		
		End If
		
		lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/
		
		//Update any header/detail records with error status if we didn't catch an individual error on the detail level
		Update edi_outbound_header
		Set status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
		
		Update edi_outbound_detail
		Set Status_cd = 'E', status_message = 'Errors exist on Header/Detail'
		Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
		
		//2017/07 TAM PINT-856 -Update respective tables of OM -START
		If idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
			this.uf_process_om_writeerror( lsproject, 'E', idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'), 'OB', 'Errors exist on Header/Detail') //write error log and trigger email alert
		End If
		//2017/07 TAM PINT-856 -Update respective tables of OM -END		
		
		Commit;
	
	Else /* No errors on order*/
	
		// 09/03 - PConkl - Set the DO_NO for any Notes or Alt Address records associated with this order
		Update DElivery_Notes set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
		Update DElivery_Alt_Address set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq;
		Update DElivery_BOM set do_no = :lsDONO where Project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and order_seq_no = :llORderSeq; 	//10/06 - PCONKL
		
		//MEA - 1/12 - Added for NIKE - Send DST
		
		IF lbSendDst Then
			If Not isvalid(lu_edi_confirmations_nike) Then
				lu_edi_confirmations_nike = Create u_nvo_edi_confirmations_nike
			End If
			liRC = lu_edi_confirmations_nike.uf_dst(lsProject, lsDONO, "RT")		
		End If
	
	End If /* any detail level errors*/
	
	// 08/13 - PCONKL - Moved after commit of notes - we need to the do_no to e assigned for retrieval
	If gs_OTM_Flag = 'Y' and gsOTMSendOutboundOrder = 'Y' Then
		iu_otm.uf_process_outbound_order(lsProject, lsDoNo, idsDOHeader,  llHeaderPos, idsDeliveryMaster,  isDeleteSkus)
	End if  //OTM Flag

Next /* EDI Header Record*/

IF lsProject = 'PANDORA' THEN
	//TimA 07/18/13 Pandora #624
	//Send the CI 3b18 on international NON EU to EU type orders.  This give Pandora a heads up about the CI
	Select DM.country DM_Country, C.Country C_Country INTO 	:lsDM_Country, :lsCustCountry
	From delivery_master DM, Customer C 
	Where DM.project_id = 'Pandora' and Do_no = :lsDONO And DM.project_id = C.Project_ID And DM.User_Field2 = C.Cust_Code;	
	
	ls_to_country   = lsDM_Country
	ls_from_country = lsCustCountry
	
	If Trim(Upper(lsDM_Country)) <> Trim(Upper(lsCustCountry)) and NOT uf_is_country_eu_to_eu(lsProject,ls_from_country, ls_to_country) then //Compare Countries
		//Note: We are putting "PRE_CI" in the Trans_Parm space because we need to identify this type of record when the Send CI/LT button
		//is pressed in the Packing List tab of w_do
		//TimA 09/08/14 Turn off per Roy because Pandora has a new way to do this in shopping cart.
		//Pandora no longer wants the PRE CI
		//Execute Immediate "Begin Transaction" using SQLCA; 
		//Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		//Values(:lsProject, 'CI', :lsDONO,'N', :ldtWhTime, 'PRE_CI');
		//Execute Immediate "COMMIT" using SQLCA;	
	End if
END IF

//mark any records as complete that might have been skipped (continued to next header)*/
For llHeaderPos = 1 to llHeaderCount

	lsProject = idsDOHeader.GetITemString(llHeaderPos,'project_id')
	lsOrderNo = idsDOHeader.GetITemString(llHeaderPos,'Invoice_no')
	llBatchSeq = idsDOHeader.GetITemNumber(llHeaderPos,'edi_batch_seq_no')
	lsStatus_cd = idsDOHeader.GetITemString(llHeaderPos,'Status_Cd')
	
	Update edi_Outbound_header
	Set status_cd = 'C' , status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
	
	Update edi_Outbound_detail
	Set Status_cd = 'C', status_message = 'Order processed successfully.'
	Where project_id = :lsProject and edi_batch_seq_no = :llBatchSeq and invoice_no = :lsOrderno and status_cd = 'N';
	
	commit;
	
	//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array -START
	If idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr') > 0 Then
		ll_row =lds_om_receipt_list.insertrow( 0)	
		lds_om_receipt_list.setitem( ll_row, 'project_Id', lsProject)
		lds_om_receipt_list.setitem( ll_row, 'change_req_no', idsDOHeader.getitemnumber( llHeaderPos, 'om_change_request_nbr'))
		lds_om_receipt_list.setitem( ll_row, 'status_cd', idsDOHeader.GetITemString(llHeaderPos,'Status_Cd'))
	End If
	//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array - END

Next

//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array -START
//21-MAR-2018 :Madhu DE3461 - Removed lsStatus_cd <> 'E'
If lds_om_receipt_list.rowcount( ) > 0  Then liRc =uf_process_om_outbound_update( lds_om_receipt_list) 
If lds_om_receipt_list.rowcount( ) > 0 and  liRc <> -1 Then uf_process_om_warehouse_order( lsproject, lds_om_receipt_list) 

destroy lds_om_receipt_list
//2017/07 TAM PINT-856 -Add successfully loaded orders into an Array - END

If lbError Then lbValError = True /*if any errors for all headers or detail, we need to set return code appropriately*/

If lbValError Then 
	Return -1
Else
	Return 0
End If


end function

public function integer uf_process_om_warehouse_order (string asproject, ref datastore adsorderlist);long llRC
u_nvo_proc_pandora		lu_pandora
u_nvo_proc_rema			lu_rema

llRC =0 


CHOOSE CASE upper(asproject)
	CASE 'PANDORA'
		lu_pandora =create u_nvo_proc_pandora
		llRC =lu_pandora.uf_process_om_warehouse_order( adsOrderList)
	CASE 'REMA'
		lu_rema = create u_nvo_proc_rema
		llRC =lu_rema.uf_process_om_warehouse_order( adsOrderList)
			
END CHOOSE

Return llRC
end function

public function integer uf_process_om_outbound_update (ref datastore adsreceipt);//Update OMA_WAREHOUSE_ORDER_QUEUE , OMC_WAREHOUSE_ORDER tables.

string  ls_rq_sql, ls_rc_sql, ls_status_cd,lsLogOut,ls_change_ind , ls_orig_rq_sql, ls_orig_rc_sql, ls_project
long ll_row, ll_rc, ll_change_req_no, ll_rq_row, ll_rc_row, ll_count

Datastore ldsDeliveryQueue, ldsDelivery

lsLogOut = '      - OM Inbound - Processing of uf_process_om_outbound_update() - Server Name: '+ nz(om_sqlca.servername, '-') + '\ (DB) ' + nz(om_sqlca.database,'-')+' \ (Return Code) '+ nz(string(om_sqlca.sqlcode),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If om_sqlca.sqlcode <> 0 Then
	//re-connect to respective DB
	select Project_Id into :ls_project from OM_Settings with(nolock) where OM_Server_Name =:om_sqlca.servername 	using sqlca;
	this.uf_connect_to_om( ls_project)
End If

If not isValid(ldsDeliveryQueue) Then
	ldsDeliveryQueue =create u_ds_datastore
	ldsDeliveryQueue.dataobject='d_oma_warehouse_order_queue_update'
End If
	ldsDeliveryQueue.settransobject( om_sqlca)

If not isValid(ldsDelivery) Then
	ldsDelivery =create u_ds_datastore
	ldsDelivery.dataobject='d_omc_Warehouse_Order'
End If
	ldsDelivery.settransobject( om_sqlca)
	
//Write to File and Screen
lsLogOut = '      - OM Inbound - Start Processing of uf_process_om_outbound_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Retrieve Original Query
ls_orig_rq_sql = ldsDeliveryQueue.getsqlselect( )
ls_orig_rc_sql = ldsDelivery.getsqlselect( )

//Loop through Ref datastore to update OM tables.
For ll_row = 1 to adsreceipt.rowcount()
	ll_change_req_no = adsreceipt.getitemnumber(ll_row, 'change_req_no')
	ls_status_cd =adsreceipt.getitemstring(ll_row, 'status_cd')
	
	//OMA_Warehouse_Order_Queue
	ls_rq_sql = ''
	ls_rq_sql = ls_orig_rq_sql
	ls_rq_sql += " AND " 
	ls_rq_sql += "OPS$OMAUTH.OMA_WAREHOUSE_ORDER_QUEUE.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	

	ldsDeliveryQueue.setsqlselect( ls_rq_sql)
	ll_count = ldsDeliveryQueue.retrieve( )
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Processing of uf_process_om_outbound_update() - OMA_Warehouse_Order_Queue SQL Query is: '+ls_rq_sql + ' and count is: '+String(ll_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	FOR ll_rq_row =1 to ldsDeliveryQueue.rowcount( )
		IF upper(ls_status_cd) ='E' THEN
			ldsDeliveryQueue.setitem( ll_rq_row, 'status', 'FAIL')
		else
			ldsDeliveryQueue.setitem( ll_rq_row, 'status', 'SUCCESS')
		END IF
		
		ldsDeliveryQueue.setitem( ll_rq_row, 'editwho', 'SIMSUSER')
	NEXT
	
	//OMC_Warehouse_Order
	ls_rc_sql = ''
	ls_rc_sql = ls_orig_rc_sql
	ls_rc_sql += " WHERE " 
	ls_rc_sql += "OPS$OMAUTH.OMC_WAREHOUSE_ORDER.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"

	ldsDelivery.setsqlselect( ls_rc_sql)
	ll_count = ldsDelivery.retrieve( )

	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Processing of uf_process_om_outbound_update() - OMC_Warehouse_Order SQL Query is: '+ls_rc_sql + ' and count is: '+String(ll_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	FOR ll_rc_row =1 to ldsDelivery.rowcount( )
				
		// SET CANCEL to a different status
		ls_change_ind = ldsDelivery.getitemstring( ll_rc_row, 'CHANGE_REQUEST_INDICATOR' ) 
		IF upper(ls_status_cd) ='E' THEN
			IF ls_change_ind = 'CANCEL'  Then
				ldsDelivery.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'REJECT')
			ELSE
				ldsDelivery.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'FAILED')
			END IF
		else
			IF ls_change_ind = 'CANCEL' Then
				ldsDelivery.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'ACCEPT')
			ELSE
				ldsDelivery.setitem( ll_rc_row, 'CHANGE_REQUEST_STATUS', 'COMPLETED')
			END IF
		END IF
		
		ldsDelivery.setitem( ll_rc_row, 'editwho', 'SIMSUSER')
	NEXT
	
	IF ldsDeliveryQueue.rowcount( ) > 0 THEN
		
		//storing into DB
		Execute Immediate "Begin Transaction" using om_sqlca;
		
		If ldsDeliveryQueue.rowcount( ) > 0 Then
			ll_rc =ldsDeliveryQueue.update( false, false);
		End IF
		
		If ll_rc =1 Then
			Execute Immediate "COMMIT" using om_sqlca;
			
			if om_sqlca.sqlcode = 0 then
				ldsDeliveryQueue.resetupdate( )
			else
				Execute Immediate "ROLLBACK" using om_sqlca;
				ldsDeliveryQueue.reset( )
				//Write to File and Screen
				lsLogOut = '      - OM Inbound - uf_process_om_outbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) + " and ll_rc: "+string(ll_rc) +"  Error:"+om_sqlca.SQLErrText
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				Return -1
			end if
			
		else
			 string lserrtxt
			 lserrtxt = om_sqlca.SQLErrText
			Execute Immediate "ROLLBACK" using om_sqlca;
			lsLogOut = '      - OM Inbound - uf_process_om_outbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) + " and ll_rc: "+string(ll_rc) +"  Error:"+om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
		
		If ldsDelivery.rowcount( ) > 0 Then
			ll_rc =ldsDelivery.update( false, false);
		End IF
		
		If ll_rc =1 Then
			Execute Immediate "COMMIT" using om_sqlca;
			
			if om_sqlca.sqlcode = 0 then
				ldsDelivery.resetupdate( )
			else
				Execute Immediate "ROLLBACK" using om_sqlca;
				ldsDelivery.reset( )
				lsLogOut = '      - OM Inbound - uf_process_om_outbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) + " and ll_rc: "+string(ll_rc) +"  Error:"+om_sqlca.SQLErrText
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				Return -1
			end if
			
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			lsLogOut = '      - OM Inbound - uf_process_om_outbound_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd) + " and ll_rc: "+string(ll_rc) +"  Error:"+om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound - uf_process_om_outbound_update() -Write Messages into OMC Table for Change Request No:  '+ string(ll_change_req_no) +" and Status: "+ upper(ls_status_cd)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	
		//update OMC_Message
		If  upper(ls_status_cd) ='E'  THEN
			ll_rc = uf_process_omc_message('OMC_WHS_ORDER', 'E', '940_TO_SIMS_PROCESS',  'FAILED TO LOAD OB ORDER INTO SIMS', ll_change_req_no)
		else
			ll_rc = uf_process_omc_message('OMC_WHS_ORDER', 'I', '940_TO_SIMS_PROCESS',  'SUCCESSFULLY LOADED OB ORDER INTO SIMS', ll_change_req_no)
		END IF
	
		//Reseting sql's
		ldsDeliveryQueue.reset( )
		ldsDelivery.reset( )
	END IF
Next

//Write to File and Screen
lsLogOut = '      - OM Inbound - End Processing of uf_process_om_outbound_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Destroy ldsDeliveryQueue
Destroy ldsDelivery

Return ll_rc
end function

public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction);//05-SEP-2017 :Madhu Added PINT-856 - Goods Receipt Acknowledgement

long llRC

u_nvo_proc_pandora lu_pandora

lu_pandora =create u_nvo_proc_pandora

CHOOSE CASE upper(asproject)
	CASE 'PANDORA'
		llRC = lu_pandora.uf_process_om_inbound_acknowledge( asproject, asrono, asaction)
		
END CHOOSE

Return llRC
end function

public function integer uf_schedule_sweeper_restart ();//14-Dec-2017 :Madhu Schedule Sweeper Restart
DateTime ldtToday, ldtNextDateTime
String		ls_minutes, ls_next_time, lsLogOut
long 	ll_minutes

lsLogOut =  "  Start Processing -uf_schedule_sweeper_restart() - "
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_writeError(lsLogOut)
		
ldtToday = DateTime(today(), now())
ls_minutes = ProfileString(gsIniFile,'SIMS3FP','AUTORESTARTDELAYBYMINS','')

If IsNumber(ls_minutes) Then 
	ll_minutes = long(ls_minutes)
else
	ll_minutes = 1440
End If

ldtNextDateTime = f_add_time_to_datetime(ldtToday, ll_minutes)

SetProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTDATE',String(ldtNextDateTime,'mm-dd-yyyy'))
SetProfileString(gsIniFile,'SIMS3FP','RESTARTNEXTTIME', String(Time(ldtNextDateTime)))

lsLogOut =  "  End Processing -uf_schedule_sweeper_restart() - Scheduled Next Sweeper Restart Date: "+string(ldtNextDateTime)
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_writeError(lsLogOut)

lbRestartScheduled = True

Return 0
end function

public function integer uf_process_om_item_master_update (str_parms astr_item_parm);//12-Mar-2018 :Madhu - S16591 - REMA - EDI -888 Pull Item Master Records from OM.
//Update OMA_ITEM_QUEUE , OMC_ITEM tables.

string lsLogOut, ls_project
string	ls_orig_imq_sql, ls_orig_im_sql, ls_orig_ima_sql, ls_item_queue_sql, ls_item_attr_sql, ls_item_sql
long 	ll_rc, ll_row, ll_change_req_no, ll_im_row

Datastore ldsItemQueue, ldsItem, ldsItemAttr

lsLogOut = '      - OM Item Master - Processing of uf_process_om_item_master_update() - Server Name: '+ nz(om_sqlca.servername, '-') + '\ (DB) ' + nz(om_sqlca.database,'-')+' \ (Return Code) '+ nz(string(om_sqlca.sqlcode),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If om_sqlca.sqlcode <> 0 Then
	//re-connect to respective DB
	select Project_Id into :ls_project from OM_Settings with(nolock) where OM_Server_Name =:om_sqlca.servername 	using sqlca;
	this.uf_connect_to_om( ls_project)
End If

IF NOT isvalid(ldsItem) THEN					//OMC_Item
	ldsItem = Create u_ds_datastore
	ldsItem.dataobject ='d_omc_item'
END IF
	ldsItem.SetTransObject(om_sqlca)
	
IF NOT isvalid(ldsItemAttr) THEN		 		//OMC_Item_Attr
	ldsItemAttr = Create u_ds_datastore
	ldsItemAttr.dataobject ='d_omc_item_attr'
END IF
	ldsItemAttr.SetTransObject(om_sqlca)

IF NOT isvalid(ldsItemQueue) THEN		 		//OMA_Item_Queue
	ldsItemQueue = Create u_ds_datastore
	ldsItemQueue.dataobject ='d_oma_item_queue'
END IF
	ldsItemQueue.SetTransObject(om_sqlca)

//Write to File and Screen
lsLogOut = '      - OM Item Master - Start Processing of uf_process_om_item_master_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Retrieve Original Query
ls_orig_imq_sql = ldsItemQueue.getsqlselect( )
ls_orig_ima_sql = ldsItemAttr.getsqlselect( )
ls_orig_im_sql = ldsItem.getsqlselect( )

//Loop through str_parm List to update OM tables.
For ll_row = 1 to UpperBound(astr_item_parm.long_arg[])
	ll_change_req_no = astr_item_parm.long_arg[ll_row]
	
	//OMA Item Queue
	ls_item_queue_sql =''
	ls_item_queue_sql = ls_orig_imq_sql
	ls_item_queue_sql +="  AND OPS$OMAUTH.OMA_ITEM_QUEUE.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	
	ldsItemQueue.setsqlselect( ls_item_queue_sql)
	ldsItemQueue.retrieve( )
	
	For ll_im_row = 1 to ldsItemQueue.rowcount( )
		ldsItemQueue.setitem( ll_im_row, 'status', 'SUCCESS')
		ldsItemQueue.setitem( ll_im_row, 'editwho', 'SIMSUSER')
	Next
	
	//OMC Item Attr
	ls_item_attr_sql =''
	ls_item_attr_sql = ls_orig_ima_sql
	ls_item_attr_sql +="  WHERE OPS$OMAUTH.OMC_ITEM_ATTR.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	
	ldsItemAttr.setsqlselect( ls_item_attr_sql)
	ldsItemAttr.retrieve( )
	
	For ll_im_row = 1 to ldsItemAttr.rowcount( )
		ldsItemAttr.setitem( ll_im_row, 'CHANGE_REQUEST_STATUS', 'COMPLETED')
		ldsItemAttr.setitem( ll_im_row, 'editwho', 'SIMSUSER')
	Next
	
	//OMC Item
	ls_item_sql =''
	ls_item_sql = ls_orig_im_sql
	ls_item_sql +="  WHERE OPS$OMAUTH.OMC_ITEM.CHANGE_REQUEST_NBR IN ("+ string(ll_change_req_no)+")"
	
	ldsItem.setsqlselect( ls_item_sql)
	ldsItem.retrieve( )
	
	For ll_im_row = 1 to ldsItem.rowcount( )
		ldsItem.setitem( ll_im_row, 'CHANGE_REQUEST_STATUS', 'COMPLETED')
		ldsItem.setitem( ll_im_row, 'editwho', 'SIMSUSER')
	Next

	//storing into DB
	Execute Immediate "Begin Transaction" using om_sqlca;
	
	If ldsItemQueue.rowcount( ) > 0 Then ll_rc =ldsItemQueue.update( false, false);
	If ldsItemAttr.rowcount( ) > 0 and ll_rc > 0 Then ll_rc =ldsItemAttr.update( false, false);
	If ldsItem.rowcount( ) > 0 and ll_rc > 0 Then ll_rc =ldsItemAttr.update( false, false);
	
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
		if om_sqlca.sqlcode = 0 then
			If ldsItemQueue.rowcount( ) > 0 Then ldsItemQueue.resetupdate()
			If ldsItemAttr.rowcount( ) > 0 Then ldsItemAttr.resetupdate( )
			If ldsItem.rowcount( ) > 0 Then ldsItem.resetupdate()
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			If ldsItemQueue.rowcount( ) > 0 Then ldsItemQueue.reset( )
			If ldsItemAttr.rowcount( ) > 0 Then ldsItemAttr.reset( )
			If ldsItem.rowcount( ) > 0 Then ldsItem.reset()
			
			//Write to File and Screen
			lsLogOut = '      - OM Item Master - uf_process_om_item_master_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" Error:"+om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;

		//Write to File and Screen
		lsLogOut = '      - OM Item Master - uf_process_om_item_master_update() -Error occurred for Change Request No:  '+ string(ll_change_req_no) +" Error:"+om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
	//update OMC_Message
	ll_rc = uf_process_omc_message('IM Record', 'I', 'IM_TO_SIMS_PROCESS',  'SUCCESSFULLY LOADED IM RECORD INTO SIMS', ll_change_req_no)

	//Reseting sql's
	ldsItemQueue.reset( )
	ldsItemAttr.reset( )
	ldsItem.reset( )
Next

//Write to File and Screen
lsLogOut = '      - OM Item Master - End Processing of uf_process_om_item_master_update() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Destroy ldsItemQueue
Destroy ldsItemAttr
Destroy ldsItem

Return ll_rc
end function

public function integer uf_process_load_plan_outbound_update (string asproject);//07-AUG-2018 :Madhu S21850 - Load Plan Outbound Update

string lsLogOut, ls_Order_No, ls_Wh_Code, ls_New_Sql, ls_Where_Sql,  ls_Modify_Sql, ls_sql, lsErrText
string ls_trans_type, ls_load_id, ls_prev_load_id, ls_customer_order, ls_Find, ls_wh, ls_error
string ls_carrier, ls_transport_mode, ls_carrier_pro_no
long ll_Row, ll_Row_Count, ll_Pos, ll_RC, ll_FindRow
boolean lbError

u_ds_datastore lds_load_plan, lds_delivery

lsLogOut = '          - PROCESSING FUNCTION - Update Load Plan Outbound Orders. - ' + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

SetPointer(Hourglass!)

lds_load_plan = create u_ds_datastore
lds_load_plan.dataobject='d_import_load_plan'
lds_load_plan.settransobject( SQLCA)

lds_delivery = create u_ds_datastore
lds_delivery.dataobject='d_baseline_unicode_delivery_master'
lds_delivery.settransobject( SQLCA)

//1. get records from EDI_Load_Plan
lds_load_plan.retrieve( asproject)
ll_Row_Count = lds_load_plan.rowcount( )

lsLogOut = '              ' + string(ll_Row_Count) + ' Load Plan records were retrieved for processing.'
FileWrite(giLogFileNo,lsLogOut)
uf_write_log(lsLogOut) /*write to Screen*/

If ll_Row_Count =0 Then
	Return 0
ElseIf ll_Row_Count < 0 Then
	uf_send_email("",'Filexfer'," - ***** uf_process_load_plan_outbound_update - Unable to read EDI Load Plan Records!","Unable to read EDI Load Plan Records",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//2. If Trans_type ='U' /'D' - clear all existing values which are assigned with Load_Id from Delivery Master
For ll_Row = 1 to ll_Row_Count
	ls_trans_type = lds_load_plan.getItemString( ll_Row, 'Transaction_Type')
	ls_wh_code = lds_load_plan.getItemString( ll_Row, 'Wh_Code')
	ls_load_Id = lds_load_plan.getItemString( ll_Row, 'Load_Id')
	
	IF (upper(ls_trans_type) ='U' or upper(ls_trans_type) ='D') and (ls_prev_load_Id <> ls_load_Id) THEN
		
		update Delivery_Master set Load_Id =NULL, Shipment_Id=NULL, Awb_Bol_No=NULL, Carrier=NULL, Carrier_Pro_No =NULL,
			Stop_Id =NULL, Load_Lock='N',  Master_BOL=NULL, Load_Sequence=NULL, Ready_By_Date=NULL, Otm_status = 'L' //TAM 2019/04/10 DE9565 
		where Project_Id =:asproject and WH_Code =:ls_Wh_Code
		and Load_Id =:ls_load_Id;
		commit;
		
		lsLogOut = '          - PROCESSING FUNCTION - Updated all Outbound Orders which are associated with Warehouse /Load Id - ' + ls_Wh_Code +' / '+ ls_load_Id
		FileWrite(giLogFileNo,lsLogOut)
		uf_write_log(lsLogOut) /*write to Screen*/

	END IF
	ls_prev_load_Id = ls_load_Id
Next

//3. get Customer Order No's into string
For ll_Row = 1 to ll_Row_Count
	ls_Order_No += "'"+lds_load_plan.getItemString( ll_Row, 'Customer_Order')+"',"
	ls_wh += "'"+lds_load_plan.getItemString( ll_Row, 'wh_code')+"',"
Next

ls_Order_No = Left(ls_Order_No, len(ls_Order_No) - 1) //strip off comma at the end
ls_wh = Left(ls_wh, len(ls_wh) - 1) //strip off comma at the end

ls_Where_Sql ="  Where Project_Id ='"+asproject+"'  and wh_code IN ("+ls_wh+") and Invoice_No IN ("+ls_Order_No+") and Ord_Status <> 'V' "

//4. get Original Sql of Delivery Master
ls_New_Sql = lds_delivery.getsqlselect( )
ls_New_Sql +=ls_Where_Sql

//5. modify original sql and retrieve orders
ls_Modify_Sql = 'DataWindow.Table.Select="' + ls_New_Sql + '"'
lds_delivery.Modify(ls_Modify_Sql)
lds_delivery.retrieve()

If lds_delivery.rowcount( ) =0 Then
	Return 0
ElseIf lds_delivery.rowcount( ) < 0 Then
	lsLogOut = '                uf_process_load_plan_outbound_update - Unable to retrieve Outbound Order Records!. '+ls_New_Sql
	FileWrite(giLogFileNo,lsLogOut)
	uf_send_email("",'Filexfer'," - ***** uf_process_load_plan_outbound_update - Unable to retrieve Outbound Order Records!","Unable to retrieve Outbound Order Records ",'') /*send an email msg to the file transfer error list*/
	Return -1
End If

//6. Loop through each EDI Load Plan Record
For ll_Row = 1 to ll_Row_Count
	
	//read values from EDI Load Plan
	ls_trans_type = lds_load_plan.getItemString( ll_Row, 'Transaction_Type')
	ls_wh_code = lds_load_plan.getItemString( ll_Row, 'Wh_Code')
	ls_customer_order = lds_load_plan.getItemString( ll_Row, 'Customer_Order')
	ls_load_Id = lds_load_plan.getItemString( ll_Row, 'Load_Id')
	ls_carrier = trim(lds_load_plan.getItemString( ll_Row, 'Carrier_Id'))
	ls_carrier_pro_no = trim(lds_load_plan.getItemString( ll_Row, 'Tracking_Number')) //06-FEB-2019 :Madhu DE8506 Added Probill
	
	//GailM 10/26/2018 DE6934 Google - Transport mode new mapping
	If Not isNull( ls_carrier) and ls_carrier <> '' Then
		Select transport_mode into :ls_transport_mode
		From carrier_master with(nolock)
		Where  project_id = :asproject and carrier_code = :ls_carrier ;
	End If

	//find a record on above Delivery Datastore
	ls_Find ="WH_Code ='"+ls_wh_code+"' and Invoice_No ='"+ls_customer_order+"'"
	ll_FindRow = lds_delivery.find( ls_Find, 1, lds_delivery.rowcount())
	
	//update respective fields on above Delivery Datastore
	IF ll_FindRow > 0 and upper(ls_trans_type) <> 'D' THEN
	
		lds_delivery.setItem( ll_FindRow, 'Load_Id', ls_load_Id)
		lds_delivery.setItem( ll_FindRow, 'Otm_Status', 'T') //TAM 2019/04/10 DE9565 - Set OTM status to 'T' for TMS
 		lds_delivery.setItem( ll_FindRow, 'Shipment_Id', trim(lds_load_plan.getItemString( ll_Row, 'Shipment_Id')))
		lds_delivery.setItem( ll_FindRow, 'Master_BOL', trim(lds_load_plan.getItemString( ll_Row, 'Master_BOL')))
		lds_delivery.setItem( ll_FindRow, 'Awb_Bol_No', trim(lds_load_plan.getItemString( ll_Row, 'Child_BOL')))
		lds_delivery.setItem( ll_FindRow, 'Carrier', ls_carrier)
		lds_delivery.setItem( ll_FindRow, 'Carrier_Pro_No', ls_carrier_pro_no)	 //06-FEB-2019 :Madhu DE8506 Added Probill
		lds_delivery.setItem( ll_FindRow, 'Transport_Mode', ls_transport_mode)		//DE6934
		lds_delivery.setItem( ll_FindRow, 'Stop_Id', lds_load_plan.getItemNumber( ll_Row, 'Delivery_Stop'))
		lds_delivery.setItem( ll_FindRow, 'Load_Lock', 'N')
		lds_delivery.setItem( ll_FindRow, 'Load_Sequence', lds_load_plan.getItemNumber( ll_Row, 'Load_Sequence'))
		lds_delivery.setItem( ll_FindRow, 'Ready_By_Date', lds_load_plan.getItemDateTime( ll_Row, 'Ready_By_Date_Time'))
		//GailM 10/25/2018 DE6933 SIMS QAT Defect - Google - Est Ship Date field new mapping	
		lds_delivery.setItem( ll_FindRow, 'Schedule_Date', lds_load_plan.getItemDateTime( ll_Row, 'Load_End_Date_Time'))

	END IF
Next

//7. Save Delivery Master changes to Database.
ll_RC = lds_delivery.update()
If ll_RC = 1 then
	Commit;
Else
	lsErrText = sqlca.sqlerrtext
	Rollback;
	uf_writeError("- ***System Error!  Unable to Update Load Plan Delivery Detail Record to database!" +lsErrText)
	lbError = True

End IF

//8. Update EDI_Load_Plan Records
For ll_Row = 1 to lds_load_plan.rowcount( )
	
	IF lbError THEN
		lds_load_plan.setItem( ll_Row, 'Status_Cd', 'E')
		lds_load_plan.setItem( ll_Row, 'Status_Message', 'Failed to Update Load Plan Outbound Orders.')	
	ELSE
		lds_load_plan.setItem( ll_Row, 'Status_Cd', 'C')
		lds_load_plan.setItem( ll_Row, 'Status_Message', 'Load Plan processed successfully.')	
	END IF
		
Next
	
	
//9. Save EDI Load Plan changes to Database.
ll_RC = lds_load_plan.update( )
If ll_RC = 1 then
	Commit;
Else
	Rollback;
	uf_writeError("- ***System Error!  Unable to Update EDI Load Plan Records to database!")
	lbError = True
End IF
	

destroy lds_load_plan
destroy lds_delivery

IF lbError THEN
	Return -1
ELSE
	Return 0
END IF
end function

public function integer uf_create_system_serial_reconciliation (string asproject, string aswhcode, string aslocation, string assku);//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

string ls_cc_No
string lsLogOut, ls_class_code
u_ds_datastore ldsCCMaster, ldsCCCriteria
datetime ldtwhTime 
long llNewRow, ll_rc, llCCRow
decimal ldCCNO
string ls_Serial_Reconciliation_CC_Notification

//write to screen and Log File
lsLogOut = '      -  Processing Function - Serial Reconciliation Cycle Count Order - uf_create_system_serial_reconciliation(). - Warehouse/Locations/Sku: ' + aswhcode + "/" + aslocation + "/" + assku 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ldtwhTime = f_getLocalWorldTime(aswhcode) //Warehouse Local Time = f_getLocalWorldTime(aswhcode) //Warehouse Local Time			
			
//get Next CC No
sqlca.sp_next_avail_seq_no(asproject, "CC_Master", "CC_No" , ldCCNO)
ls_cc_No = asproject + String(Long(ldCCNo),"000000")


SELECT CC_Class_Code into :ls_class_code FROM Item_Master with(nolock) WHERE Project_Id = :asproject and Sku =:assku USING sqlca;

ldsCCMaster = Create u_ds_datastore
ldsCCMaster.dataobject= 'd_cc_master'
ldsCCMaster.SetTransObject(SQLCA)

ldsCCCriteria = Create u_ds_datastore
ldsCCCriteria.dataobject= 'd_cc_system_criteria'
ldsCCCriteria.SetTransObject(SQLCA)

//build CC_Master records
llNewRow = ldsCCMaster.insertrow( 0)
ldsCCMaster.SetItem(llNewRow, 'cc_no', ls_cc_No)
ldsCCMaster.SetItem(llNewRow, 'project_id', asproject)
ldsCCMaster.SetItem(llNewRow, 'wh_code', aswhcode)
ldsCCMaster.SetItem(llNewRow, 'last_update', Today())
ldsCCMaster.SetItem(llNewRow, 'last_user', 'SIMSFP')
ldsCCMaster.SetItem(llNewRow, 'ord_date', ldtwhtime)
ldsCCMaster.SetItem(llNewRow, 'Ord_type', 'F') //Serial Reconciliation 
ldsCCMaster.SetItem(llNewRow, 'Ord_Status', 'N')
ldsCCMaster.SetItem(llNewRow, 'class', ls_class_code)
ldsCCMaster.SetItem(llNewRow, 'class_end', ls_class_code)
ldsCCMaster.SetItem(llNewRow, 'Remark',  'Locations/Sku for Serial Reconciliation  ' + aslocation + '/' + assku )

ldsCCMaster.SetItem(llNewRow, 'range_start', aslocation)
ldsCCMaster.SetItem(llNewRow, 'range_end', aslocation)


llCCRow = ldsCCCriteria.insertrow( 0)
ldsCCCriteria.setItem( llCCRow, 'CC_No', ls_cc_No)
ldsCCCriteria.setItem( llCCRow, 'Count_Type', 'S' )
ldsCCCriteria.setItem( llCCRow, 'Count_Value', assku)


//Write to File and Screen
lsLogOut = '      - Serial Reconciliation Cycle Count Order - uf_create_system_serial_reconciliation() - Inserting records into DB - SQL Return Code: '+ string(SQLCA.sqlcode)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
		
If ldsCCMaster.rowcount( ) > 0 Then	ll_rc =ldsCCMaster.update( True, False);
If ldsCCCriteria.rowcount( ) > 0 and ll_rc > 0 Then ll_rc =ldsCCCriteria.update( True, False);

If ll_rc =1 Then
	COMMIT USING SQLCA;
	if SQLCA.sqlcode = 0 then
		ldsCCMaster.resetupdate( )
		ldsCCCriteria.resetupdate()
	else
		ROLLBACK USING SQLCA;
		ldsCCMaster.reset( )
		ldsCCCriteria.reset()
		
		//Write to File and Screen
		lsLogOut = '      - Serial Reconciliation Cycle Count Order - uf_create_system_serial_reconciliation()  Error: '+nz(SQLCA.SQLErrText,'-') + ' Error code: '+string(SQLCA.sqlcode)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if

else
	ROLLBACK USING SQLCA;
	//Write to File and Screen
	lsLogOut = '      - Serial Reconciliation Cycle Count Order - uf_create_system_serial_reconciliation()  Error: '+nz(SQLCA.SQLErrText,'-') + ' Error code: '+string(SQLCA.sqlcode) +' Record save failed'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Write to File and Screen
lsLogOut = '      - Serial Reconciliation Cycle Count Order - uf_create_system_serial_reconciliation() - Insertion Successfully Completed.!'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Warehouse - Serial Reconciliation CC Notification
//If a warehouse has a value in this field than we will send notification of the CC order to the email address 

string ls_WhName, lsText

SELECT Serial_Reconciliation_CC_Notification, Wh_Name into :ls_Serial_Reconciliation_CC_Notification, :ls_WhName FROM Warehouse with(nolock) WHERE Wh_Code  = :aswhcode USING sqlca;

If Not IsNull(ls_Serial_Reconciliation_CC_Notification) and trim(ls_Serial_Reconciliation_CC_Notification) <> '' Then

	lsText =  " Cycle Count ("+ls_cc_No+") created for Sku: " + assku + " in Location: " + aslocation + " as part of  a Serial Reconciliation."
	
	gu_nvo_process_files.uf_send_email(asproject,ls_Serial_Reconciliation_CC_Notification,"Serial Reconciliation Cycle Count created at " + ls_WhName + "("+aswhcode+")",lsText,"")

End If

Return 0
end function

on u_nvo_process_files.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_process_files.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;if isValid( dstUtil ) then destroy dstUtil

end event

