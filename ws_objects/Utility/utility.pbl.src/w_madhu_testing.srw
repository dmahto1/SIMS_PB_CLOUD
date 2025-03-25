$PBExportHeader$w_madhu_testing.srw
forward
global type w_madhu_testing from window
end type
type sle_1 from singlelineedit within w_madhu_testing
end type
end forward

global type w_madhu_testing from window
integer width = 4160
integer height = 1924
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_1 sle_1
end type
global w_madhu_testing w_madhu_testing

type variables
Boolean ibkeytype= FALSE
Boolean ibmouseclick=FALSE

Boolean ibStartTimer =FALSE
long ll_counter
end variables

event open;Double ldWgt
String lsWgt

ldWgt =5031.0000
lsWgt =String(round(ldWgt,2))

//timer(5)
MessageBox("Display",lsWgt)
end event

on w_madhu_testing.create
this.sle_1=create sle_1
this.Control[]={this.sle_1}
end on

on w_madhu_testing.destroy
destroy(this.sle_1)
end on

event timer;////sle_1.event ue_keydown( KeyEnter!, 0)
//timer(0)
//ibkeytype=FALSE
//ibmouseclick =FALSE
//MessageBox("Timer","Doesn't accept manual enter")
//sle_1.text=''
//

ll_counter++

end event

type sle_1 from singlelineedit within w_madhu_testing
event ue_keydown pbm_keydown
event ue_mouseclick pbm_rbuttondown
integer x = 192
integer y = 224
integer width = 1691
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;//If ibkeytype =FALSE THEN
//	timer(0.5)
//	ibkeytype=TRUE
//END IF
//
//IF KeyDown(KeyEnter!) THEN
//	timer(0)
//	ibkeytype=FALSE
// END IF
//

IF ibStartTimer =FALSE Then
	timer(0.1)
else
	ibStartTimer =true
end if
end event

event ue_mouseclick;IF ibmouseclick=FALSE THEN
//	timer(0.2)
	ibmouseclick =TRUE
//	MessageBox("MouseClick","RMC is disabled")
END IF

return 1
end event

