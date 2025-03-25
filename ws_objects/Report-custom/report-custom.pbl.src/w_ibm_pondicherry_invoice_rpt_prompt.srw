$PBExportHeader$w_ibm_pondicherry_invoice_rpt_prompt.srw
$PBExportComments$IBM Pondicherry Invoice Report prompt for Invoice Amt text
forward
global type w_ibm_pondicherry_invoice_rpt_prompt from w_response_ancestor
end type
type st_amount from statictext within w_ibm_pondicherry_invoice_rpt_prompt
end type
type sle_amount_text from singlelineedit within w_ibm_pondicherry_invoice_rpt_prompt
end type
end forward

global type w_ibm_pondicherry_invoice_rpt_prompt from w_response_ancestor
integer width = 2194
integer height = 528
string title = ""
st_amount st_amount
sle_amount_text sle_amount_text
end type
global w_ibm_pondicherry_invoice_rpt_prompt w_ibm_pondicherry_invoice_rpt_prompt

on w_ibm_pondicherry_invoice_rpt_prompt.create
int iCurrent
call super::create
this.st_amount=create st_amount
this.sle_amount_text=create sle_amount_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_amount
this.Control[iCurrent+2]=this.sle_amount_text
end on

on w_ibm_pondicherry_invoice_rpt_prompt.destroy
call super::destroy
destroy(this.st_amount)
destroy(this.sle_amount_text)
end on

event ue_postopen;call super::ue_postopen;

istrparms = Message.Powerobjectparm
st_amount.text = st_amount.Text + String(istrparms.Long_arg[1],'##,##,##,##,##,###')

sle_amount_text.SetFocus()
end event

event closequery;call super::closequery;If Not istrparms.Cancelled then 
	istrparms.String_arg[1] = sle_amount_text.text
End IF

message.Powerobjectparm = istrparms
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_ibm_pondicherry_invoice_rpt_prompt
integer x = 1166
integer y = 332
integer height = 88
end type

type cb_ok from w_response_ancestor`cb_ok within w_ibm_pondicherry_invoice_rpt_prompt
integer x = 672
integer y = 332
integer height = 88
end type

type st_amount from statictext within w_ibm_pondicherry_invoice_rpt_prompt
integer x = 41
integer y = 48
integer width = 2117
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Please enter the text for the Invoice Amount of: "
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_amount_text from singlelineedit within w_ibm_pondicherry_invoice_rpt_prompt
integer x = 50
integer y = 156
integer width = 2117
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

