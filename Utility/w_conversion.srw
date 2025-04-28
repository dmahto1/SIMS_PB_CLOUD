HA$PBExportHeader$w_conversion.srw
forward
global type w_conversion from window
end type
type st_conversion_kilos from statictext within w_conversion
end type
type st_conversion_pounds from statictext within w_conversion
end type
type sle_kilos from singlelineedit within w_conversion
end type
type sle_pounds from singlelineedit within w_conversion
end type
type sle_feets from singlelineedit within w_conversion
end type
type st_conversion_feet from statictext within w_conversion
end type
type st_conversion_meter from statictext within w_conversion
end type
type st_conversion_centimeters from statictext within w_conversion
end type
type st_conversion_inches from statictext within w_conversion
end type
type sle_meters from singlelineedit within w_conversion
end type
type sle_centimeters from singlelineedit within w_conversion
end type
type sle_inches from singlelineedit within w_conversion
end type
type gb_conversion_metric from groupbox within w_conversion
end type
type gb_conversion_english from groupbox within w_conversion
end type
end forward

global type w_conversion from window
integer x = 823
integer y = 360
integer width = 2368
integer height = 1208
boolean titlebar = true
string title = "Conversions"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 79741120
st_conversion_kilos st_conversion_kilos
st_conversion_pounds st_conversion_pounds
sle_kilos sle_kilos
sle_pounds sle_pounds
sle_feets sle_feets
st_conversion_feet st_conversion_feet
st_conversion_meter st_conversion_meter
st_conversion_centimeters st_conversion_centimeters
st_conversion_inches st_conversion_inches
sle_meters sle_meters
sle_centimeters sle_centimeters
sle_inches sle_inches
gb_conversion_metric gb_conversion_metric
gb_conversion_english gb_conversion_english
end type
global w_conversion w_conversion

type variables
n_warehouse i_nwarehouse
end variables

on w_conversion.create
this.st_conversion_kilos=create st_conversion_kilos
this.st_conversion_pounds=create st_conversion_pounds
this.sle_kilos=create sle_kilos
this.sle_pounds=create sle_pounds
this.sle_feets=create sle_feets
this.st_conversion_feet=create st_conversion_feet
this.st_conversion_meter=create st_conversion_meter
this.st_conversion_centimeters=create st_conversion_centimeters
this.st_conversion_inches=create st_conversion_inches
this.sle_meters=create sle_meters
this.sle_centimeters=create sle_centimeters
this.sle_inches=create sle_inches
this.gb_conversion_metric=create gb_conversion_metric
this.gb_conversion_english=create gb_conversion_english
this.Control[]={this.st_conversion_kilos,&
this.st_conversion_pounds,&
this.sle_kilos,&
this.sle_pounds,&
this.sle_feets,&
this.st_conversion_feet,&
this.st_conversion_meter,&
this.st_conversion_centimeters,&
this.st_conversion_inches,&
this.sle_meters,&
this.sle_centimeters,&
this.sle_inches,&
this.gb_conversion_metric,&
this.gb_conversion_english}
end on

on w_conversion.destroy
destroy(this.st_conversion_kilos)
destroy(this.st_conversion_pounds)
destroy(this.sle_kilos)
destroy(this.sle_pounds)
destroy(this.sle_feets)
destroy(this.st_conversion_feet)
destroy(this.st_conversion_meter)
destroy(this.st_conversion_centimeters)
destroy(this.st_conversion_inches)
destroy(this.sle_meters)
destroy(this.sle_centimeters)
destroy(this.sle_inches)
destroy(this.gb_conversion_metric)
destroy(this.gb_conversion_english)
end on

event open;i_nwarehouse =Create n_warehouse
end event

event close;destroy n_warehouse
end event

type st_conversion_kilos from statictext within w_conversion
integer x = 1175
integer y = 548
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Kilos"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_conversion_pounds from statictext within w_conversion
integer x = 178
integer y = 576
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Pounds"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_kilos from singlelineedit within w_conversion
integer x = 1650
integer y = 552
integer width = 480
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;sle_pounds.text= string(round(i_nwarehouse.of_convert(real(sle_kilos.text),'KG','PO'),4))
end event

type sle_pounds from singlelineedit within w_conversion
integer x = 466
integer y = 552
integer width = 480
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;sle_kilos.text= string(round(i_nwarehouse.of_convert(real(sle_pounds.text),'PO','KG'),4))
end event

type sle_feets from singlelineedit within w_conversion
integer x = 466
integer y = 436
integer width = 480
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;sle_meters.text= string(round(i_nwarehouse.of_convert(real(sle_feets.text),'FT','M'),4))
end event

type st_conversion_feet from statictext within w_conversion
integer x = 178
integer y = 452
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Feet"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_conversion_meter from statictext within w_conversion
integer x = 1175
integer y = 440
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Meter"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_conversion_centimeters from statictext within w_conversion
integer x = 1175
integer y = 332
integer width = 361
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Centimeters"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_conversion_inches from statictext within w_conversion
integer x = 178
integer y = 328
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Inches"
boolean focusrectangle = false
end type

event constructor;

g.of_check_label_button(this)
end event

type sle_meters from singlelineedit within w_conversion
integer x = 1650
integer y = 436
integer width = 480
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;sle_feets.text= string(round(i_nwarehouse.of_convert(real(sle_meters.text),'M','FT'),4))
end event

type sle_centimeters from singlelineedit within w_conversion
integer x = 1650
integer y = 320
integer width = 480
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;sle_inches.text= string(round(i_nwarehouse.of_convert(real(sle_centimeters.text),'CM','IN'),4))
end event

type sle_inches from singlelineedit within w_conversion
integer x = 466
integer y = 320
integer width = 480
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;//Call function from n_warehouse
//sle_meters.text=string(i_nwarehouse.of_convert(real(sle_inches.text),'CM','M'))
sle_centimeters.text= string(round(i_nwarehouse.of_convert(real(sle_inches.text),'IN','CM'),4))
end event

type gb_conversion_metric from groupbox within w_conversion
integer x = 1147
integer y = 164
integer width = 1079
integer height = 580
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Metric"
end type

event constructor;
g.of_check_label_button(this)
end event

type gb_conversion_english from groupbox within w_conversion
integer x = 55
integer y = 164
integer width = 1079
integer height = 580
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "English"
end type

event constructor;
g.of_check_label_button(this)
end event

