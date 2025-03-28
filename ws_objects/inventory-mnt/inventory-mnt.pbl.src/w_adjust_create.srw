$PBExportHeader$w_adjust_create.srw
$PBExportComments$*+Stock Adjustment Create
forward
global type w_adjust_create from window
end type
type p_empty from picture within w_adjust_create
end type
type p_arrow from picture within w_adjust_create
end type
type cb_swap_serial from commandbutton within w_adjust_create
end type
type st_retrieve_sn from statictext within w_adjust_create
end type
type rb_serial_reconcile from radiobutton within w_adjust_create
end type
type cb_adjust_import from commandbutton within w_adjust_create
end type
type cbx_serial_retrieve from checkbox within w_adjust_create
end type
type cb_add_serial from commandbutton within w_adjust_create
end type
type cb_delete_serials from commandbutton within w_adjust_create
end type
type dw_serial from u_dw_ancestor within w_adjust_create
end type
type rb_adjust_break_carton from radiobutton within w_adjust_create
end type
type rb_adjust_merge_pallet from radiobutton within w_adjust_create
end type
type rb_adjust_break_pallet from radiobutton within w_adjust_create
end type
type cb_pallet_adjust from commandbutton within w_adjust_create
end type
type cb_adjust_reset from commandbutton within w_adjust_create
end type
type rb_adjust_other from radiobutton within w_adjust_create
end type
type rb_adjust_inv_type from radiobutton within w_adjust_create
end type
type rb_adjust_owner from radiobutton within w_adjust_create
end type
type rb_adjust_qty from radiobutton within w_adjust_create
end type
type cb_adjust_sort from commandbutton within w_adjust_create
end type
type cb_adjust_help from commandbutton within w_adjust_create
end type
type cb_adjust_split from commandbutton within w_adjust_create
end type
type cb_adjust_cancel from commandbutton within w_adjust_create
end type
type cb_adjust_ok from commandbutton within w_adjust_create
end type
type dw_adjust from u_dw_ancestor within w_adjust_create
end type
type gb_adjustment_type from groupbox within w_adjust_create
end type
type dw_content from u_dw_ancestor within w_adjust_create
end type
end forward

global type w_adjust_create from window
integer x = 123
integer y = 188
integer width = 4105
integer height = 2604
boolean titlebar = true
string title = "New Stock Adjustment"
boolean controlmenu = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 79741120
event ue_postopen ( )
event ue_process_type_chg ( )
event ue_disable_type_chg ( )
event ue_pallet_adjust ( )
p_empty p_empty
p_arrow p_arrow
cb_swap_serial cb_swap_serial
st_retrieve_sn st_retrieve_sn
rb_serial_reconcile rb_serial_reconcile
cb_adjust_import cb_adjust_import
cbx_serial_retrieve cbx_serial_retrieve
cb_add_serial cb_add_serial
cb_delete_serials cb_delete_serials
dw_serial dw_serial
rb_adjust_break_carton rb_adjust_break_carton
rb_adjust_merge_pallet rb_adjust_merge_pallet
rb_adjust_break_pallet rb_adjust_break_pallet
cb_pallet_adjust cb_pallet_adjust
cb_adjust_reset cb_adjust_reset
rb_adjust_other rb_adjust_other
rb_adjust_inv_type rb_adjust_inv_type
rb_adjust_owner rb_adjust_owner
rb_adjust_qty rb_adjust_qty
cb_adjust_sort cb_adjust_sort
cb_adjust_help cb_adjust_help
cb_adjust_split cb_adjust_split
cb_adjust_cancel cb_adjust_cancel
cb_adjust_ok cb_adjust_ok
dw_adjust dw_adjust
gb_adjustment_type gb_adjustment_type
dw_content dw_content
end type
global w_adjust_create w_adjust_create

type variables
Boolean	ibCancel, ibNewContainer, ibSplitOK
datawindowchild idwc_supp
n_warehouse i_nwarehouse
integer ii_row, iiQtyChgCount
W_adjust_Create	iwWindow
Dec	IdOrigQty
String	is_trans_type, isOrigSQL, isOrigSQLSerial
n_adjust_pallet_parms in_pallet_parms

String is_serialized_ind, is_container_ind, is_po_no2_ind

boolean ib_allow_content_select_row = false
end variables

forward prototypes
public function integer wf_validations ()
public subroutine wf_enable_break_pallet ()
public function integer wf_adjust_serial (long alrow)
public function integer wf_check_serial_number_exist ()
public function long wf_create_item_serial_change_record (string as_project, string as_sku, string as_wh, string as_suppcode, long al_ownerid, string as_pono, string as_old_pono, string as_from_serial_no, string as_to_serial_no, boolean ab_suppress_947)
end prototypes

event ue_postopen();DatawindowChild	ldwc
String				lsFilter
ibCancel = True

String lsSerialSwapFlag

// 04/14 - PCONKL - Serial DW only visible if project SN Chain of CUstody enabled
 IF g.ibSNchainofcustody THEN
	
	dw_serial.Visible = True
	cb_delete_serials.visible = True
	cb_swap_serial.visible = True   //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	cb_add_serial.visible = True
	cbx_serial_retrieve.visible = True

Else
	
	dw_serial.Visible = False
	cb_delete_serials.visible = False
	 cb_swap_serial.visible = False //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	cb_add_serial.visible = False
	dw_content.Height = 1850
	cbx_serial_retrieve.visible = False	

End If

//DGM Make owner name invisible based in indicator
IF Upper(g.is_owner_ind) <> 'Y' THEN
	dw_content.object.cf_owner_name.visible = 0
	dw_content.object.cf_name_t.visible = 0
//	cb_split.visible = false
End IF

//DGM Make owner name invisible based in indicator
IF Upper(g.is_coo_ind) <> 'Y' THEN
	dw_content.object.country_of_origin.visible = 0
	dw_content.object.country_of_origin_t.visible = 0	
END IF	

//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
IF Upper(gs_project) ='PANDORA' AND f_retrieve_parm("PANDORA","FLAG","RECONCILE OPTION") = "Y" THEN
	rb_serial_reconcile.visible =True
ELSE
	rb_serial_reconcile.visible =False
END IF

IF gbSerialReconcileOnly THEN
	rb_adjust_qty.enabled =FALSE
	rb_adjust_inv_type.enabled =FALSE
	rb_adjust_break_pallet.enabled =FALSE
	rb_adjust_break_carton.enabled =FALSE
	rb_adjust_owner.enabled =FALSE
	rb_adjust_other.enabled =FALSE
	rb_adjust_merge_pallet.enabled =FALSE
	rb_serial_reconcile.enabled =TRUE
	cb_pallet_adjust.enabled =FALSE
END IF
//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END

//DGM For supp code dwc 10/06/00
i_nwarehouse = Create n_warehouse
dw_adjust.GetChild("supp_code",idwc_supp)
idwc_supp.Settransobject(SQLCA)
idwc_supp.InsertRow(0)

// 01/03 - PConkl - Retrieve warehouse by project instead of filtering
dw_adjust.GetChild("wh_code",ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* 04/04 - PCONKL - Load from USer Warehouse DS */
//ldwc.Retrieve(gs_Project)

//07/04 - PCONKL -= Load Reason Dropdown
dw_adjust.GetChild("reason",ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project,'IA')

dw_adjust.InsertRow(0)


//added by dgm For initialising Inventory type
// 03/02 - Pconkl - now being retrieved by project in n_warehouse
i_nwarehouse.of_init_inv_ddw(dw_content)
i_nwarehouse.of_init_inv_ddw(dw_serial) /* 04/14 - PCONKL */

cb_adjust_Split.Enabled = False
cb_adjust_import.enabled=False //12-Dec-2014 :Madhu- Added for HONDA -Stock Adjustment Import

//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
IF gbSerialReconcileOnly THEN
	rb_serial_reconcile.Checked =TRUE
ELSE
	rb_adjust_qty.Checked = True /*default to a qty chg */
END IF
//14-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END

This.TriggerEvent('ue_process_type_chg')
cb_adjust_Reset.Enabled = False
iiQtyChgCount = 0 /*only allowing qty to change on 2 rows in a single transaction -only way to move between buckets and report accurately*/

if left(gs_project,4) = 'NIKE' then
	dw_adjust.Object.reason.dddw.AllowEdit=False
	//dw_content.Object.avail_qty.EditMask.Mask = "######0"			// LTK 20150115  This is now controlled by a project flag
end if

// LTK 20150115  Allow quantity decimals based on project flag.
if g.ibAllowQuantityDecimals then
	dw_content.Object.avail_qty.EditMask.Mask = '######0.#####'	
else
	dw_content.Object.avail_qty.EditMask.Mask = '######0'	
end if

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process - Turn this off until needed
lsSerialSwapFlag = f_retrieve_parm("PANDORA","SERIAL_SWAP","SERIAL_NUMBER_SWAP")
//GailM 12/20/2019 DE13984 Do Not show st_retrieve_sn if not Pandora
If Upper(gs_project) <> "PANDORA" Then st_retrieve_sn.visible = FALSE

//If Not enabled return
//GailM 12/20/2019 DE13984 Do Not show st_retrieve_sn if not Pandora
IF IsNull(lsSerialSwapFlag) OR Upper(lsSerialSwapFlag) <> 'Y' THEN  
	cb_swap_serial.visible = False 
	st_retrieve_sn.visible = False
else
	cb_swap_serial.visible = True 
	st_retrieve_sn.visible = True
End If


end event

event ue_process_type_chg();
//Process the Adjutment TYpe radio button group

String	lsModify

ibSplitOK = True

// 04/14 - PCONKL - DEleting of Serial NUmbers
cb_delete_serials.Enabled = False
cb_swap_serial.Enabled = False   //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
cb_add_serial.Enabled = False


dw_adjust.object.t_or.visible=false
dw_adjust.object.t_serial_number.visible=false
dw_adjust.object.serialno.visible=false

// Begin  - Dinesh - 10/06/2022 - SIMS-89- Geistlich Serialization - Updates (Part II)
if upper(gs_project)='GEISTLICH' then // Dinesh 10/06/2022
	dw_adjust.object.t_serial_number.visible=True
	dw_adjust.object.serialno.visible=True
end if
// End  - Dinesh - 10/06/2022 - SIMS-89- Geistlich Serialization - Updates (Part II)

// TAM - 2018/02 -S14838 - Added Carton to Serial DW
//lsModify = "c_select.protect=1 l_Code.Protect=1 serial_no.Protect=1 lot_no.Protect=1 po_no.protect=1 po_no2.protect=1 inventory_type.protect=1 exp_dt.protect=1"
lsModify = "c_select.protect=1 l_Code.Protect=1 serial_no.Protect=1 lot_no.Protect=1 po_no.protect=1 po_no2.protect=1 inventory_type.protect=1 exp_dt.protect=1 carton_id.protect=1"

dw_serial.Modify(lsModify)




lsModify = "Avail_Qty.Protect=0 Inventory_Type.Protect=0 serial_no.Protect=0 Lot_no.Protect=0 po_no.Protect=0 po_no2.Protect=0 Country_of_Origin.Protect=0 "
lsModify += "container_id.Protect=0 expiration_date.Protect=0 cntnr_length.Protect=0 cntnr_width.Protect=0 Cntnr_height.Protect=0 cntnr_weight.Protect=0"
Dw_Content.Modify(lsModify)

cb_pallet_adjust.Enabled = false		// LTK 20131013  Pandora #657 Pallet Break logic

If rb_adjust_qty.Checked Then /*Qty change*/
	
	//If Qty is changing, disable split row functionality
	ibSplitOK = False
	cb_adjust_split.Enabled = FALse
	is_trans_type = 'Q'  //TAM 2005/04/18
	
	//Protect Non Qty Fields on DW
	lsModify = "Inventory_Type.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)
	
	// 04/14 - PCONKL - DEleting/Adding of Serial NUmbers
	If dw_serial.RowCount() > 0 Then
		cb_delete_serials.Enabled = True
		cb_swap_serial.Enabled = True and is_trans_type = 'S' //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	End If
	
	lsModify = "c_select.protect=0"
	dw_serial.Modify(lsModify)
	
ElseIf rb_adjust_owner.Checked Then /*Owner Change*/
	
	is_trans_type = 'O'  //TAM 2005/04/18
		
	//Protect all of the fields, will allow qty to chg if row split (to split quantities only)
	lsModify = "Inventory_Type.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)
	
	
ElseIf rb_adjust_Inv_Type.Checked Then /*Inventory Type Change*/
	
	is_trans_type = 'I'  //TAM 2005/04/18
	
	//Protect all of the fields except inv type, will allow qty to chg if row split (to split quantities only)

	// 04/11 - PCONKL - Allow a Super User to change a cyvcle count inventory type
	Dw_Content.object.Inventory_Type.protect="0~tIf( inventory_type  = '*',1,0)"
	If gs_role = '0' or gs_role = '-1' Then
		dw_Content.Modify("Inventory_Type.protect=0")
	End If
	
	lsModify = "serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)
	
	// 04/14 - PCONKL - DEleting of Serial NUmbers
	lsModify = "inventory_type.protect=0"
	dw_serial.Modify(lsModify)
	
ElseIf rb_adjust_break_pallet.Checked Then		/* Pandora pallet break */

	is_trans_type = 'P'  	// LTK 20131013  Pandora #657 Pallet Break logic
	
	wf_enable_break_pallet()

	// Protect all, the data is set programmatically upon return from the Pallet Adjust window
	lsModify = "Avail_Qty.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)

ElseIf rb_adjust_merge_pallet.Checked Then		/* Pandora pallet break */

//  TAM S29817 - Disable Merge Pallet - Functionality has been ccombined with MERGE_FOOTPRINT
//	is_trans_type = 'M'  	// LTK 20131024  Pandora #657 Merge Break logic
	is_trans_type = 'F'  	// LTK 20131024  Pandora #657 Merge Break logic
	
	wf_enable_break_pallet()

	// Protect all, the data is set programmatically upon return from the Pallet Adjust window
	lsModify = "Avail_Qty.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)

ElseIf rb_adjust_break_carton.Checked Then		/* Pandora carton break */

	is_trans_type = 'C'  	// LTK 20130227  Pandora #699 Carton Merge Break logic
	
	wf_enable_break_pallet()

	// Protect all, the data is set programmatically upon return from the Pallet Adjust window
	lsModify = "Avail_Qty.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)

//  TAM S29817 - Disable Merge Carton - Functionality has been ccombined with MERGE_FOOTPRINT - Remove Radio Button
//ElseIf rb_adjust_merge_carton.Checked Then		/* Pandora carton merge */

//	is_trans_type = 'D'  	// LTK 20130227  Pandora #699 Carton Merge Break logic
	
//	wf_enable_break_pallet()

	// Protect all, the data is set programmatically upon return from the Pallet Adjust window
//	lsModify = "Avail_Qty.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1 "
//	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
//	Dw_Content.Modify(lsModify)

//13-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process
ElseIf rb_serial_reconcile.Checked Then /*Serial Reconcile change*/
	
	//Enable Serial Search
	dw_adjust.object.t_or.visible=true
	dw_adjust.object.t_serial_number.visible=true
	dw_adjust.object.serialno.visible=true

	rb_serial_reconcile.checked = true

	//If Serial Reconcile is changing, disable split row functionality
	ibSplitOK = False
	cb_adjust_split.Enabled = False
	is_trans_type = 'S'
	
	//Protect Non Qty Fields on DW
	lsModify = "Inventory_Type.Protect=1 serial_no.Protect=1 Lot_no.Protect=1 po_no.Protect=1 po_no2.Protect=1 Country_of_Origin.Protect=1"
	lsModify += "container_id.Protect=1 expiration_date.Protect=1 cntnr_length.Protect=1 cntnr_width.Protect=1 Cntnr_height.Protect=1 cntnr_weight.Protect=1"
	Dw_Content.Modify(lsModify)
	
	cb_add_serial.Enabled = True  //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	
	If dw_serial.RowCount() > 0 Then
		cb_delete_serials.Enabled = True
		cb_swap_serial.Enabled = True   //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	End If
	
	lsModify = "c_select.protect=0"
	dw_serial.Modify(lsModify)

////GailM 8/11/2020 S48701 F24564 Google - Prevent N/A on put away and stock adjustment and stock adjustment
ElseIf rb_adjust_other.Checked Then /*Other change - Protect po_no2*/
	lsModify = "l_code.Protect=0 Serial_No.Protect=0 lot_no.Protect=0 po_no.protect=0 po_no2.protect=1  exp_dt.protect=0 carton_id.protect=1"
	dw_serial.Modify(lsModify)
	
	// Begin .....Akash Baghel - 07/18/2023...- SIMS 243- added dddw for po_no drop down column (project code)

  If upper(gs_project) = 'PANDORA' then	
	  dw_content.Modify("po_no.Visible='1'")
	  dw_content.Modify("po_no.Edit.Style='dddw'")
	
	  dw_content.Modify("po_no.dddw.Case='Any'")
	  dw_content.Modify("po_no.dddw.Name='dddw_project_code'")
	  dw_content.Modify("po_no.dddw.DataColumn='project_code'")
	  dw_content.Modify("po_no.dddw.DisplayColumn='project_code'")
	  dw_content.Modify("po_no.dddw.Limit=30")
	
	  dw_content.Modify("po_no.dddw.PercentWidth=100")
	  dw_content.Modify("po_no.dddw.UseAsBorder= Yes")
	  dw_content.Modify("po_no.dddw.VScrollBar=Yes")
	
   End if

      datawindowchild ldw_childother

      dw_content.GetChild ( "po_no", ldw_childother )
      ldw_childother.SetTransObject ( SQLCA )
      ldw_childother.Retrieve ()
		
//End ... .....Akash Baghel - 07/19/2023...- SIMS 243- added dddw for po_no drop down column (project code)


Else /* Other*/
	
	is_trans_type = 'X'  //TAM 2005/04/18
	lsModify = "Inventory_Type.Protect=1"
	Dw_Content.Modify(lsModify)	
	
	// 04/14 - PCONKL - If serial numbers exist on Serial DW, dont allow them to be updated on main DW
	If dw_Serial.RowCount() > 0 Then
		lsModify = "Serial_No.Protect=1"
		Dw_Content.Modify(lsModify)	
	End If
	
	//jxlim 05/04/2010 protect lot_no field for Comcast	
	IF gs_project = 'COMCAST' THEN
		lsModify = "Lot_no.Protect=1"	
		Dw_Content.Modify(lsModify)	
     END IF
	  
	 // 04/14 - PCONKL - Serial DW
	 lsModify = "l_code.Protect=0 Serial_No.Protect=0 lot_no.Protect=0 po_no.protect=0 po_no2.protect=0  exp_dt.protect=0"
	dw_serial.Modify(lsModify)

	//TAM - 2018/02 - S14838 - If PO_NO2 tracked, and Container Tracked  and Serialized Tracked then lock down PoNo2 and Container Id
				
	If  is_po_no2_ind = 'Y' and is_container_ind = 'Y' and is_serialized_ind = 'B' Then				
		dw_Content.Modify("Po_No2.Protect=1")	
		dw_Content.Modify("Container_Id.Protect=1")	
	Else
		dw_Content.Modify("Po_No2.Protect=0")	
		dw_Content.Modify("Container_Id.Protect=0")	
	End If

End IF
	
// 04/14 - PCONKL - If Serials exist, don't allow Qty to be modified on Content DW
If dw_Serial.RowCOunt() > 0 Then
	dw_Content.Modify("avail_qty.Protect=1")
End If
end event

event ue_disable_type_chg();
//Disable the Inv Type Change Radio buttons
rb_adjust_qty.Enabled = False
rb_adjust_inv_type.Enabled = False
rb_adjust_owner.Enabled = False
rb_adjust_other.Enabled = False
rb_adjust_break_pallet.Enabled = False
rb_adjust_break_carton.Enabled = False
rb_adjust_merge_pallet.Enabled = False
rb_serial_reconcile.Enabled =False
//  TAM S29817 - Disable Merge Carton - Functionality has been ccombined with MERGE_FOOTPRINT - Remove Radio Button
//rb_adjust_merge_carton.Enabled = False
end event

event ue_pallet_adjust();
long llContentRowCount,k, llCartonRowCount, llToCartonRow, llFromCartonRow,llToPalletRow //TAM 2018/02 -S14838
String ls_error, lsFind, lsPrevCartonNo, lsFromCartonNo //TAM 2018/02 -S14838
Int liResult

in_pallet_parms = create n_adjust_pallet_parms

// Parms Sent
in_pallet_parms.is_project = gs_project
in_pallet_parms.is_warehouse = Trim(dw_adjust.Object.wh_code[1])
in_pallet_parms.is_sku = Trim(dw_adjust.Object.sku[1])

if rb_adjust_break_pallet.Checked then
	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART
// TAM 2019/03 S29817 - Change to F For footprint merge
elseif rb_adjust_merge_pallet.Checked then
//  TAM S29817 - Disable Merge Pallet - Functionality has been ccombined with MERGE_FOOTPRINT 
//	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_PALLET
	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_FOOTPRINT
elseif rb_adjust_break_carton.Checked then
	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART	
//  TAM S29817 - Disable Merge Carton - Functionality has been ccombined with MERGE_FOOTPRINT - Remove Radio Button
//elseif rb_adjust_merge_carton.Checked then
//	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_CARTON
end if

OpenWithParm(w_adjust_pallet, in_pallet_parms)

// Parms Received
in_pallet_parms = Message.PowerObjectParm

IF IsValid(in_pallet_parms) THEN

	// First check to see if the execution was successful
	IF in_pallet_parms.of_execution_successfull( ) THEN
	
		dw_content.Reset()
		
		// Retrieve content datawindow using the in_pallet_parms data
		dw_content.TriggerEvent("ue_retrieve")
		
		IF in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART THEN
		
			// Ensure content quantity >= sum of the carton count
			// Ensure one row exists in dw and copy it to a second row setting the attributes to "insert"
			// Modify the quantity of the first row (source)  qty = qty - sum of carton count
			// Modify the quantity of the second row (destination)  qty = sum of carton count
			// Set new SSCC # (pallet id) on second row
			
			if dw_content.RowCount() = 1 then
			
				long ll_count
				if in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART then
					ll_count = in_pallet_parms.il_sum_serial_count
				else
					ll_count = in_pallet_parms.il_sum_carton_count
				end if
				
				if dw_content.Object.avail_qty[1] > ll_count then
					dw_content.RowsCopy(1,1,Primary!,dw_content,2,Primary!)
					dw_content.SetItemStatus ( 2, 0, Primary!, NewModified!)
					dw_content.Object.avail_qty[1] = Long(dw_content.Object.avail_qty[1]) - ll_count
					dw_content.Object.avail_qty[2] = ll_count
					dw_content.Object.po_no2[2] = in_pallet_parms.is_sscc_nr_new
					
					//TAM 2018/01 - s14838 - Need to set the new carton ID as well since same carton can't be on 2 pallets
					dw_content.Object.Container_Id[2] = in_pallet_parms.is_carton_id_new
				else
					ls_error = "Available quantity must meet or exceed the quantity being broken.  Please contact support."
				end if
			else
				ls_error = "Expecting one row.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support."
			end if
			
			if Len(ls_error) > 0 then
				MessageBox("Error", ls_error)
				dw_content.reset()
			end if
		
		/* TAM 2018/01 - s14838 - BEGIN - New BREAK Pallet Logic -  We want to keep the Carton ID intact which means we need
		to decrement the original pallet/original carton and increment a new pallet/ original carton */
		Elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART  then
		
			// Ensure content quantity >= sum of the carton count
			// Ensure one row exists in dw and copy it to a second row setting the attributes to "insert"
			// Modify the quantity of the first row (source)  qty = qty - sum of carton count
			// Modify the quantity of the second row (destination)  qty = sum of carton count
			// Set new SSCC # (pallet id) on second row
			
			llContentRowCount = dw_content.RowCount()
			if dw_content.RowCount() < 1 then
				MessageBox("Error", "Expecting at least one row.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
				dw_content.reset()
			else		
			
				for k = 1 to llContentRowCount
				
					ll_count = dw_content.Object.avail_qty[k]
					dw_content.RowsCopy(k,k,Primary!,dw_content,dw_content.RowCount()+1,Primary!) //Copy to end
					dw_content.SetItemStatus ( dw_content.RowCount(), 0, Primary!, NewModified!)
					
					dw_content.Object.avail_qty[dw_content.RowCount()] = Long(dw_content.Object.avail_qty[k])
					dw_content.Object.avail_qty[k] = 0
					dw_content.Object.po_no2[dw_content.RowCount()] = in_pallet_parms.is_sscc_nr_new
				next
			end if
		
		/* TAM 2018/01 - s14838 - BEGIN - New Merge Pallet Logic -  We want to keep the Carton ID intact which means we need
		to decrement the original pallet/original carton and increment a new pallet/ original carton */
		elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_PALLET  then
		
			// Ensure content quantity >= sum of the carton count
			// For each Original Pallet/Original Carton we need to Copy a New Pallet/Original Carton setting the attributes to "insert"
			// Modify the quantity of the first row (source)  qty = 0
			// Modify the quantity of the copied row (destination)  qty = source qty
			// Set new SSCC # (pallet id) on copied row
			
			llContentRowCount = dw_content.RowCount()
			if dw_content.RowCount() < 1 then
				MessageBox("Error", "Expecting at least one row.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
				dw_content.reset()
			else		
				
				for k = 1 to llContentRowCount
					ll_count = dw_content.Object.avail_qty[k]
					dw_content.RowsCopy(k,k,Primary!,dw_content,dw_content.RowCount()+1,Primary!) //Copy to end
					dw_content.SetItemStatus ( dw_content.RowCount(), 0, Primary!, NewModified!)
					
					dw_content.Object.avail_qty[dw_content.RowCount()] = Long(dw_content.Object.avail_qty[k])
					dw_content.Object.avail_qty[k] = 0
					dw_content.Object.po_no2[dw_content.RowCount()] = in_pallet_parms.is_sscc_nr_new
				next
			end if
		
		elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_CARTON then
			// TAM 2018/01 - s14838 - END 		
			/* TAM 2018/01 - s14838 - BEGIN - New Merge CartonLogic -  We want to keep the Pallet Id intact but add Quantities Of the From Carton IDs to the New Carton ID intact which means we need
			to decrement the original Carton and increment a new carton */
			
			llContentRowCount = dw_content.RowCount()
			
			if dw_content.RowCount() < 2 then
				MessageBox("Error", "Expecting at least 2 rows.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
				dw_content.reset()
			else		
			
				lsfind = "Container_Id = '" + in_pallet_parms.is_carton_id_new + "'" // Get the to Carton ID
				llToCartonRow = dw_content.find(lsFind,1, dw_content.RowCount())
				If llToCartonRow < 1 then // No "TO CARTON"Found.  Should not happen
					MessageBox("Error", "No 'To Carton' Found to Adjust.  Please contact support.")  //Should not happen
					dw_content.reset()
				Else //Loop Through Content
				
					//09-JULY-2018 :Madhu DE4725 - Merge Carton Id's appropriately - START
					For k =1 to in_pallet_parms.ids_carton_list.rowcount( )
					
						lsFromCartonNo = in_pallet_parms.ids_carton_list.Object.carton_no[k]
						IF lsPrevCartonNo <> lsFromCartonNo THEN
						
							lsfind = "Container_Id = '" + in_pallet_parms.ids_carton_list.Object.carton_no[k] + "'"
							llFromCartonRow = dw_content.find( lsfind, 1, dw_content.rowcount())
							
							IF llFromCartonRow > 0 THEN
								ll_count = dw_content.Object.avail_qty[llFromCartonRow]
								dw_content.Object.avail_qty[llFromCartonRow] = 0
								dw_content.Object.avail_qty[llToCartonRow] = Long(dw_content.Object.avail_qty[lLToCartonRow]) + ll_count
							END IF
						END IF
						
						lsPrevCartonNo= lsFromCartonNo
					Next
					//09-JULY-2018 :Madhu DE4725 - Merge Carton Id's appropriately - END
				end if  //To Carton
			end if // Not Enough Adjustment Rows

		/* TAM 2019/03 - s29812 - BEGIN - Mixed Containerization -  */
		elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_FOOTPRINT  then
		
			// Ensure content quantity >= sum of the carton count
			// For each Original Pallet/Original Carton we need to Copy a New Pallet/Original Carton setting the attributes to "insert"
			// Modify the quantity of the first row (source)  qty = 0
			// Modify the quantity of the copied row (destination)  qty = source qty
			// Set new SSCC # (pallet id) on copied row
			
			llContentRowCount = dw_content.RowCount()
			if dw_content.RowCount() < 1 then
				MessageBox("Error", "Expecting at least one row.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
				dw_content.reset()
			else		
				If in_pallet_parms.is_to_scan_type = 'P' Then //Merge To Pallet
					If in_pallet_parms.is_to_pallet_type = 'C' Then //Merge Cartons To Pallet
						for k = 1 to llContentRowCount
							ll_count = dw_content.Object.avail_qty[k]
							dw_content.RowsCopy(k,k,Primary!,dw_content,dw_content.RowCount()+1,Primary!) //Copy to end
							dw_content.SetItemStatus ( dw_content.RowCount(), 0, Primary!, NewModified!)
					
							dw_content.Object.avail_qty[dw_content.RowCount()] = Long(dw_content.Object.avail_qty[k])
							dw_content.Object.avail_qty[k] = 0
							dw_content.Object.po_no2[dw_content.RowCount()] = in_pallet_parms.is_sscc_nr
						next

					Else //Merge Cartons or Serial Numbers to a Serialized Pallet. *Note.  Existing cartons will  lose their Carton ID

						llContentRowCount = dw_content.RowCount()
			
						if dw_content.RowCount() < 2 then
							MessageBox("Error", "Expecting at least 2 rows.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
							dw_content.reset()
						else		
							lsfind = "Po_No2 = '" + in_pallet_parms.is_sscc_nr + "'" // Get the to Pallet ID
							llToPalletRow = dw_content.find(lsFind,1, dw_content.RowCount())
							If llToPalletRow < 1 then // No "TO Pallet" Found.  Should not happen
								MessageBox("Error", "No 'To Pallet' Found to Adjust.  Please contact support.")  //Should not happen
								dw_content.reset()
							Else //Loop Through Content

								For k =1 to in_pallet_parms.ids_pallet_carton_list.	rowcount( )

									lsFromCartonNo = in_pallet_parms.ids_pallet_carton_list.Object.carton_id[k]
									IF lsPrevCartonNo <> lsFromCartonNo THEN
						
									lsfind = "Container_Id = '" + in_pallet_parms.ids_pallet_carton_list.Object.carton_id[k] + "' and Po_No2 = '" + in_pallet_parms.ids_pallet_carton_list.Object.po_no2[k] + "'"
									llFromCartonRow = dw_content.find( lsfind, 1, dw_content.rowcount())

										IF llFromCartonRow > 0 THEN
											ll_count = dw_content.Object.avail_qty[llFromCartonRow]
											dw_content.Object.avail_qty[llFromCartonRow] = ll_count - in_pallet_parms.ids_pallet_carton_list.Object.qty[k]
											dw_content.Object.avail_qty[llToPalletRow] = dw_content.Object.avail_qty[llToPalletRow] + in_pallet_parms.ids_pallet_carton_list.Object.qty[k]
										END IF
									END IF
						
									lsPrevCartonNo= lsFromCartonNo
								Next

							End If
						End If
					End If
				Else //Merge To Carton

					llContentRowCount = dw_content.RowCount()
			
					if dw_content.RowCount() < 2 then
						MessageBox("Error", "Expecting at least 2 rows.  Found: " + String(dw_content.RowCount()) + " row(s).  Please contact support.")
						dw_content.reset()
					else		
			
						lsfind = "Container_Id = '" + in_pallet_parms.is_carton_id + "'" // Get the to Carton ID
						llToCartonRow = dw_content.find(lsFind,1, dw_content.RowCount())
						If llToCartonRow < 1 then // No "TO CARTON"Found.  Should not happen
							MessageBox("Error", "No 'To Carton' Found to Adjust.  Please contact support.")  //Should not happen
							dw_content.reset()
						Else //Loop Through Content
				
							//09-JULY-2018 :Madhu DE4725 - Merge Carton Id's appropriately - START
							For k =1 to in_pallet_parms.ids_pallet_carton_list.	rowcount( )
					
								lsFromCartonNo = in_pallet_parms.ids_pallet_carton_list.Object.carton_id[k]
								IF lsPrevCartonNo <> lsFromCartonNo THEN
						
									lsfind = "Container_Id = '" + in_pallet_parms.ids_pallet_carton_list.Object.carton_id[k] + "'"
									llFromCartonRow = dw_content.find( lsfind, 1, dw_content.rowcount())
							
									IF llFromCartonRow > 0 THEN
										//GailM 1/6/2020 DE14071 Disallow merge if From Carton is partially allocated (Footprint needing container split) 
										liResult = f_is_container_allocated( lsFromCartonNo )
										If  liResult = 1 Then
											MessageBox("Error","Container " + lsFromCartonNo + " is partially allocated and cannot be merged at this time.",StopSign!)
											dw_content.reset()
										Else
											ll_count = dw_content.Object.avail_qty[llFromCartonRow]
											dw_content.Object.avail_qty[llFromCartonRow] = ll_count - in_pallet_parms.ids_pallet_carton_list.Object.qty[k]
											dw_content.Object.avail_qty[llToCartonRow] = dw_content.Object.avail_qty[lLToCartonRow] + in_pallet_parms.ids_pallet_carton_list.Object.qty[k]
										End If
									END IF
								END IF
						
								lsPrevCartonNo= lsFromCartonNo
							Next
							//09-JULY-2018 :Madhu DE4725 - Merge Carton Id's appropriately - END
						end if  //To Carton
					end if // Not Enough Adjustment Rows
				end if //Pallet or Carton Merge
			end if  // Not Enough Adjustment Rows

		END IF //Adjustment Type
	
	ELSE
		destroy in_pallet_parms
	END IF //execution success
END IF //valid pallet_parms
end event

public function integer wf_validations ();Decimal	ldNewQty
Long	llRowPos, llRowCount, llCount, llSerialCount
String	lsWarehouse, lsSku, ls_supp, lsRef, lsReason

//Get Header Info
lsWarehouse = dw_adjust.GetITemString(1,"wh_code")
lsSku = dw_adjust.GetITemString(1,"sku")
ls_supp = dw_adjust.GetITemString(1,"supp_code")
lsRef = dw_adjust.GetITemString(1,"ref_no")
lsReason  = dw_adjust.GetITemString(1,"Reason")

If f_check_required(this.title, dw_adjust ) = -1 Then
	dw_adjust.SetFocus()
	Return -1
End If


llRowCount = dw_content.RowCount()
If llRowCount = 0 Then Return 0

ldNewQty = 0
	
For llRowPos = 1 to llRowCount
	ldNewQty += dw_content.GetITemNumber(llRowPos,"avail_qty")
Next

If rb_serial_reconcile.checked = true THEN
 	if dw_serial.DeletedCount() = 0  and dw_serial.ModifiedCount() = 0 then
		MessageBox ("Adjustment","There are no changes to the Serial data.")
		Return -1
	end if
END IF

// 03/05 - PCONKL _ Unless it is a QTY Chg, Orig Qty must = Ending Qty
If Not rb_adjust_qty.Checked Then /*qualitative adjustment, orig and ending qty must be the same*/
	
	If ldNewQty <> idOrigQty Then
		Messagebox('Adjust', 'New Qty MUST equal Original qty for qualitative adjustments!',StopSign!)
		Return -1
	End If
	
Else /*Quantitative chg - orig and ending qty must be different (to trap for a qualitative chg between existing buckets*/

	If ldNewQty = idOrigQty Then
		Messagebox('Adjust', 'New Qty MUST be different than Original qty for Quantitative adjustments!~r~rIf you are trying to move stock between 2 existing buckets,~rmake a qualitative adjustment instead.',StopSign!)
		Return -1
	End If
	
End If /*Not a qty Chg */


//For Logitech, we need to validate reson code against dropdown (table)
// dts 062607 - Now doing this for Maquet and Phoenix Brands as well...
// 2/7/2011; David C; Adding PANDORA to this validation also
//BCR 15-DEC-2011: Treat Bluecoat same as Pandora
//GailM 3/11/2019 Add PhilipsCLS to make reason code required.
If Upper(gs_Project) = 'LOGITECH' or Upper(gs_Project) = 'MAQUET' or Upper(gs_Project) = 'PHXBRANDS' or Upper ( gs_Project ) = "PANDORA" or Upper ( gs_Project ) = "BLUECOAT" or Upper ( gs_Project ) = 'PHILIPSCLS' or Upper ( gs_Project ) = 'PHILIPS-DA' Then // Dinesh - 11/23/2020- S51444- PHILIPS-DA
	
	If isNull(lsReason) or lsReason = '' Then
		
		messagebox(w_adjust_create.title, "Reason Code is required!",StopSign!)
		dw_adjust.SetFocus()
		dw_adjust.SetColumn('reason')
		Return -1
			
	Else
		
		Select Count(*) into :llCount
		From Lookup_Table
		Where project_id = :gs_project and code_type = 'IA' and code_id = :lsReason;
	
		If llCount < 1 Then
			messagebox(w_adjust_create.title, "Invalid Reason Code. Please select from the dropdown list!",StopSign!)
			dw_adjust.SetFocus()
			dw_adjust.SetColumn('reason')
			Return -1
		End If
		
	End If /*reason cd */
	
End If /* Logitech/Maquet/Phoenix */

//BCR 29-JUN-2011: Prevent leading and trailing spaces in Serial No entries...
llRowPos = dw_content.GetNextModified(0, Primary!)
DO WHILE llRowPos > 0
	If LEFT(dw_content.GetITemString(llRowPos,"serial_no"), 1) = ' ' THEN 
		MessageBox(w_adjust_create.title, "Please remove leading spaces from Serial Number!", StopSign!)	
		f_setfocus(dw_content, llRowPos, "serial_no")
		Return -1
	END IF
	
	If RIGHT(dw_content.GetITemString(llRowPos,"serial_no"), 1) = ' ' THEN 
		MessageBox(w_adjust_create.title, "Please remove trailing spaces from Serial Number!", StopSign!)	
		f_setfocus(dw_content, llRowPos, "serial_no")
		Return -1
	END IF
	
	llRowPos = dw_content.GetNextModified(llRowPos, Primary!)
	
LOOP
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

//When user select NN6 or NN7 adjustment type, they require to be reminded to use SPLIT. 
//Due to the impact on the message sent to Nike,  User should not be allowed to confirm adjustment if SPLIT is not used.

If Left(Upper(gs_Project),4) = 'NIKE' Then

	If isNull(lsReason) or lsReason = '' Then
	
		messagebox(w_adjust_create.title, "Reason Code is required!",StopSign!)
		dw_adjust.SetFocus()
		dw_adjust.SetColumn('reason')
		Return -1
		
	END IF
	
	If left(lsReason,3) = 'NN6' OR left(lsReason,3) = 'NN7' then

		If dw_content.Find("c_split_ind = '1' or c_split_ind = '2'",1,dw_content.RowCount()) = 0 Then /*rows not split*/

			MessageBox (w_adjust_create.title, "For 'NN6' or 'NN7' Adjustment Type, you are required to use a SPLIT.")
			Return -1
	
		End IF
	
	End if

End IF

Return 0
end function

public subroutine wf_enable_break_pallet ();// LTK 20131013  Pandora #657 method controls enabling of the pallet break command button
cb_pallet_adjust.Enabled = false
				
//  TAM S29817 - Disable Merge Carton - Functionality has been ccombined with MERGE_FOOTPRINT - Remove Radio Button
//	and (rb_adjust_break_pallet.Checked or rb_adjust_merge_pallet.Checked or rb_adjust_break_carton.Checked or rb_adjust_merge_carton.Checked)  &
if Upper(gs_project) = 'PANDORA'  &
	and (rb_adjust_break_pallet.Checked or rb_adjust_merge_pallet.Checked or rb_adjust_break_carton.Checked)  &
	and dw_adjust.RowCount() > 0 then
	
	String ls_po_no2_controlled_ind, ls_supp_code, ls_sku

	ls_sku = dw_adjust.Object.sku[1]
	ls_supp_code = dw_adjust.Object.supp_code[1]

	if Len(ls_sku) > 0 and Len(ls_supp_code) > 0 then

		select po_no2_controlled_ind
		into :ls_po_no2_controlled_ind
		from item_master WITH (NOLOCK)
		where project_id = :gs_project
		and sku = :ls_sku
		and supp_code = :ls_supp_code;
		
		if sqlca.sqlcode = 0 then
			if Upper(ls_po_no2_controlled_ind) = 'Y' then
				cb_pallet_adjust.Enabled = true
			end if
		end if
	end if
end if

end subroutine

public function integer wf_adjust_serial (long alrow);
String	lsFind
Long	llOrigRow, llNewRow

dw_Content.AcceptText()
dw_Serial.AcceptText()

//If a serial row is modified, we need to update the corresponding content rows - decrement 1 and increment another.
//If a row doesn't exist for the new set of attributes, we will split the original row and create a new one

//find the original row
lsFind = "Upper(ro_no) = '" + Upper(dw_serial.GetITemString(alRow,'ro_no',primary!,True)) + "'"
lsFind += " and Upper(l_code) = '" + Upper(dw_serial.GetITemString(alRow,'l_code',Primary!,True)) + "'"
lsFind += " and Upper(sku) = '" + Upper(dw_serial.GetITemString(alRow,'sku',primary!,True)) + "'"
lsFind += " and Upper(inventory_type) = '" + Upper(dw_serial.GetITemString(alRow,'inventory_type',primary!,True)) + "'"
lsFind += " and Upper(lot_no) = '" + Upper(dw_serial.GetITemString(alRow,'lot_no',primary!,True)) + "'"
lsFind += " and Upper(po_no) = '" + Upper(dw_serial.GetITemString(alRow,'po_no',primary!,True)) + "'"
lsFind += " and Upper(po_no2) = '" + Upper(dw_serial.GetITemString(alRow,'po_no2',primary!,True)) + "'"
lsFind += " and String(expiration_date,'MMDDYYYY') = '" + String(dw_serial.GetITemDateTime(alRow,'exp_dt',primary!,True),'MMDDYYYY') + "'"
lsFind += " and avail_qty > 0 " /* we might be decrementing multiple content rows */
		
llOrigRow = dw_Content.Find(lsFind,1,dw_Content.RowCount())
			
If llOrigRow < 1 Then
	Messagebox("Adjust", "Corresponding Inventory record not found for Serial Number '" + dw_serial.GetITemString(alRow,'serial_no') + "' ~rOr multiple Serial updates decrementing Inventory below 0.~rUnable to delete Serial Number~r~rClick 'Reset' to review and start again.",Stopsign!)
	dw_Serial.ScrolltoRow(alrow)
	cb_adjust_Ok.Enabled = False
	cb_delete_Serials.Enabled = False
	cb_swap_Serial.Enabled = False //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	Return -1
End If

//Find the new row (if it exists)
lsFind = "Upper(ro_no) = '" + Upper(dw_serial.GetITemString(alRow,'ro_no')) + "'"
lsFind += " and Upper(l_code) = '" + Upper(dw_serial.GetITemString(alRow,'l_code')) + "'"
lsFind += " and Upper(sku) = '" + Upper(dw_serial.GetITemString(alRow,'sku')) + "'"
lsFind += " and Upper(inventory_type) = '" + Upper(dw_serial.GetITemString(alRow,'inventory_type')) + "'"
lsFind += " and Upper(lot_no) = '" + Upper(dw_serial.GetITemString(alRow,'lot_no')) + "'"
lsFind += " and Upper(po_no) = '" + Upper(dw_serial.GetITemString(alRow,'po_no')) + "'"
lsFind += " and Upper(po_no2) = '" + Upper(dw_serial.GetITemString(alRow,'po_no2')) + "'"
lsFind += " and String(expiration_date,'MMDDYYYY') = '" + String(dw_serial.GetITemDateTime(alRow,'exp_dt'),'MMDDYYYY') + "'"
lsFind += " and avail_qty > 0 " /* we might be decrementing multiple content rows */
		
llNewRow = dw_Content.Find(lsFind,1,dw_Content.RowCount())

If llNewRow > 0 Then
	
	//Deccrement from old and increment new content record
	dw_Content.SetItem(llOrigRow,'avail_qty',dw_Content.GetITemNumber(llOrigRow,'avail_qty') - 1)
	dw_Content.SetItem(llNewRow,'avail_qty',dw_Content.GetITemNumber(llNewRow,'avail_qty') + 1)
	
	dw_Content.SetITem(llOrigRow,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
	dw_Content.SetITem(llNewRow,'c_adjust_by_serial','Y')
	
Else /* need to split the existing row */
	
	dw_content.RowsCopy(llOrigRow,llOrigRow, Primary!, dw_content,llOrigRow + 1, Primary!)
	llNewRow = llOrigRow + 1
	
	dw_Content.SetItem(llOrigRow,'avail_qty',dw_Content.GetITemNumber(llOrigRow,'avail_qty') - 1)
	dw_Content.SetItem(llNewRow,'avail_qty',1)
	
	dw_Content.SetITem(llNewRow,'Inventory_Type', dw_serial.GetITemString(alRow,'inventory_type'))
	dw_Content.SetITem(llNewRow,'lot_no', dw_serial.GetITemString(alRow,'lot_no'))
	dw_Content.SetITem(llNewRow,'po_no', dw_serial.GetITemString(alRow,'po_no'))
	dw_Content.SetITem(llNewRow,'po_no2', dw_serial.GetITemString(alRow,'po_no2'))
	dw_Content.SetITem(llNewRow,'expiration_date', dw_serial.GetITemDateTime(alRow,'exp_dt'))
	
	//Denote Split, original row = 1, new = 2
	dw_content.SetItem(llOrigRow,'c_split_ind','1')
	dw_content.SetItem(llNewRow,'c_split_ind','2')

	dw_Content.SetITem(llOrigRow,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
	dw_Content.SetITem(llNewRow,'c_adjust_by_serial','Y')
	
End If




Return 0
end function

public function integer wf_check_serial_number_exist ();//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

long ll_Idx
//string ls_LCode, lsSku, lsSerial, lsSerialLoc, ls_NewSerialNo, lsTransParm, lsSerialWhCode
string lsSku, ls_LCode, ls_NewSerialNo, lsTransParm
string lsSerialLoc, lsSerialWhCode, lsSerialNo
integer li_count
datetime ldtToday
//string ls_WhCode , ls_CCNo
decimal ld_Avail_Qty
string lsSerialSwapFlag

//long  ll_find , ll_Row,  ll_ContentRow
//long ll_owner_ID
//string lsOwnerCode
//

//ls_CCNo = idw_main.GetItemString( 1, "CC_No")
//ls_WhCode = idw_main.GetItemString( 1, "wh_code")

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process - Turn this off until needed
lsSerialSwapFlag = f_retrieve_parm("PANDORA","SERIAL_SWAP","SERIAL_NUMBER_SWAP")

//If Not enabled return
IF IsNull(lsSerialSwapFlag) OR Upper(lsSerialSwapFlag) <> 'Y' THEN Return 0


For ll_Idx = 1 to dw_serial.RowCount()

	If dw_Serial.getItemStatus(ll_Idx,"serial_no",Primary!) = NewModified! OR dw_Serial.getItemStatus(ll_Idx,"serial_no",Primary!) = DataModified! Then

		lsSerialNo =  dw_Serial.GetItemString(ll_Idx,"serial_no")
		lsSku = dw_Serial.GetItemString(ll_Idx,"sku")
		ls_LCode =  dw_Serial.GetItemString(ll_Idx,"l_code")

		//Check for Serial Numbers that are not in this location. 
		//There can only be one since the Serial_Number_Inventory PK is Project/Sku/Serial_No
	
		//We should have to limit on And l_code <> :ls_LCode 
	
		SELECT count(*), l_code, Wh_Code INTO :li_count, :lsSerialLoc, :lsSerialWhCode FROM Serial_Number_Inventory With (NoLock)
			Where project_id = :gs_project AND serial_no = :lsSerialNo and sku = :lsSku 
			GROUP BY l_code, Wh_Code USING SQLCA;			
			
//--
		If li_count > 0 Then
		
			ls_NewSerialNo = "?" + lsSerialNo
				
			SELECT sum(   dbo.Content_summary.Avail_Qty ) INTO :ld_Avail_Qty
			FROM dbo.Content_summary WITH (NOLOCK)
			WHERE 	( dbo.Content_summary.Avail_Qty > 0 ) 
			 and  content_summary.sku = :lsSku  and  content_summary.l_code = :lsSerialLoc  and content_summary.wh_code = :lsSerialWhCode USING SQLCA;
	
			If isNull(ld_Avail_Qty) then ld_Avail_Qty = 0
	
			if ld_Avail_Qty > 0 then
	
				Update  Serial_Number_Inventory SET serial_no = :ls_NewSerialNo 
				Where project_id = :gs_project AND serial_no = :lsSerialNo and sku = :lsSku and l_code = :lsSerialLoc and wh_code = :lsSerialWhCode USING SQLCA;
					
				If Sqlca.sqlcode <> 0  Then
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox("Stock Adjustment_Create","Unable to update existing serial number in Serial_Number_Inventory table: ~r~r" + sqlca.sqlerrtext)
					Return -1	
				End IF
		
			
				//Create batch_transaction record for Serial Number Rec
				
				//Position in Trans Parm
				//WH_Code = 1-10
				//L_Code = 12-21
				//Sku = 23 -
						
	//			ls_WhCode = mid(lsTrans_parm, 1, 10)
	//			ls_LCode = mid( lsTrans_parm, 12, 10)
	//			ls_Sku = mid(lsTrans_parm , 23)
				
				//GailM 11/25/2020 DE18220 Google SOC orders created from Serial Swap - Remove create SOC for serial swap
				/* BEGIN DE18220
				lsTransParm = lsSerialWhCode + space(10 - len(lsSerialWhCode)) + ":" + lsSerialLoc + space(10 - len(lsSerialLoc)) + ":" + lsSku
				
				//llAdjustID
		
				ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse(  ) ) 
	//MA 			'' = Adjument ID 
	
				Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
											Values(:gs_Project, 'SRCC', '','N', :ldtToday, :lsTransParm)
				Using SQLCA;		
		
				If Sqlca.sqlcode <> 0  Then
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox("Stock Adjustment_Create","Unable to create for existing serial number found in Inventory: ~r~r" + sqlca.sqlerrtext)
					Return -1	
				End IF		
						FINISHED DE18220*/
			Else
		
				//Serial_number not in inventory so delete. 
				
				Delete from  Serial_Number_Inventory 
				Where project_id = :gs_project AND serial_no = :lsSerialNo and sku = :lsSku and l_code = :lsSerialLoc and wh_code = :lsSerialWhCode USING SQLCA;
					
				If Sqlca.sqlcode <> 0  Then
					Execute Immediate "ROLLBACK" using SQLCA;
					MessageBox("Stock Adjustment_Create","Unable to update existing serial number in Serial_Number_Inventory table: ~r~r" + sqlca.sqlerrtext)
					Return -1	
				End IF			
					
		
			End IF
			
		End IF

	End If		 
		
Next		
	
 Return 0
end function

public function long wf_create_item_serial_change_record (string as_project, string as_sku, string as_wh, string as_suppcode, long al_ownerid, string as_pono, string as_old_pono, string as_from_serial_no, string as_to_serial_no, boolean ab_suppress_947);//27-Dec-2017 :Madhu PEVS-806 3PL CC Orders
//Insert Record into Item Serial Change History Table

long ll_count, ll_Trans_Id
DateTime ldtToday
String ls_Transaction_Sent

ldtToday = DateTime(today() ,now())

select count(*) into :ll_count from Item_Serial_Change_History with(nolock)
where Project_Id= :as_project and sku=:as_sku
and wh_code =:as_wh and Owner_Id =:al_ownerId
and ( From_Serial_No =:as_from_serial_no and To_Serial_No =:as_to_serial_no)
and Transaction_Sent <>'Y'
using sqlca;

If ll_count = 0 Then

	if ab_suppress_947 = true then
		//We don't want to sent 947s. If I set it to anything other than 'Y', then it will get sent in the sweeper.
		ls_Transaction_Sent = 'Y'
	else
		SetNull(ls_Transaction_Sent)
	end if

	//Insert record into Item_Serial_change_history table
	Insert into Item_Serial_Change_History (Project_Id,WH_Code,Owner_Id,PO_No,Sku,Supp_Code,From_Serial_No,To_Serial_No,Transaction_Sent, Update_User, Complete_Date, Old_Po_No)
	values (:as_project, :as_wh, :al_ownerId, :as_pono, :as_sku, :as_suppcode, :as_from_serial_no, :as_to_serial_no, :ls_Transaction_Sent, 'SIMSFP', :ldtToday, :as_old_pono)
	using sqlca;
	//commit;	//GailM 7/22/2020 DE16865 Google DB Blocking Issue - Let this insert be committed when all other changes are committed in closequery() event
End If

select Max(Id_No) into :ll_Trans_Id from Item_Serial_Change_History with(nolock)
where Project_Id= :as_project and sku=:as_sku
and wh_code =:as_wh and Owner_Id =:al_ownerId and PO_No =:as_pono
and  From_Serial_No =:as_from_serial_no and To_Serial_No =:as_to_serial_no
and Transaction_Sent <> 'Y' and Update_User='SIMSFP'
using sqlca;

Return ll_Trans_Id
end function

on w_adjust_create.create
this.p_empty=create p_empty
this.p_arrow=create p_arrow
this.cb_swap_serial=create cb_swap_serial
this.st_retrieve_sn=create st_retrieve_sn
this.rb_serial_reconcile=create rb_serial_reconcile
this.cb_adjust_import=create cb_adjust_import
this.cbx_serial_retrieve=create cbx_serial_retrieve
this.cb_add_serial=create cb_add_serial
this.cb_delete_serials=create cb_delete_serials
this.dw_serial=create dw_serial
this.rb_adjust_break_carton=create rb_adjust_break_carton
this.rb_adjust_merge_pallet=create rb_adjust_merge_pallet
this.rb_adjust_break_pallet=create rb_adjust_break_pallet
this.cb_pallet_adjust=create cb_pallet_adjust
this.cb_adjust_reset=create cb_adjust_reset
this.rb_adjust_other=create rb_adjust_other
this.rb_adjust_inv_type=create rb_adjust_inv_type
this.rb_adjust_owner=create rb_adjust_owner
this.rb_adjust_qty=create rb_adjust_qty
this.cb_adjust_sort=create cb_adjust_sort
this.cb_adjust_help=create cb_adjust_help
this.cb_adjust_split=create cb_adjust_split
this.cb_adjust_cancel=create cb_adjust_cancel
this.cb_adjust_ok=create cb_adjust_ok
this.dw_adjust=create dw_adjust
this.gb_adjustment_type=create gb_adjustment_type
this.dw_content=create dw_content
this.Control[]={this.p_empty,&
this.p_arrow,&
this.cb_swap_serial,&
this.st_retrieve_sn,&
this.rb_serial_reconcile,&
this.cb_adjust_import,&
this.cbx_serial_retrieve,&
this.cb_add_serial,&
this.cb_delete_serials,&
this.dw_serial,&
this.rb_adjust_break_carton,&
this.rb_adjust_merge_pallet,&
this.rb_adjust_break_pallet,&
this.cb_pallet_adjust,&
this.cb_adjust_reset,&
this.rb_adjust_other,&
this.rb_adjust_inv_type,&
this.rb_adjust_owner,&
this.rb_adjust_qty,&
this.cb_adjust_sort,&
this.cb_adjust_help,&
this.cb_adjust_split,&
this.cb_adjust_cancel,&
this.cb_adjust_ok,&
this.dw_adjust,&
this.gb_adjustment_type,&
this.dw_content}
end on

on w_adjust_create.destroy
destroy(this.p_empty)
destroy(this.p_arrow)
destroy(this.cb_swap_serial)
destroy(this.st_retrieve_sn)
destroy(this.rb_serial_reconcile)
destroy(this.cb_adjust_import)
destroy(this.cbx_serial_retrieve)
destroy(this.cb_add_serial)
destroy(this.cb_delete_serials)
destroy(this.dw_serial)
destroy(this.rb_adjust_break_carton)
destroy(this.rb_adjust_merge_pallet)
destroy(this.rb_adjust_break_pallet)
destroy(this.cb_pallet_adjust)
destroy(this.cb_adjust_reset)
destroy(this.rb_adjust_other)
destroy(this.rb_adjust_inv_type)
destroy(this.rb_adjust_owner)
destroy(this.rb_adjust_qty)
destroy(this.cb_adjust_sort)
destroy(this.cb_adjust_help)
destroy(this.cb_adjust_split)
destroy(this.cb_adjust_cancel)
destroy(this.cb_adjust_ok)
destroy(this.dw_adjust)
destroy(this.gb_adjustment_type)
destroy(this.dw_content)
end on

event open;Integer			li_ScreenH, li_ScreenW
Environment	le_Env


// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

iwWindow = This

isOrigSQL = dw_content.GetSQlSelect()
isOrigSQLSerial = dw_serial.GetSqlSelect()

This.PostEvent("ue_postOpen")


end event

event closequery;Long llRowCount,	llRowPos, llRC, ll_owner, ll_orig_OWner, llAdjustID, llModCount , ll_Component_No, llFindRow, ll_Id_No, llCartonRowCount
Long llContentRow,ll_qty,ll_comp_qty,llcomp_qty,llRowCount1,ll_comp_no,ll_qty_diff,k,ll_rtn
boolean lb_suppress_947,lb_check
String ls_cc_class_Code,lsRONO1,ls_owner_cd

Str_parms	lstrparms
		
decimal 	ldAvailQty,	ldNewQty, ld_tot_new_qty
		
String	lsType,	lsOldType, lsSerial,	lsLot, lsPO, lsWarehouse, lsSku, lsRef, lsReason, lsLoc,			&
			lsRONO, lsRONO20, lspo2, lsoldpo2, ls_container_ID, ls_supp, ls_coo,	ls_oldcoo, lsContainerList,	&
			lsTransParm, lsMsg, lsTitle, lsoldlot, lsRemarks, lsFind, lsoldpo, lsSerialSwapFlag, lsPrevSerial
			
DateTime	ldtToday, ldt_expiration_date, ldtOldExpDT //GAP 11/02 added exp.date
datastore lds_adjust_qty
lds_adjust_qty = create datastore

//Get out if canceled
If ibCancel Then
	Return 0
End IF

llRowCount = dw_content.RowCount()
//If llRowCount = 0 Then Return 0
// LTK 20140327  Allow to continue if only carton_serial table being updated
If llRowCount = 0 and NOT IsValid(in_pallet_parms) Then 
	
	If rb_serial_reconcile.checked = true then
		
		If dw_serial.DeletedCount() > 0 then
			dw_serial.Update()
		End If	
	end if
	
	Return 0
End If

dw_adjust.AcceptText()
// pvh - 11/28/06 - moved here after accepttext to avoid multiple messages
g.of_check_label(dw_adjust) 


If dw_content.AcceptText() < 0 Then REturn 1

//05-Oct-2016 :Madhu- Update Reason code to content records -START
For llRowPos=1 to llRowCount
	If dw_content.getItemstatus( llRowPos, 0, Primary!) =DataModified! Then
			dw_content.setItem( llRowPos, 'Adj_Reason', dw_adjust.getItemString(1,"Reason"))
	End If
Next
//05-Oct-2016 :Madhu- Update Reason code to content records -END

lsRef = dw_adjust.getItemString(1,"ref_no")
lsReason  = dw_adjust.getItemString(1,"Reason")
lsRemarks  = dw_adjust.getItemString(1,"remarks") /* 11/11 - PCONKL */
lsMsg = ""
llModCount = 0

SetPointer(Hourglass!)

dw_content.AcceptText()
dw_serial.AcceptText()

//Validations
If wf_validations() < 0 Then Return 1

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
		
lsSerialSwapFlag = f_retrieve_parm("PANDORA","SERIAL_SWAP","SERIAL_NUMBER_SWAP")


//00/04 - PCONKL - Moved save of Content before creation of adjustment records

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
//SQLCA.DBParm = "disablebind =0" /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/


//SQLCA.DBParm = "disablebind =0"
llrc = dw_Content.Update(False,False) /*edi confirmation needs the original flag values*/
//SQLCA.DBParm = "disablebind =1"  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/

If llRc < 1 Then
	Execute Immediate "ROLLBACK" using SQLCA;
	IF dw_content.ib_error THEN //dgm for duplicate rows see also dberror event of dw_content
//			Messagebox("Stock Adjustment_Create","Attempt to insert duplicate record please check",StopSign!)
		dw_content.ib_error = false
		dw_content.SetColumn('avail_qty')
	ELSE	
		MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment")
	END IF	
	Return 1
End IF

//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

llRc = wf_check_serial_number_exist()
If llRc = 0 Then			//GailM 6/4/2020 To reduce or eliminate DB locks.  wf_check_serial_number_exist was not being checked for error
	// 04/14 - PCONKL - Update Serial Records
	llrc = dw_Serial.Update(False,False) 
	If llRc < 1 Then
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment - Unable to process Serial Number records")
		Return 1
	End IF
Else
	Return 1
End If

// LTK 20131013  Pandora #657 Pallet break logic
// If this object is instantiated at this point, then the carton_serial table requires updating

//TAM 2018/01 S14838 - Change from carton_serial to Serial_Number_Inventory
if IsValid(in_pallet_parms) then

	String ls_carton_serial_update
	Long	i
	
	if in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_CARTON then
		// Merge Carton
//		ls_carton_serial_update = "update carton_serial "
//		ls_carton_serial_update += " set pallet_id = '" + in_pallet_parms.is_sscc_nr + "', "
//		ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id + "' "
//		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
//		ls_carton_serial_update +=  "and sku = '" + in_pallet_parms.is_sku + "' "
//		ls_carton_serial_update += " and status_cd <> 'D' "
//		ls_carton_serial_update += " and serial_no in " + in_pallet_parms.of_get_serial_in_string_merge()
		ls_carton_serial_update = "update serial_number_inventory "
		ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr + "', "
		ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id_new + "', "
// TAM 2019/05 - S33409 - Populate Serial History Table
		ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
		ls_carton_serial_update += " Transaction_ID = '', "
		ls_carton_serial_update += " Adjustment_Type = 'MERGE_CARTON' "
		
		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
		ls_carton_serial_update +=  "and sku = '" + in_pallet_parms.is_sku + "' "
		ls_carton_serial_update += " and serial_no in " + in_pallet_parms.of_get_serial_in_string_merge()

	elseif 	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART then
		// Carton Break
//		ls_carton_serial_update = "update carton_serial "
//		ls_carton_serial_update += " set pallet_id = '" + in_pallet_parms.is_sscc_nr_new + "', "
//		ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id_new + "' "
//		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
//		ls_carton_serial_update +=  "and sku = '" + in_pallet_parms.is_sku + "' "
//		ls_carton_serial_update += " and carton_id = " + in_pallet_parms.is_carton_id
//		ls_carton_serial_update += " and status_cd <> 'D' "
//		ls_carton_serial_update += " and pallet_id = '" + in_pallet_parms.is_sscc_nr + "'"
//		ls_carton_serial_update += " and serial_no in " + in_pallet_parms.of_get_serial_in_string()
		ls_carton_serial_update = "update serial_number_inventory "
		ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr_new + "', "
		ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id_new + "', "
// TAM 2019/05 - S33409 - Populate Serial History Table
		ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
		ls_carton_serial_update += " Transaction_ID = '', "
		ls_carton_serial_update += " Adjustment_Type = 'BREAK_CARTON' "

		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
		ls_carton_serial_update +=  "and sku = '" + in_pallet_parms.is_sku + "' "
		ls_carton_serial_update += " and carton_id = '" + in_pallet_parms.is_carton_id+"' "
		ls_carton_serial_update += " and po_no2 = '" + in_pallet_parms.is_sscc_nr + "' "
		ls_carton_serial_update += " and serial_no in " + in_pallet_parms.of_get_serial_in_string()

//TAM 2019/03 S29817 - Footprints Mixed Containerization
	elseif 	in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_FOOTPRINT then
		If in_pallet_parms.is_to_scan_type = 'P' Then //Merging into Pallet
			If in_pallet_parms.is_to_pallet_type = 'C' Then //To Pallet is containerized

				ls_carton_serial_update = "update serial_number_inventory "
				ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr + "', "
			// TAM 2019/05 - S33409 - Populate Serial History Table
				ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
				ls_carton_serial_update += " Transaction_ID = '', "
				ls_carton_serial_update += " Adjustment_Type = 'MERGE_CONTAINER_PALLET' "

				ls_carton_serial_update += " where project_id = '" + gs_project + "' "
				ls_carton_serial_update += " and sku = '" + in_pallet_parms.is_sku + "' "

				// Build the where clause from the Pallet/Carton Datastore Parm
				ls_carton_serial_update += " and (" 
				//	loop through the pallet/carton rows to build the where clause for the FROM rows
				llCartonRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
				for i = 1 to llCartonRowCount
					if i = 1 then
						ls_carton_serial_update += " (serial_number_inventory.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					else
						ls_carton_serial_update += " or (serial_number_inventory.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					end if
					ls_carton_serial_update += "  and serial_number_inventory.carton_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
				next
				ls_carton_serial_update += ")"

			Else //To Pallet is Serialized
				ls_carton_serial_update = "update serial_number_inventory "
				ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr + "', "
				ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id + "', "
			// TAM 2019/05 - S33409 - Populate Serial History Table
				ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
				ls_carton_serial_update += " Transaction_ID = '', "
				ls_carton_serial_update += " Adjustment_Type = 'MERGE_SERIAL_PALLET' "

				ls_carton_serial_update += " where project_id = '" + gs_project + "' "
				ls_carton_serial_update += " and sku = '" + in_pallet_parms.is_sku + "' "
	
				// Build the where clause from the Pallet/Carton Datastore Parm and Serial Number List
				ls_carton_serial_update += " and (" 
				//	loop through the pallet/carton rows to build the where clause for the FROM rows
				llCartonRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
				boolean lbfirstcarton = true
				for i = 1 to llCartonRowCount
					// If pallet/carton = 'DUMMY'/'DUMMY' we want to skip changing this pallet/carton row.  This is a loose serial number and it will be changed by the serial list.  
					//We don't want to change all serials that are 'DUMMY'/'DUMMY' but it is on the pallet/carton list so we can do the adjustment to the QTY in wf_enable_break_pallet
					if (Upper(in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2')) = 'DUMMY' or &
					Upper(in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2')) = 'NA' or &
					in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') = '-') and &
					((Upper(in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Carton_Id')) = 'DUMMY' or &
					Upper(in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Carton_Id')) = 'NA' or &
					in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Carton_Id') = '-')) Then
						Continue
					end if

					if lbfirstcarton then
						ls_carton_serial_update += " (po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
						lbfirstcarton = False 
					else
						ls_carton_serial_update += " or (po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					end if
					ls_carton_serial_update += "  and carton_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
				next
				ls_carton_serial_update += " or serial_no in " + in_pallet_parms.of_get_serial_in_string_merge()
				
				ls_carton_serial_update += ")"

			End If
		Else	//Merging into Carton
				ls_carton_serial_update = "update serial_number_inventory "
				ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr + "', "
				ls_carton_serial_update += " carton_id = '" + in_pallet_parms.is_carton_id + "', "
			// TAM 2019/05 - S33409 - Populate Serial History Table
				ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
				ls_carton_serial_update += " Transaction_ID = '', "
				ls_carton_serial_update += " Adjustment_Type = 'MERGE_CARTON' "

				ls_carton_serial_update += " where project_id = '" + gs_project + "' "
				ls_carton_serial_update += " and sku = '" + in_pallet_parms.is_sku + "' "

				// Build the where clause from the Pallet/Carton Datastore Parm and Serial Number List
				ls_carton_serial_update += " and (" 
				//	loop through the pallet/carton rows to build the where clause for the FROM rows
				llCartonRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
				for i = 1 to llCartonRowCount
					if i = 1 then
						ls_carton_serial_update += " (po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					else
						ls_carton_serial_update += " or (po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					end if
					ls_carton_serial_update += "  and carton_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
				next
				ls_carton_serial_update += " or serial_no in " + in_pallet_parms.of_get_serial_in_string_merge()
				
				ls_carton_serial_update += ")"

		End If

	else
		// Pallet Break and Pallet Merge
//		ls_carton_serial_update = "update carton_serial "
//		ls_carton_serial_update += " set pallet_id = '" + in_pallet_parms.is_sscc_nr_new + "' "
//		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
//		ls_carton_serial_update += " and sku = '" + in_pallet_parms.is_sku + "' "
//		ls_carton_serial_update += " and carton_id in " + in_pallet_parms.of_get_container_in_string()
//		ls_carton_serial_update += " and status_cd <> 'D' "
		ls_carton_serial_update = "update serial_number_inventory "
		ls_carton_serial_update += " set po_no2 = '" + in_pallet_parms.is_sscc_nr_new + "', "
		// TAM 2019/05 - S33409 - Populate Serial History Table
		ls_carton_serial_update += " Transaction_Type = 'ADJUST', "
		ls_carton_serial_update += " Transaction_ID = '', "
		ls_carton_serial_update += " Adjustment_Type = 'MERGE_PALLET' "

		ls_carton_serial_update += " where project_id = '" + gs_project + "' "
		ls_carton_serial_update += " and sku = '" + in_pallet_parms.is_sku + "' "
		ls_carton_serial_update += " and carton_id in " + in_pallet_parms.of_get_container_in_string()
	
		if in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART then
			// Pallet Break
//			ls_carton_serial_update += " and pallet_id = '" + in_pallet_parms.is_sscc_nr + "'"
			ls_carton_serial_update += " and po_no2 = '" + in_pallet_parms.is_sscc_nr + "'"
		else
			// Pallet Merge
//			ls_carton_serial_update += " and pallet_id in " + in_pallet_parms.of_build_pallet_in_string()
			ls_carton_serial_update += " and po_no2 in " + in_pallet_parms.of_build_pallet_in_string()
		end if
	end if

	Execute Immediate :ls_carton_serial_update using SQLCA;

	if Sqlca.sqlcode <> 0  then
		Execute Immediate "ROLLBACK" using SQLCA;
//		MessageBox("Stock Adjustment_Create","Error updating carton_serial table: ~r~r" + sqlca.sqlerrtext)
		MessageBox("Stock Adjustment_Create","Error updating serial_number_inventory table: ~r~r" + sqlca.sqlerrtext)
		return 1	
	end if
end if

long liAdjCount = 0

//For Each modified Content row, Create an adjustment header
For llRowPos = 1 to llRowCount
	
	If dw_content.getItemStatus(llRowPos,0,Primary!) <> DataModified! &
	AND dw_content.getItemStatus(llRowPos,0,Primary!) <> NewModified! & 
	Then Continue 	
	
	// 04/14 - PCONKL - If C_Adjust_by_Serial is set to 'Y', it means we will create an adjustment record for each serial record from serial_Number_Inventory modified instead of 1 per content record - need to itemize
	If  dw_content.getItemString(llRowPos,"c_adjust_by_Serial") = 'Y' Then
		Continue
	End If
	
	//Get Header Info
	lsWarehouse = dw_content.getItemString(llRowPos,"wh_code")
	
	// pvh 11/23/05 - gmt
	//ldtToday = datetime(Today(),now())
	ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	
	lsSku = dw_content.getItemString(llRowPos,"sku")
	ls_supp = dw_content.getItemString(llRowPos,"supp_code")
		
	//get values for adjustment
	// 09/01 - PCONKL - changed DW to retreive original values twice, If we 'split' a row, there are no original values in the buffer
	lsOldType = dw_content.getItemString(llRowPos,"orig_inventory_type") /* 05/01 PCONKL - we're tracking changes to inv type now*/
	lsType = dw_content.getItemString(llRowPos,"inventory_type")
	lsSerial = dw_content.getItemString(llRowPos,"serial_no")

	lslot = dw_content.getItemString(llRowPos,"lot_no")
	lsoldlot = dw_content.getItemString(llRowPos,"orig_Lot_No") 
	//santosh - added new field for old_pono value
	lsoldpo = dw_content.getItemString(llRowPos,"orig_po_no")
	lspo = dw_content.getItemString(llRowPos,"po_no")
	lspo2 = dw_content.getItemString(llRowPos,"po_no2")
	lsoldpo2 = dw_content.getItemString(llRowPos,"orig_po_no2") /* 6/04 TAM Pass orig po_no2 */
	
	ls_container_ID  = dw_content.getItemString(llRowPos,"container_ID")   //GAP 11/02 
	
  	ldt_expiration_date  = dw_content.getItemDatetime(llRowPos,"expiration_date") //GAP 11/02 
	ldtOldExpDT = dw_content.getItemDatetime(llRowPos,"orig_expiration_date") /* 04/16 - PCONKL*/
	
	ll_owner = dw_content.getItemNumber(llRowPos,"owner_id")
	ll_orig_owner = dw_content.getItemNumber(llRowPos,"orig_owner_id")
	ls_coo = dw_content.getItemString(llRowPos,"country_of_origin")
	ls_oldcoo = dw_content.getItemString(llRowPos,"orig_country_of_origin") /* 6/04 TAM Pass orig COO */
	lsloc = dw_content.getItemString(llRowPos,"l_code")
	lsRONO = dw_content.getItemString(llRowPos,"receive_master_supp_invoice_no")
	If isnull(lsRONO) Then
		lsRONO =  dw_content.getItemString(llRowPos,"ro_no")
	End If
	ldAvailQty = dw_content.getItemNumber(llRowPos,"orig_qty") /*original value before update!*/
	ldNewQty = dw_content.getItemNumber(llRowPos,"avail_qty")
	
	//lsRONO1 =  dw_content.getItemString(llRowPos,"ro_no")
	ll_qty_diff= ldAvailQty - ldNewQty // Dinesh
	
	lsTransParm = dw_content.getItemString(llRowPos,"c_Parm")
	
	
	lssku= dw_content.getItemString(llRowPos,"sku") // Dinesh
	ll_comp_no= dw_content.getItemnumber(llRowPos,"component_no") // Dinesh
	
	
	//MEA - 7/12 - Disable for Stryker per BoonHee
	
	IF Upper(gs_project) <> 'STRYKER' THEN
	
		IF lsSerial <> '-' and ldNewQty > 1 THEN
				Execute Immediate "ROLLBACK" using SQLCA;	//DE16865
				Messagebox(w_adjust_create.title,"Serialized item quantity cannot be more than 1..",StopSign!)	
				dw_content.ScrollToRow ( llRowPos )
				dw_content.Setfocus()
				dw_content.Setcolumn("avail_qty")
				Return 1		 
		END IF 
		
	END IF
	 
	IF dw_content.getItemStatus(llRowPos,0,Primary!) = NewModified! THEN 
		ldAvailQty =0 //Added DGM 080901
	END IF
	
	ld_tot_new_qty += ldNewQty


	liAdjCount = liAdjCount + 1

	//Create an Adjustment Record 
	//SQLCA.DBParm = "disablebind =0"  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
	Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks, old_expiration_date) 
	values						(:gs_project,:lsSku,:ls_supp,:ll_orig_Owner,:ll_owner,:ls_coo,:ls_oldcoo,:lsWarehouse,:lsLoc,:lsOldType,:lsType, &
									:lsSerial,:lsLot,:lspo,:lsoldpo,:lspo2,:lsoldpo2,
									:ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty,:ldNewQty,:lsRef,:lsReason,:gs_userid,:ldtToday,:is_trans_type,
									:lsoldlot,:lsremarks, :ldtOldExpDT)  //GAP 11/02 Added cont/exp.date here  --// TAM 2005/04/18  Added Adjustment type from radio button selected., 11/11 - PCONKL -Added remarks, 04/16 - PCONKL - Added Old Expiration Date
	Using SQLCA;
	//SQLCA.DBParm = "disablebind =1"	 /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
	
	If Sqlca.sqlcode <> 0  Then
		Execute Immediate "ROLLBACK" using SQLCA;
		MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
		Return 1	
	End IF 
	 

//TAM 10/01/04 truncate rono to 20 (from "receive_master_supp_invoice_no" above)
	lsRONO20 = MID(lsRoNo,1,20)
	
	// 05/01 PCONKL - We need to display the Adjustment ID of the new record. Since it is auto generated by the DB, we need to retrieve it
	Select Max(Adjust_no) into :llAdjustID
	From	 Adjustment
	Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and supp_code = :ls_supp and last_user = :gs_userid and last_update = :ldtToday;
	
	If llAdjustID > 0 Then
		//02/06 - PCONKL - don't dispaly msgbox until after commit - leaving locks
		//	messageBox('New Adjustment ID','The Adjustment ID for Row # ' + string(llRowPos) + ' is: ' + string(llAdjustID) + '~r~rIf your procedures require it, please write this number down.')
		lsMsg += 'The Adjustment ID for Row # ' + string(llRowPos) + ' is: ' + string(llAdjustID) + "~r"
		// 09/03 - PCONKL - store the adjustment ID on the record so we can include it on EDI Collaboration (MM)
		dw_content.SetITem(llRowPos,'c_adjust_no',llAdjustID)
	
	Else
		lsMsg += 'Unable to retrieve the Adjustment ID for Row # ' + string(llRowPos)	//DE16865
	End If

	//01/12 - MEA - Nike - Only send EDI if valid reason code

	datawindowchild ldwChild
	integer liFind
	
	// 03/04 - PCONKL - We will also create a transaction record for the Sweeper to pick up and create a MM tranasction to the customer if necessary
	If dw_content.getItemString(llRowPos,'c_send_collab_ind') = 'Y' Then
			
		Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
										Values(:gs_Project, 'MM', :llAdjustID,'N', :ldtToday, :lsTransParm)
		Using SQLCA;
		
		If Sqlca.sqlcode <> 0  Then
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
			Return 1	
		End IF

	End If  /* send collab checkbox checked */
	
	llModCount ++

Next /* MOdified COntent Record*/

//04/14 - PCONKL - If Serial records modified or Deleted, write an itemized adjusment record for each serial number instead of the modified content record

dw_Serial.SetFilter("")
dw_Serial.Filter()

//Deleted Rows...
If dw_serial.DeletedCount() > 0 Then
	
	llRowCount = dw_serial.DeletedCount()
	For llRowPos = 1 to llRowCount
		
		//If a new serial row was created and Deleted, we don't need to create an adjustment
		If dw_content.getItemStatus(llRowPos,0,Delete!) = New! or dw_content.getItemStatus(llRowPos,0,Delete!) = NewModified! Then
			Continue 
		End If
		
		ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	
		//TAM - 2018/02/05 -Found bug on Delete.  Should get SKU from dw_serial
		//lsSku = dw_content.getItemString(llRowPos,"sku")
		lsSku = dw_Serial.getItemString(llRowPos,"sku",Delete!,True)
			
		//get values for adjustment
		lsOldType = dw_Serial.getItemString(llRowPos,"inventory_type",Delete!,True)
		lsType = dw_Serial.getItemString(llRowPos,"inventory_type",Delete!,True)
		lsSerial = dw_Serial.getItemString(llRowPos,"serial_no",Delete!,True)

		lslot = dw_Serial.getItemString(llRowPos,"lot_no",Delete!,True)
		lsoldlot = dw_Serial.getItemString(llRowPos,"Lot_No",Delete!,True) 
	
		lspo = dw_Serial.getItemString(llRowPos,"po_no",Delete!,True)
		lspo2 = dw_Serial.getItemString(llRowPos,"po_no2",Delete!,True)
		lsoldpo2 = dw_Serial.getItemString(llRowPos,"po_no2",Delete!,True) 
		lsloc = dw_Serial.getItemString(llRowPos,"l_code",Delete!,True)
	
		//ls_container_ID  = dw_content.getItemString(llRowPos,"container_ID")   
  		ldt_expiration_date  = dw_Serial.getItemDatetime(llRowPos,"exp_dt",Delete!,True) 
	
		// need some fields from Content record
		lsFind = "Upper(ro_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'ro_no',Delete!,True)) + "'"
		lsFind += " and Upper(l_code) = '" + Upper(dw_Serial.getItemString(llRowPos,'l_code',Delete!,True)) + "'"
		lsFind += " and Upper(sku) = '" + Upper(dw_Serial.getItemString(llRowPos,'sku',Delete!,True)) + "'"
		lsFind += " and Upper(inventory_type) = '" + Upper(dw_Serial.getItemString(llRowPos,'inventory_type',Delete!,True)) + "'"
		lsFind += " and Upper(lot_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'lot_no',Delete!,True)) + "'"
		lsFind += " and Upper(po_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'po_no',Delete!,True)) + "'"
		lsFind += " and Upper(po_no2) = '" + Upper(dw_Serial.getItemString(llRowPos,'po_no2',Delete!,True)) + "'"
		
		llFindRow = dw_Content.Find(lsFind,1,dw_Content.RowCOunt())
		If llFindRow > 0 Then
			
			lsWarehouse = dw_content.getItemString(llFindRow,"wh_code")
			ls_supp = dw_content.getItemString(llFindRow,"supp_code")
			ll_owner = dw_Content.getItemNumber(llFindRow,"owner_id")
			ll_orig_owner = dw_Content.getItemNumber(llFindRow,"owner_id")
			ls_coo = dw_Content.getItemString(llFindRow,"country_of_origin")
			ls_oldcoo = dw_Content.getItemString(llFindRow,"country_of_origin") 
			ls_oldcoo = dw_Content.getItemString(llFindRow,"country_of_origin") 
			lsRONO = dw_content.getItemString(llFindRow,"receive_master_supp_invoice_no")
			lsType = dw_content.getItemString(llFindRow,"inventory_type")	
		Else
			
			If rb_serial_reconcile.checked = false then
				
				Execute Immediate "ROLLBACK" using SQLCA;
				MessageBox("Stock Adjustment_Create","Corresponding Content record not found for Serial Number: '" + lsSerial + "'. No changes made",Stopsign! )
				Return 1	

			End IF
			
		End If
		
		If isnull(lsRONO) Then
			lsRONO =  dw_Serial.getItemString(llRowPos,"ro_no",Delete!,True)
		End If
		
		//Deleting a serial will always go from 1 to 0
		//15-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process
		IF rb_serial_reconcile.checked THEN
			ldAvailQty = 0
			ldNewQty = 0
		ELSE
			ldAvailQty = 1
			ldNewQty = 0
		END IF
	
		lsTransParm = ""
		 
		 liAdjCount = liAdjCount + 1

		//Create an Adjustment Record
		//SQLCA.DBParm = "disablebind =0"  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
		//MikeA - Change ls_Old_Type to lsType - Original type was already null in database.
		Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no,po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
		values						(:gs_project,:lsSku,:ls_supp,:ll_orig_Owner,:ll_owner,:ls_coo,:ls_oldcoo,:lsWarehouse,:lsLoc,:lsType,:lsType, &
									:lsSerial,:lsLot,:lspo,:lsoldpo,:lspo2,:lsoldpo2,
									:ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty,:ldNewQty,:lsRef,:lsReason,:gs_userid,:ldtToday,:is_trans_type,
									:lsoldlot,:lsremarks) 
		Using SQLCA;
		//SQLCA.DBParm = "disablebind =1"	  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
		
		If Sqlca.sqlcode <> 0  Then
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
			Return 1	
		End IF

		//TAM 10/01/04 truncate rono to 20 (from "receive_master_supp_invoice_no" above)
		lsRONO20 = MID(lsRoNo,1,20)
		
		if  rb_adjust_qty.checked = true then
			lb_suppress_947 = false
		else
			lb_suppress_947 = true
		end if
		
		//27-Dec-2017 :Madhu PEVS-806 3PL CC Orders - START
		ll_Id_No = this.wf_create_item_serial_change_record( gs_project, lsSku, lsWarehouse, ls_supp, ll_owner, lspo, lspo, lsSerial, '-', lb_suppress_947)
		lsTransParm =string(ll_Id_No)
		
		// 05/01 PCONKL - We need to display the Adjustment ID of the new record. Since it is auto generated by the DB, we need to retrieve it
		Select Max(Adjust_no) into :llAdjustID
		From	 Adjustment
		Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;
	
		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

		IF Upper(lsSerialSwapFlag) = 'Y' THEN

			if  rb_adjust_qty.checked = true then

//				MessageBox("Send 947", "Delete " + lsSerial) 

				Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
										Values(:gs_Project, 'SN', :llAdjustID,'N', :ldtToday, :lsTransParm)
				USING SQLCA;
					
			End IF

		End IF		
	
	
		If llAdjustID > 0 Then
			lsMsg += 'The Adjustment ID for Row # ' + string(llRowPos) + ' is: ' + string(llAdjustID) + "~r"
			//dw_content.SetITem(llRowPos,'c_adjust_no',llAdjustID)
		Else
			lsMsg += 'Unable to retrieve the Adjustment ID for Row # ' + string(llRowPos)	//DE16865
		End If

//		//13-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - Don't create batch transaction
		//10-JAN-2020 : MikeA - This code isn't need for serial anymore. Handled thru 'SN' process. 
		
//		IF rb_serial_reconcile.checked =False THEN
//			Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
//										Values(:gs_Project, 'MM', :llAdjustID,'N', :ldtToday, :lsTransParm)
//			Using SQLCA;
//		END IF
//		
//		If Sqlca.sqlcode <> 0  Then
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
//			Return 1	
//		End IF
		
		llModCount ++
			
	Next /* Next Deleted Serial record*/
	
End If /*Deleted Serial NUmber records */


//Updated Serial Rows...
llRowCount = dw_Serial.RowCount() 
If llRowCount > 0 Then
	
	For llRowPos = 1 to llRowCount
		
		If dw_Serial.getItemStatus(llRowPos,0,Primary!) <> DataModified!	AND dw_Serial.getItemStatus(llRowPos,0,Primary!) <> NewModified! 	Then Continue 
		
		ldtToday = f_getLocalWorldTime( lsWarehouse ) 
	
		lsSku = dw_Serial.getItemString(llRowPos,"sku")
			
		//get values for adjustment
		lsOldType = dw_Serial.getItemString(llRowPos,"orig_inventory_type")
		lsType = dw_Serial.getItemString(llRowPos,"inventory_type")
		lsSerial = dw_Serial.getItemString(llRowPos,"serial_no")

		lslot = dw_Serial.getItemString(llRowPos,"lot_no")
		lsoldlot = dw_Serial.getItemString(llRowPos,"orig_Lot_No") 
	
		lspo = dw_Serial.getItemString(llRowPos,"po_no")
		lspo2 = dw_Serial.getItemString(llRowPos,"po_no2")
		lsoldpo2 = dw_Serial.getItemString(llRowPos,"orig_po_no2") 
		lsloc = dw_Serial.getItemString(llRowPos,"l_code")
	
		//ls_container_ID  = dw_content.getItemString(llRowPos,"container_ID")   
  		ldt_expiration_date  = dw_Serial.getItemDatetime(llRowPos,"exp_dt") 
	
		// need some fields from Content record
		lsFind = "Upper(ro_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'ro_no')) + "'"
		lsFind += " and Upper(l_code) = '" + Upper(dw_Serial.getItemString(llRowPos,'l_code')) + "'"
		lsFind += " and Upper(sku) = '" + Upper(dw_Serial.getItemString(llRowPos,'sku')) + "'"
		lsFind += " and Upper(inventory_type) = '" + Upper(dw_Serial.getItemString(llRowPos,'inventory_type')) + "'"
		lsFind += " and Upper(lot_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'lot_no')) + "'"
		lsFind += " and Upper(po_no) = '" + Upper(dw_Serial.getItemString(llRowPos,'po_no')) + "'"
		lsFind += " and Upper(po_no2) = '" + Upper(dw_Serial.getItemString(llRowPos,'po_no2')) + "'"
		
		IF ib_allow_content_select_row = false OR dw_content.GetRow() = 0 THEN
			Execute Immediate "ROLLBACK" using SQLCA;	//GailM 7/22/2020 DE16865 Google DB Blocking Issue (Stock Transfer)
			Messagebox("Adjust", "Must select a content record first before you can modify a Serial Number.",Stopsign!)
			Return 1
		END IF
		
		
		llFindRow =  dw_content.GetRow() // dw_Content.Find(lsFind,1,dw_Content.RowCount())
		llContentRow = llFindRow
		
//		If llFindRow > 0 Then
			
			lsWarehouse = dw_content.getItemString(llFindRow,"wh_code")
			ls_supp = dw_content.getItemString(llFindRow,"supp_code")
			ll_owner = dw_Content.getItemNumber(llFindRow,"owner_id")
			ll_orig_owner = dw_Content.getItemNumber(llFindRow,"owner_id")
			ls_coo = dw_Content.getItemString(llFindRow,"country_of_origin")
			ls_oldcoo = dw_Content.getItemString(llFindRow,"country_of_origin") 
			ls_oldcoo = dw_Content.getItemString(llFindRow,"country_of_origin") 
			lsRONO = dw_content.getItemString(llFindRow,"receive_master_supp_invoice_no")
			lsType = dw_content.getItemString(llFindRow,"inventory_type")
//		Else
//			
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment_Create","Corresponding Content record not found for Serial Number: '" + lsSerial + "'. No changes made",Stopsign! )
//			Return 1	
//			
//			
//			
//			
//		End If
		
		If isnull(lsRONO) Then
			lsRONO =  dw_Serial.getItemString(llRowPos,"ro_no")
		End If
		
		//If a new row, it will go from 0 to 1, otherwise serial qty will always be 1
		If dw_Serial.getItemStatus(llRowPos,0,Primary!) = NewModified! 	Then
			ldAvailQty = 0
		Else
			ldAvailQty = 1
		End If
		
		//15-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process
		IF rb_serial_reconcile.checked THEN
			ldNewQty =0
		ELSE
			ldNewQty = 1
		END IF
	
		lsTransParm = ""
		 
		 liAdjCount = liAdjCount + 1

		//Create an Adjustment Record
		//SQLCA.DBParm = "disablebind =0"  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
		//MikeA - Change ls_Old_Type to lsType - Original type was already null in database.
		Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,old_po_no, po_no2,old_po_no2,
									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
									old_lot_no,remarks) 
		values						(:gs_project,:lsSku,:ls_supp,:ll_orig_Owner,:ll_owner,:ls_coo,:ls_oldcoo,:lsWarehouse,:lsLoc,:lsType,:lsType, &
									:lsSerial,:lsLot,:lspo,:lsoldpo,:lspo2,:lsoldpo2,
									:ls_container_ID, :ldt_expiration_date,:lsRONO,:ldAvailQty,:ldNewQty,:lsRef,:lsReason,:gs_userid,:ldtToday,:is_trans_type,
									:lsoldlot,:lsremarks) 
		Using SQLCA;
		//SQLCA.DBParm = "disablebind =1"	  /* 08/16 - PCONKL - Commented out due to SQL 2016 issues with driver*/
		
		If Sqlca.sqlcode <> 0  Then
			Execute Immediate "ROLLBACK" using SQLCA;
			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
			Return 1	
		End IF

		//TAM 10/01/04 truncate rono to 20 (from "receive_master_supp_invoice_no" above)
		lsRONO20 = MID(lsRoNo,1,20)
	
		//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process

		IF Upper(lsSerialSwapFlag) = 'Y' THEN
		
			//Send 947
		
			IF dw_Serial.getItemStatus(llRowPos,0,Primary!) = NewModified! Then
	
				lsPrevSerial = "-"
			
				if  rb_adjust_qty.checked = true then
					lb_suppress_947 = false
				else
					lb_suppress_947 = true
				end if
			
				ll_Id_No = this.wf_create_item_serial_change_record( gs_project, lsSku, lsWarehouse, ls_supp, ll_owner, lspo, lspo, lsPrevSerial, lsSerial, lb_suppress_947)
				lsTransParm =string(ll_Id_No)

				Select Max(Adjust_no) into :llAdjustID
				From	 Adjustment
				Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;

				//Get Header Info
				//ldAvailQty = dw_content.getItemDecimal(dw_content.GetRow(),"avail_qty")
				//(dw_serial.RowCount() > ldAvailQty) AND

				if  rb_adjust_qty.checked = true then

//					MessageBox("Send 947", "Add " + lsSerial) 

					Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
											Values(:gs_Project, 'SN', :llAdjustID,'N', :ldtToday, :lsTransParm)
					USING SQLCA;
					
				end if

			End If
			
			
			IF dw_Serial.getItemStatus(llRowPos,0,Primary!) = DataModified! Then
	
				IF dw_Serial.getItemStatus(llRowPos,"serial_no",Primary!) = DataModified! Then
	
					lsPrevSerial =  dw_Serial.getItemString(llRowPos,"serial_no", primary!, true)
				
					if  rb_serial_reconcile.checked = true then
						lb_suppress_947 = false
					else
						lb_suppress_947 = true
					end if
				
					ll_Id_No = this.wf_create_item_serial_change_record( gs_project, lsSku, lsWarehouse, ls_supp, ll_owner, lspo, lspo, lsPrevSerial, lsSerial, lb_suppress_947)
					lsTransParm =string(ll_Id_No)
	
					Select Max(Adjust_no) into :llAdjustID
					From	 Adjustment
					Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;
	
					//Get Header Info
					//ldAvailQty = dw_content.getItemDecimal(dw_content.GetRow(),"avail_qty")
					//(dw_serial.RowCount() > ldAvailQty) AND
	
					if  rb_serial_reconcile.checked = true then
	
		//				MessageBox("Send 947", lsPrevSerial + " swap with " + lsSerial) 
	
						Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
												Values(:gs_Project, 'SN', :llAdjustID,'N', :ldtToday, :lsTransParm)
						USING SQLCA;
						
					end if

				End IF


				//MikeA - 1/9/2020 - Added as per Roy
	
				IF dw_Serial.getItemStatus(llRowPos,"po_no",Primary!) = DataModified! Then    
		
					lspo =  dw_Serial.getItemString(llRowPos,"po_no")
					lsoldpo =  dw_Serial.getItemString(llRowPos,"po_no", primary!, true)
					ls_owner_cd = Upper(dw_serial.getItemString(llRowPos,'serial_number_inventory_owner_cd')) // Dinesh - 10/04/2023 - SIMS-317- Google - Stock Adjustment for Class A GPNs
					select  CC_Class_Code into :ls_cc_class_Code from Item_Master with(nolock) 
					where Project_Id =:gs_project and sku =:lsSku  and Supp_code =:ls_supp         
					using sqlca;				
				
					//IF rb_adjust_other.checked = true AND (upper(ls_cc_class_Code) ='A') AND (Upper(trim(lspo)) = 'RESEARCH' AND Upper(trim(lsoldpo)) <> 'RESEARCH' )  THEN 
					IF rb_adjust_other.checked = true AND (upper(ls_cc_class_Code) ='A') AND ((Upper(trim(lspo)) = 'MAIN' and Right(ls_owner_cd,2) = 'PR')  AND (Upper(trim(lsoldpo)) <> 'RESEARCH' and Right(ls_owner_cd,2) <> 'PR')) THEN  // Dinesh -10/19/2023 -  SIMS-317- Google - Stock Adjustment for Class A GPNs
						//lsMsg += 'Inventory will be moved to Project Code: RESEARCH.  Deletion of Inventory and Serial number must be processed in a separate Stock Adjustment session after Google has approved in IMS.' + "~r" // Dinesh -10/19/2023 -  SIMS-317- Google - Stock Adjustment for Class A GPNs
						lsMsg += 'Inventory will be moved to Project Code: MAIN with WH*PR.  Deletion of Inventory and Serial number must be processed in a separate Stock Adjustment session after Google has approved in IMS.' + "~r" // Dinesh -10/19/2023 -  SIMS-317- Google - Stock Adjustment for Class A GPNs
	
						ll_Id_No = this.wf_create_item_serial_change_record( gs_project, lsSku, lsWarehouse, ls_supp, ll_owner, lspo, lsoldpo, lsSerial, lsSerial, false)
						lsTransParm =string(ll_Id_No)
	
						Select Max(Adjust_no) into :llAdjustID
						From	 Adjustment
						Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;
		
						Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
							Values(:gs_Project, 'SN', :llAdjustID,'N', :ldtToday, :lsTransParm)
							USING SQLCA;
		
					END IF
				
				END IF


			End If
			
			
		END IF
	
	
	
		// 05/01 PCONKL - We need to display the Adjustment ID of the new record. Since it is auto generated by the DB, we need to retrieve it
		Select Max(Adjust_no) into :llAdjustID
		From	 Adjustment
		Where project_id = :gs_project and ro_no = :lsrono20 and sku = :lsSku and serial_no = :lsSerial and last_user = :gs_userid and last_update = :ldtToday;
	
		If llAdjustID > 0 Then
			lsMsg += 'The Adjustment ID for Row # ' + string(llRowPos) + ' is: ' + string(llAdjustID) + "~r"
			//dw_content.SetITem(llRowPos,'c_adjust_no',llAdjustID)
		Else
			lsMsg += 'Unable to retrieve the Adjustment ID for Row # ' + string(llRowPos)	//DE16865
		End If
		
//		//15-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - Don't create batch transaction
		//10-JAN-2020 : MikeA - This code isn't need for serial anymore. Handled thru 'SN' process. 
		
//		IF rb_serial_reconcile.checked =False
//			Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
//										Values(:gs_Project, 'MM', :llAdjustID,'N', :ldtToday, :lsTransParm)
//			Using SQLCA;
//		END IF
		
//		If Sqlca.sqlcode <> 0  Then
//			Execute Immediate "ROLLBACK" using SQLCA;
//			MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
//			Return 1	
//		End IF
		
		llModCount ++
		
	Next /* Next modified serial row*/
	
End If /*modified Serial Rows */


//Commit Changes
Execute Immediate "COMMIT" using SQLCA;
If Sqlca.sqldbcode < 0 Then
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
	Return 1
End IF


// Begin - Dinesh  - 07082022- S70298- SIMS PIP/SIP- Work order refractories - Stock adjustment
	if (gs_project='GEISTLICH' or gs_project='NYCSP')  and ll_comp_no > 0 then
		
		//Execute Immediate "Begin Transaction" using SQLCA;
	
				lds_adjust_qty.dataobject='d_adjustment_qty'
				lds_adjust_qty.SetTransobject(sqlca)
				
				llRowCount1 = lds_adjust_qty.Retrieve(ll_comp_no,lsloc)
				
			for k= 1 to lds_adjust_qty.rowcount()
					
					lsSku= lds_adjust_qty.getitemstring(k,"sku") 

						
					if lsSku <> '' or not isnull(lsSku)  then
					
							select child_qty into :ll_qty from Item_component where SKU_child=:lsSku;
							
							ll_comp_qty= ll_qty* ll_qty_diff
						
							llcomp_qty= lds_adjust_qty.getItemnumber(k,"component_qty") 
							
							if llcomp_qty <> 0 then
							
									ll_comp_qty=llcomp_qty - ll_comp_qty 
									
									lds_adjust_qty.setitem(k,'component_qty',ll_comp_qty)
									ll_rtn= lds_adjust_qty.update()
									
									IF ll_rtn = 1 THEN
	
										Execute Immediate "COMMIT" using SQLCA;
									
										
									End if
									
							end if
							
					end if
				
				next
		
			IF llRowCount1 <=0 THEN 
				MessageBox('', "No records Generated!")
				Return
					 
			End if
			
			If Sqlca.sqldbcode < 0 Then 
				Execute Immediate "ROLLBACK" using SQLCA;
				MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
				Return 1	
			End IF 
			
				
		End if
	
	// End - Dinesh  - 07082022- S70298- SIMS PIP/SIP- Work order refractories - Stock adjustment
	 

SetPointer(arrow!)

//Show adjustment numbers created...
If llModCount > 1 Then
	lsTitle = "New Adjustment ID's"
	lsMsg += "~r~rIf your procedures require it, please write these numbers down."
Else
	lsTitle = "New Adjustment ID"
	lsMsg += "~r~rIf your procedures require it, please write this number down."
End IF
	
Messagebox(lsTitle, lsMsg)
end event

event close;Destroy i_nwarehouse
end event

event resize;
// 04/14 - PCONKL - size of DW_Content DW is being set in ue_postOpen depending on whether serial DW is being displayed for chain of custody or not

//IF This.width < 3850 THEN This.width = 3850
//
//dw_content.width = THIS.width - 37
//
//IF THIS.HEIGHT < 1100 THEN
//	THIS.HEIGHT = 1100
//ELSE
//	dw_content.HEIGHT = THIS.HEIGHT - 815
//	cb_adjust_split.y 	= dw_content.y + THIS.HEIGHT - 815 + 50
//	cb_adjust_ok.y    	= cb_adjust_split.y 
//	cb_adjust_cancel.y = cb_adjust_split.y 
//	cb_adjust_reset.y 	= cb_adjust_split.y 
//	cb_adjust_sort.y 	= cb_adjust_split.y 
//	cb_adjust_help.y = cb_adjust_split.y 
//END IF
end event

type p_empty from picture within w_adjust_create
integer x = 3872
integer y = 444
integer width = 59
integer height = 52
boolean originalsize = true
boolean border = true
boolean focusrectangle = false
end type

type p_arrow from picture within w_adjust_create
boolean visible = false
integer x = 3794
integer y = 444
integer width = 59
integer height = 52
boolean originalsize = true
string picturename = "Next!"
boolean focusrectangle = false
end type

type cb_swap_serial from commandbutton within w_adjust_create
integer x = 864
integer y = 2400
integer width = 366
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Swap Serial"
end type

event clicked;
integer i
string lsInventory_Type 

IF ib_allow_content_select_row = false OR dw_content.GetRow() = 0 THEN
	Messagebox("Adjust", "Must select a content record first before you can swap a Serial Number.",Stopsign!)
	Return 
END IF

IF dw_content.RowCount() > 0 THEN

	i = dw_content.GetRow()
	
	IF i > 0 THEN
		lsInventory_Type = dw_content.GetITemString(i,'inventory_type')
		
		IF lsInventory_Type = "*" THEN
			Messagebox("Adjust", "The selected content record is in Cycle Count. Must complete Cycle Count before being able to swap a serial.",Stopsign!)
			Return 
		END IF
		
	END IF

END IF

dw_serial.Modify("serial_No.Protect=0~tif (left( serial_no,1)='?',1,0)")
//dw_serial.Modify("serial_No.Protect=0~tif (left( serial_no,1)='?',1,0)")
end event

type st_retrieve_sn from statictext within w_adjust_create
integer x = 1015
integer y = 1536
integer width = 2121
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type rb_serial_reconcile from radiobutton within w_adjust_create
integer x = 3237
integer y = 288
integer width = 571
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Serial Reconcile"
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')
end event

type cb_adjust_import from commandbutton within w_adjust_create
integer x = 1330
integer y = 2400
integer width = 283
integer height = 92
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hebrewcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import"
end type

event clicked;//08-Dec-2014 :Madhu- Added new functionality

OpenwithParm(w_adjust_create_import,dw_content)
end event

type cbx_serial_retrieve from checkbox within w_adjust_create
integer x = 14
integer y = 1536
integer width = 928
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Retrieve Serial Numbers"
end type

event clicked;if this.checked then

	//04/14 - PCONKL - Retrieve the Serial NUmbers from Serial_Number_Inventory if chain of custody enabled
	 IF g.ibSNchainofcustody OR rb_serial_reconcile.checked  THEN
		dw_serial.TriggerEvent('ue_retrieve')
		
		dw_content.setRowFocusIndicator( p_empty )
		ib_allow_content_select_row = false
		
	End If

end if

integer li_null




end event

type cb_add_serial from commandbutton within w_adjust_create
integer x = 475
integer y = 2400
integer width = 366
integer height = 92
integer taborder = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Serial"
end type

event clicked;String	lsFind, lsInventory_Type
Long	llFindRow, i, ll_qty, ll_serial_qty, llRow
boolean lbAddSerialOnly
datetime ldtToday 

IF ib_allow_content_select_row = false OR dw_content.GetRow() = 0 THEN
	Messagebox("Adjust", "Must select a content record first before you can add a Serial Number.",Stopsign!)
	Return 
END IF

IF cbx_serial_retrieve.checked = false then
	Messagebox("Adjust", "Must retrieve existing serials first before you can add a Serial Number. (Retrieve Serial Numbers must be checked.)",Stopsign!)
	Return 
END IF

ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse(  ) ) 

If dw_content.RowCount() > 0 Then
	
	i = dw_content.GetRow()
	
	IF i > 0 THEN
		lsInventory_Type = dw_content.GetITemString(i,'inventory_type')
		
		IF lsInventory_Type = "*" THEN
			Messagebox("Adjust", "The selected content record is in Cycle Count. Must complete Cycle Count before being able to add a serial.",Stopsign!)
			Return 
		END IF
		
	END IF
	
//	//Make sure there is a Content row to increment
//	lsFind = "Upper(ro_no) = '" + Upper(dw_content.GetITemString(ii_row,'ro_no')) + "'"
//	lsFind += " and Upper(l_code) = '" + Upper(dw_content.GetITemString(ii_row,'l_code')) + "'"
//	lsFind += " and Upper(sku) = '" + Upper(dw_content.GetITemString(ii_row,'sku')) + "'"
//	lsFind += " and Upper(inventory_type) = '" + Upper(dw_content.GetITemString(ii_row,'inventory_type')) + "'"
//	lsFind += " and Upper(lot_no) = '" + Upper(dw_content.GetITemString(ii_row,'lot_no')) + "'"
//	lsFind += " and Upper(po_no) = '" + Upper(dw_content.GetITemString(ii_row,'po_no')) + "'"
//	lsFind += " and Upper(po_no2) = '" + Upper(dw_content.GetITemString(ii_row,'po_no2')) + "'"
//	lsFind += " and String(expiration_date,'MMDDYYYY') = '" + String(dw_content.GetITemDateTime(ii_row,'expiration_date'),'MMDDYYYY') + "'"
//	lsFind += " and avail_qty > 0 " /* we might be decrementing multiple content rows */
		
	llFindRow = i // dw_Content.Find(lsFind,1,dw_Content.RowCount())
			
//	If llFindRow < 1 Then
//		Messagebox("Adjust", "Corresponding Inventory record not found forinserting Serial Number",Stopsign!)
//		dw_content.ScrolltoRow(ii_row)
//		cb_adjust_Ok.Enabled = False
//		//cb_delete_Serials.Enabled = False
//		Return
//	End If
	
	//15-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
	//a. If Content.Qty > Serial Count, force Ops to select "Serial Reconcile" option
	//b. Make sure, don't add more serial no's than avail Qty
	//c. Don't bump up content qty
	lbAddSerialOnly = FALSE
	
	IF upper(gs_project) ='PANDORA' THEN
		
		ll_serial_qty = dw_Serial.RowCount()
		ll_qty = dw_Content.getItemNumber(llFindRow, 'avail_qty')
		
		iF f_retrieve_parm("PANDORA","FLAG","RECONCILE OPTION") = "Y" Then
			IF rb_adjust_qty.checked and ll_qty > dw_Serial.RowCount() THEN
				//prompt message	
				MessageBox("Adjust", "Serial Qty is lesser than Available Qty, please add serial no's by selecting Serial Reconcile Option." +&
				"~r~rAvailable Qty: "+string(ll_qty) +"  Serial Qty: "+string(ll_serial_qty) +"  and Expected to Add Serial Qty: "+string (ll_qty - ll_serial_qty) +&
				"~r~rClick 'Reset' to review and start again.",Stopsign!)
				Return
				
			ELSEIF rb_serial_reconcile.checked and ll_qty > dw_Serial.RowCount() THEN
				lbAddSerialOnly =TRUE
				
			ELSEIF (rb_serial_reconcile.checked  OR rb_adjust_qty.checked) and ll_qty = dw_Serial.RowCount() THEN
				//prompt message
				//ADD is not allowed when Inventory Quantity and Serial Numbers are in sync.  If you need to add a inventory please do this in a Cycle Count

				MessageBox("Adjust", "ADD is not allowed when Inventory Quantity and Serial Numbers are in sync.  If you need to add a inventory please do this in a Cycle Count.",Stopsign!)

//				MessageBox("Adjust", "Please add serial no's by selecting Qty Option to reflect on Inventory." +&
//				"~r~rClick 'Reset' to review and start again.",Stopsign!)
				Return
			END IF
		Else
			MessageBox("Reconcile Option is turned off","Reconcile Option required to add serials.~r~nTurn on flag in Lookup Table - RECONCILE OPTION")
				Return
		End If
	END IF
	//15-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END
	
	//GailM 6/19/2019 S33404 - Google 1:1 requirement for Serials/quantity in SIMS 
	llRow = dw_serial.InsertRow(0)
	dw_serial.SetItem(llRow,'serial_number_inventory_project_id',dw_content.GetItemString(llFindRow,'project_id'))
	dw_serial.SetItem(llRow,'serial_number_inventory_wh_code',dw_content.GetItemString(llFindRow,'wh_code'))
	dw_serial.SetItem(llRow,'serial_number_inventory_owner_id',dw_content.GetItemNumber(llFindRow,'owner_id'))
	dw_serial.SetItem(llRow,'serial_number_inventory_owner_cd',dw_content.GetItemString(llFindRow,'owner_owner_cd'))
	dw_serial.SetItem(llRow,'serial_number_inventory_component_no',dw_content.GetItemString(llFindRow,'component_no'))
	dw_serial.SetItem(llRow,'supp_invoice_no',dw_content.GetItemString(llFindRow,'receive_master_supp_invoice_no'))
	dw_serial.SetItem(llRow,'ro_no',dw_content.GetItemString(llFindRow,'ro_no'))
	dw_serial.SetItem(llRow,'l_code',dw_content.GetItemString(llFindRow,'l_code'))
	dw_serial.SetItem(llRow,'sku',dw_content.GetItemString(llFindRow,'sku'))
	dw_serial.SetItem(llRow,'inventory_type',dw_content.GetItemString(llFindRow,'inventory_type'))
	dw_serial.SetItem(llRow,'lot_no',dw_content.GetItemString(llFindRow,'lot_no'))
	dw_serial.SetItem(llRow,'po_no',dw_content.GetItemString(llFindRow,'po_no'))
	dw_serial.SetItem(llRow,'po_no2',dw_content.GetItemString(llFindRow,'po_no2'))
	dw_serial.SetItem(llRow,'carton_id',dw_content.GetItemString(llFindRow,'container_id'))
	dw_serial.SetItem(llRow,'exp_dt',dw_content.GetItemDatetime(llFindRow,'expiration_date'))
	
	dw_serial.SetItem(llRow,'Serial_no','')
	
	dw_serial.setItem(llRow,'update_date', ldtToday)
	dw_serial.setItem(llRow,'update_user',gs_userid)
	
	// TAM 2019/05 - S33409 - Populate Serial History Table
	dw_serial.setItem(llRow,'Transaction_Type','ADJUST')
	dw_serial.setItem(llRow,'Transaction_ID','')
	dw_serial.setItem(llRow,'Adjustment_Type','SERIAL ADDED')

	dw_serial.scrolltorow(llRow)
	Dw_serial.SetRow(llRow)
	dw_serial.Modify("serial_No.Protect=0~tif (left( serial_no,1)='?',1,0)")
	dw_serial.Setfocus()
	dw_serial.setcolumn('serial_no')
	
	//Increment content
	IF lbAddSerialOnly =FALSE THEN
		dw_Content.SetItem(llFindRow,'avail_qty',dw_content.GetITemnumber(llFindRow,'avail_Qty') + 1)
		dw_Content.SetITem(llFindRow,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
	END IF

Else
	
	MessageBox("Adjust", "A content record must be selected before you add a serial.",Stopsign!)

	
End If

cb_adjust_reset.Enabled = True
end event

type cb_delete_serials from commandbutton within w_adjust_create
integer x = 32
integer y = 2400
integer width = 421
integer height = 92
integer taborder = 150
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Serials"
end type

event clicked;Long 	i, llRowCount, llFindRow
long	ll_content_qty, ll_serial_count, ll_serial_un_count,ll_Owner_Id
String	lsFind, lsSerialFind, lsSelectFind, lsUnSelectFind, lsInventory_Type
string ls_sku, ls_supp_code,ls_owner_cd,lsToWarehouse,ls_custcode,ls_Owner_code

string lsSelectedSerialFind, ls_msg
long ll_serial_find_row, ll_selected_find_row, ll_selected_serial_count, ll_content_find_row
boolean lbDeleteSerialOnly

//Can not change the adjustment type or split a row after any changes are made
iwWindow.TriggerEvent('ue_disable_type_chg')
cb_adjust_Split.Enabled = False
ibSplitOK = False
cb_adjust_Reset.Enabled = True

//Delete any checked rows and decrement from corresponding Content record
llRowCount = dw_Serial.RowCount()
For i = llRowCount to 1 step - 1
	
	If dw_serial.getItemString(i,'c_select') = 'Y' Then /* checked for Delete*/
		
		IF ib_allow_content_select_row = true AND dw_content.GetRow() > 0 THEN
		
			lsInventory_Type = dw_content.GetITemString(dw_content.GetRow(),'inventory_type')
		
			IF lsInventory_Type = "*" THEN
				Messagebox("Adjust", "The selected content record is in Cycle Count. Must complete Cycle Count before being able to delete a serial.",Stopsign!)
				Return 
			END IF
		
		END IF
		
		//Find corresponding Content Record and decrement. If not found or decrements below zero, it's an error
		lsFind = "Upper(ro_no) = '" + Upper(dw_serial.getItemString(i,'ro_no')) + "'"
		lsFind += " and Upper(l_code) = '" + Upper(dw_serial.getItemString(i,'l_code')) + "'"
		lsFind += " and Upper(sku) = '" + Upper(dw_serial.getItemString(i,'sku')) + "'"
		lsFind += " and (Upper(inventory_type) = '" + Upper(dw_serial.getItemString(i,'inventory_type')) + "' OR inventory_type = '*') "   //MikeA - Added Cyclecount because Content could be in CycleCount. 
		lsFind += " and Upper(lot_no) = '" + Upper(dw_serial.getItemString(i,'lot_no')) + "'"
		lsFind += " and Upper(po_no) = '" + Upper(dw_serial.getItemString(i,'po_no')) + "'"
		lsFind += " and Upper(po_no2) = '" + Upper(dw_serial.getItemString(i,'po_no2')) + "'"
		lsFind += " and Upper(container_id) = '" + Upper(dw_serial.getItemString(i,'carton_id')) + "'"
		lsFind += " and String(expiration_date,'MMDDYYYY') = '" + String(dw_serial.getItemDateTime(i,'exp_dt'),'MMDDYYYY') + "'"
		lsFind += " and avail_qty > 0 " /* we might be decrementing multiple content rows */
		
		llFindRow = dw_Content.Find(lsFind,1,dw_Content.RowCount())
		ll_content_find_row = llFindRow
		
		//SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
		//There is no inventory but record exists in Serial_Number_Inventory - Allow to delete. 
		If (llFindRow = 0 OR isNull(llFindRow)) And rb_serial_reconcile.checked = true then
			dw_Serial.DeleteRow(i)
			cb_adjust_Ok.Enabled = True
			CONTINUE
		End If
		
		IF llFindRow > 0 THEN
		
			lsInventory_Type = dw_content.GetITemString(llFindRow,'inventory_type')
		
			IF lsInventory_Type = "*" THEN
				Messagebox("Adjust", "The selected content record is in Cycle Count. Must complete Cycle Count before being able to delete a serial.",Stopsign!)
				Return 
			END IF
			
		END IF
		
		
		If llFindRow < 1 Then
			Messagebox("Adjust", "Corresponding Inventory record not found for Serial Number '" + dw_serial.getItemString(i,'serial_no') + "' ~rOr multiple Serial deletes decrementing Inventory below 0.~rUnable to delete Serial Number~r~rClick 'Reset' to review and start again.",Stopsign!)
			dw_Serial.ScrolltoRow(i)
			cb_adjust_Ok.Enabled = False
			cb_delete_Serials.Enabled = False
			cb_swap_Serial.Enabled = False  //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
			Return
		End If

		//10-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
		IF upper(gs_project) ='PANDORA' THEN
		
			//reset value
			ll_serial_count =0
			ll_selected_serial_count =0
			lbDeleteSerialOnly =FALSE
	
			//1. get content QTY.
			ll_content_qty = dw_Content.getItemNumber(llFindRow,'Avail_Qty')
			
			//2. get serial no. records against above criteria
			lsSerialFind = "Upper(ro_no) = '" + Upper(dw_serial.getItemString(i,'ro_no')) + "'"
			lsSerialFind += " and Upper(l_code) = '" + Upper(dw_serial.getItemString(i,'l_code')) + "'"
			lsSerialFind += " and Upper(sku) = '" + Upper(dw_serial.getItemString(i,'sku')) + "'"
			lsSerialFind += " and Upper(inventory_type) = '" + Upper(dw_serial.getItemString(i,'inventory_type')) + "'"
			lsSerialFind += " and Upper(lot_no) = '" + Upper(dw_serial.getItemString(i,'lot_no')) + "'"
			lsSerialFind += " and Upper(po_no) = '" + Upper(dw_serial.getItemString(i,'po_no')) + "'"
			lsSerialFind += " and Upper(po_no2) = '" + Upper(dw_serial.getItemString(i,'po_no2')) + "'"
			lsSerialFind += " and Upper(carton_id) = '" + Upper(dw_serial.getItemString(i,'carton_id')) + "'"
			lsSerialFind += " and String(exp_dt,'MMDDYYYY') = '" + String(dw_serial.getItemDateTime(i,'exp_dt'),'MMDDYYYY') + "'"

			ll_serial_find_row = dw_serial.find( lsSerialFind, 0, dw_serial.rowcount())
			
			//3. get count(serial) records with above criteria
			DO WHILE ll_serial_find_row > 0
				ll_serial_count++
				ll_serial_find_row = dw_serial.find( lsSerialFind, ll_serial_find_row +1, dw_serial.rowcount() +1)
			LOOP
			
			//4. If Count(Serial) exceeds than Avail QTY then allow to delete ONLY serial no's!
			IF rb_adjust_qty.checked and ll_serial_count <> ll_content_qty THEN
				
				//prompt message
				IF ll_serial_count > ll_content_qty THEN
					ls_msg ="Serial Qty is greater than Available Qty, please delete serial no's by selecting Serial Reconcile Option."
				ELSE
					ls_msg ="Serial Qty is lesser than Available Qty, please reconcile serial No's via Cycle Count process."
				END IF
				
				Messagebox("Adjust", ls_msg+"~r~r Available Qty: "+string(ll_content_qty)+" Serial Qty: "+string(ll_serial_count)+&
				"~r~rClick 'Reset' to review and start again.",Stopsign!)
				Return
				
			ELSEIF rb_serial_reconcile.checked and ll_serial_count > ll_content_qty THEN

				lsSelectedSerialFind = lsSerialFind+" and c_select='Y'"
				ll_selected_find_row = dw_serial.find( lsSelectedSerialFind, 0, dw_serial.rowcount())
				
				//5. get count(selected serial no's)
				DO WHILE ll_selected_find_row > 0
					ll_selected_serial_count++
					ll_selected_find_row = dw_serial.find( lsSelectedSerialFind, ll_selected_find_row +1, dw_serial.rowcount() +1)
				LOOP
				
				//6. shouldn't delete more serial no's than avail qty
				IF ll_content_qty <= (ll_serial_count - ll_selected_serial_count) THEN
					lbDeleteSerialOnly =TRUE
				ELSE
					Messagebox("Adjust", "During Serial Reconciliation Process, please don't delete more Serial Numbers than the Actual Avail Qty. ~r~r Actual Avail Qty:  "+string(ll_content_qty) +" and Expected to Delete Serial No's: "+string(ll_serial_count - ll_content_qty)+ &
					"~r~rClick 'Reset' to review and start again.",Stopsign!)
					dw_Serial.ScrolltoRow(i)
					cb_adjust_Ok.Enabled = False
					cb_delete_Serials.Enabled = False
					cb_swap_Serial.Enabled = False  //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
					Return
				END IF

			ELSEIF rb_serial_reconcile.checked and ll_serial_count < ll_content_qty THEN
				Messagebox("Adjust", "Serial Qty is lesser than Available Qty, please reconcile serial No's via Cycle Count process."+&
				"~r~r Available Qty: "+string(ll_content_qty)+" Serial Qty: "+string(ll_serial_count)+&
				"~r~rClick 'Reset' to review and start again.",Stopsign!)
				Return
				
			ELSEIF rb_serial_reconcile.checked and ll_serial_count = ll_content_qty THEN
				Messagebox("Adjust", "Serial Qty is equals to Available Qty, please select QTY option to adjust quantity."+&
				"~r~r Available Qty: "+string(ll_content_qty)+" Serial Qty: "+string(ll_serial_count)+&
				"~r~rClick 'Reset' to review and start again.",Stopsign!)
				Return

			ELSEIF rb_adjust_qty.checked and ll_serial_count = ll_content_qty THEN
				
				//MIKEA - Do not allow a down count for a Class A item unless the project (PO_NO) = ‘RESEARCH’
				
				string ls_cc_class_Code
				string ls_po_no 
				
				ls_sku = Upper(dw_serial.getItemString(i,'sku'))
				ls_supp_code = Upper(dw_Content.GetItemString(ll_content_find_row, "supp_code"))
				
				ls_po_no = Upper(dw_serial.getItemString(i,'po_no'))
				ls_owner_cd = Upper(dw_serial.getItemString(i,'serial_number_inventory_owner_cd')) // Dinesh - 10/04/2023 - SIMS-317- Google - Stock Adjustment for Class A GPNs
								
				select  CC_Class_Code into :ls_cc_class_Code from Item_Master with(nolock) 
				where Project_Id =:gs_project and sku =:ls_sku  and Supp_code =:ls_supp_code
				using sqlca;				
				
				//IF upper(ls_cc_class_Code) ='A' and trim(upper(ls_po_no)) <> 'RESEARCH' then // Dinesh -10/19/2023 -  SIMS-317- Google - Stock Adjustment for Class A GPNs
				IF upper(ls_cc_class_Code) ='A' and (trim(upper(ls_po_no)) <> 'RESEARCH' and Right(ls_owner_cd,2) <> 'PR')   then  // Dinesh -10/19/2023 -  SIMS-317- Google - Stock Adjustment for Class A GPNs
				
					//Messagebox("Adjust", "A down count for a Class A item is not allowed unless the project (PO_NO) = ‘RESEARCH’ ",Stopsign!)
					Messagebox("Adjust", "A down count for a Class A item is not allowed unless the Owner Code is like  ‘WH*PR’ ",Stopsign!) // Dinesh -10/19/2023 - SIMS-317- Google - Stock Adjustment for Class A GPNs
					Return
					
				End If
				
			END IF
		END IF
		//10-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END
		
		If left(dw_serial.GetItemString(i,"serial_no"),1) = "?" then
			Messagebox("Adjust", "Unable to delete Serial Number with '?' pre-fix~r~rIt must be reconciled thru Cycle Count.",Stopsign!)
			dw_Serial.ScrolltoRow(i)
			dw_serial.SetItem(i,'c_select','N')
			Return
		End IF
		
		
		//Decrement from Content
		If dw_Content.getItemNumber(llFindRow,'Avail_Qty') > 0  Then
	
				// TAM 2019/05 - S33409 - Populate Serial History Table
				dw_serial.setItem(i,'Transaction_Type','ADJUST')
				dw_serial.setItem(i,'Transaction_ID','')
				dw_serial.setItem(i,'Adjustment_Type','SERIAL DELETED')
			
			IF lbDeleteSerialOnly THEN
				dw_Serial.DeleteRow(i)
			ELSE
				dw_Content.setItem(llFindRow,'avail_qty', dw_Content.getItemNumber(llFindRow,'Avail_Qty') - 1)
				dw_Content.setItem(llFindRow,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
				dw_Serial.DeleteRow(i)
			END IF
		Else
			
			Messagebox("Adjust", "Corresponding Inventory record not found for Serial Number '" + dw_serial.getItemString(i,'serial_no') + "' ~rOr multiple Serial deletes decrementing Inventory below 0.~rUnable to delete Serial Number~r~rClick 'Reset' to review and start again.",Stopsign!)
			dw_Serial.ScrolltoRow(i)
			cb_adjust_Ok.Enabled = False
			cb_delete_Serials.Enabled = False
			cb_swap_Serial.Enabled = False  //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
			Return
			
		End If
		
	End If

Next /*Serial Record */

cb_delete_Serials.Enabled = False
cb_swap_Serial.Enabled = False  //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
end event

type dw_serial from u_dw_ancestor within w_adjust_create
integer y = 1616
integer width = 4018
integer height = 732
integer taborder = 40
string dataobject = "d_adjust_create_serials"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;call super::ue_retrieve;// 04/14 - PCONKL - Retrieve Serial NUmbers from serial_Number_Inventory based on same criteria used to retrieve main DW

String	lsWarehouse, lsSku,ls_supp, lsModify
Integer i
long ll_owner

string ls_orderno, ls_lotno, ls_OrigSQL, ls_serialno

//GailM 6/18/2019 Turn off dw_serial filter
dw_serial.SetFilter("")
dw_serial.Filter()


lsWarehouse = dw_adjust.GetItemString(1,"wh_code")
lsSku = dw_adjust.GetItemString(1,"sku")
ls_supp = dw_adjust.GetItemString(1,"supp_code")
ls_orderno = dw_adjust.GetItemString(1,"orderno")
ls_serialno =  dw_adjust.GetItemString(1,"serialno")

//Jxlim 01/21/2011 adding lot_no to search criteria
ls_lotno = dw_adjust.GetItemString(1,"lot_no")

IF  ( IsNull(ls_serialno) Or Trim(ls_serialno) = "") AND &
	( IsNull(ls_orderno) Or Trim(ls_orderno) = "") AND &	
	 ( IsNull(ls_lotno) Or Trim(ls_lotno) = "") AND &   
      ((IsNull(lsWarehouse) Or Trim(lsWarehouse) = "") OR  (IsNull(lsSku) Or Trim(lsSku) = "") OR (IsNull(ls_supp) Or Trim(ls_supp) = "")) Then
	RETURN 
END IF

string lsNewSQL, ls_where

ls_where = " Where ( ( Serial_Number_Inventory.Project_ID = '"+gs_project+"' ) and "

IF Not IsNull(ls_orderno) AND Trim(ls_orderno) <> '' THEN
	
	//ls_orderno
	
	this.Modify("sku.visible='1'")
	
	//BCR: Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQLSerial
	
	ls_where = ls_where + " ( Receive_Master.Supp_Invoice_No = '" + ls_orderno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "

//Jxlim 01/21/2011 if lot_no is not empty add to search criteria
ElseIf Not IsNull(ls_lotno) AND Trim(ls_lotno) <> '' THEN	

	this.Modify("sku.visible='1'")
	
	//BCR: Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQLSerial
	
	ls_where = ls_where + " ( Serial_Number_Inventory.lot_no = '" + ls_lotno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "

ElseIf Not IsNull(ls_serialno) AND Trim(ls_serialno) <> '' THEN	
	
	string ls_lcode, ls_RoNo, ls_inv_type, ls_lot_no, ls_po_no, ls_po_no2
	long ll_Owner_ID

	SELECT WH_Code, l_code, Sku, Owner_Id,  Ro_no, inventory_type, lot_no, po_no, po_no2
	INTO  :lsWarehouse, :ls_lcode, :lsSku, :ll_Owner_ID, :ls_RoNo, :ls_inv_type, :ls_lot_no, :ls_po_no, :ls_po_no2  
	FROM Serial_Number_Inventory with (NoLock) WHERE Serial_No = :ls_serialno USING SQLCA;


	IF SQLCA.SQLCode = 0 Then
			
	Else 
//		MessageBox ("Invalid Sku", "Sku not found in Serial Number Inventory table.")
		Return 
	End IF

	this.Modify("sku.visible='1'")	

	if dw_content.RowCount() > 0  then

		ls_where = ls_where + "  (Serial_Number_Inventory.wh_code = '" + lsWarehouse + "') and " + & 
						"  ( Serial_Number_Inventory.l_code = '" +  ls_lcode + "' )  and" + &
						"  ( Serial_Number_Inventory.Owner_Id = " +  string(ll_Owner_ID) + " ) and " + &
						"  ( Serial_Number_Inventory.Ro_No = '" +  ls_RoNo + "' ) and  " + &
						"  ( Serial_Number_Inventory.inventory_type = '" +  ls_inv_type + "' ) and  " + &
 						"  ( Serial_Number_Inventory.lot_no = '" +  ls_lot_no + "' ) and  " + &
						"  ( Serial_Number_Inventory.po_no = '" +  ls_po_no + "' ) and  " + &						 
						"  ( Serial_Number_Inventory.po_no2 = '" +  ls_po_no2 + "' ) and  " + &						 
						 "  ( Serial_Number_Inventory.SKU = '" +  lsSku + "') ) "
	
	
	else

		ls_where = ls_where + "  (serial_number_inventory.serial_no = '" + ls_serialno + "') ) " 	
		 
	end if
							 
							 
	//BCR 27-JUN-2011: SQL 2008 Compatibility...
	
	//Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQLSerial
	
	//Replace INNER JOIN b/w Content and Receive_Master in original SQL with LEFT JOIN, and eliminate it from the WHERE clause...
//	ls_OrigSQL = Replace(ls_OrigSQL,LastPos(ls_OrigSQL,'INNER'),5,'LEFT')
	//********************************************************
	
	
	
ELSE

	this.Modify("sku.visible='0'")	
	
	ls_where = ls_where + "  (Serial_Number_Inventory.wh_code = '" + lsWarehouse + "') and " + & 
							 "  ( Serial_Number_Inventory.SKU = '" +  lsSku + "') ) "
							 
	//BCR 27-JUN-2011: SQL 2008 Compatibility...
	
	//Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQLSerial
	
	//Replace INNER JOIN b/w Content and Receive_Master in original SQL with LEFT JOIN, and eliminate it from the WHERE clause...
//	ls_OrigSQL = Replace(ls_OrigSQL,LastPos(ls_OrigSQL,'INNER'),5,'LEFT')
	//********************************************************

END IF

lsNewSQL = ls_OrigSQL +  ls_where

this.Modify("DataWindow.Table.Select=~""+lsNewSQL+"~"")

This.Retrieve()
string lsorigpono2, lspono2
long  lsrowcount
lsrowcount = this.RowCount()
lsorigpono2= this.getItemString(1,'orig_po_no2')
lspono2= this.getItemString(1,'po_no2')

//GailM 6/20/2019 - S33404 - Check for zero serial numbers
If lsrowcount = 0 Then
	st_retrieve_sn.text = "No serial numbers found for this GPN."
Else
	st_retrieve_sn.text = ""
End If		



//If This.RowCount() <=0 Then
//	Messagebox("Stock Adjustment","No content records found for this Warehouse/SKU!")
//	dw_adjust.SetFocus()
//	dw_adjust.SetColumn("Sku")
//End If

//01/03 - Pconkl - Hide Container DIMS if There are no Containers present
//This.TriggerEvent('ue_hide_unused')



end event

event itemchanged;call super::itemchanged;String	lsFind, lsSKU
Long 	llCount, ll_rtn
Boolean lb_SN_cleaned
String lsInventory_Type

//Can not change the adjustment type or split a row after any changes are made
iwWindow.TriggerEvent('ue_disable_type_chg')
cb_adjust_Split.Enabled = False
ibSplitOK = False
cb_adjust_Reset.Enabled = True


CHOOSE CASE Upper(dwo.Name)
		
	Case 'L_CODE'
		
		//Only going to allow the location to be changed to match an existing Content Record in case it wasn;t transferred
		//	lsFilter = "(Upper(supp_invoice_no) = '" + Upper(This.GetITemString(row,'receive_Master_supp_invoice_no')) + "' or isnull(supp_invoice_no))"
	lsFind = "Upper(ro_no) = '" + Upper(This.GetITemString(row,'ro_no')) + "'"
	lsFind += " and Upper(l_code) = '" + Upper(data) + "'"
	lsFind += " and Upper(sku) = '" + Upper(This.GetITemString(row,'sku')) + "'"
	lsFind += " and Upper(inventory_type) = '" + Upper(This.GetITemString(row,'inventory_type')) + "'"
	lsFind += " and Upper(lot_no) = '" + Upper(This.GetITemString(row,'lot_no')) + "'"
	lsFind += " and Upper(po_no) = '" + Upper(This.GetITemString(row,'po_no')) + "'"
	lsFind += " and Upper(po_no2) = '" + Upper(This.GetITemString(row,'po_no2')) + "'"
		
	If dw_Content.Find(lsFind,1,dw_Content.RowCount()) < 1 Then
		Messagebox("Adjust","You can only change the location to match an existing Inventory Record.",StopSign!)
		Return 1
	End If

	// TAM 2019/05 - S33409 - Populate Serial History Table
	dw_serial.setItem(row,'Transaction_Type','ADJUST')
	dw_serial.setItem(row,'Transaction_ID','')
	dw_serial.setItem(row,'Adjustment_Type','LOCATION CHANGE')

Case 'C_SELECT'
	
	if data = 'Y' then
		cb_Delete_Serials.Enabled = True
		cb_swap_Serial.Enabled = True  and is_trans_type = 'S' //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	End IF
	
Case 'LOT_NO', 'PO_NO', 'PO_NO2', 'INVENTORY_TYPE', 'EXP_DT'
	
	if wf_adjust_Serial(row) < 0 Then
		return 1
	End If

	// TAM 2019/05 - S33409 - Populate Serial History Table
	dw_serial.setItem(row,'Transaction_Type','ADJUST')
	dw_serial.setItem(row,'Transaction_ID','')
	dw_serial.setItem(row,'Adjustment_Type','ATTRIBUTE CHANGE')
	
Case 'SERIAL_NO'

//	IF ib_allow_content_select_row = false OR dw_content.GetRow() = 0 THEN
//		Messagebox("Adjust", "Must select a content record first before you can add a Serial Number.",Stopsign!)
//		Return 1
//	END IF

	lsInventory_Type = dw_content.GetITemString(dw_content.GetRow(),'inventory_type')
		
	IF lsInventory_Type = "*" THEN
		Messagebox("Adjust", "The selected content record is in Cycle Count. Must complete Cycle Count before being able to change a serial.",Stopsign!)
		Return 1
	END IF



	//Sept 2019 - MikeA - S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
	//Allow duplicate serial numbers.	
	
	If not rb_serial_reconcile.checked Then
	
		//make sure the serial doesn't already exist...
		lsSKU = This.GetITemString(row,'SKU')
		
		Select COunt(*) into :llCount
		From Serial_Number_Inventory
		Where project_id = :gs_Project and sku = :lsSKU and serial_no = :data;
		
		If llCount > 0 Then
			Messagebox("Adjust","Serial Number already exists.",Stopsign!)
			Return 1
		End If
	End If
	
	// TAM 2019/05 - S33409 - Populate Serial History Table - If the origianl Value was Blank then don't update the Serial History Values.  It was already set in the cd_add_serial.clicked event
	if Not IsNull(dw_serial.GetITemString(row,'SERIAL_NO',primary!,TRUE)) and dw_serial.GetITemString(row,'SERIAL_NO',primary!,TRUE) <> ''  and dw_serial.GetITemString(row,'SERIAL_NO',primary!,TRUE) <> '-' Then
		dw_serial.setItem(row,'Transaction_Type','ADJUST')
		dw_serial.setItem(row,'Transaction_ID','')
		dw_serial.setItem(row,'Adjustment_Type','SERIAL CHANGED')
	End If
		
	// GailM 06/25/2019 - cleanup SN's by removing special characters '.' and '-'
	data = TRIM(data)
	If len(data) > 1 Then
		//DO WHILE MATCH( data, "[-\._$?]" )  //3/20 - MikeA -  DE15073 -SIMS - Google - Not able to save Serial Number with Dash
		DO WHILE MATCH( data, "[\._$?]" )
			data = f_string_replace(data,"_","")
			//data = f_string_replace(data,"-","") //3/20 - MikeA -  DE15073 -SIMS - Google - Not able to save Serial Number with Dash
			data = f_string_replace(data,"\","")
			data = f_string_replace(data,".","")
			data = f_string_replace(data,"$","")
			data = f_string_replace(data,"?","")
		LOOP	
		lb_SN_cleaned = TRUE
	End If	
	
	IF lb_SN_cleaned THEN
		ll_Rtn = 2
		this.setitem( row, dwo.name, data )
	ELSE
		ll_Rtn = 0
	
	END IF
	
	RETURN ll_Rtn
			
End Choose

	
end event

event itemerror;call super::itemerror;Return 1
end event

event itemfocuschanged;call super::itemfocuschanged;

if dwo.name = "serial_no" and rb_serial_reconcile.checked then
	
	if left(this.getitemstring(row,"serial_no"),1) ="?" then
		dwo.protect = 1
	else
		dwo.protect = 0
	end if
	
end if
end event

event clicked;call super::clicked;
if dwo.name = "serial_no" and rb_serial_reconcile.checked then
	
	if left(this.getitemstring(row,"serial_no"),1) ="?" then
		dwo.protect = 1
	else
		dwo.protect = 0
	end if
	
end if
end event

type rb_adjust_break_carton from radiobutton within w_adjust_create
integer x = 2715
integer y = 288
integer width = 494
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Break &Carton"
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;if Upper(gs_Project) = 'PANDORA' and Upper(f_retrieve_parm('PANDORA','FLAG','PALLET_BREAK_MERGE_ON')) = 'Y' then
	this.visible = true
	g.of_check_label_button(this)
else
	this.visible = false
end if
end event

type rb_adjust_merge_pallet from radiobutton within w_adjust_create
integer x = 3237
integer y = 220
integer width = 512
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Merge Footprint"
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')
end event

event constructor;if Upper(gs_Project) = 'PANDORA' and Upper(f_retrieve_parm('PANDORA','FLAG','PALLET_BREAK_MERGE_ON')) = 'Y' then
	this.visible = true
	g.of_check_label_button(this)
else
	this.visible = false
end if
end event

type rb_adjust_break_pallet from radiobutton within w_adjust_create
integer x = 2715
integer y = 220
integer width = 494
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Break &Pallet"
end type

event constructor;if Upper(gs_Project) = 'PANDORA' and Upper(f_retrieve_parm('PANDORA','FLAG','PALLET_BREAK_MERGE_ON')) = 'Y' then
	this.visible = true
	g.of_check_label_button(this)
else
	this.visible = false
end if
end event

event clicked;Parent.TriggerEvent('ue_process_type_chg')

end event

type cb_pallet_adjust from commandbutton within w_adjust_create
integer x = 2962
integer y = 412
integer width = 462
integer height = 92
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Pallet &Adjust"
end type

event clicked;parent.TriggerEvent('ue_pallet_adjust')

end event

event constructor;if Upper(gs_Project) = 'PANDORA' and Upper(f_retrieve_parm('PANDORA','FLAG','PALLET_BREAK_MERGE_ON')) = 'Y' then
	this.visible = true
	g.of_check_label_button(this)
else
	this.visible = false
end if
end event

type cb_adjust_reset from commandbutton within w_adjust_create
integer x = 2971
integer y = 2400
integer width = 311
integer height = 92
integer taborder = 130
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reset"
end type

event clicked;
//Enable the Inv Type Change Radio buttons
rb_adjust_qty.Enabled = True
rb_adjust_inv_type.Enabled = True
rb_adjust_owner.Enabled = True
rb_adjust_other.Enabled = True

rb_adjust_qty.Checked = True
iiQtyChgCount = 0

//13-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - START
If g.ibsnchainofcustody and is_serialized_ind = 'B' Then				
	rb_serial_reconcile.enabled =True 
Else
	rb_serial_reconcile.enabled =False
End If
//13-MAY-2019 :Madhu S33404 F15609 Inventory Serial Reconciliation Process - END				
				
destroy in_pallet_parms

dw_content.TriggerEvent("ue_retrieve")

Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;
g.of_check_label_button(this)
end event

type rb_adjust_other from radiobutton within w_adjust_create
integer x = 3237
integer y = 148
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O&ther"
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;
g.of_check_label_button(this)
end event

type rb_adjust_inv_type from radiobutton within w_adjust_create
integer x = 2715
integer y = 148
integer width = 494
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Inventory Type "
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;
g.of_check_label_button(this)


end event

type rb_adjust_owner from radiobutton within w_adjust_create
integer x = 3237
integer y = 84
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Owner"
end type

event clicked;Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;
g.of_check_label_button(this)
end event

type rb_adjust_qty from radiobutton within w_adjust_create
integer x = 2715
integer y = 84
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Qty"
end type

event clicked;
Parent.TriggerEvent('ue_process_type_chg')

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_sort from commandbutton within w_adjust_create
integer x = 3342
integer y = 2400
integer width = 297
integer height = 92
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Sort"
end type

event clicked;

//This Event displays the sor criterial & sorts by the desire criteria
long ll_ret
String str_null
SetNull(str_null)

ll_ret=dw_content.Setsort(str_null)
ll_ret=dw_content.Sort()
	

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_help from commandbutton within w_adjust_create
integer x = 3735
integer y = 2400
integer width = 261
integer height = 92
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;
ShowHelp(g.is_helpFile,Topic!,563)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_split from commandbutton within w_adjust_create
integer x = 1733
integer y = 2400
integer width = 334
integer height = 92
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "S&plit"
end type

event clicked;// 09/04 - PCONKL - any conversion of Container ID to Numeric must use LONGLONG instead of LONG

long ll_source, llNewRow, llFind  
longlong	llMaxContainer
string ls_colname,	&
		lsOrigContainer,	&
		lsMaxContentContainer,	&
		lsMaxPickContainer,	&
		lsMaxContainer,		&
		lsRONO,	&
		lsTemp,	&
		lsDONO

ll_source= ii_row

If ll_source <=0 Then Return

// 03/05 - PCONKL - If doing an owner or Inv Type Chg, Only allow 1 split
If rb_adjust_owner.Checked or rb_adjust_inv_Type.Checked Then
	ibSplitOK = False
	This.Enabled = False
End If

//Can not change the adjustment type after any changes are made
parent.TriggerEvent('ue_disable_type_chg')
cb_adjust_Reset.Enabled = True

dw_content.RowsCopy(ll_source,ll_source, Primary!, dw_content,ll_source + 1, Primary!)

//Denote Split, original row = 1, new = 2
dw_content.SetItem(ll_source,'c_split_ind','1')
dw_content.SetItem(ll_source + 1,'c_split_ind','2')


dw_content.Setfocus()
dw_content.Scrolltorow(ll_source + 1)
dw_content.SetColumn('avail_qty')

// 01/03 - PConkl - If we are tracking by Container ID, we may want to assign a new COntainer to the Split row
// This should be short term if we add true container logic

If dw_content.GeTitemString(ll_Source,'Container_id') <> '-' Then
	
	If Messagebox('Create Stock Adjustment','Would you like to assign a new Container ID to the new row?',Question!,YesNo!) = 1 Then
		
		//We need to determine the highest container ID already used for this order regardless of whether it exists in Content or not
		// Cartons were originally created by taking last 6 of RO_NO + 6 digit sequence #. Take next highest where first 6 are equal
		//If Container ID is < 12 characters, than it was probably created from original conversion in which case it is just sequential
		//and we should just take the next sequential number less than nnnnnn (Can't just take next one because it's already been used)
		
		SetPointer(hourglass!)
		
		lsOrigContainer = dw_content.GeTitemString(ll_Source,'Container_id')
		lsRONO = dw_content.GeTitemString(ll_Source,'ro_no')
		
		If len(lsOrigContainer) = 12 Then /*assigned in Putaway*/
		
			//Get the highest from Content
			Select Max(Convert(Numeric(25),container_ID)) Into :lsMaxContentContainer
			from Content
			Where Project_ID = :gs_Project and ro_no = :lsRoNO and container_id <> '-';
			
			//Get the Highest from Picking - it may have already been shipped and removed from Content
			lsTemp = Left(lsOrigContainer,6) + '%' /* we want the highest that match the first 6 of the current (same order) */
			lsDoNO = Left(gs_Project,8) + '%' /*narrow down to proper project*/
			
			Select Max(Convert(Numeric(25),Container_ID)) into :lsmaxPickContainer
			From Delivery_Picking
			Where do_no like :lsDoNo and Container_ID <> '-' and Container_ID like :lsTemp;
					
		Else /* assigned in Conversion - get the highest less than 12 digits (not too scientific)*/
			
			//Content
			Select Max(Convert(Numeric(25),container_ID)) Into :lsMaxContentContainer
			from Content
			Where Project_ID = :gs_Project and Container_ID <> '-' and Len(Container_id) < 12;
			
			//Picking
			lsDoNO = Left(gs_Project,8) + '%' /*narrow down to proper project*/
			
			Select Max(Convert(Numeric(25),Container_ID)) into :lsmaxPickContainer
			From Delivery_Picking
			Where do_no like :lsDoNo and Container_ID <> '-' and Len(Container_id) < 12;
						
		End If
		
		If isnull(lsMaxContentContainer) Then lsMaxContentContainer = "0"
		If isnull(lsMaxPickContainer) Then lsMaxpickContainer = "0"
		
		If LongLong(lsMaxContentContainer) > LongLong(lsMaxPickContainer) Then
				lsMaxContainer = lsMaxContentContainer
		Else
			lsMaxContainer = lsMaxPickContainer
		End If
		
		If isnumber(lsMaxContainer) Then
			
			llMaxContainer = LongLong(lsMaxContainer)
			
			If len(lsOrigContainer) = 12 Then
				lsMaxContainer = String((llMaxContainer + 1),"000000000000")
			Else
				lsMaxContainer = String((llMaxContainer) + 1)
			End If
			
			//we may have already retrieved this one but not saved to DB so if already found in DW, increment
			llFind = dw_Content.Find("container_id = '" + lsMaxContainer + "'", 1, dw_content.RowCount())
			Do While llFind > 0
				
				llMaxContainer = LongLong(lsMaxContainer)
				
				If len(lsOrigContainer) = 12 Then
					lsMaxContainer = String((llMaxContainer) + 1,"000000000000")
				Else
					lsMaxContainer = String((llMaxContainer) + 1)
				End If
				
				llFind = dw_Content.Find("container_id = '" + lsMaxContainer + "'", 1, dw_content.RowCount())
				
			Loop
			
			dw_content.SetItem(ll_source + 1,'container_id',lsMaxConTainer)
			ibNewContainer = True /*will prompt for Container Labels (Pulse Only)*/
			
		Else
			messagebox('Create Stock Adjustment','Unable to increment Container ID')
		End If
		
		SetPointer(arrow!)
		
	End If /*new Container requested*/
	
End If /*Container Tracking*/

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_cancel from commandbutton within w_adjust_create
integer x = 2569
integer y = 2400
integer width = 297
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;
ibCancel = True
Close(Parent)
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_adjust_ok from commandbutton within w_adjust_create
integer x = 2213
integer y = 2400
integer width = 247
integer height = 92
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;ibCancel = False
Close(Parent)
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_adjust from u_dw_ancestor within w_adjust_create
integer width = 2661
integer height = 492
string dataobject = "d_adjust_new_header"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;string ls_supp_code,ls_sku,ls_title
string ls_null
Setnull(ls_null)
////Once sku is populated, retrieve Content
//If dwo.name = "sku" Then
//	dw_content.PostEvent("ue_retrieve")
//End If

ls_title = w_adjust_create.title
CHOOSE CASE dwo.name
case 'sku'
	
	this.SetItem( 1, "orderno", ls_null)
	this.SetItem( 1, "serialno", ls_null)
	
	dw_content.Reset()
	destroy in_pallet_parms

	//Check if item_master has the records for entered sku	
	IF i_nwarehouse.of_item_sku(gs_project,data) > 0 THEN	
		//Check in drop down datawindows & insert row just to escape from retrieve
		IF idwc_supp.Retrieve(gs_project,data) > 0 THEN
			ls_supp_code =idwc_supp.Getitemstring(1,"supp_code")		
		END IF
		//Check if ddw is 0 then insert to avoid retrival argument pop up
		//IF ddw ret 1 row then assign the value to dupp_code
   	IF idwc_supp.RowCount() = 0 THEN 
     		 idwc_supp.InsertRow( 0 )
		ELSEIF idwc_supp.RowCount() = 1  and ( not isnull(ls_supp_code) or ls_supp_code <> "" ) THEN			
			  	This.object.supp_code[ row ] = ls_supp_code
				ls_sku = data				
				dw_content.PostEvent("ue_retrieve")

				//TAM - 2018/02 - If Chain of Custody and Sku is serial tracked then don't allow Qty to be changed on Content.(QTY will be handled on the Serial DW)
				//TAM - 2018/02 - S14838 - If PO_NO2 tracked, and Container Tracked  and Serialized Tracked then lock down PoNo2 and Container Id
				Select Serialized_Ind, container_tracking_ind, po_no2_controlled_ind Into :is_serialized_ind, :is_container_ind, :is_po_no2_ind
				From Item_Master WITH (NOLOCK)
				Where project_id = :gs_project and sku = :ls_sku and supp_code = :ls_supp_code;			

				If g.ibsnchainofcustody and is_serialized_ind = 'B' Then				
					dw_Content.Modify("Avail_Qty.Protect=1")
				Else
					dw_Content.Modify("Avail_Qty.Protect=0")
				End If
				
				If  is_po_no2_ind = 'Y' and is_container_ind = 'Y' and is_serialized_ind = 'B' Then				
					dw_Content.Modify("Po_No2.Protect=1")	
					dw_Content.Modify("Container_Id.Protect=1")	
				Else
					dw_Content.Modify("Po_No2.Protect=0")	
					dw_Content.Modify("Container_Id.Protect=0")	
				End If
				
		ELSEIF idwc_supp.RowCount() > 1 THEN			   
//			   this.Setfocus()
//				SetColumn("supp_code")
            this.object.supp_code[row] = ls_null
            f_setfocus(dw_adjust,row,'supp_code')				
   		END IF
 	Else		/*Not found */	
		MessageBox(ls_title, "Invalid SKU, please re-enter!",StopSign!)
//		post event ue_post_itemchanged()
      post f_setfocus(dw_adjust,row,'sku')
		return -1
		
 END IF

Case 'supp_code'
	
	this.SetItem( 1, "orderno", ls_null)
	 //Jxlim 01/21/2011 lot_not
	this.SetItem( 1, "lot_no", ls_null) 	 
	this.SetItem( 1, "serialno", ls_null)
	 ls_sku = this.Getitemstring(row,"sku")
	 //ls_supp_code = data
	 destroy in_pallet_parms

	 dw_content.PostEvent("ue_retrieve")
	 
Case 'orderno'
	 dw_content.Reset()
	 //Jxlim 01/21/2011 lot_not
	 this.SetItem( 1, "lot_no", ls_null) 	 
	 this.SetItem( 1, "sku", ls_null)
	 this.SetItem( 1, "supp_code", ls_null)
	 this.SetItem( 1, "wh_code", ls_null)	 
	 this.SetItem( 1, "serialno", ls_null)
	 
	 destroy in_pallet_parms

	 dw_content.PostEvent("ue_retrieve")

Case 'wh_code'
	
	this.SetItem( 1, "orderno", ls_null)
	 //Jxlim 01/21/2011 lot_not
	 this.SetItem( 1, "lot_no", ls_null) 	 
	this.SetItem( 1, "serialno", ls_null)
	
	destroy in_pallet_parms

	dw_content.PostEvent("ue_retrieve")
	
//Jxlim 02/21/2011 Added lot_no criteria
Case 'lot_no'
	dw_content.Reset()
	this.SetItem( 1, "orderno", ls_null)
	this.SetItem( 1, "sku", ls_null)
	this.SetItem( 1, "supp_code", ls_null)
	this.SetItem( 1, "wh_code", ls_null)
	this.SetItem( 1, "serialno", ls_null)
	
	destroy in_pallet_parms

	dw_content.PostEvent("ue_retrieve")	

Case 'serialno'
	
	dw_content.Reset()
	dw_serial.Reset()
	this.SetItem( 1, "orderno", ls_null)
	this.SetItem( 1, "sku", ls_null)
	this.SetItem( 1, "supp_code", ls_null)
	this.SetItem( 1, "wh_code", ls_null) 
	 this.SetItem( 1, "lot_no", ls_null)
	 
	destroy in_pallet_parms
	

	 
	dw_content.PostEvent("ue_retrieve")	 
	cbx_serial_retrieve.checked = true
	 
	dw_serial.PostEvent("ue_retrieve")	  
	 
END Choose			
Return




end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event constructor;This.SetTransObject(Sqlca)
//IF g.ib_label_access THEN g.POST of_lable_insert(this)
// pvh - 11/28/06 - moved to after the accepttext to avoid multiple messages..i hope
// g.of_check_label(this) 
g.of_check_label(this) 

setOriginalPosition()

//Jxlim 04/01/2011 Make reason field a not allow for editing for Pandora only.

//BCR 15-DEC-2011: Treat Bluecoat same as Pandora
If gs_project = 'PANDORA' OR gs_project = 'BLUECOAT' Then
   dw_adjust.Modify("reason.dddw.AllowEdit=no")
Else
   dw_adjust.Modify("reason.dddw.AllowEdit=yes'")		
End If
end event

type gb_adjustment_type from groupbox within w_adjust_create
integer x = 2670
integer y = 16
integer width = 1097
integer height = 380
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Adjustment Type"
end type

event constructor;
g.of_check_label_button(this)

if Upper(gs_Project) = 'PANDORA' and Upper(f_retrieve_parm('PANDORA','FLAG','PALLET_BREAK_MERGE_ON')) = 'Y' then
	//this.height = 350
else
	this.height = 280
end if
end event

type dw_content from u_dw_ancestor within w_adjust_create
event ue_hide_unused ( )
event ue_retrieve_obsolete ( )
event ue_keypress pbm_dwnkey
integer y = 524
integer width = 4018
integer height = 1004
integer taborder = 20
string dataobject = "d_adjust_new_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_hide_unused;
//01/03 - Pconkl - Hide Container DIMS if There are no Containers present
If This.Find("Container_ID <> '-'",1,This.RowCount()) = 0 Then
	This.Modify("cntnr_Length.Width=0 Cntnr_Width.Width=0 Cntnr_height.Width=0 Cntnr_Weight.Width=0")
Else
	This.Modify("cntnr_Length.Width=297 Cntnr_Width.Width=297 Cntnr_height.Width=297 Cntnr_Weight.Width=297")
End If
end event

event ue_retrieve_obsolete();//BCR 27-JUN-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN...
//...This is the original ue_retrieve prior to SQL 2008 conversion. I am preserving it for future reference. I had to, first, 
//modify d_adjust_new_detail because it selected from a table not used in the WHERE clause, which is not allowable in 2008. 
//This, in turn, called for a substantial re-write of this user event (see ue_retrieve).

String	lsWarehouse, lsSku,ls_supp, lsModify
Integer i
long ll_owner

string ls_orderno, ls_lotno


lsWarehouse = dw_adjust.GetItemString(1,"wh_code")
lsSku = dw_adjust.GetItemString(1,"sku")
ls_supp = dw_adjust.GetItemString(1,"supp_code")
ls_orderno = dw_adjust.GetItemString(1,"orderno")

//Jxlim 01/21/2011 adding lot_no to search criteria
ls_lotno = dw_adjust.GetItemString(1,"lot_no")

IF ( IsNull(ls_orderno) Or Trim(ls_orderno) = "") AND &	
	 ( IsNull(ls_lotno) Or Trim(ls_lotno) = "") AND &   
      ((IsNull(lsWarehouse) Or Trim(lsWarehouse) = "") OR  (IsNull(lsSku) Or Trim(lsSku) = "") OR (IsNull(ls_supp) Or Trim(ls_supp) = "")) Then
	RETURN 
END IF

string lsNewSQL, ls_where

ls_where = " and ( ( Content.Project_ID = '"+gs_project+"' ) and "

IF Not IsNull(ls_orderno) AND Trim(ls_orderno) <> '' THEN
	
	//ls_orderno
	
	this.Modify("sku.visible='1'")
	
	ls_where = ls_where + " ( Content.RO_No = Receive_Master.RO_No) and  ( Receive_Master.Supp_Invoice_No = '" + ls_orderno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "

//Jxlim 01/21/2011 if lot_no is not empty add to search criteria
ElseIf Not IsNull(ls_lotno) AND Trim(ls_lotno) <> '' THEN	

	this.Modify("sku.visible='1'")
	
	ls_where = ls_where + " ( Content.RO_No = Receive_Master.RO_No) and  ( Content.lot_no = '" + ls_lotno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "
	
ELSE

	this.Modify("sku.visible='0'")	
	
				IF IsNull(lsWarehouse) OR lsWarehouse = "" THEN
					MessageBox ("Required", "Warehouse is required.")
					dw_adjust.SetFocus()
					dw_adjust.SetColumn("wh_code")					
					RETURN 
				END IF				
	
	ls_where = ls_where + "  ( Content.RO_No *= Receive_Master.RO_No) and " + &
							 "  (content.wh_code = '" + lsWarehouse + "') and " + & 
							 "  ( Content.SKU = '" +  lsSku + "') ) and " + &
							 "  ( Content.Supp_Code = '"+ls_supp+"' ) " 	
					
END IF

lsNewSQL = isOrigSQL +  ls_where

this.Modify("DataWindow.Table.Select=~""+lsNewSQL+"~"")

This.Retrieve()


If This.RowCount() <=0 Then
	Messagebox("Stock Adjustment","No content records found for this Warehouse/SKU!")
	dw_adjust.SetFocus()
	dw_adjust.SetColumn("Sku")
End If

//01/03 - Pconkl - Hide Container DIMS if There are no Containers present
This.TriggerEvent('ue_hide_unused')

IdOrigQty = 0

IF This.RowCount() > 0  THEN
	For i = 1 to This.rowcount()
		// 09/01 PConkl - we will show the original qty to show how it's being changed
		IdOrigQty += THis.GetITemNUmber(i,'avail_qty')  
	Next
END IF	

lsModify = "orig_qty_text.Text='" + string(IdOrigQty, "######0.#####") + "'"  //GAP 12-02	decimal masking
This.Modify(lsModify)

cb_adjust_Reset.Enabled = False

end event

event ue_keypress;
//if ((key = KeyDownArrow! OR key = KeyUpArrow!)) then
//    return 1
//end if

IF KeyDown(KeyUpArrow!) or KeyDown(KeyDownArrow!) THEN
	Return 1
END IF




					  

end event

event ue_retrieve;//BCR 27-JUN-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN...
//...I had to, first, modify d_adjust_new_detail because it selected from a table not used in the WHERE clause, which is not 
//allowable in 2008. This, in turn, called for a substantial re-write of this user event (see ue_retrieve_obsolete for the original code).

String	lsWarehouse, lsSku,ls_supp, lsModify
Integer i
long ll_owner
long llRowCount
string ls_orderno, ls_lotno, ls_OrigSQL
string ls_serialno

lsWarehouse = dw_adjust.GetItemString(1,"wh_code")
lsSku = dw_adjust.GetItemString(1,"sku")
ls_supp = dw_adjust.GetItemString(1,"supp_code")
ls_orderno = dw_adjust.GetItemString(1,"orderno")
ls_serialno =  dw_adjust.GetItemString(1,"serialno")

//Jxlim 01/21/2011 adding lot_no to search criteria
ls_lotno = dw_adjust.GetItemString(1,"lot_no")



IF	( IsNull(ls_serialno) Or Trim(ls_serialno) = "")  AND &
	( IsNull(ls_orderno) Or Trim(ls_orderno) = "") AND &	
	 ( IsNull(ls_lotno) Or Trim(ls_lotno) = "") AND &   
      ((IsNull(lsWarehouse) Or Trim(lsWarehouse) = "") OR  (IsNull(lsSku) Or Trim(lsSku) = "") OR (IsNull(ls_supp) Or Trim(ls_supp) = "")) Then
	RETURN 
END IF

string lsNewSQL, ls_where

//if trim(ls_serialno) <> '' and not isnull(ls_serialno) then
//	SELECT WH_Code,  Sku INTO  :lsWarehouse, :lsSku FROM Serial_Number_Inventory with (NoLock) WHERE Serial_No = :ls_serialno USING SQLCA;
//
//	IF SQLCA.SQLCode = 0 Then
//
//	Else 
//		MessageBox ("Invalid Sku", "Sku not found in Serial Number Inventory table.")
//		Return 
//	End IF
//
//end if


ls_where = " and ( ( Content.Project_ID = '"+gs_project+"' ) and "

IF Not IsNull(ls_orderno) AND Trim(ls_orderno) <> '' THEN
	
	//ls_orderno
	
	this.Modify("sku.visible='1'")
	
	//BCR: Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQL
	
	ls_where = ls_where + " ( Receive_Master.Supp_Invoice_No = '" + ls_orderno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "

//Jxlim 01/21/2011 if lot_no is not empty add to search criteria
ElseIf Not IsNull(ls_lotno) AND Trim(ls_lotno) <> '' THEN	

	this.Modify("sku.visible='1'")
	
	//BCR: Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQL
	
	ls_where = ls_where + " ( Content.lot_no = '" + ls_lotno + "')) AND Receive_Master.Supp_Invoice_No Is Not Null "

ElseIf Not IsNull(ls_serialno) AND Trim(ls_serialno) <> '' THEN		
	
		this.Modify("sku.visible='1'")
	// Begin - Dinesh - 10/06/2022 - SIMS-89- Geistlich Serialization - Updates (Part II)
		if upper(gs_project)='GEISTLICH' then
			
			ls_OrigSQL = isOrigSQL
		
			ls_where = ls_where + " ( Content.serial_no = '" + ls_serialno + "'" + " and Item_Master.Serialized_Ind ='Y'))"
		
		
		else // End  - Dinesh - 10/06/2022 - SIMS-89- Geistlich Serialization - Updates (Part II)
			
			ls_where = ls_where + "  (Serial_Number_Inventory.serial_no = '" + ls_serialno + "'))" 
	
	//Get a local copy of the original sql instance variable now that we've modified the original dw select statement
			ls_OrigSQL = isOrigSQL
	
	//Replace INNER JOIN b/w Content and Receive_Master in original SQL with LEFT JOIN, and eliminate it from the WHERE clause...
	ls_OrigSQL = Replace(ls_OrigSQL,LastPos(ls_OrigSQL,'INNER'),5,'LEFT')
	
	integer li_lastpos

	li_LastPos = LastPos(ls_OrigSQL, "RO_No")
	
	ls_OrigSQL = left(  ls_OrigSQL, li_LastPos + 4) + &
		"	INNER JOIN Serial_Number_Inventory ON   Content.Project_ID = Serial_Number_Inventory.Project_Id  and  " + &
          " Content.WH_Code = Serial_Number_Inventory.Wh_Code  and  " + &
         	" Content.L_Code = Serial_Number_Inventory.L_Code  and " + & 
      	   " Content.Owner_ID = Serial_Number_Inventory.Owner_Id  and  " + &
   	      " Content.SKU = Serial_Number_Inventory.SKU  and "  + &
		" Content.Ro_no = Serial_Number_Inventory.Ro_no " + &
		mid(  ls_OrigSQL, li_LastPos + 5)	

	//********************************************************
	end if // Dinesh
	 dw_content.Post Function SetRow(1)
	ii_row = 1
	
ELSE

	this.Modify("sku.visible='0'")	
	
				IF IsNull(lsWarehouse) OR lsWarehouse = "" THEN
					MessageBox ("Required", "Warehouse is required.")
					dw_adjust.SetFocus()
					dw_adjust.SetColumn("wh_code")					
					RETURN 
				END IF				
	
//	ls_where = ls_where + "  ( Content.RO_No *= Receive_Master.RO_No) and " + &
//							 "  (content.wh_code = '" + lsWarehouse + "') and " + & 
//							 "  ( Content.SKU = '" +  lsSku + "') ) and " + &
//							 "  ( Content.Supp_Code = '"+ls_supp+"' ) " 	
	ls_where = ls_where + "  (content.wh_code = '" + lsWarehouse + "') and " + & 
							 "  ( Content.SKU = '" +  lsSku + "') ) and " + &
							 "  ( Content.Supp_Code = '"+ls_supp+"' ) " 
							 
	//BCR 27-JUN-2011: SQL 2008 Compatibility...
	
	//Get a local copy of the original sql instance variable now that we've modified the original dw select statement
	ls_OrigSQL = isOrigSQL
	
	//Replace INNER JOIN b/w Content and Receive_Master in original SQL with LEFT JOIN, and eliminate it from the WHERE clause...
	ls_OrigSQL = Replace(ls_OrigSQL,LastPos(ls_OrigSQL,'INNER'),5,'LEFT')
	//********************************************************

END IF

// LTK 20131013  Pandora #657 Pallet break logic
if IsValid(in_pallet_parms) then
	ls_where = " and  Content.Project_ID = '" + gs_project + "'  "
	ls_where += " and Content.wh_code = '" + in_pallet_parms.is_warehouse + "' "
	ls_where += " and Content.sku = '" + in_pallet_parms.is_sku + "' "
//	ls_where += " and Content.po_no2 = '" + in_pallet_parms.is_sscc_nr + "' "
//	ls_where += " and Content.container_id in " + in_pallet_parms.of_get_container_in_string()
		
//TAM 2018 - S14838 - For Merge Pallet and Break Pallet we are using the Container list to create adjustment rows since we are moving full containers
//	if in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART or &
//	   in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART then
	if in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_CARTON_APART then
		ls_where += " and Content.po_no2 = '" + in_pallet_parms.is_sscc_nr + "'"
		ls_where += " and Content.container_id = '" + in_pallet_parms.is_carton_id + "'"

	elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.BREAK_PALLET_APART or &
		   in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_PALLET then
			ls_where += " and Content.container_id in " + in_pallet_parms.of_build_carton_in_string()
// TAM 2019/03 - 29817 - Mixed Footprint Containerization -start
	elseif in_pallet_parms.is_adjustment_type = n_adjust_pallet_parms.MERGE_FOOTPRINT then
		// If the TO container = Carton 
		if in_pallet_parms.is_to_scan_type = 'C' then
		//TEST - Merge Cartons 
			ls_where += " and (Content.container_id = '" + in_pallet_parms.is_carton_id + "'" //To Carton ID scanned
			//	loop through the pallet/carton rows to build the where clause for the FROM rows
			llRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
			if llRowCount < 1 then
				MessageBox("Error", "Expecting at least one row.  Found.  Please contact support.")
			else		
				for i = 1 to llRowCount
					ls_where += " or (Content.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
					ls_where += "  and Content.container_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
				next
			ls_where += ")" 				
			end if

		// If the TO container = Pallet 
		else
			// If Pallet is containerized  then we get the TO.Pono2 and the list of FROM.Carton IDs into Content 
			if in_pallet_parms.is_to_pallet_type = 'C' then
				// Build the where clause
				ls_where += " and (" 
				//	loop through the pallet/carton rows to build the where clause for the FROM rows
				llRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
				if llRowCount < 1 then
					MessageBox("Error", "Expecting at least one row.  Found.  Please contact support.")
				else		
					for i = 1 to llRowCount
						if i = 1 then
						ls_where += " (Content.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
						else
							ls_where += " or (Content.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
						end if
						ls_where += "  and Content.container_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
					next
					ls_where += ")"
				End If


			// else TO container is a loose serial Pallet then we get the TO.Pono2 and then build the list of FROM.PONO2/CARTON combinations 
			else
				ls_where += " and (Content.po_no2 = '" + in_pallet_parms.is_sscc_nr + "'" //To Pallet ID scanned
				//	loop through the pallet/carton rows to build the where clause for the FROM rows
				llRowCount = in_pallet_parms.ids_pallet_carton_list.RowCount()
				if llRowCount < 1 then
					MessageBox("Error", "Expecting at least one row.  Found.  Please contact support.")
				else		
					for i = 1 to llRowCount
						ls_where += " or  (Content.po_no2 = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'Po_No2') + "'"
						ls_where += "  and Content.container_id = '" + in_pallet_parms.ids_pallet_carton_list.getItemString(i,'carton_id') + "')"
					next
				end if
				ls_where += ")" 				
			end if
		end if
// TAM 2019/03 - 29817 - Mixed Footprint Containerization -End

	else
		// Carton Merge, build the pallet "in string"
		//ls_where += " and Content.container_id in " + in_pallet_parms.of_get_container_in_string()	// old functionality
//		ls_where += " and Content.po_no2 in " + in_pallet_parms.of_build_pallet_in_string()
	end if
end if

//lsNewSQL = isOrigSQL +  ls_where
lsNewSQL = ls_OrigSQL +  ls_where

this.Modify("DataWindow.Table.Select=~""+lsNewSQL+"~"")


This.Retrieve()


If This.RowCount() <=0 Then
	Messagebox("Stock Adjustment","No content records found!")
	dw_adjust.SetFocus()
	dw_adjust.SetColumn("Sku")
End If

//01/03 - Pconkl - Hide Container DIMS if There are no Containers present
This.TriggerEvent('ue_hide_unused')

IdOrigQty = 0

IF This.RowCount() > 0  THEN
	For i = 1 to This.rowcount()
		// 09/01 PConkl - we will show the original qty to show how it's being changed
		IdOrigQty += THis.GetITemNUmber(i,'avail_qty')  
	Next
END IF	

lsModify = "orig_qty_text.Text='" + string(IdOrigQty, "######0.#####") + "'"  //GAP 12-02	decimal masking
This.Modify(lsModify)

// LTK 20141023 Added the serial number checkbox so that serials are not automatically retrieved
if cbx_serial_retrieve.checked then
	//04/14 - PCONKL - Retrieve the Serial NUmbers from Serial_Number_Inventory if chain of custody enabled
	 IF g.ibSNchainofcustody THEN
		dw_serial.TriggerEvent('ue_retrieve')
	End If
end if

cb_adjust_Reset.Enabled = False

wf_enable_break_pallet()	// LTK 20131013  Pandora #657  enable break pallet command buttons if rules are satisfied

IF this.rowcount( ) > 0 THEN cb_adjust_import.enabled=TRUE //12-Dec-2014 :Madhu- Added for HONDA -Stock Adjustment Import



end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1
end event

event itemchanged;call super::itemchanged;String	lsCOO, ls_old_containerId, ls_old_pono2, lsFilter 
String lsProject_ID, lsSKU, lsSupp_Code, lsWH_Code, lsL_Code, lsInventory_Type, lsSerial_No, lsLot_No, lsRO_No &
		, lsPO_No, lsPO_No2, lsContainer_ID
Datetime ldtExpiration_Date
Long llOwner_ID
Long	lLRowPos, llRowCount
Long ll_carton_srl
Datetime ldtExpDT

//TAM 07/04			
This.SetITem(row,'c_Send_collab_ind','Y') /*always write a adjustment to the batch transaction on item change */

//Can not change the adjustment type or split a row after any changes are made
iwWindow.TriggerEvent('ue_disable_type_chg')
cb_adjust_Split.Enabled = False
ibSplitOK = False
cb_adjust_Reset.Enabled = True

CHOOSE CASE Upper(dwo.Name)
		
	Case 'AVAIL_QTY'
		
			/*only allowing qty to change on 2 rows in a single transaction for a qualitative adjustment*/
			If  rb_adjust_inv_type.Checked or rb_adjust_owner.Checked Then
				
				iiQtyChgCount ++ 
				
				If iiQtyChgCount > 2 Then
					Messagebox("Adjust","You can only move the qty between 2 rows for a qualitative adjustment")
					This.SetITem(row,'c_Send_collab_ind','N')
					Return 1
				End If
				
				//If this is not a new row of a split and Inventory TYpe or Owner has been changed, can't change qty as well
				If This.GetITemString(row,'c_split_ind') <> '2' Then /* 2 = new row of the split,1 = orignal split row */
				
					If this.GetITemStatus(row,'inventory_type',Primary!) = DataModified! Then
						Messagebox("Adjust","You can not modify both the Inventory Type and Qty without creating a new row (Split)")
						This.SetITem(row,'c_Send_collab_ind','N')
						Return 1
					End If
					
					If this.GetITemStatus(row,'owner_id',Primary!) = DataModified! Then
						Messagebox("Adjust","You can not modify both the Owner and Qty without creating a new row (Split)")
						This.SetITem(row,'c_Send_collab_ind','N')
						Return 1
					End If
					
				End If /*not new split row*/
				
			End If /*Qualitative adjustment*/
			
			//JXLIM 05/04/2010 End of code
		
		
	Case 'INVENTORY_TYPE'
		
			//If this is row being split, don't allow Inv Type to be changed on Original row, force user to change on new row
			If This.GetITemString(row,'c_split_ind') = '1' Then /* 1 = orignal row, 2 = new row*/
				Messagebox("Adjust","You must change the Inventory type on the new row")
				This.SetITem(row,'c_Send_collab_ind','N')
				Return 1
			End If
			
			//If not processing a split row, can't change both Type and Qty
			If This.GetITemString(row,'c_split_ind') <> '1' and  This.GetITemString(row,'c_split_ind') <> '2'and &
				this.GetITemStatus(row,'avail_qty',Primary!) = DataModified! Then
				
					Messagebox("Adjust","You can not modify both the Inventory Type and Qty without creating a new row (Split)")
					This.SetITem(row,'c_Send_collab_ind','N')
					Return 1					
			End If			
			
			// 11/11 - PCONKL - If retrieved by Order and an Inv Type change, allow a change to the first row to be replicated to all rows - will exclude for Comcast for now since we have to check type of each pallet
			If rb_adjust_inv_type.checked and dw_adjust.GetItemString(1,'orderno') > '' and row = 1 and this.Rowcount() > 1 and gs_project <> 'COMCAST' Then
				
				If Messagebox("Adjustment","Would you like to apply this Inventory Type to all records?",Question!,yesNo!,2) = 1 Then
					
					lsInventory_Type = data
					llRowCount = This.RowCount()
					For lLRowPos = 2 to llRowCount
						This.SetITem(llRowPos,'Inventory_Type',lsInventory_Type)
						This.SetITem(llRowPos,'c_Send_collab_ind','Y')
					Next
					
				End If
				
			End If
			
			
			// 04/14 - PCONKL - UPdate Inventory Type on all linked Serial Numnber Records
			llRowCount = dw_Serial.RowCount()
			If llRowCount > 0 Then
				
				For llRowPos = 1 to llRowCOunt
					dw_Serial.SetITem(llRowPos,'inventory_type',data)
				Next
				
				This.SetITem(row,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
				
			End If
			
	//Jxlim 01/21/2011 for W&S po_no and po_n02 only accept Numeric values
	//Tricky need to use upper case for teh column name else won't find it.
	Case "PO_NO"
		
		If Left(gs_project,3) = 'WS-' Then		
			If Not isnumber(data) Then
				Messagebox("Adjust", "Only Numeric values allowed!")
				Return 1
			End If
		End If
		
		// 04/14 - PCONKL - UPdate PO_NO on all linked Serial Numnber Records

		// TAM 2018/11/12 - DE7196 - If SKU is serialized but the retrieve serial number has not been clicked we need to force the retrieve
		IF g.ibSNchainofcustody and dw_Serial.RowCount() <= 0 THEN
			dw_serial.TriggerEvent('ue_retrieve')
			cbx_serial_retrieve.checked = true
		End If

		//GailM 10/21/2020 DE18225 Google - SIMS Production - Stock Adjustments on Serial Tracked GPNs not updating PONO - filter for content ro
		lsFilter = " (Upper(ro_no) = '" + Upper(This.GetITemString(row,'ro_no',primary!,true)) + "' or isnull(ro_no)) "
		lsFilter += " and (Upper(l_code) = '" + Upper(This.GetITemString(row,'l_code',primary!,true)) + "' or isnull(l_code)) "
		lsFilter += " and (Upper(sku) = '" + Upper(This.GetITemString(row,'sku')) + "' or isnull(sku)) "
		lsFilter += " and (Upper(lot_no) = '" + Upper(This.GetITemString(row,'lot_no',primary!,true)) + "' or isnull(lot_no)) "
		lsFilter += " and String(exp_dt,'MMDDYYYY') = '" + String(This.GetITemDateTime(row,'expiration_date',primary!,true),'MMDDYYYY') + "'"
		dw_Serial.SetFilter(lsFilter)
		dw_Serial.Filter()
		
		llRowCount = dw_Serial.RowCount()
		If llRowCount > 0 Then
			
			For llRowPos = 1 to llRowCOunt
				dw_Serial.SetITem(llRowPos,'po_no',data)
			Next
		
			This.SetITem(row,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/

		End If
						
	Case "LOT_NO"
		
		
		// 04/14 - PCONKL - UPdate Lot_NO on all linked Serial Numnber Records
		llRowCount = dw_Serial.RowCount()
		If llRowCount > 0 Then
				
			For llRowPos = 1 to llRowCOunt
				dw_Serial.SetITem(llRowPos,'Lot_no',data)
			Next
			
			This.SetITem(row,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
				
		End If
			
		// 03/16 - PCONKL - For Kendo, Validate Lot No against Lot COntrol file and populate Expiration Date 
		IF Upper(gs_Project) = 'KENDO' and data <> '-'  Then
						
			lsSKU = This.GetItemString(row,"sku") 
			lsSupp_Code = This.GetItemString(row,"supp_code") 
						
			Select Expiration_Date
			Into :ldtExpDT
			From Lot_Control
			Where project_id = 'KENDO' and sku = :lsSKU and Supp_code = : lsSupp_Code and Lot_No = :data
			Using SQLCA;
						
			If Sqlca.sqlnrows < 1 Then
				Messagebox("Adjust","Invalid Batch Code (Lot)!",StopSign!)
				Return 1
			Else
				This.SetItem(row,'Expiration_date',ldtExpDT)
			End If
						
		End If

	Case "EXPIRATION_DATE"
		
		
		// 04/14 - PCONKL - UPdate EXP_DT on all linked Serial Numnber Records
		llRowCount = dw_Serial.RowCount()
		If llRowCount > 0 Then
				
			For llRowPos = 1 to llRowCOunt
				dw_Serial.SetITem(llRowPos,'exp_dt',datetime(data))
			Next
				
			This.SetITem(row,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
			
		End If
						
	Case "PO_NO2"
		
		If Upper(gs_project) = 'PANDORA' Then
			//GailM 8/11/2020 S48701 F24564 Google - Prevent N/A on put away and stock adjustment and stock adjustment
			//Force po_no2 to 5 or more characters and do not allow anything less that 5 to be anything but NA
			ls_old_pono2 = This.getItemString( row, 'po_no2', primary!, true)
			If len(data) < 5 and data <> 'NA' Then
				Messagebox("Adjust","Pallet ID must be over 4 characters except the value NA.  Please re-enter.")
				This.setitem(row, 'po_no2', ls_old_pono2)
				This.SetFocus()
				This.SelectText(1, Len(ls_old_pono2))
				Return 1
			End If
		End If
		
		If Left(gs_project,3) = 'WS-' Then		
			If Not isnumber(data) Then
				Messagebox("Adjust", "Only Numeric values allowed!")
				Return 1
			End If
		End If			
		
		// 04/14 - PCONKL - UPdate po_no2 on all linked Serial Numnber Records
		llRowCount = dw_Serial.RowCount()
		If llRowCount > 0 Then
			
			For llRowPos = 1 to llRowCOunt
				dw_Serial.SetITem(llRowPos,'po_no2',data)
			Next
				
			This.SetITem(row,'c_adjust_by_serial','Y') /* will suppress content level adjustment record to be set and will itemize by serial instead*/
			
		End If
			
	//Jxlim 01/21/2011 end of code for W&S po_no, po_no2								

	CASE 'COUNTRY_OF_ORIGIN'
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		lsCOO = f_get_Country_Name(data)
		If isNull(lsCOO) or lsCOO = '' Then
			MessageBox('Adjust', "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
		
		//This.SetITem(row,'c_Send_collab_ind','Y') /*allow collaboration msg to be sent (3COM)*/
		
	Case 'CONTAINER_ID' /* 01/03 - PCONKL - must be numeric so we increment if necessary */
		
		If Upper(gs_project) = 'PANDORA' Then
			//GailM 8/11/2020 S48701 F24564 Google - Prevent N/A on put away and stock adjustment and stock adjustment
			//Force po_no2 to 5 or more characters and do not allow anything less that 5 to be anything but NA
			ls_old_containerId = This.getItemString( row, 'container_id', primary!, true)
			If len(data) < 5 and data <> 'NA' Then
				Messagebox("Adjust","Container ID must be over 4 characters except the value NA.  Please re-enter.")
				This.setitem(row, 'container_id', ls_old_containerId)
				This.SetFocus()
				This.SelectText(1, Len(ls_old_containerId))
				Return 1
			End If
		End If
		
		//BCR 15-DEC-2011: Treat Bluecoat same as Pandora
		// if  gs_project = 'PANDORA' OR gs_project = 'BLUECOAT' then
		// ET3 2012-06-14: Implement generic test
		if g.ibSNchainofcustody then
		// 04/27/2010 ujh:  Check to see if Container ID is unique for this record set of 15 columns making up the primary key
		//		This does NOT simulate a unique column constraint, only unique primary key of 15 columns.
			lsProject_ID 			= GetItemString(row, 'Project_ID')
			lsSKU						= GetItemString(row, 'SKU')
			lsSupp_Code			= GetItemString(row, 'Supp_Code')
			llOwner_ID				= GetItemNumber(row, 'Owner_ID')
			lsCOO					= GetItemString(row, 'Country_of_Origin')
			lsWH_Code				= GetItemString(row, 'WH_Code')
			lsL_Code					= GetItemString(row, 'L_Code')
			lsInventory_Type 		= GetItemString(row, 'Inventory_Type')
			lsSerial_No				= GetItemString(row, 'Serial_No')
			lsLot_No					= GetItemString(row, 'Lot_No')
			lsRO_No					= GetItemString(row, 'RO_No')
			lsPO_No					= GetItemString(row, 'PO_No')
			lsPO_No2				= GetItemString(row, 'PO_No2')
			lsContainer_ID			= data
			ldtExpiration_Date		= GetItemDateTime(row, 'Expiration_Date')
			Select Count(*) into :llRowCount 
			From Content
				where Project_ID			= :lsProject_ID
				and  SKU			 			= :lsSKU
				and  Supp_Code			= :lsSupp_Code			
				and  Owner_ID				= :llOwner_ID
				and Country_of_Origin	= :lsCOO					
				and WH_Code				= :lsWH_Code	
				and L_Code					= :lsL_Code	
				and Inventory_Type		= :lsInventory_Type 	
				and Serial_No				= :lsSerial_No
				and Lot_NO					= :lsLot_No	
				and RO_No					= :lsRO_No	
				and PO_No					= :lsPO_No	
				and PO_NO2				= :lsPO_No2
				and Container_ID			= :lsContainer_ID	
				and Expiration_Date		= :ldtExpiration_Date	;
			if llRowCount > 0 Then
				Messagebox('Error','Container_ID is not Unique, Please choose another.')
				Return 1
			end if
			// 04/27/2010 ujh  END change
		else
		   //  05/17/2021    Dhirendra: Made changes for the Defect DE21438 for the Project SG-MUSER -Start
				If Not isnumber(data) and data <> '-'  and Upper(gs_project) <> 'SG-MUSER'   Then
					Messagebox('Adjust',"Container ID must be numeric!",StopSign!)
					Return 1
				End If
			End If	
				 //  05/17/2021    Dhirendra: Made changes for the Defect DE21438 for the Project SG-MUSER -END 
				 
		//We are only showing the Container DIMS if Container ID is not '-'
		This.PostEvent('ue_hide_unused')
		

	
	// ET3 - 2012-07-05 Pandora 447 - cleanup SN's by removing leading/trailing '.' and '-'
	CASE 'SERIAL_NO'
		BOOLEAN lb_SN_cleaned = FALSE
		LONG    ll_Rtn = 0
		
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
			
			IF lb_SN_cleaned THEN
				ll_Rtn = 2
				this.setitem( row, dwo.name, data )
			ELSE
				ll_Rtn = 0
			
			END IF
			
			RETURN ll_Rtn

		END IF  // Pandora
	
		
END CHOOSE		
end event

event itemerror;//If dwo.Name = "avail_qty" Then
	Return 1
//End If
end event

event doubleclicked;str_parms	lstrparms
Long	llRowPos, llRowCount

IF dwo.Name = 'cf_owner_name' THEN
	
		// if not performing an owner chg, get out
		If not rb_adjust_owner.Checked Then Return 

		//If splitting a row, the owner must be changed on the new row
		If This.GetITemString(row,'c_split_ind') = '1' Then /* 1 = orignal row, 2 = new row*/
			Messagebox("Adjust","You must change the Owner on the new row")
			Return 1
		End If
		
		open(w_select_owner)
		lstrparms = Message.PowerObjectParm
		
		If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
			
			cb_adjust_Reset.Enabled = True
			
			If Lstrparms.String_Arg[4] = 'Y' Then /*Update all row*/
			
				llRowCount = This.RowCount()
				For llRowPos = 1 to llRowCount
					this.SetItem(llRowPos,"owner_id",Lstrparms.Long_arg[1])
					This.SetItem(llRowPos,"owner_owner_cd",Lstrparms.String_arg[2])
					This.SetItem(llRowPos,"owner_owner_type",Lstrparms.String_arg[3])
					//TAM 07/04			
					This.SetITem(llRowPos,'c_Send_collab_ind','Y') /* write a adjustment to the batch
																				 transaction on a doubleclick  */
				next
			
			Else /*Current row Only */
				
				this.SetItem(row,"owner_id",Lstrparms.Long_arg[1])
				This.SetItem(row,"owner_owner_cd",Lstrparms.String_arg[2])
				This.SetItem(row,"owner_owner_type",Lstrparms.String_arg[3])
				//TAM 07/04			
				This.SetITem(row,'c_Send_collab_ind','Y') /* write an adjustment to the batch
																				 transaction on a doubleclick  */
			End If
	
		End If
END IF		



end event

event clicked;String	lsFilter

dw_content.setRowFocusIndicator( p_arrow )
ib_allow_content_select_row = true

ii_row =row
IF row > 0 THEN
	SetRow(row)
//	This.SelectRow(0, FALSE)
//	This.SelectRow(row, TRUE)
	If ibSplitOK Then
		cb_adjust_Split.Enabled = True
	End If
Else
	cb_adjust_Split.Enabled = False	
END IF

////JXLIM 05/12/2010 Protect the lot_no field for Comcast when lot_not is not '-'
//IF rb_adjust_other.Checked Then			
//		IF gs_project = 'COMCAST' THEN
//					IF This.GetITemString(row,'lot_no') <> '-' THEN				
//						This.Object.lot_no.Protect=1
//					ELSE
//						This.Object.lot_no.Protect=0
//					END IF
//		END IF
//END IF

// 04/14 - PCONKL - If chain of custody enabled, filter the serial number rows based on the row selected in the Content DW
//Filter based on original values so if a value is changed on the content DW, it doesnt re-filter (like changing Inv Type)

 IF g.ibSNchainofcustody and row > 0 THEN
	
//	lsFilter = "(Upper(supp_invoice_no) = '" + Upper(This.GetITemString(row,'receive_Master_supp_invoice_no')) + "' or isnull(supp_invoice_no))"
	lsFilter = " (Upper(ro_no) = '" + Upper(This.GetITemString(row,'ro_no',primary!,true)) + "' or isnull(ro_no)) "
	lsFilter += " and (Upper(l_code) = '" + Upper(This.GetITemString(row,'l_code',primary!,true)) + "' or isnull(l_code)) "
	lsFilter += " and (Upper(sku) = '" + Upper(This.GetITemString(row,'sku')) + "' or isnull(sku)) "
//	lsFilter += " and (Upper(inventory_type) = '" + Upper(This.GetITemString(row,'inventory_type',primary!,true)) + "' or isnull(inventory_type)) "
	lsFilter += " and (Upper(lot_no) = '" + Upper(This.GetITemString(row,'lot_no',primary!,true)) + "' or isnull(lot_no)) "
//	lsFilter += " and (Upper(po_no) = '" + Upper(This.GetITemString(row,'po_no',primary!,true)) + "' or isnull(po_no)) "
//MikeA 2019/11 According to Roy
//The serial number table should bring back serials for everything that is serial tracked at BOTH and Footprints tracked GPNS.
//	lsFilter += " and (Upper(po_no2) = '" + Upper(This.GetITemString(row,'po_no2',primary!,true)) + "' or isnull(po_no2)) "
//TAM 2018/02 S14383 need container Id as well
//MikeA 2019/11 According to Roy
//The serial number table should bring back serials for everything that is serial tracked at BOTH and Footprints tracked GPNS.
//	lsFilter += " and (Upper(carton_id) = '" + Upper(This.GetITemString(row,'container_id',primary!,true)) + "' or isnull(carton_id)) "
	lsFilter += " and String(exp_dt,'MMDDYYYY') = '" + String(This.GetITemDateTime(row,'expiration_date',primary!,true),'MMDDYYYY') + "'"
	dw_Serial.SetFilter(lsFilter)
	dw_Serial.Filter()
	
	//Dont allow Qty to be changed on COntent if Serials exist
	If dw_Serial.RowCount() > 0 Then
		
		dw_Content.Modify("Avail_Qty.Protect=1")
		
		//If Serials exist and it's a qty change, enable the add serial number button. Need to be able to split an existing row
		If rb_adjust_qty.checked or rb_serial_reconcile.checked Then
			cb_add_serial.Enabled = True
		Else
			cb_add_serial.Enabled = False
		End If
		st_retrieve_sn.text = ""
						
	Else

		//TAM - 2018/02 - If Chain of Custody and Sku is serial tracked then don't allow Qty to be changed on Content.(QTY will be handled on the Serial DW)
		If g.ibsnchainofcustody and is_serialized_ind = 'B' Then				
			dw_Content.Modify("Avail_Qty.Protect=1")	
		Else
			dw_Content.Modify("Avail_Qty.Protect=0")	
		End If
		st_retrieve_sn.text = "No serial numbers found for Row #" + string(row)
		cb_add_serial.Enabled = True
		cb_delete_serials.Enabled = False
		cb_swap_serial.Enabled = False //SEPT-2019 :MikeA S37369 - F17811 - Google - SIMS - Serial Number Go Forward Process
		
	End If
	
End If
end event

event constructor;call super::constructor;
setRowFocusIndicator( parent.p_arrow )

//If gs_project <> 'NORTEL' and gs_project <> '3COM_NASH' Then
//	This.Modify("cc_api_ind.width=0 c_send_collab_ind.width=0")
//End If


end event

event ue_postitemchanged;call super::ue_postitemchanged;Long	llRowCount, llRowPos

CHOOSE CASE Upper(dwo.Name)
		
	Case 'AVAIL_QTY'
		
		//If we did a qualitative adjustment for Inv Type or Owner and we are adjusting 2 rows without a split row,
		// it is going to look like 2 quantitative adjustments. On the row being incremented, we want to show which bucket was decremented
		// There should only be 1 of each (we are only allowint the qty to change on 2 rows)
		
		If rb_adjust_inv_type.Checked or rb_adjust_owner.Checked Then
			
			If This.Find("c_split_ind = '1' and c_split_ind = '2'",1,This.RowCount()) = 0 Then /*rows not split*/
			
				If This.GetITemNumber(Row,'avail_qty') > This.GetITemNumber(Row,'avail_qty',Primary!,True) Then /* New Qty > orig Qty*/
				
					//This is the row being incremented, find a row that was decremented to get inv type/owner
					For llRowPos = 1 to This.RowCount()
						
						If This.GetITemNumber(llRowPos,'avail_qty') < This.GetITemNumber(llRowPos,'avail_qty',Primary!,True) Then
							
							If rb_adjust_inv_Type.Checked Then
								This.SetItem(row,'c_parm',"OLD_INVENTORY_TYPE=" + This.GetITemString(lLRowPOs,'Inventory_type'))
							Else /*owner*/
								This.SetItem(row,'c_parm',"OLD_OWNER=" + String(This.GetITemNumber(lLRowPOs,'orig_owner_ID')))
							End If
							
							This.SetItem(llRowPos,'c_parm','SKIP') /* we don't want to create a transaction for the row that is being decremented (will be covered by the row being incremented)*/
							Exit
								
						End If
						
					Next
					
				ElseIf this.GetITemNumber(row,'avail_qty') < This.GetITemNumber(row,'avail_qty',Primary!,True) Then /* New Qty < orig Qty*/
					
					//This is the row that was decremented, find the row that was incremented
					For llRowPos = 1 to This.RowCount()
						
						If  This.GetITemNumber(llRowPos,'avail_qty') > This.GetITemNumber(llRowPos,'avail_qty',Primary!,True) Then
							
							If rb_adjust_inv_Type.Checked Then
								This.SetItem(llRowPos,'c_parm',"OLD_INVENTORY_TYPE=" + This.GetITemString(row,'Inventory_type'))
							Else
								This.SetItem(llRowPos,'c_parm',"OLD_OWNER="  + String(This.GetITemNumber(row,'orig_owner_ID')))
							End If
							
							Exit
							
						End If
						
					Next
					
					This.SetItem(row,'c_parm','SKIP') /* we don't want to create a transaction for the row that is being decremented (will be covered by the row being incremented)*/
					
				End If /*Qty chg*/
			
			End If /* No split row*/
			
			
		End If /*Qualitative chg*/
		
End Choose
end event

event sqlpreview;call super::sqlpreview;
//MessageBox ("sql", sqlsyntax )
end event

event retrieveend;call super::retrieveend;
dw_content.setRowFocusIndicator( p_empty )
ib_allow_content_select_row = false
end event

