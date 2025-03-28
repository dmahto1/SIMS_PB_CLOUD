$PBExportHeader$w_owner_change.srw
$PBExportComments$*+  warehouse transfer
forward
global type w_owner_change from w_std_master_detail
end type
type cb_readonly from commandbutton within tabpage_main
end type
type cb_set_new from commandbutton within tabpage_main
end type
type st_2 from statictext within tabpage_main
end type
type sle_orderno from singlelineedit within tabpage_main
end type
type cb_confirm from commandbutton within tabpage_main
end type
type cb_void from commandbutton within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_search from datawindow within tabpage_search
end type
type cb_clear from commandbutton within tabpage_search
end type
type dw_result from u_dw_ancestor within tabpage_search
end type
type tabpage_detail from userobject within tab_main
end type
type cb_replace_boxid from commandbutton within tabpage_detail
end type
type st_1 from statictext within tabpage_detail
end type
type dw_transfer_detail_content_append from u_dw_ancestor within tabpage_detail
end type
type dw_content_append from u_dw_ancestor within tabpage_detail
end type
type p_1 from picture within tabpage_detail
end type
type cb_1 from commandbutton within tabpage_detail
end type
type sle_update_to from singlelineedit within tabpage_detail
end type
type cb_update_to from commandbutton within tabpage_detail
end type
type p_arrow from picture within tabpage_detail
end type
type cb_reset from commandbutton within tabpage_detail
end type
type cb_insert1 from commandbutton within tabpage_detail
end type
type cb_delete from commandbutton within tabpage_detail
end type
type dw_content from u_dw_ancestor within tabpage_detail
end type
type dw_transfer_detail_content from u_dw_ancestor within tabpage_detail
end type
type dw_trans_detail_content from u_dw_ancestor within tabpage_detail
end type
type dw_detail from u_dw_ancestor within tabpage_detail
end type
type tabpage_detail from userobject within tab_main
cb_replace_boxid cb_replace_boxid
st_1 st_1
dw_transfer_detail_content_append dw_transfer_detail_content_append
dw_content_append dw_content_append
p_1 p_1
cb_1 cb_1
sle_update_to sle_update_to
cb_update_to cb_update_to
p_arrow p_arrow
cb_reset cb_reset
cb_insert1 cb_insert1
cb_delete cb_delete
dw_content dw_content
dw_transfer_detail_content dw_transfer_detail_content
dw_trans_detail_content dw_trans_detail_content
dw_detail dw_detail
end type
type tabpage_serial from userobject within tab_main
end type
type cb_serial_barcode from commandbutton within tabpage_serial
end type
type dw_serial from u_dw_ancestor within tabpage_serial
end type
type cb_serial_delete from commandbutton within tabpage_serial
end type
type cb_serial_generate from commandbutton within tabpage_serial
end type
type tabpage_serial from userobject within tab_main
cb_serial_barcode cb_serial_barcode
dw_serial dw_serial
cb_serial_delete cb_serial_delete
cb_serial_generate cb_serial_generate
end type
type tabpage_alt_serial_capture from userobject within tab_main
end type
type cb_alt_serisl_capture_clear from commandbutton within tabpage_alt_serial_capture
end type
type cb_generate from commandbutton within tabpage_alt_serial_capture
end type
type cb_save_parent_changes from commandbutton within tabpage_alt_serial_capture
end type
type cb_print_parent_labels from commandbutton within tabpage_alt_serial_capture
end type
type dw_alt_serial_child_list from u_dw_ancestor within tabpage_alt_serial_capture
end type
type dw_soc_alt_serial_capture_save from u_dw_ancestor within tabpage_alt_serial_capture
end type
type dw_alt_serial_owner_change_detail from u_dw_ancestor within tabpage_alt_serial_capture
end type
type st_alt_serial_me from statictext within tabpage_alt_serial_capture
end type
type dw_alt_serial_parent from u_dw_ancestor within tabpage_alt_serial_capture
end type
type dw_alt_serial_child from u_dw_ancestor within tabpage_alt_serial_capture
end type
type tabpage_alt_serial_capture from userobject within tab_main
cb_alt_serisl_capture_clear cb_alt_serisl_capture_clear
cb_generate cb_generate
cb_save_parent_changes cb_save_parent_changes
cb_print_parent_labels cb_print_parent_labels
dw_alt_serial_child_list dw_alt_serial_child_list
dw_soc_alt_serial_capture_save dw_soc_alt_serial_capture_save
dw_alt_serial_owner_change_detail dw_alt_serial_owner_change_detail
st_alt_serial_me st_alt_serial_me
dw_alt_serial_parent dw_alt_serial_parent
dw_alt_serial_child dw_alt_serial_child
end type
type dw_report from datawindow within w_owner_change
end type
end forward

global type w_owner_change from w_std_master_detail
integer width = 4969
integer height = 2180
string title = "Stock Owner Change"
event ue_confirm ( )
event ue_deleterow ( )
event ue_search ( )
event ue_pick_pallet ( )
event ue_move_pallet ( )
event ue_print_pallet_labels ( )
event ue_pick_mixed ( )
event ue_post_confirm ( )
dw_report dw_report
end type
global w_owner_change w_owner_change

type variables
Datawindow   idw_main, idw_search,idw_result
Datawindow idw_detail		//,idw_content
SingleLineEdit isle_code
String is_org_sql,isFromLocSql,istoLocSql, isFromLocContSql
w_owner_change iw_window
datawindowchild idwc_det_supplier
n_warehouse i_nwarehouse
Integer ii_ret
boolean ib_access=False
boolean ib_new_search
boolean ib_selection_changing
boolean ib_transfer_from_first
boolean ib_transfer_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_error , ibFWDPickPending
boolean ibSerialModified, ibConfirmed
boolean ib_Duplicated, ib_Invalid_Data, ib_processed_at_least_one, ib_alt_serial_error
boolean ib_Serialized, ib_Serial_Validated
boolean ib_SetNewFlag  //05/04/2010 ujh:  In ue_save, this will alert that the save came following setting by cb_Set_New
boolean ib_SetSerialFlag	//gwm - 2019-11-07 Reset serial flag and dono in serial number inventory on set to new
boolean ib_SerialDeleted,ibFootprint //dts - 2014-05-05 (deleted serials weren't being saved).
integer  ii_Duplicate_Row_Number, ii_Invalid_Data_Row_Number, ii_Error_Row_Number
string	   is_Duplicate_Error_Message, is_Invalid_Data_Error_Message,  is_Error_Error_Message
// pvh 09/16/05
datastore idsFromLocations, idsFromLocationsContainer
u_ds_ancestor idsSerialInventory
long ilOwnerid
string isOrderNo
long colorMint,il_DblClkPickRow,il_SingleBoxIdSwap,il_CountNotScanned,il_ContainerTracked

string isOrderStatus,isSelSku,is_tono
string isToNo
string isWarehouse

//TimA 04/28/14 Pandore issue #36
String isDetailRecordsToReConfirm

//?constant integer success = 0
//?constant integer failure = -1

Datawindow idw_content_append
Datawindow idw_transfer_detail_content_append
Datawindow idw_transfer_detail_content
Datawindow idw_serial

boolean ib_display_unique_item_error_message
Boolean ibkeytype =FALSE //17-Aug-2015 :Madhu- Added code to prevent Manual Scanning
Boolean ibmouseclick =FALSE //17-Aug-2015 :Madhu- Added code to prevent Manual Scanning
Boolean ibPressF10Unlock =FALSE //17-Aug-2015 :Madhu- Added to prevent Manul scanning
boolean ibSplitContainerRequired

//dts - 2015-12-21 - for refreshing the TO locations drop-down
long il_ToLocListOwner 
string is_ToLocListWarehouse, is_ToLocListPONO, is_ToLocListSKU, is_ToLocListSerialized,is_order_new,is_display_name

boolean ibSingleProjectTurnedOn //to toggle the single-project rule for serialized GPNs
boolean isValidated =FALSE //08-JUNE-2017 :Madhu PEVS-428 - SOC Allow Commingle Validation for Serialized /Non-Serialized Items.
int iiContainerChecked = 0 		//GailM 08/22/2018 Footprint container checked indicator

string isPallet, isContainer, isWhCode, isinvoice_no, isColorCode, isMixedType
int ilCurrPickRow
long ilNbrContainers, ilTotAvailQty,il_userspid,il_find_matchW,il_find_matchR
boolean ibFootprintAlloc = FALSE
int iiFootprintBreakRequired = 0
Boolean ibPharmacyProcessing		//GailM 12/02/2019 Add check for Pharmacy Processing
end variables

forward prototypes
public subroutine wf_clear_screen ()
public function integer wf_validation ()
public subroutine wf_checkstatus ()
public function integer wf_confirm ()
public subroutine dotransferall (long detailrow)
public function string getfromlocationsql ()
public subroutine setqtyalldisplay (boolean abool)
public subroutine setownerid (long aid)
public function long getownerid ()
protected function integer dopickdata (string assku, string assuppliercode, long detailrow)
public function boolean checkforconfirmed ()
public subroutine setordernumber (string asordernbr)
public function string getordernumber ()
public function boolean checkforduplicates (long row2check)
public function long dofromfilter (string _filter)
public subroutine setorderstatus (string _value)
public subroutine settono (string _value)
public subroutine setwarehouse (string _value)
public function string getorderstatus ()
public function string gettono ()
public function string getwarehouse ()
public function integer doopentransfersearch ()
public function boolean checkforchanges ()
public function datastore getrolleduptransactions (datastore ads)
public subroutine setcolormint ()
public function long getcolormint ()
public subroutine dotransferallcontainer (integer detailrow)
public function string getfromlocationcontainersql ()
public subroutine wf_insert_row ()
public function integer wf_check_process ()
public function integer validate_serializeed_parents_children ()
private function boolean f_lockserialnumber (ref boolean ab_locked)
public function integer wf_update_content ()
public function boolean wf_is_detail_complete ()
public function boolean wf_is_detail_row_serialized ()
public function boolean wf_serial_numbers_validated ()
protected function boolean wf_select_reconfirm_records (string as_orderno)
public function integer wf_batch_validate (string astono)
public function integer wf_commingle_validation (string as_sku, long al_new_ownerid, string as_new_pono, string as_dwhcode, string as_toloc, string as_serializedind)
public function integer wf_check_full_pallet_container ()
public function integer wf_is_footprint_pallet_allocated (string aspallet, string aswhcode, string assku, long althisalloc)
public function boolean wf_is_detail_row_serialized (integer aidetailrow)
public function integer wf_reset_serial_flag (string asdono)
public subroutine wf_check_container_scanned ()
public subroutine wf_soc_order_readonly (boolean ab_read)
end prototypes

event ue_deleterow();// ue_deleterow()
int returncode
long test



returncode = idw_detail.deleterow( idw_detail.getrow() )

//test = idw_detail.deletedcount()

//if idw_detail.rowcount() = 0 then event ue_delete()
end event

event ue_search();// ue_search

end event

event ue_pick_pallet();//GailM 8/6/2018 S222208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers

String lsSKU, lsFind, lsFilter
Int liRow, liFound, liRC
Long llReqQty
Datastore ldsFromPallet, ldsToPallet, ldsOwnerChangeDetail
Str_parms	lstrParms

ldsFromPallet = Create datastore
ldsFromPallet.dataobject = 'd_pick_pallet'
ldsFromPallet.SetTransObject(SQLCA)

ldsToPallet = Create datastore
ldsToPallet.dataobject = 'd_pick_pallet'
ldsToPallet.SetTransObject(SQLCA)

ldsOwnerChangeDetail = Create datastore
ldsOwnerChangeDetail.dataobject = 'd_owner_change_detail'
ldsOwnerChangeDetail.SetTransObject(SQLCA)

idw_detail.Rowscopy( ilCurrPickRow, ilCurrPickRow, Primary!, ldsOwnerChangeDetail, 1, Primary!)

lsSKU = idw_detail.GetItemString(ilCurrPickRow, "SKU" )
llReqQty = idw_detail.GetItemNumber( ilCurrPickRow, "quantity" )

ldsFromPallet.Retrieve( isPallet )
lsFilter = "carton_id = '" + isContainer + "' "
ldsFromPallet.SetFilter( lsFilter )
ldsFromPallet.filter( )

	lstrparms.String_Arg[1] = isPallet
	lstrparms.String_Arg[2] = isContainer
	lstrparms.String_Arg[3] = isinvoice_no
	lstrparms.String_Arg[4] = isWhCode
	lstrparms.String_Arg[5] = 'SOC'			//Order type Stock Owner Change
	lstrparms.String_Arg[6] = isColorCode
	lstrparms.String_Arg[7] = isMixedType
	lstrparms.String_Arg[8] = idw_detail.GetItemString(ilCurrPickRow, "s_location")
	
	lstrparms.integer_arg[1] = ilCurrPickRow
	lstrparms.Boolean_arg[1] = ibPharmacyProcessing		//Future processing of Pharmacy individual serial numbers
	lstrparms.Long_Arg[1] = llReqQty
	lstrparms.Long_arg[2] = idw_detail.GetItemNumber(ilCurrPickRow, "quantity")	//DE12642
	
	ldsFromPallet.SetFilter("")
	ldsFromPallet.filter( )

	
	lstrparms.Datastore_Arg[1] = ldsFromPallet
	lstrparms.Datastore_Arg[2] = ldsToPallet
	lstrparms.Datastore_Arg[3] = ldsOwnerChangeDetail
	lstrparms.Datawindow_Arg[1] = idw_detail
	lstrparms.Datawindow_Arg[2] = idw_transfer_detail_content
	
	OpenWithParm(w_pick_pallet, lstrparms)
	
ldsFromPallet = lstrparms.Datastore_Arg[1]
ldsToPallet = lstrparms.Datastore_Arg[2]



end event

event ue_move_pallet();//GailM 6/25/2018 S20849 F8117 I1026 Google - SIMS - Footprints - Movements of partial containers
//GailM 11/20/2018 DE7355 Move extra contains from a pallet when not all containers are being shipped to maintain full pallet integrity
//We are expecting the color_code on each pick row to be "6" which indicates this is a full container from the pallet and will be exempt from pallet id change
String lsFind, lsMessage
String lsContainers[], lsMoveContainers[]
String lsContainer, lsNewPallet, lsSKU
String lsOrderType, lsToNo, isInvoiceNo
Long llAdjustNo
Int liPickRows, liPickRow, liContentRows, liContentRow, liContainerRows, liContainerRow, liExists, liMoveNbr
Int liContentSummaryRow, liContentSummaryRows, liFound, liModified
Int liSerialRow, liSerialRows, liTotalSerialsChanged, liMoveRow, liMoveRows, aiRC, aiRec, liRC
datastore ldsAdjustment, ldsNewContentSummary,ldsSerial, ldsContent
datetime ldtToday

lsToNo = idw_main.GetItemString(1, "to_no")
isInvoiceNo = idw_main.GetItemString(1, "to_no")		//Use to_no for stock transfer
isWhCode = idw_main.GetItemString(1, "s_warehouse")
ldtToday = f_getLocalWorldTime( isWhCode ) 

//Get containers to remain in pallet
liPickRows = idw_detail.rowcount()
For liPickRow = 1 to liPickRows
	If idw_detail.GetItemString(liPickRow,"po_no2") = isPallet Then
		lsContainers[liPickRow] = idw_detail.GetItemString(liPickRow, "container_id")
		lsSKU = idw_detail.GetItemString(liPickRow, "sku")
	End If
Next

liContainerRows = UpperBound(lsContainers)
liMoveNbr = 1
liTotalSerialsChanged = 0

ldsNewContentSummary = Create u_ds_ancestor
ldsNewContentSummary.dataobject = 'd_content_summary_pallet'
ldsNewContentSummary.SetTransObject(SQLCA)

ldsContent = Create u_ds_ancestor
ldsContent.dataobject = 'd_content_pallet'
ldsContent.SetTransObject(SQLCA)

ldsSerial = Create datastore
ldsSerial.dataobject = 'd_serial_container'
ldsSerial.SetTransObject(SQLCA)

ldsAdjustment = Create u_ds_ancestor
ldsAdjustment.dataobject =  'd_container_adjustment'
ldsAdjustment.SetTransObject(SQLCA)

ldsAdjustment.Reset( )

liContentSummaryRows = ldsNewContentSummary.Retrieve( gs_project, isWhCode, lsSKU, isPallet, isContainer, gsFootprintBlankInd)		//All content summary rows for the pallet
liContentRows = ldsContent.Retrieve( gs_project, isWhCode, lsSKU, isPallet)		//All content rows for the pallet

For liContentSummaryRow = 1 to liContentSummaryRows 
	lsContainer = ldsNewContentSummary.GetItemString(liContentSummaryRow, "container_id")
	liExists = 0
	For liContainerRow = 1 to liContainerRows
		If lsContainers[liContainerRow] = lsContainer Then
			liExists = 1
			Continue
		End If
	Next
	If liExists = 0 Then 
		lsMoveContainers[liMoveNbr] = lsContainer
		liMoveNbr ++
	End If
Next

sqlca.sp_check_digit_build(gs_project,"SSCC_No", "" , 0 , lsNewPallet ) 

liMoveRows = UpperBound(lsMoveContainers)
liSerialRows = ldsSerial.Retrieve( gs_project, isWhCode, lsSKU, isPallet)

For liMoveRow = 1 to liMoveRows
	lsContainer = lsMoveContainers[liMoveRow]
	lsFind = "container_id = '" + lsContainer + "' "
	aiRec = ldsNewContentSummary.Find(lsFind, 1, liContentSummaryRows)
	liFound = ldsContent.Find(lsFind, 1, liContentRows)
	If aiRec > 0 and liFound > 0 Then
		ldsNewContentSummary.SetItem(aiRec, "po_no2", lsNewPallet)
		ldsContent.SetItem(liFound, "po_no2", lsNewPallet)
		
		/* Populate the adjustment with content summary record */
		aiRC = ldsAdjustment.InsertRow(0)
		ldsAdjustment.SetItem( aiRC, "project_id", ldsNewContentSummary.GetItemString( aiRec, "project_id" ))
		ldsAdjustment.SetItem( aiRC, "sku", ldsNewContentSummary.GetItemString( aiRec, "sku" ))
		ldsAdjustment.SetItem( aiRC, "supp_code", ldsNewContentSummary.GetItemString( aiRec, "supp_code" ))
		ldsAdjustment.SetItem( aiRC, "owner_id", ldsNewContentSummary.GetItemNumber( aiRec, "owner_id" ))
		ldsAdjustment.SetItem( aiRC, "old_owner", ldsNewContentSummary.GetItemNumber( aiRec, "owner_id" ))
		ldsAdjustment.SetItem( aiRC, "country_of_origin", ldsNewContentSummary.GetItemString( aiRec, "country_of_origin" ))
		ldsAdjustment.SetItem( aiRC, "old_country_of_origin", ldsNewContentSummary.GetItemString( aiRec, "country_of_origin" ))
		ldsAdjustment.SetItem( aiRC, "wh_code", ldsNewContentSummary.GetItemString( aiRec, "wh_code" ))
		ldsAdjustment.SetItem( aiRC, "l_code", ldsNewContentSummary.GetItemString( aiRec, "l_code" ))
		ldsAdjustment.SetItem( aiRC, "inventory_type", ldsNewContentSummary.GetItemString( aiRec, "inventory_type" ))
		ldsAdjustment.SetItem( aiRC, "old_inventory_type", ldsNewContentSummary.GetItemString( aiRec, "inventory_type" ))
		ldsAdjustment.SetItem( aiRC, "serial_no", ldsNewContentSummary.GetItemString( aiRec, "serial_no" ))
		ldsAdjustment.SetItem( aiRC, "lot_no", ldsNewContentSummary.GetItemString( aiRec, "lot_no" ))
		ldsAdjustment.SetItem( aiRC, "old_lot_no", ldsNewContentSummary.GetItemString( aiRec, "lot_no" ))
		ldsAdjustment.SetItem( aiRC, "ro_no", ldsNewContentSummary.GetItemString( aiRec, "ro_no" ))
		ldsAdjustment.SetItem( aiRC, "po_no", ldsNewContentSummary.GetItemString( aiRec, "po_no" ))
		ldsAdjustment.SetItem( aiRC, "old_po_no", ldsNewContentSummary.GetItemString( aiRec, "po_no" ))
		ldsAdjustment.SetItem( aiRC, "po_no2", lsNewPallet )
		ldsAdjustment.SetItem( aiRC, "old_po_no2", isPallet )
		ldsAdjustment.SetItem( aiRC, "old_quantity",  ldsNewContentSummary.GetItemNumber( aiRec, "avail_qty" ))
		ldsAdjustment.SetItem( aiRC, "quantity", ldsNewContentSummary.GetItemNumber( aiRec, "avail_qty" ))
		ldsAdjustment.SetItem( aiRC, "reason", "Pallet Split")
		ldsAdjustment.SetItem( aiRC, "ref_no", lsToNo)
		ldsAdjustment.SetItem( aiRC, "adjustment_type", "900")
		ldsAdjustment.SetItem( aiRC, "last_user", gs_userid)
		ldsAdjustment.SetItem( aiRC, "last_update", ldtToday)
		ldsAdjustment.SetItem( aiRC, "container_id", ldsNewContentSummary.GetItemString( aiRec, "container_id" ))
		ldsAdjustment.SetItem( aiRC, "expiration_date", ldsNewContentSummary.GetItemString( aiRec, "expiration_date" ))
		ldsAdjustment.SetItem( aiRC, "old_expiration_date", ldsNewContentSummary.GetItemString( aiRec, "expiration_date" ))
	
		// Update po_no2 in serial table
		For liSerialRow = 1 to liSerialRows
			If ldsSerial.GetItemString(liSerialRow, "carton_id") = lsContainer Then
				ldsSerial.SetItem(liSerialRow, "po_no2", lsNewPallet)
				ldsSerial.SetItem(liSerialRow, "update_date", ldtToday)
				ldsSerial.SetItem(liSerialRow, "update_user", gs_userid)
				liTotalSerialsChanged ++
			End If
		Next
		
	Else
		messagebox("Error updating content summary","Could not find container " + lsContainer + " in content summary.")
	End If
	
Next

lsMessage = "There will be " + string(liMoveRows) + " containers moved from palletID " + isPallet + " to new palletID " + lsNewPallet + ".~n~rDo you wish to continue with split?"
If MessageBox("Move containers from Pallet", lsMessage, Question!, YesNo!) = 1 Then
	Execute Immediate "Begin Transaction" using SQLCA;
	liRC = ldsSerial.update()
	If liRC = 1 Then
		liRC = ldsContent.update()
		If liRC = 1 Then
			//liRC = ldsNewContentSummary.update()		We should not have to save the content summary in this case.
			If liRC = 1 Then
				liRC = ldsAdjustment.update()
				If liRC = 1 Then
					lsMessage = "Pallet split has been successful~r~r New PalletID " + lsNewPallet
					Execute Immediate "Commit" Using Sqlca;
					
					select max(adjust_no) into :llAdjustNo from Adjustment 
					Where project_id = :gs_project and sku = :lsSku and last_user = :gs_userid and last_update = :ldtToday;
					
					//Remove color from pick list
					For liContainerRow = 1 to liContainerRows
						lsFind = "container_id = '" + lsContainers[liContainerRow] + "' "
						liFound = idw_detail.Find(lsFind, 1, liPickRows)
						If liFound > 0 Then
							idw_detail.SetItem(liFound,"color_code","0")
							idw_detail.SetItemStatus(liFound, "color_code", Primary!, NotModified! )
						End If
					Next
					
					lsMessage += "~r~rSee Adjustments " + string( llAdjustNo - liMoveRows +1 ) + " thru " + string( llAdjustNo ) + ". "
					f_method_trace_special( gs_project, this.ClassName() , lsMessage, lsToNo,'','',isInvoiceNo)
					Messagebox("Pallet Split Process", lsMessage)
					
					//Print PALLET LEVEL label	
					If messagebox("Print Pallet Level Labels","Do you wish to print the Pallet Level Label?", Question!, YesNo!) = 1 Then
						liRC = f_print_pallet_level_labels( lsContainers, lsMoveContainers, lsSKU, isWhCode, isPallet, lsNewPallet )
					End If
				Else
					lsMessage = "Error occurred while saving Adjustment  records~r~r" 
					Execute Immediate "Rollback" using SQLCA;
					f_method_trace_special( gs_project, this.ClassName() , lsMessage, lsToNo,'','',isInvoiceNo)
					Messagebox("Pallet Split Process", lsMessage)
				End If
			Else
				lsMessage = "Error occurred while saving Content Summary records~r~r" 
				Execute Immediate "Rollback" using SQLCA;
				f_method_trace_special( gs_project, this.ClassName() , lsMessage, lsToNo,'','',isInvoiceNo)
				Messagebox("Pallet Split Process", lsMessage)
			End If
		Else
			lsMessage = "Error occurred while saving Content records~r~r" 
			Execute Immediate "Rollback" using SQLCA;
			f_method_trace_special( gs_project, this.ClassName() , lsMessage, lsToNo,'','',isInvoiceNo)
			Messagebox("Pallet Split Process", lsMessage)
		End If
	Else
		lsMessage = "Error occurred while saving Serial records~r~r" 
		Execute Immediate "Rollback" using SQLCA;
		f_method_trace_special( gs_project, this.ClassName() , lsMessage, lsToNo,'','',isInvoiceNo)
		Messagebox("Pallet Split Process", lsMessage)
	End If
End If





end event

event ue_pick_mixed();//GailM 5/8/2019 DE10131 Google - SIMS - Footprints - Movements of Mixed Containers
String lsPalletNo, lsFilter, lsSKU, lsFind, lsSelect, lsWhere, lsSelect2, lsMixedType, lsColorCode
String lsLocation, lsOrderType
Int liRow, liFound, li_Pos, li_Pos1, li_Pos2, li_Ret
Long llReqQty
Boolean lbCancelled
Datastore ldsFromPallet, ldsToPallet, ldsTranDetail
Str_parms	lstrParms
Str_parms	lstrReturnParms

lsSKU = idw_detail.GetItemString(ilCurrPickRow,'sku')
lsLocation = idw_detail.GetItemString(ilCurrPickRow,'s_location')
isinvoice_no = idw_main.GetItemString(1, 'to_no')
isWhCode = idw_main.GetItemString(1, 's_warehouse')
isPallet = idw_detail.GetItemString(ilCurrPickRow,'po_no2') 
isContainer = idw_detail.GetItemString(ilCurrPickRow,'container_id') 
lsColorCode = idw_detail.GetItemString(ilCurrPickRow,'color_code') 
lsMixedType = idw_detail.GetItemString(ilCurrPickRow,'mixed_type') 
llReqQty = idw_detail.GetItemNumber(ilCurrPickRow,'quantity')

ldsFromPallet = Create datastore
ldsFromPallet.dataobject = 'd_pick_mixed'
ldsFromPallet.SetTransObject(SQLCA)

ldsFromPallet.Retrieve(gs_Project,isWhCode,lsSKU,isPallet,isContainer,lsLocation)	

ldsToPallet = Create datastore
ldsToPallet.dataobject = 'd_pick_mixed'
ldsToPallet.SetTransObject(SQLCA)

ldsTranDetail = Create datastore
ldsTranDetail.dataobject = 'd_owner_change_detail'
ldsTranDetail.SetTransObject(SQLCA)

idw_detail.Rowscopy( ilCurrPickRow, ilCurrPickRow, Primary!, ldsTranDetail, 2, Primary!)

lstrparms.String_Arg[1] = isPallet
lstrparms.String_Arg[2] = isContainer
lstrparms.String_Arg[3] = isinvoice_no
lstrparms.String_Arg[4] = isWhCode
lstrparms.String_Arg[5] = 'SOC'
lstrparms.String_Arg[6] = lsColorCode
lstrparms.String_Arg[7] = lsMixedType
lstrparms.String_Arg[8] = lsLocation
lstrparms.integer_arg[1] = ilCurrPickRow
lstrparms.Boolean_arg[1] = ibPharmacyProcessing
lstrparms.Long_Arg[1] = llReqQty
lstrparms.Long_Arg[2] = idw_detail.GetItemNumber(ilCurrPickRow, "quantity")	//DE12642
lstrparms.Datastore_Arg[1] = ldsFromPallet
lstrparms.Datastore_Arg[2] = ldsToPallet
lstrparms.Datastore_Arg[3] = ldsTranDetail
lstrparms.Datawindow_Arg[1] = idw_detail
lstrparms.Datawindow_Arg[2] = idw_transfer_detail_content

OpenWithParm(w_pick_pallet, lstrparms)

//lstrReturnParms = Message.PowerobjectParm

ldsFromPallet = lstrparms.Datastore_Arg[1]
ldsToPallet = lstrparms.Datastore_Arg[2]
lbCancelled = lstrparms.cancelled

If lbCancelled Then
	messagebox("Cancelled","The process has been cancelled.")
End If


end event

event ue_post_confirm();//Any Project Specific processing that needs to occur after the order has been confirmed
Int li_ret
Long	llRowPos, llRowCount
String	lsPalletSave, lsPallet, lsRoNo, lsInvoice, lsWhCode, lsLocType, lsLCode, lsCOO, lsSKU
String lsPoNo, lsPoNo2, lsCntrId, lsSupplier, lsMsg
Decimal ldOwnerId
Boolean ibFootprintInd

//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse - Stock Transfer
If gs_project = 'PANDORA' Then

	llRowCount = idw_content_append.RowCount()
	For llRowPos = 1 to llRowCount
		lsWhCode = idw_content_append.GetItemString(llRowPos,'wh_code')
		lsLCode = idw_content_append.GetItemString(llRowPos,'l_code')
		lsLocType = f_get_loc_type(lsWhCode, lsLCode)
		If lsLocType = "Z" Then
			lsSKU = idw_content_append.GetItemString(llRowPos,'sku') 
			lsSupplier = idw_content_append.GetItemString(llRowPos,'supp_code') 
			ibFootprintInd = f_is_sku_foot_print(lsSKU, lsSupplier)		//pono2 and containerId have already been changed to NA/NA
			lsRoNo = idw_content_append.GetItemString(llRowPos,'ro_no') 
			lsCOO = idw_content_append.GetItemString(llRowPos,'country_of_origin') 
			lsPoNo = idw_content_append.GetItemString(llRowPos,'po_no') 
			lsPoNo2 = idw_content_append.GetItemString(llRowPos,'po_no2') 
			lsCntrId = idw_content_append.GetItemString(llRowPos,'container_id') 
			ldOwnerId = idw_content_append.GetItemNumber(llRowPos,'owner_id') 
			
			li_ret	= 	sqlca.sp_merge_kitting_location_records(gs_project, lsWhCode, lsLCode, lsSKU, lsRoNo, lsCOO, lsPoNo, lsPoNo2, lsCntrId, ldOwnerId)
			
			lsMsg = "ue_post_confirm PANDORA: merged rono " + lsRoNo + " into a kitting location"
			f_method_trace_special( gs_project,this.ClassName() + 'Pandora Kitting-ue_post_confirm',lsMsg,isToNo,' ',' ',isToNo ) 
		End If
	Next

End If
end event

public subroutine wf_clear_screen ();idw_main.Reset()
idw_detail.reset()

tab_main.tabpage_main.cb_confirm.enabled = False
tab_main.tabpage_detail.Enabled = False
tab_main.tabpage_alt_serial_capture.Enabled = False

tab_main.SelectTab(1) 
idw_main.Hide()

isle_code.Text = ""

// pvh 09/16/05
setQtyAllDisplay( true )

Return

end subroutine

public function integer wf_validation ();string ls_dwhcode, ls_dlcode, ls_lcode, ls_swhcode, ls_slcode,ls_sku
string ls_sno,ls_lno, lsLocType
string ls_itype,ls_sku1,ls_tono,ls_supp,ls_po,ls_po2
string ls_container_ID    //GAP 11/02 added here
long i,ll_own, llCount
decimal ld_qty,ld_quantity,ld_qty1 // GAP 11/02 changed from long to decimal
datetime ldt_expiration_date  //GAP 11/02 added here
String	lsSKUPrev
Boolean lbKittingLoc
Integer li_colnbr = 1
Long ll_row = 1
String ls_colname, ls_textname,ls_collabelname,ls_coltype

If idw_main.AcceptText() = -1 then
	tab_main.SelectTab(1)
	idw_main.SetFocus()
	Return -1
End If

If idw_detail.AcceptText() = -1 then
	tab_main.SelectTab(2)
	idw_detail.SetFocus()
	Return -1
End If
IF idw_main.getitemstring(1,'ord_status') = "V" THEN RETURN 0

If idw_detail.AcceptText() = -1 then
	tab_main.SelectTab(2)
	idw_detail.SetFocus()
	Return -1
End If

//MA - 01/18 -Check for Full Pallet / Carton Validation 
If upper(gs_project) ='PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" Then
//	wf_check_full_pallet_container()
End If

SetMicroHelp("Checking required fields...")
//Check required fields for master record
if f_check_required(is_title,idw_main) = -1 then
	tab_main.SelectTab(1)
	return -1
end if
IF idw_detail.FindRequired(Primary!, ll_row, li_colnbr, ls_colname, False) < 1 THEN
	RETURN -1
END IF

if ls_colname <> 'user_field3'   then
if f_check_required(is_title,idw_detail) = -1 then
	tab_main.SelectTab(2)
	return -1
end if
end if 

ls_dwhcode = idw_main.getitemstring(1,'d_warehouse')
ls_swhcode = idw_main.getitemstring(1,'s_warehouse')

for i = 1 to idw_detail.rowcount()
	
	setmicrohelp("Checking order detail record " + String(i) )
	
	ls_dlcode = idw_detail.getitemstring(i,'d_location')
	ls_slcode = idw_detail.getitemstring(i,'s_location')	
	ls_sku = idw_detail.getitemstring(i,'sku')
   ls_supp = idw_detail.getitemstring(i,'supp_code')
	ls_sno = idw_detail.getitemstring(i,'serial_no')
	ls_lno = idw_detail.getitemstring(i,'lot_no')
	ls_po = idw_detail.getitemstring(i,'po_no')
	ls_po2 = idw_detail.getitemstring(i,'po_no2')
	ls_container_ID = idw_detail.getitemstring(i,'container_ID')  				//GAP 11/02 
	ldt_expiration_date = idw_detail.getitemdatetime(i,'expiration_date')  	//GAP 11/02 
	ll_own = idw_detail.getitemnumber(i,'owner_id')
	ls_itype = idw_detail.getitemstring(i,'inventory_type')
	ld_quantity = idw_detail.getitemnumber(i,'quantity')
	
	IF isnull(ld_quantity) or ld_quantity = 0 THEN 
		 MessageBox(is_title,"Quantity is missing or invalid in row " + string( i ) + ", please check!",StopSign!)
		 tab_main.selecttab(4)
		 f_setfocus(idw_detail, i, "sku")
		 return -1
	END IF	 
	
	// pvh - 09/21/05
	if checkforDuplicates( i ) then
		Messagebox(is_title,"Found duplicate Transfer list item in row " + string( i ) + ", please check!",StopSign!)
		return -1
	end if


	// check location code 	
	//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse
	lsLocType = f_get_loc_type(ls_dwhcode, ls_dlcode)
	If lsLocType = 'Z' Then
		lbKittingLoc = TRUE
	End If

	//03/20 -PCONKL - Only validate SKU if changed
	If ls_sku <> lsSKUPrev Then
	
		Select Count(*) into :llCount
		from Item_MAster
		where sku = :ls_sku and project_id = :gs_project;
	
		If llCount < 1 Then
			messagebox(is_title,'Invalid SKU!',StopSign!)
			tab_main.SelectTab(2)
			f_setfocus(idw_detail, i, "SKU")
			return -1
		end if
	
	End If
	
	lsSKUPrev = ls_Sku

next

If lbKittingLoc Then
	MessageBox ("Destination Location", "You have chosen a KITTING location.  Pallet IDs and~r~n Container IDs will be removed from inventory~r~n content upon confirmation of this order")
End If


return 0
end function

public subroutine wf_checkstatus ();
integer i
isle_code.TabOrder = 0
isle_code.DisplayOnly = True

isle_code.BackColor = 12639424 /* 10/00 PCONKL - set to green when not enterable*/
str_multiparms lstr_parms
string bColor

//Transfer Main information
i=1
lstr_parms.string_arg1[i]="ord_date";i++
lstr_parms.string_arg1[i]="ord_type";i++
lstr_parms.string_arg1[i]="s_warehouse";i++
lstr_parms.string_arg1[i]="user_field1";i++
lstr_parms.string_arg1[i]="user_field2";i++
lstr_parms.string_arg1[i]="user_field3";i++
lstr_parms.string_arg1[i]="user_field4";i++
lstr_parms.string_arg1[i]="user_field5";i++
lstr_parms.string_arg1[i]="remark"

//Transfer Detail information
i=1
lstr_parms.string_arg2[i]="sku";i++
lstr_parms.string_arg2[i]="supp_code";i++
lstr_parms.string_arg2[i]="quantity";i++
lstr_parms.string_arg2[i]="s_location";i++
lstr_parms.string_arg2[i]="d_location";i++
lstr_parms.string_arg2[i]="c_owner_name";i++ //GAP 11/02 
lstr_parms.string_arg2[i]="country_of_origin";i++
lstr_parms.string_arg2[i]="lot_no";i++
lstr_parms.string_arg2[i]="serial_no";i++
lstr_parms.string_arg2[i]="po_no";i++
lstr_parms.string_arg2[i]="po_no2";i++
lstr_parms.string_arg2[i]="inventory_type";i++
lstr_parms.string_arg2[i]="container_ID";i++  //GAP 11/02 
lstr_parms.string_arg2[i]="expiration_date";i++ //GAP 11/02

tab_main.tabpage_detail.cb_1.enabled = true	// LTK 20110110

Choose Case idw_main.GetItemString(1,"ord_status")
		
	Case "N", "P" /*Process*/

		tab_main.tabpage_detail.cb_delete.Enabled = True
		tab_main.tabpage_detail.cb_reset.Enabled = True
		tab_main.tabpage_main.cb_confirm.Enabled = True
		//TimA 04/28/14 Pandora issue #36 Adding Re-Confirm to SOC's
		tab_main.tabpage_main.cb_confirm.Text = '&Confirm'
		tab_main.tabpage_main.cb_void.Enabled = True
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = True

		tab_main.tabpage_detail.cb_update_to.enabled = true
		tab_main.tabpage_detail.sle_update_to.enabled = true		

		idw_detail.SetTabOrder("d_location", 10)

		idw_main.SetTabOrder("remark", 10)
	
		tab_main.tabpage_alt_serial_capture.cb_alt_serisl_capture_clear.enabled = FALSE
		tab_main.tabpage_alt_serial_capture.cb_save_parent_changes.enabled = FALSE
		tab_main.tabpage_alt_serial_capture.cb_print_parent_labels.enabled = FALSE
		
		tab_main.tabpage_alt_serial_capture.enabled = True
		
		
		// 05/04/2010 ujh
		if upper(idw_main.GetItemString(1,'ord_status'))  = 'P'  Then
			tab_main.tabpage_main.cb_set_new.visible = True
			tab_main.tabpage_main.cb_set_new.Enabled = true
			
			   If 	 Upper(gs_project) = 'PANDORA' Then
					wf_check_container_scanned()
				End If
		End if
		
//TEMP-DTS - enable the serial field until the order is complete....(fails on save because of background color and/or button enabled/disabled).
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("to_no.Protect=1") //temp-DTS
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Protect=0") //temp-DTS
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Background.Color = " + string(RGB(255,255,255))+")") //temp-DTS
       

	Case "C" /*Complete*/
		setQtyAllDisplay( false )	
		tab_main.tabpage_detail.cb_reset.Enabled = False
		tab_main.tabpage_main.cb_confirm.Enabled = True
		//TimA 04/28/14 Pandora issue #36 Adding Re-Confirm to SOC's
		tab_main.tabpage_main.cb_confirm.Text ='Re-&Confirm'

		tab_main.tabpage_main.cb_void.Enabled = False

		tab_main.tabpage_detail.cb_update_to.enabled = false
		tab_main.tabpage_detail.sle_update_to.enabled = false
		tab_main.tabpage_detail.cb_1.enabled = false
		
		im_menu.m_file.m_save.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_alt_serial_capture.cb_generate.enabled 						= FALSE
		tab_main.tabpage_alt_serial_capture.cb_alt_serisl_capture_clear.enabled 	= FALSE
		tab_main.tabpage_alt_serial_capture.cb_save_parent_changes.enabled 		= FALSE
		tab_main.tabpage_alt_serial_capture.cb_print_parent_labels.enabled 		= FALSE
		
		tab_main.tabpage_alt_serial_capture.enabled = True
		
//		tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.ReSet()
//		tab_main.tabpage_alt_serial_capture.dw_alt_serial_child.ReSet()
//
     	i_nwarehouse.of_settab(idw_main)
     	i_nwarehouse.of_settab(idw_detail)

	Case "V" /*Void */
		setQtyAllDisplay( false )
		tab_main.tabpage_detail.cb_reset.Enabled = False
		tab_main.tabpage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_void.Enabled = False
		
		tab_main.tabpage_detail.cb_update_to.enabled = false
		tab_main.tabpage_detail.sle_update_to.enabled = false		

		im_menu.m_file.m_save.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_alt_serial_capture.cb_alt_serisl_capture_clear.enabled 	= FALSE
		tab_main.tabpage_alt_serial_capture.cb_generate.enabled 						= FALSE
		tab_main.tabpage_alt_serial_capture.cb_save_parent_changes.enabled		= FALSE
		tab_main.tabpage_alt_serial_capture.cb_print_parent_labels.enabled 		= FALSE
		
		tab_main.tabpage_alt_serial_capture.enabled = True
		
     	i_nwarehouse.of_settab(idw_main)
		i_nwarehouse.of_settab(idw_detail)
			
	Case 'X' /* 04/05 - PCONKL - Pending a FWD Pick Replenishment */
			
		tab_main.tabpage_detail.cb_reset.Enabled = True
		tab_main.tabpage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_void.Enabled = False

		tab_main.tabpage_detail.cb_update_to.enabled = false	
		tab_main.tabpage_detail.sle_update_to.enabled = false		
			
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = False
		if ib_edit then
			im_menu.m_record.m_delete.Enabled = True
		else
			im_menu.m_record.m_delete.Enabled = false
		end if

		tab_main.tabpage_alt_serial_capture.cb_alt_serisl_capture_clear.enabled = FALSE
		tab_main.tabpage_alt_serial_capture.cb_save_parent_changes.enabled = FALSE
		tab_main.tabpage_alt_serial_capture.cb_print_parent_labels.enabled = FALSE
		
		tab_main.tabpage_alt_serial_capture.enabled = True
		
		tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.ReSet()
		tab_main.tabpage_alt_serial_capture.dw_alt_serial_child.ReSet()
	
     	i_nwarehouse.of_settab(idw_main,lstr_parms,1)
		i_nwarehouse.of_settab(idw_detail,lstr_parms,2)
		
End Choose

i_nwarehouse.of_hide_unused(idw_detail)



end subroutine

public function integer wf_confirm ();long i, j, k, ll_currow, ll_totalrows, llowner, llNewOwner, ll_rtn,llCompNo, ll_sn_owner_id
string ls_sku,ls_lcode,ls_dlcode, ls_itype,ls_sno,ls_lno, ls_new_pono, ls_new_inventory_type, ls_sn_warehouse, ls_serial_no
string ls_tono, ls_ro, ls_pono, ls_pono2,ls_container_id, lsSupplier, lsCOO, lsFind, ls_new_pono2, ls_new_container_id
String ls_serialize_ind//Tam 2017/01/10
string ls_whcode, ls_LocType
datetime  ldt_expiration_date //GAP 11/02 
integer li_count, li_return
long ll_line_item_no, ll_next_check_line_item = 1
decimal ld_quantity

long ll_owner_inv_count, ll_return
string ls_warehouse, ls_ref, ls_reason
long ll_quantity, ll_old_quantity
integer li_rowcount

decimal  ld_req
long ld_avail, ld_content_qty

idw_transfer_detail_content_append.Reset()	// LTK 20110110

boolean lb_do_loc_check = true

Boolean lbReconfirm //TimA 04/09/14 For Re-Confirming
String lsToNo
String lsMsg
//dts 2015-12-29 - single-project rule is evolving to allow mixed projects for non-oracle-tracked Owners/GPNs
string ls_c_new_owner_name_saved, ls_sku_saved, ls_OracleIntegratedOwner, ls_MixedProject

datetime ldtToday
ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse(  ) ) 

lsToNo = idw_main.getitemstring(1,'to_no')
If Left(tab_main.tabpage_main.cb_confirm.Text,2 ) <> 'Re' then
	lbReconfirm = False
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','start ue-confirm: ',lsToNo,' ',' ' ,isOrderNo )
else
	//TimA 04/28/14 Re-Confirm was pressed
	lbReconfirm = True
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','start Re-confirm: ',lsToNo,' ',' ',isOrderNo  ) //String(isle_code)
End if

ibConfirmed = TRUE

ll_rtn = 1
If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	ll_rtn = -1
	Return ll_rtn 
End If
If idw_detail.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_detail.SetFocus()
	ll_rtn = -1
	Return ll_rtn 
End If

//TimA Pandora issue #36 on a Re-Confirm skip over everything and just do the batch transactions below
If lbReconfirm = False then

	// pvh - 09/21/05
	if checkforconfirmed() then 
		messagebox( is_title, "Transfer Already Confirmed.", exclamation!)
		return -1
	end if
	
	//--
	
	// LTK 20110429 Pandora #205 - SOC Multiline Fix - ensure that user_line_item_no is not null
	if idw_detail.Find("IsNull(user_line_item_no)", 1, idw_detail.RowCount()) > 0 then
		MessageBox(is_title, "System error:  this action cannot be performed because user line items have not been set.  ~rPlease contact system support!", StopSign!)
		Return -1
	end if
	
	// LTK 20110131 Check for all SOC detail records to be populated
	if idw_detail.Find("Trim(s_location) = '*' or Trim(d_location) = '*'", 1, idw_detail.RowCount()) > 0 then
		MessageBox(is_title, "All FROM/TO locations must be populated on the Owner Change Detail Tab!", StopSign!)
		Return -1
	end if
	
	string lsproject, lssku, ls_dwhcode, ls_swhcode, ls_slcode
	
	ls_whcode = idw_main.getitemstring(1,'d_warehouse')
	
	ls_dwhcode = idw_main.getitemstring(1,'d_warehouse')
	ls_swhcode = idw_main.getitemstring(1,'s_warehouse')
	
	string ls_c_new_owner_name, ls_Customer_Type
	integer  li_pos
	string ls_new_l_code //ls_po_no, ls_new_po_no, 
	
	//TimA 06/21/11
	//This was inside the For loop below and causing a memory leak problem
	datastore lds_d_owner_change_check_location
	lds_d_owner_change_check_location = CREATE datastore;
	lds_d_owner_change_check_location.dataobject = "d_owner_change_check_location"
	lds_d_owner_change_check_location.SetTransObject(SQLCA)
	
	//BCR 15-DEC-2011: Treat Bluecoat same as Pandora
	if gs_Project = 'PANDORA' OR gs_Project = 'BLUECOAT' then
	//dts 9/30/10 - need to allow for moving ALL of the material in a location from one Owner to another
	/*check to see that all of the material will be changed....
		so, scroll through all of the records in the SOC
		add up the quantity to be moved where the from/to location are equal
		if all of them are the same from/to owner
		check the total qty to be moved against what's in the location now.
		if it's equal, it's ok to change owners without changing location
	*/
	integer liOwner
	string lsNextLoc
	decimal ldAvailQty
	boolean lbSameLoc //lbFullQty
	
	//string lsTEMP //TEMPO!!!
	
	//	lbFullQty = True
		idw_detail.SetSort("s_location")
		idw_detail.Sort()
		for i = 1 to idw_detail.rowcount()
			//add the qty for all lines where the location is not changing...
			//if moving total qty, we'll skip line-level validation below so make sure only moving to a single owner/InvType.
			ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
			ls_slcode = Upper(idw_detail.getitemstring(i,'s_location',Primary!,True))
			llOwner = idw_detail.getitemNumber(i,'Owner_id')
			llNewOwner = idw_detail.getitemNumber(i,'new_owner_id')
			ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type'))	
			ls_new_inventory_type = Upper(idw_detail.getitemstring(i,'new_inventory_type'))
//			TODO !!! Project Check here? (12/15/15)
			ls_pono = Upper(idw_detail.getitemstring(i,'po_no'))
			ls_new_pono = Upper(idw_detail.getitemstring(i,'new_po_no'))
			ls_sku = Upper(idw_detail.getitemstring(i,'sku'))

			if ls_dlcode = ls_slcode then
				/*actually, we only care that all of the quantity is represented in the owner change.
				.... if some of it moves to a new location, that would be ok. It will be validated below.
	!!!			There might be multiple From Locations.
				 - so, we must sort by From Location, and at each change in FromLoc, check the SOC Qty against AvailQty !! 
				 Only want to validate qty if at least some of the qty will remain in the FromLoc*/
				 lbSameLoc = True
			end if
				ld_quantity = ld_quantity + idw_detail.getitemnumber(i,'quantity')
				if i < idw_detail.rowcount() then
					lsNextLoc = Upper(idw_detail.getitemstring(i + 1, 's_location', Primary!, True))
				else
					lsNextLoc = 'done'
				end if
				/* START SAME LOC */
				if ls_sLCode <> lsNextLoc then
					if lbSameLoc = True then
						// LTK 20110223	SOC enhancement
						// Check if a inventory exists in this location from a different owner, 
						// if so display error message and return.
						decimal ld_other_owner_qty
						
						//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
						//dts 2015-12-15 - If GPN is serialized, need to trap for different Project (in addition to Owner) in same location
						string ls_error_msg

						//dts 2015-12-29 - Now grabbing 'Mixed Project' (UF18) from Item Master and 'Oracle Integrated' (UF5) from customer master (to control whether single-project rule is enforced)
						if ls_sku <> ls_sku_saved then
							ls_sku_saved = ls_sku
							SELECT max(upper(user_field18)) INTO :ls_MixedProject
								FROM Item_Master
								WHERE project_id = :gs_project AND sku = :ls_sku
								USING SQLCA;
						end if	
	
						ls_c_new_owner_name =  Upper(idw_detail.getitemstring(i,'c_new_owner_name'))
						//Need to remove Type from Owner Name that is shown on screen.
						li_pos = LastPos ( ls_c_new_owner_name,  "(" )
						IF li_pos > 1 then 
							ls_c_new_owner_name = Left(ls_c_new_owner_name, li_pos -1)
						END IF
						if ls_c_new_owner_name <> ls_c_new_owner_name_saved then
							ls_c_new_owner_name_saved = ls_c_new_owner_name 
							SELECT Customer_Type, upper(user_field5) INTO :ls_Customer_Type, :ls_OracleIntegratedOwner
								FROM Customer 
								WHERE project_id = :gs_project AND cust_code = :ls_c_new_owner_name
								USING SQLCA;
						
							IF SQLCA.SQLCode = 100 THEN
								MessageBox ("Can't Confirm", "Customer Code: '" + ls_c_new_owner_name + "' not found.")
								RETURN -1
							END IF
							
							IF SQLCA.SQLCode < 0 THEN
								MessageBox ("DB Error", SQLCA.SQLErrText )
								RETURN -1
							END IF
							
							IF Upper(ls_Customer_Type) = 'IN' THEN 
								MessageBox ("Can't Confirm",  "Customer Code: '" +ls_c_new_owner_name + "' is inactive. You cannot continue with confirm.")
								RETURN -1
							END IF
						end if
						
						//if ib_serialized = False then
						//if ib_serialized = False or ls_OracleIntegratedOwner = 'N' or ls_MixedProject = 'Y' then 
						//dts 2016-01-07 - Making Single-project logic configurable
						if ibSingleProjectTurnedOn = False or ib_serialized = False or ls_OracleIntegratedOwner = 'N' or ls_MixedProject = 'Y' then 
							//the old way....
							select sum(avail_qty + tfr_in + alloc_qty) into :ld_other_owner_qty
							from content_summary
							//where project_id = 'PANDORA'
							where project_id = :gs_project
							and wh_code = :ls_swhcode 
							and l_code = :ls_dlcode
							and owner_id <> :llNewOwner
							Using SQLCA;
		
							If ld_other_owner_qty > 0 Then
								ls_error_msg = "Quantity from a different owner exists for location (" +  ls_slcode + &
													 ").  Please move to a different location!"
								MessageBox(is_title, ls_error_msg, StopSign!)
								Return -1
							End If
						else //Serialized (and tracked by Pandora)...
							//For a Serialized SKU, need to limit location to single Project but allow other Projects for other SKUs.
							//  So, there can't be inventory for another OWNER (regardless of GPN), or another PROJECT (for the given GPN)
							select sum(avail_qty + tfr_in + alloc_qty) into :ld_other_owner_qty
							from content_summary
							where project_id = :gs_project
							and wh_code = :ls_swhcode 
							and l_code = :ls_dlcode
							and (owner_id <> :llNewOwner or (po_no <> :ls_new_pono and sku = :ls_sku))
							Using SQLCA;
		
							/* TAM - 2017/01/10 Need to check the serial_ind of the detail row.  What was happening is if any row on the detail is 
								serialized then ib_serialized is set on.  It was then doing the location serial validation for non serialized rows. */
							// We should on validate owner code if the line is serialized
							// If ld_other_owner_qty > 0 Then
							ls_serialize_ind = idw_detail.getitemstring(i,'Serialized_Ind')
							If ld_other_owner_qty > 0 and (ls_serialize_ind = 'B' or ls_serialize_ind = 'Y') Then
								ls_error_msg = "Location (" +  ls_slcode + ") contains inventory for a different Owner or Project.  Please move to a different location!"
								MessageBox(is_title, ls_error_msg, StopSign!)
								Return -1
							End If
						end if //Serialized (and tracked by Pandora)...
	
					end if  //same loc
					ld_quantity = 0
					ld_other_owner_qty = 0
					lbSameLoc = False
				end if 
				/* END SAME LOC */
		next
	end if
	for i = 1 to idw_detail.rowcount()
		ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
		ls_slcode = Upper(idw_detail.getitemstring(i,'s_location',Primary!,True))
		
		//04-May-2017 :Madhu PEVS-428 - SOC Commingle Validation for Serialized /Non-Serialized GPN's -START
		//If not re-initialized, following attributes were holding last detail row values.
		llNewOwner = idw_detail.getitemnumber( i, 'new_owner_id')
		ls_new_pono = idw_detail.getitemstring(i,'new_po_no')
		ls_new_inventory_type = Upper(idw_detail.getitemstring(i,'new_inventory_type'))
		ls_pono = Upper(idw_detail.getitemstring(i,'po_no'))
		//04-May-2017 :Madhu PEVS-428 - SOC Commingle Validation for Serialized /Non-Serialized GPN's -END
		
		If isnull(ls_dlcode) then
			MessageBox ("Error", "Must enter 'TO Location' for all lines.'")
			Return -1
		END IF
		
		ls_c_new_owner_name =  Upper(idw_detail.getitemstring(i,'c_new_owner_name'))
	
		//Need to remove Type from Owner Name that is shown on screen.
		li_pos = LastPos ( ls_c_new_owner_name,  "(" )
	
		IF li_pos > 1 then 
			ls_c_new_owner_name = Left(ls_c_new_owner_name, li_pos -1)
		END IF

		//dts 2015-12-29 - Now grabbing 'Mixed Project' (UF18) from Item Master and 'Oracle Integrated' (UF5) from customer master (to control whether single-project rule is enforced)
		ls_sku = Upper(idw_detail.getitemstring(i,'sku'))
		if ls_sku <> ls_sku_saved then
			ls_sku_saved = ls_sku
			SELECT max(upper(user_field18)) INTO :ls_MixedProject
				FROM Item_Master
				WHERE project_id = :gs_project AND sku = :ls_sku
				USING SQLCA;
		end if	
	
		if ls_c_new_owner_name <> ls_c_new_owner_name_saved then
			ls_c_new_owner_name_saved = ls_c_new_owner_name 
			SELECT Customer_Type, upper(user_field5) INTO :ls_Customer_Type, :ls_OracleIntegratedOwner
				FROM Customer 
				WHERE project_id = :gs_project AND cust_code = :ls_c_new_owner_name
				USING SQLCA;
		
			IF SQLCA.SQLCode = 100 THEN
				MessageBox ("Can't Confirm", "Customer Code: '" + ls_c_new_owner_name + "' not found.")
				RETURN -1
			END IF
			
			IF SQLCA.SQLCode < 0 THEN
				MessageBox ("DB Error", SQLCA.SQLErrText )
				RETURN -1
			END IF
			
			IF Upper(ls_Customer_Type) = 'IN' THEN 
				MessageBox ("Can't Confirm",  "Customer Code: '" +ls_c_new_owner_name + "' is inactive. You cannot continue with confirm.")
				RETURN -1
			END IF
		end if
	
		// check location code 	
		select l_code into :ls_lcode from location 
			where wh_code = :ls_dwhcode and l_code = :ls_dlcode;
			
		if sqlca.sqlcode <> 0 then
			messagebox(is_title,'Invalid destination location!',StopSign!)
			tab_main.SelectTab(2)
			f_setfocus(idw_detail, i, "d_location")
			return -1
		end if
		
		select l_code into :ls_lcode from location 
			where wh_code = :ls_swhcode and l_code = :ls_slcode;
		if sqlca.sqlcode <> 0 then
			messagebox(is_title,'Invalid source location!',StopSign!)
			tab_main.SelectTab(2)
			f_setfocus(idw_detail, i, "s_location")
			return -1
		end if
	
		Select project_reserved into :lsProject
		From	location
		Where wh_code = :ls_dwhcode and l_code = :ls_dlcode
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
	
			//if serialized, we need to validate single-Project rule as well as single-owner
			//dts 2015-12-29 -  now letting non-Oracle-tracked Owners and GPNs mix projects
			//if ib_serialized = False then
			//if ib_serialized = False or ls_OracleIntegratedOwner = 'N' or ls_MixedProject = 'Y' then 
			//dts 2016-01-07 - Making Single-project logic configurable
			if ibSingleProjectTurnedOn = False or ib_serialized = False or ls_OracleIntegratedOwner = 'N' or ls_MixedProject = 'Y' then 
				IF (ls_lcode <> ls_dlcode) AND (llOwner <> llNewOwner)  THEN
					
					//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
					Select count(*) into :li_Count
						From	content
						//Where project_id = 'PANDORA'
						Where project_id = :gs_project
						and wh_code = :ls_dwhcode and l_code = :ls_dlcode
						and (owner_id <> :llNewOwner or Inventory_Type <> :ls_new_inventory_type) and Avail_Qty > 0 
						Using SQLCA;
						
					/* TEMPO!!!! 10/12 - letting this go to process 'H' to 'P' orders...
					  10/14 - turning back on.... */
					IF li_Count > 0 THEN
						messagebox(is_title, "The 'TO Location' ("+ls_dlcode+") already has material of a different Owner or Inventory Type!",StopSign!)
						Return -1
					END IF
				END IF
			else //Serialized (and tracked by Pandora)...
				IF (ls_lcode <> ls_dlcode) AND (llOwner <> llNewOwner or ls_pono <> ls_new_pono)  THEN
					Select count(*) into :li_Count
						From	content
						Where project_id = :gs_project
						and wh_code = :ls_dwhcode and l_code = :ls_dlcode
						and (owner_id <> :llNewOwner or (po_no <> :ls_new_pono and sku = :ls_sku) or Inventory_Type <> :ls_new_inventory_type) and Avail_Qty > 0 
						Using SQLCA;
						
					IF li_Count > 0 THEN
						messagebox(is_title, "The 'TO Location' ("+ls_dlcode+") already has material of a different Owner, Project or Inventory Type!",StopSign!)
						Return -1
					END IF
				END IF
			end if // If Serialized...

		Else /* Location Not Found*/
			Messagebox(is_title,"Location Not Found!",StopSign!)
			Return 1
		End If	
		
		//04-May-2017 :Madhu PEVS-428 - SOC Commingle Validation for Serialized /Non-Serialized GPN's - START
		ls_serialize_ind = idw_detail.getitemstring(i,'Serialized_Ind')

		ll_return = wf_commingle_validation(ls_sku, llNewOwner, ls_new_pono,  ls_dwhcode, ls_dlcode, ls_serialize_ind)
		
		IF ll_return < 0 Then
			messagebox(is_title, "The 'TO Location' ("+ls_dlcode+") already has material of a different Owner, Project or Inventory Type!",StopSign!)
			Return -1
		End IF
		//04-May-2017 :Madhu PEVS-428 - SOC Commingle Validation for Serialized /Non-Serialized GPN's - END	
	Next
	
	//MA - 01/18 -Check for Full Pallet / Carton Validation 
	If upper(gs_project) ='PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" Then
		//if wf_check_full_pallet_container() = -1 then return -1
	End If
	//// TAM 2010/09/09  Call serial number save to validate serial numbers are good
	///tab_main.tabpage_alt_serial_capture.TriggerEvent("ue_save")
	tab_main.tabpage_serial.TriggerEvent("ue_save")
	
	//// TAM 2010/07/24  Make Serial Cature mandatory
	//If ib_Serialized = TRUE and ib_Serial_Validated = FALSE Then
	//	messagebox(is_title, "Serial Numbers have not been entered but this order requires serial numbers to be captured. ",StopSign!)
	//	Return -1
	//END IF
	//
	if ib_Serialized = TRUE and NOT wf_serial_numbers_validated() then
		MessageBox(is_title, "Serial Numbers have not been entered but this order requires serial numbers to be captured. ",StopSign!)
		Return -1
	end if
		
	if messagebox(is_title,'Are you sure you want to confirm this order?',Question!,YesNo!,2) = 2 then	Return -1
	
	idw_content_append.Reset()
	idw_content_append.SetFilter("")
	
	ls_dwhcode = idw_main.getitemstring(1,'d_warehouse')
	ls_tono = idw_main.getitemstring(1,'to_no')
	
	// pvh - 02/14/06 gmt
	datetime gmtdate
	gmtdate =  f_getLocalWorldTime( ls_dwhcode ) 
	
				
	Execute Immediate "Begin Transaction" using SQLCA; 
		
	// Retrieve related transfer content records for all rows
	
	string ls_to_no
	boolean lb_record_in_db = false
	
	
	idw_content_append.Reset()
	
	
	for i = 1 to idw_detail.rowcount()
		// New replacement code block...
	
		ls_sku = Upper(idw_detail.getitemstring(i,'sku',Primary!,True))
		lsSupplier = Upper(idw_detail.getitemstring(i,'supp_code',Primary!,True))
		lsCoo = Upper(idw_detail.getitemstring(i,'Country_of_origin',Primary!,True))
		llOwner = idw_detail.getitemNumber(i,'Owner_id',Primary!,True)
		//llCompNo = idw_detail.getitemNumber(i,'Component_no',Primary!,True)
		ls_lcode = Upper(idw_detail.getitemstring(i,'s_location',Primary!,True))
		ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
		ls_sno = Upper(idw_detail.getitemstring(i,'serial_no',Primary!,True))
		ls_lno = Upper(idw_detail.getitemstring(i,'lot_no',Primary!,True))
		ls_pono = Upper(idw_detail.getitemstring(i,'po_no',Primary!,True))
		ls_pono2 = Upper(idw_detail.getitemstring(i,'po_no2',Primary!,True))
		ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type',Primary!,True))
		ls_container_id = Upper(idw_detail.getitemstring(i,'container_id',Primary!,True)) 	//GAP 11/02 added 
		ldt_expiration_date = idw_detail.getitemdatetime(i,'expiration_date',Primary!,True) //GAP 11/02 added here 
	
		// LTK vars set from previuos code block
		llNewOwner = idw_detail.getitemNumber(i,'new_owner_id')
		ls_new_pono = Upper(idw_detail.getitemstring(i,'new_po_no'))
		ll_line_item_no =  idw_detail.getitemnumber(i,'line_item_no')
		ll_quantity = idw_detail.getitemnumber(i,'quantity')
		ls_ref =  idw_main.getitemstring(1,'to_no')   
		ls_new_inventory_type = Upper(idw_detail.getitemstring(i,'new_inventory_type'))
	
		if IsNull(ls_new_inventory_type) OR trim(ls_new_inventory_type) = '' THEN ls_new_inventory_type = ls_itype
	
		if IsNull(ls_new_inventory_type) OR trim(ls_new_inventory_type) = '' then
			ls_new_inventory_type = ls_itype
		end if
	
		ls_warehouse = getWarehouse()
	
		//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse
		ls_LocType = f_get_loc_type( ls_warehouse, ls_dlcode )
		If ls_LocType = 'Z' Then
			If f_is_sku_foot_print(lsSku, lsSupplier) Then
				ls_new_pono2 = gsFootPrintBlankInd
				ls_new_container_id = gsFootPrintBlankInd
				MessageBox ("Destination Location", "You have chosen a KITTING location.  Pallet IDs and~r~n Container IDs will be removed from inventory~r~n content upon confirmation of this order")
			End If
		Else
			ls_new_pono2 = ls_pono2
			ls_new_container_id = ls_container_id
		End If
	
		//dw_transfer_detail_content_append.retrieve(getToNo(), ls_sku, lsSupplier, llOwner, ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,ls_pono,ls_pono2,ls_container_id, ldt_expiration_date,lsCoo )  
		//dw_transfer_detail_content_append.retrieve(getToNo(), ls_sku, lsSupplier, llOwner, ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,ls_pono,ls_pono2,ls_container_id, ldt_expiration_date,lsCoo,ll_line_item_no )  
		idw_transfer_detail_content_append.retrieve(getToNo(), ls_sku, lsSupplier, llNewOwner, ls_lcode, ls_dlcode, ls_new_inventory_type, ls_sno, ls_lno,ls_new_pono,ls_pono2,ls_container_id, ldt_expiration_date,lsCoo,ll_line_item_no ) 	
	
		ll_totalrows = idw_transfer_detail_content_append.RowCount()
		If ll_totalrows <= 0 Then
			// TAM - 2018/04 - DE3780 - Add rollback
			Execute Immediate "ROLLBACK" using SQLCA;
			lsMsg = "Could not retrieve Pick Detail.~n~r"
			lsMsg += " One of the below variables is incorrect: ~n~r"
			lsMsg += "ToNo:" + getToNo() + "~n~r"
			lsMsg += "ls_sku:" + ls_sku + "~n~r" 	
			lsMsg += "lsSupplier:" + lsSupplier + "~n~r" 	
			lsMsg += "llNewOwner:" + string(llNewOwner) + "~n~r"	
			lsMsg += "ls_lcode:" + ls_lcode + "~n~r"	
			lsMsg += "ls_dlcode:" + ls_dlcode + "~n~r" 	
			lsMsg += "ls_new_inventory_type:" + ls_new_inventory_type + "~n~r" 	
			lsMsg += "ls_sno:" + ls_sno + "~n~r" 	
			lsMsg += "ls_lno:" + ls_lno + "~n~r" 	
			lsMsg += "ls_new_pono:" + ls_new_pono + "~n~r" 	
			lsMsg += "ls_pono2:" + ls_pono2 + "~n~r" 	
			lsMsg += "ls_container_id:" + ls_container_id + "~n~r" 	
			lsMsg += "ldt_expiration_date:" + string(ldt_expiration_date) + "~n~r" 	
			lsMsg += "lsCoo:" + lsCoo + "~n~r" 	
			lsMsg += "ll_line_item_no:" + string(ll_line_item_no) + "~n~r" 	
	f_method_trace_special( gs_project,this.ClassName() + ' -wf_confirm','TransferDetailContentAppend error: ' + lsMsg,lsToNo,' ',' ',isOrderNo  ) 
			lsMsg = "Could not populate transfer detail content append.~n~nCheck Dashboard wf_confirm for details~n~n"
			lsMsg += "Check Dashboard wf_confirm entry for details.~n~n"
			lsMsg += "System error 10002, please contact system support!"
			MessageBox(is_title, lsMsg, StopSign!)
			ll_rtn = -1
			Return ll_rtn
		End If
	
		lsFind = "Upper(sku) = '" + ls_sku + "' and Upper(l_code) = '" + ls_dlcode + &
			"' and Upper(serial_no) = '" + ls_sno + "' and Upper(lot_no) = '" + ls_lno + "' and Upper(po_no) = '" + ls_new_pono +  "' and Upper(po_no2) = '" + ls_new_pono2 +  & 
			"' and Upper(Container_ID) = '" + ls_new_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" +  String(ldt_expiration_date,'mm/dd/yyyy hh:mm')   + & 
			"' and upper(country_of_origin) = '" + lscoo + "' and Upper(inventory_type) = '" + ls_new_inventory_type + "' and owner_id = " + string(llNewOwner)  + & 
			" and upper(supp_code) = '" + lsSupplier + "'"
	
		/* dts - 01/18/06 - added supplier to Find so that it will re-retrieve 
		if supplier is different but everything else is the same. */
			
		k = idw_content_append.Find(lsFind, 1, idw_content_append.RowCount())
		If k	<= 0 Then
			//k = idw_content_append.retrieve(gs_project, ls_whcode, ls_sku, lsSupplier, llOwner,ls_dlcode, ls_sno, ls_lno,ls_pono,ls_pono2, ls_itype,lscoo, ls_container_id ,ldt_expiration_date )
			//k = idw_content_append.retrieve(gs_project, ls_whcode, ls_sku, lsSupplier, llNewOwner,ls_dlcode, ls_sno, ls_lno,ls_new_pono,ls_pono2, ls_new_inventory_type,lscoo, ls_container_id ,ldt_expiration_date )
			k = idw_content_append.retrieve(gs_project, ls_whcode, ls_sku, lsSupplier, llNewOwner,ls_dlcode, ls_sno, ls_lno,ls_new_pono,ls_new_pono2, ls_new_inventory_type,lscoo, ls_new_container_id ,ldt_expiration_date )
		end if        
		
		
		for j = 1 to ll_totalrows
			
			ls_ro = Upper(idw_transfer_detail_content_append.GetItemString(j,'ro_no'))
			llCompNo = idw_transfer_detail_content_append.GetItemNumber(j,'component_no')
	
			lsFind = "Upper(sku) = '" + ls_sku + "' and Upper(l_code) = '" + ls_dlcode + &
				"' and Upper(serial_no) = '" + ls_sno + "' and Upper(lot_no) = '" + ls_lno + "' and Upper(po_no) = '" + ls_new_pono + "' and Upper(po_no2) = '" + ls_new_pono2 +  & 
				"' and Upper(Container_ID) = '" + ls_new_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm')   + "' and Upper(ro_no) = '" + ls_ro +  "' and upper(country_of_origin) = '" + lscoo +  &  
				"' and Upper(inventory_type) = '" + ls_new_inventory_type + "' and owner_id = " + string(llNewOwner) + & 
				" and upper(supp_code) = '" + lsSupplier + "'"
				/* dts - 01/18/06 - added supplier to Find... */
				
			//If component exists, add to find
			If llCompNo > 0 Then
				lsFind += " and component_no = " + String(llCompNo)
			End If
			
			ll_currow = idw_content_append.Find(lsFind, 1, idw_content_append.RowCount())
					
			If ll_currow <= 0 Then
				ll_currow = idw_content_append.InsertRow(0)
				idw_content_append.setitem(ll_currow,'project_id',gs_project)
				idw_content_append.setitem(ll_currow,'sku',ls_sku)
				idw_content_append.setitem(ll_currow,'supp_code',lsSupplier)
				idw_content_append.setitem(ll_currow,'wh_code',ls_whcode)
				idw_content_append.setitem(ll_currow,'l_code',ls_dlcode)
	//			idw_content_append.setitem(ll_currow,'inventory_type',ls_itype)
				idw_content_append.setitem(ll_currow,'inventory_type',ls_new_inventory_type)			
				idw_content_append.setitem(ll_currow,'serial_no',ls_sno)
				idw_content_append.setitem(ll_currow,'lot_no', ls_lno)
	//			idw_content_append.setitem(ll_currow,'po_no', ls_pono)
				idw_content_append.setitem(ll_currow,'po_no', ls_new_pono)
				idw_content_append.setitem(ll_currow,'po_no2', ls_new_pono2)					//S45954
				idw_content_append.setitem(ll_currow,'container_ID', ls_new_container_ID)  	//S45954
				idw_content_append.setitem(ll_currow,'expiration_date', ldt_expiration_date)		 	
				idw_content_append.setitem(ll_currow,'ro_no', ls_ro )
	//			idw_content_append.setitem(ll_currow,'owner_id', llOwner)
				idw_content_append.setitem(ll_currow,'owner_id', llNewOwner)
				idw_content_append.setitem(ll_currow,'component_no', llCompNo)
				idw_content_append.setitem(ll_currow,'Country_of_origin', lsCoo)
				idw_content_append.setitem(ll_currow,'last_user', gs_userid)
				// pvh 11/30/05 - gmt
				idw_content_append.setitem(ll_currow,'last_update', gmtDate )
				//idw_content.setitem(ll_currow,'last_update', datetime( today(), now() ) )
				
				idw_content_append.setitem(ll_currow,'reason_cd', 'ST')
				idw_content_append.setitem(ll_currow,'cntnr_length',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_length')) /* 12/03 - PCONKL*/
				idw_content_append.setitem(ll_currow,'cntnr_Width',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL*/
				idw_content_append.setitem(ll_currow,'cntnr_Height',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL*/
				idw_content_append.setitem(ll_currow,'cntnr_Weight',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL*/
				idw_content_append.setitem(ll_currow,'last_cycle_count',idw_transfer_detail_content_append.GetItemDateTime(j,'last_cycle_count')) /* 2017/12/7 - TAM - Need to return Last_Cycle_Count as well*/
			End If
			//TAM 2017/12/07 - 3PL CC - If Material is moving in to an existing content row then we want to save the oldest Last Cycle Count 
			if idw_transfer_detail_content_append.GetItemDateTime(j,'last_cycle_count') < idw_content_append.GetItemDateTime(j,'last_cycle_count') then
				idw_content_append.setitem(ll_currow,'last_cycle_count',idw_transfer_detail_content_append.GetItemDateTime(j,'last_cycle_count'))
			end if

			idw_content_append.setitem(ll_currow,'avail_qty', &
				idw_content_append.getitemnumber(ll_currow, "avail_qty") + &
				idw_transfer_detail_content_append.GetItemNumber(j,'quantity'))
						
		next
	
		//idw_transfer_detail_content_append.SaveAs("c:\idw_transfer_detail_content_append"  + idw_main.Object.to_no[1] + " .csv", CSV!, false)
		idw_transfer_detail_content_append.Reset()
	
		/* End of new replacement code block */
	
		/* Create Adjustment */
		ls_reason = "Owner Change Process"
	
		Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
										wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no, po_no, old_po_no,po_no2,old_po_no2,
										container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
										old_lot_no) 
		values						(:gs_project,:ls_sku,:lsSupplier,:llOwner,:llNewOwner,:lsCoo,:lsCoo,:ls_dwhcode,:ls_dlcode,:ls_itype,:ls_new_inventory_type, &
										:ls_sno,:ls_lno, :ls_new_pono, :ls_pono,:ls_new_pono2,:ls_pono2,
										:ls_new_container_ID, :ldt_expiration_date, :ls_ro, :ll_quantity, :ll_quantity,:ls_Ref,:ls_reason,:gs_userid,:ldtToday,'O',
										:ls_lno) 
		Using SQLCA;
		
		IF SQLCA.SQLCode <> 0 THEN
			
			Execute Immediate "ROLLBACK" using SQLCA;
	// TAM 2010/09/10 moved message after rollback
			MessageBox ("DB Error", SQLCA.SQLErrText )
			Return -1
			
		END IF
					
	next
	
	/* Update Serial_Number_Inventory table and child serial numbers for components */
	
	long ll_serial_rows, ll_detail_row
	long ll_owner_id, ll_new_owner_id
	long ll_child_rows, p, ll_component_no
	string ls_serialized_ind
	datastore lds_pc_serial_update				// used to update child serial #'s in serial_number_inventory table
	datastore lds_pc_serial_update_content	// used to update child serial #'s in content table
	
	ls_warehouse = getWarehouse()
	ll_serial_rows = idw_serial.RowCount()
	
	for i = 1 to ll_serial_rows
	
		// Find corresponding SOC detail row
		ll_detail_row = idw_detail.Find("line_item_no = " + String(idw_serial.Object.to_line_item_no[i]),1,idw_detail.RowCount())
		if ll_detail_row <= 0 then
			// TAM - 2018/04 - DE3780 - Add rollback
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox(is_title,"Serial number detail line could not be found.")
			return -1
		end if
		
		ll_owner_id = idw_detail.Object.owner_id[ll_detail_row]
		ll_new_owner_id = idw_detail.Object.new_owner_id[ll_detail_row]
		ls_c_new_owner_name = Upper( idw_detail.Object.c_new_owner_name[ll_detail_row] )
		ls_serialized_ind = Upper( Trim(idw_detail.Object.serialized_ind[ll_detail_row]) )
		ls_pono = Upper( idw_detail.Object.po_no[ll_detail_row] )
		ls_new_pono = Upper( idw_detail.Object.new_po_no[ll_detail_row] )
		ls_new_l_code = Upper( idw_detail.Object.d_location[ll_detail_row] )
		
		//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse
		ls_pono2 =  Upper( idw_detail.Object.po_no2[ll_detail_row] )
		ls_container_id =  Upper( idw_detail.Object.container_id[ll_detail_row] )
		ls_LocType = f_get_loc_type( ls_warehouse, Upper( idw_detail.Object.d_location[ll_detail_row] ) )
		If ls_LocType = 'Z' Then
			If f_is_sku_foot_print(lsSku, lsSupplier) Then
				ls_pono2 = gsFootPrintBlankInd
				ls_container_id = gsFootPrintBlankInd
			End If
		End If
		
		// Remove Type from Owner Name that is shown on screen.
		li_pos = LastPos ( ls_c_new_owner_name,  "(" )
		if li_pos > 1 then 
			ls_c_new_owner_name = Left(ls_c_new_owner_name, li_pos -1)
		end if
		
		//dts - 2015-12-12 - now updating SNI table for Project changes too (not only when changing owner)
		//if ll_owner_id <> ll_new_owner_id then
			
			// Only update the serial table when ls_serialized_ind = 'B'.
			// When ls_serialized_ind = 'Y', the content table will be updated.
			if ls_serialized_ind = 'B' then
	
				/*dts - 2015-12-12 - now updating SNI table for Project changes too (not only when changing owner) so need to add Project (po_no) and l_code to SNI Retrieve and Set.
				     - may need to be more flexible in the retrieve (not just for FROM Location because of lack of data controls in the beginning so we don't really know where serial #s are) */
				//Get existing serial inventory record for the serial number.  
				ls_sku = idw_serial.Object.sku_parent[i]
				ls_serial_no = idw_serial.Object.serial_no_parent[i]
		
				if ibSingleProjectTurnedOn = true then //dts 2016-01-07 - Making Single-project logic configurable
					//do we need to restrict it to the SNI.L_Code?
					SELECT Wh_Code, Owner_Id, Component_no 
					INTO :ls_sn_warehouse, :ll_sn_owner_id, :ll_component_no
					FROM Serial_Number_Inventory  
					//dts - 2015-12-12 Now looking for specified Project
					//WHERE ( Project_Id = :gs_project ) AND ( SKU = :ls_sku ) AND (Serial_No = :ls_serial_no ) using sqlca   ;
					WHERE Project_Id = :gs_project AND SKU = :ls_sku AND Serial_No = :ls_serial_no and po_no = :ls_pono using sqlca   ;
				else
					SELECT Wh_Code, Owner_Id, Component_no 
					INTO :ls_sn_warehouse, :ll_sn_owner_id, :ll_component_no
					FROM Serial_Number_Inventory  
					WHERE ( Project_Id = :gs_project ) AND ( SKU = :ls_sku ) AND (Serial_No = :ls_serial_no ) using sqlca   ;
				end if
				IF SQLCA.SQLCode = -1 THEN 
						Execute Immediate "ROLLBACK" using SQLCA;
						// TAM 2010/09/10 moved message after rollback
						MessageBox ("DB Error", SQLCA.SQLErrText )
						Return -1
				End If
		
				IF SQLCA.SQLCode = 100 THEN 
					//TAM 2010/09/10 Added Rollback
					Execute Immediate "ROLLBACK" using SQLCA;
					// TAM 2010/09/10 moved message after rollback
					if ibSingleProjectTurnedOn = true then //dts 2016-01-07 - Making Single-project logic configurable
						Messagebox(is_title,"Serial Number: " + ls_serial_no + ", SKU: " + ls_sku + ", Project: " + ls_pono +  " Does not exist in Serial Inventory!")
					else
						Messagebox(is_title,"Serial Number: " + ls_serial_no + " SKU: " + ls_sku + " Does not exist in Serial Inventory!")
					end if
					RETURN -1
				END IF
		
				//dts - 2015-12-12 - do we need to validate Project or even do this here (isn't it already caught when the SN is entered?)?
				// Check if warehouse/owner/sku match
				If ls_warehouse <> ls_sn_warehouse or  llowner <> ll_sn_owner_id Then
						//TAM 2010/09/10 Added Rollback
						Execute Immediate "ROLLBACK" using SQLCA;
						// TAM 2010/09/10 moved message after rollback
						if ibSingleProjectTurnedOn = true then //dts 2016-01-07 - Making Single-project logic configurable
							Messagebox(is_title,"Serial Number: " + ls_serial_no + " SKU: " + ls_sku + " Belongs to a different Warehouse, Owner or Project!")
						else
							Messagebox(is_title,"Serial Number: " + ls_serial_no + " SKU: " + ls_sku + " Belongs to a different Warehouse or Owner!")
						end if
						Return -1
				End If
		
				// Update to table
				UPDATE Serial_Number_Inventory  
				//dts - 2015-12-12 SET Owner_Id = :ll_new_owner_id, Owner_CD = :ls_c_new_owner_name 
				//TODO 2016-01-07 - should we set Location and Project even if single-project rule is not turned on?
				//15-Nov-2017 :Madhu PEVS-902 - Replace  ls_dlcode by ls_new_l_code
				
				// TAM 2019/05 - S33409 - Populate Serial History Table
				//GailM 5/12/2020 - S45954 F22932 I2621 Google DA Kitting move to Spoke Warehouse - added pono2 and container_id
				SET Owner_Id = :ll_new_owner_id, Owner_CD = :ls_c_new_owner_name, po_no = :ls_new_pono, l_code = :ls_new_l_code, 
					update_date = :ldtToday, update_user = :gs_userid, po_no2 = :ls_pono2, carton_id = :ls_container_id,
					Transaction_Type = 'SOC', Transaction_ID = :lsToNo, Adjustment_Type = 'ATTRIBUTE CHANGE'				
				WHERE ( Project_Id = :gs_project ) AND ( SKU = :ls_sku ) AND (Serial_No = :ls_serial_no ) using sqlca   ;
		
				IF SQLCA.SQLCode <> 0 THEN 
						Execute Immediate "ROLLBACK" using SQLCA;
						// TAM 2010/09/10 moved message after rollback
						MessageBox ("DB Error", SQLCA.SQLErrText )
						Return -1
				End If
	
			end if
			
			// Set the child serial number owner id's and owner codes to the values set for the parent
			// per the SOC enhancement design document.  This is done only when serialized_ind = 'B'.
			if ls_serialized_ind = 'B' then
	
				if ll_component_no > 0 then
					
					if NOT IsValid(lds_pc_serial_update) then
						lds_pc_serial_update = Create datastore
						lds_pc_serial_update.DataObject = 'd_soc_child_serial_update'
						lds_pc_serial_update.SetTransObject(SQLCA)
					end if
		
					ll_child_rows = lds_pc_serial_update.Retrieve(gs_project,'*', ll_component_no)
	
					for p = 1 to ll_child_rows
						// Set owner_id and owner_cd for all child rows					
						lds_pc_serial_update.Object.owner_id[p] = idw_detail.Object.new_owner_id[ll_detail_row]
						lds_pc_serial_update.Object.owner_cd[p] = ls_c_new_owner_name
					next
					
					if lds_pc_serial_update.Update() < 0 then
						// TAM - 2018/04 - DE3780 - Add rollback
						Execute Immediate "ROLLBACK" using SQLCA;
						MessageBox(is_title,"Error updating child serial numbers for owner id=!" + idw_serial.Object.owner_id[i])
						return -1
					end if
	
				end if
			end if
		//end if  //dts - 2015-12-12 
	next 
	
	ll_rtn = 0
	if idw_content_append.Update(false,false)  = 1 then
		
		// pvh 11/30/05 - gmt
		If IsNull(idw_main.GetItemDateTime(1, 'complete_date')) Then
			//idw_main.setitem(1,'complete_date', today() )
			idw_main.setitem(1,'complete_date', f_getLocalWorldTime( idw_main.object.s_warehouse[ 1 ] )  )
		end If
		idw_main.setitem(1,'ord_status','C')
		ll_rtn = idw_main.Update( false,false ) 
	end if

	//TimA 04/28/14 Set the instance variable to null because we have no list of detail rows on a confirm
	SetNull(isDetailRecordsToReConfirm )
ELSE
	//TimA 04/28/14 Pandora issue #36 On a re-confirm we want the users to choose the detail lines.
	if upper(gs_project) = 'PANDORA' then
		ls_tono = idw_main.getitemstring(1,'to_no')
		//Call the function that will retrieve detail records to select for Re-Confirm
		IF wf_select_reconfirm_records( idw_main.getitemstring(1,'to_no') ) = False THEN
			//No detail records selected
			Return -1
		END IF
	
		If isDetailRecordsToReConfirm = Upper('ALL' ) Then
			//All the detail records selected so do normal processing.  If not this variable will be delimited with line numbers.
			SetNull(isDetailRecordsToReConfirm )
		End if
	Else
		//Set the varable to null for all non Pandora projects
		SetNull(isDetailRecordsToReConfirm )
	End if

	//Note: This is need because of the Re-Confirm.  The begin Transaction starts after the If condition for this Re-Confirm
	//and because of the commit below on the batch transaction we need to start a begin.
	Execute Immediate "Begin Transaction" using SQLCA; 

END IF

IF ll_rtn = 1 THEN

//	If NOT (   	tab_main.tabpage_alt_serial_capture.cb_generate.Enabled 							= FALSE and &
//			 		tab_main.tabpage_alt_serial_capture.cb_alt_serisl_capture_clear.Enabled 		= FALSE and &
//			 		tab_main.tabpage_alt_serial_capture.cb_print_parent_labels.Enabled 			= FALSE and &
//			 		tab_main.tabpage_alt_serial_capture.cb_save_parent_changes.Enabled 			= FALSE ) Then tab_main.tabpage_alt_serial_capture.TriggerEvent("ue_save")

	//Create Batch Transaction
	
	datetime ldtGMTToday
	ldtGMTToday = f_getLocalWorldTime( getWarehouse() ) 
	
	If wf_batch_validate(ls_tono) = 0 Then	//19-Sep-2016 Madhu- Added validation to avoid duplicate records

	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
			Values(:gs_Project, 'OC', :ls_tono,'N', :ldtGMTToday, :isDetailRecordsToReConfirm );
	
	End If //19-Sep-2016 Madhu- Added validation to avoid duplicate records
	
	IF SQLCA.SQLCode = 0 THEN


//idw_content_append.SaveAs("c:\idw_content_appends" + idw_main.Object.to_no[1] + ".csv", CSV!, false)

		
		Execute Immediate "COMMIT" using SQLCA;
		IF Sqlca.Sqlcode = 0 THEN
			idw_main.ResetUpdate()
			idw_content_append.ResetUpdate()	
			
			//BCR 13-JUL-2011: Zero Quantities Issue Resolution => Call stored proc to delete zero qty rows right after every  
			//successful Content table update. This way, we don't have to rely on the erratic update trigger for cleanup.
			li_return = SQLCA.sp_content_qty_zero()
			
		end if	
		
		MessageBox(is_title, "Record confirmed!")
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_confirm','End confirm: ',lsToNo,' ',' ' ,isOrderNo )
		this.event ue_retrieve()
	
		//6/17/2020 -GailM - Some projects may have some post confirmation processing
		This.TriggerEvent('ue_post_Confirm')

		return 0
	
	END IF


END IF

Execute Immediate "ROLLBACK" using SQLCA;
idw_main.ResetUpdate()
idw_content_append.ResetUpdate()	
MessageBox(is_title, "Record confirm failed!~r~n" + SQLCA.SQLErrText )
Return -1


end function

public subroutine dotransferall (long detailrow);// doTransferAll( long detailRow )

string sku
string supplier
string toLocation
string fromLocation

long FromLocrows
long newRow
long index
long max
datastore idsworker

if detailrow <= 0 or isNull( detailrow ) then return 

idsworker = f_datastorefactory( idw_detail.dataobject )

datawindowchild adwcFrom

idw_detail.accepttext()

sku = idw_detail.object.sku[ detailrow ]
if isNull( sku ) or len( sku ) = 0 then
	messagebox( this.title, "SKU is Invalid, Please Re-Try",exclamation! )
	return
end if

supplier = idw_detail.object.supp_code[ detailrow ]
if isNull( supplier ) or len( supplier ) = 0 then 
	messagebox( this.title, "Supplier is Invalid, Please Re-Try",exclamation! )
	return
end if

FromLocation =  idw_detail.object.s_location[ detailRow ]
if isNull( FromLocation ) or len( FromLocation ) = 0 then 
	messagebox( this.title, "From Location is Missing or Invalid, Select a Valid FromLocation and Re-Try",exclamation! )
	return
end if

toLocation =  idw_detail.object.d_location[ detailRow ]
if isNull( toLocation ) or len( toLocation ) = 0 then 
	messagebox( this.title, "To Location is Missing or Invalid, Select a Valid To Location and Re-Try",exclamation! )
	return
end if

idsFromLocations.setsqlselect( GetFromLocationSQL( ) )
idsFromLocations.Retrieve()

FromLocRows = doFromFilter( fromLocation )

if FromLocRows <=0 then
	messagebox( this.title, "From Locations Not Found! Contact Technical Support.",exclamation! )
	return
end if

idsworker.reset()
idw_detail.rowscopy( detailRow,detailRow,primary!, idsworker,1,primary! )

for index = 1 to FromLocRows
	if index = 1 then 
		newrow = detailRow
	else
		newRow =idsworker.insertrow(0)
	end if	
	idsworker.object.sku[ newRow ] = sku
	idsworker.object.supp_code[ newRow ] = idsFromLocations.object.supp_code[ index ]
	idsworker.object.owner_id[ newRow ]= idsFromLocations.object.owner_id[ index ]
	idsworker.object.c_owner_name[ newRow ] = g.of_get_owner_name( idsFromLocations.object.owner_id[ index ] )
	idsworker.object.country_of_origin[ newRow ] = idsFromLocations.object.country_of_origin[ index ]
	idsworker.object.s_location[ newRow] = idsFromLocations.object.l_code[ index ]
	idsworker.object.d_location[ newRow] = toLocation
	idsworker.object.quantity[ newRow ] = idsFromLocations.object.avail_qty[ index ]
	idsworker.object.inventory_type[ newRow ] = idsFromLocations.object.inventory_type[ index ]
	idsworker.object.owner_id[ newRow ] = idsFromLocations.object.owner_id[ index ]
	idsworker.object.to_no[ newRow] =  idw_main.object.to_no[ 1 ]
	idsworker.object.lot_no[ newRow ] = idsFromLocations.object.lot_no[ index ]
	idsworker.object.po_no[ newRow ] = idsFromLocations.object.po_no[ index ]
	idsworker.object.po_no2[ newRow ] = idsFromLocations.object.po_no2[ index ]
	idsworker.object.container_ID[ newRow ] = idsFromLocations.object.container_ID[ index ]
	idsworker.object.expiration_date[ newRow ] = idsFromLocations.object.expiration_date[ index ]
	idsworker.object.serial_no[ newRow ] = idsFromLocations.object.serial_no[ index ]
next

idsworker = getRolledUpTransactions( idsworker )
max = idsworker.rowcount()

for index = 1 to max
	
	if index = 1 then 
		newRow = detailrow
	else
		newRow =idw_detail.insertrow(0)
	end if

	idw_detail.object.sku[ newRow ] = idsWorker.object.sku[ index ]
	idw_detail.object.supp_code[ newRow ] = idsWorker.object.supp_code[ index ]
	idw_detail.object.owner_id[ newRow ]= idsWorker.object.owner_id[ index ]
	idw_detail.object.c_owner_name[ newRow ] = idsWorker.object.c_owner_name[ index ]
	idw_detail.object.country_of_origin[ newRow ] = idsWorker.object.country_of_origin[ index ]
	idw_detail.object.s_location[ newRow] = idsWorker.object.s_location[ index ]
	idw_detail.object.d_location[ newRow] = idsWorker.object.d_location[ index ]
	idw_detail.object.quantity[ newRow ] = idsWorker.object.quantity[ index ]
	idw_detail.object.inventory_type[ newRow ] = idsWorker.object.inventory_type[ index ]
	idw_detail.object.owner_id[ newRow ] = idsWorker.object.owner_id[ index ]
	idw_detail.object.to_no[ newRow] =  idsWorker.object.to_no[ index ]
	idw_detail.object.lot_no[ newRow ] = idsWorker.object.lot_no[ index ]
	idw_detail.object.po_no[ newRow ] = idsWorker.object.po_no[ index ]
	idw_detail.object.po_no2[ newRow ] = idsWorker.object.po_no2[ index ]
	idw_detail.object.container_ID[ newRow ] = idsWorker.object.container_ID[ index ]
	idw_detail.object.expiration_date[ newRow ] = idsWorker.object.expiration_date[ index ]
	idw_detail.object.serial_no[ newRow ] = idsWorker.object.serial_no[ index ]
		
next


end subroutine

public function string getfromlocationsql ();// string = getFromLocationSQL()

string lsNewSql

lsNewSql = replace(isfromlocsql,pos(isfromLocSql,'xxxxx'),5,gs_project) 

// pvh 11/14/05 - remove supplier code
lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
				    "' and sku = '" + idw_detail.object.sku[ idw_detail.getrow() ] + &
				    "' and avail_qty > 0 "
// 
// replaced code
// 
//lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
//				    "' and sku = '" + idw_detail.object.sku[ idw_detail.getrow() ] + &
//				    "' and supp_code = '" + idw_detail.object.supp_code[ idw_detail.getrow() ] + &
//				    "' and avail_qty > 0 "
					 
return lsNewSql

end function

public subroutine setqtyalldisplay (boolean abool);//// setQtyAllDisplay( boolean abool )
//
//// turn off/on the qty all objects.
//
//if gs_project <> 'PHXBRANDS'  and gs_project <>  'DEMO' and gs_project <>  'PANDORA' then
//	 tab_main.tabpage_detail.cb_xferall.visible = false
//	 return
//end if
//tab_main.tabpage_detail.cb_xferall.visible = abool
//
//
//
end subroutine

public subroutine setownerid (long aid);// setOwnerId( long aID )
ilOwnerID = aID

end subroutine

public function long getownerid ();// long = getOwnerID()
return ilOwnerID

end function

protected function integer dopickdata (string assku, string assuppliercode, long detailrow);// int = doPickData( string asSKU, string asSupplierCode, Long detailRow )

long llRow
long llOwnerId
string lsCOO

IF i_nwarehouse.of_item_master(gs_project,asSKU,asSupplierCode) > 0 THEN
	
	//Get the values from datastore ids which is item master
	llRow =i_nwarehouse.ids.Getrow()
	llOwnerId = i_nwarehouse.ids.GetItemnumber(llRow,"owner_id")
	idw_detail.SetItem(detailRow,'serialized_ind',i_nwarehouse.ids.GetItemString(llRow,"serialized_ind"))
	idw_detail.SetItem(detailRow,'lot_controlled_ind',i_nwarehouse.ids.GetItemString(llRow,"lot_controlled_ind"))
	idw_detail.SetItem(detailRow,'po_controlled_ind',i_nwarehouse.ids.GetItemString(llRow,"po_controlled_ind"))
	idw_detail.SetItem(detailRow,'po_no2_controlled_ind',i_nwarehouse.ids.GetItemString(llRow,"po_no2_controlled_ind"))
	idw_detail.Setitem(detailRow,'container_Tracking_Ind',i_nwarehouse.ids.Getitemstring(llRow,'container_Tracking_ind')) //GAP 11/02
	idw_detail.Setitem(detailRow,'expiration_controlled_ind',i_nwarehouse.ids.Getitemstring(llRow,'expiration_controlled_ind')) //GAP 11/02
	lsCOO = i_nwarehouse.ids.GetItemString(llRow,"Country_of_Origin_Default")
	//Set the values from datastore ids which is item master
	idw_detail.object.owner_id[ detailRow ]=llOwnerId
	idw_detail.object.country_of_origin[ detailRow ] = lsCOO
	//Get the owner name
	idw_detail.object.c_owner_name[ detailRow ] = g.of_get_owner_name( llOwnerId )
 Else
	MessageBox(is_title, "Supplier code not found, please re-enter!",StopSign!)
	return 1
END IF

return 0

end function

public function boolean checkforconfirmed ();// boolean = checkforconfirmed()

long rows

//datastore ids
//
//ids = f_datastoreFactory( 'd_tran_master' )
//
//MessageBox( " gs_project = "+ gs_project," getOrderNumber() = " + getOrderNumber())
//
//rows = ids.retrieve( getOrderNumber(), gs_project )
//if rows <= 0 then
//	messagebox( is_title, "Unable to Retrieve Transfer Master Data.  Please Contact Support.",exclamation! )
//	return false
//end if
//

//if ids.objectreturn true.ord_status[1] = 'C' then return true

return false

end function

public subroutine setordernumber (string asordernbr);// setOrderNumber( string asOrdernbr )
isOrderNo = asOrdernbr

end subroutine

public function string getordernumber ();// string = getOrderNumber()
return isOrderNo

end function

public function boolean checkforduplicates (long row2check);// boolean = checkforduplicates( long row2check )

string 		filterfor
long 			remainingrows

idw_detail.setredraw( false )

filterfor   = "Upper(sku) = '" + Upper( idw_detail.object.sku[ row2check ] )  + "~'"
filterfor += " and Upper(supp_code) = '" +   Upper( idw_detail.object.supp_code[ row2check ] )  + "~'"
filterfor += " and Owner_id = " + string(  idw_detail.object.Owner_id[ row2check ]  ) 
filterfor += " and Upper(Country_of_origin) = '" + Upper( idw_detail.object.Country_of_origin[ row2check ] )   + "~'"
filterfor += " and Upper(s_location) = '" +   Upper( idw_detail.object.s_location[ row2check ] )   + "~'"
filterfor += " and Upper(d_location) = '" +   Upper( idw_detail.object.d_location[ row2check ] )   + "~'"
filterfor += " and Upper(serial_no) = '" +  Upper( idw_detail.object.serial_no[ row2check ] )   + "~'"	
filterfor += " and Upper( lot_no ) = '" +   Upper( idw_detail.object.lot_no[ row2check ] )   + "~'"
filterfor += " and Upper(po_no) = '" +   Upper( idw_detail.object.po_no[ row2check ] ) + "~'"
filterfor += " and Upper(po_no2) = '" +   Upper( idw_detail.object.po_no2[ row2check ] )  + "~'"	
filterfor += " and Upper( inventory_type ) = '" +   Upper( idw_detail.object.inventory_type[ row2check ] )    + "~'"
filterfor += " and Upper( container_id ) = '" +   Upper( idw_detail.object.container_id[ row2check ] )   + "~'"
filterfor += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" +  String( idw_detail.object.expiration_date[ row2check ] ,'mm/dd/yyyy hh:mm')  + "~'"
filterfor += " and line_item_no = " +   string( idw_detail.object.line_item_no[ row2check ] ) 

idw_detail.setfilter( filterfor )
idw_detail.filter()

remainingrows = idw_detail.rowcount()
 
idw_detail.setfilter( '' )
idw_detail.filter()
idw_detail.setredraw( true )

if remainingRows > 1 then return true

return false


end function

public function long dofromfilter (string _filter);// long = doFromFilter( string _filter )

string sBegin = "l_code = ~'"
string sEnd = "~' and avail_qty > 0"
string sFilter

// filter the location code
sFilter = sBegin + Trim( _filter ) + sEnd

idsfromlocations.setfilter( sFilter )
idsfromlocations.filter()

return idsfromlocations.rowcount()

end function

public subroutine setorderstatus (string _value);// setOrderStatus( string _value )
isOrderStatus = _value

end subroutine

public subroutine settono (string _value);// setToNo( string _value )
isToNo = _value

end subroutine

public subroutine setwarehouse (string _value);// setWarehouse( string _value )
isWarehouse = _value

end subroutine

public function string getorderstatus ();// string = getOrderStatus()
return isOrderStatus

end function

public function string gettono ();// string = getToNo()
return isTono

end function

public function string getwarehouse ();// string = getwarehouse()
return isWarehouse

end function

public function integer doopentransfersearch ();// int = doOpenTransferSearch()

// if there are existing transfers for the sku/supp/location...etc then inform the user they must void or confirm the existing transfer before
// saving this one.

return 0

end function

public function boolean checkforchanges ();// boolean = checkforchanges()
long modifiedrow
boolean ibChanged

idw_detail.accepttext()
idw_main.accepttext()

ibChanged = false

modifiedrow = tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.getNextModified( 0, Primary! )
if modifiedrow > 0 then ibChanged = true

modifiedrow = idw_detail.getNextModified( 0, Primary! )
if modifiedrow > 0 then ibChanged = true

//modifiedrow = idw_detail.getNextModified( 0, Primary! )
//if modifiedrow > 0 then 
//	messagebox(is_title,'Warning, you are going to change this order into New status',StopSign!) // dinesh - 07/23/2024- SIMS-497-Google SIMS Packing list saving issue.
//	//ibChanged = true
//	//return ibChanged
//end if
//
modifiedrow = idw_main.getNextModified( 0, Primary! )
if modifiedrow > 0 then ibChanged = true

modifiedrow = idw_Detail.DeletedCount()
if modifiedrow > 0 then ibChanged = true

if ibChanged then	messagebox(is_title,'Please save changes first!',StopSign!)

return ibChanged

end function

public function datastore getrolleduptransactions (datastore ads);// datastore = getRolledUpTransactions( datastore ads )

datastore 	idsreturn
string 		filterfor
long 			remainingrows
long			index
long			max
decimal		quantity
long			innerindex
long 			newRow
long tester

idsreturn = f_datastorefactory( ads.dataobject )

do while ads.rowcount() > 0
	tester = ads.rowcount()
	index =1
	filterfor   = "Upper(sku) = '" + Upper( ads.object.sku[ index ] )  + "~'"
	filterfor += " and Upper(supp_code) = '" +   Upper( ads.object.supp_code[ index ] )  + "~'"
	filterfor += " and Owner_id = " + string(  ads.object.Owner_id[ index ]  ) 
	filterfor += " and Upper(Country_of_origin) = '" + Upper( ads.object.Country_of_origin[ index ] )   + "~'"
	filterfor += " and Upper(s_location) = '" +   Upper( ads.object.s_location[ index ] )   + "~'"
	filterfor += " and Upper(d_location) = '" +   Upper( ads.object.d_location[ index ] )   + "~'"
	filterfor += " and Upper(serial_no) = '" +  Upper( ads.object.serial_no[ index ] )   + "~'"	
	filterfor += " and Upper( lot_no ) = '" +   Upper( ads.object.lot_no[ index ] )   + "~'"
	filterfor += " and Upper(po_no) = '" +   Upper( ads.object.po_no[ index ] ) + "~'"
	filterfor += " and Upper(po_no2) = '" +   Upper( ads.object.po_no2[ index ] )  + "~'"	
	filterfor += " and Upper( inventory_type ) = '" +   Upper( ads.object.inventory_type[ index ] )    + "~'"
	filterfor += " and Upper( container_id ) = '" +   Upper( ads.object.container_id[ index ] )   + "~'"
	filterfor += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" +  String( ads.object.expiration_date[ index ] ,'mm/dd/yyyy hh:mm')  + "~'"
	ads.setfilter( filterfor )
	ads.filter()
	quantity = 0
	remainingrows = ads.rowcount()
	if remainingrows > 1 then
		for innerindex = 1 to remainingrows
			quantity += ads.object.quantity[ innerindex ]
		next
		ads.object.quantity[ 1 ] = quantity
		ads.rowscopy( 1,1, primary!, idsReturn,(idsReturn.rowcount()+1), primary! )
		ads.RowsDiscard ( 1, remainingrows, primary! ) 
	else
		ads.rowscopy( 1,1, primary!, idsReturn,( idsReturn.rowcount() +1), primary! )
		ads.RowsDiscard ( 1, 1, primary! ) 
	end if
	ads.setfilter( "" )
	ads.filter()
loop
return idsReturn



end function

public subroutine setcolormint ();colorMint = Long( idw_main.Object.ord_status.Background.Color )
end subroutine

public function long getcolormint ();return colorMint

end function

public subroutine dotransferallcontainer (integer detailrow);// doTransferAllContainer( long detailRow )

//Added MEA - 10/08 - Add all items in container.


//We need to add functionality to the Stock Transfer function for Diebold to be able to move all of the 
//rows for a given container (po_no2) without having to manually enter each row separately. 
//After Selecting a content record from the "From Location" field and entering a value in the 
//"To Location" field, we should blow out detail rows for all of the other content records with the same 
//location and po_no2 and fill in the "To Location" that was entered in the first row.

string sku
string supplier
string toLocation
string fromLocation

long FromLocrows
long newRow
long index
long max
datastore idsworker

if detailrow <= 0 or isNull( detailrow ) then return 

idsworker = f_datastorefactory( idw_detail.dataobject )

datawindowchild adwcFrom

idw_detail.accepttext()

sku = idw_detail.object.sku[ detailrow ]
if isNull( sku ) or len( sku ) = 0 then
	messagebox( this.title, "SKU is Invalid, Please Re-Try",exclamation! )
	return
end if

supplier = idw_detail.object.supp_code[ detailrow ]
if isNull( supplier ) or len( supplier ) = 0 then 
	messagebox( this.title, "Supplier is Invalid, Please Re-Try",exclamation! )
	return
end if

FromLocation =  idw_detail.object.s_location[ detailRow ]
if isNull( FromLocation ) or len( FromLocation ) = 0 then 
	messagebox( this.title, "From Location is Missing or Invalid, Select a Valid FromLocation and Re-Try",exclamation! )
	return
end if

toLocation =  idw_detail.object.d_location[ detailRow ]
if isNull( toLocation ) or len( toLocation ) = 0 then 
	messagebox( this.title, "To Location is Missing or Invalid, Select a Valid To Location and Re-Try",exclamation! )
	return
end if


string ls_po_no2

ls_po_no2 =  idw_detail.GetItemString( detailrow, "po_no2"  )

//If there is no container the return.

//Return if  '-', 'NA' or 'N/A'

if IsNull(ls_po_no2) or trim(ls_po_no2) = "" or trim(ls_po_no2) = '-' or trim(ls_po_no2) = 'NA'  or trim(ls_po_no2) = 'N/A' then
	
	return
	
end if


////Only do when Container starts with a "G", "C", or "P" and the rest is numeric.
//
//
//if left(upper(ls_po_no2), 1) = "G" or  left(upper(ls_po_no2), 1) ="C" or  left(upper(ls_po_no2), 1) ="P" then
//
//
//	//Check to see if the rest is numeric, if not - return
//	
//	IF NOT IsNumber(mid(ls_po_no2, 2)) THEN
//
//		return
//		
//	END IF
//
//else
//
//	//return for the rest.
//	
//	return
//
//end if

integer li_pos, li_RowCount
string ls_container_where


idsFromLocationsContainer.setsqlselect( GetFromLocationContainerSQL( ) )
FromLocRows =  idsFromLocationsContainer.Retrieve()

if FromLocRows > 0 then

	idw_detail.SetRedraw(false)

	idw_detail.DeleteRow(detailrow)

	li_RowCount = idw_detail.RowCount()

	if li_RowCount > 0 then

		for index = li_RowCount to 1  step -1
				
			if trim(ls_po_no2) = trim(idw_detail.GetItemString( index, "po_no2")) then
							
					idw_detail.DeleteRow(index)						
					
			end if
			
		next

	end if	

	
	idsworker.reset()
	idw_detail.rowscopy( detailRow,detailRow,primary!, idsworker,1,primary! )
	
	for index = 1 to FromLocRows

		newRow =idsworker.insertrow(0)
		
		idsworker.object.sku[ newRow ] =  idsFromLocationsContainer.object.sku[ index ]
		idsworker.object.supp_code[ newRow ] = idsFromLocationsContainer.object.supp_code[ index ]
		idsworker.object.owner_id[ newRow ]= idsFromLocationsContainer.object.owner_id[ index ]
		idsworker.object.c_owner_name[ newRow ] = g.of_get_owner_name( idsFromLocationsContainer.object.owner_id[ index ] )
		idsworker.object.country_of_origin[ newRow ] = idsFromLocationsContainer.object.country_of_origin[ index ]
		idsworker.object.s_location[ newRow] = idsFromLocationsContainer.object.l_code[ index ]
		idsworker.object.d_location[ newRow] = toLocation
		idsworker.object.quantity[ newRow ] = idsFromLocationsContainer.object.avail_qty[ index ]
		idsworker.object.inventory_type[ newRow ] = idsFromLocationsContainer.object.inventory_type[ index ]
		idsworker.object.owner_id[ newRow ] = idsFromLocationsContainer.object.owner_id[ index ]
		idsworker.object.to_no[ newRow] =  idw_main.object.to_no[ 1 ]
		idsworker.object.lot_no[ newRow ] = idsFromLocationsContainer.object.lot_no[ index ]
		idsworker.object.po_no[ newRow ] = idsFromLocationsContainer.object.po_no[ index ]
		idsworker.object.po_no2[ newRow ] = idsFromLocationsContainer.object.po_no2[ index ]
		idsworker.object.container_ID[ newRow ] = idsFromLocationsContainer.object.container_ID[ index ]
		idsworker.object.expiration_date[ newRow ] = idsFromLocationsContainer.object.expiration_date[ index ]
		idsworker.object.serial_no[ newRow ] = idsFromLocationsContainer.object.serial_no[ index ]
	next
	

	max = idsworker.rowcount()
	
	for index = 1 to max
		
		newRow =idw_detail.insertrow(0)

		idw_detail.object.sku[ newRow ] = idsWorker.object.sku[ index ]
		idw_detail.object.supp_code[ newRow ] = idsWorker.object.supp_code[ index ]
		idw_detail.object.owner_id[ newRow ]= idsWorker.object.owner_id[ index ]
		idw_detail.object.c_owner_name[ newRow ] = idsWorker.object.c_owner_name[ index ]
		idw_detail.object.country_of_origin[ newRow ] = idsWorker.object.country_of_origin[ index ]
		idw_detail.object.s_location[ newRow] = idsWorker.object.s_location[ index ]
		idw_detail.object.d_location[ newRow] = idsWorker.object.d_location[ index ]
		idw_detail.object.quantity[ newRow ] = idsWorker.object.quantity[ index ]
		idw_detail.object.inventory_type[ newRow ] = idsWorker.object.inventory_type[ index ]
		idw_detail.object.owner_id[ newRow ] = idsWorker.object.owner_id[ index ]
		idw_detail.object.to_no[ newRow] =  idsWorker.object.to_no[ index ]
		idw_detail.object.lot_no[ newRow ] = idsWorker.object.lot_no[ index ]
		idw_detail.object.po_no[ newRow ] = idsWorker.object.po_no[ index ]
		idw_detail.object.po_no2[ newRow ] = idsWorker.object.po_no2[ index ]
		idw_detail.object.container_ID[ newRow ] = idsWorker.object.container_ID[ index ]
		idw_detail.object.expiration_date[ newRow ] = idsWorker.object.expiration_date[ index ]
		idw_detail.object.serial_no[ newRow ] = idsWorker.object.serial_no[ index ]
			
	next

	idw_detail.Post Function SetRow(detailrow)
	
	idw_detail.SetRedraw(true)

else

	for index = 1 to idw_detail.RowCount()
		
		if index <> detailrow then
		
			if trim(ls_po_no2) = trim(idw_detail.GetItemString( index, "po_no2")) then
							
					idw_detail.SetItem( index, "d_location", idw_detail.GetItemString( detailrow, "d_location"))					
					
			end if
			
		end if
		
	next

end if
end subroutine

public function string getfromlocationcontainersql ();// string = GetFromLocationContainerSQL()

string lsNewSql

lsNewSql = replace(isFromLocContSql,pos(isFromLocContSql,'xxxxx'),5,gs_project) 

// pvh 11/14/05 - remove supplier code
lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
				    "' and po_no2 = '" + idw_detail.object.po_no2[ idw_detail.getrow() ] + &
				    "' and avail_qty > 0 "

					 
return lsNewSql

end function

public subroutine wf_insert_row ();long ll_row

// pvh - 10/03/05
dwitemstatus ldwStatus
ldwStatus = idw_main.getItemStatus( 1, 0, primary! )
if ldwStatus = Datamodified! or ldwStatus = NewModified! then
	iw_window.event ue_save()
end if

ll_row = idw_detail.GetRow()

If ll_row > 0 Then
	ll_row = idw_detail.rowcount()
	ll_row = idw_detail.InsertRow(ll_row + 1)
Else
	ll_row = idw_detail.InsertRow(0)
	
End If	


idw_detail.setcolumn('sku')
idw_detail.SetItem(ll_row, "to_no", getToNo() )
// reset the status to New!
idw_detail.setItemStatus( ll_row, 0, primary! , NotModified!	 )
idw_detail.setItemStatus( ll_row, 0, primary! , New! )

idw_detail.Post Function SetFocus()
idw_detail.Post Function ScrollToRow(ll_row)

return

end subroutine

public function integer wf_check_process ();

string ls_tono, srono
long ll_currow

integer li_rowcount, i, j


tab_main.tabpage_detail.dw_trans_detail_content.SetTransObject(SQLCA)
tab_main.tabpage_detail.dw_transfer_detail_content.SetTransObject(SQLCA)

datetime gmtToday
if idw_main.rowcount() > 0 then
	gmtToday = f_getLocalWorldTime( idw_main.object.s_warehouse[1] ) 
else
	gmtToday = f_getLocalWorldTime( gs_default_wh ) 
end if

ls_tono = idw_main.getitemstring(1,'to_no')

//This is to clean-up if there are any SOCs in transfer_detail_content.
//We are not using transfer detail content anymore.

tab_main.tabpage_detail.dw_transfer_detail_content.SetTransObject(SQLCA)

li_rowcount = tab_main.tabpage_detail.dw_transfer_detail_content.Retrieve(ls_tono)

if li_rowcount > 0 then
	
//	MessageBox ("FYI", "There are content records to handle.")
	
	Execute Immediate "Begin Transaction" using SQLCA; 

		
	for i = 1 to li_rowcount
		
		string ls_sku, ls_supp, ls_lcode, ls_dlcode, ls_sno, ls_lno, ls_pono, ls_itype, ls_po2, ls_container_id
		string ls_coo
		long ll_own, k, ll_totalrows
		datetime ldt_expiration_date
		
		ls_sku = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'sku')
		ls_supp = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'supp_code')
		ls_lcode = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'s_location')
		ls_dlcode = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'d_location')
		ls_sno = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'serial_no')
		ls_lno = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'lot_no')
		ls_pono = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'po_no')
		ls_itype = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'inventory_type')
		ls_po2 = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'po_no2')
		ls_container_id = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'container_id')				 
		ldt_expiration_date = tab_main.tabpage_detail.dw_transfer_detail_content.getitemdatetime(i,'expiration_date')	 
		ls_coo = tab_main.tabpage_detail.dw_transfer_detail_content.getitemstring(i,'country_of_origin')
		ll_own = tab_main.tabpage_detail.dw_transfer_detail_content.getitemnumber(i,'owner_id')

		//dw_trans_detail_content   --> new dw
		
	
//		MessageBox (ls_sku, ls_lcode)
	
		k = tab_main.tabpage_detail.dw_trans_detail_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
			 "' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			 " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())
			
		If k	<= 0 Then
			tab_main.tabpage_detail.dw_trans_detail_content.retrieve(gs_project, getWarehouse(), ls_sku,ls_supp,ll_own,ls_lcode, ls_sno, &
										  ls_lno, ls_pono,ls_po2, ls_itype,ls_coo, ls_container_id, ldt_expiration_date )
		End If
		
			
		sRoNo = Upper(tab_main.tabpage_detail.dw_transfer_detail_content.GetItemString(i,'ro_no'))
		
		ll_currow = tab_main.tabpage_detail.dw_trans_detail_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
			  "' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(ro_no) = '" + sRoNo + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, tab_main.tabpage_detail.dw_trans_detail_content.RowCount())
		
		
		If ll_currow <= 0 Then
				ll_currow = tab_main.tabpage_detail.dw_trans_detail_content.InsertRow(0)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'project_id',gs_project)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'sku',ls_sku)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'supp_code',ls_supp)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'wh_code',getWarehouse() )
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'l_code',ls_lcode)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'inventory_type',ls_itype)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'serial_no',ls_sno)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'lot_no', ls_lno)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'po_no', ls_pono)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'po_no2', ls_po2)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'container_id', ls_container_id)  			
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'expiration_date', ldt_expiration_date)	
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'country_of_origin', ls_coo)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'owner_id', ll_own)
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'ro_no', sRoNo )
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'complete_date',tab_main.tabpage_detail.dw_transfer_detail_content.GetItemDateTime(i,'complete_date'))
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'cntnr_Length',tab_main.tabpage_detail.dw_transfer_detail_content.GetItemNumber(i,'cntnr_Length')) 
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'cntnr_Width',tab_main.tabpage_detail.dw_transfer_detail_content.GetItemNumber(i,'cntnr_Width')) 
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'cntnr_Height',tab_main.tabpage_detail.dw_transfer_detail_content.GetItemNumber(i,'cntnr_Height')) 
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'cntnr_Weight',tab_main.tabpage_detail.dw_transfer_detail_content.GetItemNumber(i,'cntnr_Weight')) 
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'last_user', gs_userid)
				// pvh 11/30/05 - gmt
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'last_update', gmtToday )
				//idw_content.setitem(ll_currow,'last_update',  datetime( today(), now() ) )
				tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'reason_cd', 'ST')
				
			End If
			
			tab_main.tabpage_detail.dw_trans_detail_content.setitem(ll_currow,'avail_qty', &	
			tab_main.tabpage_detail.dw_trans_detail_content.getitemnumber(ll_currow, "avail_qty") + &
			tab_main.tabpage_detail.dw_transfer_detail_content.GetItemNumber(i,'quantity'))
			
		
	next
	
	
	for j = li_rowcount to 1 Step -1
			tab_main.tabpage_detail.dw_transfer_detail_content.DeleteRow(j)
	next
	
	
end if

IF tab_main.tabpage_detail.dw_trans_detail_content.Update() <> 1 THEN
	
	Execute Immediate "ROLLBACK" using SQLCA;
	RETURN -1
	
END IF

IF tab_main.tabpage_detail.dw_transfer_detail_content.Update() <> 1 THEN
	
	Execute Immediate "ROLLBACK" using SQLCA;
	RETURN -1
END IF 

Execute Immediate "COMMIT" using SQLCA;


RETURN 1
end function

public function integer validate_serializeed_parents_children ();//Integer 		Row_counter, Row_counter_children, li_no_of_parents_to_serialize, li_no_of_children, li_current_parent_row, li_TO_Line_Item_No,  li_sql_err_code
//String			ls_current_parent_supp_code , ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no, ls_filter_string
//String			ls_TONO, ls_Last_User, ls_find_string
//DateTime 	ldt_Create_Date, ldt_Last_Update
//Long 			ll_Blank_serial_numbers
//
//tabmain.dw_alt_serial_child.SetRedraw(   FALSE)
//dw_alt_serial_parent.SetRedraw(FALSE)
//
//dw_alt_serial_parent.AcceptText()
//
//If NOT ( ib_Duplicated or  ib_Invalid_Data ) Then 
//	
//	dw_alt_serial_child.SetRedraw(   FALSE )
//
//	li_no_of_parents_to_serialize = dw_alt_serial_parent.RowCount()
//
//	If li_no_of_parents_to_serialize > 0 Then
//
//		ls_find_string 				=   " TRIM(serial_no_parent)	= '' or IsNull( serial_no_parent) "
//		ll_Blank_serial_numbers = dw_alt_serial_parent.Find( 	ls_find_string ,1, dw_alt_serial_parent.RowCount())
//
// 		If ll_Blank_serial_numbers < 0 THEN 
//
//			dw_alt_serial_child.Reset()
//			dw_alt_serial_child.SetFilter("")
//			dw_alt_serial_child.Filter()
//		
//			For Row_counter = 1 to li_no_of_parents_to_serialize		
//				
//				dw_alt_serial_child.Reset()
//				dw_alt_serial_child.SetFilter("")
//				dw_alt_serial_child.Filter()
//			
//				dw_soc_alt_serial_capture_save.SetFilter("")
//				dw_soc_alt_serial_capture_save.Filter()
//							
//				ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"			))
//				ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"sku_parent"					)) 	
//				ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"alt_sku_parent"				))
//				ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"serial_no_parent"			))
//
//				ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//				ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//				ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//				ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//
//				ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
//		                				'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
//					  				'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
//					  				'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'
//
//				If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
//					
//					dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//					dw_soc_alt_serial_capture_save.Filter()
//		
//					dw_alt_serial_child.Object.Data[ 1,1, dw_soc_alt_serial_capture_save.RowCount(), 23] &
//							= dw_soc_alt_serial_capture_save.Object.Data[1,1, dw_soc_alt_serial_capture_save.RowCount(), 23]
//	
//			    		If dw_alt_serial_child.RowCount() > 0 Then
//						
//						For Row_counter_children =  1 To li_no_of_children
//				
//							 dw_alt_serial_child.SetItemStatus(Row_counter_children, 0, Primary!, NewModified!)
//				 
//						Next
//			
//						li_sql_err_code = dw_alt_serial_child.Update( )
//					
//						If  NOT li_sql_err_code < 0 Then  	MessageBox(" ","database error")
//			
//					End If
//					
//				End If
//		
//			Next
//			
//			COMMIT USING SQLCA;
//			
//		Else
//			
//			ii_Error_Row_Number     =  ll_Blank_serial_numbers
//			is_Error_Error_Message  =  ' All Serial Numbers Must Be Specified Before Validating! ' 
//			ib_alt_serial_error =True
//			
//			dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//
//	         return -1
//
//		End If
//			
//	Else
//					
//			ii_Error_Row_Number     = 0
//			is_Error_Error_Message  =  'No Parent Rows To Serialize! '
//			ib_alt_serial_error =True
//			
//			dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//			
//			return -1
//	
//	End If
//Else
//		
//	ii_Error_Row_Number     = 0
//	is_Error_Error_Message  =  'Cannot save Invaid Data or Duplicate records!!'
//	ib_alt_serial_error =True
//	
//	dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//
//	 return -1
//	
//End If
//
//dw_alt_serial_parent.PostEvent( 'ue_redraw')
return 0


end function

private function boolean f_lockserialnumber (ref boolean ab_locked);// KRZ - What is the order status?
Choose Case idw_main.GetItemString(1,"ord_status")

	// Complete
	Case "C"
		
		// Set serial number parent to read  only.
		ab_locked = true
		tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Protect=1")
		
	// Anything but complete.
	Case Else
		
		// Set serial number parent to NOT read  only.
		ab_locked = false
		tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Protect=0")
		
// End What is the order status?
End Choose

// Return ab_locked
return ab_locked
end function

public function integer wf_update_content ();// int = wf_update_content()

//this function is modified by DGM  FROm 09/13/00 to 10/13/00
//We have modified all search criteia added supp_code,po,po2,owner,coo
//same parameters are also added for the all retrival parameters
//Same filds have been added for getitem & setitem statements

decimal ld_req, ld_avail //GAP 11-02  convert to decimal
long i, j, k, ll_currow, ll_totalrows,ll_own,ll_new_own, llCompNo, ll_line_item_no
string ls_sku, ls_lcode,ls_dlcode, ls_itype,ls_new_itype,ls_sno,ls_lno,ls_Pono,ls_new_pono
string ls_supp,ls_po2,ls_coo
string ls_container_id 			//GAP 11-02 
datetime ldt_expiration_date	//GAP 11-02 
string sRoNo, lsMsg
string sFilter
long tester

dwitemstatus ldis_status

idw_content_append.Reset()
idw_content_append.SetFilter("")
idw_transfer_detail_content_append.Reset()


if idw_main.rowcount() < 1 then return -1

// pvh 11/30/05 - gmt
datetime gmtToday
if idw_main.rowcount() > 0 then
	gmtToday = f_getLocalWorldTime( idw_main.object.s_warehouse[1] ) 
else
	gmtToday = f_getLocalWorldTime( gs_default_wh ) 
end if

// 04/05 - PCONKL - No COntent to process if status is X (Pending FWD Pick Replenishment)
If getOrderStatus()  = 'X' Then Return 0

// Retrieve related content records for all modified rows

for i = 1 to idw_detail.rowcount()

	ldis_status = idw_detail.getitemstatus(i,0,Primary!)
	If ibFWDPickPending Then /*always retrieve content if Pending FWD Pick*/
	Elseif ldis_status <> newmodified! and ldis_status <> datamodified! then
		continue
	End If
	
	ls_sku = Upper(idw_detail.getitemstring(i,'sku'))
	ls_supp = Upper(idw_detail.getitemstring(i,'supp_code'))
	ls_lcode = Upper(idw_detail.getitemstring(i,'s_location'))
	ls_sno = Upper(idw_detail.getitemstring(i,'serial_no'))
	ls_lno = Upper(idw_detail.getitemstring(i,'lot_no'))
	ls_pono = Upper(idw_detail.getitemstring(i,'po_no'))
	ls_po2 = Upper(idw_detail.getitemstring(i,'po_no2'))
	ls_container_id =  Upper(idw_detail.getitemstring(i,'container_id'))		//GAP 11-02 
	ldt_expiration_date = idw_detail.getitemDateTime(i,'expiration_date')	//GAP 11-02 
	ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin'))
	
	ll_own = idw_detail.getitemnumber(i,'owner_id')
	ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type'))
	
	k = idw_content_append.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
      	"' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) + &
		" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) +&
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())
		
	If k	<= 0 Then
		
		idw_content_append.retrieve(gs_project, getWarehouse(), ls_sku,ls_supp,ll_own, ls_lcode, &
										ls_sno, ls_lno, ls_pono,ls_po2,ls_itype,ls_coo, ls_container_id,&
										ldt_expiration_date ) 
		
	End If
next


// Return original values of modified old records to content table

// LTK 20110111  SOC updates
// For SOC, we only want to perform this step if this update is subsequent to the initial update.
// This means that if transfer_detail_content rows have been inserted, we want to return
// those values to the content table here.

for i = 1 to idw_detail.rowcount()
	
	ldis_status = idw_detail.getitemstatus(i,0,Primary!)

	if ldis_status <> datamodified! and getOrderStatus() <> "V" and getOrderStatus() <> "N" then Continue


	if ib_SetNewFlag or getOrderStatus() = "V" then

		if ( Trim(idw_detail.GetItemString(i,"s_location")) = "*" or &
			Trim(idw_detail.GetItemString(i,"d_location")) = "*" ) then

			// If this row has not been inserted into transfer_detail_content, continue
			Continue
		else
			// The value for this transfer_detail_content row will be returned to content below
		end if


	elseif ldis_status = DataModified! and &
		( Trim(idw_detail.GetItemString(i,"s_location",Primary!,TRUE)) = "*" or &
			Trim(idw_detail.GetItemString(i,"d_location",Primary!,TRUE)) = "*" ) then

				// This is the initial setting of these fields, therefore they were never inserted into the 
				// transfer_detail_content table.  Do not execute the loop's code for this occasion.
				
				Continue
				
	elseif ldis_status = NewModified! or ldis_status = New! or ldis_status = NotModified! then

				Continue
				
	end if

	// 04/05 - PCONKL - If Pending FWD Pick Executuin, there won't be any content ro process
	If ibfwdpickpending Then Exit
	
	ls_sku = Upper(idw_detail.getitemstring(i,'sku',Primary!,True))
	ls_supp = Upper(idw_detail.getitemstring(i,'supp_code',Primary!,True))
	ls_lcode = Upper(idw_detail.getitemstring(i,'s_location',Primary!,True))
	ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
	ls_sno = Upper(idw_detail.getitemstring(i,'serial_no',Primary!,True))
	ls_lno = Upper(idw_detail.getitemstring(i,'lot_no',Primary!,True))
	ls_pono = Upper(idw_detail.getitemstring(i,'po_no',Primary!,True))
	ls_new_pono = Upper(idw_detail.getitemstring(i,'new_po_no',Primary!,True))
	ls_po2 = Upper(idw_detail.getitemstring(i,'po_no2',Primary!,True))
	ls_container_id = Upper(idw_detail.getitemstring(i,'container_id',Primary!,True))	//GAP 11-02 
	ldt_expiration_date = idw_detail.getitemDateTime(i,'expiration_date',Primary!,True)	//GAP 11-02 
	ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin',Primary!,True))
	ll_own = idw_detail.getitemnumber(i,'owner_id',Primary!,True)
	ll_new_own = idw_detail.getitemnumber(i,'new_owner_id',Primary!,True)	
	ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type',Primary!,True))
	ls_new_itype = Upper(idw_detail.getitemstring(i,'new_inventory_type',Primary!,True))	
	ll_line_item_no = idw_detail.getitemnumber(i,'line_item_no',Primary!,True)

	// Retrieving transfer_detail_content with the 3 "new" fields

//	idw_transfer_detail_content_append.retrieve( getToNo() , ls_sku, ls_supp,ll_own,ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,ls_pono,ls_po2, &
//									ls_container_id, ldt_expiration_date,ls_coo, ll_line_item_no )

	// Use the 3 "new" fields for retrieval from transfer_detail_content
	idw_transfer_detail_content_append.retrieve( getToNo() , ls_sku, ls_supp,ll_new_own,ls_lcode, ls_dlcode, ls_new_itype, ls_sno, ls_lno,ls_new_pono,ls_po2, &
									ls_container_id, ldt_expiration_date,ls_coo, ll_line_item_no )
	ll_totalrows = idw_transfer_detail_content_append.RowCount()
	//GailM 1/21/2020 DE14186 If query with new owner fails, try with original owner
	If ll_totalrows <= 0 Then
		idw_transfer_detail_content_append.retrieve( getToNo() , ls_sku, ls_supp,ll_own,ls_lcode, ls_dlcode, ls_new_itype, ls_sno, ls_lno,ls_new_pono,ls_po2, &
									ls_container_id, ldt_expiration_date,ls_coo, ll_line_item_no )
									
		ll_totalrows = idw_transfer_detail_content_append.RowCount()
	End If
	
	If ll_totalrows <= 0 Then
			lsMsg = "Could not retrieve Pick Detail.~n~r"
			lsMsg += " One of the below variables is incorrect: ~n~r"
			lsMsg += "ToNo:" + getToNo() + "~n~r"
			lsMsg += "ls_sku:" + ls_sku + "~n~r" 	
			lsMsg += "ls_supp:" + ls_supp + "~n~r" 	
			lsMsg += "ll_new_own:" + string(ll_new_own) + "~n~r"	
			lsMsg += "ls_lcode:" + ls_lcode + "~n~r"	
			lsMsg += "ls_dlcode:" + ls_dlcode + "~n~r" 	
			lsMsg += "ls_new_itype:" + ls_new_itype + "~n~r" 	
			lsMsg += "ls_sno:" + ls_sno + "~n~r" 	
			lsMsg += "ls_lno:" + ls_lno + "~n~r" 	
			lsMsg += "ls_new_pono:" + ls_new_pono + "~n~r" 	
			lsMsg += "ls_po2:" + ls_po2 + "~n~r" 	
			lsMsg += "ls_container_id:" + ls_container_id + "~n~r" 	
			lsMsg += "ldt_expiration_date:" + string(ldt_expiration_date) + "~n~r" 	
			lsMsg += "ls_coo:" + ls_coo + "~n~r" 	
			lsMsg += "ll_line_item_no:" + string(ll_line_item_no) + "~n~r" 	
	f_method_trace_special( gs_project,this.ClassName() + ' -wf_update_content','TransferDetailContentAppend error: ' + lsMsg,getToNo(),' ',' ',isOrderNo  ) 
			lsMsg = "Could not populate transfer detail content append.~n~nSystem error 10002, please contact system support!"
			MessageBox(is_title, lsMsg, StopSign!)
		Return -1
	End If

	k = idw_content_append.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
	     " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())

		
	If k	<= 0 Then
		idw_content_append.retrieve(gs_project, getWarehouse() , ls_sku, ls_supp,ll_own,ls_lcode, ls_sno, ls_lno, &
										ls_pono,ls_po2, ls_itype,ls_coo, ls_container_id, ldt_expiration_date ) 


	End If
	
	for j = 1 to ll_totalrows
		
		sRoNo = Upper(idw_transfer_detail_content_append.GetItemString(j,'ro_no'))
		ll_currow = idw_content_append.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		    "' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			 "' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(ro_no) = '" + sRoNo + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())
			
		If ll_currow <= 0 Then
			
			ll_currow = idw_content_append.InsertRow(0)
			idw_content_append.setitem(ll_currow,'project_id',gs_project)
			idw_content_append.setitem(ll_currow,'sku',ls_sku)
			idw_content_append.setitem(ll_currow,'supp_code',ls_supp)
			idw_content_append.setitem(ll_currow,'wh_code',getWarehouse() )
			idw_content_append.setitem(ll_currow,'l_code',ls_lcode)
			idw_content_append.setitem(ll_currow,'inventory_type',ls_itype)
			idw_content_append.setitem(ll_currow,'serial_no',ls_sno)
			idw_content_append.setitem(ll_currow,'lot_no', ls_lno)
			idw_content_append.setitem(ll_currow,'po_no', ls_pono)
			idw_content_append.setitem(ll_currow,'po_no2', ls_po2)			
			idw_content_append.setitem(ll_currow,'container_id', ls_container_id)			//GAP 11-02 
			idw_content_append.setitem(ll_currow,'expiration_date', ldt_expiration_date)	//GAP 11-02 		
			idw_content_append.setitem(ll_currow,'country_of_origin', ls_coo)
			idw_content_append.setitem(ll_currow,'owner_id', ll_own)
			idw_content_append.setitem(ll_currow,'ro_no',sRoNo)
			idw_content_append.setitem(ll_currow,'complete_date',idw_transfer_detail_content_append.GetItemDateTime(j,'complete_date'))
			idw_content_append.setitem(ll_currow,'cntnr_Length',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Length')) /* 12/03 - PCONKL*/
			idw_content_append.setitem(ll_currow,'cntnr_Width',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL*/
			idw_content_append.setitem(ll_currow,'cntnr_Height',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL*/
			idw_content_append.setitem(ll_currow,'cntnr_Weight',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL*/
			idw_content_append.setitem(ll_currow,'last_cycle_count',idw_transfer_detail_content_append.GetItemDateTime(j,'last_cycle_count'))  /* 2017/12/7 - TAM - Need to return Last_Cycle_Count*/
			idw_content_append.setitem(ll_currow,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content_append.setitem(ll_currow,'last_update', gmtToday )
			//idw_content_append.setitem(ll_currow,'last_update', datetime( today(), now() ) )
			idw_content_append.setitem(ll_currow,'reason_cd', 'ST')
		End If


		idw_content_append.setitem(ll_currow,'avail_qty', &
			idw_content_append.getitemnumber(ll_currow, "avail_qty") + &
			idw_transfer_detail_content_append.GetItemNumber(j,'quantity'))
			
	next
	
	for j = ll_totalrows to 1 Step -1
		idw_transfer_detail_content_append.DeleteRow(j)
	next
	
next

long test
test = idw_detail.deletedcount()
// Return deleted rows to content table
for i = 1 to idw_detail.deletedcount()

	ldis_status = idw_detail.getitemstatus(i,0,Delete!)
	if ldis_status = new! or ldis_status = newmodified! then Continue
	

	if Trim(idw_detail.GetItemString(i,"s_location",Primary!,TRUE)) = "*" or &
		Trim(idw_detail.GetItemString(i,"d_location",Primary!,TRUE)) = "*" then

		// This is the initial setting of these fields and therefore they were never inserted into the 
		// transfer_detail_content table.  Do not execute the loop's code for this occasion.
				
		Continue				
	end if
	
	
	
	// 04/05 - PCONKL - If Pending FWD Pick Executuin, there won't be any content ro process
	If ibfwdpickpending  Then Exit

	ls_sku = idw_detail.getitemstring(i,'sku',Delete!,True)
	ls_supp = idw_detail.getitemstring(i,'supp_code',Delete!,True)
	ls_lcode = idw_detail.getitemstring(i,'s_location',Delete!,True)
	ls_dlcode = idw_detail.getitemstring(i,'d_location',Delete!,True)
	ls_sno = idw_detail.getitemstring(i,'serial_no',Delete!,True)
	ls_lno = idw_detail.getitemstring(i,'lot_no',Delete!,True)
	ls_pono = idw_detail.getitemstring(i,'po_no',Delete!,True)
	ls_new_pono = idw_detail.getitemstring(i,'new_po_no',Delete!,True)
	ls_itype = idw_detail.getitemstring(i,'inventory_type',Delete!,True)
	ls_new_itype = idw_detail.getitemstring(i,'new_inventory_type',Delete!,True)
	ls_po2 = idw_detail.getitemstring(i,'po_no2',Delete!,True)
	ls_container_id = idw_detail.getitemstring(i,'container_id',Delete!,True)				//GAP 11-02 
	ldt_expiration_date = idw_detail.getitemdatetime(i,'expiration_date',Delete!,True)	//GAP 11-02 
	ls_coo = idw_detail.getitemstring(i,'country_of_origin',Delete!,True)
	ll_own = idw_detail.getitemnumber(i,'owner_id',Delete!,True)
	ll_new_own = idw_detail.getitemnumber(i,'new_owner_id',Delete!,True)
	ll_line_item_no = idw_detail.getitemnumber(i,'line_item_no',Delete!,True)

	
	// Use the 3 "new" fields for retrieval from transfer_detail_content
	idw_transfer_detail_content_append.retrieve(getToNo(), ls_sku,ls_supp,ll_new_own, ls_lcode, ls_dlcode, ls_new_itype, ls_sno, ls_lno,&
									ls_new_pono,ls_po2, ls_container_id, ldt_expiration_date, ls_coo, ll_line_item_no  )
	
	ll_totalrows = idw_transfer_detail_content_append.RowCount()
	If ll_totalrows <= 0 Then		
		
		MessageBox(is_title, "System error 10001, please contact system support!", StopSign!)
		Return -1
	End If

	k = idw_content_append.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		 "' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
	    " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())
		
	If k	<= 0 Then
		idw_content_append.retrieve(gs_project, getWarehouse(), ls_sku,ls_supp,ll_own,ls_lcode, ls_sno, &
									  ls_lno, ls_pono,ls_po2, ls_itype,ls_coo, ls_container_id, ldt_expiration_date )
	End If

	for j = 1 to ll_totalrows
		
		sRoNo = Upper(idw_transfer_detail_content_append.GetItemString(j,'ro_no'))
		
		ll_currow = idw_content_append.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		     "' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(ro_no) = '" + sRoNo + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content_append.RowCount())
	
	If ll_currow <= 0 Then
			ll_currow = idw_content_append.InsertRow(0)
			idw_content_append.setitem(ll_currow,'project_id',gs_project)
			idw_content_append.setitem(ll_currow,'sku',ls_sku)
			idw_content_append.setitem(ll_currow,'supp_code',ls_supp)
			idw_content_append.setitem(ll_currow,'wh_code',getWarehouse() )
			idw_content_append.setitem(ll_currow,'l_code',ls_lcode)
			idw_content_append.setitem(ll_currow,'inventory_type',ls_itype)
			idw_content_append.setitem(ll_currow,'serial_no',ls_sno)
			idw_content_append.setitem(ll_currow,'lot_no', ls_lno)
			idw_content_append.setitem(ll_currow,'po_no', ls_pono)
			idw_content_append.setitem(ll_currow,'po_no2', ls_po2)
			idw_content_append.setitem(ll_currow,'container_id', ls_container_id)  			//GAP 11-02
			idw_content_append.setitem(ll_currow,'expiration_date', ldt_expiration_date)	//GAP 11-02
			idw_content_append.setitem(ll_currow,'country_of_origin', ls_coo)
			idw_content_append.setitem(ll_currow,'owner_id', ll_own)
			idw_content_append.setitem(ll_currow,'ro_no', sRoNo )
			idw_content_append.setitem(ll_currow,'complete_date',idw_transfer_detail_content_append.GetItemDateTime(j,'complete_date'))
			idw_content_append.setitem(ll_currow,'cntnr_Length',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Length')) /* 12/03 - PCONKL */
			idw_content_append.setitem(ll_currow,'cntnr_Width',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL */
			idw_content_append.setitem(ll_currow,'cntnr_Height',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL */
			idw_content_append.setitem(ll_currow,'cntnr_Weight',idw_transfer_detail_content_append.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL */
			idw_content_append.setitem(ll_currow,'last_user', gs_userid)
			idw_content_append.setitem(ll_currow,'last_cycle_count',idw_transfer_detail_content_append.GetItemDateTime(j,'last_cycle_count'))  /* 2017/12/7 - TAM - Need to return Last_Cycle_Count*/			// pvh 11/30/05 - gmt
			idw_content_append.setitem(ll_currow,'last_update', gmtToday )
			//idw_content_append.setitem(ll_currow,'last_update',  datetime( today(), now() ) )
			idw_content_append.setitem(ll_currow,'reason_cd', 'ST')
			
		End If
		
			idw_content_append.setitem(ll_currow,'avail_qty', &	
			idw_content_append.getitemnumber(ll_currow, "avail_qty") + &
			idw_transfer_detail_content_append.GetItemNumber(j,'quantity'))
			
	next /*Deleted Row*/
	
	for j = ll_totalrows to 1 Step -1
		idw_transfer_detail_content_append.DeleteRow(j)
	next
	
next


idw_content_append.sort()

// Transfer new requested quantity from content to transfer detail for all modified rows

If GetOrderStatus() <> "V" Then
	
	for i = 1 to idw_detail.rowcount()

		ldis_status = idw_detail.getitemstatus(i,0,Primary!)
	//	if not (ldis_status = DataModified! or ldis_status = NewModified!) then continue
	
		// 04/05 - PCONKL - FWD Pick - If we have saved existing rows before executing the transfer, the rows may be in a not modified status
		If ibfwdpickpending Then
		Else
			if not (ldis_status = DataModified! or ldis_status = NewModified!) then continue
		End If
		
		ls_sku   = Upper(idw_detail.getitemstring(i,'sku'))
		ls_supp   = Upper(idw_detail.getitemstring(i,'supp_code'))
		ls_lcode = Upper(idw_detail.getitemstring(i,'s_location'))
		ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location'))
		ls_sno   = Upper(idw_detail.getitemstring(i,'serial_no'))
		ls_lno   = Upper(idw_detail.getitemstring(i,'lot_no'))
		ls_pono   = Upper(idw_detail.getitemstring(i,'po_no'))
		ls_new_pono = Upper(idw_detail.getitemstring(i,'new_po_no'))
		ls_po2   = Upper(idw_detail.getitemstring(i,'po_no2'))
		ls_container_id   = Upper(idw_detail.getitemstring(i,'container_id'))	//GAP 11-02
		ldt_expiration_date   = idw_detail.getitemdatetime(i,'expiration_date')	//GAP 11-02
		ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type'))
		ls_new_itype = Upper(idw_detail.getitemstring(i,'new_inventory_type'))
		ld_req   = idw_detail.getitemnumber(i,'quantity') 
		ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin'))
		ll_own = idw_detail.getitemnumber(i,'owner_id')
		ll_new_own = idw_detail.getitemnumber(i,'new_owner_id')
		ll_line_item_no = idw_detail.getitemnumber(i,'line_item_no')

	sFilter = "upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
			"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
		     " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2  + &
			"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + ls_container_id + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'"  

		idw_content_append.SetFilter( sFilter )
		idw_content_append.Filter()
		
		// Transfer new requested quantity from content
		j = 0
		Do while ld_req > 0 and j < idw_content_append.RowCount()
			
			j ++
			ld_avail = idw_content_append.GetItemNumber(j, "avail_qty")
			ll_currow = idw_transfer_detail_content_append.InsertRow(0)
			idw_transfer_detail_content_append.setitem(ll_currow,'to_no', getToNo() )
			idw_transfer_detail_content_append.setitem(ll_currow,'sku',ls_sku)
			idw_transfer_detail_content_append.setitem(ll_currow,'supp_code',ls_supp)
			idw_transfer_detail_content_append.setitem(ll_currow,'s_location',ls_lcode)
			idw_transfer_detail_content_append.setitem(ll_currow,'d_location',ls_dlcode)
//			idw_transfer_detail_content_append.setitem(ll_currow,'inventory_type',ls_itype)
			idw_transfer_detail_content_append.setitem(ll_currow,'inventory_type',ls_new_itype)
			idw_transfer_detail_content_append.setitem(ll_currow,'serial_no',ls_sno)
			idw_transfer_detail_content_append.setitem(ll_currow,'lot_no',ls_lno)
//			idw_transfer_detail_content_append.setitem(ll_currow,'po_no',ls_pono)
			idw_transfer_detail_content_append.setitem(ll_currow,'po_no',ls_new_pono)
			idw_transfer_detail_content_append.setitem(ll_currow,'po_no2', ls_po2)
			idw_transfer_detail_content_append.setitem(ll_currow,'container_id', ls_container_id)				//GAP 11-02
			idw_transfer_detail_content_append.setitem(ll_currow,'expiration_date', ldt_expiration_date)		//GAP 11-02	
			idw_transfer_detail_content_append.setitem(ll_currow,'country_of_origin', ls_coo)
//			idw_transfer_detail_content_append.setitem(ll_currow,'owner_id', ll_own)
			idw_transfer_detail_content_append.setitem(ll_currow,'owner_id', ll_new_own)
			idw_transfer_detail_content_append.setitem(ll_currow,'component_no', idw_content_append.GetItemNumber(j,'component_no')) /* 10/00 PCONKL*/
			idw_transfer_detail_content_append.setitem(ll_currow,'cntnr_length', idw_content_append.GetItemNumber(j,'cntnr_length')) /* 12/03 PCONKL*/
			idw_transfer_detail_content_append.setitem(ll_currow,'cntnr_width', idw_content_append.GetItemNumber(j,'cntnr_width')) /* 12/03 PCONKL*/
			idw_transfer_detail_content_append.setitem(ll_currow,'cntnr_Height', idw_content_append.GetItemNumber(j,'cntnr_Height')) /* 12/03 PCONKL*/
			idw_transfer_detail_content_append.setitem(ll_currow,'cntnr_Weight', idw_content_append.GetItemNumber(j,'cntnr_Weight')) /* 12/03 PCONKL*/
			idw_transfer_detail_content_append.setitem(ll_currow,'ro_no',idw_content_append.GetItemString(j,'ro_no'))
			idw_transfer_detail_content_append.setitem(ll_currow,'line_item_no', ll_line_item_no)
			idw_transfer_detail_content_append.setitem(ll_currow,'last_cycle_count',idw_content_append.GetItemDateTime(j,'last_cycle_count'))  /* 2017/12/7 - TAM - Need to return Last_Cycle_Count*/			
			If ld_avail >= ld_req Then
				idw_transfer_detail_content_append.setitem(ll_currow,'quantity', ld_req)
				idw_content_append.setitem(j, "avail_qty", ld_avail - ld_req)
				ld_req = 0
			Else
				idw_transfer_detail_content_append.setitem(ll_currow,'quantity', ld_avail)
				idw_content_append.setitem(j, "avail_qty", 0)
				ld_req -= ld_avail					
			End If
		
			idw_content_append.setitem(j,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content_append.setitem(i,'last_update', gmtToday )
			idw_content_append.setitem(i,'last_update', datetime( today(), now() ) )
			idw_content_append.setitem(j,'reason_cd', 'ST')

		Loop

		If ld_req > 0 Then
			Messagebox(is_title,"Not enough inventory for transfer!",StopSign!)
			tab_main.selecttab(2)
			f_setfocus(idw_detail, i, "sku")
			return -1
		End If
	
	next /*Detail Row*/
	
End If /*Not Voided */

Return 0

end function

public function boolean wf_is_detail_complete ();// Checks to determine if all rows on the SOC detail tab have been
// populated and updated.

boolean lb_detail_complete = true
long i

for i = 1 to idw_detail.RowCount()
	if Trim(idw_detail.Object.s_location[i]) = '*' or Trim(idw_detail.Object.d_location[i]) = '*' then
		lb_detail_complete = false
		exit
	end if
next

if idw_detail.ModifiedCount() > 0 or idw_detail.DeletedCount() > 0 then
	lb_detail_complete = false
end if

Return lb_detail_complete

end function

public function boolean wf_is_detail_row_serialized ();boolean lb_detail_row_serialized
integer i

//	if idw_detail.GetRow() > 0 then
//		if idw_detail.Object.Serialized_Ind[idw_detail.GetRow()] = 'Y' or &
//			idw_detail.Object.Serialized_Ind[idw_detail.GetRow()] = 'B' then
//			
//			lb_detail_row_serialized = true
//			
//		end if
//	end if
for i = 1 to idw_detail.RowCount()
	if idw_detail.Object.Serialized_Ind[i] = 'Y' or idw_detail.Object.Serialized_Ind[i] = 'B' then
		lb_detail_row_serialized = true
		exit
	end if
next

return lb_detail_row_serialized
end function

public function boolean wf_serial_numbers_validated ();// Determines if all of the serial numbers have been validated.

boolean lb_validated = false

if idw_serial.RowCount() > 0 then

	if idw_serial.Find("Trim(serial_no_parent) = '' or IsNull(serial_no_parent) or Trim(serial_no_parent) = '-' ", 1, idw_serial.RowCount() ) > 0 then
		lb_validated = false
	else
		lb_validated = true
	end if
end if

return lb_validated

end function

protected function boolean wf_select_reconfirm_records (string as_orderno);//TimA 04/28/14
long     lrtn
boolean lbRtn = FALSE

istrparms.String_arg[1 ] = as_orderno
istrparms.String_arg[2 ] = 'SOC' //This is pass because the window can handle inbound or outbound.
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

public function integer wf_batch_validate (string astono);//19-Sep-2016 Madhu- Added to Avoid Duplicate Batch Transaction Records .

String lsTransType, lsTransStatus,lsMsg
DateTime ltdTransCreateDate, ldtTransCompleteDate

Select Trans_Type, Trans_status, Trans_Create_Date, Trans_Complete_Date
Into :lsTransType, :lsTransStatus, :ltdTransCreateDate, :ldtTransCompleteDate
From batch_Transaction with(nolock)
Where Project_ID = :gs_Project and Trans_Type = 'OC' and Trans_Order_ID = :asToNo and Trans_create_date =
(SELECT Max(Trans_create_date) AS Trans_create_date 
FROM batch_Transaction with(nolock)
GROUP BY  Trans_Type, Project_ID,  Trans_Order_ID
HAVING Project_ID = :gs_Project and Trans_Type = 'OC' and Trans_Order_ID = :asToNo);				
		
//same order confirmed by another User without re-confirming.
IF lsTransStatus = 'C' and Left(tab_main.tabpage_main.cb_confirm.Text,2) <>  'Re' and NOT (IsNull(ldtTransCompleteDate)) Then 
	lsMsg = "SOC confirmation batch transaction for this order# "+asToNo+" has already completed. Do you want to Re-Process again? '"
	f_method_trace_special( gs_project, this.ClassName() + ' - ue_confirm', 'End ue_confirm' + ' SOC confirmation batch transaction for this order has already in Completed status' ,isToNo, ' ',' ',isToNo)

	If messagebox(is_title,lsMsg,Question!,YesNo!,2) =2 Then
		Return -1
	else 
		Return 0
	end if

ELSEIF lsTransStatus = 'N' or IsNull(ldtTransCompleteDate) then
		lsMsg = "SOC confirmation batch transaction for this order already exists in New status.  Please Wait'"
		messagebox(is_title,lsMsg)
		f_method_trace_special( gs_project, this.ClassName() + ' - ue_confirm', 'End ue_confirm' + ' SOC confirmation batch transaction for this order already exists in New status' ,isToNo, ' ',' ',isToNo)
		Return -1
ELSE
		Return 0
END IF
end function

public function integer wf_commingle_validation (string as_sku, long al_new_ownerid, string as_new_pono, string as_dwhcode, string as_toloc, string as_serializedind);//04-May-2017 :Madhu PEVS-428 - SOC Allow Commingle Validation for Serialized /Non-Serialized Items.

//A. Multiple Serialized GPN's
//1. If same Owner code and Same PoNo - Allow commingle to ToLoc. (compare against Content table)
//2. If same Owner code and different PoNo - Don't Allow commingle to ToLoc. (compare against Content table)
//3. If Different Owner code and Same PoNo - Don't Allow commingle to ToLoc. (compare against Content table)
//4. If Different Owner code and Different PoNo - Don't Allow commingle to ToLoc. (compare against Content table)

//B. Multiple Non-Serialized GPN's
//1. If same Owner code and Same PoNo - Allow commingle to ToLoc. (compare against Content table)
//2. If same Owner code and different PoNo -  Allow commingle to ToLoc. (compare against Content table)
//3. If Different Owner code and Same PoNo - Don't Allow commingle to ToLoc. (compare against Content table)
//4. If Different Owner code and Different PoNo - Don't Allow commingle to ToLoc. (compare against Content table)

//C. Mix of Serialized and Non-Serialized GPN's
//1. If Same Owner code and Same PoNo - Allow commingle to ToLoc. (compare against Content table)
//2. If Same Owner code and Different PoNo - Don't Allow commingle to ToLoc. (compare against Content table)

long  ll_Row, ll_Rowcount, ll_ownerId, ll_new_ownerId, llFindRow, ll_count
string lsSql, lsError, ls_sku, ls_pono, ls_serializeInd, ls_suppcode, ls_new_pono, ls_toloc, lsFind
Datastore lds_content

lds_content =Create Datastore

lsSql = " select Distinct A.sku, A.supp_code, A.owner_Id, A.Po_No, A.l_code, B.Serialized_Ind FROM Content A with(nolock) "
lsSql +=" INNER JOIN Item_Master B with(nolock) ON A.Project_Id =B.Project_Id and A.SKU =B.SKU and A.Supp_Code =B.Supp_Code "
lsSql += " where A.Project_Id ='"+ gs_project +"' and ( A.Owner_Id <> "+ string(al_new_ownerId)+" or A.po_no <> '"+ as_new_pono+"' )"
lsSql += " and A.wh_code ='"+ as_dwhcode+"' and A.l_code ='"+ as_toloc+"' and A.avail_qty > 0"

lds_content.create( SQLCA.syntaxFromSQL(lsSql, "", lsError))
lds_content.settransobject( SQLCA)
ll_Rowcount =lds_content.retrieve( )

If (upper(as_serializedind) ='B' or upper(as_serializedind) ='Y') and (ll_Rowcount > 0) Then
	//throw error message
	Return -1

elseIf upper(as_serializedind) ='N' and ll_Rowcount > 0 Then
	
	//05-FEB-2018 :Madhu DE3103 - Removed "for" loop which is causing crashing application.
	//Optimize the below process, else application goes out of scope.
	lds_content.setfilter( "Serialized_Ind ='N'")
	lds_content.filter( )
	ll_count =lds_content.rowcount( )
	
	//Owner code should match
	lsFind =" owner_Id <>"+string(al_new_ownerId)
	llFindRow = lds_content.find( lsFind, 1, 	lds_content.rowcount( ))
	IF 	llFindRow > 0 Then return -1
	
	//re-set filter
	lds_content.setfilter("")
	lds_content.filter( )
	ll_count =lds_content.rowcount( )
	
	lds_content.setfilter( "Serialized_Ind ='B' or Serialized_Ind ='Y'")
	lds_content.filter( )
	ll_count =lds_content.rowcount( )
	
	//Owner code and PoNo should match
	lsFind =" owner_Id <>"+string(al_new_ownerId) +" and Po_No <> '"+as_new_pono+"'"
	llFindRow = lds_content.find( lsFind, 1, 	lds_content.rowcount( ))
	IF 	llFindRow > 0 Then return -1
	

//07-JUN-2017 Madhu - Which is cauing slowness and loop through all records for each iteration.	
elseIf upper(as_serializedind) ='N' and ll_Rowcount = 0 Then //New records into Stock Inquiry
	
	//Don't loop through for each iteration
	If isValidated =FALSE Then
		For ll_Row =1 TO idw_detail.rowcount( )
			ls_sku = 	idw_detail.getitemstring(ll_Row, 'sku')
			ll_new_ownerId =idw_detail.getitemnumber(ll_Row, 'new_owner_Id')
			ls_new_pono =idw_detail.getitemstring(ll_Row, 'new_po_no')
			ls_serializeInd = idw_detail.getitemstring(ll_Row,'Serialized_Ind')
			ls_toloc = idw_detail.getitemstring(ll_Row, 'd_location')
			
			If (as_toloc = ls_toloc) Then //If same To Location, validation occur
			choose case upper(ls_serializeInd)
				case 'N' //Non-Serialized
					//Ownercode should match
					If ll_new_ownerId <> al_new_ownerId Then
						isValidated =FALSE
						//throw error message
						Return -1
					End If
					
				case 'B', 'Y' //Serialized
					//Owner code and PoNo should match
					If (ll_new_ownerId <> al_new_ownerId) or (ls_new_pono <> as_new_pono) Then
						isValidated =FALSE
						//throw error message
						Return -1
					End If
			end choose
		End If
			
		Next
		
		isValidated =TRUE //don't repeat validation for each iteration
End IF
	
End If

destroy lds_content
Return 0
end function

public function integer wf_check_full_pallet_container ();//MEA - 1/18 - SIMS-F5726 
//Add logic in ue_save to validate that if a SKU is tracked by both po_no2 and Container_ID that both full pallets and containers are being transferred.
//If not, display a message that the Pallet/Carton must be split through the Stock Adjustment function first. This logic should be encapsulated so it can be called elsewhere (see below)
long ll_idx, ll_Count, ll_Qty, ll_This_Alloc, llAvailQty, llAllocContainers, llEmptyContainers, modifiedrow, llThisOrder
long llFootprintSerialNumbersPresent, llLinked, llNbrSerialLinked
string ls_sku, ls_Supplier, ls_pono_2, ls_whcode, ls_container_id, lsLocation, lsToNo
string lsOrderNbr, lsOrderType, lsSharedContainer, lsThisOrderType, lsMixedType, lsFilter
string lsMsg1, lsMsg2, lsMsg3, lsMsg4, lsMsg5, lsMsg6
string lsMixedContFlag, lsGPNConversionFlag
int liRtn
boolean lbFootprint, lbAllocated, ibMixedContainerization, lbDashedFootprint, lbLooseSerials
str_parms lstr_parms
u_ds_ancestor ldsSerial

lsMixedContFlag = f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION")
lsGPNConversionFlag = f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION")

IF gs_project <> 'PANDORA' THEN Return 0 

ldsSerial = Create u_ds_ancestor
ldsSerial.dataobject = 'd_serial_container'
ldsSerial.SetTransObject(SQLCA)

ibFootprintAlloc = TRUE
lsOrderNbr = ""
lsOrderType = ""

FOR ll_idx  = 1 to idw_detail.RowCount()

	ls_sku = idw_detail.GetItemString( ll_idx, "sku")
	ls_Supplier =  idw_detail.GetItemString( ll_idx, "supp_code")
	ls_pono_2	=  idw_detail.GetItemString( ll_idx, "po_no2")
	ls_container_id = idw_detail.GetItemString( ll_idx, "container_id")
	ls_whcode = idw_main.getItemString(1, 's_warehouse')
	lsLocation = idw_detail.GetItemString( ll_idx, "s_location")
	lsToNo = idw_main.getItemString(1, 'to_no')
	ll_Qty =   idw_detail.GetItemNumber( ll_idx, "quantity")
	lbAllocated = FALSE
	ibMixedContainerization = FALSE
	lbFootprint = f_is_sku_foot_print(ls_sku, ls_Supplier)
	lbLooseSerials = (ls_pono_2 = gsFootPrintBlankInd and ls_container_id = gsFootPrintBlankInd)
	lbDashedFootprint = (ls_pono_2 = "-" or ls_container_id = "-")
		
	If lbFootprint and lsGPNConversionFlag = 'Y' Then
		If lsLocation = "*" Then Return 0		//SOC has been unallocated...  do not process
		If (ls_pono_2 = gsFootPrintBlankInd and ls_container_id = gsFootPrintBlankInd) OR  (ls_pono_2 = '-' and ls_container_id = '-') Then
			select count(*) into :llNbrSerialLinked	from serial_number_inventory with (nolock) where project_id = :gs_project and wh_code = :ls_whcode
			and sku = :ls_sku and l_code = :lsLocation and po_no2 = :ls_pono_2 and carton_id = :ls_container_id and do_no = :lsToNo using sqlca;

			select count(*) into :llFootprintSerialNumbersPresent from serial_number_inventory with (nolock) where project_id = :gs_project 
			and wh_code = :ls_whcode and sku = :ls_sku and l_code = :lsLocation and po_no2 = :ls_pono_2 and carton_id = :ls_container_id using sqlca;
			
			If llNbrSerialLinked < ll_Qty Then								//Not enough SNs linked
				If llFootprintSerialNumbersPresent >= ll_Qty Then		//But enough SNs present
					llFootprintSerialNumbersPresent = 0	
				Else
					llFootprintSerialNumbersPresent = llFootprintSerialNumbersPresent - llNbrSerialLinked		//Not enough linked and not enough present - add SNs
				End If
			ElseIf llNbrSerialLinked = ll_Qty Then
				llFootprintSerialNumbersPresent = 0
			End If
		Else
			llFootprintSerialNumbersPresent = f_footprint_serial_numbers(ls_sku, ls_whcode, lsLocation, ls_pono_2, ls_container_id, ll_Qty)
		End If
		
		If llFootprintSerialNumbersPresent <> 0 Then
			lsMsg6 += "Footprint GPN " + ls_sku + " must contain serial numbers for pallet " + ls_pono_2 + " and container " + ls_container_id + "."
			If ll_Qty < llFootprintSerialNumbersPresent Then		//Quantity required is less that difference between Content and Serial Number Inventory
				lsMsg6 += "Detail row " + string(ll_idx) + " requires " + string(ll_Qty) + " serial numbers.  Missing serial numbers"
				lsMsg6 += " for this WH/GPN/Loc/Pallet/Container: " + string(llFootprintSerialNumbersPresent)
			Else
				lsMsg6 += "~n~rThere are " + string(ABS(llFootprintSerialNumbersPresent)) + " missing serial numbers for this WH/GPN/Loc/Pallet/Container.~n~r~n~r" 
			End If

			idw_detail.SetItem(ll_idx, "color_code", "9")
			idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			idw_detail.SetItem(ll_idx, "mixed_type", "N")
			idw_detail.SetItemStatus(ll_idx, "mixed_type", Primary!, NotModified! )
			ibSplitContainerRequired = TRUE
//			tab_main.SelectTab(2)
//			tab_main.tabpage_detail.SetFocus()
//			idw_detail.SetColumn("container_id")
//			idw_detail.SetFocus()
//			idw_detail.ScrollToRow(1)
		End If
	End If
	
		If ls_pono_2 = gsFootPrintBlankInd or ls_container_id = gsFootPrintBlankInd Then 
			ibMixedContainerization = TRUE
			If ls_pono_2 = gsFootPrintBlankInd and ls_container_id <> gsFootPrintBlankInd Then
				lsMixedType = "P"		//Pallet w/serials
			ElseIf  ls_pono_2 <> gsFootPrintBlankInd and ls_container_id = gsFootPrintBlankInd Then
				lsMixedType = "C"		//Container w/serials
			ElseIf  ls_pono_2 = gsFootPrintBlankInd and ls_container_id = gsFootPrintBlankInd Then
				//Check loose serials for SerialFlag = "L".  If they are already set, do not set highlight to yellow
				ll_count = ldsSerial.Retrieve( gs_project, ls_whcode, ls_sku, ls_pono_2)
				lsFilter = "carton_id = '" + ls_container_id + "' and l_code = '" + lsLocation + "' and do_no = '" + lsToNo + "' "
				ldsSerial.SetFilter(lsFilter)
				ldsSerial.Filter()
				
				llLinked = ldsSerial.RowCount()
				If ll_Qty <> llLinked Then
					lsMixedType = "S"		//Loose Serials
				Else
					continue
				End If
			End If
		ElseIf lbFootprint and (ls_pono_2 = '-' or ls_container_id = '-') Then 
			If lsMsg5 = "" Then		//Only show one warning
				lsMsg5 += ls_sku + ", as a footprint GPN, under mixed containerization, the pallet and/or container must be changed to " + gsFootPrintBlankInd + &
							" as a default.  The dash remains the default for serialized GPNs that are not considered as mixed containerization.~r~n~r~n" + &
							"      Please make the change at the earliest convenience.~n~r~n~r"
				ibMixedContainerization = TRUE
			End If
		End If
		
	//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
	//Is is a Footprint GPN and not a default pallet and container then check for split
	//If lbFootprint and ls_pono_2 <> '-' and ls_container_id <> '-' then
	If ls_pono_2 = gsFootPrintBlankInd or ls_container_id = gsFootPrintBlankInd Then ibMixedContainerization = TRUE
	If lbFootprint  then
		SetMicroHelp("Checking for pallet allocation")
		SetPointer(HourGlass!)
		
		If Not ibMixedContainerization Then		//Check for allocated pallet
			lstr_parms = f_is_footprint_allocated( ls_pono_2, ls_container_id, idw_detail, ls_whcode, ls_sku )
			lsOrderNbr = lstr_parms.String_Arg[1]
			lsOrderType = lstr_parms.String_Arg[2]
			lsSharedContainer = lstr_parms.String_Arg[3]
			lsThisOrderType = lstr_parms.String_Arg[4]
			llAvailQty = lstr_parms.Long_Arg[1]
			llEmptyContainers = lstr_parms.Long_Arg[2]
			llAllocContainers = lstr_parms.Long_Arg[3]
			llThisOrder = lstr_parms.Long_Arg[4]
		End If
		
		SetMicroHelp("Continuing with pallet/container discovery...")
		
		IF lsOrderNbr <> "" and llThisOrder > 0 Then

			CHOOSE CASE lsOrderType
				CASE "S"
					lsOrderNbr = "Outbound Order " + lsOrderNbr
				CASE "O"
					lsOrderNbr = "Stock Owner Change " + lsOrderNbr
				CASE "I"
					lsOrderNbr = "Stock Transfer " + lsOrderNbr
			END CHOOSE
			If lsMsg1 > "" Then lsMsg1 = lsMsg1 + "~r~n~r~n"
			lsMsg1 += "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" + &
						+ lsOrderNbr + " has allocated unit(s) for pallet " + ls_pono_2 + &
						" and cannot be split at this time.~n~r~n~r" + &
						"Pick another pallet and re-generate the pick list or wait for the other order to process."
			lbAllocated = TRUE		
			idw_detail.SetItem(ll_idx, "color_code", "6")
			idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
		End If
		
		SELECT Count(*) INTO :ll_count 
			from Serial_Number_Inventory 
				where Project_Id =: gs_project
				and sku = :ls_sku
				and wh_code = :ls_whcode
				and po_no2 =:ls_pono_2
				and carton_id = :ls_container_id
				and l_code = :lsLocation
				and left(serial_no,1) <> '?'
			USING SQLCA;
			
		If ll_count = ll_Qty Then llLinked = ll_count
			
		IF Not lbAllocated Then
			If ll_Qty <> ll_count and llThisOrder > 0 and Not ibMixedContainerization Then		//This container requires split
				If lsMsg2 > "" Then lsMsg2 = lsMsg2 + "~r~n~r~n"
				lsMsg2 += "Footprint pallets/containers must remain full to be moved." + &
					"~rGPN " + ls_sku + " has a quantity of " + string(ll_Qty) + " and " + &
					"container: " +ls_container_id + " has " + string(ll_count) + " units." + &
					"  Pallet: " + ls_pono_2 + " units not included in~rthis move will have new pallet/container numbers." + &
					"~r~r~nDouble-click the container field on the Owner Change Detail screen to split the container."
				idw_detail.SetItem(ll_idx, "color_code", "5")
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			ElseIf llEmptyContainers > 0 and llAllocContainers > 0 and Not ibMixedContainerization Then
				lsMsg3 +=  "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" + &
					"There are " + string(llAllocContainers) + " full footprint container(s) with " +string(llEmptyContainers + llAllocContainers) + " containers in Pallet " + ls_pono_2 + "~r~n~r" + &
					"The extra container(s) must be moved to another pallet.  The allocated container(s) will retain the pallet id"
				idw_detail.SetItem(ll_idx, "color_code", "7")
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )	
			ElseIf ibMixedContainerization and lsMixedType <> 'N'  and ((ll_Qty <> ll_count and ll_count > 0) or (ll_count > llLinked)) Then	//MCL needs split
				If lsMsg4 = "" Then lsMsg4 = "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" 

				lsMsg4 += "There are " + string(ll_count) + " units of mixed containerization at location " + lsLocation + " with " + string(ll_Qty) + " allocated.~n~r" 
				lsMsg4 += "Once identified, the serial number(s) allocated will be linked to this stock owner change.~n~r~n~r"
				
				idw_detail.SetItem(ll_idx, "color_code", "8")
				idw_detail.SetItem(ll_idx, "mixed_type", lsMixedType)
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
				idw_detail.SetItemStatus(ll_idx, "mixed_type", Primary!, NotModified! )
//			Else
//				If idw_detail.GetItemString(ll_idx, "color_code") <> "6" Then
//					idw_detail.SetItem(ll_idx, "color_code", "0")	//Reset color code
//					idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )		//DE13083
//				End If
			End If
		End IF
	END IF
	lbAllocated = FALSE
NEXT

If lsMsg1 > "" Then			//Pallet is allocated, stop	(6)
	MessageBox ("Pallet / Container Warning", lsMsg1 )
End If

If lsMsg2 > "" Then		//Need to split	(5)
	MessageBox ("Pallet / Container Warning", lsMsg2 )
End If

If lsMsg3 > "" and  llThisOrder > 0 Then		//Full containers, excess containers (7)	
	messagebox("Full Footprint Containers", lsMsg3)
End If

If lsMsg4 > "" and  lsMixedType <> 'N' Then		//Mixed containerization needs split (8)	
	lsMsg4 += "Double-click owner change detail ContainerId column to identify and link serial numbers. " 
	messagebox("Footprint Containers Mixed Containerization", lsMsg4)
End If

If lsMsg5 > "" Then		//Notice that dash must be change to NA	
	messagebox("Footprint Containers Mixed Containerization", lsMsg5)
End If

If lsMsg6 > "" Then		//Missing serial numbers	
	lsMsg6 += "Double-click owner change detail ContainerId column to enter serial numbers. " 
	messagebox("Footprint Containers missing serial numbers", lsMsg6)
End If

SetMicroHelp("Ready")
SetPointer(Arrow!)

If lsMsg1 > "" or lsMsg2 > "" or lsMsg3 > "" or lsMsg4 > "" or lsMsg6 > "" Then
	tab_main.SelectTab(2)
	tab_main.tabpage_detail.SetFocus()
	idw_detail.SetColumn("container_id")
	idw_detail.SetFocus()
	idw_detail.ScrollToRow(1)
	Return -1
End If

Return 0
end function

public function integer wf_is_footprint_pallet_allocated (string aspallet, string aswhcode, string assku, long althisalloc);Int liRtn = 0
Long llAvailQty, llAllocQty, llOtherQty, TotAvailQty
Int liRowContent, liRowPos

u_ds_ancestor ldsCS

ilTotAvailQty = 0

ldsCS = Create u_ds_ancestor
ldsCS.dataobject = 'd_content_summary_pallet'
ldsCS.SetTransObject(SQLCA)

//Check content summary for allocated units.  Cannot allow this pallet to be split while other orders are allocated.
liRowContent = ldsCS.Retrieve(gs_project, asWhCode, asSku, asPallet)
If liRowContent > 0 Then
	//Loop through, looking for allocated units
	For liRowPos = 1 to liRowContent
		llAvailQty = ldsCS.GetItemNumber( liRowPos, 'avail_qty')
		llAllocQty = ldsCS.GetItemNumber( liRowPos, 'alloc_qty')
		llOtherQty = ldsCS.GetItemNumber( liRowPos, 'tfr_out') + ldsCS.GetItemNumber( liRowPos, 'tfr_in') + ldsCS.GetItemNumber( liRowPos, 'wip_qty') + ldsCS.GetItemNumber( liRowPos, 'sit_qty')
		liRtn += llAllocQty + llOtherQty
		ilTotAvailQty += llAvailQty
	Next
End If

ilNbrContainers = liRowContent		//Report nbr of containers in this pallet	
alThisAlloc = liRowContent
Destroy ldsCS

Return liRtn
end function

public function boolean wf_is_detail_row_serialized (integer aidetailrow);//GailM 11/7/2019 DE13460 Must reset serial flag and dono for serialized SKUs
Boolean lbSerialized

If idw_detail.Object.Serialized_Ind[aiDetailRow] = 'Y' or idw_detail.Object.Serialized_Ind[aiDetailRow] = 'B' Then
	lbSerialized = true
End If

return lbSerialized



end function

public function integer wf_reset_serial_flag (string asdono);//GailM 11/7/2019 DE13460 Reset serial flag and dono in serial number inventory when order set to new
integer liRtn = 0

Execute Immediate "Begin Transaction" using SQLCA;

	update serial_number_inventory set serial_flag = 'N', do_no = "-", transaction_type = "SOC reset serial flag", transaction_id = :asDoNo
	where project_id = :gs_project and do_no = :asDoNo
	using SQLCA;

Execute Immediate "Commit Transaction" using SQLCA;

return liRtn
end function

public subroutine wf_check_container_scanned ();
//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -Start
Long	llRowCount,	llRowPos, llContainerCount, llHyphen
String ls_mod, ls_err, ls_yes
boolean lbDetailChanged //dts - 08/16/2024 - testing fix for 'Please save changes first...' message.-SIMS-545-Google – SIMS-Prevent movement of FP Tracked GPN movement without valid info

il_CountNotScanned = 0
il_ContainerTracked = 0
llHyphen = 0

llRowCOunt =  idw_detail.RowCount()

//GailM 09/20/2017 - SIMSPEVS-849 - Fix to SIMSPEVS-605 to all all GPNs to be validated
//	The data contains 4,300+ container tracked inventory records with a hyphen in container_id
//  	We will treat these as validaated.  Set container_tracking_ind to Y for these.  They will eventually go away
//dts - 08/16/2024 - testing fix for 'Please save changes first...' message.-SIMS-545-Google – SIMS-Prevent movement of FP Tracked GPN movement without valid info
    //testing to see if there are any other changes to idw-detail.  If not, update the dw after setting UF3...
lbDetailChanged=False
if idw_detail.getNextModified(0, Primary!)> 0 then
		lbDetailChanged=True
end if

For llRowPos = 1 to llRowCount
	If Upper(gs_project) = 'PANDORA' and  idw_detail.GetItemString( llRowPos,'Container_Tracking_Ind' ) = 'Y' and ( idw_detail.GetItemString( llRowPos, 'Container_Id' ) = '-' or  idw_detail.GetItemString( llRowPos, 'Container_Id' ) = 'NA') and  (idw_detail.GetItemString( llRowPos, 'user_field3' ) = 'N' or  isnull( idw_detail.GetItemString( llRowPos, 'user_field3' )) or  ( idw_detail.GetItemString( llRowPos, 'user_field3' )) = '') Then
		
		//dts - 08/16/2024 idw_detail.SetItem( llRowPos, 'user_field3', 'N' )- SIMS-545-Google – SIMS-Prevent movement of FP Tracked GPN movement without valid info
		 idw_detail.SetItem( llRowPos, 'user_field3', 'Y' )
		llHyphen ++
	End If
Next

//dts - 08/16/2024 - testing fix for 'Please save changes first...' message.-SIMS-545-Google – SIMS-Prevent movement of FP Tracked GPN movement without valid info
If llHyphen > 0 and not lbDetailChanged Then //Update  idw_detail to save the changes
		idw_detail.Update( )
End If

//If llHyphen > 0 Then			//Update  idw_detail to save the changes
//	 idw_detail.Update( )
//End If

If llRowCount > 0 Then		// Do nothing if no picking rows.
	For llRowPos = 1 to llRowCount
		If Upper(gs_project) = 'PANDORA' and  idw_detail.GetItemString(llRowPos,'Container_Tracking_Ind') = 'Y' Then
			il_ContainerTracked++
			If  idw_detail.GetItemString(llRowPos,'user_field3') = 'N' Then
				il_CountNotScanned++
			End If
		End If
	Next
End If

if upper(gs_project) = 'PANDORA' Then
	If il_CountNotScanned > 0  then
	//	tab_main.tabpage_pack.cb_pack_generate.Enabled = false
		//tab_main.tabpage_serial.cb_generate_ob_serial.Enabled = False
		tab_main.tabpage_Detail.cb_replace_boxid.visible = True
		tab_main.tabpage_detail.cb_replace_boxid.enabled = True
	Else
		tab_main.tabpage_detail.cb_replace_boxid.enabled = false
		//tab_main.tabpage_pick.cb_replace_boxid.visible = false
		ibSplitContainerRequired = FALSE	//GailM 5/10/2019 DE9847 Control generate buttons
	End If
End If
//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation - end 
end subroutine

public subroutine wf_soc_order_readonly (boolean ab_read);// Dinesh - 08/22/2023- SIMS-198- Google read only changes 
//wf_soc_order_readonly

if ab_read=True then
	idw_main.object.datawindow.readonly = 'yes'
	idw_detail.object.datawindow.readonly = 'yes'
	tab_main.tabpage_serial.dw_serial.object.datawindow.readonly='yes'
 	tab_main.tabpage_detail.dw_detail.object.datawindow.readonly='yes'
	tab_main.tabpage_serial.cb_serial_generate.enabled = False
	tab_main.tabpage_detail.cb_replace_boxid.enabled = False
	tab_main.tabpage_detail.cb_update_to.enabled = False
	tab_main.tabpage_detail.cb_1.enabled = False
	tab_main.tabpage_serial.cb_serial_delete.enabled = False
	tab_main.tabpage_serial.cb_serial_barcode.enabled = False
	tab_main.tabpage_main.cb_confirm.enabled = False
	tab_main.tabpage_main.cb_void.enabled = False

end if
end subroutine

event open;call super::open;DatawindowChild	ldwc, ldwc2
String				lsFilter
i_nwarehouse = create n_warehouse
iw_window = This
tab_main.MoveTab(2,0)

ilHelpTopicID = 528 /*set help topic */

end event

on w_owner_change.create
int iCurrent
call super::create
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_owner_change.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

wf_clear_screen()

isToNo = ''		// LTK 20110314 Reset to_no instance for Pandora Bug#63 (quick search not retrieving correct records)
isle_code.DisplayOnly = False
isle_code.BackColor = rgb(255,255,255) /* 10/00 PCONKL - set to white when enterable*/
isle_code.TabOrder = 10
isle_code.SetFocus()


end event

event ue_save;Integer li_ret,li_ret_l,li_ret_ll,li_return
long i,ll_totalrows, ll_no,ll_rtn, ll_detail_rows, ll_detail_rowcount,k,ll_spid,ll_spidR
datastore lds_screen_lock
String ls_prefix, ls_order,ls_Message,ls_status, lsOrderNbr,lsSyntax,lsTemp1,ls_Load_Lock,ls_invoice_no,ls_userspid,ls_tono,ls_User_IdW
Boolean lbContentFailed,lb_trailer_no , lb_seal_no,lb_lock = True,lb_read,lb_readonly=False // Dinesh - 03/16/2023- SIMS-53-Google - SIMS - Load Lock and New Loading Status
ls_Message = "Record Saved !!!"
String ls_Edit_Mode,ls_user_id,ls_order_no,lsinvoice_no,ls_display_name1,ls_display_name,ls_Edit_modeW,ls_Edit_modeR
datetime ld_entry_dateR,ld_entry_dateW

IF f_check_access(is_process,"S") = 0 THEN Return -1


//isOrderNo
// Validations

//Santosh 07/21/14 Added new Method Trace calls
f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','start ue_save: ',isToNo,' ',' ' ,isOrderNo) 

// pvh 11/30/05 - gmt
datetime ldtToday

if idw_main.rowcount() > 0 then
	ldtToday = f_getLocalWorldTime( idw_main.object.s_warehouse[ 1 ] ) 
else
	ldtToday = f_getLocalWorldTime( gs_default_wh ) 
end if
if gs_project='PANDORA' then
// Begin  - Dinesh - 06/15/2023- SIMS-198- Google - SIMS - Read Only Access
				ls_tono= idw_main.GetItemString(1,'to_no')
				lds_screen_lock = Create datastore
				lds_screen_lock.Dataobject = 'd_screen_lock_order_r'
				lds_screen_lock.settrans(sqlca)
				lds_screen_lock.retrieve(gs_System_No,'R')
				select count(*) into : il_find_matchW from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
				select user_id,UserSPID,Edit_Mode,Entry_Date into :ls_User_IdW,:ll_spid,:ls_Edit_modeW,:ld_entry_dateR from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
				select count(*) into : il_find_matchR from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='R' and screen_name='Stock Owner Change' using sqlca;
				select user_id,UserSPID,Edit_Mode,Entry_Date,order_no into :ls_User_Id,:ll_spidR,:ls_Edit_Mode,:ld_entry_dateR,:ls_Order_No from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='R' and userspid = :gl_userspid and screen_name='Stock Owner Change' using sqlca;
//					 if ls_tono= ls_Order_No and gs_userid = ls_User_IdW   then 
							select display_name into :ls_display_name from usertable with (Nolock) where userid=:ls_User_IdW;

				if  (il_find_matchW > 0 and il_find_matchR > 0) and (ls_Order_No=gs_System_No and gs_userid <> ls_User_IdW  and ll_spidR = gl_userspid ) then
						messagebox(is_title,'User Name: ' + ls_display_name + '/Session: ' + string(ll_spid) + ' is already accessing the Order Number ' + isOrderNo + '.~r~n~r~nThe screen is locked and can be accessible to read mode only.Please contact your Site Manager/Supervisor to unlock the screen or wait for sweeper to run for clearing the locked order.', Stopsign! )
						lb_readonly=True
						wf_soc_order_readonly(lb_readonly)
						Return -1
					
				elseif (il_find_matchW > 0 and  il_find_matchR > 0) and (ls_Order_No=gs_System_No and gs_userid = ls_User_IdW and ls_Edit_mode='R' and  ll_spidR = gl_userspid) then
						messagebox(is_title,'Hey!! You have already opened another session: ' +string(ll_spid)+ ' for the same Order Number ' + isOrderNo + '.~r~nPlease close all your current/previous session first and then re-open the order.', Stopsign! )
						lb_readonly=True
						wf_soc_order_readonly(lb_readonly)
						Return -1
				elseif  ib_access= True and (il_find_matchW = 0 and  il_find_matchR > 0) and (ls_Order_No=gs_System_No and gs_userid = ls_User_Id and ls_Edit_mode='R' and  ll_spidR = gl_userspid) then
						messagebox(is_title,'Hey!! You have changed this order to READ ONLY ACCESS, session: ' +string(ll_spidR)+ '. Please close all your current session and re- open the order again to make any change for this order. ', Stopsign! )
						lb_readonly= True
						wf_soc_order_readonly(lb_readonly)
						Return -1

				else
					end if
			
		End if
		
		// End Dinesh S51817 - 01/22/21 - Google - SIMS - SAP Conversion - GUI

// End - Dinesh-  06/15/2023- SIMS-198- Google - SIMS - Read Only Access


SetPointer(HourGlass!)
If idw_main.RowCount() > 0 Then
	If wf_validation() = -1 Then
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Validation Error order failed save: ',isToNo,' ',' ' ,isOrderNo) 

		SetMicroHelp("Save failed!")
		Return -1
	End If
	// pvh - 02/14/06 - gmt
	idw_main.SetItem(1,'last_update', ldtToday ) 
	//idw_main.SetItem(1,'last_update', datetime(today(),now() ) ) 
	idw_main.SetItem(1,'last_user',gs_userid)
End If

//--




// Assign Order No.

If not ib_edit  Then
// 10/00 PCONKL - Using Stored procedure to get next available RO_NO
//						Prefixing with Project ID to keep Unique within System
		
	ll_no = g.of_next_db_seq(gs_project,'Transfer_Master','TO_No')
	
	If ll_no <= 0 Then
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Unable to retrieve the next available order Number: ',isToNo,' ',' ' ,isOrderNo) 
		messagebox(is_title,"Unable to retrieve the next available order Number!")
		Return -1
	End If
	
	ls_order = Trim(Left(gs_project,9)) + String(ll_no,"000000")
	// pvh 09/21/05
	setOrderNumber( ls_order )
	isle_code.Text = ls_order
	idw_main.SetItem(1,"project_id",gs_project)
	idw_main.SetItem(1,"to_no",ls_order)
	setToNo( ls_order )

	For i = 1 to idw_detail.RowCount()
		idw_detail.SetItem(i, "to_no", ls_order)
	Next


ENd IF 

// LTK 20110111 	If the row has been modified, require that From and To locations are set.
// Default value = '*' so required field check was not used.
ll_detail_rows = idw_detail.RowCount()
for i=1 to ll_detail_rows
	dwitemstatus ldwi_status
	ldwi_status = idw_detail.getitemstatus(i,0,Primary!)
	
	if  ldwi_status = NewModified! or ldwi_status = DataModified! then
		if Trim(idw_detail.object.s_location[i]) = '*' then
			MessageBox(is_title,"Please enter a value for 'FROM'.")
			idw_detail.setRow(i)
			idw_detail.setColumn("s_location")
			return -1
		end if

		if Trim(idw_detail.object.d_location[i]) = '*' then
			MessageBox(is_title,"Please enter a value for 'TO'.")
			idw_detail.setRow(i)
			idw_detail.setColumn("d_location")
			return -1
		end if

	end if
next



// LTK 20110105  Copied code from w_tran.ue_save() to modify content
If idw_main.RowCount() > 0 Then
	If idw_main.GetItemString(1,"ord_status") <> "C" and idw_main.GetItemString(1,"ord_status") <> "X" Then
				
// LTK Test commenting modified count > 0 out so that Set New and Void will be processed in wf_update_content.
//		if idw_detail.ModifiedCount() > 0 then
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Start update content datawindow: ',isToNo,' ',' ' ,isOrderNo) 
			If wf_update_content() = -1 Then
		
				return -1
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','End update content datawindow: ',isToNo,' ',' ' ,isOrderNo) 
	
	/*
	/*
				// TODO:  determine if following code is needed...
	
				// If we are exectuing the FWD Pick Replenishment and it fails, reset the status to Pending
				If idw_main.GetItemString(1,"ord_status",Primary!,True) = "X" then
					idw_main.SetItem(1,'ord_status','X')
				End If
	*/			
				return -1
				
			Else
				
	/*			
				// TODO:  determine if following code is needed...
				
				//If FWD Pick executuin was successfull, disable button
				If idw_main.GetItemString(1,"ord_status",Primary!,True) = "X" then
					tab_main.tabpage_detail.cb_replenish.Enabled = False
					ibfwdpickpending = False
				End If
	*/							
	
	
				return -1
	*/
	
//			End If		// LTK Test commenting modified count > 0...checking this in wf_update_content

		End if
		
		// LTK 20110115 	If Set New action, set all source/destination locations 
		// 						back to their default setting of "*".
		// GWM 20191107	Also set serial number serial flag and dono to default
		if ib_setnewflag then
			ll_detail_rowcount = idw_detail.RowCount()
			for i = 1 to ll_detail_rowcount 
				idw_detail.Object.s_location[i] = "*"
				idw_detail.Object.d_location[i] = "*"		
				If wf_is_detail_row_serialized (i) Then ib_SetSerialFlag = TRUE
			next
		end if	
	End If		
End If

If ib_SetSerialFlag Then wf_reset_serial_flag(isToNo)	// GWM 20191107	Also set serial number serial flag and dono to default

//Begin - Dinesh - 08/09/2023- SIMS-198- Google read only 
if gs_project='PANDORA' and lb_readonly= True then
		wf_soc_order_readonly(lb_readonly)
end if
//End - Dinesh - 08/09/2023- SIMS-198- Google read only 

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	ls_status = idw_main.GetItemString(1,"ord_status")
	// 05/04/2010 ujh:  If the flag has not been set by cb_Set_new, then process as originally done
	if not ib_SetNewFlag  then 
		If  ls_status <> "C" and ls_status <> "V" and ls_status <> "X" Then
				idw_main.SetItem(1,"ord_status","P")
				tab_main.tabpage_main.cb_set_new.visible = true
				tab_main.tabpage_main.cb_set_new.enabled = true
		End If	
	end if
	ib_SetNewFlag = False // 05/04/2010 ujh:  reset it until set again by cb_set_new  Need this after commit to check footprint
	
	li_ret=idw_main.Update(False, False)
		
End If

//Santosh 07/21/14 Added new Method Trace calls
f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Start update  SOC: ',isToNo,' ',' ' ,isOrderNo) 


if li_ret = 1  then li_ret = idw_detail.Update(False, False)

//if li_ret = 1   then li_ret = idw_content.Update(False, False)								// LTK 20110115 Removed this var
if li_ret = 1   then li_ret = idw_content_append.Update(False, False)						// LTK 20110110 SOC updates
if li_ret = 1   then li_ret = idw_transfer_detail_content_append.Update(False, False)	// LTK 20110110 SOC updates

If IsValid(idsSerialInventory) Then
	if li_ret = 1 and idsSerialInventory.RowCount() > 0  then 
		dwItemStatus l_status
		l_status = idsSerialInventory.GetItemStatus(1, 0, Primary!)

		li_ret = idsSerialInventory.update()										// GWM 20191018 SOC updates
	End If
End If

If idw_main.RowCount() = 0  and li_ret = 1 Then li_ret = idw_main.Update(False, False)

ib_processed_at_least_one = TRUE

 //Santosh 07/21/14 Added new Method Trace calls
f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','End update SOC: ',isToNo,' ',' ' ,isOrderNo) 

//If tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.RowCount() > 0 Then
//	//messagebox("", tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Describe("serial_no_parent.Background.Color" ))
//	If li_ret = 1 and Not Trim(String(tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Describe("serial_no_parent.Background.Color" ))) = "67108864" Then 		
//		tab_main.tabpage_alt_serial_capture.TriggerEvent("ue_save")
//	Else
//		li_ret = 1 
//		ii_ret = 1
//	End If
//Else
//	li_ret = 1 
//	ii_ret = 1
//End If

ii_ret = 1

// LTK 20110203 SOC enhancements
//if li_ret = 1 and idw_serial.RowCount() > 0 then
//dts - 2014-05-05 - also need to update serials if they've been deleted.
if li_ret = 1 and (idw_serial.RowCount() > 0 or ib_SerialDeleted) then
	
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Start update serials: ',isToNo,' ',' ' ,isOrderNo) 
		
	tab_main.tabpage_serial.TriggerEvent("ue_save")

	//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','End update serials: ',isToNo,' ',' ' ,isOrderNo) 
	ib_SerialDeleted = FALSE
end if

IF (li_ret = 1 and ii_ret = 1) THEN

	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_detail.ResetUpdate()
		idw_main.ResetUpdate()
//		idw_content.ResetUpdate()		// LTK 20110115 Removed this var
		tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.ResetUpdate()
		
		//BCR 13-JUL-2011: Zero Quantities Issue Resolution => Call stored proc to delete zero qty rows right after every successful 
		//Content table update. This way, we don't have to rely on the erratic update trigger for cleanup.
		
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Start Content update : ',isToNo,' ',' ' ,isOrderNo) 
		li_return = SQLCA.sp_content_qty_zero()
		
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','End Content update : ',isToNo,' ',' ' ,isOrderNo) 
		
		//GailM 12/24/2018 S22208 - If not setting to New, check footprint for full palles, already allocated and partial containers
		If gs_Project = "PANDORA" and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y"  Then
			iiFootprintBreakRequired = wf_check_full_pallet_container()
			//GailM 2/8/2018 DE8267 Turn serial tab generate button on or off
			If iiFootprintBreakRequired = -1 Then	
				tab_main.tabpage_serial.cb_serial_generate.enabled = FALSE		//Turn Serial Tab Generate button back on	
			End If
		End If
		
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
//			wf_checkstatus()
			SetMicroHelp("Record Saved!")
		End If
		Return 0
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
		
		//Santosh 07/21/14 Added new Method Trace calls
		f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','Save Failed and Rollback : ',isToNo,' ',SQLCA.SQLErrText ,isOrderNo) 
//		idw_content.ResetUpdate()		// LTK 20110115 Removed this var
		MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	
	//Santosh 07/21/14 Added new Method Trace calls
	f_method_trace_special( gs_project,this.ClassName() + ' -ue_save','System Error record saved failed: ',isToNo,' ',SQLCA.SQLErrText ,isOrderNo) 
	
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF

return 1
end event

event ue_delete;call super::ue_delete;Long i, ll_cnt
string ls_null

If f_check_access(is_process,"D") = 0 Then Return

If Messagebox(is_title, "Are you sure you want to delete this Record?", Question!,yesno!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

ll_cnt = idw_detail.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_detail.deleterow( i )
Next

ib_changed = False


idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record	Deleted!")
Else
	SetMicroHelp("Record	deleted failed!")
End If
This.Trigger Event ue_edit()


end event

event ue_new;//string ls_Prefix,ls_order
//long ll_no
//
//// Acess Rights
//If f_check_access(is_process,"N") = 0 Then Return
//
//// Looking for unsaved changes
//If wf_save_changes() = -1 Then Return	
//
//// Clear existing data
//
//This.Title = is_title + " - New"
//ib_edit = False
//ib_changed = False
//
//wf_clear_screen()
//
//idw_main.InsertRow(0)
//idw_main.SetItem(1,"project_id",gs_project)
//idw_main.SetItem(1,"s_warehouse",gs_default_wh)
//idw_main.SetItem(1,"d_warehouse",gs_default_wh)
//idw_main.SetItem(1,'ord_type','I')
//idw_main.SetItem(1,"ord_date",Today())
//	
//setWarehouse( gs_default_wh )
//setOrderStatus( 'N' )
//
//wf_checkstatus()
//
//tab_main.tabpage_detail.Enabled = True
//
//idw_main.Show()
//idw_main.SetFocus()
//
end event

event ue_retrieve;call super::ue_retrieve;isle_code.TriggerEvent(Modified!)
end event

event ue_print;String ls_order

If ib_changed Then
	MessageBox(is_title, "Please save changes first!")
	Return
End If

ls_order = idw_main.GetItemString(1, "to_no")
If dw_report.Retrieve(ls_order) > 0 Then
	OpenWithParm(w_dw_print_options,dw_report) 
Else
	MessageBox(is_title, "Nothing to print!")
End If	
end event

event resize;tab_main.Resize(workspacewidth(),workspaceHeight())
//tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-300)
//tab_main.tabpage_search.dw_result.Resize(workspacewidth() - 80,workspaceHeight()-500)
//tab_main.tabpage_serial.dw_serial.Resize(workspacewidth() - 80,workspaceHeight()-300)
tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() * 0.98,workspaceHeight() * 0.87)
tab_main.tabpage_search.dw_result.Resize(workspacewidth() * 0.98,workspaceHeight() * 0.87)
tab_main.tabpage_serial.dw_serial.Resize(workspacewidth() * 0.98,workspaceHeight() * 0.85)

end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2, ldwc3, ldwc4
String				lsFilter

//pvh 09/16/05
idsFromLocations = create datastore
idsFromLocations.dataobject = 'dddw_content_locs'
idsFromLocations.settransobject( sqlca )

idsFromLocationsContainer = create datastore
idsFromLocationsContainer.dataobject = 'dddw_content_locs_container'
idsFromLocationsContainer.settransobject( sqlca )

isFromLocContSql = idsFromLocationsContainer.getsqlselect()


// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_search = tab_main.tabpage_search.dw_search
idw_result = tab_main.tabpage_search.dw_result
idw_detail = tab_main.tabpage_detail.dw_detail
//idw_content = tab_main.tabpage_detail.dw_content
idw_content_append = tab_main.tabpage_detail.dw_content_append												// LTK 20110105 SOC enhancements
idw_transfer_detail_content_append = tab_main.tabpage_detail.dw_transfer_detail_content_append		// LTK 20110105 SOC enhancements
idw_serial = tab_main.tabpage_serial.dw_serial

//DGM 09/26/00 Added the dddw for supplier

idw_detail.GetChild("supp_code",idwc_det_supplier)
isle_code = tab_main.tabpage_main.sle_orderno

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_detail.SetTransObject(Sqlca)
idw_result.SetTransObject(Sqlca)
//idw_content.SetTransObject(Sqlca)
idw_content_append.SetTransObject(Sqlca)						// LTK 20110105 SOC enhancements
idw_transfer_detail_content_append.SetTransObject(Sqlca)	// LTK 20110105 SOC enhancements
idw_serial.SetTransObject(Sqlca)										// LTK 20110203 SOC enhancements

dw_report.SetTransObject(Sqlca)

// 07/00 PCONKL - Filter warehouse Dropdowns by current project
idw_main.GetChild("s_warehouse",ldwc)
idw_main.GetChild("d_warehouse",ldwc2)
idw_search.GetChild("s_warehouse",ldwc3)
idw_search.GetChild("d_warehouse",ldwc4)

// 01/03 - PCONKL - Retrieve Warehouse dropdowns by Project instead of filtering
ldwc3.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc3) /* 04/04 - PCONKL - Load from USer Warehouse Datastore*/
//ldwc3.Retrieve(gs_Project)

//Share with other warehouse dropdowns
ldwc3.ShareData(ldwc) /*Source on Main*/
ldwc3.ShareData(ldwc2) /*Dest on main*/
ldwc3.ShareData(ldwc4) /*Dest on Search*/

is_org_sql = idw_result.getsqlselect()

idw_search.insertrow(0)


if gs_Project = 'PANDORA' then

	string ls_wh_code

	idw_main.object.user_field2.dddw.name='dddw_pandora_sub_inv_locs'
	idw_main.object.user_field2.dddw.displaycolumn='cust_name'
	idw_main.object.user_field2.dddw.datacolumn='cust_code'

	idw_main.object.user_field2.dddw.useasborder='yes'
	idw_main.object.user_field2.dddw.allowedit='no'
	idw_main.object.user_field2.dddw.vscrollbar='yes'
	idw_main.object.user_field2.width="650"
	idw_main.object.user_field2.dddw.percentwidth="200"

	idw_main.object.user_field2.dddw.required='yes'

	idw_main.GetChild("user_field2", ldwc)
	ldwc.SetTransObject(SQLCA)
	
	//TimA 05/10/13 Pandora issue #607
	tab_main.tabpage_detail.dw_detail.Modify("new_po_no.Protect=1") 
end if


// 03/02 - PCONKL - Inv Type being retrieved by Project in n_warehouse
i_nwarehouse.of_init_inv_ddw(idw_detail) 

// pvh
setColorMint()

// Default into edit mode
This.TriggerEvent("ue_edit")

idw_detail.SetTabOrder("s_location", 0)

//dts 2016-01-08
if f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' then
	ibSingleProjectTurnedOn = TRUE
end if

end event

event close;call super::close;//Begin - dinesh - 08/22/2023- SIMS-198- Google Read only access 
if gs_project = 'PANDORA' then
//delete from Screen_Lock where user_id=:gs_userid  and screen_name='Delivery Order'  using sqlca; // Dinesh - 06092023 - SIMS-198- Screen Lock 
delete from Screen_Lock where user_id=:gs_userid  and screen_name='Stock Owner Change' and  userspid=:gl_userspid using sqlca; // Dinesh - 06092023 - SIMS-198- Screen Lock 
commit;
end if
//End - dinesh -  08/22/2023 - SIMS-198- Google Read only access
destroy i_nwarehouse
end event

event ue_file;// LTK 20130913  Pandora #583 added the following code for exporting search results
if gs_project = 'PANDORA' and tab_main.SelectedTab = 5 then // Search Tab
                if NOT IsNull(idw_result) and idw_result.RowCount() > 0 then
                                idw_current = idw_result
                end if
end if

CALL SUPER::ue_file                       // Method is now overridden, call ancestor event

end event

event activate;call super::activate;//Santosh - added for dashboard -10/09/2014
gs_ActiveWindow = 'SOC'
gs_system_no =isToNo //15-Sep-2015 :Madhu- Global gs_System_No for logging database errors if they happen
end event

event timer;call super::timer;//17-Aug-2015 :Madhu- Added code to prevent Manual Scanning

timer(0)
ibkeytype=FALSE
ibmouseclick =FALSE
MessageBox("Manual Entry","Doesn't Accept manual Entry")
tab_main.tabpage_serial.dw_serial.setitem( idw_serial.getrow(),'serial_no_parent','-')
end event

event ue_unlock;call super::ue_unlock;ibPressF10Unlock =TRUE //17-Sep-2015 :Madhu Added to unlock order for PressKey vs SNScan
end event

type tab_main from w_std_master_detail`tab_main within w_owner_change
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 4283
integer height = 2864
integer taborder = 0
integer textsize = -8
tabpage_detail tabpage_detail
tabpage_serial tabpage_serial
tabpage_alt_serial_capture tabpage_alt_serial_capture
end type

on tab_main.create
this.tabpage_detail=create tabpage_detail
this.tabpage_serial=create tabpage_serial
this.tabpage_alt_serial_capture=create tabpage_alt_serial_capture
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_detail,&
this.tabpage_serial,&
this.tabpage_alt_serial_capture}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_detail)
destroy(this.tabpage_serial)
destroy(this.tabpage_alt_serial_capture)
end on

event tab_main::selectionchanged;SetNull(idw_current)
String ls_Edit_ModeR,ls_User_IdR,ls_Order_NoR,ls_display_name1,ls_display_name,ls_Order,lsinvoice_no,ls_userspid // Dinesh - 06/19/2023- SIMS-198- Google- Read only 
datastore lds_screen_lock
string ls_User_IdW,ls_tono
long k
boolean lb_read
// For updating sort option
CHOOSE CASE newindex
	case 1
//		// 05/04/2010 ujh
			// Begin  - Dinesh - 08/03/2023- SIMS-198- Google - SIMS - Read Only Access
			ls_tono= is_tono
			//ls_tono= isToNo
				
//			If gs_project = 'PANDORA' then
//				
//				//ls_tono = idw_main.GetItemString(1,'TO_No')
//			   if gs_System_No <> '' or not isnull(gs_System_No) then
//				lds_screen_lock = Create datastore
//				lds_screen_lock.Dataobject = 'd_screen_lock_order_r'
//				lds_screen_lock.settrans(sqlca)
//				lds_screen_lock.retrieve(gs_System_No,'R')
//				select count(*) into : il_find_matchW from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
//				select user_id,UserSPID into :ls_User_IdW,:ls_userspid from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
//				for k= 1 to lds_screen_lock.rowcount()
//					 ls_Edit_ModeR = lds_screen_lock.getitemstring(k,'edit_Mode')
//					 ls_User_IdR = lds_screen_lock.getitemstring(k,'user_Id')
//					 ls_Order_NoR =lds_screen_lock.getitemstring(k,'order_No')
//					 if ls_tono= ls_Order_NoR and gs_userid = ls_User_IdW   then 
//							select display_name into :ls_display_name1 from usertable with (Nolock) where userid=:ls_User_IdR;
//							 ls_display_name= ls_display_name + ls_display_name1+ " ,"
//							 lb_read= True
//					end if
//				next
//						if lb_read= True and  lds_screen_lock.rowcount() > 0 and ls_userspid = string(gl_userspid) then
//							messagebox(is_title,'You are accessing~r~nthe same Order Number ' + lsinvoice_no + '.~r~nThis screen is locked for the other user untill you update, save and close the Delivery Order screen for this order.', Stopsign! )
//						
//						else
//							if  il_find_matchW > 0 and ls_Order_NoR=gs_System_No and gs_userid <> ls_User_IdW  then
//								messagebox(is_title,'User Name ' + is_display_name + '  is already accessing the Order Number ' + isToNo + '.~r~nThe screen is locked and can be accessible to read mode only.Please contact your Site Manager/Supervisor to unlock the screen before the waiting time of 2 hours.', Stopsign! )
//								//lb_readonly=True
//
//							end if	
//							if il_find_matchW > 0 and ls_Order_NoR=gs_System_No and gs_userid = ls_User_IdW then
//								messagebox(is_title,'Hey!! You have already opened another session: ' +string(ls_userspid)+ ' for the same Order Number ' + isToNo + '.~r~nPlease close all your current/previous session first and then re-open the order.', Stopsign! )
//								//lb_readonly=True
//
//							end if
//						End if
//					End if
//			End if
//		// End - Dinesh - 08/03/2023- SIMS-198- Google - SIMS - Read Only Access

			if tab_main.tabpage_main.dw_main.rowcount()  > 0 then
					if upper(tab_main.tabpage_main.dw_main.getitemString(1, "Ord_status")) = "P" then
						tab_main.tabpage_main.cb_set_new.visible = true
						tab_main.tabpage_main.cb_set_new.enabled = true
					end if
				end if
		
	case 2 
		//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -Start
		If 	Upper(gs_project) = 'PANDORA' Then
			tab_main.tabpage_detail.cb_replace_boxid.Visible= true
			wf_check_container_scanned()
			
		End If
		//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -Start
		
	Case 3
//		ib_selection_changing = TRUE
//		
//		If tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.RowCount() > 0 Then
//		 
//			tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.ScrollToRow(1)
//			tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SetColumn(	"serial_no_parent"		)	
//			tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SelectText(	1, Len(	tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.GetText())	)
//			tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SetFocus()
//			
//		End If
//		 
//		 ib_selection_changing =FALSE
//

		tabpage_serial.cb_serial_generate.enabled = wf_is_detail_complete() and  wf_is_detail_row_serialized()

		//tabpage_serial.cb_serial_delete.enabled = wf_is_detail_complete() and wf_is_detail_row_serialized()
		tabpage_serial.cb_serial_delete.enabled = tabpage_serial.cb_serial_generate.enabled
		tabpage_serial.cb_serial_barcode.enabled = tabpage_serial.cb_serial_generate.enabled //03-Nov-2017 :Madhu PEVS-654 2D Barcode
		
		//GailM 2/8/2018 DE8267 Turn serial tab generate button on or off
		//Turn Serial Tab Generate button back off if break is needed
		If iiFootprintBreakRequired = -1 Then	
			tab_main.tabpage_serial.cb_serial_generate.enabled = FALSE		
		Else
			tab_main.tabpage_alt_serial_capture.cb_generate.enabled = TRUE
		End If			
		
	
			
	CASE 4
		im_menu.m_record.m_delete.Disable()
		wf_check_menu(TRUE,'sort')
		If NOT ISNULL(idw_result) Then
		 	idw_current = idw_result
			if idw_result.rowcount() > 0 then idw_result.Retrieve() // refresh search window
		End IF

// TAM - 2018/04 - S18354 - Turn on sort button for Search
	CASE 5 // Search window
		wf_check_menu(True,'sort')
		idw_current = idw_result
		
	Case Else		
		wf_check_menu(FALSE,'sort')
END CHOOSE

end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 104
integer width = 4247
integer height = 2744
string text = "Owner Change Information "
cb_readonly cb_readonly
cb_set_new cb_set_new
st_2 st_2
sle_orderno sle_orderno
cb_confirm cb_confirm
cb_void cb_void
dw_main dw_main
end type

on tabpage_main.create
this.cb_readonly=create cb_readonly
this.cb_set_new=create cb_set_new
this.st_2=create st_2
this.sle_orderno=create sle_orderno
this.cb_confirm=create cb_confirm
this.cb_void=create cb_void
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_readonly
this.Control[iCurrent+2]=this.cb_set_new
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_orderno
this.Control[iCurrent+5]=this.cb_confirm
this.Control[iCurrent+6]=this.cb_void
this.Control[iCurrent+7]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.cb_readonly)
destroy(this.cb_set_new)
destroy(this.st_2)
destroy(this.sle_orderno)
destroy(this.cb_confirm)
destroy(this.cb_void)
destroy(this.dw_main)
end on

event tabpage_main::constructor;call super::constructor;// Begin- Dinesh - 11/06/2023 - SIMS-328- Screen Lock  read only part 2 
if gs_project= 'PANDORA' then
	
	tab_main.tabpage_main.cb_readonly.visible = True
	
	if gs_system_no <> '' or not isnull(gs_system_no) then
		tab_main.tabpage_main.cb_readonly.enabled = False
	else
		tab_main.tabpage_main.cb_readonly.enabled = True
end if

else
	tab_main.tabpage_main.cb_readonly.visible = False
end if


// End- Dinesh - 11/06/2023 - SIMS-328- Screen Lock  read only part 2 
end event

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 104
integer width = 4247
integer height = 2744
cb_search cb_search
dw_search dw_search
cb_clear cb_clear
dw_result dw_result
end type

on tabpage_search.create
this.cb_search=create cb_search
this.dw_search=create dw_search
this.cb_clear=create cb_clear
this.dw_result=create dw_result
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_search
this.Control[iCurrent+2]=this.dw_search
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.dw_result
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_search)
destroy(this.dw_search)
destroy(this.cb_clear)
destroy(this.dw_result)
end on

type cb_readonly from commandbutton within tabpage_main
integer x = 2789
integer y = 1628
integer width = 462
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Read Only Access"
end type

event clicked;// Begin - Dinesh - 11/06/2023 - SIMS-328- Screen Lock  read only part 2 
boolean lb_readonly
lb_readonly= True
If MessageBox( is_title, "Are you sure you want to change this order to read only?", Question!, YesNo!, 1 ) = 1 Then
	update Screen_Lock set edit_mode='R' where  user_id=:gs_userid  and screen_name='Stock Owner Change' and  userspid=:gl_userspid using sqlca;
	tab_main.tabpage_main.cb_readonly.enabled = False
	wf_soc_order_readonly(lb_readonly)
	 ib_access= True
End If
// End - Dinesh - 11/06/2023 - SIMS-328- Screen Lock  read only part 2 
end event

type cb_set_new from commandbutton within tabpage_main
boolean visible = false
integer x = 2290
integer y = 1628
integer width = 357
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Set New"
end type

event clicked;//05/04/2010 Ujh
if checkforChanges() then	
	return
end if

// LTK 20110429 Pandora #205 - SOC Multiline Fix - ensure that user_line_item_no is not null
if idw_detail.Find("IsNull(user_line_item_no)", 1, idw_detail.RowCount()) > 0 then
	MessageBox(is_title, "System error:  this action cannot be performed because user line items have not been set.  ~rPlease contact system support!", StopSign!)
	Return -1
end if

if messagebox(is_title,'Are you sure you want to set Status to "New?" ',Question!,YesNo!,2) = 2 then
	return
End if

idw_main.setitem(1,'ord_status','N')

setOrderStatus(idw_main.object.ord_status[ 1 ] )
ib_SetNewFlag = true
ib_SerialDeleted = true		//GailM 11/7/2019 DE13260 - Delete serial tab on set to new
tab_main.tabpage_serial.TriggerEvent("ue_clear")

If iw_window.Trigger Event ue_save() = 0 Then
	MessageBox(is_title, "Order Set To New!")
	cb_set_new.visible = false
	cb_set_new.enabled = false
Else
	MessageBox(is_title, "Status Change to New failed!")
End If

ib_SetNewFlag = false		// LTK 20110111 reset flag
end event

type st_2 from statictext within tabpage_main
integer x = 366
integer y = 60
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "PANDORA SOC #:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_orderno from singlelineedit within tabpage_main
integer x = 823
integer y = 52
integer width = 626
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
integer limit = 20
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_order, ls_wh_code, ls_code,ls_OrderNbr
Integer	lirc, llCount, ll_Serialized_Indacator, li_row,ll_userspid,ll_spid,j,k
DatawindowChild	dwcFromLoc, ldwc
datastore lds_screen_lockR,lds_screen_lockW
boolean lb_locked,lb_multiple_ord_search,lb_readonly,lb_selfuser
string ls_User_Id,ls_Order_No,ls_Edit_Mode,ls_display_name, ls_User_Id1,ls_Order_No1,ls_Edit_Mode1,ls_display_name1,ls_edit_moderead
string  ls_Edit_ModeR,ls_User_IdR, ls_Order_NoR,ls_Edit_ModeW,ls_User_IdW, ls_Order_NoW,ls_spid,ls_userspid,ls_order_read,ls_to_no,ls_screen_name
Datetime ldt_user_login_Date,ldt_Entry_Date,ldt_Out_Date
dw_main.SetFocus()
dw_main.Reset()
//SetNull(isToNo)  // 05/04/2010 ujh:  This was removed to fix problem selecting an order from the search screen doubleclick
ls_order = This.Text
isOrderNo = ls_order
isle_code.text = This.Text
lb_readonly=False
lb_selfuser=False
//Datastore lds_screen_lockW

ibPressF10Unlock =FALSE //17-Sep-2015 :Madhu- Added for PressKeyVsSNScan


tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Reset()
tab_main.tabpage_serial.dw_serial.Reset()

 li_row =  tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.GetRow()
// MessageBox( "test'", string( li_row ))

tab_main.tabpage_alt_serial_capture.dw_alt_serial_child.Reset()
tab_main.tabpage_alt_serial_capture.dw_soc_alt_serial_capture_save.Reset()

ls_code = This.Text
is_tono=ls_code
w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

//If the Order # is null then select it from the db and continue
IF IsNull(isToNo) or isToNo = "" THEN
	
	//Dhirendra-11 Jan 2021-S52705- PANDORA - Added condition for Multiple search 
IF   Pos(ls_order, ",") > 0 and Upper(gs_project) ="PANDORA" THEN
	
	lb_multiple_ord_search =true
	
else

	SELECT Count(*) Into :llCount
			FROM Transfer_Master      
			WHERE ( Transfer_Master.User_Field3  like '%'+:ls_order+'%' ) and          ( Transfer_Master.Project_ID = :gs_project ) USING SQLCA;   	
		end if 
//	MessageBox ("count", llCount)
	
	If llCount > 1 and  lb_multiple_ord_search = false Then
		MessageBox(is_title, "Multiple SOCs exist for this Pandora SOC Number. Please select from the Search Screen!", Exclamation!)
		This.SetFocus()
		This.SelectText(1,Len(ls_order))
RETURN
//Dhirendra-11 Jan 2021 -S52705- PANDORA - Added elseif condition to redirect on search tab for the multiple search 
	elseif llCount = 0  and lb_multiple_ord_search = true then
		ls_OrderNbr = this.Text
		//tab_main.SelectTab ( 10 ) //18-Jun-2014 :Madhu- commented code to display appropriate
		tab_main.SelectTab ( 5 ) //18-Jun-2014 :Madhu- Added code to display appropriate
		tab_main.tabpage_search.dw_search.Object.User_Field3[1] = trim(ls_OrderNbr)
      	tab_main.tabpage_search.cb_search.Event clicked ( )
		RETURN
	
		
	ElseIf llCount < 1 Then
		MessageBox(is_title, "SOC not found, please enter again!", Exclamation!)
		This.SetFocus()
		This.SelectText(1,Len(ls_order))
		RETURN
	Else
		SELECT To_No Into :isToNo
			FROM Transfer_Master      
			WHERE ( Transfer_Master.User_Field3 = :ls_order ) and          ( Transfer_Master.Project_ID = :gs_project ) USING SQLCA;   	
	END IF

END IF
w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

IF isToNo = "" THEN RETURN

	// LTK 20110727 	Pandora #234  The serialized flag was not being set upon a reretrieve, causing serial validation errors for SOC's which did not contain serialized sku's.
	ib_Serialized = FALSE

	// LTK 20110802 	Pandora #234  Instance flags were not being reset prior to a retrieve causing undesired behavior if multiple SOC's were retrieved in the same window instance.	
	ib_SetNewFlag = FALSE
	cb_set_new.visible = FALSE
	cb_set_new.enabled = FALSE
	
	idw_main.Retrieve(isToNo,gs_project)
		
	If idw_main.RowCount() > 0 Then
	// pvh 09/21/05
		isToNo = idw_main.getitemstring(1,'to_no') 			
		
		gs_system_no =isToNo //15-Sep-2015 :Madhu- Global gs_System_No for logging database errors if they happen
		setOrderNumber( ls_order )	
	
		setWarehouse( idw_main.getitemstring(1,'s_warehouse') )		
		setToNo( idw_main.getitemstring(1,'to_no') )		
		setOrderStatus( idw_main.getitemstring(1,'ord_status') )
	
		w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo
	
		idw_detail.Retrieve(gs_project,isToNo)
		
//Begin - Dinesh - 06/08/2023 - SIMS-198 - Google - SIMS - Google - SIMS - Read Only Access 
if gs_project='PANDORA' then
//		ls_order_read=ls_order
//		SELECT invoice_no INTO :ls_invoice_no FROM Delivery_Master WHERE do_no = :ls_order_read   and project_id = :gs_project;
//		if ls_invoice_no <> "" and not isnull(ls_invoice_no) then
//			ls_order=ls_invoice_no
//			is_order_new= ls_order
//		end if
	//Begin - Dinesh - 11/06/2023 - SIMS-328 - Google - SIMS - Google - SIMS - Read Only Access part 2
		if gs_System_No <> '' or not isnull(gs_System_No) then
			tab_main.tabpage_main.cb_readonly.enabled = True
		else
			tab_main.tabpage_main.cb_readonly.enabled = False
		end if
		//End - Dinesh - 11/06/2023 - SIMS-328 - Google - SIMS - Google - SIMS - Read Only Access part 2
			lds_screen_lockW = Create datastore
			lds_screen_lockW.Dataobject = 'd_screen_lock_order_w'
			lds_screen_lockW.settrans(sqlca)
			lds_screen_lockW.retrieve(gs_System_No,'W')
			
			//select top 1 Login_Time into :ldt_user_login_Date  from User_Login_History where UserId=:gs_userid order by Login_Time desc;
			//select UserSPID into :gl_userspid  from User_Login_History where UserId=:gs_userid and Login_Time=:ldt_user_login_Date;
			select count(*) into : il_find_matchW from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
			
			lds_screen_lockR = Create datastore
			lds_screen_lockR.Dataobject = 'd_screen_lock_order_r'
			lds_screen_lockR.settrans(sqlca)
			lds_screen_lockR.retrieve(gs_System_No,'R')
		
			for j= 1 to lds_screen_lockR.rowcount()
					ls_Edit_ModeR = lds_screen_lockR.getitemstring(j,'edit_Mode')
				 	ls_User_IdR = lds_screen_lockR.getitemstring(j,'user_Id')
					ls_Order_NoR =lds_screen_lockR.getitemstring(j,'order_No')
			NEXT
			
			select count(*) into : il_find_matchR from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='R' and screen_name='Stock Owner Change' using sqlca;
			
			if (il_find_matchR > 0 and il_find_matchW=0) then
				select User_Id,Order_No,screen_name,Entry_Date,Out_Date,Edit_Mode,UserSPID into :ls_User_Id,:gs_System_No,:ls_screen_name,:ldt_Entry_Date,:ldt_Out_Date,:ls_Edit_Mode,:ll_spid from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='R' and screen_name='Stock Owner Change' using sqlca;
			end if
			if (il_find_matchW > 0 and il_find_matchR= 0) then
				select User_Id,Order_No,screen_name,Entry_Date,Out_Date,Edit_Mode,UserSPID into :ls_User_Id,:gs_System_No,:ls_screen_name,:ldt_Entry_Date,:ldt_Out_Date,:ls_Edit_Mode,:ll_spid from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;	
			end if
			if (il_find_matchR > 0 and  il_find_matchW > 0) then
				select User_Id,Order_No,screen_name,Entry_Date,Out_Date,Edit_Mode,UserSPID into :ls_User_Id,:gs_System_No,:ls_screen_name,:ldt_Entry_Date,:ldt_Out_Date,:ls_Edit_Mode,:ll_spid from Screen_Lock with(nolock) where Order_No= :gs_System_No and Edit_Mode='W' and screen_name='Stock Owner Change' using sqlca;
			end if
			
			lds_screen_lockW.retrieve(gs_System_No,'W')
				for k= 1 to lds_screen_lockW.rowcount()
					 ls_Edit_ModeW = lds_screen_lockW.getitemstring(k,'edit_Mode')
					 ls_User_IdW = lds_screen_lockW.getitemstring(k,'user_Id')
					 ls_Order_NoW =lds_screen_lockW.getitemstring(k,'order_No')
					 ll_userspid =lds_screen_lockW.getitemnumber(k,'userspid')
				next
				
					select Display_Name into :is_display_name from UserTable with(nolock) where UserId=:ls_User_IdW;
				
			
				if  gs_System_No = ls_Order_NoW and gs_userid <> ls_User_IdW and gs_System_No <> '' then
						messagebox(is_title,'User Name: ' + is_display_name + '/Session: ' + string(ll_userspid) +  ' is already accessing the Order Number ' + ls_order + '.~r~nThe screen is locked and can be accessible to read mode only.Please contact your Site Manager/Supervisor to unlock the screen or wait for sweeper run to clear the lock automatically.', Stopsign! )
						lb_readonly=True
						lb_selfuser= False
				
				elseif gs_System_No=ls_Order_NoW and gs_userid = ls_User_IdW and ll_spid <>gl_userspid and gs_System_No <> '' then
						
						messagebox(is_title,'Hey!! You have already opened another session: ' +string(ll_userspid)+ ' for~r~nthe same Order Number ' + ls_order + '.~r~n~r~nPlease close all your current/previous session first and then re-open the order.', Stopsign! )
						lb_readonly=True
						lb_selfuser= False
				
				elseif gs_System_No=ls_Order_NoW and gs_userid = ls_User_IdW and  ll_spid = gl_userspid and gs_System_No <> '' then
						//messagebox(is_title,'Hey!! You have already opened the same order in the same session with SPID ID: ' +string(ll_userspid)+ ' for~r for the Order number ' + ls_order + '.~r~n~r~n', Stopsign! )
						lb_readonly=False
						lb_selfuser= True	
			
				end if
			if lb_selfuser= False  then
			
				if (il_find_matchW =  0 and il_find_matchR = 0 )  then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; // Dinesh - 09/20/2023- Read only
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
					
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid= ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid <> gl_userspid) then
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
						commit;
						lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid= ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid <> gl_userspid) then
						delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid and Edit_Mode='R' using sqlca; //09/21/2023- Dinesh - Read only
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
						commit;
						lb_readonly=true
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid= ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid <> gl_userspid) then
						delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - Read only
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
						commit;
						lb_readonly=True
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid= ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid <> gl_userspid ) then
						delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - Read only
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
						commit;
						lb_readonly=false
				//Begin - Dinesh - 09/20/2023- SIMS-328-  Google  - Read Only Access Part 2
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid= ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid <> gl_userspid) then
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
						commit;
						lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid= ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid <> gl_userspid) then
						delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode='R' and UserSPID=:gl_userspid using sqlca; // Dinesh - 09/20/2023- SIMS-328-  Google  - Read Only Access Part 2
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
						commit;
						lb_readonly=true
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid= ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid <> gl_userspid) then
						//delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' using sqlca;
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
						commit;
						lb_readonly=True
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid= ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid <> gl_userspid ) then
						delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode='R' and UserSPID=:gl_userspid using sqlca; // Dinesh - 09/20/2023- SIMS-328-  Google  - Read Only Access Part 2
						insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
						commit;
						lb_readonly=false
				//End - Dinesh - 09/20/2023- SIMS-328-  Google  - Read Only Access Part 2
						
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid = ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid = ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid = ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode='R' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid = ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode='R' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=true
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid = ls_User_IdW and gs_System_No = ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
					
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid = ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid = gl_userspid) then
					//delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' using sqlca;
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid = ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid = ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change'  and UserSPID=:gl_userspid using sqlca;//09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid = ls_User_IdW and gs_System_No <> ls_Order_NoW and ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false

				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No <> ls_Order_NoW and  ll_spid = gl_userspid) then
					//delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' using sqlca;
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No <> ls_Order_NoW and  ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid <> ls_User_IdW and gs_System_No <> ls_Order_NoW and  ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid <> ls_User_IdW and gs_System_No <> ls_Order_NoW and  ll_spid = gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;		
					lb_readonly=false
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					//delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' using sqlca;
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=true
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode in('R','W') and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=True
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and ((gs_userid <> ls_User_IdW) or (ls_User_IdW='')  and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid<> ls_User_IdR and gs_System_No = ls_Order_NoR and ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca;//09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;
					lb_readonly=false
					
				elseif (il_find_matchW = 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No <> ls_Order_NoW and  ll_spid <> gl_userspid) then
					//delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' using sqlca;
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=true
				elseif (il_find_matchW > 0 and il_find_matchR = 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and Edit_Mode='R' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
					commit;
					lb_readonly=True
					
				elseif (il_find_matchW > 0 and il_find_matchR > 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
						lds_screen_lockW.retrieve(gs_System_No,'W')
					 for k= 1 to lds_screen_lockW.rowcount()
						 ls_Edit_ModeW = lds_screen_lockW.getitemstring(k,'edit_Mode')
						 ls_User_IdW = lds_screen_lockW.getitemstring(k,'user_Id')
						 ls_Order_NoW =lds_screen_lockW.getitemstring(k,'order_No')
						 ll_userspid =lds_screen_lockW.getitemnumber(k,'userspid')
					next
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca;//09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
				elseif (il_find_matchW = 0 and il_find_matchR > 0) and (gs_userid <> ls_User_IdW and gs_System_No = ls_Order_NoW and  ll_spid <> gl_userspid) then
					delete from screen_lock where User_Id=:gs_userid and screen_name='Stock Owner Change' and UserSPID=:gl_userspid using sqlca; //09/21/2023- Dinesh - SIMS-328-  Google  - Read Only Access Part 2
					insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'W',:gl_userspid) using sqlca;
					commit;	
					lb_readonly=false
					
				
				else
					lb_readonly=false
					//insert into Screen_Lock (User_Id,Order_No,Screen_Name,Entry_Date,Out_Date,Edit_Mode,UserSPID) values(:gs_userid,:gs_System_No,:is_title,getdate(),NULL,'R',:gl_userspid) using sqlca;
				end if	
			else
				
			end if
			
			//Begin - Dinesh - 11/06/2023 - SIMS-328 - Google - SIMS - Google - SIMS - Read Only Access part 2
			select edit_mode into :ls_edit_moderead from Screen_Lock with(nolock) where Order_No= :gs_System_No and user_id = :gs_userid and screen_name='Stock Owner Change' and userspid=:gl_userspid using sqlca;
			
			if ls_edit_moderead= 'W' then
				
				tab_main.tabpage_main.cb_readonly.enabled = True
			else
				tab_main.tabpage_main.cb_readonly.enabled = False
			end if
			//End - Dinesh - 11/06/2023 - SIMS-328 - Google - SIMS - Google - SIMS - Read Only Access part 2
		
	 End if
//End - Dinesh - 07/25/2023 - SIMS-198 - Google - SIMS - Google - SIMS - Read Only Access 

		
		//*Begin................... Akash Baghel - 08/09/2023...- SIMS 243- Match the project code in order detail tab to project code table */
        String  ls_pono, ls_new_pono, ls_pono_code, ls_new_pono_code, lsFindpono, lsFindpononew
		long   i, llrowcount1, llFindRow1, llFindRow2
		
		If gs_project = 'PANDORA'  Then
		   llrowcount1 = idw_detail.rowcount()

			datastore	ldsProjectCode
			  ldsProjectCode = Create datastore
                ldsProjectCode.dataobject= 'd_project_code'
                ldsProjectCode.SetTransobject(SQLCA)
                ldsProjectCode.Retrieve()		 
       
		 for i = 1 to llrowcount1
		       ls_pono = idw_detail.GetItemString(i, "po_no")	 
			  ls_new_pono =  idw_detail.GetItemstring(i, 'new_po_no')
		      lsFindpono = "project_code = '" +ls_pono + "'"
			  lsFindpononew = "project_code = '" +ls_new_pono + "'"	
               llFindRow1 = ldsProjectCode.Find(lsFindpono, 1, ldsProjectCode.rowcount())
			  llFindRow2 = ldsProjectCode.Find(lsFindpononew, 1, ldsProjectCode.rowcount())	
			
			 If llFindRow1 > 0 and  llFindRow2 > 0  Then
			  Elseif  llFindRow1 <= 0 and llFindRow2 <= 0  Then   
		                messagebox("Project Code Not Match", "This order of PO_NO and New_PO_NO "+ls_pono+" AND "+ls_new_pono+" has an invalid Project Code. Processing of this order is not allowed.")
			   Elseif  llFindRow1 > 0 and llFindRow2 <= 0 Then 
				        messagebox("Project Code Not Match", "This order of PO_NO and New_PO_NO "+ls_pono+" AND "+ls_new_pono+" has an invalid Project Code. Processing of this order is not allowed.")	            
			    Elseif  llFindRow1 <= 0 and llFindRow2 > 0 Then 
				       messagebox("Project Code Not Match", "This order of PO_NO and New_PO_NO "+ls_pono+" AND "+ls_new_pono+" has an invalid Project Code. Processing of this order is not allowed.")
                    	 lb_readonly=True
					wf_soc_order_readonly(lb_readonly) // Dinesh - 08/22/2023- SIMS-243 - Match the project code in order detail tab to project code table */
					 return -1
				  	
		       End if
		   Next		
	  End if
		//*End................... Akash Baghel - 08/09/2023...- SIMS 243- Match the project code in order detail tab to project code table */
		

		//dts - 2015-12-11 Now project changes will have serial numbers (not just owner changes)
		//      - Making the Single-Project rule configurable.
		long llFound
		if ibSingleProjectTurnedOn then
			llFound = idw_detail.Find( 	 "(Serialized_Ind = 'B' or Serialized_Ind = 'Y') " ,1,idw_Detail.RowCount())
		else
			llFound = idw_detail.Find( 	 "(Serialized_Ind = 'B' or Serialized_Ind = 'Y') and NOT  ( c_owner_name =  c_new_owner_name) " ,1,idw_Detail.RowCount())
		end if
		//If idw_detail.Find( 	 "(Serialized_Ind = 'B' or Serialized_Ind = 'Y') and NOT  ( c_owner_name =  c_new_owner_name) " ,1,idw_Detail.RowCount()) > 0 Then
		If llFound > 0 Then

			ib_Serialized           = TRUE
			ib_Serial_Validated = FALSE
			w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo + '   CHANGING SERIALIZED COMPONENTS P/C CAPTURE REQUIRED!'
			
			tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.retrieve(isToNo)
			tab_main.tabpage_serial.dw_serial.retrieve(isToNo)
			
			If 	tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.RowCount() > 0 Then

					tab_main.tabpage_alt_serial_capture.dw_soc_alt_serial_capture_save.Retrieve(isToNo)
					
					 If tab_main.tabpage_alt_serial_capture.dw_soc_alt_serial_capture_save.RowCount() > 0 Then 

						ib_processed_at_least_one = TRUE
						tab_main.tabpage_alt_serial_capture.cb_generate.Enabled = FALSE
					
						If tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.RowCount() > 1 Then

							// Lockdown the serial number field if necessary.
							f_lockserialnumber(lb_locked)	
							
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Background.Color = 67108864")
						
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SetColumn("serial_no_parent")
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SetRow(1)
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.ScrollToRow(1)
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.SetFocus()

							ib_new_search =TRUE
							
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.TriggerEvent( "ue_row_focus_changed" )
							
							wf_checkstatus()
							
							tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.POSTEVENT( "ue_Redraw" )
							
						End If
					Else

						tab_main.tabpage_alt_serial_capture.cb_generate.enabled =TRUE
	
					End If
					
					If tab_main.tabpage_alt_serial_capture.dw_soc_alt_serial_capture_save.RowCount() > 0 Then tab_main.tabpage_alt_serial_capture.dw_soc_alt_serial_capture_save.SetRow(1)
					
			Else
					//GailM 2/8/2018 DE8267 Turn serial tab generate button on or off
					//Turn Serial Tab Generate button back off if break is needed
					If iiFootprintBreakRequired = -1 Then	
						tab_main.tabpage_serial.cb_serial_generate.enabled = FALSE		
					Else
						tab_main.tabpage_alt_serial_capture.cb_generate.enabled = TRUE
					End If									
			End If
		
		Else
			
			w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo
			tab_main.tabpage_alt_serial_capture.cb_generate.enabled = FALSE
			
		End If
		
	End If
	
	wf_checkstatus()
	
	//Begin -08/22/2023- SIMS-198- Google- Read only for the multiple users
	if gs_project='PANDORA' then
			wf_soc_order_readonly(lb_readonly)
	end if
	//End -08/22/2023- SIMS-198- Google- Read only for the multiple users
	
	tab_main.tabpage_detail.Enabled = True
	ib_changed = False
	idw_main.Show()
	idw_main.SetFocus()
	setQtyAllDisplay( true )
	
	IF gs_Project = "PANDORA" then
		
		ls_wh_code = idw_main.GetItemString(1, "s_warehouse")
		
		if Not IsNull(ls_wh_code) AND trim(ls_wh_code) <> '' then
		
			idw_main.GetChild("user_field2", ldwc)
		
			ldwc.Retrieve(upper(gs_project), ls_wh_code)
	
		end if
		
Else
	MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
	This.SetFocus()
	This.SelectText(1,Len(ls_order))
End If
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 1193
integer y = 1628
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Confirm"
end type

event clicked;if Not checkforChanges() then	wf_confirm()

end event

type cb_void from commandbutton within tabpage_main
integer x = 1742
integer y = 1628
integer width = 357
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Void"
end type

event clicked;if messagebox(is_title,'Are you sure you want to void this order?',Question!,YesNo!,2) = 2 then
	return
End if

//Santosh 07/21/14 Added new Method Trace calls
f_method_trace_special( gs_project,this.ClassName() + ' -Void',' Start : ',isToNo,' ',' ' ,String(isle_code)) 

if checkforChanges() then	
	return
end if

idw_main.setitem(1,'ord_status','V')

setOrderStatus(idw_main.object.ord_status[ 1 ] )

If iw_window.Trigger Event ue_save() = 0 Then
	f_method_trace_special( gs_project,this.ClassName() + ' -Void',' SOc is Voided : ',isToNo,' ',' ' ,String(isle_code)) 
	MessageBox(is_title, "Record voided!")
	
	Update Serial_Number_Inventory Set serial_flag = 'N', do_no = '-', transaction_type = 'Reset serial flag on SOC Void', transaction_id = :isToNo
	Where do_no = :isToNo
	Using SQLCA;
	
Else
	f_method_trace_special( gs_project,this.ClassName() + ' -Void',' SOC is failed to Voide : ',isToNo,' ',' ' ,String(isle_code)) 
	MessageBox(is_title, "Record void failed!")
End If

f_method_trace_special( gs_project,this.ClassName() + ' -Void',' End: ',isToNo,' ',' ' ,String(isle_code)) 


end event

type dw_main from u_dw_ancestor within tabpage_main
integer x = 261
integer y = 156
integer width = 2798
integer height = 1308
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_owner_change_master"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;Return
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event itemchanged;
datawindowchild ldwc
string ls_wh_code, ls_null
long ll_owner_id, li_idx
string ls_sub_inventory_type

ib_changed = True


Choose Case dwo.name
		
	Case 's_warehouse' /* 11/00 PCONKL - Set destination warehouse = Soure Warehouse */
		
		This.SetItem(row,'d_warehouse',data)
		setWarehouse( data )
		
		IF gs_Project = "PANDORA" then
			
			ls_wh_code = data
			
			if Not IsNull(ls_wh_code) AND trim(ls_wh_code) <> '' then
			
				idw_main.GetChild("user_field2", ldwc)
			
				ldwc.Retrieve(upper(gs_project), ls_wh_code)
				
				SetNull(ls_null)
				
				//Make sure the user field 2 is reset if the wh_code is changed.
				
				idw_main.SetItem( 1, "user_field2", ls_null)
	
			end if	
			
		END IF		
		
		
	CASE "USER_FIELD2"
	
	IF gs_project = "PANDORA" THEN
		
		ls_Sub_Inventory_Type = data
		
		SELECT Owner_ID INTO :ll_owner_id FROM OWNER 
			WHERE Project_ID = "PANDORA" AND
					Owner_CD = :ls_Sub_Inventory_Type
			USING SQLCA;
		
		IF SQLCA.SQLCode = 100 THEN
			
			MessageBox ("Error", "Sub Location ("+ls_Sub_Inventory_Type+") not found in Owner Table")
			
			Return 1
			
		ELSE
		
			
			FOR li_idx = 1 to idw_detail.RowCount()
				
				//Set Owner to Sub-Inventory-Loc
				
				idw_detail.SetItem(li_idx, "owner_id", ll_owner_id)
				
			NEXT
			
	
	
		END IF
	
	END IF
		

	

End Choose
end event

type cb_search from commandbutton within tabpage_search
event ue_search ( )
integer x = 3081
integer y = 76
integer width = 311
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event ue_search();// ue_search

end event

event clicked;String  ls_criteria, ls_val, ls_sql
String ls_sku,ls_ordnbr,ls_contid
Long    ll_rows,i
Integer li_ret
Date    ld_date
datetime ldt_date
Boolean lb_tran_from
boolean lb_tran_to
boolean lb_complete_from
boolean lb_complete_to
Boolean lb_where 
String ls_search_string,ls_in_clause // Added by Dhirendra 11 Jan 2021
//Initialize Date Flags
lb_tran_from 		= FALSE
lb_tran_to 			= FAlSE
lb_complete_from 	= FALSE
lb_complete_to 	= FALSE
lb_where = False

SetPointer(HourGlass!)

idw_search.AcceptText()
ls_criteria = ""
ls_sql = is_org_sql

// 07/00 PCONKL - Always include project in Search Criteria
ls_criteria += " project_id = '" + gs_project + "' And Ord_Type = 'O' And "

// Order Starting Date
ldt_date = dw_search.GetItemDatetime(1,"order_s_date")
IF NOT IsNull(ldt_date) And String(ldt_date,"mm/dd/yyyy hh:mm") <> '01/01/1900 00:00' THEN
	ls_criteria = ls_criteria + "ord_date >= '" + String(ldt_date, "mm/dd/yyyy hh:mm") + "' And "
	lb_tran_from = TRUE
	lb_where = True
END IF

// Order Ending Date
ldt_date = idw_search.GetItemDatetime(1,"order_e_date")
IF NOT IsNull(ldt_date) And String(ldt_date,"mm/dd/yyyy hh:mm") <> '01/01/1900 23:59' THEN
	ls_criteria = ls_criteria + "ord_date <= '" + String(ldt_date, "mm/dd/yyyy hh:mm") + "' And "
	lb_tran_to = TRUE
	lb_where = True
END IF

// Completed Starting Date
ldt_date = idw_search.GetItemDateTime(1,"complete_s_date")
IF NOT IsNull(ldt_date) And String(ldt_date,"mm/dd/yyyy hh:mm") <> '01/01/1900 00:00' THEN
	ls_criteria = ls_criteria + "complete_date >= '" + String(ldt_date, "mm/dd/yyyy hh:mm") + "' And "
	lb_complete_from = TRUE
	lb_where = True
END IF

// completed Ending Date
ldt_date = idw_search.GetItemDatetime(1,"complete_e_date")
IF NOT IsNull(ldt_date) And String(ldt_date,"mm/dd/yyyy hh:mm") <> '01/01/1900 00:00' THEN
	ls_criteria = ls_criteria + "complete_date <= '" + String(ldt_date, "mm/dd/yyyy hh:mm") + "' And "
	lb_complete_to = TRUE
	lb_where = True
END IF

// Order Status
ls_val = idw_search.GetItemString(1,"status")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "ord_status = '" + ls_val + "' AND "
	lb_where = True
END IF

// Order_type
ls_val = idw_search.GetItemString(1,"order_type")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "ord_type = '" + ls_val + "' AND "
	lb_where = True
END IF

// Source Warehouse
ls_val = idw_search.GetItemString(1,"s_warehouse")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "s_warehouse = '" + ls_val + "' And "
	lb_where = True
END IF

// Destination Warehouse
ls_val = idw_search.GetItemString(1,"d_warehouse")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "d_warehouse = '" + ls_val + "' And "
	lb_where = True	
END IF

// EMail	- GailM 03/14/2014 - Added UF5 to search criteria in version 1.7.1.0.  Update 06/11/2014 for promotion to PROD
ls_val = idw_search.GetItemString(1,"user_field5")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "user_field5 = '" + ls_val + "' AND "
	lb_where = True
END IF

//SKU enter the valid sku dgm 070501
ls_sku = idw_search.GetItemString(1,"sku")
ls_contid = idw_search.GetItemString(1,"container_id")
IF NOT IsNull(ls_sku) AND ls_sku <> '' THEN
	// 07/03 Mathi Only for SKU search
	If IsNull(ls_contid) or ls_contid= "" Then
	ls_criteria = ls_criteria + "to_no in( Select  to_no from transfer_detail where " + &
   	"sku ='"+ ls_sku + "') and "
	lb_where = True
	Else
		//07/03 Mathi SKU and CONT ID search
		ls_criteria = ls_criteria + "to_no in( Select  to_no from transfer_detail where " + &
           				"sku ='"+ ls_sku + "' and container_id ='"+ ls_contid + "') and "
	lb_where = True
	End If
		
ELSE
	//07/03 Mathi Only for Container search
	If NOT IsNull(ls_contid) AND ls_contid <> "" Then
	ls_criteria = ls_criteria + "to_no in( Select  to_no from transfer_detail where " + &
           				"container_id ='"+ ls_contid + "') and "
	lb_where = True	
	End If						  
END IF

//order number enter  dgm 070501
// TAM 2018/03 - S16307 - Trim Order Number
ls_ordnbr = trim(idw_search.GetItemString(1,"order_nbr"))
IF NOT IsNull(ls_ordnbr) AND ls_ordnbr <> '' THEN
	ls_criteria = ls_criteria + "Transfer_Master.to_no like '%" + ls_ordnbr + "%' And "
	lb_where = True	
END IF

// Order Number (UF3)
ls_val = idw_search.GetItemString(1,"user_field3")
//Dhirendra-11 Jan 2021 PANDORA - Added if condition for multiple search and creating search string to pass in  IN Clauae
IF not isNull(ls_val)  and  Pos(ls_val, ",") > 0 and Upper(gs_project) ="PANDORA" THEN
	ls_criteria  += " Transfer_Master.user_field3 IN (" 
for i = 1 to 10

IF  pos(ls_val,',') > 0 then 
	ls_in_clause = left(ls_val,(pos(ls_val,',')))
    ls_in_clause =  left(ls_in_clause,(len(ls_in_clause) - 1))
        ls_search_string = ls_search_string + "'" + ls_in_clause + "'"
		 ls_search_string  =  ls_search_string + ", "
	    ls_val= right(ls_val,(len(ls_val) - len(ls_in_clause) )-1)
	else
		IF not isnull(ls_val) or ls_val <> '' then
	   
		  ls_search_string = ls_search_string + "'" + ls_val + "'"
		  ls_criteria += ls_search_string + ") and " 
		  	lb_where = True	
	end if 
	exit 
end if 
next
else
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "user_field3 like '" + ls_val + "%' And "
	lb_where = True	
END IF
end if
//Dhirendra End here

//Check Transfer Date range for any errors prior to retrieving
IF 	((lb_tran_to = TRUE and lb_tran_from = FALSE) 	OR &
		 (lb_tran_from = TRUE and lb_tran_to = FALSE)  	OR &
		 (lb_tran_from = FALSE and lb_tran_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Transfer Date Range", Stopsign!)
		Return
END IF

//Check Complete Date range for any errors prior to retrieving
IF 	((lb_complete_to = TRUE and lb_complete_from = FALSE) 	OR &
		 (lb_complete_from = TRUE and lb_complete_to = FALSE)  	OR &
		 (lb_complete_from = FALSE and lb_complete_to = TRUE)) 	THEN
		messagebox("ERROR", "Please complete the FROM\To in Complete Date Range", Stopsign!)
		Return
END IF	
//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF	  
// Adding Where Clause
IF Len(ls_criteria) > 0 THEN
	ls_sql = ls_sql + "Where " + Left(ls_criteria, Len(ls_criteria) - 4)
END IF

ls_sql = ls_sql + " Order By to_no ASC "
//messagebox("ls sql", ls_sql)
dw_result.Reset()
dw_result.SetSqlSelect(ls_sql)	
ll_rows = dw_result.Retrieve()

If ll_rows <=0 Then
	Messagebox(is_title,"No records were found matching your Search Criteria!")
End If

SetPointer(Arrow!)

end event

type dw_search from datawindow within tabpage_search
integer y = 12
integer width = 3063
integer height = 340
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_owner_change_search"
boolean border = false
boolean livescroll = true
end type

event constructor;ib_transfer_from_first 	= TRUE
ib_transfer_to_first 	= TRUE
ib_complete_from_first 	= TRUE
ib_complete_to_first 	= TRUE
end event

event clicked;string 	ls_column

long		ll_row

datetime	ldt_begin_date
datetime	ldt_end_date

dw_search.AcceptText()
ls_column 	= DWO.Name
ll_row 		= dw_search.GetRow()

CHOOSE CASE ls_column
		
	CASE "order_s_date"
		
		IF ib_transfer_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("order_s_date")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_transfer_from_first = FALSE
			
		END IF
		
	CASE "order_e_date"
		
		IF ib_transfer_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("order_e_date")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_transfer_to_first = FALSE
			
		END IF
		
	
		
	CASE "complete_s_date"
		
		IF ib_complete_from_first THEN
			
			ldt_begin_date = f_get_date("BEGIN")
			dw_search.SetColumn("complete_s_date")
			dw_search.SetText(string(ldt_begin_date, "mm/dd/yyyy hh:mm"))
			ib_complete_from_first = FALSE
			
		END IF
		
	CASE "complete_e_date"
		
		IF ib_complete_to_first THEN
			
			ldt_end_date = f_get_date("END")
			dw_search.SetColumn("complete_e_date")
			dw_search.SetText(string(ldt_end_date, "mm/dd/yyyy hh:mm"))
			ib_complete_to_first = FALSE
			
		END IF
		
	CASE ELSE
		
END CHOOSE

end event

type cb_clear from commandbutton within tabpage_search
integer x = 3081
integer y = 188
integer width = 311
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;idw_search.reset()
idw_search.insertrow(0)

idw_result.reset()
end event

type dw_result from u_dw_ancestor within tabpage_search
integer x = 23
integer y = 364
integer width = 4096
integer height = 2364
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_owner_change_result"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;// Pasting the record to the main entry datawindow
string ls_code

IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	If ib_changed = False and ib_edit = True Then
		ls_code = this.getitemstring(row,'user_field3')
		isle_code.text = ls_code
		isToNo = This.GetItemString(row,'to_no')
		isle_code.TriggerEvent(Modified!)
	End If
END IF



end event

type tabpage_detail from userobject within tab_main
event create ( )
event destroy ( )
event ue_transferall ( )
integer x = 18
integer y = 104
integer width = 4247
integer height = 2744
long backcolor = 79741120
string text = "Owner Change Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
cb_replace_boxid cb_replace_boxid
st_1 st_1
dw_transfer_detail_content_append dw_transfer_detail_content_append
dw_content_append dw_content_append
p_1 p_1
cb_1 cb_1
sle_update_to sle_update_to
cb_update_to cb_update_to
p_arrow p_arrow
cb_reset cb_reset
cb_insert1 cb_insert1
cb_delete cb_delete
dw_content dw_content
dw_transfer_detail_content dw_transfer_detail_content
dw_trans_detail_content dw_trans_detail_content
dw_detail dw_detail
end type

on tabpage_detail.create
this.cb_replace_boxid=create cb_replace_boxid
this.st_1=create st_1
this.dw_transfer_detail_content_append=create dw_transfer_detail_content_append
this.dw_content_append=create dw_content_append
this.p_1=create p_1
this.cb_1=create cb_1
this.sle_update_to=create sle_update_to
this.cb_update_to=create cb_update_to
this.p_arrow=create p_arrow
this.cb_reset=create cb_reset
this.cb_insert1=create cb_insert1
this.cb_delete=create cb_delete
this.dw_content=create dw_content
this.dw_transfer_detail_content=create dw_transfer_detail_content
this.dw_trans_detail_content=create dw_trans_detail_content
this.dw_detail=create dw_detail
this.Control[]={this.cb_replace_boxid,&
this.st_1,&
this.dw_transfer_detail_content_append,&
this.dw_content_append,&
this.p_1,&
this.cb_1,&
this.sle_update_to,&
this.cb_update_to,&
this.p_arrow,&
this.cb_reset,&
this.cb_insert1,&
this.cb_delete,&
this.dw_content,&
this.dw_transfer_detail_content,&
this.dw_trans_detail_content,&
this.dw_detail}
end on

on tabpage_detail.destroy
destroy(this.cb_replace_boxid)
destroy(this.st_1)
destroy(this.dw_transfer_detail_content_append)
destroy(this.dw_content_append)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.sle_update_to)
destroy(this.cb_update_to)
destroy(this.p_arrow)
destroy(this.cb_reset)
destroy(this.cb_insert1)
destroy(this.cb_delete)
destroy(this.dw_content)
destroy(this.dw_transfer_detail_content)
destroy(this.dw_trans_detail_content)
destroy(this.dw_detail)
end on

event ue_transferall();// ue_transferAll()
dwitemstatus astatus

astatus = idw_detail.getItemStatus( idw_detail.getrow(),0, primary! )
choose case astatus
	case newmodified!, new!
		doTransferAll( idw_detail.getRow() )
end choose

end event

type cb_replace_boxid from commandbutton within tabpage_detail
integer x = 1307
integer y = 16
integer width = 471
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Validate Box ID’s"
end type

event clicked;//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -Start

Long llRow, ll_EDIBatchSeqNo, ll_LineItemNo,ll_qty, ll_LineNo, llSkuRow, llBoxRow
String ls_ContainerId, ls_Sku, ls_lCode, ls_LotNo, ls_Coo, ls_OldContainerId, ls_Container_ID_Scanned_Ind, ls_PoNo2
Long ll_upbound,i, llFound
String ls_Container_id, ls_CurrentRec, lsFind, ls_FoundSku
long ll_find, ll_end, ll_start
string ll_list
int liSplitReqd

str_parms	lstrparms
str_parms	lsReturntrparms

//GailM 09/20/2017 - SIMSPEVS-849 - Fix to SIMSPEVS-605 to all all GPNs to be validated
llRow = idw_detail.GetRow( )
If il_DblClkPickRow > 1 then
	llRow = il_DblClkPickRow
	idw_detail.scrolltorow( llRow)
Else
	If isSelSku <> '' Then
		lsFind = " SKU = '" + isSelSku + "' and user_field3 = 'N' "
		llSkuRow = idw_detail.Find( lsFind, 1, idw_detail.rowcount( ) ) 
		If llSkuRow > 0 Then llRow = llSkuRow
		isSelSku = ''   //Re-initialize isSelSku
	Else
		lsFind = " Container_id <> '-' and user_field3 = 'N' "
		llBoxRow = idw_detail.Find( lsFind, 1, idw_detail.rowcount( ) )   		//GailM 06/20/2017 - SIMSPEVS-605 - Display the first SKU/Project that is container tracked
		If llBoxRow > 0 Then llRow = llBoxRow												//GailM 08/29/2017 - Check for fail to find
	End If
End If
If llRow = 0 Then llRow = 1
idw_detail.scrolltorow( llRow)

//GailM 08/16/2018 - S20849 - Google Footprint Container Split
//isWhCode = tab_main.tabpage_main.dw_main.getitemstring(1, "wh_code")
If ibFootprint and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" Then
	For i = 1 to idw_detail.rowcount()
		If idw_detail.GetItemString(i, 'color_code') = '5' Then
			liSplitReqd ++
		End if
	Next
End If

If liSplitReqd = 0 Then		//Allowed to validate
	//GailM 06/20/2017 - SIMSPEVS-605 - Return if all Boxes have been validated
	If il_CountNotScanned = 0 Then
		messagebox('Replace/Vaidate Box IDs', 'All Box IDs have been validated')
		Return
	End if
	
If  idw_Main.GetItemString(1,'ord_status') = 'P' or idw_Main.GetItemString(1,'ord_status') = 'N' Then
//	
//		If idw_main.GetItemNumber(1, "EDI_Batch_Seq_No") > 0 then
//			ll_EDIBatchSeqNo = idw_main.GetItemNumber(1, "EDI_Batch_Seq_No")
//			ll_LineItemNo = idw_detail.GetItemNumber(llRow, "Line_Item_No")
//			ls_Sku = idw_detail.GetItemString(llRow, "SKU")
//			Select ED.Container_Id ED INTO :ls_ContainerId
//			from EDI_Outbound_Header EH With (Nolock)
//			Inner Join EDI_Outbound_Detail ED With (Nolock) on ED.Project_Id = EH.Project_Id and  ED.EDI_Batch_Seq_No = EH.EDI_Batch_Seq_No 
//			Where 
//			EH.Project_Id = :gs_project
//			and 
//			EH.EDI_Batch_Seq_No = :ll_EDIBatchSeqNo
//			and ED.Line_Item_No = :ll_LineItemNo
//			and ED.SKU = :ls_Sku;
//			
//			// Determine whether to alllow this box id or show window to scan a box id
//			// 605
//			// Allow this to move forward with a containerID
//			//If Nz(ls_ContainerID,'') <> '' then
//			//MessageBox(is_title,'You can not change the Box ID on this SKU.  You must pick the Boxes listed.  Possible DejaVu order ')
//			//Return
//			//End if
//		end if
//		
		Datastore lds_BoxesPicked
		lds_BoxesPicked = Create datastore
		lds_BoxesPicked.DataObject = 'd_pandora_box_id'
		
		lstrparms.String_arg[1] = gs_project
	//	lstrparms.String_arg[2] = idw_main.GetItemString(1, "wh_code")
		lstrparms.String_arg[3] = idw_detail.GetItemString(llRow, "SKU")
		lstrparms.String_arg[4] = idw_detail.GetItemString(llRow, "PO_No")
		//lstrparms.String_arg[5] = idw_detail.GetItemString(llRow, "l_code")
		lstrparms.String_arg[6] = idw_detail.GetItemString(llRow, "to_No")
		//lstrparms.String_arg[7] = idw_detail.GetItemString(llRow, "Owner_Owner_Cd")
		ls_OldContainerId =  idw_detail.GetItemString(llRow, "Container_Id")
		lstrparms.String_arg[8] = idw_detail.GetItemString(llRow, "Container_Id")
		//6/15/2017 - Added scan indicator for 605
		lstrparms.String_arg[9] = idw_detail.GetItemString(llRow, "user_field3")
// TAM -2018/11/02 - DE6948	added PONO2(Pallet Id)
		lstrparms.String_arg[10] = idw_detail.GetItemString(llRow, "PO_No2")
	
		lstrparms.Long_arg[1] = idw_detail.GetItemNumber(llRow, "Line_Item_No")
		//lstrparms.Long_arg[2] = nz(idw_main.GetItemNumber(1, "EDI_Batch_Seq_No"),0)
		lstrparms.Long_arg[3] = idw_detail.GetItemNumber(llRow, "Owner_ID")
		lstrparms.Long_arg[4] = il_SingleBoxIdSwap
		lstrparms.Long_arg[5] = llRow
	
		lstrparms.datawindow_arg[1] = idw_detail
		lstrparms.datastore_arg[2] = lds_BoxesPicked
		
		OpenWithparm(w_boxno_add_delete,lstrparms)
	
		lsReturntrparms = message.PowerobjectParm
		
		
		ll_upbound=lds_BoxesPicked.rowcount( )
		lds_BoxesPicked.SetSort("Current_record Desc,Container_id asc")
		lds_BoxesPicked.Sort( )
		
		FOR i= 1 TO ll_upbound
			ls_FoundSku = lds_BoxesPicked.GetItemString(i,'Sku')
			ls_CurrentRec = lds_BoxesPicked.GetItemString(i,'Current_Record')
			ls_Container_id = lds_BoxesPicked.GetItemString(i,'Container_id')
			ls_Container_ID_Scanned_Ind = lds_BoxesPicked.GetItemString(i,'Container_ID_Scanned_Ind')
			ll_qty = lds_BoxesPicked.GetItemNumber(i,'qty')
			//ls_lCode = lds_BoxesPicked.GetItemString(i,'l_code')
			ll_LineNo = lds_BoxesPicked.GetItemNumber(i,'line_item_no')
			//ls_Coo = lds_BoxesPicked.GetItemString(i,'country_of_origin' )
			ls_LotNo= lds_BoxesPicked.GetItemString(i,'lot_no' )	
// TAM -2018/11/02 - DE6948	added PONO2(Pallet Id)
			ls_Pono2 = lds_BoxesPicked.GetItemString(i,'po_no2')
			If ls_CurrentRec = '1' then
				//First flag all the boxes on the order that were already on the picking list.
				ll_end = idw_detail.RowCount() + 1
				ll_find = 1
				lsFind =  " Upper(Sku) = '" + Upper(ls_FoundSku) + "' and Container_Id = '" + ls_Container_id + "'" //+ "' and line_item_no = " + String(ll_LineNo)
				ll_find = idw_detail.Find(lsFind, ll_find, ll_end)
				DO WHILE ll_find > 0
						idw_detail.scrolltorow( ll_find )
						//idw_detail.SetItem(ll_find,'containerid_found','1')
						//GailM 06/17/17 605 - Validate BoxID 
						idw_detail.SetItem(ll_find,'user_field3','Y' )
						  // Search again
						  ll_find++
					ll_find = idw_detail.Find(lsFind, ll_find, ll_end)
				LOOP
			else
				ll_end = idw_detail.RowCount() + 1
				ll_find = 1
				If il_DblClkPickRow > 0 Then
					lsFind =  " Upper(Sku) = '" + Upper(ls_FoundSku) + "' and quantity = " + String(ll_qty) + " "
				Else
				lsFind =  " Upper(Sku) = '" + Upper(ls_FoundSku) + "' and quantity = " + String(ll_qty) + ""
				End if
				//lsFind =  " Upper(Sku) = '" + Upper(ls_FoundSku) + "' and Container_Id <> '" + ls_Container_id + "'" + "' and containerid_found = '" + '0' + "'"
				ll_find = idw_detail.Find(lsFind, ll_find, ll_end)
				If ll_find > 0 then
					idw_detail.scrolltorow( ll_find )
					idw_detail.SetItem(ll_find,'Container_Id',ls_Container_id)
					idw_detail.SetItem(ll_find,'user_field3',ls_Container_ID_Scanned_Ind)
					idw_detail.SetItem(ll_find,'Lot_no',ls_Container_id)
					//idw_detail.SetItem(ll_find,'L_code',ls_lCode)
				//	idw_detail.SetItem(ll_find,'country_of_origin',ls_Coo)
					//idw_detail.SetItem(ll_find,'user_field1',ls_Coo)
					idw_detail.SetItem(ll_find,'lot_no',ls_LotNo)
					//idw_detail.SetItem(ll_find,'containerid_found','2')
// TAM -2018/11/02 - DE6948	added PONO2(Pallet Id)
					idw_detail.SetItem(ll_find,'po_no2',ls_pono2)
					dwobject ldwo
					ldwo = idw_detail.Object.Container_Id
					idw_detail.event itemchanged( ll_find, ldwo, ls_Container_id )
				end if
			End IF	
		Next
				
		ib_changed = True		//Changes have been made
		wf_check_container_scanned()

Else
		Messagebox(is_title,'Order must be in either Process .')
	Return
	end if
Else
	Messagebox(is_title,'Cannot continue to validate containers until container split is completed.')
		Return
End If		/*End Split*/

il_SingleBoxIdSwap = 0
il_DblClkPickRow = 0
// S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -END
end event

type st_1 from statictext within tabpage_detail
integer x = 1769
integer y = 116
integer width = 718
integer height = 100
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Leave blank to default From->To"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_transfer_detail_content_append from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 2738
integer y = 1436
integer width = 690
integer height = 400
integer taborder = 70
string title = "none"
string dataobject = "d_tran_detail_content_soc"
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = styleraised!
end type

event dberror;//MessageBox (string(sqldbcode), sqlerrtext )
end event

event retrievestart;return 2
end event

type dw_content_append from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 2034
integer y = 1436
integer width = 690
integer height = 400
integer taborder = 60
string title = "none"
string dataobject = "d_tran_content"
boolean vscrollbar = true
boolean resizable = true
borderstyle borderstyle = styleraised!
end type

event retrievestart;return 2
end event

event dberror;//MessageBox (string(sqldbcode), sqlerrtext )
end event

type p_1 from picture within tabpage_detail
integer x = 3214
integer y = 28
integer width = 73
integer height = 64
string picturename = "Regenerate!"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within tabpage_detail
integer x = 3200
integer y = 16
integer width = 896
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "SOC Putaway List"
end type

event clicked;str_parms lstr_parms
long ll_numrecords, ll_recordnum

// Get the number of dw_transfer_detail_content rows.
ll_numrecords = dw_transfer_detail_content.rowcount()

//messagebox("content", dw_transfer_detail_content.rowcount())
//messagebox("detail", tab_main.tabpage_detail.dw_detail.rowcount())

// LTK 20110110 comment out following loop
//
//// Loop through the records.
//For ll_recordnum = 1 to ll_numrecords
//	
//	// Get the lot and serial numbers.
//	lstr_parms.string_arg_2[ll_recordnum] = dw_transfer_detail_content.getitemstring(ll_recordnum, "serial_no")
//	lstr_parms.string_arg_3[ll_recordnum] = dw_transfer_detail_content.getitemstring(ll_recordnum, "lot_no")
//Next

// Pack the source warehouse and detail dw into the parameter structure.

lstr_parms.string_arg[1] = tab_main.tabpage_main.dw_main.getitemstring(1, "s_warehouse")
lstr_parms.string_arg_2[1] = isorderno   //ET3 - 2012-08-28
lstr_parms.datawindow_arg[1] = tab_main.tabpage_detail.dw_detail

// Open the SOC Putaway List
opensheetwithparm(w_socputawaylist, lstr_parms, w_main)
end event

type sle_update_to from singlelineedit within tabpage_detail
integer x = 1943
integer y = 16
integer width = 425
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_update_to from commandbutton within tabpage_detail
integer x = 2391
integer y = 16
integer width = 389
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update All To"
end type

event clicked;
integer li_idx

string ls_sle_update_to

//dts 2016-01-04 - not allowing them to set all locations if there are serialized GPNs.
if ib_serialized then
	messagebox('Serialized SOC', 'Function not available for SOC with Serialized parts.')
	return 0
end if

ls_sle_update_to = sle_update_to.text

//TAM 2018- -S18358 not allowing them to set location to "RESEARCH%" or RECON%"
if (ls_sle_update_to >= "RESEARCH" and ls_sle_update_to < "RESEARCI") or (ls_sle_update_to >= "RECON" and ls_sle_update_to < "RECOP") then
	messagebox('Serialized SOC', 'Location cannot be changed to RESEARCH or RECON.')
	return 0
end if

// 03/20 - PCONKL - If the 
If ls_sle_update_to = '' or isnull(ls_sle_update_to) Then
	
	If Messagebox('To Loc Default','With an empty To Loc field, this will default all To Locs with the From Loc.~r~rDo you want to continue?',Question!,YesNo!,1) = 1 Then
		
		Setpointer(hourglass!)
		
		for li_idx =1  to idw_detail.RowCount()

			idw_detail.SetItem( li_idx, "d_location",idw_detail.GetITemString(li_idx,'s_location'))

		next
		
		Setpointer(Arrow!)
		
		Return
		
	Else
		
		Return

	End If
	
End If


for li_idx =1  to idw_detail.RowCount()


	idw_detail.SetItem( li_idx, "d_location", ls_sle_update_to)

next
end event

type p_arrow from picture within tabpage_detail
boolean visible = false
integer x = 2816
integer y = 28
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "Next!"
boolean focusrectangle = false
end type

type cb_reset from commandbutton within tabpage_detail
boolean visible = false
integer x = 2802
integer y = 16
integer width = 375
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset"
end type

event clicked;long index, max

if messagebox( iw_window.title , "Reset Detail?",question!,yesno!) = 2 then return

max = idw_detail.rowcount()
for index  = max to 0 step -1
	idw_detail.deleterow( index )
next

ib_changed = False


iw_window.event ue_save()

setQtyAllDisplay( true )


end event

type cb_insert1 from commandbutton within tabpage_detail
boolean visible = false
integer x = 18
integer y = 28
integer width = 375
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Insert Row"
end type

event clicked;Long ll_row

idw_detail.SetFocus()

If idw_detail.AcceptText() = -1 Then Return

Post Function wf_insert_row()

//// pvh - 10/03/05
//dwitemstatus ldwStatus
//ldwStatus = idw_main.getItemStatus( 1, 0, primary! )
//if ldwStatus = Datamodified! or ldwStatus = NewModified! then
//	iw_window.event ue_save()
//end if
//
//ll_row = idw_detail.GetRow()
//
//If ll_row > 0 Then
//	ll_row = idw_detail.rowcount()
//	ll_row = idw_detail.InsertRow(ll_row + 1)
//Else
//	ll_row = idw_detail.InsertRow(0)
//	
//End If	
//
//idw_detail.SetFocus()
//idw_detail.setcolumn('sku')
//idw_detail.ScrollToRow(ll_row)
//idw_detail.SetItem(ll_row, "to_no", getToNo() )
//// reset the status to New!
//idw_detail.setItemStatus( ll_row, 0, primary! , NotModified!	 )
//idw_detail.setItemStatus( ll_row, 0, primary! , New! )

return





end event

type cb_delete from commandbutton within tabpage_detail
boolean visible = false
integer x = 416
integer y = 28
integer width = 375
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;
w_owner_change.event ue_deleterow()

end event

type dw_content from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 786
integer y = 860
integer width = 2656
integer height = 548
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_owner_change_content"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event retrievestart;//	return 2
end event

event sqlpreview;string _sqlsyntax
// dw_content
_sqlsyntax = sqlsyntax


end event

event dberror;MessageBox (string(sqldbcode), sqlerrtext )
end event

type dw_transfer_detail_content from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 206
integer y = 448
integer width = 3282
integer height = 548
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_owner_change_detail_content"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event dberror;MessageBox (string(sqldbcode), sqlerrtext )
end event

event retrievestart;//	return 2
end event

event sqlpreview;string _sqlsyntax
// dw_content
_sqlsyntax = sqlsyntax


end event

type dw_trans_detail_content from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 96
integer y = 268
integer width = 562
integer height = 348
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_tran_content"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event retrievestart;	return 2
end event

event sqlpreview;string _sqlsyntax
// dw_content
_sqlsyntax = sqlsyntax


end event

type dw_detail from u_dw_ancestor within tabpage_detail
event ue_enter_serial_numbers ( )
string tag = "microhelp"
integer x = 14
integer y = 112
integer width = 4087
integer height = 2620
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_owner_change_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
end type

event ue_enter_serial_numbers();//GailM 11/5/2019 S39864 F17337 I1304 Google Footprints GPN Conversion Process - Stock Owner Change - SOC
//We are expecting the color_code on each pick row to be "9" which indicates this is a footprint GPN but has less than 
//full number of serial numbers in serial number inventory table
String lsFind, lsMessage
String lsContainers[], lsMoveContainers[]
String lsContainer, lsNewPallet, lsSKU, lsLocation
String lsOrderType, lsToNo, lsMixedType, lsColorCode
Long llAdjustNo, llReqQty, llDiffQty, llOwnerId, llQty
Boolean lbCancelled
Int liPickRows, liPickRow, liContentRows, liContentRow, liContainerRows, liContainerRow, liExists, liMoveNbr
Int liContentSummaryRow, liContentSummaryRows, liFound, liModified
Int liSerialRow, liSerialRows, liTotalSerialsChanged, liMoveRow, liMoveRows, aiRC, aiRec, liRC
datastore ldsAdjustment, ldsNewContentSummary,ldsSerial, ldsContent
datetime ldtToday

Datastore ldsFromPallet, ldsToPallet, ldsPickContainer
Str_parms	lstrParms
Str_parms	lstrReturnParms

ldsFromPallet = Create datastore
ldsFromPallet.dataobject = 'd_pick_pallet'
ldsFromPallet.SetTransObject(SQLCA)

ldsToPallet = Create datastore
ldsToPallet.dataobject = 'd_pick_pallet'
ldsToPallet.SetTransObject(SQLCA)

ldsPickContainer = Create datastore
ldsPickContainer.dataobject = 'd_owner_change_detail'
ldsPickContainer.SetTransObject(SQLCA)

idw_detail.Rowscopy( ilCurrPickRow, ilCurrPickRow, Primary!, ldsPickContainer, 1, Primary!)

lsToNo = idw_main.GetItemString(1, "to_no")
isWhCode = idw_main.GetItemString(1, "s_warehouse")
ldtToday = f_getLocalWorldTime( isWhCode ) 
llQty = idw_detail.GetItemNumber( ilCurrPickRow, "quantity")

If ldsPickContainer.rowcount() = 1 Then
	lsSKU = ldsPickContainer.GetItemString( 1, "SKU" )
	lsLocation = ldsPickContainer.GetItemString(1, "s_location")
	isPallet = ldsPickContainer.GetItemString(1, "po_no2")
	isContainer = ldsPickContainer.GetItemString(1, "container_id")
	lsMixedType = ldsPickContainer.GetItemString(1, "mixed_type")
	lsColorCode = ldsPickContainer.GetItemString(1, "color_code")
	llReqQty = ldsPickContainer.GetItemNumber(1, "Quantity")
	lsFind = "SKU = '" + lsSKU + "' "
	
	llDiffQty = f_footprint_serial_numbers(lsSKU, isWhCode, lsLocation, isPallet, isContainer, llQty)
	If llDiffQty <> 0 Then
		For liPickRow = 1 to llReqQty
			liSerialRow = ldsFromPallet.InsertRow(0)
			ldsFromPallet.SetItem(liSerialRow, "po_no2", isPallet)
			ldsFromPallet.SetItem(liSerialRow, "carton_id", isContainer)
			ldsFromPallet.SetItem(liSerialRow, "serial_no", "")
		Next
	Else
		// If the user wishes to change the pallet or container ID, allow the add window, otherwise
		//messagebox("Pallet/Container Splitting", "No serial numbers can be entered.")
	End If
	
	lstrparms.String_Arg[1] = isPallet
	lstrparms.String_Arg[2] = isContainer
	lstrparms.String_Arg[3] = lsToNo
	lstrparms.String_Arg[4] = isWhCode
	lstrparms.String_Arg[5] = 'SOC'			//Order type Stock Transfer
	lstrparms.String_Arg[6] = lsColorCode
	lstrparms.String_Arg[7] = lsMixedType
	lstrparms.String_Arg[8] = lsLocation
	lstrparms.integer_arg[1] = ilCurrPickRow
	lstrparms.Boolean_arg[1] = ibPharmacyProcessing
	lstrparms.Long_Arg[1] = llReqQty
	lstrparms.Long_Arg[2] = llReqQty
	lstrparms.Datastore_Arg[1] = ldsFromPallet
	lstrparms.Datastore_Arg[2] = ldsToPallet
	lstrparms.Datastore_Arg[3] = ldsPickContainer
	lstrparms.Datawindow_Arg[1] = idw_detail
	lstrparms.Datawindow_Arg[2] = idw_transfer_detail_content
	
	OpenWithParm(w_pick_pallet, lstrparms)
	
	//lstrReturnParms = Message.PowerobjectParm

	ldsFromPallet = lstrparms.Datastore_Arg[1]
	ldsToPallet = lstrparms.Datastore_Arg[2]
	lbCancelled = lstrparms.cancelled
	
	If lbCancelled Then
		messagebox("Cancelled","The process has been cancelled.")
	End If
Else
	messagebox("ue_enter_serial_numbers error","Did not receive one container row from the pick list.  Please investigate.")
End If

//MessageBox(is_title,"You will be asked to scan serial numbers for this pick row.~n~r~n~rWork in Progress.")


end event

event constructor;call super::constructor;datawindowChild	ldwc,ldwc2
// 06/00 PCONKL - Get the original sql from from location dropdown so we can modify sql and retrieve for current row
This.GetChild('s_location',ldwc)
isFromLocSql = ldwc.getsqlselect()

This.GetChild('d_location',ldwc2)
istoLocSql = ldwc2.getsqlselect()

//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.c_owner_name.visible = 0
	this.object.cf_name_t.visible = 0
End IF

If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

This.SetRowFocusIndicator(Hand!)

end event

event doubleclicked;string lslot_no, ls_loc, ls_coo, lsMsg
Int li_ret
Long	llRowPos, llRowCount, ll_ownerid, ll_ccinvt
str_parms	lstrparms
boolean lbFootprint
String lsSerialized, lsPONO2Ind, lsContainerInd,  lsMixedType
String lsGPNConversionFlag 
String		lsFind,	&
				lsSku,	&
				lsSupplier,	&
				lsLoc,	&
				lsCOO,	&
				lsOwner,	&
				lsInvType,	&
				lsNextContainer, lsLot, lsPO, lsPO2

if row <= 0 then return -1

IF dwo.Name = 'container_id' and ( Upper(idw_main.object.ord_status[1]) = 'P' or Upper(idw_main.object.ord_status[1]) = 'N' ) THEN 
	
	
	//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -Start
	       if  Upper(gs_project) = 'PANDORA' then
			il_SingleBoxIdSwap = 1
			il_DblClkPickRow = Row
			if ib_Changed then
				Messagebox(is_title,'Please save your changes first.')
				Return
			End if
			//TimA 07/15/15
			//GailM 06/20/2017 605 - Validate BoxID - Remove check for User_Field5 (CommodityCode)
			//If pos ( Upper(is_BoxIDLookup ), ',' + This.GetItemString(Row,"User_Field5") + ',',  1 ) > 0 then
			//If This.GetItemString(Row,"User_Field5") = 'HD' Then
			If Upper(gs_project) = 'PANDORA' and il_CountNotScanned > 0 Then
				tab_main.tabpage_detail.cb_replace_boxid.event clicked( )
			Else
				messagebox('Replace/Vaidate Box IDs', 'All Box IDs have been validated')
			End If
		end if
	end if
//S53993- Dhirrendra - Google - Pandora – SOC Container ID Validation -END 
	


If Upper(idw_main.object.ord_status[1])	<> 'P' AND &
	Upper(idw_main.object.ord_status[1])	<> 'N' Then Return


IF dwo.Name = 'container_id' THEN
	
	lstrparms.Decimal_arg[1] = idw_detail.getitemdecimal(row,"quantity")
	lsGPNConversionFlag = f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION")
	//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
	//Use Foot_Prints_Ind Flag
	
	/*((idw_detail.GetItemString(row, 'serialized_ind') = "B" or idw_detail.GetItemString(row, 'serialized_ind') = "B") and idw_detail.GetItemString(row, 'po_no2_controlled_ind') = "Y" and idw_detail.GetItemString(row, 'container_tracking_ind') = "Y")*/
	
	lsSku = idw_detail.GetItemString(row, 'sku')
	lsSUpplier = idw_detail.GetItemString(row, 'supp_code')
	
	lbFootprint = f_is_sku_foot_print(lsSku,lsSUpplier)
	ilCurrPickRow = Row

	//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
	If Upper(gs_project) = 'PANDORA'  and lbFootprint and idw_detail.GetItemString(row, 'd_location') <> "*" Then
		isColorCode = idw_detail.GetItemString(row, "Color_Code")
		CHOOSE CASE isColorCode
			CASE "0", "" 													//No action required
				If lbFootprint Then											//Only footprint GPNs
					If gs_role <= "2" Then									//SuperDuper Access Only -- 12/16/2019 Opened it up to all
						If lsGPNConversionFlag = "Y" Then
							If idw_detail.getitemstring(ilCurrPickRow,'po_no2') <> '-' and idw_detail.getitemstring(ilCurrPickRow,'container_id') <> '-' Then
								MessageBox("Change Pallet and/or Container","Footprint GPN " + lsSKU + " at Row " + String(ilCurrPickRow) + " does not contain a dash and cannot change pallet or container through this process.")
							ElseIf MessageBox("Footprint GPN " + lsSKU + " processing","Do you wish to change pallet or container for this pick row?",Question!,YesNo!) = 1 Then
								idw_detail.TriggerEvent("ue_enter_serial_numbers") 
							End If
						End If
					End If
				End If				
			CASE "5"
				isPallet = This.GetITemString(row,'po_no2') 
				isContainer = This.GetItemString(row, 'container_id')
				isWhCode = idw_main.GetItemString( 1, 's_warehouse' )
				
				//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
				//If isPallet = '-' or isContainer = '-' Then
				//	MessageBox("Container Split Error", "Cannot split this pallet/container.  No pallet data detected.",StopSign!, OK!)
				//Else
					li_ret = iw_window.TriggerEvent("ue_pick_pallet")
				//End If
			CASE "6"
				//GailM 2/8/2018 DE8267 Turn serial tab generate button on or off
				iiFootprintBreakRequired = wf_check_full_pallet_container()				
				If iiFootprintBreakRequired = -1 Then	
					tab_main.tabpage_serial.cb_serial_generate.enabled = FALSE		//Turn Serial Tab Generate button back off	
				Else
					tab_main.tabpage_serial.cb_serial_generate.enabled = TRUE		//Turn Serial Tab Generate button back on	
				End If
			CASE "7"
					isPallet = This.GetITemString(row,'po_no2') 
					isContainer = This.GetItemString(row, 'container_id')
					isWhCode = idw_main.GetItemString( 1, 's_warehouse' )
					//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
					//If isPallet = '-' or isContainer = '-' Then
					//	MessageBox("Container Split Error", "Cannot split this pallet/container.  A dash was found in pallet/container data and cannot be split.",StopSign!, OK!)
					//Else
						lsMsg = "Footprint GPN " + lsSKU + " must maintain full pallet and containers.~n~r" + &
							"Pallet " + isPallet + " has excess containers not allocated that must be moved.~n~r~n~r" +  &
							"      Are you ready to move containers?"
						If MessageBox("Pallet Split Process", lsMsg, Question!, YesNo!) = 1 Then
							iw_window.TriggerEvent("ue_move_pallet")
					//	End If
					End If
				CASE	"8" 			//DE10131 Mixed Containerization
					iw_window.TriggerEvent("ue_pick_mixed") 
				CASE  "9" 				//S39864  F17337 I1304 GTN Conversion Process - Stock Owner Change - SOC
					If f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION") = 'Y' Then
						TriggerEvent("ue_enter_serial_numbers") 
					End If
			END CHOOSE
	End If
END IF

IF dwo.Name = 's_location' THEN 			
	
	lstrparms.String_arg[1] = gs_project
	lstrparms.String_arg[2] = idw_main.GetItemString(1, "s_warehouse")
	lstrparms.String_arg[3] = Upper(idw_detail.getitemstring(row,"sku"))
//	
//	lstrparms.String_arg[4] = idw_putaway.GetITemString(row,"l_code") /*if currently has location, recommendation will default to this*/
////	lstrparms.String_arg[5] = idw_putaway.GetITemString(row,"ro_no") /*we will still show as available for this order*/
	lstrparms.Decimal_arg[2] = idw_detail.getitemnumber(row,'owner_id') /*pandora needs to filter by owner_id and Inventory Type*/
	lstrparms.String_arg[6] = Upper(idw_detail.getitemstring(row,'inventory_type'))

	lstrparms.String_arg[7] = idw_detail.getitemstring(row,"to_no")/*pandora needs to filter by owner_id and Inventory Type*/
	lstrparms.Decimal_arg[4] = idw_detail.getitemnumber(row,"line_item_no") /*pandora needs to filter by owner_id and Inventory Type*/

	lstrparms.String_arg[8] = idw_detail.getitemstring(row,"po_no") /*pandora needs to filter by new_po_no and Inventory Type*/

//	MessageBox ("ok", string(row))

	//Jxlim 07/13/2011 BRD #39 Do not process SOC when some/any of the material is in cycle count inventory type (*)				
			Select count(*)  into :ll_ccinvt
			From Content
			Where Project_id 			= :gs_project
			And 	   WH_Code			= :lstrparms.String_arg[2]
			And      Owner_id 			= :lstrparms.Decimal_arg[2]			
			And	   SKU					= :lstrparms.String_arg[3]
			And      Inventory_type		=  '*'
			//Below criterias are not neccesary, it gives incorrect count for cycle count inventory type.
//			And 	   PO_No 				= :lstrparms.String_arg[8]	
//			And 	   Lot_No 				= :lslot_no
//			And      L_Code				= :ls_loc
//			And 	  Country_of_Origin  = :ls_coo		
//			And 	  Serial_No =
//			And     RO_No =					
//			And 	  Supp_Code=	/
//			And 	  PO_No2 =	
//			And 	  Component_No =	
//			And 	  Container_ID		= 
			USING SQLCA;
					
			If ll_ccinvt > 0 Then
					MessageBox(is_title, "SOC Cannot be processed - some material is in Cycle count")
					Return 1
			End If	

	long li_line_item_no, i
	decimal ld_quantity = 0

	li_line_item_no = idw_detail.getitemnumber(row,"line_item_no")
	
	
	for i = 1 to idw_detail.rowcount()
		
		IF idw_detail.getitemnumber(i,"line_item_no") = li_line_item_no THEN
			ld_quantity = ld_quantity + idw_detail.getitemdecimal(i,"quantity")
		END IF 
		
	next 	

//	MessageBox (string(row) + " -  quantity", ld_quantity)

	lstrparms.Decimal_arg[1] = ld_quantity
	
	lstrparms.boolean_arg[1] = false
//
//
//		ls_sku = Upper(idw_detail.getitemstring(i,'sku'))
//	ls_supp = Upper(idw_detail.getitemstring(i,'supp_code'))
//	ls_lcode = Upper(idw_detail.getitemstring(i,'s_location'))
//	ls_sno = Upper(idw_detail.getitemstring(i,'serial_no'))
//	ls_lno = Upper(idw_detail.getitemstring(i,'lot_no'))
//	ls_pono = Upper(idw_detail.getitemstring(i,'po_no'))
//	ls_po2 = Upper(idw_detail.getitemstring(i,'po_no2'))
//	ls_container_id =  Upper(idw_detail.getitemstring(i,'container_id'))		//GAP 11-02 
//	ldt_expiration_date = idw_detail.getitemDateTime(i,'expiration_date')	//GAP 11-02 
//	ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin'))
//	ll_own = idw_detail.getitemnumber(i,'owner_id')
//	ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type'))
//	
//	


	OpenWithparm(w_owner_change_recommend,lstrparms)
	

	Long			llFindRow,	&
					llArrayPos,	&
					llNewRow,	&
					llOwnerID,	&
					llCompNumber,	&
					llLineItem,	&
					llNextContainer
					
	


	//This.SetRedraw(False)
	
	//Parms returned rows of string for location and long for amt to putaway there!
	lstrparms = Message.PowerobjectParm
	
	IF IsValid(lstrparms)  THEN
		
		IF	UpperBound(lstrparms.boolean_arg) > 0 AND lstrparms.boolean_arg[1] <> true then RETURN 0
		
	ELSE
		
		RETURN 0
	
	END IF



//MessageBox ("ok2",  Upperbound(lstrparms.String_arg))

//Choose Case Upperbound(lstrparms.String_arg)
//		
//	Case 1 /* putting everything away in 1 location*/
//		
//		this.SetItem( row, "s_location", lstrparms.String_arg[1])
//		
//		this.SetItem( row, "country_of_origin", lstrparms.string_arg_2[1])
//	
		string     ls_data 
		dwobject   ldwo 
//
//
//		// Get a reference to the "dwo" (DWObject) - <dw_name>.OBJECT.<columnname> 
//		ldwo = this.OBJECT.s_location 
//
//		// Define the "data" to pass 
//		ls_data = lstrparms.String_arg[1]
//
//		// Trigger ItemChanged(row,dwo,data) to ... 
//		this.Event ItemChanged(row,ldwo,ls_data)
//
//		
//		
////		This.SetItem(ilcurrputawayrow,"l_code",lstrparms.String_arg[1])
////		This.SetItem(ilcurrputawayrow,"quantity",lstrparms.decimal_arg[1])
////		
////		This.SetFocus()
////		This.SetRow(ilcurrputawayrow)
////		
////		//If a component, copy location to dependent records
////		If This.GetItemString(ilcurrputawayrow,"component_ind") = 'Y' Then
////			//lsFind = "sku_parent = '" + This.GetItemString(ilcurrputawayrow,"sku_parent") + "' and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no"))
////			lsFind = "line_item_no = " + String(This.GetITemNumber(ilcurrputawayrow,'line_item_no'))
////			llFindRow = This.Find(lsFind,ilcurrputawayrow,This.RowCount())
////			lsLoc = This.GetItemString(ilcurrputawayrow,"l_code")
////			Do While llFindRow > 0
////				This.SetItem(llFindRow,"l_code",lsLoc)
////				llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
////			Loop
////		End If /*Component*/
//		
//	Case 0 /*nothing entered*/
//		
////		This.SetFocus()
////		This.SetRow(ilcurrputawayrow)
////		
//	Case Else /*more than 1 row*/
		
		integer li_idx 
	
		for li_idx = 1 to this.RowCount()
		
			if li_idx = row then continue
			
			if this.getitemnumber(li_idx,"line_item_no")  =  idw_detail.getitemnumber(row,"line_item_no") then
				this.setitem(li_idx,"line_item_no", 0)
				
//				MessageBox("Debug", "deleting row=" + String(li_idx))
				
			end if
		next

	// SOC Enhancements  LTK 20110127
	// The prior version only passed 3 parms back from the From Window:  l_code, qty, lot_no
	// Modified code to receive the rest of the content table key fields which were not sent to From Window:
	// 		supp_code, coo, serial_no, ro_no (currently no placeholder in transfer_detail), 
	//		po_no2, container_id and expiration_date
	//
	// This is done via the datastore parm argument which is a copy of the From Locations datawindow

	long ll_from_locations_row, ll_new_row
	datastore lds_from_locations
	lds_from_locations = lstrparms.datastore_arg[1]
	
	//03/20 - PCONKL
	SetPointer(hourglass!)
	This.SetRedraw(False)
	
	for i = 1 to lds_from_locations.Object.co_change_count[1]
		
		// Set transfer_detail rows with data passed back from the From Locations window
		// From Locations rows that have Owner Change Amount column set will now be 1:1 relationship 
		// transfer_detail rows.
	
		// Find the next changed From Location row in the datastore
		ll_from_locations_row = lds_from_locations.Find( "c_putaway_amt <> 0 and NOT IsNull(c_putaway_amt)", ll_from_locations_row + 1, lds_from_locations.RowCount())

		if ll_from_locations_row <= 0 then return -1

		if i = 1 then
			// Set the current detail row with data from the first From Location datawindow row modified
	
			this.Object.s_location[row] = lds_from_locations.Object.content_l_code[ll_from_locations_row]
			this.Object.quantity[row] = lds_from_locations.Object.c_putaway_amt[ll_from_locations_row]
			this.Object.lot_no[row] = lds_from_locations.Object.lot_no[ll_from_locations_row]
			
			//Added per request to simplify process.
			if IsNull(this.Object.d_location[row]) OR trim(this.Object.d_location[row]) = "" then
				this.Object.d_location[row] = this.Object.s_location[row]
			end if
	
			// Set the detail row with the remaining content key columns
			this.Object.supp_code[row] = lds_from_locations.Object.supp_code[ll_from_locations_row]
			this.Object.country_of_origin[row] = lds_from_locations.Object.country_of_origin[ll_from_locations_row]
			this.Object.serial_no[row] = lds_from_locations.Object.serial_no[ll_from_locations_row]
			this.Object.po_no2[row] = lds_from_locations.Object.po_no2[ll_from_locations_row]
			this.Object.container_id[row] = lds_from_locations.Object.container_id[ll_from_locations_row]
			this.Object.expiration_date[row] = lds_from_locations.Object.expiration_date[ll_from_locations_row]
	
		else
			// Set added detail rows with data from subsequent From Location datawindow rows modified
			
			this.RowsCopy(row, row, Primary!, this, this.RowCount()+1, Primary!)
			ll_new_row = this.RowCount()
	
			this.Object.s_location[ll_new_row] = lds_from_locations.Object.content_l_code[ll_from_locations_row]
			this.Object.quantity[ll_new_row] = lds_from_locations.Object.c_putaway_amt[ll_from_locations_row]
			this.Object.lot_no[ll_new_row] = lds_from_locations.Object.lot_no[ll_from_locations_row]
			// LTK 20100111  SOC enhancements - update the line item number 
			//dts - wanting to retain the original line_item_no
			// LTK 20110429 Pandora #205 - SOC Multiline issue; uncomment out original SOC Fix line below
			this.Object.line_item_no[ll_new_row] = idw_detail.Object.co_max_line_item_no[1] + 1
	
			//Added per request to simplify process.
			if IsNull(this.Object.d_location[ll_new_row]) OR trim(this.Object.d_location[ll_new_row]) = "" then
				this.Object.d_location[ll_new_row] = this.Object.s_location[ll_from_locations_row]
			end if
	
			// Set the detail row with the remaining content key columns
			this.Object.supp_code[ll_new_row] = lds_from_locations.Object.supp_code[ll_from_locations_row]
			this.Object.country_of_origin[ll_new_row] = lds_from_locations.Object.country_of_origin[ll_from_locations_row]
			this.Object.serial_no[ll_new_row] = lds_from_locations.Object.serial_no[ll_from_locations_row]
			this.Object.po_no2[ll_new_row] = lds_from_locations.Object.po_no2[ll_from_locations_row]
			this.Object.container_id[ll_new_row] = lds_from_locations.Object.container_id[ll_from_locations_row]
			this.Object.expiration_date[ll_new_row] = lds_from_locations.Object.expiration_date[ll_from_locations_row]
	
		end if
	next
	
	//03/20 - PCONKL
	SetPointer(Arrow!)
	This.SetRedraw(True)
			
/*
		integer li_row
		
		for li_idx =1 to UpperBound(lstrparms.String_arg)
			if li_idx = 1 then
				
				this.SetItem( row, "s_location", lstrparms.String_arg[1])
		
				this.SetItem( row, "quantity", lstrparms.Decimal_arg[1] )
				
				// LTK 20101228  SOC add lot_no change
				this.SetItem( row, "lot_no", lstrparms.String_arg_2[1] )

				//Added per request to simplify process.
				
				string ls_d_location
				
				ls_d_location = this.GetItemString( row, "d_location")
				
				IF IsNull(ls_d_location) OR trim(ls_d_location) = "" THEN
					this.SetItem( row, "d_location", lstrparms.String_arg[1])
				END IF
				
				// Get a reference to the "dwo" (DWObject) - <dw_name>.OBJECT.<columnname> 
//				ldwo = this.OBJECT.s_location 
		
				// Define the "data" to pass 
//				ls_data = lstrparms.String_arg[1]
		
				// Trigger ItemChanged(row,dwo,data) to ... 
//				this.Event ItemChanged(row,ldwo,ls_data)
	
	
			else
	
				this.RowsCopy(row, row, Primary!, this, this.RowCount()+1, Primary!)
				
				
				li_row = this.rowcount()
				
				
				
				this.SetItem( li_row, "s_location", lstrparms.String_arg[li_idx])
				
				this.SetItem( li_row, "quantity", lstrparms.Decimal_arg[li_idx] )

				// LTK 20101228  SOC add lot_no change
				this.SetItem( li_row, "lot_no", lstrparms.String_arg_2[li_idx])

				// LTK 20100111  Update the line item number 
				this.SetItem( li_row, "line_item_no", idw_detail.Object.co_max_line_item_no[1] + 1)
			
				ls_d_location = this.GetItemString( li_row, "d_location")
				
				IF IsNull(ls_d_location) OR trim(ls_d_location) = "*" THEN
					this.SetItem( li_row, "d_location", lstrparms.String_arg[li_idx])
				END IF
	

				// Get a reference to the "dwo" (DWObject) - <dw_name>.OBJECT.<columnname> 
//				ldwo = this.OBJECT.s_location 
		
				// Define the "data" to pass 
//				ls_data = lstrparms.String_arg[li_idx]
		
				// Trigger ItemChanged(row,dwo,data) to ... 
//				this.Event ItemChanged(li_row,ldwo,ls_data)
		
				
			end if
			
		next	
*/		
		
		
		
		
		//03/20 - PCONKL
		SetPointer(Hourglass!)
		This.SetRedraw(False)
	
		llRowCount = this.RowCount()
		
		for li_idx = llRowCount to 1 Step - 1
			if this.getitemnumber(li_idx,"line_item_no")  =  0 then
				deleterow(li_idx)
			end if
		next
		
		this.sort()
		
		//03/20 - PCONKL
		SetPointer(Arrow!)
		This.SetRedraw(True)
		
		
////		//If more than 1 row, we will delete existing row for SKU and re-create
////		
////		lsSku = This.GetItemString(ilcurrputawayrow,"sku") /*current row we're processing*/
////		lsSupplier = This.GetItemString(ilcurrputawayrow,"supp_code") /*current row we're processing*/
////		lscoo = This.GetItemString(ilcurrputawayrow,"country_of_origin")
////		lsowner = This.GetItemString(ilcurrputawayrow,"c_owner_name")
////		lsInvType = This.GetItemString(ilcurrputawayrow,"inventory_Type")
////		llownerid = This.GetItemNumber(ilcurrputawayrow,"owner_id")
////		llCompnumber = This.GetItemNumber(ilcurrputawayrow,"component_no")
////		llLineItem = This.GetItemNumber(ilcurrputawayrow,"line_item_no") /*08/01 PConkl*/
////		lslot = This.GetItemString(ilcurrputawayrow,"lot_no")
////		lspo = This.GetItemString(ilcurrputawayrow,"po_no")
////		lspo2 = This.GetItemString(ilcurrputawayrow,"po_no2")
////		
////		//Delete all rows for this sku/supplier/line item  09/00 pconkl - delete child component rows as well (sku_parent)
////		llFindrow = 1
//////		If llCompNumber > 0 Then
//////			lsFind = "Upper(sku_parent) = '" + Upper(This.GetItemString(ilcurrputawayrow,"sku")) + "' and component_no = " + String(This.GetItemNumber(ilcurrputawayrow,"component_no")) +  " and line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))/*sku from current putaway row*/
//////		Else
//////			lsFind = "Upper(sku_parent) = '" + Upper(This.GetItemString(ilcurrputawayrow,"sku"))  + "' and line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))
//////		End If
////		
////		lsFind = "line_item_no = " + String(This.GetItemNumber(ilcurrputawayrow,"line_item_no"))
////		
////		Do While llFindRow > 0
////			llFindRow = This.Find(lsFind,0,This.RowCount())
////			If llFindRow > 0 Then
////				This.DeleteRow(llFindRow)
////			End If
////		Loop
////		
////		//Rebuild from array
////		For llArrayPos = 1 to Upperbound(lstrparms.String_arg)
////			
////			llnewRow = This.InsertRow(0)
////			This.setitem(llnewRow,'ro_no', idw_main.GetItemString(1, "ro_no"))
////			This.SetItem(llNewRow,"sku_parent",lsSku)
////			This.SetItem(llNewRow,"sku",lsSku)
////			This.SetItem(llNewRow,"supp_code",lsSupplier)
////			This.SetItem(llNewRow,"owner_id",llOwnerID)
////			This.SetItem(llNewRow,"component_no",llcompnumber)
////			This.SetItem(llNewRow,"line_item_no",llLineItem) /*08/01 PConkl*/
////			This.SetItem(llNewRow,"country_of_origin",lsCOO)
////			This.SetItem(llNewRow,"c_owner_name",lsowner)
////			This.SetItem(llNewRow,"l_code",lstrparms.String_arg[llArrayPos])
////			This.SetItem(llNewRow,"quantity",lstrparms.decimal_arg[llArrayPos])
////			This.SetItem(llNewRow,"inventory_type", lsInvType)
////			This.SetItem(llNewRow,"lot_no", lsLot)
////			This.SetItem(llNewRow,"po_no", lspo)
////			This.SetItem(llNewRow,"po_no2", lsPo2)
////			IF i_nwarehouse.of_item_master(gs_project,lsSku,lsSupplier,idw_putaway,llNewRow) < 1 THEN
////	//			 Messagebox("","Could not retrieve item master values")
////			END IF				
////			
////			If THis.GetITemString(llNewRow,'component_ind') = 'Y' Then
////				//Build Child Records
////				wf_create_comp_child(llNewRow)
////			//	llCompNumber ++ 
////			End If
////			
////			// 12/02 - PConkl - If Tracking by Container ID, set to Next
////			If This.GetItemString(llNewrow,'container_tracking_Ind') = 'Y' Then
////				llNextContainer = This.RowCount()
////				lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')  /*start off with using the rowcount */
////				//If found, keep bumping until no longer present
////				llFindRow = This.Find("Container_ID = '" + lsNextContainer + "'",1,This.RowCount())
////				Do While llFindRow > 0
////					llNextContainer ++
////					lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')
////					llFindRow = This.Find("Container_ID = '" + lsNextContainer + "'",1,This.RowCount())
////				Loop
////				This.SetITem(llNewrow,'container_id',lsNextContainer)
////			End If /*Container Tracked */
////			
////		Next
////	
////		This.Sort()
////		This.groupCalc()
////		This.SetFocus()
//////		This.SetRow(llNewRow)
//////		This.ScrollToRow(llNewRow)
////
////		// 08/01 PCONKL - instead of scrolling to new row, scroll to the row that was origianlly processed. 
////		llFindRow = This.Find(lsFind,0,This.RowCount())
////		If llFindRow > 0 Then
////			This.SetRow(llFindRow)
////			This.ScrolltoRow(llFindRow)
////		End If
//		
//End Choose

ib_changed = True

//This.SetRedraw(True)

This.AcceptText()




	
	
	
	
	
	
END IF

end event

event itemchanged;string ls_supp_code,ls_alternate_sku,ls_coo,ls_sku, ls_po_no2, ls_new_to, ls_old_to
Long ll_row,ll_owner_id ,ll_rtn
ib_changed = True
datawindowChild	ldwc
long ll_ownerid, l_code
string ls_wh_code, ls_invt
integer li_count

Choose Case dwo.name

case 'sku'
	
	//Check if item_master has the records for entered sku
	ll_rtn=i_nwarehouse.of_item_sku(gs_project,data)
	IF ll_rtn > 0 THEN
		This.object.supp_code[row]=""
		IF ll_rtn = 1   THEN	
			ls_supp_code=i_nwarehouse.ids_sku.object.supp_code[1] 
		  	This.object.supp_code[ row ] = ls_supp_code
			ls_sku = data
			Post f_setfocus(idw_detail,row,'quantity')
			// pvh 09/16/05 goto? 
			return doPickData( data, ls_supp_code, Row )
   		END IF
	Else			
		MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
		return 1
 	END IF

Case 'supp_code'
	
	// pvh 09/16/05 goto? 
	return doPickData( this.object.sku[ row ]  , data , Row )
	 
Case "country_of_origin" /* 09/00 PCONKL - validate Country of Origin*/
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		ls_COO = f_get_Country_Name(data)
		If isNull(ls_COO) or ls_COO = '' Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If

 Case "s_location" /* 08/02 - PCONKL - Copy Content information from selected row*/		
// 	This.GetChild('s_location',ldwc)
// 	ll_row = ldwc.GetRow()
// 	If ll_Row > 0 Then
//		// pvh 11/15/05
//		if isNull(this.object.supp_code[row] ) or len( String( this.object.supp_code[row] )) = 0 then
//			This.object.supp_code[ row ] = ldwc.GetITemString(ll_row,'supp_code')
//		end if
//		// eom
// 		This.SetItem(row,'lot_no',ldwc.GetITemString(ll_row,'lot_no'))
// 		This.SetItem(row,'po_no',ldwc.GetITemString(ll_row,'po_no'))
// 		This.SetItem(row,'po_no2',ldwc.GetITemString(ll_row,'po_no2'))
//   	 	This.SetItem(row,'container_ID',ldwc.GetITemString(ll_row,'container_ID'))				//GAP 11/02
// 		This.SetItem(row,'expiration_date',ldwc.GetITemdatetime(ll_row,'expiration_date')) 	//GAP 11/02
//		This.SetItem(row,'serial_no',ldwc.GetITemString(ll_row,'serial_no'))
//		This.SetItem(row,'Inventory_type',ldwc.GetITemString(ll_row,'inventory_type'))
//		This.SetItem(row,'country_of_origin',ldwc.GetITemString(ll_row,'country_of_origin'))
//		This.SetItem(row,'owner_id',ldwc.GetITemNumber(ll_row,'owner_id'))
//		this.object.c_owner_name[ row ] = g.of_get_owner_name(ldwc.GetITemNumber(ll_row,'owner_id'))
//		
//		i_nwarehouse.of_hide_unused(this) //GAP 11/02 - Hide any unused lottable fields
//		
//	End If
	
	integer li_idx
	
	//Added MEA - 10/08 - Add all item in container.
	
	Case "d_location"
		
		If upper(gs_project) = 'PANDORA'  Then
			
//			integer li_count
//			long ll_ownerid, l_code
//			string ls_wh_code
			
			ls_wh_code= idw_main.GetItemString(1, "d_warehouse")
			
			//TAM 2018- -S18358 not allowing them to set location to "RESEARCH%" or RECON%"
			if (data >= "RESEARCH" and data < "RESEARCI") or (data >= "RECON" and data < "RECOP") then
				messagebox('Serialized SOC', 'Location cannot be changed to RESEARCH or RECON.')
				return 1
			end if
			
			l_code = Long(data)
			
			ll_ownerid = this.GetItemNumber( row, "new_owner_id")
//			
//			select count(*)  into :li_count
//			from content
//			where project_id = 'PANDORA'
//			and owner_id = :ll_ownerid
//			and l_code = :l_code 
//			and wh_code = :ls_wh_code USING SQLCA;
//	
//			MessageBox("count", li_count)
//	
//			MessageBox ("Data", string(data))
			
			IF sqlca.sqlcode <> 0 THEN
				
				MessageBox ("DB Error", SQLCA.SQLErrText )
				
			END IF
			
		End IF
		
	
END Choose	

If idw_detail.Find( 	"(Serialized_Ind = 'B' or Serialized_Ind = 'Y') and NOT (c_owner_name = c_new_owner_name)   "  ,1,idw_Detail.RowCount() ) > 0 Then
	
	ib_Serialized           		= TRUE
	ib_Serial_Validated 		= FALSE
	w_owner_change.Title 	= is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo + '   CHANGING SERIALIZED COMPONENTS P/C CAPTURE REQUIRED!'
		
Else
			
	w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

End If 
	
Return

end event

event itemerror;
if dwo.Name = 'sku' Then 
	REturn 1
Else
	Return 2
End If
end event

event itemfocuschanged;call super::itemfocuschanged;String	lsWhere,	&
			lsWarehouse,	&
			lsLot,			&
			lsSerial,		&
			lsSupplier
string ls_po,ls_po2,ls_coo, ls_container_ID //GAP 11/02	
datetime ldt_expiration_date //GAP 11/02
DatawindowChild	ldwc
String				lsNewSQL
Integer	liRC,ll_own
//dts 2015-12-15 - driving TO location drop-down based on Owner (and Project, if serialized)
long llNewOwner
string ls_Serialized, ls_new_pono, ls_sku
boolean lbRefreshToLocs
string	ls_OracleIntegratedOwner, ls_MixedProject, ls_NewOwnerCD
integer li_pos

If dwo.Name = "s_location" Then 
	
//	//Retrieve content records for from loc dropdown
//	This.GetChild("s_location", ldwc)
//	ldwc.SetTransObject(SQLCA)
//	ldwc.setsqlselect( GetFromLocationSQL( ) )
//	ldwc.Retrieve()

Elseif dwo.Name = "d_location" Then
	
	// 06/00 PCONKL - Retrieve locations for  destination Warehouse - only show where project reserved is null or reserved to current project
	lsWarehouse = idw_main.GetItemString(1,"d_warehouse")
	If not isnull(lsWarehouse) Then
		llNewOwner = idw_detail.getitemNumber(row,'new_owner_id')
		//ls_new_inventory_type = Upper(idw_detail.getitemstring(i,'new_inventory_type'))
		ls_Serialized = Upper(idw_detail.getitemstring(row,'serialized_ind'))
		ls_new_pono = Upper(idw_detail.getitemstring(row,'new_po_no'))
		ls_sku = Upper(idw_detail.getitemstring(row,'sku'))
		ls_NewOwnerCD = Upper(idw_detail.getitemstring(row,'c_new_owner_name'))
		//Need to remove Type from Owner Name that is shown on screen.
		li_pos = LastPos ( ls_NewOwnerCD,  "(" )
		IF li_pos > 1 then 
			ls_NewOwnerCD = Left(ls_NewOwnerCD, li_pos -1)
		END IF

		lsWhere = " Where (wh_code = '" + lsWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
		lirc = This.GetChild("d_location", ldwc)
		lsNewSql = replace(istolocsql,pos(istoLocSql,'ZZZZZ'),5,gs_project) /*replace dummy project*/
		lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,lsWarehouse) /*replace dummy warehouse*/

//TAM 2018/04 - S18358 -  Filter out Research and Recon location
		lsNewSql += " and (L_Code not like 'RESEARCH%') and (L_Code not like 'RECON%') "

		//dts 2015-12-29 - Now grabbing 'Mixed Project' (UF18) from Item Master and 'Oracle Integrated' (UF5) from customer master (to control whether single-project rule is enforced)
		// - making single-project rule configurable...
		if ibSingleProjectTurnedOn then
			if ls_sku <> is_ToLocListSKU then
				SELECT max(upper(user_field18)) INTO :ls_MixedProject
					FROM Item_Master
					WHERE project_id = :gs_project AND sku = :ls_sku
					USING SQLCA;
			end if
		else
			ls_MixedProject = 'Y'
		end if

		if llNewOwner <> il_ToLocListOwner then
			SELECT upper(user_field5) INTO :ls_OracleIntegratedOwner
				FROM Customer 
				WHERE project_id = :gs_project AND cust_code = :ls_NewOwnerCD
				USING SQLCA;
		end if
		
		// dts - 2015-12-15 - limit destination locations to eligible locations for the SOC (empty or same owner (and for Serialized, same po_no))
		//Previously, the TO locs drop-down was only poplulated once. Opening a 2nd SOC for a different warehouse would leave an incorrect list (but probably doesn't happen often, if ever).
		//Now comparing the criteria used for the last refresh. If it needs to change, re-retrieve it.
		//2015-12-29 - now allowing mixed Projects for non-oracle-tracked Owners (UF5='N') and for GPNs where Mixed Project (UF18) = 'Y'
		//if ls_serialized = 'B' then
		if ls_serialized = 'B' and ls_OracleIntegratedOwner = 'Y' and ls_MixedProject = 'N' and ibSingleProjectTurnedOn then
			if llNewOwner <> il_ToLocListOwner or ls_new_pono <> is_ToLocListPONO or ls_sku <> is_ToLocListSKU then
				lbRefreshToLocs = true
				lsNewSql += " and L_Code not in (select distinct L_Code from Content with(nolock) where Project_Id = 'pandora' and WH_Code = '" + lsWarehouse +"' and (Owner_Id <> " + string(llNewOwner) + " or inventory_type<>'N' or (po_no <> '" + ls_new_pono + "' and sku = '" + ls_Sku +"')))"
			end if
		elseif lsWarehouse <> is_ToLocListWarehouse or llNewOwner <> il_ToLocListOwner or ls_serialized <> is_ToLocListSerialized then  //this row is not serialized but drop-down is based on a serialized SKU or a different Owner
			lbRefreshToLocs = true
			lsNewSql += " and L_Code not in (select distinct L_Code from Content with(nolock) where Project_Id = 'pandora' and WH_Code = '" + lsWarehouse +"' and (Owner_Id <> " + string(llNewOwner) + " or inventory_type<>'N'))"
		end if
		
		ldwc.SetTransObject(SQLCA)
		ldwc.setsqlselect(lsNewSql)
		//only retrieve once
		//dts - 2015-12-21 - Now refreshing the TO drop-down if there is a change in eligible locations (by warehouse, owner, and GPN/Project (if serialized).
		//If ldwc.Rowcount() <=0 Then
		If ldwc.Rowcount() <=0 or lbRefreshToLocs Then
			is_ToLocListWarehouse = lsWarehouse
			il_ToLocListOwner = llNewOwner
			is_ToLocListPONO = ls_new_pono
			is_ToLocListSKU = ls_sku
			is_ToLocListSerialized = ls_serialized
			w_main.SetMicroHelp("Retrieving Locations...")
			ldwc.Retrieve()
			w_main.SetMicroHelp("Ready")
		End If
	End If
	
End If

end event

event process_enter;//IF This.GetColumnName() = "quantity" THEN
IF This.GetColumnName() = "inventory_type" THEN
	IF This.GetRow() = This.RowCount() THEN
//		tab_main.tabpage_detail.cb_insert.TriggerEvent(Clicked!)
		Return 1
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event retrieveend;call super::retrieveend;Integer i, liRC, li_ret
long ll_owner
ibFootprint = false
if rowcount <= 0 then return


IF Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to rowcount
		ll_owner=This.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.c_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
				
		ll_owner=This.GetItemNumber(i,"new_owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.c_new_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
		
		this.setitemstatus( i, 0,primary!, NotModified! )
	Next
END IF




integer li_line_item_no

integer li_find, li_idx
string lsSku,lsSupplier

//Just in case, make sure there is a line_item_no

li_find = this.Find("IsNull(line_item_no)", 1, this.RowCount())

if li_find > 0 then
	
	for li_idx = 1 to this.RowCount()
		
		this.SetItem( li_idx, "line_item_no", li_idx)
		
			
		
	next		
	
end if

if  this.RowCount() > 0 then
for i = 1 to this.RowCount()
lsSku = This.GetItemString(i, "sku") 
		lsSupplier = This.GetItemString(i, "supp_code") 
	
		if  f_is_sku_foot_print( lsSku, lsSupplier)  Then
	
			ibFootprint = true
		end if
	next
	end if

this.Update()

//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
If gs_Project = "PANDORA" and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" and isOrderStatus = 'P' Then
	iiFootprintBreakRequired = wf_check_full_pallet_container()
	//GailM 2/8/2018 DE8267 Turn serial tab generate button on or off
	If iiFootprintBreakRequired = -1 Then	
		tab_main.tabpage_serial.cb_serial_generate.enabled = FALSE		//Turn Serial Tab Generate button back on	
	End If
End If
	
setQtyAllDisplay( false )
end event

event clicked;//Choose Case dwo.name
//
//Case "s_location" /* GAP 11/02 - force an itemchange - Fix selection bug in  drop down by row*/
//		This.SetItem(row,'s_location'," ")
//END Choose		
//
//Return

end event

event dberror;call super::dberror;

MessageBox (string(sqldbcode), sqlerrtext )
end event

event buttonclicked;call super::buttonclicked;//
//If Upper(idw_main.object.ord_status[1])	<> 'P' AND &
//	Upper(idw_main.object.ord_status[1])	<> 'N' Then Return
//
//
//if dwo.name = "b_delete"  then
//	
//	idw_detail.deleterow( row )
//
//
//	
//end if
end event

type tabpage_serial from userobject within tab_main
event ue_generate ( )
event create ( )
event destroy ( )
event ue_initialize ( )
event ue_clear ( )
event ue_save ( )
event ue_delete ( )
integer x = 18
integer y = 104
integer width = 4247
integer height = 2744
long backcolor = 79741120
string text = "Serial Numbers"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_serial_barcode cb_serial_barcode
dw_serial dw_serial
cb_serial_delete cb_serial_delete
cb_serial_generate cb_serial_generate
end type

event ue_generate();string ls_serialized_ind, ls_sku, ls_supplier
string ls_serial_work, ls_whcode
long ll_detail_row_count, ll_current_row, ll_quantity, i, j
//dts Pandora #804 - Footprint SOCs
string lsPallet, lsSQL, lsWhere, sql_syntax, lsErrors, ls_pono2_ind, ls_container_ind
string lsContainer, lsLocation, lsMsg,lsFilter
boolean lbFootprint
integer liRC
datastore ldsFootprint

//Use to update serial number inventory for serial flag and dono
ldsFootprint = Create Datastore
ldsFootprint.dataobject = 'd_serial_inventory_validate'
ldsFootprint.settransobject( SQLCA)
lsSQL = ldsFootprint.GetSqlSelect()

idsSerialInventory = Create u_ds_ancestor
idsSerialInventory.dataobject = 'd_serial_inventory_validate'
idsSerialInventory.settransobject( SQLCA)

ib_changed = TRUE //03-Nov-2017 :Madhu PEVS-654 2D Barcode

if idw_serial.RowCount() = 0 then

	idw_serial.SetTransObject(SQLCA)
		
	This.SetRedraw(FALSE) 
	
	ll_detail_row_count = idw_detail.RowCount()
	    If ll_detail_row_count > 0 Then
//		li_message_return = MessageBox("P/C Capture","Generating Parent Rows For Serialized Rows~rthat contain Serial Numbers and a Quantity of 1.")

		// SOC detail loop
		for i = 1 to ll_detail_row_count
			ls_serialized_ind = idw_detail.Object.serialized_ind[i]
			//MessageBox("Debug", " row = " + String(i) + "  ser_ind = " + String(ls_serialized_ind))
			if ls_serialized_ind = "B" or ls_serialized_ind = "Y" then

//				if NOT IsNull(idw_detail.Object.quantity[i]) and IsNumber(idw_detail.Object.quantity[i]) then
				if NOT IsNull(idw_detail.Object.quantity[i]) then
					ll_quantity = Long(idw_detail.Object.quantity[i])
				else
					ll_quantity = 0
				end if
				
				/*
				DTS - 2014-05-08 - For Footprint SKUs, select against carton_Serial to get recordset of serial numbers.
				- then scroll through that recordset to insert into idw_serial.
				*/
				ls_pono2_ind = idw_detail.Object.po_no2_controlled_ind[i]
				ls_container_ind = idw_detail.Object.container_tracking_ind[i]
				//Check for Footprint...
				
				//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
				//Use Foot_Prints_Ind Flag
				
				ls_sku = idw_detail.Object.sku[i]
				ls_supplier = idw_detail.Object.supp_code[i]
				lsLocation = idw_detail.Object.s_location[i]
				
				lbFootprint = False
				//ls_serialized_ind = "B" and ls_pono2_ind = 'Y' and ls_container_ind = 'Y' 
				if f_is_sku_foot_print( ls_sku, ls_Supplier) then
					lbFootprint = True // for use below...
					lsPallet = idw_detail.Object.po_no2[i]
					lsContainer = idw_detail.Object.container_id[i]
					
					//Use Serial_Number_Inventory 
					ls_whcode = idw_main.getItemString(1, 's_warehouse')
					
					//MA - 01/18 - Use the Serial_Number_Inventory Table 
					//GailM 1/15/2019 Must also add carton_id since each detail row for a pallet can have multiple cartons
					lsWhere = " where project_id ='PANDORA' "
					lsWhere += " and Po_No2 = '" + lsPallet + "' "
					lsWhere += " and wh_code ='" + ls_whcode + "' "
					lsWhere += " and carton_id = '" + lsContainer + "' "
					//GailM 10/18/2019 Loose serial must be identified further by location and serial flag
					//GailM 12/10/2019 This is the place to force footprint GPNs to change dashes to NA to comply with footprint policy
					If lsPallet = "-" or lsContainer = "-" Then
						lsMsg = "Cannot continue to generate serial numbers.  Footprint GPNs with a dash in pallet or carton must be changed to " + gsFootPrintBlankInd + "."
						lsMsg += "~r~n~r~nPlease double-click the container ID field on detail screen to change pallet and/or carton."
						messagebox("Generate Serial Number error", lsMsg)
						tab_main.SelectTab(2)
						tab_main.tabpage_detail.SetFocus()
						idw_detail.SetColumn("container_id")
						idw_detail.SetFocus()
						idw_detail.ScrollToRow(1)
						Exit
					ElseIf  (lsPallet = gsFootPrintBlankInd and lsContainer = gsFootPrintBlankInd) Then	 //These are loose serials
						lsWhere += " and l_code = '" + lsLocation + "' and serial_flag = 'L' "
						lsWhere += " and do_no = '" + isToNo + "' "
					End If
			
					sql_syntax = lsSQL + lsWhere
					ldsFootprint.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", lsERRORS))
					IF Len(lsErrors) > 0 THEN
						Messagebox(is_title, 'Unable to retreive  Serial_Number_Inventory records.~r~r' + lsErrors)
					Else		
						lirc = ldsFootprint.SetTransobject(sqlca)
						lsFilter = "sku = '" + idw_detail.GetITemString(i,'sku')+"'"
						// Begin - Dinesh - 08/02/2022 -SIMS-59-Cannot confirm SOC due to serial number issue
						ldsFootprint.setfilter(lsFilter)
						ldsFootprint.filter()
						// End - Dinesh - 08/02/2022 -SIMS-59-Cannot confirm SOC due to serial number issue
						ll_quantity = ldsFootprint.Retrieve()
					END IF
					
				end if //Pandora
				
				// Serial number loop
				for j = 1 to ll_quantity
					
					//if ldsFootprint.object.po_no2[j] =idw_detail.Object.po_no2[i] then
					
					ll_current_row = idw_serial.InsertRow(0)

					idw_serial.Object.supp_code_parent[ll_current_row] = idw_detail.Object.supp_code[i]
					idw_serial.Object.sku_parent[ll_current_row] = idw_detail.Object.sku[i]
					ls_serial_work = idw_detail.Object.serial_no[i]
					//GailM 01/09/2018 S27905/F13127/I1304 Google - SIMS Footprints Containerization - make Configurable
					if lbFootprint AND f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION") = "Y" then
						ls_serial_work = ldsFootprint.GetItemString(j, 'Serial_No')
					end if
					if IsNull(ls_serial_work) then ls_serial_work = " "
					idw_serial.Object.serial_no_parent[ll_current_row] = ls_serial_work
					idw_serial.Object.alt_sku_parent[ll_current_row] = idw_detail.Object.sku[i]		// TODO: check this...multi cols set from detail sku column
					idw_serial.Object.no_of_children_for_parent[ll_current_row] = 0						// TODO: appears to always be 0 ???
					idw_serial.Object.supp_code_child[ll_current_row] = idw_detail.Object.supp_code[i]
					idw_serial.Object.sku_child[ll_current_row] = idw_detail.Object.sku[i]				// TODO: check this...many cols set from detail sku column
					idw_serial.Object.serial_no_child[ll_current_row] = ls_serial_work
					idw_serial.Object.alt_sku_child[ll_current_row] = idw_detail.Object.sku[i]			// TODO: check this...many cols set from detail sku column
					idw_serial.Object.report_seq_child[ll_current_row] = 0
					idw_serial.Object.total_sku_qty_child[ll_current_row] = 0								// TODO:	 appears to always be 0 ???
					idw_serial.Object.missing_item_ind[ll_current_row] = "N"
					idw_serial.Object.total_sku_qty_included[ll_current_row] = 0							// TODO:	 appears to always be 0 ???
					idw_serial.Object.to_no[ll_current_row] = idw_detail.Object.to_no[i]
					idw_serial.Object.to_line_item_No[ll_current_row] = idw_detail.Object.line_item_No[i]
					idw_serial.Object.create_date[ll_current_row] = Today()
					idw_serial.Object.last_update[ll_current_row] = Today()
					idw_serial.Object.last_user[ll_current_row] = gs_userid
					idw_serial.Object.user_line_item_no[ll_current_row] = String( idw_detail.Object.user_line_item_no[i] ) //LTK (via dts) - 2016-01-05
				
			next	// Serial number loop
			
			
				
				ldsFootprint.RowsCopy(1, ldsFootprint.RowCount(), Primary!, idsSerialInventory, 1, Primary!)
				ldsFootprint.Reset()
				
//
//	The oringal main loop below spun through this result set...
//
//    FROM Transfer_Detail,   
//         Item_Master  
//   WHERE ( Transfer_Detail.Supp_Code = Item_Master.Supp_Code ) and  
//         ( Transfer_Detail.SKU = Item_Master.SKU ) and
//  			( ( Item_Master.project_id = :a_project ) ) and
//         ( ( Transfer_Detail.TO_No = :a_order ) )    
//				
	
	
	
//				li_qty_of_parents_changed = dw_alt_serial_owner_change_detail.GetItemNumber(Row_No,"quantity")
//				If IsNull( li_qty_of_parents_changed ) or li_qty_of_parents_changed = 0 Then li_qty_of_parents_changed = 1
//				 
//				For Qty_Row = 1 to li_qty_of_parents_changed
//								
//					li_inserted_row_number = dw_alt_serial_parent.InsertRow(0)
//					dw_alt_serial_parent.scrolltorow(li_inserted_row_number)
//				
//					li_number_of_children = 0
//
//		     		tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.retrieve("PANDORA",dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"),"PANDORA")
//					If tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.RowCount()  > 0 Then
//						
//						For Child_List_Row_No = 1 to tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.RowCount()
//             		    	  		li_number_of_children =   li_number_of_children + tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.GetItemNumber(Child_List_Row_No, "Child_qty")
//						Next
//					End If		
//				  // LTK start here
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"supp_code_parent",			dw_alt_serial_owner_change_detail.GetItemString(Row_No,"supp_code"))
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"sku_parent",						dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
//				
//					ls_serial_no = dw_alt_serial_owner_change_detail.GetItemString(Row_No,"serial_no")
//					
//			 		If IsNull( ls_serial_no ) Then  ls_serial_no = " "
//					 
//					If ls_serial_no = " " or ls_serial_no = "-" Then
//						
////						li_default_serial_no_counter =li_default_serial_no_counter  + 1
////						ls_default_serial_no = "MISSING" + String(li_default_serial_no_counter )
//
//						ls_default_serial_no = " "
//						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_parent",			ls_default_serial_no)
//							
//					Else
//						
//						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_parent",			ls_serial_no)
//						
//			 		End If
//					 
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"alt_sku_parent",				dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"no_of_children_for_parent",	 li_number_of_children)
//
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"supp_code_child",				dw_alt_serial_owner_change_detail.GetItemString(Row_No,"supp_code"))
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"sku_child",						dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
//				
//	
//						 
//					If ls_serial_no = " " or ls_serial_no = "-" Then
//						
//						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_child",			ls_default_serial_no)
//						
//					Else
//						
//						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_child",			ls_serial_no)
//						
//			 		End If
//			 
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"alt_sku_child",					dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
//		
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"report_seq_child",				0)
//					
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"total_sku_qty_child",			li_number_of_children)
//					
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"missing_item_ind",				"N")
//					
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"total_sku_qty_included",		li_number_of_children)
//		
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"TO_NO",							dw_alt_serial_owner_change_detail.GetItemString(Row_No,"TO_No"))
//
////					dw_alt_serial_parent.SetItem(li_inserted_row_number,"to_line_item_No",				Row_No)
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"to_line_item_No",				dw_alt_serial_owner_change_detail.GetItemNumber(Row_No,"line_item_No"))			
//   	 				dw_alt_serial_parent.SetItem(li_inserted_row_number,"create_date",					now())
//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"last_update",					now())
//	    				dw_alt_serial_parent.SetItem(li_inserted_row_number,"last_user",	              		gs_userid)
//				 
//					dw_alt_serial_parent.SetRow(1)
//					dw_alt_serial_parent.ScrollToRow(1)	
//					dw_alt_serial_parent.SetColumn("serial_no_parent")	
//					dw_alt_serial_parent.SelectText(1, Len(dw_alt_serial_parent.GetText()))
//					dw_alt_serial_parent.SetFocus()
//				
//				Next
			end if
		next		// SOC detail loop
		
		dwItemStatus l_status
		For i = 1 to idsSerialInventory.rowcount()
			idsSerialInventory.SetItem(i, "Serial_Flag", "P")
			idsSerialInventory.SetItem(i, "do_no", isToNo)
			idsSerialInventory.SetItem(i, "transaction_type", "SOC SN ALLOCATE")
			idsSerialInventory.SetItem(i, "transaction_ID", isToNo)
			l_status = idsSerialInventory.GetItemStatus(i, 0, Primary!)
			If l_status = NewModified! Then 
				idsSerialInventory.SetItemStatus(i, 0, Primary!, DataModified!)
				l_status = idsSerialInventory.GetItemStatus(i, 0, Primary!)
			End If
		Next


//		
//////		dw_alt_serial_child.TriggerEvent("ue_generate_child_list")
////		dw_alt_serial_child.TriggerEvent("ue_display_received_children")
////		
	Else
////		MessageBox("P/C Capture","No Serialized Rows Exist To Capture!")
	End If

else
	MessageBox(is_title,"You may only generate Serial Number rows once.~r~rHowever, you may delete all Serial Number rows and generate once again.")
end if
//
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.SetFilter('1=1')
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.Filter()
//
//dw_alt_serial_parent.SetRedraw( TRUE )
//dw_alt_serial_child.SetRedraw( TRUE )
this.SetRedraw( TRUE ) 

end event

on tabpage_serial.create
this.cb_serial_barcode=create cb_serial_barcode
this.dw_serial=create dw_serial
this.cb_serial_delete=create cb_serial_delete
this.cb_serial_generate=create cb_serial_generate
this.Control[]={this.cb_serial_barcode,&
this.dw_serial,&
this.cb_serial_delete,&
this.cb_serial_generate}
end on

on tabpage_serial.destroy
destroy(this.cb_serial_barcode)
destroy(this.dw_serial)
destroy(this.cb_serial_delete)
destroy(this.cb_serial_generate)
end on

event ue_initialize();this.Enabled = true

if dw_serial.RowCount() =  0 then

	if dw_serial.Retrieve(isToNo) > 0 then
		dw_serial.SetRow(1)
		dw_serial.SetColumn("serial_no_parent")
		dw_serial.SetFocus()
	end if

end if

end event

event ue_clear();Integer li_Number_Of_Parent_Rows, li_Row_Counter
String ls_mod_string

//dw_alt_serial_parent.SetRedraw( 		False 	)
//dw_alt_serial_child.SetRedraw( 		False 	)

//ls_mod_string = "serial_no_parent.Background.Color = "+string(RGB(255,255,255))+")"
//dw_alt_serial_parent.Modify( ls_mod_string )

ib_Duplicated		= 	FALSE
ib_Invalid_Data		=	FALSE
ibSerialModified	= 	FALSE 

If idw_detail.Find( 	"Serialized_Ind = 'B' or Serialized_Ind = 'Y'" ,1,idw_Detail.RowCount()) > 0 Then
	
	ib_Serialized           		= TRUE
	ib_Serial_Validated 		= FALSE
	w_owner_change.Title 	= is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo + '   CHANGING SERIALIZED COMPONENTS P/C CAPTURE REQUIRED!'
		
Else
			
	w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

End If

idw_serial.SetRedraw(true)
//idw_serial.Reset()

long ll_rows, i
ll_rows = idw_serial.RowCount()
for i = ll_rows to 1 step -1	
	idw_serial.DeleteRow(i)
next
ib_SerialDeleted = TRUE

//dw_serial.Retrieve(isToNo)


/*

SetNull( ii_Invalid_Data_Row_Number	)
SetNull( ii_Duplicate_Row_Number		)

 is_Duplicate_Error_Message		= ' '
 is_Invalid_Data_Error_Message	= ' '

dw_alt_serial_child.Reset()
dw_soc_alt_serial_capture_save.Reset()

li_Number_Of_Parent_Rows = dw_alt_serial_parent.RowCount()

If dw_alt_serial_parent.RowCount() > 0 Then

	For  li_Row_Counter = 1 to li_Number_Of_Parent_Rows
	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_parent", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_child", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "DATASTATUS", ' ')	
	
	Next
	
	dw_alt_serial_parent.ScrollToRow(1)	
	dw_alt_serial_parent.SetRow(1)	
	dw_alt_serial_parent.SetColumn("serial_no_parent")			
	dw_alt_serial_parent.SelectText(1, 9999,1,1)
	dw_alt_serial_parent.SetFocus()
End If

cb_alt_serisl_capture_clear.enabled 	= FALSE
cb_print_parent_labels.Enabled         = FALSE
cb_save_parent_changes.Enabled     = FALSE

SetNull( ii_Duplicate_Row_Number		)
SetNull( ii_Invalid_Data_Row_Number	)

dw_alt_serial_parent.SetRedraw( 		True 	)
dw_alt_serial_child.SetRedraw( 		True 	)

*/
end event

event ue_save();// The transaction is handled in the window ue_save event

ii_ret = 1

ib_changed =FALSE //03-Nov-2017 :Madhu PEVS-654 2D Barcode

if idw_serial.Update() < 0 then
	ii_ret = -1
	return
end if


//Integer 		Row_Counter, Row_counter_children, li_no_of_parents_to_serialize, li_no_of_children, li_current_parent_row, li_TO_Line_Item_No
//Integer		li_sql_err_code, li_Total_Number_of_Children, li_Original_Children, li_inserted_row_number
//String			ls_current_parent_supp_code , ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no, ls_filter_string
//String			ls_TONO, ls_Last_User, ls_find_string,  ls_mod_string
//DateTime 	ldt_Create_Date, ldt_Last_Update
//Long 			ll_Blank_serial_numbers
//boolean lb_locked
//
//ii_ret= 0
//
//dw_alt_serial_child.SetRedraw(   FALSE)
//dw_alt_serial_parent.SetRedraw(FALSE)
//
//If Not Trim(String(tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Describe("serial_no_parent.Background.Color" ))) = "67108864" Then 
//	
//dw_alt_serial_parent.AcceptText()
//
//ib_Serial_Validated = FALSE
//
//If NOT (  cb_generate.Enabled 							= FALSE and &
//			cb_alt_serisl_capture_clear.Enabled 		= FALSE and &
//			cb_print_parent_labels.Enabled 			= FALSE and &
//			cb_save_parent_changes.Enabled 			= FALSE )    Then
//
//	If NOT ( ib_Duplicated or  ib_Invalid_Data ) Then 
//	
//		dw_alt_serial_child.SetRedraw(   FALSE )
//
//		li_no_of_parents_to_serialize = dw_alt_serial_parent.RowCount()
//
//		If li_no_of_parents_to_serialize > 0 Then
//						
//			ls_find_string 				=   " TRIM(serial_no_parent)	= '' or IsNull( serial_no_parent) "
//			ll_Blank_serial_numbers = dw_alt_serial_parent.Find( 	ls_find_string ,1, dw_alt_serial_parent.RowCount())
//
// 			If ll_Blank_serial_numbers = 0 THEN 
//
//				dw_alt_serial_child.Reset()
//				dw_alt_serial_child.SetFilter("")
//				dw_alt_serial_child.Filter()
//		
//				Execute Immediate "Begin Transaction" using sqlca; /* 05/25 - PCONKL */
//					
//				For Row_counter = 1 to li_no_of_parents_to_serialize	
//					
//					li_Original_Children	=	dw_alt_serial_parent.GetItemNumber(Row_counter,"total_sku_qty_child")
//
//					If li_Original_Children > 0 Then
//				
//						dw_alt_serial_child.Reset()
//						dw_alt_serial_child.SetFilter("")
//						dw_alt_serial_child.Filter()
//			
//						dw_soc_alt_serial_capture_save.SetFilter("")
//						dw_soc_alt_serial_capture_save.Filter()
//							
//						ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"			))
//						ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"sku_parent"					)) 	
//						ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"alt_sku_parent"				))
//						ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"serial_no_parent"			))
//
//						ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//						ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//						ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//						ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//
//						ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
//		                					'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
//					  					'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
//					  					'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'
//
//						If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
//					
//							dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//							dw_soc_alt_serial_capture_save.Filter()
//		
//							dw_alt_serial_child.Object.Data[ 1,1, dw_soc_alt_serial_capture_save.RowCount(), 25] &
//								= dw_soc_alt_serial_capture_save.Object.Data[1,1, dw_soc_alt_serial_capture_save.RowCount(), 25]
//	
//			    				If dw_alt_serial_child.RowCount() > 0 Then
//								
//							 	li_no_of_children = dw_alt_serial_child.RowCount()
//						
//								For Row_counter_children =  1 To li_no_of_children
//				
//				                  	 li_Total_Number_of_Children = dw_alt_serial_parent.GetItemNumber( Row_counter,"no_of_children_for_parent")
//											
////									dw_alt_serial_child.SetItemStatus(Row_counter_children, 0, Primary!, NewModified!)
//																
//									dw_alt_serial_child.SetItem(     	 Row_counter_children, "no_of_children_for_parent",  li_Total_Number_of_Children  )
//								
//									If  ( li_Total_Number_of_Children  -  1 )  >= 0 Then
//										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_child", 		  li_Total_Number_of_Children  -  1)
//										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_included", 	  li_Total_Number_of_Children  -  1)
//									Else
//										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_child", 		 0)
//										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_included", 	 0)
//									End If
//												 
//								Next
//			
//							
//								
//								li_sql_err_code = dw_alt_serial_child.Update( )
//					
//								If  li_sql_err_code < 0 Then  
//									Execute Immediate "Rollback" using sqlca;
//									MessageBox(" ","database error")
//									return
//								End If
//			
//							End If
//					
//						End If
//					Else
//						
//						dw_alt_serial_child.Reset()
//						
//						li_inserted_row_number = dw_alt_serial_child.InsertRow(0)
//						dw_alt_serial_child.scrolltorow(li_inserted_row_number)
//						
//						ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"			))
//						ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"sku_parent"					)) 	
//						ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"alt_sku_parent"				))
//						ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"serial_no_parent"			))
//
//						ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//						ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//						ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//						ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//
//						
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "no_of_children_for_parent",  li_Total_Number_of_Children  )
//					
//						
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Supp_Code_Parent",			dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"	))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "SKU_Parent",						dw_alt_serial_parent.GetItemString(		Row_counter,"SKU_Parent"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Alt_SKU_Parent",				dw_alt_serial_parent.GetItemString(		Row_counter,"Alt_SKU_Parent"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Serial_no_Parent",				dw_alt_serial_parent.GetItemString(		Row_counter,"Serial_no_Parent"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "No_of_Children_for_parent",	dw_alt_serial_parent.GetItemNumber(		Row_counter,"No_of_Children_for_parent"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Supp_Code_Child",				dw_alt_serial_parent.GetItemString(		Row_counter,"Supp_Code_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "SKU_Child",						dw_alt_serial_parent.GetItemString(		Row_counter,"SKU_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Alt_SKU_Child",					dw_alt_serial_parent.GetItemString(		Row_counter,"Alt_SKU_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Report_Seq_Child",				dw_alt_serial_parent.GetItemNumber(	Row_counter, "Report_Seq_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Total_SKU_Qty_Child",			dw_alt_serial_parent.GetItemNumber(	Row_counter,"Total_SKU_Qty_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Missing_Item_Ind",				dw_alt_serial_parent.GetItemString(		Row_counter,"Missing_Item_Ind"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Total_SKU_Qty_Included",	dw_alt_serial_parent.GetItemNumber(	Row_counter,"Total_SKU_Qty_Included"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Ro_No",							dw_alt_serial_parent.GetItemString(		Row_counter,"Ro_No"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Do_No",							dw_alt_serial_parent.GetItemString(		Row_counter, "Do_No"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Create_Date",					dw_alt_serial_parent.GetItemDateTime(	Row_counter,"Create_Date"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Last_Update",					dw_alt_serial_parent.GetItemDateTime(	Row_counter,"Last_Update"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Last_User",						dw_alt_serial_parent.GetItemString(		Row_counter,"Last_User"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "Serial_no_Child",				dw_alt_serial_parent.GetItemString(		Row_counter,"Serial_no_Child"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "do_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"do_line_item_No"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "ro_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"ro_line_item_No"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "TO_NO",							dw_alt_serial_parent.GetItemString(		Row_counter,"TO_NO"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "to_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"to_line_item_No"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "sku_substitute",					dw_alt_serial_parent.GetItemString(	Row_counter,"sku_substitute"))
//						dw_alt_serial_child.SetItem( li_inserted_row_number, "supplier_substitute",			dw_alt_serial_parent.GetItemString(	Row_counter,"supplier_substitute"))
//					
//						
//						If  ( li_Total_Number_of_Children  -  1 )  >= 0 Then
//								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_child", 		  li_Total_Number_of_Children  -  1)
//								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_included", 	  li_Total_Number_of_Children  -  1)
//						Else
//								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_child", 		 0)
//								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_included", 	 0)
//						End If
//
//
//						li_sql_err_code = dw_alt_serial_child.Update( )
//					
//						If  li_sql_err_code < 0 Then  
//							Execute Immediate "Rollback" using sqlca;
//							MessageBox(" ","database error")
//							return
//						End If
//					
//					End If
//			
//				Next
//			
//				Execute Immediate "COMMIT" USING SQLCA;
//			
//				If NOT (  cb_generate.Enabled 							= FALSE and &
//							cb_alt_serisl_capture_clear.Enabled 		= FALSE and &
//							cb_print_parent_labels.Enabled 			= FALSE and &
//							cb_save_parent_changes.Enabled 			= FALSE )  or &
//							ibConfirmed = TRUE Then MessageBox( 'P/C Capture' ,' All Parent / Children Serialized! ' )
//							
//			 ii_ret = 1
//						
//			 For Row_Counter = 1 to dw_alt_serial_parent.RowCount()
//				   dw_alt_serial_parent.SetItemStatus( Row_Counter, 0, Primary!, NotModified!)
//			Next
//			
//			Else
//			
//				ii_Error_Row_Number     =  ll_Blank_serial_numbers
//				is_Error_Error_Message  =  ' All Serial Numbers Must Be Specified Before Validating! ' 
//				ib_alt_serial_error =True
//				
//				tab_main.tabpage_alt_serial_capture.SetFocus()
//				dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//
//	         	return
//
//			End If
//			
//		Else
//					
//			ii_Error_Row_Number     = 0
//			is_Error_Error_Message  =  'No Parent Rows To Serialize! '
//			ib_alt_serial_error =True
//			
//			dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//			
//			return
//	
//		End If
//	Else
//		
//		ii_Error_Row_Number     = 0
//		is_Error_Error_Message  =  'Cannot save Invaid Data or Duplicate records!!'
//		ib_alt_serial_error =True
//		
//		tab_main.tabpage_alt_serial_capture.SetFocus()
//		dw_alt_serial_parent.TriggerEvent( 'ue_goback')
//
//		 return
//	
//	End If
//	
//End If
//
//Else 
//	
//	ii_ret = 1
//	
//End If
//dw_alt_serial_parent.PostEvent( 'ue_redraw')
//ib_Serial_Validated = TRUE
//cb_alt_serisl_capture_clear.enabled 	= FALSE
//cb_save_parent_changes.Enabled 		= FALSE
//
//// Lockdown the serial number field if necessary.
//f_lockserialnumber(lb_locked)						
//							
//// dw_alt_serial_parent.Modify("serial_no_parent.Protect=1")
//ls_mod_string = "serial_no_parent.Background.Color =67108864	"
//dw_alt_serial_parent.Modify( ls_mod_string )
//
//
//
end event

event ue_delete();Integer li_Number_Of_Parent_Rows, li_Row_Counter
String ls_mod_string

//dw_alt_serial_parent.SetRedraw( 		False 	)
//dw_alt_serial_child.SetRedraw( 		False 	)

//ls_mod_string = "serial_no_parent.Background.Color = "+string(RGB(255,255,255))+")"
//dw_alt_serial_parent.Modify( ls_mod_string )

ib_Duplicated		= 	FALSE
ib_Invalid_Data		=	FALSE
ibSerialModified	= 	FALSE 

If idw_detail.Find( 	"Serialized_Ind = 'B' or Serialized_Ind = 'Y'" ,1,idw_Detail.RowCount()) > 0 Then
	
	ib_Serialized           		= TRUE
	ib_Serial_Validated 		= FALSE
	w_owner_change.Title 	= is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo + '   CHANGING SERIALIZED COMPONENTS P/C CAPTURE REQUIRED!'
		
Else
			
	w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

End If

idw_serial.SetRedraw(true)
//idw_serial.Reset()

long ll_rows, i
ll_rows = idw_serial.RowCount()
for i = ll_rows to 1 step -1	
	idw_serial.DeleteRow(i)
next


//dw_serial.Retrieve(isToNo)


/*

SetNull( ii_Invalid_Data_Row_Number	)
SetNull( ii_Duplicate_Row_Number		)

 is_Duplicate_Error_Message		= ' '
 is_Invalid_Data_Error_Message	= ' '

dw_alt_serial_child.Reset()
dw_soc_alt_serial_capture_save.Reset()

li_Number_Of_Parent_Rows = dw_alt_serial_parent.RowCount()

If dw_alt_serial_parent.RowCount() > 0 Then

	For  li_Row_Counter = 1 to li_Number_Of_Parent_Rows
	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_parent", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_child", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "DATASTATUS", ' ')	
	
	Next
	
	dw_alt_serial_parent.ScrollToRow(1)	
	dw_alt_serial_parent.SetRow(1)	
	dw_alt_serial_parent.SetColumn("serial_no_parent")			
	dw_alt_serial_parent.SelectText(1, 9999,1,1)
	dw_alt_serial_parent.SetFocus()
End If

cb_alt_serisl_capture_clear.enabled 	= FALSE
cb_print_parent_labels.Enabled         = FALSE
cb_save_parent_changes.Enabled     = FALSE

SetNull( ii_Duplicate_Row_Number		)
SetNull( ii_Invalid_Data_Row_Number	)

dw_alt_serial_parent.SetRedraw( 		True 	)
dw_alt_serial_child.SetRedraw( 		True 	)

*/
end event

type cb_serial_barcode from commandbutton within tabpage_serial
integer x = 2711
integer y = 36
integer width = 544
integer height = 100
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Scan 2D Barcode"
end type

event clicked;//03-Nov-2017 :Madhu PEVS-654 - 2D Barcode

If ib_changed Then
	MessageBox(is_title, "Please save changes first!")
	Return
End If

If idw_serial.rowcount( ) = 0 Then
	MessageBox(is_title, "Please generate Serial No records first!")
	Return
End If

open(w_owner_serial_numbers)
end event

type dw_serial from u_dw_ancestor within tabpage_serial
event ue_keydown pbm_dwnkey
event ue_mouseclick pbm_rbuttondown
integer x = 5
integer y = 172
integer width = 4242
integer height = 2560
integer taborder = 20
string dataobject = "d_do_alt_serial_capture_tono"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_keydown;//17-Aug-2015 :Madhu- Added code to prevent Manual Scanning
If gbPressKeySNScan ='Y' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			IF  Upper(gs_project)='PANDORA' and this.getcolumnname( )='serial_no_parent' and  ibPressF10Unlock =FALSE THEN
				If ibkeytype =FALSE THEN
					timer(0.5)
					ibkeytype=TRUE
				END IF
				
				//Get Key Pressed
				IF (KeyDown(KeyShift!) and KeyDown(KeyInsert!)) or (KeyDown(KeyControl!))THEN
					MessageBox("Manual Entry", " Control, Shift Key's are disabled!")
					this.setitem(idw_serial.getrow(), 'serial_no_parent', '-')
					ibkeytype =FALSE
				END IF

				CHOOSE CASE key
					CASE KeyEnter!,KeyUpArrow!,KeyDownArrow!,KeyLeftArrow!,KeyRightArrow!
						timer(0)
						ibkeytype=FALSE
				END CHOOSE
			END IF
	END CHOOSE
END IF
end event

event ue_mouseclick;//17-Aug-2015 :Madhu- Added code to prevent Manul Scanning
If gbPressKeySNScan ='Y' THEN
	CHOOSE CASE gs_role
		CASE '1','2'
			IF Upper(gs_project)='PANDORA' and this.getcolumnname( )='serial_no_parent'  and ibPressF10Unlock =FALSE THEN
				ibmouseclick =FALSE
				MessageBox("MouseClick","Right Mouse Click (RMC) Option is disabled")
			ELSE 
				ibmouseclick =TRUE
			END IF
	END CHOOSE
END IF

Return 0
end event

event constructor;call super::constructor;this.SetRowFocusIndicator(Hand!)
end event

event itemerror;call super::itemerror;if ib_display_unique_item_error_message then
	ib_display_unique_item_error_message = false	// Message displayed in itemchanged
else
	MessageBox("SOC Serial Scan", "Serial number (" + Data + ") does not exist for given SKU/Owner/Project/Location." + &
											"~r~nPlease enter a valid serial number.", StopSign!)
end if

return 1

end event

event itemchanged;call super::itemchanged;// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'

BOOLEAN lb_SN_cleaned = FALSE
LONG    ll_Rtn = 0

CHOOSE CASE dwo.name
		
	CASE 'serial_no_parent', 'serial_no_child'
		IF UPPER(gs_project) = 'PANDORA' THEN
			
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

END CHOOSE

//25-Jun-2015 :Madhu- As Disccused in code review -shifted code from here -START
//IF lb_SN_cleaned THEN
//	ll_Rtn = 2
//	this.setitem( row, dwo.name, data )
//ELSE
//	ll_Rtn = 0
//
//END IF
//25-Jun-2015 :Madhu- As Disccused in code review -shifted code from here -END

// Validate serial numbers here

string ls_owner_cd, ls_parent_sku
long ll_owner_id, ll_content_owner_id

ls_parent_sku = Upper(idw_serial.Object.sku_parent[row])

string ls_find_string
long ll_find_detail_row
string ls_from_loc, ls_from_project, ls_tono

ls_find_string = "sku = '" + ls_parent_sku + "' and line_item_no = " + string(this.Object.to_line_item_no[row])
ll_find_detail_row = idw_detail.find(ls_Find_string, 1, idw_detail.RowCount())
// TODO: if row not found return 1
ll_owner_id = idw_detail.GetItemNumber(ll_find_detail_row, "owner_id")

// Ensure user does not enter duplicate serial numbers in the Parent Serial Number list
if this.Find ( "serial_no_parent = '" + data + "'", 1, this.RowCount()) > 0 then
	ib_display_unique_item_error_message = true
	MessageBox("Serial Number Entry Error", "Serial number (" + data + ") already exists in Parent Serial Number list!  "  + &
								"~r~nPlease enter a unique serial number.", StopSign!)
	this.SelectText(1, Len(this.GetText()))
	return 1
end if

//25-Jun-2015 :Madhu- As Disccused in code review -shifted code to here -START
IF lb_SN_cleaned THEN
	ll_Rtn = 2
	this.setitem( row, dwo.name, data )
ELSE
	ll_Rtn = 0

END IF
//25-Jun-2015 :Madhu- As Disccused in code review -shifted code to here -END

// LTK 20110206  SOC enhancements
// Per Roy Rosete, validate against both the serial_number_inventory and 
// content table to determine if the serial # exists.

//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
//dts - 2015-12-29 - adding From Project and Location (for non 'MAIN') to 'where' clause as we're now tracking serial #s by project and segregating by location
//dts 2016-01-05 - need to allow serial # to be from a different location as there could be several Detail lines (with different FROM locs).
ls_from_loc = idw_detail.GetItemString(ll_find_detail_row, "s_location")
ls_from_project = idw_detail.GetItemString(ll_find_detail_row, "po_no")
ls_tono = idw_detail.GetItemString(ll_find_detail_row, "to_no")
//if upper(ls_from_project) <> 'MAIN' then
if upper(ls_from_project) <> 'MAIN' and ibSingleProjectTurnedOn then
	SELECT owner_cd 
	INTO :ls_owner_cd
	FROM serial_number_inventory
	//WHERE project_id = 'PANDORA'
	WHERE project_id = :gs_project
	AND sku = :ls_parent_sku
	AND owner_id = :ll_owner_id
	and po_no = :ls_from_project //dts 2015-12-29
//	and l_code = :ls_from_loc //dts 2015-12-29
	and l_code in(select s_location from transfer_detail where to_no = :ls_tono and sku = :ls_parent_sku)
	AND serial_no = :data;
else // not validating l_code for non-MAIN inventory (as we don't really know where it is)
	SELECT owner_cd 
	INTO :ls_owner_cd
	FROM serial_number_inventory
	WHERE project_id = :gs_project
	AND sku = :ls_parent_sku
	AND owner_id = :ll_owner_id
	and po_no = :ls_from_project //dts 2015-12-29
	AND serial_no = :data;
end if

if Trim(ls_owner_cd) = "" then
	
	//BCR 15-DEC-2011: Treat Bluecoat same as Pandora...modify code to use gs_project instead of Pandora
	//if upper(ls_from_project) <> 'MAIN' then
	if upper(ls_from_project) <> 'MAIN' and ibSingleProjectTurnedOn then
		SELECT owner_id 
		INTO :ll_content_owner_id
		FROM content
	//	WHERE project_id = 'PANDORA'
		WHERE project_id = :gs_project
		AND sku = :ls_parent_sku
		AND owner_id = :ll_owner_id
		and po_no = :ls_from_project //dts 2015-12-29
		//and l_code = :ls_from_loc //dts 2015-12-29
		and l_code in(select s_location from transfer_detail where to_no = :ls_tono and sku = :ls_parent_sku)
		AND serial_no = :data;
	else // not validating l_code for non-MAIN inventory (as we don't really know where it is)
		SELECT owner_id 
		INTO :ll_content_owner_id
		FROM content
		WHERE project_id = :gs_project
		AND sku = :ls_parent_sku
		AND owner_id = :ll_owner_id
		and po_no = :ls_from_project //dts 2015-12-29
		AND serial_no = :data;
	end if

	if ll_content_owner_id = 0 then
		// Serial number is not in serial_number_inventory nor content
		this.SelectText(1, Len(this.GetText()))
		return 1
	end if
end if

// Also set serial_no_child column
this.Object.serial_no_child[row] = data


RETURN ll_Rtn

// OLD item changed event...
//Integer 	Row_count, Row_Count_Child, Imposter_Row_Counter, li_no_of_children, li_current_parent_row, li_TO_Line_Item_No, li_Original_Children,li_inserted_row_number
//String 	ls_current_parent_supp_code , ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no, ls_filter_string
//String 	ls_imposter_parent_supp_code , ls_imposter_parent_sku, ls_imposter_parent_alt_sku, ls_imposter_parent_serial_no
//String	 	ls_tono, ls_Last_User, ls_mod_string, ls_find_string
//Long 		ll_Duplicated_Row_number
//DateTime ldt_Create_Date, ldt_Last_Update
//
//
//If ib_new_search = FALSE Then
//
//PostEvent('ue_redraw')
//
//dw_alt_serial_child.SetRedraw(FALSE)
//dw_alt_serial_parent.SetRedraw(FALSE)
//dw_alt_serial_child.Reset()
//dw_alt_serial_child.SetFilter("")
//dw_alt_serial_child.Filter()
//
//ib_processed_at_least_one				= TRUE
//
//If Trim(data) = '' or IsNull(data) Then 
//			
//	ib_alt_serial_error              =   FALSE
//	ib_Duplicated		= 	FALSE
//	ib_Invalid_Data		=	FALSE
//	ibSerialModified	= 	FALSE
//
//	SetNull( ii_Duplicate_Row_Number		)
//	SetNull( ii_Invalid_Data_Row_Number	)
//
//	 is_Duplicate_Error_Message		= ' '
//	 is_Invalid_Data_Error_Message	= ' '
//	 
//	dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	' '	)
//
//Else
//	
//	ls_TONO								= Upper(dw_alt_serial_parent.GetItemString(		row,"TO_NO"						))
//	li_TO_Line_Item_No				= dw_alt_serial_parent.GetItemNumber(	row,"to_line_item_No"		)	
//
//	ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		row,"supp_code_parent"			))
//	ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		row,"sku_parent"						)) 	
//	ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		row,"alt_sku_parent"				))
//	ls_current_parent_serial_no 	= Upper(data)
//
//// 10/17/10 - check that the serial # exists for the SKU/Owner....
//long llOwner, llFindDetail
//string lsOwner
//ls_Find_string = "sku = '" + ls_current_parent_sku + "' and line_item_no = " + string(li_TO_Line_Item_no)
//llFindDetail = idw_detail.find(ls_Find_string, 1, idw_detail.RowCount())
//llOwner = idw_detail.GetItemNumber(llFindDetail, "Owner_ID")
//select owner_cd into :lsOwner from serial_number_inventory
//where project_id = 'PANDORA' and sku = :ls_current_parent_sku and owner_id = :llOwner
//and serial_no = :data;
//if lsOwner = "" then
//	return 1
//end if
//
//	ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//	ls_current_parent_sku  			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//	ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//	ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//
//	ldt_Create_Date					= 	dw_alt_serial_parent.GetItemDateTime(	row,"create_date"				)
//	ldt_Last_Update					= 	dw_alt_serial_parent.GetItemDateTime(	row,"last_update"				)
//	ls_Last_User						= 	Upper(dw_alt_serial_parent.GetItemString(		row,"last_user"					))
//
//// Check for Duplicate Serial Numbers
//
////If youv'e gotten a Parent Before see if this one has the same credentials
//
//	If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
//
//		ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
//		                	'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
//					  	'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
//					  	'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'
//
//
//		dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//		dw_soc_alt_serial_capture_save.Filter()
//
//		If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
//		
//			For Imposter_Row_Counter = 1 to dw_alt_serial_parent.RowCount()
//				
//				ls_imposter_parent_supp_code			= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"supp_code_parent"		))
//				ls_imposter_parent_sku					= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"sku_parent"				)) 	
//				ls_imposter_parent_alt_sku				= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"alt_sku_parent"			))
//				ls_imposter_parent_serial_no			= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"serial_no_parent"		)) 
//			
//				ls_imposter_parent_supp_code	  		=	ls_imposter_parent_supp_code	 	+ Fill( " ", 7 - 	Len( 	ls_imposter_parent_supp_code	 	))
//				ls_imposter_parent_sku  				=	ls_imposter_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_imposter_parent_sku 				))
//				ls_imposter_parent_alt_sku    			=	ls_imposter_parent_alt_sku			+ Fill( " ", 50 -	Len(	ls_imposter_parent_alt_sku 			))
//				ls_imposter_parent_serial_no  			=	ls_imposter_parent_serial_no  		+ Fill( " ", 50 - 	Len( 	ls_imposter_parent_serial_no		))
//	
//				If 	ls_imposter_parent_supp_code		= ls_current_parent_supp_code 	and &
//					ls_imposter_parent_sku				= ls_current_parent_sku 			and &
//					ls_imposter_parent_alt_sku			= ls_current_parent_alt_sku 		and &
//					ls_imposter_parent_serial_no		= ls_current_parent_serial_no 		and Imposter_Row_Counter <> row Then
//		
//					//   This ones an imposter			
//
//					ls_find_string ='supp_code_parent= "' +  ls_current_parent_supp_code    + '"  and ' 		+  	&
//										' sku_parent = "' +  ls_current_parent_sku			  	  + '"  and  '		+	&
//										' alt_sku_parent = "' +  ls_current_parent_alt_sku 	  + '"  and  '		+	&
//								         ' serial_no_parent	= "' +  ls_current_parent_serial_no + '"'
//					
//					ll_Duplicated_Row_number = dw_alt_serial_parent.Find( 	ls_find_string ,1, dw_alt_serial_parent.RowCount())
//																									
//       				If ll_Duplicated_Row_number = ROW  Then ll_Duplicated_Row_number = dw_alt_serial_parent.Find( 	ls_find_string,ROW+1, dw_alt_serial_parent.RowCount())
//																									
//					is_Duplicate_Error_Message = 'Duplicate Serial Numbers For Serial Number '+ Trim( ls_current_parent_serial_no ) +' ~r~r~r Found at Rows ' +string( ll_Duplicated_Row_number )+ ' and '+ string(row)+ &
//										"~r~r~r parent_supp_code =  " 	+ ls_current_parent_supp_code	+ &
//		               					"~r sku_parent            =  " 	+ ls_current_parent_sku				+ &
//										"~r alt_sku_parent       =  "	+ ls_current_parent_alt_sku			+ &
//										"~r serial_no_parent    =  "	+ ls_current_parent_serial_no
//				
//				
//					ls_filter_string = 	'1 = 1'
//					dw_soc_alt_serial_capture_save.SetFilter(		ls_filter_string	)
//					dw_soc_alt_serial_capture_save.Filter()
//				
//					ii_Duplicate_Row_Number = row
//					
//					ib_Duplicated 		= 	TRUE
//					ib_Invalid_Data		=	FALSE
//	 
//	 				dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	'DUPLICATE'	)
//					
//					PostEvent( "ue_goback("+STRING(ii_Duplicate_Row_Number)+ ")")
//	
//					return
//		
//				End If
//			
//			NEXT
//		
//		Else
//		
////		Turn back on the previously filtered off SAVE records and continue
//			ls_filter_string = 	'1 = 1'
//			dw_soc_alt_serial_capture_save.SetFilter(		ls_filter_string	)
//			dw_soc_alt_serial_capture_save.Filter()
//	
//		End If
//	End If
//
////	THIS IS A PARENT WHO IS LOOKING FOR CHILDREN
//
//	li_Original_Children	=	dw_alt_serial_parent.GetItemNumber(Row,"total_sku_qty_child")
//	
//	dw_alt_serial_child.ReSet()
//
//	If li_Original_Children > 0 Then
//
////	If NOT a Duplicate Then Get Parent and Children to verify whether they have been Serialized before
//	
//		dw_alt_serial_child.Retrieve(	ls_current_parent_supp_code,  ls_current_parent_sku, 			&
//														ls_current_parent_alt_sku, 		ls_current_parent_serial_no,	&	
//														li_TO_Line_Item_No, 				ldt_Create_Date, 					&
//														ldt_Last_Update,					ls_Last_User, ls_tono				)
//
//
////	During the retreive process the records for both the Parent and the parent's children were returrned
//
//		If dw_alt_serial_child.RowCount() = 0 Then
//		
//// 	 If NO records were returned then not only is there no children But NO Parent exists either
//// 	Tell the user that the Parent is invalid and return		
//		
//			is_Invalid_Data_Error_Message =  "Serial Number " +Trim(ls_current_parent_serial_no)+" is NOT Valid! ~r~r Row Number            = " + string(row)+ &
//										"~r~r Parent Supplier       =  " 	+ Trim(ls_current_parent_supp_code) 	+	&
//		               					"~r Parent  SKU            =  " 	+ 	Trim(ls_current_parent_sku)  			+	 &
//										"~r Parent Alt SKU        =  "	+ Trim(ls_current_parent_alt_sku) 	+ &
//										"~r Parent Serial No      =  "	+ Trim( ls_current_parent_serial_no)
//
//			ii_Invalid_Data_Row_Number = row
//
//			ib_Duplicated     	= FALSE
//			ib_Invalid_Data 	= TRUE
//
//			ls_filter_string = 	'1 = 2'
//			dw_alt_serial_child.SetFilter(ls_filter_string)
//			dw_alt_serial_child.Filter()
//		
//			dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	'INVALID'	)
//
//		
//			PostEvent( "ue_goback("+STRING(ii_Invalid_Data_Row_Number)+ ")")
//		
//			return
//	
//		Else
//	
//// 		Otherwise, If a record(s) was/were returned then seperate the Parent from the children
////		and display the children for everyone to see
//	
//// 		 Here we save the information to a Save Datawindow so that we dont have to retreive it ever again 
//// 		Also, the information saved here is used during the save process 
//
//			If dw_soc_alt_serial_capture_save.RowCount() > 0 Then 
//
//				dw_soc_alt_serial_capture_save.Object.Data[dw_soc_alt_serial_capture_save.RowCount() + 1,1, dw_soc_alt_serial_capture_save.RowCount() + dw_alt_serial_child.RowCount(), 25] &
//							= dw_alt_serial_child.Object.Data[1,1, dw_alt_serial_child.RowCount(), 25]
//		
//			Else
//		
//				dw_soc_alt_serial_capture_save.Object.Data[ 1,1, dw_alt_serial_child.RowCount(), 25]&
//							= dw_alt_serial_child.Object.Data[1,1, dw_alt_serial_child.RowCount(), 25]
//				
//			End If
//	
//	//	 Seperate the Parent from the display of children
//
//			ls_filter_string = 	'NOT ( serial_no_parent = serial_no_child  )  '
//			dw_alt_serial_child.SetFilter(ls_filter_string)
//			dw_alt_serial_child.Filter()
//	
//		End If
//		
//	Else
//			dw_alt_serial_child.Reset()
//						
//			li_inserted_row_number =dw_soc_alt_serial_capture_save.InsertRow(0)
//			dw_soc_alt_serial_capture_save.scrolltorow(li_inserted_row_number)
//						
//			ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row,"supp_code_parent"			))
//			ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row,"sku_parent"					)) 	
//			ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row,"alt_sku_parent"				))
//			ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row,"serial_no_parent"			))
//
//			ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//			ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//			ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//			ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//	
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "no_of_children_for_parent", 0)
//						
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Supp_Code_Parent",			dw_alt_serial_parent.GetItemString(		Row,"supp_code_parent"	))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "SKU_Parent",					dw_alt_serial_parent.GetItemString(		Row,"SKU_Parent"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Alt_SKU_Parent",				dw_alt_serial_parent.GetItemString(		Row,"Alt_SKU_Parent"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Serial_no_Parent",				dw_alt_serial_parent.GetItemString(		Row,"Serial_no_Parent"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "No_of_Children_for_parent",dw_alt_serial_parent.GetItemNumber(	Row,"No_of_Children_for_parent"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Supp_Code_Child",			dw_alt_serial_parent.GetItemString(		Row,"Supp_Code_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "SKU_Child",						dw_alt_serial_parent.GetItemString(		Row,"SKU_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Alt_SKU_Child",					dw_alt_serial_parent.GetItemString(		Row,"Alt_SKU_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Report_Seq_Child",			dw_alt_serial_parent.GetItemNumber(	Row, "Report_Seq_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Total_SKU_Qty_Child",		dw_alt_serial_parent.GetItemNumber(	Row,"Total_SKU_Qty_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Missing_Item_Ind",			dw_alt_serial_parent.GetItemString(		Row,"Missing_Item_Ind"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Total_SKU_Qty_Included",	dw_alt_serial_parent.GetItemNumber(	Row,"Total_SKU_Qty_Included"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Ro_No",							dw_alt_serial_parent.GetItemString(		Row,"Ro_No"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Do_No",							dw_alt_serial_parent.GetItemString(		Row, "Do_No"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Create_Date",					dw_alt_serial_parent.GetItemDateTime(	Row,"Create_Date"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Last_Update",					dw_alt_serial_parent.GetItemDateTime(	Row,"Last_Update"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Last_User",						dw_alt_serial_parent.GetItemString(		Row,"Last_User"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Serial_no_Child",				dw_alt_serial_parent.GetItemString(		Row,"Serial_no_Child"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "do_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"do_line_item_No"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "ro_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"ro_line_item_No"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "TO_NO",							dw_alt_serial_parent.GetItemString(		Row,"TO_NO"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "to_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"to_line_item_No"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "total_sku_qty_child", 		 	0)
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "total_sku_qty_included", 		0)
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "sku_substitute",					dw_alt_serial_parent.GetItemString(	Row,"sku_substitute"))
//			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "supplier_substitute",			dw_alt_serial_parent.GetItemString(	Row,"supplier_substitute"))			
//	End If
//
//// 	Load the entered serial number into the Parent record and Upper Case it so that all data matches
//
//	dw_alt_serial_parent.SetItem(row,"serial_no_parent",Upper(data))	
//	dw_alt_serial_parent.SetItem(row,"serial_no_child",Upper(data))	
//
//	dw_alt_serial_parent.SetRow(row)	
//	dw_alt_serial_parent.ScrollToRow(row)	
//	dw_alt_serial_parent.SetColumn("serial_no_parent")	
//	dw_alt_serial_parent.SelectText(1, Len(	dw_alt_serial_parent.GetText()))
//	dw_alt_serial_parent.SetFocus()
//	
//	ib_alt_serial_error 			= FALSE
//	ib_Duplicated					= FALSE
//	ib_Invalid_Data					= FALSE
//	ibSerialModified				= TRUE
//		
//     cb_alt_serisl_capture_clear.enabled  	= TRUE
//     cb_print_parent_labels.enabled         = TRUE
//     cb_save_parent_changes.enabled		= TRUE
//	  
//	 dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	' '	)
//
//End If
//
//End IF
end event

event itemfocuschanged;call super::itemfocuschanged;//TimA 12/08/11
//Pandora issue 311 Delete the dashes in the serial_no_field
If upper(gs_project) = 'PANDORA' then
	Choose Case Upper(dwo.Name)
		Case 'SERIAL_NO_PARENT'
			this.SelectText(1, Len(this.GetText()))
	end choose
End if
end event

type cb_serial_delete from commandbutton within tabpage_serial
integer x = 471
integer y = 28
integer width = 402
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;Parent.TriggerEvent("ue_clear")
end event

type cb_serial_generate from commandbutton within tabpage_serial
integer x = 27
integer y = 28
integer width = 402
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;//ib_new_search =FALSE
Parent.TriggerEvent("ue_generate")
////Temp-DTS - 09/20/2010 - enabling the Serial field when a (new) order is generated....
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Protect=0") //Temp-DTS
//tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Background.Color = " + string(RGB(255,255,255))+")") //Temp-DTS
//
//cb_generate.Enabled = False		
//
end event

type tabpage_alt_serial_capture from userobject within tab_main
event ue_initialize ( )
event ue_save ( )
event ue_generate ( )
event ue_delete ( )
event uie_clear_children_for_current_parent ( )
event create ( )
event destroy ( )
event ue_clear_current_parent ( )
event ue_display_received_children ( )
event ue_clear ( )
string tag = "P/C Capture"
boolean visible = false
integer x = 18
integer y = 104
integer width = 4247
integer height = 2744
long backcolor = 79741120
string text = "P/C Capture"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_alt_serisl_capture_clear cb_alt_serisl_capture_clear
cb_generate cb_generate
cb_save_parent_changes cb_save_parent_changes
cb_print_parent_labels cb_print_parent_labels
dw_alt_serial_child_list dw_alt_serial_child_list
dw_soc_alt_serial_capture_save dw_soc_alt_serial_capture_save
dw_alt_serial_owner_change_detail dw_alt_serial_owner_change_detail
st_alt_serial_me st_alt_serial_me
dw_alt_serial_parent dw_alt_serial_parent
dw_alt_serial_child dw_alt_serial_child
end type

event ue_initialize();String 	ls_current_parent_supp_code,	ls_current_parent_sku ,	ls_current_parent_alt_sku,	ls_current_parent_serial_no,	ls_filter_string 

This.Enabled = True

If dw_alt_serial_parent.RowCount() =  0 Then 
	
	dw_alt_serial_parent.Retrieve(isToNo)

	If dw_alt_serial_parent.RowCount() > 0  Then
		
		dw_alt_serial_child.Retrieve(isToNo)
	
		If dw_alt_serial_child.RowCount() > 0 Then
			
			ls_current_parent_supp_code 	= dw_alt_serial_parent.GetItemString(1,"supp_code_parent")
			ls_current_parent_sku  			= dw_alt_serial_parent.GetItemString(1,"sku_parent") 	
			ls_current_parent_alt_sku 		= dw_alt_serial_parent.GetItemString(1,"alt_sku_parent") 
			ls_current_parent_serial_no 	= dw_alt_serial_parent.GetItemString(1,"serial_no_parent")
		
			ls_filter_string = 	'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
		 	                     	 	'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
									'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
									'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'

			dw_alt_serial_child.SetFilter(ls_filter_string)
			dw_alt_serial_child.Filter()
			dw_alt_serial_child.SetRow(1)
			dw_alt_serial_child.Setcolumn("serial_no_child")
			
	        
		End If
			
		dw_alt_serial_parent.SetRow(1)
		dw_alt_serial_parent.SetColumn("serial_no_parent")
		dw_alt_serial_parent.SetFocus()
		 	
//		ib_changed = False
//		ibPCCAPTURElModified = False
	Else
	
//		TriggerEvent("ue_generate")
	
//	ib_changed = True
//	ibPCCAPTURElModified = True
	
	End If
	
End If
	
end event

event ue_save();Integer 		Row_Counter, Row_counter_children, li_no_of_parents_to_serialize, li_no_of_children, li_current_parent_row, li_TO_Line_Item_No
Integer		li_sql_err_code, li_Total_Number_of_Children, li_Original_Children, li_inserted_row_number
String			ls_current_parent_supp_code , ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no, ls_filter_string
String			ls_TONO, ls_Last_User, ls_find_string,  ls_mod_string
DateTime 	ldt_Create_Date, ldt_Last_Update
Long 			ll_Blank_serial_numbers
boolean lb_locked

ii_ret= 0

dw_alt_serial_child.SetRedraw(   FALSE)
dw_alt_serial_parent.SetRedraw(FALSE)

If Not Trim(String(tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Describe("serial_no_parent.Background.Color" ))) = "67108864" Then 
	
dw_alt_serial_parent.AcceptText()

ib_Serial_Validated = FALSE

If NOT (  cb_generate.Enabled 							= FALSE and &
			cb_alt_serisl_capture_clear.Enabled 		= FALSE and &
			cb_print_parent_labels.Enabled 			= FALSE and &
			cb_save_parent_changes.Enabled 			= FALSE )    Then

	If NOT ( ib_Duplicated or  ib_Invalid_Data ) Then 
	
		dw_alt_serial_child.SetRedraw(   FALSE )

		li_no_of_parents_to_serialize = dw_alt_serial_parent.RowCount()

		If li_no_of_parents_to_serialize > 0 Then
						
			ls_find_string 				=   " TRIM(serial_no_parent)	= '' or IsNull( serial_no_parent) "
			ll_Blank_serial_numbers = dw_alt_serial_parent.Find( 	ls_find_string ,1, dw_alt_serial_parent.RowCount())

 			If ll_Blank_serial_numbers = 0 THEN 

				dw_alt_serial_child.Reset()
				dw_alt_serial_child.SetFilter("")
				dw_alt_serial_child.Filter()
		
				Execute Immediate "Begin Transaction" using sqlca; /* 05/25 - PCONKL */
					
				For Row_counter = 1 to li_no_of_parents_to_serialize	
					
					li_Original_Children	=	dw_alt_serial_parent.GetItemNumber(Row_counter,"total_sku_qty_child")

					If li_Original_Children > 0 Then
				
						dw_alt_serial_child.Reset()
						dw_alt_serial_child.SetFilter("")
						dw_alt_serial_child.Filter()
			
						dw_soc_alt_serial_capture_save.SetFilter("")
						dw_soc_alt_serial_capture_save.Filter()
							
						ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"			))
						ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"sku_parent"					)) 	
						ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"alt_sku_parent"				))
						ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"serial_no_parent"			))

						ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
						ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
						ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
						ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))

						ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
		                					'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
					  					'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
					  					'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'

						If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
					
							dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
							dw_soc_alt_serial_capture_save.Filter()
		
							dw_alt_serial_child.Object.Data[ 1,1, dw_soc_alt_serial_capture_save.RowCount(), 25] &
								= dw_soc_alt_serial_capture_save.Object.Data[1,1, dw_soc_alt_serial_capture_save.RowCount(), 25]
	
			    				If dw_alt_serial_child.RowCount() > 0 Then
								
							 	li_no_of_children = dw_alt_serial_child.RowCount()
						
								For Row_counter_children =  1 To li_no_of_children
				
				                  	 li_Total_Number_of_Children = dw_alt_serial_parent.GetItemNumber( Row_counter,"no_of_children_for_parent")
											
//									dw_alt_serial_child.SetItemStatus(Row_counter_children, 0, Primary!, NewModified!)
																
									dw_alt_serial_child.SetItem(     	 Row_counter_children, "no_of_children_for_parent",  li_Total_Number_of_Children  )
								
									If  ( li_Total_Number_of_Children  -  1 )  >= 0 Then
										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_child", 		  li_Total_Number_of_Children  -  1)
										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_included", 	  li_Total_Number_of_Children  -  1)
									Else
										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_child", 		 0)
										dw_alt_serial_child.SetItem(     	 Row_counter_children, "total_sku_qty_included", 	 0)
									End If
												 
								Next
			
							
								
								li_sql_err_code = dw_alt_serial_child.Update( )
					
								If  li_sql_err_code < 0 Then  
									Execute Immediate "Rollback" using sqlca;
									MessageBox(" ","database error")
									return
								End If
			
							End If
					
						End If
					Else
						
						dw_alt_serial_child.Reset()
						
						li_inserted_row_number = dw_alt_serial_child.InsertRow(0)
						dw_alt_serial_child.scrolltorow(li_inserted_row_number)
						
						ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"			))
						ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"sku_parent"					)) 	
						ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"alt_sku_parent"				))
						ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row_counter,"serial_no_parent"			))

						ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
						ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
						ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
						ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))

						
						dw_alt_serial_child.SetItem( li_inserted_row_number, "no_of_children_for_parent",  li_Total_Number_of_Children  )
					
						
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Supp_Code_Parent",			dw_alt_serial_parent.GetItemString(		Row_counter,"supp_code_parent"	))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "SKU_Parent",						dw_alt_serial_parent.GetItemString(		Row_counter,"SKU_Parent"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Alt_SKU_Parent",				dw_alt_serial_parent.GetItemString(		Row_counter,"Alt_SKU_Parent"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Serial_no_Parent",				dw_alt_serial_parent.GetItemString(		Row_counter,"Serial_no_Parent"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "No_of_Children_for_parent",	dw_alt_serial_parent.GetItemNumber(		Row_counter,"No_of_Children_for_parent"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Supp_Code_Child",				dw_alt_serial_parent.GetItemString(		Row_counter,"Supp_Code_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "SKU_Child",						dw_alt_serial_parent.GetItemString(		Row_counter,"SKU_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Alt_SKU_Child",					dw_alt_serial_parent.GetItemString(		Row_counter,"Alt_SKU_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Report_Seq_Child",				dw_alt_serial_parent.GetItemNumber(	Row_counter, "Report_Seq_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Total_SKU_Qty_Child",			dw_alt_serial_parent.GetItemNumber(	Row_counter,"Total_SKU_Qty_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Missing_Item_Ind",				dw_alt_serial_parent.GetItemString(		Row_counter,"Missing_Item_Ind"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Total_SKU_Qty_Included",	dw_alt_serial_parent.GetItemNumber(	Row_counter,"Total_SKU_Qty_Included"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Ro_No",							dw_alt_serial_parent.GetItemString(		Row_counter,"Ro_No"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Do_No",							dw_alt_serial_parent.GetItemString(		Row_counter, "Do_No"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Create_Date",					dw_alt_serial_parent.GetItemDateTime(	Row_counter,"Create_Date"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Last_Update",					dw_alt_serial_parent.GetItemDateTime(	Row_counter,"Last_Update"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Last_User",						dw_alt_serial_parent.GetItemString(		Row_counter,"Last_User"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "Serial_no_Child",				dw_alt_serial_parent.GetItemString(		Row_counter,"Serial_no_Child"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "do_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"do_line_item_No"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "ro_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"ro_line_item_No"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "TO_NO",							dw_alt_serial_parent.GetItemString(		Row_counter,"TO_NO"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "to_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row_counter,"to_line_item_No"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "sku_substitute",					dw_alt_serial_parent.GetItemString(	Row_counter,"sku_substitute"))
						dw_alt_serial_child.SetItem( li_inserted_row_number, "supplier_substitute",			dw_alt_serial_parent.GetItemString(	Row_counter,"supplier_substitute"))
					
						
						If  ( li_Total_Number_of_Children  -  1 )  >= 0 Then
								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_child", 		  li_Total_Number_of_Children  -  1)
								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_included", 	  li_Total_Number_of_Children  -  1)
						Else
								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_child", 		 0)
								dw_alt_serial_child.SetItem( li_inserted_row_number, "total_sku_qty_included", 	 0)
						End If


						li_sql_err_code = dw_alt_serial_child.Update( )
					
						If  li_sql_err_code < 0 Then  
							Execute Immediate "Rollback" using sqlca;
							MessageBox(" ","database error")
							return
						End If
					
					End If
			
				Next
			
				Execute Immediate "COMMIT" USING SQLCA;
			
				If NOT (  cb_generate.Enabled 							= FALSE and &
							cb_alt_serisl_capture_clear.Enabled 		= FALSE and &
							cb_print_parent_labels.Enabled 			= FALSE and &
							cb_save_parent_changes.Enabled 			= FALSE )  or &
							ibConfirmed = TRUE Then MessageBox( 'P/C Capture' ,' All Parent / Children Serialized! ' )
							
			 ii_ret = 1
						
			 For Row_Counter = 1 to dw_alt_serial_parent.RowCount()
				   dw_alt_serial_parent.SetItemStatus( Row_Counter, 0, Primary!, NotModified!)
			Next
			
			Else
			
				ii_Error_Row_Number     =  ll_Blank_serial_numbers
				is_Error_Error_Message  =  ' All Serial Numbers Must Be Specified Before Validating! ' 
				ib_alt_serial_error =True
				
				tab_main.tabpage_alt_serial_capture.SetFocus()
				dw_alt_serial_parent.TriggerEvent( 'ue_goback')

	         	return

			End If
			
		Else
					
			ii_Error_Row_Number     = 0
			is_Error_Error_Message  =  'No Parent Rows To Serialize! '
			ib_alt_serial_error =True
			
			dw_alt_serial_parent.TriggerEvent( 'ue_goback')
			
			return
	
		End If
	Else
		
		ii_Error_Row_Number     = 0
		is_Error_Error_Message  =  'Cannot save Invaid Data or Duplicate records!!'
		ib_alt_serial_error =True
		
		tab_main.tabpage_alt_serial_capture.SetFocus()
		dw_alt_serial_parent.TriggerEvent( 'ue_goback')

		 return
	
	End If
	
End If

Else 
	
	ii_ret = 1
	
End If
dw_alt_serial_parent.PostEvent( 'ue_redraw')
ib_Serial_Validated = TRUE
cb_alt_serisl_capture_clear.enabled 	= FALSE
cb_save_parent_changes.Enabled 		= FALSE

// Lockdown the serial number field if necessary.
f_lockserialnumber(lb_locked)						
							
// dw_alt_serial_parent.Modify("serial_no_parent.Protect=1")
ls_mod_string = "serial_no_parent.Background.Color =67108864	"
dw_alt_serial_parent.Modify( ls_mod_string )



end event

event ue_generate();Integer	Row_No, Qty_Row, Child_List_Row_No, li_message_return,li_row_count,li_no_of_parents, li_inserted_row_number, li_number_of_children, li_qty_of_parents_changed, li_default_serial_no_counter = 0

String		ls_generate_from_type, ls_serial_no, ls_default_serial_no, Is_serialized_indicator

Boolean Ib_serialized_parent

tab_main.tabpage_detail.dw_detail.ShareData(	tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail )

tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.SetFilter('serialized_ind = "B"')
tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.Filter()

If dw_alt_serial_parent.RowCount() > 0 Then
//	li_message_return = MessageBox("P/C Capture","You may only Generate Parent Rows Once.~r~rHowever, You May Delete All Parent Rows then ReGenerate.")
Else
	
	dw_alt_serial_parent.Reset()
	dw_alt_serial_child.Reset()
	
	CONNECT USING SQLCA;

	dw_alt_serial_parent.SetTransObject(SQLCA)
		
	This.SetRedraw(False) 
	
    If	dw_alt_serial_owner_change_detail.RowCount() > 0 Then
//		li_message_return = MessageBox("P/C Capture","Generating Parent Rows For Serialized Rows~rthat contain Serial Numbers and a Quantity of 1.")
	
		li_row_count= dw_alt_serial_owner_change_detail.RowCount()
	
		For Row_No = 1 to li_row_count
					
			Is_serialized_indicator =  dw_alt_serial_owner_change_detail.GetItemString(Row_No,"serialized_ind")
			
			IF Is_serialized_indicator = "B" Then
			
				li_qty_of_parents_changed = dw_alt_serial_owner_change_detail.GetItemNumber(Row_No,"quantity")
				If IsNull( li_qty_of_parents_changed ) or li_qty_of_parents_changed = 0 Then li_qty_of_parents_changed = 1
				 
				For Qty_Row = 1 to li_qty_of_parents_changed
								
					li_inserted_row_number = dw_alt_serial_parent.InsertRow(0)
					dw_alt_serial_parent.scrolltorow(li_inserted_row_number)
				
					li_number_of_children = 0

		     		tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.retrieve("PANDORA",dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"),"PANDORA")
					If tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.RowCount()  > 0 Then
						
						For Child_List_Row_No = 1 to tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.RowCount()
             		    	  		li_number_of_children =   li_number_of_children + tab_main.tabpage_alt_serial_capture.dw_alt_serial_child_list.GetItemNumber(Child_List_Row_No, "Child_qty")
						Next
					End If		
				  
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"supp_code_parent",			dw_alt_serial_owner_change_detail.GetItemString(Row_No,"supp_code"))
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"sku_parent",						dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
				
					ls_serial_no = dw_alt_serial_owner_change_detail.GetItemString(Row_No,"serial_no")
					
			 		If IsNull( ls_serial_no ) Then  ls_serial_no = " "
					 
					If ls_serial_no = " " or ls_serial_no = "-" Then
						
//						li_default_serial_no_counter =li_default_serial_no_counter  + 1
//						ls_default_serial_no = "MISSING" + String(li_default_serial_no_counter )

						ls_default_serial_no = " "
						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_parent",			ls_default_serial_no)
							
					Else
						
						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_parent",			ls_serial_no)
						
			 		End If
					 
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"alt_sku_parent",				dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"no_of_children_for_parent",	 li_number_of_children)

					dw_alt_serial_parent.SetItem(li_inserted_row_number,"supp_code_child",				dw_alt_serial_owner_change_detail.GetItemString(Row_No,"supp_code"))
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"sku_child",						dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
				
	
						 
					If ls_serial_no = " " or ls_serial_no = "-" Then
						
						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_child",			ls_default_serial_no)
						
					Else
						
						dw_alt_serial_parent.SetItem(li_inserted_row_number,"serial_no_child",			ls_serial_no)
						
			 		End If
			 
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"alt_sku_child",					dw_alt_serial_owner_change_detail.GetItemString(Row_No,"SKU"))
		
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"report_seq_child",				0)
					
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"total_sku_qty_child",			li_number_of_children)
					
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"missing_item_ind",				"N")
					
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"total_sku_qty_included",		li_number_of_children)
		
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"TO_NO",							dw_alt_serial_owner_change_detail.GetItemString(Row_No,"TO_No"))

//					dw_alt_serial_parent.SetItem(li_inserted_row_number,"to_line_item_No",				Row_No)
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"to_line_item_No",				dw_alt_serial_owner_change_detail.GetItemNumber(Row_No,"line_item_No"))			
   	 				dw_alt_serial_parent.SetItem(li_inserted_row_number,"create_date",					now())
					dw_alt_serial_parent.SetItem(li_inserted_row_number,"last_update",					now())
	    				dw_alt_serial_parent.SetItem(li_inserted_row_number,"last_user",	              		gs_userid)
				 
					dw_alt_serial_parent.SetRow(1)
					dw_alt_serial_parent.ScrollToRow(1)	
					dw_alt_serial_parent.SetColumn("serial_no_parent")	
					dw_alt_serial_parent.SelectText(1, Len(dw_alt_serial_parent.GetText()))
					dw_alt_serial_parent.SetFocus()
				
				Next
			End If
		Next
		
////		dw_alt_serial_child.TriggerEvent("ue_generate_child_list")
//		dw_alt_serial_child.TriggerEvent("ue_display_received_children")
//		
	Else
//		MessageBox("P/C Capture","No Serialized Rows Exist To Capture!")
	End If
End If

tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.SetFilter('1=1')
tab_main.tabpage_alt_serial_capture.dw_alt_serial_owner_change_detail.Filter()

dw_alt_serial_parent.SetRedraw( TRUE )
dw_alt_serial_child.SetRedraw( TRUE )
This.SetRedraw( TRUE ) 




end event

event ue_delete();Integer  Row_Number, li_number_of_children
String ls_filter_string, ls_current_parent_supp_code, ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no 	

If dw_alt_serial_parent.RowCount() > 0 Then
		
	li_number_of_children = dw_alt_serial_child.RowCount()

	For Row_Number = li_number_of_children to 1 Step -1
		
		 dw_alt_serial_child.DeleteRow(Row_Number)
		 
	Next
	
	dw_alt_serial_parent.DeleteRow(0)
	
    If dw_alt_serial_parent.RowCount() > 0  Then
	
		dw_alt_serial_child.SetFilter("")
		dw_alt_serial_child.Filter()

		If dw_alt_serial_child.RowCount() > 0 Then
			
			ls_current_parent_supp_code 	= dw_alt_serial_parent.GetItemString(1,"supp_code_parent")
			ls_current_parent_sku  			= dw_alt_serial_parent.GetItemString(1,"sku_parent") 	
			ls_current_parent_alt_sku 		= dw_alt_serial_parent.GetItemString(1,"alt_sku_parent") 
			ls_current_parent_serial_no 	= dw_alt_serial_parent.GetItemString(1,"serial_no_parent")
		
			ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
		                       	 '" and  sku_parent 		= "'+ ls_current_parent_sku+			&
							 	'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
								 '" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'

			dw_alt_serial_child.SetFilter(ls_filter_string)
			dw_alt_serial_child.Filter()
			dw_alt_serial_child.SetRow(1)
			dw_alt_serial_child.Setcolumn("serial_no_child")
			
	        
		End If
			
	     dw_alt_serial_parent.SetRow(1)
		 dw_alt_serial_parent.SetColumn("serial_no_parent")
		 dw_alt_serial_parent.SetFocus()
		 	
	End If
	

Else 
	 MessageBox("P/C Capture","No Parent Rows Exist to Delete.")
End If


end event

event uie_clear_children_for_current_parent();Integer	 	Child_Row_No,	 li_child_row_count, 	li_current_child_row	

SetPointer(HourGlass!)

dw_alt_serial_child.SetRedraw(FALSE)

li_current_child_row     = dw_alt_serial_child.GetRow()
li_child_row_count       = dw_alt_serial_child.RowCount()
	
If li_child_row_count > 0 Then
	
	For Child_Row_No = 1 to li_child_row_count
						
		dw_alt_serial_child.SetItem(Child_Row_No,"serial_no_child", " ")
		
	Next	

END iF

dw_alt_serial_child.SetRow(li_current_child_row)
dw_alt_serial_child.ScrollToRow(li_current_child_row)
dw_alt_serial_child.SetFocus()

dw_alt_serial_child.SetRedraw(TRUE)





end event

on tabpage_alt_serial_capture.create
this.cb_alt_serisl_capture_clear=create cb_alt_serisl_capture_clear
this.cb_generate=create cb_generate
this.cb_save_parent_changes=create cb_save_parent_changes
this.cb_print_parent_labels=create cb_print_parent_labels
this.dw_alt_serial_child_list=create dw_alt_serial_child_list
this.dw_soc_alt_serial_capture_save=create dw_soc_alt_serial_capture_save
this.dw_alt_serial_owner_change_detail=create dw_alt_serial_owner_change_detail
this.st_alt_serial_me=create st_alt_serial_me
this.dw_alt_serial_parent=create dw_alt_serial_parent
this.dw_alt_serial_child=create dw_alt_serial_child
this.Control[]={this.cb_alt_serisl_capture_clear,&
this.cb_generate,&
this.cb_save_parent_changes,&
this.cb_print_parent_labels,&
this.dw_alt_serial_child_list,&
this.dw_soc_alt_serial_capture_save,&
this.dw_alt_serial_owner_change_detail,&
this.st_alt_serial_me,&
this.dw_alt_serial_parent,&
this.dw_alt_serial_child}
end on

on tabpage_alt_serial_capture.destroy
destroy(this.cb_alt_serisl_capture_clear)
destroy(this.cb_generate)
destroy(this.cb_save_parent_changes)
destroy(this.cb_print_parent_labels)
destroy(this.dw_alt_serial_child_list)
destroy(this.dw_soc_alt_serial_capture_save)
destroy(this.dw_alt_serial_owner_change_detail)
destroy(this.st_alt_serial_me)
destroy(this.dw_alt_serial_parent)
destroy(this.dw_alt_serial_child)
end on

event ue_display_received_children();

dw_alt_serial_child.dataobject =  'd_soc_alt_serial_capture_from_putaway'
end event

event ue_clear();Integer li_Number_Of_Parent_Rows, li_Row_Counter
String ls_mod_string

dw_alt_serial_parent.SetRedraw( 		False 	)
dw_alt_serial_child.SetRedraw( 		False 	)

ls_mod_string = "serial_no_parent.Background.Color = "+string(RGB(255,255,255))+")"
dw_alt_serial_parent.Modify( ls_mod_string )

ib_Duplicated		= 	FALSE
ib_Invalid_Data		=	FALSE
ibSerialModified	= 	FALSE 

If idw_detail.Find( 	"Serialized_Ind = 'B'" ,1,idw_Detail.RowCount()) > 0 Then
	
	ib_Serialized           		= TRUE
	ib_Serial_Validated 		= FALSE
	w_owner_change.Title 	= is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo + '   CHANGING SERIALIZED COMPONENTS P/C CAPTURE REQUIRED!'
		
Else
			
	w_owner_change.Title = is_title + " - Edit    Order No: " + isOrderNo +  + "      SOC No: "  + isToNo

End If

SetNull( ii_Invalid_Data_Row_Number	)
SetNull( ii_Duplicate_Row_Number		)

 is_Duplicate_Error_Message		= ' '
 is_Invalid_Data_Error_Message	= ' '

dw_alt_serial_child.Reset()
dw_soc_alt_serial_capture_save.Reset()

li_Number_Of_Parent_Rows = dw_alt_serial_parent.RowCount()

If dw_alt_serial_parent.RowCount() > 0 Then

	For  li_Row_Counter = 1 to li_Number_Of_Parent_Rows
	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_parent", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "serial_no_child", ' ')	
		dw_alt_serial_parent.SetItem( li_Row_Counter, "DATASTATUS", ' ')	
	
	Next
	
	dw_alt_serial_parent.ScrollToRow(1)	
	dw_alt_serial_parent.SetRow(1)	
	dw_alt_serial_parent.SetColumn("serial_no_parent")			
	dw_alt_serial_parent.SelectText(1, 9999,1,1)
	dw_alt_serial_parent.SetFocus()
End If

cb_alt_serisl_capture_clear.enabled 	= FALSE
cb_print_parent_labels.Enabled         = FALSE
cb_save_parent_changes.Enabled     = FALSE

SetNull( ii_Duplicate_Row_Number		)
SetNull( ii_Invalid_Data_Row_Number	)

dw_alt_serial_parent.SetRedraw( 		True 	)
dw_alt_serial_child.SetRedraw( 		True 	)


end event

type cb_alt_serisl_capture_clear from commandbutton within tabpage_alt_serial_capture
integer x = 471
integer y = 28
integer width = 402
integer height = 92
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Clear"
end type

event clicked;Parent.TriggerEvent("ue_clear")
end event

type cb_generate from commandbutton within tabpage_alt_serial_capture
integer x = 27
integer y = 28
integer width = 402
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;ib_new_search =FALSE
Parent.TriggerEvent("ue_generate")
//Temp-DTS - 09/20/2010 - enabling the Serial field when a (new) order is generated....
tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Protect=0") //Temp-DTS
tab_main.tabpage_alt_serial_capture.dw_alt_serial_parent.Modify("serial_no_parent.Background.Color = " + string(RGB(255,255,255))+")") //Temp-DTS

cb_generate.Enabled = False		

end event

type cb_save_parent_changes from commandbutton within tabpage_alt_serial_capture
integer x = 1358
integer y = 28
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Validate"
end type

event clicked;tab_main.tabpage_alt_serial_capture.TriggerEvent("ue_save")

end event

type cb_print_parent_labels from commandbutton within tabpage_alt_serial_capture
integer x = 914
integer y = 28
integer width = 402
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Print  Labels"
end type

event clicked;Parent.TriggerEvent("ue_print_labels")

end event

type dw_alt_serial_child_list from u_dw_ancestor within tabpage_alt_serial_capture
event ue_load_item_values ( long alserialrow,  long alpickrow )
boolean visible = false
integer x = 37
integer y = 2044
integer width = 3250
integer height = 256
integer taborder = 90
string dataobject = "d_alt_serial_child_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
end type

type dw_soc_alt_serial_capture_save from u_dw_ancestor within tabpage_alt_serial_capture
event ue_load_item_values ( long alserialrow,  long alpickrow )
event ue_generate_child_list ( )
boolean visible = false
integer x = 23
integer y = 1612
integer width = 4041
integer height = 1012
integer taborder = 100
boolean titlebar = true
string title = "dw_soc_alt_serial_capture_save"
string dataobject = "d_do_alt_serial_capture_all_tono"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type dw_alt_serial_owner_change_detail from u_dw_ancestor within tabpage_alt_serial_capture
event ue_set_column ( )
event ue_create_bundled_parent ( )
event ue_set_row ( )
boolean visible = false
integer x = 137
integer y = 412
integer width = 2418
integer height = 528
integer taborder = 0
boolean titlebar = true
string title = "Stock Ownership Change Items"
string dataobject = "d_owner_change_detail_sn_version"
boolean vscrollbar = true
boolean resizable = true
end type

type st_alt_serial_me from statictext within tabpage_alt_serial_capture
integer x = 23
integer y = 252
integer width = 2912
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type dw_alt_serial_parent from u_dw_ancestor within tabpage_alt_serial_capture
event ue_load_item_values ( long alserialrow,  long alpickrow )
event ue_redraw ( )
event ue_goback ( integer gobacktorow )
event ue_row_focus_changed ( )
integer y = 140
integer width = 4247
integer height = 1376
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "Serialized Parents"
string dataobject = "d_do_alt_serial_capture_tono"
boolean vscrollbar = true
end type

event ue_redraw();dw_alt_serial_child.SetRedraw( 	TRUE )
dw_alt_serial_parent.SetRedraw( TRUE )
end event

event ue_goback(integer gobacktorow);String ls_Error_type


PostEvent( "ue_redraw")

If	ib_Duplicated  	 Then 

	dw_alt_serial_parent.SetRow(				ii_Duplicate_Row_Number	)	
	dw_alt_serial_parent.ScrollToRow(		ii_Duplicate_Row_Number	)	
	
	 ls_Error_type =  'DUPLICATE'
	dw_alt_serial_parent.SetItem(				ii_Duplicate_Row_Number,	'datastatus',  ls_Error_type	)
		
	MessageBox('P/C Capture', is_Duplicate_Error_Message )
	
End If

If	ib_Invalid_Data  	 Then 
	
	dw_alt_serial_parent.SetRow(				ii_Invalid_Data_Row_Number	)	
	dw_alt_serial_parent.ScrollToRow(		ii_Invalid_Data_Row_Number	)
	
	 ls_Error_type =  'INVALID'
	 dw_alt_serial_parent.SetItem(				ii_Duplicate_Row_Number,	'datastatus',  ls_Error_type	)
	
	MessageBox('P/C Capture', is_Invalid_Data_Error_Message )

End If


If	ib_alt_serial_error 	 Then 
	
	If  ii_Error_Row_Number > 0 Then 
		
		dw_alt_serial_parent.SetRow(				ii_Error_Row_Number 	)	
		dw_alt_serial_parent.ScrollToRow(		ii_Error_Row_Number 	)

	End if
	
	MessageBox('P/C Capture', is_Error_Error_Message )
	ib_alt_serial_error = False
	
End If

If  ib_selection_changing = FALSE Then
	
If gobacktorow<> 0 and  Not IsNull(  gobacktorow ) Then dw_alt_serial_parent.SetRow(	gobacktorow	)
dw_alt_serial_parent.SetColumn(	"serial_no_parent"		)	
dw_alt_serial_parent.SelectText(	1, Len(	dw_alt_serial_parent.GetText())	)
dw_alt_serial_parent.SetFocus()

End If


end event

event ue_row_focus_changed();
String ls_filter_string, ls_current_parent_supp_code, ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no 	
Integer li_curent_row,  li_Original_Children

dw_alt_serial_child.SetRedraw( FALSE )

If ib_processed_at_least_one and dw_alt_serial_parent.RowCount() > 0 and NOT ( ls_current_parent_serial_no = ' ' or IsNULL( ls_current_parent_serial_no ) ) Then
	
	dw_alt_serial_child.Reset()
		
	 If ib_new_search =FALSE Then 
		li_curent_row = dw_alt_serial_parent.GetRow()
	Else
		li_curent_row = 1
		 dw_alt_serial_parent.ScrollToRow(1)
	End If
	
	li_Original_Children	=	dw_alt_serial_parent.GetItemNumber(li_curent_row,"total_sku_qty_child")

	If li_Original_Children > 0 Then
	
		ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(li_curent_row,"supp_code_parent"))
		ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(li_curent_row,"sku_parent"))	
		ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(li_curent_row,"alt_sku_parent")) 
		ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(li_curent_row,"serial_no_child"))
	
		ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
		ls_current_parent_sku  			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
		ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
		ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
	
		ls_filter_string =	'Trim( supp_code_parent )	     = TRIM("'+ ls_current_parent_supp_code			+	&
		                    		'") and TRIM( sku_parent 	)		 = TRIM("'+ ls_current_parent_sku						+	&
								'") and TRIM( alt_sku_parent ) 		 = TRIM("'+ ls_current_parent_alt_sku				+	& 
								'") and TRIM( serial_no_parent )	 = TRIM( "' +ls_current_parent_serial_no+'")'
								
		dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
		dw_soc_alt_serial_capture_save.Filter()
			
		If dw_soc_alt_serial_capture_save.RowCount() > 0 Then 
	
			dw_alt_serial_child.Object.Data[1,1, dw_soc_alt_serial_capture_save.RowCount() , 25] =  &
						dw_soc_alt_serial_capture_save.Object.Data[1,1,dw_soc_alt_serial_capture_save.RowCount() ,25] 
						
			ls_filter_string = 	'1=1  '
			dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
			dw_soc_alt_serial_capture_save.Filter()		
			
			ls_filter_string = 	'NOT ( serial_no_parent = serial_no_child  )  '
			dw_alt_serial_child.SetFilter(ls_filter_string)
			dw_alt_serial_child.Filter()			
			
		Else
			ls_filter_string = 	'1=1  '
			dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
			dw_soc_alt_serial_capture_save.Filter()		
			
		End If
		
	End If
		
End If


dw_alt_serial_child.SetRedraw(    TRUE )
dw_alt_serial_parent.SetRedraw( TRUE )
end event

event constructor;call super::constructor;
This.SetRowFocusIndicator(Hand!)
end event

event itemchanged;call super::itemchanged;Integer 	Row_count, Row_Count_Child, Imposter_Row_Counter, li_no_of_children, li_current_parent_row, li_TO_Line_Item_No, li_Original_Children,li_inserted_row_number
String 	ls_current_parent_supp_code , ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no, ls_filter_string
String 	ls_imposter_parent_supp_code , ls_imposter_parent_sku, ls_imposter_parent_alt_sku, ls_imposter_parent_serial_no
String	 	ls_tono, ls_Last_User, ls_mod_string, ls_find_string
Long 		ll_Duplicated_Row_number
DateTime ldt_Create_Date, ldt_Last_Update


If ib_new_search = FALSE Then

PostEvent('ue_redraw')

dw_alt_serial_child.SetRedraw(FALSE)
dw_alt_serial_parent.SetRedraw(FALSE)
dw_alt_serial_child.Reset()
dw_alt_serial_child.SetFilter("")
dw_alt_serial_child.Filter()

ib_processed_at_least_one				= TRUE

If Trim(data) = '' or IsNull(data) Then 
			
	ib_alt_serial_error              =   FALSE
	ib_Duplicated		= 	FALSE
	ib_Invalid_Data		=	FALSE
	ibSerialModified	= 	FALSE

	SetNull( ii_Duplicate_Row_Number		)
	SetNull( ii_Invalid_Data_Row_Number	)

	 is_Duplicate_Error_Message		= ' '
	 is_Invalid_Data_Error_Message	= ' '
	 
	dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	' '	)

Else
	
	ls_TONO								= Upper(dw_alt_serial_parent.GetItemString(		row,"TO_NO"						))
	li_TO_Line_Item_No				= dw_alt_serial_parent.GetItemNumber(	row,"to_line_item_No"		)	

	ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		row,"supp_code_parent"			))
	ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		row,"sku_parent"						)) 	
	ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		row,"alt_sku_parent"				))
	ls_current_parent_serial_no 	= Upper(data)

// 10/17/10 - check that the serial # exists for the SKU/Owner....
long llOwner, llFindDetail
string lsOwner
ls_Find_string = "sku = '" + ls_current_parent_sku + "' and line_item_no = " + string(li_TO_Line_Item_no)
llFindDetail = idw_detail.find(ls_Find_string, 1, idw_detail.RowCount())
llOwner = idw_detail.GetItemNumber(llFindDetail, "Owner_ID")
select owner_cd into :lsOwner from serial_number_inventory
where project_id = 'PANDORA' and sku = :ls_current_parent_sku and owner_id = :llOwner
and serial_no = :data;
if lsOwner = "" then
	return 1
end if

	ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
	ls_current_parent_sku  			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
	ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
	ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))

	ldt_Create_Date					= 	dw_alt_serial_parent.GetItemDateTime(	row,"create_date"				)
	ldt_Last_Update					= 	dw_alt_serial_parent.GetItemDateTime(	row,"last_update"				)
	ls_Last_User						= 	Upper(dw_alt_serial_parent.GetItemString(		row,"last_user"					))

// Check for Duplicate Serial Numbers

//If youv'e gotten a Parent Before see if this one has the same credentials

	If dw_soc_alt_serial_capture_save.RowCount() > 0 Then

		ls_filter_string = 'supp_code_parent 		= "'+ ls_current_parent_supp_code+	&
		                	'" and  sku_parent 		= "'+ ls_current_parent_sku+			&
					  	'" and alt_sku_parent 		= "'+ ls_current_parent_alt_sku+		& 
					  	'" and serial_no_parent 	= "' +ls_current_parent_serial_no+'"'


		dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
		dw_soc_alt_serial_capture_save.Filter()

		If dw_soc_alt_serial_capture_save.RowCount() > 0 Then
		
			For Imposter_Row_Counter = 1 to dw_alt_serial_parent.RowCount()
				
				ls_imposter_parent_supp_code			= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"supp_code_parent"		))
				ls_imposter_parent_sku					= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"sku_parent"				)) 	
				ls_imposter_parent_alt_sku				= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"alt_sku_parent"			))
				ls_imposter_parent_serial_no			= Upper(dw_alt_serial_parent.GetItemString(Imposter_Row_Counter,"serial_no_parent"		)) 
			
				ls_imposter_parent_supp_code	  		=	ls_imposter_parent_supp_code	 	+ Fill( " ", 7 - 	Len( 	ls_imposter_parent_supp_code	 	))
				ls_imposter_parent_sku  				=	ls_imposter_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_imposter_parent_sku 				))
				ls_imposter_parent_alt_sku    			=	ls_imposter_parent_alt_sku			+ Fill( " ", 50 -	Len(	ls_imposter_parent_alt_sku 			))
				ls_imposter_parent_serial_no  			=	ls_imposter_parent_serial_no  		+ Fill( " ", 50 - 	Len( 	ls_imposter_parent_serial_no		))
	
				If 	ls_imposter_parent_supp_code		= ls_current_parent_supp_code 	and &
					ls_imposter_parent_sku				= ls_current_parent_sku 			and &
					ls_imposter_parent_alt_sku			= ls_current_parent_alt_sku 		and &
					ls_imposter_parent_serial_no		= ls_current_parent_serial_no 		and Imposter_Row_Counter <> row Then
		
					//   This ones an imposter			

					ls_find_string ='supp_code_parent= "' +  ls_current_parent_supp_code    + '"  and ' 		+  	&
										' sku_parent = "' +  ls_current_parent_sku			  	  + '"  and  '		+	&
										' alt_sku_parent = "' +  ls_current_parent_alt_sku 	  + '"  and  '		+	&
								         ' serial_no_parent	= "' +  ls_current_parent_serial_no + '"'
					
					ll_Duplicated_Row_number = dw_alt_serial_parent.Find( 	ls_find_string ,1, dw_alt_serial_parent.RowCount())
																									
       				If ll_Duplicated_Row_number = ROW  Then ll_Duplicated_Row_number = dw_alt_serial_parent.Find( 	ls_find_string,ROW+1, dw_alt_serial_parent.RowCount())
																									
					is_Duplicate_Error_Message = 'Duplicate Serial Numbers For Serial Number '+ Trim( ls_current_parent_serial_no ) +' ~r~r~r Found at Rows ' +string( ll_Duplicated_Row_number )+ ' and '+ string(row)+ &
										"~r~r~r parent_supp_code =  " 	+ ls_current_parent_supp_code	+ &
		               					"~r sku_parent            =  " 	+ ls_current_parent_sku				+ &
										"~r alt_sku_parent       =  "	+ ls_current_parent_alt_sku			+ &
										"~r serial_no_parent    =  "	+ ls_current_parent_serial_no
				
				
					ls_filter_string = 	'1 = 1'
					dw_soc_alt_serial_capture_save.SetFilter(		ls_filter_string	)
					dw_soc_alt_serial_capture_save.Filter()
				
					ii_Duplicate_Row_Number = row
					
					ib_Duplicated 		= 	TRUE
					ib_Invalid_Data		=	FALSE
	 
	 				dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	'DUPLICATE'	)
					
					PostEvent( "ue_goback("+STRING(ii_Duplicate_Row_Number)+ ")")
	
					return
		
				End If
			
			NEXT
		
		Else
		
//		Turn back on the previously filtered off SAVE records and continue
			ls_filter_string = 	'1 = 1'
			dw_soc_alt_serial_capture_save.SetFilter(		ls_filter_string	)
			dw_soc_alt_serial_capture_save.Filter()
	
		End If
	End If

//	THIS IS A PARENT WHO IS LOOKING FOR CHILDREN

	li_Original_Children	=	dw_alt_serial_parent.GetItemNumber(Row,"total_sku_qty_child")
	
	dw_alt_serial_child.ReSet()

	If li_Original_Children > 0 Then

//	If NOT a Duplicate Then Get Parent and Children to verify whether they have been Serialized before
	
		dw_alt_serial_child.Retrieve(	ls_current_parent_supp_code,  ls_current_parent_sku, 			&
														ls_current_parent_alt_sku, 		ls_current_parent_serial_no,	&	
														li_TO_Line_Item_No, 				ldt_Create_Date, 					&
														ldt_Last_Update,					ls_Last_User, ls_tono				)


//	During the retreive process the records for both the Parent and the parent's children were returrned

		If dw_alt_serial_child.RowCount() = 0 Then
		
// 	 If NO records were returned then not only is there no children But NO Parent exists either
// 	Tell the user that the Parent is invalid and return		
		
			is_Invalid_Data_Error_Message =  "Serial Number " +Trim(ls_current_parent_serial_no)+" is NOT Valid! ~r~r Row Number            = " + string(row)+ &
										"~r~r Parent Supplier       =  " 	+ Trim(ls_current_parent_supp_code) 	+	&
		               					"~r Parent  SKU            =  " 	+ 	Trim(ls_current_parent_sku)  			+	 &
										"~r Parent Alt SKU        =  "	+ Trim(ls_current_parent_alt_sku) 	+ &
										"~r Parent Serial No      =  "	+ Trim( ls_current_parent_serial_no)

			ii_Invalid_Data_Row_Number = row

			ib_Duplicated     	= FALSE
			ib_Invalid_Data 	= TRUE

			ls_filter_string = 	'1 = 2'
			dw_alt_serial_child.SetFilter(ls_filter_string)
			dw_alt_serial_child.Filter()
		
			dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	'INVALID'	)

		
			PostEvent( "ue_goback("+STRING(ii_Invalid_Data_Row_Number)+ ")")
		
			return
	
		Else
	
// 		Otherwise, If a record(s) was/were returned then seperate the Parent from the children
//		and display the children for everyone to see
	
// 		 Here we save the information to a Save Datawindow so that we dont have to retreive it ever again 
// 		Also, the information saved here is used during the save process 

			If dw_soc_alt_serial_capture_save.RowCount() > 0 Then 

				dw_soc_alt_serial_capture_save.Object.Data[dw_soc_alt_serial_capture_save.RowCount() + 1,1, dw_soc_alt_serial_capture_save.RowCount() + dw_alt_serial_child.RowCount(), 25] &
							= dw_alt_serial_child.Object.Data[1,1, dw_alt_serial_child.RowCount(), 25]
		
			Else
		
				dw_soc_alt_serial_capture_save.Object.Data[ 1,1, dw_alt_serial_child.RowCount(), 25]&
							= dw_alt_serial_child.Object.Data[1,1, dw_alt_serial_child.RowCount(), 25]
				
			End If
	
	//	 Seperate the Parent from the display of children

			ls_filter_string = 	'NOT ( serial_no_parent = serial_no_child  )  '
			dw_alt_serial_child.SetFilter(ls_filter_string)
			dw_alt_serial_child.Filter()
	
		End If
		
	Else
			dw_alt_serial_child.Reset()
						
			li_inserted_row_number =dw_soc_alt_serial_capture_save.InsertRow(0)
			dw_soc_alt_serial_capture_save.scrolltorow(li_inserted_row_number)
						
			ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(		Row,"supp_code_parent"			))
			ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(		Row,"sku_parent"					)) 	
			ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(		Row,"alt_sku_parent"				))
			ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(		Row,"serial_no_parent"			))

			ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
			ls_current_parent_sku			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
			ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
			ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
	
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "no_of_children_for_parent", 0)
						
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Supp_Code_Parent",			dw_alt_serial_parent.GetItemString(		Row,"supp_code_parent"	))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "SKU_Parent",					dw_alt_serial_parent.GetItemString(		Row,"SKU_Parent"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Alt_SKU_Parent",				dw_alt_serial_parent.GetItemString(		Row,"Alt_SKU_Parent"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Serial_no_Parent",				dw_alt_serial_parent.GetItemString(		Row,"Serial_no_Parent"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "No_of_Children_for_parent",dw_alt_serial_parent.GetItemNumber(	Row,"No_of_Children_for_parent"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Supp_Code_Child",			dw_alt_serial_parent.GetItemString(		Row,"Supp_Code_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "SKU_Child",						dw_alt_serial_parent.GetItemString(		Row,"SKU_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Alt_SKU_Child",					dw_alt_serial_parent.GetItemString(		Row,"Alt_SKU_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Report_Seq_Child",			dw_alt_serial_parent.GetItemNumber(	Row, "Report_Seq_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Total_SKU_Qty_Child",		dw_alt_serial_parent.GetItemNumber(	Row,"Total_SKU_Qty_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Missing_Item_Ind",			dw_alt_serial_parent.GetItemString(		Row,"Missing_Item_Ind"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Total_SKU_Qty_Included",	dw_alt_serial_parent.GetItemNumber(	Row,"Total_SKU_Qty_Included"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Ro_No",							dw_alt_serial_parent.GetItemString(		Row,"Ro_No"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Do_No",							dw_alt_serial_parent.GetItemString(		Row, "Do_No"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Create_Date",					dw_alt_serial_parent.GetItemDateTime(	Row,"Create_Date"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Last_Update",					dw_alt_serial_parent.GetItemDateTime(	Row,"Last_Update"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Last_User",						dw_alt_serial_parent.GetItemString(		Row,"Last_User"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "Serial_no_Child",				dw_alt_serial_parent.GetItemString(		Row,"Serial_no_Child"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "do_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"do_line_item_No"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "ro_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"ro_line_item_No"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "TO_NO",							dw_alt_serial_parent.GetItemString(		Row,"TO_NO"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "to_line_item_No",				dw_alt_serial_parent.GetItemNumber(	Row,"to_line_item_No"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "total_sku_qty_child", 		 	0)
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "total_sku_qty_included", 		0)
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "sku_substitute",					dw_alt_serial_parent.GetItemString(	Row,"sku_substitute"))
			dw_soc_alt_serial_capture_save.SetItem( li_inserted_row_number, "supplier_substitute",			dw_alt_serial_parent.GetItemString(	Row,"supplier_substitute"))			
	End If

// 	Load the entered serial number into the Parent record and Upper Case it so that all data matches

	dw_alt_serial_parent.SetItem(row,"serial_no_parent",Upper(data))	
	dw_alt_serial_parent.SetItem(row,"serial_no_child",Upper(data))	

	dw_alt_serial_parent.SetRow(row)	
	dw_alt_serial_parent.ScrollToRow(row)	
	dw_alt_serial_parent.SetColumn("serial_no_parent")	
	dw_alt_serial_parent.SelectText(1, Len(	dw_alt_serial_parent.GetText()))
	dw_alt_serial_parent.SetFocus()
	
	ib_alt_serial_error 			= FALSE
	ib_Duplicated					= FALSE
	ib_Invalid_Data					= FALSE
	ibSerialModified				= TRUE
		
     cb_alt_serisl_capture_clear.enabled  	= TRUE
     cb_print_parent_labels.enabled         = TRUE
     cb_save_parent_changes.enabled		= TRUE
	  
	 dw_alt_serial_parent.SetItem(				ii_Invalid_Data_Row_Number,	'DATASTATUS',	' '	)

End If

End IF
end event

event rowfocuschanged;call super::rowfocuschanged;
this.TriggerEvent( "ue_row_focus_changed")

//
//String ls_filter_string, ls_current_parent_supp_code, ls_current_parent_sku, ls_current_parent_alt_sku, ls_current_parent_serial_no 	
//
//
//If  ib_selection_changing = FALSE Then
// 
//dw_alt_serial_child.SetRedraw( FALSE )
//
//If ib_processed_at_least_one and dw_alt_serial_parent.RowCount() > 0 and NOT ( ls_current_parent_serial_no = ' ' or IsNULL( ls_current_parent_serial_no ) ) Then
//	
//	dw_alt_serial_child.Reset()
//	
//	ls_current_parent_supp_code 	= Upper(dw_alt_serial_parent.GetItemString(currentrow,"supp_code_parent"))
//	ls_current_parent_sku  			= Upper(dw_alt_serial_parent.GetItemString(currentrow,"sku_parent"))	
//	ls_current_parent_alt_sku 		= Upper(dw_alt_serial_parent.GetItemString(currentrow,"alt_sku_parent")) 
//	ls_current_parent_serial_no 	= Upper(dw_alt_serial_parent.GetItemString(currentrow,"serial_no_child"))
//	
//	ls_current_parent_supp_code   = ls_current_parent_supp_code 	+ Fill( " ", 7 - 	Len( 	ls_current_parent_supp_code 	))
//	ls_current_parent_sku  			= ls_current_parent_sku  			+ Fill( " ", 50 -	Len( 	ls_current_parent_sku 			))
//	ls_current_parent_alt_sku  		= ls_current_parent_alt_sku  		+ Fill( " ", 50 - 	Len( 	ls_current_parent_alt_sku 		))
//	ls_current_parent_serial_no     = ls_current_parent_serial_no		+ Fill( " ", 50 -	Len(	ls_current_parent_serial_no 	))
//
//		ls_filter_string =	'Trim( supp_code_parent )	     = TRIM("'+ ls_current_parent_supp_code			+	&
//		                    		'") and TRIM( sku_parent 	)		 = TRIM("'+ ls_current_parent_sku						+	&
//								'") and TRIM( alt_sku_parent ) 		 = TRIM("'+ ls_current_parent_alt_sku				+	& 
//								'") and TRIM( serial_no_parent )	 = TRIM( "' +ls_current_parent_serial_no+'")'
//								
//	dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//	dw_soc_alt_serial_capture_save.Filter()
//			
//	If dw_soc_alt_serial_capture_save.RowCount() > 0 Then 
//
//			dw_alt_serial_child.Object.Data[1,1, dw_soc_alt_serial_capture_save.RowCount() , 23] =  &
//						dw_soc_alt_serial_capture_save.Object.Data[1,1,dw_soc_alt_serial_capture_save.RowCount() ,23] 
//						
//			ls_filter_string = 	'1=1  '
//			dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//			dw_soc_alt_serial_capture_save.Filter()		
//			
//			ls_filter_string = 	'NOT ( serial_no_parent = serial_no_child  )  '
//			dw_alt_serial_child.SetFilter(ls_filter_string)
//			dw_alt_serial_child.Filter()			
//			
//	Else
//			ls_filter_string = 	'1=1  '
//			dw_soc_alt_serial_capture_save.SetFilter(ls_filter_string)
//			dw_soc_alt_serial_capture_save.Filter()		
//			
//	End If
//		
//End If
//
//
//dw_alt_serial_child.SetRedraw(    TRUE )
//dw_alt_serial_parent.SetRedraw( TRUE )
//
//End If
end event

event rowfocuschanging;call super::rowfocuschanging;String ls_data


If  ib_selection_changing = FALSE Then
	
If ib_processed_at_least_one Then
	
	dw_alt_serial_parent.SetRedraw(FALSE)	
	dw_alt_serial_child.SetRedraw(FALSE)	

	If ib_Duplicated = TRUE Then 
		PostEvent("ue_goback")
		PostEvent("ue_redraw")
		return 1
	End If

	If ib_Invalid_Data = TRUE Then 
		PostEvent("ue_goback")
		PostEvent("ue_redraw")
		return 1
	End If

	If ib_alt_serial_error	= TRUE Then	
	
		dw_alt_serial_parent.SetRow(currentrow)	
		PostEvent("ue_goback")
		PostEvent("ue_redraw")
		return 1
	
	Else 

		dw_alt_serial_parent.SetItem( currentrow,	'DATASTATUS',	' '	)

		PostEvent("ue_redraw")
		return 0
	End If
	
End If
End IF
end event

event itemfocuschanged;call super::itemfocuschanged;
//If  ib_selection_changing = FALSE Then
//
//If ib_processed_at_least_one Then
//	
//	PostEvent("ue_redraw")
//	dw_alt_serial_parent.SetRow(row)
//	
//End If
//
//End IF
end event

event clicked;call super::clicked;  ib_new_search =FALSE

If Trim(String(Describe("serial_no_parent.Background.Color" ))) = "67108864" Then
	If This.GetClickedRow() > 0  Then This.ScrollToRow(  This.GetClickedRow() )
	PostEvent("ue_row_focus_changed")
End If
end event

event itemerror;call super::itemerror;messagebox("SOC Serial Scan", "Serial number (" + Data + ") does not exist for given SKU/Owner")
return 1

end event

type dw_alt_serial_child from u_dw_ancestor within tabpage_alt_serial_capture
event ue_load_item_values ( long alserialrow,  long alpickrow )
event ue_generate_child_list ( )
integer y = 1564
integer width = 4242
integer height = 1148
integer taborder = 0
boolean bringtotop = true
boolean titlebar = true
string title = "Serialized Children"
string dataobject = "d_soc_alt_serial_capture_from_putaway"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;this.SetRow(This.GetClickedRow())
this.SetFocus()
end event

event constructor;call super::constructor;
This.SetRowFocusIndicator(Hand!)
end event

type dw_report from datawindow within w_owner_change
boolean visible = false
integer x = 3584
integer y = 428
integer width = 494
integer height = 364
string dataobject = "d_tran_report"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

