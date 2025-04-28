HA$PBExportHeader$w_stock_movement_rpt_by_boe.srw
$PBExportComments$Stock Movement Report for All SKU's by Date range
forward
global type w_stock_movement_rpt_by_boe from w_std_report
end type
type st_1 from statictext within w_stock_movement_rpt_by_boe
end type
end forward

global type w_stock_movement_rpt_by_boe from w_std_report
integer width = 3488
integer height = 2044
string title = "Stock Movement Report by BOE"
st_1 st_1
end type
global w_stock_movement_rpt_by_boe w_stock_movement_rpt_by_boe

type variables
DataWindowChild idwc_warehouse,idwc_supp


boolean ib_movement_from_first =TRUE
boolean ib_movement_to_first =TRUE
//boolean ib_select_sku
//boolean ib_select_date_start
//boolean ib_select_date_end

String	isoriqsqldropdown, isOrigRptSQL
end variables

on w_stock_movement_rpt_by_boe.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_stock_movement_rpt_by_boe.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_retrieve;String ls_ord_type,ls_boe,ls_newsql, lsWhereReceive, lsWhereDelivery, lsLotHold, lsSKUHold
Datetime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj
decimal ld_balance
decimal ld_in_count
decimal ld_out_count
decimal ld_old_quantity
decimal ld_difference
decimal ld_quantity, ld_bal
decimal ld_n_bal_qty,ld_n_in_count,ld_n_out_count


ib_movement_from_first =False
ib_movement_to_first =False

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()



//Check if a start date has been entered
if  not isnull(dw_select.GetItemDatetime(1,"s_date")) then
	ldt_s = dw_select.GetItemDatetime(1, "s_date")
	dw_report.Modify("from_date_t.Text='" + String(ldt_s,'mm/dd/yyyy') + "'")
Else
	dw_report.Modify("from_date_t.Text=''")
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDatetime(1,"e_date")) then
	ldt_e = dw_select.GetItemDatetime(1, "e_date")
	dw_report.Modify("to_date_t.Text='" + String(ldt_e,'mm/dd/yyyy') + "'")
Else
	dw_report.Modify("To_date_t.Text=''")
END IF


//check  if a BOE# has been entered
if  not isnull(dw_select.GetItemString(1,"boe")) then
	ls_boe = dw_select.GetItemString(1, "boe")
	dw_report.Modify("boe_t.Text='" + ls_boe + "'")
Else
	dw_report.Modify("boe_t.Text=''")
END IF

//We need to tackon whereclause to both receive and delivery where clause (Union)
ls_newSQL = isOrigRptSql

//Always Tackon Project
lsWhereReceive += " and Receive_Master.Project_id = '" + gs_project + "' "
lsWhereDelivery += " and Delivery_MAster.Project_id = '" + gs_project + "' "

//Tackon BOE if PResent
If ls_boe > '' Then
	lsWhereReceive += " and Receive_putaway.Lot_no = '" + ls_boe + "' "
	lsWhereDelivery += " and Delivery_Picking.Lot_no = '" + ls_boe + "' "
End If

//Tackon From Date if Present
If Not isnull(dw_select.GetItemDatetime(1,"s_date")) Then
	lsWhereReceive += " and  receive_Master.complete_Date >= '" + string(dw_select.GetItemDateTime(1,"s_date"),'mm-dd-yyyy hh:mm') + "' "
	lsWhereDelivery += " and  Delivery_Master.complete_Date >= '" + string(dw_select.GetItemDateTime(1,"s_date"),'mm-dd-yyyy hh:mm') + "' "
End If

//Tackon To Date if Present
If Not isnull(dw_select.GetItemDatetime(1,"E_date")) Then
	lsWhereReceive += " and  receive_Master.complete_Date <= '" + string(dw_select.GetItemDateTime(1,"E_date"),'mm-dd-yyyy hh:mm') + "' "
	lsWhereDelivery += " and  Delivery_Master.complete_Date <= '" + string(dw_select.GetItemDateTime(1,"E_date"),'mm-dd-yyyy hh:mm') + "' "
End If

//Add Receive Where Cluase before forst Group By
ls_NewSql = Replace(ls_NewSql,(Pos(Upper(ls_NewSql),'GROUP BY RECEIVE') - 1),1,lsWhereReceive)

//Add Delivery Where Cluase before forst Group By
ls_NewSql = Replace(ls_NewSql,(Pos(Upper(ls_NewSql),'GROUP BY DELIVERY') - 1),1,lsWhereDelivery)

dw_report.SetRedraw(False)

dw_report.SetSQLSelect(ls_newsql)

ll_cnt = dw_report.Retrieve() 

ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True

	
	
	For i = 1 to ll_cnt	

		//Reset balance when Lot (BOE) or SKU Changes - Report will break to a new page
		If dw_report.GetITemString(i,'receive_putaway_lot_no') <> lsLotHold or &
			dw_report.GetITemString(i,'receive_putaway_Sku') <> lsSKUHold Then
			
				ld_balance = 0
				
		End If
		
		lsLotHold = dw_report.GetITemString(i,'receive_putaway_lot_no')
		lsSKUHold = dw_report.GetITemString(i,'receive_putaway_SKU')
		
		ld_in_count 	= dw_report.GetItemNumber(i, "In_qty")
		ld_out_count 	= dw_report.GetItemNumber(i, "out_qty")				

      ld_balance = (ld_balance + ld_in_Count) - ld_Out_Count
		dw_report.SetItem(i, "balance_qty",ld_balance)
			  		
	Next
		
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

event ue_postopen;call super::ue_postopen;
isOrigRptSql = dw_report.Describe("DataWindow.Table.Select")
end event

type dw_select from w_std_report`dw_select within w_stock_movement_rpt_by_boe
integer x = 18
integer width = 3131
string dataobject = "d_stock_movement_rpt_byboe_select"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
datawindowChild	ldwc

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()


CHOOSE CASE ls_column
		
	CASE "s_date"
		
		IF ib_movement_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			
			dw_select.SetColumn("s_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_movement_from_first = FALSE
			
						
		END IF
		dw_select.SetItem(1, "boe" , "")
		
	CASE "e_date"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			
			dw_select.SetColumn("e_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
						
		END IF
		dw_select.SetItem(1, "boe" , "")
	
   CASE "boe"
		 dw_select.SetColumn("s_date")
		 dw_select.SetText("00/00/0000 00:00")
		 dw_select.SetColumn("e_date")
		 dw_select.SetText("00/00/0000 00:00")
		
	
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_stock_movement_rpt_by_boe
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_stock_movement_rpt_by_boe
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_stock_movement_by_boe#"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type st_1 from statictext within w_stock_movement_rpt_by_boe
integer x = 1513
integer y = 108
integer width = 1216
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 134217857
long backcolor = 67108864
string text = "Pls enter the date range or BOE#"
boolean focusrectangle = false
end type

