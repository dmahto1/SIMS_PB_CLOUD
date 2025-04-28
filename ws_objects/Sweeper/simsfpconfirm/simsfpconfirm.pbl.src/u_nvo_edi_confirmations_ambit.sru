$PBExportHeader$u_nvo_edi_confirmations_ambit.sru
$PBExportComments$Process outbound edi confirmation transactions for Ambit
forward
global type u_nvo_edi_confirmations_ambit from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_ambit from nonvisualobject
end type
global u_nvo_edi_confirmations_ambit u_nvo_edi_confirmations_ambit

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_rt (string asproject, string asorderid)
public function integer uf_gr (string asproject, string asrono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Ambit for the order that was just confirmed

Datastore	ldsSerial
				
Long			llRowPos, llRowCount, llNewRow, llBatchSeq, llPickQty, lLSerialCount, llSerialPos, llPickPos, llFindRow, llNewSerialRow
				
String		lsFind, 	lsOutString, lsMessage,	lsSku, lsInvoice, lsCurrency, lsFileName,	&
				lsPallet, lsPalletHold, lsCarton, lsSerial, lsDoNo, lsCustomer, lsLogOut,lsInvoiceTEmp

DEcimal		ldBatchSeq, ldFreightCost, ldTotalQty, ldRcvQty, ldShipQty
Integer		liRC

DateTime		ldtCompleteDate, ldtToday

Boolean		lbFullPallet


ldtToday = DateTime(Today(),Now())

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

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_gi_outbound_serial'
lirc = ldsSerial.SetTransobject(sqlca)

idsOut.Reset()
idsGR.Reset()

//Retreive Delivery Master, Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoPick.Retrieve(asDoNo) /*Pick Records */

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//We're sending a header level confirmation with Freight Costs and Currency info

lsInvoice = idsDOMain.GetITemString(1,'Invoice_No')
lsCustomer = idsDOMain.GetITemString(1,'Cust_Code')
lsDoNo = idsDOMain.GetITemString(1,'DO_No')

lsCurrency = idsDOMain.GetITemString(1,'USer_Field4') /*Currency Code in UF4*/
If isNull(lsCurrency) Then lsCurrency = ''

ldFreightCost = idsDOMain.GetiTEmDecimal(1,'freight_cost')
If isnull(ldFreightCost) Then ldFreightCost = 0
ldFreightCost = ldFreightCost * 100 /*implied decimal*/

ldtCompleteDate = idsDOMain.GetITemDateTime(1,'complete_date')

//Set Output File Name (from Sweeper)
lsFileName = "C" + String(Today(),'YYYYMMDDHHMMSS') + ".dat"

//each column is a seperate row in the file

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)

//Left fill Invoice Numer with zeros to 10 char
lsInvoiceTEmp = lsInvoice /*used below, don't want to pad there*/
Do WHile Len(LsInvoiceTemp) < 10
	lsInvoiceTemp = "0" + LsInvoiceTemp
Loop

idsOut.SetItem(llNewRow,'batch_data', "F01" + lsInvoiceTemp) /* Invoice NUmber - padded above to 10 */
idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', "F02US$") /* Currency- HArdCode to US$*/
idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', "F03" + String(ldFreightCost,'0000000000')) /* Freight Charge*/
idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', "F04" + String(ldtCompleteDate,'YYYYMMDD')) /* Invoice NUmber*/
idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/


//Write the Detail Level Confirmation

// 05/04 - PCONKL - Only tracking by Pallet at Inbound now, loose cartons will be entered in the Outbound Serial tab
//Anything not a full pallet will be processed as a carton or serial # from the serial tab

//We want to report full pallets, full cartons (if not a full pallet) and loose (if not a full carton)
//To do that, we will compare what was putaway to what was picked to determine full pallet/carton

llRowCOunt = idsDOPick.RowCount()

lsPalletHold = ''

//New file for detail File
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Total qty needed for file name
Select Sum(Delivery_Picking.Quantity)
Into	:ldTotalQty
From Delivery_Picking
Where do_no = :lsDONO;

If isnull(ldTotAlQty) Then ldTotalQty = 0

//Set File Name = Invoice_no + Ship Qty + Ship Date
lsFileName = lsInvoice + '-' + String(ldTotalQTY,'#############0') + 'PCS-' + String(ldtCompleteDate,'YYYY.MM.DD') + '.txt'

For llRowPos = 1 to llRowCount
	
	lsPallet = idsDOPick.GetITemString(llRowPos,'lot_no') /* pallet in Lot_no */
	lsSKU = idsDOPick.GetITemString(llRowPos,'SKU')
	
	//If the Pallet has changed, check to see if it is full, if so, write a record and skip to next pallet
	If lsPallet <> lsPalletHold Then

		Select Sum(Quantity) Into :ldShipQty
		From Delivery_Picking
		Where do_no = :lsDoNo and Sku = :lsSKU and Lot_No = :lsPallet;
		
		Select Sum(Quantity) Into :ldRcvQty
		From Receive_Putaway
		Where Sku = :lsSKU and Lot_No = :lsPallet and ro_no in (select ro_no from Delivery_Picking_Detail where do_no = :lsDoNo);
				
		If ldShipQty = ldRcvQty Then /* full pallet being shipped */
		
			//Write a full pallet Transaction
			llNewRow = idsOut.insertRow(0)
			idsOut.SetItem(llNewRow,'Project_id', asProject)
			idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
			idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/
			
			//format output string as fixed block
			lsOutString =  lsInvoice + Space(25 - Len(lsInvoice)) /*Order Number - pad to 25 */
			lsOutString +=  lsPallet + Space(25 - Len(lsPallet)) /*pallet Number - pad to 25 */
			lsOutString += "P" /* pallet */
			lsOutString +=  lsSKU + Space(25 - Len(lsSKU)) /*SKU*/
			lsOutString +=  lsCustomer + Space(25 - Len(lsCustomer)) /*Cust Code*/
						
			idsOut.SetItem(llNewRow,'batch_data',lsOutString)
			
			lbFullPallet = True /* won't write any more transactions for this pallet*/
			
		Else /* Not a full pallet being shipped*/
		
			lbFullPallet = False /* Need to write carton/Serial level transactions for this Pallet*/
			
		End If /* Full pallet Shipped */
				
	Else /* Same Pallet*/
						
	End If /* Pallet Changed*/
		
	lsPalletHold = lsPallet
		
Next /* Next Pick record */

//Anything not reported as a full pallet will be reported as either a carton or serial

//Retrieve all of the Outbound Serial records - no need to do by SKU
llSerialCount = ldsSerial.Retrieve(lsDoNo)

For llRowPos = 1 to llSerialCount /* each outbound serial entered*/
	
	//If the Serial begins with a 'C', it is a carton, otherwise it's a Serial
	lsSerial = ldsSerial.GetITemString(llRowPos,'serial_no')
	lsSKU = ldsSerial.GetITemString(llRowPos,'SKU')
	
	If Upper(Left(lsSerial,1)) = 'C' Then
		
		//Create a Carton Level Transaction
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
		idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/
			
		//format output string as fixed block
		lsOutString =  lsInvoice + Space(25 - Len(lsInvoice)) /*Order Number - pad to 25 */
		lsOutString +=  lsSerial + Space(25 - Len(lsSerial)) /*Carton Number - pad to 25 */
		lsOutString += "C" /* Carton */
		lsOutString +=  lsSKU + Space(25 - Len(lsSKU)) /*SKU*/
		lsOutString +=  lsCustomer + Space(25 - Len(lsCustomer)) /*Cust Code*/
					
		idsOut.SetItem(llNewRow,'batch_data',lsOutString)
			
	Else /*Serial */
		
		//Write a serial Row
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'file_name', lsFileName) /*output file Name*/
		idsOut.SetItem(llNewRow,'dest_cd', 'GI') /*routed to GI folder*/
				
		//format output string as fixed block
		lsOutString =  lsInvoice + Space(25 - Len(lsInvoice)) /*Order Number - pad to 25 */
		lsOutString +=  lsSerial + Space(25 - Len(lsSerial)) /*Serial Number - pad to 25 */
			
		lsOutString += "S" /* Serial */
		lsOutString +=  lsSKU + Space(25 - Len(lsSKU)) /*SKU*/
		lsOutString +=  lsCustomer + Space(25 - Len(lsCustomer)) /*Cust Code*/
									
		idsOut.SetItem(llNewRow,'batch_data',lsOutString)
				
	End If
	
Next /* Next Outbound Serial */
		
				
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,ASPROJECT)

Return 0
end function

public function integer uf_rt (string asproject, string asorderid);
Return 0
end function

public function integer uf_gr (string asproject, string asrono);Integer	liRC
String	lsLogout, lsWarehouse, lsAmbitWarehouse, lsFind, lsOutString, lsFileName
Long		llRowCOunt, llRowPos, llFindRow, llNewRow
Decimal	ldBatchSeq

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
	idsromain.SetTransobject(sqlca)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransobject(sqlca)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

//Convert our warehouse to Ambit Warehouse Code
lsWarehouse = idsROMain.GetITemString(1,'wh_code')
Choose Case Upper(lsWarehouse)
	Case 'AMBIT-WDY'
		lsAmbitWarehouse = 'FD'
	Case 'AMBIT-OTAY', 'AMBIT-RMAO'
		lsAmbitWarehouse = 'FE'
	Case Else
		lsAmbitWarehouse = 'FD'
End Choose

llRowCOunt = idsROPutaway.RowCount()

//Rollup to Line/SKU level
For llRowPos = 1 to llRowCount
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	End If
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no(gs_project,'EDI_Inbound_Header','EDI_Inbound_Header',ldBatchSeq)
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the Header Row - Each colum is a seperate row

//OrderNo
lsOutString = 'H01' + idsROMain.GetItemString(1,'supp_invoice_no')
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/

//Warehouse
lsOutString = 'H02' + lsAmbitWarehouse
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/

//Receipt Date
lsOutString = 'H03' + String(idsROMain.GetItemDateTime(1,'Complete_date'),'YYYYMMDD')
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/


//Write the Trailer ROw
lsOutString = 'T01' + String(idsgr.RowCount()) /* Number of Lines */
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/

//Write the detail rows - Each field is a seperate row in the file
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	//Line Number
	lsOutString = 'D01' + String(idsgr.getITemNumber(llRowPos,'po_item_number')) 
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/
	
	//SKU
	lsOutString = 'D02' + idsgr.getITemString(llRowPos,'SKU') /* Line Item Number */
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/

	//QTY
	lsOutString = 'D03' + String(idsgr.getITemNumber(llRowPos,'Quantity')) 
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'AMBIT')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'dest_cd', 'GR') /*routed to Goods Receipt folder*/
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'AMBIT')

Return 0

REturn 0
end function

on u_nvo_edi_confirmations_ambit.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_ambit.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

