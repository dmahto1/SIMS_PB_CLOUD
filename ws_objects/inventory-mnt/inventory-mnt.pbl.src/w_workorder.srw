$PBExportHeader$w_workorder.srw
$PBExportComments$*+ Maintain WorkOrders
forward
global type w_workorder from w_std_master_detail
end type
type dw_workorder_component_sku from u_dw_ancestor within tabpage_main
end type
type cb_component_sku_import from commandbutton within tabpage_main
end type
type cb_component_sku_delete from commandbutton within tabpage_main
end type
type cb_component_sku_add from commandbutton within tabpage_main
end type
type gb_component_sku from groupbox within tabpage_main
end type
type cb_create_detail from commandbutton within tabpage_main
end type
type cb_1 from commandbutton within tabpage_main
end type
type cb_void from commandbutton within tabpage_main
end type
type cb_confirm from commandbutton within tabpage_main
end type
type st_1 from statictext within tabpage_main
end type
type dw_report from u_dw_ancestor within tabpage_main
end type
type sle_order from singlelineedit within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type cb_clear from commandbutton within tabpage_search
end type
type cb_search from commandbutton within tabpage_search
end type
type dw_search_result from u_dw_ancestor within tabpage_search
end type
type dw_search from datawindow within tabpage_search
end type
type tabpage_instructions from userobject within tab_main
end type
type cb_maintain_instructions from commandbutton within tabpage_instructions
end type
type dw_instructions from u_dw_ancestor within tabpage_instructions
end type
type tabpage_instructions from userobject within tab_main
cb_maintain_instructions cb_maintain_instructions
dw_instructions dw_instructions
end type
type tabpage_detail from userobject within tab_main
end type
type cb_verify_bom from commandbutton within tabpage_detail
end type
type cb_delete_detail from commandbutton within tabpage_detail
end type
type cb_insert_detail from commandbutton within tabpage_detail
end type
type dw_detail from u_dw_ancestor within tabpage_detail
end type
type tabpage_detail from userobject within tab_main
cb_verify_bom cb_verify_bom
cb_delete_detail cb_delete_detail
cb_insert_detail cb_insert_detail
dw_detail dw_detail
end type
type tabpage_picking from userobject within tab_main
end type
type dw_pick_print from datawindow within tabpage_picking
end type
type cb_print_pick from commandbutton within tabpage_picking
end type
type dw_pickdetail from u_dw_ancestor within tabpage_picking
end type
type cb_pic_locs from commandbutton within tabpage_picking
end type
type cb_delete_pick from commandbutton within tabpage_picking
end type
type cb_insert_pick from commandbutton within tabpage_picking
end type
type cb_generate_pick from commandbutton within tabpage_picking
end type
type dw_picking from u_dw_ancestor within tabpage_picking
end type
type tabpage_picking from userobject within tab_main
dw_pick_print dw_pick_print
cb_print_pick cb_print_pick
dw_pickdetail dw_pickdetail
cb_pic_locs cb_pic_locs
cb_delete_pick cb_delete_pick
cb_insert_pick cb_insert_pick
cb_generate_pick cb_generate_pick
dw_picking dw_picking
end type
type tabpage_cto_process from userobject within tab_main
end type
type st_2 from statictext within tabpage_cto_process
end type
type mle_remarks from multilineedit within tabpage_cto_process
end type
type cb_3 from commandbutton within tabpage_cto_process
end type
type cb_selectall from commandbutton within tabpage_cto_process
end type
type st_message from statictext within tabpage_cto_process
end type
type cb_generate from commandbutton within tabpage_cto_process
end type
type dw_serial from u_dw_ancestor within tabpage_cto_process
end type
type cb_print from commandbutton within tabpage_cto_process
end type
type tabpage_cto_process from userobject within tab_main
st_2 st_2
mle_remarks mle_remarks
cb_3 cb_3
cb_selectall cb_selectall
st_message st_message
cb_generate cb_generate
dw_serial dw_serial
cb_print cb_print
end type
type tabpage_putaway from userobject within tab_main
end type
type dw_component_parent from u_dw_ancestor within tabpage_putaway
end type
type cb_scanunits from commandbutton within tabpage_putaway
end type
type cb_2 from commandbutton within tabpage_putaway
end type
type cb_confirm_putaway from commandbutton within tabpage_putaway
end type
type dw_putaway_content from u_dw_ancestor within tabpage_putaway
end type
type dw_putaway_print from datawindow within tabpage_putaway
end type
type cb_print_putaway from commandbutton within tabpage_putaway
end type
type cb_putaway_locs from commandbutton within tabpage_putaway
end type
type cb_delete_putaway from commandbutton within tabpage_putaway
end type
type cb_insert_putaway from commandbutton within tabpage_putaway
end type
type cb_generate_putaway from commandbutton within tabpage_putaway
end type
type dw_putaway from u_dw_ancestor within tabpage_putaway
end type
type tabpage_putaway from userobject within tab_main
dw_component_parent dw_component_parent
cb_scanunits cb_scanunits
cb_2 cb_2
cb_confirm_putaway cb_confirm_putaway
dw_putaway_content dw_putaway_content
dw_putaway_print dw_putaway_print
cb_print_putaway cb_print_putaway
cb_putaway_locs cb_putaway_locs
cb_delete_putaway cb_delete_putaway
cb_insert_putaway cb_insert_putaway
cb_generate_putaway cb_generate_putaway
dw_putaway dw_putaway
end type
end forward

global type w_workorder from w_std_master_detail
integer width = 4151
integer height = 2064
string title = "Work Order"
event ue_generate_pick ( )
event ue_print_pick ( )
event ue_generate_putaway ( )
event ue_print_putaway ( )
event ue_confirm ( )
event ue_void ( )
event ue_maintain_instructions ( )
event ue_generate_pick_server ( )
event ue_websphere_confirm ( )
event ue_generate_putaway_nycsp ( )
event type long ue_create_kit_change_detail ( )
event ue_generate_putaway_kit_change_add ( )
event ue_generate_putaway_kit_change_delete ( )
end type
global w_workorder w_workorder

type variables
Datawindow idw_main, idw_Detail, idw_instructions, idw_Pick, idw_Serial, & 
				idw_Putaway, idw_putaway_print, idw_search_result, idw_search, idw_pick_detail, idw_pick_Print, idw_putaway_Content, idw_component_parent//TAM 2014/05	
				
datastore ids_pick_detail	
				
Datastore	ids_Content, ids_Pick_alloc, ids_inv_type
n_warehouse i_nwarehouse
String	is_WONO, isColumn, isorigSearchSql, isOrigStatus
Window	iw_Window
SingleLineEdit	isle_Order
Datawindowchild  idwc_supplier_detail, idwc_supplier_Pick, idwc_supplier_Putaway
str_parms	istr_pick_short
Long	ilPickArrayPos, ilCompNumber
Boolean	ibConfirmRequested, ibPickShort, ib_ship_ind

inet	linit
u_nvo_websphere_post	iuoWebsphere

boolean ibSerialModified

string isCurrentSKU, isCurrentPackCartonId
long ilRetrieveRow, ilParentQty, ilUndoRow
boolean ibSkuScanned

u_nvo_carton_serial_scanning iuo_carton_serial_scanning


boolean ibmultiplesku

long ilParent_rowno, ilParent_maxrow, ilComponent_no
end variables

forward prototypes
public function integer wf_clear_screen ()
public function integer wf_putaway_content ()
public function integer wf_realloc_comp (long alrow, decimal aloldqty, decimal alnewqty)
public function integer wf_validation ()
public function integer wf_check_status ()
public function integer wf_update_content ()
public function integer wf_pick_row (long alpickrow)
public function integer wf_logitech_putaway ()
public function integer wf_verify_bom ()
public function integer wf_update_content_server ()
public function integer wf_create_comp_child (long alrow)
public function string uf_get_next_container_id (string asgroup)
public function integer wf_putaway_nycsp ()
public function integer uf_revert_pallet (string as_palletid)
public subroutine dodisplaymessage (string _title, string _message)
public function integer wf_component_sku_visible (boolean as_visible, string as_order_type)
public function string getronocompletedate (string asrono)
public function integer wf_reset_putaway ()
end prototypes

event ue_generate_pick();Long	llDetailCount,	llDetailPos, llPickCount, llPickPos, llNewPickRow,	llChildCount,	&
		llChildPos,	llFindRow, llArrayPos
		
decimal ldParentQty  //GAP 11/04 Decimal convertion 

String	lsSQL, lsModify, lsRC, lsSKU, lsSupplier,	lsChildSKU,	lsChildSupplier,	&
			lsCompInd, lsInvType, lsFind, lsCompType, lsWONO, lsWarehouse
str_parms	lstrparms

Integer	liRC

DatawindowChild	ldwc

u_ds	lds_item_component

////GAP 12/02 -  retrieving inventory types and shipping indicators. 
//IF IsValid(ids_inv_type) = FALSE THEN
//	ids_inv_type = Create datastore
//	ids_inv_type.Dataobject = 'd_inv_type'
//	ids_inv_type.SetTransObject(sqlca)
//	ids_inv_type.Retrieve(gs_project)
//	//ll_rtn = ids_inv_type.rowcount()
//end if 
//
lds_item_component = Create u_ds
lds_item_component.dataobject = 'd_item_component_parent'
lds_item_component.SetTransObject(SQLCA)

idw_detail.AcceptText()

If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Picking List!')
	return
End If	

//Must have Order Details first
If idw_Detail.RowCount() <= 0 Then
	Messagebox(is_title,'Please enter 1 or more Order Details first.')
	Return
End If

//Can not Generate Pick if Putaway Exists
If idw_putaway.RowCount() > 0 Then
	Messagebox(is_title, 'You can not generate the Pick List once you have created Putaway Records!',StopSign!)
	Return
End If

//Reset Pick allocation and shortage reporting
ids_pick_alloc.Reset()
ilPickArrayPos = 0
istr_pick_short = lstrparms /*reset array to null*/

	
//Sort order can be changed in Project Maintenance to any available fields on d_autoPick
If g.is_pick_sort_order > ' ' Then
	liRC = ids_pick_alloc.SetSort(g.is_pick_sort_order)
Else
	liRC = ids_pick_alloc.SetSort("Complete_Date A")
End If

// 09/03 - PONKL - 3 COM wants to pick by 3COM owned first. If we sort by Owner, 3COM will be lowest
If upper(gs_Project) = '3COM_NASH' Then
	liRC = ids_pick_alloc.SetSort("Owner_cd A, Complete_Date A, Priority A") /*3COM SHOULD SORT FIRST IN OWNER LIST*/
End If

If idw_pick.RowCount() > 0 Then 
	Choose Case MessageBox(is_title, "Delete existing records?", Question!, YesNo!,2)
		Case 2
			Return
		Case 1
			SetPointer(HourGlass!)
			idw_pick.SetRedraw(False)
			
			idw_pick.SetFilter('')
			idw_pick.Filter()

			llPickCount = idw_pick.RowCount()
			For llPickPos = llPickCount to 1 Step -1
				idw_pick.DeleteRow(llPickPos)
			Next
			ib_changed = True
			idw_pick.SetRedraw(True)
						
			This.TriggerEvent('ue_save') /*will re-allocate any picked stock*/
			
	End Choose
End If

//Genereate the Pick List for Each Component/Sub Component

//The first pass will build a pick row for each detail - splitting the highest level parent into it's children (which may also be components). 
//The rational is that we will not try and pick the highest level components from Inventory (that's why they are creating a workorder) but we
//attempt to allocate subcomponents from inventory if available. If not available, we will blow out to the individual children and allocate them from inventory.
//The second pass will try and allocate each part from inventory for both components and children

idw_pick.SetRedraw(False)
SetPointer(Hourglass!)

idwc_supplier_Pick.InsertRow(0)

idw_pick.GetChild('DELIVER_TO_LOCATION',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.InsertRow(0)

ibPickShort = False /*we won't allow a short pick to be saved */

lsWONO = idw_main.GetITemString(1,'wo_no')
lsWarehouse = idw_main.GetITemString(1,'wh_Code')

//First Pass - For Each Detail Row, split if component, otherwise build pick row
llDetailCount = idw_Detail.RowCount()
For llDEtailPos = 1 to llDetailCount
	
	lsSKU = idw_Detail.GetITemstring(llDetailPos,'sku')
	lsSupplier = idw_Detail.GetITemstring(llDetailPos,'supp_code')
		
	If idw_Detail.GetITemString(llDetailPos,'Component_Ind') = 'Y' or idw_main.GetITemString(1,'ord_type') = 'P' Then
		
		ldParentQty = idw_Detail.GetItemNumber(llDetailPos,"req_qty")
		
		/* 08/02 - PCONKL - default component type to 'C' (DW/DB Table also being used for Packaging*/
		// 02/06 - PCONKL, For Packaging Type Work Orders, we will retrieve component types of 'P' for packaging, otherwise we will retreive Component type (C)
		
		If idw_main.GetITemString(1,'ord_type') = 'P' Then /*packaging*/
			lsCompType = 'P'
		Else
			lsCompType = 'C'
		End If
		
		llChildCOunt = lds_item_component.Retrieve(gs_project,lssku,lsSupplier, lsCompType) 
		
		//02/06 - PCONKL - If this is a packaging WO, we want to include the parent SKU in the picklist
		If idw_main.GetITemString(1,'ord_type') = 'P' Then
			llChildCOunt = lds_item_component.InsertRow(0)
			lds_item_component.SetItem(llChildCount,"sku_child",idw_Detail.GetITemString(llDetailPos,'sku'))
			lds_item_component.SetItem(llChildCount,"supp_code_child",idw_Detail.GetITemString(llDetailPos,'supp_Code'))
		End If
		
		//Build a pick row for each of the children
		For llChildPos = 1 to llChildCount
			
			lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
			lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
						
			//We need the component ind for this child sku (It may also be a parent)
			Select Component_ind Into :lsCompInd
			From Item_master
			Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
			Using SQLCA;
			
			llNewPickRow = idw_Pick.InsertRow(0)
		
			idw_pick.SetItem(llNewPickRow,'wo_no',lsWONO)
			idw_pick.SetItem(llNewPickRow,'line_item_no',idw_Detail.GetITemNumber(llDetailPos,'line_item_no'))
			idw_pick.SetItem(llNewPickRow,'sku',lsChildSKU)
			idw_pick.SetItem(llNewPickRow,'sku_Parent',lsSKU)
			idw_pick.SetItem(llNewPickRow,'supp_code',lsChildSupplier)
			idw_pick.SetItem(llNewPickRow,'owner_id',idw_Detail.GetITemNumber(llDetailPos,'owner_id'))
			idw_pick.SetItem(llNewPickRow,'quantity',ldParentQty * (lds_item_component.GetItemNumber(llChildPos,"child_qty"))) /*extent parent qty by Child Unit QTY*/
			
			//Retrieve ItemMaster Values (component ind, serialized, lotized, etc.)
			i_nwarehouse.of_item_master(gs_project,lsChildSku,lsChildSupplier,idw_pick,llNewPickRow)
			
			//This original row being created will be deleted (we are combining pick rows and these rows will never be updated)
			idw_pick.SetItem(llNewPickRow,'deliver_to_location','XXXXXXXXXXX')
			
		Next /*Child*/
		
	Else /*Not a component, build a straight Pick Row*/
		
		llNewPickRow = idw_Pick.InsertRow(0)
		
		idw_pick.SetItem(llNewPickRow,'wo_no',idw_main.GetITemString(1,'wo_no'))
		idw_pick.SetItem(llNewPickRow,'line_item_no',idw_Detail.GetITemNumber(llDetailPos,'line_item_no'))
		idw_pick.SetItem(llNewPickRow,'sku',lsSKU)
		idw_pick.SetItem(llNewPickRow,'sku_Parent',lsSKU)
		idw_pick.SetItem(llNewPickRow,'supp_code',lsSupplier)
		idw_pick.SetItem(llNewPickRow,'owner_id',idw_Detail.GetITemNumber(llDetailPos,'owner_id'))
		idw_pick.SetItem(llNewPickRow,'quantity',idw_Detail.GetITemNumber(llDetailPos,'req_qty'))
		
		//Retrieve ItemMaster Values (component ind, serialized, lotized, etc.)
		i_nwarehouse.of_item_master(gs_project,lsSKU,lsSupplier,idw_pick,llNewPickRow)
		
		//This original row being created will be deleted (we are combining pick rows and these rows will never be updated)
		idw_pick.SetItem(llNewPickRow,'deliver_to_location','XXXXXXXXXXX')
				
	End If
	
Next /*Detail Row */

//Second Pass - allocate each row, if it can't be allocated in full, break out to child level if it is a component
llPickCount = idw_Pick.RowCount()
For llPickPos = 1 to llPickCount
	
	wf_pick_row(llPickPos) /*will allocate for each row and break out components if not pickable from FG Inventory*/
	
Next /*Pick Row */

//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_pick)
	
	
//delete the original rows marked with 'XXXXXXXXXXX'
lsFind = "deliver_to_location = 'XXXXXXXXXXX'"
llFindRow = idw_pick.Find(lsFind,1,idw_pick.RowCount())
Do While llFindRow > 0
	idw_pick.DEleteRow(llFindRow)
	llFindRow = idw_pick.Find(lsFind,1,idw_pick.RowCount())
Loop

idw_pick.Sort()
idw_pick.SetRedraw(True)
SetPointer(Arrow!)


ib_changed = True

//show any shortages - WE WON'T ALLOW A SHORT PICK TO BE SAVED - Must change Order Detail and regenerate!!
If ilPickArrayPos > 0 Then
	
	ibPickShort = True /*we won't allow a short pick to be saved */
	OpenWithParm(w_pick_exception,istr_pick_short)
	lstrparms = Message.PowerObjectParm
	
	//02/06 - PCONKL - For GM, We will allow them to reserve any short (but > 0) available qty for this WO
	If gs_project = 'GM_MI_DAT' and upperbound(lstrparms.String_Arg) > 0 Then
	
		//making the assumption that if we weren't able to pick all, then we can safely update all remaining pickable content for this sku
	
		Execute Immediate "Begin Transaction" using SQLCA; 
		
		For llArrayPos = 1 to upperbound(lstrparms.String_Arg)
			
			Update Content
			Set lot_no = :lsWONO
			Where Project_id = :gs_project and wh_code = :lsWarehouse and sku = :lstrparms.String_Arg[llArrayPos] and lot_no = '-' and
					Inventory_type in (select Inv_type from Inventory_Type where project_id = :gs_Project and workorder_pickable_ind = 'Y');
					
			If Sqlca.SqlCode <> 0 Then
				Execute Immediate "ROLLBACK" using SQLCA;
				messagebox(is_Title,"Unable to reserve inventory for WorkORder!~r~r" + Sqlca.Sqlerrtext)
				Exit
			End If
			
		Next
		
		Execute Immediate "COMMIT" using SQLCA;
		
	End If /*GM*/
	
End If /*Picked short*/

//Advise user if we have picked components (in case they want to pick the parts instead of the finished components)
If idw_pick.Find("component_ind = 'Y'",1,idw_pick.RowCount()) > 0 Then
	Messagebox(is_title,'One or more Picked Items (shown in bold) are~rcompleted Sub-Components in FG Inventory.~r~rIf you would rather pick these items from Raw Materials instead,~rDelete the rows or adjust the quantity and the required~rRaw Materials will be adjusted appropriately.')
End If


end event

event ue_print_pick();Long	llRowCount,	&
		llRowPos,	&
		llNewRow

String	lsSKU,	&
			lsSupplier,	&
			lsDescription
			
Decimal	ldLength, ldWidth, ldHeight
			

// *** 02/12 - TAM - Created NVO for custom Pick lists and removed non baseline code

u_nvo_custom_wo_picklists	luo_Pick
luo_Pick= Create u_nvo_custom_wo_picklists



//*** Override Baseline logic with any custom Picklist logic *****
 Choose Case Upper(gs_Project)
 
	
	Case 'RIVERBED'		//2011/12/08 - Added Riverbed.	
	
		luo_pick.uf_wo_pickprint_riverbed()
		return
	
End Choose
 
 //*** BASELINE PICK LOGIC ***//
 
 idw_pick_Print.Reset()

llRowCount = idw_pick.RowCount()

For llRowPos = 1 to llRowCount /*for each Pick Row */
	
	llNewRow = idw_pick_Print.InsertRow(0)
	
	//From Header
	idw_pick_print.SetITem(llNewRow,'Project_id',idw_main.GetITemString(1,'project_id'))
	idw_pick_print.SetITem(llNewRow,'workorder_nbr',idw_main.GetITemString(1,'workorder_number'))
	idw_pick_print.SetITem(llNewRow,'ord_date',idw_main.GetITemDateTime(1,'ord_date'))
	idw_pick_print.SetITem(llNewRow,'sched_Date',idw_main.GetITemDateTime(1,'sched_date'))
	idw_pick_print.SetITem(llNewRow,'remark',idw_main.GetITemString(1,'remarks'))
	idw_pick_print.SetITem(llNewRow,'wh_code',idw_main.GetITemString(1,'wh_code'))
	idw_pick_print.SetITem(llNewRow,'delivery_order_nbr',idw_main.GetITemString(1,'delivery_invoice_no'))
	
	//From Picking
	idw_pick_print.SetITem(llNewRow,'SKU',idw_pick.GetITemString(llRowPos,'SKU'))
	idw_pick_print.SetITem(llNewRow,'supp_code',idw_pick.GetITemString(llRowPos,'supp_code'))
	idw_pick_print.SetITem(llNewRow,'l_code',idw_pick.GetITemString(llRowPos,'l_code'))
	idw_pick_print.SetITem(llNewRow,'deliver_to_location',idw_pick.GetITemString(llRowPos,'deliver_to_location'))
	idw_pick_print.SetITem(llNewRow,'lot_no',idw_pick.GetITemString(llRowPos,'lot_no'))
	idw_pick_print.SetITem(llNewRow,'serial_no',idw_pick.GetITemString(llRowPos,'serial_No'))
	idw_pick_print.SetITem(llNewRow,'po_no',idw_pick.GetITemString(llRowPos,'po_no'))
	idw_pick_print.SetITem(llNewRow,'po_no2',idw_pick.GetITemString(llRowPos,'po_no2'))
	idw_pick_print.SetITem(llNewRow,'container_id',idw_pick.GetITemString(llRowPos,'container_id'))			//GAP 11-02
	idw_pick_print.SetITem(llNewRow,'expiration_date',idw_pick.GetITemdatetime(llRowPos,'expiration_date'))	//GAP 11-02
	idw_pick_print.SetITem(llNewRow,'inventory_Type',idw_pick.GetITemString(llRowPos,'inventory_Type'))
	idw_pick_print.SetITem(llNewRow,'coo',idw_pick.GetITemString(llRowPos,'Country_of_Origin'))
	idw_pick_print.SetITem(llNewRow,'quantity',idw_pick.GetITemNumber(llRowPos,'quantity'))
	
	//need description and dimensions (for GM) from ITem Master
	lsSku = idw_pick.GetITemString(llRowPos,'SKU')
	lsSupplier = idw_pick.GetITemString(llRowPos,'Supp_code')
	
	Select Description, length_1, width_1, height_1 
	Into	:lsDescription, :ldLength, :ldWidth, :ldHeight
	From ITem_MAster
	Where Project_id = :gs_project and sku = :lsSKU and supp_code = :lsSupplier;
	
	
	If isnull(ldLength) then ldLength = 0
	If isnull(ldWidth) then ldWidth = 0
	If isnull(ldHeight) then ldHeight = 0
	
	idw_pick_print.SetITem(llNewRow,'description',lsDescription)
	
	If ldLength = 0 and ldWidth = 0 and ldHeight = 0 Then
	Else
		idw_pick_print.SetITem(llNewRow,'dimensions', String(ldLength,"####0.##") + " x " +  String(ldWidth,"####0.##") + " x " +  String(ldHeight,"####0.##"))
	End If

	
Next /*Pick Row */

idw_pick_Print.Sort()
idw_pick_print.GroupCalc()

OpenWithParm(w_dw_print_options,idw_pick_print) 
end event

event ue_generate_putaway();//generate the FG putaway of finished components

Long	llRowPos,		&
		llRowCount,		&
		llOwnerID,		&
		llLineItem,	&
		llNewRow,		&
		llSubLine,		&
		llFindRow,		&
		llfindPickRow,	&
		llDiebold100Owner
		
decimal ldReqQty //GAP 11/02 convert to decimal 
String	lsSKU,		&
			lsSupplier,	&
			lsCOO,		&
			lsOwnerName,	&
			lsSerial,		&
			lsLot,			&
			lsPO,				&
			lsPO2,			&
			lsComp,			&
			lsLoc,			&
			lsWarehouse,	&
			lsInvType,		&
			lsOrder,		&
			lsContainer, &
			lsUF1,	 		&
			lsGroup, lsExpiration //GAP 11/02 added container and expirtaion indicators 
			
If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Putaway List!')
	return
End If			
			
//Cant generate Putaway until after Pick List generated
If idw_Pick.RowCount() <= 0 Then
	MessageBox(is_title,'You must generate the Pick List before generating the Putaway List!')	
	Return
End If /*No Pick list */

ib_changed = True

SetPointer(Hourglass!)
idw_putaway.SetRedraw(False)

//08/08 - PCONKL - FOr Diebold, we are putting everything away as Company 100 (OWner)
If gs_project = 'DIEBOLD' Then
	
	Select Owner_id into :llDiebold100Owner
	From Owner
	Where Project_id = 'DIEBOLD' and Owner_cd = '100' and owner_type = 'C';
	
End If

idwc_supplier_Putaway.InsertRow(0)
			
llRowCount = idw_Detail.RowCount()
			
For llRowPos = 1 to llRowCount /*For each Detail Record*/
	
	w_main.SetMicrohelp('generating Putaway for Detail Line: ' + String(llRowPos) + ' of ' + String(llRowCount))
	
	lsOrder = idw_main.GetITemString(1,'wo_no')
	lssku = idw_detail.GetItemString(llRowPos,"sku")
	llOwnerID = idw_detail.GetItemNumber(llRowPos,"owner_id")
	lsOwnername = idw_detail.GetItemString(llRowPos,"cf_owner_name")
	lsSupplier = idw_detail.getITemString(llRowPos,"supp_code")
	llLineItem = idw_detail.GetItemNumber(llRowPos,"line_item_no")
	
	if isnull(idw_detail.GetItemNumber(llRowPos,"alloc_qty")) Then idw_Detail.SetItem(llRowPos,'alloc_Qty',0)

	ldReqQty = idw_detail.GetItemNumber(llRowPos,"req_qty") - idw_detail.GetItemNumber(llRowPos,"alloc_qty")
	
	If ldReqQty < 0 Then Continue
	
	//Retrieve serial, lot, PO, Container & Expiration tracking indicators
	Select SerialIzed_Ind, Lot_Controlled_IND, PO_Controlled_Ind, PO_NO2_Controlled_Ind, Container_Tracking_Ind, 
			Expiration_Controlled_Ind, Component_Ind, country_of_origin_default, User_Field1
	Into	:lsSerial, :lsLot, :lsPO, :lsPO2,:lsContainer,:lsExpiration, :lsComp, :lsCOO, :lsUF1
	From Item_Master
	Where Project_id = :gs_project and SKU = :lsSKU and supp_code = :lsSupplier;
	
	//Get default Putaway Location based on Item, owner and Inv Type	
	//lsLoc = i_nwarehouse.of_assignlocation(lssku,lsSUpplier, lswarehouse, lsInvType,llOwnerID, ldReqQty)
	
	llNewRow = idw_putaway.InsertRow(0)
	
	idw_putaway.setitem(llNewRow,'wo_no', lsorder)
	idw_putaway.SetItem(llNewRow,"sku", lssku)	
	idw_putaway.SetItem(llNewRow,"sku_parent", lssku)	
	idw_putaway.SetItem(llNewRow,"supp_code", lsSupplier)
	idw_putaway.SetItem(llNewRow,"owner_id", llOwnerID)	
	idw_putaway.SetItem(llNewRow,"line_item_no", llLineItem)	
	idw_putaway.SetItem(llNewRow,"cf_owner_name", lsOwnername)	
	idw_putaway.SetItem(llNewRow,"inventory_type", lsInvtype)	
	idw_putaway.SetItem(llNewRow,"serialized_ind", lsSerial)	
	idw_putaway.SetItem(llNewRow,"lot_controlled_ind", lsLot)
	idw_putaway.SetItem(llNewRow,"po_controlled_ind", lsPO)
	idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind", lsPO2)
	idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind", lsContainer)  	//GAP 11-02
	idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind", lsExpiration) 	//GAP 11-02
	idw_putaway.SetItem(llNewRow,"component_ind", lsComp)
	idw_putaway.SetItem(llNewRow,"country_of_origin", lsCOO)
	idw_putaway.SetItem(llNewRow,"quantity", ldReqQty) 
	idw_putaway.SetItem(llNewRow,"l_code", lsloc)	
	idw_putaway.setitem(llNewRow,'component_no',0)
	idw_putaway.SetItem(llNewRow,"expiration_date",date(2999,12,31))				//Arun 11OCT2012 to avoid hard coded date on dw's column specification.
	
	
	//TAM 2009/05/20 For BlueCoat, User_field1 from Item Master = PONO(revision) 
	If gs_project = 'BLUECOAT' Then
		idw_putaway.SetItem(llNewRow,"po_no", lsUF1)
	//TAM 2009/05/12 For BlueCoat, get the PONO2 from the picking row if PONO2 is Tracked 
		llfindPickRow = idw_pick.Find("Upper(SKU_Parent) = '" + Upper(lsSKU) + "' and upper(po_no2_controlled_ind) = 'Y'",1,idw_pick.RowCount())
		If llfindPickRow > 0 Then	idw_putaway.SetItem(llNewRow,"po_no2", idw_pick.GetItemString(llfindPickRow,"Po_No2"))
	End If

	//TAM 2011/12/08 For Riverbed, PONO = Delivery_invoice_number or "GENERIC" if blank 
	If gs_project = 'RIVERBED' Then
		If  idw_main.GetITemString(1,'delivery_invoice_no') > '' then
			idw_putaway.SetItem(llNewRow,"po_no", idw_main.GetITemString(1,'delivery_invoice_no'))
		else
			idw_putaway.SetItem(llNewRow,"po_no",'GENERIC')
		End If
	End If

	// 07/04 - PCONKL - Set Unique Line number
	llSubLine = llNewRow
	//If Subline Already Exists, bump until not
	llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
	Do While llFindRow > 0
		llSubLine ++
		llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
	Loop

	idw_putaway.SetItem(llNewRow,"sub_line_item_no", llSubLine)	 
	
	// 08/08 - PCONKL - Set Lot (SO) and po_no (SO Line) for Diebold
	//							Time Permitting, we will replace with values from EDI_Inbound_Detail
	If gs_project = 'DIEBOLD' Then
		idw_Putaway.SetITem(llNewRow,'Lot_No',idw_main.GetITemString(1,'workorder_Number'))
		idw_Putaway.SetItem(llNewRow,'po_no',idw_detail.GetItemString(llRowPos,"user_field1"))
		idw_putaway.SetItem(llNewRow,"owner_id", llDiebold100Owner) /*defaulting to Company 100 Owner */
		idw_Putaway.SetITem(llNewRow,'inventory_type','N') /*Default to Normal*/
	//	idw_putaway.SetItem(llNewRow,"quantity", idw_detail.GetItemNumber(llRowPos,"req_qty"))
	End If

// TAM 10/07/2010  For NYCSP we need to calculate the container ID
	If gs_project = 'NYCSP' Then
		// If Tracking by Container ID, set to Next
		If lsContainer = 'Y' Then
			idw_Putaway.SetITem(llNewRow,'container_id',uf_get_next_container_ID('')) /* 04/01 - PCONKL - moved to function to support project specific requirements*/
		End If /*Container Tracked */
	End If

		// 2010/09 TAM - If this Item is a Component, Insert Rows for child Items (For NYCSP but could be for everyone)
	If gs_project = 'NYCSP' Then
		If idw_putaway.GetItemString(llNewRow,"component_ind") = 'Y' Then
			ilCompNumber =  g.of_next_db_seq(gs_project,'Content','Component_no')
			idw_putaway.setitem(llNewrow,'component_no', ilCompnumber)
			wf_create_comp_child(llNewrow)
		Else /* not a component*/
			idw_putaway.setitem(llNewrow,'component_no',0)
		End If /*component*/
	End If	
	
Next /*Next Detail Row*/

// 07/04 - PCONKL - For Logitech, we need to copy Lot, PO and Exp Date from Picking to Putaway and make sure the qty's match
If Upper(gs_project) = 'LOGITECH' Then
	wf_logitech_putaway()
End If



SetPointer(Arrow!)
idw_putaway.SetRedraw(True)

//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_putaway)

end event

event ue_print_putaway();
// This event prints the PutawayList which is currently visible on the screen 
// and not from the database

Long ll_rowcnt, ll_row, i
decimal ld_quantity //GAP 11-02 decimal convertion
DateTime  ld_date
String ls_sku, ls_serial, ls_lotno, ls_whcode, ls_inv_type
String ls_location, ls_order,ls_customer
String ls_lob_code, ls_grp_code, ls_lob, ls_grp
String ls_description, ls_remark, ls_po,lsSupplier
boolean bDone
Datawindowchild ldwc_type

//idw_putaway_print.GetChild("inventory_type", ldwc_type)
//ldwc_type.SetTransObject(sqlca)
//ldwc_type.Retrieve(gs_project)
//If idw_putaway.AcceptText() = -1 Then Return
bDone = false
idw_putaway_print.Reset()
// idw_putaway.Sort()

ll_rowcnt = idw_putaway.RowCount()

If ll_rowcnt = 0 Then
   MessageBox("Putaway"," No Putaway list records to print!")
	Return
End if

ls_order = idw_main.getitemstring(1,"workorder_number")
//
//ld_date = idw_main.getitemdatetime(1,"ord_date")
ld_date = idw_main.getitemdatetime(1,"ord_date") /* 05/00 PCONKL - use receive date*/
ls_whcode = idw_main.getitemstring(1,"wh_code")
ls_remark = idw_main.getitemstring(1,"remarks")

SetPointer(Hourglass!)
w_main.SetMicrohelp('Preparing Putaway list for Printing...')
  
For i = 1 to ll_rowcnt
	
	//If this row has already been confiremd, don't print again
	If idw_putaway.GetITemString(i,'User_field2') > ' ' Then 
		MessageBox("Putaway", "This has already been printed")
		bDone = true
		Continue
	end if 
	
	ls_sku = idw_putaway.getitemstring(i,"sku")
	lsSupplier = idw_putaway.getitemstring(i,"supp_code")
	ls_serial = idw_putaway.getitemstring(i,"serial_no")
	ls_po = idw_putaway.getitemstring(i,"po_no")
   ls_lotno = idw_putaway.getitemstring(i,"lot_no")
	ls_location = idw_putaway.getitemstring(i,"l_code")
	ls_inv_type = idw_putaway.getitemstring(i,"inventory_type")
	ld_quantity = idw_putaway.getitemnumber(i,"quantity")
	ll_row = idw_putaway_print.InsertRow(0)
	idw_putaway_print.setitem(ll_row,"ro_no",ls_order)
	idw_putaway_print.setitem(ll_row,"project_id",gs_project) 
//	idw_putaway_print.setitem(ll_row,"ord_date",ld_date)
	idw_putaway_print.setitem(ll_row,"remark",ls_remark)
	idw_putaway_print.setitem(ll_row,"inventory_type",ls_inv_type)
	idw_putaway_print.setitem(ll_row,"wh_code",ls_whcode)
	idw_putaway_print.setitem(ll_row,"sku",ls_sku)
	idw_putaway_print.setitem(ll_row,"supp_code",lsSupplier)
	idw_putaway_print.setitem(ll_row,"sku_parent",idw_putaway.getitemstring(i,"sku")) 
	idw_putaway_print.setitem(ll_row,"serial_no",ls_serial)
	idw_putaway_print.setitem(ll_row,"po_no",ls_po)
	idw_putaway_print.setitem(ll_row,"po_no2",idw_putaway.getitemstring(i,"po_no2")) 
		idw_putaway_print.setitem(ll_row,"container_ID",idw_putaway.getitemstring(i,"container_ID")) 			//gap 11-02
		idw_putaway_print.setitem(ll_row,"expiration_date",idw_putaway.getitemdatetime(i,"expiration_date")) 	//gap 11-02
	idw_putaway_print.setitem(ll_row,"lot_no",ls_lotno)
	idw_putaway_print.setitem(ll_row,"l_code",ls_location)
	idw_putaway_print.setitem(ll_row,"quantity",ld_quantity)
	idw_putaway_print.setitem(ll_row,"component_ind","N")
	idw_putaway_print.setitem(ll_row,"component_no",0) 
	
Next

idw_putaway_print.Sort()
idw_putaway_print.GroupCalc()

SetPointer(Arrow!)
w_main.SetMicrohelp('Ready')

If idw_putaway_print.RowCount() = 0 and not bDone Then
   MessageBox("Putaway"," No Putaway list records to print!")
	Return
Else
	if idw_putaway_print.RowCount() = 0 then
		return
	else 
		bDone = false
	end if 
end if

Openwithparm(w_dw_print_options,idw_putaway_print) 

end event

event ue_confirm();integer li_return, liMsg
long ll_totalrows,i, ll_new, llFindRow,	llRowPos, llRowCOunt, llTotalrcvQty
String	lsRONO, lsFind, lsOrder, lsSKU, lsWONO
DateTIme	ldtToday
Boolean	lbCreateBackorder
//u_nvo_edi_confirmations	lu_edi_confirm

Str_parms	lStrparms

ldtToday = DateTIme(today(),Now())

If idw_detail.rowcount() <= 0 then
	messagebox(is_title,'Please input 1 or more order detail lines first.')
	return
end if

If idw_Pick.rowcount() <= 0 then
	messagebox(is_title,'Please complete Pick List first.')
	return
end if

If idw_putaway.rowcount() <= 0 then 
	messagebox(is_title,'Please complete the Putaway List first.')
	return
end if

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return 
End If

If idw_detail.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_detail.SetFocus()
	Return 
End If

If idw_Pick.AcceptText() = -1 Then 
	tab_main.SelectTab(4) 
	idw_Pick.SetFocus()
	Return 
End If

If idw_putaway.AcceptText() = -1 Then
	tab_main.SelectTab(5) 
	idw_putaway.SetFocus()
	Return 
End If

//We will only be validating Putaway locations on confirmation. This will allow a putawaylist
//to be printed without locations
ibConfirmRequested = True 

If ib_changed Then
	messagebox(is_title,'Please save changes first!',StopSign!)
	return
End If

if messagebox(is_title,'Are you sure you want to confirm this Work Order?',Question!,YesNo!,2) = 2 then
	return
End if

Setpointer(Hourglass!) 


lsOrder = idw_main.getitemstring(1,'workorder_number')
lsWONO = idw_main.getitemstring(1,'wo_no')

If IsNull(idw_main.GetItemDateTime(1, 'complete_date')) Then
	idw_main.setitem(1,'complete_date',today())
End If

idw_main.setitem(1,'ord_status','C')

If This.Trigger Event ue_save() = 0 Then
	
	
	// 09/08 - PCONKL - We may be posting a transaction to Websphere as well (i.e. Diebold)
	This.TriggerEvent("ue_websphere_Confirm")

	w_main.SetMicrohelp("Record Confirmed!")
	Messagebox(is_title,'Order Confirmed!')	
Else
	w_main.SetMicrohelp("Record Confirm Failed!")
	idw_main.setitem(1,'ord_status','P') 
	idw_putaway_Content.Reset() 
	idw_component_parent.Reset() 
	Return
End If

// 09/03 - PCONKL - we may need to send some sort of transaction when the workorder is confirmed
//lu_edi_confirm = Create u_nvo_edi_confirmations
//lu_edi_confirm.uf_workOrder_confirmation(idw_main, idw_detail,idw_pick)

// 04/04 - PCONKL - Now writing transactions from Sweeper - create a transaction record for this orde ID
Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		Values(:gs_Project, 'WO', :lsWONO,'N', :ldtToday, '');
Execute Immediate "COMMIT" using SQLCA;


//If Delivery Invoice Number is present, see if the user wants to open that order
//11/03 - PCONKL - Changed to use do_no to maintain 1 to 1 relationship between WO and DO
If idw_main.GetITemString(1,'do_no') > ' ' and idw_main.GetITemString(1, 'ord_type') <> 'P' Then /* Packaging WO's attach to Receiving Orders*/
	If Messagebox(is_Title, 'This Work Order was created to fill Delivery Order ' + idw_main.GetITemString(1,'DElivery_invoice_no') + '~r~rWould you like to open this order now?',Question!,YesNo!,1) = 1 Then
		Lstrparms.String_arg[1] = "W_DOR"
		Lstrparms.String_arg[2] = "*DONO*" + idw_main.GetITemString(1,'do_no') /* prefix with *DONO* to open by do_no instead of order # */
		OpenSheetwithparm(w_do,lStrparms, w_main, gi_menu_pos, Original!)
	End If
End If /*DO present*/	

Setpointer(Arrow!) 
end event

event ue_void();
if messagebox(is_title,'Are you sure you want to void this order?',Question!,YesNo!,2) = 2 then
	return
End if

isOrigStatus = idw_main.GetItemString(1,'ord_status')
idw_main.setitem(1,'ord_status','V')

If This.Trigger Event ue_save() = 0 Then
	MessageBox(is_title, "Record voided!")
Else
	MessageBox(is_title, "Record void failed!")
End If



end event

event ue_maintain_instructions;Str_Parms	lstrparms

Lstrparms.String_Arg[1] = idw_main.GetItemString(1,'wo_no')
OpenWithParm(w_workorder_text,lstrparms)

Lstrparms = Message.PowerObjectParm

//Refresh Instructions
If Not lstrparms.Cancelled Then
	idw_instructions.Retrieve(gs_project,idw_main.GetItemString(1,'wo_no'))
End If

end event

event ue_generate_pick_server();
// 08/08 - PCONKL - generating Pick Lists on Websphere now

String	lsXML, lsXMLREsponse, lsReturnCode, lsReturnDesc
Long	llPickCount, llPickPos, llIdx
DatawindowChild	ldwc
str_parms	lstrparms

idw_detail.AcceptText()

If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Picking List!')
	return
End If	

//Must have Order Details first
If idw_Detail.RowCount() <= 0 Then
	Messagebox(is_title,'Please enter 1 or more Order Details first.')
	Return
End If

//Can not Generate Pick if Putaway Exists
If idw_putaway.RowCount() > 0 Then
	Messagebox(is_title, 'You can not generate the Pick List once you have created Putaway Records!',StopSign!)
	Return
End If

If idw_pick.RowCount() > 0 Then 
	Choose Case MessageBox(is_title, "Delete existing records?", Question!, YesNo!,2)
		Case 2
			Return
		Case 1
			SetPointer(HourGlass!)
			idw_pick.SetRedraw(False)
			
			idw_pick.SetFilter('')
			idw_pick.Filter()

			llPickCount = idw_pick.RowCount()
			For llPickPos = llPickCount to 1 Step -1
				idw_pick.DeleteRow(llPickPos)
			Next
			ib_changed = True
			idw_pick.SetRedraw(True)
						
			This.TriggerEvent('ue_save') /*will re-allocate any picked stock*/
			
	End Choose
End If

idwc_supplier_Pick.InsertRow(0)

idw_pick.GetChild('DELIVER_TO_LOCATION',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.InsertRow(0)


iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("WOPickRequest", "ProjectID='" + gs_Project + "'")
lsXML += 	'<WONO>' + idw_main.GetITemstring(1,'wo_no') +  '</WONO>' 
lsXML = iuoWebsphere.uf_request_footer(lsXML)

//Messagebox("",lsXML)

w_main.setMicroHelp("Generating Pick List on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

//messageBox("",lsXMLResponse)

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
If pos(Upper(lsXMLResponse),"WOPICKRECORD") > 0 Then
	idw_Pick.modify("datawindow.import.xml.usetemplate='wopickresponse'")
	idw_Pick.ImportString(xml!,lsXMLResponse)
	ib_changed = True
Else
	messageBox(is_title, 'No pick rows were generated')
End If

IF idw_main.GetItemString(1,'ord_type') = 'D' THEN
	
	//On a delete, only use the parent and skus being deleted. 
	//Mimic that add. 
	
	string lsSku
	long llFindRow
	
	For llIdx = idw_Pick.RowCount() to 1 step -1
	
		lsSku = idw_Pick.GetItemString( llIdx, "sku")
	
		IF lsSku = idw_main.GetItemString(1,'user_field1') THEN continue;
	
		llFindRow = tab_main.tabpage_main.dw_workorder_component_sku.Find("component_sku = '" +lsSku+"'",1,tab_main.tabpage_main.dw_workorder_component_sku.RowCount())

		IF llFindRow > 0 THEN Continue;

		idw_Pick.DeleteRow(llIdx)
	
	Next
	
END IF


idw_pick.SetRedraw(True)

//Notify users of shortages...
If pos(lsXMLResponse,'DOPickShort') > 0 Then
	
	//We need to tweak the XML to match what is being passed in a Delivery Order sinvce we're using the same exception window
	Do While Pos(lsXmlResponse,'WOPick') > 0
		lsXMLResponse = Replace(lsXMLResponse,Pos(lsXMLResponse,'WOPick'),6,'DOPick')
	Loop
	
	ibPickShort = True /*we won't allow a short pick to be saved */
	lstrparms.String_arg[1] = lsXMLResponse
	OpenWithParm(w_pick_exception,lstrparms)
End If


//Advise user if we have picked components (in case they want to pick the parts instead of the finished components)
If idw_pick.Find("component_ind = 'Y'",1,idw_pick.RowCount()) > 0 Then
	Messagebox(is_title,'One or more Picked Items (shown in bold) are~rcompleted Sub-Components in FG Inventory.~r~rIf you would rather pick these items from Raw Materials instead,~rDelete the rows or adjust the quantity and the required~rRaw Materials will be adjusted appropriately.')
End If


// 11/02 - PCOnkl - Hide or show lot, po, etc. if necessary
i_nwarehouse.of_hide_unused(idw_pick)

// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Use populate the Deliver_To with the L_CODE(Put away in the same place)
llPickCount = idw_pick.RowCount()
For llPickPos = 1 to llPickCount
	idw_pick.SetItem(llPickPos,'deliver_to_location',idw_pick.GetItemString(llPickPos,'l_code'))
Next

w_main.setMicroHelp("Ready")
end event

event ue_websphere_confirm();
String	lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc


//09/08 - PCONKL - Only doing for Diebold right now
If gs_Project <> 'DIEBOLD' Then Return

iuoWebsphere = CREATE u_nvo_websphere_post
linit = Create Inet
lsXML = iuoWebsphere.uf_request_header("WOConfirmationRequest", "ProjectID='" + gs_Project + "' wono='" + idw_main.GetITemstring(1,'wo_no') + "'")
lsXML = iuoWebsphere.uf_request_footer(lsXML)

//Messagebox("",lsXML)

w_main.setMicroHelp("Posting WO Confirmation on Application server...")

lsXMLResponse = iuoWebsphere.uf_post_url(lsXML)

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
		
		Messagebox("Websphere Operational Exception Error","Unable to post WO Confirmation to Websphere: ~r~r" + lsReturnDesc,StopSign!)
		Return 
	
	Case Else
		
		If lsReturnDesc > '' Then
			Messagebox("",lsReturnDesc)
		End If
			
End Choose

////
end event

event ue_generate_putaway_nycsp();//generate the FG putaway of finished components
Long 	 llPickDetailPos, llPickDetailCount	//S47693

Long	llRowPos, llRowQty,		&
		llRowCount,		&
		llOwnerID,		&
		llLineItem,	&
		llNewRow,		&
		llSubLine,		&
		llFindRow,		&
		llfindPickRow,	&
		llDiebold100Owner
		
decimal ldReqQty //GAP 11/02 convert to decimal 
String	lsSKU,		&
			lsSupplier,	&
			lsCOO,		&
			lsOwnerName,	&
			lsSerial,		&
			lsLot,			&
			lsPO,				&
			lsPO2,			&
			lsComp,			&
			lsLoc,			&
			lsWarehouse,	&
			lsInvType,		&
			lsContainer, &
			lsUF1,			&
			lsGroup, lsExpiration //GAP 11/02 added container and expirtaion indicators 
			
If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Putaway List!')
	return
End If			
			
//Cant generate Putaway until after Pick List generated
If idw_Pick.RowCount() <= 0 Then
	MessageBox(is_title,'You must generate the Pick List before generating the Putaway List!')	
	Return
End If /*No Pick list */

ib_changed = True

SetPointer(Hourglass!)
idw_putaway.SetRedraw(False)

idwc_supplier_Putaway.InsertRow(0)
			
llRowCount = idw_Detail.RowCount()
			
For llRowPos = 1 to llRowCount /*For each Detail Record*/
	
	w_main.SetMicrohelp('generating Putaway for Detail Line: ' + String(llRowPos) + ' of ' + String(llRowCount))

	is_WONO = idw_main.GetITemString(1,'wo_no')
	lssku = idw_detail.GetItemString(llRowPos,"sku")
	llOwnerID = idw_detail.GetItemNumber(llRowPos,"owner_id")
	lsOwnername = idw_detail.GetItemString(llRowPos,"cf_owner_name")
	lsSupplier = idw_detail.getITemString(llRowPos,"supp_code")
	llLineItem = idw_detail.GetItemNumber(llRowPos,"line_item_no")
	lsInvType = 'N' //TAM 2012/08/01  Default Inventory Type
		
	if isnull(idw_detail.GetItemNumber(llRowPos,"alloc_qty")) Then idw_Detail.SetItem(llRowPos,'alloc_Qty',0)
	
	long llre, llal
	llre = idw_detail.GetItemNumber(llRowPos,"req_qty")
	llal =  idw_detail.GetItemNumber(llRowPos,"alloc_qty")

	ldReqQty = idw_detail.GetItemNumber(llRowPos,"req_qty") - idw_detail.GetItemNumber(llRowPos,"alloc_qty")
	
	If ldReqQty < 0 Then Continue
	
	//Retrieve serial, lot, PO, Container & Expiration tracking indicators
	Select SerialIzed_Ind, Lot_Controlled_IND, PO_Controlled_Ind, PO_NO2_Controlled_Ind,Container_Tracking_Ind, 
			Expiration_Controlled_Ind, Component_Ind, country_of_origin_default, User_Field1
	Into	:lsSerial, :lsLot, :lsPO, :lsPO2,:lsContainer,:lsExpiration, :lsComp, :lsCOO, :lsUF1
	From Item_Master
	Where Project_id = :gs_project and SKU = :lsSKU and supp_code = :lsSupplier;

	//GailM 7/10/2020 S47693 F20484 I2896 KNY - NYCSP: Use RO_NO Date vs. WO_NO Date When Creating WOs
	For llRowQty = 1 to ldReqQty /*QTY 1 in Putaway Row For each Detail QTY*/  //Replace this loop with idw_pick_detail loop
	//For llPickDetailPos = 1 to llPickDetailCount
	
	//Get default Putaway Location based on Item, owner and Inv Type	
	//lsLoc = i_nwarehouse.of_assignlocation(lssku,lsSUpplier, lswarehouse, lsInvType,llOwnerID, ldReqQty)
	
		llNewRow = idw_putaway.InsertRow(0)
	
		idw_putaway.setitem(llNewRow,'wo_no', is_WONO)
		idw_putaway.SetItem(llNewRow,"sku", lssku)	
		idw_putaway.SetItem(llNewRow,"sku_parent", lssku)	
		idw_putaway.SetItem(llNewRow,"supp_code", lsSupplier)
		idw_putaway.SetItem(llNewRow,"owner_id", llOwnerID)	
		idw_putaway.SetItem(llNewRow,"line_item_no", llLineItem)	
		idw_putaway.SetItem(llNewRow,"cf_owner_name", lsOwnername)	
		idw_putaway.SetItem(llNewRow,"inventory_type", lsInvtype)	
		idw_putaway.SetItem(llNewRow,"serialized_ind", lsSerial)	
		idw_putaway.SetItem(llNewRow,"lot_controlled_ind", lsLot)
		idw_putaway.SetItem(llNewRow,"po_controlled_ind", lsPO)
		idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind", lsPO2)
		idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind", lsContainer)  	//GAP 11-02
		idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind", lsExpiration) 	//GAP 11-02
		idw_putaway.SetItem(llNewRow,"component_ind", lsComp)
		idw_putaway.SetItem(llNewRow,"country_of_origin", lsCOO)
		idw_putaway.SetItem(llNewRow,"quantity", 1) 
// TAM 2011/01  Just use blank location,  It was comment out above at some time so just plug a blank to prevent Null
		//idw_putaway.SetItem(llNewRow,"l_code", lsloc)	
		idw_putaway.SetItem(llNewRow,"l_code", '' )	
		idw_putaway.setitem(llNewRow,'component_no',0)


		// 07/04 - PCONKL - Set Unique Line number
		llSubLine = llNewRow
		//If Subline Already Exists, bump until not
		llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
		Do While llFindRow > 0
			llSubLine ++
			llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
		Loop

		idw_putaway.SetItem(llNewRow,"sub_line_item_no", llSubLine)	 
	

	// TAM 10/07/2010  For NYCSP we need to calculate the container ID
		If gs_project = 'NYCSP' Then
			// If Tracking by Container ID, set to Next
			If lsContainer = 'Y' Then
				idw_Putaway.SetITem(llNewRow,'container_id',uf_get_next_container_ID('')) /* 04/01 - PCONKL - moved to function to support project specific requirements*/
			End If /*Container Tracked */
		End If

		// 2010/09 TAM - If this Item is a Component, Insert Rows for child Items (For NYCSP but could be for everyone)
		If gs_project = 'NYCSP' Then
			If idw_putaway.GetItemString(llNewRow,"component_ind") = 'Y' Then
				ilCompNumber =  g.of_next_db_seq(gs_project,'Content','Component_no')
				idw_putaway.setitem(llNewrow,'component_no', ilCompnumber)
				wf_create_comp_child(llNewrow)
			Else /* not a component*/
				idw_putaway.setitem(llNewrow,'component_no',0)
			End If /*component*/
		End If	
	
	Next /*Next Quantity Row*/
Next /*Next Detail Row*/

// 2010/10 -TAM - For NYCSP, we need to copy Lot, PO and Exp Date and L_Code from Picking to Putaway and make sure the qty's match
If Upper(gs_project) = 'NYCSP' Then
	wf_putaway_nycsp()
End If



SetPointer(Arrow!)
idw_putaway.SetRedraw(True)

//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_putaway)

end event

event type long ue_create_kit_change_detail();//Integer liRC
//long i,ll_totalrows, llWONO
//String	lsOrder

long i, ldOwnerId,   ldAvailQty, ll_row,ll_count, ll_Idx
String lswhcode, lsParentSku, lsParentSupplier,  lsComponentSku, lsComponentSupplier,ls_component_putaway_location
Datastore lds_detail_whs

lswhcode =  idw_main.GetItemString(1,'wh_code')
// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Create the order detail Lines
/*  This functionality will build detail rows to pick all inventory for a given parent sku entered in the Userfields 1 and 2 on the workorder master.  
	A detailrow will be added for each warehouse and the total quantity will be picked since all inventory must be changed.
	In addition if the Order Type is 'A-Add' then we will also add a detail row to pick the component being added to the kit.
*/
If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then
	If idw_main.GetItemString(1,"ord_status") <> 'N' Then
		Messagebox(is_title,'Order must be in Status "NEW".')
		Return -1
	End If

	If isNull(idw_main.GetITemString(1,'user_field1')) or idw_main.GetITemString(1,'User_Field1') ='' Then
		Messagebox(is_title,'Parent SKU is required.')
		Return -1
	else
		lsParentSku = idw_main.GetITemString(1,'User_Field1')	
	End If

	If isNull(idw_main.GetITemString(1,'user_field2')) or idw_main.GetITemString(1,'User_Field2') ='' Then
		Messagebox(is_title,'Parent Supplier is required.')
		Return -1
	else
		lsParentSupplier = idw_main.GetITemString(1,'User_Field2')	
	End If

//02/20 - MikeA S42641 F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order
//	If isNull(idw_main.GetITemString(1,'user_field3')) or idw_main.GetITemString(1,'User_Field3') ='' Then
	If tab_main.tabpage_main.dw_workorder_component_sku.RowCount() <= 0 Then
		Messagebox(is_title,'At least one Component SKU is required.')
		Return -1
	else
//		02-20-2020 - MikeA - F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order		
//		Set Below but still do validation.

//		lsComponentSku = idw_main.GetITemString(1,'User_Field3')	

	End If
	
	
//TAM 07/2014 If 'A' Then UF 4 is component qty.  If "D" then UF4 is Component Putaway Location

	FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount()

		If idw_main.GetItemString(1,'ord_type') = 'A'  Then	
			If isNull(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(ll_Idx,'userfield_1')) or &
			   tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(ll_Idx,'userfield_1') ='' Then
				Messagebox(is_title,'Component Quantity is required.')
				Return -1
			else
				If not isNumber(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(ll_Idx,'userfield_1')) Then
					Messagebox(is_title,'Component Quantity is must be numeric.')
					tab_main.tabpage_main.dw_workorder_component_sku.SetRow(ll_Idx)
					tab_main.tabpage_main.dw_workorder_component_sku.SetColumn("userfield_1")
					Return -1
				End If
			End If
		Else
			If isNull(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(ll_Idx,'userfield_1')) or &
			   tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(ll_Idx,'userfield_1') ='' Then
				Messagebox(is_title,'Component Putaway Location is required.')
				 tab_main.tabpage_main.dw_workorder_component_sku.SetRow(ll_Idx)
				 tab_main.tabpage_main.dw_workorder_component_sku.SetColumn("userfield_1")
				Return -1
			End If
//			ls_component_putaway_location = idw_main.GetITemString(1,'user_field4')
		End If
	NEXT 

	SELECT Count(*)  
	INTO :ll_count  
	FROM Item_Master  
	WHERE Project_Id = :gs_project AND SKU = :lsParentSku AND Supp_Code = :lsParentSupplier  ;
	If ll_count <> 1 Then
		Messagebox(is_title,'Parent Item is not found in the Item Master.')
		Return -1
	End If

	If idw_main.GetItemString(1,"ord_type") = 'A' Then
		
		FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount()  //Loop thru ComponentSku

			lsComponentSku = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "Component_Sku")

			SELECT Min(Supp_Code)
			INTO :lsComponentSupplier  
			FROM Item_Master  
			WHERE Project_Id = :gs_project AND SKU = :lsComponentSku and Item_Delete_Ind = 'N' ;
			If IsNull(lsComponentSupplier) OR  lsComponentSupplier < '' Then
				Messagebox(is_title,'Component Item ('+lsComponentSku+') is not found in the Item Master.')
				tab_main.SelectTab(1)
				tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
				tab_main.tabpage_main.dw_workorder_component_sku.SetRow(ll_Idx)
				tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('component_sku')
				Return -1
			End If
	
			SELECT Count(*)  
			INTO :ll_count  
			FROM Item_Component  
			WHERE Project_Id = :gs_project AND SKU_Parent = :lsParentSku AND Supp_Code_Parent = :lsParentSupplier  AND SKU_Child = :lsComponentSku;
			If ll_count = 1 Then
				Messagebox(is_title,'Component Item  ('+lsComponentSku+') is already in the Item Master.')
				tab_main.SelectTab(1)
				tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
				tab_main.tabpage_main.dw_workorder_component_sku.SetRow(ll_Idx)
				tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('component_sku')

				Return -1
			End If
	
		Next
	End If


	If idw_main.GetItemString(1,"ord_type") = 'D' Then
		
		FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount() //Loop thru ComponentSku
		
			lsComponentSku = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "Component_Sku")
		
			ls_component_putaway_location = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "userfield_1")
		
			SELECT Count(*)  
			INTO :ll_count  
			FROM Item_Component  
			WHERE Project_Id = :gs_project AND SKU_Parent = :lsParentSku AND Supp_Code_Parent = :lsParentSupplier  AND SKU_Child = :lsComponentSku;
			If ll_count <> 1 Then
				Messagebox(is_title,'Component Item ('+lsComponentSku+') is not found in the Item Master.')
				tab_main.SelectTab(1)
				tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
				tab_main.tabpage_main.dw_workorder_component_sku.SetRow(ll_Idx)
				tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('component_sku')
				Return -1
			End If
	//TAM 07/2014 Check that UF4(Component Putaway Location) is a valid location
			SELECT Count(*)  
			INTO :ll_count  
			FROM Location  
			WHERE Wh_Code = :lswhcode AND l_code = :ls_component_putaway_location;
			If ll_count <> 1 Then
				Messagebox(is_title,'Component Putaway Location ('+ls_component_putaway_location+') Not a valid location.')
				Return -1
			End If
	
		Next
	
	End If

	// Delete Existing Details
	ll_count = idw_detail.Rowcount()
	if ll_count > 0 then
		If Messagebox(is_title, "Detail Records Exist - Are you sure you want to delete this record?", Question!,yesno!,2) = 2 Then
			Return -1
		End If
		ll_count = idw_detail.Rowcount()
		For i = ll_count to 1 Step -1
			idw_detail.DeleteRow(i)
		Next
	End If
		
	// Datastore used to get the list of warehouses and the available qty.  
	If not isvalid (lds_detail_whs) Then
		lds_detail_whs = Create DataStore
		lds_detail_whs.dataobject = 'd_workorder_kit_adjustment_whs'
		lds_detail_whs.SetTransObject(SQLCA)
	End If
		
	ll_count = lds_detail_whs.Retrieve(gs_project,lsParentSku,lsParentSupplier) 

	if ll_count < 1 then
		Messagebox(is_title,'No Inventory for this selected Item.')
		Return -1
	End If

	idwc_supplier_Detail.InsertRow(0)
	for i = 1 to ll_count
		ll_row = idw_detail.InsertRow(0)
		idw_detail.SetITem(ll_row,'wo_no',idw_main.GetITemString(1,'wo_no'))
		idw_detail.SetItem(ll_row,'line_item_no',ll_row)
		idw_detail.SetITem(ll_row,'sku',idw_main.GetItemString(1,'user_field1'))
		idw_detail.SetITem(ll_row,'supp_code',idw_main.GetItemString(1,'user_field2'))
		/* We store the Warehouse code in UF 1 because workorders usually dont pick inventory across warehouses,
		but for Kit changes we are changing all kits in all warehouse */
		idw_detail.SetITem(ll_row,'user_field1',lds_detail_whs.GetItemString(i,'wh_code')) 
		idw_detail.SetITem(ll_row,'Req_Qty',lds_detail_whs.GetItemNumber(i,'Avail_Qty'))
		idw_detail.SetITem(ll_row,'Owner_Id',lds_detail_whs.GetItemNumber(i,'Owner_Id'))
		idw_detail.SetITem(ll_row,'Component_Ind','N')

		/* If the Order Type is A for Add a component to the Kit then we need to add a detail row to pick the new component from
		Raw Inventory (found in User Fields 3 and 4)
		*/
		If idw_main.GetItemString(1,"ord_type") = 'A'Then
			
			FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount() //Loop thru ComponentSku
		
				lsComponentSku = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "Component_Sku")

				ll_row = idw_detail.InsertRow(0)
				idw_detail.SetITem(ll_row,'wo_no',idw_main.GetITemString(1,'wo_no'))
				idw_detail.SetItem(ll_row,'line_item_no',ll_row)
				//02/20 - MikeA S42641 F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order
				idw_detail.SetITem(ll_row,'sku', lsComponentSku) //idw_main.GetITemString(1,'user_field3'))
	//			idw_detail.SetITem(ll_row,'supp_code',idw_main.GetITemString(1,'user_field4'))
				idw_detail.SetITem(ll_row,'user_field1',lds_detail_whs.GetItemString(i,'wh_code'))
				idw_detail.SetITem(ll_row,'supp_code',lsComponentSupplier)
				idw_detail.SetITem(ll_row,'Req_Qty',lds_detail_whs.GetItemNumber(i,'Avail_Qty')*  dec(tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "userfield_1")))//dec(idw_main.GetITemString(1,'user_field4')))
				SELECT Owner_Id  INTO :ldOwnerId  FROM Item_Master     WHERE Project_Id = :gs_project  AND SKU = :lsComponentSku AND  Supp_Code = :lsComponentSupplier    ;
				idw_detail.SetITem(ll_row,'Owner_Id',ldOwnerId)
				idw_detail.SetITem(ll_row,'Component_Ind','N')
			Next
		End If	//Order Type 'A'			
	next //Warehouse
End If //TAM - Kit Change Functionality

ib_changed = True


	
Return 0
end event

event ue_generate_putaway_kit_change_add();//generate the FG putaway of finished components

Long	llRowPos, llRowQty,		&
		llRowCount,		&
		llOwnerID,		&
		llLineItem,	&
		llNewRow,		&
		llSubLine,		&
		llFindRow,		&
		llFindPickRow,	&
		ll_Idx
		
decimal ldReqQty, &
		ldChildQty

String		lsWhCode,lsFind, lsComponentSku	
String		lsSqlSyntax, ERRORS
Long		llPickDetailRows, llResult

datastore lds_pick_detail 
lds_pick_detail = Create datastore

//GailM 11/20 DE17335 Multiple changes in this event to sync with 5 trigger changes  for Add and Delete components
//Only PickDetail rows have ro_no - a special DS was created to pull the ro_no field
lsSqlSyntax = "Select wo_no, line_item_no, ro_no, container_id from workorder_picking_detail with (nolock) where wo_no = '" + idw_main.GetITemString(1,'wo_no') + "' "
llResult = lds_pick_detail.Create(SQLCA.SyntaxFromSQL(lsSqlSyntax,"", ERRORS))
llResult = lds_pick_detail.SetTransObject(SQLCA)
llResult = lds_pick_detail.Retrieve()
llPickDetailRows = lds_pick_detail.RowCount()

If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Putaway List!')
	return
End If			
			
//Cant generate Putaway until after Pick List generated
If idw_Pick.RowCount() <= 0 Then
	MessageBox(is_title,'You must generate the Pick List before generating the Putaway List!')	
	Return
End If /*No Pick list */

ib_changed = True

SetPointer(Hourglass!)
idw_putaway.SetRedraw(False)

idwc_supplier_Putaway.InsertRow(0)

llRowCount = idw_Pick.RowCount()  //Load new records from Picking.
			
For llRowPos = 1 to llRowCount /*For each Picking Record*/
	
	w_main.SetMicrohelp('generating Putaway for Picking Line: ' + String(llRowPos) + ' of ' + String(llRowCount))

	If idw_main.GetITemString(1,'User_field1') = idw_pick.GetItemString(llRowPos,"sku") Then // First run only load the Parent Items
 
		llNewRow = idw_putaway.InsertRow(0)
	
		idw_putaway.setitem(llNewRow,'wo_no', idw_main.GetITemString(1,'wo_no'))
		idw_putaway.SetItem(llNewRow,"sku", idw_pick.GetItemString(llRowPos,"sku"))	
		idw_putaway.SetItem(llNewRow,"sku_parent", idw_pick.GetItemString(llRowPos,"sku_parent"))	
		idw_putaway.SetItem(llNewRow,"supp_code", idw_pick.GetITemString(llRowPos,"supp_code"))
		idw_putaway.SetItem(llNewRow,"owner_id", idw_pick.GetItemNumber(llRowPos,"owner_id"))	
		idw_putaway.SetItem(llNewRow,"line_item_no", idw_pick.GetItemNumber(llRowPos,"line_item_no"))	
		idw_putaway.SetItem(llNewRow,"cf_owner_name", idw_pick.GetItemString(llRowPos,"cf_owner_name"))	
		idw_putaway.SetItem(llNewRow,"inventory_type", idw_pick.GetItemString(llRowPos,"inventory_type"))	
		idw_putaway.SetItem(llNewRow,"serialized_ind", idw_pick.GetItemString(llRowPos,"serialized_ind"))	
		idw_putaway.SetItem(llNewRow,"lot_controlled_ind",  idw_pick.GetItemString(llRowPos,"lot_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"po_controlled_ind",  idw_pick.GetItemString(llRowPos,"po_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind",  idw_pick.GetItemString(llRowPos,"po_no2_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind",  idw_pick.GetItemString(llRowPos,"Container_Tracking_Ind")) 
		idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind",  idw_pick.GetItemString(llRowPos,"Expiration_Controlled_Ind"))
		idw_putaway.SetItem(llNewRow,"Expiration_Date",  idw_pick.GetItemDateTime(llRowPos,"Expiration_Date"))
		idw_putaway.SetItem(llNewRow,"component_ind",  'Y') //Default Parent to Yes
		idw_putaway.SetItem(llNewRow,"country_of_origin",  idw_pick.GetItemString(llRowPos,"country_of_origin"))
		idw_putaway.SetItem(llNewRow,"quantity", idw_pick.GetItemNumber(llRowPos,"quantity")) 
		idw_putaway.SetItem(llNewRow,"l_code",  idw_pick.GetItemString(llRowPos,"l_code"))	
		idw_putaway.setitem(llNewRow,'Container_Id',idw_pick.GetItemString(llRowPos,"Container_Id"))
		idw_putaway.SetItem(llNewRow,"sub_line_item_no", llNewRow)	
		idw_putaway.SetItem(llNewRow,"old_inventory_type",idw_pick.GetItemString(llRowPos,"inventory_type"))
		idw_putaway.SetItem(llNewRow,"old_container_id",idw_pick.GetItemString(llRowPos,"container_id"))
		idw_putaway.SetItem(llNewRow,"old_l_code",idw_pick.GetItemString(llRowPos,"l_code"))
		
		lsFind = "line_item_no = " + String(idw_pick.GetItemNumber(llRowPos,"line_item_no")) + " and container_id = '" + idw_pick.GetItemString(llRowPos,"container_id") + "' "
		llFindPickRow = lds_pick_detail.Find(lsFind, 1, lds_pick_detail.RowCount())
		If llFindPickRow > 0 Then
			idw_putaway.SetItem(llNewRow,"ro_no",lds_pick_detail.GetItemString(llFindPickRow,"ro_no"))	//GailM 11/13/2020
		Else
			idw_putaway.SetItem(llNewRow,"ro_no","-")	//GailM 11/13/2020
		End If

		//MikeA - DE15132 - SIMS QAT DEFECT - S42641 - NYCSP - Component Delete not working for single SKUS
		//Component_No not being assigned for add if one isn't being picked. 
		
		
		ilCompNumber = idw_pick.GetItemNumber(llRowPos,"component_no")

		if IsNull(ilCompNumber) OR ilCompNumber = 0 then
			ilCompNumber =  g.of_next_db_seq(gs_project,'Content','Component_no')
		end if		
		
		idw_putaway.SetItem(llNewRow,"component_no", ilCompNumber) 
		
		
		idw_putaway.SetItem(llNewRow,"c_confirm_putaway_ind", 'Y') 
	//Get Warehouse From Detail(UF1)
		llFindRow = idw_detail.Find("line_item_no = " + String(idw_pick.GetItemNumber(llRowPos,"line_item_no")),1,idw_detail.RowCount())
		lsWhCode =  idw_detail.getITemString(llFindRow,"user_field1")
		idw_putaway.SetItem(llNewRow,"User_Field1", lsWhCode)

//Add Child Record for each Parent record - All inventory should already be picked for this

		//02/20 - MikeA S42641 F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order

		FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount() //Loop thru ComponentSku

			lsComponentSku = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "Component_Sku")

			llNewRow = idw_putaway.InsertRow(0)
		
		//Get 1st PIck Row for Children for parent warehouse
	//		lsFind = "Sku = '" + idw_Main.GetItemString(1,"User_Field3") + "' and user_field1 = '" + lsWhCode + "'"  
			lsFind = "Sku = '" + lsComponentSku + "' and user_field1 = '" + lsWhCode + "'"  
			llFindRow = idw_detail.Find(lsFind  ,1,idw_detail.RowCount())
	//		llFindRow = idw_detail.Find("Sku = '" + idw_Main.GetItemString(1,"User_Field3")+"' and user_field1 = '" + lsWhCode + "'"  ,1,idw_detail.RowCount())
			lsFind	= "line_item_no = " + String(idw_detail.GetItemNumber(llFindRow,"line_item_no"))
			llFindRow = idw_pick.Find(lsFind,1,idw_pick.RowCount())
	//		llFindRow = idw_pick.Find("line_item_no = " + String(idw_pick.GetItemNumber(llFindRow,"line_item_no")),1,idw_pick.RowCount())
	
			idw_putaway.setitem(llNewRow,'wo_no', idw_main.GetITemString(1,'wo_no'))
			idw_putaway.SetItem(llNewRow,"sku", lsComponentSku )     // idw_main.GetITemString(1,'User_field3'))	
			idw_putaway.SetItem(llNewRow,"sku_parent", idw_pick.GetItemString(llRowPos,"sku_parent"))	
			idw_putaway.SetItem(llNewRow,"supp_code", idw_pick.GetITemString(llFindRow,"supp_code"))
			idw_putaway.SetItem(llNewRow,"owner_id", idw_pick.GetItemNumber(llFindRow,"owner_id"))	
			idw_putaway.SetItem(llNewRow,"line_item_no", idw_pick.GetItemNumber(llRowPos,"line_item_no"))	
			idw_putaway.SetItem(llNewRow,"cf_owner_name", idw_pick.GetItemString(llFindRow,"cf_owner_name"))	
	//		idw_putaway.SetItem(llNewRow,"inventory_type", idw_pick.GetItemString(llFindRow,"inventory_type"))	
			idw_putaway.SetItem(llNewRow,"inventory_type",  '8') //Set Inventory Type to "8" Component Child
			idw_putaway.SetItem(llNewRow,"serialized_ind", idw_pick.GetItemString(llFindRow,"serialized_ind"))	
			idw_putaway.SetItem(llNewRow,"lot_controlled_ind",  idw_pick.GetItemString(llFindRow,"lot_controlled_ind"))
			idw_putaway.SetItem(llNewRow,"po_controlled_ind",  idw_pick.GetItemString(llFindRow,"po_controlled_ind"))
			idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind",  idw_pick.GetItemString(llFindRow,"po_no2_controlled_ind"))
			idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind",  idw_pick.GetItemString(llFindRow,"Container_Tracking_Ind")) 
			idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind",  idw_pick.GetItemString(llFindRow,"Expiration_Controlled_Ind"))
			idw_putaway.SetItem(llNewRow,"Expiration_Date",  idw_pick.GetItemDateTime(llFindRow,"Expiration_Date"))
			idw_putaway.SetItem(llNewRow,"component_ind",  '*') //Default Child to *
			idw_putaway.SetItem(llNewRow,"country_of_origin",  idw_pick.GetItemString(llFindRow,"country_of_origin"))
			ldChildQty = idw_pick.GetItemNumber(llRowPos,"quantity") * dec( tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "userfield_1")) //dec(idw_Main.GetItemString(1,"User_Field4"))
			idw_putaway.SetItem(llNewRow,"quantity",ldChildQty) 
			idw_putaway.SetItem(llNewRow,"l_code",  idw_pick.GetItemString(llRowPos,"l_code"))	
			idw_putaway.setitem(llNewRow,'Container_Id',idw_pick.GetItemString(llRowPos,"Container_Id"))
			idw_putaway.SetItem(llNewRow,"sub_line_item_no", llNewRow)	
			idw_putaway.SetItem(llNewRow,"User_Field1", lsWhCode)
			idw_putaway.SetItem(llNewRow,"component_no", ilCompNumber )  //DE15132 //idw_pick.GetItemNumber(llRowPos,"component_no")) 
			idw_putaway.SetItem(llNewRow,"c_confirm_putaway_ind", 'Y') 
			idw_putaway.SetItem(llNewRow,"old_inventory_type",idw_pick.GetItemString(llFindRow,"inventory_type"))
			idw_putaway.SetItem(llNewRow,"old_container_id",idw_pick.GetItemString(llFindRow,"container_id"))
			idw_putaway.SetItem(llNewRow,"old_l_code",idw_pick.GetItemString(llFindRow,"l_code"))
			
			lsFind = "line_item_no = " + String(idw_pick.GetItemNumber(llRowPos,"line_item_no")) + " and container_id = '" + idw_pick.GetItemString(llRowPos,"container_id") + "' "
			llFindPickRow = lds_pick_detail.Find(lsFind, 1, lds_pick_detail.RowCount())
			If llFindPickRow > 0 Then
				idw_putaway.SetItem(llNewRow,"ro_no",lds_pick_detail.GetItemString(llFindPickRow,"ro_no"))	//GailM 11/13/2020
			Else
				idw_putaway.SetItem(llNewRow,"ro_no","-")	//GailM 11/13/2020
			End If
		Next

End If // Add Parents Only
Next /*Next Pick Row*/
tab_main.tabpage_putaway.cb_confirm_putaway.Enabled = True
SetPointer(Arrow!)
idw_putaway.SetRedraw(True)

			


//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_putaway)

end event

event ue_generate_putaway_kit_change_delete();//generate the FG putaway of finished components

Long	llRowPos, llRowQty,		&
		llRowCount,		&
		llOwnerID,		&
		llLineItem,	&
		llNewRow,		&
		llSubLine,		&
		llFindRow,		&
		llfindPickRow
		
decimal ldReqQty, &
		ldChildQty
		
boolean lbDeleteSku

String		lsWhCode,lsFind,lsComponentLocation
String		lsSqlSyntax, ERRORS
Long		llPickDetailRows, llResult

datastore lds_pick_detail 
lds_pick_detail = Create datastore

//GailM 11/20 DE17335 Multiple changes in this event to sync with 5 trigger changes  for Add and Delete components
//Only PickDetail rows have ro_no - a special DS was created to pull the ro_no field
lsSqlSyntax = "Select wo_no, line_item_no, ro_no, container_id from workorder_picking_detail with (nolock) where wo_no = '" + idw_main.GetITemString(1,'wo_no') + "' "
llResult = lds_pick_detail.Create(SQLCA.SyntaxFromSQL(lsSqlSyntax,"", ERRORS))
llResult = lds_pick_detail.SetTransObject(SQLCA)
llResult = lds_pick_detail.Retrieve()
llPickDetailRows = lds_pick_detail.RowCount()
			
If ib_changed Then //GAP 11/02
	messagebox(is_title,'Please save changes before generating Putaway List!')
	return
End If			
			
//Cant generate Putaway until after Pick List generated
If idw_Pick.RowCount() <= 0 Then
	MessageBox(is_title,'You must generate the Pick List before generating the Putaway List!')	
	Return
End If /*No Pick list */

ib_changed = True

SetPointer(Hourglass!)
idw_putaway.SetRedraw(False)

idwc_supplier_Putaway.InsertRow(0)

llRowCount = idw_Pick.RowCount()  //Load new records from Picking.
			
For llRowPos = 1 to llRowCount /*For each Picking Record*/
	
	w_main.SetMicrohelp('generating Putaway for Picking Line: ' + String(llRowPos) + ' of ' + String(llRowCount))

		llNewRow = idw_putaway.InsertRow(0)
	
		idw_putaway.setitem(llNewRow,'wo_no', idw_main.GetITemString(1,'wo_no'))
		idw_putaway.SetItem(llNewRow,"sku", idw_pick.GetItemString(llRowPos,"sku"))	
		
		llFindRow = tab_main.tabpage_main.dw_workorder_component_sku.Find("component_sku = '" + idw_pick.GetItemString(llRowPos,"sku")+"'",1,tab_main.tabpage_main.dw_workorder_component_sku.RowCount())
		IF llFindRow > 0 THEN
			lsComponentLocation = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(llFindRow, "userfield_1")
			lbDeleteSku = true
		ELSE
			lsComponentLocation = idw_pick.GetItemString(llRowPos,"l_code")
			lbDeleteSku = false
		END IF 
	
		idw_putaway.SetItem(llNewRow,"sku_parent", idw_pick.GetItemString(llRowPos,"sku_parent"))	
		idw_putaway.SetItem(llNewRow,"supp_code", idw_pick.GetITemString(llRowPos,"supp_code"))
		idw_putaway.SetItem(llNewRow,"owner_id", idw_pick.GetItemNumber(llRowPos,"owner_id"))	
		idw_putaway.SetItem(llNewRow,"line_item_no", idw_pick.GetItemNumber(llRowPos,"line_item_no"))	
		idw_putaway.SetItem(llNewRow,"cf_owner_name", idw_pick.GetItemString(llRowPos,"cf_owner_name"))	
		idw_putaway.SetItem(llNewRow,"inventory_type", idw_pick.GetItemString(llRowPos,"inventory_type"))	
		idw_putaway.SetItem(llNewRow,"serialized_ind", idw_pick.GetItemString(llRowPos,"serialized_ind"))	
		idw_putaway.SetItem(llNewRow,"lot_controlled_ind",  idw_pick.GetItemString(llRowPos,"lot_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"po_controlled_ind",  idw_pick.GetItemString(llRowPos,"po_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind",  idw_pick.GetItemString(llRowPos,"po_no2_controlled_ind"))
		idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind",  idw_pick.GetItemString(llRowPos,"Container_Tracking_Ind")) 
		idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind",  idw_pick.GetItemString(llRowPos,"Expiration_Controlled_Ind"))
		idw_putaway.SetItem(llNewRow,"Expiration_Date",  idw_pick.GetItemDateTime(llRowPos,"Expiration_Date"))
		// If Component Indicater = '*' Then we are removing this Item From the Kit and putting it away as a Normal Inventory
		If idw_pick.GetItemString(llRowPos,"Component_Ind") = '*' Then
			IF lbDeleteSku then
				idw_putaway.SetItem(llNewRow,"old_inventory_type", idw_pick.GetItemString(llRowPos, "inventory_type"))
				idw_putaway.setitem(llNewRow,"old_Container_Id",  idw_pick.GetItemString(llRowPos, "Container_Id"))
				idw_putaway.SetItem(llNewRow,"old_l_code", idw_pick.GetItemString(llRowPos, "l_code"))
				idw_putaway.SetItem(llNewRow,"component_no", 0) 
				idw_putaway.SetItem(llNewRow,"component_ind",  "N") //Default Parent to Yes
				idw_putaway.SetItem(llNewRow,"inventory_type",  "N") //Set Inventory Type to "N"ormal"
				idw_putaway.setitem(llNewRow,"Container_Id", "-")
				
				idw_putaway.SetItem(llNewRow,"l_code", lsComponentLocation)//idw_main.GetItemString(1,"user_field4"))	//Tam 07/2014 Use UF4(ComponentPutaway Location)  from Main to set component putaway location)
			Else
				idw_putaway.SetItem(llNewRow,"component_no",idw_pick.GetItemNumber(llRowPos,"component_no"))
				idw_putaway.SetItem(llNewRow,"component_ind", idw_pick.GetItemString(llRowPos,"component_ind"))
				idw_putaway.SetItem(llNewRow,"inventory_type", idw_pick.GetItemString(llRowPos,"inventory_type"))
				idw_putaway.setitem(llNewRow,'Container_Id',  idw_pick.GetItemString(llRowPos,"Container_Id"))			
				idw_putaway.SetItem(llNewRow,"l_code",  idw_pick.GetItemString(llRowPos,"l_code"))
				
			End If
			
			
		Else
			idw_putaway.SetItem(llNewRow,"component_ind",  'Y') //Default Parent to Yes
			idw_putaway.setitem(llNewRow,'Container_Id',idw_pick.GetItemString(llRowPos,"Container_Id"))
			idw_putaway.SetItem(llNewRow,"component_no", idw_pick.GetItemNumber(llRowPos,"component_no")) 
			idw_putaway.SetItem(llNewRow,"l_code",  idw_pick.GetItemString(llRowPos,"l_code"))	
			idw_putaway.SetItem(llNewRow,"old_inventory_type", idw_pick.GetItemString(llRowPos, "inventory_type"))
			idw_putaway.setitem(llNewRow,"old_Container_Id",  idw_pick.GetItemString(llRowPos, "Container_Id"))
			idw_putaway.SetItem(llNewRow,"old_l_code", idw_pick.GetItemString(llRowPos, "l_code"))
		End If
		idw_putaway.SetItem(llNewRow,"country_of_origin",  idw_pick.GetItemString(llRowPos,"country_of_origin"))
		idw_putaway.SetItem(llNewRow,"quantity", idw_pick.GetItemNumber(llRowPos,"quantity")) 
		idw_putaway.SetItem(llNewRow,"sub_line_item_no", llNewRow)	
		idw_putaway.SetItem(llNewRow,"c_confirm_putaway_ind", 'Y') 
		//Get Warehouse From Detail(UF1)
		llFindRow = idw_detail.Find("line_item_no = " + String(idw_pick.GetItemNumber(llRowPos,"line_item_no")),1,idw_detail.RowCount())
		lsWhCode =  idw_detail.getITemString(llFindRow,"user_field1")
		idw_putaway.SetItem(llNewRow,"User_Field1", lsWhCode)
		
		lsFind = "line_item_no = " + String(idw_pick.GetItemNumber(llRowPos,"line_item_no")) + " and container_id = '" + idw_pick.GetItemString(llRowPos,"container_id") + "' "
		llFindPickRow = lds_pick_detail.Find(lsFind, 1, lds_pick_detail.RowCount())
		If llFindPickRow > 0 Then
			idw_putaway.SetItem(llNewRow,"ro_no",lds_pick_detail.GetItemString(llFindPickRow,"ro_no"))	//GailM 11/13/2020
		Else
			idw_putaway.SetItem(llNewRow,"ro_no","-")	//GailM 11/13/2020
		End If
Next /*Next Pick Row*/


SetPointer(Arrow!)
tab_main.tabpage_putaway.cb_confirm_putaway.Enabled = True
idw_putaway.SetRedraw(True)

//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_putaway)

end event

public function integer wf_clear_screen ();
idw_main.Reset()
idw_detail.Reset()
idw_pick.Reset()
idw_putaway.Reset()

tab_main.tabpage_main.dw_workorder_component_sku.Reset()

isle_order.Text = ""

tab_main.SelectTab(1) 

Return 0

end function

public function integer wf_putaway_content ();//Putaway New rows to Content

Long	ll_TotalRows,	&
		I,					&
		llFindRow,		&
		ll_New, ll_Component_No, &
		ll_Idx
		
String	lsFind, lsWONO, lsParm, lsComponentSku

DateTime	ldtToday
Integer	lirc

// pvh 08/25/05 - GMT
// ldtToday = DateTIme(today(),Now())
// warehouse code is set in itemchanged of dw_main.
ldtToday = f_getLocalWorldTime( g.getCurrentWarehouse() ) 

lsWONO = idw_main.GetITemString(1,'wo_no')

//Create new content records - Putway records may need to be rolled up to a single content if there are duplicate sku
//They may also need to rolled into previously saved Putaway Records

If idw_putaway.AcceptText() < 0 Then Return -1

//This will run validation routine
If ib_changed then
	MEssagebox(is_title, 'Please save your changes first')
	Return -1
End If

//Confirm
//TAM 2014/05  Kit Change - Confirm All if Kit change.  We are not allowing them to delete add or modify the putaway so what is gereted is what get processed
If Messagebox(is_title,'Are you sure you want to confirm Putaway of the selected row(s)?',Question!,YesNo!,1) <> 1 and	Upper(idw_main.getitemstring(1,'Ord_Type')) <> 'A' and  Upper(idw_main.getitemstring(1,'Ord_Type')) <> 'D' Then Return -1
//If Messagebox(is_title,'Are you sure you want to confirm Putaway of the selected row(s)?',Question!,YesNo!,1) <> 1 Then Return -1

// 07/04 - PCONKL - we want a transaction record for the sweeper when we have allocated from the Pick List.
//							not knowing when the pick list is stable, we will generate it the firt time a putaway is confirmed
//							and update file_transmit_ind so we don't send it again.

If idw_main.GetITemString(1,'file_transmit_Ind') <> 'Y' or  isnull(idw_main.GetITemString(1,'file_transmit_Ind')) Then
	
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
								Values(:gs_Project, 'WX', :lsWONO,'N', :ldtToday, ''); /* 'WX' = Pick Complete */
	Execute Immediate "COMMIT" using SQLCA;
	
	idw_Main.SetITem(1,'file_transmit_Ind','Y') /* we only want to send once */
		
End If



idw_putaway_Content.Retrieve(idw_main.GetITemString(1,'wo_no')) /*Retieve any existing Putaway Rows*/

ll_totalrows = idw_putaway.rowcount()

for i = 1 to ll_totalrows
	
	//If row not checked then Don't process
	If idw_putaway.GetITemString(i,'c_confirm_putaway_ind') <> 'Y' or isnull(idw_putaway.GetITemString(i,'c_confirm_putaway_ind')) Then Continue
	
	//Location is required (not checked in Validation routine unless confirming order)
	If isNull(idw_putaway.GetITemString(i,'l_code')) or idw_putaway.GetITemString(i,'l_code') = '' Then
		Messagebox(is_title,'Location is required!')
		idw_putaway.SetRow(i)
		idw_putaway.SetColumn('l_code')
		Return -1
	End If
	
	//Putaway Type (UF1) is required for Logitech
	If Upper(gs_Project) = 'LOGITECH' Then
		If isNull(idw_putaway.GetITemString(i,'user_Field1')) or idw_putaway.GetITemString(i,'User_field1') = '' Then
			Messagebox(is_title,'Putaway Type is required!')
			idw_putaway.SetRow(i)
				idw_putaway.SetColumn('user_field1')
			Return -1
		End If
	End If
	
	// 08/08 - PCONKL - Po_no2 (Container ID) is required for Diebold
	If Upper(gs_Project) = 'DIEBOLD' Then
		If isNull(idw_putaway.GetITemString(i,'po_no2')) or idw_putaway.GetITemString(i,'po_no2') = '' or idw_putaway.GetITemString(i,'po_no2') = '-' Then
			Messagebox(is_title,'Container ID is required!')
			idw_putaway.SetRow(i)
				idw_putaway.SetColumn('po_no2')
			Return -1
		End If
	End If
	//BCR 04-JAN-2011: Get next Component_No value as per Bob's instruction...
//	ll_Component_No = g.of_next_db_seq(gs_project,'Content','Component_No')
	
	//See if the row already exists for this sku/supplier/coo/owner/loc/inv type 
	lsFind = "Upper(sku) = '" + Upper(idw_putaway.getitemstring(i,'sku')) + "' and Upper(supp_code) = '" + Upper(idw_putaway.getitemstring(i,'supp_code')) + "'"
	lsFind += " and Upper(country_of_origin) = '" + Upper(idw_putaway.getitemstring(i,'country_of_origin')) + "' and Owner_id = " + String(idw_putaway.getitemnumber(i,'owner_id'))
// TAM - 2014/04 - Added Workorder Types Kit Change Add and Delete.  Get the Putaway warehouse from Userfield1 on the Putaway screen
	If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' or Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
		lsFind += " and Upper(wh_code) = '" + Upper(idw_Putaway.getitemstring(i,'User_Field1')) + "' and Upper(l_code) = '" + Upper(idw_putaway.getitemstring(i,'l_code')) + "'"
	Else
		lsFind += " and Upper(wh_code) = '" + Upper(idw_main.getitemstring(1,'wh_code')) + "' and Upper(l_code) = '" + Upper(idw_putaway.getitemstring(i,'l_code')) + "'"
	End If
	//Jxlim 01/14/2011 not includind serial_no
//	lsFind += " and Upper(inventory_type) = '" + Upper(idw_putaway.getitemstring(i,'inventory_type')) + "' and upper(serial_no) = '" + Upper(idw_putaway.getitemstring(i,'serial_no')) + "'"
	lsFind += " and Upper(inventory_type) = '" + Upper(idw_putaway.getitemstring(i,'inventory_type'))  + "'"
	lsFind += " and Upper(lot_no) = '" + Upper(idw_putaway.getitemstring(i,'lot_no')) + "' and Upper(po_no) = '" + upper(idw_putaway.getitemstring(i,'po_no')) + "'"
	lsFind += " and Upper(po_no2) = '" + Upper(idw_putaway.getitemstring(i,'po_no2')) + "' and Upper(ro_no) = '" + Upper(idw_putaway.getitemstring(i,'wo_no')) + "'"
	lsFind += " and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + String(idw_putaway.getitemDateTime(i,'expiration_date'),'mm/dd/yyyy hh:mm') + "'"
// TAM 2010/10/13 Added container Id
	lsFind += " and Upper(container_id) = '" + Upper(idw_putaway.getitemString(i,'container_id')) + "'"
	
	llFindRow = idw_putaway_Content.Find(lsFind,1,idw_putaway_Content.RowCount())
	If llFindRow > 0 Then /*update qty on existing record*/
		idw_putaway.SetITem(i,'user_field2',String(today(),'MM/DD/YYYY HH:MM'))	   //GailM  11/12/2020 

		//Jxlim 01/04/2011 not write the serial numbers to Content if the Serialized_ind = ‘B’. 	
		IF idw_putaway.getitemstring(i,'serialized_ind') =  'B' Then
			idw_putaway_Content.setitem(llFindRow,'serial_no','-')				
		Else
			idw_putaway_Content.setitem(llFindRow,'serial_no',Trim(idw_putaway.getitemstring(i,'serial_no')))
		End If
						
	//TAM 2010/09 Added components to match receive order component processing (NYCSP only but could be for All)	
		If Upper(gs_Project) = 'NYCSP' Then
			If idw_putaway.GetITemString(i,"component_ind") = '*' or idw_putaway.GetITemString(i,"component_ind") = 'B' Then /* 09/02 - Pconkl - 'B' = Both (child and parent) */
				idw_putaway_Content.setitem(llFindRow,'component_qty',(idw_putaway_Content.GetItemNumber(llFindRow,'component_qty') + idw_putaway.getitemnumber(i,'quantity')))
			Else
				idw_putaway_Content.setitem(llFindRow,'avail_qty',(idw_putaway_Content.GetItemNumber(llFindRow,'avail_qty') + idw_putaway.getitemnumber(i,'quantity')))
			End If
		Else
			idw_putaway_Content.setitem(llFindRow,'avail_qty',(idw_putaway_Content.GetItemNumber(llFindRow,'avail_qty') + idw_putaway.getitemnumber(i,'quantity')))
		End If
	
	Else /* create a new content record*/
		ll_new = idw_putaway_Content.insertrow(0)
		idw_putaway_Content.accepttext()
		idw_putaway_Content.setitem(ll_new,'project_id',gs_project)
		idw_putaway_Content.setitem(ll_new,'sku',idw_putaway.getitemstring(i,'sku'))
		idw_putaway_Content.setitem(ll_new,'supp_code',idw_putaway.getitemstring(i,'supp_code'))
		idw_putaway_Content.setitem(ll_new,'country_of_origin',idw_putaway.getitemstring(i,'country_of_origin'))
		idw_putaway_Content.setitem(ll_new,'owner_id',idw_putaway.getitemnumber(i,'owner_id'))	
		//BCR 04-JAN-2011: Set Component_No to value obtained above...
		idw_putaway_Content.setitem(ll_new,'component_no', idw_putaway.getitemnumber(i,'component_no'))
		ll_Component_No =  idw_putaway.getitemnumber(i,'component_no')
		// TAM 03/29/2012 Added this back in for Riverbed.  It was messed up on delivery order being a kit within a kit
		// GXMOR 05/03/2012 Added NYCSP for if statement as directed by TAM
		If Upper(gs_Project) = 'RIVERBED' or Upper(gs_Project) = 'NYCSP' Then 
			idw_putaway_Content.setitem(ll_new,'component_no',idw_putaway.getitemnumber(i,'component_no')) /*Finished goods are no longer components, don't want to link any children at picking!! */
		End If
		//
	// TAM - 2014/04 - Added Workorder Types Kit Change Add and Delete.  Get the Putaway warehouse from Userfield1 on the Putaway screen
		If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' or Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
			idw_putaway_Content.setitem(ll_new,'wh_code',idw_putaway.getitemstring(i,'user_field1'))
		Else
			idw_putaway_Content.setitem(ll_new,'wh_code',idw_main.getitemstring(1,'wh_code'))
		End If
		idw_putaway_Content.setitem(ll_new,'l_code',idw_putaway.getitemstring(i,'l_code'))
		idw_putaway_Content.setitem(ll_new,'inventory_type',idw_putaway.getitemstring(i,'inventory_type'))
		//Jxlim 01/04/2011 not write the serial numbers to Content if the Serialized_ind = ‘B’. 	
		//idw_putaway_Content.setitem(ll_new,'serial_no',idw_putaway.getitemstring(i,'serial_no')) 					
		IF idw_putaway.getitemstring(i,'serialized_ind') =  'B' Then
			idw_putaway_Content.setitem(ll_new,'serial_no','-')
		Else
			idw_putaway_Content.setitem(ll_new,'serial_no',idw_putaway.getitemstring(i,'serial_no'))
		End if
		idw_putaway_Content.setitem(ll_new,'lot_no',idw_putaway.getitemstring(i,'lot_no'))
		idw_putaway_Content.setitem(ll_new,'po_no',idw_putaway.getitemstring(i,'po_no')) 
		idw_putaway_Content.setitem(ll_new,'po_no2',idw_putaway.getitemstring(i,'po_no2')) 
		idw_putaway_Content.setitem(ll_new,'container_id',idw_putaway.getitemstring(i,'container_id')) 				//gap 11-02		
		idw_putaway_Content.setitem(ll_new,'expiration_date',idw_putaway.getitemdatetime(i,'expiration_date')) 	//gap 11-02	
		idw_putaway_Content.setitem(ll_new,'ro_no',idw_putaway.getitemstring(i,'wo_no'))  //dts - 12/12/2020 adding this line back in (Riverbed throwing system error doing 'Confirm Putaway' step. Non-NYCSP projects are not setting ro_no below (required for insert into Content))
		idw_putaway_Content.setitem(ll_new,'reason_cd','')
		idw_putaway_Content.setitem(ll_new,'last_user',gs_userid)
		idw_putaway_Content.setitem(ll_new,'last_update',g.of_getWorldTime() )

		//TAM 2010/09 Added components to match receive order component processing (NYCSP only but could be for All)	
		If Upper(gs_Project) = 'NYCSP' Then
			If idw_putaway.GetITemString(i,"component_ind") = '*' or idw_putaway.GetITemString(i,"component_ind") = 'B' Then /* 09/02 - Pconkl - 'B' = Both (child and parent) */
				idw_putaway_Content.setitem(ll_new,'avail_qty',0)
				idw_putaway_Content.setitem(ll_new,'component_qty',idw_putaway.getitemnumber(i,'quantity'))
				idw_putaway_Content.setitem(ll_new,'ro_no',idw_putaway.getitemstring(i,'wo_no')) 	//GailM DE17335 - Throwing a DB error if coming from picking
				idw_putaway.SetITem(i,'user_field2',String(today(),'MM/DD/YYYY HH:MM'))	   //GailM  7/10/2020 S47693 F20484 I2896 - For component SKU - cancelled
			Else
				idw_putaway_Content.setitem(ll_new,'avail_qty',idw_putaway.getitemnumber(i,'quantity'))
				idw_putaway_Content.setitem(ll_new,'component_qty',0)
				idw_putaway_Content.setitem(ll_new,'ro_no',idw_putaway.getitemstring(i,'wo_no')) 	//GailM DE17335 - Throwing a DB error if coming from picking
				idw_putaway.SetITem(i,'user_field2',String(today(),'MM/DD/YYYY HH:MM'))		//GailM  7/10/2020 S47693 F20484 I2896 - For parent SKU
			End If
		Else
			idw_putaway_Content.setitem(ll_new,'avail_qty',idw_putaway.getitemnumber(i,'quantity'))
			idw_putaway_Content.setitem(ll_new,'component_qty',0)
		End If

	End If /*new or existing row*/
	
	////XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	////BCR 15-DEC-2011: We need to add serial numbers to the Serial_Number _inventory when a serialized part is created 
	////                             via a work order and it’s serial tracking indicator is ‘B’. Pandora and Bluecoat for now...
	
	String  lsWhCode, lsOwnerCd, lsSKU, lsSerialNo, ls_Component_ind, lsSupplier
	Long  ll_Owner_id
	
	//IF Upper(gs_Project) = 'PANDORA' OR Upper(gs_Project) = 'BLUECOAT' THEN
	// ET3 2012-06-14: Implement generic test
	IF g.ibSNchainofcustody THEN
		IF idw_putaway.getitemstring(i,'serialized_ind') =  'B' Then
	// TAM - 2014/04 - Added Workorder Types Kit Change Add and Delete.  Get the Putaway warehouse from Userfield1 on the Putaway screen
			If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' or Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
				lsWhCode =idw_putaway.getitemstring(i,'user_field1')
			Else
				lsWhCode = idw_main.getitemstring(1,'wh_code')
			End If
			lsSKU = idw_putaway.getitemstring(i,'sku')
			lsSerialNo = idw_putaway.getitemstring(i,'serial_no')
			ls_Component_ind =  idw_putaway.GetITemString(i,"component_ind")
			ll_Owner_id = idw_putaway.getitemnumber(i,'owner_id')
			
			//Use Owner_Id to get Owner_Cd...
			Select Owner_cd 
			Into	:lsOwnerCd
			From Owner
			Where Project_id = :gs_Project and owner_id = :ll_Owner_id;
			
			if sqlca.SQlcode <> 0 then
				Messagebox(is_title,'Attempt to obtain Owner_Cd failed!' + '~n~n' + sqlca.sqlerrtext)
				Return -1
			end if
			
			Insert Into Serial_Number_Inventory (project_ID,Wh_code, Owner_id, Owner_cd, SKU, Serial_NO, Component_Ind, Component_No, Update_date,Update_user)
			Values(:gs_Project, :lsWhCode, :ll_Owner_id, :lsOwnerCd, :lsSKU, :lsSerialNo,:ls_Component_ind, :ll_Component_No,  :ldtToday, :gs_userid);
			
			if sqlca.SQlcode <> 0 then
				Messagebox(is_title,'Insert Into Serial_Number_Inventory table failed!' + '~n~n' + sqlca.sqlerrtext)
				Return -1
			end if
		END IF
	END IF
							
	////XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	
	//dts - 12/12/2020 adding this back in (from original GitHub version)
    //Set the putaway date (USer field 2)
    Idw_putaway.SetITem(i,'user_field2',String(today(),'MM/DD/YYYY HH:MM'))
	 
	//Update the Completed Qty on the Order Detail Tab (if Found)
// TAM - 2014/04 - Added Workorder Types Kit Change Add.  Use the Warehouse(User_Field1) in the find.
	If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' or  Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
		lsFind = "Upper(sku) = '" + Upper(idw_putaway.getitemstring(i,'sku')) + "' and Upper(supp_code) = '" + Upper(idw_putaway.getitemstring(i,'supp_code')) + "'"  + " and Upper(User_Field1) = '" + Upper(idw_putaway.getitemstring(i,'user_field1')) + " ' "
	Else
		lsFind = "Upper(sku) = '" + Upper(idw_putaway.getitemstring(i,'sku')) + "' and Upper(supp_code) = '" + Upper(idw_putaway.getitemstring(i,'supp_code')) + "'"
	End If
	llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
	If llFindRow > 0 Then
		idw_detail.SetITem(llFindRow,'alloc_qty',(idw_Detail.GetITemNumber(llFindRow,'Alloc_qty') + idw_putaway.getitemnumber(i,'quantity')))
	End If
	
	// 07/04 - PCONKL - We want to create a batch transaction record for the sweeper for each Putaway record being confirmed
	//							the actual row being confirmed will be passsed in the parm field
	
	lsParm = String(idw_putaway.getitemnumber(i,'sub_line_Item_No'))
	
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
							Values(:gs_Project, 'WA', :lsWONO,'N', :ldtToday, :lsParm); /* 'WA' = Putaway Complete */
	Execute Immediate "COMMIT" using SQLCA;
				
next /*Putaway Row */

// TAM - 2014/04 - Added Workorder Types Kit Change Add and Delete.  We need to update the Item_Component table with the changes
	If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' or Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
		
		idw_component_parent.Retrieve(gs_project,idw_main.getitemstring(1,'user_field1'),idw_main.getitemstring(1,'user_field2'),"C") //Load the item_component datawindow

		FOR ll_Idx =1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount()  //Loop thru ComponentSku
		
			lsComponentSku = tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "Component_Sku")
		
//			lsFind = "Upper(sku) = '" + Upper(idw_main.getitemstring(1,'user_field3')) + "'" 
			lsFind = "Upper(sku) = '" + lsComponentSku + "'" 
			llFindRow = idw_putaway.Find(lsFind,1,idw_putaway.RowCount())
			If llFindRow > 0 Then 
				lsSku = idw_putaway.getItemString(llFindRow,'SKU')
				lsSupplier = idw_putaway.getItemString(llFindRow,'supp_code')
			Else
				Continue
				//Return -1
			End If
			If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'A' Then
			// Add the compont to the item component table
				ll_new = idw_component_parent.insertrow(0)
				idw_component_parent.accepttext()
				idw_component_parent.SetItem(ll_new,"project_id",gs_project)
				idw_component_parent.SetItem(ll_new,"sku_parent",idw_main.GetItemString(1,"user_field1"))
				idw_component_parent.SetItem(ll_new,"supp_code_parent",idw_main.GetItemString(1,"user_field2"))
				idw_component_parent.SetItem(ll_new,'last_update',Today()) 
				idw_component_parent.SetItem(ll_new,'last_user',gs_userid)	
				idw_component_parent.SetItem(ll_new,'component_type',"C")  /* 08/02 - Pconkl - default to component (as apposed to Packaging */
				idw_component_parent.SetItem(ll_new,'sku_child',lsSku)
				idw_component_parent.SetItem(ll_new,'supp_code_child',lsSupplier)
				//GailM 08/14/2017 SIMSPEVS-743 Defect : NYCSP Work Order Process 
//				If isNumber(idw_main.GetItemString(1,"user_field4")) then
//					idw_component_parent.SetItem(ll_new,"child_qty",Dec(idw_main.GetItemString(1,"user_field4")))
//				End If   
				If isNumber(tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "userfield_1")) then
					idw_component_parent.SetItem(ll_new,"child_qty",Dec(tab_main.tabpage_main.dw_workorder_component_sku.GetItemString(ll_Idx, "userfield_1")))
				End If   
	
			End If
			If Upper(idw_main.getitemstring(1,'Ord_Type')) = 'D' Then
			// Delete the compont from the item component table
				lsFind = "Upper(SKU_Child) = '" + Upper(lsSku) + "'" 
				llFindRow = idw_component_parent.Find(lsFind,1,idw_component_parent.RowCount())
				If llFindRow > 0 Then 
					idw_component_parent.deleterow(llFindRow)
					idw_component_parent.accepttext()
				Else
					Continue
					//Return -1
				End If
	
			End If
		Next
	End If



idw_putaway.Rowcount()
idw_putaway_Content.Rowcount()

//Save the changes
Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/
liRC = idw_putaway_Content.Update() /*FG Putaway to Content*/
if liRC = 1 then liRC = idw_putaway.Update() /*will update date to Putaway record*/
if liRC = 1 then liRC = idw_detail.Update() /*will update Allocated Qty on DEtail*/
if liRC = 1 then liRC = idw_Main.Update() /*will update File Transmit Ind on Header */
// TAM 2014/05 - Kit Change functionality - If Order type is Kit CHange (A)dd or {D)elete then we will update the Item Component table with the child sku affected.
If liRC = 1 Then
	If idw_main.GetItemString(1,"ord_type") = 'A' or  idw_main.GetItemString(1,"ord_type") = 'D' Then
		liRC = idw_component_parent.Update() 
	End If
End If

IF (liRC = 1) THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		SetMicroHelp("Putaway Confirmed!")
		MessageBox(is_title, "Putaway Confirmed!")
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		
		//re-retrive detail and putaway to restore original values
		idw_detail.Retrieve(idw_main.GetITemString(1,'wo_no'))
		idw_Putaway.Retrieve(idw_main.GetITemString(1,'wo_no'))
		
		Return -1
		
   END IF
	
ELSE /*save failed */
	
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, Unable to confirm Putaway records!")
	
	//re-retrive detail and putaway to restore original values
	idw_detail.Retrieve(idw_main.GetITemString(1,'wo_no'))
	idw_Putaway.Retrieve(idw_main.GetITemString(1,'wo_no'))
	
	Return -1
	
END IF

//idw_putaway.Retrieve	(lsWONO)		//Refresh putaway
//reset checkbox on Putaway
for i = 1 to ll_totalrows
	If idw_putaway.GetITemstring(i,'c_confirm_putaway_ind') = 'Y' Then
		idw_putaway.SetItem(i,'c_confirm_putaway_ind','N')
	End If
Next

tab_main.tabpage_putaway.cb_confirm_putaway.Enabled = False

Return 0
end function

public function integer wf_realloc_comp (long alrow, decimal aloldqty, decimal alnewqty);String	lsChildSKU,	&
			lsSKU,		&
			lsSupplier,	&
			lsChildSupplier,	&
			lsCompInd,	&
			lsFind
			
decimal ldParentQTY //GAP 11-02 convert to decimal 	

Long		llChildCount,		&
			llChildPos,			&
			llNewPickRow,		&
			llFindRow
			
u_ds	lds_item_component
str_parms	lstrparms

lds_item_component = Create u_ds
lds_item_component.dataobject = 'd_item_component_parent'
lds_item_component.SetTransObject(SQLCA)

istr_pick_short = lstrparms
ilPickArrayPos = 0 /*reset shortage array */

ldParentQTY = aloldqty - alNewQty /* parent qty is the difference between the old and new */

//If new qty > then orig qty, user will have to manually decrement children
If ldParentQTY < 0 Then
	Messagebox(is_title,'If you increment the FG allocation, you will to~rmanually decrement the children part quantities')
	Return 0
Elseif ldParentQTY = 0 Then /*qty not changed */
	Return 0
End If

lsSKu = idw_pick.GetITemString(alRow,'SKU')
lsSUpplier = idw_pick.GetItemString(alRow,'supp_code')

llChildCOunt = lds_item_component.Retrieve(gs_project,lssku,lsSupplier, "C") /* 08/02 - PCONKL - default component type to 'C' (DW/DB Table also being used for Packaging*/
		
idw_pick.SetRedraw(False)

//Build a pick row for each of the children
For llChildPos = 1 to llChildCount
		
	lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
	lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
					
	//We need the component ind for this child sku (It may also be a parent)
	Select Component_ind Into :lsCompInd
	From Item_master
	Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
	Using SQLCA;
			
	llNewPickRow = idw_Pick.InsertRow(0)
	idw_pick.SetItem(llNewPickRow,'wo_no',idw_main.GetITemString(1,'wo_no'))
	idw_pick.SetItem(llNewPickRow,'line_item_no',idw_Pick.GetITemNumber(alRow,'line_item_no'))
	idw_pick.SetItem(llNewPickRow,'sku',lsChildSKU)
	idw_pick.SetItem(llNewPickRow,'sku_Parent',lsSKU)
	idw_pick.SetItem(llNewPickRow,'supp_code',lsChildSupplier)
	idw_pick.SetItem(llNewPickRow,'owner_id',idw_Pick.GetITemNumber(alRow,'owner_id'))
	idw_pick.SetItem(llNewPickRow,'quantity',ldParentQTY * (lds_item_component.GetItemNumber(llChildPos,"child_qty"))) /*extent parent qty by Child Unit QTY*/
	idw_pick.SetItem(llNewPickRow,'deliver_to_location','XXXXXXXXXXX')
		
	//Retrieve ItemMaster Values (component ind, serialized, lotized, etc.)
	i_nwarehouse.of_item_master(gs_project,lsChildSku,lsChildSupplier,idw_pick,llNewPickRow)
		
	wf_pick_Row(llNewPickRow) /*will combine iwth an existing row if it exists*/
	
Next

lsFind = "deliver_to_location = 'XXXXXXXXXXX'"
llFindRow = idw_pick.Find(lsFind,1,idw_pick.RowCount())
Do While llFindRow > 0
	idw_pick.DEleteRow(llFindRow)
	llFindRow = idw_pick.Find(lsFind,1,idw_pick.RowCount())
Loop

//show any shortages
If ilPickArrayPos > 0 Then
	OpenWithParm(w_pick_exception,istr_pick_short)
End If

idw_pick.SetRedraw(True)


REturn 0
end function

public function integer wf_validation ();Long	llRowCount,	&
		llRowPos,	&
		llCount,		&
		llIdx
		
String	lsLoc, lsWarehouse, lsSKU, lsLot, lsPO, lsFind
DateTime	ldtExpDt

String lsParentSku,lsParentSupplier,lsComponentSku,lsComponentSupplier
Boolean	lbQtyShort, lbCheckBOM

If idw_detail.AcceptText() < 0 Then Return -1
If idw_Pick.AcceptText() < 0 Then Return -1
If idw_Putaway.AcceptText() < 0 Then Return -1
If idw_Serial.AcceptText() < 0 Then Return -1
IF tab_main.tabpage_main.dw_workorder_component_sku.AcceptText() < 0 Then Return -1

//Validate Order Detail Information
llRowCount = idw_Detail.RowCount()
For llRowPos = 1 to llRowCount
	
	//LineItem Required
	If isNull(idw_detail.GetITemNumber(llRowPos,'line_item_no')) or idw_detail.GetITemNumber(llRowPos,'line_item_no') <=0 Then
		tab_main.SelectTab(3)
		idw_detail.SetFocus()
		idw_detail.SetRow(llrowPos)
		idw_detail.SetColumn('line_item_no')
		Messagebox(is_title,'Line Item # is required.')
		Return -1
	End If
	
	//SKU is Required
	If isNull(idw_detail.GetITemString(llRowPos,'SKU')) or idw_detail.GetITemstring(llRowPos,'SKU') = '' Then
		tab_main.SelectTab(3)
		idw_detail.SetFocus()
		idw_detail.SetRow(llrowPos)
		idw_detail.SetColumn('SKU')
		Messagebox(is_title,'SKU is required.')
		Return -1
	End If
	
	//Supplier is Required
	If isNull(idw_detail.GetITemString(llRowPos,'supp_code')) or idw_detail.GetITemstring(llRowPos,'supp_code') = '' Then
		tab_main.SelectTab(3)
		idw_detail.SetFocus()
		idw_detail.SetRow(llrowPos)
		idw_detail.SetColumn('supp_code')
		Messagebox(is_title,'Supplier is required.')
		Return -1
	End If
	
	//Qty Required
	If isNull(idw_detail.GetITemNumber(llRowPos,'req_qty')) or idw_detail.GetITemNumber(llRowPos,'req_qty') <=0 Then
		tab_main.SelectTab(3)
		idw_detail.SetFocus()
		idw_detail.SetRow(llrowPos)
		idw_detail.SetColumn('req_qty')
		Messagebox(is_title,'Req Qty is required.')
		Return -1
	End If
	
	//If Confirmed qty < then ordered qty, we will want to prompt - at end
	//GailM 8/19/2020 DE17072 DE17072 NYCSP - Defect: Do not count components when checking QtyShort
	If (idw_detail.GetITemNumber(llRowPos,'req_qty') > idw_detail.GetITemNumber(llRowPos,'alloc_qty')) And idw_detail.GetItemNumber(llRowPos,'alloc_qty') <> 0 Then
		lbQtyShort = True
	End If
	
Next /*Detail Record */

//Validate Picking Information
llRowCount = idw_Pick.RowCount()

//We won't allow a short Pick to be saved
If llRowCount > 0 And ibPickShort Then
	Messagebox(is_title,'Unable to Pick all of the items required for this order.~r~rYou must delete the Pick List or adjust the Required QTY on the Order Detail tab.',StopSign!)
	REturn -1
End If

For llrowPos = 1 to llRowCount /*For each Picking Record */
	
	//LineItem Required
	If isNull(idw_pick.GetITemNumber(llRowPos,'line_item_no')) or idw_pick.GetITemNumber(llRowPos,'line_item_no') <=0 Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('line_item_no')
		Messagebox(is_title,'Line Item # is required.')
		Return -1
	End If
	
	//SKU Required
	If isNull(idw_pick.GetITemString(llRowPos,'SKU')) or idw_pick.GetITemString(llRowPos,'SKU') = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('SKU')
		Messagebox(is_title,'SKU is required.')
		Return -1
	End If
	
	//Supplier Required
	If isNull(idw_pick.GetITemString(llRowPos,'supp_code')) or idw_pick.GetITemString(llRowPos,'supp_code') = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('supp_code')
		Messagebox(is_title,'Supplier is required.')
		Return -1
	End If
	
	//Inventory Type Required
	If isNull(idw_pick.GetITemString(llRowPos,'Inventory_Type')) or idw_pick.GetITemString(llRowPos,'Inventory_Type') = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('Inventory_Type')
		Messagebox(is_title,'Inventory Type is required.')
		Return -1
	End If
	
	//Country of Origin Required
	If isNull(idw_pick.GetITemString(llRowPos,'Country_of_Origin')) or idw_pick.GetITemString(llRowPos,'Country_of_Origin') = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('Country_of_Origin')
		Messagebox(is_title,'Country of Origin is required.')
		Return -1
	End If
	
	
	//Pick From Location required and Valid
	lsLoc = idw_pick.GetITemString(llRowPos,'l_code')
	If isNull(lsLoc) or lsLoc = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('l_code')
		Messagebox(is_title,'Pick From Location is required.')
		Return -1
	End If
	
	//// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit Skip the location validation because we are picking all and this cannot change
	If idw_main.GetItemString(1,'ord_type') <> 'A' and  idw_main.GetItemString(1,'ord_type') <> 'D' Then
		lsWarehouse = idw_main.GetITemString(1,'wh_code')
		
		Select Count(*) into :llCount
		From Location
		where wh_code = :lsWarehouse and l_code = :lsLoc;
		
		If llCount <= 0 Then /*not found */
			tab_main.SelectTab(4)
			idw_pick.SetFocus()
			idw_pick.SetRow(llrowPos)
			idw_pick.SetColumn('l_code')
			Messagebox(is_title,'Invalid Pick From Location.')
			Return -1
		End if
	
	End if // End Skip for Kit Change
	
	
	//QTY Required
	If isNull(idw_pick.GetITemNumber(llRowPos,'quantity')) or idw_pick.GetITemNumber(llRowPos,'quantity') <=0 Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('quantity')
		Messagebox(is_title,'Quantity is required.')
		Return -1
	End If
	
	//Deliver To Location required and Valid
	lsLoc = idw_pick.GetITemString(llRowPos,'deliver_to_location')
	If isNull(lsLoc) or lsLoc = '' Then
		tab_main.SelectTab(4)
		idw_pick.SetFocus()
		idw_pick.SetRow(llrowPos)
		idw_pick.SetColumn('deliver_to_location')
		Messagebox(is_title,'Deliver To Location is required.')
		Return -1
	End If
	
Next /*Pick Record */

//Validate Putaway Information
llRowCount = idw_Putaway.RowCount()
For llrowPos = 1 to llRowCount
	
	//LineItem Required
	If isNull(idw_putaway.GetITemNumber(llRowPos,'line_item_no')) or idw_putaway.GetITemNumber(llRowPos,'line_item_no') <=0 Then
		tab_main.SelectTab(5)
		idw_putaway.SetFocus()
		idw_putaway.SetRow(llrowPos)
		idw_putaway.SetColumn('line_item_no')
		Messagebox(is_title,'Line Item # is required.')
		Return -1
	End If
	
	//SKU Required
	If isNull(idw_putaway.GetITemString(llRowPos,'SKU')) or idw_putaway.GetITemString(llRowPos,'SKU') = '' Then
		tab_main.SelectTab(5)
		idw_putaway.SetFocus()
		idw_putaway.SetRow(llrowPos)
		idw_putaway.SetColumn('SKU')
		Messagebox(is_title,'SKU is required.')
		Return -1
	End If
	
	//Supplier Required
	If isNull(idw_putaway.GetITemString(llRowPos,'supp_code')) or idw_putaway.GetITemString(llRowPos,'supp_code') = '' Then
		tab_main.SelectTab(5)
		idw_putaway.SetFocus()
		idw_putaway.SetRow(llrowPos)
		idw_putaway.SetColumn('supp_code')
		Messagebox(is_title,'Supplier is required.')
		Return -1
	End If
	
	//Inventory Type Required
	If isNull(idw_putaway.GetITemString(llRowPos,'inventory_type')) or idw_putaway.GetITemString(llRowPos,'inventory_type') = '' Then
		tab_main.SelectTab(5)
		idw_putaway.SetFocus()
		idw_putaway.SetRow(llrowPos)
		idw_putaway.SetColumn('inventory_type')
		Messagebox(is_title,'Inventory Type is required.')
		Return -1
	End If	
	
			//Jxlim 01/27/2010 Validate Serialized, Serialized Type of 'B' = capturing both Inbound and Outbound but not writing to Content
			If idw_putaway.GetITemString(llRowPos,'serialized_ind') = 'Y' or idw_putaway.GetITemString(llRowPos,'serialized_ind') = 'B' Then
				If idw_putaway.GetItemString(llRowPos,'serial_no') = '-' or isnull(idw_putaway.GetItemString(llRowPos,'serial_no')) or Trim(idw_putaway.GetItemString(llRowPos,'serial_no')) = '' Then
					MessageBox(is_title, "Serial Numbers must be entered for serialized parts!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "serial_no")
					Return -1
				ElseIf idw_putaway.GetITemNumber(llRowPos,'quantity') <> 1 Then
					MessageBox(is_title, "Quantity must be 1 for serialized parts!", StopSign!)	
					tab_main.SelectTab(5)
					f_setfocus(idw_putaway, llRowPos, "quantity")
					Return -1
				End If
			End If /*Serialized */
			
			//Check for Lot Required
			If idw_putaway.GetITemString(llRowPos,'lot_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(llRowPos,'lot_no') = '-' or isnull(idw_putaway.GetItemString(llRowPos,'lot_no')) or Trim(idw_putaway.GetItemString(llRowPos,'lot_no')) = '' Then
					MessageBox(is_title, "Lot Numbers must be entered!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "lot_no")
					Return -1
				End If
			End If /*Lot Required*/
			
			//Check for PO Required
			If idw_putaway.GetITemString(llRowPos,'po_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(llRowPos,'po_no') = '-' or isnull(idw_putaway.GetItemString(llRowPos,'po_no')) or Trim(idw_putaway.GetItemString(llRowPos,'po_no')) = '' Then
					MessageBox(is_title, "PO Numbers must be entered!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "po_no")
					Return -1
				End If
			End If /*PO Required*/
			
			//Check for PO2 Required
			If idw_putaway.GetITemString(llRowPos,'po_no2_controlled_ind') = 'Y' Then
				If idw_putaway.GetItemString(llRowPos,'po_no2') = '-' or isnull(idw_putaway.GetItemString(llRowPos,'po_no2')) or Trim(idw_putaway.GetItemString(llRowPos,'po_no2')) = '' Then
					MessageBox(is_title, "PO2 Numbers must be entered!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "po_no2")
					Return -1
				End If
			End If /*PO2 Required*/
			
			//Check for Container Required
			If idw_putaway.GetITemString(llRowPos,'container_tracking_ind') = 'Y' Then
				If idw_putaway.GetItemString(llRowPos,'container_ID') = '-' or isnull(idw_putaway.GetItemString(llRowPos,'container_ID')) or Trim(idw_putaway.GetItemString(llRowPos,'container_id')) = '' Then
					MessageBox(is_title, "Container ID must be entered!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "container_ID")
					Return -1
				End If
			End If /*Container Required*/
						
			//Check for Expiration Date Required
			If idw_putaway.GetITemString(llRowPos,'expiration_Controlled_ind') = 'Y' Then
				If isnull(idw_putaway.GetItemDateTime(llRowPos,'expiration_Date')) or String(idw_putaway.GetItemDateTime(llRowPos,'expiration_Date'),'mm/dd/yyyy') = '12/31/2999' Then
					MessageBox(is_title, "Expiration Date must be entered!", StopSign!)	
					tab_main.SelectTab(5) 
					f_setfocus(idw_putaway, llRowPos, "expiration_Date")
					Return -1
				End If
			End If /*Expiration Date Required*/
	
			//Location is Required only when confirming Putaway
			If ibConfirmRequested Then
				
				If isNull(idw_putaway.GetITemString(llRowPos,'l_code')) or idw_putaway.GetITemString(llRowPos,'l_code') = '' Then
					tab_main.SelectTab(5)
					idw_putaway.SetFocus()
					idw_putaway.SetRow(llrowPos)
					idw_putaway.SetColumn('l_code')
					Messagebox(is_title,'Putaway Location is required.')
					Return -1
				End If
				
				//All Putaway Rows must be confirmed to Stock before the order can be confirmed
				If isNull(idw_putaway.GetITemString(llRowPos,'user_field2')) or idw_putaway.GetITemString(llRowPos,'user_field2') = '' Then
					tab_main.SelectTab(5)
					idw_putaway.SetFocus()
					Messagebox(is_title,'All Items in Putaway List must be confirmed before the order can be confirmed!')
					Return -1
				End If
				
	End If /*Confirm requested */
	
	// 07/04 - PCONKL - For logitech, we need to validate that the Lot,PO and Exp Dt are those that were entered on the Picking List if the item being picked is the same being putaway
	If upper(gs_project) = 'LOGITECH' Then
		
		lsSKU = idw_putaway.GetITemString(llRowPos,'sku')
		lsLot = idw_putaway.GetITemString(llRowPos,'lot_no')
		lsPO = idw_putaway.GetITemString(llRowPos,'po_no')
		ldtExpDt = idw_putaway.GetITemdateTime(llRowPos,'expiration_Date')
		
		If idw_pick.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,idw_Pick.RowCount()) > 0 Then /*putting away the same SKU as picking*/
		
			//make sure we have a pick row for this sku/lot/po/exp dt
			lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(lot_no) = '" + Upper(lsLot) + "' and Upper(po_no) = '" + Upper(lsPO) + "' and String(expiration_date,'mm/dd/yyyy') = '" + String(ldtExpDt,'mm/dd/yyyy') + "'"
			If idw_Pick.Find(lsFind,1,idw_Pick.RowCount()) <= 0 then
				Messagebox(is_title,'Pedimento Number, Port of Entry or Pedimento Date~rdo not match an entry on the Pick List!',StopSign!)
				tab_main.SelectTab(5)
				idw_putaway.SetFocus()
				idw_putaway.SetRow(llrowPos)
				idw_putaway.SetColumn('lot_no')
				Return -1
			End If
		
		End If /* same SKU on pick/putaway*/
	
	End If /*Logitech*/

Next /*Putaway rec */

//If Putaway short, give user option to stop confirmation
If lbQtyShort and ibConfirmRequested Then
	If Messagebox(is_title,'Not all ordered Finished Goods have been Putaway.~r~rIf there are any remaining items to return to inventory~rThey must be entered manually on the Putaway List.~r~rDo you still want to confirm this order?',Question!,YesNo!,2) = 2 Then
		Return -1
	End If
End If


If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then

	IF tab_main.tabpage_main.dw_workorder_component_sku.RowCount() > 0 THEN
	
		FOR llIdx = 1 to  tab_main.tabpage_main.dw_workorder_component_sku.RowCount()
		
			If isNull(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(llIdx,'component_sku')) or &
				trim(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(llIdx,'component_sku')) = '' Then
				tab_main.SelectTab(1)
				tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
				tab_main.tabpage_main.dw_workorder_component_sku.SetRow(llIdx)
				tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('component_sku')
				Messagebox(is_title,'Component Sku is required.')
				Return -1
			End If
			
			If isNull(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(llIdx,'userfield_1')) or &
				trim(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(llIdx,'userfield_1')) = '' Then
				tab_main.SelectTab(1)
				tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
				tab_main.tabpage_main.dw_workorder_component_sku.SetRow(llIdx)
				tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('userfield_1')
				If idw_main.GetItemString(1,'ord_type') = 'A'  Then
					Messagebox(is_title,'Component Quantity is required.')
				Else
					Messagebox(is_title,'Component Putaway Location is required.')
				End IF
				Return -1
			End If		
			
			If idw_main.GetItemString(1,'ord_type') = 'A'  Then
				If not isNumber(tab_main.tabpage_main.dw_workorder_component_sku.GetITemString(llIdx,'userfield_1')) Then
					Messagebox(is_title,'Component Quantity is must be numeric.')
					tab_main.SelectTab(1)
					tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
					tab_main.tabpage_main.dw_workorder_component_sku.SetRow(llIdx)
					tab_main.tabpage_main.dw_workorder_component_sku.SetColumn('userfield_1')
					Return -1
				End If
			End If
		NEXT
	End IF
End If

//TAM 2016/02/10 - VALIDATE UF1 is Required for NYX
If upper(gs_project) = 'NYX' Then
		If isNull(idw_main.GetITemString(1,'User_Field1')) or trim(idw_main.GetITemString(1,'User_Field1')) = '' Then
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			idw_main.SetRow(llrowPos)
			idw_main.SetColumn('user_field1')
			Messagebox(is_title,'Customer PO# is required.')
			Return -1
		End If
END IF /*NYX*/

If upper(gs_project) = 'RIVERBED' Then
	//Validate Order Detail Information
	llRowCount = idw_Serial.RowCount()
	For llRowPos = 1 to llRowCount
		
		//LineItem Required
		If isNull(idw_Serial.GetITemString(llRowPos,'serial_no')) or trim(idw_Serial.GetITemString(llRowPos,'serial_no')) = '' Then
			tab_main.SelectTab(5)
			idw_Serial.SetFocus()
			idw_Serial.SetRow(llrowPos)
			idw_Serial.SetColumn('serial_no')
			Messagebox(is_title,'Serial No is required.')
			Return -1
		End If
		
		
	Next
END IF /*Riverbed*/

Return 0
end function

public function integer wf_check_status ();
isle_order.DisplayOnly = True
isle_order.TabOrder = 0

Choose Case idw_main.GetItemString(1,"ord_status")
		
	Case "N" /*New */
		
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_print.Enabled = False
		im_menu.m_file.m_refresh.Enabled = True
		im_menu.m_record.m_delete.Enabled = True
		
		If ib_edit Then
			im_menu.m_record.m_delete.Enabled = True
			im_menu.m_file.m_retrieve.Enabled = True
		Else
			im_menu.m_record.m_delete.Enabled = False
			im_menu.m_file.m_retrieve.Enabled = False
		End If
		
		tab_main.tabpage_detail.Enabled = True
		
		If ib_edit Then
			tab_main.tabpage_instructions.Enabled = True
			tab_main.tabpage_picking.Enabled = True
			tab_main.tabpage_cto_process.Enabled = True		
			tab_main.tabpage_putaway.Enabled = True			
		Else
			tab_main.tabpage_instructions.Enabled = False
			tab_main.tabpage_picking.Enabled = False
			tab_main.tabpage_cto_process.Enabled = False	
			tab_main.tabpage_Putaway.Enabled = False			
		End If
		
		idw_detail.object.Datawindow.ReadOnly = "NO"
		idw_pick.object.Datawindow.ReadOnly = "NO"
		idw_Putaway.object.Datawindow.ReadOnly = "NO"
		idw_detail.object.Datawindow.ReadOnly = "NO"
		
		Tab_main.tabpage_detail.cb_insert_Detail.Enabled = True
		Tab_main.tabpage_detail.cb_Delete_Detail.Enabled = True
		Tab_main.tabpage_picking.cb_insert_Pick.Enabled = True
		Tab_main.tabpage_picking.cb_Delete_Pick.Enabled = True
		Tab_main.tabpage_picking.cb_generate_Pick.Enabled = True
		Tab_main.tabpage_Putaway.cb_insert_Putaway.Enabled = True
		Tab_main.tabpage_Putaway.cb_Delete_Putaway.Enabled = True
		Tab_main.tabpage_Putaway.cb_Generate_Putaway.Enabled = True
		Tab_main.tabpage_instructions.cb_Maintain_Instructions.Enabled = True
		
		Tab_main.tabpage_main.cb_confirm.Enabled = False
		Tab_main.tabpage_main.cb_void.Enabled = True
		
		Tab_main.tabpage_cto_process.cb_generate.Enabled = False
		
		 tab_main.tabpage_main.dw_workorder_component_sku.object.Datawindow.ReadOnly = "NO"
		tab_main.tabpage_main.cb_component_sku_add.Enabled = True
		tab_main.tabpage_main.cb_component_sku_delete.Enabled = True
		tab_main.tabpage_main.cb_component_sku_import.Enabled = True		
		
		
	Case "P", "F" /*Picking or FG Putaway*/
		      	
		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = True
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_detail.Enabled = True
		tab_main.tabpage_picking.Enabled = True
		tab_main.tabpage_cto_process.Enabled = True	
		tab_main.Tabpage_putaway.Enabled = True
		tab_main.tabpage_instructions.Enabled = True
		
		Tab_main.tabpage_detail.cb_insert_Detail.Enabled = True
		Tab_main.tabpage_detail.cb_Delete_Detail.Enabled = True
		
		//Cant modify Pick if alredy generated Putaway
		If idw_Putaway.RowCount() > 0 Then
			Tab_main.tabpage_picking.cb_insert_Pick.Enabled = False
			Tab_main.tabpage_picking.cb_Delete_Pick.Enabled = false
			Tab_main.tabpage_picking.cb_generate_Pick.Enabled = False
		Else
			Tab_main.tabpage_picking.cb_insert_Pick.Enabled = True
			Tab_main.tabpage_picking.cb_Delete_Pick.Enabled = True
			Tab_main.tabpage_picking.cb_generate_Pick.Enabled = True
		End If
		
		Tab_main.tabpage_Putaway.cb_insert_Putaway.Enabled = True
		Tab_main.tabpage_Putaway.cb_Delete_Putaway.Enabled = True
		Tab_main.tabpage_Putaway.cb_Generate_Putaway.Enabled = True
		Tab_main.tabpage_instructions.cb_Maintain_Instructions.Enabled = True
		
		Tab_main.tabpage_main.cb_confirm.Enabled = True
		Tab_main.tabpage_main.cb_void.Enabled = True
		
		idw_detail.object.Datawindow.ReadOnly = "NO"
		idw_pick.object.Datawindow.ReadOnly = "NO"
		idw_Putaway.object.Datawindow.ReadOnly = "NO"
		idw_detail.object.Datawindow.ReadOnly = "NO"
		
		Tab_main.tabpage_cto_process.cb_generate.Enabled = True
		
   	    tab_main.tabpage_main.dw_workorder_component_sku.object.Datawindow.ReadOnly = "YES"
		tab_main.tabpage_main.cb_component_sku_add.Enabled = False
		tab_main.tabpage_main.cb_component_sku_delete.Enabled = False
		tab_main.tabpage_main.cb_component_sku_import.Enabled = False
		
	CASE "C"  /*Complete*/

		im_menu.m_file.m_save.Enabled = True
		im_menu.m_file.m_retrieve.Enabled = True
		im_menu.m_file.m_print.Enabled = True
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_detail.Enabled = True
		tab_main.tabpage_picking.Enabled = True
		tab_main.tabpage_putaway.Enabled = True
		tab_main.tabpage_instructions.Enabled = True
		tab_main.tabpage_cto_process.Enabled = True	
		
		idw_detail.object.Datawindow.ReadOnly = "Yes"
		idw_pick.object.Datawindow.ReadOnly = "Yes"
		idw_Putaway.object.Datawindow.ReadOnly = "Yes"
		idw_detail.object.Datawindow.ReadOnly = "Yes"
		
		Tab_main.tabpage_detail.cb_insert_Detail.Enabled = False
		Tab_main.tabpage_detail.cb_Delete_Detail.Enabled = False
		Tab_main.tabpage_picking.cb_insert_Pick.Enabled = False
		Tab_main.tabpage_picking.cb_Delete_Pick.Enabled = False
		Tab_main.tabpage_picking.cb_generate_Pick.Enabled = False
		Tab_main.tabpage_Putaway.cb_insert_Putaway.Enabled = False
		Tab_main.tabpage_Putaway.cb_Delete_Putaway.Enabled = False
		Tab_main.tabpage_Putaway.cb_Generate_Putaway.Enabled = False
		Tab_main.tabpage_instructions.cb_Maintain_Instructions.Enabled = False
		
		Tab_main.tabpage_main.cb_confirm.Enabled = False
		Tab_main.tabpage_main.cb_void.Enabled = False
		
		Tab_main.tabpage_cto_process.cb_generate.Enabled = False

   	    tab_main.tabpage_main.dw_workorder_component_sku.object.Datawindow.ReadOnly = "YES"
		tab_main.tabpage_main.cb_component_sku_add.Enabled = False
		tab_main.tabpage_main.cb_component_sku_delete.Enabled = False
		tab_main.tabpage_main.cb_component_sku_import.Enabled = False			
		
	CASE "V" /*Void*/
		
		im_menu.m_file.m_save.Enabled = False
		im_menu.m_file.m_retrieve.Enabled = False
		im_menu.m_file.m_print.Enabled = False
		im_menu.m_file.m_refresh.Enabled = False
		im_menu.m_record.m_delete.Enabled = False
		
		tab_main.tabpage_detail.Enabled = True
		tab_main.tabpage_picking.Enabled = True
		tab_main.tabpage_cto_process.Enabled = True	
		tab_main.tabpage_putaway.Enabled = True
      tab_main.tabpage_instructions.Enabled = True
		
		idw_Main.object.Datawindow.ReadOnly = "Yes"
		idw_detail.object.Datawindow.ReadOnly = "Yes"
		idw_pick.object.Datawindow.ReadOnly = "Yes"
		idw_Putaway.object.Datawindow.ReadOnly = "Yes"
		idw_detail.object.Datawindow.ReadOnly = "Yes"
		
		Tab_main.tabpage_detail.cb_insert_Detail.Enabled = False
		Tab_main.tabpage_detail.cb_Delete_Detail.Enabled = False
		Tab_main.tabpage_picking.cb_insert_Pick.Enabled = False
		Tab_main.tabpage_picking.cb_Delete_Pick.Enabled = False
		Tab_main.tabpage_picking.cb_generate_Pick.Enabled = False
		Tab_main.tabpage_Putaway.cb_insert_Putaway.Enabled = False
		Tab_main.tabpage_Putaway.cb_Delete_Putaway.Enabled = False
		Tab_main.tabpage_Putaway.cb_Generate_Putaway.Enabled = False
		Tab_main.tabpage_instructions.cb_Maintain_Instructions.Enabled = False
		
		Tab_main.tabpage_main.cb_confirm.Enabled = False
		Tab_main.tabpage_main.cb_void.Enabled = False
		
		Tab_main.tabpage_cto_process.cb_generate.Enabled = False
		
   	     tab_main.tabpage_main.dw_workorder_component_sku.object.Datawindow.ReadOnly = "YES"
		tab_main.tabpage_main.cb_component_sku_add.Enabled = False
		tab_main.tabpage_main.cb_component_sku_delete.Enabled = False
		tab_main.tabpage_main.cb_component_sku_import.Enabled = False			
		
End Choose
//GAP 11/02 - Hide any unused lottable fields
i_nwarehouse.of_hide_unused(idw_pick)
i_nwarehouse.of_hide_unused(idw_putaway)

Return 0
end function

public function integer wf_update_content ();
//Decrementing Picked Items from Content - Allocation process
decimal  ld_req, ld_avail //gap 11/02 convert to decimal 
Integer	liRC
long i, j, k, ll_currow, ll_totalrows, ll_content_cnt,ll_owner_id,llComponent,llID,llLineItemNo
long llDetailRow //TAM Added find on detail row
string ls_sku,ls_whcode,ls_lcode,ls_itype,ls_sno,ls_lno, lsWONO, ls_status, ls_ro,ls_pono,ls_supp_code //GAP 11-02 took out variable "shit" and deleted all references!
String ls_coo, ls_po_no2,ls_find_string , lsCompInd,lsSkuParent, lsFindHold, ls_container_id  //GAP 11-02 added containerid
datetime ldt_expiration_date //GAP 11-02 added expiration date
dwitemstatus ldis_status
//TAM - 2018/10 - S23683 - Fix delete to return to Component QTY instead of Avail QTY
long ll_avail 		
long ll_comp 		

ids_content.Reset()
ids_content.SetFilter("")
idw_pick_detail.Reset()
idw_pick.Sort()

ls_whcode = idw_main.getitemstring(1,'wh_code')

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 
//ldtToday = datetime( today(), now() )

lsWONO = idw_main.getitemstring(1,'wo_no')
ls_status = idw_main.getitemstring(1,'ord_status')

// Retrieve related content records for all modified rows
// not being reset before each retrieve (return 2 in retrievstart event!!!!)
long llpick_count
llpick_count = idw_pick.rowcount()
for i = 1 to idw_pick.rowcount()
	
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	if ldis_status <> NewModified! and ldis_status <> DataModified! then continue
	
	ls_sku = idw_pick.getitemstring(i,'sku')
	ls_supp_code = idw_pick.getitemstring(i,'supp_code')
	ls_coo = idw_pick.getitemstring(i,'country_of_origin')
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id')
	ls_po_no2 = idw_pick.getitemstring(i,'po_no2')
	ls_container_id  = idw_pick.getitemstring(i,'container_id')
	ldt_expiration_date  = idw_pick.getitemdatetime(i,'expiration_date')
	ls_lcode = idw_pick.getitemstring(i,'l_code')
	//If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind') = 'O' Then
		ls_sno = '-'
	Else
		ls_sno = idw_pick.getitemstring(i,'serial_no')
	End If
	ls_lno = idw_pick.getitemstring(i,'lot_no')
	ls_pono = idw_pick.getitemstring(i,'po_no')
	ls_itype = idw_pick.getitemstring(i,'inventory_type')
	
	// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Use the Warehous code from  the detail screen (UF1)
	If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then
//		ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
//		ls_find_string += " and line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
		ls_find_string = "line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
		llDetailRow = idw_Detail.Find(ls_find_String,1,idw_Detail.RowCount())  
		If llDetailRow > 0 Then
			ls_whCode  = idw_detail.getitemstring(llDetailRow,'user_field1')
		End If
	End If
		
	//We only want to retrieve the rows once - we may have multiple pick rows that will retrieve the same content rows (only line item different).
	ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
	ls_find_string += " and owner_id = " + String(ll_owner_id) + " and upper(country_of_origin) = '" + Upper(ls_coo) + "'"
	ls_Find_String += " and Upper(l_code) = '" + Upper(ls_lCode) + "' and Upper(serial_no) = '" + Upper(ls_sno) + "'"
	ls_Find_String += " and Upper(lot_no) = '" + Upper(ls_lno) + "' and Upper(po_no) = '" + Upper(ls_pono) + "'"
	ls_Find_String += " and Upper(po_no2) = '" + Upper(ls_po_no2) + "' and Upper(inventory_type) = '" + Upper(ls_itype) + "'"
	ls_Find_String += " and Upper(wh_code) = '" + Upper(ls_whCode) + "'" //TAM DE6236 -added warhouse code to find because Component add and delete span multiple warehouses
	ls_find_string += " and Upper(container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + string(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "' "
	If ids_Content.Find(ls_find_String,1,ids_Content.RowCount()) <=0 Then

		// TAM 2011/01  Change to use a content dw for workorders.  We are getting a problem because the expiration date in content contains milliseconds.  WO is not using server picking.  On the server the expiration date is bracketed with.000 and .999 milliseconds in the where clause.
		// We need to do this on this datawindow.  I did not want to change d_do_content.
		string  ls_expiration_from,  ls_expiration_to
		ls_expiration_from= string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.000'
		ls_expiration_to = string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.999'

//		ll_content_cnt = Ids_Content.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, ls_container_id, ldt_expiration_date) //GAP 11-02 
		ll_content_cnt = Ids_Content.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, ls_container_id, ls_expiration_from, ls_expiration_to) //GAP 11-02 
	End If
	
next

// Return original values of modified old records to content table
for i = 1 to idw_pick.rowcount() /*For each Pick Row*/
		
	ldis_status = idw_pick.getitemstatus(i,0,Primary!)
	if ldis_status <> DataModified! and ls_status <> "V" then Continue

	ls_sku = Upper(idw_pick.getitemstring(i,'sku',Primary!,True))
	ls_supp_code = Upper(idw_pick.getitemstring(i,'supp_code',Primary!,True))
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id',Primary!,True)
	ls_coo = Upper(idw_pick.getitemstring(i,'country_of_origin',Primary!,True))
	ls_po_no2 = Upper(idw_pick.getitemstring(i,'po_no2',Primary!,True))
	ls_container_id = Upper(idw_pick.getitemstring(i,'container_id',Primary!,True))		 //GAP 11-02 
	ldt_expiration_date = idw_pick.getitemdatetime(i,'expiration_date',Primary!,True)	 //GAP 11-02 
	ls_lcode = Upper(idw_pick.getitemstring(i,'l_code',Primary!,True))
	//If capturing serial # on outbound, ignore value on Pick List
	If idw_pick.getitemstring(i,'serialized_ind') = 'O' Then
		ls_sno = '-'
	Else
		ls_sno = Upper(idw_pick.getitemstring(i,'serial_no',Primary!,True))
	End If
	ls_lno = Upper(idw_pick.getitemstring(i,'lot_no',Primary!,True))
	ls_itype = idw_pick.getitemstring(i,'inventory_type',Primary!,True)
	ls_pono = Upper(idw_pick.getitemstring(i,'po_no',Primary!,True))
	llLineItemNo = idw_pick.getitemnumber(i,'Line_Item_no') /* 09/01 PCONKL */
	llComponent = idw_pick.getitemnumber(i,'Component_no') /* TAM - 2014/04 */
	lsCompInd = Upper(idw_pick.getitemstring(i,'Component_Ind',Primary!,True))

	// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Use the Warehous code from  the detail screen (UF1)
	If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then
//		ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
//		ls_find_string += "and line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
		ls_find_string = "line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
		llDetailRow = idw_Detail.Find(ls_find_String,1,idw_Detail.RowCount())  
		If llDetailRow > 0 Then
			ls_whCode  = idw_detail.getitemstring(llDetailRow,'user_field1')
		End If
	End If
	
	idw_pick_detail.retrieve(lsWONO, ls_sku, ls_supp_code,ll_Owner_Id,ls_coo,ls_lcode, ls_itype, ls_sno, ls_lno, ls_pono,ls_po_no2,llLineItemNo, ls_container_id, ldt_expiration_date) //GAP 11-02 
	
	ll_totalrows = idw_pick_detail.RowCount()
	
	If ll_totalrows <= 0 Then
		MessageBox(is_title, "System error 10002, please contact system support!", StopSign!)
		Return -1
	End If
	
	ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '" &
            		 + ls_supp_code + & 
	   				"' and Upper(l_code) = '" + ls_lcode + "' and upper(country_of_origin) = '" + ls_coo + "'" + &
						" and owner_id = " + string(ll_owner_id) + &
						" and Upper(po_no2) = '" + ls_po_no2 + &
						"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
						+ ls_lno + "' and upper(po_no) = '" + ls_pono +  &
						"' and inventory_type = '" + ls_itype + "'" + &
						" and Upper(container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + string(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "' "
	
	k = ids_content.Find(ls_find_string, 1, ids_content.RowCount())
	If k	<= 0 Then
		// TAM 2011/01  Change to use a content dw for workorders.  We are getting a problem because the expiration date in content contains milliseconds.  WO is not using server picking.  On the server the expiration date is bracketed with.000 and .999 milliseconds in the where clause.
		// We need to do this on this datawindow.  I did not want to change d_do_content.
//		ll_content_cnt = Ids_Content.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, ls_container_id, ldt_expiration_date) //GAP 11-02 
		ls_expiration_from= string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.000'
		ls_expiration_to = string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.999'
		ll_content_cnt = Ids_Content.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, ls_container_id, ls_expiration_from, ls_expiration_to) //GAP 11-02 
	End If
	
	for j = 1 to ll_totalrows /*for each Pick Detail Row*/
		
		ls_ro = idw_pick_detail.GetItemString(j,'ro_no')
		ll_currow = ids_content.Find(ls_find_string + "and inventory_type ='" + ls_itype+"' and ro_no = '" + ls_ro + "'",1, ids_content.RowCount())
		If ll_currow <= 0 Then
			ll_currow = ids_content.InsertRow(0)
			ids_content.setitem(ll_currow,'project_id',gs_project)
			ids_content.setitem(ll_currow,'ro_no',ls_ro)
			ids_content.setitem(ll_currow,'sku',ls_sku)
			ids_content.setitem(ll_currow,'supp_code',ls_supp_code)
			// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Use the Warehous code from  the detail screen (UF1)
			If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then
//				ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
//				ls_find_string += " and line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
				ls_find_string = " line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no')) 
				llDetailRow = idw_Detail.Find(ls_find_String,1,idw_Detail.RowCount())  
				If llDetailRow > 0 Then
					ls_whCode  = idw_detail.getitemstring(llDetailRow,'user_field1')
				End If
			End If			
			ids_content.setitem(ll_currow,'wh_code',ls_whcode)
			ids_content.setitem(ll_currow,'owner_id',ll_owner_id)
			ids_content.setitem(ll_currow,'country_of_origin',ls_coo)
			ids_content.setitem(ll_currow,'po_no2',ls_po_no2)
			ids_content.setitem(ll_currow,'container_id',ls_container_id)			//GAP 11-02		
			ids_content.setitem(ll_currow,'expiration_date',ldt_expiration_date)	//GAP 11-02				
			ids_content.setitem(ll_currow,'l_code',ls_lcode)
			ids_content.setitem(ll_currow,'inventory_type',ls_itype)
			ids_content.setitem(ll_currow,'serial_no',ls_sno)
			ids_content.setitem(ll_currow,'lot_no', ls_lno)
			ids_content.setitem(ll_currow,'po_no', ls_pono)
			ids_content.setitem(ll_currow,'reason_cd', '')
			ids_content.setitem(ll_currow,'avail_qty', 0)
			ids_content.setitem(ll_currow,'component_qty', 0)
			ids_content.setitem(ll_currow,'last_user',gs_userid)
			ids_content.setitem(ll_currow,'last_update', ldtToday  )
//			If isnull(llComponent) Then llComponent = 0 /* 06/01 PConkl */
			//ids_content.setitem(ll_currow,'component_no',0) /* 10/00 PCONKL */
			// TAM - Kit Change Functionality  Get Component No from Picking row
			If isnull(llComponent) Then 
				llComponent = 0 /* 06/01 PConkl */
			else	
				ids_content.setitem(ll_currow,'component_no', llComponent  )
			End If

		//	ids_content.setitem(ll_currow,'complete_date',idw_pick_detail.GetItemDateTime(j,'complete_date'))
		End If
 
 // TAM - Kit Change Functionality -If order Type is  "D" kit change delete and item is a component  then Use the Component QTY instead of the Avail QTY
		If idw_main.GetItemString(1,'ord_type') = 'D' and lsCompInd= '*' Then
			ll_comp =  ids_content.getitemnumber(ll_currow, "component_qty") + idw_pick_detail.GetItemNumber(j,'quantity')
			ll_avail =  0
			ids_content.setitem(ll_currow,'component_qty', ids_content.getitemnumber(ll_currow, "component_qty") + &
			idw_pick_detail.GetItemNumber(j,'quantity'))
		Else
			ll_avail =  ids_content.getitemnumber(ll_currow, "avail_qty") + idw_pick_detail.GetItemNumber(j,'quantity')
		End If
		ids_content.setitem(ll_currow,'avail_qty', ll_avail)
//		ids_content.setitem(ll_currow,'avail_qty', ids_content.getitemnumber(ll_currow, "avail_qty") + &
//				idw_pick_detail.GetItemNumber(j,'quantity'))--
				
	next /*Next Pick Detail*/
	
	for j = ll_totalrows to 1 Step -1
		idw_pick_detail.DeleteRow(j)
	next
	
next /*Next Pick*/

// Return deleted rows to content table
for i = 1 to idw_pick.deletedcount()
			
	ldis_status = idw_pick.getitemstatus(i,0,Delete!)
	if ldis_status = New! or ldis_status = NewModified! then Continue

	// 06/00 PCONKL - Find is case sensitive!!
	ls_sku = Upper(idw_pick.getitemstring(i,'sku',Delete!,True))
	ls_supp_code = Upper(idw_pick.getitemstring(i,'supp_code',Delete!,True))
	ll_owner_id = idw_pick.getitemnumber(i,'owner_id',Delete!,True)
	ls_coo = Upper(idw_pick.getitemstring(i,'country_of_origin',Delete!,True))
	ls_po_no2 = Upper(idw_pick.getitemstring(i,'po_no2',Delete!,True))
	ls_container_id = Upper(idw_pick.getitemstring(i,'container_id',Delete!,True))		 //GAP 11-02 
	ldt_expiration_date = idw_pick.getitemdatetime(i,'expiration_date',Delete!,True)	 //GAP 11-02 	
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
	llLineItemNo = idw_pick.getitemnumber(i,'line_Item_No',Delete!,True) /* 09/01 PCONKL */
	// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete then Use the Warehous code from  the detail screen (UF1)
	llComponent = idw_pick.getitemnumber(i,'Component_No',Delete!,True) /* 09/01 PCONKL */
	lsCompInd = Upper(idw_pick.getitemstring(i,'Component_Ind',Primary!,True))
	If idw_main.GetItemString(1,'ord_type') = 'A' or  idw_main.GetItemString(1,'ord_type') = 'D' Then
//		ls_find_string = "Upper(sku) = '" + Upper(ls_SKU) + "' and Upper(supp_code) = '" + Upper(ls_supp_Code) + "'"
//		ls_find_string += " and line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no',Delete!,True)) 
		ls_find_string = "line_item_no = " + String(idw_pick.getitemnumber(i,'line_item_no',Delete!,True)) 
		llDetailRow = idw_Detail.Find(ls_find_String,1,idw_Detail.RowCount())  
		If llDetailRow > 0 Then
				ls_whCode  = idw_detail.getitemstring(llDetailRow,'user_field1')
		End If
	End If			
	
	idw_pick_detail.retrieve(lsWONO, ls_sku, ls_supp_code,ll_owner_id,ls_coo, ls_lcode, ls_itype, ls_sno, ls_lno, ls_pono,ls_po_no2,llLineItemNo, ls_container_id, ldt_expiration_date) //GAP 11-02 
	ll_totalrows = idw_pick_detail.RowCount()
	
	If ll_totalrows <= 0 Then
		MessageBox(is_title, "System error 10001, please contact system support!", StopSign!)
		Return -1
	End If

	// 10/00 PCONKL - Include Component in Find
	ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '" &
            		 + ls_supp_code + & 
	   				"' and Upper(l_code) = '" + ls_lcode + "' and Upper(country_of_origin) = '" + ls_coo + "'" + &
						" and owner_id = " + string(ll_owner_id) + &
						" and Upper(po_no2) = '" + ls_po_no2 + &
						"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
						+ ls_lno + "' and upper(po_no) = '" + ls_pono +  &
						"' and inventory_type = '" + ls_itype + "'" + &
						" and Upper(container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + string(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "' "
	long cntrowcnt	
	cntrowcnt = ids_content.RowCount()
	k = ids_content.Find(ls_find_string, 1, ids_content.RowCount())

	If k	<= 0 Then
		// TAM 2011/01  Change to use a content dw for workorders.  We are getting a problem because the expiration date in content contains milliseconds.  WO is not using server picking.  On the server the expiration date is bracketed with.000 and .999 milliseconds in the where clause.
		// We need to do this on this datawindow.  I did not want to change d_do_content.
		ls_expiration_from= string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.000'
		ls_expiration_to = string(ldt_expiration_date,'mm/dd/yyyy hh:mm:ss') + '.999'
		ll_content_cnt = Ids_Content.retrieve(gs_project, ls_whcode, ls_sku, ls_supp_code,ll_owner_id,ls_coo,ls_lcode, ls_sno, ls_lno, ls_pono,ls_po_no2, ls_itype, ls_container_id, ls_expiration_from, ls_expiration_to) //GAP 11-02 
	End If
	
	for j = 1 to ll_totalrows /*For Each Pick Detail */
		
		ls_ro = idw_pick_detail.GetItemString(j,'ro_no')
		ll_currow = ids_content.Find(ls_find_string + "and inventory_type ='"+ls_itype+"' and ro_no = '" + ls_ro + "'",1, ids_content.RowCount())
		
		If ll_currow <= 0 Then
			ll_currow = ids_content.InsertRow(0)
			ids_content.setitem(ll_currow,'project_id',gs_project)
			ids_content.setitem(ll_currow,'sku',ls_sku)
			ids_content.setitem(ll_currow,'supp_code',ls_supp_code)
			ids_content.setitem(ll_currow,'country_of_origin',ls_coo)
			ids_content.setitem(ll_currow,'owner_id',ll_owner_id)
			ids_content.setitem(ll_currow,'wh_code',ls_whcode)
			ids_content.setitem(ll_currow,'l_code',ls_lcode)
			ids_content.setitem(ll_currow,'inventory_type',ls_itype)
			ids_content.setitem(ll_currow,'serial_no',ls_sno)
			ids_content.setitem(ll_currow,'lot_no', ls_lno)
			ids_content.setitem(ll_currow,'ro_no',ls_ro)
			ids_content.setitem(ll_currow,'po_no',ls_pono)
			ids_content.setitem(ll_currow,'po_no2',ls_po_no2)

			ids_content.setitem(ll_currow,'container_id',ls_container_id)			//GAP 11-02		
			ids_content.setitem(ll_currow,'expiration_date',ldt_expiration_date)	//GAP 11-02							
			
			ids_content.setitem(ll_currow,'reason_cd','')
			ids_content.setitem(ll_currow,'avail_qty', 0)
			ids_content.setitem(ll_currow,'component_qty', 0)
			ids_content.setitem(ll_currow,'last_user',gs_userid)
			ids_content.setitem(ll_currow,'last_update',ldtToday )
			If isnull(llComponent) then llComponent = 0 /* 06/01 PCONKL */
			ids_content.setitem(ll_currow,'component_no',llComponent) /* 10/00 PCONKL */
		//	ids_content.setitem(ll_currow,'complete_date',idw_pick_detail.GetItemDateTime(j,'complete_date'))
		End If

//TAM - 2018/10 - S23683 - Fix delete to return to Component QTY instead of Avail QTY
	// TAM - Kit Change Functionality -If order Type is  "D" kit change delete and item is a component  then Use the Component QTY instead of the Avail QTY
		If idw_main.GetItemString(1,'ord_type') = 'D' and lsCompInd= '*' Then
			ll_comp =  ids_content.getitemnumber(ll_currow, "component_qty") + idw_pick_detail.GetItemNumber(j,'quantity')
			ll_avail =  0
			ids_content.setitem(ll_currow,'component_qty', ids_content.getitemnumber(ll_currow, "component_qty") + &
			idw_pick_detail.GetItemNumber(j,'quantity'))
		Else
			ll_avail =  ids_content.getitemnumber(ll_currow, "avail_qty") + idw_pick_detail.GetItemNumber(j,'quantity')
		End If
		ids_content.setitem(ll_currow,'avail_qty', ll_avail)
//		ids_content.setitem(ll_currow,'avail_qty', ids_content.getitemnumber(ll_currow, "avail_qty") + &
//				idw_pick_detail.GetItemNumber(j,'quantity'))
		
	next /*Next Pick Detail */
	
	for j = ll_totalrows to 1 Step -1
		idw_pick_detail.DeleteRow(j)
	next
	
next

ids_content.sort()

// Transfer new requested quantity from content to picking detail for all modified rows
If ls_status <> "V" Then
	for i = 1 to idw_pick.rowcount()
		
		ldis_status = idw_pick.getitemstatus(i,0,Primary!)
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
		ls_pono   = Upper(idw_pick.getitemstring(i,'po_no') )
		ls_po_no2   = Upper(idw_pick.getitemstring(i,'po_no2') )
		
		ls_container_id = Upper(idw_pick.getitemstring(i,'container_id'))		 //GAP 11-02 
		ldt_expiration_date = idw_pick.getitemdatetime(i,'expiration_date')	 //GAP 11-02 			
		
		ls_itype = idw_pick.getitemstring(i,'inventory_type')
		ld_req   = idw_pick.getitemnumber(i,'quantity') 
		llLineItemNo = idw_pick.getitemnumber(i,'line_Item_No') /* 09/01 PCONKL */
		llComponent = idw_pick.getitemnumber(i,'Component_no') /* TAM - 2014/04 */
		lsCompInd = idw_pick.getitemstring(i,'Component_Ind') /* TAM - 2014/04 */
	
		If isnull(ld_req) Then ld_req = 0 /* 07/00 PCONKL */
	
		// 10/00 Pconkl - Include component in Find
		ls_find_string =   "Upper(sku) = '" + ls_sku + "' and Upper(supp_code) = '" &
            		 + ls_supp_code + "' and Upper(Country_of_origin) = '" + ls_coo + "'" + & 
	   				" and owner_id = " + string(ll_owner_id) + &
						" and Upper(po_no2) = '" + ls_po_no2 + "' and upper(l_code) = '" + ls_lCode +  &
						"' and Upper(serial_no) = '" + ls_sno + "' and upper(lot_no) = '" &
						+ ls_lno + "' and upper(po_no) = '" + ls_pono +  &
						"' and inventory_type = '" + ls_itype + "'" 	+ &
						" and Upper(container_ID) = '" + ls_container_id + "' and String(expiration_date,'mm/dd/yyyy hh:mm') = '" + string(ldt_expiration_date,'mm/dd/yyyy hh:mm') + "' "
			
		//Filter is case sensitive!!
		liRC = ids_content.SetFilter(ls_find_string)
		ids_content.Filter()
		
		ll_content_cnt = ids_content.RowCount()
	
		j = 0
	
		//Do while ld_req > 0 and j < ids_content.RowCount()
		Do while ld_req > 0 and j < ids_content.RowCount() and ids_content.RowCount() > 0
			j += 1
	// TAM - Kit Change Functionality -If order Type is  "D" kit change delete and item is a component  then Use the Component QTY instead of the Avail QTY
			If idw_main.GetItemString(1,'ord_type') = 'D' and lsCompInd= '*' Then
				ld_avail = ids_content.GetItemNumber(j, "component_qty")
			Else
				ld_avail = ids_content.GetItemNumber(j, "avail_qty")
			End If
			
			If ld_avail <= 0 Then Continue
				
			ll_currow = idw_pick_detail.InsertRow(0)
			idw_pick_detail.setitem(ll_currow,'wo_no',lsWONO)
			idw_pick_detail.setitem(ll_currow,'sku',ls_sku)
			idw_pick_detail.setitem(ll_currow,'sku_parent',lsskuParent) /*10/00 PCONKL */
			idw_pick_detail.setitem(ll_currow,'supp_code',ls_supp_code)
			idw_pick_detail.setitem(ll_currow,'country_of_origin',ls_coo)
			idw_pick_detail.setitem(ll_currow,'owner_id',ll_owner_id)
			idw_pick_detail.setitem(ll_currow,'l_code',ls_lcode)
			idw_pick_detail.setitem(ll_currow,'inventory_type',ls_itype)
			idw_pick_detail.setitem(ll_currow,'serial_no',ls_sno)
			idw_pick_detail.setitem(ll_currow,'lot_no',ls_lno)
			idw_pick_detail.setitem(ll_currow,'po_no',ls_pono)
			idw_pick_detail.setitem(ll_currow,'po_no2',ls_po_no2)
			
			idw_pick_detail.setitem(ll_currow,'container_id',ls_container_id)			//GAP 11-02		
			idw_pick_detail.setitem(ll_currow,'expiration_date',ldt_expiration_date)	//GAP 11-02							
			
			idw_pick_detail.setitem(ll_currow,'component_ind',lsCompInd) /* 10/00 PCONKL*/
			If isnull(llComponent) Then llComponent = 0 /* 06/01 PCONKL*/
			idw_pick_detail.setitem(ll_currow,'component_no',llComponent) /* 10/00 PCONKL*/
			idw_pick_detail.setitem(ll_currow,'line_Item_No',llLineItemNo) /* 09/01 PCONKL*/
			idw_pick_detail.setitem(ll_currow,'ro_no',ids_content.GetItemString(j,'ro_no'))
		
			If ld_avail >= ld_req Then
				idw_pick_detail.setitem(ll_currow,'quantity', ld_req)
				// TAM - Kit Change Functionality -If order Type is  "D" kit change delete and item is a component  then Use the Component QTY instead of the Avail QTY
				If idw_main.GetItemString(1,'ord_type') = 'D' and lsCompInd= '*' Then
					ids_content.setitem(j, "component_qty", ld_avail - ld_req)
				Else
					ids_content.setitem(j, "avail_qty", ld_avail - ld_req)
				End If
					ld_req = 0
			Else
				idw_pick_detail.setitem(ll_currow,'quantity', ld_avail)
	// TAM - Kit Change Functionality -If order Type is  "D" kit change delete and item is a component  then Use the Component QTY instead of the Avail QTY
				If idw_main.GetItemString(1,'ord_type') = 'D' and lsCompInd= '*' Then
					ids_content.setitem(j, "component_qty", 0)
				Else
					ids_content.setitem(j, "avail_qty", 0)
				End if
				ld_req -= ld_avail		
				
			End If
		
		Loop
		
		If ld_req > 0 Then
			Messagebox(is_title,"Not enough inventory for picking!",StopSign!)
			tab_main.selecttab(4)
			f_setfocus(idw_pick, i, "sku")
			return -1
		End If
	
	next /*next Pick Row */

End If

Return 0

end function

public function integer wf_pick_row (long alpickrow);String	lsSKU,			&
			lsSupplier,		&
			lsFind,			&
			lsWareHouse,	&
			lsChildSKU,		&
			lsChildSupplier,	&
			lsCompInd,			&
			lsShipInv, 	&
			lsInvType, 	&
			lsLoc

Long	llOwner,				&
		llLineItemNo,		&
		llContentCount,	&
		llContentPos,		&
		llPickRow,			&
		llNewPickRow,		&
		llChildCount,		&
		llChildPos,			&
		llFindRow,			&
		llFindInd
		
decimal	ldReqQty,ldAVailQty,	ldParentQty,ldTotReqQty //GAP 11-02 decimal convertion
		
Boolean	lbFirstContent

u_ds	lds_item_component

// 02/06 - PCONKL - using new workorder_pickable_ind instead of shippable Ind and joing in content datastore
//GAP 12/02 -  retrieving inventory types and shipping indicators. 
//IF IsValid(ids_inv_type) = FALSE THEN
//	ids_inv_type = Create datastore
//	ids_inv_type.Dataobject = 'd_inv_type'
//	ids_inv_type.SetTransObject(sqlca)
//	ids_inv_type.Retrieve(gs_project)
//	//ll_rtn = ids_inv_type.rowcount()
//end if 

lds_item_component = Create u_ds
lds_item_component.dataobject = 'd_item_component_parent'
lds_item_component.SetTransObject(SQLCA)

lsSKU = idw_pick.GetItemString(alPickRow,'SKU')
lsSupplier = idw_pick.GetItemString(alPickRow,'Supp_code')
lsWarehouse = idw_main.GetItemString(1,'wh_code')
llOwner = idw_pick.GetItemNumber(alPickRow,'owner_id')
llLineItemNo = idw_pick.GetItemNumber(alPickRow,'line_item_no')

//If we haven't already done so, retrieve content for this SKU/Supplier (retrievestart - return=2, append)
//since we may be processing the same child for diffferent parents, we don't want to allocate it twice (we're not updating content here, only reading)

ids_Pick_Alloc.SetFilter('')
ids_Pick_Alloc.Filter()

//10/02 - PCONKL - We can't include Supplier in retrival of CHilderen because they may have a different supplier than the Parent!

lsFind = "Upper(SKU) = '" + Upper(lsSku) + "'"
If ids_pick_alloc.Find(lsFind,1,ids_pick_alloc.RowCOunt()) <= 0 Then
	ids_Pick_Alloc.Retrieve(gs_project, lsWareHouse, lsSKU) 
End If

llContentCount =  ids_pick_Alloc.RowCount()

//Filter COntent for the current SKU
lsFind += " and avail_qty > 0"
ids_pick_alloc.SetFilter(lsFind)
ids_pick_alloc.Filter()

// 02/06 - PCONKL - For GM, We want to filter for lot_no either = '-' or this WO_NO. We might have reserved available stock to only pe pickable for this WO in a previous pick
If gs_project = 'GM_MI_DAT' Then
	
	lsFind += " and (lot_no = '-' or lot_no = '' or lot_no = '" + idw_main.GetITemString(1,'wo_no') + "')"
	ids_pick_alloc.SetFilter(lsFind)
	ids_pick_alloc.Filter()
	
	//We aso want to sort reserved Invcentory to the top*/
	If g.is_pick_sort_order > ' ' Then
		ids_pick_alloc.SetSort("Lot_No D, " + g.is_pick_sort_order)
	Else
		ids_pick_alloc.SetSort("Lot_No D, Complete_Date A")
	End If

End If /*GM*/
	
ids_Pick_Alloc.Sort()

llContentCount = ids_pick_Alloc.RowCount()

ldReqQty = idw_pick.GetITemNumber(alPickRow,'quantity') /*we already set the required qty in the last step - we will change if not enough*/
ldTotReqQty = ldReqQty /*will be used to report total required if short */
idw_pick.SetITem(alPickRow,'Quantity',0) /*will be set by actaully allocation*/

lbFirstContent = True

For llContentPos = 1 to llContentCount
	
	// 02/06 - PCONKL - using new workorder_pickable_ind instead of shippable Ind and joing in content datastore
	
//	//GAP 12-02  logic to skip records where the inventory_shippable_ind is set to "N"
//	lsInvType = Upper(ids_pick_alloc.GetItemString(llContentPos,'inventory_type'))
//	llFindInd = ids_inv_type.RowCount()
//	llFindInd = ids_inv_type.Find( &
//		"inv_type = '" + lsInvType + "'", 1, ids_inv_type.RowCount())
//	lsShipInv =  ids_inv_type.GetItemString(llFindInd, 'inventory_shippable_ind')  	
//	If lsShipInv = "N" Then Continue /*next content rec */
	
	ldAVailQty = ids_pick_alloc.GetItemNumber(llContentPos,'avail_qty')
	lsLoc = ids_pick_alloc.GetItemString(llContentPos,'l_code')
	llFindRow = 0
	
	If ldAVailQty <= 0 Then Continue /*next content rec */
	
	//If we already have a row for this sku/supplier/line item/Location - update, otherwise insert a new row
	lsFind = "Upper(SKU) = '" + Upper(lsSku) + "' and Upper(supp_code) = '" + Upper(lsSupplier) + "'" 
	//lsFind = "Upper(SKU) = '" + Upper(lsSku) + "' and Upper(supp_code) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'supp_code')) + "'" 
	lsFind += " and Upper(l_code) = '" + Upper(lsLoc) + "' and Line_item_No = " + String(llLineITemNo)
	lsFind += " and Upper(inventory_Type) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'inventory_type')) + "'"
	lsFind += " and Upper(serial_no) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'serial_no')) + "'"
	lsFind += " and Upper(lot_no) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'lot_no')) + "'"
	lsFind += " and Upper(po_no) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'po_no')) + "'"
	lsFind += " and Upper(po_no2) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'po_no2')) + "'"
	lsFind += " and Upper(container_ID) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'container_ID')) + "'"
	lsFind += " and Upper(country_of_origin) = '" + Upper(ids_pick_alloc.GetItemString(llContentPos,'country_of_origin')) + "'"
	llFindRow = idw_Pick.Find(lsFind,1,idw_pick.RowCount())
		
	//If not found, we will be inserting a new Pick Row
	If llFindRow <= 0 Then
		llPickRow = idw_pick.InsertRow(0)
	End If
		
	If llFindRow > 0 Then /*updating existing pick row with additional picked qty */
	
		idw_pick.setitem(llFindRow,'inventory_type',ids_pick_alloc.GetItemString(llContentPos,'inventory_type'))
		idw_pick.setitem(llFindRow,'owner_id',ids_pick_alloc.GetItemNumber(llContentPos,'owner_id'))
		idw_pick.setitem(llFindRow,'country_of_origin',ids_pick_alloc.GetItemString(llContentPos,'country_of_origin'))
		idw_pick.setitem(llFindRow,'l_code',ids_pick_alloc.GetItemString(llContentPos,'l_code'))
		idw_pick.setitem(llFindRow,'serial_no',ids_pick_alloc.GetItemString(llContentPos,'serial_no'))
		idw_pick.setitem(llFindRow,'lot_no',ids_pick_alloc.GetItemString(llContentPos,'lot_no'))
		idw_pick.setitem(llFindRow,'po_no',ids_pick_alloc.GetItemString(llContentPos,'po_no'))
		idw_pick.setitem(llFindRow,'po_no2',ids_pick_alloc.GetItemString(llContentPos,'po_no2'))
		idw_pick.setitem(llFindRow,'container_id',ids_pick_alloc.GetItemString(llContentPos,'container_id'))				//gap 11-02
		idw_pick.setitem(llFindRow,'expiration_date',ids_pick_alloc.GetItemdatetime(llContentPos,'expiration_date'))	//gap 11-02
		idw_pick.setitem(llFindRow,'country_of_origin',ids_pick_alloc.GetItemString(llContentPos,'country_of_origin'))
	
		If ldAVailQty >= ldReqQty Then /*more than enough available, allocate all */
			idw_pick.setitem(llFindRow,'quantity',(idw_pick.GetITemNumber(llFindRow,'quantity') + ldReqQty))
			ldAVailQty = ldAVailQty - ldReqQty
			ids_pick_alloc.SetITem(llContentPos,'avail_qty', ldAVailQty)
			ldReqQty = 0
		Else /*not enough*/
			idw_pick.setitem(llFindRow,'quantity',(idw_pick.GetITemNumber(llFindRow,'quantity') + ldAVailQty))
			ldReqQty = ldReqQty - ldAVailQty
			ldAVailQty = 0
			ids_pick_alloc.SetITem(llContentPos,'avail_qty', 0)
		End If
	
	Else /*set values for new picking row */
		
		//values were set for first row in last step
		idw_pick.setitem(llPickRow,'wo_no',idw_pick.GetItemString(alPickRow,'wo_no'))
		idw_pick.setitem(llPickRow,'sku',idw_pick.GetItemString(alPickRow,'sku'))
		idw_pick.setitem(llPickRow,'sku_parent',idw_pick.GetItemString(alPickRow,'sku_parent'))
		//idw_pick.setitem(llPickRow,'supp_code',idw_pick.GetItemString(alPickRow,'supp_code'))
	
		
		idw_pick.setitem(llPickRow,'component_no',0)
		idw_pick.setitem(llPickRow,'component_ind',idw_pick.GetItemString(alPickRow,'component_ind'))
		idw_pick.setitem(llPickRow,'serialized_Ind',idw_pick.GetItemString(alPickRow,'serialized_Ind'))
		idw_pick.setitem(llPickRow,'lot_controlled_Ind',idw_pick.GetItemString(alPickRow,'lot_controlled_Ind'))
		idw_pick.setitem(llPickRow,'po_controlled_Ind',idw_pick.GetItemString(alPickRow,'po_controlled_Ind'))
		idw_pick.setitem(llPickRow,'po_no2_controlled_Ind',idw_pick.GetItemString(alPickRow,'po_no2_controlled_Ind'))
		idw_pick.setitem(llPickRow,'expiration_controlled_Ind',idw_pick.GetItemString(alPickRow,'expiration_controlled_Ind'))
		idw_pick.setitem(llPickRow,'container_Tracking_Ind',idw_pick.GetItemString(alPickRow,'container_Tracking_Ind'))
		idw_pick.setitem(llPickRow,'line_item_no',idw_pick.GetItemNumber(alPickRow,'line_item_no')) 
			
		//From Content record
		idw_pick.setitem(llPickRow,'supp_code',ids_pick_alloc.GetItemString(llContentPos,'supp_code'))
		idw_pick.setitem(llPickRow,'inventory_type',ids_pick_alloc.GetItemString(llContentPos,'inventory_type'))
		idw_pick.setitem(llPickRow,'owner_id',ids_pick_alloc.GetItemNumber(llContentPos,'owner_id'))
		idw_pick.object.cf_owner_name[ llPickRow ] = g.of_get_owner_name(ids_pick_alloc.GetItemNumber(llContentPos,'owner_id'))
		idw_pick.setitem(llPickRow,'country_of_origin',ids_pick_alloc.GetItemString(llContentPos,'country_of_origin'))
		idw_pick.setitem(llPickRow,'l_code',ids_pick_alloc.GetItemString(llContentPos,'l_code'))
		idw_pick.setitem(llPickRow,'serial_no',ids_pick_alloc.GetItemString(llContentPos,'serial_no'))
		idw_pick.setitem(llPickRow,'lot_no',ids_pick_alloc.GetItemString(llContentPos,'lot_no'))
		idw_pick.setitem(llPickRow,'po_no',ids_pick_alloc.GetItemString(llContentPos,'po_no'))
		idw_pick.setitem(llPickRow,'po_no2',ids_pick_alloc.GetItemString(llContentPos,'po_no2'))
		idw_pick.setitem(llPickRow,'container_id',ids_pick_alloc.GetItemString(llContentPos,'container_id'))				//gap 11-02
		idw_pick.setitem(llPickRow,'expiration_date',ids_pick_alloc.GetItemdatetime(llContentPos,'expiration_date'))	//gap 11-02	
		idw_pick.setitem(llPickRow,'country_of_origin',ids_pick_alloc.GetItemString(llContentPos,'country_of_Origin'))
		
		If ldAVailQty >= ldReqQty Then
			idw_pick.setitem(llPickRow,'quantity',ldReqQty)
			ldAVailQty = ldAVailQty - ldReqQty
			ids_pick_alloc.SetITem(llContentPos,'avail_qty', ldAVailQty)
			ldReqQty = 0
		Else /*not enough*/
			idw_pick.SetITem(llPickRow, 'quantity', ldAVailQty)
			ldReqQty = ldReqQty - ldAVailQty
			ldAVailQty = 0
			ids_pick_alloc.SetITem(llContentPos,'avail_qty', 0)
		End If
	 
	End If /*new or updated Picking row */
	
	If ldReqQty <=0 Then Exit /*we're done for this pick row*/
	
Next /*Content record */

//If we still have required qty - if it is a component, break it out into the individual pieces
If ldReqQty > 0 Then
	
	If idw_pick.GetITemString(alPickRow,'Component_ind') = 'Y' Then

		ldParentQty = ldReqQty /* parent qty is the required qty that we wre unable to allocate */
		llChildCOunt = lds_item_component.Retrieve(gs_project,lssku,lsSupplier, "C") /* 08/02 - PCONKL - default component type to 'C' (DW/DB Table also being used for Packaging*/
		
		//Build a pick row for each of the children
		For llChildPos = 1 to llChildCount
			
			lsChildSku = lds_item_component.GetItemString(llChildPos,"sku_child")
			lsChildSupplier = lds_item_component.GetItemString(llChildPos,"supp_code_child")
						
			//We need the component ind for this child sku (It may also be a parent)
			Select Component_ind Into :lsCompInd
			From Item_master
			Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
			Using SQLCA;
			
			llNewPickRow = idw_Pick.InsertRow(0)
		
			idw_pick.SetItem(llNewPickRow,'wo_no',idw_main.GetITemString(1,'wo_no'))
			idw_pick.SetItem(llNewPickRow,'line_item_no',idw_Pick.GetITemNumber(alPickRow,'line_item_no'))
			idw_pick.SetItem(llNewPickRow,'sku',lsChildSKU)
			idw_pick.SetItem(llNewPickRow,'sku_Parent',lsSKU)
			idw_pick.SetItem(llNewPickRow,'supp_code',lsChildSupplier)
			idw_pick.SetItem(llNewPickRow,'owner_id',idw_Pick.GetITemNumber(alPickRow,'owner_id'))
			idw_pick.SetItem(llNewPickRow,'quantity',ldParentQty * (lds_item_component.GetItemNumber(llChildPos,"child_qty"))) /*extent parent qty by Child Unit QTY*/
			idw_pick.SetItem(llNewPickRow,'deliver_to_location','XXXXXXXXXXX')
			
			//Retrieve ItemMaster Values (component ind, serialized, lotized, etc.)
			i_nwarehouse.of_item_master(gs_project,lsChildSku,lsChildSupplier,idw_pick,llNewPickRow)
			
			//allocate each item - calling this function recursively
			wf_pick_row(llNewPickRow)
			
		Next /*Child*/		
		
	Else /*we are at the lowest level and are still short, display to user*/
		
		ilPickArrayPos ++
		istr_pick_Short.String_arg[ilPickArrayPos] = lsSKU + '|' + string(ldTotReqQty) + '|' + string(ldTotReqQty - ldReqQty)
				
	End If /*component*/
	
End If /*qty still required */


Return 0
end function

public function integer wf_logitech_putaway ();// 07/04 - PCONKL - Keep Lot, PO and Exp Date in sync from Picking to Putaway for Logitech

Long	llRowPos, llRowCount, llLineItem, llFindRow, llOwnerID, llSubLine, llNewRow
String	lsSKU, lsLot, lsPO, lsFind, lsLoc, lsOrder, lsSupplier, lsWarehouse, lsInvType, lsCOO, lsOwnerName, lsComp,	&
			lsSerialInd, lspo2Ind, lsContainerInD
dateTIme	ldtExpDt
Decimal	ldPickQTY, ldPutQty

//For each Picking Row, we should have a matching Putaway Row with the same Lot # (Pedimento #), PO (Port of Entry) and Exp Date (Pedimento Date)
// We may have multiple putaway records to have the correct QTY

llRowCount = idw_Pick.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = idw_Pick.GetITemString(llRowPos,'SKU')
	lsLot = idw_Pick.GetITemString(llRowPos,'Lot_No')
	lsPO = idw_Pick.GetITemString(llRowPos,'po_no')
	lsCOO = idw_Pick.GetITemString(llRowPos,'Country_of_Origin')
	llLineITem = idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
	ldPickQty = idw_Pick.GetITemNumber(llRowPos,'Quantity')
	ldtExpDt = idw_Pick.GetITemdateTime(llRowPos,'Expiration_Date')
	lsOrder = idw_main.GetITemString(1,'wo_no')
	llOwnerID = idw_Pick.GetItemNumber(llRowPos,"owner_id")
	lsOwnername = idw_Pick.GetItemString(llRowPos,"cf_owner_name")
	lsSupplier = idw_Pick.getITemString(llRowPos,"supp_code")
	
	//If this SKU is found on the detail, then they are picking and putting away the same SKU
	If idw_Detail.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,idw_detail.RowCount()) <= 0 Then Continue
	
	//See how many rows we have of this SKU/Pedimento
	ldPutQty = 0
	lsFind = "Upper(sku) = '" + upper(lsSKU) +  "' and upper(lot_no) = '" + Upper(lsLot) + "'"
	llFindRow = idw_Putaway.Find(lsFind,1,idw_Putaway.RowCount())
	
	Do While llFindRow > 0
		
		ldPutQty += idw_putaway.GetITemNumber(llFindROw,'Quantity')
		llFindRow ++
		If llFindRow > idw_Putaway.RowCount() Then Exit
		llFindRow = idw_Putaway.Find(lsFind,llFindRow,idw_Putaway.RowCount())
		
	Loop
	
	//If Pick Qty = Putaway qty for his pedimento then we don't need to do anythin with this row
	If ldPutQty >= ldPickQty Then Continue
	
	//if there is an existing non confirmed putaway row for this line/sku, update pedimento info, othewise create a new putaway rec
	lsFind = "Line_Item_No = " + String(llLineItem) + " and Upper(sku) = '" + upper(lsSKU) + "' and (isnull(User_field2) or User_field2 = '') and lot_no = '-'"
	llFindRow = idw_Putaway.Find(lsFind,1,idw_putaway.RowCount())
	If llFindRow > 0 Then /*update existing Putaway*/
		
		idw_Putaway.SetItem(llFindRow,'lot_no', lsLot) /* ped # */
		idw_Putaway.SetItem(llFindRow,'po_no', lspo) /* Port of Entry*/
		idw_Putaway.SetItem(llFindRow,'expiration_date', ldtExpDt)
		idw_Putaway.SetItem(llFindRow,'Quantity', ldPickQty - ldPutQty) /* difference between picked and currently on putaway*/
		
	Else /*insert a new Putaway*/
		
		//Retrieve serial, lot, PO, Container & Expiration tracking indicators
		Select SerialIzed_Ind,  PO_NO2_Controlled_Ind,Container_Tracking_Ind, 	Component_Ind
		Into	:lsSerialInd,  :lsPO2Ind,:lsContainerInd, :lsComp
		From Item_Master
		Where Project_id = :gs_project and SKU = :lsSKU and supp_code = :lsSupplier;
	
		//Get default Putaway Location based on Item, owner and Inv Type	
		lsLoc = i_nwarehouse.of_assignlocation(lssku,lsSUpplier, lswarehouse, lsInvType,llOwnerID, ldPutQty)
	
		llNewRow = idw_putaway.InsertRow(0)
		
		idw_putaway.setitem(llNewRow,'wo_no', lsorder)
		idw_putaway.SetItem(llNewRow,"sku", lssku)	
		idw_putaway.SetItem(llNewRow,"sku_parent", lssku)	
		idw_putaway.SetItem(llNewRow,"supp_code", lsSupplier)
		idw_putaway.SetItem(llNewRow,"owner_id", llOwnerID)	
		idw_putaway.SetItem(llNewRow,"line_item_no", llLineItem)	
		idw_putaway.SetItem(llNewRow,"cf_owner_name", lsOwnername)	
		idw_putaway.SetItem(llNewRow,"inventory_type", lsInvtype)	
		idw_putaway.SetItem(llNewRow,"serialized_ind", lsSerialInd)	
		idw_putaway.SetItem(llNewRow,"lot_controlled_ind", lsLot)
		idw_putaway.SetItem(llNewRow,"po_controlled_ind", lsPO)
		idw_putaway.SetItem(llNewRow,"po_no2_controlled_ind", lsPO2Ind)
		idw_putaway.SetItem(llNewRow,"Container_Tracking_Ind", lsContainerInd)  	//GAP 11-02
		idw_putaway.SetItem(llNewRow,"Expiration_Controlled_Ind", 'Y') 	//GAP 11-02
		idw_putaway.SetItem(llNewRow,"component_ind", lsComp)
		idw_putaway.SetItem(llNewRow,"country_of_origin", lsCOO)
		idw_putaway.SetItem(llNewRow,"quantity", ldPickQty - ldPutQty) 
		idw_putaway.SetItem(llNewRow,"l_code", lsloc)	
		idw_Putaway.SetItem(llNewRow,'lot_no', lsLot) /* ped # */
		idw_Putaway.SetItem(llNewRow,'po_no', lspo) /* Port of Entry*/
		idw_Putaway.SetItem(llNewRow,'expiration_date', ldtExpDt)
		idw_putaway.setitem(llNewRow,'component_no',0)
	
		// 07/04 - PCONKL - Set Unique Line number
		llSubLine = llNewRow
		//If Subline Already Exists, bump until not
		llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
		Do While llFindRow > 0
			llSubLine ++
			llFindRow = idw_putaway.Find("sub_line_item_no = " + String(llSubLine),1,idw_putaway.RowCount())
		Loop

		idw_putaway.SetItem(llNewRow,"sub_line_item_no", llSubLine)	 
	
	End If
	
Next /*Pick Row*/


Return 0
end function

public function integer wf_verify_bom ();String	lsFile, lsRun, lsUser, lsPassword, lsResponse, lsErrorText
Integer	liFileNo
Long	llRowPos, llRowCount, llSleepCount, llSleepCalc, llBeginPos, llEndPos
Boolean	lbFileExists
Str_parms	lstrParms

//User ID and Password are coming from USer File
Select gm_ims_logonID, gm_ims_password
into	:lsUser, :lsPassword
from Usertable
where USerID = :gs_UserID;

If lsUser = "" or lsPassword = "" Then
	MEssagebox(is_title, "GM IMS USer ID and Password are required before proceeding~r(They are entered on User Maintenance)",StopSign!)
	Return -1
End If

//Look in the Macros sub-directory of the SIMS directory
If gs_SysPath > '' Then
	lsFile = gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ebm'
	
Else
	lsFile = 'Macros\' + 'GM_IMS_EPCOU03A.ebm'
End If

If Not FileExists(lsFile) Then
	Messagebox(is_title, 'Unable to Find Macro Format (GM_IMS_EPCOU03A.ebm)!')
	Return -1
End If

//We can't call the Macro with parms - We need to create a .ini file with the variables
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ini',LineMode!,Write!,LockReadWrite!,Replace!)
If liFileNo < 0 Then
	Messagebox(is_title,"Unable to create Macro .ini File")
	Return -1
End If

SetPointer(Hourglass!)
w_main.SetMicrohelp("Retrieving BOM data from IMS")

//Write User ID and Password to .ini file
FileWrite(liFileNo,lsUser)
FileWrite(liFileNo,lsPassword)

//For Each Detail REcord, add record to the .ini file
llRowCount = idw_Detail.RowCount()
For llRowPos = 1 to llRowCount
	FileWrite(liFileNo,idw_detail.GetITemString(llRowPos,'sku') + "|" + idw_detail.GetITemString(llRowPos,'supp_code'))
Next

FileClose(liFileNo)

//Delete file from previous run if exists...
If FileExists(gs_syspath + 'Macros\' + 'EPC2u03.xml') Then
	FileDelete(gs_syspath + 'Macros\' + 'EPC2u03.xml')
End If

//Run the Macro
lsRun = 'ebrun.exe ' + gs_syspath + 'Macros\' + 'GM_IMS_EPCOU03A.ebm' 
Run(lsRun,Normal!)


//Wait for the output file to be created.

//Calc anticipated wait time based on number of items (30 seconds to get to item screen and 15 seconds per item...)
llSleepCalc = 6 + (3 * llRowCount)

llSleepCount = 0
lbFileExists = False
Do Until lbFileExists
	
	llSleepCount ++
	
	If llSleepCount > llSleepCalc Then 
	
		w_workorder.SetFocus()
		
		If MessageBox(is_title, "Do you want to continue waiting for the Macro to finish?",Question!,YesNo!,1) = 2 Then
			Setpointer(Arrow!)
			Return -1
		Else
			llSleepCount = 0
		End If
		
	End If
	
	Sleep(5)
	
	lbFileExists = FileExists(gs_syspath + 'Macros\' + 'EPC2u03.xml')
	
Loop

w_workorder.SetFocus()

//Read the file
liFileNo = FileOpen(gs_syspath + 'Macros\' + 'EPC2u03.xml',StreamMode!,Read!)
FileRead(liFileNo,lsResponse)
FileClose(liFileNo)

Setpointer(Arrow!)
w_main.SetMicrohelp("Ready")

//Process return XML...

//If we don't have an end marker, something went wrong...
If Pos(Upper(lsResponse),"</GM_IMS_RESPONSE>") = 0 Then
	Messagebox(is_title, "The GM IMS system did not return a valid response.~r~rNo updates applied to Item Master")
	Return -1
End IF

//Check for errors...
If Pos(Upper(lsResponse),"ERRORTEXT") > 0 Then
	
	llBeginPos = Pos(Upper(lsResponse),"ERRORTEXT") + 11
	llEndPos = Pos(Upper(lsResponse),"'",llbeginPos + 1)
	
	lsErrorText = MId(lsResponse,llBeginPos,(llEndPos - llBeginPos))
	
	Messagebox(is_title, "The GM IMS system returned the following error:~r~r" + lsErrorText + "~r~rNo updates applied to Item Master")
	Return -1
	
End If

//See if any items were returned...
If Pos(Upper(lsResponse),"<PARENTITEM>") = 0 Then
	Messagebox(is_title, "The GM IMS system did not return any items to update.~r~rNo updates applied to Item Master")
	Return -1
End IF

//Show the item information that was returned for user verification and update
lStrparms.String_arg[1] = lsResponse
OpenWithParm(w_load_gm_bom, lstrparms)

Return 0
end function

public function integer wf_update_content_server ();
long	i, llSerialArrayPos, llNull[], llFindRow, llCount, llFileLength
String	ls_whcode, lsWoNo, ls_status,  lsNull[], lsPost, lsXMLResponse, lsReturnCode, lsReturnDesc, lsFind, lsCrap, lsSaveFile
dwitemstatus ldis_status
String  lsXML, lsTempxml
Integer	liFileNo, liLoop

//Build XML of Pick list to pass to Websphere - We will pass Deletes and Adds - An update will be both

//Writing XML to a file - appending large amounts of data to varaibale is slow.

//OPen a temp file to hold the XML - 
lsSaveFile = "PickSaveXML-" + String(today(),"yyyymmddss") + ".txt"
liFileNo = FileOpen(lsSaveFile,LineMOde!,Write!,LockReadWrite!,Replace!)

idw_pick.AcceptText()


If f_check_required(is_title, idw_Pick) = -1 Then Return -1

ls_whcode = idw_main.getitemstring(1,'wh_code')
lsWoNo = idw_main.getitemstring(1,'wo_no')
ls_status = idw_main.getitemstring(1,'ord_status')


//Build the Deletes first
llCount = idw_pick.deletedcount()
for i = 1 to llCount
		
	ldis_status = idw_pick.getitemstatus(i,0,Delete!)
	if ldis_status = New! or ldis_status = NewModified! then Continue
		
	
	//Pass key values in for Delete
	lsXML = "<WOPickRecord>"
	lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
	lsXML += "<WONO>" + idw_main.getitemstring(1,'Wo_no') + "</WONO>"
	lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No',Delete!,True) ) + "</LineItemNo>"
	lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku',Delete!,True) + "</SKU>"
	lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code',Delete!,True) + "</SupplierCode>"
	lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id',Delete!,True)) + "</OwnerID>"
	lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity',Delete!,True)) + "</Quantity>"
	
	//Only pass if NOt Default Value to keep size of XML down
	
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
		
	If NOt isnull(idw_pick.getitemnumber(i,'component_no',Delete!,True)) and idw_pick.getitemnumber(i,'component_no',Delete!,True) <> 0 Then
		lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Delete!,True)) + "</ComponentNo>"
	End If
	
	//Component Indicator -
	If not isnull(idw_pick.getitemstring(i,'component_ind',Delete!,True)) and idw_pick.getitemstring(i,'component_ind',Delete!,True) <> 'N' Then
		lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Delete!,True) + "</ComponentInd>"
	End If
		
		
	lsXML += "</WOPickRecord>"
	
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
		lsXML = "<WOPickRecord>"
		lsXML += "<UpdateType>D</UpdateType>" /*Update Type is Delete */
		lsXML += "<WONO>" + idw_main.getitemstring(1,'wo_no') + "</WONO>"
		lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No',Primary!,True) ) + "</LineItemNo>"
		lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku',Primary!,True) + "</SKU>"
		lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code',Primary!,True) + "</SupplierCode>"
		lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id',Primary!,True)) + "</OwnerID>"
		lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity',Primary!,True)) + "</Quantity>"
		
		//Only pass in if not default value
		
		If idw_pick.getitemstring(i,'inventory_type',Primary!,True) <> 'N' Then
			lsXML += "<InvType>" + idw_pick.getitemstring(i,'inventory_type',Primary!,True) + "</InvType>"
		End If
			
		If idw_pick.getitemstring(i,'country_of_origin',Primary!,True) <> 'XXX' Then
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
		
				
		If NOt isnull(idw_pick.getitemnumber(i,'component_no',Primary!,True)) and idw_pick.getitemnumber(i,'component_no',Primary!,True) <> 0 Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no',Primary!,True)) + "</ComponentNo>"
		Else
			lsXML += "<ComponentNo>0</ComponentNo>"
		End If
		
		//Component Indicator -
		If not isnull(idw_pick.getitemstring(i,'component_ind',Primary!,True)) and idw_pick.getitemstring(i,'component_ind',Primary!,True) <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind',Primary!,True) + "</ComponentInd>"
		End If
		
	
		lsXML += "</WOPickRecord>"
		
		//Either write to file if available or Temp Variable if not
		If liFileNo > 0 Then
			FileWrite(liFileNo,lsXML)
		Else
			lsTempXml += lsXML
		End If
		
	End If /*Modified */
	
	
	//Create a new pick Record with the new (updated) values For New!, NewModified!, MOdified! and Not Void
	If (ldis_status = New! or ldis_status = NewModified! or ldis_status = DataModified!) Then
		
	//	w_main.setMicroHelp("Building Datamodified INSERT for row " + String(i) + " of " + String (llCount))
		
		lsXML = "<WOPickRecord>"
		lsXML += "<UpdateType>N</UpdateType>" /*Update Type is New */
		lsXML += "<WONO>" + idw_main.getitemstring(1,'wo_no') + "</WONO>"
		lsXML += "<LineItemNo>" + String(idw_pick.getitemnumber(i,'line_Item_No') ) + "</LineItemNo>"
		lsXML += "<SKU>" + idw_pick.getitemstring(i,'sku') + "</SKU>"
		lsXML += "<SupplierCode>" + idw_pick.getitemstring(i,'supp_code') + "</SupplierCode>"
		lsXML += "<OwnerID>" + String(idw_pick.getitemnumber(i,'owner_id')) + "</OwnerID>"
		lsXML += "<Quantity>" + String(idw_pick.getitemnumber(i,'Quantity')) + "</Quantity>"
		lsXML += "<DeliverToLocation>" + idw_pick.getitemstring(i,'deliver_to_Location') + "</DeliverToLocation>"
			
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
				
		If NOt isnull(idw_pick.getitemnumber(i,'component_no')) and idw_pick.getitemnumber(i,'component_no') <> 0 Then
			lsXML += "<ComponentNo>" + String(idw_pick.getitemnumber(i,'component_no')) + "</ComponentNo>"
		End If
				
		//Non key fields...
		If not isnull(idw_pick.getitemstring(i,'component_ind')) and idw_pick.getitemstring(i,'component_ind') <> 'N' Then
			lsXML	+=  "<ComponentInd>" + idw_pick.getitemstring(i,'component_ind') + "</ComponentInd>"
		End If
		
		If not isnull(idw_pick.getitemstring(i,'sku_parent')) and idw_pick.getitemstring(i,'sku_parent') <> idw_pick.getitemstring(i,'sku')Then
			lsXML	+=  "<SkuParent>" + idw_pick.getitemstring(i,'sku_parent') + "</SkuParent>"
		End If
				
						
		lsXML += "</WOPickRecord>"
		
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
lsPost = iuoWebsphere.uf_request_header("WOPickAllocRequest", "ProjectID='" + gs_Project + "'")
lsPost += lsXML
lsPost = iuoWebsphere.uf_request_footer(lsPost)

//Messagebox("",lsPost)

w_main.setMicroHelp("Saving Pick List on Application Server...")

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

public function integer wf_create_comp_child (long alrow);// 10/31/02 - PConkl - QTY changed to Decimal

u_ds	lu_ds
Long	llRowCount,	&
		llRowPos,	&
		llCompRow,	&
		llFindRow, llFindPickRow,	&
		llSetRow
	
long	llSubLine
long	llPickDetailCount, llPickDetailRow

		Datetime ldt_expire_date

Decimal	ldQty

String	lsSku,				&
			lsSupplier,			&
			lsSerialInd,			&
			lsLotInd,				&
			lsPOInd,					&
			lsPO2Ind,				&
			lsExpireInd,				&
			lsChildSku,			&
			lsChildSupplier,	&
			lsCompInd,			&
			lsFind,				&
			lsLoc,					&
			lsWoNo
			
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
llCompRow = alRow

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
		//Loop Through Picking rows to get the Expiration Dates and QTY

		lsFind = "Upper(sku) = '" + Upper(lu_ds.GetItemString(llRowPos,"sku_child")) + "' and Upper(Supp_code) = '" +  Upper(lu_ds.GetItemString(llRowPos,"supp_code_child"))
		lsFind += "' and line_item_no = " + String(idw_putaway.GetItemNumber(alRow,"Line_Item_no"))
//*		llFindPickRow = 0

		ldQty = ldQty *	lu_ds.GetItemNumber(llRowPos,"child_qty")

			// GailM 7/10/2020 S47693 F20484 I2896 KNY - NYCSP: Use RO_NO Date vs. WO_NO Date When Creating WOs
			// TAM 2010/09 Get the Expiration date and QTY from the component Picklist.	
			//Get serialized ind -
			lsChildSku = lu_ds.GetItemString(llRowPos,"sku_child")
			lsChildSupplier = lu_ds.GetItemString(llRowPos,"supp_code_child")
			Select serialized_ind, component_ind, lot_controlled_Ind, po_controlled_ind, po_no2_controlled_Ind, expiration_controlled_ind 
			Into :lsSerialInd, :lsCompInd, :lsLotInd, :lsPOInd, :lsPO2Ind, :lsExpireInd
			From Item_master
			Where project_id = :gs_project and sku = :lsChildSku and supp_code = :lsChildSupplier
			Using SQLCA;
				
			//Get Pick Detail records
			llFindPickRow = idw_pick.Find(lsFind,llFindPickRow+1,idw_pick.RowCount())

			If llFindPickRow > 0 Then 
				idw_pick_detail.retrieve(is_WONO, lsChildSku, lsChildSupplier,idw_pick.GetItemNumber(llFindPickRow,'owner_id'), &
					idw_pick.GetItemString(llFindPickRow,'country_of_origin'), idw_pick.GetItemString(llFindPickRow,'l_code'), &
					idw_pick.GetItemString(llFindPickRow,'inventory_type'), idw_pick.GetItemString(llFindPickRow,'serial_no'), &
					idw_pick.GetItemString(llFindPickRow,'lot_no'), idw_pick.GetItemString(llFindPickRow,'po_no'), &
					idw_pick.GetItemString(llFindPickRow,'po_no2'),idw_pick.GetItemNumber(llFindPickRow,'line_item_no'), &
					idw_pick.GetItemString(llFindPickRow,'container_id'), idw_pick.GetItemDatetime(llFindPickRow,'expiration_date')) 
			End If
			llPickDetailCount = idw_pick_detail.RowCount()
			llPickDetailRow = 1
			
		do while ldQty > 0 and llPickDetailRow <= llPickDetailCount

				llCompRow ++
				idw_putaway.InsertRow(llCompRow)

				idw_putaway.SetItem(llComprow,"component_no",idw_putaway.GetITemNumber(alRow,"Component_no"))
				idw_putaway.SetItem(llComprow,"line_item_no",idw_putaway.GetITemNumber(alRow,"line_item_no"))
				idw_putaway.SetItem(llComprow,"sku_parent", idw_putaway.GetItemString(alRow,"sku_parent"))	
				idw_putaway.setitem(llComprow,'wo_no', idw_putaway.GetItemString(alRow,"wo_no"))
				idw_putaway.SetItem(llComprow,"inventory_type",idw_putaway.GetItemString(alRow,"inventory_type"))	
				idw_putaway.SetItem(llComprow,"owner_id", idw_putaway.GetItemNumber(alRow,"owner_id"))	
				idw_putaway.SetItem(llComprow,"cf_owner_name", idw_putaway.GetItemString(alRow,"cf_owner_name"))	
				idw_putaway.SetItem(llComprow,"l_code", idw_putaway.GetItemString(alRow,"l_code"))
				idw_putaway.SetItem(llComprow,"country_of_origin", idw_putaway.GetItemString(alRow,"country_of_origin"))
				idw_putaway.SetItem(llComprow,"Expiration_date",(idw_pick_detail.GetItemDateTime(llPickDetailRow,'Expiration_date')))
//*					idw_putaway.SetItem(llComprow,"Expiration_date",'2999/12/31') //will be set at the end based on the picklist
				idw_putaway.SetItem(llComprow,"lot_no",'-') //will be set at the end based on the picklist
				idw_putaway.SetItem(llComprow,"po_no",'-') //will be set at the end based on the picklist
				idw_putaway.SetItem(llComprow,"component_ind", '*')	/*it's only a child*/
				idw_putaway.SetItem(llComprow,"container_id",idw_putaway.GetITemString(alRow,"Container_Id"))
				idw_putaway.SetItem(llComprow,"ro_no",idw_pick_detail.GetItemString(llPickDetailRow,'ro_no'))

//				idw_putaway.SetItem(llCompRow,"quantity",(idw_pick.GetItemNumber(llFindPickRow,'quantity') * lu_ds.GetItemNumber(llRowPos,"child_qty")))

//TAM 10/13/2010 For NYCSP we are seting the Parent Quantity to 1 so we use the BOM quantity for the Children
//				If gs_project = 'NYCSP' Then
//					idw_putaway.SetItem(llCompRow,"quantity",(lu_ds.GetItemNumber(llRowPos,"child_qty")))
//					ldqty = ldqty - lu_ds.GetItemNumber(llRowPos,"child_qty")
//				Else
					idw_putaway.SetItem(llCompRow,"quantity",(idw_pick_detail.GetItemNumber(llPickDetailRow,'quantity')))
					ldqty = ldqty - idw_pick_detail.GetItemNumber(llPickDetailRow,'quantity')
//				End If
			
			//Set Child Sku Values
				idw_putaway.SetItem(llCompRow,"sku",lu_ds.GetItemString(llRowPos,"sku_child"))
				idw_putaway.SetItem(llCompRow,"supp_code",lu_ds.GetItemString(llRowPos,"supp_code_child"))
		
				idw_putaway.SetItem(llCompRow,"serialized_ind",lsSerialInd)
				idw_putaway.SetItem(llCompRow,"lot_controlled_ind",lsLotInd)
				idw_putaway.SetItem(llCompRow,"po_controlled_ind",lsPOInd)
				idw_putaway.SetItem(llCompRow,"po_no2_controlled_ind",lsPO2Ind)
				idw_putaway.SetItem(llCompRow,"expiration_controlled_ind",lsExpireInd)
		
//			Else //Pick Row not found
//				ldqty =0		
//			End If
			llPickDetailRow ++
		loop 
	ldQty = idw_putaway.GetItemNumber(alRow,"quantity")

	End If /*new or updated putaway row */
	
next
		
SetPointer(Arrow!)

Return 0
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
		lsNextContainer = Right(idw_main.GetItemString(1,'wo_no'),6) + String(llnextContainer,'000000')  /*start off with using the rowcount */
		//If found, keep bumping until no longer present
		llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
		Do While llFindRow > 0
			llNextContainer ++
			lsNextContainer = Right(idw_main.GetItemString(1,'ro_no'),6) + String(llnextContainer,'000000')
			llFindRow = idw_putaway.Find("Container_ID = '" + lsNextContainer + "'",1,idw_putaway.RowCount())
		Loop
				
End If
	
Return lsNextContainer
	

end function

public function integer wf_putaway_nycsp ();// 07/04 - PCONKL - Keep Lot, PO and Exp Date in sync from Picking to Putaway for NYCSP

Long	llRowPos, llRowCount, llLineItem, llFindRow, llOwnerID, llSubLine, llNewRow
String	lsSKU, lsLot, lsPO, lsFind, lsLoc, lsOrder, lsSupplier, lsWarehouse, lsInvType, lsCOO, lsOwnerName, lsComp,	&
			lsSerialInd, lspo2Ind, lsContainerInD, lsLocation
dateTIme	ldtExpDt
Decimal	ldPickQTY, ldPutQty

//For each Picking Row, we should have a Multiple matching Putaway Row with the same Lot # , PO  and Exp Date 
// We may have multiple putaway records to have the correct QTY

llRowCount = idw_Pick.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = idw_Pick.GetITemString(llRowPos,'SKU')
	lsLot = idw_Pick.GetITemString(llRowPos,'Lot_No')
	lsPO = idw_Pick.GetITemString(llRowPos,'po_no')
	lsCOO = idw_Pick.GetITemString(llRowPos,'Country_of_Origin')
	llLineITem = idw_Pick.GetITemNumber(llRowPos,'Line_Item_No')
	ldPickQty = idw_Pick.GetITemNumber(llRowPos,'Quantity')
	ldtExpDt = idw_Pick.GetITemdateTime(llRowPos,'Expiration_Date')
	lsOrder = idw_main.GetITemString(1,'wo_no')
	llOwnerID = idw_Pick.GetItemNumber(llRowPos,"owner_id")
	lsOwnername = idw_Pick.GetItemString(llRowPos,"cf_owner_name")
	lsSupplier = idw_Pick.getITemString(llRowPos,"supp_code")
// TAM 2011/01/18 Added location.  You could have same inventory in 2 locations and it wasn't finding for the second location.
	lsLocation = idw_Pick.GetITemString(llRowPos,'L_code')
	
	//If this SKU is found on the detail, then they are picking and putting away the same SKU
//	If idw_Detail.Find("Upper(SKU) = '" + Upper(lsSKU) + "'",1,idw_detail.RowCount()) <= 0 Then Continue
	
	//See how many rows we have of this SKU/Lot
//	ldPutQty = 0  TAM 2012/08/01  Move this below the pick loop
//	lsFind = "Upper(sku) = '" + upper(lsSKU) +  "' and upper(lot_no) = '" + Upper(lsLot) + "' and Expiration_Date = '" + String(ldtExpDt)  + "'"
// TAM 2011/01/18 Added location.  You could have same inventory in 2 locations and it wasn't finding for the second location.
//	lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(lot_no) = '" + Upper(lsLot) + "' and Upper(po_no) = '" + Upper(lsPO) + "' and String(expiration_date,'mm/dd/yyyy') = '" + String(ldtExpDt,'mm/dd/yyyy') + "'" 
// TAM 2012/06 Added Supplier.  You could have inventory with 2 supplier.
//	lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(lot_no) = '" + Upper(lsLot) + "' and Upper(po_no) = '" + Upper(lsPO) + "' and String(expiration_date,'mm/dd/yyyy') = '" + String(ldtExpDt,'mm/dd/yyyy') + "'" + " and upper(l_code) = '" + lslocation + "'" 
	lsFind = "Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(lot_no) = '" + Upper(lsLot) + "' and Upper(po_no) = '" + Upper(lsPO) + "' and String(expiration_date,'mm/dd/yyyy') = '" + String(ldtExpDt,'mm/dd/yyyy') + "'" + " and upper(l_code) = '" + lslocation + "'" + " and upper(supp_code) = '" + lssupplier + "'" 
	llFindRow = idw_Putaway.Find(lsFind,1,idw_Putaway.RowCount())
	
	Do While llFindRow > 0
		
		ldPutQty += idw_putaway.GetITemNumber(llFindROw,'Quantity')
		llFindRow ++
		If llFindRow > idw_Putaway.RowCount() Then Exit
		llFindRow = idw_Putaway.Find(lsFind,llFindRow,idw_Putaway.RowCount())
		
	Loop
// TAM 2012/08/01 Moved from above.  It was resetting the qty to soon
	//See how many rows we have of this SKU/Lot
	ldPutQty = 0
	
	//If Pick Qty = Putaway qty for his pedimento then we don't need to do anythin with this row
	If ldPutQty >= ldPickQty Then Continue
	
	If lsLot = '-' and lsPO = '-' and string(ldtExpDt) = '2999/12/31' Then Continue
	
	Do While ldPutQty < ldPickQty
		
	//if there is an existing non confirmed putaway row for this line/sku, update lot, expiration date info, othewise skip
//		lsFind = "Line_Item_No = " + String(llLineItem) + " and Upper(sku) = '" + upper(lsSKU) + "'" 
/// TAM 2011/01/18 Added location.  You could have same inventory in 2 locations and it wasn't finding for the second location.
//		lsFind = "Line_Item_No = " + String(llLineItem) + " and Upper(sku) = '" + upper(lsSKU) + "' and lot_no = '-' and  po_no = '-' and  String(Expiration_Date,'yyyy/mm/dd') = '2999/12/31'" //looking for unchanged putaway records
// TAM 2012/06 Added Supplier.  You could have inventory with 2 supplier.
		lsFind = "Line_Item_No = " + String(llLineItem) + " and Upper(sku) = '" + upper(lsSKU) + "' and lot_no = '-' and  po_no = '-' and  String(Expiration_Date,'yyyy/mm/dd') = '2999/12/31' and  l_code = '' "  //looking for unchanged putaway records
//		lsFind = "Line_Item_No = " + String(llLineItem) + " and Upper(sku) = '" + upper(lsSKU) + "' and lot_no = '-' and  po_no = '-' and  String(Expiration_Date,'yyyy/mm/dd') = '2999/12/31' and  l_code = '' " +  " and Upper(supp_code) = '" + upper(lsSupplier) + "'"//looking for unchanged putaway records
		llFindRow = idw_Putaway.Find(lsFind,1,idw_putaway.RowCount())
		If llFindRow > 0 Then /*update existing Putaway*/
			idw_Putaway.SetItem(llFindRow,'lot_no', lsLot) 
			idw_Putaway.SetItem(llFindRow,'po_no', lspo) 
			idw_Putaway.SetItem(llFindRow,'expiration_date', ldtExpDt)
			ldPutQty += idw_putaway.GetITemNumber(llFindRow,'Quantity')
			idw_Putaway.SetItem(llFindRow,'l_code', lsLocation)
			idw_Putaway.SetItem(llFindRow,'supp_code', lsSupplier) 
			Else /*Exit*/
			ldPutQty = ldPickQty 
		End If
	Loop
	
Next /*Pick Row*/


Return 0
end function

public function integer uf_revert_pallet (string as_palletid);// If FG Putaway record is deleted before confirm, change the FG pallet ID back to picking pallet ID
Int 		RetVal = 0
Int			liPallets = 0
Int			liPickRow = 0
Long		llRow, llRows
String		lsPickPallet, lsPickSKU, lsPickSuppCode, lsSKU, lsSuppCode, lsPalletID, lsSerialNo
String		lsSQLSyntax, lsSQLWhere, ERRORS, lsMsg, lsLast, lsCreateDate, lsFind
 
u_ds		lds_Serial 

lsSQLWhere = "('"

llRows = idw_pick.RowCount()
For llRow = 1 to llRows
	lsPalletID = idw_pick.GetItemString(llRow,"lot_no")
	If lsPalletID <> '-' Then
		lsPickPallet = lsPalletID
		liPickRow = llRow
		liPallets = liPallets + 1
		lsSQLWhere += lsPickPallet + "','"
	End If
Next

lsSQLWhere = left(lsSQLWhere,len(lsSQLWhere)-2) + ")"

// If there are more than one pallets on picking list, we must find the original pallet for the FG pallet
If liPallets > 1 Then
	lsSQLSyntax = "select ith.pallet_id,cs.serial_no,convert(varchar(20),ith.create_date,101) " + &
						"from carton_serial cs, comcast_itd itd, comcast_ith ith " + &
						"where cs.project_id = 'Comcast' and itd.serial_no = cs.serial_no " + &
						"and ith.tran_nbr = itd.tran_nbr and cs.pallet_id = '" + as_PalletID + "' " + &
						"order by cs.serial_no, ith.create_date desc "
	lds_Serial = Create u_ds
	lds_Serial.dataobject = 'd_comcast_recon'
	lds_Serial.Create(SQLCA.SyntaxFromSQL(lsSQLSyntax,"",ERRORS))
	lds_Serial.SetTransObject(SQLCA)
	llRows = lds_Serial.Retrieve()
	IF SQLCA.SQLCode = -1 OR llRows = -1 THEN 
		MessageBox("SQL error", ERRORS)	
	else
		lsMsg = ""
		lsLast = ""
		For llRow = 1 To llRows
			lsSerialNo = lds_Serial.GetItemString(llRow,2)
			lsPickPallet = lds_Serial.GetItemString(llRow,1)
			lsCreateDate = lds_Serial.GetItemString(llRow,3)
			if lsSerialNo <> lsLast Then
				lsFind = "lot_no = '" + lsPickPallet + "'"
				liPickRow = idw_Pick.Find(lsFind,1,idw_Pick.RowCount())
				lsPickSKU = idw_pick.GetItemString(liPickRow, "SKU")
				lsPickSuppCode = idw_pick.GetItemString(liPickRow, "supp_code")

				Execute Immediate "Begin Transaction" using SQLCA;

				Update carton_serial Set pallet_id = :lsPickPallet, SKU = :lsPickSKU, supp_code = :lsPickSuppCode
								Where project_id = 'COMCAST' and pallet_id = :as_PalletID 
								and serial_no = :lsSerialNo using SQLCA;
								
				Execute Immediate "COMMIT" using SQLCA;
			End If
			lsLast = lsSerialNo
		Next
	end if
Else
	lsSQLSyntax = "Select ith.pallet_id from Comcast_ITH ith, Comcast_ITD itd Where itd.tran_nbr= ith.tran_nbr " + &
						"and ith.pallet_id in " + lsSQLWhere 
	lsPickSKU = idw_pick.GetItemString(liPickRow, "SKU")
	lsPickSuppCode = idw_pick.GetItemString(liPickRow, "supp_code")

	Execute Immediate "Begin Transaction" using SQLCA;

	Update carton_serial Set pallet_id = :lsPickPallet, SKU = :lsPickSKU, supp_code = :lsPickSuppCode
								Where project_id = 'COMCAST' and pallet_id = :as_PalletID;
								
	Execute Immediate "COMMIT" using SQLCA;
	
End If

return RetVal

end function

public subroutine dodisplaymessage (string _title, string _message);
// doDisplayMessage( string _title, string _message )

str_parms	lstrParms


lstrParms.string_arg[1] = _title
lstrParms.string_arg[2] = _message

openwithparm( w_scan_message, lstrParms )

end subroutine

public function integer wf_component_sku_visible (boolean as_visible, string as_order_type);//02/20 - MikeA S42641 F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order

tab_main.tabpage_main.dw_workorder_component_sku.Visible =  as_visible

tab_main.tabpage_main.gb_component_sku.visible =  as_visible
tab_main.tabpage_main.cb_component_sku_add.visible =  as_visible
tab_main.tabpage_main.cb_component_sku_delete.visible =  as_visible
tab_main.tabpage_main.cb_component_sku_import.visible =  as_visible

SetRedraw(False)
tab_main.tabpage_main.SetRedraw(False)

if as_visible then

	idw_main.object.user_field3_t.visible = false
	idw_main.object.user_field3.visible = false
	idw_main.object.user_field4_t.visible = false
	idw_main.object.user_field4.visible = false
	
	idw_main.object.remarks_t.y = 1078
	idw_main.object.remarks.y = 1078

	idw_main.object.remarks.height = 240

	idw_main.Modify("user_field1_t.Text='Parent SKU'")
	idw_main.Modify("user_field2_t.Text='Parent Supp'")	

	Choose Case as_order_type
	CASE 'A'
		tab_main.tabpage_main.dw_workorder_component_sku.object.userfield_1_t.Text='Component QTY'
	CASE 'D'
		tab_main.tabpage_main.dw_workorder_component_sku.object.userfield_1_t.Text='Component Loc'
	END CHOOSE

else
	
	idw_main.object.user_field3_t.visible = true
	idw_main.object.user_field3.visible = true
	idw_main.object.user_field4_t.visible = true
	idw_main.object.user_field4.visible = true
	
	idw_main.object.remarks_t.y = 774
	idw_main.object.remarks.y = 774

	idw_main.object.remarks.height = 298


end if

SetRedraw(True)
tab_main.tabpage_main.SetRedraw(True)

Return 1
end function

public function string getronocompletedate (string asrono);//GailM 7/10/2020 S47693 F20484 I2896 KNY - NYCSP: Use RO_NO Date vs. WO_NO Date When Creating WOs
Datetime ldtCompDate
String		lsRtnCompDate

SELECT complete_date INTO :ldtCompDate FROM receive_master WITH (NOLOCK) where ro_no = :asRoNo USING SQLCA;

lsRtnCompDate = String(ldtCompDate,'MM/DD/YYYY HH:MM')

Return lsRtnCompDate

end function

public function integer wf_reset_putaway ();/*GailM 8/31/2020 - DE17355 - If workorder is voided when FG putaway is not confirmed then reset content_summary SIT and WIP qty to 0 */
Int liRtn, liCount, liPos, liRows

liRtn = 0
String lsSKU, lsSuppCode, lsCOO, lsLoc, lsSerialNo, lsLotNo, lsPoNo, lsPoNo2, lsInvType, lsCtnrId, lsOldInvType, lsOldCtnrId, lsOldLoc
Datetime ldtExpDt
Long llOwnerId, llSqlNRows

liCount = idw_putaway.rowcount()
If liCount > 0 Then
	Execute Immediate "Begin Transaction" using SQLCA;
	For liPos = 1 to liCount
	
		lsSKU = idw_putaway.getitemstring(liPos,'sku')
		lsSuppCode = idw_putaway.getitemstring(liPos,'supp_code')
		llOwnerId = idw_putaway.getitemnumber(liPos,'owner_id')
		lsCOO = idw_putaway.getitemstring(liPos,'country_of_origin')
		lsLoc = idw_putaway.getitemstring(liPos,'l_code')
		lsSerialNo = idw_putaway.getitemstring(liPos,'serial_no')
		lsLotNo = idw_putaway.getitemstring(liPos,'lot_no')
		lsPoNo = idw_putaway.getitemstring(liPos,'po_no')
		lsPoNo2 = idw_putaway.getitemstring(liPos,'po_no2')
		ldtExpDt = idw_putaway.getitemdatetime(liPos,'expiration_date') 
		lsInvType = idw_putaway.getitemstring(liPos,'inventory_type')
		lsCtnrId = idw_putaway.getitemstring(liPos,'container_id')
		lsOldInvType = idw_putaway.getitemstring(liPos,'old_inventory_type')
		lsOldCtnrId = idw_putaway.getitemstring(liPos,'old_container_id')
		lsOldLoc = idw_putaway.getitemstring(liPos,'old_l_code')
		
		update content_summary set sit_qty = 0, wip_qty = 0 
		where project_id = :gs_project
		and sku = :lsSKU
		and supp_code = :lsSuppCode
		and owner_id = :llOwnerId
		and country_of_origin = :lsCOO
		and serial_no = :lsSerialNo
		and lot_no = :lsLotNo
		and po_no = :lsPoNo
		and po_no2 = :lsPoNo2
		and expiration_date = :ldtExpDt
		and ( inventory_type = :lsInvType or inventory_type = :lsOldInvType )
		and ( container_id = :lsCtnrId or container_id = :lsOldCtnrId )
		and ( l_code = :lsLoc or l_code = :lsOldLoc )
		using sqlca;
		
		llSqlNRows = SQLCA.SqlNRows
		liRows = llSqlNRows
		
		insert into gailm ( mycount, sku1, sku2, sku3, sku4, sku5 ) values (:liRows, :lsSKU, :lsCtnrId, :lsInvType, :lsOldCtnrId, :lsOldInvType) using sqlca;
		
	Next
	Execute Immediate "Commit " using SQLCA;
End If

Return liRtn
end function

on w_workorder.create
int iCurrent
call super::create
end on

on w_workorder.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
iw_window = This
tab_main.MoveTab(2,99) /*Search tab should always be last*/

end event

event ue_postopen;DatawindowChild	ldwc, ldwc2
String	lsSQL,	&
			lsModify,	&
			lsRC
		
i_nwarehouse = Create n_warehouse

idw_main = tab_main.tabpage_main.dw_main
idw_instructions = tab_main.tabpage_instructions.dw_instructions
idw_Detail = tab_main.tabpage_detail.dw_Detail
idw_pick = tab_main.tabpage_picking.dw_Picking

idw_Serial = tab_main.tabpage_cto_process.dw_Serial

idw_pick_Detail = tab_main.tabpage_picking.dw_PickDetail
idw_pick_Print = tab_main.tabpage_picking.dw_Pick_Print
idw_Putaway = tab_main.tabpage_putaway.dw_Putaway
idw_Putaway_Content = tab_main.tabpage_putaway.dw_Putaway_Content
//TAM -2014/05 - Kit Change Functionality - Add the Item Component DW to allow Item Component to be modified on Order Type Add/Delete
idw_Component_Parent = tab_main.tabpage_putaway.dw_Component_Parent
idw_Putaway_Print = tab_main.tabpage_putaway.dw_Putaway_Print
idw_Search_result = Tab_main.Tabpage_Search.dw_search_Result
idw_Search = Tab_main.Tabpage_Search.dw_search

isle_order = Tab_main.Tabpage_main.sle_Order

tab_main.tabpage_picking.cb_pic_locs.Enabled = FALse

tab_main.tabpage_putaway.cb_putaway_locs.Enabled = FALse

//Dropdown defaults
idw_detail.GetChild("supp_code",idwc_supplier_Detail)
idwc_supplier_Detail.SetTransObject(SQLCA)
idw_Pick.GetChild("supp_code",idwc_supplier_Pick)
idwc_supplier_Pick.SetTransObject(SQLCA)
idw_Putaway.GetChild("supp_code",idwc_supplier_Putaway)
idwc_supplier_Putaway.SetTransObject(SQLCA)

idw_pick.GetChild('inventory_type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)
idw_putaway.GetChild('inventory_type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2) /*share with other tabs*/

idw_main.GetChild('wh_code',ldwc)
ldwc.SetTransObject(SQLCA)
g.of_set_warehouse_dropdown(ldwc) /* 04/04 - PCONKL - Load from USer Warehouse Datastore*/
//ldwc.Retrieve(gs_project)

idw_search.GetChild('wh_code',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2) /*share with other tabs*/

tab_main.tabpage_main.dw_workorder_component_sku.SetTransObject(SQLCA)

idw_main.GetChild('ord_Type',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_project)
idw_search.GetChild('workorder_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2) /*share with other tabs*/
idw_search_result.GetChild('ord_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2) /*share with other tabs*/
tab_main.tabpage_main.dw_report.GetChild('ord_Type',ldwc2)
ldwc2.SetTransObject(SQLCA)
ldwc.ShareData(ldwc2) /*share with other tabs*/


isOrigSearchSQL = idw_search_result.GetSqlSelect() /*for tacking on search criteria to orig sql */

// Button visible - Scan kits for Comcast on FGPutaway tab - GXMOR - 01/24/2012
If gs_project = 'COMCAST' Then
	tab_main.tabpage_putaway.cb_scanunits.visible = True
End If

//Instance Datastores for Content and Picking - we will retrieve all items and retain in memory so we don't allocate same stock to 
// multiple lines of the same items
ids_content = Create n_ds_content /*retrievestart = Return 2, don't reset*/
// TAM 2011/01  Change to use a content dw for workorders.  We are getting a problem because the expiration date in content contains milliseconds.  WO is not using server picking.  On the server the expiration date is bracketed with.000 and .999 milliseconds in the where clause.
// We need to do this on this datawindow.  I did not want to change d_do_content.
//ids_content.Dataobject = 'd_do_content'
ids_content.Dataobject = 'd_wo_content'
ids_content.SetTransObject(SQLCA)

ids_Pick_alloc = Create n_ds_content
ids_Pick_alloc.Dataobject = 'd_workorder_auto_pick' 
ids_pick_alloc.SetTransObject(SQLCA)

idw_Search.InsertRow(0)

If gs_default_WH > '' Then
	idw_search.SetITem(1,'wh_code',gs_default_WH) /* 04/04 - PCONKL - Warehouse now required field on search to keep users within their domain*/
End IF

// Button visible - Scan kits for Comcast on FGPutaway tab - GWM - 01/24/2012
If gs_project = 'COMCAST' Then
	tab_main.tabpage_putaway.cb_scanunits.visible = True
ELSE
	tab_main.tabpage_putaway.cb_scanunits.visible = False	
End If

// Tab visible only for Riverbed
If gs_project = 'RIVERBED' Then
	tab_main.tabpage_cto_process.visible = True
ELSE
	tab_main.tabpage_cto_process.visible = False	
End If

This.TriggerEvent("ue_edit") /*start in Edit Mode */
end event

event ue_edit;
// Looking for unsaved changes
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

Tab_main.Tabpage_Detail.Enabled = False
Tab_main.Tabpage_instructions.Enabled = False
Tab_main.Tabpage_picking.Enabled = False
Tab_main.Tabpage_cto_process.Enabled = False
Tab_main.Tabpage_Putaway.Enabled = False

//idw_Main.Enabled = False
//idw_detail.Enabled = False
//idw_Pick.Enabled = False

// Tab properties
isle_Order.Visible=True
isle_order.DisplayOnly = False
isle_order.TabOrder = 10

idw_main.Hide()

idw_Detail.Reset()
idw_Instructions.Reset()
idw_Pick.Reset()
idw_Putaway.Reset()

tab_main.tabpage_Main.cb_confirm.Enabled = False
tab_main.tabpage_Main.cb_void.Enabled = False

//idw_search.REset()
//idw_Search.InsertRow(0)

wf_clear_screen()


isle_order.SetFocus()

is_wono = ''
end event

event ue_retrieve;call super::ue_retrieve;
String	lsOrder,	&
			lsWONO
DatawindowChild	ldwc
Long	llCount

lsOrder = isle_Order.Text

//Retrieve the Master
// 08/04 - PCONKL - need to retrive by wo_no instead of workorder_number which may not be unique
//If the Order # is null then select it from the db and continue
IF IsNull(is_wono) or is_wono = "" THEN
	
	
	Select Count(*) Into :llCount
	From WorkORder_MAster
	WHERE Workorder_Number = :lsorder and project_id = :gs_project;
	
	If llCount > 1 Then
		MessageBox(is_title, "Multiple Orders exist for this WorkOrder Number. Please select from the Search Screen!", Exclamation!)
		isle_Order.SetFocus()
		isle_Order.SelectText(1,Len(lsorder))
		RETURN
	ElseIf llCount < 1 Then
		MessageBox(is_title, "WorkOrder not found, please enter again!", Exclamation!)
		isle_Order.SetFocus()
		isle_Order.SelectText(1,Len(lsorder))
		RETURN
	Else
		SELECT WO_no
		INTO :is_wono
		FROM WorkOrder_Master
		WHERE Workorder_number = :lsorder and project_id = :gs_project;
	End If
END IF

IF is_wono = "" THEN RETURN

idw_Main.Retrieve(gs_Project, is_wono)

If idw_Main.RowCount() > 0 Then /*Order Found*/

	lsWONO = idw_Main.GetITemString(1,"wo_no")
	
	idw_main.Show()
	
	//Retrieve other tabs
	idwc_supplier_Detail.InsertRow(0)
	idw_Detail.Retrieve(lsWONO)

	idw_instructions.Retrieve(gs_project,lsWONO)
	
	idwc_supplier_Pick.InsertRow(0)
	idw_pick.GetChild('deliver_to_location',ldwc) /*retrived by Warehouse*/
	ldwc.SetTransObject(SQLCA)
	ldwc.InsertRow(0)
	
	idw_Pick.Retrieve(lsWONO)
	
	idw_Serial.Reset()
	
	if idw_Serial.Retrieve(lsWONO, gs_project) > 0 then
//		tab_main.tabpage_cto_process.cb_generate.enabled = false
	else
		tab_main.tabpage_cto_process.cb_generate.enabled = false
	end if
	
	idwc_supplier_Putaway.InsertRow(0)
	idw_putaway.Retrieve(lsWONO)
	
	isle_Order.Visible = FALse
	
	Tab_main.SelectTab(1)
	
	wf_Check_Status()
	
	ibConfirmRequested = False
	ibPickShort = False /*we won't allow a short pick to be saved */

	tab_main.tabpage_putaway.cb_confirm_putaway.Enabled = False
	
	// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete the Set userfield text
	If idw_main.GetItemString(1,"ord_type") = 'A' or  idw_main.GetItemString(1,"ord_type") = 'D' Then
		
		wf_component_sku_visible(true,  idw_main.GetItemString(1,"ord_type"))

		tab_main.tabpage_main.dw_workorder_component_sku.Retrieve(lsWONO)

		//idw_main.Modify("user_field1_t.Text='Parent SKU'")
		
		//idw_main.Modify("user_field3_t.Text='Component SKU'")


		//DE13716: NYCSP-Defect: Component Qty/Loc Field Not Working
		//Changed UserField4 based on order type to match what was in itemchanged. 
		
//		If idw_main.GetItemString(1,"ord_type") = 'A' then 
//			//idw_main.Modify("user_field4_t.Text='Component QTY'")
//			tab_main.tabpage_main.dw_workorder_component_sku.Modify("user_field1_t.Text='Component QTY'")
//		Else
//			//idw_main.Modify("user_field4_t.Text='Component Loc'")
//			tab_main.tabpage_main.dw_workorder_component_sku.Modify("user_field1_t.Text='Component Loc'")
//			
//		End If
		idw_main.Modify("user_field2_t.Text='Parent Supp'")	
		idw_detail.object.Line_Item_No.Protect  = True
        	idw_detail.object.SKU.Protect  = True   
       	idw_detail.object.Supp_code.Protect  = True   
        	idw_detail.object.Req_qty.Protect  = True   
       	idw_detail.object.Alloc_Qty.Protect  = True   
       	idw_detail.object.User_Field1.Protect  = True   
        	idw_detail.object.User_Field2.Protect  = True 
		idw_detail.object.Component_Ind.Protect  = True 
		tab_main.tabpage_detail.cb_insert_detail.visible = False
		tab_main.tabpage_detail.cb_delete_detail.visible = False
		tab_main.tabpage_picking.cb_insert_pick.visible = False
		tab_main.tabpage_picking.cb_delete_pick.visible = False
		tab_main.tabpage_putaway.cb_insert_putaway.visible = False
		tab_main.tabpage_putaway.cb_delete_putaway.visible = False
		tab_main.tabpage_putaway.cb_putaway_locs.visible = False
		tab_main.tabpage_putaway.cb_2.visible = False
	Else
		
		wf_component_sku_visible(true,  "")
	
	End If
	
Else /*Order Not Found */
	
	MessageBox(is_title, "WorkOrder not found!", Exclamation!)
	isle_Order.SetFocus()
	isle_Order.SelectText(1,Len(lsOrder))
	
End If /* Order Found? */


end event

event ue_new;call super::ue_new;string ls_Prefix,ls_order
long ll_no

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return

// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

// Clear existing data
This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
ibConfirmRequested = False
ibPickShort = False /*we won't allow a short pick to be saved */

tab_main.tabpage_putaway.cb_confirm_putaway.Enabled = False

isle_order.text = ""


wf_clear_screen()

idw_main.InsertRow(0)
idw_main.SetItem(1,"project_id",gs_project)
idw_main.SetItem(1,"ord_date",Today())
idw_main.SetItem(1,"wh_code",gs_default_wh)

If gs_project = 'GM_MI_DAT' Then
	idw_main.SetITem(1,"ord_Type",'P') 
Else
	idw_main.SetITem(1,"ord_Type",'S') 
End If

idw_main.SetITem(1,"ord_Status",'N')

wf_check_status()

idw_main.Show()
idw_main.SetFocus()
idw_main.SetColumn("delivery_invoice_no")

end event

event ue_save;Integer liRC, liRet
long i,ll_totalrows, llWONO, ll_Idx
String	lsOrder, lsWONO

long ldOwnerId,   ldAvailQty, ll_row,ll_count
String lswhcode, lsSku, lsSupplier
Datastore lds_detail_whs

IF f_check_access(is_process,"S") = 0 THEN Return -1

// Validations

SetPointer(HourGlass!)

//If idw_main.RowCount() <= 0 Then
//	Return 0
//End If
	
If wf_validation() = -1 Then
	SetMicroHelp("Save failed!")
	ibConfirmRequested = False
	Return -1
End If
	
If idw_main.RowCount() > 0 Then
	idw_main.SetItem(1,'last_update', g.of_getWorldTime() ) 
	idw_main.SetItem(1,'last_user',gs_userid)
End If

// Assign Order No.

If ib_edit = False Then
	
	// 10/00 PCONKL - Using Stored procedure to get next available WO_NO
	//						Prefixing with Project ID to keep Unique within System
		
	llWOno = g.of_next_db_seq(gs_project,'WorkOrder_Master','WO_No')
	If llWOno <= 0 Then
		messagebox(is_title,"Unable to retrieve the next available order Number!")
		Return -1
	End If
	
	lsorder = Trim(Left(gs_project,9)) + String(llWOno,"0000000")
			
	If idw_main.RowCount() > 0 Then
		idw_main.SetItem(1,"project_id",gs_project)
		idw_main.SetItem(1,"wo_no",lsorder)
		idw_main.SetItem(1,"workOrder_number",Right(lsorder,7))
		idw_main.SetItem(1, "ord_status", "N")	
	End If
	
	For i = 1 to idw_detail.RowCount()
		idw_detail.SetItem(i, "wo_no", lsorder)
	Next		

Else /*Edit existing record*/
	
	If idw_main.RowCount() > 0 Then
		If idw_main.GetItemString(1, "ord_status") <> "C" Then
			If idw_main.GetItemString(1, "ord_status") = "V" Then	//GailM 8/31/2020 DE17355 NYCSP - Defect: Work Orders Updates - Cannot void an order
				If isOrigStatus = "F" Then
					liRet = wf_reset_putaway()
				End If
			ElseIf idw_Pick.RowCount() > 0 Then
				idw_main.SetItem(1, "ord_status", "P")
				If idw_putaway.RowCOunt() > 0 Then
					idw_main.SetItem(1, "ord_status", "F") /*set to FG Putaway if we have Putaway recs (in addition to Picking)*/
				End If
			Else
				idw_main.SetItem(1, "ord_status", "N")			
			End If
		End If
	End If
	
End If /*new/Update */

// Updating the Datawindow

//Update Picking Allocation to Content
// 08/08 - PCONKL - MOved to server - Content will be updated if the other records are saved successfully...
If idw_main.RowCount() > 0 Then
	liRc = wf_update_Content()
End If

If liRC < 0 Then REturn -1

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If idw_main.RowCount() > 0 Then /*we may be deleting the order, no header*/
	liRC = idw_main.Update()
Else
	liRC = 1
End If

if liRC = 1 then liRC = idw_detail.Update(False, FALse)
if liRC = 1 then liRC = idw_instructions.Update(False, FALse)

// 08/08 - PCONKL - Being updated on server

if liRC = 1 then liRC = idw_Pick.Update(False, FALse)
if liRC = 1 then liRC = idw_Pick_detail.Update(False, FALse)

if liRC = 1 then liRC = ids_content.Update(False, FALse) /*Picked Goods allocated from Content*/
		IF SQLCA.SQLCode = -1 THEN MessageBox("SQL error", SQLCA.SQLErrText)		



if liRC = 1 then liRC = idw_putaway.Update(False, FALse)
if liRC = 1 then liRC = idw_putaway_Content.Update(False, FALse) /*FG Putaway to Content*/
if liRC = 1 then liRC = idw_component_parent.Update(False, FALse) /*TAM 2014/05 Kit Change Funtionality - Update the component item master*/

if liRC = 1 then liRC = idw_Serial.Update(False, FALse)

//02/20 - MikeA S42641 F20283 - I2758 - KNY - City of New York EM - Add or Delete Multiple Component SKUs from Work Order
//Make sure WorkOrder number is updated.
if tab_main.tabpage_main.dw_workorder_component_sku.RowCount() > 0 then
	
	lsWONO = idw_main.GetITemString(1,'wo_no')
	
	for ll_Idx = 1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount()
		IF IsNull(tab_main.tabpage_main.dw_workorder_component_sku.GetItemstring(ll_Idx,"Wo_No")) THEN &
		 	tab_main.tabpage_main.dw_workorder_component_sku.SetItem(ll_Idx, "Wo_No",  lsWONO)
	next
end if




if liRC = 1 then liRC = tab_main.tabpage_main.dw_workorder_component_sku.Update(False, FALse)

If liRC = 1 and idw_main.RowCOunt() = 0 Then 
	liRC = idw_main.Update(False, FALse)
End If


IF (liRC = 1) THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN
		
//		// 08/08 - PCONKL - UPdating Content on Server
//		If idw_main.GetItemString(1,"ord_status") <> "C" Then
//			
//			If wf_update_content_Server() = -1 Then 
//				return - 1
//			End If
//			
//		End If
		
		idw_detail.ResetUpdate()
		idw_Instructions.ResetUpdate()
		idw_Pick.ResetUpdate()
		idw_Pick_Detail.ResetUpdate()
		ids_Content.ResetUpdate()
		idw_Putaway.ResetUpdate()
		idw_Putaway_Content.ResetUpdate()
		idw_component_parent.ResetUpdate()//TAM 2014 - Kit CHange functionality
		idw_Serial.ResetUpdate()
		tab_main.tabpage_main.dw_workorder_component_sku.ResetUpdate()
		ib_changed = False
		ib_edit = True
		This.Title = is_title  + " - Edit"
		If idw_main.RowCount() > 0 Then
			wf_check_status()
		End If
		SetMicroHelp("Record Saved!")
		
   ELSE
		
		Execute Immediate "ROLLBACK" using SQLCA;
		ids_content.Reset() /*make sure we don't save content changes later */
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
		
   END IF
ELSE
   Execute Immediate "ROLLBACK" using SQLCA;
	SetMicroHelp("Save failed!")
	MessageBox(is_title, "System error, record save failed!")
	Return -1
END IF

Return 0
end event

event resize;call super::resize;
tab_main.Resize(workspacewidth(),workspaceHeight())
tab_main.tabpage_instructions.dw_instructions.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_detail.dw_detail.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_picking.dw_picking.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.tabpage_putaway.dw_putaway.Resize(workspacewidth() - 80,workspaceHeight()-250)
tab_main.Tabpage_search.dw_search_result.Resize(workspacewidth() - 80,workspaceHeight()-550)
end event

event ue_delete;call super::ue_delete;
Long i, ll_cnt

//If f_check_access(is_process,"D") = 0 Then Return


If Messagebox(is_title, "Are you sure you want to delete this record?", Question!,yesno!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

//GAP 12/02 -  retrieving inventory types and shipping indicators. 
IF IsValid(ids_inv_type) = FALSE THEN
	ids_inv_type = Create datastore
	ids_inv_type.Dataobject = 'd_inv_type'
	ids_inv_type.SetTransObject(sqlca)
	ids_inv_type.Retrieve(gs_project)
	//ll_rtn = ids_inv_type.rowcount()
end if 

ll_cnt = idw_pick.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_pick.DeleteRow(i)
Next

ll_cnt = idw_putaway.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_putaway.DeleteRow(i)
Next

ll_cnt = idw_detail.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_detail.DeleteRow(i)
Next

ll_cnt = idw_instructions.Rowcount()
For i = ll_cnt to 1 Step -1
	idw_instructions.DeleteRow(i)
Next

If wf_update_content() = -1 Then return

idw_main.DeleteRow(1)

ib_changed = False

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record deleted!")
Else
	SetMicroHelp("Record	deleted failed!")
End If

This.TriggerEvent("ue_edit")


end event

event ue_print;call super::ue_print;String	lsWONO,	&
			lsSKU

Long	llRowCount,	&
		llRowPos
		
Decimal	ldQty
		
//Print the WorkOrder Report

If ib_changed Then
	Messagebox(is_title, 'Please save your changes first.')
End If

If idw_main.RowCOunt() > 0 and idw_Detail.RowCount() > 0 Then
	
	lsWONO = idw_main.GetITemString(1,'wo_no')
	Tab_main.Tabpage_main.dw_report.Retrieve(lsWONO)
	
	//Retrieve any FG Putaway Counts
	llRowCount = Tab_main.Tabpage_main.dw_report.RowCOunt()
	For llRowPos = 1 to llRowCount
		lsSKu = Tab_main.Tabpage_main.dw_report.GetITemString(llRowPos,'workorder_detail_SKU')
		
		Select Sum(quantity) 
		Into	:ldQty
		From WorkOrder_Putaway
		Where wo_no = :lsWONO and SKU = :lsSKU;
		
		Tab_main.Tabpage_main.dw_report.SetITem(llRowPos,'c_fg_qty',ldQty)
		
	Next

	Openwithparm(w_dw_print_options,Tab_main.Tabpage_main.dw_report) 
	
Else
	
	Messagebox(is_title,'Nothing to print!')
	
End If
end event

type tab_main from w_std_master_detail`tab_main within w_workorder
integer x = 18
integer y = 28
integer width = 4064
tabpage_instructions tabpage_instructions
tabpage_detail tabpage_detail
tabpage_picking tabpage_picking
tabpage_cto_process tabpage_cto_process
tabpage_putaway tabpage_putaway
end type

on tab_main.create
this.tabpage_instructions=create tabpage_instructions
this.tabpage_detail=create tabpage_detail
this.tabpage_picking=create tabpage_picking
this.tabpage_cto_process=create tabpage_cto_process
this.tabpage_putaway=create tabpage_putaway
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_instructions,&
this.tabpage_detail,&
this.tabpage_picking,&
this.tabpage_cto_process,&
this.tabpage_putaway}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_instructions)
destroy(this.tabpage_detail)
destroy(this.tabpage_picking)
destroy(this.tabpage_cto_process)
destroy(this.tabpage_putaway)
end on

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer width = 4027
string text = "Order Info"
dw_workorder_component_sku dw_workorder_component_sku
cb_component_sku_import cb_component_sku_import
cb_component_sku_delete cb_component_sku_delete
cb_component_sku_add cb_component_sku_add
gb_component_sku gb_component_sku
cb_create_detail cb_create_detail
cb_1 cb_1
cb_void cb_void
cb_confirm cb_confirm
st_1 st_1
dw_report dw_report
sle_order sle_order
dw_main dw_main
end type

on tabpage_main.create
this.dw_workorder_component_sku=create dw_workorder_component_sku
this.cb_component_sku_import=create cb_component_sku_import
this.cb_component_sku_delete=create cb_component_sku_delete
this.cb_component_sku_add=create cb_component_sku_add
this.gb_component_sku=create gb_component_sku
this.cb_create_detail=create cb_create_detail
this.cb_1=create cb_1
this.cb_void=create cb_void
this.cb_confirm=create cb_confirm
this.st_1=create st_1
this.dw_report=create dw_report
this.sle_order=create sle_order
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_workorder_component_sku
this.Control[iCurrent+2]=this.cb_component_sku_import
this.Control[iCurrent+3]=this.cb_component_sku_delete
this.Control[iCurrent+4]=this.cb_component_sku_add
this.Control[iCurrent+5]=this.gb_component_sku
this.Control[iCurrent+6]=this.cb_create_detail
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_void
this.Control[iCurrent+9]=this.cb_confirm
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.sle_order
this.Control[iCurrent+13]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.dw_workorder_component_sku)
destroy(this.cb_component_sku_import)
destroy(this.cb_component_sku_delete)
destroy(this.cb_component_sku_add)
destroy(this.gb_component_sku)
destroy(this.cb_create_detail)
destroy(this.cb_1)
destroy(this.cb_void)
destroy(this.cb_confirm)
destroy(this.st_1)
destroy(this.dw_report)
destroy(this.sle_order)
destroy(this.dw_main)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer width = 4027
cb_clear cb_clear
cb_search cb_search
dw_search_result dw_search_result
dw_search dw_search
end type

on tabpage_search.create
this.cb_clear=create cb_clear
this.cb_search=create cb_search
this.dw_search_result=create dw_search_result
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.dw_search_result
this.Control[iCurrent+4]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_clear)
destroy(this.cb_search)
destroy(this.dw_search_result)
destroy(this.dw_search)
end on

type dw_workorder_component_sku from u_dw_ancestor within tabpage_main
boolean visible = false
integer x = 562
integer y = 696
integer width = 1947
integer height = 404
integer taborder = 30
string dataobject = "d_workorder_component_sku"
boolean vscrollbar = true
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
ib_changed = true
end event

type cb_component_sku_import from commandbutton within tabpage_main
boolean visible = false
integer x = 2661
integer y = 980
integer width = 411
integer height = 100
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import"
end type

event clicked;string ls_filename, ls_fullname
long i, rows
string ls_errtext, lsWONO

GetFileOpenName("Select File", ls_filename, ls_fullname, "txt", "Text Files (*.txt*), *.txt*")

If FileExists(ls_filename) Then

	SetPointer(hourglass!)
	
	lsWONO = idw_main.GetITemString(1,'wo_no')

	rows = tab_main.tabpage_main.dw_workorder_component_sku.Rowcount()
	If rows > 0 Then
		Choose Case MessageBox(is_title, "Delete existing records? "+&
				"~n Yes - Delete Existing Serial No's and Re-Import All ~n No - Only Import Serial No's. "+&
				"~n Cancel - Don't do Anything ", +&
				Question!, YesNoCancel!,3)
			Case 3
				Return
			Case 1

				//Need to delete any existing serial numbers first
				Execute Immediate "Begin Transaction" using SQLCA; /*PCONKL - Auto Commit Turned on to eliminate DB locks*/
	
				//Delete any CC_Serials entries That currently Exist
				delete from WorkOrder_Component_Sku 
				where WO_No =  :lsWONO
				Using SQLCA;			
				
					
				If sqlca.sqlcode <> 0 Then
					ls_ErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
					Execute Immediate "Rollback" using SQLCA;
					Messagebox(is_Title, "Unable to Delete the existing Work Order Component Skus!~r~r" + ls_ErrText)
					Return -1
				End If
				
				Execute Immediate "Commit" Using Sqlca;
				If sqlca.sqlcode <> 0 Then
					MessageBox(is_title,"Unable to Delete the existing Work Order Component Skus!~r~r")
					Return -1
				End If
				
				tab_main.tabpage_main.dw_workorder_component_sku.Reset()
				tab_main.tabpage_main.dw_workorder_component_sku.Setredraw(False)
					
				For i = rows to 1 Step -1
					tab_main.tabpage_main.dw_workorder_component_sku.DeleteRow( i )
				Next
				tab_main.tabpage_main.dw_workorder_component_sku.Setredraw(True)
		End Choose
	End If
	
	SetPointer(Hourglass!)

	tab_main.tabpage_main.dw_workorder_component_sku.ImportFile(ls_filename)
		
	FOR i =  1 to tab_main.tabpage_main.dw_workorder_component_sku.RowCount() 
		tab_main.tabpage_main.dw_workorder_component_sku.SetItem(i,'wo_no', lsWONO)
		tab_main.tabpage_main.dw_workorder_component_sku.SetItem(i, "line_item_no",  i)	
	NEXT

	tab_main.tabpage_main.dw_workorder_component_sku.SetRedraw(True)
	ib_changed = true
	MessageBox ("Import Success", "Complete upload")

End If




end event

type cb_component_sku_delete from commandbutton within tabpage_main
boolean visible = false
integer x = 2661
integer y = 876
integer width = 411
integer height = 100
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;
long ll_row
//ib_changed = True
SetPointer(Hourglass!)

ib_changed = true

IF MessageBox( is_title, "Are you sure you want to delete rows?",question!, yesno! ) = 1 Then 
	
	For ll_row = tab_main.tabpage_main.dw_workorder_component_sku.rowcount( ) to 1 Step -1
		If tab_main.tabpage_main.dw_workorder_component_sku.getItemString( ll_row, 'rowfocusindicator') ='Y' Then
			tab_main.tabpage_main.dw_workorder_component_sku.DeleteRow(ll_row)
		End If
	Next

ELSE
	For ll_row = 1 to tab_main.tabpage_main.dw_workorder_component_sku.rowcount( )
		If tab_main.tabpage_main.dw_workorder_component_sku.getItemString( ll_row, 'rowfocusindicator') ='Y' Then tab_main.tabpage_main.dw_workorder_component_sku.setItem( ll_row, 'rowfocusindicator', 'N')
	Next
Return
END IF
end event

type cb_component_sku_add from commandbutton within tabpage_main
boolean visible = false
integer x = 2661
integer y = 768
integer width = 411
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add"
end type

event clicked;
integer li_Row
string lsWONO

SetPointer(Hourglass!)

ib_changed = true

li_Row = tab_main.tabpage_main.dw_workorder_component_sku.InsertRow(0)

//wo_no

lsWONO = idw_main.GetITemString(1,'wo_no')

 tab_main.tabpage_main.dw_workorder_component_sku.SetItem(li_Row, "Wo_No",  lsWONO)
 tab_main.tabpage_main.dw_workorder_component_sku.SetItem(li_Row, "line_item_no",  li_Row)

tab_main.tabpage_main.dw_workorder_component_sku.ScrollToRow(li_Row)
tab_main.tabpage_main.dw_workorder_component_sku.SetFocus()
tab_main.tabpage_main.dw_workorder_component_sku.SetColumn("component_sku")


//Trigger Event ue_insert()

end event

type gb_component_sku from groupbox within tabpage_main
boolean visible = false
integer x = 2587
integer y = 700
integer width = 553
integer height = 400
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Component Sku"
end type

type cb_create_detail from commandbutton within tabpage_main
integer x = 2103
integer y = 1532
integer width = 475
integer height = 112
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Create Detail"
boolean cancel = true
end type

event clicked;
iw_Window.TriggerEvent('ue_create_kit_change_detail')
end event

type cb_1 from commandbutton within tabpage_main
integer x = 2697
integer y = 1532
integer width = 535
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print WO Report"
end type

event clicked;
iw_Window.TriggerEvent('ue_Print')
end event

type cb_void from commandbutton within tabpage_main
integer x = 1513
integer y = 1532
integer width = 361
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Void"
end type

event clicked;
iw_Window.TriggerEvent('ue_void')
end event

type cb_confirm from commandbutton within tabpage_main
integer x = 850
integer y = 1532
integer width = 361
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Confirm"
end type

event clicked;
iw_Window.TriggerEvent('ue_confirm')
end event

type st_1 from statictext within tabpage_main
integer x = 50
integer y = 80
integer width = 498
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "WorkOrder Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_ancestor within tabpage_main
boolean visible = false
integer x = 2130
integer y = 1532
integer width = 389
integer height = 108
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_workorder_report"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type sle_order from singlelineedit within tabpage_main
integer x = 553
integer y = 76
integer width = 663
integer height = 92
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

event modified;
iw_window.TriggerEvent('ue_retrieve')
end event

event getfocus;If This.text <> '' then
	This.SelectText(1, Len(Trim(This.Text)))
end If
end event

type dw_main from u_dw_ancestor within tabpage_main
integer x = 23
integer y = 44
integer width = 3447
integer height = 1428
integer taborder = 20
string dataobject = "d_workorder_master"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
ib_changed = True

// pvh 08/25/05 - GMT
choose case dwo.name
	case 'wh_code'
		g.setCurrentWarehouse( data )
	case 'ord_type'
		// TAM - Kit Change Functionality -If order Type is "A" kit change add or "D" kit change delete the Set userfield text and protect rows from being updated
		If data = 'A' or  data = 'D' Then
			wf_component_sku_visible(true, data)
		Else
			wf_component_sku_visible(false, "")
		End IF
	

		// TAM - Kit Change Functionality -If order Type is "A" Then USer FIeld4 = Component QTY. If "D" Then it is the Component Putaway Location
		If data = 'A' then
	//			idw_main.Modify("user_field4_t.Text='Component QTY'")

		Else
					
	//			idw_main.Modify("user_field4_t.Text='Component Loc'")


				idw_detail.object.Line_Item_No.Protect  = True
				idw_detail.object.SKU.Protect  = True   
				idw_detail.object.Supp_code.Protect  = True   
				idw_detail.object.Req_qty.Protect  = True   
				idw_detail.object.Alloc_Qty.Protect  = True   
				idw_detail.object.User_Field1.Protect  = True   
				idw_detail.object.User_Field2.Protect  = True 
				idw_detail.object.Component_Ind.Protect  = True 
				tab_main.tabpage_detail.cb_insert_detail.visible = False
				tab_main.tabpage_detail.cb_delete_detail.visible = False
				tab_main.tabpage_picking.cb_insert_pick.visible = False
				tab_main.tabpage_picking.cb_delete_pick.visible = False
				tab_main.tabpage_putaway.cb_insert_putaway.visible = False
				tab_main.tabpage_putaway.cb_delete_putaway.visible = False
				tab_main.tabpage_putaway.cb_putaway_locs.visible = False
				tab_main.tabpage_putaway.cb_2.visible = False
		End If

end choose

end event

event process_enter;call super::process_enter;
IF This.GetColumnName() = "remarks" THEN
	
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

event retrieveend;call super::retrieveend;// pvh 08/25/05 - GMT
if rowcount <=0 then return AncestorReturnValue
//
g.setCurrentWarehouse( dw_main.object.wh_code[ 1 ] )
//
return AncestorReturnValue
end event

type cb_clear from commandbutton within tabpage_search
integer x = 3090
integer y = 300
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;
idw_search.REset()
idw_Search.InsertRow(0)

If gs_default_WH > '' Then
	idw_search.SetITem(1,'wh_code',gs_default_WH) /* 04/04 - PCONKL - Warehouse now required field on search to keep users within their domain*/
End IF
end event

type cb_search from commandbutton within tabpage_search
integer x = 3090
integer y = 196
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;
idw_search_result.TriggerEvent('ue_retrieve')
end event

type dw_search_result from u_dw_ancestor within tabpage_search
integer x = 27
integer y = 412
integer width = 3959
integer height = 1220
integer taborder = 20
string dataobject = "d_workorder_search_result"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_retrieve;call super::ue_retrieve;String	lsnewSQL,	&
			lsWhere

DateTime	ldtTemp

Boolean	lbuseSku

If idw_search.AcceptText() < 0 Then Return

//Tackon any search Criteria

//BCR 09-JUL-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN
//The converted sql select has no WHERE clause. So, WHERE starts here...

//Always Include Project
lsWhere = "WHERE Project_id = '" + gs_project + "'"

//Include WorkOrder NUmber if PResent
If Not isnull(idw_search.GetITemString(1,'workOrder_Number')) Then
	lsWhere += " and workOrder_master.WorkOrder_number = '" + idw_search.GetITemString(1,'workOrder_Number') + "'"
End If

//Include WorkOrder Status if PResent
If Not isnull(idw_search.GetITemString(1,'workOrder_status')) Then
	lsWhere += " and workOrder_master.ord_status = '" + idw_search.GetITemString(1,'workOrder_status') + "'"
End If

//Include WorkOrder Type if PResent
If Not isnull(idw_search.GetITemString(1,'workOrder_type')) Then
	lsWhere += " and workOrder_master.ord_Type = '" + idw_search.GetITemString(1,'workOrder_type') + "'"
End If

//Include WorkOrder Priority if PResent
If Not isnull(idw_search.GetITemNumber(1,'priority')) Then
	lsWhere += " and workOrder_master.priority = " + String(idw_search.GetITemNumber(1,'priority'))
End If

//Include Delivery Order Number if PResent
If Not isnull(idw_search.GetITemString(1,'Delivery_Invoice_no')) Then
	lsWhere += " and workOrder_master.Delivery_Invoice_No = '" + idw_search.GetITemString(1,'Delivery_Invoice_No') + "'"
End If

//Include Warehouse if PResent
If Not isnull(idw_search.GetITemString(1,'wh_code')) Then
	lsWhere += " and workOrder_master.wh_code = '" + idw_search.GetITemString(1,'wh_code') + "'"
End If

//Include Order Date if Present
ldtTemp = idw_search.GetItemDateTime(1,"order_date_from")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.ord_date >= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

ldtTemp = idw_search.GetItemDateTime(1,"order_date_to")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.ord_date <= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

//Include Sched Date if Present
ldtTemp = idw_search.GetItemDateTime(1,"sched_date_from")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.sched_date >= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

ldtTemp = idw_search.GetItemDateTime(1,"sched_date_to")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.sched_date <= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

//Include Complete Date if Present
ldtTemp = idw_search.GetItemDateTime(1,"complete_date_from")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.complete_date >= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

ldtTemp = idw_search.GetItemDateTime(1,"complete_date_to")
If  Not IsNull(ldtTemp) Then
	lswhere += " and workOrder_master.complete_date <= '" + String(ldtTemp, "yyyy-mm-dd hh:mm") + "' "
End If

//Include SKU if PResent
If Not isnull(idw_search.GetITemString(1,'sku')) Then
	lsWhere += " and workOrder_detail.SKU = '" + idw_search.GetITemString(1,'SKU') + "'"
	lbUseSku = True /*we will want toremove outer join from master -> Detail */
End If

lsNewSql = isorigSearchSql + lsWhere

//If including search on SKU, remove the outer join on master - we only want to show masters that have sku in detail

//If lbUseSku Then
//	lsNewsql = Replace(lsnewsql,pos(lsnewsql,"*="),2,"=")
//End If

//BCR 09-JUL-2011: SQL 2008 Compatibility Project to convert "*=" to LEFT JOIN
If lbUseSku Then
	lsNewSql = Replace(lsNewSql,pos(lsNewSql,'LEFT'),4,'INNER') 
End If
//******************************************************

This.SetSqlSelect(lsNewSQL)

This.Retrieve()

If this.RowCOunt() > 0 Then
	
Else
	
	MessageBox(is_title, 'No records found.')
	
End If
end event

event clicked;call super::clicked;
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;call super::doubleclicked;
If row > 0 Then
	iw_window.TriggerEvent('ue_edit')
	If not ib_changed Then
		//isle_order.Text = This.GetItemString(row,'workorder_Number')
		is_wono = This.GetItemString(row,'wo_no')
		iw_window.TriggerEvent('ue_Retrieve')
	End If
End If
end event

type dw_search from datawindow within tabpage_search
event process_enter pbm_dwnprocessenter
integer x = 9
integer y = 12
integer width = 3442
integer height = 368
integer taborder = 50
string title = "none"
string dataobject = "d_work_order_search"
boolean border = false
boolean livescroll = true
end type

event process_enter;
Send(Handle(This),256,9,Long(0,0))
Return 1
end event

type tabpage_instructions from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4027
integer height = 1680
long backcolor = 79741120
string text = "Instructions"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_maintain_instructions cb_maintain_instructions
dw_instructions dw_instructions
end type

on tabpage_instructions.create
this.cb_maintain_instructions=create cb_maintain_instructions
this.dw_instructions=create dw_instructions
this.Control[]={this.cb_maintain_instructions,&
this.dw_instructions}
end on

on tabpage_instructions.destroy
destroy(this.cb_maintain_instructions)
destroy(this.dw_instructions)
end on

type cb_maintain_instructions from commandbutton within tabpage_instructions
integer x = 59
integer y = 12
integer width = 681
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Maintain Instructions..."
end type

event clicked;
iw_window.TriggerEvent('ue_maintain_instructions')
end event

type dw_instructions from u_dw_ancestor within tabpage_instructions
event ue_resequence ( )
integer x = 18
integer y = 124
integer width = 3973
integer height = 1500
integer taborder = 20
string dataobject = "d_workorder_instructions"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_resequence;
//reseq seq numbers

Long	llRowPos,	llRowCount

llRowCount = This.RowCount()

This.SetRedraw(False)

For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'seq_no',llRowPos)
Next

This.SetRedraw(True)
end event

event itemchanged;call super::itemchanged;
ib_changed = True



end event

event ue_insert;call super::ue_insert;

Long ll_row

This.SetFocus()
If This.AcceptText() = -1 Then Return

ll_row = This.GetRow()

If ll_row > 0 Then
	ll_row = This.InsertRow(ll_row + 1)
	This.ScrollToRow(ll_row)	
Else
	ll_row = This.InsertRow(0)
End If	

This.SetITem(ll_row,'wo_no',idw_main.GetITemString(1,'wo_no'))
This.SetITem(ll_row,'project_id',gs_project)

//Resequence
This.TriggerEvent('ue_resequence')

This.SetColumn('bom_text_id')

ib_Changed = True

end event

event ue_delete;call super::ue_delete;

Long	llRow

llRow = This.GetRow()
If llRow > 0 Then
	This.DeleteRow(llRow)
End If

This.TriggerEvent('ue_resequence')

ib_Changed = True
end event

type tabpage_detail from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4027
integer height = 1680
long backcolor = 79741120
string text = "Order Detail"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_verify_bom cb_verify_bom
cb_delete_detail cb_delete_detail
cb_insert_detail cb_insert_detail
dw_detail dw_detail
end type

on tabpage_detail.create
this.cb_verify_bom=create cb_verify_bom
this.cb_delete_detail=create cb_delete_detail
this.cb_insert_detail=create cb_insert_detail
this.dw_detail=create dw_detail
this.Control[]={this.cb_verify_bom,&
this.cb_delete_detail,&
this.cb_insert_detail,&
this.dw_detail}
end on

on tabpage_detail.destroy
destroy(this.cb_verify_bom)
destroy(this.cb_delete_detail)
destroy(this.cb_insert_detail)
destroy(this.dw_detail)
end on

type cb_verify_bom from commandbutton within tabpage_detail
integer x = 1463
integer y = 12
integer width = 457
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Verify BOM..."
end type

event clicked;
u_nvo_gm_ims	lu_ims

lu_ims = Create u_nvo_gm_ims

lu_ims.uf_verify_bom(iw_window, idw_Detail)
//wf_verify_bom()
end event

event constructor;
If gs_project = 'GM_MI_DAT' Then
	This.visible = True
Else
	This.visible = False
End If
end event

type cb_delete_detail from commandbutton within tabpage_detail
integer x = 494
integer y = 12
integer width = 421
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;idw_detail.TriggerEvent('ue_Delete')
end event

type cb_insert_detail from commandbutton within tabpage_detail
integer x = 41
integer y = 12
integer width = 421
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;
idw_detail.TriggerEvent('ue_insert')
end event

type dw_detail from u_dw_ancestor within tabpage_detail
event ue_set_column ( )
event ue_resequence ( )
integer y = 108
integer width = 4005
integer height = 1552
integer taborder = 20
string dataobject = "d_workorder_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_set_column;
This.SetColumn(isColumn)
end event

event ue_resequence;
Long	llRowPos, llRowCount

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetItem(llRowpos,'line_item_no',llRowPos)
Next
end event

event itemchanged;call super::itemchanged;Str_Parms	lStrparms
string ls_supp_code,ls_alternate_sku,ls_coo,ls_sku,ls_uom
Long ll_row,ll_owner_id,llCount
String	lsDDSQL
DatawindowChild	ldwc

ib_changed = True

Choose Case Upper(dwo.name)
	
	case 'SKU'
		
		//Check if item_master has the records for entered sku	
		llCount = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case llCount
			Case 1 /*only 1 supplier, Load*/
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				ls_sku = data
				ls_supp_code = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")
				goto pick_data
			Case is > 1 /*Supplier dropdown populated for current sku when focus received*/
				This.object.supp_code[row]=""
			Case Else			
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				tab_main.selecttab(3)
				return 1
		END Choose
		
	Case 'SUPP_CODE'
		
		 ls_sku = this.Getitemstring(row,"sku")
		 ls_supp_code = data
	 	goto pick_data
			
END Choose			

return

pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	
	ll_row =i_nwarehouse.ids.Getrow()
	
	//Only Components can go on the Order Detail Tab
	// 02/06 - PCONKL - Allow non components for package type Work Orders
	// 08/08 - PCONKL - Allow Non parents for all orders (in support of Diebold)
	
//	If i_nwarehouse.ids.GetItemString(ll_row,"component_ind") <> 'Y' and idw_main.GetITemString(1,'ord_type') <> 'P' Then
//		Messagebox(is_title, 'Only Component items can be selected.')
//		Return 1
//	End If
	
	ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id") 
	//Set the values from datastore ids which is item master  
	this.object.owner_id[row] = ll_owner_id
	This.SetITem(row,'Component_ind',i_nwarehouse.ids.GetItemString(ll_row,"component_ind"))
	This.SetITem(row,'sku_parent',ls_sku)
	//Get the owner name
	this.object.cf_owner_name[ row ] = g.of_get_owner_name(ll_owner_id)
			
	isColumn = "req_qty"
	This.PostEvent("ue_set_column")
	
ELSE
	
	MessageBox(is_title, "Invalid Supplier, please re-enter!")
	return 1
	
END IF


end event

event ue_insert;call super::ue_insert;
Long ll_row

idw_detail.SetFocus()
If idw_detail.AcceptText() = -1 Then Return

ll_row = idw_detail.GetRow()

idwc_supplier_Detail.InsertRow(0)

If ll_row > 0 Then
	ll_row = idw_detail.InsertRow(ll_row + 1)
	idw_detail.ScrollToRow(ll_row)	
Else
	ll_row = idw_detail.InsertRow(0)
End If	

idw_detail.SetITem(ll_row,'wo_no',idw_main.GetITemString(1,'wo_no'))
idw_detail.SetItem(ll_row,'line_item_no',ll_row)

idw_detail.setcolumn('sku')

ib_Changed = True

//This.PostEvent('ue_resequence')
end event

event ue_delete;call super::ue_delete;
Long	llRow

llRow = This.GetRow()
If llRow > 0 Then
	This.DeleteRow(llRow)
End If

ib_Changed = True

//This.PostEvent('ue_resequence')
end event

event constructor;call super::constructor;
IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
	this.object.cf_owner_name_t.visible = 0
End IF


end event

event itemerror;call super::itemerror;
Return 2
end event

event itemfocuschanged;call super::itemfocuschanged;

//If clicked on Supplier, populate for proper SKU/Supplier
If dwo.name = "supp_code" Then
	idwc_supplier_Detail.Retrieve(gs_project,This.GetITemString(row,'sku'))
End If
end event

event retrieveend;call super::retrieveend;
Integer i
long ll_owner
IF rowcount > 0  and Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to rowcount
		ll_owner=This.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.cf_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
	Next
END IF	
end event

event process_enter;call super::process_enter;IF This.GetColumnName() = "user_field2" THEN
	IF This.GetRow() = This.RowCount() THEN
		This.TriggerEvent('ue_insert')
	END IF
ELSE
	Send(Handle(This),256,9,Long(0,0))
End If
Return 1

end event

type tabpage_picking from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4027
integer height = 1680
long backcolor = 79741120
string text = "Component Picking"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pick_print dw_pick_print
cb_print_pick cb_print_pick
dw_pickdetail dw_pickdetail
cb_pic_locs cb_pic_locs
cb_delete_pick cb_delete_pick
cb_insert_pick cb_insert_pick
cb_generate_pick cb_generate_pick
dw_picking dw_picking
end type

on tabpage_picking.create
this.dw_pick_print=create dw_pick_print
this.cb_print_pick=create cb_print_pick
this.dw_pickdetail=create dw_pickdetail
this.cb_pic_locs=create cb_pic_locs
this.cb_delete_pick=create cb_delete_pick
this.cb_insert_pick=create cb_insert_pick
this.cb_generate_pick=create cb_generate_pick
this.dw_picking=create dw_picking
this.Control[]={this.dw_pick_print,&
this.cb_print_pick,&
this.dw_pickdetail,&
this.cb_pic_locs,&
this.cb_delete_pick,&
this.cb_insert_pick,&
this.cb_generate_pick,&
this.dw_picking}
end on

on tabpage_picking.destroy
destroy(this.dw_pick_print)
destroy(this.cb_print_pick)
destroy(this.dw_pickdetail)
destroy(this.cb_pic_locs)
destroy(this.cb_delete_pick)
destroy(this.cb_insert_pick)
destroy(this.cb_generate_pick)
destroy(this.dw_picking)
end on

type dw_pick_print from datawindow within tabpage_picking
boolean visible = false
integer x = 2592
integer y = 820
integer width = 704
integer height = 460
integer taborder = 30
string title = "none"
string dataobject = "d_workorder_picking_prt"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_print_pick from commandbutton within tabpage_picking
integer x = 1362
integer y = 16
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
iw_window.TriggerEvent('ue_print_pick')
end event

type dw_pickdetail from u_dw_ancestor within tabpage_picking
boolean visible = false
integer x = 27
integer y = 832
integer width = 3259
integer height = 720
integer taborder = 20
string dataobject = "d_work_order_pick_detail"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrievestart;call super::retrievestart;return 2
end event

type cb_pic_locs from commandbutton within tabpage_picking
integer x = 2025
integer y = 16
integer width = 402
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pic &Locs..."
end type

event clicked;
str_parms	lstrparms
Long	llRow

llRow = idw_pick.GetRow()

If llRow <= 0 Then REturn

// 05/00 Pconkl -  pop putway recommendation window

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = idw_main.GetItemString(1, "wh_code")
lstrparms.String_arg[3] = idw_pick.getItemString(llRow,"sku")
lstrparms.String_arg[4] = idw_pick.getItemString(llRow,"supp_code")
lstrparms.String_arg[5] = idw_pick.GetITemString(llRow,"l_code") /*if currently has location, recommendation will default to this*/
lstrparms.Decimal_arg[1] = idw_pick.getItemNumber(llRow,"quantity")
lstrparms.Long_arg[1] = idw_pick.getItemNumber(llRow,"owner_id") /* 08/02 - Pconkl/Tony */

OpenWithparm(w_pick_recommend,lstrparms)

idw_pick.TriggerEvent("ue_process_pick")

end event

type cb_delete_pick from commandbutton within tabpage_picking
integer x = 485
integer y = 16
integer width = 402
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;idw_pick.TriggerEvent('ue_delete')
end event

type cb_insert_pick from commandbutton within tabpage_picking
integer x = 50
integer y = 16
integer width = 402
integer height = 92
integer taborder = 30
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

type cb_generate_pick from commandbutton within tabpage_picking
integer x = 923
integer y = 16
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;// 08/08 - PCONKL - Moved picking functionality to Websphere
//iw_window.TriggerEvent('ue_generate_Pick')
iw_window.TriggerEvent('ue_generate_Pick_Server')
end event

type dw_picking from u_dw_ancestor within tabpage_picking
event ue_set_column ( )
event ue_process_pick ( )
integer y = 116
integer width = 3995
integer height = 1540
integer taborder = 20
string dataobject = "d_workorder_picking"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_set_column;
This.SetColumn(isColumn)
end event

event ue_process_pick();
// 05/00 Pconkl - process Picking requests from recommendation window

Str_parms	lstrparms
Long			llFindRow,	&
				llArrayPos,	&
				llNewRow,	&
				llCompnumber,	&
				llowner,			&
				llCurrentPickRow,	&
				llLineItemNo, &
				llRowID,			&
				llCurrentRow
				
String		lsFind, lsCont, lsSku,	lsSupplier,	lsLoc, lsSerial,	&
				lsLot, lsPO, lsPO2, lsWork, lsCompInd,	lsCOO,		&
				lsOwner,	lsInvType,	lsOwnerCode, lsOwnerType

lstrparms = Message.PowerobjectParm

llCurrentRow = This.GetRow()


// 2002/08/12 Tony add row id to return to correct row
llRowID = This.GetRowIDFromRow(llCurrentRow)

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
				
		This.SetItem(llCurrentRow,"l_code",lsLoc)
		This.SetItem(llCurrentRow,"serial_no",lsSerial)
		This.SetItem(llCurrentRow,"lot_no",lsLot)
		This.SetItem(llCurrentRow,"po_no",lsPO)
		This.SetItem(llCurrentRow,"po_no2",lsPO2)
		This.SetItem(llCurrentRow,"inventory_type",lsinvType)
		This.SetItem(llCurrentRow,"Country_Of_Origin",lsCOO) /* 02/03 - PCONKL */
		This.SetItem(llCurrentRow,"container_ID",lsCont) /* 11/02 - PCONKL */
		This.SetItem(llCurrentRow,"quantity",lstrparms.Decimal_arg[1])
		//This.SetItem(llCurrentRow,"component_no",lstrparms.Integer_arg[1])
		This.SetItem(llCurrentRow,"expiration_date",lstrparms.dateTime_arg[1])
		
		/* 09/03 - PCONKL */
		llowner = lstrparms.Long_arg[1]
		This.SetItem(llCurrentRow,"owner_id",llowner) 
		Select Owner_cd, Owner_Type 
		Into	:lsOwnerCode, :lsOwnerType
		From Owner
		Where Project_id = :gs_Project and owner_id = :llOwner;
		This.SetItem(llCurrentRow,'cf_owner_name',lsOwnerCode + '(' + lsOwnerType + ')')
		
		This.SetFocus()
		
	Case 0 /*nothing entered*/
		
		This.SetFocus()
		
	Case Else /*more than 1 row*/
		
		This.SetReDraw(False)
		
		//If more than 1 row, we will delete existing row for SKU and re-create
		lsSku = This.GetItemString(llCurrentRow,"sku") /*current row we're processing*/
		lsSupplier = This.GetItemString(llCurrentRow,"supp_code") 
		lsCompInd = This.GetItemString(llCurrentRow,"component_ind")
		lsOwner = This.GetItemString(llCurrentRow,"cf_owner_name")
		lsInvType = This.GetItemString(llCurrentRow,"inventory_Type")
		lsCoo = This.GetItemString(llCurrentRow,"country_of_origin")
		llOwner = This.GetItemNumber(llCurrentRow,"owner_id")
		llLineITemNo = This.GetItemNumber(llCurrentRow,"Line_Item_No") /* 05/02 - PCONKL*/
		
		//Delete all the lines for this SKU/Line Item 
		lsFind = "Upper(Sku) = '" + Upper(lsSKU) + "' and line_item_no = " + String(llLineItemNo)
		llFindRow = This.Find(lsFind,1,This.RowCount())
		Do While llFindRow > 0 
			This.DeleteRow(llFindRow)
			llFindRow = This.Find(lsFind,1,This.RowCount())
		Loop
			
		
		//Rebuild from array
		For llArrayPos = 1 to Upperbound(lstrparms.String_arg)
			
			llnewRow = This.InsertRow(0)
			
			//String Arg contains Location, Serial # and Lot number seperated by pipe (changed from comma to pipe - 09/04 - PCONKL)
			lsWork = lstrparms.String_arg[llArrayPos]
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
		
			This.setitem(llnewRow,'wo_no', idw_main.GetItemString(1, "wo_no"))
			This.SetItem(llNewRow,"sku",lssku)
			This.SetItem(llNewRow,"sku_parent",lssku)
			This.SetItem(llNewRow,"supp_code",lssupplier)
			//This.SetItem(llNewRow,"owner_id",llOwner)
			
			/* 09/03 - PCONKL */
			llowner = lstrparms.Long_arg[llArrayPos]
			This.SetItem(llNewRow,"owner_id",llowner)
					
			Select Owner_cd, Owner_Type 
			Into	:lsOwnerCode, :lsOwnerType
			From Owner
			Where Project_id = :gs_Project and owner_id = :llOwner;
			This.SetItem(llNewRow,'cf_owner_name',lsOwnerCode + '(' + lsOwnerType + ')')
			
			This.SetItem(llNewRow,"Line_Item_No",llLineItemNo) /*05/02 - PCONKL */
			This.SetItem(llNewRow,"component_ind",lsCompInd)
			This.SetItem(llNewRow,"cf_owner_name",lsowner)
			This.SetItem(llNewRow,"country_of_origin",lsCoo)
			//This.SetItem(llNewRow,"component_no",llCompnumber)
			This.SetItem(llNewRow,"l_code",lsloc)
			This.SetItem(llNewRow,"serial_no",lsserial)
			This.SetItem(llNewRow,"lot_no",lslot)
			This.SetItem(llNewRow,"po_no",lspo)
			This.SetItem(llNewRow,"po_no2",lspo2)
			This.SetItem(llNewRow,"container_ID",lsCont) /* 11/02 - PCONKL */
			This.SetItem(llNewRow,"quantity",lstrparms.Decimal_arg[llArrayPos])
		//	This.SetItem(llNewRow,"component_no",lstrparms.Integer_arg[llArrayPos])
			This.SetItem(llNewRow,"inventory_type", lsInvType)
			This.SetItem(llNewRow,"expiration_date",lstrparms.DateTime_arg[llArrayPos]) /* 11/02 - PCONKL */
			//for assigning item master data
			i_nwarehouse.of_item_master(gs_project,lssku,lsSupplier,idw_pick,llNewRow)	
			// 10/00 PCONKL - If this row is a componet, build child pick rows
			If lsCompInd = 'Y' Then
				i_nwarehouse.of_create_comp_child(llNewRow,idw_main,idw_pick, iw_window)
			End If /*Component parent Row*/

		Next
		
		This.Sort()
		This.GroupCalc()
		This.SetFocus()
		
// 2002/08/12 Tony add row id to return to correct row
llRowID = This.GetRowIDFromRow(llNewRow)
		
End Choose

ib_changed = True
This.AcceptText()


This.SetRedraw(True)

// 2002/08/12 Tony add row id to return to correct row

llFindRow = This.GetRowFromRowID(llRowID)
This.SetRow(llFindRow)
This.ScrollToRow(llFindRow)

end event

event itemchanged;call super::itemchanged;Str_Parms	lStrparms
string ls_supp_code,ls_alternate_sku,lscoo,ls_sku,ls_uom, lsWarehouse
Long ll_row,ll_owner_id,llCount, llRowPos
String	lsDDSQL
DatawindowChild	ldwc
long llLine_Item_No, llfind
string lsFind, lsParentSku

ib_changed = True

Choose Case Upper(dwo.name)
	
	case 'SKU'
		
		//Check if item_master has the records for entered sku	
		llCount = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case llCount
			Case 1 /*only 1 supplier, Load*/
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				ls_sku = data
				ls_supp_code = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")
				goto pick_data
			Case is > 1 /*Supplier dropdown populated for current sku when focus received*/
				This.object.supp_code[row]=""
			Case Else			
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				return 1
		END Choose
		

		
	Case 'SUPP_CODE'
		
		 ls_sku = this.Getitemstring(row,"sku")
		 ls_supp_code = data
	 	goto pick_data
		 
	Case 'DELIVER_TO_LOCATION'
		
		//If first row, ask to apply to whole order
		If row = 1  and this.RowCOunt() > 1 Then
			If messagebox(is_title,'Would you like to apply this location to the entire Order?',Question!,YesNo!,1) = 1 Then
				FOr llRowPos = 1 to This.RowCount()
					This.SetITem(llROwPos,'deliver_to_location',data)
				Next
			End If
		End If
		
		Return
		
	Case 'L_CODE' /*Validate Location*/
		
		lsWarehouse = idw_main.GetITEmString(1,'wh_code')
		Select Count(*) Into :llCount
		FRom Location
		Where wh_code = :lsWareHouse and l_code = :data;
		
		If llCount <= 0 Then
			Messagebox(is_Title,'Invalid Location!')
			Return 1
		End If
		
	Case 'QUANTITY'
		
		//If a component qty is changed, we need to adjust the children making up the component to compensate
		//We will default to pick required components from FG inventory, the user may decide to make up the sub components instead
		
		If This.GetITemString(row,'component_ind') = 'Y' Then
			
			wf_realloc_comp(row,This.GetITemNUmber(row,'quantity'),dec(data)) /* data = new qty */
			
		End If /*component*/
		
	Case "COUNTRY_OF_ORIGIN" 
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		lsCOO = f_get_Country_Name(data)
		If isNull(lsCOO) or lsCOO = '' Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
		
//	Case 'LINE_ITEM_NO'
//		
//		IF gs_project = "RIVERBED" then
//			
//			llLine_Item_No =this.GetITemNumber(row,'Line_Item_No')
//			lsFind = "line_item_no = " + string(llLine_Item_No)
//			 llfind = w_workorder.idw_detail.Find(lsFind,1,w_workorder.idw_detail.RowCount())
//			 
//			if llfind > 0 then
//				lsParentSku = w_workorder.idw_detail.GetItemString(llfind, "sku")
//				this.setItem(row, "SKU_Parent", lsParentSku)
//			end if	
//		
//		
//		end if
//		
//		
//		Return		
	
			
END Choose			

return

pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	
	ll_row =i_nwarehouse.ids.Getrow()
	
	ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id") 
	//Set the values from datastore ids which is item master  
	this.object.owner_id[row] = ll_owner_id
	This.SetITem(row,'Component_ind',i_nwarehouse.ids.GetItemString(ll_row,"component_ind"))
	This.SetITem(row,'Country_Of_origin',i_nwarehouse.ids.GetItemString(ll_row,"Country_of_Origin_Default"))
	This.SetITem(row,'serialized_ind',i_nwarehouse.ids.GetItemString(ll_row,"serialized_ind"))
	This.SetITem(row,'lot_controlled_ind',i_nwarehouse.ids.GetItemString(ll_row,"lot_controlled_ind"))
	This.SetITem(row,'po_controlled_ind',i_nwarehouse.ids.GetItemString(ll_row,"po_controlled_ind"))
	This.SetITem(row,'po_no2_controlled_ind',i_nwarehouse.ids.GetItemString(ll_row,"po_no2_controlled_ind"))
	This.SetITem(row,'expiration_controlled_ind',i_nwarehouse.ids.GetItemString(ll_row,"expiration_controlled_ind"))
	This.SetITem(row,'container_tracking_ind',i_nwarehouse.ids.GetItemString(ll_row,"container_Tracking_ind"))
	This.SetITem(row,'sku_parent',ls_sku)
	
	IF gs_project = "RIVERBED" then
	 	 
		// As Per BoonHee, there will only be 1 row in detail for Work Orderl

		if w_workorder.idw_detail.RowCount() > 0 then
			lsParentSku = w_workorder.idw_detail.GetItemString(1, "sku")
			this.setItem(row, "SKU_Parent", lsParentSku)
		end if	
		
	end if
	
	
	
	
	//Get the owner name
	this.object.cf_owner_name[ row ] = g.of_get_owner_name(ll_owner_id)
			
	isColumn = "quantity"
	This.PostEvent("ue_set_column")
	
ELSE
	
	MessageBox(is_title, "Invalid Supplier, please re-enter!")
	return 1
	
END IF


end event

event itemfocuschanged;call super::itemfocuschanged;DatawindowChild	ldwc

tab_main.tabpage_picking.cb_pic_locs.Enabled = FALse

//If clicked on Supplier, populate for proper SKU/Supplier
Choose Case Upper(dwo.Name)
	Case "SUPP_CODE"
		idwc_supplier_Pick.Retrieve(gs_project,This.GetITemString(row,'sku'))
	Case "L_CODE"
		If idw_main.GetITemString(1,'ord_status') <> 'C' and idw_main.GetITemString(1,'ord_status') <> 'V' Then
			tab_main.tabpage_picking.cb_pic_locs.Enabled = True
		End If
	Case "DELIVER_TO_LOCATION"  /*Retrived by Warehouse/Loc type of 'A' */
		This.GetChild('DELIVER_TO_LOCATION',ldwc)
		ldwc.SetTransObject(SQLCA)
		ldwc.Retrieve(idw_main.GetITemString(1,'wh_code'))
		If ldwc.RowCount() <=0 Then ldwc.InsertRow(0)
End Choose
end event

event ue_insert;call super::ue_insert;Long ll_row
Integer	liMsg
String	lsMsg
DatawindowChild	ldwc

idw_pick.SetFocus()

If idw_pick.AcceptText() = -1 Then Return

idwc_supplier_Pick.InsertRow(0)

This.GetChild('DELIVER_TO_LOCATION',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.InsertRow(0)

ll_row = idw_Pick.GetRow() 

If ll_row > 0 Then
	idw_pick.setcolumn('line_item_no')
	ll_row = idw_pick.InsertRow(ll_row + 1)
	idw_pick.ScrollToRow(ll_row)
	idw_pick.setitem(ll_row,'wo_no',idw_Main.GetItemString(1,"wo_no"))
Else
	ll_row = idw_pick.InsertRow(0)
	idw_pick.setitem(ll_row,'wo_no',idw_Main.GetItemString(1,"wo_no"))	
End If	

end event

event itemerror;call super::itemerror;Return 2
end event

event ue_delete;call super::ue_delete;
Long	llRow

llRow = This.GetRow()
If llRow > 0 Then
	
	//If it is a component, reallocate the children to compensate
	If This.GetITemString(llrow,'component_ind') = 'Y' Then
			wf_realloc_comp(llrow,This.GetITemNUmber(llrow,'quantity'),0) 
		End If /*component*/
		
	This.DeleteRow(llRow)
	
End If

ib_Changed = True
end event

event constructor;call super::constructor;
IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
	this.object.cf_owner_name_t.visible = 0
End IF

If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If
end event

event doubleclicked;call super::doubleclicked;
str_parms	lStrparms
string ls_serialised_ind,	&
		lsFind
Long		llOwnerHold,	&
			llFindRow,		&
			llRowCount,		&
			llRowPos
			
If Row > 0 Then
	
	Choose Case dwo.name
			
//		case 'serial_no' 
//			
//	 		ls_serialised_ind = this.object.serialized_ind[ row ]
//			IF upper(ls_serialised_ind) = 'Y'  and &
//	  		 Upper(idw_main.object.ord_status[1])	<> 'C' THEN 
//				i_nwarehouse.of_do_serial_nos(idw_pick,ilcurrpickrow)
//			END IF	
			
		Case "cf_owner_name"
			
			
			Open(w_select_owner)
			lstrparms = Message.PowerObjectParm
			If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
				
				//07/02 - Pconkl - If checked, update all detail rows, otherwise just current
				If lstrparms.String_Arg[4] = 'Y' Then /*update all record*/
					llRowCount = This.RowCount()
					For llRowPOs = 1 to llRowCount
						This.SetItem(llrowpos,"owner_id",Lstrparms.Long_arg[1])
						This.SetITem(llRowPos,"cf_owner_name",Lstrparms.String_arg[1])
					Next
					
					//Update all order details as well
					llRowCount = idw_detail.RowCount()
					For llRowPos = 1 to llRowCount
						idw_detail.SetItem(llRowPos,"owner_id",Lstrparms.Long_arg[1])
						idw_detail.SetITem(llRowPos,"cf_owner_name",Lstrparms.String_arg[1])
					Next
					
				Else /*only update current */
					
					llOwnerHold = This.GetITemNumber(row,'owner_id')
					This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
					This.SetITem(row,"cf_owner_name",Lstrparms.String_arg[1])
				
					//Owner Change needs to be reflected on Order Detail as well
					lsFind = "sku = '" + This.GetItemString(row,"sku") + "' and owner_id = " + String(llOwnerHold) 
					lsFind += " and Line_Item_No = " + string(This.GetITemNumber(row,'line_item_no'))
					llFindRow = idw_detail.Find(lsFind,1,idw_detail.RowCount())
					Do While llFindRow > 0
						idw_detail.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
						idw_detail.SetITem(llFindrow,"cf_owner_name",Lstrparms.String_arg[1])
						llFindRow = idw_detail.Find(lsFind,(llFindRow + 1),(idw_detail.RowCount() + 1))
					Loop
					
//					//If a component, copy Owner to dependent records
//					If This.GetItemString(row,"component_ind") = 'Y' Then
//						lsFind = "sku_parent = '" + This.GetItemString(row,"sku_parent") + "' and component_no = " + String(this.GetItemNumber(row,"component_no"))
//						llFindRow = This.Find(lsFind,1,This.RowCount())
//						Do While llFindRow > 0
//							This.SetItem(llFindRow,"owner_id",Lstrparms.Long_arg[1])
//							This.SetITem(llFindrow,"cf_owner_name",Lstrparms.String_arg[1])
//							llFindRow = This.Find(lsFind,(llFindRow + 1),(This.RowCount() + 1))
//						Loop
//					End If /*Component*/
				
				End If /*all or current row*/
								
				ib_changed = True
								
			End If /*owner selection not cancelled*/
						
			
			This.SetRedraw(True)
			
	End Choose
	
END IF


end event

event retrieveend;call super::retrieveend;Integer i
long ll_owner
IF rowcount > 0  and Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to rowcount
		ll_owner=This.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.cf_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		ENd IF	
	Next
END IF	
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

type tabpage_cto_process from userobject within tab_main
event ue_generate ( )
event ue_selectall ( )
event ue_unselectall ( )
event ue_print ( )
boolean visible = false
integer x = 18
integer y = 112
integer width = 4027
integer height = 1680
long backcolor = 79741120
string text = "CTO Process"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_2 st_2
mle_remarks mle_remarks
cb_3 cb_3
cb_selectall cb_selectall
st_message st_message
cb_generate cb_generate
dw_serial dw_serial
cb_print cb_print
end type

event ue_generate();Long	llRowPos, llRowCount, llFindRow, llPickPos, llPickCount, llUPC, llNewRow, llID, llLineItemNo, liIdx
String	lsFind,lsDONO,  lsSku, lsSupplier, lsDesc
//Long	ll_method_trace_id


If ib_changed Then
	messagebox(is_title,'Please save changes before generating Serial # list!')
	return
End If

If  dw_serial.RowCount() > 0 then
	if messagebox(is_title,'There are serial rows. Do you want to continue and delete them?', Exclamation!, YesNo!) = 1 Then
		for liIdx = dw_serial.RowCount()  to 1 step -1
			dw_serial.DeleteRow(liIdx)
		next
		dw_serial.Update()
	else
		return
	End If 
End If

//// cawikholm 07/05/11 Added call to track user 
//SetNull( ll_method_trace_id )
//f_method_trace( ll_method_trace_id, this.ClassName(), 'Start ue_generate Serial: ' + is_dono )

//10/07 - If validating carton serial relationship, make sure packing list has been generated first
// 11/09 - PCONKL - We are allowing Serial numbers to be scanned first. Instead of throwing an error, just force carton number to be scanned first.


//MAFIX - If g.ibCartonSerialvalidationRequired and idw_Pack.RowCount() = 0 Then
//	
////	messagebox(is_title,'Pack List must be generated before generating Serial # list!')
////	return
//
//	sle_barcodes.Enabled = False
//	
//MAFIX - End If

isCurrentSKU = ''

// need to show component children to check for serial #'s - may be filtered to not show
//MAFIX - wf_set_pick_filter('Remove')

//For Each Pick Row, retrieve any required outbound Serials

SetPointer(Hourglass!)

dw_serial.SetRedraw(false)

//dw_serial.Reset()


// 03/04 - PCONKL - Only need to retreive once by DONO instead of looping for each row
lsDoNO = idw_main.GetItemString(1,'do_no')
//dw_serial.Retrieve(lsDoNo, gs_Project)

For llRowPos = 1 to idw_pick.RowCount()
	
	If idw_pick.GetItemString(llRowPos,'serialized_ind') = 'O' or  idw_pick.GetItemString(llRowPos,'serialized_ind') = 'B' or g.ibScanAllOrdersRequired Then /* 02/09 - PCONKL - added Type B */
				
		ilRetrieveRow = llRowPos
//TAM 2010/05/26 Saving the Parent quantity if an Item is actually a parent and not every record.  The comment row below already existed but was not used anywhere.
		If idw_pick.GetItemString(llRowPos,'sku') = idw_pick.GetItemString(llRowPos,'sku_parent') then
			ilParentQty = idw_pick.GetItemNumber(llRowPos,"quantity")
		End If		
//		ilParentQty = idw_pick.GetItemNumber(llRowPos,"quantity")
		dw_serial.TriggerEvent("ue_retrieve") /*retrievestart = 2 to not clear after each retrieve*/
		
	End If
		
Next




// 02/01 PCONKL - Re Filter Pick list to not show components if box is not checked
//MAFIX - wf_set_pick_filter('Set')

//We only want to show items that need serializing or component masters
//dw_serial.SetFilter("component_ind = 'Y' or isnull(serial_no) or serial_no <> '-'")
//dw_Serial.Filter()

//Sort and regroup
dw_serial.Sort()
dw_serial.GroupCalc()

dw_serial.SetRedraw(True)
SetPointer(Arrow!)
			
If dw_serial.RowCount() = 0 Then
	messageBox(is_title, 'No rows are generated.')
Else
	ib_changed = true
End IF

isCurrentPackCartonId = ""

If g.ibCartonSerialvalidationRequired Then
	st_message.text = 'Scan Carton Number'
Else
	st_message.text = 'Scan Carton Number or SKU'
End If

//MAFIX 
//If g.ibCartonSerialvalidationRequired and idw_Pack.RowCount() = 0 Then
//	sle_carton_no.SetFocus() 
//End If
//MAFIX - End 



//cb_generate.Enabled = False /* 12/09 - PCONKL - Disabled retrieve above - we dont want to be able to regenerated until a save has occurred*/

//MAFIX - f_method_trace( ll_method_trace_id, this.ClassName(), 'End ue_generate Serial' )
end event

event ue_selectall();
Long	llRowPos,	&
		llRowCount
		
		
dw_serial.SetRedraw(False)

llRowCount = dw_serial.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount

	 
		dw_serial.SetITem(llRowPos,'c_print_ind','Y')
	 
	Next
	
End If

dw_serial.SetRedraw(True)

cb_print.Enabled = True
end event

event ue_unselectall();Long	llRowPos,	&
		llRowCount
		
		
dw_serial.SetRedraw(False)

llRowCount = dw_serial.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount
	
	 
		dw_serial.SetITem(llRowPos,'c_print_ind','N')

	Next
	
End If

dw_serial.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_print();
long llRowCount
Str_Parms	lstrparms
string lsPrintText, lsformat, lsLabel, lsCurrentLabel, lsLabelPrint, lsTemp, lsLineItemNo,ls_compexp
Long llPrintJob, llRowPos, llPrintCount, llFind,ll_pcikrowcount,ll_pickrow,ll_compnum=0

n_labels	lu_labels

lu_labels = Create n_labels

dw_serial.AcceptText()

llRowCount = dw_serial.RowCount()


OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
			
lsPrintText = 'Riverbed Travel Label '

//Open Printer File 
llPrintJob = PrintOpen(lsPrintText)

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return
End If


For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_serial.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
		
	lsformat = "Riverbed_Traveler_Zebra.txt"

	lsLabel = lu_labels.uf_read_label_Format(lsFormat)
	
	If lsLabel = "" Then Return

	lsCurrentLabel= lsLabel


	lsTemp = idw_main.GetItemString(1,'workorder_number')
	
	If lsTemp > ' '  Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~wo_no~~", lsTemp) 
	End If
	
	lsTemp = dw_serial.GetItemString(llRowPos,'sku')
	
	If lsTemp > ' '  Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~sku~~", lsTemp) 
	End If

	
	lsTemp = dw_serial.GetItemString(llRowPos,'sku')
	
	//serialized_ind
	
	lsLineItemNo = String(dw_serial.GetItemNumber(llRowPos,'line_item_no'))
	
//	llFind = idw_Pick.Find( "serialized_ind='N' and line_item_no=" + lsLineItemNo, 1, idw_Pick.RowCount())
		
//	If llFind > 0 then
//		lsTemp = idw_Pick.GetItemString(llFind,'sku')
//	else
//		lsTemp = ""
//	End If
	
//	If lsTemp > ' '  Then
//		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~components~~", lsTemp) 
//	End If
//	
	
	ll_pcikrowcount = idw_Pick.rowcount()

//SARUN201327OCT sTART : To print 	COMPONENTS on label
	for ll_pickrow = 1 to ll_pcikrowcount
			if idw_Pick.GetItemString(ll_pickrow,'serialized_ind') = 'N' then
				lsTemp = idw_Pick.GetItemString(ll_pickrow,'sku')
				If lsTemp > ' '  Then
					ll_compnum++
					ls_compexp = "~~components" + string(ll_compnum) + "~~" 
					lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, ls_compexp, lsTemp) 
				End If
		
			end if
		
	next
	//SARUN201327OCT End : To print 	COMPONENTS on label

	
	lsTemp = mle_remarks.text
	
	If lsTemp > ' '  Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~upgrade_kits~~", lsTemp) 
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~upgrade_kits~~", '') 
	End If
	
	lsTemp = dw_serial.GetItemString(llRowPos,'serial_no')
	
	If lsTemp > ' '  Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~sw_serial_number~~", lsTemp) 
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~sw_serial_number~~", '') 
	End If
	
	lsTemp = dw_serial.GetItemString(llRowPos,'mac_id')
	
	If lsTemp > ' '  Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~hw_serial_number~~", lsTemp) 
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "~~hw_serial_number~~", '') 
	End If

	
//	integer liPos	
//		
//	llPrintCount = dw_serial.GetITemNUmber(llRowPos,'no_of_copies')	
//		
//	liPos = Pos(lsCurrentLabel, "^PQ", 1)
//	
//	if liPos > 0 then
//		
//		lsCurrentLabel = left(lsCurrentLabel,(liPos + 2)) + string(llPrintCount) + mid(lsCurrentLabel,(liPos + 4))
//		
//	end if	
		
	
	lsLabelPrint = lsCurrentLabel

	PrintSend(llPrintJob, lsLabelPrint)	
			
Next /*detail row to Print*/

//End If


PrintClose(llPrintJob)


		







end event

on tabpage_cto_process.create
this.st_2=create st_2
this.mle_remarks=create mle_remarks
this.cb_3=create cb_3
this.cb_selectall=create cb_selectall
this.st_message=create st_message
this.cb_generate=create cb_generate
this.dw_serial=create dw_serial
this.cb_print=create cb_print
this.Control[]={this.st_2,&
this.mle_remarks,&
this.cb_3,&
this.cb_selectall,&
this.st_message,&
this.cb_generate,&
this.dw_serial,&
this.cb_print}
end on

on tabpage_cto_process.destroy
destroy(this.st_2)
destroy(this.mle_remarks)
destroy(this.cb_3)
destroy(this.cb_selectall)
destroy(this.st_message)
destroy(this.cb_generate)
destroy(this.dw_serial)
destroy(this.cb_print)
end on

type st_2 from statictext within tabpage_cto_process
integer x = 87
integer y = 1440
integer width = 306
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Remarks:"
boolean focusrectangle = false
end type

type mle_remarks from multilineedit within tabpage_cto_process
integer x = 407
integer y = 1436
integer width = 3589
integer height = 228
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within tabpage_cto_process
integer x = 366
integer y = 28
integer width = 338
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

type cb_selectall from commandbutton within tabpage_cto_process
event ue_selectall ( )
integer x = 9
integer y = 28
integer width = 338
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event ue_selectall();Long	llRowPos,	&
		llRowCount
		
		
dw_serial.SetRedraw(False)

llRowCount = dw_serial.RowCount()

If llRowCount > 0 Then

	For llRowPos = 1 to llRowCount

	 
		dw_serial.SetITem(llRowPos,'c_print_ind','Y')
	 
	Next
	
End If

dw_serial.SetRedraw(True)

cb_print.Enabled = True

end event

event clicked;Parent.Event ue_selectall()

end event

type st_message from statictext within tabpage_cto_process
integer x = 1609
integer y = 476
integer width = 2912
integer height = 76
boolean bringtotop = true
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

type cb_generate from commandbutton within tabpage_cto_process
integer x = 1504
integer y = 28
integer width = 343
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

event clicked;
Parent.TriggerEvent("ue_generate")


end event

type dw_serial from u_dw_ancestor within tabpage_cto_process
event ue_load_item_values ( long alserialrow,  long alpickrow )
integer x = 9
integer y = 148
integer width = 3986
integer height = 1244
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_workorder_outbound_serial"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_load_item_values(long alserialrow, long alpickrow);
String		lsSku,lsDoNo,lsSupplier, lsDesc,	lsSkuParent, lsCompInd
Long			llID, llMaxSeq,llCompNo, llLineItemNo
String      ls_uf4


lsDoNo = idw_pick.GetITemString(alPickRow,"do_no")
lsSku = idw_pick.GetITemString(alPickRow,"sku")
lsSkuParent = idw_pick.GetITemString(alPickRow,"sku_Parent")
lsCompInd = idw_pick.GetITemString(alPickRow,"Component_Ind")
lsSupplier = idw_pick.GetITemString(alPickRow,"supp_code")
llCompNo = idw_pick.GetITemNumber(alPickRow,"Component_no")
llLineItemNo = idw_pick.GetITemNumber(alPickRow,"line_item_no") /* 10/03 - PCONKL*/

//Get the Item Description
Select Description,user_field4 Into :lsDesc,:ls_uf4
From Item_Master
Where project_id = :gs_project and sku = :lsSku and supp_code = :lsSUpplier;


//Get the ID from Picking Detail
Select Min(id_no) into :llID
from Delivery_Picking_Detail
Where do_no = :lsdoNo and sku = :lsSKU and supp_code = :lsSupplier and Line_Item_no = :llLineItemNo;
	
dw_serial.SetItem(alSerialRow,'id_no',llID)
dw_serial.SetITem(alSerialRow,'sku',lsSKU)
dw_serial.SetITem(alSerialRow,'supp_code',lsSUpplier)
dw_serial.SetITem(alSerialRow,'sku_parent',lsSKUPArent)
dw_serial.SetITem(alSerialRow,'component_ind',lsCompInd)
dw_serial.SetITem(alSerialRow,'component_no',llCompNo)
dw_serial.SetITem(alSerialRow,'description',lsDesc)
dw_serial.SetITem(alSerialRow,'item_master_user_field4',ls_uf4)
dw_serial.SetITem(alSerialRow,'sku_substitute',lsSKU) //TAM 2010/04
dw_serial.SetITem(alSerialRow,'supplier_substitute',lsSUpplier)  //TAM 2010/04

dw_serial.SetITem(alSerialRow,'quantity',1)


llMaxSeq ++
If llMaxSeq = 0 Then llMaxSeq = 1
			
//Non components should sort at the end
If dw_serial.GetItemString(alSerialRow,'component_ind') = 'Y' Or dw_serial.GetItemString(alSerialRow,'component_ind') = '*' Or dw_serial.GetItemString(alSerialRow,'component_ind') = 'B' Then
	dw_serial.SetITem(alSerialRow,'component_sequence_no',llmaxSeq)
Else
	dw_serial.SetITem(alSerialRow,'component_sequence_no',999)
End If
		

dw_serial.SetColumn('carton_no')







end event

event constructor;call super::constructor;

If Not g.ibCartonSerialvalidationRequired Then /* 10/07 - PCONKL - using project indicator instead of hardcoding*/
	This.Modify("carton_no.visible=0")
End If




This.Modify("part_upc_Code.visible=0")


 // 2011/10/13 TAM added riverbed
If gs_project = 'RIVERBED' Then
	This.Modify("mac_id_t.text = 'Hardware Serial'")
	This.Modify("serial_no_t.text = 'Software Serial'")
 // 2011/12/03 TAM added sku substitue
	This.Modify("sku_substitute_t.text = 'Parent Serial'")
//	This.Modify("sku_substitute.protect = 0")
//	This.SetTabOrder("sku_substitute",70)
End If



This.Modify("quantity.visible=0")

This.SetRowFocusIndicator(Hand!)
end event

event itemchanged;call super::itemchanged;
ib_changed = True
ibSerialModified = True
end event

event itemerror;call super::itemerror;
Return 2

end event

event retrievestart;
//Multiple retrieves to fill DW
Return 2
end event

event ue_retrieve;//MEA - Enabled for Riverbed.
//Code copied.

String		lsSku,lsWoNo,lsSupplier,lsCOO, lsLoc,lsInvType,lsLot, lsPO,lsPO2,lsSerialized,lsDash, &
				lsDesc, lsFind, lsContainer, lsGrp,lsBOM_UF3,  ls_child_sku, ls_parent_sku, ls_shippable_flag
Long			llOwner, llPickCOunt, llPickPos, llCount,llID, llNewRow,i, llMaxSeq,llFindRow, llCompNo, llLineItemNo
Decimal		ldMod, ldPickQty, ldParentQty,ldUnitQty, ldUPC, ldQty
String      ls_uf4, lsNativeDescription
DateTime		ldtExpDt


//Picking detail records are being retrievd into datastore
//For each picking detail, we are retrieving the picking serial #'s. THis will allow us to create
// blank rows as needed so we have rows of 1 qty to fill all qty for picking detail row

// 03/04 - PCONKL - ALL Serial #'s are being retrieved at once - no need to loop through each pick detail record.
//							All we need to do is add empty rows as needed when the user clicks 'generate'

If not isvalid(ids_pick_detail) Then
	ids_pick_detail = Create DataStore
	ids_pick_detail.dataobject = 'd_workorder_serial_no_hidden'
	ids_pick_detail.SetTransObject(SQLCA)
End If

// will loop through each Pick record  and here we will return all pick details for that pick record.
lsWoNo = idw_pick.GetITemString(ilretrieverow,"wo_nO")
lsSku = idw_pick.GetITemString(ilretrieverow,"sku")
lsSerialized = idw_pick.GetITemString(ilretrieverow,"serialized_ind")
lsSupplier = idw_pick.GetITemString(ilretrieverow,"supp_code")
llOwner = idw_pick.GetITemNumber(ilretrieverow,"owner_id")
ldQty = idw_pick.GetITemNumber(ilretrieverow,"Quantity")
llCompNo = idw_pick.GetITemNumber(ilretrieverow,"Component_no")
llLineItemNo = idw_pick.GetITemNumber(ilretrieverow,"line_item_no") /* 10/03 - PCONKL*/
lsCOO = idw_pick.GetITemString(ilretrieverow,"Country_of_origin")
lsloc = idw_pick.GetITemString(ilretrieverow,"l_code")
lsInvType = idw_pick.GetITemString(ilretrieverow,"inventory_type")
lsLot = idw_pick.GetITemString(ilretrieverow,"lot_no")
lsPO = idw_pick.GetITemString(ilretrieverow,"po_no")
lsPO2 = idw_pick.GetITemString(ilretrieverow,"po_no2")
lsContainer = idw_pick.GetITemString(ilretrieverow,"Container_ID") /* 12/04 - PCONKL*/
ldtExpDT = idw_pick.GetITemDateTime(ilretrieverow,"Expiration_date")  /* 12/04 - PCONKL*/


//02/10 - PCONKL - If we are scanning all items, we only need one row per line/SKU - WE mya have multiple pick records for same line/sku - dont need multiples here
If g.ibScanAllOrdersRequired and lsSerialized = 'N' Then
	If dw_serial.Find("Line_Item_No = " + string(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) + "'",1,dw_serial.RowCount()) > 0 Then
		Return
	End If
End If

//llPickQty = idw_pick.GetITemNumber(ilretrieverow,"quantity")

//Get the Item Description
Select Description,user_field4, part_upc_Code, grp, Native_Description Into :lsDesc,:ls_uf4, :ldUPC, :lsGrp, :lsNativeDescription
From Item_Master
Where project_id = :gs_project and sku = :lsSku and supp_code = :lsSUpplier;

llPickCount = ids_pick_detail.Retrieve(lsWoNo,lssku,lssupplier,llOwner,lscoo,lsloc,lsInvTYpe,lsLot,lsPO,lsPO2,llCompNo,llLineItemNo, lsContainer, ldtExpDt) /* 12/04 - PCONKL - added Container ID and Expiration DT */

if llPickCount = 0 then
	
	llCompNo = 0
	
	llPickCount = ids_pick_detail.Retrieve(lsWoNo,lssku,lssupplier,llOwner,lscoo,lsloc,lsInvTYpe,lsLot,lsPO,lsPO2,llCompNo,llLineItemNo, lsContainer, ldtExpDt) /* 12/04 - PCONKL - added Container ID and Expiration DT */

	
end if

For llPickPos = 1 to llPickCount
	
	llID = ids_pick_detail.GetItemNumber(llPickPos,'id_no')
	
	// 10/08 - PCONKL - For Comcast, we only need 1 serial row per picking row since they are only scanning 1 pallet/carton per picked row
	// 05/09 - PCONKL - For LMC, start with 1 row per Pick List. We will add as necessary but we are ending up with thousands of extra rows to delete
	// 11/09 - If we are scanning all orders (Pack Val), we just want one row per SKU ifit is not a serialized part
	If gs_project = 'COMCAST' or gs_project = 'LMC' or (g.ibScanAllOrdersRequired and (lsSerialized = 'N' or lsSerialized = 'Y'))  then
		ldPickQty = 1
	else
		ldPickQty = ids_pick_detail.GetItemNumber(llPickPos,'quantity')
	End If
	
	//dw_serial.Retrieve(llId,gs_project) /*retievestart=2*/
	
	//	//add blank rows where needed
	// 03/04 - PCONKL - We will only add blank rows if we are 'generating', not just retreiving existing records
		
		select count(*)  into :llCount 
		From Delivery_serial_detail
		Where id_no = :llID;

		//Find THe Max for this sku
		llMaxSeq = 0
		
		//lsFind = "sku = '" + ids_pick_detail.GetItemString(llPickPos,'sku') + "' and supp_code = '" + ids_pick_detail.GetItemString(llPickPos,'supp_code') + "'"
		lsFind = "sku_parent = '" + ids_pick_detail.GetItemString(llPickPos,'sku_parent') + "' and sku = '" + ids_pick_detail.GetItemString(llPickPos,'sku') + "' and supp_code = '" + ids_pick_detail.GetItemString(llPickPos,'supp_code') + "'"
		llFindRow = dw_serial.Find(lsFind,1,dw_serial.RowCount())
		
		Do While llFindRow > 0
			If dw_serial.GetItemNumber(llFindRow,'component_sequence_no') > llMaxSeq Then
				llMaxSeq = dw_serial.GetItemNumber(llFindRow,'component_sequence_no')
			End If
			llFindRow ++
			If llFindRow > dw_serial.RowCount() Then Exit
			llFindRow = dw_serial.Find(lsFind,llFindRow,(dw_serial.RowCount() + 1))
		Loop

		if gs_project = 'RIVERBED' Then //TAM 2011/12/03 If Riverbed then we need to look in the delivery bom table for the shippable flag =  N (User_field 3) to turn the field for input
			ls_child_sku = ids_pick_detail.GetItemString(llPickPos,'sku')
			ls_parent_sku = ids_pick_detail.GetItemString(llPickPos,'sku_parent')
			Select User_field3 Into :lsBOM_UF3
			From Delivery_BOM
			Where Project_id = :gs_project and sku_parent = :ls_parent_sku and sku_child = :ls_child_sku and wo_no = :lsWoNo
			Using SQLCA;
			If POS(Trim(lsBOM_UF3), "IsShippable:N") > 0 Then
				ls_shippable_flag = 'N'
			Else
				ls_shippable_flag = 'Y'
			End If
		End If
				

		If llCount < ldPickQty Then // AND   NOT  (gs_project = 'WARNER' AND lsGrp = 'PO' ) Then
			
			For I = 1 to (Long(ldPickQty) - llCount)
				
				llNewRow = dw_serial.InsertRow(0)
				dw_serial.SetItem(llNewRow,'id_no',llID)
				dw_serial.SetITem(llNewRow,'sku',ids_pick_detail.GetItemString(llPickPos,'sku'))
				dw_serial.SetITem(llNewRow,'supp_code',ids_pick_detail.GetItemString(llPickPos,'supp_code'))
				dw_serial.SetITem(llNewRow,'sku_parent',ids_pick_detail.GetItemString(llPickPos,'sku_parent'))
				dw_serial.SetITem(llNewRow,'component_ind',ids_pick_detail.GetItemString(llPickPos,'component_ind'))
				dw_serial.SetITem(llNewRow,'component_no',ids_pick_detail.GetItemNumber(llPickPos,'component_no'))
				dw_serial.SetITem(llNewRow,'line_Item_No',ids_pick_detail.GetItemNumber(llPickPos,'line_Item_No')) /* 03/05 - PCONKL*/
				If ls_shippable_flag = 'Y' then //TAM 2011/12 Populate for riverbed
					dw_serial.SetITem(llNewRow,'shippable_flag','Y')
				Else
					dw_serial.SetITem(llNewRow,'shippable_flag','N')
				End If

				if gs_project <> 'RIVERBED' Then //TAM 2011/12/03 Don't do for Riverbed
					dw_serial.SetITem(llNewRow,'sku_substitute',ids_pick_detail.GetItemString(llPickPos,'sku')) //TAM 2010/04
				end if
				dw_serial.SetITem(llNewRow,'supplier_substitute',ids_pick_detail.GetItemString(llPickPos,'supp_code'))  //TAM 2010/04
				
				// 01/11 - PCONKL - For Comcast, if we are doing a WH transfer from a Corp Warehouse to an SIK warehouse, set the Serial # to the Lot # from Picking
				// 03/11 - PCONKL - Also if a virtual Shipment from warehouse 'COM-DIRECT'
				if gs_project = 'COMCAST' Then
					
					If (idw_Main.GetITemSTring(1,'Ord_Type') = 'Z' and Left(idw_Main.GetItemString(1,'Cust_Code'),7) = 'COM-SIK') or idw_Main.GetITEmString(1,'wh_code') = 'COM-DIRECT'  Then
					
						dw_serial.SetITem(llNewRow,'serial_no',lsLot)
						dw_serial.SetITem(llNewRow,'quantity',ldQty)
						
					End If
										
				End If /*Comcast*/
				
				//If we have a non swerialized part and we are scanning all items, ge the expeced qty from dd.alloc_qty since we wont be processing all the pick detail records (this logic will only be hit once per line/sku
				If g.ibScanAllOrdersRequired and lsSerialized = 'N' Then
					
					llFindRow = idw_detail.Find("line_item_no = " + String(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) + "'",1,idw_detail.RowCount())
					If llFindRow > 0 Then
						dw_serial.SetITem(llNewRow,'expected_qty',idw_Detail.GetItemNumber(llFindRow,'alloc_Qty'))
					Else
						dw_serial.SetITem(llNewRow,'expected_qty',ids_pick_detail.GetItemNumber(llPickPos,'quantity'))
					End If
				Else
					dw_serial.SetITem(llNewRow,'expected_qty',ids_pick_detail.GetItemNumber(llPickPos,'quantity'))
				End If
				
				dw_serial.SetITem(llNewRow,'description',lsDesc)
				dw_serial.SetITem(llNewRow,'native_description',lsNativeDescription)
				dw_serial.SetITem(llNewRow,'part_upc_code',ldUPC)
				dw_serial.SetITem(llNewRow,'item_master_user_field4',ls_uf4)
				dw_serial.SetITem(llNewRow,'serialized_ind',lsSerialized)
				
//				If gs_project <> 'LMC' Then /*LMC will be scanning Qty, don't default */
				If dw_serial.GetITemNumber(llNewRow,'Quantity') > 0 Then
				Else
					dw_serial.SetITem(llNewRow,'quantity',0)
				End If
//				End If
					
				//If not serialized for this item, default to '-' which will gray/protect
				If lsSerialized <> 'O' and lsSerialized <> 'B' Then /* 02/09 - PCONKL - Added B */
					//lsDash += '-' /*dummy value to avaoid dups but not require serial no where not required*/
					dw_serial.SetITem(llNewRow,'serial_no','-')
				End If
			
				//If it's not a child, always bump the Seq up, otherwise only bump up if we've included all the children for a single parent qty (there can be more than 1 of a child for a single parent*/
			
				// 03/03 - PCONKL - This is causing problems if the parent is split across multiple pick records (diff Lot, etc.).
				// We will assume that there is only 1 of a child per parent. If not, they will need to be entered in the same row.
			
				llMaxSeq ++
			
				If llMaxSeq = 0 Then llMaxSeq = 1
				If llMaxSeq > 9999999 Then llMaxSeq = 1 /* 05/04 - PCONKL - ensure it doesn't wrap*/
			
				//Non components should sort at the end
				// 10/04 - PCONKL - If component_no = 0 (built in WO or blown out in DO) then no need to sort by component seq - set them all to 999
				If (dw_serial.GetItemString(llNewRow,'component_ind') = 'Y' Or dw_serial.GetItemString(llNewRow,'component_ind') = '*' Or dw_serial.GetItemString(llNewRow,'component_ind') = 'B') and llCompNo > 0 Then

//TAM 2010/05/26 - BOMs are not sorted correctly if there is a child BOM quantity > 1.  The Parent sequence numbers wil be 1 to (parent quantity).  
//           In order to keep the Child Skus with their Parents we need to calculate the associated parent sequence number.  Divide Max Sequence by the Parent quantity and add 1 to the remainer
					If gs_project = 'PANDORA' and llmaxSeq>ilparentqty and ilparentqty > 0 then
						dw_serial.SetITem(llNewRow,'component_sequence_no',mod(llmaxSeq, ilparentqty) + 1)
					Else
						dw_serial.SetITem(llNewRow,'component_sequence_no',llmaxSeq)
					End If
				Else
					dw_serial.SetITem(llNewRow,'component_sequence_no',999)
				End If
				
			Next /*Next Pick Qty*/
		
		End If /* Blank rows needed */
	
Next /*Next Pick Detail*/


dw_serial.SetFocus()
dw_serial.SetRow(1)
dw_serial.ScrollToRow(1)
dw_serial.SetColumn('serial_no')








end event

event process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

event ue_insert;call super::ue_insert;
Long	llNewRow

llNewRow = This.InsertRow(0)
This.SetFocus()
This.SetRow(llNewROw)
This.ScrollToRow(llNewRow)
This.SetColumn('Line_Item_No')
end event

event ue_delete;call super::ue_delete;
This.DEleteRow(This.GetRow())
ib_changed = True
ibSerialModified = True
end event

type cb_print from commandbutton within tabpage_cto_process
integer x = 882
integer y = 28
integer width = 402
integer height = 92
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
Parent.Event ue_print()
end event

type tabpage_putaway from userobject within tab_main
integer x = 18
integer y = 112
integer width = 4027
integer height = 1680
long backcolor = 79741120
string text = "FG Putaway"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_component_parent dw_component_parent
cb_scanunits cb_scanunits
cb_2 cb_2
cb_confirm_putaway cb_confirm_putaway
dw_putaway_content dw_putaway_content
dw_putaway_print dw_putaway_print
cb_print_putaway cb_print_putaway
cb_putaway_locs cb_putaway_locs
cb_delete_putaway cb_delete_putaway
cb_insert_putaway cb_insert_putaway
cb_generate_putaway cb_generate_putaway
dw_putaway dw_putaway
end type

on tabpage_putaway.create
this.dw_component_parent=create dw_component_parent
this.cb_scanunits=create cb_scanunits
this.cb_2=create cb_2
this.cb_confirm_putaway=create cb_confirm_putaway
this.dw_putaway_content=create dw_putaway_content
this.dw_putaway_print=create dw_putaway_print
this.cb_print_putaway=create cb_print_putaway
this.cb_putaway_locs=create cb_putaway_locs
this.cb_delete_putaway=create cb_delete_putaway
this.cb_insert_putaway=create cb_insert_putaway
this.cb_generate_putaway=create cb_generate_putaway
this.dw_putaway=create dw_putaway
this.Control[]={this.dw_component_parent,&
this.cb_scanunits,&
this.cb_2,&
this.cb_confirm_putaway,&
this.dw_putaway_content,&
this.dw_putaway_print,&
this.cb_print_putaway,&
this.cb_putaway_locs,&
this.cb_delete_putaway,&
this.cb_insert_putaway,&
this.cb_generate_putaway,&
this.dw_putaway}
end on

on tabpage_putaway.destroy
destroy(this.dw_component_parent)
destroy(this.cb_scanunits)
destroy(this.cb_2)
destroy(this.cb_confirm_putaway)
destroy(this.dw_putaway_content)
destroy(this.dw_putaway_print)
destroy(this.cb_print_putaway)
destroy(this.cb_putaway_locs)
destroy(this.cb_delete_putaway)
destroy(this.cb_insert_putaway)
destroy(this.cb_generate_putaway)
destroy(this.dw_putaway)
end on

type dw_component_parent from u_dw_ancestor within tabpage_putaway
boolean visible = false
integer x = 2304
integer y = 468
integer height = 364
integer taborder = 30
string dataobject = "d_item_component_parent"
end type

type cb_scanunits from commandbutton within tabpage_putaway
integer x = 2889
integer y = 16
integer width = 352
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Scan Units"
end type

event clicked;str_parms	lstrparms
lstrparms.Datawindow_arg[1] = tab_main.tabpage_detail.dw_detail
lstrparms.Datawindow_arg[2] = tab_main.tabpage_picking.dw_picking
lstrparms.Datawindow_arg[3] = tab_main.tabpage_putaway.dw_putaway
lstrparms.String_arg[1] = tab_main.tabpage_main.dw_main.GetItemString(1,"ord_status" )

OpenSheetWithParm(w_comcast_sik_kit_label, lStrparms, w_main, gi_menu_pos, Original!)

end event

type cb_2 from commandbutton within tabpage_putaway
integer x = 2066
integer y = 16
integer width = 352
integer height = 92
integer taborder = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copy Row"
end type

event clicked;//Jxlim 01/05/2011 added copy row button
idw_Putaway.TriggerEvent("ue_Copy")

end event

event constructor;//Jxlim 01/05/2011
g.of_check_label_button(this)
end event

type cb_confirm_putaway from commandbutton within tabpage_putaway
integer x = 23
integer y = 16
integer width = 539
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Confirm Putaway"
end type

event clicked;
wf_putaway_content()
end event

type dw_putaway_content from u_dw_ancestor within tabpage_putaway
boolean visible = false
integer x = 2999
integer y = 468
integer height = 364
integer taborder = 20
string dataobject = "d_ro_content"
end type

type dw_putaway_print from datawindow within tabpage_putaway
boolean visible = false
integer x = 2290
integer y = 572
integer width = 718
integer height = 432
integer taborder = 30
string title = "none"
string dataobject = "d_putaway_prt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_print_putaway from commandbutton within tabpage_putaway
integer x = 1723
integer y = 16
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
iw_window.TriggerEvent('ue_print_putaway')
end event

type cb_putaway_locs from commandbutton within tabpage_putaway
integer x = 2409
integer y = 16
integer width = 471
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Putaway &Locs..."
end type

event clicked;
str_parms	lstrparms
Long	llRow

llRow = idw_Putaway.GetRow()
If llRow <=0 Then Return

lstrparms.String_arg[1] = gs_project
lstrparms.String_arg[2] = idw_main.GetItemString(1, "wh_code")
lstrparms.String_arg[3] = idw_putaway.getItemString(llRow,"sku")
lstrparms.String_arg[4] = idw_putaway.GetITemString(llRow,"l_code") /*if currently has location, recommendation will default to this*/
lstrparms.String_arg[5] = idw_putaway.GetITemString(llRow,"wo_no") /*we will still show as available for this order*/
lstrparms.String_arg[6] = idw_putaway.GetITemString(llRow,"inventory_type") //BCR 21-DEC-2011: Issue raised by Jeff
lstrparms.Decimal_arg[1] = idw_putaway.getItemNumber(llRow,"quantity")
lstrparms.Decimal_arg[2] = idw_putaway.getItemNumber(llRow,"owner_id") //BCR 21-DEC-2011: Issue raised by Jeff
OpenWithparm(w_putaway_recommend,lstrparms)

idw_putaway.TriggerEvent("ue_process_putaway")

end event

type cb_delete_putaway from commandbutton within tabpage_putaway
integer x = 983
integer y = 16
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete Row"
end type

event clicked;
idw_putaway.TriggerEvent('ue_Delete')
end event

type cb_insert_putaway from commandbutton within tabpage_putaway
integer x = 617
integer y = 16
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert Row"
end type

event clicked;
idw_putaway.TriggerEvent('ue_insert')
end event

type cb_generate_putaway from commandbutton within tabpage_putaway
integer x = 1353
integer y = 16
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;//TAM 10/13/2010 Added NYCSP specific putaway logic

If idw_main.GetITemString(1,'Ord_Type') = 'D' Then 
	iw_window.TriggerEvent('ue_generate_Putaway_Kit_Change_Delete')
Else
	If idw_main.GetITemString(1,'Ord_Type') = 'A' Then 
		iw_window.TriggerEvent('ue_generate_Putaway_Kit_Change_add')
	Else
		If gs_project = 'NYCSP' Then
			iw_window.TriggerEvent('ue_generate_Putaway_NYCSP')
		Else	
			iw_window.TriggerEvent('ue_generate_Putaway')
		End If
	End If
End If

long llrowcount, i, ll_sub_line_item_no

llrowcount = idw_Putaway.RowCount()

//0819 - MikeA - DE11261 -  Confirm Putaway Causing Error

// We may have added rows to this datawindow.  Update sub_line_item_no to 1 if null
For i = 1 to llrowcount
	
	ll_sub_line_item_no = idw_Putaway.GetItemNumber( i, 'sub_line_item_no' )
	
	IF IsNull( ll_sub_line_item_no ) THEN
		
		idw_Putaway.SetItem( i,'sub_line_item_no',1 )
		
	END IF
	
Next
end event

type dw_putaway from u_dw_ancestor within tabpage_putaway
event ue_set_column ( )
event ue_process_putaway ( )
event ue_check_enable ( )
event ue_doubleclicked ( )
integer y = 116
integer width = 3991
integer height = 1564
integer taborder = 20
string dataobject = "d_workorder_putaway"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_set_column;
This.SetColumn(isColumn)
end event

event ue_process_putaway();Str_parms	lstrparms
Long			llFindRow,	&
				llArrayPos,	&
				llNewRow,	&
				llOwnerID,	&
				llLineItem,	&
				llCurrRow,	&
				llSubLine
				
String		lsFind,	&
				lsSku,	&
				lsSupplier,	&
				lsLoc,	&
				lsCOO,	&
				lsOwner,	&
				lsInvType

This.SetRedraw(False)

llCurrRow = This.GetRow()

//Parms returned rows of string for location and long for amt to putaway there!
lstrparms = Message.PowerobjectParm

Choose Case Upperbound(lstrparms.String_arg)
		
	Case 1 /* putting everything away in 1 location*/
		
		This.SetItem(llCurrRow,"l_code",lstrparms.String_arg[1])
		This.SetItem(llCurrRow,"quantity",lstrparms.decimal_arg[1])
		
		This.SetFocus()
		This.SetRow(llCurrRow)
				
	Case 0 /*nothing entered*/
		
		This.SetFocus()
		This.SetRow(llCurrRow)
		
	Case Else /*more than 1 row*/
		
		//If more than 1 row, we will delete existing row for SKU and re-create
		
		lsSku = This.GetItemString(llCurrRow,"sku") /*current row we're processing*/
		lsSupplier = This.GetItemString(llCurrRow,"supp_code") /*current row we're processing*/
		lscoo = This.GetItemString(llCurrRow,"country_of_origin")
		lsowner = This.GetItemString(llCurrRow,"cf_owner_name")
		lsInvType = This.GetItemString(llCurrRow,"inventory_Type")
		llownerid = This.GetItemNumber(llCurrRow,"owner_id")
//		llCompnumber = This.GetItemNumber(llCurrRow,"component_no")
		llLineItem = This.GetItemNumber(llCurrRow,"line_item_no")
		
		//Delete all rows for this sku/supplier/line item  09/00 pconkl - delete child component rows as well (sku_parent)
		llFindrow = 1
		lsFind = "Upper(sku_parent) = '" + Upper(This.GetItemString(llCurrRow,"sku"))  + "' and line_item_no = " + String(This.GetItemNumber(llCurrRow,"line_item_no"))
			
		Do While llFindRow > 0
			llFindRow = This.Find(lsFind,0,This.RowCount())
			If llFindRow > 0 Then
				This.DeleteRow(llFindRow)
			End If
		Loop
		
		//Rebuild from array
		For llArrayPos = 1 to Upperbound(lstrparms.String_arg)
			
			llnewRow = This.InsertRow(0)
			This.setitem(llnewRow,'wo_no', idw_main.GetItemString(1, "wo_no"))
			This.SetItem(llNewRow,"sku_parent",lsSku)
			This.SetItem(llNewRow,"sku",lsSku)
			This.SetItem(llNewRow,"supp_code",lsSupplier)
			This.SetItem(llNewRow,"owner_id",llOwnerID)
//			This.SetItem(llNewRow,"component_no",llcompnumber)
			This.SetItem(llNewRow,"line_item_no",llLineItem) /*08/01 PConkl*/
			
			// 07/04 - PCONKL - Set Unique Line number
			llSubLine = This.RowCount() + 1
			//If Subline Already Exists, bump until not
			llFindRow = This.Find("sub_line_item_no = " + String(llSubLine),1,This.RowCount())
			Do While llFindRow > 0
				llSubLine ++
				llFindRow = This.Find("sub_line_item_no = " + String(llSubLine),1,This.RowCount())
			Loop
			
			This.SetItem(llNewRow,"sub_line_item_no",llSubLine) 
			
			This.SetItem(llNewRow,"country_of_origin",lsCOO)
			This.SetItem(llNewRow,"cf_owner_name",lsowner)
			This.SetItem(llNewRow,"l_code",lstrparms.String_arg[llArrayPos])
			This.SetItem(llNewRow,"quantity",lstrparms.decimal_arg[llArrayPos])
			This.SetItem(llNewRow,"inventory_type", lsInvType)
			IF i_nwarehouse.of_item_master(gs_project,lsSku,lsSupplier,idw_putaway,llNewRow) < 1 THEN
	//			 Messagebox("","Could not retrieve item master values")
			END IF				
			
//			If THis.GetITemString(llNewRow,'component_ind') = 'Y' Then
//				//Build Child Records
//				wf_create_comp_child(llNewRow)
//			//	llCompNumber ++ 
//			End If
			
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

event ue_check_enable;
//If no rows have the confirm putaway ind checked, disable the button

If This.Find('c_confirm_putaway_ind = "Y"',1,This.RowCount()) = 0 Then
	Parent.cb_confirm_putaway.Enabled = False
End If
end event

event itemchanged;call super::itemchanged;Str_Parms	lStrparms
string ls_supp_code,ls_alternate_sku,lscoo,ls_sku,ls_uom, lsWarehouse, lsGroup
Long ll_row,ll_owner_id,llCount, llRowPos, ll_component_no, ll_line_item_no
String	lsDDSQL
DatawindowChild	ldwc

//MEA
//If Upper(dwo.Name) <> 'C_CONFIRM_PUTAWAY_IND' Then
//	ib_changed = True
//End If

Choose Case Upper(dwo.name)

	case 'SKU'
		
		//Check if item_master has the records for entered sku	
		llCount = i_nwarehouse.of_item_sku(gs_project,data)
		Choose Case llCount
			Case 1 /*only 1 supplier, Load*/
				This.SetItem(row,"supp_code",i_nwarehouse.ids_sku.GetItemString(1,"supp_code"))
				ls_sku = data
				ls_supp_code = i_nwarehouse.ids_sku.GetItemString(1,"supp_code")

				// TAM 10/07/2010  For NYCSP we need to calculate the container ID
				If gs_project = 'NYCSP' Then
					// If Tracking by Container ID, set to Next
					If This.GetItemString(row,'container_tracking_Ind') = 'Y' Then
						This.SetITem(row,'container_id',uf_get_next_container_ID('')) /* 04/01 - PCONKL - moved to function to support project specific requirements*/
					End If /*Container Tracked */
				End If

				goto pick_data
			Case is > 1 /*Supplier dropdown populated for current sku when focus received*/
				This.object.supp_code[row]=""
			Case Else			
				MessageBox(is_title, "Invalid SKU, please re-enter!",StopSign!)
				return 1
		END Choose
		
	Case 'SUPP_CODE'
		
		 ls_sku = this.Getitemstring(row,"sku")
		 ls_supp_code = data
	 	goto pick_data
			
	Case 'L_CODE' /*Validate Location*/
		
		lsWarehouse = idw_main.GetITEmString(1,'wh_code')
		Select Count(*) Into :llCount
		FRom Location
		Where wh_code = :lsWareHouse and l_code = :data;
		
		If llCount <= 0 Then
			Messagebox(is_Title,'Invalid Location!')
			Return 1
		End If
	
	//TAM 2010/09 Set L_Code Same as Parent	
		ll_component_no = this.GetitemNumber(row,"component_no")
		ll_line_item_no = this.GetitemNumber(row,"line_item_no")

		For ll_row = 1 to this.RowCount()
			If this.GetItemNumber(ll_Row,'component_no') = ll_component_no and this.GetItemstring(ll_Row,'component_ind') = '*' Then
//				This.SetITem(ll_row,'l_code',data)
				this.object.l_code[ ll_row ] = data
			End If
		Next
		
	isColumn = "l_code"
	This.PostEvent("ue_set_column")

	Case "COUNTRY_OF_ORIGIN" 
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		lsCOO = f_get_Country_Name(data)
		If isNull(lsCOO) or lsCOO = '' Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
		
	Case 'C_CONFIRM_PUTAWAY_IND' /*if checked, enable button, if unchecked, see if any other rows are checked, otherwise disable*/
	
		If data = 'Y' Then
			parent.cb_confirm_putaway.Enabled = True
		Else
			This.PostEvent('ue_check_enable')
		End If

//TAM 2010/09 Set Component's  Confirm_Ind to Same as Parent	
		ll_component_no = this.GetitemNumber(row,"component_no")
		ll_line_item_no = this.GetitemNumber(row,"line_item_no")

		For ll_row = 1 to this.RowCount()
			If this.GetItemNumber(ll_Row,'component_no') = ll_component_no and this.GetItemstring(ll_Row,'component_ind') = '*' Then
//				This.SetITem(ll_row,'Component_ind',data)
				this.object.c_confirm_putaway_ind[ ll_row ] = data
			End If
		Next
		
	isColumn = "c_confirm_putaway_ind"
	This.PostEvent("ue_set_column")

////TAM 2010/09 Set Lot number to Same as Parent	
//Case 'LOT_NO' 
//		ll_component_no = this.GetitemNumber(row,"component_no")
//		ll_line_item_no = this.GetitemNumber(row,"line_item_no")
//
//		For ll_row = 1 to this.RowCount()
//			If this.GetItemNumber(ll_Row,'component_no') = ll_component_no and this.GetItemstring(ll_Row,'component_ind') = '*' Then
////				This.SetITem(ll_row,'lot_no',data)
//				this.object.lot_no[ ll_row ] = data
//			End If
//		Next
//		
//	isColumn = "lot_no"
//	This.PostEvent("ue_set_column")

//TAM 2010/09 Set Container to Same as Parent	
Case 'CONTAINER_ID' 
		ll_component_no = this.GetitemNumber(row,"component_no")
		ll_line_item_no = this.GetitemNumber(row,"line_item_no")

		For ll_row = 1 to this.RowCount()
			If this.GetItemNumber(ll_Row,'component_no') = ll_component_no and this.GetItemstring(ll_Row,'component_ind') = '*' Then
//				This.SetITem(ll_row,'container_id',data)
				this.object.container_id[ ll_row ] = data
			End If
		Next
		
	isColumn = "container_id"
	This.PostEvent("ue_set_column")

		
//TAM 2010/09 Set Inventory Type Same as Parent	
Case 'INVENTORY_TYPE' 
		ll_component_no = this.GetitemNumber(row,"component_no")
		ll_line_item_no = this.GetitemNumber(row,"line_item_no")

		For ll_row = 1 to this.RowCount()
			If this.GetItemNumber(ll_Row,'component_no') = ll_component_no and this.GetItemstring(ll_Row,'component_ind') = '*' Then
				this.object.inventory_type[ ll_row ] = data
			End If
		Next
		
	isColumn = "inventory_type"
	This.PostEvent("ue_set_column")
				
END Choose			

return

pick_data:
IF i_nwarehouse.of_item_master(gs_project,ls_sku,ls_supp_code) > 0 THEN
	
	ll_row =i_nwarehouse.ids.Getrow()
	
	ll_owner_id=i_nwarehouse.ids.GetItemnumber(ll_row,"owner_id") 
	//Set the values from datastore ids which is item master  
	this.object.owner_id[row] = ll_owner_id
	This.SetITem(row,'Component_ind',i_nwarehouse.ids.GetItemString(ll_row,"component_ind"))
	This.SetITem(row,'country_of_origin',i_nwarehouse.ids.GetItemString(ll_row,"country_of_origin_default"))
	This.SetITem(row,'sku_parent',ls_sku)
	//Get the owner name
	this.object.cf_owner_name[ row ] = g.of_get_owner_name(ll_owner_id)
			
	isColumn = "l_code"
	This.PostEvent("ue_set_column")
	
ELSE
	
	MessageBox(is_title, "Invalid Supplier, please re-enter!")
	return 1
	
END IF


end event

event constructor;call super::constructor;
IF Upper(g.is_owner_ind) <> 'Y' THEN
	this.object.cf_owner_name.visible = 0
	this.object.cf_owner_name_t.visible = 0
End IF

If g.is_coo_ind  <> 'Y' Then
	this.Modify("country_of_origin.visible=0")
End If

// 08/04 - PCONKL - UF1 being used as putaway type for LOGITECH, hide for all others
If Upper(gs_project) <> 'LOGITECH' Then
	This.Modify("user_field1.width=0")
End IF
end event

event retrieveend;call super::retrieveend;Integer i
long ll_owner
IF rowcount > 0  and Upper(g.is_owner_ind) = 'Y' THEN
	For i = 1 to rowcount
		ll_owner=This.GetItemNumber(i,"owner_id")
		IF not isnull(ll_owner) or ll_owner <> 0 THEN
			This.object.cf_owner_name[ i ] = g.of_get_owner_name(ll_owner)
		End IF	
	Next
END IF	
end event

event itemfocuschanged;call super::itemfocuschanged;
tab_main.tabpage_putaway.cb_putaway_locs.Enabled = FALse

//If clicked on Supplier, populate for proper SKU/Supplier
Choose Case Upper(dwo.Name)
	Case "SUPP_CODE"
		idwc_supplier_Putaway.Retrieve(gs_project,This.GetITemString(row,'sku'))
	Case "L_CODE"
		If idw_main.GetITemString(1,'ord_status') <> 'C' and idw_main.GetITemString(1,'ord_status') <> 'V' Then
			tab_main.tabpage_putaway.cb_putaway_locs.Enabled = True
		End If
End Choose
end event

event itemerror;call super::itemerror;Return 2
end event

event ue_delete;call super::ue_delete;
Long	llRow, ll_component_row,ll_component_no, ll_line_item_no
Int		li_Result
String lsPallet, lsPickedPallet, lsSKU, lsPickedSKU, lsSuppCode, lsPickedSuppCode

llRow = This.GetRow()
If llRow > 0 Then
	//Can only delete it if it hasn't been confirmed to Inventory (user field 2 has the confirm date)
	If This.GetITemstring(llrow,'user_Field2') = '' or isnull(This.GetITemstring(llrow,'user_Field2')) Then

		//TAM 2010/09 if they delete the parent then delete the kids		
		ll_component_no = this.GetitemNumber(llrow,"component_no")
		ll_line_item_no = this.GetitemNumber(llrow,"line_item_no")

		For ll_component_row = this.RowCount() to 1 Step -1
			If this.GetItemNumber(ll_component_row,'component_no') = ll_component_no and this.GetItemstring(ll_component_row,'component_ind') = '*' Then
				This.DeleteRow(ll_component_row)
			End If
		Next

		//GXMOR 2012/05 If Comcast Kitted, return carton/serial pallet to original pallet and change SKU/supp_code
		lsPallet = This.GetItemString(llRow,"lot_no")
		If (Left(lsPallet,6) = 'MLO-FG') Then
			li_Result = uf_Revert_Pallet(lsPallet)
		End If
		
		//Disable for testing
		This.DeleteRow(llRow)
		
	End If
End If

ib_Changed = True
end event

event ue_insert;call super::ue_insert;Long ll_row, llSubLine, llFindRow
Integer	liMsg

String	lsMsg

This.SetFocus()

If This.AcceptText() = -1 Then Return

ll_row = This.GetRow() 

If ll_row > 0 Then
//	This.setcolumn('line_item_no')
	ll_row = This.InsertRow(ll_row + 1)
//	This.ScrollToRow(ll_row)
Else
	ll_row = This.InsertRow(0)
	
End If	

This.setitem(ll_row,'wo_no',idw_Main.GetItemString(1,"wo_no"))	
//This.setitem(ll_row,'line_item_no',(This.RowCount() + 1))

// 07/04 - PCONKL - Set Unique Line number
llSubLine = ll_row
//If Subline Already Exists, bump until not
llFindRow = This.Find("sub_line_item_no = " + String(llSubLine),1,This.RowCount())
Do While llFindRow > 0
	llSubLine ++
	llFindRow = This.Find("sub_line_item_no = " + String(llSubLine),1,This.RowCount())
Loop
		
This.SetItem(ll_row,"sub_line_item_no",llSubLine) 

This.ScrollToRow(ll_row)
This.setcolumn('line_item_no')
end event

event doubleclicked;call super::doubleclicked;//Jxlim 01/05/2011 Clone from w_ro
// 09/08 - PCONKL If one of the lottable fields is double clicked, we will enable a scan mode which will allow the users to scan down a column instead of across when enter is clicked

str_parms	lstrparms
String	lsFind, lsSKU, ls_WH_Code
Long	llFindRow,llOwnerHold,llRowPos,lLRowCount, i, ll_sub_line_item_no

If Row > 0 Then

	Choose Case dwo.Name

		case "serial_no"
			/* 02/09 - PCONKL - Serialized type of 'B' is capture at IB/OB but not writing to Content */
			IF (this.getitemstring(row,'serialized_ind') = 'Y' or this.getitemstring(row,'serialized_ind') = 'B') and & 
				 Upper(idw_main.object.ord_status[1])	<> 'C' THEN
				 	This.SetRedraw(False)				
					i_nwarehouse.of_wo_serial_nos(idw_putaway,row)
					ib_changed = True
					This.SetRedraw(True)
					This.SetFocus()
					
					llrowcount = this.RowCount()
					
					// We may have added rows to this datawindow.  Update sub_line_item_no to 1 if null
					For i = 1 to llrowcount
						
						ll_sub_line_item_no = this.GetItemNumber( i, 'sub_line_item_no' )
						
						IF IsNull( ll_sub_line_item_no ) THEN
							
							this.SetItem( i,'sub_line_item_no',1 )
							
						END IF
						
					Next
					
  	 		END IF
				
	
	End Choose /*Clicked column*/	

Else
	
	/* 08/19 - MikeA - DE11261 - Added to allow doubleclick to select all putaway items. */		

	Choose Case dwo.Name
			
	case "t_confirm_putaway_ind"		
		
		llrowcount = this.RowCount()
		
		For i = 1 to llrowcount
			if IsNull(this.GetItemString( i,'user_field2')) then
				this.SetItem( i,'c_confirm_putaway_ind','Y' )
			end if
		Next	
		
		if llrowcount > 0 then
			parent.cb_confirm_putaway.Enabled = True
		end if 

	End Choose
End If /*Valid Row*/
end event

event ue_copy;call super::ue_copy;//Jxlim 01/05/2011 ue_copy clone from w_ro
Long ll_row,	&
		llNewRow,	&
		llnextContainer,	&
		llFindRow,			&
		i
	
Long	llSubLine	
	
String	lsSku,	&
			lsSupplier,	&
			lsNextContainer, &
			lsGroup

Str_Parms	lStrParms

idw_putaway.SetFocus()

If idw_putaway.AcceptText() = -1 Then Return -1

ll_row = idw_putaway.GetRow() /* 08/00 PCONKL */

If ll_row > 0 Then
	////Jxlim 01/06/2011 This logic is not apply for workorder
//	//Dont allow Copy of Component Rows
//	If idw_putaway.GetItemString(ll_row,"component_ind") = '*' or & 
//		idw_putaway.GetItemString(ll_row,"component_ind") = 'Y' or &
//		idw_putaway.GetItemString(ll_row,"component_ind") = 'B' Then
//			Messagebox(is_title,"You can not copy component rows!")	
//			Return -1
//	End If
		
	// 01/03 - PCONKL - allow user to select the number of rows to add and set QTY
	lstrparms.Decimal_arg[1] = idw_putaway.GetITemNumber(ll_row,'quantity') /*Qty from original row, will be default for new rows*/
	//Jxlim 01/05/2011 w_workorder
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
		//Jxlim 01/05/2011 workorder 
		//idw_putaway.setitem(llNewrow,'ro_no',idw_Main.GetItemString(1,"ro_no"))
		idw_putaway.setitem(llNewrow,'wo_no',idw_Main.GetItemString(1,"wo_no"))
	
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
		//Jxlim 01/18/2011 If po_no is not checked from itemmaster then set the po_no = '-' to avoid getting required db error message.
		If idw_putaway.getitemstring(i,'PO_Controlled_Ind') <>  'Y' Then
			idw_putaway.SetItem(llNewRow,'po_no','-')
		Else
			idw_putaway.SetItem(llNewRow,'po_no',idw_putaway.GetITemString(ll_row,'po_no'))
		End If
		
		If idw_putaway.getitemstring(i,'po_no2_controlled_ind') <>  'Y' Then
			idw_putaway.SetItem(llNewRow,'po_no2','-')
		Else
			idw_putaway.SetItem(llNewRow,'po_no2',idw_putaway.GetITemString(ll_row,'po_no2'))
		End If
		
		//idw_putaway.SetItem(llNewRow,'container_ID',idw_putaway.GetITemString(ll_row,'container_ID')) /* 11/02 - Pconkl */
		idw_putaway.SetItem(llNewRow,'expiration_Date',idw_putaway.GetITemDateTime(ll_row,'expiration_Date'))
		idw_putaway.SetItem(llNewRow,'country_of_origin',idw_putaway.GetITemString(ll_row,'country_of_origin'))
		idw_putaway.SetItem(llNewRow,'owner_id',idw_putaway.GetITemNumber(ll_row,'Owner_id'))
		//idw_putaway.SetItem(llNewRow,'c_owner_name',idw_putaway.GetITemString(ll_row,'c_owner_name'))
		// dts - 8/31/10 - adding owner_cd to copy...
		//idw_putaway.SetItem(llNewRow, 'owner_cd', idw_putaway.GetItemString(ll_row, 'Owner_cd'))
		idw_putaway.SetItem(llNewRow,'line_item_no',idw_putaway.GetITemNumber(ll_row,'line_item_no')) /* 08/01 PCONKL */
	//	idw_putaway.SetItem(llNewRow,'user_line_item_no',idw_putaway.GetITemString(ll_row,'user_line_item_no')) /* 01/03 - PCONKL */
		//idw_putaway.SetItem(llNewRow,'length',idw_putaway.GetITemNumber(ll_row,'length')) /* 01/03 PCONKL */
		//idw_putaway.SetItem(llNewRow,'Width',idw_putaway.GetITemNumber(ll_row,'Width')) /* 01/03 PCONKL */
		//idw_putaway.SetItem(llNewRow,'Height',idw_putaway.GetITemNumber(ll_row,'height')) /* 01/03 PCONKL */
		//idw_putaway.SetItem(llNewRow,'weight_1',idw_putaway.GetITemNumber(ll_row,'weight_1')) /* 03/04 PCONKL */
	//	idw_putaway.SetItem(llNewRow,'weight_Gross',idw_putaway.GetITemNumber(ll_row,'weight_gross')) /* 01/03 PCONKL */
		//idw_putaway.SetItem(llNewRow,'GRP',idw_putaway.GetITemString(ll_row,'GRP')) /* 2009/12/21 TAM */
		//idw_putaway.SetItem(llNewRow,'description',idw_putaway.GetITemString(ll_row,'description')) // 03/04/10 KRZ

		
		idw_putaway.SetItem(llNewRow,'user_field1',idw_putaway.GetITemString(ll_row,'user_field1'))   //MEA 9/10
		idw_putaway.SetItem(llNewRow,'user_field2',idw_putaway.GetITemString(ll_row,'user_field2'))   //MEA 9/10 
		//idw_putaway.SetItem(llNewRow,'user_field3',idw_putaway.GetITemString(ll_row,'user_field3'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field4',idw_putaway.GetITemString(ll_row,'user_field4'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field5',idw_putaway.GetITemString(ll_row,'user_field5'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field6',idw_putaway.GetITemString(ll_row,'user_field6'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field7',idw_putaway.GetITemString(ll_row,'user_field7'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field8',idw_putaway.GetITemString(ll_row,'user_field8'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field9',idw_putaway.GetITemString(ll_row,'user_field9'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field10',idw_putaway.GetITemString(ll_row,'user_field10'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field11',idw_putaway.GetITemString(ll_row,'user_field11'))   //MEA 9/10 
//		idw_putaway.SetItem(llNewRow,'user_field12',idw_putaway.GetITemString(ll_row,'user_field12'))   //MEA 9/10 
				
		//idw_putaway.Setcolumn("Quantity")
		idw_Putaway.SetITem(llNewRow,'Quantity',lstrparms.Decimal_arg[1]) /* 01/03 - PConkl set qty from prompt*/
		
		//If this row is a component, process the child rows
		If idw_putaway.GetItemString(llNewRow,"component_ind") = 'Y' then
			idw_putaway.SetItem(llNewRow,'component_no',(idw_putaway.GetITemNumber(ll_row,'component_no') + 5)) /*bump up component #*/
			//jxlim 01/05/2011 commented out don't need for work order
			//wf_create_comp_child(llNewRow)
		Else
			idw_putaway.SetItem(llNewRow,'component_no',0) /* 06/01 PCONKL */
		End If
		
		// 12/02 - PConkl - If Tracking by Container ID, set to Next
		If This.GetItemString(llNewrow,'container_tracking_Ind') = 'Y' Then
			
			//TAM 2009/12/21 Added group as a Parm (Used by Pandora)
			//This.SetITem(llNewrow,'container_id',uf_get_next_container_ID()) /* 04/09 - PCONKL - moved to function to support project specific requirements*/
			lsGroup = idw_putaway.getItemstring(llnewrow, "GRP")
			//Jxlim 01/06/2011 clone function from w_ro
			//This.SetITem(llNewrow,'container_id',uf_get_next_container_ID(lsGroup)) /* 04/09 - PCONKL - moved to function to support project specific requirements*/


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

event clicked;call super::clicked;String lsName
Long llRow

If dwo.Type = "text" and dwo.Name = 'confirm_putaway_ind' Then
	
	For llRow = 1 to This.RowCount()
		This.object.c_confirm_putaway_ind[ llRow ] = "Y"
	Next
		
End If

end event

