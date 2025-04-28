$PBExportHeader$w_random_cyclecount_report.srw
$PBExportComments$Random Cycle Count Report
forward
global type w_random_cyclecount_report from w_std_report
end type
end forward

global type w_random_cyclecount_report from w_std_report
integer width = 3712
integer height = 2044
string title = "Random Cycle Count Report"
end type
global w_random_cyclecount_report w_random_cyclecount_report

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

on w_random_cyclecount_report.create
call super::create
end on

on w_random_cyclecount_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;

string ls_sql 
datetime ldt_date

dw_select.AcceptText()

SetPointer(Hourglass!)

ls_sql = isorigsql

//always add Project
ls_Sql += " and Project_id = '" + gs_project + "'"

//Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	ls_Sql += " and location.wh_code = '" +  dw_select.GetItemString(1,"warehouse") + "'"
end if

//Showing all, counted or not
Choose Case dw_select.GetITemString(1,'Counted_ind')
	Case 'Y' /*Only show Counted or in-progress*/
		ls_sql += " and CC_Rnd_Cnt_Ind in ('Y', 'X')"
	Case 'N'
		ls_sql += " and CC_Rnd_Cnt_Ind in ('N', '')" 
End Choose

//Count Date
ldt_date = dw_select.GetItemDateTime(1,"Count_from_date")
If  Not IsNull(ldt_date) Then
	ls_Sql += " and Location.Last_Rnd_Cycle_Count_Date >= '" +  String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

ldt_date = dw_select.GetItemDateTime(1,"Count_To_date")
If  Not IsNull(ldt_date) Then
	ls_Sql += " and Location.Last_Rnd_Cycle_Count_Date <= '" +  String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
End If

dw_report.SetSqlSelect(ls_sql)
dw_report.Retrieve()

im_menu.m_file.m_print.Enabled = True



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

dw_select.GetChild('warehouse', ldwc)
g.of_set_warehouse_dropdown(ldwc) /*load warehouse from Project warehouse table*/

//Default to Showing all locations
dw_select.SetITem(1,'counted_ind','A')
end event

type dw_select from w_std_report`dw_select within w_random_cyclecount_report
integer x = 18
integer y = 0
integer width = 3634
integer height = 260
string dataobject = "d_random_cycle_count_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_random_cyclecount_report
end type

type dw_report from w_std_report`dw_report within w_random_cyclecount_report
integer x = 5
integer y = 264
integer width = 3575
integer height = 1584
integer taborder = 30
string dataobject = "d_random_cc_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

