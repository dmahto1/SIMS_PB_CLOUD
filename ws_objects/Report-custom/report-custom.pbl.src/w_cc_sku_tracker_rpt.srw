$PBExportHeader$w_cc_sku_tracker_rpt.srw
$PBExportComments$Cycle Count SKU Tracker Report
forward
global type w_cc_sku_tracker_rpt from w_std_report
end type
end forward

global type w_cc_sku_tracker_rpt from w_std_report
string title = "SKU Tracker Cycle Count"
end type
global w_cc_sku_tracker_rpt w_cc_sku_tracker_rpt

type variables
DataWindowChild idwc_warehouse, idwc_group, idwc_sku

string is_origsql, is_grp

end variables

on w_cc_sku_tracker_rpt.create
call super::create
end on

on w_cc_sku_tracker_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//is_OrigSql = dw_report.getsqlselect()

dw_report.Reset()
end event

event ue_postopen;call super::ue_postopen;// Initialize group
is_grp = ""

//Loading from USer Warehouse Datastore
dw_select.GetChild("wh_code", idwc_warehouse)
idwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(idwc_warehouse)

dw_select.GetChild("group", idwc_group)
idwc_group.SetTransObject(sqlca)
idwc_group.Retrieve(gs_project)

idwc_group.InsertRow(1)
idwc_group.ScrollToRow(1)
idwc_group.SelectRow(1, true)

dw_select.GetChild("sku",idwc_sku)
idwc_sku.SetTransObject(sqlca)
idwc_sku.Retrieve(gs_project)

idwc_sku.InsertRow(1)
idwc_sku.ScrollToRow(1)
idwc_sku.SelectRow(1, true)
idwc_sku.SetItem(1,"sku","")
idwc_sku.SetSort("#1 A")
idwc_sku.Sort()


is_grp = idwc_group.GetItemString(1, "grp")
if isnull(is_grp) then is_grp = ""


end event

event ue_retrieve;call super::ue_retrieve;long 	ll_cnt
String  lsWarehouse, lsGroup, lsSku

lsWarehouse = dw_select.GetItemString(1,"wh_code") 
lsGroup = dw_select.GetItemString(1,"group")
lsSku = dw_select.GetItemString(1,"sku")

If isNull(lsWarehouse) then lsWarehouse = ""
If isNull(lsGroup) then lsGroup = ""
If isNull(lsSku) then lsSku = ""

ll_cnt = dw_report.Retrieve(gs_project, lsWarehouse, lsGroup, lsSku)

If ll_cnt < 1 then

	MessageBox(is_title, "No record found!")
	Return
	
End If


end event

event resize;call super::resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()

idwc_sku.SetFilter("")
idwc_sku.Filter()


end event

type dw_select from w_std_report`dw_select within w_cc_sku_tracker_rpt
integer width = 3191
integer height = 120
string dataobject = "d_cc_sku_tracker_search"
boolean border = false
end type

event dw_select::itemchanged;call super::itemchanged;int	li_row, li_column, li_rowcnt
String ls_sku, ls_grp, ls_filter, ls_text

li_column = dw_select.GetColumn()		// Change SKU dropdown only if changing Group

if li_column = 1 then							// Reset Group and SKU
	idwc_sku.SetRedraw(false)
	dw_select.SetColumn(2)
	dw_select.SetText("")
	dw_select.SetColumn(3)
	dw_select.SetText("")
		idwc_sku.ScrollToRow(1)
		idwc_sku.SelectRow(1, true)
	idwc_sku.SetRedraw(false)
elseif li_column = 2 then
	li_row = idwc_group.GetSelectedRow(0)
	ls_grp = idwc_group.GetItemString(li_row,"grp")
	if isnull(ls_grp) then ls_grp = ""
	
	if (ls_grp = is_grp) then
		//idwc_sku.SetSort("#1 A")
		//idwc_sku.Sort()
	else
		ls_filter = ""
		idwc_sku.SetFilter(ls_filter)
		idwc_sku.Filter()
	
		if isnull(ls_grp)  then
			ls_filter = ""
		else
			ls_filter = "item_master_grp = '" + ls_grp + "' OR sku = ''"
		end if
		is_grp = ls_grp
		idwc_sku.SetRedraw(false)
		
		idwc_sku.SetFilter(ls_filter)
		idwc_sku.Filter()
		
		idwc_sku.SetSort("#1 A")
		idwc_sku.Sort()

		idwc_sku.ScrollToRow(1)
		idwc_sku.SelectRow(1, true)
		
		dw_select.SetColumn(3)
		dw_select.SetText("")
	
		idwc_sku.SetRedraw(true)
	end if
end if






end event

type cb_clear from w_std_report`cb_clear within w_cc_sku_tracker_rpt
end type

type dw_report from w_std_report`dw_report within w_cc_sku_tracker_rpt
integer y = 160
integer height = 1424
string dataobject = "d_cc_sku_tracker_rpt"
end type

