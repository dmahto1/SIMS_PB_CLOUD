$PBExportHeader$w_putaway_report.srw
$PBExportComments$Putaway Report
forward
global type w_putaway_report from w_std_report
end type
end forward

global type w_putaway_report from w_std_report
integer width = 4462
integer height = 2044
string title = "Putaway Report"
end type
global w_putaway_report w_putaway_report

type variables
String	isOrigSql


end variables

on w_putaway_report.create
call super::create
end on

on w_putaway_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()



end event

event ue_retrieve;
string ls_order_nbr
string ls_ro_no

long ll_cnt
long ll_number

boolean lb_selection

lb_selection = FALSE
If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_ro_no = w_ro.idw_main.getitemstring(1,"RO_NO")

select supp_invoice_no into :ls_order_nbr from receive_master where ro_no = :ls_ro_no and project_id = :gs_project;

//dw_select.SetItem(1,"order_nbr", ls_order_nbr)

//Remit info is passed to the nested report from paramaters passed from here to main report!

ll_cnt = dw_report.Retrieve(gs_project,ls_ro_no)

//ll_cnt = dw_report.Retrieve()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
//	dw_select.Setfocus()
//	dw_select.SetColumn('order_nbr')
End If

end event

event resize;dw_report.Resize(workspacewidth() - 5,workspaceHeight()-5)
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
Else
	messagebox("K&N Invoice","You must open a Receiving Order before you can print Putaway Report.!")
	close(this)
End If
end event

type dw_select from w_std_report`dw_select within w_putaway_report
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

type cb_clear from w_std_report`cb_clear within w_putaway_report
end type

type dw_report from w_std_report`dw_report within w_putaway_report
integer x = 5
integer y = 4
integer width = 4416
integer height = 1844
integer taborder = 30
string dataobject = "d_receiving_putaway_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

