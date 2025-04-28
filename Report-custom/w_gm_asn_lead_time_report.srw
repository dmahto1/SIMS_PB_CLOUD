HA$PBExportHeader$w_gm_asn_lead_time_report.srw
$PBExportComments$GM Detroit ASN Supplier Lead Time report
forward
global type w_gm_asn_lead_time_report from w_std_report
end type
end forward

global type w_gm_asn_lead_time_report from w_std_report
integer width = 3767
integer height = 2044
string title = "GM ASN Lead Time Report"
end type
global w_gm_asn_lead_time_report w_gm_asn_lead_time_report

type variables
String	isOrigSQL
end variables

on w_gm_asn_lead_time_report.create
call super::create
end on

on w_gm_asn_lead_time_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String	lsWhere,	&
			lsNewSQL


SetPointer(HourGlass!)
dw_report.Reset()

dw_select.AcceptText()

//Always Tack on Project ID 
lswhere = " and Receive_master.project_id = '" + gs_project + "'"


//Ship From
If date(dw_select.GetItemDate(1, "ship_date_from")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.request_Date >= '" + string(dw_select.GetItemDate(1, "ship_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If

//Ship To
If date(dw_select.GetItemDate(1, "Ship_date_To")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.request_date <= '" + string(dw_select.GetItemDate(1, "ship_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If

//Supplier
If dw_Select.GetITemString(1,'supp_Code') > "" Then
	lsWhere += " and Receive_Master.Supp_Code = '" + dw_Select.GetITemString(1,'supp_Code') + "'"
End If

//Modify SQL

lsNewSql = isorigsql + lsWhere
dw_report.setsqlselect(lsNewsql)

If dw_report.Retrieve() > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

SetPointer(Arrow!)
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-250)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;
isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
end event

type dw_select from w_std_report`dw_select within w_gm_asn_lead_time_report
integer x = 5
integer y = 8
integer width = 3671
integer height = 188
string dataobject = "d_gm_asn_lead_time_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_gm_asn_lead_time_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_gm_asn_lead_time_report
integer x = 9
integer y = 220
integer width = 3433
integer height = 1408
string dataobject = "d_gm_asn_lead_time_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

