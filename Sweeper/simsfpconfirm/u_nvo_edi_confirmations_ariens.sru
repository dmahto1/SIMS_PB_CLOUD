HA$PBExportHeader$u_nvo_edi_confirmations_ariens.sru
$PBExportComments$Process outbound edi confirmation transactions for Powerwave
forward
global type u_nvo_edi_confirmations_ariens from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_ariens from nonvisualobject
end type
global u_nvo_edi_confirmations_ariens u_nvo_edi_confirmations_ariens

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi (string asproject, string asdono, string astype)
public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail)
public function integer uf_process_daily_pro_report (string asinifile, string asproject, string asemail)
public function integer uf_ship_confirm (string as_project, string as_shipid, long aitransid)
public function integer uf_process_daily_eod_shipped_rpt (string asinifile, string asproject, string asemail)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed
//copied from Klonelab pbl
Long			llRowPos, llRowCount, llDetailFindRow,	llNewRow, llLineItem
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lsTemp

Decimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsRODetail) Then
	idsRODetail = Create Datastore
	idsRODetail.Dataobject = 'd_ro_detail'
	idsRODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//dts - might limit it to 'TIBCO' create user. For now, sending everything
/*
//If not received elctronically, don't send a confirmation
If (idsroMain.GetItemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsroMain.GetITemNumber(1,'edi_batch_seq_no'))) Then 
	lsLogOut = "      - Order not received electronically. Not creating GR."
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
end if
//OR   idsroMain.GetITemString(1,'create_user')  <> 'SIMSFP'  
*/

idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	// 08/13 - PCONKL - Do detail row find by LIne ITem, not SKU/Supplier - only find once, use elsewhere
	llLineItem =  idsroputaway.GetItemNumber(llRowPos,'line_Item_No')
	llDetailFindRow = idsRODetail.Find("Line_Item_No = " + string(llLineItem), 1, idsRODetail.RowCount())
	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GR$$HEX2$$1d200900$$ENDHEX$$Goods receipt confirmation identifier
		
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar

	//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number

	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	
	//dts 7/09/13 lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	lsOutString += String(idsROMain.GetItemDateTime(1, 'complete_date'), 'yyyymmddhhmmss') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number

	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
//	lsCOO
	
	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity

	lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

	If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field

	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
	If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present

	If idsroputaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Container ID	C(25)	No	N/A	

	If idsroputaway.GetItemString(llRowPos,'container_id') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Expiration Date	Date	No	N/A	

	If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
	
// TAM 2012/07/23 Moved down below to pull from detail.  User Line Item Number might not be present they did a manual entry instead of a generate.	
//	If trim(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) <> '' Then
//		lsOutString += String(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If			
	
	//llDetailFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())
	
	//Detail User Customer Line Number	C(25)	No	N/A	User Line Item No

	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	//Detail User Field1	C(50)	No	N/A	User Field

	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_field1') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field2	C(50)	No	N/A	User Field

	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field2') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field3	C(50)	No	N/A	User Field
	
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field3') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field4	C(50)	No	N/A	User Field
	
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field4') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Detail User Field5	C(50)	No	N/A	User Field
	
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field5') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field6	C(50)	No	N/A	User Field

	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field6') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Master User Field1	C(10)	No	N/A	User Field

	If idsROMain.GetItemString(1,'user_field1') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field2	C(10)	No	N/A	User Field

	If idsROMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field3	C(10)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Master User Field4	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field5	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field6	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field6') <> '' Then
		
		// 09/13 - make sure we send order type with proper case
		lsTemp = idsROMain.GetItemString(1,'user_field6')
		If upper(lsTemp) = 'TRANSFERORDER' Then
			lsTEmp = 'TransferOrder'
		Elseif upper(lsTemp) = 'PURCHASEORDER' Then
			lsTEmp = 'PurchaseOrder'
		End If
		
		lsOutString += lsTemp + lsDelimitChar
		
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field7	C(30)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field8	C(30)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field9	C(255)	No	N/A	User Field
	
		If idsROMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field10	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field11	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field12	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field13	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field14	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field15	C(255)	No	N/A	User Field
		
	If idsROMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) //+ lsDelimitChar
	Else
		lsOutString += lsDelimitChar // TAM 2012/07 Remove comment.   Since new fields were add we need this delimeter
//		lsOutString += lsDelimitChar
	End If	
		
	

//Carrier
		
If idsROMain.GetItemString(1,'carrier') <> '' Then
	lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	
		
//Country Of Origin

If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'country_of_origin') <> '' Then
	lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'country_of_origin')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If			
			
//UnitOfMeasure - Hardcoded to 'EA' for now (PCONKL)
		
//If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'uom') <> '' Then
//	lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'uom')) + lsDelimitChar
//Else
	lsOutString += 'EA' +  lsDelimitChar /* 08/13 - PCONKL - Default to EA if missing*/
//End If				
		
//AWB #
		
If idsROMain.GetItemString(1,'AWB_BOL_No') <> '' Then
	lsOutString += String(idsROMain.GetItemString(1,'AWB_BOL_No')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	
				
/* dts - 'Division' Not used for Ariens...
//Division

//Get from Item_Master

Select grp INTO :lsGrp From Item_Master
	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
	USING SQLCA;
			
If IsNull(lsGrp) then lsGrp = ''

lsOutString += lsGrp  // Last item in GR so no Delimeter
*/

//END IF //End Riverbed
	
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
	
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

	Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Baseline Unicode Stock Adjustment just made

/* Not Implemented for ARIENS.  Copied from Klonelab pbl...

Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsRONO, lsOrder, lsPosNeg, lstemp

Decimal		ldBatchSeq, ldNetQty
Integer		liRC
String	lsLogOut
Datastore ldsAdjustment
lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = ldsAdjustment.GetITemString(1,'ro_no')

lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')


lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''

gu_nvo_process_files.uf_write_log(lsReason) /*display msg to screen*/
lsLogOut = lsReason
FileWrite(gilogFileNo,lsLogOut)	
	
lsOldInvType = ldsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = ldsAdjustment.GetITemString(1,"inventory_type")

llOwnerID = ldsAdjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = ldsAdjustment.GetITemNumber(1,"old_owner")

llAdjustID = ldsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = ldsAdjustment.GetITemNumber(1,"quantity")
lloldQty = ldsAdjustment.GetITemNumber(1,"old_quantity")

		
//We are only sending Qty Change or Breakage (New Inv Type = 'D')
/* dts - 05/22/06 - Now also sending transaction if coming OUT of 'D'.
       - should probably send when inventory moves from Pickable to Non-pickable or vice-versa (Inventory_Shippable_Ind)
		   but C. Geerts assures us that there will be only 'Normal' and 'Damaged' Inventory types */


//BCR 01-DEC-2011: Need to remove this IF statement in order to create the transaction for ALL Adjustments...

//If (lsOldInvType = 'N' and lsNewInvType = 'D') or (lsOldInvType = 'D' and lsNewInvType = 'N') or (llNewQTY <> llOldQTY)  Then
	
	//If lsNewInvType = 'D' Then /* set to Damage*/
	if lsOldInvType <> lsNewInvType then /* Inventory Type adjustment - either Normal-to-Damaged or Damaged-to-Normal */
		//BCR 01-DEC-2011: ICC now require single character for Transaction Types...
//		lsTranType = 'BRK'
		lsTranType = 'I'
	Else /* Process as a qty adjustment*/
//		lsTranType = 'QTY'
		lsTranType = 'Q'
	End If
	
	//BCR 01-DEC-2011: ICC now require single character for Transaction Types...and we have a TranType for Owner Change.
	IF llOrigOwnerID <> llOwnerID  THEN lsTranType = 'O'
	
	//BCR 01-DEC-2011: ...and we have a TranType for Other (i.e., none of the above).
	IF IsNull(lsTranType) OR lsTranType = '' THEN lsTranType = 'X'
		
	//If only the type changed, the qty is either qty, otherwise it is the abs of the difference
	If llNewQty < llOldQty Then
		ldNetQty = llOldQty - llNewQty
		lsPosNeg = '-'
	ElseIf llNewQty > llOldQty Then
		ldNetQty = llNewQty - llOldQty
		lsPosNeg = '+'
	Else /* qty not changed, only Inv Type Did*/
		ldNetQty = llOldQty
		lsPosNeg = '+'
	End If
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$MM$$HEX2$$1d200900$$ENDHEX$$Material movement identifier

	lsOutString = 'MM' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar
		
	//Warehouse	C(10)	Yes	N/A	Shipping Warehouse
	
	lsOutString +=  ldsAdjustment.GetITemString(1,"wh_code") + lsDelimitChar
	
	//Movement Type	C(1)	Yes	N/A	Movement type
	
	lsOutString += left(lsTranType,1) + lsDelimitChar
	
	//Date	Date	Yes	N/A	Transaction date 
	
	lsOutString += String(today(),'yyyy-mm-dd') + lsDelimitChar
	
	//Reason	C(40)	No	N/A	Reason for movement
	
	If IsNull(lsReason) then lsReason = ''
	
	lsOutString += lsReason + lsDelimitChar /*reason*/	
	
	//SKU	C(26)	Yes	N/A	Material number
	
	lsOutString += lsSku + lsDelimitChar
	
	//Suppler Code	C(20)	Yes	N/A	
	
	lsOutString += lsSupplier + lsDelimitChar	
	
	//Container ID	C(25)	No	N/A	
	
	If  ldsAdjustment.GetITemString(1,'Container_ID') <> '-' Then
		lsOutString += String( ldsAdjustment.GetITemString(1,'Container_ID')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( ldsAdjustment.GetITemDateTime(1,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar
	
	
	//Transaction Number	C(18)	No	N/A	Internal reference number
	
	lsOutString += Left(String(alAdjustID,'0000000000000000'),18) + lsDelimitChar /*Internal Ref #*/
	
	//Reference Number	C(16)	No	N/A	External reference number
	
	lsOutString += left(String(alAdjustID,'0000000000000000'),16) + lsDelimitChar /*External Ref #*/	
	
	//Old Quantity	N(15,5)	No	N/A	Quantity before adjustment
	
	lsOutString += String(llOldQty,'0')  + lsDelimitChar 	
	
	//New Quantity	N(15,5)	No	N/A	Quantity after adjustment
	
	lsOutString += String(llNewQty,'0')  + lsDelimitChar	
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	lsTemp = ldsAdjustment.GetITemString(1,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	

	//Old Owner	  C(20)	No	N/A	Owner before adjustment

	
	lsTemp = ldsAdjustment.GetITemString(1,'old_owner_cd')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//New Owner	C(20)	No	N/A	Owner after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'new_owner_cd')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		

	
	//Old Inventory Type	C(1)	No	N/A	Original Inventory Type
	
	lsOutString += left(lsOldInvType,1) + lsDelimitChar  /*old Inv Type*/	
	
	//New Inventory Type 	C(1)	No	N/A	New Inventory Type
	
	lsOutString += left(lsNewInvType,1) + lsDelimitChar /*New Inv Type*/	
	
	//Old Country of Origin	C(3)	No	N/A	Country of origin before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Country of Origin	C(3)	No	N/A	Country of origin after adjustment
	
	lsTemp = ldsAdjustment.GetITemString(1,'country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//Old Lot NBR	C(50)	No	N/A	Lot before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Lot NBR	C(50)	No	N/A	Lot after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//Old PO NBR	C(50)	No	N/A	PO before adjustment
	
	lsTemp = ldsAdjustment.GetITemString(1,'old_po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR	C(50)	No	N/A	PO after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Old PO NBR 2	C(50)	No	N/A	PO2 before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR 2	C(50)	No	N/A	PO2 after adjustment		

	lsTemp = ldsAdjustment.GetITemString(1,'po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp  + lsDelimitChar
	Else
		 lsOutString += lsDelimitChar
	End If			
	
	//BCR 28-DEC-2011: Added 3 more items as part of Geistlich coding...but still Baseline.
	
	//Per Pete: "You can default UOM to $$HEX1$$1820$$ENDHEX$$EA$$HEX2$$19202000$$ENDHEX$$and blanks for UF1. User ID can come from gs_userID"
	
	//MEA  01/12 - For Nike - Getting from Item_Master - UOM
	
	//UnitofMeasure	C(4)	No	N/A			

	lsTemp = ldsAdjustment.GetITemString(1,'uom_1')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar
	
	//MEA  01/12 - For Nike - Grabbing from Last_User

	//UserID	C(10)	No	N/A			

	lsTemp =ldsAdjustment.GetITemString(1,'last_user')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar

	//MEA  01/12 - For Nike - Grabbing from Item_Master - User_Field1
	
	//UserField1	C(50)	No	N/A			

	lsTemp = ldsAdjustment.GetITemString(1,'user_field1')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp  // + lsDelimitChar
		
	
	//End 28-DEC-2011
		
	lsLogOut = lsOutString + ":" + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)	
		
		
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
   //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)
	
//End If /* inv type changed*/
		

*/
Return 0

end function

public function integer uf_gi (string asproject, string asdono, string astype);/*  NOW USING uf_ship_confirm which loops through orders on a shipment and creates GI data in a single file

//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed
//copied from Klonelab pbl
//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode
String    lsUCCS
Integer   liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
If (idsDOMain.GetItemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))) Then 
	lsLogOut = "      - Order not received electronically. Not creating GI."
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
end if

//OR  idsDOMain.GetITemString(1,'create_user')  <> 'SIMSFP'  

idsDoDetail.Retrieve(asDoNo)

idsDoPick.Retrieve(asDoNo)

idsDoPack.Retrieve(asDoNo)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

	llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())



	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GI$$HEX2$$1d200900$$ENDHEX$$Goods issue confirmation identifier
	
	//MEA - 8/12 - If the file is being generated from a $$HEX1$$1820$$ENDHEX$$Ready to Ship$$HEX2$$19202000$$ENDHEX$$transaction, the Record ID will be $$HEX1$$1820$$ENDHEX$$RS$$HEX2$$19202000$$ENDHEX$$instead of $$HEX1$$1820$$ENDHEX$$GI$$HEX1$$1920$$ENDHEX$$. This is a baseline change.
	
	//IF astype = 'R' THEN //IF lsOrdStatus = 'R' THEN
	lsOutString = astype + lsDelimitChar	
	//END IF

	
	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsOutString +=  asproject + lsDelimitChar

	
	//Warehouse	C(10)	Yes		Shipping Warehouse
	
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
	//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
	
	
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	

	
	//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
	
		lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += lsSku  + lsDelimitChar	
	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	
	
	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition
	

	lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field

	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field

	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present

	lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Container ID	C(25)	No	N/A	
		
	lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//Price	N(12,4)	No	N/A	
	
	
	lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//Ship Date	Date	No	N/A	Actual Ship date

	//dts lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'), 'yyyymmddhhmmss') 
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
	//dts 7/14/13 - why is this hard coded for '1'?
	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	// dts GI018 in ARIENS DMA...
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//Carrier	C (20)	No	N/A	Input by user
	
	If idsDoMain.GetItemString(1,'Carrier') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	
	//Freight Cost	N(10,3)	No	N/A	
	
	lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))

	IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
	
	lsOutString += lsFreight_Cost + lsDelimitChar
		
	
	//Freight Terms	C(20)	No	N/A	
	
	lsTemp = Trim(idsDoMain.GetItemString(1,'Freight_Terms'))
	
	If IsNull(lsTemp) then lsTemp = ''

	//dts - 7/14/13 - For Ariens, we'll send what we received ('PREPAID', 'COLLECT', or 'THIRDPARTY')
/*
	CHOOSE CASE Upper(Trim(lsTemp))
	CASE 'PREPAID'
		lsTemp = 'PP'                    
	CASE 'COLLECT'
		lsTemp = 'CC'
	CASE  'THIRDPARTY'
		lsTemp = 'TP'	
	CASE 'PP THIRD PARTY'
		lsTemp = 'PC'
	CASE ELSE
		lsTemp = Left(lsTemp,2)
	END CHOOSE
*/	
	
	If lsTemp <> '' Then
		lsOutString += String(lsTemp) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//Total Weight	N(12,2)	No	N/A	
	
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		
	
	
	//Transportation Mode	C(10)	No	N/A	
	
	If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			

	
	//Delivery Date	Date	No	N/A	
	
	//dts - changing to 'yyyymmddhhmmss' (though I think it probably should be blank) lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmddhhmmss') 
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//Detail User Field1	C(20)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail User Field2	C(20)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field3	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field4	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field5	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field6	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//Detail User Field7	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//Detail User Field8	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			

//	//Master User Field1	C(10)	No	N/A	User Field	
//	
//	If idsDoMain.GetItemString(1,'user_field1') <> '' Then
//		lsOutString += String(idsDoMain.GetItemString(1,'user_field1')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	
	
	//Master User Field2	C(10)	No	N/A	User Field
	
	
	If idsDoMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Master User Field3	C(10)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field4	C(20)	No	N/A	User Field
	// dts - Equipment ID
	If idsDoMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field5	C(20)	No	N/A	User Field
	// dts - Carrier Pro #
	If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Master User Field6	C(20)	No	N/A	User Field
	// dts - Client Order Type
	If idsDoMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field7	C(30)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field8	C(60)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field9	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field10	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field11	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field12	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field13	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field14	C(50)	No	N/A	User Field
	//Routing #
	If idsDoMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field15	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field16	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field16') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field17	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field17') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field18	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field18') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//CustomerCode	
	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Ship To Name
	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Address 1	
	
	If idsDoMain.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Address 2	
	
	If idsDoMain.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//Ship Address 3	
	
	If idsDoMain.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//BCR 14-DEC-2011: Data Map requires address_4
	
	//Ship Address 4	
	
	If idsDoMain.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship City	
	
	If idsDoMain.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship State	

		If idsDoMain.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Ship Postal Code	
	
	If idsDoMain.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Country

	If idsDoMain.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//UnitOfMeasure (weight)
	
	//EWMS has the Package Weight hardcoded to $$HEX1$$1c20$$ENDHEX$$1.0$$HEX1$$1d20$$ENDHEX$$. I am assuming that is the UPM (Weight) field.
	
	//MEA - Outstand question to Pete - value of field - just pass place holder for now.

	lsOutString += lsDelimitChar

	//UnitOfMeasure (quantity)	

	If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If

	//CountryOfOrigin	
	 lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')

	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	


	//Master User Field19	 
	
	If idsDoMain.GetItemString(1,'user_field19') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
		
	
	//Master User Field20	

	If idsDoMain.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//Master User Field21	
	
	If idsDoMain.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If				
		

	//Master User User Field22	
	//dts 7/14/13 - delimiter was commented out prior to implementing for Ariens.  Now adding Estimated Delivery Date, Shipment ID, Cust Order No
	If idsDoMain.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Estimated Delivery Date
	// in the map but don't think they're using it for ARIENS
	lsTemp = ''
	//lsTemp = String( idsDoMain.GetItemDateTime(1, 'Freight_ETA'), 'yyyymmddhhmmss') 
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	//Shipment ID - at the order level this will be DM.Consolidation NO
	If idsDoMain.GetItemString(1, 'Consolidation_No') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1, 'Consolidation_No')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//Customer Order Number
	If idsDoMain.GetItemString(1, 'Cust_Order_No') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1, 'Cust_Order_No')) //+ lsDelimitChar
	Else
	//	lsOutString +=lsDelimitChar
	End If		

		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */


IF ProfileString(gsinifile, asproject, "IncludeGIPackDetail",'N')  = 'Y' THEN

	//Get the Project / Warehouse defaults for UCC
	
	lsWHCode = idsDoMain.GetItemString(1,'wh_code')
	
	SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :asproject USING SQLCA;
	
	IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
	
	SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;
	
	IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''
			
	
	llRowCount = idsDoPack.RowCount()
	
	For llRowPos = 1 to llRowCount
	
		llNewRow = idsOut.insertRow(0)
	
	
		lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
		lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
		lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
		lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
		lsSOM = idsdoPack.GetITEmString(llRowPos,'standard_of_measure')
	
		//Record_ID ($$HEX1$$1820$$ENDHEX$$PK$$HEX1$$1920$$ENDHEX$$)
	
		lsOutString = 'PK' + lsDelimitChar	
	
		//Project ID	C(10)	Yes	N/A	Project identifier
		
		lsOutString +=  asproject + lsDelimitChar
		
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
		
		//Carton Number 
		
		//On the Packing Segment, we need to prefix the carton number with the Project level and Warehouse level UCC values. 
		//Carton Number will end up being an 18 digit value consisting of $$HEX1$$1820$$ENDHEX$$Project.UCC_Company_Prefix$$HEX2$$19202000$$ENDHEX$$(8) + $$HEX1$$1820$$ENDHEX$$Warehouse.UCC_Location_Prefix$$HEX1$$1920$$ENDHEX$$(1) + $$HEX1$$1820$$ENDHEX$$Delivery_Packing.Carton_No$$HEX2$$19202000$$ENDHEX$$(9).  This can be baseline as those fields will be blank if not used.
		
		lsCartonNo = idsdoPack.GetITemString(llRowPos, 'Carton_No')
		
		If IsNull(lsCartonNo) then lsCartonNo = ''
		
		If lsCartonNo <> '' Then
			
			lsCartonNo = String( LONG (idsdoPack.GetITemString(llRowPos, 'Carton_No')) , "000000000" )
			
			lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
			
			//From BaseLine
			
			liCheck = f_calc_uccs_check_Digit(lsUCCS) 
		
			
			If liCheck >=0 Then
				lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
			Else
				lsUCCS = "00" + String(lsUCCS,'00000000000000000000') + "0"
			End IF
			
			lsOutString += lsUCCS  + lsDelimitChar
			
		Else
			
			lsOutString +=lsDelimitChar
	
		END IF
		
		
		//Line Item Number
		
		lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
		
		//SKU
		
		lsOutString += lsSku  + lsDelimitChar	
		
		//Qty
		
		lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
		//Weight (Gross for carton, repeated for all records)
		
		//Need to validate. - Make sure this is summing up correctly.
		
		If String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 
						
		
		//Weight Unit (for the current line/SKU) KG or LB
		 /* dts - why are we writing UOM twice in a row?  1st one should be the Net weight for the line (PK009 in DMA)
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		*/
		If String(idsDoPack.GetItemNumber(llRowPos, 'Weight_Net')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos, 'Weight_Net')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 
		
	
		
		//Weight SOM (standard of meas)
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Carton Length
	 
		If String(idsDoPack.GetItemNumber(llRowPos,'Length')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Length')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			 
					 
					 
		
		//Carton Width
		 
		 If String(idsDoPack.GetItemNumber(llRowPos,'Width')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Width')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
						 
		 
		
		//Carton Height
					
		 If String(idsDoPack.GetItemNumber(llRowPos,'Height')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Height')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
							
		
		//Carton DIM SOM (standard of meas) IN or CM
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'IN' + lsDelimitChar
			ELSE
				lsOutString += 'CM' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Ship Tracking Number
		
	
			 If idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	    
	
		
		//User Field 1
		
		If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//User Field 2
		
		If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  //+ lsDelimitChar
		Else
	//		lsOutString +=lsDelimitChar
		End If		
	
			
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	
	next /*next Delivery Pack record */

END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)


*/
Return 0
end function

public function integer uf_process_daily_inventory_rpt (string asinifile, string asproject, string asemail);//Process Daily Inventory Report

string lsFilename ="DailyInventoryReport-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inventory Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"archivedirectory","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)



ldsdir = Create Datastore
ldsdir.Dataobject = 'd_ariens_dboh'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject,asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

ldsDir.Sort()

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("Ariens",asEmail , "Daily Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0
end function

public function integer uf_process_daily_pro_report (string asinifile, string asproject, string asemail);
Datastore	ldsOrders
Long	llOrderCount, llOrderPos,llNewrow
String	SQL_Syntax, errors, lsLogOut, lsFileName, lsPath, msg, lsPRO, lsConsol
Integer	liRC

// Create our filename and path
lsFilename = "Ariens-Daily-PRO-Report-" + string(datetime(today(),now()),"MMDDYYYYHHMM") + '.txt'  //22-Oct-2013 :Madhu CR07 SIMS Ship Confirm Carrier PRO Details Report -changed from csv to txt
lsPath = ProfileString(asInifile,"ARIENS","archivedirectory","")
lsPath += '\' + lsFilename

//Jxlim 03/20/2014 Replaced User_field5 with Carrier_pro_no field	 
//Retrieve a list of all elligible Orders to process.
//22-Oct-2013 :Madhu CR07 SIMS Ship Confirm Carrier PRO Details Report - START
ldsOrders = Create Datastore
sql_syntax = "SELECT CONVERT(VARCHAR(10),complete_date ,101) as [ShipCompleteDate], REPLACE(CONVERT(VARCHAR(5),complete_date,108),':','') as [ShipCompleteTime],"
sql_syntax+="CASE WHEN WH_Code = 'AR_2760' THEN 'America/Chicago'  WHEN WH_Code = 'AR_2761' THEN 'America/New_York' "
sql_syntax+=" WHEN WH_Code = 'AR_2762' THEN 'America/Chicago'  WHEN WH_Code = 'AR_2763' THEN 'America/Chicago' END AS TimeZone,"
sql_syntax +="consolidation_no as 'Shipment_ID',Carrier_pro_no as 'PRO_Number', Carrier as 'Carrier' from delivery_Master " 
sql_syntax += " Where Project_ID = 'Ariens' and ord_status in ('C','D') and consolidation_no > ''  and (file_transmit_ind is null or file_transmit_ind <> 'Y')"
//22-Oct-2013 :Madhu CR07 SIMS Ship Confirm Carrier PRO Details Report - END
ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Ariens PRO Report~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF


ldsOrders.SetTransObject(SQLCA)
llOrderCOunt = ldsOrders.Retrieve()

If llOrderCount = 0 Then
	lsLogOut = "       No orders retrieved for processing PRO report for Ariens "
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

// Export the data to the file location
liRC = ldsOrders.saveas(lsPath,TEXT!,true) //22-Oct-2013 :Madhu -CR07 SIMS Ship Confirm Carrier PRO Details Report -changed from csv to TEXT
msg = 'Daily PRO  Report Save As Return Code: ' + string(liRC)
FileWrite(gilogFileNo,msg)
msg = 'Daily PRO Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the PRO Report */
gu_nvo_process_files.uf_send_email("Ariens",asEmail , "Daily PRO Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily PRO Report ", lsPath)

//Update the ordersto reflect they have been transmitted
For llOrderPos = 1 to llOrderCOunt
	
	lsPro= ldsOrders.GetITemString(llOrderPos,'PRO_Number')
	lsCOnsol = ldsOrders.GetITemString(llOrderPos,'Shipment_ID')
	
	Update Delivery_Master
	Set file_transmit_ind = 'Y'
	Where Project_id = 'Ariens' and consolidation_no = :lsConsol and  ord_status in ('C','D') and (file_transmit_ind is null or file_transmit_ind <> 'Y');
	
	Commit;
	
Next

Destroy ldsOrders

RETURN 0
end function

public function integer uf_ship_confirm (string as_project, string as_shipid, long aitransid);//Prepare a Goods Issue Transactions for each order in the Shipment
//started as uf_gi (which was copied from Klonelab), now grabbing a shipment and cycling through each order

/* TODO NOTES....
 - Need to confirm SHIPMENTS instead of ORDERS!
 -   ?Always??? If we will need to confirm individual orders, then we should call uf_gi (and call uf_gi from here instead of having the code in here)
 -  So far for testing, creating the shipment (from w_do - Note: must have valid carrier in Carrier Table)unit
 
 -    then setting Shipment.Ship_id and DM.Consolidation_NO to same value
 - Need to reliably link Orders to Shipment (DM.Consolidation_NO=S.Ship_ID, ???)
 - add 'SI'-type transaction in u_nvo_edi_confirmations.uf_ship_confirmation
 - add block for Ariens and call uf_ship_confirm
 -   - right now using GI transaction to call uf_ship_confirm. Need to create new 'SI' transaction type....
 - need to address the creation of the UCC Carton #
   - Should we create the Carton #s (in packing) in the UCC format and then just write the carton # here (below)?
*/

Long	llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode
String    lsUCCS
Integer   liCheck

Decimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

string sql_Syntax, ERRORS
DataStore	ldsOrders
long llOrderCount, llOrderPos
string lsDONO, lsUOM,lsUF6
integer liCartonNo

//messagebox (string(1, '0000'), 'x')
//messagebox (string('1', '0000'), 'xx')

//Jxlim 09/17/2013 CR27 SHIPPED but Ariens doesn't have Shipped Info. Need to release @ Order level instead of Shipment level
///*dts - 8/12/13 - Slamming this in so we don't create the SI file unless all orders (on the shipment) are complete. 
// 	- we really should be confirming from the Shipment screen and only ever creating one SI trans.*/
//select count(do_no) into :llOrderCount from Delivery_Master 
//where project_id = 'ARIENS'
//and consolidation_no = :as_ShipID
//and ord_status not in('C', 'D', 'V');
//
//If llOrderCount > 0 Then
//	lsLogOut = "       Not creating SI file for Ariens shipment " + as_ShipID + " as not all Orders are complete."
//	FileWrite(gilogFileNo,lsLogOut)
//	Return 0
//End If	

////Retrieve all the Orders on the shipment
//ldsOrders = Create Datastore
//sql_syntax = "SELECT do_no from delivery_Master " 
//sql_syntax += " Where Project_ID = 'ARIENS' and ord_status in ('C','D') and consolidation_no = '" + as_ShipId + "'"
//ldsOrders.Create(SQLCA.SyntaxFromSQL(sql_syntax, "", ERRORS))
//IF Len(ERRORS) > 0 THEN
//   lsLogOut = "        *** Unable to create datastore for Ariens Shipment-Orders~r~r" + Errors
//	FileWrite(gilogFileNo,lsLogOut)
//   RETURN - 1
//END IF
//
//ldsOrders.SetTransObject(SQLCA)
//llOrderCount = ldsOrders.Retrieve()
//
//If llOrderCount = 0 Then
//	lsLogOut = "       No orders retrieved for processing Ariens SI for shipment " + as_ShipID
//	FileWrite(gilogFileNo,lsLogOut)
//	Return 0
//End If

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_Detail'
	idsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_Detail_Ariens' /* 09/13 - PCONKL - adds join to serial_Detail for outbound scanned serial numbers*/
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating SI For Shipment: " + as_ShipID
FileWrite(gilogFileNo,lsLogOut)

//moved this from below - do once for the shipment (not each order)
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(as_project,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Ariens!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
//Jxlim 09/17/2013 CR27 SHIPPED but Ariens doesn't have Shipped Info. Need to release @ Order level instead of Shipment level;Send SI for every order confirmation at a time, no looping
//Loop through each order and add to current file
//For llOrderPos = 1 to llOrderCount

//Jxlim Get dono from trans_parm on batch_transaction
Select Trans_parm Into :lsdono		
From Batch_transaction
Where Trans_id = :aitransid and  project_id =:as_project and Trans_Order_Id =:as_shipid; 

	//lsDoNO = ldsOrders.GetItemString(llOrderPos, 'do_no')
	lsLogOut = "        Creating GI For DONO: " + lsDONO	
	FileWrite(gilogFileNo,lsLogOut)
	
	//Retreive Delivery Master and Detail  records for this DONO
	If idsDOMain.Retrieve(lsDoNo) <> 1 Then
		lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + lsDONO
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
	/* dts
	//If not received elctronically, don't send a confirmation
	If (idsDOMain.GetItemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetItemNumber(1,'edi_batch_seq_no'))) Then 
		lsLogOut = "      - Order not received electronically. Not creating GI."
		FileWrite(gilogFileNo,lsLogOut)
		Return 0
	end if
	*/
	
	//OR  idsDOMain.GetITemString(1,'create_user')  <> 'SIMSFP'  
	
	idsDoDetail.Retrieve(lsDoNo)
	
	idsDoPick.Retrieve(lsDoNo)
	
	idsDoPack.Retrieve(lsDoNo)
	
	//Write the rows to the generic output table - delimited by lsDelimitChar
	
	llRowCount = idsDoPick.RowCount()
	
	For llRowPos = 1 to llRowCOunt
	
		llNewRow = idsOut.insertRow(0)
	
		lsSku = idsdoPick.GetItemString(llRowPos,'sku')
		lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
		lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
		lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
	
		llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	
		//Can't Find Detail
		IF llDetailFind <= 0 then 
			continue
		End If
	
		llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())
	
	
		lsOutString = 'GI' + lsDelimitChar	
			
		
		//Project ID	C(10)	Yes	N/A	Project identifier
		lsOutString +=  as_project + lsDelimitChar
		
		//Warehouse	C(10)	Yes		Shipping Warehouse
		lsWarehouse = idsDoMain.GetItemString(1,'wh_code')
		lsOutString += lsWarehouse + lsDelimitChar
		
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
	
		
		//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
		lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
		
		//SKU	C(50)	Yes	N/A	Material number
		lsOutString += lsSku  + lsDelimitChar	
		
		//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
		lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
		//Inventory Type	C(1)	Yes	N/A	Item condition
		lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
		
		//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
		lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
		
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	
		
		//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
		lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
		If IsNull(lsTemp) then lsTemp = ''
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
		lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
		If IsNull(lsTemp) then lsTemp = ''
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Serial Number	C(50)	No	N/A	Qty must be 1 if present
		lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
		If IsNull(lsTemp) then lsTemp = ''
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Container ID	C(25)	No	N/A	
		lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
		If IsNull(lsTemp) then lsTemp = ''
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Expiration Date	Date	No	N/A	
		lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		
	
		//Price	N(12,4)	No	N/A	
		//lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
		lsTemp = '' /* 09/13 - PCONKL - there is no price on picking_Detail*/
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	
		
		//Ship Date	Date	No	N/A	Actual Ship date
		//dts lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
		lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'), 'yyyymmddhhmmss') 
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar
	
		//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
		//dts 7/14/13 - why is this hard coded for '1'?
		lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar
		
		//Ship Tracking Number	C(25)	No	N/A	
		// dts GI018 in ARIENS DMA...
		If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
		
		//Carrier	C (20)	No	N/A	Input by user
		If idsDoMain.GetItemString(1,'Carrier') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
		
		//Freight Cost	N(10,3)	No	N/A	
		lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))
		IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
		lsOutString += lsFreight_Cost + lsDelimitChar
		
		//Freight Terms	C(20)	No	N/A	
		lsTemp = Trim(idsDoMain.GetItemString(1,'Freight_Terms'))
		If IsNull(lsTemp) then lsTemp = ''
		//dts - 7/14/13 - For Ariens, we'll send what we received ('PREPAID', 'COLLECT', or 'THIRDPARTY')
	/*
		CHOOSE CASE Upper(Trim(lsTemp))
		CASE 'PREPAID'
			lsTemp = 'PP'                    
		CASE 'COLLECT'
			lsTemp = 'CC'
		CASE  'THIRDPARTY'
			lsTemp = 'TP'	
		CASE 'PP THIRD PARTY'
			lsTemp = 'PC'
		CASE ELSE
			lsTemp = Left(lsTemp,2)
		END CHOOSE
	*/	
		If lsTemp <> '' Then
			lsOutString += String(lsTemp) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If				
		
		//Total Weight	N(12,2)	No	N/A	
		IF llPackFind > 0 then
			lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
		Else
			lsTemp = ""	
		End If
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar		
		
		//Transportation Mode	C(10)	No	N/A	
		If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
		
		//Delivery Date	Date	No	N/A	
		//dts - changing to 'yyyymmddhhmmss' (though I think it probably should be blank) lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
		lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmddhhmmss') 
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	

		//Detail User Field1	C(20)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Detail User Field2	C(20)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field3	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field4	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field5	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Detail User Field6	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
		
		//Detail User Field7	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
		
		//Detail User Field8	C(30)	No	N/A	User Field
		If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If			
	
	//	//Master User Field1	C(10)	No	N/A	User Field	
	//	
	//	If idsDoMain.GetItemString(1,'user_field1') <> '' Then
	//		lsOutString += String(idsDoMain.GetItemString(1,'user_field1')) + lsDelimitChar
	//	Else
	//		lsOutString += lsDelimitChar
	//	End If	
		
		//Master User Field2	C(10)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Master User Field3	C(10)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field3') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field4	C(20)	No	N/A	User Field
		// dts - Equipment ID
		If idsDoMain.GetItemString(1,'user_field4') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Jxlim 03/20/2014 Replace Dm.User_field5 with carrier_pro_no
		//Master User Field5	C(20)	No	N/A	User Field
		// dts - Carrier Pro #
		//If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		//	lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
		If idsDoMain.GetItemString(1,'carrier_pro_no') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'carrier_pro_no')) + lsDelimitChar
		Else
			//Jxlim 03/26/2014 during the transitioned of replacing pro no field we will continue to use user_field5 
			//until all client (document and report) are 100% replaced with carrier_pro_no field, then this user_field code will be removed
			If idsDoMain.GetItemString(1,'user_field5') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If
		End If			
			
		//Master User Field6	C(20)	No	N/A	User Field
		// dts - Client Order Type
		If idsDoMain.GetItemString(1,'user_field6') <> '' Then
			//27-Feb-2014 :Madhu- Added code check Client Order Type -START
			//lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
			lsUF6 = String(idsDoMain.GetItemString(1,'user_field6'))
			IF lsUF6 <> "SalesOrder"  and lsUF6 <>"TransferOrder" Then
				lsUF6= 'SalesOrder'
			END IF
			lsOutString += lsUF6 + lsDelimitChar
			//27-Feb-2014 :Madhu- Added code to check Client Order Type -END
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field7	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field7') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field8	C(60)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field8') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
		//Master User Field9	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field9') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field10	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field10') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field11	C(30)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field11') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field12	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field12') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field13	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field13') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Master User Field14	C(50)	No	N/A	User Field
		//Routing #
		If idsDoMain.GetItemString(1,'user_field14') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field15	C(50)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field15') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field16	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field16') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field17	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field17') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
		
		//Master User Field18	C(100)	No	N/A	User Field
		If idsDoMain.GetItemString(1,'user_field18') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//CustomerCode	
		If idsDoMain.GetItemString(1,'cust_code') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Ship To Name
		If idsDoMain.GetItemString(1,'cust_name') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Ship Address 1	
		If idsDoMain.GetItemString(1,'address_1') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Ship Address 2	
		If idsDoMain.GetItemString(1,'address_2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Ship Address 3	
		If idsDoMain.GetItemString(1,'address_3') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//BCR 14-DEC-2011: Data Map requires address_4
		//Ship Address 4	
		If idsDoMain.GetItemString(1,'address_4') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Ship City	
		If idsDoMain.GetItemString(1,'city') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Ship State	
			If idsDoMain.GetItemString(1,'state') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Ship Postal Code	
		If idsDoMain.GetItemString(1,'zip') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Ship Country
		If idsDoMain.GetItemString(1,'country') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//UnitOfMeasure (weight)
		//EWMS has the Package Weight hardcoded to $$HEX1$$1c20$$ENDHEX$$1.0$$HEX1$$1d20$$ENDHEX$$. I am assuming that is the UPM (Weight) field.		
		//MEA - Outstand question to Pete - value of field - just pass place holder for now.
		
		// Jxlim 07/31/2013 Ariens;
		//UOM is configured in Project_warehouse for each warehouse in Sims
		//If English is Inch;LB and Metric is CM; KG
		//Select Standard_Of_Measure Into :lsUOM 
		//From Project_Warehouse 
		//Where Project_Id =:as_project and WH_Code=:lswarehouse;
		
		 //If lsUOM <> '' Then
			//IF Trim(lsUOM) = 'E' THEN
			//		lsOutString += 'LB' + lsDelimitChar
				//ELSE
					//lsOutString += 'KG' + lsDelimitChar
				//END IF
		//Else
				//Assume English is blank for Ariens
				lsOutString += 'LB' + lsDelimitChar
				//lsOutString +=lsDelimitChar
		//End If	
				
	
		//UnitOfMeasure (quantity)	- Hardcoded to "EA' for now (PCONKL)
		//If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
		//	lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
		//Else
			lsOutString += 'EA' +  lsDelimitChar
		//End If
	
		//CountryOfOrigin	
		 lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar	
	
		//Master User Field19	 
		If idsDoMain.GetItemString(1,'user_field19') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
			
		//Master User Field20	
		If idsDoMain.GetItemString(1,'user_field20') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		//Master User Field21	
		If idsDoMain.GetItemString(1,'user_field21') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If				
			
		//Master User User Field22	
		//dts 7/14/13 - delimiter was commented out prior to implementing for Ariens.  Now adding Estimated Delivery Date, Shipment ID, Cust Order No
		If idsDoMain.GetItemString(1,'user_field22') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
		
		//Estimated Delivery Date
		lsTemp = ''
		lsTemp = String( idsDoMain.GetItemDateTime(1, 'Freight_ETA'), 'yyyymmddhhmmss') 
		If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp+ lsDelimitChar
	
		//Shipment ID - at the order level this will be DM.Consolidation NO
		If idsDoMain.GetItemString(1, 'Consolidation_No') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1, 'Consolidation_No')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		
	
		//Customer Order Number
		If idsDoMain.GetItemString(1, 'Cust_Order_No') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1, 'Cust_Order_No')) //+ lsDelimitChar
		Else
		//	lsOutString +=lsDelimitChar
		End If		
	
			
		idsOut.SetItem(llNewRow,'Project_id', as_Project)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		//lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
		//dts 7/15/13 - New Transaction 'SI' for Shipment Issue...
		lsFileName = 'SI' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	next /*next Picking Detail record */
	
	
	IF ProfileString(gsinifile, as_project, "IncludeGIPackDetail",'N')  = 'Y' THEN
	
		//Get the Project / Warehouse defaults for UCC
		
		lsWHCode = idsDoMain.GetItemString(1,'wh_code')
		
		SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :as_project USING SQLCA;
		
		IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
		
		SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;
		
		IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''
				
		
		llRowCount = idsDoPack.RowCount()
		For llRowPos = 1 to llRowCount
			llNewRow = idsOut.insertRow(0)
			lsSku = idsdoPack.GetItemString(llRowPos,'sku')
			lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
			lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
			lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
			lsSOM = idsdoPack.GetITEmString(llRowPos,'standard_of_measure')
		
			//Record_ID ($$HEX1$$1820$$ENDHEX$$PK$$HEX1$$1920$$ENDHEX$$)
			lsOutString = 'PK' + lsDelimitChar	
		
			//Project ID	C(10)	Yes	N/A	Project identifier
			lsOutString +=  as_project + lsDelimitChar
			
			//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
			lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
			
			//Carton Number 
			//On the Packing Segment, we need to prefix the carton number with the Project level and Warehouse level UCC values. 
			//Carton Number will end up being an 18 digit value consisting of $$HEX1$$1820$$ENDHEX$$Project.UCC_Company_Prefix$$HEX2$$19202000$$ENDHEX$$(8) + $$HEX1$$1820$$ENDHEX$$Warehouse.UCC_Location_Prefix$$HEX1$$1920$$ENDHEX$$(1) + $$HEX1$$1820$$ENDHEX$$Delivery_Packing.Carton_No$$HEX2$$19202000$$ENDHEX$$(9).  This can be baseline as those fields will be blank if not used.
			lsCartonNo = idsdoPack.GetItemString(llRowPos, 'Carton_No')
			If IsNull(lsCartonNo) then lsCartonNo = ''
			If lsCartonNo <> '' Then
				/* per Ariens, The base is $$HEX1$$1820$$ENDHEX$$0000751058000000000N$$HEX2$$18202000$$ENDHEX$$where N is the check digit.
				lsUCCS must be 17 digits long....
				using 00751058 for Company code, preceding that by '00' so need 9 digits for serial of carton
				using last 5 of do_no and then carton numbers, formatted to 4 digits
				*/
				//lsCartonNo = String( LONG (idsdoPack.GetItemString(llRowPos, 'Carton_No')) , "000000000" )
				//the string function to pad 0's for the carton number doesn't work (returning only '0000')
				liCartonNo = integer(lsCartonNo)
				lsCartonNo = right(lsDONO, 5) + string(liCartonNo, '0000')
				lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
				//From BaseLine
				liCheck = f_calc_uccs_check_Digit(lsUCCS) 
				If liCheck >=0 Then
					lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
				Else
					lsUCCS = "00" + String(lsUCCS, '00000000000000000000') + "0"
				End IF
				lsOutString += lsUCCS  + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			END IF
			
			//Line Item Number
			lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
			
			//SKU
			lsOutString += lsSku  + lsDelimitChar	
			
			//Qty
			lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
			
			//Weight (Gross for carton, repeated for all records)
			//Need to validate. - Make sure this is summing up correctly.
			If String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) <> '' Then
				lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	 
							
			//Weight Unit (for the current line/SKU) KG or LB
			 /* dts - why are we writing UOM twice in a row?  1st one should be the Net weight for the line (PK009 in DMA)
			 If lsSOM <> '' Then
				IF Trim(lsSOM) = 'E' THEN
					lsOutString += 'LB' + lsDelimitChar
				ELSE
					lsOutString += 'KG' + lsDelimitChar
				END IF
			Else
				lsOutString +=lsDelimitChar
			End If	
			*/
			If String(idsDoPack.GetItemNumber(llRowPos, 'Weight_Net')) <> '' Then
				lsOutString += String(idsDoPack.GetItemNumber(llRowPos, 'Weight_Net')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	 
			
			//Weight SOM (standard of meas)
			 If lsSOM <> '' Then
				IF Trim(lsSOM) = 'E' THEN
					lsOutString += 'LB' + lsDelimitChar
				ELSE
					lsOutString += 'KG' + lsDelimitChar
				END IF
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//Carton Length
			If String(idsDoPack.GetItemNumber(llRowPos,'Length')) <> '' Then
				lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Length')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	 			 
						 
			//Carton Width
			 If String(idsDoPack.GetItemNumber(llRowPos,'Width')) <> '' Then
				lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Width')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	 			
							 
			//Carton Height
			 If String(idsDoPack.GetItemNumber(llRowPos,'Height')) <> '' Then
				lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Height')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	 			
								
			//Carton DIM SOM (standard of meas) IN or CM
			 If lsSOM <> '' Then
				IF Trim(lsSOM) = 'E' THEN
					lsOutString += 'IN' + lsDelimitChar
				ELSE
					lsOutString += 'CM' + lsDelimitChar
				END IF
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//Ship Tracking Number
			If idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID') <> '' Then
				lsOutString += String(idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	    
		
			//User Field 1
			If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
				lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
			
//			//Jxlim 04/10/2014 Commented out per Pete as it is not ready for deployment at this time		
			//User Field 2
//			If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
//				lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2')) 			
//			End If		

			//User Field 2
			If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
				lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar  // 06-Mar-2014 :Madhu- Added for Ariens SSCC
			End If		
			
			//Jxlim 04/10/2014 Commented this out per Pete as it is not ready in ICC integretion
			//06-Mar-2014 :Madhu- Ariens SSCC -START
			If idsDoPack.GetItemString(llRowPos, 'free_form_serial_no') <> '' Then
				lsOutString += String(idsDoPack.GetItemString(llRowPos,'free_form_serial_no'))
			End If
			//06-Mar-2014 :Madhu- Ariens SSCC -END
			
			idsOut.SetItem(llNewRow,'Project_id', as_Project)
			idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		//	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
			lsFileName = 'SI' + String(ldBatchSeq,'000000') + '.dat'
			idsOut.SetItem(llNewRow,'file_name', lsFileName)
				
		next /*next Delivery Pack record */
	
	END IF
//next //next order in shipment  //Jxlim 09/17/2013 commented out looping

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, as_Project)


Return 0
end function

public function integer uf_process_daily_eod_shipped_rpt (string asinifile, string asproject, string asemail);//Jxlim 04/23/2014 Ariens Process Daily Shipped EOD Report

string lsFilename 
string lsPath,lsFileNamePath,msg,lsLogOut, lsPathArchive
int returnCode,liRC, li_ret
long llRowCount, llnewrow, i
Decimal ldbatchseq
Datastore	ldsdir

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily EOD Shipped Orders Report'
FileWrite(gilogFileNo,msg)

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
		
// Create our filename and path
//Jxlim 04/18/2014 Create a file name with .xml--Ariens- L13P506 --OSR<six digit sequential number>.xml
//lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.xml'  
lsFileName = 'OSR' + String(ldBatchSeq,'000000') + '.xml'
lsPath = ProfileString(asInifile,"ARIENS","flatfiledirout","")   //write to Flatfiledirout
lsPath += '\' + lsFilename

// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_shipped_eod_rpt'
lirc = ldsdir.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily EOD Shipped Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily EOD Shipped Orders Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject,asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

ldsDir.Sort()

// Export the data to the file location
//Jxlim 04/18/2014 Use Save as to save the records into .xml file format--Ariens- L13P506
returnCode = ldsdir.saveas(lsPath,XML!,true)
msg = 'Daily EOD Shipped  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily EOD Shipped Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)
				
				//Jxlim 04/24/2014 write to archive folder
				lsPathArchive = ProfileString(asInifile,"ARIENS","archivedirectory","")
				lsPathArchive += '\' + lsFilename + '.txt'
				
				li_ret=FileCopy(lsPath,lsPathArchive,True)
				//Jxlim 01/23/2012 write message on archive status
				If li_ret = 1 Then
					lsLogOut = Space(10) + "File archived to: " + lsPathArchive
					FileWriteEx(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_Log(lsLogOut)
				Else /*unable to archive*/
					lsLogOut = Space(10) + "*** Unable to archive File: " + lsPathArchive
					FileWriteEx(giLogFileNo,lsLogOut)
					gu_nvo_process_files.uf_write_Log(lsLogOut)
				End If
Destroy ldsdir

RETURN 0
end function

on u_nvo_edi_confirmations_ariens.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_ariens.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

