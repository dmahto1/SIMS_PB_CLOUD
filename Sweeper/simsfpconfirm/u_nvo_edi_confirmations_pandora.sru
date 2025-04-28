HA$PBExportHeader$u_nvo_edi_confirmations_pandora.sru
$PBExportComments$Process outbound edi confirmation transactions for Pandora
forward
global type u_nvo_edi_confirmations_pandora from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_pandora from nonvisualobject
end type
global u_nvo_edi_confirmations_pandora u_nvo_edi_confirmations_pandora

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName,is_ftpdirectoryout
Datastore idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment, idsROMain 
Datastore idsRODetail, idsROPutaway, idsGR, idsGI, idsDOSerial, idsCartonSerial 
Datastore idsSNOut
Datastore idsOMQROMain, idsOMQRODetail, idsOMQROSerial, idsOMExp, idsOMQInvTran, idsOMQInvTxnSernum
Datastore idsOMQWhDOMain, idsOMQWhDODetail, idsOMQWhDOSerial
Datastore idsOMQWhDOAttr, idsOMQWhDoDetailAttr
Datastore idsCCRecon
Datastore idsAltSerialRecords

Datastore ids_CC_UpCountZero_Result, ids_ro_main, ids_ro_detail, ids_ro_putaway, ids_ro_content, ids_ro_serial, ids_ro_serial_detail

Boolean ibDejaVu
n_string_util in_string_util
String is_ToNo_List[]
end variables

forward prototypes
public function integer uf_process_daily_files (string asinifile, string asemail)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
public function string nonull (string as_str)
public function datetime getpacifictime (string aswh, datetime adtdatetime)
public function integer uf_process_cityblock_outbound_rpt ()
public function integer uf_ship_confirm (string asproject, string asdono)
public function integer uf_gi_cityblock (string asproject, string asdono)
public function integer uf_process_kittyhawk_daily_rpt ()
public function integer uf_process_kittyhawk_movement_rpt ()
public function integer uf_decom_inv_rpt ()
public function integer uf_cc_confirm (string as_project, string as_ccno)
public function integer uf_write_soc_inbound (ref datastore adw_output)
public function integer uf_serial_change_rose (string asproject)
public function integer uf_process_ups (string asproject, string asdono)
public function integer uf_process_cityblock_inbound_rpt (string asproject)
public function integer uf_process_cityblock_inventory_rpt ()
public function integer uf_cb_int ()
public function integer uf_ci (string asproject, string asdono)
public function integer uf_gr_rose (string asproject, string asrono, string astransparm)
public function integer uf_oc_rose (string asproject, string astono, string astransparm)
public function boolean uf_is_country_eu_to_eu (string asproject, string as_from_country, string as_to_country)
public function integer uf_gi_rose (string asproject, string asdono, string astransparm, datetime dtrecordcreatedate)
public function integer uf_process_gi_om (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_om_adjustment (string asproject, long aladjustid, long altransid)
public function integer uf_process_gr_om (string asproject, string asrono, long aitransid, string astransparm, string asaction)
public function integer uf_process_serial_change_om (string asproject)
public function integer uf_process_ci_om (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate)
public function integer uf_process_oc_om (string asproject, string astono, string astransparm, long aitransid)
public function string gmtformatoffset (string asgmtoffset)
public function integer uf_process_cc_om (string as_project, string as_ccno, long altransid)
public function string uf_get_rdd_timezone (long al_batch_seq_no, string as_invoice_no)
public function string uf_process_om_receipt_type (string asproject, string asrono, string ascust_po_no)
public function datastore uf_process_cc_reconciliation_serial (ref datastore adsorigsn, long alrow, string as_action_cd, string as_cc_loc, string as_cc_serial_no)
public function datastore uf_process_cc_reconciliation (string as_project, string as_ccno)
public function long uf_process_cc_auto_create_soc (string as_project, string as_cc_no)
public function long uf_process_cc_auto_confirm_soc (string as_project, str_parms as_soc_parms)
public function long uf_process_cc_stock_adjustment (string as_project, str_parms as_inv_parms)
public function long uf_confirm_system_generated_cc (string as_project, string as_ccno)
public function integer uf_process_cc_no_count (string as_project, string as_ccno, string as_wh)
public function integer uf_process_gi_delay_validation (string asproject, string asdono, string ascodedesc)
public function datastore uf_process_cc_reconciliation_count_by (string as_project, string as_ccno)
public function datastore uf_process_cc_up_down_count (string as_project, string as_ccno, string as_wh, string as_sku, ref datastore adsorigsn, ref datastore adsccscansn)
public function integer uf_process_cc_update_serial_attributes (string as_project, string as_ccno)
public function str_parms uf_process_cc_serial_change (str_parms as_serial_parms)
public function long uf_process_create_batch_transaction (string as_project, string as_trans_type, long al_trans_order_id, string as_trans_parm)
public function datastore uf_process_cc_add_update_serialno (string as_action_cd, string as_project_id, string as_wh_code, string as_sku, long al_owner_id, string as_loc, string as_po_no, string as_serial_no)
public function integer uf_process_cc_reconcile_serial_inv_table (string as_project, string as_cc_no)
public function long uf_om_sn_adjustment (string asproject, long al_transid, string as_trans_order_id, string as_itrn_key)
public function long uf_process_cc_serial_change_history (string as_project, string as_cc_no, string as_wh, string as_sku, string as_suppcode, long al_ownerid, string as_pono, string as_from_serial_no, string as_to_serial_no)
public function long uf_process_cc_update_serial_records (string as_project)
public function boolean uf_process_cc_check_serial_no_exists (string as_project, string as_wh, string as_sku, string as_serial_no)
public function long uf_process_cc_is_serial_assigned_tono (string as_sku, string as_tono, string as_serial, long al_line_item_no)
public function integer uf_process_oc_sn_om (string as_project, long al_transid, string as_tono)
public function long uf_process_cc_reconcile_swap_serial_loc (string as_project, string as_ccno)
public function long uf_process_cc_auto_create_soc_serialized (string as_project, string as_cc_no, string as_sku, long al_owner_id, string as_pono)
public function long uf_process_cc_serial_check_variance (string as_project, string as_ccno)
public function string uf_get_next_dummy_serialno ()
public function boolean uf_is_sku_foot_print (string asproject, string assku, string assuppcode)
public function integer uf_process_gi_om_pallet_construct (integer al_attr_row, long aitransid, string as_client_id, string asdono, string as_wh, decimal ad_pallet_qty, string as_carton_no, string as_ref_char4, long al_pack_row)
public function integer uf_process_gi_om_carton_construct (integer al_attr_row, long aitransid, string as_client_id, string asdono, string as_wh, decimal ad_carton_qty, string as_carton_no, string as_ref_char4, long al_pack_row)
public function decimal uf_get_pallet_carton_qty (string asfind)
public function integer uf_create_up_count_zero_inbound_detail (string as_ro_no)
public function integer uf_create_up_count_zero_inbound_putaway (string as_ro_no)
public function boolean uf_is_sku_serialized (string as_project, string as_sku, string as_supp_code)
public function integer uf_create_up_count_zero_cc_records (string as_cc_no)
public function integer uf_create_up_count_zero_inbound_content (string as_project, string as_wh_code, string as_ro_no, datetime adt_today)
public function integer uf_create_up_count_zero_inbound_order (string as_project, string as_cc_no)
public function integer uf_create_up_count_zero_inbound_header (string as_project, string as_cc_no, string as_ro_no, datetime adt_today)
public function integer uf_create_up_count_zero_inbound_serial (string as_project, string as_cc_no)
public function integer uf_create_up_count_zero_serial_records (string as_project, string as_wh_code)
public function integer uf_process_om_cc_inbound_order (string as_project, string as_ro_no, long al_trans_id)
public function long uf_process_cc_remove_recon_filter ()
public function integer uf_process_lwon (string asproject, datetime adtcreatedate, string asloadid, string astransparm)
public function str_parms uf_process_cc_auto_serialno_soc (string as_project, string as_ccno, string as_sku, string as_lcode, long al_ownerid, string as_pono, string as_pono2, string as_container_id, double ad_req_qty, boolean ab_autosoc)
public function datastore uf_process_cc_get_assigned_serialno (string as_tono, string as_sku)
public function long uf_process_om_cc_sn_inbound_order (string as_project, long al_transid, string as_wh_code, string as_ro_no, string as_itrn_key, string as_sku)
public function integer uf_create_up_count_receive_serial_detail (string as_ro_no)
public function integer uf_create_up_count_inbound_serial_rollup (string as_ro_no)
public function integer uf_check_serial_number_exist (string as_project, string as_ccno, string as_wh, string as_location, string as_sku, string as_serialno)
public function integer uf_create_soc945_serial_adj (string as_project, string as_wh_code, string as_ownercd, long al_ownerid, string as_sku, string as_po_no, string as_serialno)
end prototypes

public function integer uf_process_daily_files (string asinifile, string asemail);/* Not implemented for Pandora...
Integer	liRC
String	lsStatusMsg, lsAttachments

//Return code is the number of records processed or -1 if error

isgifilename = ""
istrfilename = ""
isgrfilename = ""
isInvFileName = ""
lsAttachments = ""

liRC = uf_goods_Issue(asInifile, asemail) /*Goods Issue and Shipment files*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Goods Issue and Shipment Files (GI/TR). "
Elseif liRC = 0 Then
	lsStatusMsg += "There were no Shipments for today (GI/TR). "
Else
	
	lsStatusMsg += "Attached are the shipment files for today (GI/TR). "
	
	If isGIFileName > "" Then
		lsAttachments += "," + isGIFileName
	End If
	
	If isTRFileName > "" Then
		lsAttachments += "," + isTRFileName
	End If
	
End If


liRC = uf_goods_Receipt(asInifile, asemail) /*Goods Receipts*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Goods Receipt File (GR). "
Elseif liRC = 0 Then
	lsStatusMsg += "There were no Receipts for today (GR). "
Else
	
	lsStatusMsg += "Attached are the Receipt files for today (GR). "
	
	If isGRFileName > "" Then
		lsAttachments += "," + isGRFileName
	End If
	
End If


liRC = uf_inv_snapshot(asInifile,asEmail) /*Inv snapshot*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Inventory Snapshot File (CO). "
Elseif liRC = 0 Then
	lsStatusMsg += "There is no inventory for today (CO). "
Else
	
	lsStatusMsg += "Attached is the Inventory Snapshot file for today (CO). "
	
	If isINVFileName > "" Then
		lsAttachments += "," + isINVFileName
	End If
	
End If

//Email the Files

If lsAttachments > "" Then
	lsAttachments = Mid(lsAttachments,2,99999) /*strip off first comma*/
End If


If pos(asEmail,"@") > 0 Then
	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Transaction files",lsStatusMsg,lsAttachments)
Else /*no valid email, send an email to the file transfer error dist list*/
	gu_nvo_process_files.uf_send_email("maquet",'FILEXFER',"Unable to email Daily transaction files to Maquet","Unable to email Daily transaction files to Maquet - no email address found - files are still archived","")
End If

*/
Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Pandora for the Stock Adjustment just made
/* Not implemented ...

*/
Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for PANDORA for the order that was just confirmed
/*  - Pandora has Material Transfers and the Inventory Transaction confirmation uses the same format
       for both Inbound and Outbound so sharing new datastore; d_pandora_inv_trans 
	
	  - Now sending confirmations only for Electronic orders and manual orders for GIG-owned and BUILDS-owned inventory
			
*/


Long		llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsToProject, lsTransType, lsRemarks, lsFromProject

Decimal	ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer	liRC
DateTime ldtTemp

decimal	ldTransID

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	//idsGR.Dataobject = 'd_gr_layout'
	idsGR.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsROmain) Then
	idsROmain = Create Datastore
	idsROmain.Dataobject = 'd_ro_master'
	idsROMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsroDetail) Then
	idsroDetail = Create Datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
	idsroDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
//what if it's from the web, with edi_inbound details (for po_no, for example)?
//If idsROMain.GetItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(idsROMain.GetItemNumber(1, 'edi_batch_seq_no')) Then 
	//what if there is a mixture of GIG/BUILDS and non-GIG/BUILDS?
	//Return 0
//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsROMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
end if

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

//For Pandora, instead of WH Code, we need the Sub-Inventory Location (Owner_CD)
//  (still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = idsROMain.GetItemString(1, 'wh_code')
/*		
Select user_field1 into :lsMaquetwarehouse
From Warehouse
Where wh_code = :lsWarehouse;
	
If isnull(lsMaquetwarehouse) Then lsMaquetwarehouse = lswarehouse
*/

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCount = idsROPutaway.RowCount()

// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1
		
For llRowPos = 1 to llRowCount
	
/*	// Rolling up to Line/Sku/Supplier/Inv Type/Po_no (Pkg Cd)/Lot/Expiration Date
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind +=  " and upper(supp_code) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Supp_code')) + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	lsFind += " and expiration_date = '" + String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'YYYYMMDD') + "'"
*/	
	// Rolling up to Line/Sku/PO_no
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU')) + "'"
	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no'))
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'po_no')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())
//TEMPO - Check GR for  	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change (and it shouldn't))
		ldOwnerID = idsROPutaway.GetItemNumber(llRowPos, 'owner_id')
		if ldOwnerID <> ldOwnerID_Prev then
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;
			ldOwnerID_Prev = ldOwnerID
			
			//need to also look up Group (in UF1) to determine GIG Y/N flag
			//select
		    //   case user_field1
			//     when 'GIG' then 'Y'
			//     else 'N' into :lsGigYN
			
			//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
			//  GIG routes to a different directory structure on Pandora's side.
			select user_field1 into :lsGroup
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCd;
			if left(lsGroup, 3) = 'GIG' then 
				lsGigYN = 'Y'
			elseif left(lsGroup, 3) = 'ENT' then // 04-09 - Adding Enterprise as a possible separate routing
				lsGigYN = 'X'
			else
				lsGigYN = 'N'
			end if

			if lsElectronicYN = 'Y' then
				lsTransYN = 'Y'
			else
				//check to see if the Manual Order is GIG/BUILDS (if so, still send transaction)
				//  (need to accommodate any variations of Gig/Builds.  So far, GIG, GIG MRB, PLAT and PLAT_BLDS
				if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' then 
					lsTransYN = 'Y'
				else
					lsTransYN = 'N'
				end if
			end if
		end if

		if lsTransYN = 'Y' then
			llNewRow = idsGR.InsertRow(0)
			// now using a transaction ID Sequence number.  Only grabbing the right-most 15 chars (as that's the limit on the interface)
			idsGR.SetItem(llNewRow, 'trans_id', right(trim(idsROMain.GetItemString(1, 'ro_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			//idsGR.SetItem(llNewRow, 'to_loc', trim(idsROPutaway.GetItemString(llRowPos, 'owner_id'))) 
			//don't send 'FROM' Location if trans type is 'PO RECEIPT'
			lsTransType = trim(idsROMain.GetItemString(1, 'user_field7'))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			if upper(lsTransType) = 'PO RECEIPT' or upper(lsTransType) = 'EXP PO RECEIPT' then // dts - 4/22 -added EXPOPO RECEIPT to this clause
				idsGR.SetItem(llNewRow, 'from_loc', '')
			else
// TAM 12/08/2009 -  Moved 'From Loc' to User_field6
//				idsGR.SetItem(llNewRow, 'from_loc', trim(idsROMain.GetItemString(1, 'user_field3')))
				idsGR.SetItem(llNewRow, 'from_loc', trim(idsROMain.GetItemString(1, 'user_field6')))
			end if
			idsGR.SetItem(llNewRow, 'to_loc', trim(lsOwnerCD))
			
			idsGR.SetItem(llNewRow, 'complete_date', idsROMain.GetItemDateTime(1, 'complete_date'))
			idsGR.SetItem(llNewRow, 'sku', idsROPutaway.GetItemString(llRowPos, 'sku'))
//			lsTransType = trim(idsROMain.GetItemString(1, 'user_field7'))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
//?			//don't send 'FROM' Location if trans type is 'PO RECEIPT'
//?			if upper(lsTransType) = 'PO RECEIPT' then //TEMPO! What about EXP PO RECEIPT?
				idsGR.SetItem(llNewRow, 'from_project', trim(idsROMain.GetItemString(1, 'user_field8')))
//?			end if
			idsGR.SetItem(llNewRow, 'to_project', trim(idsROPutaway.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
			//idsGR.SetItem(llNewRow, 'trans_type', trim(idsROMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGR.SetItem(llNewRow, 'trans_type', lsTransType)  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGR.SetItem(llNewRow, 'trans_source_no', trim(idsROMain.GetItemString(1, 'supp_invoice_no')))
			idsGR.SetItem(llNewRow, 'trans_line_no', string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no')))
	//2/18/09 - now sending line_item_no		idsGR.SetItem(llNewRow, 'trans_line_no', idsROPutaway.GetItemString(llRowPos, 'user_line_item_no'))
			idsGR.SetItem(llNewRow, 'serial_no', idsROPutaway.GetItemString(llRowPos, 'serial_no'))
			idsGR.SetItem(llNewRow, 'quantity', idsROPutaway.GetItemNumber(llRowPos, 'quantity'))
			
			// 04/09 - PCONKL - Remove any carriage returns/Line feeds from Remarks - they cause the files to fail in ICC
			lsREmarks = trim(idsROMain.GetItemString(1, 'remark'))
			
			Do While pos(lsRemarks,"~t") > 0 /*tab*/
				lsREmarks = Replace(lsRemarks, pos(lsRemarks,"~t"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~n") > 0 /*New line*/
				lsREmarks = Replace(lsRemarks, pos(lsRemarks,"~n"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~r") > 0 /*CR*/
				lsREmarks = Replace(lsRemarks, pos(lsRemarks,"~r"),1," ")
			Loop
			
			idsGR.SetItem(llNewRow, 'reference', lsREmarks)  //remarks? UF?
						
			idsGR.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
			
		end if
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Inbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCount
	llNewRow = idsOut.insertRow(0)
	lsOutString = idsGR.GetItemString(llRowPos, 'trans_id') + string(llRowPos) + '|'  // ro_no
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'from_loc')) + '|'
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'to_loc')) + '|' //sub-inventory location (stored as owner)
//	lsOutString += String(idsGR.GetItemDateTime(llRowPos, 'complete_date'), 'yyyy-mm-dd hh:mm:ss') + '|'
	ldtTemp = idsGR.GetItemDateTime(llRowPos, 'complete_date')
	ldtTemp = GetPacificTime(lsWH, ldtTemp)
	lsOutString += String(ldtTemp, 'yyyy-mm-dd hh:mm:ss') + '|'
	lsOutString += idsGR.GetItemString(llRowPos, 'sku') + '|'
	// 4-09-09 - now suppressing NA 'FROM' project as well... lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'from_project')) + '|' /* Pandora 'From' Project (from RM.UF8) */	
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsFromProject = upper(idsGR.GetItemString(llRowPos, 'from_project')) /* Pandora 'From' Project (from RM.UF8) */	
	lsFromProject = idsGR.GetItemString(llRowPos, 'from_project') /* Pandora 'From' Project (from RM.UF8) */	
	If lsFromProject <> '-' and upper(lsFromProject) <> 'NA' and upper(lsFromProject) <> 'N/A' Then 
		lsOutString += NoNull(lsFromProject) + '|' 
	Else
		lsOutString += "|"
	End If
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsToProject = upper(idsGR.GetItemString(llRowPos, 'to_project')) /* Pandora Project (from po_no) */
	lsToProject = idsGR.GetItemString(llRowPos, 'to_project') /* Pandora Project (from po_no) */
	If lsToProject <> '-' and upper(lsToProject) <> 'NA' and upper(lsToProject) <> 'N/A' Then 
		lsOutString += NoNull(lsToProject) + '|' 
	Else
		lsOutString += "|"
	End If
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'trans_type')) + '|'  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'trans_source_no')) + '|' //supp_invoice_no
	lsOutString += idsGR.GetItemString(llRowPos, 'trans_line_no') + '|'
	if Trim(NoNull(idsGR.GetItemString(llRowPos, 'serial_no')))  = '-' then
		lsOutString += '|'
	else
		lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'serial_no')) + '|'
	end if
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'reference')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos, 'gig_yn') //?trailing delimiter? + '|'
	
//	lsOutString += lsComplete
	
	idsOut.SetItem(llNewRow, 'Project_id', asProject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	idsOut.SetItem(llNewRow, 'file_name', 'IT' + String(ldBatchSeq, '000000') + '.DAT') 
//end if //TEMPO!!!
	
next /*next output record */

/*
//Add a trailer Record???
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'MT' + String(ldBatchSeq,'000000') + '.DAT') 
*/

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for PANDORA for the order that was just confirmed
/*  - Pandora has Material Transfers and the Inventory Transaction Confirmation uses the same format
       for both Inbound and Outbound so sharing new datastore; d_pandora_inv_trans 
	
	  - Now sending confirmations only for Electronic orders and manual orders for GIG-owned and BUILDS-owned inventory
			
			*/

Long		llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType

Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer		liRC
datetime ldtTemp
decimal	ldTransID

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGI) Then
	idsGI = Create Datastore
	idsGI.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGI.Reset()

lsLogOut = "      Creating Inventory Transaction (GI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master, Detail and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
//what if it's from the web, with edi_inbound details (for po_no, for example)?
//If idsDOMain.GetItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetItemNumber(1, 'edi_batch_seq_no')) Then 
	//check to see if the manual order is GIG/Builds/Upgrades or not....
	//Return 0
//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
end if

idsDoPick.Retrieve(asDoNo)

//For Pandora, still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = idsDOMain.GetItemString(1, 'wh_code')

//For each sku/line Item/ in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc )

llRowCount = idsDOPick.RowCount()

// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1
		
For llRowPos = 1 to llRowCount
//TEMPO - Check GR for  	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	//Rollup to SKU/Line
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
	lsFind += " and trans_line_no = " + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no'))
	llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		//idsGI.SetItem(llNewRow, 'from_loc', trim(idsDOPick.GetItemString(1, 'owner_id'))) //TEMPO! NEED OWNER CODE HERE, not Owner_ID!
		//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change (and it shouldn't))
		ldOwnerID = idsDOPick.GetItemNumber(1, 'owner_id')

		if ldOwnerID <> ldOwnerID_Prev then
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;
			ldOwnerID_Prev = ldOwnerID

			//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
			//  GIG routes to a different directory structure on Pandora's side.
			select user_field1 into :lsGroup
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCd;
			if left(lsGroup, 3) = 'GIG' then 
				lsGigYN = 'Y'
			elseif left(lsGroup, 3) = 'ENT' then // 04-09 - Adding Enterprise as a possible separate routing
				lsGigYN = 'X'
			else
				lsGigYN = 'N'
			end if
			if lsElectronicYN = 'Y' then
				lsTransYN = 'Y'
			else
				//check to see if the Manual Order is GIG/BUILDS (if so, still send transaction)
				if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' then 
					lsTransYN = 'Y'
				else
					lsTransYN = 'N'
				end if
			end if
		end if

		if lsTransYN = 'Y' then
			llNewRow = idsGI.InsertRow(0)
			//idsGI.SetItem(llNewRow, 'trans_id', trim(idsDOMain.GetItemString(1, 'do_no'))) // do_no for outbound
			// now using a transaction ID Sequence number.  Only grabbing the right-most 15 chars (as that's the limit on the interface)
			idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			idsGI.SetItem(llNewRow, 'from_loc', trim(lsOwnerCD))
	
			idsGI.SetItem(llNewRow, 'to_loc', trim(idsDOMain.GetItemString(1, 'cust_code')))
			idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
			idsGI.SetItem(llNewRow, 'sku', idsDOPick.GetItemString(llRowPos, 'sku'))
			idsGI.SetItem(llNewRow, 'from_project', trim(idsDOPick.GetItemString(1, 'po_no')))  /* Pandora Project */
			idsGI.SetItem(llNewRow, 'to_project', trim(idsDOMain.GetItemString(1, 'user_field8')))
			idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))
			idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
			//TEMPO!! - does this need to be the User Line No?  If so, store in User_Field on the line?
	//		idsGI.SetItem(llNewRow, 'trans_line_no', string(idsROPutaway.GetItemNumber(llRowPos, 'user_line_item_no')))
			idsGI.SetItem(llNewRow, 'serial_no', idsDOPick.GetItemString(llRowPos, 'serial_no'))
			idsGI.SetItem(llNewRow, 'quantity', idsDOPick.GetItemNumber(llRowPos, 'quantity'))
//			idsGI.SetItem(llNewRow, 'reference', trim(idsDOMain.GetItemString(1, 'remark')))  //remarks? UF? Invoice?
			idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
		end if
	End If
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGI.RowCount()
For llRowPos = 1 to llRowCount
	llNewRow = idsOut.insertRow(0)
	//lsOutString = idsGI.GetItemString(llRowPos, 'trans_id') + '|'  // ro_no
	lsOutString = idsGI.GetItemString(llRowPos, 'trans_id') + string(llRowPos) + '|'  // ro_no
//	// 4-09-09 - now suppressing FROM Location if TransType not Material Receipt
//	lsTransType = upper(idsGI.GetItemString(llRowPos, 'trans_type'))  //PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
//	if lsTransType = 'MATERIAL RECEIPT' then
		lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'from_loc')) + '|'
//	else
//		lsOutString += '|'
//	end if
	lsOutString += idsGI.GetItemString(llRowPos, 'to_loc') + '|' //sub-inventory location (stored as owner)
	//lsOutString += String(idsGI.GetItemDateTime(llRowPos, 'complete_date'), 'yyyy-mm-dd hh:mm:ss') + '|'
	ldtTemp = idsGI.GetItemDateTime(llRowPos, 'complete_date')
	ldtTemp = GetPacificTime(lsWH, ldtTemp)
	lsOutString += String(ldtTemp, 'yyyy-mm-dd hh:mm:ss') + '|'
	lsOutString += idsGI.GetItemString(llRowPos, 'sku') + '|'
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsFromProject = upper(idsGI.GetItemString(llRowPos, 'from_project')) /* Pandora Project (from po_no) */
	lsFromProject = idsGI.GetItemString(llRowPos, 'from_project') /* Pandora Project (from po_no) */
	If lsFromProject <> '-' and lsFromProject <> 'NA' and lsFromProject <> 'N/A' Then 
		lsOutString += NoNull(lsFromProject) + '|' 
	Else
		lsOutString += "|"
	End If
	// dts 04-09-09 ... now suppressing 'TO' project as well
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsToProject = upper(idsGI.GetItemString(llRowPos, 'to_project')) /* Pandora 'To' Project (from RM.UF8) */	
	lsToProject = idsGI.GetItemString(llRowPos, 'to_project') /* Pandora 'To' Project (from RM.UF8) */	
	If lsToProject <> '-' and upper(lsToProject) <> 'NA' and upper(lsToProject) <> 'N/A' Then 
		lsOutString += NoNull(lsToProject) + '|' 
	Else
		lsOutString += "|"
	End If
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'trans_type')) + '|'  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'trans_source_no'))+ '|' //supp_invoice_no
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'trans_line_no')) + '|'
	If idsGI.GetItemString(llRowPos, 'serial_no') <> '-' Then
		lsOutString += idsGI.GetItemString(llRowPos, 'serial_no') + '|'
	Else
		lsOutString += "|"
	End If	
	lsOutString += string(idsGI.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'reference')) + '|'
	lsOutString += idsGI.GetItemString(llRowPos, 'gig_yn') //?trailing delimiter? + '|'
	
//	lsOutString += lsComplete
	
	idsOut.SetItem(llNewRow, 'Project_id', asProject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	idsOut.SetItem(llNewRow, 'file_name', 'IT' + String(ldBatchSeq, '000000') + '.DAT') 
	
next /*next output record */

/*
//Add a trailer Record???
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'MT' + String(ldBatchSeq,'000000') + '.DAT') 
*/

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0

end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

public function datetime getpacifictime (string aswh, datetime adtdatetime);string lsOffset, lsOffsetFremont
Dec   llNetOffset, llTimeSecs			// 6/8/2017 GailM Datatype changed from Long to Dec to allow partial hour time zone offsets (Pandora  PDA-425)
date ldDate
time ltTime, ltTimeNew

select gmt_offset into :lsOffsetFremont
from warehouse
where wh_code = 'PND_FREMNT';

if asWH = 'GMT' then
	lsOffset = '0'
else
	select gmt_offset into :lsOffset
	from warehouse
	where wh_code = :asWH;
end if

// see if subtracting the offset would make it the previous day. If so, subtract a day and the remainder of the Offset.
// - if the offset is negative (West of Fremont), see if adding the offset would make it the next day. If so, add a day and the remainder of Offset
llNetOffset = Dec(lsOffset) - Dec(lsOffsetFremont)
llNetOffset = llNetOffset * 60 * 60  //convert the offset to seconds
ldDate = date(adtDateTime)
ltTime = time(adtDateTime)
ltTimeNew = ltTime
if llNetOffset > 0 then
	llTimeSecs = SecondsAfter(time('00:00'), ltTime)
	if llTimeSecs < llNetOffset then
		ldDate = RelativeDate(ldDate, -1)
		ltTimeNew = RelativeTime(time('23:59:59'), - (llNetOffset - llTimeSecs))
	else
		ltTimeNew = RelativeTime(ltTime, - llNetOffset)
	end if
elseif llNetOffset < 0 then  //Net Offset is negative - selected WH is West of Fremont. Going to add time to convert to Pacific
	llTimeSecs = SecondsAfter(ltTime, time('23:59:59')) //seconds remaining in the day
	if llTimeSecs < llNetOffset then // time remaining in the day is less than the net offset....
		//so add a day and add the remaing time
		ldDate = RelativeDate(ldDate, +1)
		ltTimeNew = RelativeTime(time('00:00'),  (llNetOffset - llTimeSecs))
	else
		// adding the net offset won't require adding another day
		ltTimeNew = RelativeTime(ltTime, llNetOffset)
	end if
end if

//ltTimeNew = RelativeTime(ltTime, - llNetOffset*60*60)
//if ltTimeNew > ltTime then  // are there any locations West of Pacific (Hawaii or other?)
//	ldDate = RelativeDate(ldDate, -1)
//end if
adtDateTime = DateTime(ldDate, ltTimeNew)
//adtDate = RelativeDate(adtDate, llNetOffset)
return adtDateTime
end function

public function integer uf_process_cityblock_outbound_rpt ();
//Process the Cityblock Outbound Order  Report
//Modified: TimA 04/13/2011 for Pandora #190

String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsDONO, lsSerial
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsOrders, ldsOut
DateTime			ldtToday
string				lsDate

//Jxlim 09/02/2011 Added Date time stamp
ldtToday = DateTime(Today(), Now())
lsdate =  String(ldtToday, 'YYYYMMDD_HHMMSS')

lsLogOut = "      Creating Pandora CityBlock Outbound ORder File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsOrders = Create Datastore

//Jxlim 10/24/2011 Commented out servername checking, this is ready for production BRD #303
//if sqlca.database <> "sims33prd" then //check for production database
//if sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database
					//Jxlim 10/15/2011 CB outbound report new query
					sql_syntax = "Select DM.do_no, wh_Code, DPD.sku, ord_date, DM.User_field12, DM.Cust_Code, DM.city, "
					sql_syntax += " DM.country, DM.invoice_no, DPD.quantity, dsd.serial_no, DM.carrier, DM.awb_bol_no, DM.User_field13, DM.complete_date, O.Owner_CD "
					sql_syntax += "  From Delivery_MAster DM with(nolock) "
					sql_syntax += "  Inner join Delivery_Picking_Detail DPD with(nolock) on dm.DO_No=DPD.DO_No "
					sql_syntax += "  Inner join Item_Master IM with(nolock) on DM.project_id = IM.Project_ID and DPD.sku = IM.Sku and DPD.supp_Code = IM.Supp_Code "
					sql_syntax += "  Inner join Owner O with(nolock) on DPD.Owner_ID = O.Owner_ID "
					sql_syntax += "  Inner join Delivery_Serial_Detail dsd with(nolock) on dpd.ID_No = dsd.ID_No "
					sql_syntax += "  Where  DM.Project_id = 'Pandora' "
					sql_syntax += "  and DM.Ord_status in ('C', 'D') "
					sql_syntax += "  and (DM.file_transmit_ind is null or DM.file_transmit_ind <> 'Y') "
					sql_syntax += "  and DM.do_no = DPD.do_no "
					sql_syntax += "  and IM.grp = 'CB'  "
					//Jxlim 11/02/2011 Change to use inner join
//					sql_syntax += "  From Delivery_MAster with(nolock), Delivery_Picking with(nolock), Item_MASter with(nolock),Owner with(nolock), Delivery_Picking_Detail dpd with(nolock), Delivery_Serial_Detail dsd with(nolock) "
//					sql_syntax += "  Where  Delivery_MASter.Project_id = 'Pandora' "
//					sql_syntax += "  and Delivery_Picking.DO_No = dpd.DO_No  and Delivery_Picking.Line_Item_No = dpd.Line_Item_No and dpd.ID_No = dsd.ID_No "  
//					sql_syntax += "  and Delivery_Master.Ord_status in ('C', 'D')  "
//					sql_syntax += "  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
//					sql_syntax += "  and Delivery_MAster.do_no = Delivery_Picking.do_no  "
//					sql_syntax += "  and Delivery_MAster.project_id = Item_MAster.Project_ID	 "
//					sql_syntax += "  and Delivery_Picking.sku = Item_MAster.Sku  "
//					sql_syntax += "  and Delivery_Picking.supp_Code = Item_MAster.Supp_Code  "
//					sql_syntax += "  and Delivery_Picking.Owner_ID = Owner.Owner_ID "
//					sql_syntax += "  and item_master.grp = 'CB'  "
//Else
//					//TimA 04/13/2011 Pandora #190
//					sql_syntax = "Select Delivery_MAster.do_no, wh_Code, ord_date, Delivery_MAster.User_field12, Cust_Name, city, "
//					sql_syntax += "  country, invoice_no, quantity, serial_no, carrier, awb_bol_no, Delivery_MAster.User_field13, complete_date, owner.Owner_CD "
//					sql_syntax += "  From Delivery_MAster with(nolock), Delivery_Picking with(nolock), Item_MASter with(nolock),Owner with(nolock) "
//					sql_syntax += "  Where  Delivery_MASter.Project_id = 'Pandora' and (Owner.Project_ID = 'Pandora' and right(rtrim(owner_cd),3)='CTY' or right(rtrim(owner_cd),2)='CB') "
//					sql_syntax += "  and Delivery_Master.Ord_status in ('C', 'D')  "
//					sql_syntax += "  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
//					sql_syntax += "  and Delivery_MAster.do_no = Delivery_Picking.do_no  "
//					sql_syntax += "  and Delivery_MAster.project_id = Item_MAster.Project_ID	 "
//					sql_syntax += "  and Delivery_Picking.sku = Item_MAster.Sku  "
//					sql_syntax += "  and Delivery_Picking.supp_Code = Item_MAster.Supp_Code  "
//					sql_syntax += "  and Delivery_Picking.Owner_ID = Owner.Owner_ID "
//					sql_syntax += "  and item_master.grp = 'CB'  "
//End If

//sql_syntax = " Select Delivery_MAster.do_no, wh_Code, ord_date, Delivery_MAster.User_field12, Cust_Name, city, country, invoice_no, quantity, serial_no, carrier, awb_bol_no, Delivery_MAster.User_field13, complete_date  "
//sql_syntax += "  From Delivery_MAster, Delivery_Picking, Item_MASter "
//sql_syntax += "  Where Delivery_MASter.Project_id = 'Pandora' and Delivery_Master.Ord_status in ('C', 'D') and (file_transmit_ind is null or file_transmit_ind <> 'Y') and "
//sql_syntax += " Delivery_MAster.do_no = Delivery_Picking.do_no and "
//sql_syntax += " Delivery_MAster.project_id = Item_MAster.Project_ID	and Delivery_Picking.sku = Item_MAster.Sku and Delivery_Picking.supp_Code = Item_MAster.Supp_Code and item_master.grp = 'CB' "

ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora CityBlock  (Outbound ORder Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsOrders.SetTransobject(sqlca)

lLRowCount = ldsOrders.Retrieve()


lsLogOut = "    - " + String(lLRowCount) + " Order  records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Jxlim 11/01/2011 Send emptry file with header when there not record.
//Add a column Header Row*/
//If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	//Jxlim 10/24/2011 Commented out servername check, this is ready for production
	//Jxlim 10/20/2011 BRD #303 Replace customer name with customer code
	//if 	sqlca.database <> "sims33prd" then //check for production database
	//if sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database
		lsOutString = "Order Date,Vehicle ID,Warehouse,GPN,Customer Code,City,Country,Order,Qty,Lines,Cartons,Serial #,Carrier,AWB,Return AWB,Ship Date"
//	Else
//		lsOutString = "Order Date,Vehicle ID,Warehouse,Customer Name,City,Country,Order,Qty,Lines,Cartons,Serial #,Carrier,AWB,Return AWB,Ship Date"
//	End If
	//Jxlim 10/21/2011 BRD #303 end of changed
	
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//Jxlim 09/02/2011 Added Date time stamp
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT_' + lsdate + '.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
//End If

For llRowPos = 1 to lLRowCount /*Each Order*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = String(ldsOrders.GetITemDateTime(llRowPos,'Ord_Date'),'yyyy-mm-dd') + ","
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'User_Field12')) Then /*vehicle ID */
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'User_Field12') + '",'
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'wh_code')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'wh_code') + '",'
	Else
		lsOutString += ","
	End If
	
	//Jxlim 10/24/2011 Commented out servername check, this is ready for production
	//Jxlim 10/20/2011 BRD #303 Added GPN and replace customer name with customer code
	//if sqlca.database <> "sims33prd" then //check for production database	
	//if sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database
		//SKU
		If Not isnull(ldsOrders.GetITemString(llRowPos,'sku')) Then
				lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'sku') + '",'
		Else
				lsOutString += ","
		End If
		//Replace customer name with cust code
		If Not isnull(ldsOrders.GetITemString(llRowPos,'Cust_Code')) Then
			lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Cust_Code') + '",'
		Else
			lsOutString += ","
		End If
//	Else
//		If Not isnull(ldsOrders.GetITemString(llRowPos,'Cust_Name')) Then
//			lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Cust_Name') + '",'
//		Else
//			lsOutString += ","
//		End If
//	End If
	//Jxlim 10/20/2011 BRD #303 end of modification
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'city')) Then
		lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'city') +'",'
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Country')) Then
		lsOutString += '"' +  ldsOrders.GetITemString(llRowPos,'country') + '",'
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Invoice_No')) Then
		lsOutString += '"' +  ldsOrders.GetITemString(llRowPos,'Invoice_no') + '",'
	Else
		lsOutString += ","
	End If
	
	//Jxlim 10/20/2011 BRD #303 qty always 1when serialized.
	If Not isnull(ldsOrders.GetITemNumber(llRowPos,'Quantity')) Then
		//lsOutString += '"' + String(ldsOrders.GetITemNumber(llRowPos,'Quantity')) + '",'
		lsOutString += "1,"
	Else
		lsOutString += ","
	End If
	
	lsOutString += "1," /*lines always 1*/
	lsOutString += "1," /*Cartons always 1*/
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'serial_no')) and ldsOrders.GetITemString(llRowPos,'serial_no') <> '-' Then
		//Serial may contain '.' ... 
		//lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'serial_no') +'",'
		lsSerial = ldsOrders.GetITemString(llRowPos,'serial_no')
		if right(lsSerial, 1) = '.' then lsSerial = left(lsSerial, len(lsSerial)-1)
		lsOutString += '"' + lsSerial +'",'
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Carrier')) Then
		If Left(ldsOrders.GetITemString(llRowPos,'Carrier'),2) = 'FD'  or Left(ldsOrders.GetITemString(llRowPos,'Carrier'),2) = 'FE'  Then
			lsOutString += "FEDEX," 
		Else
			lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Carrier') +'",'
		End If
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'awb_bol_no')) and ldsOrders.GetITemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += '"' +  ldsOrders.GetITemString(llRowPos,'awb_bol_no') +'",'
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'User_Field13')) Then /*Return AWB */
		lsOutString += '"' +  ldsOrders.GetITemString(llRowPos,'User_Field13')  +'",'
	Else
		lsOutString += ","
	End If
	
	lsOutString += String(ldsOrders.GetITemDateTime(llRowPos,'Complete_Date'),'yyyy-mm-dd') 
	
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//Jxlim 09/02/2011 Added Date time stamp
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT_' + lsdate + '.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
		
Next /*Order Record*/

//TimA Pandora issue #281
//Add one more row to the file and place a <EOF> to show that it is the end of the file
If llNewRow > 0 then
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = '<EOF>'
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//Jxlim 09/02/2011 Added Date time stamp
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_OUTBOUND_RPT_' + lsdate + '.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB')
End if

//Update the File Transmit Ind so we don;t send again
For llRowPos = 1 to lLRowCount /*Each Order*/
	
	lsDONO = ldsOrders.GetITEmString(llRowPos,'do_no')
	
	Update Delivery_MASter
	Set File_Transmit_ind = 'Y'
	Where do_no = :lsDONO;
	
	Commit;
	
Next

If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_ship_confirm (string asproject, string asdono);/*  Prepare Ship Confirmation for the New or Replacement Order for Enterprise (see DMA PDA_SIMSSHv1_0)
Record_ID	(='701GI' - 701 is for routing to Enterprise)
Complete_Date
Cust_Order_No
Carrier
DM.User_Field7
Freight_ETA
Line_Item_No
Serial_No
Delivery_Picking.UF1
Delivery_Packing.UF1
Delivery_Packing.UF2
Owner
gig y/n? (= 'x')
Comments: The inbound ASN file naming format will  be as "asn-<date>-<partner po>-<id>.xml".  
The breakup of it would be as below:-                                                                                                                                                                                                       
asn - date (System Date the file is sent out of ICC)
- partner PO ( Cust_Order_No when referencing SIMS & Buyer Order No. when referencing Pandora)
- ID which is sequential number and is optional and would be used only if there are multiple ASNs for a Partner PO - followed by a .xml.
  - for that, count completed orders of same Order Number (how many times has this OrderNo shipped?)
*/



Long			llRowPos, llRowCount, llNewRow, llLineItemNo,	llBatchSeq, llPickRow
//llDetailRow,	
				
String		lsFind,lsOutString, lsMessage, lsSku, lsSupplier, lsInvoice,	lsTemp, lsCarrier, lsCurrencyCode, lsShipTo,	&
				lsShipFrom, lsCustCode, lsCustSKU, lsUCCSCode, lsFolder, lsLineItemNo

Decimal		ldBatchSeq, ldGrossWeight, ldnetWeight, ldTemp,ldFreight, ldTotalAmount, ldPrice, ldQTY, ldtax, ldOther
decimal		ldOwnerID, ldOwnerID_Prev
string			lsOwnerCD
Integer		liRC

String	lsLogOut
long llAllocQty

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPack) Then
	idsDOPack = Create Datastore
	idsDOPack.Dataobject = 'd_do_Packing'
	idsDOPack.SetTransObject(SQLCA)
End If

//If Not isvalid(idsDODetail) Then
//	idsDODetail = Create Datastore
//	idsDODetail.Dataobject = 'd_do_detail'
//	idsDODetail.SetTransObject(SQLCA)
//End If

idsOut.Reset()

//Retrieve Delivery Master, Detail, Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//idsDoDetail.Retrieve(asDoNo) /*detail Records*/
idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*Pack Records */

lsLogOut = "        Creating 701GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Ship Confirmation.~r~rConfirmation will not be sent to Pandora!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//scroll thru packing, look up picking...
llRowCount = idsDoPack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = idsDOpack.GetItemString(llRowPos,'SKU')
	lsLineItemNo = string(idsDOpack.GetItemNumber(llRowPos,'Line_Item_no'))
	
	lsFind = "Line_item_No = " + lsLineItemNo + " and Upper(SKU) = '" + upper(lsSKU) +  "'"
	llPickRow = idsdoPick.Find(lsFind, 1, idsdoPick.RowCount())

//TEMPO - use NoNull...
	//Build and Write the record
	lsOutString = '701GI|' 	//record type
	lsOutString += String(idsDOMain.GetItemDateTime(1,'complete_date'), 'yyyy-mm-dd hh:mm:ss') + '|'	//complete date
	lsTemp = idsDOMain.GetItemString(1, 'cust_order_no') //Customer Order Number
	lsOutString += NoNull(lsTemp) + '|'
	lsTemp = idsDOMain.GetItemString(1, 'Carrier') //Carrier
	lsOutString += NoNull(lsTemp) + '|'
	lsTemp = idsDOMain.GetItemString(1, 'User_Field7') //Transaction Type
	lsOutString += NoNull(lsTemp) + '|'
	lsOutString += String(idsDOMain.GetItemDateTime(1,'freight_eta'), 'yyyy-mm-dd hh:mm:ss') + '|'	//ETA
	lsOutString += lsLineItemNo + '|'
	lsTemp = idsDOPick.getItemString(llPickRow, 'serial_no')
	lsOutString += NoNull(lsTemp) + '|'
	lsTemp = idsDOPick.getItemString(llPickRow, 'user_field1') //Appliance ID
	lsOutString += NoNull(lsTemp) + '|'
	lsTemp = idsDOpack.GetItemString(llRowPos, 'user_field1') //Reference Number
	lsOutString += NoNull(lsTemp) + '|'
	lsTemp = idsDOpack.GetItemString(llRowPos, 'user_field2') // Return Transport Route ID
	lsOutString += NoNull(lsTemp) + '|'
	ldOwnerID = idsDOPick.GetItemNumber(llPickRow, 'owner_id')
	if ldOwnerID <> ldOwnerID_Prev then
		select owner_cd into :lsOwnerCD
		from owner
		where project_id = :asProject and owner_id = :ldOwnerID;
		ldOwnerID_Prev = ldOwnerID
	end if
	lsOutString += lsOwnerCD + '|'
	lsOutString += 'X|' //GigYN - Always 'X' to imply Enterprise (701 routing for ICC)
Next /* Pack Record */

/*
If not isnull(idsDOMain.GetITemNumber(1,'ctn_cnt')) Then									// Carton Count
	ldTemp = idsDOMain.GetITemNumber(1,'ctn_cnt')
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'0000000')

//Total Shipment Weight - Sum gross weight and net weights from Packing 
ldGrossWeight = 0
ldNetWeight = 0
llRowCOunt = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	ldGrossWEight += idsDOPack.GetITemNumber(llRowPos,'weight_Gross')
	ldnetWEight += idsDOPack.GetITemNumber(llRowPos,'weight_net')
Next
If not isnull(ldGrossWEight) Then																//Total Shipment Weight
	ldTemp = ldGrossWEight * 100000																// 5 implied decimals
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'000000000000')
*/

//write to DB for sweeper to pick up
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow, 'Project_id', 'PANDORA') /* hardcoded to match entry in .ini file for file destination*/
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString) 
//idsOut.SetItem(llNewRow, 'batch_data_2', lsOutString2)


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DS
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'HILLMAN')

Return 0
end function

public function integer uf_gi_cityblock (string asproject, string asdono);	
//Send an email ASN notification to Pandora


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llBatchSeq
String		lsFind, lsLogOut, lsText, lsFromName, lsFromAddr1, lsFromCity, lsFromState, lsFromZip, lsWarehouse, lsCarrierCode, lsCarrierName, lsURL, lsFileName, lsCustCode, lsEmail, lsOrder, lsTrackIDSave
Integer		liRC, liFileNo

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_packing'
	idsDoPack.SetTransObject(SQLCA)
End If


idsdoDetail.Reset()
idsdoPack.Reset()

//Retreive Delivery Master, Detail and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsLogOut = "        Creating GI ASN Email to Pandora For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

idsDoDetail.Retrieve(asDoNo)

idsDoPack.Retrieve(asDoNo)
idsDoPack.SetSort("shipper_tracking_id A")
idsDoPack.Sort()

//Need Ship From Address
lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')
lsOrder =  idsDoMain.GetItemString(1,'Invoice_no')

select   wh_name, address_1, city, state, zip
into	 :lsFromName, :lsFromAddr1, :lsFromCity, :lsFromState, :lsFromZip
From Warehouse
Where wh_Code = :lsWarehouse;


//Email
lsEmail = idsDOMain.GetITemString(1,'email_address')
If isnull(lsEmail) Then lsEmail = ''

//Get Carrier Name from Code
lsCarrierCode =  idsDoMain.GetITemString(1,'carrier')
If isNull(lsCarrierCode) Then lsCarrierCode = ''

If lsCarrierCode > ''  Then
	
	Select Carrier_name into :lsCarrierName
	From Carrier_Master
	Where project_id = :asProject and carrier_Code = :lsCarrierCode;
	
End If

If isNull(lsCarrierName) then
	lsCarrierName = ""
Else
	lsCarrierName += " (" + lsCarrierCode + ")"
End If


lsLogOut = "        Creating GI (ASN) Email For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Add header info to email text

//Ship Date
lsText += "~n~n"
LsText = "Ship Date:~t~t"
lsText += String(idsDoMain.GetITemDateTime(1,"Complete_date"),"mm/dd/yyyy hh:mm")

lsText += "~n~n"

//Order Number
lsText += "Order Number:~t"
lsText +=lsOrder

lsText += "~n~n"

//Ship From 	
lsText += "Ship From:~t~t"
If Not isnull(lsFromName) Then
	lsText += lsFromName
End If

lsText += "~n"

lsText += "~t~t~t"
If Not isnull(lsFromAddr1) Then
	lsText += lsFromAddr1
End If

lsText += "~n"

lsText += "~t~t~t"
If Not isnull(lsFromCity) Then
	lsText += lsFromCity + ", "
End If

If Not isnull(lsFromState) Then
	lsText += lsFromState + " "
End If

If Not isnull(lsFromZip) Then
	lsText += lsFromZip 
End If

lsText += "~n~n"
	


//Ship To
If Not isnull(idsDoMain.GetITemString(1,'cust_name')) Then
	lsText += "Ship To:~t~t"
	lsText += idsDoMain.GetITemString(1,'cust_name')
	lsText += "~n"
End If


If Not isnull(idsDoMain.GetITemString(1,'address_1')) Then
	lsText += "~t~t~t"
	lsText += idsDoMain.GetITemString(1,'address_1')
	lsText += "~n"
End If

If Not isnull(idsDoMain.GetITemString(1,'address_2')) Then
	lsText += "~t~t~t"
	lsText += idsDoMain.GetITemString(1,'address_2')
	lsText += "~n"
End If

If Not isnull(idsDoMain.GetITemString(1,'address_3')) Then
	lsText += "~t~t~t"
	lsText += idsDoMain.GetITemString(1,'address_3')
	lsText += "~n"
End If

If Not isnull(idsDoMain.GetITemString(1,'address_4')) Then
	lsText += "~t~t~t"
	lsText += idsDoMain.GetITemString(1,'address_4')
	lsText += "~n"
End If


lsText += "~t~t~t"
If Not isnull(idsDoMain.GetITemString(1,'city')) Then
	lsText += idsDoMain.GetITemString(1,'city') + ", "
End If

If Not isnull(idsDoMain.GetITemString(1,'state')) Then
	lsText += idsDoMain.GetITemString(1,'state') + " "
End If

If Not isnull(idsDoMain.GetITemString(1,'zip')) Then
	lsText += idsDoMain.GetITemString(1,'zip') 
End If

lsText += "~n~n"

//Carrier
lsText += "Carrier:~t~t~t"
lsText += lsCarrierName

lsText += "~n"

//AWB
lsText += "Tracking Nbr:~t~t"
If Not isnull(idsDoMain.GetITemString(1,'awb_bol_no')) Then
	lsText += idsDoMain.GetITemString(1,'awb_bol_no') 
End If

//Return Tracking ID (UF13)
lsText += "~n"
lsText += "Return Tracking Nbr:~t"
If Not isnull(idsDoMain.GetITemString(1,'User_Field13')) Then
	lsText += idsDoMain.GetITemString(1,'User_Field13') 
End If

//Vehicle ID (UF12)
lsText += "~n"
lsText += "Vehicle ID:~t~t~t"
If Not isnull(idsDoMain.GetITemString(1,'User_Field12')) Then
	lsText += idsDoMain.GetITemString(1,'User_Field12') 
End If

//Requestor (UF11)
lsText += "~n"
lsText += "Requestor:~t~t~t"
If Not isnull(idsDoMain.GetITemString(1,'User_Field11')) Then
	lsText += idsDoMain.GetITemString(1,'User_Field11') 
End If


//Add any additional TRAX Tracking ID's from PAcking List - First one should be in the AWB field
lsTrackIdSave = idsDoMain.GetITemString(1,'awb_bol_no') 
llRowCount = idsDoPack.RowCount()
For llRowPos = 1 to llRowCOunt
	
		If idsDoPack.GetITemString(llRowPos,'shipper_tracking_id') <> lsTrackIDSave and  idsDoPack.GetITemString(llRowPos,'shipper_tracking_id') > '' THen
			
			lsText += ", " +  idsDoPack.GetITemString(llRowPos,'shipper_tracking_id') 
			lsTrackIdSave =  idsDoPack.GetITemString(llRowPos,'shipper_tracking_id')
			
		End If
	
next /*next output record */


lsText += "~n~n~nShipment Details:~n~n"

//Detail Header...
lsText +=  "~tSku~t~t~tQty~n"
lsText +=  "~t---------------------~n"


//Add detail info to Email
llRowCount = idsDoDetail.RowCount()
For llRowPos = 1 to llRowCOunt
		
	lsText += "~t"
	lsText +=  idsDoDetail.GetITemString(llRowPos,'Sku')
	lsText += "~t~t"
	lsText += String(idsDoDetail.GetITemNumber(llRowPos,'alloc_qty'),'#######0')
	lsText += "~n"
	
next /*next output record */

//Footer - Either Prod or Test URL
If gsEnvironment = "PROD" Then
	lsURL = "https://web.menlolog.com/wms/"
Else
	lsURL = "https://menlotest.menlolog.com/wms/"
End If

lsText += "~n~n~nFor more information, please visit: " + lsURL


//Write the email...
If lsEmail > '' Then
	gu_nvo_process_files.uf_send_email("PANDORA",lsEmail,"XPO Logistics Shipment Status Update - Cityblock Driver Order ",lsText,"")
Else
	lsLogOut = "        *** Email Address not present for  Order: " +  idsDoMain.GetITemString(1,'invoice_no') + ". ASN email will not be sent."
	FileWrite(gilogFileNo,lsLogOut)
End If

//Archive the file...
lsFileName = ProfileString(gsinifile,"PANDORA","archivedirectory","") + '\' + "ASN-"  + idsDoMain.GetITemString(1,'invoice_no') + ".txt"
If FIleExists(lsFileName) Then
	lsFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')
End IF

liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockREadWrite!,Append!)
If liFileNo > 0 Then
	FileWrite(liFileNo,lsText)
	FileClose(liFileNo)
End If


Return 0
end function

public function integer uf_process_kittyhawk_daily_rpt ();//Process the Kittyhawk daily In report inbound Report



String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsRONO,  lsfilename
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsOrders, ldsOut


lsLogOut = "      Creating Pandora Kittyhawk Inbound ORder File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsOrders = Create Datastore

sql_syntax = " SELECT Receive_MAster.Ro_no, Receive_Putaway.SKU,  Lot_No,  Container_ID, Serial_No, Complete_Date"  
sql_syntax += "  FROM Receive_Master,  Receive_Putaway, Item_Master " 
sql_syntax += "  WHERE ( Receive_Putaway.RO_No = Receive_Master.RO_No ) and (Receive_Master.ord_status in ('C')) and (file_transmit_ind is null or file_transmit_ind <> 'Y') and ( Receive_Putaway.Supp_Code = Item_Master.Supp_Code ) and ( Receive_Putaway.SKU = Item_Master.SKU ) and "
sql_syntax += "  ( (Receive_Master.Project_ID = 'PANDORA' ) AND  ( Item_Master.GRP = 'KHBOOKS' ) )" 


ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora Kittyhawk  (Daily Inbound Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsOrders.SetTransobject(sqlca)

lLRowCount = ldsOrders.Retrieve()


lsLogOut = "    - " + String(lLRowCount) + " Order records retrieved for processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsfilename= 'KH-DAILY-RPT_' + string(now(),'yyyymmddhhmm') + '.csv'

//Add a column Header Row*/
If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "Part #, Ship Code, Box#, ISBN, Receive Date"
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsfilename)
	ldsOut.SetItem(llNewRow,'dest_cd', 'KH') /* routed to different folder for processing */
End If

For llRowPos = 1 to lLRowCount /*Each Order*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = (ldsOrders.GetITemString(llRowPos,'SKU')) + ","

	If Not isnull(ldsOrders.GetITemString(llRowPos,'Lot_No')) Then /*Ship Code */
		lsOutString += ldsOrders.GetITemString(llRowPos,'Lot_No') + ','
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Container_ID')) Then
		lsOutString += ldsOrders.GetITemString(llRowPos,'Container_ID') + ','
	Else
		lsOutString += ","
	End If
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Serial_No')) Then
		If ldsOrders.GetITemString(llRowPos,'Serial_No') = '-' or ldsOrders.GetITemString(llRowPos,'Serial_No') = '' Then
			lsOutString +=  ','
		Else
			lsOutString += ldsOrders.GetITemString(llRowPos,'Serial_No') + ','
		End If
	Else
		lsOutString += ","
	End If

	lsOutString += String(ldsOrders.GetITemDateTime(llRowPos,'Complete_Date'),'yyyy-mm-dd')
	
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsfilename)
	ldsOut.SetItem(llNewRow,'dest_cd', 'KH') /* routed to different folder for processing */
		
Next /*Order Record*/

//Update the File Transmit Ind so we don;t send again
For llRowPos = 1 to lLRowCount /*Each Order*/
	
	lsRONO = ldsOrders.GetITEmString(llRowPos,'ro_no')
	
	Update Receive_MASter
	Set File_Transmit_ind = 'Y'
	Where Ro_no = :lsRONO;
	
	Commit;
	
Next

If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_process_kittyhawk_movement_rpt ();//Process the Kittyhawk Movement report



String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsRONO, lsFilename 
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsOrders, ldsOut


lsLogOut = "      Creating Pandora Kittyhawk History File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsOrders = Create Datastore

//Jxlim 01/13/2012 Replace Wh_code = 'PND_NWRK' with Wh_code in('PND_NWRK', 'PND_FREMNT') per Dave

sql_syntax = " SELECT CONVERT (char(10), b.complete_date, 101) as complete_date, A.sku,	I.Description, 'Out' as ord_type, A.lot_no, sum(A.quantity) as qty"
sql_syntax += "  FROM delivery_picking A	INNER JOIN delivery_master B ON (A.do_no = B.do_no),	Item_Master I With (NOLOCK)"
sql_syntax += "  WHERE B.Wh_code in ('PND_NWRK' , 'PND_FREMNT') AND B.project_id = 'PANDORA' AND B.ord_status in ('C') AND I.GRP = 'KHBOOKS' AND 	a.SKU = I.SKU AND a.Supp_Code = I.Supp_Code AND B.Project_id = I.Project_ID"
sql_syntax += "  GROUP BY CONVERT (char(10), b.complete_date, 101), A.sku, I.Description, A.lot_no"
sql_syntax += "  UNION ALL"

sql_syntax += "  SELECT CONVERT (char(10), b.complete_date, 101) as complete_date, A.sku, I.Description, 'In' as ord_type, A.lot_no, sum(A.quantity) as qty"
sql_syntax += "  FROM Receive_Putaway A INNER JOIN Receive_master B ON (A.Ro_no = B.Ro_no), Item_Master	I With (NOLOCK)"
sql_syntax += "  WHERE B.Wh_code in ('PND_NWRK' , 'PND_FREMNT') AND B.project_id = 'PANDORA' AND I.GRP = 'KHBOOKS'  AND B.ord_status in ('C') AND a.SKU = I.SKU AND a.Supp_Code = I.Supp_Code AND B.Project_id = I.Project_ID"
sql_syntax += "  GROUP BY CONVERT (char(10), b.complete_date, 101), A.sku, I.Description, A.lot_no"
sql_syntax += "  UNION ALL"

sql_syntax += "  SELECT A.last_update as complete_date, A.sku, I.Description, 'Adj' as ord_type, A.lot_no, CASE  WHEN A.quantity > A.Old_quantity  THEN A.quantity - A.Old_quantity WHEN A.quantity < A.Old_quantity  Then A.Old_quantity - A.quantity 	END as qty" 
sql_syntax += "  FROM adjustment A, Item_MASter	I With (NOLOCK)"
sql_syntax += "  WHERE A.Wh_code in ('PND_NWRK' , 'PND_FREMNT') and A.project_id 	= 'PANDORA' AND 	I.GRP = 'KH_BOOKS'  AND A.Project_ID = I.PRoject_ID AND A.SKU = I.SKU AND A.Old_quantity <> A.Quantity AND  A.Supp_Code = I.Supp_Code"

sql_syntax += "  ORDER BY A.sku, CONVERT (char(10), b.complete_date, 101), ord_type"

ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora Kittyhawk  (Movement History Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsOrders.SetTransobject(sqlca)

lLRowCount = ldsOrders.Retrieve()


lsLogOut = "    - " + String(lLRowCount) + " Order records retrieved for processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a column Header Row*/
lsfilename= 'KH-HISTORY-RPT_' + string(now(),'yyyymmddhhmm') + '.csv'

If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "Date, Ship Code, Mvt Type, Part#, Description, QTY"
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsfilename)
	ldsOut.SetItem(llNewRow,'dest_cd', 'ISBN') /* routed to different folder for processing */
End If

For llRowPos = 1 to lLRowCount /*Each Order*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = String(ldsOrders.GetITemDateTime(llRowPos,'Complete_Date'),'yyyy-mm-dd')+ ','

	If Not isnull(ldsOrders.GetITemString(llRowPos,'Lot_No')) Then /*Ship Code */
		lsOutString += ldsOrders.GetITemString(llRowPos,'Lot_No') + ','
	Else
		lsOutString += ","
	End If

	If Not isnull(ldsOrders.GetITemString(llRowPos,'ord_type')) Then
		lsOutString +=ldsOrders.GetITemString(llRowPos,'ord_type') + ','
	Else
		lsOutString += ","
	End If

	lsOutString += (ldsOrders.GetITemString(llRowPos,'SKU')) + ','
	
	If Not isnull(ldsOrders.GetITemString(llRowPos,'Description')) Then
		lsOutString += ldsOrders.GetITemString(llRowPos,'Description') + ','
	Else
		lsOutString += ","
	End If

	lsOutString += string(ldsOrders.GetITemNumber(llRowPos,'qty')) 

	
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', lsfilename)
	ldsOut.SetItem(llNewRow,'dest_cd', 'ISBN') /* routed to different folder for processing */
		
Next /*Order Record*/

If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_decom_inv_rpt ();//Process the Hourly Pandora DECOM Inventory Report



String			sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsRONO 
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsDecomInventory, ldsOut


lsLogOut = "      Creating Pandora Hourly DECOM Inventory Report File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsDecomInventory = Create Datastore

sql_syntax = " SELECT DISTINCT  cs.project_id, cs.WH_Code, ro.arrival_date, cs.sku, itm.description,"  
sql_syntax += "  Sum(cs.avail_qty) as avail_qty, owner.Owner_Cd, cs.l_code, inv.inv_type_desc, cs.lot_no, itm.user_field5 as commodity_cd," 
sql_syntax += "cs.po_no as project_code FROM	content_summary cs,  inventory_type inv, item_master itm, Owner,  receive_master ro WHERE cs.sku = itm.sku and"
sql_syntax += " cs.supp_code = itm.supp_code and cs.inventory_type = inv.inv_type and cs.project_id = inv.project_id and  " 
sql_syntax += " cs.project_id = itm.project_id and cs.Owner_id = owner.Owner_id and cs.project_id = ro.project_id and "
sql_syntax += "  cs.ro_no = ro.ro_no and cs.project_id = 'pandora' and  ( Owner.Owner_Cd LIKE ('%rk' ) or " 
sql_syntax += " Owner.Owner_Cd LIKE ('%tb') or Owner.Owner_Cd LIKE ('%sc') or Owner.Owner_Cd LIKE ('%df')  " 
sql_syntax += "  or Owner.Owner_Cd LIKE ('%rl') or Owner.Owner_Cd LIKE ('%cl') or Owner.Owner_Cd LIKE ('%d')) and" 
sql_syntax += " Owner.Owner_Cd NOT IN (SELECT Owner.Owner_Cd FROM OWNER" 
sql_syntax += " Where  Owner.Owner_Cd LIKE ('%utb' ) or Owner.Owner_Cd LIKE ('%misc') or Owner.Owner_Cd LIKE ('%xl'))" 
sql_syntax += "  GROUP BY cs.project_id, cs.WH_Code, cs.supp_code, cs.sku, cs.l_code, " 
sql_syntax += "  cs.lot_no,itm.description, itm.user_field5, inv.inv_type_desc, ro.arrival_date, owner.Owner_Cd,cs.po_no" 

ldsDecomInventory.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora Hourly DECOM Inventory Report File.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsDecomInventory.SetTransobject(sqlca)

lLRowCount = ldsDecomInventory.Retrieve()


lsLogOut = "    - " + String(lLRowCount) + " Pandora DECOM Inventory records retrieved for processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a column Header Row*/
If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "Project|Warehouse|Arrival Date|SKU|DESCRIPTION|AVAIL|OWNER|LOCATION|INV TYPE|LOT NO|COMMODITY CODE|PROJECT CODE"
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', 'DECOM_INVSNAPSHOT_'+string(today(),'MMDDYYhhmmss'+'.txt'))
	ldsOut.SetItem(llNewRow,'dest_cd', 'DECOM') /* routed to different folder for processing */
End If

For llRowPos = 1 to lLRowCount /*Each DECOM Inventory Item*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = (ldsDecomInventory.GetITemString(llRowPos,'project_id')) + "|"

	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'WH_Code')) Then 
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'WH_Code') + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemDateTime(llRowPos,'arrival_date')) Then
		lsOutString += String(ldsDecomInventory.GetITemDateTime(llRowPos,'arrival_date') )+ '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'sku')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'sku') + '|'
	Else
		lsOutString += "|"
	End If

	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'description')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'description') + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemNumber(llRowPos,'avail_qty')) Then
		lsOutString += String( ldsDecomInventory.GetITemNumber(llRowPos,'avail_qty')) + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'Owner_Cd')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'Owner_Cd') + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'l_code')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'l_code') + '|'
	Else
		lsOutString += "|"
	End If
	
		If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'inv_type_desc')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'inv_type_desc') + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'lot_no')) Then
		lsOutString += ldsDecomInventory.GetITemString(llRowPos,'lot_no') + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'commodity_cd')) Then
		lsOutString +=ldsDecomInventory.GetITemString(llRowPos,'commodity_cd') + '|'
	Else
		lsOutString += "|"
	End If

	If Not isnull(ldsDecomInventory.GetITemString(llRowPos,'project_code')) Then
		lsOutString +=ldsDecomInventory.GetITemString(llRowPos,'project_code') 
	Else
		lsOutString += " "
	End If

	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	ldsOut.SetItem(llNewRow,'file_name', 'DECOM_INVSNAPSHOT_'+string(today(),'MMDDYYhhmmss'))
	ldsOut.SetItem(llNewRow,'dest_cd', 'DECOM') /* routed to different folder for processing */

Next /*DECOM Inventory Item*/

If ldsOut.RowCount() > 0 Then
   gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_cc_confirm (string as_project, string as_ccno);//Jxlim 03/24/2011 This function create OCR and OCC file
//OCR file 4C1 SOC ACK (Disk Erase order), no serial no in the file, thus no changed for Ian list #165
//OCC file 4C1 Cyc ACK (Cycle Count) confirmation, no serial_no in the file, thus no changed from Ian list #165
//Prepare a Cycle Count confirmation for PANDORA for given order (confirmed since last sweeper cycle)
/*  - Pandora 
                                                
*/

Long                      llRowPos, llRowCount, llFindRow,             llNewRow, llDetailFindRow, llcc_detailcount

String    lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN
string     lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_ordType,ls_diff,ls_line_no

Decimal                ldBatchSeq, ldOwnerID //, ldOwnerID_Prev
Integer liRC
DateTime ldtTemp

//?decimal          ldTransID

string                     lsPopLoc, lsInvoice, lsRONO, lsPndser
///////
datastore            ldsCCMaster, ldsCCDetail, ldsCC_Out, ldsOutSOC
double                  ldQty, ldQtyCount, ldAllocQty, ldNewRecptQty
string                     lsOrder, lsFileName, lsABCClass, lsSKU, lsDesc, lsOwner, lsOrg, lsReasonCD, lsReasonDesc, lsFileNameSOC, lsOutStringSOC, lsSequence, lsProject, lsOrdStatus
datetime                             ldtCountDate
long                                       llNewRowSOC

If Not isvalid(idsOut) Then
                idsOut = Create Datastore
                idsOut.Dataobject = 'd_edi_generic_out'
                lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsOutSOC) Then
                //used to write output if there needs to be stock adjustments created (SIMS qty > Count qty)
                ldsOutSOC = Create Datastore
                ldsOutSOC.Dataobject = 'd_edi_generic_out'
                lirc = ldsOutSOC.SetTransobject(sqlca)
End If

If Not isvalid(ldsCC_Out) Then
                //datastore to capture rolled-up cc_inventory records to be written to ldsOUT
                ldsCC_Out = Create Datastore
                ldsCC_Out.Dataobject = 'd_cc_inventory'
End If

If Not isvalid(ldsCCMaster) Then
                ldsCCMaster = Create Datastore
                ldsCCMaster.Dataobject = 'd_cc_master'
                ldsCCMaster.SetTransObject(SQLCA)
End If

If Not isvalid(ldsCCDetail) Then
                ldsCCDetail = Create Datastore
                ldsCCDetail.Dataobject = 'd_cc_inventory'
                ldsCCDetail.SetTransObject(SQLCA)
End If

idsOut.Reset()
//ldsCC_Out.Reset()

lsLogOut = "      Creating Cycle Count confirmation (CC) For CCNO: " + as_CCNO
FileWrite(gilogFileNo,lsLogOut)
                
//Retrieve the CC Master and CC Inventory records for this order
If ldsCCMaster.Retrieve(as_CCNo) <> 1 Then
                lsLogOut = "                  *** Unable to retrieve Cycle Count Order Header For CC_NO: " + as_CCNO
                FileWrite(gilogFileNo,lsLogOut)
                Return -1
End If

//For Pandora, instead of WH Code, we need the Sub-Inventory Location (Owner_CD)
//  (still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = ldsCCMaster.GetItemString(1, 'wh_code')
lsOrdStatus = upper(ldsCCMaster.GetItemString(1, 'ord_status'))

//we only send confirmations for pandora-directed cycle counts (ord_type 'P')
//if ldsCCMaster.GetItemString(1, 'Create_User')  = 'SIMSFP' then
ls_ordtype = ldsCCMaster.GetItemString(1, 'ord_type')
if ldsCCMaster.GetItemString(1, 'ord_type')  = 'P' then
                lsElectronicYN = 'Y'
else
                lsElectronicYN = 'N'
                return -1
end if

ldsCCDetail.Retrieve(as_CCNO)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(as_project, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
                lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Cycle Count Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
                FileWrite(gilogFileNo,lsLogOut)
                Return -1
End If
lsFileName = 'OCC' + String(ldBatchSeq, '000000') + '.DAT'

// 03-09 - Get the next available Trans_ID sequence number 
//TODO - Necessary?
//ldTransID = gu_nvo_process_files.uf_get_next_seq_no(as_Project, 'Transactions', 'Trans_ID')
//If ldTransID <= 0 Then Return -1


// LTK 20150805  CC Rollup Changes - Spread out any rolled up quantities before the OCR check is conducted below
n_cc_utils ln_cc_utils
ln_cc_utils = CREATE n_cc_utils

ln_cc_utils.uf_spread_rolled_up_si_counts( ldsCCDetail )


llRowCount = ldsCCDetail.RowCount()
For llRowPos = 1 to llRowCount  //each row in d_cc_inventory (which includes fields from inventory and result 1, 2 and 3 tables)
                // Rolling up to Sku/Owner/Project...
                lsFind = "upper(sku) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')) + "'"
//            lsFind += " and line_item_no = " + string(ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no'))
                lsOwner = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd') //lsOwner is used later to write 'ORG' to Header record (Datawindow d_cc_inventory has owner_owner_cd)
                lsFind += " and owner_owner_cd = '" + lsOwner + "'" //Datawindow has owner_owner_cd
                lsFind += " and upper(po_no) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'po_no')) + "'"
                
                llFindRow = ldsCC_Out.Find(lsFind, 1, ldsCC_Out.RowCount())

                If llFindRow > 0 Then /*row already exists, add the qty*/
                                //grab the latest count result (3, then 2, then 1)
                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
                                if isNull(ldQtyCount) or ldQtyCount = 0 then
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
                                end if
                                if isNull(ldQtyCount) or ldQtyCount = 0 then
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
                                end if
                                if isNull(ldQtyCount) then
                                                ldQtyCount = 0
                                end if
                                //setting the counted quantity in result_1 and will compare that to quantity (what SIMS thinks) to possibly trigger SOC
                                //ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQty)
                                ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQtyCount)
                                //update SIMS Qty
                                ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
                                if isNull(ldQty) then
                                                ldQty = 0
                                end if
                                ldsCC_Out.SetItem(llFindRow,'quantity', ldsCC_Out.GetItemNumber(llFindRow, 'quantity') + ldQty)
                                // dts - 08/10/10 - save a reason code if one is not already saved....
                                lsReasonCd = ldsCC_Out.GetItemString(llFindRow, 'reason')
                                if NoNull(lsReasonCd) = '' then
                                                lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
                                                if NoNull(lsReasonCd) <> '' then
                                                                ldsCC_Out.SetItem(llFindRow, 'reason', lsReasonCd)
                                                end if
                                end if                    
                Else /*not found, add a new record*/
                                llNewRow = ldsCC_Out.InsertRow(0)
                                ldsCC_Out.SetItem(llNewRow, 'sku', ldsCCDetail.GetItemString(llRowPos, 'sku'))
                                ldsCC_Out.SetItem(llNewRow, 'po_no', ldsCCDetail.GetItemString(llRowPos, 'po_no'))
                                ldsCC_Out.SetItem(llNewRow, 'owner_owner_cd', ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd'))
                                // owner_id is not used in output file, but is used in alloc qty lookup
                                ldsCC_Out.SetItem(llNewRow, 'owner_id', ldsCCDetail.GetItemNumber(llRowPos, 'owner_id'))
                                ldsCC_Out.SetItem(llNewRow, 'sequence', ldsCCDetail.GetItemString(llRowPos, 'sequence'))
//                                                            ldsCC_Out.SetItem(llNewRow, 'trans_line_no', ldsCCDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
                                                
                                //Quantity - grab the latest count result (3, then 2, then 1)
                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
                                if ldQtyCount > 0 then
                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count3_complete')
                                else
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
                                                if ldQtyCount > 0 then
                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count2_complete')
                                                else
                                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
                                                                if ldQtyCount > 0 then
                                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count1_complete')
                                                                else
                                                                                //ldtCountDate = datetime('2999-12-31') //TODO???
                                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'complete_date')
                                                                end if
                                                end if //Result_2 > 0
                                end if //Result_3 > 0
                                if isNull(ldQtyCount) then
                                                ldQtyCount = 0
                                end if
                                //ldsCC_Out.SetItem(llFindRow,'quantity', (ldsCC_Out.GetItemNumber(llFindRow,'quantity') + ldsCCDetail.GetItemNumber(llRowPos, 'quantity')))
                                ldsCC_Out.SetItem(llNewRow, 'result_1', ldQtyCount) // using result_1 to hold result1, 2, or 3 as appropriate
                                ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
                                if isNull(ldQty) then
                                                ldQty = 0
                                end if
                                ldsCC_Out.SetItem(llNewRow,'quantity', ldQty)
                                ldsCC_Out.SetItem(llNewRow, 'expiration_date', ldtCountDate) // just using expiration_date to hold the Count Date
                                // 6/24 ???
                                lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
                                ldsCC_Out.SetItem(llNewRow,'reason', lsReasonCd)

//TODO - We don't have comments at the line (as the DMA describes...
//                            // Remove any carriage returns/Line feeds from Remarks - they cause the files to fail in ICC
//                            lsRemarks = trim(ldsCCMaster.GetItemString(1, 'remark'))
//                            Do While pos(lsRemarks,"~t") > 0 /*tab*/
//                                            lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~t"),1," ")
//                            Loop
//                            Do While pos(lsRemarks,"~n") > 0 /*New line*/
//                                            lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~n"),1," ")
//                            Loop
//                            Do While pos(lsRemarks,"~r") > 0 /*CR*/
//                                            lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~r"),1," ")
//                            Loop                      
//                            ldsCC_Out.SetItem(llNewRow, 'reference', lsRemarks)  //remarks? UF?
                                                
                End If // New Record

                if ldQTY > ldQtyCount and lsOrdStatus <> 'V' then
                                //create SOC
                                // Create a separate file for each line that needs an Owner Change (actually project change)
                                //Jxlim 06/06/2011 added cc_no and line item #BRD 233                
                                ls_line_no= string(ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no'))

                                //lsFileNameSOC = 'OCR' + String(ldBatchSeq, '000000') + '_' + string(llRowPos ) + '.DAT'
                                lsFileNameSOC = 'OCR' + String(ldBatchSeq, '000000') + '_' + ls_line_no + '.DAT'
                                ldsOutSOC.reset()

                                /*write header.  For now, there will be a single header/detail for each sequence that needs adjustment...
                                    - may want to create a single file per owner.*/
                                //lsOutStringSOC = "OC||" +lsOwnerCD + "|" + lsOwnerCD + "|" + lsSequence +"|"
                                //dts 3/1 - adding delimiters to accomodate new fields on the format (requestor, requestor e-mail, remarks)
						  lsSequence = ldsCCDetail.GetItemString(llRowPos, 'sequence')				  
                                lsOutStringSOC = "OC||" +lsOwner + "|" + lsOwner + "|" + lsSequence + "_" + ls_line_no +"||||"  //TimA 08/23/11  Pandora #285
//                                lsOutStringSOC = "OC||" +lsOwner + "|" + lsOwner + "|" + lsSequence +"||||"
                                llNewRowSOC = ldsOutSOC.insertRow(0)
                                ldsOutSOC.SetItem(llNewRowSOC, 'Project_id', as_Project)
                                ldsOutSOC.SetItem(llNewRowSOC, 'edi_batch_seq_no', Long(ldBatchSeq))
                                ldsOutSOC.SetItem(llNewRowSOC, 'line_seq_no', llNewRowSOC)
                                ldsOutSOC.SetItem(llNewRowSOC, 'batch_data', lsOutStringSOC)
                                ldsOutSOC.SetItem(llNewRowSOC, 'file_name', lsFileNameSOC) 
                                //write detail...
                                //  "OD|SKU|||Project|RESEARCH|UserLineNbr|Qty"
                                // dts 01-10-11 - adding new fields to accommodate the addition of Requestor and remarks (actually 3 new '|'s in total)
                                //lsOutStringSOC = "OD|" + lsSKU +"|||" +lsProject +"|RESEARCH|1|" + string(ldQty - ldQtyCount)         

                                                
                                //Jxlim 06/06/2011 added cc_no and line item #BRD 233 to the file structure for order type is Pandora Directed 'P'
						 lsSKU = upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')	)
						 lsProject = upper(ldsCCDetail.GetItemString(llRowPos, 'po_no'))
                                //lsOutStringSOC = "OD|" + lsSKU +"|||" +lsProject +"|RESEARCH|1|" + string(ldQty - ldQtyCount) + "|||"
                                lsOutStringSOC = "OD|" + lsSKU +"|||" +lsProject +"|RESEARCH|1|" + string(ldQty - ldQtyCount) + "|||" + as_ccno + '|' + ls_line_no + '|'
                                                
                                                llNewRowSOC = ldsOutSOC.insertRow(0)
                                                ldsOutSOC.SetItem(llNewRowSOC, 'Project_id', as_Project)
                                                ldsOutSOC.SetItem(llNewRowSOC, 'edi_batch_seq_no', Long(ldBatchSeq))
                                                ldsOutSOC.SetItem(llNewRowSOC, 'line_seq_no', llNewRowSOC)
                                                ldsOutSOC.SetItem(llNewRowSOC, 'batch_data', lsOutStringSOC)
                                                ldsOutSOC.SetItem(llNewRowSOC, 'file_name', lsFileNameSOC) 
                                                
                                                //need to Write the inbound SOC File to the inbound Pandora directory...
                                                //gu_nvo_process_files.uf_process_flatfile_outbound(ldsOutSOC, as_Project)
                                                uf_write_soc_inbound(ldsOutSOC)
                end if
                                

Next /* Next Detail record */

/* Write the Header record first, then for each distinct line/sku/owner/po_no (project), write an output record - 
     - multiple detail lines may be combined in a single output record (multiple locs for a sku) */
//header record....
llNewRow = idsOut.insertRow(0)
//lsOrder = ldsCCMaster.GetItemString(1, 'Order_No')
lsOrder = ldsCCMaster.GetItemString(1, 'User_Field1')  //TODO - Need to add field for capturing order number, or dedicate a user field for it?  Using UF1 for now
lsABCClass = ldsCCMaster.GetItemString(1, 'class')  //TODO - this is actually field class_start. how is class_start/class_end used?
select user_field3 into :lsOrg from customer where project_id = :as_project and cust_code = :lsOwner; //lsOwner is from the detail - assuming all Customers in file have same Org (since all from same WH).
ldtTemp = ldsCCMaster.GetItemDateTime(1, 'complete_date')
ldtTemp = GetPacificTime(lsWH, ldtTemp)
//lsOutString = 'CC|' + lsOrder + '|' + NoNull(lsOrg) + '|' + string(ldsCCMaster.GetItemDateTime(1, 'complete_date'), 'yyyymmddhhmmss')
lsOutString = 'CC|' + lsOrder + '|' + NoNull(lsOrg) + '|' + string(ldtTemp, 'yyyy-mm-ddThh:mm:ss')
if Upper(Trim(f_functionality_manager(as_Project,'FLAG','SWEEPER','UNIQUETRXID','',''))) = 'Y' then		// LTK 20150515  Added Unique ID to header record
	lsOutString += "|" + "S" + in_string_util.of_parse_numeric_sys_no( String(ldsCCMaster.Object.cc_no[ 1 ]) ) + "CC"
end if

idsOut.SetItem(llNewRow, 'Project_id', as_Project)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', lsFileName) 

//Scroll thru the holding datastore and write the records to the generic output table, fields delimited by '|'
llRowCount = ldsCC_Out.RowCount()
For llRowPos = 1 to llRowCount
                llNewRow = idsOut.insertRow(0)
                lsOutString = 'AVI|'  //Record type
                lsSequence = NoNull(ldsCC_Out.GetItemString(llRowPos, 'sequence'))
                lsOutString += lsSequence + '|' //Sequence - From Pandora
                lsOwnerCD = NoNull(ldsCC_Out.GetItemString(llRowPos, 'owner_owner_cd'))
                ldOwnerID = ldsCC_Out.GetItemNumber(llRowPos, 'owner_id')
                lsOutString += lsOwnerCD + '|' // 'Supplier Location' (menlo owner code) - Datawindow has owner_owner_cd
                lsSKU = ldsCC_Out.GetItemString(llRowPos, 'SKU')
                lsOutString += lsSKU + '|' // GPN
                lsDesc = ''
                select description into :lsDesc from item_master where project_id = :as_project and sku = :lsSKU;
                lsOutString += NoNull(lsDesc) + '|' // GPN Description
                lsOutString += 'EA|' // UOM - Always EA?
                lsOutString += NoNull(lsABCClass) + '|' // ABC Class
                ldQty = ldsCC_Out.GetItemNumber(llRowPos, 'quantity') 
                ldQtyCount = ldsCC_Out.GetItemNumber(llRowPos, 'result_1') // in this case, result_1 is result1, 2, or 3 as appropriate (and summed by owner/sku/project)
                // Status - status at the line. 'Uncounted' on inbound, 'Final Count' on confirmation (if counted)
                // - TODO - need to determine if the line has been counted (0 qty may actually be the qty)
                if lsOrdStatus = 'V' then //if the order is VOID-ed, send back confirmation with 0 and Uncounted
                                lsOutString += 'Uncounted|' 
                // 8/3/2010 - Only Voided orders are uncounted.  SOP says ops will count every line on a cycle count
                //elseif ldQty = 0 then // for now, means it was a SKU/Owner/po_no for which we did not have inventory and thus did not count
                //            lsOutString += 'Uncounted|' 
                else
                                // 7/1 - count = 0 is now still considered final count...
                                //if isNull(ldQtyCount) or ldQtyCount = 0 then
                                //            lsOutString += 'Uncounted|' 
                                //else
                                                lsOutString += 'Final Count|' 
                                //end if
                end if
                
                ldtCountDate = ldsCC_Out.GetItemDateTime(llRowPos, 'expiration_date')  //just using expiration_date to hold the count date
                if ldtCountDate = datetime('2999-12-31') then
                                lsOutString += '|'
                else
                                ldtCountDate = GetPacificTime(lsWH, ldtCountDate) // 2010-07-19 - added call to GetPacificTime
                                //lsOutString += String(ldtCountDate, 'yyyymmddhhmmss') + '|' //Count Date Count1_Complete, 2_complete, 3_complete from cc_master
                                lsOutString += String(ldtCountDate, 'yyyy-mm-ddThh:mm:ss') + '|' //Count Date Count1_Complete, 2_complete, 3_complete from cc_master
                end if
                if lsOrdStatus = 'V' then //if the order is VOID-ed, send back confirmation with 0 and Uncounted
                                lsOutString +=  '0|' // Count Qty + Allocated Qty
                                //lsOutString +=  lsReasonCd + '|'  
                                //lsOutString +=  'VOID' + '|'  
                                // 6/30 - hard coding '901' for Reason Code for Void-ed orders.
                                lsOutString +=  '901' + '|'  
                else
                                // Add allocated qty here...
                                /* 2010-08-08 : Not adding allocated qty any more as it is now included in the cycle count.
                                                                                                                But, we are now adding any receipts since the cycle count was created. 
                                                                                                                Per Ian, Ops is not supposed to count anything that was newly-received.
                                lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                                select sum(Quantity) into :ldAllocQty 
                                from delivery_master dm inner join delivery_picking dp on dm.do_no = dp.do_no
                                where project_id = 'PANDORA' and ord_status in ('P', 'A')
                                and sku = :lsSKU and owner_id = :ldOwnerID and po_no = :lsProject;
                                if isNull(ldAllocQty) then ldAllocQty = 0 */
                                // receipts since cycle count was created....
                                lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                                ldtTemp = ldsCCMaster.GetItemDateTime(1, 'ord_date')
                                //ldtTemp = GetPacificTime(lsWH, ldtTemp)
                                select sum(Quantity) into :ldNewRecptQty
                                from receive_master rm inner join receive_putaway rp on rm.ro_no = rp.ro_no
                                where project_id = 'PANDORA' and complete_date > :ldtTemp //TODO! What about time zone?
                                and sku = :lsSKU and owner_id = :ldOwnerID and po_no = :lsProject;
                                if isNull(ldNewRecptQty) then ldNewRecptQty = 0 
                                //lsOutString += NoNull(string(ldQtyCount + ldAllocQty)) + '|' // Count Qty + Allocated Qty                          
                                lsOutString += NoNull(string(ldQtyCount + ldNewRecptQty)) + '|' // Count Qty + new receipt Qty
                                //only print 'reason' if the count qty < SIMS qty
                                /* 6/24 what about Allocated? 
                                                - Current thought is Allocated inventory is already picked (so Count should = SIMS, without allocated)
                                                *8/08 - Allocated is now part of Cycle Count                                        */
                                //?if ldQtyCount + ldAllocQty < ldQty then           
                                // dts - 07/17/2010 - changed to '<>' instead of '<'
                                if ldQtyCount <> ldQty then
                                                lsReasonCd = NoNull(ldsCC_Out.GetItemString(llRowPos, 'Reason'))
                                                //6/23 - sending code now... 
                                                //if lsReasonCD > '' then
                                                //            select code_descript into :lsReasonDesc from lookup_table where project_id = :as_project and code_type = 'IA' and code_id = :lsReasonCD;
                                                //else
                                                //            lsReasonDesc = ''
                                                //end if
                                                lsOutString +=  lsReasonCd + '|'  
                                else
                                                //lsReasonDesc = ''
                                                lsOutString +=  '|'  
                                end if
                                //lsOutString +=  lsReasonDesc + '|'  
                end if //is Order 'Void'?
                lsOutString += NoNull(ldsCCMaster.GetItemString(1, 'last_user')) + '|'  //TODO - user at the line/count level? Per Ian, Using Last_User for now...
                lsOutString += NoNull(ldsCCMaster.GetItemString(1, 'remark'))  + '|' // Comments - TODO! - Comments at the line? Per Ian, Using Header Remark for now...
                lsOutString += as_ccno + '-' + string(llRowPos) + '|' // Partner Order Reference- Per Ian, Using CC_NO + '-' + record number 
                //moved above... lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                lsOutString += lsProject  //+ '|'  //project code

//            ldtTemp = ldsCC_Out.GetItemDateTime(llRowPos, 'complete_date')
//            ldtTemp = GetPacificTime(lsWH, ldtTemp)
//            lsOutString += String(ldtTemp, 'yyyy-mm-dd hh:mm:ss') + '|'
                
                idsOut.SetItem(llNewRow, 'Project_id', as_Project)
                idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
                idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
                idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
                idsOut.SetItem(llNewRow, 'file_name', lsFileName) 
                //compare counted qty to SIMS qty.  If SIMS qty > Counted qty, create SOC to move excess to 'RESEARCH'
                /* 6/24 - Does the comparison need to include Allocated as well???
                                 - Current thought is Allocated inventory is already picked (so Count should = SIMS, without allocated) */
                /* 7/20 - added Order Status condition... */
                
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, as_Project)
Return 0

end function

public function integer uf_write_soc_inbound (ref datastore adw_output);//write SOC Flat file for Inbound processing to SIMS - if passed in a datawindow, we dont need to retrieve becuase the DW is still in memory and not saved to DB

String	lsLogOut, lsProject, 	lsDirList, lsPathOut, lsFileOut,lsErrorPath, lsDefaultPath,	&
			lsData, lsOrigFileName,	lsNewFileName,	lsFileSequence, lsFileSequenceHold, lsFilePrefix, &
			lsFileSuffix, lsFileExtension, lsDestPath, lsDestCD
			
Long		llArrayPos, llDirPos	, llRowCount, llRowPos
			
Integer	liFileNo, liRC

Boolean	bRet

//lsLogOut = ''
//FileWrite(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = '- PROCESSING FUNCTION: Extract Outbound Flat Files'
//FileWrite(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//lsLogOut = ''
//FileWrite(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/
//
//lsLogOut = '   Project: ' + asProject 
//FileWrite(giLogFileNo,lsLogOut)
//uf_write_Log(lsLogOut) /*display msg to screen*/

lsProject = 'PANDORA' //asProject

lsPathOut = ProfileString(gsinifile, lsProject, "flatfiledirin","") +'\' //want pandora's INbound directory, not outbound
// can't write file if there's more than one path specified...
If Pos(lsPathOut, ',') > 0 Then
	lsPathOut = Left(lsPathOut, (pos(lsPathOut, ',') - 1))
	if right(lsPathOut, 1) <> '\' then
		lsPathOut += '\'
	end if
End If

llRowCount = adw_output.RowCount()
	
//uf_write_log('     ' + string(llRowCount) + ' Rows were retrieved for flatfile output...')
	
If llRowCount > 0 Then
	//adw_Output.Sort() /* make sure we're sorted by batch seq so we only open an output file once */
	//lsFileSequenceHold = ''
	
	//For each row, stream the data to the output file
	For llRowPos = 1 to llRowCount
		//If BatchSeq has changed, close current file and create a new one
		lsFileSequence = String(adw_output.GetItemNumber(llRowPos,'edi_batch_Seq_no')) /*sequence Number */
		If lsFileSequence <> lsFileSequenceHold Then
				//Close the existing file (if it's the first time, fileno will be 0)
				If liFileNo > 0 Then
					FileClose(liFileNo) /*close the file*/
					////Archive the file
					//lsOrigFileName = lsPathOut + lsFileOut
					////MA 12/08 - Added .txt to file
					//lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + '.txt'
					
					//If FIleExists(lsNewFileName) Then
					//	lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
					//End IF
		
					//bret=CopyFile(lsOrigFileName,lsNewFileName,True)
					
					lsLogOut = "     Flat File data successfully extracted to: " + lsPathOut + lsFileOut
					FileWrite(gilogFileNo,lsLogOut)
//					uf_write_Log(lsLogOut) /*display msg to screen*/
				End If /*not first time*/
				
				// 10/03 - Pconkl - we may have different output paths depending on the dest_Cd field in the output file
				lsDestPAth = ''
				If adw_output.GetItemString(llRowPos,'Dest_cd') > '' Then
					lsDestCd = "flatfileout-" + 	adw_output.GetItemString(llRowPos,'Dest_cd')
					lsDestPath = ProfileString(gsinifile,lsProject,lsDestCd,"")
				Else
					lsDestPath = ''
				End IF
	
				If lsDestPath > '' Then
					lsPathout = lsDestPath + '\'
				Else
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirin","") +'\'
				End If
				If Pos(lsPathOut, ',') > 0 Then
					lsPathOut = Left(lsPathOut, (pos(lsPathOut, ',') - 1))
					if right(lsPathOut, 1) <> '\' then
						lsPathOut += '\'
					end if
				End If
				
				//We may have the file name specified in the datastore
				If adw_output.GetItemString(llRowPos,'file_name') > '' Then
					lsFileOut = adw_output.GetItemString(llRowPos,'file_name')
				End If
	
				lsErrorPath = ""
				liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
				If liFileNO < 0 Then
					//10/08 - PCONKL - If we can't open the specified file, try to write out to a default directory - This probably only should happen if we are trying to write directly to a remote drive that might not be available.
					lsErrorPath =  lsPathOut + lsFileOut /*where we were trying to write to*/
					
					lsPathOut = ProfileString(gsinifile,lsProject,"flatfiledirout-hold","") +'\' /*Where we store it locally until we can try again*/
					
					//Try to Open the backup file (local)
					liFileNo = FileOpen(lsPathOut + lsFileOut,LineMode!,Write!,LockREadWrite!,Append!)
					If liFileNO < 0 or lsPAthOut = "\" Then
						lsLogOut = "     ***Unable to open file: " + lsPathOut + lsFileOut + " For output to Flat File."
						If lsErrorPath > "" Then
							lsLogOut += "  *** Attempted to open originally as: " + lsErrorPath + " ***"
						End If
						
						FileWrite(gilogFileNo,lsLogOut)		
//						uf_write_Log(lsLogOut) /*display msg to screen*/
//						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.",lsLogOut ,'') /*send an email msg to the file transfer error list*/
						Return -1
					Else /*backup is open, send email to file transfer to alert that it needs to be redropped*/
//						uf_send_email('','Filexfer'," - ***** Unable to open remote file folder for file transfer. Action required to transfer file manually - see body of email for details.","Unable to open file: " + lsErrorPath + " for remote copy. File stored locally as: " + lsPathOut + lsFileOut + " and needs to be copied manually." ,'') /*send an email msg to the file transfer error list*/
					End IF
				End If
	
				lsLogOut = '     File: ' + lsPathOut + lsFileOut + ' opened for Flat File extraction...'
				FileWrite(gilogFileNo,lsLogOut)	
//				uf_write_log(lsLogOut)
		End If /*File Changed*/
		
		lsData = adw_output.GetItemString(llRowPos,'batch_data')
		
		// 02/03 - PCONKL - 255 char limitation in DW, we may have data in second batch field to append to stream
		If (Not isnull(adw_output.GetItemString(llRowPos,'batch_data_2'))) and adw_output.GetItemString(llRowPos,'batch_data_2') > '' Then
			lsData += adw_output.GetItemString(llRowPos,'batch_data_2')
		End If
			
		liRC = FileWrite(liFileNo,lsData)
		
		If liRC < 0 Then
			lsLogOut = "     ***Unable to write to file: " + lsPathOut + lsFileOut + " For output to Flat File."
			FileWrite(gilogFileNo,lsLogOut)	
//			uf_write_Log(lsLogOut) /*display msg to screen*/
		End If
		
		lsFileSequenceHold = lsFileSequence
		
	Next /*data row*/
			
	If liFileNo > 0 Then
		FileClose(liFileNo) /*close the last/only file*/
	End If

	lsLogOut = "     Flat File data successfully extracted to: " + lsPathOut + lsFileOut
	FileWrite(gilogFileNo,lsLogOut)
//	uf_write_Log(lsLogOut) /*display msg to screen*/
		
	//Archive the last/only file
	lsOrigFileName = lsPathOut + lsFileOut
	//MA 12/08 - Added .txt to file
		lsNewFileName = ProfileString(gsinifile,lsProject,"archivedirectory","") + '\' + lsFileOut + ".txt"
	
	// 03/04 - PCONKL - Check for existence of the file in the archive directory already - rename if duplicated
	//								We are now sending constant file names to some users instead of unique names (peice of shit AS400)
	
	//04/10 - MEA - Since we are batching the records, we only want to send the final file to Archive. 
	// 					 Delete any itermediate files.
	
//	IF asproject <> 'WARNER' THEN
		If FileExists(lsNewFileName) Then
			lsNewFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')  + '.txt'
		End IF
//	ELSE
//		If FileExists(lsNewFileName) Then
//			FileDelete ( lsNewFileName )
//		END IF
//	END IF
		
//TEMP!	bret=CopyFile(lsOrigFileName,lsNewFileName,True)
		
Else /*no records to process for directory*/
		
		lsLogOut = "     There was no data to write for project: " + lsProject
		FileWrite(gilogFileNo,lsLogOut)
//		uf_write_Log(lsLogOut) /*display msg to screen*/
		
End If /*records exist to output*/
		
Return 0
end function

public function integer uf_serial_change_rose (string asproject);//Jxlim 03/24/2011 This function create GCR file prefix for 4C1 - SOC -Serial Change (SC) confrimation
//If the 4C1 is a Serial Change 4C1 then, If the Item Master flag <> $$HEX1$$1c20$$ENDHEX$$Y$$HEX2$$1d202000$$ENDHEX$$then do not send a DAT file to ORacle.
/*Prepare a Owner Change Confirmation Transaction for PANDORA for the Serial Number Changes */


//Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow
//				
//String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType
//String		lsWHName, lsWHAddr1, lsWHAddr2, lsWHAddr3, lsWHAddr4, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lstempdate
//Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev
//Integer		liRC
//datetime ldtTemp, ldtToday
//decimal	ldTransID



// uf_process_dboh
//Process the SIKA Daily Balance on Hand Confirmation File
//(modeled after Maquet, Oct '07)

Datastore	ldsOut, ldsOC
				
Long			llRowPos, llRowCount, llNewRow, llid_no
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	lsPndser, lsSku, lsPrevSku, &
				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath,  lsownercd, lsnewownercd

Decimal		ldBatchSeq, ldownerid, ldnewownerid
Integer		liRC
DateTime	ldtToday, ldtTemp


ldtToday = DateTime(Today(), Now())

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Create the Owner Change datastore
ldsOC = Create Datastore

//22-Aug-2017 :Madhu -PINT-947 - Stock adjustment for SN, added condition for OM_Enabled_Ind
sql_syntax = "SELECT Wh_Code, Complete_Date, Id_No, Owner_Id,   Po_No, Sku, From_Serial_No,  To_Serial_No"  
sql_syntax += " FROM Item_Serial_Change_History with(nolock) "
sql_syntax += " WHERE Transaction_Sent is NULL "
sql_syntax += "  AND wh_code IN ( SELECT wh_code FROM Warehouse with(nolock) WHERE OM_Enabled_Ind <> 'Y' OR OM_Enabled_Ind IS NULL);"

ldsOC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Serial Number Change Transaction.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsOC.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Serial Number Change Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/


//TAM - 2010/07/28 Create a new file for each SN change
////Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no('PANDORA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
//commit;
//
//If ldBatchSeq <= 0 Then
//	lsLogOut = "   ***Unable to retrieve next available sequence number for PANDORA Serial Number Change confirmation."
//	FileWrite(gilogFileNo,lsLogOut)
//	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//	 Return -1
//End If

//Retrieve the OC Data
lsLogout = 'Retrieving Serial Number Change.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsOC.Retrieve(lsProject)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '|'
lsLogOut = 'Processing Serial Number Change Confirmation.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount

//TAM - 2010/07/28 Create a new file for each SN change
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no('PANDORA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrieve next available sequence number for PANDORA Serial Number Change confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If
			
			ldOwnerID = ldsOC.GetItemNumber(llRowPos, 'owner_id')
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;					

		llNewRow = ldsOut.InsertRow(0)
		lsOutString = 'SC|' /*rec type = Serial Number Change*/
		lsOutString += "|"
		lsOutString += lsownercd + "|"
		lsOutString += lsOwnerCd + "|"
		lsOutString += string(ldsOC.GetItemNumber(llRowPos, 'Id_No')) + "|"
	
		llid_no =ldsOC.GetItemNumber(llRowPos, 'Id_No')
	
	//TAM 2009/07/18 Converted  complete date to Pacific Time
		//lsOutString += string(ldsOC.GetItemDateTime(1, 'complete_date'), 'yyyymmddhhmmss') 
		ldtTemp = ldsOC.GetItemDateTime(llRowPos, 'complete_date')
		ldtTemp = GetPacificTime(ldsOC.GetItemString(llRowPos, 'wh_code'), ldtTemp)
		lsOutString += String(ldtTemp, 'yyyymmddhhmmss')
		if Upper(Trim(f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','',''))) = 'Y' then		// LTK 20150515  Added Unique ID to header record
			lsOutString += "|" + "S" + in_string_util.of_parse_numeric_sys_no( String(ldsOC.Object.ID_no[ 1 ]) ) + "SN"
		end if
	
		ldsOut.SetItem(llNewRow, 'Project_id', asProject)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	// TAM 2010/07/28 - Create a new file for each SN change - Only 1 row per file
	//	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'line_seq_no', 1)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
		ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
	
	
	//Detail Row
		llNewRow = ldsOut.InsertRow(0)
		lsOutString = 'SD|' /*rec type = balance on Hand Confirmation*/
		lsOutString += ldsOC.GetItemString(llRowPos, 'sku') + "|"
		lsOutString += "|"
		lsOutString += "|"
		lsOutString += ldsOC.GetItemString(llRowPos, 'po_no') + "|"  /*Project Number */
		lsOutString += ldsOC.GetItemString(llRowPos, 'po_no')  + "|" /*New Project Number */
		lsOutString += "1|" /* LINE NUMBER */
		lsOutString += "1|" /* QTY */
		lsOutString += ldsOC.GetItemString(llRowPos, 'from_serial_no')  + "|" /*From Serial Number */
		lsOutString += ldsOC.GetItemString(llRowPos, 'to_serial_no')  /*To Serial Number */	
		ldsOut.SetItem(llNewRow, 'Project_id', asProject)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	// TAM 2010/07/28 - Create a new file for each SN change - Only 1 row per file
	//	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'line_seq_no', 2)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
		ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
			
	  UPDATE dbo.Item_Serial_Change_History  
		  SET Transaction_Sent = 'Y'  
		WHERE dbo.Item_Serial_Change_History.ID_No = :llid_no   ;

next /*next output record */

	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, "PANDORA")


Return 0
end function

public function integer uf_process_ups (string asproject, string asdono);//Jxlim 03/24/2011 This function create UP trans_type for UPS Load Tender confirmation file UP file prefix
/* UPS Load Tender */
/* When an order is saved in Packing status, with UPS carrier and warehouse country is "US */
/*we are sending a UPS Load Tender file confirmation
ALL outbound orders will send the CI file (not just the electronic-enabled orders) */
			

Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow, llPackrow
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType, lsFromLoc
Decimal	ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer		liRC, llPos
Datetime 	ldtTemp, ldtToday
decimal		ldTransID
decimal 	ldWgt
decimal  	 ldQty, ld_height, ld_width, ld_depth
long			llCtnCount
Datastore	ldsUPS, ldsWH
string 		lsSKU_Hold, lsDescription, lsCarrier, lsCarrierName, lsfilename
String 		lsCust_type, lscust_code, ls_ToCust, ls_userf2, ls_Prevuserf2, ls_PrevToCust
String		ls_FromAddr1, ls_FromAddr2, ls_FromAddr3, ls_FromAddr4
String		ls_WhAddr1, ls_WhAddr2, ls_WhAddr3, ls_WhAddr4, ls_Simswh
String		ls_ToAddr1,ls_ToAddr2, ls_ToAddr3, ls_ToAddr4
Long 		llFromcount, llToCount

ldtToday = DateTime(Today(), Now())

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//This datastore contains Pandora record with UPS carrier, US warehouse, for new UP trans type 
If Not isvalid(ldsUPS) Then
	ldsUPS= Create Datastore
	ldsUPS.Dataobject = 'd_ups_interface_out'
	ldsUPS.SetTransObject(SQLCA)
End If

//This datastore use to get infromation from warehouse table if customer user_field2 is PND_XXXX and warehouse type is "WH'
If Not isvalid(ldsWH) Then
	ldsWH= Create Datastore
	ldsWH.Dataobject = 'd_maintenance_warehouse'
	ldsWH.SetTransObject(SQLCA)
End If

idsOut.Reset()
ldsUPS.Reset()
ldsWH.Reset()

lsLogOut = "      Creating UPS Load Tender (UP) For Project: " + asProject
FileWrite(gilogFileNo,lsLogOut)

//Retreive ldsUPS
ldsUPS.Retrieve()

// Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1	

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) UPS Load Tender Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - comma delimited by + ','
llRowCount = ldsUPS.RowCount()
If llRowCount <= 0 then return 0
For llRowPos = 1 to llRowCount

//Build and Write the Header
llNewRow = idsOut.insertRow(0)
lsOutString = ldsUPS.GetItemString(llRowPos, 'do_no') + ','									 // do_no
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'invoice_no')) + ','				//Order No (SIM Invoice_no)
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'cost_center')) + ','				//Cost Center (SIM user_field10)  //Jxlim 06/27/2011
	
//Ship From
//use warehouse information
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'wh_code')) + ','					//wh_code ie.PND_ATLNTA

//From address_1 from customer table customer_type = 'WH)
ls_Whaddr1 = ldsUPS.GetItemString(llRowPos, 'wh_address1') 						
ls_Whaddr1= f_string_replace(ls_whaddr1, ",", "  ")			
If ls_Whaddr1 > ' ' Then
	lsOutString += NoNull(ls_Whaddr1) +  ','			//Ship-From Address_1 (Customer)									
Else
	lsOutString +=  ','
End If	
	
//From address_2 from customer table customer_type = 'WH)
ls_Whaddr2 =  ldsUPS.GetItemString(llRowPos, 'wh_address2') 							
ls_Whaddr2= f_string_replace(ls_Whaddr2, ",", "  ")	
If ls_Whaddr2 > ' ' Then
	lsOutString += NoNull(ls_Whaddr2) + ','			//Ship-From Address_2 (Customer)			
Else
	lsOutString +=  ','
End If

//From address_3 from customer table customer_type = 'WH)
ls_Whaddr3 =ldsUPS.GetItemString(llRowPos, 'wh_address3') 						
ls_Whaddr3= f_string_replace(ls_whaddr3, ",", "  ")	
If ls_Whaddr3 > ' ' Then
	lsOutString += NoNull(ls_Whaddr3) + ','			//Ship-From Address_3 (Customer)			
Else
	lsOutString +=  ','
End If

//From address_4 from customer table customer_type = 'WH)
ls_whaddr4 = ldsUPS.GetItemString(llRowPos, 'wh_address4')						
ls_whaddr4= f_string_replace(	ls_Whaddr4, ",", "  ")	
If ls_Whaddr4 > ' ' Then
	lsOutString += NoNull(ls_Whaddr4) + ','			//Ship-From Address_4 (Customer)			
Else
	lsOutString +=  ','
End If

If	ldsUPS.GetItemString(llRowPos, 'wh_city') > ' ' Then
	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'wh_city')) + ','					//Ship-From city
Else 
	lsOutString += ','
End If

If 	ldsUPS.GetItemString(llRowPos, 'wh_state') > ' ' Then
	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'wh_state')) + ','				//Ship-From state
Else 
	lsOutString += ','
End If

If 	ldsUPS.GetItemString(llRowPos, 'wh_zip') > ' ' Then
	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'wh_zip')) + ','					//Ship-From zip
Else 
	lsOutString += ','
End If	

If ldsUPS.GetItemString(llRowPos, 'wh_Country') > ' ' Then
	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'wh_Country')) + ','			//Ship-From County
Else 
	lsOutString += ','
End If
//End of ship to for  "WH" customer type information.

////From address_1 from customer table customer_type = 'WH)
//ls_fromaddr1 = ldsUPS.GetItemString(llRowPos, 'from_address1') 						
//ls_fromaddr1= f_string_replace(	ls_fromaddr1, ",", "  ")			
//If ls_Fromaddr1 > ' ' Then
//	lsOutString += NoNull(ls_Fromaddr1) +  ','			//Ship-From Address_1 (Customer)									
//Else
//	lsOutString +=  ','
//End If	
//	
////From address_2 from customer table customer_type = 'WH)
//ls_fromaddr2 =  ldsUPS.GetItemString(llRowPos, 'from_address2') 							
//ls_fromaddr2= f_string_replace(	ls_fromaddr2, ",", "  ")	
//If ls_Fromaddr2 > ' ' Then
//	lsOutString += NoNull(ls_Fromaddr2) + ','			//Ship-From Address_2 (Customer)			
//Else
//	lsOutString +=  ','
//End If
//
////From address_3 from customer table customer_type = 'WH)
//ls_fromaddr3 =ldsUPS.GetItemString(llRowPos, 'from_address3') 						
//ls_fromaddr3= f_string_replace(	ls_fromaddr3, ",", "  ")	
//If ls_Fromaddr3 > ' ' Then
//	lsOutString += NoNull(ls_Fromaddr3) + ','			//Ship-From Address_3 (Customer)			
//Else
//	lsOutString +=  ','
//End If
//
////From address_4 from customer table customer_type = 'WH)
//ls_fromaddr4 = ldsUPS.GetItemString(llRowPos, 'from_address4')						
//ls_fromaddr4= f_string_replace(	ls_fromaddr4, ",", "  ")	
//If ls_Fromaddr4 > ' ' Then
//	lsOutString += NoNull(ls_Fromaddr4) + ','			//Ship-From Address_4 (Customer)			
//Else
//	lsOutString +=  ','
//End If
//
//If	ldsUPS.GetItemString(llRowPos, 'from_city') > ' ' Then
//	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'from_city')) + ','					//Ship-From city
//Else 
//	lsOutString += ','
//End If
//
//If 	ldsUPS.GetItemString(llRowPos, 'from_state') > ' ' Then
//	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'from_state')) + ','				//Ship-From state
//Else 
//	lsOutString += ','
//End If
//
//If 	ldsUPS.GetItemString(llRowPos, 'from_zip') > ' ' Then
//	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'from_zip')) + ','					//Ship-From zip
//Else 
//	lsOutString += ','
//End If	
//
//If ldsUPS.GetItemString(llRowPos, 'from_Country') > ' ' Then
//	lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'from_Country')) + ','			//Ship-From County
//Else 
//	lsOutString += ','
//End If	
//
//Ship To
	//If ship to Customer Type is WH then use address from warehouse else use address from customer_master
	lsCust_type =  ldsUPS.GetItemString(llRowPos, 'to_CustType')				//Customer Type
	If lsCust_type = 'WH' Then
			//Use the customer.userfield2 ie. PND_XXX to get information from warehouse table
			ls_Simswh =  ldsUPS.GetItemString(llRowPos,'sims_wh')
			//Retreive ldsWH
			ldsWH.Retrieve(ls_Simswh)
			lsOutString += NoNull(ldsWH.GetItemString(1, 'wh_code')) + ','			//wh_code ie.PND_ATLNTA
			//Ship to address_1
			ls_Whaddr1 = ldsWH.GetItemString(1, 'address_1') 						
			ls_Whaddr1= f_string_replace(ls_whaddr1, ",", "  ")			
			If ls_Whaddr1 > ' ' Then
				lsOutString += NoNull(ls_Whaddr1) +  ','										//Ship-From Address_1 (Customer)									
			Else
				lsOutString +=  ','
			End If	
				
			//From address_2 from customer table customer_type = 'WH)
			ls_Whaddr2 =  ldsWH.GetItemString(1, 'address_2') 							
			ls_Whaddr2= f_string_replace(ls_Whaddr2, ",", "  ")	
			If ls_Whaddr2 > ' ' Then
				lsOutString += NoNull(ls_Whaddr2) + ','										//Ship-From Address_2 (Customer)			
			Else
				lsOutString +=  ','
			End If
			
			//From address_3 from customer table customer_type = 'WH)
			ls_Whaddr3 =ldsWH.GetItemString(1, 'address_3') 						
			ls_Whaddr3= f_string_replace(ls_whaddr3, ",", "  ")	
			If ls_Whaddr3 > ' ' Then
				lsOutString += NoNull(ls_Whaddr3) + ','										//Ship-To Address_3 (Customer)			
			Else
				lsOutString +=  ','
			End If
			
			//From address_4 from customer table customer_type = 'WH)
			ls_whaddr4 = ldsWH.GetItemString(1, 'address_4')						
			ls_whaddr4= f_string_replace(	ls_Whaddr4, ",", "  ")	
			If ls_Whaddr4 > ' ' Then
				lsOutString += NoNull(ls_Whaddr4) + ','										//Ship-to Address_4 (Customer)			
			Else
				lsOutString +=  ','
			End If
			
			If	ldsWH.GetItemString(1, 'city') > ' ' Then
				lsOutString += NoNull(ldsWH.GetItemString(1, 'city')) + ','				//Ship-To city
			Else 
				lsOutString += ','
			End If
			
			If 	ldsWH.GetItemString(1, 'state') > ' ' Then
				lsOutString += NoNull(ldsWH.GetItemString(1, 'state')) + ','				//Ship-To state
			Else 
				lsOutString += ','
			End If
			
			If 	ldsWH.GetItemString(1, 'zip') > ' ' Then
				lsOutString += NoNull(ldsWH.GetItemString(1, 'zip')) + ','				//Ship-To zip
			Else 
				lsOutString += ','
			End If	
			
			If ldsWH.GetItemString(1, 'Country') > ' ' Then
				lsOutString += NoNull(ldsWH.GetItemString(1, 'Country')) + ','			//Ship-To County
			Else 
				lsOutString += ','
			End If
			
			If 	ldsWH.GetItemString(1, 'Tel') > ' ' Then
				lsOutString += NoNull(ldsWH.GetItemString(1, 'Tel')) + ','			   //Ship-To Phone number
			Else 
				lsOutString += ','
			End If			
			//End of ship to for  "WH" customer type information from Warehouse table ldsWH	
	//If customer type is not 'WH'
	Else
			//use information customer_master information
			lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'cust_code')) + ','			//Ship To customer
			
			//To address_1 to customer table
			ls_Toaddr1 = ldsUPS.GetItemString(llRowPos, 'to_address1')									
			ls_Toaddr1 = f_string_replace(ls_Toaddr1, ",", "  ")
			If ls_Toaddr1 > ' ' Then
				lsOutString += NoNull(ls_Toaddr1) + ','			//Ship-To Address_1 (Customer)			
			Else
				lsOutString +=  ','
			End If
			
			//To address_2 to customer table
			ls_Toaddr2 = ldsUPS.GetItemString(llRowPos, 'to_address2')		
			ls_Toaddr2 = f_string_replace(ls_Toaddr2, ",", "  ")
			If ls_Toaddr2 > ' ' Then
				lsOutString += NoNull(ls_Toaddr2) + ','			//Ship-To Address_2 (Customer)			
			Else
				lsOutString +=  ','
			End If
			
			//To address_3 to customer table
			ls_Toaddr3 = ldsUPS.GetItemString(llRowPos, 'to_address3') 						
			ls_Toaddr3 = f_string_replace(ls_Toaddr3, ",", "  ")									
			If ls_Toaddr3 > ' ' Then
				lsOutString += NoNull(ls_Toaddr3) + ','			//Ship-To Address_3 (Customer)			
			Else
				lsOutString +=  ','
			End If		
			
			//To address_4 to customer table								
			ls_Toaddr4 = ldsUPS.GetItemString(llRowPos, 'to_address4') 			
			ls_Toaddr4 = f_string_replace(ls_Toaddr4, ",", "  ")
			If ls_Toaddr4 > ' ' Then
				lsOutString += NoNull(ls_Toaddr4) + ','			//Ship-To Address_4 (Customer)			
			Else
				lsOutString +=  ','
			End If					
												
			If 	ldsUPS.GetItemString(llRowPos, 'to_City') > ' ' Then
				lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'to_City')) + ','						//Ship-To City
			Else 
				lsOutString += ','
			End If
			
			If	ldsUPS.GetItemString(llRowPos, 'to_State') > ' ' Then
				lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'to_State')) + ','						//Ship-To State
			Else 
				lsOutString += ','
			End If
			
			If   ldsUPS.GetItemString(llRowPos, 'to_Zip') > ' ' Then
				lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'to_Zip')) + ','							//Ship-To Zip
			Else 
				lsOutString += ','
			End If
			
			If 	ldsUPS.GetItemString(llRowPos, 'to_Country') > ' ' Then
				lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'to_Country')) + ','					//Ship-To Country
			Else 
				lsOutString += ','
			End If
			
			If 	ldsUPS.GetItemString(llRowPos, 'to_Tel') > ' ' Then
				lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'to_Tel')) + ','							//Ship-To Phone number
			Else 
				lsOutString += ','
			End If			
		End If
		//End of customer type condition.

lsOutString += 	','																									//leave blank // UPS LTL/TL Shipment Check-box
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'carrier_code')) + ','				//carrier 'UPS%'
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'freight_terms')) +  ','				//freight terms INCOTERMS
lsOutString += 	'Electronic Goods,'																			//electronic goods
lsOutString += 	','																									//leave blank
lsOutString +=	 ','																									//leave blank Freight class
lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'Carton_no')) +  ','				     //Carton_no

			//Dim
			// Get the length, height, and width
			ld_depth = ldsUPS.getitemdecimal(llRowPos, "length")
			ld_height = ldsUPS.getitemdecimal(llRowPos, "height")
			ld_width = ldsUPS.getitemdecimal(llRowPos, "width")	
		
lsOutString +=  Nonull(string( Truncate(ld_depth,0) ))  + ','			//length
lsOutString +=  Nonull(string( Truncate(ld_width,0) ))   + ','			//width
lsOutString +=  Nonull(string( Truncate(ld_height,0) )) + ','		//height						

lsOutString += NoNull(ldsUPS.GetItemString(llRowPos, 'carton_type')) +','			//Carton_Type

			//ldQty =  ldsUPS.GetItemNumber(llRowPos, 'Quantity')
			ldQty = 1   //always 1 per BRD
			ldWgt = ldsUPS.GetItemNumber(llRowPos, 'Weight_Gross')
			
			if isNull(ldQty) then ldQty = 0
			if isNull(llCtnCount) then llCtnCount = 0
			if isNull(ldWGT) then ldWGT = 0			

lsOutString +=  Nonull(string( Truncate(ldQty,0) )) +','		//Quantity
lsOutString +=  Nonull(string( Truncate(ldWgt,0) )) +','		//Gross Weight

idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
//Jxlim 05/18/2011 modified file name per BRD changed.
//lsfilename= 'UPSLT' + String(ldBatchSeq, '000000') + '.csv'		
lsfilename= 'UPSFREIGHTIN' + '.csv'		
idsOut.SetItem(llNewRow, 'file_name', lsfilename) 			
idsOut.SetItem(llNewRow,'dest_cd', 'UPS') /* routed to different folder for processing */
					
Next

//Write the Outbound File
If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PANDORA')
End If

Return 0

end function

public function integer uf_process_cityblock_inbound_rpt (string asproject);//Process the Cityblock Inbound Order  Report
//TimA 04/12/2011 Pandora Issue #190

String                    sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsRONO, lsSerial
Long                     llRowPos, llRowCount, llNewRow
Int						liRC
Decimal               ldBatchSeq
Datastore            ldsOrders, ldsOut
DateTime			ldtToday
string				lsDate, ls_remark

//Jxlim 09/02/2011 Added Date time stamp
ldtToday = DateTime(Today(), Now())
lsdate =  String(ldtToday, 'YYYYMMDD_HHMMSS')

lsLogOut = "      Creating Pandora CityBlock Inbound Order File... " 
FileWrite(gilogFileNo,lsLogOut)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
                lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) UPS Load Tender Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
                FileWrite(gilogFileNo,lsLogOut)
                Return -1
End If

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
ldsOrders = Create Datastore

//Commented out the checking on servername when is ready for production BRD #303
//if sqlca.database <> "sims33prd" then //check for production database
//if sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database
					//Jxlim 09/27/2011 BRD #303 Added Serial_Number_Inventory table and pull serial_no from this table, new CB inbound query
//					sql_syntax = " Select RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, Sum(RP.Quantity) as Qty, "
//					sql_syntax += "  RP.Line_Item_no,Sn.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc, IM.serialized_ind, RM.Remark "
//					sql_syntax += "  From Receive_Master RM with(nolock), Receive_Putaway RP with(nolock), Item_MASter IM with(nolock), Customer C with(nolock), Owner O with(nolock), Receive_Order_Type ROT with(nolock),  Serial_Number_Inventory SN with(nolock) "
//					sql_syntax += "  Where RM.Project_id = 'Pandora' and RM.Ord_status in ('C', 'D')  "				
//					sql_syntax += "  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
//					sql_syntax += "  and IM.grp = 'CB' "
//					sql_syntax += "  and RM.ro_no = RP.ro_no and RM.project_id = IM.Project_ID  and RP.sku = IM.Sku  "
//					sql_syntax += "  and RP.supp_Code = IM.Supp_Code and RM.User_Field6 = C.Cust_Code and RM.Project_id = C.Project_id "
//					sql_syntax += " and RP.Owner_ID = O.Owner_ID and RM.Ord_Type = ROT.Ord_Type and RM.Project_id = ROT.Project_id "
//					sql_syntax += " and RM.Project_id =sn.Project_id and RP.SKU = sn.SKU and RP.Serial_no = Sn.Serial_no"
//					sql_syntax += "  Group by RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, RP.Line_Item_no, "
//					sql_syntax += "  RP.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc,IM.serialized_ind, RM.Remark, SN.Serial_no "
//Else
//					//dts - 5/18/11 - added RM.Remark.
//					sql_syntax = " Select RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, Sum(RP.Quantity) as Qty, "
//					sql_syntax += "  RP.Line_Item_no,RP.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc, IM.serialized_ind, RM.Remark "
//					sql_syntax += "  From Receive_Master RM with(nolock), Receive_Putaway RP with(nolock), Item_MASter IM with(nolock), Customer C with(nolock), Owner O with(nolock), Receive_Order_Type ROT with(nolock) "
//					sql_syntax += "  Where RM.Project_id = 'Pandora' and (O.Project_ID = 'Pandora' and right(rtrim(O.owner_cd),3)='CTY' or right(rtrim(O.owner_cd),2)='CB') "
//					sql_syntax += "  and RM.Ord_status in ('C', 'D')  "
//					sql_syntax += "  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
//					sql_syntax += "  and IM.grp = 'CB' "
//					sql_syntax += "  and RM.ro_no = RP.ro_no and RM.project_id = IM.Project_ID  and RP.sku = IM.Sku  "
//					sql_syntax += "  and RP.supp_Code = IM.Supp_Code and RM.User_Field6 = C.Cust_Code and RM.Project_id = C.Project_id and RP.Owner_ID = O.Owner_ID and RM.Ord_Type = ROT.Ord_Type and RM.Project_id = ROT.Project_id  "
//					sql_syntax += "  Group by RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, RP.Line_Item_no, "
//					sql_syntax += "  RP.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc,IM.serialized_ind, RM.Remark "
//End If 
//Jxlim 10/27/2011 BRD #303 Not pulling serial number from serial_number table and remove owner criteria
//dts - 5/18/11 - added RM.Remark.
					sql_syntax = " Select RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, Sum(RP.Quantity) as Qty, "
					sql_syntax += "  RP.Line_Item_no,RP.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc, IM.serialized_ind, RM.Remark "
					sql_syntax += "  From Receive_Master RM with(nolock), Receive_Putaway RP with(nolock), Item_MASter IM with(nolock), Customer C with(nolock), Owner O with(nolock), Receive_Order_Type ROT with(nolock) "
					sql_syntax += "  Where RM.Project_id = 'Pandora' and RM.Ord_status in ('C', 'D')  "
					sql_syntax += "  and (file_transmit_ind is null or file_transmit_ind <> 'Y')  "
					sql_syntax += "  and IM.grp = 'CB' "
					sql_syntax += "  and RM.ro_no = RP.ro_no and RM.project_id = IM.Project_ID  and RP.sku = IM.Sku  "
					sql_syntax += "  and RP.supp_Code = IM.Supp_Code and RM.User_Field6 = C.Cust_Code and RM.Project_id = C.Project_id and RP.Owner_ID = O.Owner_ID and RM.Ord_Type = ROT.Ord_Type and RM.Project_id = ROT.Project_id  "
					sql_syntax += "  Group by RM.ro_no,RM.complete_date, RM.wh_Code, O.Owner_CD, RP.SKU, RM.User_field6, C.city, C.country, RP.Line_Item_no, "
					sql_syntax += "  RP.Serial_No, RM.AWB_BOL_No,RM.Supp_Invoice_No,ROT.Ord_Type_Desc,IM.serialized_ind, RM.Remark "

ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
                lsLogOut = "        *** Unable to create datastore for Pandora CityBlock  (Inbound Order Data).~r~r" + Errors
                FileWrite(gilogFileNo,lsLogOut)
                RETURN - 1
END IF

lirc = ldsOrders.SetTransobject(sqlca)

lLRowCount = ldsOrders.Retrieve()

lsLogOut = "    - " + String(lLRowCount) + " Order  records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Jxlim 11/01/2011 Send emptry file with header when there not record.
//Add a column Header Row*/
//If lLRowCount > 0 Then
                llNewRow = ldsOut.insertRow(0)
                lsOutString = "Arrival Date, Warehouse, Owner, GPN, Customer Code, City, Country, Qty, Lines, Serial #, AWB, Order No, Order Type, Transaction Reference"
                ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
                ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
                ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
                ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
			 //Jxlim 09/02/2011 added date timestamp to file name
			 ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT.csv')
			 //ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_' + string(ldBatchSeq) + '.csv')
                //ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_' + lsdate + '.csv')            
                ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
//End If

For llRowPos = 1 to lLRowCount /*Each Order*/
                
                llNewRow = ldsOut.insertRow(0)
                
                lsOutString = String(ldsOrders.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","
                
                If Not isnull(ldsOrders.GetITemString(llRowPos,'wh_code')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'wh_code') + '",'
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemString(llRowPos,'owner_cd')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'owner_cd') + '",'
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemString(llRowPos,'SKU')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'SKU') + '",'
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemString(llRowPos,'User_Field6')) Then /*Customer Name */
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'User_Field6') + '",'
                Else
                                lsOutString += ","
                End If
                
                If Not isnull(ldsOrders.GetITemString(llRowPos,'city')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'city') +'",'
                Else
                                lsOutString += ","
                End If
                
                If Not isnull(ldsOrders.GetITemString(llRowPos,'Country')) Then
                                lsOutString += '"' +  ldsOrders.GetITemString(llRowPos,'country') + '",'
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemNumber(llRowPos,'Qty')) Then
                                lsOutString += '"' + string(ldsOrders.GetITemNumber(llRowPos,'Qty')) + '",'
                Else
                                lsOutString += ","
                End If
                
                If Not isnull(ldsOrders.GetITemNumber(llRowPos,'Line_Item_no')) Then
                                lsOutString += '"' +  String(ldsOrders.GetITemNumber(llRowPos,'Line_Item_no')) + '",'
                Else
                                lsOutString += ","
                End If
                
                If Not isnull(ldsOrders.GetITemString(llRowPos,'Serial_No')) Then  
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Serial_No') + '",'   
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemString(llRowPos,'AWB_BOL_No')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'AWB_BOL_No') + '",'
                Else
                                lsOutString += ","
                End If
                
                If Not isnull(ldsOrders.GetITemString(llRowPos,'Supp_Invoice_No')) Then
                                lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Supp_Invoice_No') + '",'
                Else
                                lsOutString += ","
                End If

                If Not isnull(ldsOrders.GetITemString(llRowPos,'Ord_Type_Desc')) Then
                              lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Ord_Type_Desc') + '",'							
                Else
                			lsOutString += ","
                End If

         //Jxlim 11/03/2011 Remove extra carriage return.     
			//dts 5/17/11 - added Transaction Ref (RM.Remark)
			ls_remark = ldsOrders.GetITemString(llRowPos,'Remark')
			ls_remark = f_string_replace(ls_remark, "~r~n", " ")
			ls_remark = Trim(ls_remark)
			If  Not isnull(ls_remark) Then
					 lsOutString += '"' + ls_remark + '"'	
			End If					
              //  If Not isnull(ldsOrders.GetITemString(llRowPos,'Remark')) Then						  
                           //lsOutString += '"' + ldsOrders.GetITemString(llRowPos,'Remark') + '",'	
					 //  lsOutString += '"' + (ldsOrders.GetITemString(llRowPos,'Remark')			
			 //Jxlim 10/26/2011 Removed extra comma BRD 303
               // Else	
					  // lsOutString += ","					
               // End If

                ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
                ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
                ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
                ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
			 //Jxlim 09/02/2011 added date timestamp to file name		
			ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT.csv')
			//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_' + string(ldBatchSeq) + '.csv')
               //ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_'  + lsdate + '.csv')                
                ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
                                
Next /*Order Record*/

//TimA Pandora Issue #281
//Add one more row to the file and place a <EOF> to show that it is the end of the file
If llNewRow > 0 then
lsOutString = '<EOF>'
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	 //Jxlim 09/02/2011 added date timestamp to file name
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_' + string(ldBatchSeq) + '.csv')
     //ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INBOUND_RPT_'  +  lsdate  + '.csv') 
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB')
End if
//Update the File Transmit Ind so we don;t send again
For llRowPos = 1 to lLRowCount /*Each Order*/
                
                lsRONO = ldsOrders.GetITEmString(llRowPos,'ro_no')
                Update Receive_Master
                Set File_Transmit_ind = 'Y'
                Where ro_no = :lsRONO;
                Commit;
Next

If ldsOut.RowCount() > 0 Then
          gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
                                

REturn 0

end function

public function integer uf_process_cityblock_inventory_rpt ();//Process the Cityblock Inventory Report
//Modified: TimA 04/13/2011 Pandora issue #190

String		sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsDesc, lsSerial
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut

DateTime			ldtToday
string				lsDate//, lsdescq

//Jxlim 09/02/2011 Added Date time stamp
ldtToday = DateTime(Today(), Now())
lsdate =  String(ldtToday, 'YYYYMMDD_HHMMSS')

lsLogOut = "      Creating Pandora CityBlock Inventory File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore

//Jxlim 10/24/2011 Commented out servername check, this is readdy for production
//Jxlim 09/27/2011 BRD #303 Replace with Serial_number_inventory and Item master tables
//This is pending for production BRD #303
//if sqlca.database <> "sims33prd" then //check for production database
//if sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database
				//Jxlim 09/27/2011 BRD #303 New CB inventory query
				sql_syntax = "Select '' Date_Received, '' Box_ID, Sn.wh_code, Sn.sku, '' as Inventory_Type, Sn.Serial_no, IM.Description, Sn.owner_cd "
				sql_syntax += " From Serial_Number_Inventory Sn with(nolock), Item_Master Im with(nolock) "
				sql_syntax += " Where sn.Project_id = 'Pandora' and Im.grp = 'CB' and  sn.Project_id = Im.Project_id and sn.sku = Im.sku"
//Else
//				sql_syntax = "select complete_Date, Content_Summary.wh_code, Content_Summary.sku, Content_Summary.Inventory_Type, container_id, Serial_no, Description, owner_cd, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty  "
//				sql_syntax += "  From Receive_Master with(nolock), Content_Summary with(nolock), Item_MAster with(nolock), Owner O with(nolock) "
//				sql_syntax += "  Where Content_Summary.Project_id = 'Pandora' and 	Item_MAster.grp = 'CB' and  "
//				sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no and "
//				sql_syntax += " Content_Summary.Project_id = Item_MAster.Project_id and Content_Summary.sku = Item_MAster.sku and "
//				sql_syntax += " Content_Summary.supp_Code = Item_MAster.supp_code and "
//				sql_syntax += " Content_Summary.Project_id = O.Project_id and Content_Summary.owner_id = O.Owner_id "
//				sql_syntax += " Group By complete_Date, Content_Summary.wh_code, Content_Summary.sku, Content_Summary.Inventory_Type, container_id, Serial_no, Description, O.owner_cd  "
//				sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) > 0 "
//				sql_syntax += " and right(rtrim(O.owner_cd),3)='CTY' or right(rtrim(O.owner_cd),2)='CB' " //TimA Pandora #190
//End IF

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora CityBlock  (BOH Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()

lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Jxlim 11/01/2011 Send emptry file with header when there not record.
//Add a column Header Row*/
//If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "Date Received,Box ID,Serial #,Warehouse,Part Number,Inventory Type,Part Description,Owner"
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	 //Jxlim 09/02/2011 added date timestamp to file name
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate + '.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
//End If

For llRowPos = 1 to lLRowCount /*Each Order*/
	
	llNewRow = ldsOut.insertRow(0)
	
	//Jxlim 10/24/2011 Commented out servername check, this is readdy for production
	 //Jxlim 10/14/2011 BRD #303  leave Receive_Date Blank
//	If  sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database	
		lsOutString = ","
//	Else
//		lsOutString = String(ldsBoh.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","  
//	End if
	
	 //Jxlim 10/14/2011 BRD #303  leave Box_ID Blank
//	 If  sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database	
		lsOutString += ","
//	Else
//		lsOutString += ldsBoh.GetITemString(llRowPos,'container_id') + ","		
//	End If
	
	//Serial may contain '.' ... 
	//lsOutString += ldsBoh.GetITemString(llRowPos,'serial_no') + ","
	lsSerial = ldsBoh.GetITemString(llRowPos,'serial_no')
	if right(lsSerial, 1) = '.' then lsSerial = left(lsSerial, len(lsSerial)-1)
	lsOutString += lsSerial + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'wh_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'sku') + ","
		
	//Jxlim 10/24/2011 Commented out servername check, this is readdy for production	
	//Jxlim 10/14/2011 BRD #303  leave Inventory_Type Blank
	//If   sqlca.servername <> "SimsDB.menlolog.com" Then //check for production database	
		lsOutString += ","
//	Else	
//		lsInvType =  ldsBoh.GetITemString(llRowPos,'Inventory_Type')  
//		Choose Case upper(lsInvType)
//			Case "W"
//			lsOutString += "FULL" + ","
//			Case "Z"
//			lsOutString += "ERASED" + ","
//			Case Else
//			lsOutString += ","
//		End Choose	
//	End If
	//Jxlim 10/14/2011 BRD #303  leave it Blank	
	
//Jxlim 09/14/2011	BRD #299 Jxlim #299 Unescaped quotes
//within a description field if there is a quote than replace with two single quote, two double "" won't work. 
//example of a part desription OPTIONS, HARD DRIVE CAPACITY, 750GB - 1TB, 6'', 2.5"

	//Function takes 3 string arguments: 
	String lsdescq, lsquote, lsreplace_with
	
	lsdescq = ldsBoh.GetITemString(llRowPos,'description')		
	lsquote = '"'
	lsreplace_with = '""'
	
	long ll_start_pos, len_lsquote
	ll_start_pos=1
	len_lsquote = len(lsquote) 
	
	//find the first occurrence of ls_quote... 
	ll_start_pos = Pos(lsdescq ,lsquote,ll_start_pos) 
	
	//only enter the loop if you find whats in lsquote
	DO WHILE ll_start_pos > 0 
		 //replace llsquote with lsreplace_with ... 
		 lsdescq = Replace(lsdescq,ll_start_pos,Len_lsquote,lsreplace_with) 
		 //find the next occurrence of lsquote
		ll_start_pos = Pos(lsdescq,lsquote,ll_start_pos+Len(lsreplace_with)) 
	LOOP 
	//Jxlim 09/15/2011 End of code
	lsOutString  +='"' + lsdescq + '",' /*description has commas, escape in quotes*/	
	
	lsOutString += ldsBoh.GetITemString(llRowPos,'owner_cd') 
		
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	 //Jxlim 09/02/2011 added date timestamp to file name
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate +'.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
		
Next /*Inventory Record*/

//TimA Pandora issue #281
//Add one more row to the file and place a <EOF> to show that it is the end of the file
If llNewRow > 0 then
	lsOutString = '<EOF>'
	llNewRow = ldsOut.insertRow(0)

	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)	
	 //Jxlim 09/02/2011 added date timestamp to file name
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate +'.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') 
End if

If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_cb_int ();//Process the Cityblock Inventory Report
//Modified: TimA 04/13/2011 Pandora issue #190

String		sql_syntax, ERRORS, lsLogOut, lsOutString, lsInvType, lsDesc, lsSerial
Long			llRowPos, llRowCount, llNewRow
Int				liRC
Datastore	ldsBOH, ldsOut

DateTime			ldtToday
string				lsDate, lsdescq

//Jxlim 09/02/2011 Added Date time stamp
ldtToday = DateTime(Today(), Now())
lsdate =  String(ldtToday, 'YYYYMMDD_HHMMSS')

lsLogOut = "      Creating Pandora CityBlock Inventory File... " 
FileWrite(gilogFileNo,lsLogOut)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'

ldsboh = Create Datastore

sql_syntax = "select complete_Date, Content_Summary.wh_code, Content_Summary.sku, Content_Summary.Inventory_Type, container_id, Serial_no, Description, owner_cd, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty  "
sql_syntax += "  From Receive_Master with(nolock), Content_Summary with(nolock), Item_MAster with(nolock), Owner with(nolock) "
sql_syntax += "  Where Content_Summary.Project_id = 'Pandora' and 	Item_MAster.grp = 'CB' and  "
sql_syntax += " Content_Summary.Project_id = Receive_MAster.Project_ID and Content_Summary.ro_no = Receive_Master.ro_no and "
sql_syntax += " Content_Summary.Project_id = Item_MAster.Project_id and Content_Summary.sku = Item_MAster.sku and Content_Summary.supp_Code = Item_MAster.supp_code and "
sql_syntax += " Content_Summary.Project_id = owner.Project_id and Content_Summary.owner_id = owner.Owner_id "
sql_syntax += " Group By complete_Date, Content_Summary.wh_code, Content_Summary.sku, Content_Summary.Inventory_Type, container_id, Serial_no, Description, owner_cd  "
sql_syntax += " Having Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) > 0 "
sql_syntax += " and right(rtrim(owner_cd),3)='CTY' or right(rtrim(owner_cd),2)='CB' " //TimA Pandora #190

ldsboh.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
 	 lsLogOut = "        *** Unable to create datastore for Pandora CityBlock  (BOH Data).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
 	 RETURN - 1
END IF

lirc = ldsboh.SetTransobject(sqlca)

lLRowCount = ldsBoh.Retrieve()


lsLogOut = "    - " + String(ldsboh) + " inventory records retrieved for  processing..."
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Add a column Header Row*/
If lLRowCount > 0 Then
	llNewRow = ldsOut.insertRow(0)
	lsOutString = "Date Received,Box ID,Serial #,Warehouse,Part Number,Inventory Type,Part Description,Owner"
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	 //Jxlim 09/02/2011 added date timestamp to file name
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate + '.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
End If

For llRowPos = 1 to lLRowCount /*Each Order*/
	
	llNewRow = ldsOut.insertRow(0)
	
	lsOutString = String(ldsBoh.GetITemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'container_id') + ","
	//Serial may contain '.' ... 
	//lsOutString += ldsBoh.GetITemString(llRowPos,'serial_no') + ","
	lsSerial = ldsBoh.GetITemString(llRowPos,'serial_no')
	if right(lsSerial, 1) = '.' then lsSerial = left(lsSerial, len(lsSerial)-1)
	lsOutString += lsSerial + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'wh_code') + ","
	lsOutString += ldsBoh.GetITemString(llRowPos,'sku') + ","
		
	lsInvType =  ldsBoh.GetITemString(llRowPos,'Inventory_Type') 
	Choose Case upper(lsInvType)
		Case "W"
			lsOutString += "FULL" + ","
		Case "Z"
			lsOutString += "ERASED" + ","
		Case Else
			lsOutString += ","
	End Choose
		
	//Jxlim 09/14/2011	BRD #299 Jxlim #299 Unescaped quotes
	//within a description field if there is a quote than replace with two single quote, two double "" won't work. 
	//eaxmple of a part desription OPTIONS, HARD DRIVE CAPACITY, 750GB - 1TB, 6'', 2.5"
	lsdescq = ldsBoh.GetITemString(llRowPos,'description')			
//	lsdescq= f_string_replace(lsdescq, '"', '""')
	//lsdescq = Replace(lsdescq, Pos(lsdescq, '"'), Len('"'), '""')
//	lsOutString  +='"' + lsdescq + '  ",' /*description has commas, encase in quotes*/	
	lsOutString  +="'"   + lsdescq + "',"   /*description has commas, encase in quotes*/	

//if Pos(lsdescq, '"') > 0 then
//	lsdescq = Replace(lsdescq, Pos(lsdescq, '"'), Len('"'), '""')
//	lsOutString  +='"' + lsdescq + '",' /*description has commas, encase in quotes*/	
//	//	lsOutString +='"' + lsdescq + '"' + '",' /*description has commas, encase in quotes*/			
//else
//	// base case	
//	//lsOutString +='"' +  ldsBoh.GetITemString(llRowPos,'description') + '",' /*description has commas, encase in quotes*/	
//	lsOutString  +='"' + lsdescq + '",' /*description has commas, encase in quotes*/	
//end if
	
	lsOutString += ldsBoh.GetITemString(llRowPos,'owner_cd') 
		
	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	 //Jxlim 09/02/2011 added date timestamp to file name
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate +'.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') /* routed to different folder for processing */
		
Next /*Inventory Record*/

//TimA Pandora issue #281
//Add one more row to the file and place a <EOF> to show that it is the end of the file
If llNewRow > 0 then
	lsOutString = '<EOF>'
	llNewRow = ldsOut.insertRow(0)

	ldsOut.SetItem(llNewRow,'Project_id', 'PANDORA')
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', 1)
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)	
	 //Jxlim 09/02/2011 added date timestamp to file name
	//ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT.csv')
	ldsOut.SetItem(llNewRow,'file_name', 'CB-DAILY_INV_RPT_' + lsdate +'.csv')
	ldsOut.SetItem(llNewRow,'dest_cd', 'CB') 
End if

If ldsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,'PANDORA')
End If
		

REturn 0
end function

public function integer uf_ci (string asproject, string asdono);//Jxlim 03/24/2011 This function create CI file prefix
/* When an order is saved in Packing status, we are sending a 3B18 to Pandora to communicate Commercial Invoice data.  
	We're starting with our existing Goods Issue file and adding fields necessary for the Commercial Invoice
	ICC will translate our 'CI' file into the 3B18
	This started as a copy of uf_gi_rose but separating it here in case we take divergent paths....
	
	- Pandora has Material Transfers and the Inventory Transaction Confirmation uses the same format
       for both Inbound and Outbound so sharing new datastore; d_pandora_inv_trans 
	
	ALL outbound orders will send the CI file (not just the electronic-enabled orders)		
			*/

Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType, lsFromLoc
String		lsWHName, lsWHAddr1, lsWHAddr2, lsWHAddr3, lsWHAddr4, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lstempdate, ls_PacificTime, lsInvoice, lsToProjectDetail 
string		lsRONO, lsPOPLoc, lsSKU, lsDONO, lsChildLine
Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer		liRC, liLine
datetime ldtTemp, ldtToday
decimal	ldTransID
string 	lsWHContact, lsWHPhone, lsWHEmail, lsThisCarton, lsLastCarton, ls_shippertrackingno
decimal 	ldWgt
decimal   ldQty, ld_height, ld_width, ld_depth
long		llCtnCount
datastore	ldsDoPack_Track, ldsDoPack, ldsDOSerial		// GailM - 4/24/2014 - change DO Serial from instance to local variable.  Cross-Function error. 
string lsCartonType, lsPndser
string lsSKU_Hold, lsDescription, lsCarrier, lsCarrierName, lsSCAC
String ls_carrier_pro_awb_bol_no	// LTK 20150930 used to hold carrier pro no, unless null then holds AWB_BOL_NO, used in 3 locations

string lsStatus
ldtToday = DateTime(Today(), Now())

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGI) Then
	idsGI = Create Datastore
	idsGI.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDOSerial) Then
	ldsDOSerial = Create Datastore
	ldsDOSerial.Dataobject = 'd_gi_outbound_serial_pandora'
	ldsDOSerial.SetTransObject(SQLCA)
End If

//dts - 12/05/2010 - changed use of instance variable idsDoPack to local variable ldsDoPack to avoid the possibility of incorrect DataObject
If Not isvalid(ldsDoPack) Then
	ldsDoPack = Create Datastore
	ldsDoPack.Dataobject = 'd_do_packing'
	ldsDoPack.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDoPack_Track) Then
	ldsDoPack_Track = Create Datastore
	ldsDoPack_Track.Dataobject = 'd_do_packing_track_id_pandora'
	ldsDoPack_Track.SetTransObject(SQLCA)
End If


idsOut.Reset()
idsGI.Reset()

lsLogOut = "      Creating Inventory Transaction (CI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master, Detail and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsStatus = idsDOMain.GetItemString(1, 'ord_status')

// LTK 20150930  Set carrier pro variable here.  If carrier pro is null, then set the variable to AWB_BOL_NO.  Variable is used in 3 locations.
if NOT IsNull( idsDOMain.GetItemString(1, 'Carrier_Pro_no') ) or Len( Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') )) > 0 then
	ls_carrier_pro_awb_bol_no = NoNull(Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') ))
else
	ls_carrier_pro_awb_bol_no = NoNull(Trim( idsDOMain.GetItemString(1, 'AWB_BOL_No') ))
end if


//For Pandora, still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = idsDOMain.GetItemString(1, 'wh_code')
Select wh_Name, address_1, address_2, city, state, zip, country, contact_person, tel, fwd_pick_email_notification  
Into :lsWHName, :lsWHAddr1, :lsWHADdr2, :lsWHCity, :lsWHState, :lsWHZip, :lsWHCountry, :lsWHContact, :lsWHPhone, :lsWHEmail
From Warehouse
Where wh_code = :lsWH;

/* all orders send the CI transaction...
//If not received elctronically, don't send a confirmation
//what if it's from the web, with edi_inbound details (for po_no, for example)?
//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	// 5/07/2010 - need to see if this is a back order and if the original order was electronic....
	lsInvoice = idsDOMain.GetItemString(1, 'Invoice_no')
	select do_no into :lsDONO from Delivery_master where project_id = 'pandora' and invoice_no = :lsInvoice and wh_code = :lsWH and create_user = 'SIMSFP';
	if lsDONO > '' then
		lsElectronicYN = 'Y'
	end if
end if

// 08/09 - PCONKL - WE want to suppress the GI for MIM owned Inventory - Based on Customer UF1(Group) = "S-OWND-MIM"
lsFromLoc = idsDoMain.GetITemString(1,'User_field2')
If Not isnull(lsFromLoc) Then
	select user_field1 into :lsGroup
	from customer
	where project_id = :asProject and cust_code = :lsFromLoc;
	If lsGroup > '' and not isnull(lsGroup) and Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GI Suppressed for MIM Owned Inventory transaction For DO_NO: " + asDONO + ". No GI is being created for this order."
		FileWrite(gilogFileNo,lsLogOut)
		Return 0
	End IF
End IF
*/

idsDoDetail.Retrieve(asDoNo)

idsDoPick.Retrieve(asDoNo)

ldsDOSerial.Retrieve(asDoNo)		

ldsDoPack.Retrieve(asDoNo)

ldsDoPack_Track.Retrieve(asDoNo)

// TAm 2010/06/09 - Filter out Children
idsDOPick.Setfilter("Component_Ind <> '*'")
idsDOPick.Filter()

//For each sku/line Item/ in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc )

//TimA 08/06/13 Pandora #624
//Send a CI-3b18 to Pandora when the order is first dropped.  This is so they will have a heads up about the upcoming order
//**** NOTE: If order is in New status this is for a pre sending of a CI 3b18.  Since there is not Picking or packing rows at this time we have to use detail
//**** rows to create the file.
IF lsStatus = 'N' then
	llRowCount = idsDoDetail.RowCount()
	ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
	For llRowPos = 1 to llRowCount
		lsFind = "upper(sku) = '" + upper(idsDoDetail.GetItemString(llRowPos,'SKU')) +"'"
		lsFind += " and trans_line_no = '" + string(idsDoDetail.GetItemNumber(llRowPos, 'line_item_no')) + "'"
		llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())

		If llFindRow > 0 Then /*row already exists, add the qty*/
			idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDoDetail.GetItemNumber(llRowPos,'quantity')))
		Else
			ldOwnerID = idsDoDetail.GetItemNumber(1, 'owner_id')
	
			If ldOwnerID <> ldOwnerID_Prev then
				select owner_cd into :lsOwnerCD
				from owner
				where project_id = :asProject and owner_id = :ldOwnerID;
				ldOwnerID_Prev = ldOwnerID
	
				//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
				select user_field1 into :lsGroup
				from customer
				where project_id = :asProject and cust_code = :lsOwnerCd;
				if left(lsGroup, 3) = 'GIG' then 
					lsGigYN = 'Y'
				else
					lsGigYN = 'N'
				end if
			End if

			llNewRow = idsGI.InsertRow(0)
			idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) 
		
			idsGI.SetItem(llNewRow, 'from_loc', upper(trim(lsOwnerCD))) 
		
			idsGI.SetItem(llNewRow, 'to_loc', upper(trim(idsDOMain.GetItemString(1, 'cust_code')))) 
			idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
			idsGI.SetItem(llNewRow, 'sku', idsDoDetail.GetItemString(llRowPos, 'sku'))
			idsGI.SetItem(llNewRow, 'from_project', trim(idsDoDetail.GetItemString(llRowPos, 'user_field7'))) //This is where from is stored in the detail record
			idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  
			idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))
			idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDoDetail.GetItemNumber(llRowPos, 'line_item_no')))
			idsGI.SetItem(llNewRow, 'quantity', idsDoDetail.GetItemNumber(llRowPos, 'Req_Qty'))
			idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
			//idsGI.SetItem(llNewRow, 'lot', idsDoDetail.GetItemString(llRowPos, 'lot_no')) 								//Not found in detail rows
			//idsGI.SetItem(llNewRow, 'coo', idsDoDetail.GetItemString(llRowPos, 'user_field1'))						//Not found in detail rows
	
			//Get Alt SKU/ Defect Serial Number/ Defective Tracking Number from Detail row.
			lsFind = "upper(sku) = '" + upper(idsDoDetail.GetItemString(llRowPos,'SKU')) +"'"
			lsFind += " and line_item_no = " + string(idsDoDetail.GetItemNumber(llRowPos, 'line_item_no'))
	
			llFindDetailRow = idsDoDetail.Find(lsFind, 1, idsDoDetail.RowCount())
			If llFindDetailRow > 0 Then /*row found*/
				idsGI.SetItem(llNewRow, 'defect_serial_no', idsDODetail.GetItemString(llFindDetailRow,'user_field3'))
				idsGI.SetItem(llNewRow, 'defect_track_no', idsDODetail.GetItemString(llFindDetailRow,'user_field4'))
	
				idsGI.SetItem(llNewRow, 'to_project', idsDODetail.GetItemString(llFindDetailRow,'user_field5'))
				idsGI.SetItem(llNewRow, 'container_id', idsDODetail.GetItemString(llFindDetailRow, 'user_field7'))
				If idsDODetail.GetItemString(llFindDetailRow,'alternate_sku') > '' Then
					idsGI.SetItem(llNewRow, 'mfg_prt_no', idsDODetail.GetItemString(llFindDetailRow,'alternate_sku'))
				Else
					idsGI.SetItem(llNewRow, 'mfg_prt_no',  upper(idsDoDetail.GetItemString(llRowPos,'SKU')))
				End If
			Else /*not found, add a new record*/
				//error
			End If
		
		End if
	Next	
	//************ New status Pre CI 3b18	
ELSE
	//*********These are completed order that have Picking and Packing rows
	llRowCount = idsDOPick.RowCount()
	
	// 03/09 - Get the next available Trans_ID sequence number 
	ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
	If ldTransID <= 0 Then Return -1
			
	For llRowPos = 1 to llRowCount
		//TAM 2010/4/13 Skip parents of Delivery BOMS
		 If idsDOPick.GetItemString(llRowPos,'component_ind') = 'Y' and idsDOPick.GetItemNumber(llRowPos,'Component_no') = 0 Then Continue 
	
		//TEMPO - Check GR for  	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		//Rollup to SKU/Line
		//TimA 08/13/15 Pandora issue #994 added a new filter for COO.
		lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
		lsFind += " and trans_line_no = '" + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')) + "'"
		//TimA 08/25/15 #994 Currently commented out because Pandora is not ready for different lines based on different COO's.
		//Uncomment when Roy get's OK from Pandora and begin testing again.
		//Uncommented for QA testing 10/12/15
		//lsFind += " and coo = '" + string(idsDOPick.GetItemString(llRowPos, 'user_field1')) + "'"
		llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())
		
		If llFindRow > 0 Then /*row already exists, add the qty*/
			idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
		Else /*not found, add a new record*/
			//idsGI.SetItem(llNewRow, 'from_loc', trim(idsDOPick.GetItemString(1, 'owner_id'))) //TEMPO! NEED OWNER CODE HERE, not Owner_ID!
			//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change (and it shouldn't))
			ldOwnerID = idsDOPick.GetItemNumber(1, 'owner_id')
	
			if ldOwnerID <> ldOwnerID_Prev then
				select owner_cd into :lsOwnerCD
				from owner
				where project_id = :asProject and owner_id = :ldOwnerID;
				ldOwnerID_Prev = ldOwnerID
	
				//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
				select user_field1 into :lsGroup
				from customer
				where project_id = :asProject and cust_code = :lsOwnerCd;
				if left(lsGroup, 3) = 'GIG' then 
					lsGigYN = 'Y'
				else
					lsGigYN = 'N'
				end if
				/*  10-28-2010 - For CI 3B18, all orders send transaction...
				if lsElectronicYN = 'Y' then
					lsTransYN = 'Y'
				else
					//check to see if the Manual Order is GIG/BUILDS (if so, still send transaction)
					if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' then
						lsTransYN = 'Y'
					else
						lsTransYN = 'N'
					end if
				end if */
				lsTransYN = 'Y' // 10-28-2010 - For CI 3B18, all orders send transaction...
				// 7/29/09 - at this point, not yet sending transactions for Malaysia (or HongKong?).
				// 9/21/09 - Now sending transactions for Malaysia (or HongKong?).
				//if lsWH = 'PND_MLASIA' then lsTransYN = 'N'
			end if
			
			//Jxlim 03/29/2011 commented out per requirement changed.
			//Step 1. Checking Pandora Serial
			//Jxlim 03/24/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.      
			  		 //lsSku =   Upper(idsDOPick.GetItemString(llRowPos,'SKU'))
					 //Select     User_field18 into :lsPndSer		
					 //From       Item_Master		
					 //where     project_id = :asProject and sku = :lsSku		
					 //Using 	  SQLCA;      
			 //Jxim 03/24/2011 End of code
	 
			if lsTransYN = 'Y' then
				llNewRow = idsGI.InsertRow(0)
				//idsGI.SetItem(llNewRow, 'trans_id', trim(idsDOMain.GetItemString(1, 'do_no'))) // do_no for outbound
				// now using a transaction ID Sequence number.  Only grabbing the right-most 15 chars (as that's the limit on the interface)
				idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
				idsGI.SetItem(llNewRow, 'from_loc', upper(trim(lsOwnerCD))) // 08/09 - added 'upper'
		
				idsGI.SetItem(llNewRow, 'to_loc', upper(trim(idsDOMain.GetItemString(1, 'cust_code')))) // 08/09 - added 'upper'
				idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
				idsGI.SetItem(llNewRow, 'sku', idsDOPick.GetItemString(llRowPos, 'sku'))
				idsGI.SetItem(llNewRow, 'from_project', trim(idsDOPick.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
				//idsGI.SetItem(llNewRow, 'to_project', trim(idsDOMain.GetItemString(1, 'user_field8')))
				idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
				idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))
				//TAM 04/19/2010 -Added Line Item Number that came in on the Delivery BOMs
					If idsDOPick.GetItemString(llRowPos,'component_ind') = 'W' 			Then
					lsSKU = idsDOPick.GetItemString(llRowPos, 'sku')
					lsDoNO = trim(idsDOMain.GetItemString(1, 'do_no'))
					liLine = idsDOPick.GetItemNumber(llRowPos, 'line_item_no')
					SELECT dbo.Delivery_BOM.user_field1  
							INTO :lsChildLine  
							FROM dbo.Delivery_BOM  
							WHERE ( dbo.Delivery_BOM.Project_ID = 'PANDORA' ) AND  
							( dbo.Delivery_BOM.DO_NO = :lsDONO ) AND  
							( dbo.Delivery_BOM.Sku_Child = :lsSKU ) AND  
							( dbo.Delivery_BOM.Line_Item_No = :liLine )   ;
					If Not IsNull(lsChildLine) and lsChildLine <> '' Then
						idsGI.SetItem(llNewRow, 'trans_line_no', lsChildLine)
					Else
						idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
					End If
				Else
					idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
				End If
	
				//TEMPO!! - does this need to be the User Line No?  If so, store in User_Field on the line?
				//idsGI.SetItem(llNewRow, 'trans_line_no', string(idsROPutaway.GetItemNumber(llRowPos, 'user_line_item_no')))
			
				//Jxlim 03/29/2011 commented out per requirement changed.
				//Step 2 Get serial number from Sims
				//Jxlim 03/24/2011 Sending serial number when GPN is Pandora serial (Item_Master.User_field18)
				//	  If Upper(lsPndSer) = 'Y' Then
				//			idsGI.SetItem(llNewRow, 'serial_no', idsDOPick.GetItemString(llRowPos, 'serial_no'))
				//	  Else
				//			idsGI.SetItem(llNewRow, 'serial_no', '-')
				//	  End If
				//Jxlim 03/24/2011 end of code	
				
				idsGI.SetItem(llNewRow, 'quantity', idsDOPick.GetItemNumber(llRowPos, 'quantity'))
				//idsGI.SetItem(llNewRow, 'reference', trim(idsDOMain.GetItemString(1, 'remark')))  //remarks? UF? Invoice?
				idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
	
				idsGI.SetItem(llNewRow, 'lot', idsDOPick.GetItemString(llRowPos, 'lot_no'))
				//idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'country_of_origin'))
	
				// KZUV.COM - Get the country of origin from user_field1 instead of the country_of_origin field.
				idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'user_field1'))
	
				//DECOM/RMA.... NEED TO Turn this on/off for testing; b2b vs DECOM/RMA
				// 10/08/09 - now getting Container ID from dd.uf7 below (should this be for RMA only?)
				//idsGI.SetItem(llNewRow, 'container_id', idsDOPick.GetItemString(llRowPos, 'container_id'))
	
				//Get Alt SKU/ Defect Serial Number/ Defective Tracking Number from Detail row.
				lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
				lsFind += " and line_item_no = " + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no'))
	
				llFindDetailRow = idsDoDetail.Find(lsFind, 1, idsDoDetail.RowCount())
				If llFindDetailRow > 0 Then /*row found*/
					idsGI.SetItem(llNewRow, 'defect_serial_no', idsDODetail.GetItemString(llFindDetailRow,'user_field3'))
					idsGI.SetItem(llNewRow, 'defect_track_no', idsDODetail.GetItemString(llFindDetailRow,'user_field4'))
	
					idsGI.SetItem(llNewRow, 'to_project', idsDODetail.GetItemString(llFindDetailRow,'user_field5'))
					idsGI.SetItem(llNewRow, 'container_id', idsDODetail.GetItemString(llFindDetailRow, 'user_field7'))
					If idsDODetail.GetItemString(llFindDetailRow,'alternate_sku') > '' Then
						idsGI.SetItem(llNewRow, 'mfg_prt_no', idsDODetail.GetItemString(llFindDetailRow,'alternate_sku'))
					Else
						idsGI.SetItem(llNewRow, 'mfg_prt_no',  upper(idsDOPick.GetItemString(llRowPos,'SKU')))
					End If
				Else /*not found, add a new record*/
					//error
				End If
			End If
		End If
	Next /* Next Putaway record */
END IF  //End of checking order status on the order //TimA 08/06/13


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGI.RowCount()
If llRowCount <= 0 then return 0

//Build and Write the Header
llNewRow = idsOut.insertRow(0)
lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
lsOutString += 'SH1|' 																				//record type
lsOutString += lsWH + '|'																		//Warehouse
ldtToday = GetPacificTime(lsWH, ldtToday)
ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyymmddhhmmss')
lsOutString += ls_PacificTime + '|'  															//current_time
// 07/28/09 - lsOutString += NoNull(idsDOMain.GetItemString(1, 'invoice_no')) + '|' 					//supp_invoice_no
lsInvoice = NoNull(idsDOMain.GetItemString(1, 'invoice_no'))
if right(lsInvoice, 2) = '_2' then //for DECOM/RMA DC-to-DC Move, 2nd SO is created with a '_2' suffix...
	lsInvoice = left(lsInvoice, len(lsInvoice)-2)
elseif right(lsInvoice, 5) = '_DCWH' then //for DC's operating as a WH (with a designated 'Local WH'), WH x-fer from DC to Local WH is created with a '_DCWH' suffix...
	lsInvoice = left(lsInvoice, len(lsInvoice)-5)
end if
lsOutString += lsInvoice + '|' 																		//supp_invoice_no
lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_type')) + '|'						//Order_Type
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No')) + '|'				//Bill of Lading							// LTK 20150930 Commented out 
lsOutString += ls_carrier_pro_awb_bol_no + '|'												// Carrier Pro No or Bill of Lading 	// LTK 20150930 use common variable, nulls checked upon setting
lsOutString += NoNull(idsDOMain.GetItemString(1, 'User_Field2')) + '|'					//User_Field2
lsOutString += NoNull(idsDOMain.GetItemString(1, 'User_Field3')) + '|'					//User_Field3
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field7')) + '|'					//Transaction Type
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field11')) + '|'					//Requester

// KZUV.COM - Send 'Ship Via' instead of Carrier.
// dts 2/1/2011 - now send carrier name (from carrier_master) instead of Ship Via
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'carrier')) + '|'							//Carrier
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'ship_via')) + '|'							//Ship Via
// LTK 20110419  Pandora Enh #177  Field HD12 (carrier) will now contain Carrier_Master.Address_1
//												Field HD45 (service level) will now contain Carrier_master.Carrier_Name
String lsCarrierAddress1
lsCarrier = idsDOMain.GetItemString(1, 'carrier')
// 9/10/2012 dts - Issue 512: base DIMS logic on SCAC instead of Carrier Code
select carrier_name, address_1, SCAC_Code
into :lsCarrierName, :lsCarrierAddress1, :lsSCAC
from carrier_master
where project_id = 'pandora'
and carrier_code = :lsCarrier;
//lsOutString += NoNull(lsCarrierName) + '|'							//Carrier				// LTK 20110419  Pandora Enh #177
lsOutString += NoNull(lsCarrierAddress1) + '|'							//Carrier				// LTK 20110419  Pandora Enh #177 

//lsOutString += NoNull(idsDOMain.GetItemString(1, 'ship_ref')) + '|'						//PRO Number
// LTK 20150427  Pandora #962  Send Carrier Pro No unless it is null, then send continue to send ship_ref
//lsOutString += NoNull( nz( idsDOMain.GetItemString(1, 'Carrier_Pro_no'), idsDOMain.GetItemString(1, 'ship_ref') )) + '|'		//PRO Number
//29-Jun-2015 : Madhu- Added NoNull() to avoid to entire string becomes NULL.
//if IsNull( idsDOMain.GetItemString(1, 'Carrier_Pro_no') ) or Len( Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') )) = 0 then		// LTK 20150622  Added empty string check
//	//lsOutString += Trim( idsDOMain.GetItemString(1, 'ship_ref') ) + '|'
//	lsOutString += NoNull(Trim( idsDOMain.GetItemString(1, 'AWB_BOL_No') )) + '|'		// LTK 20150626  Roy requested this be changed from ship_ref to AWB_BOL_NO
//else
//	lsOutString += NoNull(Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') )) + '|'		//PRO Number
//end if
// LTK 20150930 Commented out above and now set with common variable below which is carrier pro no (unless null then AWB_BOL_NO), nulls checked upon setting variable
lsOutString += ls_carrier_pro_awb_bol_no + '|'


	ldtTemp = idsDOMain.GetItemDateTime(1, 'complete_date')			
	ldtTemp = GetPacificTime(lsWH, ldtTemp)
lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + '|'									//complete_date
lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_status')) + '|'					//Order Status
lsOutString += 	'|'																						//Ship-From ID
lsOutString += NoNull(lsWHName) + '|'															//Ship-From Name
lsOutString += NoNull(NoPipe(lsWHAddr1)) + '|'												//Ship-From Address1  GailM 2/27/2015 added call to NoPipe - will remove line feeds from string
lsOutString += NoNull(NoPipe(lsWHAddr2)) + '|'												//Ship-From Address2
lsOutString += NoNull(NoPipe(lsWHAddr3)) + '|'												//Ship-From Address3
lsOutString += NoNull(NoPipe(lsWHAddr4)) + '|'												//Ship-From Address4
lsOutString += NoNull(lsWHCity) + '|'																//Ship-From City
lsOutString += NoNull(lsWHState) + '|'															//Ship-From State
lsOutString += NoNull(lsWHZip) + '|'																//Ship-From Zip
lsOutString += NoNull(lsWHCountry) + '|'														//Ship-From Country
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Cust_Code')) + '|'					//Ship-To ID
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Cust_Name')) + '|'					//Ship-To Name
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Address_1')) + '|'					//Ship-To Address1
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Address_2')) + '|'					//Ship-To Address2
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Address_3')) + '|'					//Ship-To Address3
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Address_4')) + '|'					//Ship-To Address4
lsOutString += NoNull(idsDOMain.GetItemString(1, 'City')) + '|'								//Ship-To City
lsOutString += NoNull(idsDOMain.GetItemString(1, 'State')) + '|'							//Ship-To State
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Zip')) + '|'								//Ship-To Zip
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Country')) + '|'						//Ship-To Country
lsToProject = NoNull(idsDOMain.GetItemString(1, 'user_field8'))							//To Project
If lsToProject <> '-' and lsToProject <> 'NA' and lsToProject <> 'N/A' Then 
	lsOutString += NoNull(lsToProject) + '|' 
Else
	lsOutString += "|"
End If

ldtTemp = idsDOMain.GetItemDateTime(1, 'request_date')			
//if IsDate(String(ldtTemp)) then
//	ldtTemp = GetPacificTime(lsWH, ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + '|'								//request_date
//Else
//	lsOutString += "|"
//End If	
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Cust_Code')) + '|' 					//Customer Code
/*TODO!!! 
	POP Location (for DECOM): For outbound, POP Location is the 'FROM Location' for the order that received the Inventory
     - Need to grab ro_no (from any line?), then look up user_field3 
	  !now getting it from delivery_detail.UF6 */
//if left(lsGroup, 5) = 'DECOM' then 
	select min(user_field6) into :lsPopLoc
	from delivery_detail
	where do_no = :asDONO;
//end if

lsOutString += NoNull(lsPOPLoc) + '|'											  					//Original POP Location

/* dts 2010/08/12 - the fields below were added pursuant to the 3B18 CI transaction (and not in the original GI-3B13) */
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field2')) + '|' 	//From Company Code

//TimA 08/06/13 Pandora #624
//Use request_date from above because we don't have a pick_complete date yet
If lsStatus <> 'N' then
	ldtTemp = idsDOMain.GetItemDateTime(1, 'pick_complete')	
End if

lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + '|'								//Ship Date - when 3pl will ship the items
lsOutString += NoNull(idsDOMain.GetItemString(1, 'freight_terms')) + '|' 	//INCOTERMS
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Transport_mode')) + '|' 		//Mode of Transport

// LTK 20101217	Added call to f_string_replace() to remove all carriage return and line feeds which started showing 
//						up in the shipping_instructions column.  These characters can not be in the 3B18 files to ICC.
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'shipping_instructions')) + '|' 	//Special Instructions 
lsOutString += f_string_replace( NoNull(NoPipe(idsDOMain.GetItemString(1, 'shipping_instructions'))), "~r~n", " / " ) + '|'	//Special Instructions 

// LTK 20110419  Pandora Enh #177  Service Level now populated with carrier name
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field1')) + '|' //Service Level
lsOutString += NoNull(lsCarrierName) + '|' //Service Level

lsOutString += NoNull(lsWHContact) + '|'	//From Contact (WH.Contact_Person)
lsOutString += NoNull(lsWHEmail) + '|'	//Email Address (WH.Email_address)
lsOutString += NoNull(lsWHPhone) + '|'	//From Phone (WH.Tel)

//scroll thru packing and get carton count, weight and qty
llRowCount = ldsDoPack.RowCount()
ldsDoPack.SetSort('carton_no')
ldsDoPack.Sort()
For llRowPos = 1 to llRowCount
	//dts 1/12/11 - adding carton_type to the end of the CT1 record.  Grabbing it here since it is part of this datastore.  We're using the carton type of the first row for all rows...
	if llRowPos = 1 then
		lsCartonType = ldsDoPack.GetItemString(llRowPos, 'carton_type') 
	end if
	lsThisCarton = ldsDoPack.GetItemString(llRowPos, 'carton_no') 
	if lsThisCarton <> lsLastCarton then
		//Wgt/Dims are stored on each packing row but the values are for the carton, not the individual line (so only count each carton once)
		ldWgt = ldWgt + ldsDoPack.GetItemNumber(llRowPos, 'Weight_Gross')
		llCtnCount += 1
		lsLastCarton = lsThisCarton
	end if
	ldQty = ldQty + ldsDoPack.GetItemNumber(llRowPos, 'Quantity')
next
if isNull(ldQty) then ldQty = 0
if isNull(llCtnCount) then llCtnCount = 0
if isNull(ldWGT) then ldWGT = 0
lsOutString += string(ldQty) + '|'	//Picking.Quantity	//Total Pieces 
lsOutString += string(llCtnCount) + '|' //DM.Ctn_Cnt		//Pallets

// KZUV.COM - Round the weight to 2 decimals.
lsOutString += string(round(ldWgt, 2)) + '|'		//DM.Weight	//Total Weight 
// dts 2/1/2011 - adding Cost Center (DM.UF10 - comes in electronically or from Customer.UF7)
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field10')) 	 	         //Cost Center
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field10')) + '|'	 	//Cost Center

/* GailM - 845 - Shipment Number.  Is this where we put the shipment number (Check ICC) */
/* UnRem the below line and the line just above  and put back into QA for ICC testing.  */
//lsOutString += NoNull(string(idsDOMain.GetItemNumber(1, 'ship_cnt')))			 	//Shipment Number

idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'CI' + String(ldBatchSeq, '000000') + '.DAT') 

// Begin Detail Rows
llRowCount = idsGI.RowCount()
For llRowPos = 1 to llRowCount

	llNewRow = idsOut.insertRow(0)
	lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
	lsOutString += 'LC1|' 																				//Transaction Code
	lsOutString += lsWH + '|'																		//Warehouse
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'from_loc')) + '|' 								//sub-inventory location (stored as owner)
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'trans_line_no')) + '|'			//Line Item
	lsOutString += '|'																					// Original Quantity
	lsOutString += string(idsGI.GetItemNumber(llRowPos,'quantity')) + '|'				//Quantity
	lsOutString += 'EA|'																				//UOM
	//lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'sku')) + '|'						//SKU
	lsSKU = idsGI.GetItemString(llRowPos, 'sku')												//SKU
	lsOutString += NoNull(lsSKU) + '|'																//SKU
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'mfg_prt_no')) + '|'						//Manufacturer part number
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'defect_serial_no')) + '|'				//Defective Appl SN
	//TAM 3/1/2010 - Not Sending for decom
	// TAM 2010/01/22 Suppress lot # except Decom
	//	If left(lsGroup, 5) = 'DECOM'  Then
	//		lsOutString +=NoNull( idsGI.GetItemString(llRowPos, 'lot')) + '|'									//Lot
	//	Else
		lsOutString += '|'																					// Original Quantity
	//	End If
	lsOutString +=NoNull( idsGI.GetItemString(llRowPos, 'coo')) + '|'                          //CountryOfOrigin
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsFromProject = upper(idsGI.GetItemString(llRowPos, 'from_project')) /* Pandora Project (from po_no) */
	// 07/21/09 - BACK TO USING UPPER...lsFromProject = NoNull(idsGI.GetItemString(llRowPos, 'from_project'))							//From Project
	lsFromProject = Upper(NoNull(idsGI.GetItemString(llRowPos, 'from_project')))							//From Project
	If lsFromProject <> '-' and lsFromProject <> 'NA' and lsFromProject <> 'N/A' Then 
		lsOutString += NoNull(lsFromProject) + '|' 												//From Project
	Else
		lsOutString += "MAIN|"
	End If
		lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'defect_track_no'))	+ '|'				//Return Label Tracking Number
	
	
	// 07/21/09 - Using Upper... lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'to_project')) + '|'							//To Project
	lsToProjectDetail = Upper(NoNull(idsGI.GetItemString(llRowPos, 'to_project'))) 							//To Project
	if lsToProjectDetail = '' then
		lsOutString += 	lsToProject + '|'							//To Project  from the Header
	else
		lsOutString += lsToProjectDetail + '|'							//To Project
	end if
	//DECOM (added Container ID)...
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'container_id')) + '|'							//Container ID
	// dts 2/1/2011 - adding item description...
	if lsSKU_Hold <> lsSKU then
		select description into :lsDescription from item_master where project_id = 'PANDORA'
		and supp_code = 'PANDORA' and sku = :lsSKU;
		lsSKU_Hold = lsSKU
	end if
	lsOutString += NoNull(lsDescription)																			// Item Description
	
	idsOut.SetItem(llNewRow, 'Project_id', asProject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	idsOut.SetItem(llNewRow, 'file_name', 'CI' + String(ldBatchSeq, '000000') + '.DAT') 
	
next /*next output record */


//TimA 08/06/13 Pandora #624
//We don't have Serial numbers or packing rows when in New status
If lsStatus <> 'N' then
	// Begin Serial Rows
	// TAM 10/28/2009  Only want to send serial numbers for enterprise
	// TAM 06/2010  Send for all per Full Cycle Project
	//If left(lsGroup, 3) = 'ENT' Then
		llRowCount = ldsDOSerial.RowCount()
		For llRowPos = 1 to llRowCount
	
			llNewRow = idsOut.insertRow(0)
			lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
			lsOutString += 'SN1|' 																						//Transaction Code
			lsOutString += lsWH + '|'																				//Warehouse
			ldtToday = GetPacificTime(lsWH, ldtToday)
			lsOutString += String(ldtToday, 'yyyymmdd') + '|'  												//current_date
			lsOutString += String(ldtToday, 'hhmmss') + '|'  													//current_time
			// dts - 5/5/2010 - shouldn't this be lsInvoice?  What about '_2' and '_DCWH' orders?  Not an ENTerprise possibility?
			lsOutString += NoNull(idsDOMain.GetItemString(1, 'invoice_no')) + '|' 							//supp_invoice_no
			lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_type')) + '|'							//Order_Type
			lsOutString += string(ldsDOSerial.GetItemNumber(llRowPos, 'line_item_no')) + '|'			//Line Item
			lsOutString +=  '|'																							//Shipment		
		
			lsOutString += NoNull(ldsDOSerial.GetItemString(llRowPos, 'Country_of_origin')) + '|'		//COO
			lsOutString += NoNull(ldsDOSerial.GetItemString(llRowPos, 'carton_no')) 					//Container
	
			idsOut.SetItem(llNewRow, 'Project_id', asProject)
			idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
			idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
			idsOut.SetItem(llNewRow, 'file_name', 'CI' + String(ldBatchSeq, '000000') + '.DAT') 
		next /*next output record */
	//End If
	
	// Begin Packing Rows
	llRowCount = ldsDoPack_Track.RowCount()
	For llRowPos = 1 to llRowCount
		//dts 1/12/11 - adding carton_type to the end of the CT1 record
	
		// Get the height, width and depth
		ld_height = ldsDoPack_Track.getitemdecimal(llRowPos, "height")
		ld_width = ldsDoPack_Track.getitemdecimal(llRowPos, "width")
		ld_depth = ldsDoPack_Track.getitemdecimal(llRowPos, "length")
		//   9/17/2012 - dts - testing for 512 revealed issue with dim less than 1 (which truncates to 0). Per Ian, if less than 1, set to 1.
		if ld_height < 1 then ld_Height = 1
		if ld_width < 1 then ld_Width = 1
		if ld_depth < 1 then ld_depth = 1
		
		llNewRow = idsOut.insertRow(0)
		lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
		lsOutString += 'CT1|' 																					//Transaction Code
		lsOutString += lsWH + '|'																				//Warehouse
		ldtToday = GetPacificTime(lsWH, ldtToday)
		lsOutString += String(ldtToday, 'yyyymmdd') + '|'  												//current_date
		lsOutString += String(ldtToday, 'hhmmss') + '|'  													//current_time
		lsOutString +=  '|'																							//Shipment
		lsOutString += NoNull(ldsDoPack_Track.GetItemString(llRowPos, 'carton_no')) + '|'				//Container
		// lsOutString +=  '||||||||||||'																			//Unused fields
		lsOutString +=  '||'
		
		// 20110323 LTK	Per Revathy, if carrier is CH ROBINSON, then export DIMs information.
		//						Comment out previous DIMs code.
		//
		//	// Were just using placeholders for the dimensions for now.
		//	lsOutString +=  "|||"
		////`	lsOutString +=  nonull(string(ld_height)) + "|"
		////	lsOutString +=  nonull(string(ld_width)) + "|"
		////	lsOutString +=  nonull(string(ld_depth)) + "|"
		//
		// 9/10/2012 - dts - Issue 512: Now basing CHR DIMS code on Carrier SCAC = 'CHRW' or 'RBTW'
		// 20110323 LTK  New DIMs code.
		//if lsCarrier = 'CH ROBINSON FTL' or lsCarrier = 'CH ROBINSON LTL' then
		if upper(lsSCAC) = 'CHRW' or upper(lsSCAC) = 'RBTW' then
			lsOutString +=  nonull(string( Truncate(ld_height,0) )) + "|"	// 20110324 LTK truncate decimals per Revathy 
			lsOutString +=  nonull(string( Truncate(ld_width,0) )) + "|"		// 20110324 LTK truncate decimals per Revathy 
			lsOutString +=  nonull(string( Truncate(ld_depth,0) )) + "|"		// 20110324 LTK truncate decimals per Revathy 
		else
			// Were just using placeholders for the dimensions for now.
			lsOutString +=  "|||"
		end if
		// 20110323 LTK  End of new CH ROBINSON DIMs code.
	
		lsOutString +=  '|||||||'
		// 07/07/2010 TAM:  Fix per Trey's directions.  If null us AWB_BOL_No
		ls_shippertrackingno = ldsDoPack_Track.GetItemString(llRowPos, 'shipper_tracking_id')
		// KRZ add condition if ls_shippertrackingno = ""
		if isNull(ls_shippertrackingno) or ls_shippertrackingno = "" then
			//lsOutString += NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No'))	+ '|'
			// LTK 20150930 Commented out above and now set with common variable below which is carrier pro no (unless null then AWB_BOL_NO), nulls checked upon setting variable
			lsOutString += ls_carrier_pro_awb_bol_no + '|'
		else
			lsOutString += NoNull(ldsDoPack_Track.GetItemString(llRowPos, 'shipper_tracking_id')) + '|' 	//Tracking
		End If
		lsOutString += String(ldsDoPack_Track.GetItemNumber(llRowPos, 'line_item_no')) + '|' 				//Line No
		lsOutString += NoNull(lsCartonType)		//Carton_Type
	
		idsOut.SetItem(llNewRow, 'Project_id', asProject)
		idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		idsOut.SetItem(llNewRow, 'file_name', 'CI' + String(ldBatchSeq, '000000') + '.DAT') 
	next /*next output record */

End if

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
//TimA get the File name that was created in uf_process_flatfile_outbound
//asfilename = gu_nvo_process_files.isNewoutfilename

Return 0

end function

public function integer uf_gr_rose (string asproject, string asrono, string astransparm);// uf_gr_rose(string asproject, string asrono) returns integer

//Jxlim 03/23/2011 This function create GRR file (4B2)
//Prepare a Goods Receipt Transaction for PANDORA for the order that was just confirmed
/*  - Pandora has Material Transfers and the Inventory Transaction confirmation uses the same format
       for both Inbound and Outbound so sharing new datastore; d_pandora_inv_trans 
	
	  - Now sending confirmations only for Electronic orders and manual orders for GIG-owned and BUILDS-owned inventory
			
*/


Long		llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow
				
String	lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN
String   lsElectronicYN, lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_line_no

Decimal	ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer	liRC
DateTime ldtTemp

decimal	ldTransID
int li_Pos
string	lsPopLoc, lsInvoice, lsRONO, lsPndSer, lsSku, lsPrevSku
String 	ls_oracle_integrated
string   lsCOD  // ET3: Country of Dispatch
string lsToLoc
//dts 8/10/13 - #608 (LPN)
string lsSerial, lsOutStringSerial, lsOutString2, lsOutStringQty
string ls_serialized_ind, ls_PONO2ControlledInd, ls_ContainerTrackingInd, lsCartonID, lsPallet
long llSRow, llCartonRow, llCartonSerialRowCount

//TimA 4/21/14 Pandora Issue #36 Re-confirming an inbound order with selected detail rows
String lsLineParm
Boolean lbParmFound

String lsSkipProcess, lsSkipProcess2
String lsUniqueTrxId		

// GailM 2/ 25/2015 Add Unique Trx ID - Turn on with functionality manager - use lsSkipProcess2
lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

//TimA 10/09/14 Part of the Pandora issue #889.  When ICC is ready change the value in the lookup table to N.  This will turn on the part of the code in 889 below.
select User_Updateable_Ind
into :lsSkipProcess
from lookup_table
where project_id = 'PANDORA'
and code_type = 'SKIP_PROCESS'
and code_ID = 'Shipment_Distribution_No';

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	//idsGR.Dataobject = 'd_gr_layout'
	idsGR.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsROmain) Then
	idsROmain = Create Datastore
	idsROmain.Dataobject = 'd_ro_master'
	idsROMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsroDetail) Then
	idsroDetail = Create Datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
	idsroDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

//dts 8/10/13 - Pandora #608 (LPN)
If Not isvalid(idsCartonSerial) Then
	idsCartonSerial = Create Datastore
	idsCartonSerial.Dataobject = 'd_carton_serial_pandora'
	idsCartonSerial.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

/* 11/12/12 - dts, issue 548 - We want to suppress the GR into *SOIMIM - Based on Customer UF1(Group) = "S-OWND-MIM"
				- assuming all *SOIMIM orders will have RM.UF2 (sub-inventory location) populated. Comparing owner codes substantiates that assumption at this time */
lsToLoc = idsRoMain.GetItemString(1,'User_field2')
If Not isnull(lsToLoc) Then
	select user_field1 into :lsGroup
	from customer
	where project_id = :asProject and cust_code = :lsToLoc;
	
	If Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GR Suppressed for MIM Owned-Inventory transaction For RO_NO: " + asRONO + ". No GR is being created for this order."
		FileWrite(gilogFileNo, lsLogOut)
		Return 0
	End IF
	
End IF


//For Pandora, instead of WH Code, we need the Sub-Inventory Location (Owner_CD)
//  (still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = idsROMain.GetItemString(1, 'wh_code')

//If not received elctronically, don't send a confirmation
//what if it's from the web, with edi_inbound details (for po_no, for example)?
//If idsROMain.GetItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(idsROMain.GetItemNumber(1, 'edi_batch_seq_no')) Then 
	//what if there is a mixture of GIG/BUILDS and non-GIG/BUILDS?
	//Return 0
//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsROMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	// 5/07/2010 - if this is a back order, need to see if the original order was electronic....
	lsInvoice = NoNull(idsROMain.GetItemString(1, 'supp_invoice_no'))
	select ro_no into :lsRONO from receive_master where project_id = 'pandora' and supp_invoice_no = :lsInvoice and wh_code = :lsWH and create_user = 'SIMSFP';
	if lsRONO > '' then
		lsElectronicYN = 'Y'
	end if
end if
//DTS - 3/11/11 - TEMP - testing sending ALL receipts, so setting electronic to 'Y' for all orders...
// now off - lsElectronicYN = 'Y' //TEMP

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

// TAm 2010/03/09 - Filter out Children
//TimA 05/21/14 comment out for emergency build because component_ind was null
//idsROPutaway.Setfilter("Component_Ind <> '*'")
idsROPutaway.Filter()

llRowCount = idsROPutaway.RowCount()

// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

For llRowPos = 1 to llRowCount
	
	/*	// Rolling up to Line/Sku/Supplier/Inv Type/Po_no (Pkg Cd)/Lot/Expiration Date
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind +=  " and upper(supp_code) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Supp_code')) + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	lsFind += " and expiration_date = '" + String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'YYYYMMDD') + "'"
	*/	
	// Rolling up to Line/Sku/PO_no
	// TAM 2009/08/25 We are now saving Pandoras Line no into User Line No.  If user_line_item_no is null use the line_item_no
	// 2010-09-24 - dts - user line is still not being written to put-away.  have to look it up on detail until server code is deployed.
	//If isnull(idsROPutaway.GetItemString(llRowPos, 'user_line_item_no')) or idsROPutaway.GetItemString(llRowPos, 'user_line_item_no') = '' Then
	//	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no'))
	//Else
	//	ls_line_no =  idsROPutaway.GetItemString(llRowPos, 'user_line_item_no')
	//End If

	//**** TimA 05/09/14 Start Pandora issue #36
	//TimA 4/21/14  Re-confirming an inbound order with selected detail rows
	//Store the value of the line for comparison if there are paramaters passeed
	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no' ) )

	//TimA 05/09/14 Pandora Issue #36 Re-confirming an outbound order with selected detail rows
	//New function that will validate the transparm
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )

	//lldetailfindrow = idsDOPick.GetItemNumber(llRowPos,'line_item_no')

	//If there are values in the astransparm but the row does not match the current row skip to the next record.
	//TimA 05/05/14 Pandora issue #36
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if

	//**** TimA 05/09/14 End Pandora issue #36



//	lsParmFound = False
//	cnt = 0
//	i = 1
//	lpos = 0
//	//Cycle through the list of possible detail lines if they exist.  If one matches the line number process that row.
//	If len(astransparm ) > 0 then
//		For cnt = 1 to len(astransparm )
//			lpos = pos(astransparm, ',', i )
//			cnt ++
//			if lpos > 0 then
//				lsLineParm = mid(astransparm, i, lpos - i )
//				If lsLineParm = ls_line_no then //The line matches the parm
//					lsParmFound = True
//					Exit //Exit the For loop and process this row
//				End if
//				i = lpos + 1
//			elseif lpos = 0 and i = 0 then
//				lsLineParm = ''
//				i++
//				cnt --
//			else
//				lsLineParm = mid(astransparm, i )
//				lsParmFound = True
//				//Found the last line paramater and it is the last line of the row.  Set "i" to a value the the above If condition will not fire.
//				i = llen + 1 
//			end if
//		Next
//	End if
//	

	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no' ) )
	lsDetailFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU' ) ) + "'"
	lsDetailFind += " and line_item_no = " + ls_line_no
		
	llDetailFindRow = idsRODetail.Find(lsDetailFind, 1, idsRODetail.RowCount())

	//If there are values in the astransparm but the row does not match the current row skip to the next record.
	//TimA 05/02/14 Pandora issue #36
	//If llDetailFindRow <> Long(lsLineParm ) and lsParmFound = True then 
	//	GOTO skipDetailRow
	//End if
	if llDetailFindRow > 0 then
		If isnull(idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')) or idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no') = '' Then
			ls_line_no =  string(idsRODetail.GetItemNumber(llDetailFindRow, 'line_item_no'))
		Else
			ls_line_no =  idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')
		End If
	end if
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU')) + "'"


// TAM 2009/08/25 We are now saving Pandoras Line no into User Line No
	lsFind += " and trans_line_no = '" + ls_line_no + "'"
	//lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no'))
// TAM 2009/11/13 PoNo is in to_project not pono
//	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'po_no')) + "'"  
	lsFind += " and upper(to_project) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'po_no')) + "'"

//DECOM - Need to add Lot_No, Container_ID, Serial(?)... 

	// TAM 11/13/2009 -  Enterprise is sending Serial numbers but no one else is.
	//They want to roll up the quantities so the find needs to use the enterprise serial number or blank(Blank is loaded below for non enterprise).
// TAM 06/2010  Send for all per Full Cycle Project
//	 if left(lsGroup, 3) = 'ENT' then
			lsFind += " and upper(serial_no) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'serial_no')) + "'"
//	else
//			lsFind += " and upper(serial_no) = ''"
//	end if


	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())
//DECOM - Need to add Lot_No, Container_ID, Serial(?)... 
	//? llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

 //Get Detail Row (do we use the detail row? now done above and used for user line no)
	//lsDetailFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU')) + "'"
	//lsDetailFind += " and line_item_no = " + string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no'))
	//llDetailFindRow = idsroDetail.Find(lsDetailFind,1,idsroDetail.RowCount())

//TEMPO - Check GR for  	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change (and it shouldn't))
		ldOwnerID = idsROPutaway.GetItemNumber(1, 'owner_id')
		if ldOwnerID <> ldOwnerID_Prev then
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;
			ldOwnerID_Prev = ldOwnerID
			
			//need to also look up Group (in UF1) to determine GIG Y/N flag
			//select
		    //   case user_field1
			//     when 'GIG' then 'Y'
			//     else 'N' into :lsGigYN
			
			//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
			// LTK 20111110 Added user_field5 into ls_oracle_integrated
			select user_field1, user_field5 
			into :lsGroup, :ls_oracle_integrated
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCd;
			if left(lsGroup, 3) = 'GIG' then 
				lsGigYN = 'Y'
			else
				lsGigYN = 'N'
			end if
			
			//Jxlim 03/23/2011 Send transaction regardless oracle business unit or not Per Ian requested.
			
			// LTK 20111117	Retrieve the QA and TEST transaction flag.  This was implemented so that the else branch could be 
			//						tested in the code below for the QA and TEST environments.
			//TimA 06/01/12 Always make the lsTransYN = Y
			//We no longer need to check if production or QA database
			///////////////////////////////////////////////////////////////////////////////////////////////////

			//TimA 07/02/12 Turn this back on per Ian.  Uncomment the code that was done on 06/01/12.
			//Pandora is not ready for this until July 20th 2012
			//TimA 09/06/12 Turned this back on again Per Ian.
			
//			String ls_set_trans_flag_flag
//			select code_descript
//			into :ls_set_trans_flag_flag
//			from lookup_table
//			where project_id = 'PANDORA'
//			and code_type = 'FLAG'
//			and code_id = 'HARDCODE_QA_TRANS_Y';
//
//			//TimA 07/07/11 This is a temporary solution to keep a change in the QA environment.
//			//if sqlca.database <> "sims33prd" then //check for production database
//			
//			if sqlca.database <> "sims33prd" and ls_set_trans_flag_flag = 'Y' then //check for production database
				lsTransYN = 'Y'	
//			else
//				if lsElectronicYN = 'Y' then
//					lsTransYN = 'Y'
//				else
//					//check to see if the Manual Order is GIG/BUILDS (if so, still send transaction)
//					//  (need to accommodate any variations of Gig/Builds.  So far, GIG, GIG MRB, PLAT and PLAT_BLDS
//					//TimA 07/15/2011 Added NETOPS
//					//if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS'  or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' or left(lsGroup, 6) = 'NETOPS' then
//					// LTK 20111110 Added the ls_oracle_integrated variable set from customer.UF5 so this check is now data driven.
//					if Upper(Trim(ls_oracle_integrated)) = 'Y' then
//						lsTransYN = 'Y'					
//					else
//						lsTransYN = 'N'
//					end if
//				end if
//			end if
		    ////////////////////////////////////////////////////////////////////////////////////////////////
			 
			// 7/29/09 - at this point, not yet sending transactions for Malaysia (or HongKong?).
			// 9/21/09 - Now sending transactions for Malaysia (or HongKong?).
			//if lsWH = 'PND_MLASIA' then lsTransYN = 'N'
		end if
				
		//Jxlim 03/29/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.		
		//Step 1. Checking Pandora Serial
		lsSku = upper(idsROPutaway.GetItemString(llRowPos, 'SKU'))
		If lsSku <> lsPrevSku Then
					Select 	User_field18 into :lsPndSer
					From		Item_Master 
					where 	project_id = :asProject and
								sku = :lsSku 
					Using SQLCA;
		End If
		lsPrevSku = lsSku
		//Jxim 03/29/2011 End of code

		if lsTransYN = 'Y' then
			llNewRow = idsGR.InsertRow(0)
			// now using a transaction ID Sequence number.  Only grabbing the right-most 15 chars (as that's the limit on the interface)
			idsGR.SetItem(llNewRow, 'trans_id', right(trim(idsROMain.GetItemString(1, 'ro_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			//idsGR.SetItem(llNewRow, 'to_loc', trim(idsROPutaway.GetItemString(1, 'owner_id'))) 
			//don't send 'FROM' Location if trans type is 'PO RECEIPT'
			lsTransType = trim(idsROMain.GetItemString(1, 'user_field7'))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
//			if upper(lsTransType) = 'PO RECEIPT' or upper(lsTransType) = 'EXP PO RECEIPT' then // dts - 4/22 -added EX PO RECEIPT to this clause
//				idsGR.SetItem(llNewRow, 'from_loc', '')
//			else
// TAM 12/08/2009 -  Moved 'From Loc' to User_field6
//				idsGR.SetItem(llNewRow, 'from_loc', upper(trim(idsROMain.GetItemString(1, 'user_field3')))) // 08/09 - added 'upper'
				idsGR.SetItem(llNewRow, 'from_loc', upper(trim(idsROMain.GetItemString(1, 'user_field6')))) // 08/09 - added 'upper'
//			end if
			idsGR.SetItem(llNewRow, 'to_loc', upper(trim(lsOwnerCD))) // 08/09 - added 'upper'
			
			idsGR.SetItem(llNewRow, 'complete_date', idsROMain.GetItemDateTime(1, 'complete_date'))
			idsGR.SetItem(llNewRow, 'sku', idsROPutaway.GetItemString(llRowPos, 'sku'))
//			lsTransType = trim(idsROMain.GetItemString(1, 'user_field7'))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
//?			//don't send 'FROM' Location if trans type is 'PO RECEIPT'
//?			if upper(lsTransType) = 'PO RECEIPT' then //TEMPO! What about EXP PO RECEIPT?
//TAM 2009/07/07  Get the From location fron UF2 if not blank
// TAM 12/08/2009 - 'From Project' no longer found in user_field8 commented out the if loop
//				idsGR.SetItem(llNewRow, 'from_project', trim(idsROMain.GetItemString(1, 'user_field8')))
				lsFromProject = idsroDetail.GetItemString(llDetailFindRow, 'User_Field2')
//				If IsNull(lsFromProject) or trim(lsFromProject) = '' Then
//					idsGR.SetItem(llNewRow, 'from_project', trim(idsROMain.GetItemString(1, 'user_field8')))
//				Else
					idsGR.SetItem(llNewRow, 'from_project', trim(idsroDetail.GetItemString(llDetailFindRow, 'user_field2')))
//				End If
//?			end if
			idsGR.SetItem(llNewRow, 'to_project', trim(idsROPutaway.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
			//idsGR.SetItem(llNewRow, 'trans_type', trim(idsROMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGR.SetItem(llNewRow, 'trans_type', lsTransType)  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGR.SetItem(llNewRow, 'trans_source_no', trim(idsROMain.GetItemString(1, 'supp_invoice_no')))
// TAM 2009/08/25 We are now saving Pandoras Line no into User Line No.  Use it if not null
// TAM 2010/05/12 Use line number from above.  Reversed this if.
//			 If isnull(idsROPutaway.GetItemString(llRowPos, 'user_line_item_no')) or idsROPutaway.GetItemString(llRowPos, 'user_line_item_no') = '' Then
//				idsGR.SetItem(llNewRow, 'trans_line_no', string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no')))
			 If isnull(ls_line_no) or ls_line_no = '' Then
//				idsGR.SetItem(llNewRow, 'trans_line_no', ls_line_no)
				idsGR.SetItem(llNewRow, 'trans_line_no', idsroDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
			Else
//				idsGR.SetItem(llNewRow, 'trans_line_no', idsroDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
				idsGR.SetItem(llNewRow, 'trans_line_no', ls_line_no)
			End If
		// TAM 11/13/2009 -  Only want to send serial numbers for enterprise.
		// TAM 06//2010 -  Now sending for all because of Full Circle.
//			 if left(lsGroup, 3) = 'ENT' then

			//Jxlim 03/23/2011  If SKU is pandora serial;  (PND Serial#) Item_master.User_field18 = 'Y' then send serial number
			//Step 2 Get serial number from Sims
			//If Upper(lsPndSer) = 'Y' Then
			If Trim( idsROPutaway.GetItemString(llRowPos, 'serial_no') ) <> '-' Then	// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line
				idsGR.SetItem(llNewRow, 'serial_no', idsROPutaway.GetItemString(llRowPos, 'serial_no'))
			else
				idsGR.SetItem(llNewRow, 'serial_no', '')
			end if
			//Jlim 03/23/2011 End of code

			//dts 8/10/13 - #608 (LPN)
			idsGR.SetItem(llNewRow, 'Container_ID', idsROPutaway.GetItemString(llRowPos, 'Container_ID'))
			idsGR.SetItem(llNewRow, 'PO_NO2', idsROPutaway.GetItemString(llRowPos, 'PO_NO2'))
			
			idsGR.SetItem(llNewRow, 'quantity', idsROPutaway.GetItemNumber(llRowPos, 'quantity'))

			//TimA 10/09/14 Pandora issue #889
			idsGR.SetItem(llNewRow, 'Shipment_Distribution_No', idsROPutaway.GetItemString(llRowPos, 'Shipment_Distribution_No'))

			// 04/09 - PCONKL - Remove any carriage returns/Line feeds from Remarks - they cause the files to fail in ICC
			lsRemarks = trim(idsROMain.GetItemString(1, 'remark'))
			
			Do While pos(lsRemarks,"~t") > 0 /*tab*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~t"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~n") > 0 /*New line*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~n"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~r") > 0 /*CR*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~r"),1," ")
			Loop
			
			idsGR.SetItem(llNewRow, 'reference', NoPipe(lsRemarks))  //remarks? UF?  -  GailM 2/26/2015 added NoPipe to remove any pipe delimiters
						
			idsGR.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'

			idsGR.SetItem(llNewRow, 'awb_bol_no', idsROMain.GetItemString(1, 'awb_bol_no'))
			idsGR.SetItem(llNewRow, 'cost_center', idsROMain.GetItemString(1, 'user_field12'))
			idsGR.SetItem(llNewRow, 'ship_ref', idsROMain.GetItemString(1, 'ship_ref'))

//DECOM.... NEED TO Turn these on/off for testing; b2b vs DECOM
			idsGR.SetItem(llNewRow, 'container_id', idsROPutaway.GetItemString(llRowPos, 'container_id'))
			idsGR.SetItem(llNewRow, 'lot', idsROPutaway.GetItemString(llRowPos, 'lot_no'))
			
			// ET3: 2012-11-08 Pandora 534 Country of Dispatch
			if upper(trim(lsTransType)) = 'PO RECEIPT' or upper(trim(lsTransType)) = 'EXP PO RECEIPT' then 
				idsGR.SetItem(llNewRow, 'country_of_dispatch', idsROmain.GetItemString(1, 'user_field5'))
			end if

			// TAM: 2016-06 Added Client_Cust_PO_NBR,Vendor_Invoice_Nbr
			//TAM 2016-08-03 - If Client_Cust_PO_NBR = '' then send the Supp_Invoice_No 
			string lsClientCustPONbr
			lsClientCustPONbr =  NoNull(idsROMain.GetItemString(1, 'Client_Cust_PO_NBR'))
			If  lsClientCustPONbr = "" then
				idsGR.SetItem(llNewRow, 'Client_Cust_PO_NBR', lsInvoice) 
			Else
				idsGR.SetItem(llNewRow, 'Client_Cust_PO_NBR', trim(lsClientCustPONbr)) 
			End If
				
			idsGR.SetItem(llNewRow, 'Vendor_Invoice_Nbr', trim(idsROMain.GetItemString(1, 'Vendor_Invoice_Nbr'))) 
	
		end if
	End If
	//TimA 05/09/14 Pandora issue #36 skip detail rows that are not in the transparm string
	skipDetailRow:
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Inbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCount
	//llNewRow = idsOut.insertRow(0)
	lsOutString = idsGR.GetItemString(llRowPos, 'trans_id') + string(llRowPos) + '|'  // ro_no
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'from_loc')) + '|'
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'to_loc')) + '|' //sub-inventory location (stored as owner)
//	lsOutString += String(idsGR.GetItemDateTime(llRowPos, 'complete_date'), 'yyyy-mm-dd hh:mm:ss') + '|'
	ldtTemp = idsGR.GetItemDateTime(llRowPos, 'complete_date')
	ldtTemp = GetPacificTime(lsWH, ldtTemp)
	lsOutString += String(ldtTemp, 'yyyy-mm-dd hh:mm:ss') + '|'
	lsSku = idsGR.GetItemString(llRowPos, 'sku')		//gailm #608
	lsOutString += idsGR.GetItemString(llRowPos, 'sku') + '|'
	// 4-09-09 - now suppressing NA 'FROM' project as well... lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'from_project')) + '|' /* Pandora 'From' Project (from RM.UF8) */	
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsFromProject = upper(idsGR.GetItemString(llRowPos, 'from_project')) /* Pandora 'From' Project (from RM.UF8) */	
	// 07/21/09 - Now back to using Upper... lsFromProject = idsGR.GetItemString(llRowPos, 'from_project') /* Pandora 'From' Project (from RM.UF8) */	
	lsFromProject = upper(idsGR.GetItemString(llRowPos, 'from_project')) /* Pandora 'From' Project (from RM.UF8) */	
	If lsFromProject <> '-' and lsFromProject <> 'NA' and lsFromProject <> 'N/A' Then 
		lsOutString += NoNull(lsFromProject) + '|' 
	Else
		lsOutString += "MAIN|"  // 07/21 - added 'MAIN'
	End If
	// 07/21/09 - Now back to using Upper... lsToProject = idsGR.GetItemString(llRowPos, 'to_project') /* Pandora Project (from po_no) */
	lsToProject = upper(idsGR.GetItemString(llRowPos, 'to_project')) /* Pandora Project (from po_no) */
	If lsToProject <> '-' and lsToProject <> 'NA' and lsToProject <> 'N/A' Then 
		lsOutString += NoNull(lsToProject) + '|' 
	Else
		lsOutString += "MAIN|"  // 07/21 - added 'MAIN'
	End If
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'trans_type')) + '|'  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
	// 10/02/09 lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'trans_source_no')) + '|' //supp_invoice_no
	lsInvoice = NoNull(idsGR.GetItemString(llRowPos, 'trans_source_no'))  //supp_invoice_no
	if right(lsInvoice, 5) = '_DCWH' then //for DC's operating as a WH (with a designated 'Local WH'), WH x-fer from DC to Local WH is created with a '_DCWH' suffix...
		lsInvoice = left(lsInvoice, len(lsInvoice)-5)
	end if
	// GailM - 10/30/2013 #668 - Multiple orders for LPN - striip off -LPNnn from the invoice no
	if Pos(lsInvoice,"-LPN") > 0 then
		lsInvoice = Left(lsInvoice,Pos(lsInvoice,"-LPN") - 1)
	end if
	
	lsOutString += lsInvoice + '|'
	lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'trans_line_no')) + '|'

	//dts 8/10/13 (yes, saturday) #608 - For License Plate project (#608), need to look up serial numbers in Carton_Serial
	// - so splitting the Output string into 4 parts; the part before the Serial# (lsOutString), the Serial # (lsOutStringSerial), the Qty (lsOutStringQty), and the part after the serial# (lsOutString2)
	//   Then we can cycle through the Carton_Serial table (if necessary) and repeat the rest of the line (as it won't change)
	if Trim(NoNull(idsGR.GetItemString(llRowPos, 'serial_no')))  = '-' then
		//dts 8/10/13 lsOutString += '|'
		lsOutStringSerial = '|'
	else
		// dts 8/10/13 lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'serial_no')) + '|'
		lsSerial = NoNull(idsGR.GetItemString(llRowPos, 'serial_no'))
		lsOutStringSerial = lsSerial + '|'
		//may have a Pallet ID in PO_NO2 (for #608 - LPN project)
		lsPallet = NoNull(idsGR.GetItemString(llRowPos, 'PO_NO2'))
	end if
	//dts 8/10/13 - the rest of the output string is now captured in lsOutString 2 (see comment above)
	//8/15/13 lsOutString2 = string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutStringQty = string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString2 = NoNull(idsGR.GetItemString(llRowPos, 'reference')) + '|'
//	lsOutString2 += idsGR.GetItemString(llRowPos, 'gig_yn') //?trailing delimiter? + '|'
	lsOutString2 += NoNull(idsGR.GetItemString(llRowPos, 'awb_bol_no')) + '|'
	lsOutString2 += NoNull(idsGR.GetItemString(llRowPos, 'cost_center')) + '|'
	lsOutString2 += NoNull(idsGR.GetItemString(llRowPos, 'ship_ref')) + '|'
//DECOM.....
//TAM 3/1/2010 - Now not Sending for decom
	// TAM 01/23/2010 -  Only want to send lot#s for DECOM.
//	 if left(lsGroup, 5) = 'DECOM' then
//		lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'lot')) + '|' //Breadboard
//	else
		lsOutString2 += '|' 
//	end if
	lsOutString2 += NoNull(idsGR.GetItemString(llRowPos, 'container_id')) + '|'
/*	POP Location (for DECOM): For outbound, POP Location is the 'FROM Location' for the order that received the Inventory
     - Need to grab ro_no (from any line?), then look up user_field3 
	  !now getting it from delivery_detail.UF6 */
	select min(user_field6) into :lsPopLoc
	from receive_detail
	where ro_no = :asRONO;
	
	lsOutString2 += NoNull(lsPOPLoc)										  					//Original POP Location

	//This is needed because ICC is not done yet.  When they are change the value in the lookup_table to N
	If lsSkipProcess = 'N' then
		//TimA 10/09/14 Pandora issue #889 added Shipment_Distribution_No
		lsOutString2 += '|' 
		lsOutString2 += NoNull ( idsGR.GetItemString(llRowPos, 'Shipment_Distribution_No' ) )
	End if
	
	//Gailm 2/25/2015 - Add Unique Trx ID.  
	if (lsSkipProcess2 = "Y") Then
		int i
		trim(asRoNo)
		IF len(asRoNo) > 1 THEN
			For i = 1 to len(asRoNo)
				if isnumber(mid(asRoNo,i,1)) then
					li_Pos = i
					exit
				 end if
			next
		END IF
		lsUniqueTrxId = 'S' + right(asRoNo, len(asRoNo) - li_Pos + 1) + 'I'
		lsOutString2 += '|' 
		lsOutString2 += lsUniqueTrxId
		
		// TAM: 2016-06 Added Client_Cust_PO_NBR,Vendor_Invoice_Nbr
		lsOutString2 += '|' 
		lsOutString2 += NoNull ( idsGR.GetItemString(llRowPos, 'Client_Cust_PO_NBR' ) )
		lsOutString2 += '|' 
		lsOutString2 += NoNull ( idsGR.GetItemString(llRowPos, 'Vendor_Invoice_Nbr' ) )
		
	End If

	// ET3: 2012-11-08 Pandora 534 Country of Dispatch
	//		  2012-11-15 Commented out pending ICC being ready to handle the change
	//      2013-02-08 Re-enabled
	//      2013-02-25 Re-commenting out
	//lsOutString += NoNull(idsGR.GetItemString(llRowPos, 'country_of_dispatch')) + '|'

//	lsOutString += lsComplete

	//dts 8/10/13 - may need to grab the serial numbers from Carton_Serial (for #608 - License Plate project)
	Select PO_NO2_Controlled_Ind, Container_Tracking_Ind, Serialized_Ind 
	Into :ls_PONO2ControlledInd, :ls_ContainerTrackingInd, :ls_serialized_ind
	From Item_Master
	Where project_id = :asProject and sku = :lsSku and supp_code = 'PANDORA';	
	
	// Gailm - 12/1/2013 - Pallet Rollup from carton - leave parameters as carton but call for pallet information
	// Gailm - 12/12/2013 - Added serialized ind to check for LPN GPN
	If ls_serialized_ind = 'B' and ls_PONO2ControlledInd = 'Y' and ls_ContainerTrackingInd = 'Y' Then
		//lsCartonId = idsDOSerial.GetItemString(llRowPos, 'serial_no')
		//The Carton (maybe Pallet in future) will be in the Serial field in put-away
		lsCartonId = lsSerial
		//look up serial numbers in Carton_Serial...Leave out CartonID because of Pallet Rollup
		llSrow = idsCartonSerial.Retrieve(asProject, lsPallet, lsSku)
		llCartonSerialRowCount = idsCartonSerial.RowCount()
		//assuming there will always be Carton_Serial records for LPN SKUs...
		For llCartonRow = 1 to llCartonSerialRowCount
			llNewRow = idsOut.insertRow(0)
			lsSerial = idsCartonSerial.GetItemString(llCartonRow, 'serial_no')
			lsOutStringSerial = lsSerial + '|'
			idsOut.SetItem(llNewRow, 'Project_id', asProject)
			idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
			//idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
			//now stringing the 3 parts of output string (part before serial, the serial, the Qty, part after serial)
			//8/21 - adding delimiter after qty (1) idsOut.SetItem(llNewRow, 'batch_data', lsOutString + lsOutStringSerial + '1' + lsOutString2)
			idsOut.SetItem(llNewRow, 'batch_data', lsOutString + lsOutStringSerial + '1|' + lsOutString2)
			idsOut.SetItem(llNewRow, 'file_name', 'GRR' + String(ldBatchSeq, '000000') + '.DAT') 
		next
	else
		//not LPN SKU so serial field is actually the serial #
		llNewRow = idsOut.insertRow(0)	
		idsOut.SetItem(llNewRow, 'Project_id', asProject)
		idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		//idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		//now stringing the 3 parts of output string (part before serial, the serial, the Qty, part after serial)
		idsOut.SetItem(llNewRow, 'batch_data', lsOutString + lsOutStringSerial + lsOutStringQty + lsOutString2)
		idsOut.SetItem(llNewRow, 'file_name', 'GRR' + String(ldBatchSeq, '000000') + '.DAT') 
	end if 
	
next /*next output record */


//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_oc_rose (string asproject, string astono, string astransparm);//Jxlim 03/24/2011 This function create GCR file prefiex. Owner change (OC) confirmation. 4C1 - SOC Ack
/*Prepare a Owner Change Confirmation Transaction for PANDORA for the Transfer that was just confirmed
		
			*/

//Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow
//				
//String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType
//String		lsWHName, lsWHAddr1, lsWHAddr2, lsWHAddr3, lsWHAddr4, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lstempdate
//Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev
//Integer		liRC
//datetime ldtTemp, ldtToday
//decimal	ldTransID



// uf_process_dboh
//Process the SIKA Daily Balance on Hand Confirmation File
//(modeled after Maquet, Oct '07)

Datastore	ldsOut, ldsOC
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath,  lsownercd, lsnewownercd
				
String lsSaveSku,lsSavePoNo, lsSaveNewPoNo, lsSaveLineNumber, lsPndser
string lsCurrentSku, lsCurrentPoNo, lsCurrentNewPoNo, lsCurrentLineNumber, lsWriteLineNumber

Decimal		ldBatchSeq, ldownerid, ldnewownerid
Integer		liRC
DateTime	ldtToday, ldtTemp

//TimA 05/05/14 Pandora Issue #36 Re-confirming an Owner order with selected detail rows
Long lldetailfindrow
String lsLineParm, ls_line_no
Boolean lbParmFound
String ls_order_no

ldtToday = DateTime(Today(), Now())

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)



//Create the Owner Change datastore
ldsOC = Create Datastore

// TAM 06/2010 - Added Serial Numbers to the select
// dts - 2/24/11 - removed line_item from the group by and we're now grabbing the min(line_item) for the rest of the group-by fields
// (new SOC allocation functionality is creating new line_item #s when the 'from' location is split into more than one content record)
/* dts - 3/10/11 - now retaining the line # when the SOC line is split, so going back to grouping by line #
    - ! so that lines from pandora that differ only by line number, will retain their original line # (instead of being assigned the 'min' line #) */
//sql_syntax = " SELECT Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU, Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail. line_item_no, "
// - 3/10 sql_syntax = " SELECT Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU, Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, min(Transfer_Detail.line_item_no) line_item_no, "
// LTK 20110429 Pandora #205 - SOC Multiline Fix - Changed line_item_no to user_line_item_no in select below (excluding the join clause) because this is the field that the customer sent to SIMS and is expecting back.
sql_syntax = " SELECT Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU, Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail.user_line_item_no, "
sql_syntax += " Alternate_Serial_Capture.Serial_no_Child, SUM(Transfer_Detail.Quantity) as Total_Qty "  
sql_syntax += " FROM Transfer_Detail "
sql_syntax += " LEFT OUTER JOIN Alternate_Serial_Capture ON Transfer_Detail.TO_No = Alternate_Serial_Capture.TO_NO AND"
sql_syntax += " Transfer_Detail.Line_Item_No = Alternate_Serial_Capture.to_line_item_No AND" 
sql_syntax += " Transfer_Detail.SKU = Alternate_Serial_Capture.SKU_Child AND" 
sql_syntax += " Transfer_Detail.Supp_Code = Alternate_Serial_Capture.Supp_Code_Child,"   
sql_syntax += " Transfer_Master"
sql_syntax += " WHERE ( Transfer_Detail.TO_No = Transfer_Master.TO_No ) and ( ( Transfer_Master.TO_No = '" + asTONO + "' ))"
sql_syntax += " GROUP BY Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU," 
//sql_syntax += " Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail.Line_item_no, Alternate_Serial_Capture.Serial_no_Child ; "  
//- 3/10 sql_syntax += " Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Alternate_Serial_Capture.Serial_no_Child "  
sql_syntax += " Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail.User_Line_item_no, Alternate_Serial_Capture.Serial_no_Child"
// dts - 2/25/11 - sorting this so that we can set line_item_no to the original line (if they are split by location)
//?  - will there ever be two different lines with the same new/old owner, new/old project, and sku?
sql_syntax += " order by Owner_ID, New_Owner_ID, sku, PO_No, New_PO_No, user_line_item_no;"  

//sql_syntax = " SELECT D_Warehouse, Complete_Date, User_Field3, Owner_ID, New_Owner_ID, SKU, PO_No, New_PO_No, line_item_no, SUM(Quantity) as Total_Qty "  
//sql_syntax += " FROM Transfer_Master, Transfer_Detail "
//sql_syntax += " WHERE ( Transfer_Detail.TO_No = Transfer_Master.TO_No ) and ( ( Transfer_Master.TO_No = '" + asTONO + "' ))"
//sql_syntax += " GROUP BY D_Warehouse, Complete_Date, User_Field3, Owner_ID, New_Owner_ID, SKU, PO_No, New_PO_No, line_item_no; "  

ldsOC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Owner change Transaction.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsOC.SetTransObject(SQLCA)

// LTK 20110623 	Pandora #245 Create datastore to aggregate quantities for user line items.
//						The result set above could not be used because of the serial number grouping.
String ls_quantities_sql, ls_errors
Long ll_quantity_rows, ll_found
DataStore lds_quantites
lds_quantites = create DataStore

ls_quantities_sql   =	" SELECT user_line_item_no, SUM(quantity) as quantity_sum "
ls_quantities_sql +=	" FROM transfer_detail "
ls_quantities_sql +=	" WHERE to_no = '" + asTONO + "' "
ls_quantities_sql +=	" GROUP BY user_line_item_no; "

lds_quantites.Create(SQLCA.SyntaxFromSQL(ls_quantities_sql,"", ls_errors))

if Len(ls_errors) > 0 then
   lsLogOut = "        *** Unable to create quantities datastore for PANDORA Owner change Transaction.~r~r" + ls_errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
end if

lds_quantites.SetTransObject(SQLCA)
ll_quantity_rows = lds_quantites.Retrieve()
if ll_quantity_rows <= 0 then
   lsLogOut = "        *** Unable to retrieve quantities datastore for PANDORA Owner change Transaction.~r~r" 
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
end if
// Pandora #245  end of DataStore creation

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: PANDORA Owner Change Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//lsProject = ProfileString(asInifile, 'SIKA', "project", "")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no('PANDORA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrieve next available sequence number for PANDORA Owner Change confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrieve the OC Data
lsLogout = 'Retrieving Owner Change.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsOC.Retrieve(lsProject)
//ldsOC.SetSort("wh_code A, sku A")
//ldsOC.Sort()

// LTK 20160106  Skip confirmation if order number begins with RECON per Dave
if ldsOC.RowCount() > 0 then
	ls_order_no = Upper( Trim( ldsOC.GetItemString(1, 'user_field3') ))
	if Left( ls_order_no, 5 ) = 'RECON' then
		lsLogOut = "   ***Order begins with RECON, skip the Owner Change confirmation."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		Return 0
	end if
end if

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '|'
lsLogOut = 'Processing Owner Change Confirmation.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

		ldOwnerID = ldsOC.GetItemNumber(1, 'owner_id')
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;

		ldNewOwnerID = ldsOC.GetItemNumber(1, 'new_owner_id')
			select owner_cd into :lsNewOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldNewOwnerID;


	llNewRow = ldsOut.InsertRow(0)
	lsOutString = 'OC|' /*rec type = SOC Header */
	lsOutString += "|"
	lsOutString += NoNull(lsownercd) + "|"
	lsOutString += NoNull(lsNewOwnerCd) + "|"
	lsOutString += NoNull(ldsOC.GetItemString(1, 'user_field3')) + "|"

//TAM 2009/07/18 Converted  complete date to Pacific Time
	//lsOutString += string(ldsOC.GetItemDateTime(1, 'complete_date'), 'yyyymmddhhmmss') 
	ldtTemp = ldsOC.GetItemDateTime(1, 'complete_date')
	ldtTemp = GetPacificTime(ldsOC.GetItemString(1, 'D_Warehouse'), ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmddhhmmss')
	if Upper(Trim(f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','',''))) = 'Y' then		// LTK 20150515  Added Unique ID to header record
		lsOutString += "|" + "S" + in_string_util.of_parse_numeric_sys_no( asTONO ) + "SOC"
	end if

	ldsOut.SetItem(llNewRow, 'Project_id', asProject)
	ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
	ldsOut.SetItem(llNewRow, 'file_name', lsFileName)

For llRowPos = 1 to llRowCount

	//**** TimA 05/09/14 Start Pandora issue #36
	//TimA 4/21/14  Re-confirming an SOC order with selected detail rows
	//Store the value of the line for comparison if there are paramaters passeed
	ls_line_no =  string ( ldsOC.GetItemNumber ( llRowPos,'user_line_item_no' ) )

	//TimA 05/09/14 Pandora Issue #36 Re-confirming an SOC order with selected detail rows
	//New function that will validate the transparm
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )

	//lldetailfindrow = idsDOPick.GetItemNumber(llRowPos,'line_item_no')

	//If there are values in the astransparm but the row does not match the current row skip to the next record.
	//TimA 05/05/14 Pandora issue #36
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if

	//**** TimA 05/09/14 End Pandora issue #36



//	lsParmFound = False
//	cnt = 0
//	i = 1
//	lpos = 0
//	//Cycle through the list of possible detail lines if they exist.  If one matches the line number process that row.
//	If len(astransparm ) > 0 then
//		For cnt = 1 to len(astransparm )
//			lpos = pos(astransparm, ',', i )
//			cnt ++
//			if lpos > 0 then
//				lsLineParm = mid(astransparm, i, lpos - i )
//				If lsLineParm = ls_line_no then //The line matches the parm
//					lsParmFound = True
//					Exit //Exit the For loop and process this row
//				End if
//				i = lpos + 1
//			elseif lpos = 0 and i = 0 then
//				lsLineParm = ''
//				i++
//				cnt --
//			else
//				lsLineParm = mid(astransparm, i )
//				lsParmFound = True
//				//Found the last line paramater and it is the last line of the row.  Set "i" to a value the the above If condition will not fire.
//				//i = llen + 1 
//			end if
//		Next
//	End if
//
//	lldetailfindrow = ldsOC.GetItemNumber(llRowPos,'user_line_item_no')
//	//If there are values in the astransparm but the row does not match the current row skip to the next record.
//	//TimA 05/05/14 Pandora issue #36
//	If lldetailfindrow <> Long(lsLineParm ) and lsParmFound = True then 
//		GOTO skipDetailRow
//	End if

	
	  //Step 1. Checking Pandora Serial
	  //Jxlim 03/29/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.      
				lsCurrentSku = Upper(ldsOC.GetItemString(llRowPos, 'sku'))    
				If lsCurrentSku <> lsSaveSku Then
					Select 	User_field18 into :lsPndSer
					From		Item_Master 
					where 	project_id = :asProject and
								sku = :lsCurrentSku 
					Using SQLCA;				
				End If
	//Jxlim 03/29/2011

	//TAM 07/12/2010 - Added a new subline type to send the serial numbers
//	If	(lsSaveSku <> ldsOC.GetItemString(llRowPos, 'sku') and lsSavePoNo <> ldsOC.GetItemString(llRowPos, 'po_no') and lsSaveNewPoNo <> ldsOC.GetItemString(llRowPos, 'new_po_no') and	lsSaveLineNumber <> string(ldsOC.GetItemNumber(llRowPos,'line_item_no'))) then
	lsCurrentSku = ldsOC.GetItemString(llRowPos, 'sku')
	lsCurrentPoNo = ldsOC.GetItemString(llRowPos, 'po_no')
	lsCurrentNewPoNo = ldsOC.GetItemString(llRowPos, 'new_po_no')
	lsCurrentLineNumber = string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no'))

	//If	(lsSaveSku <> ldsOC.GetItemString(llRowPos, 'sku') or lsSavePoNo <> ldsOC.GetItemString(llRowPos, 'po_no') or lsSaveNewPoNo <> ldsOC.GetItemString(llRowPos, 'new_po_no') or lsSaveLineNumber <> string(ldsOC.GetItemNumber(llRowPos,'line_item_no'))) then
	If	lsSaveSku <> lsCurrentSKU or lsSavePoNo <> lsCurrentPoNo or lsSaveNewPoNo <> lsCurrentNewPoNo or lsSaveLineNumber <> lsCurrentLineNumber then
		/*dts 2/25/11
		   need to protect against SOC rows that were split by location. If they were serialized, then the wrong line_item_no will be on the transaction
		   - sorting by owner, sku, project, line. if only the line changes, then write the previous line on the file.
		*/
		//lsSaveSku = ldsOC.GetItemString(llRowPos, 'sku')
		//lsSavePoNo = ldsOC.GetItemString(llRowPos, 'po_no')
		//lsSaveNewPoNo = ldsOC.GetItemString(llRowPos, 'new_po_no')
		//lsSaveLineNumber = string(ldsOC.GetItemNumber(llRowPos,'line_item_no'))
//3-10		If	lsSaveSku = lsCurrentSKU and lsSavePoNo = lsCurrentPoNo and lsSaveNewPoNo = lsCurrentNewPoNo then
//3-10			//line number is all that changed so keep the current one...
//3-10		else
//3-10			//something changed besides line number so must be a new detail line
//3-10			lsWriteLineNumber = lsCurrentLineNumber
//3-10		end if
		lsSaveSku = lsCurrentSKU
		lsSavePoNo = lsCurrentPoNo
		lsSaveNewPoNo = lsCurrentNewPoNo
		lsSaveLineNumber = lsCurrentLineNumber
	
		llNewRow = ldsOut.InsertRow(0)
		lsOutString = 'OD|' /*rec type = SOC detail line */
		lsOutString += NoNull(lsSaveSKU) + "|"
		lsOutString += "|"
		lsOutString += "|"
		lsOutString += NoNull(lsSavePoNo) + "|"  /*Project Number */
		lsOutString += NoNull(lsSaveNewPoNo)  + "|" /*New Project Number */
//3-10		lsOutString += NoNull(lsWriteLineNumber) + "|" /* LINE NUMBER */
		lsOutString += NoNull(lsSaveLineNumber) + "|" /* LINE NUMBER */

		// LTK 20110623  Pandora #245 Set quantity to correct value for serialized sku's
		//lsOutString += NoNull(string(ldsOC.GetItemNumber(llRowPos, 'total_qty'))) + "|"
		ll_found = lds_quantites.Find("user_line_item_no = " + lsCurrentLineNumber, 1, ll_quantity_rows)
		if ll_found <= 0 then
			lsLogOut = "   ***Unable to find user line item quantities in aggregation datastore for PANDORA Owner Change confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		else
			lsOutString += NoNull(string(lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))) + "|"
		end if
		// LTK 20110623  Pandora #245 end of code

	// TAM 06/2010 Added Serial Number
		lsOutString += "|"  //From Serial Number = To Serial Number
			
		ldsOut.SetItem(llNewRow, 'Project_id', asProject)
		ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
		ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
		ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
		lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
		ldsOut.SetItem(llNewRow, 'file_name', lsFileName)	

			
			//TAM 07/12/2010 - Added a new subline type to send the serial numbers
			If Not IsNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child')) and  ldsOC.GetItemString(llRowPos, 'Serial_no_Child') <> '' Then
				//Jxlim 03/29/2011 Sending serial number when GPN is Pandora serial (Item_Master.User_field18)
				//Step 2 Get serial number from Sims, step 3 form to the output file
					 //If Upper(lsPndSer) = 'Y' Then		
					 	if Trim( ldsOC.GetItemString(llRowPos, 'Serial_no_Child') ) <> '-' then	// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line
							llNewRow = ldsOut.InsertRow(0)
							lsOutString = 'OS|' /*rec type = serial number */		
							lsOutString += NoNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child'))			
							ldsOut.SetItem(llNewRow, 'Project_id', asProject)
							ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
							ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
							ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
							lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
							ldsOut.SetItem(llNewRow, 'file_name', lsFileName)				
						End if
						//Jxlim 03/29/2011 End of code	
			End If
			
	Else  // TAM New Serial Row subline
		//Jxlim 03/29/2011 Sending serial number when GPN is Pandora serial (Item_Master.User_field18)
		//Step 2 Get serial number from Sims, Step 3. Form the output file
		// If  Upper(lsPndSer) = 'Y' Then
	 	if Trim( ldsOC.GetItemString(llRowPos, 'Serial_no_Child') ) <> '-' then	// LTK 20160129 Pandora #1002 - commented out line above and replaced with this line
			llNewRow = ldsOut.InsertRow(0)		
			lsOutString = 'OS|' /*rec type = balance on Hand Confirmation*/	
			lsOutString += NoNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child'))  //serial
			ldsOut.SetItem(llNewRow, 'Project_id', asProject)
			ldsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
			ldsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
			ldsOut.SetItem(llNewRow, 'batch_data', lsOutString)
			lsFileName = 'GCR' + String(ldBatchSeq, '00000') + '.DAT'
			ldsOut.SetItem(llNewRow, 'file_name', lsFileName)
		End If
		//Jxlim 03/29/2011 End of code.
	End If	

	//TimA 05/05/14 Pandora issue #36.  Skip the rows that were no choosen for the reconfirm.
	skipDetailRow:
Next /*next output record */

	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut, "PANDORA")


Return 0
end function

public function boolean uf_is_country_eu_to_eu (string asproject, string as_from_country, string as_to_country);boolean lb_return = FALSE
boolean lb_exception_found = FALSE
integer i
long    ll_row, ll_exception_rowcount
string  ls_sku, ls_find, ls_uf8, ls_uf9, ls_uf10, ls_msg
string  ls_sql_syntax, ERRORS

datastore lds_countries, lds_exceptions

lds_countries = create datastore

ls_sql_syntax = "SELECT EU_country_Ind, Designating_code, ISO_Country_Cd, Country_Name from country " + &
					"WHERE designating_code in ('" + as_to_country + "', '" + as_from_country + "');"

lds_countries.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax,"", ERRORS))
if Len(ERRORS) > 0 then
else
	if lds_countries.SetTransObject(SQLCA) = 1 then
		if lds_countries.retrieve() = 2 then			
			if Upper(Trim(lds_countries.getItemString(1, "EU_country_Ind"))) = 'Y' and Upper(Trim(lds_countries.getItemString(2, "EU_country_Ind"))) = 'Y' then
				lb_return = TRUE
		
			end if	// EU countries
			
		end if	// Retrieve

	end if	// SetTransObject
	
end if  // ERRORs



return lb_return 

end function

public function integer uf_gi_rose (string asproject, string asdono, string astransparm, datetime dtrecordcreatedate);//Jxlim 03/23/2011 This function create GIR file(3B13)
//Prepare a Goods Issue Transaction for PANDORA for the order that was just confirmed
/*  - Pandora has Material Transfers and the Inventory Transaction Confirmation uses the same format
       for both Inbound and Outbound so sharing new datastore; d_pandora_inv_trans 
	
	  - Now sending confirmations only for Electronic orders and manual orders for GIG-owned and BUILDS-owned inventory
	     - Adding HWOPS to the interface eligibility
			
			*/
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow, llSerialCount, llQuantity
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType, lsFromLoc
String		lsWHName, lsWHAddr1, lsWHAddr2, lsWHAddr3, lsWHAddr4, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lstempdate, ls_PacificTime, lsInvoice, lsToProjectDetail 
string		lsRONO, lsPOPLoc, lsSKU, lsDONO, lsChildLine, lsCarrierName
Decimal	ldBatchSeq, ldOwnerID, ldOwnerID_Prev
Integer		liRC, liLine, li_Pos
datetime 	ldtTemp, ldtToday
decimal		ldTransID
String 		lsPndSer, lsPrevSku, lsSkuFilter
//for issue 455...
boolean	lbNeedGIM, lbSkipGIR 
string		lsCust,lsThisCarton, lsLastCarton
Boolean		lbShipFromCityBlock, lbShipToCityBlock			//GailM - 7/19/2014 - Flag to determine if CityBlock orders

decimal 	ldWgt, ldWgtNet
Long llCtnCount, ll_return
String lsSerialNo, lsCartonId, lsOrdType

String ls_Serialized_Ind,ls_PONO2ControlledInd, ls_ContainerTrackingInd,lsSupplier, lsPallet
Long llCartonSerialRowCount, llCartonRow, llSerialRow,  llSrow, llSkuRow
//Boolean lb_LPNTracked
string lsCOO
boolean lbLPN, lbNonLPN				
String lsPONO2, lsContainerID		//GailM 3/31/2012 - Restructure SN1 rows into LC1
//TimA 03/18/13
String ls_Vics_Bol_no,ls_AWB_BOL_No, ls_Carrier_Pro_no

//TimA 4/24/14 Pandora Issue #36 Re-confirming an outbound order with selected detail rows
Long llDetailFindRow
String lsLineParm,ls_line_no
Boolean lbParmFound

String lsUniqueTrxId, lsSkipProcess2		// GailM 2/26/2015 - Add Unique Trx ID to Header section		
String lsUseCustType

//TimA 10/15/14 Pandora issue #903
String ls_to_country, ls_from_country,lsDM_Country, lsCustCountry,ls_CodeDesc, lsTime
DateTime  ldt_EndRetrieve
Int liMin
ldtToday = DateTime(Today(), Now())

String lsCustType
//TimA 06/15/15 
Datastore lsLookupTable
Long llListContainersRowCount
Long llListRowPos
String lsParmSearch
String lsCommodity

// GailM 2/ 25/2015 Add Unique Trx ID - Turn on with functionality manager - use lsSkipProcess2
lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

// TimA 05/06/15  Turn on with functionality manager - Skip Adding the CustType for WMS  to the end of the file
lsUseCustType = f_functionality_manager(asProject,'FLAG','SWEEPER','CUSTTYPE','','')

If Not isvalid(idsOut) Then
	idsOut = Create u_ds_datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

// GailM - 1/17/2014 - Collect SN out records before detail so LC1 records have access to SN data
If Not isvalid(idsSNOut) Then
	idsSNOut = Create u_ds_datastore
	idsSNOut.Dataobject = 'd_edi_generic_out'
	lirc = idsSNOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGI) Then
	idsGI = Create u_ds_datastore
	idsGI.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create u_ds_datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(lsLookupTable) Then
	 lsLookupTable = Create u_ds_datastore
	 lsLookupTable.dataobject = 'd_lookup_table_search'
	 lsLookupTable.SetTransObject(SQLCA)
End If

//TimA 12/20/13 Moved this down a few lines.  We need to see if we are dealing with LPN SKU's first
//If Not isvalid(idsDoPick) Then
//	idsDoPick = Create Datastore
//	idsDoPick.Dataobject = 'd_do_Picking_pandora'
//	idsDoPick.SetTransObject(SQLCA)
//End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create u_ds_datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create u_ds_datastore
	//idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'		//Moved down to use multiple dw
	//idsDoSerial.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create u_ds_datastore
	idsDoPack.Dataobject = 'd_do_packing_track_id_pandora'
	idsDoPack.SetTransObject(SQLCA)
End If

//TimA 08/02/13 LPN Project
If Not isvalid(idsCartonSerial) Then
	idsCartonSerial = Create u_ds_datastore
	idsCartonSerial.Dataobject = 'd_carton_serial_pandora'
	idsCartonSerial.SetTransObject(SQLCA)
End If



idsOut.Reset()
idsSNOut.Reset()
idsGI.Reset()

lsLogOut = "      Creating Inventory Transaction (GI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master, Detail and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

w_main.SetMicroHelp("Processing Purchase Order (ROSE)")

//For Pandora, need to know the order type to determine whether to update carton_serial do_no and status_cd
lsOrdType = NoNull(idsDOMain.GetItemString(1, 'ord_type'))

//For Pandora, still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = idsDOMain.GetItemString(1, 'wh_code')
Select wh_Name, address_1, address_2, city, state, zip, country 
Into :lsWHName, :lsWHAddr1, :lsWHADdr2, :lsWHCity, :lsWHState, :lsWHZip, :lsWHCountry
From Warehouse
Where wh_code = :lsWH;

//TimA 10/15/14 Pandora issue #903 Delay the GIR file by 15 Min or whatever the value is in the lookup table
Select DM.country DM_Country, C.Country C_Country  INTO 	:lsDM_Country, :lsCustCountry
From delivery_master DM, Customer C 
Where DM.project_id = 'Pandora' and Do_no = :asDoNo And DM.project_id = C.Project_ID And DM.User_Field2 = C.Cust_Code;	

ls_to_country   = lsDM_Country
ls_from_country = lsCustCountry
Int DateDiffInMinutes, TimeDiffInMinutes, ElapsedTimeInMinutes

if  uf_is_country_eu_to_eu(asproject,ls_from_country, ls_to_country) then //Compare Countries and if bot are EU to EU then proceed
	select code_descript
	into :ls_CodeDesc  //This should be a value of minutes to delay the processing
	from lookup_table
	where project_id = 'PANDORA'
	and code_type = 'GIR_Delay'
	and code_ID = 'Minutes'
	and User_Updateable_Ind = 'Y';
	
	select TOP 1 current_timestamp into :ldt_EndRetrieve from sysobjects using sqlca; //get Server time instead local machine time
	
	lsLogOut = "      Creating Inventory Transaction (GI) For DO_NO: " + asDONO+" current Server Time is: " + string(ldt_EndRetrieve)
	FileWrite(gilogFileNo,lsLogOut)
	
	If ls_CodeDesc <> '' and Not IsNull ( ls_CodeDesc ) then
		//ldt_EndRetrieve = DateTime(Today( ),Now( ) ) //Remeber if running this on a local machine this is your computer time not GMT
		//Use the below datetime when running on local machine.  It adds 7 hours to the local time.  Adjust for DTS if needed.
		//ldt_EndRetrieve = DateTime(Today( ),RelativeTime(Now( ),25200 ) ) //Remeber if running this on a local machine this is your computer time not GMT
		DateDiffInMinutes = DaysAfter ( Date(dtrecordcreatedate), Date(ldt_EndRetrieve)  ) * 24 * 60
		TimeDiffInMinutes = SecondsAfter ( Time(dtrecordcreatedate), Time (ldt_EndRetrieve ) ) / 60
		ElapsedTimeInMinutes = DateDiffInMinutes + TimeDiffInMinutes
		lsLogOut = "      Waiting to process Inventory Transaction (GI) For DO_NO: " + asDONO + '  ' + String(ElapsedTimeInMinutes) + ' Minutes have passed ' +  ' System DateTime is: ' + String(ldt_EndRetrieve) + '  Record Create Date is: ' + String(dtrecordcreatedate)
		FileWrite(gilogFileNo,lsLogOut)

		If ElapsedTimeInMinutes < Long ( ls_CodeDesc ) then //Compair the minutes with the theashold found in the lookup table.
			lsLogOut = "      Skipping Inventory Transaction (GI) For DO_NO: " + asDONO 
			FileWrite(gilogFileNo,lsLogOut)
			w_main.SetMicroHelp("Ready")
			Return 2
		End if
	end if
End if
//End Pandora issue #903

//If not received elctronically, don't send a confirmation
//what if it's from the web, with edi_inbound details (for po_no, for example)?
//If idsDOMain.GetItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetItemNumber(1, 'edi_batch_seq_no')) Then 
	//check to see if the manual order is GIG/Builds/Upgrades or not....
	//Return 0
//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	// 5/07/2010 - need to see if this is a back order and if the original order was electronic....
	lsInvoice = idsDOMain.GetItemString(1, 'Invoice_no')
	select do_no into :lsDONO from Delivery_master where project_id = 'pandora' and invoice_no = :lsInvoice and wh_code = :lsWH and create_user = 'SIMSFP';
	if lsDONO > '' then
		lsElectronicYN = 'Y'
	end if
end if

// 7/19/12 - Issue 455 - dts - now creating 'GIM*' file to be sent to MIM if the Ship-to is MIM (governed by ship-to Customer.UF1 = 'MIM')
//TimA 05/12/15 added lsCustType
lsCust = upper(trim(idsDOMain.GetItemString(1, 'cust_code')))
select user_field1,Customer_Type into :lsGroup, :lsCustType
from customer
where project_id = :asProject and cust_code = :lsCust;

if lsGroup = 'MIM' Then
	//lbNeedGIM = True			// LTK 20150313  Commented out per Dave's email
end if

// GailM - 7/19/2014 - If customer group then set flag to true
if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
// GailM - 7/31/2014 - Added EOS and EOS DRIVE 
//	if lsGroup = 'CB' or lsGroup = 'CB DRIVES' or lsGroup = 'CITYBLOCK' or lsGroup = 'CB CUST' or lsGroup = 'EOS' or lsGroup = 'EOS DRIVES' Then
	lbShipToCityBlock = true
End if

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Group = " + lsGroup)

// 08/09 - PCONKL - We want to suppress the GI for MIM owned Inventory - Based on Customer UF1(Group) = "S-OWND-MIM"
lsFromLoc = idsDoMain.GetITemString(1,'User_field2')
If Not isnull(lsFromLoc) Then
	
	select user_field1 into :lsGroup
	from customer
	where project_id = :asProject and cust_code = :lsFromLoc;
	
	If lsGroup > '' and not isnull(lsGroup) and Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GI Suppressed for MIM Owned Inventory transaction For DO_NO: " + asDONO + ". No GI is being created for this order."
		FileWrite(gilogFileNo,lsLogOut)
		if lbNeedGIM then //if we are creating a GIM file, then don't exit, but suppress the creation of the GIR file (normal GI that becomes a 3B13 to Pandora)
			lbSkipGIR = true
		else
			Return 0
		end if
	End IF
	
	// GailM - 7/19/2014 - If customer group then set flag to true
	if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
	// GailM - 7/31/2014 - Added EOS and EOS DRIVE 
	//if lsGroup = 'CB' or lsGroup = 'CB DRIVES' or lsGroup = 'CITYBLOCK' or lsGroup = 'CB CUST' or lsGroup = 'EOS' or lsGroup = 'EOS DRIVES' Then
		lbShipFromCityBlock = true
	End if
	
End IF

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - Group: " + lsGroup)

idsDoDetail.Retrieve(asDoNo)

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()))

//TimA 12/20/13 Look at the first SKU (and only should be one SKU) for LPN type.
If idsDoDetail.RowCount() > 0 then
	lsSku = upper(idsDoDetail.GetItemString(idsDoDetail.GetRow() ,'SKU'))	
	
	Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
	Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
	From		Item_Master 
	where	project_id = :asProject and
				sku = :lsSku 
	Using SQLCA;
End If

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()) + ' - Checked Item Master')

//TimA 12/20/13 If LPN use a different DataStore
//GailM 01/30/14 Code tightened up and traces entered.  Decisions were not  being made properly
If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
Else
	destroy idsDoPick
	idsDoPick = Create Datastore
End if

	if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
		idsDoPick.Dataobject = 'd_do_Picking_pandora'
		idsDoSerial.Dataobject = 'd_gi_outbound_serial_lpn'
		lbLPN = True
		lbNonLPN = false
		f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN flag set true, nonLPN set false for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Carton Level Query','',lsInvoice)		
		 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	elseif ls_Serialized_Ind = 'B' and (ls_ContainerTrackingInd = 'N' or ls_PONO2ControlledInd = 'N') then	//Pandora serialized but not LPN
		lbLPN = False
		lbNonLPN = true
		idsDoPick.Dataobject = 'd_do_Picking'			
		idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
		f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN flag set false, nonLPN set true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
		 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	else 
		lbLPN = False
		lbNonLPN = False

		idsDoPick.Dataobject = 'd_do_Picking'			
		idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
		// GailM - 8/28/2014 - Issue 883 - Check for containerIDs in Serial# tab for DejaVu orders
		idsDoSerial.SetTransObject(SQLCA)
		idsDoSerial.Retrieve(asDoNo)
		If idsDOSerial.RowCount() > 0 Then		//Non-serialized
			If idsDOSerial.GetItemString(1,'serial_no') = idsDOSerial.GetItemString(1,'carton_no') Then
				ibDejaVu = True
			End If
			idsDOSerial.Reset()
		End If
		
		
		f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN  false and nonLPN flags set to true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
		 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end if

idsDoSerial.SetTransObject(SQLCA)

idsDoPick.SetTransObject(SQLCA)	

	w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Start Retrive PickList: " + String(f_getLocalWorldTime('PND_MTV')))

idsDoPick.Retrieve(asDoNo)

//idsDoSerial.Retrieve(asDoNo)   GailM - 3/31/2014 - Moved into SN process

	w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Picklist retrievedil - RowCount " + String(idsDoPick.RowCount()) + ' - Completed: '+ String(f_getLocalWorldTime('PND_MTV')))
	
idsDoPack.Retrieve(asDoNo)

// TAm 2010/06/09 - Filter out Children
idsDOPick.Setfilter("Component_Ind <> '*'")
idsDOPick.Filter()



//For each sku/line Item/ in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc )

llRowCount = idsDOPick.RowCount()

// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

/* START POPULATE GI DATASTORE SECTION ************************************************************************/		
lsLogOut = "             Populate GI datastore at: '"  + String(f_getLocalWorldTime('PND_MTV'))
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	w_main.SetMicroHelp(" 1 - GI Row: " + string(llRowPos))
		
	//Refresh screen willl looping
	if llRowPos = 10000 or llRowPos = 20000 or llRowPos = 30000 or llRowPos = 40000 then
		yield()
	End if

	//**** TimA 05/09/14 Start Pandora issue #36
	ls_line_no = string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no') )

	//TimA 05/09/14 Pandora Issue #36 Re-confirming an outbound order with selected detail rows
	//New function that will validate the transparm
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )

	//lldetailfindrow = idsDOPick.GetItemNumber(llRowPos,'line_item_no')

	//If there are values in the astransparm but the row does not match the current row skip to the next record.
	//TimA 05/05/14 Pandora issue #36
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
	//If lldetailfindrow <> Long(lsLineParm ) and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if
	//**** TimA 05/09/14 End Pandora issue #36

	//TAM 2010/4/13 Skip parents of Delivery BOMS
    If idsDOPick.GetItemString(llRowPos,'component_ind') = 'Y' and idsDOPick.GetItemNumber(llRowPos,'Component_no') = 0 Then Continue 

	//TEMPO - Check GR for  	lsFind += " and trans_line_no = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	//Rollup to SKU/Line
	
	/*dts 10/12/13 - PND #639 - moved SKU look-up from below so that we know whether or not to inculde ContainerID in the Find (based on Container and PONO2 tracking)...
		- also adding UF1 (COO) to the Find */
	//Jxlim 03/29/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.		
	//Step 1. Checking Pandora Serial
	lsSku = upper(idsDOPick.GetItemString(llRowPos,'SKU'))	
	If lsSku <> lsPrevSku Then
//				Select 	User_field18 into :lsPndSer
		Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
		Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
		From		Item_Master 
		where	project_id = :asProject and
					sku = :lsSku 
		Using SQLCA;
	End If	
	lsPrevSku = lsSku
	//Jxim 03/29/2011 End of code
	//dts 10/12/13 - Only include Container on 3b13 if it's LPN (tracked by both Container ID and PONO2)
	if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
		lbLPN = True
	else
		lbLPN = False
	end if

	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
	lsFind += " and trans_line_no = '" + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')) + "'"
	//dts 2/20/15 - adding From_Project (po_no) to the Find. A single line wasn't supposed to have more than one Project but we have seen manually-created orders that do.
	lsFind += " and from_project = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no')) + "'"
	//dts 10/12/13 - Only include ContainerID in Find if it's LPN (tracked by both Container and PO_NO2.
	//if lbLPN then   Gailm This statement is valid for both types of orders.  5/8/2014
		//go ahead and include ContainerID in Find
		//GailM 6/3/2014 To reapply 639 - Filter serialized nonLPN GPNs to exclude City Block orders
		//If (Left(lsCust,3) <> "CB_")	Then	
	//GailM 7/18/2014 - If po_no2 or containerID are not blank, include in the search
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'container_id'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'container_id')) = '' Then  
		lsFind += " and container_id = '" + string(idsDOPick.GetItemString(llRowPos, 'container_id')) + "'"
	end if
	
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'po_no2'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'po_no2')) = '' Then  
		lsFind += " and po_no2 = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no2')) + "'"
	End If
	
	//dts 10/12/13 - add COO to the Find (this was missing...)
	lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
	if IsNull(lsCOO) then
		lsFind += " and COO = '" + idsDOPick.GetItemString(llRowPos, 'country_of_origin') + "'"
	else
		lsFind += " and COO = '" + lsCOO + "'"
	end if
	//?? 8/17/10 - do we need to add container_id to the find?
	llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())

	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		//idsGI.SetItem(llNewRow, 'from_loc', trim(idsDOPick.GetItemString(1, 'owner_id'))) //TEMPO! NEED OWNER CODE HERE, not Owner_ID!
		//Need to look-up Owner_CD (but shouldn't look it up for each row if it doesn't change (and it shouldn't))
		ldOwnerID = idsDOPick.GetItemNumber(1, 'owner_id')

		if ldOwnerID <> ldOwnerID_Prev then
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;
			ldOwnerID_Prev = ldOwnerID

			//need to also look up Group (in UF1) to determine GIG Y/N flag and Trans Y/N flag
			select user_field1 into :lsGroup
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCd;
			if left(lsGroup, 3) = 'GIG' then 
				lsGigYN = 'Y'
			else
				lsGigYN = 'N'
			end if
			//Jxlim 04/29/2011 Prod; Send transaction regardless oracle business unit Per Ian requested.
			//Jxlim 03/23/2011 Send transaction regardless oracle business unit Per Ian requested.
			lsTransYN = 'Y'	
			//			if lsElectronicYN = 'Y' then
			//				lsTransYN = 'Y'
			//			else
			//				//check to see if the Manual Order is GIG/BUILDS (if so, still send transaction)
			//				if left(lsGroup, 3) = 'GIG' or left(lsGroup, 4) = 'PLAT' or left(lsGroup, 3) = 'ENT' or left(lsGroup, 5) = 'HWOPS' or left(lsGroup, 5) = 'DECOM'  or left(lsGroup, 3) = 'NPI' or left(lsGroup, 5) = 'SCRAP' or left(lsGroup, 3) = 'RMA' or left(lsGroup, 9) = 'NETDEPLOY' or left(lsGroup, 2) = 'CB' or left(lsGroup, 5) = 'DCOPS' or left(lsGroup, 3) = 'GEO' then
			//					lsTransYN = 'Y'					
			//				else					
			//					lsTransYN = 'N'							
			//				end if
			//			end if

			// 7/29/09 - at this point, not yet sending transactions for Malaysia (or HongKong?).
			// 9/21/09 - Now sending transactions for Malaysia (or HongKong?).
			//if lsWH = 'PND_MLASIA' then lsTransYN = 'N'
		end if
		lsSupplier = upper(idsDOPick.GetItemString(llRowPos,'supp_code'))	
		
		//		//Jxlim 03/29/2011 If SKU is Pandora serial; (Pnd Serial#) Item_master.User_field18 is 'Y' then send serial# otherwise.		
		//		//Step 1. Checking Pandora Serial
		//		lsSku = upper(idsDOPick.GetItemString(llRowPos,'SKU'))	
		//		If lsSku <> lsPrevSku Then
		//					Select 	User_field18 into :lsPndSer
		//					From		Item_Master 
		//					where 	project_id = :asProject and
		//								sku = :lsSku 
		//					Using SQLCA;
		//		End If
		//		
		//		lsPrevSku = lsSku
		//		//Jxim 03/29/2011 End of code
				
		//	w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Line 0357 - start trans cheeck -  Time: "+ String(f_getLocalWorldTime('PND_MTV')))
		
		if lsTransYN = 'Y' then
			llNewRow = idsGI.InsertRow(0)
			//idsGI.SetItem(llNewRow, 'trans_id', trim(idsDOMain.GetItemString(1, 'do_no'))) // do_no for outbound
			// now using a transaction ID Sequence number.  Only grabbing the right-most 15 chars (as that's the limit on the interface)
			idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			idsGI.SetItem(llNewRow, 'from_loc', upper(trim(lsOwnerCD))) // 08/09 - added 'upper'
	
			idsGI.SetItem(llNewRow, 'to_loc', upper(trim(idsDOMain.GetItemString(1, 'cust_code')))) // 08/09 - added 'upper'
			idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
			idsGI.SetItem(llNewRow, 'sku', idsDOPick.GetItemString(llRowPos, 'sku'))
			idsGI.SetItem(llNewRow, 'from_project', trim(idsDOPick.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
			//idsGI.SetItem(llNewRow, 'to_project', trim(idsDOMain.GetItemString(1, 'user_field8')))
			idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))
			//TAM 04/19/2010 -Added Line Item Number that came in on the Delivery BOMs
			If idsDOPick.GetItemString(llRowPos,'component_ind') = 'W' Then
				lsSKU = idsDOPick.GetItemString(llRowPos, 'sku')
				lsDoNO = trim(idsDOMain.GetItemString(1, 'do_no'))
				liLine = idsDOPick.GetItemNumber(llRowPos, 'line_item_no')
				SELECT dbo.Delivery_BOM.user_field1  
						INTO :lsChildLine  
						FROM dbo.Delivery_BOM  
						WHERE ( dbo.Delivery_BOM.Project_ID = 'PANDORA' ) AND  
						( dbo.Delivery_BOM.DO_NO = :lsDONO ) AND  
						( dbo.Delivery_BOM.Sku_Child = :lsSKU ) AND  
						( dbo.Delivery_BOM.Line_Item_No = :liLine )   ;
				If Not IsNull(lsChildLine) and lsChildLine <> '' Then
					idsGI.SetItem(llNewRow, 'trans_line_no', lsChildLine)
				Else
					idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
				End If
			Else
				idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
			End If

			//TEMPO!! - does this need to be the User Line No?  If so, store in User_Field on the line?
			//		idsGI.SetItem(llNewRow, 'trans_line_no', string(idsROPutaway.GetItemNumber(llRowPos, 'user_line_item_no')))
	
			//Jxlim 03/22/2011 Sending serial number when GPN is Pandora serial User_field18)
			//Step 2 Get serial number from Sims
			//If Upper(lsPndSer) = 'Y' Then
			//if Trim( idsDOPick.GetItemString(llRowPos, 'serial_no') ) <> '-' then	// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line
			if Trim( ls_Serialized_Ind ) = 'B' or Trim( ls_Serialized_Ind ) = 'O' or Trim( ls_Serialized_Ind ) = 'Y' then	// LTK 20160113 Emergency build change
				//idsGI.SetItem(llNewRow, 'serial_no', idsDOPick.GetItemString(llRowPos, 'serial_no'))
				//idsGI.SetItem(llNewRow, 'serial_no',upper(lsPndSer))		//GailM.  lsPndSer not available to determine using serial no
				idsGI.SetItem(llNewRow, 'serial_no','Y')		// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line (code was only setting Y/N flag here)
			Else
				idsGI.SetItem(llNewRow, 'serial_no', 'N')
			End If
			//Jxlim 03/22/2011 end of code
			
			idsGI.SetItem(llNewRow, 'quantity', idsDOPick.GetItemNumber(llRowPos, 'quantity'))
//			idsGI.SetItem(llNewRow, 'reference', trim(idsDOMain.GetItemString(1, 'remark')))  //remarks? UF? Invoice?
			idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'

			idsGI.SetItem(llNewRow, 'lot', idsDOPick.GetItemString(llRowPos, 'lot_no'))
			//dts 10/12/13 - now using Ops-entered COO instead of actual country_of_origin
			//idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'country_of_origin'))
			lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
			if IsNull(lsCOO) then
				//in case it wasn't entered...
				idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'country_of_origin'))
			else
				idsGI.SetItem(llNewRow, 'coo', lsCOO)
			end if

			//DECOM/RMA.... NEED TO Turn this on/off for testing; b2b vs DECOM/RMA
			// 10/08/09 - now getting Container ID from dd.uf7 below (should this be for RMA only?)
			//idsGI.SetItem(llNewRow, 'container_id', idsDOPick.GetItemString(llRowPos, 'container_id'))

			//Get Alt SKU/ Defect Serial Number/ Defective Tracking Number from Detail row.
			lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
			lsFind += " and line_item_no = " + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no'))

			//lsFind += " and container_id = '" + string(idsDOPick.GetItemString(llRowPos, 'container_id')) + "'"
			//lsFind += " and po_no2 = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no2')) + "'"			
			// dts - 2010/08/17, container id now coming from picking row, not user field on detail row...
			//dts 10/12/13 only writing Container_ID for LPN SKUs (where SKU is tracked by both Container id and PO_NO2)
			//if lbLPN then			GailM 5/25/2014 - No longer true need container id always
				idsGI.SetItem(llNewRow, 'container_id', idsDOPick.GetItemString(llRowPos, 'container_id'))
			//end if
			//TimA 07/09/13 Pandora issue #608 LPN project
			idsGI.SetItem(llNewRow, 'po_no2', idsDOPick.GetItemString(llRowPos, 'po_no2'))
			//idsGI.SetItem(llNewRow, 'l_code', idsDOPick.GetItemString(llRowPos, 'l_code'))  no longer needed

			//TimA 06/15/15  Need identify Box ID's later down the code
			idsGI.SetItem(llNewRow, 'Commodity_Code', idsDOPick.GetItemString(llRowPos, 'im_user_field5')) //User_Field5 from Item Master

			llFindDetailRow = idsDoDetail.Find(lsFind, 1, idsDoDetail.RowCount())
			If llFindDetailRow > 0 Then /*row found*/
				idsGI.SetItem(llNewRow, 'defect_serial_no', idsDODetail.GetItemString(llFindDetailRow,'user_field3'))
				idsGI.SetItem(llNewRow, 'defect_track_no', idsDODetail.GetItemString(llFindDetailRow,'user_field4'))
				idsGI.SetItem(llNewRow, 'to_project', idsDODetail.GetItemString(llFindDetailRow,'user_field5'))
				//TimA 07/09/13 re-commented this out because I think it was uncommented out by mistake
				//*?? 8/17 */				idsGI.SetItem(llNewRow, 'container_id', idsDODetail.GetItemString(llFindDetailRow, 'user_field7'))
				If idsDODetail.GetItemString(llFindDetailRow,'alternate_sku') > '' Then
					idsGI.SetItem(llNewRow, 'mfg_prt_no', idsDODetail.GetItemString(llFindDetailRow,'alternate_sku'))
				Else
					idsGI.SetItem(llNewRow, 'mfg_prt_no',  upper(idsDOPick.GetItemString(llRowPos,'SKU')))
				End If
			Else
				//error
			End If

			// TAM: 2016-06 Added Client_Cust_PO_NBR,Vendor_Invoice_Nbr
			//20-Jul-2016 Madhu - commented - since, Client_Cust_Po_Nbr is not added to idsGI DW.
			//idsGI.SetItem(llNewRow, 'Client_Cust_PO_NBR', trim(idsDOMain.GetItemString(1, 'Client_Cust_PO_NBR')))

		End If
	End If
	//TimA 05/09/14 Pandora issue #36 Skip detail lines that are not part of the reconfirm by detail lines.
	skipDetailRow:
Next /* Next Picking record */

/* END OF POPULATE GI DATASTORE SECTION *************************************************************/

//
//
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


/* START SH1 HEADER SECTION *************************************************************************/
//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGI.RowCount()

		w_main.SetMicroHelp(" SH1 Row a " + + String(f_getLocalWorldTime('PND_MTV')))

if llRowCount <= 0 then return 0

//Build and Write the Header
llNewRow = idsOut.insertRow(0)

lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
lsOutString += 'SH1|' 																				//record type
lsOutString += lsWH + '|'																		//Warehouse
	ldtToday = GetPacificTime(lsWH, ldtToday)
ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyymmddhhmmss')
lsOutString += ls_PacificTime + '|'  															//current_time
// 07/28/09 - lsOutString += NoNull(idsDOMain.GetItemString(1, 'invoice_no')) + '|' 					//supp_invoice_no
lsInvoice = NoNull(idsDOMain.GetItemString(1, 'invoice_no'))		//5
if right(lsInvoice, 2) = '_2' then //for DECOM/RMA DC-to-DC Move, 2nd SO is created with a '_2' suffix...
	lsInvoice = left(lsInvoice, len(lsInvoice)-2)
elseif right(lsInvoice, 5) = '_DCWH' then //for DC's operating as a WH (with a designated 'Local WH'), WH x-fer from DC to Local WH is created with a '_DCWH' suffix...
	lsInvoice = left(lsInvoice, len(lsInvoice)-5)
end if
//TimA 03/18/14 Use the AWB if VICS Bol is blank
ls_Vics_Bol_no = NoNull(idsDOMain.GetItemString(1, 'Vics_Bol_no' ) )
ls_AWB_BOL_No = NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No' ) )
//TimA 09/28/15 Pandora issue #962 Use Carrier Pro No instead of AWB if found
ls_Carrier_Pro_no = Nz(idsDOMain.GetItemString(1, 'Carrier_Pro_no'), '' )
If ls_Vics_Bol_no = '' then
	If ls_Carrier_Pro_no =  '' Then
		ls_Vics_Bol_no = ls_AWB_BOL_No
	Else
		ls_Vics_Bol_no = ls_Carrier_Pro_no
	End if
End if

lsOutString += lsInvoice + '|' 																		//supp_invoice_no
lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_type')) + '|'						//Order_Type
//TimA 07/11/13 moved the AWB_BOL_No down and replace the ship_ref column
//TimA 03/18/14 Change to Vics_Bol to a variable 
lsOutString +=  ls_Vics_Bol_no + '|'																//Vics_bol_no
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'Vics_Bol_no')) + '|'						//Vics_bol_no
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No')) + '|'				//Bill of Lading
lsOutString += NoNull(idsDOMain.GetItemString(1, 'User_Field2')) + '|'					//User_Field2
lsOutString += NoNull(idsDOMain.GetItemString(1, 'User_Field3')) + '|'					//User_Field3
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field7')) + '|'					//Transaction Type
lsOutString += NoNull(idsDOMain.GetItemString(1, 'user_field11')) + '|'					//Requester

// LTK 20110420  Pandora #177/#139b Populate the carrier field with carrier address line 1
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'carrier')) + '|'						//Carrier
String lsCarrier, lsCarrierAddress1
lsCarrier = idsDOMain.GetItemString(1, 'carrier')
//TimA 07/11/13 Added Carrier Name for LPN project #608
select address_1, Carrier_Name 						
into :lsCarrierAddress1, :lsCarrierName
from carrier_master
where project_id = 'PANDORA'
and carrier_code = :lsCarrier;
lsOutString += NoNull(lsCarrierAddress1) + '|'													//Carrier address line 1

//TimA 07/11/13 replace ship_ref with awb_bol_no Pandora LPN project
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'ship_ref')) + '|'						//PRO Number
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No')) + '|'				//PRO Number
// LTK 20150417  Pandora #962  Send Carrier Pro No unless it is null, then send Awb_Bol_No
//lsOutString += NoNull( nz( idsDOMain.GetItemString(1, 'Carrier_Pro_no'), idsDOMain.GetItemString(1, 'AWB_BOL_No') )) + '|'		//PRO Number
if IsNull( idsDOMain.GetItemString(1, 'Carrier_Pro_no') ) or Len( Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') )) = 0 then		// LTK 20150622  Added empty string check
	lsOutString += Trim( idsDOMain.GetItemString(1, 'AWB_BOL_No') ) + '|'
else
	lsOutString += Trim( idsDOMain.GetItemString(1, 'Carrier_Pro_no') ) + '|'		//PRO Number
end if

	ldtTemp = idsDOMain.GetItemDateTime(1, 'complete_date')			
	ldtTemp = GetPacificTime(lsWH, ldtTemp)
lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + '|'									//complete_date
lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_status')) + '|'					//Order Status
lsOutString += 	'|'																						//Ship-From ID
lsOutString += NoNull(lsWHName) + '|'															//Ship-From Name
lsOutString += NoNull(lsWHAddr1) + '|'															//Ship-From Address1
lsOutString += NoNull(lsWHAddr2) + '|'															//Ship-From Address2
lsOutString += NoNull(lsWHAddr3) + '|'															//Ship-From Address3
lsOutString += NoNull(lsWHAddr4) + '|'															//Ship-From Address4
lsOutString += NoNull(lsWHCity) + '|'																//Ship-From City
lsOutString += NoNull(lsWHState) + '|'															//Ship-From State
lsOutString += NoNull(lsWHZip) + '|'																//Ship-From Zip
lsOutString += NoNull(lsWHCountry) + '|'														//Ship-From Country
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Cust_Code')) + '|'					//Ship-To ID
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Cust_Name'))) + '|'					//Ship-To Name
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Address_1'))) + '|'					//Ship-To Address1 - Pipe is a delimiter and must not be present
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Address_2'))) + '|'					//Ship-To Address2
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Address_3'))) + '|'					//Ship-To Address3
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Address_4'))) + '|'					//Ship-To Address4
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'City'))) + '|'								//Ship-To City
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'State'))) + '|'							//Ship-To State
lsOutString += NoNull(NoPipe(idsDOMain.GetItemString(1, 'Zip'))) + '|'								//Ship-To Zip
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Country')) + '|'						//Ship-To Country
//dts 01/16/12 - Pandora #566 - Make 'To Project' upper case (on 3B13)
lsToProject = Upper(NoNull(idsDOMain.GetItemString(1, 'user_field8')))							//To Project
If lsToProject <> '-' and lsToProject <> 'NA' and lsToProject <> 'N/A' Then 	
	lsOutString += NoNull(lsToProject) + '|' 
Else
	lsOutString += "|"
End If

ldtTemp = idsDOMain.GetItemDateTime(1, 'request_date')			
//if IsDate(String(ldtTemp)) then
//	ldtTemp = GetPacificTime(lsWH, ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + '|'								//request_date
//Else
//	lsOutString += "|"
//End If	
lsOutString += NoNull(idsDOMain.GetItemString(1, 'Cust_Code')) + '|' 					//Customer Code
/*TODO!!! 
	POP Location (for DECOM): For outbound, POP Location is the 'FROM Location' for the order that received the Inventory
     - Need to grab ro_no (from any line?), then look up user_field3 
	  !now getting it from delivery_detail.UF6 */
//if left(lsGroup, 5) = 'DECOM' then 
	select min(user_field6) into :lsPopLoc
	from delivery_detail
	where do_no = :asDONO;
//end if

lsOutString += NoNull(lsPOPLoc) + '|'											  					//Original POP Location

//TimA 07/11/13 Add Transport_Mode and Carrier_Name and vics_bol_no Pandora LPN Project #608
//lsOutString += NoNull(idsDOMain.GetItemString(1, 'Transport_Mode')) + '|'						//Transport Mode
//lsOutString += NoNull(lsCarrierName) 																//Carrier Name
//TimA 07/15/13 changed to carrier
lsOutString += NoNull(lsCarrier) 																//Carrier

//TimA 05/05/15
//Added WMS WH Cust type Flag
if (lsUseCustType = "Y") Then
	//If lsCustType = 'WMS' then
	// LTK 20160314  Added a configuration flag to the above line to determine if we are skipping the inbound order creation.  If we are skipping, don't send 'Y' flag to ICC, even if it's a WMS order.
	If lsCustType = 'WMS' and f_retrieve_parm("PANDORA", "FLAG", "SKIP_AUTO_INBOUND") <> 'Y' then
		lsOutString += '|Y'
	else
		lsOutString += '|N'
	end if
End if

	// GailM 2/26/2015 - Add Unique Trx ID to Header section  - Header Pos 40
	if (lsSkipProcess2 = "Y") Then
		int i
		trim(asDoNo)
		IF len(asDoNo) > 1 THEN
			For i = 1 to len(asDoNo)
				if isnumber(mid(asDoNo,i,1)) then
					li_Pos = i
					exit
				 end if
			next
		END IF
		lsUniqueTrxId = 'S' + right(asDoNo, len(asDoNo) - li_Pos + 1) + 'O'
		lsOutString += '|' 
		lsOutString += lsUniqueTrxId

		// TAM: 2016-06 Added DO_NO, Client_Cust_PO_NBR
		lsOutString += '|' 
		lsOutString += NoNull ( asDoNo )
		lsOutString += '|' 
		lsOutString += NoNull ( idsDOMain.GetItemString(1, 'Client_Cust_PO_NBR') ) //19-Jun-2016 :Madhu- Added "Client Cust Po Nbr.


	End If

idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'GIR' + String(ldBatchSeq, '000000') + '.DAT') 
	
/* END OF SH1 HEADER SECTION *****************************************************************************/
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Header Row completed")

lsLogOut = "             Populate LC1 and SN1 rows at: '"  + String(f_getLocalWorldTime('PND_MTV'))
FileWrite(gilogFileNo,lsLogOut)


/* START OF LC1 SECTION - integrated SN1 **************************************************************************/
llRowCount = idsGI.RowCount()
For llRowPos = 1 to llRowCount
	w_main.SetMicroHelp("2 - LC1 row:" + string(llRowPos))
			//Refresh screen willl looping
		if llRowPos = 10000 or llRowPos = 20000 or llRowPos = 30000 or llRowPos = 40000 then
			yield()
		end if
	// We need lsPndSer during this loop to determine whether to add serial number SN1 rows under the LC1 row
	// GI SN was set earlier in the GI loop.  SN used because its no longer used after restructure
	lsPndSer = idsGI.GetItemString(llRowPos, 'serial_no')
	ls_line_no = idsGI.GetItemString(llRowPos, 'trans_line_no')		//GailM 5/15/2014 - need for SN1 filter

	llNewRow = idsOut.insertRow(0)
	lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
	lsOutString += 'LC1|' 																				//Transaction Code
	lsOutString += lsWH + '|'																		//Warehouse
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'from_loc')) + '|' 								//sub-inventory location (stored as owner)
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'trans_line_no')) + '|'			//Line Item
	lsOutString += '|'	
																				// Original Quantity
	llQuantity = idsGI.GetItemNumber(llRowPos,'quantity')
	lsOutString += NoNull(string(llQuantity)) + '|'				//Quantity
	lsOutString += 'EA|'																				//UOM
	lsSKU = NoNull(idsGI.GetItemString(llRowPos, 'sku'))										// lsSKU is used in SN section below
	lsOutString +=  lsSKU + '|'																		//SKU

	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'mfg_prt_no')) + '|'						//Manufacturer part number
	lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'defect_serial_no')) + '|'				//Defective Appl SN
//TAM 3/1/2010 - Not Sending for decom
// TAM 2010/01/22 Suppress lot # except Decom
//	If left(lsGroup, 5) = 'DECOM'  Then
//		lsOutString +=NoNull( idsGI.GetItemString(llRowPos, 'lot')) + '|'									//Lot
//	Else
		lsOutString += '|'																					// Original Quantity
//	End If
	lsCOO = NoNull( idsGI.GetItemString(llRowPos, 'coo'))
	lsOutString += lsCOO + '|'                          //CountryOfOrigin
	// 05/12/09 - Pandora wants Project's case maintained (can't handle 'Upper') lsFromProject = upper(idsGI.GetItemString(llRowPos, 'from_project')) /* Pandora Project (from po_no) */
	// 07/21/09 - BACK TO USING UPPER...lsFromProject = NoNull(idsGI.GetItemString(llRowPos, 'from_project'))							//From Project
	lsFromProject = Upper(NoNull(idsGI.GetItemString(llRowPos, 'from_project')))							//From Project
	If lsFromProject <> '-' and lsFromProject <> 'NA' and lsFromProject <> 'N/A' Then 
		lsOutString += NoNull(lsFromProject) + '|' 												//From Project
	Else
		lsOutString += "MAIN|"
	End If
		lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'defect_track_no'))	+ '|'				//Return Label Tracking Number
	
	
	// 07/21/09 - Using Upper... lsOutString += NoNull(idsGI.GetItemString(llRowPos, 'to_project')) + '|'							//To Project
	lsToProjectDetail = Upper(NoNull(idsGI.GetItemString(llRowPos, 'to_project'))) 							//To Project
	if lsToProjectDetail = '' then
		lsOutString += 	lsToProject + '|'							//To Project  from the Header
	else
		lsOutString += lsToProjectDetail + '|'							//To Project
	end if
	//DECOM (added Container ID)...
	//GailM - 6/4/2014 - 639 City Block will not have containerID in LC1
	//GailM - 8/28/2014 - 883 DejaVu to suppress containerID except those going to WMS (What identifies transfer to WMS?)
	If NOT lbShipFromCityBlock and NOT lbShipToCityBlock and NOT ibDejaVu Then
		lsContainerID =  NoNull(idsGI.GetItemString(llRowPos, 'container_id')) 							//Container ID
	Else
		lsContainerID = ''
	End If
	//TimA 06/15/15 Per Roy.  We need to blank out  curtain container ID's because WMS can't  identify box id's on bad container ID's
	//This is a bandaid fix until we can find out how we can have correct Box ID's/Container ID's
	If lsCustType = 'WMS' then
		If idsGI.GetItemString(llRowPos, 'Commodity_Code') = 'HD' then
			If lsContainerID <> '' Then
				llListContainersRowCount = lsLookupTable.retrieve(asProject,'NULL_CONTAINER' )  //List of prefexes to look for
				llListRowPos = 0
				For llListRowPos = 1 to llListContainersRowCount
						lsParmSearch = lsLookupTable.GetItemString(llListRowPos,'Code_Id')
						If Pos(Upper(lsContainerID), lsParmSearch) > 0 then
							//The Parm is found in the container ID.  Blank out the container ID and exit the For Loop
							lsContainerID = ''
							Exit
						End if
				Next
			End If
		End if
	End if
	lsOutString += lsContainerID + '|'							//Container ID
	//TimA 07/09/13 Pandora issue #608 LPN project
	lsPONo2 = NoNull(idsGI.GetItemString(llRowPos, 'po_no2'))
	lsOutString += lsPONo2										//po_no2
	
	idsOut.SetItem(llNewRow, 'Project_id', asProject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	idsOut.SetItem(llNewRow, 'file_name', 'GIR' + String(ldBatchSeq, '000000') + '.DAT') 
	
		/*START OF SN1 SECTION - to be integrated into the LC1 section ******from within LC1***************************************/
		
		// Begin Serial Rows
		// TAM 10/28/2009  Only want to send serial numbers for enterprise
		// TAM 06/2010  Send for all per Full Cycle Project
		//If left(lsGroup, 3) = 'ENT' Then
		ldtToday = GetPacificTime(lsWH, ldtToday)
		
		iF lbLPN then
			//w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Serial Numbers for LPN PalletID:  " + String(lsPONo2))
			llSerialCount = idsDOSerial.Retrieve(asDoNo,lsPONo2,lsContainerID)				// Add palletID & cartonID to retrive serial numbers for this LC1
			For llSerialRow = 1 to llSerialCount 
				llNewRow = idsOut.insertRow(0)

				lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  						// do_no
				lsOutString += 'SN1|' 																						//Transaction Code
				lsOutString += lsWH + '|'																					//Warehouse
				lsOutString += String(ldtToday, 'yyyymmdd') + '|'  													//current_date
				lsOutString += String(ldtToday, 'hhmmss') + '|'  														//current_time
				lsOutString += NoNull(idsDOMain.GetItemString(1, 'invoice_no')) + '|' 							//supp_invoice_no
				lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_type')) + '|'								//Order_Type
				lsOutString += NoNull(string(idsDOSerial.GetItemNumber(llSerialRow, 'line_item_no'))) + '|'	//Line Item
				lsOutString +=  '|'																								//Shipment						 
				lsOutString += NoNull(idsDOSerial.GetItemString(llSerialRow,"carton_serial_serial_no")) + '|'  				//Serial Number						
				lsOutString += NoNull(idsDOSerial.GetItemString(llSerialRow, 'Country_of_origin')) + '|'		//COO
				lsOutString += NoNull(idsDOSerial.GetItemString(llSerialRow, "carton_serial_carton_id")	)						//Container ID

				idsOut.SetItem(llNewRow, 'Project_id', asProject)
				idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
				idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
				idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
				idsOut.SetItem(llNewRow, 'file_name', 'GIR' + String(ldBatchSeq, '000000') + '.DAT') 
			Next		
			w_main.SetMicroHelp("Processing Purchase Order (ROSE) - LPN LC1 rows complete")
		Else			//Serialized nonLPN (pono2_controlled_ind = 'N'  GailM 4/25/14 Any nonLPN will check SNs
			w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Serial Numbers forserialized nonLPN GPN:  " +  idsGI.GetItemString(llRowPos,'SKU') )
			If idsDOSerial.RowCount() > 0  and llQuantity <= idsDOSerial.RowCount() Then		// Already have serial data from last LC1 line and there is another row from the same line_item_no
				//Do nothing 
			Else
				idsDOSerial.Retrieve(asDoNo)		//GailM 5/8/2014 Filter changed to add containerID, 5/15/2014 added l_code to filter.
			End If
			
			If NOT ibDejaVu Then 	// GailM - 8/28/2014 - Issue 883 - ContainerIDs scanned into Serial # tab - No SN1 row
				if (isNull(lsContainerID) or trim(lsContainerID) = '') then
					lsSkuFilter = "SKU = '" + idsGI.GetItemString(llRowPos,'SKU') + "' and #3 = " + ls_line_no +  " "
				else
					lsSkuFilter = "SKU = '" + idsGI.GetItemString(llRowPos,'SKU') + "' and #3 = " + ls_line_no + " and #5 = '" + lsContainerID +  "'"
				end if
				liRC = idsDOSerial.Setfilter(lsSkuFilter)
				liRC = idsDOSerial.Filter()
		
				If idsDOSerial.Rowcount() > 0 Then
					//dts - 10/21/15 - setting Serial count to the RowCount of the Serial datastore instead of the Pick Quantity on the line (sweeper was crashing here when an order had fewer serial records than the quantity (long story...)
					//dts = 11/25/15 - if line is split by COO, then all serial #s are being written for each pick row. Don't want to write MORE serial #s than the Pick Qty
					//llSerialCount = llQuantity
					//llSerialCount = idsDOSerial.Rowcount()
					if llQuantity <= idsDOSerial.Rowcount() then
						llSerialCount = llQuantity
					else
						llSerialCount = idsDOSerial.Rowcount()
					end if
				Else
					llSerialCount = 0
				End if
				For llSkuRow = llSerialCount to 1 Step -1
					lsSerialNo = NoNull(idsDOSerial.GetItemString(llSkuRow, 'serial_no'))		//SerialNo needed outside for serial_number_inventory delete
					If Upper(lsPndSer) = 'Y' Then	
						llNewRow = idsOut.insertRow(0)
						
						lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
						lsOutString += 'SN1|' 																						//Transaction Code
						lsOutString += lsWH + '|'																					//Warehouse
						//TimA 07/24/13 Move this to before the For Statement
						//ldtToday = GetPacificTime(lsWH, ldtToday)
						lsOutString += String(ldtToday, 'yyyymmdd') + '|'  													//current_date
						lsOutString += String(ldtToday, 'hhmmss') + '|'  														//current_time
						// dts - 5/5/2010 - shouldn't this be lsInvoice?  What about '_2' and '_DCWH' orders?  Not an ENTerprise possibility?
						lsOutString += NoNull(idsDOMain.GetItemString(1, 'invoice_no')) + '|' 							//supp_invoice_no
						lsOutString += NoNull(idsDOMain.GetItemString(1, 'ord_type')) + '|'								//Order_Type
						lsOutString += NoNull(string(idsDOSerial.GetItemNumber(llSkuRow, 'line_item_no'))) + '|'	//Line Item
						lsOutString +=  '|'																								//Shipment
						lsOutString += lsSerialNo+ '|'																				//Serial Number	
						
						lsSerialNo = idsDOSerial.GetItemString(llSkuRow, 'serial_no')
						//lsOutString += NoNull(idsDOSerial.GetItemString(llSkuRow, 'Country_of_origin')) + '|'		//COO
						lsOutString += lsCOO + '|'																					//Use LC1 country of origin for SN1 row
			
						//GailM - 6/4/2014 - 639 City Block will not have containerID in LC1 or SN1 lines
						If NOT lbShipFromCityBlock and NOT lbShipToCityBlock Then
							lsOutString += NoNull(idsDOSerial.GetItemString(llSkuRow, 'carton_no')) 					//Container
						End If
											
						idsOut.SetItem(llNewRow, 'Project_id', asProject)
						idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
						idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
						idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
						idsOut.SetItem(llNewRow, 'file_name', 'GIR' + String(ldBatchSeq, '000000') + '.DAT') 
						
						idsDOSerial.DeleteRow(llSkuRow)
						
					End if
					
					// Delete serial number from serial number inventory table. Statement removed from above loop on 5/20/2014 - GailM
					Delete from Serial_Number_Inventory
					WHERE Project_id = :asProject
					and Serial_no = :lsSerialNo
					and SKU = :lsSku
					Using SQLCA;
					
				Next
				w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Serialized nonLPN LC1 lines complete")
			End If  /* End SN1 */
			
			w_main.SetMicroHelp("Ready")
				
			
		End If

		/* END OF SN1 SECTION -**************SNs are placed after corresponding LC1 rows*********************************/
	
	
next /*next output record */

/* END OF LC1 SECTION *******************************************************************************/


/*
/* Insert SN rows into idsOut from idsSNOut to have SN records after detail records */
	idsOut.SetSort("")
	idsOut.Sort()
	
	liRC = idsSNOut.RowsCopy(1,idsSNOut.RowCount(), Primary!, idsOut, 9999999, Primary!) 
	
	idsSNOut.Reset()
	idsSNOut.Dataobject = ''
	destroy idsSNOut
/* End attaching rows to idsOut */
*/

/* START OF CT1 - PACKING ROWS ***********************************************************************/
lsLogOut = "             Populate CT1 rows at: '"  + String(f_getLocalWorldTime('PND_MTV'))
FileWrite(gilogFileNo,lsLogOut)


// Begin Packing Rows
llRowCount = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount

	llNewRow = idsOut.insertRow(0)
	lsOutString = idsGI.GetItemString(1, 'trans_id') + string(llNewRow) + '|'  // do_no
	lsOutString += 'CT1|' 																					//Transaction Code
	lsOutString += lsWH + '|'																				//Warehouse
		ldtToday = GetPacificTime(lsWH, ldtToday)
	lsOutString += String(ldtToday, 'yyyymmdd') + '|'  												//current_date
	lsOutString += String(ldtToday, 'hhmmss') + '|'  													//current_time
	lsOutString +=  '|'																							//Shipment
	lsOutString += NoNull(idsDOpack.GetItemString(llRowPos, 'carton_no')) + '|'				//Container
	//TimA 07/15/13 Pandora issu 608 LPN Project Add Gross and Net Weight
	//******
	lsOutString +=  '||||||||'																				//Unused fields
	
	lsThisCarton = idsDOpack.GetItemString(llRowPos, 'carton_no')
	if lsThisCarton <> lsLastCarton then
		//Wgt/Dims are stored on each packing row but the values are for the carton, not the individual line (so only count each carton once)
		ldWgt = ldWgt + idsDOpack.GetItemNumber(llRowPos, 'Weight_Gross')
		llCtnCount += 1
		lsLastCarton = lsThisCarton
	end if
	
	if isNull(ldWGT) then ldWGT = 0
	//TimA Pandora says don't have the Decimal 07/18/13
//	lsOutString += string(round(ldWgt, 2)) + '|'		//Gross weight 
	lsOutString += NoNull(string(round(ldWgt, 0))) + '|'		//Gross weight 
	
	ldWgtNet = idsDOpack.GetItemNumber(llRowPos, 'Weight_Net')
	if isNull(ldWgtNet) then ldWgtNet = 0
	//TimA Pandora says don't have the Decimal 07/18/13
	//lsOutString += string(round(ldWgtNet, 2)) + '|'		//Net Weight 
	lsOutString += NoNull(string(round(ldWgtNet, 0))) + '|'		//Net Weight 
	
	lsOutString +=  '||'																			//Unused fields
	//****** TimA 07/15/13
	
	// 07/07/2010 TAM:  Fix per Trey's directions.  If null us AWB_BOL_No
	// 09/28/2010 ujh: Additionally check for {blank}.
	if isNull(idsDOpack.GetItemString(llRowPos, 'shipper_tracking_id')) or trim(idsDOpack.GetItemString(llRowPos, 'shipper_tracking_id')) = '' then
		//TimA 09/28/15 Pandora issue #962 Use the carrier_pro_No instead of the AWB if found
		If ls_Carrier_Pro_no = '' Then
			lsOutString += NoNull(idsDOMain.GetItemString(1, 'AWB_BOL_No'))	+ '|'
		Else
			lsOutString += ls_Carrier_Pro_no	+ '|'
		End if
	else
		lsOutString += NoNull(idsDOpack.GetItemString(llRowPos, 'shipper_tracking_id')) + '|' 	//Tracking
	End If
	lsOutString += NoNull(String(idsDOpack.GetItemNumber(llRowPos, 'line_item_no')))  				//Line No

	idsOut.SetItem(llNewRow, 'Project_id', asProject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	idsOut.SetItem(llNewRow, 'file_name', 'GIR' + String(ldBatchSeq, '000000') + '.DAT') 
next /*next output record */

/* END OF CT1 - PACKING ROWS SECTION ******************************************************************************/

/* REMOVE SERIAL NUMBERS FROM SERIAL NUMBER INVENTORY FOR NON LPN SERIALIZED ORDERS SECTION ******************************************************************************/

	//GailM 04/25/2014 - Restored deleting serial numbers from serial number inventory table for serialized nonLPN SNs
	If lbLPN Then					
		w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Remove LPN SNs from serial_number_inventory_table.")
		liRC = sqlca.sp_delete_from_sn_inventory(asProject,asDONO)
		if liRC <> 0 Then
			lsLogOut = "              Error deleting LPN serial numbers.  Outbound order: " + asDONO + ' ErrorCode: ' + string(liRC)
		Else 
			lsLogOut = "              LPN serial numbers have been removed from serial number inventory table for outbound order: " + asDONO 
		End If
		FileWrite(gilogFileNo,lsLogOut)
	End If	  

/* COMPLETE FILE AND SEND *****************************************************************************************/

destroy idsDOPick			// GailM 01/31/2014 - Necessary for reset between transactions.  LPN GPN must use appropriate datastore DW.

//TimA 05/12/15 Added per Dave to not send out the GIR file if Customer Code is  WMSCUTOVER
If lsCust = 'WMSCUTOVER' Then
	lbSkipGIR = True
	lsLogOut = "              Suppress writing out the file because Customer Code is WMSCUTOVER for outbound order : " + asDONO 
	FileWrite(gilogFileNo,lsLogOut)
End if

//Write the Outbound File
/* 7/19/12 - Issue 455 - dts - now may be creating 'GIM*' file to be sent to MIM (if the Ship-to is MIM)
				and may need to suppress the GIR file here (which was previously done above)*/
if not lbSkipGIR then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
end if
if lbNeedGIM then
	lsLogOut = "      Creating 'GIM*' file for MIM.  DO_NO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	//Change the 1st record of idsOut to have the MIM file name.
	idsOut.SetItem(1, 'file_name', 'GIM' + String(ldBatchSeq, '000000') + '.DAT') 	
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
end if

w_main.SetMicroHelp("Ready")

Return 0

end function

public function integer uf_process_gi_om (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate);//24-JUNE-2017 :Madhu Added for PINT-945 -OB Order Confirmation (3B13)
//Write records back into OMQ Tables

String		lsFind, lsOutString, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType, lsFromLoc, ls_prev_carton_No, lsNull
String 	lsInvoice, lsSKU, lsDONO, lsChildLine, lsCarrierName, lsPndSer, lsPrevSku, lsSkuFilter, lsCust,lsThisCarton, lsLastCarton, lsSerialNo, lsOrdType, ls_uf7, ls_caseId, ls_ship_track_Id
String 	ls_Serialized_Ind,ls_PONO2ControlledInd, ls_ContainerTrackingInd,lsSupplier, lsCOO, lsPONO2, lsContainerID, ls_Carrier_Pro_no, lsLineParm,ls_line_no, lsRefch1, ls_pack_containerId
String 	ls_to_country, ls_from_country,lsDM_Country, lsCustCountry,ls_CodeDesc,lsSkipProcess2,lsUseCustType,lsCustType,lsParmSearch, ls_client_id, lsCarrier, lsCarrierAddress1
String 	ls_wh_name, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_city, ls_state, ls_zip, ls_country, ls_tel, ls_fax, ls_contact, ls_email, ls_carton_No, ls_carton_type, ls_detail_Find, ls_gmt_offset
String		ls_Pack_container_Id, ls_Pack_sku, ls_supp_code, ls_prev_Po_No2, ls_prev_Pack_container_Id, ls_pick_location, ls_omq_serial_no

Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow, llSerialCount, llQuantity, llCtnCount, llSerialRow, llSkuRow, llFindPackRow
Long 		ll_change_req_no, ll_batch_seq_no, ll_rc, ll_detail_row, ll_serial_row, ll_Inv_Row,  llPackRowCount, ll_Pack_Row, ll_Item_Attr_Id
Long 		ll_attr_row, ll_attr_detail_row, llRefch1, llRefch2, ll_detail_find_row, llDetailFindRow, llDetailQty, ll_serial_find_row, ll_return_code, ll_Parent_RF1

Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev,ldWgt, ldWgtNet,ldTransID, ldOMQ_Inv_Tran, ld_total_weight, ld_pallet_qty, ld_carton_qty, ld_Item_Qty, ld_pallet_carton_qty
Integer		liRC, liLine,DateDiffInMinutes, TimeDiffInMinutes, ElapsedTimeInMinutes
DateTime 	 ldtToday,ldt_EndRetrieve
Boolean		lbNeedGIM, lbSkipGIR, lbShipFromCityBlock, lbShipToCityBlock,lbLPN, lbNonLPN,lbParmFound, lbFootPrintSku, lbPallet

ldtToday = DateTime(Today(), Now())
SetNull(lsNull)

Datastore lsLookupTable

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Start Processing of uf_process_gi_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

// GailM 2/ 25/2015 Add Unique Trx ID - Turn on with functionality manager - use lsSkipProcess2
lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

// TimA 05/06/15  Turn on with functionality manager - Skip Adding the CustType for WMS  to the end of the file
lsUseCustType = f_functionality_manager(asProject,'FLAG','SWEEPER','CUSTTYPE','','')

If Not isvalid(idsGI) Then
	idsGI = Create u_ds_datastore
	idsGI.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create u_ds_datastore
	idsDOMain.Dataobject = 'd_do_master'
End If
idsDOMain.SetTransObject(SQLCA)
	
If Not isvalid(lsLookupTable) Then
	lsLookupTable = Create u_ds_datastore
	lsLookupTable.dataobject = 'd_lookup_table_search'
End If
lsLookupTable.SetTransObject(SQLCA)
	
If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create u_ds_datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
End If
idsDoDetail.SetTransObject(SQLCA)
	
If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create u_ds_datastore
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create u_ds_datastore
	idsDoPack.Dataobject = 'd_do_packing_track_id_pandora'
End If
idsDoPack.SetTransObject(SQLCA)
	
If Not isvalid(idsOMQWhDOMain) Then
	idsOMQWhDOMain =create u_ds_datastore
	idsOMQWhDOMain.Dataobject ='d_omq_warehouse_order'
End If
idsOMQWhDOMain.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDODetail) Then
	idsOMQWhDODetail =create u_ds_datastore
	idsOMQWhDODetail.Dataobject ='d_omq_warehouse_order_detail'
End If
idsOMQWhDODetail.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOSerial) Then
	idsOMQWhDOSerial =create u_ds_datastore
	idsOMQWhDOSerial.Dataobject ='d_omq_warehouse_order_detail_sernum'
End If
idsOMQWhDOSerial.settransobject(om_sqlca)
	
If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =Create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOAttr) Then
	idsOMQWhDOAttr =Create u_ds_datastore
	idsOMQWhDOAttr.Dataobject ='d_omq_warehouse_order_attr'
End If
idsOMQWhDOAttr.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDoDetailAttr) Then
	idsOMQWhDoDetailAttr =Create u_ds_datastore
	idsOMQWhDoDetailAttr.Dataobject ='d_omq_warehouse_order_detail_attr'
End If
idsOMQWhDoDetailAttr.settransobject(om_sqlca)

idsGI.Reset()
idsOMQWhDOMain.reset()
idsOMQWhDODetail.reset()
idsOMQWhDOSerial.reset()
idsOMQInvTran.reset()
idsOMQWhDOAttr.reset()
idsOMQWhDoDetailAttr.reset()

lsLogOut = "      OM Outbound Confirmation -Creating Inventory Transaction (GI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

w_main.SetMicroHelp("Processing Purchase Order (EDI - OM)")

lsOrdType = NoNull(idsDOMain.GetItemString(1, 'ord_type'))
lsWH = idsDOMain.GetItemString(1, 'wh_code')
ll_change_req_no = idsDOMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsDOMain.getitemnumber(1,'EDI_Batch_Seq_No')

Select DM.country DM_Country, C.Country C_Country  INTO 	:lsDM_Country, :lsCustCountry
From delivery_master DM with(nolock), Customer C  with(nolock)
Where DM.project_id = 'Pandora' and Do_no = :asDoNo And DM.project_id = C.Project_ID And DM.User_Field2 = C.Cust_Code 
using sqlca;	

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

select wh_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, Fax, Contact_Person, Email_Address, GMT_Offset
into :ls_wh_name, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_city, :ls_state, :ls_zip, :ls_country, :ls_tel, :ls_fax, :ls_contact, :ls_email, :ls_gmt_offset
from Warehouse with(nolock)
where wh_Code=:lsWH
using sqlca;

ls_to_country   = lsDM_Country
ls_from_country = lsCustCountry

IF  uf_is_country_eu_to_eu(asproject,ls_from_country, ls_to_country) Then //Compare Countries and if both are EU to EU then proceed
	select code_descript
	into :ls_CodeDesc
	from lookup_table with(nolock)
	where project_id = 'PANDORA'
	and code_type = 'GIR_Delay'
	and code_ID = 'Minutes'
	and User_Updateable_Ind = 'Y'
	using sqlca;

	select TOP 1 current_timestamp into :ldt_EndRetrieve from sysobjects using sqlca; //get Server time instead local machine time
	
	lsLogOut = "      OM Outbound Confirmation -Creating Inventory Transaction (GI) For DO_NO: " + asDONO+" current Server Time is: " + string(ldt_EndRetrieve)
	FileWrite(gilogFileNo,lsLogOut)

	IF ls_CodeDesc <> '' and Not IsNull ( ls_CodeDesc ) Then
		//ldt_EndRetrieve = DateTime(Today( ),Now( ) ) //Remeber if running this on a local machine this is your computer time not GMT
		DateDiffInMinutes = DaysAfter ( Date(dtrecordcreatedate), Date(ldt_EndRetrieve)  ) * 24 * 60
		TimeDiffInMinutes = SecondsAfter ( Time(dtrecordcreatedate), Time (ldt_EndRetrieve ) ) / 60
		ElapsedTimeInMinutes = DateDiffInMinutes + TimeDiffInMinutes
		lsLogOut = "      Waiting to process Inventory Transaction (GI) For DO_NO: " + asDONO + '  ' + String(ElapsedTimeInMinutes) + ' Minutes have passed ' +  ' System DateTime is: ' + String(ldt_EndRetrieve) + '  Record Create Date is: ' + String(dtrecordcreatedate)
		FileWrite(gilogFileNo,lsLogOut)
		
		If ElapsedTimeInMinutes < Long ( ls_CodeDesc ) then //Compair the minutes with the theashold found in the lookup table.
			lsLogOut = "      Skipping Inventory Transaction (GI) For DO_NO: " + asDONO 
			FileWrite(gilogFileNo,lsLogOut)
			w_main.SetMicroHelp("Ready")
			Return 2
		end If
		
		If this.uf_process_gi_delay_validation( asproject, asdono, ls_CodeDesc) > 0 Then Return 2
	end If
End If

//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	lsInvoice = idsDOMain.GetItemString(1, 'Invoice_no')
	
	select do_no into :lsDONO from Delivery_master with(nolock) where project_id = 'pandora' and invoice_no = :lsInvoice and wh_code = :lsWH and create_user = 'SIMSFP'
	using sqlca;
	
	if lsDONO > '' then
		lsElectronicYN = 'Y'
	end if
end if

lsCust = upper(trim(idsDOMain.GetItemString(1, 'cust_code')))
select user_field1,Customer_Type into :lsGroup, :lsCustType
from customer with(nolock)
where project_id = :asProject and cust_code = :lsCust using sqlca;

if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
	lbShipToCityBlock = true
End if

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Group = " + lsGroup)

lsFromLoc = idsDoMain.GetITemString(1,'User_field2')
If Not isnull(lsFromLoc) Then
	select user_field1 into :lsGroup
	from customer with(nolock)
	where project_id = :asProject and cust_code = :lsFromLoc
	using sqlca;

	If lsGroup > '' and not isnull(lsGroup) and Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GI Suppressed for MIM Owned Inventory transaction For DO_NO: " + asDONO + ". No GI is being created for this order."
		FileWrite(gilogFileNo,lsLogOut)
		if lbNeedGIM then
			lbSkipGIR = true
		else
			Return 0
		end if
	End IF

	if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
		lbShipFromCityBlock = true
	End if
End IF

w_main.SetMicroHelp(" Processing Purchase Order (ROSE) - Retrieve DO detail - Group: " + lsGroup)
idsDoDetail.Retrieve(asDoNo)
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()))

If idsDoDetail.RowCount() > 0 then
	lsSku = upper(idsDoDetail.GetItemString(idsDoDetail.GetRow() ,'SKU'))	

	Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
	Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
	From		Item_Master with(nolock)
	where	project_id = :asProject and	sku = :lsSku 
	Using SQLCA;
End If

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()) + ' - Checked Item Master')

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
Else
	destroy idsDoPick
	idsDoPick = Create Datastore
End if

if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
	idsDoPick.Dataobject = 'd_do_Picking_pandora'
	//idsDoSerial.Dataobject = 'd_gi_outbound_serial_lpn'	//GailM 2/17/2018 Footprint change
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_footprint'
	lbLPN = True
	lbNonLPN = false
	f_method_trace_special( asproject, this.ClassName() + ' - uf_process_gi_om', 'LPN flag set true, nonLPN set false for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Carton Level Query','',lsInvoice)		

elseif ls_Serialized_Ind = 'B' and (ls_ContainerTrackingInd = 'N' or ls_PONO2ControlledInd = 'N') then
	lbLPN = False
	lbNonLPN = true
	idsDoPick.Dataobject = 'd_do_Picking'			
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
	f_method_trace_special( asproject, this.ClassName() + ' - uf_process_gi_om', 'LPN flag set false, nonLPN set true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
else 
	lbLPN = False
	lbNonLPN = False
	
	idsDoPick.Dataobject = 'd_do_Picking'			
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
	idsDoSerial.SetTransObject(SQLCA)
	idsDoSerial.Retrieve(asDoNo)
	If idsDOSerial.RowCount() > 0 Then		//Non-serialized
		If idsDOSerial.GetItemString(1,'serial_no') = idsDOSerial.GetItemString(1,'carton_no') Then
			ibDejaVu = True
		End If
		idsDOSerial.Reset()
	End If

	f_method_trace_special( asproject, this.ClassName() + ' - uf_process_gi_om', 'LPN  false and nonLPN flags set to true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
end if

idsDoSerial.SetTransObject(SQLCA)
idsDoPick.SetTransObject(SQLCA)	

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Start Retrive PickList: " + String(f_getLocalWorldTime('PND_MTV')))

idsDoPick.Retrieve(asDoNo)
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Picklist retrievedil - RowCount " + String(idsDoPick.RowCount()) + ' - Completed: '+ String(f_getLocalWorldTime('PND_MTV')))

idsDoPack.Retrieve(asDoNo)

// TAm 2010/06/09 - Filter out Children
idsDOPick.Setfilter("Component_Ind <> '*'")
idsDOPick.Filter()

llRowCount = idsDOPick.RowCount()

// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

/***** START POPULATE GI DATASTORE SECTION *********/
lsLogOut = "             Populate GI datastore at: '"  + String(f_getLocalWorldTime('PND_MTV'))
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	w_main.SetMicroHelp(" 1 - GI Row: " + string(llRowPos))
	
	//Refresh screen willl looping
	if llRowPos = 10000 or llRowPos = 20000 or llRowPos = 30000 or llRowPos = 40000 then
		yield()
	End if
	
	ls_line_no = string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no') )
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )
	
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if
		
	If idsDOPick.GetItemString(llRowPos,'component_ind') = 'Y' and idsDOPick.GetItemNumber(llRowPos,'Component_no') = 0 Then Continue 
	
	//Step 1. Checking Pandora Serial
	lsSku = upper(idsDOPick.GetItemString(llRowPos,'SKU'))	
	If lsSku <> lsPrevSku Then
		Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
		Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
		From		Item_Master with(nolock)
		where	project_id = :asProject and	sku = :lsSku 
		Using SQLCA;
	End If
	
	lsPrevSku = lsSku
	
	if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
		lbLPN = True
	else
		lbLPN = False
	end if
	
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
	lsFind += " and trans_line_no = '" + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')) + "'"
	lsFind += " and from_project = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no')) + "'"
	
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'container_id'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'container_id')) = '' Then  
		lsFind += " and container_id = '" + string(idsDOPick.GetItemString(llRowPos, 'container_id')) + "'"
	end If
	
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'po_no2'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'po_no2')) = '' Then  
		lsFind += " and po_no2 = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no2')) + "'"
	End If
	
	lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
	
	if IsNull(lsCOO) then
		lsFind += " and COO = '" + idsDOPick.GetItemString(llRowPos, 'country_of_origin') + "'"
	else
		lsFind += " and COO = '" + lsCOO + "'"
	end if
	
	lsFind += " and pick_location ='"+trim(idsDOPick.getItemString(llRowPos,'l_code'))+"'" //23-Nov-2018 :Madhu DE7221 Added Pick Location
	
	llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	else /*not found, add a new record*/
			ldOwnerID = idsDOPick.GetItemNumber(1, 'owner_id')
		
			if ldOwnerID <> ldOwnerID_Prev then
				select owner_cd into :lsOwnerCD
				from owner with(nolock)
				where project_id = :asProject and owner_id = :ldOwnerID
				using sqlca;
		
				ldOwnerID_Prev = ldOwnerID
		
				select user_field1 into :lsGroup
				from customer with(nolock)
				where project_id = :asProject and cust_code = :lsOwnerCd
				using sqlca;
		
				if left(lsGroup, 3) = 'GIG' then 
					lsGigYN = 'Y'
				else
					lsGigYN = 'N'
				end if
				
				lsTransYN = 'Y'	
			end if
		
			lsSupplier = upper(idsDOPick.GetItemString(llRowPos,'supp_code'))	
		
		if lsTransYN = 'Y' then
			llNewRow = idsGI.InsertRow(0)
			idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			idsGI.SetItem(llNewRow, 'from_loc', upper(trim(lsOwnerCD))) // 08/09 - added 'upper'
			
			idsGI.SetItem(llNewRow, 'to_loc', upper(trim(idsDOMain.GetItemString(1, 'cust_code')))) // 08/09 - added 'upper'
			idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
			idsGI.SetItem(llNewRow, 'sku', idsDOPick.GetItemString(llRowPos, 'sku'))
			idsGI.SetItem(llNewRow, 'from_project', trim(idsDOPick.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
			idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))
			idsGI.SetItem(llNewRow, 'pick_location', trim(idsDOPick.getItemString(llRowPos,'l_code'))) //18-JULY-2018 :Madhu DE5029 - Added Pick Location
			
			//store required values to determine LPN /Non-LPN
			idsGI.SetItem(llNewRow, 'serialized_Ind', ls_Serialized_Ind)
			idsGI.SetItem(llNewRow, 'Po_No2_controlled_Ind', ls_PONO2ControlledInd)
			idsGI.SetItem(llNewRow, 'container_tracking_Ind', ls_ContainerTrackingInd)


			If idsDOPick.GetItemString(llRowPos,'component_ind') = 'W' Then
				lsSKU = idsDOPick.GetItemString(llRowPos, 'sku')
				lsDoNO = trim(idsDOMain.GetItemString(1, 'do_no'))
				liLine = idsDOPick.GetItemNumber(llRowPos, 'line_item_no')
				SELECT dbo.Delivery_BOM.user_field1  
				INTO :lsChildLine  
				FROM dbo.Delivery_BOM  with(nolock)
				WHERE ( dbo.Delivery_BOM.Project_ID = 'PANDORA' ) AND  
				( dbo.Delivery_BOM.DO_NO = :lsDONO ) AND  
				( dbo.Delivery_BOM.Sku_Child = :lsSKU ) AND  
				( dbo.Delivery_BOM.Line_Item_No = :liLine )   
				using sqlca;
			
				If Not IsNull(lsChildLine) and lsChildLine <> '' Then
					idsGI.SetItem(llNewRow, 'trans_line_no', lsChildLine)
				Else
					idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
				End If
			Else
				idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
			End If

			if Trim( ls_Serialized_Ind ) = 'B' or Trim( ls_Serialized_Ind ) = 'O' or Trim( ls_Serialized_Ind ) = 'Y' then	// LTK 20160113 Emergency build change
				idsGI.SetItem(llNewRow, 'serial_no','Y')		// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line (code was only setting Y/N flag here)
			Else
				idsGI.SetItem(llNewRow, 'serial_no', 'N')
			End If
	
			idsGI.SetItem(llNewRow, 'quantity', idsDOPick.GetItemNumber(llRowPos, 'quantity'))
			idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
			
			idsGI.SetItem(llNewRow, 'lot', idsDOPick.GetItemString(llRowPos, 'lot_no'))
			lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
		
			if IsNull(lsCOO) then
				idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'country_of_origin'))
			else
				idsGI.SetItem(llNewRow, 'coo', lsCOO)
			end if
			
			lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
			lsFind += " and line_item_no = " + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no'))
			
			idsGI.SetItem(llNewRow, 'container_id', idsDOPick.GetItemString(llRowPos, 'container_id'))
			idsGI.SetItem(llNewRow, 'po_no2', idsDOPick.GetItemString(llRowPos, 'po_no2'))
			idsGI.SetItem(llNewRow, 'Commodity_Code', idsDOPick.GetItemString(llRowPos, 'im_user_field5')) //User_Field5 from Item Master
	
			llFindDetailRow = idsDoDetail.Find(lsFind, 1, idsDoDetail.RowCount())
			If llFindDetailRow > 0 Then /*row found*/
				idsGI.SetItem(llNewRow, 'defect_serial_no', idsDODetail.GetItemString(llFindDetailRow,'user_field3'))
				idsGI.SetItem(llNewRow, 'defect_track_no', idsDODetail.GetItemString(llFindDetailRow,'user_field4'))
				idsGI.SetItem(llNewRow, 'to_project', idsDODetail.GetItemString(llFindDetailRow,'user_field5'))
			
				If idsDODetail.GetItemString(llFindDetailRow,'alternate_sku') > '' Then
					idsGI.SetItem(llNewRow, 'mfg_prt_no', idsDODetail.GetItemString(llFindDetailRow,'alternate_sku'))
				Else
					idsGI.SetItem(llNewRow, 'mfg_prt_no',  upper(idsDOPick.GetItemString(llRowPos,'SKU')))
				End If
			Else
				//error
			End If //llFindDetailRow
		End If //lsTransYN
	End IF //llFindRow
	skipDetailRow:
Next /* Next Picking record */

/***** END OF POPULATE GI DATASTORE SECTION ***********/

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//1. Write Header Records into OMQ_Warehouse_Order Table
llRowCount = idsGI.RowCount()

w_main.SetMicroHelp(" SH1 Row a " + + String(f_getLocalWorldTime('PND_MTV')))

if llRowCount <= 0 then return 0

lsCarrier = idsDOMain.GetItemString(1, 'carrier')

select address_1, Carrier_Name 						
into :lsCarrierAddress1, :lsCarrierName
from carrier_master with(nolock)
where project_id = :asproject
and carrier_code = :lsCarrier using sqlca;

//Build and Write  Header Records
llNewRow = idsOMQWhDOMain.insertRow(0)
idsOMQWhDOMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQWhDOMain.setitem( 1, 'CLIENT_ID', ls_client_id)
idsOMQWhDOMain.setitem(1, 'SITE_ID', lsWH) //site id

idsOMQWhDOMain.setitem( 1, 'QACTION', 'U') //Action- U (Update)
idsOMQWhDOMain.setitem( 1, 'QSTATUS', 'NEW')
idsOMQWhDOMain.setitem( 1, 'QSTATUSDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'QSTATUSSOURCE', 'SIMSSWEEPER')
idsOMQWhDOMain.setitem( 1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id

idsOMQWhDOMain.setitem( 1, 'ADDDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'ADDWHO', 'SIMSUSER')
idsOMQWhDOMain.setitem( 1, 'EDITDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'EDITWHO', 'SIMSUSER')

idsOMQWhDOMain.setitem( 1, 'ACTUALSHIPDATE', idsDOMain.GetItemDateTime(1, 'complete_date'))
idsOMQWhDOMain.setitem(1, 'EXTERNORDERKEY', trim(idsDOMain.GetItemString(1, 'invoice_no'))) //Invoice No
idsOMQWhDOMain.setitem(1, 'INCOTERM', trim(idsDOMain.GetItemString(1, 'freight_terms'))) //Freight Terms
idsOMQWhDOMain.setitem(1, 'TYPE', trim(idsDOMain.GetItemString(1, 'ord_type'))) //Type
idsOMQWhDOMain.setitem(1, 'ORDERGROUP', trim(idsDOMain.GetItemString(1, 'user_field7'))) //Order Group
idsOMQWhDOMain.setitem(1, 'ORDERKEY', Right(trim(idsDOMain.GetItemString(1, 'do_no')),10)) //Order Key (Do No)
idsOMQWhDOMain.setitem(1, 'STATUS', 'SHIPPED') //Status - Complete (95)

idsOMQWhDOMain.setitem(1, 'CARRIERKEY', lsCarrier) //Carrier Key
idsOMQWhDOMain.setitem(1, 'CLIENT_SHIPTO_ID', trim(idsDOMain.GetItemString(1, 'cust_code'))) //Consignee Key
idsOMQWhDOMain.setitem(1, 'CONSIGNEEKEY', left(trim(idsDOMain.GetItemString(1, 'cust_code')), 15)) //Consignee Key
idsOMQWhDOMain.setitem(1, 'C_COMPANY', left(trim(idsDOMain.GetItemString(1, 'cust_name')), 45)) //Customer Name

idsOMQWhDOMain.setitem(1, 'C_ADDRESS1', left(trim(idsDOMain.GetItemString(1, 'address_1')), 45)) //Address1
idsOMQWhDOMain.setitem(1, 'C_ADDRESS2', left(trim(idsDOMain.GetItemString(1, 'address_2')), 45)) //Address2
idsOMQWhDOMain.setitem(1, 'C_ADDRESS3', left(trim(idsDOMain.GetItemString(1, 'address_3')), 45)) //Address3
idsOMQWhDOMain.setitem(1, 'C_ADDRESS4', left(trim(idsDOMain.GetItemString(1, 'address_4')), 45)) //Address4

idsOMQWhDOMain.setitem(1, 'C_CITY', trim(idsDOMain.GetItemString(1, 'city'))) //City
idsOMQWhDOMain.setitem(1, 'DELIVERYPLACE', Left(trim(idsDOMain.GetItemString(1, 'state')),2)) //State
idsOMQWhDOMain.setitem(1, 'C_ZIP', trim(idsDOMain.GetItemString(1, 'zip'))) //Zip
idsOMQWhDOMain.setitem(1, 'C_COUNTRY', trim(idsDOMain.GetItemString(1, 'country'))) //Country
idsOMQWhDOMain.setitem(1, 'C_ISOCNTRYCODE', trim(idsDOMain.GetItemString(1, 'country'))) //Country

idsOMQWhDOMain.setitem(1, 'REQUESTEDSHIPDATE', idsDOMain.GetItemDateTime(1, 'request_date')) //Request Ship Date
idsOMQWhDOMain.setitem(1, 'DELIVERYDATE', idsDOMain.GetItemDateTime(1, 'request_date')) //Delivery Date
idsOMQWhDOMain.setitem(1, 'REFCHAR1', trim(idsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr

idsOMQWhDOMain.setitem(1, 'SUSR2', this.gmtformatoffset(ls_gmt_offset)) //Warehouse.GMT_Offset
idsOMQWhDOMain.setitem(1, 'SUSR3', trim(idsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr
idsOMQWhDOMain.setitem(1, 'SUSR4', this.uf_get_rdd_timezone( ll_batch_seq_no, trim(idsDOMain.GetItemString(1, 'invoice_no'))))

If Pos(idsDOMain.GetItemString(1, 'user_field7') ,'MATERIAL') > 0 Then   
	ls_uf7 = "TRANSFER"
elseIf Pos(idsDOMain.GetItemString(1, 'user_field7') ,'CUSTOMER') > 0 Then   
	ls_uf7 = "DLVORDER"
else
	ls_uf7 =''
End If

idsOMQWhDOMain.setitem(1, 'TYPE', ls_uf7) //User Field7
idsOMQWhDOMain.setitem(1, 'DEPARTMENT', trim(idsDOMain.GetItemString(1, 'user_field10'))) //User Field10
idsOMQWhDOMain.setitem(1, 'DIVISION', trim(idsDOMain.GetItemString(1, 'Do_No'))) //Do_No

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Header Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Header Row completed")

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ls_omq_serial_no =''

//2. Write Detail Records into OMQ_Warehouse_Order_Detail Table
llRowCount = idsGI.RowCount()
For llRowPos = 1 to llRowCount

	//Roll Up Detail records for same attribute values.
	If (not isnull(idsGI.GetItemString(llRowPos, 'trans_source_no')) and len(idsGI.GetItemString(llRowPos, 'trans_source_no')) > 0) Then lsFind = "EXTERNORDERKEY = '" + idsGI.GetItemString(llRowPos, 'trans_source_no') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'sku')) and len(idsGI.GetItemString(llRowPos, 'sku')) > 0) Then lsFind += " and ITEM = '" + upper(idsGI.GetItemString(llRowPos, 'sku')) + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'trans_line_no')) and len(idsGI.GetItemString(llRowPos, 'trans_line_no')) > 0) Then lsFind += " and EXTERNLINENO = '" +  idsGI.GetItemString(llRowPos, 'trans_line_no') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'from_loc')) and len(idsGI.GetItemString(llRowPos, 'from_loc')) > 0) Then 	lsFind += " and LOTTABLE01 = '" + 	idsGI.GetItemString(llRowPos, 'from_loc') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'from_project')) and len(idsGI.GetItemString(llRowPos, 'from_project')) > 0) Then lsFind += " and LOTTABLE03 = '" + upper(idsGI.GetItemString(llRowPos, 'from_project')) + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'to_project')) and len(idsGI.GetItemString(llRowPos, 'to_project')) > 0) Then lsFind += " and SUSR1 = '" + upper(idsGI.GetItemString(llRowPos, 'to_project')) + "'"

	IF idsOMQWhDODetail.RowCount() > 0 Then 	
		llDetailFindRow = idsOMQWhDODetail.Find(lsFind,1,idsOMQWhDODetail.RowCount())
		If llDetailFindRow >0 Then 
			llDetailQty = idsOMQWhDODetail.GetItemNumber(llDetailFindRow,'SHIPPEDQTY')
		else
			llDetailFindRow = 0
		End If
		
	else
		llDetailFindRow = 0
	End IF

	IF llDetailFindRow =0 Then
		ll_detail_row =idsOMQWhDODetail.insertrow( 0)
		idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR',ll_change_req_no)
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'U') //Action- U (Update)
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
		idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
		idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
		idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', lsWH) //site id
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
		idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')
	
		idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE01', idsGI.getitemstring(llRowPos, 'from_loc'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(idsDOMain.GetItemString(1, 'invoice_no')))
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', idsGI.getitemstring( llRowPos, 'trans_line_no'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(idsDOMain.GetItemString(1, 'do_no')),10))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', String(long(idsGI.getitemstring( llRowPos, 'trans_line_no')),'00000'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'OPENQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDEREDSKUQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'UOM', 'EA')
		idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', idsGI.GetItemString(llRowPos, 'sku'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE03', idsGI.GetItemString(llRowPos, 'from_project')) //Po No
		idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR1', idsGI.GetItemString(llRowPos, 'to_project')) //To Project (UF5)
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'STATUS', 'SHIPPED')
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', idsGI.getitemstring(llRowPos, 'from_loc') +'~~'+idsGI.GetItemString(llRowPos, 'from_project')) //Owner_CD, '~', PO_NO (ex: WHIACBP~MAIN)
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'OPENQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDEREDSKUQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
		idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
	End IF
	
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+idsGI.GetItemString(llRowPos, 'trans_line_no')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	
	If NOT lbShipFromCityBlock and NOT lbShipToCityBlock and NOT ibDejaVu Then
		lsContainerID =  NoNull(idsGI.GetItemString(llRowPos, 'container_id')) 							//Container ID
	Else
		lsContainerID = ''
	End If
	
	lsPONo2 = NoNull(idsGI.GetItemString(llRowPos, 'po_no2'))
	llQuantity = idsGI.GetItemNumber(llRowPos,'quantity')
	ls_line_no = idsGI.getitemstring( llRowPos, 'trans_line_no')
	ls_pick_location = idsGI.getItemString(llRowPos, 'pick_location')
	
	ls_serialized_Ind = idsGI.getItemstring( llRowPos, 'serialized_Ind')
	ls_PONO2ControlledInd = idsGI.getItemstring( llRowPos, 'Po_No2_controlled_Ind')
	ls_ContainerTrackingInd = idsGI.getItemstring( llRowPos, 'container_tracking_Ind')
	
	//If Order is a mixture of LPN /Non-LPN (Re-set serial data store)
	IF ls_serialized_Ind ='B' and ls_PONO2ControlledInd ='Y' and ls_ContainerTrackingInd ='Y' Then
		lbLPN =TRUE
		idsDoSerial.Dataobject = 'd_gi_outbound_serial_footprint'
		idsDoSerial.SetTransObject(SQLCA)
	else
		lbLPN =FALSE
		idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
		idsDoSerial.SetTransObject(SQLCA)
	End IF
	
	//3. Write Serial No Records into OMQ_Warehouse_OrderDetail_Sernum Table
	IF lbLPN THEN
			
		llSerialCount = idsDOSerial.Retrieve(asDoNo,lsPONo2,lsContainerID)  	// Add palletID & cartonID to retrive serial numbers for this LC1
		For llSerialRow = 1 to llSerialCount 
			ll_serial_row =idsOMQWhDOSerial.insertrow( 0)
			
			idsOMQWhDOSerial.setitem( ll_serial_row, 'QACTION', 'I') //Action- I (Insert)
			idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUS', 'NEW')
			idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSDATE', ldtToday)
			idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
			idsOMQWhDOSerial.setitem( ll_serial_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
			idsOMQWhDOSerial.setitem( ll_serial_row, 'CLIENT_ID', ls_client_id)
			idsOMQWhDOSerial.setitem(ll_serial_row, 'SITE_ID', lsWH) //site id
			
			idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDDATE', ldtToday)
			idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDWHO', 'SIMSUSER')
			idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITDATE', ldtToday)
			idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITWHO', 'SIMSUSER')
	
			idsOMQWhDOSerial.setitem(ll_serial_row, 'WH_ORDER_NBR', Right(asdono, 10)) //Do No
			idsOMQWhDOSerial.setitem(ll_serial_row, 'WH_ORDERLINE_NBR', string(idsDOSerial.GetItemNumber(llSerialRow, 'line_item_no'), '00000')) //Line Item No
			idsOMQWhDOSerial.setitem(ll_serial_row, 'SERIALNUMBER', idsDOSerial.GetItemString(llSerialRow,"serial_no")) //Serial No
			idsOMQWhDOSerial.setitem(ll_serial_row, 'CASEID', Right( idsDOSerial.GetItemString(llSerialRow, "carton_serial_no" ), 10 ) ) //Carton No ONLY RIGHT 10!! - Populate scanned Carton No# from Serial Tab.
			idsOMQWhDOSerial.setitem(ll_serial_row, 'SERIALNUMTRANSID', string(gu_nvo_process_files.uf_get_next_seq_no(asproject, 'OMQ_SERIALNUM_TRANS_ID', 'SERIAL_TRANSID'))) //SERIALNUMTRANSID
			
			//07-FEB-2018 :Madhu -S14838 - Foot Prints -Outbound Orders
			//Delete Serial No's from Serial Number Inventory table
			lsSku = idsGI.GetItemString(llRowPos, 'sku')
			lsSerialNo = idsDOSerial.GetItemString(llSerialRow,"serial_no")

			// TAM 2019/05 - S33409 - Populate Serial History Table
			update  Serial_Number_Inventory
			set		Transaction_Type = 'DELIVERY',	Transaction_Id = :asdono, Adjustment_Type = 'SHIPPED'
			where Project_Id= :asproject	and wh_code=:lsWH and sku = :lsSku  and serial_no=:lsSerialNo
			using sqlca;
			commit;
			
			Delete from Serial_Number_Inventory
			WHERE Project_id = :asProject
			and SKU = :lsSku
			and wh_code =:lsWH
			and Serial_no = :lsSerialNo
			Using SQLCA;
			commit;
			
			//Write to File and Screen
			lsLogOut = '      - OM Outbound Confirmation- LPN Serial No of uf_process_gi_om() for Do_No: ' + asdono + '  and SKU: ' +lsSku+ ' and Po_No2: ' +nz(lsPONo2,'-') + ' and Container_Id: ' +nz(lsContainerID,'-')
			lsLogOut += ' Following Serial No: ' +lsSerialNo+ ' and Wh_Code: ' +lsWH+ ' Supposed to be Deleted.'
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

		Next		
		w_main.SetMicroHelp("Processing Purchase Order (ROSE) - LPN LC1 rows complete")
	Else			
		//Serialized nonLPN (pono2_controlled_ind = 'N'  GailM 4/25/14 Any nonLPN will check SNs
		w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Serial Numbers forserialized nonLPN GPN:  " +  idsGI.GetItemString(llRowPos,'SKU') )
		llSerialCount = idsDOSerial.Retrieve(asDoNo) //Re-retrieve
	
		If idsDOSerial.RowCount() > 0  and llQuantity <= idsDOSerial.RowCount() Then		// Already have serial data from last LC1 line and there is another row from the same line_item_no
			//Do nothing 
		Else
			idsDOSerial.Retrieve(asDoNo)		//GailM 5/8/2014 Filter changed to add containerID, 5/15/2014 added l_code to filter.
		End If
		
		If NOT ibDejaVu Then 	// GailM - 8/28/2014 - Issue 883 - ContainerIDs scanned into Serial # tab - No SN1 row
			
			if (isNull(lsContainerID) or trim(lsContainerID) = '') then
				lsContainerID = idsGI.GetItemString(llRowPos, 'container_id') //18-JULY-2018 :Madhu DE5029 - Get container Id from GI Datastore instead NULL value
			end if 

			lsSkuFilter = "SKU = '" + idsGI.GetItemString(llRowPos,'SKU') + "' and #3 = " + ls_line_no +  " and #5 = '" + lsContainerID +  "' and #7 ='" +ls_pick_location+"'"
			
			//18-Oct-2018 :Madhu DE6850 Don't assign duplicate serial No's
			If ls_omq_serial_no > ' ' Then lsSkuFilter += " and serial_no NOT IN ("+ls_omq_serial_no+")"
			
			liRC = idsDOSerial.Setfilter(lsSkuFilter)
			liRC = idsDOSerial.Filter()
	
			If idsDOSerial.Rowcount() > 0 Then
				if llQuantity <= idsDOSerial.Rowcount() then
					llSerialCount = llQuantity
				else
					llSerialCount = idsDOSerial.Rowcount()
				end if
			Else
				llSerialCount = 0
			End iF
			
			For llSkuRow = llSerialCount to 1 Step -1
				lsSerialNo = NoNull(idsDOSerial.GetItemString(llSkuRow, 'serial_no'))		//SerialNo needed outside for serial_number_inventory delete
				lsPndSer = idsGI.GetItemString(llRowPos, 'serial_no') //get Serial No value.
				
				If Upper(lsPndSer) = 'Y' Then	
					ll_serial_row =idsOMQWhDOSerial.insertrow( 0)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QACTION', 'I') //Action- I (Insert)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUS', 'NEW')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
					idsOMQWhDOSerial.setitem( ll_serial_row, 'CLIENT_ID', ls_client_id)
					idsOMQWhDOSerial.setitem(ll_serial_row, 'SITE_ID', lsWH) //site id
					idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDWHO', 'SIMSUSER')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITWHO', 'SIMSUSER')
					idsOMQWhDOSerial.setitem(ll_serial_row, 'WH_ORDER_NBR', Right(asdono, 10)) //Do No
					idsOMQWhDOSerial.setitem(ll_serial_row, 'WH_ORDERLINE_NBR', string(idsDOSerial.GetItemNumber(llSkuRow, 'line_item_no'), '00000')) //Line Item No
					idsOMQWhDOSerial.setitem(ll_serial_row, 'SERIALNUMBER', idsDOSerial.GetItemString(llSkuRow, 'serial_no')) //Serial No
					idsOMQWhDOSerial.setitem(ll_serial_row, 'CASEID', Right(idsDOSerial.GetItemString(llSkuRow, 'carton_serial_no') ,10)) //Carton No - Scanned from Serial Tab
					idsOMQWhDOSerial.setitem(ll_serial_row, 'SERIALNUMTRANSID', string(gu_nvo_process_files.uf_get_next_seq_no(asproject, 'OMQ_SERIALNUM_TRANS_ID', 'SERIAL_TRANSID'))) //SERIALNUMTRANSID
					
					idsDOSerial.DeleteRow(llSkuRow)
					
					//18-Oct-2018 :Madhu DE6850 Add OMQ Serial No's
					If IsNull(ls_omq_serial_no) or ls_omq_serial_no ='' Then
						ls_omq_serial_no ="'"+lsSerialNo+"'"
					else
						ls_omq_serial_no +=",'"+lsSerialNo+"'"
					End If
					
				End if
			
				// Delete serial number from serial number inventory table. Statement removed from above loop on 5/20/2014 - GailM
				lsSku = idsGI.GetItemString(llRowPos, 'sku')
				
				// TAM 2019/05 - S33409 - Populate Serial History Table
				update  Serial_Number_Inventory
				set		 Transaction_Type = 'DELIVERY',	Transaction_Id = :asdono, Adjustment_Type = 'SHIPPED'
				where Project_Id= :asproject	and wh_code=:lsWH and sku = :lsSku  and serial_no=:lsSerialNo
				using sqlca;
				commit;
				
				Delete from Serial_Number_Inventory
				WHERE Project_id = :asProject
				and SKU = :lsSku
				and wh_code =:lsWH
				and Serial_no = :lsSerialNo
				Using SQLCA;
				commit;
				
				//Write to File and Screen
				lsLogOut = '      - OM Outbound Confirmation- Non LPN Serial No of uf_process_gi_om() for Do_No: ' + asdono + '  and SKU: ' +lsSku
				lsLogOut += ' Following Serial No: ' +lsSerialNo+ ' and Wh_Code: ' +lsWH+ ' Supposed to be Deleted.'
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)

			Next
		End If //ibDejaVu
	End If //lbLPN

Next //Next Detail Record

idsOMQWhDOMain.setitem(1, 'LINECOUNT', idsOMQWhDODetail.rowcount( )) //Line count

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Building Package Information of uf_process_gi_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//4. Write Packaging Information into OMQ_WAREHOUSE_ORDERATTR, OMQ_WH_ORDERDETAIL_ATTR
llPackRowCount = idsDOPack.RowCount()

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Building Package Information of uf_process_gi_om() for Do_No: ' + asdono + '  and Pack Row Count: '+ string(llPackRowCount)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If llPackRowCount > 0 Then
	//a. Ship From Address Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFA1')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromAddress') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_wh_name)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_addr1)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_addr2)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_addr3)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
	
	//b. Ship From Location Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFL2')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromLocation') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_city)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_state)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_zip)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_country)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//c.Ship From Contact Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFC3')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromContact') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_contact)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_email)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_tel)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_fax)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//d. Shipment Reference Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SHI4')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipmentIdentifiers') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', trim(idsDOMain.GetItemString(1, 'Vics_Bol_no')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', trim(idsDOMain.GetItemString(1, 'Carrier_Pro_No')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', trim(idsDOMain.GetItemString(1, 'AWB_BOL_No')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
	
	//d.(1) Shipment Measures Construct
	FOR ll_Pack_Row =1 to idsDOPack.RowCount()
		ls_carton_No = upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_no'))
	
		if ls_prev_carton_No <> ls_carton_No Then //don't sumup duplicate carton No.
			ld_total_weight += idsDOpack.GetItemNumber(ll_Pack_Row, 'Weight_Gross')
		end if
	
		ls_prev_carton_No =ls_carton_No //store carton No into Previous value.
	
	Next
	
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SHM5')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipmentMeasures') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', 'LB')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM1', ld_total_weight) //Total_Weight_Gross
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//e. Pallet Construct
	For ll_Pack_Row = 1 to  idsDOPack.RowCount()
		
		ls_carton_No = upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_no'))
		ls_carton_Type= upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_type'))
		ls_Pack_sku = idsDOpack.GetItemString( ll_Pack_Row, 'sku')
		ls_Pack_container_Id = idsDOpack.GetItemString( ll_Pack_Row, 'Pack_Container_Id')	
		
		//10-MAY-2018 :Madhu S19289 -SIMS Mapping of Container ID for Footprints  - START
		//get supplier code from Order Detail
		select Supp_code into :ls_supp_code  from Delivery_Detail with(nolock) 
		where Do_No =:asdono and sku =:ls_Pack_sku
		using sqlca;
	
		lbPallet = FALSE	//re-set value
		lbFootPrintSku = FALSE //re-set value
		lbFootPrintSku = this.uf_is_sku_foot_print(asproject , ls_Pack_sku, ls_supp_code) //Is It Foot Print Item?
		
		//Build Find statement and look for existing Carton No on OMQWhDoAttr data store.
		IF lbFootPrintSku and ls_prev_Po_No2 <> ls_carton_No Then
			lsFind = " REFCHAR3 = '"+ls_carton_No+"'"
			lbPallet = TRUE	//Pallet Record needs to be created

		elseIf lbFootPrintSku and ls_prev_Po_No2 = ls_carton_No and ls_prev_Pack_container_Id <> ls_Pack_container_Id Then
			lsFind = " REFCHAR3 = '"+ls_Pack_container_Id+"'"
			lbPallet = FALSE //Pallet is already created
		else
			
			// 07/19 - PCONKL - F17464/F17595 - For non-Footprints, if the Pack Container ID exists, we are using that as the Carton Number
			If lbFootPrintSku = False and ls_Pack_container_Id <> '' and ls_Pack_container_Id <> '-' and ls_Pack_container_Id <> 'NA' and not isnull(ls_Pack_container_Id) Then
				
				lsFind = " REFCHAR3 = '"+ls_Pack_container_Id+"'" /* rec will be built with REFCHAR3 = Pack Container ID*/
				
			else
				lsFind = " REFCHAR3 = '"+ls_carton_No+"'"		
			End If
			
			lbPallet = TRUE	  //Pallet Record needs to be created
			
		End IF

		llFindRow = idsOMQWhDOAttr.find( lsFind, 1, idsOMQWhDOAttr.rowcount())
	
		If llFindRow = 0 Then //If Record doesn't present, add to data store.
			
			//e.(a) Get sum(PALLET) Qty.
			ld_pallet_qty =0
			lsFind ="upper(carton_type) = 'PALLET' and carton_no ='"+ ls_carton_No +"'"
			ld_pallet_qty = this.uf_get_pallet_carton_qty( lsFind)
			
			//e.(b) Get sum(CARTON) qty
			ld_carton_qty =0
			lsFind ="upper(carton_type) <> 'PALLET' and carton_no ='"+ls_carton_No +"'"
			ld_carton_qty = this.uf_get_pallet_carton_qty( lsFind)
			
			//e.(c) Get sum(Foot Print Carton) Qty.
			ld_pallet_carton_qty =0
			
			// 07/19 - PCONKL - F17464/F17595 - For non-footprints but container tracked (valid value in Pack_Container_ID), we will be building the Carton segment with ld_pallet_carton_qty as well
			IF lbFootPrintSku Then
			
				lsFind ="upper(carton_type) = 'PALLET' and carton_no ='"+ ls_carton_No +"' and Pack_Container_Id ='"+ls_Pack_container_Id+"'"
				ld_pallet_carton_qty =  this.uf_get_pallet_carton_qty( lsFind)
				
			ElseIf lbFootPrintSku = False and ls_Pack_container_Id <> '' and ls_Pack_container_Id <> '-' and ls_Pack_container_Id <> 'NA' and not isnull(ls_Pack_container_Id) Then
				
				lsFind ="carton_no ='"+ ls_carton_No +"' and Pack_Container_Id ='"+ls_Pack_container_Id+"'"
				ld_pallet_carton_qty =  this.uf_get_pallet_carton_qty( lsFind)
				
			END IF
			
			//REFCHAR4
			ls_ship_track_Id = idsDOpack.GetItemString(ll_Pack_Row, 'shipper_tracking_id')

			If isNull(ls_ship_track_Id) or ls_ship_track_Id='' or ls_ship_track_Id=' ' or len(ls_ship_track_Id) =0 Then
				ls_ship_track_Id = trim(idsDOMain.GetItemString(1, 'AWB_BOL_No'))
			End If

			//ll_attr_row =idsOMQWhDOAttr.insertrow(0) - 08/19 - PCONKL - we may have none, one or more attribute records, we'll add them as needed
			
			//e. (c) Pallet/Carton Level Construct
			//24-MAY-2019 :Madhu DE10786 Don't construct PALLET Level, if Carton No = Pack_Container_Id
			IF lbFootPrintSku THEN
				
				//Foot Print - Pallet, Carton and Item Level should be created together.
				If lbPallet  and ls_carton_No <> ls_Pack_container_Id Then
					ll_attr_row =idsOMQWhDOAttr.insertrow(0)
					this.uf_process_gi_om_pallet_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_pallet_qty, ls_carton_No, ls_ship_track_Id, ll_Pack_Row)
					
					llRefch1++
					idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
					ll_Parent_RF1 = llRefch1 //store Patent RF1
					
				End If
		
				//TAM - 2019/06/12 - S34611 - Don't send carton construct if Carton is '-' or 'NA'
				If ls_Pack_container_Id <> '-' and ls_Pack_container_Id <> 'NA' then
					ll_attr_row =idsOMQWhDOAttr.insertrow(0)
					this.uf_process_gi_om_carton_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_pallet_carton_qty, ls_Pack_container_Id, '', ll_Pack_Row)
				
					llRefch1++ //Increment count
					idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) 
					
					//MEA- 2019/07/26 - DE11824 - If Carton_No = Pack_container_ID for that Pack Record, don$$HEX1$$1920$$ENDHEX$$t do the SetItem on the REFCAHR2.
					If ls_carton_No <> ls_Pack_container_Id Then
						idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', string(ll_Parent_RF1)) //store Pallet Id as Parent (Pallet -> Carton -> Item)
					End If
					
				End If
				
			ELSE
				
				//Non-Foot Print
				If ls_carton_Type = 'PALLET' and ls_carton_No <> ls_Pack_container_Id THEN
					
					// 08/19 - PCONKL - DE12269 - Make sure we don't already have a pallet record - we may have been searching by Container above
					lsFind = " REFCHAR3 = '"+ls_carton_No+"'"		
					llFindRow = idsOMQWhDOAttr.find( lsFind, 1, idsOMQWhDOAttr.rowcount())
					
					If llFindRow = 0 Then
						
						ll_attr_row =idsOMQWhDOAttr.insertrow(0)
						this.uf_process_gi_om_pallet_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_pallet_qty, ls_carton_No, ls_ship_track_Id, ll_Pack_Row)
					
						llRefch1++
						idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
						ll_Parent_RF1 = llRefch1 //store Patent RF1
						
					End If /*pallet not already created*/
				
					// 08/19 - PCONKL - F17464/F17595 - Even if it's a pallet, we still want to create a carton segment if there is a valid container ID.
					If  ls_Pack_container_Id <> '' and ls_Pack_container_Id <> '-' and ls_Pack_container_Id <> 'NA' and not isnull(ls_Pack_container_Id) Then
						
						ll_attr_row =idsOMQWhDOAttr.insertrow(0) 
						this.uf_process_gi_om_carton_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_pallet_carton_qty, ls_Pack_container_Id, '', ll_Pack_Row)
						
						llRefch1++
						idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
						
					End If
					
				else /*Not a pallet*/
					
					//07/19 - PCONKL - F17464/F17595 - If Pack_Container_ID has a valid value, we will build the Carton Construct with that value instead of Carton_No
					If  ls_Pack_container_Id <> '' and ls_Pack_container_Id <> '-' and ls_Pack_container_Id <> 'NA' and not isnull(ls_Pack_container_Id) Then
						ll_attr_row =idsOMQWhDOAttr.insertrow(0)
						this.uf_process_gi_om_carton_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_pallet_carton_qty, ls_Pack_container_Id, '', ll_Pack_Row)
					Else
						ll_attr_row =idsOMQWhDOAttr.insertrow(0)
						this.uf_process_gi_om_carton_construct( ll_attr_row, aitransid, ls_client_id, asdono, lsWH, ld_carton_qty, ls_carton_No, ls_ship_track_Id, ll_Pack_Row)
					End If
					
					llRefch1++
					idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
				
				End If
	
				//llRefch1++
				//idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
				
			END IF
			
			lsRefch1 = string(llRefch1) //store parent REFCHAR1 value
			
		else /* Pallet/Carton Attribute record exists*/
			
			lsRefch1 = idsOMQWhDOAttr.getitemstring(llFindRow, 'REFCHAR1') //store parent REFCHAR1 value
			
		End If
	
		//f. Item Level Construct
		ll_Item_Attr_Id++
		ll_attr_detail_row =idsOMQWhDoDetailAttr.insertrow(0)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QACTION','U')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QSTATUS','NEW')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QSTATUSSOURCE','SIMSSWEEPER')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QWMQID',aitransid)
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ATTR_TYPE','ITEMLEVEL') 
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ATTR_ID', 'I'+string(ll_Item_Attr_Id))

		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'CLIENT_ID', ls_client_id)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'SITE_ID', lsWH)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'WH_ORDER_NBR', Right(asdono, 10))
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'WH_ORDERLINE_NBR', string(idsDOpack.GetItemNumber(ll_Pack_Row, 'line_item_no'), '00000')) //Line Item No
		
		llRefch1++
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR1', string(llRefch1)) //Increment count
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR2', lsRefch1) //Parent RefChar1
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR3', idsDOpack.GetItemString(ll_Pack_Row, 'Sku')) //Sku
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR4', ls_carton_No) //Carton No

		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR5', idsDOpack.GetItemString(ll_Pack_Row, 'Country_Of_Origin')) //COO
		
		ls_detail_Find = "sku ='"+ idsDOpack.GetItemString(ll_Pack_Row, 'Sku') +"' and line_item_no ="+ string(idsDOpack.GetItemNumber(ll_Pack_Row, 'line_item_no'))
		ll_detail_find_row = idsDoDetail.find( ls_detail_Find, 1,idsDoDetail.rowcount())
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM1', idsDOpack.GetItemNumber(ll_Pack_Row, 'Quantity')) //Pack Level Qty
		
		IF  ll_detail_find_row > 0 THEN
			idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM2', idsDoDetail.getitemnumber( ll_detail_find_row, 'req_qty')) //Order Level Qty (DD.Ord_Qty)
		ELSE
			ls_detail_Find = "sku ='"+ idsDOpack.GetItemString(ll_Pack_Row, 'Sku') +"'"
			ll_detail_find_row = idsDoDetail.find( ls_detail_Find, 1,idsDoDetail.rowcount())

			IF ll_detail_find_row > 0 Then idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM2', idsDoDetail.getitemnumber( ll_detail_find_row, 'req_qty')) //Order Level Qty (DD.Ord_Qty)
		END IF
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ADDDATE', ldtToday)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ADDWHO','SIMSUSER')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'EDITDATE', ldtToday)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'EDITWHO','SIMSUSER')
		
		ls_prev_Po_No2 = ls_carton_No //Assume, it is a Pallet Id
		ls_prev_Pack_container_Id = ls_Pack_container_Id
		
	NEXT

End If

//6. Update Case Id on Serial Records in OMQ_WH_ORDERDETAIL_SERNUM table.
For llRowPos = 1 to idsOMQWhDoDetailAttr.rowcount( )

	ld_Item_Qty = idsOMQWhDoDetailAttr.getItemNumber( llRowPos, 'REFNUM1') //Item Qty
	
	lsFind ="WH_ORDER_NBR ='"+ idsOMQWhDoDetailAttr.getItemString( llRowPos, 'WH_ORDER_NBR') +"' and WH_ORDERLINE_NBR ='"+ idsOMQWhDoDetailAttr.getItemString( llRowPos, 'WH_ORDERLINE_NBR') +"'"
	lsFind += " and CASEID = '"+ Right(idsOMQWhDoDetailAttr.getItemString( llRowPos, 'REFCHAR4') ,10)+"'"
	
	ll_serial_find_row = idsOMQWhDOSerial.find( lsFind, 1, idsOMQWhDOSerial.rowcount()) //Find Serial Record
	
	DO WHILE ll_serial_find_row > 0 and ld_Item_Qty > 0
		idsOMQWhDOSerial.setItem( ll_serial_find_row, 'CASEID', 'X' + idsOMQWhDoDetailAttr.getItemString( llRowPos, 'REFCHAR1')) //append with char 'X'  to avoid wrong association (Remove Later).
		ll_serial_find_row++

		If ll_serial_find_row > idsOMQWhDOSerial.rowcount( ) Then
			ll_serial_find_row =0
		else
			ll_serial_find_row = idsOMQWhDOSerial.find( lsFind, ll_serial_find_row, idsOMQWhDOSerial.rowcount())				
		End If
	
		ld_Item_Qty = ld_Item_Qty -1 //decrement qty
	LOOP
Next

//6(a). Remove 'X' as first char from Case Id.
For llRowPos = 1 to idsOMQWhDOSerial.rowcount( )
	ls_caseId = Right(idsOMQWhDOSerial.getItemString( llRowPos, 'CASEID'), len(idsOMQWhDOSerial.getItemString( llRowPos, 'CASEID')) - 1)
	idsOMQWhDOSerial.setItem( llRowPos, 'CASEID', ls_caseId)
Next

//7. Update CASE ID of OMQWhDoDetailAttr Records with Pack Container Id Value.
//08-FEB-2018 :Madhu S15632  DE3806 - If Pack Container Id present, map to REFCHAR4
For llRowPos =1 to idsDOpack.rowcount( )
	
	ls_Pack_sku = idsDOpack.getItemString( llRowPos, 'sku')
	
	//get supplier code from Order Detail
	select Supp_code into :ls_supp_code  from Delivery_Detail with(nolock) 
	where Do_No =:asdono and sku =:ls_Pack_sku
	using sqlca;

	lbFootPrintSku = this.uf_is_sku_foot_print(asproject , ls_Pack_sku, ls_supp_code) //Is It Foot Print Item?
		
	lsFind ="REFCHAR4 ='"+idsDOpack.getItemString( llRowPos, 'carton_no')+"'"
	llFindPackRow = idsOMQWhDoDetailAttr.find( lsFind, 1, idsOMQWhDoDetailAttr.rowcount())
	
	If llFindPackRow > 0 Then
		ls_pack_containerId= idsDOpack.getItemString(llRowPos, 'Pack_Container_Id')
		
		IF lbFootPrintSku THEN
			idsOMQWhDoDetailAttr.setitem(llFindPackRow, 'REFCHAR4', lsNull) //Pack Container Id
		ELSE
			If ls_pack_containerId <> '-' Then
				idsOMQWhDoDetailAttr.setitem(llFindPackRow, 'REFCHAR4', ls_pack_containerId) //Pack Container Id
			else
				idsOMQWhDoDetailAttr.setitem(llFindPackRow, 'REFCHAR4', lsNull) //Pack Container Id
			End If
		END IF
	End If	
Next

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;

If idsOMQWhDOMain.rowcount( ) > 0 Then 	ll_rc =idsOMQWhDOMain.update( false, false);		//OMQ_Warehouse_Order
If idsOMQWhDODetail.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQWhDODetail.update( false, false); //OMQ_Warehouse_OrderDetail
If idsOMQWhDOSerial.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOSerial.update( false, false); //OMQ_Wh_Orderdetail_Sernum
If idsOMQWhDOAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOAttr.update( false, false); //OMQ_WAREHOUSE_ORDERATTR
If idsOMQWhDoDetailAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDoDetailAttr.update( false, false); //OMQ_WH_ORDERDETAIL_ATTR

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQWhDOMain.resetupdate( )
		idsOMQWhDODetail.resetupdate( )
		idsOMQWhDOSerial.resetupdate( )
		idsOMQWhDOAttr.resetupdate( )
		idsOMQWhDoDetailAttr.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQWhDOMain.reset( )
		idsOMQWhDODetail.reset()
		idsOMQWhDOSerial.reset()
		idsOMQWhDOAttr.reset( )
		idsOMQWhDoDetailAttr.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If


//5. OMQ_Inventory_Transaction
For llRowPos =1 to idsDOPick.rowcount( )
	
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWH) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who

	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey

	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'WD') //Tran Type as WD (Withdrawal)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM',idsDOPick.getitemstring(llRowPos ,'sku')) //DP.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', idsDOPick.getitemstring(llRowPos ,'owner_owner_cd')) //DP.Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', idsDOPick.getitemstring(llRowPos ,'po_no')) //DP.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (0 - idsDOPick.GetItemNumber(llRowPos,'quantity')))//ITRNKey
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(trim(idsDOMain.GetItemString(1, 'invoice_no')),10)) //DM.Invoice_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', string(idsDOPick.GetItemNumber(llRowPos,'line_item_no'))) //DP.Line_Item_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(idsDOPick.getitemstring(llRowPos ,'do_no'),10) + string (idsDOPick.GetItemNumber(llRowPos,'line_item_no') ,'00000')) //DP.Do_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'PICKING') //Picking
	
Next

//OMQ_Inventory_Transaction
Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then
	ll_rc =idsOMQInvTran.update( false, false);
End IF

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " +  "System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processed Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code: " + string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy idsGI
destroy idsDoMain
destroy idsDoDetail
destroy idsDOPick
destroy idsDoPack
destroy idsDoSerial
destroy idsOMQWhDOMain 
destroy idsOMQWhDODetail 
destroy idsOMQWhDOSerial
destroy idsOMQInvTran
destroy idsOMQWhDOAttr
destroy idsOMQWhDoDetailAttr

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM

Return ll_return_code
end function

public function integer uf_om_adjustment (string asproject, long aladjustid, long altransid);//08-Aug-2017 :Madhu PINT-947 Stock Adjustment

long		llOldQty, llNewQty, llAdjustID, ll_Inv_Row, llRC, llOldOwnerId, llNewOwnerId
string	 	lsSKU, lsWhcode, lsRONO, lsOldPoNo, lsNewPoNo, lsOldOwner_Cd, lsNewOwner_Cd, ls_client_id, lsLogOut, ls_om_enabled, lsAdjType
string		lsOldCoo, lsNewCoo
decimal	ldOMQ_Inv_Tran
boolean  lbIncrementTrans, lbDecrementTrans, lbQtyTrans
datetime ldtToday

Datastore ldsAdjustment

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Adjustment- Start Processing of uf_om_adjustment() for AdjustId: ' + string(alAdjustID)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
	idsOMQInvTran.SetTransObject(om_sqlca)
End If

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id=:asproject using sqlca;

//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = ldsAdjustment.GetITemString(1,'ro_no')

lsSku = ldsAdjustment.GetITemString(1,'sku')
lsWhcode =ldsAdjustment.getItemString(1,'wh_code')
lsAdjType= ldsAdjustment.getItemString( 1, 'Adjustment_Type')

llOldOwnerId = ldsAdjustment.GetITemNumber(1,'old_owner')
lsOldOwner_Cd = ldsAdjustment.getItemString(1,'old_owner_cd')
lsOldPoNo = ldsAdjustment.getitemstring(1, 'old_po_no')
lsOldCoo = ldsAdjustment.getItemString(1,'Old_Country_of_Origin')
llOldQty = ldsAdjustment.GetITemNumber(1,'old_quantity')

llNewOwnerId = ldsAdjustment.GetITemNumber(1,'owner_Id')
lsNewOwner_Cd = ldsAdjustment.getItemString(1,'new_owner_cd')
lsNewPoNo = ldsAdjustment.getitemstring(1, 'po_no')
lsNewCoo = ldsAdjustment.getItemString(1,'Country_of_Origin')
llNewQty = ldsAdjustment.GetITemNumber(1,'quantity')

llAdjustID = ldsAdjustment.GetITemNumber(1,'adjust_no')

select OM_Enabled_Ind into :ls_om_enabled from Warehouse with(nolock) where wh_code =:lsWhcode using sqlca;

If upper(ls_om_enabled) <> 'Y' Then
	//Write to File and Screen
	lsLogOut = '      - OM Adjustment- Processing of uf_om_adjustment() for AdjustId: ' + string(alAdjustID) + ' Warehouse: '+lsWhcode+' is not enabled for OM'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Initialize variables
lbIncrementTrans =FALSE 
lbDecrementTrans = FALSE
lbQtyTrans =FALSE

//Adjustment Transaction criteria
IF  ((llNewQty <> lloldQty)  and upper(lsAdjType) = 'Q') Then //Qty changes
	lbQtyTrans =TRUE
	
elseIf lsOldCoo <> lsNewCoo Then 	//13-Dec-2018 :Madhu DE7687 don't write if COO changes.
	lbIncrementTrans =FALSE
	lbDecrementTrans = FALSE
else				//Owner / Project code changes
	lbIncrementTrans =TRUE
	lbDecrementTrans = TRUE
End IF

//Write records into OMQ_Inventory_Transaction Table

//Decrement Adjustment Record	
If (lbDecrementTrans = TRUE) Then
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	If llNewQty = llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - llOldQty) //Adjustment.Old_Qty
	elseIf llOldQty > llNewQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - (llOldQty - llNewQty)) //Adjustment.Old_Qty - Adjustment.Qty
	elseIf llNewQty > llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - (llNewQty - llOldQty)) //Adjustment.Old_Qty - Adjustment.Qty
	End If
	
	//12-Dec-2018 :Madhu DE7687 change Trantype from WD to AJ
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Withdrawl)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOldOwner_Cd) //Adjustment.Old_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsOldPoNo) //Adjustment.Old_Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjustment Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', string(aladjustid)) //Adjustment.Adjustment Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
End If

//Increment Adjustment Record
If (lbIncrementTrans = TRUE) Then
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', today()) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	If llNewQty = llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llNewQty) //Adjustment.Qty
	elseIf llOldQty > llNewQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (llOldQty - llNewQty)) //Adjustment.Old_Qty - Adjustment.Qty
	elseIf llNewQty > llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (llNewQty - llOldQty)) //Adjustment.Qty - Adjustment.Old_Qty
	End If
	
	//12-Dec-2018 :Madhu DE7687 change Trantype from DP to AJ
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Deposit)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwner_Cd) //Adjustment.New_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsNewPoNo) //Adjustment.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	
End If

//Qty change Adjustment Record
If (lbQtyTrans =TRUE) Then
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwner_Cd) //Adjustment.New_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsNewPoNo) //Adjustment.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llNewQty - llOldQty) //Adjustment.Qty - Adjustment.Old_Qty
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', string(aladjustid)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'CYCLE') //Reason code
End If

Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then
	llRC =idsOMQInvTran.update( false, false);
End IF

If llRC =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Adjustment - Processing of uf_om_adjustment() for AdjustId: ' + string(alAdjustID) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Adjustment - Processing of uf_om_adjustment() for AdjustId: ' + string(alAdjustID) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

this.uf_om_sn_adjustment( asproject, altransid, string(alAdjustID), string(ldOMQ_Inv_Tran)) //Insert SN Records.

destroy idsOMQInvTran
gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0
end function

public function integer uf_process_gr_om (string asproject, string asrono, long aitransid, string astransparm, string asaction);//07-JULY-2017 :Madhu - Added for PINT-861 - Goods Receipt Confirmation.
//Write records back into OMQ Tables.

String		lsFind,  lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN,lsLineParm
String   	lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_line_no
string		lsInvoice, lsRONO, lsPndSer, lsSku, lsPrevSku, ls_client_id, lsSkipProcess
String 	ls_oracle_integrated, lsClientCustPONbr, lsToLoc, ls_awb_bol, lsSkipProcess2
String		ls_OM_Type, lsOrderNo, ls_gmt_offset, ls_receive_putaway_serial_rollup_ind

Decimal	 ldOwnerID, ldOwnerID_Prev, ldTransID, ldOMQ_Inv_Tran
DateTime ldtTemp, ldtToday
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow, ll_detail_row, ll_return_code
Long 		ll_change_req_no, ll_serial_row, ll_rc, ll_batch_seq_no, ll_Inv_Row, llDetailQty, ll_orig_batch_seq_no
Boolean 	lbParmFound, lbAddHeader

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- Start Processing of uf_process_gr_om() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

select User_Updateable_Ind
into :lsSkipProcess
from lookup_table
where project_id = 'PANDORA'
and code_type = 'SKIP_PROCESS'
and code_ID = 'Shipment_Distribution_No'
using sqlca;

select OM_Client_Id, receive_putaway_serial_rollup_ind 
	into :ls_client_id, :ls_receive_putaway_serial_rollup_ind
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsROmain) Then
	idsROmain = Create u_ds_datastore
	idsROmain.Dataobject = 'd_ro_master'
End If
idsROMain.SetTransObject(SQLCA)
	
If Not isvalid(idsroDetail) Then
	idsroDetail = Create u_ds_datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
End If
idsroDetail.SetTransObject(SQLCA)

If Not isvalid(idsroputaway) Then
	idsroputaway = Create u_ds_datastore
	//12-APR-2019 :Madhu S31783 Foot Print Putaway Serial RollUp
	IF ls_receive_putaway_serial_rollup_ind ='Y' THEN
		idsroputaway.Dataobject = 'd_ro_putaway_serial'
	ELSE
		idsroputaway.Dataobject = 'd_ro_putaway'
	END IF
	
End If
idsroputaway.SetTransObject(SQLCA)
	
If Not isvalid(idsOMQROMain) Then
	idsOMQROMain =Create u_ds_datastore
	idsOMQROMain.Dataobject ='d_omq_receipt'
End If
idsOMQROMain.settransobject(om_sqlca)
	
If Not isvalid(idsOMQRODetail) Then
	idsOMQRODetail =Create u_ds_datastore
	idsOMQRODetail.Dataobject ='d_omq_receipt_detail'
End If
idsOMQRODetail.settransobject(om_sqlca)
	
If Not isvalid(idsOMQROSerial) Then
	idsOMQROSerial =Create u_ds_datastore
	idsOMQROSerial.Dataobject ='d_omq_receipt_detail_sernum'
End If
idsOMQROSerial.settransobject(om_sqlca)
	
If Not isvalid(idsOMExp) Then
	idsOMExp =Create u_ds_datastore
	idsOMExp.Dataobject ='d_om_expansion'
End If	
idsOMExp.settransobject(SQLCA)
	
If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =Create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)

idsGR.Reset()
idsOMQROMain.reset()
idsOMQRODetail.reset()
idsOMQROSerial.reset()
idsOMExp.reset()
idsOMQInvTran.reset()

//Write to File and Screen
lsLogOut = "    OM Inbound Confirmation - Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsToLoc = idsRoMain.GetItemString(1,'User_field2')
If Not isnull(lsToLoc) Then
	select user_field1 into :lsGroup
	from customer
	where project_id = :asProject and cust_code = :lsToLoc;
	
	If Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GR Suppressed for MIM Owned-Inventory transaction For RO_NO: " + asRONO + ". No GR is being created for this order."
		FileWrite(gilogFileNo, lsLogOut)
		Return 0
	End IF
	
End IF

lsWH = idsROMain.GetItemString(1, 'wh_code')
ll_change_req_no = idsROMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsROMain.getitemnumber(1,'EDI_Batch_Seq_No')

select  GMT_Offset
into  :ls_gmt_offset
from Warehouse with(nolock)
where wh_Code=:lsWH
using sqlca;

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

//idsROPutaway.Filter()
llRowCount = idsROPutaway.RowCount()

idsOMExp.retrieve(ll_batch_seq_no) //Retrieve OM_Expansion_Table records

//Get values of TYPE and RECEIPT_TYPE
lsFind ="Column_Name ='TYPE'"
llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())

// 08/29/17 - PCONKL - Deal with missing expansion records...
//								If expansion records missing, retrieve for the original order, mif still missing, default to blank

if llFindRow > 0 Then
	
	ls_OM_Type =idsOMExp.getitemstring(llFindRow,'Column_value')
	
Else /* get from original order*/
	
		lsorderNo = trim(idsROMain.GetItemString(1, 'supp_invoice_no'))
		lsClientCustPONbr =  trim(idsROMain.GetItemString(1, 'Client_Cust_PO_NBR'))
		
		Select min(edi_batch_seq_no) into :ll_orig_batch_seq_no
		From Receive_master
		Where Project_id = 'PANDORA' and supp_invoice_no = :lsOrderNo;
		
		If ll_orig_batch_seq_no > 0 Then
			
			idsOMExp.retrieve(ll_orig_batch_seq_no) //Retrieve OM_Expansion_Table records from original order
			
			llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())
			If llFindRow > 0 Then
				ls_OM_Type =idsOMExp.getitemstring(llFindRow,'Column_value')
			Else
				ls_OM_Type =this.uf_process_om_receipt_type( asproject, asrono, lsClientCustPONbr)
			End If
			
		Else
			ls_OM_Type = this.uf_process_om_receipt_type( asproject, asrono, lsClientCustPONbr)
		End If
		
End If


// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

For llRowPos = 1 to llRowCount
	
	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no' ) )
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )

	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if

	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no' ) )
	lsDetailFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU' ) ) + "'"
	lsDetailFind += " and line_item_no = " + ls_line_no
		
	llDetailFindRow = idsRODetail.Find(lsDetailFind, 1, idsRODetail.RowCount())

	if llDetailFindRow > 0 then
		If isnull(idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')) or idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no') = '' Then
			ls_line_no =  string(idsRODetail.GetItemNumber(llDetailFindRow, 'line_item_no'))
		Else
			ls_line_no =  idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')
		End If
	end if
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU')) + "'"

	lsFind += " and trans_line_no = '" + ls_line_no + "'"
	lsFind += " and upper(to_project) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'po_no')) + "'"
	lsFind += " and upper(serial_no) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'serial_no')) + "'"

	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		ldOwnerID = idsROPutaway.GetItemNumber(1, 'owner_id')
		if ldOwnerID <> ldOwnerID_Prev then
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;
			ldOwnerID_Prev = ldOwnerID
			
			select user_field1, user_field5 
			into :lsGroup, :ls_oracle_integrated
			from customer
			where project_id = :asProject and cust_code = :lsOwnerCd;
			if left(lsGroup, 3) = 'GIG' then 
				lsGigYN = 'Y'
			else
				lsGigYN = 'N'
			end if
			
			lsTransYN = 'Y'	
		end if
				
		//Step 1. Checking Pandora Serial
		lsSku = upper(idsROPutaway.GetItemString(llRowPos, 'SKU'))
		If lsSku <> lsPrevSku Then
					Select 	User_field18 into :lsPndSer
					From		Item_Master 
					where 	project_id = :asProject and
								sku = :lsSku 
					Using SQLCA;
		End If
		lsPrevSku = lsSku

		if lsTransYN = 'Y' then
			llNewRow = idsGR.InsertRow(0)
			idsGR.SetItem(llNewRow, 'trans_id', right(trim(idsROMain.GetItemString(1, 'ro_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			lsTransType = trim(idsROMain.GetItemString(1, 'user_field7'))
			idsGR.SetItem(llNewRow, 'from_loc', upper(trim(idsROMain.GetItemString(1, 'user_field6'))))
			idsGR.SetItem(llNewRow, 'to_loc', upper(trim(lsOwnerCD)))
			
			idsGR.SetItem(llNewRow, 'complete_date', idsROMain.GetItemDateTime(1, 'complete_date'))
			idsGR.SetItem(llNewRow, 'sku', idsROPutaway.GetItemString(llRowPos, 'sku'))
			lsFromProject = idsroDetail.GetItemString(llDetailFindRow, 'User_Field2')
			idsGR.SetItem(llNewRow, 'from_project', trim(idsroDetail.GetItemString(llDetailFindRow, 'user_field2')))
			idsGR.SetItem(llNewRow, 'to_project', trim(idsROPutaway.GetItemString(llRowPos, 'po_no')))
			idsGR.SetItem(llNewRow, 'trans_type', lsTransType)  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGR.SetItem(llNewRow, 'trans_source_no', trim(idsROMain.GetItemString(1, 'supp_invoice_no')))
			 If isnull(ls_line_no) or ls_line_no = '' Then
				idsGR.SetItem(llNewRow, 'trans_line_no', idsroDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
			Else
				idsGR.SetItem(llNewRow, 'trans_line_no', ls_line_no)
			End If

			If Trim( idsROPutaway.GetItemString(llRowPos, 'serial_no') ) <> '-' Then
				idsGR.SetItem(llNewRow, 'serial_no', idsROPutaway.GetItemString(llRowPos, 'serial_no'))
			else
				idsGR.SetItem(llNewRow, 'serial_no', '-')
			end if
			
			idsGR.SetItem(llNewRow, 'Container_ID', idsROPutaway.GetItemString(llRowPos, 'Container_ID'))
			idsGR.SetItem(llNewRow, 'PO_NO2', idsROPutaway.GetItemString(llRowPos, 'PO_NO2'))
			
			idsGR.SetItem(llNewRow, 'quantity', idsROPutaway.GetItemNumber(llRowPos, 'quantity'))
			idsGR.SetItem(llNewRow, 'Shipment_Distribution_No', idsROPutaway.GetItemString(llRowPos, 'Shipment_Distribution_No'))

			// 04/09 - PCONKL - Remove any carriage returns/Line feeds from Remarks - they cause the files to fail in ICC
			lsRemarks = trim(idsROMain.GetItemString(1, 'remark'))
			
			Do While pos(lsRemarks,"~t") > 0 /*tab*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~t"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~n") > 0 /*New line*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~n"),1," ")
			Loop
			
			Do While pos(lsRemarks,"~r") > 0 /*CR*/
				lsRemarks = Replace(lsRemarks, pos(lsRemarks,"~r"),1," ")
			Loop
			
			idsGR.SetItem(llNewRow, 'reference', NoPipe(lsRemarks))
			idsGR.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'

			idsGR.SetItem(llNewRow, 'awb_bol_no', idsROMain.GetItemString(1, 'awb_bol_no'))
			idsGR.SetItem(llNewRow, 'cost_center', idsROMain.GetItemString(1, 'user_field12'))
			idsGR.SetItem(llNewRow, 'ship_ref', idsROMain.GetItemString(1, 'ship_ref'))
			idsGR.SetItem(llNewRow, 'container_id', idsROPutaway.GetItemString(llRowPos, 'container_id'))
			idsGR.SetItem(llNewRow, 'lot', idsROPutaway.GetItemString(llRowPos, 'lot_no'))
			
			if upper(trim(lsTransType)) = 'PO RECEIPT' or upper(trim(lsTransType)) = 'EXP PO RECEIPT' then 
				idsGR.SetItem(llNewRow, 'country_of_dispatch', idsROmain.GetItemString(1, 'user_field5'))
			end if

			lsClientCustPONbr =  NoNull(idsROMain.GetItemString(1, 'Client_Cust_PO_NBR'))
			If  lsClientCustPONbr = "" then
				idsGR.SetItem(llNewRow, 'Client_Cust_PO_NBR', lsInvoice) 
			Else
				idsGR.SetItem(llNewRow, 'Client_Cust_PO_NBR', trim(lsClientCustPONbr)) 
			End If
				
			idsGR.SetItem(llNewRow, 'Vendor_Invoice_Nbr', trim(idsROMain.GetItemString(1, 'Vendor_Invoice_Nbr'))) 
			idsGR.setitem(llNewRow, 'coo', idsROPutaway.getitemstring(llRowPos, 'Country_of_Origin')) //coo
	
		end if
	End If
	skipDetailRow:
Next /* Next Putaway record */

lbAddHeader =TRUE

//Write the rows to respective OMQ Tables
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCount
	
	//1. ADD OMQ_RECEIPT Tables
	IF lbAddHeader =TRUE Then //Add Header Record against 1st row.

	 	idsOMQROMain.insertrow( 0)
	 	ldtTemp = idsGR.GetItemDateTime(llRowPos, 'complete_date')
		
		idsOMQROMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
		idsOMQROMain.setitem(1,'CLIENT_ID',ls_client_id)
		idsOMQROMain.setitem(1, 'QACTION', asaction) //Action
		
		If upper(asaction) ='I' Then
			idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
			idsOMQROMain.setitem(1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
			idsOMQROMain.setitem(1, 'STATUS', 'NOTRECVD') //Status
		else
			idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
			idsOMQROMain.setitem(1, 'QWMQID', aitransid +.1) //Set with Batch_Transaction.Trans_Id
			idsOMQROMain.setitem(1, 'STATUS', '9') //Status
		End If
		
		idsOMQROMain.setitem(1, 'RECEIPTKEY', Right(asrono,10)) //Receipt Key
		idsOMQROMain.setitem(1, 'SITE_ID', lsWH) //site id
			
		idsOMQROMain.setitem( 1, 'EXTERNRECEIPTKEY', idsGR.GetItemString(llRowPos, 'Client_Cust_PO_NBR' )) //client_cust_po_nbr
		idsOMQROMain.setitem( 1, 'EXTERNALRECEIPTKEY2', idsGR.GetItemString(llRowPos, 'trans_source_no')) //supp_invoice_no
		idsOMQROMain.setitem( 1, 'RECEIPTDATE', ldtTemp) //trans_date
		idsOMQROMain.setitem( 1, 'REFCHAR1', idsGR.GetItemString(llRowPos, 'cost_center')) //UF12
		
		idsOMQROMain.setitem( 1, 'PLACE_OF_DISCHARGE', idsGR.GetItemString(llRowPos, 'from_loc')) //UF6
		idsOMQROMain.setitem( 1, 'VENDORID', left(idsGR.GetItemString(llRowPos, 'from_loc'),10)) //UF6
		idsOMQROMain.setitem( 1, 'TYPE', ls_OM_Type) //Type
		
		idsOMQROMain.setitem( 1, 'SUSR1',  idsGR.GetItemString(llRowPos, 'awb_bol_no')) 	//Awb Bol No
		idsOMQROMain.setitem( 1, 'SUSR2', idsGR.GetItemString(llRowPos, 'Vendor_Invoice_Nbr' )) //Vendor Invoice Nbr
		idsOMQROMain.setitem( 1, 'SUSR3', this.gmtformatoffset(ls_gmt_offset)) //Warehouse.GMT_Offset
		//idsOMQROMain.setitem( 1, 'LINECOUNT',  llRowCount) 	//Line Count
		
		idsOMQROMain.setitem(1, 'ADDDATE', today()) //add_date
		idsOMQROMain.setitem(1, 'ADDWHO', 'SIMSUSER') //add_who
		idsOMQROMain.setitem(1, 'EDITDATE', today()) //edit_date
		idsOMQROMain.setitem(1, 'EDITWHO', 'SIMSUSER') //edit_who
		
				//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Header Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	End IF
	
	//2. ADD OMQ_RECEIPTDETAIL Tables
	//Roll Up Detail records for same attribute values.
	
	If (not isnull(idsGR.GetItemString(llRowPos, 'trans_source_no')) and len(idsGR.GetItemString(llRowPos, 'trans_source_no')) > 0) Then lsFind = "EXTERNRECEIPTKEY = '" + idsGR.GetItemString(llRowPos, 'Client_Cust_PO_NBR') + "'"
	If (not isnull(idsGR.GetItemString(llRowPos, 'sku')) and len(idsGR.GetItemString(llRowPos, 'sku')) > 0) Then lsFind += " and ITEM = '" + upper(idsGR.GetItemString(llRowPos, 'sku')) + "'"
	If (not isnull(idsGR.GetItemString(llRowPos, 'trans_line_no')) and len(idsGR.GetItemString(llRowPos, 'trans_line_no')) > 0) Then lsFind += " and EXTERNLINENO = '" +  idsGR.GetItemString(llRowPos, 'trans_line_no') + "'"
	If (not isnull(idsGR.GetItemString(llRowPos, 'to_loc')) and len(idsGR.GetItemString(llRowPos, 'to_loc')) > 0) Then 	lsFind += " and LOTTABLE01 = '" + 	idsGR.GetItemString(llRowPos, 'to_loc') + "'"
	If (not isnull(idsGR.GetItemString(llRowPos, 'to_project')) and len(idsGR.GetItemString(llRowPos, 'to_project')) > 0) Then lsFind += " and LOTTABLE03 = '" + upper(idsGR.GetItemString(llRowPos, 'to_project')) + "'"
	If (not isnull(idsGR.GetItemString(llRowPos, 'from_project')) and len(idsGR.GetItemString(llRowPos, 'from_project')) > 0) Then lsFind += " and SUSR1 = '" + upper(idsGR.GetItemString(llRowPos, 'from_project')) + "'"

	IF idsOMQRODetail.RowCount() > 0 Then 	
		llDetailFindRow = idsOMQRODetail.Find(lsFind,1,idsOMQRODetail.RowCount())
		If llDetailFindRow >0 Then 
			llDetailQty = idsOMQRODetail.GetItemNumber(llDetailFindRow,'QTYRECEIVED')
		else
			llDetailFindRow = 0
		End If
		
	else
		llDetailFindRow = 0
	End IF
	
	If llDetailFindRow = 0 Then
		ll_detail_row = idsOMQRODetail.insertrow( 0)
		idsOMQRODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
		idsOMQRODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id) //client_Id
		idsOMQRODetail.setitem( ll_detail_row, 'QACTION', asaction) //Action
		
		If upper(asaction) ='I' Then
			idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
			idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
			idsOMQRODetail.setitem(ll_detail_row, 'STATUS', 'NOTRECVD') //Status
		else
			idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
			idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', aitransid +.1) //Set with Batch_Transaction.Trans_Id
			idsOMQRODetail.setitem(ll_detail_row, 'STATUS', '9') //Status
		End If
			
		idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTKEY', Right(asrono,10)) //Receipt Key
		idsOMQRODetail.setitem( ll_detail_row, 'SITE_ID', lsWH) //site id
		
		idsOMQRODetail.setitem( ll_detail_row, 'EXTERNRECEIPTKEY', idsGR.GetItemString(llRowPos, 'Client_Cust_PO_NBR')) //client cust po nbr
		idsOMQRODetail.setitem( ll_detail_row, 'EXTERNLINENO', idsGR.GetItemString(llRowPos, 'trans_line_no')) //user_line_item_no
		idsOMQRODetail.setitem( ll_detail_row, 'ITEM', upper(idsGR.GetItemString(llRowPos, 'sku'))) //sku
		idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE01', idsGR.GetItemString(llRowPos, 'to_loc')) //to_location
		idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE03', upper(idsGR.GetItemString(llRowPos, 'to_project'))) //Po_No
		idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE07', upper(idsGR.GetItemString(llRowPos, 'coo'))) //COO
		idsOMQRODetail.setitem( ll_detail_row, 'QTYRECEIVED', idsGR.GetItemNumber(llRowPos,'quantity')) //QTY
		idsOMQRODetail.setitem( ll_detail_row, 'SUSR1', upper(idsGR.GetItemString(llRowPos, 'from_project'))) //From Project -UF2
		idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTLINENUMBER', Right(idsGR.GetItemString(llRowPos, 'trans_line_no'),5)) //Receipt Line Nbr
		idsOMQRODetail.setitem( ll_detail_row, 'UOM', 'EA') //UOM
		idsOMQRODetail.setitem( ll_detail_row, 'ADDDATE', Date(today())) //add_date
		idsOMQRODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER') //add_who
		idsOMQRODetail.setitem( ll_detail_row, 'EDITDATE', Date(today())) //edit_date
		idsOMQRODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER') //edit_who
	else
		idsOMQRODetail.setitem( ll_detail_row, 'QTYRECEIVED', idsGR.GetItemNumber(llRowPos,'quantity') +llDetailQty) //QTY
	End If
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+idsGR.GetItemString(llRowPos, 'trans_line_no')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//3. ADD OMQ_RECEIPTDETAIL_SERNUM Tables only for QACTION =U
	If (idsGR.GetItemString(llRowPos, 'serial_no') <> '-'  and  upper(asaction) ='U') Then
		ll_serial_row = idsOMQROSerial.insertrow( 0)
		idsOMQROSerial.setitem( ll_serial_row, 'QACTION', 'I') //Action
	
		idsOMQROSerial.setitem( ll_serial_row, 'QSTATUS', 'NEW') //Status
		idsOMQROSerial.setitem( ll_serial_row, 'QWMQID', aitransid +.1) //Set with Batch_Transaction.Trans_Id
		
		idsOMQROSerial.setitem( ll_serial_row, 'SITE_ID', lsWH) //site id
		idsOMQROSerial.setitem( ll_serial_row, 'SERIAL_NUMBER', idsGR.GetItemString(llRowPos, 'serial_no')) //serial_no
		idsOMQROSerial.setitem( ll_serial_row, 'RECEIPTKEY', Right(asrono,10)) //ro_no
		idsOMQROSerial.setitem( ll_serial_row, 'RECEIPTLINENBR', idsGR.GetItemString(llRowPos, 'trans_line_no')) //user_line_item_no
		idsOMQROSerial.setitem( ll_serial_row, 'CLIENT_ID', ls_client_id) //client_Id
		idsOMQROSerial.setitem( ll_serial_row, 'ADDDATE', today()) //add_date
		idsOMQROSerial.setitem( ll_serial_row, 'ADDWHO', 'SIMSUSER') //add_who
		idsOMQROSerial.setitem( ll_serial_row, 'EDITDATE', today()) //edit_date
		idsOMQROSerial.setitem( ll_serial_row, 'EDITWHO', 'SIMSUSER') //edit_who
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no)
		lsLogOut +=  "   Line_Item_No: "+idsGR.GetItemString(llRowPos, 'trans_line_no')+ "    Serial_No: " +idsGR.GetItemString(llRowPos, 'serial_no')
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

	end If
	
	lbAddHeader =FALSE //only one time
	
next /*next output record */

idsOMQROMain.setitem( 1, 'LINECOUNT',   idsOMQRODetail.rowcount()) 	//Line Count - Set Detail Record count

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQROMain.rowcount( ) > 0 Then	ll_rc =idsOMQROMain.update( false, false);
If idsOMQRODetail.rowcount( ) > 0 and ll_rc =1 Then 	ll_rc =idsOMQRODetail.update( false, false);
If idsOMQROSerial.rowcount( ) > 0 and ll_rc =1 Then 	ll_rc =idsOMQROSerial.update( false, false);

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQROMain.resetupdate( )
		idsOMQRODetail.resetupdate( )
		idsOMQROSerial.resetupdate();
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQROMain.reset( )
		idsOMQRODetail.reset( )
		idsOMQROSerial.reset();
		//MessageBox("ERROR", om_sqlca.SQLErrText)
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " is failed to write records to OM: "+ om_sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		Return -1
	end if

else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//MessageBox("ERROR", "System error, record save failed!")
	Return -1
End If


//Write to File and Screen
lsLogOut = '      - OM Inbound Transaction- Writing Inventory Transaction record for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If upper(asaction) ='U' Then
	//OMQ_Inventory_Transaction
	For llRowPos =1 to  idsROPutaway.RowCount()
		ll_Inv_Row = idsOMQInvTran.insertrow(0)
		
		idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
		idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
		idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
		idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
		idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWH) //site id
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Edit Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Edit who
	
		ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
		idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'DP') //Tran Type as DP (Deposit)
		idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', idsroputaway.getitemstring(llRowPos ,'sku')) //RP.Sku
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', idsroputaway.getitemstring(llRowPos ,'owner_cd')) //RP.Owner_Cd
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', idsroputaway.getitemstring(llRowPos ,'po_no')) //RP.Po_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', idsROPutaway.GetItemNumber(llRowPos,'quantity')) //ITRNKey
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(trim(idsROMain.GetItemString(1, 'supp_invoice_no')),10)) //RM.Supp_Invoice_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', Right(string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no')),5)) //RP.Line_Item_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', idsroputaway.getitemstring(llRowPos ,'ro_no') + string (idsROPutaway.GetItemNumber(llRowPos,'line_item_no') ,'0000')) //RP.Ro_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'PUTAWAY') //Putaway
	
	Next
	
	//storing into DB
	Execute Immediate "Begin Transaction" using om_sqlca;
	
	If idsOMQInvTran.rowcount( ) > 0 Then
		ll_rc =idsOMQInvTran.update( false, false);
	End IF
	
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTran.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQInvTran.reset( )
			//Write to File and Screen
			lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Error:  "+ om_sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Error: "+ om_sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
End If //QACTION ='U'

ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code "+ string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy idsOMQROMain
destroy idsOMQRODetail
destroy idsOMQROSerial
destroy idsOMQInvTran

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OT29 DB

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- End Processing of uf_process_gr_om() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return ll_return_code
end function

public function integer uf_process_serial_change_om (string asproject);//22-Aug-2017 :Madhu PINT-947 - Serial No Adjustment

Datastore	ldsOC
Long 		ll_InvTxn_row, ll_Inv_Row, llid_no, llRowPos, llRowCount, llRC
string 	ls_client_Id, lslogOut, sql_syntax, ERRORS, lsOwnerCD, ls_poNo, ls_wh, ls_sku
string		ls_to_serialno, ls_from_serialno, ls_from_poNo, ls_Old_Po_No
Decimal		ldBatchSeq, ldownerid, ldOMQ_Inv_Tran1, ldOMQ_Inv_Tran2
DateTime	ldtToday


ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Adjustment (SN change)- Start Processing of uf_process_Serial_change_om ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
End If
idsOMQInvTran.SetTransObject(om_sqlca)

If Not isvalid(idsOMQInvTxnSernum) Then
	idsOMQInvTxnSernum = Create u_ds_datastore
	idsOMQInvTxnSernum.Dataobject = 'd_omq_inventory_txn_sernum'
End If
idsOMQInvTxnSernum.SetTransObject(om_sqlca)
	
//Create the Owner Change datastore
ldsOC = Create Datastore

sql_syntax = "SELECT Wh_Code, Complete_Date, Id_No, Owner_Id,   Po_No, Sku, From_Serial_No,  To_Serial_No, Old_Po_No "  
sql_syntax += " FROM Item_Serial_Change_History  with(nolock)"
sql_syntax += " WHERE Transaction_Sent is NULL "
sql_syntax += "  AND Wh_Code IN ( SELECT wh_code FROM Warehouse with(nolock) WHERE OM_Enabled_Ind = 'Y');"

ldsOC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
	lsLogOut = "         OM Adjustment (SN change) -  Unable to create datastore for PANDORA Serial Number Change Transaction.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsOC.SetTransObject(SQLCA)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = "-  OM Adjustment (SN change) -  PROCESSING FUNCTION: PANDORA Serial Number Change Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve the OC Data
lsLogout = '- OM Adjustment (SN change) - Retrieving Serial Number Change.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsOC.Retrieve(asproject)

lsLogOut = " -OM Adjustment (SN change) - "+String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '|'
lsLogOut = ' OM Adjustment (SN change) - Processing Serial Number Change Confirmation.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

select OM_Client_Id into :ls_client_Id from Project where Project_Id= :asproject
using sqlca;

For llRowPos = 1 to llRowCount
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	sqlca.sp_next_avail_seq_no('PANDORA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
	commit;
	
	If ldBatchSeq <= 0 Then
		lsLogOut = "   OM Adjustment (SN change) - Unable to retrieve next available sequence number for PANDORA Serial Number Change confirmation."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		Return -1
	End If
	
	ldOwnerID = ldsOC.GetItemNumber(llRowPos, 'owner_id')
	
	select owner_cd into :lsOwnerCD
	from owner with(nolock)
	where project_id = :asProject and owner_id = :ldOwnerID
	using sqlca;
	
	ls_wh = ldsOC.GetItemString(llRowPos, 'Wh_Code') //wh code
	ls_sku= ldsOC.GetItemString(llRowPos, 'Sku') //sku
	ls_from_serialno =ldsOC.GetItemString(llRowPos, 'From_Serial_No')
	ls_to_serialno =ldsOC.GetItemString(llRowPos, 'To_Serial_No')
	
	ls_from_poNo = ldsOC.GetItemString(llRowPos, 'Po_No') //poNo
	
	ls_Old_Po_No = ldsOC.GetItemString(llRowPos, 'Old_Po_No') //poNo
	
	If (not IsNull(ls_to_serialno) and ls_to_serialno <> '-' ) then
		select po_no into :ls_poNo from Serial_Number_Inventory with(nolock)
		where wh_code=:ls_wh
		and sku= :ls_sku
		and Owner_Cd =:lsOwnerCD
		and Serial_No =:ls_to_serialno
		using sqlca;
	End If

	If isNull(ls_poNo) or ls_poNo='' or ls_poNo=' ' or len(ls_poNo) =0 Then
		ls_poNo = ls_from_poNo //poNo
	End If
	
	If isNull(ls_from_poNo) or ls_from_poNo='' or ls_from_poNo=' ' or len(ls_from_poNo) =0 Then
		ls_from_poNo = ls_poNo //poNo
	End If
		
	llid_no =ldsOC.GetItemNumber(llRowPos, 'Id_No')
	
	IF IsNull(ls_from_serialno) OR IsNull(ls_to_serialno) OR (ls_from_serialno <> ls_to_serialno ) THEN
	
		//A. Write OMQ_Inventory_Transaction Record (Decrement)
		IF (not IsNull(ls_from_serialno) and ls_from_serialno <> '-' ) Then
			ll_Inv_Row = idsOMQInvTran.insertrow( 0)
			idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
			idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
			idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
			idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
			idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', llid_no) //Set with Item_serial_histroy.Id_No
			idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', ls_wh) //site id
			idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
			idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Edit Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Edit who
			idsOMQInvTran.setitem( ll_Inv_Row, 'CLIENT_ID', ls_client_Id)
			
			ldOMQ_Inv_Tran1 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
			idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran1)) //ITRNKey
			
			idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
			idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', ls_sku) //Adjustment.Sku
			idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOwnerCD) //Owner_Cd
			idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', ls_from_poNo) //Po_No
			idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - 1) //-1 Negative Qty
			idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', ldBatchSeq) //EDI Batch Seq No
			idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', ldBatchSeq) //EDI Batch Seq No
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	
			//1/9/2020 - MikeA - Fixed As per Roy Testing - SKU GO Forward
	
			IF ls_to_serialno = '-'  THEN
				idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'CYCLE') //Adjustment
			ELSE
				idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'SERIAL') //Adjustment
			END IF
			
			//Write to file
			lsLogOut = ' OM Adjustment (SN change) - Record inserted into OMQ_Inventory_Transaction table (Decrement) aginst SourceKey# '+string(ldBatchSeq)+' , ItrnKey# '+string(ldOMQ_Inv_Tran1)+' Sku# '+ ls_sku
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			FileWrite(gilogFileNo,lsLogOut)
		End IF
	
		//B. Write OMQ_Inventory_Transaction Record (Increment)
		IF (not IsNull(ls_to_serialno) and ls_to_serialno <> '-' ) Then
			ll_Inv_Row = idsOMQInvTran.insertrow( 0)
			idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
			idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
			idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
			idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
			idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', llid_no) //Set with Item_serial_histroy.Id_No
			idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', ls_wh) //site id
			idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
			idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Edit Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Edit who
			idsOMQInvTran.setitem( ll_Inv_Row, 'CLIENT_ID', ls_client_Id)
			
			ldOMQ_Inv_Tran2 = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
			idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran2)) //ITRNKey
			
			idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
			idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
			idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', ls_sku) //Adjustment.Sku
			idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOwnerCD) //Owner_Cd
			idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', ls_poNo) //Po_No
			idsOMQInvTran.setitem( ll_Inv_Row, 'QTY',  1) //1 Positive Qty
			idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', ldBatchSeq) //EDI Batch Seq No
			idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', ldBatchSeq) //EDI Batch Seq No
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
			idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'SERIAL') //Adjustment
			
			//Write to file
			lsLogOut = ' OM Adjustment (SN change) - Record inserted into OMQ_Inventory_Transaction table (Increment) aginst SourceKey# '+string(ldBatchSeq)+' , ItrnKey# '+string(ldOMQ_Inv_Tran2)+' Sku# '+ ls_sku
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			FileWrite(gilogFileNo,lsLogOut)
		END IF
		
		//C. Write OMQ_Inventory_Txn_Sernum Record (Decrement)
		IF (not IsNull(ls_from_serialno) and ls_from_serialno <> '-' ) Then
			ll_InvTxn_row = idsOMQInvTxnSernum.insertrow( 0)
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QADDWHO', 'SIMSUSER') //Add Who
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QACTION', 'I') //Action
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUS', 'NEW') //Status
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QWMQID', llid_no) //Set with Item_serial_histroy.Id_No
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SITE_ID', ls_wh) //site id
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDDATE', ldtToday) //Add Date
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDWHO', 'SIMSUSER') //Add who
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITDATE', ldtToday) //Add Date
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITWHO', 'SIMSUSER') //Add who
		
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'CLIENT_ID', ls_client_Id)
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNKEY', string(ldOMQ_Inv_Tran1))
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNSERIALKEY', '1')
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ldsOC.GetItemString(llRowPos, 'from_serial_no'))
			
			//Write to file
			lsLogOut = ' OM Adjustment (SN change) - Record inserted into OMQ_Inventory_Txn_Sernum table (Decrement) aginst ItrnKey# '+string(ldOMQ_Inv_Tran1)+' From Serial No# '+ ldsOC.GetItemString(llRowPos, 'from_serial_no')
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			FileWrite(gilogFileNo,lsLogOut)
		End If
	
		//D. Write OMQ_Inventory_Txn_Sernum Record (Increment)
		IF (not IsNull(ls_to_serialno) and ls_to_serialno <> '-' ) Then	
			ll_InvTxn_row = idsOMQInvTxnSernum.insertrow( 0)
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QADDWHO', 'SIMSUSER') //Add Who
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QACTION', 'I') //Action
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUS', 'NEW') //Status
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QWMQID', llid_no) //Set with Item_serial_histroy.Id_No
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SITE_ID', ls_wh) //site id
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDDATE', ldtToday) //Add Date
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDWHO', 'SIMSUSER') //Add who
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITDATE', ldtToday) //Add Date
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITWHO', 'SIMSUSER') //Add who
		
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'CLIENT_ID', ls_client_Id)
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNKEY', string(ldOMQ_Inv_Tran2))
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNSERIALKEY', '1')
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ldsOC.GetItemString(llRowPos, 'to_serial_no'))
		
			//Write to file
			lsLogOut = ' OM Adjustment (SN change) - Record inserted into OMQ_Inventory_Txn_Sernum table (Increment) aginst ItrnKey# '+string(ldOMQ_Inv_Tran1)+' To Serial No# '+ ldsOC.GetItemString(llRowPos, 'to_serial_no')
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			FileWrite(gilogFileNo,lsLogOut)
		End If
	END IF
	
	IF Not IsNull(ls_Old_Po_No) AND ( 'RESEARCH' <> ls_Old_Po_No) THEN

		uf_create_soc945_serial_adj(asproject, ls_wh, lsOwnerCD, ldOwnerID, ls_sku, ls_Old_Po_No, ls_to_serialno )

	END IF

	UPDATE dbo.Item_Serial_Change_History  
	SET Transaction_Sent = 'Y'  
	WHERE dbo.Item_Serial_Change_History.ID_No = :llid_no   using sqlca;

next /*next output record */

llRC =1

Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then 	llRC =idsOMQInvTran.update( false, false);
If (idsOMQInvTxnSernum.rowcount( ) > 0 and llRC =1) Then 	llRC = idsOMQInvTxnSernum.update(false, false);

If llRC =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
		idsOMQInvTxnSernum.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		idsOMQInvTxnSernum.reset()
		
		//Write to File and Screen
		lsLogOut = '      - OM Adjustment (SN change)- Processing of uf_process_Serial_change_om  is failed to write/update OM Tables: ' + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = "      - OM Adjustment (SN change)- Processing of uf_process_Serial_change_om  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy idsOMQInvTran
destroy 	idsOMQInvTxnSernum

gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0
end function

public function integer uf_process_ci_om (string asproject, string asdono, long aitransid, string astransparm, datetime dtrecordcreatedate);//07-SEP-2017 :Madhu Added for PINT-945 -OB Order  CI (Commercial Invoice)
//Write records back into OMQ Tables

String		lsFind, lsOutString, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN, lsFromProject, lsToProject, lsTransType, lsFromLoc,ls_prev_carton_No
String 	lsInvoice, lsSKU, lsDONO, lsChildLine, lsCarrierName, lsPndSer, lsPrevSku, lsSkuFilter, lsCust,lsThisCarton, lsLastCarton, lsSerialNo, lsOrdType, ls_uf7, ls_gmt_offset
String 	ls_Serialized_Ind,ls_PONO2ControlledInd, ls_ContainerTrackingInd,lsSupplier, lsCOO, lsPONO2, lsContainerID, ls_Carrier_Pro_no, lsLineParm,ls_line_no, lsRefch1, ls_ship_track_Id
String 	lsDM_Country, lsCustCountry,ls_CodeDesc,lsSkipProcess2,lsUseCustType,lsCustType,lsParmSearch, ls_client_id, lsCarrier, lsCarrierAddress1, ls_pack_containerId
String 	ls_wh_name, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_city, ls_state, ls_zip, ls_country, ls_tel, ls_fax, ls_contact, ls_email, ls_carton_No, ls_carton_type, ls_detail_Find
String     ls_CI_Carrier //TAM - 2018/07/11 -S20884
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llFindDetailRow, llSerialCount, llQuantity, llCtnCount, llSerialRow, llSkuRow
Long 		ll_change_req_no, ll_batch_seq_no, ll_rc, ll_detail_row, ll_serial_row, ll_Inv_Row,  llPackRowCount, ll_Pack_Row
Long 		ll_attr_row, ll_attr_detail_row, llRefch1, llRefch2, ll_detail_find_row, llDetailQty, llDetailFindRow, ll_Item_Attr_Id, ll_return_code

Decimal		ldBatchSeq, ldOwnerID, ldOwnerID_Prev,ldWgt, ldWgtNet,ldTransID, ldOMQ_Inv_Tran,ld_total_weight, ld_pallet_qty, ld_carton_qty
Integer		liRC, liLine,DateDiffInMinutes, TimeDiffInMinutes, ElapsedTimeInMinutes
DateTime 	 ldtToday,ldt_EndRetrieve
Boolean		lbNeedGIM, lbSkipGIR, lbShipFromCityBlock, lbShipToCityBlock,lbLPN, lbNonLPN,lbParmFound

ldtToday = DateTime(Today(), Now())

Datastore lsLookupTable

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Start Processing of uf_process_ci_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

// GailM 2/ 25/2015 Add Unique Trx ID - Turn on with functionality manager - use lsSkipProcess2
lsSkipProcess2 = f_functionality_manager(asProject,'FLAG','SWEEPER','UNIQUETRXID','','')

// TimA 05/06/15  Turn on with functionality manager - Skip Adding the CustType for WMS  to the end of the file
lsUseCustType = f_functionality_manager(asProject,'FLAG','SWEEPER','CUSTTYPE','','')

If Not isvalid(idsGI) Then
	idsGI = Create u_ds_datastore
	idsGI.Dataobject = 'd_pandora_inv_trans'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create u_ds_datastore
	idsDOMain.Dataobject = 'd_do_master'
End If
idsDOMain.SetTransObject(SQLCA)
	
If Not isvalid(lsLookupTable) Then
	lsLookupTable = Create u_ds_datastore
	lsLookupTable.dataobject = 'd_lookup_table_search'
End If
lsLookupTable.SetTransObject(SQLCA)
	
If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create u_ds_datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
End If
idsDoDetail.SetTransObject(SQLCA)
	
If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create u_ds_datastore
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create u_ds_datastore
	idsDoPack.Dataobject = 'd_do_packing_track_id_pandora'
End If
idsDoPack.SetTransObject(SQLCA)
	
If Not isvalid(idsCartonSerial) Then
	idsCartonSerial = Create u_ds_datastore
	idsCartonSerial.Dataobject = 'd_carton_serial_pandora'
End If
idsCartonSerial.SetTransObject(SQLCA)
	
If Not isvalid(idsOMQWhDOMain) Then
	idsOMQWhDOMain =create u_ds_datastore
	idsOMQWhDOMain.Dataobject ='d_omq_warehouse_order'
End If
idsOMQWhDOMain.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDODetail) Then
	idsOMQWhDODetail =create u_ds_datastore
	idsOMQWhDODetail.Dataobject ='d_omq_warehouse_order_detail'
End If
idsOMQWhDODetail.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOAttr) Then
	idsOMQWhDOAttr =Create u_ds_datastore
	idsOMQWhDOAttr.Dataobject ='d_omq_warehouse_order_attr'
End If
idsOMQWhDOAttr.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDoDetailAttr) Then
	idsOMQWhDoDetailAttr =Create u_ds_datastore
	idsOMQWhDoDetailAttr.Dataobject ='d_omq_warehouse_order_detail_attr'
End If
idsOMQWhDoDetailAttr.settransobject(om_sqlca)
 
idsGI.Reset()
idsOMQWhDOMain.reset()
idsOMQWhDODetail.reset()
idsOMQWhDOAttr.reset()
idsOMQWhDoDetailAttr.reset()

lsLogOut = "      OM Outbound CI - Creating Commercial Invoice Transaction (CI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

w_main.SetMicroHelp("Processing Purchase Order (EDI - OM)")

lsOrdType = NoNull(idsDOMain.GetItemString(1, 'ord_type'))
lsWH = idsDOMain.GetItemString(1, 'wh_code')
ll_change_req_no = idsDOMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsDOMain.getitemnumber(1,'EDI_Batch_Seq_No')

Select DM.country DM_Country, C.Country C_Country  INTO 	:lsDM_Country, :lsCustCountry
From delivery_master DM with(nolock), Customer C  with(nolock)
Where DM.project_id = 'Pandora' and Do_no = :asDoNo And DM.project_id = C.Project_ID And DM.User_Field2 = C.Cust_Code using sqlca;	

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

select wh_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, Fax, Contact_Person, Email_Address, GMT_Offset
into :ls_wh_name, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_city, :ls_state, :ls_zip, :ls_country, :ls_tel, :ls_fax, :ls_contact, :ls_email, :ls_gmt_offset
from Warehouse with(nolock)
where wh_Code=:lsWH
using sqlca;


//Now using Create_User = 'SIMSFP' to determine Electronic order
if idsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	lsInvoice = idsDOMain.GetItemString(1, 'Invoice_no')
	
	select do_no into :lsDONO from Delivery_master with(nolock) where project_id = 'pandora' and invoice_no = :lsInvoice and wh_code = :lsWH and create_user = 'SIMSFP' using sqlca;
	
	if lsDONO > '' then
		lsElectronicYN = 'Y'
	end if
end if

lsCust = upper(trim(idsDOMain.GetItemString(1, 'cust_code')))
select user_field1,Customer_Type into :lsGroup, :lsCustType
from customer with(nolock)
where project_id = :asProject and cust_code = :lsCust using sqlca;

if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
	lbShipToCityBlock = true
End if

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Group = " + lsGroup)

lsFromLoc = idsDoMain.GetITemString(1,'User_field2')
If Not isnull(lsFromLoc) Then
	select user_field1 into :lsGroup
	from customer with(nolock)
	where project_id = :asProject and cust_code = :lsFromLoc using sqlca;

	If lsGroup > '' and not isnull(lsGroup) and Upper(lsGroup) = 'S-OWND-MIM' Then
		lsLogOut = "     GI Suppressed for MIM Owned Inventory transaction For DO_NO: " + asDONO + ". No GI is being created for this order."
		FileWrite(gilogFileNo,lsLogOut)
		if lbNeedGIM then
			lbSkipGIR = true
		else
			Return 0
		end if
	End IF

	if f_lookup_table('PANDORA','CBGRP',lsGroup) Then
		lbShipFromCityBlock = true
	End if
End IF

w_main.SetMicroHelp(" Processing Purchase Order (ROSE) - Retrieve DO detail - Group: " + lsGroup)
idsDoDetail.Retrieve(asDoNo)
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()))

If idsDoDetail.RowCount() > 0 then
	lsSku = upper(idsDoDetail.GetItemString(idsDoDetail.GetRow() ,'SKU'))	

	Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
	Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
	From		Item_Master with(nolock)
	where	project_id = :asProject and 	sku = :lsSku 
	Using SQLCA;
End If

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Retrieve DO detail - RowCount " + String(idsDoDetail.RowCount()) + ' - Checked Item Master')

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
Else
	destroy idsDoPick
	idsDoPick = Create Datastore
End if

if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
	idsDoPick.Dataobject = 'd_do_Picking_pandora'
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_lpn'
	lbLPN = True
	lbNonLPN = false
	f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN flag set true, nonLPN set false for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Carton Level Query','',lsInvoice)		

elseif ls_Serialized_Ind = 'B' and (ls_ContainerTrackingInd = 'N' or ls_PONO2ControlledInd = 'N') then
	lbLPN = False
	lbNonLPN = true
	idsDoPick.Dataobject = 'd_do_Picking'			
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
	f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN flag set false, nonLPN set true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
else 
	lbLPN = False
	lbNonLPN = False
	
	idsDoPick.Dataobject = 'd_do_Picking'			
	idsDoSerial.Dataobject = 'd_gi_outbound_serial_pandora'
	idsDoSerial.SetTransObject(SQLCA)
	idsDoSerial.Retrieve(asDoNo)
	If idsDOSerial.RowCount() > 0 Then		//Non-serialized
		If idsDOSerial.GetItemString(1,'serial_no') = idsDOSerial.GetItemString(1,'carton_no') Then
			ibDejaVu = True
		End If
		idsDOSerial.Reset()
	End If

	f_method_trace_special( asproject, this.ClassName() + ' - uf_gi_rose', 'LPN  false and nonLPN flags set to true for SKU:' + lsSKU ,trim(idsDOMain.GetItemString(1, 'do_no')), 'Pallet Level/Default Query','',lsInvoice)		
end if

idsDoSerial.SetTransObject(SQLCA)
idsDoPick.SetTransObject(SQLCA)	

w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Start Retrive PickList: " + String(f_getLocalWorldTime('PND_MTV')))

idsDoPick.Retrieve(asDoNo)
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Picklist retrievedil - RowCount " + String(idsDoPick.RowCount()) + ' - Completed: '+ String(f_getLocalWorldTime('PND_MTV')))

idsDoPack.Retrieve(asDoNo)

// TAm 2010/06/09 - Filter out Children
idsDOPick.Setfilter("Component_Ind <> '*'")
idsDOPick.Filter()

llRowCount = idsDOPick.RowCount()

// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

/***** START POPULATE GI DATASTORE SECTION *********/
lsLogOut = "             Populate GI datastore at: '"  + String(f_getLocalWorldTime('PND_MTV'))
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	w_main.SetMicroHelp(" 1 - GI Row: " + string(llRowPos))
	
	//Refresh screen willl looping
	if llRowPos = 10000 or llRowPos = 20000 or llRowPos = 30000 or llRowPos = 40000 then
		yield()
	End if
	
	ls_line_no = string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no') )
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )
	
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if
		
	If idsDOPick.GetItemString(llRowPos,'component_ind') = 'Y' and idsDOPick.GetItemNumber(llRowPos,'Component_no') = 0 Then Continue 
	
	//Step 1. Checking Pandora Serial
	lsSku = upper(idsDOPick.GetItemString(llRowPos,'SKU'))	
	If lsSku <> lsPrevSku Then
		Select		User_field18, Serialized_Ind, Container_Tracking_Ind, PO_No2_Controlled_Ind 
		Into 		:lsPndSer, :ls_Serialized_Ind, :ls_ContainerTrackingInd, :ls_PONO2ControlledInd
		From		Item_Master with(nolock)
		where	project_id = :asProject and	sku = :lsSku 
		Using SQLCA;
	End If
	
	lsPrevSku = lsSku
	
	if ls_Serialized_Ind = 'B' and ls_ContainerTrackingInd = 'Y' and ls_PONO2ControlledInd = 'Y' then
		lbLPN = True
	else
		lbLPN = False
	end if
	
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
	lsFind += " and trans_line_no = '" + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')) + "'"
	lsFind += " and from_project = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no')) + "'"
	
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'container_id'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'container_id')) = '' Then  
		lsFind += " and container_id = '" + string(idsDOPick.GetItemString(llRowPos, 'container_id')) + "'"
	end If
	
	If NOT isnull(string(idsDOPick.GetItemString(llRowPos, 'po_no2'))) and NOT string(idsDOPick.GetItemString(llRowPos, 'po_no2')) = '' Then  
		lsFind += " and po_no2 = '" + string(idsDOPick.GetItemString(llRowPos, 'po_no2')) + "'"
	End If
	
	lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
	
	if IsNull(lsCOO) then
		lsFind += " and COO = '" + idsDOPick.GetItemString(llRowPos, 'country_of_origin') + "'"
	else
		lsFind += " and COO = '" + lsCOO + "'"
	end if
	
	llFindRow = idsGI.Find(lsFind, 1, idsGI.RowCount())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGI.SetItem(llFindRow, 'quantity', (idsGI.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	else /*not found, add a new record*/
			ldOwnerID = idsDOPick.GetItemNumber(1, 'owner_id')
		
			if ldOwnerID <> ldOwnerID_Prev then
				select owner_cd into :lsOwnerCD
				from owner with(nolock)
				where project_id = :asProject and owner_id = :ldOwnerID using sqlca;
		
				ldOwnerID_Prev = ldOwnerID
		
				select user_field1 into :lsGroup
				from customer with(nolock)
				where project_id = :asProject and cust_code = :lsOwnerCd using sqlca;
		
				if left(lsGroup, 3) = 'GIG' then 
					lsGigYN = 'Y'
				else
					lsGigYN = 'N'
				end if
				
				lsTransYN = 'Y'	
			end if
		
			lsSupplier = upper(idsDOPick.GetItemString(llRowPos,'supp_code'))	
		
		if lsTransYN = 'Y' then
			llNewRow = idsGI.InsertRow(0)
			idsGI.SetItem(llNewRow, 'trans_id', right(trim(idsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // ro_no for inbound (or do_no for outbound) + Trans_ID Sequence
			idsGI.SetItem(llNewRow, 'from_loc', upper(trim(lsOwnerCD))) // 08/09 - added 'upper'
			
			idsGI.SetItem(llNewRow, 'to_loc', upper(trim(idsDOMain.GetItemString(1, 'cust_code')))) // 08/09 - added 'upper'
			idsGI.SetItem(llNewRow, 'complete_date', idsDOMain.GetItemDateTime(1, 'complete_date'))
			idsGI.SetItem(llNewRow, 'sku', idsDOPick.GetItemString(llRowPos, 'sku'))
			idsGI.SetItem(llNewRow, 'from_project', trim(idsDOPick.GetItemString(llRowPos, 'po_no')))  /* Pandora Project */
			idsGI.SetItem(llNewRow, 'trans_type', trim(idsDOMain.GetItemString(1, 'user_field7')))  //MATERIAL TRANSFER, PO RECEIPT, EXP PO RECEIPT, MATERIAL RECEIPT, ERS RECEIPT
			idsGI.SetItem(llNewRow, 'trans_source_no', trim(idsDOMain.GetItemString(1, 'invoice_no')))

			If idsDOPick.GetItemString(llRowPos,'component_ind') = 'W' Then
				lsSKU = idsDOPick.GetItemString(llRowPos, 'sku')
				lsDoNO = trim(idsDOMain.GetItemString(1, 'do_no'))
				liLine = idsDOPick.GetItemNumber(llRowPos, 'line_item_no')
				SELECT dbo.Delivery_BOM.user_field1  
				INTO :lsChildLine  
				FROM dbo.Delivery_BOM  with(nolock)
				WHERE ( dbo.Delivery_BOM.Project_ID = 'PANDORA' ) AND  
				( dbo.Delivery_BOM.DO_NO = :lsDONO ) AND  
				( dbo.Delivery_BOM.Sku_Child = :lsSKU ) AND  
				( dbo.Delivery_BOM.Line_Item_No = :liLine )   
				using sqlca;
			
				If Not IsNull(lsChildLine) and lsChildLine <> '' Then
					idsGI.SetItem(llNewRow, 'trans_line_no', lsChildLine)
				Else
					idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
				End If
			Else
				idsGI.SetItem(llNewRow, 'trans_line_no', string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no')))
			End If

			if Trim( ls_Serialized_Ind ) = 'B' or Trim( ls_Serialized_Ind ) = 'O' or Trim( ls_Serialized_Ind ) = 'Y' then	// LTK 20160113 Emergency build change
				idsGI.SetItem(llNewRow, 'serial_no','Y')		// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line (code was only setting Y/N flag here)
			Else
				idsGI.SetItem(llNewRow, 'serial_no', 'N')
			End If
	
			idsGI.SetItem(llNewRow, 'quantity', idsDOPick.GetItemNumber(llRowPos, 'quantity'))
			idsGI.SetItem(llNewRow, 'Gig_YN', lsGigYN)  //ICC separates the files by whether or not it is for Group 'GIG'
			
			idsGI.SetItem(llNewRow, 'lot', idsDOPick.GetItemString(llRowPos, 'lot_no'))
			lsCOO = idsDOPick.GetItemString(llRowPos, 'User_Field1')
		
			if IsNull(lsCOO) then
				idsGI.SetItem(llNewRow, 'coo', idsDOPick.GetItemString(llRowPos, 'country_of_origin'))
			else
				idsGI.SetItem(llNewRow, 'coo', lsCOO)
			end if
			
			lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) +"'"
			lsFind += " and line_item_no = " + string(idsDOPick.GetItemNumber(llRowPos, 'line_item_no'))
			
			idsGI.SetItem(llNewRow, 'container_id', idsDOPick.GetItemString(llRowPos, 'container_id'))
			idsGI.SetItem(llNewRow, 'po_no2', idsDOPick.GetItemString(llRowPos, 'po_no2'))
			idsGI.SetItem(llNewRow, 'Commodity_Code', idsDOPick.GetItemString(llRowPos, 'im_user_field5')) //User_Field5 from Item Master
	
			llFindDetailRow = idsDoDetail.Find(lsFind, 1, idsDoDetail.RowCount())
			If llFindDetailRow > 0 Then /*row found*/
				idsGI.SetItem(llNewRow, 'defect_serial_no', idsDODetail.GetItemString(llFindDetailRow,'user_field3'))
				idsGI.SetItem(llNewRow, 'defect_track_no', idsDODetail.GetItemString(llFindDetailRow,'user_field4'))
				idsGI.SetItem(llNewRow, 'to_project', idsDODetail.GetItemString(llFindDetailRow,'user_field5'))
			
				If idsDODetail.GetItemString(llFindDetailRow,'alternate_sku') > '' Then
					idsGI.SetItem(llNewRow, 'mfg_prt_no', idsDODetail.GetItemString(llFindDetailRow,'alternate_sku'))
				Else
					idsGI.SetItem(llNewRow, 'mfg_prt_no',  upper(idsDOPick.GetItemString(llRowPos,'SKU')))
				End If
			Else
				//error
			End If //llFindDetailRow
		End If //lsTransYN
	End IF //llFindRow
	skipDetailRow:
Next /* Next Picking record */

/***** END OF POPULATE GI DATASTORE SECTION ***********/

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//1. Write Header Records into OMQ_Warehouse_Order Table
llRowCount = idsGI.RowCount()

w_main.SetMicroHelp(" SH1 Row a " + + String(f_getLocalWorldTime('PND_MTV')))

if llRowCount <= 0 then return 0

lsCarrier = idsDOMain.GetItemString(1, 'carrier')


//TAM - 2018/07/11 -S20884 - Translate the SIMS carrier Code into the CI Carrier Code in OM
select Code_Descript 						
into :ls_CI_Carrier
from lookup_table with(nolock)
where project_id = :asproject and Code_Type = 'CI_CARRIER_TRANSLATE' and Code_Id = :lsCarrier using sqlca;

If  isnull(ls_CI_Carrier) or  ls_CI_Carrier = '' then	ls_CI_Carrier = lsCarrier


select address_1, Carrier_Name 						
into :lsCarrierAddress1, :lsCarrierName
from carrier_master with(nolock)
where project_id = :asproject
and carrier_code = :lsCarrier using sqlca;

//Build and Write  Header Records
llNewRow = idsOMQWhDOMain.insertRow(0)
idsOMQWhDOMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQWhDOMain.setitem( 1, 'CLIENT_ID', ls_client_id)
idsOMQWhDOMain.setitem(1, 'SITE_ID', lsWH) //site id

idsOMQWhDOMain.setitem( 1, 'QACTION', 'U') //Action- U (Update)
idsOMQWhDOMain.setitem( 1, 'QSTATUS', 'NEW')
idsOMQWhDOMain.setitem( 1, 'QSTATUSDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'QSTATUSSOURCE', 'SIMSSWEEPER')
idsOMQWhDOMain.setitem( 1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id

idsOMQWhDOMain.setitem( 1, 'ADDDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'ADDWHO', 'SIMSUSER')
idsOMQWhDOMain.setitem( 1, 'EDITDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'EDITWHO', 'SIMSUSER')

idsOMQWhDOMain.setitem(1, 'EXTERNORDERKEY', trim(idsDOMain.GetItemString(1, 'invoice_no'))) //Invoice No
idsOMQWhDOMain.setitem(1, 'INCOTERM', trim(idsDOMain.GetItemString(1, 'freight_terms'))) //Freight Terms
idsOMQWhDOMain.setitem(1, 'TYPE', trim(idsDOMain.GetItemString(1, 'ord_type'))) //Type
idsOMQWhDOMain.setitem(1, 'ORDERGROUP', trim(idsDOMain.GetItemString(1, 'user_field7'))) //Order Group
idsOMQWhDOMain.setitem(1, 'ORDERKEY', Right(trim(idsDOMain.GetItemString(1, 'do_no')),10)) //Order Key (Do No)
idsOMQWhDOMain.setitem(1, 'STATUS', 'STAGED') //Status - Complete (95)

//TAM - 2018/07/11 -S20884 - Translate the SIMS carrier Code into the CI Carrier Code in OM
//idsOMQWhDOMain.setitem(1, 'CARRIERKEY', lsCarrier) //Carrier Key
idsOMQWhDOMain.setitem(1, 'CARRIERKEY', ls_CI_Carrier) //Carrier Key

idsOMQWhDOMain.setitem(1, 'CLIENT_SHIPTO_ID', trim(idsDOMain.GetItemString(1, 'cust_code'))) //Consignee Key
idsOMQWhDOMain.setitem(1, 'CONSIGNEEKEY', left(trim(idsDOMain.GetItemString(1, 'cust_code')),15)) //Consignee Key
idsOMQWhDOMain.setitem(1, 'C_COMPANY',  left(trim(idsDOMain.GetItemString(1, 'cust_name')), 45)) //Customer Name //19-APR-2019 :Madhu DE10140
idsOMQWhDOMain.setitem(1, 'C_ADDRESS1', left(trim(idsDOMain.GetItemString(1, 'address_1')), 45)) //Address1
idsOMQWhDOMain.setitem(1, 'C_ADDRESS2', left(trim(idsDOMain.GetItemString(1, 'address_2')), 45)) //Address2
idsOMQWhDOMain.setitem(1, 'C_ADDRESS3', left(trim(idsDOMain.GetItemString(1, 'address_3')), 45)) //Address3
idsOMQWhDOMain.setitem(1, 'C_ADDRESS4', left(trim(idsDOMain.GetItemString(1, 'address_4')), 45)) //Address4
idsOMQWhDOMain.setitem(1, 'C_CITY', trim(idsDOMain.GetItemString(1, 'city'))) //City
idsOMQWhDOMain.setitem(1, 'DELIVERYPLACE', Left(trim(idsDOMain.GetItemString(1, 'state')),2)) //State
idsOMQWhDOMain.setitem(1, 'C_ZIP', trim(idsDOMain.GetItemString(1, 'zip'))) //Zip
idsOMQWhDOMain.setitem(1, 'C_COUNTRY', trim(idsDOMain.GetItemString(1, 'country'))) //Country
idsOMQWhDOMain.setitem(1, 'C_ISOCNTRYCODE', trim(idsDOMain.GetItemString(1, 'country'))) //Country

idsOMQWhDOMain.setitem(1, 'DELIVERYDATE', idsDOMain.GetItemDateTime(1, 'request_date')) //Delivery Date
idsOMQWhDOMain.setitem(1, 'REFCHAR1', trim(idsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr

idsOMQWhDOMain.setitem(1, 'SUSR2', this.gmtformatoffset(ls_gmt_offset)) //Warehouse.GMT_Offset
idsOMQWhDOMain.setitem(1, 'SUSR3', trim(idsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr
idsOMQWhDOMain.setitem(1, 'SUSR4', this.uf_get_rdd_timezone( ll_batch_seq_no, trim(idsDOMain.GetItemString(1, 'invoice_no'))))

idsOMQWhDOMain.setitem(1, 'NOTES', trim(idsDOMain.GetItemString(1, 'Shipping_Instructions'))) //Shipping Instructions

If Pos(idsDOMain.GetItemString(1, 'user_field7') ,'MATERIAL') > 0 Then   
	ls_uf7 = "TRANSFER"
elseIf Pos(idsDOMain.GetItemString(1, 'user_field7') ,'CUSTOMER') > 0 Then   
	ls_uf7 = "DLVORDER"
else
	ls_uf7 =''
End If

idsOMQWhDOMain.setitem(1, 'TYPE', ls_uf7) //User Field7
idsOMQWhDOMain.setitem(1, 'DEPARTMENT', trim(idsDOMain.GetItemString(1, 'user_field10'))) //User Field10
idsOMQWhDOMain.setitem(1, 'DIVISION', trim(idsDOMain.GetItemString(1, 'Do_No'))) //Do_No

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Processing Header Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Header Row completed")

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. Write Detail Records into OMQ_Warehouse_Order_Detail Table
llRowCount = idsGI.RowCount()
For llRowPos = 1 to llRowCount

	//Roll Up Detail records for same attribute values.
	If (not isnull(idsGI.GetItemString(llRowPos, 'trans_source_no')) and len(idsGI.GetItemString(llRowPos, 'trans_source_no')) > 0) Then lsFind = "EXTERNORDERKEY = '" + idsGI.GetItemString(llRowPos, 'trans_source_no') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'sku')) and len(idsGI.GetItemString(llRowPos, 'sku')) > 0) Then lsFind += " and ITEM = '" + upper(idsGI.GetItemString(llRowPos, 'sku')) + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'trans_line_no')) and len(idsGI.GetItemString(llRowPos, 'trans_line_no')) > 0) Then lsFind += " and EXTERNLINENO = '" +  idsGI.GetItemString(llRowPos, 'trans_line_no') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'from_loc')) and len(idsGI.GetItemString(llRowPos, 'from_loc')) > 0) Then 	lsFind += " and LOTTABLE01 = '" + 	idsGI.GetItemString(llRowPos, 'from_loc') + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'from_project')) and len(idsGI.GetItemString(llRowPos, 'from_project')) > 0) Then lsFind += " and LOTTABLE03 = '" + upper(idsGI.GetItemString(llRowPos, 'from_project')) + "'"
	If (not isnull(idsGI.GetItemString(llRowPos, 'to_project')) and len(idsGI.GetItemString(llRowPos, 'to_project')) > 0) Then lsFind += " and SUSR1 = '" + upper(idsGI.GetItemString(llRowPos, 'to_project')) + "'"

	IF idsOMQWhDODetail.RowCount() > 0 Then 	
		llDetailFindRow = idsOMQWhDODetail.Find(lsFind,1,idsOMQWhDODetail.RowCount())
		If llDetailFindRow >0 Then 
			llDetailQty = idsOMQWhDODetail.GetItemNumber(llDetailFindRow,'SHIPPEDQTY')
		else
			llDetailFindRow = 0
		End If
		
	else
		llDetailFindRow = 0
	End IF

	IF llDetailFindRow =0 Then
		ll_detail_row =idsOMQWhDODetail.insertrow( 0)
		idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR',ll_change_req_no)
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'U') //Action- U (Update)
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
		idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
		idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
		idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', lsWH) //site id
		
		idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
		idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
		idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')
	
		idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE01', idsGI.getitemstring(llRowPos, 'from_loc'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(idsDOMain.GetItemString(1, 'invoice_no')))
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', idsGI.getitemstring( llRowPos, 'trans_line_no'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(idsDOMain.GetItemString(1, 'do_no')),10))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', String(long(idsGI.getitemstring( llRowPos, 'trans_line_no')),'00000'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'OPENQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDEREDSKUQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', idsGI.getitemnumber( llRowPos, 'quantity'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'UOM', 'EA')
		idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', idsGI.GetItemString(llRowPos, 'sku'))
		idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE03', idsGI.GetItemString(llRowPos, 'from_project')) //Po No
		idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR1', idsGI.GetItemString(llRowPos, 'to_project')) //To Project (UF5)
		idsOMQWhDODetail.setitem( ll_detail_row, 'STATUS', 'STAGED')
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', idsGI.getitemstring(llRowPos, 'from_loc') +'~~'+idsGI.GetItemString(llRowPos, 'from_project')) //Owner_CD, '~', PO_NO (ex: WHIACBP~MAIN)
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'OPENQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORDEREDSKUQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
		idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', idsGI.getitemnumber( llRowPos, 'quantity') +llDetailQty)
	End IF
	
	//Write to File and Screen
	lsLogOut = '      - OM Outbound CI- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+idsGI.GetItemString(llRowPos, 'trans_line_no')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	
	If NOT lbShipFromCityBlock and NOT lbShipToCityBlock and NOT ibDejaVu Then
		lsContainerID =  NoNull(idsGI.GetItemString(llRowPos, 'container_id')) 							//Container ID
	Else
		lsContainerID = ''
	End If
	
	lsPONo2 = NoNull(idsGI.GetItemString(llRowPos, 'po_no2'))
	llQuantity = idsGI.GetItemNumber(llRowPos,'quantity')
	ls_line_no = idsGI.getitemstring( llRowPos, 'trans_line_no')
	lsPndSer = idsGI.GetItemString(llRowPos, 'serial_no') //get Serial No value.
	
	//3. Write Serial No Records into OMQ_Warehouse_OrderDetail_Sernum Table
	//As discussed with Dave, Don't write Serial No records for CI - Hence, removed code.

Next //Next Detail Record

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Building Package Information of uf_process_gi_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//4. Write Packaging Information into OMQ_WAREHOUSE_ORDERATTR, OMQ_WH_ORDERDETAIL_ATTR
llPackRowCount = idsDOPack.RowCount()

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Building Package Information of uf_process_gi_om() for Do_No: ' + asdono + ' Pack Row Count: '+string(llPackRowCount)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If llPackRowCount > 0 Then
	//a. Ship From Address Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFA1')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromAddress') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_wh_name)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_addr1)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_addr2)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_addr3)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
	
	//b. Ship From Location Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFL2')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromLocation') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_city)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_state)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_zip)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_country)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//c.Ship From Contact Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFC3')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromContact') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', ls_contact)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', ls_email)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_tel)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_fax)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//d. Shipment Reference Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SHI4')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipmentIdentifiers') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', trim(idsDOMain.GetItemString(1, 'Vics_Bol_no')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', trim(idsDOMain.GetItemString(1, 'Carrier_Pro_No')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', trim(idsDOMain.GetItemString(1, 'AWB_BOL_No')))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')

	//d.(1) Shipment Measures Construct
	FOR ll_Pack_Row =1 to idsDOPack.RowCount()
		ls_carton_No = upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_no'))
	
		if ls_prev_carton_No <> ls_carton_No Then //don't sumup duplicate carton No.
			ld_total_weight += idsDOpack.GetItemNumber(ll_Pack_Row, 'Weight_Gross')
		end if
	
		ls_prev_carton_No =ls_carton_No //store carton No into Previous value.
	
	Next
	
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SHM5')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipmentMeasures') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', 'LB')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM1', ld_total_weight) //Total_Weight_Gross
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
	
	//e. Pallet Construct
	For ll_Pack_Row = 1 to  idsDOPack.RowCount()
		ls_carton_No = upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_no'))
		ls_carton_Type= upper(idsDOpack.GetItemString(ll_Pack_Row, 'carton_type'))
		
		//Build Find statement and look for existing Carton No on OMQWhDoAttr data store.
		lsFind = " REFCHAR3 = '"+ls_carton_No+"'"
		llFindRow = idsOMQWhDOAttr.find( lsFind, 1, idsOMQWhDOAttr.rowcount())
	
		If llFindRow = 0 Then //If Record doesn't present, add to data store.
			llRefch1++
			ll_attr_row =idsOMQWhDOAttr.insertrow(0)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
			idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
			idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
			idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	
			idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
			idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(asdono, 10))
			
			//e.(a) Get sum(PALLET) Qty.
			ld_pallet_qty =0
			lsFind ="upper(carton_type) = 'PALLET' and carton_no ='"+ ls_carton_No +"'"
			ld_pallet_qty = this.uf_get_pallet_carton_qty( lsFind)
			
			//e.(b) Get sum(CARTON) qty
			ld_carton_qty =0
			lsFind ="upper(carton_type) <> 'PALLET' and carton_no ='"+ls_carton_No +"'"
			ld_carton_qty = this.uf_get_pallet_carton_qty( lsFind)
			
			ls_ship_track_Id = idsDOpack.GetItemString(ll_Pack_Row, 'shipper_tracking_id')

			If isNull(ls_ship_track_Id) or ls_ship_track_Id='' or ls_ship_track_Id=' ' or len(ls_ship_track_Id) =0 Then
				ls_ship_track_Id = trim(idsDOMain.GetItemString(1, 'AWB_BOL_No'))
			End If
			
			If ls_carton_Type = 'PALLET' THEN
				idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', Right(ls_carton_No,9)+'P')
				idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','PALLETLEVEL') 
				idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM1',ld_pallet_qty) //Pallet Qty
			else 
				//e. Carton Construct
				idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', Right(ls_carton_No,9)+'P')
				idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','PALLETLEVEL')  //As Dave stated, consider everything as Pallet.
				idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM1',ld_carton_qty) //Carton Qty
			End If

			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', string(llRefch1)) //Increment count
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR3', ls_carton_No)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR4', ls_ship_track_Id)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR5','LB')
			
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM2', idsDOpack.GetItemNumber(ll_Pack_Row, 'Weight_Gross')) //Weight_Gross
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM3', idsDOpack.GetItemNumber(ll_Pack_Row, 'height') ) //height
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM4', idsDOpack.GetItemNumber(ll_Pack_Row, 'length')) //length
			idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM5', idsDOpack.GetItemNumber(ll_Pack_Row, 'width')) //width
		
			idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
			idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
			idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
			
			lsRefch1 = string(llRefch1) //store parent REFCHAR1 value
		else
			lsRefch1 = idsOMQWhDOAttr.getitemstring(llFindRow, 'REFCHAR1') //store parent REFCHAR1 value
		End If
	
		//f. Item Level Construct
		ll_Item_Attr_Id++
		ll_attr_detail_row =idsOMQWhDoDetailAttr.insertrow(0)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QACTION','U')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QSTATUS','NEW')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QSTATUSSOURCE','SIMSSWEEPER')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'QWMQID',aitransid)
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ATTR_TYPE','ITEMLEVEL') 
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ATTR_ID', 'I'+string(ll_Item_Attr_Id))
		//idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ATTR_ID', Right(ls_carton_No,5))

		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'CLIENT_ID', ls_client_id)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'SITE_ID', lsWH)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'WH_ORDER_NBR', Right(asdono, 10))
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'WH_ORDERLINE_NBR', string(idsDOpack.GetItemNumber(ll_Pack_Row, 'line_item_no'), '00000')) //Line Item No
		
		llRefch1++
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR1', string(llRefch1)) //Increment count
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR2', lsRefch1) //Parent RefChar1
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR3', idsDOpack.GetItemString(ll_Pack_Row, 'Sku')) //Sku
		//idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR4', ls_carton_No) //Carton No
		
		//08-FEB-2018 :Madhu S15632 - If Pack Container Id present, map to REFCHAR4
		ls_pack_containerId= idsDOpack.getItemString(ll_Pack_Row, 'Pack_Container_Id')
		If not IsNull(ls_pack_containerId) or ls_pack_containerId <>'' or ls_pack_containerId <> ' ' or ls_pack_containerId <> '-' Then
			idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR4', ls_pack_containerId) //Pack Container Id
		End If

		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFCHAR5', idsDOpack.GetItemString(ll_Pack_Row, 'Country_Of_Origin')) //COO
		
		ls_detail_Find = "sku ='"+ idsDOpack.GetItemString(ll_Pack_Row, 'Sku') +"' and line_item_no ="+ string(idsDOpack.GetItemNumber(ll_Pack_Row, 'line_item_no'))
		ll_detail_find_row = idsDoDetail.find( ls_detail_Find, 1,idsDoDetail.rowcount())
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM1', idsDOpack.GetItemNumber(ll_Pack_Row, 'Quantity')) //Pack Level Qty
		
		IF ll_detail_find_row > 0 THEN
			idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM2', idsDoDetail.getitemnumber( ll_detail_find_row, 'req_qty')) //Order Level Qty (DD.Ord_Qty)
		ELSE
			ls_detail_Find = "sku ='"+ idsDOpack.GetItemString(ll_Pack_Row, 'Sku') +"'"
			ll_detail_find_row = idsDoDetail.find( ls_detail_Find, 1,idsDoDetail.rowcount())
			IF ll_detail_find_row > 0 THEN 	idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'REFNUM2', idsDoDetail.getitemnumber( ll_detail_find_row, 'req_qty')) //Order Level Qty (DD.Ord_Qty)
			
		END IF
				
		
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ADDDATE', ldtToday)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'ADDWHO','SIMSUSER')
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'EDITDATE', ldtToday)
		idsOMQWhDoDetailAttr.setitem(ll_attr_detail_row, 'EDITWHO','SIMSUSER')
		
	NEXT

End If

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQWhDOMain.rowcount( ) > 0 Then 	ll_rc =idsOMQWhDOMain.update( false, false);		//OMQ_Warehouse_Order
If idsOMQWhDODetail.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQWhDODetail.update( false, false); //OMQ_Warehouse_OrderDetail
If idsOMQWhDOAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOAttr.update( false, false); //OMQ_WAREHOUSE_ORDERATTR
If idsOMQWhDoDetailAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDoDetailAttr.update( false, false); //OMQ_WH_ORDERDETAIL_ATTR

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQWhDOMain.resetupdate( )
		idsOMQWhDODetail.resetupdate( )
		idsOMQWhDOAttr.resetupdate( )
		idsOMQWhDoDetailAttr.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQWhDOMain.reset( )
		idsOMQWhDODetail.reset()
		idsOMQWhDOAttr.reset( )
		idsOMQWhDoDetailAttr.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound CI- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound CI- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If


ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Outbound CI- Processed Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code: " + string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy idsGI
destroy idsDoMain
destroy idsDoDetail
destroy idsDOPick
destroy idsDoPack
destroy idsDoSerial
destroy idsOMQWhDOMain 
destroy idsOMQWhDODetail 
destroy idsOMQWhDOAttr
destroy idsOMQWhDoDetailAttr

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM

Return ll_return_code
end function

public function integer uf_process_oc_om (string asproject, string astono, string astransparm, long aitransid);// This function creates the Owner change (OC) confirmation. 945 - SOC 
//*Prepare a Owner Change Confirmation Transaction for PANDORA for the Transfer that was just confirmed


//Datastore	ldsOut, ldsOC
Datastore	ldsOC
				
Long			llRowPos, llRowCount, llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsWarehouse, lsWarehouseSave, lsSIKAWarehouse, lsFileName, sql_syntax, Errors, lsFileNamePath,  lsownercd, lsnewownercd
				
String lsSaveSku,lsSavePoNo, lsSaveNewPoNo, lsSaveLineNumber, lsPndser, ls_whcode, ls_gmt_offset
string lsCurrentSku, lsCurrentPoNo, lsCurrentNewPoNo, lsCurrentLineNumber, lsWriteLineNumber, ls_client_id

Decimal		ldBatchSeq, ldownerid, ldnewownerid, ldOMQ_Inv_Tran
Integer		liRC
DateTime	ldtToday, ldtTemp

Long lldetailfindrow, ll_change_req_no,ll_detail_row,  ll_serial_row, ll_rc, ll_inv_row, ll_attr_row
String lsLineParm, ls_line_no
Boolean lbParmFound
String ls_order_no

gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

If Not isvalid(idsOMQWhDOMain) Then
	idsOMQWhDOMain =create u_ds_datastore
	idsOMQWhDOMain.Dataobject ='d_omq_warehouse_order'
End If
idsOMQWhDOMain.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDODetail) Then
	idsOMQWhDODetail =create u_ds_datastore
	idsOMQWhDODetail.Dataobject ='d_omq_warehouse_order_detail'
End If
idsOMQWhDODetail.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOSerial) Then
	idsOMQWhDOSerial =create u_ds_datastore
	idsOMQWhDOSerial.Dataobject ='d_omq_warehouse_order_detail_sernum'
End If
idsOMQWhDOSerial.settransobject(om_sqlca)
	
If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOAttr) Then
	idsOMQWhDOAttr =Create u_ds_datastore
	idsOMQWhDOAttr.Dataobject ='d_omq_warehouse_order_attr'
End If
idsOMQWhDOAttr.settransobject(om_sqlca)
	
idsOMQWhDOMain.reset()
idsOMQWhDODetail.reset()
idsOMQWhDOSerial.reset()
idsOMQInvTran.reset()
idsOMQWhDOAttr.reset()

ldtToday = DateTime(Today(), Now())

//Create the Owner Change datastore
ldsOC = Create Datastore

//TAM TODO - Add Change Request Number to DB
sql_syntax = " SELECT Transfer_Master.Ord_Type, Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Master.User_Field4, Transfer_Master.User_Field5, Transfer_Master.Remark, Transfer_Master.OM_Change_Request_Nbr, "
sql_syntax += " Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU, Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail.user_line_item_no, "
sql_syntax += " Alternate_Serial_Capture.Serial_no_Child, SUM(Transfer_Detail.Quantity) as Total_Qty "  
sql_syntax += " FROM Transfer_Detail "
sql_syntax += " LEFT OUTER JOIN Alternate_Serial_Capture ON Transfer_Detail.TO_No = Alternate_Serial_Capture.TO_NO AND"
sql_syntax += " Transfer_Detail.Line_Item_No = Alternate_Serial_Capture.to_line_item_No AND" 
sql_syntax += " Transfer_Detail.SKU = Alternate_Serial_Capture.SKU_Child AND" 
sql_syntax += " Transfer_Detail.Supp_Code = Alternate_Serial_Capture.Supp_Code_Child,"   
sql_syntax += " Transfer_Master"
sql_syntax += " WHERE ( Transfer_Detail.TO_No = Transfer_Master.TO_No ) and ( ( Transfer_Master.TO_No = '" + asTONO + "' ))"
sql_syntax += " GROUP BY Transfer_Master.Ord_Type, Transfer_Master.D_Warehouse, Transfer_Master.Complete_Date, Transfer_Master.User_Field3, Transfer_Master.User_Field4, Transfer_Master.User_Field5, Transfer_Master.Remark, Transfer_Master.OM_Change_Request_Nbr, Transfer_Detail.Owner_ID, Transfer_Detail.New_Owner_ID, Transfer_Detail.SKU," 
sql_syntax += " Transfer_Detail.PO_No, Transfer_Detail.New_PO_No, Transfer_Detail.User_Line_item_no, Alternate_Serial_Capture.Serial_no_Child"
sql_syntax += " order by Owner_ID, New_Owner_ID, sku, PO_No, New_PO_No, user_line_item_no;"  

ldsOC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PANDORA Owner change Transaction.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsOC.SetTransObject(SQLCA)

lsLogOut = "      OM SOC Confirmation -Creating Inventory Transaction (OC) For TO_NO: " + asTONO
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

w_main.SetMicroHelp("Processing SOC945 (EDI - OM)")

// LTK 20110623 	Pandora #245 Create datastore to aggregate quantities for user line items.
//						The result set above could not be used because of the serial number grouping.
String ls_quantities_sql, ls_errors
Long ll_quantity_rows, ll_found
DataStore lds_quantites
lds_quantites = create DataStore

ls_quantities_sql   =	" SELECT user_line_item_no, SUM(quantity) as quantity_sum "
ls_quantities_sql +=	" FROM transfer_detail "
ls_quantities_sql +=	" WHERE to_no = '" + asTONO + "' "
ls_quantities_sql +=	" GROUP BY user_line_item_no; "

lds_quantites.Create(SQLCA.SyntaxFromSQL(ls_quantities_sql,"", ls_errors))

if Len(ls_errors) > 0 then
   lsLogOut = "        *** Unable to create quantities datastore for PANDORA Owner change Transaction.~r~r" + ls_errors
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
end if

lds_quantites.SetTransObject(SQLCA)
ll_quantity_rows = lds_quantites.Retrieve()
if ll_quantity_rows <= 0 then
   lsLogOut = "        *** Unable to retrieve quantities datastore for PANDORA Owner change Transaction.~r~r" 
	FileWrite(gilogFileNo,lsLogOut)
   Return - 1
end if
// Pandora #245  end of DataStore creation

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no('PANDORA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No', ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrieve next available sequence number for PANDORA Owner Change confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrieve the OC Data
lsLogout = 'Retrieving Owner Change.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsOC.Retrieve(lsProject)
if llRowCount <= 0 then return 0

// LTK 20160106  Skip confirmation if order number begins with RECON per Dave
if ldsOC.RowCount() > 0 then
	ls_order_no = Upper( Trim( ldsOC.GetItemString(1, 'user_field3') ))
	if Left( ls_order_no, 5 ) = 'RECON' then
		lsLogOut = "   ***Order begins with RECON, skip the Owner Change confirmation."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		Return 0
	end if
end if

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//TODO get change no
ll_change_req_no = ldsOC.GetItemNumber(1, 'OM_Change_Request_Nbr')
If IsNull(ll_change_req_no) Then ll_change_req_no =0
//ll_change_req_no = aitransid

//Write the rows to the generic output table - delimited by '|'
lsLogOut = 'Processing Owner Change Confirmation.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

		ldOwnerID = ldsOC.GetItemNumber(1, 'owner_id')
			select owner_cd into :lsOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldOwnerID;

		ldNewOwnerID = ldsOC.GetItemNumber(1, 'new_owner_id')
			select owner_cd into :lsNewOwnerCD
			from owner
			where project_id = :asProject and owner_id = :ldNewOwnerID;


ls_whcode =ldsOC.GetItemString(1, 'D_Warehouse')

select GMT_Offset into :ls_gmt_offset 
from Warehouse with(nolock) where wh_code =:ls_whcode
using sqlca;

//1. Write Header Records into OMQ_Warehouse_Order Table

w_main.SetMicroHelp(" OC Row a " + + String(f_getLocalWorldTime('PND_MTV')))

//Build and Write  Header Records
//Write to File and Screen
lsLogOut = '      - OM SOC Confirmation- Processing Header Record for To_No: ' + astono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


//TAM 11/01/2017 - ll_change_req_no does not have a value then this was created by a cycle count SOC.  We don't create the OMQ_Warehouse_Order or Detail(Only the OMQ Inventory Transactions)
If ll_change_req_no > 0 Then //Only write if Change request nbr > 0 - Start
	llNewRow = idsOMQWhDOMain.insertRow(0)
	idsOMQWhDOMain.setitem( 1, 'CLIENT_ID', ls_client_id)
	idsOMQWhDOMain.setitem(1, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
	idsOMQWhDOMain.setitem( 1, 'QACTION', 'U') //Action- U (Update)
	idsOMQWhDOMain.setitem( 1, 'QSTATUS', 'NEW')
	idsOMQWhDOMain.setitem( 1, 'QSTATUSDATE', ldtToday)
	idsOMQWhDOMain.setitem( 1, 'QSTATUSSOURCE', 'SIMSSWEEPER')
	idsOMQWhDOMain.setitem( 1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
	idsOMQWhDOMain.setitem( 1, 'ADDDATE', ldtToday)
	idsOMQWhDOMain.setitem( 1, 'ADDWHO', 'SIMSUSER')
	idsOMQWhDOMain.setitem( 1, 'EDITDATE', ldtToday)
	idsOMQWhDOMain.setitem( 1, 'EDITWHO', 'SIMSUSER')
	idsOMQWhDOMain.setitem( 1, 'ACTUALSHIPDATE', ldsOC.GetItemDateTime(1, 'complete_date'))
	idsOMQWhDOMain.setitem( 1,'CHANGE_REQUEST_NBR', ll_change_req_no) //ToNo
	idsOMQWhDOMain.setitem(1, 'EXTERNORDERKEY', trim(ldsOC.GetItemString(1, 'User_Field3'))) //ToNo
	idsOMQWhDOMain.setitem(1, 'TYPE', 'SOC') //Type
	idsOMQWhDOMain.setitem(1, 'ORDERGROUP', 'SOC') //Order Group
	idsOMQWhDOMain.setitem(1, 'ORDERKEY', Right(trim(asToNo),10)) //Order Key (To No)
	idsOMQWhDOMain.setitem(1, 'STATUS', 'SHIPPED') //Status 
	idsOMQWhDOMain.setitem(1, 'CONSIGNEEKEY', left(lsNewOwnerCD,15)) //Consignee Key
	idsOMQWhDOMain.setitem(1, 'CLIENT_SHIPTO_ID', lsNewOwnerCD) //Consignee Key
//TAM 2017/12/07 - Changed mapping for Remark
//	idsOMQWhDOMain.setitem(1, 'TRANSPORTATIONSERVICE', trim(ldsOC.GetItemString(1, 'Remark'))) //Consignee Key
	idsOMQWhDOMain.setitem(1, 'NOTES2', trim(ldsOC.GetItemString(1, 'Remark'))) //Consignee Key
	idsOMQWhDOMain.setitem(1, 'REFCHAR1', trim(ldsOC.GetItemString(1, 'user_field4'))) //Requestor
	idsOMQWhDOMain.setitem(1, 'REFCHAR2', trim(ldsOC.GetItemString(1, 'user_field5'))) //Requestor Email
	idsOMQWhDOMain.setitem(1, 'SUSR2', this.gmtformatoffset(ls_gmt_offset)) //Warehouse.GMT_Offset
	idsOMQWhDOMain.setitem(1, 'DIVISION', trim(asToNo)) //ToNo

	//Add OMQ Attribute for Ship From Contact Construct
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SFC3')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipFromContact') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID',  long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(trim(asToNo),10)) //Order Key (To No)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', trim(ldsOC.GetItemString(1, 'user_field4'))) //Requestor
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR2', trim(ldsOC.GetItemString(1, 'user_field5'))) //Requestor Email
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')


	w_main.SetMicroHelp("Processing 945 SOC - Header Row completed")
End If //Skip writing if Change request nbr is blank - End

//Write to File and Screen
lsLogOut = '      - OM SOC Confirmation- Processing Detail Record for To_No: ' + astono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. Write Detail Records into OMQ_Warehouse_Order_Detail Table


For llRowPos = 1 to llRowCount

	//**** TimA 05/09/14 Start Pandora issue #36
	//TimA 4/21/14  Re-confirming an SOC order with selected detail rows
	//Store the value of the line for comparison if there are paramaters passeed
	ls_line_no =  string ( ldsOC.GetItemNumber ( llRowPos,'user_line_item_no' ) )

	//TimA 05/09/14 Pandora Issue #36 Re-confirming an SOC order with selected detail rows
	//New function that will validate the transparm
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )


	//If there are values in the astransparm but the row does not match the current row skip to the next record.
	//TimA 05/05/14 Pandora issue #36
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if

	//**** TimA 05/09/14 End Pandora issue #36

	//TAM 07/12/2010 - Added a new subline type to send the serial numbers
//	If	(lsSaveSku <> ldsOC.GetItemString(llRowPos, 'sku') and lsSavePoNo <> ldsOC.GetItemString(llRowPos, 'po_no') and lsSaveNewPoNo <> ldsOC.GetItemString(llRowPos, 'new_po_no') and	lsSaveLineNumber <> string(ldsOC.GetItemNumber(llRowPos,'line_item_no'))) then
	lsCurrentSku = ldsOC.GetItemString(llRowPos, 'sku')
	lsCurrentPoNo = ldsOC.GetItemString(llRowPos, 'po_no')
	lsCurrentNewPoNo = ldsOC.GetItemString(llRowPos, 'new_po_no')
	lsCurrentLineNumber = string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no'))

	If	lsSaveSku <> lsCurrentSKU or lsSavePoNo <> lsCurrentPoNo or lsSaveNewPoNo <> lsCurrentNewPoNo or lsSaveLineNumber <> lsCurrentLineNumber then
		lsSaveSku = lsCurrentSKU
		lsSavePoNo = lsCurrentPoNo
		lsSaveNewPoNo = lsCurrentNewPoNo
		lsSaveLineNumber = lsCurrentLineNumber
	
	 	// LTK 20110623  Pandora #245 Set quantity to correct value for serialized sku's
		//lsOutString += NoNull(string(ldsOC.GetItemNumber(llRowPos, 'total_qty'))) + "|"
		ll_found = lds_quantites.Find("user_line_item_no = " + lsCurrentLineNumber, 1, ll_quantity_rows)
		if ll_found <= 0 then
			lsLogOut = "   ***Unable to find user line item quantities in aggregation datastore for PANDORA Owner Change confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If

//TAM 11/01/2017 - ll_change_req_no does not have a value then this was created by a cycle count SOC.  We don't create the OMQ_Warehouse_Order or Detail(Only the OMQ Inventory Transactions)
		If ll_change_req_no > 0 Then //Only write if Change request nbr > 0 - Start
			ll_detail_row =idsOMQWhDODetail.insertrow( 0)
			idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR',ll_change_req_no)
			idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'U') //Action- U (Update)
			idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
			idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
			idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
			idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
			idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
			idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
			idsOMQWhDODetail.setitem(ll_detail_row, 'STATUS', 'SHIPPED')
			idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
			idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
			idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
			idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')
			idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE01',lsOwnerCD)
			idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(ldsOC.GetItemString(1, 'User_Field3')))
			idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', lsSaveLineNumber)
			idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(asToNo),10))
			idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no') ,'00000'))
			idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', lsSaveSKU)
			idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE03', lsSavePoNo) //Po No
			idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', lsOwnerCD +'~~'+lsSavePoNo) //Owner_CD, '~', PO_NO (ex: WHIACBP~MAIN)
			idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR1', lsSaveNewPoNo) //To Project (UF5)	

			lsOutString += NoNull(string(lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))) + "|"
			idsOMQWhDODetail.setitem( ll_detail_row, 'OPENQTY', lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))
			idsOMQWhDODetail.setitem( ll_detail_row, 'ORDEREDSKUQTY', lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))
			idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))
			idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', lds_quantites.GetItemNumber(ll_found, 'quantity_sum'))
			// LTK 20110623  Pandora #245 end of code

			//Write to File and Screen
			lsLogOut = '      - OM SOC Confirmation- Processing Detail Record for To_No: ' + astono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+lsSaveLineNumber
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
  
		//3. Write Serial No Records into OMQ_Warehouse_OrderDetail_Sernum Table
			
			//TAM 07/12/2010 - Added a new subline type to send the serial numbers
			If Not IsNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child')) and  ldsOC.GetItemString(llRowPos, 'Serial_no_Child') <> '' Then
				if Trim( ldsOC.GetItemString(llRowPos, 'Serial_no_Child') ) <> '-' then	// LTK 20160106 Pandora #1002 - commented out line above and replaced with this line
					ll_serial_row =idsOMQWhDOSerial.insertrow( 0)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QACTION', 'I') //Action- U (Update)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUS', 'NEW')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
					idsOMQWhDOSerial.setitem( ll_serial_row, 'CLIENT_ID', ls_client_id)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
					idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDWHO', 'SIMSUSER')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITDATE', ldtToday)
					idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITWHO', 'SIMSUSER')
					idsOMQWhDOSerial.setitem( ll_serial_row, 'WH_ORDER_NBR', Right(astono, 10)) //Do No
					idsOMQWhDOSerial.setitem( ll_serial_row, 'WH_ORDERLINE_NBR', string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no') ,'00000')) //Line Item No
					idsOMQWhDOSerial.setitem( ll_serial_row, 'SERIALNUMBER', NoNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child'))) //Serial No
					idsOMQWhDOSerial.setitem( ll_serial_row, 'CASEID', '-') //Case Id
					idsOMQWhDOSerial.setitem( ll_serial_row, 'SERIALNUMTRANSID', string(gu_nvo_process_files.uf_get_next_seq_no(asproject, 'OMQ_SERIALNUM_TRANS_ID', 'SERIAL_TRANSID'))) //SERIALNUMTRANSID
				End if
			End If
		End If //Only write if Change request nbr > 0 - End	
		//4. Write records into OMQ_Inventory_Transaction Table

		//Decrement Adjustment Record
		ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
		idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
		idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
		idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
		idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
		ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
		idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'WD') //Tran Type as AJ (Adjustment)
		idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSaveSKU) //Adjustment.Sku
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOwnerCD) //Adjustment.Old_Owner_Cd
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsSavePoNo) //Adjustment.Old_Po_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 -  lds_quantites.GetItemNumber(ll_found, 'quantity_sum')) //Adjustment.Old_Qty
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(Trim(asTono),10)) //Adjustment.Adjustment Id
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
		idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(asToNo,10)+ string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no') ,'00000')) //Transfer.Ro_No
//TAM 11/01/2017 - We only set the the OMQ_Inventory_transaction.SOURCETYPE = 'ntrTransferDetailAdd' for SOCs created by a CC(ll_change_req_no = 0)
//		If lsSaveNewPoNo = 'RESEARCH' then 
		If lsSaveNewPoNo = 'RESEARCH' and ll_change_req_no = 0 then 
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ntrTransferDetailAdd') //ntrTransferDetailAdd
		Else 
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'SOC') //ntrTransferDetailAdd
		End If
			
		//Increment Adjustment Record
		ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
		idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
		idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
		idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
		idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
		idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
		ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
		idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'DP') //Tran Type as AJ (Adjustment)
		idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
		idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSaveSKU) //Adjustment.Sku
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwnerCD) //Adjustment.New_Owner_Cd
		idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsSaveNewPoNo) //Adjustment.Po_No
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', lds_quantites.GetItemNumber(ll_found, 'quantity_sum')) //Adjustment.Qty
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(Trim(asTono),10)) //Adjustment.Adjustment Id
		idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
		idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(asToNo,10)+ string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no') ,'00000')) //Adjustment.Ro_No
//TAM 11/01/2017 - We only set the the OMQ_Inventory_transaction.SOURCETYPE = 'ntrTransferDetailAdd' for SOCs created by a CC(ll_change_req_no = 0)
//		If lsSaveNewPoNo = 'RESEARCH' then 
		If lsSaveNewPoNo = 'RESEARCH' and ll_change_req_no = 0 then 
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ntrTransferDetailAdd') //ntrTransferDetailAdd
		Else 
			idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'SOC') //ntrTransferDetailAdd
		End If

	Else  // TAM New Serial Row subline
		If ll_change_req_no > 0 Then //Only write if Change request nbr > 0 - Start

		 	if Trim( ldsOC.GetItemString(llRowPos, 'Serial_no_Child') ) <> '-' then	// LTK 20160129 Pandora #1002 - commented out line above and replaced with this line
				ll_serial_row =idsOMQWhDOSerial.insertrow( 0)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'QACTION', 'I') //Action- U (Update)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUS', 'NEW')
				idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSDATE', ldtToday)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
				idsOMQWhDOSerial.setitem( ll_serial_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
				idsOMQWhDOSerial.setitem( ll_serial_row, 'CLIENT_ID', ls_client_id)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'SITE_ID', ldsOC.GetItemString(1, 'D_Warehouse')) //site id
				idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDDATE', ldtToday)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'ADDWHO', 'SIMSUSER')
				idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITDATE', ldtToday)
				idsOMQWhDOSerial.setitem( ll_serial_row, 'EDITWHO', 'SIMSUSER')
				idsOMQWhDOSerial.setitem( ll_serial_row, 'WH_ORDER_NBR', Right(astono, 10)) //Do No
				idsOMQWhDOSerial.setitem( ll_serial_row, 'WH_ORDERLINE_NBR', string(ldsOC.GetItemNumber(llRowPos,'user_line_item_no') ,'00000')) //Line Item No
				idsOMQWhDOSerial.setitem( ll_serial_row, 'SERIALNUMBER', NoNull(ldsOC.GetItemString(llRowPos, 'Serial_no_Child'))) //Serial No
				idsOMQWhDOSerial.setitem( ll_serial_row, 'CASEID', '-') //Case Id
				idsOMQWhDOSerial.setitem( ll_serial_row, 'SERIALNUMTRANSID', string(gu_nvo_process_files.uf_get_next_seq_no(asproject, 'OMQ_SERIALNUM_TRANS_ID', 'SERIAL_TRANSID'))) //SERIALNUMTRANSID
			End If
		End If //Only write if Change request nbr > 0 - End	
		//Jxlim 03/29/2011 End of code.
	End If	

	
	//TimA 05/05/14 Pandora issue #36.  Skip the rows that were no choosen for the reconfirm.
	skipDetailRow:
Next /*next output record */

If ll_change_req_no > 0 Then //Only write if Change request nbr > 0 - Start
	idsOMQWhDOMain.setitem(1, 'LINECOUNT', idsOMQWhDODetail.rowcount( )) //Line count
End If	

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;
ll_rc = 1 //idsOMQWhDOMainrowcount  will be 0 if it is a CC SOC so we need to initialized it to update the invTrans
If idsOMQWhDOMain.rowcount( ) > 0 Then 	ll_rc =idsOMQWhDOMain.update( false, false);		//OMQ_Warehouse_Order
If idsOMQWhDODetail.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQWhDODetail.update( false, false); //OMQ_Warehouse_OrderDetail
If idsOMQWhDOSerial.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOSerial.update( false, false); //OMQ_Wh_Orderdetail_Sernum
If idsOMQWhDOAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOAttr.update( false, false); //OMQ_Wh_OrderAttr
If idsOMQInvTran.rowcount( ) > 0 and ll_rc =1 Then ll_rc = idsOMQInvTran.update( false, false); //OMQ_InvTrans

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQWhDOMain.resetupdate( )
		idsOMQWhDODetail.resetupdate( )
		idsOMQWhDOSerial.resetupdate( )
		idsOMQWhDOAttr.resetupdate( )
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQWhDOMain.reset( )
		idsOMQWhDODetail.reset()
		idsOMQWhDOSerial.reset()
		idsOMQWhDOAttr.reset( )
		idsOMQInvTran.reset( )
		//MessageBox("ERROR", om_sqlca.SQLErrText)
		
		//Write to File and Screen
		lsLogOut = '      - OM SOC Confirmation- Processing Detail Record for To_No: ' + astono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//MessageBox("ERROR", "System error, record save failed!")
	//Write to File and Screen
	lsLogOut = '      - OM 945 SOC Confirmation- Processing Detail Record for To_No: ' + astono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy idsOMQWhDOMain 
destroy idsOMQWhDODetail 
destroy idsOMQWhDOSerial
destroy idsOMQInvTran

//Attach SOC Serial No's
If ll_change_req_no =0 Then this.uf_process_oc_sn_om( asproject, aitransid, astono)

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM
Return 0
end function

public function string gmtformatoffset (string asgmtoffset);//22-SEP-2017 :Madhu PINT- 945 Format GMT OffSet
//It should be -0400 instead -4:00

long  ll_Pos, ll_Sign_Pos, ll_gmtoffset
String ls_gmt_offset, ls_left, ls_right, ls_Sign

ll_gmtoffset = len(asgmtoffset) //length of gmt

ll_Sign_Pos = Pos(asgmtoffset, '+') //sign position
If ll_Sign_Pos =0 Then ll_Sign_Pos = Pos(asgmtoffset, '-')

ls_Sign =left(asgmtoffset, (ll_gmtoffset - (ll_gmtoffset - ll_Sign_Pos))) //sign value

If isNull(ls_Sign) or ls_Sign='' or len(ls_Sign) =0 Then ls_Sign ='+' //set default value to Sign

If ll_Sign_Pos = 0 Then //Default (+)
	ll_Pos = Pos(asgmtoffset, '.')
else 						 //Sign could be (-)
	asgmtoffset = Right(asgmtoffset, (ll_gmtoffset - ll_Sign_Pos))
	ll_Pos = Pos(asgmtoffset, '.')
End If

If ll_Pos > 0 Then
	ls_left = left(asgmtoffset, (ll_Pos -1))
	ls_right = Right(asgmtoffset, (len(asgmtoffset) - ll_Pos)) 
	
	ls_left =String(long(ls_left),'00')
	ls_right =String(long(ls_right),'00')
	ls_gmt_offset =  ls_Sign +ls_left + ls_right
	
End If


return ls_gmt_offset

end function

public function integer uf_process_cc_om (string as_project, string as_ccno, long altransid);//Jxlim 03/24/2011 This function create OCR and OCC file
//OCC file 4C1 Cyc ACK (Cycle Count) confirmation, no serial_no in the file, thus no changed from Ian list #165
//Prepare a Cycle Count confirmation for PANDORA for given order (confirmed since last sweeper cycle)
/*  - Pandora 
                                                
*/

Long                      llRowPos, llRowCount, llFindRow,             llNewRow, llDetailFindRow, llcc_detailcount

String    lsFind, lsOutString, lsMessage, lsLogOut, lsOwnerCD, lsGroup, lsGigYN, lsWH, lsTransYN, lsElectronicYN
string     lsToProject, lsTransType, lsRemarks, lsFromProject, lsDetailFind, ls_ordType,ls_diff,ls_line_no

Decimal                ldBatchSeq, ldOwnerID //, ldOwnerID_Prev
Integer liRC
DateTime ldtTemp, ldtToday


string                lsPopLoc, lsInvoice, lsRONO, lsPndser
datastore         ldsCCMaster, ldsCCDetail, ldsCC_Out, ldsOutSOC
double              ldQty, ldQtyCount, ldAllocQty, ldNewRecptQty
string                lsOrder, lsFileName, lsABCClass, lsSKU, lsDesc, lsOwner, lsOrg, lsReasonCD, lsReasonDesc, lsFileNameSOC, lsOutStringSOC, lsSequence, lsProject, lsOrdStatus,ls_client_id
datetime           ldtCountDate
decimal			ldOMQ_Inv_Tran	
long                  llNewRowSOC,ll_Inv_Row, ll_rc

gu_nvo_process_files.uf_connect_to_om( as_project) //connect to OT29 DB.

If Not isvalid(idsOut) Then
                idsOut = Create Datastore
                idsOut.Dataobject = 'd_edi_generic_out'
                lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsOutSOC) Then
                //used to write output if there needs to be stock adjustments created (SIMS qty > Count qty)
                ldsOutSOC = Create Datastore
                ldsOutSOC.Dataobject = 'd_edi_generic_out'
                lirc = ldsOutSOC.SetTransobject(sqlca)
End If

If Not isvalid(ldsCC_Out) Then
                //datastore to capture rolled-up cc_inventory records to be written to ldsOUT
                ldsCC_Out = Create Datastore
                ldsCC_Out.Dataobject = 'd_cc_inventory'
End If

If Not isvalid(ldsCCMaster) Then
                ldsCCMaster = Create Datastore
                ldsCCMaster.Dataobject = 'd_cc_master'
                ldsCCMaster.SetTransObject(SQLCA)
End If

If Not isvalid(ldsCCDetail) Then
                ldsCCDetail = Create Datastore
                ldsCCDetail.Dataobject = 'd_cc_inventory'
                ldsCCDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)
	
idsOMQInvTran.reset()
idsOut.Reset()
//ldsCC_Out.Reset()

ldtToday = DateTime(Today(), Now())


lsLogOut = "      Creating Cycle Count confirmation (CC) For CCNO: " + as_CCNO
FileWrite(gilogFileNo,lsLogOut)
                
//Retrieve the CC Master and CC Inventory records for this order
If ldsCCMaster.Retrieve(as_CCNo) <> 1 Then
                lsLogOut = "                  *** Unable to retrieve Cycle Count Order Header For CC_NO: " + as_CCNO
                FileWrite(gilogFileNo,lsLogOut)
                Return -1
End If

//For Pandora, instead of WH Code, we need the Sub-Inventory Location (Owner_CD)
//  (still need wh_code to determine GMT Offset to set time stamp to Pacific
lsWH = ldsCCMaster.GetItemString(1, 'wh_code')
lsOrdStatus = upper(ldsCCMaster.GetItemString(1, 'ord_status'))

//we only send confirmations for pandora-directed cycle counts (ord_type 'P')
//if ldsCCMaster.GetItemString(1, 'Create_User')  = 'SIMSFP' then
ls_ordtype = ldsCCMaster.GetItemString(1, 'ord_type')
if ldsCCMaster.GetItemString(1, 'ord_type')  = 'P' then
                lsElectronicYN = 'Y'
else
                lsElectronicYN = 'N'
               // return -1
end if

ldsCCDetail.Retrieve(as_CCNO)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(as_project, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
                lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Cycle Count Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
                FileWrite(gilogFileNo,lsLogOut)
                Return -1
End If
lsFileName = 'OCC' + String(ldBatchSeq, '000000') + '.DAT'

// 03-09 - Get the next available Trans_ID sequence number 
//TODO - Necessary?
//ldTransID = gu_nvo_process_files.uf_get_next_seq_no(as_Project, 'Transactions', 'Trans_ID')
//If ldTransID <= 0 Then Return -1


// LTK 20150805  CC Rollup Changes - Spread out any rolled up quantities before the OCR check is conducted below
n_cc_utils ln_cc_utils
ln_cc_utils = CREATE n_cc_utils

ln_cc_utils.uf_spread_rolled_up_si_counts( ldsCCDetail )

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :as_project
using sqlca;


llRowCount = ldsCCDetail.RowCount()
For llRowPos = 1 to llRowCount  //each row in d_cc_inventory (which includes fields from inventory and result 1, 2 and 3 tables)
                // Rolling up to Sku/Owner/Project...
                lsFind = "upper(sku) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')) + "'"
//            lsFind += " and line_item_no = " + string(ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no'))
                lsOwner = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd') //lsOwner is used later to write 'ORG' to Header record (Datawindow d_cc_inventory has owner_owner_cd)
                lsFind += " and owner_owner_cd = '" + lsOwner + "'" //Datawindow has owner_owner_cd
                lsFind += " and upper(po_no) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'po_no')) + "'"
                
                llFindRow = ldsCC_Out.Find(lsFind, 1, ldsCC_Out.RowCount())

                If llFindRow > 0 Then /*row already exists, add the qty*/
                                //grab the latest count result (3, then 2, then 1)
                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
                                if isNull(ldQtyCount) or ldQtyCount = 0 then
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
                                end if
                                if isNull(ldQtyCount) or ldQtyCount = 0 then
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
                                end if
                                if isNull(ldQtyCount) then
                                                ldQtyCount = 0
                                end if
                                //setting the counted quantity in result_1 and will compare that to quantity (what SIMS thinks) to possibly trigger SOC
                                //ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQty)
                                ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQtyCount)
                                //update SIMS Qty
                                ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
                                if isNull(ldQty) then
                                                ldQty = 0
                                end if
                                ldsCC_Out.SetItem(llFindRow,'quantity', ldsCC_Out.GetItemNumber(llFindRow, 'quantity') + ldQty)
                                // dts - 08/10/10 - save a reason code if one is not already saved....
                                lsReasonCd = ldsCC_Out.GetItemString(llFindRow, 'reason')
                                if NoNull(lsReasonCd) = '' then
                                                lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
                                                if NoNull(lsReasonCd) <> '' then
                                                                ldsCC_Out.SetItem(llFindRow, 'reason', lsReasonCd)
                                                end if
                                end if                    
                Else /*not found, add a new record*/
                                llNewRow = ldsCC_Out.InsertRow(0)
                                ldsCC_Out.SetItem(llNewRow, 'sku', ldsCCDetail.GetItemString(llRowPos, 'sku'))
                                ldsCC_Out.SetItem(llNewRow, 'po_no', ldsCCDetail.GetItemString(llRowPos, 'po_no'))
                                ldsCC_Out.SetItem(llNewRow, 'owner_owner_cd', ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd'))
                                // owner_id is not used in output file, but is used in alloc qty lookup
                                ldsCC_Out.SetItem(llNewRow, 'owner_id', ldsCCDetail.GetItemNumber(llRowPos, 'owner_id'))
                                ldsCC_Out.SetItem(llNewRow, 'sequence', ldsCCDetail.GetItemString(llRowPos, 'sequence'))
//                                                            ldsCC_Out.SetItem(llNewRow, 'trans_line_no', ldsCCDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
                                                
                                //Quantity - grab the latest count result (3, then 2, then 1)
                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
                                if ldQtyCount > 0 then
                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count3_complete')
                                else
                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
                                                if ldQtyCount > 0 then
                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count2_complete')
                                                else
                                                                ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
                                                                if ldQtyCount > 0 then
                                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count1_complete')
                                                                else
                                                                                //ldtCountDate = datetime('2999-12-31') //TODO???
                                                                                ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'complete_date')
                                                                end if
                                                end if //Result_2 > 0
                                end if //Result_3 > 0
                                if isNull(ldQtyCount) then
                                                ldQtyCount = 0
                                end if
                                //ldsCC_Out.SetItem(llFindRow,'quantity', (ldsCC_Out.GetItemNumber(llFindRow,'quantity') + ldsCCDetail.GetItemNumber(llRowPos, 'quantity')))
                                ldsCC_Out.SetItem(llNewRow, 'result_1', ldQtyCount) // using result_1 to hold result1, 2, or 3 as appropriate
                                ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
                                if isNull(ldQty) then
                                                ldQty = 0
                                end if
                                ldsCC_Out.SetItem(llNewRow,'quantity', ldQty)
                                ldsCC_Out.SetItem(llNewRow, 'expiration_date', ldtCountDate) // just using expiration_date to hold the Count Date
                                // 6/24 ???
                                lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
                                ldsCC_Out.SetItem(llNewRow,'reason', lsReasonCd)

                                                
                End If // New Record

                if ldQTY > ldQtyCount and lsOrdStatus <> 'V' then
  
		//4. Write records into OMQ_Inventory_Transaction Table

				 lsSKU = upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')	)
				 lsProject = upper(ldsCCDetail.GetItemString(llRowPos, 'po_no'))
	  		      ls_line_no= string(ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no'),'00000')
		
				//Decrement Adjustment Record	
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWH) //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(as_Project, 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'WD') //Tran Type as AJ (Adjustment)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date

				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Sku
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOwner) //Old_Owner_Cd
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsProject) //Old_Po_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', ldQtyCount -  ldQty) //Qty
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(Trim(as_ccno),10))
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(as_ccNo,10)+ ls_line_no) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ntrTransferDetailAdd') //ntrTransferDetailAdd
			
		//Increment Adjustment Record
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWH) //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(as_Project, 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'DP') //Tran Type as AJ (Adjustment)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSKU) //Adjustment.Sku
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsOwner) //New_Owner_Cd
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', 'RESEARCH') 
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', ldQty -  ldQtyCount)
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(Trim(as_ccno),10)) //Adjustment.Adjustment Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(as_ccNo,10)+ ls_line_no) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ntrTransferDetailAdd') //ntrTransferDetailAdd

			//create SOC
				// Create a separate file for each line that needs an Owner Change (actually project change)
				//Jxlim 06/06/2011 added cc_no and line item #BRD 233                
				ls_line_no= string(ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no'))

				lsFileNameSOC = 'OCR' + String(ldBatchSeq, '000000') + '_' + ls_line_no + '.DAT'
				ldsOutSOC.reset()

				/*write header.  For now, there will be a single header/detail for each sequence that needs adjustment...
				    - may want to create a single file per owner.*/
				lsSequence = ldsCCDetail.GetItemString(llRowPos, 'sequence')				  
				lsOutStringSOC = "OC||" +lsOwner + "|" + lsOwner + "|" + lsSequence + "_" + ls_line_no +"||||"  //TimA 08/23/11  Pandora #285
				llNewRowSOC = ldsOutSOC.insertRow(0)
				ldsOutSOC.SetItem(llNewRowSOC, 'Project_id', as_Project)
				ldsOutSOC.SetItem(llNewRowSOC, 'edi_batch_seq_no', Long(ldBatchSeq))
				ldsOutSOC.SetItem(llNewRowSOC, 'line_seq_no', llNewRowSOC)
				ldsOutSOC.SetItem(llNewRowSOC, 'batch_data', lsOutStringSOC)
				ldsOutSOC.SetItem(llNewRowSOC, 'file_name', lsFileNameSOC) 
				//write detail...
				lsOutStringSOC = "OD|" + lsSKU +"|||" +lsProject +"|RESEARCH|1|" + string(ldQty - ldQtyCount) + "|||" + as_ccno + '|' + ls_line_no + '|'
				                
				llNewRowSOC = ldsOutSOC.insertRow(0)
	               ldsOutSOC.SetItem(llNewRowSOC, 'Project_id', as_Project)
	               ldsOutSOC.SetItem(llNewRowSOC, 'edi_batch_seq_no', Long(ldBatchSeq))
	               ldsOutSOC.SetItem(llNewRowSOC, 'line_seq_no', llNewRowSOC)
	               ldsOutSOC.SetItem(llNewRowSOC, 'batch_data', lsOutStringSOC)
	               ldsOutSOC.SetItem(llNewRowSOC, 'file_name', lsFileNameSOC) 
				                
	               //need to Write the inbound SOC File to the inbound Pandora directory...
	               uf_write_soc_inbound(ldsOutSOC)

                end if
                                

Next /* Next Detail record */

/* Write the Header record first, then for each distinct line/sku/owner/po_no (project), write an output record - 
     - multiple detail lines may be combined in a single output record (multiple locs for a sku) */
//header record....
llNewRow = idsOut.insertRow(0)
//lsOrder = ldsCCMaster.GetItemString(1, 'Order_No')
lsOrder = ldsCCMaster.GetItemString(1, 'User_Field1')  //TODO - Need to add field for capturing order number, or dedicate a user field for it?  Using UF1 for now
lsABCClass = ldsCCMaster.GetItemString(1, 'class')  //TODO - this is actually field class_start. how is class_start/class_end used?
select user_field3 into :lsOrg from customer where project_id = :as_project and cust_code = :lsOwner; //lsOwner is from the detail - assuming all Customers in file have same Org (since all from same WH).
ldtTemp = ldsCCMaster.GetItemDateTime(1, 'complete_date')
ldtTemp = GetPacificTime(lsWH, ldtTemp)
//lsOutString = 'CC|' + lsOrder + '|' + NoNull(lsOrg) + '|' + string(ldsCCMaster.GetItemDateTime(1, 'complete_date'), 'yyyymmddhhmmss')
lsOutString = 'CC|' + lsOrder + '|' + NoNull(lsOrg) + '|' + string(ldtTemp, 'yyyy-mm-ddThh:mm:ss')
if Upper(Trim(f_functionality_manager(as_Project,'FLAG','SWEEPER','UNIQUETRXID','',''))) = 'Y' then		// LTK 20150515  Added Unique ID to header record
	lsOutString += "|" + "S" + in_string_util.of_parse_numeric_sys_no( String(ldsCCMaster.Object.cc_no[ 1 ]) ) + "CC"
end if

idsOut.SetItem(llNewRow, 'Project_id', as_Project)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', lsFileName) 

//Scroll thru the holding datastore and write the records to the generic output table, fields delimited by '|'
llRowCount = ldsCC_Out.RowCount()
For llRowPos = 1 to llRowCount
                llNewRow = idsOut.insertRow(0)
                lsOutString = 'AVI|'  //Record type
                lsSequence = NoNull(ldsCC_Out.GetItemString(llRowPos, 'sequence'))
                lsOutString += lsSequence + '|' //Sequence - From Pandora
                lsOwnerCD = NoNull(ldsCC_Out.GetItemString(llRowPos, 'owner_owner_cd'))
                ldOwnerID = ldsCC_Out.GetItemNumber(llRowPos, 'owner_id')
                lsOutString += lsOwnerCD + '|' // 'Supplier Location' (menlo owner code) - Datawindow has owner_owner_cd
                lsSKU = ldsCC_Out.GetItemString(llRowPos, 'SKU')
                lsOutString += lsSKU + '|' // GPN
                lsDesc = ''
                select description into :lsDesc from item_master where project_id = :as_project and sku = :lsSKU;
                lsOutString += NoNull(lsDesc) + '|' // GPN Description
                lsOutString += 'EA|' // UOM - Always EA?
                lsOutString += NoNull(lsABCClass) + '|' // ABC Class
                ldQty = ldsCC_Out.GetItemNumber(llRowPos, 'quantity') 
                ldQtyCount = ldsCC_Out.GetItemNumber(llRowPos, 'result_1') // in this case, result_1 is result1, 2, or 3 as appropriate (and summed by owner/sku/project)
                // Status - status at the line. 'Uncounted' on inbound, 'Final Count' on confirmation (if counted)
                // - TODO - need to determine if the line has been counted (0 qty may actually be the qty)
                if lsOrdStatus = 'V' then //if the order is VOID-ed, send back confirmation with 0 and Uncounted
                                lsOutString += 'Uncounted|' 
                // 8/3/2010 - Only Voided orders are uncounted.  SOP says ops will count every line on a cycle count
                //elseif ldQty = 0 then // for now, means it was a SKU/Owner/po_no for which we did not have inventory and thus did not count
                //            lsOutString += 'Uncounted|' 
                else
                                // 7/1 - count = 0 is now still considered final count...
                                //if isNull(ldQtyCount) or ldQtyCount = 0 then
                                //            lsOutString += 'Uncounted|' 
                                //else
                                                lsOutString += 'Final Count|' 
                                //end if
                end if
                
                ldtCountDate = ldsCC_Out.GetItemDateTime(llRowPos, 'expiration_date')  //just using expiration_date to hold the count date
                if ldtCountDate = datetime('2999-12-31') then
                                lsOutString += '|'
                else
                                ldtCountDate = GetPacificTime(lsWH, ldtCountDate) // 2010-07-19 - added call to GetPacificTime
                                //lsOutString += String(ldtCountDate, 'yyyymmddhhmmss') + '|' //Count Date Count1_Complete, 2_complete, 3_complete from cc_master
                                lsOutString += String(ldtCountDate, 'yyyy-mm-ddThh:mm:ss') + '|' //Count Date Count1_Complete, 2_complete, 3_complete from cc_master
                end if
                if lsOrdStatus = 'V' then //if the order is VOID-ed, send back confirmation with 0 and Uncounted
                                lsOutString +=  '0|' // Count Qty + Allocated Qty
                                //lsOutString +=  lsReasonCd + '|'  
                                //lsOutString +=  'VOID' + '|'  
                                // 6/30 - hard coding '901' for Reason Code for Void-ed orders.
                                lsOutString +=  '901' + '|'  
                else
                                // Add allocated qty here...
                                /* 2010-08-08 : Not adding allocated qty any more as it is now included in the cycle count.
                                                                                                                But, we are now adding any receipts since the cycle count was created. 
                                                                                                                Per Ian, Ops is not supposed to count anything that was newly-received.
                                lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                                select sum(Quantity) into :ldAllocQty 
                                from delivery_master dm inner join delivery_picking dp on dm.do_no = dp.do_no
                                where project_id = 'PANDORA' and ord_status in ('P', 'A')
                                and sku = :lsSKU and owner_id = :ldOwnerID and po_no = :lsProject;
                                if isNull(ldAllocQty) then ldAllocQty = 0 */
                                // receipts since cycle count was created....
                                lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                                ldtTemp = ldsCCMaster.GetItemDateTime(1, 'ord_date')
                                //ldtTemp = GetPacificTime(lsWH, ldtTemp)
                                select sum(Quantity) into :ldNewRecptQty
                                from receive_master rm inner join receive_putaway rp on rm.ro_no = rp.ro_no
                                where project_id = 'PANDORA' and complete_date > :ldtTemp //TODO! What about time zone?
                                and sku = :lsSKU and owner_id = :ldOwnerID and po_no = :lsProject;
                                if isNull(ldNewRecptQty) then ldNewRecptQty = 0 
                                //lsOutString += NoNull(string(ldQtyCount + ldAllocQty)) + '|' // Count Qty + Allocated Qty                          
                                lsOutString += NoNull(string(ldQtyCount + ldNewRecptQty)) + '|' // Count Qty + new receipt Qty
                                //only print 'reason' if the count qty < SIMS qty
                                /* 6/24 what about Allocated? 
                                                - Current thought is Allocated inventory is already picked (so Count should = SIMS, without allocated)
                                                *8/08 - Allocated is now part of Cycle Count                                        */
                                //?if ldQtyCount + ldAllocQty < ldQty then           
                                // dts - 07/17/2010 - changed to '<>' instead of '<'
                                if ldQtyCount <> ldQty then
                                                lsReasonCd = NoNull(ldsCC_Out.GetItemString(llRowPos, 'Reason'))
                                                //6/23 - sending code now... 
                                                //if lsReasonCD > '' then
                                                //            select code_descript into :lsReasonDesc from lookup_table where project_id = :as_project and code_type = 'IA' and code_id = :lsReasonCD;
                                                //else
                                                //            lsReasonDesc = ''
                                                //end if
                                                lsOutString +=  lsReasonCd + '|'  
                                else
                                                //lsReasonDesc = ''
                                                lsOutString +=  '|'  
                                end if
                                //lsOutString +=  lsReasonDesc + '|'  
                end if //is Order 'Void'?
                lsOutString += NoNull(ldsCCMaster.GetItemString(1, 'last_user')) + '|'  //TODO - user at the line/count level? Per Ian, Using Last_User for now...
                lsOutString += NoNull(ldsCCMaster.GetItemString(1, 'remark'))  + '|' // Comments - TODO! - Comments at the line? Per Ian, Using Header Remark for now...
                lsOutString += as_ccno + '-' + string(llRowPos) + '|' // Partner Order Reference- Per Ian, Using CC_NO + '-' + record number 
                //moved above... lsProject = NoNull(ldsCC_Out.GetItemString(llRowPos, 'po_no'))
                lsOutString += lsProject  //+ '|'  //project code

//            ldtTemp = ldsCC_Out.GetItemDateTime(llRowPos, 'complete_date')
//            ldtTemp = GetPacificTime(lsWH, ldtTemp)
//            lsOutString += String(ldtTemp, 'yyyy-mm-dd hh:mm:ss') + '|'
                
                idsOut.SetItem(llNewRow, 'Project_id', as_Project)
                idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
                idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
                idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
                idsOut.SetItem(llNewRow, 'file_name', lsFileName) 
                //compare counted qty to SIMS qty.  If SIMS qty > Counted qty, create SOC to move excess to 'RESEARCH'
                /* 6/24 - Does the comparison need to include Allocated as well???
                                 - Current thought is Allocated inventory is already picked (so Count should = SIMS, without allocated) */
                /* 7/20 - added Order Status condition... */
                
next /*next output record */

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then ll_rc = idsOMQInvTran.update( false, false); //OMQ_InvTrans

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		//MessageBox("ERROR", om_sqlca.SQLErrText)
		
		//Write to File and Screen
		lsLogOut = '      - OM CC Confirmation- Processing Detail Record for CC_No: ' + as_ccno +"  failed to write to  OMQ_Inventory_Transaction Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//MessageBox("ERROR", "System error, record save failed!")
	//Write to File and Screen
	lsLogOut = '      - OM CC Confirmation- Processing Detail Record for CC_No: ' + as_ccno +" failed to write to  OMQ_Inventory_Transaction Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy idsOMQInvTran

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, as_Project)
Return 0

end function

public function string uf_get_rdd_timezone (long al_batch_seq_no, string as_invoice_no);//27-Oct-2017 :Madhu PINT- 945 - Return TYPE value from OM_Expansions_Table
String lsFind, ls_col_value
long llFindRow, ll_orig_batch_seq_no

If Not isvalid(idsOMExp) Then
	idsOMExp =Create u_ds_datastore
	idsOMExp.Dataobject ='d_om_expansion'
	idsOMExp.settransobject(SQLCA)
End If	

idsOMExp.reset( )
idsOMExp.retrieve(al_batch_seq_no) //Retrieve OM_Expansion_Table records

lsFind ="Column_Name ='RDD_Time_Zone'"
llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())

IF llFindRow > 0 Then

	ls_col_value =idsOMExp.getitemstring(llFindRow,'Column_value')

Else /* get from original order*/

	Select min(edi_batch_seq_no) into :ll_orig_batch_seq_no
	From Delivery_Master with(nolock)
	Where Project_id = 'PANDORA' and Invoice_No = :as_Invoice_No;
	
	If ll_orig_batch_seq_no > 0 Then
	
		idsOMExp.retrieve(ll_orig_batch_seq_no) //Retrieve OM_Expansion_Table records from original order
		llFindRow =idsOMExp.find(lsFind,1,idsOMExp.rowcount())

		If llFindRow > 0 Then
			ls_col_value =idsOMExp.getitemstring(llFindRow,'Column_value')
		Else
			ls_col_value =''
		End If
	
	Else
		ls_col_value = ''
	End If

End IF

Return ls_col_value
end function

public function string uf_process_om_receipt_type (string asproject, string asrono, string ascust_po_no);//26-Oct-2017 :Madhu PINT-861 - Return TYPE based on following rules.
String ls_source_type, ls_om_type

select Source_Type into :ls_source_type 
from Receive_Master with(nolock)
where Project_Id=:asproject and Ro_No=:asrono
using sqlca;

//TAM - 2019/05/20 - S33831 Treat Import orders the same as web orders when setting OM order type
//If Pos(upper(ls_source_type), 'WEB') > 0 Then  //If Order is loaded through WEB
If Pos(upper(ls_source_type), 'WEB') > 0 or  Pos(upper(ls_source_type), 'IMPORT') > 0 Then  //Also if loaded through import
	ls_om_type ='MANORD'
elseIf (Pos(ascust_po_no,'MOR') > 0 OR Pos(ascust_po_no,'MTR') > 0 OR Pos(ascust_po_no,'CMOR') > 0 &
			OR Pos(ascust_po_no,'CMTR') > 0 OR Pos(ascust_po_no,'FMOR') > 0 OR Pos(ascust_po_no,'FMTR') > 0) Then //If Order Prefix containes
	ls_om_type ='DLVORD'
else
	ls_om_type ='ASN'
End If

Return ls_om_type
end function

public function datastore uf_process_cc_reconciliation_serial (ref datastore adsorigsn, long alrow, string as_action_cd, string as_cc_loc, string as_cc_serial_no);//18-Nov-2017 :Madhu 3PL Cycle Count Orders
//a. Reconcile Serial numbers between the Serial Inventory table and the serial numbers scanned on the Cycle Count

long		 ll_new_row, ll_count

If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If

SetPointer(Hourglass!)

ll_new_row = idsCCRecon.insertrow( 0)
idsCCRecon.setItem( ll_new_row, 'Action_Cd', as_action_cd)
idsCCRecon.setItem( ll_new_row, 'Project_Id', adsOrigSN.getItemString(alrow, 'Project_Id'))
idsCCRecon.setItem( ll_new_row, 'WH_Code', adsOrigSN.getItemString(alrow, 'WH_Code'))
idsCCRecon.setItem( ll_new_row, 'Owner_Id', adsOrigSN.getItemNumber(alrow, 'Owner_Id'))
idsCCRecon.setItem( ll_new_row, 'Owner_Cd', adsOrigSN.getItemString(alrow, 'Owner_Cd'))
idsCCRecon.setItem( ll_new_row, 'SKU', adsOrigSN.getItemString(alrow, 'SKU'))
idsCCRecon.setItem( ll_new_row, 'Serial_No', as_cc_serial_no)
idsCCRecon.setItem( ll_new_row, 'Component_Ind', adsOrigSN.getItemString(alrow, 'Component_Ind'))
idsCCRecon.setItem( ll_new_row, 'Component_No', adsOrigSN.getItemNumber(alrow, 'Component_No'))
idsCCRecon.setItem( ll_new_row, 'Update_Date', DateTime(Today(),Now()))
idsCCRecon.setItem( ll_new_row, 'Update_User', 'SIMSFP')
idsCCRecon.setItem( ll_new_row, 'l_code', as_cc_loc)
idsCCRecon.setItem( ll_new_row, 'Lot_No', adsOrigSN.getItemString(alrow, 'Lot_No'))
idsCCRecon.setItem( ll_new_row, 'Po_No', adsOrigSN.getItemString(alrow, 'Po_No'))
idsCCRecon.setItem( ll_new_row, 'Po_No2', adsOrigSN.getItemString(alrow, 'Po_No2'))
idsCCRecon.setItem( ll_new_row, 'Exp_DT', adsOrigSN.getItemDateTime(alrow, 'Exp_DT'))
idsCCRecon.setItem( ll_new_row, 'RO_NO', adsOrigSN.getItemString(alrow, 'RO_NO'))					
idsCCRecon.setItem( ll_new_row, 'Inventory_Type', adsOrigSN.getItemString(alrow, 'Inventory_Type'))
	
ll_count =idsCCRecon.rowcount( )

Return idsCCRecon
end function

public function datastore uf_process_cc_reconciliation (string as_project, string as_ccno);//18-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
string		sql_syntax, lsErrors, lslogOut, ls_find, ls_ord_status, ls_owner_cd, ls_sku_prev, ls_serial_no, ls_formatted_serials
string		ls_wh, ls_sku, lsSkuFilter, ls_sku_list[], ls_formatted_skus, ls_cc_serial_no, ls_cc_lcode, ls_serial_list[]
string 	ls_SNI_PoNo, ls_SNI_sku, ls_SNI_suppcode, ls_SNI_serialNo, ls_count_type, ls_cc_sku, ls_Orig_sql
long		ll_scan_count, ll_row, ll_cc_sku_count, ll_SNI_sku_count, ll_find_row, ll_new_row, ll_SNI_OwnerId
long		ll_sku_list, ll_sku_row, ll_recon_count, ll_cc_inv_count, ll_owner, ll_return, ll_Orig_SNI_count, ll_scanned_row
boolean 	lbError =FALSE

datastore   ldsCCMaster, ldsCCInv, ldsCCScanSN, ldsOrigSN

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_reconciliation - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create Datastore
	ldsCCMaster.Dataobject = 'd_cc_master'
	ldsCCMaster.SetTransObject(SQLCA)
End If

If Not isvalid(ldsCCInv) Then
	ldsCCInv = Create Datastore
	ldsCCInv.Dataobject = 'd_cc_inventory'
	ldsCCInv.SetTransObject(SQLCA)
End If

//Reconcile SN Datastore
If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If

//Retrieve the CC Master and CC Inventory records for this order
If ldsCCMaster.Retrieve(as_CCNo) <> 1 Then
	lslogOut = "                  *** Unable to retrieve 3PL System Cycle Count Orders For CC_NO: " + as_ccno
	FileWrite(gilogFileNo,lsLogOut)
	lbError =TRUE
End If

ls_wh = ldsCCMaster.GetItemString(1, 'wh_code')
ll_cc_inv_count = ldsCCInv.retrieve(as_ccno )

//(A) - Reconcile Serial No's - CC Scanned Serial No's v/s Serial Number Inventory Table.

//get a list of SKU's against CC No from CC_Serial_Numbers Table
ldsCCScanSN = create Datastore
sql_syntax =" select * from CC_Serial_Numbers  with(nolock) where cc_no ='"+as_ccno+"'"
ldsCCScanSN.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))
ldsCCScanSN.settransobject( SQLCA)

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore for PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
	lbError =TRUE
END IF

ll_scan_count= ldsCCScanSN.retrieve( )

//get list of Serial No's
For ll_row =1 to ll_scan_count
	ls_serial_no = ldsCCScanSN.getItemString( ll_row, 'serial_no')
	ls_serial_list[ UpperBound(ls_serial_list) + 1 ] = ls_serial_no
Next

//format Serial No's
If UpperBound(ls_serial_list) > 0 Then 
	ls_formatted_serials = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 )
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_reconciliation - CC No: '+as_ccno +'  Scaned SN Count: '+string(ll_scan_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//get list of SKU's
For ll_row =1 to ll_scan_count
	ls_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
	If ls_sku_prev <> ls_sku Then	ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
	ls_sku_prev =ls_sku
Next

//format SKU's
If UpperBound(ls_sku_list) > 0 Then 
	ls_formatted_skus = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 )
End If

//get a list of SN's with combination of SKU+WH from SNI Table
ldsOrigSN = create Datastore
sql_syntax = " select * from Serial_Number_Inventory with(nolock) "
sql_syntax += " where Project_Id ='"+as_project+"' "
sql_syntax +=" and wh_code ='"+ls_wh+"' "
sql_syntax +=" and sku IN ("+ls_formatted_skus+")"
ldsOrigSN.create( SQLCA.syntaxfromsql( sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore for PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
	lbError =TRUE
END IF

ldsOrigSN.settransobject( SQLCA)
ll_Orig_SNI_count = ldsOrigSN.retrieve( )

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_reconciliation - CC_No: '+as_ccno +' Serial Number Inventory count against CC Scanned SKU: '+string(ll_Orig_SNI_count)
FileWrite(giLogFileNo,lsLogOut)
//gu_nvo_process_files.uf_write_log(lsLogOut)

ll_sku_list =UpperBound(ls_sku_list)

IF 	lbError =FALSE THEN
	//Compare SN's against CC_Serial_Number v/s Serial Number Inventory Table.
	FOR ll_row =1 to ll_sku_list
		ls_sku = ls_sku_list[ll_row]
		
		lsSkuFilter = "sku ='"+ls_sku+"'"
		ldsCCScanSN.Setfilter(lsSkuFilter)
		ldsCCScanSN.Filter()
		ll_cc_sku_count = ldsCCScanSN.rowcount( )
	
		ldsOrigSN.Setfilter(lsSkuFilter)
		ldsOrigSN.Filter()
		ll_SNI_sku_count = ldsOrigSN.rowcount( )
		
		//(1) Update - Serial No /Location on Serial Number Inventory Table.
		//If  ll_cc_sku_count =  ll_SNI_sku_count Then
		//	this.uf_process_cc_no_count( as_project, as_ccno, ls_wh)
		//else	
			idsCCRecon = this.uf_process_cc_up_down_count( as_project, as_ccno, ls_wh, ls_sku, ldsOrigSN, ldsCCScanSN)
		//END IF
	
		ll_recon_count =	idsCCRecon.rowcount( )
		
		//re-set filter
		ldsCCScanSN.Setfilter("")
		ldsCCScanSN.Filter()
		ldsCCScanSN.rowcount( )
		
		ldsOrigSN.Setfilter("")
		ldsOrigSN.Filter()
		ldsOrigSN.rowcount( )
	NEXT

END IF


//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_reconciliation - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


destroy ldsCCMaster
destroy ldsCCInv
destroy ldsCCScanSN 
destroy ldsOrigSN

Return idsCCRecon
end function

public function long uf_process_cc_auto_create_soc (string as_project, string as_cc_no);//20-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders.
//27-Nov-2018 :Madhu S26546 Cycle Count Adjustments (Look for Null Qty instead Qty =0)

string		lsFind, lsOwner_Cd, lsReasonCd, lsOrdStatus, ls_supp_code, lsLogOut, ls_cc_class_Code
string		ls_sku, ls_pono, ls_lcode, ls_req_SN, ls_trans_parm, ls_wh, ls_sequence
long		llRowCount, llFindRow, llNewRow, llRowPos, ll_row, ll_return
long		ll_Qty, ll_Qty_Count, ll_Qty_Up, ll_Qty_Down, ll_high_volume, ll_cc_line
double	ldBatchSeq, ldQty, ldQtyCount
datetime ldtCountDate

Str_Parms  ls_soc_parms

Datastore ldsCCDetail, ldsCC_Out, ldsCCMaster
n_cc_utils ln_cc_utils

SetPointer(HourGlass!)

If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create Datastore
	ldsCCMaster.Dataobject = 'd_cc_master'
	ldsCCMaster.SetTransObject(SQLCA)
End If

If Not Isvalid(ldsCCDetail) Then
	ldsCCDetail =create Datastore
	ldsCCDetail.dataobject='d_cc_inventory'
	ldsCCDetail.settransobject( SQLCA)
End IF

If Not isvalid(ldsCC_Out) Then
	 //datastore to capture rolled-up cc_inventory records to be written to ldsOUT
	 ldsCC_Out = Create Datastore
	 ldsCC_Out.Dataobject = 'd_cc_inventory'
End If

ldsCCMaster.reset( )
ldsCCDetail.reset( )

ldsCCMaster.retrieve( as_cc_no)
ldsCCDetail.Retrieve(as_cc_no)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_auto_create_soc  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ln_cc_utils = CREATE n_cc_utils
ln_cc_utils.uf_spread_rolled_up_si_counts( ldsCCDetail )

ls_wh = ldsCCMaster.getItemstring( 1, 'wh_code')

llRowCount = ldsCCDetail.RowCount()
For llRowPos = 1 to llRowCount
	// Rolling up to Sku/Owner/Project...
	lsFind = "upper(sku) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')) + "'"
	lsOwner_Cd = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd')
	lsFind += " and owner_owner_cd = '" + lsOwner_Cd + "'"
	lsFind += " and upper(po_no) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'po_no')) + "'"
	
	llFindRow = ldsCC_Out.Find(lsFind, 1, ldsCC_Out.RowCount())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
		if isNull(ldQtyCount) then
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
		end if
		if isNull(ldQtyCount) then
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
		end if
		if isNull(ldQtyCount) then
			ldQtyCount = 0
		end if
		
		ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQtyCount)
		ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
		if isNull(ldQty) then
			ldQty = 0
		end if
		ldsCC_Out.SetItem(llFindRow,'quantity', ldsCC_Out.GetItemNumber(llFindRow, 'quantity') + ldQty)
		lsReasonCd = ldsCC_Out.GetItemString(llFindRow, 'reason')
		if NoNull(lsReasonCd) = '' then
			lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
			if NoNull(lsReasonCd) <> '' then
			  ldsCC_Out.SetItem(llFindRow, 'reason', lsReasonCd)
			end if
		end if
	Else /*not found, add a new record*/
		llNewRow = ldsCC_Out.InsertRow(0)
		ldsCC_Out.SetItem(llNewRow, 'sku', ldsCCDetail.GetItemString(llRowPos, 'sku'))
		ldsCC_Out.SetItem(llNewRow, 'po_no', ldsCCDetail.GetItemString(llRowPos, 'po_no'))
		ldsCC_Out.SetItem(llNewRow, 'owner_owner_cd', ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd'))
		ldsCC_Out.SetItem(llNewRow, 'owner_id', ldsCCDetail.GetItemNumber(llRowPos, 'owner_id'))
		ldsCC_Out.SetItem(llNewRow, 'sequence', ldsCCDetail.GetItemString(llRowPos, 'sequence'))
	
		ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
		if NOT isNull(ldQtyCount) then
			ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count3_complete')
		else
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
			if NOT isNull(ldQtyCount) then
				 ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count2_complete')
			else
				 ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
				 if NOT isNull(ldQtyCount) then
					  ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count1_complete')
				 else
					  ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'complete_date')
				 end if
			end if //Result_2 > 0
		end if //Result_3 > 0

		if isNull(ldQtyCount) then
			ldQtyCount = 0
		end if
		ldsCC_Out.SetItem(llNewRow, 'result_1', ldQtyCount) // using result_1 to hold result1, 2, or 3 as appropriate
		ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
		if isNull(ldQty) then
			ldQty = 0
		end if
		ldsCC_Out.SetItem(llNewRow,'quantity', ldQty)
		ldsCC_Out.SetItem(llNewRow, 'expiration_date', ldtCountDate) // just using expiration_date to hold the Count Date
		lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
		ldsCC_Out.SetItem(llNewRow,'reason', lsReasonCd)
		
	End If // New Record
	
	ls_soc_parms.string_arg[1] = ldsCCDetail.GetItemString(llRowPos, 'sku')
	ls_soc_parms.string_arg[2] = ldsCCDetail.GetItemString(llRowPos, 'supp_Code')
	ls_soc_parms.string_arg[3] = ls_wh
	ls_soc_parms.string_arg[4] = ldsCCDetail.GetItemString(llRowPos, 'L_Code')
	ls_soc_parms.string_arg[5] = ldsCCDetail.GetItemString(llRowPos, 'Inventory_Type')
	ls_soc_parms.string_arg[6] =ldsCCDetail.GetItemString(llRowPos, 'Lot_No')
	ls_soc_parms.string_arg[7] =ldsCCDetail.GetItemString(llRowPos, 'PO_No')
	ls_soc_parms.string_arg[8] =ldsCCDetail.GetItemString(llRowPos, 'PO_No2')
	ls_soc_parms.string_arg[9] = ldsCCDetail.GetItemString(llRowPos, 'Country_of_Origin')
	ls_soc_parms.string_arg[10] = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd')
	ls_soc_parms.string_arg[11] = ldsCCDetail.GetItemString(llRowPos, 'Ro_No')
	ls_sequence = ldsCCDetail.GetItemString(llRowPos, 'sequence')
	
	//10-JULY-2018 :Madhu DE5038 - Assign right-6-chars of CCNo, if Sequence value is NULL /Empty
	If isNull(ls_sequence) or ls_sequence='' or ls_sequence =' ' Then
		ls_sequence = Right(as_cc_no, 6)
	End If
	
	ls_soc_parms.string_arg[13] = as_cc_no
	ls_soc_parms.string_arg[14] = ldsCCDetail.GetItemString(llRowPos, 'Container_ID')
	
	ls_soc_parms.long_arg[1] = ldsCCDetail.GetItemNumber(llRowPos, 'Owner_ID')
	ls_soc_parms.long_arg[2] = ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no')
	
	ll_Qty =long(ldQty)
	ll_Qty_Count = long(ldQtyCount)

	ll_Qty_Up = ll_Qty_Count - ll_Qty
	ll_Qty_Down = ll_Qty - ll_Qty_Count

	ls_soc_parms.long_arg[3] = ll_Qty
	ls_soc_parms.long_arg[4] = ll_Qty_Count
	
	ls_soc_parms.datetime_arg[1] = ldsCCDetail.GetItemDateTime(llRowPos, 'expiration_date')
	
	ll_cc_line = 	ls_soc_parms.long_arg[2]
	ls_sku = ldsCCDetail.GetItemString(llRowPos, 'sku')
	ls_supp_code = ldsCCDetail.GetItemString(llRowPos, 'supp_code')

	ls_soc_parms.string_arg[12] = ls_sequence+'_'+string(ll_cc_line)
	
	//creating SOC for Down Counts
	IF ldQty > ldQtyCount and lsOrdStatus <> 'V'  THEN
			ls_soc_parms.long_arg[5] = ll_Qty_Down
			
			SELECT count(*) into :ll_high_volume 
			FROM Item_Master A with(nolock) 
			INNER JOIN Commodity_Codes B with(nolock) ON A.User_Field5 = B.Commodity_Cd
			WHERE A.Project_Id =:as_project and A.sku =:ls_sku and A.Supp_code =:ls_supp_code
			using sqlca;
			
			select CC_Class_Code into :ls_cc_class_Code from Item_Master with(nolock) 
			where Project_Id =:as_project and sku =:ls_sku and Supp_code =:ls_supp_code
			using sqlca;
			
			IF (ll_high_volume > 0 OR upper(ls_cc_class_Code) ='A' )THEN
				ls_soc_parms.boolean_arg[1] = TRUE //High Value Item - Don't do Auto QTY Adjustment
			else
				ls_soc_parms.boolean_arg[1] = FALSE //Not High Value Item - Do Auto QTY Adjustment
			END IF

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_create_soc  - Down Count for  CC_No: '+as_cc_no +' - sku: '+ls_sku
			lsLogOut += ' - CC Line No: ' +string(ll_cc_line) +' - Qty: '+string(ll_Qty) +' - Result Qty: '+string(ll_Qty_Count) +' - High Value Item: ' +string(ll_high_volume)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			//Auto confirm SOC
			ll_return = this.uf_process_cc_auto_confirm_soc( as_project, ls_soc_parms)

			//Stock Adjustment
			ll_return = this.uf_process_cc_stock_adjustment( as_project, ls_soc_parms)
			
	END IF
	
	//UP Counts
	IF ldQty < ldQtyCount and lsOrdStatus <> 'V'  THEN

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_create_soc  - UP Count for  CC_No: '+as_cc_no +' - sku: '+ls_sku
			lsLogOut += ' - CC Line No: ' +string(ll_cc_line) +' - Qty: '+string(ll_Qty) +' - Result Qty: '+string(ll_Qty_Count)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			ls_soc_parms.long_arg[5] = ll_Qty_Up
			ls_soc_parms.boolean_arg[1] = FALSE
			
			//stock Adjustment
			ll_return =this.uf_process_cc_stock_adjustment( as_project, ls_soc_parms)

	END IF

Next

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_auto_create_soc  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCMaster
destroy ldsCCDetail
destroy ldsCC_Out

Return ll_return
end function

public function long uf_process_cc_auto_confirm_soc (string as_project, str_parms as_soc_parms);//23-Nov-2017 :Madhu PEVS-806 3PL Cycle count Order
//Create Auto-Confirm SOC

string		ls_sku, ls_supp_code, ls_wh, ls_lcode, ls_Inv_Type, ls_lot_No, ls_po_No, ls_cc_no, ls_tran_ord_status
string		ls_po_No2, ls_coo, ls_owner_cd, ls_Ro_No , ls_Sequence, ls_tono, ls_SN_Ind, ls_req_SN
string		lsFromWarehouse, lsToWarehouse, ls_uf3, ls_Delete_ToNo, ls_Delete_List, lsLogOut
string		lsReturnTxt, lsListIgnored, lsListProcessed, ls_trans_parm, ls_container_Id, ls_formatted_ToNo
string		ls_serial_find

long		ll_Owner_Id, ll_Qty, ll_QtyCount, llLineItemNo, ll_row, ll_soc_sn_qty, ll_del_sn_count
long		ll_header_row, ll_detail_row, llFromOwnerId, llToOwnerId, ll_serial_row, ll_count, ll_serial
long		llReturnCode, llCntReceived, llCntIgnored, llCntProcessed, i, ll_cc_line_No, ll_tran_Id, ll_return, ll_rc

boolean 	lbSQLCAauto, lbAutoSOC
decimal  	ldToNo

Datetime ldt_Exp_Date, ldtWHTime

Str_Parms ls_serial_parms

Datastore ldsToHeader, ldsToDetail, ldsToSerial

SetPointer(HourGlass!)

If Not isvalid(ldsToHeader) Then
	ldsToHeader = Create u_ds_datastore
	ldsToHeader.dataobject= 'd_transfer_master'
	ldsToHeader.SetTransObject(SQLCA)
End If

If Not isvalid(ldsToDetail) Then
	ldsToDetail = Create u_ds_datastore
	ldsToDetail.dataobject= 'd_transfer_detail'
	ldsToDetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsToSerial) Then
	ldsToSerial = Create u_ds_datastore
	ldsToSerial.dataobject= 'd_alternate_serial_capture'
	ldsToSerial.SetTransObject(SQLCA)
End If

ls_sku = as_soc_parms.string_arg[1]
ls_supp_code= as_soc_parms.string_arg[2]
ls_wh = as_soc_parms.string_arg[3]
ls_lcode = as_soc_parms.string_arg[4]
ls_Inv_Type= as_soc_parms.string_arg[5]
ls_lot_No= as_soc_parms.string_arg[6]
ls_po_No =as_soc_parms.string_arg[7]
ls_po_No2 = as_soc_parms.string_arg[8]
ls_coo = as_soc_parms.string_arg[9]
ls_owner_cd =as_soc_parms.string_arg[10]
ls_Ro_No = as_soc_parms.string_arg[11]
ls_Sequence = as_soc_parms.string_arg[12]
ls_cc_no = as_soc_parms.string_arg[13] //CC No
ls_container_Id = as_soc_parms.string_arg[14] //Container Id


ll_Owner_Id = as_soc_parms.long_arg[1]
ll_cc_line_No = as_soc_parms.long_arg[2] //CC Line Item No
ll_Qty = as_soc_parms.long_arg[3] //Old Qty
ll_QtyCount = as_soc_parms.long_arg[4] //New Qty

ldt_Exp_Date = as_soc_parms.datetime_arg[1]
lbAutoSOC = as_soc_parms.boolean_arg[1]

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//building Transfer Header Records
sqlca.sp_next_avail_seq_no(as_project,"Transfer_Master","To_No" ,ldToNo) //get the next available To_No
If ldToNo <= 0 Then Return -1
ls_ToNo = as_project + String(Long(ldToNo),"000000")

ll_header_row = ldsToHeader.insertrow( 0)
ldsToHeader.SetItem(ll_header_row,'to_no', ls_ToNo)
ldsToHeader.SetItem(ll_header_row,'project_id', as_project)
ldsToHeader.SetItem(ll_header_row,'last_user', 'SIMSFP')
ldsToHeader.SetItem(ll_header_row, 'Ord_type', 'O')  /* Internal Order Type )  */
ldsToHeader.SetItem(ll_header_row, 'Ord_Status', 'N')
ldsToHeader.SetItem(ll_header_row, 'User_Field2', ls_owner_cd)

is_ToNo_List[UpperBound(is_ToNo_List) +1] =ls_ToNo

//From Owner Code
select owner_id into :llFromOwnerId  from Owner with(nolock)
where project_id = :as_project and owner_cd = :ls_owner_cd using sqlca;

//From Warehouse
select user_field2 into :lsFromWarehouse from Customer with(nolock)
where project_id = :as_project and cust_code = :ls_owner_cd using sqlca;

ldsToHeader.SetItem(ll_header_row, 's_warehouse', lsFromWarehouse)

ldtWHTime = f_getLocalWorldTime(lsFromWarehouse)
ldsToHeader.SetItem(ll_header_row, 'ord_date', ldtWHTime)
ldsToHeader.SetItem(ll_header_row,'last_update', ldtWHTime)

//To Owner Code
select owner_id into :llToOwnerId from Owner with(nolock)
where project_id = :as_project and owner_cd = :ls_owner_cd using sqlca;

//To Warehouse
select user_field2 into :lsToWarehouse 	from customer with(nolock)
where project_id = :as_project and cust_code = :ls_owner_cd using sqlca;

ldsTOHeader.SetItem(ll_header_row, 'd_warehouse', lsToWarehouse)

If lsFromWarehouse <> lsToWarehouse Then
	gu_nvo_process_files.uf_writeError("Row: " + string(ll_header_row) + " 'From Owner' and 'To Owner' are in different Warehouses. This is not allowed on an Owner Change. Record will not be processed.")
	Return -1
End If

select Distinct(User_Field3) into :ls_uf3 from Transfer_Master with(nolock)
where Project_id = :as_project and User_Field3 = :ls_sequence and Ord_status <> 'V' using sqlca;

// If record already exists, check to see if it is new.  If so get TO_No so those new records can be deleted.
If ls_uf3 =  ls_sequence then 
	select TO_No into :ls_Delete_ToNo	from Transfer_Master with(nolock)
	where Project_Id = :as_project and User_Field3 = :ls_uf3 and Ord_Status = 'N' using sqlca;
					
	//if ls_Delete_ToNo is populated, need to create/AddTo delete list, otherwise bail
	If len(ls_Delete_ToNo) > 0 then
		ls_Delete_List = ls_Delete_List + ',' +  ls_Delete_ToNo
	else
		gu_nvo_process_files.uf_writeError("Row: " + string(ll_header_row) + " MTR Nbr " + string(ls_sequence) + " - Owner Change Already Exists and is NOT 'New'") 
		Return -1
	End If
End If

ldsTOHeader.SetItem(ll_header_row, 'User_Field3', ls_sequence)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Master Record: '+ls_ToNo
FileWrite(giLogFileNo,lsLogOut)
		
//building Transfer Detail Records

llLineItemNo++
ll_detail_row =ldsToDetail.insertrow( 0)
ldsToDetail.SetItem(ll_detail_row,'To_No', ls_ToNo)
ldsToDetail.SetItem(ll_detail_row, 'Owner_id', llFromOwnerId)
ldsToDetail.SetItem(ll_detail_row, 'New_Owner_id', llToOwnerId)
ldsToDetail.SetItem(ll_detail_row,'Inventory_Type', 'N') 
ldsToDetail.SetItem(ll_detail_row, 'New_Inventory_Type', 'N')
ldsToDetail.SetItem(ll_detail_row,'Supp_Code', 'PANDORA') 
ldsToDetail.SetItem(ll_detail_row,'Country_of_origin', ls_coo) 
ldsToDetail.SetItem(ll_detail_row,'Serial_No', '-')
ldsToDetail.SetItem(ll_detail_row,'Lot_No',  ls_lot_No) 
ldsToDetail.SetItem(ll_detail_row,'Po_No2', ls_po_No2)
ldsToDetail.SetItem(ll_detail_row,'Container_Id', ls_container_Id) 
ldsToDetail.SetItem(ll_detail_row,'Expiration_Date', ldt_Exp_Date) 
ldsToDetail.SetItem(ll_detail_row, 's_location', ls_lcode)	
ldsToDetail.SetItem(ll_detail_row, 'd_location', ls_lcode)
			
ldsToDetail.SetItem(ll_detail_row, 'sku', ls_sku)
ldsToDetail.SetItem(ll_detail_row, 'Po_No', ls_po_no)
ldsToDetail.SetItem(ll_detail_row, 'New_PO_NO', 'RESEARCH')
ldsToDetail.SetItem(ll_detail_row, 'Line_Item_No', ll_cc_line_No) //CC Line Item No
ldsToDetail.SetItem(ll_detail_row, 'User_Line_Item_No', llLineItemNo)
ldsToDetail.SetItem(ll_detail_row, 'Quantity', (ll_Qty - ll_QtyCount))
			
select serialized_Ind into :ls_SN_Ind from Item_Master with(nolock) 
where Project_Id= :as_project and sku=:ls_sku and supp_code='PANDORA' using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - SKU: '+ls_sku+' - Serialized_Ind: ' + ls_SN_Ind
FileWrite(giLogFileNo,lsLogOut)

If upper(ls_SN_Ind) <> 'N' Then
	ls_serial_parms = this.uf_process_cc_auto_serialno_soc( as_project, ls_cc_no, ls_sku, ls_lcode, llFromOwnerId ,ls_po_no, ls_po_No2, ls_container_Id, (ll_Qty - ll_QtyCount), lbAutoSOC)

	//retrive assigned serial no's from SOC Orders
	If UpperBound(is_ToNo_List) > 0 Then ls_formatted_ToNo = in_string_util.of_format_string( is_ToNo_List, n_string_util.FORMAT1 )
	idsAltSerialRecords = this.uf_process_cc_get_assigned_serialno( ls_formatted_ToNo, ls_sku)
	
	For ll_row =1 to UpperBound(ls_serial_parms.string_arg)
		ls_req_SN = ls_serial_parms.string_arg[ll_row]

		//find serial no on Alternate Serial Capture data store
		ls_serial_find ="SKU_Parent ='"+ls_sku+"' and Serial_No_Parent ='"+ls_req_SN+"'"
		ll_count = idsAltSerialRecords.find( ls_serial_find, 1, idsAltSerialRecords.rowcount( ))
		
		If ll_count =0  and ll_serial < (ll_Qty - ll_QtyCount) Then
			//building Alternate Serial Capture Records
			ll_serial++
			ll_serial_row = ldsToSerial.insertrow( 0)
			ldsToSerial.setItem( ll_serial_row, 'SKU_Parent', trim(ls_sku))
			ldsToSerial.setItem( ll_serial_row, 'Supp_Code_Parent', trim(ls_supp_code))
			ldsToSerial.setItem( ll_serial_row, 'Alt_Sku_Parent', trim(ls_sku))
			ldsToSerial.setItem( ll_serial_row, 'Serial_No_Parent', trim(ls_req_SN))
			ldsToSerial.setItem( ll_serial_row, 'SKU_Child', trim(ls_sku))
			ldsToSerial.setItem( ll_serial_row, 'Supp_Code_Child', trim(ls_supp_code))
			ldsToSerial.setItem( ll_serial_row, 'Alt_Sku_Child', trim(ls_sku))
			ldsToSerial.setItem( ll_serial_row, 'Last_Update', today())
			ldsToSerial.setItem( ll_serial_row, 'Last_User', 'SIMSFP')
			ldsToSerial.setItem( ll_serial_row, 'Serial_No_Child', trim(ls_req_SN))
			ldsToSerial.setItem( ll_serial_row, 'To_No', trim(ls_ToNo))
			ldsToSerial.setItem( ll_serial_row, 'To_Line_Item_No', ll_cc_line_No)
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Serial Detail Record: '+ls_sku + ' / '+ ls_ToNo +' / ' +ls_req_SN+' / '+string(ll_cc_line_No)
			FileWrite(giLogFileNo,lsLogOut)
		End If
	Next
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - Is High Value Item: ' +string(lbAutoSOC) + ' -SQLCA.Return Code: '+string(sqlca.sqlcode)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Insert into DB
If ldsToHeader.rowcount( ) > 0 Then ll_rc = ldsToHeader.update()
If ll_rc > 0 and ldsToDetail.rowcount( ) > 0 Then ll_rc = ldsToDetail.update( )
If ll_rc > 0 and ldsToSerial.rowcount( ) > 0 Then ll_rc = ldsToSerial.update()

If ll_rc =1 Then
	COMMIT;
	if SQLCA.sqlcode = 0 then
		ldsToHeader.resetupdate( )
		ldsToDetail.resetupdate()
		ldsToSerial.resetupdate( )
	else
		ROLLBACK;
		ldsToHeader.resetupdate( )
		ldsToDetail.resetupdate()
		ldsToSerial.resetupdate( )
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count Order - Error Processing of uf_process_cc_auto_confirm_soc()  Error: '+ nz(SQLCA.SQLErrText,'-') + ' Error Code: '+string(SQLCA.sqlcode)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if

else
	ROLLBACK;
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count Order - Error Processing of uf_process_cc_auto_confirm_soc()  Error: '+ nz(SQLCA.SQLErrText, '-') +' Record save failed' + ' Error Code: '+string(SQLCA.sqlcode)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count Order -End Processing of uf_process_cc_auto_confirm_soc() - Insertion Successfully Completed.!'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If len(ls_Delete_List) > 0 Then
	// Stirp of leading comma
	ls_Delete_List =  right(ls_Delete_List, len(ls_Delete_List) - 1)
	DELETE FROM Transfer_Detail_Content  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
	DELETE FROM Transfer_Detail  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
	DELETE FROM Transfer_Master  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - Is High Value Item: ' +string(lbAutoSOC) + ' - execute Auto SOC'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ls_sequence = ls_sequence +"|"
lbSQLCAauto = SQLCA.AutoCommit
SQLCA.AutoCommit = true

f_method_trace_special( as_project, this.ClassName() + ' - uf_process_cc_auto_confirm', 'Start Auto SOC CC Stored Procedure' ,ls_ToNo, '','',ls_sequence)										
sqlca.Sp_Auto_SOC_CC('O', ls_sequence, ls_cc_no, ll_cc_line_No, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed) 	//Execute Stored Procedure	
SQLCA.AutoCommit = lbSQLCAauto

f_method_trace_special( as_project, this.ClassName() + ' - uf_process_cc_auto_confirm', 'End Auto SOC CC Stored Procedure ' + lsReturnTxt + 'Return code ' + String(llReturnCode),ls_ToNo, '','',ls_sequence)	

select Ord_status into :ls_tran_ord_status  from Transfer_Master with(nolock) 
where Project_Id =:as_project and To_No =:ls_ToNo
using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - After Auto SOC Result: '+nz(lsReturnTxt,'-') +'  - Transfer Ord Status: '+nz(ls_tran_ord_status, '-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  End Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsToHeader
destroy ldsToDetail
destroy ldsToSerial

Return 0
end function

public function long uf_process_cc_stock_adjustment (string as_project, str_parms as_inv_parms);//22-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Orders

string		ls_sku, ls_supp_code, ls_wh, ls_lcode, ls_Inv_Type, ls_lot_No, ls_po_No, ls_New_Po_No, ls_Sequence, ls_cc_no, ls_ToNo
string		ls_po_No2, ls_coo, ls_owner_cd, ls_Ro_No, ls_serial, ls_container_Id, lsLogOut, ls_sku_filter, ls_serial_No, ls_serial_Ind, ls_Trans_Id
string		ls_sql_syntax, ls_sql_errors
long 		ll_Owner_Id, ll_Qty, ll_QtyCount, ll_difference_Qty, ll_New_Row, ll_adj_No, ll_rc, ll_delete_count, ll_row, ll_row_count, ll_adj_qty
long		ll_Batch_Id, ll_Insert_count, ll_count, ll_line_item_no, ll_avail_Qty, ll_new_qty, ll_old_qty, ll_Trans_Id, ll_Pos, ll_adjust_count
Datetime	ldt_Exp_Date, ldtToday
Decimal ld_adj_No
boolean lbAutoSOC =FALSE

Str_Parms ls_serial_Parms, ls_Trans_Id_Parms

Datastore ldsAdjustment

If Not isvalid(ldsAdjustment) Then	
	ldsAdjustment = create Datastore
End If

SetPointer(HourGlass!)

ldtToday = DateTime(Today(),now())
ls_sku = as_Inv_parms.string_arg[1]
ls_supp_code= as_Inv_parms.string_arg[2]
ls_wh = as_Inv_parms.string_arg[3]
ls_lcode = as_Inv_parms.string_arg[4]
ls_Inv_Type= as_Inv_parms.string_arg[5]
ls_lot_No= as_Inv_parms.string_arg[6]
ls_po_No =as_Inv_parms.string_arg[7]
ls_po_No2 = as_Inv_parms.string_arg[8]
ls_coo = as_Inv_parms.string_arg[9]
ls_owner_cd =as_Inv_parms.string_arg[10]
ls_Ro_No = as_Inv_parms.string_arg[11]
ls_Sequence = as_Inv_parms.string_arg[12] //CC Sequence No
ls_cc_no = as_Inv_parms.string_arg[13] //CC No
ls_container_Id = as_Inv_parms.string_arg[14] //Container Id

ll_Owner_Id = as_Inv_parms.long_arg[1]
ll_line_item_no = as_Inv_parms.long_arg[2] //CC Line Item No
ll_Qty = as_Inv_parms.long_arg[3] //Old Qty
ll_QtyCount = as_Inv_parms.long_arg[4] //New Qty

ldt_Exp_Date = as_Inv_parms.datetime_arg[1]

select serialized_Ind into :ls_serial_Ind from Item_Master with(nolock) 
where Project_Id =:as_project and sku=:ls_sku and supp_code =:ls_supp_code
using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku +' - Serialized Ind: -' +ls_serial_Ind
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Item Serial Change History Parms
ls_serial_Parms.string_arg[1] = as_project
ls_serial_Parms.string_arg[2] = ls_wh
ls_serial_Parms.string_arg[3] = ls_sku
ls_serial_Parms.string_arg[4] = ls_supp_code
ls_serial_Parms.string_arg[5] = ls_Po_No
ls_serial_Parms.string_arg[6] = ls_cc_no
ls_serial_Parms.string_arg[7] =ls_lcode
ls_serial_Parms.string_arg[8] =ls_Sequence //CC Sequence No

ls_serial_Parms.long_arg[1] = ll_Owner_Id
ls_serial_Parms.long_arg[2] = ll_Qty
ls_serial_Parms.long_arg[3] = ll_QtyCount
ls_serial_Parms.boolean_arg[1] = as_Inv_parms.boolean_arg[1]

lbAutoSOC = as_Inv_parms.boolean_arg[1]


//Down Count
IF ll_Qty > ll_QtyCount THEN

	//delete SN and create Batch Transaction Records
	If upper (ls_serial_Ind) <> 'N' THEN
		ls_Trans_Id_Parms =this.uf_process_cc_serial_change( ls_serial_Parms)
		For ll_row =1 to UpperBound(ls_Trans_Id_Parms.long_arg)
			ll_Trans_Id =	ls_Trans_Id_Parms.long_arg[ll_row]
			ls_Trans_Id += string(ll_Trans_Id) +','
		Next
		
		ll_Pos =LastPos(ls_Trans_Id, ",")
		If ll_Pos > 0 Then ls_Trans_Id =Left(ls_Trans_Id, len(ls_Trans_Id) - 1)
		
	END IF
	
	IF lbAutoSOC =FALSE Then //Non-High Value Items.
		ll_difference_Qty = ll_Qty - ll_QtyCount
		
		//get Transfer Master
		select To_No, count(*) into :ls_ToNo, :ll_count from Transfer_Master with(nolock) 
		where Project_Id =:as_project and User_Field3 =:ls_Sequence and s_warehouse= :ls_wh and Ord_Status ='C'
		group by To_No
		using sqlca;
		
		If ll_count > 0 Then
			//get Transfer Detail
			select New_Po_no into :ls_New_Po_No from Transfer_Detail with(nolock)
			where To_No= :ls_ToNo and sku =:ls_sku and S_Location =:ls_lcode and Owner_Id =:ll_Owner_Id
			using sqlca;
			
			//get Stock Adjustment Record
			//10-JULY-2018 :Madhu DE5117 - Update Stock Adjustments properly
			ls_sql_syntax = " select Ro_No, Old_Quantity, Quantity "
			ls_sql_syntax += " from Adjustment with(nolock) "
			ls_sql_syntax += " where Project_Id ='"+as_project+"' and wh_code= '"+ls_wh+"'"
			ls_sql_syntax +=" 	and sku= '"+ls_sku+"' and Po_No ='"+ls_New_Po_No+"'"
			ls_sql_syntax +=" 	and Ref_No ='"+ls_ToNo+"' and Owner_Id ='"+string(ll_Owner_Id)+"'"
			
			ldsAdjustment.create( SQLCA.syntaxfromsql( ls_sql_syntax, "", ls_sql_errors))
			ldsAdjustment.settransobject( SQLCA)
			ll_adjust_count = ldsAdjustment.retrieve( )
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Retrieved Auto SOC Adjustment Records count: '+string(ll_adjust_count)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			//loop through each Adjustment Record
			FOR ll_row =1 to ll_adjust_count

				ls_Ro_No = ldsAdjustment.getItemString( ll_row, 'Ro_No')
				ll_old_qty = ldsAdjustment.getItemNumber( ll_row, 'Old_Quantity')
				ll_new_qty = ldsAdjustment.getItemNumber( ll_row, 'Quantity')
				
				//get content record
				select Avail_Qty, count(*) into  :ll_avail_Qty, :ll_count from Content with(nolock)
				where Project_Id =:as_project and sku=:ls_sku and supp_code =:ls_supp_code 
				and Owner_Id= :ll_Owner_Id and Country_Of_Origin =:ls_coo and wh_code =:ls_wh
				and l_code =:ls_lcode and Inventory_Type =:ls_Inv_Type  and Po_No =:ls_New_Po_No  and Container_Id=:ls_container_Id
				and Ro_No =:ls_Ro_No and Lot_No =:ls_Lot_No and Po_No2 =:ls_po_No2 and Expiration_date =:ldt_Exp_Date
				group by Avail_Qty
				using sqlca;
			
				If ll_count > 0 Then
					
					//17-JULY-2018 :Madhu DE5099 - Shouldn't delete QTY from existing Project code as 'RESEARCH'
					If (ll_old_qty > 0) and  (ll_new_qty > ll_old_qty) then
						ll_adj_qty = ll_new_qty -ll_old_qty
					else
						ll_adj_qty = ll_new_qty
					End If
										
					//update Existing Content Record - Clear Qty from New Project Code
					update Content Set Avail_Qty = Avail_Qty - :ll_adj_qty, Last_User='SIMSFP', Reason_Cd ='CC'
					where  Project_Id =:as_project and sku=:ls_sku and supp_code =:ls_supp_code 
					and Owner_Id= :ll_Owner_Id and Country_Of_Origin =:ls_coo and wh_code =:ls_wh
					and l_code =:ls_lcode and Inventory_Type =:ls_Inv_Type  and Po_No =:ls_New_Po_No and Container_Id=:ls_container_Id
					and Ro_No =:ls_Ro_No and Lot_No =:ls_Lot_No and Po_No2 =:ls_po_No2 and Expiration_date =:ldt_Exp_Date
					using sqlca;
					commit;
									
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Down Count - Updated Content with Qty:  ' + nz(string(ll_adj_qty),'-') + '  - Difference Qty: '+string(ll_difference_Qty)
					lsLogOut += ' against SKU: '+ls_sku+ ' - Loc: '+ nz(ls_lcode,'-') +' - Po No: '+ nz(ls_New_Po_No,'-')+ ' - Ro No: '+nz(ls_Ro_No,'-') + ' - Owner Id: '+string(ll_Owner_Id) +' - Container Id: '+nz(string(ls_container_Id), '-')
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
			
				else
					//Insert record into Content Table
					Insert into Content (Project_Id, sku, supp_code, Owner_Id,  Country_Of_Origin, wh_code,  l_code, Avail_Qty, Inventory_Type, Lot_No, Po_No, Po_No2 ,Ro_No , Expiration_date, Last_User, Last_Update, Reason_Cd, Container_Id)
					values (:as_project, :ls_sku,  :ls_supp_code, :ll_Owner_Id, :ls_coo, :ls_wh, :ls_lcode, :ll_difference_Qty,  :ls_Inv_Type, :ls_Lot_No, :ls_New_Po_No, :ls_po_No2,  :ls_Ro_No, :ldt_Exp_Date, 'SIMSFP', :ldtToday, 'CC', :ls_container_Id)
					using sqlca;
					commit;
					
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Down Count - Inserted Content with Qty:  ' + nz(string(ll_difference_Qty),'-')
					lsLogOut += ' against SKU: '+ls_sku+ ' - Loc: '+ nz(ls_lcode,'-') +' - Po No: '+ nz(ls_New_Po_No,'-')+ ' - Ro No: '+nz(ls_Ro_No,'-') + ' - Owner Id: '+string(ll_Owner_Id) +' - Container Id: '+string(ls_container_Id, '-')
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
			
				END IF
						
				//Create Stock Adjustment
				//08-Oct-2018 :Madhu DE6675 - Add container Id
				//03-Jan-2019 :Madhu DE7881 - Always set Quantity =0 for Down Count
				Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
							wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
							container_ID, expiration_date, ro_no,Ref_No,old_quantity,quantity,reason,last_user,last_update, Adjustment_Type,
							old_lot_no) 
				values	(:as_project,:ls_sku,:ls_supp_code,:ll_Owner_Id,:ll_Owner_Id, :ls_coo,:ls_coo,:ls_wh,:ls_lcode,'N',:ls_Inv_Type, &
							'-',:ls_lot_No,:ls_New_Po_No,:ls_New_Po_No,:ls_po_No2, :ls_po_No2,:ls_container_Id, :ldt_Exp_Date,:ls_Ro_No,:ls_cc_no,:ll_new_Qty, 0,'Down Count','SIMSFP',:ldtToday,'Q',
							:ls_lot_No)
				Using SQLCA;
				commit;
						
				If Sqlca.sqlcode <> 0  Then
					lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Down Count - Unable to create new stock adjustment:  ' +sqlca.sqlerrtext
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
					Return -1	
				End IF
			
				// Since it is auto generated by the DB, we need to retrieve it
				Select Max(Adjust_no) into :ll_adj_no 	From	 Adjustment with(nolock)
				Where project_id = :as_project and ro_no = :ls_Ro_No and sku = :ls_sku and wh_code =:ls_wh and l_code= :ls_lcode
				and supp_code = :ls_supp_code and po_no =:ls_New_Po_No and last_user = 'SIMSFP' and last_update = :ldtToday
				using sqlca;
			
				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' - Down Count- created Adjustment Record: '+ string(ll_adj_No)
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
			
				//Create Batch Transaction Record
				ll_Batch_Id = this.uf_process_create_batch_transaction( as_project, 'MM', ll_adj_No, ls_Trans_Id)
			Next
		End IF
	END IF
END IF


//Up Count
IF ll_Qty < ll_QtyCount THEN
	//Increment Qty of Content Record
	ll_difference_Qty = ll_QtyCount - ll_Qty
	
	select Avail_Qty, Ro_No, count(*) into  :ll_avail_Qty, :ls_Ro_No, :ll_count from Content with(nolock)
	where Project_Id =:as_project and sku=:ls_sku and supp_code =:ls_supp_code 
	and Owner_Id= :ll_Owner_Id and Country_Of_Origin =:ls_coo and wh_code =:ls_wh
	and l_code =:ls_lcode and Inventory_Type =:ls_Inv_Type  and Po_No =:ls_po_No and Container_Id= :ls_container_Id
	and Lot_No =:ls_Lot_No and Po_No2 =:ls_po_No2 and Expiration_date =:ldt_Exp_Date
	group by Avail_Qty, Ro_No
	using sqlca;

	If ll_count > 0 Then
		//update Existing Content Record
		update Content Set Avail_Qty = Avail_Qty + :ll_difference_Qty, Last_User='SIMSFP', Reason_Cd='CC'
		where  Project_Id =:as_project and sku=:ls_sku and supp_code =:ls_supp_code 
		and Owner_Id= :ll_Owner_Id and Country_Of_Origin =:ls_coo and wh_code =:ls_wh
		and l_code =:ls_lcode and Inventory_Type =:ls_Inv_Type  and Po_No =:ls_po_No and Container_Id =:ls_container_Id
		and Ro_No =:ls_Ro_No and Lot_No =:ls_Lot_No and Po_No2 =:ls_po_No2 and Expiration_date =:ldt_Exp_Date
		using sqlca;

		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Up Count - Updated Content with Qty:  ' + nz(string(ll_difference_Qty),'-')
		lsLogOut += ' against SKU: '+ls_sku+ ' - Loc: '+ nz(ls_lcode,'-') +' - Po No: '+ nz(ls_po_No,'-')+ ' - Ro No: '+nz(ls_Ro_No,'-') + ' - Owner Id: '+string(ll_Owner_Id) +' - Container Id: '+nz(string(ls_container_Id), '-')
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

	else
		//Insert record into Content Table
		Insert into Content (Project_Id, sku, supp_code, Owner_Id,  Country_Of_Origin, wh_code,  l_code, Avail_Qty, Inventory_Type, Lot_No, Po_No, Po_No2 ,Ro_No , Expiration_date, Last_User, Last_Update, Reason_Cd, Container_Id)
		values (:as_project, :ls_sku,  :ls_supp_code, :ll_Owner_Id, :ls_coo, :ls_wh, :ls_lcode, :ll_difference_Qty,  :ls_Inv_Type, :ls_Lot_No, :ls_po_No, :ls_po_No2,  :ls_Ro_No, :ldt_Exp_Date, 'SIMSFP', :ldtToday, 'CC', :ls_container_Id)
		using sqlca;
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Up Count - Inserted Content with Qty:  ' + nz(string(ll_difference_Qty),'-')
		lsLogOut += ' against SKU: '+ls_sku+ ' - Loc: '+ nz(ls_lcode,'-') +' - Po No: '+ nz(ls_po_No,'-')+ ' - Ro No: '+nz(ls_Ro_No,'-') + ' - Owner Id: '+string(ll_Owner_Id) +' - Container Id: '+nz(string(ls_container_Id), '-')
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

	END IF
	
	ll_new_qty = ll_avail_Qty +ll_difference_Qty
	
	//Create Stock Adjustment
	//08-Oct-2018 :Madhu DE6675 - Add container Id
	Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
				wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
				container_ID, expiration_date, ro_no, Ref_No,old_quantity,quantity,reason,last_user,last_update, Adjustment_Type,
				old_lot_no) 
	values	(:as_project,:ls_sku,:ls_supp_code,:ll_Owner_Id,:ll_Owner_Id, :ls_coo,:ls_coo,:ls_wh,:ls_lcode,'N',:ls_Inv_Type, &
				'-',:ls_lot_No,:ls_po_No,:ls_po_No,:ls_po_No2, :ls_po_No2,:ls_container_Id, :ldt_Exp_Date,:ls_Ro_No, :ls_cc_no,:ll_avail_Qty,:ll_new_qty,'UP Count','SIMSFP',:ldtToday,'Q',
				:ls_lot_No)
	Using SQLCA;
			
	If Sqlca.sqlcode <> 0  Then
		lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' Up Count - Unable to create new stock adjustment:  ' +sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1	
	End IF

	// Since it is auto generated by the DB, we need to retrieve it
	Select Max(Adjust_no) into :ll_adj_no 	From	 Adjustment with(nolock)
	Where project_id = :as_project and ro_no = :ls_Ro_No and sku = :ls_sku and wh_code =:ls_wh and l_code= :ls_lcode
	and supp_code = :ls_supp_code and po_no =:ls_po_No and last_user = 'SIMSFP' and last_update = :ldtToday
	using sqlca;

	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no + ' - UP Count- created Adjustment Record: '+ string(ll_adj_No)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//Insert Item Serial Change history Records
	If upper (ls_serial_Ind) <> 'N' THEN
		ls_Trans_Id_Parms = this.uf_process_cc_serial_change( ls_serial_Parms)
		For ll_row =1 to UpperBound(ls_Trans_Id_Parms.long_arg)
			ll_Trans_Id =	ls_Trans_Id_Parms.long_arg[ll_row]
			ls_Trans_Id += string(ll_Trans_Id) +','
		Next
		
		ll_Pos =LastPos(ls_Trans_Id, ",")
		If ll_Pos > 0 Then ls_Trans_Id =Left(ls_Trans_Id, len(ls_Trans_Id) - 1) //trim comma at the end
	End If
			
	//Create Batch Transaction Record
	ll_Batch_Id = this.uf_process_create_batch_transaction( as_project, 'MM', ll_adj_No, ls_Trans_Id)
	
END IF


//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_stock_adjustment  and CC_No: '+ls_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsAdjustment

Return 0
end function

public function long uf_confirm_system_generated_cc (string as_project, string as_ccno);//18-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Orders

//a. Reconcile Serial numbers between the Serial Inventory table and the serial numbers scanned on the Cycle Count
//b. Build an auto confirming SOC for any down counts. We will include any serial numbers identified as missing from the reconciliation step.
//c. Trigger the SOC confirmation logic to update OM and Pandora
//d. Create Stock adjustments where appropriate. This will include updating Content, creating the adjustment record and creating a batch transaction record 
//which will apply the logic to update OM and Pandora with the results.

string		lsLogOut, ls_count_type
long		ll_count, ll_sku_count, ll_return
boolean 	lb_variance =FALSE
datetime ldtToday

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_confirm_system_generated_cc  and CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ldtToday = DateTime(today() ,now())

//Reconcile SN Datastore
If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If


IF IsNull(as_ccno) or as_ccno='' or as_ccno=' ' or len(as_ccno) =0 THEN
	lsLogOut = "        3PL Cycle Count- Processing of uf_confirm_system_generated_cc   -Unable to retreive CC Order: " + nz(as_ccno, '-')
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End IF


//Look for records - Only Serialized Items would exists (Discrepancy)
select count(*) into :ll_count from CC_Serial_Numbers with(nolock) where cc_no =:as_ccno 
using sqlca;

//check for Serialized Items
select count(*) into :ll_sku_count from CC_Inventory A with(nolock)
INNER JOIN Item_Master B with(nolock) ON A.sku=B.sku and B.Serialized_Ind <>'N' and B.Project_Id= :as_project
where A.CC_No=:as_ccno
using sqlca;

//(A). Serial No Reconciliation Process
select Count_Type into :ls_count_type from CC_system_criteria with(nolock) where cc_no= :as_ccno using sqlca;

//Reconcile Serial Number Inventory Table against Content Locations. Some times, locations may not be accurate against System generated Locations.
If ll_sku_count > 0 Then this.uf_process_cc_reconcile_serial_inv_table( as_project, as_ccno)
If ll_count > 0 Then this.uf_process_cc_reconcile_swap_serial_loc( as_project, as_ccno) //swap Locations, if scanned SN present on different location.
If ll_count > 0  Then idsCCRecon = this.uf_process_cc_reconciliation( as_project, as_ccno) //compare scanned SN Count v/s SNI count
If idsCCRecon.rowcount( ) > 0 Then idsCCRecon = this.uf_process_cc_reconciliation_count_by( as_project, as_ccno) //count By Loc / Sku

//(B). Build an auto confirming SOC for any down counts and trigger OM SOC logic
//06-JUNE-2018 :Madhu S19881 - Treat all count types ='L' other than Order Type ='X'

If ls_count_type ='S' Then 
	ll_return =	this.uf_process_cc_serial_check_variance( as_project, as_ccno) //Serialized
else
	ll_return = this.uf_process_cc_auto_create_soc(as_project, as_ccno) //Non-Serialized
End IF

If ll_return < 0 Then Return -1

this.uf_process_cc_remove_recon_filter() //Remove filter

//(C) Update Serial No Inventory Records (Insert, Delete, Update) and attributes too
IF idsCCRecon.rowcount( ) > 0 THEN this.uf_process_cc_update_serial_records(as_project) //Execute Insert / Delete /Update Serial No Records
this.uf_process_cc_update_serial_attributes( as_project, as_ccno)  //Update Serial Number Inventory Table attributes

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_confirm_system_generated_cc  and CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy idsCCRecon
destroy idsAltSerialRecords

Return ll_return
end function

public function integer uf_process_cc_no_count (string as_project, string as_ccno, string as_wh);//01-DEC-2017 :Madhu PEVS-806 3PL Cycle Count Order
//If NO COUNT, match Location /Serial No.

string		sql_syntax, lsLogOut, lsErrors, ls_lcode, ls_find, ls_formatted_sku, ls_sku, ls_sku_list[], ls_new_sql_syntax, ls_ord_status
string		ls_cc_sku, ls_cc_lcode, ls_cc_serialno, ls_serial_list[], ls_formatted_serials, ls_sku_prev, ls_supp_code, ls_owner_cd, ls_Orig_sql
string		ls_lotno, ls_pono, ls_pono2, ls_rono, ls_InvType, ls_old_serial_No, ls_serialno, ls_prev_lcode, ls_loc_list[], ls_formatted_locs
long		ll_count, ll_row, ll_scan_count, ll_ownerId, ll_sni_count, ll_find_row, ll_remain_count
datetime	ldt_expdate, ldtToday

datastore     ldsCCScanSN, ldsSNI

SetPointer(Hourglass!)

ldtToday = DateTime(today(), now())

If not IsValid(ldsSNI) Then
	ldsSNI =create Datastore
	ldsSNI.dataobject='d_serial_number_inventory'
	ldsSNI.settransobject( SQLCA)
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_no_count - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//get a list of SKU's against CC No from CC_Serial_Numbers Table
ldsCCScanSN = create Datastore
sql_syntax =" select * from CC_Serial_Numbers  with(nolock) where cc_no ='"+as_ccno+"'"
ldsCCScanSN.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))
ldsCCScanSN.settransobject( SQLCA)

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore for PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ll_scan_count= ldsCCScanSN.retrieve( )

//get list of Scanned Serial No's
For ll_row =1 to ll_scan_count
	ls_serialno = ldsCCScanSN.getItemString( ll_row, 'serial_no')
	ls_serial_list[ UpperBound(ls_serial_list) + 1 ] = ls_serialno
Next

//format Serial No's
If UpperBound(ls_serial_list) > 0 Then 
	ls_formatted_serials = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 ) //formatted Serial No's.
End If

//get list of Scanned Sku's
For ll_row =1 to ll_scan_count
	ls_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
	If ls_sku_prev <> ls_sku Then 	
		ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
		ls_sku_prev =ls_sku
	End If
Next

//format Sku's
If UpperBound(ls_sku_list) > 0 Then 
	ls_formatted_sku = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 ) //formatted SKU's.
End If

//get list of Location's
For ll_row =1 to ll_scan_count
	ls_lcode = ldsCCScanSN.getItemString( ll_row, 'l_code')
	If ls_prev_lcode <> ls_lcode Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_lcode
	ls_prev_lcode = ls_lcode
Next

//format Location's
If UpperBound(ls_loc_list) > 0 Then 
	ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 )
End If

//create Serial Number Inventory Records datastore
ls_Orig_sql = ldsSNI.getsqlselect( )
sql_syntax = ls_Orig_sql
sql_syntax +=" where Project_Id ='"+as_project+"'"
sql_syntax +=" and wh_code ='"+as_wh+"'"
sql_syntax +=" and sku IN ("+ls_formatted_sku+")"
ldsSNI.setsqlselect( sql_syntax)
ldsSNI.retrieve( )

FOR ll_row =1 to ll_scan_count
	
	ls_cc_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
	ls_cc_lcode = ldsCCScanSN.getItemString( ll_row, 'l_code')
	ls_cc_serialNo = ldsCCScanSN.getItemString( ll_row, 'serial_no')
	
	//Find a record with Location and Serial No combination
	ldsSNI.reset( )
	ldsSNI.setsqlselect( sql_syntax)
	ll_sni_count = ldsSNI.retrieve( )

	ls_find =" l_code ='"+ls_cc_lcode+"' and serial_no ='"+ls_cc_serialNo+"'"
	ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())
	
	If ll_find_row = 0 Then //No Record found
		
		//Find a record with  Serial No -> Location Mismatch
		ldsSNI.reset( )
		ldsSNI.setsqlselect( sql_syntax)
		ll_sni_count = ldsSNI.retrieve( ) //re-retrieve
	
		ls_find =" serial_no ='"+ls_cc_serialNo+"'"
		ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())
	
		If ll_find_row >  0 THEN
			ls_lcode =ldsSNI.getItemstring(ll_find_row ,'l_code')
			ll_ownerId =ldsSNI.getItemNumber(ll_find_row ,'Owner_Id')
			ls_lotno =ldsSNI.getItemstring(ll_find_row ,'lot_no')
			ls_pono =ldsSNI.getItemstring(ll_find_row ,'po_no')
			ls_pono2 =ldsSNI.getItemstring(ll_find_row ,'po_no2')
			ldt_expdate =ldsSNI.getItemDateTime(ll_find_row ,'Exp_DT')
			ls_rono =ldsSNI.getItemstring(ll_find_row ,'ro_no')
			ls_InvType= ldsSNI.getItemstring(ll_find_row ,'Inventory_Type')

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_no_count - updating Location From: '+ls_lcode+' To: '+ls_cc_lcode+' -sku/serial No: '+ ls_cc_sku +' / '+ ls_cc_serialNo+ ' -CC_No: '+as_ccno
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

// TAM 2019/05 - S33409 - Populate Serial History Table
			//update Location on Serial Number Inventory Table.
			update Serial_Number_Inventory set l_code =:ls_cc_lcode, Update_User='SIMSFP', 
				Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'LOCATION'
			where Project_Id= :as_project	and wh_code=:as_wh and sku = :ls_cc_sku  and serial_no=:ls_cc_serialNo 
			and l_code =:ls_lcode and Owner_Id =:ll_ownerId
			using sqlca;
			commit;
	
		else
			//Find a record with Location -> Serial No Mismatch
			ldsSNI.reset( )
			ls_new_sql_syntax = sql_syntax
			ls_new_sql_syntax += " and serial_no NOT IN ("+ls_formatted_serials+")"
			ldsSNI.setsqlselect( ls_new_sql_syntax)
			ll_sni_count =ldsSNI.retrieve( ) //re-retrieve
			
			ls_new_sql_syntax ='' //re-set to blank
			
			ls_find =" l_code ='"+ls_cc_lcode+"'"
			ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())

			If ll_find_row > 0 Then
				ls_old_serial_No =ldsSNI.getItemstring(ll_find_row ,'serial_no')
				ls_lcode =ldsSNI.getItemstring(ll_find_row ,'l_code')
				ll_ownerId =ldsSNI.getItemNumber(ll_find_row ,'Owner_Id')
				ls_lotno =ldsSNI.getItemstring(ll_find_row ,'lot_no')
				ls_pono =ldsSNI.getItemstring(ll_find_row ,'po_no')
				ls_pono2 =ldsSNI.getItemstring(ll_find_row ,'po_no2')
				ldt_expdate =ldsSNI.getItemDateTime(ll_find_row ,'Exp_DT')
				ls_rono =ldsSNI.getItemstring(ll_find_row ,'ro_no')
				ls_InvType= ldsSNI.getItemstring(ll_find_row ,'Inventory_Type')
	
				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_no_count - updating Serial No From: '+ls_old_serial_No+' To: '+ls_cc_serialNo+' -sku/Loc: '+ ls_cc_sku +' / '+ ls_lcode+ ' -CC_No: '+as_ccno
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				
// TAM 2019/05 - S33409 - Populate Serial History Table
				//update serial no
				update Serial_Number_Inventory set serial_no =:ls_cc_serialNo, Update_User='SIMSFP',
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'SERIAL NUMBER CHANGE'
				where Project_Id= :as_project	and wh_code=:as_wh and sku = :ls_cc_sku  and serial_no=:ls_old_serial_No 
				and l_code =:ls_lcode and Owner_Id =:ll_ownerId
				using sqlca;
				commit;
		
				//If a Serial change, Insert record into Item_Serial_change_history table
				Insert into Item_Serial_Change_History (Project_Id,WH_Code,Owner_Id,PO_No,Sku,Supp_Code,From_Serial_No,To_Serial_No,Transaction_Sent, Update_User, Complete_Date)
				values (:as_project, :as_wh, :ll_ownerId, :ls_pono, :ls_cc_sku, 'PANDORA', :ls_old_serial_No, :ls_cc_serialNo, 'Y', 'SIMSFP', :ldtToday)
				using sqlca;
				commit;
				
			else
				//Location and Serial No Mismatch
				If ldsSNI.rowcount( ) > 0 Then

					ls_old_serial_No =ldsSNI.getItemstring(1 ,'serial_no')
					ls_lcode =ldsSNI.getItemstring(1 ,'l_code')
					ll_ownerId =ldsSNI.getItemNumber(1 ,'Owner_Id')
					ls_lotno =ldsSNI.getItemstring(1 ,'lot_no')
					ls_pono =ldsSNI.getItemstring(1 ,'po_no')
					ls_pono2 =ldsSNI.getItemstring(1 ,'po_no2')
					ldt_expdate =ldsSNI.getItemDateTime(1 ,'Exp_DT')
					ls_rono =ldsSNI.getItemstring(1 ,'ro_no')
					ls_InvType= ldsSNI.getItemstring(1 ,'Inventory_Type')
		
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_no_count - updating Serial No From: '+nz(ls_old_serial_No,'-')+' To: '+ls_cc_serialNo+' -and Loc From: '+ nz(ls_lcode,'-')+ ' To: '+ls_cc_lcode+ ' -CC_No: '+as_ccno
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
					
// TAM 2019/05 - S33409 - Populate Serial History Table
					//update serial no
					update Serial_Number_Inventory set serial_no =:ls_cc_serialNo,  l_code =:ls_cc_lcode, Update_User='SIMSFP',
						Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'SERIAL NUMBER/LOCATION CHANGEE'
					where Project_Id= :as_project	and wh_code=:as_wh and sku = :ls_cc_sku  and serial_no=:ls_old_serial_No
					and Owner_Id =:ll_ownerId and l_code=:ls_lcode
					using sqlca;
					commit;

				else
					//get OwnerCd
					select Owner_Cd into :ls_owner_cd from Owner with(nolock) 
					where Project_Id =:as_project and Owner_Id= :ll_ownerId 
					using sqlca;
					
// TAM 2019/05 - S33409 - Populate Serial History Table
					Insert into Serial_Number_Inventory (Project_Id,WH_Code,Owner_Id,Owner_Cd,SKU,Serial_No,Component_Ind,
						Component_No,Update_Date,Update_User,l_code,Lot_No,Po_No,Po_No2, Exp_DT,RO_NO,Inventory_Type,Serial_Flag, Do_No,
						Transaction_Type,	 Transaction_Id, Adjustment_Type)
					values (:as_project, :as_wh, :ll_ownerId, :ls_owner_cd, :ls_cc_sku, :ls_cc_serialNo, 'N', 0, :ldtToday, 'SIMSFP', :ls_cc_lcode,
						:ls_lotno, :ls_pono, :ls_pono2, :ldt_expdate, :ls_rono, :ls_InvType, 'N','-', 
						'CYCLE_COUNT', :as_ccno, 'SERIAL CREATE' )
					using sqlca;
					commit;
					
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_no_count - Inserted a record into Serial Number Inventory Table Serial No:  '+ls_cc_serialNo+' -and Loc: '+ ls_cc_lcode+ '  -SKU:  '+ ls_cc_sku+' -CC_No: '+as_ccno
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
					
				End IF
				
				//If a Serial change, Insert record into Item_Serial_change_history table (Reference Only!)
				Insert into Item_Serial_Change_History (Project_Id,WH_Code,Owner_Id,PO_No,Sku,Supp_Code,From_Serial_No,To_Serial_No,Transaction_Sent, Update_User, Complete_Date)
				values (:as_project, :as_wh, :ll_ownerId, :ls_pono, :ls_cc_sku, 'PANDORA', :ls_old_serial_No, :ls_cc_serialNo, 'Y', 'SIMSFP', :ldtToday)
				using sqlca;
				commit;
	
			End IF
	 End IF
  End IF
NEXT

//check any serial no exists other than scanned against Serial Number Inventory Table.
sql_syntax =""
sql_syntax = ls_Orig_sql
sql_syntax +=" where Project_Id ='"+as_project+"'"
sql_syntax +=" and wh_code ='"+as_wh+"'"
sql_syntax +=" and sku IN ("+ls_formatted_sku+")"
sql_syntax +=" and serial_no NOT IN ("+ls_formatted_serials+") and l_code NOT IN ("+ls_formatted_locs+")"
ldsSNI.setsqlselect( sql_syntax)
ll_remain_count = ldsSNI.retrieve( )

If ll_remain_count > 0 Then
	For ll_row = 1 to ll_remain_count
		ls_serialno = ldsSNI.getItemString(ll_row, 'serial_no')
		ls_lcode = ldsSNI.getItemString(ll_row, 'l_code')
		ls_sku = ldsSNI.getItemString(ll_row, 'sku')

		//Delete Serial No from Serial Number Inventory Table, if serial No doesn't associate with any Open Delivery Orders.
		select Ord_Status into :ls_ord_status from Delivery_Master  with(nolock) where Project_Id = :as_project
		and Do_No in (select Do_No from delivery_picking_Detail  with(nolock) 
		where Id_No IN (select distinct Id_No from Delivery_Serial_Detail with(nolock) 	where Serial_No=:ls_serialno and SKU_Substitute=:ls_sku))
		using sqlca;
		
		//Delete Invalid SN from Serial Number Inventory Table.					
		If upper(ls_ord_status)  <> 'N' OR upper(ls_ord_status)  <> 'P' OR upper(ls_ord_status)  <> 'I' Then
			
			//check if SN already added to idsCCRecon
			ls_find ="serial_no='"+ls_serialno+"' and l_code ='"+ls_lcode+"'"
			ll_find_row =idsCCRecon.find(ls_find, 1, idsCCRecon.rowcount())
			
			If ll_find_row = 0 Then idsCCRecon = this.uf_process_cc_reconciliation_serial( ldsSNI, ll_row, 'D', ls_lcode, ls_serialno)

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_no_count - CC_No: '+as_ccno +' - Marked SKU /Loc /SN: '+ls_sku+'/'+ls_lcode+'/'+ls_serialno+ ' with Action Cd =D and Ord_Status: '+nz(ls_ord_status,'-')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
		End If
	Next
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_no_count - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsSNI
destroy ldsCCScanSN

Return 0
end function

public function integer uf_process_gi_delay_validation (string asproject, string asdono, string ascodedesc);//07-Dec-2017 :Madhu  Add a Validation against GI v/s CI Delay.
//Write records back into OMQ Tables

string			ls_tran_status, lsLogOut
Integer		DateDiffInMinutes, TimeDiffInMinutes, ElapsedTimeInMinutes
long			ll_count
DateTime 	ldtToday,ldt_EndRetrieve, ldt_tran_comp_date

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - Outbound Confirmation- Start Processing of uf_process_gi_delay_validation() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


select TOP 1 current_timestamp into :ldt_EndRetrieve from sysobjects using sqlca; //get Server time instead local machine time

lsLogOut = "       Outbound Confirmation -Creating Inventory Transaction (GI) For DO_NO: " + asDONO+" current Server Time is: " + string(ldt_EndRetrieve)
FileWrite(gilogFileNo,lsLogOut)

select Trans_Status, Trans_Complete_Date, count(*) into :ls_tran_status, :ldt_tran_comp_date, :ll_count
from Batch_Transaction with(nolock) 
where Project_Id =:asproject and Trans_Order_Id =:asdono and Trans_Type ='CI'
group by Trans_Status, Trans_Complete_Date
using sqlca;

IF  upper(ls_tran_status) ='N' and ll_count > 0 THEN
	Return 2
else
	DateDiffInMinutes = DaysAfter ( Date(ldt_tran_comp_date), Date(ldt_EndRetrieve)  ) * 24 * 60
	TimeDiffInMinutes = SecondsAfter ( Time(ldt_tran_comp_date), Time (ldt_EndRetrieve ) ) / 60
	ElapsedTimeInMinutes = DateDiffInMinutes + TimeDiffInMinutes
	lsLogOut = "      Waiting to process Inventory Transaction (GI) For DO_NO: " + asDONO + '  ' + String(ElapsedTimeInMinutes) + ' Minutes have passed ' +  ' System DateTime is: ' + String(ldt_EndRetrieve) + '  CI Complete Date is: ' + String(ldt_tran_comp_date)
	FileWrite(gilogFileNo,lsLogOut)
	
	If ElapsedTimeInMinutes < Long ( asCodeDesc ) then //Compair the minutes with the theashold found in the lookup table.
		lsLogOut = "      Skipping Inventory Transaction (GI) For DO_NO: " + asDONO 
		FileWrite(gilogFileNo,lsLogOut)
		w_main.SetMicroHelp("Ready")
		Return 2
	end If
End IF

Return 0

end function

public function datastore uf_process_cc_reconciliation_count_by (string as_project, string as_ccno);//11-Dec-2017 :Madhu PEVS-806 3PL Cycle Count Orders
//Reconcile against Count By Loc or SKU.

string 	ls_count_type, lsLogOut, sql_syntax, lsErrors, ls_sku_loc_filter, ls_prev_sku, ls_prev_loc
string		ls_loc, ls_serial_no, ls_find, ls_sku, ls_sku_list[], ls_formatted_skus, ls_loc_list[], ls_formatted_locs
long		ll_scan_count, ll_find_row, ll_row, ll_count

Datastore ldsCCScanSN

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_reconciliation_count_by - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Reconcile SN Datastore
If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If

ldsCCScanSN = create Datastore
sql_syntax =" select * from CC_Serial_Numbers  with(nolock) where cc_no ='"+as_ccno+"'"
ldsCCScanSN.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))
ldsCCScanSN.settransobject( SQLCA)

ll_scan_count= ldsCCScanSN.retrieve( )

//get list of sku's
For ll_row =1 to ll_scan_count
	ls_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
	If ls_prev_sku <> ls_sku Then ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
	ls_prev_sku = ls_sku
Next

//format sku's
If UpperBound(ls_sku_list) > 0 Then 
	ls_formatted_skus = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 )
End If

//get list of Loc's
For ll_row =1 to ll_scan_count
	ls_loc = ldsCCScanSN.getItemString( ll_row, 'l_code')
	If ls_prev_loc <>ls_loc Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_loc
	ls_prev_loc = ls_loc
Next

//format Location's
If UpperBound(ls_loc_list) > 0 Then 
	ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 )
End If

select distinct Count_Type  into :ls_count_type 
from CC_System_Criteria with(nolock) 
where CC_No= :as_ccno
using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_reconciliation_count_by - CC No: '+as_ccno +'  Count By: '+ls_count_type
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Only reconcile scanned Locations.
If upper(ls_count_type) ='L' Then
	
	ls_sku_loc_filter ="sku IN ("+ls_formatted_skus+") and l_code NOT IN ("+ls_formatted_locs+")"
	idsCCRecon.setfilter( ls_sku_loc_filter)
	idsCCRecon.filter( )
	ll_count = idsCCRecon.rowcount( )

	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_reconciliation_count_by - CC No: '+as_ccno +'  SKu/Loc Filter: '+ls_sku_loc_filter + ' - Other than filtered count: '+string(ll_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	If ll_count > 0 Then
		For ll_row =1 to ll_count
			idsCCRecon.setitem( ll_row, 'action_cd', 'X')	//Don't Delete Remaining Records.
		Next
	End If
End If

this.uf_process_cc_remove_recon_filter() //Remove filter

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_reconciliation_count_by - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCScanSN

Return idsCCRecon
end function

public function datastore uf_process_cc_up_down_count (string as_project, string as_ccno, string as_wh, string as_sku, ref datastore adsorigsn, ref datastore adsccscansn);//18-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
//UP/DOWN COUNT - Insert/Delete Serial No records into/from Serial Number Inventory Table

string		lslogOut, ls_find, ls_owner_cd, ls_cc_serial_no, ls_cc_lcode, ls_cc_sku, ls_ord_status, ls_prev_lcode
string		ls_serial_no, ls_serial_list[], ls_formatted_serials, ls_lcode, ls_loc_list[], ls_formatted_locs, ls_sn_loc, ls_ord_type
string 	ls_sql, ls_errors, ls_cc_container, ls_container_Id, ls_prev_container_Id, ls_formatted_containers, ls_container_list[]
long		ll_cc_sku_count, ll_find_row, ll_new_row, ll_sku_row, ll_row, ll_ownerId
long		ll_owner, ll_Orig_SNI_count, ll_recon_count, ll_cc_inv_count, ll_filter_count
long		ll_order_count

datastore   ldsCCInv

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If Not isvalid(ldsCCInv) Then
	ldsCCInv = Create Datastore
	ldsCCInv.Dataobject = 'd_cc_inventory'
	ldsCCInv.SetTransObject(SQLCA)
End If

//Reconcile SN Datastore
If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If

ll_cc_inv_count = ldsCCInv.retrieve(as_ccno )
ll_cc_sku_count= adsCCScanSN.rowcount()
ll_Orig_SNI_count = adsOrigSN.rowcount()

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' Serial Number Inventory count against CC Scanned SKU: '+string(ll_Orig_SNI_count) +'  Scanned SN Count: '+string(ll_cc_sku_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select ord_type INTO :ls_ord_type  from cc_master with (nolock) where cc_no = :as_ccno using sqlca;
				

//11-Oct-2018 :Madhu DE6675 -Near future need to breakdown building list against valid container and Invalid container ['-']

//get list of Serial No's, Location and Container Id's
For ll_row =1 to ll_cc_sku_count
	ls_serial_no = adsCCScanSN.getItemString( ll_row, 'serial_no')
	ls_serial_list[ UpperBound(ls_serial_list) + 1 ] = ls_serial_no
	
	ls_lcode = adsCCScanSN.getItemString( ll_row, 'l_code')
	If ls_prev_lcode <> ls_lcode Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_lcode
	ls_prev_lcode = ls_lcode

	ls_container_Id = adsCCScanSN.getItemString( ll_row, 'container_Id')
	If (ls_prev_container_Id <> ls_container_Id and  ls_container_Id <>'-' ) Then ls_container_list[ UpperBound(ls_container_list) + 1 ] = ls_container_Id
	ls_prev_container_Id = ls_container_Id
Next

//format Serial No's
If UpperBound(ls_serial_list) > 0 Then 
	ls_formatted_serials = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 )
End If

//format Location's
If UpperBound(ls_loc_list) > 0 Then 
	ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 )
End If

//format ContainerId's
If UpperBound(ls_container_list) > 0 Then 
	ls_formatted_containers = in_string_util.of_format_string( ls_container_list, n_string_util.FORMAT1 )
else
	ls_formatted_containers =''
End If

//Insert SN records into Serial Number Inventory Table.
For ll_sku_row =1 to ll_cc_sku_count
	ls_cc_sku = adsCCScanSN.getItemString( ll_sku_row, 'sku')
	ls_cc_serial_no = adsCCScanSN.getItemString( ll_sku_row, 'serial_no')
	ls_cc_lcode =adsCCScanSN.getItemString(ll_sku_row, 'l_code')
	ls_cc_container =adsCCScanSN.getItemString(ll_sku_row, 'container_Id')

	integer li_serial_exists

	//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	if ls_ord_type = "F" then
		li_serial_exists = uf_check_serial_number_exist(as_project, as_ccno, as_wh, ls_cc_lcode, as_sku, ls_cc_serial_no)	
	end if 
	
	//Find a record with following combination SKU + Loc + SN against Serial Number Inventory records
	ls_find =" sku='"+ls_cc_sku+"' and l_code ='"+ls_cc_lcode+"' and serial_no ='"+ls_cc_serial_no+"'"
	ll_find_row = adsOrigSN.find( ls_find, 1, adsOrigSN.rowcount())
	
	//if exisiting sku/serial found, we will use that one found in uf_check_serial_number_exists
	
	if li_serial_exists  = 1 then ll_find_row = 1
	
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Find: '+ls_find+ '  against SNI and Found_Row: '+string(ll_find_row)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	If ll_find_row = 0 Then
		//get details from CC_Inventory Table.
		//08-Oct-2018 :Madhu DE6675 - Added Container Id condition
		If ls_cc_container <> '-' Then
			ls_find =" sku='"+ls_cc_sku+"' and l_code ='"+ls_cc_lcode+"' and container_Id ='"+ls_cc_container+"'"
		else
			ls_find =" sku='"+ls_cc_sku+"' and l_code ='"+ls_cc_lcode+"'"
		End If
		
		ll_find_row =ldsCCInv.find( ls_find, 1, ldsCCInv.rowcount())

		If ll_find_row > 0 Then
			ll_owner = ldsCCInv.getItemNumber( ll_find_row, 'Owner_Id')
			select Owner_Cd into :ls_owner_cd from Owner with(nolock) where Project_Id =:as_project and Owner_Id =:ll_owner using sqlca;

			//Insert SN into Serial Number Inventory Table.
			ll_new_row = idsCCRecon.insertrow( 0)
			idsCCRecon.setItem( ll_new_row, 'Action_Cd', 'I')
			idsCCRecon.setItem( ll_new_row, 'Project_Id', as_project)
			idsCCRecon.setItem( ll_new_row, 'WH_Code', as_wh)
			idsCCRecon.setItem( ll_new_row, 'Owner_Id', ldsCCInv.getItemNumber( ll_find_row, 'Owner_Id'))
			idsCCRecon.setItem( ll_new_row, 'Owner_Cd', ls_owner_cd)
			idsCCRecon.setItem( ll_new_row, 'SKU', ls_cc_sku)
			idsCCRecon.setItem( ll_new_row, 'Serial_No', ls_cc_serial_no)
			idsCCRecon.setItem( ll_new_row, 'Component_Ind', 'N')
			idsCCRecon.setItem( ll_new_row, 'Component_No', 0)
			idsCCRecon.setItem( ll_new_row, 'Update_Date', DateTime(Today(),Now()))
			idsCCRecon.setItem( ll_new_row, 'Update_User', 'SIMSFP')
			idsCCRecon.setItem( ll_new_row, 'l_code', ls_cc_lcode)
			idsCCRecon.setItem( ll_new_row, 'Lot_No', ldsCCInv.getItemString(ll_find_row, 'Lot_No'))
			idsCCRecon.setItem( ll_new_row, 'Po_No', ldsCCInv.getItemString(ll_find_row, 'Po_No'))
			idsCCRecon.setItem( ll_new_row, 'Po_No2', ldsCCInv.getItemString(ll_find_row, 'Po_No2'))
			idsCCRecon.setItem( ll_new_row, 'Carton_Id', ldsCCInv.getItemString(ll_find_row, 'Container_Id'))
			idsCCRecon.setItem( ll_new_row, 'Exp_DT', ldsCCInv.getItemDateTime( ll_find_row, 'Expiration_Date'))
			idsCCRecon.setItem( ll_new_row, 'RO_NO', ldsCCInv.getItemString(ll_find_row, 'RO_NO'))					
			idsCCRecon.setItem( ll_new_row, 'Inventory_Type', ldsCCInv.getItemString(ll_find_row, 'Inventory_Type'))



		End If
	
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Inserted SKU /Loc /SN '+ls_cc_sku+'/'+ls_cc_lcode+'/'+ls_cc_serial_no+' into Datastore with Action Cd =I'
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	End If
NEXT

//check any serial no exists other than scanned against Serial Number Inventory Table.
//21-MAR-2018 :Madhu DE3576 - Delete SN against only scanned Loc's
//No Idea -how to handle, if scanned serial no has same location for multiple rows, some are having container Id and some are not.
IF ls_formatted_containers > ' ' Then
	ls_find =" sku='"+as_sku+"' and serial_no NOT IN ("+ls_formatted_serials+") and l_code  IN ("+ls_formatted_locs+") and Carton_Id IN ("+ls_formatted_containers+")"
else
	ls_find =" sku='"+as_sku+"' and serial_no NOT IN ("+ls_formatted_serials+") and l_code  IN ("+ls_formatted_locs+")"
End IF

adsOrigSN.setfilter(ls_find)
adsOrigSN.filter()
ll_filter_count = adsOrigSN.rowcount()

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Filter: '+ls_find+' Filter Count: '+string(ll_filter_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If ll_filter_count > 0 Then
	For ll_sku_row = 1 to ll_filter_count
		ls_serial_no = adsOrigSN.getItemString(ll_sku_row, 'serial_no')
		ls_lcode = adsOrigSN.getItemString(ll_sku_row, 'l_code')

		//Delete Serial No from Serial Number Inventory Table, if serial No doesn't associate with any Open Delivery Orders.
		//19-SEP-2018 :Madhu DE6374 - Re-written SQL Query
		select count(*) into :ll_order_count from delivery_picking_Detail A with(nolock)
		INNER JOIN Delivery_Serial_Detail B with(nolock) ON A.Id_No =B.Id_No and A.SKU = B.SKU_Substitute
		INNER JOIN Delivery_Master C with(nolock) ON A.DO_No =C.DO_No
		Where C.Project_Id=:as_project and C.WH_Code=:as_wh and A.SKU =:as_sku
		and C.Ord_Status NOT IN  ('N','P','I','A')
		and B.Serial_No=:ls_serial_no and A.L_code =:ls_lcode
		using sqlca;

		//Delete Invalid SN from Serial Number Inventory Table.					
		//DEC-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
		//The Serial Reconciliation with not Delete Serial - It will set them to an 'UNKNOWN' location.
		IF ll_order_count >= 0 THEN
			
				//check if SN already added to idsCCRecon
				ls_find ="serial_no='"+ls_serial_no+"' and l_code ='"+ls_lcode+"'"
				ll_find_row =idsCCRecon.find(ls_find, 1, idsCCRecon.rowcount())
				
				select ord_type INTO :ls_ord_type  from cc_master with (nolock) where cc_no = :as_ccno using sqlca;
				
				//Write to File and Screen
				//Ok to Delete "?" the Serial Number that caused the Serial number in the first place since it is in another location. 
				if ls_ord_type = "F" AND left(ls_serial_no,1) <> '?'  then
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Move SN to UNKNOWN Find: '+ls_find+' Find Count: '+string(ll_find_row)
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
					
					If ll_find_row = 0 Then idsCCRecon = this.uf_process_cc_reconciliation_serial( adsOrigSN, ll_sku_row, 'L', ls_lcode, ls_serial_no)
	
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Marked SKU /Loc /SN: '+as_sku+'/'+ls_lcode+'/'+ls_serial_no+ ' with Action Cd =L'
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
	
				else

					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Delete SN Find: '+ls_find+' Find Count: '+string(ll_find_row)
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
					
					If ll_find_row = 0 Then idsCCRecon = this.uf_process_cc_reconciliation_serial( adsOrigSN, ll_sku_row, 'D', ls_lcode, ls_serial_no)
	
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno +' - Marked SKU /Loc /SN: '+as_sku+'/'+ls_lcode+'/'+ls_serial_no+ ' with Action Cd =D'
					FileWrite(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_log(lsLogOut)
	
				end if
		END IF
	Next
End If

//re-set filter
adsCCScanSN.Setfilter("")
adsCCScanSN.Filter()
adsCCScanSN.rowcount( )

adsOrigSN.Setfilter("")
adsOrigSN.Filter()
adsOrigSN.rowcount( )

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_up_down_count - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCInv

Return idsCCRecon
end function

public function integer uf_process_cc_update_serial_attributes (string as_project, string as_ccno);//11-Dec-2017 :Madhu PEVS-806 3PL Cycle Count Orders
//Update Attributes of Serial Number Inventory table against Content.

string		ls_sql, ls_errors, ls_lcode, ls_sku, ls_sku_prev, ls_sku_list[], ls_formatted_skus, ls_old_po_no, ls_ownercd, ls_Lot_No, ls_Po_No2, lsNull
string		ls_loc, ls_loc_list[], ls_formatted_locs, ls_serial_no, ls_wh, ls_pono, ls_find, ls_loc_prev, lsLogOut, ls_Ro_No, ls_Orig_sql
string 	ls_formatted_ToNo, ls_serial_sql, ls_alt_serial_list[], ls_alt_serial, ls_formatted_alt_serial, lsContentFilter
string		ls_cc_scan_serial, ls_cc_scan_serial_list[], ls_formatted_cc_scan_serial, ls_Container_Id, ls_old_po_no2
long		ll_count, ll_scan_count, ll_row, ll_SNI_count, ll_content_count, ll_qty, ll_filter_count, ll_filter_row, ll_filter_qty, ll_ownerId, ll_cc_count, ll_rc
DateTime ldt_Exp_Date

Datastore ldsCCScanSN, ldsContent, ldsSNI, ldsCCMaster, ldsCCDetail, ldsAltSerial

SetPointer(Hourglass!)
SetNull(lsNull)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_update_serial_attributes() - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create Datastore
	ldsCCMaster.Dataobject = 'd_cc_master'
	ldsCCMaster.SetTransObject(SQLCA)
End If

If Not isvalid(ldsCCDetail) Then
	ldsCCDetail = Create Datastore
	ldsCCDetail.Dataobject = 'd_cc_inventory'
	ldsCCDetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsSNI) Then
	ldsSNI = Create Datastore
	ldsSNI.Dataobject = 'd_serial_number_inventory'
	ldsSNI.SetTransObject(SQLCA)
End If


If ldsCCMaster.retrieve(as_ccno ) <> 1 Then
	lsLogOut = "    3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Unable to retreive CC Order : " + nz(as_ccno, '-')
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

ls_wh = ldsCCMaster.getItemstring( 1, 'wh_code')

//get distinct loc, sku from CC serial no's.
ldsCCScanSN = create Datastore
ls_sql =	 " select * from CC_Serial_numbers with(nolock) "
ls_sql += " where cc_no='"+as_ccno+"' "

ldsCCScanSN.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
ldsCCScanSN.settransobject( SQLCA)
ll_scan_count = ldsCCScanSN.retrieve( )

If ll_scan_count > 0 Then
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - CC_No: '+as_ccno + ' Scanned SN Records count: '+string(ll_scan_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//get list of SKU's
	For ll_row =1 to ll_scan_count
		ls_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
		If ls_sku_prev <> ls_sku Then	ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
		ls_sku_prev =ls_sku
	Next

	If UpperBound(ls_sku_list) > 0 Then ls_formatted_skus = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 ) 	//format SKU's
	
	//get list of Loc's
	For ll_row =1 to ll_scan_count
		ls_loc= ldsCCScanSN.getItemString( ll_row, 'l_code')
		If ls_loc_prev <> ls_loc Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_loc
		ls_loc_prev =ls_loc
	Next

	If UpperBound(ls_loc_list) > 0 Then ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 )   //format Location's
	
	For ll_row = 1 to ll_scan_count
		ls_cc_scan_serial =ldsCCScanSN.getItemString( ll_row, 'serial_no')
		ls_cc_scan_serial_list[ UpperBound(ls_cc_scan_serial_list) + 1 ] = ls_cc_scan_serial
	Next

	If UpperBound(ls_cc_scan_serial_list) > 0 Then ls_formatted_cc_scan_serial = in_string_util.of_format_string( ls_cc_scan_serial_list, n_string_util.FORMAT1 ) //format Serial No's

else
	ll_cc_count = ldsCCDetail.retrieve( as_ccno) //get CC Inventory Records
	//get list of SKU's
	For ll_row =1 to ll_cc_count
		ls_sku = ldsCCDetail.getItemString( ll_row, 'sku')
		If ls_sku_prev <> ls_sku Then	ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
		ls_sku_prev =ls_sku
	Next
	
	If UpperBound(ls_sku_list) > 0 Then ls_formatted_skus = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 ) 	//format SKU's
	
	//get list of Loc's
	For ll_row =1 to ll_cc_count
		ls_loc= ldsCCDetail.getItemString( ll_row, 'l_code')
		If ls_loc_prev <> ls_loc Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_loc
		ls_loc_prev =ls_loc
	Next
	If UpperBound(ls_loc_list) > 0 Then ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 ) 	//format Location's
	
End If

//get Transfer List
If UpperBound(is_ToNo_List) > 0 Then ls_formatted_ToNo = in_string_util.of_format_string( is_ToNo_List, n_string_util.FORMAT1 )

//get serial No's from Alternate Serial Capture table.
ldsAltSerial = create Datastore
ls_serial_sql =" select * from Alternate_Serial_Capture with(nolock) "
ls_serial_sql += " where To_No in ("+ls_formatted_ToNo+")"
ls_serial_sql += " and sku_parent in ("+ls_formatted_skus+")"

ldsAltSerial.create( SQLCA.syntaxfromsql( ls_serial_sql, "", ls_errors))
ldsAltSerial.settransobject( SQLCA)
ldsAltSerial.retrieve( )

For ll_row = 1 to ldsAltSerial.rowcount( )
	ls_alt_serial =ldsAltSerial.getItemString( ll_row, 'serial_no_parent')
	ls_alt_serial_list[ UpperBound(ls_alt_serial_list) + 1 ] = ls_alt_serial
Next

If UpperBound(ls_alt_serial_list) > 0 Then ls_formatted_alt_serial = in_string_util.of_format_string( ls_alt_serial_list, n_string_util.FORMAT1 )
	
//get Content records.
ldsContent = create Datastore
ls_sql =	 " select sku, wh_code, l_code, po_no, owner_id, Ro_No, Lot_No, Po_No2, Container_Id, Expiration_Date, sum(avail_qty) as Qty from Content with(nolock) "
ls_sql += " where project_Id='"+as_project+"' "
ls_sql += " and wh_code ='"+ls_wh+"'"
ls_sql += " and sku in ("+ls_formatted_skus+")"
ls_sql += " and l_code in ("+ls_formatted_locs+")"
ls_sql += " Group By sku, wh_code, l_code, po_no, owner_id, Ro_No, Lot_No, Po_No2, Container_Id, Expiration_Date"

ldsContent.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
ldsContent.settransobject( SQLCA)
ll_content_count = ldsContent.retrieve( )

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - CC_No: '+as_ccno + ' Content Records count: '+string(ll_content_count) +' against scanned Loc /Sku'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//get Serial Number Inventory Records
ls_Orig_sql = ldsSNI.getsqlselect( )
ls_sql = ls_Orig_sql
ls_sql += " where project_Id='"+as_project+"' "
ls_sql += " and wh_code ='"+ls_wh+"'"
ls_sql += " and sku in ("+ls_formatted_skus+")"
ls_sql += " and l_code in ("+ls_formatted_locs+")"
ls_sql +=" and  ( Serial_Flag IS NULL or Serial_Flag <> 'X' ) "

ldsSNI.setsqlselect( ls_sql)
ll_SNI_count = ldsSNI.retrieve( )

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - CC_No: '+as_ccno + ' Serial Number Inventory Records count: '+string(ll_SNI_count) +' against scanned Loc /Sku'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
If ll_SNI_count > 0 Then
	
	//A. HIGH VALUE ITEMS
	//get Project ='RESEARCH ' Content Records and update Serial No's accordingly.
	lsContentFilter ="Po_No ='RESEARCH'"
	ldsContent.setfilter(lsContentFilter)
	ldsContent.filter()
	ll_content_count = ldsContent.rowcount()
	
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project = RESEARCH  CC_No: '+as_ccno + ' - Content Records Count: '+string(ll_content_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//Loop through content to update attributes of Serial No Records.
	For ll_row = 1 to ll_content_count
		ls_sku = ldsContent.getItemString( ll_row, 'sku')
		ls_wh = ldsContent.getItemString( ll_row, 'wh_code')
		ll_ownerId = ldsContent.getItemNumber( ll_row, 'owner_id')
		ls_loc = ldsContent.getItemString( ll_row, 'l_code')
		ls_pono= ldsContent.getItemString( ll_row, 'po_no')
		ll_qty = ldsContent.getItemNumber( ll_row, 'Qty')
		ls_Ro_No = ldsContent.getItemString( ll_row, 'Ro_No')
		ls_Lot_No = ldsContent.getItemString( ll_row, 'Lot_No')
		ls_Po_No2 = ldsContent.getItemString( ll_row, 'Po_No2')
		ls_Container_Id = ldsContent.getItemString( ll_row, 'Container_Id')
		ldt_Exp_Date = ldsContent.getItemDateTime( ll_row, 'Expiration_Date')
		
		select Owner_Cd into :ls_ownercd from Owner with(nolock) 
		where Project_Id= :as_project and Owner_Id =:ll_ownerId
		using sqlca;
		
		ldsSNI.reset( )
		ldsSNI.setsqlselect( ls_sql)
		ldsSNI.settransobject( SQLCA)
		ll_SNI_count = ldsSNI.retrieve( )
		
		ls_find ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and wh_code ='"+ls_wh+"' and po_no='"+ls_pono+"' and Ro_No ='"+ls_Ro_No+"' and Lot_No ='"+ls_Lot_No+"' and Po_No2='"+ls_Po_No2+"' and Carton_Id ='"+ls_Container_Id+"' and serial_no in ("+ls_formatted_alt_serial+")"
		ldsSNI.setfilter( ls_find)
		ldsSNI.filter( )
		ll_filter_count = ldsSNI.rowcount( )
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project  RESEARCH - CC_No: '+as_ccno + ' Find: '+ls_find +' against Serial Number Inventory Records and count: '+string(ll_filter_count)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		IF ll_qty > ll_filter_count THEN
			ldsSNI.setfilter( "")
			ldsSNI.filter( )
			ldsSNI.rowcount( )
			
			ls_find ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and wh_code ='"+ls_wh+"' and (po_no ='"+ls_pono+"') and serial_no IN ("+ls_formatted_alt_serial+")"
			
			ldsSNI.setfilter( ls_find)
			ldsSNI.filter( )
			ll_filter_count = ldsSNI.rowcount( )
			
			If ll_qty >= ll_filter_count Then
				ll_filter_qty =ll_filter_count
			else
				ll_filter_qty = ll_qty
			end if
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() -  Filter By Project = RESEARCH  CC_No: '+as_ccno + ' Find: '+ls_find +' against Serial Number Inventory Records and count: '+string(ll_filter_count)
			lsLogOut +=' Filtered Qty: '+string(ll_filter_qty)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			
			For ll_filter_row = 1 to ll_filter_qty
				ls_serial_no = ldsSNI.getItemString( ll_filter_row, 'serial_no')
				ls_old_po_no = ldsSNI.getItemString( ll_filter_row, 'po_no')
				ls_old_po_no2 = ldsSNI.getItemString( ll_filter_row, 'po_no2')
				
// TAM 2019/05 - S33409 - Populate Serial History Table
				update Serial_Number_Inventory set Po_No =:ls_pono, Owner_Id =:ll_ownerId, Owner_Cd =:ls_ownercd, 
					Ro_No =:ls_Ro_No, Lot_no=:ls_Lot_No, Po_No2 =:ls_Po_No2, Exp_DT =:ldt_Exp_Date, Serial_Flag ='X',
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'LOTTABLES'
				where project_Id =:as_project and sku=:ls_sku and wh_code =:ls_wh
				and l_code =:ls_loc and serial_no =:ls_serial_no
				using sqlca;
				commit;

				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() -  Filter By Project = RESEARCH  CC_No: '+as_ccno + ' Updated Po No From: '+ls_old_po_no +' To: '+ls_pono+ ' Po No2 From: '+ls_old_po_no2+' To: '+ls_Po_No2+' Mark Serial Flag =X '
				lsLogOut +=' against Sku /Loc /SN: '+ls_sku+'/'+ls_loc+'/'+ls_serial_no
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
			Next	

		End IF
		
		ldsSNI.setfilter( "")
		ldsSNI.filter( )
		ldsSNI.rowcount( )
	NEXT
	
	//10-Jan-2019 :Madhu DE8036 - If scanned serial no's are in RESEARCH project, move back to MAIN. -START
	ldsSNI.reset( )
	ldsSNI.setsqlselect( ls_sql)
	ldsSNI.settransobject( SQLCA)
	ll_SNI_count = ldsSNI.retrieve( )
	
	//find scanned serial no's which are not in MAIN project
	IF ls_formatted_cc_scan_serial > ' ' THEN
		ls_find ="po_no <> 'MAIN' and serial_no  IN ("+ls_formatted_cc_scan_serial+")"
		ldsSNI.setfilter( ls_find)
		ldsSNI.filter( )
		ll_filter_count = ldsSNI.rowcount( )
				
		For ll_filter_row = 1 to ll_filter_count
			ls_sku = ldsSNI.getItemString(ll_filter_row, 'sku')
			ls_serial_no = ldsSNI.getItemString( ll_filter_row, 'serial_no')
			ls_loc = ldsSNI.getItemString( ll_filter_row, 'l_code')
			
// TAM 2019/05 - S33409 - Populate Serial History Table
			update Serial_Number_Inventory set Po_No ='MAIN', Serial_Flag = :lsNull,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'PONO'
			where project_Id =:as_project and sku=:ls_sku and wh_code =:ls_wh
			and l_code =:ls_loc and serial_no =:ls_serial_no
			using sqlca;
			commit;
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project <> MAIN CC_No: '+as_ccno + ' Updated Scanned Serial No : '+ ls_serial_no+' Po No From: RESEARCH To: MAIN Mark Serial Flag =X '
			lsLogOut +=' against Sku /Loc /SN: '+ls_sku+'/'+ls_loc+'/'+ls_serial_no
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
		Next
	END IF
		
	ldsSNI.setfilter( "")
	ldsSNI.filter( )
	ldsSNI.rowcount( )
		
	//10-Jan-2019 :Madhu DE8036 - If scanned serial no's are in RESEARCH project, move back to MAIN. -END
	
	//B. NON-HIGH VALUE ITEMS
	//get Project <> 'RESEARCH ' Content Records and update Serial No's accordingly.
	ldsContent.setfilter("")
	ldsContent.filter()
	ldsContent.rowcount()
	
	lsContentFilter ="Po_No <> 'RESEARCH'"
	ldsContent.setfilter(lsContentFilter)
	ldsContent.filter()
	ll_content_count = ldsContent.rowcount()
	
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project <> RESEARCH  CC_No: '+as_ccno + '  - Content Records Count: '+string(ll_content_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	FOR ll_row =1 to ll_content_count
		ls_sku = ldsContent.getItemString( ll_row, 'sku')
		ls_wh = ldsContent.getItemString( ll_row, 'wh_code')
		ll_ownerId = ldsContent.getItemNumber( ll_row, 'owner_id')
		ls_loc = ldsContent.getItemString( ll_row, 'l_code')
		ls_pono= ldsContent.getItemString( ll_row, 'po_no')
		ll_qty = ldsContent.getItemNumber( ll_row, 'Qty')
		ls_Ro_No = ldsContent.getItemString( ll_row, 'Ro_No')
		ls_Lot_No = ldsContent.getItemString( ll_row, 'Lot_No')
		ls_Po_No2 = ldsContent.getItemString( ll_row, 'Po_No2')
		ls_Container_Id = ldsContent.getItemString( ll_row, 'Container_Id')
		ldt_Exp_Date = ldsContent.getItemDateTime( ll_row, 'Expiration_Date')
		
		select Owner_Cd into :ls_ownercd from Owner with(nolock) 
		where Project_Id= :as_project and Owner_Id =:ll_ownerId
		using sqlca;
	
		ldsSNI.reset( )
		ldsSNI.setsqlselect( ls_sql)
		ldsSNI.settransobject( SQLCA)
		ll_SNI_count = ldsSNI.retrieve( )
		
		ls_find ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and wh_code ='"+ls_wh+"' and po_no='"+ls_pono+"' and Ro_No ='"+ls_Ro_No+"' and Lot_No ='"+ls_Lot_No+"' and Po_No2='"+ls_Po_No2+"' and Carton_Id ='"+ls_Container_Id+"' and serial_no NOT IN ("+ls_formatted_alt_serial+")"
		ldsSNI.setfilter( ls_find)
		ldsSNI.filter( )
		ll_filter_count = ldsSNI.rowcount( )
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project <> RESEARCH  CC_No: '+as_ccno + ' Find: '+ls_find +' against Serial Number Inventory Records and count: '+string(ll_filter_count)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		IF ll_qty > ll_filter_count THEN
			ldsSNI.setfilter( "")
			ldsSNI.filter( )
			ldsSNI.rowcount( )
	
			ls_find ="sku ='"+ls_sku+"' and l_code ='"+ls_loc+"' and wh_code ='"+ls_wh+"' and (po_no ='"+ls_pono+"' OR po_no <>'"+ls_pono+"')  and serial_no NOT IN ("+ls_formatted_alt_serial+")"
			ldsSNI.setfilter( ls_find)
			ldsSNI.filter( )
			ll_filter_count = ldsSNI.rowcount( )
			
			If ll_qty >= ll_filter_count Then
				ll_filter_qty =ll_filter_count
			else
				ll_filter_qty = ll_qty
			end if
	
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project <> RESEARCH  CC_No: '+as_ccno + ' Find: '+ls_find +' against Serial Number Inventory Records and count: '+string(ll_filter_count)
			lsLogOut +=' Filtered Qty: '+string(ll_filter_qty)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
	
			For ll_filter_row = 1 to ll_filter_qty
				ls_serial_no = ldsSNI.getItemString( ll_filter_row, 'serial_no')
				ls_old_po_no = ldsSNI.getItemString( ll_filter_row, 'po_no')
				ls_old_po_no2 = ldsSNI.getItemString( ll_filter_row, 'po_no2')
				
// TAM 2019/05 - S33409 - Populate Serial History Table
				update Serial_Number_Inventory set Po_No =:ls_pono, Owner_Id =:ll_ownerId, Owner_Cd =:ls_ownercd, 
						Ro_No =:ls_Ro_No, Lot_no=:ls_Lot_No, Po_No2 =:ls_Po_No2, Exp_DT =:ldt_Exp_Date, Serial_Flag ='X',
						Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno, Adjustment_Type = 'LOTTABLES'
				where project_Id =:as_project and sku=:ls_sku and wh_code =:ls_wh
				and l_code =:ls_loc and serial_no =:ls_serial_no
				using sqlca;
				commit;
				
				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_attributes() - Filter By Project <> RESEARCH  CC_No: '+as_ccno + ' Updated Po No From: '+ls_old_po_no +' To: '+ls_pono+ ' Po No2 From: '+ls_old_po_no2+ ' To: '+ls_Po_No2+' Mark Serial Flag =X '
				lsLogOut +=' against Sku /Loc /SN: '+ls_sku+'/'+ls_loc+'/'+ls_serial_no
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
			Next	
		End IF
	
		ldsSNI.setfilter( "")
		ldsSNI.filter( )
		ldsSNI.rowcount( )
	
	NEXT
	
	//update Serial Number Inventory table to clear Serial Flag Value
	ls_sql = ls_Orig_sql
	ls_sql += " where project_Id='"+as_project+"' "
	ls_sql += " and wh_code ='"+ls_wh+"'"
	ls_sql += " and sku in ("+ls_formatted_skus+")"
	ls_sql += " and l_code in ("+ls_formatted_locs+")"
	ls_sql +=" and  Serial_Flag = 'X'  "

	ldsSNI.setsqlselect( ls_sql)
	ll_SNI_count = ldsSNI.retrieve( )
	
	For ll_row = 1 to ll_SNI_count
		ls_serial_no = ldsSNI.getItemString( ll_row, 'serial_no')
		ldsSNI.setItem( ll_row, 'Serial_Flag', lsNull)
	Next
	
	If ldsSNI.rowcount( ) > 0 Then 
		ll_rc= ldsSNI.update( )
		If ll_rc > 0 Then
			commit;
			if SQLCA.sqlcode = 0 then
				ldsSNI.resetupdate( )
			else
				ROLLBACK;
				ldsSNI.resetupdate( )
				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count  - Error Processing of uf_process_cc_update_serial_attributes()  Error: '+ nz(SQLCA.SQLErrText,'-') + ' Error Code: '+string(SQLCA.sqlcode)
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				Return -1
			End IF
		else
			ROLLBACK;
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count  - Error Processing of uf_process_cc_update_serial_attributes()  Error: '+ nz(SQLCA.SQLErrText, '-') +' Record save failed' + ' Error Code: '+string(SQLCA.sqlcode)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
	End If
End IF //SNI Count > 0


ldsContent.setfilter("")
ldsContent.filter()
ldsContent.rowcount()

destroy ldsCCScanSN
destroy ldsContent 
destroy ldsSNI 
destroy ldsCCMaster
destroy ldsCCDetail
destroy ldsAltSerial

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_update_serial_attributes() - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function str_parms uf_process_cc_serial_change (str_parms as_serial_parms);//22-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Orders

string		ls_project, ls_sku, ls_supp_code, ls_wh, ls_lcode, ls_po_No, ls_sku_filter
string		ls_serial_No, lsFind, ls_cc_no, lsLogOut, ls_Sequence, ls_New_Po_No, ls_Lot_No, ls_Po_no2, ls_Ro_No, ls_action_cd
long 		ll_Owner_Id, ll_Qty, ll_QtyCount, ll_difference_Qty, ll_row, ll_row_count, ll_Batch_Id, ll_FindRow, ll_Trans_Id, ll_Insert_count
boolean lbAutoSOC, lb_serial
DateTime ldt_Exp_dt
Str_Parms ls_Trans_Id_list

SetPointer(HourGlass!)

//Item Serial Change History Parms
ls_project = as_serial_parms.string_arg[1]
ls_wh = as_serial_parms.string_arg[2]
ls_sku =as_serial_parms.string_arg[3]
ls_supp_code = as_serial_parms.string_arg[4]
ls_Po_No = as_serial_parms.string_arg[5]
ls_cc_no = as_serial_parms.string_arg[6]
ls_lcode = as_serial_parms.string_arg[7]
ls_Sequence = as_serial_parms.string_arg[8] //CC Sequence No

ll_Owner_Id = as_serial_parms.long_arg[1]
ll_Qty = as_serial_parms.long_arg[2]
ll_QtyCount = as_serial_parms.long_arg[3]

lbAutoSOC = as_serial_parms.boolean_arg[1]

this.uf_process_cc_remove_recon_filter() //Remove filter

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_serial_change  and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Down Count & Non-High Value Items
IF ((ll_Qty > ll_QtyCount) and (lbAutoSOC =FALSE)) THEN
	//delete SN and create Batch Transaction Records
	ll_difference_Qty = ll_Qty - ll_QtyCount
	ls_sku_filter ="sku ='"+ls_sku+"' and l_code ='"+ls_lcode+"' and po_no='"+ls_Po_No+"' and Action_Cd ='D' and Owner_Id ="+string(ll_Owner_Id)
	idsCCRecon.setfilter( ls_sku_filter)
	idsCCRecon.filter( )
	
	ll_row_count = idsCCRecon.rowcount( )

	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -Down Count (Non-High Value Item)- and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku + ' - Qty: '+string(ll_Qty) + ' Result Qty: '+string(ll_QtyCount)
	FileWrite(giLogFileNo,lsLogOut)

	IF ll_row_count > 0 Then
		FOR ll_row =1 to ll_difference_Qty 
			
			ls_serial_No = idsCCRecon.getItemString( ll_row, 'serial_no')
			ll_Trans_Id = this.uf_process_cc_serial_change_history( ls_project, ls_cc_no, ls_wh, ls_sku, ls_supp_code, ll_Owner_Id, ls_Po_No, ls_serial_No, '-')
			ls_Trans_Id_list.long_arg[ll_row] = ll_Trans_Id
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -Down Count (Non-High Value Item) - and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku + ' - Serial No: '+ls_serial_No + ' - created Item Serial Change History Record. Id_No# '+string(ll_Trans_Id)
			FileWrite(giLogFileNo,lsLogOut)
			
		NEXT
	END IF
END IF

//Down count & High-Value Items
IF ((ll_Qty > ll_QtyCount) and (lbAutoSOC =TRUE)) THEN
	
	//get New PoNo from Transfer Order
	select A.New_Po_No into :ls_New_Po_No from Transfer_Detail A with(nolock)
	INNER JOIN Transfer_Master B with(nolock) ON A.To_No =B.To_No
	where B.Project_Id =:ls_project and 	B.User_Field3=:ls_Sequence and B.s_warehouse=:ls_wh 
	and A.sku=:ls_sku and A.S_Location=:ls_lcode and A.Owner_Id= :ll_Owner_Id
	using sqlca;
	
	//get attributes from Content
	select Lot_No, Po_no2, Ro_No, Expiration_Date into :ls_Lot_No, :ls_Po_no2, :ls_Ro_No, :ldt_Exp_dt
	from Content with(nolock) where Project_Id =:ls_project and wh_Code=:ls_wh
	and sku=:ls_sku and l_code=:ls_lcode and Owner_Id=:ll_Owner_Id and Po_No =:ls_New_Po_No
	using sqlca;

	//don't delete SN's and don't create batch transaction
	ls_sku_filter ="sku ='"+ls_sku+"' and l_code ='"+ls_lcode+"' and po_no='"+ls_Po_No+"' and Owner_Id ="+string(ll_Owner_Id)
	idsCCRecon.setfilter( ls_sku_filter)
	idsCCRecon.filter( )
	ll_row_count = idsCCRecon.rowcount( )

	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -Down Count (High Value Item) - and CC_No: '+ls_cc_no + ' - Sku Filter: ' +ls_sku_filter + ' - Qty: '+string(ll_Qty) + ' Result Qty: '+string(ll_QtyCount)
	FileWrite(giLogFileNo,lsLogOut)

	IF ll_row_count > 0 Then
		FOR ll_row =1 to ll_row_count 
			
			ls_serial_No = idsCCRecon.getItemString( ll_row, 'serial_no')
			lsFind  ="sku ='"+ls_sku+"' and serial_no ='"+ls_serial_No+"'"
			ll_FindRow =idsCCRecon.find( lsFind, 1, idsCCRecon.rowcount() )
			
			//verify whether SN already exists in Serial No Inventory Table
			lb_serial =this.uf_process_cc_check_serial_no_exists( ls_project, ls_wh, ls_sku, ls_serial_No)
			
			If ll_FindRow > 0  and lb_serial =TRUE Then 
				idsCCRecon.setItem( ll_FindRow, 'action_cd', 'U') //Don't delete
			else
				idsCCRecon.setItem( ll_FindRow, 'action_cd', 'I') //Insert SN, it should be dummy SN
			End IF
			idsCCRecon.setItem( ll_FindRow, 'Po_No', ls_New_Po_No) //Update New PoNo
			idsCCRecon.setItem( ll_FindRow, 'Po_No2', ls_Po_no2) //Update New PoNo2
			idsCCRecon.setItem( ll_FindRow, 'Lot_No', ls_Lot_No) //Update New LotNo
			idsCCRecon.setItem( ll_FindRow, 'Ro_No', ls_Ro_No) //Update RoNo
			idsCCRecon.setItem( ll_FindRow, 'Exp_DT', ldt_Exp_dt) //Update New Exp Dt

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -Down Count (High Value Item) - and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku + ' - Serial No: '+ls_serial_No
			FileWrite(giLogFileNo,lsLogOut)
	
		NEXT
	ELSE
		//might, any records have Action Cd ='D', reset to 'X' - don't delete any serial no
		this.uf_process_cc_remove_recon_filter() //Remove filter
		
		ls_sku_filter ="sku ='"+ls_sku+"' and Owner_Id ="+string(ll_Owner_Id) +" and Action_Cd = 'D'"
		idsCCRecon.setfilter( ls_sku_filter)
		idsCCRecon.filter( )
		ll_row_count = idsCCRecon.rowcount( )
		
		FOR ll_row = 1 to ll_row_count
			idsCCRecon.setItem( ll_row, 'Action_Cd', 'X')
		NEXT

		this.uf_process_cc_remove_recon_filter() //Remove filter
		
	END IF
END IF

//Up Count
IF ll_Qty < ll_QtyCount THEN

	ll_difference_Qty = ll_QtyCount - ll_Qty
	ls_sku_filter ="sku ='"+ls_sku+"' and l_code ='"+ls_lcode+"' and po_no='"+ls_Po_No+"' and Action_Cd ='I' and Owner_Id ="+string(ll_Owner_Id)
	idsCCRecon.setfilter( ls_sku_filter)
	idsCCRecon.filter( )
	ll_row_count = idsCCRecon.rowcount( )

	//12-JUNE-2018 :Madhu S19881 - If processing Serial No is NEW and associated with different Po No.
	IF ll_row_count = 0 THEN
		this.uf_process_cc_remove_recon_filter() //Remove filter
		
		ls_sku_filter ="sku ='"+ls_sku+"' and l_code ='"+ls_lcode+"' and Action_Cd ='I' and Owner_Id ="+string(ll_Owner_Id)
		idsCCRecon.setfilter( ls_sku_filter)
		idsCCRecon.filter( )
		ll_row_count = idsCCRecon.rowcount( )
		
	END IF
	
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -UP Count - and CC_No: '+ls_cc_no + ' - Sku Filter: ' +ls_sku_filter + ' - Qty: '+string(ll_Qty) + ' Result Qty: '+string(ll_QtyCount) +' Row Count: '+string(ll_row_count)
	FileWrite(giLogFileNo,lsLogOut)

	IF ll_row_count > 0 Then
		
		If ll_row_count >= ll_difference_Qty Then
			ll_Insert_count = ll_difference_Qty
		else
			ll_Insert_count = ll_row_count
		End If
		
		FOR ll_row =1 to ll_Insert_count 
			ls_serial_No = idsCCRecon.getItemString( ll_row, 'serial_no')
			ll_Trans_Id = this.uf_process_cc_serial_change_history( ls_project, ls_cc_no, ls_wh, ls_sku, ls_supp_code, ll_Owner_Id, ls_Po_No, '-' ,ls_serial_No)
			ls_Trans_Id_list.long_arg[ll_row] = ll_Trans_Id
	
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change  -UP Count- and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku + ' - Serial No: '+ls_serial_No + ' - created Item Serial Change History Record. Id_No# '+string(ll_Trans_Id)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			
		NEXT
	END IF
END IF

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_serial_change  and CC_No: '+ls_cc_no + ' - SKU: ' +ls_sku
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

this.uf_process_cc_remove_recon_filter() //Remove filter

Return ls_Trans_Id_list
end function

public function long uf_process_create_batch_transaction (string as_project, string as_trans_type, long al_trans_order_id, string as_trans_parm);string ls_trans_order_Id
long 	ll_Batch_Row, ll_rc, ll_batch_Id
DateTime ldtToday

Datastore ldsBatchTran

If Not IsValid(ldsBatchTran) Then
	ldsBatchTran = create u_ds_datastore
	ldsBatchTran.dataobject='d_batch_transaction'
	ldsBatchTran.settransobject( SQLCA)
End If

ldtToday =DateTime(Today(), Now())
ls_trans_order_Id = string(al_trans_order_Id)

//Create Batch Transaction Record
Insert into Batch_Transaction (Project_Id, Trans_Type, Trans_Order_Id, Trans_Status, Trans_Parm,Trans_Create_Date)
values (:as_project, :as_trans_type, :ls_trans_order_Id, 'N',:as_trans_parm, :ldtToday)
using sqlca;

select Max(Trans_Id) into :ll_Batch_Id from Batch_Transaction with(nolock)
where Project_Id=:as_project and Trans_Type=:as_trans_type
and Trans_Order_Id =:ls_trans_order_Id
using sqlca;


Return ll_Batch_Id
end function

public function datastore uf_process_cc_add_update_serialno (string as_action_cd, string as_project_id, string as_wh_code, string as_sku, long al_owner_id, string as_loc, string as_po_no, string as_serial_no);//18-Nov-2017 :Madhu 3PL Cycle Count Orders
//a. Reconcile Serial numbers between the Serial Inventory table and the serial numbers scanned on the Cycle Count

string		 ls_owner_cd
long		 ll_new_row, ll_count

If Not isvalid(idsCCRecon) Then
	idsCCRecon = Create Datastore
	idsCCRecon.Dataobject = 'd_cc_recon_serial'
	idsCCRecon.SetTransObject(SQLCA)
End If

SetPointer(Hourglass!)

select Owner_Cd into :ls_owner_cd from Owner with(nolock) where Project_Id =:as_project_Id and Owner_Id =:al_owner_Id using sqlca;

ll_new_row = idsCCRecon.insertrow( 0)
idsCCRecon.setItem( ll_new_row, 'Action_Cd', as_action_cd)
idsCCRecon.setItem( ll_new_row, 'Project_Id', as_project_Id)
idsCCRecon.setItem( ll_new_row, 'WH_Code', as_wh_code)
idsCCRecon.setItem( ll_new_row, 'Owner_Id', al_owner_Id)
idsCCRecon.setItem( ll_new_row, 'Owner_Cd', ls_owner_cd)
idsCCRecon.setItem( ll_new_row, 'SKU', as_sku)
idsCCRecon.setItem( ll_new_row, 'Serial_No', as_serial_no)
idsCCRecon.setItem( ll_new_row, 'Component_Ind', 'N')
idsCCRecon.setItem( ll_new_row, 'Component_No', 0)
idsCCRecon.setItem( ll_new_row, 'Update_Date', DateTime(Today(),Now()))
idsCCRecon.setItem( ll_new_row, 'Update_User', 'SIMSFP')
idsCCRecon.setItem( ll_new_row, 'l_code', as_loc)
idsCCRecon.setItem( ll_new_row, 'Lot_No', '-')
idsCCRecon.setItem( ll_new_row, 'Po_No', as_po_no)
idsCCRecon.setItem( ll_new_row, 'Po_No2', '-')
idsCCRecon.setItem( ll_new_row, 'Exp_DT', '12/31/2999')
idsCCRecon.setItem( ll_new_row, 'RO_NO', '-')					
idsCCRecon.setItem( ll_new_row, 'Inventory_Type', 'N')
	
ll_count =idsCCRecon.rowcount( )

Return idsCCRecon
end function

public function integer uf_process_cc_reconcile_serial_inv_table (string as_project, string as_cc_no);//26-Dec-2017 :Madhu PEVS-806 3PL CC Order
//Reconcile Serial No Inventory Table against System Generated Locations.
//sometimes, Content Locations and Serial No Inventory Table Locations doesn't match even those have same attributes.

string 	sql_syntax, ls_errors, ls_sku, ls_sku_prev, ls_wh, ls_sku_list[], ls_formatted_skus, ls_SNI_serialNo, ls_SNI_loc, ls_Po_No, ls_serialNo
string		ls_cc_sku, ls_cc_po_no, ls_cc_lcode, lsFind, ls_mod_sql, ls_loc, ls_loc_prev, ls_loc_list[], ls_formatted_locs, ls_OwnerId_List, lsLogOut
string		ls_cc_po_no2, ls_cc_container_id
long 		ll_cc_count, ll_CC_Inv_count, ll_row, ll_cc_owner_Id, ll_OwnerId, ll_OwnerId_Prev
long		ll_cc_sys_qty, ll_cc_count_qty, ll_row_count, ll_findrow, ll_SN_count, ll_Pos, ll_remain_count

Datastore lds_CC_SNI, ldsCCMaster, ldsSerial

SetPointer(HourGlass!)

If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create Datastore
	ldsCCMaster.Dataobject = 'd_cc_master'
	ldsCCMaster.SetTransObject(SQLCA)
End If

If Not isvalid(ldsSerial) Then
	ldsSerial = Create Datastore
	ldsSerial.Dataobject = 'd_serial_number_inventory'
	ldsSerial.SetTransObject(SQLCA)
End If

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Start Processing of uf_process_cc_reconcile_serial_inv_table  - CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//CC Master
ll_cc_count = ldsCCMaster.retrieve( as_cc_no)
If ll_cc_count > 0 Then ls_wh = ldsCCMaster.getItemstring( 1, 'wh_code')

//CC Inv and CC  Results
lds_CC_SNI = create Datastore
sql_syntax =" SELECT CC.CC_No,CC.sku, CC.l_code, CC.Owner_Id, CC.Po_No, sum(CC.Quantity) as Sys_Qty, CC.PO_No2, CC.Container_Id, "
sql_syntax += " (CASE WHEN SUM(IsNull(CC3.Quantity,0)) > 0 THEN SUM(IsNull(CC3.Quantity,0)) "
sql_syntax += "	  WHEN SUM(IsNull(CC3.Quantity,0)) = 0 and SUM(IsNull(CC2.Quantity,0)) > 0 THEN SUM(IsNull(CC2.Quantity,0)) "
sql_syntax += "	  WHEN SUM(IsNull(CC3.Quantity,0)) = 0 and SUM(IsNull(CC2.Quantity,0)) = 0 and SUM(IsNull(CC1.Quantity,0)) > 0 THEN SUM(IsNull(CC1.Quantity,0))  "
sql_syntax += " END) as Count_Qty "
sql_syntax +="  FROM CC_Inventory CC with(nolock) "
sql_syntax +="	LEFT JOIN CC_Result_1 CC1 With (NOLOCK) ON CC.CC_No = CC1.CC_No "
sql_syntax +="	AND CC.line_item_no = CC1.line_item_no "
sql_syntax +="	LEFT JOIN CC_Result_2 CC2 With (NOLOCK) ON CC.CC_No = CC2.CC_No "
sql_syntax +=" 	AND CC.line_item_no = CC2.line_item_no "
sql_syntax +="	LEFT JOIN CC_Result_3 CC3 With (NOLOCK) ON CC.CC_No = CC3.CC_No "
sql_syntax +="	AND CC.line_item_no = CC3.line_item_no "
sql_syntax +=" WHERE CC.CC_No='"+as_cc_no+"'"
sql_syntax +="  GROUP BY CC.CC_No,CC.sku, CC.l_code, CC.Owner_Id, CC.Po_No,CC.PO_No2,CC.Container_Id "

lds_CC_SNI.create( SQLCA.syntaxfromsql( sql_syntax, "", ls_errors))
lds_CC_SNI.settransobject( SQLCA)
ll_CC_Inv_count = lds_CC_SNI.retrieve( )

//format SKU's
For ll_row =1 to ll_CC_Inv_count
	ls_sku = lds_CC_SNI.getItemString( ll_row, 'sku')
	If ls_sku_prev <> ls_sku Then	ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
	ls_sku_prev =ls_sku
Next

If UpperBound(ls_sku_list) > 0 Then 
	ls_formatted_skus = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 )
End If

//format Locs's
For ll_row =1 to ll_CC_Inv_count
	ls_loc = lds_CC_SNI.getItemString( ll_row, 'l_code')
	If ls_loc_prev <> ls_loc Then	ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_loc
	ls_loc_prev =ls_loc
Next

If UpperBound(ls_loc_list) > 0 Then 
	ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 )
End If

//format Owner Id's
For ll_row =1 to ll_CC_Inv_count
	ll_OwnerId = lds_CC_SNI.getItemNumber( ll_row, 'Owner_Id')
	If ll_OwnerId_Prev <> ll_OwnerId Then	
		ls_OwnerId_List += string(ll_OwnerId) +","
	End If
	ll_OwnerId_Prev = ll_OwnerId
Next

If len(ls_OwnerId_List) > 0 Then
	ll_Pos = LastPos(ls_OwnerId_List, ",")
	If ll_Pos > 0 Then ls_OwnerId_List =Left(ls_OwnerId_List, len(ls_OwnerId_List) - 1)
End If


//get a list of SN's with combination of SKU+WH from SNI Table
sql_syntax = ldsSerial.getsqlselect( )
sql_syntax += " where Project_Id ='"+as_project+"' "
sql_syntax +=" and wh_code ='"+ls_wh+"' "
sql_syntax +=" and sku IN ("+ls_formatted_skus+")"

//Find records with combination of SKU +OwnerId+ PoNo
FOR ll_row =1 to ll_CC_Inv_count
	ls_cc_sku = lds_CC_SNI.getItemString( ll_row, 'sku')
	ll_cc_owner_Id =lds_CC_SNI.getItemNumber( ll_row, 'Owner_Id')
	ls_cc_po_no = lds_CC_SNI.getItemString( ll_row, 'Po_No')
	ls_cc_lcode = lds_CC_SNI.getItemString( ll_row, 'l_code')
	ls_cc_po_no2 = lds_CC_SNI.getItemString( ll_row, 'Po_No2') //Added Po_No2
	ls_cc_container_Id = lds_CC_SNI.getItemString( ll_row, 'Container_Id') //Added Container Id
	
	ll_cc_sys_qty = lds_CC_SNI.getItemNumber(ll_row, 'Sys_Qty')
	ll_cc_count_qty = lds_CC_SNI.getItemNumber(ll_row, 'Count_Qty')

	If IsNull(ll_cc_count_qty) Then ll_cc_count_qty =0
	
	//get count with combination of Owner Id + PoNo
	ls_mod_sql = sql_syntax
	ls_mod_sql +=	" and Owner_Id ="+string(ll_cc_owner_Id)+" and Po_No ='"+ls_cc_po_no+"'"
	ldsSerial.setsqlselect( ls_mod_sql)
	ll_row_count = ldsSerial.retrieve( )
	
	IF ll_row_count > 0 Then
			//get count with combination of Owner Id + PoNo + Location
			ls_mod_sql = sql_syntax
			ls_mod_sql +=	" and Owner_Id ="+string(ll_cc_owner_Id)+" and Po_No ='"+ls_cc_po_no+"' and L_code ='"+ls_cc_lcode+"'"
			If ls_cc_po_no2 >'-' Then ls_mod_sql +=" and Po_No2 ='"+ls_cc_po_no2+"'" //12-Oct-2018 :Madhu DE6671 Added
			If ls_cc_container_Id > '-' Then ls_mod_sql += " and Carton_Id ='"+ls_cc_container_Id+"'" //12-Oct-2018 :Madhu DE6671 Added
			
			ldsSerial.setsqlselect( ls_mod_sql)
			ll_SN_count = ldsSerial.retrieve( )
			
			IF ll_SN_count = 0 Then ll_SN_count =1 //Initial value
			
			ll_findrow = 1 //Initial value
			DO WHILE (ll_cc_count_qty > ll_SN_count) and (ll_findrow > 0) and (ll_SN_count > 0)
				ldsSerial.reset()
				ldsSerial.setsqlselect( sql_syntax)
				ldsSerial.retrieve( )

				//Find a record with combination of Owner Id+ PoNo +Other than scanned Location's
				lsFind =" sku ='"+ls_cc_sku+"' and Po_No ='"+ls_cc_po_no+"' and L_code NOT IN ("+ls_formatted_locs+") and Owner_Id ="+string(ll_cc_owner_Id)
				If ls_cc_po_no2 >'-' Then lsFind +=" and Po_No2 ='"+ls_cc_po_no2+"'" //12-Oct-2018 :Madhu DE6671 Added
				If ls_cc_container_Id > '-' Then lsFind += " and Carton_Id ='"+ls_cc_container_Id+"'" //12-Oct-2018 :Madhu DE6671 Added
			
				ll_findrow = ldsSerial.find( lsFind, 1, ldsSerial.rowcount())
				
				If ll_findrow > 0 Then
					ls_SNI_serialNo = ldsSerial.getItemString( ll_findrow, 'serial_no')
					ls_SNI_loc = ldsSerial.getItemString( ll_findrow, 'l_code')
	
					update Serial_Number_Inventory set L_code =:ls_cc_lcode
					where Project_Id =:as_project and sku=:ls_cc_sku and L_code =:ls_SNI_loc
					and Owner_Id= :ll_cc_owner_Id and Po_No =:ls_cc_po_no
					and Serial_No =:ls_SNI_serialNo
					using sqlca;
					commit;
					
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_reconcile_serial_inv_table  - CC_No: '+as_cc_no+ ' Location Updated From: '+ls_SNI_loc+' To: '+ls_cc_lcode+' Serial No: '+ls_SNI_serialNo
					FileWrite(giLogFileNo,lsLogOut)
					//gu_nvo_process_files.uf_write_log(lsLogOut)
	
					ldsSerial.reset()
					ldsSerial.setsqlselect( ls_mod_sql)
					ll_SN_count = ldsSerial.retrieve( )
				else
					ll_findrow =0
					ll_SN_count = 0
					lsFind =" sku= '"+ls_cc_sku+"' and Po_No ='"+ls_cc_po_no+"' and L_code NOT IN ('"+ls_cc_lcode+"') and Owner_Id ="+string(ll_cc_owner_Id)
					If ls_cc_po_no2 >'-' Then lsFind +=" and Po_No2 ='"+ls_cc_po_no2+"'" //12-Oct-2018 :Madhu DE6671 Added
					If ls_cc_container_Id > '-' Then lsFind += " and Carton_Id ='"+ls_cc_container_Id+"'" //12-Oct-2018 :Madhu DE6671 Added
				
					ll_findrow = ldsSerial.find( lsFind, 1, ldsSerial.rowcount())
			
					If ll_findrow > 0 Then
						ls_SNI_serialNo = ldsSerial.getItemString( ll_findrow, 'serial_no')
						ls_SNI_loc = ldsSerial.getItemString( ll_findrow, 'l_code')
		
						update Serial_Number_Inventory set L_code =:ls_cc_lcode
						where Project_Id =:as_project and sku=:ls_cc_sku and L_code =:ls_SNI_loc
						and Owner_Id= :ll_cc_owner_Id and Po_No =:ls_cc_po_no
						and Serial_No =:ls_SNI_serialNo
						using sqlca;
						commit;
						
						//Write to File and Screen
						lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_reconcile_serial_inv_table  - CC_No: '+as_cc_no+ ' Location Updated From: '+ls_SNI_loc+' To: '+ls_cc_lcode+' Serial No: '+ls_SNI_serialNo
						FileWrite(giLogFileNo,lsLogOut)
						//gu_nvo_process_files.uf_write_log(lsLogOut)
		
						ldsSerial.reset()
						ldsSerial.setsqlselect( ls_mod_sql)
						ll_SN_count = ldsSerial.retrieve( )
					End If

					//Find a record with combination of Owner Id+ PoNo +Other than scanned Location's
					//ll_findrow = ldsSerial.find( lsFind, 1, ldsSerial.rowcount())
				End If
			LOOP
	End IF
Next

//Look for Serial Records Other than scanned Loc /Serial No
//25-SEP-2018 :Madhu DE6374 - Don't delete un-scanned locations.
//sql_syntax +=" and L_code NOT IN ("+ls_formatted_locs+")"
//sql_syntax +=" and Owner_Id IN ("+ls_OwnerId_List+")"
//ldsSerial.setsqlselect( sql_syntax)
//ll_remain_count = ldsSerial.retrieve( )
//
//If ll_remain_count > 0 Then
//	For ll_row = 1 to ll_remain_count
//		ls_sku = ldsSerial.getItemString( ll_row, 'sku')
//		ll_OwnerId= ldsSerial.getItemNumber( ll_row, 'Owner_Id')
//		ls_loc = ldsSerial.getItemString( ll_row, 'L_code')
//		ls_Po_No = ldsSerial.getItemString( ll_row, 'Po_No')
//		ls_serialNo = ldsSerial.getItemString( ll_row, 'Serial_No')
//		
//		this.uf_process_cc_add_update_serialno( 'D', as_project, ls_wh, ls_sku, ll_OwnerId, ls_loc, ls_Po_No, ls_serialNo)
//	Next
//End If

Destroy lds_CC_SNI 
Destroy ldsCCMaster
Destroy ldsSerial

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  End Processing of uf_process_cc_reconcile_serial_inv_table  - CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function long uf_om_sn_adjustment (string asproject, long al_transid, string as_trans_order_id, string as_itrn_key);//22-Aug-2017 :Madhu PINT-947 - Serial No Adjustment

Datastore	ldsOC
Long 		ll_InvTxn_row, llid_no, llRowPos, llRowCount, llRC
string 	ls_client_Id, lslogOut, sql_syntax, ERRORS, ls_wh, ls_sku
string		ls_to_serialno, ls_from_serialno, ls_trans_parm
DateTime	ldtToday

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Adj-SN change- Start Processing of uf_om_sn_adjustment() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
If Not isvalid(idsOMQInvTxnSernum) Then
	idsOMQInvTxnSernum = Create u_ds_datastore
	idsOMQInvTxnSernum.Dataobject = 'd_omq_inventory_txn_sernum'
End If
idsOMQInvTxnSernum.SetTransObject(om_sqlca)

select Trans_Parm into :ls_trans_parm from Batch_Transaction with(nolock)
where Project_Id= :asproject
and Trans_Order_Id =:as_trans_order_Id
and Trans_Type='MM'
using sqlca;

If (len(ls_trans_parm) > 0 and ls_trans_parm <>' ' and not IsNull(ls_trans_parm)) Then
	ldsOC = Create Datastore
	sql_syntax = "SELECT Wh_Code, Complete_Date, Id_No, Owner_Id,   Po_No, Sku, From_Serial_No,  To_Serial_No"  
	sql_syntax += " FROM Item_Serial_Change_History  with(nolock)"
	sql_syntax += " WHERE Transaction_Sent <> 'Y' "
	sql_syntax += " AND Project_Id ='"+asproject+"'"
	sql_syntax +=" AND Id_No IN ("+ls_trans_parm+")"
	sql_syntax += "  AND Wh_Code IN ( SELECT wh_code FROM Warehouse with(nolock) WHERE OM_Enabled_Ind = 'Y');"
	
	ldsOC.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	
	IF Len(ERRORS) > 0 THEN
		lsLogOut = "         OM Adj-SN change -  Unable to create datastore for PANDORA Serial Number Change Transaction.~r~r" + Errors
		FileWrite(gilogFileNo,lsLogOut)
		RETURN -1
	END IF
	
	ldsOC.SetTransObject(SQLCA)
	llRowCount = ldsOC.retrieve( )
	
	select OM_Client_Id into :ls_client_Id from Project where Project_Id= :asproject
	using sqlca;
	
	For llRowPos = 1 to llRowCount
		ls_wh = ldsOC.GetItemString(llRowPos, 'Wh_Code') //wh code
		ls_sku= ldsOC.GetItemString(llRowPos, 'Sku') //sku
		ls_from_serialno =ldsOC.GetItemString(llRowPos, 'From_Serial_No')
		ls_to_serialno =ldsOC.GetItemString(llRowPos, 'To_Serial_No')
			
		llid_no =ldsOC.GetItemNumber(llRowPos, 'Id_No')
		
		//Write OMQ_Inventory_Txn_Sernum Record
		ll_InvTxn_row = idsOMQInvTxnSernum.insertrow( 0)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QADDWHO', 'SIMSUSER') //Add Who
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QACTION', 'I') //Action
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUS', 'NEW') //Status
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QWMQID', al_transId) //Set with Batch_Transaction.Id_No
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SITE_ID', ls_wh) //site id
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDDATE', ldtToday) //Add Date
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDWHO', 'SIMSUSER') //Add who
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITDATE', ldtToday) //Add Date
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITWHO', 'SIMSUSER') //Add who
	
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'CLIENT_ID', ls_client_Id)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNKEY', as_itrn_key)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNSERIALKEY', '1')
		
		IF (not IsNull(ls_from_serialno) and ls_from_serialno <> '-' ) Then
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ls_from_serialno)
		else
			idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ls_to_serialno)
		End If
		
		//Write to file
		lsLogOut = ' OM Adj-SN change - Record inserted into OMQ_Inventory_Txn_Sernum table aginst ItrnKey# '+string(as_itrn_key)+' From Serial No# '+ ls_from_serialno +'  To Serial No# '+ ls_to_serialno
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
	
		UPDATE dbo.Item_Serial_Change_History  
		SET Transaction_Sent = 'Y'  
		WHERE dbo.Item_Serial_Change_History.ID_No = :llid_no   using sqlca;
	
	NEXT
	
	Execute Immediate "Begin Transaction" using om_sqlca;
	If (idsOMQInvTxnSernum.rowcount( ) > 0 ) Then 	llRC = idsOMQInvTxnSernum.update(false, false);
	
	If llRC =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTxnSernum.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQInvTxnSernum.reset()
			
			//Write to File and Screen
			lsLogOut = '      -OM Adj-SN change- Processing of uf_om_sn_adjustment  is failed to write/update OM Tables: ' + om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//Write to File and Screen
		lsLogOut = "      -  OM Adj-SN change- Processing of uf_om_sn_adjustment  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
	destroy ldsOC
End If

destroy 	idsOMQInvTxnSernum

//Write to File and Screen
lsLogOut = '      - OM Adj-SN change- End Processing of uf_om_sn_adjustment() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function long uf_process_cc_serial_change_history (string as_project, string as_cc_no, string as_wh, string as_sku, string as_suppcode, long al_ownerid, string as_pono, string as_from_serial_no, string as_to_serial_no);//15-Dec-2017 :Madhu PEVS-806 3PL Cycle Count Order
//Insert record into Item_Serial_change_History table, if already doesn't exist

string lsLogOut
long ll_count, ll_Batch_Id, ll_Trans_Id
DateTime ldtToday

ldtToday = DateTime(today() ,now())

SetPointer(HourGlass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Start Processing of uf_process_cc_serial_change_history  - CC_No: '+as_cc_no+ ' sku: '+as_sku+ ' From SN: '+nz(as_from_serial_no, '-')+ ' To SN: '+nz(as_to_serial_no,'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


select count(*) into :ll_count from Item_Serial_Change_History with(nolock)
where Project_Id= :as_project and sku=:as_sku
and wh_code =:as_wh and Owner_Id =:al_ownerId
and ( From_Serial_No =:as_from_serial_no and To_Serial_No =:as_to_serial_no)
and Transaction_Sent <>'Y'
using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change_history  - CC_No: '+as_cc_no+ ' SN count: '+ string(ll_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If ll_count = 0 Then
	
	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_change_history  - CC_No: '+as_cc_no+ 'sku: '+as_sku+ ' From SN: '+nz(as_from_serial_no, '-')+ ' To SN: '+nz(as_to_serial_no,'-')+ ' Inserted.'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//Insert record into Item_Serial_change_history table
	Insert into Item_Serial_Change_History (Project_Id,WH_Code,Owner_Id,PO_No,Sku,Supp_Code,From_Serial_No,To_Serial_No,Transaction_Sent, Update_User, Complete_Date)
	values (:as_project, :as_wh, :al_ownerId, :as_pono, :as_sku, :as_suppcode, :as_from_serial_no, :as_to_serial_no, 'N', 'SIMSFP', :ldtToday)
	using sqlca;
	commit;
End If

select Max(Id_No) into :ll_Trans_Id from Item_Serial_Change_History with(nolock)
where Project_Id= :as_project and sku=:as_sku
and wh_code =:as_wh and Owner_Id =:al_ownerId and PO_No =:as_pono
and  From_Serial_No =:as_from_serial_no and To_Serial_No =:as_to_serial_no
and Transaction_Sent <> 'Y' and Update_User='SIMSFP'
using sqlca;

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count-  End Processing of uf_process_cc_serial_change_history  - CC_No: '+as_cc_no+ ' sku: '+as_sku+ ' From SN: '+nz(as_from_serial_no, '-')+ ' To SN: '+nz(as_to_serial_no,'-') +' Trans Id: '+string(ll_Trans_Id)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return ll_Trans_Id

end function

public function long uf_process_cc_update_serial_records (string as_project);//27-Dec-2017 :Madhu PEVS-806 3PL CC Orders.

string		ls_action_cd, ls_wh, ls_owner_cd, ls_sku, ls_serial_no, ls_lcode, ls_lot_No, lsFilter
string		ls_po_No, ls_po_No2, ls_Ro_No, ls_Inv_Type, ls_carton_Id, lsLogOut, ls_old_wh_code
long		ll_Owner_Id, ll_row, ll_wh_count, ll_count, ll_filter_count
datetime		ldt_exp_date, ldtToday

string ls_CS_RO_NO
datastore lds_content_summary_ro_cc_resolve
		
lds_content_summary_ro_cc_resolve = Create datastore
lds_content_summary_ro_cc_resolve.dataobject = "d_content_summary_ro_cc_resolve"
lds_content_summary_ro_cc_resolve.SetTransObject(SQLCA)

ldtToday =DateTime(today(),now())

SetPointer(HourGlass!)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_update_serial_records() '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

IF idsCCRecon.rowcount( ) > 0 THEN

	//Filter By Action 'LOCATION'
	lsFilter = "Action_Cd ='L'"
	idsCCRecon.setfilter( lsFilter)
	idsCCRecon.filter( )
	ll_filter_count = idsCCRecon.rowcount( )
	
	For ll_row = 1 to ll_filter_count
		ls_action_cd = idsCCRecon.getItemString( ll_row, 'Action_Cd')
		ls_wh = idsCCRecon.getItemString( ll_row, 'WH_Code')
		ls_sku = idsCCRecon.getItemString( ll_row, 'SKU')
		ls_serial_no =idsCCRecon.getItemString( ll_row, 'Serial_No')
		ls_lcode= idsCCRecon.getItemString( ll_row, 'l_code')
		ls_po_No =idsCCRecon.getItemString( ll_row, 'Po_No')

	// TAM 2019/05 - S33409 - Populate Serial History Table
		update  Serial_Number_Inventory
		set		Transaction_Type = 'CYCLE COUNT',	Transaction_Id = '3PL', Adjustment_Type = 'SR-UNKNOWN', l_code = 'UNKNOWN'
		where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no and l_code = :ls_lcode and Po_No =:ls_po_No
		using sqlca;
		commit;
			
//		delete  from Serial_Number_Inventory where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no and l_code = :ls_lcode and Po_No =:ls_po_No
//		using sqlca;
//		commit;
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Move Location to UNKNOWN  Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
		FileWrite(giLogFileNo,lsLogOut)

	Next
	
	this.uf_process_cc_remove_recon_filter() //Remove filter
	
	
	//Filter By Action 'Delete'
	lsFilter = "Action_Cd ='D'"
	idsCCRecon.setfilter( lsFilter)
	idsCCRecon.filter( )
	ll_filter_count = idsCCRecon.rowcount( )
	
	For ll_row = 1 to ll_filter_count
		ls_action_cd = idsCCRecon.getItemString( ll_row, 'Action_Cd')
		ls_wh = idsCCRecon.getItemString( ll_row, 'WH_Code')
		ls_sku = idsCCRecon.getItemString( ll_row, 'SKU')
		ls_serial_no =idsCCRecon.getItemString( ll_row, 'Serial_No')
		ls_lcode= idsCCRecon.getItemString( ll_row, 'l_code')
		ls_po_No =idsCCRecon.getItemString( ll_row, 'Po_No')

	// TAM 2019/05 - S33409 - Populate Serial History Table
		update  Serial_Number_Inventory
		set		Transaction_Type = 'CYCLE COUNT',	Transaction_Id = '3PL', Adjustment_Type = 'DELETED'
		where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no and l_code = :ls_lcode and Po_No =:ls_po_No
		using sqlca;
		commit;
			
		delete  from Serial_Number_Inventory where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no and l_code = :ls_lcode and Po_No =:ls_po_No
		using sqlca;
		commit;
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Deleted  Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
		FileWrite(giLogFileNo,lsLogOut)

	Next
	
	this.uf_process_cc_remove_recon_filter() //Remove filter

	//Filter By Action 'Update'
	lsFilter = "Action_Cd ='U'"
	idsCCRecon.setfilter( lsFilter)
	idsCCRecon.filter( )
	ll_filter_count = idsCCRecon.rowcount( )
	
	For ll_row = 1 to ll_filter_count
		ls_action_cd = idsCCRecon.getItemString( ll_row, 'Action_Cd')
		ls_wh = idsCCRecon.getItemString( ll_row, 'WH_Code')
		ls_sku = idsCCRecon.getItemString( ll_row, 'SKU')
		ll_Owner_Id =idsCCRecon.getItemNumber( ll_row, 'Owner_Id')
		ls_owner_cd =idsCCRecon.getItemString( ll_row, 'Owner_Cd')
		ls_serial_no =idsCCRecon.getItemString( ll_row, 'Serial_No')
		ls_lcode= idsCCRecon.getItemString( ll_row, 'l_code')
		ls_po_No =idsCCRecon.getItemString( ll_row, 'Po_No')

//		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//		uf_check_serial_number_exist(as_project, 'CYCLE_COUNT-U', ls_wh, ls_lcode, ls_sku, ls_serial_no)	

		update Serial_Number_Inventory set l_code = :ls_lcode, Po_No =:ls_po_No, Owner_Id =:ll_Owner_Id, Owner_Cd =:ls_Owner_cd
		where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no
		using sqlca;
		commit;
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Updated Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
		FileWrite(giLogFileNo,lsLogOut)

	Next

	this.uf_process_cc_remove_recon_filter() //Remove filter

	//Filter By Action 'Insert'
	lsFilter = "Action_Cd ='I'"
	idsCCRecon.setfilter( lsFilter)
	idsCCRecon.filter( )
	ll_filter_count = idsCCRecon.rowcount( )

	For ll_row = 1 to ll_filter_count
		ls_action_cd = idsCCRecon.getItemString( ll_row, 'Action_Cd')
		ls_wh = idsCCRecon.getItemString( ll_row, 'WH_Code')
		ll_Owner_Id =idsCCRecon.getItemNumber( ll_row, 'Owner_Id')
		ls_owner_cd =idsCCRecon.getItemString( ll_row, 'Owner_Cd')
		ls_sku = idsCCRecon.getItemString( ll_row, 'SKU')
		ls_serial_no =idsCCRecon.getItemString( ll_row, 'Serial_No')
		ls_lcode= idsCCRecon.getItemString( ll_row, 'l_code')
		ls_lot_No =idsCCRecon.getItemString( ll_row, 'Lot_No')
		ls_po_No =idsCCRecon.getItemString( ll_row, 'Po_No')
		ls_po_No2 = idsCCRecon.getItemString( ll_row, 'Po_No2')
		ldt_exp_date = idsCCRecon.getItemDateTime( ll_row, 'Exp_DT')
		
		//OCT 2019 - Mikea - This will always be '-' because that is how it is passed from datawindow in CycleCount.
		//Will try to resolve RO_No

		lds_content_summary_ro_cc_resolve.Retrieve(as_project, ls_wh, ls_lcode, ls_sku, ll_Owner_Id, ls_po_No)

		//There will need to be more logic put behind this if there are multip_ro_nos. 

		If lds_content_summary_ro_cc_resolve.RowCount() >= 1 Then
			ls_Ro_No = lds_content_summary_ro_cc_resolve.GetItemString(1, "Ro_No")
		Else
			ls_Ro_No =idsCCRecon.getItemString( ll_row, 'RO_NO')
		End IF
		
		ls_Inv_Type =idsCCRecon.getItemString( ll_row, 'Inventory_Type')
		ls_carton_Id =idsCCRecon.getItemString( ll_row, 'Carton_Id')

		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
		//This check is done in another process. 
	
//		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//		uf_check_serial_number_exist(as_project, 'CYCLE_COUNT-I', ls_wh, ls_lcode, ls_sku, ls_serial_no)	

		//Double Check 

//		//check if serial no already assigned with different warehouse, update warehouse against SNI table.
//		select wh_code, count(*) into :ls_old_wh_code, :ll_wh_count 	from Serial_Number_Inventory with(nolock) 
//		where Project_Id= :as_project and sku= :ls_sku and serial_no= :ls_serial_no and wh_code <> :ls_wh
//		group by wh_code
//		using sqlca;
			
		If ll_wh_count > 0 Then
			
// TAM 2019/05 - S33409 - Populate Serial History Table
			update Serial_Number_Inventory set wh_code = :ls_wh, l_code = :ls_lcode, Po_No =:ls_po_No, Owner_Id =:ll_Owner_Id, Owner_Cd =:ls_Owner_cd,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = '3PL', Adjustment_Type = 'LOTTABLES'
			where Project_Id =:as_project and WH_Code =:ls_old_wh_code and SKU =:ls_sku and Serial_No =:ls_serial_no
			using sqlca;
			commit;
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Updated Serial No already exist on different warehouse ' +ls_serial_no + ' / '+ls_old_wh_code + '  Action Cd: '+ls_action_cd
			lsLogOut += ' and changed wh code to: '+ls_wh
			FileWrite(giLogFileNo,lsLogOut)
			
		else
			select count(*) into  :ll_count from Serial_Number_Inventory with(nolock) 
			where Project_Id= :as_project and sku= :ls_sku and serial_no= :ls_serial_no and wh_code = :ls_wh 
			using sqlca;
			
// TAM 2019/05 - S33409 - Populate Serial History Table
			If ll_count = 0 Then //DE3082 -Sometimes, Serial No already exist with different location.
				Insert into Serial_Number_Inventory (Project_Id,WH_Code,Owner_Id,Owner_Cd,SKU,Serial_No,Component_Ind,
						Component_No,Update_Date,Update_User,l_code,Lot_No,Po_No,Po_No2, Exp_DT,RO_NO,Inventory_Type, Carton_Id, Serial_Flag, Do_No,
						Transaction_Type ,	Transaction_Id , Adjustment_Type)
				values (:as_project, :ls_wh, :ll_Owner_Id, :ls_owner_cd, :ls_sku, :ls_serial_no, 'N', 0, :ldtToday, 'SIMSFP', :ls_lcode,
						:ls_lot_no, :ls_po_No, :ls_po_No2, :ldt_exp_date, :ls_Ro_No, :ls_Inv_type, :ls_carton_Id, 'N','-',
						'CYCLE_COUNT', '3PL', 'LOTTABLES')
				using sqlca;
				commit;
				
				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Inserted Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
				FileWrite(giLogFileNo,lsLogOut)

			else
// TAM 2019/05 - S33409 - Populate Serial History Table
				update Serial_Number_Inventory set  l_code = :ls_lcode, Po_No =:ls_po_No, Owner_Id =:ll_Owner_Id, Owner_Cd =:ls_Owner_cd,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = '3PL', Adjustment_Type = 'LOTTABLES'
				where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no
				using sqlca;
				commit;

				//Write to File and Screen
				lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Inserted/Updated Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
				FileWrite(giLogFileNo,lsLogOut)
			
			End If
		end If
		
	Next
			
	this.uf_process_cc_remove_recon_filter() //Remove filter
	
	//Filter By Action 'Update'
	//MikeaA - Added 'L' for Moving Location to Unknown. 
	lsFilter = "Action_Cd NOT IN ('I' ,'U', 'D','L')"
	idsCCRecon.setfilter( lsFilter)
	idsCCRecon.filter( )
	ll_filter_count = idsCCRecon.rowcount( )
	
	For ll_row = 1 to ll_filter_count
		ls_action_cd = idsCCRecon.getItemString( ll_row, 'Action_Cd')
		ls_wh = idsCCRecon.getItemString( ll_row, 'WH_Code')
		ll_Owner_Id =idsCCRecon.getItemNumber( ll_row, 'Owner_Id')
		ls_owner_cd =idsCCRecon.getItemString( ll_row, 'Owner_Cd')
		ls_sku = idsCCRecon.getItemString( ll_row, 'SKU')
		ls_serial_no =idsCCRecon.getItemString( ll_row, 'Serial_No')
		ls_lcode= idsCCRecon.getItemString( ll_row, 'l_code')
		ls_lot_No =idsCCRecon.getItemString( ll_row, 'Lot_No')
		ls_po_No =idsCCRecon.getItemString( ll_row, 'Po_No')
		ls_po_No2 = idsCCRecon.getItemString( ll_row, 'Po_No2')
		ldt_exp_date = idsCCRecon.getItemDateTime( ll_row, 'Exp_DT')
		ls_Ro_No =idsCCRecon.getItemString( ll_row, 'RO_NO')
		ls_Inv_Type =idsCCRecon.getItemString( ll_row, 'Inventory_Type')
		ls_carton_Id =idsCCRecon.getItemString( ll_row, 'Carton_Id')
		
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Not Deleted (High Value Item) Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode +'  Action Cd: '+ls_action_cd 
		FileWrite(giLogFileNo,lsLogOut)
		
		select count(*) into :ll_count  from Serial_Number_Inventory with(nolock) 
		where Project_Id =:as_project and wh_code=:ls_wh and sku=:ls_sku and serial_no=:ls_serial_no
		using sqlca;
		
		If ll_count = 0 Then
// TAM 2019/05 - S33409 - Populate Serial History Table
			Insert into Serial_Number_Inventory (Project_Id,WH_Code,Owner_Id,Owner_Cd,SKU,Serial_No,Component_Ind,
						Component_No,Update_Date,Update_User,l_code,Lot_No,Po_No,Po_No2, Exp_DT,RO_NO,Inventory_Type, Carton_Id, Serial_Flag, Do_No,
						Transaction_Type , Transaction_Id , Adjustment_Type)
			values (:as_project, :ls_wh, :ll_Owner_Id, :ls_owner_cd, :ls_sku, :ls_serial_no, 'N', 0, :ldtToday, 'SIMSFP', :ls_lcode,
						:ls_lot_no, :ls_po_No, :ls_po_No2, :ldt_exp_date, :ls_Ro_No, :ls_Inv_type, :ls_carton_Id, 'N','-',
						'CYCLE_COUNT', '3PL', 'LOTTABLES')
			using sqlca;
			commit;
			
			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Inserted (High Value Item) Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
			FileWrite(giLogFileNo,lsLogOut)
			
		else
// TAM 2019/05 - S33409 - Populate Serial History Table
			//update attributes of Serial No
			update Serial_Number_Inventory set  l_code = :ls_lcode, Po_No =:ls_po_No, Owner_Id =:ll_Owner_Id, Owner_Cd =:ls_Owner_cd,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = '3PL', Adjustment_Type = 'LOTTABLES'
			where Project_Id =:as_project and WH_Code =:ls_wh and SKU =:ls_sku and Serial_No =:ls_serial_no
			using sqlca;
			commit;

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_update_serial_records - Updated (High Value Item) Sku/Serial No /Loc: ' +ls_sku +' / '+ls_serial_no + ' / '+ls_lcode + '  Action Cd: '+ls_action_cd
			FileWrite(giLogFileNo,lsLogOut)

		End If
	Next
End IF

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Process of uf_process_cc_update_serial_records '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function boolean uf_process_cc_check_serial_no_exists (string as_project, string as_wh, string as_sku, string as_serial_no);//28-Dec-2017 :Madhu PEVS-806 3PL CC Orders
//check serial No already exists in Serial No Inventory Table or not.

string ls_sql_syntax
long	ll_count
boolean lb_status

Datastore ldsSerial

If not Isvalid(ldsSerial) Then
	ldsSerial = create Datastore
	ldsSerial.dataobject='d_serial_number_inventory'
	ldsSerial.settransobject( SQLCA)
End If

ls_sql_syntax = ldsSerial.getsqlselect( )
ls_sql_syntax +=" where Project_Id ='"+as_project+"'"
ls_sql_syntax +=" and wh_code ='"+as_wh+"'"
ls_sql_syntax +=" and sku ='"+as_sku+"'"
ls_sql_syntax +=" and serial_no ='"+as_serial_no+"'"
ldsSerial.setsqlselect( ls_sql_syntax)
ll_count = ldsSerial.retrieve( )

If ll_count > 0 Then
	lb_status = TRUE
else
	lb_status = FALSE
End If

destroy ldsSerial

return lb_status
end function

public function long uf_process_cc_is_serial_assigned_tono (string as_sku, string as_tono, string as_serial, long al_line_item_no);//28-Dec-2017 :Madhu PEVS-806 3PL CC Order
//check serial No already assigned to To No.

string		sql_syntax, lsErrors, lsLogOut
string 	ls_sku, ls_serial, ls_ToNo
long		ll_count
Datastore ldsAltSerial


sql_syntax=""

ldsAltSerial = create Datastore
sql_syntax = " select * from Alternate_Serial_Capture with(nolock) "
sql_syntax += " where To_No IN ("+as_ToNo+") "
sql_syntax += " and SKU_Parent ='"+as_sku+"' and Serial_No_Parent ='"+as_serial+"'"
sql_syntax += " and To_Line_Item_No ="+string(al_line_Item_No)

ldsAltSerial.create( SQLCA.syntaxfromsql( sql_syntax, "", lsErrors))

IF Len(lsErrors) > 0 THEN
	lsLogOut = "         3PL Cycle Count-  Processing of uf_process_cc_is_serial_assigned_tono()  -Unable to create datastore.~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
	RETURN -1
END IF
	
ldsAltSerial.settransobject( SQLCA)
ll_count = ldsAltSerial.retrieve( )

destroy ldsAltSerial

Return ll_count
end function

public function integer uf_process_oc_sn_om (string as_project, long al_transid, string as_tono);//29-Dec-2017 :Madhu PEVS-806 3PL CC Orders
//Attach Serial No's to OMQ_Inv_Txn_SerNum Table against SOC which is created by 3PL CC.
//Verify, if SOC is created by 3PL CC Order or not. If not, don't attach Serial No's.

string 	ls_uf3, ls_om_sql, sql_syntax, ls_wh, ls_User_Field5, ls_S_Warehouse
string		ls_Tran_Type, ls_Itrn_Key, ls_serialNo, ls_client_id, lsLogOut
long 		ll_Pos, ll_alt_serial_count, ll_Inv_count, ll_InvTxn_row, ll_count, ll_row, ll_serial_row, ll_rc
DateTime ldtToday

Datastore ldsAltSerial, ldsOMQInvTran

//Write to File and Screen
lsLogOut = '      - OM SOC SN - Start Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If Not Isvalid(ldsAltSerial) Then
	ldsAltSerial = create Datastore
	ldsAltSerial.dataobject ='d_alternate_serial_capture'
End If
ldsAltSerial.settransobject( SQLCA)
	
If Not Isvalid(ldsOMQInvTran) Then
	ldsOMQInvTran =create u_ds_datastore
	ldsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
ldsOMQInvTran.settransobject(om_sqlca)

If Not isvalid(idsOMQInvTxnSernum) Then
	idsOMQInvTxnSernum = Create u_ds_datastore
	idsOMQInvTxnSernum.Dataobject = 'd_omq_inventory_txn_sernum'
End If
idsOMQInvTxnSernum.SetTransObject(om_sqlca)


ldsOMQInvTran.reset( )
ldsAltSerial.reset( )
idsOMQInvTxnSernum.reset( )

ldtToday =DateTime(today(), now())

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id= :as_project
using sqlca;

select User_Field3 into :ls_uf3 from Transfer_Master with(nolock) where Project_Id =:as_project and To_No=:as_tono
using sqlca;

ll_Pos = Pos(ls_uf3 , "_")
If ll_Pos > 0 Then ls_uf3 =Left(ls_uf3, ll_Pos -1)

//13-JULY-2018 :Madhu DE5120 - Attach Serial No's to SOC for all CC Types
select B.Wh_Code, count(*) into :ls_wh, :ll_count from CC_Inventory A with(nolock) 
INNER JOIN CC_master B with(nolock) ON A.CC_No =B.CC_No
where B.Project_Id =:as_project and Sequence =:ls_uf3
group by  B.Wh_Code
using sqlca;

//Write to File and Screen
lsLogOut = '      - OM SOC SN - Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono + ' Is SOC created by CC No and Count: '+ nz(string(ll_count), '-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Mikea - 1/14/2020 - Need to add way to trigger process from Adjustment since it didn't come from CC. 

select User_Field5, S_Warehouse into :ls_User_Field5, :ls_S_Warehouse
	from transfer_master with (nolock)
	where to_no = :as_tono using sqlca; 

IF trim(ls_User_Field5) =  'ADJ' then 
	ll_count = 1
	ls_wh = ls_S_Warehouse
End IF

If ll_count > 0 Then
	//Get Alternate Serial Capture Records
	sql_syntax = ldsAltSerial.getsqlselect( )
	sql_syntax +=" where To_No ='"+as_tono+"'"
	ldsAltSerial.setsqlselect( sql_syntax)
	ll_alt_serial_count = ldsAltSerial.retrieve( )
	
	//Write to File and Screen
	lsLogOut = '      - OM SOC SN - Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono + ' SOC Serial Records Count: '+ nz(string(ll_alt_serial_count), '-')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	If ll_alt_serial_count > 0 Then
		//Get Respective Inventory Transactions
		ls_om_sql =ldsOMQInvTran.getsqlselect( )
		ls_om_sql +=" WHERE RECEIPTKEY ='"+Right(as_tono, 10)+"'"
		ls_om_sql +=" AND SOURCETYPE ='ntrTransferDetailAdd' "
		ldsOMQInvTran.setsqlselect( ls_om_sql)
		ll_Inv_count = ldsOMQInvTran.retrieve( )

		For ll_row =1 to ll_Inv_count
			ls_Tran_Type =ldsOMQInvTran.getItemString( ll_row, 'TRANTYPE')
			ls_Itrn_Key =  ldsOMQInvTran.getItemString( ll_row, 'ITRNKEY')
			
			For ll_serial_row = 1 to ll_alt_serial_count
				ls_serialNo = ldsAltSerial.getItemString( ll_serial_row, 'Serial_No_Parent')
				
				//Write to File and Screen
				lsLogOut = '      - OM SOC SN - Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono + ' Attaching Serial No: '+nz(ls_serialNo ,'-')
				lsLogOut +=' to ItrnKey: '+nz(ls_Itrn_Key, '-') + ' of Trans Type: '+nz(ls_Tran_Type ,'-')
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)

				//Write OMQ_Inventory_Txn_Sernum Record
				ll_InvTxn_row = idsOMQInvTxnSernum.insertrow( 0)
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QADDWHO', 'SIMSUSER') //Add Who
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QACTION', 'I') //Action
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QWMQID', al_transId) //Set with Batch_Transaction.Id_No
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SITE_ID', ls_wh) //site id
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITWHO', 'SIMSUSER') //Add who
			
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'CLIENT_ID', ls_client_Id)
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNKEY', ls_Itrn_Key)
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNSERIALKEY', '1')
				idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ls_serialNo)
			Next
		Next
	End If
End If

//storing into DB
If idsOMQInvTxnSernum.rowcount( ) > 0 Then 	
	Execute Immediate "Begin Transaction" using om_sqlca;

	ll_rc =idsOMQInvTxnSernum.update( false, false);	//OMQ_INVENTORY_TXN_SERNUM
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTxnSernum.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQInvTxnSernum.reset( )
			
			//Write to File and Screen
			lsLogOut = '      - OM SOC SN - Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText+ ' Error Code: '+string(om_sqlca.sqlcode)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//Write to File and Screen
		lsLogOut = '      - OM SOC SN - Processing Serial No Record of uf_process_oc_sn_om() for To_No: ' + as_tono +" is failed to write/update OM Tables:   System error, record save failed!"
		lsLogOut += ' Error Msg: '+ nz(om_sqlca.SQLErrText ,'-') + ' Error Code: '+string(om_sqlca.sqlcode)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
End If

destroy ldsAltSerial
destroy ldsOMQInvTran
destroy idsOMQInvTxnSernum

//Write to File and Screen
lsLogOut = '      - OM SOC SN - End Processing Serial No Records of uf_process_oc_sn_om() for To_No: ' + as_tono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function long uf_process_cc_reconcile_swap_serial_loc (string as_project, string as_ccno);//29-DEC-2017 :Madhu PEVS-806 3PL Cycle Count Order

string		sql_syntax, lsLogOut, lsErrors, ls_lcode, ls_find, ls_formatted_sku, ls_sku, ls_sku_list[], ls_new_sql_syntax, ls_ord_status, ls_serial_loc, ls_po_no
string		ls_cc_sku, ls_cc_lcode, ls_cc_serialno, ls_serial_list[], ls_formatted_serials, ls_sku_prev, ls_supp_code, ls_owner_cd, ls_Orig_sql, lsFind, lsTransParm
string		ls_lotno, ls_pono, ls_pono2, ls_rono, ls_InvType, ls_old_serial_No, ls_serialno, ls_prev_lcode, ls_loc_list[], ls_formatted_locs, ls_wh, ls_ord_type
long		ll_count, ll_row, ll_scan_count, ll_ownerId, ll_sni_count, ll_find_row, ll_remain_count, llFindRow
datetime	ldt_expdate, ldtToday

datastore     ldsCCScanSN, ldsSNI, ldsCCInv

SetPointer(Hourglass!)

ldtToday = DateTime(today(), now())

If not IsValid(ldsSNI) Then
	ldsSNI =create Datastore
	ldsSNI.dataobject='d_serial_number_inventory'
	ldsSNI.settransobject( SQLCA)
End If

If Not isvalid(ldsCCInv) Then
	ldsCCInv = Create Datastore
	ldsCCInv.Dataobject = 'd_cc_inventory'
	ldsCCInv.SetTransObject(SQLCA)
End If

ldsCCInv.retrieve(as_ccno)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_reconcile_swap_serial_loc() - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//get a list of SKU's against CC No from CC_Serial_Numbers Table
ldsCCScanSN = create Datastore
sql_syntax =" select * from CC_Serial_Numbers  with(nolock) where cc_no ='"+as_ccno+"'"
ldsCCScanSN.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))
ldsCCScanSN.settransobject( SQLCA)

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore for PANDORA 3PL System Cycle Count Orders .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ll_scan_count= ldsCCScanSN.retrieve( )

//get list of Scanned Serial No's
For ll_row =1 to ll_scan_count
	ls_serialno = ldsCCScanSN.getItemString( ll_row, 'serial_no')
	ls_serial_list[ UpperBound(ls_serial_list) + 1 ] = ls_serialno
Next

If UpperBound(ls_serial_list) > 0 Then ls_formatted_serials = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 ) //formatted Serial No's.

//get list of Scanned Sku's
For ll_row =1 to ll_scan_count
	ls_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
	If ls_sku_prev <> ls_sku Then 	
		ls_sku_list[ UpperBound(ls_sku_list) + 1 ] = ls_sku
		ls_sku_prev =ls_sku
	End If
Next

If UpperBound(ls_sku_list) > 0 Then ls_formatted_sku = in_string_util.of_format_string( ls_sku_list, n_string_util.FORMAT1 ) //formatted SKU's.

//get list of Location's
For ll_row =1 to ll_scan_count
	ls_lcode = ldsCCScanSN.getItemString( ll_row, 'l_code')
	If ls_prev_lcode <> ls_lcode Then ls_loc_list[ UpperBound(ls_loc_list) + 1 ] = ls_lcode
	ls_prev_lcode = ls_lcode
Next

If UpperBound(ls_loc_list) > 0 Then ls_formatted_locs = in_string_util.of_format_string( ls_loc_list, n_string_util.FORMAT1 ) //format Locations

select wh_code into :ls_wh from CC_Master with(nolock) where Project_Id =:as_project and CC_No =:as_ccno using sqlca;

If ll_scan_count > 0 Then
	//create Serial Number Inventory Records datastore
	ls_Orig_sql = ldsSNI.getsqlselect( )
	sql_syntax = ls_Orig_sql
	sql_syntax +=" where Project_Id ='"+as_project+"'"
	sql_syntax +=" and wh_code ='"+ls_wh+"'"
	sql_syntax +=" and sku IN ("+ls_formatted_sku+")"
	ldsSNI.setsqlselect( sql_syntax)
	ldsSNI.retrieve( )

	FOR ll_row =1 to ll_scan_count
		
		ls_cc_sku = ldsCCScanSN.getItemString( ll_row, 'sku')
		ls_cc_lcode = ldsCCScanSN.getItemString( ll_row, 'l_code')
		ls_cc_serialNo = ldsCCScanSN.getItemString( ll_row, 'serial_no')
		
//		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
//		uf_check_serial_number_exist(as_project, 'CYCLE_COUNT-Reconcile Swap', ls_wh, ls_cc_lcode, ls_cc_sku, ls_cc_serialNo)	
//		
		//Find a record with Location and Serial No combination
		ls_find =" l_code ='"+ls_cc_lcode+"' and serial_no ='"+ls_cc_serialNo+"'"
		ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())

		If ll_find_row = 0 Then //No Record found
			
			//Find a record with  Serial No -> Location Mismatch
			ls_find =" serial_no ='"+ls_cc_serialNo+"'"
			ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())

			//If found SN against different location, swap locations b/w serial No's
			If ll_find_row >  0 THEN 
				ls_lcode =ldsSNI.getItemstring(ll_find_row ,'l_code') //different loc from SNI
				
				ls_find =" l_code ='"+ls_cc_lcode+"'"
				ll_find_row = ldsSNI.find( ls_find, 1, ldsSNI.rowcount())

				If ll_find_row > 0 Then 	
					ls_serial_loc =ldsSNI.getItemstring(ll_find_row ,'serial_no') //associated SN
	
					lsFind = "sku ='"+ls_cc_sku+"' and l_code ='"+ls_cc_lcode+"'"
					llFindRow = ldsCCInv.find( lsFind, 1, ldsCCInv.rowcount())
					IF llFindRow > 0 Then ls_po_no = ldsCCInv.getItemString( llFindRow, 'po_no')
					
					IF IsNull(ls_po_no) or ls_po_no='' or ls_po_no= ' ' Then ls_po_no = ldsSNI.getItemstring(ll_find_row ,'po_no')
					
					//Write to File and Screen
					lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_reconcile_swap_serial_loc - updating Location From: '+ls_lcode+' To: '+ls_cc_lcode+' -sku/serial No /PoNo: '+ ls_cc_sku +' / '+ ls_cc_serialNo+ ' / '+ls_po_no+ ' -CC_No: '+as_ccno
					FileWrite(giLogFileNo,lsLogOut)
					//gu_nvo_process_files.uf_write_log(lsLogOut)
					
					
					//Dec 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
					//Create CycleCount for Sku\Location
					select ord_type INTO :ls_ord_type  from cc_master with (nolock) where cc_no = :as_ccno using sqlca;
				
					if ls_ord_type = "F" AND ls_lcode <> 'UNKNOWN'  then
			
						//Create batch_transaction record for Serial Number Rec
						
						//Position in Trans Parm
						//WH_Code = 1-10
						//L_Code = 12-21
						//Sku = 23 -
				
						//		ls_WhCode = mid(lsTrans_parm, 1, 10)
						//		ls_LCode = mid( lsTrans_parm, 12, 10)
						//		ls_Sku = mid(lsTrans_parm , 23)
								
								lsTransParm = ls_wh + space(10 - len(ls_wh)) + ":" + ls_lcode + space(10 - len(ls_lcode)) + ":" + ls_cc_sku
								
						//llAdjustID
				
						ldtToday = f_getLocalWorldTime( ls_wh ) 
						
						Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
									Values(:as_project, 'SRCC', :as_ccno,'N', :ldtToday, :lsTransParm)
						Using SQLCA;		

								
					end if	
					
					
// TAM 2019/05 - S33409 - Populate Serial History Table
			//update Location on Serial Number Inventory Table (Swap serial No's).
					update Serial_Number_Inventory set l_code =:ls_cc_lcode, Update_User='SIMSFP', Po_No =:ls_po_no,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno , Adjustment_Type = 'LOCATION SWAP'
					where Project_Id= :as_project	and wh_code=:ls_wh and sku = :ls_cc_sku  and serial_no=:ls_cc_serialNo 
					using sqlca;
					commit;
			
					lsFind = "sku ='"+ls_cc_sku+"' and l_code ='"+ls_lcode+"'"
					llFindRow = ldsCCInv.find( lsFind, 1, ldsCCInv.rowcount())
					IF llFindRow > 0 Then ls_po_no = ldsCCInv.getItemString( llFindRow, 'po_no')
					
					IF IsNull(ls_po_no) or ls_po_no='' or ls_po_no= ' ' Then ls_po_no = ldsSNI.getItemstring(ll_find_row ,'po_no')
					
// TAM 2019/05 - S33409 - Populate Serial History Table
					//update Location on Serial Number Inventory Table (Swap serial No's).
					update Serial_Number_Inventory set l_code =:ls_lcode, Update_User='SIMSFP',  Po_No =:ls_po_no,
					Transaction_Type = 'CYCLE_COUNT',	Transaction_Id = :as_ccno , Adjustment_Type = 'LOCATION SWAP'
					where Project_Id= :as_project	and wh_code=:ls_wh and sku = :ls_cc_sku  and serial_no=:ls_serial_loc 
					using sqlca;
					commit;
					
					//re-reteive SNI records
					ldsSNI.reset( )
					ldsSNI.setsqlselect( sql_syntax)
					ldsSNI.settransobject( SQLCA)
					ll_sni_count = ldsSNI.retrieve( )

				End If				
			End IF
		 End IF
	NEXT
  End IF

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_reconcile_swap_serial_loc() - CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCInv
destroy ldsSNI
destroy ldsCCScanSN

Return 0
end function

public function long uf_process_cc_auto_create_soc_serialized (string as_project, string as_cc_no, string as_sku, long al_owner_id, string as_pono);//20-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders.

string		lsFind, lsOwner_Cd, lsReasonCd, lsOrdStatus, ls_supp_code, lsLogOut, ls_cc_class_Code
string		ls_sku, ls_pono, ls_lcode, ls_req_SN, ls_trans_parm, ls_wh, ls_sequence, ls_sql_syntax, lsFilter
long		llRowCount, llFindRow, llNewRow, llRowPos, ll_row, ll_return
long		ll_Qty, ll_Qty_Count, ll_Qty_Up, ll_Qty_Down, ll_high_volume, ll_cc_line
double	ldBatchSeq, ldQty, ldQtyCount
datetime ldtCountDate

Str_Parms  ls_soc_parms

Datastore ldsCCDetail, ldsCC_Out, ldsCCMaster
n_cc_utils ln_cc_utils

SetPointer(HourGlass!)

If Not isvalid(ldsCCMaster) Then
	ldsCCMaster = Create Datastore
	ldsCCMaster.Dataobject = 'd_cc_master'
	ldsCCMaster.SetTransObject(SQLCA)
End If

If Not Isvalid(ldsCCDetail) Then
	ldsCCDetail =create Datastore
	ldsCCDetail.dataobject='d_cc_inventory'
	ldsCCDetail.settransobject( SQLCA)
End IF

If Not isvalid(ldsCC_Out) Then
	 //datastore to capture rolled-up cc_inventory records to be written to ldsOUT
	 ldsCC_Out = Create Datastore
	 ldsCC_Out.Dataobject = 'd_cc_inventory'
End If

ldsCCMaster.reset( )
ldsCCDetail.reset( )

ldsCCMaster.retrieve( as_cc_no)
ldsCCDetail.Retrieve(as_cc_no)
llRowCount = ldsCCDetail.retrieve( )

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_auto_create_soc_serialized()  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ln_cc_utils = CREATE n_cc_utils
ln_cc_utils.uf_spread_rolled_up_si_counts( ldsCCDetail )

ls_wh = ldsCCMaster.getItemstring( 1, 'wh_code')

llRowCount = ldsCCDetail.RowCount()

//Apply filter with combination of SKU, Owner and Project code against Rolled Up Records.
lsFilter = "upper(sku) = '" + upper(as_sku) + "'"
lsFilter += " and owner_id = " + string(al_owner_id) + ""
lsFilter += " and upper(po_no) = '" + upper(as_pono) + "'"
ldsCCDetail.setfilter(lsFilter)
ldsCCDetail.filter( )
llRowCount = ldsCCDetail.RowCount()

For llRowPos = 1 to llRowCount
	// Rolling up to Sku/Owner/Project...
	lsFind = "upper(sku) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'SKU')) + "'"
	lsOwner_Cd = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd')
	lsFind += " and owner_owner_cd = '" + lsOwner_Cd + "'"
	lsFind += " and upper(po_no) = '" + upper(ldsCCDetail.GetItemString(llRowPos, 'po_no')) + "'"
	
	llFindRow = ldsCC_Out.Find(lsFind, 1, ldsCC_Out.RowCount())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
		if isNull(ldQtyCount) or ldQtyCount = 0 then
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
		end if
		if isNull(ldQtyCount) or ldQtyCount = 0 then
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
		end if
		if isNull(ldQtyCount) then
			ldQtyCount = 0
		end if
		
		ldsCC_Out.SetItem(llFindRow,'result_1', ldsCC_Out.GetItemNumber(llFindRow, 'result_1') + ldQtyCount)
		ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
		if isNull(ldQty) then
			ldQty = 0
		end if
		ldsCC_Out.SetItem(llFindRow,'quantity', ldsCC_Out.GetItemNumber(llFindRow, 'quantity') + ldQty)
		lsReasonCd = ldsCC_Out.GetItemString(llFindRow, 'reason')
		if NoNull(lsReasonCd) = '' then
			lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
			if NoNull(lsReasonCd) <> '' then
			  ldsCC_Out.SetItem(llFindRow, 'reason', lsReasonCd)
			end if
		end if
	Else /*not found, add a new record*/
		llNewRow = ldsCC_Out.InsertRow(0)
		ldsCC_Out.SetItem(llNewRow, 'sku', ldsCCDetail.GetItemString(llRowPos, 'sku'))
		ldsCC_Out.SetItem(llNewRow, 'po_no', ldsCCDetail.GetItemString(llRowPos, 'po_no'))
		ldsCC_Out.SetItem(llNewRow, 'owner_owner_cd', ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd'))
		ldsCC_Out.SetItem(llNewRow, 'owner_id', ldsCCDetail.GetItemNumber(llRowPos, 'owner_id'))
		ldsCC_Out.SetItem(llNewRow, 'sequence', ldsCCDetail.GetItemString(llRowPos, 'sequence'))
	
		ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_3')
		if ldQtyCount > 0 then
			ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count3_complete')
		else
			ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_2')
			if ldQtyCount > 0 then
				 ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count2_complete')
			else
				 ldQtyCount = ldsCCDetail.GetItemNumber(llRowPos, 'Result_1')
				 if ldQtyCount > 0 then
					  ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'count1_complete')
				 else
					  ldtCountDate = ldsCCMaster.GetItemDateTime(1, 'complete_date')
				 end if
			end if //Result_2 > 0
		end if //Result_3 > 0

		if isNull(ldQtyCount) then
			ldQtyCount = 0
		end if
		ldsCC_Out.SetItem(llNewRow, 'result_1', ldQtyCount) // using result_1 to hold result1, 2, or 3 as appropriate
		ldQty = ldsCCDetail.GetItemNumber(llRowPos, 'quantity')
		if isNull(ldQty) then
			ldQty = 0
		end if
		ldsCC_Out.SetItem(llNewRow,'quantity', ldQty)
		ldsCC_Out.SetItem(llNewRow, 'expiration_date', ldtCountDate) // just using expiration_date to hold the Count Date
		lsReasonCd = ldsCCDetail.GetItemString(llRowPos, 'reason')
		ldsCC_Out.SetItem(llNewRow,'reason', lsReasonCd)
		
	End If // New Record

	ls_soc_parms.string_arg[1] = ldsCCDetail.GetItemString(llRowPos, 'sku')
	ls_soc_parms.string_arg[2] = ldsCCDetail.GetItemString(llRowPos, 'supp_Code')
	ls_soc_parms.string_arg[3] = ls_wh
	ls_soc_parms.string_arg[4] = ldsCCDetail.GetItemString(llRowPos, 'L_Code')
	ls_soc_parms.string_arg[5] = ldsCCDetail.GetItemString(llRowPos, 'Inventory_Type')
	ls_soc_parms.string_arg[6] =ldsCCDetail.GetItemString(llRowPos, 'Lot_No')
	ls_soc_parms.string_arg[7] =ldsCCDetail.GetItemString(llRowPos, 'PO_No')
	ls_soc_parms.string_arg[8] =ldsCCDetail.GetItemString(llRowPos, 'PO_No2')
	ls_soc_parms.string_arg[9] = ldsCCDetail.GetItemString(llRowPos, 'Country_of_Origin')
	ls_soc_parms.string_arg[10] = ldsCCDetail.GetItemString(llRowPos, 'owner_owner_cd')
	ls_soc_parms.string_arg[11] = ldsCCDetail.GetItemString(llRowPos, 'Ro_No')
	ls_sequence = ldsCCDetail.GetItemString(llRowPos, 'sequence')
	
	//10-JULY-2018 :Madhu DE5038 - Assign right-6-chars of CCNo, if Sequence value is NULL /Empty
	If isNull(ls_sequence) or ls_sequence='' or ls_sequence =' ' Then
		ls_sequence = Right(as_cc_no, 6)
	End If
	
	ls_soc_parms.string_arg[13] = as_cc_no
	ls_soc_parms.string_arg[14] = ldsCCDetail.GetItemString(llRowPos, 'Container_ID')
	
	ls_soc_parms.long_arg[1] = ldsCCDetail.GetItemNumber(llRowPos, 'Owner_ID')
	ls_soc_parms.long_arg[2] = ldsCCDetail.GetItemNumber(llRowPos, 'line_item_no')
	
	ll_Qty =long(ldQty)
	ll_Qty_Count = long(ldQtyCount)

	ll_Qty_Up = ll_Qty_Count - ll_Qty
	ll_Qty_Down = ll_Qty - ll_Qty_Count

	ls_soc_parms.long_arg[3] = ll_Qty
	ls_soc_parms.long_arg[4] = ll_Qty_Count
	
	ls_soc_parms.datetime_arg[1] = ldsCCDetail.GetItemDateTime(llRowPos, 'expiration_date')
	
	ll_cc_line = 	ls_soc_parms.long_arg[2]
	ls_sku = ldsCCDetail.GetItemString(llRowPos, 'sku')
	ls_supp_code = ldsCCDetail.GetItemString(llRowPos, 'supp_code')

	ls_soc_parms.string_arg[12] = ls_sequence+'_'+string(ll_cc_line)
	
	//creating SOC for Down Counts
	IF ldQty > ldQtyCount and lsOrdStatus <> 'V'  THEN
			ls_soc_parms.long_arg[5] = ll_Qty_Down
			
			SELECT count(*) into :ll_high_volume 
			FROM Item_Master A with(nolock) 
			INNER JOIN Commodity_Codes B with(nolock) ON A.User_Field5 = B.Commodity_Cd
			WHERE A.Project_Id =:as_project and A.sku =:ls_sku and A.Supp_code =:ls_supp_code
			using sqlca;
			
			select CC_Class_Code into :ls_cc_class_Code from Item_Master with(nolock) 
			where Project_Id =:as_project and sku =:ls_sku and Supp_code =:ls_supp_code
			using sqlca;
			
			IF (ll_high_volume > 0 OR upper(ls_cc_class_Code) ='A' )THEN
				ls_soc_parms.boolean_arg[1] = TRUE //High Value Item - Don't do Auto QTY Adjustment
			else
				ls_soc_parms.boolean_arg[1] = FALSE //Not High Value Item - Do Auto QTY Adjustment
			END IF

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_create_soc_serialized()  - Down Count for  CC_No: '+as_cc_no +' - sku: '+ls_sku
			lsLogOut += ' - CC Line No: ' +string(ll_cc_line) +' - Qty: '+string(ll_Qty) +' - Result Qty: '+string(ll_Qty_Count) +' - High Value Item: ' +string(ll_high_volume)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			//Auto confirm SOC
			ll_return = this.uf_process_cc_auto_confirm_soc( as_project, ls_soc_parms)

			//Stock Adjustment
			ll_return = this.uf_process_cc_stock_adjustment( as_project, ls_soc_parms)
			
	END IF
	
	//UP Counts
	IF ldQty < ldQtyCount and lsOrdStatus <> 'V'  THEN

			//Write to File and Screen
			lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_create_soc_serialized()  - UP Count for  CC_No: '+as_cc_no +' - sku: '+ls_sku
			lsLogOut += ' - CC Line No: ' +string(ll_cc_line) +' - Qty: '+string(ll_Qty) +' - Result Qty: '+string(ll_Qty_Count)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			ls_soc_parms.long_arg[5] = ll_Qty_Up
			ls_soc_parms.boolean_arg[1] = FALSE
			
			//stock Adjustment
			ll_return =this.uf_process_cc_stock_adjustment( as_project, ls_soc_parms)

	END IF

Next

ldsCCDetail.setfilter( "")
ldsCCDetail.filter( )
ldsCCDetail.rowcount()

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_auto_create_soc_serialized()  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCMaster
destroy ldsCCDetail
destroy ldsCC_Out

Return ll_return
end function

public function long uf_process_cc_serial_check_variance (string as_project, string as_ccno);//29-Dec-2017 :Madhu PEVS-806 3PL CC Order
//check, if CC Order is varianced or not?

string	ls_sku, ls_owner_cd, ls_po_no, lsLogOut
long 	ll_rowcount, ll_owner_Id, ll_sys_qty, ll_difference
long	ll_Result1, ll_Result2, ll_Result3, ll_row

Datastore ldsCCSerialInv

SetPointer(HourGlass!)

If not Isvalid(ldsCCSerialInv) Then
	ldsCCSerialInv =create Datastore
	ldsCCSerialInv.dataobject ='d_cc_inventory_serial_difference'
	ldsCCSerialInv.settransobject( SQLCA)
End If

ll_rowcount = ldsCCSerialInv.retrieve( as_ccno)

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_serial_check_variance()  and CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row =1 to  ll_rowcount
	ls_sku = ldsCCSerialInv.getItemString( ll_row, 'sku')
	ll_owner_Id =	ldsCCSerialInv.getItemNumber( ll_row, 'owner_Id')
	ls_owner_cd =	ldsCCSerialInv.getItemString(ll_row, 'owner_cd')
	ls_po_no =	ldsCCSerialInv.getItemString(ll_row, 'po_no')
	ll_sys_qty = ldsCCSerialInv.getItemNumber( ll_row, 'sys_qty')
	ll_difference = ldsCCSerialInv.getItemNumber( ll_row, 'difference')
	ll_Result1 = ldsCCSerialInv.getItemNumber( ll_row, 'result_1')
	ll_Result2 = ldsCCSerialInv.getItemNumber( ll_row, 'result_2')
	ll_Result3 = ldsCCSerialInv.getItemNumber( ll_row, 'result_3')

	If ll_difference =  0 Then
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_check_variance()  and CC_No: '+as_ccno
		lsLogOut += ' No Variance Found - against  sku: '+ls_sku+' Owner Id: '+ string(ll_owner_Id)+' Po No: '+ls_po_no
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	else
		//Write to File and Screen
		lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_serial_check_variance()  and CC_No: '+as_ccno
		lsLogOut += ' Variance Found - against  sku: '+ls_sku+' Owner Id: '+ string(ll_owner_Id)+' Po No: '+ls_po_no
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		this.uf_process_cc_auto_create_soc_serialized( as_project, as_ccno, ls_sku, ll_owner_Id, ls_po_no)		
	End If
Next

destroy ldsCCSerialInv

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_serial_check_variance()  and CC_No: '+as_ccno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function string uf_get_next_dummy_serialno ();//30-Dec-2017 :Madhu PEVS-806 3PL CC Orders

string ls_dummy_SN
long ll_Next_Seq_No

ll_Next_Seq_No = gu_nvo_process_files.uf_get_next_seq_no('PANDORA', 'DUMMY_SERIAL_NO', 'SEQ_NO')
ls_dummy_SN ='DUMMY'+string(ll_Next_Seq_No)
Return ls_dummy_SN
end function

public function boolean uf_is_sku_foot_print (string asproject, string assku, string assuppcode);//10-MAY-2018 :Madhu S19289 SIMS Mapping of Container ID for Footprints
//determine whether SKU is Foot Print or Not?

//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
//Use Foot_Prints_Ind Flag

string ls_serialized_ind,  ls_po_no2_ind, ls_container_ind, ls_Foot_Prints_Ind

SELECT Serialized_Ind, Po_No2_Controlled_Ind, Container_Tracking_Ind, Foot_Prints_Ind
INTO :ls_serialized_ind, :ls_po_no2_ind, :ls_container_ind, :ls_Foot_Prints_Ind
FROM  Item_Master with(nolock) 
WHERE Project_Id =:asproject and sku= :assku and supp_code=:assuppcode
using SQLCA;


//If upper(ls_serialized_ind) ='B' and upper(ls_po_no2_ind) ='Y' and upper(ls_container_ind) ='Y' Then
If upper(ls_Foot_Prints_Ind) ='Y' Then
	Return True
Else
	Return False
End IF
end function

public function integer uf_process_gi_om_pallet_construct (integer al_attr_row, long aitransid, string as_client_id, string asdono, string as_wh, decimal ad_pallet_qty, string as_carton_no, string as_ref_char4, long al_pack_row);//11-MAY-2018 :Madhu S19289 Google - Footprints - SIMS Mapping of Container ID for Footprints and Deja Vu
//Pallet Construction

DateTime ldtToday	
ldtToday = DateTime(Today(), Now())

idsOMQWhDOAttr.setitem(al_attr_row, 'QACTION','U')
idsOMQWhDOAttr.setitem(al_attr_row, 'QSTATUS','NEW')
idsOMQWhDOAttr.setitem(al_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
idsOMQWhDOAttr.setitem(al_attr_row, 'QWMQID',aitransid)

idsOMQWhDOAttr.setitem(al_attr_row, 'CLIENT_ID', long(as_client_id))
idsOMQWhDOAttr.setitem(al_attr_row, 'SITE_ID', as_wh)
idsOMQWhDOAttr.setitem(al_attr_row, 'ORDERKEY', Right(asdono, 10))

idsOMQWhDOAttr.setitem(al_attr_row, 'ATTR_ID', Right(as_carton_No,9)+'P')
idsOMQWhDOAttr.setitem(al_attr_row, 'ATTR_TYPE','PALLETLEVEL') 
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM1',ad_pallet_qty) //Pallet Qty

idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR3', as_carton_No)
idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR4', as_ref_char4)
idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR5','LB')

idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM2', idsDOpack.GetItemNumber(al_pack_row, 'Weight_Gross')) //Weight_Gross
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM3', idsDOpack.GetItemNumber(al_pack_row, 'height') ) //height
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM4', idsDOpack.GetItemNumber(al_pack_row, 'length')) //length
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM5', idsDOpack.GetItemNumber(al_pack_row, 'width')) //width

idsOMQWhDOAttr.setitem(al_attr_row, 'ADDDATE', ldtToday)
idsOMQWhDOAttr.setitem(al_attr_row, 'ADDWHO','SIMSUSER')
idsOMQWhDOAttr.setitem(al_attr_row, 'EDITDATE', ldtToday)
idsOMQWhDOAttr.setitem(al_attr_row, 'EDITWHO','SIMSUSER')

Return 0
end function

public function integer uf_process_gi_om_carton_construct (integer al_attr_row, long aitransid, string as_client_id, string asdono, string as_wh, decimal ad_carton_qty, string as_carton_no, string as_ref_char4, long al_pack_row);//11-MAY-2018 :Madhu S19289 Google - Footprints - SIMS Mapping of Container ID for Footprints and Deja Vu
//Carton Construction

DateTime ldtToday	
ldtToday = DateTime(Today(), Now())

idsOMQWhDOAttr.setitem(al_attr_row, 'QACTION','U')
idsOMQWhDOAttr.setitem(al_attr_row, 'QSTATUS','NEW')
idsOMQWhDOAttr.setitem(al_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
idsOMQWhDOAttr.setitem(al_attr_row, 'QWMQID',aitransid)

idsOMQWhDOAttr.setitem(al_attr_row, 'CLIENT_ID', long(as_client_id))
idsOMQWhDOAttr.setitem(al_attr_row, 'SITE_ID', as_wh)
idsOMQWhDOAttr.setitem(al_attr_row, 'ORDERKEY', Right(asdono, 10))


//Carton Construct
idsOMQWhDOAttr.setitem(al_attr_row, 'ATTR_ID', Right(as_carton_No,9)+'C')
idsOMQWhDOAttr.setitem(al_attr_row, 'ATTR_TYPE','CARTONLEVEL') 
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM1',ad_carton_qty) //Carton Qty

idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR3', as_carton_No)
idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR4', as_ref_char4)
idsOMQWhDOAttr.setitem(al_attr_row, 'REFCHAR5','LB')

idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM2', idsDOpack.GetItemNumber(al_pack_row, 'Weight_Gross')) //Weight_Gross
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM3', idsDOpack.GetItemNumber(al_pack_row, 'height') ) //height
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM4', idsDOpack.GetItemNumber(al_pack_row, 'length')) //length
idsOMQWhDOAttr.setitem(al_attr_row, 'REFNUM5', idsDOpack.GetItemNumber(al_pack_row, 'width')) //width

idsOMQWhDOAttr.setitem(al_attr_row, 'ADDDATE', ldtToday)
idsOMQWhDOAttr.setitem(al_attr_row, 'ADDWHO','SIMSUSER')
idsOMQWhDOAttr.setitem(al_attr_row, 'EDITDATE', ldtToday)
idsOMQWhDOAttr.setitem(al_attr_row, 'EDITWHO','SIMSUSER')

Return 0
end function

public function decimal uf_get_pallet_carton_qty (string asfind);//11-MAY-2018 :Madhu S19289 -Google - Footprints - SIMS Mapping of Container ID for Footprints and Deja Vu
//get Pallet / Carton Quantity

long llFindRow
Decimal ld_Pallet_Carton_Qty

ld_Pallet_Carton_Qty =0

llFindRow = idsDOpack.find( asfind, 0, idsDOpack.rowcount())

DO WHILE llFindRow > 0
	ld_Pallet_Carton_Qty +=idsDOpack.GetItemNumber(llFindRow, 'Quantity')
	
	llFindRow++
	If llFindRow > idsDOpack.rowcount() Then
		llFindRow=0
	else
		llFindRow = idsDOpack.find( asfind, llFindRow, idsDOpack.rowcount())
	end if
	
LOOP

Return ld_Pallet_Carton_Qty
end function

public function integer uf_create_up_count_zero_inbound_detail (string as_ro_no);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Receive Detail Records

string lsLogOut, ls_alt_sku
long ll_row, ll_detail_row

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_detail  and  Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row =1 to ids_CC_UpCountZero_Result.rowcount( )
		
		ll_detail_row= ids_ro_detail.insertrow( 0)
		
		ids_ro_detail.setItem( ll_detail_row, 'Ro_No', as_ro_no)
		ids_ro_detail.setItem( ll_detail_row, 'sku',  ids_CC_UpCountZero_Result.getItemString( ll_row, 'sku'))
		ids_ro_detail.setItem( ll_detail_row, 'Line_item_no', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'line_item_no'))
		ids_ro_detail.setItem( ll_detail_row, 'Req_Qty', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'quantity'))
		ids_ro_detail.setItem( ll_detail_row, 'Alloc_Qty', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'quantity'))
		ids_ro_detail.setItem( ll_detail_row, 'uom', ids_CC_UpCountZero_Result.getItemString( ll_row, 'uom_1'))
		ids_ro_detail.setItem( ll_detail_row, 'Supp_Code', ids_CC_UpCountZero_Result.getItemString( ll_row, 'supp_code'))
		ids_ro_detail.setItem( ll_detail_row, 'Owner_id', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'owner_id'))
		ids_ro_detail.setItem( ll_detail_row, 'Country_of_Origin', ids_CC_UpCountZero_Result.getItemString( ll_row, 'country_of_origin'))
		
		ls_alt_sku = ids_CC_UpCountZero_Result.getItemString( ll_row, 'alternate_sku')
		If isnull(ls_alt_sku) or ls_alt_sku ='' Then
			ids_ro_detail.setItem( ll_detail_row, 'Alternate_SKU', ids_CC_UpCountZero_Result.getItemString( ll_row, 'sku'))
		else
			ids_ro_detail.setItem( ll_detail_row, 'Alternate_SKU', ls_alt_sku)
		End If
Next

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_detail  and  Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function integer uf_create_up_count_zero_inbound_putaway (string as_ro_no);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Receive Putaway Records

string lsLogOut
long ll_row, ll_putaway_row

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_putaway  and  Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row =1 to ids_CC_UpCountZero_Result.rowcount( )
	
	ll_putaway_row= ids_ro_putaway.insertrow( 0)
	
	ids_ro_putaway.setItem( ll_putaway_row, 'ro_no', as_ro_no)
	ids_ro_putaway.setItem( ll_putaway_row, 'sku', ids_CC_UpCountZero_Result.getItemString( ll_row, 'sku'))
	ids_ro_putaway.setItem( ll_putaway_row, 'supp_code', ids_CC_UpCountZero_Result.getItemString( ll_row, 'supp_code'))
	ids_ro_putaway.setItem( ll_putaway_row, 'country_of_origin', ids_CC_UpCountZero_Result.getItemString( ll_row, 'country_of_origin'))
	ids_ro_putaway.setItem( ll_putaway_row, 'inventory_Type', ids_CC_UpCountZero_Result.getItemString( ll_row, 'inventory_Type'))
	ids_ro_putaway.setItem( ll_putaway_row, 'owner_id', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'owner_id'))
	ids_ro_putaway.setItem( ll_putaway_row, 'line_item_no', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'line_item_no'))
	ids_ro_putaway.setItem( ll_putaway_row, 'user_line_item_no', string(ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'line_item_no')))
	ids_ro_putaway.setItem( ll_putaway_row, 'quantity', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'quantity'))

	ids_ro_putaway.setItem( ll_putaway_row, 'l_code', ids_CC_UpCountZero_Result.getItemString( ll_row, 'l_code'))
	ids_ro_putaway.setItem( ll_putaway_row, 'lot_no', ids_CC_UpCountZero_Result.getItemString( ll_row, 'lot_no'))
	ids_ro_putaway.setItem( ll_putaway_row, 'po_no', ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no'))
	ids_ro_putaway.setItem( ll_putaway_row, 'po_no2', ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no2'))
	ids_ro_putaway.setItem( ll_putaway_row, 'serial_no', ids_CC_UpCountZero_Result.getItemString( ll_row, 'serial_no'))
	ids_ro_putaway.setItem( ll_putaway_row, 'container_id', ids_CC_UpCountZero_Result.getItemString( ll_row, 'container_id'))
	ids_ro_putaway.setItem( ll_putaway_row, 'expiration_date', ids_CC_UpCountZero_Result.getItemDateTime( ll_row, 'expiration_date'))
	
Next

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_putaway  and  Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function boolean uf_is_sku_serialized (string as_project, string as_sku, string as_supp_code);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//check - Is SKU Serialized ?

string  ls_serialized_Ind
boolean lb_serialized = FALSE

//check above SKU is Serialized?
select Serialized_Ind into :ls_serialized_Ind 
from Item_Master with(nolock)
where project_Id =:as_project and sku=:as_sku
and supp_code =:as_supp_code
using sqlca;

IF  (ls_serialized_Ind ='B'  or ls_serialized_Ind ='Y')  THEN
	lb_serialized = TRUE
else
	lb_serialized = FALSE
END IF

Return lb_serialized

end function

public function integer uf_create_up_count_zero_cc_records (string as_cc_no);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Up Count Zero Records

string lsFilter, lsLogOut, lsFind
long ll_count, llFindRow

Datastore lds_cc_result1, lds_cc_result2, lds_cc_result3

SetPointer(Hourglass!)

//Up Count Zero Result
IF Not Isvalid(ids_CC_UpCountZero_Result) Then
	ids_CC_UpCountZero_Result = create Datastore
	ids_CC_UpCountZero_Result.dataobject ='d_cc_up_count_zero_result'
End IF

IF Not IsValid(lds_cc_result1) Then
	lds_cc_result1 = create Datastore
	lds_cc_result1.dataobject ='d_cc_result1'
	lds_cc_result1.settransobject( SQLCA)
End IF

IF Not IsValid(lds_cc_result2) Then
	lds_cc_result2 = create Datastore
	lds_cc_result2.dataobject ='d_cc_result2'
	lds_cc_result2.settransobject( SQLCA)
End IF

IF Not IsValid(lds_cc_result3) Then
	lds_cc_result3 = create Datastore
	lds_cc_result3.dataobject ='d_cc_result3'
	lds_cc_result3.settransobject( SQLCA)
End IF

//Retrieve CC Results
lds_cc_result1.retrieve( as_cc_no)
lds_cc_result2.retrieve( as_cc_no)
lds_cc_result3.retrieve( as_cc_no)

lsFilter ="up_count_zero ='Y'"

//find up_count_zero records on Count3
lds_cc_result3.setfilter( lsFilter)
lds_cc_result3.filter( )

//find up_count_zero records on Count2
lds_cc_result2.setfilter( lsFilter)
lds_cc_result2.filter( )

//find up_count_zero records on Count1
lds_cc_result1.setfilter( lsFilter)
lds_cc_result1.filter( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_cc_records  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//store onto Up Count Zero data store
IF lds_cc_result3.rowcount( ) > 0 Then	
	lds_cc_result3.rowscopy( lds_cc_result3.getRow(), lds_cc_result3.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count3
	
elseIf lds_cc_result3.rowcount( ) = 0 and lds_cc_result2.rowcount( ) > 0 Then
	lds_cc_result2.rowscopy( lds_cc_result2.getRow(), lds_cc_result2.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count2
	
elseIf lds_cc_result3.rowcount( ) = 0 and lds_cc_result2.rowcount( ) = 0 and lds_cc_result1.rowcount( ) > 0 Then
	lds_cc_result1.rowscopy( lds_cc_result1.getRow(), lds_cc_result1.Rowcount(), Primary!, ids_CC_UpCountZero_Result, 1, Primary!) //copy from Count1
End IF


ll_count = ids_CC_UpCountZero_Result.rowcount( )

//25-MAR-2019 :Madhu DE9598 - Don't create Inbound Order for '0' upcount Qty
lsFind ="quantity=0"
llFindRow = ids_CC_UpCountZero_Result.find( lsFind, 0, ids_CC_UpCountZero_Result.rowcount( ))

DO WHILE llFindRow > 0
	ids_CC_UpCountZero_Result.deleterow( llFindRow)
	
	//Write to File and Screen
	lsLogOut = '      - Cycle Count Up Count Zero- Processing of uf_create_up_count_zero_cc_records  and CC_No: '+as_cc_no +' and DELETE UpCount Qty (0) Row: '+string(llFindRow)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	llFindRow = ids_CC_UpCountZero_Result.find( lsFind, llFindRow +1, ids_CC_UpCountZero_Result.rowcount( )+1)
LOOP

ll_count = ids_CC_UpCountZero_Result.rowcount( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_cc_records  and CC_No: '+as_cc_no +' and Up Count Zero Count: '+ string(ll_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Remove filter
lds_cc_result3.setfilter( "")
lds_cc_result3.filter( )
lds_cc_result3.rowcount( )

lds_cc_result2.setfilter( "")
lds_cc_result2.filter( )
lds_cc_result2.rowcount( )

lds_cc_result1.setfilter( "")
lds_cc_result1.filter( )
lds_cc_result1.rowcount( )

destroy lds_cc_result1
destroy lds_cc_result2
destroy lds_cc_result3

Return 0
end function

public function integer uf_create_up_count_zero_inbound_content (string as_project, string as_wh_code, string as_ro_no, datetime adt_today);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Receive Putaway Content Records

string ls_cc_no, ls_last_user, ls_wh_code, lsLogOut
long ll_row, ll_content_row

SetPointer(Hourglass!)

ls_cc_no = ids_CC_UpCountZero_Result.getItemString( 1, 'cc_no')

select wh_code ,last_user into :ls_wh_code,:ls_last_user 
from CC_Master with(nolock)
where Project_Id = :as_project and CC_No=:ls_cc_no
using sqlca;

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_content and CC No:  '+ls_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


For ll_row =1 to ids_CC_UpCountZero_Result.rowcount( )

	ll_content_row = ids_ro_content.insertrow(0)
	ids_ro_content.setitem( ll_content_row, 'project_id', as_project)
	ids_ro_content.setItem( ll_content_row, 'sku', ids_CC_UpCountZero_Result.getItemString( ll_row, 'sku'))
	ids_ro_content.setItem( ll_content_row, 'supp_code', ids_CC_UpCountZero_Result.getItemString( ll_row, 'supp_code'))
	ids_ro_content.setItem( ll_content_row, 'country_of_origin', ids_CC_UpCountZero_Result.getItemString( ll_row, 'country_of_origin'))
	ids_ro_content.setItem( ll_content_row, 'owner_id', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'owner_id'))
	ids_ro_content.setitem( ll_content_row, 'wh_code', ls_wh_code)
	ids_ro_content.setitem( ll_content_row, 'component_no', 0)
			
	ids_ro_content.setItem( ll_content_row, 'inventory_Type', ids_CC_UpCountZero_Result.getItemString( ll_row, 'inventory_Type'))
	ids_ro_content.setItem( ll_content_row, 'avail_qty', ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'quantity'))

	ids_ro_content.setItem( ll_content_row, 'l_code', ids_CC_UpCountZero_Result.getItemString( ll_row, 'l_code'))
	ids_ro_content.setItem( ll_content_row, 'lot_no', ids_CC_UpCountZero_Result.getItemString( ll_row, 'lot_no'))
	ids_ro_content.setItem( ll_content_row, 'po_no', ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no'))
	ids_ro_content.setItem( ll_content_row, 'po_no2', ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no2'))
	ids_ro_content.setItem( ll_content_row, 'serial_no', '-')
	ids_ro_content.setItem( ll_content_row, 'container_id', ids_CC_UpCountZero_Result.getItemString( ll_row, 'container_id'))
	ids_ro_content.setItem( ll_content_row, 'expiration_date', ids_CC_UpCountZero_Result.getItemDateTime( ll_row, 'expiration_date'))
	ids_ro_content.setitem( ll_content_row,	'ro_no',	as_ro_no)
	
	ids_ro_content.setitem( ll_content_row, 'reason_cd', 'CC')
	ids_ro_content.setitem( ll_content_row, 'last_user', ls_last_user)
	ids_ro_content.setitem( ll_content_row, 'last_update', adt_today)
	ids_ro_content.setitem( ll_content_row, 'last_cycle_count', adt_today)
Next	
	
//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_content and CC No:  '+ls_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_create_up_count_zero_inbound_order (string as_project, string as_cc_no);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty

string ls_ro_no, ls_wh_code, lsLogOut, ls_receive_putaway_serial_rollup_ind
long  ll_rc

Decimal{5}	ld_ro_no

DateTime ldt_today

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_order  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Receive Master
If Not IsValid(ids_ro_main) Then
	ids_ro_main =create u_ds_datastore
	ids_ro_main.Dataobject = 'd_ro_master'
	ids_ro_main.SetTransObject(SQLCA)
End If

//Receive Detail
If Not IsValid(ids_ro_detail) Then
	ids_ro_detail =create u_ds_datastore
	ids_ro_detail.Dataobject = 'd_ro_detail'
	ids_ro_detail.SetTransObject(SQLCA)
End If

//Receive Putaway
If Not IsValid(ids_ro_putaway) Then
	ids_ro_putaway =create u_ds_datastore
	ids_ro_putaway.Dataobject = 'd_ro_putaway'
	ids_ro_putaway.SetTransObject(SQLCA)
End If

//Receive Serial Detail
If Not IsValid(ids_ro_serial_detail) Then
	ids_ro_serial_detail =create u_ds_datastore
	ids_ro_serial_detail.Dataobject = 'd_ro_putaway_serial'
	ids_ro_serial_detail.SetTransObject(SQLCA)
End If

//Receive Content
If Not IsValid(ids_ro_content) Then
	ids_ro_content =create u_ds_datastore
	ids_ro_content.Dataobject = 'd_ro_content'
	ids_ro_content.SetTransObject(SQLCA)
End If

//Serial Number Inventory
If Not IsValid(ids_ro_serial) Then
	ids_ro_serial =create u_ds_datastore
	ids_ro_serial.Dataobject = 'd_serial_number_inventory'
	ids_ro_serial.SetTransObject(SQLCA)
End If

ldt_today = DateTime(Today(), Now())

select wh_code into :ls_wh_code 
from CC_Master with(nolock) 
where Project_Id =:as_project and cc_no =:as_cc_no
using sqlca;

//16-APR-2019 :Madhu S31783 FootPrint Putaway Serial RollUp
select Receive_Putaway_Serial_Rollup_Ind into :ls_receive_putaway_serial_rollup_ind 
from Project with(nolock)
where Project_Id =:as_project
using sqlca;

IF  ids_CC_UpCountZero_Result.rowcount( ) > 0 THEN

	sqlca.sp_next_avail_seq_no(as_project, "Receive_Master","RO_No", ld_ro_no) //get the next available RO_NO
	ls_ro_no = as_project + String(Long(ld_Ro_No),"000000") 


	//1. create Receive Master Records
	this.uf_create_up_count_zero_inbound_header(as_project, as_cc_no , ls_ro_no, ldt_today)

	//2. create Receive Detail Records
	this.uf_create_up_count_zero_inbound_detail(ls_ro_no)

	//3. create Receive Putaway Records
	this.uf_create_up_count_zero_inbound_putaway(ls_ro_no)
	
	//3(a). assign Serial No's to Putaway Records, if SKU is Serialized
	this.uf_create_up_count_zero_inbound_serial(as_project, as_cc_no)
	
	//3(b). create Serial Number Inventory Records
	this.uf_create_up_count_zero_serial_records(as_project, ls_wh_code)

	//4. create Content Record
	this.uf_create_up_count_zero_inbound_content(as_project, ls_wh_code, ls_ro_no, ldt_today)
	
	//5. RollUp Inbound Putaway Serial Records
	IF ls_receive_putaway_serial_rollup_ind ='Y' Then this.uf_create_up_count_inbound_serial_rollup( ls_ro_no)
	
	//5. Commit changes to database
	Execute Immediate "Begin Transaction" using SQLCA;

	IF ids_ro_main.rowcount( ) > 0 Then ll_rc = ids_ro_main.update( false, false);
	IF ids_ro_detail.rowcount( ) > 0 and ll_rc =1 Then ll_rc = ids_ro_detail.update( false, false);
	IF ids_ro_putaway.rowcount( ) > 0 and ll_rc =1 Then ll_rc = ids_ro_putaway.update( false, false);
	IF ids_ro_content.rowcount( ) > 0 and ll_rc = 1 Then ll_rc = ids_ro_content.update( false, false);
	IF ids_ro_serial.rowcount() > 0 and ll_rc = 1 Then ll_rc = ids_ro_serial.update(false, false);
	
	IF ll_rc =1 THEN
	
		Execute Immediate "COMMIT" using SQLCA;
		
		If sqlca.sqlcode =0 Then
			ids_ro_main.resetupdate( )
			ids_ro_detail.resetupdate( )
			ids_ro_putaway.resetupdate( )
			ids_ro_content.resetupdate( )
			ids_ro_serial.resetupdate()
			
		else
			Execute Immediate "ROLLBACK" using SQLCA;
			ids_ro_main.reset( )
			ids_ro_detail.reset( )
			ids_ro_putaway.reset( )
			ids_ro_content.reset( )
			ids_ro_serial.reset()
			
			//Write to File and Screen
			lsLogOut = '      - Cycle Count Up Count Zero- Failed to create Inbound Order against Non-Existing Inventory '+sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
		
	ELSE
			Execute Immediate "ROLLBACK" using SQLCA;
			ids_ro_main.reset( )
			ids_ro_detail.reset( )
			ids_ro_putaway.reset( )
			ids_ro_content.reset( )
			ids_ro_serial.reset()
			
			//Write to File and Screen
			lsLogOut = '      - Cycle Count Up Count Zero- Failed to create Inbound Order against Non-Existing Inventory '+sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)

			Return -1
	
	END IF
	
	//6. Insert Receive_Serial_Detail Records
	IF ls_receive_putaway_serial_rollup_ind ='Y' Then this.uf_create_up_count_receive_serial_detail( ls_ro_no)

	//7. create Batch Transaction Record against Inbound Order
	Execute Immediate "Begin Transaction" using SQLCA;
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		Values(:as_project, 'GR', :ls_ro_no,'N', :ldt_today, '');
	Execute Immediate "COMMIT" using SQLCA;

END IF

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_order  and CC_No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


destroy ids_ro_main
destroy ids_ro_detail
destroy ids_ro_putaway
destroy ids_ro_serial_detail
destroy ids_ro_serial
destroy ids_ro_content


Return 0
end function

public function integer uf_create_up_count_zero_inbound_header (string as_project, string as_cc_no, string as_ro_no, datetime adt_today);//ll_header_row4-MAY-20ll_header_row8 :Madhu Sll_header_row9286 -  Up count from Non existing qty
//create Receive Master Header Record
string lsLogOut, ls_wh_code, ls_last_user
long ll_header_row

SetPointer(Hourglass!)

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_header  and CC_No: '+as_cc_no + ' Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select wh_code, last_user into  :ls_wh_code, :ls_last_user 
from CC_Master with(nolock)
where Project_Id = :as_project and CC_No=:as_cc_no
using sqlca;

ll_header_row= ids_ro_main.insertrow( 0)

ids_ro_main.SetItem(ll_header_row,	'project_id',  as_project)
ids_ro_main.SetItem(ll_header_row,	'ro_no',	as_ro_no)
ids_ro_main.SetItem(ll_header_row,	'wh_code',	ls_wh_code)
ids_ro_main.SetItem(ll_header_row,	'supp_code', 'PANDORA')
ids_ro_main.SetItem(ll_header_row, 'ord_type',	'C')	
ids_ro_main.SetItem(ll_header_row, 'ord_status', 'C')
ids_ro_main.SetItem(ll_header_row, 'ord_date', adt_today)
ids_ro_main.SetItem(ll_header_row, 'complete_date', adt_today)

ids_ro_main.SetItem(ll_header_row,	'supp_invoice_no', as_cc_no)
ids_ro_main.SetItem(ll_header_row,	'inventory_type','N') 
ids_ro_main.SetItem(ll_header_row,	'client_cust_PO_Nbr', as_cc_no) 
ids_ro_main.SetItem(ll_header_row,	'remark','Inbound Order created via Cycle Count Order') 

ids_ro_main.SetItem(ll_header_row, 'create_user', ls_last_user)	
ids_ro_main.SetItem(ll_header_row, 'last_user', ls_last_user)	
ids_ro_main.SetItem(ll_header_row, 'Last_Update', adt_today)	


//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_header  and CC_No: '+as_cc_no + ' Ro No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0

end function

public function integer uf_create_up_count_zero_inbound_serial (string as_project, string as_cc_no);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//If SKU is serialized, assign Serial No's from Serial Numbers Tab to putaway records.

string ls_sku, ls_supp_code, ls_loc, ls_po_no, ls_po_no2, ls_container_id
string	lsFind, lsFilter, lsLogOut

long ll_row, ll_qty, ll_owner_id, llFindRow
long ll_serial_row, ll_row_pos, ll_serial_count

Datastore lds_cc_serials

SetPointer(Hourglass!)

If Not IsValid(lds_cc_serials) Then
	lds_cc_serials = create u_ds_datastore
	lds_cc_serials.dataobject='d_cc_serial_numbers'
	lds_cc_serials.settransobject( SQLCA)
End If

ll_serial_count = lds_cc_serials.retrieve( as_cc_no )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_serial  and  CC No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row = 1 to ids_CC_UpCountZero_Result.rowcount( )
	ls_sku = ids_CC_UpCountZero_Result.getItemString( ll_row, 'sku')
	ls_supp_code = ids_CC_UpCountZero_Result.getItemString( ll_row, 'supp_code')
	ls_loc = ids_CC_UpCountZero_Result.getItemString( ll_row, 'l_code')
	ll_qty = ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'quantity')
	ll_owner_id = ids_CC_UpCountZero_Result.getItemNumber( ll_row, 'owner_id')
	ls_po_no = ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no')
	ls_po_no2 = ids_CC_UpCountZero_Result.getItemString( ll_row, 'po_no2')
	ls_container_id = ids_CC_UpCountZero_Result.getItemString( ll_row, 'container_id')
	
	//Is SKU Serialized
	IF uf_is_sku_serialized (as_project, ls_sku, ls_supp_code) Then
	
		//Find appropriate record on Putaway
		lsFind = "sku='"+ls_sku+"' and l_code ='"+ls_loc+"' and po_no ='"+ls_po_no+"' and owner_Id ="+string(ll_owner_id)
		llFindRow = ids_ro_putaway.find( lsFind, 1, ids_ro_putaway.rowcount())
		
		IF llFindRow > 0 Then
			
			//create duplicate records (copy row) based on Qty
			For ll_row_pos = 1 to ll_qty -1
				ids_ro_putaway.rowscopy( llFindRow, llFindRow , Primary!, ids_ro_putaway, ids_ro_putaway.rowcount( ) +1, Primary!)
			Next
			
			//apply filter against sku, loc
			lsFilter = " sku = '"+ls_sku+"' and l_code ='"+ls_loc+"'"
			lds_cc_serials.setfilter( lsFilter)
			lds_cc_serials.filter( )
			ll_serial_count = lds_cc_serials.rowcount( )
			
			//assign Serial No's to each Putaway Record from Serial Numbers Tab
			For ll_serial_row = 1 to lds_cc_serials.rowcount( )
				lsFind = "sku='"+lds_cc_serials.getItemString(ll_serial_row, 'sku')+"' and l_code ='"+ lds_cc_serials.getItemString(ll_serial_row, 'l_code')+"' and serial_no ='-'"
				llFindRow = ids_ro_putaway.find( lsFind, 1, ids_ro_putaway.rowcount())
				
				If llFindRow > 0 Then
					ids_ro_putaway.setItem( llFindRow, 'quantity', 1)
					ids_ro_putaway.setItem( llFindRow, 'serial_no', lds_cc_serials.getItemString( ll_serial_row, 'serial_no'))
				End If
			Next

			lds_cc_serials.setfilter( "")
			lds_cc_serials.filter( )

		End IF
	End IF
Next

//apply sort on putaway records
ids_ro_putaway.setsort( " sku asc, l_code asc, line_item_no asc ")
ids_ro_putaway.sort( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_serial  and  CC No: '+as_cc_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


destroy lds_cc_serials

Return 0
end function

public function integer uf_create_up_count_zero_serial_records (string as_project, string as_wh_code);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty
//create Serial Number Inventory records against Putaway Records

string lsFilter, ls_owner_cd, lsLogOut
long ll_row, ll_serial_row, ll_owner_id, ll_prev_owner_id

SetPointer(Hourglass!)

//apply filter
lsFilter ="serial_no <> '-'"
ids_ro_putaway.setfilter( lsFilter)
ids_ro_putaway.filter( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_serial_records '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row = 1 to  ids_ro_putaway.rowcount( )

	ll_owner_id =	ids_ro_putaway.getItemNumber(ll_row ,'owner_id')
	
	IF ll_owner_id <> ll_prev_owner_id THEN
		select Owner_Cd into :ls_owner_cd 
		from Owner with(nolock) 
		where Project_Id =:as_project and Owner_Id =:ll_owner_id
		using sqlca;
	END IF
	
	ll_serial_row =	ids_ro_serial.insertrow(0)
	ids_ro_serial.setItem( ll_serial_row, 'project_id', as_project)
	ids_ro_serial.setItem( ll_serial_row, 'wh_code', as_wh_code)
	ids_ro_serial.setItem( ll_serial_row, 'owner_id', ll_owner_id)
	ids_ro_serial.setItem( ll_serial_row, 'sku', ids_ro_putaway.getItemString(ll_row, 'sku'))
	ids_ro_serial.setItem( ll_serial_row, 'serial_no', ids_ro_putaway.getItemString(ll_row, 'serial_no'))
	ids_ro_serial.setItem( ll_serial_row, 'l_code', ids_ro_putaway.getItemString(ll_row, 'l_code'))
	ids_ro_serial.setItem( ll_serial_row, 'lot_no', ids_ro_putaway.getItemString(ll_row, 'lot_no'))
	ids_ro_serial.setItem( ll_serial_row, 'po_no', ids_ro_putaway.getItemString(ll_row, 'po_no'))
	ids_ro_serial.setItem( ll_serial_row, 'po_no2', ids_ro_putaway.getItemString(ll_row, 'po_no2'))
	ids_ro_serial.setItem( ll_serial_row, 'exp_dt', ids_ro_putaway.getItemDateTime(ll_row, 'expiration_date'))
	ids_ro_serial.setItem( ll_serial_row, 'inventory_type', ids_ro_putaway.getItemString(ll_row, 'inventory_Type'))
	ids_ro_serial.setItem( ll_serial_row, 'owner_cd', ls_owner_cd)
	ids_ro_serial.setItem( ll_serial_row, 'component_ind', 'N')
	ids_ro_serial.setItem( ll_serial_row, 'component_no', 0)
	ids_ro_serial.setItem( ll_serial_row, 'ro_no', ids_ro_putaway.getItemString(ll_row, 'ro_no'))
	ids_ro_serial.setItem( ll_serial_row, 'carton_id', ids_ro_putaway.getItemString(ll_row, 'container_id'))
	
	ll_prev_owner_id = ll_owner_id
	
Next

//remove filter
ids_ro_putaway.setfilter( "")
ids_ro_putaway.filter( )
ids_ro_putaway.rowcount( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_serial_records '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function integer uf_process_om_cc_inbound_order (string as_project, string as_ro_no, long al_trans_id);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty

long		llNewQty,  ll_Inv_Row, llRC, llNewOwnerId, ll_count, ll_row
string	 	lsSKU, lsWhcode, lsRONO, lsNewPoNo, lsNewOwner_Cd, ls_client_id, lsLogOut, ls_om_enabled, ls_sql, ls_errors
decimal	ldOMQ_Inv_Tran
datetime ldtToday

Datastore lds_ro_putaway

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - CC Up Count Zero OM Adjustment- Start Processing of uf_process_om_cc_inbound_order() for Ro No: ' + string(as_ro_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( as_project) //connect to OT29 DB.

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
End If
idsOMQInvTran.SetTransObject(om_sqlca)

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id=:as_project using sqlca;

lds_ro_putaway = Create Datastore
ls_sql = " 	SELECT  A.Ro_No , B.wh_code, A.SKU , A.owner_id , C.Owner_Cd, "
ls_sql += " 	A.Lot_No , A.po_no , sum(A.Quantity) as Qty "
ls_sql +="  	FROM Receive_Putaway A with (nolock) "
ls_sql +=" 	INNER JOIN Receive_Master B with (nolock) ON B.RO_No = A.RO_No "
ls_sql +=" 	INNER JOIN Owner C with (nolock) ON C.Project_Id = B.Project_Id  AND C.owner_id = A.owner_id "
ls_sql +=" 	WHERE B.Project_Id ='"+as_project+"' and A.RO_No = '"+as_ro_no+"'"
ls_sql += " 	Group By A.RO_No , B.wh_code, A.SKU,  A.owner_id , C.Owner_Cd, A.Lot_No, A.po_no"

lds_ro_putaway.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
lds_ro_putaway.settransobject( SQLCA)
ll_count = lds_ro_putaway.retrieve( )

IF ll_count <= 0 Then
	//No Putaway records are created.
	lsLogOut = "        ***CC Up Count Zero OM Adjustment- Unable to retreive Inbound Putaway Records for Ro No: " + as_ro_no
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End IF

//10-APR-2019 :Madhu DE10044 loop through putaway records
FOR ll_row = 1 TO ll_count
	
	//get values from datastore
	lsSku = lds_ro_putaway.getItemString(ll_row,'sku')
	lsWhcode = lds_ro_putaway.getItemString(ll_row,'wh_code')
	llNewOwnerId = lds_ro_putaway.getItemNumber(ll_row,'owner_Id')
	lsNewOwner_Cd = lds_ro_putaway.getItemString(ll_row,'Owner_Cd')
	lsNewPoNo = lds_ro_putaway.getItemString(ll_row, 'po_no')
	llNewQty = lds_ro_putaway.getITemNumber(ll_row,'Qty')
	
	select OM_Enabled_Ind into :ls_om_enabled from Warehouse with(nolock) where wh_code =:lsWhcode using sqlca;
	
	If upper(ls_om_enabled) <> 'Y' Then
		//Write to File and Screen
		lsLogOut = '      - CC Up Count Zero OM Adjustment- Processing of uf_process_om_cc_inbound_order() for Ro No: ' + string(as_ro_no) + ' Warehouse: '+lsWhcode+' is not enabled for OM'
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
	//Write records into OMQ_Inventory_Transaction Table
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', al_trans_id) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(as_project, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Receive_Putaway.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwner_Cd) //Receive_Putaway.Owner_Id (Owner Cd)
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsNewPoNo) //Receive_Putaway.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llNewQty) //Receive_Putaway.Qty
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(as_ro_no),10)) //Receive_Putaway.Ro_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', string(as_ro_no)) //Receive_Putaway.Ro_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'CYCLE') //Reason code
	
	
	Execute Immediate "Begin Transaction" using om_sqlca;
	If idsOMQInvTran.rowcount( ) > 0 Then
		llRC =idsOMQInvTran.update( false, false);
	End IF
	
	If llRC =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTran.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQInvTran.reset( )
			
			//Write to File and Screen
			lsLogOut = '      - CC Up Count Zero OM Adjustment - Processing of uf_process_om_cc_inbound_order() for Ro No: ' + string(as_ro_no) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//Write to File and Screen
		lsLogOut = '      - CC Up Count Zero OM Adjustment - Processing of uf_process_om_cc_inbound_order() for Ro No: ' + string(as_ro_no) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If

	this.uf_process_om_cc_sn_inbound_order( as_project, al_trans_id, lsWhcode, as_ro_no,  string(ldOMQ_Inv_Tran), lsSku) //Insert SN Records.

NEXT

destroy lds_ro_putaway
destroy idsOMQInvTran
gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0
end function

public function long uf_process_cc_remove_recon_filter ();//31-MAY-2018 :Madhu DE3576 - Remove Reconciliation Datastore filter

long ll_rowcount

idsCCRecon.setfilter( "")
idsCCRecon.filter( )
ll_rowcount = idsCCRecon.rowcount( )

Return ll_rowcount
end function

public function integer uf_process_lwon (string asproject, datetime adtcreatedate, string asloadid, string astransparm);//Prepare a Load Lock for PANDORA for the Load ID
//06-FEB-2019 :Madhu DE8493 Passed Do_No as TransParam

Long		llRowCount, llNewRow
				
String		 lsOutString, lsMessage, lsLogOut, lsDoNo, lsLSRC, lsGmtOffset, lsWhs

Decimal		ldBatchSeq


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If


idsOut.Reset()
 
lsLogOut = "      Creating Load Lock (LWON) For LOAD_ID: " + asLoadID
FileWrite(gilogFileNo,lsLogOut)

IF IsNull(astransparm) or astransparm ='' or astransparm =' ' THEN

//Get Order
  SELECT Max(Do_No)    
    INTO :lsDoNo      FROM Delivery_Master with(nolock)     WHERE Load_Id = :asloadid   
	 using SQLCA;
ELSE
	lsDoNo = astransparm
END IF

//Get Requirement Code
  SELECT Logistic_Service_Requirement_Code
    INTO :lsLSRC  FROM EDI_Load_Plan with(nolock)    WHERE Project_Id = :asproject and Load_Id = :asloadid   
	 using SQLCA;


//Find Do_No based on LoadID
If lsDoNo = ''  Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For LoadId: " + asLoadId
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Retreive Delivery Master
llRowCount= idsDOMain.Retrieve(lsDoNo)
If llRowCount <> 1  Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DoNo: " + lsDoNo
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// Get GMT offset
lsWhs = trim(idsDOMain.GetItemString(1, 'wh_code'))// Get GMT Offset

select  GMT_Offset
into :lsGmtOffset
from Warehouse with(nolock)
where wh_Code=:lsWhs
using sqlca;

If lsGmtOffset = '' then lsGmtOffset = '0'

ldBatchSeq = 	idsDOMain.GetItemNumber(1, 'EDI_batch_seq_no')	

//Write the rows to the generic output table - space delimited by 
llNewRow = idsOut.insertRow(0)
lsOutString =  '0000000000'  // 1st  field 
lsOutString +=  'OBO                 '  // 2nd  field 
lsOutString +=  'TMS                 '  // 3rd  field 
lsOutString +=  'LOAD                '  // 4th  field 
lsOutString +=  'LOCK                '  // 5th  field 
lsOutString += String(adtcreatedate, 'YYYYMMDDHHMMSS')    // transaction date
lsOutString += this.gmtformatoffset(lsGmtOffset)  // GMT Offset
lsOutString += trim(idsDOMain.GetItemString(1, 'invoice_no'))  + Space(30 - Len(trim(idsDOMain.GetItemString(1, 'invoice_no'))))  // Order Number
lsOutString += asLoadId + Space(12 - Len(asLoadId)) 
lsOutString += trim(idsDOMain.GetItemString(1, 'wh_code'))  + Space(10 - Len(trim(idsDOMain.GetItemString(1, 'wh_code'))))  // Warehouse
lsOutString += trim(idsDOMain.GetItemString(1, 'user_field2'))  + Space(30 - Len(trim(idsDOMain.GetItemString(1, 'user_field2'))))  // Owner Code
lsOutString +=  'PRODUCT_PICKED                '  // Hardcoded
lsOutString += trim(idsDOMain.GetItemString(1, 'Carrier'))  + Space(15 - Len(trim(idsDOMain.GetItemString(1, 'Carrier'))))   // Carrier
lsOutString += lsLSRC + Space(10 - Len(lsLSRC))  //Logistic_Service_Requirement_Code
	
idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', 1)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'LWON' + String(adtcreatedate, 'YYYYMMDDHHMMSSfff') + '.DAT')  //25-FEB-2019 :Madhu DE8975 Appended Seconds to File Name

//Added a Trailer Record
llNewRow = idsOut.insertRow(0)
lsOutString = '00000001TR'+ String(adtcreatedate, 'HHMMSSYYYYMMDD')   // transaction date
lsOutString += trim(idsDOMain.GetItemString(1, 'wh_code'))  + Space(20 - Len(trim(idsDOMain.GetItemString(1, 'wh_code'))))  // Warehouse
lsOutString += String(ldBatchSeq)  + Space(50 - Len(String(ldBatchSeq)))    // TransId

	
idsOut.SetItem(llNewRow, 'Project_id', asProject)
idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow, 'line_seq_no', 2)
idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
idsOut.SetItem(llNewRow, 'file_name', 'LWON' + String(adtcreatedate, 'YYYYMMDDHHMMSSfff') + '.DAT') //25-FEB-2019 :Madhu DE8975 Appended Seconds to File Name

//Write the Outbound File
//TAM 2018/10/25 -  Write LWON files to a separate folder - So it can be FTP'ed to a different address
//gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PANDORA_CM')

destroy idsOut
destroy idsDOMain

Return 0

end function

public function str_parms uf_process_cc_auto_serialno_soc (string as_project, string as_ccno, string as_sku, string as_lcode, long al_ownerid, string as_pono, string as_pono2, string as_container_id, double ad_req_qty, boolean ab_autosoc);//21-Nov-2017 :Madhu PEVS-806 3PL Cycle Count Orders

string		sql_syntax, lsErrors, lsLogOut, ls_serial_list[], ls_alt_serial_list[], ls_formatted_serialno, ls_SN_filter
string		ls_serial_no, ls_find, ls_action_cd, ls_wh, ls_dummy_SN, ls_sku, ls_po_no, ls_lcode, lsFind
string 	ls_formatted_ToNo, ls_assigned_serialno
long		ll_scan_count, ll_row, ll_serial_count, ll_req_sn_qty, ll_find_row, ll_SNI_count, ll_SNI_row, ll_sn_count
long		ll_Next_Seq_No, ll_owner_Id, ll_Upper_Bound, ll_alt_serial_count
Datastore	ldsCCScanSN, ldsSNI
Str_Parms ls_serial_parms

SetPointer(HourGlass!)

If not IsValid(ldsSNI) Then
	ldsSNI =create Datastore
	ldsSNI.dataobject ='d_serial_number_inventory'
	ldsSNI.settransobject( SQLCA)
End If

ll_req_sn_qty = long(ad_req_qty)

this.uf_process_cc_remove_recon_filter() //Remove filter

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- Start Processing of uf_process_cc_auto_serialno_soc  and CC_No: '+as_ccno + ' - SKU: ' +as_sku +' - Req SN Qty: '+string(ll_req_sn_qty)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select wh_code into :ls_wh from CC_Master with(nolock) where Project_Id =:as_project and CC_no =:as_ccno using sqlca;

//get a list of SKU's against CC No from CC_Serial_Numbers Table
ldsCCScanSN = create Datastore
sql_syntax =" select * from CC_Serial_Numbers  with(nolock) where cc_no ='"+as_ccno+"' and sku='"+as_sku+"' and L_code ='"+as_lcode+"'"
ldsCCScanSN.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))
ldsCCScanSN.settransobject( SQLCA)
ll_scan_count = ldsCCScanSN.retrieve( )

If ll_scan_count > 0 Then //Scanned Count should be greater than 0
	//Down Count means DELETE serial No's from SNI Table.
	ll_serial_count = idsCCRecon.rowcount( )
	
	//get list of Serial No's
	For ll_row =1 to ll_scan_count
		ls_serial_list[ UpperBound(ls_serial_list) + 1 ] = ldsCCScanSN.getItemString( ll_row, 'serial_no')	
	Next
	
	//format Serial No's
	If UpperBound(ls_serial_list) > 0 Then ls_formatted_serialno = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 )
	
	//11-Oct-2018 Madhu DE6675 - Get Serial No records which are already assigned to any SOC
	//Don't consider, if it is alredy assigned to SOC's
	If UpperBound(is_ToNo_List) > 0 Then 
		ls_formatted_ToNo = in_string_util.of_format_string( is_ToNo_List, n_string_util.FORMAT1 )
		
		//get list of Serial No's
		idsAltSerialRecords = this.uf_process_cc_get_assigned_serialno( ls_formatted_ToNo, as_sku)
		
		ll_alt_serial_count = idsAltSerialRecords.rowcount( )
		
		IF ll_alt_serial_count > 0 Then
			FOR ll_row = 1 to ll_alt_serial_count
				ls_alt_serial_list[UpperBound(ls_alt_serial_list) +1] =idsAltSerialRecords.getItemString( ll_row, 'Serial_No_Parent')
			NEXT
			ls_assigned_serialno = in_string_util.of_format_string( ls_alt_serial_list, n_string_util.FORMAT1 )
		END IF

	End If
	
	IF ls_assigned_serialno >' ' Then ls_formatted_serialno += ','+ls_assigned_serialno

	//Write to File and Screen
	lsLogOut = '      - 3PL Cycle Count- Processing of uf_process_cc_auto_serialno_soc  and CC_No: '+as_ccno + ' - Assigned SN: '+nz(ls_assigned_serialno, '-') + ' Formated SN: '+nz(ls_formatted_serialno, '-')
	FileWrite(giLogFileNo,lsLogOut)

	//Look for SN other than scanned +previously assigned to ToNo which needs to be deleted
	ls_SN_filter =" sku = '"+as_sku+"' and serial_no NOT IN ("+ls_formatted_serialno+") and l_code='"+as_lcode+"'"
	idsCCRecon.setfilter( ls_SN_filter)
	idsCCRecon.filter( )
	ll_serial_count = idsCCRecon.rowcount( )
	
	If ll_serial_count >= ll_req_sn_qty Then
		For ll_row =1 to ll_req_sn_qty
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =	idsCCRecon.getItemString( ll_row, 'serial_no')
		Next
	End If
	
	//08-Oct-2018 :Madhu DE6671 - Delete SN's, if we found against above filter.
	If (ll_serial_count > 0 and ll_serial_count < ll_req_sn_qty) Then
		For ll_row =1 to ll_serial_count
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =	idsCCRecon.getItemString( ll_row, 'serial_no')
		Next
	End If
	
	//Add DUMMY SN, if SOC QTY doesn't match with idsCCRecon
	ll_sn_count =UpperBound(ls_serial_parms.string_arg)
	IF ll_serial_count <= 0 Then
		For ll_row = 1 to ll_req_sn_qty
			ls_dummy_SN =this.uf_get_next_dummy_serialNo()
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =ls_dummy_SN
			this.uf_process_cc_add_update_serialno( 'D', as_project, ls_wh, as_sku, al_ownerId, as_lcode, as_pono, ls_dummy_SN)
		Next
	else
		For ll_row = 1 to (ll_req_sn_qty - ll_sn_count)
			ls_dummy_SN =this.uf_get_next_dummy_serialNo()
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =ls_dummy_SN
			this.uf_process_cc_add_update_serialno( 'D', as_project, ls_wh, as_sku, al_ownerId, as_lcode, as_pono, ls_dummy_SN)
		Next
	End IF
	
	this.uf_process_cc_remove_recon_filter() //Remove filter
	
	//update Action Code to 'D', if it was not
	For ll_row =1 to UpperBound(ls_serial_parms.string_arg)
		 ls_serial_no = ls_serial_parms.string_arg[ll_row]
		 ls_find ="sku ='"+as_sku+"' and serial_no='"+ls_serial_no+"'"
		 
		 ll_find_row = idsCCRecon.find( ls_find, 1, idsCCRecon.rowcount())
		 
		 If ll_find_row > 0 Then
			 ls_action_cd = idsCCRecon.getItemString( ll_find_row, 'action_cd')
			 If upper(ls_action_cd) <> 'D' Then idsCCRecon.setItem( ll_find_row, 'action_cd', 'D') //delete serial No.
		End If
	NEXT
ELSE
	//Give a try to find any records for Action Code 'D'
	If ab_autosoc =TRUE Then
		ls_SN_filter =" sku = '"+as_sku+"' and l_code='"+as_lcode+"' and action_cd <> 'D'"
	else
		ls_SN_filter =" sku = '"+as_sku+"' and l_code='"+as_lcode+"' and action_cd ='D'"
	End If

	idsCCRecon.setfilter( ls_SN_filter)
	idsCCRecon.filter( )
	ll_serial_count = idsCCRecon.rowcount( )
	
	If ll_serial_count >= ll_req_sn_qty Then
		For ll_row =1 to ll_req_sn_qty
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =	idsCCRecon.getItemString( ll_row, 'serial_no')
		Next
	End If
	
	ll_Upper_Bound = UpperBound(ls_serial_parms.string_arg)
	
	//get list of Serial No's
	For ll_row =1 to ll_serial_count
		ls_serial_list[ ll_row ] = idsCCRecon.getItemString( ll_row, 'serial_no')	
	Next
	
	//format Serial No's
	If UpperBound(ls_serial_list) > 0 Then ls_formatted_serialno = in_string_util.of_format_string( ls_serial_list, n_string_util.FORMAT1 )

	//Get Serial No records from Serial No Inventory Table and set Action Code as 'DELETE'
	sql_syntax = ldsSNI.getsqlselect( )
	sql_syntax += " where Project_Id ='"+as_project+"' and sku='"+as_sku+"'"
	sql_syntax += " and l_code='"+as_lcode+"' and Owner_Id ="+string(al_ownerId)+" and Po_No ='"+as_pono+"'"
	If as_pono2 <> '-' Then sql_syntax += " and Po_No2 ='"+as_pono2+"'"
	If as_container_id <> '-' Then sql_syntax += " and Carton_Id ='"+as_container_id+"'"
	If ll_serial_count > 0 Then sql_syntax += " and serial_no NOT IN ("+ls_formatted_serialno+")"
	
	ldsSNI.setsqlselect( sql_syntax)
	ll_SNI_count = ldsSNI.retrieve( )
	
	this.uf_process_cc_remove_recon_filter() //Remove filter
			
	If  ll_SNI_count >= ll_req_sn_qty Then 
		For ll_SNI_row =1 to ll_req_sn_qty
			ls_serial_no = ldsSNI.getItemString( ll_SNI_row, 'serial_no')
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =	ls_serial_no
			
			//Look for SN other than scanned which needs to be deleted
			ls_SN_filter =" sku = '"+as_sku+"' and serial_no ='"+ls_serial_no+"' and l_code='"+as_lcode+"'"
			idsCCRecon.setfilter( ls_SN_filter)
			idsCCRecon.filter( )
			ll_serial_count = idsCCRecon.rowcount( )

			If ll_serial_count = 0 Then 	idsCCRecon = this.uf_process_cc_reconciliation_serial( ldsSNI, ll_SNI_row, 'D', as_lcode, ls_serial_no) //don't add duplicates
			
			this.uf_process_cc_remove_recon_filter() //Remove filter
		Next
	else
		For ll_SNI_row =1 to ll_SNI_count
			ls_serial_no = ldsSNI.getItemString( ll_SNI_row, 'serial_no')
			ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =	ls_serial_no
			
			//Look for SN other than scanned which needs to be deleted
			ls_SN_filter =" sku = '"+as_sku+"' and serial_no ='"+ls_serial_no+"' and l_code='"+as_lcode+"'"
			idsCCRecon.setfilter( ls_SN_filter)
			idsCCRecon.filter( )
			ll_serial_count = idsCCRecon.rowcount( )
			
			If ll_serial_count = 0 Then 	idsCCRecon = this.uf_process_cc_reconciliation_serial( ldsSNI, ll_SNI_row, 'D', as_lcode, ls_serial_no) //don't add duplicates
			
			this.uf_process_cc_remove_recon_filter() //Remove filter
		
		Next
	
		//Add DUMMY SN, if SOC QTY doesn't match with idsCCRecon
		IF ll_SNI_count <= 0 Then
			For ll_row = 1 to (ll_req_sn_qty  - ll_Upper_Bound)
				ls_dummy_SN =this.uf_get_next_dummy_serialNo()
				ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =ls_dummy_SN
				this.uf_process_cc_add_update_serialno( 'D', as_project, ls_wh, as_sku, al_ownerId, as_lcode, as_pono, ls_dummy_SN)
			Next
		else
			For ll_row = 1 to (ll_req_sn_qty - ll_SNI_count)
				ls_dummy_SN =this.uf_get_next_dummy_serialNo()
				ls_serial_parms.string_arg[UpperBound(ls_serial_parms.string_arg) +1] =ls_dummy_SN
				this.uf_process_cc_add_update_serialno( 'D', as_project, ls_wh, as_sku, al_ownerId, as_lcode, as_pono, ls_dummy_SN)
			Next
		End IF
	End If
END IF

//Write to File and Screen
lsLogOut = '      - 3PL Cycle Count- End Processing of uf_process_cc_auto_serialno_soc  and CC_No: '+as_ccno + ' - SKU: ' +as_sku
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsCCScanSN
destroy ldsSNI

Return ls_serial_parms
end function

public function datastore uf_process_cc_get_assigned_serialno (string as_tono, string as_sku);//11-Oct-2018 :Madhu DE6675 3PL CC Order
//get list of serial No already assigned to To No against CC.

string		sql_syntax, lsErrors, lsLogOut

sql_syntax=""

IF Not IsValid(idsAltSerialRecords) Then
	idsAltSerialRecords = create Datastore
End IF

sql_syntax = " select * from Alternate_Serial_Capture with(nolock) "
sql_syntax += " where To_No IN ("+as_ToNo+") "
sql_syntax += " and SKU_Parent ='"+as_sku+"'"

idsAltSerialRecords.create( SQLCA.syntaxfromsql( sql_syntax, "", lsErrors))

IF Len(lsErrors) > 0 THEN
	lsLogOut = "         3PL Cycle Count-  Processing of uf_process_cc_is_serial_assigned_tono()  -Unable to create datastore.~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF
	
idsAltSerialRecords.settransobject( SQLCA)
idsAltSerialRecords.retrieve( )


Return idsAltSerialRecords
end function

public function long uf_process_om_cc_sn_inbound_order (string as_project, long al_transid, string as_wh_code, string as_ro_no, string as_itrn_key, string as_sku);//14-MAY-2018 :Madhu S19286 -  Up count from Non existing qty

Long 		ll_InvTxn_row, llRowPos, llRowCount, llRC
string 	ls_client_Id, lslogOut, ls_sku, ls_serialno, ls_receive_putaway_serial_rollup_ind
DateTime	ldtToday

Datastore	lds_ro_serial

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - CC Up Count Zero OM Adjustment- Start Processing of uf_process_om_cc_sn_inbound_order() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select OM_Client_Id, receive_putaway_serial_rollup_ind into :ls_client_Id, :ls_receive_putaway_serial_rollup_ind 
from Project with(nolock) where Project_Id= :as_project
using sqlca;

If Not isvalid(idsOMQInvTxnSernum) Then
	idsOMQInvTxnSernum = Create u_ds_datastore
	idsOMQInvTxnSernum.Dataobject = 'd_omq_inventory_txn_sernum'
End If
idsOMQInvTxnSernum.SetTransObject(om_sqlca)

If Not isvalid(lds_ro_serial) Then
	lds_ro_serial = create u_ds_datastore
	
	//15-MAY-2019 :Madhu S31783 DE10566 Foot Print Putaway Serial RollUp
	IF ls_receive_putaway_serial_rollup_ind ='Y' THEN
		lds_ro_serial.dataobject ='d_ro_putaway_serial'
	ELSE
		lds_ro_serial.dataobject ='d_ro_putaway'
	END IF
	
	lds_ro_serial.settransobject(SQLCA)
End If

llRowCount = lds_ro_serial.retrieve( as_ro_no)

//apply filter
lds_ro_serial.setfilter( "serial_no <> '-' and sku ='"+as_sku+"'" )
lds_ro_serial.filter( )
llRowCount = lds_ro_serial.rowcount( )
	

IF llRowCount > 0 THEN
	For llRowPos = 1 to llRowCount
		ls_sku= lds_ro_serial.GetItemString(llRowPos, 'Sku') //sku
		ls_serialno =lds_ro_serial.GetItemString(llRowPos, 'serial_no')
			
		//Write OMQ_Inventory_Txn_Sernum Record
		ll_InvTxn_row = idsOMQInvTxnSernum.insertrow( 0)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QADDWHO', 'SIMSUSER') //Add Who
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QACTION', 'I') //Action
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUS', 'NEW') //Status
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'QWMQID', al_transId) //Set with Batch_Transaction.Id_No
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SITE_ID', as_wh_code) //site id
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDDATE', ldtToday) //Add Date
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ADDWHO', 'SIMSUSER') //Add who
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITDATE', ldtToday) //Add Date
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'EDITWHO', 'SIMSUSER') //Add who
	
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'CLIENT_ID', ls_client_Id)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNKEY', as_itrn_key)
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'ITRNSERIALKEY', '1')
		
		idsOMQInvTxnSernum.setitem( ll_InvTxn_row, 'SERIALNUMBER', ls_serialno)
		
		//Write to file
		lsLogOut = ' CC Up Count Zero OM Adjustment - Record inserted into OMQ_Inventory_Txn_Sernum table aginst ItrnKey# '+string(as_itrn_key)+'  Serial No# '+ ls_serialno
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
	
	NEXT
	
	If (idsOMQInvTxnSernum.rowcount( ) > 0 ) Then
		Execute Immediate "Begin Transaction" using om_sqlca;

	 	llRC = idsOMQInvTxnSernum.update(false, false);
		If llRC =1 Then
			Execute Immediate "COMMIT" using om_sqlca;
		
			if om_sqlca.sqlcode = 0 then
				idsOMQInvTxnSernum.resetupdate( )
			else
				Execute Immediate "ROLLBACK" using om_sqlca;
				idsOMQInvTxnSernum.reset()
				
				//remove filter
				lds_ro_serial.setfilter( "" )
				lds_ro_serial.filter( )
				
				//Write to File and Screen
				lsLogOut = '      -CC Up Count Zero OM Adjustment- Processing of uf_process_om_cc_sn_inbound_order  is failed to write/update OM Tables: ' + om_sqlca.SQLErrText
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
				Return -1
			end if
		else
			Execute Immediate "ROLLBACK" using om_sqlca;

			//remove filter
			lds_ro_serial.setfilter( "" )
			lds_ro_serial.filter( )
			
			//Write to File and Screen
			lsLogOut = "      -  CC Up Count Zero OM Adjustment- Processing of uf_process_om_cc_sn_inbound_order  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		End If
	End If
END IF

//remove filter
lds_ro_serial.setfilter( "" )
lds_ro_serial.filter( )

destroy lds_ro_serial
destroy 	idsOMQInvTxnSernum

//Write to File and Screen
lsLogOut = '      - CC Up Count Zero OM Adjustment- End Processing of uf_process_om_cc_sn_inbound_order() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_create_up_count_receive_serial_detail (string as_ro_no);//16-APR-2019 :Madhu S31783 FootPrint Putaway Serial RollUp

//a. Retrieve Receive_Putaway records
//b. Update Receive_Putaway.Id_No to Receive_Serial_Detail.Id_No datastore
//c. Save Receive_Serial_Detail datastore to DB

string ls_filter, lsLogOut, ls_sku, ls_coo, ls_loc, ls_lot
string ls_pono, ls_pono2, ls_container_id, lsfind
long ll_row, ll_putaway_count, ll_rc, ll_owner_id
long ll_line_no, ll_id_no, ll_find_row

SetPointer(HourGlass!)

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_receive_serial_detail and Ro_No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

ll_putaway_count = ids_ro_putaway.retrieve( as_ro_no)

FOR ll_row = 1 to ll_putaway_count
	
	ls_sku = ids_ro_putaway.getItemString(ll_row, 'sku')
	ls_coo = ids_ro_putaway.getItemString(ll_row, 'country_of_origin')
	ll_owner_id = ids_ro_putaway.getItemNumber(ll_row, 'owner_id')
	ll_line_no = ids_ro_putaway.getItemNumber(ll_row, 'line_item_no')
	ls_loc = ids_ro_putaway.getItemString(ll_row, 'l_code')
	ls_lot = ids_ro_putaway.getItemString(ll_row, 'lot_no')
	ls_pono = ids_ro_putaway.getItemString(ll_row, 'po_no')
	ls_pono2 = ids_ro_putaway.getItemString(ll_row, 'po_no2')
	ls_container_id = ids_ro_putaway.getItemString(ll_row, 'container_id')
	ll_id_no = ids_ro_putaway.getItemNumber(ll_row, 'id_no')	

	//find row on putaway and sum(qty)
	lsFind = "sku='"+ls_sku+"' and country_of_origin='"+ls_coo+"' and owner_id="+string(ll_owner_id)+" and line_item_no="+string(ll_line_no)
	lsFind += " and l_code ='"+ls_loc+"' and lot_no='"+ls_lot+"' and po_no='"+ls_pono+"' and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
	
	ll_Find_Row = ids_ro_serial_detail.find( lsFind, 0, ids_ro_serial_detail.rowcount( ))
	
	DO WHILE ll_Find_Row > 0
		ids_ro_serial_detail.setItem( ll_Find_Row, 'rsd_id_no', ll_id_no)
		ll_Find_Row = ids_ro_serial_detail.find( lsFind, ll_Find_Row +1, ids_ro_serial_detail.rowcount( ) +1)	
	LOOP	
	
	//Write to File and Screen
	lsLogOut = '      - Cycle Count Up Count Zero- Processing of uf_create_up_count_receive_serial_detail - Updated Id_No: '+string(ll_id_no) +' to SKU: '+ls_sku
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
NEXT


Execute Immediate "Begin Transaction" using SQLCA;

IF ids_ro_serial_detail.rowcount( ) > 0 Then ll_rc = ids_ro_serial_detail.update( false, false);

IF ll_rc =1 THEN

	Execute Immediate "COMMIT" using SQLCA;
	
	If sqlca.sqlcode =0 Then
		ids_ro_serial_detail.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using SQLCA;
		ids_ro_serial_detail.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - Cycle Count Up Count Zero- Failed to create Inbound Serial Detail Records  '+sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
	
ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		ids_ro_serial_detail.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - Cycle Count Up Count Zero- Failed to create Inbound Serial Detail Records  '+sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
END IF

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_receive_serial_detail  and Ro_No: '+as_ro_no
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_create_up_count_inbound_serial_rollup (string as_ro_no);//16-APR-2019 :Madhu S31783 FootPrint Putaway Serial RollUp

//a. RollUp Putaway Serial Records i.e., sum up qty of serial records and delete extra records.
//b. i.e., Sum(Qty) of Serial Records and make only one record against SKU, Line Item No and unique attributes
//c. Delete serial no's records.

string lsFilter, ls_owner_cd, lsLogOut, lsFind
string ls_sku, ls_coo, ls_loc, ls_lot, ls_pono, ls_pono2, ls_container_id, ls_serial
long ll_row, ll_serial_row, ll_putaway_count, ll_owner_id, ll_line_no, ll_Find_Row, ll_qty

SetPointer(Hourglass!)

//reset datastore
ids_ro_serial_detail.reset( )

//apply filter
lsFilter ="serial_no <> '-'"
ids_ro_putaway.setfilter( lsFilter)
ids_ro_putaway.filter( )
ll_putaway_count = ids_ro_putaway.rowcount( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- Start Processing of uf_create_up_count_zero_inbound_rollup & Putaway Count: '+string(ll_putaway_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

For ll_row = ll_putaway_count to 1 Step -1

	ls_sku = ids_ro_putaway.getItemString(ll_row, 'sku')
	ls_coo = ids_ro_putaway.getItemString(ll_row, 'country_of_origin')
	ll_owner_id = ids_ro_putaway.getItemNumber(ll_row, 'owner_id')
	ll_line_no = ids_ro_putaway.getItemNumber(ll_row, 'line_item_no')
	ls_loc = ids_ro_putaway.getItemString(ll_row, 'l_code')
	ll_qty = ids_ro_putaway.getItemNumber(ll_row, 'quantity')
	ls_lot = ids_ro_putaway.getItemString(ll_row, 'lot_no')
	ls_pono = ids_ro_putaway.getItemString(ll_row, 'po_no')
	ls_pono2 = ids_ro_putaway.getItemString(ll_row, 'po_no2')
	ls_container_id = ids_ro_putaway.getItemString(ll_row, 'container_id')
	ls_serial = ids_ro_putaway.getItemString(ll_row, 'serial_no')


	//Receive Putaway
	ll_serial_row =	ids_ro_serial_detail.insertrow(0)
	ids_ro_serial_detail.setItem(ll_serial_row, 'ro_no', as_ro_no)
	ids_ro_serial_detail.setItem( ll_serial_row, 'sku', ls_sku)
	ids_ro_serial_detail.setItem( ll_serial_row, 'country_of_origin', ls_coo)
	ids_ro_serial_detail.setItem( ll_serial_row, 'owner_id', ll_owner_id)
	ids_ro_serial_detail.setItem( ll_serial_row, 'line_item_no', ll_line_no)
	ids_ro_serial_detail.setItem( ll_serial_row, 'l_code', ls_loc)
	ids_ro_serial_detail.setItem( ll_serial_row, 'lot_no', ls_lot)
	ids_ro_serial_detail.setItem( ll_serial_row, 'po_no', ls_pono)
	ids_ro_serial_detail.setItem( ll_serial_row, 'po_no2', ls_pono2)
	ids_ro_serial_detail.setItem( ll_serial_row, 'container_id', ls_container_id)

	//Receive Serial Detail
	ids_ro_serial_detail.setItem( ll_serial_row, 'rsd_ro_no', as_ro_no)
	ids_ro_serial_detail.setItem( ll_serial_row, 'rsd_sku', ls_sku)
	ids_ro_serial_detail.setItem( ll_serial_row, 'rsd_serial_no', ls_serial)

	//find row on putaway and sum(qty)
	lsFind = "sku='"+ls_sku+"' and country_of_origin='"+ls_coo+"' and owner_id="+string(ll_owner_id)+" and line_item_no="+string(ll_line_no)
	lsFind += " and l_code ='"+ls_loc+"' and lot_no='"+ls_lot+"' and po_no='"+ls_pono+"' and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
	lsFind += " and serial_no='-'"
	
	ll_Find_Row = ids_ro_putaway.find( lsFind, 0, ll_putaway_count)

	//Write to File and Screen
	lsLogOut = '      - Cycle Count Up Count Zero- Processing of uf_create_up_count_zero_inbound_rollup - Putaway Row Found: '+string(ll_Find_Row)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	IF ll_Find_Row > 0 THEN
		
		//If Row found, sum qty, delete current row
		ids_ro_putaway.setItem( ll_Find_Row, 'quantity', ids_ro_putaway.getItemNumber(ll_Find_Row, 'quantity') + ll_qty)
		ids_ro_putaway.setItem(ll_row, 'serial_no', '-' )
		ids_ro_putaway.deleterow( ll_row)
	ELSE
		//set serial_no to '-' of current putaway row
		ids_ro_putaway.setItem( ll_row, 'serial_no', '-')
	END IF
	
Next

//remove filter
ids_ro_putaway.setfilter( "")
ids_ro_putaway.filter( )
ll_putaway_count = ids_ro_putaway.rowcount( )

//Write to File and Screen
lsLogOut = '      - Cycle Count Up Count Zero- End Processing of uf_create_up_count_zero_inbound_rollup & Putaway Count:  '+string(ll_putaway_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


Return 0
end function

public function integer uf_check_serial_number_exist (string as_project, string as_ccno, string as_wh, string as_location, string as_sku, string as_serialno);//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

//long ll_Idx
string lsSerialLoc, lsSerialWhCode, ls_NewSerialNo, lsTransParm
integer li_count
datetime ldtToday
string lsLogOut 

//string ls_WhCode, ls_CCNo
decimal ld_Avail_Qty

//long  ll_find , ll_Row,  ll_ContentRow
//long ll_owner_ID
//string lsOwnerCode

lsLogOut = '      - 3PL Cycle Count- Processing of uf_check_serial_number_exist - CC_No: '+as_ccno +' - Checking SKU /Loc /SN '+as_sku+'/'+as_location+'/'+as_serialno
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Check for Serial Numbers that are not in this location. 

SELECT count(*), l_code, Wh_Code INTO :li_count, :lsSerialLoc, :lsSerialWhCode FROM Serial_Number_Inventory With (NoLock)
	Where project_id = :as_project AND serial_no = :as_serialno and sku = :as_sku And (l_code <> :as_location OR wh_code <> :as_wh) 
	GROUP BY l_code, Wh_Code USING SQLCA;
				
If li_count > 0 Then
	
	
//	Set the location to the CycleCounted location. 
	Update  Serial_Number_Inventory SET l_code = :as_location, wh_code = :as_wh 
		Where project_id = :as_project AND serial_no = :as_serialno and sku = :as_sku and l_code = :lsSerialLoc and wh_code = :lsSerialWhCode USING SQLCA;

	lsLogOut = '      - 3PL Cycle Count- Processing of uf_check_serial_number_exist - CC_No: '+as_ccno +' - Found Exisitng SKU /WH Code /Loc /SN '+as_sku+'/'+lsSerialWhCode+'/'+lsSerialLoc+'/'+as_serialno
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)			
		
		
	SELECT sum(   dbo.Content_summary.Avail_Qty ) INTO :ld_Avail_Qty
	FROM dbo.Content_summary WITH (NOLOCK)
	WHERE 	( dbo.Content_summary.Avail_Qty > 0 ) 
	and project_id = :as_project
	 and content_summary.sku = :as_sku  and  content_summary.l_code = :lsSerialLoc  and content_summary.wh_code = :lsSerialWhCode USING SQLCA;

	If isNull(ld_Avail_Qty) then ld_Avail_Qty = 0

	if ld_Avail_Qty > 0 then
	
			
//		If Sqlca.sqlcode <> 0  Then
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment Create","Unable to update existing serial number in Serial_Number_Inventory table: ~r~r" + sqlca.sqlerrtext)
//			Return -1	
//		End IF

	
		//Create batch_transaction record for Serial Number Rec
		
		//Position in Trans Parm
		//WH_Code = 1-10
		//L_Code = 12-21
		//Sku = 23 -
				
//		ls_WhCode = mid(lsTrans_parm, 1, 10)
//		ls_LCode = mid( lsTrans_parm, 12, 10)
//		ls_Sku = mid(lsTrans_parm , 23)
		
		lsTransParm = lsSerialWhCode + space(10 - len(lsSerialWhCode)) + ":" + lsSerialLoc + space(10 - len(lsSerialLoc)) + ":" + as_sku
		
		//llAdjustID

		ldtToday = f_getLocalWorldTime( as_wh ) 
		
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
									Values(:as_project, 'SRCC', :as_ccno,'N', :ldtToday, :lsTransParm)
		Using SQLCA;		


		lsLogOut = '      - 3PL Cycle Count- Processing of uf_check_serial_number_exist - CC_No: '+as_ccno +' - Created SR Cycle Count for SKU /WH Code /Loc /SN '+as_sku+'/'+lsSerialWhCode+'/'+lsSerialLoc+'/'+as_serialno
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)		

//		If Sqlca.sqlcode <> 0  Then
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment_Create","Unable to create for existing serial number found in Inventory: ~r~r" + sqlca.sqlerrtext)
//			Return -1	
//		End IF		
	
	Else

		//Serial_number not in inventory so delete. 
		
		Update Serial_Number_Inventory Set l_code = 'UNKNOWN'
		Where project_id = :as_project AND serial_no = :as_serialno and sku = :as_sku and l_code = :as_location and wh_code = :lsSerialWhCode USING SQLCA;
		
		
//		Delete from  Serial_Number_Inventory 
//		Where project_id = :as_project AND serial_no = :as_serialno and sku = :as_sku and l_code = :as_location and wh_code = :lsSerialWhCode USING SQLCA;
		
//		If Sqlca.sqlcode <> 0  Then
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment_Create","Unable to update existing serial number in Serial_Number_Inventory table: ~r~r" + sqlca.sqlerrtext)
//			Return -1	
//		End IF			
			

	End IF
	
	Return 1
Else	
	Return 0
End IF
	




end function

public function integer uf_create_soc945_serial_adj (string as_project, string as_wh_code, string as_ownercd, long al_ownerid, string as_sku, string as_po_no, string as_serialno);//Create Auto-Confirm SOC from serial_adj

//string		ls_sku, ls_supp_code, ls_wh, ls_lcode, ls_Inv_Type, ls_lot_No, ls_po_No, ls_cc_no, ls_tran_ord_status
//string		ls_po_No2, ls_coo, ls_owner_cd, ls_Ro_No , ls_Sequence,
string		ls_tono, ls_SN_Ind, ls_req_SN, ls_lcode, ls_lot_No, ls_po_No2
string		ls_uf3, ls_Delete_ToNo, ls_Delete_List, lsLogOut
string		lsReturnTxt, lsListIgnored, lsListProcessed, ls_trans_parm, ls_container_Id, ls_formatted_ToNo
string		ls_serial_find

long		ll_Owner_Id, ll_Qty, ll_QtyCount, llLineItemNo, ll_row, ll_soc_sn_qty, ll_del_sn_count
long		ll_header_row, ll_detail_row, llFromOwnerId, llToOwnerId, ll_serial_row, ll_count, ll_serial
long		llReturnCode, llCntReceived, llCntIgnored, llCntProcessed, i, ll_cc_line_No, ll_tran_Id, ll_return, ll_rc

boolean 	lbSQLCAauto, lbAutoSOC
decimal  	ldToNo

Datetime ldt_Exp_Date, ldtWHTime

Str_Parms ls_serial_parms

Datastore ldsToHeader, ldsToDetail, ldsToSerial

SetPointer(HourGlass!)

If Not isvalid(ldsToHeader) Then
	ldsToHeader = Create u_ds_datastore
	ldsToHeader.dataobject= 'd_transfer_master'
	ldsToHeader.SetTransObject(SQLCA)
End If

If Not isvalid(ldsToDetail) Then
	ldsToDetail = Create u_ds_datastore
	ldsToDetail.dataobject= 'd_transfer_detail'
	ldsToDetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsToSerial) Then
	ldsToSerial = Create u_ds_datastore
	ldsToSerial.dataobject= 'd_alternate_serial_capture'
	ldsToSerial.SetTransObject(SQLCA)
End If

//ls_sku = as_soc_parms.string_arg[1]
//ls_supp_code= as_soc_parms.string_arg[2]
//ls_wh = as_soc_parms.string_arg[3]
//ls_lcode = as_soc_parms.string_arg[4]
//ls_Inv_Type= as_soc_parms.string_arg[5]
//ls_lot_No= as_soc_parms.string_arg[6]
//ls_po_No =as_soc_parms.string_arg[7]
//ls_po_No2 = as_soc_parms.string_arg[8]
//ls_coo = as_soc_parms.string_arg[9]
//ls_owner_cd =as_soc_parms.string_arg[10]
//ls_Ro_No = as_soc_parms.string_arg[11]
//ls_Sequence = as_soc_parms.string_arg[12]
//ls_cc_no = as_soc_parms.string_arg[13] //CC No
//ls_container_Id = as_soc_parms.string_arg[14] //Container Id
//
//
//ll_Owner_Id = as_soc_parms.long_arg[1]
//ll_cc_line_No = as_soc_parms.long_arg[2] //CC Line Item No
//ll_Qty = as_soc_parms.long_arg[3] //Old Qty
//ll_QtyCount = as_soc_parms.long_arg[4] //New Qty
//
//ldt_Exp_Date = as_soc_parms.datetime_arg[1]
//lbAutoSOC = as_soc_parms.boolean_arg[1]

//Write to File and Screen
lsLogOut = '      Start Processing of uf_create_soc945_serial_adj'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//building Transfer Header Records
sqlca.sp_next_avail_seq_no(as_project,"Transfer_Master","To_No" ,ldToNo) //get the next available To_No
If ldToNo <= 0 Then Return -1
ls_ToNo = as_project + String(Long(ldToNo),"000000")

//select owner_cd  into :ls_owner_cd  from Owner with(nolock)
//where project_id = :as_project and owner_id= :al_owner_id using sqlca;
//
ll_header_row = ldsToHeader.insertrow( 0)
ldsToHeader.SetItem(ll_header_row,'to_no', ls_ToNo)
ldsToHeader.SetItem(ll_header_row,'project_id', as_project)
ldsToHeader.SetItem(ll_header_row,'last_user', 'SIMSFP')
ldsToHeader.SetItem(ll_header_row, 'Ord_type', 'O')  /* Internal Order Type )  */
ldsToHeader.SetItem(ll_header_row, 'Ord_Status', 'N')
ldsToHeader.SetItem(ll_header_row, 'User_Field2', as_OwnerCD)
ldsToHeader.SetItem(ll_header_row, 'User_Field5', 'ADJ')


//is_ToNo_List[UpperBound(is_ToNo_List) +1] =ls_ToNo

////From Owner Code
//select owner_id into :llFromOwnerId  from Owner with(nolock)
//where project_id = :as_project and owner_cd = :ls_owner_cd using sqlca;
//
////From Warehouse
//select user_field2 into :lsFromWarehouse from Customer with(nolock)
//where project_id = :as_project and cust_code = :ls_owner_cd using sqlca;

ldsToHeader.SetItem(ll_header_row, 's_warehouse', as_wh_code)

ldtWHTime = f_getLocalWorldTime(as_wh_code)
ldsToHeader.SetItem(ll_header_row, 'ord_date', ldtWHTime)
ldsToHeader.SetItem(ll_header_row,'last_update', ldtWHTime)

////To Owner Code
//select owner_id into :llToOwnerId from Owner with(nolock)
//where project_id = :as_project and owner_cd = :ls_owner_cd using sqlca;
//
////To Warehouse
//select user_field2 into :lsToWarehouse 	from customer with(nolock)
//where project_id = :as_project and cust_code = :ls_owner_cd using sqlca;
//
ldsTOHeader.SetItem(ll_header_row, 'd_warehouse', as_wh_code)

//select Distinct(User_Field3) into :ls_uf3 from Transfer_Master with(nolock)
//where Project_id = :as_project and User_Field3 = :ls_sequence and Ord_status <> 'V' using sqlca;
//
//// If record already exists, check to see if it is new.  If so get TO_No so those new records can be deleted.
//If ls_uf3 =  ls_sequence then 
//	select TO_No into :ls_Delete_ToNo	from Transfer_Master with(nolock)
//	where Project_Id = :as_project and User_Field3 = :ls_uf3 and Ord_Status = 'N' using sqlca;
//					
//	//if ls_Delete_ToNo is populated, need to create/AddTo delete list, otherwise bail
//	If len(ls_Delete_ToNo) > 0 then
//		ls_Delete_List = ls_Delete_List + ',' +  ls_Delete_ToNo
//	else
//		gu_nvo_process_files.uf_writeError("Row: " + string(ll_header_row) + " MTR Nbr " + string(ls_sequence) + " - Owner Change Already Exists and is NOT 'New'") 
//		Return -1
//	End If
//End If

//ldsTOHeader.SetItem(ll_header_row, 'User_Field3', ls_sequence)

//Write to File and Screen
lsLogOut = '      - Processing of uf_create_soc945_serial_adj - Transfer Master Record: '+ls_ToNo
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select l_code, Lot_No, Po_No2, Carton_Id, Exp_Dt
into :ls_lcode, :ls_lot_No, :ls_po_No2, :ls_container_Id, :ldt_Exp_Date
from Serial_Number_Inventory with(nolock)
where wh_code=:as_wh_code
and sku= :as_sku
and Owner_Cd =:as_ownercd
and Serial_No =:as_serialno
using sqlca;		
		
//building Transfer Detail Records

llLineItemNo++
ll_detail_row =ldsToDetail.insertrow( 0)
ldsToDetail.SetItem(ll_detail_row,'To_No', ls_ToNo)
ldsToDetail.SetItem(ll_detail_row, 'Owner_id', al_ownerid)
ldsToDetail.SetItem(ll_detail_row, 'New_Owner_id', al_ownerid)
ldsToDetail.SetItem(ll_detail_row,'Inventory_Type', 'N') 
ldsToDetail.SetItem(ll_detail_row, 'New_Inventory_Type', 'N')
ldsToDetail.SetItem(ll_detail_row,'Supp_Code', 'PANDORA') 
ldsToDetail.SetItem(ll_detail_row,'Country_of_origin', 'XXX')   //Dummy value to save record. Not used in 945 SOC
ldsToDetail.SetItem(ll_detail_row,'Serial_No', '-')
ldsToDetail.SetItem(ll_detail_row,'Lot_No',  ls_lot_No) 
ldsToDetail.SetItem(ll_detail_row,'Po_No2', ls_po_No2)
ldsToDetail.SetItem(ll_detail_row,'Container_Id', ls_container_Id) 
ldsToDetail.SetItem(ll_detail_row,'Expiration_Date', ldt_Exp_Date) 
ldsToDetail.SetItem(ll_detail_row, 's_location', ls_lcode)	
ldsToDetail.SetItem(ll_detail_row, 'd_location', ls_lcode)
			
ldsToDetail.SetItem(ll_detail_row, 'sku', as_sku)
ldsToDetail.SetItem(ll_detail_row, 'Po_No', as_po_no)
ldsToDetail.SetItem(ll_detail_row, 'New_PO_NO', 'RESEARCH')
ldsToDetail.SetItem(ll_detail_row, 'Line_Item_No', llLineItemNo) //CC Line Item No
ldsToDetail.SetItem(ll_detail_row, 'User_Line_Item_No', llLineItemNo)
ldsToDetail.SetItem(ll_detail_row, 'Quantity', 1)

// (ll_Qty - ll_QtyCount)			
			
select serialized_Ind into :ls_SN_Ind from Item_Master with(nolock) 
where Project_Id= :as_project and sku=:as_sku and supp_code='PANDORA' using sqlca;

//Write to File and Screen
lsLogOut = '      -  Processing of uf_create_soc945_serial_adj - Transfer Detail Record: '+ls_ToNo + ' - SKU: '+as_sku+' - Serialized_Ind: ' + ls_SN_Ind
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If upper(ls_SN_Ind) <> 'N' Then
//	ls_serial_parms = this.uf_process_cc_auto_serialno_soc( as_project, ls_cc_no, ls_sku, ls_lcode, llFromOwnerId ,ls_po_no, ls_po_No2, ls_container_Id, (ll_Qty - ll_QtyCount), lbAutoSOC)
//
//	//retrive assigned serial no's from SOC Orders
//	If UpperBound(is_ToNo_List) > 0 Then ls_formatted_ToNo = in_string_util.of_format_string( is_ToNo_List, n_string_util.FORMAT1 )
//	idsAltSerialRecords = this.uf_process_cc_get_assigned_serialno( ls_formatted_ToNo, ls_sku)
//	
//	For ll_row =1 to UpperBound(ls_serial_parms.string_arg)
//		ls_req_SN = ls_serial_parms.string_arg[ll_row]
//
//		//find serial no on Alternate Serial Capture data store
//		ls_serial_find ="SKU_Parent ='"+ls_sku+"' and Serial_No_Parent ='"+ls_req_SN+"'"
//		ll_count = idsAltSerialRecords.find( ls_serial_find, 1, idsAltSerialRecords.rowcount( ))
//		
//		If ll_count =0  and ll_serial < (ll_Qty - ll_QtyCount) Then
//			//building Alternate Serial Capture Records
			ll_serial++
			ll_serial_row = ldsToSerial.insertrow( 0)
			
			ls_req_SN = as_serialno
			
			ldsToSerial.setItem( ll_serial_row, 'SKU_Parent', trim(as_sku))
			ldsToSerial.setItem( ll_serial_row, 'Supp_Code_Parent', 'PANDORA')
			ldsToSerial.setItem( ll_serial_row, 'Alt_Sku_Parent', trim(as_sku))
			ldsToSerial.setItem( ll_serial_row, 'Serial_No_Parent', trim(ls_req_SN))
			ldsToSerial.setItem( ll_serial_row, 'SKU_Child', trim(as_sku))
			ldsToSerial.setItem( ll_serial_row, 'Supp_Code_Child', 'PANDORA')
			ldsToSerial.setItem( ll_serial_row, 'Alt_Sku_Child', trim(as_sku))
			ldsToSerial.setItem( ll_serial_row, 'Last_Update', today())
			ldsToSerial.setItem( ll_serial_row, 'Last_User', 'SIMSFP')
			ldsToSerial.setItem( ll_serial_row, 'Serial_No_Child', trim(ls_req_SN))
			ldsToSerial.setItem( ll_serial_row, 'To_No', trim(ls_ToNo))
			ldsToSerial.setItem( ll_serial_row, 'To_Line_Item_No', llLineItemNo)
			
			//Write to File and Screen
			lsLogOut = '      - Processing of uf_create_soc945_serial_adj  - Transfer Serial Detail Record: '+as_sku + ' / '+ ls_ToNo +' / ' +ls_req_SN+' / '
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
//		End If
//	Next
End If

//Write to File and Screen
lsLogOut = '      -  Processing of uf_create_soc945_serial_adj  - Transfer Detail Record: '+ls_ToNo + ' -SQLCA.Return Code: '+string(sqlca.sqlcode)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Insert into DB
If ldsToHeader.rowcount( ) > 0 Then ll_rc = ldsToHeader.update()
If ll_rc > 0 and ldsToDetail.rowcount( ) > 0 Then ll_rc = ldsToDetail.update( )
If ll_rc > 0 and ldsToSerial.rowcount( ) > 0 Then ll_rc = ldsToSerial.update()

If ll_rc =1 Then
	COMMIT;
	if SQLCA.sqlcode = 0 then
		ldsToHeader.resetupdate( )
		ldsToDetail.resetupdate()
		ldsToSerial.resetupdate( )
	else
		ROLLBACK;
		ldsToHeader.resetupdate( )
		ldsToDetail.resetupdate()
		ldsToSerial.resetupdate( )
		
		//Write to File and Screen
		lsLogOut = '      - Error Processing of uf_create_soc945_serial_adj()  Error: '+ nz(SQLCA.SQLErrText,'-') + ' Error Code: '+string(SQLCA.sqlcode)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if

else
	ROLLBACK;
	//Write to File and Screen
	lsLogOut = '      - Error Processing of uf_create_soc945_serial_adj()  Error: '+ nz(SQLCA.SQLErrText, '-') +' Record save failed' + ' Error Code: '+string(SQLCA.sqlcode)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Write to File and Screen
lsLogOut = '     -End Processing of uf_create_soc945_serial_adj() - Insertion Successfully Completed.!'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//If len(ls_Delete_List) > 0 Then
//	// Stirp of leading comma
//	ls_Delete_List =  right(ls_Delete_List, len(ls_Delete_List) - 1)
//	DELETE FROM Transfer_Detail_Content  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
//	DELETE FROM Transfer_Detail  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
//	DELETE FROM Transfer_Master  WHERE TO_No in  (:ls_Delete_List)   USING sqlca;
//End If
//
////Write to File and Screen
//lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - Is High Value Item: ' +string(lbAutoSOC) + ' - execute Auto SOC'
//FileWrite(giLogFileNo,lsLogOut)
//gu_nvo_process_files.uf_write_log(lsLogOut)
//
//ls_sequence = ls_sequence +"|"
//lbSQLCAauto = SQLCA.AutoCommit
//SQLCA.AutoCommit = true
//
//f_method_trace_special( as_project, this.ClassName() + ' - uf_process_cc_auto_confirm', 'Start Auto SOC CC Stored Procedure' ,ls_ToNo, '','',ls_sequence)										
//sqlca.Sp_Auto_SOC_CC('O', ls_sequence, ls_cc_no, ll_cc_line_No, lsReturnTxt, llReturnCode, llCntReceived, llCntIgnored, lsListIgnored, llCntProcessed, lsListProcessed) 	//Execute Stored Procedure	
//SQLCA.AutoCommit = lbSQLCAauto
//
//f_method_trace_special( as_project, this.ClassName() + ' - uf_process_cc_auto_confirm', 'End Auto SOC CC Stored Procedure ' + lsReturnTxt + 'Return code ' + String(llReturnCode),ls_ToNo, '','',ls_sequence)	
//
//select Ord_status into :ls_tran_ord_status  from Transfer_Master with(nolock) 
//where Project_Id =:as_project and To_No =:ls_ToNo
//using sqlca;
//
////Write to File and Screen
//lsLogOut = '      - 3PL Cycle Count-  Processing of uf_process_cc_auto_confirm_soc  and CC_No: '+ls_cc_no +' - Transfer Detail Record: '+ls_ToNo + ' - After Auto SOC Result: '+nz(lsReturnTxt,'-') +'  - Transfer Ord Status: '+nz(ls_tran_ord_status, '-')
//FileWrite(giLogFileNo,lsLogOut)
//gu_nvo_process_files.uf_write_log(lsLogOut)
//
//Write to File and Screen
lsLogOut = '      - End Processing of uf_create_soc945_serial_adj'
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//uf_process_oc_om(as_project, ls_ToNo, )
Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date) //Trans_Parm
			Values(:as_project, 'OC', :ls_ToNo,'N', :ldtWHTime  );  //isDetailRecordsToReConfirm

destroy ldsToHeader
destroy ldsToDetail
destroy ldsToSerial

Return 0
end function

on u_nvo_edi_confirmations_pandora.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_pandora.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_string_util = CREATE n_string_util
string ls_empty[]
is_ToNo_List= ls_empty
end event

