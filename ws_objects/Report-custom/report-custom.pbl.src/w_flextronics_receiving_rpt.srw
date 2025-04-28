$PBExportHeader$w_flextronics_receiving_rpt.srw
$PBExportComments$Receiving Report
forward
global type w_flextronics_receiving_rpt from w_std_report
end type
end forward

global type w_flextronics_receiving_rpt from w_std_report
integer width = 3712
integer height = 2044
string title = "Receiving Report"
end type
global w_flextronics_receiving_rpt w_flextronics_receiving_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
end variables

on w_flextronics_receiving_rpt.create
call super::create
end on

on w_flextronics_receiving_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql, ls_from_date, ls_to_date
DateTime ldFromDate, ldTodate
Long ll_balance, i, ll_cnt
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
//lsWhere += " and receive_master.Project_id = '" + gs_project + "'"
//
////Tackon Warehouse
//if  not isnull(dw_select.GetItemString(1,"warehouse")) then
//	lswhere += " and Receive_Master.wh_code = '" + dw_select.GetItemString(1,"warehouse") + "'"
//	lb_where = TRUE
//end if
//
////Tackon BOL Nbr
//if  not isnull(dw_select.GetItemString(1,"bol_nbr")) then
//	lswhere += " and Receive_Master.Supp_Invoice_No like '%" + dw_select.GetItemString(1,"bol_nbr") + "%'"
//	lb_where = TRUE
//end if
//
////Tackon supplier
//if  not isnull(dw_select.GetItemString(1,"supplier_id")) then
//	lswhere += " and Receive_Master.Supp_Code = '" + dw_select.GetItemString(1,"supplier_id") + "'"
//	lb_where = TRUE
//end if
//
////Tackon receive slip
//if  not isnull(dw_select.GetItemString(1,"ship_ref_nbr")) then
//	lswhere += " and Receive_Master.Ship_Ref = '" + dw_select.GetItemString(1,"ship_ref_nbr") + "'"
//	lb_where = TRUE
//end if
//
////Tackon From Order Date
//If Date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
//		lsWhere = lsWhere + " and Receive_Master.ORD_DATE >= '" + string(dw_select.GetItemDateTime(1,"order_from_date"),'mm-dd-yyyy hh:mm') + "'"
//		//ls_from_date = string(dw_select.GetItemDateTime(1,"order_from_date"),'mm/dd/yyyy hh:mm ') 
//		lb_order_from = TRUE
//		lb_where = TRUE
//End If
//
////Tackon To Order Date - bump by 1 and check for less than to account for time
//If Date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
//		//ldToDate = relativeDate(dw_select.GetItemDate(1,"order_to_date"),1)
//		lsWhere = lsWhere + " and Receive_Master.ORD_DATE <= '" + string(dw_select.GetItemDateTime(1,"order_to_date"),'mm-dd-yyyy hh:mm') + "'"
//		//dw_report.Object.t_order_date.text = ls_from_date + " - " + &
//		//string(dw_select.GetItemDateTime(1,"order_to_date"),"mm/dd/yyyy hh:mm ")
//		lb_order_to = TRUE
//		lb_where = TRUE
//End If
//
////Tackon From receive Date
//If Date(dw_select.GetItemDateTime(1,"receive_from_date")) > date('01-01-1900') Then
//		lsWhere = lsWhere + " and  Receive_Master.Arrival_Date >= '" + string(dw_select.GetItemDateTime(1,"receive_from_date"),'mm-dd-yyyy hh:mm') + "'"
//		//ls_from_date = string(dw_select.GetItemDateTime(1,"receive_from_date"),'mm/dd/yyyy hh:mm ') 
//		lb_sched_from = TRUE
//		lb_where = TRUE
//End If
//
////Tackon To Receive Date - bump by 1 and check for less than to account for time
//If Date(dw_select.GetItemDateTime(1,"receive_to_date")) > date('01-01-1900') Then
//		//ldToDate = relativeDate(dw_select.GetItemDate(1,"receive_to_date"),1)
//		lsWhere = lsWhere + " and  Receive_Master.Arrival_Date <= '" + string(dw_select.GetItemDateTime(1,"receive_to_date"),'mm-dd-yyyy hh:mm') + "'"
//		//dw_report.Object.t_receive_date.text = ls_from_date + " - " + &
//		//string(dw_select.GetItemDateTime(1,"receive_to_date"),"mm/dd/yyyy hh:mm ")
//		lb_sched_to = TRUE
//		lb_where = TRUE
//End If

//Tackon From complete Date
If date(dw_select.GetItemDateTime(1,"complete_from_date")) > date('01-01-1900') Then
		//ldFromDate =Date(dw_select.GetItemDate(1,"complete_from_date"),1)
		lsWhere = lsWhere + " and  Receive_Master.complete_Date >= '" + string(dw_select.GetItemDateTime(1,"complete_from_date"),'mm-dd-yyyy hh:mm') + "'"
		//ls_from_date = string(dw_select.GetItemDateTime(1,"complete_from_date"),'mm/dd/yyyy hh:mm ') 		
		lb_complete_from = TRUE
		lb_where = TRUE
End If

//Tackon To complete Date - bump by 1 and check for less than to account for time
If Date(dw_select.GetItemDateTime(1,"complete_to_date")) > date('01-01-1900') Then			
	//	ldToDate = relativeDate(dw_select.GetItemDate(1,"complete_to_date"),1)
		lsWhere = lsWhere + " and  Receive_Master.complete_Date <= '" + string(dw_select.GetItemDateTime(1,"complete_to_date"),'mm-dd-yyyy hh:mm') + "'"
		//ls_to_date = string(dw_select.GetItemDateTime(1,"complete_to_date"),'mm/dd/yyyy hh:mm ') 
		//dw_report.Object.t_complete_date.text = ls_from_date + " - " + &
		//string(dw_select.GetItemDateTime(1,"complete_to_date"),"mm/dd/yyyy hh:mm ")
		lb_complete_to = TRUE
		lb_where = TRUE
End If

//
////Ord_Typ
//if  not isnull(dw_select.GetItemString(1,"ord_typ")) then
//	lswhere += " and Receive_Master.Ord_Type = '" + dw_select.GetItemString(1,"ord_typ") + "'"
//	lb_where = TRUE
//end if
//
//if  not isnull(dw_select.GetItemString(1,"owner")) then
//	
//	
//	lswhere += " and Receive_Detail.Owner_ID = " + dw_select.GetItemString(1,"owner")
//	lb_where = TRUE
//	
//end if

If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere 
	//MESSAGEBOX("LS NEWSQL", LSNEWSQL)
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If

dw_report.SetRedraw(False)

ldFromDate = dw_select.GetItemDateTime(1, "complete_from_date")
ldToDate = dw_select.GetItemDateTime(1, "complete_to_date")

dw_report.Object.t_date_range.text = String(ldFromDate, 'mm/dd/yyyy hh:mm') + ' To ' + String(ldTodate, 'mm/dd/yyyy hh:mm')

dw_report.SetRedraw(False)

//Check Complete Date range for any errors prior to retrieving
IF 	((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
		 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
		 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the From\To in Complete Date Range", Stopsign!)
		Return
END IF	

//If no seach is entered
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	

ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If


dw_report.SetRedraw(True)
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;//DatawindowChild	ldwc
//String	lsFilter
//
////populate dropdowns - not done automatically since dw not being retrieved
//
//dw_select.GetChild('warehouse', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve()
//
////Filter Warehouse dropdown by Current Project
//lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//ldwc.SetFilter(lsFilter)
//ldwc.Filter()
//
//dw_select.GetChild('ord_typ', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve(gs_project)
//
//dw_select.GetChild('owner', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve(gs_project)
end event

type dw_select from w_std_report`dw_select within w_flextronics_receiving_rpt
integer x = 0
integer y = 8
integer width = 3634
integer height = 108
string dataobject = "d_flextronics_receiving_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
datawindowChild	ldwc

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
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

event dw_select::constructor;
ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
ib_sched_from_first 		= TRUE
ib_sched_to_first 		= TRUE
ib_complete_from_first 	= TRUE
ib_complete_to_first 	= TRUE


end event

type cb_clear from w_std_report`cb_clear within w_flextronics_receiving_rpt
integer x = 2629
integer y = 8
end type

type dw_report from w_std_report`dw_report within w_flextronics_receiving_rpt
integer x = 14
integer y = 128
integer width = 3575
integer height = 1572
integer taborder = 30
string dataobject = "d_flextronics_receiving_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

