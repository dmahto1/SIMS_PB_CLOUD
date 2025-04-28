HA$PBExportHeader$u_dw_import_wd_scanner_do.sru
$PBExportComments$Import Western Digial Scanner Delivery Order
forward
global type u_dw_import_wd_scanner_do from u_dw_import
end type
end forward

global type u_dw_import_wd_scanner_do from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_wd_scanner_do"
end type
global u_dw_import_wd_scanner_do u_dw_import_wd_scanner_do

type variables
String	isRoNoHold,	&
			isdonoHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsdono,	&
			lsdonowork,	&
			lsOrdStatus,	&
			lsSKU,			&
			lsLoc,	&
			lsWarehouse,	&
			lsInvoice,		&
			lsCarton
			
Long		llCount

//Validate for valid field length and type

//Validate DO_NO
lsdono = Trim(This.getItemString(al_row,"do_no"))

If isnull(lsdono) Then
	This.Setfocus()
	This.SetColumn("do_no")
	iscurrvalcolumn = "do_no"
	return "'DO NO' can not be null!"
End If

If len(trim(lsdono)) > 16 Then
	This.Setfocus()
	This.SetColumn("do_no")
	iscurrvalcolumn = "Do_no"
	return "'DO NO' is > 16 characters"
End If

//check for valid Order and not complete or Void
	
Select do_no, ord_status, wh_code, invoice_no
Into	:lsdonoWork, :lsOrdStatus, :lsWarehouse, :lsInvoice
From	Delivery_master
Where Project_id = :gs_project and do_no = :lsdono;

If isNull(lsdonoWork) or lsdonoWork = '' Then /* do not found*/
	This.Setfocus()
	This.SetColumn("do_no")
	iscurrvalcolumn = "do_no"
	return "DO NO not found"
End If /* RO not found */

//validate order status
If lsOrdStatus = 'C' or lsOrdStatus = 'V' Then
	This.Setfocus()
	This.SetColumn("do_no")
	iscurrvalcolumn = "do_no"
	return "'This order is either complete or Void and can not be updated."
End If /*complete or void*/
		
//Validate Invoice No
If isnull(This.getItemString(al_row,"invoice_no")) Then
	This.Setfocus()
	This.SetColumn("invoice_no")
	iscurrvalcolumn = "invoice_no"
	return "'Invoice NO' can not be null!"
End If

If len(trim(This.getItemString(al_row,"invoice_no"))) > 20 Then
	This.Setfocus()
	This.SetColumn("invoice_no")
	iscurrvalcolumn = "Invoice_no"
	return "'Invoice NO' is > 20 characters"
End If
	
If Trim(lsInvoice) <> Trim(This.getItemString(al_row,"invoice_no")) Then /*inoivce no not for this do No*/
	This.Setfocus()
	This.SetColumn("invoice_no")
	iscurrvalcolumn = "Invoice_no"
	return "This Invoice Number is not correct for this DO NO."
End If

//Validate Carton NO
lsCarton= Trim(This.getItemString(al_row,"carton_no"))
If isnull(lsCArton) Then
	This.Setfocus()
	This.SetColumn("carton_no")
	iscurrvalcolumn = "carton_no"
	return "'Carton NO' can not be null!"
End If

If len(trim(This.getItemString(al_row,"carton_no"))) > 25 Then
	This.Setfocus()
	This.SetColumn("carton_no")
	iscurrvalcolumn = "carton_no"
	return "'Carton NO' is > 25 characters"
End If

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

// validaete existence of Picking record
Select Count(*)
Into	:llCOunt
From	Delivery_Picking
Where do_no = :lsdono and sku = :lsSKU;

If llCount <= 0 Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	Return "No Delivery Picking record found for this Order/SKU"
End If /* order detail does not exist*/

//Validate Qty
If not isnumber(This.getItemString(al_row,"quantity")) Then
	This.Setfocus()
	This.SetColumn("quantity")
	iscurrvalcolumn = "quantity"
	Return "Qty is not numeric"
End If


//Check for duplicate Packing record
Select COunt(*) into :llCOunt
From Delivery_Packing
Where do_no = :lsdono and sku = :lsSku and carton_no = :lsCarton;

If llCount > 0 Then /*loc not found*/
	This.Setfocus()
	This.SetColumn("do_no")
	iscurrvalcolumn = "do_no"
	Return "A Delivery Packing record already exists for this Order/SKU/Carton."
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
			lsdoNO,		&
			lsSKU,		&
			lsSupplier,	&
			lsCOO,		&
			lsCarton
			
Long		llOwnerID,	&
			llLineItem
			
Date		ldToday

ldToday = Today()
llRowCount = This.RowCount()

llNew = 0

isdonoHold = ''
SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//we only attempt to insert a new packing record
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsDONO = Upper(left(trim(This.GetItemString(llRowPos,"do_no")),16))
	lsSKU = Upper(left(trim(This.GetItemString(llRowPos,"SKU")),50))
	lsCarton = Upper(left(trim(This.GetItemString(llRowPos,"carton_no")),25))
	llQty = Long(This.GetItemString(llRowPos,"quantity"))
		
	//retrieve necessary pick list information - use group by and Min since we may have multiple rows that match criteria.
	Select min(supp_code), Min(owner_id), Min(country_of_origin), Min(Line_Item_No)
	Into	:lsSupplier, :llOwnerID, :lsCOO, :llLineItem
	FRom Delivery_Picking
	Where do_no = :lsdono and sku = :lsSKU
	Group By do_no, sku;
	
	If isNull(lsSupplier) or lsSupplier = '' Then
		This.SetRow(llRowPos)
		This.ScrollToRow(llRowPos)
		lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error exists in row " + string(llRowPos) +  ". Unable to retrieve Pick List Information for this order!~r~r" + lsErrtext)
		SetPointer(Arrow!)
		Return -1
	End If
	
	Insert Into Delivery_Packing (do_no, carton_no, sku, supp_code, country_of_origin, quantity, line_item_no) 
					values (:lsdono, :lsCarton, :lsSKU, :lsSupplier,  :lsCOO, :llQty, :llLineItem)
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

//Update the order status on each Header to reflect that we have generated the Packing (status = Packing)
isdoNoHold = ''
For llRowPos = 1 to llRowCount
	lsdoNO = Upper(left(trim(This.GetItemString(llRowPos,"do_no")),16))
	If lsDONO <> isdoNoHold Then
		
		Update Delivery_MAster
		Set ord_status = 'A'
		Where project_id = :gs_project and do_no = :lsDONO;
		
		isdoNoHOld = lsDONO
		llUpd ++
		
	End If /*diff header*/
Next /*Header*/

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Delivery Orders Updated: " + string(llUpd) + "~r~rNew Packing Records Added: " + String(llNew))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_wd_scanner_do.create
call super::create
end on

on u_dw_import_wd_scanner_do.destroy
call super::destroy
end on

