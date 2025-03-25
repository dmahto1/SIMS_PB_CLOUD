$PBExportHeader$w_login_sarun.srw
forward
global type w_login_sarun from window
end type
type st_2 from statictext within w_login_sarun
end type
type st_1 from statictext within w_login_sarun
end type
type cb_1 from commandbutton within w_login_sarun
end type
type p_1 from picture within w_login_sarun
end type
type st_version from statictext within w_login_sarun
end type
type dw_main from datawindow within w_login_sarun
end type
type cb_cancel from commandbutton within w_login_sarun
end type
type cb_ok from commandbutton within w_login_sarun
end type
type st_5 from statictext within w_login_sarun
end type
type st_3 from statictext within w_login_sarun
end type
end forward

global type w_login_sarun from window
integer x = 951
integer y = 612
integer width = 1888
integer height = 1744
boolean titlebar = true
string title = "System Login"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 12632256
event ue_load_reports ( )
st_2 st_2
st_1 st_1
cb_1 cb_1
p_1 p_1
st_version st_version
dw_main dw_main
cb_cancel cb_cancel
cb_ok cb_ok
st_5 st_5
st_3 st_3
end type
global w_login_sarun w_login_sarun

type prototypes

end prototypes

type variables
String is_title, isOrigSQL_Project
Boolean	ibProjectSelected
inet	linit
u_nvo_websphere_post	iuoWebsphere

end variables

forward prototypes
public subroutine doversiontest ()
public function string getformattedversion (string _version)
public function integer wf_load_database_dropdown (string astype)
end prototypes

event ue_load_reports;Long	llRowCount
// 12/00 - PCONKL - Load reports available for the current project - we will also eliminate reports that current user doesn't have access to.

SetPointer(Hourglass!)
w_main.SetMicrohelp("Loading Reports...")
llRowCount = g.ids_reports.Retrieve(gs_project)
w_main.SetMicroHelp("Ready")
SetPointer(Arrow!)



end event

public subroutine doversiontest ();// doVersionTest()

// get the version they are running and compare that to whats in the version table
//
// Determine outcome based on the version state, update date, etc.

string clientVersion

string dbVersion
string dbVersionState
datetime dbEffectiveDate
datetime dbVersionUpdateDate

  SELECT dbo.Project_Version.version,   
         dbo.Project_Version.version_state,   
         dbo.Project_Version.version_effective_date,   
         dbo.Project_Version.version_update_date
    INTO
         :dbversion,   
         :dbversionstate,   
         :dbeffectivedate,   
         :dbversionupdatedate   
    FROM dbo.Project_Version  
   WHERE dbo.Project_Version.project_id = :gs_project   ;

if sqlca.sqlcode = 100 then return
if isNull( dbversion ) or len( dbversion ) = 0 then return

clientVersion = f_get_version()
if clientVersion < dbVersion then
	dbversion = getFormattedVersion( dbVersion )
	choose case dbVersionState
		case 'M'  // mandatory
			beep(1)
			if datetime( today(), now() ) >= dbEffectiveDate then
				messagebox( "SIMS Version", "The version of SIMS on this machine is outdated.~r~n" + &
									 "It is Mandatory that this machine be upgraded to the latest version, " + dbversion + "~r~n" + &
									 "Please contact your supervisor to obtain the latest release of SIMS", stopsign! )
				halt close
			else
				messagebox( "SIMS Version", 	"The version of SIMS on this machine is outdated.~r~n" + &
									 "It is Mandatory that this machine be upgraded to the latest version.~r~n~r~n" +&
									 "This version of SIMS will expire in " + String (daysAfter( today(), date( dbeffectiveDate) ) ) + " days.~r~n~r~n" + &
									 "Please contact your supervisor to obtain the latest release of SIMS", exclamation! )

			end if
		case 'A'  // advised
			beep(1)
			if isNull( dbversionupdatedate) then
				messagebox( "SIMS Version", "The version of SIMS on this machine is outdated.~r~n" + &
								 "It is Advised that this machine be upgraded to the latest version, " + dbversion + ".~r~n" + &
								 "Please contact your supervisor to obtain the latest release of SIMS", exclamation! )
								
			else
				messagebox( "SIMS Version", "The version of SIMS on this machine is outdated.~r~n" + &
								 "It is Advised that this machine be upgraded to the latest version, " + dbversion + " by " + string(dbversionupdatedate, 'mm/dd/yyyy' ) + ".~r~n" + &
								 "Please contact your supervisor to obtain the latest release of SIMS", exclamation! )
			end if
							
		case 'S' // suggested
		case 'T' // testing
			return
	end choose
end if


end subroutine

public function string getformattedversion (string _version);// string = getFormattedVersion( string _version )

// Returns a formatted version number
string release
string rev
string updatedate
string workerant

workerant = left( _version, 2 )
release = left( workerant, 1 )
rev = right( workerant, 1 )
updatedate = right( _version, 8 )
return  trim( "Version: " + release + "." + rev + " ( " + updatedate +  " ) " )

end function

public function integer wf_load_database_dropdown (string astype);
String	lsDatabase, lsTemp, lsUser, lsPaswrd, lsSetDatabase, lsSetProject,displayvalue
datawindowchild	ldwc_database, ldwc_project
Long ll_row

dw_main.GetChild('database', ldwc_database)
dw_main.GetChild('project_id', ldwc_project)

ldwc_database.reset()


//At login, we will load 'Default', IF user hits F12, we will load all available
If Upper(asType) = 'ALL' Then
	lsDatabase = ProfileString(g.gs_DBConfigIni,"database","Available","")
Else
	lsDatabase = ProfileString(g.gs_DBConfigIni,"database","Default","")
End If

If lsDAtabase = "" Then
	
	Messagebox("Config Error","No valid Databases present in SIMSDBConfig.ini!",Stopsign!)
	Halt Close
	
Else
	
	//Parse out the list of databases - comma seperated
	Do while Pos(lsDatabase,',') > 0
		
		lsTemp = left(lsDAtabase,Pos(lsDatabase,',') - 1)
		ldwc_database.InsertRow(0)
		ldwc_database.SetITem(ldwc_database.rowCount(),'database',lsTemp)
		lsDAtabase = Mid(lsDatabase,Pos(lsDatabase,',') +1,999)
	
	Loop
	
	ldwc_database.InsertRow(0)
	ldwc_database.SetITem(ldwc_database.rowCount(),'database',lsDatabase)
	
	//If only one DB in list, select it
	If ldwc_database.RowCount() = 1 then
		dw_main.SetItem(1,'database', ldwc_database.GetITemString(1,'database'))
		dw_main.Modify("database.visible=False database_t.visible=False")
	else
		dw_main.Modify("database.visible=True database_t.visible=True")
	End If

End If

//This is for Developers only
//Added by TimA 05/16/12
//**************************************************************
 lsUser = ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultUser","")

if len(lsUser) = 0 then
	 lsUser = gs_userid
else	 
	 lsUser = ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultUser","")
end if
	 lsPaswrd = ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultPassword","")
	 lsSetDatabase= ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultDB","")
	 lsSetProject =  ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultProject","")
 
 
 if lsUser <> '' then
	dw_main.SetItem(1,'user_id', lsUser)
End if
 if lsPaswrd <> '' then
	dw_main.SetItem(1,'password', lsPaswrd)
End if
If lsSetDatabase <> '' Then
	dw_main.SetItem(1,'database', lsSetDatabase)
	dw_main.AcceptText() 
	dw_main.SetFocus()
	dw_main.SetColumn("database")
	ll_row = ldwc_database.Find("database='" +  lsSetDatabase + "'", 1,   ldwc_database.RowCount()) 
	ldwc_database.ScrollToRow(ll_row)
     ldwc_database.SelectRow(ll_row, TRUE) 
	dw_main.SetItem(ll_row,'database', ldwc_database.GetITemString(ll_row,'database'))
End if

If lsSetProject <> '' Then
	This.cb_ok.TriggerEvent('clicked')
	dw_main.SetItem(1,'project_id', lsSetProject)
	dw_main.AcceptText() 
	dw_main.SetFocus()
	dw_main.SetColumn("project_id")
	ll_row = ldwc_project.Find("project_id='" +  lsSetProject + "'", 1,   ldwc_project.RowCount()) 
	ldwc_project.ScrollToRow(ll_row)
     ldwc_project.SelectRow(ll_row, TRUE) 
	dw_main.SetItem(ll_row,'project_id', ldwc_project.GetITemString(ll_row,'project_id'))
End if
//************************************************************************
Return 0

end function

on w_login_sarun.create
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.p_1=create p_1
this.st_version=create st_version
this.dw_main=create dw_main
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_5=create st_5
this.st_3=create st_3
this.Control[]={this.st_2,&
this.st_1,&
this.cb_1,&
this.p_1,&
this.st_version,&
this.dw_main,&
this.cb_cancel,&
this.cb_ok,&
this.st_5,&
this.st_3}
end on

on w_login_sarun.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.st_version)
destroy(this.dw_main)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_5)
destroy(this.st_3)
end on

event open;DataWindowChild ldwc_project
String ls_project, lsDatabase, lsTemp
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

datawindowchild	ldwc_database

is_title = This.Title

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

// 07/00 PCONKL - Project ID will only be displayed on login screen if the user has access to multiple projects
//						After entering ID/Pass, If they have access to multiple Projects, the Field will be displayed for selection from list of eligible projects

dw_main.InsertRow(0)

//Set the Version
// pvh - 04/25/06 - version
//  st_version.Text = 'Version: ' + f_get_Version()
 st_version.Text = f_getFormattedVersion()

dw_main.Modify("project_id.visible=False project_id_t.visible=False")
dw_main.Modify("database.visible=False database_t.visible=False")
dw_main.GetChild('project_id', ldwc_project)

//get original SQL for Project dropdown, USer ID will be tacked on if necessary
isOrigSql_project = ldwc_project.getsqlselect()

// 03/12 - PCONKL - Load list of databases from database.ini
wf_load_database_Dropdown('Default')

//dw_main.GetChild('database', ldwc_database)
//
//lsDatabase = ProfileString(g.gs_DBConfigIni,"database","Available","")
//If lsDAtabase = "" Then
//	
//	Messagebox("Config Error","No valid dtaabases present in SIMSDBConfig.ini!",Stopsign!)
//	Halt Close
//	
//Else
//	
//	//Parse out the list of databases - comma seperated
//	Do while Pos(lsDatabase,',') > 0
//		
//		lsTemp = left(lsDAtabase,Pos(lsDatabase,',') - 1)
//		ldwc_database.InsertRow(0)
//		ldwc_database.SetITem(ldwc_database.rowCount(),'database',lsTemp)
//		lsDAtabase = Mid(lsDatabase,Pos(lsDatabase,',') +1,999)
//	
//	Loop
//	
//	ldwc_database.InsertRow(0)
//	ldwc_database.SetITem(ldwc_database.rowCount(),'database',lsDatabase)
//	
//	//If only one DB in list, select it
//	If ldwc_database.RowCount() = 1 then
//		dw_main.SetItem(1,'database', ldwc_database.GetITemString(1,'database'))
//	else
//		dw_main.Modify("database.visible=True database_t.visible=True")
//	End If
//
//End If











end event

type st_2 from statictext within w_login_sarun
integer x = 256
integer y = 1244
integer width = 1458
integer height = 220
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Please use Menlo NT logon and Password for SIMS Access"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_login_sarun
integer x = 256
integer y = 1152
integer width = 1458
integer height = 88
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "*** ATTENTION ***"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_login_sarun
integer x = 1170
integer y = 1500
integer width = 283
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;ShowHelp(g.is_HelpFile,Topic!,509)
end event

type p_1 from picture within w_login_sarun
integer x = 786
integer y = 240
integer width = 329
integer height = 288
boolean originalsize = true
string picturename = "sims_small.bmp"
boolean focusrectangle = false
end type

type st_version from statictext within w_login_sarun
integer x = 5
integer y = 540
integer width = 1824
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_main from datawindow within w_login_sarun
event ue_keydown pbm_dwnkey
integer x = 274
integer y = 652
integer width = 1417
integer height = 476
integer taborder = 10
string dataobject = "d_login"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;
If Key = KeyF12! Then
	wf_load_database_dropdown('All')
End IF


end event

event itemchanged;
//If User ID field is changing, make the Project ID field Invisible
If dwo.Name = "user_id" Then
	This.modify("project_id.visible=False Project_id_t.visible=False")
	ibProjectSelected = False
End If


end event

type cb_cancel from commandbutton within w_login_sarun
integer x = 763
integer y = 1500
integer width = 283
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)


end event

type cb_ok from commandbutton within w_login_sarun
integer x = 357
integer y = 1500
integer width = 283
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;String ls_userid, ls_pwd, ls_pwd2, ls_role,ls_project, lsNewSql, lsVersion, lsDatabase, lsServer, lsDB, lsXML, lsXMLResponse, lsAttributes, lsReturnCode, lsReturnDesc, lsURL
Long ls_status,	llRowCOunt,	llCount
integer li_row, liPort
ulong lul_name_size = 32
String	ls_machine_name = Space (32)

DatawindowChild	ldwc_project

If dw_main.AcceptText() = -1 Then Return

ls_userid = dw_main.GetItemString(1, "user_id")
ls_project = dw_main.GetItemString(1, "project_id")
lsDatabase = dw_main.GetItemString(1, "database")
ls_pwd2 = dw_main.GetItemString(1, "password")

If IsNull(ls_pwd2) Then ls_pwd2 = ""


// 09/12 - PCONKL - If selecting from multiple projects, we only need to do the authenticate and connection once...
//If Already connected, disable ID,Pwd and Database fields

If not ibProjectSelected Then
	
	//User and PAssword must be entered
	IF isnull(ls_userid) or ls_userId = '' Then
		MessageBox(is_title, "User ID is required!", StopSign!) 
		f_setfocus(dw_main, 1, 'user_id')
		Return
	End If

	IF isnull(ls_pwd2) or ls_pwd2 = '' Then
		MessageBox(is_title, "Password is required!", StopSign!) 
		f_setfocus(dw_main, 1, 'password')
		return
	End If

	// 04/12 - PCONKL - Database must be selected and contain valid settings in the ini file*/
	If lsDatabase = '' or isnull(lsDAtabase) then
		MessageBox(is_title, "Database must be selected!", StopSign!) 
		f_setfocus(dw_main, 1, 'database')
		Return
	End If

	//Set Server,  DAtabase, URL and Port from SIMDBConfig.ini
	sqlca.servername = ProfileString(g.gs_DBConfigIni,lsDatabase,"servername","")
	sqlca.database = ProfileString(g.gs_DBConfigIni,lsDatabase,"database","")

	lsURL = ProfileString(g.gs_DBConfigIni,lsDatabase,"url","")
	liPort =  long(ProfileString(g.gs_DBConfigIni,lsDatabase,"port",""))

	If isnull(sqlca.servername) or sqlca.servername = '' or isnull(sqlca.database) or sqlca.database = '' Then
		MessageBox(is_title, "Database/Server paramters missing from SIMSDBConfig.ini file. Unable to login", StopSign!) 
		return
	End IF


	//Authenticate USER  on WEbsphere
	// 11/05 - PCONKL - Building Pick List from Websphere now
	iuoWebsphere = CREATE u_nvo_websphere_post
	linit = Create Inet

	lsAttributes = ' NTUserID = "' + ls_userid + '" NTPassword = "' + ls_pwd2 + '"'
	lsXML = iuoWebsphere.uf_request_header("AuthenticateUserRequest", lsAttributes)
	lsXML = iuoWebsphere.uf_request_footer(lsXML)

	lsXMLResponse = iuoWebsphere.uf_post_url(lsXML, lsURL, liPort)

	//If we didn't receive an XML back, there is a fatal exception error
	If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
		Messagebox("Websphere Fatal Exception Error","Unable to Authenticate User: ~r~r" + lsXMLResponse,StopSign!)
		Return 
	End If

	lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
	lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

	If lsReturnCode<> "0"  Then
		MessageBox("Authentication Error",lsReturnDesc,StopSign!)
		REturn
	End If

	//these will be passed back from Websphere
	sqlca.logID =  iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"dbUserID")
	sqlca.logpass =  iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"dbPassword")

	//If authenticated, connect to DB
	g.uf_post_connect_Open()

	dw_main.SetTransObject(SQLCA)

	//Select passwd, user_status, access_level
	//	Into :ls_pwd, :ls_status, :ls_role
	//	From UserTable
	//	Where userid = :ls_userid;
	
End If /* Proeject notalready selected - not connected to DB*/

Select  user_status, access_level
Into :ls_status, :ls_role
From UserTable
Where userid = :ls_userid;


gs_userid = ls_userid
gs_role = ls_role

// 07/00 PCONKL - Check user_project table for proper project. If more than one exists, display and populate dropdown for choices.

dw_main.GetChild('project_id', ldwc_project)
ldwc_project.SetTransObject(sqlca)

Choose Case gs_role
		
	// 02/08 - Pconkl - added "-1" for Super Duper user
	// 06/12 - PCONKL - Only Super Duper will get entire List, Super users now need to select from authorized projects
	CAse '-1' /*Super - We will display all projects for the User to Select from*/
	
		If ibProjectSelected Then
			gs_project = dw_main.GetItemString(1,"project_id")
		Else
			gs_project = ''
			ldwc_project.setsqlselect(isorigsql_project)
			If ldwc_project.Retrieve() > 0 Then
				dw_main.SetItem(1, "project_id", ldwc_project.GetItemString(1,"project_id"))
				dw_main.Modify("project_id_t.visible=True project_id.visible=True")
				ibProjectSelected = True
				dw_main.SetFocus()
				dw_main.SetColumn("project_id")
				dw_main.Modify("user_id.protect=1 user_id.Background.Color='12632256' password.protect=1 password.Background.Color='12632256' database.protect=1 database.Background.Color='12632256'") /* 09/12 - PCONKL */
				Return
			End If
		End If
		
	CAse Else /*Admin and Operators will only see applicable projects - 06/12 - PCONKL - now including Super USers*/
		
		If ibProjectSelected Then
			gs_project = dw_main.GetItemString(1,"project_id")
		Else
			gs_project = ''
			
			//***BCR 17-JUN-2011: SQL 2008 Compatibility Project to convert "*=" to OUTER JOIN
			
			//Modify Project dddw SQL to only show for current User (from user_project Table)
			
//			lsNewSql = isOrigSql_Project + " and userid = '" + gs_userid + "'" 
//			lsNewSql = Replace(lsNewSql,pos(lsNewSql,'*='),2,'=') /*make outer join an explicit join to limit for current user*/
//			ldwc_project.setsqlselect(lsNewsql)
			//*************************************************
			lsNewSql = isOrigSql_Project + " WHERE User_Project.userid = '" + gs_userid + "'" 
			lsNewSql = Replace(lsNewSql,pos(lsNewSql,'LEFT'),4,'INNER') /*make outer join an explicit join to limit for current user*/
			ldwc_project.setsqlselect(lsNewsql)  

			//******************************************************
	
			llRowCount = ldwc_project.Retrieve() 
			If lLRowCount <= 0 Then /*no authorized Projects*/
				Messagebox(is_title,"Login Failed! You are not authorized to any Projects!~r~rContact your system Administrator.")
				ibProjectSelected = False
				Return
			Elseif llRowCount = 1 then /*only one authorized project, no need to show dropdown*/
				gs_project = ldwc_project.GetItemString(1,"project_id")
				ibProjectSelected = False
			Else /*multiple projects, show list for selection*/
				dw_main.SetItem(1, "project_id", ldwc_project.GetItemString(1,"project_id"))
				dw_main.Modify("project_id_t.visible=True project_id.visible=True")
				ibProjectSelected = True
				dw_main.SetColumn("project_id")
				dw_main.Modify("user_id.protect=1 user_id.Background.Color='12632256' password.protect=1 password.Background.Color='12632256' database.protect=1 database.Background.Color='12632256'") /* 09/12 - PCONKL */
				Return
			End If
		End If
		
End Choose

// pvh - 04/25/2006
doVersionTest()


// pvh - 05/01/06 - idle
g.setprojectIdleTime( 0 )
g.setProjectAppTerminateTime( 0 )
IDLE( g.getprojectIdleTime() )
// eom 

	
//Update the Title - include version
// pvh - 04/25/06 - version
w_main.Title = gsTitle + ', Project: ' + gs_project + ', ' + f_getFormattedVersion()
Opensheet (w_sims_banner, w_main,1,Original! )

//w_main.Title = gsTitle + ', Project: ' + gs_project + ', Version: ' + f_get_version() 

// for 3com and the shipments logon issue
if Upper( gs_project ) = '3COM_NASH' then	w_main.Title += ' As: ' + gs_userid

//Added by DGM 09/11/00
//g.is_owner_ind = g.of_get_project_ind()
g.of_get_project_ind()

//Added by DGM 12/15/00 
//For populating datastore to check labels
g.of_get_label() 

// pvh - 08/18/06 - Load Access Rights
if g.doFunctionRightsRetrieve() < 0 then
	messagebox( is_title, "Unable to Find Access Rights Data.~r~nContact your system Administrator.",exclamation! )
end if

// 12/00 PCONKL - Load available reports for project


/* Sarun for Title Change
Choose case upper(sqlca.database)
	Case 'SIMS33PRD'
		w_main.title = "Production [ " + 'Project: ' + gs_project + '] ' + f_getFormattedVersion()		
	Case 'SIMS33TEST'
		w_main.title = "Test [ " + 'Project: ' + gs_project + '] ' + f_getFormattedVersion()		
	Case 'SIMS33PAN'
		w_main.title = "QA [ " + 'Project: ' + gs_project + '] ' + f_getFormattedVersion()		
End choose		
*/

Parent.TriggerEvent("ue_load_reports")

// 10/04 - PCONKL - Create Login Entry in USer Log table
g.GetComputerNameA (ls_machine_name, lul_name_size)
lsVersion = f_get_Version() 
g.idt_user_Login_Time = DateTime(Today(),Now()) /* saved so we can re-retrieve and update logout time*/

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

Insert Into User_login_History (Project_ID, UserID, Login_Time, Machine_Name, Sims_Version)
				Values	(:gs_project, :ls_userid, :g.idt_user_Login_Time, :ls_machine_name, :lsVersion)
Using	SQLCA;

Execute Immediate "COMMIT" using SQLCA;

close(parent)
end event

type st_5 from statictext within w_login_sarun
integer x = 5
integer y = 20
integer width = 1851
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "Menlo Worldwide"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_login_sarun
integer x = 5
integer y = 104
integer width = 1851
integer height = 112
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "Supplier Inventory Management  System"
alignment alignment = center!
boolean focusrectangle = false
end type

