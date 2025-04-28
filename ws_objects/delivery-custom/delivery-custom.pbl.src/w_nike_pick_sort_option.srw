$PBExportHeader$w_nike_pick_sort_option.srw
forward
global type w_nike_pick_sort_option from window
end type
type rb_sku from radiobutton within w_nike_pick_sort_option
end type
type rb_location from radiobutton within w_nike_pick_sort_option
end type
type cb_2 from commandbutton within w_nike_pick_sort_option
end type
type cb_1 from commandbutton within w_nike_pick_sort_option
end type
type gb_1 from groupbox within w_nike_pick_sort_option
end type
end forward

global type w_nike_pick_sort_option from window
integer width = 1381
integer height = 800
boolean titlebar = true
string title = "Pick List - Sort By"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
rb_sku rb_sku
rb_location rb_location
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
end type
global w_nike_pick_sort_option w_nike_pick_sort_option

on w_nike_pick_sort_option.create
this.rb_sku=create rb_sku
this.rb_location=create rb_location
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.rb_sku,&
this.rb_location,&
this.cb_2,&
this.cb_1,&
this.gb_1}
end on

on w_nike_pick_sort_option.destroy
destroy(this.rb_sku)
destroy(this.rb_location)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type rb_sku from radiobutton within w_nike_pick_sort_option
integer x = 530
integer y = 260
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
string text = "Sku"
end type

type rb_location from radiobutton within w_nike_pick_sort_option
integer x = 530
integer y = 172
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
string text = "Location"
boolean checked = true
end type

type cb_2 from commandbutton within w_nike_pick_sort_option
integer x = 187
integer y = 500
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
if rb_location.checked then
	CloseWithReturn(Parent, 'L')	
else
	CloseWithReturn(Parent, 'S')
end if


end event

type cb_1 from commandbutton within w_nike_pick_sort_option
integer x = 782
integer y = 500
integer width = 402
integer height = 112
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
CloseWithReturn(parent, 'C')
end event

type gb_1 from groupbox within w_nike_pick_sort_option
integer x = 192
integer y = 52
integer width = 983
integer height = 352
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sort By"
end type

