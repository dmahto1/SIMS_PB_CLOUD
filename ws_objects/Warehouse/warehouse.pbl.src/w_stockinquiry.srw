$PBExportHeader$w_stockinquiry.srw
$PBExportComments$- stock inquiry
forward
global type w_stockinquiry from w_std_master_detail
end type
type uo_commodity_code from uo_multi_select_search within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type dw_select from u_dw_ancestor within tabpage_main
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type dw_query from u_dw_ancestor within tabpage_search
end type
type tabpage_avail_inventory from userobject within tab_main
end type
type uo_commodity from uo_multi_select_search within tabpage_avail_inventory
end type
type dw_avail_inv from u_dw_ancestor within tabpage_avail_inventory
end type
type dw_avail_inv_search from u_dw_ancestor within tabpage_avail_inventory
end type
type tabpage_avail_inventory from userobject within tab_main
uo_commodity uo_commodity
dw_avail_inv dw_avail_inv
dw_avail_inv_search dw_avail_inv_search
end type
type tabpage_serialinventory from userobject within tab_main
end type
type dw_search_serialinventory from u_dw_ancestor within tabpage_serialinventory
end type
type dw_serialinventory from u_dw_ancestor within tabpage_serialinventory
end type
type tabpage_serialinventory from userobject within tab_main
dw_search_serialinventory dw_search_serialinventory
dw_serialinventory dw_serialinventory
end type
type tabpage_r_detail from userobject within tab_main
end type
type dw_receive_detail from u_dw_ancestor within tabpage_r_detail
end type
type dw_select_receive from u_dw_ancestor within tabpage_r_detail
end type
type tabpage_r_detail from userobject within tab_main
dw_receive_detail dw_receive_detail
dw_select_receive dw_select_receive
end type
type tabpage_d_detail from userobject within tab_main
end type
type dw_d_detail from u_dw_ancestor within tabpage_d_detail
end type
type dw_select_delivery from u_dw_ancestor within tabpage_d_detail
end type
type tabpage_d_detail from userobject within tab_main
dw_d_detail dw_d_detail
dw_select_delivery dw_select_delivery
end type
type tabpage_t_detail from userobject within tab_main
end type
type dw_t_detail from u_dw_ancestor within tabpage_t_detail
end type
type dw_select_transfer from datawindow within tabpage_t_detail
end type
type tabpage_t_detail from userobject within tab_main
dw_t_detail dw_t_detail
dw_select_transfer dw_select_transfer
end type
type tabpage_pick from userobject within tab_main
end type
type dw_pick_detail from u_dw_ancestor within tabpage_pick
end type
type dw_select_pick from datawindow within tabpage_pick
end type
type tabpage_pick from userobject within tab_main
dw_pick_detail dw_pick_detail
dw_select_pick dw_select_pick
end type
type tabpage_pack from userobject within tab_main
end type
type dw_select_pack from datawindow within tabpage_pack
end type
type dw_pack_detail from u_dw_ancestor within tabpage_pack
end type
type tabpage_pack from userobject within tab_main
dw_select_pack dw_select_pack
dw_pack_detail dw_pack_detail
end type
type tabpage_adjustment from userobject within tab_main
end type
type dw_select_adjust from datawindow within tabpage_adjustment
end type
type dw_adjust from u_dw_ancestor within tabpage_adjustment
end type
type tabpage_adjustment from userobject within tab_main
dw_select_adjust dw_select_adjust
dw_adjust dw_adjust
end type
type tabpage_kits from userobject within tab_main
end type
type dw_si_kits from datawindow within tabpage_kits
end type
type dw_kits from datawindow within tabpage_kits
end type
type tabpage_kits from userobject within tab_main
dw_si_kits dw_si_kits
dw_kits dw_kits
end type
end forward

global type w_stockinquiry from w_std_master_detail
integer width = 4425
integer height = 2268
string title = "Stock Inquiry"
end type
global w_stockinquiry w_stockinquiry

type variables
Datawindow   idw_main, idw_search,idw_query, idw_avail_inv, idw_avail_inv_search
Datawindow idw_receive_search, idw_delivery_search
Datawindow idw_receive,idw_delivery,idw_transfer
Datawindow idw_select,idwCurrent,idw_Pick,idw_pack, idw_adjust, idw_search_SerialInventory, idw_SerialInventory,idw_kits
//TimA 07/05/12 Pandora issue #360 add Owner to the search
Datawindowchild	idw_Avail_child_owner, idw_All_child_owner
Datawindowchild	idw_Receive_child_owner, idw_Delivery_child_owner
string is_sku

String  is_org_sql,isOrigsql_main,isorigsql_receive,isorigsql_delivery,isorigsql_transfer,isorigsql_adjust,isorigsql_loc
String isWarehouse
Protected String isSku
integer ii_height
String  isorigsql_pick,isOrigsql_pack,isOrigSql_bol, isorigSql_avail_inv, isorigSql_SerialInventory,isorigsql_kits
w_stockinquiry iw_window
boolean ib_rcv_complete_from_first
boolean ib_rcv_complete_to_first
boolean ib_rcv_order_from_first
boolean ib_rcv_order_to_first
boolean ib_trn_order_from_first 	
boolean ib_trn_order_to_first 	
boolean ib_rcv_sched_from_first
boolean ib_rcv_sched_to_first
boolean ib_dlv_complete_from_first
boolean ib_dlv_complete_to_first
boolean ib_dlv_order_from_first
boolean ib_dlv_order_to_first
boolean ib_dlv_sched_from_first
boolean ib_dlv_sched_to_first
boolean ib_pick_order_from_first
boolean ib_pick_order_to_first
boolean ib_pack_order_from_first
boolean ib_pack_order_to_first
boolean ib_adj_order_from_first
boolean ib_adj_order_to_first

n_warehouse i_nwarehouse

Boolean ib_show_commodity_list =false //07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 

end variables

forward prototypes
public subroutine wf_get_name (datawindow adw)
public subroutine wf_owner_ind (datawindow adw)
public function string wf_status_new (ref datawindow adw_select_receive)
public subroutine wf_update_owner_select (datawindowchild as_dw_child)
protected function boolean f_setwarehousesku (long al_tabpagenum)
public subroutine wf_show_hide_data (long al_tabpagenum)
public subroutine wf_multi_select_commodity_code ()
end prototypes

public subroutine wf_get_name (datawindow adw);Integer i
long ll_owner
IF adw.rowcount() > 0  and Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to adw.rowcount()
		ll_owner=adw.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			adw.object.cf_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
	Next
END IF	
end subroutine

public subroutine wf_owner_ind (datawindow adw);//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	adw.object.cf_owner_name.visible = 0
	adw.object.cf_name_t.visible = 0
End IF

end subroutine

public function string wf_status_new (ref datawindow adw_select_receive);// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere,ls_Select
Integer	liRC
Date		ldToDate



adw_select_receive.AcceptTExt()
//01/05/15 TimA found a bug  adding  field for  country_of_origin after Owner_type.
//This would generate a dabase error because the union number of fields did not match the datawindow select. 
//When choosing "New" as the order status.

ls_Select = "union all "
ls_Select += "SELECT   RD.RO_No, "   
ls_Select +="'-','-','-','-',RD.Req_Qty,RM.WH_Code,RM.Arrival_Date, "   
ls_Select +="RM.Ord_Status,RM.Supp_Invoice_No,RD.SKU,RM.Ord_Date,'-', "   
ls_Select +="RD.Supp_Code, RD.Owner_ID,'-','-', '12/31/2999', Owner.Owner_Cd,Owner.Owner_Type ,'-' "  // * 01/03 - Pconkl - add Container ID and Exp Date*/
ls_Select +="    FROM Receive_Detail RD, Receive_Master RM,Owner "
lsWhere+= "WHERE ( RM.RO_No = RD.RO_No ) and " 
lsWhere+="( Owner.Owner_ID = RD.Owner_ID )  and "
lsWhere+="( RM.RO_No = RD.RO_No ) " 
//always tackon Project...
lsWhere  += " and RM.Project_id = '" + gs_project + "'"

//Tackon BOL Nbr
if  not isnull(adw_select_receive.GetItemString(1,"bol")) then
	lswhere += " and RM.Supp_Invoice_No = '" + adw_select_receive.GetItemString(1,"bol") + "'"
end if

//Tackon Order Status
if  not isnull(adw_select_receive.GetItemString(1,"status")) then
	lswhere += " and RM.ord_status = '" + adw_select_receive.GetItemString(1,"status") + "'"
end if

//tackon SKU
if  not isnull(adw_select_receive.GetItemString(1,"sku")) then
	lswhere += " and RD.SKU like '" + adw_select_receive.GetItemString(1,"sku") + "%'  "
end if

//tackon Warehouse
if  not isnull(adw_select_receive.GetItemString(1,"warehouse")) then
	lswhere += " and RM.WH_Code = '" + adw_select_receive.GetItemString(1,"warehouse") + "'  "
end if

////tackon From location
//if  not isnull(adw_select_receive.GetItemString(1,"from_loc")) then
//	lswhere += " and l_code >= '" + adw_select_receive.GetItemString(1,"from_loc") + "'  "
//end if

////tackon To location
//if  not isnull(adw_select_receive.GetItemString(1,"to_loc")) then
//	lswhere += " and l_code <= '" + adw_select_receive.GetItemString(1,"to_loc") + "'  "
//end if

//Tackon From Receive Date
If Date(adw_select_receive.GetItemDateTime(1,"from_date")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and RM.Arrival_Date >= '" + string(adw_select_receive.GetItemDateTime(1,"from_date"),'mm/dd/yyyy hh:mm') + "'"
		
End If

//Tackon To Receive Date
If Date(adw_select_receive.GetItemDateTime(1,"to_date")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and RM.Arrival_Date <= '" + string(adw_select_receive.GetItemDateTime(1,"to_date"),'mm/dd/yyyy hh:mm') + "'"
			
End If
	
//Tackon From Order Date
If Date(adw_select_receive.GetItemDateTime(1,"order_date_from")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and RM.ord_Date >= '" + string(adw_select_receive.GetItemDateTime(1,"order_date_from"),'mm/dd/yyyy hh:mm') + "'"
			
End If

//Tackon To Order Date
If Date(adw_select_receive.GetItemDateTime(1,"order_date_to")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and RM.Ord_Date <= '" + string(adw_select_receive.GetItemDateTime(1,"order_date_to"),'mm/dd/yyyy hh:mm') + "'"
			
End If
return ls_select + lsWhere


end function

public subroutine wf_update_owner_select (datawindowchild as_dw_child);String ls_sql, ls_order, ls_where
String ls_WH
//TimA 07/06/12 Pandora #360 Add owner Code to the search
If Upper(gs_project) = 'PANDORA' then

	ls_sql =  "SELECT Customer.Project_ID,  Customer.Cust_Code,  Customer.Cust_Name  FROM Customer Where PROJECT_ID = '"+ Upper(gs_Project) + "' " + " AND Customer.Customer_Type = 'WH' "
	ls_order =  " ORDER BY Customer.Project_ID ASC,  Customer.Cust_Code ASC "  
	
	If isWarehouse <> '' Then	
		ls_where = "  and user_field2 = '" + isWarehouse + "'" 
	End if

	If ls_where <> '' Then
		ls_sql = ls_sql + ls_where
	End if
	ls_sql = ls_sql + ls_order

	as_dw_child.SetTransObject(SQLCA)
	as_dw_child.SetSqlSelect(ls_sql)
	as_dw_child.Retrieve()
	
End if
end subroutine

protected function boolean f_setwarehousesku (long al_tabpagenum);datawindow ldw1, ldw2

// KRZ What tab page has been selected?
Choose Case al_tabpagenum
		
	Case 1
		ldw1 = tab_main.tabpage_main.dw_select
		ldw2 = tab_main.tabpage_main.dw_main

	Case 2
		ldw1 = tab_main.tabpage_avail_inventory.dw_avail_inv_search
		ldw2 = tab_main.tabpage_avail_inventory.dw_avail_inv
		
	//Jxlim 09/24/2013 Ariens Serial Inventory tab (New tab insert in between Avail_inv tab and Receive tab)
	Case 3
		ldw1 = tab_main.tabpage_SerialInventory.dw_search_SerialInventory
		ldw2 = tab_main.tabpage_SerialInventory.dw_SerialInventory
		
	Case 4
		ldw1 = tab_main.tabpage_r_detail.dw_select_receive
		ldw2 = tab_main.tabpage_r_detail.dw_receive_detail

	Case 5
		ldw1 = tab_main.tabpage_d_detail.dw_select_delivery
		ldw2 = tab_main.tabpage_d_detail.dw_d_detail

	Case 6
		ldw1 = tab_main.tabpage_t_detail.dw_select_transfer
		ldw2 = tab_main.tabpage_t_detail.dw_t_detail
		
	Case 7
		ldw1 = tab_main.tabpage_pick.dw_select_pick
		ldw2 = tab_main.tabpage_pick.dw_pick_detail

	Case 8	
		ldw1 = tab_main.tabpage_pack.dw_select_pack
		ldw2 = tab_main.tabpage_pack.dw_pack_detail

	Case 9
		ldw1 = tab_main.tabpage_adjustment.dw_select_adjust
		ldw2 = tab_main.tabpage_adjustment.dw_adjust
		
	Case 11
		ldw1 = tab_main.tabpage_search.dw_query
		ldw2 = tab_main.tabpage_search.dw_search	

	// Begin - 28/03/2022- Dinesh - New tab Kits
	Case 10
		ldw1 = tab_main.tabpage_kits.dw_kits
		ldw2 = tab_main.tabpage_kits.dw_si_kits
	// End -  28/03/2022- Dinesh - New tab Kits
End Choose

// If the datawindow does not already have data,
If ldw2.rowcount() = 0 then
	
	// Set the warehouse and sku for the selected dw.
	ldw1.setitem(1, "warehouse", isWarehouse)
	ldw1.setitem(1, "sku", isSku)
End If

// Return true
return true
end function

public subroutine wf_show_hide_data (long al_tabpagenum);//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 

CHOOSE CASE al_tabpagenum

CASE 1 //All Inventory
		If ib_show_commodity_list Then
			tab_main.tabpage_main.uo_commodity_code.bringtotop = False
			ib_show_commodity_list = False
		Else
			tab_main.tabpage_main.uo_commodity_code.bringtotop = True
			ib_show_commodity_list = True
		End If

CASE 2 //Avail Inventory
		If ib_show_commodity_list Then
			tab_main.tabpage_avail_inventory.uo_commodity.bringtotop=False
			ib_show_commodity_list = False
		Else
			tab_main.tabpage_avail_inventory.uo_commodity.bringtotop=True
			ib_show_commodity_list = True
		End If

END CHOOSE
end subroutine

public subroutine wf_multi_select_commodity_code ();//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 

String lsSql, lserror
long ll_row

Datastore lds_commodity

//Remove filter
tab_main.tabpage_main.uo_commodity_code.dw_search.setfilter( "")
tab_main.tabpage_main.uo_commodity_code.dw_search.filter()

tab_main.tabpage_avail_inventory.uo_commodity.dw_search.setfilter("")
tab_main.tabpage_avail_inventory.uo_commodity.dw_search.filter()

//set All Inventory
idw_select.modify("commodity_cd_t.visible =true")
idw_select.modify("commodity_cd.visible =true")

tab_main.tabpage_main.uo_commodity_code.visible =true
tab_main.tabpage_main.uo_commodity_code.width =800
tab_main.tabpage_main.uo_commodity_code.dw_search.width =800
tab_main.tabpage_main.uo_commodity_code.height = 570
tab_main.tabpage_main.uo_commodity_code.dw_search.height = 565
tab_main.tabpage_main.uo_commodity_code.bringtotop = false
tab_main.tabpage_main.uo_commodity_code.uf_init("d_item_commodity_search_list","Item_Master.User_Field5","commodity_cd")

//create datastore
lds_commodity =create Datastore
lsSql = " select distinct User_Field5 From Item_Master with(nolock) "
lsSql += " Where Project_Id ='"+gs_project+"'"
lsSql += " Order by Item_Master.User_Field5 ASC"

lds_commodity.create( SQLCA.syntaxfromsql( lsSql, "", lserror))

If len(lserror) > 0 then
	MessageBox("Error", lserror)
else
	lds_commodity.settransobject( sqlca)
	lds_commodity.retrieve( )
End If

//Assign IM.UF5 to datastore
For ll_row =1 to lds_commodity.rowcount( )
	tab_main.tabpage_main.uo_commodity_code.dw_search.insertrow( 0)
	tab_main.tabpage_main.uo_commodity_code.dw_search.setitem( ll_row, 'commodity_cd', trim(lds_commodity.getitemstring(ll_row,'User_Field5')))
	tab_main.tabpage_main.uo_commodity_code.dw_search.setitem( ll_row, 'selected', 0)
Next

//idw_select.setItem(1,"commodity_cd", "<Select Multiple>")
idw_select.setItem(1,"commodity_cd", "")
idw_select.Modify("commodity_cd.dddw.Limit=0")
idw_select.Modify("commodity_cd.dddw.Name='None'")
idw_select.Modify("commodity_cd.dddw.PercentWidth=0")
idw_select.Modify("commodity_cd.dddw.HScrollBar=Yes")


//set Avail Inventory
idw_avail_inv_search.modify("commodity_cd_t.visible =true")
idw_avail_inv_search.modify("commodity_cd.visible =true")

tab_main.tabpage_avail_inventory.uo_commodity.visible =true
tab_main.tabpage_avail_inventory.uo_commodity.width =800
tab_main.tabpage_avail_inventory.uo_commodity.dw_search.width =800
tab_main.tabpage_avail_inventory.uo_commodity.height = 570
tab_main.tabpage_avail_inventory.uo_commodity.dw_search.height = 565
tab_main.tabpage_avail_inventory.uo_commodity.bringtotop = false
tab_main.tabpage_avail_inventory.uo_commodity.uf_init("d_item_commodity_search_list","Item_Master.User_Field5","commodity_cd")

//idw_avail_inv_search.setItem(1,"commodity_cd", "<Select Multiple>")
idw_avail_inv_search.Modify("commodity_cd.dddw.Limit=0")
idw_avail_inv_search.Modify("commodity_cd.dddw.Name='None'")
idw_avail_inv_search.Modify("commodity_cd.dddw.PercentWidth=0")
idw_avail_inv_search.Modify("commodity_cd.dddw.HScrollBar=Yes")


tab_main.tabpage_main.uo_commodity_code.dw_search.sharedata( tab_main.tabpage_avail_inventory.uo_commodity.dw_search) //share data

destroy lds_commodity
end subroutine

on w_stockinquiry.create
int iCurrent
call super::create
end on

on w_stockinquiry.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;// 05/00 PCONKL - each DW will be retrieved and processed independantly

idwCurrent.TriggerEvent("ue_retrieve")



end event

event ue_print;IF idwcurrent.Rowcount() > 0 THEN
	Openwithparm(w_dw_print_options,idwcurrent) 
ELSE
	MessageBox(is_title,"Nothing to Print")
END IF	
end event

event ue_edit;// Acess Rights
If f_check_access(is_process,"E") = 0 Then
	close(w_stockinquiry)
	return
end if

end event

event ue_postopen;call super::ue_postopen;// 05/00 PCONKL - moved from open event
datawindowchild	ldwc, ldwc2, ldwcgrp, ldwcgrp2, ldwc3, ldw_owner,ldw_commodity

String	lsFilter,ls_data,ls_con
String ls_sql,ls_where, ls_order, lsChain

ib_changed = False
ib_edit = True
tab_main.MoveTab(2, 99) /*move search to end*/

iw_window = This

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_avail_inv = tab_main.tabpage_avail_inventory.dw_avail_inv
idw_receive = tab_main.tabpage_r_detail.dw_receive_detail
idw_delivery = tab_main.tabpage_d_detail.dw_d_detail
idw_transfer = tab_main.tabpage_t_detail.dw_t_detail
idw_pick = tab_main.tabpage_pick.dw_pick_detail
idw_pack = tab_main.tabpage_pack.dw_pack_detail
idw_adjust = tab_main.tabpage_adjustment.dw_adjust
idw_select = tab_main.tabpage_main.dw_select
idw_query = tab_main.tabpage_search.dw_query
idw_search = tab_main.tabpage_search.dw_search
idw_avail_inv_search = tab_main.tabpage_avail_inventory.dw_avail_inv_search
idw_kits = tab_main.tabpage_kits.dw_si_kits //Dinesh - 03/28/2022- kits

//Jxlim 09/24/2013 Ariens CR-26 Serial Number Scanning
idw_search_SerialInventory =  tab_main.tabpage_SerialInventory.dw_search_SerialInventory
idw_SerialInventory =  tab_main.tabpage_SerialInventory.dw_SerialInventory

//TimA 09/10/15 Fixed a bug found in the dddw of loc from and loc To
idw_receive_search = tab_main.tabpage_r_detail.dw_select_receive
idw_delivery_search = tab_main.tabpage_d_detail.dw_select_delivery	

g.of_setwarehouse(TRUE)
idw_query.insertrow(0)

//idw_select.insertrow(0)

// 08/07- PCONKL - Loading from USer Warehouse Datastore 
idw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
g.of_set_warehouse_dropdown(ldwc)

//Jxlim 09/24/2013 Ariens; CR-26 Serial NUmber Scanning, should only be visible if Project level chain of custody flag is turned on
IF g.ibSNchainofcustody THEN
 	tab_main.tabpage_SerialInventory.visible = True
Else
	 tab_main.tabpage_SerialInventory.visible = False	
End IF

// Begin....12/05/2024..Akash Baghel.SIMS-588... Development for Google – SIMS- Bulk Locations Utilization

If Upper(gs_project) = 'PANDORA' then
   idw_main.modify("user_field2.visible = True")
  else
   idw_main.modify("user_field2.visible = False")
end if	 
// End....12/05/2024..Akash Baghel.SIMS-588... Development for Google – SIMS- Bulk Locations Utilization


//Begin -04192022- Dinesh - SIMS PIP/SIP - Work Order Refactoring - Stock Inquiry: New tab to Show KIT and associated Components
If Upper(gs_project) = 'NYCSP'  or Upper(gs_project) = 'GEISTLICH'  then

		tab_main.tabpage_kits.visible = False
		else 
		tab_main.tabpage_kits.visible = False
end if
	//End -04192022- Dinesh - SIMS PIP/SIP - Work Order Refactoring - Stock Inquiry: New tab to Show KIT and associated 
	//Begin -09292022- Dinesh -SIMS-81- Geistlich Serialization - Updates (Part II)
If Upper(gs_project) = 'PANDORA'  then
		idw_select.modify("t_2.visible =false")
		idw_select.modify("serial_no.visible =false")
		idw_avail_inv_search.modify("t_2.visible =false")
		idw_avail_inv_search.modify("serial_no.visible =false")
end if
//End -09292022- Dinesh -SIMS-81- Geistlich Serialization - Updates (Part II)


//TimA 07/03/12 Pandora issue #360 Add Owner Search
If Upper(gs_project) = 'PANDORA' then
//	idw_receive_search = tab_main.tabpage_r_detail.dw_select_receive
//	idw_delivery_search = tab_main.tabpage_d_detail.dw_select_delivery	

	idw_avail_inv_search.Modify("owner_code.dddw.Case='Any'")
	idw_avail_inv_search.Modify("owner_code.dddw.useasborder=Yes")
	idw_avail_inv_search.Modify("owner_code.dddw.DataColumn='cust_code'")
	idw_avail_inv_search.Modify("owner_code.dddw.DisplayColumn='cust_code'")
	idw_avail_inv_search.Modify("owner_code.dddw.Limit=30")
	idw_avail_inv_search.Modify("owner_code.dddw.Name='dddw_customer'")
	idw_avail_inv_search.Modify("owner_code.dddw.PercentWidth=400")
	idw_avail_inv_search.Modify("owner_code.dddw.VScrollBar=Yes")
	idw_avail_inv_search.Modify("owner_code.dddw.HScrollBar=Yes")
	
	idw_select.Modify("owner_code.dddw.Case='Any'")
	idw_select.Modify("owner_code.dddw.useasborder=Yes")
	idw_select.Modify("owner_code.dddw.DataColumn='cust_code'")
	idw_select.Modify("owner_code.dddw.DisplayColumn='cust_code'")
	idw_select.Modify("owner_code.dddw.Limit=30")
	idw_select.Modify("owner_code.dddw.Name='dddw_customer'")
	idw_select.Modify("owner_code.dddw.PercentWidth=400")
	idw_select.Modify("owner_code.dddw.VScrollBar=Yes")
	idw_select.Modify("owner_code.dddw.HScrollBar=Yes")

	idw_receive_search.Modify("owner_code.dddw.Case='Any'")
	idw_receive_search.Modify("owner_code.dddw.useasborder=Yes")
	idw_receive_search.Modify("owner_code.dddw.DataColumn='cust_code'")
	idw_receive_search.Modify("owner_code.dddw.DisplayColumn='cust_code'")
	idw_receive_search.Modify("owner_code.dddw.Limit=30")
	idw_receive_search.Modify("owner_code.dddw.Name='dddw_customer'")
	idw_receive_search.Modify("owner_code.dddw.PercentWidth=400")
	idw_receive_search.Modify("owner_code.dddw.VScrollBar=Yes")
	idw_receive_search.Modify("owner_code.dddw.HScrollBar=Yes")

	idw_delivery_search.Modify("owner_code.dddw.Case='Any'")
	idw_delivery_search.Modify("owner_code.dddw.useasborder=Yes")
	idw_delivery_search.Modify("owner_code.dddw.DataColumn='cust_code'")
	idw_delivery_search.Modify("owner_code.dddw.DisplayColumn='cust_code'")
	idw_delivery_search.Modify("owner_code.dddw.Limit=30")
	idw_delivery_search.Modify("owner_code.dddw.Name='dddw_customer'")
	idw_delivery_search.Modify("owner_code.dddw.PercentWidth=400")
	idw_delivery_search.Modify("owner_code.dddw.VScrollBar=Yes")
	idw_delivery_search.Modify("owner_code.dddw.HScrollBar=Yes")
	
	idw_avail_inv_search.GetChild("owner_code", idw_Avail_child_owner)	
	idw_select.GetChild("owner_code", idw_All_child_owner)	
	//TimA 07/16/12 Pandora issue #360 Part II add receive and delivery

	idw_receive_search.GetChild("owner_code", idw_Receive_child_owner)	
	idw_delivery_search.GetChild("owner_code", idw_Delivery_child_owner)		
	
	wf_update_owner_select(idw_Avail_child_owner)
	wf_update_owner_select(idw_All_child_owner)
	//TimA 07/16/12 Pandora issue #360 Part II add receive and delivery	
	wf_update_owner_select(idw_Receive_child_owner)
	wf_update_owner_select(idw_Delivery_child_owner)
End if

////populate dropdowns - not done automatically since dw not being retrieved
//idw_select.GetChild('warehouse', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve()
//
////Filter warehouse by current project
//lsFilter = "project_id = '" + gs_project + "'"
//ldwc.SetFilter(lsFilter)
//ldwc.Filter()

//Share with Warehouse on other tabs
tab_main.tabpage_avail_inventory.dw_avail_inv_search.GetChild("warehouse",ldwc2)
ldwc.Sharedata(ldwc2) /*Avail Inventory Search*/
tab_main.tabpage_r_detail.dw_select_receive.GetChild("warehouse",ldwc2)
ldwc.Sharedata(ldwc2) /*receiving Search*/
tab_main.tabpage_d_detail.dw_select_delivery.GetChild('warehouse', ldwc2)
ldwc.Sharedata(ldwc2) /*Delivery Search*/
tab_main.tabpage_t_detail.dw_select_transfer.GetChild('warehouse', ldwc2)
ldwc.Sharedata(ldwc2) /*Transfer Search*/
tab_main.tabpage_pick.dw_select_pick.GetChild('warehouse', ldwc2)
ldwc.Sharedata(ldwc2) /*Pick Search*/
tab_main.tabpage_pack.dw_select_pack.GetChild('warehouse', ldwc2)
ldwc.Sharedata(ldwc2) /*Pack Search*/
tab_main.tabpage_adjustment.dw_select_adjust.GetChild('warehouse', ldwc2)
ldwc.Sharedata(ldwc2) /*adjust Search*/
tab_main.tabpage_SerialInventory.dw_search_SerialInventory.GetChild('warehouse', ldwc2) 
ldwc.Sharedata(ldwc2) /*Serial Inventory Search*/  //Jxlim 09/24/2013 Ariens CR-26
tab_main.tabpage_kits.dw_kits.GetChild('warehouse', ldwc2) // Dinesh - 03/28/2022 - Kit tab
ldwc.Sharedata(ldwc2) /*Kits*/ // Dinesh - 03/28/2022 - Kit tab

If Upper(gs_project) = 'PANDORA' then
	//TimA 07/17/12
	//Because of the Shardata above this needs to be after it for Pandora
	//We need to populate the owner codes as they change.  
	If tab_main.tabpage_r_detail.dw_select_receive.RowCount() = 0 Then
		tab_main.tabpage_r_detail.dw_select_receive.InsertRow(0)
	End If	
	If tab_main.tabpage_d_detail.dw_select_delivery.RowCount() = 0 Then
		tab_main.tabpage_d_detail.dw_select_delivery.InsertRow(0)
	End If
End if

//12/11 - MEA -  Loading Inventory Dropdown - Avail and All inventory
idw_select.GetChild("inventory_type", ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project)

//Share the data

idw_avail_inv_search.GetChild('inventory_type', ldwc2)
ldwc.ShareData(ldwc2)

idw_search_SerialInventory.GetChild('inventory_type', ldwc2)
ldwc.ShareData(ldwc2)

//08/07 - PCONKL - Retreiving Group by Project and sharing
idw_select.GetChild('group', ldwcgrp)
ldwcgrp.SetTransObject(Sqlca)
ldwcgrp.Retrieve(gs_project)
If ldwcgrp.RowCount() = 0 Then ldwcgrp.InsertRow(0)

idw_search.GetChild('grp',ldwcgrp2)
ldwcgrp.ShareData(ldwcgrp2)

idw_avail_inv_search.GetChild('group',ldwcgrp2)
ldwcgrp.ShareData(ldwcgrp2)

//// 01/01 PCONKL - share group dropdowns and Filter by project
//ldwc.SetFilter("project_id = '" + gs_project + "'")
//ldwc.Filter()

idw_select.GetChild('loc_from', ldwc)
ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve() /*dont retreive until a Warehouse has been selected

//Share location dropdowns
idw_select.GetChild('loc_to', ldwc2)
ldwc.ShareData(ldwc2)

//Jxlim 09/27/2013 Ariens CR-26 from location
idw_search_serialInventory.GetChild('loc_from', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//Jxlim 09/27/2013 Ariens CR-26 To location
idw_search_serialInventory.GetChild('loc_to', ldwc2)
ldwc.ShareData(ldwc2)

//tab_main.tabpage_r_detail.dw_select_receive.GetChild('loc_from', ldwc2)
//TimA 09/10/15 fixed a bug with the transaction object in the receive tab
idw_receive_search.GetChild('loc_from', ldwc)
ldwc.SetTransObject(Sqlca)
//ldwc.ShareData(ldwc2 ) //07-Oct-2015 :Madhu commented

//tab_main.tabpage_r_detail.dw_select_receive.GetChild('loc_to', ldwc2)
//TimA 09/10/15 fixed a bug with the transaction object in the receive tab
idw_receive_search.GetChild('loc_to', ldwc2) //07-Oct-2015 :Madhu changed from ldwc to ldwc2
ldwc.ShareData(ldwc2)

//07-Oct-2015 :Madhu- Added code to share Location b/w From and To - START
idw_avail_inv_search.getchild( 'loc_from', ldwc)
ldwc.settransobject(sqlca)

//Share location dropdowns
idw_avail_inv_search.getchild('loc_to', ldwc2)
ldwc.sharedata( ldwc2)
//07-Oct-2015 :Madhu- Added code to share Location b/w From and To - END

// 03/02 - PCONKL - Retieve Inv Type dropdown by Project
idw_main.GetChild('inventory_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)

// 08/07 - PCONKL - Share with Avail Inv Search
idw_avail_inv.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

// 04/14 - - PCONKL - Share with Serial INventory Tab
idw_SerialInventory.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

idw_select.insertrow(0)

//Jxlim 09/26/2013 Ariens CR-26
If 	tab_main.tabpage_SerialInventory.visible = True Then		
	idw_search_SerialInventory.InsertRow(0)		
End If

// 05/00 PCONKL - get SQL for each DW to tackon modifications
is_org_sql = idw_search.getsqlselect()
isorigSql_avail_inv = idw_avail_inv.getsqlselect()
isorigsql_main = idw_Main.getsqlselect()
isorigsql_receive = idw_receive.getsqlselect()
isorigsql_delivery = idw_delivery.getsqlselect()
isorigsql_transfer = idw_transfer.getsqlselect()
isorigsql_pick = idw_pick.getsqlselect()
isorigsql_pack = idw_pack.getsqlselect()
isorigsql_adjust = idw_adjust.getsqlselect()
//Jxlim 09/26/2013 Ariens CR-26 place it here after all the child dw to avoid dw specify retrieval argument error message
isorigSql_SerialInventory = idw_serialinventory.getsqlselect()	
isorigsql_kits = idw_kits.getsqlselect() // Dinesh - 03/28/2022- Kits

//idwCurrent = idw_main
//idw_Current = idw_main
idwCurrent = idw_avail_inv
idw_Current = idw_avail_inv

im_menu.m_file.m_save.Enabled = False
im_menu.m_file.m_retrieve.Enabled = True
im_menu.m_file.m_print.Enabled = True
im_menu.m_record.m_delete.Enabled = False
im_menu.m_record.m_new.Enabled = False
im_menu.m_record.m_edit1.Enabled = False
im_menu.m_file.m_refresh.Enabled = False

//Added by DGM for getting original height for band 
//see ue_retreive for more details...
//ls_data= idw_main.Object.c_sku_tot_t.Band
ls_data= idw_avail_inv.Object.c_sku_tot_t.Band
ls_con="DataWindow." + ls_data +".height" 
ii_height=integer(idw_main.describe(ls_con))

//07-Apr-2017 :Madhu - PEVS-517 -Stock Inventory Commodity Codes - START
If upper(gs_project) ='PANDORA' Then
	wf_multi_select_commodity_code()
else 
	idw_select.modify("commodity_cd_t.visible =false")
	idw_select.modify("commodity_cd.visible =false")
	idw_avail_inv_search.modify("commodity_cd_t.visible =false")
	idw_avail_inv_search.modify("commodity_cd.visible =false")
End If
//07-Apr-2017 :Madhu - PEVS-517 -Stock Inventory Commodity Codes - END

This.TriggerEvent("ue_edit")

//08/07 - PCONKL - Default to Current Inv Tab
Tab_Main.SelectTab(2)

//05-Oct-2016 :Madhu- Visible "Reason" column only on Avail Inventory search tab
idw_select.modify("reason.visible =false")
idw_select.modify("reason_t.visible =false")
end event

event resize;tab_main.Resize(workspacewidth() - 30,workspaceHeight()-30)

tab_main.tabpage_search.dw_search.Resize(workspacewidth() - 60,workspaceHeight()-420)

//TimA 07/17/12 as a result of Pandora issue #360 adding the new owner code in the search criteria the results windows needed to be adjusted to -500 on the height
tab_main.tabpage_main.dw_main.Resize(workspacewidth() - 60,workspaceHeight()-500)
tab_main.tabpage_avail_inventory.dw_avail_inv.Resize(workspacewidth() - 60,workspaceHeight()-500)
tab_main.tabpage_d_detail.dw_d_detail.Resize(workspacewidth() - 60,workspaceHeight()-500)

tab_main.tabpage_r_detail.dw_receive_detail.Resize(workspacewidth() - 60,workspaceHeight()-460)
tab_main.tabpage_t_detail.dw_t_detail.Resize(workspacewidth() - 60,workspaceHeight()-350)
tab_main.tabpage_pick.dw_pick_detail.Resize(workspacewidth() - 60,workspaceHeight()-410)
tab_main.tabpage_pack.dw_pack_detail.Resize(workspacewidth() - 60,workspaceHeight()-280)
tab_main.tabpage_adjustment.dw_adjust.Resize(workspacewidth() - 60,workspaceHeight()-350)
tab_main.tabpage_serialinventory.dw_serialInventory.Resize(workspacewidth() - 60,workspaceHeight()-350)  //Jxlim 09/27/2013 Ariens CR-26
tab_main.tabpage_kits.dw_si_kits.Resize(workspacewidth() - 60,workspaceHeight()-500) // Dinesh - 04042022
end event

event ue_clear;
Choose Case idwCurrent
		
	Case idw_main
		
		idw_select.Reset()
		idw_main.Reset()
		idw_select.InsertRow(0)
		idw_select.SetFocus()
		//TimA 07/06/12 Pandora #360
		If Upper(gs_project) = 'PANDORA' then
			isWarehouse = ''
			wf_update_owner_select(idw_All_child_owner)
		End if
		
	Case idw_avail_inv
		
		idw_avail_inv_search.Reset()
		idw_avail_inv.Reset()
		idw_avail_inv_search.InsertRow(0)
		idw_avail_inv_search.SetFocus()
		//TimA 07/06/12 Pandora #360
		If Upper(gs_project) = 'PANDORA' then
			isWarehouse = ''
			wf_update_owner_select(idw_Avail_child_owner)
		End if
		
	//Jxlim 09/26/2013 CR-26 Serial Inventory Number Scanning
	case idw_Serialinventory
		
		idw_search_serialinventory.Reset()
		idw_search_serialinventory.InsertRow(0)
		idw_serialinventory.Reset()
		idw_serialinventory.Setfocus()

		
	Case idw_receive
		
		tab_main.tabpage_r_detail.dw_select_receive.Reset()
		tab_main.tabpage_r_detail.dw_select_receive.InsertRow(0)
		tab_main.tabpage_r_detail.dw_receive_detail.Reset()
		tab_main.tabpage_r_detail.dw_select_receive.Setfocus()
		//TimA 07/16/12 Pandora #360
		If Upper(gs_project) = 'PANDORA' then
			isWarehouse = ''
			wf_update_owner_select(idw_Receive_child_owner)
		End if
		
	case idw_delivery
		
		tab_main.tabpage_d_detail.dw_select_delivery.Reset()
		tab_main.tabpage_d_detail.dw_select_delivery.InsertRow(0)
		tab_main.tabpage_d_detail.dw_d_detail.Reset()
		tab_main.tabpage_d_detail.dw_select_delivery.Setfocus()
		//TimA 07/16/12 Pandora #360
		If Upper(gs_project) = 'PANDORA' then
			isWarehouse = ''
			wf_update_owner_select(idw_Delivery_child_owner)
		End if


	case idw_transfer
		
		tab_main.tabpage_t_detail.dw_select_transfer.Reset()
		tab_main.tabpage_t_detail.dw_select_transfer.InsertRow(0)
		idw_transfer.Reset()
		idw_transfer.Setfocus()
		
	case idw_pick
		
		tab_main.tabpage_pick.dw_select_pick.Reset()
		tab_main.tabpage_pick.dw_select_pick.InsertRow(0)
		idw_pick.Reset()
		idw_pick.Setfocus()
		
	case idw_pack
		
		tab_main.tabpage_pack.dw_select_pack.Reset()
		tab_main.tabpage_pack.dw_select_pack.InsertRow(0)
		idw_pack.Reset()
		idw_pack.Setfocus()
		
	case idw_adjust
		
		tab_main.tabpage_adjustment.dw_select_adjust.Reset()
		tab_main.tabpage_adjustment.dw_select_adjust.InsertRow(0)
		idw_adjust.Reset()
		idw_adjust.Setfocus()
		
	case idw_search
		
		idw_search.Reset()
		idw_query.Reset()
		idw_query.InsertRow(0)	
		
	case idw_kits
		// Begin - 03/28/2022- Dinesh - Kit
		tab_main.tabpage_kits.dw_kits.Reset()
		tab_main.tabpage_kits.dw_kits.InsertRow(0)
		idw_adjust.Reset()
		idw_adjust.Setfocus()
		// End - 03/22/2022- Dinesh - Kit

End Choose
end event

event ue_sort;call super::ue_sort;
Return AncestorReturnValue

end event

event open;call super::open;i_nwarehouse = Create n_warehouse

ilhelpTopicID = 530 /*set help topic*/

if Upper(gs_project) = 'PULSE' then
	tab_main.tabpage_main.dw_main.dataobject = 'd_stock_inquiry_pulse'
	tab_main.tabpage_main.dw_main.SetTransObject(SQLCA)
end if

//// Begin -Dinesh - 09282022 - SIMS-74- Geistlich Serialization - Updates
//if Upper(gs_project) = 'GEISTLICH' then
//	tab_main.tabpage_main.dw_select.dataobject = 'd_si_search_geistlich'
//	tab_main.tabpage_main.dw_select.SetTransObject(SQLCA)
//end if
//// End -Dinesh - 09282022 - SIMS-74- Geistlich Serialization - Updates

//if Upper(gs_project) = 'PHILIPS-SG' OR Upper(gs_project) = 'PHILIPS-TH' then
//	tab_main.tabpage_avail_inventory.dw_avail_inv.dataobject = 'd_stock_inquiry_content_only_philips'
//	tab_main.tabpage_avail_inventory.dw_avail_inv.SetTransObject(SQLCA)
//end if
//

If Left(gs_project,3) = 'WS-' then
	tab_main.tabpage_avail_inventory.dw_avail_inv.dataobject = 'd_stock_inquiry_content_only_ws'
	tab_main.tabpage_avail_inventory.dw_avail_inv.SetTransObject(SQLCA)
end if

end event

event close;call super::close;Destroy n_warehouse;

g.of_setwarehouse(False)
end event

type tab_main from w_std_master_detail`tab_main within w_stockinquiry
event create ( )
event destroy ( )
integer x = 0
integer y = 0
integer width = 4361
integer height = 2060
integer textsize = -8
boolean multiline = true
tabpage_avail_inventory tabpage_avail_inventory
tabpage_serialinventory tabpage_serialinventory
tabpage_r_detail tabpage_r_detail
tabpage_d_detail tabpage_d_detail
tabpage_t_detail tabpage_t_detail
tabpage_pick tabpage_pick
tabpage_pack tabpage_pack
tabpage_adjustment tabpage_adjustment
tabpage_kits tabpage_kits
end type

on tab_main.create
this.tabpage_avail_inventory=create tabpage_avail_inventory
this.tabpage_serialinventory=create tabpage_serialinventory
this.tabpage_r_detail=create tabpage_r_detail
this.tabpage_d_detail=create tabpage_d_detail
this.tabpage_t_detail=create tabpage_t_detail
this.tabpage_pick=create tabpage_pick
this.tabpage_pack=create tabpage_pack
this.tabpage_adjustment=create tabpage_adjustment
this.tabpage_kits=create tabpage_kits
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_avail_inventory,&
this.tabpage_serialinventory,&
this.tabpage_r_detail,&
this.tabpage_d_detail,&
this.tabpage_t_detail,&
this.tabpage_pick,&
this.tabpage_pack,&
this.tabpage_adjustment,&
this.tabpage_kits}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_avail_inventory)
destroy(this.tabpage_serialinventory)
destroy(this.tabpage_r_detail)
destroy(this.tabpage_d_detail)
destroy(this.tabpage_t_detail)
destroy(this.tabpage_pick)
destroy(this.tabpage_pack)
destroy(this.tabpage_adjustment)
destroy(this.tabpage_kits)
end on

event tab_main::selectionchanged;DatawindowChild	ldwc
long ll_c
wf_check_menu(TRUE,'sort')
// 05/00 PCONKL - set the current DW for retrieving, etc.
Choose Case newindex
		
	
	Case 1 /*Invcentory DW*/
		
		idwCurrent = idw_main
		
		tab_main.tabpage_main.uo_commodity_code.bringtotop =False //07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
			
		
	Case 2 /* 08/07 - PCONKL - Avail Inventory (Content Only)*/
		
		idwCurrent = idw_avail_inv
		If tabpage_avail_inventory.dw_avail_inv_search.RowCount() = 0 Then
			tabpage_avail_inventory.dw_avail_inv_search.InsertRow(0)
		End If
	
			tab_main.tabpage_avail_inventory.uo_commodity.bringtotop=False //07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
			
	//Jxlim 09/24/2013 Ariens Serial Inventory tab (New tab insert in between Avail_inv tab and Receive tab)
	Case 3 /*Serial Inventory DW*/	
		idwCurrent = idw_SerialInventory
		
		If   idw_search_SerialInventory.RowCount() = 0 Then
			idw_search_SerialInventory.InsertRow(0)
		End If
		
	Case 4 /*receiving DW*/
		
		idwCurrent = idw_receive
		
		If tabpage_r_detail.dw_select_receive.RowCount() = 0 Then
			tabpage_r_detail.dw_select_receive.InsertRow(0)
		End If	
		
	Case 5 /*Delivery DW*/
		
		idwCurrent = idw_delivery
		
		If tabpage_d_detail.dw_select_delivery.RowCount() = 0 Then
			tabpage_d_detail.dw_select_delivery.InsertRow(0)
		End If
		
	Case 6 /*Transfer DW*/
		
		idwCurrent = idw_transfer
		
		If tabpage_t_detail.dw_select_transfer.RowCount() = 0 Then
			tabpage_t_detail.dw_select_transfer.InsertRow(0)
		End If
		
	Case 7 /*Pick DW*/
		
		idwCurrent = idw_pick
		
		If tabpage_pick.dw_select_pick.RowCount() = 0 Then
			tabpage_pick.dw_select_pick.InsertRow(0)
		End If
		
	Case 8 /*Pack DW*/
		
		idwCurrent = idw_pack
		
		If tabpage_pack.dw_select_pack.RowCount() = 0 Then
			tabpage_pack.dw_select_pack.InsertRow(0)
		End If
		
	Case 9 /*Adjustments DW*/
		
		idwCurrent = idw_adjust
		
		If tabpage_adjustment.dw_select_adjust.RowCount() = 0 Then
			tabpage_adjustment.dw_select_adjust.InsertRow(0)
		End If
		
	Case 11 /*Search DW*/
		
		idwCurrent = idw_search
	//Begin - 03/28/2022- Dinesh - Tab kit
	Case 10 /* Kits DW*/
		idwCurrent = idw_kits 
		
		If tabpage_kits.dw_kits.RowCount() = 0 Then
			tabpage_kits.dw_kits.InsertRow(0)
		End If
	//End - 03/28/2022- Dinesh - Tab kit
End Choose

// KRZ Synchronize the sku and warehouse.
f_setwarehousesku(newindex)

idw_current = idwCurrent /*ancestor for sort & filter using idw_current*/

//m_simple_edit.m_record.m_filter.Disable()

end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 192
integer width = 4325
integer height = 1852
string text = "All Inventory"
uo_commodity_code uo_commodity_code
dw_main dw_main
dw_select dw_select
end type

on tabpage_main.create
this.uo_commodity_code=create uo_commodity_code
this.dw_main=create dw_main
this.dw_select=create dw_select
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_commodity_code
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.dw_select
end on

on tabpage_main.destroy
call super::destroy
destroy(this.uo_commodity_code)
destroy(this.dw_main)
destroy(this.dw_select)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 192
integer width = 4325
integer height = 1852
dw_search dw_search
dw_query dw_query
end type

on tabpage_search.create
this.dw_search=create dw_search
this.dw_query=create dw_query
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_search
this.Control[iCurrent+2]=this.dw_query
end on

on tabpage_search.destroy
call super::destroy
destroy(this.dw_search)
destroy(this.dw_query)
end on

type uo_commodity_code from uo_multi_select_search within tabpage_main
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 2258
integer y = 300
integer width = 741
integer taborder = 30
end type

event ue_mousemove;//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
if ib_show_commodity_list then
	ib_show_commodity_list = false
	this.bringtotop = false
else
	ib_show_commodity_list = true
	this.bringtotop = true
end if
end event

on uo_commodity_code.destroy
call uo_multi_select_search::destroy
end on

type dw_main from u_dw_ancestor within tabpage_main
integer x = 5
integer y = 328
integer width = 4037
integer height = 1456
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_stock_inquiry"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve
String	lsWhere,ls_data,ls_con,	lsNewSQL, ls_String, ls_warehouse, ls_sku ,ls_multiselect
Integer	liRC,li_height,ll_get_hi
boolean lb_hight
Boolean lb_where

lb_where = False
lb_hight = false

idw_select.AcceptTExt()

//DGM 011101 for hidding the group by sku for all queries 
ls_data=this.Object.c_sku_tot_t.Band
ls_con="DataWindow." + ls_data +".height=0" 
this.Modify(ls_con)

//always tackon Project...
lsWhere  += " and content_summary.Project_id = '" + gs_project + "'"

//tackon SKU
ls_sku = idw_select.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Content_Summary.SKU like '%" + idw_select.GetItemString(1,"sku") + "%'  "
	lb_hight=true	//DGM011101
	lb_where = TRUE
end if

//Tackon User field 1
if  not isnull(idw_select.GetItemString(1,"alt_sku")) then
	lswhere += " and item_master.alternate_sku like '" + idw_select.GetItemString(1,"alt_sku") + "%'  "
	lb_where = TRUE
end if

//07/03 Mathi Track on CONT ID
If not isnull(idw_select.GetItemString(1,"container_id")) Then
	lswhere += " and content_summary.container_id = '" + idw_select.GetITemString(1,"container_id") +"' "
	lb_where = TRUE
End IF
// 10/00 PCONKL - Tackon Lot Nbr
if  not isnull(idw_select.GetItemString(1,"lot_no")) then
	lswhere += " and content_summary.lot_no =  '" + idw_select.GetItemString(1,"lot_no") + "'  "
	lb_where = TRUE
end if


// 05/09 MEA supp code
if not isnull(idw_select.GetItemString(1,"supp_code")) then
	lswhere += " and item_master.supp_code = '" + idw_select.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

// Begin - Dinesh - 09282022- SIMS-89- Geistlich Serialization - Updates
//if (upper(gs_project)='GEISTLICH')  or (upper(gs_project)='NYCSP')  then
	if not isnull(idw_select.GetItemString(1,"serial_no")) then
		lswhere += " and Content_Summary.serial_no = '" + idw_select.GetItemString(1,"serial_no") + "'" + " and Item_Master.Serialized_Ind ='Y'"
	end if
//End if
// End - Dinesh - 09282022- SIMS-89- Geistlich Serialization - Updates

// 10/00 PCONKL - Tackon PO Nbr
//if  not isnull(idw_select.GetItemString(1,"PO_no")) then
//	lswhere += " and content_summary.PO_no =  '" + idw_select.GetItemString(1,"PO_no") + "'  "
//	lb_where = TRUE
//end if


ls_string = idw_select.GetItemString(1,"PO_no")
if not isNull(ls_string) then
	lswhere += " and (content_summary.po_no = '" + ls_string + "' or Content_Summary.ro_no in (select ro_no from receive_xref where po_no = '" + ls_string + "'))" /* 04/04 - MA - Added so Receive _Xref would be search for po_no */
	lb_where = TRUE
end if

// 2009/05/29 TaMcClanahan - Tackon PO_NO2
if  not isnull(idw_select.GetItemString(1,"po_no2")) then
	lswhere += " and content_summary.po_no2 =  '" + idw_select.GetItemString(1,"po_no2") + "'  "
	lb_where = TRUE
end if


//tackon Warehouse
ls_warehouse = idw_select.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += " and Content_Summary.wh_code = '" + idw_select.GetItemString(1,"warehouse") + "'  "
	lb_where = TRUE
end if

//tackon Owner
//TimA 07/06/12 Pandora #360 add basline code to inclue owner code
if not isnull(idw_select.GetItemString(1,"owner_code")) and Trim(idw_select.GetItemString(1,"owner_code")) <> '' then
	lswhere += " and Owner.Owner_Cd = '" + idw_select.GetItemString(1,"owner_code") + "'  "
	lb_where = TRUE
end if

//Tackon Group
if not isnull(idw_select.GetItemString(1,"group")) then
	lswhere += " and item_master.grp = '" + idw_select.GetItemString(1,"group") + "'  "
	lb_where = TRUE
end if

//From location
if not isnull(idw_select.GetItemString(1,"loc_from")) then
	lswhere += " and Content_Summary.l_code >= '" + idw_select.GetItemString(1,"loc_from") + "'  "
	lb_where = TRUE
end if

//To location
if not isnull(idw_select.GetItemString(1,"loc_to")) then
	lswhere += " and Content_Summary.l_code <= '" + idw_select.GetItemString(1,"loc_to") + "'  "
	lb_where = TRUE
end if


// 12/11 -  MEA - Inventory Type
if not isnull(idw_select.GetItemString(1,"inventory_type")) then
	lswhere += " and content_summary.inventory_type = '" + idw_select.GetItemString(1,"inventory_type") + "'  "
	lb_where = TRUE
end if

//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
ls_multiselect = tab_main.tabpage_main.uo_commodity_code.uf_build_search( true)

if not isnull(ls_multiselect) then
	lswhere += ls_multiselect
	lb_where =TRUE
end If

// 09/02 - PCONKL - added union for Work Orders - need to tackon Where clause for both selects
// 08/07 - PCONKL - REmoved union to Workorders - changed to outer join from RM to Content
// 03/11 - MEA - Added Union for Works Orders

integer li_union_pos

//lsNewSQL = Replace(isOrigSql_main,Pos(upper(isOrigSQL_Main),'UNION'),5, lsWhere + ' Union ')

li_union_pos = Pos(Upper( isOrigSql_main), "UNION")

// Added check for li_union_pos > 0, Pulse datawindow does not have a union in the select and it was 
// causing an error.  04/26/11  cawikholm
IF li_union_pos > 0 THEN
	
	lsNewSQL = left( isOrigSql_main, li_union_pos -1) + lswhere + " " +  mid ( isOrigSql_main, li_union_pos)

ELSE
	
	lsNewSQL = isOrigSql_main

END IF

liRC = This.setsqlselect(lsNewSQL + lswhere)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

// pvh - 09/20/06 - bugfix
// liRC should be a long!!!!
// 38986 returns -somelargeInt !!!!!
long rc
// liRC = This.Retrieve()
rc =  This.Retrieve()
If rc <= 0 Then
//If liRC <= 0 Then
	MessageBox(is_title, "No inventory records were found matching your search criteria!")
ELSEIF  liRC > 1 and lb_hight THEN //Enire if else Added by DGM for display sku group footer
	ls_con="upper(sku) <> '" + idw_main.GetItemString(1,"sku") +"'"
	IF this.Find(ls_con,1,this.rowcount()) > 0 THEN
		ls_con="DataWindow." + ls_data +".height="+string(ii_height) 
		this.Modify(ls_con)
	END IF	
Else
	This.Setfocus()
End If



end event

event clicked;call super::clicked;
//Integer li_pos
//String lc_str , lc_sort
//
//lc_str = v_dw.getobjectatpointer()
//
//li_pos = pos(upper(lc_str),'_T')
//
//IF li_pos > 0 THEN
//	lc_sort = mid(lc_str,1,li_pos - 1)
//
//	IF ii_sortorder = 0 THEN
//		ii_sortorder = 1
//		lc_sort = trim(lc_sort) + ' A'
//   ELSE
//		ii_sortorder = 0
//		lc_sort = trim(lc_sort) + ' D'
//   END IF
//	v_dw.setsort(lc_sort)
//Return v_dw.sort()
//END IF
//
end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)
//DGM Make owner name invisible based in indicator
IF Upper(g.is_coo_ind) <> 'Y' THEN
	this.object.country_of_origin.visible = 0
	this.object.country_of_origin_t.visible = 0
End IF

//07-Apr-2017 Madhu PEVS-417 Stock Inventory Commodity Codes
If upper(gs_project) ='PANDORA' then
	this.object.commodity_code.visible =1
	this.object.commodity_code_t.visible =1
else
	this.object.commodity_code.visible =0
	this.object.commodity_code_t.visible =0
End If
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 786 //238
ls_column[2]="serial_no"
ls_value[2] = "-"
li_width[2] = 600
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 600
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 600
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 600
ls_column[6]="content_summary_length"
ls_value[6] = "0"
li_width[6] = 279
ls_column[7]="content_summary_width"
ls_value[7] = "0"
li_width[7] = 279
ls_column[8]="content_summary_height"
ls_value[8] = "0"
li_width[8] = 279
ls_column[9]="expiration_date"
ls_value[9] = '12/31/2999'
li_width[9] = 334
ls_column[10]="wip_qty"
ls_value[10] = "0"
li_width[10] = 311
ls_column[11]="tfr_in"
ls_value[11] = "0"
li_width[11] = 320
ls_column[12]="tfr_out"
ls_value[12] = "0"
li_width[12] = 325
ls_column[13]="content_summary_weight"
ls_value[13] = "0"
li_width[13] = 279
ls_column[14]="staging_location"
ls_value[14] = ""
li_width[14] = 539
ls_column[15]="new_qty"
ls_value[15] = "0"
li_width[15] = 311
ls_column[16] = "max_supply_onhand"
ls_value[16] = "0"
li_width[16] = 311
ls_column[17] = "min_rop"
ls_value[17] = "0"
li_width[17] = 311
ls_column[18] = "reorder_qty"
ls_value[18] = "0"
li_width[18] = 311
i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])

end event

event doubleclicked;call super::doubleclicked;

Str_parms	lStrparms
		
			
If Row > 0 Then
	
	Choose Case dwo.name
			
	case "po_no"  /* 04/04 - MAnderson - Multi PO */
		
		if this.getitemnumber(row,'avail_qty') > 0 then

			lstrparms.Long_arg[1] = 0
			lstrparms.String_arg[1] = dw_main.getItemString(row,"sku")
			lstrparms.String_arg[2] = dw_main.getitemstring(row,"supp_code")
			lstrparms.String_arg[3] = dw_main.getitemString(row,"ro_no")
		
			i_nwarehouse.of_ro_multiplepo(lstrparms)

				
		else
		
			if this.getitemstring(row,'po_no') = 'MULTIPO' then
			
				lstrparms.Long_arg[1] = 0
		
				lstrparms.String_arg[1] = this.getItemString(row,"sku")
				lstrparms.String_arg[2] = this.getitemstring(row,"supp_code")
				lstrparms.String_arg[3] = this.getitemString(row,"ro_no")
	
				lstrparms.String_arg[4] = "RO"
	
				if NOT isnull(lstrparms.String_arg[1]) and &
					NOT isnull(lstrparms.String_arg[2]) and &
					NOT isnull(lstrparms.String_arg[3])  THEN
					
					openwithParm(w_ro_multipo,lstrparms)
						
				end if
		
			end if	


		end if
	
	END CHOOSE

	
	
END IF
end event

type dw_select from u_dw_ancestor within tabpage_main
event ue_retrieve_locs ( )
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 4
integer width = 3689
integer height = 324
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_si_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_retrieve_locs;String	lsWhere,	&
			lsNewSQL
DatawindowChild	ldwc

If not isnull(isWarehouse) Then
	lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
	This.GetChild("loc_from", ldwc)
	lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
	lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
	ldwc.SetTransObject(SQLCA)
	ldwc.setsqlselect(lsNewSql)
	//messagebox("ls newsql", lsnewsql)
	ldwc.Retrieve()
End If
end event

event ue_keydown;//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes

if this.getcolumnname( ) = 'commodity_cd'  then
	tab_main.tabpage_main.uo_commodity_code.uf_set_filter( this.gettext())
end if
end event

event constructor;call super::constructor;
datawindowChild	ldwc

// 07/00 PCONKL - Get the original sql from from location dropdown so we can modify sql and retrieve for current row
This.GetChild('loc_from',ldwc)
isorigsql_loc = ldwc.getsqlselect()

end event

event itemchanged;

// 07/00 PCONKL - If warehouse is entered/changed, retrieve locations for that warehouse
Choose Case dwo.name
		
	// KRZ IF the user enters the SKU,
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	Case 'warehouse'
		
		isWareHouse = Data
		//TimA 07/06/12 Pandora #360 Add owner Code to the search
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code','')
			idw_avail_inv_search.setitem(1,'owner_code','')
			idw_receive_search.setitem(1,'owner_code','')
			idw_delivery_search.setitem(1,'owner_code','')
			//idw_receive_search, idw_delivery_search
			wf_update_owner_select(idw_All_child_owner)
			wf_update_owner_select(idw_Avail_child_owner)
			wf_update_owner_select(idw_Receive_child_owner)
			wf_update_owner_select(idw_Delivery_child_owner)			
		End if
			//This.PostEvent("ue_retrieve_locs") don't retrieve locations unless clicked on
		Case 'owner_code'
		//TimA 07/09/12 Pandora #360 Update the ower in both tabs
		If Upper(gs_project) = 'PANDORA' then
			//idw_select.setitem(1,'owner_code','')
			idw_avail_inv_search.setitem(1,'owner_code',data)
			idw_receive_search.setitem(1,'owner_code',data)
			idw_delivery_search.setitem(1,'owner_code',data)
		End if
		
	//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
	Case 'commodity_cd'
		tab_main.tabpage_main.uo_commodity_code.uf_set_filter( data)
		
End Choose
end event

event process_enter;IF This.GetColumnName() = "warehouse" THEN
	iw_window.Trigger Event ue_retrieve()
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

event clicked;call super::clicked;
DatawindowChild	ldwc
String	lsWhere,	&
			lsNewSQL

Choose Case Upper(dwo.Name)
		
	Case 'LOC_FROM', 'LOC_TO'
		
		This.GetChild('loc_from',ldwc)
		If ldwc.RowCount() = 0 Then
			If not isnull(isWarehouse) Then
				lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
				lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
				lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
				ldwc.SetTransObject(SQLCA)
				ldwc.setsqlselect(lsNewSql)
				ldwc.Retrieve()
			End If
		End If
	
	//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 
	Case 'COMMODITY_CD'
			wf_show_hide_data(1) //pass tabpage index no.
		
End Choose
end event

event losefocus;call super::losefocus;accepttext()
end event

type dw_search from u_dw_ancestor within tabpage_search
integer y = 268
integer width = 3799
integer height = 1436
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_item_master_search"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
string ls_code

IF Row > 0 THEN
	ls_code = this.getitemstring(row,'sku')	
	idw_select.setitem(1,'sku',ls_code)
	//iw_window.Trigger Event ue_retrieve()
	
	// 05/00 pconkl - 
	tab_main.SelectTab(1)
	idw_main.TriggerEvent("ue_retrieve") 
	
END IF
end event

event clicked;call super::clicked;
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF

end event

event ue_retrieve;
string ls_sku, ls_warehouse, ls_descript,ls_uf1,ls_uf2,ls_uf3,ls_uf4,ls_uf5, ls_grp
string ls_where
Boolean lb_where

If idw_query.accepttext() = -1 Then Return
idw_search.reset()
lb_where = false

ls_sku = idw_query.getitemstring(1,"sku")
ls_grp = idw_query.getitemstring(1,"grp")
ls_descript = idw_query.getitemstring(1,"descript")
ls_uf1 = idw_query.getitemstring(1,"alternate_sku")
ls_uf2 = idw_query.getitemstring(1,"user_field2")
ls_uf3 = idw_query.getitemstring(1,"user_field3")
ls_uf4 = idw_query.getitemstring(1,"user_field4")
ls_uf5 = idw_query.getitemstring(1,"user_field5")
//ls_warehouse = idw_query.getitemstring(1,"warehouse")

	
//ls_where = "where content.project_id = item_master.project_id and "
//ls_where += " content.owner_id = item_master.owner_id AND "
//ls_where += " content.sku = item_master.sku           AND " 
//ls_where +=  "item_master.owner_id = owner.owner_id  	AND " 

ls_where += " and item_master.project_id = '" + gs_project + "' "

if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	ls_where += " and item_master.sku like '" + ls_sku + "%'  "
	lb_where = TRUE
end if

//if  not isnull(ls_warehouse) then
//	ls_where += " and content.wh_code = '" + ls_warehouse + "'  "
//end if

if not isnull(ls_descript) then
	ls_where += " and item_master.description like '%" + ls_descript + "%'  "
	lb_where = TRUE
end if

if not isnull(ls_grp) then
	ls_where += " and item_master.grp = '" + ls_grp + "'  "
	lb_where = TRUE
end if

// 01/01 PCONKL - user field 1 is now alternate sku
if not isnull(ls_uf1) then
	ls_where += " and item_master.alternate_sku = '" + ls_uf1 + "'  "
	lb_where = TRUE
end if

if not isnull(ls_uf2) then
	ls_where += " and item_master.user_field2 = '" + ls_uf2 + "'  "
	lb_where = TRUE
end if

if not isnull(ls_uf3) then
	ls_where += " and item_master.user_field3 = '" + ls_uf3 + "'  "
	lb_where = TRUE
end if

// 01/01 User field 4 is supp code
if not isnull(ls_uf4) then
	ls_where += " and item_master.supp_code = '" + ls_uf4 + "'  "
	lb_where = TRUE
end if

if not isnull(ls_uf5) then
	ls_where += " and item_master.user_field5 = '" + ls_uf5 + "'  "
	lb_where = TRUE
end if
//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

idw_search.setsqlselect(is_org_sql + ls_where)

if idw_search.retrieve() = 0 then
	messagebox(is_title,"No records found!")
Else
	This.Setfocus()
end if
end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)

end event

type dw_query from u_dw_ancestor within tabpage_search
integer y = 16
integer width = 3237
integer height = 252
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_itemmaster_inquire"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;DatawindowChild	ldwc_warehouse, ldwc
string	lsFilter

//Made warehouse column invisible
this.object.warehouse.visible=0
this.object.warehouse_t.visible=0
this.object.descript.visible=0
this.object.descript_t.visible=0
//populate dropdowns - not done automatically since dw not being retrieved

dw_query.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "project_id = '" + gs_project + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
	dw_query.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
	
End If

//Filter Group
This.GetChild('grp',ldwc)
ldwc.SetFilter("project_id = '" + gs_project + "'")
ldwc.Filter()
end event

event itemchanged;call super::itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;call super::losefocus;accepttext()
end event

type tabpage_avail_inventory from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Avail Inventory"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_commodity uo_commodity
dw_avail_inv dw_avail_inv
dw_avail_inv_search dw_avail_inv_search
end type

on tabpage_avail_inventory.create
this.uo_commodity=create uo_commodity
this.dw_avail_inv=create dw_avail_inv
this.dw_avail_inv_search=create dw_avail_inv_search
this.Control[]={this.uo_commodity,&
this.dw_avail_inv,&
this.dw_avail_inv_search}
end on

on tabpage_avail_inventory.destroy
destroy(this.uo_commodity)
destroy(this.dw_avail_inv)
destroy(this.dw_avail_inv_search)
end on

type uo_commodity from uo_multi_select_search within tabpage_avail_inventory
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 2258
integer y = 300
integer width = 741
integer taborder = 30
end type

event ue_mousemove;//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 
if ib_show_commodity_list then
	ib_show_commodity_list = false
	this.bringtotop = false
else
	ib_show_commodity_list = true
	this.bringtotop = true
end if
end event

on uo_commodity.destroy
call uo_multi_select_search::destroy
end on

type dw_avail_inv from u_dw_ancestor within tabpage_avail_inventory
integer x = 5
integer y = 328
integer width = 4192
integer height = 1540
integer taborder = 30
string dataobject = "d_stock_inquiry_content_only"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_retrieve;call super::ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve
String	lsWhere,ls_data,ls_con,	lsNewSQL, ls_String, ls_warehouse, ls_sku, ls_multiselect
Integer	liRC,li_height,ll_get_hi
boolean lb_hight
Boolean lb_where
long rc

lb_where = False
lb_hight = false

idw_avail_inv_search .AcceptTExt()

//DGM 011101 for hidding the group by sku for all queries 
ls_data=this.Object.c_sku_tot_t.Band
ls_con="DataWindow." + ls_data +".height=0" 
this.Modify(ls_con)

//always tackon Project...
lsWhere  += " and content.Project_id = '" + gs_project + "'"

//tackon SKU
ls_sku = idw_avail_inv_search.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Content.SKU like '%" + idw_avail_inv_search.GetItemString(1,"sku") + "%'  "
	lb_hight=true	//DGM011101
	lb_where = TRUE
end if

//Tackon User field 1
if  not isnull(idw_avail_inv_search.GetItemString(1,"alt_sku")) then
	lswhere += " and item_master.alternate_sku like '" + idw_avail_inv_search.GetItemString(1,"alt_sku") + "%'  "
	lb_where = TRUE
end if

//07/03 Mathi Track on CONT ID
If not isnull(idw_avail_inv_search.GetItemString(1,"container_id")) Then
	lswhere += " and content.container_id = '" + idw_avail_inv_search.GetITemString(1,"container_id") +"' "
	lb_where = TRUE
End IF
// 10/00 PCONKL - Tackon Lot Nbr
if  not isnull(idw_avail_inv_search.GetItemString(1,"lot_no")) then
	lswhere += " and content.lot_no =  '" + idw_avail_inv_search.GetItemString(1,"lot_no") + "'  "
	lb_where = TRUE
end if

// 10/00 PCONKL - Tackon PO Nbr
//if  not isnull(idw_select.GetItemString(1,"PO_no")) then
//	lswhere += " and content_summary.PO_no =  '" + idw_select.GetItemString(1,"PO_no") + "'  "
//	lb_where = TRUE
//end if

// 2009/05/29 TaMcClanahan - Tackon PO_NO2
if  not isnull(idw_avail_inv_search.GetItemString(1,"po_no2")) then
	lswhere += " and content.po_no2 =  '" + idw_avail_inv_search.GetItemString(1,"po_no2") + "'  "
	lb_where = TRUE
end if

ls_string = idw_avail_inv_search.GetItemString(1,"PO_no")
if not isNull(ls_string) then
	lswhere += " and (content.po_no = '" + ls_string + "' or Content.ro_no in (select ro_no from receive_xref where po_no = '" + ls_string + "'))" /* 04/04 - MA - Added so Receive _Xref would be search for po_no */
	lb_where = TRUE
end if

//tackon Warehouse
ls_warehouse = idw_avail_inv_search.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += " and content.wh_code = '" + idw_avail_inv_search.GetItemString(1,"warehouse") + "'  "
	lb_where = TRUE
end if

//TimA 07/06/12 Pandora issue #360 add baseline change to include owner code
if not isnull(idw_avail_inv_search.GetItemString(1,"owner_code")) and Trim(idw_avail_inv_search.GetItemString(1,"owner_code")) <> '' then
	wf_update_owner_select (idw_Avail_child_owner)
	lswhere += " and Owner.Owner_Cd = '" + idw_avail_inv_search.GetItemString(1,"owner_code") + "'  "
	lb_where = TRUE
end if

// 05/09 MEA supp code
if not isnull(idw_avail_inv_search.GetItemString(1,"supp_code")) then
	lswhere += " and Content.supp_code = '" + idw_avail_inv_search.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//Tackon Group
if not isnull(idw_avail_inv_search.GetItemString(1,"group")) then
	lswhere += " and item_master.grp = '" + idw_avail_inv_search.GetItemString(1,"group") + "'  "
	lb_where = TRUE
end if

//From location
if not isnull(idw_avail_inv_search.GetItemString(1,"loc_from")) then
	lswhere += " and content.l_code >= '" + idw_avail_inv_search.GetItemString(1,"loc_from") + "'  "
	lb_where = TRUE
end if

//To location
if not isnull(idw_avail_inv_search.GetItemString(1,"loc_to")) then
	lswhere += " and content.l_code <= '" + idw_avail_inv_search.GetItemString(1,"loc_to") + "'  "
	lb_where = TRUE
end if

// 12/11 MEA supp code
if not isnull(idw_avail_inv_search.GetItemString(1,"inventory_type")) then
	lswhere += " and Content.inventory_type = '" + idw_avail_inv_search.GetItemString(1,"inventory_type") + "'  "
	lb_where = TRUE
end if

//05-Oct-2016 Madhu- Added Reason
if not isnull(idw_avail_inv_search.getItemString(1,"reason")) then
	lswhere += " and Content.Adj_Reason like '%"+ idw_avail_inv_search.getItemString(1,"reason")+"%'"
	lb_where =TRUE
end if

// Begin - Dinesh - 09292022- SIMS-89- Geistlich Serialization - Updates
//if (upper(gs_project)='GEISTLICH')  or (upper(gs_project)='NYCSP')  then
	if not isnull(dw_avail_inv_search.GetItemString(1,"serial_no")) then
		lswhere += " and Content.serial_no = '" + dw_avail_inv_search.GetItemString(1,"serial_no") + "'" + " and Item_Master.Serialized_Ind ='Y'"
	end if
//End if
// End - Dinesh - 09292022- SIMS-89- Geistlich Serialization - Updates

//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
ls_multiselect = tab_main.tabpage_avail_inventory.uo_commodity.uf_build_search( true)

if not isnull(ls_multiselect) then
	lswhere += ls_multiselect
	lb_where =TRUE
end If

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

integer li_union_pos

// 03/11 - MEA - Added Union for Works Orders

li_union_pos = Pos(Upper( isOrigSql_avail_inv), "UNION")

lsNewSQL = left( isOrigSql_avail_inv, li_union_pos -1) + lswhere + " " +  mid ( isOrigSql_avail_inv, li_union_pos)


liRC = This.setsqlselect(lsNewSQL + lswhere)



rc =  This.Retrieve()
If rc <= 0 Then
//If liRC <= 0 Then
	MessageBox(is_title, "No inventory records were found matching your search criteria!")
ELSEIF  liRC > 1 and lb_hight THEN //Enire if else Added by DGM for display sku group footer
	ls_con="upper(sku) <> '" + idw_main.GetItemString(1,"sku") +"'"
	IF this.Find(ls_con,1,this.rowcount()) > 0 THEN
		ls_con="DataWindow." + ls_data +".height="+string(ii_height) 
		this.Modify(ls_con)
	END IF	
Else
	This.Setfocus()
End If



end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)
//DGM Make owner name invisible based in indicator
IF Upper(g.is_coo_ind) <> 'Y' THEN
	this.object.country_of_origin.visible = 0
	this.object.country_of_origin_t.visible = 0
End IF

//07-Apr-2017 Madhu PEVS-417 Stock Inventory Commodity Codes
If upper(gs_project) ='PANDORA' then
	this.object.commodity_code.visible =1
	this.object.commodity_code_t.visible =1
else
	this.object.commodity_code.visible =0
	this.object.commodity_code_t.visible =0
End If
end event

event doubleclicked;call super::doubleclicked;

Str_parms	lStrparms
		
			
If Row > 0 Then
	
	Choose Case dwo.name
			
	case "po_no"  /* 04/04 - MAnderson - Multi PO */
		
		if this.getitemnumber(row,'avail_qty') > 0 then

			lstrparms.Long_arg[1] = 0
			lstrparms.String_arg[1] = This.getItemString(row,"sku")
			lstrparms.String_arg[2] = This.getitemstring(row,"supp_code")
			lstrparms.String_arg[3] = This.getitemString(row,"ro_no")
		
			i_nwarehouse.of_ro_multiplepo(lstrparms)

				
		else
		
			if this.getitemstring(row,'po_no') = 'MULTIPO' then
			
				lstrparms.Long_arg[1] = 0
		
				lstrparms.String_arg[1] = this.getItemString(row,"sku")
				lstrparms.String_arg[2] = this.getitemstring(row,"supp_code")
				lstrparms.String_arg[3] = this.getitemString(row,"ro_no")
	
				lstrparms.String_arg[4] = "RO"
	
				if NOT isnull(lstrparms.String_arg[1]) and &
					NOT isnull(lstrparms.String_arg[2]) and &
					NOT isnull(lstrparms.String_arg[3])  THEN
					
					openwithParm(w_ro_multipo,lstrparms)
						
				end if
		
			end if	


		end if
	
	END CHOOSE

	
	
END IF
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 786 //238
ls_column[2]="serial_no"
ls_value[2] = "-"
li_width[2] = 600
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 600
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 600
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 600

ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334

ls_column[7] = "max_supply_onhand"
ls_value[7] = "0"
li_width[7] = 311
ls_column[8] = "min_rop"
ls_value[8] = "0"
li_width[8] = 311
ls_column[9] = "reorder_qty"
ls_value[9] = "0"
li_width[9] = 311

i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])

end event

type dw_avail_inv_search from u_dw_ancestor within tabpage_avail_inventory
event ue_retrieve_locs ( )
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 4
integer width = 3666
integer height = 324
integer taborder = 30
string dataobject = "d_si_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_retrieve_locs();String	lsWhere,	&
			lsNewSQL
DatawindowChild	ldwc

If not isnull(isWarehouse) Then
	lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
	This.GetChild("loc_from", ldwc)
	lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
	lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
	ldwc.SetTransObject(SQLCA)
	ldwc.setsqlselect(lsNewSql)
	//messagebox("ls newsql", lsnewsql)
	ldwc.Retrieve()
End If
end event

event ue_keydown;//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes

if this.getcolumnname( ) = 'commodity_cd'  then
	tab_main.tabpage_main.uo_commodity_code.uf_set_filter( this.gettext())
end if
end event

event clicked;call super::clicked;
DatawindowChild	ldwc
String	lsWhere,	&
			lsNewSQL

Choose Case Upper(dwo.Name)
		
	Case 'LOC_FROM', 'LOC_TO'
		
		This.GetChild('loc_from',ldwc)
		If ldwc.RowCount() = 0 Then
			If not isnull(isWarehouse) Then
				lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
				lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
				lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
				ldwc.SetTransObject(SQLCA)
				ldwc.setsqlselect(lsNewSql)
				ldwc.Retrieve()
			End If
		End If
	
	//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes 
	Case 'COMMODITY_CD'
		wf_show_hide_data(2) //pass tabpage index
End Choose
end event

event constructor;call super::constructor;
datawindowChild	ldwc


// 07/00 PCONKL - Get the original sql from from location dropdown so we can modify sql and retrieve for current row
This.GetChild('loc_from',ldwc)
isorigsql_loc = ldwc.getsqlselect()

end event

event itemchanged;call super::itemchanged;

// 07/00 PCONKL - If warehouse is entered/changed, retrieve locations for that warehouse
Choose Case dwo.name
		
	// KRZ If the SKU was changed
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
			
		
	Case 'warehouse'
		
		isWareHouse = Data
		//TimA 07/06/12 Pandora #360 Add owner Code to the search
		If Upper(gs_project) = 'PANDORA' then
			idw_avail_inv_search.setitem(1,'owner_code','')
			idw_select.setitem(1,'owner_code','')

			idw_receive_search.setitem(1,'owner_code','')
			idw_delivery_search.setitem(1,'owner_code','')
			
			wf_update_owner_select(idw_Avail_child_owner)
			wf_update_owner_select(idw_All_child_owner)
			wf_update_owner_select(idw_Receive_child_owner)
			wf_update_owner_select(idw_Delivery_child_owner)						
		end if
		//This.PostEvent("ue_retrieve_locs") don't retrieve locations unless clicked on

	Case 'owner_code'
		//TimA 07/09/12 Pandora #360 Update the ower in both tabs
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code',data)
			idw_receive_search.setitem(1,'owner_code',data)
			idw_delivery_search.setitem(1,'owner_code',data)			
			//idw_avail_inv_search.setitem(1,'owner_code',data)
			
		End if

	//07-Apr-2017 Madhu PEVS-517 -Stock Inventory Commodity Codes
	Case 'commodity_cd'
		tab_main.tabpage_avail_inventory.uo_commodity.uf_set_filter( data)
		
End Choose
end event

event process_enter;call super::process_enter;IF This.GetColumnName() = "warehouse" THEN
	iw_window.Trigger Event ue_retrieve()
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

event losefocus;call super::losefocus;accepttext()
end event

type tabpage_serialinventory from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Serial Inventory"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_search_serialinventory dw_search_serialinventory
dw_serialinventory dw_serialinventory
end type

on tabpage_serialinventory.create
this.dw_search_serialinventory=create dw_search_serialinventory
this.dw_serialinventory=create dw_serialinventory
this.Control[]={this.dw_search_serialinventory,&
this.dw_serialinventory}
end on

on tabpage_serialinventory.destroy
destroy(this.dw_search_serialinventory)
destroy(this.dw_serialinventory)
end on

type dw_search_serialinventory from u_dw_ancestor within tabpage_serialinventory
event ue_retrieve_locs ( )
event ue_retreive_locs ( )
integer x = 23
integer y = 32
integer width = 2853
integer height = 188
string dataobject = "d_si_search_serialinventory"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_retreive_locs();String	lsWhere,	&
			lsNewSQL
DatawindowChild	ldwc

If not isnull(isWarehouse) Then
	lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
	This.GetChild("loc_from", ldwc)
	lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
	lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
	ldwc.SetTransObject(SQLCA)
	ldwc.setsqlselect(lsNewSql)
	messagebox("ls newsql", lsnewsql)
	ldwc.Retrieve()
End If
end event

event constructor;call super::constructor;
datawindowChild	ldwc

// 07/00 PCONKL - Get the original sql from from location dropdown so we can modify sql and retrieve for current row
This.GetChild('loc_from',ldwc)
isorigsql_loc = ldwc.getsqlselect()

end event

event clicked;call super::clicked;
DatawindowChild	ldwc
String	lsWhere,	&
			lsNewSQL

Choose Case Upper(dwo.Name)
		
	Case 'LOC_FROM', 'LOC_TO'
		
		This.GetChild('loc_from',ldwc)
		If ldwc.RowCount() = 0 Then
			If not isnull(isWarehouse) Then
				lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
				lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
				lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
				ldwc.SetTransObject(SQLCA)
				ldwc.setsqlselect(lsNewSql)
				ldwc.Retrieve()
			End If
		End If
		
End Choose
end event

event itemchanged;call super::itemchanged;//Jxlim 09/26/2013 Ariens CR-26 Search Criteria to include Warehouse, SKU, Serial Number, Loc (from/To)
//If warehouse is entered/changed, retrieve locations for that warehouse
Choose Case dwo.name
		
	// KRZ If the SKU was changed
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	Case 'warehouse'
		
		isWareHouse = Data
		This.PostEvent("ue_retrieve_locs")
		
End Choose
end event

event losefocus;call super::losefocus;AcceptText()
end event

event process_enter;call super::process_enter;IF This.GetColumnName() = "warehouse" THEN
	iw_window.Trigger Event ue_retrieve()
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

type dw_serialinventory from u_dw_ancestor within tabpage_serialinventory
integer x = 18
integer y = 236
integer width = 4187
integer height = 1424
integer taborder = 20
string dataobject = "d_si_serialinventory"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;call super::ue_retrieve;//Jxlim 09/26/2013 Ariens CR-26 - tackon any search criteria to include Warehouse, SKU, Serial Number, Loc (from/To)

String	lsWhere, ls_warehouse, ls_sku, ls_serial
Integer	liRC

Boolean lb_where
DatawindowChild	ldwc, ldwc2

//Initialize Date Flags
lb_where = False

idw_search_SerialInventory.AcceptTExt()

//always tackon Project...
lsWhere  += " Where Serial_Number_Inventory.Project_Id = '" + gs_project + "'"

//tackon SKU
ls_sku = idw_search_SerialInventory.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Serial_Number_Inventory.SKU like '%" + idw_search_SerialInventory.GetItemString(1,"sku") + "%'  "
	lb_where = TRUE
end if

//tackon Warehouse
ls_warehouse = idw_search_SerialInventory.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += " and Serial_Number_Inventory.wh_code = '" + idw_search_SerialInventory.GetItemString(1,"warehouse") + "'  "
	lb_where = TRUE
end if

//From location
if not isnull(idw_search_SerialInventory.GetItemString(1,"loc_from")) then
	lswhere += " and Serial_Number_Inventory.l_code >= '" + idw_search_SerialInventory.GetItemString(1,"loc_from") + "'  "
	lb_where = TRUE
end if

//To location
if not isnull(idw_search_SerialInventory.GetItemString(1,"loc_to")) then
	lswhere += " and Serial_Number_Inventory.l_code <= '" + idw_search_SerialInventory.GetItemString(1,"loc_to") + "'  "
	lb_where = TRUE
end if

//tackon Serial No
ls_serial = idw_search_SerialInventory.GetItemString(1,"serial_no")
if  not isnull(ls_serial) and trim(ls_serial) <> "" then
	lswhere += " and Serial_Number_Inventory.Serial_no like '%" + idw_search_SerialInventory.GetItemString(1,"serial_no") + "%'  "
	lb_where = TRUE
end if

// 04/14 - PCONKL - Inventory Type
if not isnull(idw_search_SerialInventory.GetItemString(1,"inventory_type")) then
	lswhere += " and Serial_Number_Inventory.inventory_type = '" + idw_search_SerialInventory.GetItemString(1,"inventory_type") + "'  "
	lb_where = TRUE
end if

//Giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

liRC = This.setsqlselect(isorigsql_SerialInventory + lswhere)

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Serial Number records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event sqlpreview;call super::sqlpreview;//
end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)
end event

type tabpage_r_detail from userobject within tab_main
event create ( )
event destroy ( )
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Receiving"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_receive_detail dw_receive_detail
dw_select_receive dw_select_receive
end type

on tabpage_r_detail.create
this.dw_receive_detail=create dw_receive_detail
this.dw_select_receive=create dw_select_receive
this.Control[]={this.dw_receive_detail,&
this.dw_select_receive}
end on

on tabpage_r_detail.destroy
destroy(this.dw_receive_detail)
destroy(this.dw_select_receive)
end on

type dw_receive_detail from u_dw_ancestor within tabpage_r_detail
integer x = 5
integer y = 320
integer width = 4311
integer height = 1392
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_receive"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate
Boolean lb_order_from
Boolean lb_order_to 
Boolean lb_sched_from
Boolean lb_sched_to
Boolean lb_complete_date_from
Boolean lb_complete_date_to
Boolean lb_where

DatawindowChild	ldwc,ldwc2

//Initialize Date Flags
lb_order_from 				= FALSE
lb_order_to 				= FAlSE
lb_sched_from 				= FALSE
lb_sched_to 				= FALSE
lb_complete_date_from 	= FALSE
lb_complete_date_to 		= FALSE

lb_where = False
dw_select_receive.AcceptTExt()

//03/02 - Inventory Type dropdown being retrived by Project- Share with Main DW
idw_main.GetChild('inventory_type',ldwc)
This.GetChild('receive_putaway_inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

//always tackon Project...
lsWhere  += " and receive_master.Project_id = '" + gs_project + "'"

//Tackon BOL Nbr
if  not isnull(dw_select_receive.GetItemString(1,"bol")) then
	lswhere += " and Receive_Master.Supp_Invoice_No like '%" + dw_select_receive.GetItemString(1,"bol") + "%'"
	lb_where = True
end if

//Tackon Order Status
if  not isnull(dw_select_receive.GetItemString(1,"status")) then
	lb_where = True
	lswhere += " and Receive_Master.ord_status = '" + dw_select_receive.GetItemString(1,"status") + "'"
end if

//tackon SKU
ls_sku = dw_select_receive.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lb_where = True
	lswhere += " and Receive_Putaway.SKU like '" + dw_select_receive.GetItemString(1,"sku") + "%'  "
end if

//tackon Warehouse
ls_warehouse = dw_select_receive.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lb_where = True
	lswhere += " and Receive_Master.WH_Code = '" + dw_select_receive.GetItemString(1,"warehouse") + "'  "
end if
//TimA 07/17/12 Pandora issue #360 Add Owner to the search
if not isnull(dw_select_receive.GetItemString(1,"owner_code")) and Trim(dw_select_receive.GetItemString(1,"owner_code")) <> '' then
	//wf_update_owner_select (idw_Receive_child_owner)
	lswhere += " and Owner.Owner_Cd = '" + dw_select_receive.GetItemString(1,"owner_code") + "'  "
	lb_where = TRUE
end if

// 05/09 MEA supp code
if not isnull(dw_select_receive.GetItemString(1,"supp_code")) then
	lswhere += " and Receive_Putaway.supp_code = '" + dw_select_receive.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//tackon From location
//if  not isnull(dw_select_receive.GetItemString(1,"from_loc")) then
if  not isnull(dw_select_receive.GetItemString(1,"loc_from")) then
	lb_where = True
	lswhere += " and Receive_Putaway.l_code >= '" + dw_select_receive.GetItemString(1,"loc_from") + "'  "
//	lswhere += " and Receive_Putaway.l_code >= '" + dw_select_receive.GetItemString(1,"from_loc") + "'  "
end if

//tackon To location
if  not isnull(dw_select_receive.GetItemString(1,"loc_to")) then
//if  not isnull(dw_select_receive.GetItemString(1,"to_loc")) then
	lb_where = True
	lswhere += " and Receive_Putaway.l_code <= '" + dw_select_receive.GetItemString(1,"loc_to") + "'  "
//	lswhere += " and Receive_Putaway.l_code <= '" + dw_select_receive.GetItemString(1,"to_loc") + "'  "
end if

//Tackon From Receive Date
If Date(dw_select_receive.GetItemDateTime(1,"from_date")) > date('01/01/1900 00:00') Then
		lb_where = True
		lsWhere = lsWhere + " and Receive_Master.Arrival_Date >= '" + string(dw_select_receive.GetItemDateTime(1,"from_date"),'mm/dd/yyyy hh:mm') + "'"
	lb_sched_from = TRUE		
End If

//Tackon To Receive Date
If Date(dw_select_receive.GetItemDateTime(1,"to_date")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and Receive_Master.Arrival_Date <= '" + string(dw_select_receive.GetItemDateTime(1,"to_date"),'mm/dd/yyyy hh:mm') + "'"
	lb_sched_to = TRUE		
End If
	
//Tackon From Order Date
If Date(dw_select_receive.GetItemDateTime(1,"order_date_from")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and Receive_Master.ord_Date >= '" + string(dw_select_receive.GetItemDateTime(1,"order_date_from"),'mm/dd/yyyy hh:mm') + "'"
		lb_order_from = TRUE		
		lb_where = True
End If

//Tackon To Order Date
If Date(dw_select_receive.GetItemDateTime(1,"order_date_to")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and Receive_Master.Ord_Date <= '" + string(dw_select_receive.GetItemDateTime(1,"order_date_to"),'mm/dd/yyyy hh:mm') + "'"
	lb_order_to = TRUE
	lb_where = True
End If

//Tackon From Complete Date
If Date(dw_select_receive.GetItemDateTime(1,"complete_date_from")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and Receive_Master.complete_date >= '" + string(dw_select_receive.GetItemDateTime(1,"complete_date_from"),'mm/dd/yyyy hh:mm') + "'"
		lb_complete_date_from = TRUE		
		lb_where = True
End If

//Tackon To Complete Date
If Date(dw_select_receive.GetItemDateTime(1,"complete_date_to")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and Receive_Master.Complete_Date <= '" + string(dw_select_receive.GetItemDateTime(1,"complete_date_to"),'mm/dd/yyyy hh:mm') + "'"
	lb_complete_date_to = TRUE
	lb_where = True
End If


//Check Complete Date range for any errors prior to retrieving
IF 	((lb_complete_date_to = TRUE and lb_complete_date_from = FALSE) 	OR &
		 (lb_complete_date_from = TRUE and lb_complete_date_to = FALSE)  	OR &
		 (lb_complete_date_from = FALSE and lb_complete_date_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Completed Date Range", Stopsign!)
		Return
END IF

//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
		 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
		 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
		Return
END IF

//Check Sched Arrival Date range for any errors prior to retrieving
IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
		 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
		 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Arrival Date Range", Stopsign!)
		Return
END IF
IF dw_select_receive.Getitemstring(1,"status") = "N" THEN	
	lswhere += wf_status_new(dw_select_receive)	
END IF	

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

liRC = This.setsqlselect(isorigsql_receive + lswhere)

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Receiving records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 238
ls_column[2]="receive_putaway_serial_no"
ls_value[2] = "-"
li_width[2] = 270
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 215
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 251
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 265
ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334
i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])
end event

type dw_select_receive from u_dw_ancestor within tabpage_r_detail
event ue_retreive_locs ( )
integer x = 23
integer y = 16
integer width = 4215
integer height = 300
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_search_receive"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_retreive_locs();String	lsWhere,	&
			lsNewSQL
DatawindowChild	ldwc

If not isnull(isWarehouse) Then
	lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
	This.GetChild("loc_from", ldwc)
	lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
	lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
	ldwc.SetTransObject(SQLCA)
	ldwc.setsqlselect(lsNewSql)
	messagebox("ls newsql", lsnewsql)
	ldwc.Retrieve()
End If
end event

event constructor;call super::constructor;ib_rcv_order_from_first 	= TRUE
ib_rcv_order_to_first 		= TRUE
ib_rcv_sched_from_first 	= TRUE
ib_rcv_sched_to_first 		= TRUE
ib_rcv_complete_from_first = TRUE
ib_rcv_complete_to_first	= TRUE

datawindowChild	ldwc

// 07/00 PCONKL - Get the original sql from from location dropdown so we can modify sql and retrieve for current row
This.GetChild('loc_from',ldwc)
isorigsql_loc = ldwc.getsqlselect()
end event

event clicked;call super::clicked;string 	ls_column,	&
			lsWhere,	&
			lsNewSql

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
DatawindowChild	ldwc

dw_select_receive.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_receive.GetRow()

CHOOSE CASE ls_column
		
	CASE " complete_date_from"
		
		IF ib_rcv_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_receive.SetColumn("complete_date_from")
			dw_select_receive.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_date_to"
		
		IF ib_rcv_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_receive.SetColumn("complete_date_to")
			dw_select_receive.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_complete_to_first = FALSE
			
		END IF	
	
CASE "order_date_from"
		
		IF ib_rcv_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_receive.SetColumn("order_date_from")
			dw_select_receive.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_order_from_first = FALSE
			
		END IF
		
	CASE "order_date_to"
		
		IF ib_rcv_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_receive.SetColumn("order_date_to")
			dw_select_receive.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_order_to_first = FALSE
			
		END IF
		
	CASE "from_date"
		
		IF ib_rcv_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_receive.SetColumn("from_date")
			dw_select_receive.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_sched_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_rcv_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_receive.SetColumn("to_date")
			dw_select_receive.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_rcv_sched_to_first = FALSE
			
		END IF
		
	Case 'loc_from', 'loc_to'
		//TimA 09/10/15 this was the only dddw that was different that all the others.  Made this one the same as the other dddw's for loc from and loc To.
		
		//	Case 'from_loc', 'to_loc'
				
		//		This.GetChild('loc_from',ldwc)
		////		This.GetChild('from_loc',ldwc)
		//		If ldwc.RowCount() = 0 Then
		//			If not isnull(This.getItemString(row,'warehouse')) Then
		//				lsWhere = " Where (wh_code = '" + This.getItemString(row,'warehouse') + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
		//				lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
		//				lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,This.getItemString(row,'warehouse')) /*replace dummy warehouse*/
		//				ldwc.SetTransObject(SQLCA)
		//				ldwc.setsqlselect(lsNewSql)
		//				ldwc.Retrieve()
		//
		//			End If
		//		End If
		This.GetChild('loc_from',ldwc )
		If ldwc.RowCount() = 0 Then
			If not isnull(isWarehouse) Then
				lsWhere = " Where (wh_code = '" + isWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
				lsNewSql = replace(isorigsql_loc,pos(isorigsql_loc,'ZZZZZ'),5,gs_project) /*replace dummy project*/
				lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,isWarehouse) /*replace dummy warehouse*/
				ldwc.SetTransObject(SQLCA)
				ldwc.setsqlselect(lsNewSql)
				ldwc.Retrieve()
			End If
		End If	
		
	CASE ELSE
		
END CHOOSE

end event

event itemchanged;call super::itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		//TimA 07/06/12 Pandora #360 Add owner Code to the search
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code','')
			idw_avail_inv_search.setitem(1,'owner_code','')
			idw_receive_search.setitem(1,'owner_code','')
			idw_delivery_search.setitem(1,'owner_code','')
				
			
			wf_update_owner_select(idw_All_child_owner)
			wf_update_owner_select(idw_Avail_child_owner)
			wf_update_owner_select(idw_Receive_child_owner)
			wf_update_owner_select(idw_Delivery_child_owner)			
		End if
			//This.PostEvent("ue_retrieve_locs") don't retrieve locations unless clicked on
	Case 'owner_code'
		//TimA 07/09/12 Pandora #360 Update the ower in both tabs
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code',data)
			idw_avail_inv_search.setitem(1,'owner_code',data)
			//idw_Receive_child_owner.setitem(1,'owner_code',data)
			idw_delivery_search.setitem(1,'owner_code',data)
		End if		
// End what item was changed.
End Choose
end event

event losefocus;call super::losefocus;accepttext()
end event

type tabpage_d_detail from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Delivery~r~n"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_d_detail dw_d_detail
dw_select_delivery dw_select_delivery
end type

on tabpage_d_detail.create
this.dw_d_detail=create dw_d_detail
this.dw_select_delivery=create dw_select_delivery
this.Control[]={this.dw_d_detail,&
this.dw_select_delivery}
end on

on tabpage_d_detail.destroy
destroy(this.dw_d_detail)
destroy(this.dw_select_delivery)
end on

type dw_d_detail from u_dw_ancestor within tabpage_d_detail
integer x = 5
integer y = 364
integer width = 4320
integer height = 1456
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_delivery"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate
Boolean lb_order_from
Boolean lb_order_to 
Boolean lb_sched_from
Boolean lb_sched_to
Boolean lb_complete_date_from
Boolean lb_complete_date_to
Boolean lb_where
DatawindowChild	ldwc, ldwc2

//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_where = False

dw_select_delivery.AcceptTExt()

//03/02 - Inventory Type dropdown being retrived by Project- Share with Main DW
idw_main.GetChild('inventory_type',ldwc)
This.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

//always tackon Project...
lsWhere  += " and delivery_master.Project_id = '" + gs_project + "'"

//tackon SKU
ls_sku = dw_select_delivery.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Delivery_Picking.SKU like '" + dw_select_delivery.GetItemString(1,"sku") + "%'  "
	lb_where = True
end if

//tackon Warehouse
ls_warehouse = dw_select_delivery.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += " and Delivery_Master.WH_Code = '" + dw_select_delivery.GetItemString(1,"warehouse") + "'  "
	lb_where = True
end if

//TimA 07/17/12 Pandora issue #360 Add Owner to the search
if not isnull(dw_select_delivery.GetItemString(1,"owner_code")) and Trim(dw_select_delivery.GetItemString(1,"owner_code")) <> '' then
	//wf_update_owner_select (idw_Delivery_child_owner)
	lswhere += " and Owner.Owner_Cd = '" + dw_select_delivery.GetItemString(1,"owner_code") + "'  "
	lb_where = TRUE
end if

// 05/09 MEA supp code
if not isnull(dw_select_delivery.GetItemString(1,"supp_code")) then
	lswhere += " and Delivery_Picking.supp_code = '" + dw_select_delivery.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//tackon BOL Nbr
if  not isnull(dw_select_delivery.GetItemString(1,"bol_nbr")) then
	lswhere += " and Delivery_Master.invoice_no like '%" + dw_select_delivery.GetItemString(1,"bol_nbr") + "%'  "
	lb_where = True	
end if

//Tackon From Order Date
If Date(dw_select_delivery.GetItemDateTime(1,"from_date")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and Delivery_Master.Ord_Date >= '" + string(dw_select_delivery.GetItemDateTime(1,"from_date"),'mm/dd/yyyy hh:mm') + "'"
		lb_order_from = TRUE
		lb_where = True
End If

//Tackon To order Date 
If Date(dw_select_delivery.GetItemDateTime(1,"to_date")) > date('01/01/1900') Then
	lsWhere = lsWhere + " and Delivery_Master.Ord_Date <= '" + string(dw_select_delivery.GetItemDateTime(1,"to_date"),'mm/dd/yyyy hh:mm') + "'"
	lb_order_to = TRUE
	lb_where = True
End If
	
//Tackon From Sched Date
If Date(dw_select_delivery.GetItemDateTime(1,"Sched_date_from")) > date('01/01/1900') Then
		lsWhere = lsWhere + " and Delivery_Master.schedule_Date >= '" + string(dw_select_delivery.GetItemDateTime(1,"sched_date_from"),'mm/dd/yyyy hh:mm') + "'"
		lb_sched_from = TRUE
		lb_where = True
End If

//Tackon To Sched Date 
If Date(dw_select_delivery.GetItemDateTime(1,"sched_date_to")) > date('01/01/1900') Then
	lsWhere = lsWhere + " and Delivery_Master.schedule_Date <= '" + string(dw_select_delivery.GetItemDateTime(1,"sched_date_to"),'mm/dd/yyyy hh:mm') + "'"
	lb_sched_to = TRUE
	lb_where = True
End If

//Tackon From Complete Date
//If Date(dw_select_delivery.GetItemDateTime(1,"complete_date_from")) > date('01/01/1900') Then
//		lsWhere = lsWhere + " and Delivery_Master.complete_Date >= '" + string(dw_select_delivery.GetItemDateTime(1,"complete_date_from"),'mm/dd/yyyy hh:mm') + "'"
//		lb_complete_date_from = TRUE
//		lb_where = True
//End If

//Tackon To Complete Date 
//If Date(dw_select_delivery.GetItemDateTime(1,"complete_date_to")) > date('01/01/1900') Then
//	lsWhere = lsWhere + " and Delivery_Master.complete_Date <= '" + string(dw_select_delivery.GetItemDateTime(1,"complete_date_to"),'mm/dd/yyyy hh:mm') + "'"
//	lb_complete_date_to = TRUE
//	lb_where = True
//End If

//tackon Order Status
if  not isnull(dw_select_delivery.GetItemString(1,"status")) then
	lswhere += " and Delivery_Master.Ord_Status = '" + dw_select_delivery.GetItemString(1,"status") + "'  "
	lb_where = True
end if
	
//tackon Customer Order
if  not isnull(dw_select_delivery.GetItemString(1,"customer_order")) then
	lswhere += " and Delivery_Master.Cust_Order_No = '" + dw_select_delivery.GetItemString(1,"customer_order") + "'  "
	lb_where = True
end if

//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
		 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
		 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
		Return
END IF

//Check Sched Arrival Date range for any errors prior to retrieving
IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
		 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
		 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Arrival Date Range", Stopsign!)
		Return
END IF

//Check Sched Arrival Date range for any errors prior to retrieving
IF 	((lb_complete_date_to = TRUE and lb_complete_date_from = FALSE) 	OR &
		 (lb_complete_date_from = TRUE and lb_complete_date_to = FALSE)  	OR &
		 (lb_complete_date_from = FALSE and lb_complete_date_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Completed Date Range", Stopsign!)
		Return
END IF

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

liRC = This.setsqlselect(isorigsql_delivery + lswhere)

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Delivery records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event constructor;call super::constructor; ib_filter = true
 wf_owner_ind(this)
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 238
ls_column[2]="serial_no"
ls_value[2] = "-"
li_width[2] = 270
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 215
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 251
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 265
ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334
//ls_column[10]="wip_qty"
//ls_value[10] = "0"
//ls_column[11]="tfr_in"
//ls_value[11] = "0"
//ls_column[12]="tfr_out"
//ls_value[12] = "0"
i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])
end event

type dw_select_delivery from u_dw_ancestor within tabpage_d_detail
integer y = 4
integer width = 4329
integer height = 320
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_search_delivery"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select_delivery.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_delivery.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_date"
		
		IF ib_dlv_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_delivery.SetColumn("from_date")
			dw_select_delivery.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_order_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_dlv_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_delivery.SetColumn("to_date")
			dw_select_delivery.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_order_to_first = FALSE
			
		END IF
		
	CASE "sched_date_from"
		
		IF ib_dlv_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_delivery.SetColumn("sched_date_from")
			dw_select_delivery.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_sched_from_first = FALSE
			
		END IF
		
	CASE "sched_date_to"
		
		IF ib_dlv_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_delivery.SetColumn("sched_date_to")
			dw_select_delivery.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_sched_to_first = FALSE
			
		END IF
		
	CASE "complete_date_from"
		
		IF ib_dlv_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_delivery.SetColumn("complete_date_from")
			dw_select_delivery.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_date_to"
		
		IF ib_dlv_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_delivery.SetColumn("complete_date_to")
			dw_select_delivery.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_dlv_complete_to_first = FALSE
			
		END IF
			
	CASE ELSE
		
END CHOOSE

end event

event constructor;call super::constructor;ib_dlv_order_from_first 		= TRUE
ib_dlv_order_to_first 			= TRUE
ib_dlv_sched_from_first 		= TRUE
ib_dlv_sched_to_first 			= TRUE
ib_dlv_complete_from_first 	= TRUE
ib_dlv_complete_to_first 		= TRUE
end event

event itemchanged;call super::itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		//TimA 07/06/12 Pandora #360 Add owner Code to the search
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code','')
			idw_avail_inv_search.setitem(1,'owner_code','')
			idw_receive_search.setitem(1,'owner_code','')
			idw_delivery_search.setitem(1,'owner_code','')
			
			wf_update_owner_select(idw_All_child_owner)
			wf_update_owner_select(idw_Avail_child_owner)
			wf_update_owner_select(idw_Receive_child_owner)
			wf_update_owner_select(idw_Delivery_child_owner)			
		End if
			//This.PostEvent("ue_retrieve_locs") don't retrieve locations unless clicked on
	Case 'owner_code'
		//TimA 07/09/12 Pandora #360 Update the ower in both tabs
		If Upper(gs_project) = 'PANDORA' then
			idw_select.setitem(1,'owner_code',data)
			idw_avail_inv_search.setitem(1,'owner_code',data)
			idw_receive_search.setitem(1,'owner_code',data)
			//idw_delivery.setitem(1,'owner_code',data)
		End if				
// End what item was changed.
End Choose
end event

event losefocus;call super::losefocus;accepttext()
end event

type tabpage_t_detail from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Transfer"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_t_detail dw_t_detail
dw_select_transfer dw_select_transfer
end type

on tabpage_t_detail.create
this.dw_t_detail=create dw_t_detail
this.dw_select_transfer=create dw_select_transfer
this.Control[]={this.dw_t_detail,&
this.dw_select_transfer}
end on

on tabpage_t_detail.destroy
destroy(this.dw_t_detail)
destroy(this.dw_select_transfer)
end on

type dw_t_detail from u_dw_ancestor within tabpage_t_detail
integer y = 188
integer width = 4315
integer height = 1532
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_transfer"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate

Boolean lb_order_from
Boolean lb_order_to 
Boolean lb_where
DatawindowChild	ldwc, ldwc2

//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_where = False

dw_select_transfer.AcceptTExt()

//03/02 - Inventory Type dropdown being retrived by Project- Share with Main DW
idw_main.GetChild('inventory_type',ldwc)
This.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

//always tackon Project...
lsWhere  += " and transfer_master.Project_id = '" + gs_project + "'"

////tackon SKU
if  not isnull(isSku) and trim(isSku) <> "" then
//	lswhere += " and Transfer_Detail_Content.SKU like '%" + dw_select_transfer.GetItemString(1,"sku") + "%'  "
	lswhere += " and Transfer_Detail_Content.SKU like '%" + trim(isSku) + "%'  "
	lb_where = True
end if

//tackon Order
//if  not isnull(idw_avail_inv_search.GetItemString(1,"order")) then
if  not isnull(dw_select_transfer.GetItemString(1,"order")) then
	lswhere += " and Transfer_Detail_Content.TO_No = '" + dw_select_transfer.GetItemString(1,"order") + "'  "
	lb_where = True
end if

////tackon Warehouse
//ls_warehouse = idw_avail_inv_search.GetItemString(1,"warehouse")
if  not isnull(isWarehouse) and trim(isWarehouse) <> "" then
//	lswhere += "  and ( Transfer_Master.S_Warehouse = '" + dw_select_transfer.GetItemString(1,"warehouse") + "'  "
//	lswhere += " Or Transfer_Master.D_Warehouse = '" + dw_select_transfer.GetItemString(1,"warehouse") + "' ) "
	lswhere += "  and ( Transfer_Master.S_Warehouse = '" + trim(isWarehouse) + "'  "
	lswhere += " Or Transfer_Master.D_Warehouse = '" + trim(isWarehouse) + "' ) "
	lb_where = True
end if

// 05/09 MEA supp code
if not isnull(dw_select_transfer.GetItemString(1,"supp_code")) then
	lswhere += " and Transfer_Detail_Content.supp_code = '" + dw_select_transfer.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//Tackon From Date
If Date(dw_select_transfer.GetItemDateTime(1,"from_date")) > date('01/01/1900 00:00') Then
		lsWhere = lsWhere + " and Transfer_Master.Complete_Date >= '" + string(dw_select_transfer.GetItemDateTime(1,"from_date"),'mm/dd/yyyy hh:mm') + "'"
		lb_order_from = TRUE
		lb_where = True
End If

//Tackon To Date 
If Date(dw_select_transfer.GetItemDateTime(1,"to_date")) > date('01/01/1900 00:00') Then
	lsWhere = lsWhere + " and Transfer_Master.Complete_Date <= '" + string(dw_select_transfer.GetItemDateTime(1,"to_date"),'mm/dd/yyyy hh:mm') + "'"
	lb_order_to = TRUE
	lb_where = True
End If

//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
		 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
		 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
		Return
END IF
	
liRC = This.setsqlselect(isorigsql_transfer + lswhere)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Transfer records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event constructor;call super::constructor;ib_filter = true
 wf_owner_ind(this)
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 238
ls_column[2]="transfer_detail_content_serial_no"
ls_value[2] = "-"
li_width[2] = 270
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 215
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 251
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 265
ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334

i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])
end event

event sqlpreview;call super::sqlpreview;string ls_syntax

ls_syntax = ls_syntax
end event

type dw_select_transfer from datawindow within tabpage_t_detail
integer x = 32
integer y = 12
integer width = 3131
integer height = 160
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_si_search_transfer"
boolean border = false
boolean livescroll = true
end type

event constructor;ib_trn_order_from_first 	= TRUE
ib_trn_order_to_first 		= TRUE
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select_transfer.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_transfer.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_date"
		
		IF ib_trn_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_transfer.SetColumn("from_date")
			dw_select_transfer.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_trn_order_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_trn_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_transfer.SetColumn("to_date")
			dw_select_transfer.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_trn_order_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

event itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;accepttext()
end event

type tabpage_pick from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Pick~r~n"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pick_detail dw_pick_detail
dw_select_pick dw_select_pick
end type

on tabpage_pick.create
this.dw_pick_detail=create dw_pick_detail
this.dw_select_pick=create dw_select_pick
this.Control[]={this.dw_pick_detail,&
this.dw_select_pick}
end on

on tabpage_pick.destroy
destroy(this.dw_pick_detail)
destroy(this.dw_select_pick)
end on

type dw_pick_detail from u_dw_ancestor within tabpage_pick
integer y = 240
integer width = 4283
integer height = 1488
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_pick"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate
Boolean lb_pick_from
Boolean lb_pick_to 
Boolean lb_where
DatawindowChild	ldwc, ldwc2

//Initialize Date Flags
lb_pick_from 		= FALSE
lb_pick_to 		= FAlSE
lb_where = False
dw_select_pick.AcceptTExt()

//03/02 - Inventory Type dropdown being retrived by Project- Share with Main DW
idw_main.GetChild('inventory_type',ldwc)
This.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

//always tackon Project...
lsWhere  += " and delivery_master.Project_id = '" + gs_project + "'"

//tackon BOL
if  not isnull(dw_select_pick.GetItemString(1,"bol")) then
	lswhere += " and Delivery_Master.Invoice_No Like '%" + dw_select_pick.GetItemString(1,"bol") + "%'  "
	lb_where = True
end if

//tackon SKU
ls_sku = dw_select_pick.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Delivery_Picking.SKU like '%" + dw_select_pick.GetItemString(1,"sku") + "%'  "
	lb_where = True
end if

//tackon Warehouse
ls_warehouse = dw_select_pick.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += "  and Delivery_Master.WH_Code = '" + dw_select_pick.GetItemString(1,"warehouse") + "'  "
	lb_where = True
end if

// 05/09 MEA supp code
if not isnull(dw_select_pick.GetItemString(1,"supp_code")) then
	lswhere += " and Delivery_Picking.supp_code = '" + dw_select_pick.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

// 12/11 MEA alt_sku
if not isnull(dw_select_pick.GetItemString(1,"alt_sku")) then
	lswhere += " and Item_Master.alternate_sku = '" + dw_select_pick.GetItemString(1,"alt_sku") + "'  "
	lb_where = TRUE
end if

//Tackon From Date
If Date(dw_select_pick.GetItemDateTime(1,"from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and Delivery_Master.Pick_Start >= '" + string(dw_select_pick.GetItemDateTime(1,"from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_pick_from = TRUE
End If

//Tackon To Date
If Date(dw_select_pick.GetItemDateTime(1,"to_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and Delivery_Master.Pick_Start <= '" + string(dw_select_pick.GetItemDateTime(1,"to_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_pick_to = TRUE
End If

//Check Pick Order Date range for any errors prior to retrieving
IF 	((lb_pick_to = TRUE and lb_pick_from = FALSE) 	OR &
		 (lb_pick_from = TRUE and lb_pick_to = FALSE)  	OR &
		 (lb_pick_from = FALSE and lb_pick_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Pick Start Date Range", Stopsign!)
		Return
END IF

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	

liRC = This.setsqlselect(isorigsql_pick + lswhere)


If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Picking records were found matching your search criteria!")
Else
	This.Setfocus()
End If


end event

event constructor;call super::constructor; ib_filter = true
 wf_owner_ind(this)
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 238
ls_column[2]="delivery_picking_serial_no"
ls_value[2] = "-"
li_width[2] = 270
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 215
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 251
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 265
ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334
i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])
end event

type dw_select_pick from datawindow within tabpage_pick
integer y = 4
integer width = 3017
integer height = 236
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_si_search_pick"
boolean border = false
boolean livescroll = true
end type

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select_pick.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_pick.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_date"
		
		IF ib_pick_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_pick.SetColumn("from_date")
			dw_select_pick.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_pick_order_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_pick_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_pick.SetColumn("to_date")
			dw_select_pick.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_pick_order_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

event constructor;ib_pick_order_from_first 	= TRUE
ib_pick_order_to_first 		= TRUE
end event

event itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;accepttext()
end event

type tabpage_pack from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Pack~r~n"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_select_pack dw_select_pack
dw_pack_detail dw_pack_detail
end type

on tabpage_pack.create
this.dw_select_pack=create dw_select_pack
this.dw_pack_detail=create dw_pack_detail
this.Control[]={this.dw_select_pack,&
this.dw_pack_detail}
end on

on tabpage_pack.destroy
destroy(this.dw_select_pack)
destroy(this.dw_pack_detail)
end on

type dw_select_pack from datawindow within tabpage_pack
integer y = 4
integer width = 3127
integer height = 148
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_search_pack"
boolean border = false
boolean livescroll = true
end type

event constructor;ib_pack_order_from_first 		= TRUE
ib_pack_order_to_first 		= TRUE
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select_pack.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_pack.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_date"
		
		IF ib_pack_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_pack.SetColumn("from_date")
			dw_select_pack.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_pack_order_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_pack_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_pack.SetColumn("to_date")
			dw_select_pack.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_pack_order_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

event itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;accepttext()
end event

type dw_pack_detail from u_dw_ancestor within tabpage_pack
integer y = 172
integer width = 3511
integer height = 1536
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_pack"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate

Boolean lb_pack_from
Boolean lb_pack_to 
Boolean lb_where

//Initialize Date Flags
lb_pack_from 		= FALSE
lb_pack_to 		= FAlSE
lb_where = False
dw_select_pack.AcceptTExt()

//always tackon Project...
lsWhere  += " and delivery_master.Project_id = '" + gs_project + "'"

//tackon BOL
if  not isnull(dw_select_pack.GetItemString(1,"bol")) then
	lswhere += " and Delivery_Master.Invoice_No Like '%" + dw_select_pack.GetItemString(1,"bol") + "%'  "
	lb_where = True
end if

//tackon SKU
ls_sku = dw_select_pack.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and Delivery_packing.SKU like '%" + dw_select_pack.GetItemString(1,"sku") + "%'  "
	lb_where = True
end if

//tackon Warehouse
ls_warehouse = dw_select_pack.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += "  and Delivery_Master.WH_Code = '" + dw_select_pack.GetItemString(1,"warehouse") + "'  "
	lb_where = True
end if

// 05/09 MEA supp code
if not isnull(dw_select_pack.GetItemString(1,"supp_code")) then
	lswhere += " and Delivery_Packing.supp_code = '" + dw_select_pack.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//Tackon From Date
If dw_select_pack.GetItemDateTime(1,"from_date") > datetime('01-01-1900 00:00') Then
		lsWhere = lsWhere + " and Delivery_Master.Pick_Start >= '" + string(dw_select_pack.GetItemDatetime(1,"from_date"),'mm/dd/yyyy hh:mm') + "'"
		lb_pack_from = TRUE
		lb_where = True
End If

//Tackon To Date - bump by 1 and check for less than to account for time
If dw_select_pack.GetItemDatetime(1,"to_date") > datetime('01-01-1900 00:00') Then
		//ldToDate = relativeDate(dw_select_pack.GetItemDate(1,"to_date"),1)
		lsWhere = lsWhere + " and Delivery_Master.Pick_Start < '" + string(dw_select_pack.GetItemDateTime(1,"to_date"),'mm/dd/yyyy hh:mm') + "'"
		lb_pack_to = TRUE
		lb_where = True
End If

//Check pack Order Date range for any errors prior to retrieving
IF 	((lb_pack_to = TRUE and lb_pack_from = FALSE) 	OR &
		 (lb_pack_from = TRUE and lb_pack_to = FALSE)  	OR &
		 (lb_pack_from = FALSE and lb_pack_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Pack Start Date Range", Stopsign!)
		Return
END IF

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF
	
	
liRC = This.setsqlselect(isorigsql_pack + lswhere)

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No packing records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event constructor;call super::constructor;ib_filter = true
end event

type tabpage_adjustment from userobject within tab_main
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Adjustments"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_select_adjust dw_select_adjust
dw_adjust dw_adjust
end type

on tabpage_adjustment.create
this.dw_select_adjust=create dw_select_adjust
this.dw_adjust=create dw_adjust
this.Control[]={this.dw_select_adjust,&
this.dw_adjust}
end on

on tabpage_adjustment.destroy
destroy(this.dw_select_adjust)
destroy(this.dw_adjust)
end on

type dw_select_adjust from datawindow within tabpage_adjustment
integer y = 12
integer width = 2930
integer height = 188
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_si_search_adjust"
boolean border = false
boolean livescroll = true
end type

event constructor;ib_adj_order_from_first 		= TRUE
ib_adj_order_to_first 		= TRUE
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select_adjust.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select_adjust.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_date"
		
		IF ib_adj_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select_adjust.SetColumn("from_date")
			dw_select_adjust.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_adj_order_from_first = FALSE
			
		END IF
		
	CASE "to_date"
		
		IF ib_adj_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select_adjust.SetColumn("to_date")
			dw_select_adjust.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_adj_order_to_first = FALSE
			
		END IF
		
			
	CASE ELSE
		
END CHOOSE

end event

event itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
		isSku = data
		
	// Warehouse
	Case 'warehouse'
		
		// Capture the warehouse ID.
		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;accepttext()
end event

type dw_adjust from u_dw_ancestor within tabpage_adjustment
integer x = 9
integer y = 192
integer width = 4302
integer height = 1500
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_si_adjust"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;// 05/00 PCONKL - tackon any search criteria and retrieve

String	lsWhere, ls_warehouse, ls_sku
Integer	liRC
Date		ldToDate

Boolean lb_adj_from
Boolean lb_adj_to 
Boolean lb_where
DatawindowChild	ldwc, ldwc2

//Initialize Date Flags
lb_adj_from 		= FALSE
lb_adj_to 		= FAlSE
lb_where = False
dw_select_adjust.AcceptTExt()

//03/02 - Inventory Type dropdown being retrived by Project- Share with Main DW
idw_main.GetChild('inventory_type',ldwc)
This.GetChild('inventory_type',ldwc2)
ldwc.ShareData(ldwc2)

//always tackon Project...
lsWhere  += " Where adjustment.Project_id = '" + gs_project + "'"
lsWhere  += " and adjustment.owner_id = owner.owner_id "

//tackon SKU
ls_sku = dw_select_adjust.GetItemString(1,"sku")
if  not isnull(ls_sku) and trim(ls_sku) <> "" then
	lswhere += " and adjustment.SKU like '%" + dw_select_adjust.GetItemString(1,"sku") + "%'  "
	lb_where = TRUE
end if

//tackon Warehouse
ls_warehouse = dw_select_adjust.GetItemString(1,"warehouse")
if  not isnull(ls_warehouse) and trim(ls_warehouse) <> "" then
	lswhere += " and adjustment.wh_code = '" + dw_select_adjust.GetItemString(1,"warehouse") + "'  "
	lb_where = TRUE
end if

// 05/09 MEA supp code
if not isnull(dw_select_adjust.GetItemString(1,"supp_code")) then
	lswhere += " and adjustment.supp_code = '" + dw_select_adjust.GetItemString(1,"supp_code") + "'  "
	lb_where = TRUE
end if

//BCR 10-JUN-2011: Filter out Child Components
lswhere += " and Adjustment.Inventory_Type <> '8'  "
lb_where = TRUE
//********************************************

//Tackon From Date
If Date(dw_select_adjust.GetItemDateTime(1,"from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and adjustment.last_update >= '" + string(dw_select_adjust.GetItemDateTime(1,"from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_adj_from = TRUE
		lb_where = TRUE
End If

//Tackon To Date 
If Date(dw_select_adjust.GetItemDateTime(1,"to_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and adjustment.last_update <= '" + string(dw_select_adjust.GetItemDateTime(1,"to_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_adj_to = TRUE
	lb_where = TRUE
End If

//Check Adjustment Order Date range for any errors prior to retrieving
IF 	((lb_adj_to = TRUE and lb_adj_from = FALSE) 	OR &
		 (lb_adj_from = TRUE and lb_adj_to = FALSE)  	OR &
		 (lb_adj_from = FALSE and lb_adj_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Adjustment Date Range", Stopsign!)
		Return
END IF

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

liRC = This.setsqlselect(isorigsql_adjust + lswhere)

If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Adjustment records were found matching your search criteria!")
Else
	This.Setfocus()
End If

end event

event constructor;call super::constructor;ib_filter = true
wf_owner_ind(this)
end event

event retrieveend;call super::retrieveend;String ls_column[],ls_value[]
Integer li_width[]
dwitemstatus l_item
ls_column[1]="lot_no"
ls_value[1] = "-"
li_width[1] = 238
ls_column[2]="serial_no"
ls_value[2] = "-"
li_width[2] = 270
ls_column[3]="po_no"
ls_value[3] = "-"
li_width[3] = 215
ls_column[4]="po_no2"
ls_value[4] = "-"
li_width[4] = 251
ls_column[5]="container_id"
ls_value[5] = "-"
li_width[5] = 265
ls_column[6]="expiration_date"
ls_value[6] = '12/31/2999'
li_width[6] = 334
i_nwarehouse.of_width_set(this,ls_column[],ls_value[],li_width[])
end event

type tabpage_kits from userobject within tab_main
string tag = "Kits"
integer x = 18
integer y = 192
integer width = 4325
integer height = 1852
long backcolor = 79741120
string text = "Kits"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_si_kits dw_si_kits
dw_kits dw_kits
end type

on tabpage_kits.create
this.dw_si_kits=create dw_si_kits
this.dw_kits=create dw_kits
this.Control[]={this.dw_si_kits,&
this.dw_kits}
end on

on tabpage_kits.destroy
destroy(this.dw_si_kits)
destroy(this.dw_kits)
end on

type dw_si_kits from datawindow within tabpage_kits
event ue_retrieve ( )
integer x = 5
integer y = 196
integer width = 4315
integer height = 1648
integer taborder = 30
string title = "none"
string dataobject = "d_stock_inquiry_content_kit"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_retrieve();string lswhere,ls_sku,ls_warehouse,lsorder
boolean lb_where
int liRC,ll_row
//Begin -  Dinesh - Kits new tab stock inquiry
//lsWhere  += " and delivery_master.Project_id = '" + gs_project + "'"

//lsWhere  += " 
idw_kits.AcceptTExt()
idw_kits.setfocus()
//ls_sku=tab_main.tabpage_kits.sle_sku.text
//idw_kits.settrans(sqlca)
//idw_kits.Retrieve()
//ls_sku = dw_kits.GetItemString(1,"sku")
//ls_sku='FO'
//messagebox('',isSku)
if  not isnull(isSku) and trim(isSku) <> "" then
	lsWhere += "where m.project_id='" + gs_project + "'" + " and c.component_no in (select component_no from content_summary where project_id= '"+ gs_project +"'"+ " and SKU ='" + isSku + "'" + ")" 
	lb_where = True
end if



//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	


integer li_union_pos
string lsNewSQL

// Added Union for Works Orders

li_union_pos = Pos(Upper( isorigsql_kits), "UNION ALL")

lsNewSQL = left( isorigsql_kits, li_union_pos -1) + lswhere + " " +  mid ( isorigsql_kits, li_union_pos)

lsorder += " order by c.component_no,l_code,Avail_Qty desc"
string ls_sql
ls_sql= lsNewSQL + lswhere +lsorder


This.settrans(sqlca)
liRC = This.setsqlselect(ls_sql)


If This.Retrieve() <= 0 Then
	MessageBox(is_title, "No Kits records were found matching your search criteria!")
Else
	This.Setfocus()
End If

//End -  Dinesh - Kits new tab stock inquiry

end event

type dw_kits from datawindow within tabpage_kits
integer y = 56
integer width = 1120
integer height = 120
integer taborder = 30
string title = "none"
string dataobject = "d_si_search_kit"
boolean border = false
boolean livescroll = true
end type

event itemchanged;// KRZ What item was changed?
Choose Case dwo.name
		
	// SKU
	Case 'sku'
		
		// Capture the SKU.
	
		isSku = data
	
		
	// Warehouse
//	Case 'warehouse'
//		
//		// Capture the warehouse ID.
//		isWareHouse = Data
		
// End what item was changed.
End Choose
end event

event losefocus;accepttext()
end event

event clicked;accepttext()
end event

