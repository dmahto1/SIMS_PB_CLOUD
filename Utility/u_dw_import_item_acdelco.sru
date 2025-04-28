HA$PBExportHeader$u_dw_import_item_acdelco.sru
$PBExportComments$Import AC DElco Sku information
forward
global type u_dw_import_item_acdelco from u_dw_import
end type
end forward

global type u_dw_import_item_acdelco from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_itemaster_acsku"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_item_acdelco u_dw_import_item_acdelco

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSupplier,	&
			lsgroup
long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "gm_sku"
		goto lac
	case "acdelco_sku"
		goto ldesc
	Case "description"
		goto lSupplier
	case "supplier"
		goto lgroup
	case "group"
		goto luom1
	Case "uom_1"
		goto llength1
	Case "length_1"
		goto lwidth1
	Case "width_1"
		Goto lheight1
	Case "height_1"
		iscurrvalcolumn = ''
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
//Validate AC Delco SKU
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

//If Upper(Left(gs_project,4)) <> 'GM_M'  Then

If Upper(Left(gs_project,4)) <> 'GM_M'  Then
	If isnull(This.getItemString(al_row,"supplier_id")) Then
		This.Setfocus()
		This.SetColumn("supplier_id")
		iscurrvalcolumn = "supplier_id"
		return "'Supplier' can not be null!"
	End If
End If /*not GM MExico*/

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

//End If /*not GM Mexico*/

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

luom1:
//Validate UOM (level 1)
If len(trim(This.getItemString(al_row,"uom_1"))) > 4 Then
	This.Setfocus()
	This.SetColumn("uom_1")
	iscurrvalcolumn = "uom_1"
	Return "UOM (1) is > 4 Characters"
End If

llength1:
//Validate Length 1
If not isnumber(This.getItemString(al_row,"length_1")) Then
	This.Setfocus()
	This.SetColumn("length_1")
	iscurrvalcolumn = "length_1"
	Return "length (1) is must be numeric"
ElseIf len(trim(This.getItemString(al_row,"length_1"))) > 7 Then
	This.Setfocus()
	This.SetColumn("length_1")
	iscurrvalcolumn = "length_1"
	Return "length (1) is > 7 Digits"
End If

lwidth1:
//Validate Width 1
If not isnumber(This.getItemString(al_row,"width_1")) Then
	This.Setfocus()
	This.SetColumn("width_1")
	iscurrvalcolumn = "width_1"
	Return "Width (1) is must be numeric"
ElseIf len(trim(This.getItemString(al_row,"width_1"))) > 7 Then
	This.Setfocus()
	This.SetColumn("width_1")
	iscurrvalcolumn = "width_1"
	Return "Width (1) is > 7 Digits"
End If

lheight1:
//Validate Height 1
If not isnumber(This.getItemString(al_row,"Height_1")) Then
	This.Setfocus()
	This.SetColumn("Height_1")
	iscurrvalcolumn = "Height_1"
	Return "height (1) is must be numeric"
ElseIf len(trim(This.getItemString(al_row,"Height_1"))) > 7 Then
	This.Setfocus()
	This.SetColumn("Height_1")
	iscurrvalcolumn = "Height_1"
	Return "Height (1) is > 7 Digits"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew,		&
		llOwner,		&
		llLength1,	&
		llWidth1,	&
		llHeight1
		
String	lsSku,	&
			lsACSku,	&
			lsDesc,	&
			lsSupplier,	&
			lsGroup,	&
			lsErrText,	&
			lsUOM1,		&
			lsSQL
			
Datetime		ldToday, ldtServerTime

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
ldtServerTime = DateTime(Today(),now())

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//Update or Insert for each Row...
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsSku = left(trim(This.GetItemString(llRowPos,"gm_sku")),50)
	lsACSku = left(trim(This.GetItemString(llRowPos,"acdelco_sku")),50)
	lsDesc = left(trim(This.GetItemString(llRowPos,"Description")),70)
	lsSupplier = left(trim(This.GetItemString(llRowPos,"supplier_id")),20)
	If Upper(Left(gs_project,4)) = 'GM_M'  and (isnull(lsSupplier) or lsSupplier = '') Then
		lsSupplier = 'XX'
	End If
	
	lsGroup = left(trim(This.GetItemString(llRowPos,"group")),10)
	lsuom1 = left(trim(This.GetItemString(llRowPos,"uom_1")),4)
	llLength1 = Long(This.GetItemString(llRowPos,"length_1"))
	llWidth1 = Long(This.GetItemString(llRowPos,"Width_1"))
	llheight1 = Long(This.GetItemString(llRowPos,"height_1"))
	
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
	If lsUOM1 > ' ' Then lsSQL += "uom_1 = '" + lsUOM1 + "', "
	If lllength1 > 0 Then lsSQL += "length_1 = " + string(lllength1) + ", "
	If llwidth1 > 0 Then lsSQL += "width_1 = " + string(llwidth1) + ", "
	If llheight1 > 0 Then lsSQL += "height_1 = " + string(llheight1) + ", "
	lsSQl += "Interface_upd_req_ind = 'Y', last_user = '" + gs_userid + "', last_update = '" + string(today(),'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where sku = '" + lsSku + "' and project_id = '" + gs_project + "'" /*Where*/
	If lsSupplier > ' ' Then lsSQl += " and supp_code = '" + lsSupplier + "'" /*GM Mexico doesn't want to include SUpplier*/
		
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
		Where project_id = :gs_project and owner_type = 'S' and owner_cd = 'XX'
		//Where project_id = :gs_project and owner_type = 'S' and owner_cd = :lsSupplier
		Using SQLCA;
		
		Insert Into item_master (project_id,sku,owner_id,country_of_origin_default,description,alternate_sku,supp_code,grp,uom_1,length_1, width_1, height_1, last_user,last_update, Interface_upd_req_ind) 
		values (:gs_project,:lsSku,:llOwner,'XXX',:lsDesc,:lsACSku,:lsSupplier,:lsgroup,:lsuom1,:llLength1, :llWidth1, :llheight1,:gs_userid,:ldToday,'Y')
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

// 02/09 - PCONKL - We may need to trigger an update to someone else (like LMS)
Execute Immediate "Begin Transaction" using SQLCA; 
	
Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date, Trans_Parm)
		Values(:gs_Project, 'IM', "",'N', :ldtServerTime, '');
							
Execute Immediate "COMMIT" using SQLCA;

MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rRecords Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_item_acdelco.create
call super::create
end on

on u_dw_import_item_acdelco.destroy
call super::destroy
end on

