HA$PBExportHeader$w_comcast_activity_rpt.srw
$PBExportComments$Comcast Acivity Report
forward
global type w_comcast_activity_rpt from w_std_report
end type
end forward

global type w_comcast_activity_rpt from w_std_report
integer width = 3712
integer height = 2044
string title = "Receiving Report"
end type
global w_comcast_activity_rpt w_comcast_activity_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
end variables

on w_comcast_activity_rpt.create
call super::create
end on

on w_comcast_activity_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;DateTime ldFromDate, ldtodate
Long ll_balance, i, ll_cnt

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ldFromDate = dw_Select.GetITemDateTime(1,"complete_from_date")
ldToDate = dw_Select.GetITemDateTime(1,"complete_to_date")

ll_cnt = dw_report.Retrieve(ldFromDate, ldToDate)
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()


end event

type dw_select from w_std_report`dw_select within w_comcast_activity_rpt
integer x = 18
integer width = 2798
integer height = 124
string dataobject = "d_comcast_activity_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
datawindowChild	ldwc

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE "receive_from_date"
		
		IF ib_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("receive_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_sched_from_first = FALSE
			
		END IF
		
	CASE "receive_to_date"
		
		IF ib_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("receive_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_sched_to_first = FALSE
			
		END IF
		
	CASE "complete_from_date"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("complete_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_to_date"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("complete_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
	Case 'supplier_id' /* 11/01 PCONKL - Only retrieve suppliers if clicked on*/
		
		This.GetChild('supplier_id',ldwc)
		If ldwc.RowCOunt() = 0 Then
			ldwc.SetTransObject(SQLCA)
			ldwc.Retrieve(gs_project)
		End If
		
	CASE ELSE
		
END CHOOSE

end event

event dw_select::constructor;
ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
ib_sched_from_first 		= TRUE
ib_sched_to_first 		= TRUE
ib_complete_from_first 	= TRUE
ib_complete_to_first 	= TRUE


end event

type cb_clear from w_std_report`cb_clear within w_comcast_activity_rpt
end type

type dw_report from w_std_report`dw_report within w_comcast_activity_rpt
integer x = 18
integer y = 136
integer width = 3575
integer height = 1696
integer taborder = 30
string dataobject = "d_comcast_activity_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

