HA$PBExportHeader$w_supplier_master_rpt.srw
$PBExportComments$Window used for supplier information
forward
global type w_supplier_master_rpt from w_std_report
end type
end forward

global type w_supplier_master_rpt from w_std_report
int Width=3671
int Height=2072
boolean TitleBar=true
string Title="Supplier Master Report"
end type
global w_supplier_master_rpt w_supplier_master_rpt

on w_supplier_master_rpt.create
call super::create
end on

on w_supplier_master_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-75)
end event

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

type dw_select from w_std_report`dw_select within w_supplier_master_rpt
boolean Visible=false
end type

type dw_report from w_std_report`dw_report within w_supplier_master_rpt
int Y=28
int Width=3557
int Height=1828
string DataObject="d_supplier_master_rpt"
boolean HScrollBar=true
end type

