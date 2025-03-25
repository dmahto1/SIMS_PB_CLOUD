$PBExportHeader$w_3com_a0_rpt.srw
$PBExportComments$3COM A0 Report
forward
global type w_3com_a0_rpt from w_std_report
end type
end forward

global type w_3com_a0_rpt from w_std_report
integer width = 3529
integer height = 2120
string title = "3COM A0 Report"
end type
global w_3com_a0_rpt w_3com_a0_rpt

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time

end variables

on w_3com_a0_rpt.create
call super::create
end on

on w_3com_a0_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;Long	llRowCount
DateTime	ldtFrom, ldtTo

If dw_select.AcceptText() = -1 Then Return

//From/To Dates are required
ldtFrom = dw_select.GetItemDateTime(1,'complete_date_From')
ldtTo = dw_select.GetItemDateTime(1,'complete_date_To')

If isnull(ldtFrom) or isNull(ldtTo) Then
	Messagebox(This.Title,'From and To Dates are required.')
	dw_select.SetFocus()
	dw_select.setColumn('complete_date_From')
	Return
End IF



SetPointer(HourGlass!)
dw_report.Reset()

llRowCount = dw_report.Retrieve(ldtFrom, ldtTo)
		
If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If




end event

type dw_select from w_std_report`dw_select within w_3com_a0_rpt
integer x = 0
integer width = 3067
integer height = 116
string dataobject = "d_3com_mes_reconcil_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name


//Create the locating warehouse name datastore
ids_find_warehouse = CREATE Datastore 
ids_find_warehouse.dataobject = 'd_find_warehouse'
ids_find_warehouse.SetTransObject(SQLCA)
ids_find_warehouse.Retrieve()

ib_first_time = true




end event

type cb_clear from w_std_report`cb_clear within w_3com_a0_rpt
integer x = 3150
integer y = 12
integer width = 297
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_3com_a0_rpt
integer x = 14
integer y = 128
integer width = 3438
integer height = 1740
integer taborder = 30
string dataobject = "d_3com_a0_report"
boolean hscrollbar = true
end type

