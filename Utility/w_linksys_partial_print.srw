HA$PBExportHeader$w_linksys_partial_print.srw
forward
global type w_linksys_partial_print from window
end type
type st_sku from statictext within w_linksys_partial_print
end type
type st_3 from statictext within w_linksys_partial_print
end type
type st_2 from statictext within w_linksys_partial_print
end type
type st_1 from statictext within w_linksys_partial_print
end type
type sle_weight from singlelineedit within w_linksys_partial_print
end type
type sle_qty from singlelineedit within w_linksys_partial_print
end type
type cb_2 from commandbutton within w_linksys_partial_print
end type
type cb_1 from commandbutton within w_linksys_partial_print
end type
end forward

global type w_linksys_partial_print from window
integer width = 1646
integer height = 832
boolean titlebar = true
string title = "Partial Label Definition"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_sku st_sku
st_3 st_3
st_2 st_2
st_1 st_1
sle_weight sle_weight
sle_qty sle_qty
cb_2 cb_2
cb_1 cb_1
end type
global w_linksys_partial_print w_linksys_partial_print

type variables

Str_parms	istrparms
end variables

event open;
istrparms = message.PowerObjectParm



if len(istrparms.String_arg[40]) > 0 then
	st_sku.text = istrparms.String_arg[40]
end if


if istrparms.Long_arg[10] > 0 then
	sle_qty.text = string(istrparms.Long_arg[10])
end if

if istrparms.Long_arg[11] > 0 then
	sle_weight.text = string(istrparms.Long_arg[11])
end if

end event

on w_linksys_partial_print.create
this.st_sku=create st_sku
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_weight=create sle_weight
this.sle_qty=create sle_qty
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_sku,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_weight,&
this.sle_qty,&
this.cb_2,&
this.cb_1}
end on

on w_linksys_partial_print.destroy
destroy(this.st_sku)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_weight)
destroy(this.sle_qty)
destroy(this.cb_2)
destroy(this.cb_1)
end on

type st_sku from statictext within w_linksys_partial_print
integer x = 686
integer y = 84
integer width = 827
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_linksys_partial_print
integer x = 247
integer y = 84
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_linksys_partial_print
integer x = 247
integer y = 408
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Weight:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_linksys_partial_print
integer x = 247
integer y = 232
integer width = 343
integer height = 56
integer textsize = -8
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

type sle_weight from singlelineedit within w_linksys_partial_print
integer x = 686
integer y = 388
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type sle_qty from singlelineedit within w_linksys_partial_print
integer x = 686
integer y = 212
integer width = 343
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
boolean hideselection = false
end type

type cb_2 from commandbutton within w_linksys_partial_print
integer x = 896
integer y = 600
integer width = 402
integer height = 112
integer taborder = 40
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
istrparms.cancelled = true

CloseWithReturn( parent, istrparms)
end event

type cb_1 from commandbutton within w_linksys_partial_print
integer x = 334
integer y = 600
integer width = 402
integer height = 112
integer taborder = 30
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
if trim(sle_qty.text) = '' then sle_qty.text = "0"
if trim(sle_weight.text) = '' then sle_weight.text = "0"

istrparms.Long_arg[10] = long(sle_qty.text)
istrparms.Long_arg[11] = double(sle_weight.text)


CloseWithReturn( parent, istrparms)
end event

