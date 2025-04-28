HA$PBExportHeader$w_ro_pallet_container.srw
$PBExportComments$+ Pallet / Container creation screen.
forward
global type w_ro_pallet_container from w_response_ancestor
end type
type cb_generate from commandbutton within w_ro_pallet_container
end type
type st_1 from statictext within w_ro_pallet_container
end type
type st_2 from statictext within w_ro_pallet_container
end type
type st_3 from statictext within w_ro_pallet_container
end type
type sle_1 from singlelineedit within w_ro_pallet_container
end type
type sle_2 from singlelineedit within w_ro_pallet_container
end type
type st_4 from statictext within w_ro_pallet_container
end type
end forward

global type w_ro_pallet_container from w_response_ancestor
string tag = "Pallet /Container Screen"
string title = "Pallet /Container Screen"
long backcolor = 67108864
cb_generate cb_generate
st_1 st_1
st_2 st_2
st_3 st_3
sle_1 sle_1
sle_2 sle_2
st_4 st_4
end type
global w_ro_pallet_container w_ro_pallet_container

on w_ro_pallet_container.create
int iCurrent
call super::create
this.cb_generate=create cb_generate
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_1=create sle_1
this.sle_2=create sle_2
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generate
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.sle_2
this.Control[iCurrent+7]=this.st_4
end on

on w_ro_pallet_container.destroy
call super::destroy
destroy(this.cb_generate)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.st_4)
end on

event ue_postopen;call super::ue_postopen;

Istrparms = Message.PowerObjectParm

sle_1.text =Istrparms.String_arg[1]
sle_2.text =Istrparms.String_arg[2]

IF Istrparms.String_arg[3] ="po_no2" THEN
	st_3.text="Pallet Id"
ELSE
	st_3.text="Container Id"
END IF
end event

event closequery;call super::closequery;

If IsNull(sle_2.text) Then
	MessageBox("System Generate Pallet /Container Id", "Pallet / Container Id shouldn't be empty")
	Return -1
End If

IF Not Istrparms.Cancelled Then
	Istrparms.String_arg[1] = sle_1.text
	Istrparms.String_arg[2] = sle_2.text
End IF

Message.PowerObjectParm = Istrparms

Return 0
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_ro_pallet_container
end type

type cb_ok from w_response_ancestor`cb_ok within w_ro_pallet_container
end type

type cb_generate from commandbutton within w_ro_pallet_container
integer x = 1627
integer y = 352
integer width = 325
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;//28-AUG-2018 :Madhu S23016 Foot Print Containerization
//System generate and assign next SSCC No to Pallet Id / Container Id.

sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , sle_2.text )
end event

type st_1 from statictext within w_ro_pallet_container
integer x = 87
integer y = 32
integer width = 1737
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "System generate Pallet /Container Id"
alignment alignment = center!
long bordercolor = 255
boolean focusrectangle = false
end type

type st_2 from statictext within w_ro_pallet_container
integer x = 37
integer y = 220
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU"
boolean focusrectangle = false
end type

type st_3 from statictext within w_ro_pallet_container
integer x = 37
integer y = 352
integer width = 402
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pallet Id"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ro_pallet_container
integer x = 439
integer y = 220
integer width = 1161
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_ro_pallet_container
integer x = 439
integer y = 352
integer width = 1161
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_ro_pallet_container
integer x = 32
integer y = 476
integer width = 1943
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Click on ~'Generate~' button to assign Next Pallet Id / Container Id."
boolean focusrectangle = false
end type

