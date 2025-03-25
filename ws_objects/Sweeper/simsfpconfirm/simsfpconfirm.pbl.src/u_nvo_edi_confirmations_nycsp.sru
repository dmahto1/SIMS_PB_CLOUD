$PBExportHeader$u_nvo_edi_confirmations_nycsp.sru
$PBExportComments$Process outbound edi confirmation transactions for NYCSP
forward
global type u_nvo_edi_confirmations_nycsp from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_nycsp from nonvisualobject
end type
global u_nvo_edi_confirmations_nycsp u_nvo_edi_confirmations_nycsp

type variables

String	isGIFileName, isTRFileName, isGRFileName, isINVFileName
Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment,idsROMain, idsRODetail, idsROPutaway, idsGR

string lsDelimitChar
end variables

forward prototypes
public function integer uf_lms_itemmaster ()
public function integer uf_gi (string asproject, string asdono, string astype)
public function integer uf_gi_lms (string asproject, string asdono, string astype)
public function integer uf_gi_old (string asproject, string asdono, string astype)
end prototypes

public function integer uf_lms_itemmaster ();//Create an Item master update file for LMS - all items that have changed since last run

String	lsLogOut, sql_syntax, Errors, lsOutString_LMS, lsSKU
DataStore	ldsItem
Long	llRowPos, llRowCount, llNewRow, llRecSeq
Dec	ldBatchSeq, ldQty, ldTemp
Int	liRC
DateTime	ldtToday

ldtToday = DateTime(today(),Now())

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('NYCSP','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create the Item Datastore...
ldsItem = Create Datastore
sql_syntax = "SELECT SKU, Supp_code, User_field4, User_field5, Description, Freight_Class, Shelf_Life, uom_1, uom_2, uom_3, uom_4, qty_2, qty_3, qty_4,  weight_1, weight_2, weight_3, weight_4, " 
sql_syntax += " Length_1, length_2, length_3, length_4, Width_1, width_2, width_3, width_4, height_1, height_2, height_3, height_4, standard_of_measure "
sql_syntax += " From Item_Master "
sql_syntax += " Where Project_ID = 'NYCSP' and Interface_Upd_Req_Ind = 'Y';"
ldsItem.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Nycsp Item Master extract (SIMS->LMS.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsItem.SetTransObject(SQLCA)


lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIMS -> LMS Item Master update for Nycsp... " 
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
Where Project_ID = 'NYCSP' and Interface_Upd_Req_Ind = 'Y';

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
	lsOutString_LMS += "BETHPG" /*Warehouse - hardcoded for now as is not relevent to Item Master*/
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	//If we received it with a supplier, send it back with a supplier (assuming that if we defaulted it, the supplier will be 'Nycsp' or existing supplier is numeric
	// always send # as seperator even if not present
	
//	If ldsItem.GetItemString(lLRowPos,'supp_code') = 'Nycsp' or isnumber(ldsItem.GetItemString(lLRowPos,'supp_code')) Then
//	If ldsItem.GetItemString(lLRowPos,'supp_code') = 'NYCSP'  Then
		lsSKU = ldsItem.GetItemString(lLRowPos,'Sku')
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
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'weight_1')
	If ldTemp > 0 Then
		if ldsItem.GetItemString(llRowPos, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 2
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'weight_2')
	If ldTemp > 0 Then
		if ldsItem.GetItemString(llRowPos, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 3
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'weight_3')
	If ldTemp > 0 Then
		if ldsItem.GetItemString(llRowPos, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 4
	//dts - 10/08 - now converting Wgt to Kilos, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'weight_4')
	If ldTemp > 0 Then
		if ldsItem.GetItemString(llRowPos, 'standard_of_measure') = 'E' then
			ldTemp = ldTemp * 0.45359237
		end if
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'height_1')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'height_2')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'height_3')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'height_4')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Width_1')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Width_2')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Width_3')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Width_4')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
		
	//Length 1
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Length_1')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 2
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Length_2')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 3
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Length_3')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 4
	//dts - 10/08 - now converting DIMs to Metric, if necessary
	ldTemp = ldsItem.GetItemNumber(llRowPos, 'Length_4')
	If ldTemp > 0 Then
		lsOutString_LMS += String(ldTemp,'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If	
	
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'NYCSP')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'N832' + String(ldBatchSeq,'00000') + '.DAT') 
		
Next /* Item Master Record*/

//Write the Outbound File 
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'NYCSP')

//Reset update status on rows processed
Update Item_Master
Set Interface_Upd_Req_Ind = 'N'
Where Project_ID = 'NYCSP' and Interface_Upd_Req_Ind = 'X';

Commit;


Return 0
end function

public function integer uf_gi (string asproject, string asdono, string astype);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed

//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	ls_Description, lsTemp, lssku,   lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//If Not isvalid(idsDOMain) Then
//	idsDOMain = Create Datastore
//	idsDOMain.Dataobject = 'd_do_master'
//	idsDOMain.SetTransObject(SQLCA)
//End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_picking_nycsp'
	idsDoDetail.SetTransObject(SQLCA)
End If



idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDODetail.Retrieve(asDoNo) < 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//idsDoDetail.Retrieve(asDoNo)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//10-Jan-2014 :Madhu- NYCSP- CR- Generate GI- START
If idsDODetail.getItemString(1,'Ord_Type') <> 'S' Then
	lsLogOut =" *** GI file is not generated for an order :"+ asDONO + " due to Order Type is not 'Sale'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
//10-Jan-2014 :Madhu- NYCSP- CR- Generate GI- END

//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoDetail.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoDetail.GetITEmString(llRowPos,'sku')

	
	
	lsOutString = 'GI' + lsDelimitChar
	lsOutString = idsDoDetail.GetItemString(1,'wh_code') + lsDelimitChar 	//Warehouse	C(10)	Yes		Shipping Warehouse
	lsOutString += lsSku  + lsDelimitChar		//SKU


	//Description
	If idsDoDetail.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'Description')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	lsOutString += String( idsdoDetail.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar  //Picked Qty
			
	//Container ID	C(25)	No	N/A	
	lsTemp = idsdoDetail.GetITemString(llRowPos,'Container_ID')
	If IsNull(lsTemp) then lsTemp = ''
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
			
	lsOutString += idsDoDetail.GetItemString(1,'Invoice_no') + lsDelimitChar	 //Delivery Number	C(10)	Yes	N/A	Delivery Order Number
			
	//shipping complete date
	lsTemp = String( idsDoDetail.GetItemDateTime(1,'complete_date'),'yyyy/mm/dd hh:mm') 
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	
			
	//Cust Code
	If idsDoDetail.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
		
	//Ship To Name
	If idsDoDetail.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
			
	//Ship Address 1	
	If idsDoDetail.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//Ship Address 2	
	If idsDoDetail.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
		
	//Ship Address 3	
	If idsDoDetail.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
			
	//Ship Address 4	
	If idsDoDetail.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
			
	//Ship City	
	If idsDoDetail.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
			
	//Ship State	
	If idsDoDetail.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
			
	//Ship Postal Code	
	If idsDoDetail.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
			
	//complete Date
			
	lsTemp = String( idsDoDetail.GetItemDateTime(1,'receive_date'),'yyyy-mm-dd') 
	If IsNull(lsTemp) then lsTemp = ''
		lsOutString += lsTemp
	
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.RNM'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

public function integer uf_gi_lms (string asproject, string asdono, string astype);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed

//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

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
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline'  //MEA - Commented out for Babycare. - No rows returned for Babycare.  // TAM 9/26/12 FIxed the datawindow to return rows
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
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

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

// TAM - 10/01/2012 - Look for Detail using LineItemNo(There should only be one)  This is needed because on the picklist there may be component skus that are not on the detail row but need to be included on the output.
//	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	llDetailFind = idsDoDetail.Find("line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

	llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())



	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“GI”	Goods issue confirmation identifier
	
	//MEA - 8/12 - If the file is being generated from a ‘Ready to Ship’ transaction, the Record ID will be ‘RS’ instead of ‘GI’. This is a baseline change.
	
	IF lsOrdStatus = 'R' THEN
		lsOutString = 'RS' + lsDelimitChar	
	ELSE
		lsOutString = 'GI' + lsDelimitChar
	END IF

	
	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsOutString +=  asproject + lsDelimitChar

	
	//Warehouse	C(10)	Yes		Shipping Warehouse
	
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
	//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
	
	
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	

	
	//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
	
		lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += lsSku  + lsDelimitChar	
	

	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file

//MEA -  Commented out for Babycare. // TAM 9/26/12 FIxed the datawindow to return rows

//	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar

	If 	idsdoPick.GetITemString(llRowPos,'Serial_No') <> '' Then
		lsOutString += '1' + lsDelimitChar
	Else
		lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	End If
	
	
	//Inventory Type	C(1)	Yes	N/A	Item condition
	

	lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field

	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field

	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present

	lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Container ID	C(25)	No	N/A	
		
	lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//Price	N(12,4)	No	N/A	
	
	
	lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//Ship Date	Date	No	N/A	Actual Ship date

	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery

	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		//BCR 30-DEC-2011: Geistlich UAT fix...
//		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//Carrier	C (20)	No	N/A	Input by user
	
	If idsDoMain.GetItemString(1,'Carrier') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	
	//Freight Cost	N(10,3)	No	N/A	
	
	lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))

	IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
	
	lsOutString += lsFreight_Cost + lsDelimitChar
		
	
	//Freight Terms	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'Freight_Terms') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Freight_Terms')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//Total Weight	N(12,2)	No	N/A	
	
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		
	
	
	//Transportation Mode	C(10)	No	N/A	
	
	If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			

	
	//Delivery Date	Date	No	N/A	
	
	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//Detail User Field1	C(20)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail User Field2	C(20)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field3	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field4	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field5	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field6	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//Detail User Field7	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//Detail User Field8	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			

//	//Master User Field1	C(10)	No	N/A	User Field	
//	
//	If idsDoMain.GetItemString(1,'user_field1') <> '' Then
//		lsOutString += String(idsDoMain.GetItemString(1,'user_field1')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	
	
	//Master User Field2	C(10)	No	N/A	User Field
	
	
	If idsDoMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Master User Field3	C(10)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field4	C(20)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field5	C(20)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Master User Field6	C(20)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field7	C(30)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field8	C(60)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field9	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field10	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field11	C(30)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field12	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field13	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field14	C(50)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field15	C(50)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field16	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field16') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field17	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field17') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field18	C(100)	No	N/A	User Field
	
	If idsDoMain.GetItemString(1,'user_field18') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//CustomerCode	
	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Ship To Name
	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Address 1	
	
	If idsDoMain.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Address 2	
	
	If idsDoMain.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//Ship Address 3	
	
	If idsDoMain.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//BCR 14-DEC-2011: Data Map requires address_4
	
	//Ship Address 4	
	
	If idsDoMain.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship City	
	
	If idsDoMain.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship State	

		If idsDoMain.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Ship Postal Code	
	
	If idsDoMain.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Ship Country

	If idsDoMain.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//UnitOfMeasure (weight)
	
	//EWMS has the Package Weight hardcoded to “1.0”. I am assuming that is the UPM (Weight) field.
	
	//MEA - Outstand question to Pete - value of field - just pass place holder for now.

	lsOutString += lsDelimitChar

	//UnitOfMeasure (quantity)	

	If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If

	//CountryOfOrigin	
	 lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')

	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	


	//Master User Field19	
	
	If idsDoMain.GetItemString(1,'user_field19') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Master User Field20	

	If idsDoMain.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//Master User Field21	
	
	If idsDoMain.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If				
		

	//Master User User Field22	

	If idsDoMain.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) //+ lsDelimitChar
	Else
//		lsOutString +=lsDelimitChar
	End If		
	
	
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */


IF ProfileString(gsinifile, asproject, "IncludeGIPackDetail",'N')  = 'Y' THEN

	//Get the Project / Warehouse defaults for UCC
	
	lsWHCode = idsDoMain.GetItemString(1,'wh_code')
	
	SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :asproject USING SQLCA;
	
	IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
	
	SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;
	
	IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''
			
	
	llRowCount = idsDoPack.RowCount()
	
	For llRowPos = 1 to llRowCOunt
	
		llNewRow = idsOut.insertRow(0)
	
	
		lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
		lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
		lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
		lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
		lsSOM = idsdoPack.GetITEmString(llRowPos,'standard_of_measure')
	
		//Record_ID (‘PK’)
	
		lsOutString = 'PK' + lsDelimitChar	
	
		//Project ID	C(10)	Yes	N/A	Project identifier
		
		lsOutString +=  asproject + lsDelimitChar
		
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
		
		//Carton Number 
		
		//On the Packing Segment, we need to prefix the carton number with the Project level and Warehouse level UCC values. 
		//Carton Number will end up being an 18 digit value consisting of ‘Project.UCC_Company_Prefix’ (8) + ‘Warehouse.UCC_Location_Prefix’(1) + ‘Delivery_Packing.Carton_No’ (9).  This can be baseline as those fields will be blank if not used.
		
		lsCartonNo = idsdoPack.GetITemString(llRowPos, 'Carton_No')
		
		If lsCartonNo <> '' Then
			
			lsCartonNo = String( LONG (idsdoPack.GetITemString(llRowPos, 'Carton_No')) , "000000000" )
			
			lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
			
			//From BaseLine
			
			liCheck = f_calc_uccs_check_Digit(lsUCCS) 
		
			
			If liCheck >=0 Then
				lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
			Else
				lsUCCS = "00" + String(lsUCCS,'00000000000000000000') + "0"
			End IF
			
			lsOutString += lsUCCS  + lsDelimitChar
			
			
	
		END IF
		
		//Line Item Number
		
		lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
		
		//SKU
		
		lsOutString += lsSku  + lsDelimitChar	
		
		//Qty
		
		lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
		//Weight (Gross for carton, repeated for all records)
		
		//Need to validate. - Make sure this is summing up correctly.
		
		If String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 
						
		
		//Weight Unit (for the current line/SKU) KG or LB
		 
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		
		//Weight SOM (standard of meas)
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Carton Length
	 
		If String(idsDoPack.GetItemNumber(llRowPos,'Length')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Length')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			 
					 
					 
		
		//Carton Width
		 
		 If String(idsDoPack.GetItemNumber(llRowPos,'Width')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Width')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
						 
		 
		
		//Carton Height
					
		 If String(idsDoPack.GetItemNumber(llRowPos,'Height')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Height')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
							
		
		//Carton DIM SOM (standard of meas) IN or CM
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'IN' + lsDelimitChar
			ELSE
				lsOutString += 'CM' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Ship Tracking Number
		
	
			 If idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	    
	
		
		//User Field 1
		
		If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//User Field 2
		
		If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  //+ lsDelimitChar
		Else
	//		lsOutString +=lsDelimitChar
		End If		
	
			
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	
	next /*next Delivery Pack record */

END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

public function integer uf_gi_old (string asproject, string asdono, string astype);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed

//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

Long llDetailFind, llPackFind

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
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
//	idsDoPick.Dataobject = 'd_do_Picking'
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline'  //MEA - Commented out for Babycare. - No rows returned for Babycare.  // TAM 9/26/12 FIxed the datawindow to return rows
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating GI For DONO: " + asDONO
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

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//10-Jan-2014 :Madhu- NYCSP- CR- Generate GI- START
If idsDOMain.getItemString(1,'Ord_Type') <> 'S' Then
	lsLogOut =" *** GI file is not generated for an order :"+ asDONO + " due to Order Type is not 'Sale'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
//10-Jan-2014 :Madhu- NYCSP- CR- Generate GI- END

//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

// TAM - 10/01/2012 - Look for Detail using LineItemNo(There should only be one)  This is needed because on the picklist there may be component skus that are not on the detail row but need to be included on the output.
//	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	llDetailFind = idsDoDetail.Find("line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

	llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())



	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“GI”	Goods issue confirmation identifier
	
	//MEA - 8/12 - If the file is being generated from a ‘Ready to Ship’ transaction, the Record ID will be ‘RS’ instead of ‘GI’. This is a baseline change.
	
	IF lsOrdStatus = 'R' THEN
		lsOutString = 'RS' + lsDelimitChar	
	ELSE
		lsOutString = 'GI' + lsDelimitChar
	END IF
	
	//10-Jan-2014 :Madhu- NYCSP -CR -Generate GI -START
	IF lsOrdStatus <> 'R' and asproject ='NYCSP' THEN
			
						
			lsOutString = idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar 	//Warehouse	C(10)	Yes		Shipping Warehouse
			lsOutString += lsSku  + lsDelimitChar		//SKU
			lsOutString += idsdoPick.GetItemString(1,'Description') + lsDelimitChar  //SKU -Description
			lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar  //Picked Qty
			
			//Container ID	C(25)	No	N/A	
			lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
			If IsNull(lsTemp) then lsTemp = ''
			If  lsTemp <> '-' Then
				lsOutString += lsTemp + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
			
			lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	 //Delivery Number	C(10)	Yes	N/A	Delivery Order Number
			
			//shipping complete date
			lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy/mm/dd hh:mm') 
			If IsNull(lsTemp) then lsTemp = ''
			lsOutString += lsTemp+ lsDelimitChar	
			
			//Cust Code
			
			If idsDoMain.GetItemString(1,'cust_code') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
		
			//Ship To Name
			
			If idsDoMain.GetItemString(1,'cust_name') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Address 1	
			
			If idsDoMain.GetItemString(1,'address_1') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Address 2	
			
			If idsDoMain.GetItemString(1,'address_2') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
		
			//Ship Address 3	
			
			If idsDoMain.GetItemString(1,'address_3') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Address 4	
			
			If idsDoMain.GetItemString(1,'address_4') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship City	
			
			If idsDoMain.GetItemString(1,'city') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship State	
		
				If idsDoMain.GetItemString(1,'state') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//Ship Postal Code	
			
			If idsDoMain.GetItemString(1,'zip') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//complete Date
			
			lsTemp = String( idsDoMain.GetItemDateTime(1,'receive_date'),'yyyy-mm-dd') 
			If IsNull(lsTemp) then lsTemp = ''
			lsOutString += lsTemp+ lsDelimitChar	
	
	ELSE   //10-Jan-2014 :Madhu -NYCSP- CR-Generate GI- END
		
			//Project ID	C(10)	Yes	N/A	Project identifier
			
			lsOutString +=  asproject + lsDelimitChar
		
			
			//Warehouse	C(10)	Yes		Shipping Warehouse
			
			lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
			
			//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
			
			
			lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
		
			
			//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
			
				lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
			
			//SKU	C(50)	Yes	N/A	Material number
		
		
			lsOutString += lsSku  + lsDelimitChar	
			
		
			
			//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
			
		//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file
		
		//MEA -  Commented out for Babycare. // TAM 9/26/12 FIxed the datawindow to return rows
		
		//	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
			If 	idsdoPick.GetITemString(llRowPos,'Serial_No') <> '' Then
				lsOutString += '1' + lsDelimitChar
			Else
				lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
			End If
			
			
			//Inventory Type	C(1)	Yes	N/A	Item condition
			
		
			lsOutString += String( idsdoPick.GetITemString(llRowPos,'Inventory_Type')) + lsDelimitChar
			
			//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
			
			lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar	
			
			//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
		
			lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')
			
			If IsNull(lsTemp) then lsTemp = ''
			
			If  lsTemp <> '-' Then
				lsOutString += lsTemp + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
		
			lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')
			
			If IsNull(lsTemp) then lsTemp = ''
			
			If  lsTemp <> '-' Then
				lsOutString += lsTemp + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Serial Number	C(50)	No	N/A	Qty must be 1 if present
		
			lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')
			
			If IsNull(lsTemp) then lsTemp = ''
			
			If  lsTemp <> '-' Then
				lsOutString += lsTemp + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
			
			//Container ID	C(25)	No	N/A	
				
			lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
			
			If IsNull(lsTemp) then lsTemp = ''
		
			If  lsTemp <> '-' Then
				lsOutString += lsTemp + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
			
			//Expiration Date	Date	No	N/A	
		
			lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		
		
			//Price	N(12,4)	No	N/A	
			
			
			lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar	
			
			
			//Ship Date	Date	No	N/A	Actual Ship date
		
			lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar
		
			
			//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
		
			lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar
			
			
			
			//Ship Tracking Number	C(25)	No	N/A	
			
			If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
				//BCR 30-DEC-2011: Geistlich UAT fix...
		//		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
				lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If				
			
			//Carrier	C (20)	No	N/A	Input by user
			
			If idsDoMain.GetItemString(1,'Carrier') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If				
			
			
			//Freight Cost	N(10,3)	No	N/A	
			
			lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))
		
			IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
			
			lsOutString += lsFreight_Cost + lsDelimitChar
				
			
			//Freight Terms	C(20)	No	N/A	
			
			If idsDoMain.GetItemString(1,'Freight_Terms') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'Freight_Terms')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If				
			
			//Total Weight	N(12,2)	No	N/A	
			
			IF llPackFind > 0 then
				lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
			Else
				lsTemp = ""	
			End If
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar		
			
			
			//Transportation Mode	C(10)	No	N/A	
			
			If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If			
		
			
			//Delivery Date	Date	No	N/A	
			
			lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
			
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar	
			
			//Detail User Field1	C(20)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
			
			//Detail User Field2	C(20)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Detail User Field3	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Detail User Field4	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Detail User Field5	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Detail User Field6	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If			
			
			//Detail User Field7	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If			
			
			//Detail User Field8	C(30)	No	N/A	User Field
			
			If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If			
		
		//	//Master User Field1	C(10)	No	N/A	User Field	
		//	
		//	If idsDoMain.GetItemString(1,'user_field1') <> '' Then
		//		lsOutString += String(idsDoMain.GetItemString(1,'user_field1')) + lsDelimitChar
		//	Else
		//		lsOutString += lsDelimitChar
		//	End If	
			
			//Master User Field2	C(10)	No	N/A	User Field
			
			
			If idsDoMain.GetItemString(1,'user_field2') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
		
			//Master User Field3	C(10)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field3') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
		
			//Master User Field4	C(20)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field4') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
		
			//Master User Field5	C(20)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field5') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
				
			//Master User Field6	C(20)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field6') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
		
			//Master User Field7	C(30)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field7') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
		
			//Master User Field8	C(60)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field8') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
		
			//Master User Field9	C(30)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field9') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field10	C(30)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field10') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field11	C(30)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field11') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field12	C(50)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field12') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field13	C(50)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field13') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If	
			
			//Master User Field14	C(50)	No	N/A	User Field
		
			If idsDoMain.GetItemString(1,'user_field14') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field15	C(50)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field15') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field16	C(100)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field16') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field17	C(100)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field17') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If		
			
			//Master User Field18	C(100)	No	N/A	User Field
			
			If idsDoMain.GetItemString(1,'user_field18') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//CustomerCode	
			
			If idsDoMain.GetItemString(1,'cust_code') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//Ship To Name
			
			If idsDoMain.GetItemString(1,'cust_name') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Address 1	
			
			If idsDoMain.GetItemString(1,'address_1') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Address 2	
			
			If idsDoMain.GetItemString(1,'address_2') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
		
			//Ship Address 3	
			
			If idsDoMain.GetItemString(1,'address_3') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//BCR 14-DEC-2011: Data Map requires address_4
			
			//Ship Address 4	
			
			If idsDoMain.GetItemString(1,'address_4') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship City	
			
			If idsDoMain.GetItemString(1,'city') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship State	
		
				If idsDoMain.GetItemString(1,'state') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//Ship Postal Code	
			
			If idsDoMain.GetItemString(1,'zip') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Ship Country
		
			If idsDoMain.GetItemString(1,'country') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
			
			//UnitOfMeasure (weight)
			
			//EWMS has the Package Weight hardcoded to “1.0”. I am assuming that is the UPM (Weight) field.
			
			//MEA - Outstand question to Pete - value of field - just pass place holder for now.
		
			lsOutString += lsDelimitChar
		
			//UnitOfMeasure (quantity)	
		
			If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
				lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
			Else
				lsOutString += lsDelimitChar
			End If
		
			//CountryOfOrigin	
			 lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')
		
			If IsNull(lsTemp) then lsTemp = ''
			
			lsOutString += lsTemp+ lsDelimitChar	
		
		
			//Master User Field19	
			
			If idsDoMain.GetItemString(1,'user_field19') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If		
			
			//Master User Field20	
		
			If idsDoMain.GetItemString(1,'user_field20') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If	
		
			//Master User Field21	
			
			If idsDoMain.GetItemString(1,'user_field21') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
			Else
				lsOutString +=lsDelimitChar
			End If				
				
		
			//Master User User Field22	
		
			If idsDoMain.GetItemString(1,'user_field22') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) //+ lsDelimitChar
			Else
		//		lsOutString +=lsDelimitChar
			End If		

END IF  //10-Jan-2014 :Madhu -NYCSP- CR-Generate GI -Added
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.RNM'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */


IF ProfileString(gsinifile, asproject, "IncludeGIPackDetail",'N')  = 'Y' THEN

	//Get the Project / Warehouse defaults for UCC
	
	lsWHCode = idsDoMain.GetItemString(1,'wh_code')
	
	SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :asproject USING SQLCA;
	
	IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
	
	SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;
	
	IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''
			
	
	llRowCount = idsDoPack.RowCount()
	
	For llRowPos = 1 to llRowCOunt
	
		llNewRow = idsOut.insertRow(0)
	
	
		lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
		lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
		lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
		lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
		lsSOM = idsdoPack.GetITEmString(llRowPos,'standard_of_measure')
	
		//Record_ID (‘PK’)
	
		lsOutString = 'PK' + lsDelimitChar	
	
		//Project ID	C(10)	Yes	N/A	Project identifier
		
		lsOutString +=  asproject + lsDelimitChar
		
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
		
		//Carton Number 
		
		//On the Packing Segment, we need to prefix the carton number with the Project level and Warehouse level UCC values. 
		//Carton Number will end up being an 18 digit value consisting of ‘Project.UCC_Company_Prefix’ (8) + ‘Warehouse.UCC_Location_Prefix’(1) + ‘Delivery_Packing.Carton_No’ (9).  This can be baseline as those fields will be blank if not used.
		
		lsCartonNo = idsdoPack.GetITemString(llRowPos, 'Carton_No')
		
		If lsCartonNo <> '' Then
			
			lsCartonNo = String( LONG (idsdoPack.GetITemString(llRowPos, 'Carton_No')) , "000000000" )
			
			lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
			
			//From BaseLine
			
			liCheck = f_calc_uccs_check_Digit(lsUCCS) 
		
			
			If liCheck >=0 Then
				lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
			Else
				lsUCCS = "00" + String(lsUCCS,'00000000000000000000') + "0"
			End IF
			
			lsOutString += lsUCCS  + lsDelimitChar
			
			
	
		END IF
		
		//Line Item Number
		
		lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
		
		//SKU
		
		lsOutString += lsSku  + lsDelimitChar	
		
		//Qty
		
		lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
		//Weight (Gross for carton, repeated for all records)
		
		//Need to validate. - Make sure this is summing up correctly.
		
		If String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 
						
		
		//Weight Unit (for the current line/SKU) KG or LB
		 
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
	
		
		//Weight SOM (standard of meas)
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Carton Length
	 
		If String(idsDoPack.GetItemNumber(llRowPos,'Length')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Length')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			 
					 
					 
		
		//Carton Width
		 
		 If String(idsDoPack.GetItemNumber(llRowPos,'Width')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Width')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
						 
		 
		
		//Carton Height
					
		 If String(idsDoPack.GetItemNumber(llRowPos,'Height')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Height')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	 			
							
		
		//Carton DIM SOM (standard of meas) IN or CM
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'IN' + lsDelimitChar
			ELSE
				lsOutString += 'CM' + lsDelimitChar
			END IF
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//Ship Tracking Number
		
	
			 If idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	    
	
		
		//User Field 1
		
		If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//User Field 2
		
		If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  //+ lsDelimitChar
		Else
	//		lsOutString +=lsDelimitChar
		End If		
	
			
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.RNM'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	
	next /*next Delivery Pack record */

END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

on u_nvo_edi_confirmations_nycsp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_nycsp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;lsDelimitChar = char(9)
end event

