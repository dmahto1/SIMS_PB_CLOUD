HA$PBExportHeader$w_password.srw
forward
global type w_password from window
end type
type sle_con_pass from singlelineedit within w_password
end type
type sle_new_pass from singlelineedit within w_password
end type
type sle_old_pass from singlelineedit within w_password
end type
type cb_cancel from commandbutton within w_password
end type
type cb_ok from commandbutton within w_password
end type
type st_3 from statictext within w_password
end type
type st_2 from statictext within w_password
end type
type st_1 from statictext within w_password
end type
end forward

global type w_password from window
integer width = 1358
integer height = 820
boolean titlebar = true
string title = "Change Password"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
sle_con_pass sle_con_pass
sle_new_pass sle_new_pass
sle_old_pass sle_old_pass
cb_cancel cb_cancel
cb_ok cb_ok
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_password w_password

type variables
m_simple_record curr_menu
Boolean record_changed
Boolean update_success
String win_title
end variables

on w_password.create
this.sle_con_pass=create sle_con_pass
this.sle_new_pass=create sle_new_pass
this.sle_old_pass=create sle_old_pass
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.sle_con_pass,&
this.sle_new_pass,&
this.sle_old_pass,&
this.cb_cancel,&
this.cb_ok,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_password.destroy
destroy(this.sle_con_pass)
destroy(this.sle_new_pass)
destroy(this.sle_old_pass)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;curr_menu = This.MenuId
win_title = This.Title

This.move(0,0)




end event

type sle_con_pass from singlelineedit within w_password
integer x = 663
integer y = 356
integer width = 475
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type sle_new_pass from singlelineedit within w_password
integer x = 663
integer y = 236
integer width = 475
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type sle_old_pass from singlelineedit within w_password
integer x = 663
integer y = 116
integer width = 475
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_password
integer x = 699
integer y = 544
integer width = 329
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

type cb_ok from commandbutton within w_password
integer x = 288
integer y = 544
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;String ls_new_pass, ls_con_pass, ls_old_pass, ls_sys_pass

ls_new_pass = Trim(sle_new_pass.Text)
ls_con_pass = Trim(sle_con_pass.Text)
ls_old_pass = Trim(sle_old_pass.Text)

Select passwd Into :ls_sys_pass From UserTable Where UserID = :gs_userid;
If Upper(ls_sys_pass) <> ls_old_pass Then
	MessageBox(win_title, "Invalid old password!")
	sle_old_pass.SetFocus()
	Return
End If

If ls_new_pass <> ls_con_pass Then
	MessageBox(win_title, "Passwords do not match!")
	sle_new_pass.SetFocus()
	Return
End If

Update UserTable Set passwd = :ls_con_pass Where userid = :gs_userid;
IF Sqlca.Sqlcode = 0 THEN
	SetMicroHelp("Password Changed!")
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
   MessageBox(win_title, SQLCA.SQLErrText, Information!)
END IF

Close(Parent)

end event

type st_3 from statictext within w_password
integer x = 119
integer y = 364
integer width = 530
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Confirm Password :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_password
integer x = 206
integer y = 244
integer width = 443
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "New Password :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_password
integer x = 210
integer y = 124
integer width = 439
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Old Password :"
alignment alignment = right!
boolean focusrectangle = false
end type

