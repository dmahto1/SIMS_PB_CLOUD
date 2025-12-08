$PBExportHeader$w_sims_update.srw
$PBExportComments$Sims About Screen
forward
global type w_sims_update from window
end type
type st_sims from statictext within w_sims_update
end type
type p_1 from picture within w_sims_update
end type
end forward

global type w_sims_update from window
integer x = 823
integer y = 360
integer width = 1422
integer height = 820
boolean titlebar = true
string title = "About SIMS"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
st_sims st_sims
p_1 p_1
end type
global w_sims_update w_sims_update

event open;
Integer			li_ScreenH, li_ScreenW
Environment	le_Env
string ls_message

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

// pvh - 04/25/06 - version
This.Title = 'SIMS - ' + f_getFormattedVersion()
//This.Title = 'About SIMS - Version: ' + f_get_version()
//Begin- Dinesh - 11/03/2025- sims-874-Display a Message to the User when a new SIMS Version is Deployed
ls_message = message.StringParm
st_sims.text= ls_message
//End- Dinesh - 11/03/2025- sims-874-Display a Message to the User when a new SIMS Version is Deployed
end event

on w_sims_update.create
this.st_sims=create st_sims
this.p_1=create p_1
this.Control[]={this.st_sims,&
this.p_1}
end on

on w_sims_update.destroy
destroy(this.st_sims)
destroy(this.p_1)
end on

type st_sims from statictext within w_sims_update
integer y = 372
integer width = 1413
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type p_1 from picture within w_sims_update
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

