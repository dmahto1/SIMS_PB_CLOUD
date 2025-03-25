HA$PBExportHeader$w_cc_allocation_rpt.srw
$PBExportComments$Cycle Count Allocation Report
forward
global type w_cc_allocation_rpt from w_std_report
end type
end forward

global type w_cc_allocation_rpt from w_std_report
integer width = 3730
integer height = 2132
string title = "Allocation Report"
event ue_allocate ( )
end type
global w_cc_allocation_rpt w_cc_allocation_rpt

type variables
String	isOrigSql
Boolean ib_order_from_first, ib_order_to_first

end variables

event ue_allocate();//Long	llRowCount,	llRowPos, llOwner, llContentCount, llContentPos, llNewRow
//
//Decimal	ldAvailQty,	ldReqQty
//		
//String	lsSKU, lsWarehouse, lsFilter, lsSupplier, lsSQL
//			
//n_ds_Content	ldsCOntent
//
//ldsContent = Create n_ds_Content
//ldsContent.Dataobject = 'd_allocation_rpt_Content'
//ldsContent.SetTransObject(SQLCA)
//
//// 02/05 - PCONKL - If not excluding non shippable inv typs (meaning - we are allowing non shippable types), remove from SQL
//If dw_select.GetItemString(1,'shippable_inv_Type_ind') <> 'Y' Then
//	
//	lsSql = ldsContent.GetSqlSelect()
//	lsSQl = Replace(lsSql,pos(lsSql,"and Inventory_Type.Inventory_shippable_ind = 'Y'"),48,'')
//	ldsContent.object.datawindow.table.select = lsSql
//	Messagebox('',lsSQL)
//End If
//
////Allocate in current Sort order for Detail Records
//llRowCount = dw_report.RowCount()
//For llRowPos = 1 to llRowCount
//	
//	//Remove any previous filtering
//	ldsContent.SetFilter('')
//	ldsContent.Filter()
//	
//	lsSKU = dw_Report.GetITemString(llRowPOs,'delivery_Detail_sku')
//	lsSupplier = dw_Report.GetITemString(llRowPOs,'delivery_Detail_supp_code')
//	lswarehouse = dw_Report.GetITemString(llRowPOs,'delivery_Master_wh_code')
//	llOwner = dw_report.GetITemNumber(llRowPos,'delivery_Detail_Owner_id')
//	ldReqQty = dw_report.GetITemNumber(llRowPos,'delivery_Detail_req_qty')
//		
//	//Retrieve Content records if we dont already have (Retrievestart=2)
//	If ldsContent.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "'", 1, ldsContent.RowCOunt()) <= 0 Then
//		ldsContent.Retrieve(gs_project, lsWarehouse, lsSku)
//	End If
//	
//	//Filter for the current Detail Row.
//	lsFilter = "Upper(Content_SKU) = '" + Upper(lsSKU) + "' and c_avail_qty > 0" /*always filter by SKU  and available qty > 0*/
//	
//	//If not allowing picking by Alt Supplier, include in Filter
//	If g.is_allow_alt_supplier_pick = 'N' Then
//		lsFilter += " and Upper(Content_supp_code) = '" + Upper(lsSUpplier) + "'"
//	End If
//	
//	//If not allowing to pick from all owners, filte for current Owner
//	If dw_Select.GetITemString(1,'allow_alt_owner_Ind') <> 'Y' Then
//		lsFilter += " and Content_owner_id = " + String(llOwner)
//	End If	
//	
//	ldsContent.SetFilter(lsFilter)
//	ldsContent.Filter()
//	
//	//allocate from Content records
//	llContentCount = ldsContent.RowCount()
//	FOr llContentPos = 1 to llContentCount
//		
//		ldAvailQty = ldsContent.GetITemNumber(llContentPos,'c_avail_Qty')
//		If ldAvailQTy <= 0 Then Continue
//		
//		//If this is the first time for this detail record, update the fields on the current record, otherwise add a new row. We'll sort when we're done
//		If llContentPos = 1 then
//			llNewRow = llRowPos
//		Else
//			llNewRow = dw_report.InsertRow(0)
//			dw_report.SetITem(llNewRow,'rec_source_ind','B')
//			dw_report.SetITem(llNewRow,'delivery_master_Project_id',dw_report.GetITemString(llRowPos,'delivery_master_Project_id'))
//			dw_report.SetITem(llNewRow,'delivery_master_wh_code',dw_report.GetITemString(llRowPos,'delivery_master_wh_code'))
//			dw_report.SetITem(llNewRow,'delivery_master_Invoice_no',dw_report.GetITemString(llRowPos,'delivery_master_Invoice_no'))
//			dw_report.SetITem(llNewRow,'delivery_master_cust_order_No',dw_report.GetITemString(llRowPos,'delivery_master_cust_order_No'))
//			dw_report.SetITem(llNewRow,'delivery_master_ord_Type',dw_report.GetITemString(llRowPos,'delivery_master_ord_Type'))
//			dw_report.SetITem(llNewRow,'delivery_master_cust_code',dw_report.GetITemString(llRowPos,'delivery_master_cust_code'))
//			dw_report.SetITem(llNewRow,'delivery_master_cust_Name',dw_report.GetITemString(llRowPos,'delivery_master_cust_Name'))
//			dw_report.SetITem(llNewRow,'delivery_master_Inventory_Type',dw_report.GetITemString(llRowPos,'delivery_master_Inventory_Type'))
//			dw_report.SetITem(llNewRow,'delivery_master_Priority',dw_report.GetITemNumber(llRowPos,'delivery_master_Priority'))
//			dw_report.SetITem(llNewRow,'delivery_master_ord_date',dw_report.GetITemDateTime(llRowPos,'delivery_master_ord_date'))
//			dw_report.SetITem(llNewRow,'delivery_master_schedule_date',dw_report.GetITemDateTime(llRowPos,'delivery_master_schedule_date'))
//			dw_report.SetITem(llNewRow,'delivery_Detail_line_Item_NO',dw_report.GetITemNumber(llRowPos,'delivery_Detail_line_Item_NO'))
//			dw_report.SetITem(llNewRow,'delivery_Detail_Sku',dw_report.GetITemString(llRowPos,'delivery_Detail_Sku'))
//			dw_report.SetITem(llNewRow,'delivery_Detail_supp_code',dw_report.GetITemString(llRowPos,'delivery_Detail_supp_code'))
//			dw_report.SetITem(llNewRow,'owner_Owner_Cd',dw_report.GetITemString(llRowPos,'owner_Owner_Cd'))
//			dw_report.SetITem(llNewRow,'owner_Owner_Type',dw_report.GetITemString(llRowPos,'owner_Owner_Type'))
//			dw_report.SetITem(llNewRow,'delivery_Detail_req_qty',0)
//		End If
//		
//		dw_report.SetITem(llNewRow,'c_avail_owner', ldsContent.GetITEmString(llContentPos,'owner_Owner_Cd') + '(' + ldsContent.GetITEmString(llContentPos,'owner_Owner_Type') + ')')
//		
//		If ldAvailQty >= ldreqqty Then
//			dw_report.SetITem(llNewRow,'delivery_Detail_c_avail_qty', ldReqQty)
//			ldsContent.SetItem(llContentPos,'c_avail_qty', (ldAvailQty - ldReqQty))
//			Exit
//		Else /*not all available*/
//			dw_report.SetITem(llNewRow,'delivery_Detail_c_avail_qty', ldAvailQty)
//			ldReqQty = ldReqQty - ldAvailQty
//		End If
//				
//	Next /*Content record */
//		
//Next /*Detail Row */
//

end event

on w_cc_allocation_rpt.create
call super::create
end on

on w_cc_allocation_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
isOrigSql = dw_report.getsqlselect()


end event

event ue_retrieve;
Long	llRowCount, llPos
Integer	lirc
String	lsWhere,	lsNewSQL, lsSort
String sql_syntax, Errors
String ls_wh, lsOwnerCd
long index, i, llOwnerId, llOwnerPrev
boolean 	lb_order_from, lb_order_to
Datastore lds_cc

ls_wh =dw_select.GetITEmString(1,'wh_code')

//warehouse, cc_no, pandora_CC, Pandora_ cc_sequence_no, sku, location, owner_code, project_code QTY

If dw_select.AcceptText() < 0 Then Return

//Initialize date flags
lb_order_from 		= FALSE
lb_order_to 		= FALSE


SetPointer(HourGlass!)
dw_report.Reset()

sql_syntax = "SELECT CC_master.CC_No, CC_master.wh_code, CC_master.User_Field1, cc_generic_field.sequence, CC_master.Ord_Date, "
sql_syntax += "CASE WHEN content_summary.l_code IS NULL THEN 'No_Count' ELSE CASE WHEN content_summary.l_code = '*' THEN 'Cycle Count' "
sql_syntax += "ELSE content_summary.l_code END END AS l_code , "
sql_syntax += "CC_master.range_start, cc_generic_field.owner_id as Owner_Id, cc_generic_field.project, Sum(isnull(content_summary.alloc_qty,0))  as alloc_qty " 
sql_syntax += "FROM CC_master " 
sql_syntax += "RIGHT JOIN cc_generic_field ON CC_master.CC_No = cc_generic_field.CC_No  " 
sql_syntax += "LEFT OUTER JOIN content_summary (nolock) ON CC_master.Project_Id = content_summary.project_id AND "
sql_syntax += "CC_master.WH_Code = content_summary.wh_code AND "
sql_syntax += "cc_generic_field.Owner_Id = content_summary.Owner_Id AND "
sql_syntax += "cc_generic_field.project = content_summary.Po_No AND "
sql_syntax += "CC_master.Range_Start = content_summary.sku "  
sql_syntax += "WHERE ( CC_master.Project_Id = 'Pandora' ) AND ( CC_master.Ord_Status = 'A' )"   
	
If ls_wh <> '' and Not IsNull(ls_wh) Then
	sql_syntax += " and CC_Master.wh_code = '" + ls_wh + "'  "
End If
	
//Tackon From Order Date
If date(dw_select.GetItemDateTime(1,"Order_from_date")) > date('01-01-1900') Then
		sql_syntax += " and CC_master.Ord_Date >= '" + string(dw_select.GetItemDateTime(1,"order_from_date"),'mm-dd-yyyy hh:mm') + "'"
		lb_order_from = TRUE
End If

//Tackon To Order Date
If date(dw_select.GetItemDateTime(1,"order_to_date")) > date('01-01-1900') Then
	sql_syntax += " and CC_master.Ord_Date <= '" + string(dw_select.GetItemDateTime(1,"order_to_date"),'mm-dd-yyyy hh:mm') + "'"
	lb_order_to = TRUE
End If

	
sql_syntax += " GROUP BY CC_master.CC_No, CC_master.wh_code,  CC_master.User_Field1,  cc_generic_field.sequence, CC_master.Ord_Date, content_summary.l_code, CC_master.range_start, cc_generic_field.owner_id, cc_generic_field.project   "
	
If Upper(dw_select.GetITemString(1,'sort_order')) = 'S' Then
	sql_syntax += " Order by CC_Master.Wh_code, CC_master.range_start, CC_Master.CC_No ; "
Else 
	sql_syntax += " Order by CC_Master.Wh_code, CC_Master.CC_No, CC_master.range_start ; "
End If 		
	
//Check Order Date range for any errors prior to retrieving
IF 	((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
	 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
	 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
	messagebox("ERROR", "Please complete the FROM\TO in Order Date Range", Stopsign!)
	Return
END IF

If (dw_select.GetItemDateTime(1,"order_to_date") < dw_select.GetItemDateTime(1,"order_from_date")) AND &
	 (lb_order_from = TRUE and lb_order_to = TRUE)  THEN
	messagebox("ERROR", "FROM Date must be greater than the TO Date", Stopsign!)	
	Return
END IF
	
lds_CC = Create Datastore
lds_CC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
lds_CC.SetTransobject(sqlca)
	
IF lds_cc.Retrieve() <=0 THEN 
	MessageBox(is_title, "No Report Generated!")
	Return 
END IF

llRowCount = lds_cc.rowcount()

for index = 1 to llRowCount
	i = dw_Report.Insertrow(0)

	if  Not IsNull(lds_cc.GetITemString(index,'Owner_Id')) Then
		llOwnerID =  Long(lds_cc.GetITemString(index,'Owner_Id'))
		if llOwnerID <> llOwnerPrev then
			SELECT owner_cd INTO :lsOwnerCd 
			FROM Owner
			Where Project_id = :gs_project and owner_id = :llOwnerID;
			llOwnerPrev = llOwnerID
		End If			
	Else 
		lsOwnerCd = ''
	End If			
			
			dw_Report.setitem(i, "warehouse", lds_cc.GetITemString(index,'wh_code'))
			dw_Report.setitem(i, "cc_no", lds_cc.GetITemString(index,'cc_no'))
			dw_Report.setitem(i, "sku", lds_cc.GetITemString(index,'range_start'))
			dw_Report.setitem(i, "location", lds_cc.GetITemString(index,'l_code'))
			dw_Report.setitem(i, "alloc_qty", lds_cc.GetITemNumber(index,'alloc_qty'))
			dw_Report.setitem(i, "user_field1", lds_cc.GetITemString(index,'user_field1'))
			dw_Report.setitem(i, "user_field4", lds_cc.GetITemString(index,'sequence'))
			dw_Report.setitem(i, "Order_Date", lds_cc.GetITemDateTime(index,'Ord_Date'))
			dw_Report.setitem(i, "po_no", lds_cc.GetITemString(index,'project'))
			dw_Report.setitem(i, "Owner_Cd", lsOwnerCd)
next

If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If



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



// LTK 20150827  Commnet block above and populate warehouse DDDW via common method which uses user's configured warehouses.
DataWindowChild ldwc_warehouse
dw_select.GetChild("wh_code", ldwc_warehouse)
ldwc_warehouse.SetTransObject(sqlca)
g.of_set_warehouse_dropdown(ldwc_warehouse)

if Len( Trim( gs_default_wh )) > 0 and dw_select.RowCount() > 0 then
	dw_select.SetItem(1, "wh_code", gs_default_wh)
end if






end event

event ue_sort;call super::ue_sort;dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_cc_allocation_rpt
integer x = 18
integer y = 0
integer width = 2875
integer height = 364
string dataobject = "d_cc_allocation_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;ib_order_from_first 		= TRUE
ib_order_to_first 		= TRUE

end event

event dw_select::clicked;call super::clicked;string 	ls_column

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
		
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from w_std_report`cb_clear within w_cc_allocation_rpt
integer x = 2944
integer y = 32
integer width = 306
integer height = 136
end type

type dw_report from w_std_report`dw_report within w_cc_allocation_rpt
integer x = 0
integer y = 376
integer width = 3625
integer height = 1516
integer taborder = 30
string dataobject = "d_cc_allocation_rpt"
boolean hscrollbar = true
end type

