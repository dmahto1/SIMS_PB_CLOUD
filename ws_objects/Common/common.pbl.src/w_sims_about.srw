$PBExportHeader$w_sims_about.srw
$PBExportComments$Sims About Screen
forward
global type w_sims_about from window
end type
type st_3 from statictext within w_sims_about
end type
type st_2 from statictext within w_sims_about
end type
type st_1 from statictext within w_sims_about
end type
type p_1 from picture within w_sims_about
end type
type p_plash from picture within w_sims_about
end type
end forward

global type w_sims_about from window
integer x = 823
integer y = 360
integer width = 1399
integer height = 844
boolean titlebar = true
string title = "About SIMS"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 16777215
st_3 st_3
st_2 st_2
st_1 st_1
p_1 p_1
p_plash p_plash
end type
global w_sims_about w_sims_about

event open;
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

// pvh - 04/25/06 - version
This.Title = 'About SIMS - ' + f_getFormattedVersion()
//This.Title = 'About SIMS - Version: ' + f_get_version()
end event

on w_sims_about.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.p_1=create p_1
this.p_plash=create p_plash
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.p_1,&
this.p_plash}
end on

on w_sims_about.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.p_plash)
end on

type st_3 from statictext within w_sims_about
string tag = "[DL] MLG SIMS"
integer x = 137
integer y = 680
integer width = 1093
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
string text = "mlg_support@cnf.com"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_sims_about
integer x = 137
integer y = 632
integer width = 1093
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
string text = " 888-967-1151 "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sims_about
integer x = 137
integer y = 568
integer width = 1093
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
string text = "For Support:"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_sims_about
integer x = 517
integer y = 32
integer width = 329
integer height = 288
boolean originalsize = true
string picturename = "sims_small.bmp"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_plash from picture within w_sims_about
integer x = 288
integer y = 352
integer width = 795
integer height = 152
string picturename = "GXOLogo.png"
boolean focusrectangle = false
end type

