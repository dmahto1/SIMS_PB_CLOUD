$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type p_2 from picture within w_login
end type
type cb_1 from commandbutton within w_login
end type
type p_1 from picture within w_login
end type
type st_version from statictext within w_login
end type
type dw_main from datawindow within w_login
end type
type cb_cancel from commandbutton within w_login
end type
type cb_ok from commandbutton within w_login
end type
type st_5 from statictext within w_login
end type
type st_3 from statictext within w_login
end type
end forward

global type w_login from window
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
p_2 p_2
cb_1 cb_1
p_1 p_1
st_version st_version
dw_main dw_main
cb_cancel cb_cancel
cb_ok cb_ok
st_5 st_5
st_3 st_3
end type
global w_login w_login

type prototypes

end prototypes

type variables
String is_title, isOrigSQL_Project
Boolean	ibProjectSelected,ibShowAllProject = False
Boolean ib_dbValidation =FALSE //29-Jun-2015 :Madhu- Added to validate QA build against PROD db.
inet	linit
u_nvo_websphere_post	iuoWebsphere
nvo_file invoGetFileInfo

end variables

forward prototypes
public subroutine doversiontest ()
public function string getformattedversion (string _version)
public function integer wf_load_database_dropdown (string astype)
public subroutine dopbdtimecheck ()
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

//29-Jun-2015 :Madhu- Strip QA /PROD from the f_get_version() - START
If Pos(clientVersion,",") > 0 THEN  
	clientVersion= trim(left(clientVersion,Pos(clientVersion,",") -1)) //client version
ELSEIF Pos(clientVersion,"-") > 0 THEN
	clientVersion= trim(left(clientVersion,Pos(clientVersion,"-") -1))
END IF
//29-Jun-2015 :Madhu- Strip QA /PROD from the f_get_version() - END

if clientVersion < dbVersion then
	dbversion = getFormattedVersion( dbVersion )
	choose case dbVersionState
		case 'M'  // mandatory
			beep(1)
			if datetime( today(), now() ) >= dbEffectiveDate then
				if gs_role = '-1' then
					if upper(sqlca.database) = 'SIMS33PRD' and gs_project = 'PANDORA' then
						messagebox( "PANDORA SIMS", "To log in to the Pandora SIMS instance, you must re-start SIMS and use 'F12' to select the Pandora database (before hitting Ok or <Enter>).", stopsign! )
						halt close
					end if		
					messagebox( "SIMS Version", "The version of SIMS on this machine is outdated.~r~n" + &
									 "It is Mandatory that this machine be upgraded to the latest version, " + dbversion + "~r~n" + &
									 "Because you are SuperDuper, you get to log in anyway (but be careful).", stopsign! )
				else 	
					if upper(sqlca.database) = 'SIMS33PRD' and gs_project = 'PANDORA' then
						messagebox( "PANDORA SIMS", "To log in to the Pandora SIMS instance, you must re-start SIMS and use 'F12' to select the Pandora database (before hitting Ok or <Enter>).", stopsign! )
						halt close
					end if		
					messagebox( "SIMS Version", "The version of SIMS on this machine is outdated.~r~n" + &
								 "It is Mandatory that this machine be upgraded to the latest version, " + dbversion + "~r~n" + &
								 "Please contact your supervisor to obtain the latest release of SIMS", stopsign! )
					halt close
				end if 
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


//29-Jun-2015 :Madhu- Added code to validate to prompt a message, if anyone points to PROD db by using QA build -START
If (gs_buildVersion ='QA') and (upper(sqlca.database) = 'SIMS33PRD' or upper(sqlca.database) = 'SIMSPANPRD') THEN
	CHOOSE CASE gs_role
		CASE '0','-1'
			ib_dbValidation =FALSE
			MessageBox("SIMS DB Connection","This QA Version of SIMS is pointing to PROD/PANDORA DB which is NOT recommended but it's at your OWN risk",StopSign!)
		CASE '1','2'
			ib_dbValidation =TRUE
			MessageBox("SIMS DB Connection","This QA Version of SIMS is pointing to PROD/PANDORA DB which is NOT allowed. Please select appropriate DB",StopSign!)
	END CHOOSE
END IF
//29-Jun-2015 :Madhu- Added code to validate to prompt a message, if anyone points to PROD db by using QA build -END

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
String	lsDatabase, lsTemp, lsUser, lsPaswrd, lsSetDatabase, lsSetProject,displayvalue,lsShowAllProj
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
 lsPaswrd = ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultPassword","")
 lsSetDatabase= ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultDB","")
 lsSetProject =  ProfileString(g.gs_DBConfigIni,"Developer_Info","SetDefaultProject","")
 lsShowAllProj =  ProfileString(g.gs_DBConfigIni,"Developer_Info","ShowAllProject","")   //Sarun2014Nov03 : Show Only Active Project
 
 if lsShowAllProj = 'Y' then ibShowAllProject = True
 
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
	//TimA 09/25/15 made changes because of issues with super users
	//Jesslyn was having problem with defauls and logging into production
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

public subroutine dopbdtimecheck ();/* 22-Mar-2013 :Neha - Added code to compare the PBD date with EXE/Version date*/

string ls_files[],ls_path
string is_filename,ls_datetime,ls_exedatetime
date ld_exe,ld_pbd
int li_items, li_i
//window lw_1
listbox llb_1
OLEObject obj_shell, obj_folder, obj_item

obj_shell = CREATE OLEObject
obj_shell.ConnectToNewObject( 'shell.application' )

ls_path  = GetCurrentDirectory ()

//Open( lw_1 )

this.openUserObject( llb_1 )

//To get the exe date
is_filename ="sims-mww.exe"
obj_folder = obj_shell.NameSpace( ls_path) //folder
obj_item = obj_folder.ParseName( is_filename ) //file
ls_exedatetime = obj_folder.GetDetailsOf( obj_item, 3 ) //exe date
ld_exe =date(ls_exedatetime) //convert string to date

//To get the dates of each pbd

IF llb_1.DirList(ls_path, 0) then
	li_items = llb_1.TotalItems()
end if

For li_i = 1 to li_items
	ls_files[ li_i ] = llb_1.Text( li_i )
	is_filename = ls_files[ li_i ]  //we come to know which pbd it is 
	obj_folder = obj_shell.NameSpace(ls_path) //folder
	obj_item = obj_folder.ParseName( is_filename ) //file
	ls_datetime = obj_folder.GetDetailsOf( obj_item, 3 )
	ld_pbd =date(ls_datetime) //convert string to date
	
	int ls_count			

	Select count(Code_Descript)
	into :ls_count
	from dbo.lookup_table 
	where project_id ='*ALL'  and code_type ='PBD' and Code_Descript = :is_filename ; 
	
	If ls_count =  0 then 
	 	continue 
	end if 
	
	
	IF ld_pbd < ld_exe THEN
	messagebox( "SIMS PBD Date", "The " +  upper(is_filename) + " date of SIMS on this machine is outdated.~r~n" + &
									 "It is Mandatory that this machine be upgraded to the latest pbd,   ~r~n" + &
									 "Please contact your supervisor to obtain the latest release of SIMS", stopsign! )
	halt close
END IF
	
Next


obj_shell.DisconnectObject()
destroy obj_folder
destroy obj_item
destroy obj_shell
this.closeUserObject( llb_1 )

//Close( lw_1 )
//destroy lw_1


end subroutine

on w_login.create
this.p_2=create p_2
this.cb_1=create cb_1
this.p_1=create p_1
this.st_version=create st_version
this.dw_main=create dw_main
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_5=create st_5
this.st_3=create st_3
this.Control[]={this.p_2,&
this.cb_1,&
this.p_1,&
this.st_version,&
this.dw_main,&
this.cb_cancel,&
this.cb_ok,&
this.st_5,&
this.st_3}
end on

on w_login.destroy
destroy(this.p_2)
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

//check the fucntions 

/*SetPointer(Hourglass!)
w_main.SetMicroHelp("Cheking the current PBD")
dopbdtimecheck() //22-Mar-2013 :Madhu calling new function 
w_main.SetMicroHelp("")
SetPointer(Arrow!) */

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

type p_2 from picture within w_login
integer x = 530
integer y = 172
integer width = 741
integer height = 236
string picturename = "GXOlogin.png"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_login
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

type p_1 from picture within w_login
integer x = 741
integer y = 576
integer width = 329
integer height = 288
boolean originalsize = true
string picturename = "sims_small.bmp"
boolean focusrectangle = false
end type

type st_version from statictext within w_login
integer x = 23
integer y = 868
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

type dw_main from datawindow within w_login
event ue_keydown pbm_dwnkey
integer x = 233
integer y = 996
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

type cb_cancel from commandbutton within w_login
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

type cb_ok from commandbutton within w_login
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

event clicked;String ls_userid, ls_pwd, ls_pwd2, ls_role,ls_project, lsNewSql, lsVersion, lsDatabase, lsServer, lsDB, lsXML, lsXMLResponse, lsAttributes, lsReturnCode, lsReturnDesc, lsURL, lsDatasource,ls_showAllProject
Long ls_status,	llRowCOunt,	llCount
integer li_row, liPort,j
ulong lul_name_size = 32
String	ls_machine_name = Space (32)
//TimA 07/23/15
Boolean lbSetFile
Date ldGetSIMSFileDate,ldGetPBDDate 
String lsPbdListFiles, lsPbdFile,lsGoodPBD, lsBadPBD
Long llCountDates
String ls_commodity_authorized_user //01-Jun-2016 Madhu Added
datastore lds_sims_notification,lds_sims_notification_filter
long i,ll_count,li_time_interval
DatawindowChild	ldwc_project

If dw_main.AcceptText() = -1 Then Return

ls_userid = dw_main.GetItemString(1, "user_id")
ls_project = dw_main.GetItemString(1, "project_id")
lsDatabase = dw_main.GetItemString(1, "database")
ls_pwd2 = dw_main.GetItemString(1, "password")

If IsNull(ls_pwd2) Then ls_pwd2 = ""

If not ibShowAllProject then ls_showAllProject = " and  (  Active_Customer_Ind = 'Y' or  Active_Customer_Ind is null )" //Sarun2014Nov03 : Show Only Active Project


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
	lsDatasource = ProfileString(g.gs_DBConfigIni,lsDatabase,"datasource","") /* 11/13 - PCONKL*/

	If isnull(sqlca.servername) or sqlca.servername = '' or isnull(sqlca.database) or sqlca.database = '' Then
		MessageBox(is_title, "Database/Server paramters missing from SIMSDBConfig.ini file. Unable to login", StopSign!) 
		return
	End IF


	//Authenticate USER  on WEbsphere
	// 11/05 - PCONKL - Building Pick List from Websphere now
	iuoWebsphere = CREATE u_nvo_websphere_post
	linit = Create Inet

	lsAttributes = ' NTUserID = "' + ls_userid + '" NTPassword = "' + ls_pwd2 + '"'
	
	// 11/13 - PCONKL - Include the datasource if present so we can validate against a DB other than the default
	If lsDatasource > '' Then
		g.isWebsphereDAtasource = lsDataSource
	else
		g.isWebsphereDAtasource = ''
	End If
	
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

Select  user_status, access_level,Commodity_Authorized_User
Into :ls_status, :ls_role,:ls_commodity_authorized_user
From UserTable
Where userid = :ls_userid;


gs_userid = ls_userid
gs_role = ls_role
gs_commodity_authorized_user =ls_commodity_authorized_user

// 07/00 PCONKL - Check user_project table for proper project. If more than one exists, display and populate dropdown for choices.

dw_main.GetChild('project_id', ldwc_project)
ldwc_project.SetTransObject(sqlca)

Choose Case gs_role
		
	// 02/08 - Pconkl - added "-1" for Super Duper user
	// 06/12 - PCONKL - Only Super Duper will get entire List, Super users now need to select from authorized projects
	CAse '-1' /*Super - We will display all projects for the User to Select from*/
	
			lsNewSql = isOrigSql_Project + " WHERE 1 =1 " + ls_showAllProject    //Sarun2014Nov03 : Show Only Active Project
			//lsNewSql = Replace(lsNewSql,pos(lsNewSql,'LEFT'),4,'INNER') ////Sarun2014Nov03 : Show Only Active Project - 
			//Madhu 12-Nov-15 : As discussed in code review commented above line.

		If ibProjectSelected Then
			gs_project = dw_main.GetItemString(1,"project_id")
		Else
			gs_project = ''
			ldwc_project.setsqlselect(lsNewsql)
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
			lsNewSql = isOrigSql_Project + " WHERE User_Project.userid = '" + gs_userid + "'" + ls_showAllProject  //Sarun2014Nov03 : Show Only Active Project
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

IF ib_dbValidation =TRUE THEN RETURN //29-Jun-2015 :Madhu- Don't allow whoever has role of 1 or 2 against PROD db by using SIMS QA build.
// Begin- Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement

//07-Apr-2014 Madhu- SIMS Timer Notification Alert Functionality -START
//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval 
//	into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:gi_time_interval 
//FROM SIMS_Notification with(nolock);  // This block of lines commenetd out against below lines// Dinesh
// Begin- Dinesh - 05/31/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval,login 
//	into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:gi_time_interval,:gs_login 
//FROM SIMS_Notification_user with(nolock);

lds_sims_notification = create datastore 
lds_sims_notification_filter = create datastore
long ll_count_all
lds_sims_notification.dataobject='d_sims_notification_search_all'
lds_sims_notification.settrans(sqlca)
lds_sims_notification.retrieve()
ll_count_all= lds_sims_notification.rowcount()
	for j=1 to ll_count_all
		gs_Projectlist= lds_sims_notification.getitemstring(j,'Project_Id')
		gs_Userlist= lds_sims_notification.getitemstring(j,'User_Id')
		gs_NotificationFlag= lds_sims_notification.getitemstring(j,'Notification_Flag')
		gs_ShutdownFlag= lds_sims_notification.getitemstring(j,'Shutdown_Flag')
		gs_AlertNotes= lds_sims_notification.getitemstring(j,'Notes')
		gi_time_interval= lds_sims_notification.getitemnumber(j,'Time_Interval')
		gs_login= lds_sims_notification.getitemstring(j,'login')
		
		if gs_Userlist <> '*ALL' and gs_projectlist = '*ALL' then
			lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
				lds_sims_notification_filter.settrans(sqlca)
				lds_sims_notification_filter.retrieve()
				lds_sims_notification_filter.SetFilter("user_id = '"+ gs_Userlist +"'")
			end if
			if gs_Userlist='*ALL' and gs_projectlist <> '*ALL' then
				lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
				lds_sims_notification_filter.settrans(sqlca)
				lds_sims_notification_filter.retrieve()
				lds_sims_notification_filter.SetFilter("project_id = '"+ gs_Projectlist +"'")
			end if
			if gs_Userlist<> '*ALL' and gs_projectlist <> '*ALL' then
				lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
				lds_sims_notification_filter.settrans(sqlca)
				lds_sims_notification_filter.retrieve()
				lds_sims_notification_filter.SetFilter("project_id = '"+ gs_Projectlist +"' and user_id = '"+ gs_Userlist +"'")
				lds_sims_notification_filter.filter()
			end if
			ll_count= lds_sims_notification_filter.rowcount()
			
			for i =1 to ll_count
				gs_Projectlist= lds_sims_notification_filter.getitemstring(i,'Project_Id')
				gs_Userlist= lds_sims_notification_filter.getitemstring(i,'User_Id')
				gs_NotificationFlag= lds_sims_notification_filter.getitemstring(i,'Notification_Flag')
				gs_ShutdownFlag= lds_sims_notification_filter.getitemstring(i,'Shutdown_Flag')
				gs_AlertNotes= lds_sims_notification_filter.getitemstring(i,'Notes')
				gi_time_interval= lds_sims_notification_filter.getitemnumber(i,'Time_Interval')
				gs_login= lds_sims_notification_filter.getitemstring(i,'login')
			//next
			//SELECT Project_Id,User_Id,Notification_Flag,Shutdown_Flag,Notes,Time_Interval,login 
			//	into :gs_Projectlist,:gs_Userlist,:gs_NotificationFlag,:gs_ShutdownFlag,:gs_AlertNotes,:gi_time_interval,:gs_login 
			//FROM SIMS_Notification_user with(nolock); 
			// End- Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
			//IF gs_ShutdownFlag ='Y'  and gs_role <> '-1' THEN // Commented this line - Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
			////IF  gs_ShutdownFlag ='Y'   and gs_login ='Y' THEN
			//IF  gs_Userlist =gs_userid and 
			//and gs_login ='Y'
			if upper(gs_Userlist)= upper(gs_userid) then
				If gs_login ='Y'   THEN // Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
					g.of_sims_notification_process( )
					//IF gbLogin =TRUE THEN RETURN
				END IF
			END IF
		Next 
		
// Begin -Dinesh -06/05/2024-  SIMS-473-Google - SIMS – SIMS Timer Enhancement
if gs_Userlist='*ALL' and gs_projectlist='*ALL' then
	lds_sims_notification_filter.dataobject='d_sims_notification_search_all'
	lds_sims_notification_filter.settrans(sqlca)
	lds_sims_notification_filter.retrieve()
	gs_Projectlist= lds_sims_notification_filter.getitemstring(1,'Project_Id')
	gs_Userlist= lds_sims_notification_filter.getitemstring(1,'User_Id')
	gs_NotificationFlag= lds_sims_notification_filter.getitemstring(1,'Notification_Flag')
	gs_ShutdownFlag= lds_sims_notification_filter.getitemstring(1,'Shutdown_Flag')
	gs_AlertNotes= lds_sims_notification_filter.getitemstring(1,'Notes')
	li_time_interval= lds_sims_notification_filter.getitemnumber(1,'Time_Interval')
	gs_login= lds_sims_notification_filter.getitemstring(1,'login')
	if upper(gs_Userlist)= upper(gs_userid) then
		If gs_login ='Y'   THEN // Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement
			g.of_sims_notification_process( )
		//IF gbLogin =TRUE THEN RETURN
		END IF
	End if
  END IF
  //Dinesh -06/11/2024 - SIMS-473- Google - SIMS – SIMS Timer Enhancement
  if gs_projectlist ='PANDORA'  and (upper(gs_Userlist)= upper(gs_userid)) then
			exit;
end if
IF gs_projectlist <> '*ALL' and gs_Userlist <>'*ALL' then
	if (upper(gs_Userlist)= upper(gs_userid)) and (upper(gs_projectlist)=upper(gs_project)) then
			exit;
	end if
End if
if upper(gs_projectlist)  = '*ALL' and gs_Userlist = '*ALL' then
	exit;
end if
if upper(gs_projectlist)  = '*ALL' and (UPPER(gs_Userlist) = UPPER(gs_userid)) then
	exit;
end if
if upper(gs_projectlist)  = upper(gs_project) and (UPPER(gs_Userlist) = '*ALL') then
	exit;
end if
NEXT
// End -Dinesh - 05/22/2024- Dinesh - SIMS-473-Google - SIMS – SIMS Timer Enhancement


//07-Apr-2014 Madhu- SIMS Timer Notification Alert Functionality -END

//10-Sep-2015 :Madhu-  PressKey vs SNScan - START
SELECT User_Updateable_Ind into :gbPressKeySNScan FROM Lookup_Table with(nolock) 
WHERE Project_Id='PANDORA' and Code_Type='PressKeySNScan';
//10-Sep-2015 :Madhu-  PressKey vs SNScan - END

//12-Apr-2017 :Madhu PEVS-424 Stock Transfer Serial No -START
//Enable only for Stock Transfers
SELECT User_Updateable_Ind into :gbPressKeySNScanTransfers FROM Lookup_Table with(nolock) 
WHERE Project_Id='PANDORA' and Code_Type='PressKeySNScan' and Code_Id='StockTransfer';
//12-Apr-2017 :Madhu PEVS-424 Stock Transfer Serial No -END

//14-June-2017 :TAM PEVS-605 -START
//Enable only for Container Scans during Picking
SELECT User_Updateable_Ind into :gbPressKeyContainerScan FROM Lookup_Table with(nolock) 
WHERE Project_Id='PANDORA' and Code_Type='PressKeyContainerScan' and Code_Id='Picking';
//14-June-2017 :TAM PEVS-605 -END

// pvh - 05/01/06 - idle
g.setprojectIdleTime( 0 )
g.setProjectAppTerminateTime( 0 )
IDLE( g.getprojectIdleTime() )
// eom 

	
//Update the Title - include version
// pvh - 04/25/06 - version
// To include Machine name and SPID - /w_main.Title is shifted down // Dinesh - 09/26/2023- SIMS-305- SIMS PIP/SIP - Include Release # in Version Stamp
//w_main.Title = gsTitle + ', Project: ' + gs_project + ', ' + f_getFormattedVersion() // Dinesh - 09/26/2023- SIMS-305- SIMS PIP/SIP - Include Release # in Version Stamp
//w_main.Title = gsTitle + ', Project: ' + gs_project + ', Version: ' + f_get_version()  

// for 3com and the shipments logon issue
if Upper( gs_project ) = '3COM_NASH' then	w_main.Title += ' As: ' + gs_userid

//Added by DGM 09/11/00
//g.is_owner_ind = g.of_get_project_ind()
g.of_get_project_ind()

//Added by DGM 12/15/00 
//For populating datastore to check labels
g.of_get_label() 

//TimA 10/25/12
//Populate custom datawindows sorts
//NOTE:******************************************** 
//If using this for the first time to setup a new DW be sure to read the comments of_get_custom_dw function.
//*************************************************
g.of_get_custom_dw( )

// pvh - 08/18/06 - Load Access Rights
if g.doFunctionRightsRetrieve() < 0 then
	messagebox( is_title, "Unable to Find Access Rights Data.~r~nContact your system Administrator.",exclamation! )
end if

// 12/00 PCONKL - Load available reports for project
Parent.TriggerEvent("ue_load_reports")

// 10/04 - PCONKL - Create Login Entry in USer Log table
g.GetComputerNameA (ls_machine_name, lul_name_size)
lsVersion = f_get_Version() 
g.idt_user_Login_Time = DateTime(Today(),Now()) /* saved so we can re-retrieve and update logout time*/


//TimA 07/23/15 Look for the PBD files for SIMS and compare the dates to the sims-mww.exe file.
lsPbdListFiles = 'ancestors.pbd,china-reports.pbd,common.pbd,DDDW.pbd,delivery-custom.pbd,delivery-dw.pbd,delivery.pbd,inventory-mnt.pbd,maintenance.pbd,receiving.pbd,report-custom.pbd,report.pbd,shipments.pbd,sims_app.pbd,utility.pbd,warehouse.pbd,'
invoGetFileInfo = CREATE nvo_file

lbSetFile = invoGetFileInfo.of_set_File(gs_syspath + 'sims-mww.exe' )
If lbSetFile = true then
	llCountDates  =1
	ldGetSIMSFileDate = invoGetFileInfo.of_get_modified_date( )
Else
	lbSetFile = False
End if

If lbSetFile = True Then
	Do While Pos(lsPbdListFiles, ',') > 1
		SetNull(ldGetPBDDate )
		lsPbdFile = Mid (lsPbdListFiles,1,Pos(lsPbdListFiles, ',') - 1)
		lbSetFile = invoGetFileInfo.of_set_File(gs_syspath + lsPbdFile )
		If lbSetFile = True then
			ldGetPBDDate = invoGetFileInfo.of_get_modified_date( )
		Else
			lbSetFile = False
		End if
		If lbSetFile = True then
			If ldGetPBDDate >= ldGetSIMSFileDate Then
				//In case a PBD is updated after the production realease because of a bug we need to accept that newer file.
				If lsGoodPBD = '' then
					lsGoodPBD = lsGoodPBD + lsPbdFile + '-' + String(ldGetPBDDate)
				Else
					lsGoodPBD = lsGoodPBD + ', ' + lsPbdFile + '-' + String(ldGetPBDDate)
				End if
				llCountDates ++
			Else
				If lsBadPBD = '' then
					lsBadPBD = lsBadPBD + lsPbdFile + '-' + String(ldGetPBDDate)
				Else
					lsBadPBD = lsBadPBD + ', ' + lsPbdFile + '-' + String(ldGetPBDDate)
				End if
			End if
		End if
		lsPbdListFiles = Mid (lsPbdListFiles,Pos(lsPbdListFiles, ',') + 1,Len(lsPbdListFiles))	
	Loop
End if

If lsGoodPBD = '' Then SetNull(lsGoodPBD )
If lsBadPBD = '' Then SetNull(lsBadPBD )

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

Insert Into User_login_History (Project_ID, UserID, Login_Time, Machine_Name, Sims_Version, PBDCount,User_System_Path, SIMS_Exe_FileDate, Good_PBD, Bad_PBD )
				Values	(:gs_project, :ls_userid, :g.idt_user_Login_Time, :ls_machine_name, :lsVersion, :llCountDates, :gs_syspath, :ldGetSIMSFileDate, :lsGoodPBD,:lsBadPBD  )
Using	SQLCA;

Execute Immediate "COMMIT" using SQLCA;

//Begin - 09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
datetime ldt_user_login_Date
long ll_userspid
select top 1 Login_Time into :ldt_user_login_Date  from User_Login_History where UserId=:gs_userid order by Login_Time desc;
select UserSPID into :ll_userspid  from User_Login_History where UserId=:gs_userid and Login_Time=:ldt_user_login_Date;
gl_userspid=ll_userspid
//End - 09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2	

w_main.Title = gsTitle + ',Project: ' + gs_project + ',' + f_getFormattedVersion() + ',UserID: ' + ls_userid + ',Machine: ' + ls_machine_name + ',Session : ' + string(gl_userspid) // Dinesh - 09/26/2023- SIMS-305- SIMS PIP/SIP - Include Release # in Version Stamp

 Opensheet (w_sims_banner, w_main,gi_menu_pos,Original! ) //sarun2014apr09 -Madhu turned off until next cycle
close(parent)
end event

type st_5 from statictext within w_login
integer x = 5
integer y = 20
integer width = 1851
integer height = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Menlo Logistics is now..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_login
integer x = 32
integer y = 460
integer width = 1851
integer height = 112
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Supplier Inventory Management  System"
alignment alignment = center!
boolean focusrectangle = false
end type

