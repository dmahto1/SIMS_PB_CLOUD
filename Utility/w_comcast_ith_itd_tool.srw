HA$PBExportHeader$w_comcast_ith_itd_tool.srw
$PBExportComments$Request download of ITH-ITD files from Comcast
forward
global type w_comcast_ith_itd_tool from w_response_ancestor
end type
type st_1 from statictext within w_comcast_ith_itd_tool
end type
type cbx_vmen01 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmen02 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmen03 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmen04 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmes01 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmes02 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmes03 from checkbox within w_comcast_ith_itd_tool
end type
type cbx_vmes04 from checkbox within w_comcast_ith_itd_tool
end type
type cb_send from commandbutton within w_comcast_ith_itd_tool
end type
type st_msg from statictext within w_comcast_ith_itd_tool
end type
type cb_1 from commandbutton within w_comcast_ith_itd_tool
end type
type cb_2 from commandbutton within w_comcast_ith_itd_tool
end type
type st_2 from statictext within w_comcast_ith_itd_tool
end type
type gb_1 from groupbox within w_comcast_ith_itd_tool
end type
type filetime from structure within w_comcast_ith_itd_tool
end type
type str_win32_find_data from structure within w_comcast_ith_itd_tool
end type
type str_ofstruct from structure within w_comcast_ith_itd_tool
end type
type os_systemtime from structure within w_comcast_ith_itd_tool
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

global type w_comcast_ith_itd_tool from w_response_ancestor
integer width = 2642
integer height = 1436
string title = "Comcast ITH-ITD Tool"
st_1 st_1
cbx_vmen01 cbx_vmen01
cbx_vmen02 cbx_vmen02
cbx_vmen03 cbx_vmen03
cbx_vmen04 cbx_vmen04
cbx_vmes01 cbx_vmes01
cbx_vmes02 cbx_vmes02
cbx_vmes03 cbx_vmes03
cbx_vmes04 cbx_vmes04
cb_send cb_send
st_msg st_msg
cb_1 cb_1
cb_2 cb_2
st_2 st_2
gb_1 gb_1
end type
global w_comcast_ith_itd_tool w_comcast_ith_itd_tool

type prototypes

Function ulong InternetOpen (ref string lpszAgent, ulong dwAccessType, ref string lpszProxy, ref string lpszProxyBypass, ulong dwFlags) Library "WININET.DLL" Alias for "InternetOpenA;Ansi"
Function ulong InternetConnect (ulong hInternet, ref string lpszServerName, long nServerPort, ref string lpszUserName, ref string lpszPassword, ulong dwService, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "InternetConnectA;Ansi"
Function Boolean InternetCloseHandle (ulong hInternet) Library "WININET.DLL"
Function boolean InternetGetLastResponseInfo(ref ulong lpdwError, String lpszBuffer, ref ulong lpdwBufferLength)  Library "WININET.DLL" Alias for "InternetGetLastResponseInfoA;Ansi" 

Function boolean FtpSetCurrentDirectory (ulong hConnect, ref string lpszDirectory) Library "WININET.DLL" Alias for "FtpSetCurrentDirectoryA;Ansi"
Function boolean FtpGetCurrentDirectory (ulong hConnect, ref string lpszCurrentDirectory, ref ulong lpdwCurrentDirectory) Library "WININET.DLL" Alias for "FtpGetCurrentDirectoryA;Ansi"


Function boolean FtpPutFile (ulong hConnect, ref string lpszLocalFile, ref string lpszNewRemoteFile, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpPutFileA;Ansi"
Function boolean FtpGetFile (ulong hConnect, ref string lpszRemoteFile, ref string lpszNewFile, boolean fFailIfExists, ulong dwFlagsAndAttributes,  ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" ALIAS for "FtpGetFileA;Ansi"
Function ulong FtpFindFirstFile (ulong hConnect, ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpFindFileData, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpFindFirstFileA;Ansi"
Function boolean FtpRenameFile (ulong hConnect, ref string lpszExisting, ref string lpszNew) Library "WININET.DLL" Alias for "FtpRenameFileA;Ansi"
Function boolean FtpDeleteFile (ulong hConnect, ref string lpszFileName) Library "WININET.DLL" Alias for "FtpDeleteFileA;Ansi"
Function boolean FtpCommand (ulong hConnect, boolean fExpectResponse, ulong dwFlagsAndAttributes, Ref string lpszCommand, ref ulong dwContext, ref ulong phFtpCommand) Library "WININET.DLL" Alias for "FtpCommandA;Ansi"

FUNCTION boolean CreateDirectoryA(ref string path, long attr)  LIBRARY "kernel32.dll" alias for "CreateDirectoryA;Ansi"
FUNCTION ulong GetCurrentDirectoryA(ulong BufferLen, ref string currentdir) LIBRARY "Kernel32.dll" alias for "GetCurrentDirectoryA;Ansi"
FUNCTION boolean CopyFile(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" ALIAS for "CopyFileA;Ansi"
FUNCTION ulong FindFirstFile(ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindFirstFileA;Ansi"
FUNCTION boolean FindNextFile(ulong hfindfile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindNextFileA;Ansi"
Function boolean InternetFindNextFile (ulong hFind, ref STR_WIN32_FIND_DATA lpvFindData) Library "WININET.DLL" Alias for "InternetFindNextFileA;Ansi"
Function boolean MoveFile (ref string lpExistingFileName, ref string lpNewFileName ) LIBRARY "kernel32.dll" ALIAS FOR "MoveFileA;Ansi"
Function boolean DeleteFile (ref string lpFileName) LIBRARY "kernel32.dll" ALIAS FOR "DeleteFileA;Ansi" 
FUNCTION long FormatMessage (Long dwFlags, ref Any lpSource, Long dwMessageId, Long dwLanguageId, ref String lpBuffer, Long nSize, Long Arguments) LIBRARY "kernel32" ALIAS FOR "FormatMessageA;Ansi"
FUNCTION ulong CreateMutexA(ulong lpMutexAttributes, long bInitialOwner, ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi" 
FUNCTION ulong GetLastError() library "kernel32.dll" 
function boolean GetComputerNameA(ref string  lpBuffer, ref ulong nSize) library "KERNEL32.DLL" alias for "GetComputerNameA;Ansi"

Function boolean FileTimeToSystemTime(ref FILETIME lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL"
Function long  CompareFileTime (ref FILETIME lpFileTime1,ref FILETIME lpFileTime2) Library "KERNEL32.DLL" alias for "CompareFileTime;Ansi" 

end prototypes

type variables

String is_sites[8,2]
String is_XML, is_path, is_cred, is_server, is_servername, is_username, is_password, is_msg
String is_buffer
Integer ii_records, ii_filenum, iiTransferMode
int xpos0,ypos0,xpos1, ypos1,xpos2, ypos2,xpos3, ypos3,xpos4, ypos4
INT ii_dirchanged

ulong	il_hConnection, il_hopen, il_error, il_bufferlen, il_port, il_dwcontext
long il_records

end variables

forward prototypes
public function integer wf_make_files ()
public function long wf_openconnection ()
public function long wf_makeconnection ()
public function boolean wf_changedirectory ()
public function boolean wf_checkdirectory ()
public function string wf_send_file ()
public function long wf_nbr_records ()
end prototypes

public function integer wf_make_files ();/* Create 8 files (1 for each site) on local drive in /files directory */
int retVal = 0
int li_filenum = 0
int li_result = 0
int li_sites_len = 0
int li_inx = 0
boolean bRet = false
String ls_path, ls_file

ls_path = 'files'
li_sites_len = UpperBound(is_sites)

/* Check that the directory \files\ exists */
IF NOT DirectoryExists( ls_path ) THEN
	bRet = CreateDirectoryA(ls_path, 0)
	if not bRet then
		MessageBox("Directory Error","The directory " + ls_path + " could not be created.")
	end if
END IF

/* Create files if they do not exists */
for li_inx = 1 to li_sites_len 
	ls_file = is_sites[li_inx, 2]
	IF NOT FileExists(ls_path+ "\" + ls_file) then
		li_filenum = FileOpen(ls_path+ "\" + ls_file,StreamMode!,Write!,Shared!,Replace!)
		If li_filenum >= 0 then
			li_result = FileWrite(li_filenum,is_XML)
			if li_result <= 0 then
				MessageBox("Error Writing File","Could not write data to " + ls_path + ls_file)
				return li_result
			else
				FileClose(li_filenum)
			end if
		Else
			MessageBox("Error Opening file","Could not open file for " + ls_path + ls_file)
		End If
	END IF
next

return retVal

end function

public function long wf_openconnection ();long retVal = 0
String ls_null

//Only need to connect once
IF il_hopen = 0 or isnull(il_hopen) THEN
	il_hopen=this.internetOpen(ls_null,0,ls_null,ls_null,0)
	IF il_hopen = 0 or isnull(il_hopen) THEN
		retVal = -1
		return retVal
	End IF
End If

return il_hopen


end function

public function long wf_makeconnection ();long retVal = 0

/* For testing only ** retVal +=  '~n~r' + space(5) + 'Internet Connection Opened. Handle = ' + String(il_hopen) */

il_hConnection=this.InternetConnect(il_hopen, is_servername, il_port, is_username, is_password,1,67108864,il_dwcontext) /* 67108864 = No Cache */
if il_hConnection <= 0 then
	retVal = -1
end if

return retVal
end function

public function boolean wf_changedirectory ();boolean retVal, bRet
ulong luBufferLength, lRet
string lsBuffer = space(35)

retVal = False
luBufferLength = len(is_path)

bRet = this.FtpSetCurrentDirectory(il_hConnection, is_path)

ii_dirchanged = 1



return retVal


end function

public function boolean wf_checkdirectory ();boolean bRet
String lsBuffer
ulong luBufferLength

lsBuffer = space(20)
luBufferLength = 20

bRet = FtpGetCurrentDirectory(il_hConnection, lsBuffer, luBufferLength)
/*
if bRet then 
		MessageBox("FTP Directory",lsBuffer) 
	else
		MessageBox("FTP Directory", "FtpGetCurrentDirectory failed.")
end if
*/
return bRet
end function

public function string wf_send_file ();String retVal, ls_null, ls_path, ls_FileName, ls_RemoteName, ls_send, ls_NullString
int li_result, li_sites_len, li_inx
ulong llErrorCode,llPort, ll_dwcontext, lu_error
boolean bRet

li_sites_len = UpperBound(is_sites)
//ls_NullString = NULL
ls_path = "files/"
ls_send = "N"
lu_error = 0
il_port = 0
il_dwcontext = 0
iiTransferMode = 0

//Only need to connect once
IF il_hopen = 0 or isnull(il_hopen) THEN
	il_hopen= wf_openconnection()
	IF il_hopen = -1 THEN
		retVal +=  "~n~r - ***** Unable to open FTP Connection."
		return retVal
	End If
End If

IF il_hConnection = 0 or isnull(il_hConnection) then
	lu_error = wf_makeconnection()
	IF lu_error < 0 or il_hConnection <= 0 THEN
		retVal +=  "~n~r        - ***** Unable to connect to FTP Server. " 
		return retVal
	End If
End If

IF ii_dirchanged = 0 THEN			// Change FTP directory only once
	bRet = wf_changedirectory()
END IF

bRet = wf_checkdirectory()

	/* Put the files to the server */
	for li_inx = 1 to li_sites_len
		ls_FileName = ls_path + is_sites[li_inx, 2]
		ls_RemoteName = is_sites[li_inx,2]

		ls_send = is_sites[li_inx, 1]
		IF ls_send = 'Y'  and FileExists(ls_FileName) THEN
			bRet =this.FtpPutFile(il_hConnection,ls_FileName, ls_RemoteName,iiTransferMode,ll_dwcontext) /* 03/04 - Mode passed in: 0-default, 1=ASCII */
			//bRet = this.FtpDeleteFile(il_hConnection, ls_RemoteName)
			
			If Not bret Then
				lu_error = GetLastError()
				retVal += '~n~r' + Space(10) + "***** Unable to upload file: " + ls_FileName  + ' to remote server!.  ErrorCode: ' + string(lu_error) + "."
			Else
				//bRet = this.InternetGetLastResponseInfo(il_error, ls_NullString, il_bufferlen )
				retVal += '~n~r' + Space(5) + is_sites[li_inx,2] 
				/*
				is_buffer = Space(il_bufferlen + 1)
				bRet = this.InternetGetLastResponseInfo(il_error, is_buffer, il_bufferlen )
				 For testing only
					retVal += '~n~r' + Space(10) + "isError: " + string(il_error) + "-BufferLength: " + &
						string(il_bufferlen) + " -- Buffer: " + is_buffer */
			End If
		END IF
	next
	
	//messagebox("End of processing","This is the end of processing")
/*	
if il_hConnection <> 0 then
	bRet=InternetCLoseHandle(il_hConnection)
	SetNull(il_hConnection)
end if
/* Close the internet connection if Open - hopefully, clear cache */
if il_hopen <> 0 then
	bRet=InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
end if


	retVal += '~n~r' + Space(10) + "Could not change Ftp Directory to " + is_path
	
				bRet = this.InternetGetLastResponseInfo(il_error, ls_NullString, il_bufferlen )
				is_buffer = Space(il_bufferlen + 1)
				bRet = this.InternetGetLastResponseInfo(il_error, is_buffer, il_bufferlen )
				retVal += '~n~r' + Space(10) + "File: " + ls_FileName + " was successfully uploaded to remote server:" + is_path
				retVal += '~n~r' + Space(10) + "isError: " + string(il_error) + "-BufferLength: " + &
						string(il_bufferlen) + " -- Buffer: " + is_buffer

 Reset sites  and checkboxes 
is_sites[1,1] = 'N'
is_sites[2,1] = 'N'
is_sites[3,1] = 'N'
is_sites[4,1] = 'N'
is_sites[5,1] = 'N'
is_sites[6,1] = 'N'
is_sites[7,1] = 'N'
is_sites[8,1] = 'N'
cbx_vmen01.checked = False
cbx_vmen02.checked = False
cbx_vmen03.checked = False
cbx_vmen04.checked = False
cbx_vmes01.checked = False
cbx_vmes02.checked = False
cbx_vmes03.checked = False
cbx_vmes04.checked = False
*/

return retVal

end function

public function long wf_nbr_records ();/* Get count of records in ITH-ITH ready for processing */
long retVal = 0

st_msg.text = ''

Select count(*) into :retVal
From Comcast_ith, comcast_itd 
Where comcast_ith.tran_nbr = Comcast_itd.tran_Nbr 
and comcast_ith.status in ('N', 'U')  
and comcast_itd.status = 'N' 
using SQLCA;

return retVal
end function

on w_comcast_ith_itd_tool.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_vmen01=create cbx_vmen01
this.cbx_vmen02=create cbx_vmen02
this.cbx_vmen03=create cbx_vmen03
this.cbx_vmen04=create cbx_vmen04
this.cbx_vmes01=create cbx_vmes01
this.cbx_vmes02=create cbx_vmes02
this.cbx_vmes03=create cbx_vmes03
this.cbx_vmes04=create cbx_vmes04
this.cb_send=create cb_send
this.st_msg=create st_msg
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_vmen01
this.Control[iCurrent+3]=this.cbx_vmen02
this.Control[iCurrent+4]=this.cbx_vmen03
this.Control[iCurrent+5]=this.cbx_vmen04
this.Control[iCurrent+6]=this.cbx_vmes01
this.Control[iCurrent+7]=this.cbx_vmes02
this.Control[iCurrent+8]=this.cbx_vmes03
this.Control[iCurrent+9]=this.cbx_vmes04
this.Control[iCurrent+10]=this.cb_send
this.Control[iCurrent+11]=this.st_msg
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.gb_1
end on

on w_comcast_ith_itd_tool.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cbx_vmen01)
destroy(this.cbx_vmen02)
destroy(this.cbx_vmen03)
destroy(this.cbx_vmen04)
destroy(this.cbx_vmes01)
destroy(this.cbx_vmes02)
destroy(this.cbx_vmes03)
destroy(this.cbx_vmes04)
destroy(this.cb_send)
destroy(this.st_msg)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.gb_1)
end on

event open;call super::open;int li_ret = 0

ii_dirchanged = 0

/* Initialize array for sending XML files */
is_sites[1,1] = 'N'
is_sites[1,2] = 'ITH_VMEN01'
is_sites[2,1] = 'N'
is_sites[2,2] = 'ITH_VMEN02'
is_sites[3,1] ='N'
is_sites[3,2] = 'ITH_VMEN03'
is_sites[4,1] ='N'
is_sites[4,2] = 'ITH_VMEN04'
is_sites[5,1] ='N'
is_sites[5,2] = 'ITH_VMES01'
is_sites[6,1] ='N'
is_sites[6,2] = 'ITH_VMES02'
is_sites[7,1] = 'N'
is_sites[7,2] = 'ITH_VMES03'
is_sites[8,1] = 'N'
is_sites[8,2] = 'ITH_VMES04'

/* All XML files have the same body - Only the file names are different */
is_XML = '<?xml version="1.0" encoding="UTF-8"?><eisdata><transaction><header><trantype>ITH</trantype><options>details</options></header></transaction></eisdata>'

CHOOSE CASE (upper(SQLCA.database))
	CASE 'SIMS33PRD'
		is_servername = 'ftp-prod.con-way.com'
	CASE 'SIMS33PAN'
		is_servername = 'ftp-test.con-way.com'
	CASE 'SIMS33TEST'
		is_servername = 'ftp-test.con-way.com'
END CHOOSE

is_username = 'mlgsims'
is_password = 'G$=Hwkz5'
is_path = 'out/MINTEK'

is_server = is_username + ':' + is_password + "@" + is_servername + "/" + is_path

/* Make local files if not already available */
li_ret = wf_make_files()

SetNull(il_hConnection)  /* reset connection - it appears that sometimes it is never discconecting*/
Setnull(il_hopen)




end event

event mousemove;call super::mousemove;/* Show button tag below command buttons */

IF xpos >= cb_1.X AND (xpos <= cb_1.x + cb_1.Width) AND &
     ypos >= cb_1.y AND (ypos <= cb_1.y + cb_1.Height) THEN
   st_2.text = cb_1.tag
ELSEIF xpos >= cb_send.X AND (xpos <= cb_send.x + cb_send.Width) AND &
     ypos >= cb_send.y AND (ypos <= cb_send.y + cb_send.Height) THEN
   		st_2.text = cb_send.tag
ELSEIF xpos >= cb_2.X AND (xpos <= cb_2.x + cb_2.Width) AND &
     ypos >= cb_2.y AND (ypos <= cb_2.y + cb_2.Height) THEN
   		st_2.text = cb_2.tag
ELSEIF xpos >= cb_ok.X AND (xpos <= cb_ok.x + cb_ok.Width) AND &
     ypos >= cb_ok.y AND (ypos <= cb_ok.y + cb_ok.Height) THEN
   		st_2.text = cb_ok.tag
ELSE
  	 st_2.text = ""
END IF

end event

event ue_close;call super::ue_close;//boolean bRet

/* Close connections 
if il_hConnection <> 0 then
	bRet=InternetCLoseHandle(il_hConnection)
	SetNull(il_hConnection)
end if
/* Close the internet connection if Open - hopefully, clear cache */
if il_hopen <> 0 then
	bRet=InternetCLoseHandle(il_hopen)
	SetNull(il_hopen)
end if
*/

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_comcast_ith_itd_tool
boolean visible = false
integer x = 1207
boolean enabled = false
end type

type cb_ok from w_response_ancestor`cb_ok within w_comcast_ith_itd_tool
string tag = "Done and &Exit"
integer x = 1979
integer y = 1144
string text = "Done"
end type

type st_1 from statictext within w_comcast_ith_itd_tool
integer x = 567
integer y = 4
integer width = 928
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comcast ITH-ITD Tool"
boolean focusrectangle = false
end type

type cbx_vmen01 from checkbox within w_comcast_ith_itd_tool
string tag = "Menlo Atlanta"
integer x = 105
integer y = 184
integer width = 402
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMEN01"
end type

event clicked;If cbx_vmen01.checked = True Then
	is_sites[1,1] = 'Y'
Else
	is_sites[1,1] = 'N'
End If

end event

type cbx_vmen02 from checkbox within w_comcast_ith_itd_tool
string tag = "Menlo Aurora"
integer x = 105
integer y = 264
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMEN02"
end type

event clicked;If cbx_vmen02.checked = True Then
	is_sites[2,1] = 'Y'
Else
	is_sites[2,1] = 'N'
End If

end event

type cbx_vmen03 from checkbox within w_comcast_ith_itd_tool
string tag = "Menlo Fremont"
integer x = 105
integer y = 340
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMEN03"
end type

event clicked;If cbx_vmen03.checked = True Then
	is_sites[3,1] = 'Y'
Else
	is_sites[3,1] = 'N'
End If

end event

type cbx_vmen04 from checkbox within w_comcast_ith_itd_tool
string tag = "Menlo Monroe"
integer x = 105
integer y = 416
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMEN04"
end type

event clicked;If cbx_vmen04.checked = True Then
	is_sites[4,1] = 'Y'
Else
	is_sites[4,1] = 'N'
End If

end event

type cbx_vmes01 from checkbox within w_comcast_ith_itd_tool
string tag = "ComcastSIKAtlanta"
integer x = 105
integer y = 492
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMES01"
end type

event clicked;If cbx_vmes01.checked = True Then
	is_sites[5,1] = 'Y'
Else
	is_sites[5,1] = 'N'
End If

end event

type cbx_vmes02 from checkbox within w_comcast_ith_itd_tool
string tag = "ComcastSIKAurora"
integer x = 105
integer y = 568
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMES02"
end type

event clicked;If cbx_vmes02.checked = True Then
	is_sites[6,1] = 'Y'
Else
	is_sites[6,1] = 'N'
End If

end event

type cbx_vmes03 from checkbox within w_comcast_ith_itd_tool
string tag = "ComcastSIKFremont"
integer x = 105
integer y = 644
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMES03"
end type

event clicked;If cbx_vmes03.checked = True Then
	is_sites[7,1] = 'Y'
Else
	is_sites[7,1] = 'N'
End If

end event

type cbx_vmes04 from checkbox within w_comcast_ith_itd_tool
string tag = "ComcastSIKMonroe"
integer x = 105
integer y = 720
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "VMES04"
end type

event clicked;If cbx_vmes04.checked = True Then
	is_sites[8,1] = 'Y'
Else
	is_sites[8,1] = 'N'
End If

end event

type cb_send from commandbutton within w_comcast_ith_itd_tool
string tag = "Send all checked files to request ITH/ITD download"
integer x = 55
integer y = 1144
integer width = 603
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Send Request(s)"
end type

event clicked;/* Pass through is_sites and send files to ETS */
int li_no, i
String ls_retStr
st_msg.text = ''
li_no = 0
ls_retStr = ''

For i = 1 to 8
	If is_sites[i, 1] = 'Y' Then
		li_no = li_no + 1
	End If
next 

If li_no = 0 Then
	MessageBox('Sending Requests to Comcast', ' There must be at least one request')
Else
	st_msg.text = 'Results:'
	
	ls_retStr = wf_send_file()
	
	ls_retStr += '~n~rA request has been sent to pull ITH-ITD files for each warehouse~n~r' + &
						'listed above.  It will take some time before the records arrive for~r~n' + &
						 'processing.  Use the Records to Process button to monitor the~r~n' + &
						 'number of records received.  When you feel all records have ~r~n' + &
						 'arrived, use the ProcessITH button to move the serial numbers ~r~n' + &
						 'to the  carton/serial table.'
	
	st_msg.text += ls_retStr
	
	//MessageBox("Send request results",ls_retStr)
	
End If

end event

type st_msg from statictext within w_comcast_ith_itd_tool
integer x = 695
integer y = 132
integer width = 1897
integer height = 964
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_comcast_ith_itd_tool
event mousemove ( )
string tag = "Show serial numbers downloaded and ready to process to carton/serial"
integer x = 763
integer y = 1144
integer width = 613
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Records to Process"
end type

event clicked;/* Check ITH-ITD tables for number of records ready to process */
//ii_records = 0

il_records = wf_nbr_records()

st_msg.text = 'There are ' + string(il_records) + ' records ready to process.'

end event

type cb_2 from commandbutton within w_comcast_ith_itd_tool
string tag = "Records will be processed into carton/serial on next Sweeper cycle"
integer x = 1472
integer y = 1144
integer width = 443
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&ProcessITH"
end type

event clicked;/* Trigger Comcast ITH-ITD processing on next Sweeper cycle */
/* Comcast ITH-ITD processing has been moved from Sweeper to Stored Procedure */
/* Replaced 10/10/2012 - GWM */
int liYr, liMo, liDay, retVal, liJobId, liCtr, liTemp, liRtn
Datetime ldt_dtime
Date ld_date
String lsSP = 'Comcast_Process_ITH-ITD'
String lsRetMsg = ''
String lsProcName, lsSql, lsTemp

lsProcName = 'sprocStartComcastProcess'
lsSql = 'execute ' + lsProcName

//lsSql = "dbo.sp_start_job N'Comcast_Process_ITH-ITD'"
liJobId = 1

ld_date = RelativeDate(Today(), - 1)
ldt_dtime = datetime(ld_date, Now())

//EXECUTE IMMEDIATE 'USE msdb';

EXECUTE IMMEDIATE :lsSql;

If SQLCA.SQLCODE <> 0 Then
   MessageBox( "ERROR", string( sqlca.sqlcode ) + SQLCA.SqlErrText )
Else
	st_msg.text = 'Comcast Process ITH has been launched.~n~r~n~rCheck Records to Process for completion'
End If

//st_msg.text = 'Returned String: ' + lsTemp + ' / Returned Number: ' + string(liTemp)



				
end event

type st_2 from statictext within w_comcast_ith_itd_tool
integer x = 55
integer y = 1284
integer width = 2098
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_comcast_ith_itd_tool
integer x = 50
integer y = 104
integer width = 603
integer height = 712
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Check All That Apply"
end type

