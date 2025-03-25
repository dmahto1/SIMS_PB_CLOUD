HA$PBExportHeader$w_select_import_file.srw
$PBExportComments$allow to pick a defaulted file to import
forward
global type w_select_import_file from window
end type
type cb_1 from commandbutton within w_select_import_file
end type
type cb_cancel from commandbutton within w_select_import_file
end type
type cb_ok from commandbutton within w_select_import_file
end type
type sle_file from singlelineedit within w_select_import_file
end type
end forward

global type w_select_import_file from window
integer width = 2016
integer height = 356
boolean titlebar = true
string title = "Import File:"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_getfile ( )
cb_1 cb_1
cb_cancel cb_cancel
cb_ok cb_ok
sle_file sle_file
end type
global w_select_import_file w_select_import_file

type variables
str_Parms	istrparms
end variables

event ue_getfile;
Integer	liRC
String	lsPAth,	&
			lsFile

liRC = getFileOpenName("Select FIle to Import",lsPath, lsFile,"TXT","Text Files (*.TXT),*.TXT,")
	
If lsPAth > '' Then
	sle_file.Text = lsPath
End If
end event

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

sle_file.Text = Istrparms.String_arg[1]


end event

on w_select_import_file.create
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_file=create sle_file
this.Control[]={this.cb_1,&
this.cb_cancel,&
this.cb_ok,&
this.sle_file}
end on

on w_select_import_file.destroy
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_file)
end on

event closequery;
If IstrPArms.Cancelled Then
	IstrParms.String_arg[1] = ''
Else
	//Make sure file exists
	If not FileExists(sle_file.Text) Then
		Messagebox('Import File','This file does not exist.')
		Return 1
	End If
	Istrparms.String_arg[1] = sle_file.Text
End If

Message.PowerObjectParm = Istrparms


end event

type cb_1 from commandbutton within w_select_import_file
integer x = 151
integer y = 156
integer width = 256
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Find..."
end type

event clicked;Parent.TriggerEvent('ue_getfile')
end event

type cb_cancel from commandbutton within w_select_import_file
integer x = 1637
integer y = 156
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

type cb_ok from commandbutton within w_select_import_file
integer x = 965
integer y = 156
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

type sle_file from singlelineedit within w_select_import_file
integer x = 55
integer y = 20
integer width = 1883
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

