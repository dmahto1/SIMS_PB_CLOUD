HA$PBExportHeader$w_tran_copy_detail_row.srw
$PBExportComments$Parms for Receive Putaway Copy Row function
forward
global type w_tran_copy_detail_row from w_response_ancestor
end type
type st_1 from statictext within w_tran_copy_detail_row
end type
type st_2 from statictext within w_tran_copy_detail_row
end type
type sle_rows from singlelineedit within w_tran_copy_detail_row
end type
type sle_qty from singlelineedit within w_tran_copy_detail_row
end type
type st_3 from statictext within w_tran_copy_detail_row
end type
type st_4 from statictext within w_tran_copy_detail_row
end type
end forward

global type w_tran_copy_detail_row from w_response_ancestor
integer width = 1193
integer height = 632
string title = "Copy Trans Detail Row"
st_1 st_1
st_2 st_2
sle_rows sle_rows
sle_qty sle_qty
st_3 st_3
st_4 st_4
end type
global w_tran_copy_detail_row w_tran_copy_detail_row

on w_tran_copy_detail_row.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_rows=create sle_rows
this.sle_qty=create sle_qty
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_rows
this.Control[iCurrent+4]=this.sle_qty
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
end on

on w_tran_copy_detail_row.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_rows)
destroy(this.sle_qty)
destroy(this.st_3)
destroy(this.st_4)
end on

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;
Sle_Rows.Text = '2' /*default to one new row */
Sle_Qty.Text = String(Istrparms.Decimal_Arg[1],'#######.#####')
end event

event closequery;call super::closequery;
If Istrparms.Cancelled Then
	Message.PowerObjectParm = Istrparms
	Return 0
End If

//fields must be present and Numeric

If isnull(sle_rows.Text) or sle_rows.Text = '' Then
	messagebox('Copy Row','Total Number of Rows must be entered!',StopSign!)
	sle_rows.SetFocus()
	REturn 1
End If

If not isnumber(sle_rows.Text) Then
	messagebox('Copy Row','Total Number of Rows must be Numeric!',StopSign!)
	sle_rows.SetFocus()
	sle_Rows.SelectText(1,Len(sle_rows.Text))
	REturn 1
End If

If Long(sle_rows.Text) <= 0 Then
	messagebox('Copy Row','Total Number of Rows must be > 0!',StopSign!)
	sle_rows.SetFocus()
	sle_Rows.SelectText(1,Len(sle_rows.Text))
	REturn 1
End If

If isnull(sle_qty.Text) or sle_qty.Text = '' Then
	messagebox('Copy Row','QTY per row must be entered!',StopSign!)
	sle_qty.SetFocus()
	REturn 1
End If

If not isnumber(sle_qty.Text) Then
	messagebox('Copy Row','QTY per row must be Numeric!',StopSign!)
	sle_qty.SetFocus()
	sle_qty.SelectText(1,Len(sle_qty.Text))
	REturn 1
End If

//If Long(sle_qty.Text) <= 0 Then
//	messagebox('Copy Row','QTY per row must be > 0!',StopSign!)
//	sle_qty.SetFocus()
//	sle_qty.SelectText(1,Len(sle_qty.Text))
//	REturn 1
//End If

Istrparms.Long_arg[1] = Long(sle_rows.Text)
Istrparms.Decimal_arg[1] = Dec(sle_qty.Text)

Message.PowerObjectParm = Istrparms
Return 0
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_tran_copy_detail_row
integer x = 649
integer y = 420
integer width = 242
integer height = 92
integer taborder = 30
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_tran_copy_detail_row
integer x = 274
integer y = 420
integer width = 242
integer height = 92
integer textsize = -8
end type

type st_1 from statictext within w_tran_copy_detail_row
integer y = 44
integer width = 718
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
string text = "Total Number of Rows:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_tran_copy_detail_row
integer y = 108
integer width = 718
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(including Original)"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_rows from singlelineedit within w_tran_copy_detail_row
integer x = 759
integer y = 36
integer width = 370
integer height = 100
integer taborder = 1
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;
If not isnumber(this.Text) Then
	messageBox('Copy Row','Value must be Numeric!',StopSign!)
	This.SetFocus()
	This.SelectText(1,len(This.Text))
ElseIf Long(this.Text) < 0 then
	messageBox('Copy Row','Value must be > 0!',StopSign!)
	This.SetFocus()
	This.SelectText(1,len(This.Text))
End If
end event

type sle_qty from singlelineedit within w_tran_copy_detail_row
integer x = 759
integer y = 224
integer width = 370
integer height = 100
integer taborder = 2
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;If not isnumber(this.Text) Then
	messageBox('Copy Row','Value must be Numeric!',StopSign!)
	This.SetFocus()
	This.SelectText(1,len(This.Text))
ElseIf Long(this.Text) < 0 then
	messageBox('Copy Row','Value must be > 0!',StopSign!)
	This.SetFocus()
	This.SelectText(1,len(This.Text))
End If
end event

type st_3 from statictext within w_tran_copy_detail_row
integer x = 50
integer y = 236
integer width = 667
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
string text = "QTY for each Row:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_tran_copy_detail_row
integer x = 169
integer y = 292
integer width = 530
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "(including Original)"
alignment alignment = right!
boolean focusrectangle = false
end type

