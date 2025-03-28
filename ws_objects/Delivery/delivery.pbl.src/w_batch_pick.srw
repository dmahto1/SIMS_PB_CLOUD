$PBExportHeader$w_batch_pick.srw
$PBExportComments$*+Batch Pick Master
forward
global type w_batch_pick from w_std_master_detail
end type
type cb_batch from commandbutton within tabpage_main
end type
type cb_cust from commandbutton within tabpage_main
end type
type st_batch_pick_id_t from statictext within tabpage_main
end type
type sle_batch_id from singlelineedit within tabpage_main
end type
type cb_confirm from commandbutton within tabpage_main
end type
type cb_generate from commandbutton within tabpage_main
end type
type dw_batch_master from u_dw_ancestor within tabpage_main
end type
type cb_confirmall from commandbutton within tabpage_search
end type
type cb_clearall from commandbutton within tabpage_search
end type
type cb_selectall from commandbutton within tabpage_search
end type
type cb_2 from commandbutton within tabpage_search
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_result from u_dw_ancestor within tabpage_search
end type
type dw_search from datawindow within tabpage_search
end type
type tabpage_order_detail from userobject within tab_main
end type
type em_delivery_dt from editmask within tabpage_order_detail
end type
type cb_update_delivery_dt from commandbutton within tabpage_order_detail
end type
type cb_remove_orders from commandbutton within tabpage_order_detail
end type
type dw_batch_details from u_dw_ancestor within tabpage_order_detail
end type
type tabpage_order_detail from userobject within tab_main
em_delivery_dt em_delivery_dt
cb_update_delivery_dt cb_update_delivery_dt
cb_remove_orders cb_remove_orders
dw_batch_details dw_batch_details
end type
type tabpage_pick from userobject within tab_main
end type
type cb_mobile from commandbutton within tabpage_pick
end type
type cb_send_to_cart from commandbutton within tabpage_pick
end type
type dw_pick_print from datawindow within tabpage_pick
end type
type cb_pick_print from commandbutton within tabpage_pick
end type
type cb_pick_copy from commandbutton within tabpage_pick
end type
type cb_delete_pick from commandbutton within tabpage_pick
end type
type cb_insert_pick from commandbutton within tabpage_pick
end type
type cb_picklocs from commandbutton within tabpage_pick
end type
type cb_generate_pick from commandbutton within tabpage_pick
end type
type dw_pick from u_dw_ancestor within tabpage_pick
end type
type tabpage_pick from userobject within tab_main
cb_mobile cb_mobile
cb_send_to_cart cb_send_to_cart
dw_pick_print dw_pick_print
cb_pick_print cb_pick_print
cb_pick_copy cb_pick_copy
cb_delete_pick cb_delete_pick
cb_insert_pick cb_insert_pick
cb_picklocs cb_picklocs
cb_generate_pick cb_generate_pick
dw_pick dw_pick
end type
type tabpage_pack from userobject within tab_main
end type
type cb_print_dn from commandbutton within tabpage_pack
end type
type st_carrier_ship_date from statictext within tabpage_pack
end type
type em_carrier_ship_date from editmask within tabpage_pack
end type
type dw_pack_labels from datawindow within tabpage_pack
end type
type cb_carrier_labels from commandbutton within tabpage_pack
end type
type dw_packprint from datawindow within tabpage_pack
end type
type cb_pack_print from commandbutton within tabpage_pack
end type
type cb_delete_pack from commandbutton within tabpage_pack
end type
type cb_insert_pack from commandbutton within tabpage_pack
end type
type cb_pack_copy from commandbutton within tabpage_pack
end type
type cb_generate_pack from commandbutton within tabpage_pack
end type
type dw_pack from u_dw_ancestor within tabpage_pack
end type
type tabpage_pack from userobject within tab_main
cb_print_dn cb_print_dn
st_carrier_ship_date st_carrier_ship_date
em_carrier_ship_date em_carrier_ship_date
dw_pack_labels dw_pack_labels
cb_carrier_labels cb_carrier_labels
dw_packprint dw_packprint
cb_pack_print cb_pack_print
cb_delete_pack cb_delete_pack
cb_insert_pack cb_insert_pack
cb_pack_copy cb_pack_copy
cb_generate_pack cb_generate_pack
dw_pack dw_pack
end type
type tabpage_trax from userobject within tab_main
end type
type st_1 from statictext within tabpage_trax
end type
type ddlb_trax_printer from dropdownlistbox within tabpage_trax
end type
type cb_trax_print_label from commandbutton within tabpage_trax
end type
type cb_trax_void from commandbutton within tabpage_trax
end type
type cb_trax_ship from commandbutton within tabpage_trax
end type
type cb_trax_clearrall from commandbutton within tabpage_trax
end type
type cb_trax_selectall from commandbutton within tabpage_trax
end type
type dw_trax from u_dw_ancestor within tabpage_trax
end type
type tabpage_trax from userobject within tab_main
st_1 st_1
ddlb_trax_printer ddlb_trax_printer
cb_trax_print_label cb_trax_print_label
cb_trax_void cb_trax_void
cb_trax_ship cb_trax_ship
cb_trax_clearrall cb_trax_clearrall
cb_trax_selectall cb_trax_selectall
dw_trax dw_trax
end type
end forward

global type w_batch_pick from w_std_master_detail
integer width = 4128
integer height = 2560
string title = "Batch Picking"
event ue_generate_batch ( )
event ue_generate_pick ( )
event ue_confirm ( )
event ue_void ( )
event ue_generate_pack ( )
event ue_backorder ( )
event ue_drop_raw ( )
event ue_generate_pick_server ( )
event ue_print_summary ( )
event ue_print_order_picklist_babycare ( )
event ue_send_to_pick_cart ( )
event ue_process_mobile ( )
end type
global w_batch_pick w_batch_pick

type variables
Datawindow 	idw_search,	&
				idw_result,	&
				idw_master,	&
				idw_detail,	&
				idw_Pick,	&
				idw_Pack,	&
				idw_Print,	&
				idw_packPrint,	&
				idw_packLabels, &
				idw_trax, idw_sikbatch
				
				
DatawindowChild idwc_carton_type
				
SingleLineEdit	isle_Batch_ID

w_batch_pick	iw_Window

String	isOrigSQL_Detail,	&
			isOrigSQL_Pick,	&
			isOrigSQL_Search,	&
			isColumn,	&
			is_Carrier_ship_date,	&
			isUpdateSql[]
			
n_warehouse i_nwarehouse

Datastore	IdsContent,	&
				IdsPickDetail, &
				IdsOrderData
				
Boolean		ibbatchCriteriaChanged,	&
				ibGenerateBatch,			&
				ibGeneratePick,			&
				ibDEleteBatch,				&
				ibDropRaw,					&
				ibPickChanged,				&
				ibpickmodified,			&
				ibServerAllocationEnabled,	&
				ibDisableDeleteWarning

Long			ilcurrpickrow, 				&
 				il_BatchPickIDs[]

// pvh gmt 12/28/05
string isWarehouse

// pvh 02/10/06
str_parms	istrAddressData
datastore idsDeliveryMaster

inet	linit
u_nvo_websphere_post	iuoWebsphere
string isShipRef,is_invoiceno
Long	ilSetRow
String	isTraxWarehouse

end variables

forward prototypes
public function integer wf_update_content ()
public function integer wf_check_status ()
public function integer wf_validate ()
public function integer wf_enable_trax ()
public subroutine setwarehouse (string _value)
public function string getwarehouse ()
public subroutine setaddressdata (string asdono)
public function str_parms getaddressdata ()
public function string getdetailuserfield1 (string asordernumber, string assku, long lineitemnumber)
public function integer wf_update_content_server ()
public subroutine wf_set_filter_carton_type ()
public function integer uf_enable_first_carton_row (integer airow, string asorder, string ascarton)
public function integer uf_update_carton_rows (integer airow, string ascolumn, decimal advalue)
public function integer uf_get_order_data ()
public function integer uf_create_batch_transactions (integer asbatchpickid, datetime asdtgmttoday)
public function long uf_get_serial_detail_quantity (string asdono)
public function integer wf_load_trax_printer_list ()
public subroutine wf_set_line_no_babycare ()
public function integer wf_check_status_mobile ()
end prototypes

event ue_generate_batch();//generate a list of orders to pick based on Batch Criteria

String	lsOrdType, lsCustType, lsCustCode, lsCarrier, lsWarehouse,	lsOrderFrom,	&
			lsOrderTo, lsNewSql,	lsModify, lsLastUserId, lsLastUserCheck, lsCustOrder, lsSKU,lsSupplier, &
			lsTempSQL,lsMultCust, lsItemCartStatus, lsConsolNo, lsOrderList, lsMultiOrders

Long	llBatchID,	&
		llRowCount,	&
		llRowPos,	&
		llFindRow,    &
		llQtyForSku, &
		llOrdersForBatch, &
		llLine,	&
		llPos, llCount
		
Dec	ldOrderVolume
Integer	liMsg
Boolean	lbIncludeHold, lbSku
DateTime	ldtFrom, ldtTo

lbIncludeHold = False

If idw_master.RowCount() <= 0 Then Return
If idw_MAster.AcceptText() < 0 Then Return

//Warn if Pick List or Detail List has already been generated
If idw_Pick.RowCount() > 0 or idw_Detail.RowCount() > 0 Then
	If MessageBox(is_title,'Warning! This will clear existing Detail Rows!.~r~rDo you want to continue?',Stopsign!,YesNo!,2) = 2 Then
		Return
	End If
End If

//If there are already detail rows, we need to reset the Batch Pick Id to Null to 'Release' them
If idw_Detail.RowCount() > 0 Then
	
	llBatchID = idw_master.GetITemNumber(1,'batch_pick_id')
	
	//Delete the PAck Rows
	idw_pack.SetRedraw(False)
	llRowCount = idw_pack.RowCount()
	For llRowPos = llRowCount to 1 Step -1
		If idw_pack.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pack.GetITemString(llRowPos,'ord_Status') = 'D' or idw_pack.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
		idw_pack.DeleteRow(llRowPos)
	Next

	idw_pack.SetRedraw(True)
	
	//Delete the Pick Rows and Update the Content records - Don't Delete any rows for orders that have been confirmed or Voided
	idw_pick.SetRedraw(False)
	llRowCount = idw_pick.RowCount()
	For llRowPos = llRowCount to 1 Step -1
		If idw_pick.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pick.GetITemString(llRowPos,'ord_Status') = 'D' or idw_pick.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
		idw_pick.DeleteRow(llRowPos)
	Next
	
	idw_pick.SetRedraw(True)
		
	If llBatchID > 0 Then
		//'Release' details
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		Update Delivery_MAster
		Set Batch_Pick_id = 0, ord_status = 'N'
		Where Project_id = :gs_project and batch_Pick_id = :llBatchID and ord_status Not in('C', 'D', 'V');
		
		Execute Immediate "COMMIT" using SQLCA; /* 11/04 - PCONKL - need a commit within this transaction before callin use_save*/
		
	End If
	
	idw_detail.Reset()
	
	ibDEleteBatch = True
	ibGenerateBatch = True /* we wont be able to save if the criteria has changed unless we are re-generating the batch*/
	If iw_window.Trigger Event ue_save() = -1 Then Return
	ibGenerateBatch = False
	IbDEletebatch = False
	
	idw_pick.Reset() /*contents have been 'released', clear the DW */
	
	ib_changed = True
	
End If /*batch already exists*/


idw_detail.Reset()

//Build the List of Details based on the entered Batch Criteria
lsOrdType = Idw_Master.GetITemString(1,'ord_type')
lsWarehouse = Idw_Master.GetITemString(1,'wh_code')
lsCustType = Idw_Master.GetITemString(1,'customer_type')
lsCustCode = Idw_Master.GetITemString(1,'cust_code')
lsCarrier = Idw_Master.GetITemString(1,'carrier')
lsOrdType = Idw_Master.GetITemString(1,'ord_type')
lsOrderList = Idw_Master.GetITemString(1,'invoice_no_list') //29-May-2018 :Madhu S19740 - Added Order List
lsOrderFrom = Idw_Master.GetITemString(1,'invoice_no_from')
lsOrderTo = Idw_Master.GetITemString(1,'invoice_no_to')
lsCustOrder = Idw_Master.GetITemString(1,'cust_order_no')
lsLastUserCheck = Idw_Master.GetITemString(1,'user_check')
lsLastUserId = Idw_Master.GetITemString(1,'last_user')
lsSKU = Idw_Master.GetITemString(1,'SKU')
llQtyForSku = Idw_Master.GetITemNumber(1,'qty_for_sku')  // 07/19/2010 ujhall: 07 of 12 Comcast SIK Batch Picking: 
llOrdersForBatch = long(Idw_Master.GetITemNumber(1,'orders_for_batch'))  // 07/19/2010 ujhall: 08 of 12 Comcast SIK Batch Picking: 
lsSupplier = Idw_Master.GetITemString(1,'Supp_code')
ldtFrom = idw_Master.GetITemDateTime(1,'ord_date_From')
ldtTo = idw_Master.GetITemDateTime(1,'ord_date_To')
llLine = Idw_Master.GetITemNumber(1,'Line_Item_Count')  //Jxlim 04/19/2013 Physio PHC-CR13-034 Add 1 line orders to batch selection; leveraging for baseline
ldOrderVolume = Idw_Master.GetITemNumber(1,'order_Volume') /* 10/13 - PCONKL */
lsItemCartStatus =  Idw_Master.GetITemString(1,'Item_Ugly_Ind')
lsConsolNo =  Idw_Master.GetITemString(1,'Consolidation_No') /* n01/16 - PCONKL */

//29-May-2018 :Madhu S19740 - Added Order List - START
If (lsOrderList >'' and (lsOrderFrom >'' or lsOrderTo >'')) Then
	Messagebox(is_Title,' Would you please use anyone of the Order Search Criteria. ~n Either Order List (OR) Order Nbr Range (From & To). ~nBut NOT both!', Stopsign!)
	ib_changed = False
	Return
End If
//29-May-2018 :Madhu S19740 - Added Order List - END


//Build SQL for retrieving Order records
lsNewSql = " And Delivery_MAster.Project_id = '" + gs_project + "'" /*always include Project*/

//Warehouse is the only required field, will always be filled in if default warehouse is set
If lsWarehouse > '' Then
	lsNewSql += " and wh_code = '" + lsWarehouse + "'" 
Else
	Messagebox(is_title,'Warehouse is Required!',Stopsign!)
	idw_master.SetFocus()
	idw_MAster.SetColumn('wh_code')
	Return
End If

//Order Type if present
If lsOrdType > '' Then
	lsNewSQL += " and ord_type = '" + lsOrdType + "'"
End If

//Customer if present
// 05/13 - PCONKL - allowing multiple customers to be included
If lsCustCode > '' Then
	
	If pos(lsCustCode,',') > 0 Then /* multiple customers*/
	
		llCount = Len(lsCustCode)
		for llPos = 1 to llCount
			
			If Mid(lsCustCode,llPos,1) = ' ' THen Continue
			
			If Mid(lsCustCode,llPos,1) = ',' Then
				lsMultCust += "'" + Mid(lsCustCode,llPos,1)  + "'"
			Else
				lsMultCust +=Mid(lsCustCode,llPos,1)
			End If
			
		Next
		
		lsMultCust ="'" + lsMultCust + "'"
		
		lsNewSQL += " and cust_code in (" + lsMultCust + ") "
		
	Else
		lsNewSQL += " and cust_code = '" + lsCustCode + "'"
	End If
			
End If

//Customer Type if present
If lsCustType > '' Then
	lsNewSQL += " and Cust_code in (select Cust_code from Customer where Project_id = '" + gs_project + "' and customer_type = '" + lsCustType + "')"
End If

//Carrier if present
If lsCarrier > '' Then
	lsNewSQL += " and carrier = '" + lsCarrier + "'"
End If

//From Order if present
If lsOrderFrom > '' Then
	lsNewSQL += " and invoice_no >= '" + lsOrderFrom + "'"
End If

//To Order if present
If lsOrderTo > '' Then
	lsNewSQL += " and invoice_no <= '" + lsOrderTo + "'"
End If

//Cust Order Nbr if present
If lsCustOrder > '' Then
	lsNewSQL += " and cust_order_No = '" + lsCustOrder + "'"
End If

//09/09 -PCONKL - Added Order Date Range
If  Not IsNull(ldtFrom) Then
	lsNewSQL += " and delivery_master.ord_date >= '" + String(ldtFrom, "yyyy-mm-dd hh:mm:ss") + "' "
End If

If  Not IsNull(ldtTo) Then
	lsNewSQL += " and delivery_master.ord_date <= '" + String(ldtTo, "yyyy-mm-dd hh:mm:ss") + "' "
End If

//01/16 - PCONKL - added Consolidation No
If lsConsolNo > '' Then
	lsNewSQL += " and Consolidation_No = '" + lsConsolNo + "'"
End If

//09/09 - PCONKL - Add Supplier
// 11/14 - PCONKL - allowing multiple customers to be included

//If lsSupplier > '' Then
//	lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "' and supp_code = '" + lsSupplier + "') "
//End If

String	lsMultiSupplier

If lsSupplier > '' Then
	
	If pos(lsSupplier,',') > 0 Then /* multiple Suppliers*/
	
		llCount = Len(lsSupplier)
		for llPos = 1 to llCount
			
			If Mid(lsSupplier,llPos,1) = ' ' THen Continue
			
			If Mid(lsSupplier,llPos,1) = ',' Then
				lsMultiSupplier += "'" + Mid(lsSupplier,llPos,1)  + "'"
			Else
				lsMultiSupplier +=Mid(lsSupplier,llPos,1)
			End If
			
		Next
		
		lsMultiSupplier ="'" + lsMultiSupplier + "'"
		
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "' and supp_code in (" + lsMultiSupplier + ")) "
		
	Else /*Single Supplier*/
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "' and supp_code = '" + lsSupplier + "') "
	End If
			
End If

//29-May-2018 :Madhu S19740 - Added Order List - START
If lsOrderList > '' Then
	
	If pos(lsOrderList,',') > 0 Then /* multiple order no's*/
	
		llCount = Len(lsOrderList)
		for llPos = 1 to llCount
			
			If Mid(lsOrderList,llPos,1) = ' ' THen Continue
			
			If Mid(lsOrderList,llPos,1) = ',' Then
				lsMultiOrders += "'" + Mid(lsOrderList,llPos,1)  + "'"
			Else
				lsMultiOrders +=Mid(lsOrderList,llPos,1)
			End If
			
		Next
		
		lsMultiOrders ="'" + lsMultiOrders + "'"
		
		lsNewSQL += " and invoice_no in (" + lsMultiOrders + ") "
		
	Else
		lsNewSQL += " and invoice_no = '" + lsOrderList + "'"
	End If
			
End If

//29-May-2018 :Madhu S19740 - Added Order List - END

//If Last User Check is on 
If lsLastUserCheck = '1' Then
	lsNewSQL += " and Delivery_MAster.last_user = '" + lsLastUserId + "'"
End If

// 02/07 - include only orders where SKU is present
If lsSKU > "" Then		//Sku entered on the criteria screen
	// 07/19/2010 ujhall: 12p2 of12 Comcast SIK Batch Picking: If > 0,  Limit returned rows by the manually entered Qty_For_Sku.
	if llQtyForSku > 0 then
		//	lsNewSQL += " and Delivery_Master.do_no in (Select do_no from Delivery_Detail where do_no like '"&
		//	+ gs_project + "%' and sku = '" + lsSKU + "' and req_qty = '" + String(llQtyForSku,"0") + "') "
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "' and sku = '" + lsSKU  +  "' and req_qty = '" + String(llQtyForSku,"0") + " ') "
				
				//Jxlim 04/19/2013 Physio PHC-CR13-034 Add 1 line orders to batch selection; leveraging for baseline
				//If Line Item was entered then add line_item to where clause that has all the qualifiers (filter)
				If  llLine  > 0 Then
					lsNewSql = Left(lsNewSql, len(lsNewSql) - 2)
					//Added group by and Having
					lsNewSql +="~rGroup by Delivery_MAster.Do_no"
					lsNewSql += "~rHaving Count(Delivery_Detail.line_item_No) = " + String(llLine) + ")"		
				End If
	else
		//lsNewSQL += " and Delivery_Master.do_no in (Select do_no from Delivery_Detail where do_no like '" + gs_project + "%' and sku = '" + lsSKU + "') "
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "' and sku = '" + lsSKU + " ') "
		//lsNewSQL += " and Delivery_Master.do_no in (" +lsTempSQL + " where do_no like '" + gs_project + "%' and sku = '" + lsSKU + "') "

				//Jxlim 04/19/2013 Physio PHC-CR13-034 Add 1 line orders to batch selection; leveraging for baseline
				//If Line Item was entered then add line_item to where clause that has all the qualifiers (filter)
				If  llLine  > 0 Then
					lsNewSql = Left(lsNewSql, len(lsNewSql) - 2)
					//Added group by and Having
					lsNewSql +="~rGroup by Delivery_MAster.Do_no"
					lsNewSql += "~rHaving Count(Delivery_Detail.line_item_No) = " + String(llLine) + ")"		
				End If
	end if  //End for Qty
Else //Sku not entered on the criteria screen
	//25-Jun-2013 :Madhu - Added condition to retrieve the data based on QtyforSku, if sku is blank -START
	If (IsNull(lsSKU) and llQtyForSku > 0) Then
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project +  "' and req_qty = '" + String(llQtyForSku,"0") + " ') "
	end if	
	//25-Jun-2013 :Madhu - Added condition to retrieve the data based on QtyforSku, if sku is blank -END
	
	//Jxlim 05/01/2013 Add Line Item count  
	If llLine > 0 Then
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail where delivery_Master.do_no = delivery_detail.do_no and ord_status = 'N' and Project_id = '" + gs_Project + "'"  
		//Added group by and Having
		lsNewSql +="~rGroup by Delivery_MAster.Do_no"
		lsNewSql += "~rHaving Count(Delivery_Detail.line_item_No) = " + String(llLine) + ")"
	End If
End If

//10/13 - PCONKL - Include/exclude orders with Item Cart Statuses
Choose Case lsItemCartStatus
		
	Case '1' /* All orders - Do nothing */
		
	Case '2' /* All Cart ITems Only */
		
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail, Item_Master where delivery_Master.do_no = delivery_detail.do_no "
		lsNewSql += " and Delivery_MAster.Project_id = Item_Master.Project_id and Delivery_Detail.SKU = Item_MAster.SKU and delivery_Detail.Supp_Code = Item_MAster.Supp_Code and Item_MAster.Pick_Cart_Status in ('Y','U')"
		lsNewSql += " and ord_status = 'N' and Delivery_Master.Project_id = '" + gs_Project + "')"
		
		lsNewSql += " and Delivery_MAster.do_no Not in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail, Item_Master where delivery_Master.do_no = delivery_detail.do_no "
		lsNewSql += " and Delivery_MAster.Project_id = Item_Master.Project_id and Delivery_Detail.SKU = Item_MAster.SKU and delivery_Detail.Supp_Code = Item_MAster.Supp_Code and (Item_MAster.Pick_Cart_Status in ('N','') or Pick_Cart_Status is null)"
		lsNewSql += " and ord_status = 'N' and Delivery_Master.Project_id = '" + gs_Project + "')"
		
	Case '3' /*Cart ITems but no Ugly */
		
		lsNewSql += " and Delivery_MAster.do_no in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail, Item_Master where delivery_Master.do_no = delivery_detail.do_no "
		lsNewSql += " and Delivery_MAster.Project_id = Item_Master.Project_id and Delivery_Detail.SKU = Item_MAster.SKU and delivery_Detail.Supp_Code = Item_MAster.Supp_Code and Item_MAster.Pick_Cart_Status = 'Y'"
		lsNewSql += " and ord_status = 'N' and Delivery_Master.Project_id = '" + gs_Project + "')"
		
		lsNewSql += " and Delivery_MAster.do_no Not in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail, Item_Master where delivery_Master.do_no = delivery_detail.do_no "
		lsNewSql += " and Delivery_MAster.Project_id = Item_Master.Project_id and Delivery_Detail.SKU = Item_MAster.SKU and delivery_Detail.Supp_Code = Item_MAster.Supp_Code and Item_MAster.Pick_Cart_Status = 'U'"
		lsNewSql += " and ord_status = 'N' and Delivery_Master.Project_id = '" + gs_Project + "')"
		
	Case '4' /*Exclude all cart items */
		
		lsNewSql += " and Delivery_MAster.do_no Not in (select Delivery_MAster.do_no from Delivery_Master,Delivery_Detail, Item_Master where delivery_Master.do_no = delivery_detail.do_no "
		lsNewSql += " and Delivery_MAster.Project_id = Item_Master.Project_id and Delivery_Detail.SKU = Item_MAster.SKU and delivery_Detail.Supp_Code = Item_MAster.Supp_Code and Item_MAster.Pick_Cart_Status in ('Y','U')"
		lsNewSql += " and ord_status = 'N' and Delivery_Master.Project_id = '" + gs_Project + "')"
		
End Choose

//We only want to include Delivery Orders in a new Status that Have Order Details and aren't already on a batch
//For Saltillo, we may also include orders in HOLD status (were placed in hold awaiting packaging of Raw Materials)
If lbIncludeHold Then
	lsNewSql += " and delivery_master.Ord_Status in ('N', 'H') and (delivery_master.batch_pick_id is null or delivery_master.batch_pick_id = 0) "
Else
	lsNewSql += " and delivery_master.Ord_Status = 'N' and (delivery_master.batch_pick_id is null or delivery_master.batch_pick_id = 0) "
End If

//if number of orders was entered then use the bare select with a subselect that has all the qualifiers
if llOrdersForBatch  > 0 then
	lsNewSql = isOrigSQL_Detail + " and Delivery_Master.DO_No in (select top " + String(llOrdersForBatch) + " Delivery_Master.Do_NO from Delivery_Master where 1=1 " + lsNewSql + ")"
else //otherwise prepend the bare select to the criteria
	lsNewSql = isOrigSql_detail + lsNewSql
end if

//setsqlselect won't allow us to issue update statements when more than 1 table is present
lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
idw_detail.Modify(lsModify)	

w_main.SetMicroHelp('Generating Batch Order List...')
SetPointer(Hourglass!)

idw_Detail.Retrieve()

//If we included any orders in Hold, set the status of these orders back to New
If lbIncludeHold Then
	llRowCount = idw_Detail.RowCount()
	llFindRow = idw_Detail.Find("ord_status = 'H'",1,llRowCount)	
	Do While llFindRow > 0
		idw_detail.SetITem(llFindRow,'ord_status','N')
		llFindrow ++
		If llFindRow > lLRowCount Then Exit
		llFindRow = idw_Detail.Find("ord_status = 'H'",llFindRow,llRowCount)
	Loop
End If /*include hold orders */

w_main.SetMicroHelp('Ready')
SetPointer(Arrow!)

If idw_detail.RowCount() > 0 Then
	tab_main.SelectTab(2)
	ib_changed = True
Else
	Messagebox(is_Title,'No Delivery Orders in a New status were found matching this criteria')
	ib_changed = False
	Return
End If

// 10/13 - PCONKL - If limiting to a particular order volume, delete the orders that exceeed the volume (not including ugly items)- not even going to attempt this in SQL
if ldOrderVolume > 0 Then
	
	llRowCount = idw_Detail.RowCount()
	
	For llRowPos = 1 to lLRowCount
		//if idw_detail.object.c_order_volume_less_ugly[llRowPos] > ldOrderVolume Then  
		if idw_detail.object.c_order_total_volume[llRowPos] > ldOrderVolume Then  
			idw_detail.SetItem(llRowPos,'c_delete_ind','Y')
		End If
	Next
	
	ibDisableDeleteWarning = True /*don;t prompt for deleting of orders */
	tab_main.tabpage_order_Detail.cb_remove_orders.triggerEvent('clicked')
	
End If

idw_master.SetItem(1,'batch_status','N') /*always Status of New after generating order list*/

wf_check_status()

ibbatchCriteriaChanged = False /*user will need to re-gen the batch if they change the criteria*/

idw_master.SetItem(1,'batch_status','N') /*New Status*/

end event

event ue_generate_pick();Long		llRowCount,	&
			llRowPos,	&
			llRecCount,		&
			llBatchID
		
String	lsInvoiceNo, lsPickSort
		
Datastore	ldsOrders

If idw_Pick.RowCount() > 0 Then
	
	If Messagebox(is_title,'Warning! This will clear the existing Pick List!~r~rDo you want to continue?',StopSign!,YesNo!,2) = 2 Then
		Return
	Else /*clear the existing Pick/Pack*/
		
		idw_pack.SetRedraw(False)
		llRowCount = idw_pack.RowCount()
		For llRowPos = llRowCount to 1 Step -1
			//Don't delete rows for orders that have been confirmed or deleted
			If idw_pack.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pack.GetITemString(llRowPos,'ord_Status') = 'D' or  idw_pack.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
			idw_pack.DeleteRow(llRowPos)
		Next
		
		idw_pick.SetRedraw(False)
		llRowCount = idw_pick.RowCount()
		For llRowPos = llRowCount to 1 Step -1
			//Don't delete rows for orders that have been confirmed or deleted
			If idw_pick.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pick.GetITemString(llRowPos,'ord_Status') = 'D' or  idw_pick.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
			idw_pick.DeleteRow(llRowPos)
		Next
				
		ib_changed = True
		idw_pick.SetRedraw(True)
		idw_pack.SetRedraw(True)
		
		//Save changes
		ibGeneratePick = True /*we will want to set the Order status to new if Genereating the Pick*/
		If iw_window.Trigger Event ue_save() = -1 Then Return
		ibGeneratePick = False
		
	End If
	
End If /*Pick Already Exists*/

idw_Pick.SetRedraw(False)
SetPointer(Hourglass!)

ibPickChanged = True

// 01/04  PCONKL - Added option to use default Sort Order for Project
lsPickSort = idw_Master.GetITemString(1,'Pick_Sort_Order')
If lsPickSort = 'PROJECT' Then /*use Project Level Sort Order*/
	If g.is_pick_sort_order > ' ' Then
		lsPickSort = g.is_pick_sort_order
	Else
		lsPickSort = "Complete_Date A"
	End If
End If 

i_nwarehouse.of_batch_Picking(idw_detail,idw_pick,lsPickSort)

// 08/02 - PConkl - For Saltillo/Detroit, we will drop ALL orders where ANY stock for that order requires Raw/Hold/Quar/Scrap materials
If Upper(Left(gs_project,4)) = 'GM_M' Then /* GAP 09/2002 Added stock on Raw/Hold/Quar/Scrap status to this routine */
	This.TriggerEvent('ue_drop_raw')
End If

ib_changed = True

idw_Pick.SetRedraw(True)

idw_pick.Sort()
idw_pick.GroupCalc()

If ibDropRaw Then /* Raw/Hold/Quar/Scrap was required */
	MessageBox(is_title,'One or more orders requires items to be picked from inventory types: Raw/Hold/Quar/Scrap.~r~rThese orders will be dropped from the batch when you save.')
End If

If idw_pick.RowCount() = 0 Then
	Messagebox(is_title,'Nothing Available to Pick!')
End If

//hide any unused lottable fields (lot, po, etc.)
idw_pick.TriggerEvent('ue_hide_unused')

SetPointer(Arrow!)
//
// pvh gmt 12/28/05
datetime ldtToday
ldtToday = f_getLocalWorldTime( getWarehouse() ) 
//ldtToday = datetime( today(), now() )

idw_master.SetItem(1,'batch_status','P') /*Process Status - will be changed to Picking in ue_save if successfull*/
If isNull(idw_master.GetITemDateTime(1,'pick_start')) Then
	// pvh gmt 12/28/05
	idw_master.SetITem(1,'pick_start', ldtToday )
	//idw_master.SetITem(1,'pick_start',Today())
End If

w_main.SetMicroHelp("Ready")
end event

event ue_confirm();//Confirm all outbound orders that we picked.

Long	llRowCount, llRowPos, llBatchPickID, llTransCount
Long  llPickCount, llOrderQty, lldbQty   
Datastore	ldsSerChec

		
Boolean	lbOverPick, lbUnderPick
DateTime	ldtToday
string lsOrdStat, lsDONO, lsOrder, lsPrevDONO, lsTransID //Oct'07 - for creating batch_transactions for AMS-MUSER
string lsPrevOrder, lsCurOrder, lsTransParm

If idw_Pick.AcceptText() <0 Then Return

//Check for changes
If ib_changed Then
	Messagebox(is_title,'Please save changes first')
	Return
End If

//Make sure pick list has been generated and saved (button should only be enabled if picked but just in case
If idw_Pick.RowCOunt() <= 0 Then
	messageBox(is_title,'Pick List must be generated before confirming this order.')
	Return
End If

if messagebox(is_title,'Are you sure you want to confirm this order?~r~rALL Delivery Orders for this batch will be confirmed as well.',Question!,YesNo!,2) = 2 then
	return
End if

//Check for Over/Under Pick (Back Order)
llRowCount = idw_detail.RowCount()
For llRowPos = 1 to llRowCount
	
	If idw_detail.GetItemNumber(llRowPos, "req_qty") < idw_detail.GetItemNumber(llRowPos, "alloc_qty") Then
		lbOverPick = True
	ElseIf idw_detail.GetItemNumber(llRowPos, "req_qty") > idw_detail.GetItemNumber(llRowPos, "alloc_qty") Then
		lbUnderPick = True
	End If

Next

//If any rows have allocated > requested, either warn user or stop based on Project level over pick Ind
If lbOverPick Then
	
	If (g.is_allow_overPick = 'Y' OR  g.is_allow_overPick = 'B') Then /*over picking allowed for Project*/
		If Messagebox(is_title,'One or more line items has been over Picked.~r~rWould you like to continue?',Question!,yesNo!,2) = 2 Then
			Return
		End If
	Else  /*over picking Not allowed for Project*/
		Messagebox(is_title,'One or more line items has been over Picked.~r~rPlease correct before continuing.',StopSign!)
		Return
	End If
	
End If

If lbUnderPick Then /* MA - 04-04 Added under picking */

	If (g.is_allow_overPick = 'U' OR  g.is_allow_overPick = 'B') Then /*under picking allowed for Project*/
		If Messagebox(is_title,'One or more line items has been under Picked.~r~rWould you like to continue?',Question!,yesNo!,2) = 2 Then
			Return
		End If
	Else  /*under picking Not allowed for Project*/
		Messagebox(is_title,'One or more line items has been under Picked.~r~rPlease correct before continuing.',StopSign!)
		Return
	End If
	
End If

/* SARUN : Remove Serial Checking Logic

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/* 07/19/2010 ujhall: 09 of 12 Comcast SIK Batch Picking:  Loop thru the pick list to ensure serial nummber entry 
		when outbound order requires serial numbers.*/
llPickCount = idw_pick.RowCount()
if llPickCount > 0 then // Begin process pic rows for serial number compliance

	For llRowPos = 1 to llPickCount +1
		
		If llRowPos =  llPickCount +1 Then GoTo ValidateLast  // when all done, be sure to validate the last order
		
		lsCurOrder = idw_pick.GetItemString(llRowPos, 'invoice_no') //Get next order
		
		If lsCurOrder <> lsPrevOrder Then   // Begin Test and Validation of previous orders
		
			If not (isnull(lsPrevOrder) or lsPrevOrder = '') Then // Begin Previous exists
			
				ValidateLast:  // when all done, be sure to validate the last order
				// Prev Order exist, so determine if previous requires serial numbers.  If so, assure all have been capture
				IF upper(idw_Pick.GetitemString(llRowPos - 1, 'serialized_ind')) = 'O'  OR upper(idw_Pick.GetitemString(llRowPos - 1, 'serialized_ind')) = 'B' Then
					
					//Serial numbers are required for prev order, so test and validate
					lsDONO = idw_Pick.GetitemString(llRowPos - 1, 'DO_No')
					Select Count(*) into :lldbQty 
					from delivery_serial_detail ds
					join Delivery_picking_detail dp on dp.id_no = ds.id_no
					and do_no = :lsDONO; 
					
					If lldbQty <> llOrderQty then
						messagebox(is_title,'Order number '+lsPrevOrder+ ': One or more Serial numbers have not been scanned.~r~rPlease correct before continuing.',StopSign!)
		//				return
					End if
					
				End if 
				
				llOrderQty = 0 // Reset Qty for next order
				
				If llRowPos =  llPickCount +1 Then Continue
				
			End if // End Previous exists
			
		End If  // End Test and Validation of previous orders
		llOrderQty = llOrderQty + idw_pick.GetItemNumber(llRowPos, 'quantity')  // Accumulate for current order
		
		lsPrevOrder = lsCurOrder  // Align order to know when there is a change
		
	Next
	
End If  // End Processing Pick rows for serial number compliance
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SARUN : Remove Serial Checking Logic

*/

//SARUN 05May2012 : To Avoid checking of Serial number for SKU not needed Serail : START
			  llBatchPickID = idw_master.GetITemNumber(1,'batch_pick_id')
                ldsSerChec = Create DataStore
                ldsSerChec.DataObject = 'd_serial_diff_search'
                ldsSerChec.SetTransObject(sqlca)
                llPickCount	= ldsSerChec.Retrieve(gs_project,string(llBatchPickID))
                
                IF   llPickCount > 0 Then
                	For llRowPos =1 to llPickCount
					if llRowPos = llPickCount then
		             	    lsCurOrder = lsCurOrder + ldsSerChec.getitemstring(llRowPos,'inv')
					else
						lsCurOrder = lsCurOrder + ldsSerChec.getitemstring(llRowPos,'inv') +','
					end if
                	Next
				messagebox(is_title,'Order number '+lsCurOrder+ ': One or more Serial numbers have not been scanned.~r~rPlease correct before continuing.',StopSign!)
				return
               End If



//SARUN 05May2012 : To Avoid checking of Serial number for SKU not needed Serail : END

//SARUN30June2013 : Added g.isdeliverybackorder , so that in case of under pick it will check check that project allow for backorder or not : Start 

//Prompt for BackOrder

If lbUnderPick and g.isdeliverybackorder = 'Y' Then
	If Messagebox(is_title,'One or more orders were not picked completely.~r~rWould you like to create BACK ORDERS for the remaining items?',Question!,YesNo!,1) = 2 Then
		lbUnderPick = False /*used to trigger ue_backorder after orders have been confirmed*/
	End If
End If


//set Delivery Status to Confirmed and set Complete Date

llBatchPickID = idw_master.GetITemNumber(1,'batch_pick_id')

// pvh 02.15.06 - gmt
datetime ldtGMTToday
ldtGMTToday = f_getLocalWorldTime( getWarehouse() ) 

Execute Immediate "Begin Transaction" using SQLCA; /* 07/19/2010 ujh: 07 of ??  moved from about line 82*/

// pvh 11/23/05 - gmt 
Update Delivery_Master
Set ord_status = 'C', Complete_Date = :ldtGMTToday, Last_User = :gs_userID, last_update = :ldtGMTToday
Where Project_id = :gs_project and batch_Pick_id = :llBatchPickID and ord_status in ('I', 'A')
Using SQLCA;


/* 08/02/2011 GXMOR: Add error checking for update DeliveryMaster - show error if not successful */
If sqlca.sqlcode >= 0 and sqlca.sqlnrows >= 1 Then		// Must update at least one row
	
	//Update the Batch Status to Complete and pick complete date 
	idw_master.SetItem(1,'batch_status','C')
	If isNull(idw_master.GetITemDateTime(1,'pick_complete')) Then
		// pvh 02/20/06 - gmt
		idw_master.SetItem(1,'pick_complete', ldtGMTToday )
		//idw_master.SetITem(1,'pick_complete',Today())
		
	End If
	
	idw_master.Update()
	
	If sqlca.sqlcode >=0 Then	
	
		Execute Immediate "COMMIT" using SQLCA;
		
		If SQLCA.SQLCode = 0 Then
				
		Else /*commit failed*/
			
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox(is_title, 'Unable to Confirm batch!~r~r' + SQLCA.SQLErrText)
			SetMicroHelp("Confirm failed!")
			return
			
		End If
		
	Else /*save Failed*/
		
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox(is_title, 'Unable to Confirm Batch!~r~r' + SQLCA.SQLErrText)
		SetMicroHelp("Confirm failed!")
		return 
		
	End If
	
	
	// dts 10/07 - Scroll thru the Orders on the Batch and create Transactions as appropriate
		
	llRowCount = idw_Detail.RowCount()

	idw_Detail.SetSort("do_no")
	idw_detail.sort()
	
	lsPrevDONO = ""
	
	For llRowPos = 1 to llRowCount
					
		CHoose Case upper(gs_project)
							
			case   'AMS-MUSER'
							
				//		if gs_project =  'AMS-MUSER' then
				/* waiting to Implement this on Server except for AMS-muser */
				/* Need to create 'GI' and 'GS' transactions as appropriate (see w_do.ue_confirm for criteria)
				 - 3COM 
					- Eersel (WH = 3COM-NL): Create 'GI' record at 'Ready To Ship' and 'GS' record at 'Complete' 
					- Nashville & Singapore: Create GI at 'Complete'
				 - AMS-MUSER: create 'GS' records at Complete
					 - Should expand this to be configurable at Project (WH?) and for all those sending transactions!
							
				Cycle through Orders
				Check order status
				Don't create transaction if already created (or order has been voided)
				For those with 'ReadyToShip', create transaction(s) as appropriate based on status
					- If status is 'R' don't create transaction that is created at Ready
					- If status is 'A', 'I', create transactions as appropriate for the project
				*/							
				
				//	idw_Detail.SetSort("do_no")
				//	idw_detail.sort()
				lsDONO = idw_detail.GetItemString(llRowPos, "do_no")
				
				if lsDONO <> lsPrevDONO then
						
					lsPrevDONO = lsDONO
						
					//check to see if transaction already created...
					select count(trans_id) into :llTransCount
					from batch_transaction
					where trans_order_id = :lsDONO
					and Project_id = :gs_Project   // 07/19/10 ujhall: 22 of ??   added to speed up query
					and trans_type = 'GS';
									
					if llTransCount = 0 then
							
						lsOrder = idw_detail.GetItemString(llRowPos, "invoice_no")
							
						Select ord_status Into :lsOrdStat
						From Delivery_Master
						Where Project_ID = :gs_Project and Do_no = :lsDONo;
							
						//	If lsOrdStat = 'C' or lsOrdStat = 'D' Then  /*already Confirmed, can't Confirm*/
						If  lsOrdStat = 'D' Then  /*already Confirmed, can't Confirm*/
								Messagebox(is_Title, 'Order ' + lsOrder + ' was already confirmed and will not create a Batch Transaction!', StopSign!)
								//Return
						ElseIf lsOrdStat = 'R' Then /*already  in Ready to Ship Status*/
								Messagebox(is_Title, 'Order ' + lsOrder + ' was already placed in Ready Status and will not create a Batch Transaction!', StopSign!)
							//Return
						ElseIf lsOrdStat = 'V' Then /*already  Voided*/
								Messagebox(is_Title, 'Order ' + lsOrder + ' was already Voided and will not create a Batch Transaction!', StopSign!)
							//Return
						else
								Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
								Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
								Values(:gs_Project, 'GS', :lsDONO,'N', :ldtGMTToday, '');
								Execute Immediate "COMMIT" using SQLCA;
						End If
							
					end if /*Trans not prevously created*/
						
					end if /*Order Changed*/
										
			//case 'COMCAST'
			Case Else /* 08/11 - PCONKL - everyone else should be baseline at this point*/
								
				lsDONO = idw_detail.GetItemString(llRowPos, "do_no")
								
				if lsDONO <> lsPrevDONO then
									
					lsPrevDONO = lsDONO
					
					//10-APR-2019 :Madhu S28196 Bosch Post GoodsIssueRequest to Websphere - START
					if upper(gs_project) ='BOSCH' THEN
						lsTransParm = "<Id_No>" + lsDONO  + "</Id_No><Id_Type>order</Id_Type>"
					else
						lsTransParm =''
					end if
					//10-APR-2019 :Madhu S28196 Bosch Post GoodsIssueRequest to Websphere - END


//					MessageBox ("Creating GI", 	idw_detail.GetItemString(llRowPos, "invoice_no"))					
											
					Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
					
					Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
					Values(:gs_Project, 'GI', :lsDONO,'N', :ldtGMTToday, :lsTransParm);
					
					Execute Immediate "COMMIT" using SQLCA;

				//18-Feb-2014: Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
					Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
			
					Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
					Values(:gs_Project, 'GS', :lsDONO,'N', :ldtGMTToday, :lsTransParm);
					
					Execute Immediate "COMMIT" using SQLCA;

				//18-Feb-2014: Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END
				End If /* order changed*/
								
								
			//case else
								
			End Choose				
					
										
		Next /*Order*/

	
		SetMicroHelp("Batch Confirmed!")
		Messagebox(is_title,'Batch Confirmed!')
	
		wf_check_Status()

		//Create BAck Orders if Requested

		//SARUN18July2013 : Added g.isdeliverybackorder , so that in case of under pick it will check check that project allow for backorder or not : Start 
		
		//BackOrder Creation
		
		If lbUnderPick and g.isdeliverybackorder = 'Y' Then
					This.TriggerEvent('ue_backorder')
		End If


Else /*No delivery Orders updated successfully*/
	
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, 'Unable to Confirm batch!~r~r' + SQLCA.SQLErrText + ' Could not update delivery orders.'  )
	SetMicroHelp("Confirm failed!")
	return
			
End If		/* End DeliveryMaster Update */
end event

event ue_generate_pack();//generate the PackList for the Batch
// 11/02 - PCONKL - chg QTY to Decimal

Long ll_cnt, ll_row, i,llFindRow, llCartonNo, llLoopCount, llLoopPos,llLineITemNo, llLineItemNoHold, llRowPos, llRowCount, llOuterpackID
Long llPickPos, llPickCount
Decimal ld_weight , ld_length, ld_width, ld_height,ld_qty, ldSetQty,ldGrossWEight
STRING lsSKU, lsSkuParent, lsSupplier, lsSkuParentHold, lsSkuHold,lsFind, lsSerialNo,ls_std_measure, lsInvoice, lsInvoiceHold, lsCartonHold, lsCarton
String  ls_wh_code,ls_std_measure_w,lsSupplierhold, lsSortHold, lsLoc, lsLocHold, lsZone, lscusttype, lscustcode, lsSkuPrev
String	lsLotNo, lsLotNoPrev, lsPONO, lsPONOPrev, lsPONO2, lsPONO2Prev
Boolean	lbLottablesChanged
String lsGSIN, lsOrderSupp, lsGsinType, lsSSCC

If ib_changed Then
	messagebox(is_title,'Please save changes before generating Packing list!')
	return
End If

If idw_pack.RowCount() > 0 Then
	If MessageBox(is_title, "Delete current packing list?", Question!, YesNo!,2) = 1 Then
		ll_cnt = idw_pack.RowCount()
		idw_pack.Setredraw(false) /*pconkl 5/3/00*/
		For i = ll_cnt To 1 Step - 1
			idw_pack.DeleteRow(i)
		Next
		idw_pack.Setredraw(True) /*pconkl 5/3/00*/
		
		// 5/4/00 PCONKL - deleted rows must be saved back to DB (deleted from) to avoid PK integrity violation
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		If idw_pack.Update(False, False) = 1 Then
			Execute Immediate "COMMIT" using SQLCA;
   		If SQLCA.SQLCode = 0 Then
   			idw_pack.ResetUpdate()
			Else /*commit failed*/
				Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				SetMicroHelp("Save failed!")
				return
			End If
		Else /*update failed*/
			Execute Immediate "ROLLBACK" using SQLCA;
     			MessageBox(is_title, "Unable to delete Packing List Rows! " + SQLCA.SQLErrText)
				SetMicroHelp("Save failed!")
				return
		End If /*end process of delete*/
	Else
		Return
	End If
End If

SetPointer(Hourglass!)
idw_pack.Setredraw(false) /*pconkl 10/00*/

idw_pack.SetColumn ("carton_no")

//GailM 9/3/2019 S36484 F17554 Philips Batch GSIN
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
lsGsinType = idw_master.GetItemString(1, 'gsin_type')
If (Upper(gs_project) = 'PHILIPSCLS' OR Upper(gs_project) = 'PHILIPS-DA') and lsGsinType = "2" Then
	lsGsin = idw_detail.GetItemString(1, 'user_field4')
	lsOrderSupp = idw_detail.GetItemString(1, 'supp_code')	//Assume 1st order detail supp code is all orders supplier for combined GSIN
	If Not IsNull(lsGsin) and lsGsin <> '' Then
		If messagebox("ls_title","GSIN has already been assigned as " + lsGsin + ".  Do you want to change?", Question!, YesNo!) = 1 Then
			lsGSIN =  f_get_gsin_number( gs_project, lsOrderSupp)
		End If
	Else
		lsGSIN =  f_get_gsin_number( gs_project, lsOrderSupp)
	End If
End If

// 2/01 PCONKL - Create PAck list from Pick List, Not order detail

llPickCount = idw_Pick.RowCount()

//Sort the Pick List by Order before sku so that carton numbers are in order by Order Number
lsSortHold = idw_Pick.Describe("DataWindow.Table.Sort") /*we will want to resort the Pick list at the end*/
idw_Pick.SetSort('Invoice_no A, SKU A')
idw_Pick.Sort()

llCartonNo = 0
llOuterPackID = 0
lsInvoiceHold = ''
lsSkuHold = '' /*for adding new pack row (adding on Sku change)*/
lsSkuParentHold = '' /*for adding new Carton - Component children will go in the same carton as their parent eventhough the sku is different*/

For llPickPos = 1 to llPickCount /*each Pick Row*/
	
	// 2012/04/05 - TAM - If we have built Components from free children, don't show on Pack List
	If idw_Pick.GetITemString(llPickPos,'component_ind') = '*' or idw_Pick.GetITemString(llPickPos,'component_ind') = 'B' or idw_Pick.GetITemString(llPickPos,'component_ind') = 'W' Then Continue

	w_main.SetMicroHelp('generating Pack List row ' + string(i) + ' of ' + string(ll_cnt))
	
	llFindRow = 0
	lbLottablesChanged = False
	
	//Check for new pack row or carton
	lsSku = idw_pick.GetITemString(llPickPos,'Sku')
	lsInvoice = idw_pick.GetITemString(llPickPos,'Invoice_no')
	lsSkuParent = idw_pick.GetITemString(llPickPos,'sku_parent')
	lsSupplier = idw_pick.GetItemString(llPickPos,"supp_code")
	lsLoc = idw_pick.GetItemString(llPickPos,"l_code")
	lsZone = idw_pick.GetItemString(llPickPos,"zone_id")
	lsSerialno = idw_pick.GetItemString(llPickPos,"serial_no")
	llLineItemNo = idw_pick.GetITemNumber(llPickPos,'line_item_no')
	lsLotNo = idw_pick.GetItemString(llPickPos,"lot_no")
	lsPoNo = idw_pick.GetItemString(llPickPos,"po_no")
	lsPoNo2 = idw_pick.GetItemString(llPickPos,"po_no2")
	
	// 04/16 - PCONKL - New row if lottables changing (like in W_DO)
	if g.isCopy_Lot_No_to_Packlist = 'Y' then
		if lsLotNo <> lsLotNoPrev or lsPoNo <> lsPoNoPrev  or lsPoNo2 <> lsPoNo2Prev  then
			lbLottablesChanged = true
		end if
	end if
			
	//If Order Numebr changing, reset Carton Number
	If lsInvoice <> lsInvoiceHold THen
		llCartonNo = 0
		llOuterPackID ++ /* 04/16 - PCONKL - Default a new pallet per order*/
		lsSkuHold = ''
		lsSkuParent = ''
		If lsGsinType = "1" Then	//New GSIN only on change of order
			lsGsin = idw_detail.GetItemString(1, 'user_field4')
			lsOrderSupp = idw_detail.GetItemString(1, 'supp_code')	//Assume 1st order detail supp code is all orders supplier for combined GSIN
			If Not IsNull(lsGsin) and lsGsin <> '' Then
				If messagebox("ls_title","GSIN has already been assigned as " + lsGsin + " for order " + lsInvoice + ".  Do you want to change?", Question!, YesNo!) = 1 Then
					lsGSIN =  f_get_gsin_number( gs_project, lsOrderSupp)
				End If
			else
				lsGSIN =  f_get_gsin_number( gs_project, lsOrderSupp)
			End If
		End If
	End If

	If lsSku <> lsSkuHold or lsInvoice <> lsInvoiceHold or llLineItemNo <> llLineItemNoHold or lsSupplier <> lsSupplierhold or lsLoc <> lsLocHold or lbLottablesChanged Then /*different sku or line Item, new pack Row - 04/16 - PCONKL - new carton if lottable changing and we're copying from picking*/

		ll_row = idw_pack.InsertRow(0)
		
		llCartonNo ++
		
		lsInvoiceHold = lsInvoice
		lsSkuHold = lsSku
		lsSupplierhold = lsSupplier 
		lsLocHold = lsLoc
		llLineItemNoHold = llLineITemNo
		lsLotNoPrev = lsLotNo
		lsPONOPrev = lsPONO
		lsPONO2prev = lsPONO2
	
	End If
	

	// 07/19/2010 ujh: 06 of ??; 
	if lsSKU <> lsSkuPrev Then
		lsSkuPrev = lsSku
		//Select SKU from Item_Master and Check row count
		SELECT Length_1, Width_1, Height_1, Weight_1,standard_of_measure
		INTO :ld_length, :ld_width, :ld_height, :ld_weight,:ls_std_measure
		FROM Item_Master 
		WHERE Project_id = :gs_project and
				SKU = :lsSKU and
				supp_code = :lsSupplier;
	end if
		
	//If it's a component, default each to a new carton, otherwise, put all in same Carton
	// 08/08/2010 ujhall: 07 of 07: All pick rows per order to a single Carton: If a component and NOT Comcast, separate cartons
	If (idw_pick.GetItemString(llPickPos,'component_ind') = 'Y' or idw_pick.GetItemString(llPickPos,'component_ind') = '*') and upper(gs_project) <> 'COMCAST'  Then /*component Parent*/
//	If idw_pick.GetItemString(llPickPos,'component_ind') = 'Y' or idw_pick.GetItemString(llPickPos,'component_ind') = '*' Then /*component Parent*/
		llLoopCount = idw_pick.GetItemnumber(llPickPos,'quantity') /*loop once for each qty*/
		ldSetQty = 1 /*set each qty to 1*/
	Else /*not a component*/
		
		// 08/02 - PConkl - For Saltillo/Detroit, we create a seperate Pack Row for each unit of qty (qty of 5 = 5 cartons)
		If Upper(gs_project) = 'GM_MONTRY' Then
			llLoopCount = idw_pick.GetItemnumber(llPickPos,'quantity') /*loop once for each qty*/
			ldSetQty = 1 /*set each qty to 1*/
		Else /*Not Saltillo*/
			llLoopCount = 1 /*loop once*/
			ldSetQty = idw_pick.GetItemnumber(llPickPos,'quantity') /*set qty to total Qty*/
		End If
		
	End If /*Component ? */
	
	For llLoopPos = 1 to llLoopCount

		idw_pack.SetItem(ll_row,"quantity",idw_pack.GetITemNumber(ll_row,'Quantity') + ldSetQty ) /*add current pick row to whats in current pack row (we may be combining multiple pick rows into a single Pack) */
		
		IF SQLCA.sqlcode = 0 THEN
			idw_pack.SetItem ( ll_row, 'length', ld_length)
			idw_pack.SetItem ( ll_row, 'width', ld_width )
			idw_pack.SetItem ( ll_row, 'height', ld_height)
			idw_pack.SetItem ( ll_row, 'weight_net',ld_weight )
			idw_pack.SetItem (ll_row,'cbm',(Round(ld_length,0)*Round(ld_width,0)*Round(ld_height,0))) /* 06/00 PCONKL - set cbm*/
		END IF
		
		//If it's a component child, we will want to put it in the same carton as the parent
		If idw_pick.GetItemString(llPickPos,'component_ind') = '*' Then /*component Child*/
			lsFind = "Sku = '" + idw_pick.GetITemString(llPickPos,'sku_parent') + "' and supp_code = '" + idw_pick.GetITemString(llPickPos,'supp_code') + "'"
			llFindRow = idw_pack.Find(lsFind,llFindRow,idw_pack.RowCount()) /* start with first parent*/
			If llFindRow > 0 Then
				idw_pack.SetItem(ll_row,"carton_no", idw_pack.GetItemString(llFindRow,'carton_no')) /*Set to same carton as Parent*/
			Else
				idw_pack.SetItem(ll_row,"carton_no",'0')
			End If
			
			llFindRow ++
			
		Else
			
			If llCartonNo = 0 Then llCartonNo = 1
			idw_pack.SetItem(ll_row,"carton_no", String(llCartonNo))
			
			If g.is_unique_pack_cartonNumbers = 'Y' Then
//				//idw_pack.SetItem(ll_row,"carton_no", String(llCartonNo,'000000000'))
//				lsCarton = Right(Mid(idw_pick.GetItemString(llPickPos,"do_no"),(len(gs_project) + 1),7),6) /* right 6 of everything after project*/
				idw_pack.SetItem(ll_row,"carton_no", String(long(Right(Mid(idw_pick.GetItemString(llPickPos,"do_no"),(len(gs_project) + 1),7),6)),'000000') + String(llCartonNo,'000')) /* last 6 of do_no + 3 sequential*/
			Else
				idw_pack.SetItem(ll_row,"carton_no", String(llCartonNo))
			End If
						
		End If
		
		idw_pack.SetItem(ll_row,"component_ind",idw_pick.GetItemString(llPickPos,'component_ind'))
		idw_pack.SetItem(ll_row,"do_no", idw_pick.GetItemString(llPickPos,"do_no"))
		idw_pack.SetItem(ll_row,"ord_status", idw_pick.GetItemString(llPickPos,"ord_status"))
		idw_pack.SetItem(ll_row,"invoice_no", idw_pick.GetItemString(llPickPos,"Invoice_no"))
		idw_pack.SetItem(ll_row,"sku", lsSku)
		idw_pack.SetItem(ll_row,"supp_code", lsSupplier)
		idw_pack.SetItem(ll_row,"l_code", lsLoc)
		idw_pack.SetItem(ll_row,"zone_id", lsZone)
		idw_pack.SetITem(ll_row,'line_item_No',llLIneItemNo) /* 09/01 Pconkl */
		
		IF g.isCopy_Lot_No_to_Packlist = 'Y' then
				
			idw_pack.SetItem(ll_row,"pack_lot_no", lsLotNo)
			idw_pack.SetItem(ll_row,"pack_po_no", lsPoNo)			
			idw_pack.SetItem(ll_row,"pack_po_no2", lsPoNo2)					
							
		End IF
			
		//GailM 8/5/2019 S36484 F17554 Philips Batch GSIN plus DE12618 Issue #1: Do not change if order is complete, ready or void
		//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
		If (Upper(gs_project) = 'PHILIPSCLS'  OR Upper(gs_project) = 'PHILIPS-DA' ) and idw_pick.GetItemString(llPickPos,"ord_status") <> 'C' and idw_pick.GetItemString(llPickPos,"ord_status") <> 'R' and idw_pick.GetItemString(llPickPos,"ord_status") <> 'V' Then
			idw_pack.SetItem(ll_row, "user_field4", lsGSIN)
			lsFind = "do_no = '" + idw_pack.GetItemString(ll_row,"do_no") + "' "
			llFindRow = idw_detail.Find(lsFind, 1, idw_detail.RowCount())
			if llFindRow > 0 Then
				idw_detail.SetItem(llFindRow,"user_field4", lsGSIN)
				idw_detail.SetItem(llFindRow,"transport_mode","LT")
				idw_detail.SetItem(llFindRow, "pick_complete",f_get_date("END"))
			End If
			lsSSCC = f_get_sscc_number( gs_project, lsSupplier)
			idw_pack.SetItem(ll_row, "pack_sscc_no", lsSSCC)
			idw_pack.SetItem(ll_row, "carton_type", "CS")
		End If
			
		//1-Dec-2014 :Madhu- Copy DD.UF2 onto Packlist.UF2 for ANKI -START
		If gs_project ='ANKI' THEN
			long ll_Findrow
			lsFind = "Sku = '" + lsSku + "' and line_item_no = " + String(llLineItemNo) + " and supp_code = '" +lsSupplier +"'"
			ll_Findrow = idw_detail.find( lsFind, 0, idw_detail.rowcount())  // Get corresponding record/row from Delivery Detail based on above attributes
			
			idw_pack.setItem(ll_row,'user_field2',idw_Detail.getItemString(ll_Findrow,'delivery_detail_user_field2'))  // Get DD.UF2 and copy onto generated pack list record.
		END IF
		//1-Dec-2014 :Madhu- Copy DD.UF2 onto Packlist.UF2 for ANKI -END  
				
		//Dgm ETOM default is assign from Wharehouse if Item Master default is different.
		ls_wh_code = idw_master.object.wh_code[1]
		ls_std_measure_w = g.ids_project_warehouse.object.standard_of_measure[g.of_project_warehouse(gs_project,ls_wh_code)]
		IF ls_std_measure = ls_std_measure_w THEN
			idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure)			
		ELSE
			idw_pack.Setitem(ll_row,"standard_of_measure",ls_std_measure_w)
			//wf_convert(ls_std_measure_w,1)//convert the Dimentions 
		END IF	
//		wf_assignetom(2) //Assigning value of Standard_of Mesure to Radio Button	
		
		//Append serial numbers (inbound captured) if combining multiple pick records into 1 pack rec
		If not isnull(idw_pack.GetITemString(ll_row,'free_form_serial_no')) then
			If (Not isnull(lsSerialNo))  and lsSerialno <> '-' Then
				idw_pack.SetItem(ll_row,'free_form_serial_no',idw_pack.GetITemString(ll_row,'free_form_serial_no') + ', ' + lsSerialNo)
			End If
		Else
			If (Not isnull(lsSerialNo)) and lsSerialno <> '-' Then
				idw_pack.SetItem(ll_row,'free_form_serial_no',lsSerialNo)
			End If
		End If
		
		If Left(idw_pack.GetITemString(ll_row,'free_form_serial_no'),1) = ',' Then /*strip off first comma if exists*/
			idw_pack.SetItem(ll_row,'free_form_serial_no',right(idw_pack.GetITemString(ll_row,'free_form_serial_no'),(len(idw_pack.GetITemString(ll_row,'free_form_serial_no')) - 1)))
		End If
		
		idw_pack.setitem(ll_row,'country_of_origin',idw_pick.getitemstring(llPickPos,'country_of_origin'))
		
		IF NOT IsNull(idw_pack.GetITemNumber(ll_row,'Quantity')) THEN /*set gross wt*/
				idw_pack.SetItem ( ll_row, 'weight_gross', (idw_pack.GetITemNumber(ll_row,'weight_net') * idw_pack.GetITemNumber(ll_row,'Quantity')))
		END IF
		
		idw_pack.SetItem(ll_row,'outerpack_id',llOuterPackID) /* 04/16 - PCONKL*/
		
		If llLoopPos < llLoopCount Then
			ll_row = idw_pack.InsertRow(0)
			llCartonNo ++
		End If	
		
	Next /*loop count*/
	
Next /* Next Pick Row*/

uf_enable_first_carton_row(0,"",'')

//Combine Gross WEights from multiple packing rows with same order/carton number into the first row. The first row should have the gross weight for the entire carton, not just the portion of that SKU in the carton
llRowCount = idw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsInvoice = idw_Pack.GetITemString(llRowPos,'invoice_no')
	lsCarton = idw_Pack.GetITemString(llRowPos,'carton_no')
	
	If lsInvoice <> lsInvoiceHold or lsCarton <> lsCartonHold Then
		
		ldGrossWEight = idw_Pack.GetITemNumber(llRowPos,'weight_gross')
		
		//Find any other rows for this Order/Carton
		If llRowPos < llRowCount Then
				
			llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(lsInvoice) + "' and Upper(carton_no) = '" + Upper(lsCarton) + "'",llRowPos + 1, llRowCount)
			Do While llFindRow > 0
				
				If idw_pack.GetITemNumber(llFindRow,'weight_net') > 0 and idw_pack.GetITemNumber(llFindRow,'quantity') > 0 Then
					ldGrossWeight += (idw_pack.GetITemNumber(llFindRow,'weight_net') * idw_pack.GetITemNumber(llFindRow,'quantity') )
				End If
				
				llFindRow ++
				If llFindRow > llRowCount Then
					llFindRow = 0
				Else
					llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(lsInvoice) + "' and Upper(carton_no) = '" +  Upper(lsCarton) + "'",llFindRow, llRowCount)
				End If
				
			Loop
			
		End If
		
		idw_Pack.SetITem(lLRowPos,'weight_gross',ldGrossWEight)
		
		//Set all the other rows of this order/carton to the Gross weight just calculated
		If llRowPos < llRowCount Then
				
			llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(lsInvoice) + "' and Upper(carton_no) = '" + Upper(lsCarton) + "'",llRowPos + 1, llRowCount)
			Do While llFindRow > 0
				
				idw_pack.SetITem(llFindRow,'weight_gross',ldGrossWeight)
				
				llFindRow ++
				If llFindRow > llRowCount Then
					llFindRow = 0
				Else
					llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(lsInvoice) + "' and Upper(carton_no) = '" +  Upper(lsCarton) + "'",llFindRow, llRowCount)
				End If
				
			Loop
			
		End If
		
		
	End If
	
	lsCartonHold = lsCarton
	lsInvoiceHold = lsInvoice
	
Next /*PAcking Row*/


idw_pack.Setredraw(True) /*pconkl 10/00*/

idw_pack.Sort()
idw_pack.GroupCalc()

//Resort the Pick LIst
idw_pick.SetSort(lsSortHold)
idw_pick.Sort()
idw_pick.GroupCalc()

// 02/01 PCONKL - reset filter on Pick LIst based on showing components
//wf_set_pick_filter('Set')

SetPointer(Arrow!)
idw_pack.SetFocus()

ib_changed = True
end event

event ue_backorder();//Create a back Order for any Items not Picked in full

// 11/02 - PCONKL - chg qty fields to decimal

Long	llDetailPos,	&
		llDetailCount,	&
		llBatchSeq,	&
		llDoNo,	&
		llOwner,		&
		llLineItemNo,llBatchPickID

Decimal	ldReqQty

String	lsInvoice,	lsDoNo,	&
			lsInvoiceHold,	&
			lsInvType,		&
			lsWarehouse,	&
			lsCustomer,		&
			lsCustName,		&
			lsAddr1, lsAddr2, lsAddr3, lsAddr4,	&
			lsCity, lsState, lsZip, lsDistrict, lsCountry,	&
			lsCustOrder,	&
			lsErrText,	&
			lsSku, lsAltSku, lsSupplier,	&
			lsContact, lsTel, lsfax,ls_prev_dono
			
DateTime	ldtOrdDate, ldtToday

// pvh 02.15.06 - gmt
ldtToday = f_getLocalWorldTime( getWarehouse()  ) 
//ldtToday = DateTime(Today(), Now())

w_main.SetMicroHelp('Creating Back Orders...')
SetPointer(HourGlass!)

//Make sure it is sorted correctly by Invoice & LIne ITem #
idw_Detail.SetSort("Invoice_no A, line_item_no A")
idw_Detail.Sort()

//For each Row where Alloc Qty < Req Qty, create a back Order
llDetailCount = Idw_Detail.RowCount()
For llDetailPos = 1 to llDeTailCount
	
	If idw_detail.GetITemNumber(llDEtailPos,'alloc_qty') < idw_detail.GetITemNumber(llDEtailPos,'req_qty') Then /*Not allocated in Full*/
		
		lsInvoice = idw_detail.GetITemString(llDEtailPos,'invoice_no')
		
		//Only want to create a header the first time for a new invoice
		If lsInvoice <> lsInvoiceHold Then 
			
			//Fields for New Header
			ls_prev_dono = idw_Detail.GetItemString(llDetailPos,"do_no")
			lsInvType = idw_Detail.GetItemString(llDetailPos,"inventory_type")
			lsWarehouse = idw_Detail.GetItemString(llDetailPos,"wh_code")
			lsCustomer = idw_Detail.GetItemString(llDetailPos,"cust_code")
			lsCustName = idw_Detail.GetItemString(llDetailPos,"Cust_Name")
			lsContact = idw_Detail.GetItemString(llDetailPos,"contact_person")
			lstel = idw_Detail.GetItemString(llDetailPos,"tel")
			lsFax = idw_Detail.GetItemString(llDetailPos,"fax")
			lsaddr1 = idw_Detail.GetItemString(llDetailPos,"Address_1")
			lsaddr2 = idw_Detail.GetItemString(llDetailPos,"Address_2")
			lsaddr3 = idw_Detail.GetItemString(llDetailPos,"Address_3")
			lsaddr4 = idw_Detail.GetItemString(llDetailPos,"Address_4")
			lsCity = idw_Detail.GetItemString(llDetailPos,"City")
			lsState = idw_Detail.GetItemString(llDetailPos,"State")
			lsZip = idw_Detail.GetItemString(llDetailPos,"Zip")
			lsCountry = idw_Detail.GetItemString(llDetailPos,"Country")
			lsCustOrder = idw_Detail.GetItemString(llDetailPos,"Cust_order_no")
			llBatchSeq = idw_Detail.GetItemNumber(llDetailPos,"edi_batch_seq_no")
			ldtOrdDate = idw_Detail.GetItemDateTime(llDetailPos,"Ord_Date")
			
			//Get Next Available DoNo
			lldono = g.of_next_db_seq(gs_project,'Delivery_Master','DO_No')
			If lldono <= 0 Then
				messagebox(is_title,"Unable to retrieve the next available order Number!")
				Return
			End If
			lsDoNo = Trim(Left(gs_project,9)) + String(lldono,"0000000")
			
			//Create the New Header
			Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
			
//Sarun2013Sep27 Start : Babycare is not able to see their language character in new back order, also missing some feilds (SIM-2779)			

//			Insert Into Delivery_MAster
//							(do_no, Project_id, Ord_Type, Ord_date, Ord_Status, wh_code, Inventory_type, Cust_Order_no,
//							  Cust_code, Cust_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
//							  Invoice_no, Freight_Cost, LAst_USer, LAst_Update, edi_batch_seq_no, contact_person, tel, fax)
//			Values		(:lsDoNo, :gs_Project, "B", :ldtOrdDate, "N", :lsWarehouse, :lsInvType, :lsCustOrder,
//							:lsCustomer, :lsCustName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry,
//							:lsInvoice, 0, :gs_Userid, :ldtToday, :llBatchSeq, :lsContact, :lsTel, :lsFax)

			Insert Into Delivery_MAster
							(do_no, Project_id, Ord_Type, Ord_date, Ord_Status, wh_code, Inventory_type, Cust_Order_no,
							  Cust_code, Cust_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
							  Invoice_no, Freight_Cost, LAst_USer, LAst_Update, edi_batch_seq_no, contact_person,tel, fax,
							  User_Field1,User_Field2,User_Field3,User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,
							  User_Field9,User_Field10,User_Field11,User_Field12,User_Field13,User_Field14,User_Field15,
							  User_Field16,User_Field17,User_Field18,User_Field19,User_Field20,batch_pick_id)
							 Select :lsDoNo, Project_id, "B", ord_date, "N", wh_code, Inventory_type, Cust_Order_no,
							  Cust_code, Cust_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
							  Invoice_no, Freight_Cost, :gs_Userid,:ldtToday, edi_batch_seq_no, contact_person, tel, fax,
							  User_Field1,User_Field2,User_Field3,User_Field4,User_Field5,User_Field6,User_Field7,User_Field8,
							  User_Field9,User_Field10,User_Field11,User_Field12,User_Field13,User_Field14,User_Field15,
							  User_Field16,User_Field17,User_Field18,User_Field19,User_Field20,0
							  from delivery_master where project_id = :gs_Project and do_no = :ls_prev_dono							
			Using SQLCA;
			
//Sarun2013Sep27 : End			
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "ROLLBACK" using SQLCA;
				Messagebox("BackOrder","Unable to Create new Delivery Order Header for Invoice #:" + LsInvoice + "~r~r" + lsErrText)
				Return 
			End If	
									
			lsInvoiceHold = lsInvoice
			
		End if /*New Header Needed (New Invoice) */
		
		//Create a New Detail Row for this Invoice - Header has already been created
		
		ldReqQty = idw_detail.GetITemNumber(llDEtailPos,'req_qty') - idw_detail.GetITemNumber(llDEtailPos,'alloc_qty')
		lsSKU = idw_Detail.GetItemString(llDetailPos,"SKU")
		lsAltSKU = idw_Detail.GetItemString(llDetailPos,"Alternate_SKU")
		lsSupplier = idw_Detail.GetItemString(llDetailPos,"supp_code")
		llOwner = idw_detail.GetITemNumber(llDEtailPos,'owner_id')
		llLineItemNo = idw_detail.GetITemNumber(llDEtailPos,'Line_Item_no')
		
		Insert Into Delivery_Detail
						(do_no, SKU, supp_code, owner_id, alternate_sku, req_qty, alloc_qty, uom, line_item_no)
		Values		(:lsDoNo, :lsSKU, :lsSupplier, :llOwner, :lsAltSku, :ldReqQty, 0, 'EA', :llLineItemNo)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("BackOrder","Unable to Create new Delivery Order Detail for Invoice #/SKU:" + LsInvoice + '/' + lsSku + "~r~r" + lsErrText)
			Return 
		End If	
		
		//Commit Changes
		Execute Immediate "COMMIT" using SQLCA;
		
	End If /*Alloc qty < Req Qty - Backorder needed */
			
Next /*Detail Row*/
// SARUN2014MAY06 : Start : Unassoicated the pick Id from NEW orders i.e. fully unpicked

llBatchPickID = idw_master.GetITemNumber(1,'batch_pick_id')

Execute Immediate "Begin Transaction" using SQLCA;

Update delivery_master set batch_pick_id = 0
where Project_Id = :gs_project and Batch_Pick_Id = :llBatchPickID and Ord_Status = 'N';

//Commit Changes
Execute Immediate "COMMIT" using SQLCA;
// SARUN2014MAY06 :END : Unassoicated the pick Id from NEW orders i.e. fully unpicked
w_main.SetMicroHelp('Ready')
SetPointer(Arrow!)
MessageBox(is_title, 'Back Orders Created!')

end event

event ue_drop_raw;// For Saltillo - This event will drop any order from the batch where any item requires materials types: ('M') or ('H') or ('Q') or ('S')

Long	llPickRowCount, llPickRowPos, llDetailRowCount, llDetailRowPos, llFindRow
String	lsOrderNo, lsFind

llDetailRowCount = idw_Detail.RowCount()

//loop through Pick rows and update any header where Raw/Hold/Quar/Scrap is Found
llPickRowCount = idw_pick.RowCOunt()
For llPickRowPos = 1 to llPickRowCount
	/* Raw/Hold/Quar/Scrap materials for GM Mexico */
	If idw_pick.GetITemString(llPickRowPos,'Inventory_type') = 'M' or idw_pick.GetITemString(llPickRowPos,'Inventory_type') = 'H' or idw_pick.GetITemString(llPickRowPos,'Inventory_type') = 'Q' or idw_pick.GetITemString(llPickRowPos,'Inventory_type') = 'S' Then 
	
		//Update the Order Status to Hold for this order Number
		lsOrderNo = idw_pick.GetITemString(llPickRowPos,'Invoice_No')
		lsFind = "Invoice_No = '" + lsOrderNo + "'"
		llFindRow = idw_Detail.Find(lsFind,1,llDetailRowCount)
		Do While llFindRow > 0
			idw_Detail.SetITem(llFindRow,'ord_status','H') /*Hold */
			idw_Detail.SetITem(llFindRow,'batch_Pick_ID',0) /*remove from Batch*/
			
			llFindRow ++
			If llFindRow > llDetailRowCount Then Exit
			llFindRow = idw_Detail.Find(lsFind,llFindRow,llDetailRowCount)
		Loop
		
		ibDropRaw = True
	
	End If /* Raw/Hold/Quar/Scrap Material Inv Type */
	
NExt /*Pick Row */



end event

event ue_generate_pick_server();Long		llRowCount,	&
			llRowPos,	&
			llRecCount,		&
			llBatchID
		
String	lsInvoiceNo, lsPickSort, lsXML, lsXMLResponse, lsDONOHold, lsReturnCode, lsReturnDesc
		
Datastore	ldsOrders

str_parms	lstrparms

llBatchID = idw_MAster.GetITemNumber(1,'batch_pick_id')

If idw_Pick.RowCount() > 0 Then
	
	If Messagebox(is_title,'Warning! This will clear the existing Pick List!~r~rDo you want to continue?',StopSign!,YesNo!,2) = 2 Then
		Return
	Else /*clear the existing Pick/Pack*/
		
		idw_pack.SetRedraw(False)
		llRowCount = idw_pack.RowCount()
		For llRowPos = llRowCount to 1 Step -1
			//Don't delete rows for orders that have been confirmed or deleted
			If idw_pack.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pack.GetITemString(llRowPos,'ord_Status') = 'D' or  idw_pack.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
			idw_pack.DeleteRow(llRowPos)
		Next
		
		idw_pick.SetRedraw(False)
		llRowCount = idw_pick.RowCount()
		For llRowPos = llRowCount to 1 Step -1
			//Don't delete rows for orders that have been confirmed or deleted
			If idw_pick.GetITemString(llRowPos,'ord_Status') = 'C' or idw_pick.GetITemString(llRowPos,'ord_Status') = 'D' or  idw_pick.GetITemString(llRowPos,'ord_Status') = 'V' Then Continue
			idw_pick.DeleteRow(llRowPos)
		Next
				
		ib_changed = True
		idw_pick.SetRedraw(True)
		idw_pack.SetRedraw(True)
		
		//Save changes
		ibGeneratePick = True /*we will want to set the Order status to new if Genereating the Pick*/
		If iw_window.Trigger Event ue_save() = -1 Then Return
		ibGeneratePick = False
		
		//12/14 - PCONKL - we bumped up the print count when printed, reset if new Pick being generated
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Delivery_MAster
		Set pick_list_print_Count = 0
		where Project_id = :gs_Project and batch_Pick_ID = :llBatchID ;
		
		Execute Immediate "Commit" using SQLCA;
		
	End If
	
End If /*Pick Already Exists*/

idw_Pick.SetRedraw(False)
SetPointer(Hourglass!)

ibPickChanged = True

// 01/04  PCONKL - Added option to use default Sort Order for Project
lsPickSort = idw_Master.GetITemString(1,'Pick_Sort_Order')
If lsPickSort = 'PROJECT' Then /*use Project Level Sort Order*/
	If g.is_pick_sort_order > ' ' Then
		lsPickSort = g.is_pick_sort_order
	Else
		lsPickSort = "Complete_Date A"
	End If
End If 



// 11/05 - PCONKL - Building Pick List from Websphere now
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("DOPickRequest", "ProjectID='" + gs_Project + "' PickSortOrder='" + lsPickSort + "'")

//Need a list of valid DO_NOs
llRowCount = idw_Detail.RowCount()
For llRowPos = 1 to llRowCount
	
	If idw_Detail.GetITemString(llRowPos,'do_no') <> lsDONOHold Then
		lsXML += 	'<DONO>' + idw_Detail.GetITemstring(llRowPos,'do_no') +  '</DONO>' 
	End If
	
	lsDONOHold = idw_Detail.GetITemstring(llRowPos,'do_no')
	
Next

lsXML = iuoWebsphere.uf_request_footer(lsXML)

//Messagebox("",lsXML)

w_main.setMicroHelp("Generating Pick List on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

//Messagebox('',lsXMLResponse)

w_main.setMicroHelp("Pick List generation complete")

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to generate Pick List: ~r~r" + lsXMLResponse,StopSign!)
	Return 
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to generate Pick List: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

//messagebox('',lsreturn)

//import XML into DW
If pos(Upper(lsXMLResponse),"DOPICKRECORD") > 0 Then
	idw_Pick.modify("datawindow.import.xml.usetemplate='dopickresponse'")
	idw_Pick.ImportString(xml!,lsXMLResponse)
	ib_changed = True
Else
	messageBox(is_title, 'No pick rows were generated')
End If

idw_pick.SetRedraw(True)

// 08/02 - PConkl - For Saltillo/Detroit, we will drop ALL orders where ANY stock for that order requires Raw/Hold/Quar/Scrap materials
If Upper(Left(gs_project,4)) = 'GM_M' Then /* GAP 09/2002 Added stock on Raw/Hold/Quar/Scrap status to this routine */
	This.TriggerEvent('ue_drop_raw')
End If

idw_pick.Sort()
idw_pick.GroupCalc()

//Notify users of shortages...
If pos(lsXMLResponse,'DOPickShort') > 0 Then
	lstrparms.String_arg[1] = lsXMLResponse
	OpenWithParm(w_pick_exception,lstrparms)
End If

If ibDropRaw Then /* Raw/Hold/Quar/Scrap was required */
	MessageBox(is_title,'One or more orders requires items to be picked from inventory types: Raw/Hold/Quar/Scrap.~r~rThese orders will be dropped from the batch when you save.')
End If

//hide any unused lottable fields (lot, po, etc.)
idw_pick.TriggerEvent('ue_hide_unused')

SetPointer(Arrow!)

//
// pvh gmt 12/28/05
datetime ldtToday
ldtToday = f_getLocalWorldTime( getWarehouse() ) 
//ldtToday = datetime( today(), now() )

idw_master.SetItem(1,'batch_status','P') /*Process Status - will be changed to Picking in ue_save if successfull*/
If isNull(idw_master.GetITemDateTime(1,'pick_start')) Then
	// pvh gmt 12/28/05
	idw_master.SetITem(1,'pick_start', ldtToday )
	//idw_master.SetITem(1,'pick_start',Today())
End If

w_main.SetMicroHelp("Ready")
end event

event ue_print_summary();
Long	llID

//TAM 2016/03 Changed to case and added H2O report

choose case Upper(gs_project)
		
	Case 'BABYCARE'  
		idw_print.Dataobject = 'd_batch_picking_prt_summary_babycare'
		
	Case 'H2O'  
		idw_print.Dataobject = 'd_batch_picking_prt_summary_H2O'
		
	Case Else
		idw_print.Dataobject = 'd_batch_picking_prt_summary'

end choose

//if Upper(gs_project) = 'BABYCARE' THEN
//	
//	idw_print.Dataobject = 'd_batch_picking_prt_summary_babycare'
//	
//ELSE	
//	idw_print.Dataobject = 'd_batch_picking_prt_summary'
//	
//END IF

idw_print.SetTransObject(SQLCA)

SetPointer(HourGlass!)

llID = idw_Master.GetITemNumber(1,'batch_pick_id')
idw_print.Retrieve(gs_project,llID)

idw_print.Modify("pick_start_t.text = '" + String(idw_Master.GetITemDateTime(1,'pick_start'),'mm/dd/yyyy hh:mm') + "'")

//For coty only, show Customer Order NUmber in Header - should only be one per batch
If Upper(gs_project) = 'COTY' and idw_detail.RowCount() > 0 Then
	idw_print.Modify("cust_order_no_t.text = '" + idw_detail.GetITemString(1,'cust_order_No') + "'")
End If

SetPointer(Arrow!)

OpenWithParm(w_dw_print_options,idw_print) 

If message.doubleparm = 1 then

	// 01/14 - PCONKL - update print count
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Delivery_MAster
	Set pick_list_print_Count = 0
	where Project_id = :gs_Project and batch_Pick_ID = :llID and Pick_List_Print_Count is null;
	
	Update Delivery_master
	Set pick_list_print_Count = ( pick_list_print_Count + 1 ) where Project_id = :gs_Project and batch_Pick_ID = :llID;
	
	Execute Immediate "COMMIT" using SQLCA;
		
	idw_detail.Retrieve()
	idw_detail.GroupCalc()
	
End If

end event

event ue_print_order_picklist_babycare();// This event prints the Picking List which is currently visible on the screen 
// and not from the database

Long ll_cnt, i, j, llDetailFindROw, llFindRow
String ls_address, lsUOM
String ls_project_id , ls_sku , ls_description, lsSupplier, lsSkuHold, lsSupplierHold
String ls_inventory_type , ls_inventory_type_desc, lsClientName,lsIMUser9,lsimuser13
String ls_loc_code,ls_whcode, lsSchedCode, lsSchedCodeHold, lsSchedDesc, lsShipVia, lsInvTypeHold
String	 ls_hazard_class, ls_hazard_cd
dec{3} ldweight_1
Str_parms	lStrPArms
Boolean	lbNotBatch
string ls_l_code, ls_invoice_no, ls_do_no, ls_do_no_hold
string ls_user_field11, ls_user_field13, ls_user_field1, ls_user_field12, ls_wh_code, ls_user_field3
string ls_native_description, ls_user_field5, ls_user_field9, ls_user_field4, ls_tel, ls_address_1
String ls_dd_user_field1 
Long  ll_dd_alloc_qty, xi
date	ld_ord_date

// pvh - 02/07/06
long llLine_Item_No
long	llFind
string lsFind
string lsOrderNumber

string donobreak = "*"
string dono
Str_parms	lAddresses

If idw_pick.AcceptText() = -1 Then
	Return	
End If

//Make sure it has been saved first
If ib_Changed Then
	Messagebox(is_title,'Please save changes first.')
	Return
End If

ll_cnt = idw_detail.rowcount()
If ll_cnt = 0 Then
	MessageBox(is_title," No Picking records to print!")
	Return
End If

//Prompt for Sort/BReak Type
OpenWithParm(w_pick_print_order,lstrparms)
lstrparms = Message.PowerObjectParm
	
If lstrparms.Cancelled Then
		
	REturn
		
Else
		
	If lStrparms.String_Arg[1] = 'O' Then /*sort by order, load standard pick list*/
		
		idw_print.Dataobject = 'd_batch_picking_prt_babycare'
		
		lbNotBatch = True
			
	ElseIf lStrparms.String_Arg[1] = 'S' Then /* 09/07 - PCONKL - Just print a summary by Sku/Loc*/
			
		This.TriggerEvent('ue_print_Summary')
		Return
			
	Else /*by Zone */
			
		idw_print.Dataobject = 'd_batch_picking_prt'
					
	End If
		
End If
	

SetPointer(HourGlass!)

idw_print.Reset()

ls_project_id = gs_Project
lsSkuHold = ''
lsSupplierHold = ''

// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From	Project
Where project_id = :ls_project_id
Using SQLCA;

For xi = 1 to ll_cnt
	
	 ls_sku = idw_detail.getitemstring(xi,"sku")
	 lsSupplier = idw_detail.getitemstring(xi,"supp_code") 
	 ls_invoice_no = idw_detail.getitemstring(xi,"invoice_no") 
  
 	  // Find this sku on the pick list dw - set variable i to this value	
	  i = idw_pick.Find( 'sku = "' + ls_sku + '" and supp_code = "' + lsSupplier + '"' + " and invoice_no = '" + ls_invoice_no + "'", 1, idw_pick.RowCount() )
 
 	  IF i = 0 THEN continue  // This should never happen - we should always find the sku on the pick list
	
	// 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
	If idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
	
	ls_sku = idw_pick.getitemstring(i,"sku")
	lsSupplier = idw_pick.getitemstring(i,"supp_code")
	llLine_Item_No = idw_pick.object.line_item_no[ i ]
	lsOrderNumber = idw_pick.object.invoice_no[ i ]
	
	//Some fields from detail Row...
	lsFind = "invoice_no = '" + lsOrderNumber + "' and Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string( llLine_Item_No )
	llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
		
	j = idw_print.InsertRow(0)

	if lbNOtBatch Then
		dono =  idw_pick.object.do_no[ i ]
		if dono <> donoBreak then
			//dts - 01/08 - now setting isShipRef in SetAddressData as well
			setAddressData( dono )
			donobreak=dono
		end if
		// delivery Order number in alternate sku
		
	end if

	idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/

	idw_print.setitem(j,"wh_code",idw_pick.getitemstring(i,"wh_Code"))
	
	//Only retrieve if Sku has changed*/
	If (ls_sku <> lsSKUHold) or (lsSupplier <> lsSupplierHold) Then
		
		//See if we have it on a previous row before re-retrieving...
		lsFind = "Upper(SKU) = '" + Upper(ls_sku) + "' and upper(supp_Code) = '" + Upper(lsSUpplier) + "'"
		llFindRow = idw_print.Find(lsFind, 1, j - 1)
		
		If llFindRow > 0 and J > 1 Then
			
			ls_description = idw_print.getItemString(llFindRow,"description") 
			lsIMUser9 = idw_print.getItemString(llFindRow,"im_user_field9") 
			lsIMUser13 = idw_print.getItemString(llFindRow,"im_user_field13") 
			ldweight_1 = idw_print.getItemNumber(llFindRow,"weight_1") 
													
		Else
			
			select description, User_field9, Weight_1, User_field13, UOM_1, 
					hazard_cd, hazard_class		//TAM 2006/06/26 Added UF13 -- Added hazard cd & class 04/29/11 cawikholm
			into 	:ls_description, :lsIMUser9, :ldweight_1, :lsIMUser13, :lsUOM, :ls_hazard_cd, :ls_hazard_class
		     from item_master 
			where project_id = :ls_project_id and sku = :ls_sku and supp_code = :lsSupplier;
	
		End If
		
	End If
	
//	lsSkuHold = ls_Sku
//	lsSUpplierHold = lsSupplier
	
	ls_description = trim(ls_description)

	
	lAddresses = getAddressData()
	if UpperBound( lAddresses.string_arg ) > 0 and lbNotBatch then
		
		idw_print.object.cust_name[ j ] = lAddresses.string_arg[1]
		idw_print.object.delivery_address1[ j ] = lAddresses.string_arg[2]	
		idw_print.object.delivery_address2[ j ] = lAddresses.string_arg[3]
		idw_print.object.delivery_address3[ j ] = lAddresses.string_arg[4]	
		idw_print.object.delivery_address4[ j ] = lAddresses.string_arg[5]
		idw_print.object.city[ j ] = lAddresses.string_arg[6]	
		idw_print.object.state[ j ] = lAddresses.string_arg[7]
		idw_print.object.zip_code[ j ] = lAddresses.string_arg[8]	
		idw_print.object.country[ j ] = lAddresses.string_arg[9]	
		idw_print.object.carrier[ j ] = lAddresses.string_arg[10]
		
	end if


	//From detail row...
	If llDetailFindRow > 0 Then
		idw_print.setitem(j,"cust_code",idw_detail.object.cust_code[ llDetailFindRow ])
	End If
	
	idw_print.setitem(j,"project_id",Upper(gs_project))
	idw_print.setitem(j,"batch_id",idw_pick.getitemnumber(i,"batch_Pick_id"))
	idw_print.setitem(j,"invoice_no",idw_pick.getitemstring(i,"invoice_no"))
	idw_print.setitem(j,"cust_ord_no",idw_pick.getitemstring(i,"cust_order_no"))
	//idw_print.setitem(j,"cust_code",idw_pick.getitemstring(i,"cust_code"))
	idw_print.setitem(j,"sku",idw_pick.getitemstring(i,"sku"))
	idw_print.setitem(j,"sku_parent",idw_pick.getitemstring(i,"sku_Parent"))
	idw_print.setitem(j,"supp_code",idw_pick.getitemstring(i,"supp_code"))
	idw_print.setitem(j,"description",ls_description)
	idw_print.setitem(j,"im_user_field9",lsimuser9) /* only visible for Saltillo as defined in DW properties*/
	idw_print.setitem(j,"weight_1",ldweight_1) /* GAP 09/2002 */
	idw_print.setitem(j,"serial_no",idw_pick.getitemstring(i,"serial_no"))
	idw_print.setitem(j,"lot_no",idw_pick.getitemstring(i,"lot_no"))
	idw_print.setitem(j,"po_no",idw_pick.getitemstring(i,"po_no"))
	idw_print.setitem(j,"po_no2",idw_pick.getitemstring(i,"po_no2")) 
	idw_print.setitem(j,"container_ID",idw_pick.getitemstring(i,"Container_ID")) /* 11/02 - PCONKL */
	idw_print.setitem(j,"expiration_date",idw_pick.getitemdateTIme(i,"expiration_Date")) /* 11/02 - PCONKL */
		
		
	ls_invoice_no = idw_pick.getitemstring(i,"invoice_no")
	ls_do_no = idw_pick.getitemstring(i,"do_no")
		
	ls_wh_code = idw_pick.getitemstring(i,"wh_Code")

		// Changed to get foward pick location from location table.  cawikholm 08/03/11
	select l_code
	   into :ls_l_code
	  from location  
	 where WH_Code = :ls_wh_code
		and SKU_Reserved =  :ls_sku
	  using SQLCA;
		
		// Use forward pick location if not null from above query.  If null then use original value
		IF IsNull( ls_l_code ) OR ls_l_code = '' THEN
			
			idw_print.setitem(j,"l_code",idw_pick.getitemstring(i,"l_code"))
			
		ELSE
				
			idw_print.setitem(j,"l_code",ls_l_code)
				
		END IF
			
		// 08/03/11 cawikholm - Get User Fields & other fields from Delivery Master
		If ls_do_no <> ls_do_no_Hold Then
			
			SELECT A.User_Field11
				,A.User_Field13
				,A.User_Field1
				,A.User_field12
				,A.User_Field5
				,A.User_Field9
				,A.User_Field4
				,A.User_Field3
				,A.tel
				,A.ord_date
				,A.Address_1
			 INTO :ls_user_field11
		 		,:ls_user_field13
				,:ls_user_field1
				,:ls_user_field12
				,:ls_user_field5
				,:ls_user_field9
				,:ls_user_field4
				,:ls_user_field3
				,:ls_tel
				,:ld_ord_date
				,:ls_address_1
		  	FROM Delivery_Master				A
			 WHERE A.Project_ID = :ls_project_id
				AND A.DO_No = :ls_do_no
			 USING SQLCA;
			 
		End If /*Order Changed*/
		 
		 // set user fileds on babycare batch picking dw
		 
		 idw_print.setitem(j,"user_field11",ls_user_field11)
		 idw_print.setitem(j,"user_field13",ls_user_field13)
		 idw_print.setitem(j,"user_field1",ls_user_field1)		  
 		 idw_print.setitem(j,"user_field12",ls_user_field12)
		 idw_print.setitem(j,"user_field5",ls_user_field5)
		 idw_print.setitem(j,"user_field9",ls_user_field9)
		 idw_print.setitem(j,"user_field4",ls_user_field4)
		 idw_print.setitem(j,"user_field3",ls_user_field3)
			 
		 // set other fields on babycare batch picking dw
		  idw_print.setitem(j,"tel",ls_tel)
		  idw_print.setitem(j,"ord_date",ld_ord_date)
		  idw_print.setitem(j,"address_1",ls_address_1)
		  	
		If (ls_sku <> lsSKUHold) or (lsSupplier <> lsSupplierHold) Then
			
		 	 select native_description				// cawikholm 08/04/11 Added native_description for babycare
				into :ls_native_description
				from item_master 
				where project_id = :ls_project_id and sku = :ls_sku and supp_code = :lsSupplier;	  
				
		End If
			  
		  idw_print.SetItem(j,"description",ls_native_description)	  
			  
		  // Get User_field1 and alloc_qty from delivery_detail
		 SELECT user_field1
					,alloc_qty
		   INTO :ls_dd_user_field1
			    , :ll_dd_alloc_qty
		   FROM delivery_detail
		 WHERE do_no = :ls_do_no
		     AND sku = :ls_sku
			AND supp_code = :lsSupplier
		 USING SQLCA;
		     
		 idw_print.SetItem(j,"user_field1",ls_dd_user_field1)		  
		 idw_print.SetItem(j,"quantity",ll_dd_alloc_qty)		  	  
			  
		
	idw_print.setitem(j,"zone_id",idw_pick.getitemstring(i,"zone_id"))
	idw_print.setitem(j,"component_no",idw_pick.getitemnumber(i,"component_no"))
	
	//lds_print.setitem(j,"ship_ref_nbr",idw_other.getitemstring(1,"ship_ref"))
	idw_print.setitem(j,"ship_ref_nbr", isShipRef)
	
	idw_print.setitem(j,"pick_as",idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
	
	ls_inventory_type = idw_pick.getitemstring(i,"inventory_type")
	If ls_inventory_type <> lsInvTypeHold Then
		
		SELECT Inv_Type_Desc into :ls_inventory_type_desc  
   		 FROM Inventory_Type  
		 where Inv_Type = :ls_inventory_type and Project_id = :gs_project; /* 12/00 PCONKL - Inventory Type is now project specific*/
		 
		 lsInvTypeHold = ls_inventory_type
		 
	End IF
	
	 ls_inventory_type_desc = trim(ls_inventory_type_desc) 
	idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
	ls_loc_code = idw_pick.object.l_code[i]
	ls_whCode   = idw_pick.object.wh_code[i]
	IF i_nwarehouse.inv_common_tables.of_select_location(ls_whCode,ls_loc_code) = 1 THEN
			idw_print.setitem(j,'picking_seq',i_nwarehouse.inv_common_tables.id_picking_seq)
	END IF			
	
	lsSkuHold = ls_Sku
	lsSUpplierHold = lsSupplier
	ls_do_no_hold = ls_do_no
	
Next /*Pick Row*/

idw_print.Sort()
idw_print.GroupCalc()

wf_set_line_no_babycare()
	


OpenWithParm(w_dw_print_options,idw_print) 



end event

event ue_send_to_pick_cart();Long		llRowCount,	&
			llRowPos,	&
			llRecCount,		&
			llBatchID
		
String	lsInvoiceNo, lsPickSort, lsXML, lsXMLResponse, lsDONOHold, lsReturnCode, lsReturnDesc
		
Datastore	ldsOrders

str_parms	lstrparms

If idw_Pick.RowCount() = 0 Then
	Messagebox(is_title,'You must generate and save the Pick List before sending to the cart',StopSign!) 
	REturn
End If /*Pick doesn't Exist*/

If ib_Changed then
	Messagebox(is_title,'You must save your changes  before sending to the cart',StopSign!) 
	Return
End If

//all orders must be fully allocated
If idw_Detail.Find("Alloc_Qty < Req_Qty",1,idw_Detail.RowCount()) > 0 Then
	Messagebox(is_title,"Not all orders have been fully allocated. Batch cannot be sent to cart",Stopsign!) 
	Return
End If

//If already sent, warn
If idw_MAster.GetITEmString(1,'pick_cart_status') = 'Y' Then
	If MessageBox(is_Title,"This batch has already been sent to the cart. Do you want to send again?",Question!,yesNo!,2) = 2 Then
		Return
	End If
End If

SetPointer(Hourglass!)

// 11/05 - PCONKL - Building Pick List from Websphere now
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("IntherPickCartPickRequest", "ProjectID='" + gs_Project + "'")

//Need a list of valid DO_NOs
llRowCount = idw_Detail.RowCount()
For llRowPos = 1 to llRowCount
	
	If idw_Detail.GetITemString(llRowPos,'do_no') <> lsDONOHold Then
		lsXML += 	'<DONO>' + idw_Detail.GetITemstring(llRowPos,'do_no') +  '</DONO>' 
	End If
	
	lsDONOHold = idw_Detail.GetITemstring(llRowPos,'do_no')
	
Next

lsXML = iuoWebsphere.uf_request_footer(lsXML)


w_main.setMicroHelp("Sending Pick List to Cart...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

w_main.setMicroHelp("Send complete")

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to generate Pick List: ~r~r" + lsXMLResponse,StopSign!)
	Return 
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to send Pick List to Cart: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		Else
			Messagebox(is_title,"Transaction successfully sent to Pick Cart")
		End If
			
End Choose

//Update cart status on batch header
idw_Master.setItem(1,'pick_cart_status','Y')
This.TriggerEvent('ue_Save')

//Re-retrieve the detail tab to pick up the status changes
//idw_detail.Retrieve()

SetPointer(Arrow!)

w_main.SetMicroHelp("Ready")
end event

event ue_process_mobile();String	lsWarehouse, lsmobilescanreqind, lsmobilepackloc, lsFindStr, Crap
Long	llBatchPickID
Integer	i
DateTime	ldtGMT

if ib_changed then
	Messagebox(is_title,"Please save your changes before releasing to Mobile")
	Return 
End If
		
SetPointer(Hourglass!)

lsWarehouse = idw_Master.GetITemString(1,'wh_Code')
llBatchPickID = idw_MAster.GetITemNumber(1,'batch_pick_ID')

ldtGMT = f_getLocalWorldTime( lsWarehouse) 
		
//If Releasing, set status and dates, otherwise clear
if isNull(idw_MAster.GetITemString(1,'mobile_enabled_Ind')) or  idw_MAster.GetITemString(1,'mobile_enabled_Ind') = ''  or  idw_MAster.GetITemString(1,'mobile_enabled_Ind') = 'N' Then /* Releasing*/
					
		If idw_Pick.RowCount() = 0 Then
			MessageBox(is_title,'You must generate the Pick List before releasing orders to mobile')
			Return
		End If
		
		lsFindStr = "wh_code = '" + lsWarehouse + "'"
		i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
		If i > 0  Then
			lsmobilepackloc= g.ids_project_warehouse.GetItemString(i, "MObile_Default_Pack_Location") 
			lsmobilescanreqind=g.ids_project_warehouse.GetItemString(i, "MObile_Scan_all_Units_Req_Ind") 
		End If
					
					
		//Update Status on Picking without sending to Websphere
		Execute Immediate "Begin Transaction" using SQLCA;
				
		Update Batch_Pick_Master 
		Set Mobile_Enabled_Ind = 'Y'
		where Project_Id=:gs_project 
		and Batch_Pick_ID=:llBatchPickID;
		
		Update Delivery_Master 
		Set Mobile_status_ind='R',Mobile_Enabled_Ind='Y',Mobile_Pack_Location=:lsmobilepackloc,
		MObile_Scan_all_Units_Req_Ind=:lsmobilescanreqind,Mobile_Released_time=:ldtGMT
		where Project_Id=:gs_project 
		and Batch_Pick_ID=:llBatchPickID;
				
		Update Delivery_Picking
		Set Mobile_status_Ind = 'N'
		Where do_no in (Select do_no from Delivery_Master where project_id = :gs_Project and Batch_Pick_ID=:llBatchPickID);
		
		Execute Immediate "Commit" using SQLCA;
			
Else /*Removing*/
			
		SetNull(ldtGMT )
					
		//Update Status on Picking without sending to Websphere
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update Batch_Pick_Master 
		Set Mobile_Enabled_Ind = 'N'
		where Project_Id=:gs_project 
		and Batch_Pick_ID=:llBatchPickID;
		
		Update Delivery_Master 
		Set Mobile_status_ind='',Mobile_Enabled_Ind='',Mobile_User_Assigned='',Mobile_Released_time=:ldtGMT,
		Mobile_Pick_start_time=:ldtGMT,Mobile_Pick_complete_time=:ldtGMT
		where Project_Id=:gs_project 
		and Batch_Pick_ID=:llBatchPickID;
		
		
		Update Delivery_Picking
		Set Mobile_status_Ind = '', mobile_picked_qty = 0, mobile_picked_by = '', mobile_pick_start_time = null, mobile_pick_Complete_time = null
		Where do_no in (Select do_no from Delivery_Master where project_id = :gs_Project and Batch_Pick_ID=:llBatchPickID);
		
		Execute Immediate "Commit" using SQLCA;
		
End If
		
		
This.TriggerEvent('ue_retrieve')
		
wf_check_status_mobile() 
		
SetPointer(Arrow!)
end event

public function integer wf_update_content ();// 11/02 - PConkl - Chg QTY to Decimal and add Container ID and Exp Date

//** 08/06 - PCONKL - This function is now oudside the transaction - any inline SQL or updates need to be written to SQL array and will be processed
//								within the trasnaction in UE_Save ***

long i, j, k, ll_currow,  ll_totalrows, ll_content_cnt,ll_owner_id,llComponent,llID,llLineItemNo, llArrayCount, llBatchID
string ls_sku,ls_sku_hold, ls_whcode,ls_lcode,ls_itype,ls_sno,ls_lno, &
		ls_dono, ls_status, ls_ro,ls_pono,ls_supp_code, lsZone
String ls_coo, ls_po_no2, ls_find_string , lsCompInd,lsSkuParent, lsFindHold, lsContID

DateTime	ldtExpDate

Boolean	lbSerialExists
Decimal	ld_req, ld_avail, ldContLength, ldContWidth, ldContHeight, ldContWeight

dwitemstatus ldis_status

IdsContent.Reset()
IdsContent.SetFilter("")

IdsPickDetail.Reset()
idw_pick.Sort()

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( getWarehouse() ) 

//08/06 - We only want to try and delete Delivery Serial Detail records if we know they exist for the batch - delete is killing performance
If idw_master.RowCount() > 0 Then
	
	llBatchID = idw_Master.GetITemNUmber(1,'batch_pick_id')
	
	select min(Delivery_serial_detail.id_no) into :llID
	from delivery_master, delivery_Picking_Detail, delivery_serial_detail
	Where Delivery_Picking_Detail.do_no = delivery_MAster.do_no and
			delivery_picking_detail.id_no = delivery_serial_detail.id_no and batch_pick_id = :llBatchID;
		
	If Not isnull(llID) and llID > 0 Then lbSerialExists = True
	
End If

// Retrieve related content records for all modified rows
// not being reset before each retrieve (return 2 in retrievstart event!!!!)

for i = 1 to idw_pick.rowcount()
	
	//We wont make any changes to rows that have been confirmed or Voided!
	If idw_pick.GetITemString(i,'ord_status') = 'C' or idw_pick.GetITemString(i,'ord_status') = 'D' or idw_pick.GetITemString(i,'ord_status') = 'V' Then Continue
	
	// 08/04 - PCONKL - Ignore Component records where component_no = 0 - Just a placeholder for the childeren being blown out (replacing Workorder)
	//							No need to retrieve content records - they won't exist anyway.
	If idw_pick.getitemstring(i, 'Component_ind') = 'Y'  and idw_pick.getitemstring(i, 'l_code') = 'N/A' and (idw_pick.getitemNumber(i,'Component_no') = 0 or isnull(idw_pick.getitemNumber(i,'Component_no'))) Then Continue
	
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	if ldis_status <> NewModified! and ldis_status <> DataModified! then continue
	
	ls_whcode = idw_pick.getitemstring(i,'wh_code') 
	ls_dono = idw_pick.getitemstring(i,'do_no')
	ls_status = idw_Pick.getitemstring(i,'ord_status')

	ls_sku = idw_pick.getitemstring(i,'sku')
	ls_supp_code = idw_pick.getitemstring(i,'supp_code')
	ls_coo = idw_pick.getitemstring(i,'country_of_origin')
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id')
	ls_po_no2 = idw_pick.getitemstring(i,'po_no2')
	lsContID = idw_pick.getitemstring(i,'container_ID') 
	ldtExpDate = idw_pick.getitemDateTime(i,'expiration_Date') 
	ls_lcode = idw_pick.getitemstring(i,'l_code')
	// 10/00 PCONKL - If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind') = 'O' Then
		ls_sno = '-'
	Else
		ls_sno = idw_pick.getitemstring(i,'serial_no')
	End If
	ls_lno = idw_pick.getitemstring(i,'lot_no')
	ls_pono = idw_pick.getitemstring(i,'po_no')
	ls_itype = idw_pick.getitemstring(i,'inventory_type')
	
	// We only want to retrieve the rows once - with batch picking, we may have multiple pick rows that will retrieve the same content rows.
	ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
	ls_find_string += " and owner_id = " + String(ll_owner_id) + " and upper(country_of_origin) = '" + Upper(ls_coo) + "'"
	ls_Find_String += " and Upper(l_code) = '" + Upper(ls_lCode) + "' and Upper(serial_no) = '" + Upper(ls_sno) + "'"
	ls_Find_String += " and Upper(lot_no) = '" + Upper(ls_lno) + "' and Upper(po_no) = '" + Upper(ls_pono) + "'"
	ls_Find_String += " and Upper(po_no2) = '" + Upper(ls_po_no2) + "' and Upper(inventory_type) = '" + Upper(ls_itype) + "'"
	ls_Find_String += " and Upper(container_ID) = '" + Upper(lsContID) + "' and String(expiration_Date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpDate,'mm/dd/yyyy hh:mm') + "'"
	
	If idsContent.Find(ls_find_String,1,idsContent.RowCount()) <=0 Then
		ll_content_cnt = IdsContent.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, lsContID, ldtExpDate)
	End If
	
next

// Return original values of modified old records to content table

for i = 1 to idw_pick.rowcount() /*For each Pick Row*/
	
	//We wont make any changes to rows that have been confirmed or Voided!
	If idw_pick.GetITemString(i,'ord_status',Primary!,True) = 'C' or idw_pick.GetITemString(i,'ord_status',Primary!,True) = 'D' or idw_pick.GetITemString(i,'ord_status',Primary!,True) = 'V' Then Continue
	
	If idw_pick.getitemstring(i,'sku_pickable_ind',Primary!,True) = 'N' Then Continue /* 09/01 PCONKL - content was not touched if SKU is non pickable*/
	
	ls_whcode = idw_pick.getitemstring(i,'wh_code') 
	ls_dono = idw_pick.getitemstring(i,'do_no')
	ls_status = idw_Pick.getitemstring(i,'ord_status')
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	
	if ldis_status <> DataModified! and ls_status <> "V" then Continue

	// 06/00 PCONKL - Find is case sensitive!!!
	ls_sku = Upper(idw_pick.getitemstring(i,'sku',Primary!,True))
	ls_supp_code = Upper(idw_pick.getitemstring(i,'supp_code',Primary!,True))
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id',Primary!,True)
	ls_coo = Upper(idw_pick.getitemstring(i,'country_of_origin',Primary!,True))
	ls_po_no2 = Upper(idw_pick.getitemstring(i,'po_no2',Primary!,True))
	lsContID = Upper(idw_pick.getitemstring(i,'container_ID',Primary!,True)) 
	ldtExpDate = idw_pick.getitemDateTime(i,'expiration_date',Primary!,True)
	ls_lcode = Upper(idw_pick.getitemstring(i,'l_code',Primary!,True))
	// 10/00 PCONKL - If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind') = 'O' Then
		ls_sno = '-'
	Else
		ls_sno = Upper(idw_pick.getitemstring(i,'serial_no',Primary!,True))
	End If
	ls_lno = Upper(idw_pick.getitemstring(i,'lot_no',Primary!,True))
	ls_itype = idw_pick.getitemstring(i,'inventory_type',Primary!,True)
	ls_pono = Upper(idw_pick.getitemstring(i,'po_no',Primary!,True))
	lsCompind = Upper(idw_pick.getitemstring(i,'component_ind'))
	lsZone = Upper(idw_pick.getitemstring(i,'delivery_Picking_zone_ID')) /* 05/05- PCONKL - This is the zone ID from Picking, Not location */
	If isnull(lsCompInd) Then lsCompInd = ''
	llComponent = idw_pick.getitemnumber(i,'component_no') 
	llLineItemNo = idw_pick.getitemnumber(i,'Line_Item_no') 
	ldContlength = idw_pick.getitemnumber(i,'cntnr_length')
	ldContWidth = idw_pick.getitemnumber(i,'cntnr_width')
	ldContheight = idw_pick.getitemnumber(i,'cntnr_height')
	ldContWeight = idw_pick.getitemnumber(i,'cntnr_Weight')
	
	IdsPickDetail.retrieve(ls_dono, ls_sku, ls_supp_code,ll_Owner_Id,ls_coo,ls_lcode, ls_itype, ls_sno, ls_lno, ls_pono,ls_po_no2,llLineItemNo, lsContID, ldtExpDate, llComponent, lsZone)
	
	ll_totalrows = IdsPickDetail.RowCount()
	If ll_totalrows <= 0 Then
		MessageBox(is_title, "System error 10002, please contact system support!", StopSign!)
		Return -1
	End If
	
	// 09/04 - PCONKL - If this is a parent placeholder for children items being exploded (replacing WO), We don't want to
	//							update COntent (it was never allocated) but we still need to delete the Pick Detail Records. They will be
	//							rebuilt below.
	If idw_pick.getitemstring(i, 'Component_ind',Primary!,True) = 'Y'  and idw_pick.getitemstring(i, 'l_code',Primary!,True) = 'N/A'  and (idw_pick.getitemNumber(i,'Component_no',Primary!,True) = 0 or isnull(idw_pick.getitemNumber(i,'Component_no',Primary!,True))) Then 
	Else	
		
		ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '"  + ls_supp_code + & 
	   					"' and Upper(l_code) = '" + ls_lcode + "' and upper(country_of_origin) = '" + ls_coo + "'" + &
							" and owner_id = " + string(ll_owner_id) + " and Upper(po_no2) = '" + ls_po_no2 + &
							"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
							+ ls_lno + "' and upper(po_no) = '" + ls_pono +  "' and inventory_type = '" + ls_itype + "'" + &
							" and Upper(container_id) = '" + lsContID + "' and String(expiration_Date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpDate,'mm/dd/yyyy hh:mm') + "'"
	
		// 10/00 Pconkl - Include component info in Find so we can update a specific component, set to 0 if not a component
		If Not isnull(llComponent) Then
			ls_find_string +=	" and component_no = " + string(llComponent)
		End If
	
		k = IdsContent.Find(ls_find_string, 1, IdsContent.RowCount())
		If k	<= 0 Then
			ll_content_cnt = IdsContent.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_Owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono, ls_po_no2,ls_itype, lsContID, ldtExpDate)
		End If
	
		for j = 1 to ll_totalrows /*for each Pick Detail Row*/
		
			ls_ro = IdsPickDetail.GetItemString(j,'ro_no')
			ll_currow = IdsContent.Find(ls_find_string + " and inventory_type ='" + ls_itype + "' and ro_no = '" + ls_ro + "'",1, IdsContent.RowCount())
			If ll_currow <= 0 Then
				ll_currow = IdsContent.InsertRow(0)
				IdsContent.setitem(ll_currow,'project_id',gs_project)
				IdsContent.setitem(ll_currow,'ro_no',ls_ro)
				IdsContent.setitem(ll_currow,'sku',ls_sku)
				IdsContent.setitem(ll_currow,'supp_code',ls_supp_code)
				IdsContent.setitem(ll_currow,'wh_code',ls_whcode)
				IdsContent.setitem(ll_currow,'owner_id',ll_owner_id)
				IdsContent.setitem(ll_currow,'country_of_origin',ls_coo)
				IdsContent.setitem(ll_currow,'po_no2',ls_po_no2)
				IdsContent.setitem(ll_currow,'container_id',lsContID)
				IdsContent.setitem(ll_currow,'expiration_date',ldtExpDate)
				IdsContent.setitem(ll_currow,'l_code',ls_lcode)
				IdsContent.setitem(ll_currow,'inventory_type',ls_itype)
				IdsContent.setitem(ll_currow,'serial_no',ls_sno)
				IdsContent.setitem(ll_currow,'lot_no', ls_lno)
				IdsContent.setitem(ll_currow,'po_no', ls_pono)
				IdsContent.setitem(ll_currow,'reason_cd', '')
				IdsContent.setitem(ll_currow,'avail_qty', 0)
				IdsContent.setitem(ll_currow,'component_qty', 0)
				IdsContent.setitem(ll_currow,'last_user',gs_userid)
				// pvh 11/23/05 - GMT
				IdsContent.setitem(ll_currow,'last_update', ldtToday )
				//IdsContent.setitem(ll_currow,'last_update',today())
				If isnull(llComponent) Then llComponent = 0 /* 06/01 PConkl */
				IdsContent.setitem(ll_currow,'component_no',llComponent) /* 10/00 PCONKL */
				IdsContent.setitem(ll_currow,'complete_date',IdsPickDetail.GetItemDateTime(j,'complete_date'))
			
				// 02/03 - PCONKL - Container Dimensions and Weight need to be returned to Content
				idscontent.setitem(ll_currow,'cntnr_Length', ldContLength)
				idscontent.setitem(ll_currow,'cntnr_Width', ldContWidth)
				idscontent.setitem(ll_currow,'cntnr_Height', ldContHeight)
				idscontent.setitem(ll_currow,'cntnr_Weight', ldContWeight)
				
			End If
		
			// 10/00 PCONKL - If it's a component child, update the component qty, otherwise update available QTy
			If lsCompInd = '*' Then /*Componet Child, update Component_qty*/
				IdsContent.setitem(ll_currow,'component_qty', &
					IdsContent.getitemnumber(ll_currow, "component_qty") + &
					IdsPickDetail.GetItemNumber(j,'quantity'))
			Else /*not a component child, update available qty*/
				IdsContent.setitem(ll_currow,'avail_qty', &
					IdsContent.getitemnumber(ll_currow, "avail_qty") + &
					IdsPickDetail.GetItemNumber(j,'quantity'))
			End If /*component? */
			
		next /*Next Pick Detail*/
		
	End If /*Not a parent placeholder */
	
	for j = ll_totalrows to 1 Step -1
		
		//10/00 PCONKL - delete delivery serial rows first
		llID = IdsPickDetail.GetITemNumber(j,'id_no')
				
		//Delete from delivery_serial_detail where id_no = :llID;
		
		//08/06 - PCONKL - update will occur in ue_save within transaction - 
		//						This delete is killing performance, we only want to delete if we know we have any for the batch
		If lbSerialExists Then
			
			llArrayCount = UpperBound(isUpdateSql)
			llArrayCount ++
			isUpdateSql[llArrayCount] = "Delete from delivery_serial_detail where id_no = " + String(llID) + ";"
					
		End If
		
		IdsPickDetail.DeleteRow(j)
		
	next
	
next /*Next Pick*/

// Return deleted rows to content table

for i = 1 to idw_pick.deletedcount()
	
	//We wont make any changes to rows that have been confirmed or Voided!
	If idw_pick.GetITemString(i,'ord_status',Delete!,True) = 'C' or idw_pick.GetITemString(i,'ord_status',Delete!,True) = 'D' or idw_pick.GetITemString(i,'ord_status',Delete!,True) = 'V' Then Continue
	
	// 09/01 PCONKL - No Picking Detail Row if SKU is non-pickable (it was never picked to begin with)
	If idw_pick.getitemstring(i,'sku_pickable_ind',Delete!,True) = 'N' Then Continue
	
	ldis_status = idw_pick.getitemstatus(i,0,Delete!)
	ls_whcode = idw_Pick.getitemstring(i,'wh_code',Delete!,True) /*warehouse will be the same for all of the orders in the batch*/
	ls_doNo = idw_Pick.getitemstring(i,'do_no',Delete!,True)
	ls_status = idw_Pick.getitemstring(i,'ord_status',Delete!,True)
	
	if ldis_status = New! or ldis_status = NewModified! then Continue

	// 06/00 PCONKL - Find is case sensitive!!
	ls_sku = Upper(idw_pick.getitemstring(i,'sku',Delete!,True))
	ls_supp_code = Upper(idw_pick.getitemstring(i,'supp_code',Delete!,True))
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id',Delete!,True)
	ls_coo = Upper(idw_pick.getitemstring(i,'country_of_origin',Delete!,True))
	ls_po_no2 = Upper(idw_pick.getitemstring(i,'po_no2',Delete!,True))
	lsContID = Upper(idw_pick.getitemstring(i,'container_ID',Delete!,True)) 
	ldtExpDate = idw_pick.getitemDateTime(i,'expiration_Date',Delete!,True)
	ls_lcode = Upper(idw_pick.getitemstring(i,'l_code',Delete!,True))
	// 10/00 PCONKL - If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind',Delete!,True) = 'O' Then
		ls_sno = '-'
	Else
		ls_sno = Upper(idw_pick.getitemstring(i,'serial_no',Delete!,True))
	End If
	ls_lno = Upper(idw_pick.getitemstring(i,'lot_no',Delete!,True))
	ls_itype = idw_pick.getitemstring(i,'inventory_type',Delete!,True)
   ls_pono = Upper(idw_pick.getitemstring(i,'po_no',Delete!,True))
	lsCompind = Upper(idw_pick.getitemstring(i,'component_ind',Delete!,True))
	lsZone = Upper(idw_pick.getitemstring(i,'delivery_Picking_Zone_ID',Delete!,True)) /* 05/05 PCONKL */
	if Isnull(lsCompInd) Then lsCompInd = ''
	llComponent = idw_pick.getitemnumber(i,'component_no',Delete!,True) 
	llLineItemNo = idw_pick.getitemnumber(i,'line_Item_No',Delete!,True) 
	ldContlength = idw_pick.getitemnumber(i,'cntnr_length',Delete!,True)
	ldContWidth = idw_pick.getitemnumber(i,'cntnr_width',Delete!,True)
	ldContheight = idw_pick.getitemnumber(i,'cntnr_height',Delete!,True)
	ldContWeight = idw_pick.getitemnumber(i,'cntnr_Weight',Delete!,True)
	
	IdsPickDetail.retrieve(ls_dono, ls_sku, ls_supp_code,ll_owner_id,ls_coo, ls_lcode, ls_itype, ls_sno, ls_lno, ls_pono,ls_po_no2,llLineItemNo, lsContID, ldtExpDAte,llComponent, lsZone)
	ll_totalrows = IdsPickDetail.RowCount()
	If ll_totalrows <= 0 Then
		MessageBox(is_title, "System error 10001, please contact system support!", StopSign!)
		Return -1
	End If

	// 08/04 - PCONKL - Ignore Component records where component_no = 0 - Just a placeholder for the childeren being blown out (replacing Workorder)
	If idw_pick.getitemstring(i, 'Component_ind',Delete!,True) = 'Y'  and idw_pick.getitemstring(i, 'l_code',Delete!,True) = 'N/A' and (idw_pick.getitemNumber(i,'Component_no',Delete!,True) = 0 or isnull(idw_pick.getitemNumber(i,'Component_no',Delete!,True))) Then
	Else
		
		// 10/00 PCONKL - Include Component in Find
		ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '"  + ls_supp_code + & 
	   					"' and Upper(l_code) = '" + ls_lcode + "' and Upper(country_of_origin) = '" + ls_coo + "'" + &
							" and owner_id = " + string(ll_owner_id) + " and Upper(po_no2) = '" + ls_po_no2 + &
							"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
							+ ls_lno + "' and upper(po_no) = '" + ls_pono +  "' and inventory_type = '" + ls_itype + "'" + &
							" and Upper(Container_ID) = '" + lsContID + "' and String(expiration_Date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpDate,'mm/dd/yyyy hh:mm') + "'"
	
		// 10/00 Pconkl - Include component info in Find so we can update a specific component, set to 0 if not a component
		If Not isnull(llComponent) Then
			ls_find_string +=	" and component_no = " + string(llComponent)
		End If
						
		k = IdsContent.Find(ls_find_string, 1, IdsContent.RowCount())
		If k	<= 0 Then
			ll_content_cnt = IdsContent.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo, ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, lsContID, ldtExpDate)
		End If
	
		// pvh 11/23/05 - gmt
		//ldtToday = f_getLocalWorldTime( getWarehouse() ) 
		//ldtToday = datetime( today(), now() )
	
		for j = 1 to ll_totalrows /*For Each Pick Detail */
		
			ls_ro = IdsPickDetail.GetItemString(j,'ro_no')
			ll_currow = IdsContent.Find(ls_find_string + "and inventory_type ='"+ls_itype+"'",1, IdsContent.RowCount())
		
			If ll_currow <= 0 Then
				ll_currow = IdsContent.InsertRow(0)
				IdsContent.setitem(ll_currow,'project_id',gs_project)
				IdsContent.setitem(ll_currow,'sku',ls_sku)
				IdsContent.setitem(ll_currow,'supp_code',ls_supp_code)
				IdsContent.setitem(ll_currow,'country_of_origin',ls_coo)
				IdsContent.setitem(ll_currow,'owner_id',ll_owner_id)
				IdsContent.setitem(ll_currow,'wh_code',ls_whcode)
				IdsContent.setitem(ll_currow,'l_code',ls_lcode)
				IdsContent.setitem(ll_currow,'inventory_type',ls_itype)
				IdsContent.setitem(ll_currow,'serial_no',ls_sno)
				IdsContent.setitem(ll_currow,'lot_no', ls_lno)
				IdsContent.setitem(ll_currow,'ro_no',ls_ro)
				IdsContent.setitem(ll_currow,'po_no',ls_pono)
				IdsContent.setitem(ll_currow,'po_no2',ls_po_no2)
				IdsContent.setitem(ll_currow,'container_id',lsContID) /* 11/02 - PCONKL */
				IdsContent.setitem(ll_currow,'expiration_Date',ldtExpDate) /* 11/02 - PCONKL */
				IdsContent.setitem(ll_currow,'reason_cd','')
				IdsContent.setitem(ll_currow,'avail_qty', 0)
				IdsContent.setitem(ll_currow,'component_qty', 0)
				IdsContent.setitem(ll_currow,'last_user',gs_userid)
				// pvh 11/23/05 - GMT
				IdsContent.setitem(ll_currow,'last_update',ldtToday )
				//IdsContent.setitem(ll_currow,'last_update',today())
			
				If isnull(llComponent) then llComponent = 0 /* 06/01 PCONKL */
				IdsContent.setitem(ll_currow,'component_no',llComponent) /* 10/00 PCONKL */
				IdsContent.setitem(ll_currow,'complete_date',IdsPickDetail.GetItemDateTime(j,'complete_date'))
			
				// 02/03 - PCONKL - Container Dimensions and Weight need to be returned to Content
				idscontent.setitem(ll_currow,'cntnr_Length', ldContLength)
				idscontent.setitem(ll_currow,'cntnr_Width', ldContWidth)
				idscontent.setitem(ll_currow,'cntnr_Height', ldContHeight)
				idscontent.setitem(ll_currow,'cntnr_Weight', ldContWeight)
				
			End If
		
			// 10/00 PCONKL - If it's a component child, update the component qty, otherwise update available QTy
			If lsCompInd = '*' Then /*Component Child, update Component_qty*/
				IdsContent.setitem(ll_currow,'component_qty', &
					IdsContent.getitemnumber(ll_currow, "component_qty") + &
					IdsPickDetail.GetItemNumber(j,'quantity'))
			Else /*not a component child, update available qty*/
				IdsContent.setitem(ll_currow,'avail_qty', &
					IdsContent.getitemnumber(ll_currow, "avail_qty") + &
					IdsPickDetail.GetItemNumber(j,'quantity'))
			End If /*component? */
		
		next /*Next Pick Detail */
		
	End If /*Not a parent placeholder */
	
	for j = ll_totalrows to 1 Step -1
		//10/00 PCONKL - delete delivery serial rows first
		llID = IdsPickDetail.GetITemNumber(j,'id_no')
		
		//Delete from delivery_serial_detail where id_no = :llID;
		
		//08/06 - PCONKL - update will occur in ue_save within transaction - 
		//						This delete is killing performance, we only want to delete if we know we have any for the batch
		If lbSerialExists Then
			
			llArrayCount = UpperBound(isUpdateSql)
			llArrayCount ++
			isUpdateSql[llArrayCount] = "Delete from delivery_serial_detail where id_no = " + String(llID) + ";"
						
		End If
				
		IdsPickDetail.DeleteRow(j)
		
	next
	
next

IdsContent.sort()

// Transfer new requested quantity from content to picking detail for all modified rows

If ls_status <> "V" Then
for i = 1 to idw_pick.rowcount()
	
	//We wont make any changes to rows that have been confirmed or Voided!
	If idw_pick.GetITemString(i,'ord_status') = 'C' or idw_pick.GetITemString(i,'ord_status') = 'D' or idw_pick.GetITemString(i,'ord_status') = 'V' Then Continue
	
	/* 09/01 PCONKL - content was not touched if SKU is non pickable*/
	If idw_pick.getitemstring(i,'sku_Pickable_Ind') = 'N' Then Continue
	
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	ls_whcode = idw_Pick.getitemstring(i,'wh_code') 
	ls_dono = idw_Pick.getitemstring(i,'do_no')
	ls_status = idw_Pick.getitemstring(i,'ord_status')
	
	if not (ldis_status = DataModified! or ldis_status = NewModified!) then continue
	
	// 06/00 PCONKL - Filter is case sensitive!!
	ls_sku   = Upper(idw_pick.getitemstring(i,'sku'))
	lsskuparent   = Upper(idw_pick.getitemstring(i,'sku_parent'))
	ls_supp_code   = Upper(idw_pick.getitemstring(i,'supp_code'))
	ll_owner_id = 	idw_pick.getitemnumber(i,'owner_id')
	ls_lcode = Upper(idw_pick.getitemstring(i,'l_code'))
	ls_Coo = Upper(idw_pick.getitemstring(i,'country_of_origin'))
	// 10/00 PCONKL - If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind') = 'O' Then
		ls_sno = '-'
	Else
		ls_sno   = Upper(idw_pick.getitemstring(i,'serial_no'))
	End If
	ls_lno   = Upper(idw_pick.getitemstring(i,'lot_no'))
	ls_pono   = Upper(idw_pick.getitemstring(i,'po_no'))
	ls_po_no2   = Upper(idw_pick.getitemstring(i,'po_no2'))
	lsCOntID  = Upper(idw_pick.getitemstring(i,'container_id')) /* 11/02 - PCONKL */
	ldtExpDate  = idw_pick.getitemdateTime(i,'expiration_date') /* 11/02 - PCONKL */
	ls_itype = idw_pick.getitemstring(i,'inventory_type')
	ld_req   = idw_pick.getitemnumber(i,'quantity') 
	lsCompind = Upper(idw_pick.getitemstring(i,'component_ind')) /* 10/00 PCONKL */
	lsZone = Upper(idw_pick.getitemstring(i,'Zone_ID')) /* 05/05 PCONKL */
	if isNull(lsCompInd) Then lsCompInd = ''
	llComponent = idw_pick.getitemnumber(i,'component_no') /* 10/00 PCONKL */
	llLineItemNo = idw_pick.getitemnumber(i,'line_Item_No') /* 09/01 PCONKL */
	ldContlength = idw_pick.getitemnumber(i,'cntnr_length')
	ldContWidth = idw_pick.getitemnumber(i,'cntnr_width')
	ldContheight = idw_pick.getitemnumber(i,'cntnr_height')
	ldContWeight = idw_pick.getitemnumber(i,'cntnr_Weight')
	
	If isnull(ld_req) Then ld_req = 0 /* 07/00 PCONKL */
	
	If idw_pick.getitemstring(i, 'Component_ind') = 'Y'  and idw_pick.getitemstring(i, 'l_code') = 'N/A' and (idw_pick.getitemNumber(i,'Component_no') = 0 or isnull(idw_pick.getitemNumber(i,'Component_no'))) Then 
		
		//Build a pick detail record without updating content
		ll_currow = IdsPickDetail.InsertRow(0)
		IdsPickDetail.setitem(ll_currow,'do_no',ls_dono)
		IdsPickDetail.setitem(ll_currow,'sku',ls_sku)
		IdsPickDetail.setitem(ll_currow,'sku_parent',lsskuParent) 
		IdsPickDetail.setitem(ll_currow,'supp_code',ls_supp_code)
		IdsPickDetail.setitem(ll_currow,'country_of_origin',ls_coo)
		IdsPickDetail.setitem(ll_currow,'owner_id',ll_owner_id)
		IdsPickDetail.setitem(ll_currow,'l_code',ls_lcode)
		IdsPickDetail.setitem(ll_currow,'inventory_type',ls_itype)
		IdsPickDetail.setitem(ll_currow,'serial_no',ls_sno)
		IdsPickDetail.setitem(ll_currow,'lot_no',ls_lno)
		IdsPickDetail.setitem(ll_currow,'po_no',ls_pono)
		IdsPickDetail.setitem(ll_currow,'po_no2',ls_po_no2)
		IdsPickDetail.setitem(ll_currow,'container_ID',lsContID) 
		IdsPickDetail.setitem(ll_currow,'expiration_date',ldtExpDate) 
		IdsPickDetail.setitem(ll_currow,'component_ind',lsCompInd)
		IdsPickDetail.setitem(ll_currow,'Zone_ID',lsZone) /* 05/05 PCONKL*/
		If isnull(llComponent) Then llComponent = 0 
		IdsPickDetail.setitem(ll_currow,'component_no',llComponent) 
		IdsPickDetail.setitem(ll_currow,'line_Item_No',llLineItemNo) 
		IdsPickDetail.setitem(ll_currow,'ro_no','N/A')
		IdsPickDetail.setitem(ll_currow,'cntnr_length',ldContlength)
		IdsPickDetail.setitem(ll_currow,'cntnr_width',ldContWidth)
		IdsPickDetail.setitem(ll_currow,'cntnr_height',ldContHeight)
		IdsPickDetail.setitem(ll_currow,'cntnr_weight',ldContWeight)
		
		IdsPickDetail.setitem(ll_currow,'quantity', ld_req)
				
	Else
		
		// 10/00 Pconkl - Include component in Find
		ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '" + ls_supp_code + "' and Upper(Country_of_origin) = '" + ls_coo + "'" + & 
	   					" and owner_id = " + string(ll_owner_id) + " and Upper(po_no2) = '" + ls_po_no2 + &
							"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
							+ ls_lno + "' and upper(po_no) = '" + ls_pono +  "' and inventory_type = '" + ls_itype + "'" + &
							" and Upper(Container_ID) = '" + lsContID + "' and String(expiration_Date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpDate,'mm/dd/yyyy hh:mm') + "'"
						
		// 10/00 Pconkl - Include component info in Find so we can update a specific component, set to 0 if not a component
		If Not isnull(llComponent) Then
			ls_find_string +=	" and component_no = " + string(llComponent)
		End If
						
		lsFindHold = ls_Find_String /*find without location*/
	
		//Ignore location if it's a component Child
		//If lsCompInd <> '*' Then
			ls_find_String += " and Upper(l_code) = '" + ls_lcode + "'"
		//End If
	
		//Filter is case sensitive!!
		IdsContent.SetFilter(ls_find_string)
		IdsContent.Filter()
		
		//If we didn't find any component children at this location, try without location in find
		If lsCompInd = '*' and IdsContent.RowCount() = 0 Then
			IdsContent.SetFilter(lsFindHold)
			IdsContent.Filter()
		End If
	
		j = 0  								

		//Do while ll_req > 0 and j < IdsContent.RowCount()
		Do while ld_req > 0 and j < IdsContent.RowCount() and IdsContent.RowCount() > 0
			
			j += 1
			// 10/00 PCONKL - If This is a component Child, we are using component qty, other wise available qty
			If lsCompInd = '*' Then
				ld_avail = IdsContent.GetItemNumber(j, "component_qty")
			Else
				ld_avail = IdsContent.GetItemNumber(j, "avail_qty")
			End If
		
			If ld_avail <= 0 Then Continue
		
			//If it's component child and the content location is other than on the pick list, update pick list
			// children aren't being moved in a atransfer so we need to be able to pick from another location with the same component number
			If lsCompind = '*' Then
				idw_pick.SetItem(i,"l_code",IdsContent.GetITemString(j,'l_code'))
				ls_lCode = IdsContent.GetITemString(j,'l_code')
			End If
		
			ll_currow = IdsPickDetail.InsertRow(0)
			IdsPickDetail.setitem(ll_currow,'do_no',ls_dono)
			IdsPickDetail.setitem(ll_currow,'sku',ls_sku)
			IdsPickDetail.setitem(ll_currow,'sku_parent',lsskuParent) /*10/00 PCONKL */
			IdsPickDetail.setitem(ll_currow,'supp_code',ls_supp_code)
			IdsPickDetail.setitem(ll_currow,'country_of_origin',ls_coo)
			IdsPickDetail.setitem(ll_currow,'owner_id',ll_owner_id)
			IdsPickDetail.setitem(ll_currow,'l_code',ls_lcode)
			IdsPickDetail.setitem(ll_currow,'inventory_type',ls_itype)
			IdsPickDetail.setitem(ll_currow,'serial_no',ls_sno)
			IdsPickDetail.setitem(ll_currow,'lot_no',ls_lno)
			IdsPickDetail.setitem(ll_currow,'po_no',ls_pono)
			IdsPickDetail.setitem(ll_currow,'po_no2',ls_po_no2)
			IdsPickDetail.setitem(ll_currow,'container_id',lsContID) /* 11/02 - PCONKL */
			IdsPickDetail.setitem(ll_currow,'expiration_Date',ldtExpDate) /* 11/02 - PCONKL */
			IdsPickDetail.setitem(ll_currow,'component_ind',lsCompInd) /* 10/00 PCONKL*/
			If isnull(llComponent) Then llComponent = 0 /* 06/01 PCONKL*/
			IdsPickDetail.setitem(ll_currow,'component_no',llComponent) /* 10/00 PCONKL*/
			IdsPickDetail.setitem(ll_currow,'line_Item_No',llLineItemNo) /* 09/01 PCONKL*/
			IdsPickDetail.setitem(ll_currow,'ro_no',IdsContent.GetItemString(j,'ro_no'))
			IdsPickDetail.setitem(ll_currow,'cntnr_length',ldContlength)
			IdsPickDetail.setitem(ll_currow,'cntnr_width',ldContWidth)
			IdsPickDetail.setitem(ll_currow,'cntnr_height',ldContHeight)
			IdsPickDetail.setitem(ll_currow,'cntnr_weight',ldContWeight)
		
			If ld_avail >= ld_req Then
				IdsPickDetail.setitem(ll_currow,'quantity', ld_req)
				// 10/00 PCONKL - If This is a component Child, we are using component qty, other wise available qty
				If lsCompInd = '*' Then
					IdsContent.setitem(j, "component_qty", ld_avail - ld_req)
				Else
					IdsContent.setitem(j, "avail_qty", ld_avail - ld_req)
				End If
				ld_req = 0
			Else
				IdsPickDetail.setitem(ll_currow,'quantity', ld_avail)
				// 10/00 PCONKL - If This is a component Child, we are using component qty, other wise available qty
				If lsCompInd = '*' Then
					IdsContent.setitem(j, "component_qty", 0)
				Else
					IdsContent.setitem(j, "avail_qty", 0)
				End If
				ld_req -= ld_avail			
			End If
		
		Loop
	
		If (ld_req > 0) and (lsCompInd <> '*') Then /* 10/00 PCONKL - we dont really care if not enough component child inventory*/
			Messagebox(is_title,"Not enough inventory for picking!",StopSign!)
			tab_main.selecttab(3)
			idw_pick.SetFocus()
			idw_pick.SetColumn('SKU')
			idw_pick.SetRow(i)
			idw_pick.ScrolltoRow(i)
		
			return -1
		End If
		
	End If /*parent placeholder*/
	
next /*next Pick Row */

End If

Return 1
end function

public function integer wf_check_status ();//enable disable based on Status

String	lsStatus

lsStatus = idw_master.GetITemString(1,'batch_status')

tab_main.TabPage_Order_detail.cb_remove_orders.Enabled = False

Choose Case lsStatus
		
	Case 'N' /*New*/
		
		tab_main.Tabpage_Order_Detail.Enabled = False
		tab_main.Tabpage_Pick.Enabled = False
		tab_main.Tabpage_Pack.Enabled = False
		tab_main.Tabpage_Trax.Enabled = False
		
		idw_detail.Modify("c_select_ind.visible=True") 
		
		tab_main.tabpage_main.cb_generate.Enabled = True
		tab_main.tabpage_main.cb_cust.Enabled = True
		im_menu.m_file.m_save.Enabled = True
		
//		tab_main.Tabpage_order_Detail.cb_selectall.Enabled = True
//		tab_main.Tabpage_order_Detail.cb_Clearall.Enabled = True
			
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		
		tab_main.tabPage_main.cb_confirm.Enabled = False
				
		tab_main.TabPage_Pick.cb_generate_pick.Enabled = True
		
		tab_main.TabPage_Pick.cb_insert_pick.Enabled = True
		tab_main.TabPage_Pick.cb_delete_pick.Enabled = True
		tab_main.TabPage_Pick.cb_pick_copy.Enabled = True
		
		tab_main.TabPage_Pack.cb_generate_pack.Enabled = True
		tab_main.TabPage_Pack.cb_insert_pack.Enabled = True
		tab_main.TabPage_Pack.cb_delete_pack.Enabled = True
		tab_main.TabPage_Pack.cb_pack_copy.Enabled = True
		
		idw_master.Object.DataWindow.ReadOnly="No"
		idw_Detail.Object.DataWindow.ReadOnly="No"
		idw_Pick.Object.DataWindow.ReadOnly="No"
		
		//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -START
		If idw_detail.find("ord_status = 'V'",1,idw_detail.RowCount()) > 0 Then
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = True
		Else
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = False /* 05/13 - PCONKL */
		END IF//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -END
		
	Case 'P' /*Process*/
		
		tab_main.Tabpage_Order_Detail.Enabled = True
		tab_main.Tabpage_Pick.Enabled = True
		tab_main.Tabpage_Pack.Enabled = True
		tab_main.Tabpage_Trax.Enabled = False
		
		idw_detail.Modify("c_select_ind.visible=False") /* we don't want to show the selection checkbox if we have already saved these records*/
//		tab_main.Tabpage_order_Detail.cb_selectall.Enabled = False
//		tab_main.Tabpage_order_Detail.cb_Clearall.Enabled = False
		tab_main.tabpage_main.cb_generate.Enabled = True
					
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		
		tab_main.tabPage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_cust.Enabled = True
		
		tab_main.TabPage_Pick.cb_generate_pick.Enabled = True
		tab_main.TabPage_Pick.cb_insert_pick.Enabled = True
		tab_main.TabPage_Pick.cb_delete_pick.Enabled = True
		tab_main.TabPage_Pick.cb_pick_copy.Enabled = True
		tab_main.TabPage_Pick.cb_pick_Print.Enabled = True
		
		tab_main.TabPage_Pack.cb_generate_pack.Enabled = True
		tab_main.TabPage_Pack.cb_insert_pack.Enabled = True
		tab_main.TabPage_Pack.cb_delete_pack.Enabled = True
		tab_main.TabPage_Pack.cb_pack_copy.Enabled = True
		
		idw_master.Object.DataWindow.ReadOnly="No"
		idw_Detail.Object.DataWindow.ReadOnly="No"
		idw_Pick.Object.DataWindow.ReadOnly="No"
		
		//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -START
		If idw_detail.find("ord_status = 'V'",1,idw_detail.RowCount()) > 0 Then
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = True
		Else
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = False /* 05/13 - PCONKL */
		END IF//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -END
		
	Case 'I', 'A' /*Picking/Packing*/
		
		tab_main.Tabpage_Order_Detail.Enabled = True
		tab_main.Tabpage_Pick.Enabled = True
		tab_main.Tabpage_Pack.Enabled = True
		
		wf_enable_trax() /*enable or disable trax page depening on warehouse setting*/
		
		idw_detail.Modify("c_select_ind.visible=False") /* we don't want to show the selection checkbox if we have already saved these records*/
//		tab_main.Tabpage_order_Detail.cb_selectall.Enabled = False
//		tab_main.Tabpage_order_Detail.cb_Clearall.Enabled = False
		tab_main.tabpage_main.cb_generate.Enabled = False
					
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		
		tab_main.tabPage_main.cb_confirm.Enabled = True
		tab_main.tabpage_main.cb_cust.Enabled = True
		
		tab_main.TabPage_Order_detail.cb_remove_orders.Enabled = False
				
		tab_main.TabPage_Pick.cb_generate_pick.Enabled = True
		tab_main.TabPage_Pick.cb_insert_pick.Enabled = True
		tab_main.TabPage_Pick.cb_delete_pick.Enabled = True
		tab_main.TabPage_Pick.cb_pick_copy.Enabled = True
		tab_main.TabPage_Pick.cb_pick_Print.Enabled = True
		
		tab_main.TabPage_Pack.cb_generate_pack.Enabled = True
		tab_main.TabPage_Pack.cb_insert_pack.Enabled = True
		tab_main.TabPage_Pack.cb_delete_pack.Enabled = True
		tab_main.TabPage_Pack.cb_pack_copy.Enabled = True
		
		idw_master.Object.DataWindow.ReadOnly="No"
		idw_Detail.Object.DataWindow.ReadOnly="No"
		idw_Pick.Object.DataWindow.ReadOnly="No"
		
		//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -START
		If idw_detail.find("ord_status = 'V'",1,idw_detail.RowCount()) > 0 Then
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = True
		Else
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = False /* 05/13 - PCONKL */
		END IF//19-Aug-2013 :Madhu - Enable update delivery dt, if it is voided -END
		
	Case 'C' /*Complete*/
		
		tab_main.Tabpage_Order_Detail.Enabled = True
		tab_main.Tabpage_Pick.Enabled = True
		tab_main.Tabpage_Pack.Enabled = True
		
		wf_enable_trax() /*enable or disable trax page depening on warehouse setting*/
		
		
		tab_main.tabPage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_generate.Enabled = False
		tab_main.tabpage_main.cb_cust.Enabled = False
		
		tab_main.TabPage_Order_detail.cb_remove_orders.Enabled = False
				
		tab_main.TabPage_Pick.cb_generate_pick.Enabled = False
		tab_main.TabPage_Pick.cb_insert_pick.Enabled = False
		tab_main.TabPage_Pick.cb_delete_pick.Enabled = False
		tab_main.TabPage_Pick.cb_pick_copy.Enabled = False
		
		tab_main.TabPage_Pack.cb_generate_pack.Enabled = False
		tab_main.TabPage_Pack.cb_insert_pack.Enabled = False
		tab_main.TabPage_Pack.cb_delete_pack.Enabled = False
		tab_main.TabPage_Pack.cb_pack_copy.Enabled = False
		
		im_menu.m_file.m_save.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		
		idw_master.Object.DataWindow.ReadOnly="Yes"
		idw_Detail.Object.DataWindow.ReadOnly="Yes"
		idw_Pick.Object.DataWindow.ReadOnly="Yes"
		idw_Pack.Object.DataWindow.ReadOnly="Yes"
		
		/* 05/13 - PCONKL */
		If idw_detail.find("ord_status <> 'C'",1,idw_detail.RowCount()) > 0 Then
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = False
		Else
			tab_main.Tabpage_Order_Detail.cb_update_delivery_dt.Enabled = True 
		End If
		
End Choose

If idw_detail.RowCount() > 0 Then
	tab_main.Tabpage_order_detail.Enabled = True
	tab_main.Tabpage_Pick.Enabled = True
	tab_main.Tabpage_Pack.Enabled = True
//	im_menu.m_file.M_clear.Enabled = False
Else
	im_menu.m_file.M_clear.Enabled = True
	tab_main.TabPage_Pick.cb_generate_pick.Enabled = False
	tab_main.TabPage_Pick.cb_insert_pick.Enabled = False
	tab_main.TabPage_Pick.cb_delete_pick.Enabled = False
	tab_main.TabPage_Pick.cb_pick_copy.Enabled = False
End If

idw_trax.TriggerEvent('ue_enable')

//hide any unused lottable fields on Picking (lot, po, etc.)
idw_pick.TriggerEvent('ue_hide_unused')

If  idw_detail.RowCount() > 0 Then
	tab_main.tabpage_main.cb_batch.enabled = True
Else
	tab_main.tabpage_main.cb_batch.enabled = False
End If

// 12/14 - PCONKL - Enable/Disable MObile based on warehouse flag
wf_check_status_Mobile()


Return 0
end function

public function integer wf_validate ();Long		llRowPos,	&
			llrowCount,	&
			llFindRow,	&
			llPackedCount,	&
			llNewRow,		&
			llPick,			&
			llPack,ll_cnt,i,ldord_qty,ldpick_qty
		
String	lsFind

Datastore	lds_compare

If idw_master.AcceptText() < 0 Then Return -1
If Idw_Pick.AcceptText() < 0 Then Return -1
If Idw_Pack.AcceptText() < 0 Then Return -1

//If we're deleting the batch, thre is no need to validate
If ibDEleteBatch Then Return 0

//If the batch criteria has been changed (and we have not asked to regenerate the batch), we will not allow the user to change until they re-generate the batch
If ibbatchCriteriaChanged and (not ibGenerateBatch) Then
	Messagebox(is_title,'The batch Criteria has been changed since the Batch was last Generated.~r~rThis batch can not be saved unless you Re_Generate the Batch!',StopSign!)
	Return -1
End If /*batch Criteria changed */

//Validate Pick List Fields
w_main.SetMicroHelp('Validating Pick Details...')

llRowCount = idw_Pick.RowCount()



// 02/05 - PCONKL - Allow for user to delete rows with 0 Qty
If idw_pick.Find("quantity = 0",1,idw_pick.RowCount()) > 0 Then
	If Messagebox(is_title,'Do you want to delete the non-pickable rows (qty = 0)?',Question!,yesNo!,2) = 1 Then
		idw_pick.SetRedraw(false)
		for llRowPos = llRowCount to 1 Step -1
			If idw_Pick.GetITemNumber(llRowPos,'quantity') = 0 Then
				idw_pick.DeleteRow(llRowPos)
			End If
		Next
		idw_pick.SetRedraw(True)
	End If
End IF

//If llPackedCount > 0 Then
	//Datastore for validating Pick/Pack totals are equal
	lds_compare = Create Datastore
	lds_compare.Dataobject = 'd_do_compare' 
	lds_compare.SetTransObject(SQLCA)
//End If

llRowCount = idw_Pick.RowCount()
llPackedCount = idw_Pack.RowCOunt()

For llRowPos = 1 to llRowCount
	
//	If idw_pick.GetITemstatus(llRowPos,0,Primary!) = NotModified! Then Continue
	
	If idw_pick.GetItemString(llRowPos,'component_ind') = '*' Then Continue
	
	//Location is Required
	If isnull(idw_pick.GetITemString(llRowPOs,'l_code')) or idw_pick.GetITemString(llRowPOs,'l_code') = '' Then
		messageBox(is_title,'Location is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('l_code')
		Return -1
	End If
	
	//SKU is Required
	If isnull(idw_pick.GetITemString(llRowPOs,'SKU')) or idw_pick.GetITemString(llRowPOs,'SKU') = '' Then
		messageBox(is_title,'SKU is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('SKU')
		Return -1
	End If
	
	//QTY Must be > 0
	If isnull(idw_pick.GetITemNumber(llRowPOs,'Quantity')) or idw_pick.GetITemNumber(llRowPOs,'Quantity') = 0 Then
		messageBox(is_title,'QTY Must be > 0.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('quantity')
		Return -1
	End If
	
	//Supplier is Required
	If isnull(idw_pick.GetITemString(llRowPOs,'Supp_code')) or idw_pick.GetITemString(llRowPOs,'Supp_code') = '' Then
		messageBox(is_title,'Supplier is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('Supp_code')
		Return -1
	End If
	
	//COO is Required
	If isnull(idw_pick.GetITemString(llRowPOs,'country_of_origin')) or idw_pick.GetITemString(llRowPOs,'country_of_origin') = '' Then
		messageBox(is_title,'Country of Origin is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('country_of_origin')
		Return -1
	End If
	
	//Order # is Required
	If isnull(idw_pick.GetITemString(llRowPOs,'Invoice_NO')) or idw_pick.GetITemString(llRowPOs,'Invoice_NO') = '' Then
		messageBox(is_title,'Order Number is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('Invoice_NO')
		Return -1
	End If
	
	//Line Item Number is Required
	If isnull(idw_pick.GetITemNumber(llRowPOs,'line_item_No')) or idw_pick.GetITemNumber(llRowPOs,'line_item_No') = 0 Then
		messageBox(is_title,'Line Item Number is Required.')
		tab_main.SelectTab(3)
		idw_Pick.SetFocus()
		idw_Pick.SetRow(llRowPos)
		idw_Pick.setColumn('line_item_No')
		Return -1
	End If
	
	//Pick Row must be present on Order Detail 
	// 02/06 - Don't validate component children
	// 03/29/2012 - GXMOR - Added Component Ind W as a child since the pick record is set depending on whether a component is free range or pre kitted.
	If idw_pick.GetItemString(llRowPOs,'component_ind') = '*'  or idw_pick.GetItemString(llRowPOs,'component_ind') = 'B'  or idw_pick.GetItemString(llRowPOs,'component_ind') = 'W'  Then
	Else
		
		lsFind = "Upper(sku) = '" + Upper(idw_Pick.GetITemString(llRowPos,'SKU')) + "'"
		lsFind += " and Upper(Invoice_no) = '" + Upper(idw_Pick.GetITemString(llRowPos,'Invoice_no')) + "'"
		lsFind += " and Line_Item_no = " + String(idw_Pick.GetITemNumber(llRowPos,'Line_Item_No'))
		llFindRow =  idw_DEtail.Find(lsFind,1,idw_Detail.RowCount())
	
		// 07/05 - PCONKL - If picking Alternate SKU, validate against Alternate SKU on Detail instead of Primary SKU
		If llFindRow <= 0 and g.is_allow_alt_sku_Pick = 'Y' Then
		
			lsFind = "Upper(alternate_sku) = '" + Upper(idw_Pick.GetITemString(llRowPos,'SKU')) + "'"
			lsFind += " and Upper(Invoice_no) = '" + Upper(idw_Pick.GetITemString(llRowPos,'Invoice_no')) + "'"
			lsFind += " and Line_Item_no = " + String(idw_Pick.GetITemNumber(llRowPos,'Line_Item_No'))
			llFindRow =  idw_DEtail.Find(lsFind,1,idw_Detail.RowCount())
		
		End If
	
		If llFindRow <= 0 Then
			messageBox(is_title,'Pick Detail is Not found in Order Details.')
			tab_main.SelectTab(3)
			idw_Pick.SetFocus()
			idw_Pick.SetRow(llRowPos)
			idw_Pick.setColumn('SKU')
			Return -1
		End If /*Order Detail Not Found*/
		
	End If /*Component*/
	
	//we want to sum up Picked qty to compare to Packed
//	If llPackedCount > 0 Then
	// 04/05/2012 - TAM - Added Component Ind as a check between Pick and Pack.  We want to skip the Component rows from the compare.
	If idw_pick.GetItemString(llRowPOs,'component_ind') = '*'  or idw_pick.GetItemString(llRowPOs,'component_ind') = 'B'  or idw_pick.GetItemString(llRowPOs,'component_ind') = 'W'  Then
	Else
		llFindRow = lds_compare.find(lsFind,1,lds_compare.rowcount())
		if llFindRow < 1 then
			llNewRow = lds_compare.insertrow(0)
			lds_compare.setitem(llNewRow,'sku',idw_Pick.GetITemString(llRowPos,'SKU'))
			lds_compare.setitem(llNewRow,'supp_code',idw_Pick.GetITemString(llRowPos,'Supp_code'))
			lds_compare.setitem(llNewRow,'invoice_no',idw_Pick.GetITemString(llRowPos,'Invoice_no'))
			lds_compare.setitem(llNewRow,'pick',idw_pick.getitemnumber(llRowPos,'quantity'))
			lds_compare.setitem(llNewRow,'line_item_no',idw_Pick.GetITemNumber(llRowPos,'Line_Item_No'))
		else
			lds_compare.setitem(llFindRow,'pick',lds_compare.getitemnumber(llFindRow,'pick') + idw_pick.getitemnumber(llRowPos,'quantity'))
		end if
	End If
//	End If /*Packing list exists*/
	
Next /* Next Picking Row */

//Validate Packing Rows
w_main.SetMicroHelp('Validating Pack Details...')

//llPackedCount = idw_Pack.RowCount()
For llRowPos = 1 to llPackedCount
	
	//If idw_pack.GetITemstatus(llRowPos,0,Primary!) = NotModified! Then Continue
	
	//SKU is Required
	If isnull(idw_pack.GetITemString(llRowPOs,'SKU')) or idw_pack.GetITemString(llRowPOs,'SKU') = '' Then
		messageBox(is_title,'SKU is Required.')
		tab_main.SelectTab(4)
		idw_Pack.SetFocus()
		idw_Pack.SetRow(llRowPos)
		idw_Pack.setColumn('SKU')
		Return -1
	End If
	
	//QTY Must be > 0
	If isnull(idw_pack.GetITemNumber(llRowPOs,'Quantity')) or idw_pack.GetITemNumber(llRowPOs,'Quantity') = 0 Then
		messageBox(is_title,'QTY Must be > 0.')
		tab_main.SelectTab(4)
		idw_Pack.SetFocus()
		idw_Pack.SetRow(llRowPos)
		idw_Pack.setColumn('quantity')
		Return -1
	End If
	
	//Supplier is Required
	If isnull(idw_pack.GetITemString(llRowPOs,'Supp_code')) or idw_pack.GetITemString(llRowPOs,'Supp_code') = '' Then
		messageBox(is_title,'Supplier is Required.')
		tab_main.SelectTab(4)
		idw_Pack.SetFocus()
		idw_Pack.SetRow(llRowPos)
		idw_Pack.setColumn('Supp_code')
		Return -1
	End If
	
	//Carton Number is Required
	If isnull(idw_pack.GetITemString(llRowPOs,'carton_no')) or idw_pack.GetITemString(llRowPOs,'carton_no') = '' Then
		messageBox(is_title,'Carton Number is Required.')
		tab_main.SelectTab(4)
		idw_Pack.SetFocus()
		idw_Pack.SetRow(llRowPos)
		idw_Pack.setColumn('carton_no')
		Return -1
	End If
	
	//Pack Row must be present on Pick List
	lsFind = "Upper(sku) = '" + Upper(idw_Pack.GetITemString(llRowPos,'SKU')) + "'"
	If Upper(Left(gs_project,4)) <> 'GM_M' Then /*don't include supplier in match for Saltillo/Detroit as we may be picking from an alternate supplier*/
		lsFind += " and Upper(supp_code) = '" + Upper(idw_Pack.GetITemString(llRowPos,'Supp_code')) + "'"
	End If
	lsFind += " and Upper(Invoice_no) = '" + Upper(idw_Pack.GetITemString(llRowPos,'Invoice_no')) + "'"
	lsFind += " and Line_Item_no = " + String(idw_Pack.GetITemNumber(llRowPos,'Line_Item_No'))
	If idw_Pick.Find(lsFind,1,idw_Pick.RowCount()) <= 0 Then
		messageBox(is_title,'Pack Detail is Not found in Pick List.')
		tab_main.SelectTab(4)
		idw_Pack.SetFocus()
		idw_Pack.SetRow(llRowPos)
		idw_Pack.setColumn('SKU')
		Return -1
	End If /*Pick Detail Not Found*/
	
	//Pack Qty must equal Picke Qty
	llFindRow = lds_compare.find(lsFind,1,lds_compare.rowcount())
	if llFindRow < 1 then
		llNewRow = lds_compare.insertrow(0)
		lds_compare.setitem(llNewRow,'sku',idw_Pack.GetITemString(llRowPos,'SKU'))
		lds_compare.setitem(llNewRow,'supp_code',idw_Pack.GetITemString(llRowPos,'Supp_code'))
		lds_compare.setitem(llNewRow,'Invoice_no',idw_Pack.GetITemString(llRowPos,'Invoice_no'))
		lds_compare.setitem(llNewRow,'pack',idw_pack.getitemnumber(llRowPos,'quantity'))
		lds_compare.setitem(llNewRow,'line_item_no',idw_Pack.GetITemNumber(llRowPos,'Line_Item_No'))
	else
		If isnull(lds_compare.getitemnumber(llFindRow,'pack')) or lds_compare.getitemnumber(llFindRow,'pack') = 0 Then
			lds_compare.setitem(llFindRow,'pack',idw_pack.getitemnumber(llRowPos,'quantity'))
		Else
			lds_compare.setitem(llFindRow,'pack',lds_compare.getitemnumber(llFindRow,'pack') + idw_pack.getitemnumber(llRowPos,'quantity'))
		End If
	end if
	
Next /*Packing Row*/

If idw_pick.RowCount() > 0 and idw_Pack.RowCount() > 0 Then
	//If Packed Qty <> Picked Qty, warn user
	For llRowPos = 1 to lds_compare.rowcount()
		llPick = lds_compare.getitemnumber(llRowPos,'pick')
		llPack = lds_compare.getitemnumber(llRowPos,'pack')
		if (lds_compare.getitemnumber(llRowPos,'pack') <> lds_compare.getitemnumber(llRowPos,'pick')) or &
			isNull(lds_compare.getitemnumber(llRowPos,'pick')) or isNull(lds_compare.getitemnumber(llRowPos,'pack')) then
				MessageBox(is_title, "Packing Quantity is not Equal to that of picking, please check!", StopSign!)	
				tab_main.SelectTab(4) 
				lsFind = "Upper(sku) = '" + Upper(lds_compare.GetITemString(llRowPos,'SKU')) + "'"
				lsFind += " and Upper(supp_code) = '" + Upper(lds_compare.GetITemString(llRowPos,'Supp_code')) + "'"
				lsFind += " and Upper(Invoice_no) = '" + Upper(lds_compare.GetITemString(llRowPos,'Invoice_no')) + "'"
				llFindrow = idw_pack.find(lsFind, 1, idw_pack.RowCount())
				if llFindrow > 0 then
					f_setfocus(idw_pack, llFindrow, "quantity")
				end if	
				Return -1
		end if
	next
End If
//SARUN04July2013 : Check project configuration for underpick and overpick like in do saving /confirmation and batch confirmation : Start 
ll_cnt = idw_detail.RowCount()
For i = 1 to ll_cnt 

	ldord_qty = idw_detail.getitemnumber(i,'req_qty')
	ldpick_qty = idw_detail.getitemnumber(i,'Alloc_qty')
	
	if ldord_qty < ldpick_qty  and ldord_qty > 0 and ldpick_qty > 0 and  (g.is_allow_overPick <> 'Y' AND g.is_allow_overPick <> 'B') Then 
		Messagebox(is_title,"Picked QTY is greater than Ordered Qty~rand over picking is not allowed!",StopSign!)
		tab_main.selecttab(2)
		f_setfocus(idw_detail, i, "sku")
		return -1
	end if
		
	if ldord_qty > ldpick_qty  and ldord_qty > 0  and ldpick_qty > 0 and (g.is_allow_overPick <> 'U' AND g.is_allow_overPick <> 'B') Then 
		Messagebox(is_title,"Picked QTY is Less than Ordered Qty~rand under picking is not allowed!",StopSign!)
		tab_main.selecttab(2)
		f_setfocus(idw_detail, i, "sku")
		return -1
	end if

next
//SARUN04July2013 : Check project configuration for underpick and overpick like in do saving /confirmation and batch confirmation : ENd
w_main.SetMicroHelp('Ready')
Return 0
end function

public function integer wf_enable_trax ();
//Enable or disable trax depending on warehouse code...

String	lsProject, lsWarehouse, lsTraxEnabled
Long 		llRow

If idw_master.RowCount() < 1 Then Return 0

lsProject = idw_master.GetItemString(1,'project_id')
lswarehouse = idw_master.GetItemString(1,'wh_code')

llRow = g.of_project_warehouse(lsProject, lsWarehouse)
If llRow > 0 Then
	lsTraxEnabled = g.ids_project_warehouse.GetITemString(llRow,'trax_enable_ind')
End If

If lsTraxEnabled = 'Y' Then
	tab_main.tabpage_trax.Enabled = True
Else
	tab_main.tabpage_trax.Enabled = False
End If


Return 0
end function

public subroutine setwarehouse (string _value);// setWarehouse( string _value )

if isNull( _value ) then _value = "" 
isWarehouse = _value

end subroutine

public function string getwarehouse ();// string = getwarehouse()
return isWarehouse

end function

public subroutine setaddressdata (string asdono);// setAddressData( string asDono )

// pvh - 02/10/06

long dRow

dRow = idsDeliveryMaster.retrieve( gs_project, asDoNo )
if dRow <= 0 then return
	
istrAddressData.string_arg[1] = idsDeliveryMaster.object.cust_name[ dRow  ]
istrAddressData.string_arg[2] = idsDeliveryMaster.object.address_1[ dRow  ]
istrAddressData.string_arg[3] = idsDeliveryMaster.object.address_2[ dRow  ]
istrAddressData.string_arg[4] = idsDeliveryMaster.object.address_3[ dRow  ]
istrAddressData.string_arg[5] = idsDeliveryMaster.object.address_4[ dRow  ]
istrAddressData.string_arg[6] = idsDeliveryMaster.object.city[ dRow  ]
istrAddressData.string_arg[7] = idsDeliveryMaster.object.state[ dRow  ]
istrAddressData.string_arg[8] = idsDeliveryMaster.object.zip[ dRow  ]
istrAddressData.string_arg[9] = idsDeliveryMaster.object.country[ dRow  ]
istrAddressData.string_arg[10] = idsDeliveryMaster.object.carrier[ dRow  ]
istrAddressData.string_arg[11] = idsDeliveryMaster.object.cust_Code[ dRow  ]

//dts 01/08 Sika wants to actually print Ship_Ref where the Form says 'Ship Ref Nbr'
isShipRef = idsDeliveryMaster.object.ship_ref[dRow]


return


end subroutine

public function str_parms getaddressdata ();// str_parms = getAddressData()

return istrAddressData

end function

public function string getdetailuserfield1 (string asordernumber, string assku, long lineitemnumber);// string = getDetailUserField1( string asOrder, string asSku, Long LIneItemNumber )

string lsFind
long foundit

lsFind = "invoice_no = '" + asOrderNumber + "' and Upper(sku) = '" + Upper(asSku) + "' and line_item_no = " + string( LineItemNumber )

foundit = idw_detail.Find(lsFind,1,idw_detail.RowCount())

if foundit > 0 Then
	return  idw_detail.object.delivery_detail_user_field1[ foundit ]
else
	return ''
end if

end function

public function integer wf_update_content_server ();
long	i, llSerialArrayPos, llNull[], llFindRow, llCount, llFileLength
String	lsNull[], lsPost, lsXMLResponse, lsReturnCode, lsReturnDesc, lsFind, lsCrap
Boolean	lbRefreshSerial
dwitemstatus ldis_status
String  lsXML, lsTempxml, lsSaveFile
Integer	liFileNo, liLoop

//Build XML of Pick list to pass to Websphere - We will pass Deletes and Adds - An update will be both

//Writing XML to a file - appending large amounts of data to varaibale is slow.

//OPen a temp file to hold the XML - 
lsSaveFile = "PickSaveXML-" + String(today(),"yyyymmddss") + ".txt"
liFileNo = FileOpen(lsSaveFile,LineMOde!,Write!,LockReadWrite!,Replace!)

idw_pick.AcceptText()

If f_check_required(is_title, idw_Pick) = -1 Then Return -1

//Build the Deletes first
llCount = idw_pick.deletedcount()
for i = 1 to llCount
		
	// 09/01 PCONKL - No Picking Detail Row if SKU is non-pickable (it was never picked to begin with)
	If idw_pick.getitemstring(i,'sku_pickable_ind',Delete!,True) = 'N' Then Continue
	
	ldis_status = idw_pick.getitemstatus(i,0,Delete!)
	if ldis_status = New! or ldis_status = NewModified! then Continue
	
	//Pass key values in for Delete
	lsXML = "<DOPickRecord>"
	lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
	lsXML += "<DONO>" + idw_Pick.getitemstring(i,'do_no',Delete!,True) + "</DONO>"
	lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No',Delete!,True) ) + "</LineItemNo>"
	lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku',Delete!,True) + "</SKU>"
	lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code',Delete!,True) + "</SupplierCode>"
	lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id',Delete!,True)) + "</OwnerID>"
	//lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type',Delete!,True) + "</InvType>"
	lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity',Delete!,True)) + "</Quantity>"
	//lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin',Delete!,True) + "</COO>"
	
	//Only pass if NOt Default value to keep size of XML down
	If idw_pick.getitemstring(i,'inventory_type',Delete!,True) <> 'N' Then
		lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type',Delete!,True) + "</InvType>"
	End If
	
	If idw_pick.getitemstring(i,'country_of_origin',Delete!,True) <> 'XXX' Then
		lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin',Delete!,True) + "</COO>"
	End If
	
	If idw_pick.getitemstring(i,'serial_no',Delete!,True) <> '-' Then
		lsXML += "<SerialNo>" + idw_pick.getitemstring(i,'serial_no',Delete!,True) + "</SerialNo>"
	End If
	
	If idw_pick.getitemstring(i,'lot_no',Delete!,True) <> '-' Then
		lsXML += "<LotNo>" + idw_pick.getitemstring(i,'lot_no',Delete!,True) + "</LotNo>"
	End If
	
	If idw_pick.getitemstring(i,'po_no',Delete!,True) <> '-' Then
		lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no',Delete!,True) + "</PONO>"
	End If
	
	If idw_pick.getitemstring(i,'po_no2',Delete!,True) <> '-' Then
		lsXML += "<PONO2>" + idw_pick.getitemstring(i,'po_no2',Delete!,True) + "</PONO2>"
	End If
	
	If idw_pick.getitemstring(i,'Container_ID',Delete!,True) <> '-' Then
		lsXML += "<ContainerID>" + idw_pick.getitemstring(i,'Container_ID',Delete!,True) + "</ContainerID>"
	End If
	
	If String(idw_pick.getitemDateTime(i,'Expiration_Date',Delete!,True),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
		lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date',Delete!,True),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
	End If
		
		
	lsXML += "<Location>" + idw_pick.getitemstring(i,'l_code',Delete!,True) + "</Location>"
	
	If idw_pick.getitemstring(i,'Zone_ID',Delete!,True) <> '-' Then
		lsXML += "<ZoneID>" + idw_pick.getitemstring(i,'Zone_ID',Delete!,True) + "</ZoneID>"
	End If
	
	If NOt isnull(idw_pick.getitemnumber(i,'component_no',Delete!,True)) and idw_pick.getitemnumber(i,'component_no',Delete!,True) <> 0 Then
		lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Delete!,True)) + "</ComponentNo>"
	//Else
	//	lsXML += "<ComponentNo>0</ComponentNo>"
	End If
		
//	//Add Serial # Indicator
//	lsXML += "<SerialNumbersExist>"
//	If llFindRow > 0 Then
//		lsXML += "Y"
//	Else
//		lsXML += "N"
//	End If
//	lsXML += "</SerialNumbersExist>"
		
	//Component Indicator -
	If not isnull(idw_pick.getitemstring(i,'component_ind',Delete!,True)) and idw_pick.getitemstring(i,'component_ind',Delete!,True) <> 'N' Then
		lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Delete!,True) + "</ComponentInd>"
	//Else
	//	lsXML +="<ComponentInd></ComponentInd>"
	End If
		
		
	lsXML += "</DOPickRecord>"
	
	//Either write to file if available or Temp Variable if not
	If liFileNo > 0 Then
		FileWrite(liFileNo,lsXML)
	Else
		lsTempXml += lsXML
	End If
		
next /* DEleted Pick Row */

//Updates will build a Delete with the original key values (might have changed) and an Insert for the entire new PIck Record
llCount = idw_pick.rowcount()
For i = 1 to llCount /*For each Pick Row*/
	
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
		
	//Delete for DataModified OR Void
	If ldis_status = DataModified! Then
		
		//Pass key values in for Delete
		lsXML = "<DOPickRecord>"
		lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
		lsXML += "<DONO>" + idw_Pick.getitemstring(i,'do_no',Primary!,True) + "</DONO>"
		lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No',Primary!,True) ) + "</LineItemNo>"
		lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku',Primary!,True) + "</SKU>"
		lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code',Primary!,True) + "</SupplierCode>"
		lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id',Primary!,True)) + "</OwnerID>"
	//	lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type',Primary!,True) + "</InvType>"
		lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity',Primary!,True)) + "</Quantity>"
		//lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin',Primary!,True) + "</COO>"
		
		//Only pass in if not default value
		
		If idw_pick.getitemstring(i,'inventory_type',Primary!,True) <> 'N' Then
			lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type',Primary!,True) + "</InvType>"
		End If
			
		If idw_pick.getitemstring(i,'country_of_origin',Primary!,True)  <> 'XXX' Then
			lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin',Primary!,True) + "</COO>"
		End If
			
		If idw_pick.getitemstring(i,'serial_no',Primary!,True) <> '-' Then
			lsXML += "<SerialNo>" + idw_pick.getitemstring(i,'serial_no',Primary!,True) + "</SerialNo>"
		End If
		
		If idw_pick.getitemstring(i,'lot_no',Primary!,True) <> '-' Then
			lsXML += "<LotNo>" + idw_pick.getitemstring(i,'lot_no',Primary!,True) + "</LotNo>"
		End If
		
		If idw_pick.getitemstring(i,'po_no',Primary!,True) <> '-' Then
			lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no',Primary!,True) + "</PONO>"
		End If
		
		If idw_pick.getitemstring(i,'po_no2',Primary!,True) <> '-' Then
			lsXML += "<PONO2>" + idw_pick.getitemstring(i,'po_no2',Primary!,True) + "</PONO2>"
		End If
				
		If idw_pick.getitemstring(i,'Container_ID',Primary!,True) <> '-' Then		
			lsXML += "<ContainerID>" + idw_pick.getitemstring(i,'Container_ID',Primary!,True) + "</ContainerID>"
		End If
				
		If String(idw_pick.getitemDateTime(i,'Expiration_Date',Primary!,True),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
			lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date',Primary!,True),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
		End If
		
		lsXML += "<Location>" + idw_pick.getitemstring(i,'l_code',Primary!,True) + "</Location>"
		
		If idw_pick.getitemstring(i,'Zone_ID',Primary!,True) <> '-' Then
			lsXML += "<ZoneID>" + idw_pick.getitemstring(i,'Zone_ID',Primary!,True) + "</ZoneID>"
		End If
		
		If NOt isnull(idw_pick.getitemnumber(i,'component_no',Primary!,True)) and idw_pick.getitemnumber(i,'component_no',Primary!,True) <> 0  Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Primary!,True)) + "</ComponentNo>"
		Else
	//		lsXML += "<ComponentNo>0</ComponentNo>"
		End If
		
		If NOt isnull(idw_pick.getitemnumber(i,'batch_pick_id',Primary!,True)) and idw_pick.getitemnumber(i,'batch_pick_id',Primary!,True) <> 0  Then
			lsXML += "<BatchPickID>" + String(idw_pick.getitemnumber(i,'batch_pick_id',Primary!,True)) + "</BatchPickID>"
		Else
		//	lsXML += "<BatchPickID>0</BatchPickID>"
		End If
		
//		//Add Serial # Indicator
//		lsXML += "<SerialNumbersExist>"
//		If llFindRow > 0 Then
//			lsXML += "Y"
//		Else
//			lsXML += "N"
//		End If
//		lsXML += "</SerialNumbersExist>"
		
		//Component Indicator -
		If not isnull(idw_pick.getitemstring(i,'component_ind',Primary!,True)) and idw_pick.getitemstring(i,'component_ind',Primary!,True) <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Primary!,True) + "</ComponentInd>"
	//	Else
	//		lsXML +="<ComponentInd></ComponentInd>"
		End If
		
	
		lsXML += "</DOPickRecord>"
		
		//Either write to file if available or Temp Variable if not
		If liFileNo > 0 Then
			FileWrite(liFileNo,lsXML)
		Else
			lsTempXml += lsXML
		End If
		
	End If /*Modified */
	
	
	//Create a new pick Record with the new (updated) values For New!, NewModified!, MOdified! and Not Void
	If (ldis_status = New! or ldis_status = NewModified! or ldis_status = DataModified!) Then
		
		lsXML = "<DOPickRecord>"
		lsXML += "<UpdateType>N</UpdateType>" /*Update Type is New */
		lsXML += "<DONO>" + idw_Pick.getitemstring(i,'do_no') + "</DONO>"
		lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No') ) + "</LineItemNo>"
		lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku') + "</SKU>"
		lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code') + "</SupplierCode>"
		lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id')) + "</OwnerID>"
		//lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type') + "</InvType>"
		lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity')) + "</Quantity>"
		//lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin') + "</COO>"
		
		//Only pass in if not default value
		
		If idw_pick.getitemstring(i,'inventory_type') <> 'N' Then
			lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type') + "</InvType>"
		End If
		
		If idw_pick.getitemstring(i,'country_of_origin') <> 'XXX' Then
			lsXML += "<COO>" + idw_pick.getitemstring(i,'country_of_origin') + "</COO>"
		End If
		
		If idw_pick.getitemstring(i,'serial_no') <> '-' Then
			lsXML += "<SerialNo>" + idw_pick.getitemstring(i,'serial_no') + "</SerialNo>"
		End If
		
		If idw_pick.getitemstring(i,'lot_no') <> '-' Then
			lsXML += "<LotNo>" + idw_pick.getitemstring(i,'lot_no') + "</LotNo>"
		End If
		
		If idw_pick.getitemstring(i,'po_no') <> '-' Then
			lsXML += "<PONO>" + idw_pick.getitemstring(i,'po_no') + "</PONO>"
		End If
		
		If idw_pick.getitemstring(i,'po_no2') <> '-' Then
			lsXML += "<PONO2>" + idw_pick.getitemstring(i,'po_no2') + "</PONO2>"
		End If
		
		If idw_pick.getitemstring(i,'Container_ID')  <> '-' Then
			lsXML += "<ContainerID>" + idw_pick.getitemstring(i,'Container_ID') + "</ContainerID>"
		End If
		
		If String(idw_pick.getitemDateTime(i,'Expiration_Date'),"yyyy-mm-dd hh:mm:ss") <> '2999-12-31 00:00:00' Then
			lsXML += "<ExpirationDate>" + String(idw_pick.getitemDateTime(i,'Expiration_Date'),"yyyy-mm-dd hh:mm:ss") + ":000</ExpirationDate>"
		End If
		
		lsXML += "<Location>" + idw_pick.getitemstring(i,'l_code') + "</Location>"
		
		If  idw_pick.getitemstring(i,'Zone_ID') <> '-' Then
			lsXML += "<ZoneID>" + idw_pick.getitemstring(i,'Zone_ID') + "</ZoneID>"
		End If
		
		
		If NOt isnull(idw_pick.getitemnumber(i,'component_no')) and idw_pick.getitemnumber(i,'component_no') <> 0 Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no')) + "</ComponentNo>"
		Else
		//	lsXML += "<ComponentNo>0</ComponentNo>"
		End If
				
		//Non key fields...
		If not isnull(idw_pick.getitemstring(i,'component_ind')) and idw_pick.getitemstring(i,'component_ind') <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind') + "</ComponentInd>"
		//Else
		//	lsXML +="<ComponentInd></ComponentInd>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'sku_parent')) and idw_pick.getitemstring(i,'sku_parent') <> idw_pick.getitemstring(i,'sku')Then
			lsXML	+=  "<SkuParent>" + idw_pick.getitemstring(i,'sku_parent') + "</SkuParent>"
		//Else
		//	lsXML +="<SkuParent></SkuParent>"
		End If
		
		If Not isnull(idw_pick.getitemstring(i,'sku_pickable_ind')) and idw_pick.getitemstring(i,'sku_pickable_ind') <> 'Y' Then
			lsXML += "<SkuPickableInd>" + idw_pick.getitemstring(i,'sku_pickable_ind') + "</SkuPickableInd>"
		Else
	//		lsXML += "<SkuPickableInd>Y</SkuPickableInd>"
		End If
		
		If NOt isnull(idw_pick.getitemNumber(i,'cntnr_length')) and idw_pick.getitemNumber(i,'cntnr_length') <> 0 Then
			lsXML += "<CntnrLength>" + String(idw_pick.getitemNumber(i,'cntnr_length')) + "</CntnrLength>"
		Else
	//		lsXML += "<CntnrLength>0</CntnrLength>"
		End If
		
		If Not isnull(idw_pick.getitemNumber(i,'cntnr_width')) and idw_pick.getitemNumber(i,'cntnr_width') <> 0 Then
			lsXML += "<CntnrWidth>" + String(idw_pick.getitemNumber(i,'cntnr_width')) + "</CntnrWidth>"
		Else
	//		lsXML += "<CntnrWidth>0</CntnrWidth>"
		End If
		
		If not isnull(idw_pick.getitemNumber(i,'cntnr_height')) and idw_pick.getitemNumber(i,'cntnr_height') <> 0 Then
			lsXML += "<CntnrHeight>" + String(idw_pick.getitemNumber(i,'cntnr_height')) + "</CntnrHeight>"
		Else
	//		lsXML += "<CntnrHeight>0</CntnrHeight>"
		End If
		
		If not isnull(idw_pick.getitemNumber(i,'cntnr_weight')) and idw_pick.getitemNumber(i,'cntnr_weight') <> 0 Then
			lsXML += "<CntnrWeight>" + String(idw_pick.getitemNumber(i,'cntnr_weight')) + "</CntnrWeight>"
		Else
	//		lsXML += "<CntnrWeight>0</CntnrWeight>"
		End If
		
		If NOt isnull(idw_pick.getitemnumber(i,'batch_pick_id')) and idw_pick.getitemnumber(i,'batch_pick_id') <> 0 Then
			lsXML += "<BatchPickID>" + String(idw_pick.getitemnumber(i,'batch_pick_id')) + "</BatchPickID>"
		Else
		//	lsXML += "<BatchPickID>0</BatchPickID>"
		End If
		
		lsXML += "</DOPickRecord>"
		
		//Either write to file if available or Temp Variable if not
		If liFileNo > 0 Then
			FileWrite(liFileNo,lsXML)
		Else
			lsTempXml += lsXML
		End If
		
	End If /* Modified or new and not void*/
	
Next

If liFileNo > 0 Then FileClose(liFileNo)

//w_main.setMicroHelp("Creating XML from File...")

llFileLength = FileLength(lsSaveFile)
liFileNo = FileOPen(lsSaveFile,StreamMode!,Read!)

If liFileNo > 0 Then
	// Determine how many times to call FileRead
	IF llFileLength > 32765 THEN
		IF Mod(llFileLength, 32765) = 0 THEN
    	   liLoop = llFileLength/32765
   	ELSE
       	liLoop = (llFileLength/32765) + 1
   	END IF
	ELSE
  	 liLoop = 1
	END IF

	lsXML = ""

	For i = 1 to liLoop
		FileRead(liFileNo,lsCrap)
		lsXML += lsCrap
	Next

	FileClose(liFileNo)
	FileDelete(lsSaveFile)
	
Else
	
	lsXML = lsTempXml
	
End If


If isNull(lsXML) Then
	Messagebox(is_title, 'Unable to Save Pick list - required Pick fields missing')
	Return -1
End If

If lsXML = "" Then Return 0

//Add the header and footer
iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsPost = iuoWebsphere.uf_request_header("DOPickAllocRequest", "ProjectID='" + gs_Project + "'")
lsPost += lsXML
lsPost = iuoWebsphere.uf_request_footer(lsPost)

//Messagebox("",lsPost)

w_main.setMicroHelp("Saving Pick List on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsPost)

w_main.setMicroHelp("Pick List Allocation complete")

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to save Pick List: ~r~r" + lsXMLResponse,StopSign!)
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to Save Pick List: ~r~r" + lsReturnDesc,StopSign!)
		Return -1
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox(is_title,lsReturnDesc)
		End If
		
		if lsReturnCode = "-1" Then Return -1
			
End Choose




Return 0

end function

public subroutine wf_set_filter_carton_type ();

String ls_select,ls_filter,ls_wh_code
long i,ll_ret
idw_master.AcceptText()
IF idw_pack.Rowcount() > 0  THEN
	ls_wh_code = idw_master.object.wh_code[1]
	ls_filter = "project_id = '" + gs_project +"' and wh_code = '" +ls_wh_code +"'"
	idwc_carton_type.SetFilter(ls_filter)
	ll_ret = idwc_carton_type.Filter()
	ll_ret=idwc_carton_type.RowCount()
	IF ll_ret = 0 THEN
		ls_filter = "project_id = '*ALL'"
		idwc_carton_type.SetFilter(ls_filter)
		ll_ret=idwc_carton_type.Filter() 
	END IF
END IF	

end subroutine

public function integer uf_enable_first_carton_row (integer airow, string asorder, string ascarton);
//Only first row of a carton should have dims enabled


Long	llRowCount, llRowPos, llFindRow
String	lsReturnFind, lsOldCarton
Decimal	ldGrossWeight
Boolean	lbMultRows

//Get out if not enabled for project
If not g.ibSyncPackCarton Then REturn 0

//If aiRow > 0 then we want to reset cursor to that row
If aiRow > 0 Then
	lsReturnFind = "upper(Invoice_No) = '" + Upper(idw_Pack.getITemString(aiRow,'invoice_no')) + "' and Line_Item_No = " + String(idw_pack.GetITemNumber(aiRow,'line_item_no')) + " and upper(carton_no) = '" + & 
					Upper(asCarton) + "' and Upper(Sku) = '" + Upper(idw_pack.GetITemString(aiRow,'Sku')) + &
					"' and Upper(supp_code) = '" + Upper(idw_pack.GetITemString(aiRow,'supp_Code')) + "'"
End IF

//wf_set_pack_Filter('REMOVE')

idw_pack.Sort()

llRowCount = idw_pack.RowCount()

idw_pack.SetRedraw(False)

For llRowPos = 1 to llRowCount
	
	If llRowPos = 1 Then
		
		//IF the row has an *, we changed the carton number. IT may now be the first row of the carton but we want to take the DIMS from
		// an original row in the carton if they exist
		
		If idw_Pack.GetITemString(1,'c_first_carton_row') = '*' and llRowCount > 1 Then
			
			llFindRow =  idw_pack.Find("Upper(Invoice_No) = '" + Upper(idw_Pack.GetITemString(llRowPos,'invoice_no')) + "' and Upper(Carton_no) = '" + Upper(idw_pack.GetItemString(llRowPos,'carton_no')) + "'",2, llRowCount)
			If llFindRow > 0 Then
				
				//Set values from first found row to idw_pack row (only if different, cut down on IO)...
				If idw_pack.GetITemString(llRowPos,'carton_type') <> idw_pack.GetITemString(llFindRow,'carton_type') or isNull(idw_pack.GetITemString(llRowPos,'carton_type')) Then
					idw_pack.SetItem(llRowPos,'carton_type',idw_pack.GetITemString(llFindRow,'carton_type'))
				End If
			
				If idw_pack.GetITemNumber(llRowPos,'length') <> idw_pack.GetITemNumber(llFindRow,'length') or isNull(idw_pack.GetITemNumber(llRowPos,'length')) Then
					idw_pack.SetItem(llRowPos,'length',idw_pack.GetITemNumber(llFindRow,'length'))
				End If
			
				If idw_pack.GetITemNumber(llRowPos,'width') <> idw_pack.GetITemNumber(llFindRow,'width') or isNull(idw_pack.GetITemNumber(llRowPos,'width')) Then
					idw_pack.SetItem(llRowPos,'width',idw_pack.GetITemNumber(llFindRow,'width'))
				End If
			
				If idw_pack.GetITemNumber(llRowPos,'height') <> idw_pack.GetITemNumber(llFindRow,'height') or isNull(idw_pack.GetITemNumber(llRowPos,'height'))  Then
					idw_pack.SetItem(llRowPos,'height',idw_pack.GetITemNumber(llFindRow,'height'))
				End If
			
				If idw_pack.GetITemNumber(llRowPos,'cbm') <> idw_pack.GetITemNumber(llFindRow,'cbm') or isNull(idw_pack.GetITemNumber(llRowPos,'cbm')) Then
					idw_pack.SetItem(llRowPos,'cbm',idw_pack.GetITemNumber(llFindRow,'cbm'))
				End If
			
				If idw_pack.GetITemNumber(llRowPos,'weight_gross') <> idw_pack.GetITemNumber(llFindRow,'weight_gross') or isNull(idw_pack.GetITemNumber(llRowPos,'weight_gross')) Then
					idw_pack.SetItem(llRowPos,'weight_gross',idw_pack.GetITemNumber(llFindRow,'weight_gross'))
				End If
			
				If idw_pack.GetITemString(llRowPos,'shipper_tracking_id') <> idw_pack.GetITemString(llFindRow,'shipper_tracking_id') or isNull(idw_pack.GetITemString(llRowPos,'shipper_tracking_id')) Then
					idw_pack.SetItem(llRowPos,'shipper_tracking_id',idw_pack.GetITemString(llFindRow,'shipper_tracking_id'))
				End If
				
				If idw_pack.GetITemString(llRowPos,'user_field1') <> idw_pack.GetITemString(llFindRow,'user_field1') or isNull(idw_pack.GetITemString(llRowPos,'user_field1')) Then
					idw_pack.SetItem(llRowPos,'user_field1',idw_pack.GetITemString(llFindRow,'user_field1'))
				End If
				
				If idw_pack.GetITemString(llRowPos,'user_field2') <> idw_pack.GetITemString(llFindRow,'user_field2') or isNull(idw_pack.GetITemString(llRowPos,'user_field2')) Then
					idw_pack.SetItem(llRowPos,'user_field2',idw_pack.GetITemString(llFindRow,'user_field2'))
				End If
				
			End If
			
		End If
		
		idw_pack.SetITem(1,'c_first_carton_row','Y')
		
				
	Else
		
		llFindRow = idw_pack.Find("Upper(Invoice_No) = '" + Upper(idw_Pack.GetITemString(llRowPos,'invoice_no')) + "' and Upper(Carton_no) = '" + Upper(idw_pack.GetItemString(llRowPos,'carton_no')) + "'",1, (llRowPos - 1))
		If llFindRow > 0 Then
			
			idw_pack.SetITem(lLRowPos,'c_first_carton_row','N')
			
			//Set values from first found row to idw_pack row (only if different, cut down on IO)...
			If idw_pack.GetITemString(llRowPos,'carton_type') <> idw_pack.GetITemString(llFindRow,'carton_type') or isNull(idw_pack.GetITemString(llRowPos,'carton_type')) Then 				
				idw_pack.SetItem(llRowPos,'carton_type',idw_pack.GetITemString(llFindRow,'carton_type'))
			End If
			
			If idw_pack.GetITemNumber(llRowPos,'length') <> idw_pack.GetITemNumber(llFindRow,'length') or isnull(idw_pack.GetITemNumber(llRowPos,'length')) Then
				idw_pack.SetItem(llRowPos,'length',idw_pack.GetITemNumber(llFindRow,'length'))
			End If
			
			If idw_pack.GetITemNumber(llRowPos,'width') <> idw_pack.GetITemNumber(llFindRow,'width') or isnull(idw_pack.GetITemNumber(llRowPos,'width')) Then
				idw_pack.SetItem(llRowPos,'width',idw_pack.GetITemNumber(llFindRow,'width'))
			End If
			
			If idw_pack.GetITemNumber(llRowPos,'height') <> idw_pack.GetITemNumber(llFindRow,'height') or isnull(idw_pack.GetITemNumber(llRowPos,'height')) Then
				idw_pack.SetItem(llRowPos,'height',idw_pack.GetITemNumber(llFindRow,'height'))
			End If
			
			If idw_pack.GetITemNumber(llRowPos,'cbm') <> idw_pack.GetITemNumber(llFindRow,'cbm') or isnull(idw_pack.GetITemNumber(llRowPos,'cbm')) Then
				idw_pack.SetItem(llRowPos,'cbm',idw_pack.GetITemNumber(llFindRow,'cbm'))
			End If
			
			If idw_pack.GetITemNumber(llRowPos,'weight_gross') <> idw_pack.GetITemNumber(llFindRow,'weight_gross') or isnull(idw_pack.GetITemNumber(llRowPos,'weight_gross')) Then
				idw_pack.SetItem(llRowPos,'weight_gross',idw_pack.GetITemNumber(llFindRow,'weight_gross'))
			End If
			
			If idw_pack.GetITemString(llRowPos,'shipper_tracking_id') <> idw_pack.GetITemString(llFindRow,'shipper_tracking_id') or isnull(idw_pack.GetITemString(llRowPos,'shipper_tracking_id')) Then
				idw_pack.SetItem(llRowPos,'shipper_tracking_id',idw_pack.GetITemString(llFindRow,'shipper_tracking_id'))
			End If
			
			
			
		Else /*first row for carton*/
			
			//IF set to an *, the carton number is being changed. It may now be the first row but we want to take the DIMS from a previous row in the carton
			If idw_Pack.GetITemString(llRowPos,'c_first_carton_row') = '*' and llRowPos < llRowCount Then
			
				llFindRow =  idw_pack.Find("Upper(Invoice_No) = '" + Upper(idw_Pack.GetITemString(llRowPos,'invoice_no')) + "' and Upper(Carton_no) = '"+ Upper(idw_pack.GetItemString(llRowPos,'carton_no')) + "'",(llRowPos + 1), llRowCount)
				If llFindRow > 0 Then
				
					If idw_pack.GetITemString(llRowPos,'carton_type') <> idw_pack.GetITemString(llFindRow,'carton_type') or isNull(idw_pack.GetITemString(llRowPos,'carton_type')) Then
						idw_pack.SetItem(llRowPos,'carton_type',idw_pack.GetITemString(llFindRow,'carton_type'))
					End If
			
					If idw_pack.GetITemNumber(llRowPos,'length') <> idw_pack.GetITemNumber(llFindRow,'length') or isnull(idw_pack.GetITemNumber(llRowPos,'length')) Then
						idw_pack.SetItem(llRowPos,'length',idw_pack.GetITemNumber(llFindRow,'length'))
					End If
			
					If idw_pack.GetITemNumber(llRowPos,'width') <> idw_pack.GetITemNumber(llFindRow,'width') or isNull(idw_pack.GetITemNumber(llRowPos,'width')) Then
						idw_pack.SetItem(llRowPos,'width',idw_pack.GetITemNumber(llFindRow,'width'))
					End If
			
					If idw_pack.GetITemNumber(llRowPos,'height') <> idw_pack.GetITemNumber(llFindRow,'height') or isNull(idw_pack.GetITemNumber(llRowPos,'height')) Then
						idw_pack.SetItem(llRowPos,'height',idw_pack.GetITemNumber(llFindRow,'height'))
					End If
			
					If idw_pack.GetITemNumber(llRowPos,'cbm') <> idw_pack.GetITemNumber(llFindRow,'cbm') or isNull(idw_pack.GetITemNumber(llRowPos,'cbm')) Then
						idw_pack.SetItem(llRowPos,'cbm',idw_pack.GetITemNumber(llFindRow,'cbm'))
					End If
			
					If idw_pack.GetITemNumber(llRowPos,'weight_gross') <> idw_pack.GetITemNumber(llFindRow,'weight_gross') or isNull(idw_pack.GetITemNumber(llRowPos,'weight_gross')) Then
						idw_pack.SetItem(llRowPos,'weight_gross',idw_pack.GetITemNumber(llFindRow,'weight_gross'))
					End If
			
					If idw_pack.GetITemString(llRowPos,'shipper_tracking_id') <> idw_pack.GetITemString(llFindRow,'shipper_tracking_id') or isNull(idw_pack.GetITemString(llRowPos,'shipper_tracking_id')) Then
						idw_pack.SetItem(llRowPos,'shipper_tracking_id',idw_pack.GetITemString(llFindRow,'shipper_tracking_id'))
					End If
					
					If idw_pack.GetITemString(llRowPos,'user_field1') <> idw_pack.GetITemString(llFindRow,'user_field1') or isNull(idw_pack.GetITemString(llRowPos,'user_field1')) Then
						idw_pack.SetItem(llRowPos,'user_field1',idw_pack.GetITemString(llFindRow,'user_field1'))
					End If
					
					If idw_pack.GetITemString(llRowPos,'user_field2') <> idw_pack.GetITemString(llFindRow,'user_field2') or isNull(idw_pack.GetITemString(llRowPos,'user_field2')) Then
						idw_pack.SetItem(llRowPos,'user_field2',idw_pack.GetITemString(llFindRow,'user_field2'))
					End If
				
				End If
			
			End If
			
			idw_pack.SetITem(lLRowPos,'c_first_carton_row','Y')
			
			
			
		End If
	
	End If
	
Next

//Recalculate the gross weight for the combined (new) carton...
If asCarton > "" Then
	
	ldGrossweight = 0
	lbMultRows = False
	
	//First pass - Calculate 
	llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(asCarton) + "'",1, llRowCount)
	Do While lLFindRow > 0
	
		If idw_pack.GetITemNumber(llFindRow,'weight_net') > 0 and idw_pack.GetITemNumber(llFindRow,'quantity') > 0 Then
			ldGrossWeight += (idw_pack.GetITemNumber(llFindRow,'weight_net') * idw_pack.GetITemNumber(llFindRow,'quantity') )
		End If
		
		llFindRow ++
		If llFindRow > llRowCount Then
			llFindRow = 0
		Else
			llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" +  Upper(asCarton) + "'",llFindRow, llRowCount)
		End If
		
		If llFindRow > 0 Then lbMultRows = True /*more than 1 packing row updated*/
	
	Loop
	
	//Second Pass - Update (only if more than 1 row for carton - don't recalc if simply changing carton number for a single line)
//	If lbMultRows Then
		
		llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(asCarton) + "'",1, llRowCount)
		Do While lLFindRow > 0
	
			idw_pack.SetITem(llFindRow,'weight_gross',ldGrossWeight)
		
			llFindRow ++
			If llFindRow > llRowCount Then
				llFindRow = 0
			Else
				llFindRow = idw_Pack.Find("Upper(Invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(asCarton) + "'",llFindRow, llRowCount)
			End If
	
		Loop
		
//	End If /* multiple pack rows */
	
	//We also need to recalculate for the old carton 
	ldGrossweight = 0
	lbMultRows = False
	
	lsOldCarton = idw_pack.GetITemString(aiRow,'carton_no',primary!,True)
	If lsOldCarton > "" and lsOldcarton <> asCarton Then
	
		//First pass - Calculate 
		llFindRow = idw_Pack.Find("Upper(invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(lsOldCarton) + "'",1, llRowCount)
		Do While lLFindRow > 0
	
			If idw_pack.GetITemNumber(llFindRow,'weight_net') > 0 and idw_pack.GetITemNumber(llFindRow,'quantity') > 0 Then
				ldGrossWeight += (idw_pack.GetITemNumber(llFindRow,'weight_net') * idw_pack.GetITemNumber(llFindRow,'quantity') )
			End If
		
			llFindRow ++
			If llFindRow > llRowCount Then
				llFindRow = 0
			Else
				llFindRow = idw_Pack.Find("Upper(invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(lsOldCarton) + "'",llFindRow, llRowCount)
			End If
		
			If llFindRow > 0 Then lbMultRows = True /*more than 1 packing row updated*/
	
		Loop
	
		//Second Pass - Update (only if more than 1 row for carton - don't recalc if simply changing carton number for a single line)
//		If lbMultRows Then
		
			llFindRow = idw_Pack.Find("Upper(invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '" + Upper(lsOldCarton) + "'",1, llRowCount)
			Do While lLFindRow > 0
	
				idw_pack.SetITem(llFindRow,'weight_gross',ldGrossWeight)
		
				llFindRow ++
				If llFindRow > llRowCount Then
					llFindRow = 0
				Else
					llFindRow = idw_Pack.Find("Upper(invoice_no) = '" + Upper(asOrder) + "' and Upper(carton_no) = '"+ Upper(lsOldCarton) + "'",llFindRow, llRowCount)
				End If
	
			Loop
			
	//	End If /* multiple pack rows */
	
	End If /*old carton different */
	
End If


//wf_set_pack_Filter('SET')
idw_pack.SetRedraw(True)

idw_pack.Sort()
idw_pack.GroupCalc()

//Return to original row
If aiRow > 0 Then
	llFindRow = idw_Pack.Find(lsREturnFind,1,idw_Pack.RowCount())
	
End IF
	

Return llFindRow
end function

public function integer uf_update_carton_rows (integer airow, string ascolumn, decimal advalue);
//Update a given column for all rows of a carton with the given row/column

String	lsCarton, lsOrder
Long	llFindRow

//Get out if not enabled for project
If not g.ibSyncPackCarton Then REturn 0

If aiRow >= idw_pack.RowCount() Then Return 0

lsCarton = idw_pack.GEtItemString(aiRow,'carton_no')
lsOrder = idw_pack.GEtItemString(aiRow,'Invoice_No')

llFindRow = idw_pack.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "' and Upper(carton_no) = '" + Upper(lsCarton) + "'",aiRow + 1,idw_pack.RowCount())
Do WHile llFindRow > 0
	
	idw_pack.SetItem(llFindRow,asColumn,adValue)
	
	//Update CBM assuming one of DIMS has Changed
	idw_pack.SetITem(llFindRow,'cbm',idw_pack.GetItemNumber(llFindRow,"height")*idw_pack.GetItemNumber(llFindRow,"width")*idw_pack.GetITemNumber(llFindRow,"length"))
		
	llFindRow ++
	If llFindRow > idw_pack.RowCOunt() Then
		Exit
	Else
		llFindRow = idw_pack.Find("Upper(invoice_no) = '" + Upper(lsOrder) + "' and Upper(carton_no) = '" + Upper(lsCarton) + "'",llFindRow ,idw_pack.RowCount())
	End If
	
Loop

Return 0
end function

public function integer uf_get_order_data ();/*************************************************************/
/* Get order data for all batches requested and put in datastore 							*/
/* Validate that all welcome letters and Trax labels have been printed					*/
/* Validate that all serial numbers for orders needing them at outbound are present */
/* If validation succeeds: Return number of rows 												*/
/* -1 = Query fails																						*/
/* -2 = Welcome letters or Trax labels not printed											*/
/* -3 = Serial detail records missing when required											*/
/* -4 = Both printing and serial detail records failed											*/
/*************************************************************/

String sql_syntax, errors, ls_DONO, ls_batches, ls_welcome, ls_label, ls_serialized_ind
Integer li_RowCount, li_Return, li_Print_Ind, li_Serial_Ind, li_RowPos, li_batch
Long ll_OrderQty

li_RowCount = UpperBound(il_BatchPickIDs[])
li_Return = 0

for li_RowPos = 1 to li_RowCount
	ls_batches += String(il_BatchPickIDs[li_RowPos]) + ","
next
ls_batches = left(ls_batches,len(ls_batches) - 1)		//Cut off last comma

//Create the datastores dynamically (no physical datastore object)
/* 4/26/2011 * GXMOR * Added distinct to syntax for multiple SKUs in ItemMaster */
IdsOrderData = Create datastore
sql_syntax = "select distinct dm.project_id,dm.do_no,dm.invoice_no,im.serialized_ind," + &
					"dp.quantity," + &
					"dm.batch_pick_id,dm.user_field2,dp.trax_ship_ref_nbr " + &
					"from delivery_master dm, delivery_packing dp, item_master im " + &
					"where dm.project_id = 'Comcast' and im.project_id = 'Comcast' "+ &
					"and dp.do_no = dm.do_no and im.sku = dp.sku " + &
					"and dm.batch_pick_id in (" + ls_batches + ")"
					
	IdsOrderData.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", Errors))
	IF Len(Errors) > 0 THEN
		 li_Return = -1
	ELSE
		IdsOrderData.SetTransObject(SQLCA)
		li_RowCount = IdsOrderData.Retrieve()
		
		li_Return = li_RowCount
		for li_RowPos = 1 to li_RowCount
			// Check for welcome letters and Trax labels printed
			ls_welcome = IdsOrderData.GetItemString(li_RowPos,"user_field2")
			ls_label = IdsOrderData.GetItemString(li_RowPos,"trax_ship_ref_nbr")
			li_batch = IdsOrderData.GetItemNumber(li_RowPos,"batch_pick_id")
			if ls_welcome = '' or isnull(ls_welcome) or ls_label = '' or isnull(ls_label) then
				li_Print_Ind = -2
			end if
			// Check for serial detail data
			ls_DONO = IdsOrderData.GetItemString(li_RowPos,"do_no")
			ll_OrderQty = IdsOrderData.GetItemNumber(li_RowPos,"quantity")
			ls_serialized_ind = IdsOrderData.GetItemString(li_RowPos,"serialized_ind")
			if (ls_serialized_ind = "O" or ls_serialized_ind = "B") Then
				If ll_OrderQty = uf_get_serial_detail_quantity(ls_DONO) Then
					IdsOrderData.SetItem(li_RowPos,"serialized_ind","Y")	// Has serial data
				Else
					IdsOrderData.SetItem(li_RowPos,"serialized_ind","N")	// Missing serial data
					li_Serial_Ind = -3
				End if
			Else
				IdsOrderData.SetItem(li_RowPos,"serialized_ind","X")		// Does not need serial data
			End if
		next		
	END IF
	
If li_Print_Ind = -2 Then
	If li_Serial_Ind = -3 Then
		li_Return = -4		// Both printing & serial data failed
	Else
		li_Return = -2		// Only printing failed
	End if
Elseif li_Serial_Ind = -3 Then
	li_Return = -3			// Only serial data failed
End if

return li_Return


end function

public function integer uf_create_batch_transactions (integer asbatchpickid, datetime asdtgmttoday);/* Create batch transaction... case statements for each project */
int li_Return, li_RowPos, li_RowCount
string lsDONo

li_Return = 0

IdsOrderData.SetFilter("batch_pick_id="+string(asBatchPickID))
IdsOrderData.Filter()

li_RowCount = IdsOrderData.RowCount()

//messagebox("Filtered Order Data","BatchPickID:"+string(asBatchPickID)+" orders:"+string(li_RowCount))

Choose Case upper(gs_project)
	case 'AMS-MUSER'
		/* waiting to Implement this on Server except for AMS-muser */
	case 'COMCAST'
		for li_RowPos = 1 to li_RowCount
			lsDONO = IdsOrderData.GetItemString(li_RowPos,"do_no")
				Execute Immediate "Begin Transaction" using SQLCA; 
					Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
							Values(:gs_Project, 'GI', :lsDONO,'N', :asdtGMTToday, '');
				Execute Immediate "COMMIT" using SQLCA;
			
		next
	case else
End Choose

IdsOrderData.SetFilter("")
IdsOrderData.Filter()

return li_Return
end function

public function long uf_get_serial_detail_quantity (string asdono);
Long ll_dbQty, ll_Return

ll_Return = 0
	/*Execute Immediate "Begin Transaction" using SQLCA; */

	Select Count(*) into :ll_dbQty 
	from delivery_serial_detail ds
	join Delivery_picking_detail dp on dp.id_no = ds.id_no
	and do_no = :asDONO; 
	
	If sqlca.sqlcode >=0 Then
		ll_Return = ll_dbQty
	Else 
		ll_Return = sqlca.sqlcode
	End if
		
return ll_Return
end function

public function integer wf_load_trax_printer_list ();

String	lsWarehouse, sql_syntax, Errors
DAtaStore ldsPrinters
Long	llRowCount, llRowPos

lsWarehouse = idw_MAster.GEtITemString(1,'wh_code')

If lsWarehouse <> isTraxWarehouse Then
	
	ldsPrinters = Create Datastore
	sql_syntax = "Select Trax_Printer_locale from Trax_warehouse where project_id = '" + gs_project + "' and wh_code = '" + lsWarehouse + "'"
	sql_syntax += " Union Select Trax_Printer_locale from Trax_Printer where project_id = '" + gs_project + "' and wh_code = '" + lsWarehouse + "';"

	ldsPrinters.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsPrinters.SetTransObject(SQLCA)
	llRowCount = ldsPrinters.retrieve()
	
	tab_main.tabpage_Trax.ddlb_Trax_printer.Reset()
	
	For llRowPos = 1 to llRowCount
		tab_main.tabpage_Trax.ddlb_Trax_printer.Additem(ldsPrinters.GetITemString(llRowPos,'trax_printer_locale'))
	Next
	
	tab_main.tabpage_Trax.ddlb_Trax_printer.SelectITem(1)
	
	isTraxWarehouse = lsWarehouse
	
End If

Return 0
end function

public subroutine wf_set_line_no_babycare ();long		ll_rowcount
string		ls_hold_invoice_no
string		ls_curr_invoice_no
long		ll_line_no, i

ll_rowcount = idw_print.RowCount()

ls_hold_invoice_no = ''

for i = 1 to ll_rowcount
	
	ls_curr_invoice_no = idw_print.object.invoice_no[i]
	
	IF ls_curr_invoice_no <> ls_hold_invoice_no THEN
		
		// Reset line number to 1
		ll_line_no = 0
		
		ls_hold_invoice_no = ls_curr_invoice_no
		
	END IF	
		
	ll_line_no = ll_line_no + 1
	
	idw_print.object.line_id[i] =  ll_line_no

next


end subroutine

public function integer wf_check_status_mobile ();
String	lsWarehouse, lsFindStr, lsBatchMobileEnabled
Integer	i

idw_Pick.Object.Datawindow.ReadOnly = False
idw_Pack.Object.Datawindow.ReadOnly = False

// F10 unlock may have changed these settings...
	
//idw_Pick.Object.mobile_status_Ind.Protect = True
//idw_Pick.Modify("mobile_status_Ind.Background.Color = '12639424'")
//

lsBatchMobileEnabled = idw_master.GetItemString(1, "mobile_Enabled_Ind")
If isNull(lsBatchMobileEnabled) Then lsBatchMobileEnabled = ''

lsWarehouse = idw_master.GetItemString(1, "wh_code")
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") = 'Y' Then
		
		idw_Master.modify("mobile_enabled_ind.visible=True mobile_enabled_ind_t.visible=True")
		
		idw_Detail.modify("mobile_status_ind.visible=True mobile_status_ind_t.visible=True")
		idw_Detail.Modify("mobile_released_time.visible=True mobile_released_time_t.visible=True")
		idw_Detail.Modify("mobile_pick_start_time.visible=True mobile_pick_start_time_t.visible=True")
		idw_Detail.Modify("mobile_scan_all_units_req_ind.visible=True mobile_scan_all_units_req_ind_t.visible=True ")
		idw_Detail.Modify("mobile_pick_complete_time.visible=True mobile_pick_complete_time_t.visible=True")	
		idw_Detail.Modify("mobile_pack_location.visible=True mobile_pack_location_t.visible=True ")
		
		idw_Pick.modify("mobile_status_ind.visible=True mobile_status_ind_t.visible=True")
		idw_Pick.Modify("mobile_released_time.visible=True mobile_released_time_t.visible=True")
		idw_Pick.Modify("mobile_pick_start_time.visible=True mobile_pick_start_time_t.visible=True")
		idw_Pick.Modify("mobile_pick_complete_time.visible=True mobile_pick_complete_time_t.visible=True")	
		idw_Pick.Modify("mobile_picked_by.visible=True mobile_picked_by_t.visible=True")
		idw_Pick.Modify("mobile_picked_qty.visible=True mobile_picked_qty_t.visible=True")
		idw_Pick.Modify("mobile_current_location.visible=True mobile_current_location_t.visible=True")
			
		tab_main.tabpage_pick.cb_mobile.Visible = True
					
	Else /* Not mobile Enabled */
		
		idw_Master.modify("mobile_enabled_ind.visible=false mobile_enabled_ind_t.visible=false")
		
		idw_Detail.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Detail.Modify("mobile_released_time.visible=false mobile_released_time_t.visible=false")
		idw_Detail.Modify("mobile_pick_start_time.visible=false mobile_pick_start_time_t.visible=false")
		idw_Detail.Modify("mobile_scan_all_units_req_ind.visible=false mobile_scan_all_units_req_ind_t.visible=false ")
		idw_Detail.Modify("mobile_pick_complete_time.visible=false mobile_pick_complete_time_t.visible=false")	
		idw_Detail.Modify("mobile_pack_location.visible=false mobile_pack_location_t.visible=false ")	
	
		idw_Pick.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Pick.Modify("mobile_released_time.visible=false mobile_released_time_t.visible=false")
		idw_Pick.Modify("mobile_pick_start_time.visible=false mobile_pick_start_time_t.visible=false")
		idw_Pick.Modify("mobile_pick_complete_time.visible=false mobile_pick_complete_time_t.visible=false")	
		idw_Pick.Modify("mobile_picked_by.visible=false mobile_picked_by_t.visible=false")
		idw_Pick.Modify("mobile_picked_qty.visible=false mobile_picked_qty_t.visible=false")
		idw_Pick.Modify("mobile_current_location.visible=false mobile_current_location_t.visible=false")
		
		tab_main.tabpage_pick.cb_mobile.Visible = False
				
	End If
	
End If

//If released to mobile, can't make any changes to picking
If lsBatchMobileEnabled = "Y"  Then
			
	//Pick
	tab_main.tabpage_pick.cb_insert_Pick.Enabled = False
	tab_main.tabpage_pick.cb_delete_Pick.Enabled = False
	tab_main.tabpage_pick.cb_generate_Pick.Enabled = False
	tab_main.tabpage_pick.cb_Pick_Copy.Enabled = False
	
	idw_Pick.Object.Datawindow.ReadOnly = True
	
	tab_main.tabpage_pick.cb_mobile.Text = "Remove from Mobile"
	
	//Can only remove from mobile if all lines are still in New
	If idw_Pick.Find("Mobile_status_Ind <> 'N'",1,idw_pick.RowCount()) > 0 Then
		tab_main.tabpage_pick.cb_mobile.Enabled = False
	Else
		If idw_Pick.RowCOunt() > 0 Then
			tab_main.tabpage_pick.cb_mobile.Enabled = True
		End If
	End If
	
Else
	
	//Can only releae to Mobile if all orders in Process, Picking or Packing
	If idw_Pick.Find("ord_status = 'N' or Ord_status = 'C' or Ord_status = 'D' or Ord_status = 'V'",1,idw_pick.RowCount()) > 0 Then
		tab_main.tabpage_pick.cb_mobile.Enabled = False
	Else
		tab_main.tabpage_pick.cb_mobile.Enabled = True
	End if
	
	tab_main.tabpage_pick.cb_mobile.Text = "Release To Mobile"
				
End If

		
REturn 0
end function

on w_batch_pick.create
int iCurrent
call super::create
end on

on w_batch_pick.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
iw_window = This
tab_main.MoveTab(2,99) /*move search to end*/

i_nwarehouse = Create n_warehouse

idw_search = tab_main.tabpage_search.dw_search
idw_result = tab_main.tabpage_search.dw_result
idw_master = Tab_main.tabpage_main.dw_batch_master
idw_detail = tab_main.tabpage_order_detail.dw_batch_details
idw_pick = tab_main.tabpage_pick.dw_pick
idw_Pack = tab_main.tabpage_pack.dw_pack
idw_trax = tab_main.tabpage_trax.dw_trax
idw_packPrint = tab_main.tabpage_pack.dw_packPrint
idw_packlabels = tab_main.tabpage_pack.dw_pack_labels
idw_print = tab_main.tabpage_pick.dw_pick_print
isle_batch_ID = tab_main.tabpage_main.sle_batch_ID

// 01/06 - Pconkl - for controlled rollout of server based pick allocation
//If Upper(sqlca.database) <> "SIMS33PRD" or &
//	gs_project = 'HILLMAN' or &
//	gs_project = 'POWERWAVE' Then
	
		ibServerAllocationEnabled = True
		
//Else
//	ibServerAllocationEnabled = False
//End If



end event

event resize;call super::resize;
tab_main.Resize(workspacewidth() - 30,workspaceHeight() - 20)
idw_result.Resize(workspacewidth() - 80,workspaceHeight()-800)
idw_detail.Resize(workspacewidth() - 100,workspaceHeight()-300)
idw_pick.Resize(workspacewidth() - 100,workspaceHeight()-300)
idw_pack.Resize(workspacewidth() - 100,workspaceHeight()-300)
idw_trax.Resize(workspacewidth() - 100,workspaceHeight()-300)

tab_main.tabpage_search.cb_selectall.y = workspaceHeight()-300
tab_main.tabpage_search.cb_clearall.y = workspaceHeight()-300
tab_main.tabpage_search.cb_confirmall.y = workspaceHeight()-300

end event

event ue_postopen;call super::ue_postopen;datawindowChild	ldWC,	&
						ldwc2, ldwc_warehouse
						
String	lsFilter

//Jxlim 11/17/2010 - Batch report button only visible for Comcast at this time
If gs_project = 'COMCAST' Then
	tab_main.tabpage_main.cb_batch.visible=true
	tab_main.tabpage_main.cb_batch.enabled=False
Else
	tab_main.tabpage_main.cb_batch.visible=False
End If
//Jxlim end

//GMOR 12/20/2010 - SIK Multiple Batch Confirm 
tab_main.tabpage_search.cb_confirmall.enabled=False

idw_search.InsertRow(0)

// pvh 02/1006
// delivery master
idsDeliveryMaster = f_datastoreFactory('d_deliverymasterbyprojdono')

//Create datastores for updating Content
IdsContent = Create n_ds_content
IdsContent.Dataobject = 'd_do_content'
IdsContent.SetTransObject(SQLCA)

IdsPickDetail = Create n_ds_content
IdsPickDetail.Dataobject = 'd_do_pick_detail'
IdsPickDetail.SetTransObject(SQLCA)

//Retrieve Order Type Dropdown and share wqith search screen
idw_master.GetChild("ord_type", ldwc)
idw_search.GetChild("ord_type",ldwc2)
idw_search.GetChild("wh_code", ldwc_warehouse)
ldwc.SetTransObject(sqlca)
If ldwc.Retrieve(gs_project) < 1 Then ldwc.InsertRow(0)
ldwc.ShareData(ldwc2)

//Carrier
idw_master.GetChild('carrier',ldwc)
idw_search.GetChild("carrier",ldwc2)
ldwc.SetTransObject(SQLCA)
If ldwc.Retrieve(gs_project) < 1 Then ldwc.InsertRow(0)
ldwc.ShareData(ldwc2)

//Inv Type
idw_pick.GetChild('inventory_Type',ldwc)
ldwc.SetTransObject(SQLCA)
If ldwc.Retrieve(gs_project) < 1 Then ldwc.InsertRow(0)

		
//warehouse
idw_master.GetChild('wh_code',ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* 04/04 - PCONKL - Load from User Warehouse DAtastore */
ldwc.ShareData(ldwc_warehouse)
//If ldwc.Retrieve(gs_project) < 1 Then ldwc.InsertRow(0)

//Filter Customer Type by Project
idw_master.GetChild('customer_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.SetFilter("Upper(project_id) = '" + Upper(gs_project) + "'")
ldwc.Filter()

//Capture original SQL for Detail and Pick DW's
//setsqlselect won't allow us to issue update statements when more than 1 table is present
//isOrigSql_Detail = GetSqlSelect(idw_Detail)
isOrigSQL_Detail = 	idw_detail.Describe("DataWindow.Table.Select")

//isorigSQl_Pick = GetSQLSelect(idw_pick)
isOrigSQL_Search = GetSqlSelect(idw_Result)

// 09/05 - PCONKL - TRAX DW shared with Packing Dw
idw_Pack.ShareData(idw_Trax)

//// 09/05 - PCONKL - Hide TRAX tab if project not enabled
//If not g.ibTraxEnabled Then
//	tab_main.tabpage_trax.visible = False
//End If

// 04/13 - PCONKL - Added 'Print DN' button - only visible for Starbucks-TH for now
If gs_project = 'STBTH'  Then
	
	tab_main.TabPage_Pack.cb_print_dn.visible = True
		
Else
	tab_main.TabPage_Pack.cb_print_dn.visible = False
End If
	
tab_main.Tabpage_Order_Detail.em_delivery_dt.Text = String(today())

// 12/13 - PCONKL - PSend to Cart button should only be visible for Physio right now. Customer 2 will get a project level indicator
If gs_project = 'PHYSIO-MAA'  or gs_project = 'PHYSIO-XD' Then
	tab_main.tabpage_pick.cb_send_to_cart.visible = True
Else
	tab_main.tabpage_pick.cb_send_to_cart.visible = False
End If


This.TriggerEvent('ue_edit')


end event

event ue_edit;call super::ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties

im_menu.m_file.m_save.Enabled = False
im_menu.m_file.m_retrieve.Enabled = True
im_menu.m_file.m_print.Enabled = False
im_menu.m_file.m_refresh.Enabled = False
im_menu.m_record.m_delete.Enabled = False

tab_main.tabpage_order_detail.Enabled = False
tab_main.tabpage_Pick.Enabled = False
tab_main.tabpage_Pack.Enabled = False
tab_main.tabpage_trax.Enabled = False

isle_Batch_ID.Visible=True
isle_Batch_ID.TabOrder = 10
//isle_Batch_id.Text = ''

idw_master.Hide()
tab_main.tabpage_main.cb_cust.Visible = False

tab_main.tabpage_main.cb_generate.Enabled = False
tab_main.tabpage_main.cb_confirm.Enabled = False

Tab_main.SelectTab(1)
isle_Batch_ID.SetFocus()
end event

event ue_new;Long	llBatchID

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

tab_main.tabpage_main.cb_confirm.Enabled = False
tab_main.TabPage_Order_detail.cb_remove_orders.Enabled = False

tab_main.tabpage_order_detail.Enabled = False
tab_main.tabpage_Pick.Enabled = False
tab_main.tabpage_Pack.Enabled = False
//Begin - Dinesh - 06/23/2021- S57912- PhilipsCLS GSIN and Batch Picking
datawindowchild ldwc,ldwc2,ldwc3,ldwc4
IF Upper(gs_project) = 'PHILIPSCLS' Then    
    tab_main.tabpage_main.dw_batch_master.dataobject='d_batch_pick_info_philipscls' 
    tab_main.tabpage_main.dw_batch_master.settrans(sqlca)
    
        tab_main.tabpage_main.dw_batch_master.GetChild('ord_type',ldwc)
        ldwc.SetTransObject(SQLCA)
        if ldwc.RowCount() = 0 then
            ldwc.Retrieve(gs_project)
        End If
        
        tab_main.tabpage_main.dw_batch_master.GetChild('carrier',ldwc2)
        ldwc2.SetTransObject(SQLCA)
        if ldwc2.RowCount() = 0 then
            ldwc2.Retrieve(gs_project)
        End If
        
        tab_main.tabpage_main.dw_batch_master.GetChild('customer_type',ldwc3)
        ldwc3.SetTransObject(SQLCA)
        if ldwc3.RowCount() = 0 then
            ldwc3.Retrieve()
            ldwc3.SetFilter("project_id = '" + gs_project + "'")
            ldwc3.Filter()
        End If
        
        tab_main.tabpage_main.dw_batch_master.GetChild('wh_code',ldwc4)
        ldwc4.SetTransObject(SQLCA)
        if ldwc4.RowCount() = 0 then
            ldwc4.Retrieve(gs_project)
        End If  
else
idw_master.Reset()
end if
//End - Dinesh - 06/23/2021- S57912- PhilipsCLS GSIN and Batch Picking 
idw_detail.Reset()
idw_Pick.Reset()
idw_Pack.Reset()

idw_master.InsertRow(0)
idw_master.Show()
tab_main.SelectTab(1)
tab_main.tabpage_main.cb_cust.Visible = True

isle_batch_id.Visible = False
isle_Batch_ID.text = ''

//New record defaults
idw_master.SetITem(1,'project_id',gs_Project)
idw_master.SetItem(1,'batch_status','N') /*Status of New*/
idw_master.SetItem(1,'pick_Cart_status','N') /*Status of Not Sent*/
idw_master.SetITem(1,'wh_code',gs_default_wh) /*default warehouse for project*/
idw_master.SetITem(1,'last_user',gs_userid) /*default warehouse for project*/
idw_master.SetITem(1,'item_ugly_ind','1') /*default to all orders */

//GailM 9/25/2019 S36848 - DE12618 - PhilipsCLS GSIN/SSCC processing
//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
If upper(gs_project) = 'PHILIPSCLS' OR upper(gs_project) = 'PHILIPS-DA' Then
	idw_master.object.gsin_type.visible = TRUE
	idw_master.SetItem(1,'gsin_type','1')	/*Set GSIN Type to default*/
Else
	idw_master.object.t_18.visible = FALSE
	idw_master.object.gsin_type.visible = FALSE
End If

// pvh gmt 12/28/05 - set the warehouse
setWarehouse( gs_default_wh )
	
/*default to Project level*/
idw_master.SetITem(1,'Pick_Sort_order','PROJECT')

wf_check_status()


end event

event ue_save;// 11/02 - PCONKL - Chg QTY to Decimal

Long		llRC,	&
			llBatchID,	&
			llRowPos,	&
			llRowCount,	&
			llLineItem,	&
			llPackCount,	&
			llPickCount,	&
			llDetailCount,	&
			llOwnerID,		&
			llFindRow,		&
			llArrayPos, llArraycount
			
String	lsMsg,	&
			lsDoNo,	lsDoNoHold, 	&
			lsSku,		&
			lsSupplier,	&
			lsInvoice,	&
			lsEmptyArray[] 
			
Decimal	ldAllocQty

If idw_master.RowCount() <= 0 Then Return 0

SetPointer(Hourglass!)

//Validate before Saving
if tab_main.selectedtab = 5 then  //hdc clear the filter (shared buffer with pack) before saving from the trax tab so it doesn't complain about line count not matching
	idw_trax.SetRedraw(false) //hdc turn off redraw so the user doesn't see dup lines pop up, then go away
	idw_pack.SetFilter("")
	idw_pack.Filter()
end if

// SARUN04JULY2013 SIMS Over/Under picking issue.  Refresh here to synch up the picking and detail quantities before any validations are performed:Start
If ibPickChanged Then
	This.TriggerEvent('ue_refresh') /*updated alloc qty before saving details*/
End If
// SARUN4JULY2013 SIMS Over/Under picking issue.  Refresh here to synch up the picking and detail quantities before any validations are performed:End



If wf_validate() < 0 Then 
		idw_trax.SetFilter("c_dup_filter = 'N'")  //hdc restore the trax filter
		idw_trax.Filter()
		idw_trax.SetRedraw(true)
	Return -1
end if

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( getWarehouse() ) 
//ldtToday = datetime( today(), now() )

//If we haven't yet assigned the Batch ID, do so now...
If idw_master.GetItemNumber(1,'batch_pick_id') > 0 Then
	llBatchId = idw_master.GetItemNumber(1,'batch_pick_id')
Else /*get the next available ID */
	//Get the Next available Seq No
	llBatchId = g.of_next_db_seq(gs_project,'Batch_Pick_Master','batch_Pick_ID')
	If llBatchId <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available batch Pick ID!")
		idw_trax.SetFilter("c_dup_filter = 'N'") //hdc restore the trax filter
		idw_trax.Filter()
		idw_trax.SetRedraw(true)		
		Return -1
	End If
	
	idw_master.SetITem(1,'batch_Pick_ID',llBatchID)
	isle_batch_id.text = String(llBatchID)
	
End If

w_main.SetMicroHelp('Updating Detail Order Status...')
idw_detail.SetRedraw(False)
idw_Pick.SetRedraw(False)

// 08/02 - Pconkl - If we are dropping ORders with Raw Material (For Saltillo), delete any pick rows for an order in Hold
If ibDropRaw Then
	llDetailCount = idw_Detail.RowCount()
	For llRowPos = 1 to llDetailCount
		If idw_detail.GetITemString(llRowPos,'ord_Status') = 'H' Then
			llFindRow = idw_pick.Find("invoice_no='" + idw_detail.GetITemString(llRowPos,'invoice_no') + "'",1,idw_pick.RowCount())
			Do While llFindRow > 0
				idw_Pick.DeleteRow(llFindRow)
				llFindRow = idw_pick.Find("invoice_no='" + idw_detail.GetITemString(llRowPos,'invoice_no') + "'",1,idw_pick.RowCount())
			Loop
		End If /*Order in Hold */
	Next /*detail Row */
End If /*dropping Raw Material orders */

llPickCOunt = idw_Pick.RowCount()
llPackCount = idw_Pack.RowCount()


//Update Delivery MAster rows with Order status, Last Update/User unless the order has already been confiremd or Void
llRowCount = idw_detail.RowCount()
For llRowPos = 1 to llRowCount
	
	w_main.SetMicroHelp('Updating Detail Order Status ' + String(llRowPos) + ' of ' + String(llRowCount))
	If idw_Detail.GetITemString(llRowPos,'Ord_status') = 'C' or idw_Detail.GetITemString(llRowPos,'Ord_status') = 'V' Then Continue
	
	// 08/02 - Pconkl - dont set the batch ID if dropping from batch (it has already been set to 0 to remove from the batch)
	If (not ibdropraw) and (isNull(idw_detail.GetItemNumber(llRowPos,'batch_Pick_id')) or idw_detail.GetItemNumber(llRowPos,'batch_Pick_id') = 0) and idw_detail.GetItemString(llRowPos,'ord_status') <> 'H' Then
		idw_Detail.SetITem(llRowPos,'batch_Pick_ID',llBatchID)
	End If
	
	//Update the Order Status on the Delivery Order Records 
	lsInvoice = idw_detail.GetItemString(llRowPos,'Invoice_no')
	
	//If regenerating the Pick or Batch, Set the Order Status back to New
	//Only set the status if it has changed - will speed up saving of records
	If ibGeneratePick or ibGenerateBatch or ibDeleteBatch Then
		If idw_detail.GetITemString(llRowPos,'ord_status') <> 'N' Then
			idw_detail.SetItem(llRowPos,'ord_status','N') /*set to New Status*/
		End If
	Else
		If idw_detail.GetITemString(llRowPos,'ord_status') <> 'H' Then /* if hold, leave so */
			If llPackCOunt > 0 and idw_pack.Find("Upper(Invoice_NO) = '" + Upper(lsInvoice) + "'",1,llPackCount) > 0 Then
				If idw_detail.GetITemString(llRowPos,'ord_status') <> 'A' Then
					idw_detail.SetItem(llRowPos,'ord_status','A') /*set to Packing Status*/
				End If
			ElseIf llPickCount > 0 and idw_pick.Find("Upper(Invoice_NO) = '" + Upper(lsInvoice) + "'",1,llPickCount) > 0 then
				If idw_detail.GetITemString(llRowPos,'ord_status') <> 'I' Then
					idw_detail.SetItem(llRowPos,'ord_status','I') /*set to Picking Status*/
				End If
			Else
				If idw_detail.GetITemString(llRowPos,'ord_status') <> 'N' Then
					idw_detail.SetItem(llRowPos,'ord_status','N') /*set to Process Status*/
				End If
			End If
		End If /*Not Hold Status*/
	End If /*Regenerating Batch or Pick*/

	If idw_detail.GetITemStatus(llRowPos,0,Primary!) = NotModified! Then Continue /*should speed saving*/
	
	
	// pvh 11/23/05 - GMT
	idw_detail.SetITem(llRowPos,'last_update', ldtToday )
	idw_detail.SetITem(llRowPos,'last_user',gs_userid)
		
Next /*Next Order Detail*/

idw_detail.SetRedraw(True)
idw_Pick.SetRedraw(True)

llDetailCount = idw_Detail.RowCount()

//Update Batch Pick ID on any Pick Rows that haven't already been set (If not deleting the batch)
If Not ibDEleteBatch Then

	w_main.SetMicroHelp('Updating Pick Detail Status...')
	idw_pick.SetRedraw(False)

	llRowCount = idw_Pick.RowCount()
	For llRowPos = 1 to llRowCount
		
		w_main.SetMicroHelp('Updating Pick Detail Status ' + String(llRowPos) + ' of ' + String(llRowCount))
		
		If idw_pick.GetITemStatus(lLRowPOs,0,Primary!) = NOtMOdified! Then Continue
		
		If isNull(idw_pick.GetITemNumber(llRowPos,'batch_pick_id')) or idw_pick.GetITemNumber(llRowPos,'batch_pick_id') = 0 Then
			idw_Pick.SetITem(llRowPos,'batch_Pick_ID',llBatchID)
		End If
		//show the new order status on the picking row (but don't update)
		lsInvoice = idw_Pick.GetItemString(llRowPos,'Invoice_no')
		idw_Pick.SetItem(llRowPos,'ord_status',idw_detail.GetITemString(idw_detail.Find("Upper(Invoice_NO) = '" + Upper(lsInvoice) + "'",1,llDetailCOunt),'ord_status'))
		idw_pick.SetITemStatus(llRowPos,'ord_status',Primary!,NotModified!)
		
	Next

	idw_Pick.SetRedraw(True)
	
	//Show the new status on the Packing Tab (If not deleting the batch)
	
	idw_Pack.SetRedraw(False)
	llRowCount = idw_pack.RowCount()
	For llRowPos = 1 to llRowCount
		lsInvoice = idw_Pack.GetItemString(llRowPos,'Invoice_no')
		idw_Pack.SetItem(llRowPos,'ord_status',idw_detail.GetITemString(idw_detail.Find("Upper(Invoice_NO) = '" + Upper(lsInvoice) + "'",1,llDetailCount),'ord_status'))
		idw_pack.SetITemStatus(llRowPos,'ord_status',Primary!,NotModified!)
	Next /*PAsking Record*/

	idw_Pack.SetRedraw(True)
	
End If /*Not deleting Batch*/

//Update the status (Batch Pick MAster) if not complete or void
If idw_master.GetITemString(1,'batch_status') <> 'C' Then
	If idw_pack.RowCount() > 0 Then
		idw_master.SetItem(1,'batch_status','A') /*Packing Status*/
	ElseIf idw_pick.RowCount() > 0 Then
		idw_master.SetItem(1,'batch_status','I') /*Picking Status*/
	ElseIf idw_detail.RowCount() > 0 Then
		If idw_detail.Find("Batch_Pick_id > 0",1,idw_detail.RowCount()) > 0 Then
			idw_master.SetItem(1,'batch_status','P') /*Process Status*/
		Else
			idw_master.SetItem(1,'batch_status','N') /*New Status*/
		End If
	Else
		idw_master.SetItem(1,'batch_status','N') /*New Status*/
	End If
End If /*not complete or void */

//Update the Order Status on the Delivery Order Records

//Update Last Update
//
// pvh 11/23/05 - GMT
idw_master.SetItem(1,'last_update', ldtToday ) 
// idw_master.SetItem(1,'last_update',Today()) 

idw_master.SetItem(1,'last_user',gs_userid) 
	
//08/06 - PCONKL - There are many detail records that are updating a single Delvery Master record - reset the update flag on all
//							except the first for each order so we don't send an update statement to the DB for each one.

llRowCount = idw_Detail.RowCount()
For llRowPos = 1 to llRowCount
	
	lsDoNo = idw_detail.GetITemString(llRowPos, 'do_no')
	
	If lsDONo = lsDoNoHold Then
		idw_detail.SetItemStatus(llRowPos,0,Primary!,NotModified!)
	End If
	
	lsDoNoHold = lsDoNo
	
next

//08/06 - PCONKL - Moved content allocation outside of transaction to minimize lock times

//12/06 - PCONKL - Content being updatied on the server - controlled rollout
//If not ibserverallocationenabled Then
//	
//	w_main.SetMicroHelp('Updating Inventory Records...')
//	llRC = wf_Update_Content()
//	If llRC < 0 Then
//		idw_trax.SetFilter("c_dup_filter = 'N'")   //hdc restore the trax filter
//		idw_trax.Filter()
//		idw_trax.SetRedraw(true)
//		Return -1
//	End If
//
//End If /*Production only*/

If ibPickChanged Then
	This.TriggerEvent('ue_refresh') /*updated alloc qty before saving details*/
End If
	
//Save the MAster
w_main.SetMicroHelp('Saving Batch Header...')

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

// 08/06 - PCONKL - Any deletes for Delivery_Serial_Detail from wf_update_content are here...
//12/06 - PCONKL - Moved to server 
//						- only executing in production for now
//If UpperBound(isupdateSql) > 0 and llRC >=0 and not ibserverallocationenabled Then
//	
//	w_main.SetMicroHelp('Deleting Delivery_Serial_detail records...')
//	
//	llArrayCount = UpperBound(isupdateSql)
//	
//	For llArrayPos = 1 to llArrayCount
//		Execute Immediate :isUpdateSql[llarrayPos] using SQLCA;		
//		If Sqlca.Sqlcode < 0 Then
//			llrc = -1
//			Exit
//		End If
//	Next
//	
//	isUpdateSql = lsEmptyArray /*Reset Array*/
//	
//End If

llRC = idw_master.Update()

//Save the Order Detail records
If llRC >=0 Then
	
//	If ibPickChanged Then
//		This.TriggerEvent('ue_refresh') /*updated alloc qty before saving details*/
//	End If
	
	w_main.SetMicroHelp('Saving Order Details...')
	llRC = idw_Detail.Update() /*this will update the Batch Pick ID and the Order Status on Delivery MAster*/
	
	// 12/06 - PCONKL - Allocated Qty being updated on Server now
	/* 12/06 - PCONKL - hardocded for controlled layout */
//	If not ibserverallocationenabled Then
//		
//		If idw_Pick.RowCOunt() > 0  Then 
//			
//			w_main.SetMicroHelp('Updating Allocated Quantities...')
//		
//			llRowCount = idw_detail.RowCount()
//			For llRowpos = 1 to llRowCount
//			
//				If Not ibPickChanged THen Continue
//	
//				lsDoNo = idw_detail.GetItemString(llrowPos,'do_no')
//				lsSKU = idw_detail.GetItemString(llrowPos,'SKU')
//				lssupplier = idw_detail.GetItemString(llrowPos,'supp_code')
//				llLineItem = idw_detail.GetItemNumber(llrowPos,'line_Item_no')
//				ldallocQty = idw_detail.GetItemNumber(llrowPos,'alloc_Qty')
//				llOwnerID = idw_detail.GetItemNumber(llrowPos,'owner_id')
//		
//				Update Delivery_Detail
//				Set alloc_qty = :ldAllocQty, owner_id = :llOwnerID
//				Where do_no = :lsDoNo and SKU = :lsSku and supp_code = :lsSupplier and Line_Item_no = :llLineItem;
//		
//			Next /*detail*/
//		
//		Else /*NO Picking rows, set to 0 if > 0*/
//		
//			If llBatchID > 0 Then
//			
//				Update Delivery_Detail
//				Set alloc_qty = 0
//				Where alloc_qty > 0 and do_no in (select do_no from delivery_MAster where project_id = :gs_project and batch_pick_id = :llBatchID);
//				
//			End If
//		
//		End If
//		
//	End If /*prod only */
	
End If

// 12/06 - PCONKL - Picking, Pickinfg Detail and Content records are now being updated on the server
// *** 12/06 - PCONKL - Hardcoded to ensure controlled layout ****
//If not ibserverallocationenabled Then
//	
//	//Save the Pick records
//	If llRC >=0 Then
//		w_main.SetMicroHelp('Saving Pick Records...')
//		llRC = idw_Pick.Update()
//	End If
//
//	//Save Pick Detail Records
//	If llRC >=0 Then
//		llRC = idspickdetail.Update()
//	End If
//
//	//Save Content Records
//	If llRC >=0 Then
//		w_main.SetMicroHelp('Saving Content Records...')
//		llRC = idsContent.Update()
//	End If
//	
//End If /* Production only*/

//Save Packing Records
If llRC >=0 Then
	w_main.SetMicroHelp('Saving Pack Records...')
	llRC = idw_Pack.Update()
End If

//Commit the changes if details and Pick saved properly
If llRC >=0 Then
	
	w_main.SetMicroHelp('Commiting Changes...')
	Execute Immediate "COMMIT" using SQLCA;
	
	If SQLCA.SQLCode = 0 Then
	  	If idw_master.RowCount() > 0 Then
			This.Title = is_title + " - Edit"
			//ib_changed = False
			ibdropraw = False
			ib_edit = True
			ibPickChanged = False
			//wf_check_status()
		End If
		SetMicroHelp("Record Saved!")
//		Return 0 
   Else /*commit failed*/
		Execute Immediate "ROLLBACK" using SQLCA;
		lsMsg = "Unable to commit Batch Picking Records!~r~r"
		If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
			lsMsg += SQLCA.SQLErrText
		End If
     	MessageBox(is_title, lsMsg)
		SetMicroHelp("Commit failed!")
		return -1
	End If
	
	//12/06 - PCONKL - Content bei ng allcoated on the server - only if everything else has been saved successfully
	// *** 12/06 - PCONKL - Hardcoded to ensure controlled rollout ****
	//If ibserverallocationenabled Then
				
		If wf_update_content_Server() = -1 Then 
			return -1
		End If
				
		idw_pick.ResetUpdate()
		idspickdetail.ResetUpdate()
		idsContent.ResetUpdate()
		
		ibpickmodified = False
		
	//End If
		
Else /*save Failed*/
	
	Execute Immediate "ROLLBACK" using SQLCA;
	lsMsg = "Unable to save Batch Picking Records!~r~r"
	If Not isnull(SQLCA.SQLErrText) Then /*if errtext is null, we get no msg - datastores dont return error codes like DW's*/
		lsMsg += SQLCA.SQLErrText
	End If
  	MessageBox(is_title, lsMsg)
	SetMicroHelp("Save failed!")
		idw_trax.SetFilter("c_dup_filter = 'N'")  //hdc restore the trax filter
		idw_trax.Filter()
		idw_trax.SetRedraw(true)
	return -1
	
End If

ib_changed = False

wf_check_status()

SetPointer(arrow!)
w_main.SetMicroHelp('Ready')

idw_trax.SetFilter("c_dup_filter = 'N'")  //hdc restore the trax filter
idw_trax.Filter()
idw_trax.SetRedraw(true)

Return 0

end event

event ue_retrieve;Long	llBatchID
String	lsNewSQL,	&
			lsModify

//Id must be numeric
If Not isNumber(isle_batch_id.text) Then
	MessageBox(is_title,'Batch Pick ID must be numeric')
	isle_batch_id.SetFocus()
	isle_batch_id.SelectText(1,Len(isle_batch_id.text))
	Return
End If

llBatchID = Long(isle_batch_id.text)

tab_main.TabPage_Order_detail.cb_remove_orders.Enabled = False

w_main.Setmicrohelp('Retrieving Batch Pick Information...')
SetPointer(Hourglass!)

//Retrieve the MAster
If idw_MASter.Retrieve(gs_project,llBatchID) > 0 Then 
	
	isle_Batch_ID.Visible=False
	idw_master.Show()
	tab_main.tabpage_main.cb_cust.Visible = True
	
	// 07/19/2010 ujhall: 01 of 12 Comcast SIK Batch Picking: Qty For SKU entry not allowed when SKU is blank
	if isnull( idw_Master.GetItemString(1,'SKU')) or  idw_Master.GetItemString(1,'SKU') = '' Then
		idw_Master.Object.qty_for_sku.protect = 1
	end if
		
	//Retrieve the details if they exist - Modify SQL to include Project and Batch ID
	lsNewSQL = isOrigSQL_Detail + " and Delivery_MAster.Project_id = '" + gs_project + "' and batch_pick_id = " + String(llBatchID)
	
	// pvh gmt 12/28/05 - set the warehouse
	setWarehouse( idw_master.object.wh_code[ 1 ] )
	
	//setsqlselect won't allow us to issue update statements when more than 1 table is present - Use Modify
	lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
	idw_detail.Modify(lsModify)

	//idw_detail.SetSqlSelect(lsNewSql)
	idw_detail.Reset()
	idw_detail.Retrieve()
	idw_detail.GroupCalc()
	
	//Retrieve the Pick Records if they exist 
	idw_pick.Reset()
	idw_pick.Retrieve(gs_Project,llBatchID)
	
	//Retrieve the Pack Records if they exist 
	idw_pack.REset()
	idw_pack.Retrieve(gs_Project,llBatchID)
	
	//Retrieve the Pack Records if they exist 
	//idw_trax.Reset()  // Dinesh - 02/27/2025 - SIMS-672-CS Migration - Label Print and Re-print not working for container with multiple Packing records
	//idw_trax.Retrieve(gs_Project,llBatchID)  // Dinesh - 02/27/2025 - SIMS-672-CS Migration - Label Print and Re-print not working for container with multiple Packing records
		
	uf_enable_first_carton_row(0,"",'')
	
	//This.TriggerEvent('ue_refresh') /*refresh allocated Qtys*/
	
	idw_pick.GroupCalc()
	
	wf_check_status()
	
	ibBatchCriteriaChanged = False
	ib_changed = False
	ibDropRaw = False
		
Else /* Batch Not Found*/
	
	Messagebox(is_title,"Batch Not found!")
	isle_batch_id.SetFocus()
	isle_batch_id.SelectText(1,Len(isle_batch_id.text))
	//Return
	
End If


w_main.Setmicrohelp('Ready')
SetPointer(Arrow!)
end event

event ue_clear;call super::ue_clear;
//Allow user to clear the Batch Criteria as long as they haven't generated the batch yet

If idw_Detail.RowCount() > 0 Then
	If Not ibbatchCriteriaChanged Then /*only need to display msg once*/
		If MessageBox(is_title,'If you change the Batch Criteria after previously generating the Batch,~rYou will need to re-generate the batch before saving.~r~rDo you want to continue?',StopSign!,YesNo!,2) = 2 Then
			Return 
		Else
			ibbatchCriteriaChanged = True
		End If
	End If
End If
			
If idw_master.RowCount() > 0 Then
	idw_master.SetItem(1,'ord_type','')
	idw_master.SetItem(1,'cust_Code','')
	idw_master.SetItem(1,'customer_type','')
	idw_master.SetItem(1,'carrier','')
	idw_master.SetItem(1,'invoice_no_from','')
	idw_master.SetITem(1,'invoice_no_to','')
	
End If
	

end event

event ue_refresh;Integer i, ll_rowcnt1, j, ll_rowcnt2, ll_balance
String ls_sku, ls_prev_sku, lsSupplier, lsOrder, lsFind
long	llLineItemNo

// This event is to refresh the Alloc Qty in idw_detail from idw_pick

If idw_detail.AcceptText() = -1 Then 
//	tab_main.SelectTab(2) 
	idw_detail.SetFocus()
	Return 
End If
If idw_pick.AcceptText() = -1 Then
//	tab_main.SelectTab(3) 
	idw_pick.SetFocus()
	Return 
End If

idw_detail.Sort()
idw_pick.Sort()

idw_detail.SetRedraw(False)

ll_rowcnt1 = idw_detail.RowCount()
ll_rowcnt2 = idw_pick.RowCount()

For i = 1 to ll_rowcnt1
	idw_detail.SetItem(i, "alloc_qty", 0)
	idw_detail.SetItemStatus(i,'alloc_qty',Primary!,NotModified!)
Next

j = 1
For i = 1 to ll_rowcnt2
		
	SetMicroHelp("Calculating allocated quantity for item " + String(i)) 
	ls_sku = idw_pick.GetItemString(i,"sku")
	lsSupplier = idw_pick.GetItemString(i,"supp_code")
	lsOrder = idw_pick.GetItemString(i,"invoice_no")
	llLineItemNo = idw_pick.GetItemNumber(i,"Line_Item_No") /* 09/01 - PCONKL - include line item when allocating detail to picking*/
		
	lsFind = "Upper(invoice_no) = '" + Upper(lsOrder) + "' and Upper(sku) = '" + Upper(ls_sku)  + "' and line_item_no = " + String(llLineItemNo)
	// ONly include supplier in find if we are not allowing pick by Alternate Supplier
	If g.is_allow_alt_supplier_pick = 'N' Then
		lsFind += " and Upper(supp_code) = '" + Upper(lsSupplier) + "'"
	End If
	
	j = idw_detail.Find(lsFind, 1, ll_rowcnt1)
	
	// 10/00 PCONKL - Dont update allocated if it's a component child
	If j > 0 and idw_pick.GetItemString(i,"component_ind") <> '*' Then	
		If j > 0 Then
			
			idw_detail.SetItem(j, "alloc_qty", idw_detail.GetItemNumber(j, "alloc_qty") + &
				idw_pick.GetItemNumber(i,"quantity"))
	
			//12/06 - PConkl - updating allocated Qty on server - reset status here so we don't update from client as well
			If ibserverallocationenabled Then
				idw_detail.setITemStatus(j,'alloc_qty',Primary!,NotModified!)
			End If
			
		End If
		
	End If
	
	// 07/05 - PCONKL - We may be allocating from an alternate SKU, include in allocated qty for primary SKU
	If g.is_allow_alt_sku_Pick = 'Y' Then
		lsFind = "Upper(invoice_no) = '" + Upper(lsOrder) + "'"
		lsFind += " and Upper(alternate_sku) = '" + Upper(ls_sku)  + "' and line_item_no = " + String(llLineItemNo)
		lsFind += " and Upper(sku) <> upper(alternate_sku)"
		j = idw_detail.Find(lsFind, 1, ll_rowcnt1)
		If j > 0 and idw_pick.GetItemString(i,"component_ind") <> '*' Then	
			
			idw_detail.SetItem(j, "alloc_qty", idw_detail.GetItemNumber(j, "alloc_qty") + &
			idw_pick.GetItemNumber(i,"quantity"))
			
			//12/06 - PConkl - updating allocated Qty on server - reset status here so we don't update from client as well
			If ibserverallocationenabled Then
				idw_detail.setITemStatus(j,'alloc_qty',Primary!,NotModified!)
			End If
			
		End If
	End If

Next

SetMicroHelp("Ready")
idw_detail.SetRedraw(True)

Return 
end event

event ue_delete;//ancestor being overridden (no need to prompt for changes if deleting)

Long	llRowCount,	&
		i,				&
		llRC,			&
		llBatchID
		
If Messagebox(is_title,'Are you sure you want to Delete this Batch?~r~rAll picked stock will be returned to inventory.',Question!,YesNo!,2) = 2 Then Return

//Re-retrieve the batch to ensure that the order statuses are accurate (we don't want to delete anything that has already been confirmed)
isle_batch_id.Text = String(idw_master.GetITemNumber(1,'batch_Pick_ID'))
This.TriggerEvent('ue_retrieve')

ibDEleteBatch = True

//Delete Packing Rows - We don't want to Delete any rows if the order is Complete!
idw_pack.SetRedraw(false)
llRowCount = idw_pack.RowCount()
For i = llRowCOunt to 1 step -1
	If idw_pack.GetITemString(i,'ord_status') = 'C' or idw_pack.GetITemString(i,'ord_status') = 'D' or idw_pack.GetITemString(i,'ord_status') = 'V' Then Continue
	idw_pack.DeleteRow(i)
Next
idw_pack.SetRedraw(True)

//Delete Pick Rows - this will free stock
idw_pick.SetRedraw(False)
SetPointer(Hourglass!)

//We don't want to Delete any rows if the order is Complete!
llRowCount = idw_pick.RowCount()
For i = llRowCOunt to 1 step -1
	If idw_pick.GetITemString(i,'ord_status') = 'C' or idw_pick.GetITemString(i,'ord_status') = 'D' or idw_pick.GetITemString(i,'ord_status') = 'V' Then Continue
	idw_pick.DeleteRow(i)
Next
idw_pick.SetRedraw(True)

idw_detail.REset()

llRC = This.TriggerEvent('ue_save')

idw_pick.REset()
idw_Pack.Reset()

If llRC >=0 Then
	
	//Remove the Batch Pick ID from delivery Orders and set status back to New - this will 'delete' the records on the detail tab
	llBatchID = idw_Master.GetItemNumber(1,'batch_pick_id')
	
	If llBatchID > 0 THen
		
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

		Update Delivery_Master
		Set Batch_Pick_ID = 0, ord_status = 'N'
		Where Project_id = :gs_project and Batch_Pick_id = :llbatchID and ord_status not in ('C', 'D', 'V');
	
		//Delete the Batch Pick Master record
		Delete from Batch_Pick_Master where Project_id = :gs_project and batch_Pick_ID = :llBatchID;
	
		Execute Immediate "COMMIT" using SQLCA;
	
		If sqlca.SqlCode >=0 Then
			Messagebox(is_title,'Batch Deleted!')
			This.TriggerEvent('ue_Edit')
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox(is_title,'Unable to Delete Batch.')
		End If
		
	End If
	
Else
	
	MessageBox(is_title,'Unable to Delete Batch.')
	
End If

isle_batch_id.Text = ''

SetPointer(Arrow!)
ibDEleteBatch = False
end event

event ue_print;call super::ue_print;// This event prints the Picking List which is currently visible on the screen 
// and not from the database

Long ll_cnt, i, j, llDetailFindROw, llFindRow, llBatchPickID
String ls_address, lsUOM
String ls_project_id , ls_sku , ls_description, lsSupplier, lsSkuHold, lsSupplierHold
String ls_inventory_type , ls_inventory_type_desc, lsClientName,lsIMUser9,lsimuser13
String ls_loc_code,ls_whcode, lsSchedCode, lsSchedCodeHold, lsSchedDesc, lsShipVia, lsInvTypeHold
String	 ls_hazard_class, ls_hazard_cd
dec{3} ldweight_1
Str_parms	lStrPArms
Boolean	lbNotBatch
string ls_l_code, ls_invoice_no, ls_do_no,  ls_do_no_Hold
string ls_user_field11, ls_user_field13, ls_user_field1, ls_user_field12, ls_wh_code, ls_user_field3
string ls_native_description, ls_user_field5, ls_user_field9, ls_user_field4, ls_tel, ld_ord_date, ls_address_1
String ls_dd_user_field1 
Long  ll_dd_req_qty
datetime ldtExpDate
string lsLocation
string lsDONO,lsNotes,lsinvoice
long llNotesCount,llNotesPos
datastore ldsNotes
string lsDONOPREVIOUS=''

// pvh - 02/07/06
long llLine_Item_No
long	llFind
string lsFind
string lsOrderNumber

string donobreak = "*"
string dono
Str_parms	lAddresses

String lscst,ls_inv,ls_batch
Long ll_sumcnt,k,ll_sumcnt_prev,ll_sumcnt_max

// TAM - 2018/09/07 - S23455
string ls_im_uf7, ls_im_uf8
long   ll_block, ll_tier, ll_pallet, ll_layer, ll_cases, llqty3

datastore lds_custsumm
lds_custsumm = CREATE datastore
lds_custsumm.dataobject = 'd_batch_picking_prt_starbucks_summary'
lds_custsumm.SetTransObject(SQLCA)

If idw_pick.AcceptText() = -1 Then
	Return	
End If

llBatchPickID = idw_master.GetITemNumber(1,'batch_pick_id')

//Make sure it has been saved first
If ib_Changed Then
	Messagebox(is_title,'Please save changes first.')
	Return
End If

ll_cnt = idw_pick.rowcount()
If ll_cnt = 0 Then
	MessageBox(is_title," No Picking records to print!")
	Return
End If

//08/05/11 cawikholm - Call new event to print Babycare order prick list
IF Upper(gs_project) = 'BABYCARE' THEN
	TriggerEvent( 'ue_print_order_picklist_babycare' )
	RETURN
END IF

//Prompt for Sort/BReak Type

// pvh - 02/08/06 - Don't prompt AMS - doesn't matter
IF Upper(gs_project) <>  'AMS-MUSER' AND Upper(gs_project) <>  'MAQUET' AND  Upper(gs_project) <> 'STBTH'  THEN

	OpenWithParm(w_pick_print_order,lstrparms)
	lstrparms = Message.PowerObjectParm
	
	IF lstrparms.Cancelled THEN
		Return
	Else
		If lStrparms.String_Arg[1] = 'O' Then /*sort by order, load standard pick list*/
			/* 09/09 - PCONKL, 12/12 - added TPV */ /* 6/13 - MEA - added FUNAI */ //TAM - 2015-01-12 added GIBSON			//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
			//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
			If Upper(gs_project) = 'PHILIPS-SG' or Upper(gs_project) = 'PHILIPSCLS' or Upper(gs_project) = 'PHILIPS-DA' or  Upper(gs_project) = 'TPV'  &
				or  Upper(gs_project) = 'FUNAI' or  Upper(gs_project) = 'GIBSON'   Then 
				idw_print.Dataobject = 'd_picking_prt_philips'
			ElseIf Upper(gs_project) ='REMA' Then //10-JULY-2018 :Madhu DE5149 - Rema Picking List
				idw_print.Dataobject ='d_picking_prt_rema'
			Else
				idw_print.Dataobject = 'd_picking_prt'
			End If
		
			lbNotBatch = True
		ElseIf lStrparms.String_Arg[1] = 'S' Then /* 09/07 - PCONKL - Just print a summary by Sku/Loc*/
			This.TriggerEvent('ue_print_Summary')
			Return
			//06-Apr-2015 :Madhu- Added 'Customer Order No' -START	
		ElseIf lstrparms.string_arg[1]='C' THEN
			idw_print.dataobject='d_picking_prt_custorder'
			//TAM 2015/04/21 - Set flag to get address infor
			lbNotBatch = True
			//06-Apr-2015 :Madhu- Added 'Customer Order No' -END
		Else /*by Zone */
			idw_print.Dataobject = 'd_batch_picking_prt'
		End IF
	End IF

ELSE
	CHOOSE CASE Upper(gs_project) 
		CASE 'MAQUET' 
			idw_print.Dataobject = 'd_maquet_batch_picking_prt'
		CASE 'STBTH' 
			idw_print.Dataobject = 'd_batch_picking_prt_starbucks'
		CASE ELSE
			idw_print.Dataobject = 'd_picking_prt_ams_muser'
			lbNotBatch = True
	END CHOOSE
END IF

SetPointer(HourGlass!)

idw_print.Reset()

ls_project_id = gs_Project
lsSkuHold = ''
lsSupplierHold = ''

// 08/00 PCONKL Show Client Name on Pick Ticket
Select Client_name into :lsClientName
From	Project with(nolock)
Where project_id = :ls_project_id
Using SQLCA;

For i = 1 to ll_cnt

	// 09/01 - PCONKL - Dont print non pickable SKUS (they are still displayed on the screen
	If idw_pick.getitemstring(i,"sku_pickable_ind") = 'N' Then Continue
	
	ls_sku = idw_pick.getitemstring(i,"sku")
	lsSupplier = idw_pick.getitemstring(i,"supp_code")
	llLine_Item_No = idw_pick.object.line_item_no[ i ]
	lsOrderNumber = idw_pick.object.invoice_no[ i ]
	
	ldtExpDate = idw_pick.getitemdateTIme(i,"expiration_Date")
	lsLocation = idw_pick.getitemstring(i,"l_code")
	
	string lsDateFind, lsCustCode,ls_altsku
	long llPrintFindRow, llQty, llCurrentQty
	
	// SANTOSH2014JAN06 Start : Chnages made to print the alternate sku
	lsFind = "invoice_no = '" + lsOrderNumber + "' and supp_code = '" + lsSupplier + "' and line_item_no = " + string( llLine_Item_No )
	llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	
	If llDetailFindRow > 0 Then
		ls_altsku = idw_detail.object.sku[ llDetailFindRow ]
	End If	
	
	if  ( ls_sku = ls_altsku) then 
		//Some fields from detail Row...
		lsFind = "invoice_no = '" + lsOrderNumber + "' and Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string( llLine_Item_No )
		llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	else
		lsFind = "invoice_no = '" + lsOrderNumber + "' and Upper(sku) = '" + Upper(ls_altsku) + "' and line_item_no = " + string( llLine_Item_No )
		llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	end if 
	
	// SANTOSH2014JAN06 End : Chnages made to pring the alternate sku
	If llDetailFindRow > 0 Then
		lsCustCode = idw_detail.object.cust_code[ llDetailFindRow ]
	End If	
	
	IF Upper(gs_project) = 'STBTH' Then	
	
		if IsNull(ldtExpDate) then
			lsDateFind = " IsNull(expiration_date) " 
		else
			lsDateFind = " string(date(expiration_date)) = '"+ string(date(ldtExpDate)) +"'" 
		end if
	
		//SANTOSH2014JUL21 -added exp date in find condition to print all rows with expiry date.
		lsFind = "Upper(cust_code) = '" + Upper(lsCustCode) + "' and Upper(supp_code) = '" + Upper(lsSupplier) + "' and Upper(sku) = '" + Upper(ls_Sku) + "' and Upper(l_code) = '" + Upper(lsLocation) + "'  and Upper(invoice_no) = '" + Upper(lsOrderNumber) + "'  and  " + (lsDateFind)
		llPrintFindRow = idw_print.Find(lsFind,1,idw_print.RowCount())
	
		If llPrintFindRow > 0 then
			llQty = idw_pick.getitemnumber(i,"quantity")
			
			If ISNull(llQty) then llQty = 0
			
			llCurrentQty = idw_print.GetItemNumber(llPrintFindRow, "quantity" ) + llQty
			idw_print.setitem(llPrintFindRow,"quantity",  llCurrentQty)
			Continue
		End If
	End IF //project = STBTH
	
	j = idw_print.InsertRow(0)
	
	if lbNOtBatch Then
		dono =  idw_pick.object.do_no[ i ]
		if dono <> donoBreak then
			//dts - 01/08 - now setting isShipRef in SetAddressData as well
			setAddressData( dono )
			donobreak=dono
		end if
	
		// delivery Order number in alternate sku
		if Upper(gs_project) =  'AMS-MUSER' then
			idw_print.object.alt_sku[ j ] = getDetailUserField1( lsOrderNumber, ls_sku,  llLine_Item_No )
		End If
	end if
	
	idw_print.setitem(j,"client_name",lsClientName) /* 08/00 PCONKL -show project name instead of code (customer sees the pick ticket)*/
	idw_print.setitem(j,"wh_code",idw_pick.getitemstring(i,"wh_Code"))
	
	//get Alternate SKU
	ls_altsku = idw_pick.getItemString( i, "alternate_sku")
	If upper(gs_project)='REMA'  and lStrparms.String_Arg[1] = 'O' Then idw_print.setItem(j, "alt_sku", ls_altsku) //10-JULY-2018 :Madhu DE5149 - REMA Alternate SKU
	
	// TAM - 2018/09/07 - S23455 -New Rema Picklist *Sort by Order
	If upper(gs_project)='REMA' and lStrparms.String_Arg[1] = 'O' then  
		idw_print.setItem(j, "client_cust_po_nbr", idw_pick.getItemString( i, "client_cust_po_nbr"))	
		idw_print.setItem(j, "schedule_date", idw_pick.getItemDateTime( i, "schedule_date"))	
	End if
	
	//Only retrieve if Sku has changed*/
	If (ls_sku <> lsSKUHold) or (lsSupplier <> lsSupplierHold) Then
	
		//See if we have it on a previous row before re-retrieving...
		lsFind = "Upper(SKU) = '" + Upper(ls_sku) + "' and upper(supp_Code) = '" + Upper(lsSUpplier) + "'"
		llFindRow = idw_print.Find(lsFind, 1, j - 1)
	
		If llFindRow > 0 and J > 1 Then
		
			ls_description = idw_print.getItemString(llFindRow,"description") 
			lsIMUser9 = idw_print.getItemString(llFindRow,"im_user_field9") 
			lsIMUser13 = idw_print.getItemString(llFindRow,"im_user_field13") 
			ldweight_1 = idw_print.getItemNumber(llFindRow,"weight_1") 
		
			IF Upper(gs_project) = 'MAQUET' THEN
				lsUOM = idw_print.getItemString(llFindRow,"im_uom") 
			END IF
		
			// For Philips-SG and Supplier SG03, populate their datawindow with hazord info
			// 04/29/11 cawikholm
			//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
			//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
			IF ((Upper(gs_project) = 'PHILIPS-SG' or Upper(gs_project) = 'PHILIPSCLS' or Upper(gs_project) = 'PHILIPS-DA') AND lsSupplier = 'SG03') THEN
				ls_hazard_class = idw_print.GetItemString(llFindRow,'hazard_class')
				ls_hazard_cd = idw_print.GetItemString(llFindRow,'hazard_cd')
			END IF
		Else
			select description, User_field9, Weight_1, User_field13, UOM_1, 
			hazard_cd, hazard_class,		//TAM 2006/06/26 Added UF13 -- Added hazard cd & class 04/29/11 cawikholm
			User_field7,user_field8,qty_3	// TAM - 2018/09/07 - S23455 -New Rema Picklist
			into 	:ls_description, :lsIMUser9, :ldweight_1, :lsIMUser13, :lsUOM, :ls_hazard_cd, :ls_hazard_class, :ls_im_uf7, :ls_im_uf8, :llqty3
			from item_master with(nolock)
			where project_id = :ls_project_id and sku = :ls_sku and supp_code = :lsSupplier;
		End If
	End If /*sku changed*/
	
	ls_description = trim(ls_description)
	
	lAddresses = getAddressData()
	if UpperBound( lAddresses.string_arg ) > 0 and lbNotBatch then
		idw_print.object.cust_name[ j ] = lAddresses.string_arg[1]
		idw_print.object.delivery_address1[ j ] = lAddresses.string_arg[2]	
		idw_print.object.delivery_address2[ j ] = lAddresses.string_arg[3]
		idw_print.object.delivery_address3[ j ] = lAddresses.string_arg[4]	
		idw_print.object.delivery_address4[ j ] = lAddresses.string_arg[5]
		idw_print.object.city[ j ] = lAddresses.string_arg[6]	
		idw_print.object.state[ j ] = lAddresses.string_arg[7]
		idw_print.object.zip_code[ j ] = lAddresses.string_arg[8]	
		idw_print.object.country[ j ] = lAddresses.string_arg[9]	
		idw_print.object.carrier[ j ] = lAddresses.string_arg[10]
	end if
	
	// 04/299/11 cawikholm - Populate hazard info for Pilips-SG - Supplier SG03
	//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
	//GailM 11/18/2020 S51441/F26536/I2978 PhilipsDA mimic PHILIPSCLS in Outbound order
	IF ((Upper(gs_project) = 'PHILIPS-SG' or Upper(gs_project) = 'PHILIPSCLS' or Upper(gs_project) = 'PHILIPS-DA') AND lsSupplier = 'SG03') THEN
		idw_print.setitem(j,"hazard_cd",ls_hazard_cd)		// 04/29/11	cawikholm
		idw_print.setitem(j,"hazard_class",ls_hazard_class)		// 04/29/11	cawikholm
 
	END IF
	
	// TAM - 2018/09/07 - S23455 -New Rema Picklist *Sort by Order
	If upper(gs_project)='REMA' and lStrparms.String_Arg[1] = 'O' then  
		If isNumber(ls_im_uf7) then
			ll_block = dec(ls_im_uf7)
		else
			ll_block = dec(ls_im_uf7)
		end If

		If isNumber(ls_im_uf8) then
			ll_tier = dec(ls_im_uf8)
		else
			ll_tier =0
		end If

		idw_print.setitem(j,"block",ll_block)		
		idw_print.setitem(j,"tier",ll_tier)	
		idw_print.setitem(j,"pallet_total",llqty3)
	
		long llMod		
		llQty = idw_pick.getitemnumber(i,"quantity")
		if llqty3>0 and not isnull(llqty3)and ll_tier > 0  and not isnull(ll_tier) then   //im.qty3 and im.uf8 must be filled in to do the calculations to prevent a divide by zero. if either is zero set pallet and layer to zeros and set cases to picked qty.  
			ll_pallet = llQty / llqty3
			llMod = Mod( llQty, llqty3)
			if llMod = 0 then //No remainer = full pallet
				ll_layer = 0
				ll_cases = 0
			else
				ll_layer = llMod / ll_tier
				ll_cases = Mod (llMod , ll_tier)
			end if
		else
			ll_pallet = 0
			ll_layer = 0
			ll_cases = llQty
		end if	
	
		idw_print.setitem(j,"pallet_qty",ll_pallet)		
		idw_print.setitem(j,"layer_qty",ll_layer)	
		idw_print.setitem(j,"case_qty",ll_cases)
		idw_print.setitem(j,"total_wgt", llQty * ldweight_1)
	
	End If
	
	//From detail row...
	If llDetailFindRow > 0 Then
		idw_print.setitem(j,"cust_code",idw_detail.object.cust_code[ llDetailFindRow ])
	End If

	idw_print.setitem(j,"project_id",Upper(gs_project))
	idw_print.setitem(j,"batch_id",idw_pick.getitemnumber(i,"batch_Pick_id"))
	//Begin - Dinesh - 06/03/2021- S57912- PhilipsCLS GSIN and Batch Picking
	IF upper(gs_project)='PHILIPSCLS' then
	
		ldsNotes = Create DataStore
		ldsNotes.dataobject = 'd_dono_notes'
		ldsNotes.SetTransObject(SQLCA)
				  
		lsDONO = this.idw_pick.GetItemString(i,'do_no')
		
		if lsDONOPREVIOUS <> lsDONO then
			lsNotes = ""
								 
				llNotesCount = ldsNotes.Retrieve(gs_project,lsDONO)
			
				For llNotesPos = 1 to llNotesCount
														
							//Only want header notes
							 If ldsNotes.GetItemNumber(llNotesPos,'line_item_No') = 0 Then
										  lsNotes += ldsNotes.GetITemString(llNotesPos,'note_text') + " "
							End If		
													  
				 Next
				 lsDONOPREVIOUS=lsDONO
			else
			end if
			  
			 If lsNotes > '' Then
				  idw_print.Modify("delivery_notes_t.text = '" + lsNotes + "'")
			 End If
			  
				idw_print.setitem(j,"ord_date",idw_pick.getitemdatetime(i,"ord_date")) 
				idw_print.setitem(j,"request_date",idw_pick.getitemdatetime(i,"request_date"))
				
	End if
	//End - Dinesh - 06/03/2021- S57912- PhilipsCLS GSIN and Batch Picking
	
	If gs_project = "STBTH" Then
		idw_print.setitem(j,"batch_ref_nbr",idw_master.getitemstring(1,"batch_ref_nbr"))
	End If
	
	idw_print.setitem(j,"invoice_no",idw_pick.getitemstring(i,"invoice_no"))
	idw_print.setitem(j,"cust_ord_no",idw_pick.getitemstring(i,"cust_order_no"))
	//idw_print.setitem(j,"cust_code",idw_pick.getitemstring(i,"cust_code"))
	idw_print.setitem(j,"sku",idw_pick.getitemstring(i,"sku"))
	idw_print.setitem(j,"sku_parent",idw_pick.getitemstring(i,"sku_Parent"))
	idw_print.setitem(j,"supp_code",idw_pick.getitemstring(i,"supp_code"))
	idw_print.setitem(j,"description",ls_description)
	idw_print.setitem(j,"im_user_field9",lsimuser9) /* only visible for Saltillo as defined in DW properties*/
	idw_print.setitem(j,"weight_1",ldweight_1) /* GAP 09/2002 */
	idw_print.setitem(j,"serial_no",idw_pick.getitemstring(i,"serial_no"))
	idw_print.setitem(j,"lot_no",idw_pick.getitemstring(i,"lot_no"))
	idw_print.setitem(j,"po_no",idw_pick.getitemstring(i,"po_no"))
	idw_print.setitem(j,"po_no2",idw_pick.getitemstring(i,"po_no2")) 
	idw_print.setitem(j,"container_ID",idw_pick.getitemstring(i,"Container_ID")) /* 11/02 - PCONKL */
	idw_print.setitem(j,"expiration_date",idw_pick.getitemdateTIme(i,"expiration_Date")) /* 11/02 - PCONKL */
	idw_print.setitem(j,"l_code",idw_pick.getitemstring(i,"l_code"))
	
	//24-APR-2019 :Madhu S32728 F15511 - Print Header Information - START
	IF idw_print.dataobject='d_picking_prt' THEN
	
		idw_print.setItem(j, "consolidation_no", idw_pick.getItemString(i, "consolidation_no"))
		idw_print.setItem(j, "ord_date", idw_pick.getItemDateTime(i, "ord_date"))
		idw_print.setItem(j, "dm_user_field2", idw_pick.getItemString(i, "dm_user_field2"))
		idw_print.setItem(j, "dm_user_field3", idw_pick.getItemString(i, "dm_user_field3"))
		idw_print.setItem(j, "request_date", idw_pick.getItemDateTime(i, "request_date"))
		idw_print.setItem(j, "priority", idw_pick.getItemString(i, "priority"))
	
	ELSEIF idw_print.dataobject ='d_picking_prt_custorder' THEN
	
		idw_print.setItem(j, "ord_date", idw_pick.getItemDateTime(i, "ord_date"))
		idw_print.setItem(j, "request_date", idw_pick.getItemDateTime(i, "request_date"))
		idw_print.setItem(j, "priority", idw_pick.getItemString(i, "priority"))
		idw_print.setItem(j, "dm_user_field1", idw_pick.getItemString(i, "dm_user_field1"))
		idw_print.setItem(j, "dm_user_field2", idw_pick.getItemString(i, "dm_user_field2"))
	END IF
	//24-APR-2019 :Madhu S32728 F15511 - Print Header Information - END
	
	//09-Oct-2015 :Madhu - "Page Break By Zone" is checked, Print Zone Id on Pick List - START
	If  Upper(gs_project) <>  'AMS-MUSER' AND Upper(gs_project) <>  'MAQUET' AND  Upper(gs_project) <> 'STBTH'   THEN
		IF	lstrparms.boolean_arg[1]=TRUE THEN
			idw_print.setitem(j,"zone_id",idw_pick.getitemstring(i,"zone_id"))
		End If
	End If
	//09-Oct-2015 :Madhu - "Page Break By Zone" is checked, Print Zone Id on Pick List - END
	
	idw_print.setitem(j,"quantity",idw_pick.getitemnumber(i,"quantity"))
	idw_print.setitem(j,"component_no",idw_pick.getitemnumber(i,"component_no"))
	
	//sarun2013sep26:Start Added remark from individual order if report is sort on ORDER 
	///TAM 2015/04/21: Added Special Instructions from individual order if report is sort on ORDER and CUSTOMER ORDER
	if (idw_print.Dataobject = 'd_picking_prt' or idw_print.Dataobject = 'd_picking_prt_custorder' ) and llDetailFindRow > 0 Then
		idw_print.setitem(j,"remark",idw_detail.object.remark[ llDetailFindRow ])
	end If
	//sarun2013sep26:End
	
	///TAM 2015/04/21: Added Special Instructions from individual order if report is sort on ORDER 
	if (idw_print.Dataobject = 'd_picking_prt' or idw_print.Dataobject = 'd_picking_prt_custorder' ) and llDetailFindRow > 0 Then
	idw_print.setitem(j,"shipping_instructions",idw_detail.object.shipping_instructions[ llDetailFindRow ])
	end If
	
	idw_print.setitem(j,"ship_ref_nbr", isShipRef)
	
	If Upper(gs_project) = 'MAQUET' Then /* 11/08 - MEA*/
		idw_print.setitem(j,"dm_user_field13",idw_pick.getitemstring(i,"user_field13"))
		idw_print.setitem(j,"im_uom", lsUOM)
	End IF
	
	idw_print.setitem(j,"pick_as",idw_pick.getitemstring(i,"user_field2")) /* 11/00 PCONKL - show pick iterations*/
	ls_inventory_type = idw_pick.getitemstring(i,"inventory_type")
	
	If ls_inventory_type <> lsInvTypeHold Then
	
	SELECT Inv_Type_Desc into :ls_inventory_type_desc  
	FROM Inventory_Type  with(nolock)
	where Inv_Type = :ls_inventory_type and Project_id = :gs_project; /* 12/00 PCONKL - Inventory Type is now project specific*/
	
	lsInvTypeHold = ls_inventory_type
	
	End IF
	
	ls_inventory_type_desc = trim(ls_inventory_type_desc) 
	idw_print.setitem(j,"inventory_type", ls_inventory_type_desc )
	ls_loc_code = idw_pick.object.l_code[i]
	ls_whCode   = idw_pick.object.wh_code[i]
	
	IF i_nwarehouse.inv_common_tables.of_select_location(ls_whCode,ls_loc_code) = 1 THEN
		idw_print.setitem(j,'picking_seq',i_nwarehouse.inv_common_tables.id_picking_seq)
	END IF			
	
	// 08/11 - PCONKL - Moved here from above
	lsSkuHold = ls_Sku
	lsSUpplierHold = lsSupplier
	ls_do_no_Hold =  ls_do_no

NEXT /*Pick Row*/

// SARUN2014NOV11 : Start : Adding BarCode to StarBucks PickingList

long ll_printrow,ll_printcount
ll_printcount = idw_print.rowcount()

IF gs_project = 'STBTH'  THEN

for ll_printrow = 1 to ll_printcount
lscst =idw_print.getitemstring(ll_printrow,"cust_code")
ls_batch = 	String(llBatchPickID)
ll_sumcnt = lds_custsumm.retrieve(ls_batch,lscst)

for k = 1 to ll_sumcnt 
ls_inv = lds_custsumm.getitemstring(k,'invoice_no') +'/' + String(lds_custsumm.getitemnumber(k,'tot_qty')) 
idw_print.setitem(ll_printrow,'barcd' + String(k) , ls_inv)
next 

idw_print.setitem(ll_printrow,"cust_code",lscst)	
NEXT

//SARUN2015JUNE30 :Adeed code to height of the summary band as the count of the order 
long ll_height
select MAX(cnt) into :ll_height from
(
select Cust_Code,count(*) cnt
from Delivery_Master dm with(nolock)
where Project_Id = 'stbth' 
and Batch_Pick_Id =:llBatchPickID
group by batch_pick_id,Cust_Code
) a;

ll_height = ll_height * 3500

idw_print.Modify("DataWindow.Trailer.1.Height="+string(ll_height))	

END IF
// SARUN2014NOV11 : End : Adding BarCode to StarBucks PickingList


idw_print.Sort()
idw_print.GroupCalc()

OpenWithParm(w_dw_print_options,idw_print) 

// 12/14 - PCONKL - Flag records as printed. We will allow an order to be dropped from the batch until the Pick List has actually been printed
IF message.doubleparm = 1 THEN

llBatchPickID = idw_MAster.GetITemNumber(1,'Batch_Pick_ID')

// 01/14 - PCONKL - update print count
Execute Immediate "Begin Transaction" using SQLCA;

Update Delivery_MAster
Set pick_list_print_Count = 0
where Project_id = :gs_Project and batch_Pick_ID = :llBatchPickID and Pick_List_Print_Count is null;

Update Delivery_master
Set pick_list_print_Count = ( pick_list_print_Count + 1 ) where Project_id = :gs_Project and batch_Pick_ID = :llBatchPickID;

Execute Immediate "COMMIT" using SQLCA;

idw_detail.Retrieve()
idw_detail.GroupCalc()

End IF
end event

event close;call super::close;if isValid( idsDeliveryMaster) then destroy idsDeliveryMaster 

end event

type tab_main from w_std_master_detail`tab_main within w_batch_pick
integer y = 12
integer width = 3890
integer height = 2332
tabpage_order_detail tabpage_order_detail
tabpage_pick tabpage_pick
tabpage_pack tabpage_pack
tabpage_trax tabpage_trax
end type

on tab_main.create
this.tabpage_order_detail=create tabpage_order_detail
this.tabpage_pick=create tabpage_pick
this.tabpage_pack=create tabpage_pack
this.tabpage_trax=create tabpage_trax
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_order_detail,&
this.tabpage_pick,&
this.tabpage_pack,&
this.tabpage_trax}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_order_detail)
destroy(this.tabpage_pick)
destroy(this.tabpage_pack)
destroy(this.tabpage_trax)
end on

event tab_main::selectionchanged;call super::selectionchanged;

Choose Case newIndex
	Case 1 /*Batch Info Tab*/
		idw_current = idw_master
	Case 2 /*Order Other Tab*/
		idw_current = idw_detail
	Case 3 /*Pick Detail Tab*/
		//ilHelpTopicID = 554
		idw_current = idw_pick
	Case 4 /*pack List*/
		idw_current = idw_Pack
		if Upper(Left(gs_project,4)) <> 'GM_M' then w_batch_pick.tab_main.tabpage_pack.em_carrier_ship_date.text = string(Today ( )) 
		
		// DW is shared with Packing DW bu we only want to show 1 record per carton
		idw_pack.SetFilter("")
		idw_pack.Filter()
		
	Case 5 /*Trax*/
		// DW is shared with Packing DW bu we only want to show 1 record per carton
		idw_trax.SetFilter("c_dup_filter = 'N'")
		idw_trax.Filter()
		wf_load_trax_Printer_list() /* 02/11 - PCONKL */
	Case Else
		idw_current = idw_result
End Choose


		
		
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 3854
integer height = 2204
string text = "Batch Info"
cb_batch cb_batch
cb_cust cb_cust
st_batch_pick_id_t st_batch_pick_id_t
sle_batch_id sle_batch_id
cb_confirm cb_confirm
cb_generate cb_generate
dw_batch_master dw_batch_master
end type

on tabpage_main.create
this.cb_batch=create cb_batch
this.cb_cust=create cb_cust
this.st_batch_pick_id_t=create st_batch_pick_id_t
this.sle_batch_id=create sle_batch_id
this.cb_confirm=create cb_confirm
this.cb_generate=create cb_generate
this.dw_batch_master=create dw_batch_master
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
this.Control[iCurrent+2]=this.cb_cust
this.Control[iCurrent+3]=this.st_batch_pick_id_t
this.Control[iCurrent+4]=this.sle_batch_id
this.Control[iCurrent+5]=this.cb_confirm
this.Control[iCurrent+6]=this.cb_generate
this.Control[iCurrent+7]=this.dw_batch_master
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_batch)
destroy(this.cb_cust)
destroy(this.st_batch_pick_id_t)
destroy(this.sle_batch_id)
destroy(this.cb_confirm)
destroy(this.cb_generate)
destroy(this.dw_batch_master)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 3854
integer height = 2204
cb_confirmall cb_confirmall
cb_clearall cb_clearall
cb_selectall cb_selectall
cb_2 cb_2
cb_search cb_search
dw_result dw_result
dw_search dw_search
end type

on tabpage_search.create
this.cb_confirmall=create cb_confirmall
this.cb_clearall=create cb_clearall
this.cb_selectall=create cb_selectall
this.cb_2=create cb_2
this.cb_search=create cb_search
this.dw_result=create dw_result
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_confirmall
this.Control[iCurrent+2]=this.cb_clearall
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_search
this.Control[iCurrent+6]=this.dw_result
this.Control[iCurrent+7]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_confirmall)
destroy(this.cb_clearall)
destroy(this.cb_selectall)
destroy(this.cb_2)
destroy(this.cb_search)
destroy(this.dw_result)
destroy(this.dw_search)
end on

type cb_batch from commandbutton within tabpage_main
integer x = 2551
integer y = 2060
integer width = 443
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Batch Report"
end type

event clicked;//Jxlim 11/22/2010 open comcast sik batch report window
str_parms	lStrparms
//OpenWithParm(w_comcast_sik_batch_report,lStrparms)
OpenSheetwithparm(w_comcast_sik_batch_report,lstrparms, w_main,gi_menu_pos, Original!)

end event

type cb_cust from commandbutton within tabpage_main
integer x = 366
integer y = 668
integer width = 320
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Customer:"
end type

event clicked;
Str_parms	lstrparms
long ll_rowcount, llPos,llCount
String	lsCust

// 11/00 PCONKL - Select a customer from popup
// 05/13 - PCONKL - we are now allowing multiple customers to be selected

//If we already have orders generated, we need to warn about changing criteria
If idw_Detail.RowCount() > 0 Then
			
	If Not ibbatchCriteriaChanged Then /*only need to display msg once*/
		If MessageBox(is_title,'If you change the Batch Criteria after previously generating the Batch,~rYou will need to re-generate the batch before saving.~r~rDo you want to continue?',StopSign!,YesNo!,2) = 2 Then
			Return 
		Else
			ibbatchCriteriaChanged = True
		End If
	End If
			
End If /*details exist*/

Open(w_select_customer)
lstrparms = message.PowerobjectParm

If Not lstrparms.Cancelled Then
	
	// 05/13 - PCONKL - Allowing multiple customers to be selected
	If upperbound( Lstrparms.String_arg) > 0 Then
		
		If Lstrparms.String_arg[1] > '' Then
		
			SetPointer(Hourglass!)
		
			llCount = upperbound( Lstrparms.String_arg)
			for llPos = 1 to llCount
				lsCust += lstrparms.String_arg[llPos] + ","
			Next
		
			lsCust = left(lsCust,Len(lsCust) - 1)
			idw_master.SetItem(1,"cust_code",lsCust)
		
		End If
		
	End If
	
End If
end event

type st_batch_pick_id_t from statictext within tabpage_main
integer x = 50
integer y = 84
integer width = 453
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Batch Pick ID:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_batch_id from singlelineedit within tabpage_main
integer x = 507
integer y = 76
integer width = 512
integer height = 76
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;//Begin - Dinesh - 06/03/2021- S57912- PhilipsCLS GSIN and Batch Picking
datawindowchild ldwc,ldwc2,ldwc3,ldwc4
IF Upper(gs_project) = 'PHILIPSCLS' Then	
	tab_main.tabpage_main.dw_batch_master.dataobject='d_batch_pick_info_philipscls' 
	tab_main.tabpage_main.dw_batch_master.settrans(sqlca)
	
		tab_main.tabpage_main.dw_batch_master.GetChild('ord_type',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve(gs_project)
		End If
		
		tab_main.tabpage_main.dw_batch_master.GetChild('carrier',ldwc2)
		ldwc2.SetTransObject(SQLCA)
		if ldwc2.RowCount() = 0 then
			ldwc2.Retrieve(gs_project)
		End If
		
		tab_main.tabpage_main.dw_batch_master.GetChild('customer_type',ldwc3)
		ldwc3.SetTransObject(SQLCA)
		if ldwc3.RowCount() = 0 then
			ldwc3.Retrieve()
			ldwc3.SetFilter("project_id = '" + gs_project + "'")
			ldwc3.Filter()
		End If
		
		tab_main.tabpage_main.dw_batch_master.GetChild('wh_code',ldwc4)
		ldwc4.SetTransObject(SQLCA)
		if ldwc4.RowCount() = 0 then
			ldwc4.Retrieve(gs_project)
		End If
End if
//End - Dinesh - 06/03/2021- S57912- PhilipsCLS GSIN and Batch Picking		
iw_window.TriggerEvent('ue_retrieve')
end event

event getfocus;If This.text <> '' then
	This.SelectText(1, Len(Trim(This.Text)))
end If
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 1938
integer y = 2060
integer width = 402
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Confirm"
end type

event clicked;
iw_window.TriggerEvent('ue_confirm')
end event

type cb_generate from commandbutton within tabpage_main
integer x = 923
integer y = 2060
integer width = 402
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;
iw_window.TriggerEvent('ue_generate_batch')
end event

type dw_batch_master from u_dw_ancestor within tabpage_main
integer x = 14
integer y = 48
integer width = 3730
integer height = 1980
string dataobject = "d_batch_pick_info"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
//We will only populate dropdowns as they are needed (clicked on)



datawindowChild	ldwc

Choose Case Upper(dwo.name)
		
	Case 'ORD_TYPE'
		
		This.GetChild('ord_type',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve(gs_project)
		End If
		
	Case 'CARRIER'
		
		This.GetChild('carrier',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve(gs_project)
		End If
		
	Case 'CUSTOMER_TYPE'
		
		This.GetChild('customer_type',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve()
			ldwc.SetFilter("project_id = '" + gs_project + "'")
			ldwc.Filter()
		End If
	
					
End Choose
end event

event itemchanged;call super::itemchanged;Long	llCount

ib_changed = True

Choose CAse Upper(dwo.Name)
	//Jxlim 04/19/2013 Physio PHC-CR13-034 Add 1 line orders to batch selection; leveraging for baseline
	//If the criteria has changed after we created the batch, must re-generate before saving
	Case 'ORD_TYPE', 'CUST_CODE','CUSTOMER_TYPE', 'CARRIER', 'WH_CODE', 'INVOICE_NO_FROM', 'INVOICE_NO_TO', 'LINE_iTEM_COUNT'
		
		// pvh gmt 12/28/05 - set the warehouse
		If Upper(dwo.Name) = 'WH_CODE' Then setWarehouse( data )
		
		//Validate Cust Code
		// 05/13 - PCONKL - allowing multiple customers to be entered comma seperated, don't validate if multiple customers entered
		If Upper(dwo.Name) = 'CUST_CODE' Then			
			
			if Pos(data,',') = 0 Then
				
				Select Count(*) into :llCount
				From Customer
				Where Project_id = :gs_Project and Cust_Code = :data;
			
				If llCount < 1 Then
					Messagebox(is_title, "Invalid Customer Code!")
					Return 1
				End If			
				
			End If
			
		End If
		
		If idw_Detail.RowCount() > 0 Then
			
			If Not ibbatchCriteriaChanged Then /*only need to display msg once*/
				If MessageBox(is_title,'If you change the Batch Criteria after previously generating the Batch,~rYou will need to re-generate the batch before saving.~r~rDo you want to continue?',StopSign!,YesNo!,2) = 2 Then
					Return 1
				Else
					ibbatchCriteriaChanged = True
				End If
			End If
			
		End If /*details exist*/
		
	// 07/19/2010 ujhall: 02 of 12 Comcast SIK Batch Picking: Make sure when SKU goes blank, so does qty_for_sku
	case 'SKU'
		if  data = '' Then
			idw_master.SetItem(1,'qty_for_sku', 0)
			idw_Master.Object.qty_for_sku.protect = 1
		else
			idw_Master.Object.qty_for_sku.protect = 0
		end if
		
			// 07/19/2010 ujhall: 03 of 12 Comcast SIK Batch Picking:
	case 'ORDERS_FOR_BATCH'
		If not isNumber(data) Then
			this.SetItem(row,'orders_for_batch', 0)
			idw_master.SelectText(1,1)
			return 1
		else
			this.accepttext()
			return 0
		end if
		
End Choose
end event

event itemerror;call super::itemerror;return 2
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event constructor;call super::constructor;
// 11/13 - PCONKL - Hiding cart status stuff for no Physio, Cust 2 will get a project level indicator
If gs_project = 'PHYSIO-MAA' or gs_project = 'PHYSIO-XD' Then
Else
	This.Modify("item_ugly_ind.visible=0 gb_ugly.visible=0 pick_cart_status.visible=0 pick_Cart_status_t.visible=0")
End If


end event

type cb_confirmall from commandbutton within tabpage_search
integer x = 786
integer y = 1764
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Confirm All"
end type

event clicked;// GMOR 12/20/2010 - Cloned from ue_confirm with changes for multiple batch confirm
//Confirm all outbound orders that we picked.

Long	llRowCount, llRowPos, llBatchPickID, llTransCount
Long  llPickCount, llOrderQty, lldbQty, llNull[]   
int     ilResult		
Boolean	lbOverPick, lbUnderPick
DateTime	ldtTodaydatetime, ldtGMTToday
string lsOrdStat, lsDONO, lsOrder, lsPrevDONO, lsTransID //Oct'07 - for creating batch_transactions for AMS-MUSER
string lsPrevOrder, lsCurOrder, lsMsg, lsResults[]

llTransCount = 0
il_BatchPickIDs[] = llNull[]
llRowCount = idw_Result.RowCount()
for llRowPos = 1 to llRowCount
	if idw_Result.GetItemString(llRowPos,"c_apply_ind") = "Y" then
		llTransCount = llTransCount + 1
		il_BatchPickIDs[llTransCount] = idw_Result.GetItemNumber(llRowPos,"batch_pick_id")
	end if
next

llRowCount = uf_get_order_data()
if llRowCount = -1 then
	lsMsg = "An error occrurred while getting these batch orders"
	MessageBox("Batch Picking Confirmations Error", lsMsg, StopSign!)
elseif llRowCount = -2 then
	lsMsg =  "        Could not continue with confirmations.~r~r" + &
				"Not all welcome letters and/or ConnectShip  labels have been printed.~r~r" + &
				"     Please complete this step before confirming batches" // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip 
	MessageBox("Batch Picking Confirmation Stopped", lsMsg, StopSign!)
elseif llRowCount = -3 then
	lsMsg =  "        Could not continue with confirmations~r~r" + &
				"Not all serial detail records are present when required~r~r" + &
				"  Please complete this step before confirming batches"
	MessageBox("Batch Picking Confirmation Stopped", lsMsg, StopSign!)
elseif llRowCount = -4 then
	lsMsg =  "                Could not continue with confirmations~r~r" + &
				"Not all welcome letters and/or Trax labels have been printed~r" + &
				"   Not all serial detail records are present when required~r~r" + &
				"     Please complete these steps before confirming batches"
	MessageBox("Batch Picking Confirmation Stopped", lsMsg, StopSign!)
elseif llRowCount = 0 then
	lsMsg = "There are no orders for this/these batche(s)"
	MessageBox("Batch Picking Confirmations Ended", lsMsg, Exclamation!)
else	
	// Ready to confirm
	if messagebox(is_title,"Are you sure you want to confirm these " + string(llRowCount) + " orders?~r~r" + &
			"ALL Delivery Orders for these batches will be confirmed as well.",Question!,YesNo!,2) = 2 then
		return
	End if
	// Question for Pete - Should we validate that serial numbers exists for SIK picking list when outbound order requires SNs?
	// Put that code here
	
	SetMicroHelp("Confirming batches")
	lsMsg = "Confirmation results:"
	
	// Loop through batches, set Delivery Status to Confirmed and set Complete Date
	llRowCount = UpperBound(il_BatchPickIDs[])
	for llRowPos = 1 to llRowCount
		llBatchPickID  = il_BatchPickIDs[llRowPos]
		ldtGMTToday = f_getLocalWorldTime( getWarehouse() )
		SetMicroHelp("Confirming Batch Pick ID: " + String(llBatchPickID))

		Execute Immediate "Begin Transaction" using SQLCA; 
		
		Update Delivery_Master
		Set ord_status = 'C', Complete_Date = :ldtGMTToday, Last_User = :gs_userID, last_update = :ldtGMTToday
		Where Project_id = :gs_project and batch_Pick_id = :llBatchPickID and ord_status = 'A'
		Using SQLCA;
		
		If sqlca.sqlcode >=0 Then
			// Update dw_result status to complete 
			Update Batch_Pick_Master
			Set batch_status = 'C', pick_complete = :ldtGMTToday, Last_User = :gs_userID, last_update = :ldtGMTToday
			Where Project_id = :gs_project and batch_pick_id = :llBatchPickID
			Using SQLCA;
			
			If sqlca.sqlcode >= 0 Then
				// Create Batch Transactions....
				ilResult = uf_Create_Batch_Transactions(llBatchPickID, ldtGMTToday)
				
				//Execute Immediate "ROLLBACK" using SQLCA;		// Rollback while testing
				Execute Immediate "COMMIT" using SQLCA;
				If SQLCA.SQLCode = 0 Then
					lsMsg += "~rOrders confirmed for Batch Pick ID: " + String(llBatchPickID) + "."
				End if
			Else
				Execute Immediate "ROLLBACK" using SQLCA;
				lsResults[llRowPos] = "~rBatch Pick ID: " + String(llBatchPickID) + " confirm orders failed: " + SQLCA.SQLErrText
			End if
   		Else /*commit failed*/
			Execute Immediate "ROLLBACK" using SQLCA;
			lsResults[llRowPos] = "~rBatch Pick ID: " + String(llBatchPickID) + " confirm orders failed: " + SQLCA.SQLErrText
		End if

	next
	idw_Result.Retrieve()
	SetMicroHelp("Ready")
	
	MessageBox("Batch Pick Confirmation", lsMsg)
	lsMsg = ""
	
end if




end event

type cb_clearall from commandbutton within tabpage_search
integer x = 402
integer y = 1764
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;int li_cnt, li_row

li_cnt = idw_result.RowCount()
li_row = 1

for li_row = 1 to li_cnt
	if idw_result.GetItemString(li_row,"batch_status") = "A" then
		idw_result.SetItem(li_row,"c_apply_ind","N")
	end if
next
	
// Disable Confirm All button
tab_main.tabpage_search.cb_confirmall.enabled=false

end event

type cb_selectall from commandbutton within tabpage_search
integer x = 18
integer y = 1764
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;int li_cnt, li_row

li_cnt = idw_result.RowCount()
li_row = 1

for li_row = 1 to li_cnt
	if idw_result.GetItemString(li_row,"batch_status") = "A" then
		idw_result.SetItem(li_row,"c_apply_ind","Y")
	end if
next

// Enable Confirm All button
tab_main.tabpage_search.cb_confirmall.enabled=true


end event

type cb_2 from commandbutton within tabpage_search
integer x = 3314
integer y = 140
integer width = 288
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
idw_search.Reset()
idw_search.InsertRow(0)

idw_result.Reset()
end event

type cb_search from commandbutton within tabpage_search
integer x = 3314
integer y = 28
integer width = 288
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
idw_result.TriggerEvent('ue_retrieve')
end event

type dw_result from u_dw_ancestor within tabpage_search
integer x = 18
integer y = 468
integer width = 3419
integer height = 1244
integer taborder = 30
string dataobject = "d_batch_pick_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;call super::ue_retrieve;String	lsNewSQL,	&
			lsTemp
			
lsNewSql = isOrigSQl_Search

If idw_search.AcceptText() < 0 Then Return

//Always Include Project in Search
lsNewSQL += " Where project_id = '" + gs_project + "'"

//Include Batch Number if Present
If idw_search.getItemNumber(1,'batch_nbr') > 0 Then
	lsNewSql += " and batch_pick_id = " + String(idw_search.getItemNumber(1,'batch_nbr'))
End If

//Include Batch Status if Present
If idw_search.getItemString(1,'batch_status') > '' Then
	lsNewSql += " and batch_status = '" + idw_search.getItemString(1,'batch_status') + "'"
End If

//Include Carrier if Present
If idw_search.getItemString(1,'carrier') > '' Then
	lsNewSql += " and carrier = '" + idw_search.getItemString(1,'carrier')+ "'"
End If

// 12/10 - PCONKL - Include Warehouse if Present
If idw_search.getItemString(1,'wh_code') > '' Then
	lsNewSql += " and wh_code = '" + idw_search.getItemString(1,'wh_code') + "'"
End If

//Include Customer Type if Present
If idw_search.getItemString(1,'customer_Type') > '' Then
	lsNewSql += " and customer_type = '" + idw_search.getItemString(1,'Customer_Type') + "'"
End If

//Include Customer Code if Present
If idw_search.getItemString(1,'cust_code') > '' Then
	lsNewSql += " and cust_code = '" + idw_search.getItemString(1,'cust_code') + "'"
End If


//Include Order Type if Present
If idw_search.getItemString(1,'Order_Type') > '' Then
	lsNewSql += " and Ord_type = '" + idw_search.getItemString(1,'Order_Type') + "'"
End If

//Include Pick Start if Present
If  Not IsNull(idw_search.GetItemDateTime(1,"pick_start")) Then
	lsNewSql += " and pick_start >= '" + 	String(idw_search.GetItemDateTime(1,"pick_start"), "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Include Pick Complete if Present
If  Not IsNull(idw_search.GetItemDateTime(1,"pick_complete")) Then
	lsNewSql += " and pick_complete <= '" + 	String(idw_search.GetItemDateTime(1,"pick_complete"), "yyyy-mm-dd hh:mm:ss") + "' "
End If

// 09/09 - PCONKL - Include Batch Ref Nbr if Present
If idw_search.getItemString(1,'batch_ref_nbr') > '' Then
	lsNewSql += " and batch_ref_nbr = '" + idw_search.getItemString(1,'batch_ref_nbr') + "'"
End If

// 09/09 - PCONKL - Include Supplier Code if Present
If idw_search.getItemString(1,'supp_Code') > '' Then
	lsNewSql += " and Supp_Code = '" + idw_search.getItemString(1,'supp_Code') + "'"
End If

// 09/09 - PCONKL Include Order Date Start if Present
If  Not IsNull(idw_search.GetItemDateTime(1,"ord_date_From")) Then
	lsNewSql += " and ord_date_from >= '" + 	String(idw_search.GetItemDateTime(1,"ord_date_From"), "yyyy-mm-dd hh:mm:ss") + "' "
End If

//09/09 - PCONKL Include Order Date To if Present
If  Not IsNull(idw_search.GetItemDateTime(1,"ord_Date_to")) Then
	lsNewSql += " and ord_date_to <= '" + 	String(idw_search.GetItemDateTime(1,"ord_Date_to"), "yyyy-mm-dd hh:mm:ss") + "' "
End If

//Include Order Number if Present
If idw_search.getItemString(1,'Order_nbr') > '' Then
	lsNewSql += " and Batch_Pick_id in (select Batch_pick_id from Delivery_MASter where project_id = '" + gs_project + "' and Invoice_no = '" + idw_search.getItemString(1,'order_nbr') + "')"
End If

//Include SKU if Present
If idw_search.getItemString(1,'sku') > '' Then
	lsNewSql += " and Batch_Pick_id in (select Batch_pick_id from Delivery_Picking where sku = '" + idw_search.getItemString(1,'sku') + "')"
End If

This.SetSqlSelect(lsNewSQL)
This.Retrieve()

If This.RowCount() <= 0 Then
	Messagebox(is_title,'No records found matching your criteria.')
End If
end event

event clicked;call super::clicked;String ls_status
int li_selected_row, li_nbr_rows, li_cnt, li_i

li_nbr_rows = idw_result.RowCount()
li_selected_row = row
li_cnt = 0

	//If row is clicked then highlight the row
	IF li_selected_row > 0 THEN
		This.SelectRow(0, FALSE)
		This.SelectRow(li_selected_row, TRUE)
	END IF
	
if li_selected_row > 0 and li_selected_row <= li_nbr_rows then
	// Get Row Status (Only Packing Status may be checked
	ls_status = GetItemString(li_selected_row,"batch_status")
	
	//Change c_apply_ind checkbox if row clicked and status is Packing
	if ls_status = "A" then
		if idw_result.GetItemString(li_selected_row,"c_apply_ind") = "N" then
			idw_result.SetItem(li_selected_row,"c_apply_ind","Y")
		else
			idw_result.SetItem(li_selected_row,"c_apply_ind","N")
		end if	
	end if
end if

for li_i = 1 to li_nbr_rows 
	if GetItemString(li_i,"c_apply_ind") = "Y" then li_cnt = li_cnt + 1
next
//messagebox("dwResultMessage","NbrApplyInd:"+string(li_cnt))

if li_cnt = 0 then 
	tab_main.tabpage_search.cb_confirmall.enabled = false
else
	tab_main.tabpage_search.cb_confirmall.enabled = true
end if

idw_result.AcceptText()

end event

event doubleclicked;call super::doubleclicked;If row > 0 Then
	iw_window.Trigger Event ue_edit()
	If not ib_changed Then
		isle_batch_id.Text = String(This.GetItemNumber(row,'batch_pick_ID'))
		isle_batch_id.Trigger Event Modified()
	End If
End If
end event

type dw_search from datawindow within tabpage_search
integer x = 18
integer y = 20
integer width = 3584
integer height = 436
integer taborder = 20
string title = "none"
string dataobject = "d_batch_pick_search"
boolean border = false
boolean livescroll = true
end type

event clicked;//We will only populate dropdowns as they are needed (clicked on)

datawindowChild	ldwc

Choose Case Upper(dwo.name)
		
	Case 'ORDER_TYPE'
		
		This.GetChild('order_type',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve(gs_project)
		End If
		
	Case 'CARRIER'
		
		This.GetChild('carrier',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve(gs_project)
		End If
		
	Case 'CUSTOMER_TYPE'
		
		This.GetChild('customer_type',ldwc)
		ldwc.SetTransObject(SQLCA)
		if ldwc.RowCount() = 0 then
			ldwc.Retrieve()
			ldwc.SetFilter("project_id = '" + gs_project + "'")
			ldwc.Filter()
		End If
					
End Choose
end event

type tabpage_order_detail from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3854
integer height = 2204
long backcolor = 79741120
string text = "Order Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
em_delivery_dt em_delivery_dt
cb_update_delivery_dt cb_update_delivery_dt
cb_remove_orders cb_remove_orders
dw_batch_details dw_batch_details
end type

on tabpage_order_detail.create
this.em_delivery_dt=create em_delivery_dt
this.cb_update_delivery_dt=create cb_update_delivery_dt
this.cb_remove_orders=create cb_remove_orders
this.dw_batch_details=create dw_batch_details
this.Control[]={this.em_delivery_dt,&
this.cb_update_delivery_dt,&
this.cb_remove_orders,&
this.dw_batch_details}
end on

on tabpage_order_detail.destroy
destroy(this.em_delivery_dt)
destroy(this.cb_update_delivery_dt)
destroy(this.cb_remove_orders)
destroy(this.dw_batch_details)
end on

type em_delivery_dt from editmask within tabpage_order_detail
integer x = 2501
integer y = 12
integer width = 599
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
boolean dropdowncalendar = true
end type

type cb_update_delivery_dt from commandbutton within tabpage_order_detail
integer x = 1915
integer y = 12
integer width = 576
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update Delivery DT:"
end type

event clicked;
DAte	ldtDeliveryDate
Long	alBatchPickID
If messagebox("Update Delivery Date","Are you sure you want to set the order status to 'Delivered' and Delivery Date = " + em_delivery_dt.Text + "?",Question!,YesNo!,1) = 1 Then
	
	alBatchPickID = idw_Master.GetITemNumber(1,'batch_pick_ID')
	ldtDeliveryDAte = Date(em_delivery_dt.Text)
	
	setpointer(hourglass!)
	
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
	Update Delivery_MAster
	Set Ord_status = 'D', Delivery_Date = :ldtDeliveryDate
	Where Project_id = :gs_Project and batch_pick_id = :alBatchPickID and ord_status = 'C'
	Using SQLCA;
	
	Execute Immediate "Commit" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
	idw_detail.Retrieve()
	
	SetPointer(Arrow!)
	
	messagebox("Update Delivery Date","Complete ")
	
End IF
end event

type cb_remove_orders from commandbutton within tabpage_order_detail
integer x = 41
integer y = 12
integer width = 745
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Remove Checked Orders"
end type

event clicked;
idw_Detail.TriggerEvent('ue_remove_Orders')
end event

type dw_batch_details from u_dw_ancestor within tabpage_order_detail
event ue_selectall ( )
event ue_clearall ( )
event ue_remove_orders ( )
event ue_check_delete ( )
integer x = 9
integer y = 116
integer width = 3424
integer height = 1500
integer taborder = 20
string dataobject = "d_batch_pick_order_details"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_selectall;Long	llRowPos,	&
		llRowCount

This.SetRedraw(False)
llRowCOunt = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind','Y')
Next
This.SetRedraw(True)
end event

event ue_clearall;
Long	llRowPos,	&
		llRowCount

This.SetRedraw(False)
llRowCOunt = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind','N')
Next
This.SetRedraw(True)
end event

event ue_remove_orders();//Remove any Checked Orders from the Batch

Long	llFindRow,	&
		llFindRow2,	&
		llBatchID

String	lsDONO

If not ibDisableDeleteWarning Then
	If MessageBox(is_title,'Are you sure you want to remove these Orders from the Batch?',Question!,YesNo!,2) = 2 Then REturn
End If

ibDisableDeleteWarning = False

llBatchID = Idw_MAster.GetItemNumber(1,'batch_pick_id')

//Loop through each Checked detail Row

SetPointer(Hourglass!)
This.SetRedraw(FAlse)

llFindRow = This.Find("c_delete_ind = 'Y'",1,This.RowCount())
Do While llFindRow > 0
	
	lsDoNo = This.GetITemString(llFindRow,'Do_no')
	
	//delete any rows from DW where DO matches
	llFindRow2 = This.Find("do_no = '" + lsDoNo + "'",1,This.RowCount())
	Do While llFindRow2 > 0
		This.DeleteRow(llFindRow2)
		llFindRow2 = This.Find("do_no = '" + lsDoNo + "'",1,This.RowCount())
	Loop
	
	//If we have already saved this Batch, remove the Batch ID's from the DElivery MASter
	If (Not isnull(llBatchID)) and llBatchID > 0 Then
		
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

		Update Delivery_master
		Set Batch_Pick_id = 0
		Where project_id = :gs_project and do_no = :lsDoNo and batch_pick_id = :llBatchID;
		
		Execute Immediate "COMMIT" using SQLCA;
		
	End If
	
	llFindRow = This.Find("c_delete_ind = 'Y'",1,This.RowCount())
	
Loop

This.ResetUpdate() /*we dont want to delete the orders, just drop them from the Batch*/

This.SetRedraw(True)
SetPointer(Arrow!)
end event

event ue_check_delete;
//If no rows are checked, disable delete button

If This.Find("c_delete_ind = 'Y'",1,This.RowCount()) <= 0 Then
	tab_main.Tabpage_Order_Detail.cb_remove_orders.Enabled = False
End If


end event

event itemchanged;call super::itemchanged;ib_changed = True

//unset Batch Pick ID if unchecked
Choose Case Upper(dwo.Name)
		
	Case 'C_DELETE_IND'
		If data = 'Y' Then /*checked*/
			If idw_master.GetItemString(1,'Batch_Status') <> 'C' Then
				tab_main.Tabpage_Order_Detail.cb_remove_orders.Enabled = True
			End If
		Else /*Unchecked - see if any other rows are checked, if Not, disable button*/
			This.PostEvent('ue_check_delete')
		End If
End CHoose
end event

event constructor;call super::constructor;datawindowchild	ldwc

IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
End IF

// 12/14 - PCONKL - cart fields should only be visible for Physio right now. Customer 2 will get a project level indicator
If gs_project = 'PHYSIO-MAA'  or gs_project = 'PHYSIO-XD' Then
	
Else
	This.Modify("pick_cart_ind.visible=false pick_cart_ind_t.visible=false item_master_pick_cart_status.visible=false item_master_pick_cart_status_t.visible=false")
End If

//12/14 - PCONKL - Mobile fields only visible if Project mobile enabled
//if not g.ibMobileEnabled Then
//	This.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
//	This.Modify("mobile_released_time.visible=false mobile_released_time_t.visible=false")
//	This.Modify("mobile_pick_start_time.visible=false mobile_pick_start_time_t.visible=false")
//	This.Modify("mobile_scan_all_units_req_ind.visible=false mobile_scan_all_units_req_ind_t.visible=false ")
//	This.Modify("mobile_pick_complete_time.visible=false mobile_pick_complete_time_t.visible=false")	
//	This.Modify("mobile_pack_location.visible=false mobile_pack_location_t.visible=false ")	
//End If

//Retrieve Order Type dropdown by Project

This.getChild('ord_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)

end event

event doubleclicked;call super::doubleclicked;Str_parms	lStrparms
string ls_serialised_ind,	&
		lsFind,lsFind2
Long		llOwnerHold,	&
			llFindRow,		&
			llFindRow2
			
If Row > 0 Then
	
	Choose Case Upper(dwo.name)
					
		Case "CF_OWNER_NAME"
			
			If Upper(idw_detail.GetItemString(row,'ord_status'))	= 'C' or Upper(idw_detail.GetItemString(row,'ord_status'))	= 'D'  Then Return
			
			Open(w_select_owner)
			lstrparms = Message.PowerObjectParm
			If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
				llOwnerHold = This.GetITemNumber(row,'owner_id')
				This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
				This.SetItem(Row,"owner_cd",Lstrparms.String_arg[2])
				This.SetItem(Row,"owner_type",Lstrparms.String_arg[3])
				ib_changed = True
				
				//Owner Change needs to be reflected on Pick Detail as well
				lsFind = "Upper(Invoice_no) = '" + Upper(This.GetItemString(row,"Invoice_no")) + "' and Upper(sku) = '" + Upper(This.GetItemString(row,"sku")) + "' and owner_id = " + String(llOwnerHold) 
				llFindRow = idw_Pick.Find(lsFind,1,idw_Pick.RowCount())
				Do While llFindRow > 0
					idw_pick.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
					//idw_pick.SetITem(llFindrow,"cf_owner_name",Lstrparms.String_arg[1])
					//If a component, copy Owner to dependent records
						If idw_Pick.GetItemString(llFindRow,"component_ind") = 'Y' Then
							lsFind2 = "component_no = " + String(idw_Pick.GetItemNumber(llFindRow,"component_no"))
							llFindRow2 = idw_pick.Find(lsFind2,1,idw_Pick.RowCount())
							Do While llFindRow2 > 0
								idw_pick.SetItem(llFindRow2,"owner_id",Lstrparms.Long_arg[1])
								idw_pick.SetItem(llFindRow2,"owner_cd",Lstrparms.String_arg[2])
								idw_pick.SetItem(llFindRow2,"owner_type",Lstrparms.String_arg[3])
								llFindRow2 = idw_pick.Find(lsFind2,(llFindRow2 + 1),(idw_pick.RowCount() + 1))
							Loop
						End If /*Component*/
					llFindRow = idw_Pick.Find(lsFind,(llFindRow + 1),(idw_Pick.RowCount() + 1))
				Loop
					
				
			End If /*owner selection not cancelled*/
			
	End Choose
	
	// 07/19/2010 ujhall: 04 of 12 
	Str_parms	lStrparms_1
	If f_check_access ("W_DOR","") = 1 Then
		lstrparms_1.String_arg[1] = "W_DOR"
		lstrparms_1.String_arg[2] =  '*DONO*' +  this.GetItemString(row, 'do_no')
		OpenSheetwithparm(w_do,lStrparms_1, w_main, gi_menu_pos, Original!)
	End If
	
END IF


end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event clicked;call super::clicked;// 07/19/2010 ujhall: 05 of 12 Comcast SIK Batch Picking:
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF


end event

type tabpage_pick from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3854
integer height = 2204
long backcolor = 79741120
string text = "Pick List"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_mobile cb_mobile
cb_send_to_cart cb_send_to_cart
dw_pick_print dw_pick_print
cb_pick_print cb_pick_print
cb_pick_copy cb_pick_copy
cb_delete_pick cb_delete_pick
cb_insert_pick cb_insert_pick
cb_picklocs cb_picklocs
cb_generate_pick cb_generate_pick
dw_pick dw_pick
end type

on tabpage_pick.create
this.cb_mobile=create cb_mobile
this.cb_send_to_cart=create cb_send_to_cart
this.dw_pick_print=create dw_pick_print
this.cb_pick_print=create cb_pick_print
this.cb_pick_copy=create cb_pick_copy
this.cb_delete_pick=create cb_delete_pick
this.cb_insert_pick=create cb_insert_pick
this.cb_picklocs=create cb_picklocs
this.cb_generate_pick=create cb_generate_pick
this.dw_pick=create dw_pick
this.Control[]={this.cb_mobile,&
this.cb_send_to_cart,&
this.dw_pick_print,&
this.cb_pick_print,&
this.cb_pick_copy,&
this.cb_delete_pick,&
this.cb_insert_pick,&
this.cb_picklocs,&
this.cb_generate_pick,&
this.dw_pick}
end on

on tabpage_pick.destroy
destroy(this.cb_mobile)
destroy(this.cb_send_to_cart)
destroy(this.dw_pick_print)
destroy(this.cb_pick_print)
destroy(this.cb_pick_copy)
destroy(this.cb_delete_pick)
destroy(this.cb_insert_pick)
destroy(this.cb_picklocs)
destroy(this.cb_generate_pick)
destroy(this.dw_pick)
end on

type cb_mobile from commandbutton within tabpage_pick
integer x = 3122
integer y = 20
integer width = 590
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Release to Mobile"
end type

event clicked;
iw_window.TriggerEvent('ue_process_mobile')

end event

type cb_send_to_cart from commandbutton within tabpage_pick
integer x = 2098
integer y = 16
integer width = 411
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send to Cart"
end type

event clicked;iw_window.TriggerEvent("ue_send_to_pick_Cart")
end event

type dw_pick_print from datawindow within tabpage_pick
boolean visible = false
integer x = 1792
integer y = 800
integer width = 992
integer height = 432
integer taborder = 40
string title = "none"
string dataobject = "d_batch_picking_prt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_pick_print from commandbutton within tabpage_pick
integer x = 1605
integer y = 16
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
iw_window.TriggerEvent('ue_print')
end event

type cb_pick_copy from commandbutton within tabpage_pick
integer x = 421
integer y = 16
integer width = 347
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Copy Row"
end type

event clicked;
idw_pick.TriggerEvent('ue_copy')
end event

type cb_delete_pick from commandbutton within tabpage_pick
integer x = 1211
integer y = 16
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;
idw_pick.TriggerEvent('ue_delete')


end event

type cb_insert_pick from commandbutton within tabpage_pick
integer x = 818
integer y = 16
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;
idw_pick.TriggerEvent('ue_insert')
end event

type cb_picklocs from commandbutton within tabpage_pick
boolean visible = false
integer x = 2610
integer y = 20
integer width = 416
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Pick Locs..."
end type

event clicked;
str_parms	lstrparms
Long	llCurrRow

llCurrRow = idw_Pick.GetRow()

If llCurrRow <=0 or idw_detail.RowCount() = 0 or idw_pick.rowCount() = 0 Then Return

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = idw_detail.GetItemString(1, "wh_code") /*all orders will be from the same warehouse*/
lstrparms.String_arg[3] = idw_pick.getItemString(llCurrRow,"sku")
lstrparms.String_arg[4] = idw_pick.getItemString(llCurrRow,"supp_code")
lstrparms.String_arg[5] = idw_pick.GetITemString(llCurrRow,"l_code") /*if currently has location, recommendation will default to this*/
lstrparms.Long_arg[1] = idw_pick.getItemNumber(llCurrRow,"quantity")

OpenWithparm(w_pick_recommend,lstrparms)

idw_pick.TriggerEvent("ue_process_pick")

end event

type cb_generate_pick from commandbutton within tabpage_pick
integer x = 69
integer y = 16
integer width = 306
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;//iw_window.TriggerEvent('ue_generate_pick')

if Upper( gs_project ) = 'SIEMENS-LM' then
	iw_window.TriggerEvent("ue_generate_pick")
else
	//Either generate from client or server..
	if g.ibappserverenabled Then
		iw_window.TriggerEvent("ue_generate_pick_server")
	else
		iw_window.TriggerEvent("ue_generate_pick")
	End If
end if

end event

type dw_pick from u_dw_ancestor within tabpage_pick
event ue_set_column ( )
event ue_calc_uom ( )
event ue_process_pick ( )
event ue_hide_unused ( )
integer x = 18
integer y = 132
integer width = 3762
integer height = 1760
integer taborder = 20
string dataobject = "d_batch_picking_pick"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_set_column;This.SetColumn(isColumn)
end event

event ue_calc_uom;datastore	lds
datawindowChild	ldwc
Long	llRow, llReqQty,llUOMCount,llUOMPos,llWorkQty,lltempPos,llNewRow
String	lsSKU, lsSupplier, lsUOMText, lsUOM

// 11/00 PCONKL - Calculate possible UOM combinations for SKU/QTY

llRow = This.GetRow()
If llRow <=0 Then Return

lsSku = This.getItemString(llRow,"sku")
lsSupplier = This.GetItemString(llRow,"supp_code")

This.Getchild("user_field2",ldwc) /*user field 2 is dropdown of pick choices*/
ldwc.Reset()

//UOM's for current Sku
lds = Create datastore
lds.dataobject = 'd_pick_uom'
lds.SetTransObject(SQLCA)

llUOMCount = lds.Retrieve(gs_project,lsSku,lsSupplier)

For llUOMPos = 1 to llUOMCount

	lsUOMText = ''
	llReqQty = This.GetItemNumber(llRow,"quantity")
	
	If llReqQty < lds.getItemNumber(llUOMPos,"qty") Then Continue
	
	For llTempPos = llUomPos to llUOMCount
		
		//lowest UOM may be blank - set to 'EACH' if it is
		If (lltempPos = llUOMCount) and (isnull(lds.GetItemString(llTempPos,'uom')) or lds.GetItemString(llTempPos,'uom') = '') Then
			lsUOM = 'EA'
		Else
			lsUOM = lds.GetItemString(llTempPos,'uom')
		End If
	
		//If current UOM can be divided into reamining required qty, take as many of this UOM
		If llReqQty >= lds.getItemNumber(llTempPos,"qty") Then
			llWorkQty = truncate(llReqQty/lds.getItemNumber(lltempPos,"qty"),0) /*whole uoms divisble*/
			lsUOMText += "," + string(llWorkQty) + ' ' + lsUOM
			llReqQty = Mod(llReqQty,(llWorkQty * lds.getItemNumber(llTempPos,"qty")))
		End If /*req qty > UOM*/
		
	Next /*iteration of current UOM*/
	
	llNewRow = ldwc.InsertRow(0)
	lsUOMText = Right(lsUOMText,(len(lsUOMText) - 1)) /*strip off first , */
	ldwc.SetItem(llNewRow,'Pick_as',lsUOMText)

Next /*UOM*/


end event

event ue_process_pick();// 05/00 Pconkl - process Picking requests from recommendation window

Str_parms	lstrparms
Long			llFindRow,	&
				llArrayPos,	&
				llNewRow,	&
				llCompnumber,	&
				llowner,			&
				llCurrentPickRow,	&
				llLineItemNo,	&
				llBatchPickID
				
String		lsFind,	&
				lsSku,	&
				lsSupplier,	&
				lsLoc,	&
				lsSerial,	&
				lsLot,		&
				lsPO,			&
				lsPO2,		&
				lsWork,		&
				lsCompInd,	&
				lsCOO,		&
				lsOwner,		&
				lsDONO,		&
				lsInvType,	&
				lsInvoiceNO,	&
				lsSkuPickableInd,	&
				lsWarehouse,		&
				lsOrdStatus,		&
				lsCont, lslength, lswidth, lsheight, lsweight

//Parms returned rows of string for location and long for amt to putaway there!
lstrparms = Message.PowerobjectParm

// 02/01 PCONKL - Pick may be filtered to not show components
This.SetRedraw(False)
// rowfocus changed from filter will change, capture first
llCurrentPickRow = ilcurrpickrow
//wf_set_pick_filter('Remove')

Choose Case Upperbound(lstrparms.String_arg)
		
	Case 1 /* picking everything from 1 location*/
		
		//String Arg contains Location, Serial # and Lot number seperated by pipe (changed from comma to pipe - 09/04 - PCONKL)
		lsWork = lstrparms.String_arg[1]
		lsLoc = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsLoc)+1))
		lsSerial = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsSerial)+1))
		lsLot = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsLot)+1))
		lsPO = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsPO)+1))
		lsPO2 = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsPO2)+1))
		lsCont = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsCont)+1))
		lsCOO = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsCOO)+1))
		//lsInvType = lsWork
		lsInvType = Left(lsWork,(pos(lsWork,'|')-1))
		
		//8/04 - PCONKL - add cntnr dims/weight
		lsWork = Right(lsWork,len(lsWork) - (len(lsInvType)+1))
		lsLength = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsLength)+1))
		lsWidth = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsWidth)+1))
		lsHeight = Left(lsWork,(pos(lsWork,'|')-1))
		lsWork = Right(lsWork,len(lsWork) - (len(lsHeight)+1))
		lsWeight = lsWork
		
		This.SetItem(llCurrentPickRow,"l_code",lsLoc)
		This.SetItem(llCurrentPickRow,"serial_no",lsSerial)
		This.SetItem(llCurrentPickRow,"lot_no",lsLot)
		This.SetItem(llCurrentPickRow,"po_no",lsPO)
		This.SetItem(llCurrentPickRow,"po_no2",lsPO2)
		This.SetItem(llCurrentPickRow,"inventory_type",lsInvType)
		This.SetItem(llCurrentPickRow,"quantity",lstrparms.long_arg[1])
		This.SetItem(llCurrentPickRow,"component_no",lstrparms.Integer_arg[1])
		
		//If a component, copy location to dependent records
		If This.GetItemString(llCurrentPickRow,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(llCurrentPickRow,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(llCurrentPickRow,"component_no"))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"l_code",lsLoc)
				This.SetItem(llFindRow,"component_no",lstrparms.Integer_arg[1])
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
		This.SetFocus()
		This.SetRow(llCurrentPickRow)
		
	Case 0 /*nothing entered*/
		
		This.SetFocus()
		This.SetRow(llCurrentPickRow)
		
	Case Else /*more than 1 row*/
		
		//If more than 1 row, we will delete existing row for SKU and re-create
		
		lsSku = This.GetItemString(llCurrentPickRow,"sku") /*current row we're processing*/
		lsSupplier = This.GetItemString(llCurrentPickRow,"supp_code") 
		lsCompInd = This.GetItemString(llCurrentPickRow,"component_ind")
		lsCoo = This.GetItemString(llCurrentPickRow,"country_of_origin")
		lsDoNo = This.GetItemString(llCurrentPickRow,"do_no")
		lsInvoiceNO = This.GetItemString(llCurrentPickRow,"invoice_no")
		lsInvType = This.GetItemString(llCurrentPickRow,"inventory_type")
		lsWarehouse = This.GetItemString(llCurrentPickRow,"wh_code")
		lsordStatus = This.GetItemString(llCurrentPickRow,"ord_Status")
		lsSKUPickableInd = This.GetItemString(llCurrentPickRow,"sku_pickable_ind")
		llOwner = This.GetItemNumber(llCurrentPickRow,"owner_id")
		llLineItemNo = This.GetItemNumber(llCurrentPickRow,"Line_Item_No")
		llbatchPickID = This.GetItemNumber(llCurrentPickRow,"Batch_Pick_ID")
		
		//Delete all rows for this Order & sku
		llFindrow = 1
		If llCompNumber > 0 Then
			lsFind = "Upper(Invoice_No) = '" + Upper(lsInvoiceNo) + "' and Upper(sku_parent) = '" + Upper(This.GetItemString(llCurrentPickRow,"sku")) + "' and component_no = " + String(This.GetItemNumber(llCurrentPickRow,"component_no"))/*sku from current putaway row*/
		Else
			lsFind = "Upper(Invoice_No) = '" + Upper(lsInvoiceNo) + "' and Upper(sku_parent) = '" + Upper(This.GetItemString(llCurrentPickRow,"sku")) + "'"
		End If
		
		Do While llFindRow > 0
			llFindRow = This.Find(lsFind,0,This.RowCount())
			If llFindRow > 0 Then
				This.DeleteRow(llFindRow)
			End If
		Loop
		
		//Rebuild from array
		For llArrayPos = 1 to Upperbound(lstrparms.String_arg)
			
			llnewRow = This.InsertRow(0)
			
			//String Arg contains Location, Serial # and Lot number seperated by pipe (changed from comma to pipe - 09/04 - PCONKL)
			lsWork = lstrparms.String_arg[1]
			lsLoc = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsLoc)+1))
			lsSerial = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsSerial)+1))
			lsLot = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsLot)+1))
			lsPO = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsPO)+1))
			lsPO2 = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsPO2)+1))
			lsCont = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsCont)+1))
			lsCOO = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsCOO)+1))
			//lsInvType = lsWork
			lsInvType = Left(lsWork,(pos(lsWork,'|')-1))
		
			//8/04 - PCONKL - add cntnr dims/weight
			lsWork = Right(lsWork,len(lsWork) - (len(lsInvType)+1))
			lsLength = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsLength)+1))
			lsWidth = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsWidth)+1))
			lsHeight = Left(lsWork,(pos(lsWork,'|')-1))
			lsWork = Right(lsWork,len(lsWork) - (len(lsHeight)+1))
			lsWeight = lsWork
		
			This.setitem(llnewRow,'do_no', lsDoNo)
			This.setitem(llnewRow,'invoice_no', lsInvoiceNo)
			This.SetItem(llNewRow,"sku",lssku)
			This.SetItem(llNewRow,"sku_parent",lssku)
			This.SetItem(llNewRow,"supp_code",lssupplier)
			This.SetItem(llNewRow,"owner_id",llOwner)
			This.SetItem(llNewRow,"Line_Item_no",llLineItemNo)
			This.SetItem(llNewRow,"Batch_Pick_ID",llBatchPickID)
			This.SetItem(llNewRow,"component_ind",lsCompInd)
			This.SetItem(llNewRow,"country_of_origin",lsCoo)
			//This.SetItem(llNewRow,"component_no",llCompnumber)
			This.SetItem(llNewRow,"l_code",lsloc)
			This.SetItem(llNewRow,"serial_no",lsserial)
			This.SetItem(llNewRow,"lot_no",lslot)
			This.SetItem(llNewRow,"po_no",lspo)
			This.SetItem(llNewRow,"po_no2",lspo2)
			This.SetItem(llNewRow,"quantity",lstrparms.long_arg[llArrayPos])
			This.SetItem(llNewRow,"component_no",lstrparms.Integer_arg[llArrayPos])
			This.SetItem(llNewRow,"inventory_type",lsInvType)
			This.SetItem(llNewRow,"sku_pickable_ind",lsskuPickableInd)
			This.SetItem(llNewRow,"wh_code",lsWarehouse)
			//for assigning item master data
			i_nwarehouse.of_item_master(gs_project,lssku,lsSupplier,idw_pick,llNewRow)	
			// 10/00 PCONKL - If this row is a componet, build child pick rows
//			If lsCompInd = 'Y' Then
//				i_nwarehouse.of_create_comp_child(llNewRow,idw_main,idw_pick)
//			End If /*Component parent Row*/
//
		Next
		
		This.Sort()
		This.GroupCalc()
		This.SetFocus()
		This.SetRow(llNewRow)
		
End Choose

ib_changed = True
This.AcceptText()

// 02/01 PCONKL - Filter Pick list to not show components if box is not checked
//wf_set_pick_filter('SET')

This.SetRedraw(True)




end event

event ue_hide_unused;
// 10/02 - Pconkl - Hide Serial, Lot, etc if not used anywhere

//Serial
If This.Find("serialized_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("serial_no.width=407 serial_no_t.width=407")
Else /*Hide*/
	This.Modify("serial_no.width=0 serial_no_t.width=0")
End If

//Lot
If This.Find("lot_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("lot_no.width=407 lot_no_t.width=407")
Else /*Hide*/
	This.Modify("lot_no.width=0 lot_no_t.width=0")
End If

//PO NO
If This.Find("po_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("po_no.width=407 po_no_t.width=407")
Else /*Hide*/
	This.Modify("po_no.width=0 po_no_t.width=0")
End If

//PO NO 2
If This.Find("po_no2_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("po_no2.width=407 po_no2_t.width=407")
Else /*Hide*/
	This.Modify("po_no2.width=0 po_no2_t.width=0")
End If

//Container ID
If This.Find("container_tracking_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("container_id.width=407 container_id_t.width=407")
Else /*Hide*/
	This.Modify("container_id.width=0 container_Id_t.width=0")
End If

//Expiration Date
If This.Find("expiration_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	This.Modify("expiration_date.width=407 expiration_date_t.width=407")
Else /*Hide*/
	This.Modify("expiration_date.width=0 expiration_date_t.width=0")
End If
end event

event itemchanged;call super::itemchanged;
string ls_supp_code,ls_alternate_sku,ls_coo,ls_sku,lsFind, lsChildSku,lsChildSupplier,lsddsql,lsUOM, lsWarehouse, lsZone, lsOwnerCode, lsOwnerType, lsOldLot, lsNewLot
Long ll_row,ll_owner_id, llFindRow,llExtQty,llFindrow2,llCount
Decimal ld_picking_seq
DatawindowChild	ldwc

ibPickChanged = True
ib_changed = True

Choose Case Upper(dwo.name)
	
	case 'SKU'
		This.SetItem(row,'sku_parent',data)
	//Check if item_master has the records for entered sku	
		llCount = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case llCount
			Case 1 /*only 1 supplier, Load*/
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				ls_sku = data
				ls_supp_code = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")
				goto pick_data
			Case is > 1 /*Supplier dropdown retrievd when clicked*/
				This.object.supp_code[row]=""
			Case Else			
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				return 1
		END Choose
	
	Case 'SUPP_CODE'
		
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 goto pick_data
	 
	case 'L_CODE'
		
		//Validate Location Code
		lsWarehouse = idw_MAster.GetItemString(1,'wh_code')
		Select Count(*) into :llCount
		From Location
		Where wh_code = :lsWarehouse and l_code = :data;
	
		If llCount <= 0 Then
			MessageBox(is_title, "Invalid Location, please re-enter!")
			Return 1
		Else /*set the zone for this Location*/
			select Zone_id,picking_seq into :lsZone,:ld_picking_seq
			From Location
			Where wh_code = :lsWarehouse and l_code = :data;
			
			This.SetItem(row,'zone_id',lsZone)
			This.object.picking_seq[row]=ld_picking_seq
			
		End If
	
	//If a component, copy location to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			Messagebox(is_title,"You must use the Pick Locs button to change the location for a Component!")
			Return 2
			
//			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
//			llFindRow = This.Find(lsFind,1,This.RowCount())
//			Do While llFindRow > 0
//				This.SetItem(llFindRow,"l_code",data)
//				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
//			Loop
		End If /*Component*/
		
	Case 'INVENTORY_TYPE'
		
		//If a component, copy location to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"inventory_type",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
	Case 'QUANTITY'
		
		// 11/00 PCONKL - If qty has changed, reset the UOM Text to qty + EA
		lsUOM = data + ' EA'
		This.SetItem(row,'user_field2',lsUOM)
		
		// 09/00 PCONKL - If Quantity has changed for a component Item, recalc child extended amts
//		If This.GetItemString(row,"component_ind") = 'Y' Then
//			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
//			llFindRow = This.Find(lsFind,1,This.RowCount())
//			Do While llFindRow > 0
//				
//				ls_Sku = This.GetITemString(llFindRow,'sku_parent')
//				lsChildSku = This.GetITemString(llFindRow,'sku')
//				llFindRow2 = This.Find("sku_parent = '" + ls_sku + "' and component_ind = 'Y'",1,This.RowCount())
//				If llFindRow2 > 0 Then
//					ls_supp_code = This.GetITemString(llFindRow2,"supp_code")
//				Else
//					ls_supp_code = ''
//				End If
//				lsChildSupplier = This.GetITemString(llFindRow,'supp_code')
//				
//				Select Child_qty Into :llExtQty
//				From Item_Component
//				Where Project_id = :gs_project and sku_parent = :ls_Sku and sku_child = :lsChildSku and supp_code_parent = :ls_supp_code and supp_code_child = :lsChildSupplier
//				Using SQLCA;
//				
//				If llExtQty > 0 Then
//					This.SetItem(llFindRow,'quantity',llExtQty* Long(data))
//				End If
//								
//				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
//				
//			Loop
//		End If /*Component Item*/
		
	Case "COUNTRY_OF_ORIGIN" /* 09/00 PCONKL - validate Country of Origin*/
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		ls_COO = f_get_Country_Name(data)
		If isNull(ls_COO) or ls_COO = '' Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
		
	Case "INVOICE_NO" /*validate that it belongs to an order detail - if so, set Do_no*/
		
		If Data > '' Then
			lsFind = "Invoice_no = '" + Data + "'"
			llFIndRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
			If llFindRow > 0 Then
				//If the order founs is complete or Void, Can not update Order
				If idw_Detail.GetITemString(llFindRow,'ord_status') = 'C' or idw_Detail.GetITemString(llFindRow,'ord_status') = 'D' or idw_Detail.GetITemString(llFindRow,'ord_status') = 'V' Then
					Messagebox(is_title,"This order is either Complete or Void and Can not be changed!",StopSign!)
					Return 1
				Else
					This.SetItem(row,'do_no',idw_detail.GetITemString(llFindRow,'do_no'))
				End If
			Else
				MessageBox(is_title, "This Order Number does not exist on this batch!")
				Return 1
			End If
		Else
			MessageBox(is_title, "Order Number is Required")
			Return 1
		End If
		
	Case 'LOT_NO'  /* 12/10 - PCONKL allow update of all rows being picked for this lot */
		
		lsOldLOt = This.GEtITEmString(row,'lot_no')
		lsNEwLot = data
		
		If Messagebox(is_title,"Do you want to change all occurances of '" + lsOldLOt + "' to '" + lsNewLot + "' ?",Question!,YesNo!,1) = 1 Then
			
			lsFind = "Upper(Lot_no) = '" + Upper(lsOldLot) + "'"
			llFindRow = This.Find(lsFind,row, This.RowCOunt())
			Do While llFindRow > 0
				This.SetITem(llFindRow,'lot_no',lsNewLot)
				llFindRow ++
				If llFindRow > This.RowCount() Then
					llFindRow = 0
				Else
					llFindRow = This.Find(lsFind,llFindRow, This.RowCOunt())
				End If
			Loop
			
		End IF
		
END Choose			
return

pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	//Get the values from datastore ids which is item master
	ll_row =i_nwarehouse.ids.Getrow()
	ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id")
	ls_coo = i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default")
	//Set the values from datastore ids which is item master
	
	//Owner Info
	Select Owner_cd, Owner_Type
	Into	:lsOwnerCode, :lsOwnerType
	From Owner
	Where project_id = :gs_project and Owner_id = :ll_owner_ID;
	
	this.object.owner_id[ row ]=ll_owner_id
	this.object.owner_Cd[ row ]=lsOwnerCode
	this.object.owner_type[ row ]=lsOwnerType
	
	this.Setitem(row,"country_of_origin",ls_coo)
	
	//Call function to set the indicatores
	i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code,idw_pick,row)
		
//	// 10/00 PCONKL - If this row is a componet, build child pick rows
//	If This.GetITemString(row,'component_ind') = 'Y' Then
//		ilCompRow = Row
//		This.PostEvent("ue_post_component") /*needs to happen after itemchanged complete*/
//	End If /*Component parent Row*/
		
	isColumn = "quantity"
	This.PostEvent("ue_set_column")
ELSE
	MessageBox(is_title, "Invalid Supplier, please re-enter!")
	return 1	
END IF


end event

event itemfocuschanged;call super::itemfocuschanged;
If dwo.name = "l_code" Then
	cb_picklocs.Enabled = True
Else
	cb_picklocs.Enabled = False
End If

Choose Case dwo.name
			
	// 11/00 PCONKL - If clicking on UOM text (user 2), calcualte valid UOM itterations for current SKU
	Case "user_field2"
		
		This.TriggerEvent("ue_calc_uom")
		
End Choose

end event

event constructor;call super::constructor;
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
End IF

//12/14 - PCONKL - Mobile fields only visible if Project mobile enabled
//if not g.ibMobileEnabled Then
//	This.modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
//	This.Modify("mobile_released_time.visible=false mobile_released_time_t.visible=false")
//	This.Modify("mobile_pick_start_time.visible=false mobile_pick_start_time_t.visible=false")
//	This.Modify("mobile_pick_complete_time.visible=false mobile_pick_complete_time_t.visible=false")	
//	This.Modify("mobile_picked_by.visible=false mobile_picked_by_t.visible=false")
//	This.Modify("mobile_picked_qty.visible=false mobile_picked_qty_t.visible=false")
//	This.Modify("mobile_current_location.visible=false mobile_current_location_t.visible=false")
//End If
end event

event itemerror;call super::itemerror;return 2
end event

event rowfocuschanged;call super::rowfocuschanged;ilCurrPickRow = currentrow
end event

event ue_delete;call super::ue_delete;
Long	llRow

llRow = This.GetRow()

If llRow > 0 Then
	
	//Can't Delete a row for an order that is Confirmed or Voided
	If This.GetItemString(llrow,'ord_status') = 'C' or This.GetItemString(llrow,'ord_Status') = 'D' or This.GetItemString(llrow,'ord_Status') = 'V' Then
		MessageBox(is_title,"This Order is either Complete or Void and can not be changed!,StopSign!")
		Return 
	End If
	
	This.DEleteRow(llRow)
	ib_changed = True
	ibPickChanged = True
	
End If
end event

event ue_insert;call super::ue_insert;
Long ll_row

THis.SetFocus()

If This.AcceptText() = -1 Then Return

If idw_master.RowCount() = 0 or idw_Detail.RowCount() = 0 Then Return

	
ll_row = This.GetRow() /* 08/00 PCONKL */

If ll_row > 0 Then
	This.setcolumn('l_code')
	ll_row = This.InsertRow(ll_row + 1)
	This.ScrollToRow(ll_row)
Else
	ll_row = idw_pick.InsertRow(0)
End If	


This.SetITem(ll_row,'sku_pickable_ind','Y') /* 09/01 PCONKL*/
This.SetITem(ll_row,'component_no',0)
This.SetITem(ll_row,'Component_ind','N')
This.SetITem(ll_row,'Ord_Status',idw_detail.GetITemString(1,'Ord_status'))
This.SetITem(ll_row,'wh_code',idw_master.GetITemString(1,'wh_code'))
This.SetITem(ll_row,'batch_pick_ID',idw_master.GetITemNumber(1,'batch_pick_ID'))

end event

event ue_copy;call super::ue_copy;
Long ll_row,	&
		llNewRow
String	lsSku,lsSupplier

This.SetFocus()

If This.AcceptText() = -1 Then Return -1

ll_row = This.GetRow() /* 08/00 PCONKL */

If ll_row > 0 Then
	
	// 10/00 PCONKL - Cant copy a component Child Row
	If This.GetItemString(ll_row,'component_ind') = '*' or This.GetItemString(ll_row,'component_ind') = 'Y' Then
		MessageBox(is_title,"You can not copy a Component row!")
		Return -1
	End If
	
	//Can't copy a row for an order that is Confirmed or Voided
	If This.GetItemString(ll_row,'ord_status') = 'C' or This.GetItemString(ll_row,'ord_Status') = 'D' or This.GetItemString(ll_row,'ord_Status') = 'V' Then
		MessageBox(is_title,"This Order is either Complete or Void and can not be changed!,StopSign!")
		Return -1
	End If
	
	This.setcolumn('sku')
	llNewrow = This.InsertRow(ll_row + 1)
	This.ScrollToRow(llNewrow)
		
	//copy items to new row
	This.SetItem(llNewRow,'sku',This.GetITemString(ll_row,'sku'))
	This.setitem(llNewrow,'do_no',This.GetITemString(ll_row,'do_no'))
	This.setitem(llNewrow,'invoice_no',This.GetITemString(ll_row,'Invoice_no'))
	This.setitem(llNewrow,'ord_status',This.GetITemString(ll_row,'ord_status'))
	This.setitem(llNewrow,'wh_code',This.GetITemString(ll_row,'wh_code'))
	This.SetItem(llNewRow,'sku_parent',This.GetITemString(ll_row,'sku_parent'))
	This.SetItem(llNewRow,'sku_pickable_ind',This.GetITemString(ll_row,'sku_pickable_ind'))
	This.SetItem(llNewRow,'supp_code',This.GetITemString(ll_row,'supp_code'))
	This.SetItem(llNewRow,'country_of_origin',This.GetITemString(ll_row,'country_of_origin'))
	This.SetItem(llNewRow,'component_ind',This.GetITemString(ll_row,'component_ind'))
	//This.SetItem(llNewRow,'cf_owner_name',This.GetITemString(ll_row,'cf_owner_name'))
	This.SetItem(llNewRow,'owner_id',This.GetITemNumber(ll_row,'owner_id'))
	This.SetItem(llNewRow,'owner_cd',This.GetITemString(ll_row,'owner_cd'))
	This.SetItem(llNewRow,'owner_type',This.GetITemString(ll_row,'owner_type'))
	This.SetItem(llNewRow,'Line_Item_no',This.GetITemNumber(ll_row,'Line_Item_no'))
	This.SetItem(llNewRow,'Batch_Pick_ID',This.GetITemNumber(ll_row,'Batch_Pick_ID'))
	
	lssku = This.GetITemString(ll_row,'sku')
	lsSupplier = This.GetITemString(ll_row,'supp_code')
	i_nwarehouse.of_item_master(gs_project,lssku,lsSupplier,idw_pick,llNewRow)
	
	This.SetItem(llNewRow,'l_code',This.GetITemString(ll_row,'l_code'))
	This.SetItem(llNewRow,'zone_id',This.GetITemString(ll_row,'zone_id'))
	This.SetItem(llNewRow,'inventory_type',This.GetITemString(ll_row,'inventory_type'))
	This.SetItem(llNewRow,'lot_no',This.GetITemString(ll_row,'lot_no'))
	This.SetItem(llNewRow,'po_no',This.GetITemString(ll_row,'po_no'))
	This.SetItem(llNewRow,'po_no2',This.GetITemString(ll_row,'po_no2'))
	
	This.Setcolumn("Quantity")
	
	ib_changed = True
	
Else
	Messagebox(is_title,"Nothing to copy!")
End If	
return 1


end event

event doubleclicked;call super::doubleclicked;Str_parms	lStrparms
string ls_serialised_ind,	&
		lsFind,lsFind2
Long		llOwnerHold,	&
			llFindRow,		&
			llFindRow2
			
If Row > 0 Then
	
	Choose Case Upper(dwo.name)
					
		Case "CF_OWNER_NAME"
			
			If Upper(idw_Pick.GetItemString(row,'ord_status'))	= 'C' or Upper(idw_Pick.GetItemString(row,'ord_status'))	= 'D'  Then Return
			
			Open(w_select_owner)
			lstrparms = Message.PowerObjectParm
			If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
				llOwnerHold = This.GetITemNumber(row,'owner_id')
				This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
				This.SetItem(Row,"owner_cd",Lstrparms.String_arg[2])
				This.SetItem(Row,"owner_type",Lstrparms.String_arg[3])
				ib_changed = True
				
				//Owner Change needs to be reflected on Order Detail as well
				lsFind = "Upper(Invoice_no) = '" + Upper(This.GetItemString(row,"Invoice_no")) + "' and Upper(sku) = '" + Upper(This.GetItemString(row,"sku")) + "' and owner_id = " + String(llOwnerHold) 
				llFindRow = idw_Detail.Find(lsFind,1,idw_Detail.RowCount())
				Do While llFindRow > 0
					idw_Detail.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
					llFindRow = idw_Detail.Find(lsFind,(llFindRow + 1),(idw_Detail.RowCount() + 1))
				Loop
					
				
				
			End If /*owner selection not cancelled*/
			
	End Choose
	
END IF


end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

type tabpage_pack from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3854
integer height = 2204
long backcolor = 79741120
string text = "Pack List"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_print_dn cb_print_dn
st_carrier_ship_date st_carrier_ship_date
em_carrier_ship_date em_carrier_ship_date
dw_pack_labels dw_pack_labels
cb_carrier_labels cb_carrier_labels
dw_packprint dw_packprint
cb_pack_print cb_pack_print
cb_delete_pack cb_delete_pack
cb_insert_pack cb_insert_pack
cb_pack_copy cb_pack_copy
cb_generate_pack cb_generate_pack
dw_pack dw_pack
end type

on tabpage_pack.create
this.cb_print_dn=create cb_print_dn
this.st_carrier_ship_date=create st_carrier_ship_date
this.em_carrier_ship_date=create em_carrier_ship_date
this.dw_pack_labels=create dw_pack_labels
this.cb_carrier_labels=create cb_carrier_labels
this.dw_packprint=create dw_packprint
this.cb_pack_print=create cb_pack_print
this.cb_delete_pack=create cb_delete_pack
this.cb_insert_pack=create cb_insert_pack
this.cb_pack_copy=create cb_pack_copy
this.cb_generate_pack=create cb_generate_pack
this.dw_pack=create dw_pack
this.Control[]={this.cb_print_dn,&
this.st_carrier_ship_date,&
this.em_carrier_ship_date,&
this.dw_pack_labels,&
this.cb_carrier_labels,&
this.dw_packprint,&
this.cb_pack_print,&
this.cb_delete_pack,&
this.cb_insert_pack,&
this.cb_pack_copy,&
this.cb_generate_pack,&
this.dw_pack}
end on

on tabpage_pack.destroy
destroy(this.cb_print_dn)
destroy(this.st_carrier_ship_date)
destroy(this.em_carrier_ship_date)
destroy(this.dw_pack_labels)
destroy(this.cb_carrier_labels)
destroy(this.dw_packprint)
destroy(this.cb_pack_print)
destroy(this.cb_delete_pack)
destroy(this.cb_insert_pack)
destroy(this.cb_pack_copy)
destroy(this.cb_generate_pack)
destroy(this.dw_pack)
end on

type cb_print_dn from commandbutton within tabpage_pack
integer x = 1678
integer y = 12
integer width = 325
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print DN"
end type

event clicked;
u_nvo_process_dn	lu_dn

lu_dn = Create u_nvo_process_dn

lu_dn.uf_process_dn()


end event

type st_carrier_ship_date from statictext within tabpage_pack
integer x = 2889
integer y = 16
integer width = 293
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Carrier Ship Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_carrier_ship_date from editmask within tabpage_pack
integer x = 3191
integer y = 20
integer width = 393
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
boolean spin = true
string minmax = "~~"
end type

event modified;if date(iw_Window.tab_main.tabpage_pack.em_carrier_ship_date.text) < Today ( )  then
	MessageBox ( "CARRIER SHIP DATE", "Date needs to be today or greater")
	iw_Window.tab_main.tabpage_pack.em_carrier_ship_date.SetFocus()
end if
end event

type dw_pack_labels from datawindow within tabpage_pack
boolean visible = false
integer x = 1874
integer y = 844
integer width = 571
integer height = 368
integer taborder = 40
string title = "none"
string dataobject = "d_pack_labels_generic"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_carrier_labels from commandbutton within tabpage_pack
integer x = 2418
integer y = 12
integer width = 462
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Carrier &Labels"
end type

event clicked;if date(iw_Window.tab_main.tabpage_pack.em_carrier_ship_date.text) < Today ( )  then
	MessageBox ( "CARRIER SHIP DATE", "Date needs to be today or greater")
	iw_Window.tab_main.tabpage_pack.em_carrier_ship_date.SetFocus()
else
	idw_pack.TriggerEvent('ue_carrier_labels')
end if
end event

type dw_packprint from datawindow within tabpage_pack
boolean visible = false
integer x = 2597
integer y = 844
integer width = 411
integer height = 432
integer taborder = 40
string title = "none"
string dataobject = "d_packing_prt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_pack_print from commandbutton within tabpage_pack
integer x = 1371
integer y = 12
integer width = 238
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
u_nvo_custom_packlists	luo_Pack

luo_pack = Create u_nvo_custom_packlists

choose case gs_project
				
	case 'GM_MI_DAT'  
		
     	luo_pack.uf_batch_pack_Print_gm() 
	  
	case "KENDO" /* 04/16 - PCONKL */
	
		luo_pack.uf_packprint_kendo_batch()
		
   case else         //Wason 10/02/04
		
	 idw_pack.TriggerEvent('ue_print')
		
end choose //Wason 19/01/04


end event

type cb_delete_pack from commandbutton within tabpage_pack
integer x = 1010
integer y = 12
integer width = 320
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;
idw_pack.TriggerEvent('ue_delete')
end event

type cb_insert_pack from commandbutton within tabpage_pack
integer x = 667
integer y = 12
integer width = 325
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;
idw_pack.TriggerEvent('ue_insert')
end event

type cb_pack_copy from commandbutton within tabpage_pack
integer x = 329
integer y = 12
integer width = 320
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Copy Row"
end type

event clicked;
idw_pack.TriggerEvent('ue_Copy')
end event

type cb_generate_pack from commandbutton within tabpage_pack
integer x = 23
integer y = 12
integer width = 283
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;iw_window.TriggerEvent('ue_generate_pack')

end event

type dw_pack from u_dw_ancestor within tabpage_pack
event ue_print ( )
event ue_carrier_labels ( )
event ue_set_row ( )
integer x = 9
integer y = 140
integer width = 3561
integer height = 1492
integer taborder = 20
string dataobject = "d_batch_pick_packing"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_print();//Print the Packing list for the BAtch (From the screen, not the DB)

// 11/02 - PCONKL - Chg QTY fields to Decimal

Long ll_cnt, i, j, llRow, llLineItemNo,llFindCount, llDetailFindRow, llhazCount, llHazPos
Long	llPackLoopCount, llPackPos
Decimal	ld_weight, ld_reqqty, ld_allocqty, ldPackQty, ldPackQtyToPrint
String ls_address,lsfind,ls_text[], lscusttype, lscustcode, lsWHCode, lsVat
String ls_sku , lsSKUHold, ls_description,ls_alt_sku, ls_supplier, lsHazCode, lsHazText, lsTransportMode, lsInvoiceNO
String ls_inventory_type_desc,ls_etom, lsOnce
String	lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname,ls_Ord_Type
Datastore	ldsHazmat

SetPointer(HourGlass!)
If idw_pack.AcceptText() = -1 Then
	Return 
End If

If ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(is_title,'Please save changes before printing Pack List.')
	Return
End If

//No row means no Print
ll_cnt = idw_pack.rowcount()

If ll_cnt = 0 Then
	MessageBox("Print Packing List"," No records to print!")
	Return
End If

//Clear the Report Window (hidden datawindow)
idw_packprint.Reset()

// 02/04 - PCONKL -  Get The Ship from info for Sears Only (uses Warehouse info)
// 01/16 - PCONKL - All projects pulling Address from Warehouse
//If upper(gs_project) = 'SEARS-FIX' then 
	lsWHCode = idw_master.getitemstring(1,"wh_code")
	Select WH_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
	Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
	From warehouse
	Where WH_Code = :lsWHCode
	Using Sqlca;

//else 
//	// 07/00 PCONKL - Get The Ship from info from the Project Table
//	Select Client_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country, vat_id
//	Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsVat
//	From Project
//	Where Project_id = :gs_project
//	Using Sqlca;
//end if 

//02/02 - PCONKL - Hazardous material stuff for GM hahn
ldsHazmat = Create Datastore
ldshazmat.dataobject = 'd_hazard_text'
ldshazmat.SetTransObject(SQLCA)

// load custom packing lists if necessary
If Upper(gs_project) = 'H2O' Then /* 01/16 - PCONKL */
ls_Ord_Type=tab_main.tabpage_main.dw_batch_master.GetITemString(1,'ord_type') // Dinesh -03/31/2021- S55411- H2O+ - SIMS: Update Packing Lst 2
		 //messagebox('',ls_Ord_Type)
	 // idw_packPrint.Dataobject = 'd_packing_prt_h2O'
	 if ls_Ord_Type='E' then // Dinesh -03/31/2021- S55411- H2O+ - SIMS: Update Packing Lst 2
	 	    idw_packPrint.Dataobject = 'd_packing_prt_h2O_new' // Dinesh - 11/26/2020 - S51458- H2O packing list print format
	  else
		  	idw_packPrint.Dataobject = 'd_packing_prt_h2O'
	  end if
else  
	idw_packPrint.Dataobject = 'd_packing_prt' //GAP1203 added the default packing 
end if 		
	
lsOnce = "NO" 
//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to ll_cnt
	
	ls_sku = idw_pack.getitemstring(i,"sku")
	lsInvoiceNO = idw_pack.getitemstring(i,"Invoice_no")
	ls_supplier = idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = idw_pack.GetITemNumber(i,'line_item_no')
	
	//Header Info is coming from The Detail TAb (has Delivery MAster Info) - Find the matching row first
	lsFind = "Upper(invoice_no) = '" + Upper(lsInvoiceNo) + "' and Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	
	If llDetailFindRow <=0 Then Continue
	
	//If Saltillo, they have a special Pack LIst (1 page per line item)
	If Upper(gs_project) = 'GM_MONTRY'  and lsOnce = "NO" then 
		lsOnce = "ONCE ONLY PER LOOP" 
		lscusttype = "NOT PDC"
		lscustcode = idw_detail.getitemstring(llDetailFindROw,"cust_code")
		select customer_type 
		into :lscusttype	
		from Customer
	 	where project_id = :gs_project and cust_code = :lscustcode ;
		If lscusttype  = "PDC" or lscusttype = "ACDELCOPDC" Then   //GAP 04-03
			idw_packPrint.Dataobject = 'd_saltillopdc_batch_packing_prt'
		else
			idw_packPrint.Dataobject = 'd_saltillo_batch_packing_prt'
		end if
	end if 
	

	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	// 02/02 - PConkl - include hazardous text cd
		
	If ls_Sku <> lsSKUHold Then
		
		select description, weight_1, hazard_text_cd
		into :ls_description, :ld_weight, :lshazCode
		from item_master 
		where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier ;
	
		select Req_Qty, Alloc_Qty , alternate_SKU
		INTO :ld_reqqty, :ld_allocqty, :ls_alt_sku //Added ls_alt_sku by DGM 08/09/00
		from Delivery_Detail
		where sku = :ls_sku ;
		
	End If /*Sku changed */
	
	lsSKUHOld = Ls_SKU
	
	// 08/02 - Pconkl - For Saltillo, we will print one page for 'each' qty (ie pack qty of 8 = 8 sheets) (trees, we don't need no stinking trees!)
	// 						This code is irrelevent since we are also generating a seperate pack row for each qty
	ldPackQty = idw_pack.getitemNumber(i,"quantity")
	
	if Upper(gs_project) = 'GM_MONTRY'  and (lscusttype  <> "PDC" and lscusttype <> "ACDELCOPDC" or isnull(lscusttype)) then // Except for PDC types
		llPackLoopCount = ldPackQty /*loop once for each qty*/
		ldpackQtyToPrint = 1 /* print 1 for each Loop*/
	Else /*not Saltillo*/
		llPackLoopCount = 1 /*only loop once for each Pack Row*/
		ldPackQtyToPrint = ldPackQty /*oroginal packed qty to print*/
	End If
		
	For llPackPos = 1 to llPackLoopCount /*set above so we can loop for each qty for Saltillo*/
		
		j = idw_packprint.InsertRow(0)
		
		ls_description = trim(ls_description)
		lsTransPortMode= idw_detail.GetITemString(llDetailFindROw,'transport_Mode') /* used for printing haz mat info*/
	
		// 02/02 PCONKL - If there is hazardous material text for this SKU/Ship Method, retrieve the text for the report
		lshazText = ''
		If lshazCode > '' Then /*haz text exists for this sku*/
			llhazCount = ldsHazmat.Retrieve(gs_project,lshazCode,lsTransportMode)
			If llHazCount > 0 Then
				For llHazPos = 1 to llHazCount
					lsHazText += ldshazMat.GetItemString(llHazPos,'hazard_text') + '~r'
				Next
			End If
		End If /*haz text exists*/

		//Set all Items on the Report by grabbing info from tab pages
		idw_packprint.setitem(j,"carton_no",idw_pack.getitemString(i,"carton_no")) /*Printed report should show carton # from screen instead of row #*/
		idw_packprint.setitem(j,"bol_no",idw_pack.getitemString(i,"invoice_no"))
		If Upper(gs_project) = 'GM_MONTRY' and (lscusttype  <> "PDC" and lscusttype <> "ACDELCOPDC"  or isnull(lscusttype)) then // Except for PDC types
			idw_packprint.setitem(j,"zone_id",idw_pack.getitemString(i,"zone_id"))
			idw_packprint.setitem(j,"l_code",idw_pack.getitemString(i,"l_code"))
		End If
		idw_packprint.setitem(j,"ord_no",idw_detail.getitemstring(llDetailFindROw,"cust_order_no"))
		idw_packprint.setitem(j,"freight_terms",idw_detail.getitemstring(llDetailFindROw,"freight_terms"))	
		idw_packprint.setitem(j,"cust_code",idw_detail.getitemstring(llDetailFindROw,"cust_code")) /* 5/3/00 PCONKL*/
		idw_packprint.setitem(j,"city",idw_detail.getitemstring(llDetailFindROw,"city"))
		idw_packprint.setitem(j,"country",idw_detail.getitemstring(llDetailFindROw,"country"))
		idw_packprint.setitem(j,"ord_date",idw_detail.getitemdatetime(llDetailFindROw,"ord_date"))
		idw_packprint.setitem(j,"complete_date",idw_detail.getitemdatetime(llDetailFindROw,"complete_date"))
		idw_packprint.setitem(j,"sku",ls_sku)
		idw_packprint.setitem(j,"alt_sku",ls_alt_sku)  //08/09/00 DGM
		idw_packprint.setitem(j,"description",ls_description)
		idw_packprint.setitem(j,"unit_weight",idw_pack.getitemDecimal(i,"weight_net")) /*take from displayed pask list instead of DB*/
		idw_packprint.setitem(j,"standard_of_measure",idw_pack.getitemString(i,"standard_of_measure"))
		idw_packprint.setitem(j,"carrier",idw_detail.getitemString(llDetailFindROw,"carrier"))
		idw_packprint.setitem(j,"ship_via",idw_detail.getitemString(llDetailFindROw,"ship_via")) /* 5/3/00 PCONKL */
		idw_packprint.setitem(j,"sch_cd",idw_detail.getitemString(llDetailFindROw,"user_field1")) /* 5/3/00 PCONKL */
		idw_packprint.setitem(j,"packlist_notes",idw_detail.getitemString(llDetailFindROw,"packlist_notes")) /* 09/01 PCONKL */
		idw_packprint.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
		idw_packprint.setitem(j,"HazText",lshazText) /* 02/02 PCONKL */

		//For English to Metrtics changes added L or K based on E or M
		ls_etom=idw_packprint.getitemString(j,"standard_of_measure")
		idw_packprint.setitem(j,"cntl_number",idw_detail.getitemString(lldetailFindRow,"delivery_detail_user_field1"))
		idw_packprint.setitem(j,"user_field2",idw_detail.getitemString(lldetailFindRow,"delivery_detail_user_field2")) /* 12/01 for Saltillo*/
		//If Upper(gs_project) = 'GM_MONTRY' and (lscusttype  <> "PDC" and lscusttype <> "ACDELCOPDC"  or isnull(lscusttype)) then // Except for PDC types
		If Upper(gs_project) <> 'GM_MONTRY'  or (Upper(gs_project) = 'GM_MONTRY'  and (lscusttype  = "PDC" or lscusttype = "ACDELCOPDC")) Then /* 08/02 - Pconkl - GAP 9/02 added satillo PDCs */
			If idw_detail.getitemnumber(lldetailFindRow,"req_qty") = idw_detail.getitemnumber(lldetailFindRow,"alloc_qty") Then
				idw_packprint.setitem(j,"ord_qty",idw_pack.getitemNumber(i,"quantity"))
			Else /*ord qty <> Alloc, if it's the last carton row for this sku, show the difference here, otherwise set to alloc*/
				If (i = ll_cnt) or (idw_pack.Find(lsFind,(i + 1),(ll_cnt + 1)) = 0) Then /*last row for the sku*/
					//set order qty = shipped qty for row + (order - alloc) from detail. This assumes that the Shipped QTY on Packing List = Alloc QTY on DEtail. This will be validated before allowing to print (wf_val)
					idw_packprint.setitem(j,"ord_qty",(idw_pack.getitemNumber(i,"quantity") + (idw_detail.getitemnumber(lldetailFindRow,"req_qty") - idw_detail.getitemnumber(lldetailFindRow,"alloc_qty"))))
				Else /* not last row for sku*/
					idw_packprint.setitem(j,"ord_qty",idw_pack.getitemNumber(i,"quantity"))
				End If
			End If
		Else /* ord qty will be set properly foir Saltillo since only one qty per page */
			idw_packprint.setitem(j,"ord_qty",idw_detail.getitemnumber(lldetailFindRow,"req_qty"))
		End If
		
		idw_packprint.setitem(j,"picked_quantity",ldPackQtyToPrint) /* 08/02 - PCONKL - Either packed qty or 1 (for Saltillo each qty is seperate page of qty = 1)*/
		
		idw_packprint.setitem(j,"volume",idw_pack.getitemDecimal(i,"cbm")) /* 02/01 - PCONKL*/
		If idw_pack.getitemDecimal(i,"cbm") > 0 Then
			idw_packprint.setitem(j,'dimensions',string(idw_pack.getitemDecimal(i,"length")) + ' x ' + string(idw_pack.getitemDecimal(i,"width")) + ' x ' + string(idw_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
		End If
		idw_packprint.setitem(j,"country_of_origin",idw_pack.getitemstring(i,"country_of_origin")) /* 10/00 - PCONKL*/
		idw_packprint.setitem(j,"supp_code",idw_pack.getitemstring(i,"supp_code")) /* 10/00 - PCONKL*/
		idw_packprint.setitem(j,"serial_no",idw_pack.getitemstring(i,"free_form_serial_no")) /* 02/01 - PCONKL*/
		idw_packprint.setitem(j,"component_ind",idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
		
		idw_packprint.setitem(j,"cust_name",idw_detail.getitemstring(llDetailFindROw,"cust_name"))
		idw_packprint.setitem(j,"delivery_address1",idw_detail.getitemstring(llDetailFindROw,"address_1"))
		idw_packprint.setitem(j,"delivery_address2",idw_detail.getitemstring(llDetailFindROw,"address_2"))
		idw_packprint.setitem(j,"delivery_address3",idw_detail.getitemstring(llDetailFindROw,"address_3"))
		idw_packprint.setitem(j,"delivery_address4",idw_detail.getitemstring(llDetailFindROw,"address_4"))
		idw_packprint.setitem(j,"delivery_state",idw_detail.getitemstring(llDetailFindROw,"state"))
		idw_packprint.setitem(j,"delivery_zip",idw_detail.getitemstring(llDetailFindROw,"zip"))
		idw_packprint.setitem(j,"remark",idw_detail.getitemstring(llDetailFindROw,"remark"))
	
		// 07/00 PCONKL - Ship from info is coming from Project Table
		idw_packprint.setitem(j,"ship_from_name",lsName)
		idw_packprint.setitem(j,"ship_from_address1",lsaddr1)
		idw_packprint.setitem(j,"ship_from_address2",lsaddr2)
		idw_packprint.setitem(j,"ship_from_address3",lsaddr3)
		idw_packprint.setitem(j,"ship_from_address4",lsaddr4)
		idw_packprint.setitem(j,"ship_from_city",lsCity)
		idw_packprint.setitem(j,"ship_from_state",lsstate)
		idw_packprint.setitem(j,"ship_from_zip",lszip)
		idw_packprint.setitem(j,"ship_from_country",lscountry)
		
	Next /*Loop of current PAck row (each qty for Saltillo) */
	
Next /*Next Pack Row */

i=1
FOR i = 1 TO UpperBound(ls_text[])
	idw_packprint.Modify(ls_text[i])
	ls_text[i]=""
NEXT


//Send the report to the Print report window
idw_packprint.Sort()
idw_packprint.GroupCalc()

OpenWithParm(w_dw_print_options,idw_packprint) 

//If message.doubleparm = 1 then
//	If idw_main.GetItemString(1,"ord_status") = "N" or &
//		idw_main.GetItemString(1,"ord_status") = "P" Then 
//		idw_main.SetItem(1,"ord_status","I")
//		ib_changed = TRUE
//		iw_window.trigger event ue_save()
//	End If
//End If

end event

event ue_carrier_labels;
//Print a carrier label for 'EACH' - depending on the carrier. We will also write rows to the FEDEX & UPS export file
//We will use one label format for all carriers and hide/show fields as appropriate. This will allow us to print the labels
//in the same order as the Pick List

Long ll_cnt, i, j, llRow, llUnitQty, llLineItemNo,llFindCount, llDetailFindRow, llSeqNo, llRC
Decimal	ld_weight
String ls_address,lsfind
String ls_sku , ls_description, ls_supplier, lsTransportMode, lsInvoiceNO
String ls_inventory_type_desc,ls_etom
String	lsaddr1,lsaddr2,lsaddr3,lsaddr4,lscity,lsstate,lszip,lscountry,lsname
u_nvo_edi_confirmations	lu_edi_confirm

SetPointer(HourGlass!)
If idw_pack.AcceptText() = -1 Then
	Return 
End If

If ib_changed then /* we want to make sure the validation routine is run before printing*/
	Messagebox(is_title,'Please save changes before printing Pack Labels.')
	Return
End If

//No row means no Print
ll_cnt = idw_pack.rowcount()
If ll_cnt = 0 Then
	MessageBox("Print Packing labels"," No labels to print!")
	Return
End If

//Clear the Report Window (hidden datawindow)
idw_packLabels.Reset()

idw_packlabels.SetRedraw(False)

// 07/00 PCONKL - Get The Ship from info from the Project Table
Select Client_name, Address_1, Address_2, Address_3, Address_4, city, state, zip, country
Into	:lsName, :lsaddr1, :lsAddr2, :lsaddr3, :lsaddr4, :lsCity, :lsState, :lsZip, :lsCountry
From Project
Where Project_id = :gs_project
Using Sqlca;

//If any orders are using Fedex, create the UO for exporting to Fedex
lsFind = "Upper(Carrier) = 'FEDEX'"
If idw_Detail.Find(lsFind,1,idw_Detail.RowCount()) > 0 Then
	lu_edi_confirm = Create u_nvo_edi_confirmations
	
	// 08/02 - Pconkl, If Saltillo/Detroit, Sort PAck Screen to match Picking (fedex labels should be in same order as Pick List)
	If Upper(Left(gs_project,4)) = 'GM_M' Then
		idw_pack.SetSort("Zone_ID A, L_Code A, SKU A, Supp_Code A, Invoice_NO A, Carton_No A")
		idw_pack.Sort() 
	End If
End If

//If any orders are using UPS, create the UO for exporting to UPS
lsFind = "Upper(Carrier) = 'UPS'"
If idw_Detail.Find(lsFind,1,idw_Detail.RowCount()) > 0 Then
	lu_edi_confirm = Create u_nvo_edi_confirmations
	// 08/02 - Pconkl, If Saltillo/Detroit, Sort PAck Screen to match Picking (ups labels should be in same order as Pick List)
	If Upper(Left(gs_project,4)) = 'GM_M' Then
		idw_pack.SetSort("Zone_ID A, L_Code A, SKU A, Supp_Code A, Invoice_NO A, Carton_No A")
		idw_pack.Sort() 
	End If
End If

llSeqNo = 0

//Loop through each row in Tab pages and grab the coresponding info
For i = 1 to ll_cnt
	
	w_main.SetMicroHelp("Creating Carrier Label " + String(i) + " of " + String(ll_cnt))
	
	ls_sku = idw_pack.getitemstring(i,"sku")
	lsInvoiceNO = idw_pack.getitemstring(i,"Invoice_no")
	ls_supplier = idw_pack.getitemstring(i,"supp_code")
	llLineItemNo = idw_pack.GetITemNumber(i,'line_item_no')
	
	//Header Info is coming from The Detail TAb (has Delivery MAster Info) - Find the matching row first
	lsFind = "Upper(invoice_no) = '" + Upper(lsInvoiceNo) + "' and Upper(sku) = '" + Upper(ls_sku) + "' and line_item_no = " + string(llLineItemNo)
	llDetailFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	
	If llDetailFindRow <=0 Then Continue
		
	//Get SKU, Description and Quantities  04/05/00 PCONKL - include user field5 as pdc_whse_loc
	// 02/02 - PConkl - include hazardous text cd
		
	select description, weight_1
	into :ls_description, :ld_weight
	from item_master 
	where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supplier ;
		
	ls_description = trim(ls_description)
	
	lsTransPortMode= idw_detail.GetITemString(llDetailFindROw,'transport_Mode') /* used for printing haz mat info*/
			
	//Set all Items on the Report by grabbing info from tab pages
	
	//For MONTRY, Print a label for each unit (loop for qty)
	If Upper(gs_project) = 'GM_MONTRY' Then
		llUnitQty = idw_pack.getitemNumber(i,"quantity")
	Else
		llUnitQty = 1 /*only one label per pack row*/
	End If
	
	For llRow = 1 to llUnitQty
	
		//If the Carrier is FEDEX, we will write a row to the Trans.in file
		If idw_detail.getitemString(llDetailFindROw,"carrier") = 'FEDEX' Then
			llRc = lu_edi_confirm.uf_export_to_fedex_batch(idw_detail,idw_pack,i)
			If llRC < 0 Then Return
			Continue /*Next Unit qty */
			
		//If the Carrier is UPS, we will write a row to the UPS.txt file,
		elseIf idw_detail.getitemString(llDetailFindROw,"carrier") = 'UPS' Then
			llRc = lu_edi_confirm.uf_export_to_ups_batch(idw_detail,idw_pack,i)
			If llRC < 0 Then Return
			Continue /*Next Unit qty */
		
		Else // otherwise we will print a label
		
	 		j = idw_packLabels.InsertRow(0)
 			idw_packLabels.setitem(j,"invoice_no",idw_pack.getitemString(i,"invoice_no"))
 			idw_packLabels.setitem(j,"freight_terms",idw_detail.getitemstring(llDetailFindROw,"freight_terms"))	
	 		idw_packLabels.setitem(j,"cust_code",idw_detail.getitemstring(llDetailFindROw,"cust_code")) 
 			idw_packLabels.setitem(j,"city",idw_detail.getitemstring(llDetailFindROw,"city"))
 			idw_packLabels.setitem(j,"country",idw_detail.getitemstring(llDetailFindROw,"country"))
	 		idw_packLabels.setitem(j,"ord_date",idw_detail.getitemdatetime(llDetailFindROw,"ord_date"))
 			idw_packLabels.setitem(j,"complete_date",idw_detail.getitemdatetime(llDetailFindROw,"complete_date"))
 			idw_packLabels.setitem(j,"sku",ls_sku)
	 		idw_packLabels.setitem(j,"description",ls_description)
 			idw_packLabels.setitem(j,"unit_weight",idw_pack.getitemDecimal(i,"weight_net")) /*take from displayed pask list instead of DB*/
 			idw_packLabels.setitem(j,"weight",idw_pack.getitemDecimal(i,"weight_gross"))
	 		idw_packLabels.setitem(j,"standard_of_measure",idw_pack.getitemString(i,"standard_of_measure"))
  			idw_packLabels.setitem(j,"carrier",idw_detail.getitemString(llDetailFindROw,"carrier"))
 			idw_packLabels.setitem(j,"ship_via",idw_detail.getitemString(llDetailFindROw,"ship_via"))
	 		idw_packLabels.setitem(j,"sch_cd",idw_detail.getitemString(llDetailFindROw,"user_field1")) 
 			idw_packLabels.setitem(j,"awb_bol_nbr",idw_detail.getitemString(llDetailFindROw,"awb_bol_no"))
 			idw_packLabels.setitem(j,"shipping_instructions",idw_detail.getitemString(llDetailFindROw,"shipping_instructions"))
 			idw_packLabels.setitem(j,"ship_ref",idw_detail.getitemString(llDetailFindROw,"ship_ref"))
 	
 			idw_packLabels.setitem(j,"project_id",gs_project) /* 12/01 PCONKL */
 		
 			//to allow labels to be sorted same as Pick List
 			idw_packLabels.setitem(j,"zone_id",idw_pack.getitemString(i,"zone_id"))
 			idw_packLabels.setitem(j,"l_code",idw_pack.getitemString(i,"l_code"))
 			
 			//For English to Metrtics changes added L or K based on E or M
	 		ls_etom=idw_packLabels.getitemString(j,"standard_of_measure")
 	
 			idw_packLabels.setitem(j,"picked_quantity",idw_pack.getitemNumber(i,"quantity")) 
 			idw_packLabels.setitem(j,"volume",idw_pack.getitemDecimal(i,"cbm")) 
 			If idw_pack.getitemDecimal(i,"cbm") > 0 Then
 				idw_packLabels.setitem(j,'dimensions',string(idw_pack.getitemDecimal(i,"length")) + ' x ' + string(idw_pack.getitemDecimal(i,"width")) + ' x ' + string(idw_pack.getitemDecimal(i,"height"))) /* 02/01 - PCONKL*/
 			End If
 
 //		idw_packLabels.setitem(j,"component_ind",idw_pack.getitemstring(i,"component_ind")) /* 02/01 - PCONKL - sort component master to top*/
 		
 			idw_packLabels.setitem(j,"cust_name",idw_detail.getitemstring(llDetailFindROw,"cust_name"))
 			idw_packLabels.setitem(j,"delivery_address1",idw_detail.getitemstring(llDetailFindROw,"address_1"))
	 		idw_packLabels.setitem(j,"delivery_address2",idw_detail.getitemstring(llDetailFindROw,"address_2"))
 			idw_packLabels.setitem(j,"delivery_address3",idw_detail.getitemstring(llDetailFindROw,"address_3"))
 			idw_packLabels.setitem(j,"delivery_address4",idw_detail.getitemstring(llDetailFindROw,"address_4"))
	 		idw_packLabels.setitem(j,"delivery_state",idw_detail.getitemstring(llDetailFindROw,"state"))
 			idw_packLabels.setitem(j,"delivery_zip",idw_detail.getitemstring(llDetailFindROw,"zip"))
 		
 			// 07/00 PCONKL - Ship from info is coming from Project Table
	 		idw_packLabels.setitem(j,"ship_from_name",lsName)
 			idw_packLabels.setitem(j,"ship_from_address1",lsaddr1)
 			idw_packLabels.setitem(j,"ship_from_address2",lsaddr2)
	 		idw_packLabels.setitem(j,"ship_from_address3",lsaddr3)
 			idw_packLabels.setitem(j,"ship_from_address4",lsaddr4)
 			idw_packLabels.setitem(j,"ship_from_city",lsCity)
	 		idw_packLabels.setitem(j,"ship_from_state",lsstate)
 			idw_packLabels.setitem(j,"ship_from_zip",lszip)
 			idw_packLabels.setitem(j,"ship_from_country",lscountry)
 		
	 		idw_packLabels.setitem(j,"piece_count",'Piece ' + String(llRow) + ' of ' + String(llUnitQty))
 		
 			//Computed Tracking No - update to DElivery mAster as well
 			idw_packLabels.setitem(j,"carrier_tracking_no",'12345678')
 		
 			//to break on each label
 			llSeqNo ++
 			idw_packLabels.setitem(j,"seq_no",llSeqNo)
	   
		end if
		
	Next /*Label for each unit (QTY Loop*/
	
Next /*Packing Row */

//If we exported to a Carrier, close the file
If isvalid(lu_edi_confirm) Then /*sending 0 as current row will close the file*/
	If idw_detail.getitemString(llDetailFindROw,"carrier") = 'FEDEX' Then lu_edi_confirm.uf_export_to_fedex_Batch(idw_detail,idw_pack,0) 
	If idw_detail.getitemString(llDetailFindROw,"carrier") = 'UPS' Then lu_edi_confirm.uf_export_to_ups_Batch(idw_detail,idw_pack,0) //gap 10-03
End If

//Send the report to the Print report window
idw_packLabels.Sort()
idw_packLabels.GroupCalc()

idw_packlabels.SetRedraw(True)

If idw_packlabels.RowCount() > 0 Then
	OpenWithParm(w_dw_print_options,idw_packLabels) 
Else
	Messagebox(is_title,'No Labels to Print.')
End If

w_main.SetMicroHelp("Ready")

end event

event ue_set_row();
if ilSetRow > 0 Then
	This.SetRow(ilSetRow)
	This.ScrollToRow(ilSetRow)
End If
end event

event ue_copy;call super::ue_copy;
Long  llRow, llNewRow

idw_pack.SetFocus()

llrow = idw_pack.GetRow()

If llRow <= 0 Then
	REturn -1
Else
	//Can't copy a row for an order that is Confirmed or Voided
	If This.GetItemString(llrow,'ord_status') = 'C' or This.GetItemString(llrow,'ord_Status') = 'D' or This.GetItemString(llrow,'ord_Status') = 'V' Then
		MessageBox(is_title,"This Order is either Complete or Void and can not be changed!,StopSign!")
		Return -1
	End If
	llNewRow = llRow + 1
	idw_pack.RowsCopy(llRow,llRow,Primary!,idw_pack,llNewRow,Primary!)
	ib_changed = True
End If

idw_pack.GroupCalc()

idw_pack.SetRow(llNewRow)
idw_Pack.ScrollToRow(llNewRow)
idw_pack.SetColumn('carton_no')

Return 0
end event

event ue_delete;call super::ue_delete;Long	llRow

llRow = This.GetRow()

If llRow > 0 Then
	

	//09/05 - PCONKL - Can't delete a row that was shipped by TRAX until it is voided
	If This.GetITemString(llrow,'tracking_id_Type') = 'T' Then
		Messagebox(is_title,'This Carton has been shipped by ConnectShip.~rYou must Void the carton before you can delete it.',StopSign!) // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip 
		//Messagebox(is_title,'This Carton has been shipped by TRAX.~rYou must Void the carton before you can delete it.',StopSign!)
		Return
	End If
	
	//Can't delete if ord_status is Complete or Void
	If THis.GetITemString(llRow,'ord_status') = 'C' or THis.GetITemString(llRow,'ord_status') = 'D' or THis.GetITemString(llRow,'ord_status') = 'V' Then
		Messagebox(is_title,'This order is either Complete or Void and can not be changed!',StopSign!)
	Else
		This.DEleteRow(llRow)
		ib_changed = True
	End If
	
End If
end event

event itemchanged;
String ls_SKU, ls_Name,ls_std_measure, lsFind
string ls_supp_code,ls_alternate_sku,ls_coo
Long ll_owner_id,ll_row, llFindRow
LONG   ll_Count, ll_Length, ll_Width, ll_Height, ll_Weight, ll_quantity, ll_qty, llFind, lLRC
decimal ld_null,ld_result
DataWindowChild	ldwc_cartonType

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 08/08/2010 ujhall: 01 of 08: Propagate entries - Ctn Type and (L,W, H):
String ls_curr_invoice_no
long ll_row_count , i
Dec  ld_length, ld_width, ld_height
ll_row_count = dw_pack.rowcount()
ls_curr_invoice_no = this.GetItemString(row, "invoice_no")
wf_set_filter_carton_type()
idwc_carton_type.SetSort("Carton_type asc")
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


setnull(ld_null)

ls_Name = dwo.Name
ib_changed = True


CHOOSE CASE Upper(ls_Name)
		
CASE 'SKU'
	
   //Check if item_master has the records for entered sku	
		ll_Count = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case ll_Count
			Case 1 /*only 1 supplier, Load*/
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				ls_sku = data
				ls_supp_code = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")
				goto pick_data
			Case is > 1 /*Supplier dropdown retrievd when clicked*/
				This.object.supp_code[row]=""
			Case Else			
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				tab_main.selecttab(6)
				return 1
		END Choose
		
Case 'SUPP_CODE'
	
	 ls_sku = this.Getitemstring(row,"sku")
	 ls_supp_code = data
	 goto pick_data
	 
Case "CARTON_TYPE"
	
	// 08/08/2010 ujhall: 02 of 08: Propagate entries - Ctn Type and (L,W, H):
	// 08/10 - PCONKL - We want to propogate from the dimensions on the carton type record, not what is already on Packing
				
	This.GetChild("CARTON_TYPE", ldwc_cartonType)
	llFind = ldwc_cartonType.Find("upper(Carton_type) = '" + upper(data) + "'",1,ldwc_cartonType.RowCount())
	If llFind > 0 Then
		
		ld_length = ldwc_cartonType.GetItemDecimal(llFind,"length")
		ld_width = ldwc_cartonType.GetItemDecimal(llFind,"width")
		ld_height = ldwc_cartonType.GetItemDecimal(llFind,"height")
				
		this.SetItem(row, 'Carton_type', string(data)) 
		this.SetItem(row, 'length', ld_length) 
		this.SetItem(row, 'width', ld_width) 
		this.SetItem(row, 'height', ld_height) 
		This.SetItem(row,'cbm', ld_length*ld_width*ld_height)
	
		if Row = 1 Then
			
			If Messagebox(is_title,"Would you like to copy this Carton Type and associated DIMS~rto All Cartons in this batch?",Question!,YesNo!,1) = 1 Then
			
				For i = 1 to ll_row_count
					this.SetItem(i, 'Carton_type', string(data)) 
					this.SetItem(i, 'length', ld_length) 
					this.SetItem(i, 'width', ld_width) 
					this.SetItem(i, 'height', ld_height) 
					This.SetItem(i,'cbm', ld_length*ld_width*ld_height)
				next
			
			End If /*Yst to prompt*/
			
		End If /*First row */
		
	End If
	

Case "LENGTH"
	
	// 08/08/2010 ujhall: 03 of 08: Propagate entries - Ctn Type and (L,W, H):
	ld_length = dec(data)
	ld_width = this.GetItemDecimal(row,"width")
	ld_height = this.GetItemDecimal(row,"height")
	
	This.SetItem(row,'cbm', ld_length*ld_width*ld_height)
	uf_update_carton_rows(row,'length',Dec(Data))
	
	if  row = 1 then
		
		If Messagebox(is_title,"Would you like to copy this LENGTH~rto All Cartons in this batch?",Question!,YesNo!,1) = 1 Then
			
			For i = 1 to ll_row_count
				this.SetItem(i, 'Length', ld_length)
				this.SetItem(i,"width", ld_width)
				this.SetItem(i,"Height", ld_Height)
				This.SetItem(i,'cbm',long(data)*This.GetItemNumber(i,"width")*This.GetITemNumber(i,"height"))
				This.SetItem(i,'cbm', ld_length*ld_width*ld_height)
			next
			
		End If
		
	End if
	
Case "WIDTH"
	
	// 08/08/2010 ujhall: 04 of 08: Propagate entries - Ctn Type and (L,W, H):
	ld_length = this.GetItemDecimal(row,"length")
	ld_width = dec(data)
	ld_height = this.GetItemDecimal(row,"height")
	
	This.SetItem(row,'cbm', ld_length*ld_width*ld_height)
	uf_update_carton_rows(row,'width',Dec(Data))
	
	if  row = 1 then
		
		If Messagebox(is_title,"Would you like to copy this WIDTH~rto All Cartons in this batch?",Question!,YesNo!,1) = 1 Then
		
			For i = 1 to ll_row_count
				this.SetItem(i, 'width', ld_width)
				this.SetItem(i,"length", ld_length)
				this.SetItem(i,"Height", ld_Height)
				This.SetItem(i,'cbm', ld_length*ld_width*ld_height)
			next		
			
		End If

	end if
	
Case "HEIGHT"
	
	// 08/08/2010 ujhall: 05 of 08: Propagate entries - Ctn Type and (L,W, H):
	ld_length = this.GetItemDecimal(row,"length")
	ld_width = this.GetItemDecimal(row,"width")
	ld_height = dec(data)
	
	This.SetItem(row,'cbm', ld_length*ld_width*ld_height)
	uf_update_carton_rows(row,'height',Dec(Data))
	
	If row = 1 then
		
		If Messagebox(is_title,"Would you like to copy this HEIGHT~rto All Cartons in this batch?",Question!,YesNo!,1) = 1 Then
			
			For i = 1 to ll_row_count
				this.SetItem(i, 'height', long(data))
				this.SetItem(i,"width", ld_width)
				this.SetItem(i,"length", ld_length)
				This.SetItem(i,'cbm', ld_length*ld_width*ld_height)
			next
			
		End If
		
	End if
	
Case "WEIGHT_GROSS"
	
	uf_update_carton_rows(row,'weight_gross',Dec(Data))
	
	If row = 1 then
		
		If Messagebox(is_title,"Would you like to copy this GORSS WEIGHT~rto All Cartons in this batch?",Question!,YesNo!,1) = 1 Then
			
			For i = 1 to ll_row_count
				This.SetITem(i,'weight_gross',dec(data))
			Next
			
		End If
		
	End If
	
CASE 'QUANTITY'
	
	ll_quantity = long(data)
	
	IF IsNull(ll_quantity) THEN RETURN 
		ll_weight = This.GetItemNumber( row, 'weight_net')
		This.SetItem ( row, 'weight_gross', (ll_Weight * ll_quantity))
	
CASE 'STANDARD_OF_MEASURE'

//	wf_convert(data,0)
	
Case "COUNTRY_OF_ORIGIN" /* 09/00 PCONKL - validate Country of Origin*/
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		ls_COO = f_get_Country_Name(data)
		If isNull(ls_COO) or ls_COO = '' Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
	
Case "INVOICE_NO" /*validate that it belongs to an order detail - if so, set Do_no*/
		If Data > '' Then
			lsFind = "Invoice_no = '" + Data + "'"
			llFIndRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
			If llFindRow > 0 Then
				//If the order founs is complete or Void, Can not update Order
				If idw_Detail.GetITemString(llFindRow,'ord_status') = 'C' or idw_Detail.GetITemString(llFindRow,'ord_status') = 'D' or idw_Detail.GetITemString(llFindRow,'ord_status') = 'V' Then
					Messagebox(is_title,"This order is either Complete or Void and Can not be changed!",StopSign!)
					Return 1
				Else
					This.SetItem(row,'do_no',idw_detail.GetITemString(llFindRow,'do_no'))
				End If
			Else
				MessageBox(is_title, "This Order Number does not exist on this batch!")
				Return 1
			End If
		Else
			MessageBox(is_title, "Order Number is Required")
			Return 1
		End If
		
Case "CARTON_NO"
		
	lLRC = uf_enable_first_carton_row(row,this.GetITemString(row,'invoice_no'),data)
	If llRC > 0 Then
		ilSetRow = llRC
		This.PostEvent('ue_set_row')
	End IF
	
END CHOOSE

return
pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	//Get the values from datastore ids which is item master
	ll_row =i_nwarehouse.ids.Getrow()
	ls_coo = i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default")
	ls_std_measure=i_nwarehouse.ids.GetItemString(ll_row,"standard_of_measure")
	//Set the values from datastore ids which is item master
	this.object.country_of_origin[ row ] = ls_coo
	this.object.standard_of_measure[ row ] = ls_std_measure
	//Call function to set the indicatores
	i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code,idw_pick,row)
				
	isColumn = "quantity"
	This.PostEvent("ue_set_column")
ELSE
	MessageBox(is_title, "Invalid Supplier, please re-enter!")
	return 1					
END IF	

end event

event ue_insert;call super::ue_insert;Long ll_row
String ls_sku,ls_supp,ls_std_measure,ls_wh_code
Decimal ld_l, ld_w, ld_h, ld_net_wt, ld_gross_wt, ld_cbm
Boolean lb_default

idw_pack.SetFocus()

ib_changed = True
ll_row = idw_pack.GetRow()

If ll_row = idw_pack.RowCount() Then ll_row ++

ll_row = idw_pack.InsertRow(ll_row)

ls_wh_code = idw_MAster.object.wh_code[1]      	
idw_pack.Setitem(ll_row,"standard_of_measure",g.ids_project_warehouse.object.standard_of_measure[g.of_project_warehouse(gs_project,ls_wh_code)])
//wf_assignetom(2)//Assign to radio button
		
idw_pack.GroupCalc()

idw_pack.SetRow(ll_Row)
idw_pack.ScrollToRow(ll_row)

end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event retrieveend;call super::retrieveend;// 08/08/2010 ujhall: 08 of 08: Propagate entries - Ctn Type and (L,W, H):  Set filter
idw_pack.Getchild("carton_type",idwc_carton_type)
wf_set_filter_carton_type()
idwc_carton_type.SetSort("Carton_type asc")
idwc_carton_type.Sort()

end event

event constructor;call super::constructor;IF g.isCopy_Lot_No_to_Packlist <> 'Y' then
	This.Object.pack_lot_no.Width=0
	This.Object.pack_po_no.Width=0
	This.Object.pack_po_no2.Width=0
	//This.Object.pack_expiration_date.visible = 'Yes'
end if
end event

type tabpage_trax from userobject within tab_main
integer x = 18
integer y = 112
integer width = 3854
integer height = 2204
long backcolor = 79741120
string text = "ConnectShip"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_1 st_1
ddlb_trax_printer ddlb_trax_printer
cb_trax_print_label cb_trax_print_label
cb_trax_void cb_trax_void
cb_trax_ship cb_trax_ship
cb_trax_clearrall cb_trax_clearrall
cb_trax_selectall cb_trax_selectall
dw_trax dw_trax
end type

on tabpage_trax.create
this.st_1=create st_1
this.ddlb_trax_printer=create ddlb_trax_printer
this.cb_trax_print_label=create cb_trax_print_label
this.cb_trax_void=create cb_trax_void
this.cb_trax_ship=create cb_trax_ship
this.cb_trax_clearrall=create cb_trax_clearrall
this.cb_trax_selectall=create cb_trax_selectall
this.dw_trax=create dw_trax
this.Control[]={this.st_1,&
this.ddlb_trax_printer,&
this.cb_trax_print_label,&
this.cb_trax_void,&
this.cb_trax_ship,&
this.cb_trax_clearrall,&
this.cb_trax_selectall,&
this.dw_trax}
end on

on tabpage_trax.destroy
destroy(this.st_1)
destroy(this.ddlb_trax_printer)
destroy(this.cb_trax_print_label)
destroy(this.cb_trax_void)
destroy(this.cb_trax_ship)
destroy(this.cb_trax_clearrall)
destroy(this.cb_trax_selectall)
destroy(this.dw_trax)
end on

type st_1 from statictext within tabpage_trax
integer x = 2149
integer y = 36
integer width = 297
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Printer:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_trax_printer from dropdownlistbox within tabpage_trax
integer x = 2464
integer y = 28
integer width = 585
integer height = 400
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_trax_print_label from commandbutton within tabpage_trax
integer x = 1746
integer y = 20
integer width = 329
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print Labels"
end type

event clicked;
dw_trax.triggerEvent('ue_print_labels')
end event

type cb_trax_void from commandbutton within tabpage_trax
integer x = 1271
integer y = 20
integer width = 329
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Void"
end type

event clicked;
dw_trax.TriggerEvent('ue_Void')
end event

type cb_trax_ship from commandbutton within tabpage_trax
integer x = 891
integer y = 20
integer width = 329
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Ship"
end type

event clicked;
dw_trax.TriggerEvent('ue_Ship')
end event

type cb_trax_clearrall from commandbutton within tabpage_trax
integer x = 375
integer y = 20
integer width = 329
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear &All"
end type

event clicked;
dw_trax.triggerEvent('ue_clearall')
end event

type cb_trax_selectall from commandbutton within tabpage_trax
integer x = 9
integer y = 20
integer width = 329
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select &All"
end type

event clicked;dw_trax.triggerEvent('ue_selectall')
end event

type dw_trax from u_dw_ancestor within tabpage_trax
event ue_ship ( ref datawindow adw_packing )
event ue_print_labels ( )
event ue_selectall ( )
event ue_clearall ( )
event ue_enable ( )
event ue_void ( )
integer x = 27
integer y = 144
integer width = 3122
integer height = 1376
integer taborder = 20
string dataobject = "d_batch_pick_packing_trax"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_ship(ref datawindow adw_packing);
Long	llFindRow, llRowPos, llRowCount
String	lsPrint[], lsWarehouse, lsLocale
u_nvo_trax	luTrax
Integer	liRC

If ib_Changed Then
	Messagebox(is_title,'Please save your changes first.')
	Return
End IF

luTrax = Create u_nvo_Trax

//Validate
liRC = luTrax.uf_validate_BP(idw_trax, idw_Detail, idw_PAck)
If liRC < 0 Then	Return


SetPointer(Hourglass!)

liRC = luTrax.uf_ship_shipment(idw_trax)

//If any of the checked rows have a tracking ID, we will prompt to print labels after retrieve
If This.Find("C_select_Ind='Y'",1,This.RowCount()) > 0 Then

	llRowCount = This.RowCOunt()
	For llRowPos = 1 to llRowCount
		//save array of checked rows - will be lost after refresh
		lsPrint[llRowPos] = This.GEtItemString(llRowPOs,'c_select_ind')
	Next
	
End If

//If succesfull, re-retreive PAck List
If liRC = 0 Then
	idw_Pack.Retrieve(gs_Project,Long(isle_batch_id.text))
End If

//Prompt for print if any of selected rows have a tracking ID assigned...
	
//recheck the rows
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind',lsPrint[llRowPos])
Next

If This.Find("C_select_Ind='Y' and shipper_tracking_ID > ''",1,This.RowCount()) > 0 Then
//If This.Find("C_select_Ind='Y' and shipper_tracking_ID > ''",1,This.RowCount()) > 0 Then
	
	// 08/10 - PCONKL - If TRAX printer Locale is other than 'QPSL', then the labels are being sent to a physical printer. No need to print, just display a confirmation msg that we already did.
	lsWarehouse = idw_Master.GetITemString(1,'wh_code')

	Select trax_printer_locale into :lsLocale
	From Trax_warehouse
	Where project_id = :gs_Project and wh_code = :lsWarehouse;
	
	If lsLocale <> 'QPSL' Then

		Messagebox("ConnectShip call Successful",'ConnectShip Labels(s) sent to printer') // Dinesh - 02/10/2025- SIMS-641-Development for Delivery Order screen change for ConnectShip
		//Messagebox("TRAX call Successful",'TRAX Labels(s) sent to printer')
		
	Else

		//If Messagebox("TRAX call Successful" ,"Would you like to print the TRAX Shipping Labels?",Question!,YesNo!,1) = 1 then
		If Messagebox("TRAX call Successful" ,"Would you like to print the ConnectShip Shipping Labels?",Question!,YesNo!,1) = 1 then//Dinesh - 02/06/2025- SIMS-641- Development for Delivery Order screen change for ConnectShip 
			This.TriggerEvent('ue_Print_labels')
		End If
		
	End If
	
End If

//If This.Find("C_select_Ind='Y' and shipper_tracking_ID > ''",1,This.RowCount()) > 0 Then
//	
//	If Messagebox(is_title,"Would you like to print the TRAX Shipping Labels?",Question!,YesNo!,1) = 1 then
//		This.TriggerEvent('ue_Print_labels')
//	End If
//	
//End If

//Uncheck
This.TriggerEvent('ue_clearall')

SetPointer(Arrow!)
end event

event ue_print_labels();////Print Shipping labels returned from TRAX
//
//Long	llRowCount, llRowPos, llPrintJob, llLen, llstartPos, llRow

// 07/19/2010 ujhall: 06 of 12 Comcast SIK Batch Picking: Replaced previous code for ue_print_labels in w_do.dw_trax
//Print Shipping labels returned from TRAX

Long	llRowCount, llRowPos, llPrintJob, llLen, llstartPos, llRow
String	lsCurrentLabel, lsLabels,  lsTrackID, lsTrackIDSave, lsPrinter, lsProject, lsWarehouse,lsDoNo,lsinvoice
Dec 		ldLoop
Int		i

Str_parms lstrparms
u_nvo_trax	luTrax

luTrax = Create u_nvo_Trax

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	If this.GetITemString(llRowpos,'c_select_ind') <> 'Y' Then Continue

	// 01/08 - PCONKL - We should be printing at the Ship Ref level instead of carton level now, check both for back ass compatability
	//							If Printing at the Ship Ref level, we only need to print once since all labels for a ship ref are in the same file
	//lsinvoice = This.GetITemString(llRowPos,'invoice_no') // Dinesh - 02/27/2025- SIMS-672-CS Migration - Label Print and Re-print not working for container with multiple Packing records
	
	//select do_no into :lsDoNo from delivery_master where Project_Id=:gs_project and invoice_no=:lsinvoice using sqlca; // Dinesh - 02/27/2025- SIMS-672-CS Migration - Label Print and Re-print not working for container with multiple Packing records
	
	If This.GetITemString(llRowPos,'trax_Ship_ref_nbr') > "" Then
		lsTrackID = This.GetITemString(llRowPos,'trax_Ship_ref_nbr')
	Else
		lsTrackID = This.GetITemString(llRowPos,'carton_no')
	End If
	
	If lsTrackID = '' or lsTrackID = lsTrackIDSave Then Continue
	
	lsLabels += luTrax.uf_retrieve_label(lsTrackID, 'CS') /* CS= Create Shipment label type */
	//lsLabels += luTrax.uf_retrieve_labels(lsTrackID,lsDoNo) /* CS= Create Shipment label type */// Dinesh - 02/27/2025- SIMS-672-CS Migration - Label Print and Re-print not working for container with multiple Packing records
	
	lsTrackIDSave = lsTrackID

Next

This.TriggerEvent('ue_clearall')

//String	lsCurrentLabel, lsLabels,  lsTrackID, lsPrinter, lsProject, lsWarehouse,lslabelDest
//Dec 		ldLoop
//Int		i
//Str_parms lstrparms
//u_nvo_trax	luTrax
//
//luTrax = Create u_nvo_Trax
////based on warehouse setting for where labels are printed, we will either print directly from SIMS or send a post to Trax to re-print
//
//llRow = g.of_project_warehouse(lsProject, lsWarehouse)
//
//If llRow > 0 Then
//	lslabelDest = g.ids_project_warehouse.GetITemString(llRow,'trax_label_print_dest')
//End If
//
////If lsLabelDest = 'T' Then /*originally printed from TRAX, send a request to re-print*/
////
////	Return
////	
////End If
//
//llRowCount = This.RowCount()
//For llRowPos = 1 to llRowCount
//	
//	If this.GetITemString(llRowpos,'c_select_ind') <> 'Y' Then Continue
//
//	lsTrackID = This.GetITemString(llRowPos,'carton_no')
//	
//	lsLabels += luTrax.uf_retrieve_label(lsTrackID, 'CS') /* CS= Create Shipment label type */
//
//Next
//
//If lsLabels = "" Then
//	Messagebox(is_title,"There are no TRAX shipping labels to print!")
//	Return
//End If
//
////Print the labels...
//luTrax.uf_Print_Label(lsLabels)
//
//This.TriggerEvent('ue_clearall')
end event

event ue_selectall();
Long	llRowPos, llRowCount

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','Y')
Next

This.SetRedraw(True)

This.TriggerEvent('ue_enable')
end event

event ue_clearall();
Long	llRowPos, llRowCount

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetItem(llRowPos,'c_select_ind','N')
Next

This.SetRedraw(True)

This.TriggerEvent('ue_enable')
end event

event ue_enable();
//Enable or disable buttons based on order status and row(s) being selected

if idw_master.RowCount() < 1 or This.RowCount () < 1 Then
	cb_trax_ship.Enabled = False
	cb_trax_void.Enabled = False
	cb_trax_print_label.enabled = False
	Return
End If

If idw_master.GetItemString(1,'batch_status') = 'C' Then

		cb_trax_ship.Enabled = False
		cb_trax_void.Enabled = False
		
		If This.Find("C_select_Ind = 'Y' and shipper_tracking_id > ''",1,This.RowCount()) > 0 Then
			cb_trax_print_label.enabled = True
		Else
			cb_trax_print_label.enabled = False
		End If

		Return
		
End If

If This.Find("C_select_Ind = 'Y' and Ord_status = 'A' and (shipper_tracking_id = '' or isnull(shipper_tracking_id))",1,This.RowCount()) > 0 Then
	cb_trax_ship.Enabled = True
Else
	cb_trax_ship.Enabled = False
End If

If This.Find("C_select_Ind = 'Y' and Ord_status = 'A' and shipper_tracking_id > ''",1,This.RowCount()) > 0 Then
	cb_trax_void.Enabled = True
	cb_trax_print_label.enabled = True
Else
	cb_trax_void.Enabled = False
	cb_trax_print_label.enabled = False
End If
end event

event ue_void();

u_nvo_trax	luTrax
Integer	liRC

If ib_Changed Then
	Messagebox(is_title,'Please save your changes first.')
	Return
End IF

SetPointer(Hourglass!)

luTrax = Create u_nvo_Trax
liRC = luTrax.uf_void_shipment(idw_master,idw_trax)

//If succesfull, re-retreive PAck List
If liRC = 0 Then
	idw_Pack.Retrieve(gs_Project,Long(isle_batch_id.text))
End If

This.triggerEvent('ue_enable')

SetPointer(arrow!)
end event

event itemchanged;call super::itemchanged;
if dwo.name = 'c_select_ind' Then
	This.PostEvent('ue_enable')
End If
end event

