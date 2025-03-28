$PBExportHeader$n_cst_appmanager.sru
forward
global type n_cst_appmanager from nonvisualobject
end type
type filetime from structure within n_cst_appmanager
end type
type str_filetime from structure within n_cst_appmanager
end type
type str_win32_find_data from structure within n_cst_appmanager
end type
type security_attributes from structure within n_cst_appmanager
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type str_filetime from structure

   ulong     ul_LowDateTime

   ulong     ul_HighDateTime

end type

type str_win32_find_data from structure

        unsignedlong            fileattributes

        str_filetime            creationfile

        str_filetime            lastaccesstime

        str_filetime            lastwritetime

        unsignedlong            filesizehigh

        unsignedlong            filesizelow

        unsignedlong            reserved0

        unsignedlong            reserved1

        character               filename[260]

        character               altfilename[14]

end type

type security_attributes from structure
	unsignedlong		nlength
	unsignedlong		lpsecuritydescriptor
	boolean		binherithandle
end type

global type n_cst_appmanager from nonvisualobject
end type
global n_cst_appmanager n_cst_appmanager

type prototypes
Function long  CompareFileTime (ref FILETIME lpFileTime1,ref FILETIME lpFileTime2) Library "KERNEL32.DLL" alias for "CompareFileTime;Ansi" 
Function ulong InternetConnect (ulong hInternet, ref string lpszServerName, long nServerPort, ref string lpszUserName, ref string lpszPassword, ulong dwService, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "InternetConnectA;Ansi"
Function ulong InternetOpen (ref string lpszAgent, ulong dwAccessType, ref string lpszProxy, ref string lpszProxyBypass, ulong dwFlags) Library "WININET.DLL" Alias for "InternetOpenA;Ansi"
Function boolean FtpPutFile (ulong hConnect, ref string lpszLocalFile, ref string lpszNewRemoteFile, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpPutFileA;Ansi"
FUNCTION ulong GetCurrentDirectoryA(ulong BufferLen, ref string currentdir) LIBRARY "Kernel32.dll" alias for "GetCurrentDirectoryA;Ansi"
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"
Function boolean FtpSetCurrentDirectory (ulong hConnect, ref string lpszDirectory) Library "WININET.DLL" Alias for "FtpSetCurrentDirectoryA;Ansi"
Function boolean FtpGetFile (ulong hConnect, ref string lpszRemoteFile, ref string lpszNewFile, boolean fFailIfExists, ulong dwFlagsAndAttributes,  ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpGetFileA;Ansi"
Function boolean CopyFile (ref string lpExistingFileName, ref string lpNewFileName, boolean bFailIfExists) Library "KERNEL32.DLL" Alias for "CopyFileA;Ansi"
FUNCTION ulong FindFirstFile(ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindFirstFileA;Ansi"
FUNCTION boolean FindNextFile(ulong hfindfile, ref STR_WIN32_FIND_DATA lpffd)  LIBRARY "kernel32.dll" ALIAS FOR "FindNextFileA;Ansi"
Function ulong FtpFindFirstFile (ulong hConnect, ref string lpszSearchFile, ref STR_WIN32_FIND_DATA lpFindFileData, ulong dwFlags, ref ulong dwContext) Library "WININET.DLL" Alias for "FtpFindFirstFileA;Ansi"
Function boolean InternetFindNextFile (ulong hFind, ref STR_WIN32_FIND_DATA lpvFindData) Library "WININET.DLL" Alias for "InternetFindNextFileA;Ansi"
FUNCTION boolean GetUserNameA(ref string uname, ref ulong slength) LIBRARY "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
Function ulong CreateFile (ref string lpFileName, ulong dwDesiredAccess, ulong dwShareMode, ref SECURITY_ATTRIBUTES lpSecurityAttributes, ulong dwCreationDisposition, ulong dwFlagsAndAttributes, ulong hTemplateFile) Library "KERNEL32.DLL" Alias for "CreateFileA;Ansi"
FUNCTION boolean SetCurrentDirectoryA(ref string cdir) LIBRARY "kernel32.dll" alias for "SetCurrentDirectoryA;Ansi"
function boolean GetComputerNameA(ref string  lpBuffer, ref ulong nSize) library "KERNEL32.DLL" alias for "GetComputerNameA;Ansi"
//Subroutine GetSystemTime (ref SYSTEMTIME lpSystemTime) Library "KERNEL32.DLL"
//TimA 02/16/15 Added because the user wanted a louder sound when an error occured in the Box ID swapping for Pandora.  There is a WAV file that is call in the window.
Subroutine sndPlaySoundA( string s_wav_file,   int uFlags ) Library "winmm.dll" alias for "sndPlaySoundA;Ansi"
end prototypes

type variables
Public:

string	is_Helpfile, is_Pick_sort_order, is_std_mesure, is_gemini_ind, is_coo_ind, is_owner_ind, is_in_sku_list_ind
String	is_allow_batch_Pick, is_Allow_OverPick, is_allow_alt_supplier_pick, is_scanner_ind, isAppServer, is_Unique_Pack_CartonNumbers
String	is_allow_alt_sku_Pick, isWebsphereURL,isWebsphereDatasource
string	is_dd_change_enabled, isReceiptBackorder, isDeliveryBAckorder, isValidatePutaway
Long		ilPrintCopies, ilWebspherePort
DateTime	idt_USer_Login_Time

String is_OTM_Enable_Ind

datastore	ids_reports, ids_project_warehouse, ids_columnlabel, idsUserWarehouse, ids_dddw_Carrier, ids_coo_translate,	&
				ids_Item_serial_Prefix, ids_Country
				
str_parms istr_parms

//nvo_kernell32 inv_kernell
// MAX_PATH constant for file operations
Private constant long MAX_PATH = 260
m_main im_menu
n_warehouse i_nwarehouse
n_cst_gemini i_gemini 

Boolean	ibFedexEnabled, ibAppServerEnabled, ibCCCEnabled, ibTNTEnabled, ibNoPromptPrint,	&
			ibForwardPickEnabled, ibTRAXEnabled, ibAllowDupDeliveryOrderNumbers, ibSyncPackcarton, ibEtaMaintEnabled, ibCartonSerialValidationRequired, &
			ibAllowDupReceiveOrderNumbers, ibReadyToShipEnabled,ibScanAllOrdersRequired, ibSupportUnicode, ibSendWebsphereGoodsIssue, ibSendWebsphereGoodsReceipt

Connection	AppserverConnection

// pvh - 08/24/05
string isCurrentWarehouse
string isLastWarehouse
int iiLastOffset
datetime idtDSTStarts
datetime idtDSTEnds
decimal{2} idOffset
string isDSTFlag
String	isWarehouseTimezone /* 09/14 - PCONKL*/

// pvh - 02/01/06
string isReceiveDetailChangeInd

inet	linit
u_nvo_websphere_post	iuoWebsphere

//TAM 2006/06/16
string isProjectUserField1

datastore idsSuppliers

// pvh - 05/01/06 - idle
int projectIdleTime
int projectAppTeminateTime

// pvh - 08/18/06
datastore idsFunctionRights

// pvh - 09/18/06 - moved bol print, picking/packing print dataobjects to app level
// to relieve some code in our humgous w_do
string isBOLPrintDo
string isPickPrintDo
string isPackPrintDo

// KRZ - Global reference to the frame window.
public w_main iw_frame

// LTK 20111227	OTM additions
String is_OTM_Delivery_Order_Send_Ind, is_OTM_Delivery_Order_Receive_Ind, is_OTM_Item_Master_Send_Ind
//MEA - 3/12 - OTM
String    isOTMCheckOutboundChanges, isOTMSendInboundOrder

// 04/12 - PCONKL - NT login authentication fields
String	gs_DBConfigIni

// ET3 - 12/06/14 - Added SN Chain of Custody: default is N; Y means treat like Pandora and BlueCoat
Boolean ibSNChainOfCustody = FALSE

//MEA - 2/13 - Added to Copy Lot No to Packlist functionality
String isCopy_Lot_No_to_Packlist  

Private Integer        ino_of_pref

//TimA 10/22/12 Part of Pandora #472
Integer ino_of_original_cols
Long il_col_original_nos[], il_DataWindowNo
String is_column_original_names[],	is_extra_original_str,is_width_original_str
Datastore ids_Custom_dw

Boolean	ibMobileEnabled		/* 09/14 - PCONKL*/

Boolean	ibAllowQuantityDecimals		// LTK 20150115

Boolean ib_shutdown =FALSE //09-APR-2015 Madhu Added -SIMS Timer Notification Alert
Boolean ib_Flag =FALSE //09-APR-2015 Madhu Added -SIMS Timer Notification Alert
String isProjectId,isUserId,isAlertNotes //09-APR-2015 Madhu Added -SIMS Timer Notification Alert

Boolean ibAllowInvTypeChangeOnTransfers		// LTK 20150824

DataStore ids_hazardous_materials	// LTK 20151028

Boolean ibUseHazardousTable			// LTK 20151030
Boolean ibPreventAirCarrierforHazardous //31-May-2016 Madhu Added
Boolean ibCommodityAuthorizedUser //01-Jun-2016 Madhu Added
Boolean ib_Receive_Putaway_Serial_Rollup_Ind //29-MAR-2019 Madhu S31781 F14974 Added Receive Putaway Serial RollUp Indicator
constant  Boolean INCLUDE_EMPTY_ROW = TRUE

end variables

forward prototypes
public function string of_get_owner_name (long as_owner_id)
public function integer of_setmicrohelp (ref dwobject adw)
public function integer of_dirtoarray (string path, ref string lista[])
public function integer of_lable_insert (datawindow ads)
public function integer of_get_label ()
public function integer of_findlabels (datawindow adw)
public function integer of_project_warehouse (ref string as_project_id, ref string as_wh_code)
public function decimal of_next_db_seq (string as_project, string as_table, string as_column)
public function integer of_get_week (date adcurrentdate)
public function string of_get_username ()
public subroutine of_resize (window awin)
public function integer of_setmicrohelp ()
public function integer of_setwarehouse (boolean as_value)
public function integer of_connect_to_appserver ()
public function integer of_connect_to_db ()
public function integer of_init_open ()
public function integer of_project_warehouse ()
public function integer of_set_warehouse_dropdown (ref datawindowchild adw_warehouse)
public function integer of_load_user_warehouse ()
public subroutine of_setmenu (boolean as_value)
public function integer of_load_project_dropdowns ()
public function integer of_check_label (datawindow adw)
public function string of_get_project_ind ()
public function string uf_build (character arg_3digits[3], string arg_building)
public function string uf_num_to_words (decimal arg_num_to_convert)
public function integer uf_send_email (string asdistriblist, string assubject, string astext, string asattachments)
public subroutine setcurrentwarehouse (string aswhcode)
public function string getcurrentwarehouse ()
public function datetime of_getworldtime ()
public subroutine setlastoffset (integer avalue)
public function integer getlastoffset ()
public subroutine setwarehousedata ()
public subroutine setlastwarehouse (string aswarehouse)
public function string getlastwarehouse ()
public subroutine setdststarts (datetime _value)
public subroutine setdstends (datetime _value)
public function datetime getdststarts ()
public function datetime getdstends ()
public subroutine setdstflag (string _value)
public function string getdstflag ()
public subroutine setgmtoffset (decimal avalue)
public function decimal getgmtoffset ()
public subroutine setreceivedetailchangeind (string _value)
public function string getreceivedetailchangeind ()
public function datastore getsupplierds ()
public function datastore getcountryds ()
public subroutine doprojectwarehouserefresh ()
public subroutine dorefreshsupplierds ()
public function integer getprojectappteminatetime ()
public subroutine setprojectidletime (integer _seconds)
public function integer getprojectidletime ()
public subroutine setprojectappterminatetime (integer _minutes)
public function long dofunctionrightsretrieve ()
public function boolean getfunctionrights (string process, string action)
public subroutine setbolprintdo (string value)
public subroutine setpickprintdo (string value)
public subroutine setpackprintdo (string value)
public function string getbolprintdo ()
public function string getpackprintdo ()
public function string getpickprintdo ()
public function integer of_check_label_button (graphicobject a_graphicobject)
public function integer uf_post_connect_open ()
public function integer uf_logout ()
public function integer uf_set_dw (ref datawindow adw_name, ref string avalues[])
public function integer of_get_custom_dw ()
public function integer of_set_dw_columns (datawindow adw_name)
public function integer uf_get_dw_values (ref datawindow adw_name, ref string avalues[])
public function integer uf_connect_to_replication_db ()
public function boolean uf_is_report_running_on_replication (string asreportwindow)
public subroutine of_sims_notification (integer al_interval)
public subroutine of_sims_notification_process ()
public function integer of_set_sims_defaults ()
public function long uf_load_hazardous_materials (boolean ab_include_empty_row)
end prototypes

public function string of_get_owner_name (long as_owner_id);String	lstype,	&
			lsCode,	&
			lsOwnerCode

Select owner_type, owner_cd
Into	:lstype, :lsCode
From	Owner 
Where Owner_id = :as_owner_id
Using SQLCA;

If lsCode > '' Then
	Return  lsCode + '(' + lsType + ')'
Else
	Return ''
End If

end function

public function integer of_setmicrohelp (ref dwobject adw);//This function sets the microhelp called from u_dw_ancestor
window activesheet
string ls_title,ls_tag
integer li_ret
li_ret = -1
activesheet = w_main.GetActiveSheet()
IF IsValid(activesheet) THEN
	IF IsValid(adw) THEN ls_tag = adw.tag	
	IF  ls_tag = "?" or len(ls_tag) = 0 THEN ls_tag = "Ready"
	 li_ret=activesheet.Setmicrohelp( ls_tag)	 
END IF
return li_ret
end function

public function integer of_dirtoarray (string path, ref string lista[]);//This function takes two parameter
//1. Path of directory you want to list all the files
//2. All the filenames would be stored in array of strings

long lul_handle

str_win32_find_data str_find

boolean lb_fin

integer n

 

str_find.filename=space(MAX_PATH)

str_find.altfilename=space(14)

n = 0

lul_handle = FindFirstFile(path, str_find)

do

        n += 1

        lista[n] = str_find.filename

        lb_fin = FindNextFile(lul_handle, str_find)

loop while lb_fin

 

return n

 

end function

public function integer of_lable_insert (datawindow ads);//This function is not called by anywhere this is used in development envirnment only
//For uploading the lables in column label tables

long ll_cnt_col,ll_cnt,ll_rtn,ll_newrow
String ls_col[],ls_describe,ls_dwo_name,ls_tablename
Datastore lds_cl
lds_cl = Create DataStore
lds_cl.Dataobject = 'd_columnlabel'
ll_cnt=lds_cl.SetTransObject(SQLCA)
ls_dwo_name = String(ads.Dataobject)
ll_cnt_col = integer(ads.Object.DataWindow.Column.Count)
ls_tablename=string(ads.Object.DataWindow.Table.UpdateTable)

ll_rtn = 1
FOR ll_cnt = 1 TO ll_cnt_col
	ls_describe = "#" + string(ll_cnt) + ".dbName"
	ls_col[ll_cnt] = ads.Describe(ls_describe)
	ll_newrow=lds_cl.InsertRow(0)
	IF ll_newrow > 0 THEN
		lds_cl.object.project_id[ll_newrow] = gs_project
		lds_cl.object.datawindows[ll_newrow] = ls_dwo_name		
		lds_cl.object.column_name[ll_newrow] = ls_col[ll_cnt]		
		lds_cl.object.table_name[ll_newrow]=ls_tablename 
	ELSE 
		ll_rtn = -1	
	END IF	
	
NEXT
ll_rtn=lds_cl.Update() 
destroy lds_cl
Return ll_rtn

end function

public function integer of_get_label ();long ll_rtn
string ls_str, ls_template

//gs_userid
//
ls_str = "TEMPLATE:" + gs_userid

ls_template = ProfileString(gs_inifile,gs_project, ls_str,"")

IF ls_template = "" THEN ls_template = "BASELINE" //Default template for Project

ids_columnlabel = Create datastore
ids_columnlabel.DataObject = 'd_columnlabel'
IF ids_columnlabel.SetTransObject(SQLCA) < 0 THEN Return -1
setpointer(Hourglass!)
w_main.SetMicroHelp("Loading Column Labels...")

ll_rtn=ids_columnlabel.Retrieve(gs_project, ls_template)
IF ll_rtn <= 0 then //If nothing is returned, try to load the baseline for the project.
	ids_columnlabel.Retrieve(gs_project, 'BASELINE')
END IF

w_main.SetMicroHelp("Ready")
SetPointer(Arrow!)
return ll_rtn
end function

public function integer of_findlabels (datawindow adw);//To be continued later as soon as we have specs ready & databse changes done.
long ll_colcnt,ll_cnt
String ls_colname,ls_temp

IF NOT ISVALID(adw) THEN Return -1
ll_colcnt=integer(adw.Object.DataWindow.Column.Count)
FOR ll_cnt = 1 TO ll_colcnt
	ls_temp = "#" + string(ll_cnt) + ".Name"
	ls_colname=adw.Describe(ls_temp)	
	ls_colname = ls_colname + "_t"
	IF ls_colname = "po_no_t" THEN
//		Messagebox("","Po_no found....")
	END IF	
NEXT
Return 1

end function

public function integer of_project_warehouse (ref string as_project_id, ref string as_wh_code);//This function is used for finding the right row for given project & warehouse 
long ll_row
String ls_temp
IF ISValid(ids_project_warehouse) THEN
	ls_temp="Upper(project_id) = '"+Upper(as_project_id)+ &
		"' and  Upper(wh_code) ='"+ Upper(as_wh_code) + "'"
	ll_row=ids_project_warehouse.Find(ls_temp,1,ids_project_warehouse.Rowcount())	
END IF		
Return ll_row

end function

public function decimal of_next_db_seq (string as_project, string as_table, string as_column);Decimal	llNextSeq
Long		llCount
string	lsproject

sqlca.sp_next_avail_seq_no(as_project,as_table,as_column,llnextSeq)


If SQLca.SQLCode < 0 Then
//	Execute Immediate "ROLLBACK" using SQLCA;
	Return -1
End If

// 05/02 - Pconkl - If row not, add and try again
If llNextSeq <=0 Then
	
	//See if it already exists, if so that's not the problem. If not, add it
	
	Select Count(*) into :llCount
	From next_sequence_no
	Where Project_id = :as_project and table_name = :as_table and column_name = :as_column;
	
	If llCount > 0 Then
		
	//	Execute Immediate "ROLLBACK" using SQLCA;
		Return - 1
		
	Else /* insert a new row and try again*/
		
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		
		insert Into Next_Sequence_NO
			(project_id, table_name, column_Name, Next_Avail_seq_no)
			Values (:as_project, :as_Table, :as_Column, 1);
			
		Execute Immediate "COMMIT" using SQLCA;
		
		sqlca.sp_next_avail_seq_no(as_project,as_table,as_column,llnextSeq)
		If SQLca.SQLCode < 0 Then
		//	Execute Immediate "ROLLBACK" using SQLCA;
			Return -1
		End If

	End If /*Row not found */
	
End If


//Execute Immediate "COMMIT" using SQLCA;
Return llNextSeq

end function

public function integer of_get_week (date adcurrentdate);
//Returns Current Week Based on SQL Server  DATENAME function

Integer	liWeekNo

liWeekno = sqlca.sp_get_week(adCurrentDate)

Return liWeekNo
end function

public function string of_get_username ();string ls_username
string ls_var 
ulong lu_val
boolean rtn
lu_val = 255
ls_username = Space( 255 )
rtn = GetUserNameA(ls_username, lu_val)
return ls_username
end function

public subroutine of_resize (window awin);string ls_syntax, ls_rc
int    li_rc
str_parms lstrparms

Integer			li_ScreenH, li_ScreenW
Environment	le_Env

lstrparms = Message.PowerObjectParm 

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

awin.Y = (li_ScreenH - awin.Height) / 2
awin.X = (li_ScreenW - awin.Width) / 2


end subroutine

public function integer of_setmicrohelp ();window activesheet
string ls_title
integer li_ret
li_ret = -1
activesheet = w_main.GetActiveSheet()
IF IsValid(activesheet) THEN	  
	 li_ret=activesheet.Setmicrohelp( "Ready")	 
END IF
return li_ret
end function

public function integer of_setwarehouse (boolean as_value);//This function is called instantiate/destroys  n_warehose uerobject & assigns it to
//i_nawarehouse.
IF isnull(as_value) THEN return -1

IF as_value THEN 
	This.i_nwarehouse = Create n_warehouse
ELSE
	IF ISValid(This.i_nwarehouse) THEN Destroy This.i_nwarehouse
END IF
Return 1
end function

public function integer of_connect_to_appserver ();
Long	llRC
String	lsMSG, lsurl

ibappserverenabled = False

// 10/12 - PCONKL - Added datasource

Select connection_url, connection_port, connection_datasource_Name
Into	:isWebSphereurl, :ilWebspherePort,:isWebsphereDAtasource
From websphere_settings;

If isWebSphereurl > '' Then 
	ibappserverenabled = True
else
	//check to see if we have an ini file override...
	lsurl = ProfileString(gs_inifile,"WEBSPHERE","url","") /*only need to check, don't load to instance variable - will be loaded at post time*/
	if lsurl > "" Then
		ibappserverenabled = True
	End If
End If

Return 0
end function

public function integer of_connect_to_db ();//MA - Added PB11 entries to make seemless from 9.

// 04/12 - PCONKL - DB USer/Password now being passed back from Websphere, not taken from App
//						Server/DB being taken from new .ini file based on DB selected on login screen

sqlca.DBMS       = "SNC SQL Native Client(OLE DB)" //ProfileString(gs_inifile,"sims3","dbms","")
//sqlca.database   = ProfileString(gs_inifile,"sims3","database","")
sqlca.userid     = ProfileString(gs_inifile,"sims3","userid","")
sqlca.dbpass     = ProfileString(gs_inifile,"sims3","dbpass","")
//sqlca.logid      = ProfileString(gs_inifile,"sims3","logid","")
//sqlca.servername = ProfileString(gs_inifile,"sims3","servername","")



//sqlca.dbparm	  = "Database='"+sqlca.database+"',TrimSpaces=1,DisableBind=0" //ProfileString(gs_inifile,"sims3","dbparm","")
//sqlca.dbparm	  = "Database='"+sqlca.database+"',TrimSpaces=1" //ProfileString(gs_inifile,"sims3","dbparm","")

// Added string to turn off MARS  -- 04/29/11  cawikholm
//sqlca.dbparm       = "Database='"+sqlca.database+"',TrimSpaces=1,ProviderString = 'MARS Connection=False'"
//04/27/2020 - dts - adding Provider Paramater
sqlca.dbparm       = "Database='"+sqlca.database+"',TrimSpaces=1,ProviderString = 'MARS Connection=False',Provider='SQLNCLI11'"

// 04/15/11 - PCONKL - Changed isolation from Read Committed to Read Uncommitted
//sqlca.LOCK = "RC" 
sqlca.LOCK = "RU" 

//sqlca.dbparm="Database='"+sqlca.database+"',TrimSpaces=1,DisableBind=1,TrustServerCertifi­cate=1,DelimitIdentifier=1,OJSyntax='ANSI',ProviderString='MultipleActiveResultSets=False; OLE DB Services=-4'" 



//sqlca.AutoCommit = False
sqlca.AutoCommit = TRUE /* 11/04 - PCONKL - Turned auto commit on to ellinate DB locks */


connect using sqlca;

//Need to set the Ansi warnings off

EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING SQLCA;

//SQLCA.DBParm = "disablebind =0"


Return sqlca.sqlcode
end function

public function integer of_init_open ();Long	llRC

gs_inifile = 'Sims30D.ini' 
SetPointer (HourGlass!)

gs_company_name = ProfileString(gs_inifile,"sims3","customer","")
gs_default_wh = ProfileString(gs_inifile,"sims3","DefaultWarehouse","")
gs_damage_loc = ProfileString(gs_inifile,"sims3","DamageLocation","")
gs_syspath = ProfileString(gs_inifile,"sims3","SysPath","")


//10/17 - MEA - Change for Mirgration

//	Look for a copy of the .ini file on the desktop. If it exists, assign the desktop path to the gs_inifile variable.


//Get desktop path for user. 

 String ls_keyword, ls_values [], ls_desktop
 ContextKeyword lcx_key

 GetContextService ("ContextKeyword", lcx_key)
 ls_keyword = "UserProfile"
 
 lcx_key.GetContextKeywords (ls_keyword, ls_values)

 ls_desktop = ls_values[1] + "\desktop\" + gs_inifile 


IF FileExists(ls_desktop) THEN
	
	gs_inifile = ls_desktop
	
ELSE
	
	//Ini File Not on Desktop
	
	gs_inifile = gs_syspath + gs_inifile
	
	//	If it does not exist
	//	Copy it from the system path (e.g. c:\sims-mww) to the desktop
	
	
	FileCopy ( gs_inifile, ls_desktop, True) 
		
	IF FileExists( ls_desktop ) THEN 
		
		//	If it is successfully copied (if fileExists() = true), assign the path to gs_inifile
		
		gs_inifile = ls_desktop
		
	ELSE
		
		//If not successful, assign the default path to gs_inifile as we are currently doing today.
		
		//04/02 - PCONKL - Include path in ini file if present - once the default directory is changed, we lose it

		If gs_inifile > '' Then
			gs_inifile = gs_syspath + gs_inifile
			If not FileExists(gs_inifile) Then
				gs_inifile = 'Sims30D.ini' 
			End If
		End If
	
	END IF
	
	
END IF





// 04/12 - PCONKL - DB paramters coming from new SIMSDBConfig.ini file
gs_DBConfigIni = "SIMSDBConfig.ini"
gs_DBConfigIni = gs_syspath + gs_DBConfigIni
If not FileExists(gs_DBConfigIni) Then
	gs_inifile = 'SIMSDBConfig.ini' 
End If

If not FileExists(gs_DBConfigIni) Then
	Messagebox("Config error","Unable to load SIMSDBConfig.ini file. Unable to start SIMS")
	Halt Close
End If

// 08/00 Pconkl - open splash screen
//Open(w_sims_splash)

// 04/12 - PCONKL - Logging in with NT credentials  before connecting to DB - moving to new function - uf_post_connect_open

////connect using sqlca;
//llRC = of_Connect_to_db()
//SetPointer (Arrow!)
//
//IF llRC <> 0 THEN
//	MessageBox ("Sorry! Cannot Connect to Database", sqlca.sqlerrtext)
//	Halt close
//	Return -1
//END IF
//
//gb_sqlca_connected = TRUE

// 10/05 - PCONKL - Load App server settings
//of_Connect_To_AppServer()

//today = Today()
//
//// 12/00 PCONKl - initialize reports by project datastore
//ids_reports = Create Datastore
//ids_reports.dataobject = 'd_project_reports'
//ids_reports.SetTRansObject(SQLCA)
//
////set helpfile
//If gs_sysPath > '' Then
//	is_HelpFile = gs_sysPath + "Simshelp.hlp"
//Else
//	is_helpfile = "Simshelp.hlp"
//End If
//

//// KRZ - Open the frame window and store reference in instance var.
Open(iw_frame)
w_main = iw_frame

//Close(w_sims_splash)


return 1


end function

public function integer of_project_warehouse ();// of_project_warehouse()

////This function is used for for creating datastore & retriving data from project_warehouse table 
long ll_row
string ls_project_ind, lsXML
string ERRORS,  dwsyntax_str,sql_syntax,ls_presentation_str

// 11/01 - PCONKL - retrieve existing DW (by project) ninsted of creating on the fly

//09/14 - PCONKL - Update warehouse Offsets from Websphere...
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("WarehouseOffsetUpdateRequest", "ProjectID='" + gs_Project + "'")
lsXML = iuoWebsphere.uf_request_footer(lsXML)

w_main.setMicroHelp("Updating Warehouse Offset times...")

 iuoWebsphere.uf_post_url(lsXML)

ids_project_warehouse = Create datastore 
ids_project_warehouse.dataobject = 'd_project_warehouse'
ids_project_warehouse.SetTransObject(SQLCA)


ll_row= ids_project_warehouse.Retrieve(gs_project)

Return ll_row
end function

public function integer of_set_warehouse_dropdown (ref datawindowchild adw_warehouse);Long	llRowCount, llRowPos, llNewRow

// 04/04 - PCONKL - Load the warehouse dropdown with the user warehouse records

adw_warehouse.REset()
llRowCount = idsuserWarehouse.RowCount()
For llRowPos = 1 to llRowCount
	llNEwRow = adw_warehouse.InsertRow(0)
	adw_warehouse.SetITem(llNewRow,'wh_Code', idsuserWarehouse.GetItemString(llrowPos,'wh_Code'))
	adw_warehouse.SetITem(llNewRow,'wh_Name', idsuserWarehouse.GetItemString(llrowPos,'wh_Name'))
	adw_warehouse.SetITem(llNewRow,'Project_id',gs_project)
Next


Return 0
end function

public function integer of_load_user_warehouse ();Long	llRowCount, llRowPos, llNewRow
String	lsDefWH

// 04/04 - PCONKL - Added abilty to restrict users to warehouses within a project and set default if multiple

If not isvalid(idsUserWarehouse) Then
	idsUserWarehouse = Create Datastore
	idsUserWarehouse.dataobject = 'd_user_warehouse'
//	idsUserWarehouse.SetTransObject(SQLCA)
End iF

idsUserWarehouse.SetTransObject(SQLCA)
idsUSerwarehouse.REset()

//If Super User logged in, we will use currently loaded project warehouse table and check for a default
// 02/08 - PCONKL - Adding "-1" as Super Duper User
If gs_role = '0' or gs_role = '-1' Then
	
	llRowCount = ids_project_warehouse.RowCount()
	For llRowPos = 1 to llRowCount
		llnewRow = idsUserWarehouse.InsertRow(0)
		idsUserWarehouse.SetItem(llNewRow,'wh_code',ids_project_warehouse.GetITemString(llRowPos,'wh_Code'))
		idsUserWarehouse.SetItem(llNewRow,'wh_Name',ids_project_warehouse.GetITemString(llRowPos,'wh_Name'))
	Next
	
Else /*If not Super User, retrieve User Warehouses. If none are present, then we will default to all of the project level warehouses*/
	
	llRowCOunt = idsUserWarehouse.Retrieve(gs_project, gs_userID)
	If llRowCount = 0 Then
		
		llRowCount = ids_project_warehouse.RowCount()
		For llRowPos = 1 to llRowCount
			llnewRow = idsUserWarehouse.InsertRow(0)
			idsUserWarehouse.SetItem(llNewRow,'wh_code',ids_project_warehouse.GetITemString(llRowPos,'wh_Code'))
			idsUserWarehouse.SetItem(llNewRow,'wh_Name',ids_project_warehouse.GetITemString(llRowPos,'wh_Name'))
		Next
		
	End If
	
End If

//See if we have a default
Select wh_code into :lsDefWH
From User_Warehouse
Where Project_id = :gs_project and Userid = :gs_USerID and default_wh_ind = 'Y';
	
If lsDefWH > '' Then
	gs_default_wh = lsDefWH
End IF

Return 0
end function

public subroutine of_setmenu (boolean as_value);////This function set the menu toolbar called by activate & deactivate event
//IF ISVALID(w_main) THEN 
//	IF as_value THEN
//		IF Not IsValid(w_main.GetActiveSheet()) THEN	w_main.toolbarvisible = as_value			
//	ELSE		
//		w_main.toolbarvisible = as_value
//	END IF
//END IF	
// im_menu.m_utilities.m_4geminiplug.Enabled = as_value
end subroutine

public function integer of_load_project_dropdowns ();// of_load_project_dropdowns

// 04/04 - PCONKL - Load Project level dropdowns and shared DS's into shared pool

//Load Carriers
If not isvalid(ids_dddw_carrier) Then
	ids_dddw_carrier = Create DAtastore
	ids_dddw_carrier.Dataobject = 'dddw_carriers'
	ids_dddw_carrier.SetTransObject(SQLCA)
End If

ids_dddw_carrier.Retrieve(gs_PRoject)

//TimA 02/24/12 OTM Project
//Check if is OTM enabled
If g.is_OTM_Enable_Ind = 'Y' Then
	//Pandora wants this dddw to limit to list but we need a way for them to choose a Null value is needed
	If gs_PRoject = 'PANDORA' then
		ids_dddw_carrier.insertrow(1)
	End if
End if
//Load COO Translate (3COM)
If not isvalid(ids_coo_translate) Then
	ids_coo_translate = Create DAtastore
	ids_coo_translate.Dataobject = 'd_ds_coo_translate'
//	ids_coo_translate.SetTransObject(SQLCA)
End If

ids_coo_translate.SetTransObject(SQLCA)
ids_coo_translate.Retrieve(gs_PRoject)

//Load Item Serial Prefix (3COM & Powerwave)
If not isvalid(ids_item_serial_Prefix) Then
	ids_item_serial_Prefix = Create DAtastore
	ids_item_serial_Prefix.Dataobject = 'd_ds_item_serial_Prefix'
//	ids_item_serial_Prefix.SetTransObject(SQLCA)
End If

ids_item_serial_Prefix.SetTransObject(SQLCA)
ids_item_serial_Prefix.Retrieve(gs_PRoject)

//Load Country Table
If not isvalid(ids_Country) Then
	ids_Country = Create DAtastore
	ids_Country.Dataobject = 'd_ds_Country'
//	ids_Country.SetTransObject(SQLCA)
End If

ids_Country.SetTransObject(SQLCA)
ids_Country.Retrieve()

// pvh - 02/06/2006
// 01/07 - PConkl - Only load for 3COM
If not isvalid( idsSuppliers ) Then
	idsSuppliers = f_datastoreFactory( 'd_supplier_list_by_project' )
End If

//If gs_project = '3COM_NASH' Then	
//	idsSuppliers.retrieve( gs_project )
//End If

// pvh - 08/18/06
if not isvalid( idsFunctionRights ) then
	// gets retrieved after the user logs in.
	idsFunctionRights = f_datastoreFactory( 'd_function_rights_by_proj_user' )
end if

idsFunctionRights.SetTransObject(SQLCA)		

REturn 0
end function

public function integer of_check_label (datawindow adw);// THis function will load user defined column labels
// 07/04 - PCONKL - Will also set column to required if necessary

String ls_setting,ls_object,ls_label,ls_Column_Name,ls_syntax, lsCrap, lsDescribe, lsrc
String ls_invisible
long ll_rtn,ll_row,ll_foundrow
string ls_values
string ls_radio_button_list
DWObject ldw_object

ll_foundrow = 1


IF ids_columnlabel.Rowcount() > 0 THEN
	
	//CHECK IF COLUMN LABELS ARE NOT BLANK OR INVISIBLE
     ls_syntax=  "upper(datawindows) = '"+upper(string(adw.DataObject))+ "' and (column_label <> " + "'' or Required_ind = 'Y' or invisible = 'Y')"

		

		
   FOR ll_row = 1 TO ids_columnlabel.Rowcount()
		
		ll_foundrow = ids_columnlabel.Find(&
		ls_syntax,&
		ll_foundrow, ids_columnlabel.RowCount()) 				
		
		IF ll_foundrow > 0 THEN
			
			ls_label=ids_columnlabel.object.column_label[ll_foundrow] /*user defined label*/
			ls_Column_Name=lower(ids_columnlabel.object.Column_Name[ll_foundrow]) /*Column_Name*/
			ls_setting = ls_Column_Name + "_t.text" /*modification to column name*/
			
		
	
			// If it's a checkbox
			lsDescribe = ls_Column_Name + ".checkbox.text"
			lsCrap = adw.Describe(lsDescribe)
			
			If lsCrap <> '?' Then
				ls_setting = ls_Column_Name + ".checkbox.text ='" + ls_label + "'"
				adw.Modify(ls_setting)
			End If
	

			// If it's a radio button
			lsDescribe = ls_Column_Name + ".RadioButtons.LeftText"
			
			lsCrap = trim(adw.Describe(lsDescribe))
			
			If lsCrap <> '!' AND lsCrap <> '?'  Then
				

				ls_values = adw.Describe(ls_Column_Name + ".Values")

				ls_radio_button_list = trim(ids_columnlabel.object.column_name_value[ll_foundrow] )

				long ll_pos
				
				ll_pos = pos(Upper(ls_values), upper(ls_radio_button_list))
				
				if ll_pos > 0 then
					
					ls_values = left(ls_values, ll_pos - 1) + ls_label + mid(ls_values, ll_pos + len(ls_radio_button_list))
					
				end if

			
				ls_setting =adw.Modify(ls_Column_Name + ".Values='"+ls_values+"'")
				adw.Modify(ls_setting)
				
				
			End If
			
	
	
			IF pos(adw.Describe(ls_setting),':') > 0 THEN ls_label += ':'	
		
	
			//Modify Label
			If ls_label > '' and not isnull(ls_label) and Trim(ls_label) <> ':' Then
				
				
				//Temp

				ls_setting = ls_Column_Name + ".text ='" + ls_label + "'"
				
				adw.Modify(ls_setting)	
				
				ls_setting = ls_Column_Name + "_t.text ='" + ls_label + "'"
				
				adw.Modify(ls_setting)
			End IF
			

			
			//Set Field to required and set label to bold and Underlined
			If ids_columnlabel.getITemString(ll_foundrow,'Required_Ind') = 'Y' Then
				
				
				ls_setting = ls_Column_Name + "_t.font.weight = 700 " /*Bold*/
				
				//if not a grid, set heading to underline
				
				ls_setting += ls_Column_Name + "_t.font.underline= yes " /*Underline*/
				
				// If it's a dropdown datawindow, we want t use the dddw.required instead of edit.required (it removes the dropdown otherwise)
				lsDescribe = ls_Column_Name + ".dddw.datacolumn"
				lsCrap = adw.Describe(lsDescribe)
				
				If lsCrap <> '?' Then
					ls_setting += ls_Column_Name + ".dddw.required= yes " /*Required*/
					ls_setting += ls_Column_Name +".dddw.allowedit=no" //5-Mar-2015 Madhu- Added to don't allow to edit dddw list, if it is Req=Y.
				Else
					ls_setting += ls_Column_Name + ".edit.required= yes" /*Required*/
				End If
				
				lsrc = adw.Modify(ls_setting)
			
				
			End If /*required*/
			
			//GailM - 2/17/2015 - Set Field to invisible if field is 'Y'
			If ids_columnlabel.getITemString(ll_foundrow,'Invisible') = 'Y' Then
				ls_invisible = ls_Column_Name + "_t.visible = false "
				lsrc = adw.Modify(ls_invisible)
				ls_invisible = ls_Column_Name + ".visible='0' "
				lsrc = adw.Modify(ls_invisible)
			End If

			//08-Aug-2014 : Madhu- Added code to update Case Type value - START
			ls_setting = ls_Column_Name +".Edit.Case ='"+ ids_columnlabel.getItemString( ll_foundrow,'case_type') +"'"
			lsrc =adw.Modify(ls_setting)
			//08-Aug-2014 : Madhu- Added code to update Case Type value - END			
			
			ll_foundrow++ //Just to search from the next find row
			
		Else
			
			EXIT
			
		END IF	
		
	NEXT				
	
END IF

return ll_rtn
end function

public function string of_get_project_ind ();
string ls_project_ind, lsCCC
string lsTNT, lsfwdPick, lsTrax, lsDupDO, lsSyncPack, lsETAMaint, lbCartonSerial, lsDupRo, lsReadyInd, lsScanAll, lsWebsphereGI, lsWebsphereGR, lsMobileEnabled, &
		lsAllowQuantityDecimals, lsAllowInvTypeChangeOnTransfers, lsUseHazardousTable,lsPreventAirCarrierforHazardous,lsCommodityAuthorizedUser, &
		lsReceivePutawaySerialRollUpInd
		
datastore lds
// pvh - 02/01/06
string lsRIndicator
string sSNChainOfCustody = 'N'
w_main.SetMicroHelp("Loading Project information...")

// pvh - 09/18/06 - added bol, pack, pick print dataobjects to project table.
string lsBolPrintdo, lsPickPrintdo, lsPackPrintdo
//TimA 01/04/12 OTM Project
//Added OTM indicator
Select ownership_managed_ind, gemini_Ind, Standard_of_Measure_Default, coo_managed_ind,
		wh_code,delivery_pick_sort_Order, over_pick_ind, Batch_pick_ind, Alt_supplier_pick_ind, scanner_ind,
		in_sku_list_ind, gen_pack_list_carton_no_ind, ccc_enabled_Ind, shipment_enabled_Ind, forward_pick_ind, 
		alt_sku_pick_ind, Trax_enable_Ind, delivery_detail_change_ind,receive_detail_change_ind, allow_dup_do_numbers_ind, user_field1,
		validate_putaway_ind, Receipt_BAckorder_Ind, Delivery_BackOrder_Ind, bol_print_dw,picking_print_dw,packing_print_dw, Pack_Carton_Sync_Ind,
		ETA_Calc_Mnt_Ind, Carton_serial_Req_Ind, allow_dup_ro_numbers_ind, enable_ready_ind, scan_all_orders_ind, OTM_Delivery_Order_Send_Ind, 
		OTM_Delivery_Order_Receive_Ind, OTM_Item_Master_Send_Ind,enable_otm_ind, SN_Chain_of_Custody, Copy_Lot_No_to_Packlist,
		OTM_check_outbound_column_changes, OTM_Inbound_Order_Send_Ind, Send_Websphere_GI_Ind, Send_Websphere_GR_Ind, mobile_enabled_Ind, Quantity_Decimal_Ind,
		Allow_Inv_Type_Chg_on_Transfers_Ind, Use_Hazardous_Table_Ind,Prevent_Air_Carrier_for_Hazardous_Ind,Commodity_Authorized_User_Ind, Receive_Putaway_Serial_Rollup_Ind

Into	:is_owner_ind, :is_gemini_ind, :is_std_mesure, :is_coo_ind,:gs_default_wh, :is_pick_sort_Order,
		:is_allow_overpick, :is_allow_batch_pick, :is_allow_alt_supplier_pick, :is_scanner_ind,
		:is_in_sku_list_ind, :is_Unique_Pack_CartonNumbers, :lsCCC, :lsTNT, :lsfwdPick, 
		:is_allow_alt_sku_pick, :lsTrax, :is_dd_change_enabled,:lsRIndicator, :lsDupDo, :isProjectUserField1, 
		:isValidatePutaway, :isReceiptBackorder, :isDEliveryBackorder,:lsBolPrintdo, :lsPickPrintdo,:lsPackPrintdo, :lsSyncPack,
		:lsETAMaint, :lbCartonSerial, :lsDupRo, :lsReadyInd, :lsScanAll, :is_OTM_Delivery_Order_Send_Ind,
		:is_OTM_Delivery_Order_Receive_Ind, :is_OTM_Item_Master_Send_Ind, :is_OTM_Enable_Ind, :sSNChainOfCustody, :isCopy_Lot_No_to_Packlist,
		:isOTMCheckOutboundChanges, :isOTMSendInboundOrder, :lsWebsphereGI, :lsWebsphereGR, :lsMobileEnabled, :lsAllowQuantityDecimals,
		:lsAllowInvTypeChangeOnTransfers , :lsUseHazardousTable,:lsPreventAirCarrierforHazardous,:lsCommodityAuthorizedUser, :lsReceivePutawaySerialRollUpInd

From	Project
Where Project_id = :gs_Project;

// pvh - 09/18/06 - added bol, pack, pick print dataobjects to project table.
setBolPrintDo( lsBolPrintdo )
setPackPrintDo( lsPackPrintdo )
setPickPrintDo( lsPickPrintdo )
//

// pvh - 02/01/06
setReceiveDetailChangeInd( lsRIndicator )


// 05/04 - PCONKL - Project level Shipment Track & Trace enabled
If lsTNT = 'Y' Then
	ibTNTEnabled = True
Else
	ibTNTEnabled = False
End If

// 04/05 - PCONKL - Project level Forward Pick enabled
If lsfwdPick = 'Y' Then
	ibforwardpickenabled = True
Else
	ibforwardpickenabled = False
End If

// 10/05 - PCONKL - Project level TRAX enabled
If lsTrax = 'Y' Then
	ibTraxenabled = True
Else
	ibTraxenabled = False
End If

If lsDupDO = "Y" THen
	ibAllowDupDeliveryOrderNumbers = True
Else
	ibAllowDupDeliveryOrderNumbers = False
End IF

//MA - Added 5/19/2009

IF lsDupRo = "Y" THEN
	ibAllowDupReceiveOrderNumbers = True
ELSE	
	ibAllowDupReceiveOrderNumbers = False
END IF

If lsSyncPack = 'N' Then
	ibSyncPackCarton = False
Else
	ibSyncPackCarton = True
End If

// dts - 04/06/07 - Added db switch for ETA Maintenance
If lsETAMaint = 'Y' Then
	ibETAMaintEnabled = True
Else
	ibETAMaintEnabled = False
End If

// 10/07 - PConkl - determines whether Carton Numbers are required when scanning Outbound serial numbers
If lbCartonSerial = 'Y' Then
	ibcartonserialvalidationrequired = True
Else
	ibcartonserialvalidationrequired = False
End If

// 11/09 - PCONKL - Ready To Ship Button (W_DO) now indicator controlled
If lsReadyInd = 'Y' Then
	ibReadyToShipEnabled = True
Else
	ibReadyToShipEnabled = False
End If

// 11/09 - PCONKL - Scan all Orders Ind
If lsscanAll = 'Y' Then
	ibscanallordersrequired = True
Else
	ibscanallordersrequired = False
End If

//TimA 11/05/12
Select Code_id INTO :gs_method_log_flag from lookup_table where Project_ID = :gs_project and Code_type = 'LOG_Trace';
If isNull(gs_method_log_flag) Then gs_method_log_flag  = 'N'

// cawikholm 07/26/11 - Set Support Unicode here.  May need to add this in project table
IF Upper(gs_project) = 'BABYCARE' THEN
	
	ibSupportUnicode = TRUE
	
ELSE
	
	ibSupportUnicode = FALSE
	
END IF

// 04/04 - PCONKL - Load any globally shared dropdowns
this.of_load_project_dropdowns()

//Populate the project_warehouse table DGM 041001
this.of_project_warehouse()

//04/04 - PCONKL - Need to load User Warehouse Access - will share with Warehouse dropdown in other objects
This.of_load_user_warehouse()

// 2012/06/14 - ET3 - SN Chain of custody processing
IF sSNChainOfCustody = 'Y' THEN
	ibSNChainOfCustody = TRUE
ELSE
	ibSNChainOfCustody = FALSE
END IF

// 04/14 - PCONKL - added Websphere GI/GR Inds
If lsWebsphereGI = 'Y' Then
	ibSendWebsphereGoodsIssue = True
Else
	ibSendWebsphereGoodsIssue = False
End If

If lsWebsphereGR = 'Y' Then
	ibSendWebsphereGoodsReceipt = True
Else
	ibSendWebsphereGoodsReceipt = False
End If

// 09/14 - PCONKL
If lsMobileEnabled = 'Y' Then
	ibMobileEnabled = True
Else
	ibMobileEnabled = False
End If

// LTK 20150115
If lsAllowQuantityDecimals = 'Y' Then
	ibAllowQuantityDecimals = True
Else
	ibAllowQuantityDecimals = False
End If

// LTK 20150824
If lsAllowInvTypeChangeOnTransfers = 'Y' Then
	ibAllowInvTypeChangeOnTransfers = True
Else
	ibAllowInvTypeChangeOnTransfers = False
End If

// LTK 20151030
If lsUseHazardousTable = 'Y' Then
	ibUseHazardousTable = True
Else
	ibUseHazardousTable = False
End If

//31-May-2016 Madhu Added -Prevent Air Carrier for Hazarodus Materials
If lsPreventAirCarrierforHazardous ='Y' Then
	ibPreventAirCarrierforHazardous =True
Else
	ibPreventAirCarrierforHazardous =False
End If

//01-Jun-2016 Madhu Added - Commodity Authorized User for Hazardous Materials
If lsCommodityAuthorizedUser ='Y' Then
	ibCommodityAuthorizedUser =True
Else
	ibCommodityAuthorizedUser= False
End If

//29-Mar-2019 Madhu S31781 F14974 - Putaway Serial RollUp Functionality
If lsReceivePutawaySerialRollUpInd ='Y' Then
	ib_Receive_Putaway_Serial_Rollup_Ind = True
Else
	ib_Receive_Putaway_Serial_Rollup_Ind = False
End If
	
w_main.SetMicroHelp("Ready")

Return ''


end function

public function string uf_build (character arg_3digits[3], string arg_building);//Called from uf_num_to_words

long  l_Digit1,l_Digit2,l_Digit3
String  s_ConvertNum
String s_Ones,s_Teens,s_Tens,s_Num


s_Ones  = "1=One        2=Two        3=Three      4=Four       5=Five       6=Six        7=Seven      8=Eight      9=Nine"
s_Teens = "10=Ten       11=Eleven    12=Twelve    13=Thirteen  14=Fourteen  15=Fifteen   16=Sixteen   17=Seventeen 18=Eightteen 19=Nineteen  "
s_Tens  = "20=Twenty    30=Thirty    40=Forty     50=Fifty     60=Sixty     70=Seventy   80=Eighty    90=Ninety"

l_Digit1 = Long(arg_3digits[1])
l_Digit2 = Long(arg_3digits[2])
l_Digit3 = Long(arg_3digits[3])

//Check for Hundreds 
If l_Digit1 > 0 Then
 s_Num = arg_3digits[1] 
 s_ConvertNum = Trim( Mid( s_Ones, Pos(s_Ones,s_Num+"=")+2 , 9 ) ) + " Hundred "
End If 

//Check for tens 
If l_Digit2 > 1 Then
 s_Num = arg_3digits[2] 
 s_ConvertNum = s_ConvertNum + Trim( Mid( s_Tens, Pos(s_Tens,s_Num+"0=")+3 , 9 ) )
 If l_Digit3 > 0 Then
  s_Num = arg_3digits[3]
  s_ConvertNum = s_ConvertNum + "-" + Trim( Mid( s_Ones, Pos(s_Ones,s_Num+"=")+2 , 9 ) )
 End If 
ElseIf l_Digit2 = 1 Then
 s_Num = arg_3digits[2] + arg_3digits[3]
   s_ConvertNum = s_ConvertNum + Trim( Mid( s_Teens, Pos(s_Teens,s_Num+"=")+3 , 9 ) ) 
ElseIf l_Digit3 > 0 Then
 s_Num = arg_3digits[3]
 s_ConvertNum = s_ConvertNum + Trim( Mid( s_Ones, Pos(s_Ones,s_Num+"=")+2 , 9 ) ) 
End If 

s_ConvertNum = trim(s_ConvertNum)
If Len(s_ConvertNum) > 0 Then
 s_ConvertNum = s_ConvertNum + " " + arg_building + " " 
End If

RETURN s_ConvertNum

end function

public function string uf_num_to_words (decimal arg_num_to_convert);//Convert a number into the word equivelent

String  s_ConvertNum, s_cents,s_Number

//absolute value of a number.
arg_num_to_convert = ABS( arg_num_to_convert )

s_Number = String ( arg_num_to_convert, "000000000000000.00" )

s_ConvertNum = s_ConvertNum + &
       uf_Build( Mid(s_Number,1,3), "Trillion" )

s_ConvertNum = s_ConvertNum + &
       uf_Build( Mid(s_Number,4,3), "Billion" )

s_ConvertNum = s_ConvertNum + &
       uf_Build( Mid(s_Number,7,3), "Million" )

s_ConvertNum = s_ConvertNum + &
       uf_Build( Mid(s_Number,10,3), "Thousand" )

s_ConvertNum = s_ConvertNum + &
       uf_Build( Mid(s_Number,13,3), "" )

//Convert decimal to string 
s_cents = Right(s_Number, 2 ) 

If s_ConvertNum = "" Then
    s_ConvertNum = "Zero"
End If

s_ConvertNum = Trim(s_ConvertNum)+ " and " + s_cents + "/100 "

RETURN s_ConvertNum

end function

public function integer uf_send_email (string asdistriblist, string assubject, string astext, string asattachments);String	lsDistribList,	lsTemp, 	lsOutPut, lsReturn, lsCommand, lsAttachments, lsSubject
			
Long		llArrayPos


// 03/05 - PCONKL - Changed to use BLAT batch commands instead of going through Outlook.


//Get the Distrib LIst, replace any semi colons with commas
lsDistribList = asDistribList

Do While Pos(lsDistribList,';') > 0
	lsDistribList = Replace(lsDistribList,Pos(lsDistribList,';'),1,',')
Loop

If isNull(lsDistribList) or lsDistribList = ''  Then
	Return 0
End If

//Create the command line prompt
lsCommand = "blat -"

//Add From
//17-Nov-2015 :Madhu- Replaced "menloworldwide" by "xpo"
lsCommand += ' -f "SIMS WMS <simssweeperSA@xpo.com>" '

//Add Subject
lsSubject = assubject 
lsCommand += ' -s "' + lsSubject + '"'

//add dist list
lsCommand += ' -t "' + lsDistribList + '"'

//supress + servername
lsCommand += " -q -noh2 -server mailhost.cnf.com "


//Body of Message
lsCommand += ' -body "' + asText + '"'

//Any attachments...
lsAttachments = asAttachments

Do While Pos(lsAttachments,';') > 0
	lsAttachments = Replace(lsAttachments,Pos(lsAttachments,';'),1,',')
Loop

If lsAttachments > '' Then
	lsCommand += " -attach " + lsAttachments
End If


//Send the message
Run(lsCommand, minimized!)


Return 0
end function

public subroutine setcurrentwarehouse (string aswhcode);// setCurrentWarehouse( string asWHCode )
if isNull( asWHCode ) then asWHCode = ''
isCurrentWarehouse = Upper( asWHCode )

end subroutine

public function string getcurrentwarehouse ();// string = getCurrentWarehouse( )
return isCurrentWarehouse

end function

public function datetime of_getworldtime ();// datetime = of_getWorldTime()

// return the world time based on the warehouse and GMT offset
return f_getLocalWorldTime( g.getcurrentwarehouse() )


end function

public subroutine setlastoffset (integer avalue);// setLastOffset( int avalue )
iiLastOffset = avalue

end subroutine

public function integer getlastoffset ();// int = getLastOffset()
return iiLastOffset

end function

public subroutine setwarehousedata ();// setWarehousedata()

decimal{2} liOffset
string lsDSTFlag
string lsWarehouse
datetime dststarts
datetime dstends
string findthis
long foundrow

//09/14 - PCONKL - added timezone

lsWarehouse = getCurrentWarehouse()

if ids_project_warehouse.rowcount() > 0 then
	findthis = "Upper( wh_code )  = '" + lsWarehouse + "'"
	foundrow = ids_project_warehouse.find( findthis, 1, ids_project_warehouse.rowcount() )
	if foundrow > 0 then
		lioffset = ids_project_warehouse.object.gmt_offset[ foundrow ]
		lsDSTFlag = ids_project_warehouse.object.dst_flag[ foundrow ]
		dststarts = ids_project_warehouse.object.dylght_svngs_time_start[ foundrow ]
		dstends = ids_project_warehouse.object.dylght_svngs_time_end[ foundrow ]
		isWarehouseTimezone = ids_project_warehouse.object.timezone[ foundrow ]
	end if
else
	SELECT dbo.Warehouse.GMT_Offset,   
			 dbo.Warehouse.DST_Flag,
                dbo.Warehouse.Dylght_svngs_time_start,   
                dbo.Warehouse.Dylght_svngs_time_end, 
			dbo.Warehouse.Timezone 
	INTO :lioffset,:lsDSTFlag,:dststarts, :dstends , :isWarehouseTimezone 
	FROM dbo.Warehouse
	WHERE wh_code = :lsWarehouse ;
end if

if isNull( liOffset ) then liOffset = 0
setGMTOffset( liOffset )

if isNull( lsDSTFlag ) then lsDSTFlag = 'N'
setDSTFlag( lsDSTFlag )

if NOT isNull( dstStarts ) then setDSTStarts( dststarts )
if NOT isNull( dstEnds ) then setDSTEnds( dstEnds )



end subroutine

public subroutine setlastwarehouse (string aswarehouse);// setLastWarehouse( string aswarehouse )
isLastWarehouse = aswarehouse

end subroutine

public function string getlastwarehouse ();// string = getlastwarehouse()
return isLastWarehouse

end function

public subroutine setdststarts (datetime _value);// setDSTStarts( datetime _value )

if NOT isNull( _value ) then
	idtDSTStarts = _value
end if

end subroutine

public subroutine setdstends (datetime _value);// setDSTEnds( datetime _value )

if NOT isNull( _value ) then
	idtDSTEnds = _value
end if

end subroutine

public function datetime getdststarts ();// datetime = getDSTStarts()
return idtDSTStarts

end function

public function datetime getdstends ();// datetime = getDSTEnds()
return idtDSTEnds

end function

public subroutine setdstflag (string _value);// setDSTFlag( string _value )

if isNull( _value ) or len( _value ) = 0 then _value = 'N'

isDSTFlag = _value

end subroutine

public function string getdstflag ();// string = getDSTFlag()
return isDSTFlag

end function

public subroutine setgmtoffset (decimal avalue);// setGMTOffset( decimal avalue )

if isNull( avalue ) then avalue = 0
idOffset = avalue

end subroutine

public function decimal getgmtoffset ();// decimal = getGMTOffset()
return idOffset

	

end function

public subroutine setreceivedetailchangeind (string _value);// setReceiveDetailChangeInd( string _value )

if isNull( _value ) or len( _value ) = 0 then _value = 'Y'  // Y is default

isReceiveDetailChangeInd = _value

end subroutine

public function string getreceivedetailchangeind ();// string = getReceiveDetailChangeInd()
return isReceiveDetailChangeInd

end function

public function datastore getsupplierds ();// datastore = getSupplierDS()

return idsSuppliers

end function

public function datastore getcountryds ();// datastore = getCountryds()
return ids_Country

end function

public subroutine doprojectwarehouserefresh ();// doProjectWarehouseRefresh()

// refresh the project warehouse datastore
ids_project_warehouse.Retrieve(gs_project)
end subroutine

public subroutine dorefreshsupplierds ();// doRefreshSupplierds()
idsSuppliers.retrieve( gs_project )

end subroutine

public function integer getprojectappteminatetime ();// int = getProjectAppTeminateTime()
//
// pvh - 05/01/06 - Idle
//
return projectAppTeminateTime

end function

public subroutine setprojectidletime (integer _seconds);// setProjectIdleTime( int _seconds )
//
// pvh - 05/01/06 - Idle
//
int seconds

// if the parameter is null, see if the value exists in the db.
if isNull( _seconds ) or _seconds = 0 then
	
	select idle_event_seconds
	into :seconds
	from project
	where project_id = :gs_project;
	
	if sqlca.sqlcode <> 0 or isNULL( seconds ) or seconds = 0 then
		projectIdleTime = 14400   // set as default, 4 hours 
	else
		projectIdleTime =  seconds 
	end if
else
	projectIdleTime = _seconds
end if

end subroutine

public function integer getprojectidletime ();// getProjectIdleTime()
//
// pvh - 05/01/06 - Idle
//
return projectIdleTime

end function

public subroutine setprojectappterminatetime (integer _minutes);// setProjectAppTerminateTime( int _minutes )
//
// pvh - 05/01/06 - Idle
//
int minutes

// if the parameter is null, see if the value exists in the db.
if isNull( _minutes ) or _minutes = 0 then
	select app_termination_minutes
	into :minutes
	from project
	where project_id = :gs_project;
	
	if isNULL( minutes ) or minutes = 0 then
		projectAppTeminateTime = 15   // set as default
	else
		projectAppTeminateTime=  minutes 
	end if
else
	projectAppTeminateTime = _minutes
end if


end subroutine

public function long dofunctionrightsretrieve ();// long = doFunctionRightsRetrieve(  )

if isNull( gs_project ) or len( Trim( gs_project ) ) = 0 then return -1
if isNull( gs_userid ) or len( Trim( gs_userid ) ) = 0 then return -1

return idsFunctionRights.Retrieve( gs_project, gs_userid )

end function

public function boolean getfunctionrights (string process, string action);// boolean = getFunctionRights( string process, string action )

string findProcess = "processid = '"
string findQuote = "' "
string findThis
long findRow
string actionCol
string rights

if isNull( process ) or len( process ) = 0 then return true

findthis = findProcess + trim( process ) + findQuote
findRow = idsFunctionRights.find( findThis, 1, idsFunctionRights.rowcount()  )
if findRow <= 0 then return false

choose case Upper( action )
	case 'E', ''
		actionCol = 'edit'
	case 'S'
		actionCol = 'save'
	case 'D'
		actionCol = 'delete'	
	case 'N'
		actionCol = 'new'
	case 'C'
		actionCol = 'confirm'
	//JxLim 04/13/2010 Change case from 'N' to 'I' for adding new record to handle not super user role. 
	//Also added case else to for value other than the available case value.
	case 'I'
		actionCol = 'new'		
	case Else
		Return False
end choose

rights = idsFunctionRights.getItemString( findrow, actionCol )

//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
//a. If Ops had access only for "Fixed Invalid Serial Number", allow to Adjustment screen and make only "Serail Reconcile" adjustment type

if rights = '1' then 
	return true
elseIf upper(gs_project) ='PANDORA' and upper(process) ='W_ADJ' then
	findthis = findProcess + 'S_TAB' + findQuote+" and edit='1'"
	findRow = idsFunctionRights.find( findThis, 1, idsFunctionRights.rowcount()  )
	IF findRow > 0 Then
		gbSerialReconcileOnly =TRUE
		return true
	End If
end if
//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END

return false

end function

public subroutine setbolprintdo (string value);// setBOLPrintDo( string value )

if isNull( value ) then value = ''

isBOLPrintDo = value

end subroutine

public subroutine setpickprintdo (string value);// setPickPrintDo( string value )

if isNull( value ) then value = ''

isPickPrintDo = value

end subroutine

public subroutine setpackprintdo (string value);// setPackPrintDo( string value )

if isNull( value ) then value = ''

isPackPrintDo = value

end subroutine

public function string getbolprintdo ();// string = getBolPrintDo()
return isBolPrintDo

end function

public function string getpackprintdo ();// string = getPackPrintDo()
return isPackPrintDo

end function

public function string getpickprintdo ();// string = getPickPrintDo()
return isPickPrintDo

end function

public function integer of_check_label_button (graphicobject a_graphicobject);// THis function will load userbutton text
// 07/04 - PCONKL - Will also set column to required if necessary

String ls_setting,ls_object,ls_label,ls_Column_Name,ls_syntax, lsCrap, lsDescribe, lsrc, lsName
long ll_rtn,ll_row,ll_foundrow
commandbutton lb_button 
statictext lst_statictext
checkbox lcb_checkbox
radiobutton lrb_radiobutton
groupbox lgb_groupbox
picturebutton lpb_picturebutton

ll_foundrow = 1

a_graphicobject.typeof()

lsName = a_graphicobject.ClassName()

IF ids_columnlabel.Rowcount() > 0 THEN
	
	//CHECK IF COLUMN LABELS ARE NOT BLANK
     ls_syntax=  "upper(datawindows) = '"+upper(lsName)+ "' and (column_label <> '')"
	  
		ll_foundrow = ids_columnlabel.Find(&
		ls_syntax,&
		ll_foundrow, ids_columnlabel.RowCount()) 				

	IF ll_foundrow > 0 THEN
				
		ls_label= ids_columnlabel.GetItemString( ll_foundrow, "column_label")
		
		ids_columnlabel.object.column_label[ll_foundrow] /*user defined label*/
	
		choose case a_graphicobject.typeof()
				
		case commandbutton!
				
			lb_button = a_graphicobject
			
			lb_button.text = ls_label

		case picturebutton!
				
			lpb_picturebutton = a_graphicobject
			
			lpb_picturebutton.text = ls_label
	
		
		case statictext!
	
			
			lst_statictext = a_graphicobject
			
			lst_statictext.text = ls_label
		
		case checkbox!
	
			
			lcb_checkbox = a_graphicobject
			
			lcb_checkbox.text = ls_label
		
		case radiobutton!
	
			
			lrb_radiobutton = a_graphicobject
			
			lrb_radiobutton.text = ls_label		
		
		case groupbox!
			

			lgb_groupbox = a_graphicobject
			
			lgb_groupbox.text = ls_label		


		end choose
	
	END IF

	
END IF	

return ll_rtn
end function

public function integer uf_post_connect_open ();Long	llRC



// 08/00 Pconkl - open splash screen
//Open(w_sims_splash)

// 04/12 - PCONKL - Logging in with NT credentials  before connecting to DB - moving to new function - uf_post_connect_open

//connect using sqlca;
llRC = of_Connect_to_db()
SetPointer (Arrow!)

IF llRC <> 0 THEN
	MessageBox ("Sorry! Cannot Connect to Database", sqlca.sqlerrtext)
	Halt close
	Return -1
END IF

gb_sqlca_connected = TRUE

// 04/13 - PCONKL - Connect to the Replicated server as well. If unable to connect, we won't attempt to run reports against it
llRC = uf_connect_to_replication_db()
If llRC = 0 Then
	gb_replication_sqlca_connected = True
Else
	gb_replication_sqlca_connected = False
End If


// 10/05 - PCONKL - Load App server settings
of_Connect_To_AppServer()

//TimA 06/08/15  Set the SIMS defaults now found in new table.
of_set_sims_defaults()

today = Today()

// 12/00 PCONKl - initialize reports by project datastore
ids_reports = Create Datastore
ids_reports.dataobject = 'd_project_reports'
ids_reports.SetTRansObject(SQLCA)

w_main.idsReportDetail.settransobject( sqlca ) /* 05/12 - PCONKL - initialized in w_main but now not connecting to DB at that point*/

//set helpfile
If gs_sysPath > '' Then
	is_HelpFile = gs_sysPath + "Simshelp.hlp"
Else
	is_helpfile = "Simshelp.hlp"
End If

//Set the server/database on the frame title bar
gstitle = 'SIMS  Database: '+ sqlca.servername + '/' + sqlca.database 
iw_frame.Title = gstitle

//Close(w_sims_splash)

return 1


end function

public function integer uf_logout ();DateTime	ldtLogout

//10/04 - PCONKL - Update the user log record with the logout time
ldtLogout = DateTime(today(),Now())
		
Execute Immediate "Begin Transaction" Using SQLCA;
		
Update User_login_history
Set logout_time = :ldtLogout
Where Project_id = :gs_Project and UserID = :gs_userid and login_time = :g.idt_USer_Login_Time
Using SQLCA;
		
Execute Immediate "COMMIT" using SQLCA;
		
gs_userid = ""

//04/12 - PCONKL - Disconencting from DB after logoff - we may be connecting to a different system
Disconnect using SQLCA;

gsTitle = "SIMS ** Not connected to database **"
iw_frame.Title = gsTitle

// 04/13 - PCONKL - Also disconnect from Replicated DB
Disconnect using Replication_SQLCA;

Return 0
end function

public function integer uf_set_dw (ref datawindow adw_name, ref string avalues[]);//////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION:		Sets a custom datawindow setting based on values from the Custom_Datawindow table.  Will re-arrange the columns based on the settings in the table.
// 
// ARGUMENTS:			dw_object, string[] aray
//
// RETURNS:			Int
//
//  Original Author: TimA
//
// MODIFICATIONS:
// Date			Who	Purpose			
// ------	----	-------
// 07/21/14		TimA  Added addtional code to set color of font
// 07/28/14		TimA Add code to be the backcolor
///////////////////////////////////////////////////////////////////////////////////	
String NewCol[],  NewWidth[],New_col_name,New_width_str, src, mod_str, col_name, disp_order, width_str, temp_str, tmp, tmp1,ls_syntax
String lsText_Color_Exp, font_str, ftmp //Font Color
String lsBack_Color_Exp, Back_str, btmp //BackColor
Long llRtn,llRowPos,X,ll_foundrow, liColCount
Integer ii, position, width_pos
Integer font_pos //Font
Integer Back_Pos //Back
String lstest
ii=1

adw_name.SetReDraw(FALSE)
//Get the list of new column sort order
ls_syntax=  "Custom_Datawindow_No = " + String(il_DataWindowNo) +   " and Datawindow = '"+ string(adw_name.DataObject) + "'" //and (column_label <> " + "'' or Required_ind = 'Y')"

//ls_syntax=  "Datawindow = '"+ string(adw_name.DataObject) + "'" //and (column_label <> " + "'' or Required_ind = 'Y')"
//Set the sort order
ids_Custom_dw.setsort("#1 A, #2 A,#3A,#5 A")
 //  FOR ll_row = 1 TO ids_Custom_dw.Rowcount()
		
//ll_foundrow = ids_Custom_dw.Find(ls_syntax,	ll_foundrow, ids_columnlabel.RowCount()) 				
ids_Custom_dw.SetFilter(ls_syntax)
ids_Custom_dw.filter( )

//TimA 07/22/14 added code for Font and Background colors			
For X = 1 to ids_Custom_dw.RowCount( )
	New_col_name =  New_col_name + ids_Custom_dw.Getitemstring(X,'Column_Name')
	New_width_str= New_width_str + String(ids_Custom_dw.GetitemNumber(X,'column_width' ) ) 
	lsText_Color_Exp= lsText_Color_Exp + Nz(String(ids_Custom_dw.GetitemString(X,'text_color_expression' ) ) ,'' )
	lsBack_Color_Exp= lsBack_Color_Exp + Nz(String(ids_Custom_dw.GetitemString(X,'back_color_expression' ) ) ,'' )

	If X < ids_Custom_dw.RowCount() then
	New_col_name =  New_col_name + ","
	New_width_str= New_width_str + ","
	lsText_Color_Exp= lsText_Color_Exp + ";" //Separate the values with a semi-colon instead of coma
	lsBack_Color_Exp= lsBack_Color_Exp + ";"  //Separate the values with a semi-colon instead of coma

	End if
Next
if New_col_name > "" then 
	avalues[ii ] = avalues[ii ] + " DORDER-" + New_col_name
end if
if New_width_str > "" then 
	avalues[ii ] = avalues[ii ] + " WIDTH-" + New_width_str
end if

If lsText_Color_Exp > '' Then
	//Expression for Font Color.  Normally in the datawindow you would put an expression in the "Text Color" expression box on the DW.
	//This way you can capture that in the database and pass it below in the modify command.
	avalues[ii ] = avalues[ii ] + " FONTCOLOR-" + lsText_Color_Exp
lstest=''
End if

If lsBack_Color_Exp > '' Then
	//Expression for back Color.  Normally in the datawindow you would put an expression in the "Background Color" expression box on the DW.
	//This way you can capture that in the database and pass it below in the modify command.
	avalues[ii ] = avalues[ii ] + "BACKCOLOR-" + lsBack_Color_Exp
lstest=''
End if

//Clear the filter
ids_Custom_dw.SetFilter("")
ids_Custom_dw.filter( )

mod_str = ""
src = ""
col_name = ""
disp_order = ""
width_str = ""
ftmp  = ""
btmp  = ""
position = POS(avalues[ii ], "DORDER-")
width_pos = POS(avalues[ii ], "WIDTH-")
font_pos = POS(avalues[ii ], "FONTCOLOR-")
back_pos = POS(avalues[ii ], "BACKCOLOR-")
			
if position > 0 then
	col_name = Left(avalues [ii ], ( position - 1 ) ) //This is the original column names up to DORDER-
	if width_pos = 0 then
		disp_order = Mid ( avalues [ii ] , ( position + 7 ) )
	else
		disp_order = Mid(avalues [ii ], ( position + 7 ) , (width_pos - (position + 7 ) ) )
		width_str = Mid(avalues [ii ], (width_pos + 6 ),  (font_pos - (width_pos + 6 ) ) )
	end if
	If font_pos > 0 Then
		//Capture the values in the table Custom_Datawindow_Detail field Text_Color_Expression.
		//Note: This is were you can put If conditions based on the column change_color_ind in the d_do_results screen.
		font_str = Mid(avalues [ii ], (font_pos + 10 ),  (back_pos - (font_pos + 10 ) ) )
	End if
	If back_pos > 0 Then
		//Capture the values in the table Custom_Datawindow_Detail field Back_Color_Expression.
		//Note: This is were you can put If conditions based on the column change_color_ind in the d_do_results screen.
		back_str = Mid(avalues [ii ], (back_pos + 10 ) )
	End if
end if
			/*
				if disp_order > "" that means it is a Grid datawindow and
				there is an display order, so turn off all the columns
				and turn it on one by one 
			*/
if disp_order > "" then
				/*
					Turn off all the columns names
				*/
	temp_str = col_name
	DO UNTIL temp_str = ""
		mod_str = RightTrim(LeftTrim(f_get_token(temp_str, "," ) ) ) + ".Visible=0 "
		src = adw_name.Modify(mod_str)
	LOOP

				/*
					Turn on only the displayed columns in order
				*/
	temp_str = disp_order
	//TimA 07/22/14 added Font and Background captures.
	DO UNTIL temp_str = ""
		liColCount++
		//All columns listed in the database will be set yo visible.  Look at next note for making them non visable.
		tmp = RightTrim(LeftTrim(f_get_token(temp_str, "," ) ) )
		mod_str = tmp + ".Visible=1"
		src = adw_name.Modify(mod_str )
		tmp1 = RightTrim(LeftTrim(f_get_token(width_str, "," ) ) )
		if IsNumber(tmp1) then
			//Note: by setting the column with to 0 in the database if will hide the column.
			mod_str = tmp + ".Width=" + tmp1
			src = adw_name.Modify(mod_str)
			mod_str = ""
		end if
		ftmp = RightTrim(LeftTrim(f_get_token(font_str, ";" ) ) )
		If Len ( ftmp ) > 0 then
			//Modify the Font Color based on the value found in the Custom_Datawindow_Detail table
			mod_str = tmp  + '.Color="0~t' + ftmp + '"'
			src = adw_name.Modify(mod_str )
			mod_str = ""
		End if						
		btmp = RightTrim(LeftTrim(f_get_token(back_str, ";" ) ) )
		If Len ( btmp ) > 0 then
			//Modify the Back Color based on the value found in the Custom_Datawindow_Detail table
			mod_str = tmp  + '.background.Mode = 0'  //You have to turn transparency off to set the background color
			src = adw_name.Modify(mod_str )
			mod_str = ""
			mod_str = tmp  + '.background.Color="1073741824~t' + btmp + '"'
			src = adw_name.Modify(mod_str )
			mod_str = ""
		End if						
	
	LOOP
end if

adw_name.SetReDraw(TRUE)
Return(1)
end function

public function integer of_get_custom_dw ();long ll_rtn
string ls_str, ls_template

//ls_str = "TEMPLATE:" + gs_userid
//
//ls_template = ProfileString(gs_inifile,gs_project, ls_str,"")
//
//IF ls_template = "" THEN ls_template = "BASELINE" //Default template for Project
//
//ids_columnlabel = Create datastore
//ids_columnlabel.DataObject = 'd_columnlabel'
//
//IF ids_columnlabel.SetTransObject(SQLCA) < 0 THEN Return -1
//setpointer(Hourglass!)
//w_main.SetMicroHelp("Loading Column Labels...")
//
//ll_rtn=ids_columnlabel.Retrieve(gs_project, ls_template)
//IF ll_rtn <= 0 then //If nothing is returned, try to load the baseline for the project.
//	ids_columnlabel.Retrieve(gs_project, 'BASELINE')
//END IF

//TimA 10/25/12
//TimA 01/15/14 modified the comment to include these instructions.
//NOTE: ***************************************************
//If you are setting up a new datawindow for the first time.  Add a record in the table Custom_Datawindow to represent the datawindow.
//Then read the comments in the function uf_get_dw_values and capture lsSQLInsert statement to insert all the columns from the original structure of the DW.
//*********************************************************
ids_Custom_dw = Create Datastore
ids_Custom_dw.DataObject = 'd_custom_dw'

IF ids_Custom_dw.SetTransObject(SQLCA) < 0 THEN Return -1
	setpointer(Hourglass!)
w_main.SetMicroHelp("Loading Custom Datawindows...")

ll_rtn=ids_Custom_dw.retrieve( gs_project)

w_main.SetMicroHelp("Ready")
SetPointer(Arrow!)
return ll_rtn
end function

public function integer of_set_dw_columns (datawindow adw_name);//////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION:		Looks at the Custom Datawindow table to see if the DW exists for the project.
// 
// ARGUMENTS:			dw_object name
//
// RETURNS:			Int
//
//  Original Author: TimA
//
// MODIFICATIONS:
// Date			Who	Purpose			
// ------	----	-------
// 07/29/14		TimA Cleaned up some comment notes
///////////////////////////////////////////////////////////////////////////////////	
String ls_dwName, lvalues[]
Long llRtn
Integer lrc


String ls_setting,ls_object,ls_label,ls_Column_Name,ls_syntax, lsCrap, lsDescribe, lsrc
long ll_rtn,ll_row,ll_foundrow
string ls_values
string ls_radio_button_list
DWObject ldw_object

ll_foundrow = 1

IF ids_Custom_dw.Rowcount() > 0 THEN
	
    // ls_syntax=  "upper(datawindow) = '"+upper(string(adw_name.DataObject)) //+ "' and (column_label <> " + "'' or Required_ind = 'Y')"

	ls_syntax=  "Datawindow = '"+ string(adw_name.DataObject) + "'" //and (column_label <> " + "'' or Required_ind = 'Y')"
		
	ll_foundrow = ids_Custom_dw.Find(ls_syntax,	ll_foundrow, ids_Custom_dw.RowCount()) 				
		
	IF ll_foundrow > 0 THEN
		il_DataWindowNo = ids_Custom_dw.getitemnumber(ll_foundrow,"Custom_Datawindow_No")
	
		lrc = uf_get_dw_values(adw_name,  lvalues)	
		lrc = uf_set_dw(adw_name, lvalues)					
					
	END IF	
		
	
END IF

return ll_rtn
end function

public function integer uf_get_dw_values (ref datawindow adw_name, ref string avalues[]);//////////////////////////////////////////////////////////////////////////////////
// DESCRIPTION:		Looks at the DW being loaded.  Builds and array of values of all the columns in the DW.
//                                Also builds a script that can be used for an insert statement in the database to input all the columns for the first time.
// 
// ARGUMENTS:			dw_object name, array_values
//
// RETURNS:			Int
//
//  Original Author: TimA
//
// MODIFICATIONS:
// Date			Who	Purpose			
// ------	----	-------
// 07/29/14		TimA Cleaned up some comment notes
///////////////////////////////////////////////////////////////////////////////////	
Integer		ii,	nn, count	
Long			col_no

String		temp_str, tmp,	cols[], col_name , tmpcolor,tmpBackColor, lsBackgroundMode
String lsSQLInsert, lstrCol, lstrWidth
Integer liCount, liWidth
ii=1

avalues[ii] = ""
temp_str = ""
count = 0
//This is used for build the SQL statment to populate Custom_Datawindow_Detail.
//TimA 01/15/14 Added the below comment
//NOTE:****************************************************************
//First put a record in the Custom_Datawindow table to represent the datawindow.
//Then put a breakpoint at the end of this function to capture the SQL string.
//********************************************************************
lsSQLInsert = 'Insert into Custom_Datawindow_Detail (Custom_Datawindow_No,Column_Name,Sort_Sequence_no,Column_Width) ~r'
		/*
			First Get then Normal Column Names
		*/
		ino_of_original_cols = f_dw_get_objects_attrib(adw_name,cols,'column','*','id')
		FOR nn = 1 to ino_of_original_cols
			col_name =  f_get_token(cols[nn],'~n') // get the column name
			tmp = f_get_token(cols[nn],'~n')
			count++
			if temp_str > "" then temp_str = temp_str + ", "
			temp_str = temp_str + col_name
			is_column_original_names[count] = col_name
			if tmp > "" then
				il_col_original_nos[count] = Long(tmp)
			else
				il_col_original_nos[count] = 0
			end if
		NEXT
		/*
			Get all the Computed Column names
		*/
		ino_of_original_cols = f_dw_get_objects_attrib(adw_name,cols,'compute','*','id')
		FOR nn = 1 to ino_of_original_cols
			col_name =  f_get_token(cols[nn],'~n') // get the column name
			count++
			if temp_str > "" then temp_str = temp_str + ", "
			temp_str = temp_str + col_name
			is_column_original_names[count] = col_name
			/*
				Tip: allways the computed column nos are starts from 1001
			*/
			il_col_original_nos[count] = 1000 + nn
		NEXT
		if temp_str > "" then avalues[ii] = temp_str
		/*
			If the datawindow type is Grid then save the display order
			also after the column list
		*/
		temp_str = adw_name.Describe("Datawindow.Table.GridColumns")
		//NOTE: Only columns that are set Visible = 1 will display in the temp_str value.
		if temp_str <> "!" and temp_str<> "?" then
			is_extra_original_str = ""
			is_width_original_str = ""
			ino_of_original_cols = UpperBound(il_col_original_nos)
			DO UNTIL temp_str = ""
				col_no = Long(f_get_token(temp_str, "~t"))
				FOR nn = 1 to ino_of_original_cols
					if col_no = il_col_original_nos[nn] then
						if is_extra_original_str > "" then is_extra_original_str = is_extra_original_str + ", "
						lstrCol =  is_column_original_names[nn]
						liCount  ++
						is_extra_original_str = is_extra_original_str + is_column_original_names[nn]
						if is_width_original_str > "" then is_width_original_str = is_width_original_str + ", "
						tmp = adw_name.Describe(is_column_original_names[nn] + ".Width")
						//Only for testing purposes are we getting the color information.
						tmpcolor = adw_name.Describe(is_column_original_names[nn] + ".Color")
						lsBackgroundMode = adw_name.describe( is_column_original_names[nn] +  '.Background.Mode' ) 
						tmpBackColor= adw_name.Describe(is_column_original_names[nn] + ".Background.Color")

						if IsNumber(tmp) then
							lstrWidth = tmp
							is_width_original_str = is_width_original_str + tmp
						else
							lstrWidth = "0"
							is_width_original_str = is_width_original_str + "-"
						end if
						//Use this lsSQLInsert to add the values to the database.  Only needs to be done on the original setup of the DW.
						//Put a breakpoint at the end of the function to grab this varable.
						lsSQLInsert = lsSQLInsert + "Select " + String(il_DataWindowNo) + "," + "'" + lstrCol +"'," + String(liCount) + "," + lstrWidth + "~r"
						lsSQLInsert = lsSQLInsert + 'UNION ALL ~r'
						EXIT
					end if
				NEXT
			LOOP
	end if 
//Breakpoint here to grab the inset statement that is being built.
Return(1)
end function

public function integer uf_connect_to_replication_db ();// 04/13  - PCONKL - Connect to the replication DB

String	lsServer

Replication_SQLCA = Create Replication_Transaction

Replication_SQLCA.DBMS       = "SNC SQL Native Client(OLE DB)" 

//Assume that login credentials are the same for Replicated server - *** For now database is hardcoded so test can point to Prod ***

Replication_SQLCA.database = sqlca.database  


//Servername stored in Lookup table

Select code_id into :lsServer
From Lookup_Table
where Project_id = '*all' and code_type = 'Repserver';

If isNull(lsServer) or lsServer = '' Then REturn - 1

Replication_SQLCA.servername = lsServer

Replication_SQLCA.logID = sqlca.logid     
Replication_SQLCA.logPass = sqlca.logPass



// Added string to turn off MARS  -- 04/29/11  cawikholm
Replication_SQLCA.dbparm       = "Database='"+Replication_SQLCA.database+"',TrimSpaces=1,ProviderString = 'MARS Connection=False'"

// 04/15/11 - PCONKL - Changed isolation from Read Committed to Read Uncommitted
//Replication-SQLCA.LOCK = "RC" 
Replication_SQLCA.LOCK = "RU" 




//Replication-SQLCA.AutoCommit = False
Replication_SQLCA.AutoCommit = TRUE /* 11/04 - PCONKL - Turned auto commit on to ellinate DB locks */


connect using Replication_SQLCA;

//Need to set the Ansi warnings off

EXECUTE IMMEDIATE "SET ANSI_WARNINGS OFF" USING Replication_SQLCA;

//SQLCA.DBParm = "disablebind =0"


Return Replication_SQLCA.sqlcode
end function

public function boolean uf_is_report_running_on_replication (string asreportwindow);Boolean	isReportReplicated
String	lsRepInd


//If not currently connected, get out
If not gb_replication_sqlca_connected Then Return False

Select replication_server_enabled into :lsRepInd
From Project_Reports
Where Project_id = :gs_project and report_id = (select report_id from project_reports_Detail where report_window = :asReportWindow);

If lsRepInd = 'Y' Then
	isREportReplicated = True
Else
	isREportReplicated = False
End If



REturn isREportReplicated
end function

public subroutine of_sims_notification (integer al_interval);//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality
long ll_time
//Look which Alert Type Flag is turned ON
IF gs_ShutdownFlag ='Y' and ib_shutdown =TRUE THEN //On next cycle of interval, force to shutdown SIMS instance.
		//of_sims_notification_process() //process for notification alert
		ib_shutdown =FALSE
		//timer(al_interval)
		//of_sims_notification_process()
		// Begin - Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancement
		//select time_interval into:ll_time from SIMS_Notification_user where user_id=:gs_userid using sqlca;
		HALT CLOSE 	//Auto shutdown SIMS
		//sleep(1)
		// End - Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancemen
	
ELSEIF gs_ShutdownFlag ='Y' and ib_shutdown =FALSE THEN //First cycle, set boolean value to TRUE and send an alert message.
	of_sims_notification_process() //process for notification alert
	
	//If logged user is available on UserList.
	IF ib_Flag =TRUE THEN 
		ib_shutdown =TRUE
	ELSE
		ib_shutdown =FALSE
	END IF

ELSEIF gs_NotificationFlag='Y' THEN
	of_sims_notification_process() //process for notification alert
END IF
end subroutine

public subroutine of_sims_notification_process ();//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality

String lsSql,lsErrors,ls_msg_desc,ls_Alert_Msg
Integer li_row,li_rowcount,li_Pos,li_Pos1
Boolean lbfound =FALSE

Datastore ldsAlertMsg,ldsUser

ldsAlertMsg =CREATE Datastore 
ldsUser =CREATE Datastore

lsSql ="SELECT Msg_Desc FROM SIMS_Notification_Message WITH (NOLOCK) WHERE Flag='Y'"
ldsAlertMsg.Create(SQLCA.SyntaxFromSQL(lsSql, "", lsErrors))

IF Len(lsErrors) > 0 Then
	Return
ELSE
	ldsAlertMsg.SetTransObject(SQLCA)
	li_rowcount =ldsAlertMsg.retrieve()
END IF

FOR li_row=1 to li_rowcount 
		ls_msg_desc =ldsAlertMsg.getitemstring( li_row, 'Msg_Desc')
		
		IF lbfound THEN 
			ls_Alert_Msg += " OR "
		END IF
		
		ls_Alert_Msg += ls_msg_desc //Append messages.
		lbfound = true
NEXT
	
ls_Alert_Msg += "~n~n" + gs_AlertNotes //Complete message description + Extra Notes from SIMS_Notification table
	

//Prompt message to user based on following scenarios.

//A. If all users assigned with all projects  get alert message
IF gs_Projectlist ='*ALL' and gs_Userlist ='*ALL' THEN 

	ib_Flag =TRUE
	gbLogin =TRUE
	// Begin - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
	MessageBox("SIMS Alert Notification",ls_Alert_Msg,StopSign!)
		if gs_ShutdownFlag ='Y'   then
			MessageBox("SIMS Alert Notification", "Please save all your changes within " + string(gi_time_interval) + " Seconds. It is going to be shut down.",StopSign!)
		end if
	//End - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
//B. only selected project users get an alert message
ELSEIF upper(gs_Projectlist) <> '*ALL' and gs_Userlist ='*ALL' THEN 

	//check whether logged user is associated with selected project.		
	lsSql ="SELECT COUNT(*) FROM User_Project WITH (NOLOCK) WHERE Project_Id IN ('" + gs_project + "') and UserId ='"+gs_userId+"'"
	// "SELECT * FROM SERIAL_NUMBER_INVENTORY WHERE PROJECT_ID = '" + gs_project + "' AND SERIAL_NO = '" + Right(lsSerial ,len(lsSerial) -1) + "' AND SKU in ( " + ls_formatted_gpns + " ) "
	ldsUser.create( SQLCA.SyntaxFromSql(lsSql,"",lsErrors))
	
	IF len(lsErrors) > 0 THEN
		Return
	ELSE
		ldsUser.settransobject( SQLCA);
		li_rowcount =ldsUser.retrieve( )
	END IF
	
	IF li_rowcount > 0 and upper(gs_Projectlist)=upper(gs_project) then // Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
		//Login Project should be in selected project list
	//IF li_rowcount > 0 and Pos(gs_Projectlist,gs_project) > 0 THEN 	//Login Project should be in selected project list// Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
		ib_Flag =TRUE
		gbLogin =TRUE
		// Begin - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
		MessageBox("SIMS Alert Notification",ls_Alert_Msg,StopSign!)
		if gs_ShutdownFlag ='Y'   then
			MessageBox("SIMS Alert Notification", "Please save all your changes within " + string(gi_time_interval) + " Seconds. It is going to be shut down.",StopSign!)
		end if
		// End - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
//	ELSE
//		ib_Flag =FALSE
//		gbLogin =FALSE
	END IF

//C. only selected users get an alert message against all assigned projects
ELSEIF gs_Projectlist ='*ALL' and gs_Userlist <> '*ALL'  and  upper(gs_Userlist) = upper(gs_Userid) THEN

	//IF Pos(gs_Userlist,gs_userId) > 0  THEN // Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancement
	//IF  gs_Projectlist=gs_project then // Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancement
		ib_Flag =TRUE
		gbLogin =TRUE
		// Begin - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
		MessageBox("SIMS Alert Notification",ls_Alert_Msg,StopSign!)
		
		if gs_ShutdownFlag ='Y'   then
			MessageBox("SIMS Alert Notification", "Please save all your changes within " + string(gi_time_interval) + " Seconds. It is going to be shut down.",StopSign!)
		end if
		
		// End - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
//	ELSE
	//	ib_Flag =FALSE
	//	gbLogin =FALSE
	//END IF

//D. only selected Project and selected users get an alert message
ELSEIF  upper(gs_Projectlist) <> '*ALL' and upper(gs_Userlist) <> '*ALL' and  upper(gs_Userlist) =upper(gs_Userid) THEN
	// Begin - Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancement
	//li_Pos1 =Pos(gs_Projectlist,gs_project)
	//li_Pos =Pos(gs_Userlist,gs_userId)
	
	//IF li_Pos > 0 and li_Pos1 > 0 THEN 	
	// End - Dinesh - 05/31/2024- commented above line SIMS-473- Google - SIMS – SIMS Timer Enhancement
	IF upper(gs_Projectlist)=gs_project and upper(gs_userlist) = upper(gs_userid) then // Dinesh - 05/31/2024- SIMS-473- Google - SIMS – SIMS Timer Enhancement
		ib_Flag =TRUE
		gbLogin =TRUE
		// Begin - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
		MessageBox("SIMS Alert Notification",ls_Alert_Msg,StopSign!)
		if gs_ShutdownFlag ='Y'   then
			MessageBox("SIMS Alert Notification", "Please save all your changes within " + string(gi_time_interval) + " Seconds. It is going to be shut down.",StopSign!)
		end if
		// End - Dinesh - 05/31/2024- SIMS-473-Google - SIMS – SIMS Timer Enhancement
//	ELSE
//		ib_Flag =FALSE
//		gbLogin =FALSE
	END IF
ELSE
	ib_Flag =FALSE
	gbLogin =FALSE
	
	
END IF
end subroutine

public function integer of_set_sims_defaults ();//TimA 06/18/15 
//Used the SIMS_Defaults table to get global path statements

//21-Feb-2017 Madhu -PEVS-467- Added default PDF path
Select Label_Path, Report_Path, PDF_Path
Into	:gs_labelpath, :gs_reportPath, :gs_pdfpath
From SIMS_Defaults;

If gs_labelpath = '' Then 
	//check to see if we have an ini file override...
	gs_labelpath = gs_syspath
else
	//Add the back slash to the end of the path statement if not there
	If Right(gs_labelpath,1) <> '\' then
		gs_labelpath = gs_labelpath + '\'
	End if
End If

If gs_reportpath = '' Then 
	//check to see if we have an ini file override...
	gs_reportpath = gs_syspath
else
	//Add the back slash to the end of the path statement if not there
	If Right(gs_reportpath,1) <> '\' then
		gs_reportpath = gs_reportpath + '\'
	End if
End If

If gs_pdfpath ='' Then
	//check to see if we have an ini file override...
	gs_pdfpath =gs_syspath
else
	//Add the back slash to the end of the path statement if not there
	If Right(gs_pdfpath,1) <> '\' Then
		gs_pdfpath = gs_pdfpath + '\'
	End If
End If

Return 0
end function

public function long uf_load_hazardous_materials (boolean ab_include_empty_row);// LTK 20151028
if NOT IsValid( ids_hazardous_materials ) then
	ids_hazardous_materials = f_datastoreFactory( 'd_dddw_hazardous_materials' )
end if

if ids_hazardous_materials.RowCount() <= 0 then
	ids_hazardous_materials.Retrieve()

	if ab_include_empty_row then
		ids_hazardous_materials.InsertRow( 1 )
	end if
end if

Return ids_hazardous_materials.RowCount()

end function

on n_cst_appmanager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_appmanager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

