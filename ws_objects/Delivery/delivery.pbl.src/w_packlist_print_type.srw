$PBExportHeader$w_packlist_print_type.srw
$PBExportComments$Prompy for Master or Carton Level PAckList
forward
global type w_packlist_print_type from w_response_ancestor
end type
type rb_master from radiobutton within w_packlist_print_type
end type
type rb_Carton from radiobutton within w_packlist_print_type
end type
type st_1 from statictext within w_packlist_print_type
end type
type gb_1 from groupbox within w_packlist_print_type
end type
end forward

global type w_packlist_print_type from w_response_ancestor
integer y = 360
integer width = 790
integer height = 627
string title = "Print Pack List"
rb_master rb_master
rb_Carton rb_Carton
st_1 st_1
gb_1 gb_1
end type
global w_packlist_print_type w_packlist_print_type

on w_packlist_print_type.create
int iCurrent
call super::create
this.rb_master=create rb_master
this.rb_Carton=create rb_Carton
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_master
this.Control[iCurrent+2]=this.rb_Carton
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_packlist_print_type.destroy
call super::destroy
destroy(this.rb_master)
destroy(this.rb_Carton)
destroy(this.st_1)
destroy(this.gb_1)
end on

event closequery;call super::closequery;
If Not istrparms.cancelled Then
	If rb_master.Checked = True Then
		istrparms.String_Arg[1] = 'M'
	Else
		istrparms.String_Arg[1] = 'C'
	End If
End IF

Message.PowerObjectParm = IstrParms
end event

event ue_postopen;call super::ue_postopen;
rb_master.Checked = True
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_packlist_print_type
integer x = 377
integer y = 419
integer height = 90
end type

type cb_ok from w_response_ancestor`cb_ok within w_packlist_print_type
integer x = 95
integer y = 419
integer width = 223
integer height = 90
end type

type rb_master from radiobutton within w_packlist_print_type
integer x = 55
integer y = 192
integer width = 607
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
string text = "&Master"
end type

type rb_Carton from radiobutton within w_packlist_print_type
integer x = 55
integer y = 269
integer width = 607
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
string text = "&Carton"
end type

type st_1 from statictext within w_packlist_print_type
integer x = 18
integer y = 42
integer width = 735
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
string text = "Print Packlist:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_packlist_print_type
integer x = 26
integer y = 112
integer width = 706
integer height = 282
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

