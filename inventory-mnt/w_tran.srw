HA$PBExportHeader$w_tran.srw
$PBExportComments$*+  warehouse transfer
forward
global type w_tran from w_std_master_detail
end type
type rb_replenishment from radiobutton within tabpage_main
end type
type st_itemcount from statictext within tabpage_main
end type
type rb_containerid from radiobutton within tabpage_main
end type
type rb_pono2 from radiobutton within tabpage_main
end type
type rb_pono from radiobutton within tabpage_main
end type
type rb_sku from radiobutton within tabpage_main
end type
type dw_sku from datawindow within tabpage_main
end type
type cb_import_sku from commandbutton within tabpage_main
end type
type cb_clear_gen from commandbutton within tabpage_main
end type
type cb_generate from commandbutton within tabpage_main
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
type sle_count from singlelineedit within tabpage_main
end type
type dw_generate from datawindow within tabpage_main
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
type dw_mobile from u_dw_ancestor within tabpage_detail
end type
type cb_serial from commandbutton within tabpage_detail
end type
type cb_copyrow from commandbutton within tabpage_detail
end type
type p_arrow from picture within tabpage_detail
end type
type cb_xferall from commandbutton within tabpage_detail
end type
type cb_reset from commandbutton within tabpage_detail
end type
type cb_replenish from commandbutton within tabpage_detail
end type
type cb_insert from commandbutton within tabpage_detail
end type
type cb_delete from commandbutton within tabpage_detail
end type
type dw_detail_content from u_dw_ancestor within tabpage_detail
end type
type dw_content from u_dw_ancestor within tabpage_detail
end type
type dw_detail from u_dw_ancestor within tabpage_detail
end type
type tabpage_detail from userobject within tab_main
dw_mobile dw_mobile
cb_serial cb_serial
cb_copyrow cb_copyrow
p_arrow p_arrow
cb_xferall cb_xferall
cb_reset cb_reset
cb_replenish cb_replenish
cb_insert cb_insert
cb_delete cb_delete
dw_detail_content dw_detail_content
dw_content dw_content
dw_detail dw_detail
end type
type dw_report from datawindow within w_tran
end type
end forward

global type w_tran from w_std_master_detail
integer width = 3961
integer height = 2256
string title = "Stock Transfer"
event ue_confirm ( )
event ue_deleterow ( )
event ue_search ( )
event ue_pick_pallet ( )
event ue_move_pallet ( )
event ue_pick_mixed ( )
dw_report dw_report
end type
global w_tran w_tran

type variables
Datawindow   idw_main, idw_search,idw_result, idw_mobile
Datawindow idw_detail,idw_content,idw_dcontent

Datawindow idw_transfer_detail_content_append		//s22208
Datawindow idw_transfer_detail_content

u_ds_ancestor idsContent
u_ds_ancestor idsContentSummary

SingleLineEdit isle_code
String is_org_sql,isFromLocSql,istoLocSql, isFromLocContSql
w_tran iw_window
datawindowchild idwc_det_supplier
n_warehouse i_nwarehouse
boolean ibSplitContainerRequired
boolean ib_transfer_from_first
boolean ib_transfer_to_first
boolean ib_complete_from_first
boolean ib_complete_to_first
boolean ib_error , ibFWDPickPending
// pvh 09/16/05
datastore idsFromLocations, idsFromLocationsContainer
long ilOwnerid
string isOrderNo
long colorMint

string isOrderStatus
string isToNo
string isWarehouse

//constant integer success = 0
//constant integer failure = -1

inet	linit
u_nvo_websphere_post	iuoWebsphere

boolean ib_is_pandora_single_project_location_rule_on
boolean ibFootprintAlloc

string isPallet, isContainer, isWhCode, isinvoice_no, isColorCode, isMixedType	, isLocation	//S22208
int ilCurrPickRow
Boolean ibPharmacyProcessing		//GailM 12/02/2019 Add check for Pharmacy Processing

end variables

forward prototypes
public subroutine wf_clear_screen ()
public function integer wf_validation ()
public subroutine wf_checkstatus ()
public function integer wf_update_content ()
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
public function integer wf_generate_detail ()
public function integer wf_check_status_mobile ()
public function string wf_validate_single_project_rule (string as_l_code, long al_row)
public function integer wf_check_toloc_cc (string assku, string assuppcode, string astoloc)
public function integer wf_sku_tracked_by_validation ()
public function integer wf_check_full_pallet_container ()
end prototypes

event ue_deleterow();// ue_deleterow()
int returncode
long test

f_method_trace_special( gs_project, this.ClassName() + ' - ue_deleterow', 'Start ue_deleterow:' + string(idw_detail.getrow()) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

//09/15 - PCONKL - Can't delete a row if the content has already been created or certain mobile statuses
If idw_detail.GetITemString(idw_detail.getrow(),'Content_Record_Created_ind') = 'Y' Then
	MessageBox('Delete Row','Inventory has already been released for this Transfer Row.~rIt can not be deleted!',Stopsign!)
	Return
End If
	
returncode = idw_detail.deleterow( idw_detail.getrow() )
test = idw_detail.deletedcount()

if idw_detail.rowcount() = 0 then event ue_delete()
end event

event ue_search();// ue_search

end event

event ue_pick_pallet();//GailM 8/6/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers

String lsSKU, lsFind, lsFilter, lsLocation
Int liRow, liFound, liRC
Long llReqQty
Datastore ldsFromPallet, ldsToPallet, ldsTranDetail
Str_parms	lstrParms

ldsFromPallet = Create datastore
ldsFromPallet.dataobject = 'd_pick_pallet'
ldsFromPallet.SetTransObject(SQLCA)

ldsToPallet = Create datastore
ldsToPallet.dataobject = 'd_pick_pallet'
ldsToPallet.SetTransObject(SQLCA)

ldsTranDetail = Create datastore
ldsTranDetail.dataobject = 'd_tran_detail'
ldsTranDetail.SetTransObject(SQLCA)

liRC = idw_detail.Rowscopy( ilCurrPickRow, ilCurrPickRow, Primary!, ldsTranDetail, 2, Primary!)
lsSKU = idw_detail.GetItemString(ilCurrPickRow, "SKU" )
llReqQty = idw_detail.GetItemNumber( ilCurrPickRow, "quantity" )
//GailM 1/9/2020 DE14138 Google - Application crashes on ST
lsLocation = idw_detail.GetItemString(ilCurrPickRow,'s_location') + "/" + idw_detail.GetItemString(ilCurrPickRow,'d_location') 

ldsFromPallet.Retrieve( isPallet )
lsFilter = "carton_id = '" + isContainer + "' "
ldsFromPallet.SetFilter( lsFilter )
ldsFromPallet.filter( )

	lstrparms.String_Arg[1] = isPallet
	lstrparms.String_Arg[2] = isContainer
	lstrparms.String_Arg[3] = isinvoice_no
	lstrparms.String_Arg[4] = isWhCode
	lstrparms.String_Arg[5] = 'StockTransfer'			//Order type Stock Transfer
	lstrparms.String_Arg[6] = isColorCode
	lstrparms.String_Arg[7] = isMixedType
	lstrparms.String_Arg[8] = lsLocation

	lstrparms.integer_arg[1] = ilCurrPickRow
	lstrparms.Boolean_arg[1] = ibPharmacyProcessing
	lstrparms.Long_Arg[1] = llReqQty
	lstrparms.Long_arg[2] = idw_detail.GetItemNumber(ilCurrPickRow, "quantity")	// DE12642
	lstrparms.Datastore_Arg[1] = ldsFromPallet
	lstrparms.Datastore_Arg[2] = ldsToPallet
	lstrparms.Datastore_Arg[3] = ldsTranDetail
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
//GailM 1/9/2020 DE14138 Google - Application crashes on ST
lsLocation = idw_detail.GetItemString(ilCurrPickRow,'s_location') + "/" + idw_detail.GetItemString(ilCurrPickRow,'d_location') 
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

ldsFromPallet.Retrieve(gs_Project,isWhCode,lsSKU,isPallet,isContainer,idw_detail.GetItemString(ilCurrPickRow,'s_location'))	

ldsToPallet = Create datastore
ldsToPallet.dataobject = 'd_pick_mixed'
ldsToPallet.SetTransObject(SQLCA)

ldsTranDetail = Create datastore
ldsTranDetail.dataobject = 'd_tran_detail'
ldsTranDetail.SetTransObject(SQLCA)

idw_detail.Rowscopy( ilCurrPickRow, ilCurrPickRow, Primary!, ldsTranDetail, 2, Primary!)

lstrparms.String_Arg[1] = isPallet
lstrparms.String_Arg[2] = isContainer
lstrparms.String_Arg[3] = isinvoice_no
lstrparms.String_Arg[4] = isWhCode
lstrparms.String_Arg[5] = 'StockTransfer'
lstrparms.String_Arg[6] = lsColorCode
lstrparms.String_Arg[7] = lsMixedType
lstrparms.String_Arg[8] = lsLocation
lstrparms.integer_arg[1] = ilCurrPickRow
lstrparms.Boolean_arg[1] = ibPharmacyProcessing
lstrparms.Long_Arg[1] = llReqQty
lstrparms.Long_Arg[2] = idw_detail.GetItemNumber(ilCurrPickRow, "quantity")	// DE12642
lstrparms.Datastore_Arg[1] = ldsFromPallet
lstrparms.Datastore_Arg[2] = ldsToPallet
lstrparms.Datastore_Arg[3] = ldsTranDetail
lstrparms.Datawindow_Arg[1] = idw_detail
lstrparms.Datawindow_Arg[2] = idw_dcontent

OpenWithParm(w_pick_pallet, lstrparms)

//lstrReturnParms = Message.PowerobjectParm

ldsFromPallet = lstrparms.Datastore_Arg[1]
ldsToPallet = lstrparms.Datastore_Arg[2]
lbCancelled = lstrparms.cancelled

If lbCancelled Then
	messagebox("Cancelled","The process has been cancelled.")
End If


end event

public subroutine wf_clear_screen ();idw_main.Reset()
idw_detail.reset()

tab_main.tabpage_main.cb_confirm.enabled = False
tab_main.tabpage_detail.Enabled = False
tab_main.tabpage_main.cb_generate.visible = False
tab_main.tabpage_main.cb_clear_gen.visible = False
tab_main.tabpage_main.cb_import_sku.visible = False

//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer-START
tab_main.tabpage_main.rb_sku.visible=False
tab_main.tabpage_main.rb_pono.visible =False
tab_main.tabpage_main.rb_pono2.visible =False
tab_main.tabpage_main.rb_replenishment.visible =False //TAM 2018/05 - S19741
//TimA 11/24/14 Pandora issue #859
tab_main.tabpage_main.rb_containerid.visible =False
tab_main.tabpage_main.sle_count.Visible=False
tab_main.tabpage_main.st_ItemCount.Visible=False
//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer -END

tab_main.SelectTab(1) 
idw_main.Hide()

tab_main.tabpage_main.dw_generate.Hide()
tab_main.tabpage_main.dw_sku.hide()

isle_code.Text = ""

// pvh 09/16/05
setQtyAllDisplay( true )

Return

end subroutine

public function integer wf_validation ();string ls_dwhcode, ls_dlcode, ls_lcode, ls_swhcode, ls_slcode,ls_sku, lsMobileStatus
string ls_sno,ls_lno
string ls_itype,ls_sku1,ls_tono,ls_supp,ls_po,ls_po2
string ls_container_ID    //GAP 11/02 added here
long i,ll_own, llCount
decimal ld_qty,ld_quantity,ld_qty1 // GAP 11/02 changed from long to decimal
datetime ldt_expiration_date  //GAP 11/02 added here

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

SetMicroHelp("Checking required fields...")
//Check required fields for master record
if f_check_required(is_title,idw_main) = -1 then
	tab_main.SelectTab(1)
	return -1
end if

if f_check_required(is_title,idw_detail) = -1 then
	tab_main.SelectTab(2)
	return -1
end if

f_method_trace_special( gs_project, this.ClassName() + ' - wf_Validation', 'Start wf_validation:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

ls_dwhcode = idw_main.getitemstring(1,'d_warehouse')
ls_swhcode = idw_main.getitemstring(1,'s_warehouse')

f_method_trace_special( gs_project, this.ClassName() + ' - wf_validation', 'Process wf_validation:' + 'From WH :'+ ls_swhcode + '- ToWH: '+ ls_dwhcode,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		


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
	
	lsMobileStatus = idw_detail.getitemstring(i,'mobile_status_Ind')
	if isnull(lsMobileStatus) Then lsMobileStatus = ''
	
	ld_quantity = idw_detail.getitemnumber(i,'quantity')
	
	// 09/15 - PCONKL - Add validation fo Inv Type
	IF isnull(ls_itype) or ls_itype = "" THEN 
		 MessageBox(is_title,"Inventory Type missing in row " + string( i ) + ", please check!",StopSign!)
		 tab_main.selecttab(4)
		 f_setfocus(idw_detail, i, "inventory_type")
		 return -1
	END IF	 
	
	IF isnull(ld_quantity) or ld_quantity = 0 THEN 
		 MessageBox(is_title,"Quantity is missing or invalid in row " + string( i ) + ", please check!",StopSign!)
		 tab_main.selecttab(4)
		 f_setfocus(idw_detail, i, "sku")
		 return -1
	END IF	 
	
	//TimA Commend out 08/06/14
	//f_method_trace_special( gs_project, this.ClassName() + ' - wf_validation', 'Process wf_Validation:' + 'Sku :'+ ls_sku &
	//	+ ' - supp_code: ' + ls_supp + ' - FromLoc: ' + ls_slcode + ' -ToLoc: ' + ls_dlcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_po &
	//	+ '	 - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm')  &
	//	+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype + '- Qty: ' + string(ld_quantity),isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
	
	// check location code 	
	// 09/15 - PCONKL - MObile might have created the transfer with a "*" for a Dest Location until assigned on device. Don't validate if pending on Mobile
	If ls_dlcode =  "*" and ( lsMobileStatus = "N"  or lsMobileStatus = "P"   or lsMobileStatus = "B"  or lsMobileStatus = "X"  or lsMobileStatus = "S" or lsMobileStatus = "1" ) Then
		
	Else
		
		select l_code into :ls_lcode from location 
		where wh_code = :ls_dwhcode and l_code = :ls_dlcode;
		
		if sqlca.sqlcode <> 0 then
			messagebox(is_title,'Invalid destination location!',StopSign!)
			tab_main.SelectTab(2)
			f_setfocus(idw_detail, i, "d_location")
			return -1
		end if
		
	End If
	
	select l_code into :ls_lcode from location 
		where wh_code = :ls_swhcode and l_code = :ls_slcode;
		
	if sqlca.sqlcode <> 0 then
		messagebox(is_title,'Invalid source location!',StopSign!)
		tab_main.SelectTab(2)
		f_setfocus(idw_detail, i, "s_location")
		return -1
	end if
	
	Select Count(*) into :llCount
	from Item_MAster
	where sku = :ls_sku and project_id = :gs_project;
	
	If llCount < 1 Then
		messagebox(is_title,'Invalid SKU!',StopSign!)
		tab_main.SelectTab(2)
		f_setfocus(idw_detail, i, "SKU")
		return -1
	end if
	
	//08-Apr-2017 Madhu PEVS-461 Validate ToLoc is in Cycle Count - START
	If upper(gs_project) ='PANDORA' and wf_check_toloc_cc(ls_sku, ls_supp, ls_dlcode) > 0 then
		messagebox(is_title, " To Location for the Stock Transfer is currently in Cycle Count")
		tab_main.selecttab( 2)
		f_setfocus(idw_detail, i, "d_location")
		return -1
	end if
	//08-Apr-2017 Madhu PEVS-461 Validate ToLoc is in Cycle Count - END
	
next

//19-Jan-2018 :Madhu S15155 - Foot Prints
If upper(gs_project) ='PANDORA' and wf_sku_tracked_by_validation() < 0 Then Return -1

//Needed to create seperate loop for this.
//Would re-order rows and caused the null quantity issue because for some reason re-sorted after filter.

for i = 1 to idw_detail.rowcount()
	
	// pvh - 09/21/05
	if checkforDuplicates( i ) then
		Messagebox(is_title,"Found duplicate Transfer list item in row " + string( i ) + ", please check!",StopSign!)
		return -1
	end if
	
next

//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
If upper(gs_project) ='PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" and isOrderStatus = 'P' Then
	wf_check_full_pallet_container()		//Check and report partial container pick but do not stop
End If
f_method_trace_special( gs_project, this.ClassName() + ' - wf-validation', 'End wf_validation:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		


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
lstr_parms.string_arg2[i]="transfer_detail_new_inventory_type";i++	// LTK 20150915
lstr_parms.string_arg2[i]="container_ID";i++  //GAP 11/02 
lstr_parms.string_arg2[i]="expiration_date";i++ //GAP 11/02



Choose Case idw_main.GetItemString(1,"ord_status")
		
	Case "N" /*New*/

		idw_main.Object.s_warehouse.Protect='0'
		idw_main.Object.user_field2.Protect='0'
		idw_main.Object.s_warehouse.Background.Color= rgb( 255,255,255 )

		tab_main.tabpage_detail.cb_replenish.Visible = False
		tab_main.tabpage_detail.cb_insert.Enabled = True
		tab_main.tabpage_detail.cb_delete.Enabled = True
		tab_main.tabpage_detail.cb_reset.Enabled = True
		tab_main.tabpage_detail.cb_serial.Enabled = False /* 12/13 - PCONKL*/
		
		tab_main.tabpage_main.cb_confirm.Enabled = False
		if ib_edit then
			tab_main.tabpage_main.cb_void.Enabled = True
		else
			tab_main.tabpage_main.cb_void.Enabled = False
		end if
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = False
		if ib_edit then
			im_menu.m_record.m_delete.Enabled = True
		else
			im_menu.m_record.m_delete.Enabled = false
		end if

      i_nwarehouse.of_settab(idw_main,lstr_parms,1)
		i_nwarehouse.of_settab(idw_detail,lstr_parms,2)
		
		// 11/11 - PCONKL
		tab_main.tabpage_main.dw_generate.visible = True
		tab_main.tabpage_main.dw_sku.visible = True
		tab_main.tabpage_main.cb_generate.visible = True
		tab_main.tabpage_main.cb_clear_gen.visible = True
		tab_main.tabpage_main.cb_import_sku.visible = True
		tab_main.tabpage_main.cb_import_sku.BringToTop = True
		tab_main.tabpage_main.cb_generate.BringToTop = true
		tab_main.tabpage_main.cb_clear_gen.BringToTop = true
		
		//17-Oct-2014 :Madhu- Honda- Visible of selected fileds for Import Transfer-START
		tab_main.tabpage_main.rb_sku.visible=True
		tab_main.tabpage_main.rb_pono.visible =True
		tab_main.tabpage_main.rb_pono2.visible =True
	//TAM 2018/05 - S19741 - Pandora uses custom transfer logic
		If gs_project = 'PANDORA' Then 
			tab_main.tabpage_main.rb_replenishment.visible =False
		Else
			tab_main.tabpage_main.rb_replenishment.visible =True 
		End If
		//TimA 11/24/14 Pandora issue #859
		tab_main.tabpage_main.rb_containerid.visible =True
		tab_main.tabpage_main.sle_count.Visible=True
		tab_main.tabpage_main.st_ItemCount.Visible=True
		//17-Oct-2014 :Madhu- Honda- Visible of selected fileds for Import Transfer -END
		
	
	setQtyAllDisplay( true )

	Case "P" /*Process*/
		
		// pvh
		idw_main.Object.s_warehouse.Background.Color= getColorMint()
		idw_main.Object.s_warehouse.Protect='1'
		idw_main.Object.user_field2.Protect='1'
		
		tab_main.tabpage_detail.cb_replenish.Visible = FAlse
		tab_main.tabpage_detail.cb_insert.Enabled = True
		tab_main.tabpage_detail.cb_delete.Enabled = True
		tab_main.tabpage_detail.cb_reset.Enabled = True
		tab_main.tabpage_detail.cb_serial.Enabled = True /* 12/13 - PCONKL*/
		
		//GailM 7/3/2018 DE5006 Operators cannot confirm unless in function rights table
		If gs_role = '-1' or gs_role = '0' or gs_role = '1' or g.getfunctionrights('W_TRN',"C") = true THEN 
			tab_main.tabpage_main.cb_confirm.Enabled = True
		End If
		
		tab_main.tabpage_main.cb_void.Enabled = True
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = True

 	    i_nwarehouse.of_settab(idw_main,lstr_parms,1)
 	     i_nwarehouse.of_settab(idw_detail,lstr_parms,2)
		setQtyAllDisplay( true )
		
		// 11/11 - PCONKL
		tab_main.tabpage_main.cb_generate.visible = True
		tab_main.tabpage_main.cb_clear_gen.visible = True
		tab_main.tabpage_main.cb_import_sku.visible = True
		tab_main.tabpage_main.dw_generate.visible = True
		tab_main.tabpage_main.dw_sku.visible = True
		tab_main.tabpage_main.cb_generate.BringToTop = true
		tab_main.tabpage_main.cb_clear_gen.BringToTop = true
		tab_main.tabpage_main.cb_import_sku.BringToTop = True
		
		//17-Oct-2014 :Madhu- Honda- Visible of selected fileds for Import Transfer-START
		tab_main.tabpage_main.rb_sku.visible=True
		tab_main.tabpage_main.rb_pono.visible =True
		tab_main.tabpage_main.rb_pono2.visible =True
	//TAM 2018/05 - S19741 - Pandora uses custom transfer logic
		If gs_project = 'PANDORA' Then 
			tab_main.tabpage_main.rb_replenishment.visible =False
		Else
			tab_main.tabpage_main.rb_replenishment.visible =True 
		End If
		//TimA 11/24/14 Pandora issue #859
		tab_main.tabpage_main.rb_containerid.visible =True
		tab_main.tabpage_main.sle_count.Visible=True
		tab_main.tabpage_main.st_ItemCount.Visible=True
		//17-Oct-2014 :Madhu- Honda- Visible of selected fileds for Import Transfer -END

	Case "C" /*Complete*/
		
		setQtyAllDisplay( false )	
		tab_main.tabpage_detail.cb_replenish.Visible = False
		tab_main.tabpage_detail.cb_insert.Enabled = False
		tab_main.tabpage_detail.cb_delete.Enabled = False
		tab_main.tabpage_detail.cb_reset.Enabled = False
		tab_main.tabpage_detail.cb_serial.Enabled = True /* 12/13 - PCONKL*/
		tab_main.tabpage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_void.Enabled = False

		im_menu.m_file.m_save.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False

     	 i_nwarehouse.of_settab(idw_main)
      	i_nwarehouse.of_settab(idw_detail)

		// 11/11 - PCONKL
		tab_main.tabpage_main.cb_generate.visible = False
		tab_main.tabpage_main.cb_clear_gen.visible = False
		tab_main.tabpage_main.cb_import_sku.visible = False
		tab_main.tabpage_main.dw_generate.visible = False
		tab_main.tabpage_main.dw_sku.visible = False
		
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer-START
		tab_main.tabpage_main.rb_sku.visible=False
		tab_main.tabpage_main.rb_pono.visible =False
		tab_main.tabpage_main.rb_pono2.visible =False
		tab_main.tabpage_main.rb_replenishment.visible =False //TAM 2018/05 - S19741
		//TimA 11/24/14 Pandora issue #859
		tab_main.tabpage_main.rb_containerid.visible =False
		tab_main.tabpage_main.sle_count.Visible=False
		tab_main.tabpage_main.st_ItemCount.Visible=False
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer -END
		
	Case "V" /*Void */
		
		setQtyAllDisplay( false )
		tab_main.tabpage_detail.cb_replenish.Visible = False
		tab_main.tabpage_detail.cb_insert.Enabled = False
		tab_main.tabpage_detail.cb_delete.Enabled = False
		tab_main.tabpage_detail.cb_reset.Enabled = False
		tab_main.tabpage_detail.cb_serial.Enabled = False /* 12/13 - PCONKL*/
		tab_main.tabpage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_void.Enabled = False

		im_menu.m_file.m_save.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_record.m_delete.Enabled = False

      i_nwarehouse.of_settab(idw_main)
		i_nwarehouse.of_settab(idw_detail)
			
		// 11/11 - PCONKL
		tab_main.tabpage_main.cb_generate.visible = False
		tab_main.tabpage_main.cb_clear_gen.visible = False
		tab_main.tabpage_main.cb_import_sku.visible = False
		tab_main.tabpage_main.dw_generate.visible = False
		tab_main.tabpage_main.dw_sku.visible = False
		
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer-START
		tab_main.tabpage_main.rb_sku.visible=False
		tab_main.tabpage_main.rb_pono.visible =False
		tab_main.tabpage_main.rb_pono2.visible =False
		tab_main.tabpage_main.rb_replenishment.visible =False //TAM 2018/05 - S19741
		//TimA 11/24/14 Pandora issue #859
		tab_main.tabpage_main.rb_containerid.visible =False
		tab_main.tabpage_main.sle_count.Visible=False
		tab_main.tabpage_main.st_ItemCount.Visible=False
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer -END

	Case 'X' /* 04/05 - PCONKL - Pending a FWD Pick Replenishment */
			
		tab_main.tabpage_detail.cb_replenish.Visible = True
		tab_main.tabpage_detail.cb_replenish.Enabled = True
		
		//06/16 - PCONKL - Chg Text on button depending on Order Type
		If idw_Main.GetITemString(1,'Ord_Type') = 'X' Then /* Customer Initiated Transfer*/
			tab_main.tabpage_detail.cb_replenish.Text = "&Execute Customer Initiated Transfer"
		Else
			tab_main.tabpage_detail.cb_replenish.Text = "&Execute FWD Pick Replenishment"
		End If
		
		tab_main.tabpage_detail.cb_insert.Enabled = True
		tab_main.tabpage_detail.cb_delete.Enabled = True
		tab_main.tabpage_detail.cb_reset.Enabled = True
		tab_main.tabpage_detail.cb_serial.Enabled = False /* 12/13 - PCONKL*/
		tab_main.tabpage_main.cb_confirm.Enabled = False
		tab_main.tabpage_main.cb_void.Enabled = False
			
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = False
		if ib_edit then
			im_menu.m_record.m_delete.Enabled = True
		else
			im_menu.m_record.m_delete.Enabled = false
		end if

     		i_nwarehouse.of_settab(idw_main,lstr_parms,1)
			i_nwarehouse.of_settab(idw_detail,lstr_parms,2)
		
		// 11/11 - PCONKL
		tab_main.tabpage_main.cb_generate.visible = False
		tab_main.tabpage_main.cb_clear_gen.visible = False
		tab_main.tabpage_main.cb_import_sku.visible = False
		tab_main.tabpage_main.dw_generate.visible = False
		tab_main.tabpage_main.dw_sku.visible = False
		
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer-START
		tab_main.tabpage_main.rb_sku.visible=False
		tab_main.tabpage_main.rb_pono.visible =False
		tab_main.tabpage_main.rb_pono2.visible =False
		tab_main.tabpage_main.rb_replenishment.visible =False //TAM 2018/05 - S19741
		//TimA 11/24/14 Pandora issue #859
		tab_main.tabpage_main.rb_containerid.visible =False
		tab_main.tabpage_main.sle_count.Visible=False
		tab_main.tabpage_main.st_ItemCount.Visible=False
		//17-Oct-2014 :Madhu- Honda- Invisible of selected fileds for Import Transfer -END
		
End Choose


wf_check_status_mobile() /* 09/15 - PCONKL */


If tab_main.tabpage_main.rb_replenishment.checked =TRUE THEN
	tab_main.tabpage_main.cb_clear_gen.triggerEvent('clicked')
	tab_main.tabpage_main.dw_generate.object.beg_loc.Protect = True
	tab_main.tabpage_main.dw_generate.object.l_type.Protect = True
	tab_main.tabpage_main.dw_generate.object.inv_type.Protect = True
	tab_main.tabpage_main.dw_generate.object.end_loc.Protect = True
	tab_main.tabpage_main.dw_generate.object.ship_date_from.Protect = True
	tab_main.tabpage_main.dw_generate.object.ship_date_to.Protect = True
	tab_main.tabpage_main.dw_generate.object.lot_no.Protect = True
	tab_main.tabpage_main.dw_generate.Modify("beg_loc.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("l_type.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("inv_type.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("end_loc.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("ship_date_from.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("ship_date_to.Background.Color = '" +  string(67108864) + "'")
	tab_main.tabpage_main.dw_generate.Modify("lot_no.Background.Color = '" +  string(67108864) + "'")
Else
	tab_main.tabpage_main.dw_generate.object.beg_loc.Protect = False
	tab_main.tabpage_main.dw_generate.object.l_type.Protect = False
	tab_main.tabpage_main.dw_generate.object.inv_type.Protect = False
	tab_main.tabpage_main.dw_generate.object.end_loc.Protect = False
	tab_main.tabpage_main.dw_generate.object.ship_date_from.Protect = False
	tab_main.tabpage_main.dw_generate.object.ship_date_to.Protect = False
	tab_main.tabpage_main.dw_generate.object.lot_no.Protect = False
	tab_main.tabpage_main.dw_generate.Modify("beg_loc.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("l_type.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("inv_type.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("end_loc.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("ship_date_from.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("ship_date_to.Background.Color = '" +  string(RGB(255,255,255)) + "'")
	tab_main.tabpage_main.dw_generate.Modify("lot_no.Background.Color = '" +  string(RGB(255,255,255)) + "'")
End If

//i_nwarehouse.of_hide_unused(idw_detail) //21-Oct-2014 :Madhu- commented for baseline.
end subroutine

public function integer wf_update_content ();// int = wf_update_content()

//this function is modified by DGM  FROm 09/13/00 to 10/13/00
//We have modified all search criteia added supp_code,po,po2,owner,coo
//same parameters are also added for the all retrival parameters
//Same filds have been added for getitem & setitem statements

decimal ld_req, ld_avail //GAP 11-02  convert to decimal
long i, j, k, ll_currow, ll_totalrows,ll_own,llCompNo, llLineItemNo
string ls_sku, ls_lcode,ls_dlcode, ls_itype,ls_sno,ls_lno,ls_Pono
string ls_supp,ls_po2,ls_coo
string ls_container_id 			//GAP 11-02 
datetime ldt_expiration_date	//GAP 11-02 
string sRoNo
string sFilter
long tester

dwitemstatus ldis_status

idw_content.Reset()
idw_content.SetFilter("")
idw_dcontent.Reset()

f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Start  wf_update_content:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		


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
	
	k = idw_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
      	"' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) + &
		" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) +&
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content.RowCount())
		//TimA Commend out 08/06/14
	//	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Retrieve content records  wf_update_content:' + 'Sku :'+ ls_sku &
	//	+ ' - supp_code: ' + ls_supp + ' - FromLoc: ' + ls_lcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
	//	+ ' - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
	//	+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

	If k	<= 0 Then
		idw_content.retrieve(gs_project, getWarehouse(), ls_sku,ls_supp,ll_own, ls_lcode, &
										ls_sno, ls_lno, ls_pono,ls_po2,ls_itype,ls_coo, ls_container_id,&
										ldt_expiration_date ) /*retrievestart = 2, not cleared before adding enw records */

	End If
	
next

// Return original values of modified old records to content table
for i = 1 to idw_detail.rowcount()
	
	ldis_status = idw_detail.getitemstatus(i,0,Primary!)
	if ldis_status <> datamodified! and getOrderStatus() <> "V" then Continue
	
	// 04/05 - PCONKL - If Pending FWD Pick Executuin, there won't be any content ro process
	If ibfwdpickpending Then Exit
	
	ls_sku = Upper(idw_detail.getitemstring(i,'sku',Primary!,True))
	ls_supp = Upper(idw_detail.getitemstring(i,'supp_code',Primary!,True))
	ls_lcode = Upper(idw_detail.getitemstring(i,'s_location',Primary!,True))
	ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
	ls_sno = Upper(idw_detail.getitemstring(i,'serial_no',Primary!,True))
	ls_lno = Upper(idw_detail.getitemstring(i,'lot_no',Primary!,True))
	ls_pono = Upper(idw_detail.getitemstring(i,'po_no',Primary!,True))
	ls_po2 = Upper(idw_detail.getitemstring(i,'po_no2',Primary!,True))
	ls_container_id = Upper(idw_detail.getitemstring(i,'container_id',Primary!,True))	//GAP 11-02 
	ldt_expiration_date = idw_detail.getitemDateTime(i,'expiration_date',Primary!,True)	//GAP 11-02 
	ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin',Primary!,True))
	ll_own = idw_detail.getitemnumber(i,'owner_id',Primary!,True)
	ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type',Primary!,True))

		//TimA Commend out 08/06/14
//	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Pending FWD Pick Execution  wf_update_content:' + 'Sku :'+ ls_sku &
//	+ ' - supp_code: ' + ls_supp + ' - FromLoc: ' + ls_lcode + ' - ToLoc: '+ ls_dlcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
//	+ ' - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
//	+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		


	idw_dcontent.retrieve( getToNo() , ls_sku, ls_supp,ll_own,ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,ls_pono,ls_po2, &
									ls_container_id, ldt_expiration_date,ls_coo )
									
	ll_totalrows = idw_dcontent.RowCount()
//TAM 2018/05 - DE3917	- Remove this error and skip the return of inventory - This is because forward pick has not saved detail content rows yet so there is nothing to return
// to inventory.  We need to Exit
	If ll_totalrows <= 0 Then Exit
		
//	If ll_totalrows <= 0 Then 
			
//		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', ' IF Pending FWD Pick Execution count>0 , error msg will prompt  wf_update_content:' + string (ll_totalrows),isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
//		MessageBox(is_title, "System error 10002, please contact system support!", StopSign!) /*Transder_Detail_Content records don't exist*/
//		Return -1
//		
//	End If

	k = idw_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
	     " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content.RowCount())

		
	If k	<= 0 Then
		idw_content.retrieve(gs_project, getWarehouse() , ls_sku, ls_supp,ll_own,ls_lcode, ls_sno, ls_lno, &
										ls_pono,ls_po2, ls_itype,ls_coo, ls_container_id, ldt_expiration_date ) 
	End If
	
	for j = 1 to ll_totalrows
		
		sRoNo = Upper(idw_dcontent.GetItemString(j,'ro_no'))
		ll_currow = idw_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		    "' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			 "' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(ro_no) = '" + sRoNo + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content.RowCount())
			
		If ll_currow <= 0 Then
			
			ll_currow = idw_content.InsertRow(0)
			idw_content.setitem(ll_currow,'project_id',gs_project)
			idw_content.setitem(ll_currow,'sku',ls_sku)
			idw_content.setitem(ll_currow,'supp_code',ls_supp)
			idw_content.setitem(ll_currow,'wh_code',getWarehouse() )
			idw_content.setitem(ll_currow,'l_code',ls_lcode)
			idw_content.setitem(ll_currow,'inventory_type',ls_itype)
			idw_content.setitem(ll_currow,'serial_no',ls_sno)
			idw_content.setitem(ll_currow,'lot_no', ls_lno)
			idw_content.setitem(ll_currow,'po_no', ls_pono)
			idw_content.setitem(ll_currow,'po_no2', ls_po2)			
			idw_content.setitem(ll_currow,'container_id', ls_container_id)			//GAP 11-02 
			idw_content.setitem(ll_currow,'expiration_date', ldt_expiration_date)	//GAP 11-02 		
			idw_content.setitem(ll_currow,'country_of_origin', ls_coo)
			idw_content.setitem(ll_currow,'owner_id', ll_own)
			idw_content.setitem(ll_currow,'ro_no',sRoNo)
			idw_content.setitem(ll_currow,'complete_date',idw_dcontent.GetItemDateTime(j,'complete_date'))
			idw_content.setitem(ll_currow,'cntnr_Length',idw_dcontent.GetItemNumber(j,'cntnr_Length')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Width',idw_dcontent.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Height',idw_dcontent.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Weight',idw_dcontent.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'component_no',idw_dcontent.GetItemNumber(j,'Component_No')) /* 2013/02 - TAM - Need to return Component_No as well*/
			idw_content.setitem(ll_currow,'last_cycle_count',idw_dcontent.GetItemDateTime(j,'last_cycle_count')) /* 2017/12/7 - TAM - Need to return Last_Cycle_Count as well*/
			idw_content.setitem(ll_currow,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content.setitem(ll_currow,'last_update', gmtToday )
			//idw_content.setitem(ll_currow,'last_update', datetime( today(), now() ) )
			idw_content.setitem(ll_currow,'reason_cd', 'ST')
			
					//TimA Commend out 08/06/14
			//f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Inserting records into content  wf_update_content:' + 'Sku :'+ ls_sku &
			//+ ' - supp_code: ' + ls_supp + ' - Wh_code: ' + getWarehouse() +' - Loc: ' + ls_lcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
			//+ ' - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
			//+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype + ' - Ro_No:' + sRoNo,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		


		End If
		
		idw_content.setitem(ll_currow,'avail_qty', &
			idw_content.getitemnumber(ll_currow, "avail_qty") + &
			idw_dcontent.GetItemNumber(j,'quantity'))
			
	next
	
	for j = ll_totalrows to 1 Step -1
		
		idw_dcontent.DeleteRow(j)
			
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'deleted records from Transfercontent detail  wf_update_content:' + string (j) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

	next

next /*Detail Row*/

long test
test = idw_detail.deletedcount()

// Return deleted rows to content table
for i = 1 to idw_detail.deletedcount()
	
	ldis_status = idw_detail.getitemstatus(i,0,Delete!)
	if ldis_status = new! or ldis_status = newmodified! then Continue
	
	// 04/05 - PCONKL - If Pending FWD Pick Executuin, there won't be any content ro process
	If ibfwdpickpending  Then Exit
	
	ls_sku = idw_detail.getitemstring(i,'sku',Delete!,True)
	ls_supp = idw_detail.getitemstring(i,'supp_code',Delete!,True)
	ls_lcode = idw_detail.getitemstring(i,'s_location',Delete!,True)
	ls_dlcode = idw_detail.getitemstring(i,'d_location',Delete!,True)
	ls_sno = idw_detail.getitemstring(i,'serial_no',Delete!,True)
	ls_lno = idw_detail.getitemstring(i,'lot_no',Delete!,True)
	ls_pono = idw_detail.getitemstring(i,'po_no',Delete!,True)
	ls_itype = idw_detail.getitemstring(i,'inventory_type',Delete!,True)
	ls_po2 = idw_detail.getitemstring(i,'po_no2',Delete!,True)
	ls_container_id = idw_detail.getitemstring(i,'container_id',Delete!,True)				//GAP 11-02 
	ldt_expiration_date = idw_detail.getitemdatetime(i,'expiration_date',Delete!,True)	//GAP 11-02 
	ls_coo = idw_detail.getitemstring(i,'country_of_origin',Delete!,True)
	ll_own = idw_detail.getitemnumber(i,'owner_id',Delete!,True)

		//TimA Commend out 08/06/14	
	//f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Deleted records, Pening FWD Pick records   wf_update_content:' + 'Sku :'+ ls_sku &
	//+ ' - supp_code: ' + ls_supp + ' - FromLoc: ' + ls_lcode + ' -ToLoc: ' + ls_dlcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
	//+ ' - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
	//+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

	idw_dcontent.retrieve(getToNo(), ls_sku,ls_supp,ll_own, ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,&
									ls_pono,ls_po2, ls_container_id, ldt_expiration_date, ls_coo  )
	
	ll_totalrows = idw_dcontent.RowCount()

//TAM 2018/05 - DE3917	- Remove this error and skip the return of inventory - This is because forward pick has not saved detail content rows yet so there is nothing to return
// to inventory.  We need to Exit
	If ll_totalrows <= 0 Then Exit
//	If ll_totalrows <= 0 Then
//		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Deleted Transfercontent detail records count  <=0, error msg will prompt (System error 10001),  wf_update_content:' + string(ll_totalrows) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
//
//		MessageBox(is_title, "System error 10001, please contact system support!", StopSign!)
//		Return -1
//	End If

	k = idw_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		 "' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
	    " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
		"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
		"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
		"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content.RowCount())
		
	If k	<= 0 Then
		idw_content.retrieve(gs_project, getWarehouse(), ls_sku,ls_supp,ll_own,ls_lcode, ls_sno, &
									  ls_lno, ls_pono,ls_po2, ls_itype,ls_coo, ls_container_id, ldt_expiration_date )
	End If
	
	for j = 1 to ll_totalrows
		
		sRoNo = Upper(idw_dcontent.GetItemString(j,'ro_no'))
		
		ll_currow = idw_content.Find("upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
		     "' and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2 + &
			"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
			" and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(ro_no) = '" + sRoNo + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + upper(ls_container_id) + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'", 1, idw_content.RowCount())
		
	If ll_currow <= 0 Then
			ll_currow = idw_content.InsertRow(0)
			idw_content.setitem(ll_currow,'project_id',gs_project)
			idw_content.setitem(ll_currow,'sku',ls_sku)
			idw_content.setitem(ll_currow,'supp_code',ls_supp)
			idw_content.setitem(ll_currow,'wh_code',getWarehouse() )
			idw_content.setitem(ll_currow,'l_code',ls_lcode)
			idw_content.setitem(ll_currow,'inventory_type',ls_itype)
			idw_content.setitem(ll_currow,'serial_no',ls_sno)
			idw_content.setitem(ll_currow,'lot_no', ls_lno)
			idw_content.setitem(ll_currow,'po_no', ls_pono)
			idw_content.setitem(ll_currow,'po_no2', ls_po2)
			idw_content.setitem(ll_currow,'container_id', ls_container_id)  			//GAP 11-02
			idw_content.setitem(ll_currow,'expiration_date', ldt_expiration_date)	//GAP 11-02
			idw_content.setitem(ll_currow,'country_of_origin', ls_coo)
			idw_content.setitem(ll_currow,'owner_id', ll_own)
			idw_content.setitem(ll_currow,'ro_no', sRoNo )
			idw_content.setitem(ll_currow,'complete_date',idw_dcontent.GetItemDateTime(j,'complete_date'))
			idw_content.setitem(ll_currow,'cntnr_Length',idw_dcontent.GetItemNumber(j,'cntnr_Length')) /* 12/03 - PCONKL */
			idw_content.setitem(ll_currow,'cntnr_Width',idw_dcontent.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL */
			idw_content.setitem(ll_currow,'cntnr_Height',idw_dcontent.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL */
			idw_content.setitem(ll_currow,'cntnr_Weight',idw_dcontent.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL */
			idw_content.setitem(ll_currow,'component_no',idw_dcontent.GetItemNumber(j,'Component_No')) /* 2013/02 - TAM - Need to return Component_No as well*/
			idw_content.setitem(ll_currow,'last_cycle_count',idw_dcontent.GetItemDateTime(j,'last_cycle_count')) /* 2017/12/7 - TAM - Need to return Last_Cycle_Count as well*/
			idw_content.setitem(ll_currow,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content.setitem(ll_currow,'last_update', gmtToday )
			//idw_content.setitem(ll_currow,'last_update',  datetime( today(), now() ) )
			idw_content.setitem(ll_currow,'reason_cd', 'ST')
				//TimA Commend out 08/06/14
			//f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Record is inserted into content   wf_update_content:' + 'Sku :'+ ls_sku &
			//+ ' - supp_code: ' + ls_supp + ' - wh_code: ' + getWarehouse() + ' - l_Loc: ' + ls_lcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
			//+ ' - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
			//+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype + 'last user: ' + gs_userid,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

		End If
		
			idw_content.setitem(ll_currow,'avail_qty', &	
			idw_content.getitemnumber(ll_currow, "avail_qty") + &
			idw_dcontent.GetItemNumber(j,'quantity'))
			
	next /*Deleted Row*/
	
	for j = ll_totalrows to 1 Step -1
		idw_dcontent.DeleteRow(j)
		f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Deleted records fr tansfer content detail   wf_update_content:' + string (j) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

	next

next

idw_content.sort()

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
		ls_po2   = Upper(idw_detail.getitemstring(i,'po_no2'))
		ls_container_id   = Upper(idw_detail.getitemstring(i,'container_id'))	//GAP 11-02
		ldt_expiration_date   = idw_detail.getitemdatetime(i,'expiration_date')	//GAP 11-02
		ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type'))
		ld_req   = idw_detail.getitemnumber(i,'quantity') 
		ls_coo = Upper(idw_detail.getitemstring(i,'country_of_origin'))
		ll_own = idw_detail.getitemnumber(i,'owner_id')
		llLineItemNo = idw_detail.getitemnumber(i,'Line_Item_No') /* 09/15 - PCONKL */
	
		sFilter = "upper(sku) = '" + ls_sku + "' and upper(l_code) = '" + ls_lcode + &
			"' and upper(country_of_origin) = '" + ls_coo + "' and owner_id = "+ string(ll_own) +  &
		     " and upper(supp_code) = '" + ls_supp + "' and upper(po_no2) = '" +ls_po2  + &
			"' and upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" + ls_lno + "' and upper(po_no) = '" + ls_pono + &
			"' and upper(inventory_type) = '" + ls_itype + "' and upper(Container_ID) = '" + ls_container_id + &
			"' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "'"
		//TimA Commend out 08/06/14
	//f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Not Modified records  wf_update_content:' +sFilter ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

		idw_content.SetFilter( sFilter )
		idw_content.Filter()

		// Transfer new requested quantity from content
		j = 0
		Do while ld_req > 0 and j < idw_content.RowCount()
		
			j ++
			ld_avail = idw_content.GetItemNumber(j, "avail_qty")
			ll_currow = idw_dcontent.InsertRow(0)
			idw_dcontent.setitem(ll_currow,'to_no', getToNo() )
			idw_dcontent.setitem(ll_currow,'line_item_No',llLineItemNo) /* 09/15 - PCONKL */
			idw_dcontent.setitem(ll_currow,'sku',ls_sku)
			idw_dcontent.setitem(ll_currow,'supp_code',ls_supp)
			idw_dcontent.setitem(ll_currow,'s_location',ls_lcode)
			idw_dcontent.setitem(ll_currow,'d_location',ls_dlcode)
			idw_dcontent.setitem(ll_currow,'inventory_type',ls_itype)
			idw_dcontent.setitem(ll_currow,'serial_no',ls_sno)
			idw_dcontent.setitem(ll_currow,'lot_no',ls_lno)
			idw_dcontent.setitem(ll_currow,'po_no',ls_pono)
			idw_dcontent.setitem(ll_currow,'po_no2', ls_po2)
			idw_dcontent.setitem(ll_currow,'container_id', ls_container_id)				//GAP 11-02
			idw_dcontent.setitem(ll_currow,'expiration_date', ldt_expiration_date)		//GAP 11-02	
			idw_dcontent.setitem(ll_currow,'country_of_origin', ls_coo)
			idw_dcontent.setitem(ll_currow,'owner_id', ll_own)
			idw_dcontent.setitem(ll_currow,'component_no', idw_content.GetItemNumber(j,'component_no')) /* 10/00 PCONKL*/
			idw_dcontent.setitem(ll_currow,'cntnr_length', idw_content.GetItemNumber(j,'cntnr_length')) /* 12/03 PCONKL*/
			idw_dcontent.setitem(ll_currow,'cntnr_width', idw_content.GetItemNumber(j,'cntnr_width')) /* 12/03 PCONKL*/
			idw_dcontent.setitem(ll_currow,'cntnr_Height', idw_content.GetItemNumber(j,'cntnr_Height')) /* 12/03 PCONKL*/
			idw_dcontent.setitem(ll_currow,'cntnr_Weight', idw_content.GetItemNumber(j,'cntnr_Weight')) /* 12/03 PCONKL*/
			idw_content.setitem(ll_currow,'component_no',idw_dcontent.GetItemNumber(j,'Component_No')) /* 2013/02 - TAM - Need to return Component_No as well*/
			idw_dcontent.setitem(ll_currow,'last_cycle_count',idw_content.GetItemDateTime(j,'last_cycle_count')) /* 2017/12/7 - TAM - Need to return Last_Cycle_Count as well*/
			idw_dcontent.setitem(ll_currow,'ro_no',idw_content.GetItemString(j,'ro_no'))
			
			If ld_avail >= ld_req Then
				idw_dcontent.setitem(ll_currow,'quantity', ld_req)
				idw_content.setitem(j, "avail_qty", ld_avail - ld_req)
				ld_req = 0
			Else
				idw_dcontent.setitem(ll_currow,'quantity', ld_avail)
				idw_content.setitem(j, "avail_qty", 0)
				ld_req -= ld_avail					
			End If
		
			idw_content.setitem(j,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content.setitem(i,'last_update', gmtToday )
			idw_content.setitem(i,'last_update', datetime( today(), now() ) )
			idw_content.setitem(j,'reason_cd', 'ST')
			//TimA Commend out 08/06/14
			//f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'Inserting records into TransferContentdetail   wf_update_content:' + 'Sku :'+ ls_sku &
			//+ ' - supp_code: ' + ls_supp + ' - FromLoc: ' + ls_lcode + ' -ToLoc: ' + ls_dlcode + ' - serial no: ' + ls_sno + ' - LotNo: ' + ls_lno + 'Po_No: ' + ls_pono &
			//+ '	 - Po_No2: ' + ls_po2 +' - container_id: ' + ls_container_id + ' - ExpDate: ' + string (ldt_expiration_date, 'mm/dd/yyyy hh:mm') + ' - Coo: ' + ls_coo &
			//+ ' - owner_id: ' +string(ll_own) + ' - InvType: ' + ls_itype + '- Ro_NO: ' + idw_content.GetItemString(j,'ro_no') + ' - Qty: ' + string (ld_req) + ' - Last_user: ' +gs_userid,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

		Loop
	
		If ld_req > 0 Then
			Messagebox(is_title,"Not enough inventory for transfer!",StopSign!)
			tab_main.selecttab(2)
			f_setfocus(idw_detail, i, "sku")
			f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'End   wf_update_content Not enough inventory for transfer :' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
			return -1
		End If
	
	next /*Detail Row*/
	
End If /*Not Voided */

	f_method_trace_special( gs_project, this.ClassName() + ' - wf_update_content', 'End   wf_update_content:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

Return 0
end function

public function integer wf_confirm ();integer li_return
long i, j, k, ll_currow, ll_totalrows, llowner,ll_rtn,llCompNo, llRowCount, llRowPos
string ls_sku,ls_whcode,ls_lcode,ls_dlcode, ls_itype,ls_sno,ls_lno, lsEnforceLocUpdate, sql_syntax, errors, lsSerial, lsLoc,ls_LocType
string ls_tono, ls_ro, ls_pono, ls_pono2,ls_container_id, lsSupplier, lsCOO, lsFind //GAP 11/02 container
String ls_new_itype	// LTK 20150826
datetime  ldt_expiration_date //GAP 11/02 
Decimal	ldReqQty, ldScannedQty
Datastore	ldsTransferSerial

// LTK 20150908  Added the following variables to allow inventory type change and the insertion of adjustment/batch_transaction records
String	ls_supp, ls_coo, lsOldType, lsType, lsLot, lspo, lspo2
String lsRONO, lsRef, lsReason, is_trans_type, lsoldlot, lsremarks, lsRONO20, lsTransParm
String lsMsg, lsTitle, ls_confirm_message,ls_error_msg
Long ll_owner, ll_row, llAdjustID, llModCount
Dec ldAvailQty, ldNewQty
Boolean lb_rework, lb_update_detail
Datetime ldtToday
DataStore lds_adjustment_insert
// LTK 20150908  end variable additions

// LTK 20160104 Pandora #1002
Boolean lb_is_pandora_single_project_location_rule_on, lb_require_serial_capture
Long ll_count
String ls_s_location, ls_s_location_already_searched
// LTK 20160104  end Pandora #1002 variable additions

f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'Start wf_confirm:'  ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

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

// pvh - 09/21/05
if checkforconfirmed() then 
	messagebox( is_title, "Transfer Already Confirmed.", exclamation!)
	return -1
end if

//--

string lsproject, lssku

ls_whcode = idw_main.getitemstring(1,'d_warehouse')
ls_tono = idw_main.getitemstring(1,'to_no')

ldtToday = f_getLocalWorldTime( ls_whcode ) 	// LTK 20150831
lds_adjustment_insert = f_datastorefactory( 'd_adjustment_sweeper' )

// LTK 20160104  Pandora #1002
if gs_project = 'PANDORA' then
	lb_is_pandora_single_project_location_rule_on = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' )
end if

//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
if gs_project = 'PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" and isOrderStatus = 'P' then
	if wf_check_full_pallet_container() = -1 then return -1
end if


for i = 1 to idw_detail.rowcount()
	
	ls_dlcode = Upper(idw_detail.getitemstring(i,'d_location',Primary!,True))
	
	If isnull(ls_dlcode) then
		MessageBox ("Error", "Must enter 'TO Location' for all lines.'")
		Return -1
	END IF

	Select project_reserved into :lsProject
	From	location
	Where wh_code = :ls_whcode and l_code = :ls_dlcode
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
		
		if gs_Project = 'PANDORA' then
			
			//TimA 02/12/14
			//Pandora #698 New MIX OWNER location type to save multiple owners in one location
			Select project_reserved, l_type
			into :lsProject, :ls_LocType
			From	location
			Where wh_code = :ls_whcode and l_code = :ls_dlcode
			Using SQLCA;
			
			If  ls_LocType <> '6'  Then //New MIX OWNER type
			
				/* NOTE!!! 
				What if a Pick is generated (emptying location of certain owner/inv_typ), 
				then a Put-away succeeds (because material of different owner has been picked)
				then the pick is un-done, placing the inventory back in content???  */
	
				//check that location is either empty or contains only material of like Owner and Inventory Type
				llOwner = idw_detail.getitemNumber(i,'Owner_id',Primary!,True)
				ls_itype = Upper(idw_detail.getitemstring(i,'inventory_type',Primary!,True))
			
				Select max(sku) into :lsSKU
				From	content
				Where project_id = 'PANDORA'
				and wh_code = :ls_whcode and l_code = :ls_dlcode
				and (owner_id <> :llOwner or Inventory_Type <> :ls_itype)
				and avail_qty > 0
				Using SQLCA;			
			
				If isnull(lsSKU) or lsSKU = '' Then
					//nothing in selected location that is a different Owner/InvType
				Else
					messagebox(is_title, "The 'TO Location' ("+ls_dlcode+") already has material of a different Owner or Inventory Type!",StopSign!)
					Return -1
				End If
				
			End if
						
		end if
		
	Else /* Location Not Found*/
		Messagebox(is_title,"Location Not Found!",StopSign!)
		Return 1
	End If
	
	// LTK 20160104  Pandora #1002 - if source location has non-MAIN inventory, then enforce the capture of serial numbers
	if gs_project = 'PANDORA' and lb_is_pandora_single_project_location_rule_on and NOT lb_require_serial_capture then

		ls_s_location = Trim( Upper(idw_detail.getitemstring(i,'s_location',Primary!,True)) )

		if Len( ls_s_location ) > 0 and Len( isWarehouse ) > 0 then
			
			if Pos( ls_s_location_already_searched, '|' + ls_s_location + '|' ) > 0 then
				// Skip, already searched this location
			else
				ls_s_location_already_searched += '|' + ls_s_location + '|'
			
				SELECT 	Count(*)
				INTO		:ll_count
				FROM 	Content_Summary
				WHERE	Project_Id = :gs_project
				AND 		wh_code = :isWarehouse
				AND		l_code = :ls_s_location
				AND		po_no <> 'MAIN'
				USING 	SQLCA;

				if ll_count > 0 then
					lb_require_serial_capture = TRUE
				end if
			end if
		end if
	end if

	f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'Process wf_confirm:' + 'ToLoc: '+ ls_dlcode ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

Next
//--

// 12/13 - PCONKL - If chain of Custody and enforcing location update of Serial NUmbers, validate that they have been entered
If g.ibSNChainOfCustody Then
	
	Select Chain_of_custody_enforce_Location_update_Ind into :lsEnforceLocUpdate
	From Project
	Where Project_id = :gs_Project;
	
	If lsEnforceLocUpdate = 'Y' Then
		
		//Calculate required...
		SELECT sum(quantity) into :ldReqQty
		from transfer_Detail
		where to_no = :ls_tono and SKU in (select sku from item_MAster where project_id =  :gs_project and serialized_ind = 'B');
		
		//Calculate scanned
		Select Count(*) into :ldScannedQty
		From Transfer_Serial_Detail
		where to_no = :ls_tono;
		
		If ldReqQty <> ldScannedQty Then
			Messagebox(is_title,"Chain of Custody requires that Serial Numbers be updated with new Location for this Transfer~rRequired = " + String(ldReqQty) + ", Updated = " + String(ldScannedQty),StopSign!)
			Return -1
		End If
		
	End If
	
End If

// LTK 20160104  Pandora #1002 - added lb_require_serial_capture check
if lb_require_serial_capture then
	
	//Calculate required...
	SELECT sum(quantity) into :ldReqQty
	from transfer_Detail
	where to_no = :ls_tono and SKU in (select sku from item_MAster where project_id =  :gs_project and serialized_ind = 'B');
	
	//Calculate scanned
	Select Count(*) into :ldScannedQty
	From Transfer_Serial_Detail
	where to_no = :ls_tono;
	
	If ldReqQty <> ldScannedQty Then
		Messagebox(is_title,"Source Location has non-MAIN project inventory which requires that ~rSerial Numbers be updated with new Location for this Transfer~rRequired = " + String(ldReqQty) + ", Updated = " + String(ldScannedQty),StopSign!)
		Return -1
	End If
end if


// LTK 20150827  Made confirmation message conditional on a Philips flag
//1-FEB-2019 :Madhu S28945 Added PHILIPSCLS
if (Upper(Trim( gs_project )) = 'PHILIPS-SG' or Upper(Trim( gs_project )) = 'PHILIPSCLS') and Upper(Trim( ls_whcode )) = 'PHILIPS-MY' and Upper( idw_main.Object.Ord_Type[ 1 ] ) = 'W' then
	lb_rework = TRUE
end if

if lb_rework then
	ls_confirm_message = 'Is Rework completed?'
else
	ls_confirm_message = 'Are you sure you want to confirm this order?'
end if

//if messagebox(is_title,'Are you sure you want to confirm this order?',Question!,YesNo!,2) = 2 then	Return -1
if messagebox(is_title,ls_confirm_message,Question!,YesNo!,2) = 2 then	Return -1


// LTK 20150827  Update new inventory types to 'N' for rework detail rows
if lb_rework then
	for i = 1 to idw_detail.RowCount()
		if idw_detail.Object.inventory_type[ i ] = 'R' then
			idw_detail.Object.transfer_detail_new_inventory_type[ i ] = 'N'
			lb_update_detail = TRUE
		end if
	next

	if lb_update_detail then
		if idw_detail.update( FALSE, FALSE ) <> 1 then
			MessageBox(is_title, "System error, record save failed!")
			f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'Update of detail records failed setting REWORK back to NEW.',isToNo, ' ',' ',isToNo)
			return -1
		end if
	end if	
end if

idw_content.Reset()
idw_content.SetFilter("")
idw_dcontent.Reset()

//ls_whcode = idw_main.getitemstring(1,'d_warehouse')
//ls_tono = idw_main.getitemstring(1,'to_no')

// pvh - 02/14/06 gmt
datetime gmtdate
gmtdate =  f_getLocalWorldTime( ls_whcode ) 

// Retrieve related transfer content records for all rows

for i = 1 to idw_detail.rowcount()
	
	// 09/15 - PCONKL - If we've already written the Content record from Mobile, don't double up here
	If idw_detail.GetITemString(i,'Content_Record_Created_Ind') = 'Y' Then
		Continue
	End If
	
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
	ls_new_itype = Upper(idw_detail.getitemstring(i,'transfer_detail_new_inventory_type',Primary!,FALSE))		// LTK 20150826
	ls_container_id = Upper(idw_detail.getitemstring(i,'container_id',Primary!,True)) 	//GAP 11/02 added 
	ldt_expiration_date = idw_detail.getitemdatetime(i,'expiration_date',Primary!,True) //GAP 11/02 added here 
	lsRef = String(idw_detail.getitemNumber(i,'id_no')) /* 06/16 - PCONKL*/
	
	If	isnull(ls_new_itype) or ls_new_itype ='' Then ls_new_itype=ls_itype //14-Jun-2016: Madhu- Added to set New Inv Type
	
	idw_dcontent.retrieve(getToNo(), ls_sku, lsSupplier, llOwner, ls_lcode, ls_dlcode, ls_itype, ls_sno, ls_lno,ls_pono,ls_pono2,ls_container_id, ldt_expiration_date,lsCoo )  
	//TimA Commend out 08/06/14
	//f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'Retrieve content wf_confirm:' + 'sku: ' +ls_sku &
	//+ ' - Supp_code: '+ lsSupplier + ' - COO: ' + lsCoo +' - From Loc: ' +ls_lcode + ' - ToLoc: '+ ls_dlcode + ' - serialno: ' +ls_sno &
	//+ ' - lot_no: ' +ls_lno +' - Po_No: ' +ls_pono + ' - Po_No2: ' +ls_pono2 + ' - Inv_Type: ' +ls_itype +' - container_id: ' + ls_container_id +' - ExpDate: ' +  String(ldt_expiration_date,'mm/dd/yyyy hh:mm') ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

	ll_totalrows = idw_dcontent.RowCount()
	If ll_totalrows <= 0 Then
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'count wf_confirm:' + 'TotalRows: ' + string(ll_totalrows ) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
	MessageBox(is_title, "System error 10002, please contact system support!", StopSign!)
		ll_rtn = -1
		Return ll_rtn
	End If

	lsFind = "Upper(sku) = '" + ls_sku + "' and Upper(l_code) = '" + ls_dlcode + &
		"' and Upper(serial_no) = '" + ls_sno + "' and Upper(lot_no) = '" + ls_lno + "' and Upper(po_no) = '" + ls_pono +  "' and Upper(po_no2) = '" + ls_pono2 +  & 
		"' and Upper(Container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" +  String(ldt_expiration_date,'mm/dd/yyyy hh:mm')   + & 
		"' and upper(country_of_origin) = '" + lscoo + "' and Upper(inventory_type) = '" + ls_new_itype + "' and owner_id = " + string(llowner)  + & 
		" and upper(supp_code) = '" + lsSupplier + "'"
	/* dts - 01/18/06 - added supplier to Find so that it will re-retrieve 
	if supplier is different but everything else is the same. */
	//f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'Retrieve content wf_confirm:' + 'Find: ' + lsFind ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
	
	k = idw_content.Find(lsFind, 1, idw_content.RowCount())
	If k	<= 0 Then
		k = idw_content.retrieve(gs_project, ls_whcode, ls_sku, lsSupplier, llOwner,ls_dlcode, ls_sno, ls_lno,ls_pono,ls_pono2, ls_new_itype,lscoo, ls_container_id ,ldt_expiration_date )
	end if        
		
	for j = 1 to ll_totalrows
		
		ls_ro = Upper(idw_dcontent.GetItemString(j,'ro_no'))
		llCompNo = idw_dcontent.GetItemNumber(j,'component_no')
		
		lsFind = "Upper(sku) = '" + ls_sku + "' and Upper(l_code) = '" + ls_dlcode + &
			"' and Upper(serial_no) = '" + ls_sno + "' and Upper(lot_no) = '" + ls_lno + "' and Upper(po_no) = '" + ls_pono + "' and Upper(po_no2) = '" + ls_pono2 +  & 
			"' and Upper(Container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(ldt_expiration_date,'mm/dd/yyyy hh:mm')   + "' and Upper(ro_no) = '" + ls_ro +  "' and upper(country_of_origin) = '" + lscoo +  &  
			"' and Upper(inventory_type) = '" + ls_new_itype + "' and owner_id = " + string(llOwner) + & 
			" and upper(supp_code) = '" + lsSupplier + "'"
			/* dts - 01/18/06 - added supplier to Find... */
	//TimA Commend out 08/06/14
		//f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'find  wf_confirm:' + ' Ro_No: ' +ls_ro +' - componentNo: '+ string(llCompNo) +' - Find: ' + lsFind ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
		
		//If component exists, add to find
		If llCompNo > 0 Then
			lsFind += " and component_no = " + String(llCompNo)
		End If
		
		ll_currow = idw_content.Find(lsFind, 1, idw_content.RowCount())
		If ll_currow <= 0 Then
			
			ll_currow = idw_content.InsertRow(0)
			idw_content.setitem(ll_currow,'project_id',gs_project)
			idw_content.setitem(ll_currow,'sku',ls_sku)
			idw_content.setitem(ll_currow,'supp_code',lsSupplier)
			idw_content.setitem(ll_currow,'wh_code',ls_whcode)
			idw_content.setitem(ll_currow,'l_code',ls_dlcode)
			//idw_content.setitem(ll_currow,'inventory_type',ls_itype)
			idw_content.setitem(ll_currow,'inventory_type',ls_new_itype)		// LTK 20150826
			idw_content.setitem(ll_currow,'serial_no',ls_sno)
			idw_content.setitem(ll_currow,'lot_no', ls_lno)
			idw_content.setitem(ll_currow,'po_no', ls_pono)
			idw_content.setitem(ll_currow,'po_no2', ls_pono2)
			idw_content.setitem(ll_currow,'container_ID', ls_container_ID)  //GAP 11/02 added here 
			idw_content.setitem(ll_currow,'expiration_date', ldt_expiration_date)		//GAP 11/02 added here 	
			idw_content.setitem(ll_currow,'ro_no', ls_ro )
			idw_content.setitem(ll_currow,'owner_id', llOwner)
			idw_content.setitem(ll_currow,'component_no', llCompNo)
			idw_content.setitem(ll_currow,'Country_of_origin', lsCoo)
			idw_content.setitem(ll_currow,'last_user', gs_userid)
			// pvh 11/30/05 - gmt
			idw_content.setitem(ll_currow,'last_update', gmtDate )
			//idw_content.setitem(ll_currow,'last_update', datetime( today(), now() ) )
			
			idw_content.setitem(ll_currow,'reason_cd', 'ST')
			idw_content.setitem(ll_currow,'cntnr_length',idw_dcontent.GetItemNumber(j,'cntnr_length')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Width',idw_dcontent.GetItemNumber(j,'cntnr_Width')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Height',idw_dcontent.GetItemNumber(j,'cntnr_Height')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'cntnr_Weight',idw_dcontent.GetItemNumber(j,'cntnr_Weight')) /* 12/03 - PCONKL*/
			idw_content.setitem(ll_currow,'last_cycle_count',idw_dcontent.GetItemDateTime(j,'last_cycle_count')) /* 2017/12/7 - TAM - Need to return Last_Cycle_Count as well*/
			
		End If

//TAM 2017/12/07 - 3PL CC - If Material is moving in to an existing content row then we want to save the oldest Last Cycle Count 
datetime con,dcon
con  = idw_content.GetItemDateTime(ll_currow,'last_cycle_count')
dcon = idw_dcontent.GetItemDateTime(j,'last_cycle_count')
		
		if idw_dcontent.GetItemDateTime(j,'last_cycle_count') < idw_content.GetItemDateTime(ll_currow,'last_cycle_count') then
			idw_content.setitem(ll_currow,'last_cycle_count',idw_dcontent.GetItemDateTime(j,'last_cycle_count'))
		end if
		
		idw_content.setitem(ll_currow,'avail_qty', &
			idw_content.getitemnumber(ll_currow, "avail_qty") + &
			idw_dcontent.GetItemNumber(j,'quantity'))
			
		// If old/new inventory types don't match, insert into adjustment datastore which will be updated later (along with batch_transaction) - LTK 20150908
		if ls_new_itype <> ls_itype then
			ll_row = lds_adjustment_insert.InsertRow(0)
			lds_adjustment_insert.Object.project_id[ ll_row ] = gs_project
			lds_adjustment_insert.Object.sku[ ll_row ] = ls_sku
			lds_adjustment_insert.Object.Supp_Code[ ll_row ] = lsSupplier
			lds_adjustment_insert.Object.WH_Code[ ll_row ] = ls_whcode
			lds_adjustment_insert.Object.Owner_ID[ ll_row ] = llOwner			
			lds_adjustment_insert.Object.Country_of_Origin[ ll_row ] = lsCoo	
			lds_adjustment_insert.Object.L_Code[ ll_row ] = ls_dlcode
			lds_adjustment_insert.Object.Inventory_Type[ ll_row ] = ls_new_itype
			lds_adjustment_insert.Object.Serial_No[ ll_row ] = ls_sno
			lds_adjustment_insert.Object.Lot_No[ ll_row ] = ls_lno
			lds_adjustment_insert.Object.RO_No[ ll_row ] = ls_ro
			lds_adjustment_insert.Object.PO_No[ ll_row ] = ls_pono
			lds_adjustment_insert.Object.PO_No2[ ll_row ] = ls_pono2
			lds_adjustment_insert.Object.Old_quantity[ ll_row ] = idw_dcontent.GetItemNumber(j,'quantity')
			lds_adjustment_insert.Object.Quantity[ ll_row ] = idw_dcontent.GetItemNumber(j,'quantity')
			
			//06/16 - PCONKL - Added Ref and Reason so we can link to a Transfer Detail record if needed
			lds_adjustment_insert.Object.ref_No[ ll_row ] = lsRef
			lds_adjustment_insert.Object.Reason[ ll_row ] = "TRANSFER"
			
			lds_adjustment_insert.Object.Last_User[ ll_row ] = gs_userid
			lds_adjustment_insert.Object.Last_Update[ ll_row ] = ldtToday
			lds_adjustment_insert.Object.Old_Inventory_Type[ ll_row ] = ls_itype
			lds_adjustment_insert.Object.Old_Country_of_Origin[ ll_row ] = lsCoo
			lds_adjustment_insert.Object.Old_PO_No2[ ll_row ] = ls_pono2
			lds_adjustment_insert.Object.container_ID[ ll_row ] = ls_container_ID
			lds_adjustment_insert.Object.Expiration_Date[ ll_row ] = ldt_expiration_date
			lds_adjustment_insert.Object.Old_Owner[ ll_row ] = llOwner
  			lds_adjustment_insert.Object.Adjustment_Type[ ll_row ] = 'I'			
		end if

	next
	
	idw_dcontent.Reset()
	
next /* Detail Row */

Execute Immediate "Begin Transaction" using SQLCA; 

ll_rtn = 0
if idw_content.Update(false,false)  = 1 then
	
	//GailM 08/02/2017 SIMSPEVS-717 NYCSP Defect-Not Updating Component Location with Parent SKU
	if gs_Project = 'NYCSP' then
		For ll_row = 1 to idw_content.rowcount()
			If idw_content.GetItemNumber(ll_row,'component_no') > 0 Then
				sql_syntax = "UPDATE content SET l_code = '" + idw_content.GetItemString(ll_row,'l_code') + &
						"' WHERE project_id = '" + gs_Project + "' AND wh_code = '" + idw_content.GetItemString(ll_row, 'wh_code') + "' " + &
						" AND container_id = '" + idw_content.GetItemString(ll_row, 'container_id') + "' "
				Execute Immediate :sql_syntax using SQLCA;
				If Sqlca.sqlcode <> 0  Then
					ls_error_msg = sqlca.sqlerrtext
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox(is_title,"Unable to save content for component child records to new location.: ~r~r" + ls_error_msg)
					Return -1
//				Else		08/29/2017 - Removed update of content_summary since it is not needed (Also removed test for inventory type = 8 as component)
//					sql_syntax = "UPDATE content_summary SET l_code = '" + idw_content.GetItemString(ll_row,'l_code') + &
//							"' WHERE project_id = '" + gs_Project + "' AND wh_code = '" + idw_content.GetItemString(ll_row, 'wh_code') + "' " + &
//							" AND container_id = '" + idw_content.GetItemString(ll_row, 'container_id') + "' AND inventory_type = '8' "
//					Execute Immediate :sql_syntax using SQLCA;
//					If Sqlca.sqlcode <> 0  Then
//						ls_error_msg = sqlca.sqlerrtext
//						Execute Immediate "ROLLBACK" using SQLCA;
//						MessageBox(is_title,"Unable to save content summary for component child records to new location.: ~r~r" + ls_error_msg)
//						Return -1
//					End IF
				End If
			End If
		Next
	End If
		
	// pvh 11/30/05 - gmt
	If IsNull(idw_main.GetItemDateTime(1, 'complete_date')) Then
		
		//idw_main.setitem(1,'complete_date', today() )
		idw_main.setitem(1,'complete_date', f_getLocalWorldTime( idw_main.object.s_warehouse[ 1 ] )  )
		//TimA Pandora issue #422.  Last user and update not being set when order is confirmed
		idw_main.setitem(1,'last_update', gmtDate )
		idw_main.setitem(1,'last_user', gs_userid)		
		
	end If
	
	idw_main.setitem(1,'ord_status','C')
	ll_rtn = idw_main.Update( false,false ) 
	
end if

// 12/13 - PCONKL - If enforcing location update for Serials (Chain of Custody), Update here
//If g.ibSNChainOfCustody  and lsEnforceLocUpdate = 'Y' and ll_rtn = 1 Then
If (g.ibSNChainOfCustody  and lsEnforceLocUpdate = 'Y' and ll_rtn = 1) or (ll_rtn = 1 and lb_require_serial_capture) Then	// LTK 20160105  Pandora #1002 added the Pandora single project rule check
	
	ldsTransferSerial = Create DataStore
	sql_syntax = "SELECT *  from transfer_Serial_Detail " 
	sql_syntax += " where to_no = '" + ls_tono + "'" 
	ldsTransferSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
	ldsTransferSerial.SetTransObject(SQLCA)
	ldsTransferSerial.Retrieve()

	llRowCount = ldsTransferSerial.RowCount()
	For llRowPOs = 1 to llRowCount
		
		lsSKU = ldstransferSerial.GetITemString(llRowPos,'sku')
		lsSerial = ldstransferSerial.GetITemString(llRowPos,'serial_no')
		lsloc = ldstransferSerial.GetITemString(llRowPos,'d_location')

// TAM 2019/05 - S33409 - Populate Serial History Table
		Update Serial_Number_Inventory Set l_code = :lsLoc, Transaction_Type = 'TRANSFER', Transaction_ID = :ls_tono, Adjustment_Type = 'LOCATION'
		Where Project_id = :gs_Project and sku = :lsSKU and Serial_no = :lsSerial
		Using SQLCA;
		
	Next
	
End If


if ll_rtn = 1 then
	for i = 1 to lds_adjustment_insert.rowcount()

		// Copied the following insertion logic from w_adjustment and modified slightly - LTK 20150901

		lsSku = lds_adjustment_insert.Object.Sku[ i ]
		ls_supp  = lds_adjustment_insert.Object.Supp_Code[ i ]
		ll_owner = lds_adjustment_insert.Object.Owner_ID[ i ]
		ls_coo = lds_adjustment_insert.Object.Country_of_Origin[ i ]
		//ls_oldcoo = idw_detail.Object.country_of_origin[ i ]
		//lsWarehouse = idw_master.Object.d_warehouse[ i ]
		lsLoc = lds_adjustment_insert.Object.L_Code[ i ]
		lsOldType = lds_adjustment_insert.Object.Old_Inventory_Type[ i ]
		lsType= lds_adjustment_insert.Object.Inventory_Type[ i ]
		lsSerial = lds_adjustment_insert.Object.Serial_No[ i ]
		lsLot = lds_adjustment_insert.Object.Lot_No[ i ]
		lspo = lds_adjustment_insert.Object.PO_No[ i ]
		//lsoldpo = idw_detail.Object.po_no[ i ]
		lspo2 = lds_adjustment_insert.Object.PO_No2[ i ]
		//lsoldpo2 = idw_detail.Object.po_no2[ i ]
		ls_container_ID = lds_adjustment_insert.Object.container_ID[ i ]
		ldt_expiration_date = lds_adjustment_insert.Object.Expiration_Date[ i ]
		lsRONO = lds_adjustment_insert.Object.RO_No[ i ]
		ldAvailQty = lds_adjustment_insert.Object.Quantity[ i ]
		
		//06/16 - PCONKL - Added Ref and Reason so we can link to a transfer record from the Adjustment confirmation if needed
		lsRef = lds_adjustment_insert.Object.Ref_no[ i ]
		lsReason = lds_adjustment_insert.Object.Reason[ i ]
		
		is_trans_type = 'I'
		lsoldlot = '-'
//			lsremarks	// leave NULL
		lsTransParm = ""

		// Insert Adjustment record
		SQLCA.DBParm = "disablebind =0"
		Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
										wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
										container_ID, expiration_date, ro_no, old_quantity,quantity,last_user,last_update, Adjustment_Type,
										old_lot_no, Ref_No, Reason) 
		values						(:gs_project,:lsSku,:ls_supp,:ll_owner,:ll_owner,:ls_coo,:ls_coo,:ls_whcode,:lsLoc,:lsOldType,:lsType, &
										:lsSerial,:lsLot,:lspo,:lspo,:lspo2,:lspo2,
										:ls_container_ID, :ldt_expiration_date, :lsRONO, :ldAvailQty,:ldAvailQty,:gs_userid,:ldtToday,:is_trans_type,
										:lsoldlot,:lsRef, :lsReason)
		Using SQLCA;
		SQLCA.DBParm = "disablebind =1"	
			
		If Sqlca.sqlcode <> 0  Then
			ls_error_msg = sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			//MessageBox("Adjustment Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
			MessageBox(is_title,"Unable to create new stock adjustment: ~r~r" + ls_error_msg)
			Return -1
		End IF	

		//TAM 10/01/04 truncate rono to 20 (from "receive_master_supp_invoice_no" above)
		lsRONO20 = MID(lsRoNo,1,20)

		// 05/01 PCONKL - We need to display the Adjustment ID of the new record. Since it is auto generated by the DB, we need to retrieve it
		Select Max(Adjust_no) into :llAdjustID
		From	 Adjustment
		Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;
	
		If llAdjustID > 0 Then
			lsMsg += 'The Adjustment ID for Row # ' + string( i ) + ' is: ' + string(llAdjustID) + "~r"
			//dw_content.SetITem(llRowPos,'c_adjust_no',llAdjustID)
		Else
			Messagebox('New Adjustment ID','Unable to retrieve the Adjustment ID for Row # ' + string(llRowPos))
		End If

		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
									Values(:gs_Project, 'MM', :llAdjustID,'N', :ldtToday, :lsTransParm)
		Using SQLCA;
		
		If Sqlca.sqlcode <> 0  Then
			ls_error_msg = sqlca.sqlerrtext
			Execute Immediate "ROLLBACK" using SQLCA;
			//MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + ls_error_msg)
			Return -1
		End IF

		llModCount ++

	next
end if

IF ll_rtn = 1 THEN
	
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		idw_main.ResetUpdate()
		idw_content.ResetUpdate()	
		
		//BCR 13-JUL-2011: Zero Quantities Issue Resolution => Call stored proc to delete zero qty rows right after every  
		//successful Content table update. This way, we don't have to rely on the erratic update trigger for cleanup.
		li_return = SQLCA.sp_content_qty_zero()
		
	end if	
	MessageBox(is_title, "Record confirmed!")
	this.event ue_retrieve()

	// Display adjustment information if available - LTK 20150909
	if llModCount > 0 then
		//Show adjustment numbers created...
		If llModCount > 1 Then
			lsTitle = "New Adjustment ID's"
			lsMsg += "~r~rIf your procedures require it, please write these numbers down."
		Else
			lsTitle = "New Adjustment ID"
			lsMsg += "~r~rIf your procedures require it, please write this number down."
		End IF
		Messagebox(lsTitle, lsMsg)
	end if

	f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'End  wf_confirm:' + 'Last User: ' + gs_userid +' - Last Update: '+ string(gmtDate ,'mm/dd/yyyy hh:mm')  ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
	return 0
ELSE
	Execute Immediate "ROLLBACK" using SQLCA;
	idw_main.ResetUpdate()
	idw_content.ResetUpdate()	
	MessageBox(is_title, "Record confirm failed!~r~n" + SQLCA.SQLErrText )
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_confirm', 'End  wf_confirm FAILED:' + 'Last User: ' + gs_userid +' - Last Update: '+ string(gmtDate ,'mm/dd/yyyy hh:mm')  ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
	Return -1
END IF


end function

public subroutine dotransferall (long detailrow);// doTransferAll( long detailRow )

string sku
string supplier
string toLocation
string fromLocation
long transQty

long FromLocrows
long newRow
long index, i
long max
datastore idsworker, idschild

f_method_trace_special( gs_project, this.ClassName() + ' - dotransferall', 'Start dotransferall:'  ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

if detailrow <= 0 or isNull( detailrow ) then return 

idsworker = f_datastorefactory( idw_detail.dataobject )
if gs_Project = "NYCSP" then  //hdc NYCSP wants to see the component children in the detail
	idschild = f_datastorefactory("d_tran_detail_nycsp")
end if

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

transQty = idw_detail.object.quantity[ detailRow ]

idsFromLocations.setsqlselect( GetFromLocationSQL( ) )
idsFromLocations.Retrieve()

FromLocRows = doFromFilter( fromLocation )

if FromLocRows <=0 then
	messagebox( this.title, "From Locations Not Found! Contact Technical Support.",exclamation! )
	return
end if

f_method_trace_special( gs_project, this.ClassName() + ' - dotransferall', 'Process dotransferall:' + 'Sku: '+ sku +' Supplier: ' +supplier &
+ ' FromLocation: ' + FromLocation + 'To Location: ' +toLocation + 'TransQty: ' + String (transQty),isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

idsworker.reset()
if gs_Project = "NYCSP" then  //hdc NYCSP wants to see the component children in the detail
	idschild.reset()
	idschild.insertrow(0)
end if 
idw_detail.rowscopy( detailRow,detailRow,primary!, idsworker,1,primary! )

for index = 1 to FromLocRows
	if index = 1 then 
		//newrow = detailRow	
		newrow = 1						// LTK 20111103 	Pandora #315
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
	if gs_Project = "NYCSP" then  //hdc this is the meat of the NYCSP child detail population
		idschild.accepttext()
		idschild.retrieve( idsworker.object.to_no[ newRow], idsworker.object.sku[newRow]  )
	end if
	//hdc this isn't necessary in the case of new orders as the SQL corrects the location problem but could be commented back in if we ever decide
	//to use this screen to correct historical data (reopen the transfer, then complete it again)
//	for i = 1 to idschild.rowcount()  
//		idschild.object.d_location[i] = idsworker.object.d_location[newRow]
//	next
//
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - dotransferall', 'Process dotransferall:' + 'Sku: ' + idsworker.object.sku[ newRow ] &
//+ '- Suppcode: ' + idsworker.object.supp_code[ newRow ] +' - Owner_name: ' +idsworker.object.c_owner_name[ newRow ] &
//+ '- InvType: '+idsworker.object.inventory_type[ newRow ] + '- ownerId: '+ string(idsworker.object.owner_id[ newRow ]) &
//+ '- COO: '+ idsworker.object.country_of_origin[ newRow ] +' -FromLoc: '+ idsworker.object.s_location[ newRow] &
//+'- toloc: '+ idsworker.object.d_location[ newRow] + '- Qty: '+ string(idsworker.object.quantity[ newRow ]) &
//+'- To_No: '+ idsworker.object.to_no[ newRow] + '- Lot_No: '+ idsworker.object.lot_no[ newRow ] &
//+ '- Po_No: '+idsworker.object.po_no[ newRow ]+ '- Po_No2: '+ idsworker.object.po_no2[ newRow ] &
//+ '- ContainerId: '+ idsworker.object.container_ID[ newRow ] + '- ExpDate: '+ string(idsworker.object.expiration_date[ newRow ] ,'mm/dd/yyyy hh:mm')&
//+ '- Serial No: ' +idsworker.object.serial_no[ newRow ],isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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
	if gs_project = "NYCSP" then
		idw_detail.object.quantity[ newRow ] = transQty
	else
		idw_detail.object.quantity[ newRow ] = idsWorker.object.quantity[ index ]
	end if
	idw_detail.object.inventory_type[ newRow ] = idsWorker.object.inventory_type[ index ]
	idw_detail.object.owner_id[ newRow ] = idsWorker.object.owner_id[ index ]
	idw_detail.object.to_no[ newRow] =  idsWorker.object.to_no[ index ]
	idw_detail.object.lot_no[ newRow ] = idsWorker.object.lot_no[ index ]
	idw_detail.object.po_no[ newRow ] = idsWorker.object.po_no[ index ]
	idw_detail.object.po_no2[ newRow ] = idsWorker.object.po_no2[ index ]
	idw_detail.object.container_ID[ newRow ] = idsWorker.object.container_ID[ index ]
	idw_detail.object.expiration_date[ newRow ] = idsWorker.object.expiration_date[ index ]
	idw_detail.object.serial_no[ newRow ] = idsWorker.object.serial_no[ index ]	

	if gs_Project = "NYCSP" then
	  for i = 1 to idschild.rowcount()  		
		newRow =idw_detail.insertrow(0)	
	
		idw_detail.object.sku[ newRow ] = idschild.object.sku[ i ]
		idw_detail.object.supp_code[ newRow ] = idschild.object.supp_code[ i ]
		idw_detail.object.owner_id[ newRow ]= idschild.object.owner_id[ i ]
//		idw_detail.object.c_owner_name[ newRow ] = idschild.object.owner_id[ i ]
		idw_detail.object.country_of_origin[ newRow ] = idschild.object.country_of_origin[ i ]
		idw_detail.object.s_location[ newRow] = idschild.object.s_location[ i ]
		idw_detail.object.d_location[ newRow] = idschild.object.d_location[ i ]
		idw_detail.object.quantity[ newRow ] = idschild.object.transfer_quantity[ i ]
		idw_detail.object.inventory_type[ newRow ] = idschild.object.inventory_type[ i ]
		idw_detail.object.to_no[ newRow] =  idschild.object.to_no[ i ]
		idw_detail.object.lot_no[ newRow ] = idschild.object.lot_no[ i ]
		idw_detail.object.po_no[ newRow ] = idschild.object.po_no[ i ]
		idw_detail.object.po_no2[ newRow ] = idschild.object.po_no2[ i ]
		idw_detail.object.container_ID[ newRow ] = idschild.object.container_ID[ i ]
		idw_detail.object.expiration_date[ newRow ] = idschild.object.expiration_date[ i ]
		idw_detail.object.serial_no[ newRow ] = idschild.object.serial_no[ i ]
	  next
	end if
next

if gs_project = "NYCSP" then  //hdc hide the total which makes no sense when child comps are shown
	idw_detail.object.compute_1.visible = false
	idw_detail.object.total_t.visible = false
end if


f_method_trace_special( gs_project, this.ClassName() + ' - dotransferall', 'End dotransferall:'  ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
end subroutine

public function string getfromlocationsql ();// string = getFromLocationSQL()

string lsNewSql, lsOwnerCd
long ll_owner_id

lsNewSql = replace(isfromlocsql,pos(isfromLocSql,'xxxxx'),5,gs_project) 
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - getfromlocationsql', 'Start getfromlocationsql:'  ,isToNo, ' ',lsNewSql,isToNo) //04-Sep-2013  :Madhu added

//03-May-2017 :Madhu PEVS-515 - Populate same Owner code Inventory records -START
If upper(gs_project) ='PANDORA' Then

	lsOwnerCd = idw_main.getitemstring(1,'user_field2') 
	
	SELECT Owner_ID INTO :ll_owner_id FROM OWNER 
	WHERE Project_ID = :gs_project AND
	Owner_CD = :lsOwnerCd
	USING SQLCA;
	//03-May-2017 :Madhu PEVS-515 - Populate same Owner code Inventory records -END			

	// pvh 11/14/05 - remove supplier code
	lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
				    "' and sku = '" + idw_detail.object.sku[ idw_detail.getrow() ] + &
					"' and Content.Owner_Id = " + string(ll_owner_id) + &  
				    " and avail_qty > 0 "
Else
	lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
				    "' and sku = '" + idw_detail.object.sku[ idw_detail.getrow() ] + &
				    "' and avail_qty > 0 "
End IF
//03-May-2017 :Madhu PEVS-515 - Populate same Owner code Inventory records -END

// 
// replaced code
// 
//lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
//				    "' and sku = '" + idw_detail.object.sku[ idw_detail.getrow() ] + &
//				    "' and supp_code = '" + idw_detail.object.supp_code[ idw_detail.getrow() ] + &
//				    "' and avail_qty > 0 "
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - getfromlocationsql', 'END getfromlocationsql:'  ,isToNo, ' ',lsNewSql,isToNo) //04-Sep-2013  :Madhu added
return lsNewSql

end function

public subroutine setqtyalldisplay (boolean abool);// setQtyAllDisplay( boolean abool )

// turn off/on the qty all objects.


//MStuart commented 072011 - make transfer visible for baseline
/*
if gs_project <> 'PHXBRANDS'  and gs_project <>  'DEMO' and gs_project <>  'PANDORA' and gs_project <>  'COMCAST' then
	 tab_main.tabpage_detail.cb_xferall.visible = false
	 return
end if
tab_main.tabpage_detail.cb_xferall.visible = abool
*/

//MStuart 072011 - make transfer visible for baseline
tab_main.tabpage_detail.cb_xferall.visible = abool	

// 11/11 - PCONKL - replacing tansfer all button with generate criteria
//tab_main.tabpage_detail.cb_xferall.visible = false
end subroutine

public subroutine setownerid (long aid);// setOwnerId( long aID )
ilOwnerID = aID

end subroutine

public function long getownerid ();// long = getOwnerID()
//f_method_trace_special( gs_project, this.ClassName() + ' - getownerid', 'Start getownerid:' + string(ilOwnerID) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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

datastore ids

ids = f_datastoreFactory( 'd_tran_master' )

rows = ids.retrieve( getOrderNumber(), gs_project )
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' -checkconfirmed', 'Start checkconfirmed:' +getOrderNumber() ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

if rows <= 0 then
	//TimA Commend out 08/06/14
//	f_method_trace_special( gs_project, this.ClassName() + ' - checkconfirmed', 'Start checkconfirmed:' +'rows: '+ string(rows) ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
	messagebox( is_title, "Unable to Retrieve Transfer Master Data.  Please Contact Support.",exclamation! )
	return false
end if

if ids.object.ord_status[1] = 'C' then return true

return false

end function

public subroutine setordernumber (string asordernbr);// setOrderNumber( string asOrdernbr )
isOrderNo = asOrdernbr

end subroutine

public function string getordernumber ();// string = getOrderNumber()
//f_method_trace_special( gs_project, this.ClassName() + ' - getordernuber', 'Start getordernumber:' + isOrderNo ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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

idw_detail.setfilter( filterfor )
idw_detail.filter()
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - checkforduplicates', 'Start checkforduplicates:' +filterfor ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

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

//TimA 09/22/15 Global gs_System_No for logging database errors if they happen
gs_System_No = isToNo

end subroutine

public subroutine setwarehouse (string _value);// setWarehouse( string _value )
isWarehouse = _value

end subroutine

public function string getorderstatus ();// string = getOrderStatus()
//f_method_trace_special( gs_project, this.ClassName() + ' - getorderstatus', 'Start getorderstatus:' + isOrderStatus ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
return isOrderStatus

end function

public function string gettono ();// string = getToNo()
//f_method_trace_special( gs_project, this.ClassName() + ' - gettono', 'Start gettono:' + isTono ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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

modifiedrow = idw_detail.getNextModified( 0, Primary! )
if modifiedrow > 0 then ibChanged = true

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
		//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - getrolleduptransactions', 'Start getrolleduptransactions:' + filterfor,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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

f_method_trace_special( gs_project, this.ClassName() + ' - dotransferallcontainer', 'Start dotransferallcontainer:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
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
			
//	f_method_trace_special( gs_project, this.ClassName() + ' - dotransferallcontainer', 'Process dotransferallcontainer:' + 'Sku: ' + idw_detail.object.sku[ newRow ] &
//+ '- Suppcode: ' + idw_detail.object.supp_code[ newRow ] +' - Owner_name: ' +idw_detail.object.c_owner_name[ newRow ] &
//+ '- COO: '+ idw_detail.object.country_of_origin[ newRow ] +' -FromLoc: '+ idw_detail.object.s_location[ newRow] &
//+'- toloc: '+ idw_detail.object.d_location[ newRow] + '- Qty: '+ string(idw_detail.object.quantity[ newRow ]) &
//+ '- InvType: '+idw_detail.object.inventory_type[ newRow ] + '- ownerId: '+ string(idw_detail.object.owner_id[ newRow ]) &
//+'- To_No: '+ idw_detail.object.to_no[ newRow] + '- Lot_No: '+ idw_detail.object.lot_no[ newRow ] &
//+ '- Po_No: '+idw_detail.object.po_no[ newRow ]+ '- Po_No2: '+ idw_detail.object.po_no2[ newRow ] &
//+ '- ContainerId: '+ idw_detail.object.container_ID[ newRow ] + '- ExpDate: '+ string( idw_detail.object.expiration_date[ newRow ] ,'mm/dd/yyyy hh:mm')&
//+ '- Serial No: ' +idw_detail.object.serial_no[ newRow ],isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
		
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
f_method_trace_special( gs_project, this.ClassName() + ' - dotransferallcontainer', 'End dotransferallcontainer:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added
end subroutine

public function string getfromlocationcontainersql ();// string = GetFromLocationContainerSQL()

string lsNewSql

lsNewSql = replace(isFromLocContSql,pos(isFromLocContSql,'xxxxx'),5,gs_project) 
f_method_trace_special( gs_project, this.ClassName() + ' - getfromlocationcontainersql', 'Start getfromlocationcotnaienrsql:' ,isToNo, ' ',lsNewSql,isToNo) //04-Sep-2013  :Madhu added

// pvh 11/14/05 - remove supplier code
lsNewSql += " and wh_code = '" +  idw_main.object.s_warehouse[1] + &
				    "' and po_no2 = '" + idw_detail.object.po_no2[ idw_detail.getrow() ] + &
				    "' and avail_qty > 0 "
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - getfromlocationcontainersql', 'End getfromlocationcontainersql:' ,isToNo, ' ',lsNewSql,isToNo) //04-Sep-2013  :Madhu added

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

// 09/15 - PCONKL - If already released to mobile, set row mobile status to new
If idw_Main.GetITemString(1,'mobile_Enabled_Ind') = 'Y' Then
	idw_Detail.SetItem(ll_Row,'mobile_status_Ind','N')
else
	idw_Detail.SetItem(ll_Row,'mobile_status_Ind','')
End If

// 09/15 - PCONKL - Set Line Item Number and default content record created
idw_Detail.SetItem(ll_Row,'Line_Item_No',ll_Row)
idw_Detail.SetItem(ll_Row,'Content_record_created_Ind',"N")

idw_detail.setcolumn('sku')
idw_detail.SetItem(ll_row, "to_no", getToNo() )
// reset the status to New!
idw_detail.setItemStatus( ll_row, 0, primary! , NotModified!	 )
idw_detail.setItemStatus( ll_row, 0, primary! , New! )

idw_detail.Post Function SetFocus()
idw_detail.Post Function ScrollToRow(ll_row)

return

end subroutine

public function integer wf_generate_detail ();
// 11/11 - PCONKL - generated detail rows based on criteria...
DataStore	ldsContent, ldsRequest
DataStore		ldsReplenishmentSkus //TAM 2018/05  - S19741
String sql_syntaxReplenishment, lsReplenishmentSKU, lsReplenishmentL_Code   //TAM 2018/05  - S19741
Long llRowCountReplenishment, llReplenishmentPos, llReplenishmentMin_FP_Qty, llReplenishment_Qty  //TAM 2018/05  - S19741

Long	llRowCount, llRowPos, llNewRow, llRequestRow, llRequestPos, llRequestCount, llRequestQty, llNeededQty, llQty, llSKUCount, llSkuPos
String	sql_syntax, ERRORS, lsSKU, lsFromLoc, lsToLoc, lsInvType, lsLocType, lsWarehouse, lsRequestSKU, lsLotNo
DateTime	ldtFrom, ldtTo
String ls_detail_sku, ls_detail_suppcode //10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No.
long llRow //10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No.

f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Start  wf_generate_detail:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

//TimA 11/24/14 added new function to imput Box ID's.  So fare we are only allowing Pandora to use container ID.
//Still not sure why we are not allowing Pandora to use this feature.  Dave is tring to remember.  This has been in place since 3/2011
//If gs_project = 'PANDORA'  and tab_main.tabpage_main.rb_containerid.checked =FALSE Then
	//TimA Pandora issue #859 change the messagebox display
//	Messagebox('Generate','This functionality is not enabled for this project except for Box ID')
//	REturn 0
//End If

tab_main.tabpage_main.dw_generate.AcceptText()
tab_main.tabpage_main.dw_sku.AcceptText()

lsWarehouse =  idw_main.GetITemString(1,'s_warehouse')

lsFromLoc =  tab_main.tabpage_main.dw_generate.GetITemString(1,'beg_loc')
lsToLoc =  tab_main.tabpage_main.dw_generate.GetITemString(1,'end_loc')
lsInvType =  tab_main.tabpage_main.dw_generate.GetITemString(1,'inv_type')
ldtFrom = tab_main.tabpage_main.dw_generate.GetITemDateTime(1,'ship_date_From')
ldtTo = tab_main.tabpage_main.dw_generate.GetITemDateTime(1,'ship_date_To')
lsLocType = tab_main.tabpage_main.dw_generate.GetITemString(1,'l_type')
lslotNo = tab_main.tabpage_main.dw_generate.GetITemString(1,'lot_no')		//SARUN2014JAN08 : Adding Lot_no to Criterie for Generated

If lsWarehouse = '' or isnull(lsWarehouse) Then
	Messagebox('Generate Detail','Warehouse required before generating Detail list',Stopsign!)
	Return -1
End If

lsSKU = ""
If tab_main.tabpage_main.dw_sku.rowCount() > 0 then

	llSkuCount = tab_main.tabpage_main.dw_sku.rowCount()
	For llSkuPos = 1 to llSkuCount
		
		If tab_main.tabpage_main.dw_sku.GetITemString(llSkuPos,'SKU') > '' Then
			lsSKU += "'" +  tab_main.tabpage_main.dw_sku.GetITemString(llSkuPos,'SKU') + "',"
		End If
		
	Next
	
	lsSKU = Left(lsSKU,(Len(lsSKU) - 1))  /*remove last comma*/
	
End If

//TAM 2018/05  - S19741 - Added Repenishment RB -  Need to build a list of skus -BEGIN
/* To do this 
	1,	Join Item_Forward_Pick to content summary to get a datastore with the Qty's currently in inventory.
	2.	Filter out any records where content.Qty < Min_FP_Qty
	3.	Build a list of SKU to select all the Content records(This portion uses the same logic as the SKU Radio Button)
	4.	Later on in the process we will build the transfer detail records using the Datastore in step 1 above.
*/

If tab_main.tabpage_main.rb_replenishment.checked =TRUE THEN
	lsSKU = ""
	ldsReplenishmentSkus = Create Datastore

	sql_syntaxReplenishment = " SELECT Item_Forward_Pick.SKU, Item_Forward_Pick.L_Code, Item_Forward_Pick.Owner_Id, Item_Forward_Pick.Min_FP_Qty, Item_Forward_Pick.Max_Qty_To_Pick, Item_Forward_Pick.Replenish_Qty, Item_Forward_Pick.Partial_Pick_Ind, Sum(content_summary.avail_qty) as avail_qty, Sum(content_summary.tfr_in) as tfr_in"
	sql_syntaxReplenishment += " FROM Item_Forward_Pick LEFT OUTER JOIN content_summary ON Item_Forward_Pick.Project_Id = content_summary.project_id AND Item_Forward_Pick.L_Code = content_summary.l_code AND Item_Forward_Pick.SKU = content_summary.sku AND Item_Forward_Pick.WH_Code = content_summary.wh_code " 
	sql_syntaxReplenishment += " WHERE Item_Forward_Pick.Project_Id = '" + gs_project + "' AND Item_Forward_Pick.WH_Code = '" + lsWarehouse + "'"  
	sql_syntaxReplenishment += " GROUP BY Item_Forward_Pick.SKU, Item_Forward_Pick.L_Code, Item_Forward_Pick.Owner_Id, Item_Forward_Pick.Min_FP_Qty, Item_Forward_Pick.Max_Qty_To_Pick, Item_Forward_Pick.Replenish_Qty, Item_Forward_Pick.Partial_Pick_Ind "

//	sql_syntaxReplenishment = " SELECT Item_Forward_Pick.SKU, Item_Forward_Pick.L_Code, Item_Forward_Pick.Owner_Id, Item_Forward_Pick.Min_FP_Qty, Item_Forward_Pick.Max_Qty_To_Pick, Item_Forward_Pick.Replenish_Qty, Item_Forward_Pick.Partial_Pick_Ind, Sum(content_summary.avail_qty)"
//	sql_syntaxReplenishment += " FROM Item_Forward_Pick, content_summary" 
//	sql_syntaxReplenishment += " WHERE Item_Forward_Pick.Project_Id = content_summary.project_id AND Item_Forward_Pick.WH_Code = content_summary.wh_code  AND Item_Forward_Pick.SKU = content_summary.sku AND"  
//	sql_syntaxReplenishment += " Item_Forward_Pick.L_Code = content_summary.l_code AND Item_Forward_Pick.Project_Id = '" + gs_project + "' AND Item_Forward_Pick.WH_Code = '" + lsWarehouse + "' AND"  
//	sql_syntaxReplenishment += " content_summary.avail_qty < Item_Forward_Pick.Min_FP_Qty AND content_summary.tfr_in = 0 "
//	sql_syntaxReplenishment += " GROUP BY Item_Forward_Pick.SKU, Item_Forward_Pick.L_Code, Item_Forward_Pick.Owner_Id, Item_Forward_Pick.Min_FP_Qty, Item_Forward_Pick.Max_Qty_To_Pick, Item_Forward_Pick.Replenish_Qty, Item_Forward_Pick.Partial_Pick_Ind "


	f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Process  wf_generate_Detail:' + 'Query to retrieve from Item_Forward_Pick: ',isToNo, ' ',sql_syntaxReplenishment,isToNo) 		

	ldsReplenishmentSkus.Create(SQLCA.SyntaxFromSQL(sql_syntaxReplenishment,"", ERRORS))

	IF Len(ERRORS) > 0 THEN
  		Messagebox('Generate Details', 'Unable to retrieve Item_Forward_Pick datastore: ' + Errors)
 		RETURN - 1
	END IF

	ldsReplenishmentSkus.SetTransObject(SQLCA)

	llRowCountReplenishment = ldsReplenishmentSkus.retrieve()
	
	//Filter Inventory for Content_Summary.Avail_QTY < Item_Forward_Pick.Min_FP_Qty 
	ldsReplenishmentSkus.SetFilter("(Avail_QTY <  Item_Forward_Pick.Min_FP_Qty or IsNull(Avail_QTY)) and (tfr_in = 0 or IsNull(tfr_in))")
	ldsReplenishmentSkus.Filter()

	llRowCountReplenishment = ldsReplenishmentSkus.RowCount()

//If no rows selected then get out
	If llRowCountReplenishment < 1 Then
		Messagebox('Generate Details', 'No inventory records found to Replenish')
		Return 0
	End If

	//Use the Datastore to build the list of SKUs to retrieve content
	For llSkuPos = 1 to llRowCountReplenishment
		
		If ldsReplenishmentSkus.GetITemString(llSkuPos,'SKU') > '' Then
			lsSKU += "'" +  ldsReplenishmentSkus.GetITemString(llSkuPos,'SKU') + "',"
		End If
		
	Next
	
	lsSKU = Left(lsSKU,(Len(lsSKU) - 1))  /*remove last comma*/

End If
//TAM 2018/05  - S19741 - Added Repenishment RB -  Need to build a list of skus -END

If lsSKU > '' or lsFromLoc > '' or lsToLoc > '' or lsInvType > '' or lsLocType > '' or string(ldtFrom) > '' or string(ldtTo) > ''   Then
Else
	Messagebox('Generate Detail','Criteria required before generating Detail list',Stopsign!)
	return 0
End If

f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Process  wf_generate_Detail:' + 'Sku: ' + lsSKU &
+ '- FromLoc: ' + lsFromLoc + ' - ToLoc: ' +lsToLoc + 'Inv_Type: ' +lsInvType + 'LocType: ' + lsLocType,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

If idw_detail.RowCount() > 0 Then
	
	If messagebox('generate Detail','Do you want to clear the existing Detail Rows?',Question!,yesNo!,2) = 1 Then
		
		Do While idw_detail.RowCount() > 0
			idw_detail.DeleteRow(1)
		Loop
		
		TriggerEvent('ue_save')
		
	End IF
	
End If

Setpointer(Hourglass!)

//Load COntent for the sentered Criteria
//Gailm 9/17/2018 S23453 F10296 I1526 Rema Replenishment - Added Inventory_Type table to add Inventory_Shippable_ind to Content query
ldsContent = Create Datastore
sql_syntax = " Select c.sku, c.supp_code,c. l_code, c.owner_id, c.country_of_origin, c.inventory_type, c.lot_no, c.serial_no, c.po_no, c.po_no2, c.Container_id, " 
sql_syntax += "c.expiration_date, i.inventory_shippable_ind, Sum(avail_qty) as Quantity "
sql_syntax += "From Content c with (nolock), Inventory_Type i with (nolock) where c.Project_id = '" + gs_project + "' and c.wh_code = '" + lsWarehouse + "' and "
sql_syntax += "i.Project_id = c.Project_Id and i.Inv_Type = c.inventory_type "


If lsSKU > '' Then //hdc NIKE code was baseline; doesn't work for long SKUs
//17-Oct-2014 : Madhu- Honda- Append appropriate attribute value to sql - START
//	if left(gs_project,4)="NIKE" then
//		sql_syntax += " and left(sku,10) in (" + lsSKU + ") "
//	else
//		sql_syntax += " and left(sku,50) in (" + lsSKU + ") "
//	end if

	If tab_main.tabpage_main.rb_sku.checked =TRUE THEN  sql_syntax += " and left(c.sku,50) in (" + lsSKU + ") "
	If tab_main.tabpage_main.rb_pono.checked =TRUE THEN  sql_syntax += " and left(c.po_no,50) in (" + lsSKU + ") "
	If tab_main.tabpage_main.rb_pono2.checked =TRUE THEN sql_syntax += " and left(c.po_no2,50) in (" + lsSKU + ") "
	//TimA 11/24/14 Added containerID
	If tab_main.tabpage_main.rb_containerid.checked =TRUE THEN sql_syntax += " and left(c.container_id,50) in (" + lsSKU + ") "
	//17-Oct-2014 : Madhu- Honda- Append appropriate attribute value to sql - END
	If tab_main.tabpage_main.rb_replenishment.checked =TRUE THEN sql_syntax += " and left(c.sku,50) in (" + lsSKU + ") "    //TAM 2018/05  - S19741 - Added Repenishment RB
End If

If lsFromLoc > '' Then
	sql_syntax += " and c.l_code = '" + lsFromLoc + "'"
End If

If lsInvType > '' Then
	sql_syntax += " and c.inventory_type = '" + lsInvType + "'"
End If

If lslotNo > '' Then
	sql_syntax += " and c.lot_no = '" + lslotNo + "'"	//SARUN2014JAN08 : Adding Lot_no to Criterie for Generated
End If

If lsLocType > '' Then
	sql_Syntax += " and c.l_code in (Select l_code from location where wh_code = '" + lsWarehouse + "' and  l_type = '" + lsLocType + "') "
End If

If String(ldtFrom) > '' and String(ldtTo) > '' Then
	
	sql_syntax += " and c.sku in (select sku from Delivery_master, Delivery_Detail where Delivery_master.do_no = delivery_Detail.do_no and project_id = '" + gs_project + "' and ord_status = 'N' and wh_code = '" + lsWarehouse + "' " 
	sql_Syntax += " and c.schedule_date >= '" + String(ldtFrom, "yyyy-mm-dd hh:mm:ss") + "' and schedule_date <= '" + String(ldtTo, "yyyy-mm-dd hh:mm:ss") + "') "
	
End If

sql_syntax += " and c.avail_qty > 0 Group By c.sku, c.supp_code, c.l_code, c.owner_id, c.country_of_origin, c.inventory_type, c.lot_no, c.serial_no, c.po_no, c.po_no2, c.Container_id, c.expiration_date, i.Inventory_Shippable_Ind  "

f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Process  wf_generate_Detail:' + 'Query to retrieve from content: ',isToNo, ' ',sql_syntax,isToNo) //04-Sep-2013  :Madhu added		

ldsContent.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   Messagebox('Generate Details', 'Unable to retrieve Content datastore: ' + Errors)
   RETURN - 1
END IF

ldsContent.SetTransObject(SQLCA)
llRowCount = ldsContent.retrieve()

// If we are searching by Schedule Date, we only want to transfer the necessary quantities. WE want to retrieve a DS of the SKU/Qty that needs transferring and loop through COntent and filter out anything not needed
If String(ldtFrom) > '' and String(ldtTo) > '' Then
	
	ldsRequest = Create DataStore
	sql_syntax = "select sku, Sum(req_Qty) as Qty from Delivery_master, Delivery_Detail where Delivery_master.do_no = delivery_Detail.do_no and project_id = '" + gs_project + "' and ord_status = 'N' and wh_code = '" + lsWarehouse + "' " 
	
	If lsSKU > '' Then
		sql_syntax += " and sku in (" + lsSKU + ") "
	End If 
	
	sql_Syntax += " and schedule_date >= '" + String(ldtFrom, "yyyy-mm-dd hh:mm:ss") + "' and schedule_date <= '" + String(ldtTo, "yyyy-mm-dd hh:mm:ss") + "' "
	sql_syntax +=  " Group by SKU "
	
	f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Process  wf_generate_Detail:' + 'Query to retrieve from content by scheduled date: ',isToNo, ' ',sql_syntax,isToNo) //04-Sep-2013  :Madhu added		

	ldsRequest.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

	IF Len(ERRORS) > 0 THEN
  	 	Messagebox('Generate Details', 'Unable to retrieve Open Order datastore: ' + Errors)
   		RETURN - 1
	END IF
	
	ldsRequest.SetTransObject(SQLCA)
	llRequestCount = ldsRequest.Retrieve()
	
End If

//For each Content record, add a detail row
If llRowCount < 1 Then
	Messagebox('Generate Details', 'No inventory records found to transfer')
	Return 0
End If

// If we retrieved open orders, we will loop through and only generate transfer rows to fulfill those orders, otherwise will transfer all matching content records
If String(ldtFrom) > '' and String(ldtTo) > '' Then
	
	If llRequestCount > 0 Then
		
		//For each open order SKU
		For llRequestPos = 1 to llRequestCount
			
			lsRequestSKU = ldsRequest.GetITEmString(llRequestPos,'SKU')
			llRequestQty = ldsRequest.GetITemNumber(llRequestPos,'Qty')
			
			//Filter COntent for just this SKU
			ldsContent.SetFilter("Upper(SKU) = '" + Upper(lsRequestSKU) + "'")
			ldsContent.Filter()
			
			llNeededQty = llRequestQty
			llRowCOunt = ldsContent.RowCount()
			
			If llRowCOunt = 0 Then Continue
			
			For llRowPos = 1 to llRowCount
				
				If llNeededQty <= 0 Then Exit
				
				llQty = ldsContent.GetITemNumber(llRowPos,'quantity')
				
				llNewRow = idw_detail.InsertRow(0)
	
				If idw_Main.GetITemString(1,'TO_NO') > '' Then
					idw_detail.SetITem(llNewRow,'to_no',idw_Main.GetITemString(1,'TO_NO'))
				End If
	
				idw_detail.SetITem(llNewRow,'SKU',ldsContent.GetITemString(llRowPos,'SKU'))
				idw_detail.SetITem(llNewRow,'supp_Code',ldsContent.GetITemString(llRowPos,'supp_code'))
				idw_detail.SetITem(llNewRow,'s_location',ldsContent.GetITemString(llRowPos,'l_code'))
				idw_detail.SetITem(llNewRow,'Owner_id',ldsContent.GetITemNumber(llRowPos,'Owner_id'))
				idw_detail.SetITem(llNewRow,'Country_of_origin',ldsContent.GetITemString(llRowPos,'Country_of_origin'))
				idw_detail.SetITem(llNewRow,'Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type'))
				idw_detail.SetITem(llNewRow,'Transfer_Detail_New_Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type')) /* 09/15 - PCONKL*/
				idw_detail.SetITem(llNewRow,'Lot_No',ldsContent.GetITemString(llRowPos,'Lot_No'))
				idw_detail.SetITem(llNewRow,'Serial_No',ldsContent.GetITemString(llRowPos,'Serial_No'))
				idw_detail.SetITem(llNewRow,'po_no',ldsContent.GetITemString(llRowPos,'po_no'))
				idw_detail.SetITem(llNewRow,'po_no2',ldsContent.GetITemString(llRowPos,'po_no2'))
				idw_detail.SetITem(llNewRow,'Container_id',ldsContent.GetITemString(llRowPos,'Container_id'))
				idw_detail.SetITem(llNewRow,'expiration_date',ldsContent.GetITemDateTime(llRowPos,'Expiration_date'))
				
				// 09/15 - PCONKL - If already released to mobile, set row mobile status to new
				If idw_Main.GetITemString(1,'mobile_Enabled_Ind') = 'Y' Then
					idw_Detail.SetItem(llNewRow,'mobile_status_Ind','N')
				else
					idw_Detail.SetItem(llNewRow,'mobile_status_Ind','')
				End If

				// 09/15 - PCONKL - Set Line Item Number and default content record created
				idw_Detail.SetItem(llNewRow,'Line_Item_No',llNewRow)
				idw_Detail.SetItem(llNewRow,'Content_record_created_Ind',"N")
				
				// If to Loc populated, defaut Transfer To Loc
				If lsToLoc > '' Then			
					idw_detail.SetITem(llNewRow,'D_location',lsToLoc)
				End If
				
				//Either take the entire COntent Record or jsut what we need to fulfill
				If llNeededQty >= llQty Then
					idw_detail.SetITem(llNewRow,'Quantity',llQty)
				Else
					idw_detail.SetITem(llNewRow,'Quantity',llNeededQty)
				End If
				
				llNeededQty = llNeededQty - llQty
					//TimA Commend out 08/06/14
				//f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'creating trasnfer detail  wf_generate_Detail:'  &
				//+ 'SKU: ' +ldsContent.GetITemString(llRowPos,'SKU') + ' - supp_code: ' + ldsContent.GetITemString(llRowPos,'supp_code') &
				//+' - FromLoc: ' +ldsContent.GetITemString(llRowPos,'l_code') + ' - Ownerid: ' + string(ldsContent.GetITemNumber(llRowPos,'Owner_id')) &
				//+ ' - COO: ' +ldsContent.GetITemString(llRowPos,'Country_of_origin') + ' - InvType: ' + ldsContent.GetITemString(llRowPos,'Inventory_Type') &
				//+ ' - LotNo: ' +ldsContent.GetITemString(llRowPos,'Lot_No') + ' - SerialNo: ' + ldsContent.GetITemString(llRowPos,'Serial_No') &
				//+ ' - PoNo: ' +ldsContent.GetITemString(llRowPos,'po_no') + ' - PoNo2: ' + ldsContent.GetITemString(llRowPos,'po_no2') &
				//+ ' - ContainerId: ' + ldsContent.GetITemString(llRowPos,'Container_id') + ' - Exp date: ' + string(ldsContent.GetITemDateTime(llRowPos,'Expiration_date') ,'mm/dd/yyyy hh:mm'),isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
				
				//10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No. - START
				ls_detail_sku = ldsContent.GetITemString(llRowPos,'SKU')
				ls_detail_suppcode = ldsContent.GetITemString(llRowPos,'supp_code')
				
				IF i_nwarehouse.of_item_master(gs_project, ls_detail_sku, ls_detail_suppcode ) > 0 THEN
		
					llRow =i_nwarehouse.ids.Getrow()
		
					If upper(i_nwarehouse.ids.GetItemString(llRow,"serialized_ind")) ='B' Then
						idw_detail.SetItem(llNewRow,'serialized_ind', 'Y')
					else
						idw_detail.SetItem(llNewRow,'serialized_ind', 'N')
					End If
				END IF
				//10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No. - END
		
			Next
			
		Next /*Next Open ORder SKU*/
		
	Else
		
		Messagebox('Generate Details', 'No Orders found in selected range to transfer')
		Return 0
		
	End If
	
//TAM 2018/05  - S19741 - Added Repenishment RB -BEGIN
ElseIf tab_main.tabpage_main.rb_replenishment.checked =TRUE THEN
/* We now need to build the Transfer Details for replenishment Sku/Locations.
To do this
	1.	Loop through each record in the Replenishment Datastore created above
	2.	Set the Content Filter for sku needed and exclude the Forward Pick Location.
	3.	Either take the entire COntent Record or just what we need to fulfill until the fulfillment quantity is satifisfied or there is no more content 
*/
	//For each Replenishment SKU
	For llReplenishmentPos = 1 to llRowCountReplenishment
			
		lsReplenishmentSKU = ldsReplenishmentSkus.GetITEmString(llReplenishmentPos,'SKU')
		lsReplenishmentL_Code = ldsReplenishmentSkus.GetITEmString(llReplenishmentPos,'L_Code')
		llReplenishmentMin_FP_Qty = ldsReplenishmentSkus.GetITemNumber(llReplenishmentPos,'Min_FP_Qty')
		llReplenishment_Qty = ldsReplenishmentSkus.GetITemNumber(llReplenishmentPos,'Replenish_Qty')
			
		//Filter COntent for just this SKU (ignore Fwd Pick Location
		//Gailm 9/17/2018 S23453 F10296 I1526 Rema Replenishment - Added Inventory_Shippable_Ind to filter out content rows that are not shippable (damage, etc.)
string lsfilter 
		lsfilter = "SKU = '" + lsReplenishmentSKU + "' and L_Code <> '" + lsReplenishmentL_Code + "' and Inventory_Shippable_Ind = 'Y' "
		ldsContent.SetFilter(lsFilter)
//		ldsContent.SetFilter("SKU = '" + lsRequestSKU + "' and L_Code <> '" + lsReplenishmentL_Code + "'")
		ldsContent.Filter()
			
		llNeededQty = llReplenishment_Qty
		llRowCOunt = ldsContent.RowCount()
			
		If llRowCOunt = 0 Then Continue
			
		For llRowPos = 1 to llRowCount
				
			If llNeededQty <= 0 Then Exit
				
			llQty = ldsContent.GetITemNumber(llRowPos,'quantity')
			
			llNewRow = idw_detail.InsertRow(0)

			If idw_Main.GetITemString(1,'TO_NO') > '' Then
				idw_detail.SetITem(llNewRow,'to_no',idw_Main.GetITemString(1,'TO_NO'))
			End If

			idw_detail.SetITem(llNewRow,'SKU',ldsContent.GetITemString(llRowPos,'SKU'))
			idw_detail.SetITem(llNewRow,'supp_Code',ldsContent.GetITemString(llRowPos,'supp_code'))
			idw_detail.SetITem(llNewRow,'s_location',ldsContent.GetITemString(llRowPos,'l_code'))
			idw_detail.SetITem(llNewRow,'d_location',lsReplenishmentL_Code)
			idw_detail.SetITem(llNewRow,'Owner_id',ldsContent.GetITemNumber(llRowPos,'Owner_id'))
			idw_detail.SetITem(llNewRow,'Country_of_origin',ldsContent.GetITemString(llRowPos,'Country_of_origin'))
			idw_detail.SetITem(llNewRow,'Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type'))
			idw_detail.SetITem(llNewRow,'Transfer_Detail_New_Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type')) /* 09/15 - PCONKL*/
			idw_detail.SetITem(llNewRow,'Lot_No',ldsContent.GetITemString(llRowPos,'Lot_No'))
			idw_detail.SetITem(llNewRow,'Serial_No',ldsContent.GetITemString(llRowPos,'Serial_No'))
			idw_detail.SetITem(llNewRow,'po_no',ldsContent.GetITemString(llRowPos,'po_no'))
			idw_detail.SetITem(llNewRow,'po_no2',ldsContent.GetITemString(llRowPos,'po_no2'))
			idw_detail.SetITem(llNewRow,'Container_id',ldsContent.GetITemString(llRowPos,'Container_id'))
			idw_detail.SetITem(llNewRow,'expiration_date',ldsContent.GetITemDateTime(llRowPos,'Expiration_date'))
				
			// 09/15 - PCONKL - If already released to mobile, set row mobile status to new
			If idw_Main.GetITemString(1,'mobile_Enabled_Ind') = 'Y' Then
				idw_Detail.SetItem(llNewRow,'mobile_status_Ind','N')
			else
				idw_Detail.SetItem(llNewRow,'mobile_status_Ind','')
			End If

			// 09/15 - PCONKL - Set Line Item Number and default content record created
			idw_Detail.SetItem(llNewRow,'Line_Item_No',llNewRow)
			idw_Detail.SetItem(llNewRow,'Content_record_created_Ind',"N")
				
				
			//Either take the entire COntent Record or jsut what we need to fulfill
			If llNeededQty >= llQty Then
				idw_detail.SetITem(llNewRow,'Quantity',llQty)
			Else
				idw_detail.SetITem(llNewRow,'Quantity',llNeededQty)
			End If
				
			llNeededQty = llNeededQty - llQty
			ls_detail_sku = ldsContent.GetITemString(llRowPos,'SKU')
			ls_detail_suppcode = ldsContent.GetITemString(llRowPos,'supp_code')
				
			IF i_nwarehouse.of_item_master(gs_project, ls_detail_sku, ls_detail_suppcode ) > 0 THEN
		
				llRow =i_nwarehouse.ids.Getrow()
		
				If upper(i_nwarehouse.ids.GetItemString(llRow,"serialized_ind")) ='B' Then
					idw_detail.SetItem(llNewRow,'serialized_ind', 'Y')
				else
					idw_detail.SetItem(llNewRow,'serialized_ind', 'N')
				End If
			END IF
		
		Next
			
	Next /*Next Repenishment SKU*/
//TAM 2018/05  - S19741 - Added Repenishment RB -End
	
Else /* not including open orders*/	
	
	For llRowPos = 1 to llrowCount
	
		llNewRow = idw_detail.InsertRow(0)
	
		If idw_Main.GetITemString(1,'TO_NO') > '' Then
			idw_detail.SetITem(llNewRow,'to_no',idw_Main.GetITemString(1,'TO_NO'))
		End If
	
		idw_detail.SetITem(llNewRow,'SKU',ldsContent.GetITemString(llRowPos,'SKU'))
		idw_detail.SetITem(llNewRow,'supp_Code',ldsContent.GetITemString(llRowPos,'supp_code'))
		idw_detail.SetITem(llNewRow,'s_location',ldsContent.GetITemString(llRowPos,'l_code'))
		idw_detail.SetITem(llNewRow,'Owner_id',ldsContent.GetITemNumber(llRowPos,'Owner_id'))
		idw_detail.SetITem(llNewRow,'Country_of_origin',ldsContent.GetITemString(llRowPos,'Country_of_origin'))
		idw_detail.SetITem(llNewRow,'Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type'))
		idw_detail.SetITem(llNewRow,'Transfer_Detail_New_Inventory_Type',ldsContent.GetITemString(llRowPos,'Inventory_Type')) /* 09/15 - PCONKL */
		idw_detail.SetITem(llNewRow,'Lot_No',ldsContent.GetITemString(llRowPos,'Lot_No'))
		idw_detail.SetITem(llNewRow,'Serial_No',ldsContent.GetITemString(llRowPos,'Serial_No'))
		idw_detail.SetITem(llNewRow,'po_no',ldsContent.GetITemString(llRowPos,'po_no'))
		idw_detail.SetITem(llNewRow,'po_no2',ldsContent.GetITemString(llRowPos,'po_no2'))
		idw_detail.SetITem(llNewRow,'Container_id',ldsContent.GetITemString(llRowPos,'Container_id'))
		idw_detail.SetITem(llNewRow,'expiration_date',ldsContent.GetITemDateTime(llRowPos,'Expiration_date'))
		idw_detail.SetITem(llNewRow,'Quantity',ldsContent.GetITemNumber(llRowPos,'quantity'))
		
		// If to Loc populated, defaut Transfer To Loc
		If lsToLoc > '' Then			
			idw_detail.SetITem(llNewRow,'D_location',lsToLoc)
		End If
			//TimA Commend out 08/06/14
		//f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'Not including open orders trasnfer detail  wf_generate_Detail:'  &
		//+ 'SKU: ' +ldsContent.GetITemString(llRowPos,'SKU') + ' - supp_code: ' + ldsContent.GetITemString(llRowPos,'supp_code') &
		//+' - FromLoc: ' +ldsContent.GetITemString(llRowPos,'l_code') + ' - Ownerid: ' + string(ldsContent.GetITemNumber(llRowPos,'Owner_id')) &
		//+ ' - COO: ' +ldsContent.GetITemString(llRowPos,'Country_of_origin') + ' - InvType: ' + ldsContent.GetITemString(llRowPos,'Inventory_Type') &
		//+ ' - LotNo: ' +ldsContent.GetITemString(llRowPos,'Lot_No') + ' - SerialNo: ' + ldsContent.GetITemString(llRowPos,'Serial_No') &
		//+ ' - PoNo: ' +ldsContent.GetITemString(llRowPos,'po_no') + ' - PoNo2: ' + ldsContent.GetITemString(llRowPos,'po_no2') &
		//+ ' - ContainerId: ' + ldsContent.GetITemString(llRowPos,'Container_id') + ' - Exp date: ' + string(ldsContent.GetITemDateTime(llRowPos,'Expiration_date') ,'mm/dd/yyyy hh:mm') &
		//+ ' - Qty: ' + string(ldsContent.GetITemNumber(llRowPos,'quantity')) + ' - toLoc: '+ lsToLoc,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		
		
		//10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No. - START
		ls_detail_sku = ldsContent.GetITemString(llRowPos,'SKU')
		ls_detail_suppcode = ldsContent.GetITemString(llRowPos,'supp_code')
		
		IF i_nwarehouse.of_item_master(gs_project, ls_detail_sku, ls_detail_suppcode ) > 0 THEN

			llRow =i_nwarehouse.ids.Getrow()

			If upper(i_nwarehouse.ids.GetItemString(llRow,"serialized_ind")) ='B' Then
				idw_detail.SetItem(llNewRow,'serialized_ind', 'Y')
			else
				idw_detail.SetItem(llNewRow,'serialized_ind', 'N')
			End If
		END IF
		//10-Apr-2017 :Madhu PEVS-424- Stock Transfer Serial No. - END
		
	Next
	
End If

//Gailm 9/17/2018 S23453 F10296 I1526 Rema Replenishment
idw_detail.SetSort('lot_no A')
idw_detail.Sort()

SetPointer(arrow!)

Tab_main.SelectTab(2)

f_method_trace_special( gs_project, this.ClassName() + ' - wf_generate_detail', 'End  wf_generate_Detail:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added		

if  gs_project =  'WS-AWI' or gs_project = 'WS-BM' or gs_project = 'WS-MHD' or gs_project = 'WS-MUSER' or gs_project = 'WS-PR' then
	idw_detail.Modify("lot_no.width=600 lot_no_t.width=600") //SARUN2014JAN08 : Visible column lot_no for WS* projects
end if

//TimA 11/24/14 reset the dw_sku and add a blank row.
tab_main.tabpage_main.dw_sku.Reset()
tab_main.tabpage_main.dw_sku.InsertRow(0)

Return 0
end function

public function integer wf_check_status_mobile ();
String	lsWarehouse, lsFindStr, lsMobileStatus, lsordStatus
Integer	i

idw_mobile.Object.Datawindow.ReadOnly = False

// F10 unlock may have changed these settings...
idw_mobile.Object.mobile_status_Ind.Protect = True
idw_mobile.Modify("mobile_status_Ind.Background.Color = '12639424'")
	
idw_Detail.Object.mobile_status_Ind.Protect = True
idw_Detail.Modify("mobile_status_Ind.Background.Color = '12639424'")


lsOrdStatus = idw_main.GetItemString(1, "ord_status")
lsMobileStatus = idw_main.GetItemString(1, "mobile_status_Ind")
If isNull(lsMobileStatus) Then lsMobileStatus = ''

lsWarehouse = idw_main.GetItemString(1, "s_warehouse")
lsFindStr = "wh_code = '" + lsWarehouse + "'"
i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
If i > 0 Then
	
	If g.ids_project_warehouse.GetItemString(i, "Mobile_Enabled_Ind") = 'Y' Then
		
		idw_mobile.visible = true
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=true mobile_Status_ind_t.visible=true")
		
		//Search Fields
		idw_result.Modify("mobile_status_ind.visible=true mobile_status_ind_t.visible=true")
		idw_search.Modify("mobile_status.visible=true mobile_status_t.visible=true")
		
		//Detail fields
		idw_Detail.Modify("mobile_status_ind.visible=true mobile_status_Ind_t.visible=true mobile_current_action.visible=true mobile_current_action_t.visible=true mobile_transfer_by.visible=true mobile_transfer_by_t.visible=true mobile_transfer_start_time.visible=true mobile_transfer_start_time_t.visible=true mobile_transfer_Complete_time.visible=true mobile_transfer_complete_time_t.visible=true")
			
	Else /* Not mobile Enabled */
		
		idw_mobile.visible = False
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false")
		
		//Search Fields
		idw_result.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Search.Modify("mobile_status.visible=false mobile_status_t.visible=false")
		
		//Detail Fields
		idw_Detail.Modify("mobile_status_ind.visible=false mobile_status_Ind_t.visible=false mobile_current_action.visible=false mobile_current_action_t.visible=false mobile_transfer_by.visible=false mobile_transfer_by_t.visible=false mobile_transfer_start_time.visible=false mobile_transfer_start_time_t.visible=false mobile_transfer_Complete_time.visible=false mobile_transfer_complete_time_t.visible=false")
			
	End If
	
else
	
		idw_mobile.visible = False
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false")
		
		//Search Fields
		idw_result.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Search.Modify("mobile_status.visible=false mobile_status_t.visible=false")
		
		//Detail Fields
		idw_Detail.Modify("mobile_status_ind.visible=false mobile_status_Ind_t.visible=false mobile_current_action.visible=false mobile_current_action_t.visible=false mobile_transfer_by.visible=false mobile_transfer_by_t.visible=false mobile_transfer_start_time.visible=false mobile_transfer_start_time_t.visible=false mobile_transfer_Complete_time.visible=false mobile_transfer_complete_time_t.visible=false")
			
	
End If

If lsMobileStatus = 'D' or lsMobileStatus = 'C' or lsOrdStatus = 'C' Then
	idw_mobile.Object.Datawindow.ReadOnly = True
Else
	if lsOrdStatus <> 'C' Then
		idw_mobile.Object.Datawindow.ReadOnly = False
	End If
End If

//Can only confirm if Complete or Discrepancy (or no status)
If lsMobileStatus = 'D' or lsMobileStatus = 'C' or lsMobileStatus = '' or isNull(lsMobileStatus) Then
	
Else
	tab_main.tabpage_main.cb_confirm.Enabled = False
End If

//Order based validations...
//If released to mobile, can't make any changes to Transfer List unless it is a discrepancy in which case, we'll allow a new row to be inserted and the discrepent row modified
If lsMobileStatus <> '' Then
		
	
	
	// Only allow Release to mobile box to be checked/unchecked if status is blank or released and Putawa List exists
	If (lsMObileStatus = '' or lsMobileStatus = 'R' or isNull(lsMobileStatus)) Then
		idw_mobile.Modify("mobile_Enabled_ind.Protect=0")
	Else
		idw_mobile.Modify("mobile_Enabled_ind.Protect=1")
	End If
	
	
	
	
	
		
End If

		
REturn 0
end function

public function string wf_validate_single_project_rule (string as_l_code, long al_row);String ls_return, ls_sku, ls_serial_ind, ls_po_no, ls_sku_retrieved, ls_warehouse, ls_find, ls_cust_cd, ls_oracle_integrated, ls_supp_code, ls_uf18
Long ll_owner_id, ll_found_row
SetNull( ls_return )

// LTK 20151214  Pandora #1002 SOC and GPN serial tracked inventory segregation
// If the SKU is serial tracked, then ensure the location has the same Owner/GPN/Project
if gs_project = 'PANDORA' then
	if ib_is_pandora_single_project_location_rule_on then

		ll_owner_id = idw_detail.GetItemNumber( al_row, 'Owner_Id' )
		ls_sku = Upper( Trim( idw_detail.GetItemString( al_row, 'sku' ) ))
		ls_serial_ind = Upper( Trim( idw_detail.GetItemString( al_row, 'Serialized_Ind' ) ))
		ls_po_no = Upper( Trim( idw_detail.GetItemString( al_row, 'Po_No' ) ))
		ls_warehouse = getWarehouse()
		ls_supp_code = idw_detail.GetItemString( al_row, 'Supp_Code' )

		if ls_serial_ind = 'B' or ls_serial_ind = 'O' or ls_serial_ind = 'Y' then

			ls_cust_cd = idw_main.Object.User_Field2[ 1 ]
			
			if Len( ls_cust_cd ) > 0  then		// shouldn't be null but let's check

				SELECT user_field5
				INTO :ls_oracle_integrated
				FROM Customer
				WHERE Project_ID = :gs_project
				AND Cust_Code = :ls_cust_cd
				USING SQLCA;

				if Upper( Trim( ls_oracle_integrated )) = 'Y' then

					SELECT user_field18
					INTO :ls_uf18
					FROM Item_Master
					WHERE Project_ID = :gs_project
					AND SKU = :ls_sku
					AND Supp_Code = :ls_supp_code
					USING SQLCA;
					
					if Upper( Trim( ls_uf18 )) = 'N' then
						// Skip this rule
					else

						SELECT MAX(sku) 
						INTO :ls_sku_retrieved
						FROM Content
						WHERE  project_id = :gs_project
						AND wh_code = :ls_warehouse
						AND l_code = :as_l_code
						AND sku = :ls_sku
						AND owner_id = :ll_owner_id
						AND po_no <> :ls_po_no
						Using SQLCA;

						if Len( ls_sku_retrieved ) > 0 then
							ls_return = "This GPN is serialized and the Location entered already contains inventory for this GPN with a different Project!"
						end if

						// Check the datawindow for violations of the rule
						if IsNull( ls_return ) then
				//			ls_find = "sku = '" + ls_sku + "' and D_Location = '" + as_l_code + "' and owner_id = " + String( ll_owner_id ) + " and po_no <> '" + ls_po_no + "'"
							ls_find = "D_Location = '" + as_l_code + "' and po_no <> '" + ls_po_no + "'"
							ll_found_row = idw_detail.Find( ls_find, 1, idw_detail.RowCount() + 1 )
							if ll_found_row > 0 then
								ls_return = "This window already contains a GPN in this Location with a different Project Code!"
							end if
						end if
					end if
				end if
			end if
		end if
	end if
end if

Return ls_return

end function

public function integer wf_check_toloc_cc (string assku, string assuppcode, string astoloc);//08-Apr-2017 Madhu PEVS-461 Validate ToLoc is in Cycle Count
String lsSql, lsError, lsFind
long ll_findrow

Datastore lds_content


lds_content =create Datastore

lsSql =" select * from Content with(nolock) "
lsSql += " where Project_Id ='"+ gs_project +"' and sku ='"+assku+"'"
lsSql += " and supp_code ='"+ assuppcode+"' and l_code ='"+astoloc+"'"

lds_content.create( SQLCA.syntaxfromsql( lsSql, "", lsError))
lds_content.settransobject( SQLCA)	
lds_content.retrieve( )

lsFind ="Inventory_Type ='*'" //cycle count Location's have Inventory type value as '*'

ll_findrow =lds_content.find( lsFind, 1, lds_content.rowcount())

destroy lds_content

return ll_findrow
end function

public function integer wf_sku_tracked_by_validation ();//19-Jan-2018 :Madhu S15155 - Foot Print
//a. check whether SKU is Tracked By: Serialized Ind(B), PoNo2(Y), Container Id(Y)
//b. If above all are TRUE, Is SKU being transfered as Full Pallet? If not, prompt a message to user.

string ls_sku, ls_supp, ls_serial_Ind, ls_pono2_Ind, ls_container_Ind, lsFind
string	ls_pono2, ls_prev_sku, ls_wh, ls_prev_pono2
long	ll_count, llFindRow, ll_detail_row, ll_detail_qty, ll_row, ll_tfr_In_qty

ls_wh = idw_main.getItemString( 1, 's_warehouse')

For ll_row =1 to idw_detail.rowcount()

		ll_tfr_In_qty =0
		ll_detail_qty = 0
		
		ls_sku = idw_detail.getItemString( ll_row, 'sku')
		ls_supp =idw_detail.getItemString( ll_row, 'supp_code')
		ls_pono2 = idw_detail.getItemString(ll_row, 'po_no2')
		
		If ls_sku <> ls_prev_sku Then
			ll_count = i_nwarehouse.of_item_master( gs_project, ls_sku, ls_supp)
			lsFind ="Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"' and supp_code ='"+ls_supp+"'"
			llFindRow = i_nwarehouse.ids.find( lsFind, 1, i_nwarehouse.ids.rowcount())
			
			ls_serial_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Serialized_Ind')
			ls_pono2_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'PO_No2_Controlled_Ind')
			ls_container_Ind = i_nwarehouse.ids.getItemString(llFindRow, 'Container_Tracking_Ind')
		End If
		
		If ls_serial_Ind ='B' and ls_pono2_Ind ='Y' and ls_container_Ind ='Y'  and (ls_sku <> ls_prev_sku  or ls_pono2 <> ls_prev_pono2) Then

			//get sum(qty) from transfer detail against PoNo2.
			lsFind ="sku = '"+ls_sku+"' and supp_code ='"+ls_supp+"' and po_no2 ='"+ls_pono2+"'"
			ll_detail_row = idw_detail.find( lsFind, 1, idw_detail.rowcount())
			
			DO WHILE ll_detail_row > 0
				ll_detail_qty += idw_detail.getItemNumber( ll_detail_row, 'quantity')
				ll_detail_row = idw_detail.find( lsFind, ll_detail_row +1, idw_detail.rowcount()+1)
			LOOP
			
			//get sum(avail_Qty) from Content and compare against Transfer Qty.
			select sum(avail_qty + tfr_In) into :ll_tfr_In_qty from Content_summary with(nolock)
			where Project_Id =:gs_project and wh_code= :ls_wh
			and sku=:ls_sku and supp_code =:ls_supp and PO_No2=:ls_pono2
			using sqlca;
			
			If IsNull(ll_tfr_In_qty) Then ll_tfr_In_qty =0
			
			If ll_detail_qty <> ll_tfr_In_qty Then
				//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
						//MessageBox("Stock Transfer", "Pallet/Carton must be split through the Stock Adjustment function first!" &
						// +"~n~rPalletId# "+ls_pono2+" , Transfer Pallet Qty# "+string(ll_detail_qty) +"  Avail Inventory Pallet Qty# "+string(ll_tfr_In_qty), StopSign!)
				 
				 
				 
				 
//				tab_main.selecttab(2)
//				f_setfocus(idw_detail, ll_row, "po_no2")
//				Return -1
			End If
		
			ls_prev_sku =ls_sku
			ls_prev_pono2 = ls_pono2
			
		End IF
Next

Return 0
end function

public function integer wf_check_full_pallet_container ();//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers

long ll_idx, ll_Count, ll_Qty, ll_This_Alloc, llAvailQty, llAllocContainers, llEmptyContainers, modifiedrow, llThisOrder
long llFootprintSerialNumbersPresent
string ls_sku, ls_Supplier, ls_pono_2, ls_whcode, ls_container_id, lsOrderNbr, lsOrderType, lsThisOrder, lsThisOrderType
string lsSharedContainer, lsLocation, lsMixedType, lsFilter, lsToNo, lsDashed
string lsMsg1, lsMsg2, lsMsg3, lsMsg4, lsMsg5
string lsMixedContFlag, lsGPNConversionFlag
int liRtn, liDashed
boolean lbFootprint, lbAllocated, ibMixedContainerization, lbLooseSerials, lbDashedFootprint
str_parms lstr_parms
u_ds_ancestor ldsSerial

lsMixedContFlag = f_retrieve_parm("PANDORA","FLAG","CONTAINERIZATION")
lsGPNConversionFlag = f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION")
liRtn = 0

IF gs_project <> 'PANDORA' THEN Return 0 

ldsSerial = Create u_ds_ancestor
ldsSerial.dataobject = 'd_serial_container'
ldsSerial.SetTransObject(SQLCA)

ibFootprintAlloc = TRUE
lsOrderNbr = ""
lsOrderType = ""
lsMsg1 = ""
lsMsg2 = ""
lsMsg3 = ""
lsMsg4 = ""
lsMsg5 = ""
lsDashed = ""
lsThisOrder = idw_detail.GetItemString(1,"to_no")

FOR ll_idx  = 1 to idw_detail.RowCount()

	ls_sku = idw_detail.GetItemString( ll_idx, "sku")
	ls_Supplier =  idw_detail.GetItemString( ll_idx, "supp_code")
	ls_pono_2	=  idw_detail.GetItemString( ll_idx, "po_no2")
	ls_container_id = idw_detail.GetItemString( ll_idx, "container_id")
	ls_whcode = idw_main.getItemString(1, 's_warehouse')
	lsLocation = idw_detail.GetItemString( ll_idx, "s_location")
	lsToNo = idw_main.getItemString(1, 'to_no')
	ll_Qty =   idw_detail.GetItemNumber( ll_idx, "quantity")
	lbLooseSerials = (ls_pono_2 = gsFootPrintBlankInd and ls_container_id = gsFootPrintBlankInd)
	lbDashedFootprint = (ls_pono_2 = "-" or ls_container_id = "-")
	lbAllocated = FALSE
	lbFootprint = f_is_sku_foot_print(ls_sku, ls_Supplier)
	
	If lbFootprint and lsGPNConversionFlag = 'Y' Then
		llFootprintSerialNumbersPresent = f_footprint_serial_numbers(ls_sku, ls_whcode, lsLocation, ls_pono_2, ls_container_id, ll_Qty)
		If llFootprintSerialNumbersPresent <> 0 and not lbDashedFootprint Then
			lsMsg4 += "Footprint GPN " + ls_sku + " must contain serial numbers for pallet " + ls_pono_2 + " and container " + ls_container_id + "."
			If ll_Qty < llFootprintSerialNumbersPresent Then		//Quantity required is less that difference between Content and Serial Number Inventory
				lsMsg4 += "~n~r~n~rDetail row " + string(ll_idx) + " requires " + string(ll_Qty) + " serial numbers.  Missing serial numbers"
				lsMsg4 += " for this WH/GPN/Loc/Pallet/Container: " + string(llFootprintSerialNumbersPresent)
			Else
				lsMsg4 += "~n~rThere are " + string(ABS(llFootprintSerialNumbersPresent)) + " missing serial numbers for this WH/GPN/Loc/Pallet/Container." 
			End If
			lsMsg4 += "~n~r~n~rDouble-click pick list ContainerId column to enter serial numbers. " 

			idw_detail.SetItem(ll_idx, "color_code", "9")
			idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			idw_detail.SetItem(ll_idx, "mixed_type", "N")
			idw_detail.SetItemStatus(ll_idx, "mixed_type", Primary!, NotModified! )
			//ibSplitContainerRequired = TRUE
			If lbFootprint and (ls_pono_2 = '-' or ls_container_id = '-') Then
				lsDashed += string(ll_idx) + "  "
			End If
	
			continue
			//return liRtn  Don't return just because you found this!
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
				
				ll_count = ldsSerial.RowCount()
				If ll_Qty <> ll_count Then
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
		Else
			ibMixedContainerization = FALSE
			lsMixedType = "N"		//Loose serials
			If lbFootprint and (ls_pono_2 = '-' or ls_container_id = '-') Then
				lsDashed += string(ll_idx) + "  "
			End If
		End If
		
	//Is is a Footprint GPN and not a default pallet and container then check for split
	//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
	//If lbFootprint and ls_pono_2 <> '-' and ls_container_id <> '-' then
	If lbFootprint and lsMixedType <> 'S' then		//not loose serials
		SetMicroHelp("Checking for pallet allocation")
		SetPointer(HourGlass!)
		
		lstr_parms = f_is_footprint_allocated( ls_pono_2, ls_container_id, idw_detail, ls_whcode, ls_sku )
		lsOrderNbr = lstr_parms.String_Arg[1]
		lsOrderType = lstr_parms.String_Arg[2]
		lsSharedContainer = lstr_parms.String_Arg[3]
		lsThisOrderType = lstr_parms.String_Arg[4]
		llAvailQty = lstr_parms.Long_Arg[1]
		llEmptyContainers = lstr_parms.Long_Arg[2]
		llAllocContainers = lstr_parms.Long_Arg[3]
		llThisOrder = lstr_parms.Long_Arg[4]
		
		SetMicroHelp("Continuing with pallet/container discovery...")
		
		IF lsOrderNbr <> "" and llThisOrder > 0 and lsOrderNbr <> lsThisOrder Then

			CHOOSE CASE lsOrderType
				CASE "S"
					lsOrderNbr = "Outbound Order " + lsOrderNbr
				CASE "O"
					lsOrderNbr = "Stock Owner Change " + lsOrderNbr
				CASE "I"
					lsOrderNbr = "Stock Transfer " + lsOrderNbr
			END CHOOSE
			If lsMsg1 > "" Then lsMsg1 = lsMsg1 + "~r~n~r~n"
			lsMsg1 = "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" + &
						+ lsOrderNbr + " has allocated unit(s) for pallet " + ls_pono_2 + &
						" and cannot be split at this time.~n~r~n~r" + &
						"Pick another pallet and re-generate the pick list or wait for the other order to process."
			lbAllocated = TRUE		
			idw_detail.SetItem(ll_idx, "color_code", "6")
			idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			If lbFootprint and (ls_pono_2 = '-' or ls_container_id = '-') Then
				lsDashed += string(ll_idx) + "  "
			End If

			continue
		End If
		
		SELECT Count(*) INTO :ll_count 
			from Serial_Number_Inventory 
				where Project_Id =: gs_project
				and sku = :ls_sku
				and wh_code = :ls_whcode
				and po_no2 =:ls_pono_2
				and carton_id = :ls_container_id
				and l_code = :lsLocation
			USING SQLCA;
			
		IF Not lbAllocated Then
			If ll_Qty <> ll_count and llThisOrder > 0 and Not ibMixedContainerization Then		//This container requires split
				If lsMsg2 > "" Then lsMsg2 = lsMsg2 + "~r~n~r~n"
				lsMsg2 += "Footprint pallets/containers must remain full to be moved." + &
					"~rGPN " + ls_sku + " has a quantity of " + string(ll_Qty) + " and " + &
					" Containers: " +ls_container_id + " has " + string(ll_count) + " units." + &
					"  Pallet: " + ls_pono_2 + " units not included in~rthis move will have new pallet/container numbers." + &
					"~r~r~nDouble-click the container field on the Owner Change Detail screen to split the container."
				idw_detail.SetItem(ll_idx, "color_code", "5")
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			ElseIf llAllocContainers > 0 and llEmptyContainers > 0 and Not ibMixedContainerization Then
				lsMsg3 +=  "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" + &
					"There are " + string(llAllocContainers) + " full footprint container(s) with " +string(llEmptyContainers + llAllocContainers) + " containers in Pallet " + ls_pono_2 + "~r~n~r" + &
					"The extra container(s) must be moved to another pallet.  The allocated container(s) will retain the pallet id"
				idw_detail.SetItem(ll_idx, "color_code", "7")
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
			ElseIf ibMixedContainerization and ll_Qty <> ll_count and ll_count > 0 Then	//MCL needs split
				If lsMsg4 > "" Then lsMsg4 = lsMsg4 + "~r~n~r~n"
				lsMsg4 += "Footprint GPN " + ls_sku + " must maintain full pallet and containers.~n~r~n~r" + &
					"There are " + string(ll_count) + " units of mixed containerization at location " + lsLocation + " with " + string(ll_Qty) + " allocated.  " + &
					"Once identified, the serial number(s) allocated will be linked to this order for transfer."
				idw_detail.SetItem(ll_idx, "color_code", "8")
				idw_detail.SetItem(ll_idx, "mixed_type", lsMixedType)
				idw_detail.SetItemStatus(ll_idx, "color_code", Primary!, NotModified! )
				idw_detail.SetItemStatus(ll_idx, "mixed_type", Primary!, NotModified! )
			End If
		End IF
	END IF
	
	If lbFootprint and (ls_pono_2 = '-' or ls_container_id = '-') Then
		lsDashed += string(ll_idx) + "  "
	End If
	
	lbAllocated = FALSE
NEXT

If lsMsg1 > "" Then			//Pallet is allocated, stop	(6)
	MessageBox ("Pallet / Container Warning", lsMsg1 )
End If

If lsMsg2 > "" Then		//Need to split	(5)
	MessageBox ("Pallet / Container Warning", lsMsg2 )
End If

//If lsMsg3 > "" and  llThisOrder > 0 Then		//Full containers, excess containers (7)	
If lsMsg3 > "" Then		//Full containers, excess containers (7)	
	messagebox("Full Footprint Containers", lsMsg3)
End If

//If lsMsg4> "" and  llThisOrder > 0 Then		//Mixed containerization needs split (8)	
If lsMsg4 > "" Then		//Mixed containerization needs split (8)	
	messagebox("Footprint Containers Mixed Containerization", lsMsg4)
End If

//If lsMsg5 	Detail row with a dash in pallet and/or container	IF THIS A GOOD PLACE TO AUTOMATICALLY CHANGE FOOTPRINT DASHES TO NA?
//If lsDashed > "" Then		
//	lsMsg5 += "Footprint GPN in row(s) " + lsDashed+ " has/have pallet and/or container with default dash (-) and cannot be processed as a footprint.~n~r"
//	lsMsg5 += "To modify the pallet/container, double-click on containerID for the row.  The window will display to allow change of pallet/container..~n~r"
//	lsMsg5 += "Default pallet/container for a footprint GPN is "  + gsFootPrintBlankInd + ".  "
//
//	messagebox("Footprint Containers Mixed Containerization", lsMsg5)
//End If

SetMicroHelp("Ready")
SetPointer(Arrow!)

If lsMsg1 > "" or lsMsg2 > "" or lsMsg3 > "" or lsMsg4 > "" or lsMsg5 > "" Then
	tab_main.SelectTab(2)
	tab_main.tabpage_detail.SetFocus()
	idw_detail.SetColumn("container_id")
	idw_detail.SetFocus()
	idw_detail.ScrollToRow(1)
	Return -1
End If

Return 0
end function

event open;call super::open;DatawindowChild	ldwc, ldwc2
String				lsFilter
i_nwarehouse = create n_warehouse
iw_window = This
tab_main.MoveTab(2, 4)

ilHelpTopicID = 528 /*set help topic */

gs_method_log_Flag ='Y'
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - ue_Open', 'Start ue_Open:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

end event

on w_tran.create
int iCurrent
call super::create
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_tran.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

If idw_main.rowcount() =1 Then
	isToNo = idw_main.GetItemString(1, "to_no")
	This.Title = is_title + " - Edit" + " - " + isToNo
Else
	This.Title = is_title + " - Edit" 
End If

ib_edit = True
ib_changed = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

wf_clear_screen()

tab_main.tabpage_main.cb_clear_gen.triggerEvent('clicked')

isle_code.DisplayOnly = False
isle_code.BackColor = rgb(255,255,255) /* 10/00 PCONKL - set to white when enterable*/
isle_code.TabOrder = 10
isle_code.SetFocus()


end event

event ue_save;Integer li_ret,li_ret_l,li_ret_ll,li_return
long i,ll_totalrows, ll_no,ll_rtn, ll_cnt
String ls_prefix, ls_order,ls_Message,ls_status
ls_Message = "Record Saved !!!"
IF f_check_access(is_process,"S") = 0 THEN Return -1

// Validations

// pvh 11/30/05 - gmt
datetime ldtToday

if idw_main.rowcount() > 0 then
	ldtToday = f_getLocalWorldTime( idw_main.object.s_warehouse[ 1 ] ) 
else
	ldtToday = f_getLocalWorldTime( gs_default_wh ) 
end if

f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'Start ue_save:' ,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

string ls_user_field2, ls_s_warehouse
//Jxlim 11/20/2012 Pandora FWD Pick BRD #464 no message necessary for zero record.
ll_cnt = idw_detail.Rowcount()
if gs_Project = 'PANDORA'  and ll_cnt >  0 Then	
	ls_user_field2 = idw_main.GetItemString(1, 'user_field2')
	ls_s_warehouse = idw_main.GetItemString(1, 's_warehouse')
	
f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'Process ue_save:' + ' User_Field2: '+ ls_user_field2 + '- warehouse: '+ ls_s_warehouse ,isToNo, ' ',' ',ls_order) //04-Sep-2013  :Madhu added

   if IsNull(ls_s_warehouse) OR trim(ls_s_warehouse) = '' then
		
		MessageBox ("Source Warehouse Required", "You must enter a source warehouse.")
		
		idw_main.SetColumn("s_warehouse")
		idw_main.SetFocus()
		
		Return -1
		
	end if	
	
	
   if IsNull(ls_user_field2) OR trim(ls_user_field2) = '' then
		
		MessageBox ("Sub-Inventory Required", "You must enter a sub-inventory.")
		
		idw_main.SetColumn("user_field2")
		idw_main.SetFocus()
		
		Return -1
		
	end if
	
end if

SetPointer(HourGlass!)
If idw_main.RowCount() > 0 Then
	
	If wf_validation() = -1 Then
		
		SetMicroHelp("Save failed!")
		Return -1
		
	End If
	
	// pvh - 02/14/06 - gmt
	idw_main.SetItem(1,'last_update', ldtToday ) 
	//idw_main.SetItem(1,'last_update', datetime(today(),now() ) ) 
	idw_main.SetItem(1,'last_user',gs_userid)
	
End If

// Assign Order No.

If not ib_edit  Then
// 10/00 PCONKL - Using Stored procedure to get next available RO_NO
//						Prefixing with Project ID to keep Unique within System
		
	ll_no = g.of_next_db_seq(gs_project,'Transfer_Master','TO_No')
	
	If ll_no <= 0 Then
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


// Updating the Datawindow
// 04/05 - PConkl - status = 'X' is FWD Pick replenishment pending. Don't update content because the Detail COntent records don't exist
//						Detail records were created remotely for a fwd pick replenishment transfer
If idw_main.RowCount() > 0 Then
	
	If idw_main.GetItemString(1,"ord_status") <> "C" and idw_main.GetItemString(1,"ord_status") <> "D" and idw_main.GetItemString(1,"ord_status") <> "X" Then /* 09/15 - PCONKL - Added 'D' for Discrepancy (mobile) */
	
		If wf_update_content() = -1 Then
			
			// If we are exectuing the FWD Pick Replenishment and it fails, reset the status to Pending
			If idw_main.GetItemString(1,"ord_status",Primary!,True) = "X" then
				idw_main.SetItem(1,'ord_status','X')
			End If
			
			return -1
			
		Else
			
			//If FWD Pick executuin was successfull, disable button
			If idw_main.GetItemString(1,"ord_status",Primary!,True) = "X" then
				tab_main.tabpage_detail.cb_replenish.Enabled = False
				ibfwdpickpending = False
			End If
							
		End If
		
	End If		
	
Else
	li_ret = 1
End If

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then
	
	ls_status = idw_main.GetItemString(1,"ord_status")
	If  ls_status <> "C" and ls_status <> "D" and ls_status <> "V" and ls_status <> "X" Then /* 09/15 - PCONKL - Added 'D' for mobile Discrepancy*/
			idw_main.SetItem(1,"ord_status","P")
	End If	
	
	li_ret=idw_main.Update(False, False)
	
End If

f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'Process ue_save:' + 'Ord_Status: ' +ls_status,isToNo, ' ',' ',isToNo) //04-Sep-2013  :Madhu added

if li_ret = 1  then li_ret = idw_detail.Update(False, False)
if li_ret = 1  then li_ret = idw_dcontent.Update(False, False)
if li_ret = 1   then li_ret = idw_content.Update(False, False)

If idw_main.RowCount() = 0 and li_ret = 1 Then li_ret = idw_main.Update(False, False)

IF (li_ret = 1) THEN
	
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		
		idw_detail.ResetUpdate()
		idw_main.ResetUpdate()
		idw_dcontent.ResetUpdate()
		idw_content.ResetUpdate()	
		
		//BCR 13-JUL-2011: Zero Quantities Issue Resolution => Call stored proc to delete zero qty rows right after every successful 
		//Content table update. This way, we don't have to rely on the erratic update trigger for cleanup.
		li_return = SQLCA.sp_content_qty_zero()
		
		//Gailm 8/2/2018 S22208 F9984 I1026 Google Footprint Partial Containers for SOC and stock transfers
		If upper(gs_project) ='PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" and isOrderStatus <> 'V' and isOrderStatus <> 'C' Then
			wf_check_full_pallet_container()		//Check and report partial container pick but do not stop
		End If
		
		If idw_main.RowCount() > 0 Then 
			ib_changed = False
			ib_edit = True
			This.Title = is_title + " - Edit - " + isToNo
			wf_checkstatus()
			SetMicroHelp("Record Saved!")
			f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'End ue_save:' ,isToNo, ' ',' ',ls_order) //04-Sep-2013  :Madhu added
		End If
		Return 0
		
   ELSE
		
		Execute Immediate "ROLLBACK" using SQLCA;
		idw_dcontent.ResetUpdate()
		idw_content.ResetUpdate()
		MessageBox(is_title, SQLCA.SQLErrText)
		f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'End ue_save FAILED Rollback:' ,isToNo, ' ',' ',ls_order) //04-Sep-2013  :Madhu added
		Return -1
		
   END IF
	
ELSE
	
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, record save failed!")
	f_method_trace_special( gs_project, this.ClassName() + ' - ue_save', 'End ue_save   FAILED System Error:' ,isToNo, ' ',' ',ls_order) //04-Sep-2013  :Madhu added
	Return -1
	
END IF


end event

event ue_delete;call super::ue_delete;Long i, ll_cnt
string ls_null, lsMobileStatus

If f_check_access(is_process,"D") = 0 Then Return

//09/15 - PCONKL - Don't allow to delete if ant content records have been written or in process by mobile
lsMobileStatus = idw_main.GetITemString(1,'mobile_status_Ind')
if isnull(lsMobileStatus) then lsMobileStatus = ''

If lsMobileStatus = '' or lsMobileStatus = 'R' Then
Else
	MessageBox(is_title,"This Transfer cannot be deleted based on the current Mobile Status",StopSign!)
	Return
End If

If idw_detail.RowCOunt() > 0 Then
	
	If idw_Detail.Find("content_record_Created_Ind = 'Y'",1,idw_Detail.RowCount()) > 0 Then
		MessageBox(is_title,"This Transfer cannot be deleted - 1 or more Detail Records have already been posted to the Destination Location on the mobile device.",StopSign!)
	Return
	End If
	
End If

If Messagebox(is_title, "Are you sure you want to delete this Record?", Question!,yesno!,2) = 2 Then
	Return
else
	f_method_trace_special( gs_project, this.ClassName() + ' - ue_delete', 'Start ue_delete:' ,isToNo, ' ',' ',isToNo) //TimA moved
End If

SetPointer(HourGlass!)

ll_cnt = idw_detail.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_detail.deleterow( i )
Next

ib_changed = False

If wf_update_content() = -1 Then Return

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record	Deleted!")
	f_method_trace_special( gs_project, this.ClassName() + ' - ue_delete', 'End ue_delete Order Deleted:' ,isToNo, ' ',' ',isToNo) //TimA Added 08/06/14
Else
	SetMicroHelp("Record	deleted failed!")
	f_method_trace_special( gs_project, this.ClassName() + ' - ue_delete', 'End ue_delete FAILED:' ,isToNo, ' ',' ',isToNo) //TimA Added 08/06/14
End If
This.Trigger Event ue_edit()


end event

event ue_new;string ls_Prefix,ls_order
long ll_no
datawindowchild ldwc

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

// Clear existing data

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False

wf_clear_screen()

idw_main.InsertRow(0)
idw_main.SetItem(1,"project_id",gs_project)
idw_main.SetItem(1,"s_warehouse",gs_default_wh)
idw_main.SetItem(1,"d_warehouse",gs_default_wh)
idw_main.SetItem(1,'ord_type','I')
idw_main.SetItem(1,"ord_date",Today())
	
setWarehouse( gs_default_wh )
setOrderStatus( 'N' )

IF gs_Project = "PANDORA" then
	
	if Not IsNull(gs_default_wh) AND trim(gs_default_wh) <> '' then
	
		idw_main.GetChild("user_field2", ldwc)
	
		ldwc.Retrieve(upper(gs_project), gs_default_wh)

	end if
	
END IF
	

wf_checkstatus()

tab_main.tabpage_detail.Enabled = True

tab_main.tabpage_main.cb_clear_gen.triggerEvent('clicked')

idw_main.Show()
idw_main.SetFocus()

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
	//TimA Commend out 08/06/14
//f_method_trace_special( gs_project, this.ClassName() + ' - ue_print', 'Start ue_print:' ,isToNo, ' ',' ',ls_order) //04-Sep-2013  :Madhu added
end event

event resize;tab_main.Resize(workspacewidth(),workspaceHeight())

If g.ibMobileenabled Then
	tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-430)
Else
	tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-280)
End If

tab_main.tabpage_search.dw_result.Resize(workspacewidth() - 80,workspaceHeight()-500)


end event

event ue_postopen;call super::ue_postopen;DatawindowChild	ldwc, ldwc2, ldwc3, ldwc4, ldwc5
String				lsFilter
Long	i

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
idw_dcontent = tab_main.tabpage_detail.dw_detail_content
idw_content = tab_main.tabpage_detail.dw_content
idw_mobile = tab_main.tabpage_detail.dw_mobile

//DGM 09/26/00 Added the dddw for supplier

idw_detail.GetChild("supp_code",idwc_det_supplier)
isle_code = tab_main.tabpage_main.sle_orderno

idw_main.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_detail.SetTransObject(Sqlca)
idw_result.SetTransObject(Sqlca)
idw_content.SetTransObject(Sqlca)
idw_dcontent.SetTransObject(Sqlca)
dw_report.SetTransObject(Sqlca)

idw_main.shareData(idw_mobile) /* 09/15 - PCONKL */

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
	idw_main.object.user_field2.dddw.displaycolumn='cust_code'
	idw_main.object.user_field2.dddw.datacolumn='cust_code'

	idw_main.object.user_field2.dddw.useasborder='yes'
	idw_main.object.user_field2.dddw.allowedit='no'
	idw_main.object.user_field2.dddw.vscrollbar='yes'
	idw_main.object.user_field2.width="650"
	idw_main.object.user_field2.dddw.percentwidth="200"

	idw_main.object.user_field2.dddw.required='no'

	idw_main.object.user_field3_t.width="380"
	idw_main.object.user_field3_t.x="2339"	

	idw_main.GetChild("user_field2", ldwc)
	ldwc.SetTransObject(SQLCA)
	

end if


// 03/02 - PCONKL - Inv Type being retrieved by Project in n_warehouse
i_nwarehouse.of_init_inv_ddw(idw_detail) 

// pvh
setColorMint()

tab_main.tabpage_main.dw_generate.visible = False
tab_main.tabpage_main.dw_sku.visible = False
tab_main.tabpage_main.dw_generate.InsertRow(0) // 11/11 - PCONKL
idw_detail.GetChild('inventory_type',ldwc)
tab_main.tabpage_main.dw_generate.GetChild('inv_type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2)
tab_main.tabpage_main.dw_generate.GetChild('l_type',ldwc3)
ldwc3.SetTransObject(SQLCA)
ldwc3.Retrieve()

// LTK 20150824  Populate newly added column: New Inventory Type
idw_detail.GetChild('transfer_detail_new_inventory_type',ldwc5)
ldwc5.SetTransObject(SQLCA)
ldwc.ShareData( ldwc5 )

tab_main.tabpage_main.cb_clear_gen.triggerEvent('clicked')

// LTK 20150115  Commented out below as it is now controlled via a project setting
//if left(gs_project, 4) = 'NIKE' then
//	idw_detail.Object.quantity.EditMask.Mask = "#######"
//end if	

// LTK 20150115  Allow quantity decimals based on project flag.
if g.iballowquantitydecimals then
	idw_detail.Object.quantity.EditMask.Mask = '#######.#####'
else
	idw_detail.Object.quantity.EditMask.Mask = '#######'
end if

// 12/13 - PCONKL - Show Serial Transfer button if chain of custody is enabled for Project
if g.ibSNchainofCustody Then
	tab_main.tabpage_detail.cb_serial.visible = True
Else
	tab_main.tabpage_detail.cb_serial.visible = False
End If

//GailM 12/04/2018 DE7346 Google dynamic breadking - stock transfer
idsContentSummary = Create u_ds_ancestor
idsContentSummary.dataobject = 'd_content_summary_pallet'
idsContentSummary.SetTransObject(SQLCA)

idsContent = Create u_ds_ancestor
idsContent.dataobject = 'd_content_pallet'
idsContent.SetTransObject(SQLCA)

// 09/15 - PCONKL - Hide mobile if not enabled for project. will be enabled at warehouse level once an order selected
If not g.ibMobileEnabled Then
	
		idw_mobile.visible = False
		
		//Header fields
		idw_Main.Modify("mobile_status_ind.visible=false mobile_Status_ind_t.visible=false")
		
		//Search Fields
		idw_result.Modify("mobile_status_ind.visible=false mobile_status_ind_t.visible=false")
		idw_Search.Modify("mobile_status.visible=false mobile_status_t.visible=false")
		
		//Detail Fields
		idw_Detail.Modify("mobile_status_ind.visible=false mobile_status_Ind_t.visible=false mobile_current_action.visible=false mobile_current_action_t.visible=false mobile_transfer_by.visible=false mobile_transfer_by_t.visible=false mobile_transfer_start_time.visible=false mobile_transfer_start_time_t.visible=false mobile_transfer_Complete_time.visible=false mobile_transfer_complete_time_t.visible=false")
			
End If
		
// Default into edit mode
This.TriggerEvent("ue_edit")

end event

event close;call super::close;destroy i_nwarehouse
end event

event closequery;call super::closequery;
// 11/00 PCONKL - We want to display a warning if we are closing without confirming!

If idw_main.RowCount() > 0 and idw_detail.RowCount() > 0 Then
	If idw_main.GetItemString(1,'Ord_status') = 'C' or idw_main.GetItemString(1,'Ord_status') = 'V' or idw_main.GetItemString(1,'Ord_status') = 'X' Then
	Else /*not complete or void*/
		If MessageBox(is_title,'If you close this window without confirming the transfer,~rThe inventory being transferred will not be accounted for~ranywhere until you confirm this order!.~r~rAre you sure you want to exit?',Exclamation!,YesNo!,1) = 1 Then
			Return 0
		Else
			Return 1
		End If
	End If /*status? */
End If /*master row exists*/
end event

event ue_unlock;call super::ue_unlock;

// 08/15 - PCONKL - add ability to voerride mobile status fields if necessary
idw_mobile.Object.Datawindow.ReadOnly = False
idw_mobile.Object.mobile_Enabled_Ind.Protect = 0
	
idw_mobile.Modify("mobile_status_ind.Protect = 0")
idw_mobile.SetTabOrder("mobile_status_ind", 20)
idw_mobile.Modify("mobile_status_Ind.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")

idw_Detail.Object.Datawindow.ReadOnly = False
idw_Detail.Modify("mobile_status_ind.Protect = 0")
idw_Detail.Modify("Quantity.Protect = 0")
idw_Detail.SetTabOrder("mobile_status_ind", 20)
idw_Detail.Modify("mobile_status_ind.Background.Color = '" +  string(RGB(255, 255, 255)) + "'")
		

end event

event activate;call super::activate;//TimA 09/22/15 Global gs_System_No for logging database errors if they happen
gs_System_No = isToNo

end event

event deactivate;call super::deactivate;//TimA 09/22/15 Global system number for capturing database errors messages
gs_System_No = ''
end event

type tab_main from w_std_master_detail`tab_main within w_tran
event create ( )
event destroy ( )
integer x = 0
integer y = 0
integer width = 3814
integer height = 2035
integer textsize = -8
tabpage_detail tabpage_detail
end type

on tab_main.create
this.tabpage_detail=create tabpage_detail
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_detail}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_detail)
end on

event tab_main::selectionchanged;// For updating sort option
CHOOSE CASE newindex
	case 2
		im_menu.m_record.m_delete.Enable()
		idw_current =idw_detail //25-Jul-2014 : Madhu- Export Transfer Detail records
	CASE 3
		im_menu.m_record.m_delete.Disable()
		wf_check_menu(TRUE,'sort')
		idw_current = idw_result
		if idw_result.rowcount() > 0 then idw_result.Retrieve() // refresh search window
	Case Else		
		wf_check_menu(FALSE,'sort')
END CHOOSE

end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer x = 15
integer y = 90
integer width = 3785
integer height = 1933
string text = " Transfer Information "
rb_replenishment rb_replenishment
st_itemcount st_itemcount
rb_containerid rb_containerid
rb_pono2 rb_pono2
rb_pono rb_pono
rb_sku rb_sku
dw_sku dw_sku
cb_import_sku cb_import_sku
cb_clear_gen cb_clear_gen
cb_generate cb_generate
st_2 st_2
sle_orderno sle_orderno
cb_confirm cb_confirm
cb_void cb_void
dw_main dw_main
sle_count sle_count
dw_generate dw_generate
end type

on tabpage_main.create
this.rb_replenishment=create rb_replenishment
this.st_itemcount=create st_itemcount
this.rb_containerid=create rb_containerid
this.rb_pono2=create rb_pono2
this.rb_pono=create rb_pono
this.rb_sku=create rb_sku
this.dw_sku=create dw_sku
this.cb_import_sku=create cb_import_sku
this.cb_clear_gen=create cb_clear_gen
this.cb_generate=create cb_generate
this.st_2=create st_2
this.sle_orderno=create sle_orderno
this.cb_confirm=create cb_confirm
this.cb_void=create cb_void
this.dw_main=create dw_main
this.sle_count=create sle_count
this.dw_generate=create dw_generate
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_replenishment
this.Control[iCurrent+2]=this.st_itemcount
this.Control[iCurrent+3]=this.rb_containerid
this.Control[iCurrent+4]=this.rb_pono2
this.Control[iCurrent+5]=this.rb_pono
this.Control[iCurrent+6]=this.rb_sku
this.Control[iCurrent+7]=this.dw_sku
this.Control[iCurrent+8]=this.cb_import_sku
this.Control[iCurrent+9]=this.cb_clear_gen
this.Control[iCurrent+10]=this.cb_generate
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_orderno
this.Control[iCurrent+13]=this.cb_confirm
this.Control[iCurrent+14]=this.cb_void
this.Control[iCurrent+15]=this.dw_main
this.Control[iCurrent+16]=this.sle_count
this.Control[iCurrent+17]=this.dw_generate
end on

on tabpage_main.destroy
call super::destroy
destroy(this.rb_replenishment)
destroy(this.st_itemcount)
destroy(this.rb_containerid)
destroy(this.rb_pono2)
destroy(this.rb_pono)
destroy(this.rb_sku)
destroy(this.dw_sku)
destroy(this.cb_import_sku)
destroy(this.cb_clear_gen)
destroy(this.cb_generate)
destroy(this.st_2)
destroy(this.sle_orderno)
destroy(this.cb_confirm)
destroy(this.cb_void)
destroy(this.dw_main)
destroy(this.sle_count)
destroy(this.dw_generate)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer x = 15
integer y = 90
integer width = 3785
integer height = 1933
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

type rb_replenishment from radiobutton within tabpage_main
integer x = 95
integer y = 1565
integer width = 472
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Replenishment"
end type

event clicked;wf_checkstatus()	


end event

type st_itemcount from statictext within tabpage_main
integer x = 238
integer y = 1661
integer width = 344
integer height = 61
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Item Count:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_containerid from radiobutton within tabpage_main
integer x = 95
integer y = 1488
integer width = 384
integer height = 77
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Container ID"
end type

event clicked;dw_sku.Reset()
dw_sku.InsertRow(0)

wf_checkstatus()	
end event

type rb_pono2 from radiobutton within tabpage_main
integer x = 95
integer y = 1421
integer width = 384
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "PoNo2"
end type

event clicked;wf_checkstatus()	
end event

type rb_pono from radiobutton within tabpage_main
integer x = 95
integer y = 1344
integer width = 384
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "PoNo"
end type

event clicked;wf_checkstatus()		

end event

type rb_sku from radiobutton within tabpage_main
integer x = 95
integer y = 1277
integer width = 384
integer height = 77
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "SKU"
boolean checked = true
end type

event clicked;wf_checkstatus()		

end event

type dw_sku from datawindow within tabpage_main
integer x = 571
integer y = 1293
integer width = 742
integer height = 317
integer taborder = 40
string title = "none"
string dataobject = "d_sku_import_external"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String lsSKU,lsNewSql, lsFromLocSql
Long ll_foundrow

//TimA 11/24/14 Part of the Pandora #859.  This just makes entering a lot of containers easier.
//See if there was data already in the field.
lsSku = Nz(tab_main.tabpage_main.dw_sku.GetItemString(row,"sku"),'')

If RightTrim(data) <> '' Then
	ll_foundrow = This.Find("sku = '" + data + "'", 1, This.rowcount( ))
	If ll_foundrow > 0 Then
		Messagebox('Already Scanned','Item ' + RightTrim(data) + ' has already been entered')
		Return 1
	End if
End if

	If tab_main.tabpage_main.dw_sku.rowcount( ) >= 1 then
		If RightTrim(data) = ''  then
			tab_main.tabpage_main.dw_sku.DeleteRow(0)
		ElseIf lsSku = '' Then 
			tab_main.tabpage_main.dw_sku.InsertRow(0)
		End if
			tab_main.tabpage_main.sle_count.text = String(tab_main.tabpage_main.dw_sku.rowcount( )-1)
	 End if


end event

type cb_import_sku from commandbutton within tabpage_main
integer x = 874
integer y = 1661
integer width = 366
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import Field..."
end type

event clicked;
string is_filename, is_fullname

dw_sku.Reset()

GetFileOpenName("Open", is_fullname, is_filename,   "txt", "Text Files (*.txt)")

If FileExists(is_filename) Then
	dw_sku.ImportFile(is_filename)
Else
	//TimA 12/01/14 reset the dw_sku and add a blank row.
	tab_main.tabpage_main.dw_sku.Reset()
	tab_main.tabpage_main.dw_sku.InsertRow(0)
End If


end event

type cb_clear_gen from commandbutton within tabpage_main
integer x = 2765
integer y = 1571
integer width = 238
integer height = 83
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;Long	i
dw_generate.reset()
dw_generate.InsertRow(0)

dw_sku.Reset()
//TimA 11/24/14 The inserting of the row is now on the item changed event of the DW
tab_main.tabpage_main.sle_count.Text=String(0)
//For i = 1 to 5 //We don't want to just populate 5 rows.
	dw_sku.InsertRow(0)
//Next
end event

type cb_generate from commandbutton within tabpage_main
integer x = 2428
integer y = 1571
integer width = 282
integer height = 83
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;
wf_generate_detail()
end event

type st_2 from statictext within tabpage_main
integer x = 457
integer y = 61
integer width = 384
integer height = 77
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
string text = "Transfer Nbr:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_orderno from singlelineedit within tabpage_main
integer x = 823
integer y = 51
integer width = 625
integer height = 77
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
integer limit = 16
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_order, ls_wh_code, ls_serial_ind
Integer	lirc
long  ll_row, ll_detailcount 			//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No.
DatawindowChild	dwcFromLoc, ldwc

ls_order = This.Text
idw_main.Retrieve(ls_order,gs_project)

If idw_main.RowCount() > 0 Then
	// pvh 09/21/05
	setOrderNumber( ls_order )	
	setWarehouse( idw_main.getitemstring(1,'s_warehouse') )
	setToNo( idw_main.getitemstring(1,'to_no') )
	
	iw_window.Title = is_title + " - Edit" + " - " + isToNo		//Show ToNo on window title
	
	setOrderStatus( idw_main.getitemstring(1,'ord_status') )
	ll_detailcount =idw_detail.Retrieve(gs_project,ls_order) //03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No.
	wf_checkstatus()
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
		
	END IF
	
	//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - START
	For ll_row =1 to ll_detailcount
		ls_serial_ind = idw_detail.getitemstring( ll_row, 'serialized_ind')
		
		if upper(ls_serial_ind)='B' then
			idw_detail.setitem( ll_row, 'serialized_ind', 'Y')
		else
			idw_detail.setitem( ll_row, 'serialized_ind', 'N')
		end if
	NEXT
	//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No. - END
	
Else
	MessageBox(is_title, "Order not found, please enter again!", Exclamation!)
	This.SetFocus()
	This.SelectText(1,Len(ls_order))
End If
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 1273
integer y = 1811
integer width = 358
integer height = 109
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
integer x = 1818
integer y = 1811
integer width = 358
integer height = 109
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

idw_main.setitem(1,'ord_status','V')

setOrderStatus(idw_main.object.ord_status[ 1 ] )

If iw_window.Trigger Event ue_save() = 0 Then
	MessageBox(is_title, "Record voided!")
	
	Update Serial_Number_Inventory 
	Set serial_flag = 'N', do_no = '-', transaction_type = 'Reset serial flag on Stock Transfer Void', transaction_id = :isToNo
	Where do_no = :isToNo
	Using SQLCA;
	
Else
	MessageBox(is_title, "Record void failed!")
End If



end event

type dw_main from u_dw_ancestor within tabpage_main
integer x = 260
integer y = 157
integer width = 3112
integer height = 1037
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tran_master"
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

type sle_count from singlelineedit within tabpage_main
integer x = 589
integer y = 1661
integer width = 256
integer height = 61
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean border = false
end type

type dw_generate from datawindow within tabpage_main
integer x = 7
integer y = 1171
integer width = 3408
integer height = 621
integer taborder = 30
string title = "none"
string dataobject = "d_stock_transfer_generate_criteria"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String	lsWarehouse,lsWhere,lsNewSql
Long	llCount,lirc

Choose Case Upper(dwo.name)

case 'BEG_LOC', 'END_LOC'

	lsWarehouse = idw_Main.GetITemSTring(1,'d_warehouse')
	
	select Count(*) into :llCount from location 
	where wh_code = :lsWarehouse and l_code = :data;
		
	If llCount < 1 Then
		MessageBox(is_title, "Invalid Location!",StopSign!)
		Return 1
	End If


End Choose
end event

event itemerror;
Return 1
end event

type cb_search from commandbutton within tabpage_search
event ue_search ( )
integer x = 3350
integer y = 16
integer width = 311
integer height = 93
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event ue_search();// ue_search

end event

event clicked;String  ls_criteria, ls_val, ls_sql
String ls_sku,ls_ordnbr,ls_contid
Long    ll_rows
Integer li_ret
Date    ld_date
datetime ldt_date
Boolean lb_tran_from
boolean lb_tran_to
boolean lb_complete_from
boolean lb_complete_to
Boolean lb_where 

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
ls_criteria += " project_id = '" + gs_project + "' And Ord_Type <> 'O' And "


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
ls_ordnbr = idw_search.GetItemString(1,"order_nbr")
IF NOT IsNull(ls_ordnbr) AND ls_ordnbr <> '' THEN
	ls_criteria = ls_criteria + "Transfer_Master.to_no like '%" + ls_ordnbr + "%' And "
	lb_where = True	
END IF

// 09 - 15 - PCONKL - Mobile Status
ls_val = idw_search.GetItemString(1,"mobile_status")
IF NOT IsNull(ls_val) AND ls_val <> '' THEN
	ls_criteria = ls_criteria + "mobile_status_ind = '" + ls_val + "' And "
	lb_where = True	
END IF


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
integer y = 13
integer width = 3266
integer height = 339
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_stock_transfer_search"
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
integer x = 3350
integer y = 128
integer width = 311
integer height = 93
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
integer x = 22
integer y = 365
integer width = 3328
integer height = 1373
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tran_result"
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
		ls_code = this.getitemstring(row,'to_no')
		isle_code.text = ls_code
		isle_code.TriggerEvent(Modified!)
	End If
END IF
end event

type tabpage_detail from userobject within tab_main
event create ( )
event destroy ( )
event ue_transferall ( )
integer x = 15
integer y = 90
integer width = 3785
integer height = 1933
long backcolor = 79741120
string text = "Transfer Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 553648127
dw_mobile dw_mobile
cb_serial cb_serial
cb_copyrow cb_copyrow
p_arrow p_arrow
cb_xferall cb_xferall
cb_reset cb_reset
cb_replenish cb_replenish
cb_insert cb_insert
cb_delete cb_delete
dw_detail_content dw_detail_content
dw_content dw_content
dw_detail dw_detail
end type

on tabpage_detail.create
this.dw_mobile=create dw_mobile
this.cb_serial=create cb_serial
this.cb_copyrow=create cb_copyrow
this.p_arrow=create p_arrow
this.cb_xferall=create cb_xferall
this.cb_reset=create cb_reset
this.cb_replenish=create cb_replenish
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.dw_detail_content=create dw_detail_content
this.dw_content=create dw_content
this.dw_detail=create dw_detail
this.Control[]={this.dw_mobile,&
this.cb_serial,&
this.cb_copyrow,&
this.p_arrow,&
this.cb_xferall,&
this.cb_reset,&
this.cb_replenish,&
this.cb_insert,&
this.cb_delete,&
this.dw_detail_content,&
this.dw_content,&
this.dw_detail}
end on

on tabpage_detail.destroy
destroy(this.dw_mobile)
destroy(this.cb_serial)
destroy(this.cb_copyrow)
destroy(this.p_arrow)
destroy(this.cb_xferall)
destroy(this.cb_reset)
destroy(this.cb_replenish)
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.dw_detail_content)
destroy(this.dw_content)
destroy(this.dw_detail)
end on

event ue_transferall();// ue_transferAll()

dwitemstatus astatus

//TimA 11/14/11 Pandora #315

//	astatus = idw_detail.getItemStatus( idw_detail.getrow(),0, primary! )
//	choose case astatus
//		case newmodified!, new!
			doTransferAll( idw_detail.getRow() )
//	end choose
//Next
end event

type dw_mobile from u_dw_ancestor within tabpage_detail
integer y = 128
integer width = 3449
integer height = 176
integer taborder = 20
string dataobject = "d_transfer_mobile"
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
String	lsTONO, lsFindStr, lsWarehouse,lsmobilepackloc,lsmobilescanreqind, lsAttributes, lsXml, lsXMLResponse, lsReturnCode, lsReturnDesc
Integer	i

lsTONO = idw_Main.GetITemString(1,'to_no')
lsWarehouse = idw_Main.GetITemString(1,'s_warehouse')
ldtGMT = f_getLocalWorldTime(lsWarehouse ) 

//ib_changed = true


Choose Case Upper(dwo.name)
		
	
	Case "MOBILE_ENABLED_IND"
		
		if ib_changed then
			Messagebox(is_title,"Please save your changes before releasing to Mobile")
			Return 1
		End If
		
		SetPointer(Hourglass!)
		
		//If checking, set status and dates, otherwise clear
		if Data = 'Y' Then /* checking*/
		
			//must enter one or more details  first
			If idw_Detail.RowCount() = 0 Then
				Messagebox(is_title,"One or more Detail rows must be entered  before releasing to Mobile")
				Return 1
			End If
			
			lsFindStr = "wh_code = '" + lsWarehouse + "'"
			i = g.ids_project_warehouse.Find(lsFindStr,1,g.ids_project_warehouse.rowcount())
									
			
						
			//Update Status on Header and Detail
			Execute Immediate "Begin Transaction" using SQLCA;
			
			Update transfer_Master 
			Set Mobile_status_ind='R',Mobile_Enabled_Ind='Y', Mobile_Released_time=:ldtGMT
			where Project_Id=:gs_project 
			and To_No=:lsTONO;
						
			Update Transfer_Detail
			Set Mobile_status_Ind = 'N'
			Where to_no = :lstONO
			and (Content_Record_Created_Ind is null or Content_Record_Created_Ind <> 'Y');
			
			Execute Immediate "Commit" using SQLCA;
			
		Else /*unchecking*/
			
			SetNull(ldtGMT )
						
			Execute Immediate "Begin Transaction" using SQLCA;
						
			Update transfer_Master 
			Set Mobile_status_ind='',Mobile_Enabled_Ind='',Mobile_User_Assigned='',Mobile_Released_time=:ldtGMT,
			Mobile_transfer_start_time=:ldtGMT,Mobile_transfer_complete_time=:ldtGMT
			where Project_Id=:gs_project 
			and To_No=:lsTONO;
						
			Update Transfer_Detail
			Set Mobile_status_Ind = '', Mobile_Current_Action = '',  mobile_transfer_by = '', mobile_transfer_start_time = null, mobile_transfer_Complete_time = null
			Where to_no = :lstONO;
			
			Execute Immediate "Commit" using SQLCA;
			
		End If
				
		idw_main.Retrieve(lsTONO,gs_project)
		idw_detail.Retrieve(gs_project,lsTONO)
		
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
			MessageBox("Assign User","Invalid User ID. Cannot assign to Transfer.",StopSign!)
			REturn 1
		End If
		
End Choose
end event

event itemerror;call super::itemerror;Return 2
end event

type cb_serial from commandbutton within tabpage_detail
integer x = 2553
integer y = 29
integer width = 450
integer height = 83
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Serial Numbers..."
end type

event clicked;
Open(w_tran_serial_numbers)
end event

type cb_copyrow from commandbutton within tabpage_detail
integer x = 640
integer y = 29
integer width = 293
integer height = 83
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&opy Row"
end type

event clicked;
dw_detail.TriggerEvent("ue_Copy")




end event

event constructor;
g.of_check_label_button(this)
end event

type p_arrow from picture within tabpage_detail
boolean visible = false
integer x = 2885
integer y = 45
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "Next!"
boolean focusrectangle = false
end type

type cb_xferall from commandbutton within tabpage_detail
boolean visible = false
integer x = 2183
integer y = 29
integer width = 344
integer height = 83
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transfer All"
end type

event clicked;parent.event ue_transferAll()


end event

type cb_reset from commandbutton within tabpage_detail
boolean visible = false
integer x = 3193
integer y = 29
integer width = 377
integer height = 83
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

If wf_update_content() = -1 Then Return

iw_window.event ue_save()

setQtyAllDisplay( true )


end event

type cb_replenish from commandbutton within tabpage_detail
integer x = 987
integer y = 29
integer width = 1031
integer height = 83
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Execute FWD Pick Replenishment"
end type

event clicked;
If idw_Main.GetITemString(1,'Ord_status') = 'X' Then
	
	idw_main.SetItem(1,'Ord_status','N')
	// pvh - 01/12/2006
	setOrderStatus( 'N' )
	//
	ibfwdpickpending = True
	iw_window.TriggerEvent('ue_save')
	
End If
end event

type cb_insert from commandbutton within tabpage_detail
integer y = 29
integer width = 293
integer height = 83
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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
integer x = 311
integer y = 29
integer width = 293
integer height = 83
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

event clicked;// pvh - 10/12/05
w_tran.event ue_deleterow()

end event

type dw_detail_content from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 3591
integer y = 13
integer width = 102
integer height = 93
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_tran_detail_content"
end type

event retrievestart;Return 2
end event

event sqlpreview;// dw_detail_content
string _sqlsyntax

_sqlsyntax = sqlsyntax

end event

type dw_content from u_dw_ancestor within tabpage_detail
boolean visible = false
integer x = 3226
integer y = 128
integer width = 80
integer height = 77
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_tran_content"
boolean hscrollbar = true
boolean vscrollbar = true
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
integer y = 307
integer width = 3361
integer height = 1459
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tran_detail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_enter_serial_numbers();//GailM 11/3/2019 S F17337 I1304 Google Footprints GPN Conversion Process - Stock Transfer
//We are expecting the color_code on each pick row to be "9" which indicates this is a footprint GPN but has less than full number of serial numbers in serial number inventory table
String lsFind, lsMessage
String lsContainers[], lsMoveContainers[]
String lsContainer, lsNewPallet, lsSKU, lsLocation, lsCoo
String lsOrderType, lsToNo, lsMixedType, lsColorCode, lsSLcode, lsDLcode, lsInvType, lsSno, lsLno, lsPoNo, lsPoNo2
Long llAdjustNo, llReqQty, llOwnerId, llQty
Boolean lbCancelled
Int liPickRows, liPickRow, liContentRows, liContentRow, liContainerRows, liContainerRow, liExists, liMoveNbr
Int liContentSummaryRow, liContentSummaryRows, liFound, liModified, liDContentRows
Int liSerialRow, liSerialRows, liTotalSerialsChanged, liMoveRow, liMoveRows, aiRC, aiRec, liRC
datastore ldsAdjustment, ldsNewContentSummary,ldsSerial, ldsContent
datetime ldtToday, lsExpDt

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
ldsPickContainer.dataobject = 'd_tran_detail'
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
	
	llOwnerId = ldsPickContainer.GetItemNumber(1, "owner_id")
	lsDLcode = ldsPickContainer.GetItemString(1, "d_location")
	lsInvType = ldsPickContainer.GetItemString(1, "inventory_type")
	lsSno = ldsPickContainer.GetItemString(1, "serial_no")
	lsLno = ldsPickContainer.GetItemString(1, "lot_no")
	lsPoNo = ldsPickContainer.GetItemString(1, "po_no")
	lsExpDt = ldsPickContainer.GetItemDatetime(1, "expiration_date")
	lsCoo = ldsPickContainer.GetItemString(1, "country_of_origin")
	
	idw_dcontent.reset( )
	liDContentRows = idw_dcontent.retrieve(lsToNo,lsSKU,'PANDORA',llOwnerId,lsLocation, lsDLcode,lsInvType,lsSno,lsLno,lsPoNo,isPallet,isContainer,lsExpDt,lsCoo)

	lsFind = "SKU = '" + lsSKU + "' "
	
	llReqQty = f_footprint_serial_numbers(lsSKU, isWhCode, lsLocation, isPallet, isContainer, llQty)
	If llReqQty <> 0 Then
		llReqQty = ABS(llReqQty)
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
	
	//For stock transfer, we need to send both source and destination locations - combine both into lsLocation
	//GailM 1/9/2020 DE14138 Google - Application crashes on ST
	lsLocation = ldsPickContainer.GetItemString(1, "s_location") + "/" + ldsPickContainer.GetItemString(1, "d_location")


	lstrparms.String_Arg[1] = isPallet
	lstrparms.String_Arg[2] = isContainer
	lstrparms.String_Arg[3] = lsToNo
	lstrparms.String_Arg[4] = isWhCode
	lstrparms.String_Arg[5] = 'StockTransfer'			//Order type Stock Transfer
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
	lstrparms.Datawindow_Arg[2] = idw_dcontent	// 1/28/2020
	
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

//08/15 - PCONKL - If not mobile enabled, move back up to original space since mobile DW not visible
if not g.ibMobileEnabled Then
	this.y = 140
End If

// LTK 20150824
if NOT g.ibAllowInvTypeChangeOnTransfers then
	this.Modify("transfer_detail_new_inventory_type.visible=0")
	//this.Modify("transfer_detail_new_inventory_type_t.visible=0")
end if

//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No -START
//Disable Inv Type and New Inv type
IF upper(gs_project)='PANDORA' THEN
	this.modify( "inventory_type.visible =0")
	this.modify("inventory_type_t.visible=0")
	this.modify("transfer_detail_new_inventory_type.visible =0")
	this.modify("transfer_detail_new_inventory_type_t.visible=0")
END IF
//03-APR-2017 :Madhu -PEVS-424 - Stock Transfer Serial No -END

setRowFocusIndicator( parent.p_arrow )

end event

event doubleclicked;//DGM this is for changing the owner which will pop up the w_select_ownerwindow
Long	llRowPos, llRowCount
str_parms	lstrparms
Boolean lbFootprint
String lsSerialized, lsPONO2Ind, lsContainerInd,  lsSku, lsSupplier, lsMsg, lsMixedType
String lsGPNConversionFlag 

ilCurrPickRow = Row

IF dwo.Name = 'container_id' THEN
	If upper(gs_project) = 'PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" Then
		
		lstrparms.Decimal_arg[1] = idw_detail.getitemdecimal(row,"quantity")
		
		//10SEPT-2018 :MEA S23046 F9270 - I1304 - Google - SIMS Footprints Containerization - Outbound
		//Use Foot_Prints_Ind Flag
		
		lsSku = idw_detail.GetItemString(ilCurrPickRow, 'sku')
		lsSupplier = idw_detail.GetItemString(ilCurrPickRow, 'supp_code')

		lbFootprint = f_is_sku_foot_print( lsSku, lsSupplier)
		
		If lbFootprint Then
			isColorCode = idw_detail.GetItemString(row, "Color_Code")
			lsGPNConversionFlag = f_retrieve_parm("PANDORA","FOOTPRINT","GPN_CONVERSION")
			CHOOSE CASE isColorCode
				CASE "0", "" 													//No action required
					If lbFootprint Then											//Only footprint GPNs
						If gs_role <= "2" Then								//SuperDuper Access Only -- 12/16/2019 Opened up to all
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
					ilCurrPickRow = Row
					
					//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
					//If isPallet = '-'  or isContainer ='-' Then
					//	MessageBox("Container Split Error", "Cannot split this pallet/container.  No pallet data detected.",StopSign!, OK!)
					//Else
						iw_window.TriggerEvent("ue_pick_pallet")
					//End If
				CASE "6"
					wf_check_full_pallet_container()								
				CASE "7"
					isPallet = This.GetITemString(row,'po_no2') 
					isContainer = This.GetItemString(row, 'container_id')
					isWhCode = idw_main.GetItemString( 1, 's_warehouse' )
					ilCurrPickRow = Row
					//19-MAR-2019 :Madhu S30668 -Mixed Containerization - Removed Pallet and Container Id condition
					
					//If isPallet = '-' or isContainer ='-' Then
					//	MessageBox("Container Split Error", "Cannot split this pallet/container.  A dash was found in pallet/container data and cannot be split.",StopSign!, OK!)
					//Else
						lsMsg = "Footprint GPN " + lsSKU + " must maintain full pallet and containers.~n~r" + &
							"Pallet " + isPallet + " has excess containers not allocated that must be moved.~n~r~n~r" +  &
							"      Are you ready to move containers?"
						If MessageBox("Pallet Split Process", lsMsg, Question!, YesNo!) = 1 Then
							iw_window.TriggerEvent("ue_move_pallet")
						End If
					//End If
				CASE	"8" 				//DE10131 Mixed Containerization
					iw_window.TriggerEvent("ue_pick_mixed") 
				CASE  "9" 				//S  F17337 I1304 GTN Conversion Procedss - Stock Transfer
					TriggerEvent("ue_enter_serial_numbers") 
			END CHOOSE
		End If
	End If
END IF

IF dwo.Name = 'c_owner_name' THEN
	
	If Upper(idw_main.object.ord_status[1])	= 'C' Then Return
	
	open(w_select_owner)
	lstrparms = Message.PowerObjectParm
		
	If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
		
		//08/02 - Pconkl - If checked, update all detail rows, otherwise just current
		If lstrparms.String_Arg[4] = 'Y' Then /*update all*/
		
			llRowCount = This.RowCount()
			For llRowPos = 1 to llRowCount
				this.SetItem(llRowPos,"owner_id",Lstrparms.Long_arg[1])
				this.SetITem(lLRowPos,"c_owner_name",Lstrparms.String_arg[1])
			Next
			
		Else /*just update current row */
			
			this.SetItem(1,"owner_id",Lstrparms.Long_arg[1])
			this.SetITem(1,"c_owner_name",Lstrparms.String_arg[1])
			
		End If
		
		ib_changed = True
		
	End If /*not cancelled*/
	
END IF /*owner double clicked*/

end event

event itemchanged;string ls_supp_code,ls_alternate_sku,ls_coo,ls_sku, ls_po_no2, ls_new_to, ls_old_to
Long ll_row,ll_owner_id ,ll_rtn, i
ib_changed = True
datawindowChild	ldwc
String ls_po_no, ls_serial_ind, ls_sku_retrieved, ls_find, ls_validation_results		// LTK 20151217  Pandora #1002
Long ll_found_row																					// LTK 20151217  Pandora #1002

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
	
 	This.GetChild('s_location',ldwc)
 	ll_row = ldwc.GetRow()
 	If ll_Row > 0 Then
		// pvh 11/15/05
		if isNull(this.object.supp_code[row] ) or len( String( this.object.supp_code[row] )) = 0 then
			This.object.supp_code[ row ] = ldwc.GetITemString(ll_row,'supp_code')
		end if
		// eom

 		//Jxlim 07/12/2011 cycle count inventory type
		If ldwc.GetITemString(ll_row,'inventory_type') = '*' Then
			MessageBox(is_title, "Bin transfer not allowed - Material is in Cycle count")
			Return 1
		Else		
			This.SetItem(row,'lot_no',ldwc.GetITemString(ll_row,'lot_no'))
			This.SetItem(row,'po_no',ldwc.GetITemString(ll_row,'po_no'))
			This.SetItem(row,'po_no2',ldwc.GetITemString(ll_row,'po_no2'))
			This.SetItem(row,'container_ID',ldwc.GetITemString(ll_row,'container_ID'))				//GAP 11/02
			This.SetItem(row,'expiration_date',ldwc.GetITemdatetime(ll_row,'expiration_date')) 	//GAP 11/02
			This.SetItem(row,'serial_no',ldwc.GetITemString(ll_row,'serial_no'))
			This.SetItem(row,'Inventory_type',ldwc.GetITemString(ll_row,'inventory_type'))
			This.SetItem(row,'transfer_detail_new_inventory_type',ldwc.GetITemString(ll_row,'inventory_type'))		// LTK 20150826
			This.SetItem(row,'country_of_origin',ldwc.GetITemString(ll_row,'country_of_origin'))
			This.SetItem(row,'owner_id',ldwc.GetITemNumber(ll_row,'owner_id'))
			This.object.c_owner_name[ row ] = g.of_get_owner_name(ldwc.GetITemNumber(ll_row,'owner_id'))
		End if		
		
			i_nwarehouse.of_hide_unused(this) //GAP 11/02 - Hide any unused lottable fields
		
		
	End If
	
	integer li_idx
	
	//Added MEA - 10/08 - Add all item in container.
	
	Case "d_location"


		// LTK 20150812  Unique SKU change.  If unique SKU location indicator is set, don't allow different SKUs to be putaway in the location
		String ls_unique_sku_ind, ls_warehouse
		ls_warehouse = getwarehouse()
		
		select Unique_SKU_ind 
		into :ls_unique_sku_ind 
		from location with (nolock) 
		where wh_code = :ls_warehouse 
		and l_code = :data;

		if Upper( ls_unique_sku_ind ) = 'Y' then

			long ll_count

			ls_sku = Upper( Trim( this.GetItemString( row,'sku' ) ) )

			select COUNT(DISTINCT SKU) 
			into :ll_count 
			from content_summary with (nolock) 
			where project_id = :gs_project 
			and wh_code = :ls_warehouse 
			and l_code = :data 
			and sku <> :ls_sku;
	
			if ll_count > 0 then
				Messagebox( is_title, "Another SKU exists in this location but the location is set to allow only a single SKU.", StopSign! )
				return 1
			end if
			
			// Also check the SKUs/Locations in the datawindow
			long j
			String ls_rows_sku
			ls_rows_sku = this.Object.sku[ row ]
			for j = 1 to this.RowCount()
				if j <> row then
					if Upper(Trim( this.Object.d_location[ j ] )) = Upper(Trim( data )) and Upper(Trim( this.Object.sku[ j ] )) <> Upper(Trim( ls_rows_sku )) then
						Messagebox( is_title, "Another identical location with a different SKU exists in the current window but this location is set to allow only a single SKU." +&
													"~rPlease enter another location.", StopSign! )
						return 1
					end if
				end if
			next

		end if


		// LTK 20151217  Pandora #1002 added Pandora block to validate single project (po_no) location rule (if appropriate)
		if gs_project = 'PANDORA' then
			ib_is_pandora_single_project_location_rule_on = ( f_retrieve_parm("PANDORA", "FLAG", "SOC_SERIAL_GPN_TRACK_ON") = 'Y' )

			ls_validation_results = wf_validate_single_project_rule(data, row)
			if NOT IsNull( ls_validation_results ) then
				MessageBox( is_title, ls_validation_results, StopSign! )
				Return 1
			end if
		end if


		If row = 1 and this.RowCount() > 1 Then
			
			If Messagebox('Transfer','Would you like to apply this DESTINATION LOCATION to all records?',Question!,YesNo!,1) = 1 Then
				
				For i = 2 to This.RowCount()

					// LTK 20151217  Pandora #1002 added Pandora block to validate single project (po_no) location rule (if appropriate)
					if gs_project = 'PANDORA' then
						ls_validation_results = wf_validate_single_project_rule(data, i)
						if NOT IsNull( ls_validation_results ) then
							MessageBox( is_title, ls_validation_results, StopSign! )
							Return 1
						end if
					end if

					This.SetItem(i,'d_location',data)	
				Next
				
			End If
			
		End If
		
			
END Choose			

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
			lsSku,			&
			lsLot,			&
			lsSerial,		&
			lsSupplier
string ls_po,ls_po2,ls_coo, ls_container_ID //GAP 11/02	
datetime ldt_expiration_date //GAP 11/02
DatawindowChild	ldwc
String				lsNewSQL
Integer	liRC,ll_own


If dwo.Name = "s_location" Then 
	
	//Retrieve content records for from loc dropdown
	This.GetChild("s_location", ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.setsqlselect( GetFromLocationSQL( ) )
	ldwc.Retrieve()

Elseif dwo.Name = "d_location" Then
	
	// 06/00 PCONKL - Retrieve locations for  destination Warehouse - only show where project reserved is null or reserved to current project
	lsWarehouse = idw_main.GetItemString(1,"d_warehouse")
	If not isnull(lsWarehouse) Then
		lsWhere = " Where (wh_code = '" + lsWarehouse + "' and (project_reserved is null or project_reserved = '" + gs_project + "'))"
		lirc = This.GetChild("d_location", ldwc)
		lsNewSql = replace(istolocsql,pos(istoLocSql,'ZZZZZ'),5,gs_project) /*replace dummy project*/
		lsNewSql = replace(lsNewSQL,pos(lsNewSQL,'XXXXX'),5,lsWarehouse) /*replace dummy warehouse*/
		ldwc.SetTransObject(SQLCA)
		ldwc.setsqlselect(lsNewSql)
		//only retrieve once
		If ldwc.Rowcount() <=0 Then
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
		tab_main.tabpage_detail.cb_insert.TriggerEvent(Clicked!)
		Return 1
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event retrieveend;call super::retrieveend;Integer i
long ll_owner

if rowcount <= 0 then return

IF Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to rowcount
		ll_owner=This.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.c_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
		this.setitemstatus( i, 0,primary!, NotModified! )
	Next
END IF

If upper(gs_project) ='PANDORA' and f_retrieve_parm("PANDORA","FLAG","CONTAINER MOVEMENT") = "Y" and isOrderStatus = 'P' Then
	wf_check_full_pallet_container()
End If

setQtyAllDisplay( false )
end event

event clicked;//Choose Case dwo.name

//Case "s_location" /* GAP 11/02 - force an itemchange - Fix selection bug in  drop down by row*/
//		This.SetItem(row,'s_location'," ")
//END Choose		

Return

end event

event ue_copy;call super::ue_copy;//MEA - 12-18-11
// Copied source from w_ro - picking tab.

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

idw_detail.SetFocus()

If idw_detail.AcceptText() = -1 Then Return -1

ll_row = idw_detail.GetRow() 

If ll_row > 0 Then
	
		
	//Allow user to select the number of rows to add and set QTY
	lstrparms.Decimal_arg[1] = idw_detail.GetITemNumber(ll_row,'quantity') /*Qty from original row, will be default for new rows*/
	OpenWithParm(w_tran_copy_detail_row,lStrParms)
	lstrparms = message.PowerObjectParm
	
	If lstrparms.Cancelled Then Return 1 /*Don't copy row if cancelled from prompt*/
	
	This.SetReDraw(False)
	
	//Set Qty on Original Row
	idw_detail.SetITem(ll_row,'Quantity',lstrparms.Decimal_arg[1])
	
	//Loop for each row to Create We're creating one less row than rowcount since we already have the first row)
	For i = 1 to (lstrparms.Long_arg[1] - 1)
	
		idw_detail.setcolumn('sku')
		llNewrow = idw_detail.InsertRow(ll_row + 1)
		//idw_putaway.ScrollToRow(llNewrow)
		
//		//copy items to new row
//		idw_putaway.setitem(llNewrow,'ro_no',idw_Main.GetItemString(1,"ro_no"))
//	
		idw_detail.SetItem(llNewRow,'sku',idw_detail.GetITemString(ll_row,'sku'))


//		idw_putaway.SetItem(llNewRow,'sku_parent',idw_putaway.GetITemString(ll_row,'sku_parent'))
		lssku = idw_detail.GetITemString(ll_row,'sku')
		lsSupplier = idw_detail.GetITemString(ll_row,'supp_code')
//		idw_putaway.SetItem(llNewRow,'component_ind',idw_putaway.GetITemString(ll_row,'component_ind'))
//		//idw_putaway.SetItem(llNewRow,'l_code','')
//s_location
//d_location
//		idw_putaway.SetItem(llNewRow,'l_code',idw_putaway.GetITemString(ll_row,'l_code'))
		idw_detail.SetItem(llNewRow,'supp_code',idw_detail.GetITemString(ll_row,'supp_code'))
		
		idw_detail.SetItem(llNewRow,'TO_No',idw_detail.GetITemString(ll_row,'TO_No'))
		
		idw_detail.SetItem(llNewRow,'lot_no',idw_detail.GetITemString(ll_row,'lot_no'))
		idw_detail.SetItem(llNewRow,'po_no',idw_detail.GetITemString(ll_row,'po_no'))
		idw_detail.SetItem(llNewRow,'po_no2',idw_detail.GetITemString(ll_row,'po_no2'))
		idw_detail.SetItem(llNewRow,'container_ID',idw_detail.GetITemString(ll_row,'container_ID')) /* 11/02 - Pconkl */
		idw_detail.SetItem(llNewRow,'expiration_Date',idw_detail.GetITemDateTime(ll_row,'expiration_Date'))
		idw_detail.SetItem(llNewRow,'country_of_origin',idw_detail.GetITemString(ll_row,'country_of_origin'))
		idw_detail.SetItem(llNewRow,'owner_id',idw_detail.GetITemNumber(ll_row,'Owner_id'))
		idw_detail.SetItem(llNewRow,'c_owner_name',idw_detail.GetITemString(ll_row,'c_owner_name'))
		idw_detail.SetItem(llNewRow,'inventory_type',idw_detail.GetITemString(ll_row,'inventory_type'))
		idw_detail.SetItem(llNewRow,'serial_no',idw_detail.GetITemString(ll_row,'serial_no'))
	
	
	
	
		//idw_putaway.Setcolumn("Quantity")
		idw_detail.SetITem(llNewRow,'Quantity',lstrparms.Decimal_arg[1]) /* 01/03 - PConkl set qty from prompt*/
		
		
	Next /*copy of Row*/
	
	This.SetReDraw(True)
	
	ib_Changed = True
		
	This.SetRow(ll_row)
	This.ScrollToRow(ll_row)
	
Else
	Messagebox(is_title,"Nothing to copy!")
End If	
return 1


end event

type dw_report from datawindow within w_tran
integer x = 18
integer y = 13
integer width = 563
integer height = 83
integer taborder = 20
string dataobject = "d_tran_report"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;if gs_Project = 'PRATT' then
	this.dataobject = 'd_ford_tran_report'
	this.settransobject(sqlca)
end if

if left(gs_Project,4) = "NIKE" then
	this.dataobject = 'd_nike_tran_report'
	this.settransobject(sqlca)
end if

//24-May-2017 :Madhu PEVS-546 - Print Stock Transfer -START
if upper(gs_project) ='PANDORA' Then
	this.dataobject='d_tran_report_pandora'
	this.settransobject( sqlca)
end if
//24-May-2017 :Madhu PEVS-546 - Print Stock Transfer -END
end event

