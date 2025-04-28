HA$PBExportHeader$u_nvo_edi_confirmations_warner.sru
$PBExportComments$Process outbound edi confirmation transactions for Warner
forward
global type u_nvo_edi_confirmations_warner from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_warner from nonvisualobject
end type
global u_nvo_edi_confirmations_warner u_nvo_edi_confirmations_warner

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
				
Datastore idsAdjustment
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_rt (string asproject, string asrono)
public function string getwarnerinvtype (string asinvtype)
public function integer uf_pod (string asproject, string asdono)
public function integer uf_adjustment (string asproject, long aladjustid, long altransid)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String     lsCurrentGIBatchSeqNum				

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

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

/* If there is a current batch seq number */
lsCurrentGIBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentGIBatchSeqNum","")

IF trim(lsCurrentGIBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentGIBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentGIBatchSeqNum)
END IF



//Write the rows to the generic output table - delimited by '|'

llRowCount = idsDoDetail.RowCount()
For llRowPos = 1 to llRowCOunt
		
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GI|' /*rec type = goods Issue*/
	lsOutString += "01|" /*warehoue hardcoded*/
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Complete_date'),'yyyymmdd') + '|' /*Ship DATE*/
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Complete_date'),'hhmm') + '|' /*Ship TIME*/
	
	//Shipment Status - If anything shipped - "FD", if Nothing - "CX"
	If idsDoDetail.Find("alloc_Qty > 0",1,idsDoDetail.RowCount()) > 0 Then
		lsOutString += "FD|"
	Else
		lsOutString += "CX|"
	End If
		
	lsOutString += "|" /*Shipment Reason*/
	lsOutString += String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No')) + "|" 
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'SKU') + "|"
	lsOutString += String( idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')) + "|"
	
	//Line Status - Latst column, ** no delimiter **
	If 	idsdoDetail.GetITemNumber(llRowPos,'alloc_qty') = idsdoDetail.GetITemNumber(llRowPos,'req_qty') Then /* Fully shipped */
		lsOutString += "AC"
	Else /*partially or 0 shipped */
		lsOutString += "OS"
	End If
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsWarehouse, lsLineItem

DEcimal		ldBatchSeq
Integer		liRC

String 		lsCurrentGRBatchSeqNum

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsroDetail) Then
	idsroDetail = Create Datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
	idsroDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//  Do not send for Customer Rejects or initial Inventory Loads
//If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no')) or idsRoMain.GetITemString(1,'Ord_Type') = 'I' Then Return 0
If idsRoMain.GetITemString(1,'Ord_Type') = 'I' or  idsRoMain.GetITemString(1,'Ord_Type') = 'R'  Then Return 0

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)


//For each sku/inventory type
llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "'" 
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
			
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
						
	End If
	
Next /* Next Putaway record */

//We also need to include rows that were 0 received (cancelled) from Receive Detail (no putaway generated)
llRowCOunt = idsRODetail.RowCount()
For llRowPos = 1 to llRowCount
	
	If idsRoDetail.GetITemNumber(llRowPos,'alloc_qty') > 0 Then Continue
	
	lsFind = "upper(sku) = '" + upper(idsRoDetail.GetItemString(llRowPos,'SKU')) + "'" 
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists - Nothing to add (0 qty)*/
			
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'Inventory_type',"")
		idsGR.SetItem(llNewRow,'sku',idsRoDetail.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',0)
						
	End If
	
Next


/* If there is a current batch seq number */
lsCurrentGRBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentGRBatchSeqNum","")

IF trim(lsCurrentGRBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Receipt_File','Good_Receipt')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentGRBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentGRBatchSeqNum)
END IF


//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GR|' /*rec type = goods receipt*/
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|' 
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + '|'
	lsOutString += "01|" /*hardcoded warehouse*/
	lsOutString += getwarnerInvType(idsGR.GetItemString(llRowPos,'inventory_type')) + '|' /* convert SIMS inv type to Warner*/
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity'))
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'GR' + String(ldBatchSeq,'000000') + '.dat'
	
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
End If

Return 0
end function

public function integer uf_rt (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Warner for the RETURN order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName

DEcimal		ldBatchSeq
Integer		liRC
String     lsCurrentRTBatchSeqNum	

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsrodetail) Then
	idsrodetail = Create Datastore
	idsrodetail.Dataobject = 'd_ro_Detail'
	idsrodetail.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating RT For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
//If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no'))   Then Return 0

idsroDetail.Retrieve(asRONO)

//For each Line/sku
llRowCOunt = idsroDetail.RowCount()

For llRowPos = 1 to llRowCount
	
	llLineItemNo = idsroDetail.GetItemNumber(llRowPos,'line_item_no')
	
	lsFind = "po_item_number = '" + String(llLineItemNo)  + "' and upper(sku) = '" + upper(idsroDetail.GetItemString(llRowPos,'SKU')) +  "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsroDetail.GetItemNumber(llRowPos,'alloc_qty')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'sku',idsroDetail.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsroDetail.GetItemNumber(llRowPos,'alloc_qty'))
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
								
	End If
	
Next /* Next Putaway record */

/* If there is a current batch seq number */
lsCurrentRTBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentRTBatchSeqNum","")

IF trim(lsCurrentRTBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Return_Confirm_File','Return_Confirm')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Return Confirmation Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentRTBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentRTBatchSeqNum)
END IF

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'RT|' /*rec type = Return Confirmation*/
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|' /*RMA Number*/
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + '|'
	lsOutString +="01|"/* warehouse hardcoded */
	
	If Not isnull(idsROMain.GetItemString(1,'User_field10') ) Then
		lsOutString += idsROMain.GetItemString(1,'User_field10') + '|' /*RMA Customer Code*/
	Else
		lsOutString += "|"
	End If
				
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|' /*RMA Line */
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) 
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'RT' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
End If

Return 0
end function

public function string getwarnerinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Warner code

String	lsWarnerInvTpe
Choose case upper(asInvType)
		
	Case 'N'
		lsWarnerInvTpe = 'A' /*saleable*/
	Case 'R'
		lsWarnerInvTpe = 'D' /*Rework*/
	Case Else
		lsWarnerInvTpe = asInvType
End Choose

Return lsWarnerInvTpe
end function

public function integer uf_pod (string asproject, string asdono);//Prepare aProof of Delivery Transaction for Warner for the order that was just confirmed


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


/* If there is a current batch seq number */
lsCurrentPODBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentPODBatchSeqNum","")

IF trim(lsCurrentPODBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Proof_Of_Delivery_File','Proof_Of_Delivery')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Proof of Delivery Transaction Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentPODBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentPODBatchSeqNum)
END IF

//Sum The Alloc and Accpt Qty to determin the Order Status
llRowCount = idsDoDetail.RowCount()
ldAllocQty = 0
ldAcceptQty = 0

For llRowPos = 1 to llRowCOunt

	//MEA - 04/10 - Need to handle nulls
	
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

//Write the rows to the generic output table - delimited by '|'
For llRowPos = 1 to llRowCOunt
		
	//Dont include any rows that shipped canceled
	//If idsdoDetail.GetITemNumber(llRowPos,'alloc_qty') = 0 Then Continue
	
	//MEA - 04/10 - Need to handle nulls
	
	ldDWAllocQty = idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')
	
	IF IsNull(ldDWAllocQty) THEN ldDWAllocQty = 0
	
	ldDWAcceptQty = idsdoDetail.GetITemNumber(llRowPos,'accepted_qty')
	
	IF IsNull(ldDWAcceptQty) THEN ldDWAcceptQty = 0	

	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'PD|' /*rec type = goods Issue*/
	lsOutString += "01|" /*warehouse hardcoded*/
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'yyyymmdd') + '|' /*Delivery DATE*/
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'hhmm') + '|' /*Delivery TIME*/
	lsOutString += lsReceiptStatus + "|"
	lsOutString += String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No')) + "|" 
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'SKU') + "|"
	
	lsOutString += String( ldDWAcceptQty) + "|"
	
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
	lsFileName = 'PD' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long altransid);//Prepare a Stock Adjustment Transaction for Warner for the Stock Adjustment just made

Long			llNewRow, llNewQty, lloldQty, llRowCount,	llAdjustID, llNetQty
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,	lsTranType, lsTransParm

Decimal		ldBatchSeq
Integer		liRC
String	lsLogOut

String lsCurrentAdjustBatchSeqNum


lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsAdjustment.Reset()

// For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment
Select  Trans_parm into  :lsTransParm
From Batch_Transaction
Where Trans_ID = :alTransID;

If lsTransParm = 'SKIP' Then
	 Return 0
End If

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsSku = idsAdjustment.GetITemString(1,'sku')
lsOldInvType = idsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")

llAdjustID = idsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")
		
//We are only Sending a record for an Inventory Type or Qty Changes
If lsOldInvType = lsNewInvType and llNewQty = llOldQty Then Return 0

/* If there is a current batch seq number */
lsCurrentAdjustBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentAdjustBatchSeqNum","")

IF trim(lsCurrentAdjustBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Adjustment_File','Adjustment')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number~rfor Adjustment Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentAdjustBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentAdjustBatchSeqNum)
END IF

		
lsOutString = 'MM' + '|' /*rec type = Material Movement*/
lsOutString += String(today(),'yyyymmdd') + '|'  
lsOutString += "01|" /*hardcoded warehouse*/

//From/To Inv Types - 
If idsAdjustment.GetITemString(1,"adjustment_type") = 'Q' Then
	
	If llNewQty > llOldQty Then
		lsOutString += "|" /* positive changes have blank in From Inv Type*/
		lsOutString +=getWarnerInvType(lsNewInvType) +  "|" 
		llNetQty = llNewQty - llOldQty
	ElseIf llOldQty > llNewQty Then
		lsOutString += getWarnerInvType(lsOldInvtype) + "|" /*negative changes show Type in Old Inv Type field*/
		lsOutString += "|"
		llNetQty = llOldQty - llNewQty
	End If
	
Else /*Inv Type Change*/
	
	/* if recombining a bucket, the adjustment will have the same value for old/new Inv Type but the balancing adjustment Inv Type is tored in the Trans_Parm*/
	If Pos(lsTransParm,'OLD_INVENTORY_TYPE') > 0 Then
		lsOldInvType = Mid(lsTransParm,(Pos(lsTransParm,'=') + 1),999)
		llnetQty = Abs(llNewQty - llOldQty)
	Else
		llnetQty = llNewQty
	End If
	
	lsOutString += getWarnerInvType(lsOldInvtype)  + "|"
	lsOutString +=getWarnerInvType(lsNewInvType) +  "|" 

End If

lsOutString += lsSku + '|' 
lsOutString += String(llNetQty)  

llNewRow = idsOut.insertRow(0)
	
	
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)

lsFileName = 'MM' + String(ldBatchSeq,'000000') + '.DAT'

idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
 //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
Return 0
end function

on u_nvo_edi_confirmations_warner.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_warner.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

