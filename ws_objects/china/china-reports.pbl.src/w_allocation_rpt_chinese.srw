$PBExportHeader$w_allocation_rpt_chinese.srw
$PBExportComments$Allocation Report
forward
global type w_allocation_rpt_chinese from w_std_report
end type
end forward

global type w_allocation_rpt_chinese from w_std_report
integer width = 3730
integer height = 2132
string title = "Delivery Availability Report"
event ue_allocate ( )
end type
global w_allocation_rpt_chinese w_allocation_rpt_chinese

type variables
String	isOrigSql


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

on w_allocation_rpt_chinese.create
call super::create
end on

on w_allocation_rpt_chinese.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;Long	llRowCount, llPos
Integer	lirc
String	lsWhere,	lsNewSQL, lsSort

If dw_select.AcceptText() < 0 Then Return

SetPointer(Hourglass!)
dw_report.SetRedraw(False)

//Tackon search criteria

/* always tackon Project and warehouse and new order status*/
lsWhere = " and Delivery_MAster.Project_ID = '" + gs_project + "' and wh_code = '" + dw_select.GetITEmString(1,'wh_code') + "' " 
lsWhere += " and ord_status = 'N' "

//Add Cust Code if PResent
If dw_Select.GetItemString(1,'Customer') > ' ' Then
	lsWhere += " and cust_code = '" + dw_Select.GetItemString(1,'Customer') + "' "
End If

//Add Order Type if PResent
If dw_Select.GetItemString(1,'order_Type') > ' ' Then
	lsWhere += " and ord_Type = '" + dw_Select.GetItemString(1,'order_Type') + "' "
End If

//Add Order Number if Present
If dw_Select.GetItemString(1,'Invoice_no') > ' ' Then
	lsWhere += " and Invoice_no = '" + dw_Select.GetItemString(1,'Invoice_no') + "' "
End If

// From Sched Date
If date(dw_select.GetItemDateTime(1,"from_SChed_Date")) > date('01-01-1900') Then
	lsWhere += " and schedule_date >= '" + string(dw_select.GetItemDateTime(1,"from_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

// From To Date
If date(dw_select.GetItemDateTime(1,"to_SChed_Date")) > date('01-01-1900') Then
	lsWhere += " and schedule_date <= '" + string(dw_select.GetItemDateTime(1,"to_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

//Modify SQL

// 01/05 - to support Components, we need to add Where before Union and at end

lsNewSQL = isOrigSql + lsWhere
lsNewSQL = Replace(lsNewSql, (Pos(Upper(lsNewSql),'UNION') - 1),1,lsWhere)
dw_Report.SetSQLSelect(lsNewSQL)

llRowCount = dw_report.Retrieve()
If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

//Sort orders before allocating
Choose Case Upper(dw_select.GetITemString(1,'sort_order'))
	Case 'O' /*Sort by Order*/
		lsSort = "delivery_master_invoice_no A, Delivery_Detail_Line_Line_Item_No A"
	Case 'P' /*priority*/
		lsSort = "Delivery_Master_Priority A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
	Case 'S' /*Schedule_Date */
		lsSort = "Delivery_Master_Schedule_Date A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
	Case 'C'
		lsSort = "Delivery_Master_Cust_Code A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A"
End Choose

lirc = dw_Report.SetSort(lsSort)
Dw_Report.Sort()

// Allocate
This.TriggerEvent('ue_allocate')

//resort
Choose Case Upper(dw_select.GetITemString(1,'sort_order'))
	Case 'O' /*Sort by Order*/
		lsSort = "C_Avail_sort_Ind A, delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A, rec_source_ind A"
	Case 'P' /*priority*/
		lsSort = "C_Avail_sort_Ind A, Delivery_Master_Priority A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A, Delivery_Detail_Sku A, rec_source_ind A"
	Case 'S' /*Schedule_Date */
		lsSort = "C_Avail_sort_Ind A, Delivery_Master_Schedule_Date A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A, Delivery_Detail_Sku A, rec_source_ind A"
	Case 'C' /*Customer*/
		lsSort = "C_Avail_sort_Ind A, Delivery_Master_Cust_Code A delivery_master_invoice_no A, Delivery_Detail_Line_Item_No A, Delivery_Detail_Sku A, rec_source_ind A"
End Choose


//Hide Owner if not tracking by
If g.is_owner_ind <> 'Y' Then
	dw_report.modify("c_req_owner.visible=False delivery_detail_owner_id_t.visible=False c_avail_owner.visible=False")
End If
dw_report.SetRedraw(True)

lirc = dw_report.SetSort(lsSort)
lirc = dw_Report.Sort()
dw_Report.GroupCalc()

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

type dw_select from w_std_report`dw_select within w_allocation_rpt_chinese
integer x = 18
integer y = 0
integer width = 3351
integer height = 364
string dataobject = "d_allocation_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
If g.is_owner_ind <> 'Y' Then
	This.modify("allow_alt_owner_ind.visible=False")
End If

g.of_check_label(this) 
end event

type cb_clear from w_std_report`cb_clear within w_allocation_rpt_chinese
integer x = 3154
integer y = 20
integer width = 55
integer height = 64
end type

type dw_report from w_std_report`dw_report within w_allocation_rpt_chinese
integer x = 0
integer y = 376
integer width = 3625
integer height = 1516
integer taborder = 30
string dataobject = "d_allocation_rpt_chinese"
boolean hscrollbar = true
end type

