HA$PBExportHeader$w_riverbed_bom_rpt.srw
$PBExportComments$Riverbed BOM Report
forward
global type w_riverbed_bom_rpt from w_std_report
end type
end forward

global type w_riverbed_bom_rpt from w_std_report
integer width = 3730
integer height = 2132
string title = "Delivery Report"
end type
global w_riverbed_bom_rpt w_riverbed_bom_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first 
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_receive_from_first
boolean ib_receive_to_first
end variables

on w_riverbed_bom_rpt.create
call super::create
end on

on w_riverbed_bom_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_sku, lsWhere, lsNewSql
Long ll_balance, i, ll_cnt
Boolean lb_where			

If dw_select.AcceptText() = -1 Then Return

//Initialize date flags
lb_where          = FALSE
SetPointer(HourGlass!)
dw_report.Reset()

IF (dw_select.GetItemString(1,"order_number") = "") or isnull(dw_select.GetItemString(1,"order_number")) THEN
	MessageBox("ERROR", "Please select an Order Number",stopsign!)
ELSE


	lsWhere = ''

	//always tackon Project and invoice Number
	lsWhere += " and Delivery_Master.project_id = '" + gs_project + "'"
	lswhere += " and Delivery_Master.invoice_no = '" + dw_select.GetItemString(1,"order_number") + "'"

	lsNewSql = isOrigSql + lsWhere 

	//If Workorder is selected then change the query to look at workorders
	if  dw_select.GetItemString(1,"orde_type_flag") = 'W'  then
		Do While Pos(Upper(lsNewSQL),'DELIVERY_MASTER') > 0
			lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'DELIVERY_MASTER'), 15, 'WORKORDER_MASTER')
		Loop
		Do While Pos(Upper(lsNewSQL),'DO_NO') > 0
			lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'DO_NO'), 5, 'WO_NO')
		Loop
		Do While Pos(Upper(lsNewSQL),'INVOICE_NO') > 0
			lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'INVOICE_NO'), 10, 'WorkOrder_Number')
		Loop
	End If
	
	dw_report.setsqlselect(lsNewsql)


	ll_cnt = dw_report.Retrieve()
	If ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If

End If


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-310)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;dw_select.SetItem(1,"orde_type_flag",'D') 

end event

type dw_select from w_std_report`dw_select within w_riverbed_bom_rpt
integer x = 18
integer y = 0
integer width = 3648
integer height = 292
string dataobject = "d_riverbed_delivery_bom_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;string 	ls_column

long		ll_row


dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


end event

type cb_clear from w_std_report`cb_clear within w_riverbed_bom_rpt
end type

type dw_report from w_std_report`dw_report within w_riverbed_bom_rpt
integer x = 0
integer y = 300
integer width = 3625
integer height = 1592
integer taborder = 30
string dataobject = "d_riverbed_delivery_bom_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

