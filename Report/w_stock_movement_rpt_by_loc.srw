HA$PBExportHeader$w_stock_movement_rpt_by_loc.srw
forward
global type w_stock_movement_rpt_by_loc from w_std_report
end type
end forward

global type w_stock_movement_rpt_by_loc from w_std_report
integer width = 3488
integer height = 2088
string title = "Stock Movement Report By Location"
end type
global w_stock_movement_rpt_by_loc w_stock_movement_rpt_by_loc

type variables
DataWindowChild idwc_warehouse,idwc_supp

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_select_sku
boolean ib_select_date_start
boolean ib_select_date_end

String	isoriqsqldropdown
end variables

on w_stock_movement_rpt_by_loc.create
call super::create
end on

on w_stock_movement_rpt_by_loc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_whcode, ls_sku, ls_ord_type,ls_filter,ls_supp,ls_loc, ls_owner
String ls_lcode,ls_lot_no,ls_serial_no,ls_inv_type,ls_po_no,ls_po_no2, ls_orderno, ls_fromloc, ls_toloc
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj, ll_ownerid
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

//Remove filter if any thing already there
dw_report.SetFilter("")
dw_report.Filter()
dw_report.Object.t_date_range.text = 'None'

ls_whcode = dw_select.GetItemString(1, "wh_code")

ls_loc = dw_select.GetItemString(1, "loc")

ls_supp = dw_select.GetItemString(1, "supp_code")


//Check if sku has been entered
if  not isnull(ls_loc) then
	ib_select_sku = TRUE
else
	ib_select_sku = FALSE
	Messagebox(is_title,"Please enter a valid Location...")
	Return 
END IF

//Check if a start date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"s_date")) then
	ib_select_date_start = TRUE
	ldt_s = dw_select.GetItemDateTime(1, "s_date")
else
	ib_select_date_start = FALSE	
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"e_date")) then
	ib_select_date_end = TRUE
	ldt_e = dw_select.GetItemDateTime(1, "e_date")
else
	ib_select_date_end = FALSE	
END IF

//Check start and end date for any errors prior to retrieving
	IF	((ib_select_date_start = TRUE and ib_select_date_end = FALSE) 	OR &
		 (ib_select_date_end = TRUE and ib_select_date_start = FALSE)  	OR &
		 (ib_select_date_start = FALSE and ib_select_date_end = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Movement Date Range", Stopsign!)
		Return
END IF
//Added by DGM in combination of four dws

dw_report.SetRedraw(False)

ll_cnt = dw_report.Retrieve(gs_project, ls_whcode,ls_loc, ls_supp) /* 05/01 PCONKL - including sku/supplier in retriveal arg instead of filtering*/
IF ib_select_date_start and ib_select_date_end Then
      ls_filter =  "complete_date between  datetime('" +string(ldt_s) +"') and datetime('"+string(ldt_e)+"')"
		dw_report.SetFilter(ls_filter)
		dw_report.Filter()
		dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
 END IF	
 
ll_cnt=dw_report.Rowcount()

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True
	ld_balance = 0
	For i = ll_cnt to 1 Step -1				
		//Jxlim 12/14/2011 BRD #289 Commented out the Case statement for Pandora, not sure why it is there for; however it is producing incorrect total count.
		If gs_project = 'PANDORA' Then
			ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
			ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")				
		Else
			ls_ord_type = dw_report.GetItemString(i,"ord_type")
			CHOOSE CASE ls_ord_type		
				CASE "Transfer"				
				CASE ELSE
					ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
					ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")				
			END CHOOSE
		End if
		//Jxlim 12/14/2011 End of BRD #289

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
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_postopen;call super::ue_postopen;string	lsFilter
DatawindowCHild	ldwc

//Jxlim BRD #289 12/08/2011 Adding Stock Movement report by location for Pandora.
If gs_project = 'PANDORA' Then
	dw_report.dataobject = 'd_stock_movement_rpt_by_loc_pandora'
	dw_report.SetTransObject(SQLCA)
End If

dw_select.GetChild('supp_code', idwc_supp)
dw_select.GetChild('wh_code', idwc_warehouse)

dw_report.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

idwc_warehouse.SetTransObject(sqlca)
idwc_supp.SetTransObject(sqlca)

idwc_supp.Insertrow(0)

//If idwc_warehouse.Retrieve(gs_Project) > 0 Then
//	
////	//Filter Warehouse dropdown by Current Project
////	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
////	idwc_warehouse.SetFilter(lsFilter)
////	idwc_warehouse.Filter()
//
//	dw_select.SetItem(1, "wh_code" , gs_default_wh)
//End If

// LTK 20150922  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("wh_code", idwc_warehouse)
idwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(idwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "wh_code", gs_default_wh)
end if


isoriqsqldropdown = idwc_supp.GetSqlselect()



end event

type dw_select from w_std_report`dw_select within w_stock_movement_rpt_by_loc
integer x = 18
integer width = 3131
string dataobject = "d_stock_movement_rpt_select_by_loc"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_movement_from_first 	= TRUE
ib_movement_to_first 	= TRUE
ib_select_sku 				= FALSE
ib_select_date_start 	= FALSE
ib_select_date_end   	= FALSE
end event

event dw_select::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

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
		
	CASE "e_date"
		
		IF ib_movement_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("e_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_movement_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

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

type cb_clear from w_std_report`cb_clear within w_stock_movement_rpt_by_loc
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_stock_movement_rpt_by_loc
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_stock_movement_rpt_by_loc"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

