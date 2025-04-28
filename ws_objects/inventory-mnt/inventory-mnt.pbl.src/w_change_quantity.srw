$PBExportHeader$w_change_quantity.srw
forward
global type w_change_quantity from window
end type
type em_quantity from editmask within w_change_quantity
end type
type st_1 from statictext within w_change_quantity
end type
type cb_2 from commandbutton within w_change_quantity
end type
type cb_1 from commandbutton within w_change_quantity
end type
end forward

global type w_change_quantity from window
integer width = 1125
integer height = 620
boolean titlebar = true
string title = "Change Quantity"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
em_quantity em_quantity
st_1 st_1
cb_2 cb_2
cb_1 cb_1
end type
global w_change_quantity w_change_quantity

on w_change_quantity.create
this.em_quantity=create em_quantity
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.em_quantity,&
this.st_1,&
this.cb_2,&
this.cb_1}
end on

on w_change_quantity.destroy
destroy(this.em_quantity)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;
str_parms	lstrparms

lstrparms = message.PowerObjectParm

em_quantity.text = string(lstrparms.Decimal_arg[1]) 
end event

type em_quantity from editmask within w_change_quantity
integer x = 425
integer y = 76
integer width = 581
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#########"
end type

type st_1 from statictext within w_change_quantity
integer x = 87
integer y = 100
integer width = 297
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Quantity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_change_quantity
integer x = 603
integer y = 340
integer width = 425
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(parent)
end event

type cb_1 from commandbutton within w_change_quantity
integer x = 91
integer y = 340
integer width = 425
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
str_parms	lstrparms


IF long(em_quantity.text ) <= 0 THEN
	
	MessageBox ("Error", "Must be greater than 0.")
	
END IF

lstrparms.Decimal_arg[1]  = long(em_quantity.text )

CloseWithReturn(parent, lstrparms)
end event

