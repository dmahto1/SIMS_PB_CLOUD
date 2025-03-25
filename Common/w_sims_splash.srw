HA$PBExportHeader$w_sims_splash.srw
$PBExportComments$Sims splash Screen
forward
global type w_sims_splash from window
end type
type p_1 from picture within w_sims_splash
end type
type p_plash from picture within w_sims_splash
end type
type st_version from statictext within w_sims_splash
end type
end forward

global type w_sims_splash from window
integer x = 823
integer y = 360
integer width = 1079
integer height = 648
windowtype windowtype = popup!
long backcolor = 16777215
p_1 p_1
p_plash p_plash
st_version st_version
end type
global w_sims_splash w_sims_splash

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
//st_version.text = 'Version: ' + f_get_version()
st_version.text =  f_getFormattedVersion()
end event

on w_sims_splash.create
this.p_1=create p_1
this.p_plash=create p_plash
this.st_version=create st_version
this.Control[]={this.p_1,&
this.p_plash,&
this.st_version}
end on

on w_sims_splash.destroy
destroy(this.p_1)
destroy(this.p_plash)
destroy(this.st_version)
end on

type p_1 from picture within w_sims_splash
integer x = 366
integer y = 20
integer width = 329
integer height = 288
boolean originalsize = true
string picturename = "sims_small.bmp"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type p_plash from picture within w_sims_splash
integer x = 329
integer y = 384
integer width = 407
integer height = 300
string picturename = "menlo.gif"
boolean focusrectangle = false
end type

type st_version from statictext within w_sims_splash
integer y = 316
integer width = 1065
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

