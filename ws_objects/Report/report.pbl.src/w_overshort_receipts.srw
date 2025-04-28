$PBExportHeader$w_overshort_receipts.srw
forward
global type w_overshort_receipts from w_std_report
end type
end forward

global type w_overshort_receipts from w_std_report
integer width = 3598
integer height = 2116
string title = "Over Short Receipts"
end type
global w_overshort_receipts w_overshort_receipts

on w_overshort_receipts.create
call super::create
end on

on w_overshort_receipts.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//DateTime ldt_datetime

//ldt_datetime = DateTime(Today(), Now())
//em_to_date.text = String(ldt_datetime, &
//		"mm/dd/yy hh:mm")
//ldt_datetime = DateTime(Today(),  time('00:01:00'))
//em_from_date.text = String(ldt_datetime,"mm/dd/yy hh:mm")

//TAM 09/2016 Adding report for Pandora.
If gs_project = 'PANDORA' Then
	dw_report.dataobject = 'd_pandora_overshort_receipts'
	dw_report.SetTransObject(SQLCA)
End If

end event

event ue_retrieve;call super::ue_retrieve;// Retrieves data from the receive master and detail tables.
// it selects the records using input from the "em_from_date" and the "em_to_date" datetime variables.

datetime ldt_from_date, ldt_to_date
integer ll_cnt

If dw_select.AcceptText() = -1 Then Return // accepts the last change in the select fields

ldt_from_date = dw_select.GetItemDatetime(1,"em_from_date")
ldt_to_date = dw_select.GetItemDatetime(1,"em_to_date")

IF IsNull(ldt_from_date) THEN	ldt_from_date = datetime(Date("2000/01/01"))

if IsNull(ldt_to_date) THEN ldt_to_date = datetime(today(), Now())

dw_report.retrieve(gs_project, ldt_from_date, ldt_to_date)
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-225)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc

// 04/02 - Pconkl - Order type by Project - need to pass parm
dw_report.GetChild('Receive_MAster_ord_type',ldwc)
ldwc.SetTransObject(SQLCA)
If ldwc.Retrieve(gs_project) < 0 Then
	ldwc.InsertRow(0)
End If
end event

type dw_select from w_std_report`dw_select within w_overshort_receipts
integer x = 23
integer y = 20
integer width = 3525
integer height = 128
string dataobject = "d_select_dates"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_overshort_receipts
integer x = 2971
integer y = 32
end type

type dw_report from w_std_report`dw_report within w_overshort_receipts
integer x = 23
integer y = 160
integer width = 3525
integer height = 1768
string dataobject = "d_overshort_receipts"
boolean hscrollbar = true
end type

type gb_selectdate from groupbox within w_overshort_receipts
integer x = 27
integer width = 2885
integer height = 148
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type em_from_date from editmask within w_overshort_receipts
integer x = 1248
integer y = 52
integer width = 736
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
boolean spin = true
end type

type em_to_date from editmask within w_overshort_receipts
integer x = 2144
integer y = 48
integer width = 736
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
boolean spin = true
end type

type st_sfromdate from statictext within w_overshort_receipts
integer x = 69
integer y = 52
integer width = 1175
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select a ~"Complete Date~" range   From:"
boolean focusrectangle = false
end type

type st_todate from statictext within w_overshort_receipts
integer x = 2011
integer y = 52
integer width = 133
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To: "
boolean focusrectangle = false
end type

