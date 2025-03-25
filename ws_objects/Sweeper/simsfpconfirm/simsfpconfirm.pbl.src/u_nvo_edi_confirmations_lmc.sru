$PBExportHeader$u_nvo_edi_confirmations_lmc.sru
$PBExportComments$Process outbound edi confirmation transactions for LMC
forward
global type u_nvo_edi_confirmations_lmc from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_lmc from nonvisualobject
end type
global u_nvo_edi_confirmations_lmc u_nvo_edi_confirmations_lmc

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName
Datastore	idsDOMain, idsDODetail,   idsOut, idsROMain, idsRODetail, idsROPutaway, idsGR

end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Diebold for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsWarehouse, lsProcessProject

Decimal		ldBatchSeq
Integer		liRC
DateTime	ldtNow, ldtTransDate

//Transaction Date is Server Time (GMT) + 8 hours
ldtNow = DateTime(today(),Now())

select Max(dateAdd( hour, 8,:ldtNow )) into :ldtTransDate
from sysobjects;

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

//Don't send for Returns (Ord_Type = 'X')
If idsRoMain.GetITemString(1,'Ord_type') = 'X' Then
	
	lsLogOut = "      No GR created for Return from Customer Orders."
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
	
End If

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

//FileName is "SR" + Order Number
lsFileName = "SR" + trim(idsROMain.GetItemString(1,'supp_invoice_no')) + ".txt"

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCount = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	// Rolling up to Line/Sku/Lot/Exp Date
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	lsFind +=  " and expiration_date = '" + String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyymmdd') + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
			
		idsGR.SetItem(llNewRow,'po_number', trim(idsROMain.GetItemString(1,'supp_invoice_no')))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'lot_no',idsROPutaway.GetItemString(llRowPos,'lot_no')) 
		idsGR.SetItem(llNewRow,'expiration_date',String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyymmdd'))
		
		
	End If
	
Next /* Next Putaway record */


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to LMC!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows - Fixed Length

lsWarehouse = idsROMain.GetItemString(1,'wh_code')

//Write a Header Record...
If idsGR.RowCount() > 0 Then
	
	lsOutString = "R001" /* Line ID */
	lsOutString += lsWarehouse // "LMS" /*Warehouse Code */
	lsOutString += Space(3) /* Owner Code */
	lsOutString += String(ldtTransDate,'yyyymmdd') /* transaction Date (GMT + 8) */
	lsOutString += String(ldtTransDate,'hhmmss') /* transaction Time (GMT + 8) */
	lsOutString += space(8) /*MC Receipt Number */
	lsOutString += String(idsROMain.GetItemDateTime(1,'complete_date'),'yyyymmdd') /* Receipt Date (GMT + 8) */
	lsOutString += String(idsROMain.GetItemDateTime(1,'complete_date'),'hhmmss') /* Receipt Time (GMT + 8) */
	lsOutString += Left(trim(idsROMain.GetItemString(1,'supp_invoice_no')),8) + Space(8 - Len(trim(idsROMain.GetItemString(1,'supp_invoice_no')))) /*Owner Receipt/Doc ref. - SIMS Order Number */
	lsOutString += Space(20) /*Container Number */
	lsOutString += Space(10) /*Operator Code */
	lsOutString += Space(10)  /*Supplier COde */
	lsOutString += Space(35)  /*Supplier Name */
	lsOutString += Space(6) /*Receipt Type */
	lsOutString += Space(1) /*pseudo order flag */
	lsOutString += Space(1)  /*Filler*/
	lsOutString += Space(20) /*MAWB */
	lsOutString += Space(20) /*HAWB*/
	lsOutString += Left(trim(idsROMain.GetItemString(1,'supp_invoice_no')),8) + Space(20 - Len(trim(idsROMain.GetItemString(1,'supp_invoice_no')))) /*Advice Note - SIMS Order Number */
	lsOutString += Space(1) /*material Type */
	lsOutString += Space(20) /* Customs Declaration # */
	lsOutString += Space(1) /*Ihub/Ohub indicator */
	lsOutString += Space(15) /*Total WEight */
	lsOutString += Space(15) /*Total Peices */
		
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name',lsFileName)
	
End If

//Write a detail for each rolled up putaway
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'R002' /*Line ID */
	lsOutString += "0000000000" /*Transaction Number */
	lsOutString += Space(10) /*Purchase Order Number */
	lSOutString += Right(String(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'),'000'),3) /* GRN Line Number */
	lsOutString += Left(Trim(idsGR.GetItemString(llRowPos,'sku')),20) + Space(20 - Len(Trim(idsGR.GetItemString(llRowPos,'sku')))) /*Product Code */
	lsOutString += Space(30) /*Product Description */
	lsOutString += Space(6) /*SKU Type */
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity'),'0000000000') /*Quantity*/
	
	If idsGR.GetItemString(llRowPos,'lot_no') <> '-' Then /* System Rotation -  Lot # */
		lsOutString += left(trim(idsGR.GetItemString(llRowPos,'lot_no')),14) + Space(14 - Len(trim(idsGR.GetItemString(llRowPos,'lot_no'))))
	Else
		lsOutString += Space(14)
	End If
	
	lsOutString += Space(25) /*Customer ROtation */
	
	If idsgr.GetItemString(llRowPos,'expiration_date') <> "29991231" Then /* Expiration Date */
		lsOutString += idsgr.GetItemString(llRowPos,'expiration_date')
	Else
		lsOutString += Space(8)
	End If
	
	lsOutString += Space(8) /*Manufacture Date */
	lsOutString += Space(8) /*System Pallet Ref */
	lsOutString += Space(18) /*Owner Pallet Ref */
	lsOutString += Space(10) /*ILP/Cust Ref */
	lsOutString += Space(4) /*SAP Plant */
	lsOutString += Space(4) /*SAP Storage Loc */
	lsOutString += Space(3) /*SAP movement Type */
	lsOutString += Space(3) /* PO Line Number */
	lsOutString += Space(2) /*Reason Code */
	lsOutString += Space(3) /*Stockist Code */
	lsOutString += Space(8) /*Software version*/
	lsOutString += Space(30) /*hardware Version */
	lsOutString += Space(1) /*Customs Status*/
	lsOutString += Space(3) /*COO*/
	lsOutString += Space(2) /* Receipt Type Reason Code */
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name',lsFileName)
	
next /*next output record */

if lsWarehouse = "LMC-MY"  OR   lsWarehouse = "LMY" then
	lsProcessProject = "LMC-MY"
else
	lsProcessProject = "LMC"
end if


//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, lsProcessProject ) // asProject)

Return 0
end function

public function integer uf_gi (string asproject, string asdono);
//Prepare a Goods Issue Transaction for LMC for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo, llLineItemNoSave,	llBatchSeq,  llLineQty
				
String		lsFind, lsOutString,	lsMessage, lsSku, lsSkuSave, lsLot, lsLotSave,	&
			 lsLogOut, lsFileName, 	lsSQl, presentation_str, dwsyntax_str, lsErrText, lsWarehouse, lsProcessProject

DEcimal		ldBatchSeq
Integer		liRC
DateTime	ldtNow, ldtTransDate

Datastore	ldsDOPick

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




idsOut.Reset()

//Transaction Date is Server Time (GMT) + 8 hours
ldtNow = DateTime(today(),Now())

select Max(dateAdd( hour, 8,:ldtNow )) into :ldtTransDate
from sysobjects;

//Retreive Delivery Master
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsFileName = 'AR' + idsDoMain.GetITemString(1,'invoice_no') + '.txt'

// - Detail Information all coming from Delivery_Serial Detail (everything is scanned)
ldsDOPick = Create Datastore
presentation_str = "style(type=grid)"

lsSQl = " Select  Delivery_serial_detail.Mac_ID, Delivery_serial_detail.Serial_No,  Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU, Sum(Delivery_serial_detail.Quantity) as Quantity " /*MAC_ID = Lot_no */
lsSQL += " From Delivery_Picking_Detail, Delivery_Serial_Detail "
lsSQL += " Where Delivery_Picking_Detail.ID_NO = Delivery_Serial_Detail.ID_NO "
lsSQL += " and Delivery_Picking_Detail.do_no = '" + asDONO + "'"
lsSQL += " Group By Delivery_serial_detail.Mac_ID, Delivery_serial_detail.Serial_No,  Delivery_Picking_Detail.Line_Item_No, Delivery_Picking_Detail.SKU "
lsSQl += " Order by Line_item_No, SKU, MAc_ID "

dwsyntax_str = SQLCA.SyntaxFromSQL(lsSQL, presentation_str, lsErrText)
ldsDOPick.Create( dwsyntax_str, lsErrText)
ldsDOPick.SetTransobject(sqlca)
ldsDOPick.Retrieve()



//For each sku/line Item/inventory type in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

llRowCOunt = ldsDOPick.RowCount()


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to K&N!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - Fixed Length

lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')

//WRite the Header Record...
If ldsDOPick.RowCount() > 0  then
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = "D011" /* Line ID */
	lsOutString +=lsWarehouse    //  "LMS" /* warehouse */
	lsOutString += Space(3) /* Order Owner Code */
	lsOutString += Left(Trim(idsDoMain.GetITemString(1,'invoice_no')),14) + Space(14 - Len(Trim(idsDoMain.GetITemString(1,'invoice_no')))) /*seller's Order Ref (SIMS Order Number) */
	lsOutString += Space(20) /* Buyers Order Ref */
	lsOutString += Space(20) /* MC Sales Order Nbr */
	lsOutString += String(idsDoMain.GetITemDateTime(1,'Pick_Start'),'YYYYMMDD')
	lsOutString += Space(8) /* Date Shipped */
	lsOutString += Space(13) /* Customer Identity */
	lsOutString += Space(30) /* Carrier*/
	lsOutString += Space(14) /* Consignment Number */
	lsOutString += Space(10) /* Freight Charge*/
	lsOutString += Space(5) /* Total Pallets */
	lsOutString += Space(5) /* Total Cartons */
	lsOutString += String(ldtTransDate,'yyyymmdd') /* transaction Date (GMT + 8) */
	lsOutString += String(ldtTransDate,'hhmmss') /* transaction Time (GMT + 8) */
	lsOutString += Space(12) /* SAles Order Number */
	lsOutString += Space(30) /* Recipient Name */
	lsOutString += Space(2) /* Reason to Hold */
	lsOutString += Space(1) /* Request Type */
	lsOutString += Space(1) /* Mode of Transport */
	lsOutString += Space(6) /* Operator ID */
	lsOutString += Space(6) /* Route Code */
	lsOutString += Space(5) /* Load Number */
	lsOutString += Space(8) /* Date Delivered */
	lsOutString += Space(4) /* Time Delivered */
	lsOutString += Space(2) /* Ohub/Ihub ind */
	lsOutString += Space(1) /* Material Type*/
	
	LsOutString+= Space(254 - Len(lsOutString)) /*Pad to 254 char*/
		
	idsOut.SetItem(llNewRow,'Project_id', 'LMC')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
End If

//Write a detail record for each Pick Detail/Serial Detail

llRowCount = ldsDOPick.RowCount()
For llRowPos = 1 to llRowCOunt
	
	lsSKU = ldsDoPick.GetITemString(llRowPOs,'SKU')
	lsLot = ldsDoPick.GetITemString(llRowPOs,'mac_id') /*MAC_ID = Lot*/
	llLineItemNo = ldsDoPick.GetITemNumber(llRowPOs,'Line_Item_No')
	
	//D012 Record... This is at the Line/Sku/Lot level (may be multiple Serial Detail Records)  - We only want to write this record when this group changes. We need to get the total count for Line/SKU/Lot for the Qty Shipped field.
	If lsSKU <> LsSkuSave or llLineItemNo <> llLineItemNoSave or lsLot <> lsLotSave Then
		
		//TODO - Retrieve total Qty for Line,Sku,Lot
		Select Sum(quantity) into :llLineQty
		From Delivery_Picking
		Where do_no = :asDono and Line_Item_No = :llLineItemNo and Sku = :lsSKU and Lot_No = :lsLot;
		
		llNewRow = idsOut.insertRow(0)
	
		lsOutString = 'D012' /* Line ID*/
		lsOutString += "0000000000" /* Transaction Number*/
		lsOutString += String(ldsDOPick.GetITemNumber(llRowPos,'line_item_no'),'000') /*Line Number */
		lsOutString += Left(Trim(ldsDOPick.getItemString(llRowPos,'SKU')),20) + Space(20 - Len(Trim(ldsDOPick.getItemString(llRowPos,'SKU')))) /*Product Code */
		lsOutString += Space(30) /* Product Description */
		lsOutString += Left(Trim(ldsDOPick.getItemString(llRowPos,'mac_id')),14) + Space(14 - Len(Trim(ldsDOPick.getItemString(llRowPos,'mac_id')))) /*System Rotation (Lot) - STORED IN MAC_ID in Delivery_Serial_Detail */
		lsOutString += Space(25) /* Customer Rotation */
		lsOutString += Space(8) /* System Pallet Ref */
		lsOutString += Space(18) /* Owner Pallet Ref*/
		lsOutString += Space(14) /*Line Order Ref */
		lsOutString += Space(8) /* Qty Ordered*/
		lsOutString += Space(8) /* Qty Picked */
		lsOutString += String(llLineQty,'00000000') /* Qty Shipped */
		lsOutString += Space(8) /* Qty BAck Ordered*/
		lsOutString += Space(4) /* SAP Plant*/
		lsOutString += Space(4) /* SAP Storage Location*/
		lsOutString += Space(4) /* SAP Movement Code*/
		lsOutString += Space(4) /* SAP Reason Code*/
		lsOutString += Space(12) /* SAP CO Order Ref*/
		lsOutString += Space(2) /* Pick Reason Code*/
		lsOutString += Space(2) /* Despatch Reason Code */
		lsOutString += Space(6) /*  Ordered UOM*/
		lsOutString += Space(3) /* Stockist Code*/
		lsOutString += Space(10) /* Supplier Code*/
		lsOutString += Space(8) /* Invoice No*/
		lsOutString += Space(8) /* Qty Delivered/Received*/
		lsOutString += Space(2) /* POD Reason Code*/
		lsOutString += Space(1) /* Kit Flag*/
		lsOutString += Space(1) /* Transit Qty Flag*/
		lsOutString += Space(2) /* VHUB Receipt Type*/
		
		LsOutString+= Space(254 - Len(lsOutString)) /*Pad to 254 char*/
	
		idsOut.SetItem(llNewRow,'Project_id', 'LMC')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	End If /* Line, Sku or Lot changed */
	

	//D016 Record - This is at the Serial level (Detail) - only for serialized parts */
	
	If Left(trim(ldsDOPick.GetITemString(llRowPos,'Serial_no')),3) <> 'N/A' Then /* N/A is a dummy serial for non serialized parts*/
	
		llNewRow = idsOut.insertRow(0)
	
		lsOutString = 'D016' /* Line ID*/
		lsOutString += Left(trim(ldsDOPick.GetITemString(llRowPos,'Serial_no')),35) + Space(35 - Len(trim(ldsDOPick.GetITemString(llRowPos,'Serial_no')))) /*Starting Serial Number */
		lsOutString += Space(8) /* GRN Number*/
		lsOutString += String(ldsDOPick.GetITemNumber(llRowPos,'Quantity'),'000000') /* Serial Qty */
		
		LsOutString+= Space(254 - Len(lsOutString)) /*Pad to 254 char*/
	
		idsOut.SetItem(llNewRow,'Project_id', 'LMC')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	End If /*Serialized*/
	
	lsSKUSave = lsSKU
	llLineItemNoSave = llLineItemNo
	lsLotSave = lsLot
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW

if lsWarehouse = "LMC-MY" OR   lsWarehouse = "LMY" then
	lsProcessProject = "LMC-MY"
else
	lsProcessProject = "LMC"
end if

gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, lsProcessProject) //'LMC')



Return 0
end function

on u_nvo_edi_confirmations_lmc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_lmc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

