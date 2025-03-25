$PBExportHeader$w_ws_awi_stock_arrival_alert_rpt.srw
forward
global type w_ws_awi_stock_arrival_alert_rpt from w_std_report
end type
end forward

global type w_ws_awi_stock_arrival_alert_rpt from w_std_report
boolean visible = false
integer width = 5691
integer height = 2144
string title = "W&S Inbound Customs Declaration Rpt"
end type
global w_ws_awi_stock_arrival_alert_rpt w_ws_awi_stock_arrival_alert_rpt

on w_ws_awi_stock_arrival_alert_rpt.create
call super::create
end on

on w_ws_awi_stock_arrival_alert_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;//TAM W&S 08/2012 
string ls_ro_no
string ls_invoice_no

long ll_cnt

boolean lb_selection

lb_selection = FALSE
If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_ro_no = w_ro.idw_main.getitemstring(1,"RO_NO")

select supp_invoice_no into :ls_invoice_no from receive_master where ro_no = :ls_ro_no and project_id = :gs_project;

dw_select.SetItem(1,"order_no", ls_invoice_no)



ll_cnt = dw_report.Retrieve(gs_project,ls_ro_no)

IF ll_cnt > 0  THEN
	im_menu.m_file.m_print.Enabled = TRUE
	dw_report.modify('DataWindow.Print.Preview ="yes"')
	dw_report.Setfocus()
ELSE
	im_menu.m_file.m_print.Enabled = FALSE	
	MessageBox(is_title, "Orders found in New status!")
	close(this)
//	dw_select.Setfocus()
//	dw_select.SetColumn('order_no')
END IF
		


end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)
end event

event ue_postopen;call super::ue_postopen;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
//If Receive Order is Open, default the Order to the current Receive Order Number
If isVAlid(w_ro) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		This.TriggerEvent('ue_retrieve')
	End If
Else
	messagebox("Wine and Spirit Stock Arrival Alert","You must open a Receive Order before you can print this report.!")
	close(this)
End If
end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight() - 10)


end event

type dw_select from w_std_report`dw_select within w_ws_awi_stock_arrival_alert_rpt
boolean visible = false
integer x = 5
integer width = 41
integer height = 36
boolean enabled = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_ws_awi_stock_arrival_alert_rpt
integer x = 3035
integer y = 36
end type

type dw_report from w_std_report`dw_report within w_ws_awi_stock_arrival_alert_rpt
integer x = 0
integer y = 0
integer width = 5627
integer height = 1944
string dataobject = "d_ws_awi_stock_arrival_alert"
boolean hscrollbar = true
boolean livescroll = false
end type

