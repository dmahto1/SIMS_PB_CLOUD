HA$PBExportHeader$w_cyclecount_adjustment_report.srw
$PBExportComments$Receiving Report
forward
global type w_cyclecount_adjustment_report from w_std_report
end type
end forward

global type w_cyclecount_adjustment_report from w_std_report
integer width = 3712
integer height = 2044
string title = "Cycle Count Adjustment Report"
end type
global w_cyclecount_adjustment_report w_cyclecount_adjustment_report

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

on w_cyclecount_adjustment_report.create
call super::create
end on

on w_cyclecount_adjustment_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;string ls_sku
string ls_warehouse
string ls_owner_cd
string ls_order_status
datetime ld_open_to, ld_open_from

dw_select.AcceptText()

SetPointer(Hourglass!)

//Warehouse
//if  not isnull(dw_select.GetItemString(1,"warehouse")) then
if  not isnull(dw_select.GetItemString(1,"warehouse")) and ( dw_select.GetItemString(1,"warehouse") <> '' ) then
	ls_warehouse = dw_select.GetItemString(1,"warehouse")
else
	setnull(ls_warehouse)
end if

//Sku
//if  not isnull(dw_select.GetItemString(1,"sku")) then
if  not isnull(dw_select.GetItemString(1,"sku")) and (dw_select.GetItemString(1,"sku") <> '' )then
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
//if  not isnull(dw_select.GetItemString(1,"ord_typ")) then
if  not isnull(dw_select.GetItemString(1,"ord_typ")) and (dw_select.GetItemString(1,"ord_typ") <> '' ) then 
	ls_order_status = dw_select.GetItemString(1,"ord_typ")
else
	setnull(ls_order_status)
end if


//Owner Cd
//if  not isnull(dw_select.GetItemString(1,"owner")) then
if  not isnull(dw_select.GetItemString(1,"owner")) and (dw_select.GetItemString(1,"owner") <> '' ) then
	ls_owner_cd = dw_select.GetItemString(1,"owner")
else
	setnull( ls_owner_cd)
end if




dw_report.Retrieve( gs_Project, ls_warehouse, ls_sku, ld_open_from, ld_open_to, ls_order_status, ls_owner_cd)



// LTK 20150807  CC Rollup Code - if the CC was set to rollup data, spread that rolled up data back out
String ls_cc_no, ls_previous_cc_no, ls_filter, ls_unique_processable_cc_no_list[]
long i
n_cc_utils ln_cc_utils
ln_cc_utils = CREATE n_cc_utils

for i = 1 to dw_report.RowCount()
	if dw_report.Object.Cycle_Count_No[ i ] <> ls_previous_cc_no then
		
		// If any of the rollup codes were set to rollup data (contain an 'N')
		if   (NOT IsNull( dw_report.Object.Count1_Rollup_code[ i ] ) and Pos( dw_report.Object.Count1_Rollup_code[ i ], 'N' ) > 0 ) or &
			(NOT IsNull( dw_report.Object.Count2_Rollup_code[ i ] ) and Pos( dw_report.Object.Count2_Rollup_code[ i ], 'N' ) > 0 ) or &
			(NOT IsNull( dw_report.Object.Count3_Rollup_code[ i ] ) and Pos( dw_report.Object.Count3_Rollup_code[ i ], 'N' ) > 0 ) then

			ls_previous_cc_no = dw_report.Object.Cycle_Count_No[ i ]
			ls_unique_processable_cc_no_list[ UpperBound( ls_unique_processable_cc_no_list ) + 1 ] = dw_report.Object.Cycle_Count_No[ i ]

		end if		
	end if
next

dw_report.SetRedraw( FALSE )
for i = 1 to UpperBound( ls_unique_processable_cc_no_list )

	ls_filter = "Cycle_Count_No = '" + ls_unique_processable_cc_no_list[ i ] + "'"
	dw_report.SetFilter( ls_filter )
	dw_report.Filter()
	ln_cc_utils.uf_spread_rolled_up_si_counts( dw_report )

next
if UpperBound( ls_unique_processable_cc_no_list ) > 0 then
	dw_report.SetFilter( "" )
	dw_report.Filter()
end if

if IsValid( ln_cc_utils ) then DESTROY ln_cc_utils

dw_report.SetRedraw( TRUE )
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

//dw_select.GetChild('warehouse', ldwc)
//ldwc.SetTransObject(Sqlca)
//ldwc.Retrieve()
//
////Filter Warehouse dropdown by Current Project
//lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//ldwc.SetFilter(lsFilter)
//ldwc.Filter()

// LTK 20150827  Commented block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
DataWindowChild ldwc_warehouse
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if


dw_select.GetChild('owner', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)


dw_report.GetChild("reason",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'IA')

// LTK 20150406  Pandroa #946, added po_no (project) to report for Pandora, hide for other projects
if gs_project<> 'PANDORA' then
	dw_report.Object.project.visible = FALSE
	dw_report.Object.project_t.visible = FALSE
end if
end event

type dw_select from w_std_report`dw_select within w_cyclecount_adjustment_report
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


end event

type cb_clear from w_std_report`cb_clear within w_cyclecount_adjustment_report
end type

type dw_report from w_std_report`dw_report within w_cyclecount_adjustment_report
integer x = 5
integer y = 264
integer width = 3575
integer height = 1584
integer taborder = 30
string dataobject = "d_cycle_count_adjustment_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

