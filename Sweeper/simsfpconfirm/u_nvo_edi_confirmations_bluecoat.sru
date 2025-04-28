HA$PBExportHeader$u_nvo_edi_confirmations_bluecoat.sru
$PBExportComments$Process outbound edi confirmation transactions for BlueCoat
forward
global type u_nvo_edi_confirmations_bluecoat from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_bluecoat from nonvisualobject
end type
global u_nvo_edi_confirmations_bluecoat u_nvo_edi_confirmations_bluecoat

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for SELECTRON for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llCartonCount
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSupplier,	lsInvType, lsTrackingNo, lsTemp,	&
				lsInvoice, lsLogOut, lsFileName

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

If Not isvalid(idsDoPick) Then
	idsDoPick = Create Datastore
	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

//Retreive Delivery Master and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoPick.Retrieve(asDoNo)

//We need the Carton Count from Packing and a single Tracking ID from packing
Select Count(Distinct carton_no), MAX(Shipper_Tracking_ID) Into :llCartonCount, :lsTrackingNo 
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//For each sku/line Item/inventory type in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

llRowCOunt = idsDOPick.RowCount()

For llRowPos = 1 to llRowCount
	
	//Dont send a record for non pickable Items
	If idsDOPick.GetItemString(llRowPos,'SKU_Pickable_Ind') = 'N' Then Continue
	
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) 
	lsFind += "' and po_item_number = " + String(idsDOPick.GetItemNumber(llRowPos,'Line_Item_no')) 
	lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llRowPos,'inventory_type'))
	lsFind += " and upper(serial_number) = '" + upper(idsDOPick.GetItemString(llRowPos,'Serial_No')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsDoMain.GetItemString(1,'invoice_no'))
		idsGR.SetItem(llNewRow,'carrier',idsDoMain.GetItemString(1,'carrier'))
		idsGR.SetItem(llNewRow,'number_packages',llCartonCount)
		idsGR.SetItem(llNewRow,'complete_date',idsDoMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llRowPos,'SKU'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'warehouse',idsDoMain.GetItemString(1,'wh_code'))
		If llRowPos = 1 then
			idsGR.SetItem(llNewRow,'freight_cost',idsDoMain.GetItemNumber(1,'freight_cost'))
		Else 
			idsGR.SetItem(llNewRow,'freight_cost',0)
		End If
		
		idsGR.SetItem(llNewRow,'serial_number',idsDoPick.GetItemString(llRowPos,'Serial_No'))
		idsGR.SetItem(llNewRow,'shipper_tracking_id',lsTrackingNo)
		
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
//	lsOutString += Left(idsGR.GetItemString(llRowPos,'warehouse'),10)  + '|'
	lsOutString += '|'
	lsOutString += Left(idsGR.GetItemString(llRowPos,'po_number'),10) + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd hh:mm:ss') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'number_packages')) + '|'
	
	If Not isnull(idsGR.GetItemString(llRowPos,'Carrier')) Then
		lsOutString += left(idsGR.GetItemString(llRowPos,'carrier'),40) + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|' 

	lsTemp = string(idsGR.GetItemNumber(llRowPos,'freight_cost'))
	If lsTemp = '0' Then
		lsOutString +='|'
	Else
		lsOutString += string(idsGR.GetItemNumber(llRowPos,'freight_cost')) + '|' 
	End IF

	lsTemp = idsGR.GetItemString(llRowPos,'serial_number')
	If lsTemp = '-' or isnull(lsTemp) Then
		lsOutString +='|'
	Else
		lsOutString += idsGR.GetItemString(llRowPos,'serial_number') + '|'
	End IF

	If not isnull(idsGR.GetItemString(llRowPos,'shipper_tracking_id')) then 
		lsOutString += string(idsGR.GetItemString(llRowPos,'shipper_tracking_id'))
	End If

	idsOut.SetItem(llNewRow,'Project_id', 'BLUECOAT')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'BC_945_' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'BLUECOAT')



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for K&N Filters for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lstemp

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

idsroPutaway.Retrieve(asRONO)

//For each sku/inventory type in Putaway, write an output record - 

w_main.SetMicrohelp('Creating Goods Receipt confirmation for BlueCoat...')

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + " and upper(po_number) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Po_No')) 
	lsFind += " and upper(serial_number) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Serial_No')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
//		idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		idsGR.SetItem(llNewRow,'po_number',idsROPutaway.GetItemString(llRowPos,'Po_no'))
// TAM - There warehouse code is EE for Eersel/Selectron warehouse
		idsGR.SetItem(llNewRow,'warehouse',idsROMain.GetItemString(1,'wh_code'))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'serial_number',idsROPutaway.GetItemString(llRowPos,'Serial_No'))
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
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'GR|' /*rec type = goods receipt*/
//	lsOutString += idsGR.GetItemString(llRowPos,'warehouse') + '|' 
	lsOutString += '|' //Not Sending Warehouse 
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_number') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) +'|'
	lsTemp = idsGR.GetItemString(llRowPos,'serial_number')
	If lsTemp = '-' Then
		lsOutString +='|'
	Else
		lsOutString += idsGR.GetItemString(llRowPos,'serial_number')
	End IF

	
	idsOut.SetItem(llNewRow,'Project_id', 'BLUECOAT')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'BC_944_' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW

gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'BLUECOAT')

Return 0
end function

on u_nvo_edi_confirmations_bluecoat.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_bluecoat.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

