HA$PBExportHeader$w_item_bom_report.srw
$PBExportComments$Item Master Bill of Material Report
forward
global type w_item_bom_report from w_std_report
end type
end forward

global type w_item_bom_report from w_std_report
integer width = 3534
integer height = 2024
string title = "Item Master BOM Report"
end type
global w_item_bom_report w_item_bom_report

type variables

String	is_OrigSql
end variables

on w_item_bom_report.create
call super::create
end on

on w_item_bom_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;String	lsWHere, lsNewSQL

dw_select.AcceptText()

//Always tackon Project and type
lsWhere = " Where Project_ID = '" + gs_Project + "' and component_Type = 'C'"

//Tackon Parent SKU if present 
If dw_select.GetItemString(1, "SKU") <> "" Then
	lsWhere = lsWhere + " and Item_Component.SKU_Parent = '" + dw_select.GetItemString(1, "SKU") + "'"
End If

//Tackon Child SKU if PResent
If dw_select.GetItemString(1, "Child_SKU") <> "" Then
	lsWhere = lsWhere + " and Item_Component.SKU_Parent in (SElect Sku_parent from Item_Component where Project_id = '" + gs_project + "' and sku_child = '" + dw_select.GetItemString(1, "Child_SKU") + "')"
End If

If lsWhere > '  ' Then
	lsNewSql = is_OrigSql + lsWhere 
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(is_OrigSql)
End If

dw_report.Retrieve(gs_Project)

If dw_report.RowCount() <=0 Then
	MessageBox('Item BOM','No Records Found!')
	im_menu.m_file.m_print.Enabled = False
Else
	im_menu.m_file.m_print.Enabled = True
End If
end event

event resize;call super::resize;
dw_report.Resize(workspacewidth() - 20,workspaceHeight()-150)
end event

event ue_postopen;call super::ue_postopen;
is_OrigSql = dw_report.getsqlselect()

//This.TriggerEvent('ue_retrieve')
end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)

end event

type dw_select from w_std_report`dw_select within w_item_bom_report
integer width = 3278
integer height = 100
string dataobject = "d_item_bom_report_search"
boolean border = false
end type

type cb_clear from w_std_report`cb_clear within w_item_bom_report
end type

type dw_report from w_std_report`dw_report within w_item_bom_report
integer y = 132
integer width = 3223
integer height = 1684
string dataobject = "d_item_bom_report"
boolean hscrollbar = true
end type

