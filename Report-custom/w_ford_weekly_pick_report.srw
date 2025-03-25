HA$PBExportHeader$w_ford_weekly_pick_report.srw
$PBExportComments$Ford Weekly Picking Report
forward
global type w_ford_weekly_pick_report from w_std_report
end type
end forward

global type w_ford_weekly_pick_report from w_std_report
integer width = 3941
integer height = 2060
string title = "Weekly Pick Complete Report"
end type
global w_ford_weekly_pick_report w_ford_weekly_pick_report

type variables
String	isOrigSQL
end variables

on w_ford_weekly_pick_report.create
call super::create
end on

on w_ford_weekly_pick_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String	lsWhere,	&
			lsNewSQL

DateTime	ldStart, ldEnd

SetPointer(HourGlass!)
dw_report.Reset()

dw_select.AcceptText()


//From
ldStart = dw_select.GetItemDateTime(1, "pick_from")

//End
ldEnd = dw_select.GetItemDateTime(1, "pick_To")

If isnull(ldStart) or isnull(ldEnd) Then
	Messagebox(is_title,'From and To Pick dates are required for this report.')
	dw_select.SetFocus()
	dw_select.SetColumn('pick_from')
	Return
End If

SetPointer(Arrow!)
If dw_report.Retrieve(gs_Project,ldStart,ldEnd) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-200)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/

// prime the dates
datetime pickfrom
datetime pickto
time asec
long theRow
theRow = dw_select.getrow()
asec = time('00:00:01')
pickfrom = datetime(relativedate(today(),-7),asec)
pickto = datetime(today(),now())
dw_select.object.pick_from[theRow] = pickFrom
dw_select.object.pick_to[theRow] = pickto
end event

type dw_select from w_std_report`dw_select within w_ford_weekly_pick_report
integer x = 5
integer y = 8
integer width = 2610
integer height = 96
string dataobject = "d_ford_weekly_pick_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_ford_weekly_pick_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_ford_weekly_pick_report
integer x = 9
integer y = 144
integer width = 3707
integer height = 1640
string dataobject = "d_ford_pick_complete_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

