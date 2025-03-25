HA$PBExportHeader$w_3com_outbound_order.srw
$PBExportComments$OutBound Order Report (GAP - 8/02)
forward
global type w_3com_outbound_order from w_std_report
end type
type uo_order_status_search from uo_multi_select_search within w_3com_outbound_order
end type
end forward

global type w_3com_outbound_order from w_std_report
integer width = 3566
integer height = 2100
string title = "Outbound Order"
uo_order_status_search uo_order_status_search
end type
global w_3com_outbound_order w_3com_outbound_order

type variables
string 			is_origsql
string       	is_warehouse_code
string  			is_warehouse_name
string       	is_ord_type
string  			is_ord_type_desc
string       	is_ord_status
string  			is_ord_status_desc
datastore 		ids_find_warehouse
datastore 		ids_find_ord_type
DataWindowChild idwc_warehouse
boolean 			ib_first_time
boolean 			ib_movement_from_first
boolean 			ib_movement_to_first
boolean 			ib_movement_fromComp_first
boolean 			ib_movement_toComp_first
end variables

on w_3com_outbound_order.create
int iCurrent
call super::create
this.uo_order_status_search=create uo_order_status_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_order_status_search
end on

on w_3com_outbound_order.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_order_status_search)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-450)
end event

event ue_retrieve;String 	ls_Where, 				&
 			ls_warehouse, 			&
 			ls_warehouse_name, 	&
 			ls_NewSql, 				&
 			ls_selection, 			&
 			ls_value, 				&
 			ls_whcode, 				&
 			ls_order_status,     &
			ls_owner_id,         &
			ls_OrigSql,          &
         ls_owner,            &
			ls_Lcode
integer 	li_y

Long 		ll_balance, 			& 
			i, 						& 
			ll_row, 					&
			ll_cnt, 					& 
			ll_find_row,         &
			ll_insert_row,ll_rowc,ll_rc,ll_childqty,ll_ownerid
			
boolean 	lb_where

DateTime ldt_s, ldt_e

String ls_projectid,ls_dono,ls_whname,ls_invoiceno,ls_ordstatus,ls_ordtype,ls_custname,ls_custorderno,ls_carrier,ls_deliverynote,ls_sku,ls_skup,ls_pcomponentind,ls_icomponentind
Datetime		ldt_notifieddate
Long	ld_lineitemno,ld_reqqty,ld_allocqty,ld_pickingqty,ld_ownerid


Datastore lds_detail
Datastore lds_component

lds_detail= create datastore
lds_detail.dataobject = 'd_3com_outbound_detail'
lds_detail.settransobject(sqlca)

lds_component= create datastore
lds_component.dataobject = 'd_3com_component'
lds_component.settransobject(sqlca)

ls_OrigSql = lds_detail.GetSQLSelect()


If dw_select.AcceptText() = -1 Then Return
lb_where = false

SetPointer(HourGlass!)
dw_report.Reset()

is_warehouse_code = dw_select.GetItemString(1, "wh_name")
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
ELSE
	

	// Always tackon  Project id and warehouse
	ls_Where = ls_Where + " and delivery_master.Project_id = '" + gs_project + "'"
	ls_Where = ls_Where + " and delivery_master.WH_Code = '" + is_warehouse_code + "'"
	
	if dw_select.GetItemString(1, "owner")<>"" then
	     ls_owner = dw_select.GetItemString(1, "owner")
	 select owner_id into :ll_ownerid from owner where owner_cd = :ls_owner;
	
	 if  isnull(ll_ownerid) or string(ll_ownerid) = "" then
		messagebox("Error","The owner name is wrong,Pls enter again")
		return
	 else
		ls_Where = ls_Where + " and delivery_picking.owner_id = '" + String(ll_ownerid) + " and delivery_master.ord_status <>'N'"
	 end if
	
	
   end if
	
	
	// 7/02 GAP - tackon  Order Type
	If dw_select.GetItemString(1, "ord_type") <> "" Then
		ls_Where = ls_Where + " and delivery_master.Ord_Type = '" + Left(dw_select.GetItemString(1, "ord_type"),1) + "'"
		lb_where = True
	end if
	
	// 7/02 GAP -  tackon  Order Status
//	If dw_select.GetItemString(1, "ord_status") <> "" Then

	ls_order_status = uo_order_status_search.uf_build_search(true)	

	
	if ls_order_status > "" then	
		
		ls_where = ls_where + ls_order_status

		lb_where = True
	end if
	
	//Tackon From Order Date
	If date(dw_select.GetItemDateTime(1, "ord_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "ord_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "ord_date_from")
		lb_where = True
	End If
	
	//Tackon To Order Date
	If date(dw_select.GetItemDateTime(1, "ord_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "ord_date_to")
		lb_where = True
	End If
	
	//Tackon From Req Date
	If date(dw_select.GetItemDateTime(1, "req_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and request_date >= '" + string(dw_select.GetItemDateTime(1, "req_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "req_date_from")
		lb_where = True
	End If
	
	//Tackon To Req Date
	If date(dw_select.GetItemDateTime(1, "req_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and request_date <= '" + string(dw_select.GetItemDateTime(1, "req_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "req_date_to")
		lb_where = True
	End If
	
	//Tackon From Sched Date
	If date(dw_select.GetItemDateTime(1, "sched_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "sched_date_from")
		lb_where = True
	End If
	
	//Tackon To Sched Date
	If date(dw_select.GetItemDateTime(1, "sched_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "sched_date_to")
		lb_where = True
	End If
	

	//Tackon From Complete Date
	If date(dw_select.GetItemDateTime(1, "comp_date_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and complete_date >= '" + string(dw_select.GetItemDateTime(1, "comp_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "comp_date_from")
		lb_where = True
	End If
	
	//Tackon To Complete Date
	If date(dw_select.GetItemDateTime(1, "comp_date_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and complete_date <= '" + string(dw_select.GetItemDateTime(1, "comp_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "comp_date_to")	
		lb_where = True
	End If
	
	//Tackon Carrier Notified FRom Date
	If date(dw_select.GetItemDateTime(1, "Carrier_notified_from")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and Carrier_notified_date >= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_where = True
	End If
	
	//Tackon Carrier Notified To Date
	If date(dw_select.GetItemDateTime(1, "Carrier_notified_to")) > date('01-01-1900') Then
		ls_Where = ls_Where + " and Carrier_notified_date <= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_to"),'mm-dd-yyyy hh:mm') + "'"
		lb_where = True
	End If
	

	//Tackon Order BY
	ls_Where = ls_Where + " ORDER BY Delivery_Master.Project_ID ASC," &  
         								+ " Warehouse.WH_Name ASC," & 
											+ " Delivery_Master.Invoice_No ASC," &
											+ " Delivery_detail.line_item_no," &
											+ " Delivery_picking.line_item_no"
	
	//messagebox("",ls_Where)
	If ls_Where > '  ' Then
		ls_NewSql = ls_OrigSql + ls_Where
      lds_detail.setsqlselect(ls_Newsql)
   Else
      lds_detail.setsqlselect(ls_OrigSql)
	End If
		
	//DGM For giving warning for all no search criteria
	if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
	END IF	
	
   dw_report.SetRedraw(False)
	
	ll_cnt = lds_detail.Retrieve()
	
	
	
	for ll_row = 1 to ll_cnt
		ls_projectid = lds_detail.getitemString(ll_row,"delivery_master_project_id")
	   ls_dono = lds_detail.getitemString(ll_row,"delivery_master_do_no")
		ls_whname = lds_detail.getitemString(ll_row,"warehouse_wh_name")
		ls_invoiceno = lds_detail.getitemString(ll_row,"delivery_master_invoice_no")
		ls_ordtype = lds_detail.getitemString(ll_row,"delivery_master_ord_type")
		ls_custname = lds_detail.getitemString(ll_row,"delivery_master_cust_name")
		ls_custorderno = lds_detail.getitemString(ll_row,"delivery_master_cust_order_no")
		ls_carrier = lds_detail.getitemString(ll_row,"delivery_master_carrier")
		ldt_notifieddate = lds_detail.getitemDatetime(ll_row,"delivery_master_carrier_notified_date")
		ls_deliverynote = lds_detail.getitemString(ll_row,"user_field6")
		ls_ordstatus = lds_detail.getitemString(ll_row,"delivery_master_ord_status")
		ld_lineitemno = lds_detail.getitemdecimal(ll_row,"delivery_detail_line_item_no")
		ls_skup = lds_detail.getitemString(ll_row,"delivery_detail_sku")
		ls_sku = lds_detail.getitemString(ll_row,"sku")
		ld_reqqty = lds_detail.getitemDecimal(ll_row,"delivery_detail_req_qty")
		ld_allocqty = lds_detail.getitemDecimal(ll_row,"delivery_detail_alloc_qty")
		ld_pickingqty = lds_detail.getitemDecimal(ll_row,"delivery_picking_quantity")
		// pvh - 10/09/06 - bug fix
		ls_Lcode = lds_detail.getitemString(ll_row,"l_code")
		//ls_Lcode = lds_detail.getitemString(ll_row,"delivery_picking_L_code")
		ld_ownerid = lds_detail.getitemDecimal(ll_row,"delivery_picking_owner_id")
		ls_pcomponentind = lds_detail.getitemString(ll_row,"delivery_picking_component_ind")
		ls_icomponentind = lds_detail.getitemString(ll_row,"item_master_component_ind")
		ll_ownerid = lds_detail.getitemdecimal(ll_row,"delivery_picking_owner_id")
		if ll_ownerid=0 or isNull(ll_ownerid) then
		   ls_owner = ""
		else
			select owner_cd into :ls_owner
		     from owner 
		   where owner_id = :ll_ownerid;
		end if
		
		
	
	 //if (ls_ordstatus <>'N' and ls_pcomponentind = 'N') or (ls_ordstatus ='N' and ls_icomponentind <> 'C') or (ls_ordstatus <>'N' and ls_pcomponentind = 'W')  then
	 //if (ls_pcomponentind = 'W' or ls_pcomponentind = 'N') then
//	 if (ls_ordstatus <>'N' and ls_pcomponentind <>'Y') or (ls_ordstatus ='N' and ls_icomponentind <>'Y') or (ls_ordstatus <>'N' and isNull(ls_pcomponentind) ) then
//	   ll_insert_row= dw_report.insertrow(0)
//		dw_report.setitem(ll_insert_row,"project_id",ls_projectid)
//		dw_report.setitem(ll_insert_row,"wh_name",ls_whname)	
//		dw_report.setitem(ll_insert_row,"wh_name_1",ls_whname)		
//		dw_report.setitem(ll_insert_row,"invoice_no",ls_invoiceno)	
//		dw_report.setitem(ll_insert_row,"completion_date",ldt_notifieddate)
//		dw_report.setitem(ll_insert_row,"cust_name",ls_custname)
//		dw_report.setitem(ll_insert_row,"delivery_note",ls_deliverynote)
//		dw_report.setitem(ll_insert_row,"ord_status",ls_ordstatus)
//		if (ls_ordstatus ='N' and ls_icomponentind <> 'Y') or (ls_ordstatus <>'N' and isnull(ls_pcomponentind))  then
//		  dw_report.setitem(ll_insert_row,"sku",ls_skup)
//	   else
//		  dw_report.setitem(ll_insert_row,"sku",ls_sku)
//	   end if
//		dw_report.setitem(ll_insert_row,"line_no",ld_lineitemno)
//		dw_report.setitem(ll_insert_row,"stock_owner",ls_owner)
//	   
//		
//		
//		if ls_pcomponentind = 'N' or ls_icomponentind <> 'Y' then
//		 dw_report.setitem(ll_insert_row,"req_qty",ld_reqqty)
//	   else 
//			
//		 select child_qty into :ll_childqty
//		 from item_component 
//		 where project_id = :ls_projectid and sku_parent = :ls_skup and sku_child = :ls_sku;
//		
//	    dw_report.setitem(ll_insert_row,"req_qty",ld_reqqty*ll_childqty)
//	   end if
//		
//		if ls_ordstatus <>'N' and (ls_pcomponentind <> 'Y' or isNull(ls_pcomponentind )) then
//		 dw_report.setitem(ll_insert_row,"alloc_qty",ld_pickingqty)
//	   end if
//	end if 	
////	 end 
//	
    if ls_ordstatus <>'N' and (ls_pcomponentind = 'W' or ls_pcomponentind = 'N' or isNull(ls_pcomponentind) or trim(ls_pcomponentind) ='' or(ls_pcomponentind = 'Y' and ls_Lcode <> 'N/A')) then
	   ll_insert_row= dw_report.insertrow(0)
		dw_report.setitem(ll_insert_row,"project_id",ls_projectid)
		dw_report.setitem(ll_insert_row,"wh_name",ls_whname)	
		dw_report.setitem(ll_insert_row,"wh_name_1",ls_whname)		
		dw_report.setitem(ll_insert_row,"invoice_no",ls_invoiceno)	
		dw_report.setitem(ll_insert_row,"do_no",ls_dono)
		
		dw_report.setitem(ll_insert_row,"completion_date",ldt_notifieddate)
		dw_report.setitem(ll_insert_row,"cust_name",ls_custname)
		dw_report.setitem(ll_insert_row,"delivery_note",ls_deliverynote)
		dw_report.setitem(ll_insert_row,"ord_status",ls_ordstatus)
		if ls_pcomponentind = 'W'then
		   dw_report.setitem(ll_insert_row,"sku",ls_sku)
	   else
         dw_report.setitem(ll_insert_row,"sku",ls_skup)
	   end if
		dw_report.setitem(ll_insert_row,"line_no",ld_lineitemno)
		dw_report.setitem(ll_insert_row,"stock_owner",ls_owner)
		dw_report.setitem(ll_insert_row,"req_qty",ld_reqqty)
      dw_report.setitem(ll_insert_row,"alloc_qty",ld_pickingqty)
	// elseif ls_ordstatus <>'N' and (isNull(ls_pcomponentind)or ls_pcomponentind <> 'Y') then
	
    end if 
	
	
	





	//*Get the sku_child from item_component when order status is "N" and component IND is "Y"
	 if ls_ordstatus ='N' and ls_icomponentind = 'Y'  then
		
	    ll_rowc = lds_component.retrieve(ls_projectid,ls_skup)
		//  messagebox("",ls_ordstatus+' '+ls_icomponentind+' '+string(ll_rowc))
		
		 for ll_rc = 1 to ll_rowc
		     ll_insert_row= dw_report.insertrow(0)
		     dw_report.setitem(ll_insert_row,"project_id",ls_projectid)
		     dw_report.setitem(ll_insert_row,"wh_name",ls_whname)	
		     dw_report.setitem(ll_insert_row,"wh_name_1",ls_whname)		
		     dw_report.setitem(ll_insert_row,"invoice_no",ls_invoiceno)	
		     dw_report.setitem(ll_insert_row,"completion_date",ldt_notifieddate)
		     dw_report.setitem(ll_insert_row,"cust_name",ls_custname)
		     dw_report.setitem(ll_insert_row,"delivery_note",ls_deliverynote)
		     dw_report.setitem(ll_insert_row,"ord_status",ls_ordstatus)
		     dw_report.setitem(ll_insert_row,"sku",lds_component.getitemstring(ll_rc,"sku_child"))
		     dw_report.setitem(ll_insert_row,"line_no",ld_lineitemno)
			  dw_report.setitem(ll_insert_row,"req_qty",ld_reqqty*lds_component.getitemnumber(ll_rc,"child_qty"))
			  
		 next
	 elseif ls_ordstatus ='N' and (ls_icomponentind <> 'Y' or isNull(ls_icomponentind) or trim(ls_icomponentind)='') then
	        ll_insert_row= dw_report.insertrow(0)
		     dw_report.setitem(ll_insert_row,"project_id",ls_projectid)
		     dw_report.setitem(ll_insert_row,"wh_name",ls_whname)	
		     dw_report.setitem(ll_insert_row,"wh_name_1",ls_whname)		
		     dw_report.setitem(ll_insert_row,"invoice_no",ls_invoiceno)	
		     dw_report.setitem(ll_insert_row,"completion_date",ldt_notifieddate)
		     dw_report.setitem(ll_insert_row,"cust_name",ls_custname)
		     dw_report.setitem(ll_insert_row,"delivery_note",ls_deliverynote)
		     dw_report.setitem(ll_insert_row,"ord_status",ls_ordstatus)
		     dw_report.setitem(ll_insert_row,"sku",ls_skup)
	        dw_report.setitem(ll_insert_row,"line_no",ld_lineitemno)
		     dw_report.setitem(ll_insert_row,"stock_owner",ls_owner)
	        dw_report.setitem(ll_insert_row,"req_qty",ld_reqqty)
	 end if	
//		
      






   next
	
	
	
	dw_report.GroupCalc()
	
	
	
	ll_cnt = dw_report.rowcount()
	
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If 
END IF
//
dw_report.SetRedraw(True)

DESTROY lds_detail
DESTROY lds_component




end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()


uo_order_status_search.uf_init("d_ord_status_search_list", "delivery_master.Ord_Status", "ord_status")

end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)

end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()

uo_order_status_search.uf_clear_list()
end event

type dw_select from w_std_report`dw_select within w_3com_outbound_order
event process_enter pbm_dwnprocessenter
integer x = 0
integer y = 0
integer width = 3419
integer height = 460
string dataobject = "d_3com_outbound_order_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::process_enter;Send(Handle(This),256,9,Long(0,0))
 Return 1
end event

event dw_select::constructor;call super::constructor;integer i, ll_row, ll_find_row

ib_movement_from_first = TRUE
ib_movement_to_first  = TRUE
ib_movement_fromComp_first = TRUE
ib_movement_toComp_first = TRUE

ib_first_time = true
ll_row = dw_select.insertrow(0)

//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_project_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve(gs_project)
ll_find_row = ids_find_warehouse.RowCount()
IF ll_find_row > 0 THEN
	i = 1
	DO while i <= ll_find_row
		is_warehouse_code = ids_find_warehouse.GetItemString(i,"wh_code")
		dw_select.SetValue("wh_name",i,is_warehouse_code)
		i +=1
	loop	
END IF
dw_select.SetItem(1,"wh_name",gs_default_wh)

//Create the locating warehouse name datastore
ids_find_ord_type = CREATE Datastore 
ids_find_ord_type.dataobject = 'dddw_delivery_order_type'
ids_find_ord_type.SetTransObject(SQLCA)
ids_find_ord_type.Retrieve(gs_project)
ll_find_row = ids_find_ord_type.RowCount()

IF ll_find_row > 0 THEN
	i = 1
	DO while i <= ll_find_row
		is_ord_type = ids_find_ord_type.GetItemString(i,"ord_type")
		is_ord_type_desc = ids_find_ord_type.GetItemString(i,"ord_type_desc")
		dw_select.SetValue("ord_type",i,  is_ord_type + " - " + is_ord_type_desc)
		//dw_products.SetValue("product_col", i, & prod_name + "~t" + String(prod_code))
		i +=1
	loop	
END IF



end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "ord_date_from"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("ord_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "ord_date_to"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("ord_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF

CASE "comp_date_from"
		
		IF ib_movement_fromComp_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("comp_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			 ib_movement_fromComp_first = FALSE
			
		END IF
		
	CASE "comp_date_to"
		
		IF ib_movement_toComp_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("comp_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_toComp_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE
end event

type cb_clear from w_std_report`cb_clear within w_3com_outbound_order
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_3com_outbound_order
integer x = 5
integer y = 460
integer width = 3429
integer height = 1404
integer taborder = 30
string dataobject = "d_3com_outbound_vmi_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_report::retrieveend;call super::retrieveend;Long	llRowCount,	llRowPos, llOwnerID
String	lsOwnerCd, lsOwnerType

//retrieve the Owner Name - with outer join to Picking LIst, we can't inner join to Owner Table 
If g.is_owner_ind = 'Y' Then
	
	This.SetRedraw(false)
	SetPointer(Hourglass!)
	lLRowCount = This.RowCount()
	For llRowPos = 1 to llRowCount
		
		llOWnerID = This.GetITemNumber(lLRowPos,'owner_id')
		If Not isnull(llOWnerID) Then
			
			Select Owner_cd, Owner_Type 
			Into	 :lsOWnerCd, :lsOwnerType
			From	 Owner
			Where Owner_id = :llOWnerID and project_id = :gs_Project;
			
			This.SetItem(llRowPos,'cf_owner_Name',Trim(lsOwnerCd) + '(' + lsOwnerType + ')')
			
		End If
		
	Next
	
	This.SetRedraw(True)
	SetPointer(Arrow!)
	
End If
end event

type uo_order_status_search from uo_multi_select_search within w_3com_outbound_order
integer x = 361
integer y = 164
integer height = 284
integer taborder = 30
boolean bringtotop = true
end type

on uo_order_status_search.destroy
call uo_multi_select_search::destroy
end on

