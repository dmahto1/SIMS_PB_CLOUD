HA$PBExportHeader$u_nvo_edi_confirmations_phoenix.sru
$PBExportComments$Process outbound edi confirmation transactions for Phoenix Brands
forward
global type u_nvo_edi_confirmations_phoenix from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_phoenix from nonvisualobject
end type
global u_nvo_edi_confirmations_phoenix u_nvo_edi_confirmations_phoenix

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_rt (string asproject, string asrono)
public function integer uf_transfer_in (string asproject, string asrono)
public function integer uf_transfer_out (string asproject, string asdono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_lms_itemmaster ()
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Phoenix for the order that was just confirmed

		
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsPHXWarehouse, lsWarehouse, lsFileName

DEcimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

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
//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//Convert our warehouse code to PHX Warehouse ID
lsWarehouse = idsROMain.GetITemString(1,'wh_code')
Select User_Field1 into :lsPHXWarehouse
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
// TAM 03/07/2007 - Added Lot_No to the find
// TAM 05/16/2007 - Removed Lot_No from the find.  They changed their mind.
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
// TAM 03/07/2007 - Added Sales Order Number and LOT_NO to the output
		If Not isnull(idsROMain.GetItemString(1,'Supp_Order_No')) Then //Supp_Order_Number is not required so check if null
			idsGR.SetItem(llNewRow,'supp_order_no',idsROMain.GetItemString(1,'Supp_Order_No'))
		Else
			idsGR.SetItem(llNewRow,'supp_order_no','')
		End If
// TAM 05/16/2007 - Removed Lot Number and Added AWBBOL to the output
		If Not isnull(idsROMain.GetItemString(1,'AWB_BOL_No')) Then //AWB_BOL_No is not required so check if null
			idsGR.SetItem(llNewRow,'awb_bol_no',idsROMain.GetItemString(1,'AWB_BOL_No'))
		Else
			idsGR.SetItem(llNewRow,'awb_bol_no','')
		End If
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

//Write the rows to the generic output table - FIXED LENGTH
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'GR' /*rec type = goods receipt*/
	lsOutString += lsPhxWarehouse + Space(10 - (len(lsPHXWarehouse))) /*PHX warehouse code */
	lsOutString += '+' /*normal receicpt*/
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') 
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd') 
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + Space(26 - Len(idsGR.GetItemString(llRowPos,'sku'))) /*pad to 26 with spaces*/
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity'),'0000000000000') /*pad to 13 with zeros*/
	lsOutString += Left(idsGR.GetItemString(llRowPos,'po_number'),10) + Space(10 - Len(idsGR.GetItemString(llRowPos,'po_number'))) /*pad to 10 with spaces*/
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number'),'00000') /* pad to 5 with zeros */
// TAM 03/07/2007 - Added Supplier Order Number and LOT_NO to the output
	lsOutString += idsGR.GetItemString(llRowPos,'supp_order_no') + Space(20 - Len(idsGR.GetItemString(llRowPos,'supp_order_no'))) /*pad to 20 with spaces*/
// TAM 05/16/2007 - Removed LOT_NO and added AWB_BOL_NO
	lsOutString += idsGR.GetItemString(llRowPos,'awb_bol_no') + Space(20 - Len(idsGR.GetItemString(llRowPos,'awb_bol_no'))) /*pad to 20 with spaces*/
	
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIGR944P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIGR944P.A' + String(ldBatchSeq,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	 If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
	  idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	 End If
	
	
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

Return 0
end function

public function integer uf_rt (string asproject, string asrono);//Prepare a Goods Return Transaction for Phoenix for the order that was just confirmed
// Using the Adjustment format

		
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsPHXWarehouse, lsWarehouse, lsFileName

DEcimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

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

lsLogOut = "      Creating RT For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)
//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//Convert our warehouse code to PHX Warehouse ID
lsWarehouse = idsROMain.GetITemString(1,'wh_code')
Select User_Field1 into :lsPHXWarehouse
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
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


//Write the rows to the generic output table FIXED LENGTH
llRowCount = idsgr.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'MM' /*rec type = Material Movement (RMA)*/
	lsOutString += lsPHXWarehouse + Space(10 - Len(lsPHXWarehouse))
	lsOutString += "RMA" /*movement Type*/
	lsOutString += " " /* Inventory type from */
	lsOutString += idsgr.GetItemString(llRowPos,'Inventory_type') /* Inventory Type To */
	lsOutString += String(idsgr.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd')
	
	If idsROMain.GetItemString(1,'User_field4') = 'M' Then /* Reason - who pays freight   */
		lsOutString += 'M   '
	Else
		lsOutString += 'C   '
	End If
	
	lsOutString += Left(idsgr.GetItemString(llRowPos,'SKU'),26)  + Space(26 - Len(idsgr.GetItemString(llRowPos,'SKU')))
	lsOutString += string(idsgr.GetItemNumber(llRowPos,'quantity'),'0000000000000') 
	lsOutString += '+' /* Qty incremented on receipt */
	lsOutString += left(idsgr.GetItemString(llRowPos,'po_number'),10) + Space(10 - Len(idsgr.GetItemString(llRowPos,'po_number')))
	lsOutString += String(idsgr.GetItemNumber(llRowPos,'po_item_number'),'000000') 
	lsOutString += Left(asRoNo,16) + Space(16 - Len(asRoNo)) /* Transaction Number (RONO)*/
	lsOutString += String(ldbatchSeq,'00000000000000000000') /* Ref Nbr */
	lsOutString += Space(20) /* Owner - Not used */
	
		
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIMM947P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIMM947P.A' + String(ldBatchSeq,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	End If
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

Return 0


end function

public function integer uf_transfer_in (string asproject, string asrono);//Prepare a Transfer IN transaction for Transfer Order (Receipt) just Confirmed
// Using the Adjustment format

		
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsPHXWarehouse, lsWarehouse, lsFileName

DEcimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

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

lsLogOut = "        Creating Transfer In MM For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive receive Order Header For Transfer: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//Convert our warehouse code to PHX Warehouse ID
lsWarehouse = idsROMain.GetITemString(1,'wh_code')
Select User_Field1 into :lsPHXWarehouse
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	End If
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no(gs_project,'EDI_Inbound_Header','EDI_Inbound_Header',ldBatchSeq)
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive next sequence number for Trandsfer In MM Confirmation!"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table FIXED LENGTH
llRowCount = idsgr.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'MM' /*rec type = Material Movement (RMA)*/
	lsOutString += lsPHXWarehouse + Space(10 - Len(lsPHXWarehouse))
	lsOutString += "WFR" /*movement Type - Warehouse Transfer*/ 
	lsOutString += idsgr.GetItemString(llRowPos,'Inventory_type')/* Inventory type from */
	lsOutString += idsgr.GetItemString(llRowPos,'Inventory_type') /* Inventory Type To */
	lsOutString += String(idsgr.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd')
	lsOutString += "    " /* reason Code*/
	lsOutString += Left(idsgr.GetItemString(llRowPos,'SKU'),26)  + Space(26 - Len(idsgr.GetItemString(llRowPos,'SKU')))
	lsOutString += string(idsgr.GetItemNumber(llRowPos,'quantity'),'0000000000000') 
	lsOutString += '+' /* Qty incremented on Transfer IN */
	lsOutString += left(idsgr.GetItemString(llRowPos,'po_number'),10) + Space(10 - Len(idsgr.GetItemString(llRowPos,'po_number')))
	lsOutString += String(idsgr.GetItemNumber(llRowPos,'po_item_number'),'000000') 
	lsOutString += Left(asRoNo,16) + Space(16 - Len(asRoNo)) /* Transaction Number (RONO)*/
	lsOutString += String(ldbatchSeq,'00000000000000000000') /* Ref Nbr */
	lsOutString += Space(20) /* Owner - Not used */
	
		
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIMM947P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIMM947P.A' + String(ldBatchSeq,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	End If
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

Return 0


end function

public function integer uf_transfer_out (string asproject, string asdono);//Prepare a Transfer OUT transaction for Transfer Order (Delivery) just Confirmed
// Using the Adjustment format

		
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsPHXWarehouse, lsWarehouse, lsFileName

DEcimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

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

idsOut.Reset()
idsGR.Reset()

lsLogOut = "        Creating Transfer Out MM For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retrieve Delivery Master & Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoPick.Retrieve(asDoNo) /*Pick Records */


//For each sku/inventory type in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

//Convert our warehouse code to PHX Warehouse ID
lsWarehouse = idsDOMain.GetITemString(1,'wh_code')
Select User_Field1 into :lsPHXWarehouse
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''

llRowCOunt = idsDOPick.RowCount()

For llRowPos = 1 to llRowCount
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsDOPick.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llRowPos,'inventory_type')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsDOMain.GetItemString(1,'invoice_no'))
		idsGR.SetItem(llNewRow,'complete_date',idsDOMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsDOPick.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llRowPos,'line_item_no'))
	End If
Next /* Next Picking record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//sqlca.sp_next_avail_seq_no(gs_project,'EDI_Inbound_Header','EDI_Inbound_Header',ldBatchSeq)
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive next sequence number for Transfer Out MM Confirmation!"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table FIXED LENGTH
llRowCount = idsgr.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'MM' /*rec type = Material Movement (RMA)*/
	lsOutString += lsPHXWarehouse + Space(10 - Len(lsPHXWarehouse))
	lsOutString += "WFR" /*movement Type - Warehouse Transfer*/ 
	lsOutString += idsgr.GetItemString(llRowPos,'Inventory_type') /* Inventory Type From */
	lsOutString += idsgr.GetItemString(llRowPos,'Inventory_type') /* Inventory type To */
	lsOutString += String(idsgr.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd')
	lsOutString += "    " /* reason Code*/
	lsOutString += Left(idsgr.GetItemString(llRowPos,'SKU'),26)  + Space(26 - Len(idsgr.GetItemString(llRowPos,'SKU')))
	lsOutString += string(idsgr.GetItemNumber(llRowPos,'quantity'),'0000000000000') 
	lsOutString += '-' /* Qty decremented on Transfer OUT */
	lsOutString += left(idsgr.GetItemString(llRowPos,'po_number'),10) + Space(10 - Len(idsgr.GetItemString(llRowPos,'po_number')))
	lsOutString += String(idsgr.GetItemNumber(llRowPos,'po_item_number'),'000000') 
	lsOutString += Left(asDoNo,16) + Space(16 - Len(asDoNo)) /* Transaction Number (DONO)*/
	lsOutString += String(ldbatchSeq,'00000000000000000000') /* Ref Nbr */
	lsOutString += Space(20) /* Owner - Not used */
	
		
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIMM947P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIMM947P.A' + String(ldBatchSeq,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	End If
	
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

Return 0


end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for 3COM NAshville for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsWarehouse, lsPhxWarehouse, lsRONO, lsOrder, lsPosNeg, lsGRP

DEcimal		ldBatchSeq, ldNetQty
Integer		liRC
String	lsLogOut

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = idsAdjustment.GetITemString(1,'ro_no')

lsSku = idsAdjustment.GetITemString(1,'sku')
lsSupplier = idsAdjustment.GetITemString(1,'supp_code')

lsReason = idsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''
	
lsOldInvType = idsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")

llOwnerID = idsAdjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsAdjustment.GetITemNumber(1,"old_owner")

llAdjustID = idsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")

// TAM 2007/02/21 - Don't send Adjustments with Item Master Group types = 'CORR'
SELECT GRP Into :lsGrp
    FROM Item_Master    
Where ITem_Master.Project_ID = :asProject and Item_Master.SKU = :lsSKU and 
		Item_Master.Supp_Code = :lsSupplier;  
//

		
//We are only sending Qty Change or Breakage (New Inv Type = 'D')
// TAM 2007/02/21 - Remove Item_Master.GRP = 'CORR' 
// If lsNewInvType = 'D' or (llNewQTY <> llOldQTY)  Then
If (lsNewInvType = 'D' or (llNewQTY <> llOldQTY)) and lsGRP <> 'CORR'  Then
		
	If  lsNewInvType = 'D' Then /* set to DAmage*/
		lsTranType = 'BRK'
	Else /* Process as a qty adjustment*/
		lsTranType = 'PCT'
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
		
	//Convert our WH to Their Code
	lsWarehouse = idsAdjustment.GetITemString(1,'wh_code')
		
	Select user_field1 into :lsPHXWarehouse
	From Warehouse
	Where wh_code = :lsWarehouse;
	
	If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''
	
	lsOutString = 'MM' /*rec type = Material Movement*/
	lsOutString += lsPHXWarehouse + Space(10 - Len(lsPHXWarehouse))
	lsOutString += lsTranType 
	lsOutString += left(lsOldInvType,1) /*old Inv Type*/
	lsOutString += left(lsNewInvType,1) /*New Inv Type*/
	lsOutString += String(today(),'yyyymmdd') 
	lsOutString += Left(lsReason,4) + Space (4 - len(lsReason)) /*reason*/
	lsOutString += Left(lsSku,26) + Space (26 - len(lsSKU))
	lsOutString += String(ldNetQty,'0000000000000') 
	lsOutString += lsPosNeg /* Qty Sign */
	lsOutString += Left(lsRONO,10)  + Space (10 - Len(lsRONO)) /* Original Order NUmber*/
	lsOutString += '000000' /* Original Order Line Number - N/A */
	lsOutString += String(alAdjustID,'0000000000000000') /*Internal Ref #*/
	lsOutString += String(alAdjustID,'00000000000000000000') /*External Ref #*/
	lsOutString += Space(20) /*Owner*/
					
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SIMM947P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SIMM947P.A' + String(ldBatchSeq,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	End If
	
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
End If /* inv type changed*/
		


Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Phoenix for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llRecSeq
				
String		lsFind, lsOutString, lsOutString_LMS,	lsMessage, lsSku,	lsSupplier,	lsInvType,	&
				lsInvoice, lsLogOut, lsWarehouse, lsPHXwarehouse, lsFileName, lsuccswhprefix, lsuccscompanyprefix,	&
				lsUCCCarton, lsChepIndicator, lsWHName, lsWHAddr1, lsWHAddr2, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lsCartonSave

Decimal		ldBatchSeq, ldBatchSeq2, ldVolume, ldWeight, ldNetWeight
Integer		liRC, liCheck
DateTime		ldtToday

// pvh - 08/23/06 - Order Type 'Z' or 'T' 
string ordType

ldtToday = DateTime(Today(),Now())

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDODetail) Then
	idsDODetail = Create Datastore
	idsDODetail.Dataobject = 'd_do_detail'
	idsDODetail.SetTransObject(SQLCA)
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
idsGR.Reset()

//Retreive Delivery Master, Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoDetail.Retrieve(asDoNo) /*detail Records*/
idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*PAck Records */

// pvh - 08/23/06 - order type
ordType = Upper( Trim( idsDoMain.Object.ord_type[ 1 ]  ) )
// set the outstream order type
//05/08 - PCONKL - Always send back what LMS sent to us (UF2) regardless of order type
If Not isnull(  idsDoMain.Object.user_field2[ 1 ]  ) Then 
	ordType = left(  idsDoMain.Object.user_field2[ 1 ] + space(4), 4 ) 
Else
	ordType = Space(4)
End If

//choose case ordType
//		case 'Z', 'T'
//			ordType = left( ordType + space(4), 4 ) 
//		case else
//			If Not isnull(  idsDoMain.Object.user_field2[ 1 ]  ) Then 
//				ordType = left(  idsDoMain.Object.user_field2[ 1 ] + space(4), 4 ) 
//			Else
//				ordType = Space(4)
//			End If
//end choose
	

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Convert our warehouse code to PHX Warehouse ID - We also need the UCCS Location Code
// 02/07 - PCONKL - Need ship from info
lsWarehouse = idsDOMain.GetITemString(1,'wh_code')
Select User_Field1,ucc_location_Prefix, wh_Name, address_1, address_2, city, state, zip, country 
Into :lsPHXWarehouse, :lsuccswhprefix, :lsWHName, :lsWHAddr1, :lsWHADdr2, :lsWHCity, :lsWHState, :lsWHZip, :lsWHCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsPHXWarehouse) Then lsPHXWarehouse = ''

//Need company level UCCS Code for Carton Number
Select ucc_Company_Prefix into :lsuccscompanyprefix
FRom Project
Where Project_ID = :asProject;

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// File to Phoenix - different batch sequence so we get 2 different files when written to flat file
ldBatchSeq2 = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create a 945 (GI) for LMS and Phoenix, after the record is created for LMS, we will add a couple of columns for JVH
llRowCount = idsdoPack.RowCount()

llRecSeq = 0

For llRowPos = 1 to llRowCount /* each Pack Row */
	
	//We need some fields from Order Detail
	lsSKU = idsDOPack.GetItemString(llRowPos,'SKU')
	llLineITemNo = idsdoPack.GetItemNumber(llRowPos,'Line_Item_No')
	llFindRow = idsDoDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineITemNo),1,idsdoDetail.RowCount())
	
	llRecSeq ++
	lsOutString = String(llRecSeq,'000000') /* Record Number*/
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	
//	//01/08 - PCONKL - For Warehouse transfers (Z or T type), set the Type to 'TRX'
//	If Upper(Trim(ordType)) = 'Z' or Upper(Trim(ordType)) = 'T' Then
//		lsOutString += 'TRX' /*transaction Code */
//		lsOutString_LMS += 'TRX' /*transaction Code */
//	Else
//		lsOutString += 'SHP' /*transaction Code */
//		lsOutString_LMS += 'SHP' /*transaction Code */
//	End If

	lsOutString += 'SHP' /*transaction Code */
	lsOutString_LMS += 'SHP' /*transaction Code */
	
	lsOutString += lsPHXWarehouse + Space(6 - Len(lsPHXWarehouse)) /*warehouse*/
	lsOutString_LMS += lsPHXWarehouse + Space(6 - Len(lsPHXWarehouse)) /*warehouse*/
	
	lsOutString += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	
	lsOutString += String(ldtToday,'HHMMSS') /* Transaction Time*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	lsOutString_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	
	/*Order Type */
	// pvh - 08/23/06 - Order Type 'Z' or 'T' 
	// moved the logic to set this outside the loop
	lsOutString += ordType
	lsOutString_LMS += ordType
//	
//	If Not isnull(idsDoMain.GetItemString(1,'User_Field2')) Then 
//		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field2'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field2')))
//		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field2'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field2')))
//	Else
//		lsOutString += Space(4)
//		lsOutString_LMS += Space(4)
//	End If
//

	/*Line Item Number */
	If Not isnull(idsDoPack.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
		lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
		lsOutString_LMS += String(idsDoPack.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
	Else
		lsOutString += '000000'
		lsOutString_LMS += '000000'
	End If
	
	lsOutString += Space(1) /*Line Item Complete*/
	lsOutString_LMS += Space(1) /*Line Item Complete*/
	
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* AWB BOL */
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
	Else
		lsOutString += Space(10)
		lsOutString_LMS += Space(10)
	End If
	
	//Original Qty = Need from Order Detail
	If llFindRow > 0 Then /*detail row found above */
		lsOutString += String((idsDoDetail.GetItemDecimal(llFindRow,'Req_Qty') * 100),'000000000000') /* Implied 2 decimal place*/
		lsOutString_LMS += String(idsDoDetail.GetItemDecimal(llFindRow,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
	Else /*not found */
		lsOutString += '000000000000'
		lsOutString_LMS += '000000000.00'
	End If
	
	//Pack Qty
	lsOutString += String((idsdoPack.GetItemDecimal(llRowPos,'quantity') * 100),'000000000000') /*Implied 2 decimal */
	lsOutString_LMS += String(idsdoPack.GetItemDecimal(llRowPos,'quantity'),'000000000.00') /*Explicit 2 decimal */
	
	//UOM - From ORder Detail
	If llFindRow > 0 Then /*detail row found above */
		If Not isnull(idsdoDetail.GetItemstring(llFindRow,'uom')) Then
			lsOutString += idsdoDetail.GetItemstring(llFindRow,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llFindRow,'uom')))
			lsOutString_LMS += idsdoDetail.GetItemstring(llFindRow,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llFindRow,'uom')))
		Else
			lsOutString += Space(6)
			lsOutString_LMS += Space(6)
		End If
	Else /* Not Found */
		lsOutString += Space(6)
		lsOutString_LMS += Space(6)
	End If
	
	//Package Weight (Gross)
	If Not isnUll(idsDoPack.GetItemDecimal(llRowPos,'weight_Gross')) Then
		lsOutString += String((idsDoPack.GetItemDecimal(llRowPos,'weight_Gross') * 1000),'000000000000') /* Implied 3 decimals*/
		lsOutString_LMS += String(idsDoPack.GetItemDecimal(llRowPos,'weight_Gross'),'00000000.000') /* Explicit 3 decimals*/
	Else
		lsOutString += '000000000000'
		lsOutString_LMS += '00000000.000'
	End If
	
	//Shipment Weight - 0
	lsOutString += '000000000000'
	lsOutString_LMS += '00000000.000'
	
	//SKU
	lsOutString += idsdoPack.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoPack.GetItemString(llRowPos,'sku')))
	lsOutString_LMS += idsdoPack.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoPack.GetItemString(llRowPos,'sku')))
	
	lsOutstring += Space(6) /*package Code */
	lsOutString_LMS += Space(6) /*package Code */
	

	//TAM 03/09/2006  If UF 9 is not blank then send the value to JVH file only (Not LMS)	
	/* dts 6/14/06 - 	Now setting flag (Y) for CHEP Indicator (User Code 1 for JVH) if there's
							a value in UF9 (CHEP Pallets) or UF11 (half pallets) 
							- UF9 populates User Code 2 and UF11 populates User Code 3 */
	//If Not isnull(idsDoMain.GetItemString(1,'User_Field9')) Then 

	If (idsDoMain.GetItemString(1,'User_Field9') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field9'))) &
		or (idsDoMain.GetItemString(1,'User_Field11') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field11'))) Then
		lsChepIndicator = 'Y'
	else
		lsChepIndicator = 'N'
	end if

	if lsChepIndicator = 'Y' then
		//If idsDoMain.GetItemString(1,'User_Field9') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field9')) Then	//TAM 04/17/2006 Added a check if Zero
		lsOutstring += 'Y              ' /*User Code 1 */
		If idsDoMain.GetItemString(1,'User_Field9') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field9')) then
			// Chep Pallets (full)
			lsOutString += Left(idsDoMain.GetItemString(1,'User_Field9'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field9'))) /*User Code 2 */
		Else 
			lsOutstring += Space(15) /*User Code 2 */
		End If
		If idsDoMain.GetItemString(1,'User_Field11') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field11')) Then
			// Chep Pallets (half)
			lsOutString += Left(idsDoMain.GetItemString(1,'User_Field11'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field11'))) /* User Code 3 */
		Else 
			lsOutstring += Space(15) /*User Code 3 */
		End If
	Else /* no CHEP pallets (full or half) */
		lsOutstring += Space(15) /*User Code 1 */
		lsOutstring += Space(15) /*USer Code 2 */
		lsOutstring += Space(15) /*User Code 3 */
	End if
	
	lsOutString_LMS += Space(15) /*User Code 1 */
	lsOutString_LMS += Space(15) /*User Code 2 */
	lsOutString_LMS += Space(15) /*User Code 3 */
	//dts lsOutstring += Space(15) /*User Code 3 */
	
	
	/* Carrier*/
	If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* Pro Number*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field6')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
	Else
		lsOutString += Space(20)
		lsOutString_LMS += Space(20)
	End If
	
	/* Trailer*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field7')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
	Else
		lsOutString += Space(10)
		lsOutString_LMS += Space(10)
	End If
	
	//Ship DAte
	lsOutString += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	lsOutString_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	
	lsOutstring += Space(4) /*Order Status */
	lsOutString_LMS += Space(4) /*Order Status */
	
	/* Master Shipment (Group Code 1)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field5')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field5'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field5')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field5'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field5')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* End Leg Carrier for Maste Load (Group Code 2)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field3')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field3'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field3')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field3'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field3')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	lsOutString += Space(15) /* Group Code 3*/
	lsOutString_LMS += Space(15) /* Group Code 3*/
	
	lsOutString += Space(15) /* Group Code 4*/
	lsOutString_LMS += Space(15) /* Group Code 4*/
	
	lsOutString += Space(15) /* Group Code 5*/
	lsOutString_LMS += Space(15) /* Group Code 5*/
	
	lsOutString += Space(15) /* Group Code 6*/
	lsOutString_LMS += Space(15) /* Group Code 6*/
	
	lsOutString += Space(15) /* Group Code 7*/
	lsOutString_LMS += Space(15) /* Group Code 7*/
	
	//Lot No - Get from Pick List
	llFindRow = idsDoPick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineITemNo),1,idsdoPick.RowCount())
	If llFindRow > 0 Then
		If idsdoPick.GetItemString(llFindRow,'lot_no') <> '-' Then
			
			lsOutString += idsdoPick.GetItemString(llFindRow,'lot_no') + Space(30 - Len(idsdoPick.GetItemString(llFindRow,'lot_no')))
			
			// 01/08 - PCONKL -  No longer sending Lot No to LMS
			//lsOutString_LMS += idsdoPick.GetItemString(llFindRow,'lot_no') + Space(30 - Len(idsdoPick.GetItemString(llFindRow,'lot_no')))
			lsOutString_LMS += Space(30)
			
		Else
			lsOutString += Space(30)
			lsOutString_LMS += Space(30)
		End If
	Else
		lsOutString += Space(30)
		lsOutString_LMS += Space(30)
	End IF


	// 01/07 - PCONKL - New LMS only fields to support Maquet
	
	// COO - From PIcking
	If llFindRow > 0 Then
		If idsdoPick.GetItemString(llFindRow,'country_of_Origin') <> 'XXX' and idsdoPick.GetItemString(llFindRow,'country_of_Origin') > "" Then
			lsOutString_LMS += Left(idsdoPick.GetItemString(llFindRow,'country_of_Origin'),3) + Space(3 - Len(idsdoPick.GetItemString(llFindRow,'country_of_Origin')))
		Else
			lsOutString_LMS += Space(3)
		End If
	Else
		lsOutString_LMS += Space(3)
	End If
	
	//Ship from ID - This value will come from LMS - should map to the warehouse code
	lsOutString_LMS += Space(9)
	
	//Ship From NAme 1
	If lsWHName > "" Then
		lsOutString_LMS += Left(lsWHName,35) + Space(35 - Len(lsWHName))
	Else
		lsOutString_LMS += Space(35)
	End If
	
	//Ship From Name 2
	lsOutString_LMS += Space(30)
	
	//Ship From Addr 1
	If lsWHaddr1 > "" Then
		lsOutString_LMS += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From Addr 2
	If lsWHaddr2 > "" Then
		lsOutString_LMS += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From City
	If lsWHCity > "" Then
		lsOutString_LMS += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From State
	If lsWHState > "" Then
		lsOutString_LMS += Left(lsWHState,2) + Space(2 - Len(lsWHState))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Ship From Zip
	If lsWHZip > "" Then
		lsOutString_LMS += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship From Country
	If lsWHCountry > "" Then
		lsOutString_LMS += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	
	//Ship TO ID (Cust COde ??)
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Code')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
	Else
		lsOutString_LMS += Space(9)
	End If
	
	//Ship TO Name 1
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Name')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
	Else
		lsOutString_LMS += Space(35)
	End If
	
	//Ship To Name 2
	lsOutString_LMS += space(30)
	
	//Ship TO  Address1
	If Not isnull(idsDoMain.GetItemString(1,'address_1')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'address_1'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_1')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO  Address2
	If Not isnull(idsDoMain.GetItemString(1,'address_2')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'address_2'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_2')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO  City
	If Not isnull(idsDoMain.GetItemString(1,'city')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'city'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'city')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO State
	If Not isnull(idsDoMain.GetItemString(1,'state')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'state'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'State')))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Ship TO Zip
	If Not isnull(idsDoMain.GetItemString(1,'zip')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'zip'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'zip')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship TO Country
	If Not isnull(idsDoMain.GetItemString(1,'country')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'country'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'country')))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Carton_No - From packing - MEA - 7/2008
	
	If Not isnull(idsdoPack.GetItemString(llRowPos,'carton_no')) Then 
		lsOutString_LMS += Left(idsdoPack.GetItemString(llRowPos,'carton_no'),20) + Space(20 - Len(idsdoPack.GetItemString(llRowPos,'carton_no')))
	Else
		lsOutString_LMS += Space(20)
	End If
	
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'SHP' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
	
	
	//Handle the Carton

	//02/07 - PCONKL - Add CTN (Carton) records	

// MA	If lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no') Then Continue /* 1 record per carton*/
	
//MA  	lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no')
	
//	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	// Transaction Type - SH1 for Ready to Ship and SHP for Goods Issue
	lsOutString_LMS += 'CTN' 
	
	lsOutString_LMS += lsPhxwarehouse + Space(6 - Len(lsPhxwarehouse)) /*warehouse*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
		
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	lsOutString_LMS += Left(idsDoPack.GetItemString(llRowPOs,'carton_no'),20) + Space(20 - Len(idsDoPack.GetItemString(llRowPOs,'carton_no'))) /*Container ID*/
	
	//Freight COst
	If idsDOMAin.GEtITEmNumber(1,'Freight_Cost') > 0 Then
		lsOutString_LMS += String(idsDOMAin.GEtITEmNumber(1,'Freight_Cost'),"00000000000.00")
	Else
		lsOutString_LMS += "00000000000.00"
	End If
	
	//Currency Code (USD or EUR???)
	lsOutString_LMS += "USD"
	
	//Height
	If idsDOPack.GEtITEmNumber(llRowPOs,'Height') > 0 Then
		lsOutString_LMS += String(idsDOPack.GEtITEmNumber(llRowPOs,'Height'),"000000000000000.0000")
	Else
		lsOutString_LMS += "000000000000000.0000"
	End If
	
	//Width
	If idsDOPack.GEtITEmNumber(llRowPOs,'Width') > 0 Then
		lsOutString_LMS += String(idsDOPack.GEtITEmNumber(llRowPOs,'Width'),"000000000000000.0000")
	Else
		lsOutString_LMS += "000000000000000.0000"
	End If
	
	//Length
	If idsDOPack.GEtITEmNumber(llRowPOs,'Length') > 0 Then
		lsOutString_LMS += String(idsDOPack.GEtITEmNumber(llRowPOs,'LENGTH'),"000000000000000.0000")
	Else
		lsOutString_LMS += "000000000000000.0000"
	End If
	
	//Dimension UOM - either CM or IN
	If idsDoPack.GetITemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOutString_LMS += "CM "
	Else
		lsOutString_LMS += "IN "
	End If
	
	//Volume
	ldVolume = idsDOPack.GEtITEmNumber(llRowPOs,'Height') * idsDOPack.GEtITEmNumber(llRowPOs,'Width') * idsDOPack.GEtITEmNumber(llRowPOs,'Length')

	//TAM - 11/24/2009 - If 0 send zeros
	If ldVolume <>  0 Then 
		lsOutString_LMS += String(ldVolume,"000000000000000.0000")
	Else 
		lsOutString_LMS += "000000000000000.0000"
	End If
	
	//Volume UOM - either CCM or CIN
	If idsDoPack.GetITemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOutString_LMS += "CCM"
	Else
		lsOutString_LMS += "CIN"
	End If
	
	//Gross Weight
	lsOutString_LMS += String(idsDOPack.GEtITEmNumber(llRowPOs,'Weight_Gross'),"000000000000000.0000")
	
	//Net Weight
	ldNetWeight = idsDOPack.GEtITEmNumber(llRowPOs,'Weight_Gross') * idsDOPack.GEtITEmNumber(llRowPOs,'Quantity')
	lsOutString_LMS += String(ldNetWeight,"000000000000000.0000")
	
	//tare Weight - 0
	lsOutString_LMS += "000000000000000.0000"
	
	//Weight UOM - either KGS or LBS
	If idsDoPack.GetITemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOutString_LMS += "KGS"
	Else
		lsOutString_LMS += "LBS"
	End If
	
	//Tracking Numnber
	If idsDoPack.GetItemString(llRowPOs,'shipper_tracking_id') > "" Then
		lsOutString_LMS += Left(idsDoPack.GetItemString(llRowPOs,'shipper_tracking_id'),30) + Space(30 - Len(idsDoPack.GetItemString(llRowPOs,'shipper_tracking_id'))) 
	Else
		lsOutString_LMS += Space(30)
	End If
		
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'SHP' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
		
	
	
	//*****
	// 05/08 - PCONKL - We are now creating a 945 to LMS for Transfers (Ord Type = Z or T) but we don't want to send them to PHX
	
	If idsDoMain.GetITemString(1,'ord_type') = 'Z' or idsDoMain.GetITemString(1,'ord_type') = 'T' Then Continue
	
	//*****
	
	
	
	//Add Phoenix only fields
	
	//Package Type
	If Not isnull(idsdoPack.GetItemString(llRowPos,'carton_type')) Then
		lsOutString += Left(idsdoPack.GetItemString(llRowPos,'carton_type'),10) + Space(10 - Len(idsdoPack.GetItemString(llRowPos,'carton_type')))
	Else
		lsOutString += "CARTON    "
	End If
	
	//Carton Number - UCCS Label - need to add UCCS info to packing carton number
	If Not isnull(idsdoPack.GetItemString(llRowPos,'carton_no')) Then
		
		//Add UCCS Info
		lsUCCCarton = f_phx_brnds_create_ucc(idsdoPack.GetItemString(llRowPos,'carton_no')) /* 12/04 - PCONKL */
		
		//12/04 - PCONKL - If label For ZEL, (00) 00xxxxx was replaced with (00) 10xxxxxxx - Need to replace here to
		If idsDoMain.GetItemString(1,'User_Field10') = 'ZEL' Then
			lsUCCCarton = Replace(lsUCCCarton,3,1,'1')
		End If
		
		If isNull(lsUccCarton) Then lsUCCCarton = String(Long(idsdoPack.GetItemString(llRowPos,'carton_no')),'00000000000000000000')
		
		lsOutString += Left(lsUccCarton,20) + Space(20 - Len(lsUccCarton))
		
	Else
		
		lsOutString += Space(20)
		
	End If
	
	// pvh - 11/03/06 - Add Delivery Appitment Number
	If Not isnull( idsDoMain.object.user_field8[ 1 ] ) Then 
		lsOutString += Trim(  idsDoMain.object.user_field8[ 1 ] )
	Else
		lsOutString += Space(30)
	End If

	// eom
	
	//Write record for Phoenix 
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq2)) /* will be split into separate file in next step*/
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SISH945P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SISH945P.A' + String(ldBatchSeq2,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
	End If
	
next /*next output record */

// 06/04 - PCONKL - We also want to include cancel records for any Order Details that did not ship (detail.Alloc_Qty = 0)
idsDODEtail.SetFilter("alloc_Qty = 0")
idsDoDetail.Filter()

llRowCount = idsdoDetail.RowCount()
For llRowPos = 1 to llRowCount /*Each 0 shipped Detail row */
		
	lsSKU = idsdoDetail.GetItemString(llRowPos,'SKU')
	llLineITemNo = idsdoDetail.GetItemNumber(llRowPos,'Line_Item_No')
	
		
		
	llRecSeq ++
	lsOutString = String(llRecSeq,'000000') /* Record Number*/
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	lsOutString += 'SHP' /*transaction Code */
	lsOutString_LMS += 'LCN' /*CANCEL - transaction Code */
	
	lsOutString += lsPHXWarehouse + Space(6 - Len(lsPHXWarehouse)) /*warehouse*/
	lsOutString_LMS += lsPHXWarehouse + Space(6 - Len(lsPHXWarehouse)) /*warehouse*/
	
	lsOutString += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	
	lsOutString += String(ldtToday,'HHMMSS') /* Transaction Time*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	lsOutString_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	
	/*Order Type */
	// pvh - 08/23/06 - Order Type 'Z' or 'T' 
	// moved the logic to set this outside the loop
	lsOutString += ordType
	lsOutString_LMS += ordType
//	
//	If Not isnull(idsDoMain.GetItemString(1,'User_Field2')) Then 
//		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field2'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field2')))
//		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field2'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field2')))
//	Else
//		lsOutString += Space(4)
//		lsOutString_LMS += Space(4)
//	End If
//
	
	/*Line Item Number */
	If Not isnull(idsDoDetail.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
		lsOutString += String(idsDoDetail.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
		lsOutString_LMS += String(idsDoDetail.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
	Else
		lsOutString += '000000'
		lsOutString_LMS += '000000'
	End If
	
	lsOutString += Space(1) /*Line Item Complete*/
	lsOutString_LMS += Space(1) /*Line Item Complete*/
	
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* AWB BOL */
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
	Else
		lsOutString += Space(10)
		lsOutString_LMS += Space(10)
	End If
	
	//Original Qty 
	lsOutString += String((idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty') * 100),'000000000000') /* Implied 2 decimal place*/
	lsOutString_LMS += String(idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
	
	
	//Pack Qty - 0 (Not shipped)
	lsOutString += '000000000000'
	lsOutString_LMS += '000000000000'
	
	//UOM
	If Not isnull(idsdoDetail.GetItemstring(llRowPos,'uom')) Then
		lsOutString += idsdoDetail.GetItemstring(llRowPos,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llRowPos,'uom')))
		lsOutString_LMS += idsdoDetail.GetItemstring(llRowPos,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llRowPos,'uom')))
	Else
		lsOutString += Space(6)
		lsOutString_LMS += Space(6)
	End If
	
	//Package Weight (Gross) - 0 for 0 shipped
	lsOutString += '000000000000'
	lsOutString_LMS += '00000000.000'
		
	//Shipment Weight - 0
	lsOutString += '000000000000'
	lsOutString_LMS += '00000000.000'
	
	//SKU
	lsOutString += idsdoDetail.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoDetail.GetItemString(llRowPos,'sku')))
	lsOutString_LMS += idsdoDetail.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoDetail.GetItemString(llRowPos,'sku')))
	
	lsOutstring += Space(6) /*package Code */
	lsOutString_LMS += Space(6) /*package Code */
	
	lsOutstring += Space(15) /*User Code 1 */
	lsOutString_LMS += Space(15) /*User Code 1 */
	
	lsOutstring += Space(15) /*USer Code 2 */
	lsOutString_LMS += Space(15) /*USer Code 2 */
	
	lsOutstring += Space(15) /*User Code 3 */
	lsOutString_LMS+= Space(15) /*User Code 3 */
	
	/* Carrier*/
	If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* Pro Number*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field6')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
	Else
		lsOutString += Space(20)
		lsOutString_LMS += Space(20)
	End If
	
	/* Trailer*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field7')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
	Else
		lsOutString += Space(10)
		lsOutString_LMS += Space(10)
	End If
	
	//Ship DAte
	lsOutString += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	lsOutString_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	
	lsOutstring += Space(4) /*Order Status */
	lsOutString_LMS += Space(4) /*Order Status */
	
	/* Master Shipment (Group Code 1)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field5')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field5'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field5')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field5'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field5')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	/* End Leg Carrier for Maste Load (Group Code 2)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field3')) Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'User_Field3'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field3')))
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field3'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field3')))
	Else
		lsOutString += Space(15)
		lsOutString_LMS += Space(15)
	End If
	
	lsOutString += Space(15) /* Group Code 3*/
	lsOutString_LMS += Space(15) /* Group Code 3*/
	
	lsOutString += Space(15) /* Group Code 4*/
	lsOutString_LMS += Space(15) /* Group Code 4*/
	
	lsOutString += Space(15) /* Group Code 5*/
	lsOutString_LMS += Space(15) /* Group Code 5*/
	
	lsOutString += Space(15) /* Group Code 6*/
	lsOutString_LMS += Space(15) /* Group Code 6*/
	
	lsOutString += Space(15) /* Group Code 7*/
	lsOutString_LMS += Space(15) /* Group Code 7*/
	
	//Lot No - blanks
	lsOutString += Space(30)
	lsOutString_LMS += Space(30)

		
	// 01/07 - PCONKL - New LMS only fields to support Maquet (LMS Express)
	
	// COO - From PIcking
	lsOutString_LMS += Space(3)
		
	//Ship from ID - This value will come from LMS - should map to the warehouse code
	lsOutString_LMS += Space(9)
	
	//Ship From NAme 1
	If lsWHName > "" Then
		lsOutString_LMS += Left(lsWHName,35) + Space(35 - Len(lsWHName))
	Else
		lsOutString_LMS += Space(35)
	End If
	
	//Ship From Name 2
	lsOutString_LMS += Space(30)
	
	//Ship From Addr 1
	If lsWHaddr1 > "" Then
		lsOutString_LMS += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From Addr 2
	If lsWHaddr2 > "" Then
		lsOutString_LMS += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From City
	If lsWHCity > "" Then
		lsOutString_LMS += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From State
	If lsWHState > "" Then
		lsOutString_LMS += Left(lsWHState,2) + Space(2 - Len(lsWHState))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Ship From Zip
	If lsWHZip > "" Then
		lsOutString_LMS += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship From Country
	If lsWHCountry > "" Then
		lsOutString_LMS += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	
	//Ship TO ID (Cust COde ??)
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Code')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
	Else
		lsOutString_LMS += Space(9)
	End If
	
	//Ship TO Name 1
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Name')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
	Else
		lsOutString_LMS += Space(35)
	End If
	
	//Ship To Name 2
	lsOutString_LMS += space(30)
	
	//Ship TO  Address1
	If Not isnull(idsDoMain.GetItemString(1,'address_1')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'address_1'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_1')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO  Address2
	If Not isnull(idsDoMain.GetItemString(1,'address_2')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'address_2'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_2')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO  City
	If Not isnull(idsDoMain.GetItemString(1,'city')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'city'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'city')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship TO State
	If Not isnull(idsDoMain.GetItemString(1,'state')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'state'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'State')))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Ship TO Zip
	If Not isnull(idsDoMain.GetItemString(1,'zip')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'zip'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'zip')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship TO Country
	If Not isnull(idsDoMain.GetItemString(1,'country')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'country'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'country')))
	Else
		lsOutString_LMS += Space(2)
	End If

	//Carton_No - From packing - MEA - 7/2008
	
	llFindRow = idsdoPack.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineItemNo), 1, idsdoPack.RowCount())

	IF llFindRow > 0 THEN
		
		If Not isnull(idsdoPack.GetItemString(llFindRow,'carton_no')) Then 
			lsOutString_LMS += Left(idsdoPack.GetItemString(llFindRow,'carton_no'),20) + Space(20 - Len(idsdoPack.GetItemString(llFindRow,'carton_no')))
		Else
			lsOutString_LMS += Space(20)
		End If
		
	Else
	
		lsOutString_LMS += Space(20)

	End If
	
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'SHP' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
	
	
	//*****
	// 05/08 - PCONKL - We are now creating a 945 to LMS for Transfers (Ord Type = Z or T) but we don't want to send them to PHX
	
	If idsDoMain.GetITemString(1,'ord_type') = 'Z' or idsDoMain.GetITemString(1,'ord_type') = 'T' Then Continue
	
	//*****
	
	
	
	//Add Phoenix only fields - blanks
	
	//Package Type
	lsOutString += Space(10)
	
	//Carton Number - blanks
	lsOutString += Space(20)
			
	//Write record for Phoenix 
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq2)) /* will be split into separate file in next step*/
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is SISH945P + Axxxxxxxxx being unique member for the AS400
	lsFileName = 'SISH945P.A' + String(ldBatchSeq2,'000000000')
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//06/04 - PCONKL - If Canada warehouse, we need to send to another FTP partition.
 	If lsWarehouse= 'PHX-MISS'  or lsWarehouse = 'PHX-EDMONT' Then
  		idsOut.SetItem(llNewRow,'dest_cd', 'CAN') /*routed to Canada folder*/
 	End If
	
Next /* 0 Shipped Detail Row*/

idsDODEtail.SetFilter("")
idsDoDetail.Filter()


///Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

Return 0
end function

public function integer uf_lms_itemmaster ();
//Create an Item master update file for LMS - all items that have changed since last run

String	lsLogOut, sql_syntax, Errors, lsOutString_LMS, lsSKU
DataStore	ldsItem
Long	llRowPos, llRowCount, llNewRow, llRecSeq
Dec	ldBatchSeq, ldQty
Int	liRC
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('PHXBRANDS','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create the Item Datastore...
ldsItem = Create Datastore
sql_syntax = "SELECT SKU, Supp_code, User_field4, User_field5, Description, Freight_Class, Shelf_Life, uom_1, uom_2, uom_3, uom_4, qty_2, qty_3, qty_4,  weight_1, weight_2, weight_3, weight_4, " 
sql_syntax += " Length_1, length_2, length_3, length_4, Width_1, width_2, width_3, width_4, height_1, height_2, height_3, height_4 "
sql_syntax += " From Item_Master "
sql_syntax += " Where Project_ID = 'PHXBRANDS' and Interface_Upd_Req_Ind = 'Y';"
ldsItem.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for PHXBRANDS Item Master extract (SIMS->LMS.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsItem.SetTransObject(SQLCA)


lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIMS -> LMS Item Master update for PHXBRANDS... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve all of the ITem Master Records for Project
lLRowCount = ldsITem.Retrieve()

//Update to pending so we can reset at end when sucessfully written
Update Item_Master
Set Interface_Upd_Req_Ind = 'X'
Where Project_ID = 'PHXBRANDS' and Interface_Upd_Req_Ind = 'Y';

Commit;

lsLogOut = "    " + String(llRowCount) + " Item Master records were retrieved for processing... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lLRecSeq = 0

For llRowPOs = 1 to lLRowCount
	
	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	lsOutString_LMS += "PM" /*Record Type */
	lsOutString_LMS += "A" /*Transaction Type*/
	lsOutString_LMS += "26    " /*Warehouse - hardcoded for now as is not relevent to Item Maste*/ /* Hard-coded to 6 */
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	//If we received it with a supplier, send it back with a supplier (assuming that if we defaulted it, the supplier will be 'PHXBRANDS' or existing supplier is numeric
	// always send # as seperator even if not present
	
//	If ldsItem.GetItemString(lLRowPos,'supp_code') = 'PHX' or isnumber(ldsItem.GetItemString(lLRowPos,'supp_code')) Then
//	If ldsItem.GetItemString(lLRowPos,'supp_code') = 'PHX'  Then
//		lsSKU = "#" + ldsItem.GetItemString(lLRowPos,'Sku')

		lsSKU =  ldsItem.GetItemString(lLRowPos,'Sku')


//	Else
//		lsSKU = ldsItem.GetItemString(lLRowPos,'supp_code') + "#" + ldsItem.GetItemString(lLRowPos,'Sku')
//	End If
	
	lsOutString_LMS += Left(lsSKU,20) + Space(20 - len(lsSKU))
	
	//Package Code (UF4)
	If ldsItem.GetItemString(lLRowPos,'User_field4') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'user_Field4'),6) + Space(6 - len(ldsItem.GetItemString(lLRowPos,'User_field4')))
	Else
		lsOutString_LMS += Space(6)
	End If
	
	//Description
	If ldsItem.GetItemString(lLRowPos,'Description') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'Description'),30) + Space(30 - len(ldsItem.GetItemString(lLRowPos,'Description')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Product Class (UF5)
	If ldsItem.GetItemString(lLRowPos,'User_field5') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'user_Field5'),6) + Space(6 - len(ldsItem.GetItemString(lLRowPos,'User_field5')))
	Else
		lsOutString_LMS += Space(6)
	End If
	
	//Freight Class - must be numeric for LMS
	If ldsItem.GetItemString(lLRowPos,'freight_class') > "" and isnumber(ldsItem.GetItemString(lLRowPos,'freight_class')) Then
		lsOutString_LMS +=  String(Dec(ldsItem.GetItemString(lLRowPos,'freight_class')),'00000000.0')
	Else
		lsOutString_LMS += "00000000.0"
	End If
	
	lsOutString_LMS += "00000000.0000" /*Maximum Qty*/
	lsOutString_LMS += "00000000.0000" /*Minimum Qty*/
	
	//Shelf Life
	If ldsItem.GetITemNumber(llRowPos, 'shelf_life') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'shelf_life'),'00000000')
	Else
		lsOutString_LMS += "00000000"
	end If
		
	//UOM1
	If ldsItem.GetItemString(lLRowPos,'uom_1') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_1'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_1')))
	Else
		lsOutString_LMS += "EA "
	End If
	
	//UOM2
	If ldsItem.GetItemString(lLRowPos,'uom_2') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_2'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_2')))
	Else
		lsOutString_LMS += "   "
	End If
	
	//UOM3
	If ldsItem.GetItemString(lLRowPos,'uom_3') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_3'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_3')))
	Else
		lsOutString_LMS += "   "
	End If
	
	//UOM4
	If ldsItem.GetItemString(lLRowPos,'uom_4') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_4'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_4')))
	Else
		lsOutString_LMS += "   "
	End If
	
	
	
	//UOM Qty1 - Conversion facfor from UOM2 -> UOM1 (QTY1 is always 1)
	If ldsItem.GetITemNumber(llRowPos, 'qty_2') > 0  Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'qty_2'),"0000000.00000000")
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//UOm Qty 2 - Conversion facfor from UOM3 -> UOM2
	If ldsItem.GetITemNumber(llRowPos, 'qty_3') > 0 and ldsItem.GetITemNumber(llRowPos, 'qty_2') > 0 Then
		
		ldQty = ldsItem.GetITemNumber(llRowPos, 'qty_3') / ldsItem.GetITemNumber(llRowPos, 'qty_2')
		lsOutString_LMS += String(ldQty,"0000000.00000000")
		
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//UOm Qty 3 Conversion factor from UOM4 -> 3
	If ldsItem.GetITemNumber(llRowPos, 'qty_4') > 0 and ldsItem.GetITemNumber(llRowPos, 'qty_3') > 0 Then
		
		ldQty = ldsItem.GetITemNumber(llRowPos, 'qty_4') / ldsItem.GetITemNumber(llRowPos, 'qty_3')
		lsOutString_LMS += String(ldQty,"0000000.00000000")
		
	Else
		lsOutString_LMS += "0000000.00000000"
	End If
	
	//Weight 1
	If ldsItem.GetITemNumber(llRowPos, 'weight_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 2
	If ldsItem.GetITemNumber(llRowPos, 'weight_2') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_2'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 3
	If ldsItem.GetITemNumber(llRowPos, 'weight_3') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_3'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 4
	If ldsItem.GetITemNumber(llRowPos, 'weight_4') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_4'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 1
	If ldsItem.GetITemNumber(llRowPos, 'height_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 2
	If ldsItem.GetITemNumber(llRowPos, 'height_2') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_2'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 3
	If ldsItem.GetITemNumber(llRowPos, 'height_3') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_3'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 4
	If ldsItem.GetITemNumber(llRowPos, 'height_4') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_4'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	
	//Width 1
	If ldsItem.GetITemNumber(llRowPos, 'Width_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 2
	If ldsItem.GetITemNumber(llRowPos, 'Width_2') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_2'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 3
	If ldsItem.GetITemNumber(llRowPos, 'Width_3') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_3'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 4
	If ldsItem.GetITemNumber(llRowPos, 'Width_4') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_4'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	
	//Length 1
	If ldsItem.GetITemNumber(llRowPos, 'length_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 2
	If ldsItem.GetITemNumber(llRowPos, 'length_2') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_2'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 3
	If ldsItem.GetITemNumber(llRowPos, 'length_3') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_3'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 4
	If ldsItem.GetITemNumber(llRowPos, 'length_4') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_4'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'PHXBRANDS')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'N832' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'ICC') /*routed to LMS folder*/
		
Next /* Item Master Record*/

//Write the Outbound File 
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHXBRANDS')

//Reset update status on rows processed
Update Item_Master
Set Interface_Upd_Req_Ind = 'N'
Where Project_ID = 'PHXBRANDS' and Interface_Upd_Req_Ind = 'X';

Commit;


Return 0
end function

on u_nvo_edi_confirmations_phoenix.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_phoenix.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

