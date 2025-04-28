$PBExportHeader$w_export_file_append_replace.srw
$PBExportComments$Prompt for replace or append of existing file on export
forward
global type w_export_file_append_replace from window
end type
type rb_replace from radiobutton within w_export_file_append_replace
end type
type rb_append from radiobutton within w_export_file_append_replace
end type
type cb_cancel from commandbutton within w_export_file_append_replace
end type
type cb_ok from commandbutton within w_export_file_append_replace
end type
type gb_1 from groupbox within w_export_file_append_replace
end type
end forward

global type w_export_file_append_replace from window
integer width = 814
integer height = 536
boolean titlebar = true
string title = "Append or Replace File"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
rb_replace rb_replace
rb_append rb_append
cb_cancel cb_cancel
cb_ok cb_ok
gb_1 gb_1
end type
global w_export_file_append_replace w_export_file_append_replace

type variables
str_Parms	istrparms
end variables

event open;
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

Istrparms = Message.PowerobjectParm

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

rb_append.Checked = True




end event

on w_export_file_append_replace.create
this.rb_replace=create rb_replace
this.rb_append=create rb_append
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.Control[]={this.rb_replace,&
this.rb_append,&
this.cb_cancel,&
this.cb_ok,&
this.gb_1}
end on

on w_export_file_append_replace.destroy
destroy(this.rb_replace)
destroy(this.rb_append)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

event closequery;
If IstrPArms.Cancelled Then
	IstrParms.String_arg[1] = ''
Else
	If rb_Append.Checked Then
		istrparms.String_arg[1] = 'A'
	Else
		istrparms.String_arg[1] = 'R'
	End If
End If

Message.PowerObjectParm = Istrparms


end event

type rb_replace from radiobutton within w_export_file_append_replace
integer x = 210
integer y = 168
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Replace"
borderstyle borderstyle = stylelowered!
end type

type rb_append from radiobutton within w_export_file_append_replace
integer x = 210
integer y = 84
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Append"
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_export_file_append_replace
integer x = 453
integer y = 316
integer width = 256
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
Istrparms.Cancelled = True
Close(Parent)
end event

type cb_ok from commandbutton within w_export_file_append_replace
integer x = 114
integer y = 316
integer width = 256
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
Close(Parent)
end event

type gb_1 from groupbox within w_export_file_append_replace
integer x = 142
integer y = 52
integer width = 521
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

