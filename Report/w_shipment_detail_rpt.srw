HA$PBExportHeader$w_shipment_detail_rpt.srw
$PBExportComments$Allocation Report
forward
global type w_shipment_detail_rpt from w_std_report
end type
end forward

global type w_shipment_detail_rpt from w_std_report
integer width = 3730
integer height = 2244
string title = "Shipment Detail Report"
event ue_allocate ( )
end type
global w_shipment_detail_rpt w_shipment_detail_rpt

type variables
String	isOrigSql

String is_where = ""
end variables

event ue_allocate();//Long	llRowCount,	llRowPos
////, llOwner,
//
//Long llContentCount, llContentPos
//
//Decimal	ldAvailQty,	ldReqQty
//		
//String	lsSKU, lsWarehouse, lsFilter
//
datastore ds_Content_Inbound

ds_Content_Inbound = Create datastore
ds_Content_Inbound.Dataobject = 'd_exception_rpt_content_next_inbound'
ds_Content_Inbound.SetTransObject(SQLCA)

//
//
//string lsSQL
//			
//n_ds_Content	ldsCOntent
//
//ldsContent = Create n_ds_Content
//ldsContent.Dataobject = 'd_exception_rpt_Content'
//ldsContent.SetTransObject(SQLCA)
//
//
////Allocate in current Sort order for Detail Records
//llRowCount = dw_report.RowCount()
//For llRowPos = 1 to llRowCount
//	
//	lsSKU = dw_Report.GetITemString(llRowPOs,'sku_num_at_risk')
//	lswarehouse = dw_Report.GetITemString(llRowPOs,'origin_whse')
//	ldReqQty = dw_report.GetITemNumber(llRowPos,'qty_required')
//		
//	string ls_last_wh_code, ls_last_sku
//	
//	if ls_last_wh_code <> lswarehouse or ls_last_sku <>  lsSKU then
//		
//		ldAvailQty = 0
//		
//		  SELECT  sum(dbo.Content.Avail_Qty) 
//       		 		INTO :ldAvailQty
//		 FROM dbo.Content,   
//			dbo.Inventory_Type  
//			WHERE 	Content.project_id = :gs_project and wh_code = :lsWarehouse and sku = :lsSku and
//				Content.Project_id = Inventory_Type.Project_id and 
//				Content.Inventory_Type = Inventory_Type.Inv_Type and Inventory_Type.Inventory_shippable_ind = 'Y' USING SQLCA;
//			
//			
//		IF SQLCA.SQLCode < 0 THEN
//			MessageBox ("Error", SQLCA.SQLErrText )
//		END IF
//		
//
//		ls_last_wh_code = lsWarehouse
//		ls_last_sku = lsSku
//
//	end if
//
//
//
//	
////	//Filter for the current Detail Row.
////	lsFilter = " c_avail_qty > 0" /*always filter by SKU  and available qty > 0*/
////
////	ldsContent.SetFilter(lsFilter)
////	ldsContent.Filter()
////	
//	//allocate from Content records
////	llContentCount = ldsContent.RowCount()
////	FOr llContentPos = 1 to llContentCount
////		
////		ldAvailQty = ldsContent.GetITemNumber(llContentPos,'c_avail_Qty')
//		
//		If IsNull(ldAvailQty) then ldAvailQty = 0
//		
//		If ldAvailQTy <= 0 Then Continue
//		
//			
//		If ldAvailQty >= ldreqqty Then
//			dw_report.SetITem(llRowPos,'qty_available', ldReqQty)
//			 ldAvailQty = ldAvailQty - ldReqQty
//		Else /*not all available*/
//			dw_report.SetITem(llRowPos,'qty_available', ldAvailQty)
//			 ldAvailQty =0
//		End If
//				
////	Next /*Content record */
//		
//
//		
//Next /*Detail Row */

Long	llRowCount,	llRowPos
//llOwner,
Long llContentCount, llContentPos, llNewRow

Decimal	ldAvailQty,	ldReqQty
		
String	lsSKU, lsWarehouse, lsFilter
//, lsSupplier,
String lsSQL
			
n_ds_Content	ldsCOntent

ldsContent = Create n_ds_Content
ldsContent.Dataobject = 'd_allocation_rpt_Content'
ldsContent.SetTransObject(SQLCA)

// 02/05 - PCONKL - If not excluding non shippable inv typs (meaning - we are allowing non shippable types), remove from SQL
//If dw_select.GetItemString(1,'shippable_inv_Type_ind') <> 'Y' Then
//	
//	lsSql = ldsContent.GetSqlSelect()
//	lsSQl = Replace(lsSql,pos(lsSql,"and Inventory_Type.Inventory_shippable_ind = 'Y'"),48,'')
//	ldsContent.object.datawindow.table.select = lsSql
//	Messagebox('',lsSQL)
//End If

string ls_last_warehouse = ""

//Allocate in current Sort order for Detail Records
llRowCount = dw_report.RowCount()
For llRowPos = 1 to llRowCount

	lswarehouse = trim(dw_Report.GetITemString(llRowPOs,'origin_whse'))
	
	IF ls_last_warehouse <> lswarehouse THEN
		ls_last_warehouse = lswarehouse
		ldsContent.Reset()
	END IF
	
	//Remove any previous filtering
	ldsContent.SetFilter('')
	ldsContent.Filter()
	
	lsSKU = dw_Report.GetITemString(llRowPOs,'sku_num_at_risk')
//	lsSupplier = dw_Report.GetITemString(llRowPOs,'delivery_Detail_supp_code')

//	llOwner = dw_report.GetITemNumber(llRowPos,'delivery_Detail_Owner_id')
	ldReqQty = dw_report.GetITemNumber(llRowPos,'qty_required')
		
	//Retrieve Content records if we dont already have (Retrievestart=2)
	If ldsContent.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "'", 1, ldsContent.RowCOunt()) <= 0 Then
		ldsContent.Retrieve(gs_project, lsWarehouse, lsSku)
	End If
	
	//Filter for the current Detail Row.
	lsFilter = "Upper(Content_SKU) = '" + Upper(lsSKU) + "' and c_avail_qty > 0" /*always filter by SKU  and available qty > 0*/
	
//	//If not allowing picking by Alt Supplier, include in Filter
//	If g.is_allow_alt_supplier_pick = 'N' Then
//		lsFilter += " and Upper(Content_supp_code) = '" + Upper(lsSUpplier) + "'"
//	End If
	
//	//If not allowing to pick from all owners, filte for current Owner
//	If dw_Select.GetITemString(1,'allow_alt_owner_Ind') <> 'Y' Then
//		lsFilter += " and Content_owner_id = " + String(llOwner)
//	End If	
	
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
			
			
			//---

			dw_report.SetITem(llNewRow,'Origin_Whse',dw_report.GetITemString(llRowPos,'Origin_Whse'))
			dw_report.SetITem(llNewRow,'Carrier_SCAC',dw_report.GetITemString(llRowPos,'Carrier_SCAC'))
			dw_report.SetITem(llNewRow,'Customer_Order_Num',dw_report.GetITemString(llRowPos,'Customer_Order_Num'))
			dw_report.SetITem(llNewRow,'PO_Num',dw_report.GetITemString(llRowPos,'PO_Num'))
			dw_report.SetITem(llNewRow,'Customer_Name',dw_report.GetITemString(llRowPos,'Customer_Name'))
			dw_report.SetITem(llNewRow,'Customer_City',dw_report.GetITemString(llRowPos,'Customer_City'))
			dw_report.SetITem(llNewRow,'Customer_State',dw_report.GetITemString(llRowPos,'Customer_State'))
			dw_report.SetITem(llNewRow,'LMS_Sch_Ship_Date',dw_report.GetItemDateTime(llRowPos,'LMS_Sch_Ship_Date'))
			dw_report.SetITem(llNewRow,'RAD_Date',dw_report.GetItemDateTime(llRowPos,'RAD_Date'))
			dw_report.SetITem(llNewRow,'SKU_Num_At_Risk',dw_report.GetITemString(llRowPos,'SKU_Num_At_Risk'))
			dw_report.SetITem(llNewRow,'QTY_Required',0)
	
		End If
		
//		dw_report.SetITem(llNewRow,'c_avail_owner', ldsContent.GetITEmString(llContentPos,'owner_Owner_Cd') + '(' + ldsContent.GetITEmString(llContentPos,'owner_Owner_Type') + ')')
		
		If ldAvailQty >= ldreqqty Then
			dw_report.SetITem(llNewRow,'qty_available', ldReqQty)
			ldsContent.SetItem(llContentPos,'c_avail_qty', (ldAvailQty - ldReqQty))
			Exit
		Else /*not all available*/
			dw_report.SetITem(llNewRow,'qty_available', ldAvailQty)
			ldReqQty = ldReqQty - ldAvailQty
		End If
				
	Next /*Content record */
		
Next /*Detail Row */




//-----

dw_report.SetFilter ( "qty_available <> qty_required")
dw_report.Filter()	

llRowCount = dw_report.RowCount()


//ds_Content_Inbound.Retrieve(gs_project)

//decimal ldReqAvailQty, ld_Needed

for llRowPos = 1 to llRowCount	

//	lsSKU = dw_report.GetITemString(llRowPOs,'sku_num_at_risk')
//	lswarehouse = dw_report.GetITemString(llRowPOs,'origin_whse')
//	ldReqQty = dw_report.GetITemNumber(llRowPos,'qty_required')
//	ldReqAvailQty = dw_report.GetITemNumber(llRowPos,'qty_available')	
//	ld_Needed = ldReqQty - ldReqAvailQty
//
//
////	IF lsSKU = "30237" THEN
////		MessageBox ("sku2", lsSKU)
////	END IF
//
//	//Retrieve Content records if we dont already have (Retrievestart=2)
//	llContentPos = ds_Content_Inbound.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "' AND Upper(wh_code) = '" + Upper(lswarehouse) + "'", 1, ds_Content_Inbound.RowCOunt()) 
//
//	If llContentPos > 0 Then
//
//		DO
//	
//			If llContentPos > 0 Then
//		
//				ldAvailQty = ds_Content_Inbound.GetITemNumber(llContentPos,'req_qty')
//		
//				IF ldAvailQty < ld_Needed THEN
//		
//					ds_Content_Inbound.SetItem(llContentPos,'req_qty', 0)			
//		
//					ld_Needed = ld_Needed - ldAvailQty
//		
//					llContentPos = ds_Content_Inbound.Find("Upper(Content_SKU) = '" + Upper(lsSKU) + "' AND Upper(wh_code) = '" + Upper(lswarehouse) + "' AND req_qty > 0 ", llContentPos, ds_Content_Inbound.RowCOunt()) 
//		
//		
//				ELSE
//					
//					ds_Content_Inbound.SetItem(llContentPos,'req_qty', (ldAvailQty - ld_Needed))
//					
//					dw_report.SetITem(llRowPos,'sku_num_proj_ib_arival_date', ds_Content_Inbound.GetITemDateTime(llContentPos,'ord_date'))
//					
//		
//					llContentPos = 0
//					
//				END IF
//				
//			END IF
//	
//		LOOP UNTIL llContentPos = 0 or llContentPos >= ds_Content_Inbound.RowCount()
//
//
//	END IF

	dw_report.SetItem(llRowPos,'qty_short', (dw_report.GetItemDecimal(llRowPos,'qty_required')-dw_report.GetItemDecimal(llRowPos,'qty_available')))


next


string lsCurrentWarehouse

lsCurrentWarehouse = ""	
	
for llRowPos = 1 to dw_report.RowCount()

	lswarehouse = dw_report.GetITemString(llRowPOs,'origin_whse')

	if llRowPos = 1 then lsCurrentWarehouse = lswarehouse


	if lsCurrentWarehouse <> lswarehouse then
		
		dw_report.InsertRow(llRowPos)
	
		lsCurrentWarehouse = lswarehouse
	
	end if

next

destroy ds_Content_Inbound;
end event

on w_shipment_detail_rpt.create
call super::create
end on

on w_shipment_detail_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;

isOrigSql = dw_report.getsqlselect()




end event

event ue_retrieve;Long	llRowCount, llPos
Integer	lirc

If dw_select.AcceptText() < 0 Then Return

is_where = ""

SetPointer(Hourglass!)
dw_report.SetRedraw(False)
//
////Tackon search criteria
//
///* always tackon Project and warehouse and new order status*/
//
////lsWhere = " and Delivery_MAster.Project_ID = '" + gs_project  + "' "
//
////+ "' and wh_code = '" + dw_select.GetITEmString(1,'wh_code') + "' " 
//


//Add warehouse if PResent
If dw_Select.GetItemString(1,'wh_code') > ' ' Then
	is_Where += " and wh_code = '" + dw_select.GetITEmString(1,'wh_code') + "' "
End If


////lsWhere += " and ord_status = 'N' "
//
//Add Cust Code if PResent
If dw_Select.GetItemString(1,'Carrier') > ' ' Then
	is_Where += " and carrier = '" + dw_Select.GetItemString(1,'carrier') + "' "
End If

//////Add Order Type if PResent
////If dw_Select.GetItemString(1,'order_Type') > ' ' Then
////	lsWhere += " and ord_Type = '" + dw_Select.GetItemString(1,'order_Type') + "' "
////End If
////
//////Add Order Number if Present
////If dw_Select.GetItemString(1,'Invoice_no') > ' ' Then
////	lsWhere += " and Invoice_no = '" + dw_Select.GetItemString(1,'Invoice_no') + "' "
////End If
////

// From Sched Date
If date(dw_select.GetItemDateTime(1,"from_SChed_Date")) > date('01-01-1900') Then
	is_Where += " and Delivery_master.Schedule_Date >= '" + string(dw_select.GetItemDateTime(1,"from_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

// From To Date
If date(dw_select.GetItemDateTime(1,"to_SChed_Date")) > date('01-01-1900') Then
	is_Where += " and Delivery_master.Schedule_Date <= '" + string(dw_select.GetItemDateTime(1,"to_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
End If

//Modify SQL


//datetime ldt_start, ldt_end
//
///// From Sched Date
////If date(dw_select.GetItemDateTime(1,"from_SChed_Date")) > date('01-01-1900') Then
////	lsWhere += " and schedule_date >= '" + string(dw_select.GetItemDateTime(1,"from_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
////End If
////
////// From To Date
////If date(dw_select.GetItemDateTime(1,"to_SChed_Date")) > date('01-01-1900') Then
////	lsWhere += " and schedule_date <= '" + string(dw_select.GetItemDateTime(1,"to_SChed_Date"),'mm-dd-yyyy hh:mm') + "' "
////End If
//
//integer li_day_num
//
//choose case DayNumber ( today() )
//
//case 1 //Sunday
//	li_day_num = 3
//case 2 //Monday
//	li_day_num = 3
//case 3
//	li_day_num = 3
//case 4
//	li_day_num = 5
//case 5
//	li_day_num = 5	
//case 6
//	li_day_num = 5	
//case 7
//	li_day_num = 4
//end choose
//
//ldt_start = DateTime( RelativeDate ( today(), -30 ), Time("00:00:00"))
//ldt_end =  DateTime( RelativeDate ( today(), li_day_num ), Time("23:59:59"))
//
llRowCount  = dw_report.Retrieve(gs_project)


dw_report.SetRedraw(True)


If llRowCount > 0 Then
	im_menu.m_file.m_print.Enabled = True
	dw_report.Setfocus()
Else
	im_menu.m_file.m_print.Enabled = False	
	MessageBox(is_title, "No records found!")
	dw_select.Setfocus()
End If

//integer li_idx

//for li_idx = 1 to dw_report.RowCount()
//	dw_report.SetItem( li_idx, "est_pallets", dw_report.GetItemDecimal (li_idx, "calc_est_pallets"))
//next






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



dw_select.GetChild("carrier", ldwc)

// 04/04 - PCONKL - Share carrier dropdowns with DS Loaded in Project Open
g.ids_dddw_carrier.ShareData(ldwc)


// From To Date
dw_select.SetItem(1,"to_SChed_Date", datetime( RelativeDate ( today(), 1 ), time("23:59:59")))







end event

event ue_sort;call super::ue_sort;//dw_Report.GroupCalc()
Return 0
end event

type dw_select from w_std_report`dw_select within w_shipment_detail_rpt
integer x = 14
integer y = 4
integer width = 3351
integer height = 292
string dataobject = "d_shipment_detail_rpt_search"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_select::constructor;
If g.is_owner_ind <> 'Y' Then
	This.modify("allow_alt_owner_ind.visible=False")
End If
end event

type cb_clear from w_std_report`cb_clear within w_shipment_detail_rpt
integer x = 3154
integer y = 20
integer width = 55
integer height = 64
end type

type dw_report from w_std_report`dw_report within w_shipment_detail_rpt
integer x = 14
integer y = 336
integer width = 3625
integer height = 1672
integer taborder = 30
string dataobject = "d_shipment_detail_rpt"
boolean hscrollbar = true
end type

event dw_report::sqlpreview;call super::sqlpreview;integer li_pos
string lsNewSQL
	

if is_Where <> "" then


	
	li_pos = Pos (sqlsyntax, "GROUP")
	
	lsNewSQL = Left(sqlsyntax, (li_pos -1)) + is_Where +" " +  Mid( sqlsyntax, li_Pos )

	this.SetSQLPreview( lsNewSQL)

end if


end event

