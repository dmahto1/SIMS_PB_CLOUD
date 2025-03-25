HA$PBExportHeader$u_nvo_edi_confirmations_sika.sru
$PBExportComments$Process outbound edi confirmation transactions for Sika
forward
global type u_nvo_edi_confirmations_sika from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_sika from nonvisualobject
end type
global u_nvo_edi_confirmations_sika u_nvo_edi_confirmations_sika

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName
Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment,idsROMain, idsRODetail, idsROPutaway, idsGR
end variables

forward prototypes
public function integer uf_goods_issue (string asinifile, string asemail)
public function integer uf_process_daily_files (string asinifile, string asemail)
public function integer uf_inv_snapshot (string asinifile, string asemail)
public function integer uf_goods_receipt (string asinifile, string asemail)
public function integer uf_gi_lms (string asproject, string asdono, string astranstype)
public function integer uf_lms_itemmaster ()
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gr (string asproject, string asrono)
end prototypes

public function integer uf_goods_issue (string asinifile, string asemail);//Create a daily file of orders shipped (GI)
/* Not implemented for SIKA...
Integer	liRC, liFileNo
Long	llorderCount, llOrderPos, llPackCount, llPackPos, llNewRow
String	lsOutString, lsLogOut, lsDONO, lsDONOHold, lsCarrierService
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsDO, ldsPack

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Maquet Daily Goods Issue File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

ldsDO = Create Datastore
ldsDO.Dataobject = 'd_maquet_gi'
lirc = ldsDO.SetTransobject(sqlca)

ldsPack = Create Datastore

//Retrieve the SO Data
lsLogout = 'Retrieving Delivery Order Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//retrieve all complete orders that have not been previously shipped
llOrderCount = ldsDO.Retrieve()

lsLogOut = String(llOrderCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llOrderCount < 1 Then 
	Return 0
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("Maquet",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Maquet Goods Issue file. Confirmation will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Build output records - already grouped by order, sku and inv type

//Write to archive file 
isGIFileName = ProfileString(asInifile,"Maquet","archivedirectory","") + '\' + "1234_GI_" + String(ldBatchSeq,"0000000000") + "_" + String(Today(),"yyyymmddhhmm") + ".txt"

//Open and spool the file
liFileNo = FileOpen(isGIFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Maquet Goods Issue file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Build a header record
lsOutString = "Siemens_order	Shipped_Notification#	sku	qty	serial#	Storer	trandate"
FileWrite(liFileNo, lsOutString) /*Spool to file */

For llOrderPos = 1 to llOrderCount
	
	lsOutString = ldsDo.GetITemString(llOrderPos,'Invoice_No') + "~t" /*Seimens Order Number*/
	lsOutString += "~t" /* Shipped Notification - currently blank*/
	lsOutString += ldsDo.GetITemString(llOrderPos,'SKU') + "~t" /*SKU*/
	lsOutString += String(ldsDo.GetITemNumber(llOrderPos,'Quantity'),"#########") + "~t" /*Qty*/
	
	If  ldsDo.GetITemString(llOrderPos,'Serial_NO') <> '-' Then
		lsOutString += ldsDo.GetITemString(llOrderPos,'Serial_NO') + "~t" /*Serial Number*/
	Else
		lsOutString += "~t"
	End If
	
	//remap Inventory Type
	Choose Case Upper(ldsDo.GetITemString(llOrderPos,'Inventory_Type'))
		Case "N" /*Normal*/
			lsOutString += "1055" + "~t"
		Case "E" /*Demo*/
			lsOutString += "1070" + "~t"
		Case "R" /*Returns*/
			lsOutString += "1071" + "~t"
		Case Else
			lsOutString += "~t"
	End Choose
	
	lsOutString += String(ldsDo.GetITemDateTime(llOrderPos,'Complete_Date'),"MM/DD/YYYY HH:MM") /*Complete Date*/
	
	FileWrite(liFileNo, lsOutString) /*Spool to file */
	
Next /* Order detail record */

//Close the file and email...
FileClose(liFileNo)

//If pos(asEmail,"@") > 0 Then
//	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Goods Shipped File","  Attached is the Daily Goods Shipped File (GI)...",lsGIFileName)
//Else /*no valid email, send an email to the file transfer error dist list*/
//	gu_nvo_process_files.uf_send_email("maquet",'FILEXFER',"Unable to email Daily shipment file to Maquet","Unable to email Daily shipment file to Maquet - no email address found - file is still archived","")
//End If
	

//Create the TR File from Delivery Packing info...

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("Maquet",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Maquet Goods Issue file. Confirmation will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
isTRFileName = ProfileString(asInifile,"Maquet","archivedirectory","") + '\' + "1234_TR_" + String(ldBatchSeq,"0000000000") + "_" + String(Today(),"yyyymmddhhmm") + ".txt"

//Create the Datastore...
sql_syntax = "SELECT carton_no, Max(shipper_tracking_id) as shipper_tracking_id   from Delivery_Packing Group by Carton_no;" 
ldsPack.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Maquet Carton/Tracking ID data (TR).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1

END IF

ldsPack.SetTransObject(SQLCA)


//Open and spool the file
liFileNo = FileOpen(isTRFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Maquet TR file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Build a header record
lsOutString = "EXTERNORDERKEY	ORDERKEY	CASEID	TRACKINGNUMBER	CARRIER_SERVICE	SHIP_DT"
FileWrite(liFileNo, lsOutString) /*Spool to file */

For llOrderPos = 1 to llOrderCount
	
	//If dono changes, retrieve packing records...
	lsDONO = ldsDo.GetITemString(llOrderPos,'do_no')
	If lsdONO <> lsDONOHold Then
		
		lirc = ldsPack.SetSqlSelect("SELECT carton_no, Max(shipper_tracking_id) as shipper_tracking_id   from Delivery_Packing where do_no = '" + lsDONO + "' Group by Carton_no")
		If lirc < 0 Then
			lsLogOut = "        *** Unable to retreive packing information for Maquet TR file. File will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
		llPackCount = ldsPack.Retrieve()
		
		//Carrier Service is carrier +"." + Sched Code (User Field 1)
		lsCarrierService = ""
		If Not isnull(ldsDo.GetITemString(llOrderPos,'Carrier')) Then
			lsCarrierService = ldsDo.GetITemString(llOrderPos,'Carrier')
		End If
		
		If Not isnull(ldsDo.GetITemString(llOrderPos,'User_Field1')) Then
			lsCarrierService += "." + ldsDo.GetITemString(llOrderPos,'User_Field1')
		End If
		
		For llPackPos = 1 to llPackCount
			
			lsOutString = ldsDo.GetITemString(llOrderPos,'Invoice_No') + "~t" /*EXTERNORDERKEY (Invoice No)*/
			lsOutString += ldsDo.GetITemString(llOrderPos,'Invoice_No') + "~t" /*ORDER KEY (Do we use Invoice No??)*/
			
			If not isnull(ldsPack.GetITemString(llPackPos,'Carton_no')) Then
				lsOutString += ldsPack.GetITemString(llPackPos,'Carton_no') + "~t" /*Case ID (Carton_No)*/
			Else
				lsOutString += "~t"
			End If
			
			If not isnull(ldsPack.GetITemString(llPackPos,'shipper_tracking_id')) Then
				lsOutString += ldsPack.GetITemString(llPackPos,'shipper_tracking_id') + "~t" /*Tracking Number (shipper_tracking_id)*/
			Else
				lsOutString += "~t"
			End If
			
			lsOutString += lsCarrierService + "~t" /*carrier Serivce level formatted above*/
			lsOutString += String(ldsDo.GetITemDateTime(llOrderPos,'Complete_Date'),"MM/DD/YYYY HH:MM") /*Complete Date*/
			
			FileWrite(liFileNo, lsOutString) /*Spool to file */
			
		Next /*pack Row for order*/

	End IF /*order changed*/
	
	lsDONOHold = lsDONO
	
Next /*Order*/

//Close the file and email...
FileClose(liFileNo)

//If pos(asEmail,"@") > 0 Then
//	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Goods Shipped File","  Attached is the Daily Goods Shipped File (TR)...",lsTRFileName)
//Else /*no valid email, send an email to the file transfer error dist list*/
//	gu_nvo_process_files.uf_send_email("maquet",'FILEXFER',"Unable to email Daily shipment file to Maquet","Unable to email Daily shipment file (TR) to Maquet - no email address found - file is still archived","")
//End If

//Update to reflect transmitted.
For llOrderPos = 1 to llOrderCount
	ldsDO.SetItem(llOrderPos,'file_transmit_ind','Y')
Next

liRC = ldsDo.Update()
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut = "        *** Unable to update Delivery_master.File_Transmit_Ind for Maquet GI/TR files"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

*/
Return 0 //llOrderCount
end function

public function integer uf_process_daily_files (string asinifile, string asemail);/* Not implemented for Sika...
Integer	liRC
String	lsStatusMsg, lsAttachments

//Return code is the number of records processed or -1 if error

isgifilename = ""
istrfilename = ""
isgrfilename = ""
isInvFileName = ""
lsAttachments = ""

liRC = uf_goods_Issue(asInifile, asemail) /*Goods Issue and Shipment files*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Goods Issue and Shipment Files (GI/TR). "
Elseif liRC = 0 Then
	lsStatusMsg += "There were no Shipments for today (GI/TR). "
Else
	
	lsStatusMsg += "Attached are the shipment files for today (GI/TR). "
	
	If isGIFileName > "" Then
		lsAttachments += "," + isGIFileName
	End If
	
	If isTRFileName > "" Then
		lsAttachments += "," + isTRFileName
	End If
	
End If


liRC = uf_goods_Receipt(asInifile, asemail) /*Goods Receipts*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Goods Receipt File (GR). "
Elseif liRC = 0 Then
	lsStatusMsg += "There were no Receipts for today (GR). "
Else
	
	lsStatusMsg += "Attached are the Receipt files for today (GR). "
	
	If isGRFileName > "" Then
		lsAttachments += "," + isGRFileName
	End If
	
End If


liRC = uf_inv_snapshot(asInifile,asEmail) /*Inv snapshot*/

If liRC < -0 Then
	lsStatusMsg += "Unable to create Inventory Snapshot File (CO). "
Elseif liRC = 0 Then
	lsStatusMsg += "There is no inventory for today (CO). "
Else
	
	lsStatusMsg += "Attached is the Inventory Snapshot file for today (CO). "
	
	If isINVFileName > "" Then
		lsAttachments += "," + isINVFileName
	End If
	
End If

//Email the Files

If lsAttachments > "" Then
	lsAttachments = Mid(lsAttachments,2,99999) /*strip off first comma*/
End If


If pos(asEmail,"@") > 0 Then
	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Transaction files",lsStatusMsg,lsAttachments)
Else /*no valid email, send an email to the file transfer error dist list*/
	gu_nvo_process_files.uf_send_email("maquet",'FILEXFER',"Unable to email Daily transaction files to Maquet","Unable to email Daily transaction files to Maquet - no email address found - files are still archived","")
End If

*/
Return 0
end function

public function integer uf_inv_snapshot (string asinifile, string asemail);//Inventory Snapshot for SIKA
/* TEMPO! 15.2. For purposes of this file, inventory that has been picked 
for an order but not yet ship completed is considered available inventory. */
Integer	liRC, liFileNo
Long	llRowCount, llRowPos, llNewRow
String	lsOutString,  lsLogOut
string ERRORS, sql_syntax, lsTemp
Decimal	ldBatchSeq
Datastore	 ldsInv

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIKA Daily Inventory Snapshot File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Create datastore
ldsInv = Create Datastore

//Create the Datastore...
//sql_syntax = "SELECT SKU, inventory_type, Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) as total_qty   from Content_Summary " 
//sql_syntax += " Where Project_ID = 'maquet' Group by SKU, Inventory_Type Having Sum( Content_Summary.Avail_Qty  ) + Sum( Content_Summary.alloc_Qty  ) > 0;"
//tempo - do we need inventory type here for SIKA?
sql_syntax = "SELECT WH_Code, SKU, lot_no, inventory_type, Sum(Avail_Qty) + Sum(alloc_Qty) as total_qty"
sql_syntax += " from Content_Summary"
sql_syntax += " Where Project_ID = 'SIKA'"
sql_syntax += " Group by WH_Code, SKU, Lot_No, Inventory_type"
sql_syntax += " Having Sum(Avail_Qty) + Sum(alloc_Qty) > 0;"
ldsInv.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for SIKA Inventory Snapshot ID data (CO).~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

lirc = ldsInv.SetTransobject(sqlca)

//Retrieve the Inv Data
lsLogout = 'Retrieving Inventory Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = ldsInv.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llRowCount < 1 Then 
	Return 0
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("SIKA", 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for SIKA Inventory Snapshot file. File will not be Created/Sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write to archive file 
//isInvFileName = ProfileString(asInifile, "SIKA", "archivedirectory", "") + '\' + "1234_CO_" + String(ldBatchSeq,"0000000000") + "_" + String(Today(),"yyyymmddhhmm") + ".txt"
//TEMPO! - Naming convention?
isInvFileName = ProfileString(asInifile, "SIKA", "archivedirectory", "") + '\' + "BH" + String(ldBatchSeq, "00000") + ".DAT"

//Open and spool the file
liFileNo = FileOpen(isInvFileName, LineMode!, Write!, LockReadWrite!, Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for SIKA Daily Inventory Snapshot file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// //Build a header record
// lsOutString = "Storer	Material Number	Quantity"
// FileWrite(liFileNo, lsOutString) /*Spool to file */

For llRowPos = 1 to llrowCount
	
	//Convert Inv Type?
/*	choose Case Upper(ldsInv.GetItemstring(llRowPos, 'inventory_Type'))
		Case 'N' /*normal*/
			lsOutString = "1055" + "~t"
		Case 'E' /*Demo*/
			lsOutString = "1070" + "~t"
		case 'R' /*Returns*/
			lsOutString = "1071" + "~t"
		Case else
			lsOutString = "~t"
	End Choose
*/
	lsOutstring = 'BH'
	lsTemp = ldsInv.GetItemstring(llRowPos, 'wh_code') /*warehouse*/
	lsOutString += lsTemp + Space(10 - Len(lsTemp))
	lsOutstring += ldsInv.GetItemstring(llRowPos, 'inventory_type')
	lsTemp = ldsInv.GetItemstring(llRowPos, 'sku') /*SKU*/
	lsOutString += lsTemp + Space(26 - Len(lsTemp))
	lsOutstring += String(ldsInv.GetItemNumber(llRowPos, 'total_qty'), "#############")
	lsOutString += Space(6) /* Package Code? */
	lsTemp = ldsInv.GetItemstring(llRowPos, 'lot_no') /*Lot #*/
	lsOutString += lsTemp + Space(30 - Len(lsTemp))
	
	FileWrite(liFileNo, lsOutString)

/* TEMPO - Do we want to create the file in here or write the data to edi_generic_out
			(and then call uf_process_flatfile_outbound....)
			//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
			gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asProject)

// Write the record to edi_generic_out
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow, 'Project_id', asproject)
	idsOut.SetItem(llNewRow, 'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow, 'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow, 'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow, 'file_name', lsFilePRefix + String(ldBatchSeq,'00000') + '.DAT') 
*/

Next /*Inv record*/


FileClose(liFileNo)

//If pos(asEmail,"@") > 0 Then
//	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Inventory Snaphot File","  Attached is the Daily Inventory Snapshot file (CO)...",lsInvFileName)
//Else /*no valid email, send an email to the file transfer error dist list*/
//	gu_nvo_process_files.uf_send_email("maquet",'FILEXFER',"Unable to email Daily shipment file to Maquet","Unable to email Daily Inventory Snaphot file (CO) to Maquet - no email address found - file is still archived","")
//End If

Return llrowCount
end function

public function integer uf_goods_receipt (string asinifile, string asemail);
//create a file of Orders received since the last run...
/* not implemented for Sika...
Integer	liRC, liFileNo
Long	llorderCount, llOrderPos, llNewRow
String	lsOutString,  lsLogOut
string ERRORS, sql_syntax
Decimal	ldBatchSeq
Datastore	 ldsRO

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Maquet Daily Goods Receipt File... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

ldsRO = Create Datastore
ldsRO.Dataobject = 'd_maquet_gr'
lirc = ldsRO.SetTransobject(sqlca)


//Retrieve the PO Data
lsLogout = 'Retrieving Receive Order Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//retrieve all complete orders that have not been previously received
llOrderCount = ldsRO.Retrieve()

lsLogOut = String(llOrderCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

If llOrderCount < 1 Then 
	
//	gu_nvo_process_files.uf_send_email("maquet",asEmail,"XPO Logistics WMS - Daily Goods Receipt File","There were no orders received today...","")
	Return 0
	
End If

//Next File Sequence #...
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no("Maquet",'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number for Maquet Goods Receipt file. Confirmation will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Build output records - already grouped by order, sku and inv type

//Write to archive file 
isGRFileName = ProfileString(asInifile,"Maquet","archivedirectory","") + '\' + "1234_GR_" + String(ldBatchSeq,"0000000000") + "_" + String(Today(),"yyyymmddhhmm") + ".txt"

//Open and spool the file
liFileNo = FileOpen(isGRFileName,LineMode!,Write!,LockReadWrite!,Append!)
If liFileNo < 0 Then
	lsLogOut = "        *** Unable to open output file for Maquet Goods Receipt file. File will not be sent'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Build a header record
lsOutString = "Purchase Order/Delivery Note	Material Number	Quantity	Serial Number	BOL	Storer	Date"
FileWrite(liFileNo, lsOutString) /*Spool to file */

For llOrderPos = 1 to llOrderCount
	
	lsOutString = ldsRO.GetITemString(llOrderPos,'Supp_Invoice_No') + "~t" /*PO/Delivery Note*/
	lsOutString += ldsRO.GetITemString(llOrderPos,'SKU') + "~t" /*SKU*/
	lsOutString += String(ldsRO.GetITemNumber(llOrderPos,'quantity'),"##########") + "~t" /*Qty*/
	
	If  ldsRO.GetITemString(llOrderPos,'Serial_NO') <> '-' Then
		lsOutString += ldsRO.GetITemString(llOrderPos,'Serial_NO') + "~t" /*Serial Number*/
	Else
		lsOutString += "~t"
	End If
	
	If Not isnull(ldsRO.GetITemString(llOrderPos,'awb_bol_no')) Then
		lsOutString += ldsRO.GetITemString(llOrderPos,'awb_bol_no') + "~t" /*BOL*/
	Else
		lsOutString += "~t"
	End If
	
	//remap Inventory Type
	Choose Case Upper(ldsRO.GetITemString(llOrderPos,'Inventory_Type'))
		Case "N" /*Normal*/
			lsOutString += "1055" + "~t"
		Case "E" /*Demo*/
			lsOutString += "1070" + "~t"
		Case "R" /*Returns*/
			lsOutString += "1071" + "~t"
		Case Else
			lsOutString += "~t"
	End Choose
	
	lsOutString += String(ldsRO.GetITemDateTime(llOrderPos,'Complete_Date'),"MM/DD/YYYY HH:MM") /*Complete Date*/
	
	FileWrite(liFileNo, lsOutString) /*Spool to file */
	
Next /* Order detail record */

//Close the file and email...
FileClose(liFileNo)

//Update to reflect transmitted.
For llOrderPos = 1 to llOrderCount
	ldsRO.SetItem(llOrderPos,'file_transmit_ind','Y')
Next

liRC = ldsRO.Update()
If liRC = 1 Then
	Commit;
Else
	Rollback;
	lsLogOut = "        *** Unable to update Receive_master.File_Transmit_Ind for Maquet GR files"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
*/
Return 0 //llOrderCount
end function

public function integer uf_gi_lms (string asproject, string asdono, string astranstype);
//Create a GI for LMS and one for SIKA
//Modeled after Maquet.  
//TEMP - Need to create both LMS and SIKA files at same time (for Maquet, one is created at Ready and one is created at Confirm)

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llRecSeq
				
String		lsFind, lsOut_SIKA, lsOut_LMS,	lsMessage, lsSku,	lsSupplier,	lsInvType, &
				lsInvoice, lsLogOut, lsWarehouse, lsSikaWarehouse, lsFileName, lsCarton, lsTemp, 	&
				lsWHName, lsWHAddr1, lsWHAddr2, lsWHCity, lsWHState, lsWHZip, lsWHCountry, lsCartonSave, &
				lsLineNoSIKA, lsLineNoLMS, lsPrefixSIKA, lsPrefixLMS, lsWH_Date_Time

Decimal		ldBatchSeq, ldBatchSeqLMS, ldVolume, ldNetWeight, ldGrossWeight, ldLength, ldWidth, ldHeight
Integer		liRC
DateTime		ldtToday

ldtToday = DateTime(Today(), Now())

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

//Retreive Delivery Master, Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoDetail.Retrieve(asDoNo) /*detail Records*/
idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*Pack Records */

//File Prefix = 'P945' for Ready to Ship and 'N945' for Goods Issue
/*
If asTransType = 'RS' Then
	lsFilePRefix = 'P945' /*for file routing below*/
	lsLogOut = "        Creating RS For DONO: " + asDONO
Else
	lsFilePRefix = 'N945' /*for file routing below*/
	lsLogOut = "        Creating GI For DONO: " + asDONO
End If
*/

/* Now creating both records simultaneously
//File Prefix = 'P945' for Ready to Ship and 'N945' for Goods Issue
*/
//TEMPO - Check File Prefixes (P945 and N945)
lsPrefixSika = 'P945'
lsPrefixLMS = 'N945'

lsLogOut = "        Creating GI For DONO: " + asDONO

FileWrite(gilogFileNo,lsLogOut)

// 02/07 - PCONKL - Need ship from info

//Convert our warehouse code to SIKA Warehouse ID 
lsWarehouse = idsDOMain.GetItemString(1,'wh_code')
Select User_Field1, wh_Name, address_1, address_2, city, state, zip, country 
Into :lsSikaWarehouse,  :lsWHName, :lsWHAddr1, :lsWHADdr2, :lsWHCity, :lsWHState, :lsWHZip, :lsWHCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsSikaWarehouse) or lsSikaWarehouse = "" Then lsSikaWarehouse = lsWarehouse
lsSikaWarehouse = Left(lsSikaWarehouse,6) + Space(6 - Len(lsSikaWarehouse))

// set string of WH/Date/Time for use later...
	lsWH_Date_Time = lsSikaWarehouse + Space(6 - Len(lsSikaWarehouse)) /*warehouse*/
	lsWH_Date_Time += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsWH_Date_Time += String(ldtToday,'HHMMSS') /* Transaction Time*/

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to SIKA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// File to LMS - different batch sequence so we get 2 different files when written to flat file
ldBatchSeqLMS = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeqLMS <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to LMS!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create a 945 (GI) for SIKA and LMS 
llRowCount = idsdoPack.RowCount()

llRecSeq = 0

For llRowPos = 1 to llRowCount /* each Pack Row */
	
	//We need some fields from Order Detail
	lsSKU = idsDOPack.GetItemString(llRowPos,'SKU')
	llLineItemNo = idsdoPack.GetItemNumber(llRowPos,'Line_Item_No')
	llFindRow = idsDoDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineItemNo), 1, idsdoDetail.RowCount())
	
	llRecSeq ++
	lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
	lsOut_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	// Transaction Type - SH1 for Ready to Ship and SHP for Goods Issue
	/* For SIKA, not sending at Ready to Ship so SH1 really means 945 for SIKA while SHP means 945 for LMS */
		lsOut_SIKA += 'SH1'
		lsLineNoSIKA = idsdoDetail.GetItemstring(llFindRow, 'User_Field2') //Send SIKA's Line No on 945 (back to SIKA)
		// 08/22/07 - need to zero-pad the line number for the 945 to SIKA (not the 945 to LMS)
		lsLineNoSIKA = String(long(lsLineNoSIKA), '000000')
		lsOut_LMS += 'SHP'
		lsLineNoLMS = string(llLineItemNo)
	
	//lsWH_Date_Time set above...
	lsOut_SIKA += lsWh_Date_Time
	lsOut_LMS += lsWh_Date_Time

	lsOut_SIKA += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	lsOut_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	
	//Ord Type should be coming from UF 2
	If Not isnull(idsDoMain.Object.user_field2[1]) Then 
		lsOut_SIKA += left(idsDoMain.Object.user_field2[1] + space(4), 4)
		lsOut_LMS += left(idsDoMain.Object.user_field2[1] + space(4), 4)
	Else
		lsOut_SIKA +=  Space(4)
		lsOut_LMS +=  Space(4)
	End If
	
	/* Line Number 
	 - Either Line_Item_No on 945 to LMS or Maquet's Line No (User_Field2) on 945P to Maquet */
	If Not isnull(lsLineNoSika) Then 
		// 08/22/07 - the Line No to SIKA will be zero-padded to 6-chars above
		lsOut_SIKA += space(6 - len(lsLineNoSika)) + lsLineNoSika
	Else
		lsOut_SIKA += Space(6)
	End If
	
	If Not isnull(lsLineNoLMS) Then 
		// 08/22/07 - the Line No to Maquet will be zero-padded to 6-chars above
		lsOut_LMS += space(6 - len(lsLineNoLMS)) + lsLineNoLMS
	Else
		lsOut_LMS += Space(6)
	End If

	lsOut_SIKA += Space(1) /*Line Item Complete*/
	lsOut_LMS += Space(1) /*Line Item Complete*/
	
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOut_SIKA += Space(15)
		lsOut_LMS += Space(15)
	End If
	/* AWB BOL */
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
	Else
		lsOut_SIKA += Space(10)
		lsOut_LMS += Space(10)
	End If
	
	//Original Qty = Need from Order Detail
	If llFindRow > 0 Then /*detail row found above */
		lsOut_SIKA += String(idsDoDetail.GetItemDecimal(llFindRow,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
		lsOut_LMS += String(idsDoDetail.GetItemDecimal(llFindRow,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
	Else /*not found */
		lsOut_SIKA += '000000000.00'
		lsOut_LMS += '000000000.00'
	End If
	
	//Pack Qty
	lsOut_SIKA += String(idsdoPack.GetItemDecimal(llRowPos,'quantity'),'000000000.00') /*Explicit 2 decimal */
	lsOut_LMS += String(idsdoPack.GetItemDecimal(llRowPos,'quantity'),'000000000.00') /*Explicit 2 decimal */
	
	//UOM - From Order Detail
	If llFindRow > 0 Then /*detail row found above */
		If Not isnull(idsdoDetail.GetItemstring(llFindRow,'uom')) Then
			lsOut_SIKA += idsdoDetail.GetItemstring(llFindRow,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llFindRow,'uom')))
			lsOut_LMS += idsdoDetail.GetItemstring(llFindRow,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llFindRow,'uom')))
		Else
			lsOut_SIKA += Space(6)
			lsOut_LMS += Space(6)
		End If
	Else /* Not Found */
		lsOut_SIKA += Space(6)
		lsOut_LMS += Space(6)
	End If
	
	//Package Weight (Gross)
	ldGrossWeight = idsDoPack.GetItemDecimal(llRowPos,'weight_Gross')
	If NOt isnull(ldGrossWeight) Then
		//If idsDoPack.GetITemString(llRowPos,'standard_of_measure') <> 'M' Then
		//	ldGrossWeight = ldGrossWeight * 0.45359237
		//End If
	Else
		ldGrossWeight = 0
	End If
	
	lsOut_SIKA += String(ldGrossWeight,'00000000.000') /* Explicit 3 decimals*/
	lsOut_LMS += String(ldGrossWeight,'00000000.000') /* Explicit 3 decimals*/
	
//	If Not isnUll(idsDoPack.GetItemDecimal(llRowPos,'weight_Gross')) Then
//		lsOut_LMS += String(ldGrossWeight,'00000000.000') /* Explicit 3 decimals*/
//	Else
//		lsOut_LMS += '00000000.000'
//	End If
	
	//Shipment Weight - 0
	lsOut_SIKA += '00000000.000'
	lsOut_LMS += '00000000.000'
	
	lsOut_SIKA += idsdoPack.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoPack.GetItemString(llRowPos,'sku')))
	lsOut_LMS += idsdoPack.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoPack.GetItemString(llRowPos,'sku')))
	
	//Package Code - PO_NO From Picking
	llFindRow = idsDoPick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineITemNo),1,idsdoPick.RowCount())
	If llFindRow > 0 Then
		If idsdoPick.GetItemString(llFindRow,'po_no') <> '-' Then
			lsOut_SIKA += idsdoPick.GetItemString(llFindRow,'po_no') + Space(6 - Len(idsdoPick.GetItemString(llFindRow,'po_no')))
			lsOut_LMS += idsdoPick.GetItemString(llFindRow,'po_no') + Space(6 - Len(idsdoPick.GetItemString(llFindRow,'po_no')))
		Else
			lsOut_SIKA += Space(6)
			lsOut_LMS += Space(6)
		End If
	Else
		lsOut_SIKA += Space(6)
		lsOut_LMS += Space(6)
	End IF
	
	/*Freight Terms -> User Code 1 */
	If idsdoMain.GetItemString(1,'Freight_terms') > "" Then
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Freight_terms'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Freight_terms')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'Freight_terms'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Freight_terms')))
	Else
		lsOut_SIKA += Space(15) 
		lsOut_LMS += Space(15) 
	End If
	
	/* User code 2 & 3, 15 spaces each */
	//lsOut_SIKA += Space(30)
	//lsOut_LMS += Space(30) 
	// dts 02/07/08 - Now sending Seal number (User_Field8) in User code 2
	If Not isnull(idsDoMain.GetItemString(1,'User_Field8')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field8'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field8')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field8'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field8')))
	Else
		lsOut_SIKA += Space(15)
		lsOut_LMS += Space(15)
	End If
	
	//user code 3
	lsOut_SIKA += Space(15)
	lsOut_LMS += Space(15) 

	/* Carrier*/
	If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
	Else
		lsOut_SIKA += Space(15)
		lsOut_LMS += Space(15)
	End If
	
	/* Pro Number*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field6')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
	Else
		lsOut_SIKA += Space(20)
		lsOut_LMS += Space(20)
	End If
	
	/* Trailer*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field7')) Then 
		// dts - 02/07/08 - now sending 30 characters...
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field7'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'User_Field7')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field7'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'User_Field7')))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
		
	If String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') > "" Then
		lsOut_SIKA += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') //Ship Date
		lsOut_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') //Ship Date
	Else
		lsOut_SIKA += Space(8)
		lsOut_LMS += Space(8)
	End If
	
	lsOut_SIKA += Space(4)
	lsOut_LMS += Space(4) /*Order Status */
	
	/* Group Codes 1 thru 7, 15 spaces each */
	lsOut_SIKA += Space(7*15)
	lsOut_LMS += Space(7*15) 
	
	//Lot No - Get from Pick List
	llFindRow = idsDoPick.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineITemNo),1,idsdoPick.RowCount())
	If llFindRow > 0 Then
		If idsdoPick.GetItemString(llFindRow,'lot_no') <> '-' Then
			lsOut_SIKA += idsdoPick.GetItemString(llFindRow,'lot_no') + Space(30 - Len(idsdoPick.GetItemString(llFindRow,'lot_no')))
			lsOut_LMS += idsdoPick.GetItemString(llFindRow,'lot_no') + Space(30 - Len(idsdoPick.GetItemString(llFindRow,'lot_no')))
		Else
			lsOut_SIKA += Space(30)
			lsOut_LMS += Space(30)
		End If
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End IF
	
	// COO - From Picking
	If llFindRow > 0 Then
		If idsdoPick.GetItemString(llFindRow,'country_of_Origin') <> 'XXX' and idsdoPick.GetItemString(llFindRow,'country_of_Origin') > "" Then
			lsOut_SIKA += Left(idsdoPick.GetItemString(llFindRow,'country_of_Origin'),3) + Space(3 - Len(idsdoPick.GetItemString(llFindRow,'country_of_Origin')))
			lsOut_LMS += Left(idsdoPick.GetItemString(llFindRow,'country_of_Origin'),3) + Space(3 - Len(idsdoPick.GetItemString(llFindRow,'country_of_Origin')))
		Else
			lsOut_SIKA += Space(3)
			lsOut_LMS += Space(3)
		End If
	Else
		lsOut_SIKA += Space(3)
		lsOut_LMS += Space(3)
	End If
	
	//Ship from ID - This value will come from LMS - should map to the warehouse code
	lsOut_SIKA += Left(lsWarehouse,9) + Space( 9 - Len(lsWarehouse))
	lsOut_LMS += Left(lsWarehouse,9) + Space( 9 - Len(lsWarehouse))
		
	//Ship From Name 1
	If lsWHName > "" Then
		lsOut_SIKA += Left(lsWHName,35) + Space(35 - Len(lsWHName))
		lsOut_LMS += Left(lsWHName,35) + Space(35 - Len(lsWHName))
	Else
		lsOut_SIKA += Space(35)
		lsOut_LMS += Space(35)
	End If
	
	//Ship From Name 2
	lsOut_SIKA += Space(30)
	lsOut_LMS += Space(30)
	
	//Ship From Addr 1
	If lsWHaddr1 > "" Then
		lsOut_SIKA += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
		lsOut_LMS += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship From Addr 2
	If lsWHaddr2 > "" Then
		lsOut_SIKA += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
		lsOut_LMS += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship From City
	If lsWHCity > "" Then
		lsOut_SIKA += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
		lsOut_LMS += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship From State
	If lsWHState > "" Then
		lsOut_SIKA += Left(lsWHState,2) + Space(2 - Len(lsWHState))
		lsOut_LMS += Left(lsWHState,2) + Space(2 - Len(lsWHState))
	Else
		lsOut_SIKA += Space(2)
		lsOut_LMS += Space(2)
	End If
	
	//Ship From Zip
	If lsWHZip > "" Then
		lsOut_SIKA += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
		lsOut_LMS += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
	Else
		lsOut_SIKA += Space(10)
		lsOut_LMS += Space(10)
	End If
	
	//Ship From Country
	If lsWHCountry > "" Then
		lsOut_SIKA += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
		lsOut_LMS += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
	Else
		lsOut_SIKA += Space(2)
		lsOut_LMS += Space(2)
	End If
	
	//Ship TO ID (Cust Code ??)
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Code')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
	Else
		lsOut_SIKA += Space(9)
		lsOut_LMS += Space(9)
	End If
	
	//Ship TO Name 1
	If Not isnull(idsDoMain.GetItemString(1,'Cust_Name')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
	Else
		lsOut_SIKA += Space(35)
		lsOut_LMS += Space(35)
	End If
	
	//Ship To Name 2
	lsOut_SIKA += Space(30)
	lsOut_LMS += space(30)
	
	//Ship TO  Address1
	If Not isnull(idsDoMain.GetItemString(1,'address_1')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'address_1'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_1')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'address_1'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_1')))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship TO  Address2
	If Not isnull(idsDoMain.GetItemString(1,'address_2')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'address_2'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_2')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'address_2'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'address_2')))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship TO  City
	If Not isnull(idsDoMain.GetItemString(1,'city')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'city'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'city')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'city'),30) + Space(30 - Len(idsDoMain.GetItemString(1,'city')))
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
	
	//Ship TO State
	If Not isnull(idsDoMain.GetItemString(1,'state')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'state'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'State')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'state'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'State')))
	Else
		lsOut_SIKA += Space(2)
		lsOut_LMS += Space(2)
	End If
	
	//Ship TO Zip
	If Not isnull(idsDoMain.GetItemString(1,'zip')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'zip'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'zip')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'zip'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'zip')))
	Else
		lsOut_SIKA += Space(10)
		lsOut_LMS += Space(10)
	End If
	
	//Ship TO Country
	If Not isnull(idsDoMain.GetItemString(1,'country')) Then 
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'country'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'country')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'country'),2) + Space(2 - Len(idsDoMain.GetItemString(1,'country')))
	Else
		lsOut_SIKA += Space(2)
		lsOut_LMS += Space(2)
	End If

	// Write the record for SIKA
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 

/*TEMPO!Maximum Script Size
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeqLMS))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_LMS)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixLMS + String(ldBatchSeqLMS,'00000') + '.DAT') 
*/
next /*next output record */

/* 01/17/08 - Not sending 'Cancel' records for Sika
				// 06/04 - PCONKL - We also want to include cancel records for any Order Details that did not ship (detail.Alloc_Qty = 0)
				idsDODetail.SetFilter("alloc_Qty = 0")
				idsDODetail.Filter()
				
				llRowCount = idsdoDetail.RowCount()
				For llRowPos = 1 to llRowCount /*Each 0 shipped Detail row */
						
					llRecSeq ++
					lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
					lsOut_LMS = String(llRecSeq,'000000') /* Record Number*/
					
					// Transaction Type - LC1 for Ready to Ship and LCN for Goods Issue
					//  (Now LC1 for SIKA and LCN for LMS)
					//If asTransType = 'RS' Then
						lsOut_SIKA += 'LC1' 
					//Else
						lsOut_LMS += 'LCN' 
					//End If
						
					//Use WH, Date, Time string from above...
					lsOut_SIKA += lsWh_Date_Time
					lsOut_LMS += lsWh_Date_Time
				
					lsOut_SIKA += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
					lsOut_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
					lsOut_SIKA += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */
					lsOut_LMS += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */
				
					
					/*Line Item Number */
					If Not isnull(idsDoDetail.GetItemNumber(llRowPos,'Line_Item_No')) Then 
						lsOut_SIKA += String(idsDoDetail.GetItemNumber(llRowPos,'Line_Item_No'),'000000')
						lsOut_LMS += String(idsDoDetail.GetItemNumber(llRowPos,'Line_Item_No'),'000000')
					Else
						lsOut_SIKA += '000000'
						lsOut_LMS += '000000'
					End If
					
					lsOut_SIKA += Space(1) /*Line Item Complete*/
					lsOut_LMS += Space(1) /*Line Item Complete*/
					
					/* LMS Shipment */
					If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
					Else
						lsOut_SIKA += Space(15)
						lsOut_LMS += Space(15)
					End If
					
					/* AWB BOL */
					If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
					Else
						lsOut_SIKA += Space(10)
						lsOut_LMS += Space(10)
					End If
					
					//Original Qty 
					lsOut_SIKA += String(idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
					lsOut_LMS += String(idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
						
					//Pack Qty - 0 (Not shipped)
					lsOut_SIKA += '000000000000'
					lsOut_LMS += '000000000000'
					
					//UOM
					If Not isnull(idsdoDetail.GetItemstring(llRowPos,'uom')) Then
						lsOut_SIKA += idsdoDetail.GetItemstring(llRowPos,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llRowPos,'uom')))
						lsOut_LMS += idsdoDetail.GetItemstring(llRowPos,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llRowPos,'uom')))
					Else
						lsOut_SIKA += Space(6)
						lsOut_LMS += Space(6)
					End If
					
					//Package Weight (Gross) - 0 for 0 shipped
					lsOut_SIKA += '00000000.000'
					lsOut_LMS += '00000000.000'
						
					//Shipment Weight - 0
					lsOut_SIKA += '00000000.000'
					lsOut_LMS += '00000000.000'
					
					lsOut_SIKA += idsdoDetail.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoDetail.GetItemString(llRowPos,'sku'))) //SKU
					lsOut_LMS += idsdoDetail.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoDetail.GetItemString(llRowPos,'sku'))) //SKU
					
					lsOut_SIKA += Space(6)
					lsOut_LMS += Space(6) /*package Code */
					
					/*Freight Terms -> User Code 1 */
					If idsdoMain.GetITemString(1,'Freight_terms') > "" Then
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Freight_terms'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Freight_terms')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'Freight_terms'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Freight_terms')))
					Else
						lsOut_SIKA += Space(15)
						lsOut_LMS += Space(15) 
					End If
					/* User Code 2 & 3, 15 spaces each */	
					lsOut_SIKA += Space(30)
					lsOut_LMS += Space(30)
					
					/* Carrier*/
					If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
					Else
						lsOut_SIKA += Space(15)
						lsOut_LMS += Space(15)
					End If
					
					/* Pro Number*/
					If Not isnull(idsDoMain.GetItemString(1,'User_Field6')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
					Else
						lsOut_SIKA += Space(20)
						lsOut_LMS += Space(20)
					End If
					
					/* Trailer*/
					If Not isnull(idsDoMain.GetItemString(1,'User_Field7')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
					Else
						lsOut_SIKA += Space(10)
						lsOut_LMS += Space(10)
					End If
					
					//Ship Date
					If String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') > "" Then
						lsOut_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') //Ship Date
						lsOut_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD') //Ship Date
					Else
						lsOut_SIKA += Space(8)
						lsOut_LMS += Space(8)
					End If
					
					lsOut_SIKA += Space(4)
					lsOut_LMS += Space(4) /*Order Status */
					/* Group Codes 1 thru 7, 15 spaces each */
					lsOut_SIKA += Space(7*15)
					lsOut_LMS += Space(7*15) 
					
				//TEMPO!	//Lot No - (was blanks for Maquet - need to go against delivery_picking)
						lsOut_SIKA += Space(8)
						lsOut_LMS += Space(8)
							
					// 01/07 - PCONKL - New LMS fields
					
					lsOut_SIKA += Space(3)
					lsOut_LMS += Space(3) // COO 
						
					//Ship from ID - This value will come from LMS - should map to the warehouse code
					lsOut_SIKA += Space(9)
					lsOut_LMS += Space(9)
					
					//Ship From Name 1
					If lsWHName > "" Then
						lsOut_SIKA += Left(lsWHName,35) + Space(35 - Len(lsWHName))
						lsOut_LMS += Left(lsWHName,35) + Space(35 - Len(lsWHName))
					Else
						lsOut_SIKA += Space(35)
						lsOut_LMS += Space(35)
					End If
					
					//Ship From Name 2
					lsOut_SIKA += Space(30)
					lsOut_LMS += Space(30)
					
					//Ship From Addr 1
					If lsWHaddr1 > "" Then
						lsOut_SIKA += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
						lsOut_LMS += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship From Addr 2
					If lsWHaddr2 > "" Then
						lsOut_SIKA += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
						lsOut_LMS += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship From City
					If lsWHCity > "" Then
						lsOut_SIKA += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
						lsOut_LMS += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship From State
					If lsWHState > "" Then
						lsOut_SIKA += Left(lsWHState,2) + Space(2 - Len(lsWHState))
						lsOut_LMS += Left(lsWHState,2) + Space(2 - Len(lsWHState))
					Else
						lsOut_SIKA += Space(2)
						lsOut_LMS += Space(2)
					End If
					
					//Ship From Zip
					If lsWHZip > "" Then
						lsOut_SIKA += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
						lsOut_LMS += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
					Else
						lsOut_SIKA += Space(10)
						lsOut_LMS += Space(10)
					End If
					
					//Ship From Country
					If lsWHCountry > "" Then
						lsOut_SIKA += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
						lsOut_LMS += Left(lsWHCountry,2) + Space(2 - Len(lsWHCountry))
					Else
						lsOut_SIKA += Space(2)
						lsOut_LMS += Space(2)
					End If
						
					//Ship TO ID (Cust Code ??)
					If Not isnull(idsDoMain.GetItemString(1,'Cust_Code')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'Cust_Code'),9) + Space(9 - Len(idsDoMain.GetItemString(1,'Cust_Code')))
					Else
						lsOut_SIKA += Space(9)
						lsOut_LMS += Space(9)
					End If
					
					//Ship TO Name 1
					If Not isnull(idsDoMain.GetItemString(1,'Cust_Name')) Then 
						lsOut_SIKA += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
						lsOut_LMS += Left(idsDoMain.GetItemString(1,'Cust_Name'),35) + Space(35 - Len(idsDoMain.GetItemString(1,'Cust_Name')))
					Else
						lsOut_SIKA += Space(35)
						lsOut_LMS += Space(35)
					End If
					
					//Ship To Name 2
					lsOut_SIKA += Space(30)
					lsOut_LMS += space(30)
					
					//Ship TO  Address1
					lsTemp = idsDoMain.GetItemString(1,'address_1')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp,30) + Space(30 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp,30) + Space(30 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship TO  Address2
					lsTemp = idsDoMain.GetItemString(1,'address_2')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp,30) + Space(30 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp,30) + Space(30 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship TO  City
					lsTemp = idsDoMain.GetItemString(1,'city')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp,30) + Space(30 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp,30) + Space(30 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(30)
						lsOut_LMS += Space(30)
					End If
					
					//Ship TO State
					lsTemp = idsDoMain.GetItemString(1,'state')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp,2) + Space(2 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp,2) + Space(2 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(2)
						lsOut_LMS += Space(2)
					End If
					
					//Ship TO Zip
					lsTemp = idsDoMain.GetItemString(1,'zip')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp,10) + Space(10 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp,10) + Space(10 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(10)
						lsOut_LMS += Space(10)
					End If
					
					//Ship TO Country
					lsTemp = idsDoMain.GetItemString(1,'country')
					If Not isnull(lsTemp) Then 
						lsOut_SIKA += Left(lsTemp, 2) + Space(2 - Len(lsTemp))
						lsOut_LMS += Left(lsTemp, 2) + Space(2 - Len(lsTemp))
					Else
						lsOut_SIKA += Space(2)
						lsOut_LMS += Space(2)
					End If
					
				//TEMPO - PREFIX	
					// Write the record for SIKA
					llNewRow = idsOut.insertRow(0)
					idsOut.SetItem(llNewRow,'Project_id', asproject)
					idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
					idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
					idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
					idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 
				
				/*TEMPO!Maximum Script Size
					// Write the record for LMS
					llNewRow = idsOut.insertRow(0)
					idsOut.SetItem(llNewRow,'Project_id', asproject)
					idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeqLMS))
					idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
					idsOut.SetItem(llNewRow,'batch_data', lsOut_LMS)
					idsOut.SetItem(llNewRow,'file_name', lsPrefixLMS + String(ldBatchSeqLMS,'00000') + '.DAT') 
				*/
				Next /* 0 Shipped Detail Row*/
not sending 'Cancel' records for Sika*/

idsDODetail.SetFilter("")
idsDoDetail.Filter()

/*TEMPO! - commenting out to get past Maximum script size exceeded problem
//Add any Serial Number records (captured at Inbound for Maquet)
llRowCount = idsDOPick.RowCount()
For llRowPOs = 1 to llRowCount
	
	If idsDOPick.GetITemString(llRowPos,'Serial_no') = '-' Then Continue /*no serial number */
	
	//We need Maquet's Line # from Order Detail (uf2)
	lsSKU = idsDOPick.GetItemString(llRowPos, 'SKU')
	llLineItemNo = idsdoPick.GetItemNumber(llRowPos, 'Line_Item_No')
	llFindRow = idsDoDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineItemNo), 1, idsdoDetail.RowCount())

	llRecSeq ++
	lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
	lsOut_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	// Transaction Type - SE1 for Ready to Ship and SER for Goods Issue
	//If asTransType = 'RS' Then //TEMPO!!! Fix this ('RS' doesn't apply to SIKA model)
		lsOut_SIKA += 'SE1' 
		// 08/08/07 - lsLineNo should be set above from Pack list, but...
		lsLineNoSIKA = idsdoDetail.GetItemstring(llFindRow, 'User_Field2') //Send Maquet's Line No on 945P (back to Maquet)
		// 08/22/07 - need to zero-pad the line number for the 945P to Maquet (not the 945 to LMS)
		lsLineNoSIKA = String(long(lsLineNoSIKA), '000000')
	//Else
		lsOut_LMS += 'SER' 
		lsLineNoLMS = string(llLineItemNo)
	//End If

	//Use WH, Date, Time string from above...
	lsOut_SIKA += lsWh_Date_Time
	lsOut_LMS += lsWh_Date_Time

	lsOut_SIKA += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	lsOut_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	lsOut_SIKA += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */
	lsOut_LMS += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */

	/* Line Number (08/08/07 - added logic for Serial Records to pass Maquet Line in 945P)
	 - Either Line_Item_No on 945 to LMS or Maquet's Line No (User_Field2) on 945P to Maquet */
	//If Not isnull(idsDoPick.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
	//tempo 12/13/07 - see if lines are being set correctly here (Sika vs LMS).
	If Not isnull(lsLineNoSika) Then //TEMPO
		lsOut_SIKA += space(6 - len(lsLineNoSika)) + lsLineNoSika
	Else
		lsOut_SIKA += Space(6)
	End If

	If Not isnull(lsLineNoLMS) Then //TEMPO
		lsOut_LMS += space(6 - len(lsLineNoLMS)) + lsLineNoLMS
	Else
		lsOut_LMS += Space(6)
	End If

	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		//TEMPO - are we sending LMS Shipment to SIKA?
		lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
		lsOut_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOut_SIKA += Space(15)
		lsOut_LMS += Space(15)
	End If
	
	//Serial Number
	lsOut_SIKA += idsdoPick.GetItemString(llRowpos,'serial_no') + Space(20 - Len(idsdoPick.GetITEmString(llRowpos,'serial_no')))
	lsOut_LMS += idsdoPick.GetItemString(llRowpos,'serial_no') + Space(20 - Len(idsdoPick.GetITEmString(llRowpos,'serial_no')))
	
	// COO 
	If idsdoPick.GetItemString(llRowpos,'country_of_Origin') <> 'XXX' and idsdoPick.GetItemString(llRowPos,'country_of_Origin') > "" Then
		lsOut_SIKA += Left(idsdoPick.GetItemString(llRowPos,'country_of_Origin'),3) + Space(3 - Len(idsdoPick.GetItemString(llRowPos,'country_of_Origin')))
		lsOut_LMS += Left(idsdoPick.GetItemString(llRowPos,'country_of_Origin'),3) + Space(3 - Len(idsdoPick.GetItemString(llRowPos,'country_of_Origin')))
	Else
		lsOut_SIKA += Space(3)
		lsOut_LMS += Space(3)
	End If
	
	//Container ID - from packing
	lsCarton = ""
	lsFind = "Line_Item_No = " + String(idsdoPick.GetItemNumber(llRowpos,'Line_item_No')) + " and Upper(SKU) = '" + Upper(idsdoPick.GetItemString(llRowpos,'SKU')) + "'"
	llFindRow = idsDOPack.Find(lsFind,1,idsDOPAck.RowCount())
	Do While llFindRow > 0
		//TEMPO?
		//Serial NO should be listed in free form serial field, if not just take first carton for line/sku)
		
		If pos(idsDOPack.GetItemString(llFindRow,'free_form_serial_no'),idsdoPick.GetItemString(llRowpos,'serial_no')) > 0 Then
			lsCarton = idsDoPack.GetItemString(llFindROw,'carton_no')
			llFindRow = 0
		Else
			
			llFindRow ++
			If llFindRow > idsDOPack.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = idsDOPack.Find(lsFind,llFindRow,idsDOPAck.RowCount())
			End If
			
		End IF
		
	Loop
	
	//If not in freeform get from first carton for line/sku
	If lsCarton = "" Then
		llFindRow = idsDOPack.Find(lsFind,1,idsDOPAck.RowCount())
		If llFindRow > 0 Then
			lsCarton = idsDoPack.GetITEmString(llFindROw,'carton_no')
		End If
	End IF
	
	lsOut_SIKA += Left(lsCarton,20) + Space(20 - len(lsCarton))
	lsOut_LMS += Left(lsCarton,20) + Space(20 - len(lsCarton))
	
	// Write the record for SIKA
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeqLMS))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_LMS)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixLMS + String(ldBatchSeqLMS,'00000') + '.DAT') 
Next /*Picking record */
*/

//Add a CTN for each carton

idsDOPack.Sort()

llRowCount = idsDOPack.RowCount()
For llRowPOs = 1 to llRowCount
	
	If lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no') Then Continue /* 1 record per carton*/
	
	lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no')
	
	llRecSeq ++
	lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
	lsOut_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	// Transaction Type - SH1 for Ready to Ship and SHP for Goods Issue
	//If asTransType = 'RS' Then
		lsOut_SIKA += 'CT1' 
	//Else
		lsOut_LMS += 'CTN' 
	//End If

	//Use WH, Date, Time string from above...
	lsOut_SIKA += lsWh_Date_Time
	lsOut_LMS += lsWh_Date_Time
		
	/* LMS Shipment */
	lsTemp = idsDoMain.GetItemString(1,'User_Field4')
	If Not isnull(lsTemp) Then 
		lsOut_SIKA += Left(lsTemp,15) + Space(15 - Len(lsTemp))
		lsOut_LMS += Left(lsTemp,15) + Space(15 - Len(lsTemp))
	Else
		lsOut_SIKA += Space(15)
		lsOut_LMS += Space(15)
	End If
	
	lsTemp = Left(idsDoPack.GetItemString(llRowPOs,'carton_no'),20) + Space(20 - Len(idsDoPack.GetItemString(llRowPOs,'carton_no'))) /*Container ID*/
	lsOut_SIKA += lsTemp
	lsOut_LMS += lsTemp
	
	//Freight Cost
	If idsDOMain.GetItemNumber(1,'Freight_Cost') > 0 Then
		lsOut_SIKA += String(idsDOMAin.GEtItemNumber(1,'Freight_Cost'),"00000000000.00")
		lsOut_LMS += String(idsDOMAin.GEtItemNumber(1,'Freight_Cost'),"00000000000.00")
	Else
		lsOut_SIKA += "00000000000.00"
		lsOut_LMS += "00000000000.00"
	End If
	
	//Currency Code (USD or EUR???)
	lsOut_SIKA += "USD"
	lsOut_LMS += "USD"
	
	//Height
	If idsDOPack.GetItemNumber(llRowPos,'Height')  > 0 Then
		ldHeight = idsDOPack.GetItemNumber(llRowPOs,'Height') 	
		lsOut_SIKA += String(ldHeight,"000000000000000.0000")
		lsOut_LMS += String(ldHeight,"000000000000000.0000")
	Else
		lsOut_SIKA += "000000000000000.0000"
		lsOut_LMS += "000000000000000.0000"
	End If
	
	//Width
	If idsDOPack.GetItemNumber(llRowPos,'Width')  > 0 Then
		ldWidth = idsDOPack.GetItemNumber(llRowPOs,'Width') 
		lsOut_SIKA += String(ldWidth,"000000000000000.0000")
		lsOut_LMS += String(ldWidth,"000000000000000.0000")
	Else
		lsOut_SIKA += "000000000000000.0000"
		lsOut_LMS += "000000000000000.0000"
	End If
	
	//Length
	If  idsDOPack.GetItemNumber(llRowPos,'Length') > 0 Then
		ldLength = idsDOPack.GetItemNumber(llRowPOs,'Length') 
		lsOut_SIKA += String(ldLength,"000000000000000.0000")
		lsOut_LMS += String(ldLength,"000000000000000.0000")
	Else
		lsOut_SIKA += "000000000000000.0000"
		lsOut_LMS += "000000000000000.0000"
	End If
	
	//Dimension UOM - either CM or IN
	If idsDoPack.GetItemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOut_SIKA += "CM "
		lsOut_LMS += "CM "
	Else
		lsOut_SIKA += "IN "
		lsOut_LMS += "IN "
	End If
	
	//Volume
	ldVolume = ldHeight * ldWidth * ldLength
	lsOut_SIKA += String(ldVolume,"000000000000000.0000")
	lsOut_LMS += String(ldVolume,"000000000000000.0000")
	
	//Volume UOM - either CCM or CIN
	If idsDoPack.GetITemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOut_SIKA += "CCM"
		lsOut_LMS += "CCM"
	Else
		lsOut_SIKA += "CIN"
		lsOut_LMS += "CIN"
	End If
		
	//Gross Weight
	IF idsDOPack.GetItemNumber(llRowPOs,'Weight_Gross') > 0 Then
		ldGrossWeight = idsDOPack.GetItemNumber(llRowPOs,'Weight_Gross')
		lsOut_SIKA += String(ldGrossWeight,"000000000000000.0000")
		lsOut_LMS += String(ldGrossWeight,"000000000000000.0000")
	Else
		lsOut_SIKA += "000000000000000.0000"
		lsOut_LMS += "000000000000000.0000"
	End If
	
	//Net Weight
	If idsDOPack.GetItemNumber(llRowPOs,'Weight_Net') > 0 Then
		ldNetWeight = idsDOPack.GetItemNumber(llRowPOs,'Weight_Net') * idsDOPack.GetItemNumber(llRowPOs,'Quantity')
		lsOut_SIKA += String(ldNetWeight,"000000000000000.0000")
		lsOut_LMS += String(ldNetWeight,"000000000000000.0000")
	Else
		lsOut_SIKA += "000000000000000.0000"
		lsOut_LMS += "000000000000000.0000"
	End If
	
	//tare Weight - 0
	lsOut_SIKA += "000000000000000.0000"
	lsOut_LMS += "000000000000000.0000"
	
	//Weight UOM - either KGS or LBS
	If idsDoPack.GetItemString(llRowPos,'standard_of_measure') = 'M' Then
		lsOut_SIKA += "KGS"
		lsOut_LMS += "KGS"
	Else
		lsOut_SIKA += "LBS"
		lsOut_LMS += "LBS"
	End If
	
	//Tracking Numnber
	lsTemp = idsDoPack.GetItemString(llRowPOs,'shipper_tracking_id')
	If lsTemp > "" Then
		lsOut_SIKA += Left(lsTemp,30) + Space(30 - Len(lsTemp)) 
		lsOut_LMS += Left(lsTemp,30) + Space(30 - Len(lsTemp)) 
	Else
		lsOut_SIKA += Space(30)
		lsOut_LMS += Space(30)
	End If
			
	// Write the record for SIKA
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 

/*TEMPO!Maximum Script Size
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeqLMS))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOut_LMS)
	idsOut.SetItem(llNewRow,'file_name', lsPrefixLMS + String(ldBatchSeqLMS,'00000') + '.DAT') 
*/	
Next /*Pack Row*/

//Include any Lot Numbers from Picking for 945P only (Sika file)
//If asTransType = 'RS' Then
	
	llRowCount = idsDOPick.RowCount()
	For llRowPOs = 1 to llRowCount
	
		If idsDOPick.GetItemString(llRowPos,'lot_no') = '-' Then Continue /*no Lot number */
	
		llRecSeq ++
		lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
	
		// Transaction Type 
		lsOut_SIKA += 'LN1' 
	
		//Use WH, Date, Time string from above...
		lsOut_SIKA += lsWh_Date_Time

		lsOut_SIKA += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
		lsOut_SIKA += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */

		/*Line Item Number */
		// dts - 03/20/08 - We need SIKA's line from Order Detail...
		/*If Not isnull(idsDoPick.GetItemNumber(llRowPos,'Line_Item_No')) Then 
			lsOut_SIKA += String(idsDoPick.GetItemNumber(llRowPos,'Line_Item_No'),'000000')
		Else
			lsOut_SIKA += '000000'
		End If*/
		lsSKU = idsDOPick.GetItemString(llRowPos,'SKU')
		llLineItemNo = idsdoPick.GetItemNumber(llRowPos,'Line_Item_No')
		llFindRow = idsDoDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineItemNo), 1, idsdoDetail.RowCount())
		lsLineNoSIKA = idsdoDetail.GetItemstring(llFindRow, 'User_Field2') //Send SIKA's Line No on 945 (back to SIKA)
		// 08/22/07 - need to zero-pad the line number...
		lsLineNoSIKA = String(long(lsLineNoSIKA), '000000')
		
		If Not isnull(lsLineNoSIKA) Then 
			lsOut_SIKA += lsLineNoSIKA
		Else
			lsOut_SIKA += '000000'
		End If
	
		/* LMS Shipment */
		lsTemp = idsDoMain.GetItemString(1,'User_Field4')
		If Not isnull(lsTemp) Then 
			lsOut_SIKA += Left(lsTemp,15) + Space(15 - Len(lsTemp))
		Else
			lsOut_SIKA += Space(15)
		End If
	
		//Lot Number
		lsOut_SIKA += idsdoPick.GetItemString(llRowpos,'Lot_no') + Space(30 - Len(idsdoPick.GetItemString(llRowpos,'lot_no')))
	
		//Qty
		lsOut_SIKA += String(idsdoPick.GetItemNumber(llRowpos,'quantity') ,'000000000.00')
	
		// Write the record for SIKA
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
		idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 
	
/*TEMPO - Note above says Lot No is only for 945P. Need to verify */
	Next
	
//End If /* Ready to Ship*/

/*TEMPO! - commenting out to get past Maximum script size exceeded problem
//Include any Expiration Dates from Picking for 945P only (ready to Ship)
If asTransType = 'RS' Then
	
	llRowCount = idsDOPick.RowCount()
	For llRowPOs = 1 to llRowCount
	
		If String(idsDOPick.GetItemDateTime(llRowPos,'expiration_date'),'YYYYMMDD') = '29991231' Then Continue /*no Expiration Date */
	
		llRecSeq ++
		lsOut_SIKA = String(llRecSeq,'000000') /* Record Number*/
	
		// Transaction Type 
		lsOut_SIKA += 'EX1' 
	
		//Use WH, Date, Time string from above...
		lsOut_SIKA += lsWh_Date_Time
		lsOut_SIKA += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
		lsOut_SIKA += idsDoMain.GetItemString(1,'ord_type') + Space(3) /*Order Type */

		/*Line Item Number */
		If Not isnull(idsDoPick.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
			lsOut_SIKA += String(idsDoPick.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
		Else
			lsOut_SIKA += '000000'
		End If
	
		/* LMS Shipment */
		If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
			lsOut_SIKA += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
		Else
			lsOut_SIKA += Space(15)
		End If
	
		//Expiration Date
		lsOut_SIKA += String(idsdoPick.GetItemDateTime(llRowpos,'expiration_date') ,'YYYYMMDD')
	
		//Qty
		lsOut_SIKA += String(idsdoPick.GetItemNumber(llRowpos,'quantity') ,'000000000.00')
	
		// Write the record for SIKA
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOut_SIKA)
		idsOut.SetItem(llNewRow,'file_name', lsPrefixSIKA + String(ldBatchSeq,'00000') + '.DAT') 
	
/*TEMPO - Note above says Lot No is only for 945P. Need to verify
		// Write the record for LMS
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeqLMS))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOut_LMS)
		idsOut.SetItem(llNewRow,'file_name', lsPrefixLMS + String(ldBatchSeqLMS,'00000') + '.DAT') 
		*/
	Next
	
End If /* Ready to Ship*/
*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0

end function

public function integer uf_lms_itemmaster ();
//Create an Item master update file for LMS - all items that have changed since last run

String	lsLogOut, sql_syntax, Errors, lsOutString_LMS, lsSKU, lsTemp
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

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('SIKA', 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to LMS!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create the Item Datastore...
ldsItem = Create Datastore
sql_syntax = "SELECT SKU, Supp_code, User_field4, User_field5, Description, Freight_Class, Shelf_Life, uom_1, uom_2, uom_3, uom_4, qty_2, qty_3, qty_4,  weight_1, weight_2, weight_3, weight_4, " 
sql_syntax += " Length_1, length_2, length_3, length_4, Width_1, width_2, width_3, width_4, height_1, height_2, height_3, height_4 "
sql_syntax += " From Item_Master "
sql_syntax += " Where Project_ID = 'SIKA' and Interface_Upd_Req_Ind = 'Y';"
ldsItem.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for SIKA Item Master extract (SIMS->LMS.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsItem.SetTransObject(SQLCA)


lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIMS -> LMS Item Master update for SIKA... " 
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrieve all of the ITem Master Records for Project
llRowCount = ldsItem.Retrieve()

//Update to pending so we can reset at end when sucessfully written
Update Item_Master
Set Interface_Upd_Req_Ind = 'X'
Where Project_ID = 'SIKA' and Interface_Upd_Req_Ind = 'Y';

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
	lsOutString_LMS += "CRANB " /*Warehouse - hardcoded for now as is not relevant to Item Master*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	//If we received it with a supplier, send it back with a supplier (assuming that if we defaulted it, the supplier will be 'Maquet' or existing supplier is numeric
	// always send # as seperator even if not present
	
	lsSKU = ldsItem.GetItemString(lLRowPos,'Sku')
	
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
	//For sika, Freight Class is usually of the format 55-1. Just sending the '55' to LMS
	lsTemp = ldsItem.GetItemString(lLRowPos,'freight_class')
	if pos(lsTemp, '-', 1) > 0 then
		lsTemp = left(lsTemp, pos(lsTemp, '-', 1)-1)
	end if
	If lsTemp > "" and isnumber(lsTemp) Then
		lsOutString_LMS +=  String(Dec(lsTemp),'00000000.0')
	Else
		lsOutString_LMS += "00000000.0"
	End If
	
	lsOutString_LMS += "00000000.0000" /*Maximum Qty*/
	lsOutString_LMS += "00000000.0000" /*Minimum Qty*/
	
	//Shelf Life
	If ldsItem.GetItemNumber(llRowPos, 'shelf_life') > 0 Then
		lsOutString_LMS += String(ldsItem.GetItemNumber(llRowPos, 'shelf_life'),'00000000')
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
	idsOut.SetItem(llNewRow,'Project_id', 'SIKA')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'N832' + String(ldBatchSeq,'00000') + '.DAT') 
		
Next /* Item Master Record*/

//Write the Outbound File 
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, 'SIKA')

//Reset update status on rows processed
Update Item_Master
Set Interface_Upd_Req_Ind = 'N'
Where Project_ID = 'SIKA' and Interface_Upd_Req_Ind = 'X';

Commit;

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Maquet for the Stock Adjustment just made
/* Not implemented for SIKA...
Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsWarehouse, lsMaquetwarehouse, lsRONO, lsOrder, lsPosNeg, lsExpDate

Decimal		ldBatchSeq, ldNetQty
Integer		liRC
String	lsLogOut

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsAdjustment) Then
	idsAdjustment = Create Datastore
	idsAdjustment.Dataobject = 'd_adjustment'
	idsAdjustment.SetTransObject(SQLCA)
End If

//Retrieve the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = idsAdjustment.GetITemString(1,'ro_no')

lsSku = idsAdjustment.GetITemString(1,'sku')
lsSupplier = idsAdjustment.GetITemString(1,'supp_code')

//If Supplier <> 'Maquet' then concatonate with SKU
If Upper(lsSupplier) <> 'MAQUET' Then
	lsSKU = lsSupplier + "#" + lsSKU
End If

lsReason = idsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''
	
lsOldInvType = idsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")

llOwnerID = idsAdjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsAdjustment.GetITemNumber(1,"old_owner")

llAdjustID = idsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")

lsExpDate = String(idsAdjustment.GetITemDateTime(1,"expiration_date"),'YYYYMMDD')

		
//We are only sending Qty Change or Breakage (New Inv Type = 'D')
//If lsNewInvType = 'D' or (llNewQTY <> llOldQTY)  Then
	
	//Set TransType
	If llOldQty <> llNewQty Then
		lsTranType = 'QTY'
	Elseif lsOldInvType <> lsNewInvType Then
		lsTranType = 'INV'
	Else
		lsTranType = 'OTH'
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
		
	Select user_field1 into :lsMaquetwarehouse
	From Warehouse
	Where wh_code = :lsWarehouse;
	
	If isnull(lsMaquetwarehouse) Then lsMaquetwarehouse = lswarehouse
	
	lsOutString = 'MM|' /*rec type = Material Movement*/
	lsOutString += lsTranType + "|" 
	lsOutString += left(lsOldInvType,1) + "|" /*old Inv Type*/
	lsOutString += left(lsNewInvType,1) + "|" /*New Inv Type*/
	lsOutString += String(today(),'yyyymmddHHMMSS') + "|" 
	lsOutString += Left(lsReason,20) + "|"  /*reason*/
	lsOutString += Left(lsSku,50) + "|" 
	lsOutString += String(llOldQty) + "|" 
	lsOutString += String(llNewQty) + "|" 
	lsOutString += String(alAdjustID) + "|" /*Transaction Number*/
	lsOutString += lsRONO + "|"  /* Ref NUmber*/
	lsOutString += + "|"  /*Owner*/
	lsOutString += lsMaquetwarehouse + "|" 
	
	// Package Code (PO_NO)
	If idsAdjustment.GetITemString(1,"PO_No") <> '-' Then
		lsOutString += idsAdjustment.GetITemString(1,"PO_No") + "|"
	Else
		lsOutString += "|"
	End If
	
	// Lot_NO
	If idsAdjustment.GetITemString(1,"Lot_No") <> '-' Then
		lsOutString += idsAdjustment.GetITemString(1,"Lot_No") + "|"
	Else
		lsOutString += "|"
	End If
		
	//Expiration Date
	If lsExpDate <> "29991231" Then
		lsOutString += lsExpDate
	End If
	
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'N947' + String(ldBatchSeq,'000000') + ".DAT"
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	// Add a trailer Row
	lsOutString = '1|TR| |' /*record count always = 1, action code is blank */
	lsOutString += String(today(),'HHMMSS') + "|"
	lsOutString += " |"
	lsOutString += String(today(),'YYYYMMDD') 
	
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'N947' + String(ldBatchSeq,'000000') + ".DAT"
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
//End If /* inv type changed*/
		

*/
Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for SIKA for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lswarehouse, lsMaquetWarehouse, lsComplete

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

//We need the SIKA warehouse Code
lsWarehouse = idsromain.GetITemString(1,'wh_code')
		
Select user_field1 into :lsMaquetwarehouse
From Warehouse
Where wh_code = :lsWarehouse;
	
If isnull(lsMaquetwarehouse) Then lsMaquetwarehouse = lswarehouse

//For each sku/inventory type in Putaway, write an output record - 
//multiple putaways may be combined in a single output record (multiple locs, etc for an inv type)

llRowCount = idsROPutaway.RowCount()

For llRowPos = 1 to llRowCount
	
	// Rolling up to Line/Sku/Supplier/Inv Type/Po_no (Pkg Cd)/Lot/Expiration Date
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos,'SKU')) + "' and po_item_number = " + string(idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
	lsFind +=  " and upper(supp_code) = '" + upper(idsROPutaway.GetItemString(llRowPos,'Supp_code')) + "'"
	lsFind += " and upper(inventory_type) = '" + upper(idsROPutaway.GetItemString(llRowPos,'inventory_type')) + "'"
	lsFind += " and upper(po_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'po_no')) + "'"
	lsFind += " and upper(lot_no) = '" + upper(idsROPutaway.GetItemString(llRowPos,'lot_no')) + "'"
	lsFind += " and expiration_date = '" + String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'YYYYMMDD') + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		//idsGR.SetItem(llNewRow,'po_number',idsROMain.GetItemString(1,'supp_invoice_no'))
		// 02/07/08 - somehow invoice is getting a leading space so trim-ing now...
		idsGR.SetItem(llNewRow,'po_number', trim(idsROMain.GetItemString(1,'supp_invoice_no')))
		idsGR.SetItem(llNewRow,'complete_date',idsROMain.GetItemDateTime(1,'complete_date'))
		idsGR.SetItem(llNewRow,'Inventory_type',idsROPutaway.GetItemString(llRowPos,'inventory_type'))
		idsGR.SetItem(llNewRow,'sku',idsROPutaway.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'supp_code',idsROPutaway.GetItemString(llRowPos,'supp_code'))
		idsGR.SetItem(llNewRow,'quantity',idsROPutaway.GetItemNumber(llRowPos,'quantity'))
		idsGR.SetItem(llNewRow,'po_item_number',idsROPutaway.GetItemNumber(llRowPos,'line_item_no'))
		idsGR.SetItem(llNewRow,'po_no',idsROPutaway.GetItemString(llRowPos,'po_no')) /*Maquet Pkg Code */
		idsGR.SetItem(llNewRow,'lot_no',idsROPutaway.GetItemString(llRowPos,'lot_no'))
		idsGR.SetItem(llNewRow,'expiration_date',String(idsROPutaway.GetItemDateTime(llRowPos,'expiration_date'),'YYYYMMDD'))
		
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
	lsOutString += lsMaquetWarehouse + "|"
	lsOutString += idsGR.GetItemString(llRowPos,'inventory_type') + '|'
	lsOutString += String(idsGR.GetItemDateTime(llRowPos,'complete_date'),'yyyymmdd') + '|'
	
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'po_number') + '|'
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	// 12/12/07 lsOutString += idsGR.GetItemString(llRowPos,'po_no') + '|' /* Pkg Cd */
	If idsGR.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'po_no') + '|' /* Pkg Cd */
	Else
		lsOutString += "NA|"
	End If
	
	If idsGR.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += idsGR.GetItemString(llRowPos,'lot_no') + '|' /* Lot */
	Else
		lsOutString += "|"
	End If
	
	If idsGR.GetItemString(llRowPos,'expiration_date') <> "29991231" Then
		lsOutString += idsGR.GetItemString(llRowPos,'expiration_date') + '|' /* Expiration Date */
	Else
		lsOutString += "|"
	End If
	
	//Line Item Complete - Compare Req Qty to Alloc Qty on Detail Record
	lsComplete = "N"
	llFindRow = idsRODetail.Find("Line_item_No = " + String(idsGR.GetItemNumber(llRowPos,'po_item_number')),1, idsRODetail.RowCOunt())
	If llFindRow > 0 Then
		If idsRODetail.GetItemNumber(llFindRow,'req_qty') = idsRODetail.GetITemNumber(llFindRow,'alloc_qty') Then
			lsComplete = 'Y'
		End If
	End If
	
	lsOutString += lsComplete
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', 'N944' + String(ldBatchSeq,'00000') + '.DAT') 
	
next /*next output record */

//Add a trailer Record
llNewRow = idsOut.insertRow(0)
lsOutString = 'EOF'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', 'N944' + String(ldBatchSeq,'00000') + '.DAT') 

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

on u_nvo_edi_confirmations_sika.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_sika.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

