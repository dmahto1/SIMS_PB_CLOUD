$PBExportHeader$u_nvo_edi_confirmations_ironport.sru
$PBExportComments$Process outbound edi confirmation transactions for Ironport
forward
global type u_nvo_edi_confirmations_ironport from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_ironport from nonvisualobject
end type
global u_nvo_edi_confirmations_ironport u_nvo_edi_confirmations_ironport

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Ironport for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq
				
String		lsOutString, lsMessage, lsLogOut, lsFileName, sql_syntax, Errors, lsTrackingID, lsCarton, lsSerial, lsSOLine
				
Datastore	ldsCartonSerial
DateTIme		ldtNow
DEcimal		ldBatchSeq
Integer		liRC

ldtNow = DateTime(today(),Now())

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

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master, Carton/Serial and Pack records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
//If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

idsDoDetail.Retrieve(asDoNo)
idsDoPack.Retrieve(asDoNo)


//We need carton serial information - we will be sending 1 record per sku/serial/tracking number (from packing)

//Create Carton Serial Info datastore
ldsCartonSerial = Create Datastore

//Create the Datastore...
sql_syntax = "SELECT  dbo.Delivery_Picking_Detail.Line_item_No as 'Line_item_No',dbo.Delivery_Picking_Detail.SKU as 'SKU',  Sum(dbo.Delivery_Picking_Detail.Quantity) as 'Qty' , "
sql_syntax += " dbo.Delivery_Serial_Detail.Serial_No as 'Outbound_Serial_no',      dbo.Delivery_Serial_Detail.carton_no  as 'carton_no' " 
sql_syntax += "FROM dbo.Delivery_Picking_Detail LEFT OUTER JOIN dbo.Delivery_Serial_Detail ON dbo.Delivery_Picking_Detail.ID_No = dbo.Delivery_Serial_Detail.ID_No "
sql_syntax += "Where do_no = '" + asDoNo + "' and l_code <> 'N/A' "
sql_syntax += "Group By dbo.Delivery_Picking_Detail.Line_item_No , sku,  Delivery_Serial_Detail.serial_no, carton_no"

ldsCartonSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Ironport Carton/Serial Inforamtion.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsCartonSerial.SetTransobject(sqlca)
ldsCartonSerial.Retrieve()


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Ironport!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 12/07 - PCONKL - Changed file naming convention to include order number instead of Date/Time
//lsFileName = 'ironport_menlo_shipped_PST_' + String(ldtNow,'yyyymmd_hhmmss') + '.csv'
lsFileName = 'ironport_menlo_shipped_' + idsdoMain.GetITemString(1,'invoice_no') + '.csv'

//Write the rows to the generic output table - delimited by ','

//Write a header row...
lsOutString = "Order Line Count, IP Transaction ID, Requested Ship Date, Actual Ship Date, Ship To: Attention Of, Ship To: Label, Ship To: Address Line 1,"
lsOutString +="Ship To: Address Line 2, Ship To: City, Ship to: State, Ship To: Postal Code, Ship To: Country, Carrier Used, Service Level Used, Component ITem ID, Quantity, Serial Number, Tracking Number, SO Line"

llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', 'Ironport')
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', lsFileName)

//For each picking detail/serial
llRowCount = ldsCartonSerial.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = Left(String(ldsCartonSerial.GetITemNumber(llRowPos,'line_item_No')),4) + ',' /*Line ITem Number (Order LIne Count) */
	lsOutString += Left(idsDoMain.GetITemString(1,'invoice_no'),8) + ',' /*Order Number (IP Transaction ID) */
	lsOutString += String(idsDOMAin.GetItemDateTime(1,'schedule_date'),'dd-mmm-yyyy') + ','  /*requested Ship Date */
	lsOutString += String(idsDOMAin.GetItemDateTime(1,'Complete_date'),'dd-mmm-yyyy') + ',' /*actual Ship Date */
	
	If NOt isnull(idsDoMain.GetITemString(1,'address_1')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'address_1') + '",' /*Ship to Attention of */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'address_2')) Then
		lsOutString += '"' +idsDoMain.GetITemString(1,'address_2') + '",' /*Ship to label */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'address_3')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'address_3') + '",' /*Ship to Address 1 */
	Else
		lsOutString += ","
	End If
		
	If NOt isnull(idsDoMain.GetITemString(1,'address_4')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'address_4') + '",' /*Ship to Address 2 */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'City')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'city') + '",' /*Ship to City */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'State')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'State') + '",' /*Ship to State */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'Zip')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'Zip') + '",' /*Ship to Zip */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'Country')) Then
		lsOutString += '"' + idsDoMain.GetITemString(1,'Country') + '",' /*Ship to Country */
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'Carrier')) Then
		lsOutString += '"' + Left(idsDoMain.GetITemString(1,'Carrier'),32) + '",' /*Carrier*/
	Else
		lsOutString += ","
	End If
	
	If NOt isnull(idsDoMain.GetITemString(1,'User_field8')) Then
		lsOutString += '"' + Left(idsDoMain.GetITemString(1,'User_field8'),32) + '",' /*Service LEvel*/
	Else
		lsOutString += ","
	End If
	
	lsOutString += Left(ldsCartonSerial.GetITemString(llRowPos,'SKU'),15) + "," /*Component Item SKU */
	
	//If serialized, default qty to 1, otherwise total qty
	If ldsCartonSerial.GetITemString(llRowPos,'Outbound_Serial_No') > "" Then
		lsOutString += "1,"
	Else
		lsOutString += Left(String(ldsCartonSerial.GetITemNumber(llRowPos,'Qty')),5) + ","
	End If
	
	//If Outbound serialized, carton # will be available on the delivery_Serial_Detail, otherwise, find it on Packing based on Line Item No
	If ldsCartonSerial.GetITemString(llRowPos,'Carton_no') > '' Then
		
		lsCarton = ldsCartonSerial.GetITemString(llRowPos,'Carton_no')
		llFindRow = idsDOPack.Find("Carton_No = '" + lsCarton + "'",1, idsDoPack.RowCount())
		If llFindRow > 0 Then
			lsTrackingID = idsDoPack.GetITemString(llFindROw,'Shipper_Tracking_ID')
		Else
			lsTrackingID = ""
		End If
		
		lsSerial = ldsCartonSerial.GetITemString(llRowPos,'Outbound_Serial_No')
		
	Else /*not outbound serialized */
		
		llFindRow = idsDOPack.Find("Line_Item_No = " + String(ldsCartonSerial.GetITemNumber(llRowPos,'line_item_No')),1, idsDoPack.RowCount())
		If llFindRow > 0 Then
			lsTrackingID = idsDoPack.GetITemString(llFindROw,'Shipper_Tracking_ID')
		Else
			lsTrackingID = ""
		End If
		
		lsSerial = ""
		
	End If
	
	If isNull(lsTrackingID) Then lsTrackingID = ""
	If isNull(lsSerial) Then lsSerial = ""
	
	lsOutString += '"' + lsSerial + '",'
	lsOutString += '"' + lsTrackingID + '",'
	
	
	//05/08 - PCONKL - Added SO Line from DD UF2
	llFindRow = idsDoDetail.Find("Line_Item_No = " + String(ldsCartonSerial.GetITemNumber(llRowPos,'line_item_No')),1,idsDoDetail.RowCount())
	If llFindRow > 0 Then
		lsSOLine = idsDoDetail.GetITemString(llFindRow,'user_Field2')
	Else
		lsSOLine = ""
	End If
	
	If isNull(lsSOLine) then lsSOLine = ""
	
	lsOutString += '"' + lsSoLine + '"'
	
	
	idsOut.SetItem(llNewRow,'Project_id', 'Ironport')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Picking Detail/Serial record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'IronPort')



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Ironport for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName, lsCOO2, lsCOO3

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

//For each line/sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCOunt = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
		
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
				
	End If
	
Next /* Next Putaway record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Ironport!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'GR|' /*rec type = goods receipt*/
	lsOutString += idsROMain.GetItemString(1,'wh_code') + '|' 
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|'
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) 
	
	idsOut.SetItem(llNewRow,'Project_id', 'IRONPORT')
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
	
		lsOutString = 'GS|' /*rec type = goods receipt Serial Number*/
		lsOutString +=	idsROPutaway.GetITemString(llRowPos,'sku') + '|'
		lsOutString +=	idsROPutaway.GetITemString(llRowPos,'serial_no') 
		
		
		idsOut.SetItem(llNewRow,'Project_id', 'IRONPORT')
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'gr' + String(ldBatchSeq,'00000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	Next /*putaway Row*/
	
End If /*serial NUmbers exist*/

If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'IRONPORT')
End If

Return 0
end function

on u_nvo_edi_confirmations_ironport.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_ironport.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

