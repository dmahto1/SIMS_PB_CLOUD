$PBExportHeader$u_dw_pulse_import_pull.sru
$PBExportComments$Import Pulse Pull (Delivery) Order
forward
global type u_dw_pulse_import_pull from u_dw_import
end type
end forward

global type u_dw_pulse_import_pull from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_pulse_import_pull"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_pulse_import_pull u_dw_pulse_import_pull

forward prototypes
public function integer wf_save ()
public function string wf_get_supplier (string assku, long alowner)
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();Long	llRowCount, llRowPos, llUpdate, llNew,	llOwner,	llLineItem,	llCount
		
Decimal	ldQty, ldNewQty, ldExistQty, ldDoNo
			
String	lsSku, lsQty, lsUOM, lsCust, lsSUpplier, lsCustSave, lsCustOrder, lsOrderNo,lsDoNO,				&
			lsErrText, lsSQL, lsCustName, lsAddr1,	lsAddr2, lsAddr3,	lsAddr4,	lsCity, lsState,			&
			lsZip, lsCountry, lsSaveFile, lsRPOLine, lsRPONbr, lsRPO, lsCommCode, lsContractNo
			
DateTime		ldToday

Integer	liTraderID, liFactoryID, liContractOwnerID	

ldToday = DateTime(Today(),Now())
llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

//For each import row - either update or add a  Delivery Order

// *** 07/10 - PCONKL - doing each insert/update in it's own transaction to hopefully reduce locking ***

//Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
		
	//Create/Update the Delivery Master Record
	
	lsOrderNo = This.GetITemString(llRowPos,'order_nbr')
	lsSKU = This.GetITemString(llRowPos,'SKU')
	lsUOM = This.GetITemString(llRowPos,'UOM')
	lsRPOLine = This.GetITemString(llRowPos,'RPO_Line')
	lsRPONbr = This.GetITemString(llRowPos,'RPO_Number')
	lsCommCode = This.GetITemString(llRowPos,'cccode3')
	lsContractNo = This.GetITemString(llRowPos,'contract_no')
	ldQty = Dec(This.GetITemString(llRowPos,'qty'))
	liTraderID = Long(This.GetITemString(llRowPos,'trader_id'))
	liFactoryID = Long(This.GetITemString(llRowPos,'factory_id'))
	liContractOwnerID = Long(This.GetITemString(llRowPos,'contract_Owner_ID'))
	
	llLineItem = llRowPos
	
	lsCust = This.GetITemString(llRowPos,'Plant')
	
	If isnull(lsUOM) or lsUOM = '' Then lsUOM = 'EA'
	
	//08/03 - PCONKL - Concat RPO Line and RPO Number into Detail User Field 2
	If isNull(lsRPOLine) then lsRPOLine = ''
	If isNull(lsRPONBR) then lsRPONBR = ''
	lsRPO = lsRPONbr + '/' + lsRPOLine
	
	//If Customer Changed, retrieve Cust Info and Owner (plant is Customer and Owner)
	If lsCust <> lsCustSave Then 	
		
		Select Owner_id 
		Into	:llOwner
		From Owner
		Where Project_id = :gs_project and owner_Type = 'C' and owner_cd = :lsCust;
		
		Select Cust_Name, address_1, address_2, address_3, address_4, city, state, zip, country
		Into	:lsCustName, :lsAddr1, :lsaddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry
		From Customer
		Where Project_id = :gs_project and Cust_code = :lsCust;
		
		lsCustSave = lsCust

	End If /*cust Changed */
	
	//See if this Order already exists (in a non completed status)
	Select Max(do_no)
	Into	:lsDoNo
	From Delivery_Master
	Where Project_id = :gs_project and invoice_no = :lsOrderNO and ord_status Not In( 'C', 'D', 'V');
	
	If lsDoNo > '' Then /*order exists - update detail*/
	
		//If the detail row already exists, add the new qty to the existing qty -
		Select Count(*)
		Into	:llCount
		From Delivery_Detail
		Where do_no = :lsdONO and sku = :lsSKU;
		
		If llCount > 0 Then /*Row Exists*/
		
			ldExistQty = 0
			
			Select Sum(req_qty)
			Into	:ldExistQty
			From Delivery_Detail
			Where do_no = :lsdONO and sku = :lsSKU;
			
			If (ldExistQty > 0) and (Not isnull(ldExistQty)) Then
				ldNewQty = ldExistQty + ldQty
			Else
				ldNewQty = ldQty
			End If
					
			Execute Immediate "Begin Transaction" using SQLCA;
			
			Update Delivery_Detail
			Set	req_qty = :ldNewQty
			Where do_no = :lsdONO and sku = :lsSKU 
			Using SQLCA;
			
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "Rollback" using SQLCA;
				Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to update Delivey Detail record to database!~r~r" + lsErrText)
				SetPointer(Arrow!)
				Return -1
			Else
				Execute Immediate "Commit" using SQLCA;
			End If
		
		Else /*add a new detail row for this sku/Line Item*/
			
			//Default the supplier to one that we have inventory if present
			lsSupplier = wf_get_supplier(lsSku, llOwner)
			If lsSupplier = '' Then lsSupplier = 'SS'
			
			//Insert the Delivery DEtail Record 
			
			Execute Immediate "Begin Transaction" using SQLCA;
			
			Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty,  uom, line_Item_no, User_Field2,
													Contract_No, Commodity_Code)
			Values							(:lsdoNo, :lsSKU,:lsSupplier, :llOwner, :lsSKU, :ldQty, 0,:lsUOM,:llLineItem, :lsRPO,
													:lsContractNo, :lsCommCode) 
			Using SQLCA;
		
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "Rollback" using SQLCA;
				Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
				SetPointer(Arrow!)
				Return -1
			Else
				Execute Immediate "Commit" using SQLCA;
			End If	
		
		End If
		
		llUpdate ++
	
	Else /*create a new header/detail*/
		
		//Insert a new Delivery MAster Record
		
		//Get the next available DONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO)//get the next available DO_NO
		lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 
						
		//Include Right most 30 char of Import File name in UF8 so that we can validate that it hasn't been imported more than once
		lsSaveFile = Right(w_import.isImportFile,30)
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,
						Cust_code, Cust_Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
						wh_code,invoice_no,Freight_Cost,User_field8, Trader_ID, Factory_ID, Contract_Owner_ID, LAst_user,LASt_Update)
		Values (:lsDONO,:gs_project,:ldToday,'N','P','N',
					:lsCust, :lsCustName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry,
					:gs_default_wh,:lsOrderNo,0,:lsSaveFile, :liTraderID, :liFactoryID, :liContractOWnerID, :gs_userid,:ldToday)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "Rollback" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Master record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		Else
			Execute Immediate "Commit" using SQLCA;
		End If	
		
		//Insert the Delivery DEtail Record 
		
		//Default the supplier to one that we have inventory if present
		lsSupplier = wf_get_supplier(lsSku, llOwner)
		If lsSupplier = '' Then lsSupplier = 'SS'
			
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty,  uom, line_Item_no, User_Field2,
													Contract_No, Commodity_Code)
		Values							(:lsdoNo, :lsSKU,:lsSupplier, :llOwner, :lsSKU, :ldQty, 0,:lsUOM,:llLineItem, :lsRPO,
													:lsContractNo, :lsCommCode) 
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "Rollback" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		Else
			Execute Immediate "Commit" using SQLCA;
		End If	
		
		llNew ++
		
	End If
	
Next /*Next Import Row*/

//Commit Using Sqlca;
//If sqlca.sqlcode <> 0 Then
//	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
//	Return -1
//End If

MessageBox("Import","Records saved.~r~rDelivery Orders Added: " + String(llNew) + "~r~rDelivery Orders Updated: " + String(llUpdate))
w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

public function string wf_get_supplier (string assku, long alowner);
String	lsSupplier

//either return the first supplier for this sku/OWner that has inventory, or if no inventory, the first supplier for this SKU

Select Min(supp_code) into :lsSupplier
from Content
Where Project_id = :gs_project and SKU = :asSKU and owner_id = :alOwner
Using SQLCA;

If lsSUpplier > ' ' Then
	
Else /*No Inventory*/
	
	Select Min(supp_code) into :lsSupplier
	From Item_MAster
	Where Project_id = :gs_project and SKU = :asSKU
	Using SQLCA;

End If

If isNull(lsSupplier) Then lsSupplier = ''

Return lsSupplier
end function

public function string wf_validate (long al_row);// 12/02 PCONKL - Validate Pull order for Pulse

String	lsPlant,	&
			lsSKU,		&
			lsInvoice,	&
			lsQTY, lsID
			
Long		llCount

//Order Number is Required
lsInvoice = This.GetITemString(al_row,'order_nbr')
If Isnull(lsInvoice) or lsInvoice = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('order_nbr')
	return "'Order Number' is Required"
End If

//Customer ID (Plant) must be present and valid*/
lsPlant = This.GetITemString(al_row,'plant')
If Isnull(lsPlant)  or lsPlant = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('plant')
	return "'Plant' is Required"
End If

Select Count(*) into :llCount
From Customer
Where project_id = :gs_Project and cust_code = :lsPlant;

If llCount < 1 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('plant')
	return "'Plant' is Invalid."
End If

//SKU is Required
lsSKU = This.GetITemString(al_row,'SKU')
If len(lsSKU) < 1 or lsSKU = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU' is Required"
End If

//SKU must be valid 
Select Count(*) into :llCount
From Item_MASter
Where project_id = :gs_Project and sku = :lsSKU;

If llCount < 1 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('SKU')
	return "'SKU is Invalid. "
End If

//Qty must be present and Numeric
lsQTY =  This.GetITemString(al_row,'QTY')
If lsQTY > '' Then
	If Not isNumber(lsQTY) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('qty')
		return "'QTY' must be numeric"
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('qty')
	return "'QTY' is Required."
End If

// 12/03 - PCONKL - CCC fields are required

//Trader ID must be present and Numeric
lsID =  This.GetITemString(al_row,'Trader_ID')
If lsID > '' Then
	If Not isNumber(lsID) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Trader_ID')
		return "'Trader ID' must be numeric"
	End If
Else /* Not present*/
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('Trader_ID')
//	return "'Trader ID' is Required."
End If

//Contract Owner ID must be present and Numeric
lsID =  This.GetITemString(al_row,'Contract_Owner_ID')
If lsID > '' Then
	If Not isNumber(lsID) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Contract_Owner_ID')
		return "'Contract Owner ID' must be numeric"
	End If
Else /* Not present*/
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('Contract_Owner_ID')
//	return "'Contract Owner ID' is Required."
End If

//Factory ID must be present and Numeric
lsID =  This.GetITemString(al_row,'Factory_ID')
If lsID > '' Then
	If Not isNumber(lsID) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Factory_ID')
		return "'Factory ID' must be numeric"
	End If
Else /* Not present*/
//	This.SetFocus()
//	This.SetRow(al_row)
//	This.SetColumn('Factory_ID')
//	return "'Factory ID' is Required."
End If


iscurrvalcolumn = ''
return ''

end function

on u_dw_pulse_import_pull.create
call super::create
end on

on u_dw_pulse_import_pull.destroy
call super::destroy
end on

