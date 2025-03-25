HA$PBExportHeader$u_dw_import_bluecoat_pallet_serial.sru
$PBExportComments$Pallet/Serial Import format for Bluecoat
forward
global type u_dw_import_bluecoat_pallet_serial from u_dw_import
end type
end forward

global type u_dw_import_bluecoat_pallet_serial from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_bluecoat_pallet_serial"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_bluecoat_pallet_serial u_dw_import_bluecoat_pallet_serial

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSupplier, lsgroup
long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	Case "sku"
		goto lSupplier
	case "supplier"
		goto lPallet
	case "pallet_id"
		goto lCarton
	Case "carton_id"
		goto lSerial
	Case "serial_no"
		isCurrValColumn = ''
		return ''
End Choose

//Validate Sku
If isnull(This.getItemString(al_row,"sku")) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "'SKU' can not be null!"
End If

If len(trim(This.getItemString(al_row,"sku"))) > 50 Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "'SKU' is > 50 characters"
End If

	
lsupplier:
//Validate Supplier

	lsSupplier = This.getItemString(al_row,"supp_code")
	
	If (Not isnull(lsSUpplier)) and lsSupplier > ' ' Then

		Select Count(*)  into :llCount
		from Supplier
		Where project_id = :gs_project and supp_code = :lsSupplier
		Using SQLCA;

		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("supp_code")
			iscurrvalcolumn = "supp_code"
			Return "Supplier ID is not valid!"
		End If

		If len(trim(This.getItemString(al_row,"supp_code"))) > 20 Then
			This.Setfocus()
			This.SetColumn("supp_code")
			iscurrvalcolumn = "supp_code"
			Return "Supplier ID is > 20 Characters"
		End If
		
	End If /*Supplier Present*/

lPallet:
//Validate Pallet
If len(trim(This.getItemString(al_row,"pallet_id"))) > 20 Then
	This.Setfocus()
	This.SetColumn("pallet_id")
	iscurrvalcolumn = "pallet_id"
	Return "Pallet ID is > 20 Characters"
End If

lCarton:
//Validate Carton
If len(trim(This.getItemString(al_row,"carton_id"))) > 20 Then
	This.Setfocus()
	This.SetColumn("carton_id")
	iscurrvalcolumn = "carton_id"
	Return "Carton ID is > 20 Characters"
End If

lSerial:
//Validate Serial
If len(trim(This.getItemString(al_row, "serial_no"))) > 50 Then
	This.Setfocus()
	This.SetColumn("serial_no")
	iscurrvalcolumn = "serial_no"
	Return "Serial Number is > 50 Characters"
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llNew		
		
String	lsSku,		&
			lsSupplier,	&
			lsPallet,	&
			lsCarton,	&
			lsSerial,	&
			lsErrText,	&
			lsSQL
			

Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()

llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Update or Insert for each Row...
For llRowPos = 1 to llRowCount
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsSku = left(trim(This.GetItemString(llRowPos, "sku")), 50)
	lsSupplier = left(trim(This.GetItemString(llRowPos, "supp_code")), 20)
	If IsNull(lsSupplier) Then lsSupplier = 'BLUECOAT'
	
	lsPallet = left(trim(This.GetItemString(llRowPos, "pallet_id")),20)
	lscarton = left(trim(This.GetItemString(llRowPos, "carton_id")), 20)
	If IsNull(lscarton) Then lscarton = '-'
	lsSerial = left(trim(This.GetItemString(llRowPos, "serial_no")),50)
	
	Insert Into carton_serial (project_id, carton_id, serial_no, mac_id, pallet_id, sku, supp_code, last_update) 
	values (:gs_project, :lsCarton, :lsSerial, '-', :lsPallet, :lsSku, :lsSupplier, :ldToday)
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	Else
		llnew ++
	End If
	
Next

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_bluecoat_pallet_serial.create
call super::create
end on

on u_dw_import_bluecoat_pallet_serial.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;Long	 llFindRow
String	lsSKU, lsSuppCode, lsPallet_Id, lsCarton_Id, lsSerial_No

boolean ib_Fail = false
integer li_count


w_main.SetMicroHelp("Checking if file has been previousely loaded")

lsSerial_no = Trim(Upper(this.GetItemString( 1, "serial_no")))
	
SELECT Count(*) INTO :li_count
	FROM carton_serial WHERE project_id = :gs_Project and serial_no = :lsSerial_No
	USING SQLCA;
		
	IF li_count > 0 THEN
		
			ib_fail = true

			MessageBox ("Error", "This file has already been loaded! ")

	END IF


w_main.SetMicroHelp("Ready")

IF ib_fail = true THEN
	
	RETURN -1
	
END IF


Return 0
end event

