HA$PBExportHeader$u_dw_import_item_bom.sru
$PBExportComments$Import ItemMaster - BOM/Package information
forward
global type u_dw_import_item_bom from u_dw_import
end type
end forward

global type u_dw_import_item_bom from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_itemaster_bom"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_item_bom u_dw_import_item_bom

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);		
//Validate for valid field length and type

String	lsSupplier,	&
			lsGroup, lsChildSupplier, lsParentSupplier, lsParentSKU, lsChildSKU
			
long		llCount

//Don't validate if row not set to process (Parent sku doesn't exist)
If This.GetITemString(al_row,'process_ind') = 'N' Then
	iscurrvalcolumn = ''
	return ''
End If
	
// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "parent_sku"
		goto lparentsupplier
	Case "parent_supplier"
		goto lchildsku
	case "child_Sku"
		goto lchildsupplier
	case "child_supplier"
		goto lchildqty
	case "child_qty"
		goto lcomponenttype
	Case "component_type"
		iscurrvalcolumn = ''
		return ''
End Choose

//Validate Parent Sku - we will skip update and validations if parent not found...
lsParentSKU = This.getItemString(al_row,"parent_sku")
If isnull(lsParentSKU) Then
	This.Setfocus()
	This.SetColumn("parent_sku")
	iscurrvalcolumn = "parent_sku"
	return "'SKU' can not be null!"
End If

Select Count(*) into :llCount
From ITem_MAster
Where project_id = :gs_project and sku = :lsParentSKU
Using SQLCA;

If llCount <= 0 Then
	this.setItem(al_row,'process_ind','N') /*Don't process*/
Else
	this.setItem(al_row,'process_ind','Y') /*process*/
End IF

	
lparentsupplier:
//Validate Supplier if present

lsSupplier = This.getItemString(al_row,"parent_Supplier")

If (not isnull(lsSupplier)) and lsSupplier > '' Then

	If lsSupplier <> lsParentSupplier Then
		
		Select Count(*)  into :llCount
		from Supplier
		Where project_id = :gs_project and supp_code = :lsSupplier
		Using SQLCA;

		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("parent_Supplier")
			iscurrvalcolumn = "parent_Supplier"
			Return "Parent Supplier is not valid!"
		End If
		
	End If
	
	lsParentSupplier = lsSupplier
	
End If /*Supplier present*/

lchildsku:
//Validate Child Sku - we won't save any records where we don't have a valid child SKU...
lsChildSKU = This.getItemString(al_row,"child_sku")
If isnull(lsChildSKU) Then
	This.Setfocus()
	This.SetColumn("child_sku")
	iscurrvalcolumn = "child_sku"
	return "'Child SKU' can not be null!"
End If

Select Count(*) into :llCount
From ITem_MAster
Where project_id = :gs_project and sku = :lsChildSKU
Using SQLCA;

//If llCount <= 0 Then
//	
//	This.Setfocus()
//	This.SetColumn("child_sku")
//	iscurrvalcolumn = "child_sku"
//	return "Invalid Child SKU!"
//	
//End IF

If llCount <= 0 Then
	this.setItem(al_row,'process_ind','N') /*Don't process*/
End IF

lchildsupplier:
//Validate Child Supplier - Required (we can't create component rec without)

lsSupplier = This.getItemString(al_row,"child_Supplier")

If (not isnull(lsSupplier)) and lsSupplier > '' Then

	if lsSupplier <> lsChildSupplier Then
		
		Select Count(*)  into :llCount
		from Supplier
		Where project_id = :gs_project and supp_code = :lsSupplier
		Using SQLCA;

		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("child_Supplier")
			iscurrvalcolumn = "child_Supplier"
			Return "Child Supplier is not valid!"
		End If
		
	End IF
	
	lsChildSupplier= lsSupplier
	
Else
	
	This.Setfocus()
	This.SetColumn("child_Supplier")
	iscurrvalcolumn = "child_Supplier"
	Return "Child Supplier is required!"
	
End If /*Supplier present*/

lchildqty:
//Child Qty must be present and numeric
If isnull(This.getItemString(al_row,"child_qty")) or Not isnumber(This.getItemString(al_row,"child_qty")) or &
	Dec(This.getItemString(al_row,"child_qty")) < 1 Then
	
		This.Setfocus()
		This.SetColumn("child_qty")
		iscurrvalcolumn = "child_qty"
		Return "Child Qty must be present, numeric and > 0 !"
		
End IF

lcomponenttype:
//Component TYpe must be C or P
If isnull(This.getItemString(al_row,"component_type")) or (This.getItemString(al_row,"component_type") <> 'C' and This.getItemString(al_row,"component_type") <> 'P') Then
	This.Setfocus()
	This.SetColumn("component_type")
	iscurrvalcolumn = "component_type"
	Return "Component Type must be 'C' (Component) or 'P' (Package) !"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew, llSupplierPos, llSupplierCount
		
Decimal	ldQty		
String	lsParentSku, lsChildSKU, lsParentSupplier, lsChildSupplier, lsErrText,	lsSQL, lsCompType, lsBomGroup,	&
			presentation_str, dwsyntax_str
Datastore	ldsSupplier
			
Date		ldToday

ldToday = Today()
llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

//Create Datastore...
ldsSupplier = Create Datastore
presentation_str = "style(type=grid)"
lsSQl = "Select supp_code from Item_master " /*We'll add project and sku below*/

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsSupplier.Create( dwsyntax_str, lsErrText)
ldsSupplier.SetTransObject(SQLCA)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//Update or Insert for each Row...
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	//If parent Sku not found in validation, don't save here...
	If This.GetITemString(llRowpos,'process_ind') = 'N' Then Continue
	
	lsPArentSku = left(trim(This.GetItemString(llRowPos,"parent_sku")),50)
	lsChildSku = left(trim(This.GetItemString(llRowPos,"child_sku")),50)
	
//	//Left pad with 0's..
//	Do While Len(lsSKU) < 8
//		lsSKU = '0' + lsSKU
//	Loop
	
	
	ldQty = Dec(trim(This.GetItemString(llRowPos,"child_qty")))
	lsParentSupplier = left(trim(This.GetItemString(llRowPos,"parent_Supplier")),10)
	lsChildSupplier = left(trim(This.GetItemString(llRowPos,"child_Supplier")),10)
	lsCompType = left(trim(This.GetItemString(llRowPos,"component_type")),1)
	
	If isnull(This.GetItemString(llRowPos,"bom_Group")) or This.GetItemString(llRowPos,"bom_Group") = "" Then
		lsBomGroup = "-"
	Else
		lsBomGroup = left(trim(This.GetItemString(llRowPos,"bom_Group")),10)
	End IF
	

// 07/01 Pconkl - Build update statement dynamically, based on fields filled in on layout
// so we dont clear out previously entered data if missing from layout

	lsSQL = "Update Item_Component Set "
//	If lsGroup > ' ' Then lsSQL += 'grp = "' + lsGroup + '", '
	
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + string(today(),'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where sku_Parent = '" + lsParentSku + "' and project_id = '" + gs_project + "'" /*Where*/
	lsSQl += "and sku_child = '" + lsChildsku + "' "
	If lsPArentSupplier > ' ' Then lsSQl += " and supp_code_Parent = '" + lsParentSupplier + "'" 
	If lsChildSupplier > ' ' Then lsSQl += " and supp_code_Child = '" + lsChildSupplier + "'" 
		
	Execute Immediate :LSSQL Using SQLCA;
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		
		If Upper(gs_project) = 'CHINASIMS'  THEN
			 SQLCA.DBParm = "disablebind =1"
		End If
		
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If	
		
	If Sqlca.sqlnrows < 1 Then /*Insert*/
		
		//If parent supplier is blank, We need to insert for each supplier of this SKU
		If lsParentSupplier = "" or isnull(lsParentSupplier) Then
			ldssupplier.SetSqlSelect("Select supp_code from Item_MaSter where project_id = '" + gs_project + "' and sku = '" + lsParentSku + "'")
			ldsSupplier.Retrieve()
		Else
			ldsSupplier.reset()
			ldsSupplier.InsertRow(0)
			ldsSupplier.SetItem(1,'supp_code',lsParentSupplier)
		End If
		
		llSupplierCount = ldsSupplier.RowCount()
		For llSupplierPos = 1 to llSupplierCount
			
			lsParentSupplier = ldsSupplier.GetITemString(llSupplierPos,'Supp_code')
			
			Insert Into item_Component (project_id,sku_parent, sku_child, supp_code_Parent, supp_code_Child, child_qty, component_Type, bom_Group,last_user,last_update) values 
					(:gs_project,:lsParentSku, :lsChildSku, :lsParentSupplier, :lsChildSupplier, :ldQty, :lsCompType, :lsBomGroup,:gs_userid,:ldToday)
			Using SQLCA;
	
			If sqlca.sqlcode <> 0 Then
				This.SetRow(llRowPos)
				This.ScrollToRow(llRowPos)
				lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
				
				If Upper(gs_project) = 'CHINASIMS'  THEN
					 SQLCA.DBParm = "disablebind =1"
				End If
				
				
				Execute Immediate "ROLLBACK" using SQLCA;
				Messagebox("Import","Unable to save changes to database!~r~r" + lsErrtext)
				SetPointer(Arrow!)
				Return -1
			Else
				llnew ++
			End If
			
		Next /*Supplier for SKU*/
		
		

	Else /*update*/
		llupdate ++
	End If
	
Next

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =1"
End If

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_item_bom.create
call super::create
end on

on u_dw_import_item_bom.destroy
call super::destroy
end on

