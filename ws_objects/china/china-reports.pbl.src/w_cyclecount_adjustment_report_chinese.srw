$PBExportHeader$w_cyclecount_adjustment_report_chinese.srw
$PBExportComments$Receiving Report
forward
global type w_cyclecount_adjustment_report_chinese from w_std_report
end type
end forward

global type w_cyclecount_adjustment_report_chinese from w_std_report
integer width = 3712
integer height = 2044
string title = "Cycle Count Adjustment Report"
end type
global w_cyclecount_adjustment_report_chinese w_cyclecount_adjustment_report_chinese

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

on w_cyclecount_adjustment_report_chinese.create
call super::create
end on

on w_cyclecount_adjustment_report_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;

string ls_sku
string ls_warehouse
string ls_owner_cd
string ls_order_status
datetime ld_open_to, ld_open_from

dw_select.AcceptText()

SetPointer(Hourglass!)

//Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	ls_warehouse = dw_select.GetItemString(1,"warehouse")
else
	setnull(ls_warehouse)
end if

//Sku
if  not isnull(dw_select.GetItemString(1,"sku")) then
	ls_sku = dw_select.GetItemString(1,"sku")
else
	setnull(ls_sku)
end if


//Order Date
If Date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
	ld_open_from = 	dw_select.GetItemDateTime(1,"order_from_date")
Else
	setnull( ld_open_from)		
End If


If Date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
	ld_open_to = 	dw_select.GetItemDateTime(1,"order_to_date")
Else
	setnull( ld_open_to)
End If


//Order _Type
if  not isnull(dw_select.GetItemString(1,"ord_typ")) then
	ls_order_status = dw_select.GetItemString(1,"ord_typ")
else
	setnull(ls_order_status)
end if


//Owner Cd
if  not isnull(dw_select.GetItemString(1,"owner")) then
	ls_owner_cd = dw_select.GetItemString(1,"owner")
else
	setnull( ls_owner_cd)
end if




dw_report.Retrieve( gs_Project, ls_warehouse, ls_sku, ld_open_from, ld_open_to, ls_order_status, ls_owner_cd)





end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()


dw_select.GetChild('owner', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)


dw_report.GetChild("reason",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'IA')

end event

type dw_select from w_std_report`dw_select within w_cyclecount_adjustment_report_chinese
integer x = 18
integer y = 0
integer width = 3634
integer height = 260
string dataobject = "d_cycle_count_adjustment_rpt_select"
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

g.of_check_label(this) 
end event

type cb_clear from w_std_report`cb_clear within w_cyclecount_adjustment_report_chinese
end type

type dw_report from w_std_report`dw_report within w_cyclecount_adjustment_report_chinese
integer x = 5
integer y = 264
integer width = 3575
integer height = 1584
integer taborder = 30
string dataobject = "d_cycle_count_adjustment_rpt_chinese"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

