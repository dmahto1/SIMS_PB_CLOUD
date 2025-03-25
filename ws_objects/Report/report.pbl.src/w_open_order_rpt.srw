$PBExportHeader$w_open_order_rpt.srw
$PBExportComments$This window is used for reporting the invoice information
forward
global type w_open_order_rpt from w_std_report
end type
end forward

global type w_open_order_rpt from w_std_report
integer width = 4165
integer height = 2216
string title = "Open Order Report"
end type
global w_open_order_rpt w_open_order_rpt

type variables
Datastore ids_find_warehouse
boolean ib_first_time
string is_warehouse_code
string is_warehouse_name
string isOrigSql, is_select
end variables

on w_open_order_rpt.create
call super::create
end on

on w_open_order_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_postopen;call super::ue_postopen;//Jxlim 09/20/2010 New report initiated by Phoenix Brands.
DatawindowChild	ldwc_warehouse
string				lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('wh_code', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "project_id = '" + gs_project + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
//	dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
	dw_select.SetItem(1, "wh_code" ,"")
End If

if gs_project = 'KLONELAB' then
	
	dw_report.dataobject = "d_klone_open_order_report"
	dw_report.SetTransObject(SQLCA)
	
end if

isOrigSQL = dw_report.GetSQlSelect() /*capture original SQL*/


end event

event ue_retrieve;////Jxlim 09/20/2010 New report initiated by Phoenix Brands.
String lswhcode,  ls_invoice_no,	lsWhere, lsNewSQL

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

lswhcode = dw_select.GetItemString(1, "Wh_code")

//Always tackon Project
lsWhere = " and dbo.Delivery_Master.Project_id = '" + gs_Project + "'"

//Tackon Warehouse if Present
If not isnull(lswhCode) and lswhCode > '' Then
	lsWhere += " and dbo.Delivery_Master.Wh_Code = '" + lsWhcode + "'"
End If

//Order nbr (Invoice no)
IF NOT isnull(dw_select.GetItemString(1,"invoice_no")) THEN
	ls_invoice_no = dw_select.GetItemString(1,"invoice_no")
	lsWhere += " and dbo.Delivery_Master.Invoice_no = '" + ls_invoice_no + "'"
END IF

//From Order date if present
If date(dw_select.GetItemDateTime(1, "from_date")) > date('01-01-1900') Then
	lsWhere += lsWhere + " and dbo.Delivery_Master.Schedule_Date >= '" + string(dw_select.GetItemDateTime(1, "from_date"),'mm-dd-yyyy hh:mm') + "'"
End If

//To Order date if present
If date(dw_select.GetItemDateTime(1, "To_date")) > date('01-01-1900') Then
	lsWhere += lsWhere + " and dbo.Delivery_Master.Schedule_Date <= '" + string(dw_select.GetItemDateTime(1, "to_date"),'mm-dd-yyyy hh:mm') + "'"
End If

lsNewSQL = isOrigSQL + lsWhere
dw_report.SetSqlSelect(lsNewSQL)

SetPointer(Arrow!)
If dw_report.Retrieve() > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

lswhcode = ''
end event

type dw_select from w_std_report`dw_select within w_open_order_rpt
integer y = 20
integer width = 3515
integer height = 104
string dataobject = "d_open_order_rpt_select"
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

//ll_row = This.insertrow(0)
ib_first_time = true
end event

type cb_clear from w_std_report`cb_clear within w_open_order_rpt
boolean visible = true
integer x = 3607
integer y = 24
end type

type dw_report from w_std_report`dw_report within w_open_order_rpt
integer y = 132
integer width = 3520
integer height = 1792
string dataobject = "d_open_order_rpt"
boolean hscrollbar = true
end type

