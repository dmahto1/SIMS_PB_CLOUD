HA$PBExportHeader$u_dw_import_item_price.sru
$PBExportComments$Import ItemMaster Price information
forward
global type u_dw_import_item_price from u_dw_import
end type
end forward

global type u_dw_import_item_price from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_itemaster_price"
end type
global u_dw_import_item_price u_dw_import_item_price

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
end prototypes

public function integer wf_save ();Long	llRowCount,	&
		llRowPos,	&
		llUpdate,	&
		llNew,		&
		llLength1,	&
		llWidth1,	&
		llHeight1, 	&
		llSupCount
		
Decimal	ldGMPrice,	&
			ldACPrice
			
String	lsSku,	&
			lsACSku,	&
			lsErrText,	&
			lsSupplier,	&
			lsUOM1,		&
			lsSQL
			
Datetime		ldToday, ldtserverTime
DataStore lds_print

// pvh 02.15.06 - gmt
ldtserverTime = DateTime(Today(),now())
ldtoday = f_getLocalWorldTime( gs_default_wh ) 

llRowCount = This.RowCount()

llupdate = 0
llNew = 0

SetPointer(Hourglass!)

// GAP 04-03 Print datastore for NEW SKU Exceptions
lds_print = Create DataStore
lds_print.DataObject = 'd_sku_temp'
lds_print.SetTransObject(sqlca)

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

If Upper(gs_project) = 'CHINASIMS'  THEN
	 SQLCA.DBParm = "disablebind =0"
End If

//Update Only, No inserts allowed if SKU doesn't exist!
For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsSku = left(trim(This.GetItemString(llRowPos,"gm_sku")),50)
	If Upper(Left(gs_project,4)) <> 'GM_M'  Then /* GM Mexico is not importing supplier*/
		lsSupplier = left(trim(This.GetItemString(llRowPos,"supplier_id")),20)
	End If
	lsACSku = left(trim(This.GetItemString(llRowPos,"acdelco_sku")),50)
	
	ldGMPrice = dec(This.GetItemString(llRowPos,"gm_price"))
	ldACPrice = dec(This.GetItemString(llRowPos,"ac_price"))
	lsuom1 = left(trim(This.GetItemString(llRowPos,"uom_1")),4)
	llLength1 = Long(This.GetItemString(llRowPos,"length_1"))
	llWidth1 = Long(This.GetItemString(llRowPos,"Width_1"))
	llheight1 = Long(This.GetItemString(llRowPos,"height_1"))
			
// 07/01 Pconkl - building update statement dynamically so we only include fields that are present in layout
// (we dont want to null out previously entered data that is not present in the current import)

	lsSQL = "Update Item_Master Set "
	
	If lsACSku > ' ' Then lsSQL += "alternate_sku = '" + lsacSKU + "', "
	If lsUOM1 > ' ' Then lsSQL += "uom_1 = '" + lsUOM1 + "', "
	If lllength1 > 0 Then lsSQL += "length_1 = " + string(lllength1) + ", "
	If llwidth1 > 0 Then lsSQL += "width_1 = " + string(llwidth1) + ", "
	If llheight1 > 0 Then lsSQL += "height_1 = " + string(llheight1) + ", "
	
	// pvh - 02/15/06 - gmt   replaced string( today()...   with string( ldtoday..
	
	lsSQl += "Interface_upd_req_ind = 'Y', last_user = '" + gs_userid + "', last_update = '" + string( ldtoday ,'mm-dd-yy hh:mm:ss') + "'" /*last update*/
	lsSQl += " Where sku = '" + lsSku + "' and project_id = '" + gs_project + "'" /*Where*/
	If lsSupplier > ' ' AND Upper(Left(gs_project,4)) <> 'GM_M'  Then lsSQl += " and supp_code = '" + lsSupplier + "'" /*GM Mexico doesn't want to include SUpplier*/
		
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
	llSupCount = Sqlca.sqlnrows //GAP 2-03 count for multiple suppliers

	If Sqlca.sqlnrows <> 1  and llSupCount <= 0 Then 
		
		// create an exception list for New SKUs
		llNew ++
		lds_print.InsertRow(llNew)
		lds_print.setitem(llNew,"sku", This.GetItemString(llRowPos,"gm_sku"))
		lds_print.setitem(llNew,"new_price", This.GetItemString(llRowPos,"gm_price"))
		Continue /*dont create price records if not inserting sku*/
		
	Else /*update - update or create price class record*/
			
		llupdate ++
		
	End If
	
	//Update Price Master for GM (class 01) and/or ACDelco (Class 02)
	
	//GM Price
	If ldGMPrice > 0 Then
			
		// 11/00 PCONKL - If GM_M, we dont include supplier, if inserting a new price record, we will need to retrieve the supplier from Itemmaster
		
		If Upper(Left(gs_project,4)) = 'GM_M'  Then
			
			If llSupCount > 1 Then 
			
				Update price_master 
				Set price_1 = :ldGMPrice
				Where sku = :lsSku and project_id = :gs_project   and  price_class = '01' /* '01' is GM Class */
				Using Sqlca;
				
			else
				
				//Try update first
				Update price_master Set
				price_1 = :ldGMPrice
				Where sku = :lsSku and project_id = :gs_project  and  price_class = '01' /* '01' is GM Class */
				Using Sqlca;
			
				If Sqlca.sqlnrows <> 1 Then /*Insert*/
					//Retrieve supplier since it's not available in import
					Select supp_code into :lsSupplier
					From Item_master
					Where sku = :lsSku and project_id = :gs_project
					Using SQLCA;
				
					If lsSupplier > '' Then
						Insert Into Price_Master (project_id,sku,supp_code,price_class,price_1) values (:gs_project,:lsSku,:lsSupplier,'01',:ldGMPrice)
						Using SQLCA;
					End If
				
				End If /*Insert*/
			
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
			end if
			
		Else /* Not GM Mexico */
			
			//Try update first
			Update price_master Set
			price_1 = :ldGMPrice
			Where sku = :lsSku and project_id = :gs_project and supp_code = :lsSupplier and  price_class = '01' /* '01' is GM Class */
			Using Sqlca;
		
			If Sqlca.sqlnrows <> 1 Then /*Insert*/
				Insert Into Price_Master (project_id,sku,supp_code,price_class,price_1) values (:gs_project,:lsSku,:lsSupplier,'01',:ldGMPrice)
				Using SQLCA;
			End If /*Insert*/
			
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
			
		End If /* GM MEXICO?? */
			
	End If /*GM Price being updated*/
		
	//AC Price
	If ldACPrice > 0 Then
		
		// 11/00 PCONKL - If GM_M, we dont include supplier, if inserting a new price record, we will need to retrieve the supplier from Itemmaster
		
		If Upper(Left(gs_project,4)) = 'GM_M'  Then
			
			//Try update first
			Update price_master Set
			price_1 = :ldACPrice
			Where sku = :lsSku and project_id = :gs_project  and  price_class = '02' /* '01' is AC Class */
			Using Sqlca;
		
			If Sqlca.sqlnrows <> 1 Then /*Insert*/
			
				//Retrieve supplier since it's not available in import
				Select supp_code into :lsSupplier
				From Item_master
				Where sku = :lsSku and project_id = :gs_project
				Using SQLCA;
				
				If lsSupplier > '' Then
					Insert Into Price_Master (project_id,sku,supp_code,price_class,price_1) values (:gs_project,:lsSku,:lsSupplier,'02',:ldACPrice)
					Using SQLCA;
				End If
				
			End If /*Insert*/
			
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
			
		Else /* Not GM Mexico */
			
			//Try update first
			Update price_master Set
			price_1 = :ldACPrice
			Where sku = :lsSku and project_id = :gs_project and supp_code = :lsSupplier and  price_class = '02' /* '02' is AC Class */
			Using Sqlca;
		
			If Sqlca.sqlnrows <> 1 Then /*Insert*/
				Insert Into Price_Master (project_id,sku,supp_code,price_class,price_1) values (:gs_project,:lsSku,:lsSupplier,'02',:ldACPrice)
				Using SQLCA;
			End If /*Insert*/
			
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
			
		End If /* GM MEXICO?? */
		
	End If /*AC Price being updated*/
	
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
	
MessageBox("Import","Records saved.~r~rRecords Updated: " + String(llUpdate) + "~r~rNew SKU Records NOT Added: " + String(llNew))
OpenWithParm(w_dw_print_options,lds_print) 


Destroy lds_print

w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

public function string wf_validate (long al_row);String	lsSupplier, lsSku
Long		llCount

//Validate for valid field length and type

// if Currvalcolumn > '' then we didn't validate the whole row, start with the next column
Choose Case iscurrvalcolumn
	Case "gm_sku"
		goto lsupplier
	Case "supplier_id"
		goto lac
	Case "ac_sku"
		goto lgmprice
	Case "gm_price"
		goto lacprice
	case "ac_price"
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
elseif len(trim(This.getItemString(al_row,"gm_sku"))) > 50 Then
	This.Setfocus()
	This.SetColumn("gm_sku")
	iscurrvalcolumn = "gm_sku"
	return "'SKU' is > 50 characters"
End If
	
lsupplier:
//Validate Supplier

// 11/00 PCONKL - Supplier not present or validated for GM Mexico
// 11/01 PCONKL - Must validae for GM if present. If null, it's OK

If Upper(Left(gs_project,4)) <> 'GM_M'  Then
	
	If isnull(This.getItemString(al_row,"supplier_id")) Then
		This.Setfocus()
		This.SetColumn("supplier_id")
		iscurrvalcolumn = "supplier_id"
		return "'Supplier' can not be null!"
	End If
	
	lsSupplier = This.getItemString(al_row,"supplier_id")
	
End If /*Not GM*/
	
// 11/00 PCONKL - Must be valid supplier since it's now in the primary key



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

End If /*Supplier Present*/

lac:
//Validate AC Delco SKU
If len(trim(This.getItemString(al_row,"acDelco_sku"))) > 50 Then
	This.Setfocus()
	This.SetColumn("acdelco_sku")
	iscurrvalcolumn = "acdelco_sku"
	Return "Alternate SKU is > 50 Characters"
End If
	
lgmprice:
//Validate gm price - must be numeric
If Not isnumber(This.getItemString(al_row,"gm_price")) Then
	This.Setfocus()
	This.SetColumn("gm_price")
	iscurrvalcolumn = "gm_price"
	Return "Price class 01 must be numeric!"
End If

If len(trim(This.getItemString(al_row,"gm_price"))) > 12 Then
	This.Setfocus()
	This.SetColumn("gm_price")
	iscurrvalcolumn = "gm_price"
	Return "Price class 01 is > 12.4 Numbers"
End If

lacprice:
//Validate AC price - must be numeric
If Not isnumber(This.getItemString(al_row,"ac_price")) Then
	This.Setfocus()
	This.SetColumn("ac_price")
	iscurrvalcolumn = "ac_price"
	Return "Price class 02 must be numeric!"
End If

If len(trim(This.getItemString(al_row,"ac_price"))) > 12 Then
	This.Setfocus()
	This.SetColumn("ac_price")
	iscurrvalcolumn = "ac_price"
	Return "Price class 02 is > 12.4 Numbers"
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

event constructor;call super::constructor;
// 11/00 PCONKL - If project is GM_M then, supplier will not be entered
//						If there are multiple SKUS, they will be all updated!

If Upper(Left(gs_project,4)) = 'GM_M'  Then
	This.dataobject = 'd_import_itemaster_price_gm'
End If
end event

on u_dw_import_item_price.create
call super::create
end on

on u_dw_import_item_price.destroy
call super::destroy
end on

