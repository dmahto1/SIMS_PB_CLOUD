HA$PBExportHeader$u_nvo_edi_confirmations_babycare.sru
$PBExportComments$Process outbound edi confirmation transactions for babycare
forward
global type u_nvo_edi_confirmations_babycare from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_babycare from nonvisualobject
end type
global u_nvo_edi_confirmations_babycare u_nvo_edi_confirmations_babycare

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsEMCCaptureDelivery, idsEMCCaptureRecieve
				
Datastore idsAdjustment

string lsDelimitChar
end variables

forward prototypes
public function integer uf_pod (string asproject, string asdono)
public function integer uf_delivery_eo (string asproject, string asdono)
public function integer uf_receive_eo (string asproject, string asrono)
end prototypes

public function integer uf_pod (string asproject, string asdono);//Prepare aProof of Delivery Transaction for Babycare for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsReceiptStatus
DEcimal		ldBatchSeq, ldAllocQty, ldAcceptQty, ldDWAllocQty, ldDWAcceptQty
Integer		liRC
String     lsCurrentPODBatchSeqNum		

  
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


idsOut.Reset()

lsLogOut = "        Creating POD For DONO: " + asDONO
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

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Proof_Of_Delivery_File','Proof_Of_Delivery')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Proof of Delivery Transaction Confirmation.~r~rConfirmation will not be sent to Babycare!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	

//Sum The Alloc and Accpt Qty to determin the Order Status
llRowCount = idsDoDetail.RowCount()
ldAllocQty = 0
ldAcceptQty = 0

For llRowPos = 1 to llRowCOunt
		
	ldDWAllocQty = idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')
	
	IF IsNull(ldDWAllocQty) THEN ldDWAllocQty = 0
	
	ldDWAcceptQty = idsdoDetail.GetITemNumber(llRowPos,'accepted_qty')
	
	IF IsNull(ldDWAcceptQty) THEN ldDWAcceptQty = 0	
	
	ldAllocQty += ldDWAllocQty
	ldAcceptQty += ldDWAcceptQty
	
Next

If ldAllocQty = 0 Then
	lsREceiptStatus = 'CX' /*Order Cancelled*/
ElseIf ldAllocQty = ldAcceptQty Then
	lsREceiptStatus = 'FR' /*Fully accepted*/
Else
	lsREceiptStatus = 'PR' /*partially accepted*/
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
For llRowPos = 1 to llRowCOunt
		
	//Dont include any rows that shipped canceled
	//If idsdoDetail.GetITemNumber(llRowPos,'alloc_qty') = 0 Then Continue
	
	//MEA - 04/10 - Need to handle nulls
	
	ldDWAllocQty = idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')
	
	IF IsNull(ldDWAllocQty) THEN ldDWAllocQty = 0
	
	ldDWAcceptQty = idsdoDetail.GetITemNumber(llRowPos,'accepted_qty')
	
	IF IsNull(ldDWAcceptQty) THEN ldDWAcceptQty = 0	

	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'PO' + lsDelimitChar  /*rec type = goods Issue*/
	lsOutString += "01" + lsDelimitChar /*warehouse hardcoded*/
	lsOutString += asproject  + lsDelimitChar
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar
	lsOutString += String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'YYYY-MM-DD') + lsDelimitChar /*Delivery DATE*/
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'HH:MM:SS') + lsDelimitChar /*Delivery TIME*/
	lsOutString += lsReceiptStatus +lsDelimitChar
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'SKU') + lsDelimitChar
	lsOutString += String( ldDWAcceptQty) + lsDelimitChar
	
	//Line Status
	If ldDWAcceptQty  = ldDWAllocQty Then
		lsOutString += "AC" /*Fully receipted*/
	Elseif ldDWAcceptQty = 0 Then
		lsOutString += "RE" /*Fully rejected*/
	Else
		lsOutString += "PT" /*Partially receipted*/
	End If
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'PO' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_delivery_eo (string asproject, string asdono);
//EMC Capture Delivery EO

integer lirc
string lsLogOut
DEcimal	ldBatchSeq
Long llRowCount, llRowPos, llNewRow
string lsOutString, lsFileName

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsEMCCaptureDelivery) Then
	idsEMCCaptureDelivery = Create Datastore
	idsEMCCaptureDelivery.Dataobject = 'd_emc_delivery_master'
	idsEMCCaptureDelivery.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating EO For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive EMC Capture  records for this DONO
//Only created for order_type = 'E'

If idsEMCCaptureDelivery.Retrieve(asDoNo) <= 0  Then
	lsLogOut = "        *** NO EO File Created For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EMC_Capture','EMC_Capture')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor EMC Capture Transaction Confirmation.~r~rConfirmation will not be sent to Babycare!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
llRowCount = idsEMCCaptureDelivery.RowCount()

//Write the rows to the generic output table - delimited by lsDelimitChar
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'EO'  + lsDelimitChar /* rec type = EO */
	lsOutString +=  asproject  + lsDelimitChar /* project */
	lsOutString +=  idsEMCCaptureDelivery.GetItemString(llRowPos,'wh_code') + lsDelimitChar /* warehouse */
	lsOutString += 'S' + lsDelimitChar  /* Outbound Type - Hardcoded */
	lsOutString +=  idsEMCCaptureDelivery.GetItemString(llRowPos,'invoice_no') + lsDelimitChar /*Order Number */
	lsOutString +=  idsEMCCaptureDelivery.GetItemString(llRowPos,'sku') + lsDelimitChar /*SKU */
	lsOutString +=  idsEMCCaptureDelivery.GetItemString(llRowPos,'emc_code') + lsDelimitChar /*EMC Code*/
	lsOutString += '1' /*Quantity $$HEX3$$132020001820$$ENDHEX$$1$$HEX2$$19202000$$ENDHEX$$(always)*/

	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'EO' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next EMC Capture record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0


end function

public function integer uf_receive_eo (string asproject, string asrono);
//EMC Capture Receive EO

integer lirc
string lsLogOut
DEcimal	ldBatchSeq
Long llRowCount, llRowPos, llNewRow
string lsOutString, lsFileName

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsEMCCaptureRecieve) Then
	idsEMCCaptureRecieve = Create Datastore
	idsEMCCaptureRecieve.Dataobject = 'd_emc_receive_master'
	idsEMCCaptureRecieve.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating EO For RONO: " + asRoNo
FileWrite(gilogFileNo,lsLogOut)

//Retreive EMC Capture  records for this asRoNo
//Only created for order_type = 'I'

If idsEMCCaptureRecieve.Retrieve(asRoNo) <= 0 Then
	lsLogOut = "        *** NO EO File Created For RONO: " + asRoNo
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EMC_Capture','EMC_Capture')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor EMC Capture Transaction Confirmation.~r~rConfirmation will not be sent to Babycare!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
llRowCount = idsEMCCaptureRecieve.RowCount()

//Write the rows to the generic output table - delimited by lsDelimitChar
For llRowPos = 1 to llRowCount
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'EO' + lsDelimitChar /* rec type = EO */
	lsOutString += asproject + lsDelimitChar /* project */
	lsOutString +=  idsEMCCaptureRecieve.GetItemString(llRowPos,'wh_code') + lsDelimitChar /* warehouse */
	lsOutString += 'R' + lsDelimitChar  /* , Inbound Type - Hardcoded */
	lsOutString +=  idsEMCCaptureRecieve.GetItemString(llRowPos,'supp_invoice_no') + lsDelimitChar /*Order Number */
	lsOutString +=  idsEMCCaptureRecieve.GetItemString(llRowPos,'sku') + lsDelimitChar /*SKU */
	lsOutString +=  idsEMCCaptureRecieve.GetItemString(llRowPos,'emc_code') + lsDelimitChar /*EMC Code*/
	lsOutString += '1' /*Quantity $$HEX3$$132020001820$$ENDHEX$$1$$HEX2$$19202000$$ENDHEX$$(always)*/

	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'EO' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next EMC Capture record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0


end function

on u_nvo_edi_confirmations_babycare.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_babycare.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

