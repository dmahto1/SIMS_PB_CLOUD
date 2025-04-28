$PBExportHeader$w_transfer_report_chinese.srw
$PBExportComments$Stock Transfer Report
forward
global type w_transfer_report_chinese from w_std_report
end type
end forward

global type w_transfer_report_chinese from w_std_report
integer width = 3767
integer height = 2044
string title = "Stock Transfer Report"
end type
global w_transfer_report_chinese w_transfer_report_chinese

type variables
String	isOrigSQL
end variables

on w_transfer_report_chinese.create
call super::create
end on

on w_transfer_report_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String lswhcode, &
		lsFromLoc,	&
		lstoLoc,		&
		lsWhere,		&
		lsSKU,		&
		lsNewSQL
		
Long llPos

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

lswhcode = dw_select.GetItemString(1, "wh_code")
lsSKU = dw_select.GetItemString(1, "sku")
lsFromLoc = dw_select.GetItemString(1, "s_loc")
lsToLoc = dw_select.GetItemString(1, "e_loc")

//Always tackon Project
lsWhere = " and project_id = '" + gs_project + "'"

//Tackon Warehouse if Present
If not isnull(lswhCode) and lswhCode > '' Then
	lsWhere += " and s_warehouse = '" + lsWhcode + "'"
End If

//tackon From Location if present
If not isnull(lsFromLoc) and lsFromLoc > '' Then
	lsWhere += " and s_location = '" + lsfromLoc + "'"
End If

//tackon To Location if present
If not isnull(lsToLoc) and lsToLoc > '' Then
	lsWhere += " and d_location = '" + lsToLoc + "'"
End If

//tackon Sku if present
If not isnull(lsSku) and lsSKU > '' Then
	lsWhere += " and sku = '" + lssku + "'"
End If

//From Order date if present
If date(dw_select.GetItemDateTime(1, "from_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "from_date"),'mm-dd-yyyy hh:mm') + "'"
End If

//To Order date if present
If date(dw_select.GetItemDateTime(1, "To_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "to_date"),'mm-dd-yyyy hh:mm') + "'"
End If

//Where clause needs to be added to existing where clause before 'group by'
lsNewSQL = isOrigSQL
llPos = Pos(lsNewSQL,'Group By')
lsNewSQL = Replace(lsNewSQL, (llpos - 1), 1, lsWhere + ' ')
dw_report.SetSQlSelect(lsNewSQL)

SetPointer(Arrow!)
If dw_report.Retrieve() > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If



end event

event resize;dw_report.Resize(workspacewidth() - 65,workspaceHeight()-215)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(sqlca)

If ldwc.Retrieve() > 0 Then
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc.SetFilter(lsFilter)
	ldwc.Filter()
End If

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
end event

type dw_select from w_std_report`dw_select within w_transfer_report_chinese
integer x = 5
integer y = 8
integer width = 3625
integer height = 200
string dataobject = "d_transfer_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_transfer_report_chinese
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_transfer_report_chinese
integer x = 5
integer y = 220
integer width = 3703
integer height = 1584
string dataobject = "d_transfer_report_chinese"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

