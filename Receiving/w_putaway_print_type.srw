HA$PBExportHeader$w_putaway_print_type.srw
$PBExportComments$Prompt to print Putaway Tags or List (GM Detroit)
forward
global type w_putaway_print_type from w_response_ancestor
end type
type rb_list from radiobutton within w_putaway_print_type
end type
type rb_tags from radiobutton within w_putaway_print_type
end type
type st_1 from statictext within w_putaway_print_type
end type
type gb_1 from groupbox within w_putaway_print_type
end type
end forward

global type w_putaway_print_type from w_response_ancestor
integer width = 791
integer height = 628
string title = "Print Putaway List"
rb_list rb_list
rb_tags rb_tags
st_1 st_1
gb_1 gb_1
end type
global w_putaway_print_type w_putaway_print_type

on w_putaway_print_type.create
int iCurrent
call super::create
this.rb_list=create rb_list
this.rb_tags=create rb_tags
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_list
this.Control[iCurrent+2]=this.rb_tags
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_putaway_print_type.destroy
call super::destroy
destroy(this.rb_list)
destroy(this.rb_tags)
destroy(this.st_1)
destroy(this.gb_1)
end on

event closequery;call super::closequery;
If Not istrparms.cancelled Then
	If rb_list.Checked = True Then
		istrparms.String_Arg[1] = 'L'
	Else
		istrparms.String_Arg[1] = 'T'
	End If
End IF

Message.PowerObjectParm = IstrParms
end event

event ue_postopen;call super::ue_postopen;
rb_tags.Checked = True
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_putaway_print_type
integer x = 375
integer y = 420
integer height = 88
end type

type cb_ok from w_response_ancestor`cb_ok within w_putaway_print_type
integer x = 96
integer y = 420
integer width = 224
integer height = 88
end type

type rb_list from radiobutton within w_putaway_print_type
integer x = 55
integer y = 192
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&List"
end type

type rb_tags from radiobutton within w_putaway_print_type
integer x = 55
integer y = 268
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Tags"
end type

type st_1 from statictext within w_putaway_print_type
integer x = 18
integer y = 40
integer width = 736
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print Putaway:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_putaway_print_type
integer x = 27
integer y = 112
integer width = 704
integer height = 280
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

