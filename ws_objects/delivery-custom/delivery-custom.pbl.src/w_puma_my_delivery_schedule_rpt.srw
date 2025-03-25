$PBExportHeader$w_puma_my_delivery_schedule_rpt.srw
forward
global type w_puma_my_delivery_schedule_rpt from w_std_report
end type
end forward

global type w_puma_my_delivery_schedule_rpt from w_std_report
integer height = 2124
string title = "PHXBRANDS Short Shipped Report"
end type
global w_puma_my_delivery_schedule_rpt w_puma_my_delivery_schedule_rpt

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
boolean 			ib_movement_fromReq_first
boolean 			ib_movement_toReq_first
boolean 			ib_movement_fromSched_first
boolean 			ib_movement_toSched_first
boolean 			ib_movement_fromCarrier_first
boolean 			ib_movement_toCarrier_first
end variables

event resize;call super::resize;dw_report.Resize(workspacewidth() - 60,workspaceHeight()-500)

end event

on w_puma_my_delivery_schedule_rpt.create
call super::create
end on

on w_puma_my_delivery_schedule_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()

//uo_order_status_search.uf_clear_list()
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_Where, 				&
 			ls_warehouse, 			&
 			ls_warehouse_name, 	&
 			ls_NewSql, 				&
 			ls_selection, 			&
 			ls_value, 				&
 			ls_whcode, 				&
 			ls_sku,					&
			ls_order_status

integer 	li_y, li_rtn

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

dw_report.SetRedraw(False)

dw_report.Reset()

If dw_select.RowCount() <= 0 Then
	Return
End If


//MAS report is for PUMA-MY
is_warehouse_code = dw_select.GetItemString(1, "wh_code")
IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
	MessageBox("ERROR", "Please select a warehouse",stopsign!)
	Return
//IF (gs_project = "") or isnull(gs_project) THEN
	//MessageBox("ERROR", "Please contact SIMS Support." +&
	//"~r~n~r~n Variable gs_project is null." ,stopsign!)
	//dw_report.SetRedraw(True)
	//Return
ELSE
 
//	// 7/02 GAP - Always tackon  Project id and warehouse
	//ls_Where = ls_Where + " and delivery_master.Project_id = '" + gs_project + "'"
	//ls_Where = ls_Where + " and delivery_master.WH_Code = '" + is_warehouse_code + "'"

	
//	// 7/02 GAP - tackon  Order Type
//	If dw_select.GetItemString(1, "ord_type") <> "" Then
//		ls_Where = ls_Where + " and delivery_master.Ord_Type = '" + Left(dw_select.GetItemString(1, "ord_type"),1) + "'"
//		lb_where = True
//	end if
	
	// 7/02 GAP -  tackon  Order Status
//	If dw_select.GetItemString(1, "ord_status") <> "" Then

	//ls_order_status = uo_order_status_search.uf_build_search(true)	

	
//	if ls_order_status > "" then	
//		
////		ls_Where = ls_Where + " and delivery_master.Ord_Status = '" + dw_select.GetItemString(1, "ord_status") + "'"
//
//		ls_where = ls_where + ls_order_status
//
//		lb_where = True
//	end if
	
//	//Tackon From Order Date
//	If date(dw_select.GetItemDateTime(1, "ord_date_from")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "ord_date_from"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_s = dw_select.GetItemDateTime(1, "ord_date_from")
//		lb_where = True
//	End If
	
//	//Tackon To Order Date
//	If date(dw_select.GetItemDateTime(1, "ord_date_to")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_e = dw_select.GetItemDateTime(1, "ord_date_to")
//		lb_where = True
//	End If
	
//	//Tackon From Req Date
//	If date(dw_select.GetItemDateTime(1, "req_date_from")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and request_date >= '" + string(dw_select.GetItemDateTime(1, "req_date_from"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_s = dw_select.GetItemDateTime(1, "req_date_from")
//		lb_where = True
//	End If
//	
//	//Tackon To Req Date
//	If date(dw_select.GetItemDateTime(1, "req_date_to")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and request_date <= '" + string(dw_select.GetItemDateTime(1, "req_date_to"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_e = dw_select.GetItemDateTime(1, "req_date_to")
//		lb_where = True
//	End If
	
	//Tackon From Sched Date	
	If date(dw_select.GetItemDateTime(1, "from_sched_date")) > date('01-01-1900') Then
		//ls_Where = ls_Where + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		ldt_s = dw_select.GetItemDateTime(1, "from_sched_date")
		//lb_where = True
	Else
				MessageBox("ERROR", "Please select a From Date!",stopsign!)				
				//li_rtn = dw_select.SetItem(1, "from_sched_date", datetime('01-01-1900')  )
				dw_select.SetFocus()
				//dw_select.SetColumn("from_sched_date")
				
				dw_select.SetColumn("from_sched_date")
				dw_select.SetText('00-00-0000')
				
				
				dw_report.SetRedraw(True)
				Return		
	End If
	
	//Tackon To Sched Date
	If date(dw_select.GetItemDateTime(1, "to_sched_date")) > date('01-01-1900') Then
		//ls_Where = ls_Where + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
		ldt_e = dw_select.GetItemDateTime(1, "to_sched_date")
		//lb_where = True
	Else
				MessageBox("ERROR", "Please select a To Date!",stopsign!)				
				//dw_select.SetItem(1, "to_sched_date", datetime('01-01-1900')  )
				dw_select.SetFocus()
				//dw_select.SetColumn("to_sched_date")
				
				dw_select.SetColumn("from_sched_date")
				dw_select.SetText('00-00-0000')
				
				dw_report.SetRedraw(True)
				Return	
	End If
	

//	//Tackon From Complete Date
//	If date(dw_select.GetItemDateTime(1, "comp_date_from")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and complete_date >= '" + string(dw_select.GetItemDateTime(1, "comp_date_from"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_s = dw_select.GetItemDateTime(1, "comp_date_from")
//		lb_where = True
//	End If
//	
//	//Tackon To Complete Date
//	If date(dw_select.GetItemDateTime(1, "comp_date_to")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and complete_date <= '" + string(dw_select.GetItemDateTime(1, "comp_date_to"),'mm-dd-yyyy hh:mm') + "'"
//		ldt_e = dw_select.GetItemDateTime(1, "comp_date_to")	
//		lb_where = True
//	End If
	
//	// 08/04 - PCONKL - Tackon Carrier Notified FRom Date
//	If date(dw_select.GetItemDateTime(1, "Carrier_notified_from")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and Carrier_notified_date >= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_from"),'mm-dd-yyyy hh:mm') + "'"
//		lb_where = True
//	End If
//	
//	////08/04 - PCONKL - Tackon Carrier Notified To Date
//	If date(dw_select.GetItemDateTime(1, "Carrier_notified_to")) > date('01-01-1900') Then
//		ls_Where = ls_Where + " and Carrier_notified_date <= '" + string(dw_select.GetItemDateTime(1, "Carrier_notified_to"),'mm-dd-yyyy hh:mm') + "'"
//		lb_where = True
//	End If
	

	// 8/02 GAP - Tackon Order BY
	//ls_Where = ls_Where + " ORDER BY Delivery_Master.Project_ID ASC," &  
   //      								+ " Warehouse.WH_Name ASC," & 
	//										+ " Delivery_Master.DO_No ASC," &  
   //      								+ " Delivery_Master.Invoice_No ASC"            								

//	If ls_Where > '  ' Then
//		ls_NewSql = is_OrigSql + ls_Where 
//		dw_report.setsqlselect(ls_Newsql)
//	Else
//		dw_report.setsqlselect(is_OrigSql)
//	End If
	
//	//DGM For giving warning for all no search criteria
//	if not lb_where then
//	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
//	END IF	

	//ll_cnt = dw_report.Retrieve(ldt_s, ldt_e)
	dw_report.SetRedraw(False)
	ll_cnt = dw_report.Retrieve( gs_project, is_warehouse_code, ldt_s, ldt_e )
	IF ll_cnt > 0 Then
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
		dw_select.SetColumn("from_sched_date")
		
		//dw_select.SetColumn("from_sched_date")
		//dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
		

	End If 
END IF

dw_report.SetRedraw(True)


////********************************************************
//// from w_allocation_report
//
//Long	llRowCount, llPos
Integer	lirc
String	lsWhere,	lsNewSQL, lsSort
//
//If dw_select.AcceptText() < 0 Then Return
//
//SetPointer(Hourglass!)
//dw_report.SetRedraw(False)
//
////Tackon search criteria
//
///* always tackon Project and warehouse and new order status*/
//lsWhere = " and Delivery_MAster.Project_ID = '" + gs_project + "' and wh_code = '" + dw_select.GetITEmString(1,'wh_code') + "' " 
//lsWhere += " and ord_status = 'N' "
//
////Add Cust Code if PResent
//If dw_Select.GetItemString(1,'Customer') > ' ' Then
//	lsWhere += " and cust_code = '" + dw_Select.GetItemString(1,'Customer') + "' "
//End If
//
////Add Order Type if PResent
//If dw_Select.GetItemString(1,'order_Type') > ' ' Then
//	lsWhere += " and ord_Type = '" + dw_Select.GetItemString(1,'order_Type') + "' "
//End If
//
////Add Order Number if Present
//If dw_Select.GetItemString(1,'Invoice_no') > ' ' Then
//	lsWhere += " and Invoice_no = '" + dw_Select.GetItemString(1,'Invoice_no') + "' "
//End If
//
//// From Sched Date
//If date(dw_select.GetItemDateTime(1,"from_SChed_Date")) > date('01-01-1900') Then
//	lsWhere += " and schedule_date >= '" + string(dw_select.GetItemDateTime(1,"from_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
//End If
//
//// From To Date
//If date(dw_select.GetItemDateTime(1,"to_SChed_Date")) > date('01-01-1900') Then
//	lsWhere += " and schedule_date <= '" + string(dw_select.GetItemDateTime(1,"to_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
//End If
//
////Modify SQL
//
//// 01/05 - to support Components, we need to add Where before Union and at end
//
//lsNewSQL = is_OrigSql + lsWhere
//lsNewSQL = Replace(lsNewSql, (Pos(Upper(lsNewSql),'UNION') - 1),1,lsWhere)
//dw_Report.SetSQLSelect(lsNewSQL)
//
//llRowCount = dw_report.Retrieve()
//If llRowCount > 0 Then
//	im_menu.m_file.m_print.Enabled = True
//	dw_report.Setfocus()
//Else
//	im_menu.m_file.m_print.Enabled = False	
//	MessageBox(is_title, "No records found!")
//	dw_select.Setfocus()
//End If
//
////Sort orders before allocating
//Choose Case Upper(dw_select.GetITemString(1,'sort_order'))
//	Case 'O' /*Sort by Order*/
//		lsSort = "delivery_master_invoice_no A, Delivery_Detail_Line_Line_Item_No A"
//	Case 'P' /*priority*/
//		lsSort = "Delivery_Master_Priority A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
//	Case 'S' /*Schedule_Date */
//		lsSort = "Delivery_Master_Schedule_Date A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
//	Case 'C'
//		lsSort = "Delivery_Master_Cust_Code A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
//End Choose
//
//lirc = dw_Report.SetSort(lsSort)
//Dw_Report.Sort()
//
//// Allocate
//This.TriggerEvent('ue_allocate')
//
//resort


// sort columns - Whse_code, Invoice_No, Cust_Order_No, Customer_Name
/*
				Delivery_Master.WH_Code         AS	'Whse_code',
		   		Delivery_Master.Invoice_No       AS 	'Invoice_No',
				Delivery_Master.Cust_Order_No AS 	'Cust_Order_No',
				Delivery_Master.Cust_Name       AS 	'Customer_Name',
				Delivery_Master.City                  AS	'Customer_City',
				Delivery_Master.State                AS 	'Customer_State',
				Delivery_Detail.SKU                   AS 	'SKU',
				Delivery_Detail.Req_Qty             AS 	'Requested_Qty', 
				Delivery_Detail.alloc_qty            AS 	'Shipped Qty', 
				Delivery_Master.Remark     
*/

Choose Case Upper(dw_select.GetITemString(1,'sort_order'))
	Case 'O' /*Sort by Cust_Order_No*/
		lsSort = "Cust_Order_No A, Invoice_No A, WH_Code A, SKU A, Schedule_date A"
	Case 'I' /*Invoice_No*/
		lsSort = "Invoice_No A, WH_Code A, SKU A, Schedule_date A"
	Case 'W' /*Whse_code */
		lsSort = "WH_Code A, SKU A, Schedule_date A, Invoice_No A"	
	Case 'C' /*Customer_Name*/
		lsSort = "Customer_Name A, Cust_Order_No A, Invoice_No A, WH_Code A, SKU A, Schedule_date A"
End Choose




string ad1 = 'went', &
		ad2='to the', &
		ad3='market',&
		ad4='bye', add


add =  ad1 +'~n~r '+ ad2 +'~n~r '+ ad3+'~n~r '+  ad4

//messagebox("message" , add)




SELECT         
				Delivery_Master.Address_1       			AS 	'Address_1',
				Delivery_Master.Address_2       			AS 	'Address_2',
				Delivery_Master.Address_3       			AS 	'Address_3',
				Delivery_Master.Address_4       			AS 	'Address_4',

//           isNull (Delivery_Master.Address_1, 'unknown Add1') --+char(13)+char(13)
//+',     '+ isNull (Delivery_Master.Address_2, 'unknown Add2') --+char(13)+char(13)
//+',     '+ isNull (Delivery_Master.Address_3, 'unknown Add3') --+char(13)+char(13)
//+',     '+ isNull (Delivery_Master.Address_4, 'unknown Add4') --+char(13)+char(13)
//+',     '+ isnull (Delivery_Master.City, 'City')
//+', '+     isNull(Delivery_Master.State, 'State')
//+', '+     isNull(Delivery_Master.zip, 'Zip') as 'Address',
//
//
//				Delivery_Master.City                  			AS		'Customer_City',
//				Delivery_Master.State                			AS 	'Customer_State',
//				Delivery_Master.zip                   			AS 	'Zip',
//


				


COUNT(Delivery_Master.Invoice_No) as 'Total Line Items'


into :ad1,:ad2,:ad3,:ad4

    FROM 	Delivery_Master
				,Delivery_Detail



   WHERE  Delivery_Master.DO_No = dbo.Delivery_Detail.DO_No		And  


                Delivery_Master.Project_ID = upper('PUMA')				         And
			    Delivery_Master.WH_Code = upper('PUMA-SG')					    And
                Delivery_Master.ord_status in ('P', 'A' , 'C') 					And 
                Delivery_Master.WH_Code <> 'PHX-THORO'	And				
                Delivery_Master.schedule_date >= '03-01-08' 				And
			    Delivery_Master.schedule_date <= '03-30-11'


//Delivery_Master.Invoice_No, Delivery_Master.schedule_date, Delivery_Master.Cust_Name
group by   
Delivery_Master.Address_1,Delivery_Master.Address_2,Delivery_Master.Address_3,Delivery_Master.Address_4
//,Delivery_Master.City, Delivery_Master.State, Delivery_Master.zip
//,Delivery_Master.Remark, Delivery_Master.Shipping_Instructions
//, Delivery_Master.Do_No 


;

add =  ad1 +'~n~r '+ ad2 +'~n~r '+ ad3+'~n~r '+  ad4

//messagebox("message" , add)

//case(address_1 when '' then 'Null' )
//+'~n~r '+ address_2 
//+'~n~r '+ address_3
////+'~n~r'+  if (isNull(address_4 ), 'Null', address_4 )
////+' '+ customer_city  +' '+customer_state+' '+  zip










////Hide Owner if not tracking by
//If g.is_owner_ind <> 'Y' Then
//	dw_report.modify("c_req_owner.visible=False delivery_detail_owner_id_t.visible=False c_avail_owner.visible=False")
//End If
dw_report.SetRedraw(True)

lirc = dw_report.SetSort(lsSort)
lirc = dw_Report.Sort()
dw_Report.GroupCalc()

SetPointer(Arrow!)


//*************************
end event

event ue_postopen;call super::ue_postopen;

//string ls_filter
DatawindowChild	ldwc_warehouse


//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(Sqlca)
ldwc_warehouse.Retrieve(gs_project)


DatawindowChild	ldwc, ldwc2
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_Project)
dw_Select.SetITem(1,'wh_code',gs_default_wh)

//dw_select.GetChild('order_Type', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve(gs_Project)
//dw_report.GetChild('delivery_master_ord_type', ldwc2) /*Share with Report*/
//ldwc.ShareData(ldwc2)
//
//dw_report.GetChild('delivery_master_inventory_type', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve(gs_Project)
end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()
end event

event ue_sort;call super::ue_sort;dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_puma_my_delivery_schedule_rpt
event process_enter pbm_dwnprocessenter
integer width = 2871
integer height = 412
string dataobject = "d_puma_my_delivery_schedule_rpt_search"
end type

event dw_select::process_enter;Send(Handle(This),256,9,Long(0,0))
 Return 1
end event

event dw_select::clicked;call super::clicked;string 	ls_column, lsSort

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


//MAS set vars to true
ib_movement_fromSched_first = true
ib_movement_toSched_first = true


CHOOSE CASE ls_column
		
//	CASE "ord_date_from"
//		
//		IF ib_movement_from_first THEN
//			
//			ldt_begin_date = f_get_date("BEGIN")
//			dw_select.SetColumn("ord_date_from")
//			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_from_first = FALSE
//			
//		END IF
//		
//	CASE "ord_date_to"
//		
//		IF ib_movement_to_first THEN
//			
//			ldt_end_date = f_get_date("END")
//			dw_select.SetColumn("ord_date_to")
//			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_to_first = FALSE
//			
//		END IF
//
//    CASE "comp_date_from"
//		
//		IF ib_movement_fromComp_first THEN
//			
//			ldt_begin_date = f_get_date("BEGIN")
//			dw_select.SetColumn("comp_date_from")
//			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_fromComp_first = FALSE
//			
//		END IF
//		
//	CASE "comp_date_to"
//		
//		IF ib_movement_toComp_first THEN
//			
//			ldt_end_date = f_get_date("END")
//			dw_select.SetColumn("comp_date_to")
//			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_toComp_first = FALSE
//			
//		END IF
//	
//	
//	CASE "req_date_from"
//		
//		IF ib_movement_fromReq_first THEN
//			
//			ldt_begin_date = f_get_date("BEGIN")
//			dw_select.SetColumn("Req_date_from")
//			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_fromReq_first = FALSE
//			
//		END IF
//		
//	CASE "req_date_to"
//		
//		IF ib_movement_toReq_first THEN
//			
//			ldt_end_date = f_get_date("END")
//			dw_select.SetColumn("Req_date_to")
//			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_toReq_first = FALSE
//			
//		END IF
		
   
   CASE "from_sched_date"
		
		IF ib_movement_fromSched_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("from_sched_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_fromSched_first = FALSE
			
		END IF
		
	CASE "to_sched_date"
		
		IF ib_movement_toSched_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("to_sched_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_toSched_first = FALSE
			
		END IF
	
	
//	CASE "carrier_notified_from"
//		
//		IF ib_movement_fromCarrier_first THEN
//			
//			ldt_begin_date = f_get_date("BEGIN")
//			dw_select.SetColumn("carrier_notified_from")
//			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_fromCarrier_first = FALSE
//			
//		END IF
//		
//	CASE "carrier_notified_to"
//		
//		IF ib_movement_toCarrier_first THEN
//			
//			ldt_end_date = f_get_date("END")
//			dw_select.SetColumn("carrier_notified_to")
//			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
//			ib_movement_toCarrier_first = FALSE
//			
//		END IF
	
	

		
		
		
	CASE ELSE
		
END CHOOSE
end event

event dw_select::constructor;call super::constructor;//If g.is_owner_ind <> 'Y' Then

This.modify("allow_alt_owner_ind.visible=False")
This.modify("shippable_inv_type_ind.visible=False")

//End If
end event

event dw_select::itemchanged;call super::itemchanged;string lsSort

//MAS
Choose Case dwo.name
	CASE "sort_order"


		Choose Case data

		//Choose Case Upper(dw_select.GetITemString(1,'compute_sort_order'))
			//Choose Case Upper(dw_select.GetITemString(1,'sort_order'))
				Case 'O' /*Sort by Cust_Order_No*/
					lsSort = "Cust_Order_No A, Invoice_No A, WH_Code A, SKU A, Schedule_date A"
				Case 'I' /*Invoice_No*/
					lsSort = "Invoice_No A, WH_Code A, SKU A, Schedule_date A"
				Case 'W' /*Whse_code */
					lsSort = "WH_Code A, SKU A, Schedule_date A, Invoice_No A"	
				Case 'C' /*Customer_Name*/
					lsSort = "Customer_Name A, Cust_Order_No A, Invoice_No A, WH_Code A, SKU A, Schedule_date A"
	End Choose
End Choose			
			dw_Report.SetSort(lsSort)
			dw_Report.Sort()
			dw_Report.GroupCalc()

			SetPointer(Arrow!)
		
	
end event

type cb_clear from w_std_report`cb_clear within w_puma_my_delivery_schedule_rpt
end type

type dw_report from w_std_report`dw_report within w_puma_my_delivery_schedule_rpt
integer y = 476
string dataobject = "d_puma_my_delivery_schedule_rpt"
boolean hscrollbar = true
end type

event dw_report::retrieveend;call super::retrieveend;//Long	llRowCount,	llRowPos, llOwnerID
//String	lsOwnerCd, lsOwnerType
//
////retrieve the Owner Name - with outer join to Picking LIst, we can't inner join to Owner Table 
//If g.is_owner_ind = 'Y' Then
//	
//	This.SetRedraw(false)
//	SetPointer(Hourglass!)
//	lLRowCount = This.RowCount()
//	For llRowPos = 1 to llRowCount
//		
//		llOWnerID = This.GetITemNumber(lLRowPos,'owner_id')
//		If Not isnull(llOWnerID) Then
//			
//			Select Owner_cd, Owner_Type 
//			Into	 :lsOWnerCd, :lsOwnerType
//			From	 Owner
//			Where Owner_id = :llOWnerID and project_id = :gs_Project;
//			
//			This.SetItem(llRowPos,'cf_owner_Name',Trim(lsOwnerCd) + '(' + lsOwnerType + ')')
//			
//		End If
//		
//	Next
//	
//	This.SetRedraw(True)
//	SetPointer(Arrow!)
//	
//End If
end event

