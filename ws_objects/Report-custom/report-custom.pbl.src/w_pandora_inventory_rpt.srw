$PBExportHeader$w_pandora_inventory_rpt.srw
$PBExportComments$Window used for processing Pandora Inventory information
forward
global type w_pandora_inventory_rpt from w_std_report
end type
end forward

global type w_pandora_inventory_rpt from w_std_report
integer width = 4613
integer height = 2196
string title = "Inventory By SKU"
end type
global w_pandora_inventory_rpt w_pandora_inventory_rpt

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

on w_pandora_inventory_rpt.create
call super::create
end on

on w_pandora_inventory_rpt.destroy
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

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-200)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)

end event

event ue_retrieve;String ls_sku, ls_from_date, ls_To_date
String ls_Where, ls_DS_Where
String ls_NewSql
string ls_value
string ls_warehouse_code
string ls_warehouse_name
integer li_new_report_row


Long ll_balance, ll_Find
Long i
long ll_cnt, ll_Idx, ll_avail_qty
long ll_find_row, ll_rowline_idx

datastore lds_returns

string	ls_return_sku[]

If dw_select.AcceptText() = -1 Then Return

SetPointer(HourGlass!)
dw_report.Reset()

//Always add project
ls_where += " and cs.project_id = '" + gs_project + "'"


long ll_ageing


//Tackon Warehouse if present
ls_value = dw_select.GetItemString(1,"warehouse")
if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
	ls_where += " and cs.wh_code = '" + ls_value + "'"
end if

//Tackon SKU if present
ls_value = dw_select.GetItemString(1,"sku")
if  (NOT isnull(ls_value) AND (ls_value > ' ')) THEN
	ls_where += " and cs.sku = '" + ls_value + "'"
end if

// 05/01 PCONKL - Tackon Inventory Type if Present
if  (NOT isnull(dw_select.GetItemString(1,"inv_type")) AND (dw_select.GetItemString(1,"inv_type") > ' ')) THEN
	ls_where += " and cs.inventory_type = '" + dw_select.GetItemString(1,"inv_type") + "'"
end if

// 2009/05 TAMCCLANAHAN - Tackon Owner Code if Present
if  (NOT isnull(dw_select.GetItemString(1,"owner_cd")) AND (dw_select.GetItemString(1,"owner_cd") > ' ')) THEN
	ls_where += " and owner.owner_cd = '" + dw_select.GetItemString(1,"owner_cd") + "'"
end if

// 2009/05 TAMCCLANAHAN - Tackon From Arrival Date if Present
ls_from_date = String(dw_select.GetItemDateTime(1,"from_arrival"),"yyyy-mm-dd hh:mm")
if  (NOT isnull(ls_from_date) AND (ls_from_date > '0000/00/00')) THEN
	ls_where += " and ro.arrival_date >= '" + ls_from_date + "'"
end if

// 2009/05 TAMCCLANAHAN - Tackon To Arrival Date if Present
ls_to_date = String(dw_select.GetItemDateTime(1,"to_arrival"),"yyyy-mm-dd hh:mm")
if  (NOT isnull(ls_to_date) AND (ls_to_date > '0000/00/00')) THEN
	ls_where += " and ro.arrival_date <= '" + ls_to_date + "'"
end if

// 2009/05 TAMCCLANAHAN - Tackon To Commodity Code if Present
if  (NOT isnull(dw_select.GetItemString(1,"commodity_cd")) AND (dw_select.GetItemString(1,"commodity_cd") > ' ')) THEN
	ls_where += " and itm.user_field5 like '" + dw_select.GetItemString(1,"commodity_cd") + "'"
end if


//Process Warehouse Number
//IF ib_first_time  = TRUE THEN
//  	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
//	  
//	ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//	IF ll_find_row > 0 THEN
//		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
//		ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
////		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//	ELSE
//		ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//		IF ll_find_row > 0 THEN													
//			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
////			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
//		END IF
//	END IF
//	ib_first_time = false
//  
//ELSE
//	is_warehouse_code = dw_select.GetItemString(1,"warehouse")
//	ll_find_row = ids_find_warehouse.Find ("wh_code = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//															
//	IF ll_find_row > 0 THEN
//		is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//		ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
////		dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//		ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
//			
//	else
//		ll_find_row = ids_find_warehouse.Find ("wh_name = '" + is_warehouse_code + "'",&
//																1,ids_find_warehouse.RowCount())
//		IF ll_find_row > 0 THEN
//			is_warehouse_code = ids_find_warehouse.GetItemString(ll_find_row,"wh_code")
//			ls_warehouse_name = ids_find_warehouse.GetItemString(ll_find_row,"wh_name")
////			dw_report.Object.t_warehouse.Text = upper(ls_warehouse_name)
//			ls_where += " and cs.wh_code = '" + is_warehouse_code + "'"
//		END IF
//	END IF
//END IF



ls_newsql = is_select + ls_where + "  " + is_groupby
//messagebox("ls newsql", ls_newsql)
If ls_Where > '  ' Then
	ls_NewSql = is_select + ls_Where +"   " + is_groupby
	dw_report.setsqlselect(ls_Newsql)
	
Else
	
	dw_report.setsqlselect(is_select + ls_where + "  " + is_groupby)
End If
	
//IF (is_warehouse_code = "") or isnull(is_warehouse_code) THEN
//	MessageBox("ERROR", "Please select a warehouse",stopsign!)
//	
//ELSE
	

	ll_cnt = dw_report.Retrieve()
		

	If ll_cnt >= 0 Then
		im_menu.m_file.m_print.Enabled = True
		
		
		If dw_report.dataobject = 'd_inventory_by_sku_rw' then

			dw_report.SetRedraw(false)
			
			lds_returns = Create datastore
			
			lds_returns.dataobject = 'd_inventory_by_sku_rw_returns'
			
			lds_returns.SetTransObject(SQLCA)
			
			if trim(ls_DS_where) <> '' then

				string ls_DS_OrigSql, ls_DS_select, ls_DS_groupby
				long li_DS_pos

				ls_DS_OrigSql = lds_returns.getsqlselect()

				li_DS_pos = pos(ls_DS_OrigSql,"GROUP BY",4000)
					
				
				ls_DS_select = mid(ls_DS_OrigSql,1,li_DS_pos - 1)		
				ls_DS_groupby = mid(ls_DS_OrigSql,li_DS_pos)

				ls_newsql = ls_DS_select + " " + ls_DS_where + "  " + ls_DS_groupby				
					
//				mle_1.TEXT = ls_newsql
					

				lds_returns.setsqlselect(ls_Newsql)

			end if


				
			lds_returns.Retrieve()
		
			datetime ldt_Latest_Order_Complete_Date, ldt_Lot_Exp_Date, ldt_server_datetime, ldt_Lot_Complete_Date
			long li_Latest_Order_Quantity, li_Lot_Quantity
			string ls_current_sku
			
			SELECT TOP 1 Getdate()
				 INTO  :ldt_server_datetime
				FROM Receive_Master Where 1 = 1 USING SQLCA;
			
			
			
			for ll_Idx = 1 to lds_returns.RowCount()
//				

				ls_sku = lds_returns.GetItemString(ll_idx, "content_summary_sku") 
				ll_avail_qty = lds_returns.GetItemNumber(ll_idx, "avail_qty")	


				if ls_current_sku <> ls_sku then
					
					ls_current_sku = ls_sku
				
				
					ldt_Latest_Order_Complete_Date  = lds_returns.GetItemDateTime(ll_idx, "last_sku_order_date") 
	//				li_Latest_Order_Quantity  = lds_returns.GetItemNumber(ll_idx, "last_sku_order_quantity") 

					IF li_Latest_Order_Quantity >= ll_avail_qty THEN
						li_Latest_Order_Quantity  = lds_returns.GetItemNumber(ll_idx, "last_sku_order_quantity") 
					ELSE
						li_Latest_Order_Quantity = ll_avail_qty
					END IF


					IF IsNull(li_Latest_Order_Quantity) THEN li_Latest_Order_Quantity = 0
					
					if ll_avail_qty <= li_Latest_Order_Quantity and li_Latest_Order_Quantity > 0 then
							
						ll_ageing = DaysAfter (date(ldt_Latest_Order_Complete_Date), date(ldt_server_datetime))
					
						li_Latest_Order_Quantity = li_Latest_Order_Quantity - ll_avail_qty
					
					else

				
						ldt_Lot_Complete_Date = lds_returns.GetItemDateTime(ll_idx, "last_sku_transfer_complete_dat") 
						ldt_Lot_Exp_Date = lds_returns.GetItemDateTime(ll_idx, "last_sku_transfer_expiration_d")
						li_Lot_Quantity = lds_returns.GetItemNumber(ll_idx, "last_sku_transfer_quantity") 
				
	
						IF String(ldt_Lot_Exp_Date, 'mm/dd/yyyy') = '12/31/2999' THEN
							
							ldt_Lot_Exp_Date = ldt_Lot_Complete_Date
							
						END IF
				
						IF li_Lot_Quantity > 0 THEN
				
							if  li_Latest_Order_Quantity > 0 then
							
								// New row
	
								ll_ageing =  DaysAfter (date(ldt_Lot_Complete_Date),  date(ldt_server_datetime))
								
								
								lds_returns.SetItem( ll_idx, "avail_qty", ll_avail_qty - li_Latest_Order_Quantity)
	
																		
								if ll_Find > 0 then
						
							
									dw_report.SetItem(ll_Find, "avail_qty", (dw_report.GetItemDecimal(ll_Find, "avail_qty") + li_Latest_Order_Quantity))
						
															
								else


									li_new_report_row = dw_report.InsertRow(1)
						
									wf_new_rw_return_row(lds_returns, li_new_report_row, ll_Idx, ll_ageing)
									
									dw_report.SetItem( li_new_report_row, "avail_qty", li_Latest_Order_Quantity)

								end if
									
								
								ll_ageing =  DaysAfter (date(ldt_Lot_Exp_Date),  date(ldt_server_datetime))
								
								li_Latest_Order_Quantity = 0
	
							else	
							
						
								//No Row
								ll_ageing = DaysAfter (date(ldt_Lot_Exp_Date),  date(ldt_server_datetime))
							
							end if
				
						end if
		
					end if
//					
				
				end if
				
				ll_Find = dw_report.Find("content_summary_sku='"+ls_sku+"' AND ageing = " + string(ll_ageing), 1, dw_report.RowCount())

				if ll_Find > 0 then
					
											
					dw_report.SetItem(ll_Find, "avail_qty", (dw_report.GetItemDecimal(ll_Find, "avail_qty") + lds_returns.GetItemDecimal(ll_Idx, "avail_qty")))
					
					
				else


					li_new_report_row = dw_report.InsertRow(1)
					
					wf_new_rw_return_row(lds_returns, li_new_report_row, ll_Idx, ll_ageing)

				end if
				
			next

			dw_report.Sort()	
				
		End If
		
		Destroy lds_returns
		
		dw_report.SetRedraw(true)
		
		
		dw_report.Setfocus()
	
	END IF
	
	IF dw_report.RowCount() <= 0  THEN
	
		im_menu.m_file.m_print.Enabled = False	
		MessageBox(is_title, "No records found!")
		dw_select.Setfocus()
	End If
//END IF

is_warehouse_code = " "



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

//dw_select.GetChild('warehouse', ldwc_warehouse)
//ldwc_warehouse.SetTransObject(sqlca)
//If ldwc_warehouse.Retrieve(gs_project) > 0 Then
//	
//	//Filter Warehouse dropdown by Current Project
//	lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
//	ldwc_warehouse.SetFilter(lsFilter)
//	ldwc_warehouse.Filter()

// LTK 20150908  Commented out block above.  Populate warehouse DDDW via common method which uses user's configured warehouses.
dw_select.GetChild("warehouse", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "warehouse", gs_default_wh)
end if
	
	
	
//	If ldwc_warehouse.RowCount() > 0 Then
//		dw_select.SetItem(1, "warehouse" , ldwc_warehouse.GetItemString(1, "wh_code"))
//	End If
	
//End If


end event

type dw_select from w_std_report`dw_select within w_pandora_inventory_rpt
integer x = 0
integer width = 4265
integer height = 200
string dataobject = "d_pandora_inventory_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;long		ll_row
long		ll_find_row

string 	ls_value
string	ls_warehouse_name

////Create the locating warehouse name datastore
//ids_find_warehouse = CREATE Datastore 
//ids_find_warehouse.dataobject = 'd_find_warehouse'
//ids_find_warehouse.SetTransObject(SQLCA)
//ids_find_warehouse.Retrieve()

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
		
	CASE "from_arrival"
		
		IF ib_from_date_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("from_arrival")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_from_date_first = FALSE
			
		END IF
		
	CASE "to_arrival"
		
		IF ib_to_date_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("to_arrival")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_to_date_first = FALSE
			
		END IF
		
	
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_pandora_inventory_rpt
boolean visible = true
integer x = 4279
integer y = 8
integer width = 261
integer taborder = 20
end type

type dw_report from w_std_report`dw_report within w_pandora_inventory_rpt
integer x = 5
integer y = 256
integer width = 4558
integer height = 1736
integer taborder = 30
string dataobject = "d_pandora_inventory_rpt"
boolean hscrollbar = true
end type

event dw_report::constructor;
//If Isnull(sle_sku) THEN
//	This.SetTransObject(SQLCA)
//	This.Retrieve()
//END IF
end event

