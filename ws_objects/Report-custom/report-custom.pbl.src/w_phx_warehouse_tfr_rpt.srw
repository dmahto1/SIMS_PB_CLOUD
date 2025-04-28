$PBExportHeader$w_phx_warehouse_tfr_rpt.srw
$PBExportComments$Phoenix Brands Warehouse Transfer Report
forward
global type w_phx_warehouse_tfr_rpt from w_std_report
end type
end forward

global type w_phx_warehouse_tfr_rpt from w_std_report
integer width = 3648
integer height = 2112
string title = "Phoenix Brands Warehouse Transfer Report"
end type
global w_phx_warehouse_tfr_rpt w_phx_warehouse_tfr_rpt

type variables
string is_origsql
string       is_warehouse_code
string  is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time
boolean ib_order_from_first
boolean ib_order_to_first
end variables

on w_phx_warehouse_tfr_rpt.create
call super::create
end on

on w_phx_warehouse_tfr_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-175)
end event

event ue_retrieve;
long ll_cnt
dateTime	ldtFrom, ldtTo


If dw_select.AcceptText() = -1 Then Return


SetPointer(HourGlass!)
dw_report.Reset()

If isnull(dw_select.GetITemDateTime(1,'order_from_date')) Then
	messagebox(is_title, "From Date is required!",StopSign!)
	Return
End If

If isnull(dw_select.GetITemDateTime(1,'order_to_date')) Then
	messagebox(is_title, "To Date is required!",StopSign!)
	Return
End If

ldtFrom = dw_select.GetITemDateTime(1,'order_from_date')
ldtTo = dw_select.GetITemDateTime(1,'order_to_date')

ll_cnt = dw_report.Retrieve(gs_project,ldtFrom, ldtTo)
IF ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If
	



end event

event open;call super::open;is_OrigSql = dw_report.getsqlselect()


end event

event ue_clear;call super::ue_clear;
dw_select.Reset()
dw_select.InsertRow(0)

dw_report.Reset()
end event

type dw_select from w_std_report`dw_select within w_phx_warehouse_tfr_rpt
integer y = 16
integer width = 2235
integer height = 96
string dataobject = "d_phx_warehouse_tfr_report_Search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;call super::clicked;
String	ls_column
DateTime	ldtFrom, ldtTo

ls_column 	= DWO.Name

CHOOSE CASE ls_column
		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldtFrom = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldtFrom, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldtTo = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldtTo, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
End Choose
end event

event dw_select::constructor;call super::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
end event

type cb_clear from w_std_report`cb_clear within w_phx_warehouse_tfr_rpt
end type

type dw_report from w_std_report`dw_report within w_phx_warehouse_tfr_rpt
integer x = 14
integer y = 132
integer width = 3566
integer height = 1776
string dataobject = "d_phx_warehouse_tfr_rpt"
boolean hscrollbar = true
end type

