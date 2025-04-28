$PBExportHeader$w_inventory_by_type.srw
$PBExportComments$Window used for processing Inventory by SKU information
forward
global type w_inventory_by_type from w_std_report
end type
end forward

global type w_inventory_by_type from w_std_report
integer width = 3529
integer height = 2120
string title = "Inventory By Type Report"
end type
global w_inventory_by_type w_inventory_by_type

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time

end variables

on w_inventory_by_type.create
call super::create
end on

on w_inventory_by_type.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Integer  li_pos,ll_len


is_OrigSql = trim(dw_report.getsqlselect())
//messagebox("is origsql",is_origsql)
li_pos = pos(is_origsql,"Group by",1)
//is_groupby = mid(is_origsql,794)
is_groupby = mid(is_origsql,li_pos)
ll_len= pos(is_groupby,';',1) 
is_groupby = mid(is_groupby,1,(ll_len - 1))
//Messagebox("",is_groupby)
IF li_pos > 0 THEN li_pos=li_pos - 1
//is_select = mid(is_origsql,1,793)
is_select = mid(is_origsql,1,li_pos)
is_OrigSql = dw_report.getsqlselect()


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String ls_sku
String ls_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name


Long ll_balance
Long i
long ll_cnt
long ll_find_row

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Tack on project id & SKU number
ls_value = dw_select.GetItemString(1,"sku")
ls_where += " and dbo.item_master.project_id = '" + gs_project + "'"


// 05/01 PCONKL - Tackon Inventory Type if Present
if  (NOT isnull(dw_select.GetItemString(1,"inv_type")) AND (dw_select.GetItemString(1,"inv_type") > ' ')) THEN
	ls_where += " and dbo.content.inventory_type = '" + dw_select.GetItemString(1,"inv_type") + "'"
ELSE
	Messagebox("Inventory by Type", "Please select an inventory type",stopsign!)
	Return
end if

//Process Warehouse Number
//IF ib_first_time  = TRUE THEN
  	ls_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
	IF isnull(ls_warehouse_code) or ls_warehouse_code = '' THEN
	  Messagebox("ERROR", "Please select a warehouse",stopsign!)
	  Return
	ELSE 
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + ls_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			ls_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			ls_where += " and dbo.content.wh_code = '" + ls_warehouse_code + "'"
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		END IF	
	END IF	
	
//	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//	IF ll_find_row > 0 THEN
//		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//		ls_where += " and dbo.content.wh_code = '" + is_warehouse_code + "'"
//		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//	ELSE
//		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//		IF ll_find_row > 0 THEN													
//			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//			ls_where += " and dbo.content.wh_code = '" + is_warehouse_code + "'"
//		END IF
//	END IF
//	ib_first_time = false
//  
//ELSE
//	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
//	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//															
//	IF ll_find_row > 0 THEN
//		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//		ls_where += " and dbo.content.wh_code = '" + is_warehouse_code + "'"
//			
//	else
//		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//		IF ll_find_row > 0 THEN
//			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//			ls_where += " and dbo.content.wh_code = '" + is_warehouse_code + "'"
//		END IF
//	END IF
//END IF


//messagebox("ls newsql", ls_newsql)
If ls_Where > '  ' Then
	ls_newsql = is_select + ls_where + is_groupby
	dw_report.setsqlselect(ls_Newsql)	
Else	
	dw_report.setsqlselect(is_origsql)
End If
	
//IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
//	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	
//ELSE
	ll_cnt = dw_report.Retrieve()
		
	If ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
//END IF
//
is_warehouse_code = " "



end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse, ldwc
string	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('inv_type', ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve()
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()
	

// LTK 20150827  Commented out block below.  Populate warehouse DDDW via common method which uses user's configured warehouses
//
//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
//	If ldwc_warehouse.RowCount() > 0 Then
//		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
//	End If
//	
//End If

dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if

end event

event ue_print;dw_report.Object.DataWindow.Print.Orientation=1
OpenWithParm(w_dw_print_options,dw_report) 
 
end event

type dw_select from w_std_report`dw_select within w_inventory_by_type
integer x = 0
integer width = 3227
integer height = 116
string dataobject = "d_inventory_type_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ib_first_time = true




end event

type cb_clear from w_std_report`cb_clear within w_inventory_by_type
integer x = 3365
integer y = 8
integer width = 96
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_inventory_by_type
integer x = 23
integer y = 124
integer width = 3438
integer height = 1796
integer taborder = 30
string dataobject = "d_inventory_type"
boolean hscrollbar = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

