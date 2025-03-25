$PBExportHeader$w_user_history.srw
forward
global type w_user_history from window
end type
type dw_1 from datawindow within w_user_history
end type
end forward

global type w_user_history from window
integer width = 4965
integer height = 1336
boolean titlebar = true
string title = "User History"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_1 dw_1
end type
global w_user_history w_user_history

on w_user_history.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_user_history.destroy
destroy(this.dw_1)
end on

event open;string lsorderno,  lsuserid
Datetime ld_min, ld_max 


dw_1.settransobject(SQLCA)

str_parms  lstrparms
lstrparms = message.PowerobjectParm

lsuserid=lstrparms.String_Arg[1] 
ld_min =lstrparms.Datetime_Arg[2]
ld_max =lstrparms.Datetime_Arg[3]

dw_1.Retrieve(lsuserid, ld_min,ld_max, gs_project)
if (dw_1.rowcount() = 0) then 
	Return 
end if 


end event

type dw_1 from datawindow within w_user_history
integer width = 4942
integer height = 1240
integer taborder = 10
string title = "none"
string dataobject = "d_user_login_history"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

