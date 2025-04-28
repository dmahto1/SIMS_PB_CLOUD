$PBExportHeader$w_gmm_outbound_report.srw
$PBExportComments$GMM Outbound Report
forward
global type w_gmm_outbound_report from w_std_report
end type
end forward

global type w_gmm_outbound_report from w_std_report
integer width = 3488
integer height = 2044
string title = "GMM Outbound Customer Order Report"
end type
global w_gmm_outbound_report w_gmm_outbound_report

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_movement_fromSched_first
boolean ib_movement_toSched_first
end variables

on w_gmm_outbound_report.create
call super::create
end on

on w_gmm_outbound_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

//5/00 PCONKL - Default from/to dates to today

//dw_select.SetItem(1,"s_date",today())
//dw_select.SetItem(1,"e_date",today())
//
isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql
DateTime ldt_s, ldt_e
integer li_y
Long ll_balance, i, ll_cnt
boolean lb_where
If dw_select.AcceptText() = -1 Then Return
lb_where = false
SetPointer(HourGlass!)
dw_report.Reset()

ldt_s = dw_select.GetItemDateTime(1, "s_date")
ldt_e = dw_select.GetItemDateTime(1, "e_date")

// 1/01 PCONKL - Always tackon Project
lsWhere = lsWhere + " WHERE delivery_master.Project_id = '" + gs_project + "'"

// 9/02 GAP - Tackon Order Type <> Packaging
lswhere = lsWhere + " and Delivery_Master.Ord_type <> '" + "P" + "'"

//Tackon BOL NBR 
If Not isnull(dw_select.GetiTemString(1,"bol_nbr")) Then
	lsWhere = lsWhere + " and invoice_no = '" + dw_select.GetiTemString(1,"bol_nbr") + "'"
	lb_where = True
End If
	
//Tackon From Order Date
If date(dw_select.GetItemDateTime(1, "s_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "s_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If
	
//Tackon To Order Date
If date(dw_select.GetItemDateTime(1, "e_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "e_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

//Tackon From Sched Date
If date(dw_select.GetItemDateTime(1, "sched_date_from")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and schedule_date >= '" + string(dw_select.GetItemDateTime(1, "sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If
	
//Tackon To Sched Date
If date(dw_select.GetItemDateTime(1, "sched_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and schedule_date <= '" + string(dw_select.GetItemDateTime(1, "sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If


If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere 
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	

ll_cnt = dw_report.Retrieve(ldt_s, ldt_e)
If ll_cnt > 0 Then
//	li_y = integer(dw_report.object.cf_city.Y)
//	Messagebox("",string(li_y))
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-225)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_select.SetFocus()
end event

type dw_select from w_std_report`dw_select within w_gmm_outbound_report
integer x = 9
integer y = 0
integer width = 2921
integer height = 200
string dataobject = "d_gmm_outbound_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;ib_movement_from_first = TRUE
ib_movement_to_first  = TRUE
ib_movement_fromSched_first = TRUE
ib_movement_toSched_first = TRUE
end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("s_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "e_date"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("e_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF

CASE "sched_date_from"
		
		IF ib_movement_fromSched_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("sched_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
		END IF
		
	CASE "sched_date_to"
		
		IF ib_movement_toSched_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("sched_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE
end event

type cb_clear from w_std_report`cb_clear within w_gmm_outbound_report
end type

type dw_report from w_std_report`dw_report within w_gmm_outbound_report
integer x = 0
integer y = 208
integer width = 3401
integer height = 1532
integer taborder = 30
string dataobject = "d_gmm_outbound_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

