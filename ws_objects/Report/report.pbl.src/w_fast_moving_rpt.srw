$PBExportHeader$w_fast_moving_rpt.srw
$PBExportComments$Fast Moving Report
forward
global type w_fast_moving_rpt from w_std_report
end type
end forward

global type w_fast_moving_rpt from w_std_report
integer width = 3488
integer height = 2044
string title = "Fast Moving Report"
end type
global w_fast_moving_rpt w_fast_moving_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first
end variables

on w_fast_moving_rpt.create
call super::create
end on

on w_fast_moving_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()





end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql, lsFilter, lsGroup, ls_from_date, ls_to_date
DateTime ldFromDate, ldtodate
Long ll_balance, i, ll_cnt

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_whcode = dw_select.GetItemstring(1,"warehouse")
lsgroup = dw_select.GetItemstring(1,"group")

ldFromDate = dw_select.GetItemDateTime(1,"order_from_date")
//ls_from_date = string(dw_select.GetItemDateTime(1,"order_from_date"),"mm/dd/yyyy hh:mm ")

ldtoDate = dw_select.GetItemDateTime(1,"order_to_date")
//ls_to_date = string(dw_select.GetItemDateTime(1,"order_to_date"),"mm/dd/yyyy hh:mm ")

string ls_supp_code

ls_supp_code = dw_select.GetItemString(1,"supp_code")

IF trim(ls_supp_code) = "" OR IsNull(ls_supp_code) THEN
	SetNull(ls_supp_code)
END IF

IF trim(lsgroup) = "" OR IsNull(lsgroup) THEN
	SetNull(lsgroup)
END IF

//or isnull(lsGroup)

// 01/01 PCONKL - All search fields are required
If isNull(ls_whcode) or isnull(ldFromDate) or isnull(ldToDate) Then
	Messagebox(is_title,"Warehouse, From & To Date must be entered for this report!")
	Return
End If

ll_cnt = dw_report.Retrieve(gs_project,ls_whcode,lsgroup,ldfromdate,ldtodate,ls_supp_code)

If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
	
	//filter to show rows if requested
	If dw_select.GetItemNumber(1,"number_to_show") > 0 Then
		lsFilter = "c_rownum <= " + String(dw_select.GetItemNumber(1,"number_to_show"))
		dw_report.SetFilter(lsFilter)
		dw_report.Filter()
	End If
	
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-270)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
// pvh - 08/09/05 
ib_order_from_first = TRUE
ib_order_to_first = TRUE




end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
string	lsFilter

//populate dropdowns 

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "project_id = '" + gs_project + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

dw_select.GetChild('group', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()
lsFilter = "project_id = '" + gs_project + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()
end event

type dw_select from w_std_report`dw_select within w_fast_moving_rpt
integer x = 0
integer y = 0
integer width = 3310
integer height = 224
string dataobject = "d_fastmovng_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_from_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("order_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "order_to_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("order_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_fast_moving_rpt
end type

type dw_report from w_std_report`dw_report within w_fast_moving_rpt
integer x = 9
integer y = 224
integer width = 3401
integer height = 1544
integer taborder = 30
string dataobject = "d_fast_moving_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

