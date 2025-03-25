HA$PBExportHeader$u_dw_import_item_coty.sru
$PBExportComments$Item Master Import format for COTY
forward
global type u_dw_import_item_coty from u_dw_import
end type
end forward

global type u_dw_import_item_coty from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_itemaster_coty"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_item_coty u_dw_import_item_coty

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSupplier, lsgroup
long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	Case "gm_sku"
		goto lac
	case "acdelco_sku"
		goto ldesc
	Case "description"
		goto lSupplier
	case "supplier"
		goto lgroup
	case "group"
		goto lUF14
	Case "user_field14"
		goto lUOM1
	Case "uom_1"
		isCurrValColumn = ''
		return ''
End Choose

//Validate Sku
If isnull(This.getItemString(al_row,"gm_sku")) Then
	This.Setfocus()
	This.SetColumn("gm_sku")
	iscurrvalcolumn = "gm_sku"
	return "'SKU' can not be null!"
End If

If len(trim(This.getItemString(al_row,"gm_sku"))) > 50 Then
	This.Setfocus()
	This.SetColumn("gm_sku")
	iscurrvalcolumn = "gm_sku"
	return "'SKU' is > 50 characters"
End If

	
lac:
//Validate Alternate SKU
If len(trim(This.getItemString(al_row,"acDelco_sku"))) > 50 Then
	This.Setfocus()
	This.SetColumn("acdelco_sku")
	iscurrvalcolumn = "acdelco_sku"
	Return "Alternate SKU is > 50 Characters"
End If
	
ldesc:
//Validate Description
If len(trim(This.getItemString(al_row,"description"))) > 70 Then
	This.Setfocus()
	This.SetColumn("description")
	iscurrvalcolumn = "description"
	Return "Description is > 70 Characters"
End If

lsupplier:
//Validate Supplier

// 11/01 - PCONKL - We want to validate supplier if present. If null, don't validate

	// 11/00 PCONKL - Must be valid supplier since it's now in the primary key

	lsSupplier = This.getItemString(al_row,"supplier_id")
	
	If (Not isnull(lsSUpplier)) and lsSupplier > ' ' Then

		Select Count(*)  into :llCount
		from Supplier
		Where project_id = :gs_project and supp_code = :lsSupplier
		Using SQLCA;

		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("supplier_id")
			iscurrvalcolumn = "supplier_id"
			Return "Supplier ID is not valid!"
		End If

		If len(trim(This.getItemString(al_row,"supplier_id"))) > 20 Then
			This.Setfocus()
			This.SetColumn("supplier_id")
			iscurrvalcolumn = "supplier_id"
			Return "Supplier ID is > 20 Characters"
		End If
		
	End If /*Supplier Present*/

lgroup:
//Validate group
If len(trim(This.getItemString(al_row,"group"))) > 10 Then
	This.Setfocus()
	This.SetColumn("group")
	iscurrvalcolumn = "group"
	Return "Group is > 10 Characters"
End If

lsGroup = This.getItemString(al_row,"group")
If lsGroup > ' ' Then /*only validate if present*/

	Select Count(*)  into :llCount
	from Item_group
	Where project_id = :gs_project and grp = :lsGroup
	Using SQLCA;

	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("group")
		iscurrvalcolumn = "group"
		Return "Group is not valid!"
	End If
//DGM 08/12/2005
ELSEIF Upper(gs_project) = 'PHXBRANDS' and (isnull(lsgroup) or lsgroup = '') THEN
		This.Setfocus()
		This.SetColumn("group")
		iscurrvalcolumn = "group"
		return "'Group' can not be null!"
End If /*Group Present*/

lUF14:
//Validate User_Field14
If len(trim(This.getItemString(al_row, "User_Field14"))) > 70 Then
	This.Setfocus()
	This.SetColumn("user_field14")
	iscurrvalcolumn = "user_field14"
	Return "French Description is > 70 Characters"
End If

lUOM1:
//Validate UOM_1

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew,		&
		llOwner
		
String	lsSku,	&
			lsACSku,	&
			lsDesc,	&
			lsSupplier,	&
			lsGroup,	&
			lsErrText,	&
			lsUF14,		&
			lsUOM1,	&
			lsUOM2,	&
			lsUOM3,	&
			lsSQL
			
decimal 	ldLength1,	&
			ldWidth1,	&
			ldHeight1,	&
			ldWeight1,	&
			ldLength2,	&
			ldWidth2,	&
			ldHeight2,	&
			ldWeight2,	&
			ldQty2,		&
			ldQty3

Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//Update or Insert for each Row...
For llRowPos = 1 to llRowCount
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsSku = left(trim(This.GetItemString(llRowPos, "gm_sku")), 50)
	lsACSku = left(trim(This.GetItemString(llRowPos, "acdelco_sku")), 50)
	lsDesc = left(trim(This.GetItemString(llRowPos, "Description")), 70)
	lsSupplier = left(trim(This.GetItemString(llRowPos, "supplier_id")), 20)
//	If Upper(Left(gs_project,4)) = 'GM_M'  and (isnull(lsSupplier) or lsSupplier = '') Then
//		lsSupplier = 'XX'
//	End If
	
	lsGroup = left(trim(This.GetItemString(llRowPos, "group")),10)
	lsUF14 = left(trim(This.GetItemString(llRowPos, "User_Field14")), 70)
	lsUOM1 = left(trim(This.GetItemString(llRowPos, "uom_1")),4)
	ldLength1 = Dec(This.GetItemString(llRowPos, "length_1"))
	ldWidth1 = Dec(This.GetItemString(llRowPos, "Width_1"))
	ldHeight1 = Dec(This.GetItemString(llRowPos, "height_1"))
	ldWeight1 = Dec(This.GetItemString(llRowPos, "Weight_1"))
	lsUOM2 = left(trim(This.GetItemString(llRowPos, "uom_2")),4)
	ldQTY2 = Dec(This.GetItemString(llRowPos, "QTY_2"))
	ldLength2 = Dec(This.GetItemString(llRowPos, "length_2"))
	ldWidth2 = Dec(This.GetItemString(llRowPos, "Width_2"))
	ldHeight2 = Dec(This.GetItemString(llRowPos, "height_2"))
	ldWeight2 = Dec(This.GetItemString(llRowPos, "Weight_2"))
	lsUOM3 = left(trim(This.GetItemString(llRowPos, "uom_3")),4)
	ldQTY3 = Dec(This.GetItemString(llRowPos, "QTY_3"))
	
	// 11/00 PCONKL - Supplier is now part of the primary key and Required
	//try update first
	
//	If Upper(Left(gs_project,4)) <> 'GM_M'  Then
//		Update item_master Set
//		alternate_sku = :lsacSku,
//		grp = :lsGroup,
//		description = :lsDesc,
//		uom_1 = :lsUOM1, 
//		length_1 = :lllength1,
//		width_1 = :llWidth1,
//		height_1 = :llHeight1,
//		last_user = :gs_userid,
//		last_update = :ldToday
//		Where sku = :lsSku and project_id = :gs_project and supp_code = :lsSupplier
//		Using Sqlca;
//	Else
//		Update item_master Set
//		alternate_sku = :lsacSku,
//		grp = :lsGroup,
//		description = :lsDesc,
//		uom_1 = :lsUOM1, 
//		length_1 = :lllength1,
//		width_1 = :llWidth1,
//		height_1 = :llHeight1,
//		last_user = :gs_userid,
//		last_update = :ldToday
//		Where sku = :lsSku and project_id = :gs_project 
//		Using Sqlca;
//	End If

// 07/01 Pconkl - Build update statement dynamically, based on fields filled in on layout
// so we dont clear out previously entered data if missing from layout

	lsSQL = "Update Item_Master Set "
	If lsACSku > ' ' Then lsSQL += "alternate_sku = '" + lsacSKU + "', "
	If lsGroup > ' ' Then lsSQL += "grp = '" + lsGroup + "', "
	If lsDesc > ' ' Then lsSQL += "Description = '" + lsDesc + "', "
	If lsUF14 > ' ' Then lsSQL += "User_Field14 = '" + lsUF14 + "', "
	If lsUOM1 > ' ' Then lsSQL += "uom_1 = '" + lsUOM1 + "', "
	If ldlength1 > 0 Then lsSQL += "length_1 = " + string(ldlength1) + ", "
	If ldwidth1 > 0 Then lsSQL += "width_1 = " + string(ldwidth1) + ", "
	If ldheight1 > 0 Then lsSQL += "height_1 = " + string(ldheight1) + ", "
	If ldweight1 > 0 Then lsSQL += "weight_1 = " + string(ldweight1) + ", "
	If lsUOM2 > ' ' Then lsSQL += "uom_2 = '" + lsUOM2 + "', "
	If ldlength2 > 0 Then lsSQL += "length_2 = " + string(ldlength2) + ", "
	If ldwidth2 > 0 Then lsSQL += "width_2 = " + string(ldwidth2) + ", "
	If ldheight2 > 0 Then lsSQL += "height_2 = " + string(ldheight2) + ", "
	If ldweight2 > 0 Then lsSQL += "weight_2 = " + string(ldweight2) + ", "
	If ldQTY2 > 0 Then lsSQL += "qty_2 = " + string(ldQTY2) + ", "
	If lsUOM3 > ' ' Then lsSQL += "uom_3 = '" + lsUOM3 + "', "
	If ldQTY3 > 0 Then lsSQL += "qty_3 = " + string(ldQTY3) + ", "
	lsSQl += "last_user = '" + gs_userid + "', last_update = '" + string(today(),'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where sku = '" + lsSku + "' and project_id = '" + gs_project + "'" 
	If lsSupplier > ' ' Then lsSQl += " and supp_code = '" + lsSupplier + "'" 
		
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
		
	If Sqlca.sqlnrows <> 1 Then /*Insert*/
	
		// 11/00 PCONKL - Owner ID is required. Default to 'XX' for current project
		Select owner_id into :llOwner
		From Owner
		//Where project_id = :gs_project and owner_type = 'S' and owner_cd = 'XX'
		Where project_id = :gs_project and owner_type = 'S' and owner_cd = :lsSupplier
		Using SQLCA;
		
		Insert Into item_master (project_id, sku, owner_id, country_of_origin_default, description, alternate_sku, supp_code, grp, User_Field14, UOM_1, Length_1, Width_1, Height_1, UOM_2, Length_2, Width_2, Height_2, QTY_2, UOM_3, QTY_3, last_user, last_update) 
		values (:gs_project, :lsSku, :llOwner, 'XXX', :lsDesc, :lsACSku, :lsSupplier, :lsgroup, :lsUF14, :lsUOM1, :ldLength1, :ldWidth1, :ldHeight1, :lsUOM2, :ldLength2, :ldWidth2, :ldHeight2, :ldQTY2, :lsUOM3, :ldQTY3, :gs_userid, :ldToday)
		Using SQLCA;
	
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			
			If Upper(gs_project) = 'CHINASIMS'  THEN
				 SQLCA.DBParm = "disablebind =1"
			End If			
			
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		Else
			llnew ++
		End If
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

on u_dw_import_item_coty.create
call super::create
end on

on u_dw_import_item_coty.destroy
call super::destroy
end on

