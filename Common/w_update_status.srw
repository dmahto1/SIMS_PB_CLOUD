HA$PBExportHeader$w_update_status.srw
$PBExportComments$Horizontal bar update status
forward
global type w_update_status from window
end type
type st_status from statictext within w_update_status
end type
type hpb_status from hprogressbar within w_update_status
end type
end forward

global type w_update_status from window
integer width = 1705
integer height = 328
boolean titlebar = true
windowtype windowtype = popup!
long backcolor = 67108864
st_status st_status
hpb_status hpb_status
end type
global w_update_status w_update_status

on w_update_status.create
this.st_status=create st_status
this.hpb_status=create hpb_status
this.Control[]={this.st_status,&
this.hpb_status}
end on

on w_update_status.destroy
destroy(this.st_status)
destroy(this.hpb_status)
end on

event open;
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2
end event

type st_status from statictext within w_update_status
integer x = 23
integer y = 152
integer width = 1655
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type hpb_status from hprogressbar within w_update_status
integer x = 123
integer y = 20
integer width = 1417
integer height = 84
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

