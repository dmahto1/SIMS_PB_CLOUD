HA$PBExportHeader$w_stock_movement_rpt_by_date_chinese.srw
$PBExportComments$Stock Movement Report for All SKU's by Date range
forward
global type w_stock_movement_rpt_by_date_chinese from w_std_report
end type
end forward

global type w_stock_movement_rpt_by_date_chinese from w_std_report
integer width = 3488
integer height = 2044
string title = "Stock Movement Report"
end type
global w_stock_movement_rpt_by_date_chinese w_stock_movement_rpt_by_date_chinese

type variables
DataWindowChild idwc_warehouse,idwc_supp

//boolean ib_movement_from_first
//boolean ib_movement_to_first
//boolean ib_select_sku
//boolean ib_select_date_start
//boolean ib_select_date_end

String	isoriqsqldropdown, isOrigRptSQL
end variables

on w_stock_movement_rpt_by_date_chinese.create
call super::create
end on

on w_stock_movement_rpt_by_date_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_whcode, ls_ord_type
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
if  not isnull(dw_select.GetItemDateTime(1,"s_date")) then
	ldt_s = dw_select.GetItemDateTime(1, "s_date")
else
	Messagebox(is_title,"Please enter a valid Starting Date...")
	Return 
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"e_date")) then
	ldt_e = dw_select.GetItemDateTime(1, "e_date")
else
	Messagebox(is_title,"Please enter a valid Ending Date...")
	Return
END IF

dw_report.SetRedraw(False)

ll_cnt = dw_report.Retrieve(gs_project, ls_whcode,ldt_s, ldt_E) 
//Execute Immediate "ROLLBACK" using SQLCA;
//Execute Immediate "COMMIT" using SQLCA;
dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' $$HEX2$$30522000$$ENDHEX$$' + String(ldt_e,'mm/dd/yyyy hh:mm')
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
//	Select Sum(Avail_Qty + Alloc_Qty + Tfr_Out + wip_qty) Into :ld_balance
//					From content_full (NOLOCK)
//						Where project_id 	= :gs_project and 
//								wh_code 		= :ls_whcode;
//								
//	If sqlca.sqlcode <> 0 Then 
		ld_balance = 0
//	END IF
	
	//dw_report.SetItem(ll_cnt, "bal_qty", ld_balance)
	
//	ll_cnt -= 1

	For i = ll_cnt to 1 Step -1		
		ls_ord_type = dw_report.GetItemString(i,"ord_type")
		
		CHOOSE CASE ls_ord_type
//			CASE "Adjust"
//				//Get the old quantity
//				//Added by DGM For getting the right coulmn in where clause
//				ll_adj = dw_report.Object.adj_no[i]
//					Select quantity, old_quantity Into :ld_quantity,:ld_old_quantity
//					From adjustment (NOLOCK)
//					Where project_id 	= :gs_project and
//							adjust_no = :ll_adj;				
//				//End of Modifications DGM 12/13/00			
//				ld_difference = abs(ld_quantity - ld_old_quantity)
//				
//				IF ld_quantity > ld_old_quantity THEN
//					dw_report.SetItem(i, "in_qty", ld_difference)
//					dw_report.SetItem(i, "out_qty", 0)
//					ld_out_count 	= ld_out_count + 0
//				ELSE
//					dw_report.SetItem(i,"out_qty", ld_difference)
//					dw_report.SetItem(i, "in_qty", 0)
//					ld_in_count 	= ld_in_count + 0
//				END IF
//				ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
//				ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")
//				
				
			CASE "Transfer"
												
				
			CASE ELSE
				ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
				ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")				
		END CHOOSE
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
		  		//dw_report.SetItem(i, "bal_qty", ld_n_bal_qty + 	ld_n_out_count - 	ld_n_in_count)
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

event ue_clear;dw_select.Reset()
dw_report.Reset()
dw_select.InsertRow(0)
If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , gs_default_wh)
End If

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

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

isOrigRptSql = dw_report.Describe("DataWindow.Table.Select")
end event

type dw_select from w_std_report`dw_select within w_stock_movement_rpt_by_date_chinese
integer x = 18
integer width = 3131
string dataobject = "d_stock_movement_rpt_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
//Hide unused Criteria (shared with Stock Movement by SKU Report)
This.Modify("supp_t.visible=false supp_code.visible=false sku_t.visible=false sku.visible=false")

g.of_check_label(this) 
end event

event dw_select::itemchanged;long ll_rtn
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

type cb_clear from w_std_report`cb_clear within w_stock_movement_rpt_by_date_chinese
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_stock_movement_rpt_by_date_chinese
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_stock_movement_rpt_by_date_chinese"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

