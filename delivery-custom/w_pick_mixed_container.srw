HA$PBExportHeader$w_pick_mixed_container.srw
$PBExportComments$- Prompt for Mixed Containerization
forward
global type w_pick_mixed_container from w_response_ancestor
end type
type rb_pallet from radiobutton within w_pick_mixed_container
end type
type rb_container from radiobutton within w_pick_mixed_container
end type
type st_1 from statictext within w_pick_mixed_container
end type
type rb_none from radiobutton within w_pick_mixed_container
end type
type st_2 from statictext within w_pick_mixed_container
end type
type gb_1 from groupbox within w_pick_mixed_container
end type
end forward

global type w_pick_mixed_container from w_response_ancestor
integer width = 1178
integer height = 874
string title = "Mixed Containerization"
rb_pallet rb_pallet
rb_container rb_container
st_1 st_1
rb_none rb_none
st_2 st_2
gb_1 gb_1
end type
global w_pick_mixed_container w_pick_mixed_container

type variables
Str_parms	ipStrParms

String isPallet, isContainer, isMixedType


end variables

on w_pick_mixed_container.create
int iCurrent
call super::create
this.rb_pallet=create rb_pallet
this.rb_container=create rb_container
this.st_1=create st_1
this.rb_none=create rb_none
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_pallet
this.Control[iCurrent+2]=this.rb_container
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_none
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
end on

on w_pick_mixed_container.destroy
call super::destroy
destroy(this.rb_pallet)
destroy(this.rb_container)
destroy(this.st_1)
destroy(this.rb_none)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;//rb_pallet.checked =TRUE
end event

event closequery;call super::closequery;
If Not istrparms.cancelled Then
	istrparms.String_Arg[1] = isMixedType
	istrparms.String_Arg[2] = isPallet
	istrparms.String_Arg[3] = isContainer
	
	If rb_pallet.Checked = True and isMixedType <> 'P' Then				//Changed to pallet
		istrparms.String_Arg[1] = 'P'
		istrparms.String_Arg[2] = 'New'
		istrparms.String_Arg[3] = 'NA'
	ElseIf rb_container.Checked = True and isMixedType <> 'C' Then	//Changed to container
		istrparms.String_Arg[1] = 'C'
		istrparms.String_Arg[2] = 'NA'
		istrparms.String_Arg[3] = 'New'
	ElseIf rb_none.Checked =True and isMixedType <> 'N' Then			//Changed to None
		istrparms.String_Arg[1]='N'
		istrparms.String_Arg[2] = 'NA'
		istrparms.String_Arg[3] = 'NA'
	End If
End IF

Message.PowerObjectParm = IstrParms
end event

event open;call super::open;ipStrParms = message.PowerObjectParm

isMixedType = ipStrParms.String_arg[1]
If isMixedType = 'P' Then 
	ipStrParms.String_Arg[1] = isMixedType
	isPallet = ipStrParms.String_arg[2] 
	isContainer = 'NA'
	rb_pallet.checked = TRUE
	rb_container.checked = FALSE
	rb_none.checked = FALSE
	st_2.text = 'Pallet ' + isPallet + ' is currently assigned to these serials.'
ElseIf isMixedType = 'C' Then
	ipStrParms.String_Arg[1] = isMixedType
	isPallet = 'NA'
	isContainer = ipStrParms.String_arg[2] 
	rb_container.checked = TRUE
	rb_pallet.checked = FALSE
	rb_none.checked = FALSE
	st_2.text = 'Container ' + isContainer + ' is currently assigned to these serials.'
ElseIf isMixedType = 'N' Then
	ipStrParms.String_Arg[1] = isMixedType
	isPallet = 'NA'
	isContainer = 'NA'
	rb_none.checked = TRUE
	rb_pallet.checked = FALSE
	rb_container.checked = FALSE
	st_2.text = 'Currently serials are loose without pallet or container'
End If

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_pick_mixed_container
integer x = 377
integer y = 675
integer height = 90
end type

type cb_ok from w_response_ancestor`cb_ok within w_pick_mixed_container
integer x = 95
integer y = 675
integer width = 223
integer height = 90
end type

type rb_pallet from radiobutton within w_pick_mixed_container
integer x = 55
integer y = 166
integer width = 1068
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
string text = "&Pallet - Assign an ID for shipping"
end type

type rb_container from radiobutton within w_pick_mixed_container
integer x = 55
integer y = 272
integer width = 1068
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
string text = "&Container - Ship with an ID"
end type

type st_1 from statictext within w_pick_mixed_container
integer x = 18
integer y = 42
integer width = 984
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
string text = "Loose Serial No~'s are shipped by:"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_none from radiobutton within w_pick_mixed_container
integer x = 55
integer y = 378
integer width = 1068
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
string text = "&None - Leave as loose serials"
end type

type st_2 from statictext within w_pick_mixed_container
integer x = 59
integer y = 490
integer width = 1068
integer height = 125
boolean bringtotop = true
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

type gb_1 from groupbox within w_pick_mixed_container
integer x = 26
integer y = 131
integer width = 1075
integer height = 362
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

