$PBExportHeader$w_riverbed_inventory_by_sku.srw
$PBExportComments$Window used for processing Inventory by SKU information
forward
global type w_riverbed_inventory_by_sku from w_std_report
end type
end forward

global type w_riverbed_inventory_by_sku from w_std_report
integer width = 3529
integer height = 2116
string title = "Inventory By SKU"
end type
global w_riverbed_inventory_by_sku w_riverbed_inventory_by_sku

type variables
String	is_OrigSql
string       is_select1, is_select2
string       is_where1, is_where2
string       is_groupby1, is_groupby2
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time

end variables

on w_riverbed_inventory_by_sku.create
call super::create
end on

on w_riverbed_inventory_by_sku.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Integer  li_pos_g1, li_pos_g2, li_pos_s1, li_pos_s2, li_pos_w1, li_pos_w2

is_OrigSql = dw_report.getsqlselect()

//Get SELECT, WHERE and GROUPBY statements
li_pos_s1 = pos(is_origsql,"SELECT",1)
li_pos_s2 = pos(is_origsql,"SELECT", li_pos_s1 +1)
li_pos_w1 = pos(is_origsql,"WHERE",1)
li_pos_w2 = pos(is_origsql,"WHERE",li_pos_w1 + 1)
li_pos_g1 = pos(is_origsql,"GROUP BY",1)
li_pos_g2 = pos(is_origsql,"GROUP BY",li_pos_g1 + 1)

is_select1 = mid(is_origsql,1,li_pos_w1 - 1)
is_select2 = mid(is_origsql,li_pos_s2,li_pos_w2 - li_pos_s2 - 1)

is_where1 = mid(is_origsql,li_pos_w1,li_pos_g1 - li_pos_w1 - 1)
is_where2 = mid(is_origsql,li_pos_w2,li_pos_g2 - li_pos_w2 - 1)

is_groupby1 = mid(is_origsql,li_pos_g1,li_pos_s2 - li_pos_g1 - 1)
is_groupby2 = mid(is_origsql,li_pos_g2)


//li_pos = pos(is_origsql,"GROUP BY",1)
////is_groupby = mid(is_origsql,794)
//is_groupby = mid(is_origsql,li_pos)
//IF li_pos > 0 THEN li_pos=li_pos - 1
////is_select = mid(is_origsql,1,793)
//is_select = mid(is_origsql,1,li_pos)
//is_OrigSql = dw_report.getsqlselect()


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String ls_sku, ls_supp_code, ls_rono
String ls_Where, ls_DS_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name
integer li_new_report_row

Long ll_balance, ll_Find
Long i
long ll_cnt, ll_Idx, ll_avail_qty
long ll_find_row, ll_rowline_idx


string	ls_return_sku[]

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Always add project
ls_where += " and cs.project_id = '" + gs_project + "'"


long ll_ageing


//Tackon SKU if present
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
	ls_where += " and cs.sku = '" + ls_value + "'"
end if

// 05/01 PCONKL - Tackon Inventory Type if Present
if  (NOT isnull(dw_select.GetItemString(1,"inv_type")) AND (dw_select.GetItemString(1,"inv_type") > ' ')) THEN
	ls_where += " and cs.inventory_type = '" + dw_select.GetItemString(1,"inv_type") + "'"
end if

// 09/04 PCONKL - Tackon Supplier if Present
if  (NOT isnull(dw_select.GetItemString(1,"supp_code")) AND (dw_select.GetItemString(1,"supp_code") > ' ')) THEN
	ls_where += " and cs.supp_code = '" + dw_select.GetItemString(1,"supp_code") + "'"
end if

//Process Warehouse Number
IF ib_first_time  = TRUE THEN
  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	  
	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN													
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		END IF
	END IF
	ib_first_time = false
  
ELSE
	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
															
	IF ll_find_row > 0 THEN
		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
			
	else
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		END IF
	END IF
END IF

ls_newsql = is_select1 + " " + is_where1 + "  " + ls_where + "  " + is_groupby1 + " " + is_select2 + " " + is_where2 + "  " + ls_where + "  " + is_groupby2
dw_report.setsqlselect(ls_Newsql)

//ls_newsql = is_select + ls_where + "  " + is_groupby
//messagebox("ls newsql", ls_newsql)
//If ls_Where > '  ' Then
//	ls_NewSql = is_select + ls_Where +"   " + is_groupby
//	dw_report.setsqlselect(ls_Newsql)
//	
//Else
//	
//	dw_report.setsqlselect(is_select + ls_where + "  " + is_groupby)
//End If

IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	
ELSE
	

	ll_cnt = dw_report.Retrieve()

	If ll_cnt >= 0 Then
		im_menu.m_file.m_print.Enabled = True
		
	
		dw_report.SetRedraw(true)
		
		
		dw_report.Setfocus()
	
	END IF
	
	IF dw_report.RowCount() <= 0  THEN
	
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
END IF

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
	

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
	If ldwc_warehouse.RowCount() > 0 Then
		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
	End If
	
End If


end event

type dw_select from w_std_report`dw_select within w_riverbed_inventory_by_sku
integer x = 0
integer width = 3227
integer height = 188
string dataobject = "d_sku"
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

type cb_clear from w_std_report`cb_clear within w_riverbed_inventory_by_sku
integer x = 3365
integer y = 8
integer width = 96
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_riverbed_inventory_by_sku
integer x = 5
integer y = 204
integer width = 3438
integer height = 1716
integer taborder = 30
string dataobject = "d_riverbed_inventory_by_sku"
boolean hscrollbar = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

