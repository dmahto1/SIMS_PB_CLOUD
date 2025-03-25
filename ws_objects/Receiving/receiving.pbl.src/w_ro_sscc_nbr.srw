$PBExportHeader$w_ro_sscc_nbr.srw
$PBExportComments$+ SSCC Nbr validation screen.
forward
global type w_ro_sscc_nbr from w_response_ancestor
end type
type st_1 from statictext within w_ro_sscc_nbr
end type
type st_2 from statictext within w_ro_sscc_nbr
end type
type st_3 from statictext within w_ro_sscc_nbr
end type
type sle_sku from singlelineedit within w_ro_sscc_nbr
end type
type sle_sscc_nbr from singlelineedit within w_ro_sscc_nbr
end type
type sle_supp from singlelineedit within w_ro_sscc_nbr
end type
type st_supp from statictext within w_ro_sscc_nbr
end type
end forward

global type w_ro_sscc_nbr from w_response_ancestor
string tag = "SSCC Nbr Validation Screen"
string title = "SSCC Nbr Validation Screen"
long backcolor = 67108864
st_1 st_1
st_2 st_2
st_3 st_3
sle_sku sle_sku
sle_sscc_nbr sle_sscc_nbr
sle_supp sle_supp
st_supp st_supp
end type
global w_ro_sscc_nbr w_ro_sscc_nbr

on w_ro_sscc_nbr.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_sku=create sle_sku
this.sle_sscc_nbr=create sle_sscc_nbr
this.sle_supp=create sle_supp
this.st_supp=create st_supp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_sku
this.Control[iCurrent+5]=this.sle_sscc_nbr
this.Control[iCurrent+6]=this.sle_supp
this.Control[iCurrent+7]=this.st_supp
end on

on w_ro_sscc_nbr.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_sku)
destroy(this.sle_sscc_nbr)
destroy(this.sle_supp)
destroy(this.st_supp)
end on

event ue_postopen;call super::ue_postopen;

Istrparms = Message.PowerObjectParm

sle_sku.text =Istrparms.String_arg[1]
sle_supp.text =Istrparms.String_arg[2]
end event

event closequery;call super::closequery;

If IsNull(sle_sscc_nbr.text) Then
	MessageBox("SSCC Nbr Validation", "SSCC Nbr shouldn't be empty")
	Return -1
End If

IF Not Istrparms.Cancelled Then
	Istrparms.String_arg[1] = sle_sku.text
	Istrparms.String_arg[2] = sle_supp.text
	Istrparms.String_arg[3] = sle_sscc_nbr.text
End IF

Message.PowerObjectParm = Istrparms

Return 0
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_ro_sscc_nbr
end type

type cb_ok from w_response_ancestor`cb_ok within w_ro_sscc_nbr
end type

type st_1 from statictext within w_ro_sscc_nbr
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
string text = "Scan valid SSCC Nbr"
alignment alignment = center!
long bordercolor = 255
boolean focusrectangle = false
end type

type st_2 from statictext within w_ro_sscc_nbr
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

type st_3 from statictext within w_ro_sscc_nbr
integer x = 37
integer y = 456
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
string text = "SSCC Nbr"
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_ro_sscc_nbr
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
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_sscc_nbr from singlelineedit within w_ro_sscc_nbr
integer x = 439
integer y = 456
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

type sle_supp from singlelineedit within w_ro_sscc_nbr
integer x = 439
integer y = 344
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

type st_supp from statictext within w_ro_sscc_nbr
integer x = 37
integer y = 344
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
string text = "Supplier"
boolean focusrectangle = false
end type

