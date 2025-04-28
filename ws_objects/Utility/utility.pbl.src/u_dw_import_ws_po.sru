$PBExportHeader$u_dw_import_ws_po.sru
$PBExportComments$Import Wine and Spirit PO
forward
global type u_dw_import_ws_po from u_dw_import
end type
end forward

global type u_dw_import_ws_po from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_ws_po"
end type
global u_dw_import_ws_po u_dw_import_ws_po

type variables
String is_bonded_wh, isskuHold
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);String	lsSKU, lsWarehouse, lsOrderNo, lsSupplier, lsUom_1, lsUom_2, lsUOM, lstemp, lsOwner
			
Long		llCount


//Validate Warehouse (first row only)
If al_row = 1 Then
	
	lswarehouse = Trim(This.getItemString(al_row,"warehouse"))

	If isnull(lswarehouse) Then
		This.Setfocus()
		This.SetColumn("warehouse")
		iscurrvalcolumn = "warehouse"
		return "'Warehouse must be present in the first row!"
	End If

	Select COUNT(*), wh_type
	Into	:llCount, :is_bonded_wh
	FRom warehouse
	Where wh_Code = :lswarehouse
	Group By wh_type;
		
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("warehouse")
		iscurrvalcolumn = "warehouse"
		return "'Invalid Warehouse"
	End If
	
End IF /* First Row */

// TAM 2011/06  Validate Owner Code

//Validate SKU  
lsSKU = Trim(This.getItemString(al_row,"SKU"))

If isnull(lsSKU) Then
	This.Setfocus()
	This.SetColumn("sku")
	iscurrvalcolumn = "sku"
	return "SKU can not be null!"
Else
	lsSupplier = This.getItemString(al_row,"supplier")
	llcount=0
	Select COUNT(*), Uom_1, Uom_2
	Into	:llCount, :lsUom_1, :lsUom_2
	FRom Item_Master

	Where Project_id = :gs_Project and sku = :lsSKU and supp_code = :lsSupplier 
	Group By Uom_1, Uom_2;
	
	If llCount <= 0 Then
		This.Setfocus()
		This.SetColumn("sku")
		iscurrvalcolumn = "sku"
		return "'Invalid SKU"
	End If
	
End If /* Sku */

//Validate UOM2
lsuom = This.getItemString(al_row,"uom2")
If  isnull(lsuom) or lsuom = ' ' Then
	This.Setfocus()
	This.SetColumn("uom2")
	iscurrvalcolumn = "uom2"
	Return "UOM is required!"
Else

	If lsUom <> lsUOM_1 and lsuom <> lsUOM_2 Then
		This.Setfocus()
		This.SetColumn("uom2")
		iscurrvalcolumn = "uom2"
		Return "UOM is not valid!"
	End If
		
End If /*UOM Validate*/


isSKUHold = lsSKU

//Schedule date Must be a A Date
lsTEMP = This.getItemString(al_row, "scheduled_date")
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("scheduled_date")
	iscurrvalcolumn = "scheduled_date"
	return "'Scheduled Date' must be a date!"
End If

//Order date Must be a A Date
lsTEMP = This.getItemString(al_row, "order_date")
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("order_date")
	iscurrvalcolumn = "order_date"
	return "'Order Date' must be a date!"
End If

//Expiration date Must be a Date
lsTEMP = This.getItemString(al_row, "Expiration_date")
If not isnull(lsTEMP) and not isdate(lsTEMP) Then
	This.Setfocus()
	This.SetColumn("Expiration_date")
	iscurrvalcolumn = "Expiration_date"
	return "'Expiration Date' must be a date!"
End If

//Validate Supplier
	lsSupplier = This.getItemString(al_row,"supplier")
	If  isnull(lsSUpplier) or lsSupplier = ' ' Then
		This.Setfocus()
		This.SetColumn("supplier")
		iscurrvalcolumn = "supplier"
		Return "Supplier is required!"
	Else
		Select Count(*)  into :llCount
		from Supplier
		Where project_id = :gs_project and supp_code = :lsSupplier
		Using SQLCA;
		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("supplier")
			iscurrvalcolumn = "supplier"
			Return "Supplier is not valid!"
		End If
		
	End If /*Supplier Present*/
	
//TAM 2011/06
//Validate Owner Cd
	lsOwner = This.getItemString(al_row,"Owner_cd")
	If  isnull(lsOwner) or lsOwner = ' ' Then
		This.Setfocus()
		This.SetColumn("Owner_cd")
		iscurrvalcolumn = "Owner_cd"
		Return "Owner is required!"
	Else
		Select Count(*)  into :llCount
		from Owner
		Where project_id = :gs_project and Owner_cd = :lsOwner
		Using SQLCA;
		If llCount <= 0 Then
			This.Setfocus()
			This.SetColumn("Owner_Cd")
			iscurrvalcolumn = "Owner_Cd"
			Return "Owner Code is not valid!"
		End If
	
	End If /*Owner Code*/			
		
	

REturn ''








end function

public function integer wf_save ();Long	llRowCount,	llRowPos, llqty, llNewDetail,	llNewPutaway, llOwnerID, llLineItem,	&
		llqty2, llReqQTY, llUserLineItem
	
		
String	lsErrText, lsRONO, lsSKU, lsLot,  lsPONO, lsPoNo2, &
			lsSupplier, lsOrderNo,  lsWarehouse, lsOwnerCd, lsCOO, lsUOM1, lsUOM2, lslocCode, lsReqUOM, lsReqQTY, lsHSCode, &
			lsPackSize, lsVolume, lsshp_rep, lsInvType
			String ls_user_field5, ls_user_field6 //TAM W&S 05/26/2011 Added two new fields to the import
DateTime ldtScheduled_Date, ldtExpiration_Date, ldtOrd_Date
			
Decimal	ldRONo
			
DateTime		ldToday

llNewDetail = 0
llNewPutaway = 0
llLineItem = 1

llRowCount = This.RowCount()
If llRowCount <= 0 Then Return 0

lsWarehouse = This.GetItemString(1,'warehouse')
//lsOwnerCd = This.GetItemString(1,'owner_Cd')   // TAM W&S 2011/05/25  Move owner code check down to Detail level.
lsSupplier = This.GetItemString(1,'supplier')
lsshp_rep = This.GetItemString(1,'ship_ref')
string lssceddt
lssceddt =  string(This.GetItemString(1,'scheduled_date'), 'YYYYMMDD')
If not isnull(This.GetItemString(1,'scheduled_date'))  Then
//	ldtScheduled_Date = DateTime(Date(String(This.GetItemString(1,'scheduled_date'), 'YYYYMMDD')), time('00:00:00'))
	ldtScheduled_Date = DateTime(Date(This.GetItemString(1,'scheduled_date')), time('00:00:00'))
Else
	ldtScheduled_Date = DateTime(Date('1900/01/01'), time('00:00:00')) 
	
End If

// pvh 02.15.06 - gmt
ldToday = f_getLocalWorldTime( lsWarehouse ) 

If not isnull(This.GetItemString(1,'order_date'))  Then
//	ldtOrd_Date = DateTime(Date(String(This.GetItemString(1,'order_date'), 'YYYY/MM/DD')), time('00:00:00'))
	ldtOrd_Date = DateTime(Date(This.GetItemString(1,'order_date')), time('00:00:00'))
Else
	ldtOrd_Date = ldToday
End If

SetPointer(Hourglass!)

 // TAM W&S 2011/05/25  Move owner code check down to Detail level.

////Get the default owner   
//Select Owner_ID into :llOwnerID
//From OWner
//Where PRoject_id = :gs_Project and Owner_CD = :lsOwnerCd and OWner_type = 'S';

//Get the next available RONO
sqlca.sp_next_avail_seq_no(gs_project,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
lsRoNO = gs_Project + String(Long(ldRoNo),"000000") 


//TAM - W&S 2010/12  -   Order Number is Formatted.  We will not allow entry into this field.  
//Format is (WH_CODE(3rd and 4TH Char)) + "A" + (Year(2 digit)) + (Month(2 Digit)) + (4 Digit Running number from Lookup table) 
// New Baseline.  If the Supplier Invoice code is Not specified as Supplier specific it will return 'NA' and behave like it use to
//Left 3 characters = WS- for Wine and Spirt.
lsOrderNo =  Mid(gs_project,4,2) + '-A' + String(Today,'YYMM') + String(ldRONO,"0000")
	


Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

//Create the Receive Master Record - Only one order per import file
Insert Into Receive_Master (ro_no, project_id, Ord_date, Ord_status, Arrival_Date, Ord_type, Inventory_Type, wh_Code,
										Supp_code, Supp_Invoice_No, LAst_User, Last_Update, Ship_Ref)
		Values					(:lsRONO, :gs_Project, :ldtOrd_Date, 'P', :ldtScheduled_Date, 'S', 'N', :lsWarehouse,
										:lssupplier, :lsOrderNo, :gs_userid, :ldToday, :lsshp_rep )
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

// Non Bonded Warehouse defaults lot No to "DP"
//03-FEB-2016 Madhu- Added code to set Lot No for WS-DP warehouse
	If is_bonded_wh = 'B' OR (Upper(gs_project)='WS-PR' and lsWarehouse='WS-DP' and Not (IsNull(Upper(left(trim(This.GetItemString(llRowPos,"lot_number")),20))))) Then
		lsLot = Upper(left(trim(This.GetItemString(llRowPos,"lot_number")),20))
	Else
		lsLot = 'DP'
	End If 	
	If isNull(lsLot) or lsLot = '' Then lsLot = '-'

	lsPoNo = Upper(left(trim(This.GetItemString(llRowPos,"po_number")),25))
	If isNull(lsPONo) or lsPoNo = '' Then lsPoNo = '-'
	lsPoNo2 = Upper(left(trim(This.GetItemString(llRowPos,"po2_number")),25))
	If isNull(lsPONo2) or lsPoNo2 = '' Then lsPoNo2 = '-'
	
	lsReqUOM = Upper(left(trim(This.GetItemString(llRowPos,"uom2")),10))
	lsReqQty = Upper(left(trim(This.GetItemString(llRowPos,"quantity")),20))
	llReqQTY = dec(This.GetItemString(llRowPos, "quantity"))
	llUserLineItem = dec(This.GetItemString(llRowPos, "line_number"))
	lslocCode = Upper(left(trim(This.GetItemString(llRowPos,"location")),50))
	lsInvType = Upper(left(trim(This.GetItemString(llRowPos,"inventory_type")),1))

//TAM W&S 05/26/2011 Added two new fields to the import
	ls_user_field5 = Upper(left(trim(This.GetItemString(llRowPos,"user_field5")),100))
	ls_user_field6 = Upper(left(trim(This.GetItemString(llRowPos,"user_field6")),100))

 // TAM W&S 2011/05/25  Move owner code check down to Detail level.
	lsOwnerCd = This.GetItemString(llRowPos,'owner_Cd') 
	//Get the default owner 
	Select Owner_ID into :llOwnerID
	From OWner
	Where PRoject_id = :gs_Project and Owner_CD = :lsOwnerCd and OWner_type = 'S';

	If not isnull(This.GetItemString(1,'Expiration_Date'))  Then
//		ldtExpiration_Date = DateTime(String(This.GetItemString(1,'expiration_date'), 'YYYY/MM/DD'))
		ldtExpiration_Date = DateTime(Date(This.GetItemString(llRowPos,'expiration_date')), time('00:00:00'))
	Else
		ldtExpiration_Date = datetime( date( '12/31/2999'),time('23:59:59') )
	End If

	//Get the Values from Item Master
	Select Country_Of_Origin_default, UOM_1, UOM_2, QTY_2, HS_Code, User_Field11, User_Field1 
	into :lsCOO, :lsUOM1, :lsUOM2, :llqty2, :lsHSCode, :lsPackSize, :lsVolume
	From Item_Master
	Where PRoject_id = :gs_Project and SKU = :lsSKU and Supp_code = :lssupplier;
		
//  Calculate Quantity by checking UOM = UOM_2 from Item Master
		If lsUOM2 = lsReqUOM Then 
			llQTY = llReqQty*llqty2
		Else
			llQTY = llReqQty
		End If
		

	// write the  Detail Record.
 //TAM W&S 05/26/2011 Added two new fields to the import
				
		Insert Into Receive_Detail (ro_no, SKU, Supp_code, Owner_ID, Country_of_Origin, Alternate_SKU, Req_Qty, 
												Alloc_QTY, Damage_Qty, UOM, Line_Item_No, USer_Line_Item_No,User_Field1,User_Field2, User_Field3, User_Field4, User_Field5, User_Field6 )
		Values							(:lsRoNo, :lsSKU, :lssupplier, :llOwnerID, :lsCOO, :lsSKU, :llQty,
												:llQty,0, :lsUOM1, :llLineItem, :llUserLineItem, :lsreqqty, :lsrequom, :lsPackSize, :lsVolume, :ls_user_field5, :ls_user_field6)
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
			
			
			
			Insert Into Receive_Putaway (ro_no, sku, supp_code, Owner_id, Country_of_origin,  Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2, Sku_parent, Component_ind, Quantity, Component_no, Line_Item_no, l_Code, user_field2, user_field4, user_field6, Expiration_Date) 
						values (:lsRONO, :lsSKU, :lssupplier, :llOwnerID, :lsCOO, :lsInvType, '-', :lsLot, :lsPoNo, :lsPoNo2, :lsSKU, 'N', :llQTY, 0, :llLineItem, :lsLocCode, :lsVolume, :lsPackSize, :lsHSCode, :ldtExpiration_Date)
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
			
		
		llLineItem ++
		
Next /*Import Row */


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

on u_dw_import_ws_po.create
call super::create
end on

on u_dw_import_ws_po.destroy
call super::destroy
end on

event ue_pre_validate;call super::ue_pre_validate;
This.Sort()
// pvh - 01/21/06
return 0
end event

