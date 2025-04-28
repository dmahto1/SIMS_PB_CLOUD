HA$PBExportHeader$w_sims_timer.srw
$PBExportComments$+ Added SIMS Timer Setup
forward
global type w_sims_timer from window
end type
type sle_version from singlelineedit within w_sims_timer
end type
type st_2 from statictext within w_sims_timer
end type
type cb_delete from commandbutton within w_sims_timer
end type
type cb_add from commandbutton within w_sims_timer
end type
type sle_custom_msg from singlelineedit within w_sims_timer
end type
type st_message from statictext within w_sims_timer
end type
type st_count_value from statictext within w_sims_timer
end type
type st_count from statictext within w_sims_timer
end type
type st_1 from statictext within w_sims_timer
end type
type rb_no from radiobutton within w_sims_timer
end type
type rb_yes from radiobutton within w_sims_timer
end type
type st_sort from statictext within w_sims_timer
end type
type cb_select_user from commandbutton within w_sims_timer
end type
type cb_cleare_user from commandbutton within w_sims_timer
end type
type cb_clear_project from commandbutton within w_sims_timer
end type
type cb_select_project from commandbutton within w_sims_timer
end type
type cb_close from commandbutton within w_sims_timer
end type
type cb_ok from commandbutton within w_sims_timer
end type
type st_msg_desc from statictext within w_sims_timer
end type
type dw_message_desc from datawindow within w_sims_timer
end type
type dw_message_type from datawindow within w_sims_timer
end type
type st_user from statictext within w_sims_timer
end type
type st_project from statictext within w_sims_timer
end type
type dw_user from datawindow within w_sims_timer
end type
type dw_project from datawindow within w_sims_timer
end type
type gb_project from groupbox within w_sims_timer
end type
type gb_user from groupbox within w_sims_timer
end type
type gb_notification from groupbox within w_sims_timer
end type
type gb_1 from groupbox within w_sims_timer
end type
type gb_custom from groupbox within w_sims_timer
end type
end forward

global type w_sims_timer from window
integer width = 3950
integer height = 2828
boolean titlebar = true
string title = "SIMS Notification Alert"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_projectlist ( )
event ue_userlist ( )
event ue_update_globalvalues ( )
sle_version sle_version
st_2 st_2
cb_delete cb_delete
cb_add cb_add
sle_custom_msg sle_custom_msg
st_message st_message
st_count_value st_count_value
st_count st_count
st_1 st_1
rb_no rb_no
rb_yes rb_yes
st_sort st_sort
cb_select_user cb_select_user
cb_cleare_user cb_cleare_user
cb_clear_project cb_clear_project
cb_select_project cb_select_project
cb_close cb_close
cb_ok cb_ok
st_msg_desc st_msg_desc
dw_message_desc dw_message_desc
dw_message_type dw_message_type
st_user st_user
st_project st_project
dw_user dw_user
dw_project dw_project
gb_project gb_project
gb_user gb_user
gb_notification gb_notification
gb_1 gb_1
gb_custom gb_custom
end type
global w_sims_timer w_sims_timer

type variables
Boolean ib_selectallproject=false
Boolean ib_selectallusers =false
String isSql,isProjectlist,isUserlist

DataWindow idw_project,idw_user,idw_message_type,idw_message_desc
end variables

event ue_projectlist();//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected project list
String lsProjectlist
Integer li_row,li_rowcount
Boolean lb_found_project =false

//Get selected Project List, if it is not concatenated earlier
li_rowcount = idw_project.rowcount( )

FOR li_row=1 to li_rowcount
	IF idw_project.getitemstring(li_row,'c_select') ='Y' THEN
		IF lb_found_project THEN 
			lsProjectlist = lsProjectlist +","
		END IF
		lsProjectlist += "'" + idw_project.getitemstring(li_row,'Project_Id') + "'"
		lb_found_project = true
	END IF
NEXT
	
isProjectlist =	lsProjectlist //Store Project list into Instance variable
end event

event ue_userlist();//09-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected Users List
String lsUSerlist
Integer li_row,li_rowcount
Boolean lb_found_user =false

li_rowcount =idw_user.rowcount( )
FOR li_row =1 to li_rowcount
	IF  idw_user.getitemstring(li_row,'c_select') ='Y' THEN
		IF lb_found_user THEN lsUserlist = lsUserlist +","
		lsUserlist += "'" +idw_user.getitemstring(li_row,'Userid') +"'"
		lb_found_user = true
	END IF
NEXT

isUserlist =lsUserlist //Store user list into Instance variable
end event

event ue_update_globalvalues();//10-APR-2015 Madhu - SIMS Timer Notification Alert Functionality

Integer li_time_interval

gs_Projectlist =idw_message_type.getitemstring(1,'Project_Id')
gs_Userlist	 = idw_message_type.getitemstring(1,'User_Id')
gs_AlertNotes = idw_message_type.getitemstring(1,'Notes')
gs_NotificationFlag = idw_message_type.getitemstring( 1, 'Notification_Flag')
gs_ShutdownFlag = idw_message_type.getitemstring(1,'Shutdown_Flag')

li_time_interval=idw_message_type.getitemnumber( 1, 'Time_Interval')

//IF Time Interval has changed update Global variable and re-call timer based on new Interval.
IF gi_time_interval <> li_time_interval THEN 
	gi_time_interval =li_time_interval;
	w_sims_banner.postEvent('open')
END IF

end event

on w_sims_timer.create
this.sle_version=create sle_version
this.st_2=create st_2
this.cb_delete=create cb_delete
this.cb_add=create cb_add
this.sle_custom_msg=create sle_custom_msg
this.st_message=create st_message
this.st_count_value=create st_count_value
this.st_count=create st_count
this.st_1=create st_1
this.rb_no=create rb_no
this.rb_yes=create rb_yes
this.st_sort=create st_sort
this.cb_select_user=create cb_select_user
this.cb_cleare_user=create cb_cleare_user
this.cb_clear_project=create cb_clear_project
this.cb_select_project=create cb_select_project
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.st_msg_desc=create st_msg_desc
this.dw_message_desc=create dw_message_desc
this.dw_message_type=create dw_message_type
this.st_user=create st_user
this.st_project=create st_project
this.dw_user=create dw_user
this.dw_project=create dw_project
this.gb_project=create gb_project
this.gb_user=create gb_user
this.gb_notification=create gb_notification
this.gb_1=create gb_1
this.gb_custom=create gb_custom
this.Control[]={this.sle_version,&
this.st_2,&
this.cb_delete,&
this.cb_add,&
this.sle_custom_msg,&
this.st_message,&
this.st_count_value,&
this.st_count,&
this.st_1,&
this.rb_no,&
this.rb_yes,&
this.st_sort,&
this.cb_select_user,&
this.cb_cleare_user,&
this.cb_clear_project,&
this.cb_select_project,&
this.cb_close,&
this.cb_ok,&
this.st_msg_desc,&
this.dw_message_desc,&
this.dw_message_type,&
this.st_user,&
this.st_project,&
this.dw_user,&
this.dw_project,&
this.gb_project,&
this.gb_user,&
this.gb_notification,&
this.gb_1,&
this.gb_custom}
end on

on w_sims_timer.destroy
destroy(this.sle_version)
destroy(this.st_2)
destroy(this.cb_delete)
destroy(this.cb_add)
destroy(this.sle_custom_msg)
destroy(this.st_message)
destroy(this.st_count_value)
destroy(this.st_count)
destroy(this.st_1)
destroy(this.rb_no)
destroy(this.rb_yes)
destroy(this.st_sort)
destroy(this.cb_select_user)
destroy(this.cb_cleare_user)
destroy(this.cb_clear_project)
destroy(this.cb_select_project)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.st_msg_desc)
destroy(this.dw_message_desc)
destroy(this.dw_message_type)
destroy(this.st_user)
destroy(this.st_project)
destroy(this.dw_user)
destroy(this.dw_project)
destroy(this.gb_project)
destroy(this.gb_user)
destroy(this.gb_notification)
destroy(this.gb_1)
destroy(this.gb_custom)
end on

event close;close(this);
end event

event open;//07-Apr-2015 Madhu- SIMS Timer Notification Alert Functionality

//Set datawindows
idw_project =dw_project
idw_user=dw_user
idw_message_type =dw_message_type
idw_message_desc =dw_message_desc

//Set transaction object to all Datawindows
idw_project.settransobject( SQLCA);
idw_user.settransobject( SQLCA);
idw_message_type.settransobject( SQLCA);
idw_message_desc.settransobject( SQLCA);

isSql =idw_user.getsqlselect( ) //Get SQL of UserProject

//Retrieve all datawindows one time
idw_project.retrieve()
idw_user.retrieve()
idw_message_type.retrieve()
idw_message_desc.retrieve()

//set with default login version
sle_version.text = f_get_Version()
end event

type sle_version from singlelineedit within w_sims_timer
integer x = 3104
integer y = 556
integer width = 631
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//15-FEB-2016 Madhu SIMS Timer Notification Alert Functionality

//Get selected list of projects from selected list and append those onto User Query.
Integer li_usercount=0
String lsSql,ls_where,lsProjectlist,lsVersion


SetPointer(HourGlass!)
idw_user.dataobject='d_user_project_list_by_version_name'
idw_user.settransobject( SQLCA)

IF idw_user.accepttext( ) =-1 Then return

idw_user.reset( )
lsSql =idw_user.getsqlselect( )

lsVersion =Left(sle_version.text,10) +"%" //6020160101-PROD

IF not ib_selectallproject THEN //If all Projects are not selected then only do the process

	parent.event ue_projectlist( )
	
	ls_where =" WHERE up.Project_ID IN "
	
	IF isProjectlist > ' ' THEN lsSql += ls_where + "(" + isProjectlist + ")"

		lsSql +=  " AND ulh.SIMS_Version < '" + lsVersion+"'  AND ulh.Logout_Time IS NULL"

	idw_user.setsqlselect( lsSql)
	li_usercount =idw_user.retrieve( )

	st_count_value.text =String(li_usercount)
	
END IF

end event

type st_2 from statictext within w_sims_timer
integer x = 2185
integer y = 576
integer width = 919
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Sort users by SIMS Version <"
boolean focusrectangle = false
end type

type cb_delete from commandbutton within w_sims_timer
integer x = 2967
integer y = 2104
integer width = 325
integer height = 116
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&DELETE"
end type

event clicked;//10-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Delete selected row
Integer li_row,li_update

li_row =idw_message_desc.getselectedrow( 0)
idw_message_desc.deleterow( li_row)
idw_message_desc.update()


end event

type cb_add from commandbutton within w_sims_timer
integer x = 2967
integer y = 2340
integer width = 325
integer height = 116
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&ADD"
end type

event clicked;//10-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Insert new customer message into SIMS_Notification_Message Table.
String ls_msg_desc,lsFind
Integer li_rowcount,li_row

ls_msg_desc = sle_custom_msg.text

li_rowcount =idw_message_desc.rowcount( )

lsFind ="Msg_Desc ='"+ls_msg_desc+"'"
li_row =idw_message_desc.find( lsFind, 0, li_rowcount)

IF li_row =0 and ls_msg_desc >' ' THEN //Don't allow to insert duplicate Messages.
	idw_message_desc.insertrow( 0)
	idw_message_desc.setitem(li_rowcount+1,'Msg_Id',li_rowcount+1)
	idw_message_desc.setitem(li_rowcount+1,'Msg_Desc',ls_msg_desc)
END IF

sle_custom_msg.text='' //Once it is added, clear the TEXT
end event

type sle_custom_msg from singlelineedit within w_sims_timer
integer x = 457
integer y = 2384
integer width = 2272
integer height = 100
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type st_message from statictext within w_sims_timer
integer x = 37
integer y = 2384
integer width = 425
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Message Desc"
boolean focusrectangle = false
end type

type st_count_value from statictext within w_sims_timer
integer x = 1998
integer y = 760
integer width = 357
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type st_count from statictext within w_sims_timer
integer x = 1801
integer y = 760
integer width = 215
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "count"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sims_timer
integer x = 837
integer y = 20
integer width = 1847
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "SIMS Notification Alert"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_no from radiobutton within w_sims_timer
integer x = 1943
integer y = 564
integer width = 293
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

event clicked;//08-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Don't sort by Project Id, list all users.
Integer li_usercount=0
String lsSql

lsSql =isSql
idw_user.setsqlselect( lsSql)
li_usercount =idw_user.retrieve( )
st_count_value.text =String(li_usercount)

end event

type rb_yes from radiobutton within w_sims_timer
integer x = 1669
integer y = 564
integer width = 247
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Yes"
end type

event clicked;//07-APR-2015 Madhu SIMS Timer Notification Alert Functionality

//Get selected list of projects from selected list and append those onto User Query.
Integer li_usercount=0
String lsSql,ls_where,lsProjectlist


SetPointer(HourGlass!)

IF idw_user.accepttext( ) =-1 Then return

idw_user.reset( )
lsSql =isSql

IF not ib_selectallproject THEN //If all Projects are not selected then only do the process

	parent.event ue_projectlist( )

	ls_where =" WHERE Project_ID IN "
	
	IF isProjectlist > ' ' THEN lsSql += ls_where + "(" + isProjectlist + ")"
	
	idw_user.setsqlselect( lsSql)
	li_usercount =idw_user.retrieve( )

	st_count_value.text =String(li_usercount)
	
END IF

end event

type st_sort from statictext within w_sims_timer
integer x = 37
integer y = 564
integer width = 1586
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Do you want to sort users by selected Project List?"
boolean focusrectangle = false
end type

type cb_select_user from commandbutton within w_sims_timer
integer x = 1175
integer y = 744
integer width = 425
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All Users"
end type

event clicked;integer li_row,li_rowcount

ib_selectallusers =True //If select all users

li_rowcount =idw_user.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_user.setitem( li_row, 'c_select', 'Y') //Set Flag =Y to all users.
NEXT






end event

type cb_cleare_user from commandbutton within w_sims_timer
integer x = 1175
integer y = 868
integer width = 425
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear All Users"
end type

event clicked;integer li_row,li_rowcount


li_rowcount =idw_user.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_user.setitem( li_row, 'c_select', 'N') //Set Flag =N to all users.
NEXT






end event

type cb_clear_project from commandbutton within w_sims_timer
integer x = 1175
integer y = 304
integer width = 494
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear All Projects"
end type

event clicked;integer li_row,li_rowcount


li_rowcount =idw_project.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_project.setitem( li_row, 'c_select', 'N') //Set Flag =N to all projects.
NEXT






end event

type cb_select_project from commandbutton within w_sims_timer
integer x = 1175
integer y = 184
integer width = 494
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All Projects"
end type

event clicked;integer li_row,li_rowcount

ib_selectallproject =true //IF select all project is clicked set boolean variable to true

li_rowcount =idw_project.rowcount( ) //Get total row count
For li_row=1 to li_rowcount
	idw_project.setitem( li_row, 'c_select', 'Y') //Set Flag =Y to all projects.
NEXT






end event

type cb_close from commandbutton within w_sims_timer
integer x = 1687
integer y = 2612
integer width = 393
integer height = 124
integer taborder = 60
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;parent.event close( )
end event

type cb_ok from commandbutton within w_sims_timer
integer x = 1051
integer y = 2612
integer width = 393
integer height = 124
integer taborder = 50
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//07-APR-2015 Madhu SIMS Timer Notification Alert Functionality

/*Case 	a. If "SelectAllProjects" =TRUE 	and 	"SelectAllUsers" = TRUE 	then set "User ID" value to default value as "*ALL"
			b. If "SelectAllProjects" =TRUE 	and 	"SelectAllUsers" = FALSE	then set "User ID" value to default value as "*ALL"
			c. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = TRUE 	then set "User ID" value to default value as "*ALL"
			d. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = FALSE (none of users selected) 	then set "User ID" value to default value as "*ALL"
			e. If "SelectAllProjects" =FALSE 	and 	"SelectAllUsers" = FALSE (some of users selected)	 then set "User ID" value to "Selected Users"
*/

Integer li_row
String ls_notification,ls_shutdown,is_title

SetPointer(Hourglass!)

idw_message_type.accepttext( )
idw_message_desc.accepttext( )

//Get selected Project List
parent.event ue_projectlist( )

//Set Project Id value
IF ib_selectallproject =FALSE and len(isProjectlist) > 0 THEN
	idw_message_type.setitem(1,'Project_Id',isProjectlist) //Set selected Project list
ELSE
	idw_message_type.setitem( 1, 'Project_Id', '*ALL') //Set default value as '*ALL'
END IF

//Get selected User List
parent.event ue_userlist( )

//Set User Id value
IF  (ib_selectallproject= FALSE and ib_selectallusers =FALSE and len(isUserlist) > 0) THEN
		idw_message_type.setitem(1,'User_Id',isUserlist)
	ELSE
		idw_message_type.setitem(1,'User_Id','*ALL')
END IF

//Set Last User Id value
idw_message_type.setitem(1,'Last_User',gs_userid)

//Get Alert Flag values
ls_notification = idw_message_type.getitemstring(1,'Notification_Flag')
ls_shutdown = idw_message_type.getitemstring(1,'Shutdown_Flag')

//Set End Time, if all Notification Flag's are Turned OFF
IF ls_notification ='N' and ls_shutdown ='N' THEN 	idw_message_type.setitem( 1, 'End_Time', DateTime(Today(),Now()))

//update SIMS_Notification & SIMS_Notification_Message Table
Execute Immediate "Begin Transaction" using SQLCA;
SQLCA.DBParm = "disablebind =0"
li_row =idw_message_type.update( false,false) 
li_row =idw_message_desc.update( false, false)
SQLCA.DBParm = "disablebind =1"

IF li_row = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	
	IF Sqlca.Sqlcode = 0 THEN
		idw_message_type.resetupdate( )
		idw_message_desc.resetupdate( )
		Return 0
	ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
	END IF
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF
end event

type st_msg_desc from statictext within w_sims_timer
integer x = 37
integer y = 1960
integer width = 416
integer height = 112
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Message Desc:"
boolean focusrectangle = false
end type

type dw_message_desc from datawindow within w_sims_timer
integer x = 457
integer y = 1940
integer width = 2313
integer height = 292
integer taborder = 40
string title = "none"
string dataobject = "d_sims_alert_message_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.SelectRow(0, false)
This.SelectRow(row, true)
end event

type dw_message_type from datawindow within w_sims_timer
integer x = 41
integer y = 1188
integer width = 2843
integer height = 568
integer taborder = 30
string title = "none"
string dataobject = "d_sims_alert_type"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type st_user from statictext within w_sims_timer
integer x = 37
integer y = 796
integer width = 416
integer height = 88
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "User Name:"
boolean focusrectangle = false
end type

type st_project from statictext within w_sims_timer
integer x = 37
integer y = 240
integer width = 425
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Project"
boolean focusrectangle = false
end type

type dw_user from datawindow within w_sims_timer
integer x = 457
integer y = 752
integer width = 677
integer height = 292
integer taborder = 20
string title = "none"
string dataobject = "d_user_project_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_project from datawindow within w_sims_timer
integer x = 457
integer y = 184
integer width = 677
integer height = 292
integer taborder = 10
string title = "none"
string dataobject = "d_assign_user_project"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_project from groupbox within w_sims_timer
integer x = 14
integer y = 124
integer width = 1710
integer height = 372
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Project List"
end type

type gb_user from groupbox within w_sims_timer
integer x = 14
integer y = 692
integer width = 1710
integer height = 372
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "User List"
end type

type gb_notification from groupbox within w_sims_timer
integer x = 9
integer y = 1112
integer width = 2930
integer height = 652
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Notification Type"
end type

type gb_1 from groupbox within w_sims_timer
integer x = 9
integer y = 1832
integer width = 2926
integer height = 424
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Notification Message Details"
end type

type gb_custom from groupbox within w_sims_timer
integer x = 9
integer y = 2300
integer width = 2926
integer height = 220
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8388608
long backcolor = 67108864
string text = "Custom Message"
end type

