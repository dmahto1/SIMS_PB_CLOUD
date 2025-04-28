HA$PBExportHeader$u_nvo_edi_confirmations_powerwave.sru
$PBExportComments$Process outbound edi confirmation transactions for Powerwave
forward
global type u_nvo_edi_confirmations_powerwave from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_powerwave from nonvisualobject
end type
global u_nvo_edi_confirmations_powerwave u_nvo_edi_confirmations_powerwave

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_rs (string asproject, string asdono, long aitransid)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Powerwave for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
	
String		ldsCartonWgtArray[], lsCartonWgt	

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM, ldWeightCarton
Integer		liRC
Boolean		lbFound

Long			llCartonCntPallet

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

//If Not isvalid(idsDoDetail) Then
//	idsDoDetail = Create Datastore
//	idsDoDetail.Dataobject = 'd_do_Detail'
//	idsDoDetail.SetTransObject(SQLCA)
//End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master, Detail and Pack records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

//idsDoDetail.Retrieve(asDoNo)
idsDoPack.Retrieve(asDoNo)
idsDoPack.SetSort("carton_no A")
idsDOPack.Sort()

//// 01/08 - Need to include SUZ warehouse
//6/12 - MEA - Added PCH
If upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-FG' or upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-USED' Then
	lsWarehouse = 'MER'
ElseIf upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-SUZ' Then
	lsWarehouse = 'MSZ'
ElseIf upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-SBLC' Then
	lsWarehouse = 'PCH'	
Else
	lsWarehouse = ''
End If

//We need the Carton Count from Packing - ??? Or is it just loose cartons from Packing ????
Select Count(Distinct carton_no) Into :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//Convert Carrier to Powerwave Carrier (SCAC)
lsCarrier = idsDoMain.GetItemString(1,'carrier')
		
Select scac_code, ship_ref into :lsSCAC, :lsShipRef
From Carrier_Master
Where project_id = "powerwave" and carrier_code = :lscarrier;

If isnull(lsSCAC) or lsSCAC = "" Then lsSCAC = lsCarrier
If isnull(lsShipRef) or lsShipRef = "" Then lsShipRef = lsCarrier

//We need to Build a Pallet Size Listing,, Net WEight, Gross Weight and CBM
ldNetWeight = 0
ldGrossWeight = 0
ldCBM = 0

llRowCount = idsDoPack.RowCount()

//Get Standard of Meausure
If llRowCount > 0 Then
	lsSOM = idsDoPack.GetITemString(1,'standard_of_measure')
Else
	lsSOM = 'M' /*Default to Metric */
End If

For llRowPos = 1 to llRowCount /*each Pack Row */
	
	lsCarton = idsDoPack.GetITemString(llRowPos,'carton_no')
	
	ldNetWeight += (idsDoPack.GetITemNumber(lLRowPos,'quantity') * idsDoPack.GetITemNumber(lLRowPos,'weight_net'))
	
	If lsCarton <> lscartonSave Then
		
		// Get the number of cartons for this pallet  05/11/11 - cawikholm
		Select Count(carton_no) Into :llCartonCntPallet
		From Delivery_Packing
		Where do_no = :asDoNo
		     and carton_no = :lsCarton;
			  
		// Get the total weight for this/these cartons  05/11/11 - cawikholm
		Select Sum(Weight_Gross) Into :ldWeightCarton
		  from Delivery_Packing
		Where do_no = :asDoNo
		     and carton_no = :lsCarton;
		
		/*Gross weight and DIMS  on each pack row are for the entire carton, not just the current row's portion*/
		ldGrossWeight += idsDoPack.GetITemNumber(lLRowPos,'weight_gross') 
		ldCBM += idsDoPack.GetITemNumber(lLRowPos,'cbm') 
		
		// ??? What do we do with loose cartons ???
		// 02/07 - PCONKL - Showing DIMS for all cartons, not just pallets
		//If Pos(Upper(idsDoPack.GetITemString(llRowPos,'carton_type')),'PALLET') = 0 Then Continue
		
		lsDim = String(idsDoPack.GetItemNUmber(lLRowPos,'Length')) + 'X' + String(idsDoPack.GetItemNUmber(lLRowPos,'width')) + 'X' + String(idsDoPack.GetItemNUmber(lLRowPos,'Height'))
		
		// 05/10/11 cawikholm - Added processing of carton and weight to pallet dimension
		lsCartonWgt = String(llCartonCntPallet) + '-' + String(ldWeightCarton,'########0.00')
		
		If UpperBound(lsDimsArray) > 0 Then

			//look for an existing entry
			lbFound = False
			For llArrayPos = 1 to UpperBound(lsDimsArray)
				
				If lsDimsArray[llArrayPos] = lsDim Then
					llQtyArray[llArrayPos] ++
					lbFound = True
					Exit
				End If
				
			Next
			
			If not lbFound Then
				llArrayCount ++
				lsDimsArray[llArrayCount] = lsDim
				ldsCartonWgtArray[llArrayCount] = lsCartonWgt
				llQtyArray[llARrayCount] = 1
			End If
			
		Else
			
			llArrayCount ++
			lsDimsArray[llArrayCount] = lsDim
			ldsCartonWgtArray[llArrayCount] = lsCartonWgt
			llQtyArray[llARrayCount] = 1
			
		End If
		
		//Only include in Pallet Count if 'Pallet'
		If Pos(Upper(idsDoPack.GetITemString(llRowPos,'carton_type')),'PALLET') > 0 Then
			llPalletCount ++
		End If
			
	End If /*new carton*/
	
	lscartonSave = lsCarton
	
Next /*Pack Row*/


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by '|'

// since we are not sending the Delivery DEtail ID, we are not looping thru detail rows, just header info
//llRowCount = idsDoDetail.RowCount()
//For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GI|' /*rec type = goods Issue*/
	
	// 01/08 - Need to include SUZ warehouse
	//lsOutString += 'MER|' /*default warehouse for now*/
	lsOutString += lsWarehouse + "|"
	
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Complete_date'),'yyyy-mm-dd') + '|'
	
	If Not isnull(lsSCAC) Then
		lsOutString += lsSCAC + '|'
	Else
		lsOutString +='|'
	End IF
	
// remooved 11/02/06 at Ravi's request
//	If idsDoDetail.GetITEmString(llRowPos,'User_Field8') > "" Then /*Delivery Detail ID - passed from DD from Powerwave*/
//		lsOutString += idsDoDetail.GetITEmString(llRowPos,'User_Field8') + "|"
//	Else
//		lsOutString += "|"
//	End If
	
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then
		lsOutString += idsDoMain.GetItemString(1,'awb_bol_no') + '|'
	Else
		lsOutString +='|'
	End IF
	
	If Not isnull(lsShipRef) Then
		lsOutString += lsShipRef + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += String(llPalletCount) + "|"
	lsOutString += String(llCartonCount) + "|"
	
	//Pallet Dimensions
	llArrayCount = Upperbound(lsDimsArray)
	If llArrayCount > 0 Then
		
		For llArrayPos = 1 to llArrayCount
			
			If lsDimsArray[llArrayPos] > "" and String(llQtyArray[llArrayPos]) > "" Then
				
				// 05/10/11 cawikholm - Added no. of cartons and total weight to dims 
				lsOutString += lsDimsArray[llArrayPos] + '-' + String(llQtyArray[llArrayPos]) + '-' + ldsCartonWgtArray[llArrayPos] 
			
				If llArrayPos < llArrayCount Then /*delimeter betwen dimensions*/
					lsOutString += ";"
				End If
				
			End If
			
		Next
				
	End If
	
	lsOutString += "|"

	lsOutString += String(ldGrossWeight,'########0.00') + "|"
	lsOutString += String(ldNetWeight,'########0.00') + "|"
	
	If lsSOM = 'M' Then /*Weight UOM*/
		lsOutString += "kg|"
	Else
		lsOutString += "lb|"
	End If
	
	If ldCBM > 0 Then
		lsOutString += String(ldCBM,'########0.00') + "|"
	Else
		lsOutString += "|"
	End If
	
	If lsSOM = 'M' Then /*DIMS UOM*/
		lsOutString += "cm|"
	Else
		lsOutString += "in|"
	End If
	
	If Not isnull(idsDoMain.GetItemNumber(1,'freight_cost')) Then
		lsOutString += String(idsDoMain.GetItemNumber(1,'freight_cost'),'########0.00') + '|'
	Else
		lsOutString +='0.00|'
	End IF
	
	lsOutString += "EUR" /*default freight currency to Euro*/
	
	idsOut.SetItem(llNewRow,'Project_id', 'Powerwave')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'gi' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

//next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'Powerwave')



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Powerwave for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsWarehouse

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

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not a PO or IR, get out
If idsROMain.GetItemString(1,'ord_Type') <> 'P' and idsROMain.GetItemString(1,'ord_Type') <> 'I' Then
	Return 0
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

idsroPutaway.Retrieve(asRONO)


// 01/08 - Need to include SUZ warehouse
// 6-12 - MEA - Added PCH
If upper(idsroMain.getItemString(1, 'wh_code')) = 'PWAVE-FG' or upper(idsroMain.getItemString(1, 'wh_code')) = 'PWAVE-USED' Then
	lsWarehouse = 'MER'
ElseIf upper(idsroMain.getItemString(1, 'wh_code')) = 'PWAVE-SUZ' Then
	lsWarehouse = 'MSZ'
ElseIf upper(idsroMain.getItemString(1, 'wh_code')) = 'PWAVE-SBLC' Then
	lsWarehouse = 'PCH'		
Else
	lsWarehouse = ''
End If

//For each sku/inventory type/Lot/COO in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//w_main.SetMicrohelp('Creating Goods Receipt confirmation for Solectron...')

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	lsFind += " and upper(country_of_Origin) = '" + upper(idsROPutaway.GetItemString(llRowPos,'country_of_Origin')) + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'lot_no',idsROPutaway.GetItemString(llRowPos,'lot_no'))
		idsGR.SetItem(llNewRow,'country_of_origin',idsROPutaway.GetItemString(llRowPos,'country_of_Origin'))
		
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'GR|' /*rec type = goods receipt*/
	lsOutString += idsROMain.GetItemString(1,'ord_Type') + '|' 
	lsOutString += Right(asRoNO,6) + '|' 
	
	// 01/08 - PCONKL - Need to include SUZ warehouse
//	lsOutString += 'MER|' /*warehouse defaulted to 'MER' for now*/
	lsOutString += lsWarehouse + "|"
	
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + '|'
	
	If idsROMain.GetItemString(1,'ship_ref') > "" Then
		lsOutString += idsROMain.GetItemString(1,'ship_ref') + '|' 
	Else
		lsOutString += "|"
	End If
	
	If idsROMain.GetItemString(1,'awb_bol_no') > "" Then
		lsOutString += idsROMain.GetItemString(1,'awb_bol_no') + '|' 
	Else
		lsOutString += "|"
	End If
	
	If idsROMain.GetItemString(1,'carrier') > "" Then
		lsOutString += idsROMain.GetItemString(1,'carrier') + '|' 
	Else
		lsOutString += "|"
	End If
	
	lsOutString += idsROMain.GetItemString(1,'last_User') + '|' 
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	
	If idsGR.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsGR.GetItemString(llRowPos,'lot_no')) + '|'
	Else
		lsOutString += "|"
	End If
	
	If idsGR.GetItemString(llRowPos,'country_of_Origin') = "XXX" Then
		lsOutString += ""
	Else
		
		//If 3 char COO, convert to 2 Char...
		If len(idsGR.GetItemString(llRowPos,'country_of_Origin')) = 3 then
			
			lsCOO3 = idsGR.GetItemString(llRowPos,'country_of_Origin')
			
			Select Designating_Code into :lsCOO2
			from Country
			Where iso_country_cd = :lsCOO3;
			
			If lsCOO2 > "" Then
				lsOutString += lsCOO2
			Else
				
			End If
			
		Else /* 2 Char code alredy entered*/
			
			lsOutString += idsGR.GetItemString(llRowPos,'country_of_Origin')
		End If
		
	End If
	
	idsOut.SetItem(llNewRow,'Project_id', 'POWERWAVE')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'gr' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


//If Serial NUmbers were captured, we need to add serial rows to same file
If idsROPutaway.Find("Serial_no <> '-'",1, idsROPutaway.RowCount()) > 0 Then
		
	llRowCOunt = idsROPutaway.RowCount()
	For llRowPos = 1 to llRowCount
	
		If idsRoPutaway.GetITemString(llRowPos,'serial_no') = '-' Then Continue
		
		llNewRow = idsOut.insertRow(0)
	
		lsOutString = 'IS|' /*rec type = goods receipt Serial Number*/
		lsOutString += Right(asRoNO,6) + '|'
		lsOutString +=	idsROPutaway.GetITemString(llRowPos,'serial_no') + '|'
		lsOutString +=	idsROPutaway.GetITemString(llRowPos,'sku')
		
		idsOut.SetItem(llNewRow,'Project_id', 'POWERWAVE')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'gr' + String(ldBatchSeq,'00000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	Next /*putaway Row*/
	
End If /*serial NUmbers exist*/

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'POWERWAVE')
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Selectron for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsRONO, lsOrder, lsPosNeg

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

//If lsNewInvType = 'D' or (llNewQTY <> llOldQTY)  Then
If (lsOldInvType = 'N' and lsNewInvType = 'D') or (lsOldInvType = 'D' and lsNewInvType = 'N') or (llNewQTY <> llOldQTY)  Then
	
	//If lsNewInvType = 'D' Then /* set to Damage*/
	if lsOldInvType <> lsNewInvType then /* Inventory Type adjustment - either Normal-to-Damaged or Damaged-to-Normal */
		lsTranType = 'BRK'
	Else /* Process as a qty adjustment*/
		lsTranType = 'QTY'
	End If
		
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
		
	lsOutString = 'MM' + '|' /*rec type = Material Movement*/
	lsOutString += lsTranType + '|' 
	lsOutString += left(lsOldInvType,1) + '|'  /*old Inv Type*/
	lsOutString += left(lsNewInvType,1) + '|' /*New Inv Type*/
	lsOutString += String(today(),'yyyymmddhhmmss') + '|'  
	lsOutString += Left(lsReason,4) + '|'   /*reason*/
	lsOutString += Left(lsSku,26) + '|' 
	lsOutString += String(llOldQty,'0000000000000')  + '|'  
	lsOutString += String(llNewQty,'0000000000000')  + '|'  
	lsOutString += String(alAdjustID,'0000000000000000') + '|' /*Internal Ref #*/
	lsOutString += String(alAdjustID,'00000000000000000000') + '|' /*External Ref #*/
	lsOutString += Space(20) /*Owner*/
					
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
   //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
End If /* inv type changed*/
		


Return 0
end function

public function integer uf_rs (string asproject, string asdono, long aitransid);//Prepare a Ready to Ship Transaction for Powerwave for the order that was just set to Ready to Ship


Long			llRowPos, llRowCount, llFindRow,	llDetailFindRow, llPickFindRow, llNewRow, llLineItemNo, llLineItemNoHold,	llBatchSeq, llCartonCount, &
				llSerialCount, llSerialPos, llPAckLine, llPackLineSave
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSKUHold, lsSupplier, lsSupplierHold,	lsInvType,	&
				lsInvoice, lsLogOut, lsFileName, lsPickFind, lsCarton, lsCartonHold, lsID, lsCarrier, lsSCAC, lsWarehouse

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtReadyDate
Datastore	ldsSerial

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
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

//Carton Serial Numbers
ldsSerial = Create Datastore
//ldsSerial.Dataobject = 'd_do_carton_serial'
ldsSerial.Dataobject = 'd_do_carton_serial_by_dono' /* 02/07 - PCONKL - Retrieving by entire dono instead of by carton/sku */
lirc = ldsSerial.SetTransobject(sqlca)

idsOut.Reset()
idsGR.Reset()

//Trans Create Date is Ready to Ship Date
select trans_create_date into :ldtReadyDate
From Batch_transaction
Where Trans_id = :aiTransID;

//Retreive Delivery Master, Detail, Picking Packing and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

idsDoDetail.Retrieve(asDoNo)
idsDoPick.Retrieve(asDoNo)
idsDoPack.Retrieve(asDoNo)

//// 01/08 - Need to include SUZ warehouse
// 6/12 - MEA - Added PCH
If upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-FG' or upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-USED' Then
	lsWarehouse = 'MER'
ElseIf upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-SUZ' Then
	lsWarehouse = 'MSZ'
ElseIf upper(idsDoMain.getItemString(1, 'wh_code')) = 'PWAVE-SBLC' Then
	lsWarehouse = 'PCH'		
Else
	lsWarehouse = ''
End If


//We need the Carton Count from Packing
Select Count(Distinct carton_no) Into :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//Convert Carrier to Powerwave Carrier (SCAC)
lsCarrier = idsDoMain.GetItemString(1,'carrier')
		
Select scac_code into :lsSCAC
From Carrier_Master
Where project_id = "powerwave" and carrier_code = :lscarrier;

If isnull(lsSCAC) or lsSCAC = "" Then lsSCAC = lsCarrier


//For each sku/line Item/inventory type/Lot/Serial Nbr  in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Loop Thru Packing for Line/Parent SKU/Supplier and Process all Parent/Child Items from Pick List for that Parent

// 11/06 - PCONKL - want to roll into a sinlg LPN (carton No) per Line Item even if Line is packed in multiple cartons. 
//                  This may be short term until Powerwave can accept multiple LN's per Line ITem.

idsDoPack.SetSort("Line_Item_No A, Carton_No A, SKU A, Supp_Code A")
idsDoPack.Sort()
llPAckLineSave = 0

llRowCOunt = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	llPAckLine = idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')
	
	If llPackLine = llPackLineSave Then Continue
		
	lsPickFind = "Line_Item_No = " + String(llPAckLine) 
	llPickFindRow = idsDOPick.Find(lsPickFind,1,idsDOPick.RowCount())
	
	Do While llPickFindRow > 0
		
		If idsDoPick.GetITemString(llPickFindRow,'Component_ind') <> 'Y' Then /*Don't include component Parents*/
		
			//Roll up to Line and sku only
			lsFind = " po_item_number = " + String(idsDOPick.GetItemNumber(llPickFindRow,'Line_Item_no')) 
			lsFind += " and upper(sku) = '" + upper(idsDOPick.GetItemString(llPickFindRow,'SKU')) + "'"
			//lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llPickFindRow,'inventory_type')) + "'"
			//lsFind += " and upper(lot_no) = '" + upper(idsDOPack.GetItemString(llRowPos,'carton_no')) + "'" /*from packing*/
	
			llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
			If llFindRow > 0 Then /*row already exists, add the qty*/
	
				idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llPickFindRow,'quantity')))
		
			Else /*not found, add a new record*/
		
				llNewRow = idsGR.InsertRow(0)
				idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llPickFindRow,'SKU'))
				idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llPickFindRow,'inventory_type'))
				idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llPickFindRow,'quantity'))
				idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llPickFindRow,'line_item_no'))
				
				idsGR.SetItem(llNewRow,'lot_no',idsDOPack.GetItemString(llRowPos,'carton_no')) /*Lot No = LPN = Packing Carton Number*/
				
				//For Non kitted parts, Delivery Detail ID is in Detail UF 1.
				// For kitted children, it is stored in UF 1 on the Delivery_BOM record since we don't have children on the Delivery Detail record
				
				llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Upper(SKU) = '" + Upper(idsDOPick.GetItemString(llPickFindRow,'SKU')) + "'",1,idsDoDetail.RowCount())
				If lLDetailFindRow > 0 Then
					
					If idsDoDetail.GetITemString(llDetailFindRow,'User_field8') > "" Then
						idsGR.SetItem(llNewRow,'user_field8',idsDoDetail.GetITemString(llDetailFindRow,'User_field8'))
					Else
						idsGR.SetItem(llNewRow,'user_field8','')
					end If
					
					//Line ITem should come from Oracle LIne (UF5) instead of Line Item NUmber
					If idsDoDetail.GetITemString(llDetailFindRow,'User_field5') > "" Then
						idsGR.SetItem(llNewRow,'user_field5',Trim(idsDoDetail.GetITemString(llDetailFindRow,'User_field5')))
					Else
						idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
					end If
					
				Else /* not found, must be a child record */
					
					lsSKU = idsDOPick.GetItemString(llPickFindRow,'SKU')
					llLineItemNo = idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')
					
					lsID = ""
					
					Select User_Field1 into :lsID
					From Delivery_BOM
					Where do_no = :asDONO and sku_Child = :lsSKU and line_item_No = :llLineItemNO;
					
					If lsID > "" Then
						idsGR.SetItem(llNewRow,'user_field8',lsID)
					Else
						idsGR.SetItem(llNewRow,'user_field8','')
					End If
					
					//Get THe line ITem from the Parent
					llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')),1,idsDoDetail.RowCount())
					If llDetailFindROw > 0 Then
						If idsDoDetail.GetITemString(llDetailFindRow,'User_field5') > "" Then
							idsGR.SetItem(llNewRow,'user_field5',Trim(idsDoDetail.GetITemString(llDetailFindRow,'User_field5')))
						Else
							idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
						end If
					Else
						idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
					End If
					
				End If /*detail found*/
				
			End If /*new or updated row*/
			
		End If /*Not a component parent*/
			
		If llPickFIndRow = idsDoPick.RowCount() Then
			llPickFindRow = 0
		Else
			llPickFindRow ++
			llPickFindRow = idsDOPick.Find(lsPickFind,llPickFindRow,idsDOPick.RowCount())
		End If
		
	Loop /* Next chiild/standalone Sku for Parent*/
	
	llPackLineSave = llPackLine
		
Next /* Next Pack record */


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'RS|' /*rec type = Ready to Ship*/
	
	// 01/08 - Need to include SUZ warehouse
	//lsOutString += 'MER|' /*default warehouse for now*/
	lsOutString += lsWarehouse + "|"
	
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'user_Field8') + '|'
	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += String(ldtReadyDate,'yyyy-mm-dd') + '|'
	lsOutString += String(llCartonCount) + '|'
		
	If Not isnull(lsSCAC) Then /*Carrier (SCAC)*/
		lsOutString += lsSCAC + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	//lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'user_field5') + '|' /*oracle LIne ITem*/
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += string(idsGR.GetItemString(llRowPos,'Lot_no'))

	idsOut.SetItem(llNewRow,'Project_id', 'Powerwave')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'rs' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

//Add any serial nummber records...

//02/07 - PCONKL - Retrieving Serials for entire order instead of looping by Pack/Pick Rows
llRowCount = ldsSerial.Retrieve(asdono)

For llRowPOs = 1 to llRowCount
	
	lsSKU = ldsSerial.GEtITEmString(llRowPos,'Sku')
	lsCarton = ldsSerial.getITemString(llRowPos,'carton_no')
	llLineItemNo = ldsSerial.GEtITEmNumber(llRowPos,'Line_Item_No')
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'OS|' /*rec type = Outbound Serial Rec*/
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + '|'

	//For Non kitted parts, Delivery Detail ID is in Detail UF 1.
	// For kitted children, it is stored in UF 1 on the Delivery_BOM record since we don't have children on the Delivery Detail record
			
	llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(llLineItemNo) + " and Upper(sku) = '" + upper(lsSKU) + "'",1,idsDoDetail.RowCount())
	If lLDetailFindRow > 0 Then
				
		If idsDoDetail.GetITemString(llDetailFindRow,'User_field8') > "" Then
			lsOutString += idsDoDetail.GetITemString(llDetailFindRow,'User_field8') + "|"
		Else
			lsOutString += "|"
		End If
				
	Else /* not found, must be a child record */
										
		lsID = ""
				
		Select User_Field1 into :lsID
		From Delivery_BOM
		Where do_no = :asDONO and sku_Child = :lsSKU and line_item_No = :llLineItemNO;
				
		If lsID > "" Then
			lsOutString += lsID + "|"
		Else
				lsOutString += "|"
		End If
		
	End If
			
	lsOutString += lsCarton + "|"
	lsOutString += lsSku + "|"
	lsOutString += ldsSerial.getITemString(llRowPos,'serial_no') + "|"
	
	idsOut.SetItem(llNewRow,'Project_id', 'Powerwave')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'rs' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*Serial Record */



//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'Powerwave')

Return 0
end function

on u_nvo_edi_confirmations_powerwave.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_powerwave.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

