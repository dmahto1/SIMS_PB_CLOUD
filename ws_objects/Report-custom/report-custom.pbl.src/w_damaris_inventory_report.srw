$PBExportHeader$w_damaris_inventory_report.srw
$PBExportComments$Damaris Inventory Report
forward
global type w_damaris_inventory_report from w_std_report
end type
end forward

global type w_damaris_inventory_report from w_std_report
integer width = 4462
integer height = 2044
string title = "Damaris Inventory Report"
end type
global w_damaris_inventory_report w_damaris_inventory_report

type variables
String	isOrigSql


end variables

on w_damaris_inventory_report.create
call super::create
end on

on w_damaris_inventory_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;//18-Jan-2013 : Madhu -Added for DUK Report

long ll_cnt

SetPointer(HourGlass!)
dw_report.Reset()

ll_cnt = dw_report.Retrieve(gs_project)
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

end event

event resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight()-5)
end event

type dw_select from w_std_report`dw_select within w_damaris_inventory_report
boolean visible = false
integer x = 9
integer y = 0
integer width = 41
integer height = 36
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;string 	ls_column

long		ll_row

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_nbr"
		
			dw_select.SetColumn("order_nbr")
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_damaris_inventory_report
end type

type dw_report from w_std_report`dw_report within w_damaris_inventory_report
integer x = 5
integer y = 4
integer width = 4416
integer height = 1844
integer taborder = 30
string dataobject = "d_damaris_inventory_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

