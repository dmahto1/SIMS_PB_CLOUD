HA$PBExportHeader$u_nvo_edi_confirmations_philips.sru
$PBExportComments$Process outbound edi confirmation transactions for Philips
forward
global type u_nvo_edi_confirmations_philips from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_philips from nonvisualobject
end type
global u_nvo_edi_confirmations_philips u_nvo_edi_confirmations_philips

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function string getphilipsinvtype (string asinvtype)
public function integer uf_rt (string asproject, string asrono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Philips for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
				

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
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0

idsDoDetail.Retrieve(asDoNo)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by '|'

llRowCount = idsDoDetail.RowCount()
For llRowPos = 1 to llRowCOunt
	
	If idsdoDetail.GetITemNumber(llRowPos,'alloc_qty') = 0 Then Continue /* don't include non shipped rows */
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GI|' /*rec type = goods Issue*/
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'
	
	//Line ITem was loaded into UF2, if still present, take it from here
	If isNumber(idsDoDetail.GetITEmString(llRowPos,'User_field2') ) Then
		lsOutString += idsDoDetail.GetITEmString(llRowPos,'User_field2') + "|"
	Else
		lsOutString += String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No')) + "|"
	End If
	
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Complete_date'),'yyyymmddhhmm') + '|'
	lsOutString += String( idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')) + "|"
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'SKU') + "|"
	
	If Not isnull( idsDoDetail.GetITEmString(llRowPos,'UOM')) Then
		lsOutString += idsDoDetail.GetITEmString(llRowPos,'UOM') + "|"
	Else
		lsOutString += "|"
	End if
	
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'Supp_Code	')  + "|" /*Plant Code*/
	
	lsOutString += "|"  /*Multiplier*/

	lsOutString += idsDoDetail.GetITEmString(llRowPos,'Supp_Code	') /*Plant Code*/			
		
	idsOut.SetItem(llNewRow,'Project_id', 'Philips-SG')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'Philips-SG')



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Philips for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsWarehouse, lsLineItem

DEcimal		ldBatchSeq
Integer		liRC

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


// 03/07 - PCONKL - If not received elctronically, or Order type = "I" (Import No GR) don't send a confirmation
If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no')) or idsRoMain.GetITemString(1,'Ord_Type') = 'I' Then Return 0

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)


//For each sku/inventory type/PO_NO, PO_no2 (po number, po line)
llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	//Some fields coming from Detail...
	lsFind = "Line_Item_No = " + String(idsROPutaway.GetItemNumber(llRowPos,'line_item_No')) + " and Upper(SKU) = '" + Upper(idsROPutaway.GetItemString(llRowPos,'sku')) + "'"
	llDetailFindRow = idsRoDetail.Find(lsFind,1,idsRoDetail.RowCount())
	
	//If UF1 is numeric, use that as the SAP LIne Item NUmber, otherwise take from Putaway - We are loading it to UF 1 on the Inbound
	If lLDetailFindRow > 0 Then
		If isNumber(idsRoDetail.GetITEmSTring(lLDetailFindRow,'User_Field1')) Then
			lsLineItem = idsRoDetail.GetITEmSTring(lLDetailFindRow,'User_Field1')
		Else
			lsLineItem = String(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		End If
	Else
		lsLineItem = String(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	End If
	
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and user_line_item_no = '" + lsLineItem + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(po_no2) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no2')) + "'"
		
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'supp_code',idsROPutaway.GetItemString(llRowPos,'supp_code'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'user_line_item_no',lsLineItem)
		idsGR.SetItem(llNewRow,'po_no',idsROPutaway.GetItemString(llRowPos,'po_no'))
		idsGR.SetItem(llNewRow,'po_no2',idsROPutaway.GetItemString(llRowPos,'po_no2'))
		
		If llDetailFindRow > 0 Then
			idsGR.SetItem(llNewRow,'uom',idsRODetail.GetItemString(llDetailFindRow,'uom'))
		End If
				
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'GR|' /*rec type = goods receipt*/
	
	lsOutString += idsRoMain.GetITemString(1,'wh_code') + "|"
	lsOutString += getPhilipsInvType(idsGR.GetItemString(llRowPos,'inventory_type')) + '|' /* convert SIMS inv type to Philips*/
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmm') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_no') + '|'/* PO Number */
	lsOutString += idsGR.GetItemString(llRowPos,'po_no2') + '|'/* PO Line */
	lsOutString += String(idsGR.GetItemString(llRowPos,'supp_code')) + '|'
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|' /*Shipping Notification Number*/
	
	If Not isnull(idsGR.GetItemString(llRowPos,'user_line_item_no')) Then
		lsOutString += idsGR.GetItemString(llRowPos,'user_line_item_no') + '|' /*Shipping Notification Line */
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(idsGR.GetItemString(llRowPos,'uom')) Then
		lsOutString +=  idsGR.GetItemString(llRowPos,'uom')  + '|'
	Else
		lsOutString += "|"
	End If
	
	If Not isnull(idsRoMain.GetITemString(1,'User_Field9')) Then /*Vendor Invoice Number*/
		lsOutString += idsRoMain.GetITemString(1,'User_Field9')
	Else
	//	lsOutString +="|"
	End If
		
	idsOut.SetItem(llNewRow,'Project_id', 'PHILIPS-SG')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHILIPS-SG')
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Selectron for the Stock Adjustment just made

Long			llNewRow, llNewQty, lloldQty, llRowCount,	llAdjustID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier,  lsUOM

Decimal		ldBatchSeq
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


lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')

//We need the Level one UOM from Item Master
Select uom_1 into :lsUOM
From Item_MAster
Where project_id = :asProject and sku = :lsSKU and supp_code = :lsSupplier;

If isNull(lsUOM) Then lsUOM = ""

lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''
	
lsOldInvType = ldsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = ldsAdjustment.GetITemString(1,"inventory_type")

llAdjustID = ldsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = ldsAdjustment.GetITemNumber(1,"quantity")
lloldQty = ldsAdjustment.GetITemNumber(1,"old_quantity")
		
//We are only Sending a record for an Inventory Type Change
If lsOldInvType = lsNewInvType Then Return 0


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
		
lsOutString = 'MM' + '|' /*rec type = Material Movement*/
lsOutString +=  '311|' 
lsOutString +=getPhilipsInvType(lsOldInvType) + '|'  /*old Inv Type - Convert to Philips Code*/
lsOutString += getPhilipsInvType(lsNewInvType)  + '|' /*New Inv Type - Convert to Philips Code*/
lsOutString += String(today(),'yyyymmddhhmm') + '|'  
lsOutString += Left(lsReason,4) + '|'   /*reason*/
lsOutString += lsSku + '|' 
lsOutString += String(lloldQty)  + '|'  
lsOutString += String(llNewQty)  + '|'  
lsOutString += String(alAdjustID,'0000000000000000') + '|' /*Internal Ref #*/
lsOutString += String(alAdjustID,'00000000000000000000') + '|' /*External Ref #*/
lsOutString += lsSupplier + '|' 
lsOutString += lsUOM

llNewRow = idsOut.insertRow(0)
	
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)

lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
  //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	

		


Return 0
end function

public function string getphilipsinvtype (string asinvtype);//Convert the Menlo Inventory Type into the Phillips code

String    lsPhilipsInvType
Choose case upper(asInvType)
                                
	 Case 'B'
		lsPhilipsInvType = 'B'
	 Case 'C'
		lsPhilipsInvType = 'C'
	 Case 'D'
		lsPhilipsInvType = 'DAM'
	 Case 'K'
		lsPhilipsInvType = 'BLCK'
	 Case 'L'
		lsPhilipsInvType = 'REBL'
	 Case 'N'
		lsPhilipsInvType = 'WHS'
	 Case 'R'
		lsPhilipsInvType = 'REW'
	 Case 'S'
		lsPhilipsInvType = 'SCRP'
	 Case 'G'
		lsPhilipsInvType = 'BWHS'
	 Case 'J'
		lsPhilipsInvType = 'BOPN'
	 Case 'F'
		lsPhilipsInvType = 'BBLK'
	 Case 'E'
		lsPhilipsInvType = 'BDAM'
	 Case Else
		lsPhilipsInvType = asInvType
End Choose

Return lsPhilipsInvType
end function

public function integer uf_rt (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Philips for the RETURN order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsWarehouse, lsLineItem

DEcimal		ldBatchSeq
Integer		liRC

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

lsLogOut = "      Creating RT For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no'))   Then Return 0

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)


//For each sku
llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	//Some fields coming from Detail...
	lsFind = "Line_Item_No = " + String(idsROPutaway.GetItemNumber(llRowPos,'line_item_No')) + " and Upper(SKU) = '" + Upper(idsROPutaway.GetItemString(llRowPos,'sku')) + "'"
	llDetailFindRow = idsRoDetail.Find(lsFind,1,idsRoDetail.RowCount())
	
	//If UF1 is numeric, use that as the SAP LIne Item NUmber, otherwise take from Putaway - We are loading it to UF 1 on the Inbound
	If lLDetailFindRow > 0 Then
		If isNumber(idsRoDetail.GetITEmSTring(lLDetailFindRow,'User_Field1')) Then
			lsLineItem = idsRoDetail.GetITEmSTring(lLDetailFindRow,'User_Field1')
		Else
			lsLineItem = String(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		End If
	Else
		lsLineItem = String(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	End If
	
	lsFind = "user_line_item_no = '" + lsLineItem  + "' and upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and Upper(supp_Code) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Supp_code'))  + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'supp_code',idsROPutaway.GetItemString(llRowPos,'supp_code'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'user_line_item_no',lsLineItem)
		
		If llDetailFindRow > 0 Then
			idsGR.SetItem(llNewRow,'uom',idsRODetail.GetItemString(llDetailFindRow,'uom'))
		End If
						
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Philips!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'RT|' /*rec type = Return Confirmation*/
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|' /*Shipping Notification Number*/
	lsOutString += idsGR.GetItemString(llRowPos,'user_line_item_no') + '|' /*Shipping Notification Line */
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmm') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'

	If Not isnull(idsGR.GetItemString(llRowPos,'uom')) Then
		lsOutString +=  idsGR.GetItemString(llRowPos,'uom')  + '|'
	Else
		lsOutString += "|"
	End If
	
	//MA - 03/11
	
	lsOutString += String(idsGR.GetItemString(llRowPos,'supp_code')) + "|"

	lsOutString += "|"  /*Multiplier*/

	lsOutString += String(idsGR.GetItemString(llRowPos,'supp_code')) /*Plant Code*/	
		
	idsOut.SetItem(llNewRow,'Project_id', 'PHILIPS-SG')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'RT' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHILIPS-SG')
End If

Return 0
end function

on u_nvo_edi_confirmations_philips.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_philips.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

