$PBExportHeader$w_nycsp_transaction_rpt_by_date.srw
$PBExportComments$+NYCSP Transaction Report by Date
forward
global type w_nycsp_transaction_rpt_by_date from w_std_report
end type
end forward

global type w_nycsp_transaction_rpt_by_date from w_std_report
integer width = 3479
integer height = 1900
string title = "NYCSP Transaction Report"
end type
global w_nycsp_transaction_rpt_by_date w_nycsp_transaction_rpt_by_date

type variables
String isoriqsqldropdown,isOrigRptSql
DatawindowChild idwc_supp,idwc_warehouse
end variables

on w_nycsp_transaction_rpt_by_date.create
call super::create
end on

on w_nycsp_transaction_rpt_by_date.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowChild	ldwc

dw_select.GetChild('supp_code', idwc_supp)
dw_select.GetChild('wh_code', idwc_warehouse)

idwc_warehouse.SetTransObject(sqlca)
idwc_supp.SetTransObject(sqlca)
isoriqsqldropdown = idwc_supp.GetSqlselect()

dw_report.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

idwc_supp.Insertrow(0)

If idwc_warehouse.Retrieve(gs_project) > 0 Then
	dw_select.SetItem(1, "wh_code" , gs_default_wh)
End If

datawindowchild ldw_child

isOrigRptSql = dw_report.Describe("DataWindow.Table.Select")
end event

event ue_retrieve;call super::ue_retrieve;//23-Dec-2013 :Madhu - Added code for all transaction records

String ls_whcode, ls_ord_type
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj
decimal ld_balance
decimal ld_in_count
decimal ld_out_count
decimal ld_old_quantity
decimal ld_difference
decimal ld_quantity, ld_bal
decimal ld_n_bal_qty,ld_n_in_count,ld_n_out_count

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

ls_whcode = dw_select.GetItemString(1, "wh_code")

//Check if a start date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"from_date")) then
	ldt_s = dw_select.GetItemDateTime(1, "from_date")
else
	Messagebox(is_title,"Please enter a valid Starting Date...")
	Return 
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"to_date")) then
	ldt_e = dw_select.GetItemDateTime(1, "to_date")
else
	Messagebox(is_title,"Please enter a valid Ending Date...")
	Return
END IF

dw_report.SetRedraw(False)

ll_cnt = dw_report.Retrieve(gs_project, ls_whcode,ldt_s, ldt_E) 
dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
		ld_balance = 0

	For i = ll_cnt to 1 Step -1		
		ls_ord_type = dw_report.GetItemString(i,"ord_type")
		ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
		ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")				

      // j is defined just for clearity
		//j = i just that the last recored does not exeed the total counts
		//ll_cnt remain constant as it is total count -DGM
			if i = ll_cnt  THEN
				j = i
			Else	
				j = i + 1
			   ld_n_bal_qty =dw_report.GetItemNumber(j, "bal_qty")
				ld_n_in_count 	=  dw_report.GetItemNumber(j, "in_qty")
				ld_n_out_count 	= dw_report.GetItemNumber(j, "out_qty")
			END IF	  
		
	Next
	
	dw_report.Object.t_in_bal.text = string(ld_in_count,"#######.#####")
	dw_report.Object.t_out_bal.text = string(ld_out_count,"#######.#####")		
	
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If

dw_report.SetRedraw(True)
end event

event ue_clear;call super::ue_clear;dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)
If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , gs_default_wh)
End If

end event

type dw_select from w_std_report`dw_select within w_nycsp_transaction_rpt_by_date
integer x = 23
integer y = 4
integer width = 3003
integer height = 192
string dataobject = "d_nycsp_transaction_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;call super::constructor;
//Hide unused Criteria (shared with Stock Movement by SKU Report)
This.Modify("supp_t.visible=false supp_code.visible=false sku_t.visible=false sku.visible=false")
end event

event dw_select::itemchanged;call super::itemchanged;long ll_rtn
String	lsDDSQl

IF dwo.name = 'sku' THEN
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn = 1 THEN 
		this.object.supp_code[row] = i_nwarehouse.ids_sku.object.supp_code[1]
		post f_setfocus(dw_select,row,'s_date')
	ELSEIF ll_rtn > 1 THEN
		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
		idwc_supp.SetSqlSelect(lsDDSQL)
		idwc_supp.Retrieve()
		
	ELSE
		Messagebox(is_title,"Invalid Sku please Re-enter")
		post f_setfocus(dw_select,row,'sku')
		Return 2
	END IF	
END IF	
end event

type cb_clear from w_std_report`cb_clear within w_nycsp_transaction_rpt_by_date
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_nycsp_transaction_rpt_by_date
integer x = 23
integer y = 196
string dataobject = "d_nycsp_transaction_rpt_by_date"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

