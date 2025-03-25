$PBExportHeader$w_maintenance_itemmaster.srw
$PBExportComments$-  itemmaster modify
forward
global type w_maintenance_itemmaster from w_std_master_detail
end type
type dw_sku_supplier from datawindow within tabpage_main
end type
type cb_item_master_owner from commandbutton within tabpage_main
end type
type dw_main from u_dw_ancestor within tabpage_main
end type
type cb_item_master_search from commandbutton within tabpage_search
end type
type cb_item_master_clear from commandbutton within tabpage_search
end type
type dw_query from u_dw_ancestor within tabpage_search
end type
type dw_search from u_dw_ancestor within tabpage_search
end type
type tabpage_price from userobject within tab_main
end type
type cb_delete_cust_alt_sku from commandbutton within tabpage_price
end type
type cb_insert_cust_alt_sku from commandbutton within tabpage_price
end type
type st_customer_alternate_skus from statictext within tabpage_price
end type
type dw_cust_sku from u_dw_ancestor within tabpage_price
end type
type st_prices from statictext within tabpage_price
end type
type cb_delete_price from commandbutton within tabpage_price
end type
type cb_insert_price from commandbutton within tabpage_price
end type
type dw_price from u_dw_ancestor within tabpage_price
end type
type tabpage_price from userobject within tab_main
cb_delete_cust_alt_sku cb_delete_cust_alt_sku
cb_insert_cust_alt_sku cb_insert_cust_alt_sku
st_customer_alternate_skus st_customer_alternate_skus
dw_cust_sku dw_cust_sku
st_prices st_prices
cb_delete_price cb_delete_price
cb_insert_price cb_insert_price
dw_price dw_price
end type
type tabpage_reorder from userobject within tab_main
end type
type uo_1 from u_textbtn within tabpage_reorder
end type
type dw_storage_rule from u_dw_ancestor within tabpage_reorder
end type
type cb_replenish_delete from commandbutton within tabpage_reorder
end type
type cb_replenish_insert from commandbutton within tabpage_reorder
end type
type st_fwd_pick from statictext within tabpage_reorder
end type
type dw_replenish from u_dw_ancestor within tabpage_reorder
end type
type st_im_replen_double_click_on_owner from statictext within tabpage_reorder
end type
type st_putaway_storage_rules from statictext within tabpage_reorder
end type
type st_supplier_reorder_information from statictext within tabpage_reorder
end type
type dw_reorder_info from u_dw_ancestor within tabpage_reorder
end type
type cb_reorder_insert from commandbutton within tabpage_reorder
end type
type cb_reorder_delete from commandbutton within tabpage_reorder
end type
type tabpage_reorder from userobject within tab_main
uo_1 uo_1
dw_storage_rule dw_storage_rule
cb_replenish_delete cb_replenish_delete
cb_replenish_insert cb_replenish_insert
st_fwd_pick st_fwd_pick
dw_replenish dw_replenish
st_im_replen_double_click_on_owner st_im_replen_double_click_on_owner
st_putaway_storage_rules st_putaway_storage_rules
st_supplier_reorder_information st_supplier_reorder_information
dw_reorder_info dw_reorder_info
cb_reorder_insert cb_reorder_insert
cb_reorder_delete cb_reorder_delete
end type
type tabpage_component from userobject within tab_main
end type
type st_im_comp_dbl_click_a_row_to_maintain from statictext within tabpage_component
end type
type dw_component_parent from u_dw_ancestor within tabpage_component
end type
type st_component_parent from statictext within tabpage_component
end type
type st_item_made_up_of_following_comp from statictext within tabpage_component
end type
type dw_component_child from u_dw_ancestor within tabpage_component
end type
type cb_add_component_parent from commandbutton within tabpage_component
end type
type cb_delete_component_parent from commandbutton within tabpage_component
end type
type tabpage_component from userobject within tab_main
st_im_comp_dbl_click_a_row_to_maintain st_im_comp_dbl_click_a_row_to_maintain
dw_component_parent dw_component_parent
st_component_parent st_component_parent
st_item_made_up_of_following_comp st_item_made_up_of_following_comp
dw_component_child dw_component_child
cb_add_component_parent cb_add_component_parent
cb_delete_component_parent cb_delete_component_parent
end type
type tabpage_packaging from userobject within tab_main
end type
type st_double_click_row_to_maintain from statictext within tabpage_packaging
end type
type cb_delete_packaging from commandbutton within tabpage_packaging
end type
type cb_add_packaging from commandbutton within tabpage_packaging
end type
type st_item_is_pack_material_used_to from statictext within tabpage_packaging
end type
type st_packing_materials_for_item from statictext within tabpage_packaging
end type
type dw_packaging_child from u_dw_ancestor within tabpage_packaging
end type
type dw_packaging_parent from u_dw_ancestor within tabpage_packaging
end type
type tabpage_packaging from userobject within tab_main
st_double_click_row_to_maintain st_double_click_row_to_maintain
cb_delete_packaging cb_delete_packaging
cb_add_packaging cb_add_packaging
st_item_is_pack_material_used_to st_item_is_pack_material_used_to
st_packing_materials_for_item st_packing_materials_for_item
dw_packaging_child dw_packaging_child
dw_packaging_parent dw_packaging_parent
end type
type tabpage_sku_substitutes from userobject within tab_main
end type
type cb_delete_component_sku_substitutes from commandbutton within tabpage_sku_substitutes
end type
type cb_add_component_sku_substitutes from commandbutton within tabpage_sku_substitutes
end type
type dw_sku_substitutes from datawindow within tabpage_sku_substitutes
end type
type tabpage_sku_substitutes from userobject within tab_main
cb_delete_component_sku_substitutes cb_delete_component_sku_substitutes
cb_add_component_sku_substitutes cb_add_component_sku_substitutes
dw_sku_substitutes dw_sku_substitutes
end type
type tabpage_coo from userobject within tab_main
end type
type cb_delete_coo from commandbutton within tabpage_coo
end type
type cb_insert_coo from commandbutton within tabpage_coo
end type
type dw_coo from u_dw_ancestor within tabpage_coo
end type
type tabpage_coo from userobject within tab_main
cb_delete_coo cb_delete_coo
cb_insert_coo cb_insert_coo
dw_coo dw_coo
end type
end forward

global type w_maintenance_itemmaster from w_std_master_detail
integer width = 4398
integer height = 2960
string title = "Item Master Maintenance"
boolean vscrollbar = true
boolean resizable = false
boolean clientedge = true
event ue_select_owner ( )
end type
global w_maintenance_itemmaster w_maintenance_itemmaster

type variables
//TimA 02/21/13 added idw_item_coo
//Pandora issue #560
Datawindow   idw_main, idw_search,idw_query, idw_price,idw_Reorder, idw_replenish, idw_sku, &
	      idw_component_parent, idw_component_child,  idw_packaging_parent, idw_packaging_child, idw_storage_Rule, &
		idw_sku_substitutes, idw_main_original, idw_item_coo
 
Boolean	ibSupplierUpdate,ibSupplierChanged, ibInterfaceTransCreated
Private Boolean ib_dimentions
n_warehouse i_nwarehouse
string i_sql,is_origSQL,isOriqSqlDropdown,isOrigSupplier, isUpdateSql[], isoriqsqldropdown_owner
w_maintenance_itemmaster iw_window
Long	ilDedLocRow
datawindowchild idwc_cc_class
String is_project

String is_current_sku, is_current_supp_cd	// LTK 20111214 OTM additions //Need place holder for current sku

//Dec id_length_1, id_width_1, id_height_1, id_weight_1	// LTK 20120427 OTM additions

String isWarehouse
Datawindowchild idwc_owner

n_otm in_otm

DataWindowChild idwc_hazard_codes		// LTK 20151028
end variables

forward prototypes
public subroutine wf_convert (ref string as_measure)
public function integer wf_validation ()
public function integer uf_gm_fwd_pick (long alrow)
public subroutine dofilterclasscolumn (string _group)
public function integer wf_method_trace_log_entry ()
end prototypes

event ue_select_owner;str_parms	lstrparms

open(w_select_owner)
lstrparms = Message.PowerObjectParm
If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
	idw_main.SetItem(1,"owner_id",Lstrparms.Long_arg[1])
	idw_main.SetITem(1,"c_owner_name",Lstrparms.String_arg[1])
	ib_changed = True
End If
end event

public subroutine wf_convert (ref string as_measure);//This function is used for converting English to Matrics conversion 
//called from itemchange event dw_main

Real lr_length1,lr_length2,lr_length3,lr_length4
real lr_width1,lr_width2,lr_width3,lr_width4
Real lr_height1,lr_height2,lr_height3,lr_height4 
Real lr_weight1,lr_weight2,lr_weight3,lr_weight4
long ll_row
ll_row = idw_main.GetRow()
IF idw_main.object.standard_of_measure.Original[ll_row] = as_measure THEN
		idw_main.object.length_1[ll_row]=idw_main.object.length_1.Original[ll_row]
		idw_main.object.length_2[ll_row]=idw_main.object.length_2.Original[ll_row]
		idw_main.object.length_3[ll_row]=idw_main.object.length_3.Original[ll_row]
		idw_main.object.length_4[ll_row]=idw_main.object.length_4.Original[ll_row]
		idw_main.object.width_1[ll_row]=idw_main.object.width_1.Original[ll_row]
		idw_main.object.width_2[ll_row]=idw_main.object.width_2.Original[ll_row]
		idw_main.object.width_3[ll_row]=idw_main.object.width_3.Original[ll_row]
		idw_main.object.width_4[ll_row]=idw_main.object.width_4.Original[ll_row]
		idw_main.object.height_1[ll_row]=idw_main.object.height_1.Original[ll_row]
		idw_main.object.height_2[ll_row]=idw_main.object.height_2.Original[ll_row]
		idw_main.object.height_3[ll_row]=idw_main.object.height_3.Original[ll_row]
		idw_main.object.height_4[ll_row]=idw_main.object.height_4.Original[ll_row]
		idw_main.object.weight_1[ll_row]=idw_main.object.weight_1.Original[ll_row]
		idw_main.object.weight_2[ll_row]=idw_main.object.weight_2.Original[ll_row]
		idw_main.object.weight_3[ll_row]=idw_main.object.weight_3.Original[ll_row]
		idw_main.object.weight_4[ll_row]=idw_main.object.weight_4.Original[ll_row]
		Return
END IF

lr_length1 = real(idw_main.object.length_1[ll_row])
lr_length2 = real(idw_main.object.length_2[ll_row])
lr_length3 = real(idw_main.object.length_3[ll_row])
lr_length4 = real(idw_main.object.length_4[ll_row])
lr_width1 = real(idw_main.object.width_1[ll_row])
lr_width2 = real(idw_main.object.width_2[ll_row])
lr_width3 = real(idw_main.object.width_3[ll_row])
lr_width4 = real(idw_main.object.width_4[ll_row])
lr_height1 = real(idw_main.object.height_1[ll_row])
lr_height2 = real(idw_main.object.height_2[ll_row])
lr_height3 = real(idw_main.object.height_3[ll_row])
lr_height4 = real(idw_main.object.height_4[ll_row])
lr_weight1 = real(idw_main.object.weight_1[ll_row])
lr_weight2 = real(idw_main.object.weight_2[ll_row])
lr_weight3 = real(idw_main.object.weight_3[ll_row])
lr_weight4 = real(idw_main.object.weight_4[ll_row])

IF as_measure = 'E' THEN			
	idw_main.object.length_1[ll_row]= round(i_nwarehouse.of_convert(lr_length1,'CM','IN'),2)
	idw_main.object.length_2[ll_row]= round(i_nwarehouse.of_convert(lr_length2,'CM','IN'),2)
	idw_main.object.length_3[ll_row]= round(i_nwarehouse.of_convert(lr_length3,'CM','IN'),2)
	idw_main.object.length_4[ll_row]= round(i_nwarehouse.of_convert(lr_length4,'CM','IN'),2)
	idw_main.object.width_1[ll_row]= round(i_nwarehouse.of_convert(lr_width1,'CM','IN'),2)
	idw_main.object.width_2[ll_row]= round(i_nwarehouse.of_convert(lr_width2,'CM','IN'),2)
	idw_main.object.width_3[ll_row]= round(i_nwarehouse.of_convert(lr_width3,'CM','IN'),2)
	idw_main.object.width_4[ll_row]= round(i_nwarehouse.of_convert(lr_width4,'CM','IN'),2)
	idw_main.object.height_1[ll_row]= round(i_nwarehouse.of_convert(lr_height1,'CM','IN'),2)
	idw_main.object.height_2[ll_row]= round(i_nwarehouse.of_convert(lr_height2,'CM','IN'),2)
	idw_main.object.height_3[ll_row]= round(i_nwarehouse.of_convert(lr_height3,'CM','IN'),2)
	idw_main.object.height_4[ll_row]= round(i_nwarehouse.of_convert(lr_height4,'CM','IN'),2)
	idw_main.object.weight_1[ll_row]= round(i_nwarehouse.of_convert(lr_weight1,'KG','PO'),2)
	idw_main.object.weight_2[ll_row]= round(i_nwarehouse.of_convert(lr_weight2,'KG','PO'),2)
	idw_main.object.weight_3[ll_row]= round(i_nwarehouse.of_convert(lr_weight3,'KG','PO'),2)
	idw_main.object.weight_4[ll_row]= round(i_nwarehouse.of_convert(lr_weight4,'KG','PO'),2)	
ELSE
	idw_main.object.length_1[ll_row]= round(i_nwarehouse.of_convert(lr_length1,'IN','CM'),2)
	idw_main.object.length_2[ll_row]= round(i_nwarehouse.of_convert(lr_length2,'IN','CM'),2)
	idw_main.object.length_3[ll_row]= round(i_nwarehouse.of_convert(lr_length3,'IN','CM'),2)
	idw_main.object.length_4[ll_row]= round(i_nwarehouse.of_convert(lr_length4,'IN','CM'),2)
	idw_main.object.width_1[ll_row]= round(i_nwarehouse.of_convert(lr_width1,'IN','CM'),2)
	idw_main.object.width_2[ll_row]= round(i_nwarehouse.of_convert(lr_width2,'IN','CM'),2)
	idw_main.object.width_3[ll_row]= round(i_nwarehouse.of_convert(lr_width3,'IN','CM'),2)
	idw_main.object.width_4[ll_row]= round(i_nwarehouse.of_convert(lr_width4,'IN','CM'),2)
	idw_main.object.height_1[ll_row]= round(i_nwarehouse.of_convert(lr_height1,'IN','CM'),2)
	idw_main.object.height_2[ll_row]= round(i_nwarehouse.of_convert(lr_height2,'IN','CM'),2)
	idw_main.object.height_3[ll_row]= round(i_nwarehouse.of_convert(lr_height3,'IN','CM'),2)
	idw_main.object.height_4[ll_row]= round(i_nwarehouse.of_convert(lr_height4,'IN','CM'),2)
	idw_main.object.weight_1[ll_row]= round(i_nwarehouse.of_convert(lr_weight1,'PO','KG'),2)
	idw_main.object.weight_2[ll_row]= round(i_nwarehouse.of_convert(lr_weight2,'PO','KG'),2)
	idw_main.object.weight_3[ll_row]= round(i_nwarehouse.of_convert(lr_weight3,'PO','KG'),2)
	idw_main.object.weight_4[ll_row]= round(i_nwarehouse.of_convert(lr_weight4,'PO','KG'),2)
END IF	

end subroutine

public function integer wf_validation ();Long	llRowcount,	&
		llRowPos,	&
		llFound, &
		ll_CompCount
		
String	lsFind, &
         ls_CompInd, &
         ls_SerialInd, &
         ls_SKU
String ls_Cubiscan  //TimA 03/14/14 Pandora issue #708
String ls_lot_no, ls_po_no, ls_po_no2,ls_exp_dt,ls_inv_type
Long ll_po_no

if idw_main.rowcount() > 0 then
	if IsNull(idw_main.GetItemString(1, 'item_delete_ind')) then
		idw_main.SetItem(1, 'item_delete_ind', 'N')
	end if
	
	//06-FEB-2019 :Madhu S28685 Added 'Allow_Receipt'
	If IsNull(idw_main.getItemString( 1, 'Allow_Receipt')) Then
		idw_main.setItem( 1, 'Allow_Receipt', 'N')
	End If
	
	//28-AUG-2018 :Madhu S23016 FootPrint Containerization
	//assign Foot Prints Ind value
	If IsNull(idw_main.getItemString( 1, 'Foot_Prints_Ind')) Then
		idw_main.setItem( 1, 'Foot_Prints_Ind', 'N')
	End If
	
	If idw_main.getItemString( 1, 'Foot_Prints_Ind') ='Y'  and Pos(upper(idw_main.getItemString( 1, 'User_Field5')) ,'MICRO') > 0 Then
		idw_main.setItem( 1, 'Container_Advice_Flag', 'Y')
	else
		idw_main.setItem( 1, 'Container_Advice_Flag', 'N')
	end If
end if

If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If

If f_check_required(is_title, idw_price) = -1 Then
	tab_main.SelectTab(2) 
	Return -1
End If

If f_check_required(is_title, idw_reorder) = -1 Then
	tab_main.SelectTab(3) 
	Return -1
End If

If f_check_required(is_title, idw_replenish) = -1 Then
	tab_main.SelectTab(3) 
	Return -1
End If

//If f_check_required(is_title, idw_putaway_loc) = -1 Then
//	tab_main.SelectTab(3) 
//	Return -1
//End If

If f_check_required(is_title, idw_component_parent) = -1 Then
	tab_main.SelectTab(4) 
	Return -1
End If

If f_check_required(is_title, idw_packaging_parent) = -1 Then
	tab_main.SelectTab(5) 
	Return -1
End If


// 04/15/2010 ujh added for Sku_Substitutes
If f_check_required(is_title, idw_main) = -1 Then
	tab_main.SelectTab(6) 
	idw_main.SetFocus()
	Return -1
End If

// 11/00 PCONKL - If any UOM quantites are filled in, then the UOM description must be as well
If idw_main.RowCount() > 0 Then
	
	//Jxlim 01/19/2011 For W&S qty_2 must be > 0
	If is_project = 'WS-' Then	
		If idw_main.GetItemNumber(1,"qty_2") <= 0 Then
			messagebox(is_title,"Qty must be greater than 0!")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			idw_main.SetColumn("qty_2")
			Return -1
		End If
	End If
	//Jxlim 01/19/2011 End of W&S code
	
	If idw_main.GetItemNumber(1,"qty_2") > 0 and (isnull(idw_main.GetItemString(1,"uom_2")) or idw_main.GetItemString(1,"uom_2") = '') Then
		messagebox(is_title,"If Qty > 0 then you must enter a UOM!")
		tab_main.SelectTab(1)
		idw_main.SetFocus()
		idw_main.SetColumn("uom_2")
		Return -1
	End If

	//EPSON - CasePack Required
	

	If gs_project = 'SMYRNA-MU'  AND Trim(Upper(idw_main.GetItemString(1,"supp_code"))) = 'EPSONINC' Then	

	
		If idw_main.GetItemNumber(1,"qty_2") <= 0  OR  (isnull(idw_main.GetItemString(1,"uom_2")) or idw_main.GetItemString(1,"uom_2") = ''  or  upper(trim(idw_main.GetItemString(1,"uom_2"))) <> 'CS' )   Then
			messagebox(is_title,"Must Enter CasePack (CS) Quantity UOM and Qty! (Level 2)")
			tab_main.SelectTab(1)
			idw_main.SetFocus()
			idw_main.SetColumn("qty_2")
			Return -1
		End If
	End If



	If idw_main.GetItemNumber(1,"qty_3") > 0 and (isnull(idw_main.GetItemString(1,"uom_3")) or idw_main.GetItemString(1,"uom_3") = '') Then
		messagebox(is_title,"If Qty > 0 then you must enter a UOM!")
		tab_main.SelectTab(1)
		idw_main.SetFocus()
		idw_main.SetColumn("uom_3")
		Return -1
	End If

	If idw_main.GetItemNumber(1,"qty_4") > 0 and (isnull(idw_main.GetItemString(1,"uom_4")) or idw_main.GetItemString(1,"uom_4") = '') Then
		messagebox(is_title,"If Qty > 0 then you must enter a UOM!")
		tab_main.SelectTab(1)
		idw_main.SetFocus()
		idw_main.SetColumn("uom_4")
		Return -1
	End If

End If /*master exists*/

//Check for required fields and Dups on Component Info
llRowCount = idw_component_parent.RowCount()
For lLRowPos = llRowCount to 1 step -1
	//If sku and supplier are null, delete the row
	If isNUll(idw_component_parent.GetItemString(llRowPos,"sku_child")) and isnull(idw_component_parent.GetItemString(llRowPos,"supp_code_child")) Then
		idw_component_parent.DEleteRow(llRowPos)
		Continue
	End If
	lsFind = "Upper(sku_child) = '" + Upper(idw_component_parent.GetItemString(llRowPos,"sku_child")) + "' and Upper(supp_code_child) = '" + Upper(idw_component_parent.GetItemString(llRowPos,"supp_code_child")) + "'"
	lsFind += " and Upper(bom_group) = '" + Upper(idw_component_parent.GetItemString(llRowPos,"bom_Group")) + "'" /* 01/05 - PCONKL - Group added to primary key */
	llFound = idw_component_parent.Find(lsFind,(llRowPos + 1),llRowCount)
	If llFound > 0 and llFound <> llRowPos Then
		Messagebox(is_title,"Duplicate SKU/Supplier/Group found on Component information!")
		tab_main.SelectTab(4) 
		idw_component_parent.SetFocus()
		idw_component_Parent.SetRow(llFound)
		idw_component_Parent.SetColumn('sku_child')
		Return -1
	End If
Next

// 08/02 - Pconkl - Check for required fields and Dups on Packaging Info
llRowCount = idw_packaging_parent.RowCount()
For lLRowPos = llRowCount to 1 step -1
	//If sku and supplier are null, delete the row
	If isNUll(idw_packaging_parent.GetItemString(llRowPos,"sku_child")) and isnull(idw_packaging_parent.GetItemString(llRowPos,"supp_code_child")) Then
		idw_packaging_parent.DEleteRow(llRowPos)
		Continue
	End If
	lsFind = "sku_child = '" + idw_packaging_parent.GetItemString(llRowPos,"sku_child") + "' and supp_code_child = '" + idw_packaging_parent.GetItemString(llRowPos,"supp_code_child") + "'"
	llFound = idw_packaging_parent.Find(lsFind,(llRowPos + 1),llRowCount)
	If llFound > 0 and llFound <> llRowPos Then
		Messagebox(is_title,"Duplicate SKU/Supplier found on Packaging information!")
		tab_main.SelectTab(5) 
		idw_packaging_parent.SetFocus()
		idw_packaging_Parent.SetRow(llFound)
		idw_packaging_Parent.SetColumn('sku_child')
		Return -1
	End If
Next

// 04/14 GailM - 702 - If Consol Item Type is Inv Attribute Only, ensure at least one lottable fields is checked 
llRowCount = idw_storage_rule.RowCount()
For lLRowPos = llRowCount to 1 step -1
	If idw_storage_rule.GetItemString(lLRowPos,"Item_Consol_Type") = 'N' Then 
		If nz( idw_storage_rule.GetItemString(lLRowPos,"consol_lot_no"),'N' ) = 'N'  and  nz( idw_storage_rule.GetItemString(lLRowPos,"consol_po_no"),'N' ) = 'N' &
			and nz( idw_storage_rule.GetItemString(lLRowPos,"consol_po_no2"),'N' ) = 'N' and  nz( idw_storage_rule.GetItemString(lLRowPos,"consol_exp_dt"),'N' )	 = 'N' &
			and nz( idw_storage_rule.GetItemString(lLRowPos,"consol_inv_type"),'N' ) = 'N'	 Then	
				Messagebox(is_title,"At least one lottable field must be checked for Inv Attribute Only")
				Return -1
		End If	
//	ElseIf idw_storage_rule.GetItemString(lLRowPos,"Item_Consol_Type") = 'G'  or  idw_storage_rule.GetItemString(lLRowPos,"Item_Consol_Type") = 'S' Then 
//		idw_storage_rule.SetItem(lLRowPos,"consol_lot_no","N")
//		idw_storage_rule.SetItem(lLRowPos,"consol_po_no","N")
//		idw_storage_rule.SetItem(lLRowPos,"consol_po_no2","N")
//		idw_storage_rule.SetItem(lLRowPos,"consol_exp_dt","N")
//		idw_storage_rule.SetItem(lLRowPos,"consol_inv_type","N")
	End If

Next

////08/01 - PCONKL - Validate Putawy Locs 
//llRowCount = idw_putaway_loc.RowCOunt()
//For llRowPos = 1 to llRowCount
//	//all fields required except for amt
//	If isnull(idw_putaway_loc.GetITemString(llRowPos,'default_column_1')) Then
//		Messagebox(is_title,"value or '*' (for all) required for Owner field")
//		tab_main.SelectTab(3) 
//		idw_putaway_loc.SetFocus()
//		idw_putaway_loc.SetColumn('default_column_1')
//		REturn -1
//	End If
//	
//	If isnull(idw_putaway_loc.GetITemString(llRowPos,'default_column_2')) Then
//		Messagebox(is_title,"value or '*' (for all) required for Inv Type field")
//		tab_main.SelectTab(3) 
//		idw_putaway_loc.SetFocus()
//		idw_putaway_loc.SetColumn('default_column_2')
//		REturn -1
//	End If
//	
//	If isnull(idw_putaway_loc.GetITemString(llRowPos,'l_code')) Then
//		Messagebox(is_title,"Location required for Putaway Location default")
//		tab_main.SelectTab(3) 
//		idw_putaway_loc.SetFocus()
//		idw_putaway_loc.SetColumn('l_code')
//		REturn -1
//	End If
//	
//Next

//04/03 - PCONKL - Validate Cust Alt SKUs
llRowCount = tab_main.Tabpage_price.dw_cust_SKU.RowCOunt()
For llRowPos = 1 to llRowCount
	If isnull(tab_main.Tabpage_price.dw_cust_SKU.GetITemString(llRowPOs,'cust_alt_SKU')) or tab_main.Tabpage_price.dw_cust_SKU.GetITemString(llRowPOs,'cust_alt_SKU') = '' Then
		Messagebox(is_title,"Customer Alternate SKU is Required!")
		tab_main.SelectTab(2) 
		tab_main.Tabpage_price.dw_cust_SKU.SetFocus()
		tab_main.Tabpage_price.dw_cust_SKU.SetRow(llRowPos)
		tab_main.Tabpage_price.dw_cust_SKU.SetColumn('cust_alt_SKU')
		REturn -1
	End If
Next

// 04/03 - PCONKL - Validate Reorder records for dups
llRowCount = idw_reorder.RowCount()
For lLRowPos = llRowCount to 1 step -1
	lsFind = "wh_Code = '" + idw_reorder.GetItemString(llRowPos,"wh_Code") + "' and owner_ID = " + String(idw_reorder.GetItemNumber(llRowPos,"owner_id"))
	llFound = idw_reorder.Find(lsFind,(llRowPos + 1),llRowCount)
	If llFound > 0 and llFound <> llRowPos Then
		Messagebox(is_title,"Duplicate warehouse/Owner found on Reorder information!")
		tab_main.SelectTab(3) 
		idw_reorder.SetFocus()
		idw_reorder.SetRow(llFound)
		idw_reorder.SetColumn('wh_code')
		Return -1
	End If
Next

// 08/05 - PCONKL - Validate Replenish records for dups
llRowCount = idw_replenish.RowCount()
For lLRowPos = llRowCount to 1 step -1
	//Jxlim 11/28/2012 Added owner_id validation on duplicate code for Pandora BRD #464 FW Pick
	If 	Upper(gs_project) <> "PANDORA"  Then
		lsFind = "wh_Code = '" + idw_replenish.GetItemString(llRowPos,"wh_Code") + "'"
	Else
		lsFind = "wh_Code = '" + idw_replenish.GetItemString(llRowPos,"wh_Code") + "' and owner_ID = " + String(idw_replenish.GetItemNumber(llRowPos,"owner_id"))
	End If
	llFound = idw_replenish.Find(lsFind,(llRowPos + 1),llRowCount)
	If llFound > 0 and llFound <> llRowPos Then
		If 	Upper(gs_project) <> "PANDORA"  Then
			Messagebox(is_title,"Duplicate Warehouse found on Replenish information!")
		Else
			Messagebox(is_title,"Duplicate Warehouse/Owner found on Replenish information!")
		End If
			tab_main.SelectTab(3) 
			idw_replenish.SetFocus()
			idw_replenish.SetRow(llFound)
			idw_replenish.SetColumn('wh_code')
			Return -1
	End If
Next

llRowCount = idw_replenish.RowCount()
For lLRowPos = llRowCount to 1 step -1
	//Jxlim 12/02/2012 Same location can not be used by multiple owners.Pandora BRD #464 FW Pick
	If 	Upper(gs_project) = "PANDORA"  Then		
		lsFind = "l_Code = '" + idw_replenish.GetItemString(llRowPos,"l_Code") + "'"
	End If
	llFound = idw_replenish.Find(lsFind,(llRowPos + 1),llRowCount)
	If llFound > 0 and llFound <> llRowPos Then
		If 	Upper(gs_project) = "PANDORA"  Then
			Messagebox(is_title,"Duplicate location found on Replenish information!")
		End If
			tab_main.SelectTab(3) 
			idw_replenish.SetFocus()
			idw_replenish.SetRow(llFound)
			idw_replenish.SetColumn('wh_code')
			Return -1
	End If
Next

// 04/15/2010  ujh
//llRowCount = idw_sku_substitutes.RowCount()
//Messagebox(is_title,"Sku_substitute row total = !" + String(llRowCount))

// 2/10/2011; David C; Do not allow component items to be serialized if its parent is not serialized for Pandora only
if Upper ( gs_project ) = "PANDORA" and idw_main.RowCount() > 0 then	// LTK 20111216	Added row count

	ls_CompInd = idw_main.Object.component_ind[1]
	ls_SerialInd = idw_main.Object.serialized_ind[1]
	ls_SKU        = idw_main.Object.sku[1]
	ls_Cubiscan        = idw_main.Object.User_Field20[1] //TimA 03/14/14 Pandora issue #708
	// If this a parent and is not being tracked by serial, then check its children
	if ls_CompInd = "Y" then
		if ls_SerialInd = "N" then
			select count(Item_component.SKU_child )
				into :ll_CompCount
			  from Item_component,
						 Item_master
			where Item_master.SKU = Item_component.SKU_child and
						 Item_component.SKU_parent = :ls_SKU and
						 Item_master.serialized_ind <> 'N'
			 using SQLCA;
			
			if not IsNull ( ll_CompCount ) and ll_CompCount > 0 then
				MessageBox ( is_title, "This item is not tracked by serial number. Therefore, its child components cannot be serial tracked either. " + &
											"Please correct the child components of this SKU.", Exclamation! )
				
				Return -1
			end if
		end if
	else
		// If this a child component and is being tracked by serial, then check its parent
		if ls_SerialInd <> "N" then
			 select count(Item_master.SKU)
				into :ll_CompCount
			  from Item_master,
						 Item_component
			where Item_master.SKU = Item_component.SKU_parent and
						 Item_component.SKU_child = :ls_SKU and 
						 Item_master.serialized_ind = 'N'
			  using SQLCA;
			
			if not IsNull ( ll_CompCount ) and ll_CompCount > 0 then
				MessageBox ( is_Title, "This item is being tracked by serial number. The parent SKU of this component is not tracked by serial number. " + &
											"Please correct.", Exclamation! )
				
				Return -1
			end if
		end if
	end if
	//TimA 03/14/14 Pandora issue #708 must have a valid wgh and dims if cube scan is used.
	If Len( ls_Cubiscan) > 0  Then
		Decimal ld_length_1,ld_width_1,ld_height_1,ld_weight_1

		ld_length_1        = idw_main.Object.length_1[1 ]
		If ld_length_1 = 0 or IsNull( ld_length_1) then
			MessageBox ( is_Title, "The length value is invalid. Please correct.", Exclamation! )
			Return -1
		End if
		ld_width_1        = idw_main.Object.width_1[1 ]
		If ld_width_1 = 0 or IsNull( ld_width_1) then
			MessageBox ( is_Title, "The width value is invalid. Please correct.", Exclamation! )
			Return -1
		End if
		ld_height_1        = idw_main.Object.height_1[1 ]
		If ld_height_1 = 0 or IsNull( ld_height_1) then
			MessageBox ( is_Title, "The height value is invalid. Please correct.", Exclamation! )
			Return -1
		End if
		ld_weight_1        = idw_main.Object.weight_1[1 ]
		If ld_weight_1 = 0 or IsNull( ld_weight_1) then
			MessageBox ( is_Title, "The weight value is invalid. Please correct.", Exclamation! )
			Return -1
		End if

	End if
end if

Return 0
end function

public function integer uf_gm_fwd_pick (long alrow);String	lsOrigLoc, lsNewLoc, lsSKU, lsWarehouse, lsSupplier
Long		llArrayCount, llCount

//Update or add fwd pick replenishment records

//08/06 - PCONKL - Dedicated Location info nw coming from strage rule DW
lsOrigLoc = idw_storage_rule.GetITemString(alrow,'dedicated_location',Primary!,True)
lsNewLoc = idw_storage_rule.GetITemString(alRow,'dedicated_location')
lswarehouse = idw_storage_rule.GetITemString(alRow,'wh_code')

If idw_replenish.RowCount() > 0 and  g.ibforwardpickenabled Then
	
	idw_replenish.SetItem(1,'l_code',lsNewLoc)
		
Else
	
	idw_Replenish.TriggerEvent('ue_insert')
	idw_replenish.SetITem(1,'l_code',lsNewLoc)
	idw_replenish.SetITem(1,'min_fp_qty',1)
	idw_replenish.SetITem(1,'max_qty_to_Pick',9999999)
	idw_replenish.SetITem(1,'replenish_qty',9999999)
	idw_Replenish.SetItem(1,'last_update',Today()) 
	idw_Replenish.SetItem(1,'last_user',gs_userid)	
	idw_Replenish.SetItem(1,'wh_code',lsWarehouse)	
	
End If

//Update Location table - Sku reserved ind.
lsSku = idw_Main.GetITemString(1,'sku')
lsSupplier = idw_Main.GetITemString(1,'supp_code')
llArrayCount = UpperBound(isUpdateSql)
						
//clear old
If lsOrigLoc > '' Then
	
	llArrayCount ++
	isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '' Where  wh_Code = (select wh_code from project_warehouse where project_id = '" + gs_project + "')" + &
										 " and l_code = '" + lsOrigLoc + "' and sku_Reserved = '" + lsSKU + "';"
End If
					
//Set new

llArrayCount ++

If lsNewLoc > '' Then

	isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '" + lsSKU + "', l_type = 'Y' Where  wh_Code = (select wh_code from project_warehouse where project_id = '" + gs_project + "')" + &
										 " and l_code = '" + lsNewLoc + "';"
										 
	// 01/07 - PConkl - Also want to update Fwd Pick and Storage Rule for other suppliers of this SKU
 	llArrayCount ++
 	isUpdateSql[llArrayCount] = "Update Item_storage_Rule Set Dedicated_location = '" + lsNewLoc + "' Where project_id = 'GM_MI_DAT' and Sku = '" + lsSKU + &
 										"' and supp_code <> '" + lsSUpplier + "';"
		
 	llArrayCount ++
 	isUpdateSql[llArrayCount] = "Update Item_Forward_Pick Set l_code = '" + lsNewLoc + "' Where project_id = 'GM_MI_DAT' and Sku = '" + lsSKU + &
 										"' and supp_code <> '" + lsSUpplier + "';"
										 
Else
	
	if idw_replenish.RowCount() = 1 Then
		idw_replenish.DeleteRow(1)
	End If
						
End If

// pvh for pConklin 04/18/06
If Not ib_Changed Then
	iw_window.TriggerEvent('ue_save')
End If
			
//If we were updating a Dedicated Location, we will need to reset the cursor back to that DW
if ilDedLocrow > 0 Then
	idw_storage_rule.setFocus()
	idw_storage_rule.setRow(ilDedLocrow)
	idw_storage_rule.setColumn('qty_for_location')
End If

Return 0
end function

public subroutine dofilterclasscolumn (string _group);// doFilterClassColumn( string _group )

string filterThis

if IsNull( _group ) or len( _group ) = 0 then
	filterThis = ''
else
	filterThis = "group_code = '" + trim( _group ) + "'"
end if

idwc_cc_class.setFilter( filterThis )
idwc_cc_class.filter()

end subroutine

public function integer wf_method_trace_log_entry ();//25-May-2018 :Madhu - S19730 - Method Trace Log Entry

string ls_qa_check_ind, ls_hazard_cd, ls_hazard_text_cd, ls_hazard_class, ls_sku, ls_last_user
datetime ldt_last_update

ls_sku = idw_main.getitemstring( 1, 'sku')

ls_qa_check_ind = idw_main.getitemstring( 1, 'qa_check_ind')
ls_hazard_cd = idw_main.getitemstring( 1, 'hazard_cd')
ls_hazard_text_cd =idw_main.getitemstring( 1, 'hazard_text_cd')
ls_hazard_class= idw_main.getitemstring( 1, 'hazard_class')

ls_last_user = idw_main.getitemstring( 1, 'last_user')
ldt_last_update = idw_main.getitemdatetime( 1, 'last_update')

f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'QA Check Ind value :' +ls_qa_check_ind ,ls_sku, ' ',' ',ls_sku)		

f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'Hazard Cd value :' +ls_hazard_cd ,ls_sku, ' ',' ',ls_sku)
f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'Hazard Text Cd value :' +ls_hazard_text_cd ,ls_sku, ' ',' ',ls_sku)
f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'Hazard Class value :' +ls_hazard_class ,ls_sku, ' ',' ',ls_sku)

f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'Last User value :' +ls_last_user ,ls_sku, ' ',' ',ls_sku)
f_method_trace_special( gs_project, this.ClassName() + ' - wf_method_trace_log_entry()', 'Last Update value :' +string(ldt_last_update ,'mm/dd/yyyy hh:mm') ,ls_sku, ' ',' ',ls_sku)


Return 0
end function

on w_maintenance_itemmaster.create
int iCurrent
call super::create
end on

on w_maintenance_itemmaster.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_edit;// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

This.Title = is_title + " - Edit"
ib_edit = True
ib_changed = False
ibSupplierUpdate = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

idw_main.Reset()
idw_price.Reset()
tab_main.tabpage_price.dw_cust_SKu.Reset()

idw_main.Hide()
idw_price.Hide()
tab_main.tabpage_price.dw_cust_SKu.Hide()

tab_main.tabpage_reorder.Enabled = False /* 07/00 PCONKL */
tab_main.tabpage_component.Enabled = False /* 09/00 PCONKL */
tab_main.tabpage_packaging.Enabled = False /* 08/02 PCONKL */
tab_main.tabpage_price.Enabled = False /* 01/02 PCONKL */
tab_main.tabpage_sku_substitutes.Enabled = False /* 04/10 ujhall */
tab_main.tabpage_coo.Enabled = False /* 02/21/13 TimA */

tab_main.tabpage_price.cb_insert_Price.Hide()
tab_main.tabpage_price.cb_delete_Price.Hide()
tab_main.tabpage_price.cb_insert_cust_alt_sku.Hide()
tab_main.tabpage_price.cb_delete_cust_alt_sku.Hide()
tab_main.tabpage_main.cb_item_master_owner.Hide() /* 09/00 PCONKL */
tab_main.SelectTab(1) 

// 09/00 PCONKL - using DW instead of SLE's
idw_sku.modify("sku.protect=0 supp_code.Protect=1")
idw_sku.SetItem(1,"sku",'')
idw_sku.SetItem(1,"supp_code",'')
idw_sku.SetFocus()
idw_sku.SetColumn("sku")







end event

event ue_save;Integer li_ret
String ls_serial_number,ls_lot_controlled ,ls_po_controlled,  lsSupplier, lsOrigSupplier, lsSku, lsemptyArray[]
Long	llArrayPos
//String ls_action
Boolean lb_otm_field_changes

String lsCoo
Long llCooCount,i

IF f_check_access(is_process,"S") = 0 THEN Return -1

SetPointer(Hourglass!)

If idw_main.AcceptText() = -1 Then 
	tab_main.SelectTab(1) 
	idw_main.SetFocus()
	Return -1
End If

If idw_price.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_price.SetFocus()
	Return -1
End If

If tab_main.tabpage_Price.dw_cust_SKU.AcceptText() = -1 Then 
	tab_main.SelectTab(2) 
	idw_price.SetFocus()
	Return -1
End If

If idw_reorder.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_reorder.SetFocus()
	Return -1
End If

If idw_replenish.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_replenish.SetFocus()
	Return -1
End If

If idw_storage_rule.AcceptText() = -1 Then 
	tab_main.SelectTab(3) 
	idw_storage_rule.SetFocus()
	Return -1
End If

//If idw_putaway_loc.AcceptText() = -1 Then 
//	tab_main.SelectTab(3) 
//	idw_putaway_loc.SetFocus()
//	Return -1
//End If

If idw_component_parent.AcceptText() = -1 Then 
	tab_main.SelectTab(4) 
	idw_component_parent.SetFocus()
	Return -1
End If

If idw_packaging_parent.AcceptText() = -1 Then 
	tab_main.SelectTab(5) 
	idw_packaging_parent.SetFocus()
	Return -1
End If

// 04/15/2010 ujh
If idw_SKU_Substitutes.AcceptText() = -1 Then 
	tab_main.SelectTab(6) 
	idw_packaging_parent.SetFocus()
	Return -1
End If

//TimA 02/14/13 Pandora issue #560
If idw_item_coo.AcceptText() = -1 Then 
	tab_main.SelectTab(7) 
	idw_item_coo.SetFocus()
	Return -1
End If
If idw_item_coo.rowcount( ) > 0 then
	llCooCount = idw_item_coo.rowcount( )
	For i = 1 to llCooCount
		lsCoo = idw_item_coo.Getitemstring(i,'country_of_origin')
		If lsCoo = 'XX' or lsCoo = 'XXX' then
			Messagebox(is_Title, 'You cannot choose XX as a country.',Stopsign!)
			Return - 1
		End if
	next
End if

//if idw_main.DeletedCount() > 0 then
// 	MessageBox ("DeleteRow",  string(idw_main.GetItemString( 1, "sku", Delete!, true)))
//	 
//end if



//MEA - 3/13 - Moved to OTM nvo

//// LTK 20111214	OTM Changes - set action code
//if Upper(g.is_OTM_Item_Master_Send_Ind) = 'Y' then
//	if idw_main.RowCount() > 0 then
//		choose case idw_main.GetItemStatus(1,0,Primary!)
//			case New!, NewModified!
//				ls_action = 'I'
//			case DataModified!
//				ls_action = 'U'
//		end choose
//	else
//		ls_action = 'D'
//	end if
//end if

//Validations
//If ib_changed Then
	If wf_validation() < 0 Then 
		Return -1
	End If
//End If

If   tab_main.tabpage_sku_substitutes.dw_sku_substitutes.Event ue_validatelist(idw_Sku_Substitutes)  = 1 then
	return 1
End if

// Updating the Datawindow

SetMicroHelp("Saving Changes...")

// pvh 02.28.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

//MEA 3/31 - Moved to OTM

//if Upper(g.is_OTM_Item_Master_Send_Ind) = 'Y' then
//	// LTK 20111214	OTM Changes - determine if a field in the set of OTM fields has had a data modification
//	lb_otm_field_changes = wf_otm_fields_modified()
//end if

wf_method_trace_log_entry() //25-May-2018 :Madhu S19730 - Method Trace Log Entry

Execute Immediate "Begin Transaction" using SQLCA;  // 11/22/04 - Turned Autocommit on, requiring 'Begin Transaction'
If (idw_main.RowCount() > 0) Then 
	//idw_main.SetItem(1,'last_update',Today()) 
	idw_main.SetItem(1,'last_update',ldtToday) 
	idw_main.SetItem(1,'last_user',gs_userid)	
	SQLCA.DBParm = "disablebind =0"
	li_ret = idw_main.Update(true, false)
	SQLCA.DBParm = "disablebind =1"
Else
	li_ret = 1
End If

If li_ret = 1 Then li_ret = tab_Main.Tabpage_Price.dw_cust_SKU.Update()
If li_ret = 1 Then li_ret = idw_price.Update()
If li_ret = 1 Then li_ret = idw_reorder.Update() 
If li_ret = 1 Then	li_ret = idw_replenish.Update() 
If li_ret = 1 Then li_ret = idw_storage_Rule.Update() 
//If li_ret = 1 Then li_ret = idw_putaway_loc.Update()
If li_ret = 1 Then li_ret = idw_component_parent.Update() 
If li_ret = 1 Then li_ret = idw_packaging_parent.Update() 
If li_ret = 1 Then li_ret = idw_SKU_Substitutes.Update()      /* 04/15/2010 ujh*/
If li_ret = 1 Then li_ret = idw_item_coo.Update()      // TimA 02/14/13 Added Pandora issue #590
If li_ret = 1 and idw_main.RowCount() < 1 then li_ret = idw_main.Update()

// 08/05 - PCONKL - for FWD Pick ( or anything else), we may need to upate other tables that we didn't want to do until everything else saved
If UpperBound(isupdateSql) > 0 and li_Ret = 1 Then
	
	For llArrayPos = 1 to UpperBound(isupdateSql)
		Execute Immediate :isUpdateSql[llarrayPos] using SQLCA;		
		If Sqlca.Sqlcode < 0 Then
			li_ret = -1
			Exit
		End If
	Next
	
	isUpdateSql = lsEmptyArray /*Reset Array*/
	
End If

IF li_ret = 1 THEN
	Execute Immediate "COMMIT" using SQLCA;
	IF Sqlca.Sqlcode = 0 THEN

		// LTK 20111214	OTM Changes - If the project is set up to send IM OTM changes and the appropriate OTM fields have been modified, send action code and 
		//						Item_Master keys to WebSphere which will asychronously forward to the TIBCO bus.  Don't process server return codes.
		
		// MEA - 3/13 - Changed so it uses the instand variable version.
		
		if Upper(g.is_OTM_Item_Master_Send_Ind) = 'Y' then	
		 
			if idw_main.RowCount() > 0 then
				is_current_sku = idw_main.Object.sku[1]
				is_current_supp_cd = idw_main.Object.supp_code[1]
			end if
			
			in_otm.uf_process_itemmaster(gs_project,  idw_main,is_current_sku,  is_current_supp_cd)
			
			string ls_OTM_Sent_Ind
			
			select OTM_Sent_Ind into :ls_OTM_Sent_Ind
				from item_master 
				where project_Id = :gs_project and
						 sku = :is_current_sku and
						 supp_code = :is_current_supp_cd using SQLCA;
						 
						 
			idw_main.SetItem( 1,  "OTM_Sent_Ind", ls_OTM_Sent_Ind)
			
//			String ls_return_cd, ls_error_message
////			n_otm ln_otm
////			ln_otm = CREATE n_otm
//
//			if ls_action = 'D' then
//				// Action is Delete.  Send the stored IM keys to OTM via a WebSphere call.
//				in_otm.uf_push_otm_item_master(ls_action, gs_project, is_delete_sku, is_delete_supp_cd, ls_return_cd, ls_error_message)
//			elseif (ls_action = 'I' or ls_action = 'U') and lb_otm_field_changes and idw_main.RowCount() > 0 then
//				// If data has been modified in the OTM fields, send the IM keys to OTM via a WebSphere call.
//				in_otm.uf_push_otm_item_master(ls_action, idw_main.Object.project_id[1], idw_main.Object.sku[1], idw_main.Object.Supp_Code[1], ls_return_cd, ls_error_message)
//				
//				wf_set_otm_dims()	// LTK 20120427 OTM additions 
//			end if
		end if
		// end OTM changes

		idw_main.ResetUpdate()
		
		// 10/00 PCONKL - If the Supplier is changing (only if it is 'XX' from Conversion) then we
		//						need to run stored procedure which will create a new Item Master record with the 
		//						new sku/supplier, update all the dependant records and delete the existing SKU.
		//						We will also have to update any dependent records already retrieved in this window (prices, component, etc.)
		If ibsupplierchanged Then
			lsSupplier = idw_sku.GetItemString(1,"supp_code") /*new Value)*/
			lsSku = idw_sku.GetItemString(1,"sku")
			SetMicroHelp("Updating Supplier...")
			Sqlca.sp_item_master_supp_code_upd(gs_project,lsSku,isOrigSupplier,lsSupplier)
			If Sqlca.SqlCode <> 0 Then
				//Execute Immediate "ROLLBACK" using SQLCA;
				messagebox(is_Title,"Unable to process Supplier Change Request!~r~r" + Sqlca.Sqlerrtext)
				return -1
			Else
				//Execute Immediate "COMMIT" using SQLCA;
				ibsupplierchanged = False
				ib_changed = False
				// 11/00 PCONKL - If not deleting (main rowcount > 0), re-retrieve, else reset search */
				If idw_main.RowCount() > 0 Then
					This.TriggerEvent("ue_retrieve") /*re-retrieve in case more updates are being made to this record*/
				Else
					idw_sku.Reset()
					idw_sku.insertRow(0)
				End If
			End If
		End If /*Supplier Updated*/
		
		SetMicroHelp("Record Saved!")
		
		ib_changed = False
		
		IF ib_edit = False THEN
			ib_edit = True
			This.Title = is_title + " - Edit"
			im_menu.m_file.m_save.Enable()
			im_menu.m_file.m_retrieve.Enable()
			im_menu.m_record.m_delete.Enable()
		END IF
		
	//	Return 0
		
   ELSE
		Execute Immediate "ROLLBACK" using SQLCA;
      MessageBox(is_title, SQLCA.SQLErrText)
		Return -1
   END IF
	
ELSE
	
  Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox(is_title, "System error, record save failed!")
	Return -1
	
END IF


// 02/07 - PCONKL - Add a Batch ransaction record for updates - Only need to write once - not retrieving by SKU - by Flag 'Interface_Upd_Req_Ind' set in ITemChanged
If not ibinterfacetranscreated Then
	
	Execute Immediate "Begin Transaction" using SQLCA; 
	
	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
							Values(:gs_Project, 'IM', "",'N', :ldtToday, '');
							
	Execute Immediate "COMMIT" using SQLCA;
	
	ibinterfacetranscreated = True
	
End If

IF IsValid( w_ro ) AND idw_main.RowCount() > 0 THEN
	
	// Call function that will update qa_check_ind in case it was updated on item info
	w_ro.wf_refresh_qa_check_ind( idw_main.GetItemString( 1, 'sku' ),		&
											  idw_main.GetItemString( 1, 'supp_code' ),		&
											  idw_main.GetItemNumber( 1, 'owner_id' ) )
	
END IF

SetPointer(Arrow!)
Return 0
end event

event ue_delete;call super::ue_delete;Long i, ll_cnt
string	lsRONO, lsSKU, lsSupplier, lsCrap

If f_check_access(is_process,"D") = 0 Then Return

// Prompting for deletion
If MessageBox(is_title, "Are you sure you want to delete this record",Question!,YesNo!,2) = 2 Then
	Return
End If

SetPointer(HourGlass!)

//08/06 - PCONKL - Make sure there is no history where we have no FK's (DB integrity will take care of the other tables)...
lsRONO = gs_project + "%" /* any rono's for project*/
lsSKU = idw_main.getItemString(1,'sku')
lsSupplier = idw_main.getItemString(1,'supp_Code')

Select Min(ro_no) into :lsCrap
From Receive_Detail
Where sku = :lsSku and supp_code = :lsSupplier and ro_no like :lsRoNo;

If lsCrap = "" or isnull(lscrap) Then
	Select Min(do_no) into :lsCrap
	From Delivery_Detail
	Where sku = :lsSku and supp_code = :lsSupplier and do_no like :lsRoNo;
End If

If lsCrap > "" Then
	MessageBox(is_title, "There is history for this item.~rIt can not be deleted!",Stopsign!)
	SetPointer(Arrow!)
	Return
End If
	
ib_changed = False

tab_main.SelectTab(1)

ll_cnt = idw_price.RowCount()
For i = ll_cnt to 1 step -1
	idw_price.DeleteRow(i)
Next

// 07/00 PCONKL
ll_cnt = idw_reorder.RowCount()
For i = ll_cnt to 1 step -1
	idw_reorder.DeleteRow(i)
Next

// 04/03 PCONKL
ll_cnt = tab_main.tabpage_price.dw_cust_SKu.RowCount()
For i = ll_cnt to 1 step -1
	tab_main.tabpage_price.dw_cust_SKu.DeleteRow(i)
Next

//3/13 - Moved to OTM - nvo

// LTK 20111214 OTM additions
if idw_main.RowCount() > 0 then
	is_current_sku = idw_main.Object.sku[1]
	is_current_supp_cd = idw_main.Object.supp_code[1]
end if

idw_main.DeleteRow(1)

If This.Trigger Event ue_save() = 0 Then
	SetMicroHelp("Record Deleted!")
Else
	SetMicroHelp("Record delete failed!")
End If
This.Trigger Event ue_edit()

end event

event ue_new;DatawindowChild	ldwc
String	lsEmptyArray[]

// Acess Rights
If f_check_access(is_process,"N") = 0 Then Return
//g.of_getuserid()
// Looking for unsaved changes
If wf_save_changes() = -1 Then Return	

isUpdateSql = lsEmptyArray /*Reset Array of pending SQL changes*/

This.Title = is_title + " - New"
ib_edit = False
ib_changed = False
ibSupplierUpdate = False

// Changing menu properties
im_menu.m_file.m_save.Disable()
im_menu.m_file.m_retrieve.Enable()
im_menu.m_record.m_delete.Disable()

// Tab properties
tab_main.SelectTab(1)

idw_main.Reset()
idw_price.Reset()
idw_component_child.Reset()
idw_component_parent.Reset()
idw_packaging_child.REset()
idw_packaging_parent.REset()
//idw_putaway_loc.Reset()
idw_reorder.REset()
tab_main.tabpage_price.dw_cust_SKu.REset()

idw_main.InsertRow(0)
idw_main.Show()
idw_main.Object.DataWindow.ReadOnly=True
tab_main.tabpage_main.cb_item_master_owner.Show() /* 09/00 PCONKL */
//idw_main.Hide()
//idw_price.Hide()
tab_main.tabpage_price.cb_insert_Price.Hide()
tab_main.tabpage_price.cb_delete_Price.Hide()
tab_main.tabpage_price.cb_insert_cust_alt_sku.Hide()
tab_main.tabpage_price.cb_delete_cust_alt_sku.Hide()

idw_sku.Reset()
idw_sku.InsertRow(0)
idw_sku.GetChild("supp_code",ldwc)
//reset doesn't seem to clear previous dddw entries, retrieve with crap to clear
//ldwc.SetTransObject(SQLCA)
//ldwc.Retrieve('xxxxx','xxxxx')
					
idw_sku.Modify("sku.Protect=0 supp_code.Protect=0")
idw_sku.SetFocus()
idw_sku.SetColumn("sku")
idw_main.object.standard_of_measure[1]=g.is_std_mesure
idw_Main.SetITem(1,'pick_cart_status','N') /* 11/13 - PCONKL*/
end event

event ue_retrieve;call super::ue_retrieve;String lsSku,	&
		  lsSupplier,	 lsOwner, &
		  lsWhere,		&
		  lsNewSQL,		&
		  lsDDSql, lsEmptyArray[]
		  
Long   ll_rows,	&
		 llCount,	&
		 llOwner
Integer	liRC

//TimA 02/14/13
Long llCooRow
DatawindowChild	LDWC

isUpdateSql = lsEmptyArray /*Reset Array of pending SQL changes*/
idw_sku.accepttext( ) //08-Mar-2018 :Madhu DE3342 - Retreive SKU.

lsSku = idw_sku.GetItemString(1,"sku")
lsSupplier = idw_sku.GetItemString(1,"supp_code")

If UpperBound(Istrparms.String_arg) > 1 Then 

	If Istrparms.String_arg[1] = 'ITEMMASTER' then
		lsSku = Istrparms.String_arg[2]
		lsSupplier = Istrparms.String_arg[3]
		 Idw_sku.SetItem(1,"sku",lsSku)
		 idw_sku.SetItem(1,"supp_code",lsSupplier)
		
	End if
End If


// 09/00 PROJECT AND SKU ALWAYS NEED TO BE ADDED TO RETRIEVAL
lsWhere = " Where project_id = '" + gs_project + "' and sku = '" + lsSku + "'"

IF NOT IsNull(lsSku) Or lsSku <> '' THEN
	
	// 09/00 - Do a count for project/sku. If > 1 than supplier is required
	Select Count(*) into :llCount
	From Item_MAster
	Where project_id = :gs_Project and
			Sku = :lsSku
			Using SQLCA;
			
	Choose Case llCount
		Case 0 /*not found*/
			ll_rows = 0
		Case 1
			If lsSupplier > ' ' Then
				//modify SQL to include supplier in Where Clause
				lsWhere += " and supp_code = '" + lsSupplier + "'"
			End If
			
				lsNewSQL = is_origsql + lsWhere
				liRC = idw_main.SetSqlSelect(lsNewSQL)
				ll_rows = idw_main.Retrieve(gs_project,lsSku)       // Retrieving the entry datawindow
				
		Case Else /*multiple rows, Must enter Supplier*/
			If lsSupplier > ' ' Then
				//modify SQL to include supplier in Where Clause
				lsWhere += " and supp_code = '" + lsSupplier + "'"
				lsNewSQL = is_origsql + lsWhere
				liRC = idw_main.SetSqlSelect(lsNewSQL)
				ll_rows = idw_main.Retrieve(gs_project,lsSku)
			Else /*Supplier must be entered*/
				
				//Populate Supplier dropdown for SKU - 
				If ib_edit Then
					idw_sku.GetChild("supp_code",ldwc)
					//Modify sql to replace dummy values with project and sku
					ldwc.SetTransObject(SQLCA)
					lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
					lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,lsSku)
					ldwc.SetSqlSelect(lsDDSQL)
					ldwc.Retrieve()
					
				End If
				
				idw_sku.Modify("supp_code.Protect=0")
				idw_sku.SetFocus()
				idw_sku.SetColumn("supp_code")
				Return
				
			End If
			
	End Choose
	
	IF ib_edit THEN								 // Edit Mode
		IF ll_rows > 0 THEN
			
			idw_main.Object.DataWindow.ReadOnly=False
			lsSupplier = idw_main.getItemString(1,"supp_code")
			lsSku = idw_main.GetItemString(1,"sku")

			idw_price.Retrieve(gs_project,lsSku,lsSupplier)
			//TimA 02/14/13 Pandora issue #560
			llCooRow = idw_item_coo.Retrieve(gs_project,lsSku,lsSupplier)
			
			If llCooRow > 0 then
				tab_main.tabpage_main.dw_main.object.Country_of_origin_default.visible= False
				tab_main.tabpage_main.dw_main.object.country_of_origin_default_t.visible= False				
				
			else
				tab_main.tabpage_main.dw_main.object.Country_of_origin_default.visible= True
				tab_main.tabpage_main.dw_main.object.country_of_origin_default_t.visible= True				
			end if
			tab_main.tabpage_reorder.Enabled = True
			tab_main.tabpage_component.Enabled = True 
			tab_main.tabpage_packaging.Enabled = True 
			tab_main.tabpage_price.Enabled = True 
//			tab_main.tabpage_sku_substitutes.Enabled = True   //ujh 04/13/2010   //05/06/2010 ujh removed
			// 05/06/2010 ujh  2 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).
			If gs_role = '1' or gs_role = '0' or gs_role = '-1' Then
				if upper(gs_Project) = 'PANDORA' then
					tab_main.tabpage_sku_substitutes.visible = true
					tab_main.tabpage_sku_substitutes.enabled = true
					//tab_main.tabpage_coo.visible = true		// LTK 20150716  Pandora #989
					//tab_main.tabpage_coo.enabled = true					
				else
					tab_main.tabpage_sku_substitutes.visible = false
					tab_main.tabpage_sku_substitutes.enabled =false
					tab_main.tabpage_coo.visible = false
					tab_main.tabpage_coo.enabled = false										
				end if
			else
				tab_main.tabpage_sku_substitutes.visible = false
				tab_main.tabpage_sku_substitutes.enabled =false
				tab_main.tabpage_coo.visible = false
				tab_main.tabpage_coo.enabled = false														
			end if
			// 05/06/2010 ujh: End 2 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).
			
			idw_reorder.Retrieve(gs_project,lsSku,lssupplier) 

			//Jxlim 11/09/2012 Addeded Owner_code			
			idw_replenish.Retrieve(gs_project,lsSku,lssupplier)
			
			idw_sku_substitutes.Retrieve(gs_project,lsSku,lssupplier)// TAM 04/18/2010
//			idw_putaway_loc.Retrieve(gs_project,lsSku,lssupplier) 
			
			// 09/00 PCONKL - Load Parent Component Info
			If idw_main.GetItemString(1,"component_ind") = 'Y' Then
				idw_component_parent.visible=True
				tab_main.tabpage_component.st_component_parent.visible=True
				tab_main.tabpage_component.cb_add_component_parent.visible=True
				tab_main.tabpage_component.cb_delete_component_parent.visible=True
				idw_component_parent.Retrieve(gs_project,lsSku,lsSupplier,"C") /* 08/02 - Pconkl - Component type = 'C' for Component (DW also used for packaging) */
			Else
				//Hide Parent info is this item is not a component
				idw_component_parent.Reset()
				idw_component_parent.visible=False
				tab_main.tabpage_component.st_component_parent.visible=False
				tab_main.tabpage_component.cb_add_component_parent.visible=False
				tab_main.tabpage_component.cb_delete_component_parent.visible=False
			End If

			//Load Child Component Info
			idw_component_child.Retrieve(gs_project,lsSku,lsSupplier,"C") /* 08/02 - Pconkl - Component type = 'C' for Component (DW also used for packaging) */
			
			// 08/02 - PConkl - Load Packaging Information
			idw_packaging_parent.Retrieve(gs_project,lsSku,lsSupplier,"P") /* P = Packaging (DW used for Components as well */
			idw_packaging_child.Retrieve(gs_project,lsSku,lsSupplier,"P")
			
			// 04/01 - PCONKL - Load Customer Alt SKUs
			tab_main.tabpage_price.dw_cust_Sku.Retrieve(gs_project,lsSku,lsSupplier)
			
			// 08/06 - PCONKL - Load Item Storage Rule Info
			idw_storage_Rule.TriggerEvent('ue_Retrieve')
			
			idw_main.Show()
			idw_price.Show()
			tab_main.tabpage_price.dw_Cust_SKU.Show()
			
			tab_main.tabpage_price.cb_insert_Price.Show()
			tab_main.tabpage_price.cb_delete_Price.Show()
			tab_main.tabpage_price.cb_insert_cust_alt_sku.Show()
			tab_main.tabpage_price.cb_delete_cust_alt_sku.Show()
			
			tab_main.tabpage_main.cb_item_master_owner.Show() 			
		
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			im_menu.m_record.m_delete.Enable()

	// 11/00 PCONKL - We will allow any supplier to be changed!
	
			idw_sku.Modify("sku.Protect=1 supp_code.Protect=0")
			ibSupplierUpdate = True /*will allow supplier to be changed without triggering ue_retrieve*/
			isOrigSupplier = idw_main.getItemString(1,"supp_code") /*needed if changing supplier*/
			
			ibsupplierchanged = False
			
			idw_sku.SetItem(1,"supp_code",idw_main.GetItemString(1,"supp_code"))
			idw_main.SetItem(1,"c_owner_name",g.of_get_owner_name(idw_main.GetItemNumber(1,"owner_id")))
			
			//reset the supplier dropdown
			idw_sku.GetChild("supp_code",ldwc)
			ldwc.SetTransObject(SQLCA)
			ldwc.Reset()
		
		This.Title = This.Title + " [" + idw_main.GetItemString(1,"supp_code") + "/" + idw_main.GetItemString(1,"sku") + "]"
			
		ELSE
			
			MessageBox(is_title, "Record not found, please enter again!", Exclamation!)
			idw_sku.SetFocus()
			idw_sku.SetColumn("sku")
			tab_main.tabpage_reorder.Enabled = False
			tab_main.tabpage_price.Enabled = False

		END IF
			
	ELSE  // New Mode
		
		IF ll_rows > 0 THEN
			MessageBox(is_title, "Record already exist, please enter again", Exclamation!)
			idw_sku.SetFocus()
			idw_sku.SetColumn("sku")
		ELSE
			idw_sku.Modify("sku.Protect=1")
			idw_main.Reset()
			idw_main.InsertRow(0)
			idw_main.Object.DataWindow.ReadOnly=False
			idw_main.SetItem(1,"project_id",gs_project)
			idw_main.SetItem(1,"sku",lsSku)
			
			idw_main.Show()
			idw_price.Show()
			tab_main.tabpage_price.dw_Cust_SKU.Show()
			
			tab_main.tabpage_price.cb_insert_Price.Show()
			tab_main.tabpage_price.cb_delete_Price.Show()
			tab_main.tabpage_price.cb_insert_cust_alt_sku.Show()
			tab_main.tabpage_price.cb_delete_cust_alt_sku.Show()
			
			tab_main.tabpage_main.cb_item_master_owner.Show()
			idw_main.SetFocus()
			im_menu.m_file.m_save.Enable()
			tab_main.tabpage_reorder.Enabled = True
			tab_main.tabpage_component.Enabled = True
			tab_main.tabpage_packaging.Enabled = True
			tab_main.tabpage_price.Enabled = True 
//			tab_main.tabpage_sku_substitutes.Enabled = True   //ujh 04/13/2010   //05/06/2010 ujh removed
			// 05/06/2010 ujh  3 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).
			If gs_role = '1' or gs_role = '0' or gs_role = '-1' Then
				if upper(gs_Project) = 'PANDORA' then
					tab_main.tabpage_sku_substitutes.visible = true
					tab_main.tabpage_sku_substitutes.enabled = true
				end if
			else
				tab_main.tabpage_sku_substitutes.visible = false
				tab_main.tabpage_sku_substitutes.enabled =false
			end if
			// 05/06/2010 ujh: End 3 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).
			
			ib_changed = True
			
			// 09/00 PCONKL - Set Supplier and defaultOwner to Supplier if not already set
			idw_main.SetItem(1,"supp_code",lsSupplier)
			
			//If not tracking COO, default to 'XXX' since it is still required in the DB
			If g.is_coo_ind <> 'Y' Then
				idw_main.SetItem(1,"country_of_origin_default",'XX')
			End If
			
			If isnull(idw_Main.GetItemNumber(1,"owner_id")) Then
				Select Owner_id into :llOwner
				From Owner 
				Where Owner_type = 'S' and
						Owner_cd = :lsSupplier and
						Project_id = :gs_project
				Using SQLCA; 
	
				idw_main.SetItem(1,"Owner_id",llOwner)
				idw_Main.SetItem(1,"c_owner_name",g.of_get_owner_name(llowner))
			End If /*owner ID not already set*/
			
			idw_main.object.standard_of_measure[1]=g.is_std_mesure
			
		END IF
	END IF
ELSE
	MessageBox(is_title, "Please enter the SKU.", Exclamation!)
	idw_sku.SetFocus()
	idw_sku.SetColumn("sku")
END IF	

//// LTK 20120113 OTM additions - populate an original datawindow so OTM fields can be compared upon a save
//if idw_main.RowCount() > 0 then
//	idw_main.RowsCopy(1, idw_main.RowCount(), Primary!, idw_main_original, 1, Primary!)
//end if


//MEA - 3/13 - Moved to OTM nvo

//wf_set_otm_dims()	// LTK 20120427 OTM additions 


//Jxlim BRD #416 05/10/2012 Disabled SOM for Pandora
If gs_project ='PANDORA' Then
	idw_main.Modify("Standard_of_Measure.Protect=1")
	idw_main.Modify("Standard_of_Measure.RadioButtons.3D=No")
	idw_main.Modify("Standard_of_Measure.RadioButtons.Scale=Yes")
	//TimA Pandora #560
	idw_item_coo.Modify("country_of_origin.Protect=1")
	tab_main.tabpage_coo.cb_insert_coo.Enabled=False
	tab_main.tabpage_coo.cb_delete_coo.Enabled=False
	// LTK 20150716  Pandora #989
	idw_main.Modify("country_of_origin_default.Protect=1")
Else
	idw_main.Modify("Standard_of_Measure.Protect=0")
	//idw_main.Modify("Standard_of_Measure.Edit.Style.RadioButtons.3D=Yes")
	idw_main.Modify("Standard_of_Measure.RadioButtons.3D=Yes")
	idw_main.Modify("Standard_of_Measure.RadioButtons.Scale=No")
	//TimA Pandora #560
	idw_item_coo.Modify("country_of_origin.Protect=0")
	tab_main.tabpage_coo.cb_insert_coo.Enabled=True
	tab_main.tabpage_coo.cb_delete_coo.Enabled=True
End If

String lsReq
//GailM 01/02/2018 Error occurred during getitemstring.  
lsReq = idw_Main.GetItemString( 1, 'Mobile_Scan_Not_Req_Ind' )

//09/14 - PCONKL - default Mobile Scan to 'N' if not present...
If isnull( lsReq ) or lsReq = '' Then
	idw_Main.SetITem(1,'Mobile_Scan_Not_Req_Ind','N')
End If



end event

event ue_postopen;call super::ue_postopen;// 05/00 PCONKL - all open code moved to postOpen

DataWindowChild ldwc_grp1, ldwc_grp2,ldwc, ldwc2,ldwc_coo,dwc_child
// pvh 06/27/06
datawindowchild ldwc_cc_grp

String	lsFilter

//TimA 08/30/12 Pandora issue #471 customize the QA check radio buttons
String lsModify, lsDisplay, lsValue
Integer liRow
Datastore lds_lookuptable

Integer li_rowcount
lds_lookuptable = create datastore
lds_lookuptable.dataobject = 'd_lookup_table'
lds_lookuptable.settransobject(sqlca)
li_rowcount=lds_lookuptable.retrieve(gs_project,'QA')

iw_window  = This

tab_main.movetab(2,999) /*always move search to the end*/

// Storing into variables
idw_main = tab_main.tabpage_main.dw_main
idw_price = tab_main.tabpage_Price.dw_price
idw_reorder = tab_main.tabpage_reorder.dw_reorder_info /* 07/00 PCONKL*/
idw_replenish = tab_main.tabpage_reorder.dw_replenish /* 04/05 PCONKL*/
//Jxlim 11/09/2012 Replenishment tabs for Pandora BRD#464
If    Upper(gs_project) = "PANDORA" Then	
	 idw_replenish.dataobject = 'd_item_replenish_pandora'

// LTK 20150423  Pandora #971  Commented lines below out because window was slow to open.  Now retrieve the child owner datawindow upon the tabpage click.
//
//	//Madhu code- START
//	idw_replenish.GetChild("owner_cd", dwc_child)
//	dwc_child.SetTransObject(sqlca)
//	dwc_child.retrieve(gs_project)
//	idw_replenish.GetChild("owner_cd", dwc_child)
//	//Madhu code -END
	 idw_replenish.SetTransObject(SQLCA)
Else
	 idw_replenish.dataobject = 'd_item_replenish'
	 idw_replenish.SetTransObject(SQLCA)
End If
//idw_putaway_loc = tab_main.tabpage_reorder.dw_putaway_loc /* 08/02 PCONKL - */
idw_storage_Rule = tab_main.tabpage_reorder.dw_storage_rule
idw_search = tab_main.tabpage_search.dw_search
idw_component_parent = tab_main.tabpage_component.dw_component_parent /* 09/00 PCONKL*/
idw_component_child = tab_main.tabpage_component.dw_component_child /* 09/00 PCONKL*/
idw_packaging_parent = tab_main.tabpage_packaging.dw_packaging_parent /* 08/02 PCONKL*/
idw_packaging_child = tab_main.tabpage_packaging.dw_packaging_child /* 08/02 PCONKL*/
idw_item_coo = tab_main.tabpage_coo.dw_coo /* 02/21/13 TimA*/
idw_query = tab_main.tabpage_search.dw_query
idw_sku = tab_main.tabpage_main.dw_sku_supplier
idw_Sku_Substitutes =  tab_main.tabpage_sku_substitutes.dw_sku_substitutes /* 04/2010 ujhall*/
idw_main.SetTransObject(Sqlca)
idw_price.SetTransObject(Sqlca)
idw_search.SetTransObject(Sqlca)
idw_SKU_Substitutes.SetTransObject(Sqlca) /* 04/2010 ujhall*/

//tabpage_coo
//d_item_master_coo  dw_coo
idw_main.Getchild("grp", ldwc_grp1)
idw_query.Getchild("grp", ldwc_grp2)
ldwc_grp1.ShareData(ldwc_grp2)
ldwc_grp1.Settransobject(sqlca)
If ldwc_grp1.Retrieve() < 1 Then
	ldwc_grp1.InsertRow(0)
End If

// pvh - 06/27/06
idw_main.Getchild("cc_group_code", ldwc_cc_grp)
ldwc_cc_grp.Settransobject(sqlca)
If ldwc_cc_grp.Retrieve( gs_project  ) < 1 Then
	ldwc_cc_grp.InsertRow(0)
End If

// it's an instance cause we need to filter it when a group is selected
idw_main.Getchild("cc_class_code", idwc_cc_class)
idwc_cc_class.Settransobject(sqlca)
If idwc_cc_class.Retrieve( gs_project  ) < 1 Then
	idwc_cc_class.InsertRow(0)
End If

i_sql = idw_search.getsqlselect()
is_origSQL = idw_main.GetSQLSelect()

idw_sku.InsertRow(0)
idw_query.InsertRow(0)

//Disable Reorder tab until order entered
tab_main.tabpage_reorder.Enabled = False

// 04/05 - PCONKL - Loading from USer Warehouse Datastore 
idw_reorder.GetChild("wh_code",ldwc)
g.of_set_warehouse_dropdown(ldwc)

//idw_putaway_loc.GetChild("wh_code",ldwc)
g.of_set_warehouse_dropdown(ldwc)

idw_Replenish.GetChild("wh_code",ldwc)
g.of_set_warehouse_dropdown(ldwc)

// LTK 20150423  Pandora #971  Commented lines below out because window was slow to open.  Now retrieve the child owner datawindow upon the tabpage click.
//
////Jxlim 11/09/2012 Adding owner code BRD #464
//If upper(gs_project) = 'PANDORA' then	
//	idw_Replenish.GetChild("owner_cd",idwc_owner)	
//	idwc_owner.Settransobject(sqlca)	
//	//If idwc_owner.Retrieve() < 1 Then		//07-Jun-2013 :Madhu commented
//	If idwc_owner.Retrieve(gs_project) < 1 Then  //07-Jun-2013 :Madhu added
//		idwc_owner.InsertRow(0)
//	End If
//	isoriqsqldropdown_owner = idwc_owner.GetSqlSelect() /*get sql for Owner dropdown so we can modify for based on warehouse*/
//	
//End If

idw_Storage_Rule.GetChild("wh_code",ldwc)
g.of_set_warehouse_dropdown(ldwc)

//Filter Group by current Project
idw_main.GetChild("grp",ldwc)
lsFilter = "Upper(project_id) = '" + upper(gs_project) + "'"
ldwc.SetFilter(lsFilter)
ldwc.Filter()

idw_sku.GetChild("supp_code",ldwc)
isoriqsqldropdown = ldwc.GetSqlSelect() /*get sql for supplier dropdown so we can modify for sku/supplier*/
i_nwarehouse = Create n_warehouse

// 04/05 - Pconkl - If Forward Pick not enabled for Porjetc, don't show info on Tab
If Not g.ibforwardpickenabled Then
	idw_replenish.Visible = False
	tab_main.tabpage_reorder.st_fwd_pick.visible = False
	tab_main.tabpage_reorder.cb_replenish_insert.Visible = False
	tab_main.tabpage_reorder.cb_replenish_Delete.Visible = False
End If
	
//TimA 08/30/12 Pandora Issue #471
if upper(gs_project) = 'PANDORA' then	
	//TimA 12/13/12 Pandora issue #550 Limit the Counties to 2 characters
	idw_main.Modify("country_of_origin_default.edit.Limit='2'")
	idw_main.Modify("Alternate_Coo_default.edit.Limit='2'")	
	liRow = 1
	lsModify = "qa_check_ind.values = '"
	if li_rowcount > 0 then
		Do while liRow <= li_Rowcount
			lsDisplay = RightTrim(lds_lookuptable.Getitemstring( liRow, 'Code_ID'))
			lsValue = RightTrim(lds_lookuptable.Getitemstring( liRow, 'Code_Descript'))
			lsModify += lsDisplay + '~t' + lsValue
			If liRow < li_Rowcount then
				lsModify += '/'
			End if
			liRow ++
		loop
		lsModify += "'"
		idw_main.Modify(lsModify)
	End if
//	string lsTest
//	lstest = idw_main.describe( "qa_check_ind.values")
//	idw_main.Modify("qa_check_ind.values = 'None~tN/Danger~tM/Damaged~tD/Both~tB/Other~tO/PKG QA~tP '")

End if


// 05/06/2010 ujh:  1 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).
If gs_role = '1' or gs_role = '0' or gs_role = '-1' Then
	if upper(gs_Project) = 'PANDORA' then
		tab_main.tabpage_sku_substitutes.visible = true
		tab_main.tabpage_sku_substitutes.enabled = true
		//tab_main.tabpage_coo.visible = true		// LTK 20150716  Pandora #989
		//tab_main.tabpage_coo.enabled = true		
	else
		tab_main.tabpage_sku_substitutes.visible = false
		tab_main.tabpage_sku_substitutes.enabled =false
		tab_main.tabpage_coo.visible = false
		tab_main.tabpage_coo.enabled = false				
	end if
else
	tab_main.tabpage_sku_substitutes.visible = false
	tab_main.tabpage_sku_substitutes.enabled =false
	tab_main.tabpage_coo.visible = false
	tab_main.tabpage_coo.enabled = false					
end if
// 05/06/2010 ujh:  End 1 of 3 changes to allow SKU_Substitutes tab to ADMIN and above (PANDORA only).

//idw_main_original.dataobject = 'd_maintenance_itemmaster'	// LTK 201120113 	OTM addition - used for field comparison upon updates and inserts

	//TimA 02/22/13 Pandora issue #560  This is for the new COO tab
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.name='dddw_country_2char'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.displaycolumn='designating_code'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.datacolumn='designating_code'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.useasborder='yes'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.allowedit='no'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.vscrollbar='yes'
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.width="650"
	tab_main.tabpage_coo.dw_coo.object.Country_of_origin.dddw.percentwidth="200"         
	tab_main.tabpage_coo.dw_coo.GetChild("Country_of_origin", ldwc_coo)
	ldwc_coo.SetTransObject(SQLCA)
	ldwc_coo.retrieve()	
	 
//	LTK 20151028	If using the Hazardous Materials Table, set the Hazard_Cd field to be a DDDW
if g.ibUseHazardousTable then
	idw_main.object.hazard_cd.dddw.name='d_dddw_hazardous_materials'
	idw_main.object.hazard_cd.dddw.displaycolumn='identification_no'
	idw_main.object.hazard_cd.dddw.datacolumn='identification_no'
	idw_main.object.hazard_cd.dddw.useasborder='yes'
	idw_main.object.hazard_cd.dddw.allowedit='no'
	idw_main.object.hazard_cd.dddw.vscrollbar='yes'
	idw_main.object.hazard_cd.dddw.percentwidth="800" 
	idw_main.object.hazard_cd.dddw.vscrollbar='yes'
	idw_main.object.hazard_cd.dddw.hscrollbar='yes'
	idw_main.object.hazard_cd.dddw.lines=10
	
	// LTK 20151028  Share hazardous materials data cache with the DDDW
	g.uf_load_hazardous_materials( g.INCLUDE_EMPTY_ROW )
	idw_main.GetChild("Hazard_Cd", idwc_hazard_codes)
	g.ids_hazardous_materials.ShareData( idwc_hazard_codes )
end if

// Default into edit mode
This.TriggerEvent("ue_edit")

//OTM

//MEA - 3/13 - Added per OTM Specs
//In ue_PostOpen, create “n_otm” as an instance variable if g.is_OTM_Item_Master_Send_Ind is set to ‘Y’. 
//It is currently being instantiated as a local variable in ue_save but we will be using it in a couple of places.

if g.is_OTM_Item_Master_Send_Ind = 'Y' then

	in_otm = CREATE n_otm
	
	idw_main.object.otm_sent_ind.visible = true
	idw_main.object.otm_sent_ind_t.visible = true

	idw_search.object.otm_sent_ind.visible = true
	
else
	
	idw_search.object.otm_sent_ind.visible = false
	
end if

//SARUN2015NOV17 : On Double Click Calling Item Master
If UpperBound(Istrparms.String_arg) > 1 Then 

	If Istrparms.String_arg[1] = 'ITEMMASTER' Then /*DO_NO passed*/
			iw_window.PostEvent("ue_retrieve")
	End if
End If

end event

event close;call super::close;Destroy i_nwarehouse
end event

event open;call super::open;
tab_main.tabpage_reorder.uo_1.is_Text = "Maintain~r~nStorage~r~nRules"
tab_main.tabpage_reorder.uo_1.event ue_open()

ilHelpTopicID = 532 /*set help topic ID*/
end event

event ue_unlock;call super::ue_unlock;//Jxlim 05/10/2012 BRD #416 Lock and unLock Standard of measure, using F10 for access Level < 1
If gs_project = 'PANDORA' THEN
	//Allow F10 for Super Users to unlock all the fields
    //wf_lock(False)
	idw_main.Object.Standard_of_measure.Protect = False	
	idw_main.Modify("Standard_of_Measure.RadioButtons.3D=Yes")
	idw_main.Modify("Standard_of_Measure.RadioButtons.Scale=No")	
	//TimA Pandora #560
	idw_item_coo.Modify("country_of_origin.Protect=0")
	tab_main.tabpage_coo.cb_insert_coo.Enabled=True
	tab_main.tabpage_coo.cb_delete_coo.Enabled=True
	
	// LTK 20150716  Pandora #989
	idw_main.Modify("country_of_origin_default.Protect=0")

END IF


end event

event activate;call super::activate;gs_ActiveWindow ="IM" //25-May-2018 :Madhu S19730 - Assign Activate Window
end event

type tab_main from w_std_master_detail`tab_main within w_maintenance_itemmaster
integer x = 18
integer y = 16
integer width = 4242
integer height = 2752
integer textsize = -9
integer weight = 700
boolean fixedwidth = false
tabpage_price tabpage_price
tabpage_reorder tabpage_reorder
tabpage_component tabpage_component
tabpage_packaging tabpage_packaging
tabpage_sku_substitutes tabpage_sku_substitutes
tabpage_coo tabpage_coo
end type

on tab_main.create
this.tabpage_price=create tabpage_price
this.tabpage_reorder=create tabpage_reorder
this.tabpage_component=create tabpage_component
this.tabpage_packaging=create tabpage_packaging
this.tabpage_sku_substitutes=create tabpage_sku_substitutes
this.tabpage_coo=create tabpage_coo
call super::create
this.Control[]={this.tabpage_main,&
this.tabpage_search,&
this.tabpage_price,&
this.tabpage_reorder,&
this.tabpage_component,&
this.tabpage_packaging,&
this.tabpage_sku_substitutes,&
this.tabpage_coo}
end on

on tab_main.destroy
call super::destroy
destroy(this.tabpage_price)
destroy(this.tabpage_reorder)
destroy(this.tabpage_component)
destroy(this.tabpage_packaging)
destroy(this.tabpage_sku_substitutes)
destroy(this.tabpage_coo)
end on

event tab_main::selectionchanged;//For updating sort option
CHOOSE CASE newindex

	CASE 3
		// LTK 20150423  Pandora #971 - Moved code below from ue_postopen to here so that window will open more quickly

		//Jxlim 11/09/2012 Adding owner code BRD #464
		If upper(gs_project) = 'PANDORA' then	
			idw_Replenish.GetChild("owner_cd",idwc_owner)	
			idwc_owner.Settransobject(sqlca)	
			//If idwc_owner.Retrieve() < 1 Then		//07-Jun-2013 :Madhu commenteds

			// LTK 20140428  Pandora #971  Added project code to SQL here.  This DDDW is used in multiple places so changed it dynamically here.
			String ls_sql
			ls_sql =   "SELECT Customer.Project_ID, Customer.Cust_Code, Customer.Cust_Name   " 
			ls_sql += "FROM Customer  "
			ls_sql += "Where  Project_Id = '" + gs_project + "' AND (NOT Customer.Customer_Type = 'IN')  "
			ls_sql += "ORDER BY Customer.Project_ID ASC, Customer.Cust_Code ASC   "
			idwc_owner.SetSqlSelect( ls_sql )

			If idwc_owner.Retrieve(gs_project) < 1 Then  //07-Jun-2013 :Madhu added
				idwc_owner.InsertRow(0)
			End If
			isoriqsqldropdown_owner = idwc_owner.GetSqlSelect() /*get sql for Owner dropdown so we can modify for based on warehouse*/
		End If		

	CASE 7                                               //  04/15/2010 ujh:  this was 6, but Sku_Substitute was added, pushing search to 7
		wf_check_menu(TRUE,'sort')
		idw_current = idw_search
	Case Else		
		wf_check_menu(FALSE,'sort')
		idw_current =idw_search   //26-Mar-2014 :Madhu- Added to export Item Master records
END CHOOSE
end event

event tab_main::selectionchanging;call super::selectionchanging;
// TAM 2010/04/06  Don't need to validate when The window changes


//CHOOSE CASE oldindex
//	CASE 6    
//		
//////		lsSecond = tab_main.tabpage_sku_substitutes.dw_sku_substitutes.GetItemString(1,'sku_Primary')
////		 idw_Sku_Substitutes.SetItem(1,'SKU_Substitute', 'Should not see')
////		 tab_main.tabpage_sku_substitutes.dw_sku_substitutes.SetItem(1,'SKU_Substitute', 'Expect to see')
////		lstest =idw_Sku_Substitutes .GetItemString(1,'sku_Substitute')
////		messagebox('test', 'Selection is changing. oldindex = ' + string(oldindex) + ': new index = '+string(newindex)+ ': Sku_Substitute = ' + lstest)
//
//// TAM 2010/04/06  Don't need to validate when The window changes
////	return  tab_main.tabpage_sku_substitutes.dw_sku_substitutes.Event ue_validatelist(idw_Sku_Substitutes)
//	
//	
//End Choose

return 0
end event

type tabpage_main from w_std_master_detail`tabpage_main within tab_main
integer y = 108
integer width = 4206
integer height = 2628
string text = " Item Info"
dw_sku_supplier dw_sku_supplier
cb_item_master_owner cb_item_master_owner
dw_main dw_main
end type

on tabpage_main.create
this.dw_sku_supplier=create dw_sku_supplier
this.cb_item_master_owner=create cb_item_master_owner
this.dw_main=create dw_main
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sku_supplier
this.Control[iCurrent+2]=this.cb_item_master_owner
this.Control[iCurrent+3]=this.dw_main
end on

on tabpage_main.destroy
call super::destroy
destroy(this.dw_sku_supplier)
destroy(this.cb_item_master_owner)
destroy(this.dw_main)
end on

type tabpage_search from w_std_master_detail`tabpage_search within tab_main
integer y = 108
integer width = 4206
integer height = 2628
cb_item_master_search cb_item_master_search
cb_item_master_clear cb_item_master_clear
dw_query dw_query
dw_search dw_search
end type

on tabpage_search.create
this.cb_item_master_search=create cb_item_master_search
this.cb_item_master_clear=create cb_item_master_clear
this.dw_query=create dw_query
this.dw_search=create dw_search
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_item_master_search
this.Control[iCurrent+2]=this.cb_item_master_clear
this.Control[iCurrent+3]=this.dw_query
this.Control[iCurrent+4]=this.dw_search
end on

on tabpage_search.destroy
call super::destroy
destroy(this.cb_item_master_search)
destroy(this.cb_item_master_clear)
destroy(this.dw_query)
destroy(this.dw_search)
end on

type dw_sku_supplier from datawindow within tabpage_main
event process_enter pbm_dwnprocessenter
integer x = 9
integer y = 4
integer width = 3150
integer height = 100
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_itemmaster_sku_supplier"
boolean border = false
boolean livescroll = true
end type

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event itemchanged;String	lsSupplier,	&
			lsSku
Long		llCount,	&
			llOwner
Integer li_pos
					

Choose Case dwo.Name
		
	Case 'sku'
		//Jxlim 01/04/2011 Disallow single or double quote in the sku field.
		lssku = data
		lssku = Left(lssku, 1)	
		If lsSku = "'" or lsSku = '"' Then
			messagebox(is_title,"Single or double quote is not allowed in the SKU!")
			Return 1
		End If
		//Jxlim 01/04/2011 End of code
		
		If ib_edit = False Then /*always want to enter a supplier if new*/
			This.SetColumn("supp_code")
		Else
			iw_window.PostEvent("ue_retrieve")
		End If
		
	Case "supp_code"
		
		lsSupplier = data

		Select Count(*) into :llCount
		From supplier
		Where Supp_code = :lsSupplier and Project_id = :gs_project
		Using SQLCA;
		
		If not llCount > 0 Then
			messagebox(is_title,"Supplier Code not found!")
			Return 1
		End If
		
		// Supplier can be updated if initially set to 'XX'. If so, we dont want to trigger the retrieve event (updating the same record) */
		If not ibSupplierUpdate Then
			iw_window.PostEvent("ue_retrieve")
		Else /*assigning a new supplier where originally 'XX'*/
			
			//Warn about change!!
			If Messagebox(is_title,'Are you sure you want to update the supplier for this SKU?~r~rIf you do, you will lose the ability to track information by the old and new supplier.~rAll information will be transferred to the new supplier.~r~r(If you are trying to edit another record, Select "Edit" from the menu). ',Question!,yesNo!,2) = 2 Then 
				Return 1
			End If
			
			//Validate that if changing supplier, that sku/supplier doesn't already exist
			lsSku = idw_main.GetItemString(1,"sku")
			Select Count(*) into :llCount
			From Item_Master
			Where project_id = :gs_project and
					sku = :lsSku and
					supp_code = :data
			Using SQLCA;
			
			If llCount > 0 Then
				Messagebox(is_title,"This Sku/Supplier already exists!")
				Return 1
			End If
			
			//idw_main.SetItem(1,"supp_code",data) /*update main DW*/
			ibSupplierChanged = True /*stored procedure will create new item master with new supplier and delete this one*/
			ib_changed = True
		End If
		
End Choose
end event

event itemerror;Return 1
end event

event constructor;
g.of_check_label(this) 
end event

type cb_item_master_owner from commandbutton within tabpage_main
boolean visible = false
integer x = 3035
integer y = 424
integer width = 274
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Owner:"
end type

event clicked;iw_window.TriggerEvent("ue_select_owner")
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_main from u_dw_ancestor within tabpage_main
event ue_dddw ( )
integer y = 104
integer width = 4178
integer height = 2512
integer taborder = 20
string dataobject = "d_maintenance_itemmaster"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event ue_dddw();//Jxlim 01/14/2011  Set the following required fields for W&S			
				This.Modify("hs_code.dddw.Required=yes'")		
				This.Modify("grp.dddw.Required=yes'")		
				This.Modify("uom_1.dddw.Required=yes'")		
				This.Modify("uom_2.dddw.Required=yes'")						
				This.Modify("Country_of_origin_default.dddw.Required=yes'")						
				This.Modify("storage_code.dddw.Required=yes'")	
				This.Modify("user_field1.edit.Required=yes'")	
				This.Modify("user_field11.edit.Required=yes'")				
				This.Modify("qty_2.EditMask.Required=yes'")		

//Jxlim 01/17/2011 Create dddw dynamically for W&S
DatawindowChild	ldwc_coo, ldwc_hs_code, ldwc_storage_code, ldwc_uom_1, ldwc_uom_2
	//dddw for hs_code
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.name='dddw_hs_code'
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.displaycolumn='hs_code'
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.datacolumn='hs_code'
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.hs_code.width="650"
	 tab_main.tabpage_main.dw_main.object.hs_code.dddw.percentwidth="200"         
	 tab_main.tabpage_main.dw_main.GetChild("hs_code", ldwc_hs_code)
	 ldwc_hs_code.SetTransObject(SQLCA)	
	 ldwc_hs_code.Retrieve(gs_project)		
	
	//dddw for coo
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.name='dddw_country_2char'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.displaycolumn='designating_code'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.datacolumn='designating_code'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.width="650"
	 tab_main.tabpage_main.dw_main.object.Country_of_origin_default.dddw.percentwidth="200"         
	 tab_main.tabpage_main.dw_main.GetChild("Country_of_origin_default", ldwc_coo)
	 ldwc_coo.SetTransObject(SQLCA)
	 ldwc_coo.retrieve()		
	 	
	//dddw for storage code
	 tab_main.tabpage_main.dw_main.object.Storage_code.dddw.name='dddw_storage_type'
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.displaycolumn='Storage_Type_Cd'
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.datacolumn='Storage_Type_Cd'
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.storage_code.width="370"
	 tab_main.tabpage_main.dw_main.object.storage_code.dddw.percentwidth="500"         
	 tab_main.tabpage_main.dw_main.GetChild("storage_code", ldwc_storage_code)
	 ldwc_storage_code.SetTransObject(SQLCA)
	 ldwc_storage_code.Retrieve(gs_project)		
	  
	  //dddw for uom_1
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.name='dddw_lookup_uom'
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.displaycolumn='code_id'
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.datacolumn='code_id'
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.uom_1.width="200"
	 tab_main.tabpage_main.dw_main.object.uom_1.dddw.percentwidth="100"         
	 tab_main.tabpage_main.dw_main.GetChild("uom_1", ldwc_uom_1)
	 ldwc_uom_1.SetTransObject(SQLCA)
	 ldwc_uom_1.Retrieve(gs_project)
	 
	 //dddw for uom_2
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.name='dddw_lookup_uom'
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.displaycolumn='code_id'
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.datacolumn='code_id'
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.useasborder='yes'
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.allowedit='no'
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.vscrollbar='yes'
	 tab_main.tabpage_main.dw_main.object.uom_2.width="200"
	 tab_main.tabpage_main.dw_main.object.uom_2.dddw.percentwidth="100"         
	 tab_main.tabpage_main.dw_main.GetChild("uom_2", ldwc_uom_2)
	 ldwc_uom_2.SetTransObject(SQLCA)
	 ldwc_uom_2.Retrieve(gs_project)	
	 
//Jxlim 01/17/2011 End of code for W&S

end event

event constructor;call super::constructor;DatawindowChild	ldwc

//Hide Country of Origin if Not Tracking
If g.is_coo_ind <> 'Y' Then
	This.Modify("country_of_origin_default.visible=0 country_of_origin_default_t.visible=0")
End If

//01/06 - PCONKL - For GM Detroit, User Field 11 is a list of label choises, setup as a dropdown and populate
If gs_project = 'GM_MI_DAT' Then
	
	This.GetChild('user_field11_1',ldwc)
	ldwc.SetTransObject(SQLCA)
	ldwc.Retrieve(gs_project,'PTLBL')
	
End If

//Jxlim 01/17/2011 Create dddw dynamically
//Wine and Spirit is actually going to be multiple projects but all project will start with”WS-“  
//When you put in project specific logic you need to only reference the 1st thru 3rd fields instead of the whole project_id.  

is_project = Left(gs_project,3)

If is_project = 'WS-' Then	
   TriggerEvent("ue_dddw")
End If
//Jxlim 01/17/2011 end of code for W&S


// 11/13 - PCONKL - Hard codeed visibility to Pick cart status for Physio for now, customer 2 will get a project level indicator
If gs_project = 'PHYSIO-MAA' or gs_project = 'PHYSIO-XD' Then
Else
	This.Modify("pick_cart_status.visible=0 pick_cart_status_t.visible=0 gb_cart_status.visible=0")
End If

// 09/14 - PCONKL - Mobile fields only visible if project mobile Enabled
If not g.ibMobileEnabled Then
	This.Modify("mobile_Scan_Not_Req_Ind.visible=0")
End If
end event

event getfocus;call super::getfocus;
//sku and/or supplier may not be validated if a field has been clicked instead of tabbing
idw_sku.AcceptText()
end event

event itemchanged;ib_changed = True
nvo_country lnvo_country
string ls_codeexchange, ls_countrycode, ls_temp

// 02/07 - PCONKL - Set 'Interface_Upd_Req_Ind' to note record has changed for triggered update (batch_Transaction written in ue_save)
//							Sweeper will procee all records for project where indicator is set, not just record written in Transaction file
This.SetITem(1,'Interface_Upd_Req_Ind','Y')

long	llCount,	&
		llOwner, &
		llArrayCount, &
		ll_ContentSKU
		
String lsCOO, &
          lsSKU, &
          lsSUpplier, &
          ls_CompInd, &
          ls_SerialInd, &
          lsHazCd

DWItemStatus ldws_Status

lsSku = this.Object.sku[1] //25-May-2018 :Madhu - S19730 - get SKU

// 05/00 PCONKL - validate weight (user field2) for numerics
Choose case dwo.name
	// pvh - 06/27/06
	case 'cc_group_code'
		doFilterClassColumn( data )
	
	case 'cc_class_code'
		if isNull( this.object.cc_group_code[ getrow() ] ) then
			messagebox("Item Master Maintenance", "Please Select a CC Group First.",exclamation! )
			return 2
		end if
	
	
	// pvh - 03.10.06 - MARL

	case 'user_field6' // 3com MARL
		if gs_project = '3COM_NASH' then
			this.object.marl_change_date[ row ] = f_getLocalWorldTime( gs_default_wh )
		end if

	Case "user_field2"
		
		If not isnumber(data) Then
			Messagebox("Validation Error", "Unpackaged Weight must be numeric!")
			return 1
		End If
		
	//MEA - 06/2008	
			
	Case "country_of_origin_default" /*Validate COO*/
		
		// Create the country object
			lnvo_country = Create nvo_country
			
		// If this is a Pandora project,
		If gs_project = "PANDORA" then
		
			// Set ls_countrycode to the data value
			ls_countrycode = data
						
			// If the user typed a 3 char code,
			If len(data) = 3 then
				
				// If we can replace the 3 char code with the 2 char code.
				If lnvo_country.f_exchangecodes(ls_countrycode, ls_codeexchange) then
				
					// Set the 2 char code instead.
					Post setitem(row, dwo.name, ls_codeexchange)
					
				// Otherwise, if we can't exchange the codes,
				Else
					
					// Show Error.
					MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
					
					// Prevent the data from taking.
					return 1
					
				// End If
				End If
			End If
		End If
		
		//02/02 - PCONKL - we will now allow 2,3 char or 3 numeric COO and validate agianst Country Table
		If not lnvo_country.f_getnameforcode(data, lsCOO) Then
			MessageBox(is_title, "Invalid Country of Origin, please re-enter!")
			Return 1
		End If
		
		// Destroy the country object.
		Destroy lnvo_country

		
	Case "component_ind" /* 09/00 PCONKL */
		
		If data = 'Y' Then
			
			idw_component_parent.Visible = True
			tab_main.tabpage_component.st_component_parent.visible=True
			tab_main.tabpage_component.cb_add_component_parent.visible=True
			tab_main.tabpage_component.cb_delete_component_parent.visible=True
			
			This.SetItem(row,'component_Type','D') /* 08/04 - PCONKL Default component type to 'Delivery Order' */
			
			// 2/10/2011; David C; Do not allow user to set this item as a component master if item is being tracked at inbound for Pandora only
			if Upper ( gs_project ) = "PANDORA" then
				ls_SerialInd = this.Object.serialized_ind[1]
				
				if ls_SerialInd = "Y" then
					MessageBox ( is_title, "This SKU is serial number tracked at inbound. It cannot have component parts.", Exclamation! )
						
					Return 2
				end if
			end if
		Else /*Changing to No */
			
			// if changing to no, we will delete the existing component rows
			
			// 10/03 - PConkl - make sure we don't have any content for the parent - can't remove components if so, will fu*k everything up later
			lsSku = idw_Main.GetITemString(1,'sku')
			lsSupplier = idw_Main.GetITemString(1,'supp_code')
			
			Select Count(*) into :llCount
			FRom Content with(nolock)
			Where Project_id = :gs_Project and sku = :lsSKU and supp_code = :lsSupplier and Component_no > 0 and avail_qty > 0;
			
			If llCount > 0 Then /*Content exists, cant change to non-component*/
				Messagebox(is_title,"There is already component inventory for this item.~r~rYou can not change the Component Indicator until the inventory is gone!",Stopsign!)
				Return 2
			End If
			
			If idw_component_parent.RowCOunt() > 0 Then
				If Messagebox(is_title,"There is already component information for this item. If you uncheck the component box, this information will be detleted!~r~rAre you sure you want to continue?",question!,yesNo!,2) = 1 Then
					//delete the component Rows
					Do While idw_component_parent.RowCOunt() > 0
						idw_component_parent.DeleteRow(1)
					Loop
				Else /*dont delete*/
					Return 2
				End If
			End If /*rows exist*/
			
			//Make Invisible
			idw_component_parent.Visible = false
			tab_main.tabpage_component.st_component_parent.visible=false
			tab_main.tabpage_component.cb_add_component_parent.visible=false
			tab_main.tabpage_component.cb_delete_component_parent.visible=false
			
			This.SetItem(row,'component_Type','') /* 08/04 - PCONKL clear out component type */
			
		End If
	
   CASE 'standard_of_measure'			
			
		IF ib_dimentions THEN
			ib_dimentions = FALSE
			Messagebox(is_title,"Please Save the Data First")
			Return 2
		END IF	
	 		wf_convert(data) //dgm 031601
			 
   CASE 'length_1','length_2','length_3','length_4','width_1','width_2','width_3','width_4',&
		'weight_1','weight_2','weight_3','weight_4','height_1','height_2','height_3','height_4'
		
		ib_dimentions = True  
		
//		// 08/06 - PConkl - Make sure Length > Width > Height for first tier (Directed Putaway)
//		if dwo.name = 'length_1' Then
//			if Long(data) < This.GetITemNumber(row,'width_1') or Long(data) < This.GetITemNumber(row,'height_1') Then
//				Messagebox(is_title,"Length must be > Width > Height.")
//				Return 1
//			End If
//		ElseIf dwo.name = 'width_1' Then
//			if Long(data) > This.GetITemNumber(row,'Length_1') or Long(data) < This.GetITemNumber(row,'height_1') Then
//				Messagebox(is_title,"Length must be > Width > Height.")
//				Return 1
//			End If
//		ElseIf dwo.name = 'height_1' Then
//			if Long(data) > This.GetITemNumber(row,'Width_1') or Long(data) > This.GetITemNumber(row,'length_1') Then
//				Messagebox(is_title,"Length must be > Width > Height.")
//				Return 1
//			End If
//		End If
	
			
	case 'item_delete_ind'
		// 2010/07/07 - dts - don't let them set an item to inactive if there are pending put-away rows for the item in question
		lsSku = idw_Main.GetITemString(1,'sku')
		lsSupplier = idw_Main.GetITemString(1,'supp_code')
		
		Select Count(*) into :llCount
		from receive_master rm with(nolock) inner join receive_putaway rp with(nolock) on rm.ro_no = rp.ro_no
		where project_id = :gs_project
		and ord_status = 'P'
		and sku = :lsSKU and rp.supp_code = :lsSupplier; 

		If llCount > 0 Then /*Put-away pending - cant set to Inactive*/
			Messagebox(is_title, "There are pending put-away records for this SKU.~r~rYou can not set the SKU to Inactive!", Stopsign!)
			Return 2
		End If
		
	//Jxlim 01/13/2011 for W&S user_field1 only accept Numeric values
	Case "user_field1"
			If Left(gs_project,3) = 'WS-' Then		
				If Not isnumber(data) Then
					Messagebox(is_title, "Only Numeric values allowed!")
					return 1
				End If
			End If
	//Jxlim 01/13/2011 end of code for W&S user_field1
	
	case "serialized_ind"
		// 2/10/2011; David C; Do not allow the serialized indicator to be changed if inventory already exists for this SKU for Pandora only
		if Upper ( gs_project ) = "PANDORA" then
			ldws_Status = idw_main.GetItemStatus ( 1, 0, Primary! )
			
			// Don't bother performing this check if this is a brand new item
			if ldws_Status = NotModified! or ldws_Status = DataModified! then
				lsSku = this.Object.sku[1]
				
				 select count(Content_Summary.SKU)
				    into :ll_ContentSKU
				  from Content_Summary with(nolock)
				where Content_Summary.SKU = :lsSku
				 using SQLCA;
				
				// If we found inventory, warn the user
				if not IsNull ( ll_ContentSKU ) and ll_ContentSKU > 0 then
					MessageBox ( is_title, "Serialization cannot be changed because inventory already exists for this SKU.", Exclamation! )
					
					Return 2
				end if
			end if
			
			// Do not allow user to set inbound serialization if this item is a component master
			ls_CompInd = this.Object.component_ind[1]
			
			if data = "Y" and ls_CompInd = "Y" then
				MessageBox ( is_title, "This SKU is serial number tracked at inbound. It cannot have component parts.", Exclamation! )
				
				Return 2
			end if
		end if
		
	case 'pick_cart_status' /* 10/13 - PCONKL - DOn't allow to be set if level 1 DIMs or weight not populated*/
		
		if data = 'Y' or data = 'U' Then
			
			if	 isnull(this.getITemNumber(1,'length_1')) or this.getITemNumber(1,'length_1') = 0 or &
			 	isnull(this.getITemNumber(1,'width_1')) or this.getITemNumber(1,'width_1') = 0 or &
				 isnull(this.getITemNumber(1,'height_1')) or this.getITemNumber(1,'height_1') = 0  or &
				  isnull(this.getITemString(1,'uom_1')) or this.getITemString(1,'uom_1')=  ''  or & 
				  isnull(this.getITemNumber(1,'weight_1')) or this.getITemNumber(1,'weight_1') = 0 Then
				
					MessageBox ( is_title, "Cart Status Flag cannot be set to Yes or Ugly until Level 1 dimensions are set.", Exclamation! )
					return 1
					
			End If
			
		End If

	//25-May-2018 :Madhu - S19730 - Method Trace Log Entry - START
	case 'hazard_cd'
		
		if g.ibUseHazardousTable then
			long ll_child_row
			ll_child_row = idwc_hazard_codes.GetRow()
			if ll_child_row > 0 then
				this.Object.proper_shipping_name[ 1 ] = idwc_hazard_codes.GetItemString( ll_child_row, 'proper_shipping_name' )
				this.Object.hazard_cd_suffix[ 1 ] = idwc_hazard_codes.GetItemString( ll_child_row, 'hazard_cd_suffix' )
			end if
		end if
		
		ls_temp = idw_Main.getItemstring( 1, 'hazard_cd' ,Primary!, true)
		f_method_trace_special( gs_project, this.ClassName() + ' - Item Changed()', 'Changed Hazard Cd value From : '+ nz(ls_temp ,'-') +' to :' +nz(data, 'NONE') ,lsSku, ' ',' ',lsSku)
		
	case 'qa_check_ind'

		ls_temp = idw_Main.getItemstring( 1, 'qa_check_ind' ,Primary!, true)
		f_method_trace_special( gs_project, this.ClassName() + ' - Item Changed()', 'Changed QA Check Ind value From : '+nz(ls_temp ,'-') +' to :' +data ,lsSku, ' ',' ',lsSku)
		
	case 'hazard_text_cd'
		ls_temp = idw_Main.getItemstring( 1, 'hazard_text_cd' ,Primary!, true)
		f_method_trace_special( gs_project, this.ClassName() + ' - Item Changed()', 'Changed Hazard Text Cd value From : '+ nz(ls_temp ,'-') +' to :' +nz(data ,'-') ,lsSku, ' ',' ',lsSku)
		
	case 'hazard_class'
		ls_temp = idw_Main.getItemstring( 1, 'hazard_class' ,Primary!, true)
		f_method_trace_special( gs_project, this.ClassName() + ' - Item Changed()', 'Changed Hazard Class value From : '+ nz(ls_temp ,'-') +' to :' + nz(data, '-') ,lsSku, ' ',' ',lsSku)

	//25-May-2018 :Madhu - S19730 - Method Trace Log Entry - END
	
End Choose

end event

event itemerror;// 05/00 PCONKL - dont return datawindow error msg if we'vae already displayed a validation err or msg
Choose case dwo.name
		
	Case "user_field2" ,"country_of_origin_default"
		
		return 1		
		
	Case Else
		
		Return 2
		
End Choose
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event retrieveend;call super::retrieveend;// pvh - 06/27/06

// tired of the please supply a value for! message
if idw_main.rowcount() <= 0 then return
if IsNull( idw_main.object.qa_check_ind[ 1 ] ) or Trim( idw_main.object.qa_check_ind[ 1 ] ) = '' then
	idw_main.object.qa_check_ind[ 1 ]  = 'N'
end if

// 11/13 - PCONKL
if IsNull( idw_main.object.pick_cart_Status[ 1 ] ) or Trim( idw_main.object.pick_cart_Status[ 1 ] ) = '' then
	idw_main.object.pick_cart_Status[ 1 ]  = 'N'
end if

// eom


// pvh - 06/27/06
doFilterClassColumn( idw_main.object.cc_group_code[ 1 ] )

// Begin Dinesh- 11/23/2020 - S51444- PHILIPS-DA 
IF upper(gs_Project) = 'PHILIPSCLS' or upper(gs_Project) = 'PHILIPS-DA' THEN
idw_main.object.allow_receipt.visible = 1
else
idw_main.object.allow_receipt.visible = 0
END IF
// End Dinesh- 11/23/2020 - S51444- PHILIPS-DA


end event

event sqlpreview;call super::sqlpreview;//if request = PreviewFunctionUpdate!	then
//	messagebox( "SQL Preview","sql...~r~n" + sqlsyntax	)
//end if
//
end event

type cb_item_master_search from commandbutton within tabpage_search
integer x = 3090
integer y = 20
integer width = 297
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
string ls_sku,ls_descript,lsAltSku,ls_uf2,ls_uf3,ls_uf4,ls_uf5, ls_grp
string ls_where,ls_sql 
Boolean lb_where
dw_search.reset()
lb_where = False

If dw_query.accepttext() = -1 Then Return

ls_sku = dw_query.getitemstring(1,"sku")
ls_descript = dw_query.getitemstring(1,"descript")
ls_grp = dw_query.getitemstring(1,"grp")
lsAltSku = dw_query.getitemstring(1,"alternate_sku")
ls_uf2 = dw_query.getitemstring(1,"user_field2")
ls_uf3 = dw_query.getitemstring(1,"user_field3")
ls_uf4 = dw_query.getitemstring(1,"user_field4")
ls_uf5 = dw_query.getitemstring(1,"user_field5")


ls_where = "Where item_master.project_id = '" + gs_project + "' "  

if  not isnull(ls_sku) then
	ls_where += " and item_master.sku like '" + ls_sku + "%' "
	lb_where = True
end if

if not isnull(ls_descript) then
	ls_where += " and item_master.description like '%" + ls_descript + "%' "
	lb_where = True
end if

if not isnull(ls_grp) then
	ls_where += " and item_master.grp = '" + ls_grp + "' "
	lb_where = True
end if

// 07/00 PCONKL - using alternate sku field in DB now
if not isnull(lsAltSku) then
	ls_where += " and item_master.alternate_sku = '" + lsAltSku + "' "
	lb_where = True
end if


if not isnull(ls_uf2) then
	ls_where += " and item_master.user_field2 = '" + ls_uf2 + "'  "
	lb_where = True
end if

if not isnull(ls_uf3) then
	ls_where += " and item_master.user_field3 = '" + ls_uf3 + "'  "
	lb_where = True
end if

if not isnull(ls_uf4) then
	ls_where += " and item_master.supp_code = '" + ls_uf4 + "'  "
	lb_where = True
end if

if not isnull(ls_uf5) then
	ls_where += " and item_master.user_field5 = '" + ls_uf5 + "'  "
	lb_where = True
end if

ls_sql = i_sql + ls_where
dw_search.setsqlselect(ls_sql)

//DGM For giving warning for all no search criteria
if not lb_where then
	  IF i_nwarehouse.of_msg(is_title,1) = 2 THEN Return
END IF

if dw_search.retrieve() = 0 then
	messagebox(is_title,"No records found!")
end if
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_item_master_clear from commandbutton within tabpage_search
integer x = 3090
integer y = 132
integer width = 297
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

event clicked;dw_search.Reset()
dw_query.Reset()
dw_query.InsertRow(0)
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_query from u_dw_ancestor within tabpage_search
integer y = 12
integer width = 3067
integer height = 284
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_itemmaster_inquire"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;//overide
//This.SetTransObject(Sqlca)
g.of_check_label(this) 

This.Modify('warehouse.visible=0 warehouse_t.visible=0')


end event

type dw_search from u_dw_ancestor within tabpage_search
integer x = 5
integer y = 256
integer width = 3904
integer height = 1676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_maintenance_itemmaster_search"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		idw_sku.SetItem(1,"sku",This.GetItemString(row,"sku"))
		idw_sku.SetItem(1,"supp_code",This.GetItemString(row,"supp_code"))
		iw_window.TriggerEvent("ue_retrieve")
	END IF
END IF

end event

type tabpage_price from userobject within tab_main
event create ( )
event destroy ( )
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "Prices/Cust Alt SKUs"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_delete_cust_alt_sku cb_delete_cust_alt_sku
cb_insert_cust_alt_sku cb_insert_cust_alt_sku
st_customer_alternate_skus st_customer_alternate_skus
dw_cust_sku dw_cust_sku
st_prices st_prices
cb_delete_price cb_delete_price
cb_insert_price cb_insert_price
dw_price dw_price
end type

on tabpage_price.create
this.cb_delete_cust_alt_sku=create cb_delete_cust_alt_sku
this.cb_insert_cust_alt_sku=create cb_insert_cust_alt_sku
this.st_customer_alternate_skus=create st_customer_alternate_skus
this.dw_cust_sku=create dw_cust_sku
this.st_prices=create st_prices
this.cb_delete_price=create cb_delete_price
this.cb_insert_price=create cb_insert_price
this.dw_price=create dw_price
this.Control[]={this.cb_delete_cust_alt_sku,&
this.cb_insert_cust_alt_sku,&
this.st_customer_alternate_skus,&
this.dw_cust_sku,&
this.st_prices,&
this.cb_delete_price,&
this.cb_insert_price,&
this.dw_price}
end on

on tabpage_price.destroy
destroy(this.cb_delete_cust_alt_sku)
destroy(this.cb_insert_cust_alt_sku)
destroy(this.st_customer_alternate_skus)
destroy(this.dw_cust_sku)
destroy(this.st_prices)
destroy(this.cb_delete_price)
destroy(this.cb_insert_price)
destroy(this.dw_price)
end on

type cb_delete_cust_alt_sku from commandbutton within tabpage_price
integer x = 3621
integer y = 1380
integer width = 270
integer height = 92
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;tab_main.Tabpage_Price.dw_cust_sku.triggerEvent('ue_Delete')
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_insert_cust_alt_sku from commandbutton within tabpage_price
integer x = 3621
integer y = 1228
integer width = 270
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;
tab_main.Tabpage_Price.dw_cust_sku.triggerEvent('ue_Insert')
end event

event constructor;
g.of_check_label_button(this)
end event

type st_customer_alternate_skus from statictext within tabpage_price
integer x = 1248
integer y = 700
integer width = 910
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Customer Alternate SKUs"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type dw_cust_sku from u_dw_ancestor within tabpage_price
integer x = 247
integer y = 796
integer width = 3035
integer height = 948
integer taborder = 20
string dataobject = "d_itemmaster_cust_alt_sku"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Long	llCount

ib_changed = True

//Validate Cust Code
If dwo.name = 'cust_code' Then
	
	Select Count(*) Into :llCount
	from Customer
	Where Project_ID = :gs_Project and cust_Code = :data;
	
	If llCount <= 0 Then
		Messagebox(is_Title,'Invalid Customer Code!')
		Return 1
	End If
	
	//See if this cust has already been entered
	If This.Find("Upper(Cust_Code) = '" + data + "'",1,This.RowCOunt()) > 0 Then
		Messagebox(is_Title,'An Alternate SKU has already been entered for this Customer Code!')
		Return 1
	End If
	
	//Set last update
	This.SetITem(row,'last_user',gs_userid)
	This.SetITem(row,'last_update',Today())
	
End If
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event ue_insert;call super::ue_insert;
Long ll_row

This.SetFocus()

If This.AcceptText() = -1 Then Return

ll_row = This.GetRow()

If ll_row > 0 Then
	This.setcolumn('cust_code')
	ll_row = This.InsertRow(ll_row + 1)
	This.ScrollToRow(ll_row)
Else
	ll_row = This.InsertRow(0)
End If	

This.setitem(ll_row, "project_id", gs_project)
This.SetItem(ll_row, "Primary_sku", idw_main.GetItemString(1, "sku"))
This.SetItem(ll_row, "Primary_supp_code", idw_main.GetItemString(1, "supp_code")) /* 09/00 PCONKL*/


end event

event ue_delete;call super::ue_delete;Long ll_crow

ll_crow = This.GetRow()

If ll_crow > 0 Then
	ib_changed = True
	This.DeleteRow(0)
End If
end event

event itemerror;call super::itemerror;Return 2

end event

type st_prices from statictext within tabpage_price
integer x = 1458
integer y = 12
integer width = 402
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Prices"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_price from commandbutton within tabpage_price
integer x = 3621
integer y = 380
integer width = 270
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;Long ll_crow

ll_crow = idw_price.GetRow()

If ll_crow > 0 Then
	ib_changed = True
	idw_price.DeleteRow(0)
End If
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_insert_price from commandbutton within tabpage_price
integer x = 3621
integer y = 224
integer width = 270
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;Long ll_row

idw_price.SetFocus()

If idw_price.AcceptText() = -1 Then Return

ll_row = idw_price.GetRow()

If ll_row > 0 Then
	idw_price.setcolumn('price_class')
	ll_row = idw_price.InsertRow(ll_row + 1)
	idw_price.ScrollToRow(ll_row)
Else
	ll_row = idw_price.InsertRow(0)
End If	

idw_price.setitem(ll_row, "project_id", gs_project)
idw_price.SetItem(ll_row, "sku", idw_main.GetItemString(1, "sku"))
idw_price.SetItem(ll_row, "supp_code", idw_main.GetItemString(1, "supp_code")) /* 09/00 PCONKL*/


end event

event constructor;
g.of_check_label_button(this)
end event

type dw_price from u_dw_ancestor within tabpage_price
integer y = 108
integer width = 3566
integer height = 532
boolean bringtotop = true
string dataobject = "d_maintenance_itemmaster_price"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;ib_changed = True
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

type tabpage_reorder from userobject within tab_main
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "Replen/Reorder/Putaway"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_1 uo_1
dw_storage_rule dw_storage_rule
cb_replenish_delete cb_replenish_delete
cb_replenish_insert cb_replenish_insert
st_fwd_pick st_fwd_pick
dw_replenish dw_replenish
st_im_replen_double_click_on_owner st_im_replen_double_click_on_owner
st_putaway_storage_rules st_putaway_storage_rules
st_supplier_reorder_information st_supplier_reorder_information
dw_reorder_info dw_reorder_info
cb_reorder_insert cb_reorder_insert
cb_reorder_delete cb_reorder_delete
end type

on tabpage_reorder.create
this.uo_1=create uo_1
this.dw_storage_rule=create dw_storage_rule
this.cb_replenish_delete=create cb_replenish_delete
this.cb_replenish_insert=create cb_replenish_insert
this.st_fwd_pick=create st_fwd_pick
this.dw_replenish=create dw_replenish
this.st_im_replen_double_click_on_owner=create st_im_replen_double_click_on_owner
this.st_putaway_storage_rules=create st_putaway_storage_rules
this.st_supplier_reorder_information=create st_supplier_reorder_information
this.dw_reorder_info=create dw_reorder_info
this.cb_reorder_insert=create cb_reorder_insert
this.cb_reorder_delete=create cb_reorder_delete
this.Control[]={this.uo_1,&
this.dw_storage_rule,&
this.cb_replenish_delete,&
this.cb_replenish_insert,&
this.st_fwd_pick,&
this.dw_replenish,&
this.st_im_replen_double_click_on_owner,&
this.st_putaway_storage_rules,&
this.st_supplier_reorder_information,&
this.dw_reorder_info,&
this.cb_reorder_insert,&
this.cb_reorder_delete}
end on

on tabpage_reorder.destroy
destroy(this.uo_1)
destroy(this.dw_storage_rule)
destroy(this.cb_replenish_delete)
destroy(this.cb_replenish_insert)
destroy(this.st_fwd_pick)
destroy(this.dw_replenish)
destroy(this.st_im_replen_double_click_on_owner)
destroy(this.st_putaway_storage_rules)
destroy(this.st_supplier_reorder_information)
destroy(this.dw_reorder_info)
destroy(this.cb_reorder_insert)
destroy(this.cb_reorder_delete)
end on

type uo_1 from u_textbtn within tabpage_reorder
integer x = 3803
integer y = 636
integer width = 306
integer height = 220
integer taborder = 40
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor;g.of_check_label_button(this)
end event

event clicked;call super::clicked;Str_parms	lstrParms

If f_check_access ("CODE_TB","") = 1 Then
	Lstrparms.String_arg[1] = ""
	OpenSheetwithparm(w_maintenance_storage_rule, lstrparms, w_main, gi_menu_pos, Original!)
End If
end event

on uo_1.destroy
call u_textbtn::destroy
end on

type dw_storage_rule from u_dw_ancestor within tabpage_reorder
event ue_delete_empty ( )
integer x = 5
integer y = 652
integer width = 3771
integer height = 608
integer taborder = 20
string dataobject = "d_item_storage_rule"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_delete_empty();
//Delete any empty rows...

Long	llRowCount, llRowPos

llRowCount = This.RowCount()
For llRowPOs = llRowCount to 1 step - 1
	
	If This.GetITemString(llRowPos,'dedicated_location') = "" or isnull(This.GetITemString(llRowPos,'dedicated_location')) Then
		This.DeleteRow(llRowPos)
	End If
	
Next
end event

event ue_retrieve;call super::ue_retrieve;Long llRowPos
//Retrieve existing record(s) and add blank rows for other warehouses if present (so we don't need insert/delete buttons)

This.Retrieve(idw_main.getItemstring(1,'project_id'), idw_main.getItemstring(1,'SKU'), idw_main.getItemstring(1,'supp_code'))



For llRowPos = 1 to g.ids_project_warehouse.rowCount()
	
	If this.Find("wh_code = '" + g.ids_project_warehouse.getItemString(llRowPos,'wh_code') + "'",1, this.rowCount()) = 0 Then
		This.InsertRow(0)
		This.SetItem(this.RowCount(),'wh_code',g.ids_project_warehouse.getItemString(llRowPos,'wh_code'))
		This.SetItem(this.RowCount(),'project_id',gs_project)
		This.SetItem(this.RowCount(),'sku',idw_main.getITemString(1,'sku'))
		This.SetItem(this.RowCount(),'supp_code',idw_main.getITemString(1,'supp_code'))
		THis.SetItemStatus(this.RowCount(),0,Primary!,NotModified!)
	End If
	
Next
end event

event itemchanged;call super::itemchanged;Long	llCount, llNull
String	lsWarehouse

Choose Case Upper(dwo.name)
		
	Case "DEDICATED_LOCATION"

		If data > "" Then
					
				lsWarehouse = This.GetITemString(row,'wh_code')
				
				Select Count(*) into :llCount 
				from Location
				Where  wh_Code = :lsWarehouse and l_code = :data;
			
				If llCount < 1 Then
					MessageBox(is_title, "Invalid Location, please re-enter!")
					Return 1
				End If
			
		Else
			
			setNull(llNull)
			This.SetItem(row, 'qty_for_location',llNull)
			This.SetItem(row, 'storage_type_cd','')
			This.SetItem(row, 'equipment_type_cd','')
			This.SetItem(row, 'storage_rule_cd','')
			
		End If
			
		// 02/06 - PCONKL - FOR GM, we want to keep in sync with Fwd Pick rec and Location Sku Reserved
		ilDedLocRow = row /*will ake sure cursor is reset back to this DW after FWD Pick row is added */
		if gs_project = 'GM_MI_DAT' Then post uf_gm_fwd_pick (row)
		
	Case "EQUIPMENT_TYPE_CD"
		
		if data = '- None - ' Then This.SetITem(row,'equipment_type_cd','')
		
End Choose

ib_changed = True
end event

event itemerror;call super::itemerror;Return 2
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
	Return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('storage_type_cd',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
if ldwc.rowCount() = 0 Then ldwc.InsertRow(0)



This.GetChild('equipment_type_cd',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
if ldwc.rowCount() = 0 Then ldwc.InsertRow(0)

This.GetChild('storage_rule_cd',ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.Retrieve(gs_Project)
if ldwc.rowCount() = 0 Then ldwc.InsertRow(0)
end event

event clicked;call super::clicked;dataWindowChild	ldwc			

//Storage Rule dropdown needs to be filtered by Warehouse
If dwo.name = 'storage_rule_cd' Then
	This.GetChild('storage_rule_cd',ldwc)
	ldwc.SetFilter("Upper(wh_code) = '" + Upper(This.GetITemString(row,'wh_code')) + "' or wh_code = ''")
	ldwc.Filter()
End IF
end event

type cb_replenish_delete from commandbutton within tabpage_reorder
integer x = 3794
integer y = 284
integer width = 265
integer height = 84
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_replenish.triggerEvent("ue_delete")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_replenish_insert from commandbutton within tabpage_reorder
integer x = 3794
integer y = 160
integer width = 265
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;dw_replenish.triggerEvent("ue_insert")
end event

event constructor;
g.of_check_label_button(this)
end event

type st_fwd_pick from statictext within tabpage_reorder
integer x = 5
integer y = 12
integer width = 2921
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Forward Pick Replenishment Information"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_replenish from u_dw_ancestor within tabpage_reorder
event ue_delete_empty ( )
integer x = 5
integer y = 92
integer width = 3771
integer height = 368
integer taborder = 20
string dataobject = "d_item_replenish"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_delete_empty();
//Delete any empty rows...

Long	llRowCount, llRowPos

llRowCount = This.RowCount()
For llRowPOs = llRowCount to 1 step - 1
	
	If This.GetITemString(llRowPos,'l_code') = "" or isnull(This.GetITemString(llRowPos,'l_code')) Then
		This.DeleteRow(llRowPos)
	End If
	
Next
end event

event constructor;call super::constructor;This.SetRowFocusIndicator(Hand!)
end event

event process_enter;call super::process_enter;//Dont tab out of DW when hitting enter

//If THis.GetColumnName() = "reorder_qty" Then
//	Return
//Else
	Send(Handle(This),256,9,Long(0,0))
	Return 1
//End If
end event

event ue_insert;call super::ue_insert;String lsOwner
Long	llNewRow, llOwner_Id

llNewRow = This.InsertRow(0)

This.Setfocus()
This.SetRow(llNewRow)
This.ScrollToRow(llNewRow)

This.SetItem(llNewRow,"project_id",idw_main.GetItemString(1,"project_id"))
This.SetItem(llNewRow,"sku",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supp_code",idw_main.GetItemString(1,"supp_code")) /* 09/00 PCONKL*/

This.SetItem(llNewRow,"wh_code",gs_default_wh)

//JXLIM 11/18/2012 Item_Forward_Pick.Owner_id
If Upper(gs_project) = 'PANDORA' then					
	This.SetItem(llNewRow,"Owner_cd",lsOwner)
	lsOwner = This.GetItemString(1,"Owner_cd")
	Select Owner_Id Into : llOwner_Id
	From Owner
	Where Owner_cd = :lsOwner
	USING SQLCA;

	This.SetItem(llNewRow,"Owner_Id",llOwner_Id) /* Jxlim 11/18/2012 Pandora BRD #464*/
End If

This.SetColumn("l_code")

end event

event ue_delete;call super::ue_delete;String	lsWarehouse, lsLoc, lsSKU
Long	llArrayCount

If This.getRow() <=0 Then Return

lsSKU = idw_main.GetITemString(1,'SKU')
lsWarehouse = This.GetITemstring(This.getRow(),'wh_code')
lsLoc = This.GetITemstring(This.getRow(),'l_code')

If Messagebox(is_title,"Are you sure you want to delete the current REPLENISHMENT row?",Question!,YesNo!,2) = 1 Then
	This.DeleteRow(This.GetRow())
	ib_changed = True
End If

//When we save the record, we will want to execute a SQL to update the warehouse master - don't do it here 
//in case they don't save
llArrayCount = UpperBound(isUpdateSql)
llArrayCount ++
isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '' where wh_code = '" + &
												lsWarehouse + "' and l_code = '" + lsLoc + "' and sku_reserved = '" + lsSKU + "';"
end event

event itemchanged;call super::itemchanged;String	lsWarehouse, lsLoc, lsSKU, lsReserved, lsType,lsfilter, lsOwner
Long	llCount, llArrayCount, llOwner_Id

Choose Case Upper(dwo.Name)
		
	Case 'L_CODE' /* must be a valid location and must be reserved for this sku*/
		
		lsWarehouse = This.GetITemString(row,'wh_code')
		lsLoc = data
		lsSKU = idw_main.getITemString(1,'SKU')
		
		Select  sku_reserved, l_type 
		into  :lsReserved, :lsType
		From Location
		Where wh_Code = :lsWarehouse and l_code = :lsLoc;
		
		If lsType = '' or isnull(lsType) Then /*no location returned*/
			Messagebox(is_Title, 'Invalid Location!~r~rPlease check Warehouse/location Maintenance.',Stopsign!)
			Return 1
		Elseif lsReserved > '' Then /*sku reserved, make sure it is reserved for this sku*/
			If lsREserved <> lsSKU Then
				Messagebox(is_Title, 'This location is already reserved for SKU ' + lsReserved + '!~r~rPlease check Warehouse/location Maintenance.',Stopsign!)
				Return 1
			End If
		End If
		
		//When we save the record, we will want to execute a SQL to update the warehouse master - don't do it here 
		//in case they don't save
		
		//Clear Old
		If Not isnull(This.GetITemString(row,'l_code')) and This.GetITemString(row,'l_code') > '' Then
			llArrayCount = UpperBound(isUpdateSql)
			llArrayCount ++
			isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '', l_type = 'Y' where wh_code = '" + &
												lsWarehouse + "' and l_code = '" + This.GetITemString(row,'l_code') + "';"
		End If
		
		//Set New
		llArrayCount = UpperBound(isUpdateSql)
		llArrayCount ++
		isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '" + lsSKU + "', l_type = 'Y' where wh_code = '" + &
												lsWarehouse + "' and l_code = '" + lsLoc + "';"
		
		/* Jxlim 11/18/2012 Pandora BRD #464*/			
		Case 'OWNER_CD'
			If Upper(gs_project) = 'PANDORA' then	
				lsOwner = Data			
				Select Owner_Id Into :llOwner_Id
				From Owner
				Where Owner_cd = :lsOwner
				USING SQLCA;
							
				This.SetItem(Row,"Owner_Id",llOwner_id)    /* Jxlim 11/18/2012 Pandora BRD #464*/
			End If
End Choose

ib_changed = True
This.SetITem(row,'Last_user', gs_userid)
This.SetItem(row, 'Last_Update',DateTime(Today(),Now()))
end event

event itemerror;call super::itemerror;
Return 2
end event

event clicked;call super::clicked;//Jxlim 11/18/2012 Pandora BRD#464 - Populate OWNER code dropdown based on selected warehouse
String	lsselect, lssort,	lswarehouse, lsWhere, lsnewsql			
Long li_find_wherepos, li_find_sortpos

Choose Case Upper(dwo.Name)
	Case "OWNER_CD" /* load available Owner if dropdown clicked on*/
		If gs_project = 'PANDORA' Then	
				//Populate OWNER code dropdown based on selected warehouse
				This.GetChild("Owner_cd",idwc_owner)		
				idwc_owner.SetTransObject(SQLCA)
				
				lswarehouse = This.GetITemString(row,'wh_code')    //Get wh_code
				If lswarehouse > ' ' Then
						//modify SQL to include warehouse in WHERE Clause				 
						lsWhere += "and Project_id = '" + gs_project + "'"	 //Always tackon project				
						
						lsNewsql = isoriqsqldropdown_owner //Original owner dropdown sql						
						lsSelect = lsNewSQL
						//Removed Order by from query to form a new select statement up to the end of where
						li_find_wherepos = Pos(lsNewsql , "ORDER BY") - 1	
						If li_find_wherepos > 0 then 				
							lsNewsql = left(lsNewsql, li_find_wherepos)	
							lsNewsql = left(lsNewsql, li_find_wherepos)	
							
							//Strip out Order by for itself in order to add it to the end of the query.				
							li_find_sortpos = Pos(lsSelect, "ORDER BY")
							lssort = Mid(lsSelect, li_find_sortpos)				
						End if
						
						//Modify SQL to include warehouse in WHERE Clause  //Populate OWNER code dropdown based on selected warehouse
						lsWhere += " and user_field2 = '" + lswarehouse + "'"
						lsNewsql +=  lsWhere +'~r' + lsSort
						
						idwc_owner.setsqlselect(lsNewsql)
						idwc_owner.Retrieve()						
				End If
		End If		
End Choose

end event

event losefocus;call super::losefocus;accepttext()
end event

type st_im_replen_double_click_on_owner from statictext within tabpage_reorder
integer x = 361
integer y = 1844
integer width = 978
integer height = 64
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Small Fonts"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click on Owner field to select owner"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;g.of_check_label_button(this)
end event

type st_putaway_storage_rules from statictext within tabpage_reorder
integer y = 564
integer width = 2921
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Putaway Storage Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_supplier_reorder_information from statictext within tabpage_reorder
integer x = 41
integer y = 1372
integer width = 2921
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Supplier Reorder Information"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_reorder_info from u_dw_ancestor within tabpage_reorder
integer x = 5
integer y = 1468
integer width = 3287
integer height = 372
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_item_reorder_info"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;String	lsFind
Long llFind

ib_changed = True

////Check for Duplicate Warehouse/Owner records
//lsFind = "wh_code = '" + data + "'"
//llFind = This.Find(lsFind,1,THis.RowCount())
//If llFind > 0 And llFind <> row  Then
//	Messagebox(is_title,"This Warehouse has already been entered!")
//	Return 1
//End If

end event

event ue_insert;Long	llNewRow

llNewRow = This.InsertRow(0)

This.Setfocus()
This.SetRow(llNewRow)
This.ScrollToRow(llNewRow)

This.SetItem(llNewRow,"project_id",idw_main.GetItemString(1,"project_id"))
This.SetItem(llNewRow,"sku",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supp_code",idw_main.GetItemString(1,"supp_code")) /* 09/00 PCONKL*/
This.SetItem(llNewRow,"pono", "-")  // ET3 2012-05-30

This.SetItem(llNewRow,"wh_code",gs_default_wh)
This.SetColumn("max_supply_onhand")

end event

event itemerror;Return 2
end event

event ue_delete;
If This.getRow() <=0 Then Return

If Messagebox(is_title,"Are you sure you want to delete the current REORDER row?",Question!,YesNo!,2) = 1 Then
	This.DeleteRow(This.GetRow())
	ib_changed = True
End If
end event

event process_enter;//Dont tab out of DW when hitting enter

If THis.GetColumnName() = "reorder_qty" Then
	Return
Else
	Send(Handle(This),256,9,Long(0,0))
	Return 1
End If
end event

event constructor;call super::constructor;
This.SetRowFocusIndicator(Hand!)
// show column only if PANDORA
if gs_project = 'PANDORA' then
	this.Modify("PONO.Visible=TRUE")
	this.Modify("PONO_t.Visible=TRUE")
end if

end event

event doubleclicked;call super::doubleclicked;str_parms	lstrparms

Choose Case upper(dwo.name)
		
	Case 'CF_OWNER_NAME'

		Open(w_select_owner)
		lstrparms = Message.PowerObjectParm
		If Not lstrparms.Cancelled and UpperBound(lstrparms.Long_arg) > 0 Then
			This.SetItem(Row,"owner_id",Lstrparms.Long_arg[1])
			This.SetItem(Row,"owner_owner_cd",Lstrparms.String_arg[2])
			This.SetItem(Row,"owner_owner_type",Lstrparms.String_arg[3])
			ib_changed = True
		End if
		
End Choose
end event

type cb_reorder_insert from commandbutton within tabpage_reorder
integer x = 3346
integer y = 1556
integer width = 265
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Insert"
end type

event clicked;dw_reorder_info.triggerEvent("ue_insert")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_reorder_delete from commandbutton within tabpage_reorder
integer x = 3346
integer y = 1692
integer width = 265
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;dw_reorder_info.TriggerEvent("ue_delete")
end event

event constructor;
g.of_check_label_button(this)
end event

type tabpage_component from userobject within tab_main
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "Component"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_im_comp_dbl_click_a_row_to_maintain st_im_comp_dbl_click_a_row_to_maintain
dw_component_parent dw_component_parent
st_component_parent st_component_parent
st_item_made_up_of_following_comp st_item_made_up_of_following_comp
dw_component_child dw_component_child
cb_add_component_parent cb_add_component_parent
cb_delete_component_parent cb_delete_component_parent
end type

on tabpage_component.create
this.st_im_comp_dbl_click_a_row_to_maintain=create st_im_comp_dbl_click_a_row_to_maintain
this.dw_component_parent=create dw_component_parent
this.st_component_parent=create st_component_parent
this.st_item_made_up_of_following_comp=create st_item_made_up_of_following_comp
this.dw_component_child=create dw_component_child
this.cb_add_component_parent=create cb_add_component_parent
this.cb_delete_component_parent=create cb_delete_component_parent
this.Control[]={this.st_im_comp_dbl_click_a_row_to_maintain,&
this.dw_component_parent,&
this.st_component_parent,&
this.st_item_made_up_of_following_comp,&
this.dw_component_child,&
this.cb_add_component_parent,&
this.cb_delete_component_parent}
end on

on tabpage_component.destroy
destroy(this.st_im_comp_dbl_click_a_row_to_maintain)
destroy(this.dw_component_parent)
destroy(this.st_component_parent)
destroy(this.st_item_made_up_of_following_comp)
destroy(this.dw_component_child)
destroy(this.cb_add_component_parent)
destroy(this.cb_delete_component_parent)
end on

type st_im_comp_dbl_click_a_row_to_maintain from statictext within tabpage_component
integer x = 1833
integer y = 1764
integer width = 1394
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click a row to maintain the Component Master"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_component_parent from u_dw_ancestor within tabpage_component
integer x = 9
integer y = 140
integer width = 1765
integer height = 1564
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_item_component_parent"
boolean minbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_insert;Long	llNewRow

llNewRow = This.InsertRow(0)

This.SetItem(llNewRow,"project_id",gs_project)
This.SetItem(llNewRow,"sku_parent",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supp_code_parent",idw_main.GetItemString(1,"supp_code"))
This.SetItem(llNewRow,'last_update',Today()) 
This.SetItem(llnewRow,'last_user',gs_userid)	
This.SetItem(llNewRow,'component_type',"C")  /* 08/02 - Pconkl - default to component (as apposed to Packaging */
This.SetFocus()
This.SetRow(llNewRow)
This.SetColumn("sku_child")

end event

event itemchanged;Long		llCount
String	lsSupplier,	&
			lsSKU,		&
			lsDDSQL
			
DatawindowChild	ldwc

ib_changed = True

Choose Case dwo.name
		
	Case "sku_child" /*validate*/
				
		//Child SKU can not be the same as the Parent SKU
		If data = idw_main.GetItemString(1,"sku") Then
			Messagebox(is_title,"This Sku can not be the same as the component SKU!")
			Return 1
		End If
		
		//Check for Dups
		
		// 09/00 - Do a count for project/sku. If > 1 than supplier is required
		Select Count(*) into :llCount
		From Item_MAster
		Where project_id = :gs_Project and
				Sku = :data
		Using SQLCA;
			
	Choose Case llCount
			
		Case 0 /*not found*/
			MessageBox(is_title,"SKU Not found. Please Re-enter!")
			Return 1
		Case 1 /*only 1 suppplier for SKU */
						
			//Populate Supplier dropdown for SKU - 
			This.GetChild("supp_code_child",ldwc)
			ldwc.SetTransObject(SQLCA)
			//Modify sql to replace dummy values with project and sku
			lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
			lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
			ldwc.SetSqlSelect(lsDDSQL)
			ldwc.Retrieve()
			This.SetItem(row,"supp_code_child",ldwc.GetITemString(1,'Item_MAster_supp_code'))
			This.SetColumn("child_qty")
			
		Case Else /*multiple rows, Must enter Supplier*/
			//Populate Supplier dropdown for SKU - 
				This.GetChild("supp_code_child",ldwc)
				ldwc.SetTransObject(SQLCA)
				//Modify sql to replace dummy values with project and sku
				lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
				lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
				ldwc.SetSqlSelect(lsDDSQL)
				ldwc.Retrieve()
				This.SetColumn("supp_code_child")
	End Choose
		
End Choose
end event

event process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event itemerror;
Choose case dwo.name
		
	Case "sku_child", "supp_code_child"
		return 1
	Case Else
		Return 2
End Choose
end event

event ue_delete;
If This.getRow() > 0 Then
	If messagebox(is_title,"Are you sure you want do delete this row?",Question!,YesNo!,2) = 1 Then
		This.DeleteRow(This.GetRow())
		ib_changed = True
	End If
End If
end event

event clicked;call super::clicked;String	lsDDSQL,	&
			lsSKU
			
DatawindowChild	ldwc

Choose Case Upper(dwo.Name)
	Case "SUPP_CODE_CHILD" /* 09/02 - PCONKL - load available suppliers if dropdown clicked on*/
		//Populate Supplier dropdown for SKU - 
		This.GetChild("supp_code_child",ldwc)
		ldwc.SetTransObject(SQLCA)
		lsSKU = This.GetITemString(row,'sku_child')
		//Modify sql to replace dummy values with project and sku
		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,lsSKU)
		ldwc.SetSqlSelect(lsDDSQL)
		ldwc.Retrieve()
End Choose
end event

type st_component_parent from statictext within tabpage_component
integer x = 32
integer width = 1129
integer height = 144
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "This Item is a Component which is made up of the following SKUs:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_item_made_up_of_following_comp from statictext within tabpage_component
integer x = 1906
integer y = 68
integer width = 1358
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "This item is part of the following Components:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_component_child from u_dw_ancestor within tabpage_component
integer x = 1824
integer y = 140
integer width = 1595
integer height = 1564
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_item_component_child"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event doubleclicked;call super::doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		idw_sku.SetItem(1,"sku",This.GetItemString(row,"sku_parent"))
		idw_sku.SetItem(1,"supp_code",This.GetItemString(row,"supp_code_parent"))
		iw_window.TriggerEvent("ue_retrieve")
	END IF
END IF
end event

type cb_add_component_parent from commandbutton within tabpage_component
integer x = 443
integer y = 1744
integer width = 393
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;dw_component_parent.TriggerEvent("ue_insert")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_component_parent from commandbutton within tabpage_component
integer x = 919
integer y = 1744
integer width = 393
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_component_parent.TriggerEvent("ue_Delete")
end event

event constructor;
g.of_check_label_button(this)
end event

type tabpage_packaging from userobject within tab_main
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "Packaging"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_double_click_row_to_maintain st_double_click_row_to_maintain
cb_delete_packaging cb_delete_packaging
cb_add_packaging cb_add_packaging
st_item_is_pack_material_used_to st_item_is_pack_material_used_to
st_packing_materials_for_item st_packing_materials_for_item
dw_packaging_child dw_packaging_child
dw_packaging_parent dw_packaging_parent
end type

on tabpage_packaging.create
this.st_double_click_row_to_maintain=create st_double_click_row_to_maintain
this.cb_delete_packaging=create cb_delete_packaging
this.cb_add_packaging=create cb_add_packaging
this.st_item_is_pack_material_used_to=create st_item_is_pack_material_used_to
this.st_packing_materials_for_item=create st_packing_materials_for_item
this.dw_packaging_child=create dw_packaging_child
this.dw_packaging_parent=create dw_packaging_parent
this.Control[]={this.st_double_click_row_to_maintain,&
this.cb_delete_packaging,&
this.cb_add_packaging,&
this.st_item_is_pack_material_used_to,&
this.st_packing_materials_for_item,&
this.dw_packaging_child,&
this.dw_packaging_parent}
end on

on tabpage_packaging.destroy
destroy(this.st_double_click_row_to_maintain)
destroy(this.cb_delete_packaging)
destroy(this.cb_add_packaging)
destroy(this.st_item_is_pack_material_used_to)
destroy(this.st_packing_materials_for_item)
destroy(this.dw_packaging_child)
destroy(this.dw_packaging_parent)
end on

type st_double_click_row_to_maintain from statictext within tabpage_packaging
integer x = 1778
integer y = 1572
integer width = 1394
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Double click a row to maintain the Packaging Master"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_packaging from commandbutton within tabpage_packaging
integer x = 709
integer y = 1612
integer width = 256
integer height = 108
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_packaging_parent.TriggerEvent("ue_delete")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_add_packaging from commandbutton within tabpage_packaging
integer x = 343
integer y = 1612
integer width = 256
integer height = 108
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;
dw_packaging_parent.TriggerEvent("ue_insert")
end event

event constructor;
g.of_check_label_button(this)
end event

type st_item_is_pack_material_used_to from statictext within tabpage_packaging
integer x = 1879
integer y = 28
integer width = 1390
integer height = 124
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "This Item is packaging material used to package the following parts:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_packing_materials_for_item from statictext within tabpage_packaging
integer x = 14
integer y = 60
integer width = 1202
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "The Packaging materials for this Item are:"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_packaging_child from u_dw_ancestor within tabpage_packaging
integer x = 1870
integer y = 148
integer width = 1504
integer height = 1408
integer taborder = 20
string dataobject = "d_item_component_child"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;// Pasting the record to the main entry datawindow
IF Row > 0 THEN
	iw_window.TriggerEvent("ue_edit")
	IF NOT ib_changed THEN
		idw_sku.SetItem(1,"sku",This.GetItemString(row,"sku_parent"))
		idw_sku.SetItem(1,"supp_code",This.GetItemString(row,"supp_code_parent"))
		iw_window.TriggerEvent("ue_retrieve")
	END IF
END IF
end event

type dw_packaging_parent from u_dw_ancestor within tabpage_packaging
integer x = 5
integer y = 148
integer width = 1829
integer height = 1408
integer taborder = 20
string dataobject = "d_item_component_parent"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_insert;call super::ue_insert;
Long	llNewRow

llNewRow = This.InsertRow(0)

This.SetItem(llNewRow,"project_id",gs_project)
This.SetItem(llNewRow,"sku_parent",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supp_code_parent",idw_main.GetItemString(1,"supp_code"))
This.SetItem(llNewRow,'last_update',Today()) 
This.SetItem(llnewRow,'last_user',gs_userid)	
This.SetItem(llNewRow,'component_type',"P")  /* 08/02 - Pconkl - default to packing (as apposed to Compoent) */
This.SetFocus()
This.SetRow(llNewRow)
This.SetColumn("sku_child")

end event

event ue_delete;call super::ue_delete;
If This.getRow() > 0 Then
	If messagebox(is_title,"Are you sure you want do delete this row?",Question!,YesNo!,2) = 1 Then
		This.DeleteRow(This.GetRow())
		ib_changed = True
	End If
End If
end event

event itemchanged;call super::itemchanged;Long		llCount
String	lsSupplier,	&
			lsSKU,		&
			lsDDSQL,		&
			lsOrigSQL
			
DatawindowChild	ldwc

ib_changed = True

Choose Case dwo.name
		
	Case "sku_child" /*validate*/
				
		//Child SKU can not be the same as the Parent SKU
		If data = idw_main.GetItemString(1,"sku") Then
			Messagebox(is_title,"This Sku can not be the same as the Packaging SKU!")
			Return 1
		End If
		
		//Check for Dups
		
		// 09/00 - Do a count for project/sku. If > 1 than supplier is required
		Select Count(*) into :llCount
		From Item_MAster
		Where project_id = :gs_Project and
				Sku = :data
		Using SQLCA;
			
	Choose Case llCount
			
		Case 0 /*not found*/
			
			MessageBox(is_title,"SKU Not found. Please Re-enter!")
			Return 1
			
		Case 1 /*only 1 suppplier for SKU */

			//Populate Supplier dropdown for SKU - 
			This.GetChild("supp_code_child",ldwc)
			ldwc.SetTransObject(SQLCA)
			//Modify sql to replace dummy values with project and sku
			lsOrigSql = isoriqsqldropdown
			lsDDSQl = Replace(lsOrigSql,pos(lsOrigSql,'xxxxxxxxxx'),10,gs_project)
			lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
			ldwc.SetSqlSelect(lsDDSQL)
			ldwc.Retrieve()
			This.SetItem(row,"supp_code_child",ldwc.GetITemString(1,'Item_MAster_supp_code'))
			This.SetColumn("child_qty")
			
		Case Else /*multiple rows, Must enter Supplier*/
			
			//Populate Supplier dropdown for SKU - 
			This.GetChild("supp_code_child",ldwc)
			ldwc.SetTransObject(SQLCA)
			//Modify sql to replace dummy values with project and sku
			lsOrigSql = isoriqsqldropdown
			lsDDSQl = Replace(lsOrigSql,pos(lsOrigSql,'xxxxxxxxxx'),10,gs_project)
			lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
			ldwc.SetSqlSelect(lsDDSQL)
			ldwc.Retrieve()
			This.SetColumn("supp_code_child")
				
	End Choose
		
End Choose
end event

event itemerror;call super::itemerror;
Choose case dwo.name
		
	Case "sku_child", "supp_code_child"
		return 1
	Case Else
		Return 2
End Choose
end event

event process_enter;call super::process_enter;Send(Handle(This),256,9,Long(0,0))
Return 1

end event

event clicked;call super::clicked;String	lsDDSQL,	&
			lsSKU
			
DatawindowChild	ldwc

Choose Case Upper(dwo.Name)
	Case "SUPP_CODE_CHILD" /* 09/02 - PCONKL - load available suppliers if dropdown clicked on*/
		//Populate Supplier dropdown for SKU - 
		This.GetChild("supp_code_child",ldwc)
		ldwc.SetTransObject(SQLCA)
		lsSKU = This.GetITemString(row,'sku_child')
		//Modify sql to replace dummy values with project and sku
		lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
		lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,lsSKU)
		ldwc.SetSqlSelect(lsDDSQL)
		ldwc.Retrieve()
End Choose
end event

type tabpage_sku_substitutes from userobject within tab_main
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "SKU Substitutes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_delete_component_sku_substitutes cb_delete_component_sku_substitutes
cb_add_component_sku_substitutes cb_add_component_sku_substitutes
dw_sku_substitutes dw_sku_substitutes
end type

on tabpage_sku_substitutes.create
this.cb_delete_component_sku_substitutes=create cb_delete_component_sku_substitutes
this.cb_add_component_sku_substitutes=create cb_add_component_sku_substitutes
this.dw_sku_substitutes=create dw_sku_substitutes
this.Control[]={this.cb_delete_component_sku_substitutes,&
this.cb_add_component_sku_substitutes,&
this.dw_sku_substitutes}
end on

on tabpage_sku_substitutes.destroy
destroy(this.cb_delete_component_sku_substitutes)
destroy(this.cb_add_component_sku_substitutes)
destroy(this.dw_sku_substitutes)
end on

type cb_delete_component_sku_substitutes from commandbutton within tabpage_sku_substitutes
integer x = 1129
integer y = 1604
integer width = 256
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_SKU_Substitutes.TriggerEvent("ue_Delete")
end event

type cb_add_component_sku_substitutes from commandbutton within tabpage_sku_substitutes
integer x = 731
integer y = 1604
integer width = 256
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;dw_SKU_Substitutes.TriggerEvent("ue_insert")
end event

type dw_sku_substitutes from datawindow within tabpage_sku_substitutes
event ue_insert ( )
event ue_delete ( )
event type integer ue_validateitem ( string insku,  string insupp_code,  string field_name )
event type integer ue_validatelist ( datawindow adw_sku_substitutes )
integer x = 27
integer y = 64
integer width = 2597
integer height = 1344
integer taborder = 50
string title = "none"
string dataobject = "d_item_sku_substitutes"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_insert();Long	llNewRow

llNewRow = This.InsertRow(0)

This.SetItem(llNewRow,"project_id",gs_project)
This.SetItem(llNewRow,"sku_primary",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supplier_primary",idw_main.GetItemString(1,"supp_code"))

This.SetItem(llNewRow,'last_update',Today()) 
This.SetItem(llnewRow,'last_user',gs_userid)	

This.SetFocus()
This.SetRow(llNewRow)

//sku_primary.Taborder = 10
//sku_supplier_primary = 0

This.SetColumn("sku_primary")


end event

event ue_delete();

If This.getRow() > 0 Then
	If messagebox(is_title,"Are you sure you want do delete this row?",Question!,YesNo!,2) = 1 Then
		This.DeleteRow(This.GetRow())
		ib_changed = True
	End If
End If
end event

event type integer ue_validateitem(string insku, string insupp_code, string field_name);long llCount


			Select Count(*) into :llCount
			From Item_MAster
			Where project_id = :gs_Project 
					and Sku = :inSKU
					and supp_code =  :inSupp_Code
			Using SQLCA;
			If llCount > 0 then
				Return 0
			Else
				Messagebox(is_title,field_name+ " combo not in database")
				Return 1
			end if
end event

event type integer ue_validatelist(datawindow adw_sku_substitutes);


long ll_EmptyCount
integer k

adw_Sku_Substitutes.acceptText()

// make sure all fields are populated
For k = 1 to adw_Sku_Substitutes.RowCount()
	if not len(Getitemstring(k,'Sku_primary'))   > 0 or  isNull(len(Getitemstring(k,'Sku_primary')))  then
		ll_EmptyCount = ll_emptycount + 1
	end if
		if not len(Getitemstring(k,'Supplier_primary'))   > 0 or  isNull(len(Getitemstring(k,'Supplier_primary')))  then
		ll_EmptyCount = ll_emptycount + 1
	end if
	if not len(Getitemstring(k,'Sku_Substitute'))   > 0 or  isNull(len(Getitemstring(k,'Sku_Substitute')))  then
		ll_EmptyCount = ll_emptycount + 1
	end if
		if not len(Getitemstring(k,'Supplier_Substitute'))   > 0 or  isNull(len(Getitemstring(k,'Supplier_Substitute')))  then
		ll_EmptyCount = ll_emptycount + 1
	end if
next

if ll_EmptyCount > 0 then
	messagebox('SKU_Substitutes Data Input Error', 'Please fill in missing data. Count = ' + string(ll_EmptyCount))	
	return 1
else
	return 0
end if
end event

event itemchanged;

//String	lsSKU_primary,	&
//			lsSKU_substitute,		&
//			lsSupplier_Primary,  &
//			lsSupplier_Substitute
//			
//long llCount
//
//ib_changed = True
//
//lsSKU_primary = this.Getitemstring(row,'sku_primary')  
//lsSupplier_primary = this.Getitemstring(row,'supplier_primary')
//lsSKU_substitute = this.Getitemstring(row,'sku_substitute')   
//lsSupplier_substitute = this.Getitemstring(row,'supplier_substitute')
//
//
//
//Choose Case dwo.name
//		
//	Case "sku_primary" /*validate*/
//		if len(data) > 0 and len(lsSupplier_primary) > 0 then
//			return  this.Event ue_ValidateItem(data, lsSupplier_primary, 'sku_primary/Supplier_Primary') 
//			 
//		end if
//			
//	Case "supplier_primary" /*validate*/
//		if len(lsSKU_primary) > 0 and len(data) > 0 then
//			 return this.Event  ue_validateitem(lsSKU_primary, data,'sku_primary/Supplier_Primary')
//		end if
//		
//			Case "sku_substitute" /*validate*/
//		if len(data) > 0 and len(lsSupplier_Substitute) > 0 then
//			return this.Event ue_ValidateItem(data, lsSupplier_Substitute, 'sku_substitute/supplier_substitute') 
//		end if
//		
//			Case "supplier_substitute" /*validate*/
//		if len(lsSKU_Substitute) > 0 and len(data) > 0 then
//			return this.Event  ue_validateitem(lsSKU_Substitute, data, 'sku_substitute/supplier_substitute')
//		end if
//End Choose

Long		llCount
String	lsSupplier,	&
			lsSKU,		&
			lsDDSQL
			
DatawindowChild	ldwc

ib_changed = True

Choose Case dwo.name
		
	Case "sku_substitute" /*validate*/
				
		//Check for Dups
		
		// 09/00 - Do a count for project/sku. If > 1 than supplier is required
		Select Count(*) into :llCount
		From Item_MAster
		Where project_id = :gs_Project and
				Sku = :data
		Using SQLCA;
			
	Choose Case llCount
			
		Case 0 /*not found*/
			MessageBox(is_title,"SKU Not found. Please Re-enter!")
			Return 1
		Case 1 /*only 1 suppplier for SKU */
						
			//Populate Supplier dropdown for SKU - 
			This.GetChild("supplier_substitute",ldwc)
			ldwc.SetTransObject(SQLCA)
			//Modify sql to replace dummy values with project and sku
			lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
			lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
			ldwc.SetSqlSelect(lsDDSQL)
			ldwc.Retrieve()
			This.SetItem(row,"supplier_substitute",ldwc.GetITemString(1,'Item_MAster_supp_code'))
			
		Case Else /*multiple rows, Must enter Supplier*/
			//Populate Supplier dropdown for SKU - 
				This.GetChild("supplier_substitute",ldwc)
				ldwc.SetTransObject(SQLCA)
				//Modify sql to replace dummy values with project and sku
				lsDDSQl = Replace(isoriqsqldropdown,pos(isoriqsqldropdown,'xxxxxxxxxx'),10,gs_project)
				lsDDSQl = Replace(lsDDSQL,pos(lsDDSQL,'zzzzzzzzzz'),10,data)
				ldwc.SetSqlSelect(lsDDSQL)
				ldwc.Retrieve()
				This.SetColumn("supplier_substitute")
	End Choose
		
End Choose		
end event

event getfocus;//TAM 2010 Don't need to insert every time.  They will use the insert button
//if this.rowcount() = 0 then
//	this.TriggerEvent("ue_insert")
//	This.SetColumn("sku_substitute")
//
//end if
end event

type tabpage_coo from userobject within tab_main
event create ( )
event destroy ( )
boolean visible = false
integer x = 18
integer y = 108
integer width = 4206
integer height = 2628
long backcolor = 79741120
string text = "COO"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_delete_coo cb_delete_coo
cb_insert_coo cb_insert_coo
dw_coo dw_coo
end type

on tabpage_coo.create
this.cb_delete_coo=create cb_delete_coo
this.cb_insert_coo=create cb_insert_coo
this.dw_coo=create dw_coo
this.Control[]={this.cb_delete_coo,&
this.cb_insert_coo,&
this.dw_coo}
end on

on tabpage_coo.destroy
destroy(this.cb_delete_coo)
destroy(this.cb_insert_coo)
destroy(this.dw_coo)
end on

type cb_delete_coo from commandbutton within tabpage_coo
integer x = 2587
integer y = 236
integer width = 265
integer height = 84
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;dw_coo.triggerEvent("ue_delete")
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_insert_coo from commandbutton within tabpage_coo
integer x = 2587
integer y = 112
integer width = 265
integer height = 84
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insert"
end type

event clicked;dw_coo.triggerEvent("ue_insert")

end event

event constructor;g.of_check_label_button(this)


end event

type dw_coo from u_dw_ancestor within tabpage_coo
integer x = 137
integer y = 112
integer width = 2359
integer height = 896
integer taborder = 30
string dataobject = "d_item_master_coo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;
This.SetRowFocusIndicator(Hand!)
end event

event itemerror;call super::itemerror;
Return 2
end event

event losefocus;call super::losefocus;accepttext()
end event

event process_enter;call super::process_enter;//Dont tab out of DW when hitting enter

//If THis.GetColumnName() = "reorder_qty" Then
//	Return
//Else
	//Send(Handle(This),256,9,Long(0,0))
	//Return 1
//End If
end event

event ue_insert;call super::ue_insert;String lsOwner
Long	llNewRow, llOwner_Id

llNewRow = This.InsertRow(0)

This.Setfocus()
This.SetRow(llNewRow)
This.ScrollToRow(llNewRow)

This.SetItem(llNewRow,"project_id",idw_main.GetItemString(1,"project_id"))
This.SetItem(llNewRow,"sku",idw_main.GetItemString(1,"sku"))
This.SetItem(llNewRow,"supp_code",idw_main.GetItemString(1,"supp_code")) 

//This.SetItem(llNewRow,"wh_code",gs_default_wh)

//JXLIM 11/18/2012 Item_Forward_Pick.Owner_id
//If Upper(gs_project) = 'PANDORA' then					
//	This.SetItem(llNewRow,"Owner_cd",lsOwner)
//	lsOwner = This.GetItemString(1,"Owner_cd")
//	Select Owner_Id Into : llOwner_Id
//	From Owner
//	Where Owner_cd = :lsOwner
//	USING SQLCA;
//
//	This.SetItem(llNewRow,"Owner_Id",llOwner_Id) /* Jxlim 11/18/2012 Pandora BRD #464*/
//End If

This.SetColumn("country_of_origin")

end event

event ue_delete;call super::ue_delete;String	lsWarehouse, lsLoc, lsSKU
Long	llArrayCount

If This.getRow() <=0 Then Return

lsSKU = idw_main.GetITemString(1,'SKU')
//lsWarehouse = This.GetITemstring(This.getRow(),'wh_code')
//lsLoc = This.GetITemstring(This.getRow(),'l_code')

If Messagebox(is_title,"Are you sure you want to delete the current COO row?",Question!,YesNo!,2) = 1 Then
	This.DeleteRow(This.GetRow())
	ib_changed = True
End If

//When we save the record, we will want to execute a SQL to update the warehouse master - don't do it here 
//in case they don't save
//llArrayCount = UpperBound(isUpdateSql)
//llArrayCount ++
//isUpdateSql[llArrayCount] = "Update Location Set sku_reserved = '' where wh_code = '" + &
//												lsWarehouse + "' and l_code = '" + lsLoc + "' and sku_reserved = '" + lsSKU + "';"
end event

