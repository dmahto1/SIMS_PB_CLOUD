$PBExportHeader$w_customer_master_rpt.srw
$PBExportComments$Window object used for the customer master report
forward
global type w_customer_master_rpt from w_std_report
end type
end forward

global type w_customer_master_rpt from w_std_report
int Width=3653
int Height=2092
boolean TitleBar=true
string Title="Customer Master Report"
end type
global w_customer_master_rpt w_customer_master_rpt

on w_customer_master_rpt.create
call super::create
end on

on w_customer_master_rpt.destroy
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

type dw_select from w_std_report`dw_select within w_customer_master_rpt
boolean Visible=false
end type

type dw_report from w_std_report`dw_report within w_customer_master_rpt
int X=32
int Y=32
int Width=3534
int Height=1852
string DataObject="d_customer_master_rpt"
boolean HScrollBar=true
end type

