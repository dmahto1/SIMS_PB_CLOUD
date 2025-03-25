$PBExportHeader$w_pending_delivery_report.srw
$PBExportComments$Pending Delivery ORder Report
forward
global type w_pending_delivery_report from w_std_report
end type
end forward

global type w_pending_delivery_report from w_std_report
integer width = 3552
integer height = 2044
string title = "Consolidation Report"
end type
global w_pending_delivery_report w_pending_delivery_report

type variables
String	isOrigSQL
end variables

on w_pending_delivery_report.create
call super::create
end on

on w_pending_delivery_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;
String	lsWarehouse

lsWarehouse = dw_Select.GetITemString(1,'wh_Code')

dw_select.AcceptText()

dw_report.Retrieve(gs_project, lsWarehouse)

If dw_report.RowCount() <=0 Then
	MessageBox('Consolidation','No records found!')
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-150)
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	Ldwc, ldwc2

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

//Populate WH dropdown for Current Project
dw_select.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
If ldwc.RowCount() <= 0 Then ldwc.InsertRow(0)
dw_Select.SetITem(1,'wh_code','AMS')





end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_Select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_pending_delivery_report
integer x = 23
integer width = 3451
integer height = 100
string dataobject = "d_pending_delivery_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_pending_delivery_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_pending_delivery_report
integer x = 5
integer y = 132
integer width = 3474
integer height = 1412
string dataobject = "d_pending_delivery_order_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

