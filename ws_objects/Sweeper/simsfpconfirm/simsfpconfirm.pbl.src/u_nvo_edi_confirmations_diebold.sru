$PBExportHeader$u_nvo_edi_confirmations_diebold.sru
$PBExportComments$Process outbound edi confirmation transactions for Diebold
forward
global type u_nvo_edi_confirmations_diebold from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_diebold from nonvisualobject
end type
global u_nvo_edi_confirmations_diebold u_nvo_edi_confirmations_diebold

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName
Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment,idsROMain, idsRODetail, idsROPutaway, idsGR
Datastore 	idsWOMain, idsWODetail, idsWOPutaway
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_wr (string asproject, string aswono)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Diebold for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lswarehouse,  lsDieboldwarehouse,lsComplete

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
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

//Don't send a GR for orders loaded from the Excel Import or manually created orders. WE will base this on a value in Detail UF 1 (Spreadsheet ID) or lack of EDI_BATCH_SEQ_NO

// 08/08 - PCONKL - We DO want to send GR's for COmpnay 132 Replenishments which ARE also loded from spreadsheet - Order TYpe = P

If (idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no')) and idsRoMain.getITemString(1,'ord_type') <> 'P') Then
	lsLogOut = "                  This order was created manually. No GR is being created." + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

If idsroDetail.RowCount() > 0 Then
	If idsRoDetail.GetITemString(1,'User_Field1') > '' Then
		lsLogOut = "                  This order was imported through Excel Spreadsheet. No GR is being created." + asRONO
		FileWrite(gilogFileNo,lsLogOut)
		Return 0
	End If
End If


//MA
//If idsROMain.GetITemString(1,'user_field8') > ''  Then
//	lsLogOut = "                  This order was created manually through import. No GR is being created." + asRONO
//	FileWrite(gilogFileNo,lsLogOut)
//	Return 0
//End If


//We need the Diebold warehouse Code (CCMF)
lsWarehouse = idsromain.GetITemString(1,'wh_code')
		
Select user_field1 into :lsDieboldwarehouse
From Warehouse
Where wh_code = :lsWarehouse;
	


//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCount = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	// Rolling up to Line/Sku/Supplier/Inv Type/Lot/PONO/PONO2
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind +=  " and upper(supp_code) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Supp_code')) + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(po_no2) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no2')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		//idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		// 02/07/08 - somehow invoice is getting a leading space so trim-ing now...
		
		//09/08 - PCONKL - For warehouse transfers, the PO is in the Cutomer PO NUmber (Supp_Order_No) since we are using Sales order for the Order number instead of the PO NUmber
		If idsRoMain.GetITemString(1,'ord_type') = 'Z' Then
			If idsROMain.GetItemString(1,'supp_order_no') > '' Then
				idsGR.SetItem(llNewRow,'po_number', trim(idsROMain.GetItemString(1,'supp_order_no')))
			else
				idsGR.SetItem(llNewRow,'po_number', trim(idsROMain.GetItemString(1,'supp_invoice_no')))
			End If
		Else
			idsGR.SetItem(llNewRow,'po_number', trim(idsROMain.GetItemString(1,'supp_invoice_no')))
		End If
		
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetItemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'supp_code',idsROPutaway.GetItemString(llRowPos,'supp_code'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'po_no',idsROPutaway.GetItemString(llRowPos,'po_no')) /*Sales Order Line*/
		idsGR.SetItem(llNewRow,'po_no2',idsROPutaway.GetItemString(llRowPos,'po_no2')) /*Diebold Container*/
		idsGR.SetItem(llNewRow,'lot_no',idsROPutaway.GetItemString(llRowPos,'lot_no')) /*Sales Order*/
		
		
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to K&N!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	//a ccouple of fields coming from detail...
	lsFind = "Line_Item_No = " + String(idsGR.GetItemNumber(llRowPos,'po_item_number'))
	llFindRow = idsRoDetail.Find(lsFind,1,idsRodetail.RowCount())
	
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'GR|' /*rec type = goods receipt*/
	lsOutString += lsDieboldwarehouse + "|"
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd') + '|'
	
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_number') + '|'
	
	//Line NUmber coming from UF 6 on Detail
	If llFindRow > 0 Then
		If idsRodEtail.GetITemString(llFindRow,'User_Field6') > '' Then
			lsOutString += idsRodEtail.GetITemString(llFindRow,'User_Field6') + "|"
		Else
			lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
		End If
	Else
		lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	End If
	
	If idsGR.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'lot_no') + '|' /* SO */
	Else
		lsOutString += "|"
	End If
	
	If idsGR.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'po_no') + '|' /* SO Line */
	Else
		lsOutString += "|"
	End If
	
		
	If idsGR.GetItemString(llRowPos,'po_no2') <> '-' Then
		
		// 10/08 - PCONKL - Don't include Container for Company 132 Replenishment orders
		If idsRoMain.GetITemString(1,'ord_type') = 'P' Then
			lsOutString += "|"
		Else
			lsOutString += idsGR.GetItemString(llRowPos,'po_no2') + '|' /* Diebold Container */
		End iF
		
	Else
		lsOutString += "|"
	End If
	
	// 07/08 - PCONKL - hardcoding Company number to 100 for now. As part of release "2B", we will be storing company number in Owner and will pull from there when the time comes
	//08/08 - set to 132 if Order TYpe = 'P' (company 132 replenishments)
	If idsRoMain.getITemString(1,'ord_type') = 'P' Then
		lsOutString += "132|"
	Else
		lsOutString += "100|"
	End If
	
//	//Company Number - From Receive Detail UF3
//	If llFindRow > 0 Then
//		
//		If idsRodEtail.GetITemString(llFindRow,'User_Field3') > '' Then
//			lsOutString += idsRodEtail.GetITemString(llFindRow,'User_Field3') + "|"
//		Else
//			lsOutString += "|"
//		End If
//		
//	Else
//		lsOutString += "|"
//	End If
	
	//Order Type
	lsOutString += idsRoMain.GetITEmString(1,'ord_type')
	
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//	idsOut.SetItem(llNewRow,'file_name', 'N944' + String(ldBatchSeq,'00000') + '.DAT') 
	
next /*next output record */

//Add a trailer Record
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//idsOut.SetItem(llNewRow,'file_name', 'N944' + String(ldBatchSeq,'00000') + '.DAT') 

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_gi (string asproject, string asdono);
//Prepare a Goods Issue Transaction for Diebold for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llCartonCount
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSupplier,	lsInvType, lsTrackingNo, lsTemp,	&
				lsInvoice, lsLogOut, lsFileName, lsWarehouse, lsDieboldWarehouse, lsOwner, lsCustomer, lsCCMF

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

idsOut.Reset()
idsGR.Reset()

//Retreive Delivery Master, Detail and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

idsDoDetail.Retrieve(asDoNo)
idsDoPick.Retrieve(asDoNo)

//We need the Carton Count from Packing and a single Tracking ID from packing
Select Count(Distinct carton_no), MAX(Shipper_Tracking_ID) Into :llCartonCount, :lsTrackingNo 
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//Convert the SIMS Warehouse Code to the Diebold CCMF Code...
lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')

select User_Field1 
into :lsDieboldWarehouse
From Warehouse
Where wh_Code = :lsWarehouse;

If isNull(lsDieboldwarehouse) or lsDieboldwarehouse = '' Then lsDieboldwarehouse = lsWarehouse

// 11/08 - PCONKL - If Ship to Customer is actually one of our warehouses (Warehouse Transfer), convert our warehouse to the Diebold CCMF
lsCustomer = idsDOMAin.GetITEmString(1,'Cust_Code')
If lsCustomer > '' Then
	
	If Left( lsCustomer,4) = 'DIE-' Then
		
		Select User_Field1 into :lsCCMF
		From Warehouse
		Where wh_code = :lsWarehouse;
		
		If lsCCMF = "" Then lsCCMF = lsCustomer
		
	Else
		lsCCMF = lsCustomer
	End If
	
Else
	lsCCMF = lsCustomer
End If

//For each sku/line Item/inventory type in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

llRowCOunt = idsDOPick.RowCount()

For llRowPos = 1 to llRowCount
	
	//Dont send a record for non pickable Items
	If idsDOPick.GetItemString(llRowPos,'SKU_Pickable_Ind') = 'N' Then Continue
	
	//Rollup to SKU/Line/Inv Type/PO_NO2
	//07/08 - PCONKL - Line Item should now come from PO_NO (SO Line) instead of SIMS line item - we are assigning a sequential Line Item number now
	
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) 
	//lsFind += "' and po_item_number = " + String(idsDOPick.GetItemNumber(llRowPos,'Line_Item_no')) 
	lsFind += "' and po_item_number = " + idsDOPick.GetItemString(llRowPos,'po_no')
	lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llRowPos,'inventory_type'))
	lsFind += " and upper(po_no2) = '" + upper(idsDOPick.GetItemString(llRowPos,'po_no2')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsDoMain.GetItemString(1,'invoice_no'))
		idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llRowPos,'SKU'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'po_no2',idsDOPick.GetItemString(llRowPos,'po_no2'))
		idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llRowPos,'quantity'))
//		idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'po_item_number',Long(idsDOPick.GetItemString(llRowPos,'Po_No')))
	
		//TODO - This needs to come from PIcking Detail
		idsGR.SetItem(llNewRow,'serial_number',idsDoPick.GetItemString(llRowPos,'Serial_No'))
				
	End If
	
Next /* Next Pick record */


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to K&N!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GI|' /*rec type = goods Issue*/
	lsOutString += Left(lsDieboldWarehouse,10)  + '|'
	lsOutString += Left(idsGR.GetItemString(llRowPos,'po_number'),20) + '|'
	lsOutString += String(idsDoMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + '|'
	lsOutString += String(llCartonCount) + '|'
	
	If Not isnull(idsDoMain.GetItemString(1,'carrier')) Then
		lsOutString += left(idsDoMain.GetItemString(1,'carrier'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|' 
	lsOutString += idsGR.GetItemString(llRowPos,'SKU') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_no2') + '|' /*Deibold Container */
	lsOutString += lsCCMF + '|' /*customer */
		
	If idsDOMAin.GetITEmString(1,'Ship_Ref') > '' Then
		lsOutString += idsDOMAin.GetITEmString(1,'Ship_Ref') + '|'
	Else
		lsOutString += '|'
	End If
	
	lsTemp = idsGR.GetItemString(llRowPos,'serial_number')
	If lsTemp = '-' or isnull(lsTemp) Then
		lsOutString +='|'
	Else
		lsOutString += idsGR.GetItemString(llRowPos,'serial_number') + '|'
	End IF

	If idsDOMAin.GetITEmString(1,'Awb_bol_no') > '' Then
		lsOutString += idsDOMAin.GetITEmString(1,'Awb_bol_no') + '|'
	Else
		lsOutString += '|'
	End If
	
	//Owner coming from Detail UF 1
	// 07/08 - Hardcoding Owner to 100 for now. As part of release 2B, we will take from owner field and will change at that time
	
	lsOutString += "100"
	
//	llFindRow = idsDoDetail.Find("Line_item_No = " + String(idsGR.GetItemNumber(llRowPos,'po_item_number')),1,idsDoDetail.RowCount())
//	If llFindRow > 0 Then
//		lsOwner = idsDoDetail.GetITemString(llFindRow,'User_Field1')
//	Else
//		lsOwner = ''
//	End If
//	
//	if isnull(lsOwner) Then lsOwner = ''
//	
//	lsOutString += lsOwner
	
	idsOut.SetItem(llNewRow,'Project_id', 'DIEBOLD')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//lsFileName = 'BC_945_' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'DIEBOLD')



Return 0
end function

public function integer uf_wr (string asproject, string aswono);
//Prepare a Warehouse Receipt Transaction for Diebold for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lswarehouse,  lsDieboldwarehouse,lsComplete, lsSupp_Invoice_NO
String		lsFileName, lsSku, lsPONO2, lsWONumber

Decimal		ldBatchSeq
Integer		liRC, li_LineItemNo

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

If Not isvalid(idsWOMain) Then
	idsWOMain = Create Datastore
	idsWOMain.Dataobject = 'd_workorder_master'
	idsWOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsWODetail) Then
	idsWODetail = Create Datastore
	idsWODetail.Dataobject = 'd_workorder_detail_wono'
	idsWODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsWOPutaway) Then
	idsWOPutaway = Create Datastore
	idsWOPutaway.Dataobject = 'd_workorder_putaway'
	idsWOPutaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating WR For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
//must change.	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsWOMain.Retrieve(asProject, asWONO) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Work Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsWODetail.Retrieve(asWONO)
idsWOPutaway.Retrieve(asWONO)


//We need the Diebold warehouse Code (CCMF)
lsWarehouse = idsWOMain.GetITemString(1,'wh_code')
		
Select user_field1 into :lsDieboldwarehouse
From Warehouse
Where wh_code = :lsWarehouse;

	
	
Select User_Field2 into :lsSupp_Invoice_NO
From Workorder_Master
Where wo_NO = :asWONO;	
	

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCount = idsWOPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	// Rolling up to Line/Sku/Supplier/Inv Type/Lot/PONO/PONO2
	lsFind = "upper(sku) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsWOPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind +=  " and upper(supp_code) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'Supp_code')) + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(po_no2) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'po_no2')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsWOPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsWOPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'po_number', trim(lsSupp_Invoice_NO))
		idsGR.SetItem(llNewRow,'complete_date',idsWOMain.GetItemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsWOPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsWOPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'supp_code',idsWOPutaway.GetItemString(llRowPos,'supp_code'))
		idsGR.SetItem(llNewRow,'quantity',idsWOPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsWOPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'po_no',idsWOPutaway.GetItemString(llRowPos,'po_no')) /*Sales Order Line*/
		idsGR.SetItem(llNewRow,'po_no2',idsWOPutaway.GetItemString(llRowPos,'po_no2')) /*Diebold Container*/
		idsGR.SetItem(llNewRow,'lot_no',idsWOPutaway.GetItemString(llRowPos,'lot_no')) /*Sales Order*/
		
		
	End If
	
	
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Warehouse Receipt Confirmation.~r~rConfirmation will not be sent to K&N!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//lsFileName = 'WR_' + String(ldBatchSeq,'00000000') + '.DAT'

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	//a ccouple of fields coming from detail...
	lsFind = "Line_Item_No = " + String(idsGR.GetItemNumber(llRowPos,'po_item_number'))
	llFindRow = idsWODetail.Find(lsFind,1,idsWODetail.RowCount())
	
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'WR|' /*rec type = warehouse receipt*/
	lsOutString += lsDieboldwarehouse + "|"
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd') + '|'
	
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_number') + '|'
	
	//Line NUmber coming from UF 2 on Detail
	If llFindRow > 0 Then
		If idsWODetail.GetITemString(llFindRow,'User_Field2') > '' Then
			lsOutString += idsWODetail.GetITemString(llFindRow,'User_Field2') + "|"
		Else
			lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
		End If
	Else
		lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	End If
	
	If idsGR.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'lot_no') + '|' /* SO */
	Else
		lsOutString += "|"
	End If
	
	If idsGR.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'po_no') + '|' /* SO Line */
	Else
		lsOutString += "|"
	End If
	
		
	If idsGR.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'po_no2') + '|' /* Diebold Container */
	Else
		lsOutString += "|"
	End If
	
	lsOutString += "100|"

	
//	//Company Number - From Receive Detail UF3
//	If llFindRow > 0 Then
//		
//		If idsWODetail.GetITemString(llFindRow,'User_Field3') > '' Then
//			lsOutString += idsWODetail.GetITemString(llFindRow,'User_Field3') + "|"
//		Else
//			lsOutString += "|"
//		End If
//		
//	Else
//		lsOutString += "|"
//	End If
	
	//Order Type
	lsOutString += idsWOMain.GetITEmString(1,'ord_type')
	
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
next /*next output record */

//Add a trailer Record
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


//If the workorder type is "T" (Build and Transfer), 
//we want to update the matching Inbound Order that was created in the 
//receiving warehouse with the Container ID's that were saved in Workorder Putaway. 

IF idsWOMain.GetITEmString(1,'ord_type') = 'T' THEN

	llRowCount = idsWOPutaway.RowCount()
	
	For llRowPos = 1 to llRowCount	
	
		lsWONumber = idsWOMAin.GetITemString(1,'Workorder_Number')
		lsSku = idsWOPutaway.GetItemString(llRowPos,'sku')
		li_LineItemNo = idsWOPutaway.GetItemNumber(llRowPos,'line_item_no')
		lsPONO2 = idsWOPutaway.GetItemString(llRowPos,'po_no2')
	
		UPDATE EDI_Inbound_Detail 
		Set po_no2  = :lsPONO2
		WHERE  Project_id = 'DIEBOLD' AND  Order_No = :lsWONumber AND 
				Line_Item_No = :li_LineItemNo and 
				SKU = :lsSku USING SQLCA;
	
		Commit;
		
	Next /* Next Putaway record */	
			
END IF


Return 0


end function

on u_nvo_edi_confirmations_diebold.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_diebold.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

