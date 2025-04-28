$PBExportHeader$u_nvo_edi_confirmations_solectron.sru
$PBExportComments$Process outbound edi confirmation transactions for Solectron
forward
global type u_nvo_edi_confirmations_solectron from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_solectron from nonvisualobject
end type
global u_nvo_edi_confirmations_solectron u_nvo_edi_confirmations_solectron

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for SELECTRON for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llCartonCount
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSupplier,	lsInvType,	&
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


//We need the Carton Count from Packing
Select Count(Distinct carton_no) Into :llCartonCount
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
	lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llRowPos,'inventory_type')) + "'"
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
// TAM - There warehouse code is EE for Eersel/Selectron warehouse
//		idsGR.SetItem(llNewRow,'warehouse',idsDoMain.GetItemString(1,'wh_code'))
		idsGR.SetItem(llNewRow,'warehouse','EE')
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
	lsOutString += Left(idsGR.GetItemString(llRowPos,'warehouse'),10)  + '|'
	lsOutString += Left(idsGR.GetItemString(llRowPos,'po_number'),10) + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'number_packages')) + '|'
	
	If Not isnull(idsGR.GetItemString(llRowPos,'Carrier')) Then
		lsOutString += left(idsGR.GetItemString(llRowPos,'carrier'),35) + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) 
	

	idsOut.SetItem(llNewRow,'Project_id', 'SOLECTRON')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'SOLECTRON')



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for K&N Filters for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName

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
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

//w_main.SetMicrohelp('Creating Goods Receipt confirmation for Solectron...')

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
// TAM - There warehouse code is EE for Eersel/Selectron warehouse
//		idsGR.SetItem(llNewRow,'warehouse',idsROMain.GetItemString(1,'wh_code'))
		idsGR.SetItem(llNewRow,'warehouse','EE')
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetITemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
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
	lsOutString += idsGR.GetItemString(llRowPos,'warehouse') + '|' 
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_number') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number'))
	
	idsOut.SetItem(llNewRow,'Project_id', 'SOLECTRON')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
next /*next output record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW

gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'SOLECTRON')

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

on u_nvo_edi_confirmations_solectron.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_solectron.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

