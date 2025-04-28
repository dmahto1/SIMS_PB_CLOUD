$PBExportHeader$w_pulse_goods_delivery_rpt.srw
$PBExportComments$OutBound Order Report (GAP - 8/02)
forward
global type w_pulse_goods_delivery_rpt from w_std_report
end type
end forward

global type w_pulse_goods_delivery_rpt from w_std_report
integer width = 3502
integer height = 2100
string title = "Pulse Goods Deliveries"
end type
global w_pulse_goods_delivery_rpt w_pulse_goods_delivery_rpt

type variables
string 			is_origsql
string       	is_ord_type
string       	is_ord_status
string  			is_ord_status_desc
datastore 		ids_find_warehouse
datastore 		ids_find_ord_type
DataWindowChild idwc_warehouse
boolean 			ib_first_time
boolean 			ib_movement_fromComp_first
boolean 			ib_movement_toComp_first
end variables

on w_pulse_goods_delivery_rpt.create
call super::create
end on

on w_pulse_goods_delivery_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() -30,workspaceHeight()-300)
end event

event ue_retrieve;String 	ls_Where, 				&
 			ls_warehouse, 			&
 			ls_warehouse_name, 	&
 			ls_NewSql, 				&
 			ls_selection, 			&
 			ls_value, 				&
 			ls_whcode, 				&
 			ls_sku

integer 	li_y

Long 		ll_balance, 			& 
			i, 						& 
			ll_row, 					&
			ll_cnt, 					& 
			ll_find_row
			
boolean 	lb_where

DateTime ldt_s, ldt_e

If dw_select.AcceptText() = -1 Then Return
lb_where = false

SetPointer(HourGlass!)
dw_report.Reset()
//
//is_warehouse_code = dw_select.GetItemString(1, "wh_name")
//IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
//	MessageBox("ERROR", "Please select a warehouse",stopsign!)
//ELSE
 	ls_Where =" and delivery_master.wh_code = 'PULSE-LIA'"
	ls_Where = ls_Where +  " and (delivery_master.ord_status = 'C' OR delivery_master.ord_status = 'D')"
	// 7/02 GAP - Always tackon  Project id and warehouse
	ls_Where = ls_Where + " and delivery_master.project_id = '" + gs_project + "'"
	
	// 7/02 GAP - tackon  Order Type
	If dw_select.GetItemString(1, "ord_type") <> "" Then
		ls_Where = ls_Where + " and delivery_master.Ord_Type = '" + Left(dw_select.GetItemString(1, "ord_type"),1) + "'"
		lb_where = True
	end if
	//For Skus
	If dw_select.object.sku[1] <> "" Then
		ls_Where = ls_Where + " and delivery_picking.sku Like '%" + dw_select.object.sku[1] + "%'"
		lb_where = True
	end if
	//Supplier code
	If dw_select.object.supplier[1] <> "" Then
		ls_Where = ls_Where + " and delivery_picking.supp_code Like '%" + dw_select.object.supplier[1] + "%'"
		lb_where = True
	end if
	//For Loc 
	If dw_select.object.plant[1] <> "" Then
			ls_Where = ls_Where + " and delivery_master.cust_code Like '%" + dw_select.object.plant[1] + "%'"
			lb_where = True
		end if

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

	// 8/02 GAP - Tackon Order BY
	//ls_Where = ls_Where + " ORDER BY Delivery_Master.Project_ID ASC," &  
   //      								+ " Warehouse.WH_Name ASC," & 
	//										+ " Delivery_Master.DO_No ASC," &  
   //      								+ " Delivery_Master.Invoice_No ASC"            								

	If ls_Where > '  ' Then
		ls_NewSql = is_OrigSql + ls_Where 
		dw_report.setsqlselect(ls_Newsql)
	Else
		dw_report.setsqlselect(is_OrigSql)
	End If
	
	//DGM For giving warning for all no search criteria
	if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
	END IF	

	//ll_cnt = dw_report.Retrieve(ldt_s, ldt_e)
	dw_report.SetRedraw(False)
	ll_cnt = dw_report.Retrieve()
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If 
//END IF

dw_report.SetRedraw(True)




end event

event open;call super::open;m_main lm_main
is_OrigSql = dw_report.getsqlselect()




end event

event ue_postopen;call super::ue_postopen;string ls_filter
DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)
IF IsValid(m_main.m_file.m_sort) THEN m_main.m_file.m_sort.Enabled = False


end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()
dw_report.Reset()

end event

type dw_select from w_std_report`dw_select within w_pulse_goods_delivery_rpt
integer x = 18
integer y = 16
integer width = 3534
integer height = 244
string dataobject = "d_goods_received_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;integer ll_row,ll_rtn
String lsFilter
DatawindowChild ldwc_order_type
ib_movement_fromComp_first = TRUE
ib_movement_toComp_first = TRUE

ib_first_time = true
ll_row = dw_select.insertrow(0)

//populate dropdowns - not done automatically since dw not being retrieved

ll_rtn=dw_select.GetChild('ord_type', ldwc_order_type)
ll_rtn=ldwc_order_type.SetTransObject(sqlca)
If ldwc_order_type.Retrieve(gs_project) > 0 Then	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "order_type = '" + gs_project + "'"
	ldwc_order_type.SetFilter(lsFilter)
	ldwc_order_type.Filter()
	
End If


end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
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

type cb_clear from w_std_report`cb_clear within w_pulse_goods_delivery_rpt
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pulse_goods_delivery_rpt
integer x = 5
integer y = 276
integer width = 3429
integer height = 1532
integer taborder = 30
string dataobject = "d_pulse_delivery_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

