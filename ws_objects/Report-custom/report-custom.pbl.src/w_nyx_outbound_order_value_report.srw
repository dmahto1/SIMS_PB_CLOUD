$PBExportHeader$w_nyx_outbound_order_value_report.srw
$PBExportComments$Putaway Report
forward
global type w_nyx_outbound_order_value_report from w_std_report
end type
end forward

global type w_nyx_outbound_order_value_report from w_std_report
integer width = 4462
integer height = 2020
string title = "Purchase Order Report"
end type
global w_nyx_outbound_order_value_report w_nyx_outbound_order_value_report

type variables
String	isOrigSql
Boolean  ib_First_Time = true

boolean ib_order_from_first
boolean ib_order_to_first
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
end variables

on w_nyx_outbound_order_value_report.create
call super::create
end on

on w_nyx_outbound_order_value_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()

dw_report.Object.DataWindow.Print.Preview = 'Yes'



end event

event ue_retrieve;
string ls_order_nbr
string ls_ro_no

long ll_cnt
long ll_number

boolean lb_selection


	String ls_whcode, ls_sku, lsWhere, lsNewSql, ls_from_date
	DateTime ldFromDate, ldtodate
	Long ll_balance, i
	Boolean lb_order_from, lb_order_to, lb_sched_from, lb_sched_to, lb_complete_from, lb_complete_to
	Boolean lb_where
	If dw_select.AcceptText() = -1 Then Return
	
	datawindowchild ldwc
	
	dw_report.GetChild('ord_type', ldwc)
	ldwc.SetTransObject(Sqlca)
	ldwc.Retrieve(gs_project)
	
	
	//Initialize Date Flags
	lb_order_from 		= FALSE
	lb_order_to 		= FAlSE
	lb_sched_from 		= FALSE
	lb_sched_to 		= FALSE
	lb_complete_from 	= FALSE
	lb_complete_to 	= FALSE
	lb_where = FALSE
	
	SetPointer(HourGlass!)
	dw_report.Reset()
	
	//Always tackon project
	lsWhere += " and delivery_master.Project_id = '" + gs_project + "'"
	
	//Tackon Warehouse
	if  not isnull(dw_select.GetItemString(1,"warehouse")) then
		lswhere += " and delivery_master.wh_code = '" + dw_select.GetItemString(1,"warehouse") + "'"
		lb_where = TRUE
	end if
	
	//Tackon BOL Nbr
	if  not isnull(dw_select.GetItemString(1,"bol_nbr")) then
		lswhere += " and delivery_master.Cust_Order_No like '%" + dw_select.GetItemString(1,"bol_nbr") + "%'"
		lb_where = TRUE
	end if
	
	//Tackon order Date
	If Date(dw_select.GetItemDateTime(1,"receive_from_date")) > date('01-01-1900') Then
			lsWhere = lsWhere + " and  Delivery_Master.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"receive_from_date"),'mm-dd-yyyy hh:mm') + "'"
			//ls_from_date = string(dw_select.GetItemDateTime(1,"receive_from_date"),'mm/dd/yyyy hh:mm ') 
			lb_sched_from = TRUE
			lb_where = TRUE
	End If
	
	//Tackon To Receive Date - bump by 1 and check for less than to account for time
	If Date(dw_select.GetItemDateTime(1,"receive_to_date")) > date('01-01-1900') Then
			//ldToDate = relativeDate(dw_select.GetItemDate(1,"receive_to_date"),1)
			lsWhere = lsWhere + " and  Delivery_Master.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"receive_to_date"),'mm-dd-yyyy hh:mm') + "'"
			//dw_report.Object.t_receive_date.text = ls_from_date + " - " + &
			//string(dw_select.GetItemDateTime(1,"receive_to_date"),"mm/dd/yyyy hh:mm ")
			lb_sched_to = TRUE
			lb_where = TRUE
	End If
	
	//Ord_Typ
	if  not isnull(dw_select.GetItemString(1,"ord_typ")) then
		lswhere += " and delivery_master.Ord_Type = '" + dw_select.GetItemString(1,"ord_typ") + "'"
		lb_where = TRUE
	end if
	
	If lsWhere > '  ' Then
		lsNewSql = isOrigSql + lsWhere 
		dw_report.setsqlselect(lsNewsql)
	Else
		dw_report.setsqlselect(isOrigSql)
	End If
	
	//Check Order Date range for any errors prior to retrieving
	IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
			 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
			 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
			messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
			Return
	END IF
	
	//Check Complete Date range for any errors prior to retrieving
	IF 	((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
			 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
			 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
			messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
			Return
	END IF	
	
	//Check Sched Arrival Date range for any errors prior to retrieving
	IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
			 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
			 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
			messagebox("ERROR", "Please complete the FROM\To in Sched Arrival Date Range", Stopsign!)
			Return
	END IF	
	
	
	//If no seach is entered
	if not lb_where then
		  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
	END IF	
	
	ll_cnt = dw_report.Retrieve()
	If ll_cnt > 0 Then
		long llCurRow, llAllocQty, llUOM2
		real ldMultiplier
		for llCurRow = 1 to dw_report.RowCount()
			llAllocQty = dw_report.GetItemNumber(llCurRow, 'delivery_detail_req_qty')
			llUOM2 = dw_report.GetItemNumber(llCurRow, 'item_master_qty_2')
			if llUOM2 <> 0 then
				if Real(long(llUOM2 * long(llAllocQty / llUOM2))) = (Real(llUOM2) * Real(llAllocQty) / Real(llUOM2)) then //divides with no remainder
					ldMultiplier = .05
				else
					ldMultiplier = .07
				end if
			else
				ldMultiplier = 1
			end if
			dw_report.SetItem(llCurRow, 'lp2', Real(dw_report.GetItemString(llCurRow, 'delivery_detail_user_field2') ) * ldMultiplier * Real(llAllocQty))
		next 
		im_menu.m_file.m_print.Enabled = True
		dw_report.Setfocus()
	Else
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
	

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;//dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
//If Receive Order is Open, default the Order to the current Receive Order Number
If isVAlid(w_ro) Then
	if w_ro.idw_main.RowCOunt() > 0 Then
		This.TriggerEvent('ue_retrieve')
	End If
End If

DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

dw_select.GetChild('ord_typ', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

this.Title="NYX Outbound Order Value Report"
end event

type dw_select from w_std_report`dw_select within w_nyx_outbound_order_value_report
integer x = 14
integer y = 0
integer width = 3840
integer height = 264
string dataobject = "d_nyx_outbound_order_value_report_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;//string 	ls_column
//
//long		ll_row
//
//dw_select.AcceptText()
//ls_column 	= DWO.Name
//ll_row 		= dw_select.GetRow()
//
//CHOOSE CASE ls_column
//		

string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
datawindowChild	ldwc

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
	CASE "order_nbr"
		
			dw_select.SetColumn("order_nbr")
	

		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE "receive_from_date"
		
		IF ib_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("receive_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_sched_from_first = FALSE
			
		END IF
		
	CASE "receive_to_date"
		
		IF ib_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("receive_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_sched_to_first = FALSE
			
		END IF
		
	CASE "complete_from_date"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("complete_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_to_date"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("complete_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
	Case 'supplier_id' /* 11/01 PCONKL - Only retrieve suppliers if clicked on*/
		
		This.GetChild('supplier_id',ldwc)
		If ldwc.RowCOunt() = 0 Then
			ldwc.SetTransObject(SQLCA)
			ldwc.Retrieve(gs_project)
		End If
		
	CASE ELSE
		
END CHOOSE


end event

type cb_clear from w_std_report`cb_clear within w_nyx_outbound_order_value_report
boolean visible = true
integer x = 3881
integer y = 56
end type

type dw_report from w_std_report`dw_report within w_nyx_outbound_order_value_report
integer x = 0
integer y = 260
integer width = 4416
integer height = 1560
integer taborder = 30
string dataobject = "d_nyx_outbound_order_report"
boolean hscrollbar = true
boolean livescroll = false
end type

