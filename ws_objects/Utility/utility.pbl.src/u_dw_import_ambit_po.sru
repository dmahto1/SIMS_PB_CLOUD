$PBExportHeader$u_dw_import_ambit_po.sru
$PBExportComments$Import Ambit PO
forward
global type u_dw_import_ambit_po from u_dw_import
end type
end forward

global type u_dw_import_ambit_po from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_ambit_po"
end type
global u_dw_import_ambit_po u_dw_import_ambit_po

type variables
String	isRoNoHold, isSKUHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSKU, lsWarehouse, lsOrderNo
			
Long		llCount


//Validate Warehouse (first row only)
If al_row = 1 Then
	
	lswarehouse = Trim(This.getItemString(al_row,"wh_Code"))

	If isnull(lswarehouse) Then
		This.Setfocus()
		This.SetColumn("wh_Code")
		iscurrvalcolumn = "wh_Code"
		return "'Warehouse must be present in the first row!"
	End If

	Select COUNT(*)
	Into	:llCount
	FRom warehouse
	Where wh_Code = :lswarehouse;
		
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("wh_Code")
		iscurrvalcolumn = "wh_Code"
		return "'Invalid Warehouse"
	End If
	
End IF /* First Row */

//Validate Order Number (first row only)
If al_row = 1 Then
	
	lsOrderNo = Trim(This.getItemString(al_row,"order_no"))

	If isnull(lsOrderNo) Then
		This.Setfocus()
		This.SetColumn("order_no")
		iscurrvalcolumn = "order_no"
		return "'Order Nbr must be present in the first row!"
	End If

	Select COUNT(*)
	Into	:llCount
	FRom Receive_Master
	Where Project_ID = :gs_Project and Supp_invoice_no = :lsOrderNo;
		
	If llCount > 0 Then
		This.Setfocus()
		This.SetColumn("order_no")
		iscurrvalcolumn = "order_no"
		return "'This Order Number already exists. (This file has already been imported)"
	End If
	
End IF /* First Row */
	
//Validate SKU  - If Changed
lsSKU = Trim(This.getItemString(al_row,"SKU"))

If isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "SKU can not be null!"
End If

If lsSKU <> isSKUHold Then
	
	Select COUNT(*)
	Into	:llCount
	FRom Item_Master
	Where Project_id = :gs_Project and sku = :lsSKU;
		
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("sku")
		iscurrvalcolumn = "sku"
		return "'Invalid SKU"
	End If
	
End If /* Sku Changed*/

isSKUHold = lsSKU


REturn ''








end function

public function integer wf_save ();Long	llRowCount,	llRowPos, llqty, llNewDetail,	llNewPutaway, llOwnerID, llLineItem,	&
		llPalletQty, llSKUQty
		
String	lsErrText, lsRONO, lsSKU, lsSKUHold, lsLot, lsLotHold, lsPONO, lsPoNoHold, &
			lsSupplier, lsOrderNo,  lsWarehouse
			
Decimal	ldRONo
			
DateTime		ldToday

llNewDetail = 0
llNewPutaway = 0
llPalletQty = 0
llSKUQty = 0
llLineItem = 1

llRowCount = This.RowCount()
If llRowCount <= 0 Then Return 0

lsOrderNo = This.GetItemString(1,'order_no')
lsWarehouse = This.GetItemString(1,'wh_Code')

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( lsWarehouse ) 

SetPointer(Hourglass!)

//Get the default owner for Ambit
Select Owner_ID into :llOwnerID
From OWner
Where PRoject_id = :gs_Project and Owner_CD = 'Ambit' and OWner_type = 'S';

//Get the next available RONO
sqlca.sp_next_avail_seq_no(gs_project,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
lsRoNO = gs_Project + String(Long(ldRoNo),"000000") 

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Create the Receive Master Record - Only one order per import file
Insert Into Receive_Master (ro_no, project_id, Ord_date, Ord_status, Ord_type, Inventory_Type, wh_Code,
										Supp_code, Supp_Invoice_No, LAst_User, Last_Update)
		Values					(:lsRONO, :gs_Project, :ldToday, 'N', 'S', 'N', :lsWarehouse,
										'AMBIT', :lsOrderNo, :gs_userid, :ldToday)
Using SQLCA;

If sqlca.sqlcode <> 0 Then
	This.SetRow(llRowPos)
	This.ScrollToRow(llRowPos)
	lsErrText = sqlca.sqlerrtext /*error text lost in rollback*/
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox("Import","Unable to Save new Receive Order header Record to Database.~r~r" + lsErrtext)
	SetPointer(Arrow!)
	Return -1
End If

//For Each Record
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
		
	lsSKU = Upper(left(trim(This.GetItemString(llRowPos,"SKU")),50))
	lsLot = Upper(left(trim(This.GetItemString(llRowPos,"lot_no")),20))
	If isNull(lsLot) or lsLot = '' Then lsLot = '-'
	lsPoNo = Upper(left(trim(This.GetItemString(llRowPos,"po_no")),25))
	If isNull(lsPONo) or lsPoNo = '' Then lsPoNo = '-'
	
	//Each Import Row is a qty of 1 - we are rolling up to Pallet/Carton level (multiple Mac ID/Serial NO per Carton)
	// 05/04 - PCONKL - Only rolling up to Pallet level now
	
	//If the Pallet (lot_no) Changes, write the Previous Putaway Record.
	If (lsLot <> lsLotHold) and llRowPos > 1 Then
		
			Insert Into Receive_Putaway (ro_no, sku, supp_code, Owner_id, Country_of_origin,  Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2, Sku_parent, Component_ind, Quantity, Component_no, Line_Item_no, l_Code) 
						values (:lsRONO, :lsSKUHold, 'AMBIT', :llOwnerID, 'XXX', "N", '-', :lsLotHold, '-', '-', :lsSKUHold, 'N', :llPalletQty, 0, :llLineItem, "")
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
				llnewPutaway ++
			End If
			
			llPalletQty = 0
		
	End If /* Carton (po_no) Changed */
	
	
	//If the SKU Changes, write the Previous Detail Record.
	If (lsSKU <> lsSKUHold) and llRowPos > 1 Then
				
		Insert Into Receive_Detail (ro_no, SKU, Supp_code, Owner_ID, Country_of_Origin, Alternate_SKU, Req_Qty,
												Alloc_QTY, Damage_Qty, UOM, Line_Item_No, USer_Line_Item_No)
		Values							(:lsRoNo, :lsSKUHold, 'Ambit', :llOwnerID, 'XXX', :lsSKUHold, :llSKUQty,
												0,0, 'EA', :llLineItem, :llLineItem)
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
			llnewDetail ++
		End If
		
		llSKUQty = 0
		llLineItem ++
		
	End If /* SKU Changed */
	
	//add current row to Carton and Line ITem Qty
	llPalletQty ++
	llSkuQty ++
		
	lsSKUHold = lsSKU
	lsLotHold = lsLot
	lsPONOHold = lsPONO
	
Next /*Import Row */

//Insert the last Detail/Putaway Record.
Insert Into Receive_Putaway (ro_no, sku, supp_code, Owner_id, Country_of_origin,  Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2, Sku_parent, Component_ind, Quantity, Component_no, Line_Item_no, l_Code) 
values 							(:lsRONO, :lsSKU, 'AMBIT', :llOwnerID, 'XXX', "N", '-', :lsLot, '-', '-', :lsSKU, 'N', :llPalletQty, 0, :llLineItem, "")
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
	llnewPutaway ++
End If

Insert Into Receive_Detail (ro_no, SKU, Supp_code, Owner_ID, Country_of_Origin, Alternate_SKU, Req_Qty,
									Alloc_QTY, Damage_Qty, UOM, Line_Item_No, USer_Line_Item_No)
Values							(:lsRoNo, :lsSKUHold, 'Ambit', :llOwnerID, 'XXX', :lsSKUHold, :llSKUQty,
												0,0, 'EA', :llLineItem, :llLineItem)
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
	llnewDetail ++
End If
		

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Receive Orders Created: 1" + "~r~rNew Detail Records Added: " + String(llNewDetail) + "~r~rNew Putaway Records Added: " + String(llNewPutaway))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_ambit_po.create
call super::create
end on

on u_dw_import_ambit_po.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
This.Sort()
// pvh - 01/21/06
return 0
end event

