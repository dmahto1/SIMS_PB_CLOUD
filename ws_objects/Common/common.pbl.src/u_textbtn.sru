$PBExportHeader$u_textbtn.sru
$PBExportComments$Created: Leyka 2004.07.15
forward
global type u_textbtn from userobject
end type
type st_1 from statictext within u_textbtn
end type
type st_2 from statictext within u_textbtn
end type
end forward

global type u_textbtn from userobject
integer width = 558
integer height = 268
long backcolor = 67108864
string text = "none"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_open pbm_open
event ue_btndown ( )
event ue_btnup ( )
event ue_clicked ( )
event clicked ( )
event ue_resize ( )
st_1 st_1
st_2 st_2
end type
global u_textbtn u_textbtn

type variables
string        is_text
protected boolean    ib_clicked
end variables

event ue_open;st_1.text = is_text
this.event ue_resize()

end event

event ue_btndown;st_2.BorderStyle = StyleLowered! 
st_1.x += 5
st_1.y += 5

ib_clicked = true



        
end event

event ue_btnup;if ib_clicked then
    st_2.BorderStyle = StyleRaised! 
    st_1.x -= 5
    st_1.y -= 5
    ib_clicked = false
end if    

end event

event ue_resize;st_1.x = 32
st_1.y = 32
st_1.width = width - 64
st_1.height = height - 64
end event

on u_textbtn.create
this.st_1=create st_1
this.st_2=create st_2
this.Control[]={this.st_1,&
this.st_2}
end on

on u_textbtn.destroy
destroy(this.st_1)
destroy(this.st_2)
end on

type st_1 from statictext within u_textbtn
event lbuttonup pbm_lbuttonup
event lbuttondown pbm_lbuttondown
integer x = 128
integer y = 48
integer width = 334
integer height = 56
integer textsize = 14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Text"
alignment alignment = center!
boolean focusrectangle = false
end type

event lbuttonup;parent.event ue_btnup()
end event

event lbuttondown;
parent.event ue_btndown()
end event

event clicked;parent.event clicked ()
end event

type st_2 from statictext within u_textbtn
event lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
integer x = 18
integer y = 16
integer width = 517
integer height = 232
integer textsize = 14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event lbuttondown;parent.event ue_btndown()
end event

event lbuttonup;parent.event ue_btnup()
end event

event clicked;
parent.event clicked ()
end event

