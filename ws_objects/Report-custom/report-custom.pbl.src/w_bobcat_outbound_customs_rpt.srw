$PBExportHeader$w_bobcat_outbound_customs_rpt.srw
$PBExportComments$OutBound Order Report
forward
global type w_bobcat_outbound_customs_rpt from w_std_report
end type
end forward

global type w_bobcat_outbound_customs_rpt from w_std_report
integer width = 4379
integer height = 2060
string title = "BOBCAT OUTBOUND CUSTOMS REPORT"
end type
global w_bobcat_outbound_customs_rpt w_bobcat_outbound_customs_rpt

type variables
boolean ib_first_time

String	 isOrigSQL
end variables

on w_bobcat_outbound_customs_rpt.create
call super::create
end on

on w_bobcat_outbound_customs_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_order
Long  i, ll_cnt,j,ll_adj

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Check if a start date has been entered
if  not isnull(dw_select.GetItemstring(1,"order_no")) then
	ls_order = dw_select.GetItemstring(1, "order_no")
else
	Messagebox(is_title,"Please enter a valid Order Number...")
	Return 
END IF

dw_report.SetRedraw(False)

ll_cnt = dw_report.Retrieve(gs_project, ls_order) 
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True

Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse
string				lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "project_id = '" + gs_project + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
	dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
	
End If
end event

event open;call super::open;isOrigSql = dw_report.getsqlselect()

end event

type dw_select from w_std_report`dw_select within w_bobcat_outbound_customs_rpt
integer x = 18
integer width = 3131
string dataobject = "d_bobcat_outbound_customs_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;
//ll_row = This.insertrow(0)
ib_first_time = true


end event

type cb_clear from w_std_report`cb_clear within w_bobcat_outbound_customs_rpt
integer x = 3154
integer y = 12
integer width = 270
end type

type dw_report from w_std_report`dw_report within w_bobcat_outbound_customs_rpt
integer y = 188
integer width = 4311
integer height = 1704
string dataobject = "d_bobcat_outbound_customs_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

