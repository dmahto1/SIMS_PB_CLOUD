$PBExportHeader$u_nvo_edi_confirmations_coty.sru
$PBExportComments$Process outbound edi confirmation transactions for Powerwave
forward
global type u_nvo_edi_confirmations_coty from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_coty from nonvisualobject
end type
global u_nvo_edi_confirmations_coty u_nvo_edi_confirmations_coty

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsDoBOM,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_rs (string asproject, string asdono, long aitransid)
public function datetime getgmttime (string aswh, datetime adtdatetime)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed
//Cloned from Riverbed with changes
//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[], lltemp, llBOMCount
				
String		lsOutString,	lsOutString2, lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsskuparent, lsSuppCode, lsLineItemNo, lsInvoiceNo, lsProductAttribute, lsProductSize, lsStyleNumber, lsGTIN, lsQty, lsPDF_URL

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound
DateTime	ldtTemp
String			lsDelimitChar, lsFind, lsTrackingNo
Long llDetailFind, llPackFind, llBOMFind, llDetailAsParentFind

lsDelimitChar = ","

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

If Not isvalid(idsDoBOM) Then
	idsDoBOM = Create Datastore
	idsDoBOM.Dataobject = 'd_do_bom'
	idsDoBOM.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "        Creating ASN OD CSB for order: " + asDONO
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

idsDoBOM.Retrieve(asDoNo)
//idsDoBOM.SetSort("user_field2")
//idsDoBOM.Sort()

lsInvoiceNo = idsDOMain.GetItemString( 1, 'invoice_no' )
lsPDF_URL = ''
lsTrackingNo = idsDOMain.GetItemString( 1, 'awb_bol_no' )
If isnull(lsTrackingNo) Then lsTrackingNo = ''

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar
llBOMCount = idsDoBOM.RowCount()

llRowCount = idsDoPick.RowCount()

//Write the first row from row one of the pick list - Parent SKU OD line
llNewRow = idsOut.insertRow(0)
lsOutString = 'OD' + lsDelimitChar
lsOutString += lsInvoiceNo+ lsDelimitChar
lsOutString += idsDOPick.GetItemString( 1, 'sku' ) + lsDelimitChar
lsOutString += '' + lsDelimitChar		//Product Attribute (always empty)
lsOutString += '' + lsDelimitChar		//Product Size (always empty)
lsOutString += '' + lsDelimitChar		//Style Number 
lsOutString += '' + lsDelimitChar		//GTIN/UPC
lsOutString += String( idsDOPick.GetItemNumber( 1, 'quantity' ) ) + lsDelimitChar
lsOutString += lsTrackingNo + lsDelimitChar			//Awb_Bol_No
lsOutString += lsPDF_URL				//PDF URL

idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)
lsFileName = 'GI' + '_' + idsDoMain.GetItemString(1,'wh_code') + '_' + String(ldBatchSeq,'000000') + '.csv'
idsOut.SetItem(llNewRow,'file_name', lsFileName)

//Loop through delivery_BOM for all rows
For llRowPos = 1 to llBOMCount

	lsSku = idsDoBOM.GetITEmString(llRowPos,'sku_child')
	lsProductAttribute = idsDoBOM.GetITEmString(llRowPos,'user_field1')
	lsProductSize = idsDoBOM.GetITEmString(llRowPos,'user_field2')
	lsStyleNumber = idsDoBOM.GetITEmString(llRowPos,'user_field3' )
	lsGTIN = idsDoBOM.GetITEmString(llRowPos,'user_field4')
	lsQty = String( idsDoBOM.GetItemNumber( llRowPos, 'child_qty' ) )

	llNewRow = idsOut.insertRow(0)
	lsOutString = 'OD' + lsDelimitChar
	lsOutString +=  lsInvoiceNo + lsDelimitChar
	lsOutString +=  lsSku + lsDelimitChar
	lsOutString +=  lsProductAttribute + lsDelimitChar
	lsOutString +=  lsProductSize + lsDelimitChar
	lsOutString +=  lsStyleNumber + lsDelimitChar
	lsOutString +=  lsGTIN + lsDelimitChar
	lsOutString +=  lsQty 

	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)
//	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	lsFileName = 'GI' + '_' + idsDoMain.GetItemString(1,'wh_code') + '_' + String(ldBatchSeq,'000000') + '.csv'

	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Coty for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3, lsOrdType

Decimal		ldBatchSeq
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

//If not a PO or IT, get out
// dts - 01/31/08 - now sending 944 for Back Orders too.
lsOrdType = idsROMain.GetItemString(1,'ord_Type')
If lsOrdType <> 'S' and lsOrdType <> 'I' and lsOrdType <> 'B' Then
	lsLogOut = "      - GR files not created for Order Type " + lsOrdType
	FileWrite(gilogFileNo,lsLogOut)	
	Return 0
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
// Commented out 07/31/07 If idsROMain.GetItemNumber(1, 'edi_batch_seq_no') = 0 or isNull(idsROMain.GetItemNumber(1, 'edi_batch_seq_no')) Then Return 0

idsroPutaway.Retrieve(asRONO)

///////For each sku/inventory type/Lot/COO in Putaway, write an output record - 
//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//w_main.SetMicrohelp('Creating Goods Receipt confirmation for Coty...')

llRowCount = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
//	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
//	lsFind += " and upper(country_of_Origin) = '" + upper(idsROPutaway.GetItemString(llRowPos,'country_of_Origin')) + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow, 'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow, 'Inventory_type', idsROPutaway.GetItemString(llRowPos, 'inventory_type'))
		idsGR.SetItem(llNewRow, 'sku', idsROPutaway.GetItemString(llRowPos, 'sku'))
		idsGR.SetItem(llNewRow, 'quantity', idsROPutaway.GetItemNumber(llRowPos, 'quantity'))
		idsGR.SetItem(llNewRow, 'po_item_number',idsROPutaway.GetItemNumber(llRowPos, 'line_item_no'))
		//idsGR.SetItem(llNewRow, 'lot_no',idsROPutaway.GetItemString(llRowPos, 'lot_no'))
		//idsGR.SetItem(llNewRow, 'country_of_origin',idsROPutaway.GetItemString(llRowPos, 'country_of_Origin'))
		
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject, 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
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
//moved below	lsOutString += idsROMain.GetItemString(1,'ord_Type') + '|' 
//	lsOutString += Right(asRoNO,6) + '|' 
	lsOutString += 'COTY-WARSA|' /*warehouse defaulted to 'COTY-WARSA' for now*/ //TEMPO!!!
	lsOutString += idsGR.GetItemString(llRowPos, 'inventory_type') + '|'
	lsOutString += String(idsROMain.GetItemDateTime(1, 'complete_date'), 'yyyymmdd') + '|'
	
	lsOutString += idsGR.GetItemString(llRowPos, 'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos, 'quantity')) + '|'
	lsOutString += idsROMain.GetItemString(1, 'supp_invoice_no') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos, 'po_item_number')) + '|'
	//lsOutString += idsROMain.GetItemString(1,'ord_Type') + '|' 
	lsOrdType = idsROMain.GetItemString(1,'ord_Type')
	if lsOrdType = 'I' then
		lsOrdType = 'IT'
	elseif lsOrdType = 'S' then
		lsOrdType = 'PO'
	end if
	lsOutString += lsOrdType
	
		
	idsOut.SetItem(llNewRow, 'Project_id', 'COTY')
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString)
	//lsFileName = 'GR' + String(ldBatchSeq, '00000000') + '.dat'
	lsFileName = 'N944' + String(ldBatchSeq,'00000') + '.CSV'
	idsOut.SetItem(llNewRow, 'file_name', lsFileName)
	
	
next /*next output record */

//TEMPO - do we need this....
//Add a trailer Record
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//idsOut.SetItem(llNewRow,'file_name', 'N944' + String(ldBatchSeq,'00000') + '.DAT') 
idsOut.SetItem(llNewRow, 'file_name', lsFileName)

/*
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
	
End If /*serial Numbers exist*/
*/

//Write the Outbound File
If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, 'COTY')
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for the Stock Adjustment just made

Return 0
end function

public function integer uf_rs (string asproject, string asdono, long aitransid);//Prepare a Ready to Ship Transaction for Powerwave for the order that was just set to Ready to Ship
/*

Long			llRowPos, llRowCount, llFindRow,	llDetailFindRow, llPickFindRow, llNewRow, llLineItemNo, llLineItemNoHold,	llBatchSeq, llCartonCount, &
				llSerialCount, llSerialPos, llPAckLine, llPackLineSave
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSKUHold, lsSupplier, lsSupplierHold,	lsInvType,	&
				lsInvoice, lsLogOut, lsFileName, lsPickFind, lsCarton, lsCartonHold, lsID, lsCarrier, lsSCAC

Decimal		ldBatchSeq
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
	lsOutString += 'ERS|' /*default for now */
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
*/
Return 0
end function

public function datetime getgmttime (string aswh, datetime adtdatetime);string lsOffset, lsOffsetFremont
long   llGMTOffset, llTimeSecs
date ldDate
time ltTime, ltTimeNew

	select gmt_offset into :lsOffset
	from warehouse
	where wh_code = :asWH;

// see if subtracting the offset would make it the previous day. If so, subtract a day and the remainder of the Offset.
// - if the offset is negative (West of Fremont), see if adding the offset would make it the next day. If so, add a day and the remainder of Offset
llGMTOffset = long(lsOffset)
llGMTOffset = llGMTOffset * 60 * 60  //convert the offset to seconds
ldDate = date(adtDateTime)
ltTime = time(adtDateTime)
ltTimeNew = ltTime
if llGMTOffset > 0 then
	llTimeSecs = SecondsAfter(time('00:00'), ltTime)
	if llTimeSecs < llGMTOffset then
		ldDate = RelativeDate(ldDate, -1)
		ltTimeNew = RelativeTime(time('23:59:59'), - (llGMTOffset - llTimeSecs))
	else
		ltTimeNew = RelativeTime(ltTime, - llGMTOffset)
	end if
elseif llGMTOffset < 0 then  //Offset is negative
	llTimeSecs = SecondsAfter(ltTime, time('23:59:59')) //seconds remaining in the day
	if llTimeSecs < llGMTOffset then // time remaining in the day is less than the net offset....
		//so add a day and add the remaing time
		ldDate = RelativeDate(ldDate, +1)
		ltTimeNew = RelativeTime(time('00:00'),  (llGMTOffset - llTimeSecs))
	else
		// adding the net offset won't require adding another day
		ltTimeNew = RelativeTime(ltTime, llGMTOffset)
	end if
end if

adtDateTime = DateTime(ldDate, ltTimeNew)
return adtDateTime
end function

on u_nvo_edi_confirmations_coty.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_coty.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

