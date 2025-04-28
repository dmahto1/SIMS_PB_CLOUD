HA$PBExportHeader$u_dw_import_sears_fixture_project.sru
$PBExportComments$Import Sears Fixtures Project data
forward
global type u_dw_import_sears_fixture_project from u_dw_import
end type
end forward

global type u_dw_import_sears_fixture_project from u_dw_import
integer width = 3077
integer height = 1572
string dataobject = "d_import_sears_fix_project"
boolean minbox = true
boolean maxbox = true
boolean border = false
borderstyle borderstyle = stylebox!
end type
global u_dw_import_sears_fixture_project u_dw_import_sears_fixture_project

type variables

Boolean	ibConfirmInbound
end variables

forward prototypes
public function string wf_validate (long al_row)
public function integer wf_save ()
public function integer wf_create_po_list (string arg_pono, ref string arg_po_list[])
end prototypes

public function string wf_validate (long al_row);// 05/03 - PCONKL - Import Sears Fixture Project data

string	lsSUpplier, lsLoc, lsStore
Long		llCount

string lsResetPO[], lsMultPONo[]
string lspono, ls_check_po
integer lipos, liIdx, liSubIdx, li_PoCount

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

//Inbound Date must be present and be a valid Date
If This.GetITemString(al_row,'begin_date') > '' Then
	If Not isDate(This.GetITemString(al_row,'begin_date')) Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('begin_date')
		return "'Inbound Receipt Date' must be a valid Date."
	End If
Else /* Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('begin_date')
	return "'Inbound Receipt Date' is Required."
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

// 08/03 - PConkl - If any of the Confirm Indicators are set, they all must be
If This.GetITemString(al_row,'confirm_inbound') > '' Then
	If This.GetITemString(al_row,'confirm_Inbound') <> 'Y' Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('confirm_inbound')
		return "'Confirm Inbound Indicator must be Y if present."
	Else
		ibConfirmInbound = True
	End If
Else
	If ibConfirmInbound Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('confirm_inbound')
		return "'If Confirm Inbound Indicator is set on any rows, it must be set on ALL rows."
	End If
End If

//If Location is present, it must be valid
// 08/03 - PConkl - If we are confirming Inbound Orders, Location must be present
lsLoc = This.GetITemString(al_row,'dedicated_loc')
If lsLoc > '' Then
	
	Select Count(*) into :llCount
	From Location
	Where wh_code = :gs_default_wh and l_code = :lsLoc;
	
	If llCount <= 0 Then
		This.SetFocus()
		This.SetRow(al_row)
		This.SetColumn('dedicated_loc')
		return "'Location' must be valid if it is present."
	End If
	
Elseif ibConfirmInbound Then /*Not present*/
	This.SetFocus()
	This.SetRow(al_row)
	This.SetColumn('dedicated_loc')
	return "'Location' must be present if confirming Inbound Orders."
End If


//Multi PO Tracking.
//4/20/2004 - MA -  Check to see if there are multi-POs 

lsPONO = This.GetITemString(al_row,'po_no')

liPos = Pos(lsPONO, ',')

lsMultPONo[] = lsResetPO[]

if liPos > 0 then

	wf_create_po_list(lsPONO, lsMultPONo)

	li_POCount = UpperBound(lsMultPONo)

	for liIdx = 1 to li_POCount
		
		ls_check_po = lsMultPONo[liIdx] 
		
		//Don't need to check the last one.
		
		if liIdx < li_POCount then
			
			for liSubIdx = (liIdx + 1) to li_POCount
				
				if ls_check_po = lsMultPONo[liSubIdx] then
					This.SetFocus()
					This.SetRow(al_row)
					This.SetColumn('po_no')
					return "Duplicate POs."	
	
				end if
				
			next
			
		end if
		
	next


end if


iscurrvalcolumn = ''
return ''

end function

public function integer wf_save ();Long	llRowCount,	llRowPos, llRONew, llDONew, llCount,	&
		llOwner,	llROLineItemNo, llDOLineItemNO, llPriority
		
String	lsSuppCode, lsSuppCodeHold, lsProject, lsProjectHold, lsStore, lsStoreHold, lsLoc, lsRemarks, lsTrailer, 	&
			lsRONO, lsDONO, lsOrderNo, lsErrText, lsSKU, lsUOM, lsDesc, lsDeliveryOrderNo, lsRecvBy, lsKeyBy,	&
			lsSaveFile,lsCustName, lsAddr1, lsAddr2, lsAddr3, lsAddr4, lsCity, lsState, lsZip, lsCountry, lsAltSKU,	&
			lsWeight, lsCube, lsCarrier, lsSHipWave, lsFreightClass, lsStack, lsOrdStatus, lsPONO, &
			lsMultPONo[], lsTempStr, lsResetPO[], lsPONOPutaway
			
DateTime		ldtCompleteDate

Date			ldtArrivalDate, ldTShipDate, ldtDeliveryDate

Decimal	ldRoNo,	ldDoNo,	ldQty

Integer	liRC, liPos, liIdx, liLastPos

Boolean	lbNewOrder
		 
Datawindow	ldwThis

ldwThis = This

u_nvo_edi_confirmations_sears_fix	luediConfirm

// pvh 02.15.06 - gmt
datetime ldtToday
ldtToday = f_getLocalWorldTime( gs_default_wh ) 

llRowCount = This.RowCount()

llDONew = 0 
llRONew = 0

SetPointer(Hourglass!)

//Include Right most 30 char of Import File name in UF8 so that we can validate that it hasn't been imported more than once
lsSaveFile = Right(w_import.isImportFile,30)
		
//Sort by Project, Supplier and Store, We will create 1 inbound order per Project/Vendor/store and 1 outbound order per store
This.SetSort("project_id A,Supp_code A, Store_id A")
This.Sort()

//For each import row - either update or add a Receiving Order and Delivery Order

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

For llRowPos = 1 to llRowCOunt
	
	w_main.SetmicroHelp("Saving Row " + string(llRowPos) + " of " + string(llRowCount))
	
	lsproject = This.GetITemString(llRowPos,'project_id')
	lsSuppCode = This.GetITemString(llRowPos,'supp_code')
	lsStore = String(Long(This.GetITemString(llRowPos,'store_id')),'00000') /*pad with leading 0's if necessary*/
	lsUOM = This.GetITemString(llRowPos,'uom')
	lsDesc = This.GetITemString(llRowPos,'description')
	lsloc = This.GetITemString(llRowPos,'dedicated_loc')
	lsPONO = This.GetITemString(llRowPos,'po_no') /* 11/03 - PCONKL */
	lsRemarks = This.GetITemString(llRowPos,'remark')
	lsTrailer = This.GetITemString(llRowPos,'trailer_number')
	lsrecvBy = This.GetITemString(llRowPos,'received_by')
	lskeyby = This.GetITemString(llRowPos,'keyed_by')
	lsAltSKU = This.GetITemString(llRowPos,'part_number')
	lsStack = This.GetITemString(llRowPos,'stackability')
	lsWeight = This.GetITemString(llRowPos,'Weight')
	lsCube = This.GetITemString(llRowPos,'Cube')
	lsCarrier = This.GetITemString(llRowPos,'Carrier')
	lsShipWave = This.GetITemString(llRowPos,'ship_wave')
	lsFreightClass = This.GetITemString(llRowPos,'freight_Class')
	ldQty = Long(This.GetItemString(llRowPos, 'Quantity'))
	llPriority = Long(This.GetItemString(llRowPos, 'priority'))
	ldtArrivalDate = Date(This.GetITemString(llRowPos,'begin_date'))
	ldtShipDate = Date(This.GetITemString(llRowPos,'End_date'))
	ldtDeliveryDate = Date(This.GetITemString(llRowPos,'Delivery_date'))
	
	lsOrderNo = lsStore + '-' + lsProject + '-' + lsSuppCode /* Order NUmber is Project + Supp Code */
	lSSKU = lsStore + '-' + lsProject /* Sku is Store + Project */
	
	If isnull(lsLoc) Then lsLoc = ''
	If isNull(lsAltSKU) or lsAltSKU = '' Then lsAltSKU = lsSKU
	If isnull(lsPONO) or lsPONO = '' Then lsPONO = "NA" /* 11/03 - PCONKL - default PO Nbr to NA if not present*/
	
 //INBOUND 
	
	//If Project,Supplier or store Changes, Create a new Receive Master Record
	// 08/03 - PCONKL - If we are auto confirming the orders (Y in the last column of import), we will only create an order per supplier instead of supplier/store
	
	If Not ibCOnfirmInbound Then /*Not auto confirming*/
		If (Upper(lsProject) <> Upper(lsProjectHold)) or (Upper(lsSuppCode) <> Upper(lsSuppCodeHold)) or (Upper(lsStore) <> Upper(lsStoreHold)) Then
			lbNewOrder = True
		Else
			lbNewOrder = False
		End If
	Else /*auto confirming*/
		If (Upper(lsProject) <> Upper(lsProjectHold)) or (Upper(lsSuppCode) <> Upper(lsSuppCodeHold))  Then
			lbNewOrder = True
		Else
			lbNewOrder = False
		End If
	End If
	
	If lbNewOrder Then
		
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
		
		//Get the next available RONO
		sqlca.sp_next_avail_seq_no(gs_project,"Receive_Master","RO_No" ,ldRONO)//get the next available RO_NO
		lsRoNO = gs_Project + String(Long(ldRoNo),"000000") 
		
		If isNull(lsRoNO) or lsRoNO = '' Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to retrieve the next available Receive Order Number.")
			SetPointer(Arrow!)
			Return -1
		End If	
		
		// 08/03 - PCONKL - If we're auto confirming, set the order status to Complete, otherwise set it to New
		If ibConfirmInbound Then
			lsOrdStatus = 'C'
			ldtCompleteDAte = ldtToday
		Else
			lsOrdStatus = 'N'
		End If
		
		Insert Into Receive_Master (Ro_no, Project_id,Ord_date,Arrival_date,Complete_date, Ship_ref,Ord_status,Ord_Type,Inventory_type,
						wh_code,Supp_code,Supp_invoice_no,User_field4, user_field5, user_field6, Remark, Carrier, LAst_user,LASt_Update)
		Values (:lsRONO,:gs_project,:ldtToday,:ldTArrivalDate, :ldtCompleteDate, 'N/A',:lsOrdStatus,'S','N',
					:gs_default_wh,:lsSUppCode,:lsOrderNo, :lstrailer, :lsRecvBy, :lsKeyby, :lsRemarks, :lsCarrier, :gs_userid,:ldtToday)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Receive Master record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		End If	
				
		llRONew ++
		llROLineItemNo = 0 /*Order Line Item Number*/
		
	End If /*Supplier and/or store Changed, New Receive Master created */
	
	//Create a new Item Master for this store/project/uom if not already present
	Select Count(*) into :llCount
	From ITem_MAster
	Where Project_ID = :gs_project and SKU = :lsSKU and supp_code = :lsSuppCode;
	
	If llCount <= 0 Then
		
		Insert Into Item_MAster (project_id, SKU, Supp_code, Description, Owner_id, Country_of_Origin_Default,
						UOM_1, Freight_Class,lot_controlled_ind, po_Controlled_Ind, LAst_USer, last_Update)
		Values (:gs_Project, :lsSKU, :lsSuppCode, :lsDesc, :llOwner, 'XXX', :lsUOM, :lsFreightClass,'Y','Y', :gs_userid,:ldtToday)
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Item Master record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		End If
		
	End If /*New ITem Created */
	
	llROLineItemNo ++ /*Bump up Line Item Number */
		
	//Create the Receive Detail Record
	Insert Into Receive_Detail (ro_no, sku, supp_code, Owner_id, Country_of_origin, Alternate_sku, req_qty, alloc_qty, Damage_qty,
					uom, line_Item_no, User_field1, USer_Field2)
	Values		(:lsRoNo, :lsSKU,:lsSuppCode, :llOwner, 'XXX', :lsAltSKU, :ldQty, :ldQty, 0, :lsUOM,:llROLineItemNo, :lsWeight, :lsCube)
	Using SQLCA;
	
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Receive Detail record to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If	

	//Multi PO Tracking.
	//4/20/2004 - MA -  Check to see if there are multi-POs 

	liPos = Pos(lsPONO, ',')
	
	lsMultPONo[] = lsResetPO[]
	
	if liPos > 0 then
	
		wf_create_po_list(lsPONO, lsMultPONo)
	
	end if
	
	// 04/20/2004 - MA - Send the value to MULTIPO in the putaway table if there are more than one PO.
	
	if Upperbound(lsMultPONo) > 1 then
		lsPONOPutaway = "MULTIPO"
	else
		lsPONOPutaway = lsPONO
	end if
	
	//Create the Putaway Record
	Insert Into Receive_Putaway (ro_no, sku, supp_code, Owner_id, Country_of_origin,l_code, Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2,
					Sku_parent, Component_ind, Quantity, component_no, line_Item_no, user_Field1)
	Values		(:lsRoNo, :lsSKU,:lsSUppCode, :llOwner, 'XXX',:lsLoc, 'N', '-', :lsUOM , :lsPONOPutaway, '-',
						:lsSku, 'N', :ldQty, 0, :llROLineItemNo, :lsStack)
	Using SQLCA;
		
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Receive Putaway record to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If	
	
	
	//04/20/2004 - MA - Insert into Receive_Xref Table if multiple POs.
	
	if Upperbound(lsMultPONo) > 1 then

		for liIdx = 1 to UpperBound(lsMultPONo)
	
			Insert Into Receive_Xref
				(PO_NO, Project_ID, RO_NO, Line_Item_No, SKU, Supp_Code)
				Values(:lsMultPONo[liIdx], :gs_Project, :lsRoNo, :llROLineItemNo,  :lsSKU, :lsSuppCode )
				USING SQLCA;
				
			If sqlca.sqlcode <> 0 Then
				lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
				Execute Immediate "ROLLBACK" using SQLCA;
				Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Multi PO record to database!~r~r" + lsErrText)
				SetPointer(Arrow!)
				Return -1
			End If	
						
		next
	
	end if
	
	// 08/03 - PCONKL - If we're auto confirming, we will also create the Content record
	If ibConfirmInbound Then
		
		Insert Into Content (Project_id, ro_no, sku, supp_code, Owner_id, Country_of_origin,l_code, Inventory_Type, Serial_no, Lot_no, Po_no, Po_no2,
					  avail_qty, component_qty, component_no, wh_code, last_User, last_Update, Reason_Cd)
		Values		(:gs_Project, :lsRoNo, :lsSKU,:lsSUppCode, :llOwner, 'XXX',:lsLoc, 'N', '-', :lsUOM, '-', '-',
						 :ldQty,0, 0,:gs_default_WH,:gs_userid,:ldtToday, 'IP')
		Using SQLCA;
		
		If sqlca.sqlcode <> 0 Then
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
			Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Content record to database!~r~r" + lsErrText)
			SetPointer(Arrow!)
			Return -1
		End If
	
	End IF /*auto confirming Inbound*/
	
 //OUTBOUND
	
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
	Values							(:lsdoNo, :lsSKU,:lsSuppCode, :llOwner, :lsAltSKU, :ldQty, 0,'EA',:llDOLineItemNo, :lsWeight, :lsCube) 
	Using SQLCA;
		
	If sqlca.sqlcode <> 0 Then
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
		Execute Immediate "ROLLBACK" using SQLCA;
		Messagebox("Import","Error saving Row: " + String(llRowPos) + " Unable to save new Delivery Detail record to database!~r~r" + lsErrText)
		SetPointer(Arrow!)
		Return -1
	End If	
	
	lsProjectHold = lsProject
	lsSuppCodeHold = lsSuppCode
	lsStoreHold = lsStore
	
Next /*Next Import Row*/

Execute Immediate "COMMIT" using SQLCA;
If sqlca.sqlcode <> 0 Then
	MessageBox("Import","Unable to Commit changes! No changes made to Database!")
	Return -1
End If

MessageBox("Import","Records saved.~r~rReceive Orders Added: " + String(llroNew) + "~rDelivery Orders Added: " + String(lldoNew) )

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

public function integer wf_create_po_list (string arg_pono, ref string arg_po_list[]);integer lipos, lilastpos
string lstempstr

string lsMultPONo[], lsResetPO[]

lsMultPONo[] = lsResetPO[]

liPos = Pos(arg_PONO, ',')

lsMultPONo[1] = trim(Left(arg_PONO, liPos - 1))

DO
	
	liLastPos = liPos
	
	liPos = Pos(arg_PONO, ',', (liLastPos + 1))
				
	if liPos > 0 then
	
		lsMultPONo[UpperBound(lsMultPONo)+1] =  trim(Mid(arg_PONO, liLastPos + 1, (liPos - liLastPos - 1)))
	
	end if
	
LOOP UNTIL liPos = 0 or liPos >= len(arg_PONO)

lsTempStr = trim(Mid(arg_PONO, liLastPos + 1))

if lsTempStr > '' then 

	lsMultPONo[UpperBound(lsMultPONo)+1] = lsTempStr

end if

//if the last character is a , then remove it.

if right(trim(arg_PONO),1) = ',' then arg_PONO = left(trim(arg_PONO), len(trim(arg_PONO))-1)

//Loop through and insert a record for each PO

arg_PO_list[] = lsMultPONo[]

return 1
end function

on u_dw_import_sears_fixture_project.create
call super::create
end on

on u_dw_import_sears_fixture_project.destroy
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

