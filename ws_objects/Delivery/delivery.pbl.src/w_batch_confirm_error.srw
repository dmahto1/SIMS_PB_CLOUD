$PBExportHeader$w_batch_confirm_error.srw
forward
global type w_batch_confirm_error from w_response_ancestor
end type
type dw_confirm_batch_errors from datawindow within w_batch_confirm_error
end type
end forward

global type w_batch_confirm_error from w_response_ancestor
integer width = 3712
integer height = 1434
string title = "Batch Confirm Messages"
dw_confirm_batch_errors dw_confirm_batch_errors
end type
global w_batch_confirm_error w_batch_confirm_error

on w_batch_confirm_error.create
int iCurrent
call super::create
this.dw_confirm_batch_errors=create dw_confirm_batch_errors
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_confirm_batch_errors
end on

on w_batch_confirm_error.destroy
call super::destroy
destroy(this.dw_confirm_batch_errors)
end on

event open;call super::open;

str_parms lstr_parms

integer li_idx, li_row

dw_confirm_batch_errors.Reset()

lstr_parms = message.PowerObjectParm

//SEPT-2019 - MikeA - DE12570 - SIMS QAT DEFECT - S36465 - PHILIPSBH - Window title issues

IF UpperBound(lstr_parms.string_arg_2[]) >= 1 THEN
	if lstr_parms.string_arg_2[1] = "READYTOSHIP" THEN This.Title = "Batch Ready to Ship Messages"
END IF

IF UpperBound(lstr_parms.string_arg_2[]) >= 1 THEN
	if lstr_parms.string_arg_2[1] = "READYTOSHIP" THEN This.Title = "Batch Ready to Ship Messages"
END IF
	
for li_idx = 1 to Upperbound(lstr_parms.string_arg)
	
	li_row = dw_confirm_batch_errors.InsertRow(0)
	
	dw_confirm_batch_errors.SetItem( li_row, "error_msg", lstr_parms.string_arg[li_row])

next

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_batch_confirm_error
boolean visible = false
integer x = 3248
integer y = 1187
end type

type cb_ok from w_response_ancestor`cb_ok within w_batch_confirm_error
integer x = 1660
integer y = 1184
end type

type dw_confirm_batch_errors from datawindow within w_batch_confirm_error
integer x = 22
integer y = 10
integer width = 3643
integer height = 1117
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_confirm_batch_errors"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

