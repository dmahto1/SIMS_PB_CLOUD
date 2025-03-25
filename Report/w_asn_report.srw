HA$PBExportHeader$w_asn_report.srw
$PBExportComments$ASN Report
forward
global type w_asn_report from w_std_report
end type
end forward

global type w_asn_report from w_std_report
integer width = 3607
integer height = 2148
string title = "ASN Report"
end type
global w_asn_report w_asn_report

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time

end variables

on w_asn_report.create
call super::create
end on

on w_asn_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;


is_OrigSql = dw_report.getsqlselect()



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-300)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String lsWhere, &
		 lsNewSql

long llRowCount

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Always Tack on project id 
lswhere = " And project_id = '" + gs_project + "'"

//Tack on Shipment ID if present
If (Not isnull(dw_select.GetITemString(1,'shipment_id'))) and dw_select.GetITemString(1,'shipment_id') > '' Then
	lsWhere += " And asn_header.shipment_id = '" + dw_select.GetITemString(1,'shipment_id') + "'"
End If

//Tack on Carrier if present
If (Not isnull(dw_select.GetITemString(1,'carrier'))) and dw_select.GetITemString(1,'carrier') > '' Then
	lsWhere += " And asn_header.carrier = '" + dw_select.GetITemString(1,'carrier') + "'"
End If

//Tack on awb if present
If (Not isnull(dw_select.GetITemString(1,'awb_bol_nbr'))) and dw_select.GetITemString(1,'awb_bol_nbr') > '' Then
	lsWhere += " And asn_header.awb_bol_nbr = '" + dw_select.GetITemString(1,'awb_bol_nbr') + "'"
End If

//Tack on Shipment Date if present
If dw_select.GetItemDate(1,"shipment_date_from") > date('01-01-1900') Then 
	lsWhere += " and asn_header.shipment_date >= '" + string(dw_select.GetItemDate(1,"shipment_date_from"),'mm-dd-yyyy') + "'"
End If

If dw_select.GetItemDate(1,"shipment_date_to") > date('01-01-1900') Then 
	lsWhere += " and asn_header.shipment_date <= '" + string(dw_select.GetItemDate(1,"shipment_date_to"),'mm-dd-yyyy') + "'"
End If

//Tack on Estimated Arrival Date if present
If dw_select.GetItemDate(1,"est_arrival_date_from") > date('01-01-1900') Then 
	lsWhere += " and asn_header.estimated_Arrival_date >= '" + string(dw_select.GetItemDate(1,"est_arrival_date_from"),'mm-dd-yyyy') + "'"
End If

If dw_select.GetItemDate(1,"est_arrival_date_from") > date('01-01-1900') Then 
	lsWhere += " and asn_header.estimated_Arrival_date <= '" + string(dw_select.GetItemDate(1,"est_arrival_date_from"),'mm-dd-yyyy') + "'"
End If

//Tack on Actual Arrival Date if present
If dw_select.GetItemDate(1,"act_arrival_date_from") > date('01-01-1900') Then 
	lsWhere += " and asn_header.actual_Arrival_date >= '" + string(dw_select.GetItemDate(1,"act_arrival_date_from"),'mm-dd-yyyy') + "'"
End If

If dw_select.GetItemDate(1,"act_arrival_date_from") > date('01-01-1900') Then 
	lsWhere += " and asn_header.actual_Arrival_date <= '" + string(dw_select.GetItemDate(1,"act_arrival_date_from"),'mm-dd-yyyy') + "'"
End If

//Tack on Order Nbr if present
If (Not isnull(dw_select.GetITemString(1,'order_nbr'))) and dw_select.GetITemString(1,'order_nbr') > '' Then
	lsWhere += " And asn_item.order_no = '" + dw_select.GetITemString(1,'order_nbr') + "'"
End If

lsnewsql = is_origsql + lswhere 

dw_report.SetSqlSelect(lsNewSql)

llRowcount = dw_report.Retrieve()
		
If llRowcount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If






end event

event ue_postopen;call super::ue_postopen;

//If Receive Order is Open, show the ASN for That ORder
If isValid(w_ro) Then
	If w_ro.idw_main.RowCOunt() > 0 Then
		dw_select.SetItem(1,'order_nbr',w_ro.idw_main.GetITemString(1,'supp_invoice_no'))
		THis.TriggerEvent('ue_retrieve')
	End If
	
End If

end event

type dw_select from w_std_report`dw_select within w_asn_report
integer x = 0
integer width = 3255
integer height = 264
string dataobject = "d_asn_report_search"
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

type cb_clear from w_std_report`cb_clear within w_asn_report
integer x = 3365
integer y = 8
integer width = 96
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_asn_report
integer x = 23
integer y = 296
integer width = 3515
integer height = 1632
integer taborder = 30
string dataobject = "d_asn_report"
boolean hscrollbar = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

