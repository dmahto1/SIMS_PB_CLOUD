$PBExportHeader$u_dw_import_sears_fixture_rollout_master.sru
$PBExportComments$Import Sears Fixtures Rollout Master Setup
forward
global type u_dw_import_sears_fixture_rollout_master from u_dw_import
end type
end forward

global type u_dw_import_sears_fixture_rollout_master from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_sears_fix_rollout_master"
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_sears_fixture_rollout_master u_dw_import_sears_fixture_rollout_master

type variables

Boolean	ibConfirmInbound
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
end prototypes

public function string wf_validate (long al_row);// 05/03 - PCONKL - Import Sears Fixture Project data

string	lsSUpplier, lsLoc, lsStore
Long		llCount

//Project is Required
If Isnull(This.GetITemString(al_row,'project_id')) or This.GetITemString(al_row,'project_id') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('project_id')
	return "'Project' is Required"
End If

//Store is Required and must be valid (customer)
If Isnull(This.GetITemString(al_row,'store_id')) or This.GetITemString(al_row,'store_id') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Store_id')
	return "'Store' is Required"
End If

lsStore = This.GetITemString(al_row,'store_id')
Select Count(*) Into :llCount
From Customer
where Project_id = :gs_project and cust_code = :lsStore;

If llCount <= 0 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('store_id')
	return "'Store ID' is Invalid."
End If

//Supplier ID is Required and must be valid
If Isnull(This.GetITemString(al_row,'supp_code')) or This.GetITemString(al_row,'supp_code') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('supp_code')
	return "'Vendor ID' is Required"
End If

lsSUpplier = This.GetITemString(al_row,'supp_code')
Select Count(*) Into :llCount
From Supplier
where Project_id = :gs_project and supp_code = :lsSupplier;

If llCount <= 0 Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('supp_code')
	return "'Vendor ID' is Invalid."
End If

//Description is Required
If Isnull(This.GetITemString(al_row,'description')) or This.GetITemString(al_row,'description') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('description')
	return "'Description' is Required"
End If

//If priority is present, it must be numeric
If This.GetITemString(al_row,'priority') > '' Then
	If Not isNumber(This.GetITemString(al_row,'Priority')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Priority')
		return "'Priority' must be numeric if it is present."
	End If
End If

//Qty must be present and Numeric
If This.GetITemString(al_row,'Quantity') > '' Then
	If Not isNumber(This.GetITemString(al_row,'Quantity')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Quantity')
		return "'QTY' must be numeric"
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Quantity')
	return "'QTY' is Required."
End If

//UOM is Required
If Isnull(This.GetITemString(al_row,'uom')) or This.GetITemString(al_row,'uom') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('uom')
	return "'UOM' is Required"
End If

//Weight must be present and Numeric
If This.GetITemString(al_row,'Weight') > '' Then
	If Not isNumber(This.GetITemString(al_row,'Weight')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Weight')
		return "'Weight' must be numeric"
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Weight')
	return "'Weight' is Required."
End If

//Cube must be present and Numeric
If This.GetITemString(al_row,'Cube') > '' Then
	If Not isNumber(This.GetITemString(al_row,'Cube')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('Cube')
		return "'Cube' must be numeric"
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('Cube')
	return "'Cube' is Required."
End If

//Freight Class is Required
If Isnull(This.GetITemString(al_row,'freight_Class')) or This.GetITemString(al_row,'freight_Class') = '' Then
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('freight_Class')
	return "'Freight Class' is Required"
End If

//Outbound SHip Date must be present and be a valid Date
If This.GetITemString(al_row,'end_date') > '' Then
	If Not isDate(This.GetITemString(al_row,'end_date')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('end_date')
		return "'Outbound Ship Date' must be a valid Date."
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('end_date')
	return "'Outbound Ship Date' is Required."
End If

//Outbound Delivery Date must be present and be a valid Date
If This.GetITemString(al_row,'delivery_date') > '' Then
	If Not isDate(This.GetITemString(al_row,'delivery_date')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('delivery_date')
		return "'Outbound Delivery Date' must be a valid Date."
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('delivery_date')
	return "'Outbound Delivery Date' is Required."
End If

iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	llRowPos,  llDONew, llCount,	&
		llOwner,	llDOLineItemNO, llPriority
		
String	lsSuppCode, lsSuppCodeHold, lsProject, lsStore, lsRemarks,  	&
			lsDONO, lsErrText, lsSKU, lsDesc, lsDeliveryOrderNo, lsSaveFile,lsCustName, lsAddr1, &
			lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsAltSKU,	&
			lsWeight, lsCube, lsSHipWave, lsFreightClass, lsOrdStatus, lsUOM
			
DateTime	ldtCompleteDate

Date			ldTShipDate, ldtDeliveryDate

Decimal		ldDoNo,	ldQty

Integer	liRC

Boolean	lbNewOrder

Datawindow	ldwThis

ldwThis = This

u_nvo_edi_confirmations_sears_fix	luediConfirm

// pvh 11/23/05 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowCount = This.RowCount()

llDONew = 0 

SetPointer(Hourglass!)

//Include Right most 30 char of Import File name in UF8 so that we can validate that it hasn't been imported more than once
lsSaveFile = Right(w_import.isImportFile,30)
		
//Sort by Project, Supplier and Store, We will create  1 outbound order per store
This.SetSort("project_id A,Supp_code A, Store_id A")
This.Sort()

//For each import row - either update or add a Delivery Order

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsproject = This.GetITemString(llRowPos,'project_id')
	lsSuppCode = This.GetITemString(llRowPos,'supp_code')
	lsStore = String(Long(This.GetITemString(llRowPos,'store_id')),'00000') /*pad with leading 0's if necessary*/
	lsDesc = This.GetITemString(llRowPos,'description')
	lsRemarks = This.GetITemString(llRowPos,'remark')
	lsAltSKU = This.GetITemString(llRowPos,'part_number')
	lsUOM = This.GetITemString(llRowPos,'uom')
	lsWeight = This.GetITemString(llRowPos,'Weight')
	lsCube = This.GetITemString(llRowPos,'Cube')
	lsShipWave = This.GetITemString(llRowPos,'ship_wave')
	lsFreightClass = This.GetITemString(llRowPos,'freight_Class')
	ldQty = Long(This.GetItemString(llRowPos, 'Quantity'))
	llPriority = Long(This.GetItemString(llRowPos, 'priority'))
	ldtShipDate = Date(This.GetITemString(llRowPos,'End_date'))
	ldtDeliveryDate = Date(This.GetITemString(llRowPos,'Delivery_date'))
	
	lSSKU = lsStore + '-' + lsProject /* Sku is Store + Project + UOM */
	
	If isNull(lsAltSKU) or lsAltSKU = '' Then lsAltSKU = lsSKU
		
	//Get the OWner ID for this Supplier - if changed
	If (Upper(lsSuppCode) <> Upper(lsSuppCodeHold)) Then
			
		Select Owner_id 
		Into	:llOwner
		From Owner
		Where Project_id = :gs_project and owner_Type = 'S' and owner_cd = :lsSuppCode;
		
		If isNull(llOwner) or llOwner <=0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Invalid Supplier!~r~rPlease run the Validation routine again.")
			SetPointer(Arrow!)
			Return -1
		End If	
			
	End If /*Supplier Changed */
	
	//Create a new Item Master for this store/project
	Select Count(*) into :llCount
	From ITem_MAster
	Where Project_ID = :gs_project and SKU = :lsSKU and supp_code = :lsSuppCode;
	
	If llCount <= 0 Then
		
		Insert Into Item_MAster (project_id, SKU, Supp_code, Description, Owner_id, Country_of_Origin_Default,
						UOM_1, Freight_Class,lot_controlled_ind, po_controlled_Ind, LAst_USer, last_Update)
		Values (:gs_Project, :lsSKU, :lsSuppCode, :lsDesc, :llOwner, 'XXX', :lsUOM, :lsFreightClass,'Y', 'Y', :gs_userid,:ldtToday)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Item Master record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		End If
		
	End If /*New ITem Created */
		
 	lsDeliveryOrderNo = lsStore + '-' + lsProject
	lsDONO = ''
	
	//See if outbound ORder Header already exists in a NEW status, if not Create a new Delivery Master
	Select do_no into :lsDoNo
	From Delivery_Master
	Where Project_id = :gs_Project and Invoice_No = :lsDeliveryOrderNo and ord_status = 'N'
	Using SQLCA;
	
	If isNull(lsDoNo) or lsDONO = ''  Then
		
		//Get the next available DONO
		sqlca.sp_next_avail_seq_no(gs_project,"Delivery_Master","DO_No" ,lddONO)//get the next available DO_NO
		lsDoNO = gs_Project + String(Long(ldDoNo),"000000") 
		
		If isNull(lsDoNO) or lsDoNO = '' Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to retrieve the next available Delivery Order Number.")
			SetPointer(Arrow!)
			Return -1
		End If
		
		//Retrieve Customer Address Info
		lsCustName = ''
		lsAddr1 = ''
		lsAddr2 = ''
		lsAddr3 = ''
		lsAddr4 = ''
		lsCity = ''
		lsState = ''
		lsZip = ''
		lsCountry = ''
		
		Select Cust_Name, address_1, address_2, address_3, address_4, city, state, zip, country
		Into	:lsCustName, :lsAddr1, :lsaddr2, :lsAddr3, :lsAddr4, :lsCity, :lsState, :lsZip, :lsCountry
		From Customer
		Where Project_id = :gs_project and Cust_code = :lsStore;
			
		//Create DElivery MAster Record
		Insert Into Delivery_Master (Do_no, Project_id,Ord_date,Ord_status,Ord_Type,Inventory_type,
						Cust_code, Cust_Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country,
						wh_code,invoice_no, Freight_Cost,User_field8, Schedule_Date, Receive_Date, Priority, user_field2, user_field3, Remark, LAst_user,LASt_Update)
		Values (:lsDONO,:gs_project,:ldtToday,'N','S','N',	:lsStore, :lsCustName, :lsAddr1, :lsAddr2, :lsAddr3, :lsAddr4,
					:lsCity, :lsState, :lsZip, :lsCountry,:gs_default_wh,:lsDeliveryOrderNo,0,:lsSaveFile, :ldtShipDate, :ldtDeliveryDate, :llPriority,
					:lsSHipWave, 'PENDING', :lsRemarks, :gs_userid,:ldtToday)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Master record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		End If	
		
		llDoNew ++
				
	End If /*Store Changed, New Delivery MAster created */
	
	//Get highest line ItemNo and Bump
	Select max(line_Item_no) into :llDOLineItemNO
	From Delivery_Detail
	Where DO_NO = :lsDONO;
	
	If isnull(llDOLineItemNO) or llDOLineItemNO = 0 Then
		llDOLineItemNO = 1
	Else
		llDOLineItemNO ++
	End If
	
	//Insert the Delivery DEtail Record 
	Insert Into Delivery_Detail (do_no, sku, supp_code, Owner_id, Alternate_sku, req_qty, alloc_qty,  uom, line_Item_no, USer_Field1, User_Field2)
	Values							(:lsdoNo, :lsSKU,:lsSuppCode, :llOwner, :lsAltSKU, :ldQty, 0,:lsUOM,:llDOLineItemNo, :lsWeight, :lsCube) 
	Using SQLCA;
		
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If	
	
	lsSuppCodeHold = lsSuppCode
	
Next /*Next Import Row*/

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rDelivery Orders Added: " + String(lldoNew) )

//Create the TMS Notification
luediConfirm = Create u_nvo_edi_confirmations_sears_fix
liRC = luEDIConfirm.uf_tms_notification(ldwThis)

If liRC >= 0 Then
	Messagebox('Import','Notification sent to TMS for these orders!')
End If


w_main.SetmicroHelp("Ready")
SetPointer(Arrow!)
Return 0
end function

on u_dw_import_sears_fixture_rollout_master.create
call super::create
end on

on u_dw_import_sears_fixture_rollout_master.destroy
call super::destroy
end on

event ue_post_import;call super::ue_post_import;
//Allow user to set Putaway locations for each store
If this.RowCount() > 0 Then
	w_import.cb_option1.Enabled = True
End If


end event

event ue_cmd_option_1;call super::ue_cmd_option_1;Str_parms	lstrparms
Long			llArrayPos,	llArrayCount, llRowCount, lLRowPos, llStrID, llFindRow
Boolean	lbFound
String	lsLoc

// Prompt and load Putaway Locations for each Store

//Load an array of distinct store numbers
llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	
	llStrId = Long(this.GetItemString(lLRowPos,'store_id'))
	lsLoc = this.GetItemString(lLRowPos,'dedicated_loc')
	//Find it in the array, add if not there
	llArrayCount = Upperbound(lstrparms.Long_arg)
	lbFound = False
	If llArrayCount > 0 Then
		For llarrayPos = 1 to llArrayCount
			If lstrparms.Long_arg[llArrayPos] = llStrID Then
				lbFound = True
				Exit
			End If
		Next
		
		If Not lbFound Then
			lstrparms.Long_arg[llArrayCount + 1] = llStrID
			lstrparms.String_arg[llArrayCount + 1] = lsLoc
		End If
		
	Else
		Lstrparms.Long_arg[1] = llStrId
	End If
	
Next /*Import Row*/

OpenWithParm(w_import_sears_fix_Location,Lstrparms)
Lstrparms = Message.PowerObjectParm

If Not lstrparms.Cancelled Then
	
	//Load the locations wherever the store is found
	llArrayCount = Upperbound(lstrparms.Long_arg)
	For llArrayPos = 1 to llArrayCount
		
		llFindRow = This.Find("store_id='" + String(lstrparms.Long_arg[llArrayPos]) + "'",1, This.RowCount())
		Do While llFindRow > 0 
			If lstrparms.String_arg[llArrayPos] > '' Then
				This.SetItem(llFindRow,'dedicated_loc',lstrparms.String_arg[llArrayPos])
			End If
			llFindRow ++
			If llFindRow > This.RowCount() Then
				lLFindROw = 0
			Else
				llFindRow = This.Find("store_id='" + String(lstrparms.Long_arg[llArrayPos]) + "'",llFindRow, This.RowCount())
			End If
		Loop
		
	Next
	
End If


end event

event ue_pre_validate;call super::ue_pre_validate;
ibConfirmInbound = False
// pvh - 01/20/06
return 0
end event

