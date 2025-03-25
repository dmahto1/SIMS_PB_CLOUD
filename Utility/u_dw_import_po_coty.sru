HA$PBExportHeader$u_dw_import_po_coty.sru
$PBExportComments$PO Import format for COTY
forward
global type u_dw_import_po_coty from u_dw_import
end type
end forward

global type u_dw_import_po_coty from u_dw_import
integer width = 4384
integer height = 1700
string dataobject = "d_import_po_coty"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_po_coty u_dw_import_po_coty

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSupplier, lsgroup, lsSKU, lsTEMP
long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case isCurrValColumn
	Case "supp_invoice_no"
		goto lord_type
	case "ord_type"
		goto lsupp_code
	case "supp_code"
		goto lvendor_desc
	case "vendor_desc"
		goto lline_item_no
	case "line_item_no"
		goto lship_ref
	case "ship_ref"
		goto lsku
	case "sku"
		goto lexpected_date
	case "expected_date"
		goto lord_qty
	case "ord_qty"
		goto lrec_qty
	case "rec_qty"
		goto ldue_qty
		isCurrValColumn = ''
		return ''
End Choose

//Validate Supp_invoice_no
If isnull(This.getItemString(al_row, "Supp_invoice_no")) Then
	This.Setfocus()
	This.SetColumn("Supp_invoice_no")
	iscurrvalcolumn = "Supp_invoice_no"
	return "'Order Number' can not be null!"
End If

lord_type:
//If isnull(This.getItemString(al_row, "ord_type")) Then
If isnull(This.getItemString(al_row, "ord_type")) or (This.getItemString(al_row, "ord_type") <> 'PO' and This.getItemString(al_row, "ord_type") <> 'IT') Then
	This.Setfocus()
	This.SetColumn("ord_type")
	iscurrvalcolumn = "ord_type"
	return "'Order Type' must be 'IT' or 'PO'!"
End If
lsupp_code:
lvendor_desc:
lline_item_no:
If isnull(This.getItemString(al_row, "line_item_no")) Then
	This.Setfocus()
	This.SetColumn("line_item_no")
	iscurrvalcolumn = "line_item_no"
	return "'Line Item' can not be null!"
End If
lship_ref:

lsku:
lsSKU = trim(This.getItemString(al_row, "sku"))
if isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "'SKU' can not be null!"
End If

If len(lsSKU) > 50 Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "'SKU' is > 50 characters"
End If

lsTEMP = ''
select SKU into :lsTEMP
from item_master
where project_id = :gs_Project
and sku = :lsSKU;

if lsTEMP = '' then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "Item '" + lsSKU + "' not in Item Master."
End If

lexpected_date:
lsTEMP = This.getItemString(al_row, "expected_date")
If isnull(lsTEMP) or not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("expected_date")
	iscurrvalcolumn = "expected_date"
	return "'Expected Date' can not be null and must be a date!"
End If

lord_qty:
lrec_qty:
ldue_qty:
lsTEMP = This.getItemString(al_row, "due_qty")
//If isnull(lsTEMP) or not isnumber(lsTEMP) Then
If isnull(lsTEMP) or not double(lsTEMP) > 0 Then
	This.Setfocus()
	This.SetColumn("due_qty")
	iscurrvalcolumn = "due_qty"
	return "'Due Qty' can not be null and must be > 0!"
End If

/*
lsupplier:
//Validate Supplier
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

		If len(trim(This.getItemString(al_row,"supplier_id"))) > 10 Then
			This.Setfocus()
			This.SetColumn("supplier_id")
			iscurrvalcolumn = "supplier_id"
			Return "Supplier ID is > 10 Characters"
		End If
		
	End If /*Supplier Present*/
*/

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long		llRowCount,	llRowPos, llNew, llLines, llOwner

integer 	liOldOrder
		
String	lsSuppInvoice, lsOrdType, lsSupplier, lsSuppName, lsLineItemNo, lsShipRef, lsSku

String	lsExpectedDate, lsReqQty, lsSQL, lsErrText

string	lsPrevInvoice, lsPrevShipRef, lsRONO

decimal 	ldReqQty, ldRONO

Datetime		ldToday

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( gs_default_wh ) 
//ldToday = Today()

llRowCount = This.RowCount()
this.SetSort("Supp_Invoice_No, expected_date")
this.sort()

//llNew = 0

SetPointer(Hourglass!)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

/*Get owner id for COTY
	- Not tracking owner at this time */
Select owner_id into :llOwner
From owner
Where  project_id = 'COTY' and owner_cd = 'COTY';

//messagebox("TEMPO!", "Caused a lock????!")

//Update or Insert for each Row...
For llRowPos = 1 to llRowCount
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	/* COTY will have multiple shipments with the same Order Number.
		- we'll create a distinct Receipt for each Order/Date combination (actually, Orig/Dest/Order/Date)
		- Not using Coty's Shipment_Number. May want to concatenate it with Expected_date for RM.Ship_Ref
	*/
	lsSuppInvoice = left(trim(This.GetItemString(llRowPos, "supp_invoice_no")), 50)
	//lsShipRef = left(trim(This.GetItemString(llRowPos, "ship_ref")), 10)
	//lsExpectedDate = left(trim(This.GetItemString(llRowPos, "expected_date")), 10)
	lsShipRef = left(trim(This.GetItemString(llRowPos, "expected_date")), 10)

	//if lsSuppInvoice <> lsPrevInvoice and lsShipRef <> lsPrevShipRef then
	if lsSuppInvoice + lsShipRef <> lsPrevInvoice + lsPrevShipRef then
		//New order/shipment (in the file)
		//if lsSuppInvoice < lsPrevInvoice then
		if lsSuppInvoice + lsShipRef < lsPrevInvoice + lsPrevShipRef then
			messagebox("PO Import", "Import file must be sorted by Order Number, then by Expected Date!")
			return 0
		end if
		//Check to see if Order Exists!!
		liOldOrder = 0
		select count(ro_no) into :liOldOrder
		from Receive_Master		
		where project_id = :gs_project
		and supp_invoice_no = :lsSuppInvoice
		and ship_ref = :lsShipRef;
	
		//if not OrderExists then
		if liOldOrder = 0 then 	//Order does not exist...
			//set header variables...
			lsOrdType = left(trim(This.GetItemString(llRowPos, "ord_type")), 2)
			//Ord_type must be either 'I' or 'S' (but come in as 'IT' or 'PO')
			if lsOrdType = 'PO' then
				lsOrdType = 'S'
			else
				lsOrdType = 'I'
			end if
			//lsSupplier = left(trim(This.GetItemString(llRowPos, "supp_code")), 10)
			//Not tracking Supplier at this time
			lsSupplier = 'COTY'		
			//vendor_desc
			
	
	//		Insert Into item_master (project_id, sku, owner_id, country_of_origin_default, description, alternate_sku, supp_code, grp, User_Field14, UOM_1, Length_1, Width_1, Height_1, UOM_2, Length_2, Width_2, Height_2, QTY_2, UOM_3, QTY_3, last_user, last_update) 
	//		values (:gs_project, :lsSku, :llOwner, 'XXX', :lsDesc, :lsACSku, :lsSupplier, :lsgroup, :lsUF14, :lsUOM1, :ldLength1, :ldWidth1, :ldHeight1, :lsUOM2, :ldLength2, :ldWidth2, :ldHeight2, :ldQTY2, :lsUOM3, :ldQTY3, :gs_userid, :ldToday)
	//		Using SQLCA;
	
			lsPrevInvoice = lsSuppInvoice
			lsPrevShipRef = lsShipRef
			//GetNextSequence for RO_NO
			sqlca.sp_next_avail_seq_no(gs_project, "Receive_Master", "RO_No" , ldRONO)
			lsRONO = gs_Project + String(Long(ldRONo),"000000") 

			//6/21/07 - setting edi_batch_seq_no to -1 to indicate it was imported via this utility...
			insert into receive_master(ro_no, project_id, ord_date, Ord_Status, ord_type, Inventory_Type, WH_Code, Supp_Code, supp_invoice_no, Ship_Ref, last_User, last_update, edi_batch_seq_no)
			values(:lsRONO, 'COTY', getdate(), 'N', :lsOrdType, 'N', 'COTY-WARSA', :lsSupplier, :lsSuppInvoice, :lsShipRef, 'DTS', getdate(), -1)
			Using SQLCA;
	//get the user
	
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "ROLLBACK" using SQLCA;
				Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
				SetPointer(Arrow!)
				Return -1
			Else
				llnew ++
			End If
		End If //Order does not exist
	end if  //is order same as previous line
	
	if liOldOrder = 0 then
		//Insert Line (TEMPO! - actually, only insert lines if this is a new order)
		lsLineItemNo = left(trim(This.GetItemString(llRowPos, "line_item_no")), 10)
	
		lsSku = left(trim(This.GetItemString(llRowPos, "sku")), 50)
		//ord_qty
		//rec_qty
		ldReqQty = dec(This.GetItemString(llRowPos, "due_qty"))
//messagebox("TEMPO!", "Order: " + lsSuppInvoice + " - " + lsShipRef + ", Line: " + lsLineItemNo + ", PrevOrder: " + lsPrevInvoice)
		insert into receive_Detail(ro_no, SKU, Supp_Code, Owner_id, Country_Of_Origin, Alternate_sku, Line_Item_no, req_qty)
		values(:lsRONO, :lsSku, :lsSupplier, :llOwner, 'XXX', :lsSku, :lsLineItemNo, :ldReqQty)
		Using SQLCA;
	//get the user
	
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Unable to save changes to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		Else
			llLines ++
		End If
	end if
	
Next

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import", "Records saved.~r~rNew Orders: " + String(llNew) + "~r~rNew Lines: " + String(llLines))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_po_coty.create
call super::create
end on

on u_dw_import_po_coty.destroy
call super::destroy
end on

