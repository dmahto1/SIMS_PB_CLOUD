$PBExportHeader$w_shipping_schedule.srw
$PBExportComments$Process Shipping Schedules (862) and create Delivery Orders
forward
global type w_shipping_schedule from w_std_report
end type
end forward

global type w_shipping_schedule from w_std_report
integer height = 2024
string title = "Shipping Schedules (862)"
end type
global w_shipping_schedule w_shipping_schedule

type variables

String	is_OrigSql
end variables

on w_shipping_schedule.create
call super::create
end on

on w_shipping_schedule.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;String	lsWHere, lsNewSQL

//TAckon SQL
dw_Select.AcceptText()

//always add Project
lsWhere = " and  Shipping_Schedule_Master.Project_id = '" + gs_Project + "'"

//Release Number
If dw_Select.GEtITemstring(1,'release_no') > '' Then
	lsWhere += " and forecast_release_no = '" + dw_Select.GEtITemstring(1,'release_no') + "'"
End If

//Forecast Type
If dw_Select.GEtITemstring(1,'forecast_Type') > '' Then
	lsWhere += " and forecast_type = '" + dw_Select.GEtITemstring(1,'forecast_Type') + "'"
End If

//Ship To
If dw_Select.GEtITemstring(1,'ship_to') > '' Then
	lsWhere += " and ship_to_uccs_Code = '" + dw_Select.GEtITemstring(1,'ship_to') + "'"
End If

//Schedule Issue Date (From)
If Not isnull(dw_Select.GetITemDateTime(1,'issue_date_From')) Then
	lsWhere += " and schedule_issue_date >= '" + string(dw_select.GetItemDateTime(1, "issue_date_From"),'mm-dd-yyyy hh:mm') + "'"
End If

//Schedule Issue Date (TO)
If Not isnull(dw_Select.GetITemDateTime(1,'issue_date_To')) Then
	lsWhere += " and schedule_issue_date <= '" + string(dw_select.GetItemDateTime(1, "issue_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If

//Schedule Begin Date (From)
If Not isnull(dw_Select.GetITemDateTime(1,'begin_date_From')) Then
	lsWhere += " and schedule_begin_date >= '" + string(dw_select.GetItemDateTime(1, "begin_date_From"),'mm-dd-yyyy hh:mm') + "'"
End If

//Schedule Begin Date (TO)
If Not isnull(dw_Select.GetITemDateTime(1,'begin_date_To')) Then
	lsWhere += " and schedule_begin_date <= '" + string(dw_select.GetItemDateTime(1, "begin_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If

//Schedule End Date (From)
If Not isnull(dw_Select.GetITemDateTime(1,'end_date_From')) Then
	lsWhere += " and schedule_end_date >= '" + string(dw_select.GetItemDateTime(1, "end_date_From"),'mm-dd-yyyy hh:mm') + "'"
End If

//Schedule End Date (TO)
If Not isnull(dw_Select.GetITemDateTime(1,'end_date_To')) Then
	lsWhere += " and schedule_end_date <= '" + string(dw_select.GetItemDateTime(1, "end_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If
//
//Customer Code - may map to UF1 or UF7 on Customer master, should be unique though
If dw_Select.GEtITemstring(1,'cust_Code') > '' Then
	lsWhere += " and (ship_to_uccs_Code = (Select user_field1 from Customer where Project_id = '" + gs_project + "' and Cust_Code = '" + dw_Select.GEtITemstring(1,'cust_Code') + "')"
	lsWhere += " or ship_to_uccs_Code = (Select user_field7 from Customer where Project_id = '" + gs_project + "' and Cust_Code = '" + dw_Select.GEtITemstring(1,'cust_Code') + "')) "
End If

lsNewSQL = is_origSQL + lsWhere
dw_report.SetSqlSelect(lsNewSQL)

dw_report.Retrieve()

If dw_report.RowCount() <=0 Then
	MessageBox('Shipping Schedules','No Records Found!')
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If
end event

event resize;call super::resize;
dw_report.Resize(workspacewidth() - 40,workspaceHeight()-400)
end event

event ue_postopen;call super::ue_postopen;
is_OrigSql = dw_report.getsqlselect()

//default Issue date to current date
//dw_select.SetItem(1,'issue_Date_From',f_get_Date('BEGIN'))
//dw_select.SetItem(1,'issue_Date_To',f_get_Date('END'))
end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_shipping_schedule
integer width = 3278
integer height = 320
string dataobject = "d_shipping_schedule_search"
boolean border = false
end type

type cb_clear from w_std_report`cb_clear within w_shipping_schedule
end type

type dw_report from w_std_report`dw_report within w_shipping_schedule
integer y = 348
integer height = 1448
string dataobject = "d_shipping_schedule"
end type

