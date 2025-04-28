$PBExportHeader$w_completed_order_sku_shipped_report.srw
$PBExportComments$Allocation Report
forward
global type w_completed_order_sku_shipped_report from w_std_report
end type
end forward

global type w_completed_order_sku_shipped_report from w_std_report
integer width = 3730
integer height = 2132
string title = "Completed Order SKU Shipped Report"
event ue_allocate ( )
end type
global w_completed_order_sku_shipped_report w_completed_order_sku_shipped_report

type variables
String	isOrigSql

boolean  ib_order_from_first
boolean ib_order_to_first
end variables

event ue_allocate();Long	llRowCount,	llRowPos, llOwner, llContentCount, llContentPos, llNewRow

Decimal	ldAvailQty,	ldReqQty
		
String	lsSKU, lsWarehouse, lsFilter, lsSupplier, lsSQL
			
n_ds_Content	ldsCOntent

ldsContent = Create n_ds_Content
ldsContent.Dataobject = 'd_allocation_rpt_Content'
ldsContent.SetTransObject(SQLCA)

// 02/05 - PCONKL - If not excluding non shippable inv typs (meaning - we are allowing non shippable types), remove from SQL
If dw_select.GetItemString(1,'shippable_inv_Type_ind') <> 'Y' Then
	
	lsSql = ldsContent.GetSqlSelect()
	lsSQl = Replace(lsSql,pos(lsSql,"and Inventory_Type.Inventory_shippable_ind = 'Y'"),48,'')
	ldsContent.object.datawindow.table.select = lsSql
	Messagebox('',lsSQL)
End If

//Allocate in current Sort order for Detail Records
llRowCount = dw_report.RowCount()
For llRowPos = 1 to llRowCount
	
	//Remove any previous filtering
	ldsContent.SetFilter('')
	ldsContent.Filter()
	
	lsSKU = dw_Report.GetITemString(llRowPOs,'delivery_Detail_sku')
	lsSupplier = dw_Report.GetITemString(llRowPOs,'delivery_Detail_supp_code')
	lswarehouse = dw_Report.GetITemString(llRowPOs,'delivery_Master_wh_code')
	llOwner = dw_report.GetITemNumber(llRowPos,'delivery_Detail_Owner_id')
	ldReqQty = dw_report.GetITemNumber(llRowPos,'delivery_Detail_req_qty')
		
	//Retrieve Content records if we dont already have (Retrievestart=2)
	If ldsContent.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "'", 1, ldsContent.RowCOunt()) <= 0 Then
		ldsContent.Retrieve(gs_project, lsWarehouse, lsSku)
	End If
	
	//Filter for the current Detail Row.
	lsFilter = "Upper(Content_SKU) = '" + Upper(lsSKU) + "' and c_avail_qty > 0" /*always filter by SKU  and available qty > 0*/
	
	//If not allowing picking by Alt Supplier, include in Filter
	If g.is_allow_alt_supplier_pick = 'N' Then
		lsFilter += " and Upper(Content_supp_code) = '" + Upper(lsSUpplier) + "'"
	End If
	
	//If not allowing to pick from all owners, filte for current Owner
	If dw_Select.GetITemString(1,'allow_alt_owner_Ind') <> 'Y' Then
		lsFilter += " and Content_owner_id = " + String(llOwner)
	End If	
	
	ldsContent.SetFilter(lsFilter)
	ldsContent.Filter()
	
	//allocate from Content records
	llContentCount = ldsContent.RowCount()
	FOr llContentPos = 1 to llContentCount
		
		ldAvailQty = ldsContent.GetITemNumber(llContentPos,'c_avail_Qty')
		If ldAvailQTy <= 0 Then Continue
		
		//If this is the first time for this detail record, update the fields on the current record, otherwise add a new row. We'll sort when we're done
		If llContentPos = 1 then
			llNewRow = llRowPos
		Else
			llNewRow = dw_report.InsertRow(0)
			dw_report.SetITem(llNewRow,'rec_source_ind','B')
			dw_report.SetITem(llNewRow,'delivery_master_Project_id',dw_report.GetITemString(llRowPos,'delivery_master_Project_id'))
			dw_report.SetITem(llNewRow,'delivery_master_wh_code',dw_report.GetITemString(llRowPos,'delivery_master_wh_code'))
			dw_report.SetITem(llNewRow,'delivery_master_Invoice_no',dw_report.GetITemString(llRowPos,'delivery_master_Invoice_no'))
			dw_report.SetITem(llNewRow,'delivery_master_cust_order_No',dw_report.GetITemString(llRowPos,'delivery_master_cust_order_No'))
			dw_report.SetITem(llNewRow,'delivery_master_ord_Type',dw_report.GetITemString(llRowPos,'delivery_master_ord_Type'))
			dw_report.SetITem(llNewRow,'delivery_master_cust_code',dw_report.GetITemString(llRowPos,'delivery_master_cust_code'))
			dw_report.SetITem(llNewRow,'delivery_master_cust_Name',dw_report.GetITemString(llRowPos,'delivery_master_cust_Name'))
			dw_report.SetITem(llNewRow,'delivery_master_Inventory_Type',dw_report.GetITemString(llRowPos,'delivery_master_Inventory_Type'))
			dw_report.SetITem(llNewRow,'delivery_master_Priority',dw_report.GetITemNumber(llRowPos,'delivery_master_Priority'))
			dw_report.SetITem(llNewRow,'delivery_master_ord_date',dw_report.GetITemDateTime(llRowPos,'delivery_master_ord_date'))
			dw_report.SetITem(llNewRow,'delivery_master_schedule_date',dw_report.GetITemDateTime(llRowPos,'delivery_master_schedule_date'))
			dw_report.SetITem(llNewRow,'delivery_Detail_line_Item_NO',dw_report.GetITemNumber(llRowPos,'delivery_Detail_line_Item_NO'))
			dw_report.SetITem(llNewRow,'delivery_Detail_Sku',dw_report.GetITemString(llRowPos,'delivery_Detail_Sku'))
			dw_report.SetITem(llNewRow,'delivery_Detail_supp_code',dw_report.GetITemString(llRowPos,'delivery_Detail_supp_code'))
			dw_report.SetITem(llNewRow,'owner_Owner_Cd',dw_report.GetITemString(llRowPos,'owner_Owner_Cd'))
			dw_report.SetITem(llNewRow,'owner_Owner_Type',dw_report.GetITemString(llRowPos,'owner_Owner_Type'))
			dw_report.SetITem(llNewRow,'delivery_Detail_req_qty',0)
		End If
		
		dw_report.SetITem(llNewRow,'c_avail_owner', ldsContent.GetITEmString(llContentPos,'owner_Owner_Cd') + '(' + ldsContent.GetITEmString(llContentPos,'owner_Owner_Type') + ')')
		
		If ldAvailQty >= ldreqqty Then
			dw_report.SetITem(llNewRow,'delivery_Detail_c_avail_qty', ldReqQty)
			ldsContent.SetItem(llContentPos,'c_avail_qty', (ldAvailQty - ldReqQty))
			Exit
		Else /*not all available*/
			dw_report.SetITem(llNewRow,'delivery_Detail_c_avail_qty', ldAvailQty)
			ldReqQty = ldReqQty - ldAvailQty
		End If
				
	Next /*Content record */
		
Next /*Detail Row */


end event

on w_completed_order_sku_shipped_report.create
call super::create
end on

on w_completed_order_sku_shipped_report.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()

ib_order_from_first = true
ib_order_to_first = true


end event

event ue_retrieve;String	lsWhere,	lsNewSQL

// Accept search criteria.
If dw_select.AcceptText() < 0 Then Return

If isnull(dw_select.getitemstring(1,'wh_code')) then 
	messagebox("SIMS", "You must select a valid warehouse")
	return
End If

// Set the pointer to hourglass and redraw to off.
SetPointer(Hourglass!)
dw_report.SetRedraw(False)

/* always tack on Project and warehouse and new order status*/
lsWhere = " and Delivery_MAster.Project_ID = '" + gs_project + "' and wh_code = '" + dw_select.GetITEmString(1,'wh_code') + "' " 
// lsWhere += " and ord_status = 'N' "

// From Sched Date
If date(dw_select.GetItemDateTime(1,"from_SChed_Date")) > date('01-01-1900') Then
	lsWhere += " and complete_date >= '" + string(dw_select.GetItemDateTime(1,"from_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

// From To Date
If date(dw_select.GetItemDateTime(1,"to_SChed_Date")) > date('01-01-1900') Then
	lsWhere += " and complete_date <= '" + string(dw_select.GetItemDateTime(1,"to_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

// Construct new SQL.
lsNewSQL = isOrigSql + lsWhere

clipboard(lsNewSQL)

// Set the new SQL
dw_Report.SetSQLSelect(lsNewSQL)

// If there are rows,
If dw_report.Retrieve() > 0 Then
	
	// Enable the print menu item and set focus to the report dw.
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
	
// Otherwise, if there are no rows returned,
Else
	
	// Disable the print menu item, show a messagebox and set focus to the search dw.
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

// Redraw the screen.
dw_report.SetRedraw(True)

// Set the pointer to arrow.
SetPointer(Arrow!)

end event

event resize;dw_report.Resize(workspacewidth() - 30,workspaceHeight()-380)
end event

event ue_clear;dw_select.Reset()
dw_select.InsertRow(0)
dw_Select.SetITem(1,'wh_code',gs_default_wh)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2
String	lsFilter

//populate dropdowns - not done automatically since dw not being retrieved

dw_select.GetChild('wh_code', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_Project)
dw_Select.SetITem(1,'wh_code',gs_default_wh)

dw_select.GetChild('order_Type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_Project)
dw_report.GetChild('delivery_master_ord_type', ldwc2) /*Share with Report*/
ldwc.ShareData(ldwc2)

dw_report.GetChild('delivery_master_inventory_type', ldwc)
ldwc.SetTransObject(Sqlca)
ldwc.Retrieve(gs_Project)




end event

event ue_sort;call super::ue_sort;dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_completed_order_sku_shipped_report
integer x = 18
integer y = 0
integer width = 3351
integer height = 364
string dataobject = "d_completed_order_sku_shipped_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
If g.is_owner_ind <> 'Y' Then
	This.modify("allow_alt_owner_ind.visible=False")
End If
end event

event dw_select::itemchanged;call super::itemchanged;//date ldate_date
//time ltime_time
//string as_colname
//
//as_colname = getcolumnname()
//		
//
//Choose Case as_colname
//	Case "from_sched_date"
//		
//		ldate_date = date(data)
//		ltime_time = time("00:00")
//		
//		setitem(1, "from_sched_Date", datetime(ldate_date, ltime_time))
//		
//	Case "to_sched_date"
//		
//		ldate_date = date(data)
//		ltime_time = time("23:59")
//		
//		setitem(1, "to_sched_date", datetime(ldate_date, ltime_time))
//		
//	Case Else
//		
//		//
//		
//End Choose
end event

event dw_select::clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
datawindowChild	ldwc

dw_select.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_select.GetRow()

CHOOSE CASE ls_column
		
	CASE "from_sched_date"
		
		IF ib_order_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_select.SetColumn("from_sched_date")
			dw_select.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_order_from_first = FALSE
			
		END IF
		
	CASE "to_sched_date"
		
		IF ib_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_select.SetColumn("to_sched_date")
			dw_select.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_order_to_first = FALSE
			
		END IF
End Choose
end event

type cb_clear from w_std_report`cb_clear within w_completed_order_sku_shipped_report
integer x = 3154
integer y = 20
integer width = 55
integer height = 64
end type

type dw_report from w_std_report`dw_report within w_completed_order_sku_shipped_report
integer x = 0
integer y = 376
integer width = 3625
integer height = 1516
integer taborder = 30
string dataobject = "d_completed_order_sku_shipped_report"
boolean hscrollbar = true
end type

