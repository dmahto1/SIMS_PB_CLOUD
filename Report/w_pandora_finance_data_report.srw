HA$PBExportHeader$w_pandora_finance_data_report.srw
$PBExportComments$Pandora Finance Data Report
forward
global type w_pandora_finance_data_report from w_std_report
end type
end forward

global type w_pandora_finance_data_report from w_std_report
integer width = 4613
integer height = 2288
string title = "Finance Data Report"
end type
global w_pandora_finance_data_report w_pandora_finance_data_report

type variables
String	is_OrigSql
string       is_select
string       is_groupby
string       is_warehouse_code
string       is_warehouse_name
datastore ids_find_warehouse
boolean ib_first_time, ib_from_date_first, ib_to_date_first

end variables

forward prototypes
public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing)
end prototypes

public function integer wf_new_rw_return_row (ref datastore returns_dw, long report_row, long return_row, integer ageing);

dw_report.SetItem(report_row, "content_summary_project_id", returns_dw.GetItemString( return_row, "content_summary_project_id"))
dw_report.SetItem(report_row, "content_summary_wh_code", returns_dw.GetItemString( return_row, "content_summary_wh_code"))
dw_report.SetItem(report_row, "content_summary_supp_code", returns_dw.GetItemString( return_row, "content_summary_supp_code"))
dw_report.SetItem(report_row, "supp_name", returns_dw.GetItemString( return_row, "supp_name"))
dw_report.SetItem(report_row, "content_summary_sku", returns_dw.GetItemString( return_row, "content_summary_sku"))
dw_report.SetItem(report_row, "item_master_alternate_sku", returns_dw.GetItemString( return_row, "item_master_alternate_sku"))
dw_report.SetItem(report_row, "item_master_description", returns_dw.GetItemString( return_row, "item_master_description"))
dw_report.SetItem(report_row, "item_master_std_cost", returns_dw.GetItemDecimal( return_row, "item_master_std_cost"))
dw_report.SetItem(report_row, "project_name", returns_dw.GetItemString( return_row, "project_name"))
dw_report.SetItem(report_row, "avail_qty", returns_dw.GetItemDecimal( return_row, "avail_qty"))
dw_report.SetItem(report_row, "season_code", returns_dw.GetItemString( return_row, "season_code"))
dw_report.SetItem(report_row, "brand", returns_dw.GetItemString( return_row, "brand"))	
dw_report.SetItem(report_row, "sub_category", returns_dw.GetItemString( return_row, "sub_category"))
dw_report.SetItem(report_row, "gender_category", returns_dw.GetItemString( return_row, "gender_category"))
dw_report.SetItem(report_row, "product_attribute", returns_dw.GetItemString( return_row, "product_attribute"))
dw_report.SetItem(report_row, "ageing", ageing)
dw_report.SetItem(report_row, "content_summary_cost_price", returns_dw.GetItemString( return_row, "content_summary_cost_price"))
//dw_report.SetItem(report_row, "order_type", returns_dw.GetItemString( return_row, "order_type"))

Return 0
end function

on w_pandora_finance_data_report.create
call super::create
end on

on w_pandora_finance_data_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Integer  li_pos

is_OrigSql = dw_report.getsqlselect()
//messagebox("is origsql",is_origsql)
li_pos = pos(is_origsql,"GROUP BY",1)
//is_groupby = mid(is_origsql,794)
is_groupby = mid(is_origsql,li_pos)
IF li_pos > 0 THEN li_pos=li_pos - 1
//is_select = mid(is_origsql,1,793)
is_select = mid(is_origsql,1,li_pos)
is_OrigSql = dw_report.getsqlselect()


end event

event resize;dw_report.Resize(workspacewidth() - 15,workspaceHeight()-300)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;
DateTime ldt_date
String ls_string, ls_where, ls_sql 
Boolean  lb_complete_from, lb_complete_to

//Initialize Date Flags
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_sql = is_OrigSql
ls_where = ''


ldt_date = dw_select.GetItemDateTime(1,"finance_data_from_date")
If  Not IsNull(ldt_date) Then
	ls_where = "  WHERE complete_date >= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_complete_from = TRUE		
End If

ldt_date = dw_select.GetItemDateTime(1,"finance_data_to_date")
If  Not IsNull(ldt_date) Then
	ls_where += " and complete_date <= '" + &
		String(ldt_date, "mm/dd/yyyy hh:mm") + "' "
	lb_complete_to = TRUE	
End If

//Check Complete Date range for any errors prior to retrieving
IF ((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
	 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
	 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
	Return
END IF

ls_sql += ls_where
dw_report.SetSqlSelect(ls_sql)

If dw_report.Retrieve() = 0 Then
	messagebox(is_title,"No record found!")
	im_menu.m_file.m_print.Enabled = False
Else 
	im_menu.m_file.m_print.Enabled = True
End If
		



end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc_warehouse, ldwc
string	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('inv_type', ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve()
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()
	
dw_select.GetChild('owner_cd', ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project)

dw_select.GetChild('warehouse', ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
If ldwc_warehouse.Retrieve(gs_project) > 0 Then
	
	//Filter Warehouse dropdown by Current Project
	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
	ldwc_warehouse.SetFilter(lsFilter)
	ldwc_warehouse.Filter()
	
//	If ldwc_warehouse.RowCount() > 0 Then
//		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
//	End If
	
End If


end event

type dw_select from w_std_report`dw_select within w_pandora_finance_data_report
integer x = 0
integer width = 1211
integer height = 200
string dataobject = "d_pandora_financial_data_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value

ib_first_time = true
ib_from_date_first 		= TRUE
ib_to_date_first 		= TRUE





end event

event dw_select::clicked;call super::clicked;string 	ls_column
DatawindowChild	ldwc
long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "finance_data_from_date"
		
		IF ib_from_date_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("finance_data_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_from_date_first = FALSE
			
		END IF
		
	CASE "finance_data_to_date"
		
		IF ib_to_date_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("finance_data_from_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_to_date_first = FALSE
			
		END IF
		
	
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_pandora_finance_data_report
boolean visible = true
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;dw_report.reset()
end event

type dw_report from w_std_report`dw_report within w_pandora_finance_data_report
integer x = 5
integer y = 256
integer width = 4558
integer height = 1672
integer taborder = 30
boolean titlebar = true
string dataobject = "d_export_pandora_financial_data2"
boolean hscrollbar = true
boolean resizable = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

