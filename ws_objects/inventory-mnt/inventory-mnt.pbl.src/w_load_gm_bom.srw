$PBExportHeader$w_load_gm_bom.srw
$PBExportComments$Load GM BOm info scraped from IMS system
forward
global type w_load_gm_bom from w_response_ancestor
end type
type dw_bom from datawindow within w_load_gm_bom
end type
type st_1 from statictext within w_load_gm_bom
end type
type st_2 from statictext within w_load_gm_bom
end type
type cb_1 from commandbutton within w_load_gm_bom
end type
end forward

global type w_load_gm_bom from w_response_ancestor
integer width = 3433
integer height = 1676
string title = "Verfiy BOM"
event ue_print ( )
dw_bom dw_bom
st_1 st_1
st_2 st_2
cb_1 cb_1
end type
global w_load_gm_bom w_load_gm_bom

forward prototypes
public function string wf_format_group (string asgroup)
public function integer wf_update_ro_contract ()
protected function integer wf_update_bom ()
end prototypes

event ue_print();
OpenWithParm(w_dw_print_options,dw_bom) 
end event

public function string wf_format_group (string asgroup);
String	lsGroup

// "Three digit group numbers will have one leading zero (i.e. 0.659). All other Group numbers will have
//  No leading zeros (i.e.1.266, 10.373" From the GM standards manual

lsGroup = asGroup

//First, make sure there is a period - If not, there should be 3 digits after...
If POs(lsGroup,'.') = 0 Then
	lsGroup = Left(lsGroup,(len(lsGroup) - 3)) + "." + Right(lsGroup,3)
End IF

Choose Case Len(lsGroup) /*len includes period*/
		
	Case 4 /*needs a leading zero for 3 digit groups*/
		
		lsGroup = "0" + lsGroup
		
	Case 6 /*drop any leading zeros*/
		
		If left(lsGroup,1) = '0' Then lsGroup = Right(lsGroup,5)
				
End Choose

Return lsGroup
end function

public function integer wf_update_ro_contract ();String	lsSKU, lsSupplierContract, lsMenloContract, lsContract, lsCOO
Long	llRowPos, llRowCount, llFindRow

llRowCount = dw_bom.RowCount()
For llRowpOs = 1 to llRowCount
	
	lsSKU = dw_bom.getITemString(llRowPos, 'parent_sku')
	lsSupplierContract = dw_bom.getITemString(llRowPos, 'supplier_Contract')
	lsMenloContract = dw_bom.getITemString(llRowPos, 'Menlo_Contract')
	
	//validate COO returned from IMS
	lsCOO = dw_bom.getITemString(llRowPos, 'COO')
	If f_get_country_name(lsCOO) = "" Then
		lsCOO = 'XXX'
	End If
	
	If lsSupplierContract > "" Then
		lsContract = "S = '" + lsSupplierContract + "' "
	End If
	
	If lsMEnloContract > "" THen
		
		If lsContract > "" Then
			lsContract += ", M = " + lsMEnloContract
		Else
			lsContract = "M = " + lsMEnloContract
		End If
		
	End IF
	
	If lsContract > "" Then
		
		llFindRow = w_ro.idw_detail.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",1, w_ro.idw_detail.rowcount())
		Do While llFindRow > 0
			
			w_ro.idw_detail.SetITem(llFindRow,'User_Field3', lsContract)
			
			If lsCOO > "" and lsCOO <> 'XXX' Then
				w_ro.idw_detail.SetITem(llFindRow,'Country_of_Origin', lsCoo)
			End If
			
			llFindRow ++
			If llFindRow > w_ro.idw_detail.rowcount() Then
				llFindRow = 0
			Else
				llFindRow = w_ro.idw_detail.Find("Upper(Sku) = '" + Upper(lsSKU) + "'",llFindRow, w_ro.idw_detail.rowcount())
			End If
			
		Loop
			
	End If
	
Next /* Detail Row */

w_ro.ib_changed = True

Return 0
end function

protected function integer wf_update_bom ();String lsParentSKU, lsParentSKUSave, lsChildSku, lsDesc, lsSpanishDesc, lsFrenchDesc,	lsPackageType, &
			lsItemGroup, lsACDPart, lsErrText, lsChildSupplier, lsParentSupplier, lsUPC, lsACDPLC, lsCOO, lsNewITems
			
Long	llRowCount, llRowPos, llUPC, llChildQty, llMerchQty, llFindRow, llDefaultOwner

DateTime ldtToday

ldtToday = DateTime(today(),now())
lsNewITems = ""

SetPointer(Hourglass!)

dw_bom.sort()

Execute Immediate "Begin Transaction" using SQLCA;

//For each PArent SKU - update the Item MAster, Delete the Packaging component records and re-create

lLRowCount = dw_bom.RowCount()
For lLRowPos = 1 to llRowCount
	
	lsParentSku = dw_bom.GetITemString(llRowPos,'parent_sku')
	lsDesc = dw_bom.GetITemString(llRowPOs,'desc')
	lsFrenchDesc = dw_bom.GetITemString(llRowPOs,'french_desc')
	lsSpanishDesc = dw_bom.GetITemString(llRowPOs,'spanish_desc')
	
	lsItemGroup = dw_bom.GetITemString(llRowPOs,'group')
	lsItemGroup = wf_format_group(lsItemGroup) /* group code may need formatting*/
	lsChildSku = dw_bom.GetITemString(llRowPOs,'child_sku')
	lsACDPart = dw_bom.GetITemString(llRowPOs,'acd_part')
	lsACDPLC = dw_bom.GetITemString(llRowPOs,'acd_plc')
	lsCOO = dw_bom.GetITemString(llRowPOs,'coo')
	lsPackageType = dw_bom.GetITemString(llRowPOs,'package_type')
	
	lsUPC = Trim(dw_bom.GetITemString(llRowPos,'upc'))
	
	//Remove any spaces from UPC
	Do While Pos(lsUpc," ") > 0
		lsUpc = Replace(lsUpc,Pos(lsUpc," "),1,"")
	Loop
	
	llmerchQty = dw_bom.GetITemNumber(llRowPos,'merch_qty')
	llChildQty = dw_bom.GetITemNumber(llRowPos,'child_Qty')
	
	//If parent SKU has changed, update the item master and delete the children packaging records..
	If lsParentSku <> lsParentSkuSave Then
	
		//Update Item MASter(s)
		Update Item_MASter
		Set Description = :lsDesc, User_field8 = :lsFrenchDesc, User_field9 = :lsSpanishDesc, user_field10 = :lsACDPLC, 
				User_field1 = :lsItemGroup, user_Field12 = :lsACDPart, part_upc_Code = :lsUPC, Qty_2 = :llMerchQty, 
				Country_of_Origin_Default = :lsCOO
		Where Project_id = :gs_project and sku = :lsParentSKU;
		
		If sqlca.SqlCode < 0 Then
			
			lsErrText = SQLCA.SQLErrText
   		Execute Immediate "ROLLBACK" using SQLCA;
			SetPointer(Arrow!)
			Messagebox("", "Unable to udpate Item Master Record:~r~r" + lsErrText)
			Return -1
			
		End If
		
		//Delete Child packaging Items - If coming from WO, try and get the parent supplier, otherwise delete for all and create new for first
		
		lsParentSupplier = ""
		
		If isvalid(w_workorder) Then
		
			If w_workorder.idw_detail.RowCount() > 0 Then
				
				llFindRow = w_workorder.idw_detail.Find("Upper(sku) = '" + Upper(lsParentSKU) + "'",1, w_workorder.idw_detail.RowCount())
				If llFindRow > 0 Then
					lsParentSupplier = w_workorder.idw_detail.GetITemString(llFindRow,'supp_code')
				End If
				
			End If
		
		End IF
				
		If lsParentSupplier > "" Then
			
			Delete from Item_Component
			Where project_id = :gs_Project and sku_parent = :lsParentSku and supp_Code_parent = :lsParentSupplier and component_type = 'P';
			
		Else
			
			Delete from Item_Component
			Where project_id = :gs_Project and sku_parent = :lsParentSku and component_type = 'P';
			
		End If
		
		If sqlca.SqlCode < 0 Then
			
			lsErrText = SQLCA.SQLErrText
   			Execute Immediate "ROLLBACK" using SQLCA;
			SetPointer(Arrow!)
			Messagebox("", "Unable to Delete old Child Packaging Record(s):~r~r" + lsErrText)
			Return -1
			
		End If
		
		//We will need the parent Supplier for creating the Item Component records
		If lsParentSupplier = "" Then
			
			Select Min(supp_code) into:lsParentSupplier
			from Item_MAster 
			Where project_id = :gs_project and sku = :lsParentSku;
			
		End If
		
	End If /*new parent sku*/
	
	//Create a new Package record (item_Component)
	
	If lsChildSKU > "" Then
		
		//We need the supplier of the child Item
		Select Min(supp_code) into:lsChildSupplier
		from Item_MAster 
		Where project_id = :gs_project and sku = :lsChildSku;
	
		//If item not found, create for supplier 0000 - Non inventory tracked items
		If lsChildSupplier = "" or isnull(lsChildSupplier) Then 
			
			//If owner for 000 not already retrieved, retrieve now
			If llDefaultOwner = 0 or isnull(llDefaultOwner) Then
				
				Select Owner_id into :llDefaultOwner
				From Owner
				Where Project_id = :gs_project and owner_type = 'S' and owner_cd = '0000';
				
			End If
			
			lsChildSupplier = '0000'
			
			Insert Into Item_Master (Project_id, SKU, Supp_code, OWner_ID, Country_of_origin_default, Description,
												Grp, last_user, last_update)
					Values (:gs_project, :lsChildSKU, :lsChildSupplier, :llDefaultOwner, 'XXX', 'Misc pacakging materials',
								'Non-Inv', :gs_userID, :ldttoday);
					
			If sqlca.SqlCode < 0 Then
				lsErrText = SQLCA.SQLErrText
   			Execute Immediate "ROLLBACK" using SQLCA;
				SetPointer(Arrow!)
				Messagebox("", "Unable to Insert new Item Master Record:~r~r" + lsErrText)
				Return -1
			End If
			
			If lsNewItems = "" Then
				lsNewItems = lsChildSKU
			Else
				lsNewItems += "~r" + lsChildSKU
			End If
			
		End If
		
		Insert into item_component (project_id, sku_parent, supp_Code_parent, sku_child, supp_Code_child,
												child_qty, last_user, last_update, Component_Type, Bom_Group, child_package_Type)
											
		Values							(:gs_project, :lsParentSku, :lsparentSupplier, :lsChildSku, :lsChildSupplier,
												:llChildQty, :gs_userID, :ldttoday, 'P', '-', :lsPackageType);
												
		If sqlca.SqlCode < 0 Then
			lsErrText = SQLCA.SQLErrText
   		Execute Immediate "ROLLBACK" using SQLCA;
			SetPointer(Arrow!)
			Messagebox("", "Unable to Insert new Child Packaging Record(s):~r~r" + lsErrText)
			Return -1
		End If
		
	End If /*Child SKU present */
	
	lsPArentSkuSave = lsParentSKU
	
Next

Execute Immediate "COMMIT" using SQLCA;

SetPointer(Arrow!)

If lsNewITems = "" Then
	Messagebox("","Item Master and Packaging records updated.")
Else
	Messagebox("","Item Master and Packaging records updated.~r~rThe following new item(s) were created as Non Inventory Tracked Items (Supplier '0000'):~r~r" + lsNewItems + "~r~rThe supplier can be changed in Item Master Maintenance if necessary.")
End If

Return 0
end function

on w_load_gm_bom.create
int iCurrent
call super::create
this.dw_bom=create dw_bom
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_bom
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_1
end on

on w_load_gm_bom.destroy
call super::destroy
destroy(this.dw_bom)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
end on

event ue_postopen;call super::ue_postopen;
Istrparms = Message.PowerObjectParm

//Messagebox("",istrParms.String_arg[1])
//String_arg[1] should have an xml file to import
If UpperBound(istrParms.String_arg) > 0 Then
//	dw_bom.modify("datawindow.import.xml.usetemplate='gm_ims_bom_verify'")
	dw_bom.ImportString(xml!,istrParms.String_arg[1])
End IF
end event

event closequery;call super::closequery;Integer	liRC

If istrparms.Cancelled Then
	istrparms.Integer_arg[1] = 0
	Message.PowerObjectParm = istrParms
	Return 0
End If

//Update the ITem Master and Component MASter with new packaging Info...
liRC = wf_update_Bom()

//If coming from REceive Order, we want to copy contract info to Receive Detail
If istrparms.Window_arg[1] = w_ro Then	
	wf_update_ro_contract()
End If
	
If liRC < 0 Then
	Return -1
Else
	istrparms.Integer_arg[1] = 1
	Message.PowerObjectParm = istrParms
	Return 0
End IF


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_load_gm_bom
integer x = 1691
integer y = 1452
end type

type cb_ok from w_response_ancestor`cb_ok within w_load_gm_bom
integer x = 1257
integer y = 1452
end type

type dw_bom from datawindow within w_load_gm_bom
integer width = 3392
integer height = 1240
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_load_gm_bom"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_load_gm_bom
integer x = 18
integer y = 1292
integer width = 3195
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "BOM information has been retrieved from the GM IMS system. "
boolean focusrectangle = false
end type

type st_2 from statictext within w_load_gm_bom
integer x = 18
integer y = 1356
integer width = 1445
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "~'OK~' to update Item Master, ~'Cancel~' to cancel"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_load_gm_bom
integer x = 2473
integer y = 1452
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
PArent.TriggerEvent('ue_print')
end event

