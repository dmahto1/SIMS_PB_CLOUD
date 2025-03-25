$PBExportHeader$w_nike_stkmove_rpt.srw
forward
global type w_nike_stkmove_rpt from w_nike_report_ancestor
end type
end forward

global type w_nike_stkmove_rpt from w_nike_report_ancestor
integer width = 4123
integer height = 2020
string title = "Stock Movement Report"
end type
global w_nike_stkmove_rpt w_nike_stkmove_rpt

on w_nike_stkmove_rpt.create
call super::create
end on

on w_nike_stkmove_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;DateTime ld_sdate, ld_edate
Time     lt_stime, lt_etime

lt_stime = 00:00:00
lt_etime = 23:59:59

ld_sdate = DateTime(RelativeDate(Today(), -30), lt_stime)
ld_edate = DateTime(Today(), lt_etime)

dw_query.InsertRow(0)
dw_query.SetItem(1,"s_date",ld_sdate)
dw_query.SetItem(1,"e_date",ld_edate)


// Loading from USer Warehouse Datastore 
DataWindowChild ldwc_warehouse,ldwc_warehouse2

dw_query.GetChild("wh_code_fr", ldwc_warehouse)

ldwc_warehouse.SetTransObject(sqlca)

g.of_set_warehouse_dropdown(ldwc_warehouse)

dw_query.SetITem(1,'wh_code_fr',gs_default_WH)
end event

event ue_retrieve;String   ls_sku, ls_wh_code, ls_descript
Time     lt_stime = 00:00:00, lt_etime = 23:59:59
DateTime ld_sdate, ld_edate
Long     ll_rowcnt, ll_curr
Integer  li_count
Long ll_in,ll_out,ll_bal

Long ll_balance, i

SetPointer(HourGlass!)

If dw_query.AcceptText() = -1 Then Return
dw_report.Reset()

// Checking whether the sku + color + size is valid

ls_sku = dw_query.GetItemString(1, "sku")
ls_wh_code = dw_query.GetItemString(1, "wh_code_fr")

IF IsNull(ls_sku) or Len(Trim(ls_sku)) = 0 THEN
	MessageBox(is_title, "Please enter SKU first!")
	Return
End If

If isNull(ls_wh_code) Then 
	MessageBox(is_title, "Please choose a warehouse first!")
	Return
End If

Select description into :ls_descript
	From item_master
	Where sku = :ls_sku and project_id = :gs_project;
IF Sqlca.Sqlcode <> 0 THEN
	MessageBox(is_title,"Invalid SKU, please enter again!")
	dw_query.SetFocus()
	dw_query.SetColumn("sku")
	Return
END IF

// Getting the dates

ld_sdate = DateTime(dw_query.GetItemDate(1,"s_date"), lt_stime)
ld_edate = DateTime(dw_query.GetItemDate(1,"e_date"), lt_etime)

// caculate current stock
	//Select Sum(avail_qty + alloc_qty) Into :ll_curr 
	//	From Content
	//	Where sku = :ls_sku and wh_code = :ls_wh_code;
Select Sum(Avail_Qty + Alloc_Qty + Tfr_Out) Into :ll_balance
		From content_summary
		Where wh_code = :ls_wh_code and sku = :ls_sku and project_id = :gs_project;
If sqlca.sqlcode <> 0 Then ll_balance = 0
If IsNull(ll_balance) Then ll_balance = 0

dw_report.Object.curr_stk.Text = String(ll_balance)

dw_report.Object.description.Text = f_nike_remove_quote(ls_descript)

ll_rowcnt  = dw_report.Retrieve(gs_project, ld_sdate, ld_edate, ls_sku, ls_wh_code)

IF ll_rowcnt > 0 THEN
	im_menu.m_file.m_print.Enabled = True
	
//	If dw_query.GetItemDate(1,"e_date") < today() Then
//		ll_balance = 0
//		For i = 1 to ll_rowcnt
//			ll_balance -= dw_report.GetItemNumber(i, "out_qty")
//			ll_balance += dw_report.GetItemNumber(i, "in_qty")
//		Next
//	End If
	dw_report.SetItem(ll_rowcnt, "bal_qty", ll_balance)
	ll_rowcnt -= 1
	For i = ll_rowcnt to 1 Step -1

		ll_in = dw_report.GetItemNumber(i + 1, "in_qty")
		ll_out = dw_report.GetItemNumber(i + 1, "out_qty") 
		ll_bal = dw_report.GetItemNumber(i + 1, "bal_qty") 
		
		dw_report.SetItem(i, "bal_qty", dw_report.GetItemNumber(i + 1, "bal_qty") + &
			dw_report.GetItemNumber(i + 1, "out_qty") - &
			dw_report.GetItemNumber(i + 1, "in_qty"))			
	Next
ELSE
	im_menu.m_file.m_print.Enabled = False
	MessageBox(is_title, "No record found!")
END IF
end event

type dw_report from w_nike_report_ancestor`dw_report within w_nike_stkmove_rpt
integer x = 5
integer y = 108
integer width = 4064
integer height = 1692
string dataobject = "d_nike_stk_move"
end type

event dw_report::sqlpreview;call super::sqlpreview;
//MessageBox ("sql", sqlsyntax )
end event

type dw_query from w_nike_report_ancestor`dw_query within w_nike_stkmove_rpt
integer x = 0
integer y = 4
integer width = 3104
integer height = 112
string dataobject = "d_nike_stk_move_search"
end type

