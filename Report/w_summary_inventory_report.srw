HA$PBExportHeader$w_summary_inventory_report.srw
$PBExportComments$Window used for displaying summary inventory information
forward
global type w_summary_inventory_report from w_std_report
end type
end forward

global type w_summary_inventory_report from w_std_report
integer width = 3639
integer height = 2072
string title = "Summary Inventory Report"
end type
global w_summary_inventory_report w_summary_inventory_report

type variables
string isorigsql
string is_groupby
string is_select
string       is_warehouse_code
string       is_warehouse_name
boolean   ib_first_time
datastore ids_find_warehouse

// pvh 09/22/05
u_sqlutil SqlUtil

string isOrderBy

end variables

forward prototypes
public subroutine setorderby (string asorderby)
public subroutine doparsesql (string assql)
public function string getorderby ()
end prototypes

public subroutine setorderby (string asorderby);// setOrderBy( string asOrderBy )
isOrderBy = asOrderBy


end subroutine

public subroutine doparsesql (string assql);// doParseSQL( string asSQL )

end subroutine

public function string getorderby ();// string = getOrderby()
return isOrderBy

end function

on w_summary_inventory_report.create
call super::create
end on

on w_summary_inventory_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_sku
String ls_Where
String ls_NewSql
String ls_value
string ls_warehouse
string ls_warehouse_name
string lsTemp

long ll_find_row
Long ll_balance
Long i
long ll_cnt
long llStart

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Tack on project id & SKU number
ls_where += " and cs.project_id = '" + gs_project + "'"
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(dw_select.GetItemString(1,"sku")) AND (ls_value > ' ')) THEN
	ls_where += " and cs.sku = '" + dw_select.GetItemString(1,"sku") + "'"

ELSE
	
end if

// 05/01 PCONKL - Tack on Inventory Type if Present
if  (NOT isnull(dw_select.GetItemString(1,"inv_type")) AND (dw_select.GetItemString(1,"inv_type") > ' ')) THEN
	ls_where += " and cs.inventory_type = '" + dw_select.GetItemString(1,"inv_type") + "'"
end if

// 09/04 PCONKL - Tack on Supplier if Present
if  (NOT isnull(dw_select.GetItemString(1,"supp_code")) AND (dw_select.GetItemString(1,"Supp_code") > ' ')) THEN
	ls_where += " and cs.supp_code = '" + dw_select.GetItemString(1,"supp_code") + "'"
end if

//Process Warehouse Number
// pvh 09/21/05
is_warehouse_code = dw_select.GetItemString(1,"warehouse")
//dts - 12/07/05 if is_warehouse_code <>  'All'  then 
//  Now have 'All' and 'All Rollup' (which rolls all WH's together)
if left(is_warehouse_code, 3) <>  'All'  then 
	IF ib_first_time  = TRUE THEN
		is_warehouse_code = dw_select.GetItemString(1,"warehouse")
		  
		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																	1,ids_find_warehouse.RowCount())
		IF ll_find_row > 0 THEN
			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
			//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
		ELSE
			ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
																	1,ids_find_warehouse.RowCount())
			IF ll_find_row > 0 THEN													
				is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
				ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
				ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
				//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
				
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
			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
			//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
			
				
		else
			ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
																	1,ids_find_warehouse.RowCount())
			IF ll_find_row > 0 THEN
				is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
				ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
				ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
				//dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
				
			END IF
		END IF
	END IF
end if

/*dts - 12/07/05
  - remove/replace the sql that groups by Warehouse (lsTemp and llStart are used only for readability) */
if is_warehouse_code =  'All Rollup'  then 
	//set wh_code to 'All'
	lsTemp = "cs.WH_Code"
	llStart = pos(is_select, lsTemp, 1)
	is_select = replace(is_select, llStart, len(lsTemp), "wh_code = 'ALL'")
	//set warehouseName to 'All' (instead of looking it up)
	lsTemp = "warehouseName = ( select w.wh_name from warehouse w where w.wh_code = cs.wh_code)"
	llStart = pos(is_select, lsTemp, 1)
	is_select = replace(is_select, llStart, len(lsTemp), "warehouseName = 'ALL'")
	//remove the group by wh_code
	lsTemp = "cs.wh_code,"
	llStart = pos(is_groupby, lsTemp, 1)
	is_groupby = replace(is_groupby, llStart, len(lsTemp), "")	
end if	

// pvh - 09/22/05

ls_NewSql = is_select + ls_Where +"   " + is_groupby + '  ' + sqlUtil.getOrderby()

If ls_Where > '  ' Then
	ls_NewSql = is_select + ls_Where +"   " + is_groupby + '  ' +  sqlUtil.getOrderby()
	dw_report.setsqlselect(ls_Newsql)
Else
	dw_report.setsqlselect(is_select + ls_where + "  " + is_groupby + '  ' + sqlUtil.getOrderby() )
End If

IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE
	ll_cnt = dw_report.Retrieve()
	If ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
	is_warehouse_code = " "
END IF



end event

event open;call super::open;Integer  li_pos


//BCR 11-OCT-2011: Call custom dw for Comcast...
IF Upper(gs_project) = 'COMCAST' THEN
	dw_report.dataobject = "d_comcast_summary_inventory_rpt"
	dw_report.SetTransObject(SQLCA)
END IF
//End

isOrigSql = dw_report.getsqlselect()

// pvh 09/22/05
SqlUtil = create u_sqlutil
SqlUtil.setOriginalSQL( dw_report.getsqlselect() )
SqlUtil.doParseSql()

is_groupby = sqlutil.getGroupby()

is_select = sqlutil.getSelect() + sqlutil.getFrom() + sqlutil.getWhere()

// 12/00 PCONKL - Dont harcode starting position of Group BY!
//li_pos = pos(isorigsql,"GROUP BY",1)
//is_groupby = mid(isorigsql,li_Pos)
//is_select = mid(isorigsql,1,(li_Pos - 1))




end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event resize;dw_report.Resize(workspacewidth() -30,workspaceHeight()-200)
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

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()
//	
//	dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
//	// pvh 09/21/05
//	long insertrow
//	insertrow = ldwc_warehouse.insertrow(0)
//	ldwc_warehouse.setitem( insertrow , 'warehouse_wh_name', '- All, by Warehouse -' )
//	ldwc_warehouse.setitem( insertrow , 'wh_code', 'All' )
//
//	//dts 12/07/05
//	insertrow = ldwc_warehouse.insertrow(0)
//	ldwc_warehouse.setitem( insertrow , 'warehouse_wh_name', '- All, Roll Up Warehouses -' )
//	ldwc_warehouse.setitem( insertrow , 'wh_code', 'All Rollup' )
//
//	ldwc_warehouse.setsort( 'warehouse_wh_name A' )
//	ldwc_warehouse.sort()
//	
//End If

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if

long insertrow
insertrow = ldwc_warehouse.insertrow(0)
ldwc_warehouse.setitem( insertrow , 'wh_name', '- All, by Warehouse -' )
ldwc_warehouse.setitem( insertrow , 'wh_code', 'All' )

//dts 12/07/05
insertrow = ldwc_warehouse.insertrow(0)
ldwc_warehouse.setitem( insertrow , 'wh_name', '- All, Roll Up Warehouses -' )
ldwc_warehouse.setitem( insertrow , 'wh_code', 'All Rollup' )

ldwc_warehouse.setsort( 'wh_name A' )
ldwc_warehouse.sort()

end event

type dw_select from w_std_report`dw_select within w_summary_inventory_report
integer x = 23
integer y = 24
integer width = 3538
integer height = 188
string dataobject = "d_sku"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
long		ll_row
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

type cb_clear from w_std_report`cb_clear within w_summary_inventory_report
integer x = 3104
integer y = 12
end type

type dw_report from w_std_report`dw_report within w_summary_inventory_report
integer x = 23
integer y = 208
integer width = 3543
integer height = 1560
string dataobject = "d_summary_inventory_rpt"
boolean hscrollbar = true
end type

event dw_report::constructor;This.SetTransObject(SQLCA)
This.insertrow(0)
//This.Retrieve()
end event

event dw_report::retrieveend;call super::retrieveend;//Commented by DGM 06/24/2005 as per Bob has asked me to remove the entire column deom DW Object
//// 03/03 - PCONKL - Compute Total QTY (not using a computed field so it can be exported)
//
//Long	llRowCount,	&
//		llRowPos
//		
//
//llRowCount = This.RowCount()
//
//This.SetRedraw(False)
//
//For llRowPos = 1 to llRowCount
//	
////	This.SetItem(llRowPos,'c_total',((This.GetITemNumber(llRowPos,'avail_qty') + This.GetITemNumber(llRowPos,'sit_qty') + &
////					This.GetITemNumber(llRowPos,'wip_qty')) - This.GetITemNumber(llRowPos,'alloc_qty')))
//	
//next
//
//This.SetRedraw(True)
end event

