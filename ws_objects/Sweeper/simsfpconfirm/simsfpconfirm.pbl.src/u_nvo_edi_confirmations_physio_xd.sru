$PBExportHeader$u_nvo_edi_confirmations_physio_xd.sru
forward
global type u_nvo_edi_confirmations_physio_xd from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_physio_xd from nonvisualobject
end type
global u_nvo_edi_confirmations_physio_xd u_nvo_edi_confirmations_physio_xd

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	

end variables

forward prototypes
public function integer uf_rt (string asproject, string asrono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_rs (string asproject, string asdono, long altransid)
end prototypes

public function integer uf_rt (string asproject, string asrono);If Not isvalid(iu_nvo_marc_transactions) Then	
		iu_nvo_marc_transactions = Create u_nvo_marc_transactions
	End If
	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)

Return 0
end function

public function integer uf_gr (string asproject, string asrono);
//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
//	If Not isvalid(iu_nvo_marc_transactions) Then	
//		iu_nvo_marc_transactions = Create u_nvo_marc_transactions
//	End If
//	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)
//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long aitransid);//Prepare a Marc GT Stock Adjustment Transaction for AMS-USER for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llNetQty, llRowCount, llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOldInvType,	lsNewInvType,		&
				lsLogOut, lsWarehouse, &
				lsoldcoo, lsnewcoo, lsoldPo_No2, lsnewPo_No2, lsNewOwnerCD, lsTransParm

DateTime	ldtTransTime

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
// 03/05 - For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment

Select Trans_create_date, Trans_parm into :ldtTranstime, :lsTransParm
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

llOwnerID = idsadjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsadjustment.GetITemNumber(1,"old_owner")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
lloldQty = idsadjustment.GetITemNumber(1,"old_quantity")

lsOldCOO = idsadjustment.GetITemString(1,"old_country_of_origin") /*original value before update!*/
lsNewCOO = idsadjustment.GetITemString(1,"country_of_origin")

lsOldPO_NO2 = idsadjustment.GetITemString(1,"old_Po_No2") /*original value before update!*/
lsNewPO_NO2 = idsadjustment.GetITemString(1,"Po_No2")

lsNewOwnerCd = idsadjustment.GetITemString(1,"new_owner_cd")
		
//TAMCCLANAHAN 
//Begin Process Mark GT interface

// Call MARC GT Interface on Change in Inventory Type, Original Owner, Qty, Bonded, COO --- To Be Coded Later 
lsWarehouse = idsadjustment.GetITemString(1,'Wh_Code')


If (lsOldInvType <> lsNewInvType) or (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (lsOldPo_no2 <> lsNewPo_No2) or (lsOldCoo <> lsNewCoo) Then
		If Not isvalid(iu_nvo_marc_transactions) Then	
			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
		End If
		iu_nvo_marc_transactions.uf_corrections(asProject,alAdjustID)
End If
//End Marc GT Process


Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Jxlim 08/07/2012 CR12 interface for PHYSIO-XD
//Prepare a Goods Issue Transaction for PHYSIO-XD for the order that was just confirmed
//Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llCartonCount
//				
//String		lsFind, lsOutString,	lsMessage, lsSku,	lsSupplier,	lsInvType, lsTrackingNo, lsTemp,	&
//				lsInvoice, lsLogOut, lsFileName
//
//DEcimal		ldBatchSeq
//Integer		liRC
//
//If Not isvalid(idsOut) Then
//	idsOut = Create Datastore
//	idsOut.Dataobject = 'd_edi_generic_out'
//	lirc = idsOut.SetTransobject(sqlca)
//End If
//
//If Not isvalid(idsGR) Then
//	idsGR = Create Datastore
//	idsGR.Dataobject = 'd_gr_layout'
//End If
//
//If Not isvalid(idsDOMain) Then
//	idsDOMain = Create Datastore
//	idsDOMain.Dataobject = 'd_do_master'
//	idsDOMain.SetTransObject(SQLCA)
//End If
//
//If Not isvalid(idsDoPick) Then
//	idsDoPick = Create Datastore
//	idsDoPick.Dataobject = 'd_do_Picking'
//	idsDoPick.SetTransObject(SQLCA)
//End If
//
//idsOut.Reset()
//idsGR.Reset()
//
////Retreive Delivery Master and Picking records for this DONO
//If idsDOMain.Retrieve(asDoNo) <> 1 Then
//	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
//	FileWrite(gilogFileNo,lsLogOut)
//	Return -1
//End If
//
//idsDoPick.Retrieve(asDoNo)
//
////We need the Carton Count from Packing and a single Tracking ID from packing
//Select Count(Distinct carton_no), MAX(Shipper_Tracking_ID) Into :llCartonCount, :lsTrackingNo 
//From Delivery_Packing
//Where do_no = :asDoNo;
//
//If isnull(llCartonCount) then llCartonCount = 0
//
////For each sku/line Item/inventory type in Picking, write an output record - 
////multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)
//
//lsLogOut = "        Creating GI For DONO: " + asDONO
//FileWrite(gilogFileNo,lsLogOut)
//
//llRowCOunt = idsDOPick.RowCount()
//
//For llRowPos = 1 to llRowCount
//	
//	//Dont send a record for non pickable Items
//	If idsDOPick.GetItemString(llRowPos,'SKU_Pickable_Ind') = 'N' Then Continue
//	
//	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) 
//	lsFind += "' and po_item_number = " + String(idsDOPick.GetItemNumber(llRowPos,'Line_Item_no')) 
//	lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llRowPos,'inventory_type'))
//	lsFind += " and upper(serial_number) = '" + upper(idsDOPick.GetItemString(llRowPos,'Serial_No')) + "'"
//	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
//	If llFindRow > 0 Then /*row already exists, add the qty*/
//		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
//	Else /*not found, add a new record*/
//		llNewRow = idsGR.InsertRow(0)
//		idsGR.SetItem(llNewRow,'po_number',idsDoMain.GetItemString(1,'invoice_no'))
//		idsGR.SetItem(llNewRow,'carrier',idsDoMain.GetItemString(1,'carrier'))
//		idsGR.SetItem(llNewRow,'number_packages',llCartonCount)
//		idsGR.SetItem(llNewRow,'complete_date',idsDoMain.GetITemDateTime(1,'complete_date'))
//		idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llRowPos,'SKU'))
//		idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llRowPos,'inventory_type'))
//		idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llRowPos,'quantity'))
//		idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llRowPos,'line_item_no'))
//		idsGR.SetItem(llNewRow,'warehouse',idsDoMain.GetItemString(1,'wh_code'))
//		If llRowPos = 1 then
//			idsGR.SetItem(llNewRow,'freight_cost',idsDoMain.GetItemNumber(1,'freight_cost'))
//		Else 
//			idsGR.SetItem(llNewRow,'freight_cost',0)
//		End If
//		
//		idsGR.SetItem(llNewRow,'serial_number',idsDoPick.GetItemString(llRowPos,'Serial_No'))
//		idsGR.SetItem(llNewRow,'shipper_tracking_id',lsTrackingNo)
//		
//	End If
//	
//Next /* Next Pick record */
//
//
////Get the Next Batch Seq Nbr - Used for all writing to generic tables
//ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
//If ldBatchSeq <= 0 Then
//	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to K&N!'"
//	FileWrite(gilogFileNo,lsLogOut)
//	Return -1
//End If
//
////Write the rows to the generic output table - delimited by '|'
//llRowCount = idsGR.RowCount()
//For llRowPos = 1 to llRowCOunt
//	
//	llNewRow = idsOut.insertRow(0)
//	lsOutString = 'GI|' /*rec type = goods Issue*/
////	lsOutString += Left(idsGR.GetItemString(llRowPos,'warehouse'),10)  + '|'
//	lsOutString += '|'
//	lsOutString += Left(idsGR.GetItemString(llRowPos,'po_number'),10) + '|'
//	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyy-mm-dd hh:mm:ss') + '|'
//	lsOutString += String(idsGR.GetItemNumber(llRowPos,'number_packages')) + '|'
//	
//	If Not isnull(idsGR.GetItemString(llRowPos,'Carrier')) Then
//		lsOutString += left(idsGR.GetItemString(llRowPos,'carrier'),40) + '|'
//	Else
//		lsOutString +='|'
//	End IF
//	
//	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
//	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
//	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|' 
//
//	lsTemp = string(idsGR.GetItemNumber(llRowPos,'freight_cost'))
//	If lsTemp = '0' Then
//		lsOutString +='|'
//	Else
//		lsOutString += string(idsGR.GetItemNumber(llRowPos,'freight_cost')) + '|' 
//	End IF
//
//	lsTemp = idsGR.GetItemString(llRowPos,'serial_number')
//	If lsTemp = '-' or isnull(lsTemp) Then
//		lsOutString +='|'
//	Else
//		lsOutString += idsGR.GetItemString(llRowPos,'serial_number') + '|'
//	End IF
//
//	If not isnull(idsGR.GetItemString(llRowPos,'shipper_tracking_id')) then 
//		lsOutString += string(idsGR.GetItemString(llRowPos,'shipper_tracking_id'))
//	End If
//
//	idsOut.SetItem(llNewRow,'Project_id', asProject)
//	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
//	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
//	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.DAT'
//	idsOut.SetItem(llNewRow,'file_name', lsFileName)
//	
//
//next /*next output record */
//
////Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
//gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asProject)
//
//
//
Return 0
end function

public function integer uf_rs (string asproject, string asdono, long altransid);//Jxlim 08/07/2012 Added RS interface for PHYSIO-XD
//Prepare a Ready to Ship Transaction for PHYSIO-XD for the order that was just set to Ready to Ship


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
Where Trans_id = :alTransID;

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
If upper(idsDoMain.getItemString(1, 'wh_code')) = 'PHYSIO-AMS' Then
	lsWarehouse = 'PHYSIO-AMS' 	
Else
	lsWarehouse = ''
End If


//We need the Carton Count from Packing
Select Count(Distinct carton_no) Into :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//Convert Carrier to PHYSIO-XD Carrier (SCAC)
lsCarrier = idsDoMain.GetItemString(1,'carrier')
		
Select scac_code into :lsSCAC
From Carrier_Master
Where project_id = "PHYSIO-XD" and carrier_code = :lscarrier;

If isnull(lsSCAC) or lsSCAC = "" Then lsSCAC = lsCarrier


//For each sku/line Item/inventory type/Lot/Serial Nbr  in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Loop Thru Packing for Line/Parent SKU/Supplier and Process all Parent/Child Items from Pick List for that Parent

// 11/06 - PCONKL - want to roll into a sinlg LPN (carton No) per Line Item even if Line is packed in multiple cartons. 
//                  This may be short term until PHYSIO-XD can accept multiple LN's per Line ITem.

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
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to PHYSIO-XD!'"
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

	idsOut.SetItem(llNewRow,'Project_id', 'PHYSIO-XD')
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
	
	idsOut.SetItem(llNewRow,'Project_id', 'PHYSIO-XD')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'rs' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*Serial Record */



//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHYSIO-XD')

Return 0
end function

on u_nvo_edi_confirmations_physio_xd.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_physio_xd.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

