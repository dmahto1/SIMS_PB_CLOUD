HA$PBExportHeader$u_nvo_edi_confirmations_h2o.sru
$PBExportComments$Process outbound edi confirmation transactions for h2o
forward
global type u_nvo_edi_confirmations_h2o from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_h2o from nonvisualobject
end type
global u_nvo_edi_confirmations_h2o u_nvo_edi_confirmations_h2o

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_process_dboh (string asproject, string asinifile)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llDetailFindRow,	llNewRow, llLineItemNo
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp

DEcimal		ldBatchSeq
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

idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to H2O!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	llLineItemNo = idsroputaway.GetItemNumber(llRowPos,'line_item_no')
	
	//will need detail line for some fields
	llDetailFindRow = idsRODetail.Find("Line_Item_No = " + String(llLineItemNo) + " and upper(sku) = '" + upper(lsSKU) + "'", 1, idsRODetail.RowCount())
	
	llNewRow = idsOut.insertRow(0)
	
		
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
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number
	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar
	
	//Supplier COde
	lsOutString += idsroputaway.GetItemString(llRowPos,'supp_code') + lsDelimitChar
	
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
	
	
	//Detail User  Line Number	C(25)	No	N/A	User Line Item No
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
		lsOutString += String(idsROMain.GetItemString(1,'user_field6')) + lsDelimitChar
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
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar 
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
			
	//UnitOfMeasure
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'uom') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		
	//AWB #
	If idsROMain.GetItemString(1,'AWB_BOL_No') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'AWB_BOL_No')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
				
//	Item Group (from Item Master)
	Select grp INTO :lsGrp From Item_Master
	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
	USING SQLCA;
			
	If IsNull(lsGrp) then lsGrp = ''
	lsOutString += lsGrp  
	
	lsOutString += lsDelimitChar
	
	//01/16 - PCONKL - New Named FIelds
	
	//Client Cust PO Nbr
	If idsROMain.GetItemString(1,'client_cust_po_nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'client_cust_po_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Client Invoice Nbr
	If idsROMain.GetItemString(1,'client_invoice_nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'client_invoice_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Container Nbr
	If idsROMain.GetItemString(1,'container_nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'container_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Client Order Type
	If idsROMain.GetItemString(1,'client_order_type') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'client_order_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Container Type
	If idsROMain.GetItemString(1,'container_Type') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'container_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//From WH Loc
	If idsROMain.GetItemString(1,'from_wh_loc') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'from_wh_loc')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Seal  Nbr
	If idsROMain.GetItemString(1,'seal_nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'seal_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Vendor Invoice Nbr
	If idsROMain.GetItemString(1,'vendor_invoice_nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'vendor_invoice_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Currency Code
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'currency_Code') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'currency_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Supplier Order Number
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'Supplier_Order_Number') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'Supplier_Order_Number')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Cust PO Nbr
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'cust_po_nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'cust_po_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Line COntainer Nbr
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'line_container_nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'line_container_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Vendor Line Nbr
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'vendor_line_nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'vendor_line_nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail - Client Line Nbr - LAST COLUMN
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'client_line_nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'client_line_nbr')) // + lsDelimitChar
	Else
		//lsOutString += lsDelimitChar
	End If	
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
	
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Baseline Unicode Stock Adjustment just made


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
		


Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed



Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

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
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline'  
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

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
//If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0

idsDoDetail.Retrieve(asDoNo)

idsDoPick.Retrieve(asDoNo)

idsDoPack.Retrieve(asDoNo)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to H2O!'"
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
	//GI001 Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GI$$HEX2$$1d200900$$ENDHEX$$Goods issue confirmation identifier
	
	//MEA - 8/12 - If the file is being generated from a $$HEX1$$1820$$ENDHEX$$Ready to Ship$$HEX2$$19202000$$ENDHEX$$transaction, the Record ID will be $$HEX1$$1820$$ENDHEX$$RS$$HEX2$$19202000$$ENDHEX$$instead of $$HEX1$$1820$$ENDHEX$$GI$$HEX1$$1920$$ENDHEX$$. This is a baseline change.
	
	IF lsOrdStatus = 'R' THEN
		lsOutString = 'RS' + lsDelimitChar	
	ELSE
		lsOutString = 'GI' + lsDelimitChar
	END IF

	
	//GI002 Project ID	C(10)	Yes	N/A	Project identifier	
	lsOutString +=  asproject + lsDelimitChar
	
	//GI003 Warehouse	C(10)	Yes		Shipping Warehouse	
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
	//GI004 Delivery Number	C(10)	Yes	N/A	Delivery Order Number		
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
	
	//GI005 Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number	
	lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
	//GI006 SKU	C(50)	Yes	N/A	Material number
	lsOutString += lsSku  + lsDelimitChar	
	
	//GI007 Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	If 	idsdoPick.GetITemString(llRowPos,'Serial_No') <> '' Then
		lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'serial_qty')) + lsDelimitChar
	Else
		lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	End If	
	
	//GI008 Inventory Type	C(1)	Yes	N/A	Item condition	
	lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
	
	//GI009 Lot Number	C(50)	No	N/A	1st User Defined Inventory field	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//GI010 PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI011PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI012 Serial Number	C(50)	No	N/A	Qty must be 1 if present
	lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI013 Container ID	C(25)	No	N/A			
	lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI014 Expiration Date	Date	No	N/A	
	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//GI015 Price	N(12,4)	No	N/A		
	lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//GI016 Ship Date	Date	No	N/A	Actual Ship date
	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//GI017 Package Count	N(5,0)	No	N/A	Total no. of package in delivery
	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//GI018 Ship Tracking Number (AWB)	C(25)	No	N/A		
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		//BCR 30-DEC-2011: Geistlich UAT fix...
//		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//GI019 Carrier	C (20)	No	N/A	Input by user	
	If idsDoMain.GetItemString(1,'Carrier') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		
	//GI020 Freight Cost	N(10,3)	No	N/A		
	lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))

	IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
	
	lsOutString += lsFreight_Cost + lsDelimitChar
		
	
	//GI021 Freight Terms	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'Freight_Terms') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Freight_Terms')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//GI022 Total Weight	N(12,2)	No	N/A		
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//GI023 Transportation Mode	C(10)	No	N/A		
	If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//GI024 Delivery Date	Date	No	N/A		
	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//GI025 Detail User Field1	C(20)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI026 Detail User Field2	C(20)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI027 Detail User Field3	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI028 Detail User Field4	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI029 Detail User Field5	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI030 Detail User Field6	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//GI031 Detail User Field7	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//GI032 Detail User Field8	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//*****************/MAster User fieldxxx**************************************
	//GI033 Master User Field2	C(10)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//GI034 Master User Field3	C(10)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//GI035 Master User Field4	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//GI036 Master User Field5	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//GI037 Master User Field6	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//GI038 Master User Field7	C(30)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//GI039 Master User Field8	C(60)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//GI040 Master User Field9	C(30)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI041 Master User Field10	C(30)	No	N/A	User Field	BOL No,  we are sending awb_nol_no in GI041 position
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI042 Master User Field11	C(30)	No	N/A	User Field	Carrier Pro No, we are sending carrier_pro_no in GI042 position
	If idsDoMain.GetItemString(1,'carrier_pro_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'carrier_pro_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI043 Master User Field12	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI044 Master User Field13	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI045 Master User Field14	C(50)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI046 Master User Field15	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI047 Master User Field16	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field16') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI048 Master User Field17	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field17') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI049 Master User Field18	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field18') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI050 CustomerCode		
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//GI051 Ship To Name	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI052 Ship Address 1		
	If idsDoMain.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI053 Ship Address 2		
	If idsDoMain.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//GI054 Ship Address 3		
	If idsDoMain.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
		
	//GI055 Ship Address 4		
	If idsDoMain.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI056 Ship City		
	If idsDoMain.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI057 Ship State	
		If idsDoMain.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//GI058 Ship Postal Code
	
	If idsDoMain.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI059 Ship Country
	If idsDoMain.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//GI060 Ship Telephone	
	If idsDoMain.GetItemString(1,'tel') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'tel')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//GI061 UnitOfMeasure (quantity)	
	If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If

	//GI062 CountryOfOrigin	
	 lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')

	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	


	//GI063 Master User Field19		
	If idsDoMain.GetItemString(1,'user_field19') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI064 Master User Field20	
	If idsDoMain.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//GI065 Master User Field21		
	If idsDoMain.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If				
		

	//GI066 Master User User Field22	
	If idsDoMain.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	// 01/16 - PCONKL - New named fields...
	
	//GI067 Master Department Code	
	If idsDoMain.GetItemString(1,'Department_Code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI068 Master Department Name	
	If idsDoMain.GetItemString(1,'Department_Name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI069 Master Department Code	
	If idsDoMain.GetItemString(1,'Division') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Division')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI070 Master Vendor	
	If idsDoMain.GetItemString(1,'Vendor') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Vendor')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI071 Detail - Buyer Part	
	If idsdoDetail.GetItemString(llDetailFind,'Buyer_Part') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Buyer_Part')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI072 Detail - Vendor Part	
	If idsdoDetail.GetItemString(llDetailFind,'Vendor_Part') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Vendor_Part')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI073 Detail - UPC	
	If idsdoDetail.GetItemString(llDetailFind,'UPC') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'UPC')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI074 Detail - EAN	
	If idsdoDetail.GetItemString(llDetailFind,'EAN') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'EAN')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI075 Detail - GTIN	
	If idsdoDetail.GetItemString(llDetailFind,'GTIN') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'GTIN')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI076 Detail - Department Name 	
	If idsdoDetail.GetItemString(llDetailFind,'Department_Name') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Department_Name')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI077 Detail - Division	
	If idsdoDetail.GetItemString(llDetailFind,'Division') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Division')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//GI078 SSCC - **Not in Master or Detail, not sure why it's on the layout but it's been published, leave blank for now **
	lsOutString += lsDelimitChar
	
	//GI079 Master Account Number	
	If idsDoMain.GetItemString(1,'Account_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Account_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI080 Master ASN Number	
	If idsDoMain.GetItemString(1,'ASN_Number') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'ASN_Number')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If		
	
	//GI081 Master Client Cust PO Nbr	
	If idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI082 Master Client Cust SO Nbr	
	If idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI083 Master Container Nbr	
	If idsDoMain.GetItemString(1,'Container_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Container_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI084 Master Dock Code	
	If idsDoMain.GetItemString(1,'Dock_Code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Dock_Code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI085 Master Document Codes	
	If idsDoMain.GetItemString(1,'Document_Codes') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Document_Codes')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI086 Master Equipment Nbr	
	If String(idsDoMain.GetItemNumber(1,'Equipment_Nbr')) <> '' Then
		lsOutString += String(idsDoMain.GetItemNumber(1,'Equipment_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI087 Master FOB	
	If idsDoMain.GetItemString(1,'FOB') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI088 Master FOB	Bill Duty Acct
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI089 Master FOB	Bill Duty Party
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI090 Master FOB	Bill Freight Party
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI091 Master FOB	Bill Freight To Acct
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_To_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Freight_To_Acct')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI092 Master From Warehouse
	If idsDoMain.GetItemString(1,'From_wh_Loc') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'From_Wh_Loc')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI093 Master Routing Number
	If idsDoMain.GetItemString(1,'Routing_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Routing_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI094 Master Seal Number
	If idsDoMain.GetItemString(1,'Seal_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Seal_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI095 Master Shipping Route
	If idsDoMain.GetItemString(1,'Shipping_Route') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Shipping_Route')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI096 Master SLI Nbr
	If idsDoMain.GetItemString(1,'SLI_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'SLI_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI097 Detail - client Cust Line No	
	If idsdoDetail.GetItemString(llDetailFind,'Client_Cust_Line_No') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Client_Cust_Line_No')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI098 Detail - VAT ID	
	If idsdoDetail.GetItemString(llDetailFind,'vat_identifier') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'vat_identifier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI099 Detail - CI Value	
	If idsdoDetail.GetItemString(llDetailFind,'CI_Value') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'CI_Value')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI100 Detail - Currency
	If idsdoDetail.GetItemString(llDetailFind,'Currency') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Currency')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI101 Detail - Cust Line Nbr
	If idsdoDetail.GetItemString(llDetailFind,'Cust_Line_Nbr') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Cust_Line_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI102 Detail - Client Cust Invoice
	If idsdoDetail.GetItemString(llDetailFind,'Client_Cust_Invoice') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Client_Cust_Invoice')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI103 Detail - Cust PO
	If idsdoDetail.GetItemString(llDetailFind,'Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI104 Detail - Delivery Nbr
	If idsdoDetail.GetItemString(llDetailFind,'Delivery_Nbr') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Delivery_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI105 Detail - Internal Price
	If idsdoDetail.GetItemString(llDetailFind,'Internal_Price') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Internal_Price')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI106 Detail - Client Inv Type
	If idsdoDetail.GetItemString(llDetailFind,'Client_Inv_Type') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Client_Inv_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI107 Detail - Permit Nbr
	If idsdoDetail.GetItemString(llDetailFind,'Permit_Nbr') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Permit_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI108 Detail - Supp_Code
	If idsdoDetail.GetItemString(llDetailFind,'Supp_Code') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Supp_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI109 Detail - User Line item No
	If idsdoDetail.GetItemString(llDetailFind,'User_Line_Item_No') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'User_Line_Item_No')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI110 Master Order Type
	If idsDoMain.GetItemString(1,'Ord_Type') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Ord_Type')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI111 Detail - Cust SKU
	If idsdoDetail.GetItemString(llDetailFind,'Customer_SKU') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Customer_SKU')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI112 MasterCustomer Order Nbr 
	If idsDoMain.GetItemString(1,'Cust_Order_No') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Cust_Order_No')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar  
	End If	
	
	//GI113 Detail - Mark For Name
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Name') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Name')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI114 Detail - Mark For Address 1
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI115 Detail - Mark For Address 2
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_2') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI116 Detail - Mark For Address 3
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI117 Detail - Mark For Address 4
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_4') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Address_4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI118 Detail - Mark For City
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_City') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_City')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI119 Detail - Mark For State
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_State') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_State')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI120 Detail - Mark For Zip
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Zip') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Zip')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//GI121 Detail - Mark For Country - ** LAST COLUMN*/
	If idsdoDetail.GetItemString(llDetailFind,'Mark_For_Country') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'Mark_For_Country')) //+ lsDelimitChar
	Else
	//	lsOutString += lsDelimitChar
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
	
	For llRowPos = 1 to llRowCOunt
	
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
			
		ELSE
			lsOutString +=lsDelimitChar //17-Dec-2014 :Madhu- Added code to pass even if it is empty.
	
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
		 
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
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
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If		

		// 01/16 - PCONKL - New Named Fields
		
		//InterPack Count
		If idsDoPack.GetItemString(llRowPos,'Interpack_Count') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Interpack_Count'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//InterPack Type
		If idsDoPack.GetItemString(llRowPos,'Interpack_Type') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Interpack_Type'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Pack SSCC
		If idsDoPack.GetItemString(llRowPos,'Pack_SSCC_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_SSCC_No'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Pack Lot
		If idsDoPack.GetItemString(llRowPos,'Pack_Lot_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_Lot_No'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Pack PONO
		If idsDoPack.GetItemString(llRowPos,'Pack_PO_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_PO_No'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Pack PONO2
		If idsDoPack.GetItemString(llRowPos,'Pack_PO_No2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_PO_No2'))  + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Outerpack SSCC - ** Last Column **
		If idsDoPack.GetItemString(llRowPos,'Outerpack_SSCC_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Outerpack_SSCC_No'))  //+ lsDelimitChar
		Else
		//	lsOutString +=lsDelimitChar
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



Return 0
end function

public function integer uf_process_dboh (string asproject, string asinifile);
//Process Daily Inventory Report

string lsFilename ="INV"
string lsPath,lsFileNamePath,msg
int returnCode,liRC
long llRowCount, ldBatchSeq

Datastore	ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inventory Report'
FileWrite(gilogFileNo,msg)




// Create our filename and path

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Inventory_Snapshot','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	msg = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,msg)
	Return -1
End If



lsFilename += string(ldBatchSeq,'00000') + '.dat'
lsPath = ProfileString(asInifile,asproject,"flatfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)



ldsdir = Create Datastore
ldsdir.Dataobject = 'd_H2O_dboh'
lirc = ldsdir.SetTransobject(sqlca)



msg = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
FileWrite(gilogFileNo,msg)
gu_nvo_process_files.uf_write_log(msg) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject)

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


Destroy ldsdir

RETURN 0
end function

on u_nvo_edi_confirmations_h2o.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_h2o.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
//lsDelimitChar = char(9)
lsDElimitChar = "|"

end event

