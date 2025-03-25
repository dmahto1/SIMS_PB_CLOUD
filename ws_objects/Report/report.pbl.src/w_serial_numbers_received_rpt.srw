$PBExportHeader$w_serial_numbers_received_rpt.srw
forward
global type w_serial_numbers_received_rpt from w_std_report
end type
end forward

global type w_serial_numbers_received_rpt from w_std_report
integer width = 3488
integer height = 2044
string title = "Serial Numbers Received Report"
end type
global w_serial_numbers_received_rpt w_serial_numbers_received_rpt

type variables
DataWindowChild idwc_warehouse,idwc_supp

boolean ib_movement_from_first
boolean ib_movement_to_first
boolean ib_select_sku
boolean ib_select_date_start
boolean ib_select_date_end

String	isoriqsqldropdown
String 	isOrigSql, is_Where
end variables

on w_serial_numbers_received_rpt.create
call super::create
end on

on w_serial_numbers_received_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;String ls_whcode, lsNewSql
DateTime ldt_s, ldt_e
Long  i, ll_cnt,j,ll_adj
Boolean lb_where = false

is_where = ""


If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Remove filter if any thing already there
dw_report.SetFilter("")
dw_report.Filter()
dw_report.Object.t_date_range.text = 'None'

ls_whcode = dw_select.GetItemString(1, "wh_code")

IF IsNull(ls_whcode) or TRIM(ls_whcode) = "" THEN
	
	MessageBox ("Error", "Must enter a warehouse!")
	dw_select.SetColumn("wh_code")
	dw_select.SetFocus()
	RETURN
	
END IF

dw_report.Object.t_project.text =gs_project
dw_report.Object.t_wh_code.text =ls_whcode

//Always tackon project
is_where += " and receive_master.Project_id = '" + gs_project + "'"
is_where += " and receive_master.wh_code = '" + ls_whcode + "'"
lb_where = TRUE

//Tackon Warehouse
if  not isnull( dw_select.GetItemString(1, "order_no")) then
	is_where += " AND Receive_Master.Supp_Invoice_No like '%" + dw_select.GetItemString(1, "order_no") + "%'"
	lb_where = TRUE
end if



//Check if a start date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"s_date")) then
	ib_select_date_start = TRUE
	ldt_s = dw_select.GetItemDateTime(1, "s_date")
	
	is_Where = is_Where + " and  Receive_Master.complete_Date >= '" + string(dw_select.GetItemDateTime(1, "s_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE	

else
	ib_select_date_start = FALSE	
END IF

//Check if a end date has been entered
if  not isnull(dw_select.GetItemDateTime(1,"e_date")) then
	ib_select_date_end = TRUE
	ldt_e = dw_select.GetItemDateTime(1, "e_date")
	
	is_Where = is_Where + " and  Receive_Master.complete_Date <= '" + string(dw_select.GetItemDateTime(1,"e_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_where = TRUE	
	
else
	ib_select_date_end = FALSE	
END IF

IF ib_select_date_start and ib_select_date_end Then
		dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
	ELSEIF ib_select_date_start THEN
		dw_report.Object.t_date_range.text = 'From ' + String(ldt_s,'mm/dd/yyyy hh:mm') 
	ELSEIF 	ib_select_date_end THEN
		dw_report.Object.t_date_range.text = ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
END IF	


////Check start and end date for any errors prior to retrieving
//	IF	((ib_select_date_start = TRUE and ib_select_date_end = FALSE) 	OR &
//		 (ib_select_date_end = TRUE and ib_select_date_start = FALSE)  	OR &
//		 (ib_select_date_start = FALSE and ib_select_date_end = TRUE)) 	THEN
//		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
//		Return
//END IF



dw_report.SetRedraw(False)

//gs_project, ls_whcode


integer li_Pos

	
If is_Where > '  ' Then
	

	
	li_Pos = Pos(isOrigSql, "ORDER BY")
	
	lsNewSql = Left(isOrigSql, li_Pos - 1)  + "  " + is_Where + "  " +  Mid(isOrigSql, li_Pos)
	

	 dw_report.setsqlselect(lsNewsql)
	

	
Else
	dw_report.setsqlselect(isOrigSql)
End If

ll_cnt = dw_report.Retrieve() 

If ll_cnt > 0 Then
	
	im_menu.m_file.m_print.Enabled = True 
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
End If	

//IF ib_select_date_start and ib_select_date_end Then
//      ls_filter =  "complete_date between  datetime('" +string(ldt_s) +"') and datetime('"+string(ldt_e)+"')"
//		dw_report.SetFilter(ls_filter)
//		dw_report.Filter()
//		dw_report.Object.t_date_range.text = String(ldt_s,'mm/dd/yyyy hh:mm') + ' To ' + String(ldt_e,'mm/dd/yyyy hh:mm')
// END IF	
// 
//ll_cnt=dw_report.Rowcount()
//
//If ll_cnt > 0 Then
//	
//	im_menu.m_file.m_print.Enabled = True
////	Select Sum(Avail_Qty + Alloc_Qty + Tfr_Out + wip_qty) Into :ld_balance
////					From content_full (NOLOCK)
////						Where project_id 	= :gs_project and 
////								wh_code 		= :ls_whcode and 
////								sku 			= :ls_sku    and
////								supp_code   = :ls_supp;
////								
////	If sqlca.sqlcode <> 0 Then 
//		ld_balance = 0
////	END IF
//	
////	dw_report.SetItem(ll_cnt, "bal_qty", ld_balance)
//	
////	ll_cnt -= 1
//
//	For i = ll_cnt to 1 Step -1		
//		ls_ord_type = dw_report.GetItemString(i,"ord_type")
//		
//		CHOOSE CASE ls_ord_type
////			CASE "Adjust"
////				//Get the old quantity
////				//Added by DGM For getting the right coulmn in where clause
////				ll_adj = dw_report.Object.adj_no[i]
////					Select quantity, old_quantity Into :ld_quantity,:ld_old_quantity
////					From adjustment With (NOLOCK)
////					Where project_id 	= :gs_project and
////							sku 			= :ls_sku     and
////							supp_code   = :ls_supp    and
////							adjust_no = :ll_adj;				
////				//End of Modifications DGM 12/13/00			
////				ld_difference = abs(ld_quantity - ld_old_quantity)
////				
////				IF ld_quantity > ld_old_quantity THEN
////					dw_report.SetItem(i, "in_qty", ld_difference)
////					dw_report.SetItem(i, "out_qty", 0)
////					ld_out_count 	= ld_out_count + 0
////				ELSE
////					dw_report.SetItem(i,"out_qty", ld_difference)
////					dw_report.SetItem(i, "in_qty", 0)
////					ld_in_count 	= ld_in_count + 0
////				END IF
////				ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
////				ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")
////				
////				
//			CASE "Transfer"
//												
//				
//			CASE ELSE
//				ld_in_count 	= ld_in_count + dw_report.GetItemNumber(i, "in_qty")
//				ld_out_count 	= ld_out_count + dw_report.GetItemNumber(i, "out_qty")				
//		END CHOOSE
//      // j is defined just for clearity
//		//j = i just that the last recored does not exeed the total counts
//		//ll_cnt remain constant as it is total count -DGM
//			if i = ll_cnt  THEN
//				j = i
//			Else	
//				j = i + 1			
//				ld_n_bal_qty =dw_report.GetItemNumber(j, "bal_qty")
//				ld_n_in_count 	=  dw_report.GetItemNumber(j, "in_qty")
//				ld_n_out_count 	= dw_report.GetItemNumber(j, "out_qty")
//				//dw_report.SetItem(i, "bal_qty", ld_n_bal_qty + 	ld_n_out_count - 	ld_n_in_count)	
//			END IF  
//		
//	Next
//	
//	dw_report.Object.t_in_bal.text = string(ld_in_count,"#######.#####")
//	dw_report.Object.t_out_bal.text = string(ld_out_count,"#######.#####")		
//	
//Else
//	im_menu.m_file.m_print.Enabled = False	
//	MessageBox(is_title, "No records found!")
//End If

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

dw_select.GetChild('supp_code', idwc_supp)
dw_select.GetChild('wh_code', idwc_warehouse)

dw_report.GetChild('inv_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)

idwc_warehouse.SetTransObject(sqlca)
idwc_supp.SetTransObject(sqlca)

idwc_supp.Insertrow(0)

If idwc_warehouse.Retrieve(gs_Project) > 0 Then
	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	idwc_warehouse.SetFilter(lsFilter)
//	idwc_warehouse.Filter()

	dw_select.SetItem(1, "wh_code" , gs_default_wh)
	
End If

isoriqsqldropdown = idwc_supp.GetSqlselect()
end event

event open;call super::open;


isOrigSql = dw_report.getsqlselect()


end event

type dw_select from w_std_report`dw_select within w_serial_numbers_received_rpt
integer x = 18
integer width = 3131
string dataobject = "d_serial_numbers_received_rpt_select"
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

type cb_clear from w_std_report`cb_clear within w_serial_numbers_received_rpt
integer x = 3154
integer y = 12
integer width = 270
end type

event cb_clear::clicked;call super::clicked;If idwc_warehouse.RowCount() > 0 Then
	dw_select.SetItem(1, "wh_code" , idwc_warehouse.GetItemString(1, "wh_code"))
End If

end event

type dw_report from w_std_report`dw_report within w_serial_numbers_received_rpt
integer y = 188
integer width = 3401
integer height = 1704
string dataobject = "d_serial_numbers_received_rpt"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

