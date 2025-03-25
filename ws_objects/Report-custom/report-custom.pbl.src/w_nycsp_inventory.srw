$PBExportHeader$w_nycsp_inventory.srw
$PBExportComments$Window used for processing Inventory by SKU information
forward
global type w_nycsp_inventory from w_std_report
end type
end forward

global type w_nycsp_inventory from w_std_report
integer width = 3790
integer height = 2116
string title = "Inventory By SKU"
end type
global w_nycsp_inventory w_nycsp_inventory

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time
boolean 			ib_expire_from_first
boolean 			ib_expire_to_first


end variables

forward prototypes
public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing)
end prototypes

public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing);

dw_report.SetItem(report_row, "content_project_id", returns_dw.GetItemString( return_row, "content_project_id"))
dw_report.SetItem(report_row, "content_wh_code", returns_dw.GetItemString( return_row, "content_wh_code"))
dw_report.SetItem(report_row, "content_supp_code", returns_dw.GetItemString( return_row, "content_supp_code"))
dw_report.SetItem(report_row, "supp_name", returns_dw.GetItemString( return_row, "supp_name"))
dw_report.SetItem(report_row, "content_sku", returns_dw.GetItemString( return_row, "content_sku"))
dw_report.SetItem(report_row, "item_master_alternate_sku", returns_dw.GetItemString( return_row, "item_master_alternate_sku"))
dw_report.SetItem(report_row, "item_master_description", returns_dw.GetItemString( return_row, "item_master_description"))
dw_report.SetItem(report_row, "item_master_std_cost", returns_dw.GetItemDecimal( return_row, "item_master_std_cost"))
dw_report.SetItem(report_row, "project_name", returns_dw.GetItemString( return_row, "project_name"))
dw_report.SetItem(report_row, "avail_qty", returns_dw.GetItemDecimal( return_row, "avail_qty"))
dw_report.SetItem(report_row, "season_code", returns_dw.GetItemString( return_row, "season_code"))
dw_report.SetItem(report_row, "brand", returns_dw.GetItemString( return_row, "brand"))	
dw_report.SetItem(report_row, "sub_category", returns_dw.GetItemString( return_row, "sub_category"))
dw_report.SetItem(report_row, "gender_category", returns_dw.GetItemString( return_row, "gender_category"))
dw_report.SetItem(report_row, "product_attribute", returns_dw.GetItemString( return_row, "product_attribute"))
dw_report.SetItem(report_row, "ageing", ageing)
dw_report.SetItem(report_row, "content_cost_price", returns_dw.GetItemString( return_row, "content_cost_price"))
//dw_report.SetItem(report_row, "order_type", returns_dw.GetItemString( return_row, "order_type"))

dw_report.SetItem(report_row, "item_dept", returns_dw.GetItemString( return_row, "item_dept"))




Return 0
end function

on w_nycsp_inventory.create
call super::create
end on

on w_nycsp_inventory.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Integer  li_pos

//	dw_report.dataobject = 'd_nycsp_inventory'
//	dw_report.SetTransObject(SQLCA)


//is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql",is_origsql)
//li_pos = pos(is_origsql,"GROUP BY",1)
//is_groupby = mid(is_origsql,li_pos)
//IF li_pos > 0 THEN li_pos=li_pos - 1
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
string ls_OrigSql, ls_select, ls_groupby, ls_project
integer li_new_report_row, li_pos

Long ll_balance, ll_Find
Long i
long ll_cnt, ll_Idx, ll_avail_qty
long ll_find_row, ll_rowline_idx, ll_row, ll_insert_row, ll_component_no
DateTime ldt_s, ldt_e

datastore lds_inventory

string	ls_return_sku[]

If dw_select.AcceptText() = -1 Then Return

dw_report.setredraw(false)

SetPointer(HourGlass!)
dw_report.Reset()

lds_inventory = Create datastore
lds_inventory.dataobject = 'd_nycsp_inventory'
lds_inventory.SetTransObject(SQLCA)
ls_OrigSql = lds_inventory.GetSQLSelect()
//ls_select = ls_OrigSql
li_pos = pos(ls_origsql,"GROUP BY",1)
ls_groupby = mid(ls_origsql,li_pos)
IF li_pos > 0 THEN li_pos=li_pos - 1
ls_select = mid(ls_origsql,1,li_pos)



//Always add project
ls_where += " and cs.project_id = '" + gs_project + "'"


long ll_ageing


//Tackon From Expiration Date
If date(dw_select.GetItemDateTime(1, "expiration_from")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and expiration_date >= '" + string(dw_select.GetItemDateTime(1, "expiration_from"),'mm-dd-yyyy hh:mm') + "'"
	ldt_s = dw_select.GetItemDateTime(1, "expiration_from")
	End If
	
	//Tackon To Expiration Date
If date(dw_select.GetItemDateTime(1, "expiration_to")) > date('01-01-1900') Then
	ls_Where = ls_Where + " and expiration_date <= '" + string(dw_select.GetItemDateTime(1, "expiration_to"),'mm-dd-yyyy hh:mm') + "'"
	ldt_e = dw_select.GetItemDateTime(1, "expiration_to")
End If

//Tackon SKU if present
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
//	ls_where += " and cs.sku like '" + ls_value + "%'"
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
		lds_inventory.Object.t_warehouse.Text = upper(ls_warehouse_name)
	ELSE
		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN													
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			lds_inventory.Object.t_warehouse.Text = upper(ls_warehouse_name)
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
		lds_inventory.Object.t_warehouse.Text = upper(ls_warehouse_name)
		ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
			
	else
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			lds_inventory.Object.t_warehouse.Text = upper(ls_warehouse_name)
			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
		END IF
	END IF
END IF


ls_newsql = ls_select + ls_where + "  " + ls_groupby
//messagebox("ls newsql", ls_newsql)
If ls_Where > '  ' Then
	ls_NewSql = ls_select + ls_Where +"   " + ls_groupby
	lds_inventory.setsqlselect(ls_Newsql)
	
Else
	
	lds_inventory.setsqlselect(ls_select + ls_where + "  " + ls_groupby)
End If
	
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	
ELSE

	ll_cnt = lds_inventory.Retrieve()

	If ll_cnt >= 0 Then
	for ll_row = 1 to ll_cnt
		ll_insert_row = dw_report.insertrow(0)
		ls_project = lds_inventory.getitemString(ll_row,"content_project_id")
		ll_component_no = lds_inventory.getitemNumber(ll_row,"Component_No")
		dw_report.setitem(ll_insert_row,"wh_code",lds_inventory.getitemString(ll_row,"content_WH_Code"))
		dw_report.setitem(ll_insert_row,"project_id",lds_inventory.getitemString(ll_row,"content_project_id"))
		dw_report.setitem(ll_insert_row,"supp_code",lds_inventory.getitemString(ll_row,"content_supp_code"))
		dw_report.setitem(ll_insert_row,"container_id",lds_inventory.getitemString(ll_row,"container_id"))
		dw_report.setitem(ll_insert_row,"sku",lds_inventory.getitemString(ll_row,"content_sku"))
		dw_report.setitem(ll_insert_row,"supp_name",lds_inventory.getitemString(ll_row,"supp_name"))
		dw_report.setitem(ll_insert_row,"l_code",lds_inventory.getitemString(ll_row,"content_l_code"))
		dw_report.setitem(ll_insert_row,"lot_no",lds_inventory.getitemString(ll_row,"lot_no"))
		dw_report.setitem(ll_insert_row,"expiration_date",lds_inventory.getitemDateTime(ll_row,"expiration_date"))
		dw_report.setitem(ll_insert_row,"alt_sku",lds_inventory.getitemString(ll_row,"item_master_alternate_sku"))
		dw_report.setitem(ll_insert_row,"description",lds_inventory.getitemString(ll_row,"item_master_description"))
		dw_report.setitem(ll_insert_row,"UOM_1",lds_inventory.getitemString(ll_row,"item_master_UOM_1"))
		dw_report.setitem(ll_insert_row,"inv_type_desc",lds_inventory.getitemString(ll_row,"inv_type_desc"))
		dw_report.setitem(ll_insert_row,"project_name",lds_inventory.getitemString(ll_row,"project_name"))
		dw_report.setitem(ll_insert_row,"avail_qty",lds_inventory.getitemNumber(ll_row,"avail_qty"))
		dw_report.setitem(ll_insert_row,"component_qty",lds_inventory.getitemNumber(ll_row,"component_qty"))
		dw_report.setitem(ll_insert_row,"Owner_name",lds_inventory.getitemString(ll_row,"cf_Owner_Name"))
		
						
		If ll_component_no > 0 Then
			SELECT SKU  INTO :ls_sku  FROM Content  WHERE ( Project_ID = :ls_project ) AND  (Component_No = :ll_component_no ) AND  ( Avail_Qty > 0 )   ;
			dw_report.setitem(ll_insert_row,"parent_sku",ls_sku)
		End If

		  
	next

		im_menu.m_file.m_print.Enabled = True
		dw_report.SetRedraw(true)
		dw_report.Setfocus()
	
	END IF
	
	IF lds_inventory.RowCount() <= 0  THEN
	
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

type dw_select from w_std_report`dw_select within w_nycsp_inventory
integer x = 0
integer width = 3561
integer height = 188
string dataobject = "d_nycsp_inventory_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name

ib_expire_from_first = TRUE
ib_expire_to_first  = TRUE

//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ib_first_time = true




end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


CHOOSE CASE ls_column
		
	CASE "expiration_from"
		
		IF ib_expire_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("expiration_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_expire_from_first = FALSE
			
		END IF
		
	CASE "expiration_to"
		
		IF ib_expire_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("expiration_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_expire_to_first = FALSE
			
		END IF

	CASE ELSE
		
END CHOOSE
end event

type cb_clear from w_std_report`cb_clear within w_nycsp_inventory
integer x = 3639
integer y = 8
integer width = 96
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_nycsp_inventory
integer x = 5
integer y = 204
integer width = 3561
integer height = 1716
integer taborder = 30
string dataobject = "d_nycsp_inventory_rpt"
boolean hscrollbar = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

