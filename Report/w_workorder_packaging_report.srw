HA$PBExportHeader$w_workorder_packaging_report.srw
$PBExportComments$Workorder Packaging Report
forward
global type w_workorder_packaging_report from w_std_report
end type
end forward

global type w_workorder_packaging_report from w_std_report
integer width = 3552
integer height = 2044
string title = "Workorder Packaging Report"
end type
global w_workorder_packaging_report w_workorder_packaging_report

type variables
String	isOrigSQL
end variables

on w_workorder_packaging_report.create
call super::create
end on

on w_workorder_packaging_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;		
String	lsWhere,	&
			lsNewSQL,	&
			lsWONO,		&
			lsSKU

Long		llRowCOunt,	&
			llRowPos
			
Decimal	ldQTY

SetPointer(Hourglass!)
dw_report.SetRedraw(False)
w_main.SetMicrohelp('Retrieving Report data...')

dw_select.AcceptText()

//Always Tack on Project ID 
lswhere = " and Workorder_master.project_id = '" + gs_project + "'"

//Tackon Warehouse if PResent
If Not isnull(dw_Select.GetITemString(1,'wh_code')) Then
	lsWhere += " and workorder_master.Wh_code = '" + dw_Select.GetITemString(1,'wh_code') + "'"
End If

//Tackon Order Status if PResent
If Not isnull(dw_Select.GetITemString(1,'ord_status')) Then
	lsWhere += " and workOrder_master.ord_status = '" + dw_Select.GetITemString(1,'Ord_status') + "'"
End If

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1,"ord_date_From")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and WorkOrder_Master.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"ord_date_From"),'mm-dd-yyyy hh:mm') + "'"
End If

//Tackon To Order Date
If date(dw_select.GetItemDateTime(1,"ord_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and WorkOrder_Master.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
End If

//Tackon SKU if PResent for parent, child or either SKU
If Not isnull(dw_Select.GetITemString(1,'sku')) Then
	
	Choose Case Upper(dw_Select.GetITemString(1,'parent_child_Ind'))
			
		Case 'P' /*Parent SKU only*/
			
			lsWhere += " and WorkOrder_MASter.wo_no in (select wo_no from workorder_Detail where Sku = '" + dw_Select.GetITemString(1,'sku') + "')"
			
		Case 'C' /* Child Sku Only */
			
			lsWhere += " and WorkOrder_MASter.wo_no in (select wo_no from workorder_Detail where Sku in (Select sku_parent from item_Component where project_id = '" + gs_project + "' and sku_child = '" + dw_Select.GetITemString(1,'sku') + "'))"
			
		Case Else /*Either*/
			
			lsWhere += " and (WorkOrder_MASter.wo_no in (select wo_no from workorder_Detail where Sku = '" + dw_Select.GetITemString(1,'sku') + "')"
			lsWhere += " or WorkOrder_MASter.wo_no in (select wo_no from workorder_Detail where Sku in (Select sku_parent from item_Component where project_id = '" + gs_project + "' and sku_child = '" + dw_Select.GetITemString(1,'sku') + "')))"
	End Choose
	
End If

//Modify SQL - Where Clause needs to go before group by
//lsNewSql = isorigsql + lsWhere 
lsNewSQL = Replace(isOrigSql, (Pos(isOrigSql,"Group By") - 1),1,lsWhere)
dw_report.setsqlselect(lsNewsql)

If dw_report.Retrieve(gs_Project) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

//set the remaining required qty - not using computed field so it can be exported
llRowCount = dw_report.RowCount() 
If llRowCount > 0 Then
	For llRowPos = 1 to llRowCount
		If not isnull(dw_report.GetITemNumber(llRowPOs,'reserved_qty')) Then
			dw_report.SetItem(llRowPos,'remaining_req_qty',dw_report.GetITemNumber(llRowPOs,'extended_req_qty') - dw_report.GetITemNumber(llRowPOs,'reserved_qty'))
		Else
			dw_report.SetItem(llRowPos,'remaining_req_qty',dw_report.GetITemNumber(llRowPOs,'extended_req_qty'))
		End If
	Next
End If

SetPointer(Arrow!)
dw_report.SetRedraw(True)
w_main.SetMicrohelp('Ready')
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-300)
end event

event ue_postopen;call super::ue_postopen;
DatawindowChild	Ldwc, ldwc2

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

//populate warehouse dropdown
dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//populate WorkOrder Type dropdown
dw_select.GetChild('ord_type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//Share with Report
dw_report.GetChild('ord_type', ldwc2)
ldwc.ShareData(ldwc2)

dw_Select.SetItem(1,'wh_code',gs_default_wh)
dw_select.SetItem(1,'ord_status','N')



end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_Select.InsertRow(0)
dw_Select.SetItem(1,'wh_code',gs_default_wh)
end event

type dw_select from w_std_report`dw_select within w_workorder_packaging_report
integer x = 23
integer width = 3415
integer height = 272
string dataobject = "d_workorder_report_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;
This.modify("t_3.visible=false t_5.visible=false t_6.visible=false ord_type_t.visible=false")
This.modify("comp_date_from.visible=false comp_date_to.visible = False ord_type.visible=false")
end event

type cb_clear from w_std_report`cb_clear within w_workorder_packaging_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_workorder_packaging_report
integer x = 0
integer y = 304
integer width = 3474
integer height = 1512
string dataobject = "d_workorder_packaging"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

