HA$PBExportHeader$w_customer_master_rpt_chinese.srw
$PBExportComments$Window object used for the customer master report
forward
global type w_customer_master_rpt_chinese from w_std_report
end type
end forward

global type w_customer_master_rpt_chinese from w_std_report
integer width = 3653
integer height = 2092
string title = "Customer Master Report"
end type
global w_customer_master_rpt_chinese w_customer_master_rpt_chinese

on w_customer_master_rpt_chinese.create
call super::create
end on

on w_customer_master_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;dw_report.Object.t_project.text = gs_project
end event

event ue_retrieve;long ll_cnt



If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()



ll_cnt = dw_report.Retrieve(gs_project)
IF ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If




end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-75)
end event

type dw_select from w_std_report`dw_select within w_customer_master_rpt_chinese
boolean visible = false
end type

type cb_clear from w_std_report`cb_clear within w_customer_master_rpt_chinese
end type

type dw_report from w_std_report`dw_report within w_customer_master_rpt_chinese
integer x = 32
integer y = 32
integer width = 3534
integer height = 1852
string dataobject = "d_customer_master_rpt_chinese"
boolean hscrollbar = true
end type

