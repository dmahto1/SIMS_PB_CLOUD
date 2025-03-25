$PBExportHeader$w_consolidation_set_dates.srw
$PBExportComments$Consolidation global date update
forward
global type w_consolidation_set_dates from w_response_ancestor
end type
type dw_1 from datawindow within w_consolidation_set_dates
end type
end forward

global type w_consolidation_set_dates from w_response_ancestor
integer width = 1097
integer height = 516
string title = "Consolidation Date update"
dw_1 dw_1
end type
global w_consolidation_set_dates w_consolidation_set_dates

on w_consolidation_set_dates.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_consolidation_set_dates.destroy
call super::destroy
destroy(this.dw_1)
end on

event ue_postopen;call super::ue_postopen;
dw_1.InsertRow(0)

dw_1.SetITem(1,'consol_date',today())
dw_1.SetITem(1,'date_type','C')
end event

event closequery;call super::closequery;
dw_1.AcceptText()

If Istrparms.Cancelled Then
	Message.PowerObjectParm = Istrparms
	Return 0
End If

If isnull(dw_1.GetItemString(1,'date_type')) or dw_1.GetItemString(1,'date_type') = '' Then
	Messagebox('','Please enter the date you want to update')
	dw_1.SetFocus()
	dw_1.SetColumn('date_type')
	Return 1
End If

//If isnull(dw_1.GetItemDateTime(1,'consol_date'))  Then
//	Messagebox('','Please enter the date.')
//	dw_1.SetFocus()
//	dw_1.SetColumn('consol_date')
//	Return 1
//End If

Istrparms.String_arg[1] = dw_1.GetItemString(1,'date_type')
Istrparms.DateTime_arg[1] = dw_1.GetItemDateTime(1,'consol_date')

Message.PowerObjectParm = Istrparms

Return 0
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_consolidation_set_dates
integer x = 599
integer y = 304
integer height = 84
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_consolidation_set_dates
integer x = 165
integer y = 304
integer height = 84
integer textsize = -8
end type

type dw_1 from datawindow within w_consolidation_set_dates
integer x = 18
integer y = 20
integer width = 1015
integer height = 240
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_consolidation_set_dates"
boolean border = false
boolean livescroll = true
end type

