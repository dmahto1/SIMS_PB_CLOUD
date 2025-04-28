$PBExportHeader$w_cis_location_617_report.srw
$PBExportComments$Print CIS location 617 Report
forward
global type w_cis_location_617_report from w_std_report
end type
end forward

global type w_cis_location_617_report from w_std_report
integer width = 3488
integer height = 2044
string title = "CIS Manual Receiving Report (loc 617)"
end type
global w_cis_location_617_report w_cis_location_617_report

type variables
DataWindowChild idwc_warehouse
string	isOrigsql
end variables

on w_cis_location_617_report.create
call super::create
end on

on w_cis_location_617_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
//5/00 PCONKL - Default from/to dates to today

//dw_select.SetItem(1,"s_date",today())
//dw_select.SetItem(1,"e_date",today())

isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql
Long ll_balance, i, ll_cnt
Boolean lb_where
If dw_select.AcceptText() = -1 Then Return
lb_where = False
SetPointer(HourGlass!)
dw_report.Reset()

lsWhere = ''

//always tackon Project
lsWhere += " and project_id = '" + gs_project + "'"

//Tackon BOL NBR to sql if present 
If Not isnull(dw_select.GetiTemString(1,"bol_nbr")) Then
	lsWhere = lsWhere + " and supp_Invoice_No = '" + dw_select.GetiTemString(1,"bol_nbr") + "'"
	lb_where = True
End If

//Tackon From Recv Date
If date(dw_select.GetItemDateTime(1, "s_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and arrival_date >= '" + string(dw_select.GetItemDateTime(1, "s_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
	lb_where = True
End If
	
// To Rcv Date
If date(dw_select.GetItemDateTime(1, "e_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and arrival_date <= '" + string(dw_select.GetItemDateTime(1, "e_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1, "order_date_from")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "order_date_from"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If
	
// To Order Date
If date(dw_select.GetItemDateTime(1, "order_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "order_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = True
End If

	
If lsWhere > '  ' Then
	lsNewSql = isOrigSql + lsWhere 
	dw_report.setsqlselect(lsNewsql)
Else
	dw_report.setsqlselect(isOrigSql)
End If

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



end event

event resize;dw_report.Resize(workspacewidth() - 75,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.insertrow(0)
dw_select.SetFocus()
end event

type dw_select from w_std_report`dw_select within w_cis_location_617_report
integer x = 14
integer y = 8
integer width = 2711
integer height = 192
string dataobject = "d_receive_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_cis_location_617_report
end type

type dw_report from w_std_report`dw_report within w_cis_location_617_report
integer x = 14
integer y = 212
integer width = 3401
integer height = 1644
integer taborder = 30
string dataobject = "d_cis_617_receiving_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

