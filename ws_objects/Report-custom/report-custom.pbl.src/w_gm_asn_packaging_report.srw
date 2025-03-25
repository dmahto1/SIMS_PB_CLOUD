$PBExportHeader$w_gm_asn_packaging_report.srw
$PBExportComments$GM DEtroit ASN Packaging report
forward
global type w_gm_asn_packaging_report from w_std_report
end type
end forward

global type w_gm_asn_packaging_report from w_std_report
integer width = 3767
integer height = 2044
string title = "GM ASN Packaging Report"
end type
global w_gm_asn_packaging_report w_gm_asn_packaging_report

type variables
String	isOrigSQL
end variables

on w_gm_asn_packaging_report.create
call super::create
end on

on w_gm_asn_packaging_report.destroy
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

//If present, tackon From and To Order/Ship Dates

//Order Number
If dw_Select.GetITemString(1,'order_nbr') > "" Then
	lsWhere += " and Receive_Master.Supp_invoice_No = '" + dw_Select.GetITemString(1,'order_nbr') + "'"
End If

//Rcv Slip Nbr
If dw_Select.GetITemString(1,'rcv_slip_nbr') > "" Then
	lsWhere += " and Receive_Master.Ship_Ref = '" + dw_Select.GetITemString(1,'rcv_slip_nbr') + "'"
End If

//Parent SKU
If dw_Select.GetITemString(1,'parent_sku') > "" Then
	lsWhere += " and Receive_Detail.SKU = '" + dw_Select.GetITemString(1,'parent_Sku') + "'"
End If

//Child SKU
If dw_Select.GetITemString(1,'child_Sku') > "" Then
	lsWhere += " and item_component.sku_child = '" + dw_Select.GetITemString(1,'child_sku') + "'"
End If

//Child Supplier
If dw_Select.GetITemString(1,'child_Supplier') > "" Then
	lsWhere += " and item_component.supp_Code_child = '" + dw_Select.GetITemString(1,'child_Supplier') + "'"
End If

//pkg_type
If dw_Select.GetITemString(1,'pkg_type') > "" Then
	lsWhere += " and item_component.child_package_Type = '" + dw_Select.GetITemString(1,'pkg_type') + "'"
End If

//Contract
If dw_Select.GetITemString(1,'contract') > "" Then
	lsWhere += " and receive_Detail.User_Field3 like '%" + dw_Select.GetITemString(1,'contract') + "%'"
End If

//Order From
If date(dw_select.GetItemDateTime(1, "order_date_from")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.ord_Date >= '" + string(dw_select.GetItemDateTime(1, "order_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If

//Order To
If date(dw_select.GetItemDateTime(1, "order_date_To")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.ord_date <= '" + string(dw_select.GetItemDateTime(1, "order_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If

//Ship From
If date(dw_select.GetItemDate(1, "ship_date_from")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.request_Date >= '" + string(dw_select.GetItemDate(1, "ship_date_from"),'mm-dd-yyyy hh:mm') + "'"
End If

//Ship To
If date(dw_select.GetItemDate(1, "Ship_date_To")) > date('01-01-1900') Then
	lsWhere += " and Receive_master.request_date <= '" + string(dw_select.GetItemDate(1, "ship_date_To"),'mm-dd-yyyy hh:mm') + "'"
End If


//Modify SQL - Where clause needs to be appended to end of existing Where and before "Group BY"

lsNewSql = isorigsql 
lsNewSQL = Replace(lsNewSql,(Pos(lsNewSql, "Group BY") - 1),1,lsWhere + " ")
dw_report.setsqlselect(lsNewsql)

If dw_report.Retrieve() > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

SetPointer(Arrow!)
end event

event resize;dw_report.Resize(workspacewidth() - 40,workspaceHeight()-350)
end event

event ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)



end event

event ue_postopen;call super::ue_postopen;
isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
end event

type dw_select from w_std_report`dw_select within w_gm_asn_packaging_report
integer x = 5
integer y = 8
integer width = 3671
integer height = 300
string dataobject = "d_gm_asn_pkg_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_gm_asn_packaging_report
integer x = 3269
integer y = 0
end type

type dw_report from w_std_report`dw_report within w_gm_asn_packaging_report
integer x = 9
integer y = 340
integer width = 3433
integer height = 1408
string dataobject = "d_gmdat_asn_packing_report"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

