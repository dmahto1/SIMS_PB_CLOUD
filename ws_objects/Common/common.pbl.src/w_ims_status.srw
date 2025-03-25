$PBExportHeader$w_ims_status.srw
$PBExportComments$IMS communication popup
forward
global type w_ims_status from window
end type
type st_status from statictext within w_ims_status
end type
type hpb_status from hprogressbar within w_ims_status
end type
type st_1 from statictext within w_ims_status
end type
type cb_1 from commandbutton within w_ims_status
end type
end forward

global type w_ims_status from window
integer width = 1134
integer height = 716
boolean titlebar = true
string title = "IMS"
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_status st_status
hpb_status hpb_status
st_1 st_1
cb_1 cb_1
end type
global w_ims_status w_ims_status

on w_ims_status.create
this.st_status=create st_status
this.hpb_status=create hpb_status
this.st_1=create st_1
this.cb_1=create cb_1
this.Control[]={this.st_status,&
this.hpb_status,&
this.st_1,&
this.cb_1}
end on

on w_ims_status.destroy
destroy(this.st_status)
destroy(this.hpb_status)
destroy(this.st_1)
destroy(this.cb_1)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2
end event

type st_status from statictext within w_ims_status
integer x = 55
integer y = 144
integer width = 1015
integer height = 192
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type hpb_status from hprogressbar within w_ims_status
integer x = 14
integer y = 400
integer width = 1042
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 1
end type

type st_1 from statictext within w_ims_status
integer y = 40
integer width = 1070
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Communicating with IMS"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ims_status
integer x = 370
integer y = 480
integer width = 293
integer height = 112
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;
Close(Parent)
end event

