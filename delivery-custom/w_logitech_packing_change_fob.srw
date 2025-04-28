HA$PBExportHeader$w_logitech_packing_change_fob.srw
forward
global type w_logitech_packing_change_fob from window
end type
type sle_fob from singlelineedit within w_logitech_packing_change_fob
end type
type st_1 from statictext within w_logitech_packing_change_fob
end type
type cb_2 from commandbutton within w_logitech_packing_change_fob
end type
type cb_1 from commandbutton within w_logitech_packing_change_fob
end type
end forward

global type w_logitech_packing_change_fob from window
integer width = 1184
integer height = 568
boolean titlebar = true
string title = "Change FOB"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_fob sle_fob
st_1 st_1
cb_2 cb_2
cb_1 cb_1
end type
global w_logitech_packing_change_fob w_logitech_packing_change_fob

on w_logitech_packing_change_fob.create
this.sle_fob=create sle_fob
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.sle_fob,&
this.st_1,&
this.cb_2,&
this.cb_1}
end on

on w_logitech_packing_change_fob.destroy
destroy(this.sle_fob)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;
sle_fob.text = message.StringParm
end event

type sle_fob from singlelineedit within w_logitech_packing_change_fob
integer x = 352
integer y = 120
integer width = 704
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_logitech_packing_change_fob
integer x = 69
integer y = 140
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "FOB:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_logitech_packing_change_fob
integer x = 631
integer y = 308
integer width = 315
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
CloseWithReturn(parent, "**CANCEL**")
end event

type cb_1 from commandbutton within w_logitech_packing_change_fob
integer x = 256
integer y = 308
integer width = 315
integer height = 96
integer taborder = 10
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
string ls_fob

ls_fob = sle_fob.text

CloseWithReturn( parent, ls_fob)
end event

