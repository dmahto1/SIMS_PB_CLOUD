$PBExportHeader$w_ro.srw
$PBExportComments$*+receiving order
forward
global type w_ro from w_std_master_detail
end type
type cb_custom2 from commandbutton within tabpage_main
end type
type cb_custom1 from commandbutton within tabpage_main
end type
type cb_backorder from commandbutton within tabpage_main
end type
type cb_address from commandbutton within tabpage_main
end type
type cb_shipment from commandbutton within tabpage_main
end type
type cb_confirm from commandbutton within tabpage_main
end type
type cb_void from commandbutton within tabpage_main
end type
type sle_orderno from singlelineedit within tabpage_main
end type
type sle_order2 from singlelineedit within tabpage_main
end type
type cb_open_do from commandbutton within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type st_ro_order_no from statictext within tabpage_main
end type
type cb_ro_search from commandbutton within tabpage_search
end type
type cb_ro_clear from commandbutton within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type uo_mobile_status from uo_multi_select_search within tabpage_search
end type
type dw_condition from u_dw_ancestor within tabpage_search
end type
type tabpage_other_info from userobject within tab_main
end type
type dw_other from u_dw_ro_master_uf within tabpage_other_info
end type
type tabpage_other_info from userobject within tab_main
dw_other dw_other
end type
type tabpage_orderdetail from userobject within tab_main
end type
type st_ro_verify_sku_text from statictext within tabpage_orderdetail
end type
type sle_verify from singlelineedit within tabpage_orderdetail
end type
type cb_ims_verify from commandbutton within tabpage_orderdetail
end type
type cb_iqc from commandbutton within tabpage_orderdetail
end type
type cb_insert from commandbutton within tabpage_orderdetail
end type
type cb_delete from commandbutton within tabpage_orderdetail
end type
type cb_list_sku from commandbutton within tabpage_orderdetail
end type
type dw_detail from u_dw_ancestor within tabpage_orderdetail
end type
type dw_list_sku from datawindow within tabpage_orderdetail
end type
type tabpage_orderdetail from userobject within tab_main
st_ro_verify_sku_text st_ro_verify_sku_text
sle_verify sle_verify
cb_ims_verify cb_ims_verify
cb_iqc cb_iqc
cb_insert cb_insert
cb_delete cb_delete
cb_list_sku cb_list_sku
dw_detail dw_detail
dw_list_sku dw_list_sku
end type
type tabpage_putaway from userobject within tab_main
end type
type cbx_autofill from checkbox within tabpage_putaway
end type
type dw_putaway_mobile from u_dw_ancestor within tabpage_putaway
end type
type cb_emc from commandbutton within tabpage_putaway
end type
type cb_putaway_pallets from commandbutton within tabpage_putaway
end type
type cb_print_cn from commandbutton within tabpage_putaway
end type
type cbx_show_comp from checkbox within tabpage_putaway
end type
type cb_generate from commandbutton within tabpage_putaway
end type
type cb_insertrow from commandbutton within tabpage_putaway
end type
type cb_deleterow from commandbutton within tabpage_putaway
end type
type cb_putaway_locs from commandbutton within tabpage_putaway
end type
type cb_copyrow from commandbutton within tabpage_putaway
end type
type cb_print from commandbutton within tabpage_putaway
end type
type dw_print from datawindow within tabpage_putaway
end type
type dw_content from u_dw_ancestor within tabpage_putaway
end type
type dw_carton_serial from datawindow within tabpage_putaway
end type
type dw_putaway from u_dw_ancestor within tabpage_putaway
end type
type tabpage_putaway from userobject within tab_main
cbx_autofill cbx_autofill
dw_putaway_mobile dw_putaway_mobile
cb_emc cb_emc
cb_putaway_pallets cb_putaway_pallets
cb_print_cn cb_print_cn
cbx_show_comp cbx_show_comp
cb_generate cb_generate
cb_insertrow cb_insertrow
cb_deleterow cb_deleterow
cb_putaway_locs cb_putaway_locs
cb_copyrow cb_copyrow
cb_print cb_print
dw_print dw_print
dw_content dw_content
dw_carton_serial dw_carton_serial
dw_putaway dw_putaway
end type
type tabpage_notes from userobject within tab_main
end type
type dw_notes from u_dw_ancestor within tabpage_notes
end type
type tabpage_notes from userobject within tab_main
dw_notes dw_notes
end type
type tabpage_rma_serial from userobject within tab_main
end type
type cb_delete_row from commandbutton within tabpage_rma_serial
end type
type cb_copy_row from commandbutton within tabpage_rma_serial
end type
type rb_auto from radiobutton within tabpage_rma_serial
end type
type rb_manual from radiobutton within tabpage_rma_serial
end type
type st_message from statictext within tabpage_rma_serial
end type
type sle_rma_barcode from singlelineedit within tabpage_rma_serial
end type
type dw_rma_serial from u_dw_ancestor within tabpage_rma_serial
end type
type gb_1 from groupbox within tabpage_rma_serial
end type
type tabpage_rma_serial from userobject within tab_main
cb_delete_row cb_delete_row
cb_copy_row cb_copy_row
rb_auto rb_auto
rb_manual rb_manual
st_message st_message
sle_rma_barcode sle_rma_barcode
dw_rma_serial dw_rma_serial
gb_1 gb_1
end type
type dw_scanner from datawindow within w_ro
end type
type dw_custom_report from datawindow within w_ro
end type
end forward

global type w_ro from w_std_master_detail
integer width = 3977
integer height = 2188
string title = "Receiving Order"
event ue_confirm ( )
event ue_generate_putaway ( )
event ue_backorder ( )
event ue_asn ( )
event ue_post_confirm ( )
event ue_process_shipments ( )
event ue_workorder ( )
event ue_sort_putaway ( )
event ue_generate_putaway_server ( )
event ue_assign_locations_server ( )
dw_scanner dw_scanner
dw_custom_report dw_custom_report
end type
global w_ro w_ro

type variables
Datawindow   idw_main, idw_search, idw_detail
Datawindow   idw_putaway, idw_condition, idw_scanner, idw_rma_Serial
Datawindow   idw_content, idw_list_sku, idw_print, idw_Notes
Datawindow   idw_carton_serial, idw_other, idw_Putaway_mobile

Datawindowchild idwc_supplier
// TAM W&S 2010/12 For wine and spirit make UF2 a Dropdown
// GWM 2015/04/06 Add dropdown for UOM
Datawindowchild idwc_uom

Datawindowchild idwc_detail_uf2
//TimA Pandora issue #560
Datawindowchild idwc_IM_Coo_Detail,idwc_IM_Coo_Putaway,idwc_currency

w_ro iw_window
Integer ii_return
SingleLineEdit isle_whcode,isle_code, isle_order2
string is_sql,isSetColumn
string is_rono, isCurrentSKU 
String is_bolno, isOrigSQLSerial, isCarton
string is_project_uf1
String is_bonded // TAM W&S 2012/12
string is_Inbound_ord_Ind

String	isScanColumn
 
Boolean ib_import, ibConfirmRequested, ibManualScan, ibWORequested, ibMultipleSKU, ibSkuScanned
long	ilCurrPutawayRow,ilComprow, ilCompNumber
//string is_Serialized_Ind,is_po_indicator,is_lot_indicator

n_warehouse i_nwarehouse
boolean ib_srch_order_from_first
boolean ib_srch_order_to_first
boolean ib_srch_receive_from_first
boolean ib_srch_receive_to_first
boolean ib_srch_complete_from_first
boolean ib_srch_complete_to_first
boolean idw_putaway_has_focus  // 06/28/2010 ujhall: 03 of 07:  Validate Inbound Serial Numbers
boolean ib_OrdStatusReset // 1/26/2011; David C; Indicator if admin reset order status
boolean ib_save_via_confirm  // 02/21/2011 ujh: I-135  true when ue_save is called from ue_confirm
boolean ibFootprint				//07/02/2019 GailM Change ibLPN to ibFootPrint - 08/29/2013 GailM Pandora Issue #608 License Plate Project
boolean ibDejaVu	// 08/15/2014 Pandora Issue #883 - DejaVu IB orders w/containerID must be scanned
boolean ibDejaVu_Asked, ibDejaVu_Override //work around for DejaVu orders. the ...Override is in the lookup table to turn this on or off.  The ...Asked is for individual order
boolean ibMIM   //GailM 07/03/2017 - SIMSPEVS-654 - PAN SIMS allow container/serial capture in 2D Barcode - BOX ID
boolean ib_inbound //03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement

u_nvo_carton_serial_scanning iuo_carton_serial_scanning
u_nvo_check_digit_validations iuo_check_digit_validations

inet	linit
u_nvo_websphere_post	iuoWebsphere

// pvh - 03.10.06 MARL
constant string MARLAdjustReason = 'MARL Change'
constant string ManualAdjustReason = 'Manual Change'

datastore	idsItemMaster
datastore	idsRLScan
datastore	idsMarlAdjustment
datastore 	idsDOPicking

string 		isRLSkuList[]
string		isQualityHoldFlag[]
  string		isRLSkuMARL[]
long		ilAdjustmentRow
long        ilRowLastChild   //02/21/2011 ujh: I-135  This the compute_1 column (ROW) on dw_putaway

// pvh - bluecoat 
constant string  isEDIIn = 'EDI_Inbound_Header'
constant string  isEDIOut = 'EDI_Outbound_Header'
constant long  ii3comOwner = 106885 
//constant int failure = -1
//constant int success = 0
constant int one = 1
boolean ibUpdateEdi
string isEDIDirection
long	ilErrorRow
long	ilEdiBatchNo
long ilEdiOrderLineNo
long ilEdiOrderSeq
long ilEdiBatchNoIn
long ilEdiOrderLineNoIn
long ilEdiOrderSeqIn
datastore idsEdiBatchHead
datastore idsEdiBatchDetail
datastore idsEdiContainers		// Gailm - 08/15/22014 - Issue 883 - DejuVu orders required to scan containerIDs

Long ilComponenttRow
Long ilComponenttInsertRow

Boolean ib_ConfirmFail  //TimA 04/06/11

string isGenericSearchColumnNameValue[]


// LTK 20111101	Variables used to store background color expressions which will be set upon the postopen event.
// GailM 8/18/2014 - Deja Vu requires scanning by container ID
String is_lot_no_init_bg_color, is_lot_no_scan_bg_color
String is_po_no_init_bg_color, is_po_no_scan_bg_color
String is_po_no2_init_bg_color, is_po_no2_scan_bg_color
String is_container_init_bg_color, is_container_scan_bg_color

str_pscan_resp str_resp //hdc 10/12/2012  holds return values from physio "scan or generate" prompt
long ll_Row, retCode
String is_suppinvoiceno  //08-Feb-2013  :Madhu added

//MEA - 4/13 - OTM
String isDeleteSkus[]  //Capture Sku's before the order is deleted
String isRoNoDelete
String isFlagDeleteOTM
n_otm 	in_otm

//TimA 04/09/14 Pandore issue #36
CommandButton  icb_confirm
String isDetailRecordsToReConfirm

Boolean	ibSRNotifiedLot,ibSRNotifiedPO, ibSRNotifiedPO2, ibSRNotifiedInvType, ibSRNotifiedExpDT

boolean ib_batchconfirmmode	// LTK 20150129  Added for Pandora batch confirm
string is_batch_message[] 	

//TimA 02/06/15 variable to show if the scanned container ID is on the row they are scanning
Boolean id_CurrentRowContainerIdFound
Boolean ib_show_mobile_status = false
Boolean ibkeytype =FALSE //17-Aug-2015 :Madhu- Added to prevent Manul scanning
Boolean ibmouseclick =FALSE //17-Aug-2015 :Madhu- Added to prevent Manul scanning
Boolean ibPressF10Unlock =FALSE //17-Aug-2015 :Madhu- Added to prevent Manul scanning

//TimA 10/22/15 Flag.  If the order is from WMS like a warehouse transfer.
Boolean ibFromWMS = FALSE
String is_dangerous_item //08-Jun-2016 Madhu Added for Commodity Authorized User
Long il_detail_row	//08-Jun-2016 Madhu Added for Commodity Authorized User

//GailM 07/13/2017 SIMSPEVS-737 PAN SIMS Soft warning for two separate owner codes on one location
Boolean ib_allow_multi_owner_per_location = FALSE
Boolean ib_has_allowed_multi_owner_per_location = FALSE
String isAllowMultiOwnerPerLocation	

Boolean ib_vendor_label_compliant =FALSE //28-JULY-2018 :Madhu S21780 Label Consolidation
Boolean ib_serialized_present	//GailM 7/23/2019 Related to S31781 F14974 Putaway Serial RollUp

Boolean ib_AutoFill_Putaway_Pallet = FALSE
Boolean ib_AutoFill_Putaway_Container = FALSE

Boolean ib_AutoFill_Shift_Select = false
Long 	   il_AutoFill_Start_Row = 0
end variables

forward prototypes
public function integer wf_set_comp_filter (string as_action)
public function string wf_generate_pulse_imi ()
public function integer wf_create_comp_child (long alrow)
public function integer wf_validation ()
public subroutine wf_clear_screen ()
public function integer wf_check_confirm ()
public subroutine wf_checkstatus ()
public function integer doaccepttext ()
public function boolean doduplicateputawaycheck (long arow)
public function integer getmaxlineitemnumber (ref datawindow _dw, string _colname)
public function integer getrlskulistcount ()
public function integer domarlcheck ()
public function str_parms getrlskulist ()
public function integer getindexforsku (string _sku)
public function integer dorlvalidate ()
public subroutine setinventorytype ()
public subroutine setrlskulist ()
public function boolean isvalidmarl (string _marl)
public subroutine setqualityholdarray (string _sku, long _itemrow)
public subroutine setmarlarray (string _sku, string _qualityholdflag, string _marl)
public function integer getmarllistcount ()
public subroutine setqualityholdrows ()
public function integer doqualityholdvalidate ()
public subroutine setrlskuarray (string _sku)
public function integer wf_set_supplier_visibility ()
public function integer setedibatchno (string _tablename)
public function long getedibatchno ()
public function integer getediorderseq ()
public subroutine setediorderseq ()
public subroutine setedilineno (integer _value)
public subroutine setedilineno ()
public function integer getedilineno ()
public function integer doedidetail (long _index, long _lineitemno)
public subroutine setedibatchheader ()
public subroutine setedibatchdetail (long putawayrow)
public subroutine setedidirection (string value)
public function string getedidirection ()
public subroutine setupdateedi (boolean value)
public function boolean getupdateedi ()
public subroutine doclearadjustments ()
public function boolean getadjustmentexists (long putawayrow)
public subroutine docreatebatchtrans ()
public function long getnewadjustmentrow ()
public function integer getadjustments ()
public subroutine setadjustmentrow (long value)
public function long getadjustmentrow ()
public function boolean isskubundled (string _sku, string _supplier)
public function long getinventoryitem (string _sku, string _supplier)
public subroutine doresetarrays ()
public function integer doadjustmentwork (long arow, string oldtype, string newtype, string reason)
public function integer setadjustmentrecord (long workingrow, long putawayrow, string oldinv, string newinv, string reason)
public subroutine dodeleteadjustmentrow (string theline, string thesku)
public subroutine dodisplaymessage (string _title, string _message)
public function integer wf_coo_validation (datawindow adw_serial, integer al_row)
public function integer wf_check_warranty (datawindow adw_serial, string as_sku, string as_supp_code, string as_serial, long al_findrow)
public function integer uf_validate_container (string asdata)
public function integer wf_lock (boolean ab_lock)
public function boolean f_processtransordertype (string as_transtype, string as_ordtype)
public function string uf_get_next_container_id (string asgroup)
public function integer wf_create_rma_address (string ascustcode)
public function boolean f_setdetaildescription (long al_rownum)
public function boolean f_checkforalphachar (string as_stringtocheck, ref boolean ab_hasalpha)
public function integer uf_comcast_update_carton_serial (integer airow)
public function integer wf_detail_vs_putaway ()
public function string wf_pandora_save_validations ()
public function integer wf_refresh_qa_check_ind (string as_sku, string as_supp_code, long al_owner_id)
public function integer wf_check_status_emc ()
public function integer uf_config_custom_buttons ()
public function integer uf_print_nike_receiving_rpt ()
public function integer uf_print_nike_tally_sheet ()
public function date wf_calculate_rdd (date as_date, string as_wh_code, string as_cust_code, string as_from_wh_code, ref string as_message)
public function integer wf_export_ws_tradenet ()
public subroutine getdeletedskus ()
public function string uf_get_custom_column_setting (datawindow a_dw, string a_column, integer a_row)
protected function boolean wf_select_reconfirm_records (string as_rono)
public function integer wf_export ()
public function integer wf_display_message (string as_message)
public function integer wf_display_message (string as_title, string as_message)
public subroutine uf_showhide_status (string as_status)
public function integer wf_check_status_mobile ()
public function boolean wf_is_xx_coo_check_excluded (string as_supp_invoice_no)
public function integer wf_check_commodity_authorized_user ()
public function boolean f_check_dims (long al_rownum)
public function integer uf_om_expansion (long llbatchseqno, long llnewbatchseqno)
public function integer uf_replace_all_pono2_containerid_values (string as_col_name, string as_old_col_value, string as_new_col_value)
public function long wf_putaway_release_mobile_validation ()
public subroutine wf_min_shelf_life_inbound_validation (boolean lbgenerateputaway)
public function integer wf_edi_inbound_expansion (string as_orderno, long al_batchseq, long al_new_batchseq)
public function integer wf_generate_putaway_serial_records ()
public function any wf_get_rma_serial_list (string as_sku, long al_id_no)
public subroutine wf_set_rma_serial_tab_status ()
public function integer wf_validate_container_against_edi_record ()
public function integer wf_alt_rma_serial_save (datawindow adw)
public function integer wf_autofill_putaway_container_pallet (string as_column_name, integer ai_row, string as_value)
public function boolean f_is_pandora_pharmacy_location (string aswarehouse, string aslocation)
public function string f_is_kitting_location_occupied (string aswhcode, string aslocation, string assku)
public function string getloctype (string aswhcode, string aslocation)
public subroutine f_crossdock ()
end prototypes

event ue_confirm();boolean	lb_gotserial, lb_error_dup_sn, lbCreateBackorder, lb_Error, lbReconfirm

Decimal	ldTotalrcvQty, ld_NxtSeq, ldTotalQty_Putaway
DateTime	ldtToday, ldtExpDT

integer	liMsg, liCrap, i_indx, li_count, li_blank_emc_codes

long	ll_return, ll_totalrows,i, ll_new, llFindRow,	llRowPos, llRowCOunt, llownerid, ll_owner_id, ll_quantity
long	ll_GRN_No, ll_Component_No, ll_error_dup_sn_cnt, ll_method_trace_id,llrecord1, ll_id_no
long	ll_serial_count, ll_serial_find_row, ll_serial_row

String		lsRONO, lsFind,	lsFind2, lsOrder, lsSKU, lsOrdStat, lsOwnerName,	ls_InActiveCustomerName, ls_Sub_Inventory_Type
String		ls_CustCode, ls_CustType, lsWhCode, lsOwnerCd, lsSerialNo, lsSerializedInd, ls_po_no2_controlled_ind, ls_container_tracking_ind
String		ls_Component_Ind, ls_Find, ls_dup_sku_serial, ls_wh_code, ls_order_type, lsGRP, lsMsg, ls_serialized_ind
String 	lsLoc, lsLocHold, lsLocType, ls_Supp_GRN, lsContainerID, ls_sqlsyntax, lsLot, lsPO, lsPO2,  lsInvType, lsHoldStatus
String 	ab_error_message_title, ab_error_message, ls_serial_list[] ,ls_empty_list[]
String 	ls_uf7, ls_uf6, ls_uf5, ls_uf9, ls_transport_mode, ls_uf2, ls_cuf2_2, ls_cuf2_6 //SIMSPEVS-785
String 	ls_uf2CustType, ls_uf6CustType //TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" customers(UF2) or from_location(UF6)
String		lsPutawayContainer, lsPutawayPONO2
Boolean	lbPandoraPharmacyLocation
int liAdj

/* GailM - 03/01/2018 - S16211 - PAN SIMS to validate Arrival Date upon confirmation on Inbound - START */
Date ldToday

// 01/20 - PCONKL - F20487/S41494 - Determine if this is a Pandora Pharmacy Location. Currently, it is at the warehouse level. If we have to go to the Location level
//			We will need to move it to the Putaway Loop
ls_wh_code = Upper(idw_main.getitemstring(1,'wh_code'))
lbPandoraPharmacyLocation = f_is_pandora_pharmacy_location(ls_wh_code,'')

// cawikholm 07/05/11 Added call to track user 

SetMicroHelp("Pre-confirmation processing...")

IF Left(icb_confirm.Text,2 ) <> 'Re' THEN
	lbReconfirm = False
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','start ue_confirm: ',is_rono,' ',' ' ,is_suppinvoiceno)
else
	//TimA 04/09/14 Re-Confirm was pressed
	lbReconfirm = True
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','start Re-confirm: ',is_rono,' ',' ' ,is_suppinvoiceno)
END IF

// ET3 2012-06-14: Implement generic test
IF g.ibSNchainofcustody THEN
	//BCR 06-DEC-2011: Treat Bluecoat same as Pandora...
	//if upper(gs_project) = 'PANDORA' OR upper(gs_project) = 'BLUECOAT' then
	//IF gs_project = "PANDORA" THEN
	ls_wh_code = Upper(idw_main.getitemstring(1,'wh_code'))
	
	//3/10 JAyres Check to see if Customer is Active
	If  tab_main.tabpage_orderdetail.dw_detail.RowCount() > 0 then
		FOR i_indx = 1 to tab_main.tabpage_orderdetail.dw_detail.RowCount() 
			llOwnerID 		= tab_main.tabpage_orderdetail.dw_detail.GetItemNumber(i_indx,"owner_id")
			lsOwnername 	=tab_main.tabpage_orderdetail.dw_detail.GetItemString(i_indx,"c_owner_name")
			If Right(Trim(lsOwnername), 3) = '(C)' Then
			
				Select Distinct dbo.Customer.Cust_Name
					Into 	:ls_INActiveCustomerName
				FROM 	dbo.Owner with(nolock), dbo.Customer with(nolock)
				Where dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
				and  	dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
				and 	dbo.Owner.Owner_ID 			= :llOwnerID
				and 	dbo.Customer.Customer_Type = 'IN' 
				and 	dbo.Owner.Project_ID 		= :gs_project;
			
				If NOT ( ls_INActiveCustomerName = '' or IsNULL(ls_INActiveCustomerName) ) Then
					If IsNULL(lsOwnername) Then lsOwnername = ''
				//MessageBox(is_title, "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i_indx) +" of Order Detail.~r~rPlease Enter an Active Owner then Save." )	
				wf_display_message("Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i_indx) +" of Order Detail.~r~rPlease Enter an Active Owner then Save.")	// LTK 20150130 batch confirm
				return
				End If
			End If
		Next	
	End If //detail rows...
	
	//3/10 JAyres Check to see if Owner is Active
	// dts 2011-02-16 (need to show children (do we need to check the 'show components' check box?))
	//  - 2/22 - now handled elsewhere (see //MAS 021511 changes)
	//if tab_main.tabpage_putaway.cbx_show_comp.enabled = true then
	//	tab_main.tabpage_putaway.cbx_show_comp.checked = true
	//	wf_Set_comp_filter('Set')
	//end if
	If tab_main.tabpage_putaway.dw_putaway.RowCount() > 0 then
		FOR i_indx = 1 to tab_main.tabpage_putaway.dw_putaway.RowCount()
		
			lsSerialNo = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Serial_no')
			lsSerializedInd = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Serialized_Ind')
			// 8/13 GailM #608
			ls_po_no2_controlled_ind = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'po_no2_controlled_ind')
			ls_container_tracking_ind = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'container_tracking_ind')
			
			// if this line item is serialized,
			// 01/03/2011 ujh:  See (12/22/2010 ujh: In Discussion with Dave agreed to change the test below from 'i' to 'y'
			If lower(lsSerializedInd) = 'b' or lower(lsSerializedInd) = 'y' then
			
				// See if we've entered at least one serial number.
				lb_gotserial = len(trim(lsSerialNo)) > 0
				
				// If we have entered at least one serial number,
				If lb_gotserial then
					// Get the quantity for the line item.
					ll_quantity = tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx, 'quantity')
					
					// lb_gotserial is true now only if the quantity is one except for carton/pallet validation.  Pandora Issue #608.
					lb_gotserial = ll_quantity >= 1
					// End If we have entered at least one serial number
				End If
				
				If not lb_gotserial then
					//messagebox(is_title, "Not all serial numbers have been entered.")
					wf_display_message("Not all serial numbers have been entered.")	// LTK 20150130 batch confirm
					lb_Error = true
					return
				End IF
			End If // End if this line item is serialized.
			
			llOwnerID 		=  tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx,"owner_id")
			lsOwnername 	=  tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx,"c_owner_name")
			If Right(Trim(lsOwnername), 3) = '(C)' Then
				Select Distinct 	dbo.Customer.Cust_Name
				Into    			:ls_INActiveCustomerName
				FROM 			dbo.Owner with(nolock), dbo.Customer with(nolock)
				Where 			dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
				and    		dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
				and 			dbo.Owner.Owner_ID 		= :llOwnerID
				and 			dbo.Customer.Customer_Type 	= 'IN' 
				and 			dbo.Owner.Project_ID 		= :gs_project;
				
				If NOT ( ls_INActiveCustomerName = '' or IsNULL(ls_INActiveCustomerName) ) Then
					If IsNULL(lsOwnername) Then lsOwnername = ''
					//MessageBox(is_title, "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i_indx) +" of Put Away List.~r~rPlease Enter an Active Owner then Save." )	
					wf_display_message("Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i_indx) +" of Put Away List.~r~rPlease Enter an Active Owner then Save.")	// LTK 20150130 batch confirm
					return
				End If
			End If
			
			// dts - 09/29/10 - now mandating cross-dock location for crossdock orders
			//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse - Putaway + Merge cross-dock with DA kitting
			lsLoc = idw_putaway.GetItemString(i_indx, 'l_code')
			if lsLoc <> lsLocHold then
				Select l_type into :lsLocType
				From	location with(nolock)
				Where wh_code = :ls_wh_code and l_code = :lsLoc
				Using SQLCA;
				
				If lsLocType <> '9' and  idw_main.GetItemString(1, "crossdock_ind") = 'Y' Then
					//messagebox(is_title, "Cross-dock orders must be put-away in a cross-dock location!", StopSign!)
					wf_display_message("Cross-dock orders must be put-away in a cross-dock location!")	// LTK 20150130 batch confirm
					Return
				ElseIf lsLocType = 'Z' and gs_project = 'PANDORA' and ls_po_no2_controlled_ind = "Y" and ls_container_tracking_ind = "Y" Then
					wf_display_message("You have chosen a KITTING location.  Pallet IDs and Container IDs will be removed from inventory content upon confirmation of this order")	
					idw_putaway.SetItem(i_indx, 'container_id', gsFootPrintBlankInd)
					idw_putaway.SetItem(i_indx, 'po_no2', gsFootPrintBlankInd)
					//Need to update content/content summary with another rono.  
				End If
				lsLocHold = lsLoc
			end if
		Next
	
		// LTK 20110711  Pandora #222  If the sum quantity of the Put Away rows is zero, do not allow confirmation.
		if idw_putaway.object.compute_2[1] <= 0 then
			//MessageBox(is_title, "Sum of the Put Away records must be greater than zero.", StopSign!)
			wf_display_message("Sum of the Put Away records must be greater than zero.")	// LTK 20150130 batch confirm
			Return
		end if
	
		// LTK 20110722  Pandora - Add additional over/under receiving sum check per Dave.
		if idw_detail.RowCount() > 0 and idw_putaway.RowCount() > 0 then
		
			//TAM 2013/11/08 Need to check for (B)oth as well
			//			if idw_detail.object.compute_2[1] < idw_putaway.object.compute_2[1] and g.isvalidatePutaway <> 'Y' then
			if idw_detail.object.compute_2[1] < idw_putaway.object.compute_2[1] and g.isvalidatePutaway <> 'Y'  and g.isvalidatePutaway <> 'B' then
				//Messagebox(is_title,"This project does not allow for over receiving.",StopSign!)
				wf_display_message("This project does not allow for over receiving.")	// LTK 20150130 batch confirm
				Return
			end if
		
			//TAM 2013/11/08 Need to check for (B)oth as well
			//			if idw_detail.object.compute_2[1] > idw_putaway.object.compute_2[1] and g.isvalidatePutaway <> 'U' then
			if idw_detail.object.compute_2[1] > idw_putaway.object.compute_2[1] and g.isvalidatePutaway <> 'U'  and g.isvalidatePutaway <> 'B' then
				//Messagebox(is_title,"This project does not allow for under receiving.",StopSign!)
				wf_display_message("This project does not allow for under receiving.")	// LTK 20150130 batch confirm
				Return
			end if
		
		end if
	End If //put-away rows....	
END IF //Pandora (chainOfCustody)

// pvh - gmt 11/22/05
if idw_main.rowcount() > 0 then
	ldtToday = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
else
	ldtToday = f_getLocalWorldTime( gs_default_wh  ) 
end if

If idw_detail.rowcount() <= 0 then
	//messagebox(is_title,'Please input 1 or more order detail lines first.')
	wf_display_message('Please input 1 or more order detail lines first.')	// LTK 20150130 batch confirm
	return
end if


If idw_putaway.rowcount() <= 0 then 
	//messagebox(is_title,'Please complete the Putaway List first.')
	wf_display_message('Please complete the Putaway List first.')	// LTK 20150130 batch confirm
	return
end if


// pvh - 09/12/05 - COO on putaway - refactor validation
if doAcceptText() < 0 then return

//03/03 - PCONKL - Make sure the order was not confirmed or Voided by another user 
lsRONO = idw_main.GetITemString(1,'Ro_no')

Select ord_status Into :lsOrdStat
From Receive_Master with(nolock)
Where Project_ID = :gs_Project and ro_no = :lsRONo;

//TimA 04/09/14 we are now allowing Re-Confirms
If lsordStat = 'C'  and lbReconfirm = False Then  /*already Confirmed, can't Confirm*/
	//Messagebox(is_Title,'This Order was already confirmed or by another user. It can not be Confirmed!',StopSign!)
	wf_display_message('This Order was already confirmed or by another user. It can not be Confirmed!')	// LTK 20150130 batch confirm
	ib_changed = False
	isle_code.TriggerEvent('Modified')
	Return
ElseIf lsordStat = 'V' Then /*already  Voided*/
	//Messagebox(is_Title,'This Order was already Voided or by another user. It can not be Confirmed!',StopSign!)
	wf_display_message('This Order was already Voided or by another user. It can not be Confirmed!')	// LTK 20150130 batch confirm
	ib_changed = False
	isle_code.TriggerEvent('Modified')
	Return
End If

//
// 07/00 PCONKL - We will only be validating Putaway locations ( 07/04 - and required fields) on confirmation. This will allow a putawaylist
//						to be printed without locations
//TimA 04/09/14
IF lbReconfirm = False THEN
	ibConfirmRequested = True 
Else
	ibConfirmRequested = False
END IF

// 08/13 GailM #608 Set ibFootprint replaces ibLPN
IF upper(gs_project) = 'PANDORA'  and upper(lsSerializedInd) = 'B' and upper(ls_po_no2_controlled_ind) = 'Y' and upper(ls_container_tracking_ind) = 'Y' THEN
	ibFootprint = false	//GailM - 2/14/2018 - Footprint
Else
	ibFootprint = false
END IF

//TimA 04/09/14 We only need to validate data on the Confirm
IF lbReconfirm = False THEN
	//Gailm #608 - 9/5/2013 - call wf_validation() only for nonLPN GPNs.  wf_validation will be called in ue_save during Save only
	If NOT ibFootprint Then
		//Validate
		If wf_validation() = -1 Then
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','Validation Error message occured.  Confirmed Failed: ',is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 : Madhu added			
			ibConfirmRequested = False
			Return
		End If
	End If
END IF


SetMicroHelp("Processing project level confirmation checks...")

// 10/03 - PCONKL - Project level confirmation checks
//TimA 04/09/14
IF lbReconfirm = False THEN
	If wf_check_confirm() = -1 Then
		ibConfirmRequested = False
		Return
	End If
END IF

If ib_changed Then
	SetMicroHelp("Ready")
	//messagebox(is_title,'Please save changes first!',StopSign!)
	wf_display_message('Please save changes first!')	// LTK 20150130 batch confirm
	return
End If



//All manually-entered Orders must be MATERIAL RECEIPT in UF7

//If UF7 = PO RECEIPT or EXP PO RECEIPT, then no FROM Location (and we shouldn't require it) if UF7 = MATERIAL RECEIPT, then FROM Location must be valid Pandora location (Customer)
//Pandora Checks - Validation
//12/09/09: UJHALL; ls_uf3 Xchanged for ls_uf6
ldToday = Date(ldtToday) //Local WH Date

Time ltCutoffTime = Time( "14:00" )
Time ltArrivalTime 

ltArrivalTime = Time(  idw_main.GetItemDateTime(1, "Arrival_Date" ) )

IF gs_project = 'PANDORA' THEN

	/* GailM - 03/01/2018 -- START */
	IF IsNull(idw_main.GetItemDateTime(1, "Arrival_Date" ) ) THEN
		lsMsg = "Please enter a valid Arrival Date!"
		MessageBox(is_title, lsMsg, StopSign!)	
		tab_main.SelectTab(1 ) 
		f_setfocus(idw_main, i, "Arrival_Date")
		Return		
	ELSE
		If f_validate_datetime(idw_main.GetItemDateTime(1, "Arrival_Date")) = 0 Then
			lsMsg = "Arrival Date is not a valid date!"
			MessageBox(is_title, lsMsg, StopSign!)	
			tab_main.SelectTab(1 ) 
			f_setfocus(idw_main, i, "Arrival_Date")
			Return
		End if
	
		If Date( idw_main.GetItemDateTime(1, "Arrival_Date" ) ) > ldToday Then
			lsMsg = "The Arrival Date cannot be greater than Current Date!!~r~n~r~nCurrentDate: " + &
			String( ldToday, 'yyyy/mm/dd' )+ "~r~n                vs~r~nArrivalDate:  " +&
			String( idw_main.GetItemDateTime(1, "Arrival_Date" ), 'yyyy/mm/dd' ) + " "
			wf_display_message(is_title, lsMsg )	
			tab_main.SelectTab(1 ) 
			f_setfocus(idw_main, i, "Arrival_Date")
			Return		
		End If		
	
		If  Date( idw_main.GetItemDateTime(1, "Arrival_Date" ) ) <  Date( idw_main.GetItemDateTime(1, "Ord_Date" ) ) Then
			lsMsg = "The Arrival Date cannot be before Order Date. Please correct the Arrival Date!~rAre you sure you want to proceed?"
			If MessageBox( is_title, lsMsg, Exclamation!, YesNo!,2 ) <> 1 Then
				tab_main.SelectTab(1 ) 
				f_setfocus(idw_main, i, "Arrival_Date")
				Return		
			End If
		End If		
	
		If  Date( idw_main.GetItemDateTime(1, "Arrival_Date" ) ) =  ldToday Then
			If  ltArrivalTime <  ltCutoffTime Then
				lsMsg = "The Arrival DateTime is before cut off Datetime.~r~n~r~nAre you sure you want to confirm the order? Y/N"
				If MessageBox( is_title, lsMsg, Exclamation!, YesNo!,2 ) <> 1 Then
					tab_main.SelectTab(1 ) 
					f_setfocus(idw_main, i, "Arrival_Date")
					Return		
				End If
			End If		
		
			If  ltArrivalTime >  ltCutoffTime Then
				lsMsg = "The Arrival DateTime is after cut off Datetime.~r~n~r~nAre you sure you want to confirm the order? Y/N"
				If MessageBox( is_title, lsMsg, Exclamation!, YesNo!,2 ) <> 1 Then
					tab_main.SelectTab(1 ) 
					f_setfocus(idw_main, i, "Arrival_Date")
					Return		
				End If
			End If		
		End If
	
	End IF /* STOP S16211 Arrival Date Validation */
	
	ls_uf7 = idw_main.GetItemString( 1,"user_Field7")
	
	//GailM - 8/26/2017 - SIMSPEVS-785 PAN SIMS to prevent the same WhCode/OwnerCode on receipt to stop 4B2
	ls_uf2 = idw_main.GetItemString( 1,"user_Field2")
	
	//12/09/2009: UJHALL;  Xchange UF3 for UF6
	//ls_uf3 = idw_main.GetItemString( 1,"user_Field3")
	ls_uf6 = idw_main.GetItemString( 1,"user_Field6")
	//Dinesh - 04/12/2021- S54935- Google - SIMS – 947 change needed for Google SAP
	select count(*) into :liAdj from lookup_table with(nolock) where code_type='ORDER_CONFIRM_ADJ' and code_id=:ls_uf6;
	
	// Removed SIMSPEVS-785 (part of 17-9.1) which will be deployed after 17-10 release
	If ls_uf6 = ls_uf2 Then
		SetMicroHelp("Ready")
		wf_display_message("Ship FROM Location and the Sub Inv Location cannot be the same warehouse.") //SIMSPEVS-785
		return
	Else
		//TAM - 3/18 - S13945 -  Added customer type to the SQL
		SELECT user_field2, customer_type  INTO :ls_cuf2_2, :ls_uf2CustType FROM Customer
		WHERE Cust_Code = :ls_uf2 AND Project_ID = 'PANDORA' 
		USING SQLCA;
	
		if sqlca.SQlcode <> 0 then				/* 01/18 - GailM - DE2663 */
			wf_display_message("Warning while testing SubInv Location","Possible missing curtomer record on SubInv Loc (UserField2).  Error: " + String(SQLCA.SQLCode) + " - " + SQLCA.SQLErrText)	
		end if
	
		//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" customers(UF2) or from_location(UF6)
		If  ls_uf2CustType = 'IN' Then		
			SetMicroHelp("Ready")
			wf_display_message("The Sub Inv Location cannot be INACTIVE.")	
			return
		End If 
	
		//TAM - 3/18 - S13945 -  Added customer type to the SQL
		SELECT user_field2, customer_type  INTO :ls_cuf2_6, :ls_uf6CustType FROM Customer
		WHERE Cust_Code = :ls_uf6 AND Project_ID = 'PANDORA' 
		USING SQLCA;
	
		if sqlca.SQlcode <> 0 then				/* 01/18 - GailM - DE2663 */
			wf_display_message("Warning while testing From Location","Possible missing curtomer record on From Location (UserField6).  Error: " + String(SQLCA.SQLCode) + " - " + SQLCA.SQLErrText)	
		end if
	
		If  ls_cuf2_2 = ls_cuf2_6 Then		//Both warehouses are the same
			SetMicroHelp("Ready")
			wf_display_message("Ship FROM Location and the Sub Inv Location cannot be the same warehouse.")	//SIMSPEVS-785
			return
		End If 
	
		//TAM - 3/18 - S13945 -  For Pandora, Don't allow "INACTIVE" customers(UF2) or from_location(UF6)
		If  ls_uf6CustType = 'IN'  Then	
			SetMicroHelp("Ready")
			wf_display_message("The Ship FROM Location cannot be INACTIVE.")	
			return
		End If 
	End If   				// End of 785     Will be put back in after 17-10 release 
	
	IF ls_uf7 = "MATERIAL RECEIPT" THEN
		SELECT customer_type INTO :ls_CustType FROM Customer
		WHERE Cust_Code = :ls_uf6 AND Project_ID = 'PANDORA' 
		USING SQLCA;
		
		if sqlca.SQlcode <> 0 then
			//MessageBox ("DB Error", SQLCA.SQLErrText)
			//wf_display_message(SQLCA.SQLErrText)		// LTK 20150130 batch confirm
			wf_display_message("A database error has occured - DB Error: " + SQLCA.SQLErrText + ".~n Report error to system administrator.") 	// 01/18 - GailM - DE2663 - Need more message than blank
		end if
		
		If ls_CustType = '' or IsNull(ls_CustType) Then
			SetMicroHelp("Ready")
			//MessageBox (is_Title, "FROM Location must be a valid Customer.")
			wf_display_message("FROM Location must be a valid Customer.")	// LTK 20150130 batch confirm
			return
		else
			ls_order_type = Upper(idw_main.getitemstring(1,'ord_type'))
			//TAM - No Longer a valid edit when Pandora starts sending the 3B2s for warhouse transfers.  This is part of the shipment Id project
			//			if ls_CustType = 'WH' and ls_order_type <> 'Z' and ls_order_type <> 'Y' then
			//				SetMicroHelp("Ready")
			//				//MessageBox (is_Title, "From Location '" + ls_uf6 + "' not valid for selected oder type.~r~rOnly Warehouse Transfers and Intermediate Receipts can have a Warehouse-type Customer in From Location.")
			//				wf_display_message("From Location '" + ls_uf6 + "' not valid for selected oder type.~r~rOnly Warehouse Transfers and Intermediate Receipts can have a Warehouse-type Customer in From Location.")	// LTK 20150130 batch confirm
			//				return
			//			end if
		End If
	END IF
	
	IF upper(trim(ls_uf7)) = "PO RECEIPT"  OR upper(trim(ls_uf7)) = "EXP PO RECEIPT" THEN
		//Make User_Field5 (Country of Dispatch) on Inbound required where UF7 = PO RECEIPT (and EXP PO RECEIPT)
		ls_uf5 = idw_main.GetItemString( 1,"user_Field5")
		IF IsNull(ls_uf5) OR trim(ls_uf5) = "" THEN
			SetMicroHelp("Ready")
			//MessageBox (is_Title, "County of Dispatch (UF5) is required.")
			wf_display_message("County of Dispatch (UF5) is required.")	// LTK 20150130 batch confirm
			idw_main.SetColumn("user_Field5")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			return 			
		END IF
		
		//Valid UF5 against Country Table
		If NOT isnull(ls_uf5) AND Trim(ls_uf5) <> '' Then
			SELECT Count(ISO_Country_Cd) INTO :li_count 
			FROM Country
			WHERE Designating_Code = :ls_uf5 USING SQLCA;
			
			If li_Count <= 0 Then
				SetMicroHelp("Ready")
				//MessageBox (is_Title, "County of Dispatch (UF5) is invalid.")
				wf_display_message("County of Dispatch (UF5) is invalid.")	// LTK 20150130 batch confirm
				idw_main.SetColumn("user_Field5")
				tab_main.SelectTab(1)
				idw_main.SetFocus()
				return 
			End IF
		END IF
		
		
		//Make User_Field9 (Vendor Name) on Inbound required where UF7 = PO RECEIPT (and EXP PO RECEIPT)
		
		ls_uf9 = idw_main.GetItemString( 1,"user_Field9")
		
		//01-SEP-2017 :Madhu - commented as requested by Roy
		//SIMSPEVS-804 PINT for 17_9.1 deploy gwm
		/*IF IsNull(ls_uf9) OR trim(ls_uf9) = "" THEN
		SetMicroHelp("Ready")
		//MessageBox (is_Title, "Vendor Name (UF9) is required.")
		wf_display_message("Vendor Name (UF9) is required.")	// LTK 20150130 batch confirm
		idw_main.SetColumn("user_Field9")
		tab_main.SelectTab(1)
		idw_main.SetFocus()
		return 			
		
		END IF*/
	END IF //UF7 condition
	
	//Make Transport Mode mandatory for Inbound.
	
	ls_transport_mode = idw_main.GetItemString( 1,"transport_mode")
	
	IF IsNull(ls_transport_mode) OR trim(ls_transport_mode) = "" THEN
		SetMicroHelp("Ready")
		//MessageBox (is_Title, "Transport Mode is required.")
		wf_display_message("Transport Mode is required.")	// LTK 20150130 batch confirm
		idw_main.SetColumn("transport_mode")
		tab_main.SelectTab(1) 
		idw_main.SetFocus()
		return 			
	END IF
	
	// GailM - 8/28/2014 - Pandora Issue 883 - DejaVu ContainerID must be scanned prior to confirmation
	//dts 10/16/14 - building in a work-around for SuperDuper users to get around orders that are incorrectly deemed DejaVu (while we wait for action on Pandora IT's part regarding rules)
	If ibDejaVu and ibDejaVu_Override and gs_role = '-1' and not ibDejaVu_Asked Then
		if not ib_batchconfirmmode then	// LTK 20150130 batch confirm
			If Messagebox('DejaVu Prompt for SuperDuper Users, in ue_confirm', 'This order is Marked DejaVu. Leave as DejaVu?',Question!,YesNo!,1) = 2 Then
				ibDejaVu = false
			else
				ibDejaVu_Asked = true
			End If
		end if
	end if		
	
	If ibDejaVu  Then
		//dts - 10/16/23 need to change how container scanning is validated as we see orders with the quantity from the detail line split over multiple containers.
		//Now comparing the quantities of Put-away and Detail but that doesn't address mixed DejaVu/non-DejaVu (though not sure that's in scope).
		// - If Mixed DejaVu/Non-DejaVu is valid, we should cycle through putaway, sorted by line number and then if the line has a container, sum the qty and compare that to the detail line qty
		//    if there is a discrepancy, throw a message, specifying the line #.
		ll_totalrows = 0
		ldTotalQty_putaway = 0
		llRowCOunt = idw_putaway.RowCount()
		//sum the quantities of the put-away
		for llRowPos = 1 to llRowCount
			ls_Find =  idw_putaway.GetItemString(llRowPos,'container_id')
	
			//if ls_Find <> '' Then ll_totalrows ++
			if ls_Find <> '-' and ls_Find <> '' Then 
				ll_totalrows ++
				ldTotalQty_Putaway = ldTotalQty_Putaway + idw_putaway.GetItemNumber(llRowPos, 'quantity')
			end if
		next

		//now sum the quantities of the detail
		ldTotalRcvQty = 0
		llRowCount = idw_detail.RowCount()
		for llRowPos = 1 to llRowCount
			ldTotalRcvQty = ldTotalRcvQty + idw_detail.GetItemNumber(llRowPos, 'alloc_qty')
		next
	
		//If ll_totalrows <> idw_detail.RowCount() Then
		if ldTotalQty_Putaway <> ldTotalRcvQty then
			//MessageBox (is_Title, "Containers must be scanned prior to confirmation")
			//MessageBox (is_Title, "Quantity for Scanned Containers does not match Received Quantity.")
			wf_display_message("Quantity for Scanned Containers does not match Received Quantity.")	// LTK 20150130 batch confirm
			tab_main.SelectTab(3)
			idw_putaway.SetFocus()
			idw_putaway.SetColumn(25)
			SetMicroHelp("Ready")
			return 		
		End If
	End If //dejavu
END IF /*Pandora*/

//TAM - W&S 2011/04  -   GRN is Formatted.   
IF gs_project = 'WS-PR'  and Upper(idw_main.getitemstring(1,'ord_type')) = 'S' THEN
	ls_Supp_GRN = idw_main.GetITemString(1,'supp_code') + '_GRN'
	ll_grn_no = g.of_next_db_seq(gs_project,ls_Supp_GRN,'GRN')
	If ll_grn_no <= 0 Then
		//messagebox(is_title,"Unable to retrieve the next available GRN Number!")
		wf_display_message("Unable to retrieve the next available GRN Number!")	// LTK 20150130 batch confirm
		Return 
	End If
	idw_main.SetItem(1, "user_field9", idw_main.GetITemString(1,'supp_code') + String(ll_grn_no,'000000')) 
END IF

// 09/02 - PCONKL - remove a filtered Putaway list (Components, etc.)
wf_set_comp_filter('Remove')

Setpointer(Hourglass!) 

// 05/01 PCONKL - If not everything was received, we will give the option to create a backorder.

lsOrder = idw_main.getitemstring(1,'supp_invoice_no')

//12/06 - PCONKL - validate against Over/Under Receiving Indicator
IF lbReconfirm = False THEN
	//TimA 04/09/14 Since the order was already validated on the confirm we don't need to do this again
	Choose Case g.isvalidatePutaway
	
	case 'N' /*Neither allowed*/
	
		If idw_detail.Find("alloc_qty <> req_qty",1,idw_detail.RowCount()) > 0 Then
			//Messagebox(is_title,'One or more items have over or under received.~r~rThis project does not allow for over/Under receiving',StopSign!)
			wf_display_message('One or more items have over or under received.~r~rThis project does not allow for over/Under receiving')	// LTK 20150130 batch confirm
			Return
		End If
	
	Case 'U' /*Under allowed, Over not*/
	
		If idw_detail.Find("alloc_qty > req_qty",1,idw_detail.RowCount()) > 0 Then
			//Messagebox(is_title,'One or more items have been over received.~r~rThis project does not allow for over receiving',StopSign!)
			wf_display_message('One or more items have been over received.~r~rThis project does not allow for over receiving')	// LTK 20150130 batch confirm
			Return
		End If
	
	Case 'Y' /* Over Allowed, under not*/
	
		If idw_detail.Find("alloc_qty < req_qty",1,idw_detail.RowCount()) > 0 Then
			//Messagebox(is_title,'One or more items have been under received. ~r~rThis project does not allow for under receiving',StopSign!)
			wf_display_message('One or more items have been under received. ~r~rThis project does not allow for under receiving')	// LTK 20150130 batch confirm
			Return
		End If
	
	End Choose
	
END IF

//08-Jun-2016 :Madhu- added for Commodity Authorized User - START
IF g.ibcommodityauthorizeduser THEN
	If wf_check_commodity_authorized_user () = -1 Then
		MessageBox(is_title,"You're not authorized for processing Restricted Commodity Item(s)# " + is_dangerous_item)
		tab_main.SelectTab(3)
		idw_detail.setrow( il_detail_row)
		idw_detail.setcolumn( "sku")
		idw_detail.setfocus( )
		SetMicroHelp("Save failed!")
		Return
	End If
END IF
//08-Jun-2016 :Madhu- added for Commodity Authorized User - END

//TimA 04/09/14
IF lbReconfirm = False THEN
	if not ib_batchconfirmmode then	// LTK 20150130
		if messagebox(is_title,'Are you sure you want to confirm this order?',Question!,YesNo!,2) = 2 then
			SetMicroHelp("Ready")
			return
		End if
	end if
ELSE
	if not ib_batchconfirmmode then	// LTK 20150130
		if messagebox(is_title,'Are you sure you want to Re-confirm this order?',Question!,YesNo!,2) = 2 then
			SetMicroHelp("Ready")
			return
		End if
	end if
END IF


SetMicroHelp("Begin confirmation...")
//
// 09/06 - PCONKL - Backorder ability controlled by project level flag...
// 10/07 - PCONKL - Account for Damage Qty when calculating shortage
// 07/12/2012 Jxlim CR06 Physio-Automatic created  back order and added FIREEYE project as well
//TimA 04/09/14 We only need to check on backorders on the confirm
IF lbReconfirm = False THEN
	If idw_detail.Find("req_qty > (alloc_qty + damage_qty)",1,idw_detail.RowCount()) > 0 and g.isReceiptBackOrder = 'Y' Then
	
		//Jxlim 08/08/2012 Added back-order creation automatic for PHYSIO
		// 05/10/2010 - dts - making back-order creation automatic for Pandora
		//if gs_Project = 'PANDORA' then
		//if gs_Project = 'PANDORA' or Left(gs_Project, 6) = 'PHYSIO' or gs_Project = 'FIREEYE' Then Not sure why this one doesn't work
		if gs_Project = 'PANDORA' or gs_Project = 'PHYSIO AMS' or gs_Project = 'PHYSIO MAA' or gs_Project = 'PHYSIO-XD' or gs_Project = 'PHYSIO-MAA' or gs_Project = 'FIREEYE' Then
			liMsg = 1
		else
			if not ib_batchconfirmmode then	// LTK 20150130
				liMsg =  MessageBox("Back Order?","One or more items of this order were not received in full.~r~rWould you like to create a Back Order for the remaining item(s)?",Question!,yesNoCancel!,1) 
			end if
		end if
		
		Choose Case liMsg
			Case 1 /*create backorder*/
				lbCreateBackorder = True /*create after confirm is completed*/
			Case 2 /*no*/
			Case 3 /*Cancel confirm*/
			Return /*dont confirm*/
		End Choose
	End If

	//TimA 03/18/11
	// if upper(gs_project) = 'PANDORA' then  nxjain - 07-19-2013 
	if g.ibSNchainofcustody  then
		//Beginning the trasaction here because if the save fails when trying to save the serial numbers we need to rollback records to content.
		//This was moved from down below
		Execute Immediate "Begin Transaction" using SQLCA; 
		//*********************
		//	TimA
		
		// ****     NOTE: WE SHOULD NOT HAVE ANY VALIDATION OR MESSAGE BOXES BELOW THIS LINE OF CODE. ******
		//***********************************************************************************************************************
		//***********************************************************************************************************************
	end if
END IF

// 04/13 - PCONKL - For Starbucks, we want to set the po_no on Content (and thus Putaway) to Supp Code + ReceiptDate (YYYYMMDD)
// 05/13 - MEA - Changed that to update only if the Order Type = PLCDC. 
// 05/13 - MEA - Fixed to check backorder.

//8	STBTH     	8	PLCDC	menlo\bxtan	5/31/2013 03:12:03:783	N

//Can you just do it based on retrieving the receive_master.ord_type where ro_no = the min(ro_no) where supp_invoice_no = $$HEX1$$2620$$ENDHEX$$

boolean lb_update_po
string ls_back_order_ord_type


//TimA 04/09/14 only do this on the first Confirmation
If lbReconfirm = False Then 
	SetMicroHelp("Creating Inventory from Putaway List...")
	
	//Create new content records
	//08/01 PCONKL - Line Item No has been added - Putway records may need to be rolled up to a single content if there are duplicate sku
	idw_content.Reset()
	ll_totalrows = idw_putaway.rowcount()
	
	FOR i = 1 to ll_totalrows
		
		lssku = idw_putaway.getItemString(i, 'sku')
		ls_serialized_ind = idw_putaway.getItemString(i, 'serialized_ind')
		ll_id_no = idw_putaway.getItemNumber(i, 'id_no')
		ls_serial_list =ls_empty_list
		
		//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START					
		IF g.ib_receive_putaway_serial_rollup_ind and (ls_serialized_ind='Y' or ls_serialized_ind = 'B') THEN	//DE11788
			ls_serial_list = wf_get_rma_serial_list(lssku, ll_id_no)
		ELSE
			ls_serial_list[UpperBound(ls_serial_list)+1] = idw_putaway.getItemString(i, 'serial_no')
		END IF
		//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
		
		// 06/15 - PCONKL - We may have already written to Content from mobile or elsewhere. If so, don't re-write here...
		If not isnull(idw_putaway.GetItemString(i, 'Content_Record_Created_Ind')) and idw_putaway.GetItemString(i, 'Content_Record_Created_Ind') = 'Y' Then
			Continue
		End If
		
		FOR ll_serial_row = 1 to UpperBound(ls_serial_list)
			
			lsSerialNo = ls_serial_list[ll_serial_row]
			If IsNull(lsSerialNo) or lsSerialNo = '' Then lsSerialNo = '-'		//Do not allow serial to be NULL or blank
			
			// 01/20 - PCONKL - F20487/S41494 - For Pandora, If a Pharmacy location, we are going to strip off the po_no2/Container_ID values and replace with 'NA'
			//			We may be rolling up across these values
			//			 For now, 'Location' is at the warehouse level and has been determined above. If we need to determine at the location level, we will need to make the call here
			If gs_project = 'PANDORA' and lbPandoraPharmacyLocation Then
				
				If idw_putaway.getitemstring(i,'po_no2') <> '-' Then
					lsPutawayPONO2 = 'NA'
				Else
					lsPutawayPONO2 = '-'
				End If
				
				If idw_putaway.getitemstring(i,'container_ID') <> '-' Then
					lsPutawayContainer = 'NA'
				Else
					lsPutawayContainer = '-'
				End If
				
			Else
				lsPutawayPONO2 = idw_putaway.getitemstring(i,'po_no2')
				lsPutawayContainer = idw_putaway.getitemstring(i,'container_ID')
			End If
			
			//See if the row already exists for this sku/supplier/coo/owner/loc/inv type
			lsFind = "Upper(sku) = '" + Upper(idw_putaway.getitemstring(i,'sku')) + "' and Upper(supp_code) = '" + Upper(idw_putaway.getitemstring(i,'supp_code')) + "'"
			lsFind += " and Upper(country_of_origin) = '" + Upper(idw_putaway.getitemstring(i,'country_of_origin')) + "' and Owner_id = " + String(idw_putaway.getitemnumber(i,'owner_id'))
			lsFind += " and Upper(wh_code) = '" + Upper(idw_main.getitemstring(1,'wh_code')) + "' and Upper(l_code) = '" + Upper(idw_putaway.getitemstring(i,'l_code')) + "'"
			lsFind += " and Upper(inventory_type) = '" + Upper(idw_putaway.getitemstring(i,'inventory_type')) + "'" 
			lsFind += " and Upper(lot_no) = '" + Upper(idw_putaway.getitemstring(i,'lot_no')) + "'"
			lsFind += " and Upper(po_no) = '" + upper(idw_putaway.getitemstring(i,'po_no')) + "'"
			lsFind += " and Upper(po_no2) = '" + Upper(lsPutawayPONO2) + "' and Upper(ro_no) = '" + Upper(idw_putaway.getitemstring(i,'ro_no')) + "'"
			lsFind += " and Upper(container_ID) = '" + Upper(lsPutawayContainer) + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(idw_putaway.getitemdateTime(i,'expiration_date'),'mm/dd/yyyy hh:mm') + "'"  /* 11/02 - PCONKL */
			
			// 02/10 - PCONKL - If we have components that are serialized both (we are not writing to content), we need to combine Putaways with different Component NO into a single component_no in Content. Otherwise we will have a PK violation
			If idw_putaway.getitemnumber(i,'component_no') > 0 and idw_putaway.GetITemString(i,'Serialized_ind') = 'B' Then
			
				//find the First Component No for this Line/SKU
				lsFind2 =  "Upper(sku) = '" + Upper(idw_putaway.getitemstring(i,'sku')) + "' and Upper(supp_code) = '" + Upper(idw_putaway.getitemstring(i,'supp_code')) + "'"
				lsFind2 += " and Upper(country_of_origin) = '" + Upper(idw_putaway.getitemstring(i,'country_of_origin')) + "' and Owner_id = " + String(idw_putaway.getitemnumber(i,'owner_id'))
				lsFind2 +=  " and Upper(l_code) = '" + Upper(idw_putaway.getitemstring(i,'l_code')) + "'"
				lsFind2 += " and Upper(inventory_type) = '" + Upper(idw_putaway.getitemstring(i,'inventory_type')) + "'" 
				lsFind2 += " and Upper(po_no) = '" + upper(idw_putaway.getitemstring(i,'po_no')) + "'"
				lsFind2 += " and Upper(po_no2) = '" + Upper(idw_putaway.getitemstring(i,'po_no2')) + "' and Upper(ro_no) = '" + Upper(idw_putaway.getitemstring(i,'ro_no')) + "'"
				lsFind2 += " and Upper(container_ID) = '" + Upper(idw_putaway.getitemstring(i,'container_ID')) + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(idw_putaway.getitemdateTime(i,'expiration_date'),'mm/dd/yyyy hh:mm') + "'"
				
				llFindRow = idw_Putaway.Find(lsFind2,1,idw_putaway.RowCount())
				If llFindRow > 0 and llFindRow < i Then
					lsFind += " and component_no = " + String(idw_putaway.getitemnumber(llFindRow,'component_no')) 
				Else
					lsFind += " and component_no = " + String(idw_putaway.getitemnumber(i,'component_no')) 
				End If
			Else
				lsFind += " and component_no = " + String(idw_putaway.getitemnumber(i,'component_no')) 
			End If
			
			
			// 02/09 - PCONKL - Serialized_Ind of 'B' - Capture at Inbound (and outbound) but DON'T write to content
			If idw_putaway.getitemstring(i,'serialized_ind') <> 'B' Then /*either saving Serial # */
				//lsFind += " and upper(serial_no) = '" + Upper(idw_putaway.getitemstring(i,'serial_no')) + "'"
				lsFind += " and upper(serial_no) = '" + lsSerialNo + "'" //5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
			End If
						
			llFindRow = idw_Content.Find(lsFind,1,idw_Content.RowCount())
			If llFindRow > 0 Then /*update qty on existing record*/
			
				If idw_putaway.GetITemString(i,"component_ind") = '*' or idw_putaway.GetITemString(i,"component_ind") = 'B' Then /* 09/02 - Pconkl - 'B' = Both (child and parent) */
						idw_content.setitem(llFindRow,'component_qty',(idw_content.GetItemNumber(llFindRow,'component_qty') + idw_putaway.getitemnumber(i,'quantity')))
				Else
					//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
					if lsSerialNo='-' or isnull(lsSerialNo) or lsSerialNo='' then
						idw_content.setitem(llFindRow,'avail_qty',(idw_content.GetItemNumber(llFindRow,'avail_qty') + idw_putaway.getitemnumber(i,'quantity')))
					else
						idw_content.setitem(llFindRow,'avail_qty',(idw_content.GetItemNumber(llFindRow,'avail_qty') + 1)) //serial No always has Qty# 1
					end if
					//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
				End If
					
			Else /* create a new content record*/
				
				//TAM - W&S 2010/12  -   W&S Don't create a content record for Wine and spirit if the quantity = 0.  We want to create a backorder for these tp capture the lottable fields
				//Left 3 characters = WS- for Wine and Spirt.
				If Left(gs_project,3) = 'WS-'  and   idw_putaway.getitemnumber(i,'quantity') = 0  Then
				
				Else
					ll_new = idw_content.insertrow(0)
					idw_content.accepttext()
					idw_content.setitem(ll_new,'project_id',gs_project)
					idw_content.setitem(ll_new,'sku',idw_putaway.getitemstring(i,'sku'))
					idw_content.setitem(ll_new,'supp_code',idw_putaway.getitemstring(i,'supp_code'))
					idw_content.setitem(ll_new,'country_of_origin',idw_putaway.getitemstring(i,'country_of_origin'))
					idw_content.setitem(ll_new,'owner_id',idw_putaway.getitemnumber(i,'owner_id'))	
					idw_content.setitem(ll_new,'component_no',idw_putaway.getitemnumber(i,'component_no'))
					idw_content.setitem(ll_new,'wh_code',idw_main.getitemstring(1,'wh_code'))
					idw_content.setitem(ll_new,'l_code',idw_putaway.getitemstring(i,'l_code'))
					idw_content.setitem(ll_new,'inventory_type',idw_putaway.getitemstring(i,'inventory_type'))
					idw_content.setitem(ll_new,'lot_no',Trim(idw_putaway.getitemstring(i,'lot_no')))
					idw_content.setitem(ll_new,'po_no',Trim(idw_putaway.getitemstring(i,'po_no'))) 
				//	idw_content.setitem(ll_new,'po_no2',Trim(idw_putaway.getitemstring(i,'po_no2'))) 
					idw_content.setitem(ll_new,'po_no2',Trim(lsPutawayPONO2)) /* 01/20 - PCONKL*/
				//	idw_content.setitem(ll_new,'container_ID',idw_putaway.getitemstring(i,'container_ID')) /* 11/02 PCONKL */
					idw_content.setitem(ll_new,'container_ID',lsPutawayContainer) /* 01/20 PCONKL */
					idw_content.setitem(ll_new,'expiration_Date',idw_putaway.getitemDateTime(i,'expiration_Date')) /* 11/02 PCONKL */
					idw_content.setitem(ll_new,'cntnr_length',idw_putaway.getitemNumber(i,'length')) /* 01/03 PCONKL */
					idw_content.setitem(ll_new,'cntnr_width',idw_putaway.getitemNumber(i,'Width')) /* 01/03 PCONKL */
					idw_content.setitem(ll_new,'cntnr_height',idw_putaway.getitemNumber(i,'Height')) /* 01/03 PCONKL */
					idw_content.setitem(ll_new,'cntnr_weight',idw_putaway.getitemNumber(i,'Weight_Gross')) /* 01/03 PCONKL */
					idw_content.setitem(ll_new,'ro_no',idw_putaway.getitemstring(i,'ro_no'))
					idw_content.setitem(ll_new,'reason_cd','')
					idw_content.setitem(ll_new,'last_user',gs_userid)
					idw_content.setitem(ll_new,'last_update',ldtToday)
					//2017/11 - TAM - 3PL CC - Update the Last Counted Date(New field) */
					idw_content.setitem(ll_new,'last_cycle_count',ldtToday)
										
					// 02/09 - PCONKL - If Serialized Ind = 'B', We are capturing at Inbound (And Outbound) but NOT writing to Content
					IF idw_putaway.getitemstring(i,'serialized_ind') =  'B' Then
						idw_content.setitem(ll_new,'serial_no','-')
					Else
						//idw_content.setitem(ll_new,'serial_no',Trim(idw_putaway.getitemstring(i,'serial_no'))) //5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
						idw_content.setitem(ll_new,'serial_no', lsSerialNo) //5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
					End If
														
					// 09/00 PCONKL - If this is a child of a component, we will update the component qty, otherwise, we'll update the available qty
					If idw_putaway.GetITemString(i,"component_ind") = '*' or idw_putaway.GetITemString(i,"component_ind") = 'B' Then /* 09/02 - Pconkl - 'B' = Both (child and parent) */
						idw_content.setitem(ll_new,'component_qty',idw_putaway.getitemnumber(i,'quantity'))
						idw_content.setitem(ll_new,'avail_qty',0)
					Else

						//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
						if lsSerialNo='-' or ls_serialized_ind = 'N' then	//GailM 8/14/2019 DE11788 Always set avail qty to putaway qty if not serialized or serialNo default "-"
							idw_content.setitem(ll_new,'avail_qty',idw_putaway.getitemnumber(i,'quantity'))
						else
							idw_content.setitem(ll_new,'avail_qty', 1)
						end if
						//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
						
						idw_content.setitem(ll_new,'component_qty',0)
					End If
				
				End If /*W&S Blank qty check*/
				
			End If /*new or existing row*/
			
			// 06/15 - PCONKL - Mark putaway as content created
			//TimA 08/06/15
			//Comment out per Pete.  Causing problem with saving and having deadlocks
			//idw_Putaway.SetItem(i,'Content_Record_Created_Ind','Y')
			
		NEXT //serial records
		
	NEXT /*Putaway*/
	
END IF

//TimA 04/09/14 Only do this on the first Confirmation on Re-Confirm see the Else statement about sending the batch transactions.
If lbReconfirm = False Then 

	SetMicroHelp("Content Created - Call to save...")
	
	// pvh - gmt 12/15/05
	idw_main.setitem(1,'complete_date',  f_getLocalWorldTime( idw_main.object.wh_code[1] )  )
	idw_main.setitem(1,'ord_status','C')
	
	// ET3 2012-06-14: Implement generic test
	IF g.ibSNchainofcustody THEN
		//BCR 06-DEC-2011: Treat Bluecoat same as Pandora...
		//if upper(gs_project) = 'PANDORA' OR upper(gs_project) = 'BLUECOAT' then
		// Set the ue_save called from confirm flag
		ib_save_via_confirm = true
	end if

	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','start ue_save: ',is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 : Madhu added
		
	If iw_window.Trigger Event ue_save() = 0 Then
		ibFootprint = false	//GailM - 2/14/2018 - Footprint.  ue_save sets ibFootprint back to true...  turn if off
		
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','end - ue_save: ',is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 : Madhu added
		
		// 08/11/2010 ujhall: 05 of 09 Full Circle Fix: Save Serial nos to Serial_number_Inventory table
		// ET3 2012-06-14: Implement generic test
		IF g.ibSNchainofcustody THEN
			//BCR 06-DEC-2011: Treat Bluecoat same as Pandora...
			//	if upper(gs_project) = 'PANDORA'  OR upper(gs_project) = 'BLUECOAT' then
			//		this.wf_detail_vs_putaway()
			ib_save_via_confirm = false
			lb_Error = false
			lb_error_dup_sn = false 
			lsWhCode =  Upper(idw_main.getitemstring(1,'wh_code'))
			
			//TimA 03/18/11 moved the begin transaction up in the code.  See above
			//		Execute Immediate "Begin Transaction" using SQLCA; 
			
			SetMicroHelp("More validation of serial numbers and sending SNs to Serial Number Invntory...")
		
			// GailM #608 - 9/5/2013 - Wrap the below putaway loop to non-LPN SKUs only.  LPN will be copied from carton_serial enmass
			If NOT ibFootprint Then
				
				FOR i_indx = 1 to tab_main.tabpage_putaway.dw_putaway.RowCount()
			
					//16-OCT-2018 :Madhu S20312 DE6759 Don't add serial no, if already inserted via Mobile
					If not isnull(tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Content_Record_Created_Ind')) and tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Content_Record_Created_Ind') = 'Y' Then
						Continue
					End If
				
					//			lsWhCode =  Upper(idw_main.getitemstring(1,'wh_code'))
					lsLoc = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx,'l_code')
					ll_Owner_id = tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx,'Owner_id')
					lsOwnerCd  = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Owner_cd')
					lsSKU =  tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx,'SKU')
					lsSerialNo = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Serial_no')
					lsSerializedInd = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Serialized_Ind')
					
					ll_id_no = tab_main.tabpage_putaway.dw_putaway.getItemNumber(i_indx, 'Id_No')
					
					//TimA 07/03/13 Get Container_ID Pandora issue #608
					lsContainerID = tab_main.tabpage_putaway.dw_putaway.getitemstring(i_indx,'container_ID')
					//TimA 05/25/11 Pandora issue #223 
					lsGRP = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'GRP')
				
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					// 01/03/2011 ujh: S/N_P: Get Component_Ind and Component_No to insert into table below
					//Add conditons to test for serialization and test component_ID to see if it is not a stand alone item (may
					//		want to test that a component's parent is already in the table. Found out that parent may not be 
					// in table, as an unserialized parent could have serialized children
					ls_Component_ind =  tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx, 'Component_Ind')
					ll_Component_No = tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx,'Component_No')
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////
					/* 01/03/2011 ujh: S/N_Pa:  The following requires dw_putaway be orderd so Parents precede 
					children.  This was accomplished by the call to ue_sort when the putaway list was generated*/
					/* If a non-type "B" serialized parent has Type "B" serialized children, we will put it in Serialized_Number_Inventory
					so children can find their parent.  That means we will not want to delete a parent as long as 
					there are children in the table*/
					llFindRow = 0   // Make sure no carry over from previous iteration. Don't care where child is, just that it exists
					IF idw_putaway.getitemString(i_indx, 'component_ind') = 'Y' &   
					and idw_putaway.getitemString(i_indx, 'Serialized_ind') <> 'B' then    
						ls_Find = "Component_No = "  + String(idw_putaway.getitemnumber(i_indx,'component_no')) 
						ls_Find += " And Serialized_ind = 'B' "
						ls_Find +=  " And Component_ind = '*' " 
						// Find this parts serialized children if it has any
						llFindRow = idw_putaway.Find(ls_Find,1,idw_putaway.RowCount())
						// if a serialized child is found, need to create a FAKE serial number for this non serialized parent
						If llFindRow > 0 then 
							sqlca.sp_next_avail_seq_no(gs_project,"Serial_Number_Inventory","Serial_No" ,ld_NxtSeq)//get the next available num
							lsSerialNo = 'FAKE_' + String(Long(ld_NxtSeq),"000000") 
						End if
					
					end if //01/03/2011 ujh: S/N_Pa  
				
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
					//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
					ls_serial_list=ls_empty_list
					IF g.ib_receive_putaway_serial_rollup_ind and Upper(lsSerializedInd) = 'B' THEN
						ls_serial_list = this.wf_get_rma_serial_list( lssku, ll_id_no)
					ELSE
						ls_serial_list[UpperBound(ls_serial_list) +1] = lsSerialNo
					END IF
					//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
				
					/*Per Trey, if serialnumber is dash (the default) or blank or null, do not write to tabel, otherwise write*/
					// 12/22/2010 ujh:  in discussion with Dave agreed to change the test below from upper(lsSerializedInd) = 'I' to 'Y' 
					//			if not(isnull(lsSerialNo) or lsSerialNo = '-' or lsSerialNo = '') and (upper(lsSerializedInd) = 'Y' or Upper(lsSerializedInd) = 'B')then	
					/* 01/03/2011 ujh: S/N_P:  Per Ian (01/20/2011) SKUs set to inbound are not written to the table  
					01'03/2011 ujh: S/N_Pa: We will write unserialized parents that have serialized children.  llFindrow > 0 means we found a serialized child*/
					
					///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//01/03/2011 ujh: S/N_Pa:  The following were reversed in order to check the code in 01/26/2011.  Must be reversed for S/N_P
					//			if  not(isnull(lsSerialNo) or lsSerialNo = '-' or lsSerialNo = '') and  Upper(lsSerializedInd) = 'B'  then	// Original code
					FOR ll_serial_row = 1 to UpperBound(ls_serial_list)
						lsSerialNo = ls_serial_list[ll_serial_row]
					
						IF  (not(isnull(lsSerialNo) or lsSerialNo = '-' or lsSerialNo = '') and  Upper(lsSerializedInd) = 'B') or llFindRow > 0  THEN	// new S/N_P
							///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
							
								//TimA 05/25/11 Pandora issue #223 Don't add serial number to the serial number invoice table if the GRP is KHBOOKS and serialized is "B"
								IF lsSerializedInd = 'B' and  lsGRP = 'KHBOOKS' then
									Continue
								End if				
								
								//01/03/2011 ujh: S/N_P:  The serial number SkU Combo should not be in the table at this point.  Error if it is
								//ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, lsSKU, lsSerialNo,lsOwnercd, ls_Component_ind, ll_component_no,true)
								//dts - 2/19/11 - added parameter to skip component number as part of the serial look-up condition
								
								//TimA 04/15/11 - added parameters to capture error message in calling function
								//ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, lsSKU, lsSerialNo,lsOwnercd, ls_Component_ind, ll_component_no, true, true)  //TEMPO! - SkipComponent = True?
								ab_error_message_title = ''
								ab_error_message = ''
								//24-Jul-2014 : Madhu - Added "is_rono,is_suppinvoiceno" to write those onto Method Trace Log
								ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, lsSKU, lsSerialNo,lsOwnercd, ls_Component_ind, ll_component_no, true, true,ab_error_message_title,ab_error_message,is_rono,is_suppinvoiceno)  //TEMPO! - SkipComponent = True? 
							
							if ll_return = 1 then
								// the serial number Sku combo was found in the table
								// Code will continue checking serial numbers after one is found to be in error
								//					lb_Error = true
								lb_error_dup_sn = true  // 01/03/2011 ujh: S/N_Pzz
								ll_error_dup_sn_cnt	= ll_error_dup_sn_cnt + 1
								IF ll_error_dup_sn_cnt <= 10  then// quit capturing after 10, but keep trying to do all we can
									ls_dup_sku_serial = ls_dup_sku_serial + '('+lsSKU+','+lsSerialNo+') '  // 01/03/2011 ujh: S/N_Pzz
								end if
								//	elseif  idw_putaway.GetITemString(i_indx,"po_no2_controlled_ind") = 'Y' Then	//GailM 7/30/2013 - Pandora #608 - Add SNs to SerNoInventory
								
								
								//						ls_sqlsyntax = "sp_insert_sn_inventory  '" + gs_project +"', '" + lsSerialNo  +"', '" + ls_wh_code + "', " + &
								//							string(llOwnerID) + ",'" + lsOwnerCd  + "', '" + ls_Component_ind  +"', " + string(ll_component_no) + ", '" + &
								//							String(ldtToday,'YYYYMMDD') + "', '" + gs_userid + "', '" + lsRONO + "' "
								//						SetPointer(HourGlass!)
								//						SetMicroHelp("Saving SN to Serial Number Inventory table")
								//							//	Execute Immediate "Begin Transaction SerNoInv" using SQLCA;
								//								
								//								Execute Immediate  :ls_sqlsyntax;
								//							
								//							//	Execute Immediate "COMMIT SerNoInv" using SQLCA; 
								//						SetMicroHelp("Ready")
								//						SetPointer(Arrow!)
							else
							
								/* 01/03/2011 ujh: S/N_P:  NOW remove the restriction from components and allow them in the table.*/
								// If this is not a 'component' piece of an assembly,
								// GailM #608 Added check for LPN GPNs
								IF idw_putaway.GetITemString(i_indx,"component_ind") <> '*' then  
									// 01/03/2011 ujh: S/N_Pb:  add ls_component_ind and ll_component_no to the call
									//TimA 07/03/13 added and update for Carton_ID Pandora issue #608
									
									// 05/14 - PCONKL - Added New fields from Content to support adjustments and transfers
									lsLot = idw_putaway.GetITemString(i_indx,'lot_no')
									lspo = idw_putaway.GetITemString(i_indx,'po_no')
									lspo2 = idw_putaway.GetITemString(i_indx,'po_no2')
									lsrono = idw_putaway.GetITemString(i_indx,'ro_no')
									lsInvType = idw_putaway.GetITemString(i_indx,'inventory_type')
									ldtExpDT = idw_putaway.GetITemDateTime(i_indx,'expiration_date')
									
									//01/20 - PCONKL - S41494 - If a Pandora Pharmacy location, we stripped off the PO_NO2 and Container_ID values when writing to Contant
									//										We need tos trip them off here too so they match
									If gs_project = 'PANDORA' and lbPandoraPharmacyLocation Then
				
										If lspo2 <> '-' Then
											lspo2 = 'NA'
										Else
											lspo2 = '-'
										End If
				
										If lsContainerID <> '-' Then
											lsContainerID = 'NA'
										Else
											lsContainerID = '-'
										End If
										
									End If /* Pandora Pharmacy Location*/
									
									//14-Aug-2014 : Madhu - check whether SN record present in SKUSerialHold Table, it is YES, set Hold_Status =Y -END
									// TAM 2019/05 - S33409 - Populate Serial History Table fields
									Insert Into Serial_Number_Inventory (project_ID,Wh_code, Owner_id, Owner_cd, SKU, Serial_NO, Component_Ind, 
									Component_No, Update_date,Update_user,Carton_Id, l_code, ro_no, lot_no, po_no, po_no2, inventory_type, exp_dt,Hold_status,Transaction_Type,Transaction_Id,Adjustment_Type)
									Values(:gs_Project, :lsWhCode, :ll_Owner_id, :lsOwnerCd, :lsSKU, :lsSerialNo,:ls_Component_ind, 
										:ll_Component_No,  :ldtToday, :gs_userid, :lsContainerID, :lsLoc, :lsrono, :lsLot, :lspo, :lspo2, :lsInvType, :ldtExpDT,:lsHoldStatus,'RECEIVING', :lsrono, 'SERIAL ADDED');
									
									if sqlca.SQlcode <> 0 then
										lb_Error = true
										ab_error_message = SQLCA.SQLErrText
										exit
									end if
									
								End If //component_ind condition
								
							End If  // End checking that serial number is not in table
							
						END IF // should we flag and catch the fact that there are some incorrect serial numbers.
						
					NEXT //loop through serial records
					
				NEXT //putaway records
				
			END IF  // End nonLPN SKU/GPN loop for entry in serial_number_inventory table
	
			if lb_Error then
				Execute Immediate "ROLLBACK" using SQLCA;
				//MessageBox (ab_error_message_title, ab_error_message) // 04/15/2011 TimA
				wf_display_message(ab_error_message_title, ab_error_message)	// LTK 20150130
				
				//MessageBox ("DB Error Saving Serial Nums", SQLCA.SQLErrText)
				ib_ConfirmFail = True //TimA 04/06/11 Confirm failed
				return
			elseif lb_error_dup_sn then
				Execute Immediate "ROLLBACK" using SQLCA;
				//MessageBox(ab_error_message_title, ab_error_message + '~r' + ls_dup_sku_serial)  // 04/15/2011 TimA
				wf_display_message(ab_error_message_title, ab_error_message + '~r' + ls_dup_sku_serial)	// LTK 20150130
				//MessageBox("Serial # Error", 'One or more Duplicate Serial Numbers.  ~r' + ls_dup_sku_serial)  // 01/03/2011 ujh: S/N_Pzz
				ib_ConfirmFail = True  //TimA 04/06/11 Confirm failed
				return
			else
				Execute Immediate "COMMIT" using SQLCA; 
				ib_ConfirmFail = False  //TimA 04/06/11 Confirm Failed false
			end if
	
		END IF  // Project Pandora (chainof custody)
		
		// Begin - Dinesh - 03/22/2021- S54935- Google - SIMS – 947 change needed for Google SAP
		
		if gs_Project='PANDORA' and liAdj > 0 then
				Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
				
				Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
					Values(:gs_Project, 'MM', :lsRONO,'N', :ldtToday, 'Inbound');
				Execute Immediate "COMMIT" using SQLCA;
			
		else
		// End - Dinesh - 03/22/2021- S54935- Google - SIMS – 947 change needed for Google SAP
				// 12/08 - PCONKL - Want to write the record before we show confirmation msgbox
				Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
				
				Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
					Values(:gs_Project, 'GR', :lsRONO,'N', :ldtToday, '');
				Execute Immediate "COMMIT" using SQLCA;
				
				//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
				//inserting a record with GT into Batch Transaction table
				Execute Immediate "Begin Transaction" using SQLCA;
				
				Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
					Values(:gs_Project, 'GT', :lsRONO,'N', :ldtToday, '');
				
				Execute Immediate "COMMIT" using SQLCA;
				//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END	
		end if
		
		w_main.SetMicrohelp("Record Confirmed!")
		if not ib_batchconfirmmode then	// LTK 20150130 batch confirm
			Messagebox(is_title,'Order Confirmed!') /* 08/02 - Pconkl */
		end if
		ibConfirmRequested = False
				
	Else //save
		// 02/21/2011 ujh: I-135:  Reset ue_saved called from confirm flag
		if upper(gs_project) = 'PANDORA' then
			ib_save_via_confirm = false
		end if
		//MessageBox(is_title, "Record confirm failed!")
		wf_display_message("Record confirm failed!") // LTK 20150130
		
		idw_main.setitem(1,'ord_status','P') /* 08/02 - PConkl  */
		idw_content.Reset() /* 09/00 PCONKL */
		ibConfirmRequested = False
		Return
	End If //ue_save
	
ELSE
	//TimA 04/09/14 Pandora issue #36
	//Note:  This can be a baseline change but all the NVO's in the sweeper need to be modified to pass the Trans_Parm paramater.  
	//So for right now it's just for Pandora
	if upper(gs_project) = 'PANDORA' then
		//Call the function that will retrieve detail records to select for Re-Confirm
		IF wf_select_reconfirm_records( idw_main.GetITemString(1,'Ro_No') ) = False THEN
			//No detail records selected
			Return 
		END IF
		
		If isDetailRecordsToReConfirm = Upper('ALL' ) Then
			//All the detail records selected so do normal processing.  If not this variable will be delimited with line numbers.
			SetNull(isDetailRecordsToReConfirm )
		End if
	Else
		//Set the varable to null for all non Pandora projects
		SetNull(isDetailRecordsToReConfirm )
	End if
	
	// Begin - Dinesh - 03/22/2021- S54935- Google - SIMS – 947 change needed for Google SAP
	//if ((gs_Project='PANDORA') and (ls_uf6='GPN_CHANGE' or ls_uf6='GCD_PACKAGING_USAGE' or ls_uf6='SCRAP' or ls_uf6='R_CHANGE' or ls_uf6='PO_FIX')) then
	if  gs_Project='PANDORA' and liAdj > 0 then
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm )
		Values(:gs_Project, 'MM', :lsRONO,'N', :ldtToday, 'Inbound' );
		Execute Immediate "COMMIT" using SQLCA;
	else
		// End - Dinesh - 03/22/2021- S54935- Google - SIMS – 947 change needed for Google SAP
		//Messagebox(is_title,isDetailRecordsToReConfirm )
		//TimA 04/09/14 Order Re-Confirmed only send the new batch transactions
		Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm )
		Values(:gs_Project, 'GR', :lsRONO,'N', :ldtToday, :isDetailRecordsToReConfirm );
		Execute Immediate "COMMIT" using SQLCA;
		
		Execute Immediate "Begin Transaction" using SQLCA;
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm )
		Values(:gs_Project, 'GT', :lsRONO,'N', :ldtToday, :isDetailRecordsToReConfirm );
		Execute Immediate "COMMIT" using SQLCA;
	end if
	
	w_main.SetMicrohelp("Record Re-Confirmed!")
	Messagebox(is_title,'Order Re-Confirmed!') /* 08/02 - Pconkl */
	ibConfirmRequested = False
END IF

// 03/04 - PCONKL - All new GR's will be genreated in Batch Mode. 12/08 - PCONKL - Moved up above
//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
//
//Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
//							Values(:gs_Project, 'GR', :lsRONO,'N', :ldtToday, '');
//
//
//Execute Immediate "COMMIT" using SQLCA;

//TimA 04/019/14 Only do this on the first Confirmation 
If lbReconfirm = False Then 
	//cawikholm 07/05/11 End Tracing
	//TimA 03/26/15 move the method trace call down to the bottom
	//f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','end ue_confirm: ',lsRONO,' ',' ' ,is_suppinvoiceno)  //08-Feb-2013 :Madhu added
	
	// Copy LPN serial numbers from carton_serial to serial_number_inventory
	If ib_ConfirmFail = false and ibFootprint Then			// 08/13 GailM LPN project #608
		SetMicroHelp("Copy LPN serial numbers to Serial Number Inventory...")
		ll_return = sqlca.sp_copy_to_sn_inventory(gs_project,lsRoNo)
		if ll_return <> 0 Then
			If ll_return = 2627 Then
				//Messagebox("WARNING","LPN serial numbers could not be saved to Serial Number Inventory.  Primary key violation.  Either there are duplicate SNs or the SNs have been previously entered.  Error:" + string(ll_return), Exclamation!)
				wf_display_message("LPN serial numbers could not be saved to Serial Number Inventory.  Primary key violation.  Either there are duplicate SNs or the SNs have been previously entered.  Error:" + string(ll_return))
			Else
				//Messagebox("WARNING","LPN serial numbers could not be saved to Serial Number Inventory table.  See: " + string(ll_return), Exclamation!)
				wf_display_message("LPN serial numbers could not be saved to Serial Number Inventory table.  See: " + string(ll_return))
			End If
		End if
	End If
	
	//04/02 - PCONKL - Some projects may have some post confirmation processing
	SetMicroHelp("Post confirmation processing...")
	SetPointer(HourGlass!)
	This.TriggerEvent('ue_post_Confirm')
	
	// 05/01 Pconkl - Create backorder if requested
	SetMicroHelp("Creating Backorder...")
	If lbCreateBackorder Then
		This.TriggerEvent("ue_backOrder")
		//TimA 02/12/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','Back order created: ',is_rono,' ', ' ' ,is_suppinvoiceno) 
	End If

Else
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','end Re-Confirm: ',lsRONO,' ',' ' ,is_suppinvoiceno) 
End if

//TImA 03/26/15 moved this down from above
f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','end ue_confirm: ',lsRONO,' ',' ' ,is_suppinvoiceno) 

SetMicroHelp("Ready")
Setpointer(Arrow!) 


end event

event ue_generate_putaway();
//*** 08/06 - PCONKL - This event is obsolete, now calling ue_generate_putaway_server *********

// 10/31/02 - Pconkl - Qty fields changed to decimal

Long ll_row, ll_cnt,i,j, llOwnerID, llCompRow, llRowCount, llRowPos,	& 
		llLoopCount,llEDIBatch,llLineItem, llFindRow, llIMIID
		
String ls_sku, ls_wh, ls_type, ls_loc, ls_order, lsOwnername, lsSupplier, lsCOO, lsSuppOrderNO, lsFind 
String lsContainer[], lsCOOArray[], lsNullarray[],  lsLocSave, lsVASLoc, lsContract
String	lsSerial, lsLot, lsPO, lsPO2, lsComp, lsCont, lsEXP, lsContainerID, lsLineItemNo, lsIMIID, lsCompType, lsSort, ls_INActiveCustomerName

Long	 llNullArray[], llArrayPos, llCount,  llNextContainer,  llWeekNo

Decimal	ldReqQty, ldSetQty, ldRCVQty[], ldPendingQty, ldUnitWT
Boolean	lbASN, lbWOPending, lbContractExists

DateTime	ldtToday, ldtGMT

Datastore luds_edi_serial

// 07/06 - PCONKL - Set Putaway Start Time on MAster
ldtGMT = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
idw_main.SetItem(1,'Putaway_start_Time',	ldtGMT  ) 

//08/29/05 - for Auto-created orders (from Outbound Warehouse Transfers)...
string lsDONO, lsLotArray[], lsPOArray[], lsPO2Array[], lsSerialArray[], lsInvTypeArray[], lsSuppArray[]
DateTime ldtExpArray[], ldtNullArray[]
long llRowCountPick
Datastore luds_picking

// pvh
string lsDetailUserField1
//
 // pvh - 03.10.06 - MARL
integer returncode

SetPointer(HourGlass!)

ldtToday = DateTime(today(),Now())

llNextContainer = 0 /*init Container ID - concatonated with Ro_No */

// 07/06 - PCONKL - For GM Detroit, If we haven't already done an IMS verify for the order (when loading through ASN), promt now...
If gs_project = 'GM_MI_DAT' Then
	
	If not isDate(idw_Main.GetITemString(1,'user_Field1')) or idw_Main.GetITemString(1,'user_Field1') = "" or isnull(idw_Main.GetITemString(1,'user_Field1')) Then
		
		If Messagebox(is_title, "This order has not been verified with the GM IMS system.~r~rWould you like to do it now?",Question!,YesNo!,1) = 1 Then
			tab_main.tabpage_OrderDetail.cb_ims_verify.TriggerEvent("clicked")
		End If
		
	End IF

End If /* GM */

// 09/02 - PCONKL - remove a filtered Putaway list (Components, etc.)
wf_set_comp_filter('Remove')

If idw_putaway.RowCount() > 0 Then 
	Choose Case MessageBox(is_title, "Delete existing records?", Question!, YesNoCancel!,3)
		Case 3
			Return
		Case 1
			idw_putaway.SetRedraw(False)
			ll_cnt = idw_putaway.RowCount()
			For ll_row = ll_cnt to 1 Step -1
				idw_putaway.DeleteRow(ll_row)
			Next
			idw_putaway.SetRedraw(True)
	End Choose
End If

ib_changed = True

ilCompNumber = 0

ls_order = idw_main.GetItemString(1, "ro_no")
ls_type = idw_main.GetItemString(1, "inventory_type")
ls_wh = idw_main.GetItemString(1, "wh_Code")

// 02/06 - BackOrders will have the batch_seq_no set to -1 (if originally > 0) so we don't retrieve the same batch Seq No's on a back order
If idw_main.GetItemNumber(1,"edi_batch_seq_no") > 0 Then
	//Create the serial # datastore
	
	//02/07/06 - now used to capture ticket #'s for DDC as well.
	//   Selecting the max(edi_batch_seq_no) for given sku/line item.
	//   ! This won't work for an Add without a unique line_item_no (ddc says there won't be duplicates)
	luds_edi_serial = Create Datastore
	luds_edi_serial.dataobject = 'd_ro_edi_serial'
	luds_edi_serial.SetTransobject(SQLCA)
End If

//if the order is a warehouse transfer (created by outbound order confirmation)...
If idw_main.GetItemString(1, "ord_type") = 'Z' and idw_main.GetItemString(1, "do_no") <> '' Then
	//Create the delivery_picking datastore
	lsDONO = idw_main.GetItemString(1, "do_no")
	luds_picking = Create Datastore
	luds_picking.dataobject = 'd_do_picking'  //can we use d_do_picking from delivery-dw.pbl?
	luds_picking.SetTransObject(SQLCA)
	llRowCountPick = luds_picking.Retrieve(lsDONO) //tempo - still using this?
else
	lsDONO = ''
End If

idw_putaway.SetRedraw(False)
ll_cnt = idw_detail.RowCount()

// 08/02 - PCONKL - Reset sort seq - we are allowing the user to sort*/
idw_detail.SetSort("Line_Item_No A, SKU A, Alternate_SKU A, Owner_ID A, Country_of_origin A")
idw_detail.Sort()

For i = 1 to ll_cnt /*For each Detail Record*/
	
	w_main.SetMicrohelp('generating Putaway for Detail Line: ' + String(i) + ' of ' + String(ll_cnt))	
	// pvh - 01/12/2006 - ams-muser
	if Upper(gs_project) = 'AMS-MUSER' then
		lsDetailUserField1 = 	idw_detail.object.user_field1[ i ]
	end if
	
	lbASN = FaLse
	lbWOPending = False
	ls_sku = idw_detail.GetItemString(i,"sku")
	llOwnerID = idw_detail.GetItemNumber(i,"owner_id")
	lsOwnername = idw_detail.GetItemString(i,"c_owner_name")
	lsSupplier = idw_detail.GetItemString(i,"supp_code")
	lsCOO = idw_detail.GetItemString(i,"country_of_origin")
	llLineitem = idw_detail.GetItemNumber(i,"line_item_no")
	lsLineItemNo = idw_detail.GetItemString(i,"user_line_item_no") 
	ldreqQty = idw_detail.GetItemNumber(i,"req_qty")
	
	//3/10 JAyres Check to see if Customer is Active
	If Right(Trim(lsOwnername), 3) = '(C)' Then
	
		Select Distinct dbo.Customer.Cust_Name
		Into    	:ls_INActiveCustomerName
		FROM 	dbo.Owner,
		         	dbo.Customer
		Where 	dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
			and    dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
			and 	dbo.Owner.Owner_ID 		= :llOwnerID
	    		and 	dbo.Customer.Customer_Type 	= 'IN' 
			and 	dbo.Owner.Project_ID 		= :gs_project;
			
		If NOT ( ls_INActiveCustomerName = '' or IsNULL(ls_INActiveCustomerName) ) Then
			If IsNull( lsOwnername  ) then  lsOwnername = ''
			MessageBox(is_title, "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i) +" of Order Detail.~r~rPlease Enter an Active Owner then Regenerate." )	
			return
		End If
	End If
	
	//Retrieve serial, lot & PO tracking indicators
	// 02/06 - PCONKL - include Item Component Info to see if any of the items are packaging for a parent item (joining at child level)
	//						If so, we will check to see if there is a pending packagibg WO that is waiting for this packaging
	
	Select Distinct SerialIzed_Ind, Lot_Controlled_IND, PO_Controlled_Ind, PO_NO2_Controlled_Ind, 
				Component_Ind, expiration_controlled_Ind, container_tracking_Ind, weight_1, Item_Component.Component_Type
	Into	:lsSerial, :lsLot, :lsPO, :lsPO2, :lsComp, :lsExp, :lsCont, :ldUnitWT, :lsCompType
	FROM dbo.Item_Master LEFT OUTER JOIN dbo.Item_Component ON dbo.Item_Master.Project_ID = dbo.Item_Component.Project_ID AND dbo.Item_Master.SKU = dbo.Item_Component.SKU_Child AND dbo.Item_Master.Supp_Code = dbo.Item_Component.Supp_Code_Child and Item_Component.component_type = 'P'  
	Where Item_Master.Project_id = :gs_project and Item_Master.SKU = :ls_SKU and Item_Master.supp_code = :lsSupplier ;
	
	//FOR GM_MI_DAT - If component type is 'P', this item is a package and we will check to see if there is an open WO waiting for this packaging item to be received
	If gs_Project = 'GM_MI_DAT' and lsCompType = 'P' Then 
		
		Select Sum(Req_Qty) into :llCount
		From Workorder_MAster, Workorder_Detail
		Where Workorder_MAster.wo_no = Workorder_Detail.wo_no and
				Workorder_MAster.Project_ID = :gs_Project and Workorder_MAster.ord_status = 'N' and 
				Workorder_Detail.SKU in (Select sku_parent from Item_Component where project_id = :gs_Project and sku_child = :ls_sku and supp_code_Child = :lsSupplier);
				
				If llCount > 0 Then /* Child needed*/
					lbWOPending = True		
				End If /*Child needed on Pending WO */
		
	End If
	
	// 07/02 - PCONKL Get default Putaway location from Item Master 
	ls_loc = i_nwarehouse.of_assignlocation(ls_sku,lsSUpplier, ls_wh, ls_type,llOwnerID, ldReqQty)
	
	lsLocSave = ls_Loc
				
	ldSetQty = ldReqQty
	llLoopCount = 1 /*loop once setting req qty*/
	// 11/01 PCONKL - This Event may be triggered by w_proc_asn_order to build the putaway based on ASN items checked.
	//						If that is the case, we will only build the Putaway for rows that have been checked and copy qty's and carton information
	// dts 08/29/05 - If the order was created by confirming an Outbound Warehouse Transfer
	
	If isValid(w_proc_asn_order) Then /*ASN Order Window Opened*/
		If w_proc_Asn_order.ibApplyasn Then /*apply button clicked*/
		
			lsFind = "Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string(llLineItem) + " and c_apply_ind = 'Y'"
			llFindRow = w_proc_Asn_order.dw_asn.Find(lsFind,1,w_proc_Asn_order.dw_asn.RowCount())
			
			If llFindRow <= 0 Then
				Continue /*we wont create a putaway row if it is not selected on the ASN Window*/
			Else
				lbASN = True /*will override EDI table for building Putaway for this Row*/
			End If
			
		End If /*apply button Selected*/
	End If /*ASN Window Open*/
		
	// 01/01 PCONKL - If this order was received via EDI with Inventory Type, serial numbers, lot or PO, we will populate them here
	
	llRowCount = 0
	
	If idw_main.GetItemNumber(1,"edi_batch_seq_no") > 0 Then
		llEDIBatch = idw_main.GetItemNumber(1,"edi_batch_seq_no")
		lsSuppOrderNO = idw_main.GetItemString(1,"supp_invoice_no")
		llRowCount = luds_edi_serial.Retrieve(gs_project,llEDIBatch,lsSuppOrderNO,ls_SKU,llLineItem)
		//If there are more than 1 rows, then we want to create a putaway row with a qty of 1 for each row and capture the serial #
		If llRowCount > 1 Then
			// dts - 02/07/06 - ddc - need to get quantity from edi_inbound_detail table for each Ticket # (Lot_NO)
			//    now grabbing quantity for all - not setting to 1 (for 3COM Serials)
			llLoopCount = llRowCount
			//dts 2/07/06 ldSetQty = 1
		End If
	End If /* order via EDI */
	

	//IF there is an ASN record(s) for this SKU/Line Item, We will loop for each one (shipment and/or carton).
	// This will ovverride Serial NUmber processing from PO
	
	If lbASN Then /*checked asn exists for this sku/line Item*/
	
		//Reset arrays
		lsContainer = lsNullArray
		lsCOOArray = lsNullArray
		ldRCVQty = llNullArray
		llArrayPOs = 0
		
		//Find out how many checked rows there are for this Sku/Line item. This is how many times we will loop and create a new Putawy record
		lsFind = "Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string(llLineItem) + " and c_apply_ind = 'Y'"
		llFindRow = w_proc_Asn_order.dw_asn.Find(lsFind,1,w_proc_Asn_order.dw_asn.RowCount())
		
		Do While llFindRow > 0
			
			llArrayPos ++
			lsContainer[llArrayPos] = w_proc_Asn_order.dw_asn.GetItemString(llFindRow,'container_id')
			lsCooArray[llArrayPos] = w_proc_Asn_order.dw_asn.GetItemString(llFindRow,'country_of_origin')
			ldRCVQty[llArrayPos] = w_proc_Asn_order.dw_asn.GetItemNumber(llFindRow,'c_work_qty')
			llFindRow ++
			If llFindRow >w_proc_Asn_order.dw_asn.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = w_proc_Asn_order.dw_asn.Find(lsFind,llFindRow,w_proc_Asn_order.dw_asn.RowCount())
			End If
			
		Loop
		
		//Loop once for each row found
		llLoopCount = UpperBound(lsContainer)
	
	End If /*checked ASN exists for this sku/line item*/
	
	// 08/29/05 dts - If order is Whse Xfer, get Delivery Picking fields here (lot-able fields)
	llRowCountPick = 0
	if lsDONO <> '' then //Order was created from an Outbound Order (Warehouse Transfer)
		//Reset arrays
		lsLotArray = lsNullArray
		lsPOArray = lsNullArray
		lsPO2Array = lsNullArray
		lsContainer = lsNullArray
		lsCOOArray = lsNullArray
		lsSerialArray = lsNullArray
		lsInvTypeArray = lsNullArray
		lsSuppArray = lsNullArray
		ldRCVQty = llNullArray
		ldtExpArray = ldtNullArray
		llArrayPOs = 0
		
		//Find out how many Delivery Picking rows there are for this Sku/Line item.
		//This is how many times we will loop and create a new Putawy record or add qty to an existing one.
		/*Could be multiple picking rows for sku/lineItem...
		  - Could mean multiple put-away rows (different lot/po/po2....)
		  - Or Same put-away row (only differ by location) */
		lsFind = "Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string(llLineItem)
//messagebox("TEMPmsg - Find in Delivery Picking:", "lsFind: " + lsFind)
		llFindRow = luds_picking.Find(lsFind, 1, luds_picking.RowCount())		
		Do While llFindRow > 0			
			llArrayPos ++
			lsLotArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'Lot_no')
			lsPOArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'PO_NO')
			lsPO2Array[llArrayPos] = luds_picking.GetItemString(llFindRow, 'PO_NO2')
			lsContainer[llArrayPos] = luds_picking.GetItemString(llFindRow, 'container_id')
			lsCOOArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'country_of_origin')
			lsSerialArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'serial_no')
			lsInvTypeArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'inventory_type')
			lsSuppArray[llArrayPos] = luds_picking.GetItemString(llFindRow, 'supp_code')
			ldtExpArray[llArrayPos] = luds_picking.GetItemDateTime(llFindRow, 'expiration_date')
			ldRCVQty[llArrayPos] = luds_picking.GetItemNumber(llFindRow, 'quantity')
			llFindRow ++
			If llFindRow > luds_picking.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = luds_picking.Find(lsFind, llFindRow, luds_picking.RowCount())
			End If
		Loop
		//Loop once for each row found
		llLoopCount = UpperBound(lsContainer)
	End If /* order created from Delivery Order */

	//If This Order Detail is Serialized Component, we need to loop for each qty as well - 
	//If children are serialized, they will need to make the parent serialized so we can set the loop here
	If lsSerial = 'Y' and lsComp = 'Y' Then /*capturing at inbound */
		ldSetQty = 1
		llLoopCount = ldReqQty
	End If
	
	
	For j = 1 to llLoopCount
		
		/*loop count will be 1 unless we have serial #'s to enter from EDI file or we are splitting putaway to pending WO VAS loc
		 - Or, if this was created from an Outbound Order (Warehouse Transfer)   
		   In case of Whse Xfer, may be either inserting new record or updating qty for existing record */
		
		ll_row = 0
		if lsDONO <> '' then
			//Build lsFind for search against Put-away datastore...
			lsFind = "Upper(sku) = '" + Upper(ls_Sku) + "' and line_item_no = " + string(llLineItem)
			If lsLotArray[j] > ' ' Then
				lsFind += " and lot_no = '" + lsLotArray[j] + "'"
			End If
			If lsPOArray[j] > ' ' Then
				lsFind += " and po_no = '" + lsPOArray[j] + "'"
			End If
			If lsPO2Array[j] > ' ' Then
				lsFind += " and po_no2 = '" + lsPO2Array[j] + "'"
			End If
			If lsSerialArray[j] > ' ' Then
				lsFind += " and serial_no = '" + lsSerialArray[j] + "'"
			End If
			If lsContainer[j] > ' ' Then
				lsFind += " and container_id = '" + lsContainer[j] + "'"
			End If
			If lsInvTypeArray[j] > ' ' Then
				lsFind += " and Inventory_type = '" + lsInvTypeArray[j] + "'"
			End If
			If lsSuppArray[j] > ' ' Then
				lsFind += " and supp_code = '" + lsSuppArray[j] + "'"
			End If
			If not (IsNull(ldtExpArray[j]) or string(ldtExpArray[j], 'mm/dd/yyyy')='12/31/2999') Then
				lsFind += " and string(expiration_date, 'mm/dd/yyyy') = '" + string(ldtExpArray[j], 'mm/dd/yyyy') + "'" //??? Do we need hh:mm:ss  ???
			End If
			//messagebox ("TEMP Msg - Find in Put-Away (llLoopCount:" + string(llLoopCount) + ")", "j: " +string(j) + ", lsfind: " + lsFind)
			ll_row = idw_putaway.find(lsFind, 1, idw_putaway.RowCount())
		end if //not created from a delivery order (or line not found)
		
		//dts - 8/29/02 - now conditionally inserting new row (might be just updating qty)
		if ll_row = 0 then
			
			ll_row = idw_putaway.InsertRow(0)
		
			idw_putaway.setitem(ll_row,'ro_no', ls_order)
			idw_putaway.SetItem(ll_row,"sku", ls_sku)	
			idw_putaway.SetItem(ll_row,"sku_parent", ls_sku)	
			idw_putaway.SetItem(ll_row,"supp_code", lsSupplier)
/*SUBSTITUTE*/		idw_putaway.SetItem(ll_row,"sku_substitute", ls_sku)	//TAM 2010/04/07
/*SUBSTITUTE*/		idw_putaway.SetItem(ll_row,"supplier_substitute", lssupplier)	//TAM 2010/04/07
			idw_putaway.SetItem(ll_row,"owner_id", llOwnerID)	/* 09/00 PCONKL */
			idw_putaway.SetItem(ll_row,"line_item_no", lllineItem)	/* 08/01 PCONKL */
			idw_putaway.SetItem(ll_row,"c_owner_name", lsOwnername)	/* 09/00 PCONKL */
			idw_putaway.SetItem(ll_row,"inventory_type", ls_type)	
			idw_putaway.SetItem(ll_row,"serialized_ind", lsSerial)	
			idw_putaway.SetItem(ll_row,"lot_controlled_ind", lsLot)
			idw_putaway.SetItem(ll_row,"po_controlled_ind", lsPO)
			idw_putaway.SetItem(ll_row,"po_no2_controlled_ind", lsPO2)
			idw_putaway.SetItem(ll_row,"expiration_controlled_ind", lsExp) /* 11/02 - PConkl*/
			idw_putaway.SetItem(ll_row,"container_Tracking_ind", lsCont) /* 11/02 - PConkl*/
			idw_putaway.SetItem(ll_row,"component_ind", lsComp)
			idw_putaway.SetItem(ll_row,"user_line_item_no", lsLineItemNo)	/* GAP 12/02  */
			idw_putaway.SetItem(ll_row,"weight_1", ldUnitWT)	/* 03/04 - PCONKL  */
			
			// pvh - 01/12/2006 - ams-muser
			if Upper(gs_project) = 'AMS-MUSER' then
				idw_putaway.object.user_field1[ ll_row ] = lsDetailUserField1
			end if
			
			/* GAP 6-03  GM_M only Create a Receipt #  in User_field1 for each line item - used in "gmm receive report" */
			If Upper(Left(gs_Project,4)) = "GM_M" Then 
				idw_putaway.SetItem(ll_row,"user_field1", right(ls_order,6) + string(lllineItem))
			end if
	
			//If Packaging item needed on a pending WO, set UF2 to Y
			if lbWOPending Then
				idw_putaway.SetItem(ll_row,"user_field2","Y")
			End If
			
			// TAM 7-04  3COM_NASH Only 
			If gs_Project = "3COM_NASH" Then 

			
				// 07/05 - PCONKL - wh_code was not being set previously - code commented below is to maintain the status quoa
				
				// Default PO_NO2 (Used as "Bonded Indicator") with "N"  Warehouse 3COM_NL Default = "Y"  
				//If ls_wh = "3COM-NL" Then
				//	idw_putaway.SetItem(ll_row,"PO_NO2", 'Y')
				//Else
					idw_putaway.SetItem(ll_row,"PO_NO2", 'N')
				//End If
				// Default LOT_NO  with "N/A" unless Warehouse 3COM_SIN. "Leaving it as "-" will force them to enter it. 
				//If ls_wh <> "3COM-SIN" Then
					idw_putaway.SetItem(ll_row,"LOT_NO", 'N/A')
				//End If
				
				// 09/04 - PCONKL - If this order is a return, set expiration date to today. This will force returns to be
				//							picked before new product (expiration date first in pick sort order)
				If idw_main.GetITemString(1,'Ord_Type') = 'X' Then /*return*/
					idw_putaway.SetItem(ll_row,"expiration_date", ldtToday)
				End If
				
			End If /*3COM*/
			
			//Take qty/COO from the ASN if present, or DONO if Warehouse Transfer
			If lbASN or lsDONO <> '' Then
				If lsCOOArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row,"country_of_origin", lsCOOArray[j]) /* 11/01 PCONKL */
				Else
					idw_putaway.SetItem(ll_row,"country_of_origin", lsCOO)
				End If
				
				idw_putaway.SetItem(ll_row,"quantity",ldRcvQty[j])
				
			Else /*Not ASN and not Warehouse Transfer*/
				
				idw_putaway.SetItem(ll_row,"country_of_origin", lsCOO)	/* 09/00 PCONKL */
								
			   //messagebox ('temp', ' Qty:' + string(ldsetqty))
				/*set qty will be req qty unless we are moving some to pending DO loc or entering serial #'s in which case it will be 1
				  - ldSetQty may now be the sum(Quantity) from edi_inbound_serial table (and thus not 1 for DDC Ticket #s)*/
				idw_putaway.SetItem(ll_row,"quantity", ldSetQty) 
				
			End If
			
			idw_putaway.SetItem(ll_row,"l_code", ls_loc)
			
			//Set Serial, Lot & PO from edi file if present
			If llRowCount > 0 Then
				
				//If processing from ASN, take from the first row (lot, etc. will be the same, only serial will be diff)
				If lbASN Then
					If luds_edi_serial.GetItemString(1,'inventory_type') > ' ' Then
						idw_putaway.SetItem(ll_row,"inventory_type", luds_edi_serial.GetItemString(1,'inventory_type'))
					End If
					If luds_edi_serial.GetItemString(1,'lot_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"lot_no", luds_edi_serial.GetItemString(1,'lot_no'))
					End If
					If luds_edi_serial.GetItemString(1,'po_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"po_no", luds_edi_serial.GetItemString(1,'po_no'))
					End If
					//If luds_edi_serial.GetItemString(1,'po_no2') > ' ' Then /*carton Nbr*/
						idw_putaway.SetItem(ll_row,"po_no2", lsContainer[j]) /*carton Nbr*/
					//End If
					If luds_edi_serial.GetItemString(1,'serial_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"serial_no", luds_edi_serial.GetItemString(1,'serial_no'))
					End If
				Else /*not from ASN*/
					If luds_edi_serial.GetItemString(j,'inventory_type') > ' ' Then
						idw_putaway.SetItem(ll_row,"inventory_type", luds_edi_serial.GetItemString(j,'inventory_type'))
					End If
					If luds_edi_serial.GetItemString(j,'po_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"po_no", luds_edi_serial.GetItemString(j,'po_no'))
					End If
					If luds_edi_serial.GetItemString( j ,'po_no2') > ' ' Then
						idw_putaway.SetItem(ll_row,"po_no2", luds_edi_serial.GetItemString(j,'po_no2'))
					End If
					If luds_edi_serial.GetItemString(j,'serial_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"serial_no", luds_edi_serial.GetItemString(j,'serial_no'))
					End If
				  //dts 02/07/06 - DDC - Ticket #s, not serial #s - need quantity
						// 'Quantity' field is now numeric {SQL: SUM(CAST(quantity as decimal)) Quantity}
					ldSetQty = luds_edi_serial.GetItemNumber(j,'quantity')
					idw_putaway.SetItem(ll_row,"quantity", ldSetQty)
					If luds_edi_serial.GetItemString(j,'lot_no') > ' ' Then
						idw_putaway.SetItem(ll_row,"lot_no", luds_edi_serial.GetItemString(j,'lot_no'))
					End If
//				messagebox("TEMPO", "COO?")
				If luds_edi_serial.GetItemString(j,'country_of_origin') > ' ' Then
					idw_putaway.SetItem(ll_row,"country_of_origin", luds_edi_serial.GetItemString(j,'country_of_origin'))
				End If
					// pvh - 01/12/2006 - amd
					if Upper( gs_project ) = 'AMS-MUSER' then
						If luds_edi_serial.object.l_code[ j ] > ' ' Then
							idw_putaway.object.l_code[ ll_row ] = luds_edi_serial.object.l_code[ j ]
						end If
					end if
					// eom
					
	//				If luds_edi_serial.GetItemString(j,'owner_ID') > ' ' Then /* 12/02 - PCONKL - We may set Owner from EDI File */
	//					idw_putaway.SetItem(ll_row,"owner_ID", Long(luds_edi_serial.GetItemString(j,'owner_ID')))
	//					idw_Detail.SetITem(i,'Owner_id',Long(luds_edi_serial.GetItemString(j,'owner_ID'))) /*detail needs to be updated too */
	//				End If
					
				End If /*ASN*/
					
			End If /*edi file exists*/
			
			//Set Serial, Lot & PO from Delivery Order if appropriate (Warehouse Transfer and Picking Line found)
	//x		If llRowCountPick > 0 Then
			If lsDONO <> '' Then
				If lsLotArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row, "lot_no", lsLotArray[j])
				End If
				If lsPOArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row, "po_no", lsPOArray[j])
				End If
				If lsPO2Array[j] > ' ' Then				
					//idw_putaway.SetItem(ll_row,"po_no2", luds_picking.GetItemString(1,'po_no2'))
					idw_putaway.SetItem(ll_row, "po_no2", lsPO2Array[j]) 
				End If
				If lsSerialArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row, "serial_no", lsSerialArray[j])
				End If
				If lsContainer[j] > ' ' Then
					idw_putaway.SetItem(ll_row, "container_id", lsContainer[j])
				End If
				If lsInvTypeArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row,"inventory_type", lsInvTypeArray[j])
				End If
				If lsSuppArray[j] > ' ' Then
					idw_putaway.SetItem(ll_row, "supp_code", lsSuppArray[j])
				End If
				If not(IsNull(ldtExpArray[j]) or string(ldtExpArray[j], 'mm/dd/yyyy')='12/31/2999') Then
					idw_putaway.SetItem(ll_row,"expiration_date", ldtExpArray[j])
				End If
				idw_putaway.SetItem(ll_row, "quantity", ldRcvQty[j])
			end if //not created from a delivery order (or line not found)
		else //put-away record for lot/po/po2... already exists, update qty (warehouse transfers)
			//messagebox("TEMPmsg", "ldSetQty: " + string(ldSetQty) + ", ldRCVQty[j]: " + string(ldRCVQty[j]))
			ldSetQty = idw_putaway.GetItemNumber(ll_row, "quantity")
			ldSetQty += ldRCVQty[j]
			idw_putaway.SetItem(ll_row, "quantity", ldSetQty) /*set qty will be req qty unless we are moving some to pednind DO loc or entering serial #'s in which case it will be 1*/
		end if
		
		// 09/00 PCONKL - If this Item is a Component, Insert Rows for child Items
		If idw_putaway.GetItemString(ll_row,"component_ind") = 'Y' Then
			
			// 09/02 - PCONKL - Component #'s now generated so we can mainatain a unique component # in Inventory
			ilCompNumber =  g.of_next_db_seq(gs_project,'Content','Component_no')
			idw_putaway.setitem(ll_row,'component_no', ilCompnumber)
			wf_create_comp_child(ll_row)
			
		Else /* not a component*/
			idw_putaway.setitem(ll_row,'component_no',0)
		End If /*component*/
		
		// 12/02 - PConkl - If Tracking by Container ID, Set the next Available - Concat RO_NO + sequential #
		If idw_putaway.GetItemString(ll_row,'container_Tracking_ind') = 'Y' Then
			llNextContainer ++
			lsContainerID = Right(idw_main.GetITemString(1,'ro_no'),6) + String(llNextContainer,'000000')
			idw_putaway.setitem(ll_row,'container_ID', lsContainerID)
		End If /*Tracking by Container ID */
				
	Next /* quantiy of 1 if serialized*/
	
	//06/06 - PCONKL - If GM, we will only be creating a PAckaging WO (below) if contract = 44734 (in UF3)
	If gs_project = 'GM_MI_DAT' Then
		
		lsContract = idw_detail.GetItemString(i,"User_Field3")
		If pos(lsContract,"44734") > 0 Then
			lbContractExists = True
		End IF
		
	End If
	
	IF gs_project = 'AMS-MUSER' AND  idw_main.GetItemString(1, "wh_Code") = 'EED' THEN
		
		idw_putaway.SetItem(ll_row, "lot_no", idw_main.GetItemString(1, "ship_ref"))
		idw_putaway.SetItem(ll_row, "po_no2", 'Y') 
		
	END IF 
	

	
Next /*Next Detail Row*/

idw_putaway.SetRedraw(True)
idw_putaway.GroupCalc()

// 07/00 PCONKL - Enable printing of Putaway list before saving (printing with blank locations, etc.)
If idw_putaway.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False
End If

//If any of Putaway records are components, enable show components checkbox
If idw_putaway.RowCount() > 0 Then
	If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) > 0 Then
		    //MAS - 021511 - check cbx_show_comp and disable for all projects
			tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
			tab_main.Tabpage_putaway.cbx_show_comp.Checked = True
		
		wf_set_comp_filter('SET') /*default to not showing component children*/
	Else
		tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
		    //MAS - 021511 - check cbx_show_comp and disable for all projects
			tab_main.Tabpage_putaway.cbx_show_comp.Checked = True
	End If
End If

//For GM, notify user if any of the Packaging (Child) Items have a pending WO
If gs_project = 'GM_MI_DAT'  Then
	if idw_putaway.Find("User_field2 = 'Y'",1, idw_Putaway.rowCount()) > 0 Then
		messagebox(is_title,'One or more of the Packaging Items is needed on a pending WO.~r~rSee the screen for more details...')
	End If
End IF

//For GM, If any parent Items needs packaging, alert user (This should be fairly exclusive from above notification for children)
If gs_project = 'GM_MI_DAT' and lbContractExists Then 
	
	Select Count(*) into :llCount
	From Item_Component
	Where Project_ID = :gs_Project and supp_Code_parent = :lsSupplier and
			sku_parent in (select sku from receive_detail where ro_no = :ls_Order);
			
	If llCount > 0 Then
		
		If Messagebox(is_title,'One or more of the Items on this order require Packaging.~r~rWould you like to create a Packaging WorkOrder?',Question!,yesNo!,1) = 1 Then
			ibWORequested = True /* will  create WO after Putaway List Saved*/
		End IF
		
	End IF
	
End If /*GM*/

// pvh - 03.13.06 MARL
If gs_Project = "3COM_NASH" Then 
	if idw_main.GetItemString(1, "ord_type") = 'X' then
		setRLSkuList(  )
		setQualityHoldRows()
		if getMARLListCount() > 0 then doMARLCheck()
	end if
end if
// eom

// 11/02 - PCONKL - Hide any unused lottable fields
idw_Putaway.TriggerEVent('ue_hide_unused')

idw_main.SetItem(1, "ord_status", "P")	

////02/06 - PCONKL - we may have a project/warehouse level sort on the Putaway (Screen and report will be sorted the same if present)
//This.TriggerEvent('ue_sort_Putaway')

//BCR 09-FEB-2012: Any project that has this kind of project/warehouse level sort on Putaway (like Bluecoat does) may run into run-time problems if there are Components attached to Parents. 
//                           In Bluecoat's case, Child Component shows up on row 1, followed by Parent on row 2. When you select Location for Parent, it doesn't copy down into Child.  
//                           So, per Pete Conklin, trigger this event ONLY if there are no Child Components.
If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) = 0 Then
	This.TriggerEvent('ue_sort_Putaway')
END IF


end event

event ue_backorder();
String	lsOrderNo,	&
			lsNewOrder,	&
			lsInvType,	&
			lsShipRef,	&
			lsWarehouse,	&
			lsSupplier,	&
			lsSuppname,	&
			lsCarrier,	&
			lsShipVia,	&
			lsAgent,		&
			lsCustomsDoc, &
			lsRemarks,	&
			lsSuppOrder,	&
			lsOrdType,	&
			lsSKU,		&
			lsBOInd,	&
			sql_syntax, errors, lsLot, lsPO, lsPO2, lsCOO, lsDONO,	&
			lsRONO, lsNewRONO, &
			lsUF1, lsUF2, lsUF3, lsUF4, lsUF5, lsUF6, lsUF7, lsUF8, lsUF9, lsUF10, lsUF11,lsUF13, &
			lsContainer_Id,lsSourceType	//07-Dec-2015 :Madhu Added Source Type
			
String		lsClientCustPO, lsClientOrdType, lsClientInvoiceNbr, lsVendorInvoiceNbr, lsFromWHLoc, ls_order_type,ls_om_conf_type	
Long		llRowCount,	llRowPos, llNewRow,	llBatchSeq, llNewBatchSeq, llFindRow, llLineItemNo, llLinePos, llDetailRowCount, ll_om_change_req_nbr
			
Decimal	ldBOQty, ldEDIQty, ldSetQty
			
Int		liOrderSuffix, liRC, liCount

String lsOwnerId, lsAlternateSKU, lsUserLineItemNo, lsSerialNo  //TimA 05/13/11 Pandora issue #203
String ls_ShipmentDistributionNo, lsErrorText

DataStore	ldsDetail, ldsEDIDetail, ldsNotes, ldsAddress

Datetime ldt_exp_date,ldt_NeedByDate

//Create a back Order for the current Order

//Capture any necessary header fields
lsOrderNo = idw_main.GetItemString(1,"supp_invoice_no")
lsrono = idw_main.GetItemString(1,"ro_no")
lsdono = idw_main.GetItemString(1,"do_no")
lsInvType = idw_main.GetItemString(1,"inventory_type")
lsShipRef = idw_main.GetItemString(1,"ship_ref")
lsWarehouse = idw_main.GetItemString(1,"wh_code")
lsSupplier = idw_main.GetItemString(1,"supp_code")
lsSuppName = idw_main.GetItemString(1,"supp_Name")
lsCarrier = idw_main.GetItemString(1,"carrier")
lsShipVia = idw_main.GetItemString(1,"ship_via")
lsAgent = idw_main.GetItemString(1,"agent_info")
lsCustomsDoc = idw_main.GetItemString(1,"customs_doc")
lsRemarks = idw_main.GetItemString(1,"remark")
lsSuppOrder = idw_main.GetItemString(1,"Supp_order_no")
lsOrdType = idw_main.GetItemString(1,"ord_type")
llBatchSeq = idw_main.GetItemNumber(1,"edi_batch_seq_no")
lsSourceType =idw_main.GetItemString(1,"Source_Type")	//07-Dec-2015 :Madhu Added Source Type
//Pandora needs to keep the PO Line Type (transaction type) among other things so adding user fields...
lsUF1 = idw_other.GetItemString(1, "User_Field1") 
lsUF2 = idw_other.GetItemString(1, "User_Field2") 
lsUF3 = idw_other.GetItemString(1, "User_Field3") 
lsUF4 = idw_other.GetItemString(1, "User_Field4") 
lsUF5 = idw_other.GetItemString(1, "User_Field5") 
lsUF6 = idw_other.GetItemString(1, "User_Field6") 
lsUF7 = idw_other.GetItemString(1, "User_Field7") 
lsUF8 = idw_other.GetItemString(1, "User_Field8") 
lsUF9 = idw_other.GetItemString(1, "User_Field9") 
lsUF10 = idw_other.GetItemString(1, "User_Field10") 
lsUF11 = idw_other.GetItemString(1, "User_Field11") 
lsUF13 = idw_other.GetItemString(1, "User_Field13")  //06-Jan-2015 :Madhu -KLN B2B SPS Conversion


// 07/16 - PCONKL - Add new named fields


lsClientCustPO = idw_main.GetItemString(1,"client_cust_PO_Nbr")
lsClientOrdType = idw_main.GetItemString(1,"client_order_type")
lsClientInvoiceNbr = idw_main.GetItemString(1,"client_invoice_nbr")
lsvendorInvoiceNbr = idw_main.GetItemString(1,"vendor_invoice_nbr")
lsFromWHLoc =  idw_main.GetItemString(1,"from_wh_loc")
ll_om_change_req_nbr =idw_main.getitemnumber( 1, 'OM_CHANGE_REQUEST_NBR') //08-Aug-2017 :Madhu PINT-856
ls_order_type =idw_main.getitemstring( 1, 'OM_Order_Type') //28-Aug-2017 :Madhu PINT-856
ls_om_conf_type =idw_main.getitemstring( 1, 'OM_Confirmation_Type') //28-Aug-2017 :Madhu PINT-856


//Capture Detail info where received qty < shipped qty
ldsDetail = Create Datastore
ldsDetail.DataObject = 'd_ro_detail'
llRowCOunt = idw_detail.RowCount()

f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Start ue_backorder: ',lsrono,' ',' ' ,is_suppinvoiceno)

For llRowPos = 1 to llRowCount
	
	//10/07 - Account for Damage Qty when calculating backordered qty
	//If idw_detail.GetITemNumber(llRowPos,'alloc_qty') < (idw_detail.GetITemNumber(llRowPos,'req_qty') + idw_detail.GetITemNumber(llRowPos,'damage_qty')) Then
	If idw_detail.GetITemNumber(llRowPos,'Req_qty') > (idw_detail.GetITemNumber(llRowPos,'alloc_qty') + idw_detail.GetITemNumber(llRowPos,'damage_qty')) Then
		
		idw_detail.RowsCopy(llRowPos, llRowPos, Primary!, ldsDetail,1, Primary!)
		ldsDetail.SetItem(1,"req_qty", (idw_detail.GetITemNumber(llRowPos,'req_qty') - (idw_detail.GetITemNumber(llRowPos,'alloc_qty') + idw_detail.GetITemNumber(llRowPos,'damage_qty'))))
		ldsDetail.SetItem(1,"alloc_qty",0)
		// pvh - 09/20/06 - BobBugFound
		ldsDetail.object.damage_qty[ 1 ] = 0
		
	End If /*not all received*/
	
Next /*next existing detail row*/

//Jxlim 05/30/2012 BRD #371 If create_user of the initial order is 'IMPORT' set the create user to 'IMPORT' as well on BackOrder.
String ls_createuser
ls_createuser = idw_main.GetItemString(1, "create_user")

This.TriggerEvent("ue_new")

//Jxlim 06/01/2012 BRD #371 Set create_user after ue_new to IMPORT for Backorder of Its Imported order 
If ls_createuser = 'IMPORT' Then
	idw_main.SetItem(1, "create_user", ls_createuser)
End If

//Set the info on the new order

// TAM 2019/07/15 - DE11682 - Allow order number to be full size (>27)
//lsNewOrder = Trim(Left(lsOrderNo,27)) /* 08/01 - Pconkl - default new order to same number as original*/
lsNewOrder = Trim(lsOrderNo) /* 08/01 - Pconkl - default new order to same number as original*/

isle_code.text = lsNewOrder
Idw_main.SetITem(1,"supp_invoice_no",lsNewOrder)

//12/07 - PCONKL - added option at order type level to either retain the original order type or set to Backorder
Select backorder_type_ind into :lsBOInd
From Receive_ORder_Type
Where Project_id = :gs_project and ord_type = :lsOrdType;

If lsBOInd = 'Y' Then /*retain original order type*/
	Idw_main.SetItem(1,"ord_type",lsOrdType)
Else /*Backorder*/
	Idw_main.SetItem(1,"ord_type",'B') 
End If

Idw_main.SetITem(1,"Inventory_Type",lsInvType)

//07-Dec-2015 :Madhu Added Source Type -START
if Pos(lsSourceType,"/B") > 0 THEN
	idw_main.SetItem(1,"Source_Type",lsSourceType)
ELSE
	idw_main.SetItem(1,"Source_Type",lsSourceType+" /B")
END IF
//07-Dec-2015 :Madhu Added Source Type - END

idw_main.SetItem(1,"OM_CHANGE_REQUEST_NBR", ll_om_change_req_nbr) //08-Aug-2017 :Madhu PINT-856
idw_main.SetItem(1,"OM_Order_Type", ls_order_type) //28-Aug-2017 :Madhu PINT-856
idw_main.SetItem(1,"OM_Confirmation_Type", ls_om_conf_type) //28-Aug-2017 :Madhu PINT-856

//MEA - 05/09 - Use User_field9 for Ship_ref when "PHILIPS-SG"
// 12/12 - PCONKL - cloned for TPV
// 6/13 - MEA - cloned for FUNAI
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS

IF Upper(gs_project) = "PHILIPS-SG" or Upper(gs_project) ="PHILIPSCLS" or Upper(gs_project) = "TPV" or Upper(gs_project) = "FUNAI" or Upper(gs_project) = "GIBSON" THEN /*TAM 2015/03 - Added Gibson */
	Idw_Main.SetITem(1,"ship_ref",lsUF9)	
ELSE
	Idw_Main.SetITem(1,"ship_ref",lsShipRef)
END IF


Idw_Main.SetITem(1,"wh_code",lsWarehouse)
Idw_Main.SetITem(1,"supp_code",lsSupplier)
Idw_Main.SetITem(1,"supp_name",lsSuppname)
Idw_Main.SetITem(1,"carrier",lsCarrier)
Idw_Main.SetITem(1,"ship_via",lsShipVia)
If NOT gs_project = "FLEX-SIN" THEN
	Idw_Main.SetITem(1,"agent_info",lsAgent)
END IF
Idw_Main.SetITem(1,"customs_doc",lsCustomsDoc)
Idw_Main.SetITem(1,"do_no",lsDONO)

// 01/08 - MEA - Do not copy supp_order_no if Project is "PHXBRANDS"
//					  Copy it for all other projects.

If NOT gs_project = "PHXBRANDS" THEN
	Idw_Main.SetITem(1,"Supp_order_no",lsSuppOrder)
END IF


//02/06 - PCONKL - If we had a batch seq for original order, set to -1 here so we don't re-process the original edi records on putaway
// 12/07 - PCONKL - We now want to assign a new edi_batch_seq_no so we can process any records from the original file that need to be processed on the backorder

//If llBatchSeq > 0 Then llBatchSeq = -1
//Idw_Main.SetITem(1,"edi_batch_seq_no",llBatchSeq)

If llBatchSeq > 0 Then
	llNewBatchSeq =  g.of_next_db_seq(gs_project,'EDI_Inbound_Header','EDI_Batch_Seq_No')
	Idw_Main.SetITem(1,"edi_batch_seq_no",llNewBatchSeq)
	//TimA 03/26/15 added method trace call
     f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Insert Into EDI_Inbound_Header: Batch Seq No ' + String(llNewBatchSeq) ,lsrono,' ',' ' ,is_suppinvoiceno)
	//Create a new EDI_Inbound_Header Record (just the shell needed to avoid FK violation on the detail records)
	Execute Immediate "Begin Transaction" using SQLCA;
	Insert Into EDI_Inbound_Header (project_id, edi_batch_seq_no, order_seq_no, order_no, status_cd, Status_message) 
	values								(:gs_Project, :llNewBatchSeq, 1, :lsORderNo, 'C', 'Backorder');

	If sqlca.sqlcode <> 0 Then
		lsErrorText =sqlca.sqlerrtext
		Execute Immediate "ROLL BACK" using SQLCA;
	     f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Failed to create the EDI Header ' + lsErrorText ,lsrono,' ',' ' ,is_suppinvoiceno)		
		//MessageBox("Import","Unable to save changes to database!~r~r" +lsErrorText)
	Else
		Execute Immediate "COMMIT" using SQLCA;
	End if
End If

If lsremarks > ' ' Then
Else
	lsRemarks = "Back Order for Order Nbr: '" + lsOrderNo + "'"
End If
Idw_Main.SetITem(1,"remark",lsRemarks)

// 07/04 - PCONKL - For Logitech, we need to keep the original order type (instead of Backorder) and put 'backorder' in UF 3
If Upper(gs_Project) = 'LOGITECH' Then
	Idw_main.SetItem(1,"ord_type",lsOrdType) 
	idw_Main.SetItem(1,'user_field3','BACKORDER')
End If

uf_om_expansion(llBatchSeq, llNewBatchSeq) //28-Aug-2017 :Madhu PINT-856

// 07/16 - PCONKL - New named fields
Idw_main.SetItem(1,"client_cust_PO_Nbr",lsClientCustPO) 
Idw_main.SetItem(1,"client_order_type",lsClientOrdType) 
Idw_main.SetItem(1,"client_invoice_nbr",lsClientInvoiceNbr) 
Idw_main.SetItem(1,"vendor_invoice_nbr",lsvendorInvoiceNbr) 
Idw_main.SetItem(1,"from_wh_loc",lsFromWHLoc) 

// 04/09 - dts - Pandora needs to keep User_Field7 (transaction type), among others.
		// could probably do this for all, but nobody's asked so....
// 05/09 - PCONKL - Somebody (Philips) asked...


Idw_Other.SetItem(1, 'user_field1', lsUF1)
Idw_Other.SetItem(1, 'user_field2', lsUF2)
Idw_Other.SetItem(1, 'user_field3', lsUF3)
Idw_Other.SetItem(1, 'user_field4', lsUF4)
Idw_Other.SetItem(1, 'user_field5', lsUF5)
Idw_Other.SetItem(1, 'user_field6', lsUF6)
Idw_Other.SetItem(1, 'user_field7', lsUF7)
Idw_Other.SetItem(1, 'user_field8', lsUF8)
Idw_Other.SetItem(1, 'user_field9', lsUF9)
Idw_Other.SetItem(1, 'user_field10', lsUF10)
Idw_Other.SetItem(1, 'user_field11', lsUF11)
Idw_Other.SetItem(1, 'user_field13', lsUF13) //06-Jan-2015 :Madhu -KLN B2B SPS Conversion

// TAM 2015/07/31 Moved this below the userfield population above
// 2014/05 - TAM - Do not copy userFields 4,5,6 and Carrier  if Project is "Friedrich"
//					  Copy it for all other projects.

If  gs_project = "FRIEDRICH" THEN
	Idw_Other.SetITem(1,"User_Field2",'')
	Idw_Other.SetITem(1,"User_Field4",'')
	Idw_Other.SetITem(1,"User_Field5",'')
	Idw_Other.SetITem(1,"User_Field6",'')
	Idw_Other.SetITem(1,"Carrier",'')
END IF


//Set Detail Info...
ldsDetail.RowsCopy(1,ldsDetail.RowCount(),Primary!,idw_detail,1,Primary!)

//12/07 - PCONKL - If we have EDI records for this order, we need to try and reconcile what wasn't received and apply to backorder.
//							If we have multiple records per detail row, we may not get it right...
If llBAtchSeq > 0 Then
	
	//Create Datastore and Retreive all of the EDI detail records for the original order
	
	ldsEDIDetail = Create Datastore
	//TimA 05/23/11 Pandora issue #203
	sql_syntax = "Select line_item_no, SKU, Quantity, lot_no, po_no, po_no2, Inventory_Type, "
	sql_syntax += "Country_Of_Origin, Owner_ID, Alternate_SKU, User_Line_Item_No, Serial_no, Expiration_Date, Container_Id,  Shipment_Distribution_No, Need_by_Date "
	sql_syntax += "From Edi_Inbound_Detail "
	sql_syntax += "Where Project_id = '" + gs_project + "' "
	sql_syntax += "and edi_batch_Seq_no = " + String(llBatchSeq) + " "
	sql_syntax += "and order_no = '" + lsOrderNo + "' "
	//sql_syntax += "and Serial_No Not In (select serial_no from receive_putaway where ro_no = '" + lsrono + "')"
	sql_syntax += "and (Serial_no is null or Serial_no = '' or Serial_no = '-'  or Serial_No Not In (select serial_no from receive_putaway where ro_no = '" + lsrono + "'))" /* 05/12 - PCONKL - Need to include rows where there are no serial numbers on Putaway*/
	//08/2019 - MikeA - DE12016 - PhilipsCLS : BackOrder Putway Generate with previous order qty - Added Serial_no = '-'  - No Records were being retrieved for this datastore.
	sql_Syntax += "Order by Line_item_No, SKU "
		
	
//	sql_syntax = "Select line_item_no, SKU, Quantity, lot_no, po_no, po_no2, Inventory_Type, Country_Of_Origin "
//	sql_syntax += "From Edi_Inbound_Detail "
//	sql_syntax += "Where Project_id = '" + gs_project + "' and edi_batch_Seq_no = " + String(llBatchSeq) + " and order_no = '" + lsOrderNo + "' "
//	sql_Syntax += "Order by Line_item_No, SKU "

	ldsEDIDetail.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	IF Len(ERRORS) > 0 THEN
   	Messagebox(is_title,'Unable to retreive original EDI values.~r~rBackorder will still be created without copying values forward (Lot No, etc.).~r~r' + errors)
     f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Failed to retreive original EDI values :  '  ,lsrono,' ',' ' ,is_suppinvoiceno)
	Else		
		lirc = ldsEDIDetail.SetTransobject(sqlca)
		ldsEDIDetail.Retrieve()
	END IF
		
	//For each new detail record, create a new EDI Detail record
	lllinePos = 0
	//TimA 03/26/15 added method trace call
     f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Insert Into EDI_Inbound_Detail Records:  '  ,lsrono,' ',' ' ,is_suppinvoiceno)
	llDetailRowCount = idw_Detail.RowCount()
	Execute Immediate "Begin Transaction" using SQLCA;
	
	For llRowPos = 1 to idw_Detail.RowCount()
		
		ldBOQty = idw_detail.GetITemNumber(llRowPos, 'req_qty') /*BO Qty */
		//TimA 03/26/15 Added  Shipment_Distribution_No
		//dts - 11/04/2015 - For Pandora, we need to find by User Line/Project instead of Line/Distribution (Shipment Distribution project never went live, not because of SIMS)
		If gs_project = 'PANDORA' then
			//llFindRow = ldsEDIDetail.Find("Line_Item_No = " + String(idw_detail.GetITemNumber(llRowPos, 'Line_Item_No')) + " and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku')  + "'" + " and Shipment_Distribution_No = '" + Nz(idw_detail.GetITemString(llRowPos, 'Shipment_Distribution_No') ,'')+ "'",1, ldsEDIDetail.RowCount())
			//llFindRow = ldsEDIDetail.Find("User_Line_Item_No = '" + idw_detail.GetITemString(llRowPos, 'User_Line_Item_No') + "' and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku')  + "'" + " and po_no = '" + idw_detail.GetITemString(llRowPos, 'Shipment_Distribution_No') + "'",1, ldsEDIDetail.RowCount()) //23-MAY-2019 :Madhu DE10764 EDI Inbound Detail Records
			llFindRow = ldsEDIDetail.Find("User_Line_Item_No = '" + idw_detail.GetITemString(llRowPos, 'User_Line_Item_No') + "' and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku')  + "'",1, ldsEDIDetail.RowCount()) //23-MAY-2019 :Madhu DE10764 EDI Inbound Detail Records
		Else
			llFindRow = ldsEDIDetail.Find("Line_Item_No = " + String(idw_detail.GetITemNumber(llRowPos, 'Line_Item_No')) + " and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku') + "'",1, ldsEDIDetail.RowCount())
		End if
	   
		
		//Loop through EDI records for Detail until we match the BO Qty - We may have multiple records per detail - If so, we are not trying to reconcile against which lottlables have alredy been recieved - if someone bitc*es, we'll revisit
			
		Do While llFindRow > 0 and ldBOQty > 0
			
			lsLot = ldsEDIDetail.GetITemString(llFindRow,'Lot_no')
			lsSKU = ldsEDIDetail.GetITemString(llFindRow,'SKU')
			lsPo = ldsEDIDetail.GetITemString(llFindRow,'Po_no')
			lsPO2 = ldsEDIDetail.GetITemString(llFindRow,'Po_no2')
			lsCOO = ldsEDIDetail.GetITemString(llFindRow,'Country_of_Origin')
			lsInvType = ldsEDIDetail.GetITemString(llFindRow,'Inventory_Type')
			ldEDIQty = Dec(ldsEDIDetail.GetITemString(llFindRow,'Quantity'))
			
			//TimA 05/23/11 Pandora issue #203
			//TimA 03/26/15 ls_ShipmentDistributionNo, ldt_NeedByDate
			lsOwnerId = ldsEDIDetail.GetITemString(llFindRow,'Owner_Id')
			lsAlternateSKU = ldsEDIDetail.GetITemString(llFindRow,'Alternate_SKU')
			lsUserLineItemNo = ldsEDIDetail.GetITemString(llFindRow,'User_Line_Item_No')
			lsSerialNo = ldsEDIDetail.GetITemString(llFindRow,'Serial_No')			
			ls_ShipmentDistributionNo = Nz(ldsEDIDetail.GetITemString(llFindRow,'Shipment_Distribution_No'),'')
			ldt_NeedByDate = ldsEDIDetail.GetITemDateTime(llFindRow,'Need_By_Date')
			
			llLineItemNo = idw_detail.GetITemNumber(llRowPos, 'Line_Item_No')
			
			If ldEdiQty > ldBOQty Then
				ldSetQty = ldBOQty
				ldBOQty = 0
			Else
				ldSetQty = ldEDIQty
				ldBOQty = ldBOQty - ldEDIQty
			End If
			
			
			//MEA - 7/13 - Expiration Date and Container ID from the original EDI_Inbound_Detail record to the new one. Expiration Date is in the Insert SQL but the variable is not set before the insert.  Container ID is not even included.
			
			ldt_exp_date = ldsEDIDetail.GetItemDateTime(llFindRow,'Expiration_Date')	
			lsContainer_Id =  ldsEDIDetail.GetITemString(llFindRow,'Container_Id')	
			
			//Create a new EDI_Inbound_Detail Record 
			
			llLinePos ++
			//TimA 05/23/11 Pandora issue #203
			//TimA 03/26/15 Added ls_ShipmentDistributionNo, ldt_NeedByDate
			Insert Into EDI_Inbound_Detail (project_id, edi_batch_seq_no, order_seq_no, order_line_no, order_no, sku, line_item_no, Inventory_Type, Country_of_Origin, lot_no, po_no, po_no2, Quantity, Status_CD, Status_message,Owner_ID, Alternate_SKU, User_Line_Item_No, Serial_no, Expiration_Date, Container_Id, Shipment_Distribution_No, Need_By_Date) 
			values (:gs_Project, :llNewBatchSeq, 1, :llLinePos, :lsORderNo, :lsSKU, :llLineItemNo, :lsInvType,:lsCOO, :lsLot, :lsPO, :lsPO2, :ldSetQty, 'C', 'Backorder',:lsOwnerId,:lsAlternateSKU,:lsUserLineItemNo, :lsSerialNo, :ldt_exp_date, :lsContainer_Id, :ls_ShipmentDistributionNo, :ldt_NeedByDate);
			
			//Insert Into EDI_Inbound_Detail (project_id, edi_batch_seq_no, order_seq_no, order_line_no, order_no, sku, line_item_no, Inventory_Type, Country_of_Origin, lot_no, po_no, po_no2, Quantity, Status_CD, Status_message) 
			//values								(:gs_Project, :llNewBatchSeq, 1, :llLinePos, :lsORderNo, :lsSKU, :llLineItemNo, :lsInvType,:lsCOO, :lsLot, :lsPO, :lsPO2, :ldSetQty, 'C', 'Backorder');
	
			//dts - 11/02/2015 - If this is serialized, we've already used this line so don't need it anymore (and thus will use a different serial_no in the insert into EDI_Inbound_Detail
			if lsSerialNo > '-' then 
				ldsEDIDetail.DeleteRow( llFindRow ) 
			end if
			If ldBOQty = 0 or llFindRow = ldsEDIDetail.RowCOunt() Then
				llFindRow = 0
			Else
				llFindRow ++
				If gs_project = 'PANDORA' then
					//TimA 03/26/15 Added  Shipment_Distribution_No
					llFindRow = ldsEDIDetail.Find("Line_Item_No = " + String(idw_detail.GetITemNumber(llRowPos, 'Line_Item_No')) + " and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku')  + "'" + " and Shipment_Distribution_No = '" + Nz(idw_detail.GetITemString(llRowPos, 'Shipment_Distribution_No') ,'')+ "'",1, ldsEDIDetail.RowCount())
				Else
					llFindRow = ldsEDIDetail.Find("Line_Item_No = " + String(idw_detail.GetITemNumber(llRowPos, 'Line_Item_No')) + " and SKU = '" + idw_detail.GetITemString(llRowPos, 'Sku') + "'",llFindRow, ldsEDIDetail.RowCount())
				End if
			End If			
			
		Loop
		
	Next /*Detail */

	If sqlca.sqlcode <> 0 Then
		lsErrorText =sqlca.sqlerrtext
		Execute Immediate "ROLL BACK" using SQLCA;
	     f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','Failed to create the EDI Detail ' + lsErrorText ,lsrono,' ',' ' ,is_suppinvoiceno)		
		//MessageBox("Import","Unable to save changes to database!~r~r" +lsErrorText)
	Else
		Execute Immediate "COMMIT" using SQLCA;
		//TimA 03/26/15 added method trace call
   		 f_method_trace_special( gs_project,this.ClassName() + ' -ue_Backorder','End Insert Into EDI_Inbound_Detail: Rows added  ' + String(llDetailRowCount)  ,lsrono,' ',' ' ,is_suppinvoiceno)
	End if	
		
End If /*orignal received electronically*/

//4-MAR-2019 :Madhu PHILIPSCLS create EDI Expansion Records
//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic (F26536)
//If llBatchSeq > 0 and upper(gs_project) ='PHILIPSCLS'  Then wf_edi_inbound_expansion(lsOrderNo, llBatchSeq, llNewBatchSeq)
If llBatchSeq > 0 and (upper(gs_project) ='PHILIPSCLS' or upper(gs_project) ='PHILIPS-DA') Then wf_edi_inbound_expansion(lsOrderNo, llBatchSeq, llNewBatchSeq)

ib_changed = True
This.Title = "Receiving Back Order"

// dts 05/08 - don't allow user to change order no if order was electronically received.
if idw_Main.GetItemNumber(1, "edi_batch_seq_no") > 0 then
   Messagebox("Back Order Created", "A Back Order has been created!~r~r The order number is the same and can not be changed~rsince the order was received electronically.~r~rPlease enter the new Sched Arrival Date~rand make any necessary updates to the new order.")
	idw_Main.SetTabOrder("supp_invoice_no",0)
else
   Messagebox("Back Order Created","A Back Order has been created!~r~r The order number is the same - change if necessary.~r~rPlease enter the new Sched Arrival Date~rand make any necessary updates to the new order.")
end if

idw_main.SetFocus()
idw_main.SetColumn("arrival_date")

//09/08 - PCONKL - Want to save automagically for Diebold
// 04/15/09 - PCONKL - Save for all
//If gs_project = 'DIEBOLD' and (idw_Main.GetITemNumber(1,'edi_batch_Seq_No') > 0 or idw_Main.GetItemString(1,'ord_type') = 'P') Then
	This.triggerEvent('ue_save')
//End If
	
//04/09 - PCONKL - Copy Notes and Return address (Receive_Alt_Address) if present
lsNewrono = idw_main.GetItemString(1,"ro_no")

ldsAddress = Create Datastore
ldsAddress.DataObject = 'd_ro_return_Address'
ldsAddress.SetTransObject(SQLCA)
llRowCount = ldsAddress.Retrieve(gs_project, lsRono)

If llRowCount> 0 Then
	
	ldsAddress.RowsCopy(1,ldsAddress.RowCount(),Primary!,ldsAddress,99999,Primary!)
	For llRowPos = llRowCount + 1 to ldsAddress.RowCount()
		ldsAddress.SetITem(llRowPos,'ro_no',lsNewRoNO)
	Next
	
	Execute Immediate "Begin Transaction" using SQLCA; 
	ldsAddress.Update()
	Execute Immediate "COMMIT" using SQLCA;
	
End If

ldsNotes = Create Datastore
ldsNotes.DataObject = 'd_ro_notes'
ldsNotes.SetTransObject(SQLCA)
llRowCount = ldsNotes.Retrieve(lsRono)

If llRowCount> 0 Then
	
	ldsNotes.RowsCopy(1,ldsNotes.RowCount(),Primary!,ldsNotes,99999,Primary!)
	For llRowPos = llRowCount + 1 to ldsNotes.RowCount()
		ldsNotes.SetITem(llRowPos,'ro_no',lsNewRoNO)
	Next
	
	Execute Immediate "Begin Transaction" using SQLCA; 
	ldsNotes.Update()
	Execute Immediate "COMMIT" using SQLCA;
	
End If

end event

event ue_asn();// 11/01 - PCONKL - Process any ASN information onto Putaway list

Str_parms	lStrparms

lStrParms.String_arg[1] = idw_main.GetITemString(1,'supp_Invoice_No') /*order # to retrieve ASN for*/
// pvh gmt 12/15/05
// needed to pass warehouse code 
IstrParms.String_arg[2] = idw_main.object.wh_code[1]

OpenSheetwithparm(w_proc_asn_Order,lstrparms, w_main, gi_menu_pos, Original!)
end event

event ue_post_confirm();//Any Project Specific processing that needs to occur after the order has been confirmed

Long	llRowPos, llRowCount
String	lsPalletSave, lsPallet, lsRoNo, lsInvoice, lsWH, lsLocType, lsLCode, lsCOO, lsSKU
String lsPoNo, lsPoNo2, lsCntrId
Decimal ldOwnerId
Long	ll_method_trace_id

//TimA 07/14/2011 Pandora issue #255
Datastore ldsDetailMaster
String sql_syntax, ERRORS, ls_Sku, lsFind, lsDoNo, sql_syntax_Update, lsErrText
long ll_Line_No, llFindRow
Decimal ld_Price, ld_Cost
dwItemStatus l_status
integer li_ret

//TimA 09/29/11 Pandora issue #287 Add three days to the delivery date if multi-stage order
Date ld_Complete, ld_OrderDate
Date ld_Complete3
//TimA 07/17/12 Pandora issue #360.  Populate the outbound delivery date with the inbound complete date.
Datetime ldtDeliveryDate

Date ld_RequestDate
String lsCountyOutbound, lsCountryInbound
String lsCustIdOutBound, lsCustIdInBound, lsWHCodeOutbound,lsOutboundFromLoc
String ls_Message
String ls_Test

lsRoNo = idw_Main.GetItemString(1,'ro_no')

if Upper( gs_project ) = '3COM_NASH'  and idw_main.GetItemString(1, "ord_type") = 'X' then
	doCreateBatchTrans()
end if


//10/08 - PCONKL - For Comcast, we want to update the Carton Serial Table to reflect the Ro_NO for each Pallet received
//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse - Putaway  --- Replacing COMCAST code since project is long gone
If gs_project = 'PANDORA' Then

	
	llRowCount = idw_Putaway.RowCount()
	For lLRowPOs = 1 to llRowCount
		lsWH = idw_main.getitemstring(1, 'wh_code')
		lsLCode = idw_Putaway.GetITemString(llROwPos,'l_code')
		lsCOO = idw_Putaway.GetITemString(llROwPos,'country_of_origin') 
		lsSKU = idw_Putaway.GetITemString(llROwPos,'sku')
		lsPoNo = idw_Putaway.GetITemString(llROwPos,'po_no')
		lsPoNo2 = idw_Putaway.GetITemString(llROwPos,'po_no2') 
		lsCntrId = idw_Putaway.GetITemString(llROwPos,'container_id')
		ldOwnerId = idw_Putaway.GetITemNumber(llROwPos,'owner_id')
		lsLocType = getLocType(lsWH, lsLCode)
		
		If lsLocType = 'Z' Then	//Kitting location only
			li_ret	= 	sqlca.sp_merge_kitting_location_records(gs_project, lsWH, lsLCode, lsSKU, lsRoNo, lsCOO, lsPoNo, lsPoNo2, lsCntrId, ldOwnerId)
			f_method_trace_special( gs_project,this.ClassName() + 'Pandora Kitting-ue_post_confirm','ue_post_confirm PANDORA: ',lsRoNo,' ',' ',is_suppinvoiceno ) 
		End If
		
	Next /*Putaway*/
	
End If

if gs_project = 'PANDORA' then
	
	// cawikholm 07/05/11 Added call to track user 
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','start ue_post_confirm PANDORA: ',lsRoNo,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
	
	// Change order from 'Hold' to 'New' if necessary...
	lsWH = idw_main.getitemstring(1, 'wh_code')
	
	lsInvoice = idw_main.getitemstring(1, 'supp_invoice_no')
	//if the 1st move was from a DCWH isntead of a DC, the receipt will end in '_DCWH' but the order on 'HOLD' will not...
	if right(lsInvoice, 5) = '_DCWH' then
		lsInvoice = left(lsInvoice, Len(lsInvoice) - 5)
	end if
	
	//TimA 07/14/2011 Pandora issue #255
	ldsDetailMaster = Create Datastore		
	sql_syntax = "select Delivery_Master.invoice_no,Delivery_Detail.*"
	sql_syntax += " from Delivery_Detail, Delivery_Master "
	sql_syntax += " where Delivery_Detail.DO_No = Delivery_Master.DO_No "
	sql_syntax += " and Delivery_Master.Project_ID = 'PANDORA' "
	sql_syntax += " and Delivery_Master.Ord_Status = 'H' "
	sql_syntax += " and (Delivery_master.invoice_no = '" + lsInvoice + "' or Delivery_master.invoice_no = '" + lsInvoice + "_2'" + ")"
			
					
	ldsDetailMaster.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", ERRORS))
	IF Len(Errors) > 0 THEN
		if not ib_batchconfirmmode then	// LTK 20150130 batch confirm
			messagebox(is_title, "*** Unable to create datastore for updating price.~r~r" + Errors)
		end if
	else
		ldsDetailMaster.SetTransObject(SQLCA)
		llRowCount = ldsDetailMaster.Retrieve()	
	end if
	
	//TimA Pandora issue #287		
	//Look for the Outbound order
	select WH_Code,Cust_Code, user_field2  
	INTO :lsWHCodeOutbound, :lsCustIdOutBound, :lsOutboundFromLoc 
	from Delivery_Master 
	where Project_ID = 'PANDORA' 
	and Ord_Status = 'H' 
	and WH_Code = :lsWH
	and (invoice_no = :lsInvoice or invoice_no = :lsInvoice + '_2');
	
	//TimA 07/18/12 Pandora issue #452 grab the complete date and set the outbound delivery date when the order is confirmed
	ldtDeliveryDate = Datetime(idw_main.GetItemDateTime(1,"complete_date"))
	
	If lsWHCodeOutbound <> '' and lsCustIdOutBound <> '' and lsOutboundFromLoc<> '' then
		ld_RequestDate = wf_calculate_rdd(Date(idw_main.GetItemDateTime(1,"complete_date")),lsWH,lsCustIdOutBound,lsOutboundFromLoc, ls_Message)
	end if
		
	
	For llRowPos = 1 to llRowCount
		
		ll_Line_No = ldsDetailMaster.getitemnumber(llRowPos, 'line_item_no')
		ls_Sku = ldsDetailMaster.getitemstring(llRowPos, 'sku')
		ld_Price = ldsDetailMaster.getitemnumber(llRowPos, 'Price')
		lsDoNo= ldsDetailMaster.getitemString(llRowPos, 'Do_No')

		
		//Find the matching records based on the line number and sku
		lsFind = "line_item_no = " + string(ll_Line_no)  + " and Upper(sku) = '" + ls_sku + "'"
		llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
		If llFindRow >0 Then
			ld_cost = idw_detail.getitemnumber(llFindRow,"cost")
			If ld_cost > 0 then
				sql_syntax_Update = "update Delivery_Detail Set delivery_detail.Price =" + string(ld_cost) + " from Delivery_Detail, Delivery_Master  "
				sql_syntax_Update += " where Delivery_Detail.DO_No = Delivery_Master.DO_No "
				sql_syntax_Update += " and Delivery_Master.Project_ID = 'PANDORA' "
				sql_syntax_Update += " and (Delivery_master.invoice_no = '" + lsInvoice + "' or Delivery_master.invoice_no = '" + lsInvoice + "_2'" + ") and Delivery_Detail.DO_No = '" + lsDoNo + "'"
				sql_syntax_Update += " and Delivery_Detail.SKU = '" + ls_Sku + "'"
			
				Execute Immediate :sql_syntax_Update Using SQLCA;
				If sqlca.sqlcode <> 0 Then
					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	
					Execute Immediate "ROLLBACK" using SQLCA;
				//TimA 02/12/14 Added new Method Trace calls
				f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','Unable to save the price on the outbound order: ',is_rono,' ', lsErrText ,is_suppinvoiceno) 									
				//Messagebox("Import","Unable to save the price on the outbound order!~r~r" + Nz(lsErrText,'' ) )
				wf_display_message("Unable to save the price on the outbound order!~r~r" + Nz(lsErrText,'' ))	// LTK 20150130 batch confirm
				SetPointer(Arrow!)
				Return
				End If
			else
				//Set the cost field with the price from the delivery order
				idw_detail.SetItem(llFindRow,"cost",ld_Price)
			end if
		end if	
	Next 

// GailM #608 Set save from confirm to true to bypass wf_validation
ib_save_via_confirm = true

If This.Trigger Event ue_save() = 0 Then
	//TimA 09/29/11 Pandora issue #287
	//TimA 05/01/12 Pandora issue #410.  Set the Outbound OTM Status to Sweeper Hold when confirming the inbound side of the multi stage order
	Execute Immediate "Begin Transaction" using SQLCA;	
	//set Last_User and Last_update as well?	
	//	set ord_status = 'N', 	request_date = :ld_RequestDate
	update delivery_master
	set ord_status = 'N', 	OTM_Status = 'S', request_date = :ld_RequestDate
	where project_id = 'PANDORA'
	and wh_code = :lsWH
	and (invoice_no = :lsInvoice or invoice_no = :lsInvoice + '_2')
	and ord_status = 'H';
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		//TimA 02/12/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','Update failed on Delivery Master setting ord_status to N and the OTM_Status to S: ',is_rono,' ', lsErrText ,is_suppinvoiceno) 														
	End if
	//TimA 07/18/12 Pandora issue #452 update the delivery_date on the outbound order with the complete date
	//Only for warehouse transfers and the outbound order is not voided.
	If idw_main.GetItemString(1, "ord_type") = 'Z' then //Warehouse transfer
			If Not IsNull(ldtDeliveryDate ) then
				Execute Immediate "Begin Transaction" using SQLCA;	
					update delivery_master
					Set delivery_date = :ldtDeliveryDate, ord_status = 'D'
					where project_id = 'PANDORA'
					and (invoice_no = :lsInvoice or invoice_no = :lsInvoice + '_2') and ord_status =  'C';		
				Execute Immediate "COMMIT" using SQLCA;
				If sqlca.sqlcode <> 0 Then
					lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Execute Immediate "ROLLBACK" using SQLCA;
					//TimA 02/12/14 Added new Method Trace calls
					f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','Update failed on Delivery Master setting ord_status to D: ',is_rono,' ', lsErrText ,is_suppinvoiceno) 														
				End if
			End if
	End if
Else
	//TimA 02/12/14 Added new Method Trace calls
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','The save failed: ',lsRoNo,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 :Madhu added	
End if
	//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_post_confirm PANDORA' ) //08-Feb-2013 :Madhu commented
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_post_confirm','End ue_post_confirm PANDORA: ',lsRoNo,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 :Madhu added
	If ls_Message <> '' then
		if not ib_batchconfirmmode then	// LTK 20150130 batch confirm
			Messagebox('',ls_Message)
		end if
	end if
	
end if

// GailM 06/23/2014 - Pandora Issue 703 - Reset ib_save_via_confirm to false for the next order.  (Also baseline issue)
ib_save_via_confirm = false

end event

event ue_process_shipments();u_nvo_shipments	lu_Shipments
String	lsShipNo
Str_parms	lstrParms

lu_shipments = Create u_nvo_Shipments

//Validate that necessary fields are present before creating/Updating Shipment
if lu_shipments.uf_validate_inbound(idw_main, idw_detail.RowCount()) < 0 then return //message is in validate function

If ib_changed Then
	messagebox(is_title,'Please save changes first!',StopSign!)
	return
End If

lsShipNo = lu_shipments.uf_create_inbound_Shipment(idw_main, idw_Detail)

If lsShipNo <> "-1" Then 
	lstrparms.String_Arg[1] = lsShipNo
	OpenSheetwithparm(w_shipments,lStrparms, w_main, gi_menu_pos, Original!)
End If

end event

event ue_workorder();String	lsRoNO, lsWONO, lsOrder, lsWarehouse, lsInvoiceNo, lsErrText, lsSKU, lsSupplier, lsWOList
Long	llWONO, llCount, llRowPos, llRowCount, llOwner, llLineitemNo
decimal	ldReqQty
DateTime	ldtToday

Long	ll_method_trace_id

// cawikholm 07/05/11 Added call to track user 
SetNull( ll_method_trace_id )
//f_method_trace( ll_method_trace_id, this.ClassName(), 'Start ue_workorder: ' + is_rono ) //08-Feb-2013  :Madhu commented

//See if we already have a workorder for this Receive Order, If so, we can only update if in New Status (Not picked or putaway)

ldtToday = dateTime(Today(),Now())
lsRONO = idw_Main.GetITemString(1,'ro_no')
lsInvoiceNo = idw_Main.GetITemString(1,'supp_invoice_No')
lsWarehouse = idw_main.GetITemString(1,'wh_code')

f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','start ue_workorder: ',lsRONO,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
//For Each Detail That requires Packaging, create a WO header and Detail Record

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

llRowCount = idw_Detail.RowCount()
For lLRowPos = 1 to llRowCount
	
	lsSKU = idw_detail.GetITemString(llRowPos,'SKU')
	lsSupplier = idw_detail.GetITemString(llRowPos,'Supp_code')
	llOwner = idw_detail.GetITemNumber(llRowPos,'owner_id')
	llLineITemNo = idw_detail.GetITemNumber(llRowPos,'line_item_no')
	ldReqQty = idw_detail.GetITemNumber(llRowPos,'req_qty')
					
	Select Count(*) into :llCount
	From Item_component
	Where Project_id = :gs_Project and Sku_parent = :lsSKU and Supp_Code_Parent = :lsSupplier and component_Type = 'P';
	
	If llCount < 1 Then Continue /*WO Not needed for this Item*/
	
	//See if we already have a WO for this Line ITem (previous generation of Putaway)
	Select Count(*) into :llCount
	From Workorder_Detail
	Where sku = :lsSKU and Supp_Code = :lsSupplier and Line_Item_no = :llLineItemNo and
			wo_no in (Select wo_no from WorkOrder_MAster where do_no = :lsRoNo);
			
	If llCount > 0 Then Continue /*already created*/
		
	//Next ID
	llWOno = g.of_next_db_seq(gs_project,'WorkOrder_Master','WO_No')
	If llWOno <= 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		messagebox(is_title,"Unable to retrieve the next available order Number!")
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder ' + "Unable to retrieve the next available order Number!" ) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder ' + "Unable to retrieve the next available order Number!" ,lsRONO,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
		Return 
	End If
	
	lsWONO = Trim(Left(gs_project,9)) + String(llWOno,"0000000")
	lsORder = Right(lsWONO,7)

	Insert into Workorder_MAster (wo_no, project_id, ord_type, ord_date, Delivery_Invoice_NO, workorder_number, ord_status, wh_code, priority, do_no, last_user, last_Update)
							Values (:lsWONO, :gs_project, "P", :ldtToday, :lsInvoiceNo, :lsOrder, "N", :lsWarehouse, 1, :lsRONO, :gs_userid, :ldtToday)
	Using SQLCA;			
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox(is_title,"Unable to create new WorkOrder MASTER record.!~r~r" + lsErrText)
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder ' + "Unable to create new WorkOrder MASTER record.! " + lsErrText ) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder ' + "Unable to create new WorkOrder MASTER record.! " + lsErrText ,lsRONO,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
		Return
	End If
		
	Insert Into workorder_Detail (wo_no, line_item_no, SKU, supp_code, Owner_ID, SKU_Parent, Component_ind, Req_qty, Alloc_Qty)
	Values								(:lsWONO, :llLineITemNo, :lsSKU, :lsSUpplier, :llOwner, :lsSKU, "Y", :ldReqQty, 0)
	Using SQLCA;
					
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox(is_title,"Unable to create new WorkOrder DETAIL record.!~r~r" + lsErrText)
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder ' + "Unable to create new WorkOrder DETAIL record.! " + lsErrText ) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder ' + "Unable to create new WorkOrder DETAIL record.! " + lsErrText ,lsRONO,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
		Return
	End If
	
	//For GM, we also want to reserve this stock for this WO - Put WO_NO in Lot No - WO is coded for that
	If gs_project = 'GM_MI_DAT' Then
		
		Update Receive_Putaway
		Set lot_no = :lsWONO
		Where ro_no = :lsRONO and Line_Item_No = :llLineItemNo and sku = :lsSKU
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox(is_title,"Unable to update Receive Putaway record to allocate stock for WO.!~r~r" + lsErrText)
			//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder ' + "Unable to update Receive Putaway record to allocate stock for WO.! " + lsErrText ) //08-Feb-2013  :Madhu commented
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder ' + "Unable to update Receive Putaway record to allocate stock for WO.! " + lsErrText ,lsRONO,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
			Return
		End If
	
	End If
	
	lsWOList += ", " + lsOrder
	
Next /*Detail Record*/

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox(is_title,"Unable to Commit changes! No changes made to Database!")
	//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder ' + "Unable to Commit changes! No changes made to Database!" ) //08-Feb-2013  :Madhu commented
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder ' + "Unable to Commit changes! No changes made to Database!",lsRONO,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
	Return 
End If
		
lsWOList = Mid(lsWOList,3,999999)

If lsWOList = "" Then
	Messagebox(is_title, "No new Workorders were created.")
ElseIf Pos(lsWoList,',') > 0 Then
	Messagebox(is_title, "Workorders: " + lsWOList + " have been created.")
Else
	Messagebox(is_title, "Workorder #: " + lsWOList + " has been created.")
End If

//Re-retreive Putaway list so Lot NO's can be copied to content if they confirm right away
If gs_project = 'GM_MI_DAT' Then idw_putaway.Retrieve(lsRONO, gs_project)

//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_workorder' )  //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' -ue_workorder','End ue_workorder: ',lsRONO,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
end event

event ue_sort_putaway();String	lswarehouse, lsSort

//02/06 - PCONKL - we may have a project/warehouse level sort on the Putaway (Screen and report will be sorted the same if present)
If idw_Main.RowCount() < 1 or idw_Putaway.RowCount() < 1 Then Return

idw_Putaway.SetRedraw(False)

lsWarehouse= idw_main.GetITemString(1,'wh_Code')

If g.of_project_warehouse(gs_project,lswarehouse) > 0 Then
	if g.ids_project_warehouse.GetITemString(g.of_project_warehouse(gs_project,lswarehouse),'Receive_putaway_Sort_order') > "" Then
		
		lsSort = g.ids_project_warehouse.GetITemString(g.of_project_warehouse(gs_project,lswarehouse),'Receive_putaway_Sort_order')
		
		//If we have any components, we need to sort by Sku Parent, Comp NO and Comp ind (D)
		If idw_Putaway.Find("Component_No > 0",1, idw_putaway.RowCount()) > 0 Then
			
		End If
		
		idw_putaway.SetSort(lsSort)
				
	End If
	
End If

idw_Putaway.Sort()
idw_Putaway.SetRedraw(True)
end event

event ue_generate_putaway_server();// 07/06 - PCONKL - Putaway lists now being generated on Websphere
//TimA 02/06/13 changed ll_row to ll_rows because of a compiling problem
//Harold declared ll_rows in the Instance varables.   It was just easier to change it here rather than find out where it is use for the instance varable.

String ls_sku, ls_wh, ls_type, ls_loc, ls_order,  lsSupplier,  lsFind, ls_INActiveCustomerName, ls_hs_code// TAM W&S 04/2011
String lsLocSave, lsContract, lsOwnerName,	lsxml, lsXMLResponse, lsReturnCode, lsReturnDesc
string lsDeleteExisting, lsIMIID,lsContainerID, ls_ToProject, ls_GeneratedProject, ls_OwnerCD, ls_wh_code		//#883
string ls_location_org, ls_cur_cd, lsSKU, lsInactiveSKU, lsLine, lsSkuSupplier_Hold
String ls_serial, ls_user, ls_UpperUser, ls_createuser, ls_detail_find
String ls_WghDim, ls_cube_scan, ls_sku_or_skus,ls_sku_list,ls_List_of_Skus,  ls_serial_Ind, ls_pono2_Ind, ls_container_Ind

Integer li_idx, liMsg

Long	 llArrayPos, llCount, ll_owner_id, ll_Owner_Prev, ll_method_trace_id, llDetailFind
Long ll_rows, ll_cnt,i,j,  llRowCount, llLoopCount,llEDIBatch, llLineItem, llFindRow

Decimal	ldReqQty, ldSetQty, ldRCVQty[], ldPendingQty, ldUnitWT, ld_std_cost, ld_price_1, ld_price_2
Boolean	lbContractExists, lb_WghDimValidate
DateTime	ldtToday, ldtGMT, ldt_expiration_date

//dts Long ll_SkuCount

ls_WghDim = 'N'
lb_WghDimValidate = False


// pvh - 08/28/06 for petec
If idw_Detail.rowcount() = 0 Then
	Messagebox(is_title,'At least 1 Detail Row must be entered before generating the Putaway list.')
	Return
End If
// eom
//Detail rows must be saved since server will retrieving instead of looping thru list
If ib_changed Then
	Messagebox(is_title,'Please save your changes first.')
	Return
End IF

// cawikholm 07/05/11 Added call to track user 
SetNull( ll_method_trace_id )
//f_method_trace( ll_method_trace_id, this.ClassName(), 'Start ue_generate_putaway_server: ' + is_rono ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','Start ue_generate_putaway_server: ',is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
ls_wh_code = idw_main.GetItemString(1, 'wh_code')
If gs_project = 'PANDORA' then
	//TimA 03/14/14 Pandora issue #708
	Select User_Updateable_Ind INTO :ls_WghDim FROM lookup_table with (NoLock) 
	Where Project_ID = :gs_project AND Code_Type = 'CUBE_SCAN' and Code_Id = :ls_wh_code  USING SQLCA;
End if
// dts 2010/07/05 - Not allowing put-away generation if there are any 'Inactive' SKUs (item_delete_ind = Y)
// 9/29/10 - only looking in database if the sku changed....
FOR li_idx = 1 to idw_detail.RowCount()
	lsSKU = idw_detail.GetItemString(li_idx,"sku")
	lsSupplier = idw_detail.GetItemString(li_idx,"supp_code")
	if lsSKU + lsSupplier <> lsSkuSupplier_Hold then
		lsSkuSupplier_Hold = lsSKU + lsSupplier //dts - 2014-04-24 - the 'hold' variable was not being set so it was doing the check for each line (probably not a big impact)
		//dts - 2014-04-24 - Pandora #844 - moving hard stop to printing of Put-away list (and making this Pandora-specific)
		if gs_Project = 'PANDORA' then
			//TimA 03/14/14 added a lookup value that Pandora needs for issue #708
			Select item_delete_ind, User_Field20 Into :lsInactiveSKU, :ls_Cube_Scan
			FROM item_master
			Where project_id = :gs_project
			and supp_code = :lsSupplier
			and sku = :lsSKU;
		end if
		if lsInactiveSKU = 'Y' then
			lsLine = string(idw_detail.GetItemNumber(li_idx,"line_item_no"))
			messagebox("Inactive SKU", "SKU '" + lsSKU + "' (line " + lsLine +") is Inactive!  Order can not be processed")
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End ue_generate_putaway_server ' + "SKU '" + lsSKU + "' (line " + lsLine +") is Inactive!  Order can not be processed",is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
			return
		end if
		if gs_Project = 'PANDORA' then //dts - 2014-04-24 - added condition on Project 
			//TimA 03/14/14 Pandora issue #708
			//Should only validate if Pandora order
			If ls_WghDim = 'Y' then //  - Wgt/Dims capture is turned on for this Warehouse
				 If ls_cube_scan= '' or IsNULL( ls_cube_scan)  Then //Cubiscan is missing in the Item Master file UF20 (dts - moved this comment from line above)
					if Len(ls_sku_list) > 0 then
						if Pos(ls_sku_list,lsSKU ) = 0 then
							//dts ll_SkuCount += 1
							ls_sku_list += ", " + lsSKU
						end if
					else
						ls_sku_list = lsSKU
					end if
					//if ll_SkuCount > 1 then //dts - 2014-04-24 = changed from 0 to 1
					//	//dts ls_sku_or_skus = "GPN(s) are "
					//	ls_sku_or_skus = "GPNs "
					//else
					//	//dts ls_sku_or_skus = "GPN is "
					//	ls_sku_or_skus = "GPN "
					//end if
					lb_WghDimValidate = True
				End if 
			End if
		end if //Pandora
	end if //sku (plus supplier) changes...
next

If lb_WghDimValidate = True then //This should only fire on Pandora orders that are missing wts/dims
	//On curtin WH don't allow the putaway if wgh and dims are missing.  This list of WH can be found in the lookup table under CUBE_SCAN
	if not ib_batchconfirmmode then
		MessageBox("GPN Weights/Dims missing", "Dims/wts for the following GPN(s) have not been validated by the Cubiscan. Please measure these parts: ~r~r" + ls_sku_list )
	end if
//	Return //dts - 2014-04-24 - Commented out the Return - no longer a hard stop at putaway generation.
End if

// 07/06 - PCONKL - Set Putaway Start Time on MAster
ldtGMT = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
idw_main.SetItem(1,'Putaway_start_Time',	ldtGMT  ) 
//08/29/05 - for Auto-created orders (from Outbound Warehouse Transfers)...
string lsDONO, lsLotArray[], lsPOArray[], lsPO2Array[], lsSerialArray[], lsInvTypeArray[], lsSuppArray[]
DateTime ldtExpArray[], ldtNullArray[]
long llRowCountPick
Datastore luds_picking

// pvh
string lsDetailUserField1
//
 // pvh - 03.10.06 - MARL
integer returncode

SetPointer(HourGlass!)
ldtToday = DateTime(today(),Now())


//// 07/06 - PCONKL - For GM Detroit, If we haven't already done an IMS verify for the order (when loading through ASN), promt now...
//If gs_project = 'GM_MI_DAT' Then
//	
//	If not isDate(idw_Main.GetITemString(1,'user_Field1')) or idw_Main.GetITemString(1,'user_Field1') = "" or isnull(idw_Main.GetITemString(1,'user_Field1')) Then
//		
//		If Messagebox(is_title, "This order has not been verified with the GM IMS system.~r~rWould you like to do it now?",Question!,YesNo!,1) = 1 Then
//			tab_main.tabpage_OrderDetail.cb_ims_verify.TriggerEvent("clicked")
//		End If
//		
//	End IF
//
//End If /* GM */

if gs_project = 'PANDORA' then
	// - make sure owner is set to a valid WH-customer for selected warehouse
	long lltest
	lltest = idw_detail.RowCount()
	FOR li_idx = 1 to idw_detail.RowCount()
				
		ll_Owner_ID = idw_detail.GetItemNumber(li_idx, "owner_id")
		lsOwnername = idw_detail.GetItemString(li_idx,"c_owner_name")
		ls_INActiveCustomerName = '' 
		 		
		//3/10 JAyres Check to see if Customer is Active
		If Right(Trim(lsOwnername), 3) = '(C)' Then
			
			Select Distinct dbo.Customer.Cust_Name
			Into    	:ls_INActiveCustomerName
			FROM 	dbo.Owner,
		         		dbo.Customer
			Where 	dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
			and    	dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
			and 		dbo.Owner.Owner_ID 		= :ll_Owner_ID 
	    		and 		dbo.Customer.Customer_Type 	= 'IN' 
			and 		dbo.Owner.Project_ID 		= :gs_project;
	
			If NOT ( ls_INActiveCustomerName= '' or IsNULL( ls_INActiveCustomerName) ) Then
				If IsNull( lsOwnername  ) then  lsOwnername = ''
				MessageBox(is_title, "Owner Name: "+   lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail.~r~rPlease Enter an Active Owner then Regenerate." )	
				//f_method_trace( ll_method_trace_id, this.ClassName(), 'End Pandora ue_generate_putaway_server ' + "Owner Name: "+   lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail. Please Enter an Active Owner then Regenerate."  ) //08-Feb-2013  :Madhu commented
				f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End Pandora ue_generate_putaway_server ' + "Owner Name: "+   lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail. Please Enter an Active Owner then Regenerate.",is_rono,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
				return
			End If
		End If
			
		if ll_owner_id <> ll_Owner_Prev then
			select owner_cd
			into :ls_OwnerCD
			from owner
			where project_id = 'PANDORA'
			and owner_id = :ll_Owner_ID;
			
			Select user_field2
			Into :ls_wh
			From Customer
			Where Project_id = :gs_project and Cust_Code = :ls_OwnerCD;
			
			if isnull(ls_wh) or ls_wh <> idw_main.GetItemString(1, 'wh_code') then
				messagebox(is_title, "Must set Owner to valid Receiving Location.")
				tab_main.selecttab("tabpage_orderdetail")
				//f_method_trace( ll_method_trace_id, this.ClassName(), 'End Pandora ue_generate_putaway_server ' + "Must set Owner to valid Receiving Location."  ) //08-Feb-2013  :Madhu commented
				f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End Pandora ue_generate_putaway_server ' + "Must set Owner to valid Receiving Location." ,is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013  :Madhu added
				return
			end if
		end if
	NEXT
	
Else
	
	//3/10 JAyres Check to see if Owner is Active
	FOR li_idx = 1 to idw_detail.RowCount()
		ll_Owner_ID = idw_detail.GetItemNumber(li_idx, "owner_id")
		lsOwnername = idw_detail.GetItemString(li_idx,"c_owner_name")
		lsDetailUserField1 = idw_detail.GetItemString(li_idx,"user_field1")
		
		ls_INActiveCustomerName = '' 
		 
		Select Distinct dbo.Customer.Cust_Name
		Into    	:ls_INActiveCustomerName
		FROM 	dbo.Owner,
		         	dbo.Customer
		Where 	dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
			and    dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
			and 	dbo.Owner.Owner_ID 		= :ll_Owner_ID 
	    		and 	dbo.Customer.Customer_Type 	= 'IN' 
			and 	dbo.Owner.Project_ID 		= :gs_project;
			
		If NOT ( ls_INActiveCustomerName= '' or IsNULL( ls_INActiveCustomerName) ) Then
			MessageBox(is_title, "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail.~r~rPlease Enter an Active Owner then Regenerate." )	
			//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_generate_putaway_server ' + "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail. Please Enter an Active Owner then Regenerate."  ) //08-Feb-2013  :Madhu commented
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End ue_generate_putaway_server ' + "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(li_idx) +" of Order Detail. Please Enter an Active Owner then Regenerate.",is_rono,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
			return
		End If	
		
	Next
end if


// 09/02 - PCONKL - remove a filtered Putaway list (Components, etc.)
wf_set_comp_filter('Remove')
// 08/06 - PCONKL - For server based putaway, we need to delete existing putaway records and reset status to "N" since we are using
//							Content_Full to assign locations (SIT included in available for location). This will happen on the server.

// 01/07 - PCONKL - allow to keep existing records - server will generate based on Req Qty - Alloc Qty

//If idw_putaway.RowCount() > 0 Then 
//	If messagebox(is_title,"Existing records will be deleted.~r~rContinue?",Question!,yesNo!,1) = 2 Then return
//End If

If idw_putaway.RowCount() > 0 Then 
	
	liMsg = messagebox(is_title,"Delete Existing Records?",Question!,yesNoCancel!,1)
	
	Choose CAse liMsg
			
		Case 1 /*Yes*/
			lsDeleteExisting = "Y"
		Case 2 /*No*/
			lsDeleteExisting = "N"
		Case else
			return
	End Choose
	
End If

// 06/15 - PCONKL - If any rows have been writtedn to content, they can't be deleted
If lsDeleteExisting = "Y" and idw_putaway.Find("Content_Record_Created_Ind = 'Y'",1,idw_putaway.RowCount()) > 0 Then
	
	If Messagebox(is_title,'One or more more Putaway rows have been released to Available Inventory and cannot be deleted!~r~rContinue?',Question!,YesNo!,2) = 2 Then
		Return
	else
		lsDeleteExisting = "N"
	End If
	
End If

If lsDeleteExisting = "Y" Then
	idw_putaway.reset() /*Actual deletion of records will occur on server*/
End If

//// pvh - 11/29/06 - MARL
//if Upper( gs_project ) = '3COM_NASH'  and idw_main.GetItemString(1, "ord_type") = 'X' then
//	doClearAdjustments()
//	doResetArrays()
//end if

//08-Jun-2016 :Madhu- added for Commodity Authorized User - START
	If g.ibcommodityauthorizeduser Then
		If wf_check_commodity_authorized_user () = -1 Then
			MessageBox(is_title,"You're not authorized for processing Restricted Commodity Item(s)# " + is_dangerous_item)
			tab_main.SelectTab(3)
			idw_detail.setrow( il_detail_row)
			idw_detail.setcolumn( "sku")
			idw_detail.setfocus( )
			SetMicroHelp("Save failed!")
			Return
		End If
	End If
//08-Jun-2016 :Madhu- added for Commodity Authorized User - END

string ls_ord_type   //25-Jun-2013 :Madhu added for set Expirationdate to back order

ib_changed = True
ls_order = idw_main.GetItemString(1, "ro_no")
ls_type = idw_main.GetItemString(1, "inventory_type")
ls_wh = idw_main.GetItemString(1, "wh_Code")

ls_ord_type =idw_main.GetItemString(1,"ord_type")  //25-Jun-2013 :Madhu added for set Expirationdate to back order


//idw_putaway.SetRedraw(False)
ll_cnt = idw_detail.RowCount()

iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("ROPutawayRequest", "ProjectID='" + gs_Project + "' DeleteExistingRecords='" + lsDeleteExisting + "'")
lsXML += 	'<RONO>' + idw_main.GetITemstring(1,'ro_no') +  '</RONO>' 
lsXML = iuoWebsphere.uf_request_footer(lsXML)


//Messagebox("",lsXML)

w_main.setMicroHelp("Generating Putaway List on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

//Messagebox("XML response",lsXMLResponse)

w_main.setMicroHelp("Putaway List generation complete")

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to generate Putaway List: ~r~r" + lsXMLResponse,StopSign!)
	//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_generate_putaway_server ' + "Websphere Fatal Exception Error. Unable to generate Putaway List: " + lsXMLResponse ) //08-Feb-2013  :Madhu commented
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End ue_generate_putaway_server ' + "Websphere Fatal Exception Error. Unable to generate Putaway List: " + lsXMLResponse,ls_order,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
	Return 
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")


Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to generate Putaway List: ~r~r" + lsReturnDesc,StopSign!)
		//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_generate_putaway_server ' + "Websphere Operational Exception Error. Unable to generate Putaway List: " + lsReturnDesc ) //08-Feb-2013  :Madhu commented
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End ue_generate_putaway_server ' + "Websphere Operational Exception Error. Unable to generate Putaway List: " + lsReturnDesc,ls_order,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

//import XML into DW
If pos(Upper(lsXMLResponse),"ROPUTAWAYRECORD") > 0 Then
	idw_Putaway.modify("datawindow.import.xml.usetemplate='roputawayresponse'")
	idw_Putaway.ImportString(xml!,lsXMLResponse)
	ib_changed = True
Else
	messageBox(is_title, 'No Putaway rows were generated')
End If

//idw_putaway.SetRedraw(True)
idw_putaway.GroupCalc()

// 07/00 PCONKL - Enable printing of Putaway list before saving (printing with blank locations, etc.)
If idw_putaway.RowCount() > 0 Then
	im_menu.m_file.m_print.Enabled = True
Else
	im_menu.m_file.m_print.Enabled = False
End If


tab_main.tabpage_putaway.cb_putaway_locs.Enabled = True
tab_main.tabpage_putaway.cb_putaway_locs.Text = "Assign Locs..."

//If any of Putaway records are components, enable show components checkbox
If idw_putaway.RowCount() > 0 Then

	If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) > 0 Then
		//MAS - 021511 - check cbx_show_comp and disable for all projects
		tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
		tab_main.Tabpage_putaway.cbx_show_comp.Checked = True
		
		wf_set_comp_filter('SET') /*default to not showing component children*/
	Else
		tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
		//MAS - 021511 - check cbx_show_comp and disable for all projects
		tab_main.Tabpage_putaway.cbx_show_comp.Checked = True
	End If
End If

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 11/24/2010 ujh: Baseline:  If any Putaway records are components set Inventory type to 8
If idw_putaway.RowCount() > 0 Then
	FOR li_idx = 1 to idw_putaway.RowCount()
		If  idw_putaway.GetItemString(li_idx, "component_ind") = '*'  Then
			idw_putaway.SetItem(li_idx, "Inventory_type", '8')
		End if	
			
		//25-Jun-2013 :Madhu added for set the Expiration date to back orders -START
		datetime ldt_expiration_date1

		string ls_supp_invoice_no1,ls_origrono,ls_origsku,ls_container_id,ls_lot,ls_pono,ls_pono2,ls_exp_control_ind,ls_suppcode
		ls_origsku =idw_putaway.GetItemString(li_idx,"sku")
		ls_suppcode =idw_putaway.GetItemString(li_idx,"supp_code")
		
		//Jxlim 08/15/2013 Commented out per Pete 08/15/2013 Expiration Date is originated from and it should come from websphere, SIMS client does not reset expiration date.
//		IF  ls_ord_type ='B' THEN  // If ordertype is Backorder
//				select Supp_Invoice_No into :ls_supp_invoice_no1 from Receive_Master where Ro_No =:ls_order using sqlca;
//				select Ro_No into :ls_origrono from Receive_Master where Supp_Invoice_No=:ls_supp_invoice_no1 and Ord_type='S' and Ord_status='C' and Project_Id =:gs_project using sqlca;
//				select expiration_date,container_id,lot_no,po_no,po_no2 into :ldt_expiration_date1,:ls_container_id,:ls_lot,:ls_pono,:ls_pono2 
//						from Receive_Putaway where Ro_No=:ls_origrono and sku=:ls_origsku using sqlca;
//				idw_putaway.SetItem(li_idx,"expiration_date",date(ldt_expiration_date1))
//				idw_putaway.SetItem(li_idx,"container_id",ls_container_id)
//				idw_putaway.SetItem(li_idx,"lot_no",ls_lot)
//				idw_putaway.SetItem(li_idx,"po_no",ls_pono)
//				idw_putaway.SetItem(li_idx,"po_no2",ls_pono2)
//			ELSE
//			//25-Jun-2013 :Madhu added for set the Expiration date to back orders -END
//			If  IsNull(idw_putaway.GetItemDateTime(li_idx, "Expiration_Date")) THEN //Madhu added
//				idw_putaway.SetItem(li_idx,"expiration_date",date(2999,12,31))		//03-apr-2013: Madhu added to set the default expiration date
//			END If
//		END IF	//25-Jun-2013 :Madhu added for set the Expiration date to back orders

	NEXT
end if
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// pvh -=- 03.13.06 MARL
If gs_Project = "3COM_NASH"  and idw_main.GetItemString(1, "ord_type") = 'X' then
	setRLSkuList(  )
	setQualityHoldRows()
	if getMARLListCount() > 0 then
		if doMARLCheck() = one then 	setInventoryType()
	end if
end if
// eom

//09/06 - PCONKL - For Powerwave, For a PO (NOt an IR) If we have any Outbound Serial flags, flip them to scan at Inbound (We want to capture for GR but we won't write to Content)
//						For an IR, we always want to track Lot (LPN)
If gs_project = 'POWERWAVE'  Then
	idw_putaway.TriggerEvent('ue_set_powerwave_flags')
End If /*Powerwave PO */

//11/07 - PCONKL - Set flags for GM_Montry and SLI-POOL
If gs_project = 'GM_MONTRY' or gs_project = 'SLI-POOL' Then
	idw_putaway.TriggerEvent('ue_set_gm_montry_flags')
End If /*Powerwave PO */

If gs_Project = "RUN-WORLD" or gs_Project = "GIGA" or gs_Project = "PUMA" Then /* 09/09 - PConkl - Added Puma*/
	
	FOR li_idx = 1 to idw_putaway.RowCount()
	
		ls_sku = idw_putaway.GetItemString(li_idx,"SKU")
		lsSupplier =  idw_putaway.GetItemString(li_idx,"supp_code")
		
		SELECT Std_Cost INTO :ld_Std_Cost
			FROM ITEM_MASTER
			WHERE SKU = :ls_sku AND SUPP_CODE = :lsSupplier AND project_ID = :gs_project USING SQLCA;

		idw_putaway.SetItem(li_idx,"PO_NO2", string(ld_Std_Cost))
	
	NEXT
END IF


//JXLIM 07/01/2010 -	For manual order (edi_batch_seq_no null or 0) set po_no on all putaway rows to $$HEX1$$1820$$ENDHEX$$FGW$$HEX1$$1920$$ENDHEX$$.
Long ll_edi
ll_edi = idw_Main.GetItemNumber(1,'edi_batch_seq_no')
// dts - 2010/07/05 - added parentheses around 'or' condition
IF gs_project = 'MAQUET' and (ll_edi < 0 or IsNull(ll_edi)) Then
	FOR li_idx = 1 to idw_putaway.RowCount()
		idw_putaway.SetItem(li_idx, "po_no", 'FGW') 		
	NEXT		
END IF 

IF gs_project = 'AMS-MUSER' AND  idw_main.GetItemString(1, "wh_Code") = 'EED' THEN
	FOR li_idx = 1 to idw_putaway.RowCount()
		
		idw_putaway.SetItem(li_idx, "lot_no", idw_main.GetItemString(1, "ship_ref"))
		idw_putaway.SetItem(li_idx, "po_no2", 'Y') 
		
	NEXT
		
END IF 

// 02/10 - PCONKL - Defaulting Inventory Types for Warner- Customer reject to 'X', Customer returns being defaulted to 'E' on server if they are electronic
IF gs_project = 'WARNER'  THEN
	
	FOR li_idx = 1 to idw_putaway.RowCount()
		
		If idw_main.GetITemString(1,'Ord_type') = 'X' Then /*Return from Customer*/
			idw_putaway.SetItem(li_idx, "Inventory_type", 'E')
		ElseIf idw_main.GetITemString(1,'Ord_type') = 'R' Then /*Customer Reject*/
			idw_putaway.SetItem(li_idx, "Inventory_type", 'X')
		End If
	NEXT
		
END IF /*warner*/


// 12/02 - PCONKL - For Pulse, we are setting Lot # (IMI #) as YYMMNNNNNN where NN = LAst 3 of RO_NO + Last 3 of Line Item No
// 03/03- PCONKL - using seq generator for last 6 of IMI instead of ro_no, and adding 'M' as firt char
// 07/03 - PCONKL - we only want to generate IMI if receiving Raw materials into HKG WH
// 03/10 - MEA - Copied back in for PULSE
If Upper(gs_Project) = 'PULSE' and &
	idw_main.GetITemString(1,'wh_code') = 'PULSE-LIA'  Then

	/* If Warehouse transfer then */
	
	//During inbound order import, allow to overwrite the $$HEX1$$1c20$$ENDHEX$$Container ID$$HEX2$$1d202000$$ENDHEX$$and $$HEX1$$1c20$$ENDHEX$$IMI #$$HEX2$$1d202000$$ENDHEX$$(Lot_no) 
	//algorithm when order types are $$HEX1$$1c20$$ENDHEX$$I$$HEX2$$1d202000$$ENDHEX$$(Item Transfer to Liaobu) and $$HEX1$$1c20$$ENDHEX$$T$$HEX2$$1d202000$$ENDHEX$$(Trail Shipment to Liaobu) 

	IF NOT (idw_main.GetITemString(1,'ord_type') = 'I' OR &
				idw_main.GetITemString(1,'ord_type') = 'T') Then

		FOR li_idx = 1 to idw_putaway.RowCount()
	
			lsIMIID = wf_generate_pulse_IMI()
			
	
			If lsIMIID <> "-1" Then
				idw_putaway.setitem(li_idx,'lot_No', lsIMIID)
			End If
			
		NEXT
	
	ELSE
	
	string ls_supp_invoice_no, ls_putaway_sku
	integer li_line_item_no
	string ls_length
	string ls_height
	string ls_width
	string ls_weight_gross
	
		FOR li_idx = 1 to idw_putaway.RowCount()
	
			 ls_supp_invoice_no = idw_main.GetItemString(1,'supp_invoice_no') 
			 ls_putaway_sku = idw_putaway.GetItemString(li_idx,'sku')
			 li_line_item_no = idw_putaway.GetItemNumber(li_idx,'line_item_no')
			 
			 decimal ld_quantity
			
			 SELECT user_field4, user_field5, user_field6, user_field2, quantity
				INTO :ls_length, :ls_width, :ls_height, :ls_weight_gross, :ld_quantity
				FROM EDI_Inbound_Detail
				WHERE Order_Line_No = :li_line_item_no and project_id = 'PULSE' AND
							sku = :ls_putaway_sku  and order_no = :ls_supp_invoice_no USING SQLCA;
			
			idw_putaway.setitem(li_idx,'length', dec(ls_length))
			idw_putaway.setitem(li_idx,'width', dec(ls_width))
			idw_putaway.setitem(li_idx,'height', dec(ls_height))
			idw_putaway.setitem(li_idx,'weight_gross', dec(ls_weight_gross))			
			idw_putaway.setitem(li_idx,'quantity', ld_quantity)		
			
		NEXT
	END IF	
End If /* Pulse */		


IF Upper(gs_project) = "PANDORA" THEN
//??	ls_Sub_Inventory_Type = idw_main.GetItemString( 1, "user_field2")
   //12/09/09 UJHALL Removed: part of no more entries in UF6 and UF8 at header level for Pandora
	//ls_ToProject = idw_main.GetItemString( 1, "user_field6")
/* now getting owner from the detail line
   - preventing putaway generation (above) if any owner is Pandora (must be sub-location)	*/
	
	//Jxlim 05/21/2012  Set CreateUser to 'IMPORT' for imported order. (Initial imported order)
	//Move out from For statement Jxlim 04/25/2012 
	ls_createuser = idw_main.GetItemString(1, "create_user")
	If IsNull(ls_createuser) Then
		ls_createuser ='IMPORT'
		idw_main.SetItem(1, "Create_User", ls_createuser)
	End If
	ls_user = idw_main.GetItemString(1, "last_user")				
	ls_upperuser = Upper(ls_user)           
	FOR li_idx = 1 to idw_putaway.RowCount()
			       //JXLIM 09/29/2011 BRD #201 populate serial no on import inbound order
				//If this is an import inbound order then bring in the serial_no that was imported (Don't clear out)        
				//If(edi_batch_seq_no <> 0 and  create_user <> 'SIMSFP','This order was received through import
				//when the order is MSE and last user is not SIMSFP and it isUpper case then this order is imported thus load serial number    
				//Jxlim 01/25/2012 check create_user instead of last_user per Dave; not populate serial_no when the create user is 'SIMSFP'
				//Move to above For before loop Jxlim 04/25/2012 
//				ls_createuser = idw_main.GetItemString(1, "create_user")					
//				ls_user = idw_main.GetItemString(1, "last_user")				
//				ls_upperuser = Upper(ls_user)    
				//Don't have to check last_user
				//If ll_edi <> 0 And ls_createuser <>  'SIMSFP'  And ls_user =ls_upperuser Then 
				//If ll_edi <> 0 And ls_createuser <>  'SIMSFP'  Then  //<> 'SIMSFP' will set serial no for anything other than 'SIMSFP'
				If ll_edi <> 0 And ls_createuser = 'IMPORT'  Then    
					ls_serial =  idw_putaway.GetItemString(li_idx, "serial_no")
					ls_serial = Upper(ls_serial)
					idw_putaway.SetItem(li_idx,"serial_no",ls_serial)
				Else
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					//06/28/2010 ujhall: 01 of 07:  Validate Inbound Serial #.  Blank Serial number to force a scan
					//See dw_putaway.Itemchanged for part 2 of this.
					
					//15-Jan-2018 :Madhu S14839 - Foot Print - START
					ls_sku = idw_putaway.GetItemString(li_idx, "sku")
					lsSupplier= idw_putaway.GetItemString(li_idx, "supp_code")
					llcount = i_nwarehouse.of_item_master( gs_project, ls_sku, lsSupplier)
					
					lsFind ="Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"' and supp_code = upper('"+lsSupplier+"')"
					llFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())
					
					ls_serial_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Serialized_Ind')
					ls_pono2_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'PO_No2_Controlled_Ind')
					ls_container_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Container_Tracking_Ind')
					
					If ls_serial_Ind ='B' and ls_pono2_Ind ='N' and ls_container_Ind ='N' Then
						idw_putaway.SetItem(li_idx,"serial_no","-")					
					else
						ls_serial =  idw_putaway.GetItemString(li_idx, "serial_no")
						ls_serial = Upper(ls_serial)
						idw_putaway.SetItem(li_idx,"serial_no",ls_serial)
					End If
					//15-Jan-2018 :Madhu S14839 - Foot Print - END
					
				End if
			///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//TAM 2010/04/07 Adding Substitute SKU Logic -Defaulting to SKU
/*SUBSTITUTE*/		idw_putaway.SetItem(li_idx, "sku_substitute", idw_putaway.GetItemString(li_idx, "sku"))
/*SUBSTITUTE*/		idw_putaway.SetItem(li_idx, "supplier_substitute", idw_putaway.GetItemString(li_idx, "supp_code")) 
		
		ll_rows = idw_detail.Find("Line_Item_No = " + string(idw_putaway.GetItemNumber(li_idx, "line_item_no")), 1, idw_detail.RowCount())
		ll_owner_id = idw_detail.GetItemNumber(ll_rows, "owner_id")
		//Set Owner_id to Sub-Inventory-Loc's owner_id
//TEMP!		if ll_owner_id > 0 then idw_putaway.SetItem(li_idx, "owner_id", ll_owner_id)
		//Set PO_NO to Project (UF6)
		if ls_ToProject = '' or isnull(ls_ToProject) then
			ls_GeneratedProject = trim(idw_putaway.GetItemString(li_idx, "po_no"))
			//default it to 'NA' if it isn't set from the putaway generation (from edi_inbound)
			if ls_GeneratedProject = '' or ls_GeneratedProject = '-' or isnull(ls_GeneratedProject) then
				//idw_putaway.SetItem(li_idx, "po_no", 'NA')
				// 09/09/09 - isn't this supposed to be 'MAIN' now?
				idw_putaway.SetItem(li_idx, "po_no", 'MAIN')
			end if
		else
			// 10/09 - PCONKL - ONLY set if not set elsewhre (like the server). We should really never be setting it here.
			// 12/09 - PCONKL - Dont ever set from UF6. No longer using this field.
//			If isnull(idw_putaway.GetItemString(li_idx, "po_no")) or idw_putaway.GetItemString(li_idx, "po_no") = '' or idw_putaway.GetItemString(li_idx, "po_no") = '-' Then
//				idw_putaway.SetItem(li_idx, "po_no", ls_ToProject)
//			End If
		end if
		// GailM - 08/14/2014 - Pandora Issue 883 - Deja Vu orders now require scanning containerIDs 	
		//dts - 10/16/14 - we should only be 'blanking' these out if it is a DejaVu order (plus we should be setting to '-' instead of '')
		//dts 10/16/14 - building in a work-around for SuperDuper users to get around orders that are incorrectly deemed DejaVu (while we wait for action on Pandora IT's part regarding rules)
		If ibDejaVu and ibDejaVu_Override and gs_role = '-1' and not ibDejaVu_Asked Then
			If Messagebox('DejaVu Prompt for SuperDuper Users, in ue_generate_putaway...', 'This order is Marked DejaVu. Leave as DejaVu?',Question!,YesNo!,1) = 2 Then
				ibDejaVu = false
			else
				ibDejaVu_Asked = true
			End If
		end if		
		If ibDejaVu Then
				lsContainerID = idw_putaway.GetItemString(li_idx, 'container_id')
				//dts - should be setting to '-' instead of ''
//				if lsContainerID <> '' and lsContainerID <> '-' Then
//					idw_putaway.SetItem(li_idx,'container_id','')
				if lsContainerID <> '-'  and lsContainerID <> '' Then //OCT 2019 - MikeA - DE12998 - Check for blank container id. 
//					idw_putaway.SetItem(li_idx,'container_id','-')
					idw_putaway.SetItem(li_idx,'container_id','') //OCT 2019 - MikeA - DE12998 - Use '' instead of '-'.
				end if
		end if
		NEXT
		
		//if ll_owner_id > 0 then
		FOR li_idx = 1 to idw_detail.RowCount()
			//Set Owner to Sub-Inventory-Loc
//TEMP!			idw_detail.SetItem(li_idx, "owner_id", ll_owner_id)
			//set cost...
			//TimA 07/19/2011 Per Ian if the order already has a price don't reset it and get a price form the price master.
			//Result of Issue #255
			If  idw_detail.Getitemnumber (li_idx, 'cost')  = 0 or  isnull(idw_detail.Getitemnumber (li_idx, 'cost')) then				
				ls_SKU =  idw_detail.GetItemString(li_idx, "sku" ) 
				//always 'PANDORA' lsSupplier =  idw_detail.GetItemString(li_idx, "supp_code" ) 
				ll_Owner_ID = idw_detail.GetItemNumber(li_idx, "owner_id")
				ls_OwnerCD = ''
				select owner_cd into :ls_OwnerCD
				from owner
				where project_id = 'PANDORA'
				and owner_id = :ll_Owner_ID;
				
				ls_location_org = ''
				Select user_field3
				Into	 :ls_location_org
				From Customer
				Where Project_id = :gs_project and Cust_Code = :ls_OwnerCD;
				
				ld_price_1 = 0; ld_price_2 = 0; ls_cur_cd = ''
				Select price_1, price_2, Currency_CD
				Into	 :ld_price_1, :ld_price_2, :ls_cur_cd
				From Price_Master
				Where Project_id = :gs_project and sku = :ls_SKU  AND price_class = :ls_location_org; //and supp_code = :lsSupplier 
		
				if idw_main.GetItemString(1, 'inventory_type') = "N" then
						idw_detail.SetItem(li_idx, 'cost', ld_price_1)
				else
					idw_detail.SetItem(li_idx, 'cost', ld_price_2)
				end if
				idw_detail.SetItem(li_idx, 'user_field1', ls_cur_cd)
			End if
		NEXT
	//end if
END IF

//TAM W&S 2010/12 Default Non bonded lot no to "DP"

If Left(gs_Project,3) = "WS-" Then 

	If is_bonded = 'N' Then
		FOR li_idx = 1 to idw_putaway.RowCount()
			If Upper(gs_project) <> "WS-BM" and Upper(gs_project) <> "WS-PR" THEN idw_putaway.SetItem(li_idx,"LOT_NO", 'DP') //13-Jan-2015 :Madhu- As requested for whs transfer order from WS-Bonded to WS-DP only for WS-BM
			//	idw_putaway.SetItem(li_idx,"LOT_NO", 'DP') //17-Oct-2014 :Madhu- As requested for whs transfer order from WS-Bonded to WS-DP 

			IF  Upper(gs_project) ='WS-PR' and ls_wh_code='WS-DP' and (IsNull(idw_putaway.getItemString(li_idx,'lot_no')) or (idw_putaway.getItemString(li_idx,'lot_no')='-')) THEN idw_putaway.setItem(li_idx,"lot_no",'DP') //03-FEB-2016 Madhu- Assign Lot No for WS-DP warehouse
		
			idw_putaway.SetItem(li_idx,"PO_NO", '0') //TAM W&S 5/18/2011 Default PONO to 0 for non bonded
		NEXT
// TAM W&S 2011/02/10 Moving CIF Total to Detail Screen.  We are not entering the PO_NO field.  This is used for CIF per Bottle and is calculated from the CIF total on the Details Screen Cost/quantiy
	ELSE
		Decimal ll_CIFtotal  //TAM W&S 05/18/2011 Made CIF Total a decimal
		Long ll_QTY
		FOR li_idx = 1 to idw_putaway.RowCount()
			ll_rows = idw_detail.Find("Line_Item_No = " + string(idw_putaway.GetItemNumber(li_idx, "line_item_no")), 1, idw_detail.RowCount())
			ll_CIFTotal = idw_detail.GetItemNumber(ll_rows, "cost")
			ll_QTY = idw_detail.GetItemNumber(ll_rows, "Req_Qty")
			if ll_qty > 0 Then
				idw_putaway.SetItem(li_idx, 'PO_NO',string(ll_CIFTotal/ll_qty,'#####0.0000'))	
			End If

		NEXT

	End If

// TAM W&S 2011/03/19  Poulate userfields with Item Master info.
	
	FOR li_idx = 1 to idw_putaway.RowCount()
	
		ls_sku = idw_putaway.GetItemString(li_idx,"SKU")
		lsSupplier =  idw_putaway.GetItemString(li_idx,"supp_code")
		string ls_user_field1, ls_user_field11
		
		SELECT User_field1, User_field11, hs_code INTO :ls_user_field1, :ls_user_field11, :ls_hs_code
			FROM ITEM_MASTER
			WHERE SKU = :ls_sku AND SUPP_CODE = :lsSupplier AND project_ID = :gs_project USING SQLCA;

		idw_putaway.SetItem(li_idx,"user_field2", ls_user_field1)
		idw_putaway.SetItem(li_idx,"user_field4", ls_user_field11)
		idw_putaway.SetItem(li_idx,"user_field6", ls_hs_code)
	
	NEXT


End If

// 11/02 - PCONKL - Hide any unused lottable fields
idw_Putaway.TriggerEvent('ue_hide_unused')

idw_main.SetItem(1, "ord_status", "P")	

// 11/30 - GMOR - If Comcast, enable Putaway Pallets button
// 03/11 - PCONKL - If Virtual WH (com-direct), set location to DOCK
if Upper( gs_Project ) = 'COMCAST' Then
                
	tab_main.tabpage_putaway.cb_putaway_pallets.Enabled = True
                
    		IF idw_main.GetItemString(1, "wh_Code") = 'COM-DIRECT' THEN
                                
             FOR li_idx = 1 to idw_putaway.RowCount()
                    idw_putaway.SetItem(li_idx, "l_code", 'DOCK')
            NEXT
                                
       END IF 
                
End If

//Jxlim 08/08/2012 Physio CR06 copy user_field1 from detail to putaway.user_field1 (CR06 Physio receivemaster and receivedetail have the same value on user_field1)
If Left(Upper(gs_Project), 6) = 'PHYSIO' Then 	  
	lsDetailUserField1 = idw_main.GetItemString(1, "user_field1")						 
	IF Not IsNull(lsDetailUserField1) AND trim(lsDetailUserField1) > '' then 
		 FOR li_idx = 1 to idw_putaway.RowCount()
				idw_putaway.SetItem(li_idx, "user_field1", lsDetailUserField1)
		 NEXT
	End IF  
End IF

// MEA - 06/12 - for Inbound, if user field 5 is not empty, then when we generate the putaway, this value should be on the Location field

if Upper( gs_Project ) = 'STRYKER' Then
     
	string  ls_user_field5
	  
	ls_user_field5 = idw_main.GetItemString(1, "user_field5")		 
					 
	IF Not IsNull(ls_user_field5) AND trim(ls_user_field5) > '' then 
		 FOR li_idx = 1 to idw_putaway.RowCount()
				idw_putaway.SetItem(li_idx, "l_code", ls_user_field5)
		 NEXT
	End IF        

	
	//When they generate the putaway, pop up an alert message to indicate which SKU and line item # has less than 5years expiry.
	//1.	If the expiry date of the inventory is less than 5 years from the receipt date, SIMS to pop up error message to alert Menlo ops.
	
	
	string lsWarehouse
	
	lsWarehouse = idw_main.GetItemString( 1, "wh_code")
	
	ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	
	 FOR li_idx = 1 to idw_putaway.RowCount()
			ldt_expiration_date = idw_putaway.GetItemDateTime(li_idx, "expiration_date")
			
			
			
			IF DaysAfter ( date(ldtToday), date(ldt_expiration_date) ) < 180 Then
				
				lsSKU = idw_putaway.GetItemString(li_idx,"sku")
				 li_line_item_no = idw_putaway.GetItemNumber(li_idx,'line_item_no')
				
				 Messagebox(is_title, "Sku: " + lsSku + " and Line Item #: " + string(li_line_item_no) + " has less than 180 days expiry.")
				 
			End If
			
	 NEXT	
	
End If

//MEA - 06/12
//a)	In receiving function,  where  stocks received, SIMS will put in the logic that for  
// inventory type = 0009 Returns Stock, assigned the  expiry date to be  01/01/1999. 
//Else (other inventory type )  expiry date to be set  12/31/2999.
//
//There is code as well in the itemchanged event on the putaway datawindow.

IF Upper( gs_Project ) = 'PHILIPS-TH' Then
	FOR li_idx = 1 to idw_putaway.RowCount()
		if idw_putaway.GetItemString(li_idx, "inventory_type") = "9" then
			 idw_putaway.SetItem(li_idx, "expiration_date", date("01/01/1999"))
		else
			 idw_putaway.SetItem(li_idx, "expiration_date",date("12/31/2999"))
		end if
	 NEXT
End If
				
//10-Nov-2014 :Madhu- PHILIPS-SG - Set Exp Date -1/1/1999 for Return Customer Order -START
//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
IF (Upper(gs_project) ='PHILIPS-SG' or Upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA') and idw_main.getitemstring(1,"ord_type") ='X' THEN
	For li_idx =1 to idw_putaway.rowcount( )
		idw_putaway.setitem( li_idx, "expiration_date",date("01/01/1999"))
	NEXT
END IF
//10-Nov-2014 :Madhu- PHILIPS-SG - Set Exp Date -1/1/1999 for Return Customer Order -END

//26-APR-2018 :Madhu S18747 Rema - Set Exp Date to 12/31/2099 - START
IF Upper(gs_project) ='REMA' THEN
	For li_idx =1 to idw_putaway.rowcount( )
		idw_putaway.setitem( li_idx, "expiration_date",date("12/31/2099"))
	NEXT
END IF
//26-APR-2018 :Madhu S18747 Rema - Set Exp Date to 12/31/2099 - END

//30-Jan-2019 :Madhu S28685 PHILIPSCLS BlueHeart Minimum Shelf Life Inbound Validation
//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
IF upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA' THEN  wf_min_shelf_life_inbound_validation(TRUE)

//02/06 - PCONKL - we may have a project/warehouse level sort on the Putaway (Screen and report will be sorted the same if present)
//This.TriggerEvent('ue_sort_Putaway')

//BCR 09-FEB-2012: Any project that has this kind of project/warehouse level sort on Putaway (like Bluecoat does) may run into run-time problems if there are Components attached to Parents. 
//                           In Bluecoat's case, Child Component shows up on row 1, followed by Parent on row 2. When you select Location for Parent, it doesn't copy down into Child.  
//                           So, per Pete Conklin, trigger this event ONLY if there are no Child Components.
If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) = 0 Then
	This.TriggerEvent('ue_sort_Putaway')
END IF

// cawikholm 07/05/11 End Tracing 
//f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_generate_putaway_server' ) //08-Feb-2013  :Madhu commented
f_method_trace_special( gs_project,this.ClassName() + ' -ue_generate_putaway_server','End ue_generate_putaway_server: ',ls_order,' ',' ',is_suppinvoiceno ) //08-Feb-2013  :Madhu added

end event

event ue_assign_locations_server();// 11/12 - PCONKL - Process Location assignment on Server - In case Putaway List was not originally generated on Server (scanning to build, etc.)


String	lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc, lsRONO

If ib_changed Then 
	Messagebox(is_title,'Please save your changes first.')
	Return
End IF



iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("ROAssignLocationRequest", "ProjectID='" + gs_Project +"'")
lsXML += 	'<RONO>' + idw_main.GetITemstring(1,'ro_no') +  '</RONO>' 
lsXML = iuoWebsphere.uf_request_footer(lsXML)




w_main.setMicroHelp("assigning Putaway Locations on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

//Messagebox("XML response",lsXMLResponse)

w_main.setMicroHelp("Putaway List generation complete")

//Check for Valid Return...
//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to generate Putaway List: ~r~r" + lsXMLResponse,StopSign!)
	Return 
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		Messagebox("Websphere Operational Exception Error","Unable to generate Assign Putaway Locations: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

//import XML into DW
If pos(Upper(lsXMLResponse),"ROPUTAWAYRECORD") > 0 Then
	
	//If we received a Putaway List back (Should be the same on sent, delete the existing*/
	idw_putaway.Reset()
	
	lsRONO = idw_Main.GetITemString(1,'ro_no')
	Execute Immediate "Begin Transaction" using SQLCA;
	Delete from Receive_Putaway where ro_no = :lsRONO;
	Execute Immediate "Commit" using SQLCA;
	
	idw_Putaway.modify("datawindow.import.xml.usetemplate='roputawayresponse'")
	idw_Putaway.ImportString(xml!,lsXMLResponse)
	ib_changed = True
	
Else
	messageBox(is_title, 'No Locations were generated')
End If

//idw_putaway.SetRedraw(True)
idw_putaway.GroupCalc()


end event

public function integer wf_set_comp_filter (string as_action);

//Putaway list may be filtering component info. Most logic needs to process these rows anyway.
// so we may have to unfilter the pick list before processing and refilter afterwords.


//MAS 021911 - disable componet processing for all projects
//commented all code
Choose Case Upper(as_action)
		
	Case 'REMOVE' /*remove existing filter*/
		//MAS 021911 - disable componet processing for all projects
		//idw_putaway.SetFilter('')
		//tab_main.tabpage_putaway.cbx_show_comp.Checked = True
		
	Case 'SET' /* Re-set*/
		
		//If tab_main.tabpage_putaway.cbx_show_comp.Checked Then
			//idw_putaway.SetFilter('')
		//Else
			//idw_putaway.SetFilter("sku = sku_parent	")
		//End If

End Choose

//idw_putaway.Filter()

Return 0
end function

public function string wf_generate_pulse_imi ();//Generate the Next available IMI ID for PULSE

Long	llWeekNo,	&
		llIMIID
		
String	lsIMIID

llWeekNo = g.of_get_Week(Today()) /*get the week number from the Julian Date*/
llIMIID = g.of_next_db_seq(gs_project,'Receive_Putaway','IMI_ID_NO')
If llIMIID <= 0 Then
	messagebox(is_title,"Unable to retrieve the next available IMI ID Number!")
	Return "-1"
End If

lsIMIID = 'M' + Right(String(today(),'yyyy'),2) + String(llWeekNo,'00') + String(llIMIID,'000000')

Return lsIMIID
end function

public function integer wf_create_comp_child (long alrow);// 10/31/02 - PConkl - QTY changed to Decimal

u_ds	lu_ds
Long	llRowCount,	&
		llRowPos,	&
		llCompRow,	&
		llFindRow,	&
		llSetRow

Decimal	ldQty

String	lsSku,				&
			lsSupplier,			&
			lsSerial,			&
			lsLot,				&
			lsPO,					&
			lsPO2,				&
			lsChildSku,			&
			lsChildSupplier,	&
			lsCompInd,			&
			lsFind,				&
			lsLoc
			
SetPointer(HourGlass!)

lu_ds = Create u_ds
lu_ds.dataobject = 'd_item_component_parent'
lu_ds.SetTransObject(SQLCA)
		
lsSku = idw_putaway.GetItemString(alRow,"sku")
lsSupplier = idw_putaway.GetItemString(alRow,"supp_code")
lsLoc = idw_putaway.GetItemString(alRow,"l_code")
ldQty = idw_putaway.GetItemNumber(alRow,"quantity")
lu_ds.Retrieve(gs_project,lssku,lsSupplier, "C") /*retrieve children for Master - 08/02 - PCONKL - Include component type = 'C' (DW/DB table also being used for packaging)*/

llRowCount = lu_ds.RowCount()
if ilComponenttRow > 0 then
	llCompRow = 	ilComponenttRow
else
	llCompRow = alRow
end if

For llRowPos = 1 to llRowCount
	
	//09/02 - Pconkl - We may need to update combine child putaway rows if we are multiple componenet levels deep and mid level components have the same children
	lsFind = "Upper(sku) = '" + Upper(lu_ds.GetItemString(llRowPos,"sku_child")) + "' and Upper(Supp_code) = '" +  Upper(lu_ds.GetItemString(llRowPos,"supp_code_child"))
	lsFind += "' and Upper(l_code) = '" + Upper(lsLoc) + "' and line_item_no = " + String(idw_putaway.GetItemNumber(alRow,"Line_Item_no"))
	lsFind += " and component_no = " + String(idw_putaway.GetItemNumber(alRow,"component_no")) /* 02/10 - PCONKL */
	llFindRow = idw_putaway.Find(lsFind,1,idw_putaway.RowCount())
	
	If llFindRow > 0 Then 
		// add qty to existing Qty, Extend Unit Qty if Parent already sent
		If ldQty > 0 Then
			idw_putaway.SetItem(llFindRow,"quantity",(idw_putaway.GetItemNumber(llFindRow,'quantity') + (ldQty * lu_ds.GetItemNumber(llRowPos,"child_qty"))))
		Else
			idw_putaway.SetItem(llFindRow,"quantity",(idw_putaway.GetItemNumber(llFindRow,'quantity') + lu_ds.GetItemNumber(llRowPos,"child_qty")))
		End If
		
	Else /* Not found, insert a new Putaway Row */
		
		llCompRow ++
		idw_putaway.InsertRow(llCompRow)
		idw_putaway.SetItem(llComprow,"component_no",idw_putaway.GetITemNumber(alRow,"Component_no"))
		idw_putaway.SetItem(llComprow,"line_item_no",idw_putaway.GetITemNumber(alRow,"line_item_no"))
		idw_putaway.SetItem(llComprow,"sku_parent", idw_putaway.GetItemString(alRow,"sku_parent"))	
		idw_putaway.setitem(llComprow,'ro_no', idw_putaway.GetItemString(alRow,"ro_no"))
		idw_putaway.SetItem(llComprow,"inventory_type",idw_putaway.GetItemString(alRow,"inventory_type"))	
		//idw_putaway.SetItem(llComprow,"component_ind", '*')	
		idw_putaway.SetItem(llComprow,"owner_id", idw_putaway.GetItemNumber(alRow,"owner_id"))	
		idw_putaway.SetItem(llComprow,"c_owner_name", idw_putaway.GetItemString(alRow,"c_owner_name"))	
		idw_putaway.SetItem(llComprow,"l_code", idw_putaway.GetItemString(alRow,"l_code"))
		idw_putaway.SetItem(llComprow,"country_of_origin", idw_putaway.GetItemString(alRow,"country_of_origin"))
			
		//Set Child Sku Values
		idw_putaway.SetItem(llCompRow,"sku",lu_ds.GetItemString(llRowPos,"sku_child"))
		idw_putaway.SetItem(llCompRow,"supp_code",lu_ds.GetItemString(llRowPos,"supp_code_child"))
		//If parent Quantiy is set, extend child qty
		If ldQty > 0 Then
			idw_putaway.SetItem(llCompRow,"quantity",(ldQty * lu_ds.GetItemNumber(llRowPos,"child_qty")))
		Else
			idw_putaway.SetItem(llCompRow,"quantity",lu_ds.GetItemNumber(llRowPos,"child_qty"))
		End If
	
		//Get serialized ind -
		lsChildSku = lu_ds.GetItemString(llRowPos,"sku_child")
		lsChildSupplier = lu_ds.GetItemString(llRowPos,"supp_code_child")
		Select serialized_ind, component_ind, lot_controlled_Ind, po_controlled_ind, po_no2_controlled_Ind 
		Into :lsSerial, :lsCompInd, :lsLot, :lsPO, :lsPO2
		From Item_master
		Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
		Using SQLCA;
	
		idw_putaway.SetItem(llCompRow,"serialized_ind",lsSerial)
		idw_putaway.SetItem(llCompRow,"lot_controlled_ind",lsLot)
		idw_putaway.SetItem(llCompRow,"po_controlled_ind",lsPO)
		idw_putaway.SetItem(llCompRow,"po_no2_controlled_ind",lsPO2)
		
//		If lsCompInd = 'Y' Then 
//			idw_putaway.SetItem(llComprow,"component_ind", 'B') /*Both*/
//			wf_create_comp_child(llComprow) /*create children rows for this Parent/Child (it's both) */
//		Else
			idw_putaway.SetItem(llComprow,"component_ind", '*')	/*it's only a child*/
//		End If
	
		// 09/02 - PConkl - This child may also be a parent - call recursively as long as a child is a parent to another child

	End If /*new or updated putaway row */
	
next
// 02/21/2001 ujh: I-135: Save the row of the last child to be able to insert another parent
ilRowLastChild = llCompRow
		
SetPointer(Arrow!)

Return 0
end function

public function integer wf_validation ();string ls_whcode, ls_code,ls_sku,ls_psku, ls_osku, ls_posku,lsInactivesku, ls_prev_sku, ls_po_no2
string ls_loc, ls_ploc, ls_type, ls_ptype, ls_serial, ls_pserial, ls_lot, ls_plot,lsSupplier, lspsupplier, &
		ls_PO, ls_pPO, ls_PO2, ls_pPO2, lsPOP, lsFromLoc, lsTemp, lsToLoc, ls_Coo, ls_InventoryType, ls_ContainerID		
string lsPOLine, lsfind, ls_msg, ls_allow_receipt, ls_sscc_nbr   //S14736
integer li_Count
boolean lb_CheckContainer, lb_CheckPallet
string lsCheckedContainer[], lsCheckedPallet[]
long ll_CheckedContainer, ll_CheckedPallet
string ls_ro_no

DateTime ldt_Expiration_Date		

long i,j, k, ll_cnt, llOwner,llPOwner, llLineItem,llPLineItem, llRequiredSerial
long	llskucount, llskufindrow, ll_find_row, ll_find_putaway_row, ll_find_loc_row
string lsScannerID //see if Order is assigned to a scanner

if doAcceptText() < 0 then return -1
  
SetPointer(Hourglass!)
w_main.SetMicroHelp('Validating Data...')

// Check if all required fields are filled

// 1/19/05 - dts - Make sure Order Nbr and Supplier are populated...
if isnull(idw_main.GetItemString(1, "Supp_invoice_no")) or trim(idw_main.GetItemString(1, "Supp_invoice_no")) = '' then

//TAM - W&S 2010/12  -   W&S Order Number is Formatted.  Skip validation. We will create it during this save.  
//Left 3 characters = WS- for Wine and Spirt.
	If Left(gs_project,3) <> 'WS-'  Then
		messagebox(is_Title, "Must enter Order Number.")
		f_SetFocus(idw_main, 1, "supp_invoice_no")
		return -1
	end if
end if

if isnull(idw_main.GetItemString(1, "supp_code")) or trim(idw_main.GetItemString(1, "supp_code")) ='' then
	messagebox(is_Title, "Must enter Order Number.")
	f_SetFocus(idw_main, 1, "supp_invoice_no")
	return -1
end if

if isnull(idw_main.GetItemString(1, "supp_code")) or trim(idw_main.GetItemString(1, "supp_code")) ='' then
	messagebox(is_Title, "Must enter valid Supplier.")
	f_SetFocus(idw_main, 1, "supp_code")
	return -1
end if

// 07/04 - PCONKL - Only check required on Confirmation - all fields can now be defined as required at the project level
If ibConfirmRequested Then
	//TimA 09/18/15 Seeing errors in the DB Error Log table for invalid Arrival dates.
	//Putting this in the check and validate the arrival date.
	//	If IsNull(idw_main.GetItemDateTime(1, "Arrival_Date" ) ) Then
	//			MessageBox(is_title, "Please enter a valid Arrival Date!", StopSign!)	
	//			tab_main.SelectTab(1 ) 
	//			f_setfocus(idw_main, i, "Arrival_Date")
	//			Return -1		
	//	Else
	//		If f_validate_datetime(idw_main.GetItemDateTime(1, "Arrival_Date")) = 0 Then
	//			MessageBox(is_title, "Arrival Date is not a valid date!", StopSign!)	
	//			tab_main.SelectTab(1 ) 
	//			f_setfocus(idw_main, i, "Arrival_Date")
	//			Return -1
	//		End if
	//	End if
		
	//20-Dec-2017 :Madhu S14308 - Add validation against Arrival Date v/s Putaway Start Time - START
	//GailM - 2/14/2018 - S14308 removed and will be replaced by story from initiative I363 feature F6871
	//	IF (upper(gs_project) ='PANDORA') and (idw_main.GetItemDateTime(1, "Arrival_Date" ) < idw_main.GetItemDateTime(1, "putaway_start_time" )) Then
	//			MessageBox(is_title, "Arrival Date should be greater than Putaway Start Time!", StopSign!)	
	//			tab_main.SelectTab(1 ) 
	//			f_setfocus(idw_main, i, "Arrival_Date")
	//			Return -1
	//	End IF
	//20-Dec-2017 :Madhu S14308 - Add validation against Arrival Date v/s Putaway Start Time - END
	
	//TimA 09/18/15 Seeing errors in the DB Error Log table for invalid Order dates.
	//Putting this in the check and validate the Order date.
	If IsNull(idw_main.GetItemDateTime(1, "Ord_Date" ) ) Then
			MessageBox(is_title, "Please enter a valid Order Date!", StopSign!)	
			tab_main.SelectTab(1 ) 
			f_setfocus(idw_main, i, "Ord_Date")
			Return -1		
	Else
		If f_validate_datetime(idw_main.GetItemDateTime(1, "Ord_Date")) = 0 Then
			MessageBox(is_title, "Order Date is not a valid date!", StopSign!)	
			tab_main.SelectTab(1 ) 
			f_setfocus(idw_main, i, "Ord_Date")
			Return -1
		End if
	End if
	
	// 9/23/2010 - must default crossdock_ind since datawindow considers it required, even though it's not.
	if isnull(idw_main.GetItemString(1, "crossdock_ind")) or trim(idw_main.GetItemString(1, "crossdock_ind")) ='' then
		idw_main.SetItem(1, 'crossdock_ind', 'N')
	end if
	
	If f_check_required(is_title, idw_main) = -1 Then
		tab_main.SelectTab(1) 
		Return -1
	End If

	If f_check_required(is_title, idw_detail) = -1 Then
		tab_main.SelectTab(3) 
		Return -1
	End If

	If f_check_required(is_title, idw_putaway) = -1 Then
		tab_main.SelectTab(4) 
		Return -1
	End If
	
	//dts - 08/17/05 - Validate Scanner Status if Order is assigned to a scanner...
	lsScannerID = idw_main.GetItemString(1, "scanner_id") 
	if lsScannerID <> 'NONE' and not IsNull(lsScannerID) then
		//check status
		if idw_main.GetItemString(1, "scanner_status") <> 'PUTAWAY' then
			messagebox(is_Title, "Order has been assigned to a Scanner and can not be Confirmed until Scanner_Status is set to 'PUTAWAY'.", StopSign!)
			f_SetFocus(idw_main, 1, "Scanner_Status")
			return -1
		end if
	end if
		
End If /*Confirmation requested*/

If f_check_required(is_title, idw_rma_serial) = -1 Then
	tab_main.SelectTab(6) 
	Return -1
End If
	
// March 2010...
if gs_Project = 'PANDORA' then
	// do this in ue_confirm?
	lsFromLoc = upper(idw_main.GetItemString(1, "user_field6"))
	lsPOLine = upper( idw_main.GetItemString( 1, "user_field7" ) )	
	
	//GailM 1/24/2018 S14736 F5815 I382 PAN But allow Country of Dispatch to be blank on Receipt from RMA_SUPPL if PO Line Type=Material Receipt
	if lsFromLoc = 'RMA_SUPPL'  and lsPOLine <> "MATERIAL RECEIPT" then
		//If From Location = RMA_SUPPL, country of dispatch (rm.uf5) and vendor name (rm.uf9) are mandatory
		lsTemp = trim(idw_main.GetItemString(1, "user_field5"))
		if isnull(lsTemp) or lsTemp = '' Then
			MessageBox(is_title, "Must enter country of dispatch.", StopSign!)	
			tab_main.SelectTab(2) 
			f_setfocus(idw_other, 1, "User_Field5")
			Return -1
		End If
			
// TAM PEVS-809 -  ReMove vendor name requirement
//		lsTemp = trim(idw_main.GetItemString(1, "user_field9"))
//		if isnull(lsTemp) or lsTemp = '' Then
//			MessageBox(is_title, "Must enter Vendor Name.", StopSign!)	
//			tab_main.SelectTab(2) 
//			f_setfocus(idw_other, 1, "User_Field9")
//			Return -1
//		End If
	end if
end if


// Find duplicate records in order details
// 08/01 - Pconkl - added line item number to allow for the same sku in multiple lines (for Nortel)

ll_cnt = idw_detail.RowCount()

For i = 1 to ll_cnt
	
	ls_sku = idw_detail.GetItemString(i, "sku")
	lsSupplier = idw_detail.GetItemString(i, "supp_code")
	ls_osku = idw_detail.GetItemString(i, "alternate_sku")
	llOwner = idw_detail.GetItemNumber(i, "owner_id")
	llLineItem = idw_detail.GetItemNumber(i, "line_item_no")
	lsInactivesku =idw_detail.getitemstring(i, "Item_Delete_Ind") //06-Oct-2015 :Madhu- Added to don't receive Inactive SKU
	ls_sscc_nbr = idw_detail.getItemString(i, "sscc_nbr") //get SSCC Nbr

	If ls_sku = ls_psku and ls_osku = ls_posku  and llOwner = llPOwner and llLineItem = llPlineItem Then
		MessageBox(is_title, "Found duplicate detail records, please check!", StopSign!)	
		tab_main.SelectTab(3) 
		f_setfocus(idw_detail, i, "sku")
		Return -1
	End If
	
	//some fields are required just to save the record to the DB...
	if isnull(ls_SKU) Then
		MessageBox(is_title, "SKU is required!", StopSign!)	
		tab_main.SelectTab(3) 
		f_setfocus(idw_detail, i, "sku")
		Return -1
	End If
	
	if isnull(lsSupplier) Then
		MessageBox(is_title, "Supplier is required!", StopSign!)	
		tab_main.SelectTab(3) 
		f_setfocus(idw_detail, i, "supp_code")
		Return -1
	End If
	
	if isnull(ls_osku) Then
		MessageBox(is_title, "Alternate SKU is required!", StopSign!)	
		tab_main.SelectTab(3) 
		f_setfocus(idw_detail, i, "alternate_sku")
		Return -1
	End If
	
	if isnull(llLineItem) Then
		MessageBox(is_title, "Line Item is required!", StopSign!)	
		tab_main.SelectTab(3) 
		f_setfocus(idw_detail, i, "line_item_no")
		Return -1
	End If
	
	//06-Oct-2015 :Madhu- Added to don't receive Inactive SKU	 -START
	if lsInactivesku ='Y' Then
		MessageBox(is_title,"SKU '" + ls_sku + "' is Inactive!  Can not receive an Inactive SKU!",StopSign!)
		tab_main.SelectTab(3)
		f_setfocus(idw_detail, i, "sku")
		Return -1
	End if
	//06-Oct-2015 :Madhu- Added to don't receive Inactive SKU - END
	
	ls_psku = ls_sku
	ls_posku = ls_osku
	llPowner = llOwner
	llPLineItem = llLineItem
	
	if gs_Project = 'PANDORA' then // March 2010...
		lsFromLoc = upper(idw_main.GetItemString(1, "user_field6"))
		/*	per Roy... The rule is if Pop code or DC code is the from location and WH*G or WH*GM is the to location, then the pop location field must match the from location.  */
		/*	 5/10/2010 - new rule: From location is DC or PP and To location is WH*GM, then pop code field must match from location */
		
		if left(lsFromLoc, 2) = 'DC' or left(lsFromLoc, 2) = 'PP' then	
			lsToLoc = upper(idw_other.GetItemString(1, "user_field2"))
			//if left(lsToLoc, 2) = 'WH' and (right(lsToLoc, 1) = 'G' or right(lsToLoc, 2) = 'GM') then
			if left(lsToLoc, 2) = 'WH' and right(lsToLoc, 2) = 'GM' then
				//validate POP Location (rd.uf6), is equal to the 'From Location' (rm.uf6)
				lsPOP = upper(idw_detail.GetItemString(i, "user_field6"))
				if isnull(lsPOP) then lsPOP = ''
				if lsPOP <> lsFromLoc then
					MessageBox(is_title, "Invalid POP Location. Must equal FROM Location (" + lsFromLoc + ").", StopSign!)	
					tab_main.SelectTab(3) 
					f_setfocus(idw_detail, i, "User_Field6")
					Return -1
				end if
			End If
		end if //From Location begins 'DC' or 'PP'
	end if //Pandora
	
	//25-FEB-2019 :Madhu S28685 DE8978 - PHILIPSCLS BlueHeart -SSCCNbr Validation - START
	//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
	//IF upper(gs_project) ='PHILIPSCLS' and NOT ( ls_sscc_nbr = '-' or IsNull(ls_sscc_nbr) or ls_sscc_nbr = '') THEN
	IF (upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA') and NOT ( ls_sscc_nbr = '-' or IsNull(ls_sscc_nbr) or ls_sscc_nbr = '') THEN

		//2-MAR-2019 :Madhu 	DE9119- Find a SKU exist on Putaway List
		ll_find_putaway_row = idw_putaway.find( "sku ='"+ls_sku+"' and Line_Item_No = " + String(llLineItem), 1, idw_putaway.rowcount())
		IF ll_find_putaway_row > 0 THEN
			lsFind = "sku ='"+ls_sku+"' and Line_Item_No = " + String(llLineItem) +" and sscc_nbr ='"+ls_sscc_nbr+"'"
			ll_find_row = idw_putaway.find( lsFind, 1, idw_putaway.rowcount())
			IF ll_find_row = 0 THEN
				MessageBox(is_title, "SSCC Nbr: "+ls_sscc_nbr+" must be scanned on Putaway Records against SKU: "+ls_sku + " and Line_Item_No = " + String(llLineItem), StopSign!)
				Return -1
			END IF
		END IF
	END IF
	//25-FEB-2019 :Madhu S28685 DE8978- PHILIPSCLS BlueHeart -SSCCNbr Validation - END
				
Next

// Validate detail records

ll_cnt = idw_detail.RowCount()
For i = 1 to ll_cnt
	If IsNull(idw_detail.GetItemString(i, "ro_no")) Then
		idw_detail.SetItem(i, "ro_no", idw_main.GetItemString(1, "ro_no"))
	End If
	ls_sku = idw_detail.GetItemString(i, "sku")
	lsSupplier =  idw_detail.object.supp_code[ i ]
	// pvh - 03.17.06
	if gs_project = '3COM_NASH' and idw_Main.GetITemString(1,'ord_type') = 'X' then		
		if isSkuBundled( ls_sku, lsSupplier ) then 
			messagebox( is_title, "Bundled SKU not allowed on Return, Return Individual Child SKU(s)",stopsign! )
			f_setfocus(idw_detail, i, "sku")
			return -1
		end if	
	end if
	// eom	
	j = 0
Next

// Validate put away records

//// pvh - 03.14.06 - MARL
if gs_project = '3COM_NASH' and idw_Main.GetITemString(1,'ord_type') = 'X' then
	if doRLValidate() < 0 then return -1
end if
// eom

w_main.SetMicroHelp('Validating Data...Loop through putaway #1')

ll_cnt = idw_putaway.RowCount()

j = 0
ls_whcode = idw_main.getitemstring(1,'wh_code')

For i = 1 to ll_cnt /*each Putaway*/
	
	If IsNull(idw_putaway.GetItemString(i, "ro_no")) Then
		idw_putaway.SetItem(i, "ro_no", idw_main.GetItemString(1, "ro_no"))
	End If
	
	If IsNull(idw_putaway.GetItemNumber(i, "component_no")) Then
		idw_putaway.SetItem(i, "component_no",0)
	End If
		
	ls_sku = idw_putaway.GetItemString(i, "sku")
	llLineItem = idw_putaway.GetItemNumber(i, "Line_Item_No") /* 10/03 - PCONKL*/
	
	//SKU required
	if isnull(ls_SKU) Then
		MessageBox(is_title, "SKU is required!", StopSign!)	
		tab_main.SelectTab(4) 
		f_setfocus(idw_putaway, i, "sku")
		Return -1
	End If

	//TimA 09/18/15  Baseline make Expiration_Date required
	ldt_Expiration_Date = idw_putaway.GetItemDateTime(i, "Expiration_Date")
 	//Expiration_Date is a PK field and is required
	if IsNull(ldt_Expiration_Date ) Then
		MessageBox(is_title, "Expiration Date is required!", StopSign!)	
		tab_main.SelectTab(4 ) 
		f_setfocus(idw_putaway, i, "Expiration_Date")
		Return -1
	Else
		//See if it is a valid date and not just a typo
		If f_validate_DateTime(ldt_Expiration_Date  ) = 0 Then
			MessageBox(is_title, "Expiration Date is not a valid date!", StopSign!)	
			tab_main.SelectTab(4 ) 
			f_setfocus(idw_putaway, i, "Expiration_Date")
			Return -1
		end if

	End If

	//TimA 09/18/15  Baseline make ContainerID required
	ls_ContainerID = idw_putaway.GetItemString(i, "Container_Id")
	//inventory_type is a PK field and is required
	if isnull(ls_ContainerID ) Then
		MessageBox(is_title, "Container ID is required!", StopSign!)	
		tab_main.SelectTab(4 ) 
		f_setfocus(idw_putaway, i, "Container_Id")
		Return -1
	End If

	//TimA 09/10/15  Baseline make inventory_type required
	ls_InventoryType = idw_putaway.GetItemString(i, "inventory_type")
	//inventory_type is a PK field and is required
	if isnull(ls_InventoryType) Then
		MessageBox(is_title, "Inventory Type is required!", StopSign!)	
		tab_main.SelectTab(4 ) 
		f_setfocus(idw_putaway, i, "inventory_type")
		Return -1
	End If

	//TimA 02/08/13  Baseline make COO required
	ls_Coo = idw_putaway.GetItemString(i, "country_of_origin")
	//COO Required
	if isnull(ls_Coo) Then
		MessageBox(is_title, "Country or Origin is required!", StopSign!)	
		tab_main.SelectTab(4) 
		f_setfocus(idw_putaway, i, "country_of_origin")
		Return -1
	End If

	//Line Item Required
	if isnull(llLineItem) Then
		MessageBox(is_title, "Line Item is required!", StopSign!)	
		tab_main.SelectTab(4) 
		f_setfocus(idw_putaway, i, "Line_Item_No")
		Return -1
	End If
	
	//BCR - 08-MAY-2011: Remove leading and/or trailing spaces from Serial_No
	If LEFT(idw_putaway.GetItemString(i,'serial_no'), 1) = ' ' THEN 
		MessageBox(is_title, "Please remove leading spaces from Serial Number!", StopSign!)	
		tab_main.SelectTab(4) 
		f_setfocus(idw_putaway, i, "serial_no")
		Return -1
	END IF
	
//Nxjain13012017
//27-APR-2017 Madhu -PEVS-593 - Don't allow to save putaway, if Qty >1 but SN should be present - START.

	If gs_project <> 'PANDORA' then
		If idw_putaway.GetITemString(i,'serialized_ind') = 'Y' or idw_putaway.GetITemString(i,'serialized_ind') = 'B' Then
		//			If idw_putaway.GetItemString(i,'serial_no') = '-' or isnull(idw_putaway.GetItemString(i,'serial_no')) or Trim(idw_putaway.GetItemString(i,'serial_no')) = '' Then
		//					MessageBox(is_title, "Serial Numbers must be entered for serialized parts!", StopSign!)	
		//					tab_main.SelectTab(4) 
		//					f_setfocus(idw_putaway, i, "serial_no")
		//					Return -1
		//				Elseif idw_putaway.GetITemNumber(i,'quantity') <> 1  then
		//					MessageBox(is_title, "Quantity must be 1 for serialized parts!", StopSign!)	
		//					tab_main.SelectTab(4) 
		//					f_setfocus(idw_putaway, i, "quantity")
		//					Return -1
		//				end if 
		
				If (idw_putaway.GetItemString(i,'serial_no') <> '-' and not(isnull(idw_putaway.GetItemString(i,'serial_no'))) and Trim(idw_putaway.GetItemString(i,'serial_no')) <> '') &
					and (idw_putaway.GetITemNumber(i,'quantity') > 1 ) Then
							MessageBox(is_title, "Quantity must be 1 for serialized parts!", StopSign!)	
							tab_main.SelectTab(4) 
							f_setfocus(idw_putaway, i, "quantity")
				End If
	
		End If /*Serialized */
	End if 
	//27-APR-2017 Madhu -PEVS-593 - Don't allow to save putaway, if Qty >1 but SN should be present - END.
	
	//30-Jan-2019 :Madhu S28685 - PHILIPSCLS BlueHeart -Allow Receipt Validation - START
	//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
	IF upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA' THEN
		
		lsSupplier= idw_putaway.getItemString(i, "supp_code")
		llSkucount = i_nwarehouse.of_item_master( gs_project, ls_sku, lsSupplier)
		
		lsFind ="Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"' and supp_code = upper('"+lsSupplier+"')"
		llSkuFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())
		
		ls_Allow_Receipt = i_nwarehouse.ids.getItemString(llSkuFindRow, 'Allow_Receipt')
		
		IF ((IsNull(ls_Allow_Receipt) or ls_Allow_Receipt ='N')  and (ls_prev_sku  <> ls_sku)) THEN
			ls_msg ="SKU "+ls_sku+" is NEW to Warehouse. ~n~nPlease enable Allow_Receipt Indicator On Item Master."
			IF ibConfirmRequested THEN
				MessageBox(is_title, ls_msg, StopSign!)	
				tab_main.SelectTab(4) 
				f_setfocus(idw_putaway, i, "sku")
				Return -1
			ELSE
				MessageBox(is_title, ls_msg)	
				tab_main.SelectTab(4) 
				f_setfocus(idw_putaway, i, "sku")
			END IF
		END IF
		
		ls_prev_sku  = ls_sku
	
	END IF
	//30-Jan-2019 :Madhu S28685 - PHILIPSCLS BlueHeart -Allow Receipt Validation - END
	
	//TimA 09/22/11 Coment this out per Dave. Because the field is CHAR, there will always be trailing spaces anyway.
//	If RIGHT(idw_putaway.GetItemString(i,'serial_no'), 1) = ' ' THEN 
//		MessageBox(is_title, "Please remove trailing spaces from Serial Number!", StopSign!)	
//		tab_main.SelectTab(4) 
//		f_setfocus(idw_putaway, i, "serial_no")
//		Return -1
//	END IF
	//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	
	j = 0 /* 07/00 PCONKL */
	j = idw_detail.Find("Upper(sku) = '" + Upper(ls_sku) + "' and Line_Item_no = " + String(llLineITem), j, idw_detail.RowCount()) /* 10/03 - PCONKL - Include Line ITem in search*/
	
	If j > 0 Then
		
//		//make sure that Container ID is not duplicated - want to check everytime!
//		If (idw_putaway.GetItemString(i,'container_ID') <> '-') and i < idw_Putaway.RowCount() Then
//			If idw_Putaway.Find("Upper(Container_ID) = '" + Upper(idw_putaway.GetItemString(i,'container_ID')) + "'", (i + 1), (idw_putaway.RowCount() + 1)) > 0 Then
//				MessageBox(is_title, "Duplicate Container ID Found!", StopSign!)	
//				tab_main.SelectTab(4) 
//				f_setfocus(idw_putaway, i, "container_ID")
//				Return -1
//			End If
//		End If
		
		// 07/00 PCONKL - We will only be validating Putaway locations on confirmation. This will allow a putawaylist
		//						to be printed without locations
		
		If ibConfirmRequested Then
			
			k = 0
			ls_loc = idw_putaway.GetItemString(i, "l_code")
			select count(*) into :k from location 
				where wh_code = :ls_whcode and l_code = :ls_loc;
			If k = 0 or IsNull(k) Then
			//TAM W&S 2011/01 -  For wine and spirit,  Allow confirm of a putaway with a zero quantity.  They want enter the lotables in this order and create a backorder with those lotables.
				If Left(gs_project,3) = "WS-" and idw_putaway.GetITemNumber(i,'quantity') = 0  THEN
					
				Else
					MessageBox(is_title, "Invalid location in put away records, please check!", StopSign!)	
					tab_main.SelectTab(4) 
					f_setfocus(idw_putaway, i, "l_code")
					Return -1				
				End If //TAM W&S 2011/01 
			End If
			
			//10/02 - PConkl - If confirming, if serialized, serial # must be present and qty = 1
			// 02/09 - PCONKL - Serialized Type of 'B' = capturing both Inbound and Outbound but not writing to Content
			//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
			If (g.ib_receive_putaway_serial_rollup_ind =False and (idw_putaway.GetITemString(i,'serialized_ind') = 'Y' or idw_putaway.GetITemString(i,'serialized_ind') = 'B')) Then
				If idw_putaway.GetItemString(i,'serial_no') = '-' or isnull(idw_putaway.GetItemString(i,'serial_no')) or Trim(idw_putaway.GetItemString(i,'serial_no')) = '' Then
					MessageBox(is_title, "Serial Numbers must be entered for serialized parts!", StopSign!)	
					tab_main.SelectTab(4) 
					f_setfocus(idw_putaway, i, "serial_no")
					Return -1
				ElseIf idw_putaway.GetITemNumber(i,'quantity') <> 1 and  idw_putaway.GetITemString(i,'po_no2_controlled_ind') <> 'Y' Then		
					//GailM - 7/30/2013 - Added po_no2_controlled_ind for carton/pallet control. Pandora #608.
					MessageBox(is_title, "Quantity must be 1 for serialized parts!", StopSign!)	
					tab_main.SelectTab(4) 
					f_setfocus(idw_putaway, i, "quantity")
					Return -1
				End If
			End If /*Serialized */
			
			//Check for Lot Required
			If idw_putaway.GetITemString(i,'lot_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(i,'lot_no') = '-' or isnull(idw_putaway.GetItemString(i,'lot_no')) or Trim(idw_putaway.GetItemString(i,'lot_no')) = '' Then
				//TAM W&S 2011/01 -  For wine and spirit,  Allow confirm of a putaway with a zero quantity.  They want enter the lottables in this order and create a backorder with those lotables.
					If Left(gs_project,3) = "WS-" and idw_putaway.GetITemNumber(i,'quantity') = 0  THEN
						
					Else
						MessageBox(is_title, "Lot Numbers must be entered!", StopSign!)	
						tab_main.SelectTab(4) 
						f_setfocus(idw_putaway, i, "lot_no")
						Return -1
					End If //TAM W&S 2011/01 
				End If
			End If /*Lot Required*/
			
			//Check for PO Required
			If idw_putaway.GetITemString(i,'po_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(i,'po_no') = '-' or isnull(idw_putaway.GetItemString(i,'po_no')) or Trim(idw_putaway.GetItemString(i,'po_no')) = '' Then
				//TAM W&S 2011/01 -  For wine and spirit,  Allow confirm of a putaway with a zero quantity.  They want enter the lottables in this order and create a backorder with those lotables.
					If Left(gs_project,3) = "WS-" and idw_putaway.GetITemNumber(i,'quantity') = 0  THEN
						
					Else
						MessageBox(is_title, "PO Numbers must be entered!", StopSign!)	
						tab_main.SelectTab(4) 
						f_setfocus(idw_putaway, i, "po_no")
						Return -1
					End If //TAM W&S 2011/01 
				End If
			End If /*PO Required*/
			
			//Check for PO2 Required
			If idw_putaway.GetITemString(i,'po_no2_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(i,'po_no2') = '-' or isnull(idw_putaway.GetItemString(i,'po_no2')) or Trim(idw_putaway.GetItemString(i,'po_no2')) = '' Then
				//TAM W&S 2011/01 -  For wine and spirit,  Allow confirm of a putaway with a zero quantity.  They want enter the lottables in this order and create a backorder with those lotables.
					If Left(gs_project,3) = "WS-" and idw_putaway.GetITemNumber(i,'quantity') = 0  THEN
						
					Else
						MessageBox(is_title, "PO2 Numbers must be entered!", StopSign!)	
						tab_main.SelectTab(4) 
						f_setfocus(idw_putaway, i, "po_no2")
						Return -1
					End If //TAM W&S 2011/01 
				End If
			End If /*PO2 Required*/
			
			//Check for Container Required
			If idw_putaway.GetITemString(i,'container_tracking_ind') = 'Y' Then
				If idw_putaway.GetItemString(i,'container_ID') = '-' or isnull(idw_putaway.GetItemString(i,'container_ID')) or Trim(idw_putaway.GetItemString(i,'container_id')) = '' Then
					MessageBox(is_title, "Container ID must be entered!", StopSign!)	
					tab_main.SelectTab(4) 
					f_setfocus(idw_putaway, i, "container_ID")
					Return -1
				End If
			End If /*Container Required*/
						
			//Check for Expiration Date Required
			If idw_putaway.GetITemString(i,'expiration_Controlled_ind') = 'Y' Then
				If isnull(idw_putaway.GetItemDateTime(i,'expiration_Date')) or String(idw_putaway.GetItemDateTime(i,'expiration_Date'),'mm/dd/yyyy') = '12/31/2999' Then
					MessageBox(is_title, "Expiration Date must be entered!", StopSign!)	
					tab_main.SelectTab(4) 
					f_setfocus(idw_putaway, i, "expiration_Date")
					Return -1
				End If
			End If /*Expiration Date Required*/
						
			
		End If /*Confirm Requested*/
		
	Else /*Line Item/Sku not found*/
		
		If idw_Putaway.GetItemString(i,"component_ind") <> '*' and idw_Putaway.GetItemString(i,"component_ind") <> 'B' Then /* 09/00 PCONKL - An asterick means it's a component child, 'B' means it's both - will not be in order detail*/
			MessageBox(is_title, "Line Item/SKU not in order details, please check!", StopSign!)	
			tab_main.SelectTab(4) 
			f_setfocus(idw_putaway, i, "sku")
			Return -1
		End If /*not component*/
		
	End If
	
	//MikeA - 02/14/2020 - DE14804 -  SIMS - Google - Footprints Container shipped on multiple orders 
	//Don't allow it to be saved it came in on a previous order even in same location. 
	
	IF  f_is_sku_foot_print (idw_putaway.GetItemString(i, "sku"), idw_putaway.GetItemString(i, "supp_code")) THEN

		ls_ContainerID = idw_putaway.GetItemString(i, "Container_Id")
		ls_loc = idw_putaway.GetItemString(i, "l_code")
		ls_ro_no = idw_putaway.GetItemString(i, "ro_no")
		ls_po_no2 = idw_putaway.GetItemString(i, "po_no2")
	
		IF Trim(Upper(ls_ContainerID)) <> 'NA' AND Not IsNull(ls_ContainerID) AND Trim(ls_ContainerID) <> '' AND Trim(ls_ContainerID) <> '-' THEN
		
			//Check to see container has already been checked for this save process
	
			lb_CheckContainer = true
	
			IF UpperBound(lsCheckedContainer) > 0 THEN
				FOR ll_CheckedContainer = 1 to UpperBound(lsCheckedContainer)
					//Container Has already been checked. 
					IF lsCheckedContainer[ll_CheckedContainer] = ls_ContainerID then
						 lb_CheckContainer =  false
						 EXIT
					END IF
				NEXT
			END IF
				
			IF lb_CheckContainer THEN
			
				//Look to see if container already exists in the warehouse. 
			
				SELECT Count(l_code) INTO :li_Count
					FROM Content_Summary (NoLock)
					WHERE Container_ID = :ls_ContainerID AND
								l_code <> :ls_loc AND
								ro_no <> :ls_ro_no AND
								wh_code = :ls_whcode USING SQLCA;
								
				IF li_Count > 0 THEN
					MessageBox(is_title, "Container " + string(ls_ContainerID) + " is a Footprint Container and cannot be split across multiple locations. There is another location has the same ContainerID: " + ls_ContainerID, StopSign!)
					Return -1
				END IF
				
				//Make sure Container is not being split across multiple locations
	
				ll_find_loc_row = idw_putaway.find( "Container_ID ='"+ls_ContainerID+"' and l_code <> '" + String(ls_loc) + "'", 1, idw_putaway.rowcount())
				IF ll_find_loc_row > 0 THEN
					MessageBox(is_title, "Container " + string(ls_ContainerID) + " is a Footprint Container and cannot be split across multiple locations. Row: " + string(ll_find_loc_row), StopSign!)
					idw_putaway.SetRow(ll_find_loc_row)
					idw_putaway.SetColumn("l_code")
					Return -1
				END IF
				
				lsCheckedContainer[UpperBound(lsCheckedContainer)+1] = ls_ContainerID
					
			END IF
			
		END IF
			
		//Check to see pallet has already been checked for this save process

		IF Trim(Upper(ls_po_no2)) <> 'NA' AND Not IsNull(ls_po_no2) AND Trim(ls_po_no2) <> ''  AND Trim(ls_po_no2) <> '-' THEN

			lb_CheckPallet = true
	
			IF UpperBound(lsCheckedPallet) > 0 THEN
				FOR ll_CheckedPallet = 1 to UpperBound(lsCheckedPallet)
					//Container Has already been checked. 
					IF lsCheckedPallet[ll_CheckedPallet] = ls_po_no2 then
						 lb_CheckPallet =  false
						 EXIT
					END IF
				NEXT
			END IF
				
			IF lb_CheckPallet THEN	
				
				SELECT Count(l_code) INTO :li_Count
					FROM Content_Summary (NoLock)
					WHERE Po_No2 = :ls_po_no2 AND
								l_code <> :ls_loc AND
								ro_no <> :ls_ro_no AND
								wh_code = :ls_whcode USING SQLCA;
								
				IF li_Count > 0 THEN
					MessageBox(is_title, "Pallet " + string(ls_po_no2) + " is a Footprint Pallet and cannot be split across multiple locations. There is another location has the same PalletID: " + ls_po_no2, StopSign!)
					Return -1
				END IF			
		
					
				//Make sure Pallet is not being split across multiple locations
		
				ll_find_loc_row = idw_putaway.find( "po_no2 ='"+ls_po_no2+"' and l_code <> '" + String(ls_loc) + "'", 1, idw_putaway.rowcount())
				IF ll_find_loc_row > 0 THEN
					MessageBox(is_title, "Pallet " + string(ls_po_no2) + " is a Footprint Pallet and cannot be split across multiple locations. Row: " + string(ll_find_loc_row), StopSign!)
					idw_putaway.SetRow(ll_find_loc_row)
					idw_putaway.SetColumn("l_code")
					Return -1
				END IF				

			END IF
	
		END IF
	END IF
	
Next /*Putaway rec */

// Find duplicate records in put away list
	w_main.SetMicroHelp('Validating Data...Loop through putaway checking for duplicate SN/GPNs')

	ll_cnt = idw_putaway.RowCount()
	
	setPointer( hourglass! )
	idw_Putaway.SetRedraw(False)
	
	For i = 1 to ll_cnt
		if doDuplicatePutawayCheck( i ) then
			MessageBox(is_title, "Found duplicate put away records, please check!", StopSign!)	
			tab_main.SelectTab(4)  /* 06/15 - PCONKL - changed to 4 to account for new other info tab*/
			f_setfocus(idw_putaway, i, "sku")
			idw_Putaway.SetRedraw(True)
			Return -1
		end if
	Next

SetPointer(Arrow!)
idw_Putaway.SetRedraw(True)
w_main.SetMicroHelp('Ready...')

return 0
end function

public subroutine wf_clear_screen ();idw_main.Reset()
idw_detail.reset()
idw_putaway.reset()
idw_notes.reset()

tab_main.tabpage_main.cb_confirm.enabled = False
tab_main.tabpage_main.cb_void.enabled = False	
tab_main.tabpage_putaway.Enabled = False
tab_main.tabpage_notes.Enabled = False

ib_import = False
tab_main.SelectTab(1) 
idw_main.Hide()

isle_code.Text = ""

//MStuart - backorder functionalty
tab_main.tabpage_main.cb_backorder.visible= False


Return

end subroutine

public function integer wf_check_confirm ();
// 07/04 - PCONKL - moved to UO 

U_nvo_custom_validations_Receive	lu_validate

lu_validate = Create U_nvo_custom_validations_Receive

Return	lu_validate.uf_check_Confirm()



end function

public subroutine wf_checkstatus ();integer i, li_EdiBatchNo
string ls_dw_color, ls_Status, lsOrder
string lsOrigSQL, lsNewSQL, lsWhere, lsFind
long llFindRow, llCntrCount
long llEdiBatchNo		//GailM 6/9/2020 - DE16304 - Integer li_EdiBatchNo failed to ready numeric field.  Replaced by Long datatype.

//messagebox("check status","")
//messageBox("status", string( idw_main.object.ord_status[1]))


str_multiparms lstr_parms
//Transfer Main information
i=1
lstr_parms.string_arg1[i]="supp_invoice_no";i++
lstr_parms.string_arg1[i]="ord_date";i++
lstr_parms.string_arg1[i]="arrival_date";i++
lstr_parms.string_arg1[i]="ord_type";i++
lstr_parms.string_arg1[i]="wh_code";i++
lstr_parms.string_arg1[i]="inventory_type";i++
lstr_parms.string_arg1[i]="supp_code";i++
lstr_parms.string_arg1[i]="supp_name";i++
lstr_parms.string_arg1[i]="supp_order_no";i++
lstr_parms.string_arg1[i]="line_of_business";i++
lstr_parms.string_arg1[i]="awb_bol_no";i++
lstr_parms.string_arg1[i]="back_order_no";i++
//lstr_parms.string_arg1[i]="complete_date";i++
lstr_parms.string_arg1[i]="ship_via";i++
lstr_parms.string_arg1[i]="ship_ref";i++
lstr_parms.string_arg1[i]="carrier";i++
lstr_parms.string_arg1[i]="agent_info";i++
lstr_parms.string_arg1[i]="ctn_cnt";i++
lstr_parms.string_arg1[i]="weight";i++
lstr_parms.string_arg1[i]="shipping_carton_volume";i++
lstr_parms.string_arg1[i]="request_date";i++
lstr_parms.string_arg1[i]="transport_mode";i++
lstr_parms.string_arg1[i]="customs_doc";i++ 
lstr_parms.string_arg1[i]="user_field1";i++
lstr_parms.string_arg1[i]="user_field2";i++
lstr_parms.string_arg1[i]="user_field3";i++
lstr_parms.string_arg1[i]="user_field4";i++
lstr_parms.string_arg1[i]="user_field5";i++
lstr_parms.string_arg1[i]="user_field6";i++
lstr_parms.string_arg1[i]="user_field7";i++
lstr_parms.string_arg1[i]="user_field8";i++
lstr_parms.string_arg1[i]="user_field9";i++
lstr_parms.string_arg1[i]="user_field10";i++
lstr_parms.string_arg1[i]="user_field11";i++
lstr_parms.string_arg1[i]="scanner_id";i++
lstr_parms.string_arg1[i]="scanner_status";i++
lstr_parms.string_arg1[i]="remark";i++
lstr_parms.string_arg1[i]="container_nbr";i++
lstr_parms.string_arg1[i]="client_cust_po_nbr";i++
lstr_parms.string_arg1[i]="container_type";i++
lstr_parms.string_arg1[i]="client_order_type";i++
lstr_parms.string_arg1[i]="from_wh_loc";i++
lstr_parms.string_arg1[i]="client_invoice_nbr";i++
lstr_parms.string_arg1[i]="seal_nbr";i++
lstr_parms.string_arg1[i]="vendor_invoice_nbr";
isle_code.DisplayOnly = True
isle_code.TabOrder = 0

//li_EdiBatchNo = idw_main.GetItemNumber(1,'Edi_Batch_Seq_No')		
llEdiBatchNo =  idw_main.GetItemNumber(1,'Edi_Batch_Seq_No')	//DE16304

// KRZ TEST
//messagebox("tabsequence 1",  string(tab_main.tabpage_putaway.dw_putaway.Object.po_no.TabSequence))

tab_main.tabpage_orderDetail.dw_detail.Object.datawindow.ReadOnly = 'NO' /* may be set to readolnly = Yes below, reset here */

//TimA 04/09/14 
icb_confirm.Text = '&Confirm'

	
// 02/09 - dts - Drop-down for User_Field2 should only be visible for Pandora
// GailM 08/15/2014 Pandora Issue 883 - DejaVu intermediate orders with containerIDs requires scanning - set flag
If Upper(gs_Project) = 'PANDORA' Then
	
	//29-APR-2019 :Madhu S32505 F15371 - Add Container Level validations. - START
	IF NOT isnull(llEdiBatchNo) and llEdiBatchNo <> 0  THEN
		if NOT isvalid(idsEdiContainers) then
				idsEdiContainers = Create datastore
		end if
			
		idsEdiContainers.reset()
		idsEdiContainers.dataobject = "d_edi_batch_trans_in_detail"
		idsEdiContainers.SetTransObject(SQLCA)
		lsOrigSQL = idsEdiContainers.GetSQLSelect()
	
		lsWhere = " where dbo.EDI_Inbound_Detail.Project_ID = '" + gs_Project + "'" 	/*always tackon project */ 
		lsWhere += " and dbo.EDI_Inbound_Detail.EDI_Batch_Seq_No = " + String(idw_main.GetItemNumber(1,'Edi_Batch_Seq_No') )
		lsNewSQL = lsOrigSql + lsWhere
		
		idsEdiContainers.SetSqlSelect(lsNewSQL)
		idsEdiContainers.Retrieve()
	END IF
	//29-APR-2019 :Madhu S32505 F15371 - Add Container Level validations. - END
	
//	tab_main.tabpage_other.user_field2_pandora.Visible = True
	If (idw_Main.GetItemString(1,'Ord_type') = 'Y' and NOT isnull(li_EdiBatchNo) and li_EdiBatchNo <> 0 ) Then	// Intermediate order, check staging table for containerIDs
		
		If idsEdiContainers.RowCount() > 0 Then
			//lsFind = idsEdiContainers.GetItemString(1,'container_id')		// Test first record for existence of container_id
			//If NOT isnull(lsFind) or lsFind = '' or lsFind = '-' Then
			//// LTK 20140926 Change the Deja Vu condition
			//If NOT (isnull(lsFind) or lsFind = '' or lsFind = '-') Then
			//	ibDejaVu = true
			//End If
			//now testing to see if ANY record has Container ID
			If idsEdiContainers.Find("Container_id <> '-' and Container_id <> ''", 1, idsEdiContainers.RowCount()) > 0   Then
				ibDejaVu = true
			end if
		
		End If
	Elseif idw_Main.GetItemString(1,'Ord_type') = 'Z' Then	// Warehouse Transfer, check DO for containerIDs

		// LTK 20150212  Pandora #984  Lock detail datawindow for warehouse transfers
		tab_main.tabpage_orderDetail.dw_detail.Object.datawindow.ReadOnly = 'YES'

		If NOT isvalid(idsDOPicking) Then
			idsDOPicking = Create datastore
		end if // dts 10/16/14  - need to only create the datastore once but need to check for DejaVu if a new order is opened (but not multiple times per order - but oh well...)
			idsDOPicking.reset()
			idsDOPicking.dataobject = 'd_do_picking'
			idsDOPicking.SetTransObject(SQLCA)
			idsDOPicking.Retrieve(tab_main.tabpage_main.dw_main.GetItemString(1,'do_no'))
			If idsDOPicking.RowCount() > 0 Then
//				lsFind = idsDOPicking.GetItemString(1,'container_id')			// Test first record for existence of container_id
//				If NOT isnull(lsFind) or lsFind = '' or lsFind = '-' Then
				// LTK 20140926 Change the Deja Vu condition
//				If NOT (isnull(lsFind) or lsFind = '' or lsFind = '-') Then
					//dts - 10/16/14 - Need to look at Outbound order to see if it's DejaVu (either look at edi_outbound_detail or look at DD.UF7 which is populated by Container ID from file)
					// - for now, just seeing if any detail line has 'RMA Container ID' (dd.uf7) populated. The original condition above only checked 1st record so mixture of DejaVu and non-DejaVu would not be handled correctly
					lsOrder = idw_main.GetItemString(1, 'supp_invoice_no')
					select COUNT(dd.DO_No) into :llCntrCount
					from Delivery_Master dm inner join Delivery_Detail dd on dm.DO_No=dd.DO_No
					where Project_Id = 'Pandora' 
					and Invoice_No = :lsOrder
					and (dd.User_Field7 <>'' and dd.User_Field7 is not null);
					if llCntrCount > 0 then
						ibDejaVu = true
					end if
				//End If
			End If
		//dts End If
	Else
		//	tab_main.tabpage_other.user_field2_pandora.Visible = False
	End If
End If

// 11/30 - GMOR - Pallet button on putaway tab is only visible for Comcast
If Upper(gs_Project) = 'COMCAST' Then
	tab_main.tabpage_putaway.cb_putaway_pallets.Visible = True
Else
	tab_main.tabpage_putaway.cb_putaway_pallets.Visible = False
End If
	
// 04/09 - PCONKL - ADdress button only enabled for Customer Returns
If idw_Main.GetItemString(1,'Ord_type') = 'X' Then

	tab_main.tabpage_main.cb_address.visible = True	
	//MStuart - 090111	
	tab_main.tabpage_main.cb_address.x = 2341
	
	If idw_Main.GetITemString(1,'ro_no') > '' Then
		tab_main.tabpage_main.cb_address.Enabled = True
	Else
		tab_main.tabpage_main.cb_address.Enabled = False
	End If
	
Else
	
	tab_main.tabpage_main.cb_address.visible = False	
		
End If

// TAM W&S 2010/12 Lock Down Fields for Wine and Spirit
If left(gs_project,3) = 'WS-'   then
	idw_detail.object.req_qty.protect = true
	idw_detail.object.uom.protect = true    
	idw_detail.SetTabOrder("req_qty", 0)
	idw_detail.SetTabOrder("uom", 0)
END IF

// SARUN2014MAY12 : WS-PR Inbound Export
If upper(gs_project) =  'WS-PR' then
	tab_main.tabpage_main.cb_custom2.enabled = false
	tab_main.tabpage_main.cb_custom2.visible = false			
End IF 

Choose Case idw_main.GetItemString(1,"ord_status")
		
	Case "N"
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True			
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_orderdetail.Enabled = True
		tab_main.tabpage_other_info.enabled = True
		If ib_edit Then
			tab_main.tabpage_main.cb_confirm.enabled = True	
			tab_main.tabpage_main.cb_void.enabled = True	
			tab_main.tabpage_putaway.Enabled = True			
		Else
			tab_main.tabpage_main.cb_confirm.enabled = False
			tab_main.tabpage_main.cb_void.enabled = False	
			tab_main.tabpage_putaway.Enabled = False
		End If
		
		tab_main.tabpage_orderdetail.cb_insert.enabled = True
		tab_main.tabpage_orderdetail.cb_delete.enabled = True	
		tab_main.tabpage_OrderDetail.cb_IQC.Enabled = True
		tab_main.tabpage_putaway.cb_deleterow.enabled = True	
		tab_main.tabpage_putaway.cb_insertrow.enabled = True	
		tab_main.tabpage_putaway.cb_generate.enabled = True	
		tab_main.tabpage_putaway.cb_copyrow.enabled = True	
		tab_main.tabpage_putaway.cb_putaway_pallets.enabled = False  /* 12/01 - GMOR */
		
		tab_main.tabpage_rma_serial.Enabled = False /* 05/05 - PCONKL */
		
		i_nwarehouse.of_settab(idw_main,lstr_parms,1)
		
		// GailM 6/12/15 - allow edit named fields
		idw_main.SetTaborder( "container_nbr", 210)
		idw_main.SetTaborder( "client_cust_po_nbr", 220)
		idw_main.SetTaborder( "container_type", 230)
		idw_main.SetTaborder( "client_order_type", 240)
		idw_main.SetTaborder( "from_wh_loc", 250)
		idw_main.SetTaborder( "client_invoice_nbr", 260)
		idw_main.SetTaborder( "seal_nbr", 270)
		idw_main.SetTaborder( "vendor_invoice_nbr", 280)

		idw_detail.SetTabOrder("line_item_no", 5)
		idw_detail.SetTabOrder("sku", 10)
		idw_detail.SetTabOrder("supp_code", 15)
		idw_detail.SetTabOrder("alternate_sku", 20)
		// pvh 09/09/05 
		//idw_detail.SetTabOrder("country_of_origin", 25)
		idw_detail.SetTabOrder("req_qty", 30)
		idw_detail.SetTabOrder("uom", 40)
		idw_detail.SetTabOrder("cost", 50)
		idw_detail.SetTabOrder("user_field1",60)
		idw_detail.SetTabOrder("user_field2",70)
		idw_detail.SetTabOrder("user_field3",80)
		idw_detail.SetTabOrder("user_field4",90)
		
		idw_putaway.SetTabOrder("line_item_no", 5)
		idw_putaway.SetTabOrder("sku", 10)
		idw_putaway.SetTabOrder("supp_code", 12)
		idw_putaway.SetTabOrder("country_of_Origin", 15)
		idw_putaway.SetTabOrder("l_code", 20)
		idw_putaway.SetTabOrder("inventory_type",30)
		idw_putaway.SetTabOrder("quantity", 35)
		idw_putaway.SetTabOrder("serial_no", 40)
		idw_putaway.SetTabOrder("lot_no", 45)	
		idw_putaway.SetTabOrder("po_no", 50)	
		idw_putaway.SetTabOrder("po_no2", 55)
		idw_putaway.SetTabOrder("container_ID", 60)
		idw_putaway.SetTabOrder("expiration_Date", 70)
		idw_putaway.SetTabOrder("length", 80)
		idw_putaway.SetTabOrder("width", 90)
		idw_putaway.SetTabOrder("height", 100)
		idw_putaway.SetTabOrder("weight_Gross", 110)
		idw_putaway.SetTabOrder("user_field1",120)
		idw_putaway.SetTabOrder("user_field2",130)
		idw_putaway.SetTabOrder("user_field3",140)
		idw_putaway.SetTabOrder("user_field4",150)	
		idw_putaway.SetTabOrder("user_field5",160)
		idw_putaway.SetTabOrder("user_field6",170)
		idw_putaway.SetTabOrder("user_field7",180)
		idw_putaway.SetTabOrder("user_field8",190)
		idw_putaway.SetTabOrder("user_field8", 200)
		idw_putaway.SetTabOrder("user_field9",210)
		idw_putaway.SetTabOrder("user_field10",220)
		idw_putaway.SetTabOrder("user_field11",230)		
		idw_putaway.SetTabOrder("user_field12",240)	
		
	// TAM W&S 2010/12 Lock Down Fields for Wine and Spirit
		If left(gs_project,3) = 'WS-'   then
			idw_detail.SetTabOrder("req_qty", 0)
			idw_detail.SetTabOrder("uom", 0)
			idw_detail.object.user_field3.protect = true    
			idw_putaway.object.po_no.protect = true    
			idw_detail.SetTabOrder("user_field3", 0)
			idw_putaway.SetTabOrder("po_no", 0)
		END IF
		
		IF left(upper(gs_project), 2) =  'WS' Then
			tab_main.tabpage_main.cb_custom1.enabled = false
		End IF 
		
		IF Left(gs_project,4) = "NIKE" THEN 
			tab_main.tabpage_main.cb_custom1.enabled = false
			
			if idw_main.getitemnumber(1, "edi_batch_seq_no") > 0 then
				idw_detail.object.req_qty.protect = true
				
				tab_main.tabpage_orderdetail.cb_insert.enabled = False
				tab_main.tabpage_orderdetail.cb_delete.enabled = False					
				
				
			else
				idw_detail.object.req_qty.protect = false
			end if
			
		END IF

		tab_main.tabpage_putaway.cb_putaway_locs.Enabled = False
		
		IF gs_project = "PANDORA" THEN
			tab_main.Tabpage_putaway.cbx_autofill.enabled = true
			tab_main.Tabpage_putaway.cbx_autofill.checked = false			
		END IF

		
Case "P"
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
//		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		tab_main.tabpage_putaway.Enabled = True
		tab_main.tabpage_orderdetail.cb_insert.enabled = True
		tab_main.tabpage_orderdetail.cb_delete.enabled = True	
		tab_main.tabpage_OrderDetail.cb_IQC.Enabled = True
		tab_main.tabpage_putaway.cb_deleterow.enabled = True	
		tab_main.tabpage_putaway.cb_insertrow.enabled = True	
		tab_main.tabpage_putaway.cb_copyrow.enabled = True
		tab_main.tabpage_putaway.cb_generate.enabled = True
		tab_main.tabpage_putaway.cb_print.enabled = True
		tab_main.tabpage_putaway.cb_putaway_pallets.enabled = True /* 12/01 - GMOR */
		tab_main.tabpage_main.cb_confirm.enabled = True
		tab_main.tabpage_main.cb_void.enabled = True
		tab_main.tabpage_other_info.enabled = True
			
		// GailM 6/12/15 - allow edit named fields
		idw_main.SetTaborder( "container_nbr", 210)
		idw_main.SetTaborder( "client_cust_po_nbr", 220)
		idw_main.SetTaborder( "container_type", 230)
		idw_main.SetTaborder( "client_order_type", 240)
		idw_main.SetTaborder( "from_wh_loc", 250)
		idw_main.SetTaborder( "client_invoice_nbr", 260)
		idw_main.SetTaborder( "seal_nbr", 270)
		idw_main.SetTaborder( "vendor_invoice_nbr", 280)
				
		//Added By DGM
      i_nwarehouse.of_settab(idw_main,lstr_parms,1)
		idw_main.SetTabOrder("supp_code", 0)
		idw_main.SetTabOrder("complete_date", 0)
		///
		
		idw_detail.SetTabOrder("line_item_no", 5)
		idw_detail.SetTabOrder("sku", 10)
		idw_detail.SetTabOrder("supp_code", 15)
		idw_detail.SetTabOrder("alternate_sku", 20)
		// pvh - 09/09/05
		//idw_detail.SetTabOrder("country_of_origin", 25)
		idw_detail.SetTabOrder("req_qty", 30)
		idw_detail.SetTabOrder("uom", 40)
		idw_detail.SetTabOrder("cost", 50)
		idw_detail.SetTabOrder("user_field1",60)
		idw_detail.SetTabOrder("user_field2",70)
		idw_detail.SetTabOrder("user_field3",80)
		idw_detail.SetTabOrder("user_field4",90)
		

		idw_putaway.SetTabOrder("line_item_no", 5)
		idw_putaway.SetTabOrder("sku", 10)
		idw_putaway.SetTabOrder("supp_code", 12)
		idw_putaway.SetTabOrder("country_of_Origin", 15)
		idw_putaway.SetTabOrder("l_code", 20)
		idw_putaway.SetTabOrder("inventory_type",30)
		idw_putaway.SetTabOrder("quantity", 35)
		idw_putaway.SetTabOrder("serial_no", 40)

		idw_putaway.SetTabOrder("lot_no", 50)
		idw_putaway.SetTabOrder("po_no", 60)
		idw_putaway.SetTabOrder("po_no2", 70)
		idw_putaway.SetTabOrder("container_ID", 75)
		idw_putaway.SetTabOrder("expiration_date", 80)
		idw_putaway.SetTabOrder("length", 85)
		idw_putaway.SetTabOrder("width", 90)
		idw_putaway.SetTabOrder("height", 100)
		idw_putaway.SetTabOrder("weight_Gross", 110)
		idw_putaway.SetTabOrder("user_field1",120)
		idw_putaway.SetTabOrder("user_field2",130)
		idw_putaway.SetTabOrder("user_field3",140)
		idw_putaway.SetTabOrder("user_field4",150)	
		idw_putaway.SetTabOrder("user_field5",160)
		idw_putaway.SetTabOrder("user_field6",170)
		idw_putaway.SetTabOrder("user_field7",180)
		idw_putaway.SetTabOrder("user_field8",190)
		idw_putaway.SetTabOrder("user_field8", 200)
		idw_putaway.SetTabOrder("user_field9",210)
		idw_putaway.SetTabOrder("user_field10",220)
		idw_putaway.SetTabOrder("user_field11",230)		
		idw_putaway.SetTabOrder("user_field12",240)	
		
		
		// 08/07 - PCONKL - Only enabling RMA Serial Tab for 3COM Order Types 'M' and 'R' And any serialized part
		If idw_main.RowCount() > 0 and gs_project = '3COM_NASH' Then
			
			If  idw_Main.GetITemString(1,'Ord_type') = 'M' or idw_Main.GetITemString(1,'Ord_type') = 'R' Then 
				
				//Check for Serialized parts - normally tracked at Outbound but will track at Inbound for RMA side of house (As opposed to Revenue)
				If idw_rma_serial.Find("serialized_ind <> 'N'",1,idw_rma_serial.RowCount()) > 0   Then				
					
//					OR &
//				   (idw_putaway.Find("serialized_ind <> 'N'",1,idw_putaway.RowCount()) > 0) 
					
					tab_main.tabpage_rma_serial.Enabled = True /* 05/05 - PCONKL*/
					idw_rma_Serial.Object.datawindow.ReadOnly = 'No'
					
					tab_main.tabpage_rma_serial.rb_auto.Checked = True
					tab_main.tabpage_rma_serial.rb_auto.triggerEvent('clicked')
					
				Else
					tab_main.tabpage_rma_serial.Enabled = False
				End If
			Else
				tab_main.tabpage_rma_serial.Enabled = False
			End If
			
		End If /* 3COM ONly */
		
		If g.ib_receive_putaway_serial_rollup_ind Then tab_main.tabpage_rma_serial.Enabled = True
		
		IF gs_project = "PANDORA" THEN
			idw_main.SetTabOrder("wh_code",0)
			idw_other.SetTabOrder("user_field2",0)
		END IF
		
	// TAM W&S 2010/12 Lock Down Fields for Wine and Spirit
		If left(gs_project,3) = 'WS-'   then
			idw_detail.SetTabOrder("req_qty", 0)
			idw_detail.SetTabOrder("uom", 0)
			idw_detail.object.user_field3.protect = true    
			idw_putaway.object.po_no.protect = true    
			idw_detail.SetTabOrder("user_field3", 0)
			idw_putaway.SetTabOrder("po_no", 0)
		END IF
		
		If left(upper(gs_project), 2) =  'WS' then
			tab_main.tabpage_main.cb_custom1.enabled = false
		End IF 		
		

		IF Left(gs_project,4) = "NIKE" THEN 
			tab_main.tabpage_main.cb_custom1.enabled = false
			
			if idw_main.getitemnumber(1, "edi_batch_seq_no") > 0 then
				idw_detail.object.req_qty.protect = true
				
				tab_main.tabpage_orderdetail.cb_insert.enabled = False
				tab_main.tabpage_orderdetail.cb_delete.enabled = False					
			
				
			else
				idw_detail.object.req_qty.protect = false
			end if
			
		END IF
		
		If left(gs_project,6) = 'PHYSIO' Then
			
			tab_main.tabpage_putaway.cb_putaway_locs.Enabled = True
			tab_main.tabpage_putaway.cb_putaway_locs.Text = "Assign Locs..."
			
		End If

		
		IF gs_project = "PANDORA" THEN
			tab_main.Tabpage_putaway.cbx_autofill.enabled = true
			tab_main.Tabpage_putaway.cbx_autofill.checked = false			
		END IF
		
		
	CASE "C" 
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
//		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_other_info.enabled = True
		tab_main.tabpage_orderdetail.Enabled = True
		tab_main.tabpage_putaway.Enabled = True
		tab_main.tabpage_orderdetail.cb_insert.enabled = False
		tab_main.tabpage_orderdetail.cb_delete.enabled = False	
		tab_main.tabpage_OrderDetail.cb_IQC.Enabled = True
		tab_main.tabpage_putaway.cb_deleterow.enabled = False	
		tab_main.tabpage_putaway.cb_insertrow.enabled = False	
		tab_main.tabpage_putaway.cb_copyrow.enabled = False	
		tab_main.tabpage_putaway.cb_generate.enabled = False
		tab_main.tabpage_putaway.cb_print.enabled = true
	//	tab_main.tabpage_putaway.cb_asn.enabled = False
		tab_main.tabpage_putaway.cb_putaway_pallets.enabled = False  /* 12/01 - GMOR */
		//tab_main.tabpage_main.cb_confirm.enabled = False //This is now set down below for super users and re-confirm
		tab_main.tabpage_main.cb_void.enabled = False

		if ( gs_role = "-1" or gs_role = "0" ) then
			//TimA 04/30/14 Re-Confirm is only for Super Users.
			icb_confirm.Enabled = True
			icb_confirm.Text = 'Re-&Confirm'
		else
			icb_confirm.Enabled = false
		end if
						
		tab_main.tabpage_rma_serial.Enabled = True
		idw_rma_Serial.Object.datawindow.ReadOnly = 'Yes'

     	 i_nwarehouse.of_settab(idw_main) 		 
		idw_main.SetTabOrder("ship_via", 100)
		idw_main.SetTabOrder("ship_ref", 110)
		idw_main.SetTabOrder("ctn_cnt", 120)
		idw_main.SetTabOrder("weight", 130)		
		idw_other.SetTabOrder("user_field1",10)
		idw_other.SetTabOrder("user_field2",20)
		idw_other.SetTabOrder("user_field3",30)
		idw_other.SetTabOrder("user_field4",40)
		idw_other.SetTabOrder("user_field5",50)
		idw_other.SetTabOrder("user_field6",60)
		idw_other.SetTabOrder("user_field7",70)
		idw_other.SetTabOrder("user_field8",80)
		idw_main.SetTabOrder("remark",270)
		
		// GailM 6/12/15 - disallow edit named fields
		idw_main.SetTaborder( "container_nbr", 0)
		idw_main.SetTaborder( "client_cust_po_nbr", 0)
		idw_main.SetTaborder( "container_type", 0)
		idw_main.SetTaborder( "client_order_type", 0)
		idw_main.SetTaborder( "from_wh_loc", 0)
		idw_main.SetTaborder( "client_invoice_nbr", 0)
		idw_main.SetTaborder( "seal_nbr", 0)
		idw_main.SetTaborder( "vendor_invoice_nbr", 0)

		IF gs_project = "PANDORA" THEN
			idw_other.SetTabOrder("user_field2",0)
		END IF

// Setting everything to taborder=0
      	i_nwarehouse.of_settab(idw_detail)
		i_nwarehouse.of_settab(idw_putaway)

//TAM W&S 05/25/2011  Unlock user_fields 5 & 6 after confirm for WS-AWI		
		IF gs_project = "WS-AWI" THEN
			idw_detail.SetTabOrder("user_field5", 100)
			idw_detail.SetTabOrder("user_field6", 110)
		END IF
		
// GXMOR Comcast 06/25/2012  Unlock supp_order_no after confirm for Cocmast
		IF UPPER(gs_project) = 'COMCAST' THEN
			idw_main.SetTabOrder("supp_order_no", 50)
		END IF

		//MStuart - BackOrder functionality
		If ( gs_role = '0' or gs_role = '-1')  AND g.isReceiptBackOrder = 'Y' Then
			tab_main.tabpage_main.cb_backorder.visible= True
			//MStuart - 090111
	   		 tab_main.tabpage_main.cb_address.x = 3095	
		End If
		
		If left(upper(gs_project), 2) =  'WS' then
			tab_main.tabpage_main.cb_custom1.enabled = true
		End IF 		

// SARUN2014MAY12 : WS-PR Inbound Export
		If upper(gs_project) =  'WS-PR' then
			tab_main.tabpage_main.cb_custom2.enabled = true
			tab_main.tabpage_main.cb_custom2.visible = true			
			idw_other.SetTabOrder("user_field13",230)		//SARUN2014JUNE12 available feild after convfirmation	
			idw_other.SetTabOrder("user_field15",234)
			
		End IF 		


		IF Left(gs_project,4) = "NIKE" THEN 
			tab_main.tabpage_main.cb_custom1.enabled = true
		END IF

		tab_main.tabpage_putaway.cb_putaway_locs.Enabled = False

		IF gs_project = "PANDORA" THEN
			tab_main.Tabpage_putaway.cbx_autofill.enabled = false
			tab_main.Tabpage_putaway.cbx_autofill.checked = false			
		END IF


	CASE "V" 
		
		im_menu.m_file.m_save.Enabled = False
		im_menu.m_file.m_retrieve.Enabled = False
//		im_menu.m_file.m_print.Enabled = False
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_orderdetail.Enabled = True
		tab_main.tabpage_putaway.Enabled = True
		tab_main.tabpage_orderdetail.cb_insert.enabled = False
		tab_main.tabpage_orderdetail.cb_delete.enabled = False	
		tab_main.tabpage_OrderDetail.cb_IQC.Enabled = False
		tab_main.tabpage_putaway.cb_deleterow.enabled = False	
		tab_main.tabpage_putaway.cb_Copyrow.enabled = False
		tab_main.tabpage_putaway.cb_insertrow.enabled = False	
		tab_main.tabpage_putaway.cb_generate.enabled = False	
		tab_main.tabpage_putaway.cb_print.enabled = False	
//		tab_main.tabpage_putaway.cb_asn.enabled = False
		tab_main.tabpage_putaway.cb_putaway_pallets.enabled = False  /* 12/01 - GMOR */
		tab_main.tabpage_main.cb_confirm.enabled = False
		tab_main.tabpage_main.cb_void.enabled = False
	
		tab_main.tabpage_rma_serial.Enabled = False /* 05/05 - PCONKL */
		tab_main.tabpage_other_info.enabled = false    /* 03/15 - GailM     */
		
      i_nwarehouse.of_settab(idw_main)
		
		idw_detail.SetTabOrder("sku", 0)
		idw_detail.SetTabOrder("alternate_sku", 0)
		// pvh - 09/09/05
		//idw_detail.SetTabOrder("country_of_origin", 0)
		idw_detail.SetTabOrder("req_qty", 0)
		idw_detail.SetTabOrder("uom", 0)
		idw_detail.SetTabOrder("cost", 0)
		idw_detail.SetTabOrder("user_field1",0)
		idw_detail.SetTabOrder("user_field2",0)
		idw_detail.SetTabOrder("user_field3",0)
		idw_detail.SetTabOrder("user_field4",0)
		
		idw_putaway.SetTabOrder("sku", 0)
		idw_putaway.SetTabOrder("l_code", 0)
		idw_putaway.SetTabOrder("inventory_type",0)
//		idw_putaway.SetTabOrder("serial_no", 0)
//		idw_putaway.SetTabOrder("lot_no", 0)
		idw_putaway.SetTabOrder("po_no2", 0)
		idw_putaway.SetTabOrder("container_ID", 0)
		idw_putaway.SetTabOrder("expiration_date", 0)
		idw_putaway.SetTabOrder("quantity", 0)
		idw_putaway.SetTabOrder("user_field1",0)
		idw_putaway.SetTabOrder("user_field2",0)
		idw_putaway.SetTabOrder("length", 0)
		idw_putaway.SetTabOrder("width", 0)
		idw_putaway.SetTabOrder("height", 0)
		idw_putaway.SetTabOrder("weight_Gross", 0)
		idw_putaway.SetTabOrder("user_field3",0)
		idw_putaway.SetTabOrder("user_field4",0)
		idw_putaway.SetTabOrder("user_field5",0)
		idw_putaway.SetTabOrder("user_field6",0)
		idw_putaway.SetTabOrder("user_field7",0)
		idw_putaway.SetTabOrder("user_field8",0)
		idw_putaway.SetTabOrder("user_field8", 0)
		idw_putaway.SetTabOrder("user_field9",0)
		idw_putaway.SetTabOrder("user_field10",0)
		idw_putaway.SetTabOrder("user_field11",0)		
		idw_putaway.SetTabOrder("user_field12",0)	

		IF Left(gs_project,4) = "NIKE" THEN 
			tab_main.tabpage_main.cb_custom1.enabled = false
		END IF
		
		
		If left(upper(gs_project), 2) =  'WS' then
			tab_main.tabpage_main.cb_custom1.enabled = false
		End IF 		
				
		tab_main.tabpage_putaway.cb_putaway_locs.Enabled = False

		// GailM 6/12/15 - disallow edit named fields
		idw_main.SetTaborder( "container_nbr", 0)
		idw_main.SetTaborder( "client_cust_po_nbr", 0)
		idw_main.SetTaborder( "container_type", 0)
		idw_main.SetTaborder( "client_order_type", 0)
		idw_main.SetTaborder( "from_wh_loc", 0)
		idw_main.SetTaborder( "client_invoice_nbr", 0)
		idw_main.SetTaborder( "seal_nbr", 0)
		idw_main.SetTaborder( "vendor_invoice_nbr", 0)
		
		
		IF gs_project = "PANDORA" THEN
			tab_main.Tabpage_putaway.cbx_autofill.enabled = false
			tab_main.Tabpage_putaway.cbx_autofill.checked = false			
		END IF

End Choose

// 10/16 - For Kendo, Don;t allow any changes to the detail tab for Kendo regardless of order status if an electronic order
If gs_project = 'KENDO' and idw_Main.GetITemNumber(1,'edi_batch_seq_no') > 0 Then
	
	tab_main.tabpage_orderDetail.dw_detail.Object.datawindow.ReadOnly = 'YES'
	tab_main.tabpage_orderdetail.cb_insert.enabled = False
	tab_main.tabpage_orderdetail.cb_delete.enabled = False	
	
End If
				
// 04/05 - PCONKL - Don't allow user to change warehouse if received electronically
// 7/2010 - or if warehouse transfer
If idw_Main.rowCount() > 0 Then
	
	If idw_Main.GetItemNumber(1,'edi_batch_seq_no') > 0 or idw_Main.GetItemString(1,'ord_type') = 'Z' Then
		
		//dts - 9/6/05 - Phxbrands needs ability to change wh_code for electronic orders...
		If gs_project <> 'PHXBRANDS' Then
			idw_Main.SetTabOrder("wh_Code",0)
		End If
		
		//dts - 05/01/08 - not allowing user to change order number for electronic orders...
		idw_Main.SetTabOrder("supp_invoice_no",0)
		
		//02/10 - FOr Warner, Disable Add delete buttons for electronic orders
		If gs_project = 'WARNER' Then
			tab_main.tabpage_orderdetail.cb_insert.enabled = False
			tab_main.tabpage_orderdetail.cb_delete.enabled = False
			//Jxlim 06/30/2010 Disable Detail Order dw for Warner on EDI- electronic orders.		
			idw_detail.object.datawindow.ReadOnly = "Yes"
			//Jxlim 06/30/2010 End of modified code for Warner.
		End If
		
	end if
	
End If

// Jxlim 07/16/2010 Enabled fields for Phoenix Brands
IF gs_project = "PHXBRANDS" THEN
			idw_other.SetTabOrder("user_field10",110)
			idw_other.SetTabOrder("user_field12",120)
			idw_other.SetTabOrder("user_field13",130)
END IF

// 10/02 - PConkl - Hide unused fields on Putaway
idw_putaway.TriggerEvent('ue_hide_unused')

// 11/02 - TAM - W&S - Hide unused fields on Detail
idw_detail.TriggerEvent('ue_hide_unused')

// 10/08 - PCONKL - reset any tab order set up for allowing scanner entry on Putaway
isScanColumn = ""
idw_putaway.TriggerEvent('ue_Scan_Mode')

//1/25/2011; David C; Allow supers users to reset the status if the order has been voided 
ls_Status = idw_Main.Object.ord_status[1]

if ( gs_role = "-1" or gs_role = "0" ) and ls_Status = "V" then
	idw_Main.SetTabOrder ( "ord_status", 10 )
else
	idw_Main.SetTabOrder ( "ord_status", 0 )
end if
		
IF gs_project = 'PANDORA' THEN
	IF idw_main.GetItemString(1,"ord_status") = 'C'  THEN
		wf_lock(true)
	ELSEIF idw_main.object.edi_batch_Seq_No[1] > 0  and upper( idw_main.GetItemString(1, "create_user" ))= 'SIMSFP'  THEN
		wf_lock(false)
	ELSE
		wf_lock(false)
	END IF

	//We need to lock this down regardless of type.
	//Still able to unlock using F10
	
	ls_dw_color = idw_main.object.datawindow.color
	idw_other.Object.user_field7.Protect = true
	idw_other.Modify("user_field7.Background.Color = '" +  ls_dw_color + "'")
	
//TAM 2009/12/16 - Allow PONO Change if manual order
//	//Protect Pandora Project
//	idw_putaway.Object.po_no.Protect = true
//	idw_putaway.Modify("po_no.Background.Color = '" +  ls_dw_color + "'")
	// 090909 - Can't change 'From Project' on detail if it's electronic or a WH xfer
	if Upper(idw_main.object.ord_type[1]) = 'Z' or idw_main.object.edi_batch_seq_no[1] > 0 then
		//messagebox("TEMP", string(idw_main.object.edi_batch_seq_no[1]))
		idw_detail.Object.user_field2.Protect = true //From Project on Detail
		//12/09/09 UJHALL Removed: part of no more entries in UF6 and UF8 at header level
		//idw_main.Object.user_field6.Protect = true //12/03/09 UJH Prevent Mod to "To Project"
	//TAM 2009/12/16 - Allow PONO Change if manual order
	//Protect Pandora Project
		idw_putaway.Object.po_no.Protect = true
		idw_other.Object.user_field2.Protect = true //Sub-inventory location - can only use it on manually-created orders.
	else
		idw_detail.Object.user_field2.Protect = false //From Project on Detail
		idw_other.Object.user_field2.Protect = false // Sub-INventory on Main  KRZ
		idw_other.SetTabOrder("user_field2", 20)	//gwm
	//TAM 2009/12/16 - Allow PONO Change if manual order
	//Unlock Pandora Project
		idw_putaway.Object.po_no.Protect = false
	end if
	
	/* 06/16/2014 - GailM - Issue 875 - Protect fields when inbound order is received electronically but allow F10 */
	/* 06/20/2014 - GailM - removed test for create_user */
	If (  idw_main.object.edi_batch_seq_no[1] <> 0  ) Then
		idw_detail.object.alternate_sku.Protect = true
		idw_detail.object.req_qty.Protect = true
		idw_detail.object.cost.Protect = true
		idw_detail.object.user_field1.Protect = true
	End If

	//GailM 07/03/2017 - SIMSPEVS-654 - PAN SIMS allow container/serial capture in 2D Barcode - BOX ID (Should this be a check on Client_Cust_PO_Nbr?)
	If left(idw_main.GetItemString(1,'supp_invoice_no'),1) = 'X' Then
		ibMIM = true
	Else
		ibMIM = false
	End If

	//GailM 5/29/2018 S19731 F8404 I1143 Google SIMS Prevent Line Deletion in order detail screen
	If (gs_role = '-1' or gs_role = '0')  Then
		tab_main.tabpage_orderdetail.cb_delete.enabled = True
	Else
		tab_main.tabpage_orderdetail.cb_delete.enabled = False
	End If

//	//Owner
//	idw_putaway.Object.c_owner_name.Protect = true
//	idw_putaway.Modify("c_owner_name.Background.Color = '" +  ls_dw_color + "'")
	
END IF	

//MStuart - BabyCare EMC Functionality - 083011
If upper(gs_project) = 'BABYCARE' Then
	wf_check_status_emc()
End If

//SARUN2016FEB10:RO_Open:Start
String lsStatus
lsStatus = idw_main.GetItemString(1,"ord_status")
//tab_main.tabpage_main.cb_open_do.visible=False				
IF idw_main.GetItemString(1,'ord_type') = 'Z' THEN
	if gs_project = 'PANDORA' then
		if lsStatus = 'D' OR lsStatus = 'C' then 
			tab_main.tabpage_main.cb_open_do.visible=True
			tab_main.tabpage_main.cb_open_do.bringtotop=True
			tab_main.tabpage_main.dw_main.bringtotop=false
		end if

	end if
END IF
//SARUN2016FEB10:RO_Open:End		

				
//06/15 - PCONKL
wf_check_status_Mobile()

Return
end subroutine

public function integer doaccepttext ();// int = doAcceptText()

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If

If idw_other.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_other.SetFocus()
	Return -1
End If

If idw_detail.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_detail.SetFocus()
	Return -1
End If

If idw_putaway.AcceptText() = -1 Then
	tab_main.SelectTab(4) 
	idw_putaway.SetFocus()
	Return -1
End If

If idw_rma_serial.AcceptText() = -1 Then
	Return -1
End If

return 0

end function

public function boolean doduplicateputawaycheck (long arow);// boolean doDuplicatePutawayCheck( arow )
//
// 11/30/05 - ro_no isn't set until a save, so it is null on an insertrow
//				  and removed from the test filter
//
string sku
string loc
string inventoryType
string serialnbr
string lot
string Supplier
string PO
string PO2
string COO
string containerid
string rono
string filterfor
boolean returnCode
decimal lineItemNbr
datetime ldtExpirationDate
string	ls_lot

returnCode = false

// Grab the data to test
sku = trim( idw_putaway.GetItemString( aRow, "sku"))
loc = trim( idw_putaway.GetItemString( aRow, "l_code"))
inventoryType = trim( idw_putaway.GetItemString( aRow, "inventory_type"))
serialnbr = trim( idw_putaway.GetItemString( aRow, "serial_no"))
lot = trim( idw_putaway.GetItemString( aRow, "lot_no"))
po = trim( idw_putaway.GetItemString( aRow, "po_no"))
po2 = trim( idw_putaway.GetItemString( aRow, "po_no2"))
supplier = trim( idw_putaway.GetItemString( aRow, "supp_code"))
COO = trim( idw_putaway.object.country_of_origin[ aRow ] )
lineItemNbr = idw_putaway.object.line_item_no[ aRow ]

// pvh 11/30/05
//rono = idw_putaway.object.ro_no[ aRow ]
containerid = idw_putaway.object.container_id[ aRow ]
ldtExpirationDate = idw_putaway.object.expiration_date[ aRow ]

// pvh 11/30/05 - can't have nulls
if isnull(serialnbr ) then serialnbr = '-'
if isnull( lot ) then lot = '-'
if isnull( po ) then po = '-'
if isnull( po2 ) then po2 = '-'
if isnull( containerid ) then containerid = '-'
if isnull(inventoryType ) then inventoryType = '-'
if isnull( supplier ) then supplier = '-'
if isnull( COO ) then COO = '-'

// cawikholm - 06/23/11 Add a tilde in front of ' for lot_no
IF Pos( lot, "'", 1 ) > 0 THEN 
	
	ls_lot = f_string_replace( lot, "'", "*")		// Replace ' with *
	lot = f_string_replace( ls_lot, "*", "~~'" )	// Now replace the * with a ~'
	
END IF

// build the filter string
filterFor = "Trim(sku) = ~'" + sku + "~' and  Trim(l_code)  = ~'" + loc + "~' and Trim(inventory_type) = ~'" +  inventoryType + "~'"
filterFor += " and serial_no = ~'" + serialnbr + "~' and lot_no = ~'" + lot + "~' and po_no = ~'" + po + "~'"
filterFor += " and po_no2 = ~'" + po2 + "~' and supp_code = ~'" + supplier + "~'"
filterFor += " and country_of_origin = ~'" + COO + "~'"
filterFor += " and line_item_no = " +String(  lineItemNbr )
//OCT 2019 - MikeA - DE12998 - Need to account for blank container id. 
if containerid = '-' then
	filterFor += " and (container_id = ~'" +String(  containerid ) + "~' or container_id = ~'~') "
else
	filterFor += " and container_id = ~'" +String(  containerid ) + "~'"
end if
filterFor += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldtExpirationDate,'mm/dd/yyyy hh:mm')  + "~'"
//filterFor += " and ro_no = ~'" + rono + "~'"

//idw_putaway.setredraw( false )

idw_putaway.setfilter( filterFor )
idw_putaway.filter()

long testRow
testRow = idw_putaway.rowcount()

if idw_putaway.rowcount() > 1 then returnCode = true

idw_putaway.setfilter("")
idw_putaway.filter()

//idw_putaway.setredraw( true )

return returnCode




end function

public function integer getmaxlineitemnumber (ref datawindow _dw, string _colname);// int = getMaxlineitemnumber( ref datawindow _dw, string _colname )

int index
int max
int value
int maxValue
decimal  test

max = _dw.rowcount()
value = 0
maxValue = 0
for index = 1 to max
	test = _dw.getItemNumber( index, _colname )
	value = integer( test )
	if value > maxvalue then maxValue = value
next
return maxValue


end function

public function integer getrlskulistcount ();// integer = getRLSkuListCount()

// return the number of items in the RLSkuList

int count

count = UpperBound( isRLSkuList )
if isNull( count ) or count < 0 then count = 0

return count

end function

public function integer domarlcheck ();// integer = doMARLCheck( )

/*
From requirements document

4.2.1.	If the MARL on the item master for an item being received on a return order is not blank, SIMS should prompt for a scan of the RL (revision level). 
			This data might be scan-able but might need to be manually entered based upon the product or over ridden by the operator.

Get the list of skus needing RL Values and pass them to the scan window
Set the inventory Type based on the returned values in the datawindow
			
*/
if getMARLListCount() <=0 then return 0

istrparms = getRLSkuList()
int index,max
long skuIndex
max = UpperBound( istrparms.string_arg )
for index = 1 to max
	skuIndex = getIndexforSku( istrparms.string_arg[ index ] )
	if skuIndex > UpperBound( isRLSkuMarl ) then
		istrparms.string_arg[ index ] = ''
		continue
	end if
	if isValidMarl( isRLSkuMARL[ skuIndex ] ) then continue
	istrparms.string_arg[ index ] = ''
next

openwithparm( w_3com_rl_scan, istrparms )
istrparms = message.powerobjectparm
if isNull( istrparms.Cancelled ) then return 0
if istrparms.Cancelled then return 0
if UpperBound( istrparms.datastore_arg ) > 0 then
	idsRLScan = istrparms.datastore_arg[1]
	return one
end if

return success



end function

public function str_parms getrlskulist ();// string = getRLSkuList()
str_parms parms

parms.string_arg = isRLSkuList

return parms

end function

public function integer getindexforsku (string _sku);// integer = getIndexForSKU( string _sku )

int max
int index
int returnIndex

max = getRLSkuListCount()

returnIndex = 0

for index = 1 to max
	if isRLSkuList[ index ] = _sku then
		returnIndex = index
		exit
	end if
next

return returnIndex

end function

public function integer dorlvalidate ();// integer = dorlvalidate(  )

/*
if Quality Hold Flag then set inventory_type = 'HOLD'
if RL is less than MARL, set inventory type = 'OBSOLETE'

*/

string onHold = 'H'
string Obsolete = 'O'
string whatever = '*'

int index
int max
int listIndex
int putindex
int putrows

string sku
string rl
string qualityflag
string MARL
string InventoryType
boolean foundError
string msg

max = idsRLScan.rowcount()
putrows = idw_putaway.rowcount()

for index = 1 to max
	
	// get the values, check for override
	sku = idsRLScan.object.sku[ index ]
	rl = idsRLScan.object.rl[ index ]
	if Trim( Upper ( rl )) = Trim( Upper ( sku )) then continue
	// get the sku index, qualityholdflag and MARL
	listindex = getIndexForSKU( sku )
	if listindex = 0 then continue
	if listIndex <= UpperBound( isRlSkuMarl ) then
		MARL = isRlSkuMarl[ listindex ]
	else
		continue
	end if
	
	// Determine Inventory Type
	inventoryType = whatever
	if rl < MARL then InventoryType = Obsolete
	if inventoryType = whatever then continue
	msg = "RL is less than MARL, Inventory Type should be ~'OBSOLETE~'"
	// test the putaway inventory type
	for putindex = 1 to putrows
		if idw_putaway.object.sku[ putIndex ] = sku then
			if idw_putaway.object.inventory_type[ putIndex ] <> inventoryType then
				foundError = true
				exit
			end if
		end if
	next
	if foundError then exit
next
if foundError then
	messagebox( "3COM RL Scan","Invalid Inventory Type for SKU" + sku + "~r~n" + msg , exclamation! )
	return -1
end if

if doQualityHoldValidate() < 0 then return -1

return 0

end function

public subroutine setinventorytype ();// integer = setInventoryType(  )

/*
From requirements document...

4.2.2.1.	If the RL is at or above the MARL (if it$$HEX1$$1920$$ENDHEX$$s not blanks on the master file) and the item is not on hold, do nothing, normal processing.

4.2.2.2.	If the item is below MARL, the message should state that the product is obsolete and must be put away as OBSOLETE inventory.

4.2.2.3.	If the item is on quality hold the message should state that there are quality issues and the product must be put away as HOLD inventory.
4.2.2.4.	If the item is both below MARL and on HOLD, enforce the MARL procedure and display the message that it must be put away as OBSOLETE
4.2.3.	Enforce the inventory type per the above at inventory put-away rather than using RETURNS

The datawindow passed in contains the scanned rl value and the override setting.

get the sku and RL or override from the datawindow

Find the index for the sku by searching rlSkulist
get the quality hold flag
when done, set the inventory type based on the rules...

if override flag then do nothing

if Quality Hold Flag then set inventory_type = 'HOLD'
if RL is less than MARL, set inventory type = 'OBSOLETE'

*/
constant string Obsolete = 'O'
constant string whatever = '*'

int index
int max
int listIndex
int putindex
int putrows

long strIndex
string sku
string rl
string qualityflag
string MARL
string InventoryType
string oldInvType

max = idsRLScan.rowcount()
if max <= 0 then return // nothing to do

putrows = idw_putaway.rowcount()

for index = 1 to max
	
	// get the values, check for override
	sku = idsRLScan.object.sku[ index ]
	rl = idsRLScan.object.rl[ index ]
	// if they didn't have a marl, they are to scan a sku....bypass requirement.
	if trim( Upper( rl )  ) = trim( Upper( sku ) ) then continue
	if isNull( rl ) or len( rl ) = 0 then continue
	// get the sku index, MARL
	listindex = getIndexForSKU( sku )
	if listIndex <= UpperBound( isRLSkuMarl ) then
		MARL = isRLSkuMARL[ listindex ]
	else
		continue
	end if
	
	// Determine Inventory Type
	inventoryType = whatever
	if len( MARL ) > 0 and MARL > rl then	InventoryType = Obsolete
	
	if inventoryType = whatever then continue
	
	// Set The Inventory Type
	idw_putaway.setredraw( false )
	for putindex = 1 to putrows
		if idw_putaway.object.sku[ putIndex ] = sku then
			oldInvType = idw_putaway.object.inventory_type[ putIndex ]
			idw_putaway.object.inventory_type[ putIndex ] = inventoryType
			doAdjustmentWork( putIndex, oldInvType, inventoryType, MARLAdjustReason )
		end if	
	next
	idw_putaway.setredraw( true )
next

return 

end subroutine

public subroutine setrlskulist ();// integer = setRLSkuList(  )

long	itemRow
integer returnCode
string invMARL
string invQualityHoldFlag
long putawayRows
string _sku
long index
string _supplier

putawayRows = idw_putaway.rowcount()
for index = 1 to putawayRows
	_sku = idw_putaway.object.sku[ index ]
	_supplier = idw_putaway.object.supp_code[ index ]
	itemRow =  getInventoryItem( _sku, _supplier )
	
	if itemRow < 0 then continue 
	
	setRLSkuArray( _sku )
	
	setQualityHoldArray( _sku, itemRow )
	
	if idsItemMaster.object.grp[ itemRow ] = 'B' then continue // no bundles parents
	
	invMARL =Trim( Upper( idsItemMaster.object.MARL[ itemRow ] ) )
	
	if isNull( invMARL ) or len(invMARL ) = 0 then continue
	if NOT isValidMARL( invMARL ) then continue

	setMARLArray(  _sku,  invQualityHoldFlag, invMARL )
	
next

return


end subroutine

public function boolean isvalidmarl (string _marl);// boolean = isValidMARL( string _marl )

// so far invalid MARL values are 'XX' and blank/null
/*
	03-17-06 - MARL MUST BE ALPHA CHARACTERS, WITH A MAX LENGTH OF 2
*/


if _marl = 'XX' then return false
if Trim( _marl ) = '' then return false
if isNull( _marl ) then return false
if Match( _marl, "[0-9]") then return false
if  Match( _marl, "[A-Z][A-Z]" ) then
	return true
else
	return false
end if


end function

public subroutine setqualityholdarray (string _sku, long _itemrow);// setQualityHoldArray()
// 

string invQualityHoldFlag
long index
int max
boolean foundit

invQualityHoldFlag = idsItemMaster.object.QUALITYHOLD[ _itemRow ]
if isNull( invQualityHoldFlag ) or len( invQualityHoldFlag ) = 0 then invQualityHoldFlag = 'N'

max = getRLSkuListCount()

if max = 0 then
	isQualityHoldFlag[ 1 ] = invQualityHoldFlag
	return
end if

for index = 1 to max
	if isRLSkuList[ index ] = _sku then
		foundit = true
		exit
	end if
next
if foundit then
	isQualityHoldFlag[ index ] = invQualityHoldFlag
	return
end if
max++
isQualityHoldFlag[ max ] = invQualityHoldFlag



end subroutine

public subroutine setmarlarray (string _sku, string _qualityholdflag, string _marl);// setMARLArray( string sku, string _qualityHoldFlag, string _MARL )

int index
int max
boolean foundit

max = getRLSkuListCount()
if max = 0 then
	isRLSkuMARL[ 1 ] = _MARL
	return
end if

for index = 1 to max
	if isRLSkuList[ index ] = _sku then
		foundit = true
		isRLSkuMARL[ index ] = _MARL
		exit
	end if
next

if foundit then return  // already in the list
max++
isRLSkuMARL[ max ] = _MARL
end subroutine

public function integer getmarllistcount ();// int = getMARLListCount()

return upperBound( isRLSkuMARL )

end function

public subroutine setqualityholdrows ();// setQualityHoldRows()

string onHold = 'H'
string whatever = '*'

int index
int max
int putindex
int putrows
string sku
string qualityflag
string InventoryType

putrows = idw_putaway.rowcount()
max = UpperBound( isQualityHoldFlag )

for index = 1 to max
	// get the sku index, qualityholdflag
	sku = isRLSkuList[ index ]
	qualityflag = isQualityHoldFlag[ index ]
	// Determine Inventory Type
	inventoryType = whatever
	if Upper( left( qualityflag , 1 ) ) = 'Y'  then InventoryType = onHold
	if inventoryType = whatever then continue
	// Set The Inventory Type
	idw_putaway.setredraw( false )
	for putindex = 1 to putrows
		if idw_putaway.object.sku[ putIndex ] = sku then
			idw_putaway.object.inventory_type[ putIndex ] = inventoryType
			doAdjustmentWork( putIndex, idw_putaway.object.inventory_type[ putIndex ], inventoryType,MARLAdjustReason )
		end if
	next
	idw_putaway.setredraw( true )
next

return 

end subroutine

public function integer doqualityholdvalidate ();// integer = doQualityHoldValidate()

string onHold = 'H'
string whatever = '*'
string Obsolete = 'O'
int index
int max
int putindex
int putrows
boolean founderror
string sku
string qualityflag
string InventoryType
string lineItemNo

putrows = idw_putaway.rowcount()
max = UpperBound( isQualityHoldFlag )

for index = 1 to max
	// get the sku index, qualityholdflag
	sku = isRLSkuList[ index ]
	qualityflag = isQualityHoldFlag[ index ]
	// Determine Inventory Type
	inventoryType = whatever
	if Upper( left( qualityflag , 1 ) ) = 'Y'  then InventoryType = onHold
	if inventoryType = whatever then continue
	// check the Inventory Type
	for putindex = 1 to putrows
		if idw_putaway.object.sku[ putIndex ] <>  sku then continue
		lineItemNo = string( idw_putaway.object.line_item_no[ putIndex ]  )
		if idw_putaway.object.inventory_type[ putIndex ] <>  inventoryType AND &
			idw_putaway.object.inventory_type[ putIndex ] <>  Obsolete  then
			founderror = true
			exit
		end if
	next
	if foundError then exit
next
if foundError then 
	messagebox("Sku " + sku + " is on Quality Hold", "Sku " + sku + " on Line Item No: "  +lineItemNo+ " is on Quality Hold, Inventory Type must be ~"HOLD~"",stopsign! )
	return -1
end if
return 0

end function

public subroutine setrlskuarray (string _sku);// setRLskuarray( string _sku )

int index
int max
boolean foundit

max = getRLSkuListCount()
if max = 0 then
	isRLSkuList[ 1 ] = _sku
	max = 1
end if

for index = 1 to max
	if isRLSkuList[ index ] = _sku then
		foundit = true
		exit
	end if
next

if foundit then return  // already in the list
max++
isRLSkuList[ max ] = _sku

end subroutine

public function integer wf_set_supplier_visibility ();
//Supplier visibility on Detail and Putaway tabs is dependant on indicator on Receive_order_type

If idw_main.RowCount() < 1 Then Return 0

If idw_main.GetITemString(1,'multiple_supplier_ind') = 'Y' Then
	idw_detail.Modify("supp_code.width=311 supp_code_t.width=311")
	idw_putaway.Modify("supp_code.width=311 supp_code_t.width=311")
Else
	idw_detail.Modify("supp_code.width=0")
	//idw_detail.Modify("supp_code.visible=0")
	idw_Putaway.Modify("supp_code.width=0")
	//idw_Putaway.Modify("supp_code.visible=0")
End If

Return 0
end function

public function integer setedibatchno (string _tablename);// setEDIBatchNo()

decimal ldNexSeq
long llCount
string lsColumn = 'EDI_Batch_Seq_No'

Execute Immediate "Begin Transaction" using SQLCA; 

sqlca.sp_next_avail_seq_no(gs_project, _tablename ,lsColumn,ldNexSeq)
If SQLca.SQLCode < 0 Then
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
	return failure
End If

If ldNexSeq <=0 Then
	
	//See if it already exists, if so that's not the problem. If not, add it
	Select Count(*) into :llCount
	From next_sequence_no
	Where Project_id = :gs_project and table_name = :_tablename and column_name = :lsColumn;
	If llCount > 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
	return failure

		
Else /* insert a new row and try again*/
		
		insert Into Next_Sequence_NO
			(project_id, table_name, column_Name, Next_Avail_seq_no)
			Values (:gs_project, :_tablename, :lsColumn, 1);
			
		Execute Immediate "COMMIT" using SQLCA;
		
		sqlca.sp_next_avail_seq_no(gs_project,_tablename,lsColumn,ldNexSeq)
		If SQLca.SQLCode < 0 Then
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("System Error","Unable to retrieve the Next Available Batch Seq No.")
			return failure
		End If
	End If /*Row not found */
End If

Execute Immediate "COMMIT" using SQLCA;

ilEdiBatchNo = Long( ldNexSeq )

Return success




end function

public function long getedibatchno ();// long = getEdiBatchNo()
return ilEdiBatchNo

end function

public function integer getediorderseq ();// int = getEdiOrderSeq()
return ilEdiOrderSeq
end function

public subroutine setediorderseq ();// setEdiOrderSeq(  )

long seq

seq = getEdiOrderSeq()
if isNull( seq ) then seq = 0

seq++

ilEdiOrderSeq = seq
 
 
end subroutine

public subroutine setedilineno (integer _value);// setEdiLineNo( int _value )
ilEdiOrderLineNo = _value

end subroutine

public subroutine setedilineno ();// setEdiLineNo(  )
int seq

seq = getEdiLineNo()
if isNull( seq ) then seq = 0

seq++
ilEdiOrderLineNo = seq

end subroutine

public function integer getedilineno ();// int = getEdiLineNo()
return ilEdiOrderLineNo

end function

public function integer doedidetail (long _index, long _lineitemno);// integer = doEDIDetail( long _index )

string 		lsSku
string 		lsSupplier
string 		lsErrText
string 		coo
long	 		llOwner
long 			ediBatchNo
string		lot
string 		po
int				seq
int				_line
decimal		dqty
datetime 	dtexp
string		serialNumber
long 			insertRow

ediBatchNo = getEDIBatchNo()
seq = getEdiOrderSeq()
_line = getEdiLineNo()

serialNumber 	= Trim(idw_putaway.object.serial_no[ _index ] )
lsSku		 		= Trim(idw_putaway.object.sku[ _index ] )
lsSupplier 			= Trim(idw_putaway.object.supp_code[ _index ] )
llOwner 			= Long( idw_putaway.object.owner_id[ _index ]  )
coo					= Trim(idw_putaway.object.country_of_origin[ _index ] )
lot						= Trim(idw_putaway.object.lot_no[ _index ] )
po						= Trim(idw_putaway.object.po_no[ _index ] )
dqty					= dec( idw_putaway.object.quantity[ _index ] )
dtexp				=  idw_putaway.object.expiration_date[ _index ]

insertRow = idsEdiBatchDetail.insertRow( 0 )

if getEdiDirection() = isEDIOut then
	idsEdiBatchDetail.object.project_id[ insertRow ] = gs_project
	idsEdiBatchDetail.object.EDI_batch_seq_no[ insertRow ] = ediBatchNo
	idsEdiBatchDetail.object.Order_seq_no[ insertRow ] = seq
	idsEdiBatchDetail.object.Order_Line_No[ insertRow ] = string( _line )
	idsEdiBatchDetail.object.sku[ insertRow ] = lsSku
	idsEdiBatchDetail.object.Supp_Code[ insertRow ] = lsSupplier
	idsEdiBatchDetail.object.Owner_id[ insertRow ] = String( llOwner )
	idsEdiBatchDetail.object.Country_of_Origin[ insertRow ] = coo
	idsEdiBatchDetail.object.Serial_No[ insertRow ] = serialNumber
	idsEdiBatchDetail.object.lot_no[ insertRow ] = lot
	idsEdiBatchDetail.object.po_no[ insertRow ] = po
	idsEdiBatchDetail.object.Line_Item_No[ insertRow ] = _lineitemno
	idsEdiBatchDetail.object.quantity[ insertRow ] = String( dqty )
	idsEdiBatchDetail.object.expiration_date[ insertRow ] = dtexp
else
	idsEdiBatchDetail.object.project_id[ insertRow ] = gs_project
	idsEdiBatchDetail.object.EDI_batch_seq_no[ insertRow ] = ediBatchNo
	idsEdiBatchDetail.object.Order_seq_no[ insertRow ] = seq
	idsEdiBatchDetail.object.Order_line_no[ insertRow ] = _line
end if

return success


end function

public subroutine setedibatchheader ();// setEdiBatchHeader( long putawayRow )

long ediBatchNo
int seq
string lserrtext
long	insertRow

if setEdiBatchNo( getEdiDirection() ) = failure then return 
ediBatchNo = getEDIBatchNo()

// add the edi batch number to idw_main
idw_main.object.EDI_Batch_Seq_No[ idw_main.getrow() ] = ediBatchNo

// set the batch sequence number
setEdiOrderSeq()
seq = getEdiOrderSeq()

// insert the edi header
insertRow = idsEdiBatchHead.insertRow( 0 )
if getEdiDirection() = isEDIOut then
	idsEdiBatchHead.object.Project_ID[ insertRow ] = gs_project
	idsEdiBatchHead.object.EDI_Batch_Seq_No[ insertRow ] = ediBatchNo
	idsEdiBatchHead.object.Order_Seq_No[ insertRow ] = seq
	idsEdiBatchHead.object.status_cd[ insertRow ] = 'C' // 10/11/06 - changed from 'N'
else
	idsEdiBatchHead.object.Project_ID[ insertRow ] = gs_project
	idsEdiBatchHead.object.status_cd[ insertRow ] = 'C' // 10/11/06 - changed from 'N'
end if

return

end subroutine

public subroutine setedibatchdetail (long putawayrow);// setEdiBatchDetail( long putawayRow )

int lineItemNumber

lineItemNumber = idw_putaway.object.line_item_no[ putawayrow ]

setEdiLineNo(  )

doEDIDetail( putawayrow,lineItemNumber ) 

return

end subroutine

public subroutine setedidirection (string value);// setEdiDirection()

isEdiDirection = value

if isEdiDirection = isEDIOut then
	idsEdiBatchHead = f_datastoreFactory( "d_edi_batch_trans_out_header" )
	idsEdiBatchDetail = f_datastoreFactory( "d_edi_batch_trans_out_detail" )
else
	idsEdiBatchHead = f_datastoreFactory( "d_edi_batch_trans_in_header" )
	idsEdiBatchDetail = f_datastoreFactory( "d_edi_batch_trans_in_detail" )
end if

end subroutine

public function string getedidirection ();// string = getEDIDirection()
return isEdiDirection

end function

public subroutine setupdateedi (boolean value);ibUpdateEdi = value

end subroutine

public function boolean getupdateedi ();return ibUpdateEdi

end function

public subroutine doclearadjustments ();// doClearAdjustments()

// clear the adjustments created for 3com Marl changes

long index
long max

max = idsmarladjustment.rowcount()
if max > 0 then
	for index =  max to 1 step -1
		idsmarladjustment.deleteRow( index )
	next
end if



	
end subroutine

public function boolean getadjustmentexists (long putawayrow);// boolean getAdjustmentExists( long putawayRow )

string findthis
long foundit
boolean exists
string lineitemno

lineitemno = String( idw_putaway.object.line_item_no[ putawayRow ] )

findthis = "ref_no = '" + lineitemno + "'"
foundit = idsmarladjustment.find( findthis, 1, idsmarladjustment.rowcount() )
if foundit > 0 then 
	exists = true
	setAdjustmentRow( foundit )
end if

return exists

end function

public subroutine docreatebatchtrans ();// doCreateBatchTrans()

// loop through the adjustments datastore and create the batch transactions

long index, max
string  MarlAdjustmentKey
datetime ldtToday
string stupidpowerbuilder

stupidpowerbuilder = MARLAdjustReason // can't use a read only variable in an insert statement...stupid.

// re-retrieve the adjustments...they will have the trans id we need
max = idsmarladjustment.retrieve( gs_project, idw_main.object.ro_no[ 1 ] )
if max <= 0 then return

ldtToday = f_getLocalWorldTime( idw_main.object.wh_code[1] ) // we want a consistant timestamp

for index = 1 to max
	MarlAdjustmentKey = String ( idsmarladjustment.object.adjust_no[ index ] )
	Execute Immediate "Begin Transaction" using SQLCA; 
			Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
											Values(:gs_Project, 'MM', :MarlAdjustmentKey,'N', :ldtToday, :stupidpowerbuilder )
			Using SQLCA;
	Execute Immediate "COMMIT" using SQLCA;

next

end subroutine

public function long getnewadjustmentrow ();// long = getNewAdjustmentRow()
return idsmarladjustment.insertRow( 0 )

end function

public function integer getadjustments ();// getAdjustments()

long index, max
string oldinvtype, newInvtype
long putIndex
long adjustid

// get any adjustments created for 3com MARL changes

if idsmarladjustment.retrieve( gs_project, is_rono ) <= 0 then return failure
return success

end function

public subroutine setadjustmentrow (long value);ilAdjustmentRow = value

end subroutine

public function long getadjustmentrow ();return ilAdjustmentRow
end function

public function boolean isskubundled (string _sku, string _supplier);// boolean isSKUbundled( string _sku, string _supplier )

long 	itemRow 

itemRow = idsItemMaster.retrieve( gs_project, _sku, _supplier )
if itemRow <=0 then return false

if idsItemMaster.object.grp[ itemRow ] = 'B' then return true

return false


end function

public function long getinventoryitem (string _sku, string _supplier);// integer = getInventoryItem( _sku, _supplier )

long itemRow

itemRow = idsItemMaster.retrieve( gs_project, _sku, _supplier )
if itemRow < 0 then
	return -1
else
	return itemrow
end if
 

end function

public subroutine doresetarrays ();// doResetArrays()

// initialize the MARL arrays

string isEmpty[]

isRLSkuList  = isEmpty
isQualityHoldFlag = isEmpty
isRLSkuMARL =isEmpty


end subroutine

public function integer doadjustmentwork (long arow, string oldtype, string newtype, string reason);// integer = doAdjustmentWork( long aRow, string oldType, string newType, string reason )

long index
long strIndex
long updateRow

if getAdjustmentExists( aRow ) then
	updateRow = getAdjustmentRow(  )
else
	updateRow = getNewAdjustmentRow( )
end if

return setAdjustmentRecord( updateRow, aRow,OldType, newType, reason )

end function

public function integer setadjustmentrecord (long workingrow, long putawayrow, string oldinv, string newinv, string reason);// integer = setAdjustmentRecord( long workingRow, long putawayRow, string oldInv, string newInv )
idsmarladjustment.object.project_id[ workingRow ] 					= gs_project
idsmarladjustment.object.sku[ workingRow ] 							= idw_putaway.object.sku[ putawayRow ]
idsmarladjustment.object.supp_code[ workingRow ] 				= idw_putaway.object.supp_code[ putawayRow ]
idsmarladjustment.object.owner_id[ workingRow ] 					= ii3comOwner
idsmarladjustment.object.old_owner[ workingRow ] 					= ii3comOwner
idsmarladjustment.object.country_of_origin[ workingRow ] 		= idw_putaway.object.country_of_origin[ putawayRow ]
idsmarladjustment.object.old_country_of_origin[ workingRow ] 	= idw_putaway.object.country_of_origin[ putawayRow ]
idsmarladjustment.object.wh_code[ workingRow ] 					= idw_main.object.wh_code[ 1 ]
idsmarladjustment.object.l_code[ workingRow ] 						= idw_putaway.object.l_code[ putawayRow ]
idsmarladjustment.object.old_inventory_type[ workingRow ] 		= 'R'  // they are always returns
idsmarladjustment.object.inventory_type[ workingRow ] 			= newinv
idsmarladjustment.object.serial_no[ workingRow ] 					= idw_putaway.object.serial_no[ putawayRow ]
idsmarladjustment.object.lot_no[ workingRow ] 						= idw_putaway.object.lot_no[ putawayRow ]
idsmarladjustment.object.ro_no[ workingRow ] 						= idw_main.object.ro_no[ 1 ]
idsmarladjustment.object.po_no[ workingRow ] 						= idw_putaway.object.po_no[ putawayRow ]
idsmarladjustment.object.po_no2[ workingRow ] 						= idw_putaway.object.po_no2[ putawayRow ]
idsmarladjustment.object.old_po_no2[ workingRow ] 				= idw_putaway.object.po_no2[ putawayRow ]
idsmarladjustment.object.old_quantity[ workingRow ] 				= idw_putaway.object.quantity[ putawayRow ]
idsmarladjustment.object.quantity[ workingRow ] 						= idw_putaway.object.quantity[ putawayRow ]
idsmarladjustment.object.ref_no[ workingRow ] 						= String( idw_putaway.object.line_item_no[ putawayRow ] )
idsmarladjustment.object.reason[ workingRow ] 						= reason
idsmarladjustment.object.last_user[ workingRow ] 					= gs_userid
idsmarladjustment.object.last_update[ workingRow ] 				= f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
idsmarladjustment.object.container_id[ workingRow ] 				= idw_putaway.object.container_id[ putawayRow ]
idsmarladjustment.object.expiration_date[ workingRow ] 			= idw_putaway.object.expiration_date[ putawayRow ]
idsmarladjustment.object.adjustment_type[ workingRow ] 			= 'I'
return success

end function

public subroutine dodeleteadjustmentrow (string theline, string thesku);// doDeleteAdjustmentRow( string theline, string thesku )

string findthis
long foundrow

findthis = "ref_no = '" + theline + "' and sku = '" + thesku + "'"
foundrow = idsmarladjustment.find( findthis,1,idsmarladjustment.rowcount() )
if foundrow > 0 then idsmarladjustment.deleteRow( foundrow )

return


end subroutine

public subroutine dodisplaymessage (string _title, string _message);// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function integer wf_coo_validation (datawindow adw_serial, integer al_row);
////Validate COO and serial prefix for 3COM Only
//
//String lsSKU, lsSupplier, lsProcType, lsSerialNo, lsFind, ls_null, ls_carton, ls_coo
//long llFindRow ,ll_desg_find
//SetNull(ls_null)
//
//adw_serial.AcceptText()
//
//lsSKU = adw_serial.object.sku[al_row]
//lsSupplier = adw_serial.object.supp_code[al_row]
//lsProcType=trim(upper(adw_serial.object.item_master_user_field4[al_row]))
//
//IF lsProcType <> 'BCC' and lsProcType <> 'BNC' THEN Return 0
//
////Check for Carton scan or SKU Scan
//lsSerialNo= upper(adw_serial.object.serial_no[al_row])
//IF NOT ISNULL(lsSerialNo) THEN
//		
//	IF mid(lsSerialNo,1,1) <> 'C' and mid(lsSerialNo,1,1) <> 'M' and &
//		mid(lsSerialNo,1,1) <> 'A' and mid(lsSerialNo,1,1) <> 'P' and mid(lsSerialNo,1,1) <> '3' THEN /* 07/04 - PCONKL - added A,P,3 to exclusion list */
//				
//			lsFind = "serial_division = '" + mid(lsSerialNo,1,1) + "' and serial_supplier= '" + mid(lsSerialNo,4,1) + "'"
//			ll_desg_find = g.ids_coo_translate.Find(lsFind,1,g.ids_coo_translate.RowCount())
//			IF  ll_desg_find < 1 THEN
//				
//				doDisplayMessage(This.title,lsSerialNo + " Does not have a valid COO match.")
//				adw_serial.object.serial_no[al_row] = "-"
//				adw_serial.POST ScrollTORow(al_row)
//				adw_serial.POST Setcolumn('serial_no')
//				Return -1
//					
//			END IF
//			
//			lsFind = "prefix = '" + mid(lsSerialNo,1,3) + "' and SKU='" + lsSKU + "' and supp_code='" + lsSupplier + "'"
//			IF g.ids_item_serial_prefix.Find(lsFind,1, g.ids_item_serial_prefix.RowCount()) < 1	THEN 	
//				
//				doDisplayMessage(This.title,lsSerialNo + " is not a valid Serial number for part " +lsSKU)
//				adw_serial.object.serial_no[al_row] = "-"
//				adw_serial.POST ScrollTORow(al_row)
//				adw_serial.POST Setcolumn('serial_no')
//				Return -1
//				
//			END IF	
//			
//	ELSE	/*Carton Scan*/
//		
//		Return 0
//		
//	END IF	
//	
//END IF
//	
////Update the COO on the Serial Tab if different then IM Default
//If ll_desg_find > 0 THEN
//	
//	ls_coo= g.ids_coo_translate.object.Designating_Code[ll_desg_find]
//	lsFind =  "iso_country_cd = '" + ls_coo + "'"	
//	llFindRow= g.ids_Country.Find(lsFind,1,g.ids_Country.RowCount())
//	If llFindRow > 0 Then
//		ls_coo=g.ids_Country.object.Designating_Code[llFindRow]
//		adw_serial.SetItem(al_row,'country_of_Origin',ls_Coo)
//	End If
//	
//	
//End If

Return 1




end function

public function integer wf_check_warranty (datawindow adw_serial, string as_sku, string as_supp_code, string as_serial, long al_findrow);string  ls_fru_sku, ls_inv_type
integer li_warranty_length
datetime ldt_Week_Start_Date, ldt_week_End_Date
date  ldt_warranty_date
string ls_week_code, ls_note, ls_uf4
string ls_under_warranty = "N"
boolean ib_check_fru = false
string ls_ord_type, ls_serialized_ind
	
ls_ord_type = idw_main.GetItemString(1, "ord_type")
	
if ls_ord_type <>  'M'  then return 0

if al_findrow = 0 then return 0

//QBNA	V	HOLD (GLS)	Nashville	Warranty Screening only (no FRU)
//QEIN 	V	HOLD (GLS)	Eersel	Warranty Screening only (no FRU)
//RBNA 	P	SPOR (GLS)	Nashville	Warranty and FRU Screening
//

 ls_inv_type = adw_serial.GetItemString(al_findrow , "inventory_type")

choose case Upper(ls_inv_type)
	case "V"
		
	case "P"
		ib_check_fru = true
	case else
		Return 0 //No checking needed.
end choose


//SC1.2.2.1.	Validate serialization by ensuring that the process type for the SKU in the item master is either BCC or BNC and that Outbound serialization is indicated

//and user_field4 = 'BCC' OR user_field4 = 'BNC'

//O

SELECT user_field4, serialized_ind INTO :ls_uf4, :ls_serialized_ind
	FROM item_master
	WHERE project_id = :gs_project AND
				sku = :as_sku AND
				supp_code = :as_supp_code USING SQLCA;


IF SQLCA.SQLCode = 100 THEN
	
	MessageBox ("Error", "SKU not valid.")
	RETURN -1	
END IF


IF Not (ls_uf4 = 'BCC' OR ls_uf4 = 'BNC')  OR (IsNull(ls_serialized_ind) OR  ls_serialized_ind <> 'O')  THEN 
	
//	MessageBox ("Warning!", "Not 'BCC' or 'BNC'")
	Return -1
	
END IF

SELECT dbo.Warranty_SKU.Warranty_Length,   
		dbo.Warranty_SKU.FRU_SKU  
		INTO :li_warranty_length, :ls_fru_sku
 FROM dbo.Warranty_SKU   
 WHERE Project_ID = :gs_Project AND
				SKU = :as_sku USING SQLCA;


IF SQLCA.SQLCode = 100 THEN
	
	//SKU NOT Found

	//Change inventory type to "M" MRB

//SC1.2.2.2.1.	If SKU not found in Table 1: 
//SC1.2.2.2.1.1. Change the inventory type to "M" MRB 
//SC1.2.2.2.1.2. Display a message to the effect of "Tag [SKU] with 'Warranty period not found' prior to put-away" 

	adw_serial.SetItem(al_findrow , "inventory_type", "M")
	
	MessageBox ("Error", "Tag " + as_sku + " with 'Warranty period not found' prior to put-away.")
	
	//Need to send something to 3Com
	
	
ELSE

//SC1.2.2.2.2.	If SKU found in Table 1:
//SC1.2.2.2.2.1. Use the 5th and 6th characters of the serial number to get the manufacture date (week end date) from Table 2
//SC1.2.2.2.2.2. Use the manufacture date with the warranty period length (in months) from Table 1 to determine if today's date is in the warranty period or if the warranty period has already ended 


	//SKU Found

	//Check to see if under warranty
	
	IF li_warranty_length = 999 THEN
		
		//FRU relabelling so they will always pass the warranty check
	
		ls_under_warranty = 'Y'
	
	ELSE
	
	
		ls_week_code =  Mid( as_serial, 5, 2) //5th and 6th characters in sku are the week code

		
//		MessageBox ("Week Code", ls_week_code)
		
		
		 SELECT dbo.Warranty_Week.Week_Start_Date,   
					dbo.Warranty_Week.week_End_Date
				INTO :ldt_Week_Start_Date,
						 :ldt_week_End_Date
			FROM dbo.Warranty_Week 
			WHERE week_code = :ls_week_code AND
						project_id = :gs_project
			USING SQLCA;
		
		IF SQLCA.SQLCode = 100 THEN

			adw_serial.SetItem(al_findrow , "inventory_type", "M")						
					
			MessageBox ("Error", "Week Code not found in Warranty Week Table.")
			
			RETURN -1	
		END IF
			
//		MessageBox ("ok", string( RelativeDate (date(ldt_Week_Start_Date), (li_warranty_length * 30))) + ":" + 	string( RelativeDate (date(ldt_week_End_Date), (li_warranty_length * 30))) )
	
		date ld_today
	
		ld_today = Today()
	
//		MessageBox ("Man Date:" + string(ldt_week_End_Date), string(li_warranty_length))

		ldt_warranty_date = RelativeDate (  date(ldt_week_End_Date), (li_warranty_length * 30))

		ls_note = "Warranty until: " + string(date(ldt_warranty_date),"MM/DD/YY" ) + "."

	
	
		if ld_today <= ldt_warranty_date  then
			
			ls_under_warranty = 'Y'
			
			MessageBox ("Serial Under Warranty", ls_note )

			
		else
			
			ls_under_warranty = 'N'
			
			MessageBox ("Serial Not Under Warranty", ls_note)
			
			
		end if
	
	
	END IF

END IF


if ls_under_warranty = 'Y' then

//	 if ib_check_fru then 

		//2.1.1.	If in warranty and inventory type = "P" SPOR (GLS):
		//SC2.1.1.1.	Change inventory type to "A" Broken (GLS) 
		
//			if adw_serial.GetItemString(al_findrow , "inventory_type") = "P" then
				adw_serial.SetItem(al_findrow , "inventory_type", "A")
//			end if	
	 
//	else
	 	//SC1.2.2.2.2.4. If in warranty and inventory type = "V" HOLD (GLS): 
		//1.2.2.2.2.4.1.	Change inventory type to "A" Broken (GLS) 
	
//		if adw_serial.GetItemString(al_findrow , "inventory_type") = "V" then
//			adw_serial.SetItem(al_findrow , "inventory_type", "A")
//		end if
//		 
//	end if
else

 //SC1.2.2.2.2.3. If out of warranty (today's date is after end of warranty period)::
 //1.2.2.2.2.3.1.	Change the inventory type to "M" MRB	
	
	adw_serial.SetItem(al_findrow , "inventory_type", "M")
	
end if


integer li_row, li_find

//li_row = dw_warranty_sku_fru.InsertRow(0)


if ib_check_fru and  ls_under_warranty = 'Y' and (Not IsNull(ls_fru_sku) AND trim(ls_fru_sku) <> "") then
	
	string ls_sql, ls_where, ls_orig_sql
	
	MessageBox ("Reprint Label", "The part must be relabeled from " + as_sku + " to " + ls_fru_sku )
	
	
	adw_serial.SetItem(al_findrow,'sku', ls_fru_sku)
	
	datastore lds_item_master
	
	lds_item_master = Create datastore
	
	lds_item_master.dataobject = "d_maintenance_itemmaster"
	lds_item_master.SetTransObject(SQLCA)

	ls_orig_sql = lds_item_master.getsqlselect()

	ls_where = "  Where item_master.project_id = '" + gs_project + "' "  
	ls_where += " and item_master.sku = '" + ls_fru_sku + "' "

	ls_sql = ls_orig_sql + ls_where
	lds_item_master.setsqlselect(ls_sql)

	lds_item_master.Retrieve()

	if  lds_item_master.Retrieve() > 0 then
		
			
	else

			
		ls_where = "  Where item_master.project_id = '" + gs_project + "' "  
		ls_where += " and item_master.sku = '" + as_sku + "' "
	
		ls_sql = ls_orig_sql + ls_where
		lds_item_master.setsqlselect(ls_sql)
	
		lds_item_master.Retrieve()

		lds_item_master.RowsCopy(1,  1, Primary!, lds_item_master, 2, Primary!)
		
		lds_item_master.SetItem( 2, "sku", ls_fru_sku)
		
		lds_item_master.Update()
		
		
	end if	
		
		
	li_find = 0
	
	DO

		li_Find = idw_putaway.Find("sku='"+as_sku+"'", li_Find, idw_putaway.RowCount())

		if li_Find > 0 then
			
			idw_putaway.SetItem( li_Find, "sku", ls_fru_sku)
			
		end if


	LOOP UNTIL li_find = 0


	li_find = 0
	
	DO

		li_Find = idw_detail.Find("sku='"+as_sku+"'", li_Find, idw_detail.RowCount())

		if li_Find > 0 then
			
			idw_detail.SetItem( li_Find, "sku", ls_fru_sku)
			
		end if


	LOOP UNTIL li_find = 0	
	
	
	
end if

//dw_warranty_sku_fru.SetItem(li_row, "warranty_length", li_warranty_length)
//dw_warranty_sku_fru.SetItem(li_row, "fru_sku", ls_fru_sku)
//dw_warranty_sku_fru.SetItem(li_row, "warranty", ls_under_warranty)
//dw_warranty_sku_fru.SetItem(li_row, "note", ls_note)


RETURN 0
end function

public function integer uf_validate_container (string asdata);String	lsRONO, lsFind, lsContainer, lsFindPutaway
Long  llCnt, llPos, llFindRow, llLineItemNo, llRow, llFindRowPutaway, llLineItemNo_Putaway 
boolean lbFoundIt

//OCT 2019 - MikeA - S36898  F17989 - PhilipsCLS - Add Batch Code 
//Use continer_id to store Batch Code - Don't perform Baseline validation.
If left(gs_project,7) = 'PHILIPS' Then Return 0


llRow = idw_Putaway.GetRow()
llCnt = 0

// dts - 10/16/14 - Moved this back to Baseline as Pandora needs to accept duplicate Container IDs (from WH x-fers, etc)
//		// 04/03 - PCONKL - Make sure it is not used and the prefix is for this order (first 6 must be last 6 of RONO)
//		// 08/14 - GailM - Check moved out of Baseline.  Pandora needs it also.
//		lsFind = "Upper(Container_ID) = '" + upper(asdata) + "'"
//		If idw_Putaway.Find(lsFind,1,idw_Putaway.RowCOunt()) > 0 Then
//			Messagebox(is_title,"This Container ID is already being used!")
//			Return -1
//		End If
		
Choose Case Upper(gs_project)
		
	Case "PANDORA"
		
		// GailM - 8/18/2014 - Pandora Issue 883 - Deja Vu - ContainerID scanning
		lsContainer = ''
		llLineItemNo = 0
		//dts 10/16/14 - building in a work-around for SuperDuper users to get around orders that are incorrectly deemed DejaVu (while we wait for action on Pandora IT's part regarding rules)
		If ibDejaVu and ibDejaVu_Override and gs_role = '-1' and not ibDejaVu_Asked Then
			If Messagebox('DejaVu Prompt for SuperDuper Users, in uf_validate_container', 'This order is Marked DejaVu. Leave as DejaVu?',Question!,YesNo!,1) = 2 Then
				ibDejaVu = false
			else
				ibDejaVu_Asked = true
			End If
		end if		
		if ibDejaVu Then
			If tab_main.tabpage_main.dw_main.GetItemString(1,'ord_type') = 'Z' Then	// DejaVu Warehouse Transfer
				//dts - Need to loop to fill ALL lines with the scanned Container ID
				lsFind = "UPPER(container_id) = '" + UPPER(asData) + "'"
				llFindRow = idsDOPicking.Find(lsFind,1,idsDOPicking.RowCount())
				if llFindRow > 0 Then
					lbFoundIt = False  //see if the current row has the entered container ID.
					//now looping to find all lines with the scanned/entered ContainerID
					lsContainer = idsDOPicking.GetItemString(llFindRow,'container_id')
					do while llFindRow > 0
						llLineItemNo = idsDOPicking.GetItemNumber(llFindRow,'line_item_no')
						//find and stamp the line in putaway...
						lsFindPutaway = "line_item_no = " + string(llLineItemNo)
						llFindRowPutaway = idw_putaway.Find(lsFindPutaway,1,idw_putaway.RowCount())
						If llFindRowPutaway > 0 Then
							llLineItemNo_Putaway = idw_putaway.GetItemNumber(llRow,'line_item_no')
							if llLineItemNo = llLineItemNo_Putaway then
								lbFoundIt = true
							end if
							idw_putaway.SetItem(llFindRowPutaway,'container_id',lsContainer)
						end if
						llFindRow ++
						if llFindRow > idsDOPicking.RowCount() then
							llFindRow = 0
						else
							llFindRow = idsDOPicking.Find(lsFind,llFindRow,idsDOPicking.RowCount())
						end if
					loop
					if lbFoundIt = false then
//						idw_putaway.SetItem(llRow,'container_id','-')						//Erase inputted container
						idw_putaway.SetItem(llRow,'container_id','')   						//OCT 2019 - MikeA - DE12998
						//TimA 02/09/15 Scroll to the row with the '-' in it.  So that the cursor stays on that field while keying in container ID's
						idw_putaway.setrow(llRow)
						idw_putaway.scrolltorow( llRow)
						id_CurrentRowContainerIdFound = True
						return 2
					end if
				Else
					messagebox(is_title,'Container ID is not valid or cannot be found in delivery tables.~n~rPlease re-try.')
					Return -1
				End If
			Elseif tab_main.tabpage_main.dw_main.GetItemString(1,'ord_type') = 'Y' Then	// Intermediate Order
				//dts - Need to loop to fill ALL lines with the scanned Container ID
				lsFind = "UPPER(container_id) = '" + UPPER(asData) + "'"
				llFindRow = idsEdiContainers.Find(lsFind,1,idsEdiContainers.RowCount())
				if llFindRow > 0 Then
					lbFoundIt = False  //see if the current row has the entered container ID.
					//now looping to find all lines with the scanned/entered ContainerID
					lsContainer = idsEdiContainers.GetItemString(llFindRow,'container_id')
					do while llFindRow > 0 //finding all rows in edi staging table that have the scanned Container ID...
						llLineItemNo = idsEdiContainers.GetItemNumber(llFindRow,'line_item_no')
						//find and stamp the line in putaway...
						lsFindPutaway = "line_item_no = " + string(llLineItemNo)
						llFindRowPutaway = idw_putaway.Find(lsFindPutaway,1,idw_putaway.RowCount())
						If llFindRowPutaway > 0 Then
							llLineItemNo_Putaway = idw_putaway.GetItemNumber(llRow,'line_item_no')
							if llLineItemNo = llLineItemNo_Putaway then
								lbFoundIt = true
							end if
							idw_putaway.SetItem(llFindRowPutaway,'container_id',lsContainer)
						end if
						llFindRow ++
						if llFindRow > idsEdiContainers.RowCount() then
							llFindRow = 0
						else
							llFindRow = idsEdiContainers.Find(lsFind,llFindRow,idsEdiContainers.RowCount())
						end if
					loop
					if lbFoundIt = false then
//						idw_putaway.SetItem(llRow,'container_id','-')						//Erase inputted container
						idw_putaway.SetItem(llRow,'container_id','')      					//OCT 2019 - MikeA - DE12998
						//TimA 02/09/15 Scroll to the row with the '-' in it.  So that the cursor stays on that field while keying in container ID's
						idw_putaway.setrow(llRow)
						idw_putaway.scrolltorow( llRow)
						id_CurrentRowContainerIdFound = True
						return 2
					end if
				Else
//Tam 2016/11/22  Turn off this message per Roys instruction
//					messagebox(is_title,'Container ID is not valid or cannot be found in staging tables.~n~rPlease re-try.')
//					Return -1
				End If
			End If
			
//			if lsContainer <> '' and llLineItemNo > 0 then			// Found container, now enter into putaway list
//				lsFind = "line_item_no = " + string(llLineItemNo)
//				llFindRow = idw_putaway.Find(lsFind,1,idw_putaway.RowCount())
//				If llFindRow > 0 Then
//					if llRow = llFindRow Then
//						idw_putaway.SetItem(llFindRow,'container_id',lsContainer)		//Re-enter for the correct line item no
//						return 0
//					else
//						idw_putaway.SetItem(llRow,'container_id','')						//Erase inputted container
//						idw_putaway.SetItem(llFindRow,'container_id',lsContainer)		//Re-enter for the correct line item no
//						return 2
//					end if
//				End If
//			end if
		End If
		
		//Only allow it to be changed to one that is already on the order
		//If idw_Putaway.Find("Upper(Container_ID) = '" + Upper(asData) + "'",1,idw_Putaway.RowCount()) = 0 Then
		//	Messagebox(is_title,"You can not create a new Box ID.~r~rYou can only update to an existing ID.",StopSign!)
		//	Return -1
		//End IF
		
	Case Else /*Baseline*/
			
		// 04/03 - PCONKL - Make sure it is not used and the prefix is for this order (first 6 must be last 6 of RONO)
		// 08/14 - GailM - Check moved out of Baseline.  Pandora needs it also.
		//dts - 10/16/14 -  now back into the baseline section....
		lsFind = "Upper(Container_ID) = '" + upper(asdata) + "'"
		If idw_Putaway.Find(lsFind,1,idw_Putaway.RowCOunt()) > 0 Then
			Messagebox(is_title,"This Container ID is already being used!")
			Return -1
		End If

		lsRONO = Right(idw_main.GetITemString(1,'ro_no'),6)
			
		//must be 12 digits
		If len(asdata) <> 12 Then
			Messagebox(is_title,"Container ID must be 12 digits and start with '" + lsRono + "'",StopSign!)
			Return -1
		End If
			
		If Not isnumber(asdata)  Then
			Messagebox(is_title,"Container ID must be numeric!",StopSign!)
			Return -1
		End If /* not numeric*/
			
					
		If Left(asdata,6) <> lsRONO Then
			Messagebox(is_title,"Container Prefix is not assigned to this order.~rContainer ID must start with '" + lsRono + "'",StopSign!)
			Return -1
		End If
			
	End Choose
	
	Return 0
end function

public function integer wf_lock (boolean ab_lock);long ll_edibatchseqno
string ls_ordertype

IF gs_project = 'PANDORA' THEN

	string ls_color, ls_dw_color
	boolean lb_display_only, lb_enabled  
	
	ls_dw_color = idw_main.object.datawindow.color
	
	IF ab_lock THEN
		ls_color = ls_dw_color // string(RGB(128, 128, 128))
		lb_display_only = true
		lb_enabled = false
	ELSE
		ls_color = string(RGB(255, 255, 255))
		lb_display_only = false
		lb_enabled = true
	END IF

	//From Location
	idw_main.Object.wh_code.Protect = lb_display_only
	idw_main.Object.wh_code.Background.Color = ls_color
	
	//TimA 07/19/13 Moved from sle_orderno.clicked.  Problem was 
	// LTK 20111130	Pandora #253 Lock From Location field on electronic orders (or orders from MSE which is redundant)
	// GailM 20150323 - UserFields moved to new tab - other info
	if idw_main.RowCount() > 0 then
		if idw_main.Object.edi_batch_seq_no[1] > 0 then
			idw_other.object.user_field6.Protect = TRUE
			idw_other.object.user_field6.background.Color = idw_main.object.datawindow.color
			// GailM 06/16//2014 - Pandora Issue 875 - Protect 
			idw_detail.object.req_qty.Protect = TRUE
			idw_detail.object.req_qty.background.Color = idw_main.object.datawindow.color

			//TimA 10/07/14 Pandora issue #889
			idw_detail.object.Shipment_Distribution_No.protect = true
			idw_detail.object.Shipment_Distribution_No.background.Color = idw_main.object.datawindow.color
			idw_detail.object.Need_By_Date.protect = true
			idw_detail.object.Need_By_Date.background.Color = idw_main.object.datawindow.color

			idw_Putaway.object.Shipment_Distribution_No.protect = true
			idw_Putaway.object.Shipment_Distribution_No.background.Color = idw_main.object.datawindow.color
			idw_Putaway.object.Need_By_Date.protect = true
			idw_Putaway.object.Need_By_Date.background.Color = idw_main.object.datawindow.color

		Else
			//Pandora issue #889
			idw_detail.object.Shipment_Distribution_No.protect = FALSE
			idw_detail.object.Need_By_Date.protect = FALSE
			idw_Putaway.object.Shipment_Distribution_No.protect = FALSE
			idw_Putaway.object.Need_By_Date.protect = FALSE
		end if
	end if

//12/09/09:  UJHALL; Exhange UF3 for UF6
//	idw_main.Object.user_field3.Background.Color = 	ls_color
//	idw_main.Object.user_field3.Protect = 	lb_display_only
	//idw_main.Object.user_field6.Background.Color = 	ls_color
	//idw_main.Object.user_field6.Protect = 	lb_display_only

	//To Location
	
	//Item Number
	
		
	tab_main.tabpage_orderdetail.cb_insert.enabled = lb_enabled
	tab_main.tabpage_orderdetail.cb_delete.enabled = lb_enabled

	
	idw_detail.Object.sku.Protect = lb_display_only
//	idw_detail.Object.sku.Background.Color = ls_color	

	//From Project
//12/09/09 UJHALL Removed: part of no more entries in UF6 and UF8 at header level
//	idw_main.Object.user_field8.Protect = lb_display_only	
//	idw_main.Object.user_field8.Background.Color = ls_color	



	//To Project
//12/09/09 UJHALL Removed: part of no more entries in UF6 and UF8 at header level
//	idw_main.Object.user_field6.Protect = lb_display_only
//	idw_main.Object.user_field6.Background.Color = ls_color	

	
	//Transaction_Type

	idw_other.Object.user_field7.Background.Color = ls_color//ls_dw_color
	idw_other.Object.user_field7.Protect = lb_display_only //True	
	
	//TimA 10/10/11 Pandora issue #240
	idw_detail.object.user_line_item_no.protect = true
	idw_detail.object.line_item_no.protect = true //According to Roy always lock this
	
	//Trx Source Num
	//////////////////////////////Freeze Line_item_NO/////////////////////////////////////////////////////////////////////
	// 05/17/2010  ujhall: 1 of 1  // If Pandora and if this is due to a warehouse transfer 
	//	or (if an electronic order) or (if it is an MSE order from the web) , don't allow line number or SKU change
	If upper(gs_project) = 'PANDORA'   then
		// IF a Warehouse Transfer, then protect
		If upper(idw_main.GetItemString(1, "ord_type")) = 'Z' then
			idw_detail.object.line_item_no.protect = true
			idw_detail.object.sku.protect = true    //06/02/2010 ujhall:  Lock SKU Added  in 3 places here
			idw_main.object.supp_invoice_no.protect = true  //06/23/2010 ujhall: Lock Order Number Added in 3 places here
			idw_main.object.ord_type.tabsequence =0  //06/23/2010 ujhall: Lock Order type Added in 3 places here
		else
			/* 06/02/2010 ujHall:  Following  logic taken from  d_ro_master.t_3 expression incorporating expressions 
			     for "visible" and for what text is displayed. PowerBuilder handles nulls such that when edi_batch_seq_no is null the 'If' 
				is false even though null does not equal zero.  This mimics the expressions mentioned above and was
				 designed to mirror those expressions which have been behaving as desired. */
			If ( idw_main.object.edi_batch_seq_no[1] <> 0  or upper(idw_main.GetItemString(1, "ord_type")) = 'B') then  
					// If an electronic order then protect else if not a backorder it must be MSE, so protect
					If	( idw_main.object.edi_batch_seq_no[1] <> 0  and upper(idw_main.GetITEmString(1,"create_user")) = 'SIMSFP' ) then
						idw_detail.object.line_item_no.protect = true
						idw_detail.object.sku.protect = true    //06/02/2010 ujhall:  Lock SKU Added  in 3 places here
						idw_main.object.supp_invoice_no.protect = true  //06/23/2010 ujhall: Lock Order Number Added in 3 places here
						idw_main.object.ord_type.tabsequence =0  //06/23/2010 ujhall: Lock Order type Added in 3 places here
						
//						// KRZ Make the sub-inventory type field readonly.
						idw_other.object.user_field2.protect = true
						idw_other.object.user_field2.tabsequence =0
						
					else
						// if not a backorder, it must be MSE
						If  upper(idw_main.GetItemString(1, "ord_type")) <> 'B'  then
							idw_detail.object.line_item_no.protect = true
							idw_detail.object.sku.protect = true    //06/02/2010 ujhall:  Lock SKU Added  in 3 places here
							idw_main.object.supp_invoice_no.protect = true  //06/23/2010 ujhall: Lock Order Number Added in 3 places here
							idw_main.object.ord_type.tabsequence = 0  //06/23/2010 ujhall: Lock Order type Added in 3 places here
						end if
					end if
				end if
		end if
	else
		// This is Baseline
		idw_detail.Object.line_item_no.Protect = lb_display_only
	end if	
	// End 05/17/2010 ujhall:
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	idw_detail.Object.line_item_no.Background.Color = ls_color	

//	idw_detail.Object.line_item_no.Background.Color = ls_color
	
	idw_detail.Object.supp_code.Protect = lb_display_only
//	idw_detail.Object.supp_code.Background.Color = ls_color	

	//Order Type
	idw_main.Object.ord_type.Protect = lb_display_only
//	idw_main.Object.ord_type.Background.Color = ls_color	
	
	idw_detail.Object.alternate_sku.Protect = lb_display_only
//	idw_detail.Object.alternate_sku.Background.Color = ls_color	
	
	idw_detail.Object.c_owner_name.Protect = lb_display_only
//	idw_detail.Object.c_owner_name.Background.Color = ls_color	

	idw_main.Object.inventory_type.Protect = lb_display_only
//	idw_main.Object.inventory_type.Background.Color = ls_color	

	idw_main.Object.supp_invoice_no.Background.Color = ls_color	

	//Quantity
	// Get the edi_batch_seq_no and order type.
	
	//TimA 11/22/11 Removed the color change to Red if it is an electronic warehouse order.
	//Per Roy 
//	ll_edibatchseqno = idw_main.getitemnumber(1, "edi_batch_seq_no")
//	ls_ordertype = idw_main.getitemstring(1, "ord_type")
	
	// If the batch seq no is greater than 0 or order type is warehouse transfer,
//	If ll_edibatchseqno > 0 or ls_ordertype = "Z" then
		
//		idw_detail.Object.req_qty.Protect = not lb_display_only
//		idw_detail.Object.req_qty.Background.Color = "255"
		//string(RGB(128, 128, 128))
//	else
		
		idw_detail.Object.req_qty.Protect = lb_display_only
		idw_detail.Object.req_qty.Background.Color = ls_color
		
//	End If
	
	//PO_No
	
//	idw_putaway.Object.po_no.Protect = lb_display_only
//	idw_putaway.Object.po_no.Background.Color = ls_color
	
END IF

RETURN 0
end function

public function boolean f_processtransordertype (string as_transtype, string as_ordtype);// First, reset required fields.
tab_main.tabpage_other_info.dw_other.object.user_field9.font.weight = 400
tab_main.tabpage_other_info.dw_other.modify("user_field9.Edit.Required=false")
tab_main.tabpage_other_info.dw_other.object.user_field5.font.weight = 400
tab_main.tabpage_other_info.dw_other.modify("user_field5.Edit.Required=false")

// What is the trans type?
Choose case lower(as_transtype)
		
	// PO Receipt or EXP PO Receipt
	Case "po receipt", "exp po receipt"
		
		// If the order type is supplier,
		If lower(as_ordtype) = "supplier" then
			
			// Make Vendor Required.
			tab_main.tabpage_other_info.dw_other.object.user_field9.font.weight = 700
			tab_main.tabpage_other_info.dw_other.modify("user_field9.Edit.Required=true")
			
			// Make Dispatch Country Required.
			tab_main.tabpage_other_info.dw_other.object.user_field5.font.weight = 700
			tab_main.tabpage_other_info.dw_other.modify("user_field5.Edit.Required=true")
				
		End If
		
	// Material Receipt
	Case "material receipt"
		
		// What is the order type?
		Choose case lower(as_ordtype)
				
			Case "whse trans"
				
			Case "return from customer"
			
				// Make Dispatch Country Required.
				tab_main.tabpage_other_info.dw_other.object.user_field5.font.weight = 700
				tab_main.tabpage_other_info.dw_other.modify("user_field5.Edit.Required=true")
				
			Case "return from supplier"
			
				// Make Vendor Required.
				tab_main.tabpage_other_info.dw_other.object.user_field9.font.weight = 700
				tab_main.tabpage_other_info.dw_other.modify("user_field9.Edit.Required=true")
				
				// Make Dispatch Country Required.
				tab_main.tabpage_other_info.dw_other.object.user_field5.font.weight = 700
				tab_main.tabpage_other_info.dw_other.modify("user_field5.Edit.Required=true")
				
		End Choose
		
End Choose

return true
end function

public function string uf_get_next_container_id (string asgroup);
//Get the Nex Container ID - May have project specific requirements


String	lsContainer, lsNextContainer
Long	llNextContainer, llFindRow, llSeq

If gs_project = 'PANDORA' and Upper(asgroup) = 'CB' Then
		
	// Container ID is "CTY" + 8 digit sequential from Sequence generator
	llSeq = g.of_next_db_seq(gs_project,'Receive_Master','Pandora_Box_ID')
	If llSeq <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available Box Number!")
		Return ""
	End If
	
	lsNextContainer =  "CTY" + String(llSeq,"00000000")
		
		
 Else /*Baseline*/
		
		llNextContainer = idw_Putaway.RowCount()
		lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')  /*start off with using the rowcount */
		//If found, keep bumping until no longer present
		llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
		Do While llFindRow > 0
			llNextContainer ++
			lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')
			llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
		Loop
				
End If
	
Return lsNextContainer
	
	
//	Choose Case Upper(gs_Project)
		
//	Case "PANDORA"
//		
////Tam Added parameter to pass in group.  If the Group is Kittyhawk then use a different sequence
//		If Upper(asgroup) = 'KHBOOKS' Then
//			// Container ID is "CTY" + 8 digit sequential from Sequence generator
//			llSeq = g.of_next_db_seq(gs_project,'Receive_Master','Pandora_KH_Box_ID')
//			If llSeq <= 0 Then
//				messagebox(is_title,"Unable to retrieve the next available Box Number!")
//				Return ""
//			End If
//		
//			lsNextContainer =  String(llSeq,"00000000")
//		Else
//			// Container ID is "CTY" + 8 digit sequential from Sequence generator
//			llSeq = g.of_next_db_seq(gs_project,'Receive_Master','Pandora_Box_ID')
//			If llSeq <= 0 Then
//					messagebox(is_title,"Unable to retrieve the next available Box Number!")
//					Return ""
//			End If
//			lsNextContainer =  "CTY" + String(llSeq,"00000000")
//		End If
//		
//		
//		
//	Case Else /*Baseline*/
//		
//		llNextContainer = idw_Putaway.RowCount()
//		lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')  /*start off with using the rowcount */
//		//If found, keep bumping until no longer present
//		llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
//		Do While llFindRow > 0
//			llNextContainer ++
//			lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')
//			llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
//		Loop
//				
//	End Choose
//	
//	Return lsNextContainer
end function

public function integer wf_create_rma_address (string ascustcode);
//Update or add the Receive_Alt_address based on the Cust COde passed in.

String	lsRONO, lsName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsTel, lsFax, lsContact, lsEmail
Long		llID

lsRoNO = idw_Main.GetITemString(1,'ro_no')


//If No customer passed in, Delete the record...
If asCustCode = "" Then
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Delete from Receive_Alt_address where Project_id = :gs_Project and ro_no = :lsRONO and address_type = 'RC';
	Execute Immediate "COMMIT" using SQLCA;
	
	Return 0
	
End If

Select Cust_Name, ADdress_1, Address_2, Address_3, address_4, City, State, Zip, Country, Contact_person, Tel, Fax, Email_Address
Into	:lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsContact, :lsTel, :lsFax, :lsEmail
From Customer
Where Project_id = :gs_project and Cust_Code = :asCustCode;

If lsName = '' or isnull(lsName) Then Return -1

//Add or update existing address record
Select Max(receive_Alt_Address_id) into :llID
From Receive_Alt_Address
Where Project_id = :gs_Project and address_type = 'RC' and ro_no = :lsRONO;


Execute Immediate "Begin Transaction" using SQLCA;

If llID > 0 Then /*Update*/

	Update Receive_Alt_Address
	Set Name = :lsname, Address_1 = :lsaddr1, Address_2 = :lsAddr2, address_3 = :lsAddr3, Address_4 = :lsAddr4, City = :lsCity, 
			State = :lsState, Zip = :lsZip, Country = :lsCountry, tel = :lsTel, fax = :lsFax, Contact_person = :lsContact, Email_address = :lsEmail
	Where Receive_Alt_Address_id = :llID;


Else /*Insert*/
	
	Insert into Receive_Alt_Address (Project_id, address_type, Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, RO_NO, Contact_person, Fax, Email_address)
	Values (:gs_project, 'RC', :lsName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry, :lsTel, :lsRONO, :lsContact, :lsFax, :lsEmail);
	
End If /*Insert/Update*/

Execute Immediate "COMMIT" using SQLCA;

Return 0
end function

public function boolean f_setdetaildescription (long al_rownum);string ls_sku, ls_supplier, ls_description
long ll_findrow, ll_count

// Get the sku and supplier
ls_sku = tab_main.tabpage_orderdetail.dw_detail.getitemstring(al_rownum, "sku")
ls_supplier = tab_main.tabpage_orderdetail.dw_detail.getitemstring(al_rownum, "supp_code")

// If this is the Pandora Project,
If lower(ls_supplier) = "pandora" then

	// Initialize the warehouse object.
	ll_count = i_nwarehouse.of_item_sku(ls_supplier,ls_sku)
	
	//we may have more than 1 item row retrieved
	ll_findrow = i_nwarehouse.ids_sku.Find("Upper(SKU) = '" + Upper(ls_sku) + "' and Upper(Supp_code) = '" + Upper(ls_supplier) + "'",1, i_nwarehouse.ids_sku.rowCount())
	If ll_findrow < 1 Then
		
		// Find the row for this sku and supplier.
		ll_findrow = i_nwarehouse.ids_sku.Find("Upper(SKU) = '" + Upper(ls_sku) + "' and Upper(Supp_code) = '" + Upper(ls_supplier) + "'",1, i_nwarehouse.ids_sku.rowCount())
		
		If ll_findrow < 1 Then
			MessageBox(is_title, "Invalid SKU/Supplier, please re-enter!",StopSign!)
		End If
		
		// Return false
		return false
		
	End If
	
	// Get and set the description
	ls_description = i_nwarehouse.ids_sku.GetITemstring(ll_findrow,'description')
	tab_main.tabpage_orderdetail.dw_detail.SetItem(al_rownum, "description_1",ls_description)
	
// End if this project is pandora,
End If

// Return true
return true
end function

public function boolean f_checkforalphachar (string as_stringtocheck, ref boolean ab_hasalpha);long ll_numchars, ll_charnum
boolean lb_goodcheck

// Reset ab_hasalpha
ab_hasalpha = false

// Derrive lb_goodcheck
lb_goodcheck = len(as_stringtocheck) > 0

// Get the number of characters in the string to check.
ll_numchars = len(as_stringtocheck)

// Loop through the characters.
For ll_charnum = 1 to ll_numchars
	
	// If this character is alpha,
	If not isnumber(mid(as_stringtocheck, ll_charnum, 1)) then
		
		// Set the has alpha flag.
		ab_hasalpha = true
		exit
	End If
	
// Next character.
Next

// Return lb_goodcheck
return lb_goodcheck
end function

public function integer uf_comcast_update_carton_serial (integer airow);String	lsPutawaySKU, lsPallet, lspalletSKU


lsPallet = idw_Putaway.GetITemString(aiRow,'Lot_No')
lsPutawaySKU = idw_Putaway.GetITemString(aiRow,'SKU')

Select Max(SKU) into :lsPalletSKU
from Carton_Serial
Where Project_id = 'Comcast' and Pallet_id = :lsPallet;

If lsPalletSKU <> lsPutawaySKU Then
	
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Update Carton_serial
	Set SKU = :lsPutawaySKU
	Where Project_id = 'Comcast' and pallet_id = :lsPallet
	Using SQLCA;
	
	Execute Immediate "COMMIT" using SQLCA;
	
	w_ro.SetMicroHelp("carton Serial data updated for Pallet: " + lsPallet)
		
End IF


Return 0
end function

public function integer wf_detail_vs_putaway ();
//long i_ndx
//datastore ldw_detail_putaway
//ldw_detail_putaway = Create Datastore
//ldw_detail_putaway.dataobject = 'd_detail_putaway_order_compare'
//
//for i_ndx = 1 to idw_detail.rowcount()
//	if ldw_detail_putaway.GetItemNumber(i_ndx, 'alloc_qty') &
//		<> ldw_detail_putaway.GetItemNumber(i_ndx, 'req_qty') then
//		
//		ldw_detail_putaway.InsertRow(i_ndx)
//		ldw_detail_putaway.SetItem(i_ndx, 'rownum', ldw_detail_putaway.GetItemNumber(i_ndx, 'Compute_1'))
//		ldw_detail_putaway.SetItem(i_ndx, 'line_item_no', ldw_detail_putaway.GetItemNumber(i_ndx, 'line_item_no'))
//		ldw_detail_putaway.SetItem(i_ndx, 'sku', ldw_detail_putaway.GetItemString(i_ndx, 'sku'))
//		ldw_detail_putaway.SetItem(i_ndx, 'description_1', ldw_detail_putaway.GetItemString(i_ndx, 'description_1'))
//	end if
//
//next

if isvalid(w_detail_putaway_compare) then
	close(w_detail_putaway_compare)
end if
OpenWithParm(w_detail_putaway_compare, idw_detail)





return 0
end function

public function string wf_pandora_save_validations ();// 20110316 LTK	This function contains the "Joel validation" block which was located in ue_save.

String ls_pandora_validation_error, ls_Sub_Inventory_Type, ls_CustCode, lsOwnername, ls_INActiveCustomerName
Long ll_owner_id, llOwnerID, llAvail, ll_wh_row, llLocCnt
Long llLocOwnerID1, llLocAvail1, llLocAlloc1, llLocOwnerID2, llLocAvail2, llLocAlloc2
Long llLocSit, llLocTfr_in, llLocTfr_out, llQty
Integer i_indx, li_ret
String ls_ordStatus, ls_uf6, ls_country, lsLoc, lsWhCode, lsSku
String sql_syntax, lsError, lsLocType, lsSerializedInd, lsSerialNo
Datastore ldsOwners

//IF gs_project = "PANDORA" THEN
	
	//3/10 JAyres Check to see if the Sub Inventory Location is for an InActive Customer	
	If idw_main.RowCount() > 0 Then
		ls_Sub_Inventory_Type = idw_main.GetItemString( 1, "user_field2" )
		If IsNULL(ls_Sub_Inventory_Type) or ls_Sub_Inventory_Type = '' then
			//skip the check
		else
			SELECT Owner_ID INTO :ll_owner_id FROM OWNER 
				WHERE Project_ID = "PANDORA" AND
				Owner_CD = :ls_Sub_Inventory_Type
				USING SQLCA;
			IF SQLCA.SQLCode = 100 THEN
				ls_pandora_validation_error = "Sub-Inventory Location ("+ls_Sub_Inventory_Type+") not found in Owner Table"
				MessageBox ("Error", ls_pandora_validation_error)
				// 5/20/2010 Need to roll back. setting li_ret to facilitate that
				// 5/20/2010 Return 1
				//li_ret = 0
			ELSE
				ls_CustCode = ''
				SELECT	Cust_Code INTO :ls_CustCode FROM Customer
				WHERE 	Cust_Code = :ls_Sub_Inventory_Type AND Project_ID = 'PANDORA' and Customer_type = 'IN'
				USING 	SQLCA;
					
				if sqlca.SQlcode <> 0 and sqlca.SQlcode <> 100 then
					ls_pandora_validation_error = "Error retrieving customer information. ~r~n" + SQLCA.SQLErrText
					MessageBox ("DB Error", ls_pandora_validation_error)
				end if

				If ISNull( ls_CustCode	) Then  ls_CustCode =''
				If ls_CustCode <> '' Then
					if Len(ls_pandora_validation_error) > 0 then
						ls_pandora_validation_error = ls_pandora_validation_error + "~r~nSub-Inventory Location Must be an Acitve Customer."
					else
						ls_pandora_validation_error = "Sub-Inventory Location Must be an Acitve Customer."
					end if
					MessageBox (is_Title, ls_pandora_validation_error)
					// 5/20/2010 return 1
					//li_ret = 0
				End if
			END IF
		END IF // sub-inventory is populated	

		//Jxlim 05/25/2011 #198 look up from customer table if user_field6 =cust_code the set country of dispatch user_filed5 with country from customer.
			 ls_ordStatus = idw_main.GetItemString( 1, "ord_status" )
			 If ls_ordStatus = 'P' Then
				 ls_uf6 = idw_main.GetItemString( 1, "user_field6" )
				 If IsNULL(ls_uf6) or ls_uf6 = '' then   //checking for null value
					  //skip the check
				 Else
							Select   Country Into :ls_country
							 From     Customer
							 Where   Project_id = :gs_project
							 And        Cust_code = :ls_uf6
							 Using    SQLCA;           
							 If sqlca.sqlcode = 0 Then
								 idw_main.SetItem(1, "user_field5", ls_country)
							 Else  /*not Found*/
								//Jxlim 06/01/2011 if not found then skip
								 //MessageBox (is_Title, "FROM Location must be a valid and active Customer.")
								// ls_pandora_validation_error = "From Location Must be a valid Customer."
							 End If
					 End If
			 End If         //Jxlim 05/26/2011 end of #198
	END IF // idw_main.RowCount() > 0

	long ll_previous_row_owner_id		// 20110316 LTK introduced this variable for efficiency
	//3/10 JAyres Check to see if Customer is Active
	If Len(ls_pandora_validation_error) = 0 and tab_main.tabpage_orderdetail.dw_detail.RowCount() > 0 then
		FOR i_indx = 1 to tab_main.tabpage_orderdetail.dw_detail.RowCount() 
			//If li_ret = 0 Then Continue
			llOwnerID 		= tab_main.tabpage_orderdetail.dw_detail.GetItemNumber(i_indx,"owner_id")
			lsOwnername 	=tab_main.tabpage_orderdetail.dw_detail.GetItemString(i_indx,"c_owner_name")
			
			If llOwnerID <> ll_previous_row_owner_id  and Right(Trim(lsOwnername), 3) = '(C)' Then
				ll_previous_row_owner_id = llOwnerID				
			
				Select Distinct 	dbo.Customer.Cust_Name
				Into    			:ls_INActiveCustomerName
				FROM 			dbo.Owner,
										dbo.Customer
				Where 			dbo.Owner.Project_ID 		= dbo.Customer.Project_ID
					and    		dbo.Owner.owner_cd			= dbo.Customer.Cust_Code
					and 			dbo.Owner.Owner_ID 		= :llOwnerID
						and 			dbo.Customer.Customer_Type 	= 'IN' 
					and 			dbo.Owner.Project_ID 		= :gs_project;
			
				If NOT ( ls_INActiveCustomerName = '' or IsNULL(ls_INActiveCustomerName) ) Then
					If IsNULL(lsOwnername) Then lsOwnername = ''
					ls_pandora_validation_error = "Owner Name: "+  lsOwnername + " is INACTIVE at Row "+string(i_indx) +" of Order Detail.~r~rPlease Enter an Active Owner then Save."
					MessageBox(is_title, ls_pandora_validation_error)	
					//li_ret = 0
					exit	// 20110316 LTK  Exit loop as soon as error condition occurs
					End If
			End If
		Next
		// dts - moved below If li_ret = 1  Then li_ret = idw_detail.Update()
	End If // detail rows...

	/*TAM - 2017/04 - Added a validation to check open orders for potential MIXED owner codes.  If an open order exist for this putaway line 
	 and it is for a different owner/project then return a message saying the putaway location must be changed.  
	 This is to prevent an open order that is put back to new status from mixing inventory.
	*/
	//GailM 07/13/2017 SIMSPEVS-737 PAN SIMS Soft warning - Must not have available qty
	/*	A change to remark above.  Certain warehouses have the ability to mix owners in a location as long as the original owner is fully allocated.
		The new owner can load the location with inventory (of the same owner) during the time the original owner has  allocated inventory.
		The new owner is asked the question whether they agree to this condition.  Original owner cannot unallocate the inventory as long as new 
		owner has available inventory in the location.
	*/
	lsWhCode =  Upper(idw_main.getitemstring(1,'wh_code'))
	ll_wh_row = g.of_project_warehouse(gs_project, lsWhCode)		//Is WH allowed to mix owners?
	isAllowMultiOwnerPerLocation = g.ids_project_warehouse.GetItemString( ll_wh_row,'warehouse_allow_multi_owner_per_location_ind' )
			
	If Len(ls_pandora_validation_error) = 0 and tab_main.tabpage_putaway.dw_putaway.RowCount() > 0 then
		iF isAllowMultiOwnerPerLocation = 'Y' Then		// WH is allowed to mix owners at a location
			ldsOwners = Create Datastore
			FOR i_indx = 1 to tab_main.tabpage_putaway.dw_putaway.RowCount()
				llOwnerID = tab_main.tabpage_putaway.dw_putaway.GetItemNumber(i_indx,"owner_id")
				lsLoc = tab_main.tabpage_putaway.dw_putaway.GetItemString(i_indx,'l_code')
					//check that location is either empty or is not already allowed to mix owners (loc type 6 and 9)
				Select l_type into :lsLocType From location Where wh_code = :lsWhCode and l_code = :lsLoc
						Using SQLCA;
				If  ( IsNull( lsLocType ) or ( lsLocType <> '9' and  lsLocType <> '6' ) ) then
// TAM 2018/08/06 - DE5516 - Don't edit if Location "*" - This is the default location when no location and creates a record in Content_Summary.SIT.
//21-NOV-2018 :Madhu DE7369 Added SIT, Tfr_In, Tfr_Out quantities
//					sql_syntax = "Select owner_id, sum(avail_qty) as avail, sum(alloc_qty) as alloc From content_summary Where project_id = 'PANDORA' " + &
//						" and wh_code = '" + lsWhCode + "' and l_code = '" + lsLoc + "' group by owner_id"
					sql_syntax = "Select owner_id, sum(avail_qty) as avail, sum(alloc_qty) as alloc, sum(sit_qty) as sit, sum(tfr_in) as tfr_in, sum(tfr_out) as tfr_out " + & 
						" From content_summary Where project_id = 'PANDORA' " + &
						" and wh_code = '" + lsWhCode + "' and l_code = '" + lsLoc + "' and l_code <> '*' group by owner_id"
						
					ldsOwners.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", lsError))
					IF Len(lsError) > 0 THEN
						messagebox("TEMPO", "*** Unable to create datastore for Content Records.~r~r" + lsError)
							ls_pandora_validation_error =  "Database error in wf_pandora_save_validations:  Unable to create datastore for Content Records.~r~r" + lsError
						continue
					END IF
					ldsOwners.SetTransObject(SQLCA)
					llLocCnt = ldsOwners.Retrieve()
/**********/
					If llLocCnt <=0 Then
						//The location is empty.  Do nothing.
					ElseIf llLocCnt = 1 Then		//One owner in this location
						If llOwnerID = ldsOwners.GetItemNumber(1,'owner_id') Then
							//One owner in one location is ideal.  Nothing to do.
							ls_pandora_validation_error = ""
						Else
							//Second owner attempted.  Is first owner fully allocated?
							llLocAvail1 = ldsOwners.GetItemNumber(1,'avail')
							llLocAlloc1 = ldsOwners.GetItemNumber(1,'alloc')
							llLocSit = ldsOwners.GetItemNumber(1,'sit')
							llLocTfr_in = ldsOwners.GetItemNumber(1,'tfr_in')
							llLocTfr_out = ldsOwners.GetItemNumber(1,'tfr_out')
							
							If llLocAvail1 = 0 and llLocAlloc1 = 0 and llLocSit =0 and llLocTfr_in = 0 and llLocTfr_out =0 and isAllowMultiOwnerPerLocation = 'Y' Then
									If  ib_has_allowed_multi_owner_per_location = True Then	ls_pandora_validation_error = "" // Allow to save
							elseIf llLocAvail1 = 0 and (llLocAlloc1 > 0  or llLocSit > 0 or llLocTfr_in > 0 or llLocTfr_out > 0 ) and isAllowMultiOwnerPerLocation = 'Y'  Then
								If  ib_has_allowed_multi_owner_per_location = True Then		// Already asked, don't ask again
									// Allow to save
									ls_pandora_validation_error = ""
								Else	// Ask to allow this condition
									ll_wh_row = messagebox(is_title, 'This bin Location has allocated inventory of a different ownercode.  If you wish to use this location, press. Otherwise, press Cancel and choose a new bin location.', Question!, OKCancel!)
									if ll_wh_row = 2 Then
										// Do not save.  Have owner changed and resave
										ls_pandora_validation_error = "Please return to putaway list and change owner on Row: " + String(i_indx)
										messagebox(is_title, ls_pandora_validation_error)
										Exit		//   Exit loop as soon as error condition occurs
									Else
										ib_allow_multi_owner_per_location = True	
										ib_has_allowed_multi_owner_per_location = True
									End If
								End If
							Else
								ls_pandora_validation_error = "The Location " + lsLoc + " at Row " + String(i_indx) + " already has material of a different Owner or Inventory Type!~r~r Please return to putaway and change owner."
								messagebox(is_title,ls_pandora_validation_error,StopSign!)
								Exit		//   Exit loop as soon as error condition occurs							
							End If
						End If					
					ElseIf llLocCnt = 2 Then	// Already two owners in this location.  Is this new order with the same owner as the available qty?
						llLocOwnerID1 = ldsOwners.GetItemNumber( 1,'owner_id' )
						llLocAvail1 = ldsOwners.GetItemNumber( 1,'avail' )
						llLocAlloc1 = ldsOwners.GetItemNumber( 1,'alloc' )
						llLocOwnerID2 = ldsOwners.GetItemNumber( 2,'owner_id' )
						llLocAvail2 = ldsOwners.GetItemNumber( 2,'avail' )
						llLocAlloc2 = ldsOwners.GetItemNumber( 2,'alloc' )

						If ( llLocOwnerID1 = llOwnerID And  llLocAvail1 >= 0 And llLocAvail2 = 0 And llLocAlloc2 > 0 )	Or  ( llLocOwnerID2 = llOwnerID And  llLocAvail2 >= 0 and llLocAvail1 = 0 And llLocAlloc1 > 0 ) Then		
							// This will allow entry
							ls_pandora_validation_error = ""
						Else
							ls_pandora_validation_error = "The Location " + lsLoc + " at Row " + String(i_indx) + " already has material of a different Owner or Inventory Type!~r~r Please return to putaway and change owner."
							MessageBox(is_title, ls_pandora_validation_error)	
							exit	//   Exit loop as soon as error condition occurs
						End If
					Else
						ls_pandora_validation_error = "Location " + lsLoc + " at Row " + String(i_indx) + " has more than 2 owners!  Please research this location and rectify."	
						MessageBox(is_title, ls_pandora_validation_error)	
						exit	//   Exit loop as soon as error condition occurs
					End If
				End If	
/**********/
			Next
			Destroy ldsOwners
		End If
	End If	

//GailM 3/10/2020 DE15091 Google IB save validation of SN with qty GT 1
If idw_putaway.RowCount() > 0 then
	FOR i_indx = 1 to idw_putaway.RowCount()
		lsSerializedInd =  idw_putaway.GetItemString(i_indx, 'serialized_ind' )
		lsSerialNo = idw_putaway.GetItemString(i_indx, 'serial_no' )
		llQty = idw_putaway.GetItemNumber(i_indx, 'quantity' )
		If (lsSerializedInd = 'Y' or lsSerializedInd = 'B') and llQty > 1 and lsSerialNo <> '-' Then
			ls_pandora_validation_error = "Serial number " + lsSerialNo + " at Row " + String(i_indx) + " has a quantity above 1.~n~rRow cannot have a quantity above 1 and a serial number.~n~r~n~r     Please research this condition and rectify."	
			MessageBox(is_title, ls_pandora_validation_error)	
			exit	//   Exit loop as soon as error condition occurs
		End If
	Next
End If 
// End DE15091



Return ls_pandora_validation_error
end function

public function integer wf_refresh_qa_check_ind (string as_sku, string as_supp_code, long al_owner_id);long			ll_find
long			ll_end
string			ls_qa_check_ind
string			ls_orig_qa_check_ind

// Get qa_check_ind from database incase value has changed in item master
SELECT QA_CHECK_IND
    INTO :ls_qa_check_ind
   FROM ITEM_MASTER
  WHERE PROJECT_ID = :gs_project
      AND SKU = :as_sku
      AND SUPP_CODE = :as_supp_code
      AND OWNER_ID = :al_owner_id
  USING SQLCA;

IF sqlca.sqlcode <> 0 THEN
	
	RETURN -1
	
END IF

// Check for update of qa_check_ind on Order Detail

ll_end = idw_detail.RowCount() + 1

ll_find = 1

ll_find = idw_detail.Find("SKU = '" + as_sku + "' AND SUPP_CODE = '" + as_supp_code + "' AND owner_id = " + String( al_owner_id),ll_find, ll_end)

DO WHILE ll_find > 0

	ls_orig_qa_check_ind = idw_detail.GetItemString( ll_find, 'qa_check_ind' )

	IF ls_orig_qa_check_ind <> ls_qa_check_ind THEN
	
		// Set qa_check_ind with value from database 
		idw_detail.SetItem( ll_find, 'qa_check_ind', ls_qa_check_ind )
		
	END IF

     // Search again

     ll_find++

     ll_find = idw_detail.Find("SKU = '" + as_sku + "' AND SUPP_CODE = '" + as_supp_code + "' AND owner_id = " + String( al_owner_id),ll_find, ll_end)

LOOP

// Check for update of qa_check_ind on Putaway

ll_end = idw_putaway.RowCount() + 1

ll_find = 1

ll_find = idw_putaway.Find("SKU = '" + as_sku + "' AND SUPP_CODE = '" + as_supp_code + "' AND owner_id = " + String( al_owner_id),ll_find, ll_end)

DO WHILE ll_find > 0

	ls_orig_qa_check_ind = idw_putaway.GetItemString( ll_find, 'qa_check_ind' )

	IF ls_orig_qa_check_ind <> ls_qa_check_ind THEN
	
		// Set qa_check_ind with value from database 
		idw_putaway.SetItem( ll_find, 'qa_check_ind', ls_qa_check_ind )
		
	END IF

     // Search again

     ll_find++

     ll_find = idw_putaway.Find("SKU = '" + as_sku + "' AND SUPP_CODE = '" + as_supp_code + "' AND owner_id = " + String( al_owner_id),ll_find, ll_end)

LOOP

RETURN 1

end function

public function integer wf_check_status_emc ();//*****************************************//
//MStuart - babycare emc functionality                            //
//****************************************//

//cb_emc enabled or visible also set in postopen event
		

////********************************************************
////USED for TESTing if NEEDED - don't delete
////********************************************************
//string ord_type, ord_status
//
//ord_type = idw_main.object.ord_type[1]
//ord_status = idw_main.object.ord_status[1]
//
//
//messagebox(" wf_check_status_emc", &
//					+"~n~r"+ "main ord type" +' '+ord_type+' ' &
//							+"~n~r"+ "main ord status" +' '+ord_status+' ' &
//							+"~n~r"+ "Modified Cnt." +' '+string(idw_putaway.ModifiedCount()) )
//							
//							
//						
//
////***********************************************************
////*********************END***********************************
		
		
//************************************************************\\
//************************************************************\\
//							BabYCare Requirements for enable cb_emc			                      
//																										     
//		idw_main.object.ord_type[1]  = I				 				      
//      idw_main.object.ord_status[1] = process(putaway list exists)		               
//   	idw_putaway.ModifiedCount() = 0(putaway saved)
// 		then enable emc cb				                                                                      
//************************************************************* \\
//************************************************************* \\
integer row_cnt

SELECT  COUNT(*)
INTO :row_cnt
    FROM  Item_Master,   
              Receive_Putaway  
   WHERE ( Receive_Putaway.SKU = Item_Master.SKU and 
			   Item_Master.Supp_Code = Receive_Putaway.Supp_Code and
			   upper(Item_MAster.User_Field1) = 'Y' and
                Item_Master.Project_ID = :gs_project and  
			   Receive_Putaway.RO_No = :is_rono)  ;
  
If row_cnt = 0 Then
	tab_main.Tabpage_putaway.cb_emc.enabled = FALSE
	Return 0
End If


//order type I, putaway or above, and putaway saved(no pending changes) enable cb_emc	
If idw_putaway.RowCount() > 0 Then
											
	If  idw_main.object.ord_type[1] = 'I' and &	 
		idw_main.object.ord_status[1] = 'P' and &
					 idw_putaway.ModifiedCount() = 0 Then
		
		tab_main.Tabpage_putaway.cb_emc.enabled = TRUE
	Else
		tab_main.Tabpage_putaway.cb_emc.enabled = FALSE
	End If

Else
	tab_main.Tabpage_putaway.cb_emc.enabled = FALSE
End If

Return 1
end function

public function integer uf_config_custom_buttons ();
tab_main.tabpage_main.cb_custom1.visible = False
tab_main.tabpage_main.cb_custom2.visible = False

Choose Case upper(gs_project)
		
	Case 'NIKE-SG',  'NIKE-MY'
		
		tab_main.tabpage_main.cb_custom1.visible = True
		tab_main.tabpage_main.cb_custom2.visible = True
		
		tab_main.tabpage_main.cb_custom1.Text = 'Recv Reprt'
		tab_main.tabpage_main.cb_custom2.Text = 'Tally Sheet'
		
	Case 'STBTH'
		
		tab_main.tabpage_main.cb_custom1.visible = True
		tab_main.tabpage_main.cb_custom1.Enabled = True
		tab_main.tabpage_main.cb_custom1.Text = 'Print PO'
		
	Case Else	
	
		if left(upper(gs_project), 2) =  'WS' then
		
			tab_main.tabpage_main.cb_custom1.visible = True
			tab_main.tabpage_main.cb_custom1.Text = 'Custom Permit Declaration Export'
			tab_main.tabpage_main.cb_custom1.Width = 950
			tab_main.tabpage_main.cb_custom1.x = 100
			
		end if

// SARUN2014MAY12 : WS-PR Inbound Export
		if upper(gs_project) =  'WS-PR' then

				tab_main.tabpage_main.cb_custom2.Text = 'Export'

		end if

		
End Choose

Return 0
end function

public function integer uf_print_nike_receiving_rpt ();// 11/11 - PCONKL - Imported from Nike EWMS

OLEObject xl, xs
String filename,ls
String lineout[1 to 11]
String prev_sku, curr_sku, lsSku, lsSuppCode, lsCatType
String ls_type, ls_descript,ls_putloc
Long i, ll_cnt, pos,ll_putaway_rowcnt,ll_findrow, llLineItem
Long ll_qty, ll_alloc
Long ll_qty_sub, ll_alloc_sub, ll_damage_sub
Long ll_qty_tot, ll_alloc_tot, ll_damage_tot
String dummy,ls_sku,ls_sap_po_no,ls_inbound_delivery_no,ls_inbound_delivery_sub_item_no

If idw_main.RowCOunt() = 0 Then return 0

SetPointer(HourGlass!)

ll_cnt 	 = idw_detail.RowCount()
ll_putaway_rowcnt = idw_putaway.RowCount()

If ll_cnt <= 0 Then
	MessageBox("", "No Detail records found for Receiving Report!")
	Return - 1
End If

SetMicroHelp("Opening Excel ...")
filename = ProfileString(gs_inifile,"sims3","syspath","") + "Reports\RcvRpt.xls"
//filename ="c:\sims-test\reports\RcvRpt.xls"

If not FileExists(fileName) Then
	messageBox('Not Found','Excel Template: ' + fileName + " Not found.")
	Return -1
End If

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

ls_type = idw_main.GetItemString(1,"inventory_type")

Select inv_type_desc 
	Into :ls_descript 
	From inventory_type 
	Where project_id = :gs_project and inv_type = :ls_type;

xs.cells(1,1).Value = "Printed on: " + String(Today(),"mm/dd/yyyy hh:mm")
xs.cells(4,1).Value = "Receive No.: " + idw_main.GetItemString(1,"supp_invoice_no")
xs.cells(4,3).Value = "Order Date: " + String(idw_main.GetItemDateTime(1,"ord_date"),"mm/dd/yyyy hh:mm")
xs.cells(4,5).Value = "Complete Date: " + String(idw_main.GetItemDateTime(1,"complete_date"),"mm/dd/yyyy hh:mm")
xs.cells(4,8).Value = "Actual Receipt Date: " + String(idw_main.GetItemDateTime(1,"request_date"),"mm/dd/yyyy hh:mm")
xs.cells(5,1).Value = "Warehouse: " + idw_main.GetItemString(1,"wh_code")
xs.cells(5,3).Value = "Inventory Type: " + ls_descript

If Not isnull( idw_main.GetItemString(1,"user_Field8")) Then
	xs.cells(5,5).Value = "Vessel: " + idw_main.GetItemString(1,"user_Field8")
Else
	xs.cells(5,5).Value = "Vessel: "
End If

If Not isnull(idw_main.GetItemString(1,"remark")) Then
	xs.cells(6,1).Value = "Remark: " + idw_main.GetItemString(1,"remark")
Else
	xs.cells(6,1).Value = "Remark: "
End If

If Not isnull(idw_main.GetItemNumber(1,"ctn_cnt")) Then
	xs.cells(6,3).Value = "No. of Ctn.: " + String(idw_main.GetItemNumber(1,"ctn_cnt"))
Else
	xs.cells(6,3).Value = "No. of Ctn.: "
End If

If Not isnull(idw_main.GetItemString(1,"user_Field6")) Then
	xs.cells(7,3).Value = "Freight cost(SGD): " +idw_main.GetItemString(1,"user_Field6")
Else
	xs.cells(7,3).Value = "Freight cost(SGD): "
End If

If Not isnull(idw_main.GetItemString(1,"ship_ref")) Then
	xs.cells(6,5).Value = "Ship Ref: " + String(idw_main.GetItemString(1,"ship_ref"))
Else
	xs.cells(6,5).Value = "Ship Ref: "
End If

If Not isnull( idw_main.GetItemString(1,"user_Field7")) Then
	xs.cells(7,5).Value = "Other cost(SGD): " + idw_main.GetItemString(1,"user_Field7")
Else
	xs.cells(7,5).Value = "Other cost(SGD): "
End If

xs.cells(8,3).Value = "ETA Date: " + String(idw_main.GetItemDateTime(1,"arrival_date"),"mm/dd/yyyy hh:mm")

If Not isnull(idw_main.GetItemString(1,"user_Field10")) Then
	xs.cells(8,5).Value = "Doc Rcv'd Date: " +  idw_main.GetItemString(1,"user_Field10")
Else
	xs.cells(8,5).Value = "Doc Rcv'd Date: "
End If

If Not isnull(idw_main.GetItemString(1,"supp_order_no")) Then
	xs.cells(9,3).Value = "Shipment No: " + idw_main.GetItemString(1,"supp_order_no")
Else
	xs.cells(9,3).Value = "Shipment No: "
End If

If Not isnull( idw_main.GetItemString(1,"awb_bol_no")) Then
	xs.cells(9,5).Value = "BOL NO: " + idw_main.GetItemString(1,"awb_bol_no")
Else
	xs.cells(9,5).Value = "BOL NO: "
End If

If not isnull(idw_main.GetItemString(1,"user_Field11")) Then
	xs.cells(9,10).Value = "REF NO: " + idw_main.GetItemString(1,"user_Field11")
Else
	xs.cells(9,10).Value = "REF NO: " 
End If


	
pos = 10
idw_detail.Sort()
ll_qty_sub = 0
ll_alloc_sub  = 0
ll_damage_sub = 0
ll_qty_tot = 0
ll_alloc_tot  = 0
ll_damage_tot = 0
For i = 1 to ll_cnt
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	curr_sku = Left(idw_detail.GetItemString(i,"sku"),10)
	If curr_sku <> prev_sku and i <> 1 Then
		pos += 1 
		xs.rows(pos + 1).Insert
		lineout[1] = ""
		lineout[2] = ""
		lineout[3] = ""
		lineout[4] = ""
		lineout[5] = ""
		lineout[6] = ""
		lineout[7] = "Sub-total:"
		lineout[8] = String(ll_qty_sub)
		lineout[9] = String(ll_alloc_sub)
		lineout[10] = ""
		lineout[11] = String(ll_alloc_sub  - ll_qty_sub)
		xs.range("a" + String(pos) + ":k" +  String(pos)).Value = lineout
		ll_qty_sub = 0
		ll_alloc_sub  = 0
		ll_damage_sub = 0
	End If
	pos += 1
	xs.rows(pos + 1).Insert
	ll_qty 			=idw_detail.GetItemNumber(i,"req_qty")
	ll_alloc 		= idw_detail.GetItemNumber(i,"alloc_qty")
	ll_qty_sub 		+= ll_qty
	ll_alloc_sub 	+= ll_alloc
	ll_qty_tot 		+= ll_qty
	ll_alloc_tot 	+= ll_alloc
	
	if ll_putaway_rowcnt > 0 then
		
		// PCONKL - Find Putaway row based on Line ITem and SKU instead
		ls_sku 	= idw_detail.GetItemString(i,"sku")
		llLineItem = idw_detail.GetITemNumber(i,'line_item_no')
		
		ll_findrow = idw_Putaway.Find("Line_item_no = " + string(llLineItem) + " and sku = '" + ls_sku + "'",1,idw_putaway.RowCount())
		
		//ls_sap_po_no 				= idw_detail.GetItemString(i,"sap_po_no")
//		ls_sap_po_no 				= idw_main.GetItemString(1,"supp_order_no")
//		ls_inbound_delivery_no 	= idw_detail.GetItemString(i,"User_Field2")
//		ls_inbound_delivery_sub_item_no = idw_detail.GetItemString(i,"User_Field3")
//		ls = "sku = '" + ls_sku + "' and sap_po_no = '" + ls_sap_po_no + "' and inbound_delivery_no = '" + ls_inbound_delivery_no + "' and inbound_delivery_sub_item_no = '" + ls_inbound_delivery_sub_item_no + "'"
//		ll_findrow		 = idw_putaway.Find("sku = '" + ls_sku + "' and sap_po_no = '" + ls_sap_po_no + "' and inbound_delivery_no = '" + ls_inbound_delivery_no + "' and inbound_delivery_sub_item_no = '" + ls_inbound_delivery_sub_item_no + "'", 1, ll_putaway_rowcnt)
//		
		If ll_findrow > 0 Then
			ls_putloc       = String(idw_putaway.GetItemString(ll_findrow,"l_code"),"@@@-@@-@@")
		Else
			ls_putloc = ''
		End If
		
	end if
	
		
	lineout[1] 		= String(i)
	lineout[2] 		= String(idw_detail.GetItemString(i,"sku"))
	lineout[3] 		= ls_putloc
	
	// 03/2612 - PCONKL - needs to come from UF5 (SAP PO Nbr) 
//	lineout[4]		= idw_detail.GetItemString(i,"sap_po_no")
	//lineout[4] 		=	idw_main.GetItemString(1,"supp_order_no")
	lineout[4] 		= idw_detail.GetItemString(i,"User_Field5")
	
	lineout[5] 		= idw_detail.GetItemString(i,"User_Field2")
	lineout[6] 		= idw_detail.GetItemString(i,"User_Field3")
	
//	lineout[7] 		= idw_detail.GetItemString(i,"coo")

	If ll_findrow > 0 Then
		lineout[7] = idw_putaway.getITemString(ll_findRow,'country_of_origin')
	End If
	
	lineout[8] 		= String(ll_qty)
	lineout[9] 		= String(ll_alloc)

	lsSku = idw_detail.GetItemString(i,"sku")
	lsSuppCode = idw_detail.GetItemString(i,"supp_code")
	
	select user_field9 into :lsCatType from item_master where project_Id = :gs_project and sku = :lsSku and supp_code = :lsSuppCode USING SQLCA;

	lineout[10] 		= lsCatType
	
	lineout[11] 		= String(ll_alloc  - ll_qty)
	xs.range("a" + String(pos) + ":k" +  String(pos)).Value = lineout
	prev_sku = curr_sku
	
Next

pos += 1
lineout[1] = ""
lineout[2] = ""
lineout[3] = ""
lineout[4] = ""
lineout[5] = ""
lineout[6] = ""
lineout[7] = "Sub-total:"
lineout[8] = String(ll_qty_sub)
lineout[9] = String(ll_alloc_sub)

lineout[10] 		= ""

lineout[11] = String(ll_alloc_sub - ll_qty_sub)
xs.range("a" + String(pos) + ":k" +  String(pos)).Value = lineout
pos += 1
lineout[5] = ""
lineout[6] = ""
lineout[7] = "Total:"
lineout[8] = String(ll_qty_tot)
lineout[9] = String(ll_alloc_tot)

lineout[10] 		= ""

lineout[11] = String(ll_alloc_tot  - ll_qty_tot)
xs.range("a" + String(pos) + ":k" +  String(pos)).Value = lineout

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()


Return 0
end function

public function integer uf_print_nike_tally_sheet ();
//11/11 - PCONKL - Imported from EWMS

OLEObject xl, xs
String filename, sql_syntax, lsRONO, ERRORS
String lineout[1 to 4]
String prev_sku, curr_sku
Long i, ll_cnt, pos
Long ll_qty

Datastore	ldsTallySheet

SetPointer(HourGlass!)

If idw_main.RowCOunt() = 0 Then return 0

lsRONO = idw_main.GetItemString(1,"ro_no")

ldsTallySheet = Create DataStore

sql_syntax = " Select sku, sum(req_qty) qty from receive_Detail where ro_no = '" + lsRONO + "' Group by SKU order by SKU;"
ldsTallySheet.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   messagebox("","Unable to create datastore for Tallysheet data." + Errors)
   RETURN - 1
END IF

ldsTallySheet.SetTransObject(SQLCA)
ldsTallySheet.retrieve()
ll_cnt 	= ldsTallySheet.RowCount()


If ll_cnt <= 0 Then
	MessageBox("", "No Detail records found for TallySheet!")
	Return - 1
End If

SetMicroHelp("Opening Excel ...")
filename = ProfileString(gs_inifile,"sims3","syspath","") + "Reports\Inbound_Tally_Sheet.xls"

If not FileExists(fileName) Then
	messageBox('Not Found','Excel Template: ' + fileName + " Not found.")
	Return -1
End If

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)

SetMicroHelp("Printing report heading...")

xs.cells(8,9).Value = idw_main.GetItemString(1,"supp_invoice_no")
xs.cells(10,9).Value = idw_main.GetItemString(1,"supp_order_no")
	
pos = 12
ldsTallySheet.setSort('sku')
ldsTallySheet.Sort()

For i = 1 to ll_cnt
	
	SetMicroHelp("Exporting to Excel line " + String(i) + " of " + String(ll_cnt))
	curr_sku = ldsTallySheet.GetItemString(i,"sku")
	pos += 1   
   xs.cells(pos,1).value = i  
	ll_qty 			= ldsTallySheet.GetItemNumber(i,"qty")
	lineout[1] 		= String(mid(curr_sku,1,10))
	lineout[2] 		= String(mid(curr_sku,12,18))
	xs.range("b" + String(pos) + ":c" +  String(pos)).Value = lineout
	xs.cells(pos,4).Value = ll_qty
	prev_sku = curr_sku
	If i + 2  <= ll_cnt Then xs.rows(pos + 1).Insert  
	
Next

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()


Return 0
end function

public function date wf_calculate_rdd (date as_date, string as_wh_code, string as_cust_code, string as_from_wh_code, ref string as_message);
//TimA 11/17/11
//Pandora issue #287
Integer li_DayOfWeek
Integer li_Sunday, li_Saturday
String ls_IB_City, ls_IB_State,ls_IB_Customer_type, ls_IB_Cust_Code, ls_IB_SIMS_WH, ls_IB_Loc_wh,  ls_IB_Country
String ls_OB_City, ls_OB_State,ls_OB_Customer_type, ls_OB_Cust_Code, ls_OB_SIMS_WH, ls_OB_Loc_wh,  ls_OB_Country, Country_Ind

Date ld_NewRddDate,ld_RequestDate

Integer i, li_Days, li_daynumber, li_DaysOut, li_Counter

Date ldRequestDatePlus7 //7 Days Warehouse Transfer Domestic Outbound
Date ldRequestDatePlus9 //9 Warehouse Transfer International Outbound
Date ldRequestDatePlus1 //1 Day Local Warouse

//Get the Inbound Warehouse information
select City, State,Customer_type,Cust_Code, User_Field2, User_Field4,  Country 
Into :ls_IB_City, :ls_IB_State,:ls_IB_Customer_type, :ls_IB_Cust_Code, :ls_IB_SIMS_WH, :ls_IB_Loc_wh,  :ls_IB_Country 
from Customer 
where project_id = 'PANDORA' 
and Cust_Code = :as_Cust_Code;

//Get the Outbound Warehouse information
select City, State,Customer_type,Cust_Code, User_Field2, User_Field4,  Country 
Into :ls_OB_City, :ls_OB_State,:ls_OB_Customer_type, :ls_OB_Cust_Code, :ls_OB_SIMS_WH, :ls_OB_Loc_wh,  :ls_OB_Country 
from Customer 
where project_id = 'PANDORA' 
and Cust_Code = :as_from_wh_code;


If IsNull(ls_IB_Country) or ls_IB_Country = '' then
	as_Message = 'Could not find the country for the inbound customer code  in the Customer table'
	Return as_Date
end if
If IsNull(ls_OB_Country) or ls_OB_Country = '' then
	as_Message = 'Could not find the country for the outbound customer code in the Customer table'
	Return as_Date	
end if
If IsNull(ls_IB_Customer_type) or ls_IB_Customer_type = '' then
	as_Message = 'Could not find the Customer Type for the inbound customer code in the Customer table'	
	Return as_Date	
end if
If IsNull(ls_OB_Customer_type) or ls_OB_Customer_type = '' then
	as_Message = 'Could not find the Customer Type for the outbound customer code in the Customer table'		
	Return as_Date	
end if




If ls_IB_Country = ls_OB_Country and ls_IB_Customer_type = ls_OB_Customer_type then
	//7 Days Warehouse Transfer Domestic Outbound
	//Countries are the same and they are the same WH type
	//li_Days = 7
	//TimA 
	//Change to 5 days per Ian 06/07/12
	li_Days = 5
Elseif	ls_IB_Country <> ls_OB_Country and ls_IB_Customer_type = ls_OB_Customer_type then
	//9 Warehouse Transfer International Outbound
	//Countries are different and they are the same WH type
		//TimA 05/07/12
		//If the country EU Ind is yes on both IB and OB countries then the RDD in only 5 days.
		Select EU_Country_Ind INTO :Country_Ind From Country where Designating_Code = :ls_IB_Country;
		//Check the first inbound country
		If Country_Ind = 'Y' then
			Select EU_Country_Ind INTO :Country_Ind From Country where Designating_Code = :ls_OB_Country;
			//Check the outbound cointry
			If Country_Ind = 'Y' then
				li_Days = 5
			Else
				li_Days = 9
			End if
		Else
			//First country did have the EU desination so don't test the second and mke it 9 days.
			li_Days = 9
		End if
ElseIf ls_IB_Country = ls_OB_Country and ls_IB_Customer_type <> ls_OB_Customer_type then
	//1 Day Local Warouse
	//Same Country but the local WH
		li_Days = 1
End if

li_DayOfWeek = DayNumber (as_Date)

FOR i = 1 TO li_Days
	li_DaysOut ++
    li_daynumber = DayNumber(RelativeDate(date(as_Date), li_DaysOut))
	 IF li_daynumber = 1 OR li_daynumber = 7 THEN
		i --
	end if

NEXT

ld_RequestDate = RelativeDate ( as_Date, li_DaysOut )

li_DayOfWeek = DayNumber (ld_RequestDate)

If li_DayOfWeek >1 and li_DayOfWeek < 7  then
	//Monday-Friday
	ld_NewRddDate = ld_RequestDate
else
	//If the day of the week is Saurday then we only need to add two days
	If li_DayOfWeek = 7 then
		li_DayOfWeek = 2
	end if
	ld_NewRddDate = RelativeDate ( ld_RequestDate, li_DayOfWeek )
	
End if
Return ld_NewRddDate
end function

public function integer wf_export_ws_tradenet ();
string lsDetailOutString, lsTemp, lsMasterOutString
string lsDelimitChar = ','
integer liFileRowNum = 0
integer liIdx
string lsSku, lsSupp_Code, lsHS_Code, lsDescription, ls_IM_User_field9, lsSupp_Name
string ls_UOM2, ls_UOM1
long ll_QTY2, llDetailFindRow, llLineItemNo
datastore idsOut
long llNewBatchSeq
datetime ldt_filerundate

string ls_path, ls_file

int li_rc


//li_rc = GetFileSaveName ( "Save Location",    ls_path, ls_file, "DOC",   "All Files (*.*),*.*" , "",    32770)
//
//
//
//IF li_rc = 1 Then
//
//   MessageBox ("ok", ls_file)
//	
//Else 
//	
//	Return 0
//
//End If

string lsPathOut, lsFileOutHeader, lsFileOutDetail
integer liFileNoHeader, liFileNoDetail



if idw_putaway.RowCount() <= 0  or idw_detail.RowCount() <= 0 then
	
	MessageBox ("Error", "The are no detail of putaway rows. Both must be completed for export.")
	Return 0
	
end if


//The path is stored in the lookup_table and is project dependant.

Select Code_Descript INTO :lsPathOut FROM lookup_table with (NoLock) 
	Where Project_ID = :gs_project AND Code_Type = 'CUSEXPPATH' USING SQLCA;

//MessageBox ("ok", lsPathOut)

If IsNull(lsPathOut) then lsPathOut = "C:\Export_Tradenet"


//INP00 = Header
//INP40 = Detail
//Orderno will be the order number from sims.
//Seq will be a sequence number.  
//This is needed because there is a limit of 50 rows on a file.  If there are more than 50 rows on an order we will increment the sequence for each 50 items.
//Date will have the date/time the file is created.  
//3.	Tradenet has a limit of 50 detail records per file.   If an order has more than 50 rows we need to actually split it into multiple files with a different Sequence for example Inbound order $$HEX1$$1c20$$ENDHEX$$1234$$HEX2$$1d202000$$ENDHEX$$has 130 detail rows.  We would create 6 output files
//INP00 1234 001 20120728143000.dat 

ldt_filerundate = datetime(today(), now())

string lsOrderNo

lsOrderNo = idw_main.GetItemString( 1, "supp_invoice_no")

liFileRowNum = 50

for liIdx = 1 to idw_putaway.RowCount()

	lsDetailOutString = ""

	liFileRowNum = liFileRowNum + 1
	
	if liFileRowNum > 50 then
		
		liFileRowNum = 1
				
		//Get the Next Batch Seq Nbr - Used for all writing to generic tables   (Use same across all projects.)
		llNewBatchSeq =  g.of_next_db_seq('WS-','Customs_Export','Seq_No')
		If llNewBatchSeq <= 0 Then
			MessageBox ("DB Error",  "*** Unable to retrieve the next available sequence number!")
			Return -1
		End If
	
		
		if liFileNoHeader > 0 then
			FileClose(liFileNoHeader)
			FileClose(liFileNoDetail)
		end if
		
		lsFileOutDetail = "INP40"+lsOrderNo+ String(llNewBatchSeq) + string( ldt_filerundate,'yyyymmddhhss')  + "00" +  ".dat"
		
		lsFileOutHeader = "INP00"+lsOrderNo+ String(llNewBatchSeq) + string( ldt_filerundate,'yyyymmddhhss')  + "00" +  ".dat"
	
		
		liFileNoHeader = FileOpen(lsPathOut + "\" +  lsFileOutHeader,LineMode!,Write!,LockREadWrite!,Replace!,EncodingUTF8!)
		liFileNoDetail = FileOpen(lsPathOut + "\" + lsFileOutDetail,LineMode!,Write!,LockREadWrite!,Replace!,EncodingUTF8!)
		
		if liFileNoHeader < 0 or liFileNoDetail < 0 then
			MessageBox ("Error", "Unable to open file.")
			Return 0
		end if
		
		//Create Header File
		
		//MsgSq	Char(12)	1.99706E+11	N	message sequence	Date = todays date. SeqNo must be taken from field# 2.	Todays date(yyyymmdd) + Sequence # starting with 9097.  We need a new output file for each 50 details
		//<Date+SeqNo>	
		
		lsMasterOutString = String(ldt_filerundate, 'yyyymmdd') + String(llNewBatchSeq) +  lsDelimitChar	
		
		//SeqNo	Int(4)	0001..0002	N	sequence number	default value = 9097	starting with 9097.  We need a new output file for each 50 details.  This is a Header level Sequence Number
	
		lsMasterOutString += String(llNewBatchSeq) +  lsDelimitChar			
		
		//MsgDate	Date	DD/MM/YYYY	N	date of declaration	todays date	Todays date(mm/dd/yyyy)
		
		lsMasterOutString += String(today(), "DD/MM/YYYY") +  lsDelimitChar

//		Removed per Carol Wong		
//		//DecType	Char(3)		Y	declaration type	"if II permit - default value = APS
//		
//		lsMasterOutString += String(today(), "DD/MM/YYYY") +  lsDelimitChar		
	
		//if EX permit - default value = GTR"	 'APS'
		
		lsMasterOutString +=  'APS' +  lsDelimitChar		
		
		//CargoPkg	Char(2)		Y	cargo packing type		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//TempimpE	Date	DD/MM/YYYY	Y	End date of temp. import Date		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//TtQtyUnt	Char(3)		Y	total outer pack unit	default value = CTN	CTN'
		
		lsMasterOutString +=  'CTN' +  lsDelimitChar
		
		//TtQty	Numeric(15,4)		Y	total outer pack quantity		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//TtGWtUnt	Char(3)		Y	total gross weight unit		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//TtGWt	Numeric(15,4)		Y	total gross weight quantity		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//WtOutVes	Numeric(13,2)		Y	tonnage of outward vesssel		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//Extvalidity	Char(1)		Y	Reason for extension of validity date (STDID)		<blank>
		
		lsMasterOutString +=   lsDelimitChar	
		
		//Receiptid1	Char(17)		Y	receipient mailbox id		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//Receiptid2	Char(17)		Y	recipient mailbox id		<blank>

		lsMasterOutString +=   lsDelimitChar		
		
		//Receiptid3	Char(17)		Y	$$HEX1$$1820$$ENDHEX$$MR$$HEX4$$1920200013202000$$ENDHEX$$receipient mailbox id		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//Suppind	Char(1)		Y	Supply Indicator (STDID)		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//Prevpmt	Char(11)		Y	Previous Permit Number		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//AECode	Char(20)		Y	Declaring CR No	default value = 200201226C	 '200201226C'
		
		lsMasterOutString +=  '200201226C' +  lsDelimitChar
		
		//AENm1	Char(35)		Y	Name 1	default value = MENLO WORLDWIDE ASIA PACIFIC PTE LTD	 'MENLO WORLDWIDE ASIA PACIFIC PTE LTD'
		
		lsMasterOutString +=  'MENLO WORLDWIDE ASIA PACIFIC PTE LTD' +  lsDelimitChar
		
		//AENm2	Char(35)		Y	Name 2		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//AENm3	Char(35)		Y	Name 3		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CGCode	Char(20)		Y	Inward Carrier Agent CR		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CGNm1	Char(35)		Y	Name 1		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CGNm2	Char(35)		Y	Name 2		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CGNm3	Char(35)		Y	Name 3		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CACode	Char(20)		Y	Outward Carrier Agent CR		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CANm1	Char(35)		Y	Name 1		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CANm2	Char(35)		Y	Name 2		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CANm3	Char(35)		Y	Name 3		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CCCode	Char(20)		Y	Claimant CR		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CCNm1	Char(35)		Y	Name 1		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CCNm2	Char(35)		Y	Name 2		<blank>
		
		lsMasterOutString +=   lsDelimitChar		
		
		//CCNm3	Char(35)		Y	Name 3		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//IMCode	Char(20)		Y	Importer CR	"depend on order. All customers use their own CR# except Pernod Ricard Singapore.
		//Do not maintain customer CR# in the customer profile."	TBD - Possible User_Field on Receive_Master or Supplier.
		
		lsMasterOutString +=   lsDelimitChar
		
		//IMNm1	Char(35)		Y	name1	depend on order. Value = Customer Name	Supplier.Supp_Name from Receive_Master.Supp_Code
		
		lsSupp_Code = idw_main.GetItemString( 1, "Supp_Code")
		
		Select Supp_Name
		INTO  :lsSupp_Name
			From Supplier with (nolock)
			WHERE Supp_Code =:lsSupp_Code AND
					  Project_ID = :gs_project USING SQLCA;
		
		if IsNull(lsSupp_Name) then lsSupp_Name = ''
		
		lsMasterOutString +=   lsSupp_Name +  lsDelimitChar
		
		//IMNm2	Char(35)		Y	name2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//EXCode	Char(20)		Y	EX CR number		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//EXNm1	Char(35)		Y	name1		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//EXNm2	Char(35)		Y	name2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//FWCode	Char(20)		Y	Freight Forwarder CR		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//FWNm1	Char(35)		Y	name1		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//FWNm2	Char(35)		Y	name2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//FWNm3	Char(35)		Y	Name3		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CNNm1	Char(35)		Y	name1		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CNNm2	Char(35)		Y	name2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CNAdd1	Char(35)		Y	consignee address 1		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CNAdd2	Char(35)		Y	consignee address 2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CNAdd3	Char(35)		Y	consignee address 3		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//RelCode	Char(7)		Y	place of release code	default value = LW274	LW274'

//      Changed per Carol Wong
//		lsMasterOutString +=  'LW274' +  lsDelimitChar

		lsMasterOutString +=  'KZ' +  lsDelimitChar

//      Changed per Carol Wong		
		//RelLocNAD	Char(105)		Y	place of release name and address1	default value = MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY	MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY'

//		lsMasterOutString +=  'MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY' +  lsDelimitChar
			
		lsMasterOutString +=  'KEPPEL FTZ' +  lsDelimitChar
			
			
		//RecCode	Char(7)		Y	place of receipt	default value = LW274	LW274'
		
		lsMasterOutString +=  'LW274' +  lsDelimitChar
		
		//RecLocNAD	Char(105)		Y	place of receipt name and  add1	default value = MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY	MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY'

		lsMasterOutString +=  'MENLO LOGISTICS WORLDWIDE ASIA PACIFIC PTE LTD 30 BOON LAY WAY' +  lsDelimitChar
		
		//StorageCode	Char(7)		Y	place of storage code		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//BGInd	Char(1)		Y	bank guarantee indicator	default value = I	I'
		
		//Changed per Carol Wong
		
		lsMasterOutString +=  lsDelimitChar  // 'I' 
		
		//CCNric	Char(20)		Y	Claimant nric		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CCName1	Char(35)		Y	Claimant name1		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CCName2	Char(35)		Y	Claimant name2		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//CCName3	Char(35)		Y	Claimant name3		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//TtItems	Int(4)		Y	total no of items	depend on the total count of items in the order	Total Receive_Putaway
		
		//Changed per Carol
		
		lsMasterOutString +=  string( idw_putaway.RowCount()) +  lsDelimitChar  //idw_putaway.GetItemNumber (1, "compute_2")
		
		//UpdReq	Int(4)		Y	number of request for amendment		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//TtCifFob	Numeric(15,2)		Y	total cif/fob value	depend on order	TBD - I think this is Not Applicable on Inbound Material

		lsMasterOutString +=   lsDelimitChar
		
		//TtAmtPay	Numeric(15,2)		Y	total Amount payable	depend on order	TBD - I think this is Not Applicable on Inbound Material

		lsMasterOutString +=   lsDelimitChar
		
		//TtCedDut	Numeric(15,2)		Y	Total Ced Duty payable		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//TtExDut	Numeric(15,2)		Y	Total Excise Duty payable	depend on order	TBD - I think this is Not Applicable on Inbound Material
		
		lsMasterOutString +=   lsDelimitChar
		
		//TtGstPay	Numeric(15,2)		Y	Total Gst  payable	depend on order	TBD - I think this is Not Applicable on Inbound Material

		lsMasterOutString +=   lsDelimitChar
		
		//Blawb	Char(17)		Y	OBL or AWB		<blank>
		
		lsMasterOutString +=   lsDelimitChar
		
		//GoodType	Char(1)	P-Dutiable Petroleumn, , L-Liq/Tob, M-Dutiable Motor Vehicle,  N-Normal Goods	Y	For internal control of goods	default value = L	L'
		
		lsMasterOutString +=  'L' +  lsDelimitChar
		
		//Option	Char(1)	S-Storage, X-Seastore, G-GST Exemption, E-GST/Duty Exemption	Y	Internal controls.		<blank>
		
		
		lsMasterOutString +=   lsDelimitChar
				
				
		FileWrite(liFileNoHeader,lsMasterOutString)
		
		
	end if
	
	//Same as Header MSGSQ Todays date(yyyymmdd) + Sequence # starting with 9097.  We need a new output file for each 50 details
	
	//INP40 - HS Code information						
	//Field	Data Type	Format	NULL	Remarks	Values to be written in the file - Single/Multiple permit	
	//MsgSq	Char(12)	1.99706E+11	N	message sequence	follow the MsgSq in INP00 file	Same as Header MSGSQ Todays date(yyyymmdd) + Sequence # starting with 9097.  We need a new output file for each 50 details
	//		<Date+SeqNo>	
	
	lsDetailOutString = String(ldt_filerundate, 'yyyymmdd') + String(llNewBatchSeq) +  lsDelimitChar	
	
	//SerNo	Int(4)	1	N	serial number	is a serial# which starts from 1 & max up to 50. to be incremental by 1 for each line item	Actually a line number starting from 1 to 50.  We need a new output file for each 50 details so we start over with each output file

	lsDetailOutString += String(liFileRowNum) +  lsDelimitChar	
	
	//Need to grab a bunch of data from Item_Master
	//Will be used farther down
	
	lsSku = idw_putaway.GetItemString(liIdx, "sku")
	lsSupp_Code = idw_putaway.GetItemString(liIdx, "supp_code")
	llLineItemNo = idw_putaway.GetItemNumber(liIdx, "line_item_no")
	
	string ls_IM_User_field10, ls_IM_User_field1
	
	Select Description, HS_Code, User_field9, UOM_2, QTY_2, UOM_1, User_field10, User_field1
	INTO  :lsDescription, :lsHS_Code, :ls_IM_User_field9, :ls_UOM2, :ll_QTY2, :ls_UOM1, :ls_IM_User_field10, :ls_IM_User_field1
		From Item_Master with (nolock)
		WHERE Sku = :lsSku AND
				  Supp_Code =:lsSupp_Code AND
				  Project_ID = :gs_project USING SQLCA;
	
	
	string lsDutiable_UOM
	decimal ldGST_Rate
	
	//HSCode	Char(10)		Y	hscode	depend on order	Item Master.HS_Code
	
	IF IsNull(lsHS_Code) THEN 
		lsHS_Code = ""
	ELSE		
		Select Dutiable_UOM, GST_Rate
			INTO  :lsDutiable_UOM, :ldGST_Rate
			From hs_code_profile with (nolock)
			WHERE HS_Code =:lsHS_Code AND
					  Project_ID = :gs_project USING SQLCA;
	END IF
	
	lsDetailOutString += lsHS_Code +  lsDelimitChar
	
	//ItemDesc1	Char(35)		Y	item desc 1	depend on order & max char allowed is 35. If more than 35, display in next column.	Item Master.description(Pos 1-35)


	if IsNull(lsDescription) then lsDescription = ""
	
	lsDetailOutString += Left(lsDescription,35) +  lsDelimitChar
	
	//ItemDesc2	Char(35)		Y	item desc 2	same as above	Item Master.description(Pos 36-70)
	
	lsDetailOutString += Mid(lsDescription,36, 35) +  lsDelimitChar
	
	//ItemDesc3	Char(35)		Y	item desc 3	same as above	<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//ItemDesc4	Char(35)		Y	item desc 4	same as above	<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//ItemDesc5	Char(35)		Y	item desc 5	same as above	<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//Brand	Char(35)		Y	brand name		<blank>
	
	lsTemp = ls_IM_User_field10
	
	if IsNull(lsTemp) then lsTemp = ''
	
	lsDetailOutString += lsTemp + lsDelimitChar	
	
	//Model	Char(35)		Y	model name		<blank>
	
	lsDetailOutString += lsDelimitChar	
	
	//IMDGDesc	Char(1)	Indicator=$$HEX1$$1920$$ENDHEX$$Y$$HEX2$$19200900$$ENDHEX$$Y	dangerous goods indicator		<blank>
	
	lsDetailOutString += lsDelimitChar	
	
	//CtyCode	Char(2)		Y	country code (cty of origin)	depend on order	Receive_Putaway.Country_of_Origin
	
	lsTemp = idw_putaway.GetItemString(liIdx, "Country_of_Origin")
	
	if IsNull(lsTemp) then lsTemp = ""

	lsDetailOutString += lsTemp +  lsDelimitChar	
	
	//CurLot	Char(30)		Y	current lot number	depend on order	Receive_Putaway.Lot_No
	
	lsTemp = idw_putaway.GetItemString(liIdx, "Lot_No")
	
	if IsNull(lsTemp) then lsTemp = ""

	lsDetailOutString += lsTemp +  lsDelimitChar	
		
	//PrevLot	Char(30)		Y	previous lot number		<blank>
	
	lsDetailOutString += lsDelimitChar	
	
	//QtyUnt	Char(3)		Y	Item quantity unit	depend on order	Receive_Detail.User_Field2  (W&S sends in the UOM that inventory is reported in.  They are using cases and there may be 6 bottles per case.  We only store eaches in inventory.)

	llDetailFindRow = idw_detail.Find("Line_Item_No = " + String(llLineItemNo) + " and Upper(sku) = '" + upper(lsSKU) + "' and Upper(supp_code) = '" + upper(lsSupp_Code) + "'",1,idw_detail.RowCount())

//	if llDetailFindRow > 0 then
		
	lsTemp = lsDutiable_UOM // idw_detail.GetItemString(llDetailFindRow, "user_field2")

	if IsNull(lsTemp) then lsTemp = ""

	lsDetailOutString += lsTemp +  lsDelimitChar	
	
		
//	else
//		lsDetailOutString += lsDelimitChar
//	end if


	//Qty	Numeric(15,4)		Y	Item quantity	depend on order	"This is where it gets customized here is the formulat to determine what the QTY is that gets reported. Receive_Detail.User_Field1 has the number of units per UOM. 

	//if receive_detail.user_field2  = receive_detail.uom then QTY = receive_putaway.QTY Else  
	//QTY = receive_putaway.qty /( receive_detail.req_qty / dec(receive_detail.user_field1)
	
	if llDetailFindRow > 0 then
		
		//if receive_detail.user_field2  = receive_detail.uom then QTY = receive_putaway.QTY Else  
		
		if  trim(idw_detail.GetItemString(llDetailFindRow, "user_field2")) = trim(idw_detail.GetItemString(llDetailFindRow, "uom")) then
	
			lsTemp = string(idw_putaway.GetItemNumber(liIdx, "quantity"))
		
		else
		
			//QTY = receive_putaway.qty* dec(receive_detail.user_field1)"
			
			string lsDDUF1
			
			lsDDUF1 = idw_detail.GetItemString(llDetailFindRow, "user_field1")
			
			If IsNull(lsDDUF1) then lsDDUF1 = ''
			
			lsTemp = string(idw_putaway.GetItemNumber(liIdx, "quantity") * dec(lsDDUF1))
			
		
		end if
		
		If IsNull(lsTemp) then lsTemp = ""

		lsDetailOutString += lsTemp +  lsDelimitChar	
		
		
	else
		lsDetailOutString += lsDelimitChar
	end if	
	
		
	//TtDutQtyUnt	Char(3)		Y	total dutiable qty/wt/vol unit	depend on order	TBD - I think this is Not Applicable on Inbound Material
	
	lsDetailOutString += lsDutiable_UOM + lsDelimitChar	
	
	//TtDutQty	Numeric(15,4)		Y	total dutiable qty/wt/vol	depend on order	TBD - I think this is Not Applicable on Inbound Material
	
	if llDetailFindRow > 0 then
		
		//if receive_detail.user_field2  = receive_detail.uom then QTY = receive_putaway.QTY Else  
		
		if  trim(idw_detail.GetItemString(llDetailFindRow, "user_field2")) = trim(idw_detail.GetItemString(llDetailFindRow, "uom")) then
	
			lsTemp = string(idw_putaway.GetItemNumber(liIdx, "quantity"))
		
		else
		
			//QTY = receive_putaway.qty* dec(receive_detail.user_field1)"
		
			
			lsDDUF1 = idw_detail.GetItemString(llDetailFindRow, "user_field1")
			
			If IsNull(lsDDUF1) then lsDDUF1 = ''
			
			lsTemp = string(idw_putaway.GetItemNumber(liIdx, "quantity") * dec(lsDDUF1))
			
		
		end if
		
	else
		lsDetailOutString += lsDelimitChar
	end if			
		
		
	If IsNull(lsTemp) then lsTemp = ""

	lsDetailOutString += lsTemp +  lsDelimitChar	
	
	//UnitWtUnt	Char(3)		Y	dutiable wt/vol unit	depend on order	TBD - I think this is Not Applicable on Inbound Material
	
	lsDetailOutString += lsDutiable_UOM +  lsDelimitChar	
	
	//UnitWt	Numeric(15,4)		Y	Dutiable wt/vol per unit	depend on order	TBD - I think this is Not Applicable on Inbound Material
	
	IF IsNull(ls_IM_User_field1) THEN ls_IM_User_field1 = ""
	
	lsDetailOutString += ls_IM_User_field1 +   lsDelimitChar	
	
	//LiqPcUnt	Char(3)		Y	alcohol unit of mea.	depend on order	Item_Master.User_field9
		
	IF IsNull(ls_IM_User_field9) THEN ls_IM_User_field9 = ""
	
	lsDetailOutString += ls_IM_User_field9 +  lsDelimitChar
	
	//LiqPc	Numeric(6,3)		Y	alcohol percentage	depend on order	Receive_Putaway.PO_NO2
	
	lsTemp = idw_putaway.GetItemString(liIdx, "PO_NO2")
	
	if IsNull(lsTemp) then lsTemp = ""

	lsDetailOutString += lsTemp +  lsDelimitChar	

			
	//OuterQty	Numeric(8,0)		Y	outer pack qty	depend on order	1
	
	lsDetailOutString += "1" +  lsDelimitChar	
	
	//OuterUnt	Char(3)		Y	outer pack unit	depend on order	Item_Master.UOM2
	
	IF IsNull(ls_UOM2) THEN ls_UOM2 = ""
	
	lsDetailOutString += ls_UOM2 +  lsDelimitChar

	//InQty	Numeric(8,0)		Y	in pack qty	depend on order	Item_Master.QTY2

	IF IsNull(ll_QTY2) THEN ll_QTY2 = 0
	
	lsDetailOutString += String(ll_QTY2) +  lsDelimitChar	
	
	//InUnt	Char(3)		Y	in pack unit	depend on order	Item_Master.UOM1

	IF IsNull(ls_UOM1) THEN ls_UOM1 = ""
	
	lsDetailOutString += ls_UOM1 +  lsDelimitChar
	
	
	//InnerQty	Numeric(8,0)		Y	inner pack qty		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//InnerUnt	Char(3)		Y	inner pack unit		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//InmostQty	Numeric(8,0)		Y	inmost pack qty		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//InmostUnt	Char(3)		Y	inmost pack unit		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//MarkNo1	Char(17)		Y	marks and nos 1		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//MarkNo2	Char(17)		Y	marks and nos 2		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//MarkNo3	Char(17)		Y	marks and nos 3		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//ESDNP	Char(2)		Y	markings on dutiable goods - SNDP		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//CifFob	Numeric(15,2)		Y	cif/fob value in SGD	depend on order	receive_putaway.qty *  receive_putaway.po_no
	
//	lsTemp = idw_putaway.GetItemString(liIdx, "po_no")
//	
//	if IsNull(lsTemp) then lsTemp = ""
//
//	lsDetailOutString += lsTemp +  lsDelimitChar	

	

	if llDetailFindRow > 0 then
			
		lsTemp = string(idw_detail.GetItemDecimal(llDetailFindRow, "cost"))
	
	else
		
		lsTemp = ''
		
	end if
	
	if IsNull(lsTemp) then lsTemp = ''
		
	lsDetailOutString += lsTemp +  lsDelimitChar	
	
	//OthAmt	Numeric(15,2)		Y	Other amount		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//OthCurr	Char(3)		Y	currency of charge		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//OthExchg	Numeric(10,6)		Y	rate of exchange		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//UntPr	Numeric(15,4)		Y	unit price		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//UntPrCurr	Char(3)		Y	currency code		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//UntPrExchg	Numeric(10,6)		Y	exchange rate		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//LSP	Numeric(15,2)		Y	LSP value		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//InvNo	Char(17)		Y	invoice number		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//VehType	Char(3)		Y	default value = P. Waiting confirmation from SCS		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//MvReg	Char(17)		Y	motor vehicle registration number		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//Dt1stReg	Date		Y	date of first registration		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//EngCapQ	Char(3)	8	Y	Engine capacity qualifier		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//EngCap	Numeric(6,2)		Y	engine capacity		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//EngCapUnt	char(2)	CC / KW	Y	motor vehicle engine capacity/Power		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//BLAWBHI	Char(17)		Y	In House bl/awb No.		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//BLAWBHO	Char(17)		Y	Out House bl/awb No.		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//Dutytype	char(1)		Y	Duty type A/S/P	default value = P	P'
	
	lsDetailOutString += 'P' +  lsDelimitChar
	
	//TaxCedUnt	Char(3)		Y	Customs rate class unit		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//CedRt	Numeric(7,4)		Y	Customs duty rate		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//CedAmt	Numeric(15,2)		Y	Customs duty amt		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//TaxExUnt	Char(3)		Y	Excise rate class unit	default value = LP	LPA'
	
	lsDetailOutString +=   lsDelimitChar  // 'LPA' +
	
	//ExRt	Numeric(9,2)		Y	Excise duty rate	default value = 70	70
	
	lsDetailOutString += '70' +  lsDelimitChar	
	
	//ExAmt	Numeric(15,2)		Y	Excise duty amt		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//PrerateQ	char(3)	9-May	Y	Preferential rate qualifier		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//Prerate	char(3)	PRF /PRI	Y	Preferential rate		<blank>
	
	lsDetailOutString += lsDelimitChar
	
	//GstAmt	Numeric(15,2)		Y	Gst amt	depend on order	TBD - I think this is Not Applicable on Inbound Material
	
	lsDetailOutString += lsDelimitChar
	
	//GoodType	Char(1)	P-Dutiable Petroleumn, , L-Liq/Tob, M-Dutiable Motor Vehicle,  N-Normal Goods	Y	For internal control of goods	default value = L	L

	lsDetailOutString += 'L' +  lsDelimitChar
	
	//Gstrate	Numeric (7,4)		Y	Gst Rate		<blank>
	
	lsTemp = string(ldGST_Rate)
	
	if IsNull(lsTemp) then lsTemp = ''
	
	lsDetailOutString += lsTemp + lsDelimitChar

//	MessageBox ("ok", lsDetailOutString)
	
	FileWrite(liFileNoDetail,lsDetailOutString)
	

next

FileClose(liFileNoHeader)
FileClose(liFileNoDetail)

MessageBox ("Export Complete", "There were " + string(idw_putaway.RowCount()) + " rows exported to " + lsPathOut + ".")


Return 0

end function

public subroutine getdeletedskus ();

//MikeA 04/13 OTM Project
//Populates an array of Sku's that need to be sent to OTM on the delete

Long llRowCount, llRowPos

isRoNoDelete = idw_main.GetITemString(1,'Ro_no')  

llRowCount =  idw_detail.Rowcount()
For llRowPos = 1 to llRowCount
	isDeleteSkus[llRowPos] = idw_detail.GEtItemString(llRowPOs,'sku')
Next

end subroutine

public function string uf_get_custom_column_setting (datawindow a_dw, string a_column, integer a_row);//TimA 01/15/14
//If the DW is in the table Custom_Datawindow then there should be column width settings to be used.
//These settings are first set in w_login/ g.of_get_custom_dw( )
String ls_syntax, lsModify
Long ll_foundrow,ll_DataWindowNo, llRowFound, llWidth

ll_foundrow = 1

IF g.ids_Custom_dw.Rowcount() > 0 THEN
	ls_syntax=  "Datawindow = '"+ string(a_dw.DataObject) + "'" + " and Column_Name =  '"+ string(a_column) + "'"
	llRowFound = g.ids_Custom_dw.Find(ls_syntax,	a_row, g.ids_Custom_dw.RowCount()) 
	llWidth = g.ids_Custom_dw.GetItemNumber(llRowFound,'Column_Width')
		
	lsModify = "" + a_column + ".width=" + String(llWidth) + "" + " " + a_column + "_t.width=" + String(llWidth) + ""

End if


Return lsModify
end function

protected function boolean wf_select_reconfirm_records (string as_rono);//TimA 04/16/14
long     lrtn
boolean lbRtn = FALSE

istrparms.String_arg[1 ] = as_rono
istrparms.String_arg[2 ] = 'INBOUND' //This is pass because the window can handle inbound or outbound.
//Open window that has detail records from orders
OpenWithParm(w_reconfirm_detail_lines,istrparms)
istrparms = Message.PowerObjectParm	

IF istrparms.string_arg_2[1 ] <> '' THEN
	If istrparms.string_arg_2[1 ] = Upper('NONE' ) Then
		MessageBox('Selection Error','You need to select detail records for Re-Confirm.',StopSign!)
		lrtn = -1
	Else
		isDetailRecordsToReConfirm = istrparms.string_arg_2[1 ]
		lrtn = 1
	End if

ELSE
	// no go - 
	lrtn = -1

END IF
//
IF (lrtn >= 1) THEN
	// SUCCESS
	lbRtn = True
ELSE
	lbRtn = False
END IF 

Return lbRtn




end function

public function integer wf_export ();long llRowCount,i,pos,ColF
dw_custom_report.SetTransObject(SQLCA)
llRowCount = dw_custom_report.Retrieve(upper(idw_main.GetITemString(1,'ro_no')))

OLEObject xl, xs
String filename, sql_syntax
String lineout[1 to 23]

//filename = ProfileString(gs_inifile,"sims3","syspath","") + "Reports\wspr_inbound_export.xlsx" //17-Feb-2017 :Madhu - commented
filename = gs_reportpath + "wspr_inbound_export.xlsx" //17-Feb-2017 :Madhu - Get path from SIMS_Defaults table

If not FileExists(fileName) Then
	messageBox('Not Found','Excel Template: ' + fileName + " Not found.")
	Return -1
End If

xl = CREATE OLEObject
xs = CREATE OLEObject
xl.ConnectToNewObject("Excel.Application")
xl.Workbooks.Open(filename,0,True)
xs = xl.application.workbooks(1).worksheets(1)




pos=2
For i = 1 to llRowCount
	pos++
	// SARUN2014JUNE12 : Roundoff
	ColF				= Round(dw_custom_report.getitemnumber(i,'Case')/dw_custom_report.getitemnumber(i,'PACK_SIZE'),0)
	lineout[1] 		= String(dw_custom_report.getitemnumber(i,'line_item_no'))
	lineout[2] 		= dw_custom_report.getitemstring(i,'PO')
	lineout[3] 		= dw_custom_report.getitemstring(i,'PO_Type')
	lineout[4] 		= dw_custom_report.getitemstring(i,'BP')
	lineout[5] 		= dw_custom_report.getitemstring(i,'SKU')
	lineout[6] 		= String(ColF) //String(dw_custom_report.getitemnumber(i,'Case'))
	lineout[7] 		= dw_custom_report.getitemstring(i,'Lot_no')	
	lineout[8] 		= dw_custom_report.getitemstring(i,'Commodity_Code')	
	lineout[9] 		= dw_custom_report.getitemstring(i,'PREMIT_NO')	
	lineout[10] 		= dw_custom_report.getitemstring(i,'LICENSE_NO')
	lineout[11] 		= dw_custom_report.getitemstring(i,'DATE')
	lineout[12] 		= dw_custom_report.getitemstring(i,'VINTAGE')
	lineout[13] 		= dw_custom_report.getitemstring(i,'ALC')
	lineout[14] 		= dw_custom_report.getitemstring(i,'BATCH_NO')
	lineout[15] 		= String(dw_custom_report.getitemnumber(i,'Length'))
	lineout[16] 		= String(dw_custom_report.getitemnumber(i,'Width'))
	lineout[17] 		= String(dw_custom_report.getitemnumber(i,'Height'))
	lineout[18] 		= String(dw_custom_report.getitemnumber(i,'WEIGHT'))
	lineout[19] 		= String(dw_custom_report.getitemnumber(i,'PACK_SIZE'))
	lineout[20] 		= dw_custom_report.getitemstring(i,'DESCRIPTION')
	lineout[21] 		= dw_custom_report.getitemstring(i,'BARCODE')	
	lineout[22] 		= dw_custom_report.getitemstring(i,'GIFTBOXBARCODE')
	lineout[23] 		= dw_custom_report.getitemstring(i,'CARTON_BARCODE')

	xs.range("a" + String(pos) + ":w" +  String(pos)).Value = lineout
	
Next

SetMicroHelp("Complete!")
xl.Visible = True
xl.DisconnectObject()

Return 0


For i = 1 to llrowcount

	dw_custom_report.setitem(i, 'BARCODE',"'" + dw_custom_report.getitemstring(i,'BARCODE') )
	dw_custom_report.setitem(i, 'GIFTBOXBARCODE',"'" + dw_custom_report.getitemstring(i,'GIFTBOXBARCODE') )
	dw_custom_report.setitem(i, 'CARTON_BARCODE',"'" + dw_custom_report.getitemstring(i,'CARTON_BARCODE') )
	
next

dw_custom_report.SaveAs('',CSV!,True)

Return 0


end function

public function integer wf_display_message (string as_message);if not ib_batchconfirmmode then
	MessageBox(is_title, as_message)
else
	is_batch_message[UpperBound(is_batch_message)+1] =  idw_main.getItemString(1,'supp_invoice_no') + ': ' + as_message
end if

return 0
end function

public function integer wf_display_message (string as_title, string as_message);if not ib_batchconfirmmode then
	MessageBox(as_title, as_message)
else
	is_batch_message[UpperBound(is_batch_message)+1] =  idw_main.getItemString(1,'supp_invoice_no') + ': ' + as_message
end if

return 0
end function

public subroutine uf_showhide_status (string as_status);
CHOOSE CASE as_status
		
	
	CASE 'mobile_status_ind' /* 11/14 - PCONKL */
		If ib_show_mobile_status Then
			tab_main.tabpage_search.uo_mobile_status.bringtotop = False
			ib_show_mobile_status = False
		Else
			tab_main.tabpage_search.uo_mobile_status.bringtotop = True
			ib_show_mobile_status = True
		End If
			
		
END CHOOSE

end subroutine

public function integer wf_check_status_mobile ();
String	lsWarehouse, lsFindStr, lsMobileStatus, lsordStatus
Integer	i

idw_Putaway.Object.Datawindow.ReadOnly = False

// F10 unlock may have changed these settings...
idw_putaway_mobile.Object.mobile_status_Ind.Protect = True
idw_putaway_mobile.Modify("mobile_status_Ind.Background.Color = '12639424'")
	
idw_Putaway.Object.mobile_status_Ind.Protect = True
idw_Putaway.Modify("mobile_status_Ind.Background.Color = '12639424'")


lsOrdStatus = idw_main.GetItemString(1, "ord_status")
lsMobileStatus = idw_main.GetItemString(1, "mobile_status_Ind")
If isNull(lsMobileStatus) Then lsMobileStatus = ''

lsWarehouse = idw_main.GetItemString(1, "wh_code")
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") = 'Y' Then
		
		idw_putaway_mobile.visible = true
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=true mobile_Status_ind_t.visible=true")
		
		//Search Fields
		idw_condition.Modify("mobile_status_ind.visible=true mobile_status_ind_t.visible=true")
		idw_search.Modify("mobile_status_ind.visible=true mobile_status_ind_t.visible=true")
		
		//Putaway fields
		idw_Putaway.Modify("mobile_status_ind.visible=true mobile_status_Ind_t.visible=true mobile_putaway_by.visible=true mobile_putaway_by_t.visible=true mobile_putaway_start_time.visible=true mobile_putaway_start_time_t.visible=true mobile_putaway_Complete_time.visible=true mobile_putaway_complete_time_t.visible=true")
			
	Else /* Not mobile Enabled */
		
		idw_putaway_mobile.visible = False
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false")
		
		//Search Fields
		idw_condition.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Search.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		
		//Putaway Fields
		idw_Putaway.Modify("mobile_status_ind.visible=false mobile_status_Ind_t.visible=false mobile_putaway_by.visible=false mobile_putaway_by_t.visible=false mobile_putaway_start_time.visible=false mobile_putaway_start_time_t.visible=false mobile_putaway_Complete_time.visible=false mobile_putaway_complete_time_t.visible=false")
			
	End If
	
End If

If lsMobileStatus = 'D' or lsMobileStatus = 'C' or lsOrdStatus = 'C' Then
	idw_putaway_mobile.Object.Datawindow.ReadOnly = True
Else
	if lsOrdStatus <> 'C' Then
		idw_putaway_mobile.Object.Datawindow.ReadOnly = False
	End If
End If

If lsMobileStatus = 'D' or lsMobileStatus = 'C' or lsMobileStatus = '' Then
	
else
	icb_confirm.Enabled = False
End If

//Order based validations...
//If released to mobile, can't make any changes to Putaway List unless it is a discrepancy in which case, we'll allow a new row to be inserted and the discrepent row modified
If lsMobileStatus <> '' Then
			
	//Putaway
//	tab_main.tabpage_Putaway.cb_insertrow.Enabled = False
//	tab_main.tabpage_Putaway.cb_copyrow.Enabled = False 
//	tab_main.tabpage_Putaway.cb_deleterow.Enabled = False
	tab_main.tabpage_Putaway.cb_generate.Enabled = False
	
	
	// Only allow Release to mobile box to be checked/unchecked if status is blank or released and Putawa List exists
	If (lsMObileStatus = '' or lsMobileStatus = 'R' or isNull(lsMobileStatus)) Then
		idw_putaway_mobile.Modify("mobile_Enabled_ind.Protect=0")
	Else
		idw_putaway_mobile.Modify("mobile_Enabled_ind.Protect=1")
	End If
	
else	
	idw_putaway_mobile.Modify("mobile_Enabled_ind.Protect=0") //07-SEP-2018 :Madhu DE5931 - Unlock, if it is protected.
End If

		
REturn 0
end function

public function boolean wf_is_xx_coo_check_excluded (string as_supp_invoice_no);boolean lb_return
Datastore lds_lookuptable
long ll_rowcount, i
String ls_mask

as_supp_invoice_no = Upper( Trim( as_supp_invoice_no ))

lds_lookuptable = f_datastorefactory( 'd_lookup_table' )

ll_rowcount = lds_lookuptable.retrieve( gs_project, 'EXCLUDE_COO_XX_VALIDATION' )

for i = 1 to ll_rowcount
	ls_mask = Upper( Trim( lds_lookuptable.Object.Code_Id[ i ] ))

	if Pos( as_supp_invoice_no, ls_mask ) = 1 then
		lb_return = TRUE
		EXIT
	end if
next

return lb_return

end function

public function integer wf_check_commodity_authorized_user ();//08-Jun-2016 Madhu Added for Commodity Authorized User

//Get Commodity Authorized User value from Global Variable
//Get sku from order detail and have User Field5 value
//Get Commodity_Restriction from Commodity Codes against User Field5 value
// If Commodity_Restriction =Y and Commodity_Authorized_user= N throw an error message else proceed further
//Commodity_Authorized_user= N -> Not Authorized for Restricted Commodities on UserTable
//Commodity_Authorized_user= Y -> Authorized for Restricted Commodities on UserTable


long  ll_detail_rowcount,ll_findrow
String ls_sku,ls_suppcode,ls_uf5,ls_find,ls_sql,ls_error,presentation_str

Datastore lds_commoditycd

//Create a run time datastore for Commodity Codes and Load values
lds_commoditycd =Create Datastore
ls_sql =" select Commodity_Cd, Commodity_Description, Commodity_Restriction  "
ls_sql +=" From Commodity_Codes with(nolock)"

presentation_str = "style(type=grid)"
lds_commoditycd.create(SQLCA.SyntaxFromSql(ls_sql, presentation_str,ls_error))
lds_commoditycd.SetTransObject(SQLCA)
lds_commoditycd.retrieve( )


If (isnull(gs_commodity_authorized_user) OR gs_commodity_authorized_user='' OR gs_commodity_authorized_user='N') Then //If user is not authorized for commodity goods
	ll_detail_rowcount =idw_detail.rowcount( ) //get detil row count
	
	For ll_row =1 to ll_detail_rowcount //Repeat through loop
		ls_sku = idw_detail.getitemstring(ll_row,'sku')
		ls_suppcode =idw_detail.getitemstring(ll_row,'supp_code')
			
			//Look for an Item Master to get User Field5 value
			select User_Field5 into :ls_uf5 from dbo.Item_Master with(nolock) 
			where Project_Id =:gs_project and sku=:ls_sku and supp_code =:ls_suppcode 
			using sqlca;
		
			//Look for Commodity_Restriction value against UF5
			ls_find ="Commodity_Cd='"+ls_uf5+"'"
			ll_findrow=lds_commoditycd.find( ls_find, 1, lds_commoditycd.rowcount())
			
			//If Commodity Restrictions value is Y return -1 to throw an error message
			If upper(lds_commoditycd.getitemstring(ll_findrow,'Commodity_Restriction')) ="Y" Then
				is_dangerous_item = ls_sku //set Restricted Item
				il_detail_row =ll_row //set Danegorus Item Row on Detail
				Return -1
			End If
	Next 
End If

Return 0
end function

public function boolean f_check_dims (long al_rownum);string ls_sku, ls_supplier, ls_Cube_Scan

// Get the sku and supplier
ls_sku = tab_main.tabpage_orderdetail.dw_detail.getitemstring(al_rownum, "sku")
ls_supplier = tab_main.tabpage_orderdetail.dw_detail.getitemstring(al_rownum, "supp_code")


if gs_Project = 'PANDORA' then
	Select User_Field20 Into :ls_Cube_Scan
	FROM item_master
	Where project_id = :gs_project
	and supp_code = :ls_Supplier
	and sku = :ls_SKU;
end if

 If ls_cube_scan= '' or IsNULL( ls_cube_scan)  Then //Cubiscan is missing in the Item Master file UF20 
	if not ib_batchconfirmmode then
		return false
	end if
End if 

// Return true
return true




end function

public function integer uf_om_expansion (long llbatchseqno, long llnewbatchseqno);//28-Aug-2017 :Madhu - Write records into OM_Expansion table for PINT-856
//When Back Order created, copy expansion records (against old batch_seq_no) and write for NewBatch_Seq_no.

String 	sql_syntax, ERRORS, lsErrText, ls_project, ls_table_name, ls_col_name, ls_col_val
long 		llRowPos, llRowCount

Datastore ldsOMExpansion


ldsOMExpansion = Create Datastore		
sql_syntax = "select Project_Id, Table_Name, Key_Value, Line_Item_No, Column_Name, Column_Value"
sql_syntax += " from OM_Expansion_Table with(nolock)"
sql_syntax += " where Key_Value ='"+string(llBatchSeqNo)+"'"

ldsOMExpansion.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", ERRORS))
IF Len(Errors) > 0 THEN
		Messagebox('OM_Expansion_Table',"Unable to create datastore for OM_Expansion_Table .!~r~r" + Errors)
else
	ldsOMExpansion.SetTransObject(SQLCA)
	llRowCount = ldsOMExpansion.Retrieve()	
end if

For llRowPos =1 to llRowCount
	
	ls_project = ldsOMExpansion.getitemstring( llRowPos, 'Project_Id')
	ls_table_name = ldsOMExpansion.getitemstring( llRowPos, 'Table_Name')
	ls_col_name = ldsOMExpansion.getitemstring( llRowPos, 'Column_Name')
	ls_col_val = ldsOMExpansion.getitemstring( llRowPos, 'Column_Value')
	
	//Insert Record into OM_Expansion_Table
	Execute Immediate "Begin Transaction" using SQLCA;
		INSERT INTO OM_Expansion_Table (Project_Id, Table_Name, Key_Value, Line_Item_No, Column_Name, Column_Value)
			values ( :ls_project, :ls_table_name, :llNewBatchSeqNo, 0, :ls_col_name, :ls_col_val )
		using sqlca;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox('OM_Expansion_Table',"Unable to Insert Record into OM_Expansion_Table .!~r~r" + lsErrText)
			Return -1
		End If
	
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('OM_Expansion_Table',"Unable to Commit changes! No changes made to Database!")
		Return -1
	End If

Next

destroy ldsOMExpansion
Return 0	
end function

public function integer uf_replace_all_pono2_containerid_values (string as_col_name, string as_old_col_value, string as_new_col_value);//15-Jan-2018 :Madhu S14839 - Foot Print 
//Replace All PoNo2 /Container Id values, if User say 'Yes'
string lsFind, lsFind1, ls_sku, lsSupplier, ls_pono2_Ind, ls_container_Ind
long	llFindRow, llcount, llItemFindRow

//OCT 2019 - MikeA - S38251  F18113 - PhilipsBH: Stop po_no2 pop up message box
//Philips does not want to use this functionality.
If left(gs_project,7) = 'PHILIPS' Then Return 0

lsFind = as_col_name+" = '"+as_old_col_value+"'"
llFindRow = idw_putaway.find( lsFind, 1, idw_putaway.rowcount())

//get a count of rows which are having same either PoNo2 /Container Id values
DO WHILE llFindRow > 0 
	llcount++
	llFindRow++
	If llFindRow > idw_putaway.rowcount( ) Then exit
	llFindRow = idw_putaway.find( lsFind, llFindRow, idw_putaway.rowcount())
LOOP

If llcount > 0 Then
	If MessageBox("Inbound Order", "Would you like to replace all "+as_col_name +" values (" +as_old_col_value+ ") by (" +as_new_col_value+")", Question!, YesNo!, 1) =1 Then
		llFindRow = idw_putaway.find( lsFind, 1, idw_putaway.rowcount())
		DO WHILE llFindRow > 0 
			
			//23-MAR-2018 :Madhu DE3620 -check wether SKU is Tracked By Po No2 /Container Id
			ls_sku = idw_putaway.GetItemString(llFindRow, "sku")
			lsSupplier= idw_putaway.GetItemString(llFindRow, "supp_code")
			llcount = i_nwarehouse.of_item_master( gs_project, ls_sku, lsSupplier)
			
			lsFind1 ="Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"' and supp_code = upper('"+lsSupplier+"')"
			llItemFindRow = i_nwarehouse.ids.find( lsFind1, 1, i_nwarehouse.ids.rowcount())
			
			If llItemFindRow > 0 Then
				ls_pono2_Ind = i_nwarehouse.ids.getItemString(llItemFindRow, 'PO_No2_Controlled_Ind')
				ls_container_Ind = i_nwarehouse.ids.getItemString(llItemFindRow, 'Container_Tracking_Ind')
				
				If (upper(as_col_name) ='PO_NO2' and ls_pono2_Ind ='Y' ) OR (upper(as_col_name) = 'CONTAINER_ID' and ls_container_Ind ='Y') Then
					idw_putaway.setItem( llFindRow, as_col_name, as_new_col_value)
				End If
			END IF

			llFindRow++
			If llFindRow > idw_putaway.rowcount( ) Then exit
			llFindRow = idw_putaway.find( lsFind, llFindRow, idw_putaway.rowcount())
		LOOP
	
	End If
End If

Return 0
end function

public function long wf_putaway_release_mobile_validation ();//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway validation
//02-AUG-2018 :Madhu DE5531 - Added Tracking By validations

string ls_sku, ls_Inv_Type, ls_title, ls_sn_required
string ls_loc, ls_lot_no, ls_po_no, ls_po_no2, ls_containerId, ls_serial_no
string ls_po_no_controlled_ind, ls_lot_controlled_ind, ls_exp_controlled_ind
string ls_po_no2_controlled_ind, ls_container_tracking_ind

long ll_putaway_row, ll_qty, ll_mail_count, ll_mobile_count
DateTime ldt_exp_date

ls_title ="Release to Mobile Validation"

//Loop through each putaway record
For ll_putaway_row = 1 to idw_putaway.rowcount( )

	ls_sku = 	idw_putaway.getItemString( ll_putaway_row, 'sku')
	
	ls_sn_required =  idw_putaway.getItemString( ll_putaway_row, 'compute_3')
		
	ls_Inv_Type =	idw_putaway.getItemString( ll_putaway_row, 'Inventory_Type')
	ls_loc = 	idw_putaway.getItemString( ll_putaway_row, 'l_code')
	ll_qty =	idw_putaway.getItemNumber( ll_putaway_row, 'Quantity')
	
	ls_lot_no =	idw_putaway.getItemString( ll_putaway_row, 'Lot_No')
	ls_po_no =	idw_putaway.getItemString( ll_putaway_row, 'PO_No')
	ls_po_no2 = 	idw_putaway.getItemString( ll_putaway_row, 'PO_No2')
	ls_containerId =	idw_putaway.getItemString( ll_putaway_row, 'container_ID')
	ls_serial_no =	idw_putaway.getItemString( ll_putaway_row, 'Serial_No')
	ldt_exp_date = idw_putaway.getItemdatetime( ll_putaway_row, 'Expiration_Date')
		
	ls_po_no_controlled_ind =	idw_putaway.getItemString( ll_putaway_row, 'PO_Controlled_Ind')
	ls_lot_controlled_ind =	idw_putaway.getItemString( ll_putaway_row, 'Lot_Controlled_Ind')
	
	ls_po_no2_controlled_ind =	idw_putaway.getItemString( ll_putaway_row, 'PO_NO2_Controlled_Ind')
	ls_container_tracking_ind =	idw_putaway.getItemString( ll_putaway_row, 'container_tracking_Ind')
	ls_exp_controlled_ind = 	idw_putaway.getItemString( ll_putaway_row, 'expiration_Controlled_Ind')

	//SN Scan Required validation (Make sure Serial No should be provided)
	IF ls_sn_required ='Y' THEN
		IF  ls_serial_no ='-' THEN
			MessageBox(ls_title ," SKU : "+trim(ls_sku) + " is Serialized. ~n~rPlease Provide values for  Serial No!", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'sku')
			Return -1
		ELSEIF ll_qty > 1 THEN
			MessageBox(ls_title ," SKU : "+trim(ls_sku) + " is Serialized. ~n~rQuantity shouldn't be greater than 1 for Serialized SKU!", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'sku')
			Return -1
		END IF
	END IF
	
	//b. General Validations
	
	//Inventory Type validation
	IF  IsNull(ls_Inv_Type) OR ls_Inv_Type ='' THEN
			MessageBox(ls_title ," Inventory Type is required. Please Provide a valid Inventory Type value.", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Inventory_Type')
			Return -1
	END IF

	//Location validation
	IF  IsNull(ls_loc) OR ls_loc ='' OR ls_loc ='*' THEN
			MessageBox(ls_title ," Location is required. Please Provide a valid Location value", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'l_code')
			Return -1
	END IF
	
	//Lot -validation
	IF ls_lot_controlled_ind ='Y' and (IsNull(ls_lot_no) OR ls_lot_no ='' OR ls_lot_no ='-') THEN
			MessageBox(ls_title ," Lot is required. Please Provide a valid Lot value", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Lot_No')
			Return -1
	END IF

	//Po No -validation
	IF ls_po_no_controlled_ind ='Y' and (IsNull(ls_po_no) OR ls_po_no ='' OR ls_po_no ='-') THEN
			MessageBox(ls_title ," Po No is required. Please provide a valid Po No value", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Po_No')
			Return -1
	END IF
	
	//Po No2 - validation
	IF ls_po_no2_controlled_ind ='Y' and (IsNull(ls_po_no2) OR ls_po_no2 ='' OR ls_po_no2 ='-') THEN
			MessageBox(ls_title ," Pallet Id is required. Please provide a valid Pallet Id value", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Po_No2')
			Return -1
	END IF
	
	//Container Id - validation
	IF ls_container_tracking_ind ='Y' and (IsNull(ls_containerId) OR ls_containerId ='' OR ls_containerId ='-') THEN
			MessageBox(ls_title ," Container Id is required. Please provide a valid Container Id value", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'container_ID')
			Return -1
	END IF
	
	//Expiration Date - validation
	IF ls_exp_controlled_ind ='Y' and (IsNull(ldt_exp_date) OR f_validate_DateTime(ldt_exp_date ) = 0 OR string(ldt_exp_date ,'MM/DD/YYYY') = '12/31/2999' ) THEN
			MessageBox(ls_title ," Expiration Date is required. Please Provide Valid Date.", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Expiration_Date')
			Return -1
	END IF

	//Quantity - validation
	IF (ll_qty = 0) OR IsNull(ll_qty)  THEN
			MessageBox(ls_title ," Quantity is required. Please Provide Quantity which should be greater than Zero.", Stopsign!)
			tab_main.SelectTab(4 )
			f_setfocus(idw_putaway, ll_putaway_row, 'Quantity')
			Return -1
	END IF

Next

Return 0
end function

public subroutine wf_min_shelf_life_inbound_validation (boolean lbgenerateputaway);//30-Jan-2019 :Madhu S28685 -PHILIPSCLS BlueHeart Minimum Inbound ShelfLife Validation
//if Expiration Date $$HEX2$$13202000$$ENDHEX$$Current Date < Shelf_Life, with the message $$HEX1$$1c20$$ENDHEX$$Expiry Date is xx days from the minimumRemainingShelfLifeInbound of yy days$$HEX1$$1d20$$ENDHEX$$
//Where xx is Expiration Date $$HEX2$$13202000$$ENDHEX$$Current Date, and yy is minimumRemainingShelfLifeInbound.

//If it is not calling from generate putaway process, no need to display error message, only set background color to YELLOW.

String ls_wh_code, ls_sku, lsSupplier, lsFind, ls_uf1
Long	ll_idx, llSkucount, llSkuFindRow, ll_shelf_life_Inbound, ll_shelf_life_Outbound
Long	ll_diff_days, ll_line_item_no, ll_current_row
DateTime ldtToday, ldt_expiration_date

ls_wh_code = idw_main.getItemString(1, 'wh_code')
ldtToday = f_getLocalWorldTime( ls_wh_code )  //get warehouse local time

FOR ll_idx = 1 to idw_putaway.rowcount()
	
	IF lbgenerateputaway =TRUE THEN idw_putaway.setItem(ll_idx, "Po_No2",String(ldtToday,'YYYYMMDD'))
	
	ls_sku= idw_putaway.getItemString(ll_idx, "sku")
	ll_line_item_no = idw_putaway.GetItemNumber(ll_idx,'line_item_no')
	lsSupplier= idw_putaway.getItemString(ll_idx, "supp_code")
	ldt_expiration_date = idw_putaway.getItemdatetime( ll_idx, "expiration_date")
	llSkucount = i_nwarehouse.of_item_master( gs_project, ls_sku, lsSupplier)
	
	//Aug-2019 :MikeA DE11826 -PHILIPSCLS Fix  Inbound Order Error due to Lowercase Project_ID in Item_Master
	
	lsFind ="upper(Project_Id) =upper('"+gs_project+"') and sku ='"+ls_sku+"' and upper(supp_code) = upper('"+lsSupplier+"')"
	llSkuFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())
	
	ls_uf1 = i_nwarehouse.ids.getItemString(llSkuFindRow, 'User_Field1') //MinimumRemainingShelfLifeInbound
	IF isnumber(ls_uf1) Then ll_shelf_life_Inbound = long(ls_uf1)
	ll_shelf_life_Outbound = i_nwarehouse.ids.getItemNumber(llSkuFindRow, 'Shelf_Life') //MinimumRemainingShelfLifeOutbound

	ll_diff_days = DaysAfter ( date(ldtToday), date(ldt_expiration_date) )
	
	//27-FEB-2019 :Madhu DE8977 DE9081 - Reset instance color value
	IF (ll_diff_days < ll_shelf_life_Outbound  and ll_shelf_life_Outbound > 0 ) THEN
		idw_putaway.setItem(ll_idx, 'min_shelf_life_validation', 'Y')
		IF lbgenerateputaway =TRUE THEN Messagebox(is_title, "Sku: " + ls_sku + " and Line Item #: " + string(ll_line_item_no) + " Expiry Date is "+ string(ll_diff_days)+"  days from the minimumRemainingShelfLifeInbound of "+string(ll_shelf_life_Inbound)+" days.")
	ELSE
		idw_putaway.setItem(ll_idx, 'min_shelf_life_validation', 'N')
	END IF
	
	idw_putaway.Modify("sku.Background.Color =~"67108864~tIf(min_shelf_life_validation = 'Y', rgb(255,255,0), rgb (255,255,255))~"")

NEXT
end subroutine

public function integer wf_edi_inbound_expansion (string as_orderno, long al_batchseq, long al_new_batchseq);//4-MAR-2019 :Madhu PHILIPSCLSBlueHeart Create EDI Inbound Expansion records for Back Order.
//When Back Order created, copy expansion records (against old batch_seq_no) and write for NewBatch_Seq_no.

String 	sql_syntax, ERRORS, lsErrText, ls_project, ls_user_line , ls_ord_table, ls_field_name, ls_field_data, ls_upload
long 		llRowPos, llRowCount, ll_ord_seq, ll_ord_line

Datastore ldsInboundExpansion

ldsInboundExpansion = Create Datastore
sql_syntax = "select Project_Id, Order_Seq_No, Order_Line_No, User_Line_Item_No, Order_Table, Field_Name, Field_Data, Upload"
sql_syntax += " from EDI_Inbound_Expansion with(nolock)"
sql_syntax += " where Project_Id ='"+gs_project+"' and Order_No ='"+as_orderno+"' and EDI_Batch_Seq_No ="+string(al_batchseq)

ldsInboundExpansion.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", ERRORS))
IF Len(Errors) > 0 THEN
		Messagebox('EDI_Inbound_Expansion', "Unable to create datastore for EDI_Inbound_Expansion .!~r~r" + Errors)
else
	ldsInboundExpansion.SetTransObject(SQLCA)
	llRowCount = ldsInboundExpansion.Retrieve()	
end if

For llRowPos =1 to llRowCount
	
	ll_ord_seq = ldsInboundExpansion.getItemNumber( llRowPos, 'Order_Seq_No')
	ll_ord_line = ldsInboundExpansion.getItemNumber( llRowPos, 'Order_Line_No')
	ls_user_line = ldsInboundExpansion.getItemString( llRowPos, 'User_Line_Item_No')
	ls_ord_table = ldsInboundExpansion.getItemString( llRowPos, 'Order_Table')
	ls_field_name = ldsInboundExpansion.getItemString( llRowPos, 'Field_Name')
	ls_field_data = ldsInboundExpansion.getItemString( llRowPos, 'Field_Data')
	ls_upload = ldsInboundExpansion.getItemString( llRowPos, 'Upload')

	
	//Insert Record into OM_Expansion_Table
	Execute Immediate "Begin Transaction" using SQLCA;
		INSERT INTO EDI_Inbound_Expansion (Project_Id, EDI_Batch_Seq_No, Order_Seq_No, Order_Line_No, Order_No, 
				User_Line_Item_No, Order_Table, Field_Name, Field_Data, Upload)
			values ( :gs_project, :al_new_batchseq, :ll_ord_seq, :ll_ord_line, :as_orderno, 
				:ls_user_line, :ls_ord_table, :ls_field_name, :ls_field_data, :ls_upload )
		using sqlca;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox('EDI_Inbound_Expansion',"Unable to Insert Record into EDI_Inbound_Expansion .!~r~r" + lsErrText)
			Return -1
		End If
	
	Execute Immediate "COMMIT" using SQLCA;
	If sqlca.sqlcode <> 0 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox('EDI_Inbound_Expansion',"Unable to Commit changes! No changes made to Database!")
		Return -1
	End If

Next

destroy ldsInboundExpansion
Return 0	
end function

public function integer wf_generate_putaway_serial_records ();//1-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//make a server call to generate and insert serial records into Receive_Serial_Detail table

string lsxml, lsDeleteExisting, lsXMLResponse, ls_order, lsreturncode, lsreturndesc
int li_ret
long ll_count

IF Not IsValid(iuoWebsphere) THEN
	iuoWebsphere = CREATE u_nvo_websphere_post
END IF

//Don't make call everytime to server.
select count(*) into :ll_count from receive_serial_detail with(nolock)
where ro_no=:is_rono
using sqlca;

IF ll_count > 0 THEN Return 0

linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("ROPutawaySerialRequest", "ProjectID='" + gs_Project + "'")
lsXML += 	'<RONO>' + idw_main.getItemstring(1,'ro_no') +  '</RONO>' 
lsXML = iuoWebsphere.uf_request_footer(lsXML)

w_main.setMicroHelp("Generating Putaway Serial List on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

w_main.setMicroHelp("Putaway Serial List generation complete")

//validate response
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	Messagebox("Websphere Fatal Exception Error","Unable to generate Putaway Serial List: ~r~r" + lsXMLResponse,StopSign!)
	f_method_trace_special( gs_project,this.ClassName() + ' -wf_generate_putaway_serial_records','End wf_generate_putaway_serial_records ' + "Websphere Fatal Exception Error. Unable to generate Putaway List: " + lsXMLResponse,ls_order,' ',' ',is_suppinvoiceno )
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		Messagebox("Websphere Operational Exception Error","Unable to Savw Putaway Serial List: ~r~r" + lsReturnDesc,StopSign!)
		f_method_trace_special( gs_project,this.ClassName() + ' -wf_generate_putaway_serial_records','End wf_generate_putaway_serial_records ' + "Websphere Operational Exception Error. Unable to Save Putaway Serial List: " + lsReturnDesc,ls_order,' ',' ',is_suppinvoiceno )
		Return -1
	
	Case Else
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

idw_rma_serial.retrieve( is_rono, gs_project)

Return 0
end function

public function any wf_get_rma_serial_list (string as_sku, long al_id_no);//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//Return serial List against SKU and Id_No from RMA Serial Tab

string ls_serial_list[], lsFind
long ll_serial_count, ll_serial_find_row

ll_serial_count = idw_rma_serial.rowcount( )
lsFind ="sku='"+as_sku+"' and Id_No="+string(al_id_no)
ll_serial_find_row = idw_rma_serial.find( lsFind, 1, ll_serial_count)

DO WHILE ll_serial_find_row > 0
	ls_serial_list[UpperBound(ls_serial_list) +1] = idw_rma_serial.getItemString(ll_serial_find_row, 'serial_no')
	ll_serial_find_row = idw_rma_serial.find( lsFind, ll_serial_find_row+1, ll_serial_count+1)
LOOP

Return ls_serial_list[]
end function

public subroutine wf_set_rma_serial_tab_status ();//8-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//At least one serialized SKU should be available on Putaway List

long llFindRow

llFindRow = idw_putaway.find( "Serialized_Ind IN ('Y','B')", 1, idw_putaway.rowcount())

IF g.ib_receive_putaway_serial_rollup_ind  and llFindRow > 0 THEN 
	tab_main.tabpage_rma_serial.visible =TRUE
	this.wf_generate_putaway_serial_records( )
ELSE
	tab_main.tabpage_rma_serial.visible =FALSE
END IF

end subroutine

public function integer wf_validate_container_against_edi_record ();//29-APR-2019 :Madhu S32505 F15371 - Add Container Level validations.
string ls_sku, ls_container_id, ls_find, ls_source_type, ls_prev_find
long ll_putaway_row, ll_putaway_count,  ll_find_row, li_EdiBatchNo
long	ll_edi_row, ll_edi_count
decimal ld_putaway_qty, ld_edi_qty

//16-MAY-2019 :Madhu S33666 Add Source Type and exclude validation for WEB Orders.
ls_source_type = idw_main.getItemString( 1, 'Source_Type')
li_EdiBatchNo = idw_main.GetItemNumber(1,'Edi_Batch_Seq_No')	

IF NOT isnull(li_EdiBatchNo) and li_EdiBatchNo <> 0  THEN
	IF idsEdiContainers.rowcount( ) > 0  and Pos(upper(ls_source_type) ,'WEB') = 0 THEN
	
		ll_edi_count = idsEdiContainers.rowcount( )
	
		//loop through each putaway record
		FOR ll_edi_row = 1 to ll_edi_count
			
			ls_sku = idsEdiContainers.getItemString(ll_edi_row, 'Sku')
			ls_container_id = idsEdiContainers.getItemString(ll_edi_row, 'container_id')
			//DE11788 - Check container id for NULL value
			If IsNull(ls_container_id) Then
				ls_find = "sku='"+ls_sku+"' and IsNull(container_id) "
			Else
				ls_find = "sku='"+ls_sku+"' and container_id ='"+ls_container_id+"'"
			End if
			
			//IF NOT (IsNull(ls_container_id) or ls_container_id= ''  or ls_container_id= ' ' or ls_container_id='-' or ls_container_id='NA' or ls_container_id ='DUMMY') and ls_find <> ls_prev_find THEN
			IF ls_find <> ls_prev_find THEN
				
				//reset values
				ld_putaway_qty =0
				ld_edi_qty =0
				
				//get sum(qty) of sku, container_Id from EDI table
				ll_find_row = idsEdiContainers.find( ls_find, 1, ll_edi_count)
				
				DO WHILE ll_find_row > 0
					ld_edi_qty += Dec(idsEdiContainers.getItemString(ll_find_row, 'Quantity'))
					ll_find_row = idsEdiContainers.find( ls_find, ll_find_row +1, ll_edi_count +1)
				LOOP
				
				//get sum(qty) of sku, container_Id from Putaway
				ll_find_row = idw_putaway.find( ls_find, 1, idw_putaway.rowcount())
				ll_putaway_row =ll_find_row
				
				DO WHILE ll_find_row > 0
					ld_putaway_qty += idw_putaway.getItemNumber(ll_find_row, 'Quantity')
					ll_find_row = idw_putaway.find( ls_find, ll_find_row +1, idw_putaway.rowcount() +1)
				LOOP
				
				ls_prev_find = ls_find
				
				//compare Quantities
				IF  ld_putaway_qty <> ld_edi_qty  and ld_edi_qty > 0 and ld_putaway_qty > 0 THEN
					MessageBox(is_title, "Quantities are mismatch against Container Id "+ls_container_Id+" , Expected("+ string(ld_edi_qty)+") but receiving ("+string(ld_putaway_qty)+")", StopSign!)
					f_setfocus(idw_putaway, ll_putaway_row, "Container_Id")
					Return -1
				END IF
		
			END IF
			
		NEXT
		
	END IF
END IF

Return 0
end function

public function integer wf_alt_rma_serial_save (datawindow adw);//GailM 9/17/2019 DE11788 - Cannot save to Receive Serial Detail from dw_rma_serial datawindow.  Alternate save.
Int liRtn
Long llRowPos, llRowCount, llNewRow
Datetime ldtToday
Datastore ldsDetailSerial

ldtToday = f_getLocalWorldTime( idw_main.object.wh_code[1] )

ldsDetailSerial = Create Datastore
ldsDetailSerial.DataObject = 'd_rec_detail_serial'
ldsDetailSerial.SetTransObject(SQLCA)

liRtn = 1
llRowCount = adw.RowCount()
If llRowCount = 0 Then Return 1

For llRowPos = 1 to llRowCount
	llNewRow = ldsDetailSerial.InsertRow(0)
	ldsDetailSerial.SetItem(llNewRow, "ro_no", adw.GetItemString(llRowPos,"ro_no"))
	ldsDetailSerial.SetItem(llNewRow, "sku", adw.GetItemString(llRowPos,"sku"))
	ldsDetailSerial.SetItem(llNewRow, "serial_no", adw.GetItemString(llRowPos,"serial_no"))
	ldsDetailSerial.SetItem(llNewRow, "id_no", adw.GetItemNumber(llRowPos,"id_no"))
	ldsDetailSerial.SetItem(llNewRow, "record_create_date", ldtToday)
Next

liRtn = ldsDetailSerial.Update()

Destroy ldsDetailSerial

Return liRtn

end function

public function integer wf_autofill_putaway_container_pallet (string as_column_name, integer ai_row, string as_value);
//MikeA - F18447 - I2576 - Google - SIMS - Receiving Enhancement
//MikeA - 3/20 - F21861  S43665 - Google BRD - SIMS - Inbound Putaway Autofill II

long ll_RowCount, ll_Idx
boolean lb_indvidual_selected
string ls_row_selected

//Check to see if Putaway autfill box is checked. 
IF Not tab_main.Tabpage_putaway.cbx_autofill.checked Then Return 0 

if idw_putaway.Find("c_autofill = 'Y'", 1, idw_putaway.RowCount()) > 0 then
	lb_indvidual_selected = true
end if

ll_RowCount = idw_putaway.RowCount()
	
//Reset all the check boxes if selected.

for ll_Idx = 1 to ll_RowCount

	ls_row_selected =  idw_putaway.GetItemString(ll_Idx, "c_autofill")
	
	if lb_indvidual_selected AND (IsNull(ls_row_selected) OR ls_row_selected <> 'Y') then Continue
		
	if 	ll_Idx = ai_row then continue
		
	if as_column_name = 'quantity' then
		idw_putaway.SetItem( ll_idx, as_column_name,  long(as_value))
	else
		idw_putaway.SetItem( ll_idx, as_column_name,  as_value)
	end if	
		
	
next


//string lsContainerID, lsPoNo2
//long liFindContainerCount, liFindPalletCount, ll_Idx
//boolean lbHasContainerID, lbHasPalletID, lbUpdateContainer, lbUpdatePallet
//integer liMessage
//
//lsContainerID = idw_putaway.GetItemString(ai_row,'container_id')
//lsPoNo2 = idw_putaway.GetItemString(ai_row,'po_no2') 
//
////check to see if po_no2 and/or Container_ID have valid value (not a '-' or 'NA'). 
//
//IF  Not(IsNull(lsContainerID)  or trim(lsContainerID)= ''  or trim(lsContainerID) = '-' or trim(lsContainerID)='NA') THEN
//	lbHasContainerID = true
//END IF
//
//IF NOT(IsNull(lsPoNo2) or trim(lsPoNo2)= ''   or trim(lsPoNo2) ='-' or trim(lsPoNo2)='NA') Then
//	lbHasPalletID = true
//End IF	
//
//IF lbHasContainerID OR lbHasPalletID Then 
//
//	IF lbHasContainerID Then
//		
//		liFindContainerCount = 0
//		
//		for ll_idx = 1 to idw_putaway.RowCount()
//			if ll_idx = ai_row then Continue
//			if lsContainerID = idw_putaway.GetItemString(ll_idx, "container_id") then liFindContainerCount = liFindContainerCount + 1
//
//		next
//		
//	END IF
//
//	IF lbHasPalletID Then
//
//		liFindPalletCount = 0
//		
//		for ll_idx = 1 to idw_putaway.RowCount()
//			if ll_idx = ai_row then Continue
//			if lsPoNo2 = idw_putaway.GetItemString(ll_idx, "po_no2") then liFindPalletCount = liFindPalletCount + 1
//
//		next
//		
//	END IF
//	
////		if liFindContainerCount > 0 AND liFindPalletCount > 0 then
////			//Prompt to Update by Container_ID or Pallet? 	
////		End IF
//			
//	//According to BRD - changes in W_Ro - Putaway tab, use Pallet ID if Found first. 		
//
//	if  liFindPalletCount > 0 then
//		if ib_AutoFill_Putaway_Pallet = true then
//			lbUpdatePallet = true //We only want to prompt once, not for every new pallet/container 
//		else
//			liMessage = messagebox(is_title, 'There are more ' +string(liFindPalletCount) +' line(s) with the same Pallet ID:'+lsPoNo2+', would you like to auto populate the rest of the lines? ',Question!, YesNo!,2)	
//			If liMessage = 1 then lbUpdatePallet = true
//		end if
//	ElseIf liFindContainerCount > 0 then
//		if ib_AutoFill_Putaway_Container = true then
//			lbUpdateContainer = true //We only want to prompt once, not for every new pallet/container 
//		else
//			liMessage = messagebox(is_title, 'There are more ' +string(liFindContainerCount) + ' line(s) with the same Container ID:'+lsContainerID+', would you like to auto populate the rest of the lines? ',Question!, YesNo!,2)
//			If liMessage = 1 then lbUpdateContainer = true
//		end if
//	End IF
//		
//	IF lbUpdatePallet then
//		for ll_Idx = 1 to idw_putaway.RowCount()
//			if ll_Idx = ai_row then continue
//			if idw_putaway.GetItemString(ll_idx, "po_no2") = lsPoNo2 then
//				if as_column_name = 'quantity' then
//					idw_putaway.SetItem( ll_idx, as_column_name,  long(as_value))
//				else
//					idw_putaway.SetItem( ll_idx, as_column_name,  as_value)
//				end if
//			end if
//		next
//		ib_AutoFill_Putaway_Pallet = true 
//	End If			
//	
//	IF lbUpdateContainer then
//		for ll_Idx = 1 to idw_putaway.RowCount()
//			if ll_idx = ai_row then continue
//			
//			if idw_putaway.GetItemString(ll_idx, "container_id") = lsContainerID then
//				if as_column_name = 'quantity' then
//					idw_putaway.SetItem( ll_idx, as_column_name,  long(as_value))
//				else
//					idw_putaway.SetItem( ll_idx, as_column_name,  as_value)
//				end if
//			end if
//		next
//		ib_AutoFill_Putaway_Container = true
//	End IF
//			
//End IF
//
return 0
end function

public function boolean f_is_pandora_pharmacy_location (string aswarehouse, string aslocation);
// 02/20 - PConkl - Currently implementing at the warehouse level. In the future, we may drill down to the location level

String	lsPharmacyInd

Select pharmacy_location_ind into :lsPharmacyInd
From Warehouse
Where wh_code = :aswarehouse
Using SQLCA;

If lsPharmacyInd = 'Y' Then
	Return True
Else
	Return false
End If
end function

public function string f_is_kitting_location_occupied (string aswhcode, string aslocation, string assku);String lsRoNo, lsPoNo, lsCOO, lsPoNo2, lsContainerId
Datetime ldtExpDt, ldtRecDate

Select Top 1 ro_no, po_no, country_of_origin, expiration_date, record_create_date, po_no2, container_id 
into :lsRoNo, :lsPoNo, :lsCOO, :ldtExpDt, :ldtRecDate, :lsPoNo2, :lsContainerId
From Content with (nolock)
Where wh_code = :asWhCode and l_code = :asLocation and sku = :asSku
Using SQLCA;

If IsNull(lsRoNo) Then lsRoNo = ''

If lsRoNo > '' Then
	//idw_putaway.SetItem(1, 'ro_no', lsRoNo)
	idw_putaway.SetItem(1, 'po_no', lsPoNo)
	idw_putaway.SetItem(1, 'country_of_origin', lsCOO)
	idw_putaway.SetItem(1, 'expiration_date', ldtExpDt)
//	idw_putaway.SetItem(1, 'po_no2', lsPoNo2)
//	idw_putaway.SetItem(1, 'container_id', lsContainerId)
End If

Return lsRoNo

end function

public function string getloctype (string aswhcode, string aslocation);String lsLocType

				Select l_type into :lsLocType
				From	location with(nolock)
				Where wh_code = :asWhCode and l_code = :asLocation
				Using SQLCA;

Return lsLocType
end function

public subroutine f_crossdock ();//// Dinesh - 28/06/2021- DE20364 -Google - SIMS QA - Last leg of a multileg is flagged as crossdock
long User_field13,User_field15
string ls_order,lsUF13,lsUF15
ls_order=tab_main.tabpage_main.sle_orderno.text
lsUF13 = idw_other.GetItemString(1, "User_Field13") 
lsUF15 = idw_other.GetItemString(1, "User_Field15") 
select  count(*) into :User_field13 from Receive_Master where project_id=:gs_project and user_field13=:lsUF13;
select count(*) into : User_field15 from Receive_Master where project_id=:gs_project and user_field13=:lsUF15;
	if   User_field13 > 0 and User_field15 > 0 then
			idw_main.SetItem(1, "crossdock_ind",'Y')
	elseif  User_field13 > 0 and User_field15 = 0 then 
			idw_main.SetItem(1, "crossdock_ind",'N')
	elseif User_field13 = 0 and User_field15 > 0 then 
			idw_main.SetItem(1, "crossdock_ind",'Y')	
	end if
end subroutine

on w_ro.create
int iCurrent
call super::create
this.dw_scanner=create dw_scanner
this.dw_custom_report=create dw_custom_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_scanner
this.Control[iCurrent+2]=this.dw_custom_report
end on

on w_ro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_scanner)
destroy(this.dw_custom_report)
end on

event ue_delete;call super::ue_delete;Long i, ll_cnt, ll_ret
String	lsRONO

If f_check_access(is_process,"D") = 0 Then Return

If left(gs_project, 4) = 'NIKE' Then

	If gs_role = '0' or gs_role = '1' Then
		
		MessageBox("Security Check", "You have no access to this function!",StopSign!)
		return 
		
	End If
	
End If



// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this Inbound record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ib_changed = False

tab_main.SelectTab(1)

For i = idw_putaway.RowCount() to 1 Step -1
	idw_putaway.DeleteRow(i)
Next
For i = idw_detail.RowCount() to 1 Step -1
	idw_detail.DeleteRow(i)
Next

// 10/03 - PCONKL - Delete any Notes and Alt Address rows
lsRONO = idw_main.GetITemString(1,'ro_no')
Execute Immediate "Begin Transaction" using SQLCA;
Delete from receive_Notes where project_id = :gs_project and ro_no = :lsRONO;
Delete from receive_alt_address where project_id = :gs_project and ro_no = :lsRONO; /* 04/09 - PCONKL */
Execute Immediate "COMMIT" using SQLCA;


idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record	Deleted!")
Else
	SetMicroHelp("Record	deleted failed!")
End If
This.Trigger Event ue_edit()

end event

event ue_edit;// Acess Rights
//is_process = Message.StringParm

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False
ibWORequested = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
//tab_main.tabpage_putaway.enabled = false
tab_main.tabpage_notes.enabled = false 
tab_main.tabpage_orderdetail.enabled = false
tab_main.tabpage_rma_serial.enabled = false
tab_main.tabpage_other_info.enabled = false

wf_clear_screen()

isle_code.Visible=True
is_roNo = ''
isle_code.DisplayOnly = False
isle_code.TabOrder = 10
isle_code.SetFocus()


end event

event ue_new;string ls_Prefix,ls_order, lsSupplierInd, lsOrdType
long ll_no
long	llyyyymm
datawindowchild ldwc
string ls_null
//TAM - W&S 2010/12  
string lsSupp_invoice_No
String ls_createUser

// Acess Rights
//If f_check_access(is_process,"N") = 0 Then Return  // Dinesh - 02/11/2021 - commented 

// Begin Dinesh - 02/11/2021 - S53783 - Google - SIMS - Back Order creation
IF gs_Project = "PANDORA" then
else
	If f_check_access(is_process,"N") = 0 Then Return
end if

// End Dinesh - 02/11/2021 - S53783 - Google - SIMS - Back Order creation

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

// Clear existing data
This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
ibConfirmrequested = False

// pvh - 09.14.2006 BlueCoat
setUpdateEdi( false )

isle_code.text = ""
isle_order2.text = ""

wf_clear_screen()

idw_main.InsertRow(0)
idw_main.SetItem(1,"project_id",gs_project)
idw_main.SetItem(1,"ord_date",Today())
idw_main.SetItem(1,"wh_code",gs_default_wh)

IF gs_Project = "PANDORA" then
	
	if Not IsNull(gs_default_wh) AND trim(gs_default_wh) <> '' then
	
		idw_other.GetChild("user_field2", ldwc)
		
		ldwc.SetTransObject(SQLCA)
	
		ldwc.Retrieve(upper(gs_project), gs_default_wh)
		
		SetNull(ls_null)
		
		//Make sure the user field 2 is reset if the wh_code is changed.
		// GailM - 06/09/2015 - user_field2 moved to dw_other for named field change -
		
		idw_other.SetItem( 1, "user_field2", ls_null)

	end if	
	
END IF /*Pandora*/


IF Left(gs_project,4) = "NIKE" THEN
	idw_main.SetITem(1,"inventory_type",'S') /* 11/11 - PCONKL - Default to Stock Returns for Nike*/
Else
	idw_main.SetITem(1,"inventory_type",'N') 
End If


IF gs_project = "MAQUET" THEN

	idw_main.SetItem(1,"ord_type",'N') /* 03/09 mea - default to NO SAP*/

ElseIF Left(gs_project,4) = "NIKE" THEN
	
	idw_main.SetItem(1,"ord_type",'X') /* 11/11 - PCONKL - default to returns for Nike*/
	
ELSE

	idw_main.SetITem(1,"ord_type",'S') 
	
	
END IF


IF gs_project = "PANDORA" THEN
	idw_main.SetItem(1, "user_field7", "MATERIAL RECEIPT")
END IF

idw_main.SetItem(1,"create_user", gs_userid )
idw_main.SetItem(1,"Source_Type","MANUAL") //07-Dec-2015 :Madhu Added Source Type

// 03/06 - PCONKL - support for multiple suppliers on order based on Ord Type
lsOrdType = idw_main.GetITEmString(1,"ord_type")

Select multiple_supplier_ind into :lsSupplierInd
From Receive_Order_Type
Where project_id = :gs_project and ord_type = :lsOrdType;

		
		
idw_main.SetITem(1,"multiple_supplier_ind",lsSUpplierInd)
wf_set_supplier_visibility()

idw_rma_serial.Reset() /*05/05 - PCONKL */
wf_checkstatus()

//11-Feb-2015 Madhu- Disable protect/ Set Tab Order property on columns -START
IF idw_main.Object.supp_invoice_no.protect ='1' THEN 	idw_main.Modify("supp_invoice_no.protect=0")
IF idw_main.Object.user_field12.TabSequence='0' THEN idw_main.Modify("user_field12.TabSequence=240")
IF idw_main.Object.user_field13.TabSequence='0' THEN idw_main.Modify("user_field13.TabSequence=250")
IF idw_main.Object.user_field14.TabSequence='0' THEN idw_main.Modify("user_field14.TabSequence=260")
IF idw_main.Object.user_field15.TabSequence='0' THEN idw_main.Modify("user_field15.TabSequence=270")
IF idw_main.Object.user_field16.TabSequence='0' THEN idw_main.Modify("user_field16.TabSequence=280")
IF idw_main.Object.user_field17.TabSequence='0' THEN idw_main.Modify("user_field17.TabSequence=290")
//11-Feb-2015 Madhu- Disable protect/ Set Tab Order property on columns -END

idw_main.Show()
idw_main.SetFocus()
idw_main.SetColumn("supp_invoice_no")

//TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
//TAM - W&S 2011/04  -   GRN is Formatted.  We will not allow entry into this field.  
	If Left(gs_project,3) = 'WS-'  Then
		idw_Main.SetTabOrder("supp_invoice_no",0)
		idw_main.SetColumn("ord_date")
		idw_Main.SetTabOrder("user_field9",0)
		idw_Main.SetTabOrder("user_field13",330)
	End If


// 11/11 - PCONKL - For Nike, we are gooing to assign the order number...FOr mat is RCTYYYYMMxxxxx where YYYY=Year and MM=Month. Wanted to store entire value in Seq Generater but too large for a Long. We will store the MM and sequence
//							Sweeper will bump up the month and reset the sequence at the beginning of the month

IF Left(gs_project,4) = "NIKE" THEN
	
	ll_no = g.of_next_db_seq(gs_project,'Receive_Master','SUPP_INVOICE_NO')
	If ll_no <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available order Number!")
	else
		idw_main.SetITem(1,'supp_invoice_no','RCT' + String(today(),'YYYY')   +  string(ll_no,'00000'))
		idw_main.SetITem(1,'supp_code','NIKE')
	End If
	
End If /*Nike*/

end event

event ue_retrieve;call super::ue_retrieve;isle_code.TriggerEvent(Modified!)

end event

event ue_save;Integer li_ret,li_ret_l,li_ret_ll,li_return, i_indx
long i,ll_totalrows, ll_no,llOwnerID, ll_Owner_Id
long llFindRow, ll_return  // 02/21/201\1 ujh: I-135:
String	ls_Order, lsRONO, lsOrdStat, lsOwnerName, ls_INActiveCustomerName, ls_Sub_Inventory_Type, ls_CustCode, lsSuppOrdNo
string ls_costcenter, ls_location
string lsFind // 02/21/2011 ujh: I-135:
Long ll_rowCount, p,p2, ll_PutawayCount, li_count, li_ItemChecked,li_inadequate_sku_count
string lsWarehouse 

integer li_save_Failed
//TimA 04/07/13 Pandora issue #560
Long llCooCount,c
String lsCoo
//TimA 02/12/14 Added new Method Trace calls
is_suppinvoiceno= idw_main.getitemstring(1,'supp_invoice_no')
f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','start ue_save: ',is_rono,' ',' ' ,is_suppinvoiceno) 

// 08/13 GailM #608 Set ibFootprint replaces ibLPN
// 10/03/2013 GailM - Wrap test for LPN around test that Putaway list has at least one record.
If idw_putaway.RowCount() > 0 then
	If upper(gs_project) = 'PANDORA'  and ( (idw_putaway.GetItemString(1,'serialized_ind') = 'B' and idw_putaway.GetItemString(1,'po_no2_controlled_ind') = 'Y' and idw_putaway.GetItemString(1,'container_tracking_ind') = 'Y') Or idw_putaway.GetItemString(1,'foot_prints_ind') = 'Y') Then
		ibFootprint = true
	Else
		ibFootprint = false
	End If
End if

//MEA - 4/13 - OTM
IF g.is_OTM_Enable_Ind = 'Y' AND g.isOTMSendInboundOrder = 'Y' Then
	If Not isvalid(in_otm) Then
		in_otm = CREATE n_otm
	End if
End IF

IF f_check_access(is_process,"S") = 0 THEN Return -1

SetPointer(HourGlass!)

// 04/17/03 - PCONKL - Make sure the order has not been confirmed/voided by another user since last changed here
If idw_main.RowCount() > 0 Then
	lsRONO = idw_Main.GetITemString(1,'RO_NO')
	If not isnull(lsRONO) and lsRONO > '' Then
		// 1/26/2011; David C; Prevent this validation if admin has reset the order status to New
		if not ib_OrdStatusReset then
			Select ord_status into :lsOrdStat
			From REceive_Master
			Where project_id = :gs_Project and ro_no = :lsRoNo;
		
			If (lsOrdStat <> idw_main.GetITemString(1,'Ord_status')) and (lsOrdStat = 'C' or lsOrdStat = 'V') Then
				//TimA 02/12/14 Added new Method Trace calls
				f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Received error that order was changed by another user: ',is_rono,' ',' ' ,is_suppinvoiceno) 
				//Messagebox(is_title,'The Status of this order has been changed by another user since it was retrieved.~r~rPlease re-retrieve this order and make your changes again.')
				wf_display_message('The Status of this order has been changed by another user since it was retrieved.~r~rPlease re-retrieve this order and make your changes again.')	// LTK 20150130 batch confirm
				REturn -1
			End If
		else
			ib_OrdStatusReset = false
		end if
	End If
End If

// pvh - gmt 11/22/05
datetime ldtGMT

If idw_main.RowCount() > 0 Then
	// pvh - gmt 11/22/05
	ldtGMT = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 
	idw_main.SetItem(1,'last_update',	ldtGMT  ) // pvh - gmt 11/22/05
	idw_main.SetItem(1,'last_user',gs_userid)

	//TAM 2016/10/06  if Client_Cust_PO_Nbr is Blank,  Populate it with the supp_invoice_nbr
	If upper(gs_project) = 'PANDORA'  and	(isnull(idw_Main.GetITemString(1,'client_cust_po_nbr')) or idw_Main.GetITemString(1,'RO_NO') = '') Then
		idw_main.SetItem(1,'client_cust_po_nbr', is_suppinvoiceno)
	End If
	
	If not ib_save_via_confirm Then		//#608
		If wf_validation() = -1 Then
			//TimA 02/12/14 Added new Method Trace calls
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Validation Error order failed save: ',is_rono,' ',' ' ,is_suppinvoiceno) 
			SetMicroHelp("Save failed!")
			Return -1
		End If 
	End If
End If

w_main.SetMicroHelp('Saving Changes...')

// Assign Order No.

ib_edit = ib_edit

If ib_edit = False Then
	
	// 10/00 PCONKL - Using Stored procedure to get next available RO_NO
	//						Prefixing with Project ID to keep Unique within System
		
	ll_no = g.of_next_db_seq(gs_project,'Receive_Master','RO_No')
	If ll_no <= 0 Then
		//messagebox(is_title,"Unable to retrieve the next available order Number!")
		wf_display_message("Unable to retrieve the next available order Number!")	// LTK 20150130 batch confirm
		Return -1
	End If
	
	ls_order = Trim(Left(gs_project,9)) + String(ll_no,"000000")
			
	idw_main.SetItem(1,"project_id",gs_project)
	idw_main.SetItem(1,"ro_no",ls_order)

//TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
//Format is (WH_CODE(3rd and 4TH Char)) + "A" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
// New Baseline.  If the Supplier Invoice code is Not specified as Supplier specific it will return 'NA' and behave like it use to
//Left 3 characters = WS- for Wine and Spirt.
	If Left(gs_project,3) = 'WS-'  Then
		lsSuppOrdNo =  Mid(gs_project,4,2) + '-A' + String(Today,'YYMM') + String(ll_no,"0000")
		idw_main.SetItem(1, "supp_invoice_no", lsSuppOrdNo)
	End If

	For i = 1 to idw_detail.RowCount()
		idw_detail.SetItem(i, "ro_no", ls_order)
	Next		
	
Else /*updating existing record*/
	
	If idw_main.RowCount() > 0 Then
		If idw_main.GetItemString(1, "ord_status") <> "C" and &
			idw_main.GetItemString(1, "ord_status") <> "Q" and /* 07/02 - PCONKL - Leave QA Hold if set */ & 
			idw_main.GetItemString(1, "ord_status") <> "V" Then
			If idw_putaway.RowCount() > 0 Then
				idw_main.SetItem(1, "ord_status", "P")
			Else
				idw_main.SetItem(1, "ord_status", "N")			
			End If
		End If
		This.Trigger event ue_refresh() 
	End If
	
End If

//Checking if serilised or po or lot status is "y" or "N'
// pvh 09/12/05 - COO on putaway - refactor validation
if doAcceptText() < 0 then return -1

// 20110316 LTK	Moved the "Joel validation" block to a function which is now 
//						called *outside* of the update transaction.
String ls_pandora_validation_error

if gs_project = "PANDORA" then
	ls_pandora_validation_error = wf_pandora_save_validations()
end if


// ET3 2012-11-08 Pandora 534 - Country of Dispatch Required for certain orders
IF gs_project = 'PANDORA' THEN
	
	STRING ls_uf7
	STRING ls_uf5
	
	ls_uf7 = idw_main.GetItemString( 1,"user_Field7")
	ls_uf5 = idw_main.GetItemString( 1,"user_Field5")
	
	IF upper(trim(ls_uf7)) = "PO RECEIPT"  OR upper(trim(ls_uf7)) = "EXP PO RECEIPT" THEN
		
		//Make User_Field5 (Country of Dispatch) on Inbound required where UF7 = PO RECEIPT (and EXP PO RECEIPT)
		IF IsNull(ls_uf5) OR trim(ls_uf5) = "" THEN
			//TimA 02/12/14 Added new Method Trace calls
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','County of Dispatch (UF5) is required: ',is_rono,' ',' ' ,is_suppinvoiceno) 			
			//MessageBox (is_Title, "County of Dispatch (UF5) is required.")
			wf_display_message("County of Dispatch (UF5) is required.")	// LTK 20150130 batch confirm
			idw_main.SetColumn("user_Field5")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			return -1
			
		ELSEIf NOT isnull(ls_uf5) AND Trim(ls_uf5) <> '' Then
			//Valid UF5 against Country Table
			SELECT Count(ISO_Country_Cd) INTO :li_count 
			FROM Country
			WHERE Designating_Code = :ls_uf5 USING SQLCA;
					
			If li_Count <= 0 Then
				//TimA 02/12/14 Added new Method Trace calls
				f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','County of Dispatch (UF5) is required: ',is_rono,' ',' ' ,is_suppinvoiceno) 							
				//MessageBox (is_Title, "County of Dispatch (UF5) is invalid.")
				wf_display_message("County of Dispatch (UF5) is invalid.")	// LTK 20150130 batch confirm
				idw_main.SetColumn("user_Field5")
				tab_main.SelectTab(1)
				idw_main.SetFocus()
				return -1 
			End IF
				
		END IF

		// LTK 20150813  Added exclusion check for COO = 'XX'   if invoice number contains certain masks
		if NOT wf_is_xx_coo_check_excluded( is_suppinvoiceno ) then
			llCooCount = idw_putaway.rowcount( )
			For c = 1 to llCooCount
				lsCoo = idw_putaway.Getitemstring(c,'country_of_origin')
			next
		end if

	End if


END IF // Pandora

//20-Nov-2014 :Madhu- Added validation for KLN B2B SPS Conversion- START
IF Upper(gs_Project)= 'KLONELAB' Then
	string ls_user_field13
	ls_user_field13 = idw_main.GetItemString(1,'User_field13')
	
	if not isnull(ls_user_field13) then
		if ls_user_field13 <> "B2B"  and ls_user_field13 <>"SPS" Then
			wf_display_message("User Field13 must be either B2B or SPS.")	// LTK 20150130 batch confirm
			idw_main.SetColumn("user_Field13")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			return -1
		end if
	else
		wf_display_message("User Field13 must be either B2B or SPS.")	// LTK 20150130 batch confirm
		idw_main.SetColumn("user_Field13")
		tab_main.SelectTab(1)
		idw_main.SetFocus()
		return -1
	end if
END IF
//20-Nov-2014 :Madhu- Added validation for KLN B2B SPS Conversion- END

if Len(ls_pandora_validation_error) > 0 then
	return -1
end if

//8-APR-2019 :Madhu DE9675 - ByPass validation upcon confirmation
IF not ib_save_via_confirm Then
	
	//28-JULY-2018 :Madhu S21780 Label Consolidation - START
	If upper(gs_project) ='PANDORA' and idw_putaway.rowcount( ) > 0  and f_retrieve_parm("PANDORA", "FOOTPRINT", "FOOTPRINT_LABELS" ,"USER_UPDATEABLE_IND") = 'Y'  Then
		If MessageBox( is_title, "Are vendor labels compliant (Yes/No)", Question!, YesNo!, 1) = 1 Then
			ib_vendor_label_compliant = True
		else
			ib_vendor_label_compliant = False
		End If
	End If
	//28-JULY-2018 :Madhu S21780 Label Consolidation - END
	
		
	//2019/03 - TAM S30669 DE9674 Are putaway attributes match phyical stock - START
	IF upper(gs_project) ='PANDORA' and idw_putaway.rowcount( ) > 0 THEN
		If MessageBox(is_title, "Do generated attributes on the Putaway List match the Physical Stock on the dock? ", Question!, YesNo!, 1) = 0 Then
			MessageBox(is_title, "Please enter the attributes on the Putaway List ! ")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			return -1
		End If
	END IF
// Begin - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
//1.	We want a new waning message to pop up.  
//2.	New warning message should say the following:  You will need to print out new part labels for this inbound order.
//3.	There should be an ‘OK’ button at the bottom of the message.
//4.	When the operator clicks on he ‘OK’ button, SIMS will continue to save the inbound order
//5.	After the save of the inbound order SIMS will auto open the Part Label screen under Utility
lsWarehouse = idw_main.GetItemString(1,"wh_code")
select Inbound_ord_Ind into :is_Inbound_ord_Ind from Warehouse where wh_code=:lsWarehouse using sqlca;
	IF upper(gs_project) ='PANDORA' and idw_putaway.rowcount( ) > 0 and is_Inbound_ord_Ind='Y'THEN
		If MessageBox(is_title, "You will need to print out new part labels for this inbound order ", Question!, YesNo!, 1) = 1 Then
			ib_inbound = True
		else 
			ib_inbound = False
		End if
	End if 
// End - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
	
	//29-APR-2019 :Madhu S32505 F15371 - Add Container Level validations.
	// TAM - 2019/06/07 - DE10877 - Added a check to see if order was deleted
//	IF upper(gs_project) = 'PANDORA' THEN
	IF upper(gs_project) = 'PANDORA' and  idw_main.RowCount() > 0 THEN
		IF wf_validate_container_against_edi_record() < 0 THEN Return -1
	END IF
END IF
//2019/03 - TAM S30669 Are putaway attributes match phyical stock - END

// Updating the Datawindow

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	li_ret = idw_main.Update()
Else 
	li_ret = 1
End If



//dts - 9/8/2010 SQLCA.DBParm = "disablebind =0"
If li_ret = 1  Then li_ret = idw_detail.Update()

//Band-Aid fix to save Chinese.
//MEA - This is now run from Citrix instead of local in China. Hoping 2008 will fix the issue.


If Upper(gs_project) = 'PULSE' THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//cawikholm 07/26/11 Added check for SupportUnicode set disablebind so Chinese characters can be saved.
If g.ibSupportUnicode = TRUE THEN
	 SQLCA.DBParm = "disablebind =0"
End If

If li_ret = 1  Then li_ret = idw_putaway.Update()

// 02/21/2011 ujh: I-135:  Zero out putaway qty to force entry
If Upper(gs_project) = 'PANDORA' THEN
	// Closes a window that might be open when putaway value is corrected so window will not now open
	if isvalid(w_detail_putaway_compare) then
		close(w_detail_putaway_compare)
	end if
	
	lsFind = 'Req_qty <> Alloc_qty'
	llFindRow = idw_detail.Find(lsFind, 1, idw_detail.RowCount())
	if llFindRow > 0 and idw_putaway.RowCount() > 0 Then
	/* If any quantity mismatch, show on the comparison window.  This window will open only when 
		there is a mismatch and putaway is populated.  If putaway values are changed to matching while the window is open, it 
		will be closed  and will re-open if there is still a mismatch*/
		
		// Do not show comparison if ue_save was called from confirm
		if not ib_save_via_confirm then
			li_save_Failed = 1
		end if
	end if
end if
/////////////////////END   01/2102011 ujh: I-135:  Zero out putaway qty to force entry

If Upper(gs_project) = 'PULSE' THEN
	 SQLCA.DBParm = "disablebind =1"
End If

// cawikholm 07/26/11 Set disablebind back to 1 - this is the default for ole db
If g.ibSupportUnicode = TRUE THEN
	 SQLCA.DBParm = "disablebind =1"
End If

is_rono=idw_main.GetItemString(1,'ro_no') //17-Nov-2014 :Madhu- Added to get Ro No

If li_ret = 1 Then
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','start update content datawindow: ',is_rono,' ',' ' ,is_suppinvoiceno) 
End if

if li_ret = 1 then li_ret = idw_content.Update()

If li_ret = 1 then
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','end - update content datawindow ',is_rono,' ',' ' ,is_suppinvoiceno) //08-Feb-2013 : Madhu added
End if

//if li_ret = 1 then li_ret = idw_rma_serial.Update() /* 05/05 - PCONKL */  GailM 9/17/2019 Replace with call to function.  DE11788
if li_ret = 1 then 
	li_ret = idw_rma_serial.Update()
	If li_ret <> 1 Then
		li_ret = wf_alt_rma_serial_save(idw_rma_serial)
		If li_ret = 1 Then
			idw_rma_serial.Reset()
			idw_rma_serial.Retrieve(is_rono, gs_project)
		Else
			f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Save ue_save ' + "Unable to update Receive Putaway Serial record.! ",lsRONO,' ',' ',is_suppinvoiceno ) 
		End If
	Else
		idw_rma_serial.Reset()
		idw_rma_serial.Retrieve(is_rono, gs_project)
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Save ue_save ' + "Receive Putaway Serial record saved.! ",lsRONO,' ',' ',is_suppinvoiceno ) 
	End If
End If


If idw_main.RowCount() = 0 and li_ret = 1 Then li_ret = idw_main.Update()
//dts - 9/8/2010 SQLCA.DBParm = "disablebind =1"

// pvh - 11/29/06 - Marl 
If idw_main.RowCount() > 0 Then
	if Upper( gs_project ) = '3COM_NASH'  and idw_main.GetItemString(1, "ord_type") = 'X' then
		if li_ret = 1 then 	li_ret = idsmarladjustment.update()
	end if
End If

IF (li_ret = 1) THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
			This.Title = is_title  + " - Edit"
			wf_checkstatus()
			SetMicroHelp("Record Saved!")
		End If
	//	Return 0
	
	
	//OTM - MEA - 4/12

	If g.is_OTM_Enable_Ind = 'Y' AND g.isOTMSendInboundOrder = 'Y' Then
		//TimA 02/12/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Call OTM: ',is_rono,' ', ' ' ,is_suppinvoiceno) 			
		in_otm.uf_process_inbound_order(gs_project, idw_main, idw_detail)
	
	End If
	
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		
	      //MessageBox(is_title, SQLCA.SQLErrText)
		wf_display_message(SQLCA.SQLErrText)	// LTK 20150130 batch confirm
		//TimA 02/12/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Save Failed and Rollback: ',is_rono,' ', SQLCA.SQLErrText ,is_suppinvoiceno) 			
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	//TimA 02/12/14 Added new Method Trace calls
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','System Error record saved failed: ',is_rono,' ', SQLCA.SQLErrText ,is_suppinvoiceno) 				
	wf_display_message("System error, record save failed!")	// LTK 20150130 batch confirm
	Return -1
END IF


if li_save_Failed = 1 then
	//Part of the Pandora issue #135
	this.wf_detail_vs_putaway()	
end if

idw_detail.Sort()

//BCR 09-FEB-2012: Any project that has this kind of project/warehouse level sort on Putaway (like Bluecoat does) may run into run-time problems if there are Components attached to Parents. 
//                           In Bluecoat's case, Child Component shows up on row 1, followed by Parent on row 2. When you select Location for Parent, it doesn't copy down into Child.  
//                           So, per Pete Conklin, trigger this event ONLY if there are no Child Components.
If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) = 0 Then
	This.TriggerEvent('ue_sort_Putaway')
END IF

If Pos(this.Title,'[') = 0 and idw_main.RowCount() > 0 Then
	This.title = This.Title + " [" + idw_main.GetITemString(1,'supp_invoice_no') + "]"
End If

this.wf_set_rma_serial_tab_status() //8-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp

// 02/06 - If a WO creation was requested at Putaway, create the QO now that Putaway has been saved
if ibWORequested Then
	This.TriggerEvent('ue_workorder')
	ibWORequested = False
End If

//08-Feb-2013  :Madhu Code -START
string lssuppinvocieno
Select Supp_Invoice_No into :lssuppinvocieno
From Receive_Master with(nolock)
Where project_id = :gs_Project and ro_no = :lsRoNo;

is_suppinvoiceno = lssuppinvocieno
			
//08-Feb-2013  :Madhu Code -END

w_main.SetMicroHelp('Ready...')
//TimA 02/12/14 Added new Method Trace calls
f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','End ue_save: ',is_rono,' ',' ' ,is_suppinvoiceno) 		
// Begin - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
If ib_inbound= True and  upper(gs_project) = 'PANDORA' then
	OpenSheetWithParm(w_pandora_part_label_print, "  ", w_main,gi_menu_pos, Original!)
else
	return 0
end if
// End - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
Return 0

	

end event

event ue_refresh;// 10/31/02 - PConkl - Qty fields changed to Decimal

Long i, ll_rowcnt1, j, ll_rowcnt2, llLineItem
String ls_sku, ls_Supplier, ls_prev_sku
Decimal	ld_balance1, ld_balance2, ld_req, ld_alloc, ld_damage


//pvh - 02.01.06
//disable detail tab based on project-level indicator (for Electronically-received orders) 
if gs_role = '2' and g.getReceiveDetailChangeInd() = "N" and	idw_main.object.edi_batch_seq_no[1] > 0 THEN
	idw_detail.object.datawindow.ReadOnly = "Yes"
	tab_main.tabpage_orderdetail.cb_insert.enabled = false
	tab_main.tabpage_orderdetail.cb_delete.enabled = false
	tab_main.tabpage_orderdetail.cb_iqc.enabled = false
	tab_main.tabpage_orderdetail.cb_list_sku.enabled = false
end if


//13-Aug-2014 : Madhu- Added code to lock the line_item_no for Electronically received orders for Ariens -START
if idw_main.object.edi_batch_seq_no[1] > 0 and gs_project='ARIENS' Then
	idw_detail.object.line_item_no.protect=1
end if
//13-Aug-2014 : Madhu- Added code to lock the line_item_no for Electronically received orders for Ariens -END

// This event is to refresh the Alloc and Damage Qty in idw_detail from idw_putaway

//08/02 - PCONKL - No need top refresh unless something has changed -   
// TAM 2018/04 - DE3844  SIMS Baseline - Need to refresh Received Qty when order opened because of SIMS Mobile
//If not ib_Changed Then REturn

 // pvh 09/12/05 - COO on putaway - refactor validation
if doAcceptText() < 0 then return

ll_rowcnt1 = idw_detail.RowCount()
ll_rowcnt2 = idw_putaway.RowCount()

For i = 1 to ll_rowcnt1
	idw_detail.SetItem(i, "alloc_qty", 0)
	idw_detail.SetItem(i, "damage_qty", 0)
Next

j = 1
For i = 1 to ll_rowcnt2
	SetMicroHelp("Calculating allocated and damage quantity for item " + String(i)) 
	// 09/00 PCONKL - Dont include component child qty's
	If idw_putaway.GetItemString(i,"Component_ind") = '*' Then
	Else
		ls_sku = idw_putaway.GetItemString(i,"sku")
		ls_supplier = idw_putaway.GetItemString(i,"supp_code")
		llLineItem = idw_putaway.GetItemNumber(i,"line_item_no")
		// 02/01 - PCONKL - Include Supplier in find, always start with first row for find and compare uppercase (find is case sensitive)
		// 08/01 - PCONKL - Include Line Item No in Find - may have same sku with diff line item numbers
		j = idw_detail.Find("Upper(sku) = '" + Upper(ls_sku) + "' and Upper(supp_code) = '" + Upper(ls_supplier) + "' and line_item_no = " + string(llLineItem), 1, ll_rowcnt1)
		If j > 0 Then	
			If idw_putaway.GetItemString(i, "inventory_type") = "D" Then
				idw_detail.SetItem(j, "damage_qty", &
					idw_detail.GetItemNumber(j, "damage_qty") + &
					idw_putaway.GetItemNumber(i,"quantity"))
			Else
				idw_detail.SetItem(j, "alloc_qty", &
					idw_detail.GetItemNumber(j, "alloc_qty") + &
					idw_putaway.GetItemNumber(i,"quantity"))
			End If
		End If
	End If /*Not Component*/
Next

// 05/03 - PCONKL - What the hell was going on here?!?
//ld_balance1 = 0
//ld_balance2 = 0
//For i = 1 to ll_rowcnt1
//	ls_sku = idw_detail.GetItemString(i,"sku")
//	If ls_sku = ls_prev_sku Then
//		idw_detail.SetItem(i, "alloc_qty", &
//			idw_detail.GetItemNumber(i, "alloc_qty") + ld_balance1)
//		idw_detail.SetItem(i - 1, "alloc_qty", &
//			idw_detail.GetItemNumber(i - 1, "alloc_qty") - ld_balance1)
//		idw_detail.SetItem(i, "damage_qty", &
//			idw_detail.GetItemNumber(i, "damage_qty") + ld_balance2)
//		idw_detail.SetItem(i - 1, "damage_qty", &
//			idw_detail.GetItemNumber(i - 1, "damage_qty") - ld_balance2)
//	End If
//	ld_balance1 = 0
//	ld_balance2 = 0
//	ld_req = idw_detail.GetItemNumber(i, "req_qty")
//	ld_alloc = idw_detail.GetItemNumber(i, "alloc_qty")
//	ld_damage = idw_detail.GetItemNumber(i, "damage_qty")
//	If ld_alloc + ld_damage > ld_req Then
//		If ld_alloc = ld_req Then
//			ld_balance1 = ld_alloc - ld_req
//			ld_balance2 = ld_damage
//		Else
//			ld_balance2 = ld_alloc + ld_damage - ld_req
//		End If
//	End If
//	ls_prev_sku = ls_sku
//Next

SetMicroHelp("Ready")

Return 
end event

event ue_print;Str_parms	lstrparms
string lsWH, lsFind
integer liButton, liFound
long llCount
datastore ldsPrint
n_labels	lu_labels

//dts - 2014-04-24, Pandora Issue #844 - Cube Scan validation (update to Pandora Issue #708 - no hard stop at put-away generation, hard stop at print)
String ls_WghDim, ls_cube_scan, ls_sku_list
string ls_wh_code, lsSKU, lsSupplier, lsSkuSupplier_Hold
integer li_idx
Boolean lb_WghDimValidate
ls_WghDim = 'N'
lb_WghDimValidate = False

ldsPrint = Create Datastore		//GailM 03/18

// 06/06 - PCONKL - GM DEtroit has the option to print tags or list
If gs_project = 'GM_MI_DAT' Then
	OpenWithParm(w_putaway_print_Type,lstrparms)
	lstrparms = Message.PowerobjectParm
	If lstrparms.Cancelled Then Return
	If lstrparms.String_arg[1] = 'T' Then /*Print tags*/
		OpenSheet(w_gm_print_putaway_tags,w_main, gi_menu_pos, Original!)
		return
	End If
End IF


//dts - 2014-04-24 - Pandora #844 - moving DIMs/WGT hard stop to printing of Put-away list (from put-away generation)...
if gs_Project = 'PANDORA' then
	//see if WH uses the Cube Scan...
	ls_wh_code = Upper(idw_main.getitemstring(1, 'wh_code'))
	Select User_Updateable_Ind INTO :ls_WghDim FROM lookup_table with (NoLock) 
	Where Project_ID = :gs_project AND Code_Type = 'CUBE_SCAN' and Code_Id = :ls_wh_code  USING SQLCA;
	
	If ls_WghDim = 'Y' then //  - Wgt/Dims capture is turned on for this Warehouse
	//dts 5/1/14 - changing from detail dw to putaway dw (duh).
		FOR li_idx = 1 to idw_putaway.RowCount()
			lsSKU = idw_putaway.GetItemString(li_idx,"sku")
			lsSupplier = idw_putaway.GetItemString(li_idx,"supp_code")
			if lsSKU + lsSupplier <> lsSkuSupplier_Hold then
				lsSkuSupplier_Hold = lsSKU + lsSupplier
	
				//See if Wgt/DIMs have been captured via Cubiscan....
				Select User_Field20 Into :ls_Cube_Scan
				FROM item_master
				Where project_id = :gs_project
				and supp_code = :lsSupplier
				and sku = :lsSKU;
				If ls_cube_scan= '' or IsNULL( ls_cube_scan)  Then //Cubiscan stamp is missing in Item Master UF20
					if Len(ls_sku_list) > 0 then
						if Pos(ls_sku_list, lsSKU) = 0 then
							ls_sku_list += ", " + lsSKU
						end if
					else
						ls_sku_list = lsSKU
					end if
					lb_WghDimValidate = True
				End if //is the Cubiscan (UF20) stamp missing?
			end if //New SKU
		Next
	End if // - Wgt/Dim capture turned on for the warehouse

	If lb_WghDimValidate = True then
		MessageBox("GPN Weights/Dims missing", "Dims/wts for the following GPN(s) have not been validated by the Cubiscan. Please measure these parts: ~r~r" + ls_sku_list )
		Return // don't let them print without capturing DIMS (actually, without a value in UF20).
	End if
	
	//GailM 3/29/2018 - S17580 F7364 I623 - Google - SIMS Putaway and Picking Blind Count Sheets
	ldsPrint.Dataobject = 'd_putaway_prt_pandora_audit'
	ldsPrint.SetTransObject(SQLCA)


end if //Pandora

//GailM 7/23/2019 Check putaway list for SKU that is serialized.  If present set serialized present flag on
For  li_idx = 1 to idw_putaway.RowCount()
	If idw_putaway.GetItemString(li_idx,'serialized_ind') = 'B' or idw_putaway.GetItemString(li_idx,'serialized_ind') = 'Y'  Then
		ib_serialized_present = TRUE
		continue
	End If
Next

//5-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//GailM 7/23/2019 DE11808 Putaway list not printing if not serialized present
IF g.ib_receive_putaway_serial_rollup_ind and ib_serialized_present THEN
	If idw_rma_serial.rowcount() = 0 Then
		llCount = idw_rma_serial.retrieve(is_rono, gs_project)
		If llCount > 0 Then
			f_putaway_print(iw_window, idw_main, idw_putaway, idw_rma_serial, idw_print, ldsPrint )
		Else
			f_putaway_print(iw_window, idw_main, idw_putaway, idw_rma_serial, idw_print, ldsPrint )
		End If
	Else
		f_putaway_print(iw_window, idw_main, idw_putaway, idw_rma_serial, idw_print, ldsPrint )
	End If
ELSE
	f_putaway_print(iw_window, idw_main, idw_putaway, idw_rma_serial, idw_print, ldsPrint )
END IF

idw_main.SetItem(1, "ord_status", "P")	

// 10/19/06 - dts - 3COM Eersel wants option to print put-away details...
// 06/07/07 - dts - Powerwave wants the option as well...
lsWH = idw_main.GetItemString(1, "wh_code")
If (gs_project = '3COM_NASH' and lsWH = '3COM-NL') or gs_project = 'POWERWAVE' or gs_project = 'EMU-CEO' Then
	liButton = MessageBox(is_title, "Would you like to print Put-away Details?", Question!, YesNoCancel!, 1)
	if liButton = 1 THEN
		
		// EMU-CEO printing on a zebra label
		If  gs_project = 'EMU-CEO' Then
			lu_labels = Create n_labels
			lu_labels.uf_emu_ceo_receiving_label()
		Else
			
			//printing putaway details...
			ldsPrint.Dataobject = 'd_3com_print_putaway_details'
			ldsPrint.SetTransObject(SQLCA)
			llCount = ldsPrint.Retrieve(is_RoNo)
			If llCount > 0 Then
				Openwithparm(w_dw_print_options, ldsPrint) 
			End IF
			
		End If
		
	ElseIf liButton = 2 then
		//not printing putaway details
	Else
		//cancel
		return
	End IF
end if

end event

event ue_postopen;DatawindowChild	ldwc, ldwc2,ldwc_inv
String				lsFilter
int liResult
long llCount

ib_changed = False
ib_edit = True
tab_main.MoveTab(2, 99)

iw_window = This

//29-MAR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
If  g.ib_receive_putaway_serial_rollup_ind Then
	tab_main.Tabpage_rma_serial.Visible = True
else
	tab_main.Tabpage_rma_serial.Visible = False
End If

if Upper( gs_project ) = 'AMS-MUSER' then
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_ams_muser'
 tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
end if

//7/13 - MEA - Added for Pulse
if Upper( gs_project ) = 'STBTH' then
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_starbucks'
 tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
end if

//Add the new barcode for PE-THA and PHILIPS-TH:- Nxjain 03/12

//if Upper( gs_project ) = 'PE-THA' or  Upper( gs_project ) = 'PHILIPS-TH'  then
if Upper( gs_project ) = 'PE-THA' or  Upper( gs_project ) = 'PHILIPS-TH' or  Upper( gs_project ) = 'TPV' &
	or  Upper( gs_project ) ='FRANKE_TH'   then
//tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_petha'
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_barcode'
  tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
end if

//end Nxjain :-03/11

// 11/19/09 - UJHALL  -  If Pandora, set printed report to show owner
if Upper( gs_project ) = 'PANDORA' then
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_pandora'
 tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
	//dts - 10/16/2014 - adding a hook for SuperDuper users to override the DejaVu code (as requirements keep evolving)
	select count(Code_Type) into :llCount from Lookup_Table with(nolock)
	where project_id = 'pandora' and code_type = 'FLAG' and code_id = 'DejaVu_Override' and code_descript = 'Y';
	if llCount > 0 then
		ibDejaVu_Override = true
	end if

//TAM 2017/09/12 - SIMSPEVS-804 - for PANDORA, Remove "NEW" Toolbar option
//GWM 2017/09/28 - Removed - interfers with SIMS deploy 17-10 release (and now reentered for 17_9.1 deploy
		im_menu.m_record.m_new.Enabled = False
		im_menu.m_record.m_new.ToolBarItemVisible = False
		im_menu.m_record.m_new.Disable()

end if

//8/10 - MEA - Added for Pulse
if Upper( gs_project ) = 'PULSE' then
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_pulse'
 tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
end if

//TAM w&s - Added for Wiine and Spirits
if left(Upper( gs_project ),3) = 'WS-' then
 tab_main.tabpage_putaway.dw_print.dataobject = 'd_putaway_prt_ws'
 tab_main.tabpage_putaway.dw_print.settransobject( sqlca ) 
end if

// pvh - 03.10.06 MARL
//if Upper(gs_project) = '3COM_NASH' then
	idsItemMaster = f_datastoreFactory( "d_3com_ro_item_master_marl" )
	idsMarlAdjustment = f_datastoreFactory( "d_adjustment_sweeper" ) // copy of d_adjustment used in sweeper
	idsRLScan = f_datastoreFactory( "d_3com_rl_scan_ext" )
//end if

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_list_sku = tab_main.tabpage_orderdetail.dw_list_sku 
idw_print = tab_main.tabpage_putaway.dw_print
idw_search = tab_main.tabpage_search.dw_search
idw_condition = tab_main.tabpage_search.dw_condition
isle_code = tab_main.tabpage_main.sle_orderno
isle_order2 = tab_main.tabpage_main.sle_order2
idw_detail = tab_main.tabpage_orderdetail.dw_detail
idw_putaway = tab_main.tabpage_putaway.dw_putaway
idw_putaway_mobile = tab_main.tabpage_putaway.dw_putaway_mobile /* 06/15 - PCONKL */
idw_notes = tab_Main.tabpage_Notes.dw_notes 
idw_content = tab_main.tabpage_putaway.dw_content
idw_carton_serial = tab_main.tabpage_putaway.dw_carton_serial
idw_other = tab_main.tabpage_other_info.dw_other


idw_rma_serial = tab_main.tabpage_rma_serial.dw_rma_serial
idw_scanner = dw_scanner
idw_detail.GetChild("supp_code",idwc_supplier)

idw_list_sku.SetTransObject(Sqlca)
idw_print.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idwc_supplier.SetTransObject(Sqlca)

//GailM - Named field changes 03/15
//idw_other.SetTransObject(Sqlca)
idw_main.ShareData(idw_other)
idw_main.ShareData(idw_putaway_mobile) /* 06/15 - PCONKL */

//TimA 04/09/14 Pandora issue #36
icb_confirm = tab_main.tabpage_main.cb_confirm

//01/03 - PCONKL - retrieve Warehouse by Project instead of filtering

idw_condition.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
// 04/04 - PCONKL - Loading from USer Warehouse Datastore - also required entry on Search Criteria - Must search by single warehouse
g.of_set_warehouse_dropdown(ldwc)
//ldwc.Retrieve(gs_Project)

//Share Warehouse with Order Info Tab
idw_main.GetChild("wh_code",ldwc2)
ldwc.Sharedata(ldwc2)

//03/03 - PCONKL -Order Type now project specific  - retrive by project and share with Search screen and search result
idw_condition.GetChild("ord_type",ldwc)
ldwc.SetTransObject(sqlca)
ldwc.Retrieve(gs_project)
idw_main.getChild('ord_type',ldwc2)
ldwc.ShareData(ldwc2)
idw_search.getChild('ord_type',ldwc2)
ldwc.ShareData(ldwc2)

///BCR 06-SEP-2011 - Supplier Code now a dropdown datawindow
	idw_main.GetChild("supp_code",ldwc)
	ldwc.SetTransObject(sqlca)
	ldwc.Retrieve(gs_project)
	
	//TimA 09/20/11 on the Pandora project only show Pandora
	If Upper(gs_Project) = 'PANDORA' Then
		ldwc.SetFilter("Supp_Code = '" + gs_Project + "'" )
		ldwc.Filter( )
	End if


//04/04 - PCONKL - Share Global Carrier dropdown
idw_main.GetChild("carrier",ldwc)
g.ids_dddw_carrier.ShareData(ldwc)

idw_condition.SetTransObject(Sqlca)
idw_content.SetTransObject(Sqlca)
idw_scanner.SetTransObject(Sqlca)
idw_carton_serial.SetTransObject(Sqlca)

// 03/02 - PCONKL - Inv Type now being retrived by Project (in N_Warehouse) Putaway will be shared with Main
//i_nwarehouse.of_init_inv_ddw(idw_putaway)
i_nwarehouse.of_init_inv_ddw(idw_main)
idw_main.GetChild('inventory_type',ldwc)
idw_putaway.GetChild('inventory_type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)

tab_main.tabpage_putaway.cb_putaway_locs.Enabled = False

// 09/09 - PCONKL - Delivery Note button only visible for Philips right now - 12/12 - added TPV - 6/13 added FUNAI TAM-2015/03 - Added Gibson
//3-FEB-2019 :Madhu S28945 Added PHILIPSCLS
//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
If gs_project = 'PHILIPS-SG' or upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA' or gs_project = 'PHILIPS-TH' or  gs_project = 'SG-MUSER' or gs_project = 'WARNER' or gs_project = 'TPV' or gs_project = 'FUNAI'   or gs_project = 'GIBSON' Then
	tab_main.tabpage_putaway.cb_print_cn.visible =True
Else
	tab_main.tabpage_putaway.cb_print_cn.visible = False
End If

//  11/30 - GMOR - Pallet button on putaway tab is only visible for Comcast
If Upper(gs_Project) = 'COMCAST' Then
	tab_main.tabpage_putaway.cb_putaway_pallets.Visible = True
Else
	tab_main.tabpage_putaway.cb_putaway_pallets.Visible = False
End If
	
//GAP 06-03 check for inboundsku list functionality 
if g.is_in_sku_list_ind = "Y" Then tab_main.tabpage_orderdetail.cb_list_sku.visible = True 

idw_condition.InsertRow(0)
If gs_default_wh > '' Then
	idw_condition.SetITem(1,'wh_code',gs_default_wh) /* warehouse now required search field to keep users within their domain*/
End If

is_sql = idw_search.GetSQLSelect()
isOrigSqlSerial = tab_main.Tabpage_rma_serial.dw_rma_serial.GetSqlSelect()

// Default into edit mode
This.TriggerEvent("ue_edit")

// 04/03 - PCONKL - We may open this window from another function and pass an order number in to be processed
If UpperBound(Istrparms.String_arg) > 1 Then /*order number present*/
	//If prefixed by '*RONO*', RO NO has been passed instead of Order Number (usually when we have multiple orders of the same order number */
	If Left(Istrparms.String_arg[2],6) = '*RONO*' Then /*DO_NO passed*/
		is_Rono = Mid(Istrparms.String_arg[2],7)
	Else /*Order number passed */
		isle_code.Text = Istrparms.String_arg[2]
	End If
	isle_code.TriggerEvent('modified')
End If

//11th hour hiding of new cb_IQC button:
if gs_Project = 'LOGITECH' then
	tab_main.tabpage_OrderDetail.cb_IQC.visible = true
else
	tab_main.tabpage_OrderDetail.cb_IQC.visible = false
end if

//0606 - PCONKL - IMS verify only visible for GM Detroit
if gs_Project = 'GM_MI_DAT' then
	tab_main.tabpage_OrderDetail.cb_ims_verify.visible = true
End If

iuo_check_digit_validations = Create u_nvo_check_digit_validations /* 01/09 - PCONKL */
 
 
//  font.face="Arial" font.height="-9" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )
// GailM 20150323 - User fields moved to dw other 
if gs_Project = 'PANDORA' then
	string ls_wh_code

	idw_other.object.user_field2.dddw.name='dddw_pandora_sub_inv_locs'
	idw_other.object.user_field2.dddw.displaycolumn='cust_code'
	idw_other.object.user_field2.dddw.datacolumn='cust_code'
	idw_other.object.user_field2.dddw.useasborder='yes'
	idw_other.object.user_field2.dddw.allowedit='no'
	idw_other.object.user_field2.dddw.vscrollbar='yes'
	//TimA Pandora issue #238
	//Move and adjust the with of the DDW for the new field size of 20 characters
	idw_other.object.user_field2.width="825"
	idw_other.object.user_field2.dddw.percentwidth="225"	
	idw_other.object.user_field2.x="1559"
	idw_other.object.user_field2_t.x="1198"
	idw_other.object.user_field2_t.width="330"	
	idw_other.object.user_field3_t.width="380"
	idw_other.object.user_field3_t.x="2339"	
	
	idw_other.GetChild("user_field2", ldwc)
	ldwc.SetTransObject(SQLCA)
	idw_other.Modify("user_field6.Edit.Case='Upper'")  //07-Aug-2014 : Madhu- Made UF6 to upper case level.
	//TimA Pandora Issue #560
		
	idw_detail.Modify("country_of_origin.dddw.Name='dddw_get_item_master_coo'")
	idw_detail.Modify("country_of_origin.dddw.DataColumn='Country_Of_Origin'")
	idw_detail.Modify("country_of_origin.dddw.DisplayColumn='Country_Of_Origin'")
	idw_detail.Modify("country_of_origin.dddw.UseAsBorder='yes'")
	idw_detail.Modify("country_of_origin.dddw.VScrollBar='yes'")
	idw_detail.Modify("country_of_origin.dddw.HScrollBar='yes'")
		
	idw_detail.Modify("country_of_origin.dddw.Case='Upper'")
	
	idw_detail.Modify("country_of_origin.dddw.PercentWidth=400")
	idw_detail.Modify("country_of_origin.dddw.Lines=15")
	idw_detail.Modify("country_of_origin.dddw.AllowEdit=no")
	idw_detail.Modify("country_of_origin.dddw.AutoRetrieve=no")
	
	idw_detail.GetChild ( "country_of_origin", idwc_IM_Coo_Detail )
	idwc_IM_Coo_Detail.SetTransObject(Sqlca)
	
	//Putaway
	idw_putaway.Object.country_of_origin.dddw.Name             = "dddw_get_item_master_coo"
	idw_putaway.Object.country_of_origin.dddw.DataColumn    = "Country_Of_Origin"
	idw_putaway.Object.country_of_origin.dddw.DisplayColumn = "Country_Of_Origin"
	idw_putaway.Object.country_of_origin.dddw.UseAsBorder    = "Yes"
	idw_putaway.Object.country_of_origin.dddw.VScrollBar       = "Yes"
	idw_putaway.Object.country_of_origin.dddw.HScrollBar       = "Yes"
	
	idw_putaway.Modify("country_of_origin.dddw.Case='Upper'")
	idw_putaway.Modify("country_of_origin.dddw.PercentWidth=400")
	idw_putaway.Modify("country_of_origin.dddw.Lines=15")
	idw_putaway.Modify("country_of_origin.dddw.AllowEdit=no")
	
	idw_putaway.GetChild ( "country_of_origin", idwc_IM_Coo_Putaway )
	idwc_IM_Coo_Putaway.SetTransObject(Sqlca)
	
	//MikeA 3/20 - S43665 - F21861 - Google BRD - SIMS - Inbound Putaway Autofill II
	//Made AutiFill checkbox visibile/enabled for Pandora only
	
	tab_main.Tabpage_putaway.cbx_autofill.visible = true
	tab_main.Tabpage_putaway.cbx_autofill.enabled = true
//	idw_putaway.Object.c_autofill.Visible = false
	
	idw_putaway.Object.c_autofill.Protect = true
	

else
	
	tab_main.Tabpage_putaway.cbx_autofill.visible = false

end if

//if order type = 'I' and putaway saved check - done in wf_check_status_emc
If upper(gs_project) = 'BABYCARE' Then	
	tab_main.tabpage_putaway.cb_emc.enabled = False

	//pallet cb only visible for comcast moving cb_emc to pallets x cordinate
	tab_main.Tabpage_putaway.cb_emc.x = 2359
	tab_main.Tabpage_putaway.cb_emc.width = 297	
	//move componet checkbox over
	tab_main.Tabpage_putaway.cbx_show_comp.x = 2875	
	
Else
	tab_main.tabpage_putaway.cb_emc.visible = False
End If

// LTK 20111101	Store the initial background color expression.  Also create the scan expression based on the 
// initial expression and replacing white (editable), if it exists, with the scan color of green '13237437'.
is_lot_no_init_bg_color = idw_putaway.Describe("lot_no.Background.Color")
if Pos(is_lot_no_init_bg_color,'rgb(255,255,255)') > 0 then
	is_lot_no_scan_bg_color = Replace(is_lot_no_init_bg_color,Pos(is_lot_no_init_bg_color,'rgb(255,255,255)'),16,'13237437')
else
	is_lot_no_scan_bg_color = is_lot_no_init_bg_color
end if

is_po_no_init_bg_color = idw_putaway.Describe("po_no.Background.Color")
if Pos(is_po_no_init_bg_color,'rgb(255,255,255)') > 0 then
	is_po_no_scan_bg_color = Replace(is_po_no_init_bg_color,Pos(is_po_no_init_bg_color,'rgb(255,255,255)'),16,'13237437')
else
	is_po_no_scan_bg_color = is_po_no_init_bg_color
end if

is_po_no2_init_bg_color = idw_putaway.Describe("po_no2.Background.Color")
if Pos(is_po_no2_init_bg_color,'rgb(255,255,255)') > 0 then
	is_po_no2_scan_bg_color = Replace(is_po_no2_init_bg_color,Pos(is_po_no2_init_bg_color,'rgb(255,255,255)'),16,'13237437')
else
	is_po_no2_scan_bg_color = is_po_no2_init_bg_color
end if

is_container_init_bg_color = idw_putaway.Describe("container_id.Background.Color")
if Pos(is_container_init_bg_color,'rgb(255,255,255)') > 0 then
	is_container_scan_bg_color = Replace(is_container_init_bg_color,Pos(is_container_init_bg_color,'rgb(255,255,255)'),16,'13237437')
else
	is_container_scan_bg_color = is_container_init_bg_color
end if
// LTK 20111101	End of background color expression changes.


// 11//11 - PCONKL - added 2 custrom buttons on Main tab. - Make visible/invisible and label...
uf_config_custom_buttons()

if left(gs_project,4) = 'NIKE' then
	tab_main.tabpage_Search.dw_search.Modify("awb_bol_no.x=1840")
	tab_main.tabpage_Search.dw_search.Modify("ord_date.x=2250")	
	
	idw_Detail.Modify( "alloc_qty.Background.Color='16777215~tIf(alloc_qty > 0 ,if (req_qty <> alloc_qty,rgb(255,255,0),rgb(255,255,255)),rgb(255,255,0))'")
end if


// MEA - 11/09/2012
//In d_ro_search_con, replace the current User Field columns and titles with generic fields (e.g. search_fieldx, search_fieldx_t). The 8 fields can be grouped together on the right side. 
//The existing ancestor code will set the headers properly when new records are added to column_label with the new field names. We should not display a default heading if 
//nothing is set for the column label. 

integer liIdx, liFindRow

liFindRow = 0

for liIdx = 1 to 8

	liFindRow = g.ids_columnlabel.Find(" datawindows = 'd_ro_search_con' and column_name= 'search_field"+string(liIdx)+"' and ((Not IsNull(Column_Name_Value)) AND trim(Column_Name_Value) <> '')", liFindRow, g.ids_columnlabel.RowCount())

	if liFindRow > 0 then
		
		idw_condition.Modify( "search_field"+string(liIdx)+"_t.text='"+g.ids_columnlabel.GetItemString(liFindRow,"Column_Label" )+":'" )
		idw_condition.Modify( "search_field"+string(liIdx)+"_t.Color=0)")
		isGenericSearchColumnNameValue[liIdx] = g.ids_columnlabel.GetItemString(liFindRow,"Column_Name_Value" )
	else
		isGenericSearchColumnNameValue[liIdx] = "" 
	end if

next

if g.is_OTM_Enable_Ind = 'Y' AND g.is_OTM_Delivery_Order_Receive_Ind = 'Y' then
	in_otm = CREATE n_otm

	idw_main.object.otm_sent_ind.visible = true
	idw_main.object.otm_sent_ind_t.visible = true
	idw_search.object.otm_sent_ind.visible = true
	
else
	
	idw_search.object.otm_sent_ind.visible = false
	
end if

if gs_project = 'PANDORA' then
	idw_search.object.receive_master_batch_confirm_id.visible = true
	idw_search.object.receive_master_batch_confirm_id_t.visible = true
	//TAM 2016/08/04 added 2 fields 
	idw_search.object.receive_master_client_cust_po_nbr.visible = true
	idw_search.object.receive_master_client_cust_po_nbr_t.visible = true
	idw_search.object.receive_master_vendor_invoice_nbr.visible = true
	idw_search.object.receive_master_vendor_invoice_nbr_t.visible = true
	
end if

// 06/15 - PCONKL - MAke Mobile Status multi-select
tab_main.tabpage_search.uo_mobile_status.visible = true
tab_main.tabpage_search.uo_mobile_status.width = 725
tab_main.tabpage_search.uo_mobile_status.dw_search.width = 720
tab_main.tabpage_search.uo_mobile_status.height = 570
tab_main.tabpage_search.uo_mobile_status.dw_search.height = 565
tab_main.tabpage_search.uo_mobile_status.bringtotop = false

tab_main.tabpage_search.uo_mobile_status.uf_init("d_do_mobile_status_list","Receive_master.mobile_status_ind","mobile_status")

idw_condition.setItem(1,"mobile_status_ind", "<Select Multiple>")
idw_condition.Modify("mobile_status_ind.dddw.Limit=0")
idw_condition.Modify("mobile_status_ind.dddw.Name='None'")
idw_condition.Modify("mobile_status_ind.dddw.PercentWidth=0")

//idw_other = f_whitespace(idw_other, 88, 648)
idw_other = f_whitespace(idw_other, 92, 652)

	  
idw_main = f_whitespace(idw_main,840, 1480)
// Move command buttons if whitespace has been done
if gl_ScreenHeightChange > 0 then
	llCount = tab_main.tabpage_main.cb_confirm.y - gl_ScreenHeightChange
	tab_main.tabpage_main.cb_confirm.y = llCount
	tab_main.tabpage_main.cb_void.y = llCount
	tab_main.tabpage_main.cb_shipment.y = llCount
	tab_main.tabpage_main.cb_backorder.y = llCount
	tab_main.tabpage_main.cb_address.y = llCount
	tab_main.tabpage_main.cb_shipment.y = llCount
	tab_main.tabpage_main.cb_custom1.y = llCount
	tab_main.tabpage_main.cb_custom2.y = llCount
end if
end event

event ue_accept_text;idw_main.AcceptText()

end event

event resize;tab_main.Resize(workspacewidth(),workspaceHeight())

tab_main.tabpage_orderdetail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_orderdetail.dw_list_sku.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_search.dw_search.Resize(workspacewidth() - 80,workspaceHeight()-900)
tab_main.tabpage_notes.dw_notes.Resize(workspacewidth() - 80,workspaceHeight()-50)
tab_main.tabpage_rma_serial.dw_rma_serial.Resize(workspacewidth() - 80,workspaceHeight()-430)

If g.ibMobileenabled Then
	tab_main.tabpage_putaway.dw_putaway.Resize(workspacewidth() - 80,workspaceHeight()-420) //  06/15 - tweaked for mobile DW at top
Else
	tab_main.tabpage_putaway.dw_putaway.Resize(workspacewidth() - 80,workspaceHeight()-300)
End If
end event

event open;call super::open;i_nwarehouse = Create n_warehouse
is_title = This.title
ilHelpTopicID = 502 /*set help topic ID to open*/


//MStuart - backorder functionality - 083111
tab_main.tabpage_main.cb_backorder.visible = False

//MStuart - 090111
tab_main.tabpage_main.cb_address.visible = False

end event

event close;call super::close;Destroy n_warehouse   

// 11/01 - PConkl - If ASN window open, close
If isValid(w_proc_Asn_order) Then Close(w_proc_Asn_order)

if isValid( idsItemMaster ) then destroy ( idsItemMaster )
if isValid( idsRLScan ) then destroy ( idsRLScan )

f_method_trace_special( gs_project, this.ClassName() , 'Close Inbound order ' ,is_rono, '','',is_suppinvoiceno) //07-Oct-2015 :Madhu Added Method Trace call

//05/08 - PCONKL - Close Diebold Container ID window if open
If isValid(w_diebold_Container_Generate) Then Close(w_diebold_Container_Generate)

//TimA 06/18/13 part of the Pandora License Plate project #608
If gs_ActiveWindow = 'IN' then
	gs_ActiveWindow = ''
End if
end event

event ue_unlock;call super::ue_unlock;
IF gs_project = 'PANDORA' THEN
	//TimA 06/10/13 Added this method trace to see who is pressing F10
	f_method_trace_special( gs_project, this.ClassName() , 'F10 Unlock pressed for Inbound order: ' ,is_rono, '','',is_suppinvoiceno) 		

	wf_lock(false)

	// TimA 10/10/11	Pandora issue #240 Unlock only upon an F10.  
	idw_detail.Object.user_line_item_no.Protect = FALSE
	idw_detail.Modify("user_line_item_no.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")
	idw_detail.Object.line_item_no.Protect = FALSE
	idw_detail.Modify("line_item_no.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")	

	// LTK 20111121	Pandora #253 Unlock "From Location" field (UF6) upon an F10
	//TimA 06/12/15 Fixed for F10 issue on new Named fields.
	idw_other.Object.user_field6.Protect = false
	idw_other.Object.user_field6.Background.Color = RGB(255, 255, 255)
	//idw_main.Object.user_field6.Protect = false
	//idw_main.Object.user_field6.Background.Color = RGB(255, 255, 255)

		/* 06/16/2014 - GailM - Issue 875 - Protect fields when inbound order is received electronically but allow F10 */
		/* 06/20/2014 - GailM - removed test for create_user */
		If (  idw_main.object.edi_batch_seq_no[1] <> 0  ) Then
			idw_detail.object.alternate_sku.Protect = FALSE
			idw_detail.object.req_qty.Protect = FALSE
			idw_detail.object.cost.Protect = FALSE
			idw_detail.object.user_field1.Protect = FALSE
			
			//Pandora issue #889
			idw_detail.object.Shipment_Distribution_No.protect = FALSE
			idw_detail.object.Need_By_Date.protect = FALSE
			idw_Putaway.object.Shipment_Distribution_No.protect = FALSE
			idw_Putaway.object.Need_By_Date.protect = FALSE

		End If

	// LTK 20150212  Pandora #984  Lock detail datawindow for warehouse transfers
	if idw_Main.GetItemString(1,'Ord_type') = 'Z' then
		tab_main.tabpage_orderDetail.dw_detail.Object.datawindow.ReadOnly = 'NO'
	end if

	ibPressF10Unlock =TRUE 	//31-Aug-2015 :Madhu- Disable Prevent Manul Scanning
	gbPressF10Unlock =TRUE  //17-Sep-2015 :Madhu-  Disable Prevent Manul Scanning
	
end if

// 06/15 - PCONKL - add ability to voerride mobile status fields if necessary
//If idw_main.GetItemString(idw_main.rowcount(), 'mobile_enabled_ind') = 'Y' Then
	
	idw_putaway_mobile.Object.Datawindow.ReadOnly = False
	idw_Putaway_mobile.Object.mobile_Enabled_Ind.Protect = 0
	
	idw_Putaway_mobile.Modify("mobile_status_ind.Protect = 0")
	idw_Putaway_mobile.SetTabOrder("mobile_status_ind", 20)
	idw_Putaway_mobile.Modify("mobile_status_Ind.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")
	
	idw_Putaway.Object.Datawindow.ReadOnly = False
	idw_Putaway.Modify("mobile_status_ind.Protect = 0")
	idw_Putaway.Modify("Quantity.Protect = 0")
	idw_Putaway.SetTabOrder("mobile_status_ind", 20)
	idw_Putaway.Modify("mobile_status_ind.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")
		
//End If /*Mobile enabled*/
end event

event timer;call super::timer;
Timer(0)
tab_main.tabpage_orderdetail.sle_verify.backcolor = rgb(255,255,255)
tab_main.tabpage_orderdetail.sle_verify.Text = ''


//17-Aug-2015 :Madhu- Added code to prevent Manual Scanning - START
ibkeytype=FALSE
ibmouseclick =FALSE

MessageBox("Manual Entry","Doesn't Accept manual Entry")
tab_main.tabpage_putaway.dw_putaway.setitem(idw_putaway.getrow(), 'serial_no', '-')
//17-Aug-2015 :Madhu- Added code to prevent Manual Scanning - END
end event

event activate;call super::activate;//TimA 06/18/13 part of the Pandora License Plate project #608
gs_ActiveWindow = 'IN'

//TimA 08/13/15 Global gs_System_No for logging database errors if they happen
gs_System_No = is_rono
end event

event deactivate;call super::deactivate;//TimA 08/13/15 Global system number for capturing database errors messages
gs_System_No = ''
end event

type tab_main from w_std_master_detail`tab_main within w_ro
integer x = 23
integer y = 0
integer width = 3895
integer height = 1980
integer textsize = -9
tabpage_other_info tabpage_other_info
tabpage_orderdetail tabpage_orderdetail
tabpage_putaway tabpage_putaway
tabpage_notes tabpage_notes
tabpage_rma_serial tabpage_rma_serial
end type

on tab_main.create
this.tabpage_other_info=create tabpage_other_info
this.tabpage_orderdetail=create tabpage_orderdetail
this.tabpage_putaway=create tabpage_putaway
this.tabpage_notes=create tabpage_notes
this.tabpage_rma_serial=create tabpage_rma_serial
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_other_info,&
this.tabpage_orderdetail,&
this.tabpage_putaway,&
this.tabpage_notes,&
this.tabpage_rma_serial}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_other_info)
destroy(this.tabpage_orderdetail)
destroy(this.tabpage_putaway)
destroy(this.tabpage_notes)
destroy(this.tabpage_rma_serial)
end on

event tab_main::selectionchanged;// 10/00 PCONKL - set sort if Search Tab

// 04/01 PCONKL - Set help keyword
		
IlHelpTopicID = 0
			
Choose Case NewIndex
	Case 1 /*order Info*/
		IlHelpTopicID = 546
		wf_check_menu(False,'sort')
		wf_check_menu(False,'find')
		idw_current = idw_main
	Case 2 /*Other Info*/
		//IlHelpTopicID = 547
		wf_check_menu(TRUE,'sort') 
		wf_check_menu(TRUE,'find')		
		idw_current = idw_other
		// Begin Dinesh S52817- 01/22/21 - Google - SIMS - SAP Conversion - GUI 
			If gs_project = 'PANDORA' then
				idw_other.object.User_Field13.Protect = TRUE
				idw_other.object.User_Field15.Protect = TRUE
			end if
		// End Dinesh S51817 - 01/22/21 - Google - SIMS - SAP Conversion - GUI
		
	Case 3 /*Order Detail*/
		IlHelpTopicID = 547
		wf_check_menu(TRUE,'sort') 
		wf_check_menu(TRUE,'find')		
		idw_current = idw_detail
	Case 4 /*Putaway*/
		IlHelpTopicID = 548
		wf_check_menu(True,'sort')
		wf_check_menu(True,'find')		
		idw_current = idw_putaway
		
		//MStuart - 021511 - check cbx_show_comp and disable for all projects
		tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
		tab_main.Tabpage_putaway.cbx_show_comp.checked = True
		tab_main.Tabpage_putaway.cbx_show_comp.triggerevent(clicked!)

		//***********************************************************
		//MStuart - babycare - emc functionality - 081211
		//***********************************************************
		
		//cb_emc enabled or visible set in postopen event
		If upper(gs_project) = 'BABYCARE' and &
						idw_putaway.RowCount() > 0 Then			
			wf_check_status_emc()			
		End If
					
		//*************************************************
		//MStuart end of *BabyCare*
		//*************************************************
		
	Case 5 /*Notes*/
		//IlHelpTopicID = 548
		wf_check_menu(True,'sort') 
		wf_check_menu(False,'find')		
		idw_current = idw_notes
	Case 6 /*RMA SERIAL*/
		
		idw_current = idw_rma_serial
		wf_check_menu(True,'sort')
		wf_check_menu(True,'find')		

		tab_main.tabpage_rma_serial.rb_auto.Checked = True
		tab_main.tabpage_rma_serial.rb_auto.triggerEvent('clicked')
				
	Case 7 /*search Tab*/
		IlHelpTopicID = 518
		idw_current = idw_search
	   wf_check_menu(TRUE,'sort')
		wf_check_menu(False,'find')		
End Choose



 
		
end event

event tab_main::clicked;if idw_list_sku.visible then  //gap 06-03 reset sku list datawindow if left open
	tab_main.tabpage_orderdetail.cb_list_sku.text = "&List SKU" 
	// idw_list_sku.reset()
	idw_list_sku.visible = false 
	idw_detail.visible = true
	tab_main.tabpage_orderdetail.cb_delete.enabled = true
	tab_main.tabpage_orderdetail.cb_insert.enabled = true
end if


end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 108
integer width = 3858
integer height = 1856
string text = " Order Information "
cb_custom2 cb_custom2
cb_custom1 cb_custom1
cb_backorder cb_backorder
cb_address cb_address
cb_shipment cb_shipment
cb_confirm cb_confirm
cb_void cb_void
sle_orderno sle_orderno
sle_order2 sle_order2
cb_open_do cb_open_do
dw_main dw_main
st_ro_order_no st_ro_order_no
end type

on tabpage_main.create
this.cb_custom2=create cb_custom2
this.cb_custom1=create cb_custom1
this.cb_backorder=create cb_backorder
this.cb_address=create cb_address
this.cb_shipment=create cb_shipment
this.cb_confirm=create cb_confirm
this.cb_void=create cb_void
this.sle_orderno=create sle_orderno
this.sle_order2=create sle_order2
this.cb_open_do=create cb_open_do
this.dw_main=create dw_main
this.st_ro_order_no=create st_ro_order_no
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_custom2
this.Control[iCurrent+2]=this.cb_custom1
this.Control[iCurrent+3]=this.cb_backorder
this.Control[iCurrent+4]=this.cb_address
this.Control[iCurrent+5]=this.cb_shipment
this.Control[iCurrent+6]=this.cb_confirm
this.Control[iCurrent+7]=this.cb_void
this.Control[iCurrent+8]=this.sle_orderno
this.Control[iCurrent+9]=this.sle_order2
this.Control[iCurrent+10]=this.cb_open_do
this.Control[iCurrent+11]=this.dw_main
this.Control[iCurrent+12]=this.st_ro_order_no
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_custom2)
destroy(this.cb_custom1)
destroy(this.cb_backorder)
destroy(this.cb_address)
destroy(this.cb_shipment)
destroy(this.cb_confirm)
destroy(this.cb_void)
destroy(this.sle_orderno)
destroy(this.sle_order2)
destroy(this.cb_open_do)
destroy(this.dw_main)
destroy(this.st_ro_order_no)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 108
integer width = 3858
integer height = 1856
cb_ro_search cb_ro_search
cb_ro_clear cb_ro_clear
dw_search dw_search
uo_mobile_status uo_mobile_status
dw_condition dw_condition
end type

on tabpage_search.create
this.cb_ro_search=create cb_ro_search
this.cb_ro_clear=create cb_ro_clear
this.dw_search=create dw_search
this.uo_mobile_status=create uo_mobile_status
this.dw_condition=create dw_condition
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ro_search
this.Control[iCurrent+2]=this.cb_ro_clear
this.Control[iCurrent+3]=this.dw_search
this.Control[iCurrent+4]=this.uo_mobile_status
this.Control[iCurrent+5]=this.dw_condition
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_ro_search)
destroy(this.cb_ro_clear)
destroy(this.dw_search)
destroy(this.uo_mobile_status)
destroy(this.dw_condition)
end on

type cb_custom2 from commandbutton within tabpage_main
boolean visible = false
integer x = 1330
integer y = 1728
integer width = 416
integer height = 96
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Custom 2"
end type

event clicked;
Choose Case Upper(gs_project)
		
	Case 'NIKE-SG', 'NIKE-MY'
		
		uf_print_nike_tally_sheet()

// SARUN2014MAY12 : WS-PR Inbound Export
	Case 'WS-PR'
		
		WF_EXPORT()
				
		
End Choose
end event

type cb_custom1 from commandbutton within tabpage_main
boolean visible = false
integer x = 731
integer y = 1728
integer width = 416
integer height = 96
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Custom 1"
end type

event clicked;Str_Parms	 lstrparms

Choose Case Upper(gs_project)
		
	Case 'NIKE-SG', 'NIKE-MY'
		
		uf_print_nike_receiving_rpt()
		
	Case 'STBTH'
		
			lstrparms.String_Arg[1] = ''
			OpenSheetWithParm(w_starbucks_th_po,lstrparms,w_main, gi_menu_pos, Original!)
		
	Case Else
		
		If left(Upper(gs_project),2) = 'WS' then
		
			wf_export_ws_tradenet()
			
		End If
		
End Choose
end event

type cb_backorder from commandbutton within tabpage_main
integer x = 2341
integer y = 1616
integer width = 567
integer height = 96
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create &BackOrder"
end type

event clicked;//MStuart - 072011 - create BackOrder functionality

string ls_ord_num, ls_status = 'N' , ls_order_type = 'B'
int li_cnt

ls_ord_num = trim(idw_main.GetItemString( 1, 'supp_invoice_no' ))

 Select COUNT(*) 
   InTo :li_cnt
  From Receive_Master
Where Project_ID             = :gs_project
    and supp_invoice_no    = :ls_ord_num
    and upper(Ord_Type)   = :ls_order_type
    and upper(Ord_Status) = :ls_status ;

If SQLCA.SQLCode = -1 Then
	MessageBox("BackOrder Count SQL ERROR", SQLCA.SQLErrText)
	Return
End If
	 	 
//if ord. nbr. found with status of New and type Backorder let user know backorder already exists
If li_cnt > 0 Then  
			If MessageBox( is_title, "BackOrder(s) already exists!" &
								+ "Are you sure you want to Create BackOrder?", Question!, YesNo!, 1 ) = 1 Then
										iw_window.triggerEvent( "ue_backorder" )				
			End If
	
ElseIf MessageBox( is_title, "Create BackOrder?", Question!, YesNo!, 1 ) = 1 Then
				iw_window.triggerEvent( "ue_backorder" )		
End If	
	
	

end event

type cb_address from commandbutton within tabpage_main
boolean visible = false
integer x = 2798
integer y = 1596
integer width = 343
integer height = 96
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Address..."
end type

event clicked;str_parms	lstrparms

lstrparms.String_arg[1] = idw_Main.GetITemString(1,'ro_no')

//Read only if order not open
If idw_Main.GetITEmstring(1,'ord_status') = 'N' or idw_Main.GetITEmstring(1,'ord_status') = 'P' Then
	lstrParms.String_arg[2] = 'Y'
Else
	lstrParms.String_arg[2] = 'N'
End If

OpenWithParm(w_ro_return_address, lstrparms)
end event

type cb_shipment from commandbutton within tabpage_main
integer x = 731
integer y = 1616
integer width = 416
integer height = 96
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Shipments..."
end type

event clicked;
iw_window.TriggerEvent("ue_process_Shipments")
//messagebox ("SIMS", "'Shipments' functionality not yet enabled.")

end event

event constructor;
//Outbound Track & Trace (Shipments)
If g.ibTNTEnabled Then
	g.of_check_label_button(this)
	This.Visible = True
Else
	This.Visible = False
End If
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 1330
integer y = 1616
integer width = 334
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = " &Confirm"
end type

event clicked;//MEA - 04/12 Added to check credentials
string lsWarehouse
if f_check_access( is_process, "C")  = 0 Then Return


iw_window.triggerEvent("ue_confirm")

// Begin - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
lsWarehouse = idw_main.GetItemString(1,"wh_code")
select Inbound_ord_Ind into :is_Inbound_ord_Ind from Warehouse where wh_code=:lsWarehouse using sqlca;
	IF upper(gs_project) ='PANDORA' and idw_putaway.rowcount( ) > 0 and is_Inbound_ord_Ind='Y'THEN
		If MessageBox(is_title, "You will need to print out new part labels for this inbound order ", Question!, YesNo!, 1) = 1 Then
			ib_inbound = True
		else 
			ib_inbound = False
		End if
	End if
	
If ib_inbound= True and  upper(gs_project) = 'PANDORA' then
	OpenSheetWithParm(w_pandora_part_label_print, "  ", w_main,gi_menu_pos, Original!)
else
	return 0
end if
// End - 03/01/2021 - Dinesh - S54346 - Google - SIMS -  Footprints Inbound Warning Enhancement
	


//TimA 04/06/11
//If a Rollback has occured re-retrieve the order
IF gs_project = "PANDORA" and ib_ConfirmFail = True THEN
	isle_code.TriggerEvent(Modified!)
end if

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_void from commandbutton within tabpage_main
integer x = 1847
integer y = 1616
integer width = 306
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Void"
end type

event clicked;

//MEA - 04/12 Added to check credentials

if f_check_access( is_process, "C")  = 0 Then Return


String	lsRoNo,	&
			lsOrdStat

DateTime	ldtToday 

//03/03 - PCONKL - Make sure the order was not confirmed by another user 
lsRONO = idw_main.GetITemString(1,'Ro_no')
ldtToday = f_getLocalWorldTime( idw_main.getitemstring(1,'wh_code') ) 

Select ord_status Into :lsOrdStat
From Receive_MAster
Where Project_ID = :gs_Project and ro_no = :lsRONo;

If lsordStat = 'C' Then /*already Confrimed, can't void*/
	Messagebox(is_Title,'This Order was already confirmed by another user. It can not be Voided!',StopSign!)
	ib_changed = False
	isle_code.TriggerEvent('Modified')
	Return
End If

//GailM 8/29/2019 - S36463/F17577 Inbound Void Orders
If lsordStat <> 'N' Then
	Messagebox(is_Title,"This Order must be in 'New' status to void.~r~nPlease delete Put Away List and try again.",StopSign!)
	ib_changed = False
	isle_code.TriggerEvent('Modified')
	Return
End If

if messagebox(is_title,'Are you sure you want to void this order?',Question!,YesNo!,2) = 2 then
	return
End if

idw_main.setitem(1,'ord_status','V')

//OTM - MEA - 04/13

//$$HEX2$$22200900$$ENDHEX$$In ue_Void:
//o	Instantiate N_OTM
//o	Add a call at the end of existing script to the generic Inbound Order Processor created above in N_OTM if The 2 OTM indicators are set to Y (Enable_OTM_Ind and OTM_Inbound_Order_Send_Ind).
//$$HEX2$$a7f00900$$ENDHEX$$We need to replicate the function $$HEX1$$1c20$$ENDHEX$$getdeltedskus$$HEX2$$1d202000$$ENDHEX$$from W_DO to pass the list of SKU$$HEX1$$1920$$ENDHEX$$s
//

//OTM_Inbound_Order_Send_Ind
//Copied TimA from w_do

If g.is_OTM_Enable_Ind = 'Y' AND g.isOTMSendInboundOrder = 'Y' Then
	//Don't check NOT OTM orders
//	If idw_main.getitemstring(1, 'OTM_Status') <> 'N' then
		//MikeA 04/13 OTM Project.  We need to capture the deleted Do_no for the OTM call in ue_save

		//Call Function to get a list of Sku's
		getdeletedskus()

		isFlagDeleteOTM = 'Y'
//	Else
//		isFlagDeleteOTM = 'N'
//	End if
End if




If iw_window.Trigger Event ue_save() = 0 Then
	
	//13-MAY-2019 :Madhu S31437 -F14849 - Philips Customer Return Finish Cancellation
	Execute Immediate "Begin Transaction" using SQLCA;
	
	Insert Into Batch_Transaction (project_Id, Trans_Type, Trans_Order_Id, Trans_Status, Trans_Create_Date, Trans_Parm)
	Values(:gs_Project, 'VR', :lsRONO,'N', :ldtToday, '');
	
	Execute Immediate "COMMIT" using SQLCA;

	MessageBox(is_title, "Record voided!")
Else
	MessageBox(is_title, "Record void failed!")
End If


end event

event constructor;
g.of_check_label_button(this)
end event

type sle_orderno from singlelineedit within tabpage_main
integer x = 507
integer y = 20
integer width = 992
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 50
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_bol,	lsOrder, lsModify, lsRC, ls_wh_code, ls_ordertype, ls_OrderNbr, ls_WghDim, ls_missing_dims
String ls_wh_type // TAM W&S
Long	llCount, ll_rownum, ll_numrows, ll_edibatchseqno
DatawindowChild ldwc
boolean lb_multi_ord_search
String ls_User_Field13,ls_User_Field15
//Nxjain Trim the Bol value and udpate the where clause with like function. -20160211

//Set bol = current text
ls_bol = trim(This.Text)

ibDejaVu = False //dts 10/16/14
ibDejaVu_Asked = False //dts 10/16/14
ibPressF10Unlock =FALSE //17-Sep-2015 :Madhu- Added for PressKeyVsSNScan
gbPressF10Unlock =FALSE  //17-Sep-2015 :Madhu- Added for PressKeyVsSNScan

//TimA 10/22/15 Used in Selection Change to see if the from warehouse is WMS
ibFromWMS = FALSE

//If the Order # is null then select it from the db and continue
IF IsNull(is_rono) or is_rono = "" THEN 
	
	//18-JUNE-2018 :Madhu S20312 -Mobile Inbound Putaway
	If len(ls_bol) =0 then
		MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
		This.SetFocus()
		This.SelectText(3,Len(ls_bol))
		RETURN
	end if 
	//Dinesh Begin - 02/12/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search 
IF  len(ls_bol)  > 50  Then
	MessageBox('Order Out of limit', "Multi order or Multi-Leg Order is out of limit please enter not more than 5 Orders!", Exclamation!)
	This.SetFocus()		
	This.SelectText(1,Len(ls_bol))
	RETURN
end IF
//Dinesh End - 02/12/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search 
	
	is_suppinvoiceno = ls_bol
	
	// 05/00 PCONKL - We can have duplicate Supplier invoice numbers
	// We will get bad return code if we try to 'select into' and there is > 1 row.
	// Chnaged logic to do a count first. If 0 then not found, if > 1 then make user select from search screen, if 1 then retrieve
  long ll_find,flag
//Dinesh - 02/11/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search 
select count(*) into :ll_find from Receive_Master where Supp_Invoice_No= :ls_bol and project_id=:gs_project;
  //Dhirendra-11 Jan 2021 PANDORA S52705- Added if condition for multiple search 
  IF   Pos(ls_bol, ",") > 0  and Upper(gs_project) ="PANDORA" THEN 
	lb_multi_ord_search =true
// Begin-  Dinesh -01/22/2021 - S52817 - Google - SIMS - SAP Conversion - GUI
  Elseif not isnull(ls_bol) and ll_find=1 and  Upper(gs_project) ="PANDORA" THEN 
	Select User_Field13,User_Field15 into :ls_User_Field13,:ls_User_Field15 from Receive_Master  with(nolock)
	where Supp_Invoice_No=:ls_bol and project_id = :gs_project;
	
		if (not ISNULL(ls_User_Field13) or ls_User_Field13<> '') or (not ISNULL(ls_User_Field15) or ls_User_Field15<>'') then
			lb_multi_ord_search =True
		else
			Select Count(*) into :llCount
			FROM Receive_Master with(nolock)
			WHERE Supp_Invoice_No like '%'+:ls_bol+'%'  and project_id = :gs_project;
	     end if
	// End-  Dinesh -01/22/2021 - S52817 - Google - SIMS - SAP Conversion - GUI
  else
	
	Select Count(*) into :llCount
	FROM Receive_Master with(nolock)
	WHERE Supp_Invoice_No like '%'+:ls_bol+'%'  and project_id = :gs_project;
 end if 
	
	If llCount =0 then  //nxjain 2014-02-01 Secar by RO_no 		
		Select Count(*) , ro_no  Into :llCount , :is_rono
		FROM Receive_Master with (nolock)
		WHERE ro_no like '%'+:ls_bol+'%' and project_id = :gs_project
		Group by ro_no ;
	
	end if 
		
	If llCount = 0 and gs_Project = "PANDORA"  then  //TAM 2016/-09-27 For Pandora Also search by Client_cust_po_nbr(Order_Nbr) 
		
		Select Count(*) , ro_no  Into :llCount , :is_rono
		FROM Receive_Master with (nolock)
		WHERE client_cust_po_nbr like '%'+:ls_bol+'%' and project_id = :gs_project
		Group by ro_no ;
	
	end if 
			
	If llCount = 0  and lb_multi_ord_search =false    THEN //Dhirendra-11 Jan 2021 PANDORA S52705- Added lb_multi_ord_search variable in if condition for multiple search
		MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
		This.SetFocus()
		This.SelectText(1,Len(ls_bol))
		RETURN
	ElseIf llCount > 1 and  lb_multi_ord_search = false  Then //Dhirendra-11 Jan 2021 PANDORA S52705- Added lb_multi_ord_search variable in if condition for multiple search
		Messagebox(is_title,"Multiple records found for this Order nbr, please select from search tab!")
		
		// 1/26/2011; David C; Switch to the Search Tab and retrieve the list of duplicate orders that were found
		//TimA 06/17/15 clear the provious search criteria if there is any
		tab_main.tabpage_search.cb_ro_clear.Event clicked ( )
		ls_OrderNbr = tab_main.tabpage_main.sle_orderno.Text
		tab_main.SelectTab ( 7 )
		tab_main.tabpage_search.dw_condition.Object.invoice_no[1] = trim(ls_OrderNbr)
		tab_main.tabpage_search.cb_ro_search.Event clicked ( )
		
		Return
		//Dhirendra-11 Jan 2021 PANDORA S52705- Added elseif condition for multiple search to redirect on search tab
	elseif  llCount = 0  and  lb_multi_ord_search = true  Then
		tab_main.tabpage_search.cb_ro_clear.Event clicked ( )
		ls_OrderNbr = tab_main.tabpage_main.sle_orderno.Text
		tab_main.SelectTab ( 7 )
		tab_main.tabpage_search.dw_condition.Object.invoice_no[1] = trim(ls_OrderNbr)
		tab_main.tabpage_search.cb_ro_search.Event clicked ( )
		Return
	Elseif IsNull(is_rono) or is_rono = "" THEN 
		SELECT RO_no
		INTO :is_rono
		FROM Receive_Master with (nolock)
		WHERE Supp_Invoice_No like '%'+:ls_bol+'%'  and project_id = :gs_project;
	
		IF SQLCA.sqlcode <> 0 THEN
			MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
			This.SetFocus()
			This.SelectText(1,Len(ls_bol))
			RETURN
		End If
	END IF
END IF

IF is_rono = "" THEN RETURN

// pvh - 09.14.2006 BlueCoat
setUpdateEdi( false )

// pvh - 01/18/07 - MARL
// reset the adjustment datastore to clear out previous orders data.
idsMarlAdjustment.reset()
//
long ll_result = 0
//TimA 08/13/15 added gs_system_No and method trace call
gs_System_No = is_rono
ll_result = idw_main.Retrieve(is_rono)
if  Upper(gs_project) ="PANDORA" THEN 
		f_crossdock() // Dinesh - 28/06/2021 - S52817- Google - SIMS QA - Last leg of a multileg is flagged as crossdock
end if
f_method_trace_special( gs_project, this.ClassName() , 'Opened Inbound order ' ,is_rono, '','',is_suppinvoiceno ) 
IF idw_main.RowCount() > 0 Then
	is_suppinvoiceno = ls_bol
	
	
	// Retrieve the datawindow using the rono, edibahseqno and order type (final two used in 'protect' for req_qty).
	idw_detail.Retrieve(is_rono)

	//////////////////////////////////////////// KRZ populate detail dw with description //////////////////////////////////////////////////////////////
	// Get the number of detail rows,
	ll_numrows = idw_detail.rowcount()
	
	// TAM - 2016/12 - For Pandora we need to check if any details require DIMS entry and display a warning message if they do
	ls_WghDim = 'N'
	ls_missing_dims = 'N'
	If gs_project = 'PANDORA'  then
		ls_wh_code = idw_main.GetItemString(1, "wh_code")
		Select User_Updateable_Ind INTO :ls_WghDim FROM lookup_table with (NoLock) 
		Where Project_ID = :gs_project AND Code_Type = 'CUBE_SCAN' and Code_Id = :ls_wh_code  USING SQLCA;
	End if
	
	// Loop through the rows,
	For ll_rownum = 1 to ll_numrows
		
		// Set the description.
		f_setdetaildescription(ll_rownum)

		// TAM - 2016/12 - For Pandora we need to check if any details require DIMS entry and display a warning message if they do
		If ls_WghDim = 'Y' and ls_missing_dims <> 'Y'   then //  - Wgt/Dims capture is turned on for this Warehouse 
			if f_check_dims(ll_rownum) = false then
				MessageBox("GPN Weights/Dims missing", "Dims/wts on the detail screen have not been validated by the Cubiscan. Invalid GPNS  will be displayed during Generate Putaway: ~r~r")
				ls_missing_dims = 'Y'
			end if
		End if
	Next
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	idw_putaway.Retrieve(is_rono, gs_project)
	IF g.ib_receive_putaway_serial_rollup_ind Then idw_rma_serial.Retrieve(is_rono, gs_project) //8-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
	idw_notes.Retrieve(is_rono)
	
	tab_main.tabpage_orderdetail.Enabled = True
	tab_main.tabpage_putaway.Enabled = True
	
	wf_set_rma_serial_tab_status() //8-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
	
	//BCR 09-FEB-2012: Any project that has this kind of project/warehouse level sort on Putaway (like Bluecoat does) may run into run-time problems if there are Components attached to Parents. 
	//                           In Bluecoat's case, Child Component shows up on row 1, followed by Parent on row 2. When you select Location for Parent, it doesn't copy down into Child.  
	//                           So, per Pete Conklin, trigger this event ONLY if there are no Child Components.
	If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) = 0 Then
		iw_window.TriggerEvent('ue_sort_Putaway')
	END IF

	If idw_notes.RowCount() > 0 Then
		tab_main.tabpage_notes.Enabled = True
	Else
		tab_main.tabpage_notes.Enabled = False
	End If

	wf_checkstatus()
	
	If idw_main.GetItemString(1, "ord_status") <> "C" and &
		idw_main.GetItemString(1, "ord_status") <> "V" Then
		iw_window.TriggerEvent("ue_refresh")
	End If

//	// 11/01 - PCONKL - IF ASN records exist for this order, show the button on the Putaway tab. Otherwise make it invisible
//	lsOrder = idw_main.GEtItemString(1,'supp_invoice_no')
//	
//	Select Count(*) into :llCount
//	FRom asn_header, asn_item
//	Where asn_header.ASn_no = asn_item.ASn_no and
//			asn_header.Project_id = :gs_Project and
//			asn_item.Order_no = :lsOrder;
//			
//	If llCount > 0 Then
//		tab_main.tabpage_putaway.cb_asn.Visible = True
//	Else
//		tab_main.tabpage_putaway.cb_asn.Visible = FAlse
//	End If
	
	//MAS 021511 commented - check cbx_show_comp and disable for all projects 
	//tab_main.Tabpage_putaway.cbx_show_comp.Checked = False
	
	//If any of Putaway records are components, enable show components checkbox
	If idw_putaway.RowCOunt() > 0 Then
		//MAS commented 021511- check cbx_show_comp and disable for all projects
		//If idw_putaway.Find("component_ind = 'Y'",1,idw_putaway.RowCount()) > 0 Then
		//MAS 021511 - commented, check cbx_show_comp and disable for all projects
			//tab_main.Tabpage_putaway.cbx_show_comp.Enabled = True
			 tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
			 tab_main.Tabpage_putaway.cbx_show_comp.Checked = True
			 wf_set_comp_filter('SET') /*default to not showing component children*/
		//Else
		//	tab_main.Tabpage_putaway.cbx_show_comp.Enabled = False
		//End If
	End If

	// pvh - 03.13.06 MARL
	If gs_Project = "3COM_NASH" and idw_main.GetItemString(1, "ord_type") = 'X' then
		if idw_putaway.rowcount() > 0 then 
			doResetArrays()  // clear the list out first			
			setRLSkuList(  )
			getAdjustments()
		end if
	end if
	
	IF gs_Project = "PANDORA" then
		
		ls_wh_code = idw_main.GetItemString(1, "wh_code")
		if Not IsNull(ls_wh_code) AND trim(ls_wh_code) <> '' then
			idw_other.GetChild("user_field2", ldwc)
			//idw_main.SetTransObject(SQLCA)
			ldwc.Retrieve(upper(gs_project), ls_wh_code)
		end if

		//TimA 10/22/15 Look to see if the From Warehouse is from WMS
		//GailM 7/6/2020 DE16627 Eliminate repeated retrieval from customer master - Moved from putaway tab selectionchanged
		String lsCustType, lsCustCode
		lsCustCode = idw_Other.GetItemString(1,'User_Field6' )
		If lsCustCode <> '' Then
			SELECT CU.Customer_Type Into :lsCustType FROM Customer CU WITH (NOLOCK) 
			WHERE Cu.Project_Id = :gs_project
			AND CU.Cust_Code = :lsCustCode
			Using SQLCA;
			If lsCustType = 'WMS' then
				ibFromWMS = True
			Else
				ibFromWMS = False
			End if
		End if
			
	END IF
	
	//30-Jan-2019 :Madhu S28685 PHILIPSCLS BlueHeart Minimum Shelf Life Inbound Validation
	//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
	//IF upper(gs_project) ='PHILIPSCLS' and idw_putaway.rowcount( ) > 0 THEN wf_min_shelf_life_Inbound_validation(FALSE)	
	IF (upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA') and idw_putaway.rowcount( ) > 0 THEN wf_min_shelf_life_Inbound_validation(FALSE)	
	ib_changed = False
	ibConfirmrequested = False
	idw_main.Show()
	idw_main.SetFocus()
	This.Visible = FALSE
	
	// 05/00 pconkl - noo need to show this field once a record has been retrieved
	//sle_order2.Visible = TRUE
	sle_order2.text = This.text
	is_bolno = This.Text
	
	If Pos(iw_window.Title,'[') = 0 Then
		iw_window.Title = iw_window.Title + " [" + idw_Main.GetITemString(1,'Supp_invoice_no') + "]"
	End If
	
	//03/06 - PCONKL - If this order type supports multiple suppliers, show supplier on Detail and Putaway tabs
	wf_set_supplier_visibility()
	
ELSE
	MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
	This.SetFocus()
	This.SelectText(1,Len(ls_bol))
END IF

// TAM W&S 2010/12  We are processing bonded warehouses(Wh_TYPE "B" differently then non_bonded Wh_Type "N".  	
		IF Left(gs_Project,3) = "WS-" then
			ls_wh_code = idw_main.GetItemString(1, "wh_code")
		
			if Not IsNull(ls_wh_code) AND trim(ls_wh_code) <> '' then
				Select wh_type into :ls_wh_type
				From Warehouse with (nolock)
				Where Wh_code = :ls_wh_code  ;
				If ls_wh_type = 'B'  Then
					is_bonded = 'Y'
				Else
					idw_putaway.SetTabOrder("lot_no", 0)
					is_bonded = 'N'
				End If
			End If 
		End If

// 03/03 - PConkl - Make sure that Confirm and Void buttons are not selected when user hits enter (they will be if the last order voideded or confirmed)
tab_main.tabpage_main.Cb_Confirm.Default = False
tab_main.tabpage_main.Cb_Void.Default = False
idw_main.SetFocus()

//05/14 - PCONKL - reset warning message indicators for Storage Rule field changes on Putaway
ibSRNotifiedLot = False
ibSRNotifiedPO = False
ibSRNotifiedPO2 = False
ibSRNotifiedInvType = False
ibSRNotifiedExpDT = False

if tab_main.tabpage_main.cb_open_do.visible then tab_main.tabpage_main.cb_open_do.bringtotop = true //SARUN2016FEB10:RO_Open
end event

type sle_order2 from singlelineedit within tabpage_main
boolean visible = false
integer x = 507
integer y = 28
integer width = 855
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12639424
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_open_do from commandbutton within tabpage_main
boolean visible = false
integer x = 142
integer y = 28
integer width = 370
integer height = 76
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "     Order No:"
end type

event clicked;Str_parms	lStrparms_1
	If f_check_access ("W_DOR","") = 1 Then
		lstrparms_1.String_arg[1] = "W_ROD"
		lstrparms_1.String_arg[2] =  idw_main.GetItemString(1, 'supp_Invoice_No' )
		setredraw(false)
		if isvalid(w_do) then
			MessageBox(is_title,"Delivery Order Window is Already Open, First Close the existing window and then DoubleClick")
		else	
			OpenSheetwithparm(w_do,lStrparms_1, w_main, gi_menu_pos, Original!)
		end if		
		
		

		setredraw(true)
	End If

end event

type dw_main from u_dw_ancestor within tabpage_main
event ue_post_check_status ( )
integer x = 37
integer y = 28
integer width = 3803
integer height = 1572
integer taborder = 20
string dataobject = "d_ro_master"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event ue_post_check_status;
// 06/00 PCONKL - Posted from Itemchange to update protected fields if status changed
wf_checkstatus()
end event

event itemchanged;String ls_supp_name, lsRONO, lsOrder, ls_Null, ls_sub_inventory_type, ls_ordertype, ls_transtype
integer li_scan, liCount, li_count
string ls_msg, lsSupplierInd, ls_wh_code,  ls_CustCode, ls_wh_type
long ll_owner_id, li_idx
datawindowchild ldwc
boolean lb_hasalpha
string ls_ord_Desc, ls_unavailable		//16-Jun-2016 :Madhu- Added for Order Types

ib_changed = True

Choose Case Upper(dwo.Name)
		
	// KRZ
	Case "USER_FIELD7"
		
		// Get the order type.
		ls_ordertype = getitemstring(1, "ord_type")
		
		// Process depending on trans and order types.
		f_processtransordertype(data, ls_ordertype)
		
	// KRZ
	Case "ORD_TYPE"
		
		//07-Feb-2017 :Madhu- Added to know whether Order Type is Available/Unavailable -START
		select Ord_Type_Desc, Unavailable into :ls_ord_Desc, :ls_unavailable 
		from Receive_Order_Type with(nolock)
		where Project_Id=:gs_project and Ord_Type= :data
		using sqlca;
		
		IF upper(ls_unavailable) ='Y' Then
			MessageBox(is_title, "'"+ ls_ord_Desc +"' is Unavailable when creating an Inbound Order!")
			Return 1
		End IF
		
		// KRZ 
		//if data = 'Z' then
			// show messagebox
		//	messagebox(is_title, "You may not select 'Warehouse Transfer' when creating an Inbound Order!")
		//	return 1
		//End If
		//07-Feb-2017 :Madhu- Added to know whether Order Type is Available/Unavailable -END
		
		// pvh - 12/05/06 - MARL
		//
		// if the order type changes to return and there putaway rows exist
		// do the MARL check
		//
		if data = 'X' and idw_putaway.rowcount() > 0 then
			setRLSkuList(  )
			setQualityHoldRows()
			if getMARLListCount() > 0 then
				if doMARLCheck() = one then 	setInventoryType()
			end if
		end if
		
		// 03/06 - PCONKL - If ord type changes, we may or may not show Supplier on Detail and Putaway tabs
		
		Select multiple_supplier_ind into :lsSupplierInd
		From Receive_Order_Type
		Where project_id = :gs_project and ord_type = :data;
		
		idw_main.SetITem(1,"multiple_supplier_ind",lsSUpplierInd)
		
		//If we are switching to ord type that does not allow multiple suppliers, make sure that we don't already have more than 1 on detail
		If lsSupplierInd <> "Y" and idw_Detail.RowCount() > 0 Then
			
			If idw_Detail.Find("Supp_Code <> '" + idw_main.GetITemString(1,"supp_code") + "'",1,idw_Detail.RowCount()) > 0 Then
				MessageBox(is_title,"This order has multiple suppliers at the detail level.~rYou can not switch to an order type that does not allow for multiple suppliers")
				Return 1
			End If
		
		End If
		
		wf_set_supplier_visibility()
		
		// Get the order type.
		ls_transtype = getitemstring(1, "user_field7")
		
		// Process depending on trans and order types.
		f_processtransordertype(ls_transtype, data)

	Case "SUPP_CODE"
	
		// 10/00 PCONKL - If order detail records have been entered, then we cant change supplier (all skus for order must have same supplier)
		If idw_detail.RowCount() > 0 Then
			messagebox(is_title,"You must delete the Order Detail records before you can change the Supplier!")
			Return 1
		End IF
	
		// 09/00 PCONKL - 'XX' is not a valid supplier. It was used for conversion where supplier was required but not available.

		If data = 'XX' Then
			Messagebox(is_title,"'XX' is not a valid supplier.~r~rAll SKU's with 'XX' as the supplier code will need to be changed to a valid supplier code before they can be placed on an order!")
			Return 1
		End If
	
		Select supp_name Into :ls_supp_name
			From supplier
			Where project_id = :gs_project and supp_code = :data;
		If sqlca.sqlcode = 0 Then
			This.SetItem(1, "supp_name", ls_supp_name)
		Else /*not Found*/
			Messagebox(is_title,"Supplier not found!",Stopsign!)
			Return 1
		End If
	
	Case "SUPP_ORDER_NO"
		
		// 05/07 - PCONKL - For AMS-MUSER, Validate for Dupplicate Supp_Order_No
		// 07/09 - MEA - Added for PHXBRANDS.
		
		If (gs_Project = 'AMS-MUSER' OR gs_Project = 'PHXBRANDS') AND trim(data) <> "" then
			
			lsRONO = This.GetITemString(1,'ro_no')
			lsOrder = data
			liCount = 0
			
			Select Count(*) into :liCount
			From Receive_Master
			Where Project_ID = :gs_Project  and supp_order_No = :lsOrder and ro_no <> :lsRONO;
			
			If liCount > 0 Then
				
				//If it's PHXBRANDS - Prompt them to see if they want to continue.
				
				IF gs_Project = 'PHXBRANDS' THEN
				
					IF Messagebox (is_title, "Caution - Duplicate Supplier Order Number. Would you like to continue? Y/N.", Exclamation!, YesNo!, 2) <> 1 THEN
						RETURN 1
					END IF
	
				ELSE
	
					MessageBox(is_title,"This Supplier Order Number (MAWB) already exists for another Order",StopSign!)
					Return 1
	
				End If
			
			End If
			
		End If

	CASE "SUPP_INVOICE_NO"
                                
		  // If this is the Pandora Project,
		  If gs_project = 'PANDORA' then
		  
				// KRZ If we can verify whether or not the string has at least one alpha character,
				If f_checkforalphachar(data, lb_hasalpha) then
				
					 // If the supplier invoice does NOT have at least one alpha character,
					 If not lb_hasalpha then
										  
						  // Show message.
						  messagebox("Invalid supplier code", "You must enter at least one alpha character.")
						  
						  // Return 1 to reject the value.
						  return 1
										  
					 // End If the supplier invoice does NOT have at least one alpha character.
					 End If
				
				// End If we can verify whether or not the string has at least one alpha character.
				End If
								
		  // End if this project is pandora.
		  End If
	
		If NOt g.ibAllowDupReceiveOrderNumbers Then
			
			lsOrder = data
			
			Select Count(*) into :liCount
			From Receive_Master
			Where project_id = :gs_Project and Supp_invoice_no  = :lsOrder and Ord_status <> 'V' and ro_no <> :lsRONO;
			
			If liCount > 0 Then
				MessageBox(is_Title,"Receive Order " + lsOrder + " already exists~r(This project does not allow duplicate order numbers)")
				This.SetFocus()
				this.Post Function SetItem(1, "supp_invoice_no", this.GetItemString(1,"supp_invoice_no", primary!, true))
				RETURN 1
				//This.Text = idw_Main.GetITemString(1,'supp_invoice_no')
			End If
							
		End IF
	
		//SEPT-2019 :MikeA S36895 F17741 -  I2544 - PHILIPS-TH allow duplicate INBOUND order numbers - START
		IF upper(gs_project) ='PHILIPS-TH' THEN
			
			ls_Wh_Code =  idw_main.getItemString(1, 'wh_code')
			
			if Not IsNull(ls_Wh_Code) AND trim(ls_Wh_Code) <> '' then
			
				select count(*) into :liCount 
				from receive_master with(nolock)
				where Project_ID = :gs_Project  and supp_invoice_no = :data
				and wh_code =:ls_Wh_Code
				using sqlca;
					
				IF liCount > 0 THEN
					MessageBox(is_Title,"Receiving Order " + data + " already exists.~r(This Warehouse should not allow duplicate order numbers.)", StopSign!)
					This.SetFocus()
					this.Post Function SetItem(1, "supp_invoice_no", this.GetItemString(1,"supp_invoice_no", primary!, true))
					Return 1
				END IF
			END IF
		END IF
		//SEPT-2019 :MikeA S36895 F17741 -  I2544 - PHILIPS-TH allow duplicate INBOUND order numbers - END
	
		
	Case "SHIP_REF"
		
		// 05/07 - PCONKL - For AMS-MUSER, Validate for Dupplicate Supp_Order_No
		If gs_Project = 'AMS-MUSER' then
			
			lsRONO = This.GetITemString(1,'ro_no')
			lsOrder = data
			liCount = 0
			
			Select Count(*) into :liCount
			From Receive_Master
			Where Project_ID = 'AMS-MUSER'  and ship_ref = :lsOrder and ro_no <> :lsRONO;
			
			If liCount > 0 Then
				MessageBox(is_title,"Rcv Slip Nbr already exists for another Order",StopSign!)
				Return 1
			End If
			
		End If
		
	Case "SUPP_INVOICE_NO"
		// dts 09/07 - limiting Order No to 10 chars for Coty 
		If gs_Project = 'COTY' then
			if len(data) > 10 then
				MessageBox(is_title, "Order can not exceed 10 characters.", StopSign!)
				return 1
			end if
		end if
		
	case "WH_CODE"
		
		IF gs_Project = "PANDORA" then
			ls_wh_code = data
			if Not IsNull(ls_wh_code) AND trim(ls_wh_code) <> '' then
				idw_other.GetChild("user_field2", ldwc)
				ldwc.SetTransObject(SQLCA)
				ldwc.Retrieve(upper(gs_project), ls_wh_code)
				SetNull(ls_null)
				//Make sure the user field 2 is reset if the wh_code is changed.
				idw_other.SetItem( 1, "user_field2", ls_null)
				idw_other.settaborder( "user_field2", 20)
				idw_other.Object.user_field2.Protect = false
			end if	
			idw_main.SetItem(1, "Ord_Date", f_GetLocalWorldTime(ls_wh_code))
		END IF

// TAM W&S 2010/12  We are processing bonded warehouses(Wh_TYPE "B" differently then non_bonded Wh_Type "N".  	
		IF Left(gs_Project,3) = "WS-" then
			ls_wh_code = data
			Select wh_type into :ls_wh_type
			From Warehouse
			Where Wh_code = :ls_wh_code  ;
			If ls_wh_type = 'B'  Then
				is_bonded = 'Y'
			Else
				idw_putaway.SetTabOrder("lot_no", 0)
				is_bonded = 'N'
			End If
		End If

		//SEPT-2019 :MikeA S36895 F17741 -  I2544 - PHILIPS-TH allow duplicate INBOUND order numbers - START
		IF upper(gs_project) ='PHILIPS-TH' THEN
			
			lsOrder = idw_main.getItemString(1, 'supp_invoice_no')
			
			select count(*) into :liCount 
			from receive_master with(nolock)
			where Project_ID = :gs_Project  and supp_invoice_no = :lsOrder
			and wh_code =:data
			using sqlca;
				
			IF liCount > 0 THEN
				MessageBox(is_Title,"Receiving Order " + lsOrder + " already exists.~r(This Warehouse should not allow duplicate order numbers.)", StopSign!)
				
				This.SetFocus()
				this.Post Function SetItem(1, "wh_code", this.GetItemString(1,"wh_code", primary!, true))
				RETURN 1

			END IF
		END IF
		//SEPT-2019 :MikeA S36895 F17741 -  I2544 - PHILIPS-TH allow duplicate INBOUND order numbers - END

	CASE "USER_FIELD2"
	
		IF gs_project = "PANDORA" THEN
			ls_Sub_Inventory_Type = data
			SELECT Owner_ID INTO :ll_owner_id FROM OWNER 
				WHERE Project_ID = "PANDORA" AND
						Owner_CD = :ls_Sub_Inventory_Type
				USING SQLCA;
			IF SQLCA.SQLCode = 100 THEN
				MessageBox ("Error", "Sub-Inventory Location ("+ls_Sub_Inventory_Type+") not found in Owner Table")
				Return 1
			ELSE
				ls_CustCode = ''
				SELECT	Cust_Code INTO :ls_CustCode FROM Customer
				WHERE 	Cust_Code = :ls_Sub_Inventory_Type AND Project_ID = 'PANDORA' and Customer_type = 'IN'
				USING 	SQLCA;
					
				if sqlca.SQlcode <> 0 and sqlca.SQlcode <> 100 then
						MessageBox ("DB Error", SQLCA.SQLErrText)
				end if
					
				If ISNull( ls_CustCode	) Then  ls_CustCode =''
				
				if ls_CustCode <> '' Then
					MessageBox (is_Title, "Sub-Inventory Location Must be an Active Customer.")
					return 1
				end if
								
				FOR li_idx = 1 to idw_putaway.RowCount()
					//Set Owner to Sub-Inventory-Loc
					idw_putaway.SetItem(li_idx, "owner_id", ll_owner_id)
					if not ISNull(data) then idw_putaway.SetItem(li_idx, "c_owner_name",data +' (C)')
				NEXT
				FOR li_idx = 1 to idw_detail.RowCount()
					//Set Owner to Sub-Inventory-Loc
					idw_detail.SetItem(li_idx, "owner_id", ll_owner_id)
					if not ISNull(data) then idw_detail.SetItem(li_idx, "c_owner_name",data+' (C)')
				NEXT			
			END IF
		END IF

string ls_uf3, ls_uf7
	CASE "USER_FIELD6"
      //12/09/09 UJHALL Removed logic that had been UF6; replaced with logic that had been UF3: 
		// part of no more entries in UF6 and UF8 at header level for Pandora & Xchange UF6 for UF3
//		IF gs_project = "PANDORA" THEN
//			if data <> '' then
//				FOR li_idx = 1 to idw_putaway.RowCount()
//					//Set po_no to Project ID
//					idw_putaway.SetItem(li_idx, "po_no", data)
//				NEXT
//			END IF
//		END IF
//string ls_uf3, ls_uf7
		IF gs_project = 'PANDORA' THEN
			ls_uf7 = idw_main.GetItemString( 1,"user_Field7")
			ls_uf3 = data
			IF ls_uf7 = "MATERIAL RECEIPT" THEN
				li_count = 0
				SELECT Count(*) INTO :li_count FROM Customer
					WHERE Cust_Code = :ls_uf3 AND Project_ID = 'PANDORA' and Customer_type<> 'IN'
						USING SQLCA;
				if sqlca.SQlcode <> 0 then
					MessageBox ("DB Error", SQLCA.SQLErrText)
				end if
				if li_count <= 0 then
					MessageBox (is_Title, "FROM Location must be a valid and acitve Customer.")
					return 1
				end if
			END IF
		END IF

 	CASE "USER_FIELD3"
//		IF gs_project = 'PANDORA' THEN
//			ls_uf7 = idw_main.GetItemString( 1,"user_Field7")
//			ls_uf3 = data
//			IF ls_uf7 = "MATERIAL RECEIPT" THEN
//				integer li_count
//				SELECT Count(*) INTO :li_count FROM Customer
//					WHERE Cust_Code = :ls_uf3 AND Project_ID = 'PANDORA' 
//						USING SQLCA;
//				if sqlca.SQlcode <> 0 then
//					MessageBox ("DB Error", SQLCA.SQLErrText)
//				end if
//				if li_count <= 0 then
//					MessageBox (is_Title, "FROM Location must be a valid Customer.")
//					return 1
//				end if
//			END IF
//	END IF
	Case 'USER_FIELD10'
		
		//For a Warner Return Order, User Field 10 must be a valid customer Code
		If gs_project = 'WARNER' and This.GetITemString(1,'ord_type') = 'X' Then
			
			If Data > '' Then
				
				Select Count(*) into :liCount
				from customer
				Where project_id = :gs_project and cust_code = :data;
			
				If liCount < 1 Then
					Messagebox(is_title,'Invalid Customer Code',StopSign!)
					return 1
				End If
				
			End If
			
			//add/update an alt address record for the customer
			wf_create_rma_address(data)
			
		End If /*Warner*/
		
	Case "ORD_STATUS" // 1/26/2011; David C; Allow Admin user to reset the status back to New only
		// Void can only be reset to New
		if this.GetItemString ( 1, "ord_status" ) = "V" then
			if data <> "N" then
				MessageBox ( is_title, "A Voided order can only be reset to 'New'.", Exclamation! )
				Return 1
			end if
			
			// Re-enable the save menu item
			im_menu.m_file.m_save.Enabled = true
			
			// Indicate status is being reset to prevent status change message in ue_save event
			ib_OrdStatusReset = true
		end if
			
End Choose
end event

event itemerror;//Choose Case dwo.name
//	Case "supp_code"
//		Return 1
//	Case Else
//		Return 2
//End Choose

Return 2
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event clicked;call super::clicked;DatawindowChild	ldwc

// 02/02 PCONKL - Retrieve dropdowns when clicked on

Choose Case Upper(dwo.Name)
		
	Case 'TRANSPORT_MODE' 
		This.GetChild('Transport_mode',ldwc)
		ldwc.SetTransObject(SQLCA)
		ldwc.Retrieve(gs_project)
		If ldwc.RowCount() = 0 Then ldwc.InsertRow(0)
				
//	Case 'CARRIER' 
//		This.GetChild('Carrier',ldwc)
//		ldwc.SetTransObject(SQLCA)
//		ldwc.Retrieve(gs_project)
//		If ldwc.RowCount() = 0 Then ldwc.InsertRow(0)
		
End Choose
end event

event constructor;DatawindowChild	ldwc

/* GailM 20150323 - Moved to dw_other_info for user field change to another tab
// KRZ - Make country a dddw for Pandora.
if gs_project = "PANDORA" then
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.name='dddw_country_2char'
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.displaycolumn='designating_code'
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.datacolumn='designating_code'
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.user_field5.width="650"
	 tab_main.tabpage_main.dw_main.object.user_field5.dddw.percentwidth="200"         
	 tab_main.tabpage_main.dw_main.GetChild("user_field5", ldwc)
	 ldwc.SetTransObject(SQLCA)
	 ldwc.retrieve()
End If
*/

// 02/02 PCONKL - Transport Mode  and carrier dropdowns - we'll only populate if clicked on
This.GetChild('transport_mode',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.InsertRow(0)

This.GetChild('carrier',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.InsertRow(0)

// 9/21/2010 - added cross-dock check box for Pandora
	If upper(gs_project) <> 'PANDORA' Then
	  this.Modify("CrossDock_Ind.Visible=0")
	end if

super::Event constructor()
end event

event getfocus;////GAP 1-03 Enable Scanner ID and Status boxes in Datawindow
//string ind
//ind  = g.is_scanner_ind
//If  g.is_scanner_ind = "Y" Then
//	idw_main.object.scanner1_t.visible = 1	
//	idw_main.object.scanner2_t.visible = 1	
//	idw_main.object.scanner_id.visible = 1	
//	idw_main.object.scanner_status.visible = 1
//	IF not IsNull(gs_role) and gs_role <> " " THEN							
//		if integer(gs_role) <= 1 then idw_main.object.scanner_status.protect = 0
//	end if
//		
//		
//End If
end event

event doubleclicked;call super::doubleclicked;//MStuart commented 072011 - created command button, visible if order in completed status and login as super user

//choose case gs_userid
//	case 'DTS', 'BOB', 'JXLIM', 'LKEHLER'
//		if messagebox("TEMPORARY! Need to validate/bullet proof.", "Hey, Create Back Order?", Question!, YesNo!, 1) = 1 then
//			iw_window.triggerEvent("ue_backorder")
//		end if
//end choose

end event

type st_ro_order_no from statictext within tabpage_main
integer x = 142
integer y = 28
integer width = 357
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Order Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_ro_search from commandbutton within tabpage_search
integer x = 3186
integer y = 192
integer width = 274
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;DateTime ldt_date
String ls_string, ls_where, ls_sql ,ls_in_clause,ls_search_string,ls_User_field13,ls_User_field15,ls_search_legid,ls_invoice_no,ls_search_legid1
Boolean lb_order_from, lb_order_to, lb_sched_from, lb_sched_to, lb_complete_from, lb_complete_to
Boolean lb_where,lb_legid
Boolean lsuseSku,lsuseCONTID,lsusePONO
//Initialize Date Flags
lb_order_from 		= FALSE
lb_order_to 		= FAlSE
lb_sched_from 		= FALSE
lb_sched_to 		= FALSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE

LONG ll_rtn = 0,i

ll_rtn = idw_condition.AcceptText()

//If idw_condition.AcceptText() = -1 Then Return
IF ll_rtn = 0 THEN
	// Shouldn't happen
	Return
ELSEIF ll_rtn = -1 THEN
	// error from something - can we handle it?
	return
END IF
	
tab_main.tabpage_search.uo_mobile_status.bringtotop = false /* 06/15 - PCONKL */

idw_search.Reset()
ls_sql = is_sql
lb_where = False
//MStuart 080311 - added where, iso conversion removed the where clause from original sql
ls_where = " where receive_master.project_id = '" + gs_project + "' "

ldt_date = idw_condition.GetItemDateTime(1,"ord_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_condition.GetItemDateTime(1,"ord_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.ord_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_order_to = TRUE
	lb_where = TRUE
End If

ldt_date = idw_condition.GetItemDateTime(1,"complete_date_s")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.complete_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_complete_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_condition.GetItemDateTime(1,"complete_date_e")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.complete_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_complete_to = TRUE
	lb_where = TRUE
End If

ldt_date = idw_condition.GetItemDateTime(1,"receive_date_from")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.arrival_date >= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_sched_from = TRUE
	lb_where = TRUE
End If

ldt_date = idw_condition.GetItemDateTime(1,"receive_date_to")
If  Not IsNull(ldt_date) Then
	ls_where += " and receive_master.arrival_date <= '" + &
		String(ldt_date, "yyyy-mm-dd hh:mm:ss") + "' "
	lb_sched_to = TRUE
	lb_where = TRUE
End If


ls_string = idw_condition.GetItemString(1,"ord_type")
if not isNull(ls_string) then
	ls_where += " and receive_master.ord_type = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"ro_no")
if not isNull(ls_string) then
	ls_where += " and receive_master.ro_no = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"ord_status")
if not isNull(ls_string) then
	ls_where += " and receive_master.ord_status = '" + ls_string + "' "
	lb_where = TRUE	
end if

ls_string = idw_condition.GetItemString(1,"ord_status")
if not isNull(ls_string) then
	ls_where += " and receive_master.ord_status = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"wh_code")
if not isNull(ls_string) then
	ls_where += " and receive_master.wh_code = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"supp_code")
if not isNull(ls_string) then
	ls_where += " and receive_master.supp_code = '" + ls_string + "' "
	lb_where = TRUE
end if


ls_string = idw_condition.GetItemString(1,"supp_order_no")
if not isNull(ls_string) then
	//TimA 01/17/14 Pandora issue #693 Pass the * to a new function for Wild card searches.
	If POS( ls_string,'*') > 0 Then
		ls_string = f_Get_String_Pars(ls_string,'*' ) //New Function
		ls_where += "  and receive_master.supp_order_no Like '%" + ls_string + "%' " 
	Else
		ls_where += " and receive_master.supp_order_no = '" + ls_string + "' "
	End if
	lb_where = TRUE
end if

//nxjain to improve the search criteria trim the invoice value -20160211

ls_string = trim(idw_condition.GetItemString(1,"invoice_no"))
  long ll_find,flag
//Dinesh - 02/11/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search 
select count(*) into :ll_find from Receive_Master where Supp_Invoice_No= :ls_string and project_id=:gs_project;
//Dhirendra-11 Jan 2021 PANDORA S52705- Added if condition for multiple search and creating search string to pass in  IN Clauae
IF not isNull(ls_string)  and  (Pos(ls_string, ",") > 0 or (Pos(ls_string, ",") = 0 and flag=1)) and Upper(gs_project) ="PANDORA" THEN
//IF not isNull(ls_string)  and  (Pos(ls_string, ",") > 0 ) and Upper(gs_project) ="PANDORA" THEN
	ls_where  += "and receive_master.Supp_Invoice_No IN (" 
// Begin - Dinesh - 01/19/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search
for i = 1 to 15
    IF  pos(ls_string,',') > 0 then 
			ls_in_clause = left(ls_string,(pos(ls_string,',')))
		 	ls_in_clause =  left(ls_in_clause,(len(ls_in_clause) - 1))
		 	 select User_field13,User_field15 into :ls_User_field13, :ls_User_field15 from Receive_Master where Supp_Invoice_No=:ls_in_clause and project_id=:gs_project;
			 ls_search_string = ls_search_string + "'" + ls_in_clause + "'"
			 ls_search_string  =  ls_search_string + ", "
			 ls_string= right(ls_string,(len(ls_string) - len(ls_in_clause) )-1)
			 if ((not isnull(ls_User_field13) or trim(ls_User_field13)<>"") and (not isnull(ls_User_field15) or trim(ls_User_field15)<>"")) or ((not isnull(ls_User_field13) or trim(ls_User_field13)<> "") and (isnull(ls_User_field15) or  trim(ls_User_field15)= "")) or ((isnull(ls_User_field13) or trim(ls_User_field13)= "") and (not isnull(ls_User_field15) or  trim(ls_User_field15) <> "")) or ((isnull(ls_User_field13) or trim(ls_User_field13)= "") and (isnull(ls_User_field15) or  trim(ls_User_field15)= "")) then
					if  ( isnull(ls_User_field13) and not isnull(ls_User_field15)) then
						ls_User_field13=""
					elseif  (isnull(ls_User_field13) and isnull(ls_User_field15)) then
						ls_User_field13=""
						ls_User_field15=""
					elseif  (not isnull(ls_User_field13) and isnull(ls_User_field15)) then
						ls_User_field15=""
					end if
					ls_search_legid  = ls_search_legid+ "'"+ls_User_field13+"'" + ", "+ "'"+ls_User_field15+"'"+", "
			  end if
		 ls_search_legid1=ls_search_legid
	ELSE
		IF not isnull(ls_string) or ls_string <> ''  then
			select User_field13,User_field15 into :ls_User_field13, :ls_User_field15 from Receive_Master where Supp_Invoice_No=:ls_string and project_id=:gs_project;
		 if ((not isnull(ls_User_field13) or trim(ls_User_field13)<>"") and (not isnull(ls_User_field15) or trim(ls_User_field15)<>"")) or ((not isnull(ls_User_field13) or trim(ls_User_field13)<> "") and (isnull(ls_User_field15) or  trim(ls_User_field15)= "")) or ((isnull(ls_User_field13) or trim(ls_User_field13)= "") and (not isnull(ls_User_field15) or  trim(ls_User_field15) <> "")) or ((isnull(ls_User_field13) or trim(ls_User_field13)= "") and (isnull(ls_User_field15) or  trim(ls_User_field15)= "")) then
					if  ( isnull(ls_User_field13) and not isnull(ls_User_field15)) then
						ls_User_field13=""
					elseif  (isnull(ls_User_field13) and isnull(ls_User_field15)) then
						ls_User_field13=""
						ls_User_field15=""
					elseif  (not isnull(ls_User_field13) and isnull(ls_User_field15)) then
						ls_User_field15=""
					end if
				ls_search_legid1  = ls_search_legid1+ "'"+ls_User_field13+"'" + ", "+ "'"+ls_User_field15+"'"
		  end if
			  ls_search_string = ls_search_string + "'" + ls_string + "'" + ", "+ ls_search_legid1
			  ls_where += ls_search_string + ") "
			  lb_where =true
		 END if 
		exit 
	END IF  
	next
ELSE
// End - Dinesh - 01/19/2021 - S52817 - Google - SIMS - SAP Conversion - GUI - Multileg Search
//Dhirendra End Here
if not isNull(ls_string) then
//	ls_where += " and receive_master.Supp_Invoice_No = '" + ls_string + "' "
	ls_where += " and receive_master.Supp_Invoice_No Like '%" + ls_string + "%' " /* 02/03 - Pconkl - use Like */
	lb_where = TRUE
end if
end if 

ls_string = idw_condition.GetItemString(1,"ship_ref")
if not isNull(ls_string) then
	ls_where += " and receive_master.ship_ref Like '%" + ls_string + "%' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"user_field1")
if not isNull(ls_string) then
	ls_where += " and receive_master.user_field1 = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"user_field2")
if not isNull(ls_string) then
	ls_where += " and receive_master.user_field2 = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"user_field3")
if not isNull(ls_string) then
	ls_where += " and receive_master.user_field3 = '" + ls_string + "' "
	lb_where = TRUE
end if

ls_string = idw_condition.GetItemString(1,"sku")
if not isNull(ls_string) then
	ls_where += " and receive_detail.sku = '" + ls_string + "' "
	lsUseSku = True /* 07/03 Mathi - searching on sku, we need to remove outer join to Master*/
	lb_where = TRUE
end if

//MEA - 12/11 - Added AWB_BOL_No to search

ls_string = idw_condition.GetItemString(1,"awb_bol_no")
if not isNull(ls_string) then
	ls_where += " and receive_master.AWB_BOL_No = '" + ls_string + "' "
	lb_where = TRUE
end if



ls_string = idw_condition.GetItemString(1,"container_id")
if not isNull(ls_string) then
	ls_where += " and receive_putaway.container_id = '" + ls_string + "' "
	lsuseCONTID = True /* 07/03 Mathi - searching on CONT ID, we need to remove outer join to Master*/
	lb_where = TRUE
end if

// 10/10 - PCONKL
// ET3 2012-08-02: PANDORA 456 - lot no from EDI_Batch_Seq_no.
ls_string = idw_condition.GetItemString(1,"lot_no")
if not isNull(ls_string) then
	ls_where += " and ( receive_putaway.lot_no = '" + ls_string + "' OR "
	ls_where += "  EDI_Inbound_Detail.lot_no = '" + ls_string + "' ) "
	
	IF idw_condition.GetItemString(1,"ord_status") = 'N' THEN
		// Do NOT use INNER JOINs for status 'NEW'
		lsuseCONTID = FALSE
	ELSE
		lsuseCONTID = True 
	END IF
	
	lb_where = TRUE
end if

//PO

ls_string = idw_condition.GetItemString(1,"po_no")
if not isNull(ls_string) then
	
	if left(upper(gs_project), 4) = 'NIKE' then //MEA - 2-12 - Added PO to search for SAP PO.
		ls_where += " and (receive_detail.user_field5 = '" + ls_string + "' )" /* 04/04 - MA -  */
	else
		ls_where += " and (receive_putaway.po_no = '" + ls_string + "' or Receive_Putaway.ro_no in (select ro_no from receive_xref where po_no = '" + ls_string + "'))" /* 04/04 - MA - Added so Receive _Xref would be search for po_no */
	end if
	
	lsusePONO = False /* 12/03 Mathi - searching on PO NO, we need to remove outer join to Master*/
	lb_where = TRUE
end if

//08/07 - PCONKL - adding Expected Serial Number search in support of 3COM RMA
ls_string = idw_condition.GetItemString(1,"exp_serial_No")
if not isNull(ls_string) then
	ls_where += " and receive_detail.exp_serial_No = '" + ls_string + "' "
	lsUseSku = True 
	lb_where = TRUE
end if

//06/15 - PCONKL - Added Mobile Status
ls_string = tab_main.tabpage_search.uo_mobile_status.uf_build_search(true)
if not isNull(ls_string) then
	ls_where += ls_string
	lb_where = TRUE
end if 

// 06/08 - PCONKL - Addeded "Custom_Field1" which can be used for different fields for different projects
//08/07 - PCONKL - adding Expected Serial Number search in support of 3COM RMA

ls_string = idw_condition.GetItemString(1,"custom_field1")
if not isNull(ls_string) then
	
	Choose Case UPPER(gs_project)
			
		Case "DIEBOLD" /* Receive Detail UF4 = Sales Order*/
	
			ls_where += " and receive_detail.user_field4 = '" + ls_string + "' "
			lsUseSku = True 
			lb_where = TRUE

		Case "PANDORA" /* From Location -> User_Field6 */
			// ET3 - 2012/07/31: Pandora issue 456, search for From Location
			ls_where += " and receive_master.user_field6 = '" + ls_string + "' "
			lb_where = TRUE
			
	End Choose
		
End If

//12/08 - MEA - added Serial Number search in support of 3COM RMA
//GailM 6/24/2019 - DE11208 Google Footprints Serial Search and 2d barcode issue - add search of serial tab
ls_string = idw_condition.GetItemString(1,"serial_no")
if not isNull(ls_string) then
	If Upper(gs_project) = 'PANDORA' then
		ls_where += " and (receive_master.ro_no in (SELECT Receive_Serial_Detail.ro_no from Receive_Serial_Detail Where Receive_Serial_Detail.serial_no = '" + ls_string + "') "
		ls_where += " or receive_master.ro_no in (SELECT Receive_Putaway.ro_no from Receive_Putaway Where Receive_Putaway.serial_no = '" + ls_string + "')) "
	Else
		ls_where += " and receive_master.ro_no in (SELECT Receive_Putaway.ro_no from Receive_Putaway Where Receive_Putaway.serial_no = '" + ls_string + "') "
	End If
	lsUseSku = True 
	lb_where = TRUE
end if

//MEA - 11/09/2012 Added generic search functions for User_Fields.

integer liIdx

for liIdx = 1 to 8

	if UpperBound(isGenericSearchColumnNameValue) >= liIdx then
	
		ls_string = idw_condition.GetItemString(1,"search_field" + string(liIdx))
		if not isNull(ls_string) and trim(ls_string) <> '' and  trim(isGenericSearchColumnNameValue[liIdx]) <> '' then
			
	//Dhirendra-11 Jan 2021 PANDORA S52705- Added if condition for multiple search and creating search string to pass in  IN Clauae	
			IF not isNull(ls_string)  and  Pos(ls_string, ",") > 0 and Upper(gs_project) ="PANDORA" THEN
	ls_where  += "and receive_master.Client_cust_po_nbr IN (" 
for i = 1 to 10

IF  pos(ls_string,',') > 0 then 
	ls_in_clause = left(ls_string,(pos(ls_string,',')))
    ls_in_clause =  left(ls_in_clause,(len(ls_in_clause) - 1))
        ls_search_string = ls_search_string + "'" + ls_in_clause + "'"
		 ls_search_string  =  ls_search_string + ", "
	    ls_string= right(ls_string,(len(ls_string) - len(ls_in_clause) )-1)
	else
		IF not isnull(ls_string) or ls_string <> '' then
		  ls_search_string = ls_search_string + "'" + ls_string + "'"
		  ls_where += ls_search_string + ") "
		  lb_where = true
	end if 
	exit 
end if 
next
else
 
//			ls_where += " and " + isGenericSearchColumnNameValue[liIdx] + " = '" + ls_string + "' "
//		     Use like so you can search wildcard %
// TAM 2016/08/03 - Fixed the like operater to automatically put in the %
//			ls_where += " and " + isGenericSearchColumnNameValue[liIdx] + " like '" + ls_string + "' "
			ls_where += " and " + isGenericSearchColumnNameValue[liIdx] + " like '%" + ls_string + "%' "
			
			lb_where = TRUE
		end if 
		end if
	
	else
		EXIT
	end if
		

next




IF not lb_where THEN
   IF	i_nwarehouse.of_msg(is_title,1) <> 1 THEN Return
END IF	

// 07/03 Mathi - If including search on SKU, remove the outer join on master - we only want to show masters that have sku in detail
If lsUseSku  Then
	//MStuart - commented 080211 - iso sql changes
	//ls_sql = Replace(ls_sql,pos(ls_sql,"=*"),2,"=") with left outer join
	ls_sql = Replace(ls_sql,pos(ls_sql,"left outer"),10,"inner")
End If

// 12/03 Mathi - If including search on CONTID or PO NO, remove the outer joins on master - we only want to show masters that have CONTID or PO NO in picking
If lsuseCONTID or lsusePONO Then
	//MStuart - commented 080211 - iso sql changes
	//ls_sql = Replace(ls_sql,pos(ls_sql,"=*"),2,"=") with left outer join
	ls_sql = Replace(ls_sql,pos(ls_sql,"left outer"),10,"inner")
	If Not lsuseSku Then
		//MStuart - commented 080211 - iso sql changes
		//ls_sql = Replace(ls_sql,pos(ls_sql,"=*"),2,"=") with left outer join
	 	ls_sql = Replace(ls_sql,pos(ls_sql,"left outer"),10,"inner")
   End If 
End If
   

//Check Order Date range for any errors prior to retrieving
IF ((lb_order_to = TRUE and lb_order_from = FALSE) 	OR &
	 (lb_order_from = TRUE and lb_order_to = FALSE)  	OR &
	 (lb_order_from = FALSE and lb_order_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Order Date Range", Stopsign!)
	Return
END IF

//Check Complete Date range for any errors prior to retrieving
IF ((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
	 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
	 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
	Return
END IF	

//Check Sched Arrival Date range for any errors prior to retrieving
IF ((lb_sched_to = TRUE and lb_sched_from = FALSE) 	OR &
	 (lb_sched_from = TRUE and lb_sched_to = FALSE)  	OR &
	 (lb_sched_from = FALSE and lb_sched_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Sched Arrival Date Range", Stopsign!)
	Return
END IF	

ls_sql += ls_where


idw_search.SetSqlSelect(ls_sql)

If idw_search.Retrieve() = 0 Then
	messagebox(is_title,"No records found!")
End If

end event

event constructor;

g.of_check_label_button(this)
end event

type cb_ro_clear from commandbutton within tabpage_search
integer x = 3186
integer y = 324
integer width = 274
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;idw_condition.Reset()
idw_condition.InsertRow(0)

If gs_default_wh > '' Then
	idw_condition.SetItem(1,'wh_code',gs_default_wh)
End If

 // 06/15- PCONKL - Added MObile status
tab_main.tabpage_search.uo_mobile_status.visible = true
tab_main.tabpage_search.uo_mobile_status.bringtotop = false
ib_show_mobile_status = False
tab_main.tabpage_search.uo_mobile_status.uf_clear_list( )
idw_condition.setItem(1,"mobile_status_ind", "<Select Multiple>")
 
idw_search.Reset()


end event

event constructor;
g.of_check_label_button(this)
end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 5
integer y = 768
integer width = 3451
integer height = 1284
integer taborder = 20
string dataobject = "d_ro_search"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;// Pasting the record to the main entry datawindow
string ls_code
If isVAlid(w_order_details) Then
Close (w_order_details)
End if
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		ls_code = this.getitemstring(row,'supp_invoice_no')
		is_rono = this.getitemstring(row,'ro_no')
		isle_code.text = ls_code
		isle_code.TriggerEvent(Modified!)
	End If
END IF
end event

event clicked;call super::clicked;// Pasting the record to the main entry datawindow
string ls_code

//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)

	//TimA 11/03/14 Pandora asked for this but I am making it a basline change.
	//This will look into the inbound order and display a popup box that shouls the list of skus and qty
	If isVAlid(w_order_details) Then
		Close (w_order_details)
	End if
	
	If idw_condition.GetItemString(1,"show_more_detail") = '1' then
		ls_code = this.getitemstring(row,'supp_invoice_no')
		is_rono = this.getitemstring(row,'ro_no')
	
		Str_parms	lstrParms
	
		lstrparms.String_Arg[1] = gs_project
		lstrparms.String_Arg[2] = is_rono
		lstrparms.String_Arg[3] = ls_code
		lstrParms.String_arg[4] = 'w_ro'
		Openwithparm(w_order_details, lStrparms)
	end if

END IF
end event

event constructor;call super::constructor;
//07/15 - pconkl - hide mobile status if not enabled for project
If not g.ibMobileEnabled THen
	This.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
End If
end event

type uo_mobile_status from uo_multi_select_search within tabpage_search
event ue_mosemove pbm_mousemove
integer x = 1440
integer y = 224
integer height = 444
integer taborder = 40
end type

event ue_mosemove;if ib_show_mobile_status then
	ib_show_mobile_status = false
	this.bringtotop = false
else
	ib_show_mobile_status = true
	this.bringtotop = true
end if
end event

on uo_mobile_status.destroy
call uo_multi_select_search::destroy
end on

type dw_condition from u_dw_ancestor within tabpage_search
integer y = 16
integer width = 3643
integer height = 756
integer taborder = 20
string dataobject = "d_ro_search_con"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;ib_srch_order_from_first 		= TRUE
ib_srch_order_to_first 			= TRUE
ib_srch_receive_from_first 	= TRUE
ib_srch_receive_to_first 		= TRUE
ib_srch_complete_from_first 	= TRUE
ib_srch_complete_to_first 		= TRUE

//07/15 - pconkl - hide mobile status if not enabled for project
If not g.ibMobileEnabled THen
	This.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
End If
end event

event clicked;call super::clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date
dw_condition.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_condition.GetRow()

CHOOSE CASE ls_column
		
	CASE "ord_date_s"
		
		IF ib_srch_order_from_first THEN
					
			ldt_begin_date = f_get_date("BEGIN")
			dw_condition.SetColumn("ord_date_s")
			dw_condition.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_srch_order_from_first = FALSE
			
		END IF
		
	CASE "ord_date_e"
		
		IF ib_srch_order_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_condition.SetColumn("ord_date_e")
			dw_condition.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_srch_order_to_first = FALSE
			
		END IF
		
	CASE "receive_date_from"
		
		IF ib_srch_receive_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_condition.SetColumn("receive_date_from")
			dw_condition.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_srch_receive_from_first = FALSE
			
		END IF
		
	CASE "receive_date_to"
		
		IF ib_srch_receive_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_condition.SetColumn("receive_date_to")
			dw_condition.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_srch_receive_to_first = FALSE
			
		END IF
		
	CASE "complete_date_s"
		
		IF ib_srch_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_condition.SetColumn("complete_date_s")
			dw_condition.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_srch_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_date_e"
		
		IF ib_srch_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_condition.SetColumn("complete_date_e")
			dw_condition.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_srch_complete_to_first = FALSE
			
		END IF
		
		
	CASE 'lot_no'
		STRING ls_msg = ''
		LONG   ll_reply = 0
		LONG   ll_rtn = 0
		STRING ls_null
		
		SetNull(ls_null)
		
		ls_msg =   'Lot number searches can take considerable length of time. You should also ~r~n' &
					+ 'select other search parameters such as status, or date to speed up the query.~r~n' &
					+ 'For in-transit inbound orders, make sure to select order status of "NEW".~r~n~r~n' &
					+ '      Select "Yes" to automatically set Order Status field to "NEW". ~r~n' & 
					+ '      Select "NO" to leave the other fields as they are. ~r~n' //&
//					+ '      Or select "CANCEL" to remove the contents of the LOT_NO field'
					
		ll_reply = 0
		ll_reply = MessageBox('WARNING', ls_msg, Question!, YesNo! ) 
		
		if ll_reply = 1 then
			// 'YES'
			this.setitem( row, 'ord_status', 'N' )
			ll_Rtn = 0
			
		elseif ll_reply = 2 then
			// 'NO' - make no changes elsewhere
			ll_Rtn = 0
			
		elseif ll_reply = 3 then
			// 'CANCEL' - lot_no is rejected
			this.setitem( row, dwo.name, ls_null)
			ll_Rtn = 1
			
		else
			// shouldn't happen but being thorough
			ll_Rtn = 1
			
		end if
		
	Case "mobile_status_ind" 
		
		uf_showhide_status("mobile_status_ind")		
		
CASE ELSE
		
END CHOOSE

end event

event itemchanged;call super::itemchanged;BOOLEAN lb_SN_cleaned = FALSE
LONG    ll_Rtn = 0
LONG    ll_reply = 0
STRING  ls_msg = ''
STRING  ls_null


ll_Rtn = 0  //initialize to 'okay'
SetNull(ls_null)


CHOOSE CASE dwo.name
		
	CASE 'serial_no'
		IF UPPER(gs_project) = 'PANDORA' THEN
					
			// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
			data = TRIM(data)
			If len(data) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( data, "[-\.]$" )
					data = MID(data, 1, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( data, "^[-\.]")
					data = MID(data, 2, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
		END IF  // Pandora
		
	CASE 'lot_no'
//		ls_msg =   'Lot number searches can take considerable length of time. ~r~n' &
//					+ 'You should also select other search parameters such as status, ~r~n' &
//					+ 'or date to speed up the query. ~r~n ~r~n' &
//					+ 'Select "Yes" to automatically set Order Status field to "NEW". ~r~n' & 
//					+ 'Select "NO" to leave the other fields as they are. ~r~n' &
//					+ 'Or select "CANCEL" to remove the contents of the LOT_NO field'
//					
//		ll_reply = 3
//		ll_reply = MessageBox('WARNING', ls_msg, Question!, YesNoCancel! ) 
//		//dodisplaymessage('WARNING', ls_msg)
//		
//		if ll_reply = 1 then
//			// 'YES'
//			this.setitem( row, 'ord_status', 'N' )
//			ll_Rtn = 0
//			
//		elseif ll_reply = 2 then
//			// 'NO' - make no changes elsewhere
//			ll_Rtn = 0
//			
//		elseif ll_reply = 3 then
//			// 'CANCEL' - lot_no is rejected
//			this.setitem( row, dwo.name, ls_null)
//			ll_Rtn = 1
//			
//		else
//			// shouldn't happen but being thorough
//			ll_Rtn = 1
//			
//		end if

	Case 'show_more_detail'

		If isVAlid(w_order_details) Then
			Close (w_order_details)
		End if			
END CHOOSE


IF lb_SN_cleaned THEN
	// override any other return setting
	ll_Rtn = 2
	this.setitem( row, dwo.name, data )

END IF

RETURN ll_Rtn
end event

type tabpage_other_info from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3858
integer height = 1856
long backcolor = 79741120
string text = "Other Info"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_other dw_other
end type

on tabpage_other_info.create
this.dw_other=create dw_other
this.Control[]={this.dw_other}
end on

on tabpage_other_info.destroy
destroy(this.dw_other)
end on

type dw_other from u_dw_ro_master_uf within tabpage_other_info
integer x = -14
integer y = 68
integer width = 3717
integer height = 780
integer taborder = 20
boolean border = false
end type

event constructor;call super::constructor;DatawindowChild	ldwc


// GailM 20150323 - Moved from dw_main to dw_other_info for user fields
// KRZ - Make country a dddw for Pandora.
if gs_project = "PANDORA" then
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.name='dddw_country_2char'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.displaycolumn='designating_code'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.datacolumn='designating_code'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.useasborder='yes'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.allowedit='no'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.vscrollbar='yes'
	 tab_main.tabpage_other_info.dw_other.object.user_field5.width="650"
	 tab_main.tabpage_other_info.dw_other.object.user_field5.dddw.percentwidth="200"         
	 tab_main.tabpage_other_info.dw_other.GetChild("user_field5", ldwc)
	 ldwc.SetTransObject(SQLCA)
	 ldwc.retrieve()
End If 

end event

event itemchanged;call super::itemchanged;
ib_changed = true
end event

type tabpage_orderdetail from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3858
integer height = 1856
long backcolor = 79741120
string text = "Order Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_ro_verify_sku_text st_ro_verify_sku_text
sle_verify sle_verify
cb_ims_verify cb_ims_verify
cb_iqc cb_iqc
cb_insert cb_insert
cb_delete cb_delete
cb_list_sku cb_list_sku
dw_detail dw_detail
dw_list_sku dw_list_sku
end type

on tabpage_orderdetail.create
this.st_ro_verify_sku_text=create st_ro_verify_sku_text
this.sle_verify=create sle_verify
this.cb_ims_verify=create cb_ims_verify
this.cb_iqc=create cb_iqc
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.cb_list_sku=create cb_list_sku
this.dw_detail=create dw_detail
this.dw_list_sku=create dw_list_sku
this.Control[]={this.st_ro_verify_sku_text,&
this.sle_verify,&
this.cb_ims_verify,&
this.cb_iqc,&
this.cb_insert,&
this.cb_delete,&
this.cb_list_sku,&
this.dw_detail,&
this.dw_list_sku}
end on

on tabpage_orderdetail.destroy
destroy(this.st_ro_verify_sku_text)
destroy(this.sle_verify)
destroy(this.cb_ims_verify)
destroy(this.cb_iqc)
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.cb_list_sku)
destroy(this.dw_detail)
destroy(this.dw_list_sku)
end on

type st_ro_verify_sku_text from statictext within tabpage_orderdetail
integer x = 2949
integer y = 76
integer width = 457
integer height = 48
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Verify SKU or UPC"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_verify from singlelineedit within tabpage_orderdetail
integer x = 2885
integer y = 4
integer width = 553
integer height = 76
integer taborder = 40
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event getfocus;This.SelectText(1,len(This.Text))
end event

event modified;
String	lsText, lsFind
Long	i


lsText = This.Text

If lsText = "" Then Return

lsFind = "Upper(Sku) = '" + Upper(lsText) + "'" 

If isNumber(lsText) Then
	lsFind += " or part_upc_Code = " + Trim(lsText) 
End If

If idw_Detail.Find(lsFind,1,idw_Detail.RowCount()) > 0 Then
	
	This.backcolor = rgb(0,255,0)
	Timer(3)
		
Else
	
	Messagebox(is_title,'SKU/UPC Code not found on this order',Stopsign!)
	
End If

This.SetFocus()
This.SelectText(1,len(This.Text))
end event

type cb_ims_verify from commandbutton within tabpage_orderdetail
boolean visible = false
integer x = 2240
integer y = 16
integer width = 384
integer height = 84
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "IMS Verify..."
end type

event clicked;Integer	liRC

u_nvo_gm_ims	lu_ims

lu_ims = Create u_nvo_gm_ims

liRC = lu_ims.uf_verify_bom(iw_window, idw_Detail)

If liRC= 1 Then
	idw_main.SetITem(1,'User_Field1', String(Datetime(today(),Now()),'mm/dd/yyyy'))
	ib_changed = True
End IF
end event

type cb_iqc from commandbutton within tabpage_orderdetail
integer x = 1179
integer y = 12
integer width = 297
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&IQC"
end type

event clicked;str_parms	lstrparms

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = is_rono
//Temp! - is it always going to be only 1 Detail line? Use ilCurrPutawayRow?
lstrparms.Long_arg[3] = idw_Detail.GetItemNumber(1, "Line_Item_No")
lstrparms.String_arg[4] = idw_Detail.GetItemString(1, "SKU")
lstrparms.String_arg[5] = idw_Detail.GetItemString(1, "User_Field1")

//OpenWithparm(w_iqc,lstrparms)

OpenSheetWithParm(w_iqc, lStrparms, w_main, gi_menu_pos, Original!)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_insert from commandbutton within tabpage_orderdetail
integer x = 27
integer y = 16
integer width = 334
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;Long ll_rowNo, ll_Owner_ID
decimal ld_lineItem
string lsUF2, ls_Sub_Inventory_Type, ls_CustCode
idw_detail.SetFocus()

IF idw_main.AcceptText() = -1 Then Return

IF gs_project = "PANDORA" THEN
	//3/10 JAyres Check to see if the Sub Inventory Location is for an InActive Customer	
	If idw_main.RowCount() > 0 Then
		ls_Sub_Inventory_Type = idw_other.GetItemString( 1, "user_field2" )
		If IsNULL(ls_Sub_Inventory_Type) Then ls_Sub_Inventory_Type = ''
		IF ls_Sub_Inventory_Type = '' THEN
			MessageBox ("Error", "Must select Sub-Inventory Location.")
			tab_main.SelectTab(2) 
			idw_other.SetFocus()
			idw_other.SetColumn("user_field2")
			Return 
		end if
		SELECT Owner_ID INTO :ll_owner_id 
		FROM OWNER 
		WHERE 	Project_ID = "PANDORA" AND
					Owner_CD = :ls_Sub_Inventory_Type
		USING SQLCA;
		
		IF SQLCA.SQLCode = 100 THEN
			MessageBox ("Error", "Sub-Inventory Location ("+ls_Sub_Inventory_Type+") not found in Owner Table")
			tab_main.SelectTab(2) 
			idw_other.SetFocus()
			idw_other.SetColumn("user_field2")
			Return 
		ELSE
			ls_CustCode = ''
			SELECT	Cust_Code INTO :ls_CustCode FROM Customer
			WHERE 	Cust_Code = :ls_Sub_Inventory_Type AND Project_ID = 'PANDORA' and Customer_type = 'IN'
			USING 	SQLCA;
				
			If sqlca.SQlcode <> 0 and sqlca.SQlcode <> 100 then
				MessageBox ("DB Error", SQLCA.SQLErrText)
			End if
			If ISNull( ls_CustCode	) Then  ls_CustCode =''
			If ls_CustCode <> '' Then
				MessageBox (is_Title, "Sub Inventory Location Must be an Acitve Customer.")
				return 
			End If
     	End If
	End If
End If

If idw_detail.AcceptText() = -1 Then Return

// 09/00 PCONKL - supplier on header must be set before a detail row can be entered since it must default.
If isnull(idw_main.GetItemString(1,"supp_code")) Then
	messagebox(is_title,"Supplier Code must be entered before you can enter detail records!",StopSign!)
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	idw_main.SetColumn("supp_code")
	Return
End If

// 01/09 dts - For Pandora, UF2 must be entered so that we can set the Owner appropriately (based on Pandora's Oracle Sub-inventory Location)
//  -- 02/09 - SubInv.Loc is coming at the detail level on E-orders (so UF2 can be blank but we'll need to allow/force entry at the detail)...
if gs_project = 'PANDORA' then
		
	//If isnull(idw_other.GetItemString(1,"User_Field2")) or trim(idw_main.GetItemString(1,"User_Field2")) = '' Then
	lsUF2 = trim(idw_other.GetItemString(1,"User_Field2"))
	// 03/08/10 - If idw_main.GetItemNumber(1, "edi_batch_seq_no") > 0 and (isnull(lsUF2) or lsUF2 = '') Then
	If isnull(lsUF2) or lsUF2 = '' Then
		messagebox(is_title,"Sub-Inventory Location (Owner) must be entered before you can enter detail records!",StopSign!)
		tab_main.SelectTab(1) 
		idw_other.SetFocus()
		idw_other.SetColumn("user_field2")
		Return
	End If
	
	ll_rowNo = idw_detail.GetRow()

	If ll_rowNo > 0 Then
		//idw_detail.setcolumn('sku')
		ll_rowNo = idw_detail.InsertRow(ll_rowNo + 1)
		//idw_detail.ScrollToRow(ll_rowNo)
	Else
		ll_rowNo = idw_detail.InsertRow(0)
	End If
	
	idw_detail.SetTabOrder("c_owner_name",0)
	idw_detail.SetItem(ll_rowNo,"c_owner_name", lsUF2)
	
	decimal ld_owner_id
	
	SELECT owner_id INTO :ld_owner_id
		FROM owner WHERE owner_cd = :lsUF2 and project_id = 'PANDORA';
	
	if sqlca.sqlcode = 100 then
		
		MessageBox ("Error",  lsUF2 + " - Owner Not Found")

	else
	
		if sqlca.sqlcode < 0 then
	
			MessageBox ("DB Error", SQLCA.SQLErrText )
			
		else
			
			idw_detail.SetItem(ll_rowNo,"owner_id", ld_owner_id)	
			
		end if
		
	end if
		
	
	
	// KRZ Lock the currency in at USD.
	idw_other.SetItem(ll_rowNo,"user_field1", "USD")
	idw_other.SetTabOrder("user_field1",0)

Else 
	ll_rowNo = idw_detail.GetRow()

	If ll_rowNo > 0 Then
		//idw_detail.setcolumn('sku')
		ll_rowNo = idw_detail.InsertRow(ll_rowNo + 1)
		//idw_detail.ScrollToRow(ll_rowNo)
	Else
		ll_rowNo = idw_detail.InsertRow(0)
	End If
end if


//
// pvh - 01/23/06
//
// find the max item number, increment.
// using rowcount causes duplicates if prior rows are deleted and new rows are added at the end. 
//
int lineitemnumber
lineitemnumber = getMaxlineitemnumber( idw_detail, "line_item_no" )
lineitemnumber++
//
// 09/00 PCONKL - default supplier to supplier from Order Header
idw_detail.SetItem(ll_rowNo,"supp_code",idw_main.GetItemString(1,"supp_code"))
// pvh - 01/23/06
idw_detail.object.line_item_no[ ll_rowNo ] = lineItemNumber
//idw_detail.SetItem(ll_rowNo,"line_item_no",idw_detail.RowCount()) /* 08/01 PConkl - default line item to current Row*/
	ld_lineItem = idw_detail.GetItemNumber(ll_rowNo,"line_item_no")   							// GAP 12-02
//	idw_detail.SetItem(ll_rowNo,"user_line_item_no",string(ld_lineItem, '#####.#####'))  	// GAP 12-02
//TimA 10/11/11 Removed the period in the formating
	idw_detail.SetItem(ll_rowNo,"user_line_item_no",string(ld_lineItem, '##########')) 

idw_detail.SetFocus()
idw_detail.SetRow(ll_rowNo)
idw_Detail.ScrolltoRow(ll_rowNo)
idw_DEtail.SetColumn('SKU')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete from commandbutton within tabpage_orderdetail
integer x = 443
integer y = 16
integer width = 334
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;ib_changed = True

If idw_detail.GetRow() > 0 then
	idw_detail.DeleteRow(0)
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_list_sku from commandbutton within tabpage_orderdetail
boolean visible = false
integer x = 1723
integer y = 16
integer width = 334
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&List SKU"
end type

event clicked;// GAP05/03 - This DW lists all skus for the supp code indicated within the dw_main....
// It allows the user to enter qty by sku and automatically generate/create a order detail line items when the qty > 0.

Long ll_row, ll_rowcount, ll_skurow, ll_owner
decimal ld_lineItem, ld_qty
string ls_sku,ls_alt_sku, ls_supp
ib_changed = True
ls_supp = idw_main.GetItemString(1,"supp_code")

If this.text = "&List SKU" then //GAP 6-03 LIST SKU by Supplier
	this.text = "&Generate"
	cb_delete.enabled = false
	cb_insert.enabled = false
	idw_list_sku.retrieve(gs_project, ls_supp) 
	idw_list_sku.visible= true 
	idw_detail.visible = false 
	
else 	
	this.text = "&List SKU" //GAP 6-03 GENERATE Order Detail Line Items
	idw_list_sku.visible = false 
	idw_detail.visible = true
	cb_delete.enabled = true
	cb_insert.enabled = true
	ll_rowcount = idw_list_sku.rowcount() 
	
	for  ll_skurow = 1 to ll_rowcount 
		ld_qty = idw_list_sku.GetItemNumber(ll_skurow,"req_qty") 
		
		if ld_qty > 0 then /*loop for each sku with qty > 0*/
	
			ll_row = idw_detail.GetRow()
			If ll_row > 0 Then
				ll_row = idw_detail.InsertRow(ll_row + 1)	
			Else
				ll_row = idw_detail.InsertRow(0)
			End If	

			// GAP05/03 - default supplier to supplier from Order Header, set Detail skus/qty using dw_list_sku
			idw_detail.SetItem(ll_row,"supp_code",ls_supp)
			idw_detail.SetItem(ll_row,"line_item_no",idw_detail.RowCount()) /* default line item to current Row*/
			ld_lineItem = idw_detail.GetItemNumber(ll_row,"line_item_no")   							
			//idw_detail.SetItem(ll_row,"user_line_item_no",string(ld_lineItem, '#####.#####'))  
			//TimA 10/11/11 Remove the period in the formating
			idw_detail.SetItem(ll_row,"user_line_item_no",string(ld_lineItem, '##########'))  			
			ls_sku = idw_list_sku.GetItemString(ll_skurow,"sku")
			ls_alt_sku = idw_list_sku.GetItemString(ll_skurow,"alternate_sku")
			idw_detail.SetItem(ll_row,"sku",ls_sku ) 		// GAP 6-03 Set ALT SKU  = SKU  when blank.
			if isnull(ls_alt_sku) or  ls_alt_sku = "" then 
				idw_detail.SetItem(ll_row,"alternate_sku",ls_sku)
			else				
				idw_detail.SetItem(ll_row,"alternate_sku",ls_alt_sku)
			end if
			idw_detail.SetItem(ll_row,"req_qty",ld_qty )
			ll_owner = idw_list_sku.GetItemNumber(ll_skurow,"owner_id")
			//GAP 6-03 load owner name
			idw_detail.SetItem(ll_row,"owner_id",ll_owner )			
			idw_detail.SetItem(ll_row,"c_owner_name",f_get_owner_name(ll_owner))				
			idw_detail.SetItem(ll_row,"uom",idw_list_sku.GetItemString(ll_skurow,"uom_1") )
			idw_detail.SetItem(ll_row,"country_of_origin",idw_list_sku.GetItemString(ll_skurow,"country_of_origin_default") )	
			//	idw_detail.SetItem(row, "cost", ld_cost)
	 	end if	
	next	

	// Set Focus ****
	idw_detail.Sort() 
	idw_detail.SetFocus() 
	idw_detail.SetRow(1)
	idw_Detail.ScrolltoRow(1)
	idw_Detail.SetColumn('SKU')
	// end of Set Focus ****	
	
End If
end event

type dw_detail from u_dw_ancestor within tabpage_orderdetail
event ue_set_column ( )
event ue_hide_unused ( )
string tag = "microhelp"
integer x = 32
integer y = 124
integer width = 3744
integer height = 1556
integer taborder = 20
string dataobject = "d_ro_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_set_column;This.SetColumn(isSetColumn)
end event

event ue_hide_unused();//Cost and Amount 
////TAM 2011/02 - W&S Wine and spirit Hides amount field and makes cost wider shows if value
	If Left(Upper(gs_Project),3) = 'WS-'  Then
		This.Modify("cost.width=439 cost_t.width=439")
		This.Modify("amount.width=0 t_4.width=0")
	End If

If Upper(gs_project) <> 'PANDORA' Then
	This.Modify("country_of_origin.width=0 country_of_origin_t.width=0")
	This.Modify("shipment_distribution_no.width=0 shipment_distribution_t.width=0")
	This.Modify("need_by_date.width=0 need_by_date_t.width=0")
	If Upper(gs_project) <> 'METRO' Then
		This.Modify("cust_line_no.width=0 cust_line_no_t.width=0")
	End If
End If
end event

event constructor;call super::constructor;// KRZ if this project is not pandora,
If lower(gs_project) <> "pandora" then
	// Set the decription column width to 0
	object.description_1.width = 0
End If

If g.is_owner_ind  <> 'Y' Then
	this.Modify("c_owner_name.visible=0")
End If

//12/02 - PCONKL - Only Show User Line Item for Pulse (and Pandora)
//05-Dec-2018 :Madhu S26847 User_Line_Item_No is visible for RVS
If upper(gs_project) <> 'PULSE' and upper(gs_project) <> 'PANDORA'  and upper(gs_project) <> 'RIVERBED' Then
	// This.Modify("user_line_item_no.width=0 user_line_Item_No_t.width=0")
	This.Modify("user_line_item_no.visible=0 user_line_Item_No_t.visible=0")
End If

//21-Jan-2019 :Madhu S28291 -Philips-TH SAP Inv Types
If upper(gs_project) ='PHILIPS-TH' THEN this.modify("user_field4.protect =1")

// TAM W&S -  Make User field2 a DDDW for UOM

if Left(gs_project,3) = "WS-" then
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.name='dddw_item_uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.displaycolumn='uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.datacolumn='uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.useasborder='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.allowedit='no'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.vscrollbar='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.width="200"
	 tab_main.tabpage_orderdetail.dw_detail.object.user_field2.dddw.percentwidth="200"         
	 tab_main.tabpage_orderdetail.dw_detail.GetChild("user_field2", idwc_detail_uf2)
	 idwc_detail_uf2.SetTransObject(SQLCA)
Else
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.name='dddw_item_uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.displaycolumn='uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.datacolumn='uom'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.useasborder='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.allowedit='no'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.vscrollbar='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.width="200"
	 tab_main.tabpage_orderdetail.dw_detail.object.uom.dddw.percentwidth="200"         
	 tab_main.tabpage_orderdetail.dw_detail.GetChild("uom", idwc_uom)
	 idwc_uom.SetTransObject(SQLCA)	
	 
End If

if Left(gs_project,3) = "MET" then

	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.name='dddw_currency'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.displaycolumn='country_currency_code'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.datacolumn='country_currency_code'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.useasborder='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.allowedit='no'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.vscrollbar='yes'
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.width="300"
	 tab_main.tabpage_orderdetail.dw_detail.object.currency_code.dddw.percentwidth="300"         
	 tab_main.tabpage_orderdetail.dw_detail.GetChild("currency_code", idwc_currency)
	 idwc_currency.SetTransObject(SQLCA)

End If

// LTK 20150115  Moved this code down to use the project flag for qunatity decimals
//
//If upper(gs_project) = 'PANDORA' Then
//	//TimA 10/13/11 Pandora issue #288.  Don't allow decimal point in the req_qty field
//	This.object.req_qty.format= '#,###,###'	
//	This.object.req_qty.EditMask.Mask= '#,###,###'
//
//	This.object.compute_2.format= '#,###,###'
//
//End if

// LTK 20150115  Allow quantity decimals based on project flag
if g.iballowquantitydecimals then
	this.object.req_qty.EditMask.Mask= '#,###,###.#####'
	this.object.req_qty.format= '#,###,###.#####'	
	this.object.compute_2.format= '#,###,###.#####'
else
	this.object.req_qty.EditMask.Mask= '#,###,###'
	this.object.req_qty.format= '#,###,###'	
	this.object.compute_2.format= '#,###,###'
end if

// pvh - 08/08/05
this.SetRowFocusIndicator(Hand!)

end event

event itemchanged;String 	lsSupplier,	&
			lsSKU,		&
			lsMsg, ls_description
			
Decimal ld_cost
Long		llCount,	llFindRow
string		lsInactiveSKU

// TAM W&S 2010/12
String lsUOM1, lsUom2
Decimal ldqty1, ldqty2

//TimA 04/04/13 Pandora issue #560
String ls_IM_Coo
Boolean lbPandoraCooSearch

lbPandoraCooSearch = False

Str_parms	lStrparms

ib_changed = True

//03/06 - PCONKL - added support for multiple suppliers on Order

Choose Case dwo.name
//	case "country_of_origin"
//
//		long lltest
//String lstest
//lltest = idwc_IM_Coo_Detail.getrow( )
//idwc_IM_Coo_Detail.selectrow(lltest, True)
//
//idwc_IM_Coo_Detail.scrolltorow( lltest)
//
//lstest = idwc_IM_Coo_Detail.GetItemString(lltest,'Country_Of_Origin')
//		This.SetItem(row,"country_of_origin",lstest)
		
	Case "sku"
		
		//this.accepttext( ) //23-Jan-2015 :Madhu- Added to accept the SKU value
		// 09/00 PCONKL
		If isnull(data) or data = '' Then Return

		// dts 2010/07/05 - Not allowing to insert row for an 'Inactive' SKU (item_delete_ind = Y)
		lsSupplier = idw_main.GetItemString(1, 'supp_code')
		Select item_delete_ind Into :lsInactiveSKU
		FROM item_master
		Where project_id = :gs_project
		and supp_code = :lsSupplier
		and sku = :data;
		if lsInactiveSKU = 'Y' then
			messagebox("Inactive SKU", "SKU '" + data + "' is Inactive!  Can not receive an Inactive SKU!",StopSign!)
			return 1 //06-Oct-2015 :Madhu- changed Return value from 2 to 1 and added "Stopsign" to Msg box
		end if

		this.accepttext( ) //23-Jan-2015 :Madhu- Added to accept the SKU value
		
		// TAM 2010/02  - If Pandora Header User_Field6 = "RMA_SUPPL" Then we only allow SKU's ending in "-R"
		If gs_project = 'PANDORA' Then
//TAM 2010/06/03			If idw_main.GetITemString(1,'user_field6') = 'RMA_SUPPL' and Right(Trim(data),2) <> "-R"   Then
              // 6/14 -  removed space in 'MENLOCL ' If (idw_main.GetITemString(1,'user_field6') = 'RMA_SUPPL'  or idw_main.GetITemString(1,'user_field6') = 'MENLOCL ') and Right(Trim(data),2) <> "-R"   Then	
			If (idw_main.GetITemString(1,'user_field6') = 'RMA_SUPPL'  or idw_main.GetITemString(1,'user_field6') = 'MENLOCL') and Right(Trim(data),2) <> "-R"   Then	
				MessageBox(is_title, "This Order only allows -R GPNs.",StopSign!)
				return 1
			End If
		
//********************************
			//TimA Pandora Issue #560
			//Check if item_master has the records for entered sku	
			lbPandoraCooSearch = True
			ls_IM_Coo = i_nwarehouse.of_item_master_coo(gs_project,data,lsSupplier)
			If ls_IM_Coo = '' Then
				This.object.country_of_origin[row]=""
				lssku = data
					
				isSetColumn = 'country_of_origin'
				This.PostEvent("ue_set_column")
	
			else
				This.SetItem(row,"country_of_origin",ls_IM_Coo)
				
			End if

		End If
//**********************************

		//Check if item_master has the records for entered sku	
		llCount = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case llCount
				
			Case 1 /*only 1 supplier, Load*/
				
				//If allowing multiple suppliers, load, otherwise make sure it matches supplier on header
				If idw_main.GetITemString(1,'multiple_supplier_ind') <> 'Y' Then
					if Upper(idw_main.GetITemString(1,'supp_code')) <> Upper(i_nwarehouse.ids_sku.GetItemString(1,"supp_code")) Then
						MessageBox(is_title, "Invalid SKU for this Supplier, please re-enter!",StopSign!)
						return 1
					End If
				End If
				
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				lssku = data
				lsSupplier = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")
				goto pick_data
				
			Case is > 1 /*Supplier dropdown populated for current sku when focus received*/
				
				If  idw_main.GetITemString(1,'multiple_supplier_ind') <> 'Y' Then
					This.SetItem(row,"supp_code",idw_main.GetItemString(1,"supp_code"))
					lssku = data
					lsSupplier = idw_main.GetItemString(1,"supp_code")
					goto pick_data
				End If
				
				This.object.supp_code[row]=""
				lssku = data
				
				isSetColumn = 'supp_code'
				This.PostEvent("ue_set_column")
				
			Case Else			
				
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				return 1
				
		END Choose



	Case "alternate_sku" /*09/00 PCONKL - get Primary Sku from Alternate*/
	
		If isnull(data) or data = '' Then Return
	
		//There might be more than 1 primary SKU that matches this alt sku/supplier
		lsSupplier = idw_main.GetItemString(1,"supp_code")
		
		Select Count(*) into :llCount
		From Item_Master
		Where project_id = :gs_project and
				supp_code = :lsSupplier and
				alternate_sku = :data
		Using SQLCA;
	
		Choose Case llCount
			
			case 0 /*invalid*/
				MessageBox(is_title, "Invalid Alternate SKU, please re-enter!")
				Return 1
			Case 1 /*only one found, populate Primary SKU*/
			
				select sku into :lsSKU
				From Item_Master
				Where project_id = :gs_project and
						supp_code = :lsSupplier and
						alternate_sku = :data
				Using SQLCA;
				
				goto pick_data
				
			Case Else /*multiple Primary SKU's found, open selection Window*/
			
				lstrparms.String_arg[1] = 'A' /*searching by Alternate Sku*/
				lstrparms.String_arg[2] = data /*Alt Sku*/
				lStrparms.String_arg[3] = lsSupplier /*Supplier code*/
				OpenWithParm(w_select_sku_supplier,lstrparms)
				Lstrparms = message.PowerObjectParm
				If Not Lstrparms.cancelled Then
					
					This.SetItem(row,"sku",Lstrparms.String_arg[2])
					lsSKU = Lstrparms.String_arg[2]
					
					goto pick_data
					
				End If
			
			End Choose /*valid SKU*/
	
	Case	"supp_code"
		
		lssku = this.Getitemstring(row,"sku")
		lsSupplier = data
	 	goto pick_data
		 
	Case "line_item_no" //GAP 12-02  keep line items in sync.
		//TimA 10/06/11 Pandora issue #240.  don't allow periods, comas etc on user line number
		//Pass the string to verify each character.
		If  f_verify_if_numeric(data) = False then
			MessageBox(is_title, "Invalid Line Number.  Must be numeric and contain no Periods, Dashes, Coma's, Letters etc., please re-enter!")
			Return 1
		else
			This.SetItem(row,"user_line_item_no",data) 			
		End if

	Case "cost"
		// TAM 2006/06/15 Added a calculation for AMS-MUSER to populate user_field4 = Cost * Upcharge(Project User_field1)
		If gs_project = 'AMS-MUSER' Then
			if isnumber(g.isprojectuserfield1) and g.isprojectuserfield1 <> '0' then
				This.SetItem(row, "user_field4", string(dec(data) * dec(g.isprojectuserfield1),'#####.0000' ))
			Else 
				This.SetItem(row, "user_field4", string(dec(data),'#####.0000' ))
			End If		
		End If

// TAM W&S 2011/02/10 Cost  is CIF Total (Moved from Putaway Screen)
		IF Left(gs_Project,3) = 'WS-' Then
//UserField 7 can be entered after the putaway has been generated but we need to push the calcualtion down to the putaway rows if it has been changed.
			If is_bonded = 'Y' Then
				long ll_putrow, ll_ReqQTY 
				decimal ll_CIF,  ll_CIF_Tot
				integer li_PutIdx
				If idw_putaway.RowCount() > 0 then 
					ll_PutRow = idw_putaway.Find("Line_Item_No = " + string(This.GetItemNumber(row, "line_item_no")), 1, idw_putaway.RowCount())
					do while ll_PutRow > 0
						ll_ReqQTY = this.GetItemNumber(Row, "Req_Qty")
						if ll_ReqQTY > 0 Then
							ll_CIF_Tot = dec(data)
							ll_CIF = ll_CIF_Tot /ll_ReqQTY
							idw_putaway.SetItem(ll_putRow, 'PO_NO',string(ll_CIF,'#####0.0000'))	
						End If
						ll_PutRow++
						If ll_PutRow > idw_putaway.RowCount() Then
							ll_putrow=0						
						else
								ll_PutRow = idw_putaway.Find("Line_Item_No = " + string(This.GetItemNumber(row, "line_item_no")), ll_PutRow, idw_putaway.RowCount())
						end if
					loop
				End If
			End If
		End If


// TAM = W&S - 2010/01 For Wine and Spirit we are not entering the Quantity and Unit of Measure.   QTY is being Entered in User_Field1 and UOM is being entered in User_Field2
// We are then taking thos values and looking in the Item master to see which level the UOM is entered.  If User Field 2 = Item_master UOM2 we will calculate the QTY and UOM values.
//We want to convert the QTY and UOM to UOM1 equivelents
	Case "user_field1"
		//Jxlim 08/15/2012 Physio wanted user_field1 on receive_master be the same as user_field1.receive_detail as well.
		If Left(gs_project,6) = 'PHYSIO' Then
			idw_main.SetItem(1, "user_field1", data)
		End If
		
		If Left(gs_project,3) = 'WS-' Then
			if Not isnumber(data)  then
				MessageBox(is_title, "Only Numberic values allowed!")
				Return 1
			Else 
				lsUOM2 = this.Getitemstring(row,"user_field2")
				// If UF2 is blank. Skip the Calculation 
				If Not IsNull(lsUOM2) and lsUOM2 <> '' Then 
					lssku = this.Getitemstring(row,"sku")
					lsSupplier = idw_main.GetItemString(1,"supp_code")
					lsUOM2 = this.Getitemstring(row,"user_field2")
					ldqty2 = dec(data)

					select UOM_1, QTY_2  into :lsUom1, :ldqty1
					From Item_Master
					Where project_id = :gs_project and
						supp_code = :lsSupplier and
						sku = :lssku and 
						UOM_2 = :lsUOM2
					Using SQLCA;

					// If UOM2 record is not found then assume User Field entered is UOM1 othewise Calculate UOM1 and QTY1			
					If ldqty1 > 0 then
						This.SetItem(row, "req_qty", dec(data) * dec(ldqty1))
						This.SetItem(row, "UOM", lsUom1)
					Else
						This.SetItem(row, "req_qty", dec(data))
						This.SetItem(row, "UOM", lsUom2)
					end if
				End If
			End If
		End If

// TAM = W&S - 2010/01 For Wine and Spirit we are not entering the Quantity and Unit of Measure.   QTY is being Entered in User_Field1 and UOM is being entered in User_Field2
// We are then taking thos values and looking in the Item master to see which level the UOM is entered.  If User Field 2 = Item_master UOM2 we will calculate the QTY and UOM values.
//We want to convert the QTY and UOM to UOM1 equivelents
	Case "user_field2"
		If Left(gs_project,3) = 'WS-' Then
			if isnumber(this.GetitemString(row,"user_field1"))  then
				ldQTY2 = dec(this.GetitemString(row,"user_field1"))
				// If UF1 is blank. Skip the Calculation 
				If Not IsNull(ldQTY2)  Then 
					lssku = this.Getitemstring(row,"sku")
					lsSupplier = idw_main.GetItemString(1,"supp_code")
					lsUOM2 = data

					select UOM_1, QTY_2  into :lsUom1, :ldqty1
					From Item_Master
					Where project_id = :gs_project and
						supp_code = :lsSupplier and
						sku = :lssku and 
						UOM_2 = :lsUOM2
					Using SQLCA;

					// If UOM2 record is not found then assume User Field entered is UOM1 othewise Calculate UOM1 and QTY1			
					If ldqty1 > 0 then
						This.SetItem(row, "req_qty", ldQty2 * dec(ldqty1))
						This.SetItem(row, "UOM", lsUom1)
					Else
						This.SetItem(row, "req_qty", ldQty2)
						This.SetItem(row, "UOM", lsUom2)
					end if
				End If
			End If
		End If

Case 'user_line_item_no'
	//TimA 10/06/11 Pandora issue #240.  don't allow periods, comas etc on user line number
	If gs_project = 'PANDORA' Then
		//Pass the string to verify each character.
		If  f_verify_if_numeric(data) = False then
			MessageBox(is_title, "Invalid Line Number.  Must be numeric and contain no Periods, Dashes, Coma's, Letters etc., please re-enter!")
			Return 1
		End if
	end if

Case 'req_qty'
	
// LTK 20150115  Commented out block below because the projects now use a project level setting to allow/prevent decimals in quantity fields
//
//	//TimA 10/13/11 Pandora issue #288.  don't allow periods, comas etc on user line number
//	If gs_project = 'PANDORA' Then
//		//Pass the string to verify each character.
//		If  f_verify_if_numeric(data) = False then
//			MessageBox(is_title, "Invalid Quanitity.  Must be numeric and contain no Periods, Dashes, Coma's, Letters etc., please re-enter!")
//			Return 1
//		End if
//	end if

End Choose /*Changed Column*/

Return

pick_data:

//we may have more than 1 item row retrieved
llFindROw = i_nwarehouse.ids_sku.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Supp_code) = '" + Upper(lsSupplier) + "'",1, i_nwarehouse.ids_sku.rowCount())
If llFindRow < 1 Then
	
	llCount = i_nwarehouse.of_item_sku(gs_project,lsSKU)
	llFindROw = i_nwarehouse.ids_sku.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Supp_code) = '" + Upper(lsSupplier) + "'",1, i_nwarehouse.ids_sku.rowCount())
	
	If llFindRow < 1 Then
		MessageBox(is_title, "Invalid SKU/Supplier, please re-enter!",StopSign!)
	End If
	
	return 1
	
End If


//If IsNull(This.GetItemString(row, "alternate_sku")) Then
	// 05/00 PCONKL - use Alternate SKU if it exists
	If i_nwarehouse.ids_sku.GetITemString(llFindRow,'alternate_sku') > ' ' Then /*alt sku exists*/
		This.SetItem(row,"alternate_sku",i_nwarehouse.ids_sku.GetITemString(llFindRow,'alternate_sku'))
	Else
		This.SetItem(row,"alternate_sku",lsSKU) /*default to  Sku*/
	End If
//End If

This.SetItem(row, "uom", i_nwarehouse.ids_sku.GetITemString(llFindRow,'uom_1'))
This.SetItem(row, "cost", i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'std_cost'))
// TAM 2006/06/15 Added a calculation for AMS-MUSER to populate user_field4 = Cost * Upcharge(Project User_field1)
If gs_project = 'AMS-MUSER' Then
	if isnumber(g.isprojectuserfield1) and g.isprojectuserfield1 <> '0' then
		This.SetItem(row, "user_field4", string(i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'std_cost') * dec(g.isprojectuserfield1),'#####.0000' ))
	Else 
		This.SetItem(row, "user_field4", string(i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'std_cost'),'#####.0000'))
	End If
End If

If lbPandoraCooSearch = false	Then
This.SetItem(row, "country_of_origin", i_nwarehouse.ids_sku.GetITemString(llFindRow,'Country_of_Origin_default'))
End if
This.SetItem(row, "qa_check_ind", i_nwarehouse.ids_sku.GetITemString(llFindRow,'qa_check_ind'))
This.SetItem(row, "part_upc_Code",i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'part_upc_Code'))

	//load owner name
IF gs_project <> 'PANDORA' THEN	
	This.SetItem(row, "owner_id",i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'owner_id'))
	This.SetItem(row,"c_owner_name",f_get_owner_name(i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'owner_id')))
ELSE
	IF IsNull(This.GetItemNumber(row, "owner_id")) THEN
		This.SetItem(row, "owner_id",i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'owner_id'))
		This.SetItem(row,"c_owner_name",f_get_owner_name(i_nwarehouse.ids_sku.GetITemNumber(llFindRow,'owner_id')))
	END IF
END IF


// Set the description for this row.
f_setdetaildescription(row)
				
isSetColumn = 'req_qty'
This.PostEvent("ue_set_column")
end event

event itemerror;

Return 2
end event

event process_enter;IF This.GetColumnName() = "user_field2" THEN
	IF This.GetRow() = This.RowCount() THEN
		tab_main.tabpage_orderdetail.cb_insert.TriggerEvent(Clicked!)
	Else
		Send(Handle(This),256,9,Long(0,0))
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

event retrieveend;call super::retrieveend;Long	llRowCount,	&
		llRowPos
		 
		 
//11/02 - PConkl - added Owner code to SQL, just format name instead of retrieving

// populate Owner Names
If g.is_owner_ind  = 'Y' Then /*only need to populate if showing */
	This.SetRedraw(False)
	llRowCOunt = This.RowCount()
	For llRowPos = 1 to llRowCount
		This.SetItem(llRowPos,"c_owner_name",This.GetITemString(llRowPos,'owner_cd') + '(' + This.GetITemString(llRowPos,'owner_type') + ')')
	next
	This.SetRedraw(True)
End If
/*
If upper(gs_project) = 'METRO' Then
	 idwc_currency.Retrieve(gs_project)
End If */
end event

event doubleclicked;call super::doubleclicked;
str_parms	lstrparms,lStrparms_1
String	lsFind, ls_WH_Code
Long	llFindRow,	&
		llOwnerHold,	&
		llRowPos,	&
		llRowCOunt

If Row > 0 Then

	Choose Case dwo.Name
		
		Case "c_owner_name"
						
			If Upper(idw_main.object.ord_status[1])	= 'C'  Then Return
			
			ls_WH_Code = idw_main.GetItemString(1, "wh_code")
			
			// 090909 - Can't change owner on detail for Pandora if it's electronic or a WH xfer
			if gs_project = 'PANDORA' and (Upper(idw_main.object.ord_type[1]) = 'Z' or idw_main.object.edi_batch_seq_no[1] > 0) then
				MessageBox('PANDORA', 'Not allowed to update Owner.')
			else
				OpenWithParm(w_select_owner, ls_WH_Code)
				lstrparms = Message.PowerObjectParm
				If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
					
					//07/02 - Pconkl - If checked, update all detail rows, otherwise just current
					If lstrparms.String_Arg[4] = 'Y' Then /*update all*/
					
						llRowCOunt = This.RowCOunt()
						For llRowPos = 1 to llRowCount
							This.SetItem(llRowpos,"owner_id",Lstrparms.Long_arg[1])
							This.SetITem(llrowpos,"c_owner_name",Lstrparms.String_arg[1])
						Next
						
						//Update all Putaway as well
						llRowCOunt = idw_Putaway.RowCount()
						For llRowPos = 1 to llRowCOunt
							idw_putaway.SetItem(llRowPos,"owner_id",Lstrparms.Long_arg[1])
							idw_putaway.SetITem(llRowPos,"c_owner_name",Lstrparms.String_arg[1])
						Next
						
					Else /* update current*/
						
						llOwnerHold = This.GetITemNumber(row,'owner_id')
						This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
						This.SetITem(row,"c_owner_name",Lstrparms.String_arg[1])
						
						//Owner Change needs to be reflected on current Putaway record as well
						lsFind = "sku = '" + This.GetItemString(row,"sku") + "' and owner_id = " + String(llOwnerHold) 
						llFindRow = idw_putaway.Find(lsFind,1,idw_putaway.RowCount())
						Do While llFindRow > 0
							idw_putaway.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
							idw_putaway.SetITem(llFindrow,"c_owner_name",Lstrparms.String_arg[1])
							llFindRow = idw_putaway.Find(lsFind,(llFindRow + 1),(idw_putaway.RowCount() + 1))
						Loop
					
					End If
					
					ib_changed = True
					
					
									
				End If /*owner selection not cancelled*/
			end if // Pandora...
			
	End Choose /*Clicked column*/
	
	// 07/19/2010 ujhall: 04 of 12 
	
	//SARUN2015NOV17 : On Double Click Calling Item Master

// TAM 05/2018 - S19728 - Google -  SIMS to provide access on doubleclick GPN from order detail for all users with view(Same as Item Maintenance Menu)
//	If f_check_access ("w_maintenance_itemmaster","") = 1 Then
	If f_check_access ("M_ITEM","") = 1 Then
		lStrparms_1.String_arg[1] = "ITEMMASTER"
		lStrparms_1.String_arg[2] =  this.GetItemString(row, 'sku')
		lStrparms_1.String_arg[3] =  this.GetItemString(row, 'supp_code')
		if isvalid(w_maintenance_itemmaster) then
			MessageBox(is_title,"Item Master is Already Open, First Close the existing window and then DoubleClick")
		else	
			OpenSheetwithparm(w_maintenance_itemmaster,lStrparms_1, w_main, gi_menu_pos, Original!)
		end if
	End If
	
	
END IF /*Valid Row*/





end event

event clicked;call super::clicked;if row > 0 then this.setrow( row )
end event

event itemfocuschanged;call super::itemfocuschanged;Long ll_ret

//If clicked on Supplier, populate for proper SKU/Supplier
Choose Case dwo.name
	Case 'supp_code'
		idwc_supplier.Retrieve(gs_project,This.GetITemString(row,'sku'))
		
// TAM W&S 2010/12 For Wine and spirit, Make UF2 a Droppdown		
	Case 'user_field2'
		If Left(gs_project,3) = 'WS-' Then
				idwc_detail_uf2.Retrieve(gs_project,This.GetITemString(row,'sku'),This.GetITemString(row,'supp_code'))
		End If
	Case 'country_of_origin'
		If gs_project = 'PANDORA' Then
				idwc_IM_Coo_Detail.Retrieve(gs_project,This.GetITemString(row,'sku'),This.GetITemString(row,'supp_code'))
		End If	
	Case 'uom'
		ll_ret = idwc_uom.Retrieve(gs_project,This.GetITemString(row,'sku'),This.GetITemString(row,'supp_code'))
		If ll_ret = 0 Then
			idwc_uom.insertRow(0)
			idwc_uom.setItem(1,"UOM","EA")		// Default to EA if no UOM in item master
		End If
end choose



end event

type dw_list_sku from datawindow within tabpage_orderdetail
boolean visible = false
integer x = 23
integer y = 124
integer width = 3456
integer height = 1540
integer taborder = 40
boolean titlebar = true
string title = "Select a SKU by entering an amount in ~"Req Qty~" field. (Click ~"Generate~" to return to Order Detail Screen)"
string dataobject = "d_ro_list_sku"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;this.accepttext()
end event

type tabpage_putaway from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3858
integer height = 1856
long backcolor = 79741120
string text = " Put Away List "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cbx_autofill cbx_autofill
dw_putaway_mobile dw_putaway_mobile
cb_emc cb_emc
cb_putaway_pallets cb_putaway_pallets
cb_print_cn cb_print_cn
cbx_show_comp cbx_show_comp
cb_generate cb_generate
cb_insertrow cb_insertrow
cb_deleterow cb_deleterow
cb_putaway_locs cb_putaway_locs
cb_copyrow cb_copyrow
cb_print cb_print
dw_print dw_print
dw_content dw_content
dw_carton_serial dw_carton_serial
dw_putaway dw_putaway
end type

on tabpage_putaway.create
this.cbx_autofill=create cbx_autofill
this.dw_putaway_mobile=create dw_putaway_mobile
this.cb_emc=create cb_emc
this.cb_putaway_pallets=create cb_putaway_pallets
this.cb_print_cn=create cb_print_cn
this.cbx_show_comp=create cbx_show_comp
this.cb_generate=create cb_generate
this.cb_insertrow=create cb_insertrow
this.cb_deleterow=create cb_deleterow
this.cb_putaway_locs=create cb_putaway_locs
this.cb_copyrow=create cb_copyrow
this.cb_print=create cb_print
this.dw_print=create dw_print
this.dw_content=create dw_content
this.dw_carton_serial=create dw_carton_serial
this.dw_putaway=create dw_putaway
this.Control[]={this.cbx_autofill,&
this.dw_putaway_mobile,&
this.cb_emc,&
this.cb_putaway_pallets,&
this.cb_print_cn,&
this.cbx_show_comp,&
this.cb_generate,&
this.cb_insertrow,&
this.cb_deleterow,&
this.cb_putaway_locs,&
this.cb_copyrow,&
this.cb_print,&
this.dw_print,&
this.dw_content,&
this.dw_carton_serial,&
this.dw_putaway}
end on

on tabpage_putaway.destroy
destroy(this.cbx_autofill)
destroy(this.dw_putaway_mobile)
destroy(this.cb_emc)
destroy(this.cb_putaway_pallets)
destroy(this.cb_print_cn)
destroy(this.cbx_show_comp)
destroy(this.cb_generate)
destroy(this.cb_insertrow)
destroy(this.cb_deleterow)
destroy(this.cb_putaway_locs)
destroy(this.cb_copyrow)
destroy(this.cb_print)
destroy(this.dw_print)
destroy(this.dw_content)
destroy(this.dw_carton_serial)
destroy(this.dw_putaway)
end on

type cbx_autofill from checkbox within tabpage_putaway
integer x = 2423
integer width = 343
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Autofill"
end type

event clicked;
//MikeA 3/20 - F21861  S43665 - Google BRD - SIMS - Inbound Putaway Autofill II


long ll_RowCount, ll_Idx


ll_RowCount = idw_putaway.RowCount()

//Reset all the check boxes if selected.

for ll_Idx = 1 to ll_RowCount
	if idw_putaway.GetItemString(ll_Idx, "c_autofill") = 'Y' then  idw_putaway.SetItem(ll_Idx, "c_autofill", 'N')
next

if this.checked = true then
//		idw_putaway.Object.c_autofill.Visible = true
		idw_putaway.Object.c_autofill.Protect = false
else
//	idw_putaway.Object.c_autofill.Visible = false
	idw_putaway.Object.c_autofill.Protect = true
end if

end event

type dw_putaway_mobile from u_dw_ancestor within tabpage_putaway
integer x = 32
integer y = 124
integer width = 3826
integer height = 176
integer taborder = 20
string dataobject = "d_ro_master_mobile"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;
DatawindowChild	ldwc

Choose case dwo.name
		
	Case "mobile_status_ind" /*filter to only show header level statuses*/
		
		This.GetChild('mobile_status_ind',ldwc)
		ldwc.SetFilter("mobile_status_ind <> 'N' and mobile_status_ind <> 'Z'  and mobile_status_ind <> 'I'  and mobile_status_ind <> 'B' and mobile_status_ind <> '1' ")
		ldwc.Filter()
	
	
		
End Choose
end event

event itemchanged;call super::itemchanged;DateTime	ldtGMT
String	lsRONO, lsFindStr, lsWarehouse,lsmobilepackloc,lsmobilescanreqind, lsAttributes, lsXml, lsXMLResponse, lsReturnCode, lsReturnDesc
Integer	i

lsRONO = idw_Main.GetITemString(1,'ro_no')
lsWarehouse = idw_Main.GetITemString(1,'wh_code')
ldtGMT = f_getLocalWorldTime( idw_main.object.wh_code[1] ) 

//ib_changed = true


Choose Case Upper(dwo.name)
		
//	Case "MOBILE_STATUS_IND"
//		
//		if ib_changed then
//			Messagebox(is_title,"Please save your changes before updating Mobile Status")
//			Return 1
//		End If
//		
//		If This.GetITEmString(1,'mobile_status_ind') = 'P' Then /* Currently in Process...*/
//	
//			If data = 'R' Then /* changing to Released - Can only do if all Items are in New Status*/
//				
//				If idw_pick.Find("Mobile_Status_Ind <> 'N'",1,idw_pick.RowCOunt()) > 0 Then
//					MessageBox(is_title,"Status cannot be changed to 'Released' unless all detail status are 'New'~rSet to 'Suspend' instead.",StopSign!)
//				Else
//					
//					//Update directly so Pick List no re-allocated
//					Execute Immediate "Begin Transaction" using SQLCA;
//			
//					Update Delivery_Picking
//					Set Mobile_status_Ind = 'N', mobile_picked_qty = 0, mobile_picked_by = '', mobile_pick_start_time = null, mobile_pick_Complete_time = null
//					Where do_no = :lsRONO;
//			
//					Update DElivery_MAster 
//					set mobile_Status_ind = 'R'
//					Where do_no = :lsRONO;
//					
//					Execute Immediate "Commit" using SQLCA;
//					
//				End If 
//				
//			ElseIf data = 'S' Then /* changing to Suspend */
//				
//				//Update directly so Pick List no re-allocated
//					Execute Immediate "Begin Transaction" using SQLCA;
//			
//					Update Delivery_Picking
//					Set Mobile_status_Ind = 'S'
//					Where do_no = :lsRONO;
//			
//					Update DElivery_MAster 
//					set mobile_Status_ind = 'S'
//					Where do_no = :lsRONO;
//					
//					Execute Immediate "Commit" using SQLCA;
//									
//			ElseIf data = 'C' Then /* changing to Complete - Can only do if no discprepency*/
//				
//				If idw_pick.Find("Mobile_Status_Ind = 'D'",1,idw_pick.RowCOunt()) > 0 Then
//					MessageBox(is_title,"Status cannot be changed to 'Complete' if there are items with discprepancies~rSet to 'Discrepancy' instead.",StopSign!)
//				Else
//					
//					Execute Immediate "Begin Transaction" using SQLCA;
//								
//					Update DElivery_MAster 
//					set mobile_Status_ind = 'C', mobile_pick_complete_time = :ldtGMT
//					Where do_no = :lsRONO;
//					
//					Execute Immediate "Commit" using SQLCA;
//					
//				End If
//				
//			ElseIf data = 'D' Then /* changing to Discprepancy - Can only do if  discprepency exist*/
//				
//				If idw_pick.Find("Mobile_Status_Ind = 'D'",1,idw_pick.RowCOunt()) = 0 Then
//					MessageBox(is_title,"Status cannot be changed to 'Discprenancy' if there are no items with discprepancies~rSet to 'Complete' instead.",StopSign!)
//				Else
//					
//					Execute Immediate "Begin Transaction" using SQLCA;
//								
//					Update DElivery_MAster 
//					set mobile_Status_ind = 'D', mobile_pick_complete_time = :ldtGMT
//					Where do_no = :lsRONO;
//					
//					Execute Immediate "Commit" using SQLCA;
//					
//				End If
//				
//			End If
//		
//		End If
		
	Case "MOBILE_ENABLED_IND"
		
		if ib_changed then
			Messagebox(is_title,"Please save your changes before releasing to Mobile")
			Return 1
		End If
		
		SetPointer(Hourglass!)
		
		//If checking, set status and dates, otherwise clear
		if Data = 'Y' Then /* checking*/
		
			//must generate Putaway List first
			If idw_Putaway.RowCount() = 0 Then
				Messagebox(is_title,"Putaway List must be generated  before releasing to Mobile")
				Return 1
			End If
			
			lsFindStr = "wh_code = '" + lsWarehouse + "'"
			i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())

			//18-JUNE-2018 :Madhu S20312 - Mobile Inbound Putaway
			If upper(gs_project)='PANDORA' Then
				If wf_putaway_release_mobile_validation() < 0 Then 
					this.Post Function SetItem(1, "mobile_enabled_ind", this.GetItemString(1,"mobile_enabled_ind", primary!, true))
					Return -1
				End If
			End If
			
			//Update Status on Picking without sending to Websphere
			Execute Immediate "Begin Transaction" using SQLCA;
			
			Update Receive_Master 
			Set Mobile_status_ind='R',Mobile_Enabled_Ind='Y', Mobile_Released_time=:ldtGMT
			where Project_Id=:gs_project 
			and Ro_No=:lsRONO;
						
			Update Receive_Putaway
			Set Mobile_status_Ind = 'N'
			Where ro_no = :lsRONO
			and (Content_Record_Created_Ind is null or Content_Record_Created_Ind <> 'Y');
			
			Execute Immediate "Commit" using SQLCA;
			
		Else /*unchecking*/
			
			SetNull(ldtGMT )
						
			Execute Immediate "Begin Transaction" using SQLCA;
						
			Update Receive_Master 
			Set Mobile_status_ind='',Mobile_Enabled_Ind='',Mobile_User_Assigned='',Mobile_Released_time=:ldtGMT,
			Mobile_Putaway_start_time=:ldtGMT,Mobile_Putaway_complete_time=:ldtGMT
			where Project_Id=:gs_project 
			and Ro_No=:lsRONO;
						
			Update Receive_Putaway
			Set Mobile_status_Ind = '',  mobile_putaway_by = '', mobile_putaway_start_time = null, mobile_putaway_Complete_time = null
			Where ro_no = :lsRONO;
			
			Execute Immediate "Commit" using SQLCA;
			
		End If
				
		idw_main.Retrieve( lsRONO) 
		idw_putaway.Retrieve(lsRONO, gs_project) 
//		if  Upper(gs_project) ="PANDORA" THEN 
//			f_crossdock() // Dinesh - 02/01/2021 - S52817- Google -SAP Conversion - GUI - set crossdock flag
//		end if
		wf_checkstatus()
		wf_check_status_mobile() 
		
		SetPointer(Arrow!)
		
	case "MOBILE_USER_ASSIGNED"
		
		If Data = "" Then Return
		
		If not isvalid(iuoWebsphere) Then
			iuoWebsphere = CREATE u_nvo_websphere_post
			linit = Create Inet
		End If

		//If a user is assigned, make sure it is a valid user
		lsAttributes = ' UserID = "' + data  + '"'
		lsXML = iuoWebsphere.uf_request_header("ValidateUserExistsRequest", lsAttributes)
		lsXML = iuoWebsphere.uf_request_footer(lsXML)

		w_main.Setmicrohelp("Validating User ID...")
		
		lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)
		
		w_main.Setmicrohelp("Ready")

		//If we didn't receive an XML back, there is a fatal exception error
		If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
			Messagebox("Websphere Fatal Exception Error","Unable to Validate User: ~r~r" + lsXMLResponse,StopSign!)
			Return 
		End If

		lsReturnCode = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
		lsReturnDesc = iuoWebsphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

		If lsReturnCode<> "0"  Then
			MessageBox("Assign User","Invalid User ID. Cannot assign to Putaway.",StopSign!)
			REturn 1
		End If
End Choose
end event

event itemerror;call super::itemerror;return 2
end event

type cb_emc from commandbutton within tabpage_putaway
integer x = 2679
integer y = 4
integer width = 178
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&EMC"
end type

event clicked;//MStuart babycare - emc functionality

str_parms	lstrparms
string ls_name

ls_name = iw_window.classname()

lstrparms.String_arg[1] = ls_name
lstrparms.String_arg[2] = tab_main.tabpage_main.sle_orderno.Text
lstrparms.String_arg[3] = is_rono

OpenWithParm(w_emc_capture, lStrparms)


end event

type cb_putaway_pallets from commandbutton within tabpage_putaway
integer x = 2359
integer y = 4
integer width = 297
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pallet"
end type

event clicked;str_parms	lstrparms

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = is_rono
//Temp! - is it always going to be only 1 Detail line? Use ilCurrPutawayRow?
lstrparms.Long_arg[3] = idw_Detail.GetItemNumber(1, "Line_Item_No")
lstrparms.String_arg[4] = idw_Detail.GetItemString(1, "SKU")
lstrparms.String_arg[5] = idw_Detail.GetItemString(1, "Supp_Code")

//OpenWithparm(w_putaway_pallets,lstrparms)

OpenSheetWithParm(w_putaway_pallets, lStrparms, w_main, gi_menu_pos, Original!)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_print_cn from commandbutton within tabpage_putaway
integer x = 1627
integer y = 12
integer width = 297
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print CN"
end type

event clicked;u_nvo_process_dn	lu_dn

lu_dn = Create u_nvo_process_dn

lu_dn.uf_process_return_note()
end event

event constructor;
g.of_check_label_button(this)
end event

type cbx_show_comp from checkbox within tabpage_putaway
integer x = 2875
integer width = 603
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Show Components"
end type

event clicked;wf_Set_comp_filter('Set')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_generate from commandbutton within tabpage_putaway
integer x = 18
integer y = 4
integer width = 297
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;long i_ndx, k_ndx,  llFindRow, ll_Component_cnt , ll_putaway_cnt, ll_groupend  //02/21/2011 ujh: I-135:
String lsFind   //02/21/2011 ujh: I-135:
boolean lbSerializedChild   //02/21/2011 ujh: I-135:
string ls_Get_sku

// pvh - 11/08/06 for Siemens
if Upper( gs_project ) = 'SIEMENS-LM' then
	iw_window.event ue_generate_putaway()
Elseif Upper( gs_project ) = 'LMC' then /* 01/09 - PCONKL - Putaway List generated generated by scanning items*/
	Open(w_putaway_scan)
elseif Upper (gs_project) = 'PHYSIO-MAA' or Upper(gs_project)='PHYSIO-XD' then /* hdc 10-05-2012 same as LMC only with the option to generate as well as scan */
	Open(w_physio_scan_or_generate)
	str_resp = Message.PowerObjectParm
	if str_resp.bok = false then //hdc 10-05-2012 user cancelled out of the box
		return
	elseif str_resp.action="generate" then //hdc standard putaway list generation
		iw_window.TriggerEvent("ue_generate_putaway_server") 
	else
		Open(w_putaway_scan)  //hdc 10/12/2012  Call physio specific scan parsing routine
	end if 
else	
	iw_window.TriggerEvent("ue_generate_putaway_server") /* 07/06 PCONKL - Putaway lists being generated on Websphere*/
end if

//Removed Issue 135 for now.  This is so we can get a new verion out
//TimA 03/24/11 Per Ian
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////From Source congtrol/////////////////////////////////////////////////////////////////
//02/21/2011 ujh: I-135:
/* This code expects sorted records where parents are followed immediately by children.  Apprently done on server */   
if upper(gs_project) = 'PANDORA' then
	 ll_putaway_cnt =  idw_putaway.Rowcount()
	For i_ndx = 1 to ll_putaway_cnt 
		ls_Get_sku = idw_putaway.GetItemString(i_ndx, 'sku')
		// Set to zero parts that are not components
		If idw_putaway.GetItemString(i_ndx, 'Component_ind') <> '*' then  // Set qty to zero
			idw_putaway.SetItem(i_ndx, 'quantity', 0)
			// If the part is a parent, remove its components
			If  upper(idw_putaway.GetItemString(i_ndx, 'Component_ind')) = 'Y' then  // remove components
				ll_Component_cnt  = 0
				// 02/21/201 ujh: i-135: Get the end of the group range for this parent and its components
				idw_putaway.SetRedraw(False)
				lsFind = "Component_ind <> '*' "
				ll_groupend = idw_putaway.Find(lsFind,(i_ndx + 1),idw_putaway.RowCount())
				// Find out if this parent has at least one serialized child
				lbSerializedChild = false
				if ll_groupend > i_ndx then
					For k_ndx = i_ndx +1 to ll_groupend
						if upper(idw_putaway.GetItemString(K_ndx, 'Serialized_ind')) = 'Y' &
							or upper(idw_putaway.GetItemString(K_ndx, 'Serialized_ind')) = 'B' &
							and idw_putaway.GetItemString(K_ndx, 'Component_ind') = '*'  Then
							lbSerializedChild = true
							exit
						end if
					next
				end if
//				if lbSerializedChild then  // Delete all children
					lsFind = "Line_Item_no = " + string(idw_putaway.GetItemNumber(i_ndx,"Line_Item_No")) + " and l_code = '" +  idw_putaway.GetItemString(i_ndx,"l_code") + "' and component_ind <> 'Y'"
	//				llFindRow = idw_putaway.Find(lsFind,(i_ndx + 1),idw_putaway.RowCount())
					llFindRow = idw_putaway.Find(lsFind,(i_ndx + 1),ll_groupend)
					// Are there any serialized children for this part?
					
					// Delete all components for this parent
					Do While llFindRow > 0
						idw_putaway.DeleteRow(llFindRow)
	//					llFindRow = idw_putaway.Find(lsFind,llFindRow,idw_putaway.RowCount())
						llFindRow = idw_putaway.Find(lsFind,llFindRow,ll_groupend)
						ll_Component_cnt ++
					Loop
//				end if
				idw_putaway.SetReDraw(True)
				ll_putaway_cnt = ll_putaway_cnt - ll_Component_cnt
			end if  // remove components
		end if   // End Set Qty to zero
	next
end if

//MStuart - BabyCare - 83011
If upper(gs_project) = 'BABYCARE' Then	
	wf_check_status_emc()
End If


////TimA 03/17/11 Pandora Enh #135
////This is a temporary solution to the problem of duplicate parents with children.
////This issue must be address at a later date
//if upper(gs_project) = 'PANDORA' then
//	string ls_sku
//	string ls_message
//	string ls_Duplicate_Sku
//	ll_putaway_cnt =  idw_putaway.Rowcount()
//	If ll_putaway_cnt > 1 then
//	For i_ndx = 1 to ll_putaway_cnt 
//		lsFind = "sku = " + "'" + string(idw_putaway.GetItemstring(i_ndx,"sku")) + "'"
//		If  upper(idw_putaway.GetItemString(i_ndx, 'Component_ind')) = 'Y' then
//			llFindRow = idw_putaway.Find(lsFind,(i_ndx + 1),idw_putaway.RowCount())
//			if llFindRow > 0 then
//				ls_Duplicate_Sku = ls_Duplicate_Sku + string(idw_putaway.GetItemstring(llFindRow,"sku")) + ", "
//			end if
//		End if
//	next
//	If ls_Duplicate_Sku <> "" then
//		ls_message = 'Parent parts of the same GPN cannot be saved into the same location on the same order. ~r~r' &
//		+ 'You must delete the duplicate parent so that there is only one remaining. ~r~r' &
//		+ 'The following are the parent duplicates: ~r~r' &
//		+ ls_duplicate_Sku
//		messagebox ("",ls_message)
//	end if	
//else
//	return 0
//end if
//end if
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// LTK 20111123	Pandora #334
if upper(gs_project) = 'PANDORA' then
	
	Long ll_rows, i
	String ls_sku_list
	
	ll_rows = idw_detail.RowCount()
	
	for i = 1 to ll_rows
		if idw_detail.Object.qa_Check_Ind[i] = 'P' then
			if Len(ls_sku_list) > 0 then
				if Pos(ls_sku_list,idw_detail.Object.sku[i]) = 0 then
					ls_sku_list += ", " + idw_detail.Object.sku[i]
				end if
			else
				ls_sku_list = idw_detail.Object.sku[i]
			end if
		end if
	next
	
	if Len(ls_sku_list) > 0 then
		MessageBox(is_title, &
			"The following GPN(s) are flagged to check for Defective Packaging.  If packaging is defective please contact your Local CSR: ~r~r~t" + ls_sku_list)
	end if

end if
// end of Pandora #334

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_insertrow from commandbutton within tabpage_putaway
integer x = 347
integer y = 4
integer width = 297
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;Long ll_row, ll_lineItem, ll_Owner_ID
decimal ld_lineItem
String	lsLoc, ls_rono, ls_wh, ls_CustCode, ls_Sub_Inventory_Type


IF gs_project = "PANDORA" THEN
	//3/10 JAyres Check to see if the Sub Inventory Location is for an InActive Customer	
	If idw_main.RowCount() > 0 Then
		ls_Sub_Inventory_Type = idw_other.GetItemString( 1, "user_field2" )
		
		If IsNULL(ls_Sub_Inventory_Type) Then ls_Sub_Inventory_Type = ''
		
		SELECT Owner_ID INTO :ll_owner_id 
		FROM OWNER 
		WHERE 	Project_ID = "PANDORA" AND
					Owner_CD = :ls_Sub_Inventory_Type
		USING SQLCA;
		
		IF SQLCA.SQLCode = 100 THEN
			MessageBox ("Error", "Sub-Inventory Location ("+ls_Sub_Inventory_Type+") not found in Owner Table")
			Return 
		ELSE
			ls_CustCode = ''
			SELECT	Cust_Code INTO :ls_CustCode FROM Customer
			WHERE 	Cust_Code = :ls_Sub_Inventory_Type AND Project_ID = 'PANDORA' and Customer_type = 'IN'
			USING 	SQLCA;
				
			If sqlca.SQlcode <> 0 and sqlca.SQlcode <> 100 then
				MessageBox ("DB Error", SQLCA.SQLErrText)
			End if
				
			If ISNull( ls_CustCode	) Then  ls_CustCode =''
			
			If ls_CustCode <> '' Then
				MessageBox (is_Title, "Sub-Inventory Location Must be an Active Customer.")
				return 
			End If
     	End If
	End If
End If

idw_putaway.SetFocus()

If idw_putaway.AcceptText() = -1 Then Return

ls_rono = idw_main.GetItemString(1, "ro_no")

ll_row = idw_putaway.InsertRow(0)

idw_putaway.setItem(ll_row,'l_code',lsLoc) /*set to empty to allow to be saved without location*/
//idw_putaway.SetItem(ll_row,"supp_code",idw_main.GetItemString(1,"supp_code")) /*supplier same for whole order*/
idw_putaway.SetItem(ll_row,"component_no",0) /* 06/01 PCONKL */
//
// pvh - 01/23/06
//
// find the max item number, increment.
// using rowcount causes duplicates if prior rows are deleted and new rows are added at the end. 
//
int lineitemnumber
lineitemnumber = getMaxlineitemnumber( idw_putaway, "line_item_no" )
lineitemnumber++
idw_putaway.object.line_item_no[ ll_row ] = lineitemnumber
//idw_putaway.SetItem(ll_row,'line_item_no',ll_row) /* 08/01 PCONKL*/
//ll_lineItem = idw_putaway.GetItemNumber(ll_row,"line_item_no")
//ld_lineItem = idw_putaway.GetItemNumber(ll_row,"line_item_no")		// GAP 12-02
idw_putaway.SetItem(ll_row,"user_line_item_no",string( lineItemNumber, '#####.#####'))
//idw_putaway.SetItem(ll_row,"user_line_item_no",string(ll_row, '#####.#####')) 		// GAP 12-02

/* GAP 6-03  GM_M only Create a Receipt #  in User_field1 for each line item - used in "gmm receive report" */
If Upper(Left(gs_Project,4)) = "GM_M" Then 
	idw_putaway.SetItem(ll_row,"user_field1", right(ls_rono,6) + string(ll_lineItem))
end if

// TAM 7-04  3COM_NASH Only 

If gs_Project = "3COM_NASH" Then 
	ls_wh = idw_main.GetItemString(1, "wh_code")
	// Default PO_NO2 (Used as "Bonded Indicator") with "N" unless Warehouse 3COM_NL. "Leaving it as "-" will force them to enter it. 
	If ls_wh <> "3COM-NL" Then
		idw_putaway.SetItem(ll_row,"PO_NO2", 'N')
	End If
	// Default LOT_NO  with "N/A" unless Warehouse 3COM_SIN. "Leaving it as "-" will force them to enter it. 
	If ls_wh <> "3COM-SIN" Then
		idw_putaway.SetItem(ll_row,"LOT_NO", 'N/A')
	End If
End If

//TAM W&S 2010/12
If Left(gs_Project,3) = "WS-" Then 
	If is_bonded = 'N' Then
			idw_putaway.SetItem(ll_row,"LOT_NO", 'DP')
			idw_putaway.SetTabOrder("lot_no", 0)
			idw_putaway.SetTabOrder("user_field1", 0)
			idw_putaway.SetItem(ll_row,"PO_NO", '0') //TAM W&S 5/18/2011 Default PONO to 0 for non bonded
	End If


End If

//MStuart - BabyCare - 83011		
If upper(gs_project) = 'BABYCARE' Then	
	wf_check_status_emc()
End If

idw_putaway.SetFocus()
idw_putaway.SetRow(ll_row)
idw_putaway.ScrollToRow(ll_row)
idw_putaway.setcolumn('sku')


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_deleterow from commandbutton within tabpage_putaway
integer x = 667
integer y = 4
integer width = 297
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;Long	 llRow, llFindRow, ll_line_item_no, ll_id_no
String	 lsFind, ls_order, ls_sku

If cbx_show_comp.Enabled and cbx_show_comp.Checked = False Then
	Messagebox(is_title,'You must show components before deleting rows.')
	Return
End If

ls_order = idw_main.GetItemString(1, "ro_no")
llRow = idw_putaway.GetRow()

IF  llRow > 0 THEN

	//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
	ls_sku = idw_putaway.getItemString( llRow, 'sku')
	ll_line_item_no = idw_putaway.getItemNumber( llRow, 'line_item_no')
	ll_id_no = idw_putaway.getItemNumber( llRow, 'id_no')
	//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END	
	
	//06/15 - PCONKL - Can't delete a row if the content has already been created or certain mobile statuses
	If idw_putaway.GetITemString(llRow,'Content_Record_Created_ind') = 'Y' Then
		MessageBox('Delete Row','Inventory has already been released for this Putaway Row.~rIt can not be deleted!',Stopsign!)
		Return
	End If
	
	If isnull(idw_putaway.GetITemString(llRow,'Mobile_status_Ind')) or idw_putaway.GetITemString(llRow,'Mobile_status_Ind') = '' or idw_putaway.GetITemString(llRow,'Mobile_status_Ind') = 'N'  Then
	else
		MessageBox('Delete Row','Record cannot be deleted for current Mobile Status',Stopsign!)
		Return
	End If
	
	ib_changed = True /* 06/15 - PCONKL - moved from above*/
	
	//TimA 02/12/14 added more Method Trace calls
	f_method_trace_special( gs_project,this.ClassName() + ' -cb_deleterow','Delete Putaway Row: ' + String(lLRow ) ,ls_order,' ',' ',is_suppinvoiceno )
	
	// pvh - 01/11/07 MARL
	doDeleteAdjustmentRow( string( idw_putaway.object.line_item_no[ llRow] ) , idw_putaway.object.sku[ llRow] )
	
	If idw_Putaway.GetItemString(llRow,"component_ind") = 'Y' Then /*if component, delete dependent rows as well*/
		idw_putaway.SetRedraw(False)
		lsFind = "sku_parent = '" + idw_Putaway.GetItemString(llRow,"sku_parent") + "' and component_no = " + string(idw_Putaway.GetItemNumber(llRow,"component_no"))
		idw_putaway.DeleteRow(llRow)

		//Delete any child dependent rows
		llFindRow = idw_putaway.Find(lsFind,1,idw_putaway.RowCount())
		Do While llFindRow > 0
			idw_putaway.DeleteRow(llFindRow)
			llFindRow = idw_putaway.Find(lsFind,1,(idw_putaway.RowCount() + 1))
		Loop
		
		idw_putaway.SetRedraw(True)
	elseIf idw_Putaway.GetItemString(llRow,"component_ind") = '*' Then 
		//Cant delete just the child
		Messagebox(is_title,'You can not delete a child component row.~rYou must delete the Parent.')
		Return
	else /*not a component, delete the current row only*/
	
		idw_putaway.DeleteRow(llRow)
	End If /*component or not*/
	
	//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
	//delete corresponding serial no records
	IF idw_rma_serial.rowcount( ) > 0 THEN
		lsFind ="sku ='"+ls_sku+"' and line_item_no="+string(ll_line_item_no)+" and id_no="+string(ll_id_no)
		llFindRow = idw_rma_serial.find( lsFind, 1, idw_rma_serial.rowcount())
		
		DO WHILE llFindRow > 0 
			idw_rma_serial.deleterow( llFindRow)
			llFindRow = idw_rma_serial.find( lsFind, 1, idw_rma_serial.rowcount()+1)
		LOOP
		
		idw_rma_serial.setredraw( true)
		
	END IF
	//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
	
	//MStuart - BabyCare - 83011		
	If upper(gs_project) = 'BABYCARE' Then	wf_check_status_emc()

END IF
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_putaway_locs from commandbutton within tabpage_putaway
integer x = 1947
integer y = 4
integer width = 389
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Putway Locs..."
end type

event clicked;str_parms	lstrparms
string ls_sub_inventory_loc

// 05/00 Pconkl -  pop putway recommendation window
// 11/02 - Changed QTY Parm to Decimal

// 12/12 - PCONKL - If cursor is not in a location field, we will make a Websphere call to assign locations for all rows based on the system generated Putaway Rules that are applied when a Putaway List is generated.
//							This will allow for a List to be manually created (scanning or manual entry) and then have locations appplied to that list.
//							If the cursor is in the Location field, the existing logic is applied to show the popup for manual location selection

 If	tab_main.tabpage_putaway.cb_putaway_locs.Text = "Assign Locs..." Then
	iw_Window.TriggerEvent('ue_assign_locations_server')
	REturn
End If 

// If cursor is on a location...


If idw_Putaway.RowCount() <= 0 or ilcurrputawayrow <= 0 Then REturn


// 02/21/2011 ujh: I-135   Must restore quantities that were zeroed out to restore things for original code.
IF gs_project = "PANDORA" THEN
	if not idw_putaway.GetItemNumber(ilcurrputawayrow, 'quantity') >  0 then
		messagebox('Quantity Error', 'Please enter quantity for row '+ string(ilcurrputawayrow,'0')+ ' before selecting a location.')
		return 
	end if
end if


/* Owner is coming in at the line level so not setting at the header via UF2
IF gs_project = "PANDORA" THEN
	ls_sub_inventory_loc = idw_other.GetItemString(1, "user_field2")
	IF IsNull(ls_sub_inventory_loc) OR trim(ls_sub_inventory_loc) = "" THEN
		MessageBox ("Error", "Must set Sub-Inventory Location before you can get put-away recomendations.")
		RETURN -1
	END IF
END IF
*/	

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = idw_main.GetItemString(1, "wh_code")
lstrparms.String_arg[3] = idw_putaway.getItemString(ilcurrputawayrow,"sku")
lstrparms.String_arg[4] = idw_putaway.GetITemString(ilcurrputawayrow,"l_code") /*if currently has location, recommendation will default to this*/
lstrparms.String_arg[5] = idw_putaway.GetITemString(ilcurrputawayrow,"ro_no") /*we will still show as available for this order*/
lstrparms.Decimal_arg[2] = idw_putaway.GetItemNumber(ilcurrputawayrow,"owner_id") /*pandora needs to filter by owner_id and Inventory Type*/
lstrparms.String_arg[6] = idw_putaway.GetItemString(ilcurrputawayrow,"inventory_type")
lstrparms.Decimal_arg[1] = idw_putaway.getItemNumber(ilcurrputawayrow,"quantity")
lstrparms.String_arg[7] = idw_putaway.GetItemString(ilcurrputawayrow,"po_no")				// LTK 20151214  Pandora #1002 SOC GPN with serial tracked
lstrparms.String_arg[8] = idw_putaway.GetItemString(ilcurrputawayrow,"serialized_ind")	// LTK 20151214  Pandora #1002 SOC GPN with serial tracked
lstrparms.String_arg[9] = idw_putaway.GetItemString(ilcurrputawayrow,"owner_cd")			// LTK 20151229  Pandora #1002 SOC GPN with serial tracked
lstrparms.String_arg[10] = idw_putaway.GetItemString(ilcurrputawayrow,"item_master_user_field18")			// LTK 20151229  Pandora #1002 SOC GPN with serial tracked


OpenWithparm(w_putaway_recommend,lstrparms)

idw_putaway.TriggerEvent("ue_process_putaway")

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_copyrow from commandbutton within tabpage_putaway
integer x = 987
integer y = 4
integer width = 297
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&opy Row"
end type

event clicked;
idw_Putaway.TriggerEvent("ue_Copy")

//MStuart - BabyCare - 83011		
If upper(gs_project) = 'BABYCARE' Then		
	wf_check_status_emc()
End If


end event

event constructor;
g.of_check_label_button(this)
end event

type cb_print from commandbutton within tabpage_putaway
integer x = 1307
integer y = 4
integer width = 297
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;w_ro.TriggerEvent("ue_print")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_print from datawindow within tabpage_putaway
boolean visible = false
integer x = 2574
integer y = 1020
integer width = 718
integer height = 460
integer taborder = 60
string dataobject = "d_putaway_prt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_content from u_dw_ancestor within tabpage_putaway
boolean visible = false
integer x = 3058
integer y = 1136
integer width = 434
integer height = 348
integer taborder = 50
string dataobject = "d_ro_content"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_carton_serial from datawindow within tabpage_putaway
boolean visible = false
integer x = 603
integer y = 1172
integer width = 690
integer height = 400
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_carton_serial_validate"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_putaway from u_dw_ancestor within tabpage_putaway
event ue_post_component ( )
event ue_process_putaway ( )
event ue_update_comp_qty ( )
event ue_hide_unused ( )
event ue_process_uom_conversion ( )
event ue_set_powerwave_flags ( )
event ue_set_gm_montry_flags ( )
event ue_scan_mode ( )
event ue_accepttext ( )
event ue_insert_components ( )
event ue_insert_components_populate_qty ( )
event ue_keystroke pbm_dwnkey
event ue_mouseclick pbm_rbuttondown
event ue_keyup pbm_keyup
string tag = "microhelp"
integer y = 316
integer width = 3433
integer height = 1540
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ro_putaway"
boolean minbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_post_component;This.SetRedraw(False)

wf_create_comp_child(ilComprow)

//This.Sort()
This.GroupCalc()

//Set back to Row
This.SetRow(ilCompRow)
This.ScrolltoRow(ilCompRow)

This.SetRedraw(True)


end event

event ue_process_putaway();// 05/00 Pconkl - process putaway requests from recommendation window
// 11/02 - PConkl - changed qty parm to decimal

Str_parms	lstrparms
Long			llFindRow,	&
				llArrayPos,	&
				llNewRow,	&
				llOwnerID,	&
				llCompNumber,	&
				llLineItem,	&
				llNextContainer
				
String		lsFind,	&
				lsSku,	&
				lsSupplier,	&
				lsLoc,	&
				lsCOO,	&
				lsOwner,	&
				lsInvType,	&
				lsNextContainer, lsLot, lsPO, lsPO2, lsDescription, &
				lsSerial_no, lsUser_field1, lsuser_field2, lsuser_field3, lsuser_field4, lsuser_field5, lsuser_field6, lsuser_field7, lsuser_field8, lsuser_field9, &
				lsuser_field10, lsuser_field11, lsuser_field12, lsuser_field13
				
Datetime     ldtExpDate				


This.SetRedraw(False)

//Parms returned rows of string for location and long for amt to putaway there!
lstrparms = Message.PowerobjectParm

Choose Case Upperbound(lstrparms.String_arg)
		
	Case 1 /* putting everything away in 1 location*/
		
		This.SetItem(ilcurrputawayrow,"l_code",lstrparms.String_arg[1])
		This.SetItem(ilcurrputawayrow,"quantity",lstrparms.decimal_arg[1])
		
		This.SetFocus()
		This.SetRow(ilcurrputawayrow)
		
		//If a component, copy location to dependent records
		If This.GetItemString(ilcurrputawayrow,"component_ind") = 'Y' Then
			//lsFind = "sku_parent = '" + This.GetItemString(ilcurrputawayrow,"sku_parent") + "' and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no"))
			//lsFind = "line_item_no = " + String(This.GetITemNumber(ilcurrputawayrow,'line_item_no'))
			lsFind = "line_item_no = " + String(This.GetITemNumber(ilcurrputawayrow,'line_item_no')) + " and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no"))
			llFindRow = This.Find(lsFind,ilcurrputawayrow,This.RowCount())
			lsLoc = This.GetItemString(ilcurrputawayrow,"l_code")
			Do While llFindRow > 0
				This.SetItem(llFindRow,"l_code",lsLoc)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/

		//F18447 - I2576 - Google - SIMS - Receiving Enhancement - DE13708

		if upper(gs_project) = 'PANDORA' then
		
			wf_autofill_putaway_container_pallet("l_code", ilcurrputawayrow, lstrparms.String_arg[1])
			
		end if
		
		
	Case 0 /*nothing entered*/
		
		This.SetFocus()
		This.SetRow(ilcurrputawayrow)
		
	Case Else /*more than 1 row*/
		
		//If more than 1 row, we will delete existing row for SKU and re-create
		
		lsSku = This.GetItemString(ilcurrputawayrow,"sku") /*current row we're processing*/
		lsSupplier = This.GetItemString(ilcurrputawayrow,"supp_code") /*current row we're processing*/
		lscoo = This.GetItemString(ilcurrputawayrow,"country_of_origin")
		lsowner = This.GetItemString(ilcurrputawayrow,"c_owner_name")
		lsInvType = This.GetItemString(ilcurrputawayrow,"inventory_Type")
		llownerid = This.GetItemNumber(ilcurrputawayrow,"owner_id")
		llCompnumber = This.GetItemNumber(ilcurrputawayrow,"component_no")
		llLineItem = This.GetItemNumber(ilcurrputawayrow,"line_item_no") /*08/01 PConkl*/
		lslot = This.GetItemString(ilcurrputawayrow,"lot_no")
		lspo = This.GetItemString(ilcurrputawayrow,"po_no")
		lspo2 = This.GetItemString(ilcurrputawayrow,"po_no2")
		ldtExpDate = This.GetItemDateTime(ilcurrputawayrow,"expiration_date")		
		lsdescription = This.GetItemString(ilcurrputawayrow,"description")
		//Jxlim 08/16/2012 Per code review, may as well added for the rest of the fields
		lsSerial_no = This.GetItemString(ilcurrputawayrow,"serial_no") 
		lsuser_field1 = This.GetItemString(ilcurrputawayrow,"user_field1") //Jxlim 08/15/2012 Physio	
		lsuser_field2 = This.GetItemString(ilcurrputawayrow,"user_field2") 
		lsuser_field3 = This.GetItemString(ilcurrputawayrow,"user_field3") 
		lsuser_field4 = This.GetItemString(ilcurrputawayrow,"user_field4") 
		lsuser_field5 = This.GetItemString(ilcurrputawayrow,"user_field5") 
		lsuser_field6 = This.GetItemString(ilcurrputawayrow,"user_field6") 
		lsuser_field7 = This.GetItemString(ilcurrputawayrow,"user_field7") 
		lsuser_field8 = This.GetItemString(ilcurrputawayrow,"user_field8") 
		lsuser_field9 = This.GetItemString(ilcurrputawayrow,"user_field9") 
		lsuser_field10 = This.GetItemString(ilcurrputawayrow,"user_field10") 
		lsuser_field11 = This.GetItemString(ilcurrputawayrow,"user_field11") 
		lsuser_field12 = This.GetItemString(ilcurrputawayrow,"user_field12") 
		lsuser_field13 = This.GetItemString(ilcurrputawayrow,"user_field13") 
		
		//Delete all rows for this sku/supplier/line item  09/00 pconkl - delete child component rows as well (sku_parent)
		llFindrow = 1
//		If llCompNumber > 0 Then
//			lsFind = "Upper(sku_parent) = '" + Upper(This.GetItemString(ilcurrputawayrow,"sku")) + "' and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no")) +  " and line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))/*sku from current putaway row*/
//		Else
//			lsFind = "Upper(sku_parent) = '" + Upper(This.GetItemString(ilcurrputawayrow,"sku"))  + "' and line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))
//		End If
		
		lsFind = "line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))
		If llCompNumber > 0 Then
			lsFind += + " and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no"))
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
			This.setitem(llnewRow,'ro_no', idw_main.GetItemString(1, "ro_no"))
			This.SetItem(llNewRow,"sku_parent",lsSku)
			This.SetItem(llNewRow,"sku",lsSku)
			This.SetItem(llNewRow,"supp_code",lsSupplier)
			This.SetItem(llNewRow,"owner_id",llOwnerID)
			This.SetItem(llNewRow,"component_no",llcompnumber)
			This.SetItem(llNewRow,"line_item_no",llLineItem) /*08/01 PConkl*/
			This.SetItem(llNewRow,"country_of_origin",lsCOO)
			This.SetItem(llNewRow,"c_owner_name",lsowner)
			This.SetItem(llNewRow,"l_code",lstrparms.String_arg[llArrayPos])
			This.SetItem(llNewRow,"quantity",lstrparms.decimal_arg[llArrayPos])
			This.SetItem(llNewRow,"inventory_type", lsInvType)
			This.SetItem(llNewRow,"lot_no", lsLot)
			This.SetItem(llNewRow,"po_no", lspo)
			This.SetItem(llNewRow,"po_no2", lsPo2)
			This.SetItem(llNewRow,"expiration_date", ldtExpDate)				
			This.SetItem(llNewRow,"description", lsDescription)
			//Jxlim 08/16/2012 Per code review, may as well added for the rest of the fields
			This.SetItem(llNewRow,"serial_no", lsserial_no) 
			This.SetItem(llNewRow,"user_field1", lsuser_field1) //Jxlim 08/15/2012 Physio
			This.SetItem(llNewRow,"user_field2", lsuser_field2) 
			This.SetItem(llNewRow,"user_field3", lsuser_field3) 
			This.SetItem(llNewRow,"user_field4", lsuser_field4) 
			This.SetItem(llNewRow,"user_field5", lsuser_field5) 
			This.SetItem(llNewRow,"user_field6", lsuser_field6) 
			This.SetItem(llNewRow,"user_field7", lsuser_field7) 
			This.SetItem(llNewRow,"user_field8", lsuser_field8) 
			This.SetItem(llNewRow,"user_field9", lsuser_field9)
			This.SetItem(llNewRow,"user_field10", lsuser_field10) 
			This.SetItem(llNewRow,"user_field11", lsuser_field11) 
			This.SetItem(llNewRow,"user_field12", lsuser_field12) 
			This.SetItem(llNewRow,"user_field13", lsuser_field13) 
			
			
			IF i_nwarehouse.of_item_master(gs_project,lsSku,lsSupplier,idw_putaway,llNewRow) < 1 THEN
	//			 Messagebox("","Could not retrieve item master values")
			END IF				
			
			If THis.GetITemString(llNewRow,'component_ind') = 'Y' Then
				//Build Child Records
				wf_create_comp_child(llNewRow)
			//	llCompNumber ++ 
			End If
			
			// 12/02 - PConkl - If Tracking by Container ID, set to Next
			If This.GetItemString(llNewrow,'container_tracking_Ind') = 'Y' Then
				llNextContainer = This.RowCount()
				lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')  /*start off with using the rowcount */
				//If found, keep bumping until no longer present
				llFindRow = This.Find("Container_ID = '" + lsNextContainer + "'",1,This.RowCount())
				Do While llFindRow > 0
					llNextContainer ++
					lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')
					llFindRow = This.Find("Container_ID = '" + lsNextContainer + "'",1,This.RowCount())
				Loop
				This.SetITem(llNewrow,'container_id',lsNextContainer)
			End If /*Container Tracked */
			
		Next
	
		This.Sort()
		This.groupCalc()
		This.SetFocus()
//		This.SetRow(llNewRow)
//		This.ScrollToRow(llNewRow)

		// 08/01 PCONKL - instead of scrolling to new row, scroll to the row that was origianlly processed. 
		llFindRow = This.Find(lsFind,0,This.RowCount())
		If llFindRow > 0 Then
			This.SetRow(llFindRow)
			This.ScrolltoRow(llFindRow)
		End If
		
End Choose

ib_changed = True

This.SetRedraw(True)

This.AcceptText()




end event

event ue_update_comp_qty;String	lsFind
Long	llFindRow,	&
		llRow
		
llRow = This.GetRow()

This.SetRedraw(False)

// 09/02 - PCONKL - DElete all of the children (the rest of this line item) and rebuild from scratch - only way to ensure that child qtys are set properly
lsFind = "Line_Item_no = " + string(This.GetItemNumber(llrow,"Line_Item_No")) + " and l_code = '" +  This.GetItemString(llrow,"l_code") + "' and component_ind <> 'Y'"
llFindRow = This.Find(lsFind,(llrow + 1),This.RowCount())
Do While llFindRow > 0
	This.DeleteRow(llFindRow)
	llFindRow = This.Find(lsFind,llFindRow,This.RowCount())
Loop
	
wf_create_comp_child(llrow) /*rebuild all the children (and grand children, etc.) */
	
This.SetReDraw(True)
end event

event ue_hide_unused();
String ls_syntax, lsModify
Long ll_FoundRowCustomColumn
//TimA 01/15/14
//Pandora issue #693.  Use the Custom_DataWindow to set the column witdhs
IF g.ids_Custom_dw.Rowcount() > 0 THEN
	ll_FoundRowCustomColumn = 1
	ls_syntax=  "Datawindow = '"+ string(This.DataObject) + "'"
	ll_FoundRowCustomColumn = g.ids_Custom_dw.Find(ls_syntax,	ll_FoundRowCustomColumn, g.ids_Custom_dw.RowCount()) 				
End if

// 10/02 - Pconkl - Hide Serial, Lot, etc if not used anywhere

//Serial
//If This.Find("serialized_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
/* CR03 If This.Find("serialized_Ind = 'Y' or serialized_ind = 'B'",1,This.RowCOunt()) > 0 Then /* 02/09 - PCONKL - Serialized_ind = B - capturing at IB/OB but not writing to Content*/ CR03 */
If This.Find("serial_no <> '-' or serialized_Ind = 'Y' or serialized_ind = 'B'",1,This.RowCOunt()) > 0 Then /* 02/09 - PCONKL - Serialized_ind = B - capturing at IB/OB but not writing to Content*/
	//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
	If ll_FoundRowCustomColumn  > 0 then
		lsModify = uf_get_custom_column_setting(This,'serial_no',ll_FoundRowCustomColumn)
		This.Modify(lsModify)
	Else
		This.Modify("serial_no.width=600 serial_no_t.width=600")
	End if
Else /*Hide*/
	This.Modify("serial_no.width=0 serial_no_t.width=0")
End If

//Lot
If This.Find("lot_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
	If ll_FoundRowCustomColumn  > 0 then
		lsModify = uf_get_custom_column_setting(This,'lot_no',ll_FoundRowCustomColumn)
		This.Modify(lsModify)
	Else
		This.Modify("lot_no.width=786 lot_no_t.width=786")
	End if
Else /*Hide*/
	This.Modify("lot_no.width=0 lot_no_t.width=0")
////TAM 2009/08/06 Lot - Pandora shows if value
	If Upper(gs_Project) = 'PANDORA' and This.Find("lot_no <> '-'",1,This.RowCOunt()) > 0 Then
		//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
		If ll_FoundRowCustomColumn  > 0 then
			lsModify = uf_get_custom_column_setting(This,'lot_no',ll_FoundRowCustomColumn)
			This.Modify(lsModify)
		Else
			This.Modify("lot_no.width=786 lot_no_t.width=786")
		End if
	End If
End If

//PO NO
If This.Find("po_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
	If ll_FoundRowCustomColumn  > 0 then
		lsModify = uf_get_custom_column_setting(This,'po_no',ll_FoundRowCustomColumn)
		This.Modify(lsModify)
	Else
		This.Modify("po_no.width=600 po_no_t.width=600")
	End if
Else /*Hide*/
	This.Modify("po_no.width=0 po_no_t.width=0")
End If

//PO NO 2
If This.Find("po_no2_controlled_Ind = 'Y' or foot_prints_ind = 'Y'",1,This.RowCOunt()) > 0 Then
	//TimA 01/15/14 If the column is found in the Custom_Datawindow_Detail table then use that column width
	If ll_FoundRowCustomColumn  > 0 then
		lsModify = uf_get_custom_column_setting(This,'po_no2',ll_FoundRowCustomColumn)
		This.Modify(lsModify)
	Else
		This.Modify("po_no2.width=600 po_no2_t.width=600")
	End if
Else /*Hide*/
	This.Modify("po_no2.width=0 po_no2_t.width=0")
End If

//Container ID - Also hide Dimensions if not tracking by Container ID
// GailM 8/18/2014 Pandora Issue 883 - Deja Vu to scan containerID
If This.Find("container_tracking_Ind = 'Y'",1,This.RowCOunt()) > 0 Then

	IF Upper(gs_project) = 'PULSE' THEN /* Modified for Pulse */
		This.Modify("container_id.width=600 container_id_t.width=407 length.width=261 Width.width=261 Height.width=261 weight_Gross.width=261 c_weight_Net.width=261")
	ELSE
		//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
		If ll_FoundRowCustomColumn  > 0 then
			lsModify = uf_get_custom_column_setting(This,'container_id',ll_FoundRowCustomColumn)
			lsModify = lsModify + " length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0"
			This.Modify(lsModify)
		Else
			This.Modify("container_id.width=670 container_id_t.width=0 length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0")
		End if
	END IF
	
Else /*Hide*/
	This.Modify("container_id.width=0 container_Id_t.width=0 length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0 ")
	//TAM 2009/08/12 Container ID - Pandora shows if value
//	If Upper(gs_Project) = 'PANDORA' and (This.Find("container_id <> '-'",1,This.RowCOunt()) > 0 or ibDejaVu) Then
	If Upper(gs_Project) = 'PANDORA' and (This.Find("container_id <> '-' or container_id <> ''",1,This.RowCOunt()) > 0 or ibDejaVu) Then	//OCT 2019 - MikeA - DE12998	
		//TimA 01/15/14 If the column is found in the Custom_Datawindow_Detail table then use that column width
		If ll_FoundRowCustomColumn  > 0 then
			lsModify = uf_get_custom_column_setting(This,'container_id',ll_FoundRowCustomColumn)
			lsModify = lsModify + " length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0"
			This.Modify(lsModify)
		Else
			If ibDejaVu Then
				This.Modify("container_id.width=670 container_id_t.width=0 length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0")
			Else
				This.Modify("container_id.width=288 container_id_t.width=0 length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0")
			End If
End if	
	Else
		This.Modify("container_id_t.width=0 length.width=0 Width.width=0 Height.width=0 weight_Gross.width=0 c_weight_Net.width=0")
	End If
End If

//Expiration Date
If This.Find("expiration_controlled_Ind = 'Y'",1,This.RowCOunt()) > 0 Then
	//TimA 01/15/14 If the column is cound in the Custom_Datawindow_Detail table then use that column width
	If ll_FoundRowCustomColumn  > 0 then
		lsModify = uf_get_custom_column_setting(This,'expiration_date',ll_FoundRowCustomColumn)
		This.Modify(lsModify)
	Else
		This.Modify("expiration_date.width=600 expiration_date_t.width=600")
	End if
Else /*Hide*/
	This.Modify("expiration_date.width=0 expiration_date_t.width=0")
End If
end event

event ue_process_uom_conversion;Long	llEdiBatchSeq, llLineItem, llFindRow
String	lsSKU, lsUSer1, lsPOUOM, lsStockUOM
Decimal {5}	ldConvFactor, ldReqQty
Str_parms	lstrparms

SetPointer(Hourglass!)


//We will only have a conversion factor if the order was received electronically
If idw_main.GetITemNumber(1,'edi_batch_seq_no') > 0 Then
			
	//Get the Conversion factor from the EDI Inbound Detail Record for this line item - QTY/UOM are concatonated in User Field 1
	llEdiBatchSeq = idw_main.GetITemNumber(1,'edi_batch_seq_no')
	llLineItem = This.getITemNumber(getclickedrow(),'line_item_no')
	lsSKU = This.GetITemString(getclickedrow(),'sku')
				
	Select Max(User_field1), max(uom_conversion_factor)
	Into	:lsUser1, :ldConvFactor
	From edi_inbound_detail
	Where Project_id = :gs_Project and edi_batch_seq_no = :llEdiBatchSeq and Line_item_no = :llLineItem and Sku = :lsSKU
	Using Sqlca;
	
	If ldConvFactor = 1 Then
		
		Messagebox(is_title,'The PO UOM is the same as the Stock UOM for this Line Item.')
		
	ElseIf ldConvFactor > 0 Then
		
		//Break out UOM from USer 1
		//ldConvFactor = Dec(Left(lsUser1,(Pos(lsUser1,'/') - 1)))
		lsPOUOM = Right(lsUser1,(len(lsUser1) - Pos(lsUser1,'/')))
				
		//Get the Req Qty from the Order Detail row
		llFindRow = idw_detail.Find("line_item_no = " + String(llLineItem) + " and sku = '" + lsSKU + "'",1,idw_detail.RowCount())
		If llFindROw > 0 Then
			lstrParms.Decimal_arg[2] = idw_detail.GetITemNumber(llFindRow,'req_qty')
			lstrParms.String_arg[2] = idw_detail.GetITemString(llFindRow,'uom')
		Else
			lstrparms.Decimal_arg[2] = 0
			lstrparms.String_arg[2] = 'EA'
		End If
		
		lstrparms.String_arg[1] = lsPOUOM
		lstrparms.Decimal_arg[1] = ldConvFactor
		lstrparms.Decimal_arg[3] = This.GetITemNumber(getclickedrow(),'quantity')
		OpenWithParm(w_pulse_putaway_uom,lstrparms)
		
		//Update Stock Quantity if entered (not cancelled)
		Lstrparms = Message.PowerobjectParm
		If Not lstrparms.Cancelled Then
			This.SetITem(getClickedRow(),'Quantity',lstrparms.Decimal_arg[1])
			ib_changed = True
		End If
		
	Else
		Messagebox(is_title,'There is no UOM conversion for this Line Item.')
	End If
			
Else /*not received electronically*/
					
	Messagebox(is_title,'This order was not received electronically.~rThere is no UOM conversion')
				
End If  /*received electronically*/

Setpointer(Arrow!)


end event

event ue_set_powerwave_flags();
Long	llRowPos, llRowCount


//09/06 - PCONKL - For Powerwave, For a PO (NOt an IR) If we have any Outbound Serial flags, flip them to scan at Inbound (We want to capture for GR but we won't write to Content)
//						For an IR, we always want to track Lot (LPN)
// 12/07 - PCONKL - Added ORder TYpes Move ('O') and DSDF Wuxi ('D') to support Suzhou warehouse

llRowCount = idw_Putaway.RowCount()

Choose Case Upper(idw_Main.GetItemString(1,'ord_type'))


	Case 'P' /* PO */
	
		For llRowPOs = 1 to llRowCount
		
			If idw_putaway.GetITemString(llRowPos,'serialized_ind') = 'O' Then /*Outbound*/
				idw_putaway.SetITem(llRowPos,'serialized_ind','Y') /*Inbound*/
			End If
		
			idw_putaway.SetITem(llRowPos,'lot_controlled_Ind','N') /*not tracking Lot NUmbers (LPN) for PO's*/
			
		Next
		
	Case 'I'  /* IR */
			
		For llRowPos = 1 to llRowCount
			idw_putaway.SetItem(llRowPos,'lot_controlled_ind','Y')
		Next
	
	Case Else
	
		For llRowPos = 1 to llRowCount
			idw_putaway.SetItem(llRowPos,'lot_controlled_ind','N')
		Next
	
End Choose
end event

event ue_set_gm_montry_flags();Long	llRowPos, llRowCount




llRowCount = idw_Putaway.RowCount()

For llRowPOs = 1 to llRowCount
		
	idw_putaway.SetITem(llRowPos,'po_no',idw_main.GetITEmString(1,'supp_invoice_no'))
	idw_putaway.SetITem(llRowPos,'po_no2',idw_main.GetITEmString(1,'ship_ref'))
					
Next
		

		

end event

event ue_scan_mode();
//If one of the lottable fields is double clicked, we will enable a scan mode which will allow the users to scan down a column instead of across when enter is clicked

//Messagebox("Scan_Mode", This.getColumnName())

//messagebox("", string(object.lot_no_t.Background.Color))

// GailM - 8/18/2014 - Issue 883 - Deja Vu - requires scanning container IDs
//Turn off previous column heading and columns indicators
This.Modify("lot_no_t.Background.Color='67108864'")
This.Modify("po_no_t.Background.Color='67108864'")
This.Modify("po_no2_t.Background.Color='67108864'")
This.Modify("container_id_t.Background.Color='67108864'")

//This.Modify("lot_no_t.Background.Color='13882323'")
//This.Modify("po_no_t.Background.Color='13882323'")
//This.Modify("po_no2_t.Background.Color='13882323'")

// LTK 20111101	Use the stored expressions, as opposed to, hard coding.
//This.Modify("lot_no.Background.Color='16777215'")
This.Modify("lot_no.Background.Color=" + is_lot_no_init_bg_color)
//This.Modify("po_no.Background.Color='16777215'")
This.Modify("po_no.Background.Color=" + is_po_no_init_bg_color)
//This.Modify("po_no2.Background.Color='16777215'")
This.Modify("po_no2.Background.Color=" + is_po_no2_init_bg_color)

This.Modify("container_id.Background.Color=" + is_container_init_bg_color)

//If double clicking on current scan column, turn it off
If This.getColumnName() = isScanColumn Then
	isScanColumn = ""
Else
	isScanColumn = This.getColumnName()
End IF

//Set current scan column label
Choose case isScanColumn
		
	Case "lot_no"
		This.Modify("lot_no_t.Background.Color='13237437'")
		//This.Modify("lot_no.Background.Color='13237437'")
		// LTK 20111101	Use the stored expressions, as opposed to, hard coding.
		This.Modify("lot_no.Background.Color=" + is_lot_no_scan_bg_color)

	Case "po_no"
		This.Modify("po_no_t.Background.Color='13237437'")
		//This.Modify("po_no.Background.Color='13237437'")
		// LTK 20111101	Use the stored expressions, as opposed to, hard coding.
		This.Modify("po_no.Background.Color=" + is_po_no_scan_bg_color)

	Case "po_no2"
		This.Modify("po_no2_t.Background.Color='13237437'")
		//This.Modify("po_no2.Background.Color='13237437'")
		// LTK 20111101	Use the stored expressions, as opposed to, hard coding.
		This.Modify("po_no2.Background.Color=" + is_po_no2_scan_bg_color)		

	Case "container_id"
		This.Modify("container_id_t.Background.Color='13237437'")
		//This.Modify("po_no2.Background.Color='13237437'")
		// LTK 20111101	Use the stored expressions, as opposed to, hard coding.
		This.Modify("container_id.Background.Color=" + is_po_no2_scan_bg_color)		

End Choose
end event

event ue_accepttext();
// 06/28/2010 ujhall: 04 of 07: Validate Inbound Serial Numbers.   (Only doing AcceptText when dw_putaway loses focus otherwise problems)
If upper(gs_Project) = 'PANDORA' Then
	IF idw_putaway_has_focus = false THEN
	
			  idw_putaway.accepttext( )
	
	END IF
End if

end event

event ue_insert_components();
// 02/21/2011 ujh: I-135:
long ll_row
if ilComponenttInsertRow > 0 then
	ll_row = ilComponenttInsertRow
else
	ll_row = this.GetRow()
end if
This.SetRedraw(False)
// Insert components for the parent in this row
wf_create_comp_child(ll_row)

This.SetRedraw(true)
end event

event ue_insert_components_populate_qty();
long ll_row, ll_parent_qty, i_ndx
ll_row = this.GetRow()
ll_parent_qty = this.GetItemNumber(ll_row, 'quantity')
This.SetRedraw(False)
wf_create_comp_child(ll_row) //  row of the last child is placed in instance variable ilRowLastChild by wf_create_comp_child.
//For i_ndx = ll_row + 1 to ilRowLastchild
//	long ujhtest
//	string ujhstring
//	ujhtest = this.GetItemNumber(i_ndx, 'quantity')
//	ujhstring = this.GetItemString(i_ndx, 'sku')
//	this.SetItem(i_ndx, 'quantity', ll_parent_qty * this.GetItemNumber(i_ndx, 'quantity'))
//next
This.SetRedraw(true)
end event

event ue_keystroke;//TimA 03/16/11 make the enter key act like the down arrow key when on the quanity field
//  This is needed for faster data input when quanities are entered.
If gs_Project = 'PANDORA' then
	GraphicObject which_control
	CHOOSE CASE Key
		CASE KeyEnter!
			which_control = this //GetFocus()
				Choose Case which_control.ClassName()
					CASE "dw_putaway"
						IF which_control.FUNCTION DYNAMIC GetColumn() = 8 and ilErrorRow = 0  THEN // Quantity field
							send(Handle(this), 256,9, long(0,0))
							 This.ScrollToRow(This.GetRow() + 1)
							 This.SetColumn(7)
							Return
						ELSE
							ilErrorRow =  0		//Gailm - 3/27/2014 - On Error do not treat enter key as a down arrow.
						END IF
				End Choose
		CASE KeyShift!
			if this.GetRow() > 0 then
				ib_AutoFill_Shift_Select = true
				il_AutoFill_Start_Row = this.GetRow()
			end if
	END CHOOSE
	
	//17-Aug-2015 :Madhu- Added code to prevent manual scanning - START
	If gbPressKeySNScan ='Y' THEN
		CHOOSE CASE gs_role
			CASE '1','2'
				IF this.getcolumnname( )='serial_no' and  ibPressF10Unlock =FALSE THEN
					If ibkeytype =FALSE THEN
						timer(0.5)
						ibkeytype=TRUE
					END IF
				
					//Get Key Pressed
					IF (KeyDown(KeyShift!) and KeyDown(KeyInsert!)) or KeyDown(KeyControl!) THEN
						MessageBox("Manual Entry", "Control, Shift Key's are disabled!")
						this.setitem(idw_putaway.getrow(), 'serial_no', '-')
						ibkeytype =FALSE
					END IF
					
					CHOOSE CASE key
						CASE KeyEnter! //which calls process_enter again fall back to this event..so, don't call timer.
							timer(0)
							ibkeytype=TRUE
						CASE KeyUpArrow!,KeyDownArrow!,KeyLeftArrow!,KeyRightArrow!,KeyTab!
							timer(0)
							ibkeytype=FALSE
					END CHOOSE
				END IF
		END CHOOSE 
	END IF
	//17-Aug-2015 :Madhu- Added code to prevent manual scanning - END
End if
end event

event ue_mouseclick;//17-Aug-2015 :Madhu- Added code to prevent Manul Scanning
If gbPressKeySNScan ='Y' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			IF Upper(gs_project)='PANDORA' and this.getcolumnname( )='serial_no'  and ibPressF10Unlock =FALSE THEN
				ibmouseclick =FALSE
				MessageBox("MouseClick","Right Mouse Click (RMC) Option is disabled")
			ELSE 
				ibmouseclick =TRUE
			END IF
	END CHOOSE
END IF

Return 0
end event

event ue_keyup;

if key = KeyShift! then
	
	ib_AutoFill_Shift_Select = false
	
end if
end event

event constructor;call super::constructor;// 09/00 PCONKL - Dont show COO or Ownership if not tracking
If g.is_owner_ind  <> 'Y' Then
	this.Modify("c_owner_name.visible=0")
End If

// pvh 09/09/05 - moved here from order_detail constructor
// 09/00 PCONKL - Dont show COO or Ownership if not tracking
If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

//12/02 - PCONKL - Only Show User Line Item for Pulse (9/21/10 - and Pandora)
//05-Dec-2018 :Madhu S26847 User_Line_Item_No is visible for RVS
If upper(gs_project) <> 'PULSE' and upper(gs_project) <> 'PANDORA'  and upper(gs_project) <> 'RIVERBED' Then
	This.Modify("user_line_item_no.width=0 user_line_Item_No_t.width=0")
	//This.Modify("user_line_item_no.visible=0 user_line_Item_No_t.visible=0")
End If

// 02/10 - PCONKL - Only showing description for Pandora
If upper(gs_project) = "PANDORA" then
	object.description.width = 0

	// LTK 20150115  Moved this code down to use the project flag for qunatity decimals
	//
	//	//TimA 10/13/11 Pandora issue #288.  Don't allow decimal point in the req_qty field
	//	This.object.quantity.format= '#,###,###'
	//	This.object.quantity.EditMask.Mask= '#,###,###'
	//	This.object.compute_2.format= '#,###,###'	

End If

// LTK 20150115  Allow quantity decimals based on project flag
if g.ibAllowQuantityDecimals then
	this.object.quantity.EditMask.Mask= '#,###,###.#####'
	this.object.quantity.format= '#,###,###.#####'
	this.object.compute_2.format= '#,###,###.#####'	
else
	this.object.quantity.EditMask.Mask= '#,###,###'
	this.object.quantity.format= '#,###,###'
	this.object.compute_2.format= '#,###,###'	
end if

//06/15 - PCONKL - If not mobile enabled, move back up to original space since mobile DW not visible
if not g.ibMobileEnabled Then
	this.y = 118
End If

//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
//Need to capture serial no's on RMA Serial Tab
IF g.ib_receive_putaway_serial_rollup_ind THEN
	this.modify( "serial_no.protect = 1")
else
	this.modify( "serial_no.protect = 0")
END IF
//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END

// pvh - 08/08/05
this.SetRowFocusIndicator( Hand! )
end event

event doubleclicked;call super::doubleclicked;

// 09/08 - PCONKL If one of the lottable fields is double clicked, we will enable a scan mode which will allow the users to scan down a column instead of across when enter is clicked

str_parms	lstrparms
String	lsFind, lsSKU, ls_WH_Code, ls_old_value, ls_sscc_nbr
Long	llFindRow,llOwnerHold,llRowPos,lLRowCount
boolean lbFootPrint

If Row > 0 Then

	// 06/15 - PCONKL - If content has already been written for this row, don't allow any mods. Easiest to just get out here
	if This.GetITemString(row,'content_record_created_ind') = 'Y' Then
		Return
	End If
	
	//28-AUG-2018 :Madhu S23016 Foot Print Containerization
	
	//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
	//Use Foot_Prints_Ind Flag
	
	If f_is_sku_foot_print(this.getItemString(row,'sku'),  this.GetItemString(row, 'supp_code')) Then
		lbFootPrint = TRUE
	ELSE
		lbFootPrint = FALSE
	END IF
		
	Choose Case dwo.Name

		case "serial_no"
			
			IF NOT g.ib_receive_putaway_serial_rollup_ind THEN 
				/* 02/09 - PCONKL - Serialized type of 'B' is capture at IB/OB but not writing to Content */
				IF (this.getitemstring(row,'serialized_ind') = 'Y' or this.getitemstring(row,'serialized_ind') = 'B') and & 
					 Upper(idw_main.object.ord_status[1])	<> 'C' THEN
						This.SetRedraw(False)
						//i_nwarehouse.of_ro_serial_nos(idw_putaway,ilcurrputawayrow)
						i_nwarehouse.of_ro_serial_nos(idw_putaway,row)
						ib_changed = True
						This.SetRedraw(True)
						This.SetFocus()
				END IF
			END IF
				
		case "lot_no"
			
			This.TriggerEvent('ue_scan_mode') /* 09/08 - PConkl*/
			
		case "po_no2"
			
			//28-AUG-2018 :Madhu S23016 Foot Print Containerization - START
			//GailM 01/09/2018 S27905/F13127/I1304 Google - SIMS Footprints Containerization - make Configurable
			IF lbFootPrint AND f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION") = "Y" Then
				lstrparms.String_arg[1] = this.getItemString(row,'sku')
				lstrparms.String_arg[2] = this.getItemString(row, 'po_no2')
				lstrparms.String_arg[3] = dwo.Name
	
				OpenWithParm(w_ro_pallet_container, lstrparms)
				
				lstrparms = Message.PowerObjectParm
				If lstrparms.Cancelled Then Return
			
				this.setItem( row, 'po_no2', lstrparms.String_arg[2])
				ls_old_value = this.getItemString( row, 'po_no2', primary!, true)
				If ls_old_value <> lstrparms.String_arg[2] Then uf_replace_all_pono2_containerid_values('po_no2' , ls_old_value , lstrparms.String_arg[2])
				this.setredraw( true)
			END IF
			//28-AUG-2018 :Madhu S23016 Foot Print Containerization - END
			
			This.TriggerEvent('ue_scan_mode') /* 09/08 - PConkl*/
			
		case "container_id"		// #883
			
			//28-AUG-2018 :Madhu S23016 Foot Print Containerization - START
			IF lbFootPrint AND f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION") = "Y" Then
				lstrparms.String_arg[1] = this.getItemString(row,'sku')
				lstrparms.String_arg[2] = this.getItemString(row, 'container_id')
				lstrparms.String_arg[3] = dwo.Name
	
				OpenWithParm(w_ro_pallet_container, lstrparms)
				
				lstrparms = Message.PowerObjectParm
				If lstrparms.Cancelled Then Return

				this.setItem( row, 'container_id', lstrparms.String_arg[2])
				ls_old_value = this.getItemString( row, 'container_id', primary!, true)
				If ls_old_value <> lstrparms.String_arg[2] Then uf_replace_all_pono2_containerid_values('container_id' , ls_old_value , lstrparms.String_arg[2])
				this.setredraw( true)
			END IF
			//28-AUG-2018 :Madhu S23016 Foot Print Containerization - END
			
			This.TriggerEvent('ue_scan_mode') /* 08/14 - GailM*/
			This.selecttext( 1,25) //TimA 02/09/15 Highlight /Select the data in the field
			
		case "po_no"  /* 04/04 - MAnderson - Multi-PO */
			
			if this.getitemstring(row,'po_no') = 'MULTIPO' then
	

				lstrparms.Long_arg[1] = dw_putaway.getItemNumber(row,"line_item_no")
				lstrparms.String_arg[1] = dw_putaway.getItemString(row,"sku")
				lstrparms.String_arg[2] = dw_putaway.getitemstring(row,"supp_code")
				lstrparms.String_arg[3] = dw_putaway.getitemString(row,"ro_no")				
			
				i_nwarehouse.of_ro_multiplepo(lstrparms)
				This.SetFocus()
				
			else
				
				This.TriggerEvent('ue_scan_mode') /* 09/08 - PConkl*/
				
			end if	
			
		case "expiration_date" /* 01/04 - PConkl */
			
			This.AcceptText()
			IF this.getitemstring(row,'expiration_controlled_ind') = 'Y' and &
				Upper(idw_main.object.ord_status[1])	<> 'C' THEN
				 
					lstrparms.String_arg[1] = This.GetITemString(row,'sku')
					lstrparms.String_arg[2] = This.GetITemString(row,'supp_code')
					lstrparms.String_arg[3] = This.GetITemString(row,'lot_controlled_ind')
					lstrparms.String_arg[4] = This.GetITemString(row,'po_controlled_ind')
					lstrparms.String_arg[5] = This.GetITemString(row,'po_no2_controlled_ind')
					lstrparms.Date_arg[1] = Date(This.GetITemDateTime(row,'expiration_date'))
					OpenWithParm(w_set_exp_dt, lstrparms)
					
					lstrparms = Message.PowerObjectParm
					If lstrparms.Cancelled Then Return
					
					ib_changed = True
					
					//Set exp for all Line Item/Lot/Po/PO2 if sepecified, otherwise just current row
					
					If isDate(String(lstrparms.Date_arg[1])) Then
						
						lsFind = ''
						
						If lstrparms.String_arg[1] = 'Y' Then /*update all rows for this line Item*/
						
//TAM 2014/07/14 - Use Sku in the Find.  For Kitted Items they may have multiple expiration dates.  Without having sku the this changes the other childern as well
//							lsFind = "Line_Item_No = " + String(This.GetITemNumber(row,'line_item_no')) 
							lsFind = "Line_Item_No = " + String(This.GetITemNumber(row,'line_item_no')) + " and SKU = '" + This.GetITemString(row,'SKU') + "'"
						
						Else /*not all line, check for lot, po and/or PO2*/
							
							If lstrparms.String_arg[2] = 'Y' Then /* update all Lot*/
								lsFInd+= " and lot_no = '" + This.GetITemString(row,'lot_no') + "'"
							End If
							
							If lstrparms.String_arg[3] = 'Y' Then /* update all po*/
								lsFInd+= " and po_no = '" + This.GetITemString(row,'po_no') + "'"
							End If
							
							If lstrparms.String_arg[4] = 'Y' Then /* update all po2*/
								lsFInd+= " and po_no2 = '" + This.GetITemString(row,'po_no2') + "'"
							End If
							
							If Left(lsFind,4) = " and" Then lsFind = Mid(lsFind,5,999) /* strip off first and*/
						
						End If
						
						If lsFind > '' Then /*updating more than 1 row*/
						
							llFindRow = This.Find(lsFind,1,This.RowCount())
							Do While llFindRow > 0 
								This.SetITem(llFindrow,'Expiration_Date', lstrparms.date_arg[1])
								llFindRow++
								If llFindRow > This.RowCount() Then Exit
								llFindRow = This.Find(lsFind,llFindRow,This.RowCount())
							Loop
						
						Else /* updating current row only */
							
							This.SetITem(row,'Expiration_Date', lstrparms.date_arg[1])
							
						End If
						
					End If
										
  	 		END IF /*expiration controlled*/
				
		Case "c_owner_name"
			
			//Cant update Component child rows
			If This.GetITemString(row,'component_ind') = '*' or Upper(idw_main.object.ord_status[1])	= 'C'  Then Return
			
			ls_WH_Code = idw_main.GetItemString(1, "wh_code")
			
			// 090909 - Can't change owner on put-away for Pandora...
			if gs_project = 'PANDORA' then
				messagebox('PANDORA', 'Not allowed to update Owner at put-away')
			else
				OpenWithParm(w_select_owner, ls_WH_Code)
				lstrparms = Message.PowerObjectParm
				If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
					
					//07/02 - Pconkl - If checked, update all detail rows, otherwise just current
					If lstrparms.String_Arg[4] = 'Y' Then /*update all record*/
						llRowCount = This.RowCount()
						For llRowPOs = 1 to llRowCount
							This.SetItem(llrowpos,"owner_id",Lstrparms.Long_arg[1])
							This.SetITem(llRowPos,"c_owner_name",Lstrparms.String_arg[1])
						Next
						
						//Update all order details as well
						llRowCount = idw_detail.RowCount()
						For llRowPos = 1 to llRowCount
							idw_detail.SetItem(llRowPos,"owner_id",Lstrparms.Long_arg[1])
							idw_detail.SetITem(llRowPos,"c_owner_name",Lstrparms.String_arg[1])
						Next
						
					Else /*only update current */
						
						llOwnerHold = This.GetITemNumber(row,'owner_id')
						This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
						This.SetITem(row,"c_owner_name",Lstrparms.String_arg[1])
					
						//Owner Change needs to be reflected on Order Detail as well
						lsFind = "sku = '" + This.GetItemString(row,"sku") + "' and owner_id = " + String(llOwnerHold) 
						llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
						Do While llFindRow > 0
							idw_detail.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
							idw_detail.SetITem(llFindrow,"c_owner_name",Lstrparms.String_arg[1])
							llFindRow = idw_detail.Find(lsFind,(llFindRow + 1),(idw_detail.RowCount() + 1))
						Loop
						
						//If a component, copy Owner to dependent records
						If This.GetItemString(row,"component_ind") = 'Y' Then
							//lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
							lsFind = "l_code = '" + This.GetItemString(row,"l_code") + "' and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
							llFindRow = This.Find(lsFind,1,This.RowCount())
							Do While llFindRow > 0
								This.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
								This.SetITem(llFindrow,"c_owner_name",Lstrparms.String_arg[1])
								llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
							Loop
						End If /*Component*/
					
					End If /*all or current row*/
								
				ib_changed = True
				
				End If /*owner selection not cancelled*/
			end if /* Pandora */

 		case "sku_substitute" //TAM 2010/04/07 

			This.AcceptText()
				 
			lstrparms.String_arg[1] = This.GetITemString(row,'sku')
			lstrparms.String_arg[2] = This.GetITemString(row,'supp_code')
			OpenWithParm(w_select_substitute_sku, lstrparms)
					
			lstrparms = Message.PowerObjectParm
			If lstrparms.Cancelled Then Return
				
			ib_changed = True
					
			This.SetITem(row,"sku_substitute",Lstrparms.String_arg[3])
			This.SetITem(row,"supplier_substitute",Lstrparms.String_arg[4])



		case 'quantity' /* MEA 03/10 - Added for Pulse */
			
			If Upper(gs_project) = 'PULSE' and Upper(idw_main.object.ord_status[1])	<> 'C' and Upper(idw_main.object.ord_status[1])	<> 'V' Then
				
				This.TriggerEvent('ue_process_uom_conversion')
								
			End If /*UOM Conversion for Pulse */

		Case "sku"
	
				//SARUN2015NOV17 : On Double Click Calling Item Master
		
			If f_check_access ("w_maintenance_itemmaster","") = 1 Then
				lstrparms.String_arg[1] = "ITEMMASTER"
				lstrparms.String_arg[2] =  this.GetItemString(row, 'sku')
				lstrparms.String_arg[3] =  this.GetItemString(row, 'supp_code')
				if isvalid(w_maintenance_itemmaster) then
					MessageBox(is_title,"Item Master is Already Open, First Close the existing window and then DoubleClick")
				else	
					OpenSheetwithparm(w_maintenance_itemmaster,lStrparms, w_main, gi_menu_pos, Original!)
				end if
			End If
			
		Case "sscc_nbr"
			
			//30-Jan-2019 :Madhu S28685 -PHILIPSCLS BlueHeart SSCC Nbr validation
			//dts 11/17/2020 - S51442 - add PHILIPS-DA to PHILIPSCLS Logic
			IF upper(gs_project) ='PHILIPSCLS' or Upper(gs_project) ='PHILIPS-DA' THEN
				lstrparms.String_arg[1] = this.getItemString(row,'sku')
				lstrparms.String_arg[2] = this.getItemString(row, 'supp_code')
						
				OpenWithParm(w_ro_sscc_nbr, lstrparms)
				
				lstrparms = Message.PowerObjectParm
				If lstrparms.Cancelled Then Return
	
				//find scanned SSCC Nbr against Detail Records
				ls_sscc_nbr = lstrparms.String_arg[3] //get SSCC Nbr
				
				lsFind = "sku = '" + this.getItemString(row,"sku") + "' and Line_Item_No = " + String(this.getItemNumber(row,'line_item_no')) +" and sscc_nbr = '" + ls_sscc_nbr+"'"
				llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
					
				IF llFindRow > 0 THEN
					
					//assign SSCC Nbr to all matching putaway records against SKU
					//27-FEB-2019 :Madhu DE9057 use appropriate find statement.
					llFindRow = idw_putaway.Find("sku = '" + this.getItemString(row,"sku") + "' and Line_Item_No = " + String(this.getItemNumber(row,'line_item_no')) ,1,idw_putaway.RowCount())
					DO WHILE llFindRow > 0
						idw_putaway.SetItem(llFindRow,"sscc_nbr", ls_sscc_nbr)
						llFindRow = idw_putaway.Find("sku = '" + this.getItemString(row,"sku") + "' and Line_Item_No = " + String(this.getItemNumber(row,'line_item_no')), (llFindRow + 1), (idw_putaway.RowCount() + 1))
					LOOP
				ELSE
					MessageBox(is_title, "Scanned SSCC Nbr "+ls_sscc_nbr+" is not valid!", StopSign!)
					Return -1
				END IF
			END IF
			
			this.setredraw( true)

	End Choose /*Clicked column*/
	
END IF /*Valid Row*/
end event

event getfocus;IF this.getrow() <> 0 THEN
	If upper(gs_project) = 'PULSE' Then
		this.Tag ="Double Click on the Serial Number, Expiration Date or Owner field to update. Double Click on QTY To convert UOM" /* 07/03 - PCONKL */
	Else
//  TAM 2010/04/08 Added Sku Substitute
//		this.Tag ="Double Click on the Serial Number, Expiration Date or Owner field to update."
		this.Tag ="Double Click on the Serial Number, Expiration Date, Owner field or SKU Substitute to update."
	End If
w_ro.SetMicroHelp(this.tag)
END IF

// 06/28/2010 ujhall: 06 of 07: Validate Inbound Serial Numbers    (keeping track of when dw_putaway has focus).
If upper(gs_project) = 'PANDORA' then
	idw_putaway_has_focus = true
end if
end event

event itemchanged;string ls_data,lsproject,		&
		lsWarehouse,ls_name,ls_serial_no, lsFind,lsSku,lsChildSku,lsSupplier,lsChildSupplier,	&
		lsNextContainer, lsIMIID, lsRONO, lsInvTyp, lsGroup, lsCustCd, lsPallet, lsPutawaySKU, lsPalletSKU
String lsFind_main, ls_Component_ind, ls_im_user_field1, ls_im_user_field11, lsCOO, lsError
String ab_error_message_title,ab_error_message,  ls_serial_ind, ls_po_no, ls_error_msg, ls_find, ls_oracle_integrated, ls_owner_code
string oldInvType, lsPalletId, ls_invt, ls_lot, ls_sku, lsInactiveSKU, ls_LocType, ls_ctype,lsFilter  //GailM 7/31/2013 608 - GailM 11/22/2013 - Pallet Rollup
string sql_syntax, ls_cc_lock_ind, ls_old_containerId, ls_old_pono2, lsLocRoNo  //S45954

long row_num_main, ll_Component_no, ll_initialized_qty, ll_req_qty, i_ndx, ll_cs_rows, ll_found_row
Long	llFindRow, llNextContainer, llWeekNo, llOwnerID, llReturn, ll_qty, ll_pallet_qty, ll_exist, llPalletQty
Long ll_wh_row, llAvail, llLocOwnerId1, llLocAvail1, llLocAlloc1, llLocOwnerId2, llLocAvail2, llLocAlloc2, llLocCnt		//GailM 07/13/2017 SIMSPEVS-737 PAN SIMS Soft warning for two separate owner codes on one location
Long llLocSit, llLocTfr_in, llLocTfr_out, ll_old_qty

boolean lb_validcoo, lb_this_pallet
DateTime	ldtExpDT

nvo_coo lnvo_coo
Datastore ldsOwners 


ib_changed = True

ilErrorRow = 0	//GailM 3/27/2014 - Use this instance varible to control KeyEnter! on quantity field

ls_serial_ind = this.getItemString( row, 'serialized_ind') //4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp

id_CurrentRowContainerIdFound = False
//TimA 04/15/2011 Capture the error message in calling function to help stop possible locking issues in SIMS
//Pandora

Choose Case dwo.name
	//*** Make sure there isn't already a case statement for the column you are working on ***
	
	case "inventory_type"
		
		// Basseline -- Pandora #702 - 5/2/2014 -  Directed putaway.  If LotNo is used in storage rule for consolidation, blank out location so putaway will assign a location. 
		If idw_putaway.getItemString(row, 'consol_inv_type') = 'Y' Then
			idw_putaway.setItem(row, 'l_code','')
			If Not ibsrNotifiedInvType  Then
				Messagebox("system Directed Putaway","This Item consolidates Putaway on Inventory Type. A new location will need to be selected")
			End If
			ibsrNotifiedInvType = True /*Only want to notify once*/
		End If		/*Directed Putaway*/

			oldInvType = idw_putaway.getItemString( row, "inventory_type", primary!, true )
			if oldInvtype <> data then
				if oldInvType = 'R' and ( data = 'O' or data = 'H' ) then
					doAdjustmentWork( row, oldInvType, data, ManualAdjustReason )
				end if
			end if
			
			//If a component, copy location to dependent records
			If This.GetItemString(row,"component_ind") = 'Y' Then
				lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
				//lsFind = "l_code = '" + This.GetItemString(row,"l_code") + "' and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
				llFindRow = This.Find(lsFind,1,This.RowCount())
				Do While llFindRow > 0
					This.SetItem(llFindRow,"inventory_type",data)
					llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
				Loop
			End If /*Component*/
					
		
		//MEA - 06/12
		//a)	In receiving function,  where  stocks received, SIMS will put in the logic that for  
		// inventory type = 0009 Returns Stock, assigned the  expiry date to be  01/01/1999. 
		//Else (other inventory type )  expiry date to be set  12/31/2999.
		//
		//The is also code in ue_generate_putaway_server.

		IF Upper( gs_Project ) = 'PHILIPS-TH' Then
			if data = "9" then
				 idw_putaway.SetItem(row, "expiration_date", date("01/01/1999"))
			else
				 idw_putaway.SetItem(row, "expiration_date",date("12/31/2999"))
			end if
		End If		
		
		
		//JXLIM 05/10/2010 moved pasted from second case 'inventory_type' below per Pete.
		//If a component, copy Inventory Type to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			//lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
			//lsFind = "l_code = '" + This.GetItemString(row,"l_code") + "' and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"inventory_type",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		//JXLIM 05/10/2010 end of pasted from case 'inventory_type' below per Pete.
				
	// pvh - 07/25/2005
	Case "country_of_origin" /* 09/00 PCONKL - validate Country of Origin*/
		
		// Create the COO object.
		lnvo_coo = Create nvo_coo
		
		// If we can determine if the COO is a valid 2 char country code.
		If lnvo_coo.f_validatecoo(data, lb_validcoo) then
			
			// If the coo is valid,
			If lb_validcoo then
		
				//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
				lsCOO = f_get_Country_Name(data)
				If isNull(lsCOO) or lsCOO = '' Then
					MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
					Return 1
				End If
		
				//If a component, copy  to dependent records
				If This.GetItemString(row,"component_ind") = 'Y' Then
					lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
					llFindRow = This.Find(lsFind,1,This.RowCount())
					Do While llFindRow > 0
						This.SetItem(llFindRow,"country_of_origin",data)
						llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
					Loop
				End If /*Component*/
				
				//TimA 04/07/13 Pandora issue #560
				//Update the detail recode that has the same sku
				lsFind = "sku = '" + This.GetItemString(row,"sku") + "'"//and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
				lsFind += " and Line_Item_no =  " + String(This.GetITemNumber(row,'Line_Item_no'))
				llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
				Do While llFindRow > 0
					idw_detail.SetItem(llFindRow,"country_of_origin",data)
					llFindRow = idw_detail.Find(lsFind,(llFindRow + 1),(idw_detail.RowCount() + 1))
				Loop
				
			Else // Otherwise, if this is NOT a valid COO,
				
				Return 1  // Return 1 to reject the value.
				
			End If  // end if this is NOT a valid COO.
			
		End If // End If we can determine if the coo is a valid 2 char country code.
		
		// Destroy the lnvo_coo object.
		Destroy lnvo_coo
		
	// eom - pvh		
	case 'sku' 
				
		lsFind = "Upper(sku) = '" + Upper(data) + "'"
		llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
		If llFindRow > 0 Then
			lsSUpplier = idw_detail.GetItemString(llFindRow,'supp_code')
		Else /*Row Not Found*/
			Messagebox(is_title,"SKU not found in Order Detail!")
			Return 1
		End If
		
		// dts 2010/07/05 - Not allowing to insert row for an 'Inactive' SKU (item_delete_ind = Y)
		Select item_delete_ind Into :lsInactiveSKU
		FROM item_master
		Where project_id = :gs_project
		and supp_code = :lsSupplier
		and sku = :data;
		if lsInactiveSKU = 'Y' then
			messagebox("Inactive SKU", "SKU '" + lsSKU + "' is Inactive!  Order can not be processed")
			return 1
		end if

		i_nwarehouse.of_item_master(gs_project,data,lsSupplier,idw_putaway,row)
		This.TriggerEvent('ue_hide_Unused') /* we may add a sku that needs to be tracked*/
		
		//Build Component children records if new data is a compnent
		If This.GetITemString(row,"component_ind") = 'Y' Then
			//ilCompRow = row
			//ilcompnumber +=5
			ilCompNumber = g.of_next_db_seq(gs_project,'Content','Component_No') /* 02/10/ - Pconkl - Component_no needs to be unique across project*/
			This.SetItem(row,"component_no",ilCompNumber)
		//	This.PostEvent("ue_post_component") /*needs to happen after itemchanged complete*/
		Else
			This.SetItem(row,"component_no",0)
		End If /*component*/
		
		// 09/00 PCONKL - If this is a new row, we will need to update owner ID from Detail Row
		If THis.GetItemStatus(row,0,Primary!) = New! or THis.GetItemStatus(row,0,Primary!) = newModified! Then
			
			This.SetITem(row,'c_owner_name',idw_detail.GetItemString(llFindRow,'c_owner_name'))
			This.SetITem(row,'country_of_origin',idw_detail.GetItemString(llFindRow,'country_of_origin'))
			This.SetITem(row,'supp_code',idw_detail.GetItemString(llFindRow,'Supp_Code')) /* 11/04 - PCONKL */
			This.SetITem(row,'owner_id',idw_detail.GetItemNumber(llFindRow,'owner_id'))
			This.SetItem(row,'sku_parent',data)
/*SUBSTITUTE*/	This.SetItem(row,'sku_substitute',data) // TAM 2010/04/07
/*SUBSTITUTE*/	This.SetItem(row,'supplier_substitute',This.GetITemString(row,'supp_code')) // TAM 2010/04/07

			
			// 2/10 - PCONKL - We need the Item Grp
			lsSupplier = This.GetITemString(row,'supp_code')
			
// TAM W&S 2011/03/19  Added more fields from Item Master for W&S
//			Select Grp into :lsGroup
//			From Item_Master
//			Where Project_id = :gs_Project and sku = :data and supp_Code = :lsSupplier;

			Select Grp, User_field1, User_Field11 into :lsGroup :ls_im_user_field1, :ls_im_user_field11
			From Item_Master
			Where Project_id = :gs_Project and sku = :data and supp_Code = :lsSupplier;
			
			This.SetItem(row,'grp',lsGroup)
			
			// 12/02 - PConkl - If Tracking by Container ID, set to Next
			If This.GetItemString(row,'container_tracking_Ind') = 'Y' Then

				//TAM 2009/12/21 Added group as a Parm (Used by Pandora)
				//This.SetITem(row,'container_id',uf_get_next_container_ID()) /* 04/01 - PCONKL - moved to function to support project specific requirements*/
				lsGroup = idw_putaway.getItemstring(row, "GRP")
				This.SetITem(row,'container_id',uf_get_next_container_ID(lsGroup)) /* 04/01 - PCONKL - moved to function to support project specific requirements*/
				
			End If /*Container Tracked */
			
			
			//Jxlim 01/13/2011 Added this line of code to enabled backcolor change based on qa_check_ind on Item_master	when tab out the sku field.
			This.SetItem(row, "qa_check_ind",idw_detail.GetItemString(llFindRow,'qa_check_ind'))			
						
			// 02/10 - PCONKL - If Pandora Cityblock, default Project. If any items on the order are Cityblock, default...
			If gs_project = 'PANDORA' Then
				
				If lsGroup = 'CB' or idw_Putaway.Find("grp = 'CB'",1,idw_putaway.RowCount()) > 0 Then
					This.SetITem(row,'po_no','CITYBLOCK')
				End If
			
			End If /* Pandora */

	// TAM W&S 2011/02/10 Moving CIF Total to Detail Screen.  We are not entering the PO_NO field.  This is used for CIF per Bottle and is calculated from the CIF total on the Details Screen User Field 11/quantiy
	// TAM W&S 2011/05/06 IIf non bonded then we need to set PONO = 0
//			IF Left(gs_Project,3) = 'WS-' and is_bonded = 'Y' Then
			IF Left(gs_Project,3) = 'WS-'  Then
				If is_bonded = 'Y' Then
					Decimal ll_CIFtotal  //TAM W&S 05/18/2011 Made CIF Total a decimal
					Long ll_dtlQTY
					ll_CIFTotal = idw_detail.GetItemNumber(llFindRow, "Cost")
					ll_dtlQTY = idw_detail.GetItemNumber(llFindRow, "Req_Qty")
					if ll_dtlqty > 0 Then
						This.SetItem(row, 'PO_NO',string(ll_CIFTotal/ll_dtlqty,'#####0.0000'))	
					End If
				Else // DP doesn't have a PoNo but a value is required 
					This.SetItem(row, 'PO_NO','0')	
				End If
			End If

// TAM W&S 2011/03/19  Populate userfields with Item Master info.
	
			IF Left(gs_Project,3) = 'WS-' Then
				idw_putaway.SetItem(row,"user_field2", ls_im_user_field1)
				idw_putaway.SetItem(row,"user_field4", ls_im_user_field11)
			End If	
	

		End If /*new Row*/

	case 'supp_code'
		
		// 03/06 - PCONKL - now allowing multiple suppliers on order, we need to validate supplier
		lsFind = "Upper(sku) = '" + Upper(idw_putaway.GetItemString(row,'sku')) + "' and upper(supp_code) = '" + Upper(data) + "'"
		llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
		If llFindRow < 1 Then
			Messagebox(is_title,"Supplier not found for this SKU in Order Detail!")
			Return 1
		End If
		
	Case 'container_id' /* 01/03 - PCONKL - must be numeric so we increment if necessary */
		
		If data <> '-' or data <> ''  Then  //OCT 2019 - MikeA - DE12998

			ls_old_containerId = idw_putaway.getItemString( row, 'container_id', primary!, true)

			//GailM 8/11/2020 S48701 F24564 Google - Prevent N/A on put away and stock adjustment and stock adjustment
			//Force container_id to 5 or more characters and do not allow anything less that 5 to be anything but NA
			If UPPER(gs_project) = 'PANDORA' and len(data) < 5 and data <> 'NA' Then
				Messagebox(is_title,"ContainerId must be over 4 characters except the value NA.  Please re-enter.")
				idw_putaway.setitem(row, 'container_id', ls_old_containerid)
				This.SetFocus()
				This.SelectText(1, Len(ls_old_containerId))
				Return 1
			End If
			
			llReturn = uf_validate_container(data)
			If llReturn = 2 Then 
				REturn 2
			elseif llReturn < 0 Then
				Return 1
			end if
			
			//15-Jan-2018 :Madhu S14839 - Foot Print - START
			IF ls_old_containerId <> data Then uf_replace_all_pono2_containerid_values('container_id' , ls_old_containerId, data)
			//15-Jan-2018 :Madhu S14839 - Foot Print - END
			
		End If /*Container ID entered*/
				
	case 'l_code' /* 07/00 PCONKL - validate location and check for project reservation*/
		
		// 02/21/2011 ujh: I-135   Must restore quantities that were zeroed out to restore things for original code.
		IF gs_project = "PANDORA" THEN   
			if not idw_putaway.GetItemNumber(row, 'quantity') > 0 then
				messagebox('Quantity Error', 'Please enter quantity for row '+ string(row,'0')+ ' before selecting a location.')
				return 2
			end if
		end if

		If isnull(data) then Return
		lsWarehouse = idw_main.GetItemString(1,"wh_code")
		
		Select project_reserved, l_type, cc_location_lock_ind
		into :lsProject, :ls_LocType, :ls_cc_lock_ind
		From	location
		Where wh_code = :lsWarehouse and l_code = :data
		Using SQLCA;
		
		If sqlca.sqlcode = 0 Then
			
		//Check for project being reserved for a specific project
			If isnull(lsProject) or lsProject = '' Then
			Else
				If lsProject <> gs_project Then
					messagebox(is_title,"This Location is reserved by another project!",StopSign!)
					Return 1
				End If
			End If
			
			// LTK 20160505  Cycle count location lock logic
			if ls_cc_lock_ind = 'Y' then
				MessageBox(is_title,"This Location is locked by a cycle count!",StopSign!)
				Return 1
			end if
			
			//TimA 02/12/14
			//Pandora #698 New MIX OWNER location type 6 to save multiple owners in one location
			//if gs_Project = 'PANDORA' and ( ls_LocType <> '9' and  ls_LocType <> '6' ) then
			// LTK 20151214  Added the IsNull() check so that nulls would drop into the "if" condition
			//21-NOV-2018 :Madhu DE7369 Added SIT, Tfr_In, Tfr_Out quantities
			if gs_Project = 'PANDORA' and ( IsNull( ls_LocType ) or ( ls_LocType <> '9' and  ls_LocType <> '6' ) ) then
				// dts - 2010-08-19, allowing multiple owners for cross-dock locations (where l_type = '9')
				/* NOTE!!! 
				What if a Pick is generated (emptying location of certain owner/inv_typ), 
				then a Put-away succeeds (because material of different owner has been picked)
				then the pick is un-done, placing the inventory back in content???  */

				//check that location is either empty or contains only material of like Owner and Inventory Type
				llOwnerID = idw_putaway.getItemNumber(row, "owner_id", primary!, true)
				lsInvTyp = idw_putaway.getItemString(row, "inventory_type", primary!, true)
				//Is this warehouse authorized to have 2 owner codes in one location as long as on is in allocated status?
				ll_wh_row = g.of_project_warehouse(gs_project, lsWarehouse)		
				isAllowMultiOwnerPerLocation = g.ids_project_warehouse.GetItemString( ll_wh_row, 'warehouse_allow_multi_owner_per_location_ind' )
				ldsOwners = Create datastore
				sql_syntax = "Select owner_id, sum(avail_qty) as avail, sum(alloc_qty) as alloc, sum(sit_qty) as sit, sum(tfr_in) as tfr_in, sum(tfr_out) as tfr_out " + &
					" From content_summary Where project_id = 'PANDORA' " + &
					" and wh_code = '" + lsWarehouse + "' and l_code = '" + data + "' group by owner_id"
				ldsOwners.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", lsError))
				IF Len(lsError) > 0 THEN
					messagebox("TEMPO", "*** Unable to create datastore for Content Records.~r~r" + lsError)
   					Return -1
				END IF
					ldsOwners.SetTransObject(SQLCA)
					llLocCnt = ldsOwners.Retrieve()
					
					If llLocCnt <= 0 Then
						// Location is empty.  Do nothing
					ElseIf llLocCnt = 1 Then		//One owner in this location
						If llOwnerID = ldsOwners.GetItemNumber(1,'owner_id') Then
							//One owner in one location is ideal.  Nothing to do.
						Else
							//Second owner attempted.  Is first owner fully allocated?
							llLocAvail1 = ldsOwners.GetItemNumber(1,'avail')
							llLocAlloc1 = ldsOwners.GetItemNumber(1,'alloc')
							llLocSit = ldsOwners.GetItemNumber(1,'sit')
							llLocTfr_in = ldsOwners.GetItemNumber(1,'tfr_in')
							llLocTfr_out = ldsOwners.GetItemNumber(1,'tfr_out')
							
							If llLocAvail1 = 0 and llLocAlloc1 = 0 and llLocSit =0 and llLocTfr_in = 0 and llLocTfr_out =0 and isAllowMultiOwnerPerLocation = 'Y' Then
								ib_allow_multi_owner_per_location = True		// During save validation, allow this condition
								ib_has_allowed_multi_owner_per_location = True		// Will check during save validation to allow save
							elseIf llLocAvail1 = 0 and (llLocAlloc1 > 0 or llLocSit > 0 or llLocTfr_in > 0 or llLocTfr_out > 0) and isAllowMultiOwnerPerLocation = 'Y'  Then
								ll_wh_row = messagebox(is_title, 'This bin Location has allocated inventory of a different ownercode.  If you wish to use this location, press OK. Otherwise, press Cancel and choose a new bin location.', Question!, OKCancel!)
								if ll_wh_row = 2 Then
									Return 1		// Return to change location
								Else
									ib_allow_multi_owner_per_location = True		// During save validation, allow this condition
									ib_has_allowed_multi_owner_per_location = True		// Will check during save validation to allow save
								End If
							else
								messagebox(is_title, "This Location already has material of a different Owner or Inventory Type!",StopSign!)
								Return 1
							End If
						End If
					ElseIf llLocCnt = 2 Then	// Already two owners in this location.  Is this new order with the same owner as the available qty?
						llLocOwnerID1 = ldsOwners.GetItemNumber(1,'owner_id')
						llLocAvail1 = ldsOwners.GetItemNumber(1,'avail')
						llLocAlloc1 = ldsOwners.GetItemNumber(1,'alloc')
						llLocOwnerID2 = ldsOwners.GetItemNumber(2,'owner_id')
						llLocAvail2 = ldsOwners.GetItemNumber(2,'avail')
						llLocAlloc2 = ldsOwners.GetItemNumber(2,'alloc')
						If ( llLocOwnerID1 = llOwnerID And  llLocAvail1 >= 0 And llLocAvail2 = 0 And llLocAlloc2 > 0 )	Or  ( llLocOwnerID2 = llOwnerID And  llLocAvail2 >= 0 and llLocAvail1 = 0 And llLocAlloc1 > 0 ) Then		
							
							// This will allow entry
						Else
							messagebox(is_title, "Location already has available quantity for another owner.  Please choose a different location!",StopSign!)
							Return 1
						End If
					Else
						messagebox(is_title, "Location cannot have a third owner assigned.  Please choose a different location!",StopSign!)
						Return 1
					End If
				
				// LTK 20151215  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
				if f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' then
	
					ls_sku = Upper( Trim( this.GetItemString( row, 'sku' ) ))
					ls_serial_ind = Upper( Trim( this.GetItemString( row, 'Serialized_Ind' ) ))
					ls_po_no = Upper( Trim( this.GetItemString( row, 'Po_No' ) ))

					if ls_serial_ind = 'B' or ls_serial_ind = 'O' or ls_serial_ind = 'Y' then
						// LTK 20151229  Added check that customer is Oracle Integrated
						ls_owner_code = String( this.Object.Owner_Cd[ row ] )
	
						If ls_LocType = 'Z' Then
							//GailM 6/12/2020 S45954 DA Kitting will merge if there is already the SKU present - Is there a record their now?
							//Do not check owner code in this case
						ElseIf NOT IsNull( ls_owner_code ) then	// shouldn't be null but let's check

							SELECT user_field5
							INTO :ls_oracle_integrated
							FROM Customer
							WHERE Project_ID = :gs_project
							AND Cust_Code = :ls_owner_code
							USING SQLCA;

							if Upper( Trim( ls_oracle_integrated )) = 'Y' then

								// Check the PND Serial indicator to determine if this rule is exercised
								if Upper( Trim( this.Object.item_master_user_field18[ row ] )) = 'N' then
									// Skip this rule
								else

									SELECT MAX(sku) 
									INTO :lsSKU
									FROM Content
									WHERE  project_id = :gs_project
									AND wh_code = :lsWarehouse
									AND l_code = :data
									AND sku = :ls_sku
									AND po_no <> :ls_po_no
									USING SQLCA;

									if Len( lsSKU ) > 0 then
										MessageBox( is_title, "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project!", StopSign! )
										Return 1
									end if
									
									// LTK 20151215  Pandora #1002  SOC and GPN serial tracked inventory segregation by project
									ls_find = "sku = '" + ls_sku + "' and l_code = '" + data + "' and owner_id = " + String( llOwnerID ) + " and po_no <> '" + ls_po_no + "'"
									ll_found_row = this.Find( ls_find, 1, this.RowCount() + 1 )
									if ll_found_row > 0 then
										MessageBox( is_title, "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project!", StopSign! )
										Return 1
									end if
								end if
							end if
						end if
					end if
				end if
				// LTK 20151215  End of Pandora #1002  

				//dts - 8/30/2010 (not ready yet but need to check in....
				/* 9/29/10 - turned back on */
				If idw_main.GetItemString(1, "crossdock_ind") = 'Y' Then
					if ls_LocType <> '9' then
						messagebox(is_title, "Cross-dock orders must be put-away in a cross-dock location!", StopSign!)
						Return 1
					end if
				End If	
			end if //Pandora and not a cross-dock location...
			
		Else /* Location Not Found*/
			Messagebox(is_title,"Location Not Found!",StopSign!)
			Return 1
		End If
		
		
		// LTK 20150812  Unique SKU change.  If unique SKU location indicator is set, don't allow different SKUs to be putaway in the location
		String ls_unique_sku_ind
		
		select Unique_SKU_ind 
		into :ls_unique_sku_ind 
		from location with (nolock) 
		where wh_code = :lsWarehouse 
		and l_code = :data;

		if Upper( ls_unique_sku_ind ) = 'Y' then

			long ll_count

			ls_sku = Upper( Trim( this.GetItemString( row,'sku' ) ) )

			select COUNT(DISTINCT SKU) 
			into :ll_count 
			from content_summary with (nolock) 
			where project_id = :gs_project 
			and wh_code = :lsWarehouse 
			and l_code = :data 
			and sku <> :ls_sku
			and NOT
				(Avail_Qty = 0
				and Alloc_Qty = 0 
				and SIT_Qty = 0
				and Tfr_In = 0
				and Tfr_Out = 0
				and WIP_Qty = 0
				and New_Qty = 0);

			if ll_count > 0 then
				Messagebox( is_title, "Another SKU exists in this location but the location is set to allow only a single SKU.", StopSign! )
				return 1
			end if


			// Also check the SKUs/Locations in the datawindow
			long i
			String ls_rows_sku
			ls_rows_sku = this.Object.sku[ row ]
			for i = 1 to this.RowCount()
				if i <> row then
					if Upper(Trim( this.Object.l_code[ i ] )) = Upper(Trim( data )) and Upper(Trim( this.Object.sku[ i ] )) <> Upper(Trim( ls_rows_sku )) then
						Messagebox( is_title, "Another identical location with a different SKU exists in the current window but this location is set to allow only a single SKU." +&
													"~rPlease enter another location.", StopSign! )
						return 1
					end if
				end if
			next

		end if

		
		//If a component, copy location to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			//lsFind = "line_item_no = " + String(This.GetITemNumber(row,'line_item_no')) + " and l_code = '" + This.GetItemString(row,"l_code") + "'"
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"l_code",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
	
	//JXLIM 05/2010 combined Case 'inventory_type' to the first one above otherwise this will never get executed per Pete
	//Case 'inventory_type'
	
//		//If a component, copy Inventory Type to dependent records
//		If This.GetItemString(row,"component_ind") = 'Y' Then
//			//lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
//			//lsFind = "l_code = '" + This.GetItemString(row,"l_code") + "' and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
//			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
//			llFindRow = This.Find(lsFind,1,This.RowCount())
//			Do While llFindRow > 0
//				This.SetItem(llFindRow,"inventory_type",data)
//				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
//			Loop
//		End If /*Component*/
//JXLIM 05/10/2010 End of commented out case 'inventory type'.
		
		
	Case 'line_item_no'
		
		//If a component, copy location to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			//lsFind = "line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			llFindRow = This.Find(lsFind,row,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"line_item_no",Long(data))
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
		//GAP 12-02  keep line items in sync.
		This.SetItem(row,"user_line_item_no",data) 
	
				
	Case 'quantity'
		
		//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - START
		ll_old_qty = this.getitemnumber( row, 'quantity', Primary!, true)
		IF g.ib_receive_putaway_serial_rollup_ind and (ls_serial_ind='Y' or ls_serial_ind ='B') and (ll_old_qty >0)  THEN
			MessageBox(is_title, "QTY Override is not allowed for Serialized SKU's. ~n~nPlease Delete appropriate Serial No's from Serial TAB to reflect QTY!.", StopSign!)
			this.setitem( row, 'quantity', ll_old_qty)
			Return 1
		END IF
		//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp - END
		
		// 02/21/2011 ujh: I-135:
		// If pandora, don't allow overpick
		if upper(gs_project) = 'PANDORA' then


// LTK 20150115  Commented out block below as projects now use a project level setting to allow/prevent quantity decimals
//
//			//TimA 10/13/11 Pandora issue #288.  don't allow periods, comas etc on user line number
//			//Pass the string to verify each character.
//			If  f_verify_if_numeric(data) = False then
//				MessageBox(is_title, "Invalid Quanitity.  Must be numeric and contain no Periods, Dashes, Coma's, Letters etc., please re-enter!")
//				Return 1
//			End if
			
			ll_initialized_qty = this.Getitemnumber(row, 'Quantity', primary!, true)
			lsFind = "Line_Item_no = " + string(This.GetItemNumber(row,"Line_Item_No")) &
				+ " and SKU = '" + This.GetItemString(row,"SKU") + "' " &
				+ " and Owner_id = " + string(This.GetItemNumber(row,"Owner_id"), '0')
//				+ " and l_code = '" +  This.GetItemString(row,"l_code") + "'" &
			llFindRow = idw_detail.Find(lsFind, 1,idw_detail.RowCount())
			if llFindrow > 0 then
				ll_req_qty = idw_detail.GetItemNumber(llFindRow, 'req_qty')
			else
//				messagebox('Sys Error', 'System Error: Cannot continue, Detail Tab Record not found ~r' &
//					+ "Line Item No = " +  string(This.GetItemNumber(row,"Line_Item_No")) &
//					+ ": SKU = '" + This.GetItemString(row,"SKU") + "' " )
				messagebox('Sys Error', 'System Error: Cannot continue, Detail Tab Record not found.' )
				return 2
			end if  // End if row found in seardh of detail row
			if long(data) > ll_req_qty then
				messagebox('Over-Pick', "Qty entered = '" + data + "' is greater than required qty = '" + string(ll_req_qty, '0') + "'.")
				return 2
			end if  // End if entered data is greater than required data
		end if  // End if Pandora
		// If Pandora and a parent and serialized, then special pandora processing else baseline
		If upper(gs_project) = 'PANDORA'  and  This.GetItemString(row,"component_ind") = 'Y'  &
			and   (This.GetItemString(row,"Serialized_ind") = 'Y'  or This.GetItemString(row,"Serialized_ind") = 'B' ) then
			// process based on initalized_qty zeroed out on retrieve
			Choose Case ll_initialized_qty
				case 0
					// First entry after zeroed out action on retrieve.  The first time is the only time the original qty will be zero.
					// Since this part is serialized a qty of 1 is the only entry acceptable.
					if long(data) = 1 then
						// insert the children
						ilComponenttRow = row
						ilComponenttInsertRow = row
						//this.Event("ue_insert_components")
						This.PostEvent("ue_insert_components")
					else
						messagebox('Qty Error', 'Serialized parents must be qty of 1. ~r' &
							+ 'If business rules alow, use insert to add additional serialized parts')
						return 2
					end if
				case else
					// original qty other than zero (entries after initial zeroed out entries)
						messagebox('Qty Error', 'Serialized parents must be qty of 1. ~r' &
							+ 'If business rules alow, use insert to add additional serialized parts')
						return 2
					
			end choose
			
		elseif upper(gs_project) = 'PANDORA'  and  This.GetItemString(row,"component_ind") = 'Y'  &
			and  ll_initialized_qty = 0 then
			/* When Pandora, a non-serialized Parent part, and initial qty is zero, need only create components and populate. */
			// add the children. Because not serialized, children may have multiple qty based on the parent qty
			This.PostEvent("ue_insert_components_populate_qty")
		else
			// Baseline////////////////////////////////////////////////////
			// 09/00 PCONKL - If Quantity has changed for a component Item, recalc child extended amts
			If This.GetItemString(row,"component_ind") = 'Y' Then
				This.PostEvent("ue_update_comp_qty") /*qty not available in wf_create_comp_child until this event is finished*/
			End If /*Component Item*/		
			// Baseline////////////////////////////////////////////////////
		end if  // end Pandora and  component Y and serialized Y or B
		
		// GailM - 03/27/2014 - If Pandora and an LPN GPN then quantity cannot be changed.  Quantity is set from Serial No field for Carton/Serial record count.  Pallet Level processing.
		//25-Jan-2018 :Madhu S14839 - Foot Prints -commented below code
		//If upper(gs_project) = 'PANDORA'  and   (This.GetItemString(row,"Serialized_ind") = 'B'  and  This.GetItemString(row,"po_no2_controlled_ind") = 'Y'  &
		//	and This.GetItemString(row,"Container_Tracking_ind") = 'Y' ) then
		//		messagebox('   Qty Error', 'Quantity cannot be set for Pandora LPN GPNs. ~r' &
		//				+ 'Set Serial No field to po_no2 value for pallet level processing')
		//		This.SetItem(row,'quantity',0)		
		//		This.ScrollToRow(row)
		//		This.SetColumn("serial_no")
		//		This.SetFocus()
		//		ilErrorRow = row
		//		Return 1
		//End If
	
	Case 'lot_no'
		
		// Basseline -- Pandora #702 - 5/2/2014 -  Directed putaway.  If LotNo is used in storage rule for consolidation, blank out location so putaway will assign a location. 
		If idw_putaway.getItemString(row, 'consol_lot_no') = 'Y' Then
			idw_putaway.setItem(row, 'l_code','')
			If not ibSRNotifiedLot Then
				Messagebox("system Directed Putaway","This Item consolidates Putaway on Lot Number. A new location will need to be selected")
			End If
			ibSRNotifiedLot = True /*only want to notify once*/
		End If

		// 12/2009 - TAM - For PANDORA and Group = KittyHawk, we need to validate Lot_no against the Luhn Mod N algorithm
		IF Upper(gs_Project) = 'PANDORA' Then
			lsGroup = idw_putaway.getItemstring(row, "GRP", primary!, true)
			If upper(trim(lsGroup)) = 'KHBOOKS' Then
				If not iuo_check_digit_validations.uf_validate_luhn(data) Then
					Messagebox(is_title,"Invalid Lot Number!",StopSign!)
					Return 1
				End IF
			End If
		End If
		
		// 01/09 - PCONKL - For LMC, we need to validate Lot_no against the Luhn Mod N algorithm
		IF Upper(gs_Project) = 'LMC' Then
	
			If not iuo_check_digit_validations.uf_validate_luhn(data) Then
				Messagebox(is_title,"Invalid Lot Number!",StopSign!)
				Return 1
			End IF
	
		End If
				
		// 03/16 - PCONKL - For Kendo, Validate Lot No against Lot COntrol file and populate Expiration Date 
		IF Upper(gs_Project) = 'KENDO' and data <> '-'  Then
			
			lsSKU = This.GetItemString(row,"sku") 
			lsSupplier = This.GetItemString(row,"supp_code") 
			
			Select Expiration_Date
			Into :ldtExpDT
			From Lot_Control
			Where project_id = 'KENDO' and sku = :lsSKU and Supp_code = :lsSupplier and Lot_No = :data
			Using SQLCA;
			
			If Sqlca.sqlnrows < 1 Then
				Messagebox(is_title,"Invalid Batch Code (Lot)!",StopSign!)
				Return 1
			Else
				This.SetItem(row,'Expiration_date',ldtExpDT)
			End If
			
		End If
		
		//If a component, copy Lot to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"lot_no",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
	Case 'po_no'
		
		//If a component, copy po_no to dependent records
		If This.GetItemString(row,"component_ind") = 'Y' Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"po_no",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
		// Basseline -- Pandora #702 - 5/2/2014 -  Directed putaway.  If LotNo is used in storage rule for consolidation, blank out location so putaway will assign a location. 
		If idw_putaway.getItemString(row, 'consol_po_no') = 'Y' Then
			idw_putaway.setItem(row, 'l_code','')
			If Not ibSRNotifiedPO Then
				Messagebox("system Directed Putaway","This Item consolidates Putaway on PO NO. A new location will need to be selected")
			End If
			ibSRNotifiedPO = True /*only want to notify once */
		End If		/*Directed Putaway*/

	Case 'po_no2'
		
		ls_old_pono2 = idw_putaway.getItemString( row, 'po_no2', primary!, true)

		//GailM 8/11/2020 S48701 F24564 Google - Prevent N/A on put away and stock adjustment and stock adjustment
		//Force po_no2 to 5 or more characters and do not allow anything less that 5 to be anything but NA
		If UPPER(gs_project) = 'PANDORA' and len(data) < 5 and data <> 'NA' Then
			Messagebox(is_title,"Pallet ID must be over 4 characters except the value NA.  Please re-enter.")
			idw_putaway.setitem(row, 'po_no2', ls_old_pono2)
			This.SetFocus()
			This.SelectText(1, Len(ls_old_pono2))
			Return 1
		End If
		
		//If a component, copy po_no2 to dependent records
		If This.GetItemString(row,"component_ind") = 'Y'  Then
			lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no")) + " and line_item_no = " + String(This.GetITemNumber(row,'line_item_no'))
			llFindRow = This.Find(lsFind,1,This.RowCount())
			Do While llFindRow > 0
				This.SetItem(llFindRow,"po_no2",data)
				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
			Loop
		End If /*Component*/
		
		// TAM W&S 2010/12 Wine and Spirit Make Numric only
		IF Left(gs_Project,3) = 'WS-' Then
			If Not isnumber(data) Then
				Messagebox(is_title,"Alcohol % Must be Numeric!",StopSign!)
				Return 1
			End If
		End If 		

		// Basseline -- Pandora #702 - 5/2/2014 -  Directed putaway.  If LotNo is used in storage rule for consolidation, blank out location so putaway will assign a location. 
		If idw_putaway.getItemString(row, 'consol_po_no2') = 'Y'   Then
			idw_putaway.setItem(row, 'l_code','')
			If Not ibSRNotifiedPO2 Then
				Messagebox("system Directed Putaway","This Item consolidates Putaway on PO NO 2. A new location will need to be selected")
			End If
			ibSRNotifiedPO2 = True /*only want to notify once*/
			
		End If		/*Directed Putaway*/
		
		//15-Jan-2018 :Madhu S14839 - Foot Print - START
		IF ls_old_pono2 <> data Then uf_replace_all_pono2_containerid_values('po_no2' , ls_old_pono2, data)
		//15-Jan-2018 :Madhu S14839 - Foot Print - END
		
	Case 'expiration_date'
		
			// Basseline -- Pandora #702 - 5/2/2014 -  Directed putaway.  If LotNo is used in storage rule for consolidation, blank out location so putaway will assign a location. 
		If idw_putaway.getItemString(row, 'consol_exp_dt') = 'Y'  Then
			idw_putaway.setItem(row, 'l_code','')
			If Not ibSRNotifiedExpDT Then
				Messagebox("system Directed Putaway","This Item consolidates Putaway on Expiration Date. A new location will need to be selected")
			End If
			ibSRNotifiedExpDT = True /*Only want to notify once*/
		End If		/*Directed Putaway*/


	// 06/28/2010 ujhall: 02 of 07: Validate Serial Number.
	Case "serial_no"
		
		IF upper(gs_project) = 'PANDORA' Then
			/*Serialized tracking flag with Ord_type  determins if they should have sent serial numbers */
			string ls_Serialized_Ind, lsLineItemNo,ls_po_no2_controlled_ind,ls_container_tracking_ind, ls_stripoff_checked
			String ls_Supp_Code, ls_Ord_Nbr, ls_User_line_item_no, ls_ord_type, ls_Owner_cd, lsSerial
			long ll_EDIBatch, ll_return , ll_pos_return
			integer liMessage
			BOOLEAN lb_SN_cleaned = FALSE
			Boolean lbStripOffSN =FALSE

			ls_SKU = This.GetItemString(row,"sku")
			ls_Supp_Code = This.GetItemString(row,"Supp_Code")
			ll_EDIBatch = idw_main.GetItemNumber(1,"edi_batch_seq_no")
			ls_User_line_item_no = trim(This.GetItemString(row,"User_Line_item_no"))
			lsLineItemNo = string(This.GetItemNumber(row,"line_item_no"))  //GailM 7/21/2013 Issue 608
			ls_Component_ind = This.GetItemString(row,"Component_ind")  // 01/03/2011 ujh: S/N_Pb:
			ll_Component_no = This.GetItemNumber(row,"Component_no")  // 01/03/2011 ujh: S/N_Pb:
			
			// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
			data = TRIM(data)
			If len(data) > 1 Then
				// strip extraneous Trailing chars
				DO WHILE MATCH( data, "[-\.]$" )
					data = MID(data, 1, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
				// strip extraneous Leading chars
				DO WHILE MATCH( data, "^[-\.]")
					data = MID(data, 2, len(data) - 1 )
					lb_SN_cleaned = TRUE
				LOOP
				
			End If
			
			lsSerial = Trim(data)
			
			/////////////Begin Find Duplicates/////////////////////////////////////////////////////////			
			//01/03/2011 ujh: S/N_P: No blank, No Null Serial Nos AND no space in the serial_no string.  Must be all caps
			ll_pos_return = pos(Trim(data), ' ', 1)
			If Not len(trim(data)) > 0 or ll_pos_return <> 0 then
				messagebox('SN Validation', 'Serial Numbers must not be null, blank or contain spaces')
				This.SetFocus()
				This.SelectText(1, Len(this.GetText()))
				return 1
			else
				data = upper(data)  // Set to all caps
			end if
			//01/03/2011 ujh: S/N_ P/////END///

			//01/03/2011 ujh: Find Duplicate sku serial number combinations on this page 
			lsFind_main = "Serial_no = '" + lsSerial + "'" + " and SKU = '" +ls_SKU +"'"  //12/06/2010 ujh: SNQM
			row_num_main = this.Find(lsFind_main,1,this.RowCount())  // Check main for SN
			
			if row_num_main > 0 then  // If duplicate found on main page, show message
				MessageBox("Duplicate found on main window","This Serial Number SKU combination has already been entered on main page line "+string(row_num_main))
				This.SetFocus()
				This.SelectText(1, Len(Trim(data)))
				Return 1
				
			End If
			//////////end Find Duplicates/////////////////////
			
			//01-AUG-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes
			ls_stripoff_checked = i_nwarehouse.of_stripoff_firstcol_checked( ls_SKU,this.GetItemString(row,'supp_code'))

			// LTK 20160401  Serial number mask validation
			String ls_return
			ls_return = i_nwarehouse.of_validate_serial_format( ls_SKU, data, this.GetItemString(row,'supp_code') )
			
			//01-AUG-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -START
			If ls_return <> "" and upper(ls_stripoff_checked) ='Y' Then
				lsSerial = i_nwarehouse.of_Stripoff_firstcol_serialno(ls_SKU, this.GetItemString(row,'supp_code'), data)
				ls_return = i_nwarehouse.of_validate_serial_format(  ls_SKU, lsSerial, this.GetItemString(row,'supp_code'))

				//Original SN and Returned SN should not be changed
				If data <> lsSerial Then 
					data = lsSerial //store the SN
					idw_putaway.setitem( row, dwo.name, data )
					lbStripOffSN =TRUE
				End If
				
			End If
			//01-AUG-2017 :Madhu -PEVS-554 - TCIF Linked Code39 "TLC39" SerialBarcodes -END
			
			if ls_return <> "" then
				Messagebox( is_title,ls_return )
				This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
				this.SelectText(1,1)
				return 1
			end if

			// processing of entered serial number complete - store if modified
			if lb_SN_cleaned then idw_putaway.setitem( row, dwo.name, data )
			
			// 12/02/2010 ujh:  If user_line_item_no is null, use line_item_no
			if isnull(ls_User_line_item_no) or ls_User_line_item_no = ''  then 
				ls_User_line_item_no = trim(String(This.GetItemNumber(row,"Line_item_no"), '0')) 
			end if
			
			ls_Ord_Nbr = upper(idw_main.GetITemString(1,'Supp_Invoice_no'))
			ls_Ord_Type  = idw_main.GetITemString(1,'Ord_type')
			ls_owner_cd = idw_putaway.GetItemString(row,'Owner_cd')
			// 01/03/2011 ujh: S/N_P: Cleanup  // Serialized_ind is available in the data window.
			ls_Serialized_Ind =  idw_putaway.GetItemString(row,'Serialized_ind')
			ls_po_no2_controlled_ind = idw_putaway.GetItemString(row,'po_no2_controlled_ind')
			ls_container_tracking_ind = idw_putaway.GetItemString(row,'container_tracking_ind')
			//			// Get the serialized tracking flag
			//			SELECT Serialized_Ind 
			//				INTO :ls_Serialized_Ind 
			//				FROM Item_master
			//				WHERE Project_ID = :gs_project
			//				AND SKU = :ls_SKU
			//				and Supp_Code = :ls_supp_code ;
			//				string ls_serialized_Ind_test

			
			// If serial number should be captured on receipt, start the process to see if it was sent and validate entered	data
			// 12/22/2010 ujh:  in discussion with Dave agreed to change the test below from upper(lsSerializedInd) = 'I' to 'Y' 
			
			//TimA 10/22/15 added the Pandora flag ibFromWMS if the order is from WMS
			If upper(ls_Serialized_Ind ) = 'Y' or upper(ls_Serialized_Ind) = 'B' or ibFromWMS = True  Then
				//////////////////////////////////////////////////////////////////////////////////////
				/* 07/14/2010 ujhall: 05 of 05 Validate Serial # doubleClick  Replaced previous method with 
				a function w_ro_serialno.wf_val_serial_nos*/  
				/* 01/03/2011 ujh:  NOTE:  wf_val_serial_nos was later replaced by 
				i_nwarehouse.of_val_serial_nos sometime before today
				*/
				
				/* 01/03/2011 ujh: S/N_P: SERIAL NUMBER VALIDATION
				For serialized parts, skip serial number validation against sent for components  
				except when the order is a warehouse transfer (S/N are not SENT for components 
				except on warehouse Transfer).  All other serialized parts will be validated. 
				*/
				/*At this point, we know the part is serialized so we need do 
				SERIAL NUMBER VALIDATION (enterd vs sent) whenever the order is a warhouse transfer or 
				the part is not a compontent
				*/
				If upper(ls_ord_type) = 'Z' or This.GetItemString(row,"component_ind") <> '*' Then
					ll_return = i_nwarehouse.of_val_serial_nos(ls_ord_nbr,ls_Ord_type,data,ll_EDIBatch,ls_SKU,ls_user_line_item_no,ls_serialized_ind)
					if ll_return <> 0 then
																																																
						// If "sent" serial number does not match the one just scanned, there is a missmatich
						// if upper(ls_Serial_no) <> upper(data) then
						// TAM 2010/08/02 If Warehouse transfer then don't allow them to save an invalid serial number
						
						//TimA 10/22/15 added the Pandora flag ibFromWMS
						If upper(idw_main.GetITemString(1,'Ord_type')) = 'Z' or ibFromWMS = True Then   // if a warehouse transfer
							If ibFromWMS = True then
								liMessage = Messagebox(is_title," Serial Number " + data + " does not exist on the Outbound half of the WMS warehouse transfer!   Please verify serial number was entered correctly and if so please contact your Site Manager/Supervisor to determine what needs to be corrected.")
							Else
								liMessage = Messagebox(is_title," Serial Number " + data + " does not exist in the Outbound half of the warehouse transfer!   Please verify serial number was entered correctly and if so please contact your Site Manager/Supervisor to determine what needs to be corrected.")
							End if
							This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
							this.SelectText(1,1)
							return 1
							//TimA 07/26/13 commented out #608 per Gail's request.  Not ready for Prod
							
						else
							/*  01/03/2011 ujh: S/N_P:
							But if it is not a warehouse transfer, then sometimes serial numbers are sent as  is 
							the case with a PO receipt.  Sometimes serial numbers are not sent as is the case with
							a regular material order.  For PO receipts entered S/Ns are compared to sent while for
							regular material orders entered S/Ns  are compared to null and will always give a mismatch.
							In both cases the message and choice will pop up because the two can't be distinguished
							except by noting that non-po receipts will have EDI_Batch_Seq_no set to null. 
							(note to self: When EDI_Batch_Seq_no is null check to see if this code will  be reached.*/
							liMessage = messagebox(is_title, 'Serial No Missmatch! Do you want to keep serial number = '+data,Question!, YesNo!,2)
							if liMessage = 2 then
								This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
								this.SelectText(1,1)
								return 1
							end if  // checking liMessage.  Fall through to check if num on database
							
							//	else
							//	return 0
							//	end if  // checking liMessage
						end if // Warehouse Transfer
						
					else
						//GailM 7/21/2013 Pandora Issue 608 - LPN fill SN fields from SN, CartonID or PalletID. Return dw_carton_serial datawindow
						If upper(gs_Project) = 'PANDORA' and ls_po_no2_controlled_ind = "Y" and ls_container_tracking_ind = "Y" Then
							SetMicroHelp("Checking serial numbers.  Please wait..")
							idw_carton_serial.Reset()
							ll_cs_rows = idw_carton_serial.Retrieve(gs_project, data)
							if ll_cs_rows = 0 then
								messagebox("Find LPN serial numbers","No serial numbers found for " + string(data))
								This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
								this.SelectText(1,1)
								return 1
							else
								ls_ctype = idw_carton_serial.GetItemString(1,'c_type')
								if ls_ctype = 'S' and idw_carton_serial.rowcount( ) = 1 then
									This.SetItem(row,'Serial_no',idw_carton_serial.GetItemString(1,'serial_no'))
									This.SetItem(llFindRow,"quantity",idw_carton_serial.GetItemnumber(1,"carton_qty"))
								elseif ls_ctype = 'C' then
									lb_this_pallet = false
									lsFind = "(serial_no = '-' or serial_no = '" + data + "') and container_id = '" + data + "' and line_item_no = " + lsLineItemNo
									for i_ndx = 1 to ll_cs_rows
										llFindRow = This.Find(lsFind,1,This.RowCount())
										if llFindRow > 0 then
											This.SetItem(llFindRow,"serial_no",idw_carton_serial.GetItemString(i_ndx,"carton_id"))
											This.SetItem(llFindRow,"quantity",idw_carton_serial.GetItemnumber(i_ndx,"carton_qty"))
											if llFindRow = row then
												lb_this_pallet = true
											end if
										end if
									next
									if not lb_this_pallet then
										This.SetItem(row,"serial_no","-")
									end if
								elseif ls_ctype = 'P' then
									lb_this_pallet = false
									for i_ndx = 1 to ll_cs_rows
										lsPalletId = idw_carton_serial.GetItemString(i_ndx,"pallet_id")
										llPalletQty = Dec(idw_carton_serial.GetItemNumber(i_ndx,"pallet_qty"))
										lsFind = "(serial_no = '-' or serial_no = '" + data + "') and po_no2 = '" + data + "' and line_item_no = " + lsLineItemNo 
											//" and container_id = '" + lsCartonId + "' "			// Gailm - 11/22/2013 -- Pallet Rollup,ignore carton ID
										llFindRow = This.Find(lsFind,1,This.RowCount())
										if llFindRow > 0 then
											This.SetItem(llFindRow,"serial_no", lsPalletId)
											This.SetItem(llFindRow,"quantity",llPalletQty)
											if llFindRow = row then
												lb_this_pallet = true
											end if
										end if
									next
									if not lb_this_pallet then		// If the carton is not in pallet row put it back to dash
										This.SetItem(row,"serial_no","-")
									end if
								else
									messagebox("Find LPN serial numbers","Error in detail for:  " + string(data))
									This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
									this.SelectText(1,1)
									return 1
								end if
								
								lsFind = "serial_no = '-'"
								llFindRow = This.Find(lsFind,1,This.RowCount())	// Find next blank SN
								if llFindRow > 0 then
									This.scrolltorow(llFindRow)
								end if
								SetMicroHelp("Ready")
								return 1
							end if		
							SetMicroHelp("Ready")
						Else
							//	else   // ll_return = 0 validation good so far
							/* 01/03/2011 ujh: S/N_P:  Two cases changed:   now [(1)Components that didn't need 
								to be validated against sent and (2) non-components where the user chose to keep the
								serial number entered] are now validated against the serial_number_inventory table.
							*/
							// 08/11/2010 ujhall: 06 of 09 Full Circle Fix:  Check DB for serial number.
							//ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, ls_SKU, data,ls_owner_cd, ls_component_ind, ll_component_no,true)
							//dts - 2/19/11 - added parameter to skip component number as part of the serial look-up condition
							
							//TimA 04/15/2011 - added parameters to capture error message in calling function
							ab_error_message_title = ''
							ab_error_message = ''
							//24-Jul-2014 :Madhu Added "is_rono,is_suppinvoiceno" to write onto Method Trace Log
							ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, ls_SKU, data, ls_owner_cd, ls_component_ind, ll_component_no, true, true,ab_error_message_title,ab_error_message,is_rono,is_suppinvoiceno) //TEMPO! - TRUE for SkipComponent?
							
							if ll_return = 1 then
								This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
								this.SelectText(1,1)
								//Tima 04/15/2011 Show the error here rather than in of_Error_on_serial_no_exists
								messagebox (ab_error_message_title, ab_error_message)
								
							elseif lb_SN_cleaned then
								// ET3 - 2012-07-10  If the SN was processed to a different value, then set that value
								ll_return = 2
								
							elseif lbStripOffSN then //01-Aug-2017 :Madhu PEVS-554  Store the modified SN
								ll_return =2
							
							end if
			
							return ll_return
				
						End If
					end if  // processing base on ll_return     // checking if serial_no matches scanned data
					
				End if // End SERIAL NUMBER VALIDATION against sent,  Components that are not in a warehouse Xfer fall to here
				
			End if  // checking if ls_serialized_ind is Y or B
			
		End if //  project is Pandora

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

// TAM - 2013/10 - Added Friedrich Serial Validation
		
		IF upper(gs_project) = 'FRIEDRICH' Then
			ls_SKU = This.GetItemString(row,"sku")
			ls_Component_ind = This.GetItemString(row,"Component_ind")  // 01/03/2011 ujh: S/N_Pb:
			ll_Component_no = This.GetItemNumber(row,"Component_no")  // 01/03/2011 ujh: S/N_Pb:
			ls_owner_cd = idw_putaway.GetItemString(row,'Owner_cd')

			ab_error_message_title = ''
			ab_error_message = ''
			//24-Jul-2014 : Madhu- Added "is_rono,is_suppinvoiceno" to write those onto Method Trace Log
			ll_return = i_nwarehouse.of_Error_on_serial_no_exists(gs_Project, ls_SKU, data, ls_owner_cd, ls_component_ind, ll_component_no, true, true,ab_error_message_title,ab_error_message,is_rono,is_suppinvoiceno) //TEMPO! - TRUE for SkipComponent?
			// If No error in inventory then check for a serial number on a prior putaway (can return a 2 to ignore)
			if ll_return <> 1 then
					ll_return = i_nwarehouse.of_Error_serial_prior_receipt(gs_Project, ls_SKU, data, ls_owner_cd, ls_component_ind, ll_component_no, true, true,ab_error_message_title,ab_error_message) //TEMPO! - TRUE for SkipComponent?
			end if 
	
			if ll_return = 1 then
				This.SetItem(row, 'Serial_no', '-')  // blank out the scanned data
				this.SelectText(1,1)
				messagebox (ab_error_message_title, ab_error_message)
			elseif lb_SN_cleaned then
				
				// ET3 - 2012-07-10  If the SN was processed to a different value, then set that value
				ll_return = 2
			end if

			return ll_return

		End If

	Case 'user_field1'

// TAM W&S 2010/12 Wine and Spirit Make Numric only
// TAM 2011/02/10 Moving CIF Total to Detail Screen
//		IF Left(gs_Project,3) = 'WS-' Then
//			If Not isnumber(data) Then
//				Messagebox(is_title,"CIF Must be Numeric!",StopSign!)
//				Return 1
//			Else
//				ll_qty =This.GetItemNumber(row,"quantity")
//				if ll_qty > 0 Then
//					This.SetItem(row, 'PO_NO',string(dec(data)/ll_qty,'#####0.0000'))	
//				End If
//			End If
//		End If 			

END Choose

IF dwo.name = "serial_no" or dwo.name = "po_no" or dwo.name = "lot_no" or  dwo.name = "po_no2" THEN
	if not(upper(gs_project) = 'PANDORA' and dwo.name = "serial_no") then  // 01/03/2011 ujh: S/N_P: dash ok for serial nos
	  IF mid(trim(data),1,1) = '-' THEN 
		  data = mid(trim(data),2)
		  idw_putaway.setitem(row,dwo.name,data)
		  return 1
	   END IF  
	End if // 01/03/2011 ujh: S/N_P: dash ok for serial nos
END IF

//F18447 - I2576 - Google - SIMS - Receiving Enhancement
//Qty, COO and Location
	
if upper(gs_project) = 'PANDORA' and (dwo.name = "quantity" or dwo.name = "country_of_origin" or dwo.name = "l_code") 	then
	
	wf_autofill_putaway_container_pallet(dwo.name, row, data)
	
end if





end event

event itemerror;
Choose Case dwo.name
	Case 'l_code'
		Return 1
////	 06/28/2010 ujhall: 07 of 07:  Validate Inbound Serial Numbers  (hoping to force the cursor to stay in serial_no coumn, but no luck).
////		This had no value, as the cursor still moved to wherever the mouse click took it
//	Case 'serial_no'
//		If upper(gs_project) = 'PANDORA' then
//			Return 1
//		else
//			goto CaseElse
//		end if
		
	Case else
//		CaseElse:
		Return 2
End Choose
end event

event itemfocuschanged;call super::itemfocuschanged;// 05/14 - PCONKL - assign Locs should be enabled for baseline

IF dwo.Name = "l_code" Then
		cb_putaway_locs.Enabled = True
		cb_putaway_locs.Text = "&Putway Locs..."
Else
	//cb_putaway_locs.Enabled = False
	
//	If left(gs_project,6) = 'PHYSIO' Then
		cb_putaway_locs.Enabled = True
		cb_putaway_locs.Text = "Assign Locs..."
//	End If
	
End If

Choose Case dwo.name
	Case 'country_of_origin'
		If gs_project = 'PANDORA' Then
				idwc_IM_Coo_Putaway.Retrieve(gs_project,This.GetITemString(row,'sku'),This.GetITemString(row,'supp_code'))
		End If	
end choose



end event

event process_enter;Long	llRow

IF This.GetColumnName() = "user_field2" THEN
	IF This.GetRow() = This.RowCount() THEN
		tab_main.tabpage_putaway.cb_insertrow.TriggerEvent(Clicked!)
	Else	
		Send(Handle(This),256,9,Long(0,0))		
	END IF
ELSE
	
	// 09/08 - PCONKL - We may be processing down the page instead of across if we are in "Scan MOde" for a particular column (lottables)
	IF This.GetColumnName() = isScanColumn and This.GetRow() <> This.RowCount() Then
		llRow = This.GetRow() + 1
		This.SetRow(llRow)
		This.ScrollToRow(llRow)
		This.SetColumn(isScanColumn)
		//TimA 02/09/15 Pandora issue
		//Because of DeJavu orders change the functionality of the enter key when keying in container ID's 
		If gs_project = 'PANDORA'  then
			If id_CurrentRowContainerIdFound = True then //Found on the current row selected
				llRow = This.GetRow() - 1
				This.SetRow(llRow)
				This.ScrollToRow(llRow)
				This.SetColumn(isScanColumn)
			Else
				If this.GetItemString(llRow, isScanColumn ) = '-' then 
					This.SetRow(llRow)
					This.ScrollToRow(llRow)
					This.SetColumn(isScanColumn)			
				Else
					//Loop through the rows until the next dash '-' is found
					Do While this.GetItemString(llRow, isScanColumn ) <> '-'  and llRow <= This.Rowcount( )
						llRow= llRow+1
						This.SetRow(llRow)
						This.ScrollToRow(llRow)
						This.SetColumn(isScanColumn)			
					Loop
				End if
			End if
		End if //End Pandora
	Else
		Send(Handle(This),256,9,Long(0,0))
	End If
	
End If

Return 1
end event

event retrieveend;call super::retrieveend;Long	llRowCount,	llRowPos, llFindRow
		
This.SetRedraw(False)

llRowCOunt = This.RowCount()
For llRowPos = 1 to llRowCount
	If g.is_owner_ind  = 'Y' Then /*only need to populate if showing */
		//11/02 - PConkl - added Owner code to SQL, just format name instead of retrieving
	//	This.SetItem(llRowPos,"c_owner_name",g.of_get_owner_name(This.GetITemNumber(llRowPos,"owner_id")))
		This.SetItem(llRowPos,"c_owner_name",This.GetITemString(llRowPos,'owner_cd') + '(' + This.GetITemString(llRowPos,'owner_type') + ')')
	End If
	//set lot and po controlled ind on component child records, not saved and no need to get from itemmaster every time!
	If This.GetItemString(llRowPos,"component_ind") = '*' Then
		idw_putaway.SetItem(llRowPos,"lot_controlled_ind",'N')
		idw_putaway.SetItem(llRowPos,"po_controlled_ind",'N')
		idw_putaway.SetItem(llRowPos,"po_no2_controlled_ind",'N')
		idw_putaway.SetItem(llRowPos,"expiration_controlled_ind",'N')
		idw_putaway.SetItem(llRowPos,"container_tracking_ind",'N')
	End If
next

//09/06 - PCONKL - For Powerwave, If it's a PO (Not an IR), If we have any Outbound Serial flags, flip them to scan at Inbound (We want to capture for GR but we won't write to Content)
If gs_project = 'POWERWAVE' Then
	This.TriggerEvent('ue_set_powerwave_flags')
End If /*Powerwave */

//F18447 - I2576 - Google - SIMS - Receiving Enhancement

ib_AutoFill_Putaway_Pallet = FALSE
ib_AutoFill_Putaway_Container = FALSE

This.SetRedraw(True)
end event

event rowfocuschanged;ilcurrputawayrow = currentrow
end event

event ue_copy;
Long ll_row,	&
		llNewRow,	&
		llnextContainer,	&
		llFindRow,			&
		i
		
String	lsSku,	&
			lsSupplier,	&
			lsNextContainer, &
			lsGroup

Str_Parms	lStrParms

idw_putaway.SetFocus()

If idw_putaway.AcceptText() = -1 Then Return -1

ll_row = idw_putaway.GetRow() /* 08/00 PCONKL */

If ll_row > 0 Then
	
	//Dont allow Copy of Component Rows
	If idw_putaway.GetItemString(ll_row,"component_ind") = '*' or & 
		idw_putaway.GetItemString(ll_row,"component_ind") = 'Y' or &
		idw_putaway.GetItemString(ll_row,"component_ind") = 'B' Then
			Messagebox(is_title,"You can not copy component rows!")	
			Return -1
	End If
		
	// 01/03 - PCONKL - allow user to select the number of rows to add and set QTY
	lstrparms.Decimal_arg[1] = idw_putaway.GetITemNumber(ll_row,'quantity') /*Qty from original row, will be default for new rows*/
	OpenWithParm(w_ro_copy_Putaway,lStrParms)
	lstrparms = message.PowerObjectParm
	
	If lstrparms.Cancelled Then Return 1 /*Don't copy row if cancelled from prompt*/
	
	This.SetReDraw(False)
	
	//Set Qty on Original Row
	idw_Putaway.SetITem(ll_row,'Quantity',lstrparms.Decimal_arg[1])
	
	//Loop for each row to Create We're creating one less row than rowcount since we already have the first row)
	For i = 1 to (lstrparms.Long_arg[1] - 1)
	
		idw_putaway.setcolumn('sku')
		llNewrow = idw_putaway.InsertRow(ll_row + 1)
		//idw_putaway.ScrollToRow(llNewrow)
		
		//copy items to new row
		idw_putaway.setitem(llNewrow,'ro_no',idw_Main.GetItemString(1,"ro_no"))
	
		idw_putaway.SetItem(llNewRow,'sku',idw_putaway.GetITemString(ll_row,'sku'))
		idw_putaway.SetItem(llNewRow,'sku_parent',idw_putaway.GetITemString(ll_row,'sku_parent'))
		lssku = idw_putaway.GetITemString(ll_row,'sku')
		lsSupplier = idw_putaway.GetITemString(ll_row,'supp_code')
		idw_putaway.SetItem(llNewRow,'component_ind',idw_putaway.GetITemString(ll_row,'component_ind'))
		//idw_putaway.SetItem(llNewRow,'l_code','')
		idw_putaway.SetItem(llNewRow,'l_code',idw_putaway.GetITemString(ll_row,'l_code'))
		idw_putaway.SetItem(llNewRow,'supp_code',idw_putaway.GetITemString(ll_row,'supp_code'))
		idw_putaway.SetItem(llNewRow,'inventory_type',idw_putaway.GetITemString(ll_row,'inventory_type'))
		idw_putaway.SetItem(llNewRow,'serialized_ind',idw_putaway.GetITemString(ll_row,'serialized_ind'))
		idw_putaway.SetItem(llNewRow,'lot_controlled_Ind',idw_putaway.GetITemString(ll_row,'lot_controlled_Ind'))
		idw_putaway.SetItem(llNewRow,'po_controlled_Ind',idw_putaway.GetITemString(ll_row,'po_controlled_Ind'))
		idw_putaway.SetItem(llNewRow,'po_no2_controlled_Ind',idw_putaway.GetITemString(ll_row,'po_no2_controlled_Ind'))
		idw_putaway.SetItem(llNewRow,'expiration_controlled_Ind',idw_putaway.GetITemString(ll_row,'expiration_controlled_Ind'))
		idw_putaway.SetItem(llNewRow,'container_tracking_Ind',idw_putaway.GetITemString(ll_row,'container_tracking_Ind'))
		idw_putaway.SetItem(llNewRow,'lot_no',idw_putaway.GetITemString(ll_row,'lot_no'))
		idw_putaway.SetItem(llNewRow,'po_no',idw_putaway.GetITemString(ll_row,'po_no'))
		idw_putaway.SetItem(llNewRow,'po_no2',idw_putaway.GetITemString(ll_row,'po_no2'))
		//idw_putaway.SetItem(llNewRow,'container_ID',idw_putaway.GetITemString(ll_row,'container_ID')) /* 11/02 - Pconkl */
		idw_putaway.SetItem(llNewRow,'expiration_Date',idw_putaway.GetITemDateTime(ll_row,'expiration_Date'))
		idw_putaway.SetItem(llNewRow,'country_of_origin',idw_putaway.GetITemString(ll_row,'country_of_origin'))
		idw_putaway.SetItem(llNewRow,'owner_id',idw_putaway.GetITemNumber(ll_row,'Owner_id'))
		idw_putaway.SetItem(llNewRow,'c_owner_name',idw_putaway.GetITemString(ll_row,'c_owner_name'))
		// dts - 8/31/10 - adding owner_cd to copy...
		idw_putaway.SetItem(llNewRow, 'owner_cd', idw_putaway.GetItemString(ll_row, 'Owner_cd'))
		idw_putaway.SetItem(llNewRow,'line_item_no',idw_putaway.GetITemNumber(ll_row,'line_item_no')) /* 08/01 PCONKL */
		idw_putaway.SetItem(llNewRow,'user_line_item_no',idw_putaway.GetITemString(ll_row,'user_line_item_no')) /* 01/03 - PCONKL */
		idw_putaway.SetItem(llNewRow,'length',idw_putaway.GetITemNumber(ll_row,'length')) /* 01/03 PCONKL */
		idw_putaway.SetItem(llNewRow,'Width',idw_putaway.GetITemNumber(ll_row,'Width')) /* 01/03 PCONKL */
		idw_putaway.SetItem(llNewRow,'Height',idw_putaway.GetITemNumber(ll_row,'height')) /* 01/03 PCONKL */
		idw_putaway.SetItem(llNewRow,'weight_1',idw_putaway.GetITemNumber(ll_row,'weight_1')) /* 03/04 PCONKL */
		idw_putaway.SetItem(llNewRow,'weight_Gross',idw_putaway.GetITemNumber(ll_row,'weight_gross')) /* 01/03 PCONKL */
		idw_putaway.SetItem(llNewRow,'GRP',idw_putaway.GetITemString(ll_row,'GRP')) /* 2009/12/21 TAM */
		idw_putaway.SetItem(llNewRow,'description',idw_putaway.GetITemString(ll_row,'description')) // 03/04/10 KRZ

		
		idw_putaway.SetItem(llNewRow,'user_field1',idw_putaway.GetITemString(ll_row,'user_field1'))   //MEA 9/10
		idw_putaway.SetItem(llNewRow,'user_field2',idw_putaway.GetITemString(ll_row,'user_field2'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field3',idw_putaway.GetITemString(ll_row,'user_field3'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field4',idw_putaway.GetITemString(ll_row,'user_field4'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field5',idw_putaway.GetITemString(ll_row,'user_field5'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field6',idw_putaway.GetITemString(ll_row,'user_field6'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field7',idw_putaway.GetITemString(ll_row,'user_field7'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field8',idw_putaway.GetITemString(ll_row,'user_field8'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field9',idw_putaway.GetITemString(ll_row,'user_field9'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field10',idw_putaway.GetITemString(ll_row,'user_field10'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field11',idw_putaway.GetITemString(ll_row,'user_field11'))   //MEA 9/10 
		idw_putaway.SetItem(llNewRow,'user_field12',idw_putaway.GetITemString(ll_row,'user_field12'))   //MEA 9/10 

		
		
		
		//idw_putaway.Setcolumn("Quantity")
		idw_Putaway.SetITem(llNewRow,'Quantity',lstrparms.Decimal_arg[1]) /* 01/03 - PConkl set qty from prompt*/
		
		//If this row is a component, process the child rows
		If idw_putaway.GetItemString(llNewRow,"component_ind") = 'Y' then
			idw_putaway.SetItem(llNewRow,'component_no',(idw_putaway.GetITemNumber(ll_row,'component_no') + 5)) /*bump up component #*/
			wf_create_comp_child(llNewRow)
		Else
			idw_putaway.SetItem(llNewRow,'component_no',0) /* 06/01 PCONKL */
		End If
		
		// 12/02 - PConkl - If Tracking by Container ID, set to Next
		If This.GetItemString(llNewrow,'container_tracking_Ind') = 'Y' Then
			
			//TAM 2009/12/21 Added group as a Parm (Used by Pandora)
			//This.SetITem(llNewrow,'container_id',uf_get_next_container_ID()) /* 04/09 - PCONKL - moved to function to support project specific requirements*/
			lsGroup = idw_putaway.getItemstring(llnewrow, "GRP")
			This.SetITem(llNewrow,'container_id',uf_get_next_container_ID(lsGroup)) /* 04/09 - PCONKL - moved to function to support project specific requirements*/


End If /*Container Tracked */		
		
	Next /*copy of Row*/
	
	This.SetReDraw(True)
	
	ib_Changed = True
		
//	//Sort and refresh group breaking
//	idw_putaway.Sort()
//	idw_putaway.GroupCalc()
		
	This.SetRow(ll_row)
	This.ScrollToRow(ll_row)
	
Else
	Messagebox(is_title,"Nothing to copy!")
End If	
return 1


end event

event losefocus;this.Tag ="Ready"
w_ro.SetMicroHelp(this.tag)

// 06/28/2010 ujhall: 05 of 07:  Validate Inbound Serial Numbers  (keeping track of when dw_putaway has focus).
If Upper(gs_project) = 'PANDORA' then
	idw_putaway_has_focus = false
	dw_putaway.event  post ue_acceptText( )
End if


end event

event clicked;call super::clicked;
DataWindowChild	ldwc
Int lirc
Long ll_Idx

if row > 0 then this.setrow( row )

ilcurrputawayrow = row

Choose case dwo.name
		
	Case "mobile_status_ind" /*filter to only show Detail level statuses*/
		
		This.GetChild('mobile_status_ind',ldwc)
		lirc = ldwc.SetFilter("mobile_status_ind <> 'R' and mobile_status_ind <> 'I' and mobile_status_ind <> 'B' and mobile_status_ind <> '1' ")
		ldwc.Filter()
	
	//MikeA - 3/20 - F21861  S43665 - Google BRD - SIMS - Inbound Putaway Autofill II
	
	Case "c_autofill"
		
		if KeyDown(KeyShift!) and this.GetItemString( row, "c_autofill") = 'N' then
			
			if NOT ib_AutoFill_Shift_Select then
			
				ib_AutoFill_Shift_Select = true
				il_AutoFill_Start_Row = row
			
			else
				
				if row <> il_AutoFill_Start_Row then
				
					if row > il_AutoFill_Start_Row then
						
						for ll_Idx = il_AutoFill_Start_Row to row
		
							this. Post Function SetItem( ll_idx, "c_autofill", 'Y')
						
						next
					
					else
		
						for ll_Idx = row to il_AutoFill_Start_Row
		
							this.Post Function SetItem( ll_idx, "c_autofill", 'Y')
						
						next
		
				
					end if
					
					il_AutoFill_Start_Row = row
				
				end if
				
			end if
			
			
			
		end if 
		
End Choose
end event

type tabpage_notes from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3858
integer height = 1856
long backcolor = 79741120
string text = "Notes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_notes dw_notes
end type

on tabpage_notes.create
this.dw_notes=create dw_notes
this.Control[]={this.dw_notes}
end on

on tabpage_notes.destroy
destroy(this.dw_notes)
end on

type dw_notes from u_dw_ancestor within tabpage_notes
integer x = 5
integer y = 12
integer width = 3314
integer height = 1572
integer taborder = 20
string dataobject = "d_ro_notes"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type tabpage_rma_serial from userobject within tab_main
event ue_mode_switch ( )
event ue_process_barcodes ( )
integer x = 18
integer y = 108
integer width = 3858
integer height = 1856
long backcolor = 79741120
string text = "Serial #"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_delete_row cb_delete_row
cb_copy_row cb_copy_row
rb_auto rb_auto
rb_manual rb_manual
st_message st_message
sle_rma_barcode sle_rma_barcode
dw_rma_serial dw_rma_serial
gb_1 gb_1
end type

event ue_mode_switch();//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//commented code which is no longer needed

if ib_changed then
	Messagebox(is_title,"Please save your changes first!")
	Return
End If
		
idw_rma_serial.reset( )
idw_rma_serial.retrieve( is_rono, gs_project)

//Long	llRowCount,	&
//		llRowPos
//		
//String	lsSKUHold
//
//Choose Case Upper(message.StringParm)
//		
//	Case "MANUAL"
//		
//		sle_rma_barcode.visible = False
//		sle_rma_barcode.Text = ''
//		st_message.text = ''
//		//dw_rma_serial.Object.DataWindow.ReadOnly= False
//		dw_rma_serial.SetFocus()
//		If dw_rma_serial.RowCOunt() > 0 Then
//			dw_rma_serial.SetRow(1)
//		End If
//		
//		st_message.text = "Please type or scan the Serial Number for the proper SKU."
//		
//	Case "BARCODE"
//		
//		ibManualScan = False
//		ibSkuScanned = False
//		ibMultipleSKU = False
//		sle_rma_barcode.visible = True
//		sle_rma_barcode.Text = ''
//		//dw_rma_serial.Object.DataWindow.ReadOnly= True
//		sle_rma_barcode.SetFocus()
//		
//		//DEtermine whether we have a single SKU or multiple SKUS - If only a single sku we wont force them to scan a SKU first, just a serial #
//		llRowCount = dw_rma_serial.RowCount()
//		lsSKUHold = ''
//		For llRowPOs = 1 to llRowCount
//			If (lsSKUHold <> dw_rma_serial.GetITemString(llRowPOs,'sku') and llRowPos > 1) Then
//				ibMultipleSKU = True
//			//	st_message.text = "Multiple SKU's exist - You must scan a SKU before Scanning the Serial Number."
//				Exit /*no need to continue*/
//			Else
//				lsSKUHold = dw_rma_serial.GetITemString(llRowPOs,'sku')
//			End If
//		NExt /*row*/
//		
//		If ibMultipleSKU Then
//			st_message.text = "Multiple SKU's exist - You must scan a SKU before Scanning the Serial Number."
//		Else
//			st_message.text = "Only a Single SKU exists. Please scan a Serial Number."
//		End If
//
//End Choose
end event

event ue_process_barcodes();//4-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//commented code which is no longer needed

//String	lsMessage, lsFind, lsbarcode, lsSerial, ls_Supplier
//Integer	liRC
//Long	llLineITemNo, llFindRow
//
//
//lsBarcode = sle_rma_barcode.Text
//
//
////If only one sku, we dont need to scan a sku.
//If not ibmultiplesku Then
//	
//	ibSkuScanned = True
//	If dw_rma_serial.RowCOunt() > 0 Then
//		
//		isCurrentSKU = dw_rma_serial.GetItemString(1,'sku') 
//		
//		lsFind = " Upper(sku) = '" + Upper(isCurrentSKU) + "' and isnull(serial_no)" 
//		llFindRow = dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount() + 1) 
//		If llFindRow > 0 Then
//			llLineItemNo = dw_rma_serial.GetItemNumber(llFindRow,'Line_Item_no') 
//		else
//			llLineItemNo = dw_rma_serial.GetItemNumber(1,'Line_Item_no') 
//		end if
//		
//	End If
//	
//End If
//
//// Always check to see if a SKU has been scanned 
//lsFind = " Upper(sku) = '" + Upper(lsbarcode) + "'"
//llFindRow = dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount())
//
//If llFindRow > 0 Then /* a SKU was scanned*/
//		
//	//All SKU's are displayed (shared with Putaway DW) - Make sure this SKU requires scanning
//	If dw_rma_serial.GetITemString(llFindRow,'serialized_ind') = 'N' Then
//		doDisplayMessage("Validation Error","This SKU does not require serial entry.")
//		sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
//		Return
//	End If
//	
//	st_message.text = "SKU scanned. Please scan a Serial Number."
//	ibSkuScanned = True
//	isCurrentSKU = sle_Rma_barcode.Text 
//	
//Else /*Must be a serial Number*/
//	
//	If ibskuscanned Then /*sku already scanned, it's a serial # */
//	
//		//Check for Duplicates
//		lsFind = "Upper(sku) = '" + Upper(isCurrentSku) + "' and Upper(serial_no) = '" + Upper(lsBarcode) + "'"
//		If dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount()) > 0 Then
//			doDisplayMessage("Duplicates found","This Serial Number has already been scanned for this SKU")
//			sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
//			Return
//		End If
//		
//		//We want to match to the expected Serial Number - If we don't have a match set to empty.
//		// IF there is serial number in the expected row, we moved it there previously, move the existing to another empty and match the current scan to the expected row.
//		
//		lsFind = "Upper(sku) = '" + Upper(isCurrentSKU) + "' and Upper(exp_serial_no) = '" + Upper(lsBarcode) + "'"
//		llFindRow = dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount())
//		
//		If llFindRow > 0 Then
//			
//			If dw_rma_serial.GetITemString(llFindRow,'serial_no') = '-' or dw_rma_serial.GetITemString(llFindRow,'serial_no') = '' Then
//				
//				dw_rma_serial.SetITem(llFindRow,'serial_no',lsBarcode)
//				
//			Else /*previously not found Exp serial was placed in first empty which is now for a matching expected, move to another empty*/
//				
//				lsSerial = dw_rma_serial.GetITemString(llFindRow,'serial_no') /*save existing for  move */
//				dw_rma_serial.SetITem(llFindRow,'serial_no',lsBarcode) /*match scan with expected*/
//				ib_changed = True
//				
//				//Find Empty...
//				lsFind = "Upper(sku) = '" + Upper(isCurrentSKU) + "' and (serial_no = '-' or serial_no = '' or isnull(serial_no))"
//				llFindRow = dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount())
//				If llFindRow > 0 Then
//					dw_rma_serial.SetITem(llFindRow,'serial_no',lsSerial) /*set empty row with SN*/
//					ib_changed = True
//				Else /*all rows full for this SKU*/
//					doDisplayMessage("Validation Error","All Serial Numbers have been scanned for this SKU")
//					sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
//					Return
//				End If
//				
//			End If /* expected empty*/
//			
//		Else /*Expected Serial Not found, use first empty*/
//		
//			//Find Empty...
//			lsFind = "Upper(sku) = '" + Upper(isCurrentSKU) + "' and (serial_no = '-' or serial_no = '' or isnull(serial_no))"
//			llFindRow = dw_rma_serial.Find(lsFind,1,dw_rma_serial.RowCount())
//			If llFindRow > 0 Then
//				dw_rma_serial.SetITem(llFindRow,'serial_no',lsbarcode) /*set empty row with SN*/
//				ib_changed = True
//			Else /*all rows full for this SKU*/
//				doDisplayMessage("Validation Error","All Serial Numbers have been scanned for this SKU")
//				sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
//				Return
//			End If
//		
//		End If /*expected */
//		
//		//Validate Serial Number
//		IF gs_project = '3COM_NASH' THEN 
//			
//			
//			
//			if  iw_window.wf_coo_validation(dw_rma_serial,llFindRow) <> -1 then
//			
//				ls_Supplier = dw_rma_serial.GetItemString(llFindRow, "supp_code")
//			
//				wf_check_warranty(dw_rma_serial, isCurrentSKU, ls_Supplier, lsBarcode, llFindRow)
//			
//			end if
//					
//			
//		END IF
//	Else /* SKU not yet scanned, must scan SKU first */
//		
//		doDisplayMessage( "Validation Error","SKU Not found. Please scan a SKU.")
//			
//	End If
//	
//End If
//
//sle_rma_barcode.SetFocus()
//sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
//
//If llFindRow > 0 Then
//	dw_rma_serial.setRow(llFindRow)
//	dw_rma_serial.scrollToRow(llFindRow)
//End If
end event

on tabpage_rma_serial.create
this.cb_delete_row=create cb_delete_row
this.cb_copy_row=create cb_copy_row
this.rb_auto=create rb_auto
this.rb_manual=create rb_manual
this.st_message=create st_message
this.sle_rma_barcode=create sle_rma_barcode
this.dw_rma_serial=create dw_rma_serial
this.gb_1=create gb_1
this.Control[]={this.cb_delete_row,&
this.cb_copy_row,&
this.rb_auto,&
this.rb_manual,&
this.st_message,&
this.sle_rma_barcode,&
this.dw_rma_serial,&
this.gb_1}
end on

on tabpage_rma_serial.destroy
destroy(this.cb_delete_row)
destroy(this.cb_copy_row)
destroy(this.rb_auto)
destroy(this.rb_manual)
destroy(this.st_message)
destroy(this.sle_rma_barcode)
destroy(this.dw_rma_serial)
destroy(this.gb_1)
end on

type cb_delete_row from commandbutton within tabpage_rma_serial
integer x = 2235
integer y = 44
integer width = 352
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//2-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//Delete Serial Records and update QTY on appropriate putaway records

string ls_sku, ls_loc, ls_pono, ls_pono2, lsFind

long ll_row, ll_idno, ll_lineno, ll_qty, llFindRow

ll_row =idw_rma_serial.getrow( )

IF ll_row > 0 THEN
	
	ls_sku = idw_rma_serial.getItemString( ll_row, 'sku')
	ls_loc = idw_rma_serial.getItemString( ll_row, 'l_code')
	ls_pono = idw_rma_serial.getItemString( ll_row, 'po_no')
	ls_pono2 = idw_rma_serial.getItemString( ll_row, 'po_no2')
	ll_lineno = idw_rma_serial.getItemNumber( ll_row, 'line_item_no')
	ll_idno = idw_rma_serial.getItemNumber( ll_row, 'Id_No')
	
	//find appropriate putaway record
	lsFind = "sku ='"+ls_sku+"' and l_code='"+ls_loc+"' and Po_No='"+ls_pono+"' and Line_Item_No="+string(ll_lineno)+" and Id_No="+string(ll_idno)+""
	llFindRow = idw_putaway.find( lsFind, 1, idw_putaway.rowcount())
	
	IF llFindRow > 0 THEN
		ll_qty = idw_putaway.getItemNumber(llFindRow, 'Quantity')
		idw_putaway.setItem( llFindRow, 'Quantity', ll_qty -1)

		idw_rma_serial.deleterow( ll_row) //Delete Serial Record
		
		ll_qty = idw_putaway.getItemNumber(llFindRow, 'Quantity')
		IF ll_qty =0 THEN idw_putaway.deleterow(llFindRow) //Delete '0' Qty Putaway Record			
		
	END IF
	
	ib_Changed = True	
END IF
end event

type cb_copy_row from commandbutton within tabpage_rma_serial
integer x = 1737
integer y = 44
integer width = 352
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&CopyRow"
end type

event clicked;idw_rma_serial.triggerevent( "ue_copy_serial")
end event

type rb_auto from radiobutton within tabpage_rma_serial
boolean visible = false
integer x = 50
integer y = 108
integer width = 389
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "&Auto Entry"
end type

event clicked;message.StringParm = 'barcode'
Parent.TriggerEvent("ue_mode_switch")
end event

type rb_manual from radiobutton within tabpage_rma_serial
boolean visible = false
integer x = 50
integer y = 44
integer width = 425
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "&Manual Entry"
end type

event clicked;message.StringParm = 'Manual'
Parent.TriggerEvent("ue_mode_switch")
end event

type st_message from statictext within tabpage_rma_serial
boolean visible = false
integer x = 32
integer y = 208
integer width = 3328
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_rma_barcode from singlelineedit within tabpage_rma_serial
boolean visible = false
integer x = 530
integer y = 28
integer width = 951
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;Parent.TriggerEvent("ue_process_barcodes")

If rb_auto.Checked Then
	This.SetFocus()
	This.SelectText(1,len(This.Text))
End IF
end event

type dw_rma_serial from u_dw_ancestor within tabpage_rma_serial
event ue_set_column ( )
event ue_clear_serial_no ( )
event type integer ue_copy_serial ( )
integer x = 32
integer y = 300
integer width = 3346
integer height = 1300
integer taborder = 60
string dataobject = "d_ro_putaway_Serial"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_set_column();This.SetColumn(isSetColumn)
end event

event ue_clear_serial_no();
this.SetItem(This.GetRow(),'Serial_no','-')
end event

event type integer ue_copy_serial();//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//copy serial records

string ls_scroll_find
int i
long ll_curr_row, ll_scroll_find_row, ll_putaway_qty, ll_required_rows
str_parms lstr_parms

IF idw_rma_serial.accepttext( ) = -1 Then Return -1

ll_curr_row = idw_rma_serial.getrow( )

IF ll_curr_row > 0 THEN
	
	lstr_parms.decimal_arg[1]  =idw_rma_serial.getItemNumber(ll_curr_row, 'Serial_Qty')
	OpenwithParm(w_ro_copy_putaway, lstr_parms)
	lstr_parms =message.powerobjectparm
	
	IF lstr_parms.cancelled THEN Return 1 //Don't copy row, if cancelled from prompt
	this.setredraw( false)
	
	ll_putaway_qty =  idw_rma_serial.getItemNumber( ll_curr_row, 'Quantity')
	ll_required_rows = lstr_parms.long_arg[1]
	
	//shouldn't add more records than required putaway qty
	IF ll_putaway_qty <  ll_required_rows THEN
		MessageBox(is_title, "You can't copy more serial no's records ("+string(ll_required_rows)+") than Required Qty ("+string(ll_putaway_qty)+") !", StopSign!)
		Return -1
	END IF
	
	idw_rma_serial.setItem( ll_curr_row, 'Serial_Qty', lstr_parms.decimal_arg[1] )
	
	FOR i = 1 to (lstr_parms.long_arg[1] -1)
		
		idw_rma_serial.rowscopy( ll_curr_row, ll_curr_row, Primary!, idw_rma_serial, idw_rma_serial.rowcount()+1, Primary!)
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Ro_No', idw_rma_serial.getItemString( ll_curr_row, 'Ro_No'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'SKU', idw_rma_serial.getItemString( ll_curr_row, 'SKU'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Description', idw_rma_serial.getItemString( ll_curr_row, 'Description'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Supp_code', idw_rma_serial.getItemString( ll_curr_row, 'Supp_code'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Owner_ID', idw_rma_serial.getItemNumber( ll_curr_row, 'Owner_ID'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Country_of_Origin', idw_rma_serial.getItemString( ll_curr_row, 'Country_of_Origin'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Line_Item_no', idw_rma_serial.getItemNumber( ll_curr_row, 'Line_Item_no'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'L_Code', idw_rma_serial.getItemString( ll_curr_row, 'L_Code'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Lot_No', idw_rma_serial.getItemString( ll_curr_row, 'Lot_No'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Inventory_Type', idw_rma_serial.getItemString( ll_curr_row, 'Inventory_Type'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Quantity', idw_rma_serial.getItemNumber( ll_curr_row, 'Quantity'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Serial_Qty', idw_rma_serial.getItemNumber( ll_curr_row, 'Serial_Qty'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'PO_No', idw_rma_serial.getItemString( ll_curr_row, 'PO_No'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'PO_No2', idw_rma_serial.getItemString( ll_curr_row, 'PO_No2'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Expiration_Date', idw_rma_serial.getItemDateTime( ll_curr_row, 'Expiration_Date'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'container_ID', idw_rma_serial.getItemString( ll_curr_row, 'container_ID'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Serial_No', '-')
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Id_No', idw_rma_serial.getItemNumber( ll_curr_row, 'Id_No'))

		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Owner_Cd', idw_rma_serial.getItemString( ll_curr_row, 'Owner_Cd'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Owner_Type', idw_rma_serial.getItemString( ll_curr_row, 'Owner_Type'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'c_owner_name', idw_rma_serial.getItemString( ll_curr_row, 'c_owner_name'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Lot_Controlled_Ind', idw_rma_serial.getItemString( ll_curr_row, 'Lot_Controlled_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'PO_Controlled_Ind', idw_rma_serial.getItemString( ll_curr_row, 'PO_Controlled_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'PO_NO2_Controlled_Ind', idw_rma_serial.getItemString( ll_curr_row, 'PO_NO2_Controlled_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'expiration_Controlled_Ind', idw_rma_serial.getItemString( ll_curr_row, 'expiration_Controlled_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'container_tracking_Ind', idw_rma_serial.getItemString( ll_curr_row, 'container_tracking_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Serialized_Ind', idw_rma_serial.getItemString( ll_curr_row, 'Serialized_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'GRP', idw_rma_serial.getItemString( ll_curr_row, 'GRP'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Weight_1', idw_rma_serial.getItemNumber( ll_curr_row, 'Weight_1'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'IM_User_Field4', idw_rma_serial.getItemString( ll_curr_row, 'IM_User_Field4'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'item_master_user_field14', idw_rma_serial.getItemString( ll_curr_row, 'item_master_user_field14'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'item_master_user_field18', idw_rma_serial.getItemString( ll_curr_row, 'item_master_user_field18'))
				
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'SKU_Parent', idw_rma_serial.getItemString( ll_curr_row, 'SKU_Parent'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Component_Ind', idw_rma_serial.getItemString( ll_curr_row, 'Component_Ind'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Component_No', idw_rma_serial.getItemNumber( ll_curr_row, 'Component_No'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Line_Item_No', idw_rma_serial.getItemString( ll_curr_row, 'User_Line_Item_No'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field1', idw_rma_serial.getItemString( ll_curr_row, 'User_Field1'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field2', idw_rma_serial.getItemString( ll_curr_row, 'User_Field2'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field3', idw_rma_serial.getItemString( ll_curr_row, 'User_Field3'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field4', idw_rma_serial.getItemString( ll_curr_row, 'User_Field4'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field5', idw_rma_serial.getItemString( ll_curr_row, 'User_Field5'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field6', idw_rma_serial.getItemString( ll_curr_row, 'User_Field6'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field7', idw_rma_serial.getItemString( ll_curr_row, 'User_Field7'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field8', idw_rma_serial.getItemString( ll_curr_row, 'User_Field8'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field9', idw_rma_serial.getItemString( ll_curr_row, 'User_Field9'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field10', idw_rma_serial.getItemString( ll_curr_row, 'User_Field10'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field11', idw_rma_serial.getItemString( ll_curr_row, 'User_Field11'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field12', idw_rma_serial.getItemString( ll_curr_row, 'User_Field12'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'User_Field13', idw_rma_serial.getItemString( ll_curr_row, 'User_Field13'))
		idw_rma_serial.setItem(idw_rma_serial.rowcount(), 'Content_Record_Created_Ind', idw_rma_serial.getItemString( ll_curr_row, 'Content_Record_Created_Ind'))
	
	NEXT
	
	ib_Changed = True
	
	this.setredraw( true)
	this.sort( )
	this.setrow( ll_curr_row)
	this.scrolltorow( ll_curr_row)
END IF

If ib_Changed and this.find( "serial_no = '-'", 0, this.rowcount( )) = 0 Then
	MessageBox(is_title, "Please save your changes first!")
	Return 0
End If

Return 1

end event

event clicked;call super::clicked;if ib_changed and this.find( "serial_no = '-'", 0, this.rowcount( )) = 0 then
	Messagebox(is_title,"Please save your changes first!")
	Return 1
End If
		
SetPointer(Hourglass!)

If rb_auto.Checked Then
	sle_rma_barcode.SetFocus()
	sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
End IF
end event

event scrollvertical;call super::scrollvertical;If rb_auto.Checked Then
	sle_rma_barcode.SetFocus()
	sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
End IF
end event

event retrievestart;call super::retrievestart;//Multiple retrieves to fill DW
this.reset( )
this.setredraw( true)
Return 2
end event

event constructor;call super::constructor;this.setredraw( true)
This.SetRowFocusIndicator(Hand!)


end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event itemchanged;call super::itemchanged;integer li_Rc
string ls_Supplier

ib_Changed = True

Choose Case Upper(dwo.Name)
		
	
		
	Case 'SERIAL_NO'
		
		li_Rc = wf_coo_validation(This,row) 
		
		If li_Rc < 0 Then
			This.PostEvent('ue_clear_serial_no')
		End If
			
		If li_Rc <> -1 then
		
			ls_Supplier = dw_rma_serial.GetItemString(row, "supp_code")
		
	 		wf_check_warranty(dw_rma_serial, this.GetItemString( row, "sku"), ls_Supplier, data, row)

		End if	
			
	End Choose
end event

event getfocus;call super::getfocus;If rb_auto.Checked Then
	sle_rma_barcode.SetFocus()
	sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
End IF
end event

event itemerror;call super::itemerror;Return 2
end event

event rowfocuschanged;call super::rowfocuschanged;If rb_auto.Checked Then
	sle_rma_barcode.SetFocus()
	sle_rma_barcode.SelectText(1,len(sle_rma_barcode.Text))
End IF
end event

event doubleclicked;call super::doubleclicked;//3-APR-2019 :Madhu SS31781 F14974 Putaway Serial RollUp
//double click on serial no records for manual insert.

str_parms	lstrparms
string	ls_sku, ls_desc, ls_loc, ls_lotno, ls_pono, ls_pono2, ls_container_id, ls_find
long	ll_findrow, ll_line_item_no, ll_idno

If row > 0 Then

	// 06/15 - PCONKL - If content has already been written for this row, don't allow any mods. Easiest to just get out here
	IF this.getItemString(row,'content_record_created_ind') = 'Y' Then Return
	
	//get attributes
	ls_sku = this.getItemString(row, 'sku')
	ls_desc = this.getItemString(row, 'description')
	ll_line_item_no = this.getItemNumber(row, 'line_item_no')
	ls_loc = this.getItemString(row, 'l_code')
	ls_lotno = this.getItemString(row, 'lot_no')
	ls_pono= this.getItemString(row, 'po_no')
	ls_pono2 = this.getItemString(row, 'po_no2')
	ls_container_id = this.getItemString(row, 'container_id')
	ll_idno = this.getItemNumber(row, 'id_no')
	If IsNull(ll_idno) Then
		ls_find ="sku='"+ls_sku+"' and line_item_no="+string(ll_line_item_no)+" and l_code='"+ls_loc+"'" +&
				" and lot_no='"+ls_lotno+"' and po_no='"+ls_pono+"'" +&
				" and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
						
		ll_findrow = idw_putaway.find( ls_find, 0, idw_putaway.rowcount())	
		If ll_findrow > 0 Then
			ll_idno = idw_putaway.GetItemNumber(ll_findrow,'id_no')
		End If
	End If
	
	Choose Case dwo.Name
		case "serial_no"
			
			If ib_Changed Then
				Messagebox(is_title,'Please save your changes first.')
				Return
			End IF

			IF (this.getItemString(row,'serialized_ind') = 'Y' or this.getItemString(row,'serialized_ind') = 'B') and & 
				 Upper(idw_main.object.ord_status[1])	<> 'C' THEN
				 	this.setredraw(false)
					i_nwarehouse.of_ro_serial_nos(idw_rma_serial, row)
					ib_changed = True

					this.setredraw(true)
					this.setfocus()
					
					//assign missing attribute values against newly created serial records.
					ls_find ="sku='"+ls_sku+"' and line_item_no="+string(ll_line_item_no)+" and l_code='"+ls_loc+"'" +&
						" and lot_no='"+ls_lotno+"' and po_no='"+ls_pono+"'" +&
						" and po_no2='"+ls_pono2+"' and container_id='"+ls_container_id+"'"
						
					ll_findrow = this.find( ls_find, 0, this.rowcount())	
					
					DO WHILE ll_findrow > 0 
						this.setItem( ll_findrow, 'description', ls_desc)
						this.setItem( ll_findrow, 'id_no', ll_idno)
						
						ll_findrow = this.find( ls_find, ll_findrow+1, this.rowcount()+1)
					LOOP
					
					this.sort( )
  	 		END IF
	End Choose
	
	ib_Changed = True
END IF
end event

type gb_1 from groupbox within tabpage_rma_serial
boolean visible = false
integer x = 32
integer width = 480
integer height = 196
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type dw_scanner from datawindow within w_ro
boolean visible = false
integer y = 1284
integer width = 2103
integer height = 556
integer taborder = 20
boolean titlebar = true
string title = "Assign Scanner ID:"
string dataobject = "d_scanner"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_custom_report from datawindow within w_ro
boolean visible = false
integer x = 3890
integer y = 1204
integer width = 690
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_export_inbound_wspr"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

