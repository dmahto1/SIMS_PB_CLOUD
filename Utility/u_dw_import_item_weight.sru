HA$PBExportHeader$u_dw_import_item_weight.sru
$PBExportComments$Import ItemMaster Weight Information
forward
global type u_dw_import_item_weight from u_dw_import
end type
end forward

global type u_dw_import_item_weight from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_itemaster_weight"
end type
global u_dw_import_item_weight u_dw_import_item_weight

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew,		&
		llOwner,		&
		llLength1,	&
		llWidth1,	&
		llHeight1
		
Decimal		llPackaged
		
String	lsSku,	&
			lsunpackaged,	&
			lsErrText,		&
			lsSupplier,	&
			lsUOM1,		&
			lsSQL, lsOWnerCode
			
Datetime	ldToday, ldtServerTime

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
ldtServerTime = DateTime(Today(),Now())

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
	lsSupplier = left(trim(This.GetItemString(llRowPos,"supplier_id")),20)
	If Upper(Left(gs_project,4)) = 'GM_M'  and (isnull(lsSupplier) or lsSupplier = '') Then
		lsSupplier = 'XX'
	End If
	lsunpackaged = left(trim(This.GetItemString(llRowPos,"unpackaged_weight")),12)
	llPackaged = dec(left(trim(This.GetItemString(llRowPos,"packaged_weight")),12))		
	lsuom1 = left(trim(This.GetItemString(llRowPos,"uom_1")),4)
	llLength1 = Long(This.GetItemString(llRowPos,"length_1"))
	llWidth1 = Long(This.GetItemString(llRowPos,"Width_1"))
	llheight1 = Long(This.GetItemString(llRowPos,"height_1"))
	
// 07/01 Pconkl - Build update statement dynamically, based on fields filled in on layout
// so we dont clear out previously entered data if missing from layout

	lsSQL = "Update Item_Master Set "
	If lsUOM1 > ' ' Then lsSQL += "uom_1 = '" + lsUOM1 + "', "
	If lsunpackaged > ' ' Then lsSQL += "user_field2 = '" + lsunpackaged + "', "
	If llPackaged > 0 Then lsSQL += "weight_1 = " + string(llPackaged) + ", "
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
	
		// 11/00 PCONKL - Owner ID is required. Default to 'XX' for current project If Supplier not present
		If lsSupplier > " " Then
			lsOwnerCode = lsSupplier
		Else
			lsOWnerCode = 'XX'
		End IF
		
		Select owner_id into :llOwner
		From Owner
		Where project_id = :gs_project and owner_type = 'S' and owner_cd = :lsOWnerCode
		Using SQLCA;
		
		Insert Into item_master (project_id,sku,supp_code,owner_id,country_of_origin_default,user_field2,weight_1,uom_1,length_1, width_1, height_1,last_user,last_update, interface_upd_req_ind) 
		values (:gs_project,:lsSku,:lsSupplier,:llOwner,'XXX',:lsunpackaged,:llPackaged,:lsuom1,:llLength1, :llWidth1, :llheight1,:gs_userid,:ldToday, 'Y')
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

public function string wf_validate (long al_row);String	lsSupplier
Long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "gm_sku"
		goto lsupplier
	Case "supplier_id"
		goto lunpack
	Case "unpackaged_weight"
		goto lpack
	case "packaged_weight"
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
	
lsupplier:
//Validate Supplier

// 11/01 PCONKL - Supplier not required for GM but must be validated if present*/
If Upper(Left(gs_project,4)) <> 'GM_M'  Then
	If isnull(This.getItemString(al_row,"supplier_id")) Then
		This.Setfocus()
		This.SetColumn("supplier_id")
		iscurrvalcolumn = "supplier_id"
		return "'Supplier' can not be null!"
	End If
End If /*Not GM*/

	// 11/00 PCONKL - Must be valid supplier since it's now in the primary key

lsSupplier = This.getItemString(al_row,"supplier_id")

If (not isnull(lsSupplier)) and lsSupplier > '' Then

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
	
End If /*Supplier PResent*/

lunpack:
//Validate Unpackaged Weight
If not isnumber(This.getItemString(al_row,"unpackaged_weight")) Then
	This.Setfocus()
	This.SetColumn("unpackaged_weight")
	iscurrvalcolumn = "unpackaged_weight"
	Return "Un-packaged weight must be numeric!"
End If


If len(trim(This.getItemString(al_row,"unpackaged_weight"))) > 12 Then
	This.Setfocus()
	This.SetColumn("unpackaged_weight")
	iscurrvalcolumn = "unpackaged_weight"
	Return "Unpackaged Weight is > 9.3 Numbers"
End If
	
lpack:
//Validate packaged Weight
If not isnumber(This.getItemString(al_row,"packaged_weight")) Then
	This.Setfocus()
	This.SetColumn("packaged_weight")
	iscurrvalcolumn = "packaged_weight"
	Return "Packaged weight must be numeric!"
End If


If len(trim(This.getItemString(al_row,"packaged_weight"))) > 12 Then
	This.Setfocus()
	This.SetColumn("packaged_weight")
	iscurrvalcolumn = "packaged_weight"
	Return "Packaged Weight is > 9.3 Numbers"
End If

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

on u_dw_import_item_weight.create
call super::create
end on

on u_dw_import_item_weight.destroy
call super::destroy
end on

