HA$PBExportHeader$w_staging_location.srw
forward
global type w_staging_location from window
end type
type sle_staging_location from singlelineedit within w_staging_location
end type
type cb_1 from commandbutton within w_staging_location
end type
type st_1 from statictext within w_staging_location
end type
end forward

global type w_staging_location from window
integer width = 1925
integer height = 568
boolean titlebar = true
string title = "Enter Staging Location"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_staging_location sle_staging_location
cb_1 cb_1
st_1 st_1
end type
global w_staging_location w_staging_location

on w_staging_location.create
this.sle_staging_location=create sle_staging_location
this.cb_1=create cb_1
this.st_1=create st_1
this.Control[]={this.sle_staging_location,&
this.cb_1,&
this.st_1}
end on

on w_staging_location.destroy
destroy(this.sle_staging_location)
destroy(this.cb_1)
destroy(this.st_1)
end on

type sle_staging_location from singlelineedit within w_staging_location
integer x = 745
integer y = 80
integer width = 1065
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_staging_location
integer x = 699
integer y = 276
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;
string ls_staging_location

ls_staging_location =  sle_staging_location.text

CloseWithReturn (parent,ls_staging_location)
end event

type st_1 from statictext within w_staging_location
integer x = 41
integer y = 88
integer width = 631
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Staging Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

