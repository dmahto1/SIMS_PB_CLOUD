$PBExportHeader$u_dw_import_wd_scanner_ro.sru
$PBExportComments$Import Western Digial Scanner Receive Order
forward
global type u_dw_import_wd_scanner_ro from u_dw_import
end type
end forward

global type u_dw_import_wd_scanner_ro from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_wd_scanner_ro"
end type
global u_dw_import_wd_scanner_ro u_dw_import_wd_scanner_ro

type variables
String	isRoNoHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsRoNo,	&
			lsRoNowork,	&
			lsOrdStatus,	&
			lsSKU,			&
			lsLoc,	&
			lsWarehouse,	&
			lsLot,			&
			lsPONO,			&
			lsPONO2,			&
			lsInvType
			
Long		llCount

isRoNoHold = ''


//Validate Inventory Type
lsInvType = Trim(This.getItemString(al_row,"inv_Type"))

If isnull(lsInvType) Then
	This.Setfocus()
	This.SetColumn("inv_Type")
	iscurrvalcolumn = "inv_Type"
	return "'Inventory Type' can not be null!"
End If

Select COUNT(*)
Into	:llCount
FRom Inventory_type
Where project_id = :gs_project and
		inv_type = :lsInvType;
		
If llCount <= 0 Then
	This.Setfocus()
	This.SetColumn("inv_type")
	iscurrvalcolumn = "inv_type"
	Return "Invalid Inventory Type"
End If

//Validate RO_NO
lsRoNo = Trim(This.getItemString(al_row,"ro_no"))

If isnull(lsRoNo) Then
	This.Setfocus()
	This.SetColumn("ro_no")
	iscurrvalcolumn = "ro_no"
	return "'RO NO' can not be null!"
End If

If len(trim(lsRoNo)) > 16 Then
	This.Setfocus()
	This.SetColumn("ro_no")
	iscurrvalcolumn = "ro_no"
	return "'ro_no' is > 16 characters"
End If

//check for valid Order and not complete or Void
//If lsRONo <> isRoNoHold Then /* only check if changed*/
	
	Select ro_no, ord_status, wh_code
	Into	:lsRoNoWork, :lsOrdStatus, :lsWarehouse
	From	Receive_master
	Where Project_id = :gs_project and ro_no = :lsroNo;
	
	If isNull(lsroNoWork) or lsRoNoWork = '' Then /* ro not found*/
		This.Setfocus()
		This.SetColumn("ro_no")
		iscurrvalcolumn = "ro_no"
		return "'ro_no' not found"
	End If /* RO not found */
	
	//validate order status
	If lsOrdStatus = 'C' or lsOrdStatus = 'V' Then
		This.Setfocus()
		This.SetColumn("ro_no")
		iscurrvalcolumn = "ro_no"
		return "'This order is either complete or Void and can not be updated."
	End If /*complete or void*/
	
	isRoNoHold = lsRoNo /*new current ro no*/
	
//End If /* ro changed */
	
//Validate SKU
lsSKU = Trim(This.getItemString(al_row,"SKU"))

If isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "SKU can not be null!"
End If

If len(trim(lsSKU)) > 50 Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	Return "SKU is > 50 Characters"
End If

// validate existence of Order detail record
Select Count(*)
Into	:llCOunt
From	Receive_Detail
Where ro_no = :lsRONO and sku = :lsSKU;

If llCount <= 0 Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	Return "No Order Detail record found for this Order/SKU"
End If /* order detail does not exist*/

//Validate Qty
If not isnumber(Trim(This.getItemString(al_row,"quantity"))) Then
	This.Setfocus()
	This.SetColumn("quantity")
	iscurrvalcolumn = "quantity"
	Return "Qty is not numeric"
End If

//Validate Lot/Pallet
lsLot = Trim(This.getItemString(al_row,"lot_no"))

If isnull(lsLot) Then
	This.Setfocus()
	This.SetColumn("lot_no")
	iscurrvalcolumn = "lot_no"
	return "Pallet can not be null!"
End If

If len(trim(lsLot)) > 20 Then
	This.Setfocus()
	This.SetColumn("lot_no")
	iscurrvalcolumn = "lot_no"
	Return "Lot/Pallet ID is > 20 Characters"
End If

//Validate PO NO/Carton
lsPONO = Trim(This.getItemString(al_row,"po_no"))

If isnull(lsPoNo) Then
	This.Setfocus()
	This.SetColumn("po_no")
	iscurrvalcolumn = "po_no"
	return "Carton can not be null!"
End If

If len(trim(lsPONO)) > 25 Then
	This.Setfocus()
	This.SetColumn("po_no")
	iscurrvalcolumn = "po_no"
	Return "PO NO/Carton ID is > 25 Characters"
End If

//Location
lsLoc = Trim(This.getItemString(al_row,"l_code"))

If isnull(lsLoc) Then
	This.Setfocus()
	This.SetColumn("l_code")
	iscurrvalcolumn = "l_code"
	return "Location can not be null!"
End If

If len(trim(lsLoc)) > 10 Then
	This.Setfocus()
	This.SetColumn("l_code")
	iscurrvalcolumn = "l_code"
	Return "Location is > 10 Characters"
End If

Select Count(*) into :llCount
FRom Location
Where wh_code = :lsWarehouse and l_code = :lsLoc;

If llCOunt <= 0 Then 
	This.Setfocus()
	This.SetColumn("l_code")
	iscurrvalcolumn = "l_code"
	Return "Invalid Location Code"
End If

//Check for duplicate Putaway record
Select COunt(*) into :llCOunt
From receive_putaway
Where ro_no = :lsRONO and sku = :lsSku and l_code = :lsLoc and lot_no = :lsLot and po_no = :lsPOno and po_no2 = :lsPono2;

If llCount > 0 Then /*loc not found*/
	This.Setfocus()
	This.SetColumn("l_code")
	iscurrvalcolumn = "l_code"
	Return "A putaway record already exists for this SKU/Location/Pallet/Carton/Time Stamp."
End If
iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llqty,	&
		llNew,	&
		llUpd
		
String	lsErrText,	&
			lsRoNO,		&
			lsSKU,		&
			lsLot,		&
			lsPONO,		&
			lsPONO2,		&
			lsLoc,		&
			lsInvType,	&
			lsSupplier,	&
			lsCOO,		&
			lsOrdStatus,	&
			lsUser1,			&
			lsUser2
			
Long		llOwnerID,	&
			llLineItem
			
Date		ldToday

ldToday = Today()
llRowCount = This.RowCount()

llNew = 0

isRoNoHold = ''
SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//we only attempt to insert a new putaway record
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsRONO = Upper(left(trim(This.GetItemString(llRowPos,"ro_no")),16))
	lsInvType = Upper(left(trim(This.GetItemString(llRowPos,"inv_type")),1))
	lsSKU = Upper(left(trim(This.GetItemString(llRowPos,"SKU")),50))
	lsLot = Upper(left(trim(This.GetItemString(llRowPos,"lot_no")),20))
	If isNull(lsLot) or lsLot = '' Then lsLot = '-'
	lsPoNo = Upper(left(trim(This.GetItemString(llRowPos,"po_no")),25))
	lsPoNo2 = Upper(left(trim(This.GetItemString(llRowPos,"po_no2")),25))
	If isNull(lsPONo) or lsPoNo = '' Then lsPoNo = '-'
	If isNull(lsPONo2) or lsPoNo2 = '' Then lsPoNo2 = '-'
	lsLoc = Upper(left(trim(This.GetItemString(llRowPos,"l_code")),10))
	lsuser1 = Upper(left(trim(This.GetItemString(llRowPos,"user_Field1")),20))
	lsuser2 = Upper(left(trim(This.GetItemString(llRowPos,"user_Field2")),20))
	llQty = Long(This.GetItemString(llRowPos,"quantity"))
	
	//We need some values from the header and detail records
	If lsRONO <> isronohold then /*only retrieve if ro no has changed*/
	
		Select ord_status 
		Into	 :lsOrdStatus
		From	Receive_Master
		Where	project_id = :gs_project and ro_no = :lsRONO;
	
		If isNull(lsOrdStatus) or lsOrdStatus = '' Then
			This.SetRow(llRowPos)
			This.ScrollToRow(llRowPos)
			lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to retrieve order Header Information for this order!~r~r" + lsErrtext)
			SetPointer(Arrow!)
			Return -1
		Elseif (lsordStatus = 'C' or lsOrdStatus = 'V') Then /*order is complete or void*/
			This.SetRow(llRowPos)
			This.ScrollToRow(llRowPos)
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to update order. Status is Complete or Void")
			SetPointer(Arrow!)
			Return -1
		End If
		
		isRoNohold = lsRoNO
		
	End If /*ro no changed*/
	
	//retrieve necessary detail information - Use group by since there may be same sku diff line items
	Select Min(supp_code), Min(owner_id), Min(country_of_origin), Min(Line_Item_No)
	Into	:lsSupplier, :llOwnerID, :lsCOO, :llLineItem
	FRom Receive_Detail
	Where ro_no = :lsRONO and sku = :lsSKU
	Group By ro_no, sku;
	
	If isNull(lsSupplier) or lsSupplier = '' Then
		This.SetRow(llRowPos)
		This.ScrollToRow(llRowPos)
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to retrieve order detail Information for this order!~r~r" + lsErrtext)
		SetPointer(Arrow!)
		Return -1
	End If
	
	Insert Into Receive_Putaway (ro_no, sku, supp_code, Owner_id, Country_of_origin, l_code, Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2, Sku_parent, Component_ind, Quantity, Component_no, Line_Item_no, User_field1, User_Field2) 
					values (:lsRONO, :lsSKU, :lsSupplier, :llOwnerID, :lsCOO, :lsLoc, :lsInvType, '-', :lsLot, :lsPoNo, :lsPono2, :lsSKU, 'N', :llQty, 0, :llLineItem, :lsUser1, :lsUSer2)
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		This.SetRow(llRowPos)
		This.ScrollToRow(llRowPos)
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to save changes to database!~r~rUse the Validate function to catch these errors before saving.~r~r" + lsErrtext)
		SetPointer(Arrow!)
		Return -1
	Else
		llnew ++
	End If
	
Next

//Update the order status on each Header to reflect that we have generated the Putaway (status = Process)
isRoNoHold = ''
For llRowPos = 1 to llRowCount
	lsRONO = Upper(left(trim(This.GetItemString(llRowPos,"ro_no")),16))
	If lsRONO <> isRoNoHold Then
		
		Update Receive_MAster
		Set ord_status = 'P'
		Where project_id = :gs_project and ro_no = :lsRONO;
		
		isRoNoHOld = lsRONO
		llUpd ++
		
	End If /*diff header*/
Next /*Header*/


Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Receive Orders Updated: " + string(llUpd) + "~r~rNew Putaway Records Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_wd_scanner_ro.create
call super::create
end on

on u_dw_import_wd_scanner_ro.destroy
call super::destroy
end on

