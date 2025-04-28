$PBExportHeader$w_consolidation_summary_rpt.srw
$PBExportComments$Consolidation Summary Report
forward
global type w_consolidation_summary_rpt from w_std_report
end type
end forward

global type w_consolidation_summary_rpt from w_std_report
integer width = 3552
integer height = 2044
string title = "Consolidation Report"
end type
global w_consolidation_summary_rpt w_consolidation_summary_rpt

type variables
String	isOrigSQL
end variables

on w_consolidation_summary_rpt.create
call super::create
end on

on w_consolidation_summary_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;
String	lsConsolNbr, lsWhere, lsNewSQL

lsNewSQL = isOrigSql

dw_select.AcceptText()

lsWhere = " And Consolidation_MAster.Project_ID = '" + gs_project + "'" /*Always tackon project*/

//Order Status
If dw_Select.GetItemString(1,'ord_Status') > '' Then
	lsWhere += " and Consolidation_MAster.ord_Status = '" + dw_Select.GetItemString(1,'ord_Status') + "'"
End If

//Source WH
If dw_Select.GetItemString(1,'fr_wh_code') > '' Then
	lsWhere += " and from_wh_code = '" + dw_Select.GetItemString(1,'fr_wh_code') + "'"
End If

//Dest WH
If dw_Select.GetItemString(1,'to_wh_code') > '' Then
	lsWhere += " and to_wh_code = '" + dw_Select.GetItemString(1,'to_wh_code') + "'"
End If

//House AWB BOL NBR
If dw_Select.GetItemString(1,'awb_bol_nbr') > '' Then
	lsWhere += " and Consolidation_MAster.awb_bol_nbr = '" + dw_Select.GetItemString(1,'awb_bol_nbr') + "'"
End If

// Master AWB BOL NBR
If dw_Select.GetItemString(1,'master_awb_bol_nbr') > '' Then
	lsWhere += " and Consolidation_MAster.master_awb_bol_no = '" + dw_Select.GetItemString(1,'master_awb_bol_nbr') + "'"
End If

//Order Date From
If not isnull(dw_Select.GetItemDateTime(1,'order_date_from'))  Then
	lsWhere += " and Consolidation_MAster.ord_date >= '" + String(dw_Select.GetItemDateTime(1,'order_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Order Date To
If not isnull(dw_Select.GetItemDateTime(1,'order_date_to'))  Then
	lsWhere += " and Consolidation_MAster.ord_date <= '" + String(dw_Select.GetItemDateTime(1,'order_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Receive Date From
If not isnull(dw_Select.GetItemDateTime(1,'receive_date_from'))  Then
	lsWhere += " and Consolidation_MAster.receive_date >= '" + String(dw_Select.GetItemDateTime(1,'receive_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Receive Date To
If not isnull(dw_Select.GetItemDateTime(1,'receive_date_to'))  Then
	lsWhere += " and Consolidation_MAster.receive_date <= '" + String(dw_Select.GetItemDateTime(1,'receive_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Complete Date From
If not isnull(dw_Select.GetItemDateTime(1,'Complete_date_from'))  Then
	lsWhere += " and Consolidation_MAster.Complete_date >= '" + String(dw_Select.GetItemDateTime(1,'Complete_date_from'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If 

//Complete Date To
If not isnull(dw_Select.GetItemDateTime(1,'Complete_date_to'))  Then
	lsWhere += " and Consolidation_MAster.Complete_date <= '" + String(dw_Select.GetItemDateTime(1,'Complete_date_to'), "yyyy-mm-dd hh:mm:ss")  + "'"
End If

//Where clause needs to go before 'Group BY'
LsNewSQL = Replace(lsNewSQL, (Pos(Upper(lsNewSQL),'GROUP BY') - 1), 1, lsWhere)

dw_report.SetSQLSelect(lsNewSQL)


dw_report.Retrieve()

If dw_report.RowCount() <=0 Then
	MessageBox('Consolidation','No records found!')
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-350)
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	Ldwc, ldwc2

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

//Populate WH dropdown for Current Project
dw_select.GetChild("fr_wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)

//Share with To warehouse 
dw_select.GetChild("to_wh_code",ldwc2)
ldwc.Sharedata(ldwc2)




end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_Select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_consolidation_summary_rpt
integer x = 23
integer width = 3451
integer height = 324
string dataobject = "d_consol_summary_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_consolidation_summary_rpt
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_consolidation_summary_rpt
integer x = 5
integer y = 340
integer width = 3474
integer height = 1412
string dataobject = "d_consolidation_summary_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

