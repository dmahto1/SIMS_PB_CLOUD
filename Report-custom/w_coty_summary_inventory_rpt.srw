HA$PBExportHeader$w_coty_summary_inventory_rpt.srw
$PBExportComments$Window used for displaying summary inventory information
forward
global type w_coty_summary_inventory_rpt from w_std_report
end type
end forward

global type w_coty_summary_inventory_rpt from w_std_report
integer width = 3639
integer height = 2072
string title = "Coty Summary Inventory Report"
end type
global w_coty_summary_inventory_rpt w_coty_summary_inventory_rpt

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

on w_coty_summary_inventory_rpt.create
call super::create
end on

on w_coty_summary_inventory_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/* dts 05/16/06  
	Modeled after w_summary_inventory_rpt (and associated data window)
	For Cody Summary Inv. Rpt, user may select Canada, US or All (in warehouse drop-down)
	Canada, and US choices prints WH name, 'ALL' choice rolls all wh's together
*/

String ls_sku, ls_Where, ls_NewSql, ls_value, ls_warehouse, ls_warehouse_name, lsTemp
string ls_select, ls_GroupBy //dts 05/16/06

long ll_find_row, ll_balance, i, ll_cnt, llStart

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Tack on project id & SKU number
ls_where += " and cs.project_id = '" + gs_project + "'"
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(dw_select.GetItemString(1,"sku")) AND (ls_value > ' ')) THEN
	ls_where += " and cs.sku = '" + dw_select.GetItemString(1,"sku") + "'"
ELSE
//	
end if

// 05/01 PCONKL - Tack on Inventory Type if Present
if  (NOT isnull(dw_select.GetItemString(1,"inv_type")) AND (dw_select.GetItemString(1,"inv_type") > ' ')) THEN
	ls_where += " and cs.inventory_type = '" + dw_select.GetItemString(1,"inv_type") + "'"
end if

// 09/04 PCONKL - Tack on Supplier if Present
if  (NOT isnull(dw_select.GetItemString(1,"supp_code")) AND (dw_select.GetItemString(1,"Supp_code") > ' ')) THEN
	ls_where += " and cs.supp_code = '" + dw_select.GetItemString(1,"supp_code") + "'"
end if

//Process Warehouse
// pvh 09/21/05
is_warehouse_code = dw_select.GetItemString(1,"warehouse")

/* remove/replace the sql that groups by Warehouse (lsTemp and llStart are used only for readability) */
ls_select = is_select
ls_GroupBy = is_GroupBy
//if is_warehouse_code =  'All Rollup'  then 
Choose Case is_warehouse_code 
	case 'All Rollup'
		//set wh_name to 'All'
		lsTemp = "wh_name"
		llStart = pos(ls_select, lsTemp, 1)
		ls_select = replace(ls_select, llStart, len(lsTemp), "wh_name = 'ALL'")
		
		//remove the group by wh_name
		lsTemp = "wh_name,"
		llStart = pos(ls_groupby, lsTemp, 1)
		ls_groupby = replace(ls_groupby, llStart, len(lsTemp), "")
		
	case 'C', 'U'
		//either 'Canada' or 'US' (is_warehouse_code will be either 'C' or 'U')
		ls_Where += " and wh.country like '" + is_warehouse_code + "%'"
		
	case else
		ls_Where += " and wh.wh_code = '" + is_warehouse_code + "'"
end choose
//end if	

ls_NewSql = ls_select + ls_Where +"   " + ls_groupby + '  ' + sqlUtil.getOrderby()
dw_report.setsqlselect(ls_Newsql)

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

dw_select.GetChild('warehouse', ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
End If



//dts 05/16/06 - for COTY report, add Canada, US and All.  
//For Canada and US choices, we'll add " and wh.country like 'C%' or 'U%' " to where clause
long insertrow
insertrow = ldwc_warehouse.insertrow(0)
ldwc_warehouse.setitem( insertrow , 'warehouse_wh_name', '- All (Roll Up) -' )
ldwc_warehouse.setitem( insertrow , 'wh_code', 'All Rollup' )

insertrow = ldwc_warehouse.insertrow(0)
ldwc_warehouse.setitem( insertrow , 'warehouse_wh_name', '- Canada -' )
ldwc_warehouse.setitem( insertrow , 'wh_code', 'C' )

insertrow = ldwc_warehouse.insertrow(0)
ldwc_warehouse.setitem( insertrow , 'warehouse_wh_name', '- US -' )
ldwc_warehouse.setitem( insertrow , 'wh_code', 'U' )

ldwc_warehouse.setsort( 'warehouse_wh_name A' )
ldwc_warehouse.sort()

dw_select.SetItem(1, "warehouse" , 'All Rollup')

end event

type dw_select from w_std_report`dw_select within w_coty_summary_inventory_rpt
integer x = 23
integer y = 24
integer width = 3534
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

type cb_clear from w_std_report`cb_clear within w_coty_summary_inventory_rpt
integer x = 3104
integer y = 12
end type

type dw_report from w_std_report`dw_report within w_coty_summary_inventory_rpt
integer x = 23
integer y = 212
integer width = 3543
integer height = 1560
string dataobject = "d_coty_summary_inventory_rpt"
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

