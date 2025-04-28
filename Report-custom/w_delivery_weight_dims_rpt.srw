HA$PBExportHeader$w_delivery_weight_dims_rpt.srw
$PBExportComments$Delivery Report
forward
global type w_delivery_weight_dims_rpt from w_std_report
end type
type dw_saveas from datawindow within w_delivery_weight_dims_rpt
end type
end forward

global type w_delivery_weight_dims_rpt from w_std_report
integer width = 3703
integer height = 2132
string title = "Delivery Report - Weight and DIMS"
event ue_calc_uom ( )
dw_saveas dw_saveas
end type
global w_delivery_weight_dims_rpt w_delivery_weight_dims_rpt

type variables
DataWindowChild idwc_warehouse
String	isOrigSql

boolean ib_order_from_first
boolean ib_order_to_first 
boolean ib_sched_from_first
boolean ib_sched_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_receive_from_first
boolean ib_receive_to_first

integer	ii_max_col
end variables

event ue_calc_uom();// 11/02 - PConkl - change QTY to Decimal

datastore	lds
datawindowChild	ldwc
Long	llRow, llUOMCount,llUOMPos,lltempPos,llNewRow, llrow_count
Decimal ldReqQty,ldWorkQty, ldWorkQty_mod, ldtemp
String	lsSKU, lsSupplier, lsUOMText, lsUOM, lsUOMText_Multi_UOM
boolean		lb_build_multi_uom

// 11/00 PCONKL - Calculate possible UOM combinations for SKU/QTY

// Rebuilt the qty for each row in the report datawindow.
llRow_count = dw_report.RowCount()

If llRow_count <=0 Then Return

//UOM's for current Sku
lds = Create datastore
lds.dataobject = 'd_pick_uom'
lds.SetTransObject(SQLCA)

For llRow = 1 to llRow_count
	
	lsSku = dw_report.getItemString(llRow,"sku")
	lsSupplier = dw_report.GetItemString(llRow,"supp_code")
	
	ldwc.Reset()

	// No need to get qty if sku is null
	IF IsNull( lsSku ) = FALSE THEN
	
		llUOMCount = lds.Retrieve(gs_project,lsSku,lsSupplier)
		
		IF llUOMCOUNT > 0 THEN
		
			IF llUOMCOUNT = 1 THEN
				
				// Use Qty on Item Master for Report Qty
				dw_report.object.quantity[llrow] = lds.getItemNumber(1,"qty")
				
			ELSE
		
				ldReqQty = dw_report.GetItemNumber(llRow,"quantity")
				
				llUOMPos = 1		//d_pick_uom is ordered by qty, use 1st UOM only
					
				If ldReqQty < lds.getItemNumber(llUOMPos,"qty") Then Continue
					
				llTempPos = llUomPos
						
				//If current UOM can be divided into reamining required qty, take as many of this UOM
				If ldReqQty >= lds.getItemNumber(llTempPos,"qty") Then
					ldtemp = lds.getItemNumber(lltempPos,"qty")
					ldWorkQty = ldReqQty/lds.getItemNumber(lltempPos,"qty")
										
					IF ldWorkQty = 0 THEN ldWorkQty = 1.0  // Round up to full uom qty
							
					dw_report.object.quantity[llrow] = ldWorkQty
							
				End If /*req qty > UOM*/
				
			END IF	// llUOMCOUNT = 1 check
			
		END IF	// llUOMCOUNT > 0 check
		
	END IF	// Null sku check
	
NEXT  // 



end event

on w_delivery_weight_dims_rpt.create
int iCurrent
call super::create
this.dw_saveas=create dw_saveas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_saveas
end on

on w_delivery_weight_dims_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_saveas)
end on

event open;call super::open;

//isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;String ls_whcode, ls_sku, lsWhere, lsNewSql, ls_from_date
Date ldFromDate, ldtodate
Long ll_balance, i, ll_cnt
boolean 	lb_order_from, lb_order_to, lb_complete_from, lb_complete_to, lb_receive_from, &
			lb_receive_to, lb_sched_from, lb_sched_to
Boolean lb_where		
integer li_pos
long		ll_row
integer	li_blank, li_insert_blank_tot, li_rc
string		ls_do_no
datastore	lds_no_do_list

SetPointer( Hourglass! )
SetRedraw( FALSE )

lds_no_do_list = create datastore

lds_no_do_list.dataobject = "d_delivery_weight_dims_rpt"

lds_no_do_list.SetTransObject(sqlca)

isOrigSql = lds_no_do_list.getsqlselect()

If dw_select.AcceptText() = -1 Then Return


//Initialize date flags
lb_order_from 		= FALSE
lb_order_to 		= FALSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE
lb_receive_from 	= FALSE
lb_receive_to 		= FALSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_where          = FALSE
SetPointer(HourGlass!)
dw_report.Reset()

lsWhere = ''

//always tackon Project
lsWhere += " and Delivery_Master.project_id = '" + gs_project + "'"

//Tackon Warehouse
if  not isnull(dw_select.GetItemString(1,"warehouse")) then
	lswhere += " and Delivery_Master.wh_code = '" + dw_select.GetItemString(1,"warehouse") + "'"
	lb_where = TRUE
end if

//Tackon Order Type <> Packaging for Satillo/Detroit - GAP 9/02
if  Upper(Left(gs_project,4)) = 'GM_M'  then
	lswhere += " and Delivery_Master.ord_type <> '" + "P" + "'"
end if

//Tackon BOL Nbr
if  not isnull(dw_select.GetItemString(1,"bol_nbr")) then
	lswhere += " and Delivery_Master.Invoice_No Like '%" + dw_select.GetItemString(1,"bol_nbr") + "%'"
	lb_where = TRUE
end if

//Tackon Cust Code
if  not isnull(dw_select.GetItemString(1,"cust_code")) then
	lswhere += " and Delivery_Master.Cust_Code = '" + dw_select.GetItemString(1,"cust_code") + "'"
	lb_where = TRUE
end if

//Tackon From Order Date
If date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and Delivery_Master.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"order_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_from = TRUE
		lb_where = TRUE		 
End If

//Tackon To Order Date
If date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and Delivery_Master.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"order_to_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_to = TRUE
		lb_where = TRUE
End If

//Tackon From complete Date
If Date(dw_select.GetItemDateTime(1,"complete_from_date")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  Delivery_Master.Complete_Date >= '" + string(dw_select.GetItemDateTime(1,"complete_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_complete_from = TRUE
		lb_where = TRUE
End If

//Tackon To complete Date 
If Date(dw_select.GetItemDateTime(1,"complete_to_date")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  Delivery_Master.Complete_Date <= '" + string(dw_select.GetItemDateTime(1,"complete_to_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_complete_to = TRUE
	lb_where = TRUE
End If

//Tackon From Receive Date
If Date(dw_select.GetItemDateTime(1,"receive_date_from")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  Delivery_Master.receive_Date >= '" + string(dw_select.GetItemDateTime(1,"receive_date_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_receive_from = TRUE 
		lb_where = TRUE
End If

//Tackon To receive Date 
If Date(dw_select.GetItemDateTime(1,"receive_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  Delivery_Master.receive_Date <= '" + string(dw_select.GetItemDateTime(1,"receive_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_receive_to = TRUE
	lb_where = TRUE
End If

//Tackon From Schedule Date
If Date(dw_select.GetItemDateTime(1,"sched_date_from")) > date('01-01-1900') Then
		lsWhere = lsWhere + " and  Delivery_Master.schedule_Date >= '" + string(dw_select.GetItemDateTime(1,"sched_date_from"),'mm-dd-yyyy hh:mm') + "'"
		lb_sched_from = TRUE
		lb_where = TRUE
End If

//Tackon To Schedule Date 
If Date(dw_select.GetItemDateTime(1,"sched_date_to")) > date('01-01-1900') Then
	lsWhere = lsWhere + " and  Delivery_Master.schedule_Date <= '" + string(dw_select.GetItemDateTime(1,"sched_date_to"),'mm-dd-yyyy hh:mm') + "'"
	lb_sched_to = TRUE
	lb_where = TRUE
End If

//// 12/00 PCONKL - Tackon Inv Type
//If  not isnull(dw_select.GetItemString(1,"inv_type")) then
//	lswhere += " and Delivery_picking.Inventory_type = '" + dw_select.GetItemString(1,"Inv_type") + "'"
//	lb_where = TRUE
//end if
	
If lsWhere > '  ' Then
	
	li_Pos = Pos(isOrigSql, "GROUP BY",1)

	if li_Pos > 0 then
	
		lsNewsql = left(isOrigSql, li_Pos -1) + lsWhere + mid(isOrigSql, li_Pos)
	
	else
	
		lsNewsql = isOrigSql + lsWhere 

	end if

	lds_no_do_list.setsqlselect(lsNewsql)
Else
	lds_no_do_list.setsqlselect(isOrigSql)
End If




//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
		 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
		 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
		Return
END IF

//Check Complete Date range for any errors prior to retrieving
IF 	((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
		 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
		 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
		Return
END IF	

//Check Arrival Date range for any errors prior to retrieving
IF 	((lb_receive_to = TRUE and lb_receive_from = FALSE) 	OR &
		 (lb_receive_from = TRUE and lb_receive_to = FALSE)  	OR &
		 (lb_receive_from = FALSE and lb_receive_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Receive Date Range", Stopsign!)
		Return
END IF

//Check Schedule Date range for any errors prior to retrieving
IF 	((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
		 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
		 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Date Range", Stopsign!)
		Return
END IF	

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	 

//Get DO_NO from datastore so we can load each order to the n-up display 
lds_no_do_list.Retrieve()

ll_row = lds_no_do_list.RowCount()

//ii_max_col = 8  // This number should match value in datawindow query

FOR i = 1 to ll_row
	
	ls_do_no = lds_no_do_list.GetItemString( i, 'do_no' )
	
	// Load each order to dw_report (see retreivestart, return 2 so each row will apend)
	dw_report.Retrieve( gs_project, ls_do_no )
	
	// Get current row count so we can add blanks (limited number of detail, set to li_max_col)
	li_rc = dw_report.RowCount()
	
	// Calc number of blank rows we need to insert 
	li_insert_blank_tot = (i * ii_max_col) - li_rc
	
	//Now insert the blanks
	For li_blank = 1 to li_insert_blank_tot
		
		dw_report.InsertRow( li_rc + li_blank )
		
	Next 
	
NEXT

//TriggerEvent( 'ue_calc_uom' )

SetRedraw( TRUE )
SetPointer( Arrow! )

ll_cnt = dw_report.RowCount()
If ll_cnt > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If


end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-310)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('warehouse', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve()

//Filter Warehouse dropdown by Current Project
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()


dw_select.GetChild('inv_type', ldwc)
ldwc.SetTransObject(Sqlca)
////added by dgm
//Messagebox("Ret",i_nwarehouse.of_init_inv_ddw(dw_select) )
ldwc.Retrieve()
lsFilter = "Upper(project_id) = '" + Upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

ii_max_col = 8  // This number should match value in datawindow query - nup display


// TAM 03/05/2013 - Created a Physio Specific Report
if left(gs_project,6) = 'PHYSIO' then
	dw_report.dataobject = "d_physio_weight_dims_nup"
	dw_report.SetTransObject(SQLCA)
	dw_saveas.dataobject = "d_physio_weight_dims_saveas"
	dw_saveas.SetTransObject(SQLCA)
end if

end event

event ue_file;String	lsOption,ls_name
Str_parms	lstrparms
ulong lu_rtn,lu_pass
integer li_rtn
long		ll_rc, i
decimal	ld_test
long		ll_row

dw_saveas.Reset()

ll_rc = dw_report.RowCount()

// datawindow in dw_report is an nup display, saveas is not working correctly, 
// so copy the data into datastore.  d_powerwave_weight_dims_saveas needs
// to change if dw_report changes.
// TAM 2013/03/12 -  Added  Physio Report d_physio_weight_dims_saveas so it needs to change as well  (already declared earlier)

for i = 1 to ll_rc //step 8

	ll_row = dw_saveas.InsertRow(0)
	
	dw_saveas.object.ord_date[ll_row] = dw_report.object.ord_date[i]
	dw_saveas.object.invoice_no[ll_row] = dw_report.object.invoice_no[i]
	dw_saveas.object.user_field6[ll_row] = dw_report.object.user_field6[i]
	dw_saveas.object.complete_date[ll_row] = dw_report.object.complete_date[i]
	dw_saveas.object.carrier[ll_row] = dw_report.object.carrier[i]
	dw_saveas.object.ship_ref[ll_row] = dw_report.object.ship_ref[i]
	dw_saveas.object.awb_bol_no[ll_row] = dw_report.object.awb_bol_no[i]
	dw_saveas.object.cust_name[ll_row] = dw_report.object.cust_name[i]
	dw_saveas.object.address_1[ll_row] = dw_report.object.address_1[i]
	dw_saveas.object.zip[ll_row] = dw_report.object.zip[i]
	dw_saveas.object.city[ll_row] = dw_report.object.city[i]
	dw_saveas.object.country[ll_row] = dw_report.object.country[i]

// TAM 2013/03/12 -  Added new fields for a Physio Report
// TAM 2013/05/12 -  Purchase and sell are backwards in Trax
// TAM 2013/07/05 -  Reverse changes  from2013/05/12
	dw_saveas.object.purchase_cost[ll_row] = dw_report.object.delivery_packing_buychargevalue[i]
	dw_saveas.object.purchase_curr[ll_row] = dw_report.object.delivery_packing_buychargecurrency[i]
	dw_saveas.object.sell_cost[ll_row] = dw_report.object.delivery_packing_sellchargevalue[i]
	dw_saveas.object.sell_curr[ll_row] = dw_report.object.delivery_packing_sellchargecurrency[i]
//
//	dw_saveas.object.sell_cost[ll_row] = dw_report.object.delivery_packing_buychargevalue[i]
//	dw_saveas.object.sell_curr[ll_row] = dw_report.object.delivery_packing_buychargecurrency[i]
//	dw_saveas.object.purchase_cost[ll_row] = dw_report.object.delivery_packing_sellchargevalue[i]
//	dw_saveas.object.purchase_curr[ll_row] = dw_report.object.delivery_packing_sellchargecurrency[i]
	
	
	dw_saveas.object.quantity_1[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_1[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_1[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_1[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_1[ll_row] = dw_report.object.weight_gross[i]
	
	// Get next row 
	i = i + 1
	
	dw_saveas.object.quantity_2[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_2[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_2[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_2[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_2[ll_row] = dw_report.object.weight_gross[i]
	
	i = i + 1
	
	dw_saveas.object.quantity_3[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_3[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_3[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_3[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_3[ll_row] = dw_report.object.weight_gross[i]
	
	i = i + 1
	
	dw_saveas.object.quantity_4[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_4[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_4[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_4[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_4[ll_row] = dw_report.object.weight_gross[i]
	
	i = i + 1
	
	dw_saveas.object.quantity_5[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_5[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_5[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_5[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_5[ll_row] = dw_report.object.weight_gross[i]

	i = i + 1
	
	dw_saveas.object.quantity_6[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_6[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_6[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_6[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_6[ll_row] = dw_report.object.weight_gross[i]
	
	i = i + 1
	
	dw_saveas.object.quantity_7[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_7[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_7[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_7[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_7[ll_row] = dw_report.object.weight_gross[i]
	
	i = i + 1
	
	dw_saveas.object.quantity_8[ll_row] = dw_report.object.quantity[i]
	dw_saveas.object.length_8[ll_row] = dw_report.object.length[i]
	dw_saveas.object.width_8[ll_row] = dw_report.object.width[i]
	dw_saveas.object.height_8[ll_row] = dw_report.object.height[i]
	dw_saveas.object.weight_gross_8[ll_row] = dw_report.object.weight_gross[i]

// TAM 2013/03/12 -  Added new fields for a Physio Report
if left(gs_project,6) = 'PHYSIO' then
	decimal ldgross, ldqty
	ldgross = 0
	ldqty = 0
If Not IsNull(dw_saveas.object.quantity_1[ll_row]) then 
	ldqty += dw_saveas.object.quantity_1[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_1[ll_row]) then ldgross += (dw_saveas.object.weight_gross_1[ll_row] * dw_saveas.object.quantity_1[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_2[ll_row]) then 
	ldqty += dw_saveas.object.quantity_2[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_2[ll_row]) then ldgross += (dw_saveas.object.weight_gross_2[ll_row] * dw_saveas.object.quantity_2[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_3[ll_row]) then 
	ldqty += dw_saveas.object.quantity_3[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_3[ll_row]) then ldgross += (dw_saveas.object.weight_gross_3[ll_row] * dw_saveas.object.quantity_3[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_4[ll_row]) then 
	ldqty += dw_saveas.object.quantity_4[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_4[ll_row]) then ldgross += (dw_saveas.object.weight_gross_4[ll_row] * dw_saveas.object.quantity_4[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_5[ll_row]) then 
	ldqty += dw_saveas.object.quantity_5[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_5[ll_row]) then ldgross += (dw_saveas.object.weight_gross_5[ll_row] * dw_saveas.object.quantity_5[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_6[ll_row]) then
	ldqty += dw_saveas.object.quantity_6[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_6[ll_row]) then ldgross += (dw_saveas.object.weight_gross_6[ll_row] * dw_saveas.object.quantity_6[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_7[ll_row]) then 
	ldqty += dw_saveas.object.quantity_7[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_7[ll_row]) then ldgross += (dw_saveas.object.weight_gross_7[ll_row] * dw_saveas.object.quantity_7[ll_row])
End If	
If Not IsNull(dw_saveas.object.quantity_8[ll_row]) then 
	ldqty += dw_saveas.object.quantity_8[ll_row]
	If Not IsNull(dw_saveas.object.weight_gross_8[ll_row]) then ldgross += (dw_saveas.object.weight_gross_8[ll_row] * dw_saveas.object.quantity_8[ll_row])
End If	

	dw_saveas.object.quantity_tt[ll_row] = ldqty
	dw_saveas.object.weight_gross_tt[ll_row] = ldgross

end if
	

next



//Triggered from menu
lu_pass = 300000
ls_name = space(5000)
lsoption = Message.StringParm
Choose Case lsoption
		
	Case "PRINTPREVIEW" /*print preview window*/
		
			OpenwithParm(w_printzoom,dw_saveas)
		
	Case "SAVEAS" /*Export*/
	//DGM 06/24/05	
	//This process is triggered only if the clag is set in descedant window
	// this process will save a file in the current work directory	
  	IF ib_saveasascii  THEN
		lu_rtn = g.GetCurrentDirectoryA(lu_pass,ls_name)
		ls_name = ls_name + '\' + 'RESULTS.xls'	
		
		IF  FileExists(ls_name) THEN 	FileDelete ( ls_name ) 
		li_rtn=dw_saveas.Saveas()
		IF li_rtn > 0 THEN li_rtn=dw_saveas.SaveAsAscii(ls_name)	
	ELSE
		li_rtn=dw_saveas.Saveas()
	END IF	
		
		
End Choose
end event

type dw_select from w_std_report`dw_select within w_delivery_weight_dims_rpt
integer x = 18
integer y = 0
integer width = 3648
integer height = 292
string dataobject = "d_delivery_weight_dims_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE
ib_sched_from_first 		= TRUE
ib_sched_to_first 		= TRUE
ib_complete_from_first 	= TRUE
ib_complete_to_first 	= TRUE
ib_receive_to_first 		= TRUE
ib_receive_from_first	= TRUE
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
		
	CASE "receive_date_from"
		
		IF ib_receive_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("receive_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_receive_from_first = FALSE
			
		END IF
		
	CASE "receive_date_to"
		
		IF ib_receive_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("receive_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_receive_to_first = FALSE
			
		END IF
		
	CASE "complete_from_date"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("complete_from_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_to_date"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("complete_to_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
	CASE "sched_date_from"
		
		IF ib_sched_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("sched_date_from")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_sched_from_first = FALSE
			
		END IF
		
	CASE "sched_date_to"
		
		IF ib_sched_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("sched_date_to")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_sched_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_delivery_weight_dims_rpt
end type

type dw_report from w_std_report`dw_report within w_delivery_weight_dims_rpt
integer x = 0
integer y = 300
integer width = 3625
integer height = 1592
integer taborder = 30
string dataobject = "d_powerwave_weight_dims_nup"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_report::retrievestart;call super::retrievestart;RETURN 2
end event

type dw_saveas from datawindow within w_delivery_weight_dims_rpt
boolean visible = false
integer x = 3365
integer y = 596
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_powerwave_weight_dims_saveas"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

