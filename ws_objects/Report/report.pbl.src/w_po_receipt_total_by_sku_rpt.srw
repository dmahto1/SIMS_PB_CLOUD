$PBExportHeader$w_po_receipt_total_by_sku_rpt.srw
$PBExportComments$Consolidation Carrier Manifest Report
forward
global type w_po_receipt_total_by_sku_rpt from w_std_report
end type
end forward

global type w_po_receipt_total_by_sku_rpt from w_std_report
integer width = 3602
integer height = 1800
string title = "PO Receipt total by SKU"
end type
global w_po_receipt_total_by_sku_rpt w_po_receipt_total_by_sku_rpt

type variables
String	isOrigSQL
end variables

on w_po_receipt_total_by_sku_rpt.create
call super::create
end on

on w_po_receipt_total_by_sku_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_report.Reset()
dw_Select.InsertRow(0)
dw_Select.SetItem(1,'wh_code',gs_default_wh)
end event

event resize;call super::resize;dw_select.Reset()
dw_Select.InsertRow(0)
dw_Select.SetItem(1,'wh_code',gs_default_wh)
end event

event ue_postopen;call super::ue_postopen;DatawindowChild	Ldwc
isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/
ib_saveasascii = True

//populate warehouse dropdown
dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

//populate Receive Order Type dropdown
dw_select.GetChild('ord_type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_project)

dw_Select.SetItem(1,'wh_code',gs_default_wh)


end event

event ue_retrieve;call super::ue_retrieve;		
String	lsWhere,	&
			lsNewSQL


SetPointer(Hourglass!)
w_main.SetMicrohelp('Retrieving Report data...')

dw_select.AcceptText()

//Always Tack on Project ID 
lswhere = " and Receive_master.project_id = '" + gs_project + "'"

//Tackon Warehouse if PResent
If Not isnull(dw_Select.GetITemString(1,'wh_code')) Then
	lsWhere += " and Receive_master.Wh_code = '" + dw_Select.GetITemString(1,'wh_code') + "'"
ELSE
	Messagebox("Warning","Please Select Wharehouse..")
	Return
End If

//Tackon Order Nbr if PResent
If Not isnull(dw_Select.GetITemString(1,'order_no')) Then
	lsWhere += " and Receive_master.supp_invoice_no = '" + dw_Select.GetITemString(1,'order_no') + "'"
ELSE
	Messagebox("Warning","Please enter Order number..")
	Return
End If

////Tackon Order Type if PResent
//If Not isnull(dw_Select.GetITemString(1,'ord_Type')) Then
//	lsWhere += " and Receive_master.ord_type = '" + dw_Select.GetITemString(1,'Ord_type') + "'"
//End If
//
////Tackon Order Status if PResent
//If Not isnull(dw_Select.GetITemString(1,'ord_status')) Then
//	lsWhere += " and Receive_master.ord_status = '" + dw_Select.GetITemString(1,'Ord_status') + "'"
//End If
//
//Tackon From Order Date
//If date(dw_select.GetItemDateTime(1, "ord_date_from")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and ord_date >= '" + string(dw_select.GetItemDateTime(1, "ord_date_from"),'mm-dd-yyyy hh:mm') + "'"
//End If
	
////Tackon To Order Date
//If date(dw_select.GetItemDateTime(1, "ord_date_to")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and ord_date <= '" + string(dw_select.GetItemDateTime(1, "ord_date_to"),'mm-dd-yyyy hh:mm') + "'"
//End If
//
////Tackon From Complete Date
//If date(dw_select.GetItemDateTime(1, "comp_date_from")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and complete_date >= '" + string(dw_select.GetItemDateTime(1, "comp_date_from"),'mm-dd-yyyy hh:mm') + "'"
//End If
//	
////Tackon To Complete Date
//If date(dw_select.GetItemDateTime(1, "comp_date_to")) > date('01-01-1900') Then
//	lsWhere = lsWhere + " and complete_date <= '" + string(dw_select.GetItemDateTime(1, "comp_date_to"),'mm-dd-yyyy hh:mm') + "'"
//End If

//Modify SQL
lsNewSql = isorigsql + lsWhere 
dw_report.setsqlselect(lsNewsql)

If dw_report.Retrieve(gs_Project) > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

SetPointer(Arrow!)
w_main.SetMicrohelp('Ready')
end event

type dw_select from w_std_report`dw_select within w_po_receipt_total_by_sku_rpt
integer width = 3442
integer height = 108
string dataobject = "d_po_receive_tot_by_sku_rpt_search"
end type

type cb_clear from w_std_report`cb_clear within w_po_receipt_total_by_sku_rpt
end type

type dw_report from w_std_report`dw_report within w_po_receipt_total_by_sku_rpt
integer x = 23
integer y = 128
integer width = 3456
string dataobject = "d_po_receive_tot_by_sku_rpt"
end type

