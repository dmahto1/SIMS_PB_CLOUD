$PBExportHeader$w_marcgt_boh_rpt.srw
$PBExportComments$Marc GT Balance on Hand Report
forward
global type w_marcgt_boh_rpt from w_std_report
end type
end forward

global type w_marcgt_boh_rpt from w_std_report
integer width = 3488
integer height = 2044
string title = "MARC GT Shipment Reconciliation Report"
end type
global w_marcgt_boh_rpt w_marcgt_boh_rpt

type variables

String	 isOrigSQL
end variables

on w_marcgt_boh_rpt.create
call super::create
end on

on w_marcgt_boh_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_whcode, ls_ord_type
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_whcode = dw_select.GetItemString(1, "wh_code")


dw_report.SetRedraw(False)

ll_cnt = dw_report.Retrieve(ls_whcode) 
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
//	Select Sum(Avail_Qty + Alloc_Qty + Tfr_Out + wip_qty) Into :ld_balance
//					From content_full (NOLOCK)
//						Where project_id 	= :gs_project and 
//								wh_code 		= :ls_whcode;
//								
//	If sqlca.sqlcode <> 0 Then 
//		ld_balance = 0
//	END IF
	
	//dw_report.SetItem(ll_cnt, "bal_qty", ld_balance)
	
//	ll_cnt -= 1


Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)
end event

event ue_clear;dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)
//If idwc_warehouse.RowCount() > 0 Then
//	dw_select.SetItem(1, "wh_code" , gs_default_wh)
//End If
//
end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

dw_select.InsertRow(0)

//dw_select.GetChild('wh_code', idwc_warehouse)
//idwc_warehouse.SetTransObject(sqlca)

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

//If idwc_warehouse.Retrieve(gs_project) > 0 Then
//	dw_select.SetItem(1, "wh_code" , gs_default_wh)
//End If

//isOrigRptSql = dw_report.Describe("DataWindow.Table.Select")
end event

event open;call super::open;isOrigSql = dw_report.getsqlselect()

end event

type dw_select from w_std_report`dw_select within w_marcgt_boh_rpt
integer x = 18
integer width = 3131
string dataobject = "d_marcgt_boh_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_clear from w_std_report`cb_clear within w_marcgt_boh_rpt
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;//If idwc_warehouse.RowCount() > 0 Then
//	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
//End If
//
end event

type dw_report from w_std_report`dw_report within w_marcgt_boh_rpt
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_marcgt_boh_rpt"
boolean hsplitscroll = true
end type

