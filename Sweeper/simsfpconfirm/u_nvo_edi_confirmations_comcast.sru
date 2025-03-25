HA$PBExportHeader$u_nvo_edi_confirmations_comcast.sru
$PBExportComments$Process outbound edi confirmation transactions for Comcast
forward
global type u_nvo_edi_confirmations_comcast from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_comcast from nonvisualobject
end type
global u_nvo_edi_confirmations_comcast u_nvo_edi_confirmations_comcast

type variables

String			isGIFileName, isTRFileName, isGRFileName, isINVFileName
String			isOMSProduct, isOMSCode, isOMSMake,isOMSName, isOMSModel, isDeviceType, isOMSProductNbr
string 		isXML, isXMLHeader, isXMLBody, isXMLFooter, isFileName
decimal 		idBatchSeq
boolean 		ibNoFreightCost

Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack, idsOut, idsAdjustment,idsROMain, idsRODetail, idsROPutaway, idsGR
Datastore 	idsWOMain, idsWODetail, idsWOPutaway, idsroSerialCarton, idsdoSerialCarton, idsDevices, idsMultiMac

end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi_sik (string asdono)
public function integer uf_lms_gi (string asproject, string asdono)
public function integer uf_lms_itemmaster ()
protected function string uf_map_address (ref datastore ldsserial, long alrow, string ascolumn, string asgroup)
public function integer uf_gi_oms_blk (string asdono)
public function integer uf_gi (string asproject, string asdono)
public function long getomsproperties (long _lineitemno)
public function integer getfileopen ()
public function integer closeandsendfile (integer _fileno)
public function integer setdevicebody (integer _devicenbr)
public function integer uf_multiple_mac_id (string asproject, string asorderid, long altransid)
public function integer uf_missing_from_site (string asproject, string asorderid, long altranid)
public function integer uf_dupe_record (string asproject, string asorderid, long altranid)
public function integer uf_insert_error (string asproject, string asorderid, long altranid)
public function integer uf_missing_sku_in_im (string asproject, string asorderid, long altranid)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Diebold for the order that was just confirmed
// GWM - 6/3/2011 - Add Attribute Level Processing with Attributes 1 through 5 using CartonSerial user_field6 through 10

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lswarehouse,  lsComcastwarehouse,lsComplete, lsserial, lssku, lssuppcode, lsSkuHold, lsGroup, lsPalletSave
String     lsModel, lsOrdNo, lsAddress[], lsWhType

Decimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idsromain = Create Datastore
	idsromain.Dataobject = 'd_ro_master'
	idsroMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsroSerialCarton) Then
	idsroSerialCarton = Create Datastore
	idsroSerialCarton.Dataobject = 'd_ro_serial_carton'
	idsroSerialCarton.SetTransObject(SQLCA)
End If

idsOut.Reset()

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsOrdNo =  idsromain.GetITemString(1,'supp_invoice_no')

//We need the Comcast warehouse Code 
lsWarehouse = idsromain.GetITemString(1,'wh_code')
		
Select user_field1, wh_type into :lsComcastwarehouse, :lsWhType
From Warehouse
Where wh_code = :lsWarehouse;

If IsNull(lsComcastwarehouse) THEN lsComcastwarehouse = ''

// *****  03/10 - PCONKL - If this is an SIK warehouse, do note sned anything to EIS  ******
If lsWhType = 'S' Then
		lsLogOut = "                  No transaction to EIS for SIK receipt  For RONO: " + asRONO
		FileWrite(gilogFileNo,lsLogOut)
		Return 0
End If


 idsroSerialCarton.Retrieve(asproject, asRONO)
 
 //Sort by Pallet so we can file break on Pallet
 idsroSerialCarton.SetSort("pallet_ID A")
 idsroSerialCarton.Sort()

//   Loop through the Putaway list and for each distinct Pallet_Id (Lot_No), retrieve all of the records from $$HEX1$$1c20$$ENDHEX$$carton_serial$$HEX2$$1d202000$$ENDHEX$$for that Pallet_ID.

//For each carton serial record, create a record to send to ICC (layout attached) $$HEX2$$13202000$$ENDHEX$$pipe delimited 

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//string lsCurrentPalletID, 

integer  liCurrentFileNum = 1, liCurrentFileCount = 0

llRowCount = idsroSerialCarton.RowCount()

//we dont want the first record to cause a file break on Pallet
If llRowCount > 0 Then
	lsPalletSave = idsroSerialCarton.GetItemString(1, "pallet_id")
End If

For llRowPos = 1 to llRowCount
	
	lssku = idsroSerialCarton.GetItemString(llRowPos, "sku")
	lssuppcode = idsroSerialCarton.GetItemString(llRowPos, "supp_code")
	
	If lsSKU <> lsskuHold Then
	
		 SELECT Item_Master.User_Field10 , grp
  		INTO :lsModel, :lsGroup
    		FROM Item_Master  
   		WHERE ( Item_Master.Project_ID = :asproject ) AND  
         		( Item_Master.SKU = :lssku ) AND  
         		( Item_Master.Supp_Code = :lssuppcode )   ;
					
		lsSkuHold = lsSKU
					
	End If
	
	liCurrentFileCount = liCurrentFileCount + 1
	
//	lsCurrentPalletID = idsroSerialCarton.GetItemString(llRowPos, "pallet_id")
	
//	if lsCurrentPalletID <> lsLastPalletID then

	llNewRow = idsOut.insertRow(0)
	
	
	lsOutString = 'TRC|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TRC$$HEX1$$1920$$ENDHEX$$
	lsOutString += '' + "|"  //From Site ID - blanks
	lsOutString += lsComcastwarehouse + '|' //To Site ID -  Warehouse.User_Field1
	
	
	If IsNull(lsOrdNo) THEN lsOrdNo = ''
	lsOutString += lsOrdNo + '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$SIMS Order Number (??)
	
	lsOutString += '' + '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		

	lsOutString+= '' + '|'  //Start Date

	// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
	lsOutString+= '' + '|'  //Status
		
	//Pallet ID 
	If idsroSerialCarton.GetItemString(llRowPos, "Pallet_ID") <> '-'  Then
		lsOutString += idsroSerialCarton.GetItemString(llRowPos, "Pallet_ID")	 + "|"
	Else
		lsOutString += '' + '|'
	End If
	
	lsOutString += lsOrdNo + '|'  /* BOL NO - SIMS Order?? */
		
	// ***  End New Fields ***
				
		
	// 05/10 - Serial No is mapped differently depending on Product type (CPE vs DTA)
	// 10/10 - PCONKL - Serial now mapped by REportstore and will always be in the Serial_No field
//	Choose Case Upper(lsGroup)
//			
//		Case "CPE"
//			
//			lsserial = idsroSerialCarton.GetItemString(llRowPos, "user_field5")	/*field 19 - M-Card Serial*/
//			
//			// 07/10 - PCONKL - If a product is mislabeled as CPE, the M-Card Serial wont be available.
//			If IsNull(lsserial) or lsSerial = '' THEN
//				lsserial = idsroSerialCarton.GetItemString(llRowPos, "Serial_No")	
//			End If
//			
//		Case else /*Default to DTA */
//			lsserial = idsroSerialCarton.GetItemString(llRowPos, "Serial_No")	
//			
//	End Choose
	
	lsserial  = uf_map_address(idsroSerialCarton, llRowPos,"SERIAL_NO",lsGroup)
	
	If IsNull(lsserial) THEN lsserial = ''
	
	lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$Serial_No from Carton_Serial record 
	lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
	
	if IsNull(lsModel) THEN lsModel = ''
	lsOutString += lsModel + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10

	// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
	
	//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   				DTA = MAC Address (MAC_ID)
	//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
	//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)							DTA = Blank
	//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)					DTA = Blank
	//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)

	// 08/10 - Per Chris Smolen and Jim martin, Address 1 and 2 need to be swapped for DTA product.
	
	// 05/10 - PCONKL - Mapping different for CPE or DTA product
	//10/10 - PCONKL - Mapping now done by REportStore. For any converted records, map generically Addr 1-5, otherwise use existing logic
//	Choose Case Upper(lsGroup)
//			
//		Case "CPE"
//			
//				lsAddress[1] =  idsroSerialCarton.GetItemString(llRowPos, "user_field3")
//				lsAddress[2] =  idsroSerialCarton.GetItemString(llRowPos, "serial_no")
//				lsAddress[3] =  idsroSerialCarton.GetItemString(llRowPos, "mac_id")
//				lsAddress[4] =  idsroSerialCarton.GetItemString(llRowPos, "user_field4")
//				lsAddress[5] =  idsroSerialCarton.GetItemString(llRowPos, "user_field2")
//
//		Case Else /* Default to DTA */
//			
//			//lsAddress[1] =  idsroSerialCarton.GetItemString(llRowPos, "mac_id")
//			//lsAddress[2] =  idsroSerialCarton.GetItemString(llRowPos, "user_field1")
//			
//			lsAddress[1] =  idsroSerialCarton.GetItemString(llRowPos, "user_field1")
//			lsAddress[2] =  idsroSerialCarton.GetItemString(llRowPos, "mac_id")
//			
//			lsAddress[3] = ""
//			lsAddress[4] = ""
//			lsAddress[5] = ""
//			
//	
//	End Choose

// GWM - 6/3/2011 - Add addresses 6 through 10 for Attribute Level Processing

	lsAddress[1] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS1",lsGroup)
	lsAddress[2] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS2",lsGroup)
	lsAddress[3] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS3",lsGroup)
	lsAddress[4] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS4",lsGroup)
	lsAddress[5] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS5",lsGroup)
	lsAddress[6] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS6",lsGroup)
	lsAddress[7] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS7",lsGroup)
	lsAddress[8] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS8",lsGroup)
	lsAddress[9] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS9",lsGroup)
	lsAddress[10] = uf_map_address(idsroSerialCarton, llRowPos,"ADDRESS10",lsGroup)
	
	if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
	if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
	if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
	if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
	if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
	if IsNull(lsAddress[6]) THEN lsAddress[6] = ""
	if IsNull(lsAddress[7]) THEN lsAddress[7] = ""
	if IsNull(lsAddress[8]) THEN lsAddress[8] = ""
	if IsNull(lsAddress[9]) THEN lsAddress[9] = ""
	if IsNull(lsAddress[10]) THEN lsAddress[10] = ""
	
	lsOutString += lsAddress[1] + '|'  
	lsOutString += lsAddress[2] + '|' 
	lsOutString += lsAddress[3] + '|'  
	lsOutString += lsAddress[4] + '|' 
	lsOutString += lsAddress[5] + '|'   
	lsOutString += lsAddress[6] + '|'  
	lsOutString += lsAddress[7] + '|' 
	lsOutString += lsAddress[8] + '|'  
	lsOutString += lsAddress[9] + '|' 
	lsOutString += lsAddress[10]   


	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
//	idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 

	// 05/10 - PCONKL - In addition to a 1000 record limit, we want to start a new file per Pallet (will most likely always be < 1000 records per pallet
	IF liCurrentFileCount >= 1000 or idsroSerialCarton.GetItemString(llRowPos, "Pallet_ID") <> lsPalletSave THEN

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If	
	
		liCurrentFileCount = 0
		
		liCurrentFileNum = liCurrentFileNum + 1
		
	END IF
	
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') /* 7/10 - PCONKL - Moved from above so first rec of new pallet is in new file*/
	
	lsPalletSave = idsroSerialCarton.GetItemString(llRowPos, "Pallet_ID")
	
next /*next output record */

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
	
	

end function

public function integer uf_adjustment (string asproject, long aladjustid);String	lsLogOut, lsSku, lsOldInvType, lsNewInvType, sql_syntax, errors, lsItemGroup, lsSupplier, lsEISModel, lsOutString, lsWarehouse, lsComcastWarehouse,lsserial, lsAddress[]
integer	liRC, liCurrentFileNum, liCurrentFileCount
Decimal	ldBatchSeq
Long	llOldQty, llNewQty, llAdjustID, llSerialPos, llSerialCount, llNewRow
DataStore	ldsCartonSerial


liCurrentFileCount = 0
liCurrentFileNum = 1

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

idsOut.Reset()
idsAdjustment.Reset()

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsSku = idsAdjustment.GetITemString(1,'sku')
lsSupplier = idsAdjustment.GetITemString(1,'Supp_Code')
lsOldInvType = idsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")

llAdjustID = idsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")
		
//We are only Sending a record for an Inventory Type or Qty changing to zero - (pallet being deleted)

If lsOldInvType = lsNewInvType and llNewQty = llOldQty Then Return 0

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//We need the ITem Group to determine if it is DTA or CPE product
Select grp, User_Field10 into :lsItemGroup, :lsEISModel
From Item_MASter
Where project_id = 'Comcast' and sku = :lsSKU and supp_Code = :lsSupplier;

If isnull(lsItemGroup) then lsItemGroup = ''
If isnull(lsEISModel) then lsEISModel = ''

//We need the Site ID
lsWarehouse = idsAdjustment.GetITemString(1,'wh_code')
		
Select user_field1 into :lsComcastwarehouse
From Warehouse
Where wh_code = :lsWarehouse;

If IsNull(lsComcastwarehouse) THEN lsComcastwarehouse = ''


//Build the Serial Number DS from Carton_Serial
ldsCartonSerial = Create Datastore
sql_syntax = "SELECT * From Carton_Serial "
sql_syntax += " Where Project_ID = 'Comcast' and Pallet_id = '" + idsAdjustment.GetItemString(1,'Lot_no') + "';"
ldsCartonSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Carton_Serial Data" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsCartonSerial.SetTransObject(SQLCA)

If llNewQty = 0 Then /*Pallet being Deleted - Send a Delete (TUP)*/

	llSerialCount = ldsCartonSerial.Retrieve()
	
	//For each Serial Number, write a TUP
	For llSerialPos = 1 to llSerialCount
		
		llNewRow = idsOut.insertRow(0)
		liCurrentFileCount ++
		
		lsOutString = 'TUP|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TUP$$HEX1$$1920$$ENDHEX$$
		lsOutString += lsComcastwarehouse + '|' //FROM Site ID -  Warehouse.User_Field1
		lsOutString += lsComcastwarehouse + '|' //To Site ID -  Warehouse.User_Field1
		lsOutString += String(alAdjustID) + '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$Adjustment ID
		lsOutString += '' + '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		
		lsOutString+= '' + '|'  //Start Date

		// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
		lsOutString+= '' + 'DELETED|'  //Status = DELETED
		
		//Pallet ID (Lot_no)
		If idsAdjustment.GetITemString(1,"lot_no") <> '-' Then
			lsOutString += idsAdjustment.GetITemString(1,"lot_no") + "|"
		Else
			lsOutString += '' + '|'
		End If
		
		lsOutString += '' + '|' /* BOL NO */
		
		// ***  End New Fields ***
		
		// 05/10 - Serial No is mapped differently depending on Product type (CPE vs DTA)
//		10/10 - PCONKL - If mapped from REportStore or EIS, Serial will always be in the serial field. They will determine which serial to use and will always be in the serial field

//		Choose Case Upper(lsItemGroup)
//			
//			Case "CPE"
//				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "user_field5")	/*field 19 - M-Card Serial*/
//			Case else /*Default to DTA */
//				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
//			
//		End Choose

		lsSerial = uf_map_address(ldsCartonSerial, llSerialPos,"Serial_no",lsItemGroup)
	
		If IsNull(lsserial) or lsSerial = '-' THEN lsserial = ''
	
		lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$Serial_No from Carton_Serial record 
		lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
		lsOutString += lsEISModel + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10

		//blanks for addresses	
		lsOutString += '|'  
		lsOutString +=  '|' 
		lsOutString +=  '|'  
		lsOutString +=  '|' 
		//lsOutString +=  ** last field*/


		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		

		IF liCurrentFileCount >= 1000 THEN

			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
			ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
			If ldBatchSeq <= 0 Then
				lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
				FileWrite(gilogFileNo,lsLogOut)
				Return -1
			End If	
	
			liCurrentFileCount = 0
		
			liCurrentFileNum = liCurrentFileNum + 1
		
		END IF
		
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 
	
	next /*Serial*/
	
	//Write the Outbound File
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


ElseIf lsOldInvType = 'S' and lsNewInvType = 'N' Then /*changing from No serial to Serial, we need to send a TRC since it wasnt sent at receipt*/
	
	llSerialCount = ldsCartonSerial.Retrieve()
	
	//For each Serial Number, write a TRC
	For llSerialPos = 1 to llSerialCount
		
		llNewRow = idsOut.insertRow(0)
		liCurrentFileCount ++
		
		lsOutString = 'TRC|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TRC$$HEX1$$1920$$ENDHEX$$
		lsOutString += '' + "|"  //From Site ID - blanks
		lsOutString += lsComcastwarehouse + '|' //To Site ID -  Warehouse.User_Field1
		lsOutString += String(alAdjustID) + '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$Adjustment ID
		lsOutString += '' + '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		
		lsOutString+= '' + '|'  //Start Date

		// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
		lsOutString+= '' + '|'  //Status
		
		//Pallet ID (Lot_no)
		If idsAdjustment.GetITemString(1,"lot_no") <> '-' Then
			lsOutString += idsAdjustment.GetITemString(1,"lot_no") + "|"
		Else
			lsOutString += '' + '|'
		End If
		
		lsOutString += '' + '|' /* BOL NO */
		
		// ***  End New Fields ***
		
		// 05/10 - Serial No is mapped differently depending on Product type (CPE vs DTA)
//		Choose Case Upper(lsItemGroup)
//			
//			Case "CPE"
//				
//				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "user_field5")	/*field 19 - M-Card Serial*/
//				
//				// 07/10 - PCONKL - If a product is mislabeled as CPE, the M-Card Serial wont be available.
//				If IsNull(lsserial) or lsSerial = '' THEN
//					lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
//				End If
//			
//			Case else /*Default to DTA */
//				
//				lsserial = ldsCartonSerial.GetItemString(llSerialPos, "Serial_No")	
//			
//		End Choose

		lsSerial = uf_map_address(ldsCartonSerial, llSerialPos,"Serial_no",lsItemGroup)
	
		If IsNull(lsserial) or lsSerial = '-' THEN lsserial = ''
	
		lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$Serial_No from Carton_Serial record 
		lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
		lsOutString += lsEISModel + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10

		// DTA vs CPE address fields are mapped differently for CPE and DTA (Item Group)
	
		//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   				DTA = MAC Address (MAC_ID)
		//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (Serial_NO),		DTA = Unit Address (UF1)
		//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)							DTA = Blank
		//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)					DTA = Blank
		//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)

		// 08/10 - Per Chris Smolen and Jim martin, Address 1 and 2 need to be swapped for DTA product.
		
		// 05/10 - PCONKL - Mapping different for CPE or DTA product
		//10/10 - PCONKL - Address mappings now done by REportstore, just passthrough what was loaded
//		Choose Case Upper(lsItemGroup)
//			
//			Case "CPE"
//			
//				lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field3")
//				lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "serial_no")
//				lsAddress[3] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
//				lsAddress[4] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field4")
//				lsAddress[5] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field2")
//
//			Case Else /* Default to DTA */
//			
//				//lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
//				//lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field1")
//				
//				lsAddress[1] =  ldsCartonSerial.GetItemString(llSerialPos, "user_field1")
//				lsAddress[2] =  ldsCartonSerial.GetItemString(llSerialPos, "mac_id")
//				
//				lsAddress[3] = ""
//				lsAddress[4] = ""
//				lsAddress[5] = ""
//		
//		End Choose

		lsAddress[1] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS1",lsItemGroup)
		lsAddress[2] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS2",lsItemGroup)
		lsAddress[3] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS3",lsItemGroup)
		lsAddress[4] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS4",lsItemGroup)
		lsAddress[5] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS5",lsItemGroup)
		lsAddress[6] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS6",lsItemGroup)
		lsAddress[7] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS7",lsItemGroup)
		lsAddress[8] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS8",lsItemGroup)
		lsAddress[9] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS9",lsItemGroup)
		lsAddress[10] = uf_map_address(ldsCartonSerial, llSerialPos,"ADDRESS10",lsItemGroup)
	
		if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
		if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
		if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
		if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
		if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
		if IsNull(lsAddress[6]) THEN lsAddress[6] = ""
		if IsNull(lsAddress[7]) THEN lsAddress[7] = ""
		if IsNull(lsAddress[8]) THEN lsAddress[8] = ""
		if IsNull(lsAddress[9]) THEN lsAddress[9] = ""
		if IsNull(lsAddress[10]) THEN lsAddress[10] = ""
	
		lsOutString += lsAddress[1] + '|'  
		lsOutString += lsAddress[2] + '|' 
		lsOutString += lsAddress[3] + '|'  
		lsOutString += lsAddress[4] + '|' 
		lsOutString += lsAddress[5] + '|'    
		lsOutString += lsAddress[6] + '|'  
		lsOutString += lsAddress[7] + '|' 
		lsOutString += lsAddress[8] + '|'  
		lsOutString += lsAddress[9] + '|' 
		lsOutString += lsAddress[10]   


		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//	idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 

		IF liCurrentFileCount >= 1000 THEN

			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
			ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
			If ldBatchSeq <= 0 Then
				lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
				FileWrite(gilogFileNo,lsLogOut)
				Return -1
			End If	
	
			liCurrentFileCount = 0
		
			liCurrentFileNum = liCurrentFileNum + 1
		
		END IF
		
		idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000' + '-' + string(liCurrentFileNum) ) + '.DAT') 
	
	next /*Serial*/
	
	//Write the Outbound File
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
End If /*Delete or Inv Type Change */


Return 0
end function

public function integer uf_gi_sik (string asdono);String	lsLogout, lsXML, sql_syntax, errors, lsFind,  lsSerial, lsOutString, lsCarton, lsCartonSave, lsAddr1, lsAddr2
String	lsWarehouse, lsComcastwarehouse, lsSKU, lsSuppCode, lsSkuHold, lsModel, lsGroup, lsAddress[], lsProduct
Integer	liRC
Long	llRowCOunt, llRowPos, llFindRow, llQty, llQtyPos, llNewRow, llDeviceIdNO, llLineItemNo, llLoopPos, llLoopCount
Decimal	ldWEight, ldBatchSeq
DataStore	ldsProducts, ldsDEvices, ldsSerial
Time	ltCompleteTime
Boolean	lbNoFreightCost

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out_external'  /*larger batch_data since not writing to DB*/
	lirc = idsOut.SetTransobject(sqlca)
End If

idsOut.Reset()

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

idsdoPack.Reset()

//Get the Order Details in a DS
// 01/12 - PCONKL - Changing to an Outer Join to Delivery_Serial_Detail to allow for non-serialized parts
//TAM 2012/03/37  Moved OMS Product (Fullfilment Code) to UF18
ldsProducts = Create Datastore
sql_syntax = " Select  DElivery_Picking_Detail.Line_Item_No, DElivery_Picking_Detail.Quantity,  DElivery_Picking_Detail.Inventory_Type,  Item_MAster.Grp, Item_master.User_Field11 as oms_product_nbr, Item_master.User_Field12 as oms_Code, "
sql_Syntax += " Item_master.USer_Field13 as oms_make,  Item_master.User_Field14 as oms_name,  Item_master.USer_Field15 as oms_model, Item_master.USer_Field16 as device_type , delivery_serial_Detail.Serial_no, Item_master.User_Field18 as oms_product "

//sql_syntax += " FRom delivery_picking_detail, Delivery_serial_detail, Item_MAster "
//sql_Syntax += " Where ITem_Master.Project_id = 'COMCAST' and delivery_picking_detail.id_no = delivery_serial_detail.id_no and Delivery_picking_Detail.SKU = Item_MAster.SKU "
//sql_syntax += " and Delivery_Picking_Detail.supp_Code = Item_Master.supp_Code and do_no = '" + asDONO + "'"

sql_Syntax += "FROM {oj Delivery_Picking_Detail LEFT OUTER JOIN Delivery_Serial_Detail ON Delivery_Picking_Detail.ID_No = Delivery_Serial_Detail.ID_No},   Item_Master  "
sql_Syntax += " Where ITem_Master.Project_id = 'COMCAST' and  Delivery_picking_Detail.SKU = Item_MAster.SKU "
sql_syntax += " and Delivery_Picking_Detail.supp_Code = Item_Master.supp_Code and do_no = '" + asDONO + "'"

sql_Syntax += " Order by  DElivery_Picking_Detail.Line_Item_No;"

ldsProducts.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Shipped Products" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsProducts.SetTransObject(SQLCA)
llRowCount = ldsProducts.retrieve()


//Get THe devices records for this ORder (sent in Order request)
ldsDevices = Create Datastore
//sql_syntax = "Select * from comcast_devices where do_no = '" + asDONO + "'"
sql_syntax = "Select ID_NO, DO_NO, Line_Item_No, Product_ID, Device_ID, Device_Type, Serial_No, Unit_ID, RFMAC_ID, MAC_ID, 'N' as Record_Used from comcast_devices where do_no = '" + asDONO + "'"

ldsDevices.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Shipped Devices" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsDevices.SetTransObject(SQLCA)
ldsDevices.Retrieve()

//Clear out any existing serial numbers in case we are reconfirming the order...
llRowCount = ldsDevices.RowCount()
For llRowPos =1 to llRowCount
	ldsDevices.SetItem(llRowPos,'Serial_no','')
	If isnull(ldsDevices.GetITemString(llRowPos,'device_type')) Then ldsDevices.SetItem(llRowPos,'device_type','')
Next



//Retreive Delivery Master
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsLogOut = "        Creating GI for Comcast SIK order  For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Need gross weight - first pack row of carton should have the total gross weight for the carton, not just that line's worth*/
idsDoPack.Retrieve(asDoNo)
idsDoPack.SetSort("carton_no A")
idsDOPack.Sort()

llRowCount = idsdoPack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsCarton = idsdoPack.GetITemString(llRowPos,'carton_no')
	If lsCarton <> lsCartonSave Then
		ldWeight += idsdoPack.GetITemNumber(llRowPos,'weight_gross')
		lsCartonSave = lsCarton
	End If
	
Next

//Update the weight onto the Delivery Master for reporting purposes
Update Delivery_MAster
Set Weight = :ldWeight
Where do_no = :asDONO;

Commit;

// XML Header info
lsXML = "<?xml version=~"1.0~" encoding=~"UTF-8~"?>"
lsXML += "<PostShipment xmlns=~"http://comcastonline.com/~">"
lsXML += "<Request>"
lsXML += "<OrderID>" + trim(idsDOMAin.GetITemString(1,'invoice_no')) +  "</OrderID>" /* SIMS Order NUmber*/

lsXML += "<Shipments>"
lsXML += "<Shipment>"

//Carrier
lsXML += "<Carrier>UPS</Carrier>"

//Date
//12/10 - PCONKL - For now, convert time to Pacific Time.
ltCompleteTime = Time(idsDOMain.GetITEmDateTime(1,'Complete_Date'))

Choose Case Upper(idsdoMain.GetITemString(1,'wh_code'))
		
	Case 'COM-SIK-MO', 'COM-SIK-AT' /*Monroe and Atlanta need to subtract 3 hours to get to PST*/
		ltCompleteTime = RelativeTime(ltCompletetime,-10800)
	Case 'COM-SIK-AU' /* Aurora - 2 */
		ltCompleteTime = RelativeTime(ltCompletetime,-7200)
	Case 'COM-SIK-FR' /*Already PST*/
		
End Choose

 lsXML += "<Date>" 
// lsXML += String(idsDOMain.GetITEmDateTime(1,'Complete_Date'),"yyyy-mm-dd") + "T" + String(RelativeTime(Time(idsDOMain.GetITEmDateTime(1,'Complete_Date')),-7200),'hh:mm:ss') /* subtract 2 hours (7200 seconds) - hardcoded for Central time (aurora) right now*/
 lsXML += String(idsDOMain.GetITEmDateTime(1,'Complete_Date'),"yyyy-mm-dd") + "T" + String(ltCompleteTime,'hh:mm:ss')
 lsXML += "</Date>"
 
 //Method
lsXML += "<Method>"

If idsdoMain.GetITemString(1,'ship_via') > '' Then
	
	Choose Case Upper(idsdoMain.GetITemString(1,'ship_via'))
		Case 'STANDARD'
			lsXML += "Standard"
		Case 'OVERNIGHT'
			lsXML += "Overnight"
		case else
			lsXML += "Standard"
	End Choose
		
Else
	lsXML += "Standard"
End If

lsXML += "</Method>"

//Packages 
lsXML += "<Packages>"
lsXML += "<Package>"

//Cost
lsXML += "<Cost>"

If idsdoMain.GetITemDecimal(1,'Freight_Cost') > 0 Then
	lsXML += String(idsdoMain.GetITemDecimal(1,'Freight_Cost'),'####0.00')
Else
	lsXML += "0.00"
	lbNoFreightCost = True /* 05/11 - PCONKL - Freight cost is sometimes not applied when their is a DB lock in the TRAX process. for a band-aid, we will suppress sending to Comcast until manually fixed...*/
End If

lsXML += "</Cost>"

//Tracking Number
lsXML += "<TrackingNumber>"

If Not isnull(idsdoMain.GetITemString(1,'awb_bol_no')) Then
	lsXML += idsdoMain.GetITemString(1,'awb_bol_no')
End If

lsXML += "</TrackingNumber>"

//Return Tracking Number - no value included
//10/11 - PCONKL - for RMA orders, include return tracking number
If idsdoMain.GetITemString(1,'ord_type') = 'R' and  idsdoMain.GetITemString(1,'return_tracking_no') > '' Then
	lsXML += "<ReturnTrackingNumber>" + idsdoMain.GetITemString(1,'return_tracking_no') + "</ReturnTrackingNumber>"
Else
	lsXML += "<ReturnTrackingNumber></ReturnTrackingNumber>"
End If


//Weight
lsXML += "<Weight>"
lsXML += String(ldWeight,'####0.00')
lsXML += "</Weight>"

lsXML += "</Package>"
lsXML += "</Packages>"


//Products Shipped

lsXML += "<ProductsShipped>"

llRowCount = ldsProducts.RowCount()
For llRowPos = 1 to lLRowCount /*each Picking Detail record */
	
	// 01/12 - PCONKL - For Non Serialized parts, we may have a Picking Detail record with a Qty > 1 so we need to loop for each instance of Qty
	//							For Serialized parts, there will be 1 record for each serial number regardless of the Qty so we don't need to loop by Qty
		
	If ldsProducts.getITemString(llRowPos,'Serial_No') = '' or isnull(ldsProducts.getITemString(llRowPos,'Serial_No')) Then /*Non serialized*/
		llLoopCount = Int(ldsProducts.GetITemNumber(llRowPos,'Quantity'))
	Else /*Serialized*/
		llLoopCount = 1
	End If
	
	For llLoopPos = 1 to llLoopCount
		
		lsGroup = ldsProducts.GetITemString(llRowPos,'grp')
	
		//Product ID and Device ID's come from the Device ID table as they were sent as part of the Shipment Request. There may be multiple Device ID's.
		//For phase 1, there will be a 1 to 1 between the Picking detail and a product/device.
		// In future phase, there may be multiple devices per product. We will need to determine whether we are using components or a finished good that blows out somehow

		
		lsXML += "<ProductShipped>"
	
		//Product Code
		lsXML += "<ProductCode>"
		
		If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_code')) Then
			lsXML += ldsProducts.GetITemString(llRowPos,'oms_code')
		End If
	
		lsXML += "</ProductCode>"
		
		//Find non used device row based on LIne ITem and Device Type (we will populate the serial number to denote that it has been assigned)
		// 01/12 - PCONKL - Can no longer base it on the presence of serial_no as we have non serialized product now, added indicator 'Record_Used'
		//lsFind = "Line_Item_No = " + String(ldsProducts.getITemNumber(lLRowPos,'Line_item_No')) + " and Upper(Device_Type) = '" + Upper(ldsProducts.getITemString(llRowPos,'device_Type')) + "' and serial_no = ''"
		lsFind = "Line_Item_No = " + String(ldsProducts.getITemNumber(lLRowPos,'Line_item_No')) + " and Upper(Device_Type) = '" + Upper(ldsProducts.getITemString(llRowPos,'device_Type')) + "' and Record_used = 'N'"
		llFindRow = ldsDevices.Find(lsFind,1,ldsDevices.RowCount())
		
		//Product ID
		lsXML += "<ProductID>"
		
		If lLFindRow > 0 Then
			lsXML += ldsDEvices.GetITemString(llFindRow,'Product_id')
		End If
		
		lsXML += "</ProductID>"
		
		//FulFillment Code
		lsXML += "<FulfillmentCode>"
		
		// 10/11 - PCONKL - If this was an RMA order, we re-mapped the product code they sent us and stored the original in the Detail UF
		If idsdoMain.GetITemString(1,'ord_type') = 'R'  Then
		
			llLineItemNO = ldsProducts.getITemNumber(lLRowPos,'Line_item_No')
		
			Select User_Field2 into :lsProduct
			From Delivery_Detail
			Where do_no = :asdono and Line_Item_No = :llLineItemNo;
		
			If (not isnull(lsProduct)) and  lsProduct > '' Then
			
				lsXML += lsProduct
			
			Else
			
				If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_product')) Then
					lsXML += ldsProducts.GetITemString(llRowPos,'oms_product')
				End If
		
			End If
		
		Else /*normal order*/
	
			If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_product')) Then
				lsXML += ldsProducts.GetITemString(llRowPos,'oms_product')
			End If
		
		End If
		
		lsXML += "</FulfillmentCode>"
		
		
		//Devices Shipped (for Line ITem)
		lsXML += "<DevicesShipped>"
		
		//Right now, this i a one to one relationship. In the future, there will be multiple devices per product shipped
			
			lsXML += "<DeviceShipped>"
			
			//DEvice Name
			lsXML += "<Name>"
			
			If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_name')) Then
				lsXML += ldsProducts.GetITemString(llRowPos,'oms_name')
			End If
			
			lsXML += "</Name>"
			
			//Make
			lsXML += "<Make>"
			If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_make')) Then
				lsXML += ldsProducts.GetITemString(llRowPos,'oms_make')
			End If
			
			lsXML += "</Make>"
			
			//Model
			lsXML += "<Model>"
			If NOt isnull(ldsProducts.GetITemString(llRowPos,'oms_model')) Then
				lsXML += ldsProducts.GetITemString(llRowPos,'oms_model')
			End If
			
			lsXML += "</Model>"
			
			// 01/12 - PCONKL - For Non Serialized, we won't include Serial, Unit ID or MAC
			If ldsProducts.getITemString(llRowPos,'Serial_No') > '' Then /* Serialized*/
			
				//Serial (FRom Serial Detail)
				lsXML += "<SerialNumber>"
			
				lsSerial = ldsProducts.GetITemString(llRowPos,'serial_no')
			
				If NOt isnull(lsSerial) Then
					lsXML += lsSerial
				End If
			
				lsXML += "</SerialNumber>"
						
				//Unit ID comes from Carton_Serial table (UF1), RFMac comes from UF2 for uDTA
				// 09/11 - PCONKL - For Routers (RTR), UF1 is the MACADdress - short term, leave as is. If we do routers long term, we will make changes
				
				//01/12 - Mapping by Product Group
				//	DTA/UDTA - Address1 = Unit_ID, ADdr2 = RFMAC
				//	RTR - Address1 = MAC_ID
			
				//Select Max(user_Field1), Max(USer_Field2) into :lsUnitID, :lsMAC
				Select Max(user_Field1), Max(USer_Field2) into :lsAddr1, :lsAddr2
				From Carton_Serial with (nolock)
				Where project_id = 'COMCAST' and serial_no = :lsSerial;
			
				If isnull(lsAddr1) Then lsAddr1 = ''
				If isnull(lsAddr2) Then lsAddr2 = ''
			
				//09/11 - PCONKL - Routers do not have Unit ID
				//if Upper(lsGroup) <> 'RTR' Then
				if Upper(lsGroup) = 'DTA' or  Upper(lsGroup) = 'UDTA' Then
					lsxml += "<UnitID>" + lsAddr1 + "</UnitID>"
				End If
			
				//Serial Number and Unit ID needs to be updated on this record...
				If llFindRow > 0 Then
				
					ldsDevices.SetITem(llFindRow,'serial_no',lsSerial)
				
					// 09/11 - Do ot write Unit ID or RFMac for Routers. IF we do this long term, we will add a new DB field for MACAddress (Different from RFMacAddress)
					// 01/12 - PCONKL - Added new DB field for MAC ID
					
					//if Upper(lsGroup) <> 'RTR' Then
					if Upper(lsGroup) = 'DTA' or  Upper(lsGroup) = 'UDTA' Then
					
						ldsDevices.SetITem(llFindRow,'Unit_ID',lsAddr1)
						ldsDevices.SetITem(llFindRow,'RFMAC_ID',lsAddr2)
					
					End If
				
					//Update in the DB for reporting purposes
					
					//01/12 - Mapping by Product Group
					//	DTA/UDTA - Address1 = Unit_ID, ADdr2 = RFMAC
					//	RTR - Address1 = MAC_ID
				
					llDeviceIdNO = ldsDevices.GetITEmNumber(llFindROw,'id_no')
				
					if Upper(lsGroup) = 'DTA' or  Upper(lsGroup) = 'UDTA' Then
						
						Update Comcast_Devices
						Set Serial_no = :lsSerial, Unit_id = :lsAddr1, RFMAC_ID = :lsAddr2
						Where id_no = :llDeviceIdNO;
				
						Commit;
						
					ElseIf  Upper(lsGroup) = 'RTR' Then
						
						Update Comcast_Devices
						Set Serial_no = :lsSerial, MAC_ID = :lsAddr1
						Where id_no = :llDeviceIdNO;
				
						Commit;
						
					End If
								
				End If
			
				//If uDTA, include RFMACAddress
				if Upper(lsGroup) = 'UDTA' Then
					lsxml += "<RFMACAddress>" + lsAddr2 + "</RFMACAddress>"
				End IF
			
				//09//11 - PCONKL - Routers need MAC ADdress. It is in UF1 which is in the same field as Unit ID for CPE/DTA.
				if Upper(lsGroup) = 'RTR' Then
					lsxml += "<MACAddress>" + lsAddr1 + "</MACAddress>"
				End IF
			
			End If /* Serialized*/
			
			//01/12 - PCONKL - Mark the Device REcord as Used (Can't rely on Serial_No be present anymore with non-serialized parts)
			If llFindRow > 0 Then
				ldsDevices.SetITem(llFindRow,'record_used','Y')
			End IF
			
			//Condition (Inv Type)
			lsxml += "<Condition>"
			
			If ldsProducts.GetITemString(llRowPos,'inventory_type') = 'N' Then
				lsXML += "New"
			Else
				lsXML += "Used"
			End If
			
			lsxml += "</Condition>"
			
			//Device Type
			lsXML += "<DeviceType>"
			
			If llFindROw > 0 Then
				If NOt isnull(ldsDevices.GetITemString(llFindRow,'device_type')) Then
					lsXML += ldsDevices.GetITemString(llFindRow,'device_type')
				End If
			End IF
			
			lsXML += "</DeviceType>"
			
			//Device ID
			lsXML += "<DeviceID>"
			
			If llFindROw > 0 Then
				If NOt isnull(ldsDevices.GetITemString(llFindRow,'device_id')) Then
					lsXML += ldsDevices.GetITemString(llFindRow,'device_id')
				End If
			End If
			
			lsXML += "</DeviceID>"
			
			lsXML += "</DeviceShipped>"
			
			llFindRow ++
			If llFindRow > ldsDevices.RowCount() Then
				llFindRow = 0
			Else
				llFindRow = ldsDevices.Find(lsFind,llFindRow,ldsDevices.RowCount())
			End If
			
		
		lsXML += "</DevicesShipped>"
		lsXML += "</ProductShipped>"

	Next /*Qty within Picking Detail Record if non-serialized*/
		
Next /*Picking Detail */

lsXML += "</ProductsShipped>"
lsXML += "</Shipment>"
lsXML += " </Shipments>"
lsXML += "</Request>"
lsXML += "</PostShipment>"


//Write to file
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor SIK Goods Issue Confirmation.~r~rConfirmation will not be sent to Comcast!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
// 05/11 - PCONKL - Current DB issues are sometimes cuasing the TRAX process to timeout updating the Freight Cost. AS a band-aid, send the file to me to manually add freight cost instead of dealing with the wrath of Comcast when they are rejected on ther side
If lbnoFreightCost Then
	
	gu_nvo_process_files.uf_send_email("COMCAST","conklin.peter@con-way.com","*****Comcast SIK Postback missing Freight charges - GI-"  + String(ldBatchSeq,'00000') +  '.XML',lsXML,"")
	
Else
	
	llNewRow = idsOut.InsertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsXML)
	idsOut.SetItem(llNewRow,'file_name', 'GI' + String(ldBatchSeq,'00000') +  '.XML') 
	
	//Write the Outbound File
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'COMCAST')
	
End If
	
idsOut.Reset()

//***  We also need to write a record to EIS for all serials captured


//Need Ship From Warehouse EIS Code (UF1)

lsWarehouse = idsDoMain.GetItemString(1,'wh_code')

select  user_field1
into	:lsComcastwarehouse
From Warehouse
Where wh_Code = :lsWarehouse;

//create datastore of serial numbers scanned
ldsSerial = Create Datastore

sql_Syntax = "SELECT top 100 dbo.Carton_Serial.Serial_No ,   dbo.Carton_Serial.Mac_ID ,   dbo.Carton_Serial.Pallet_ID ,   dbo.Carton_Serial.SKU ,    dbo.Carton_Serial.Supp_Code ,  "
sql_Syntax += "  dbo.Carton_Serial.User_field1 ,   dbo.Carton_Serial.User_field2 ,  dbo.Carton_Serial.User_field3 ,    dbo.Carton_Serial.User_field4,  dbo.Carton_Serial.User_field5, "
sql_Syntax += "  dbo.Carton_Serial.User_field6 ,   dbo.Carton_Serial.User_field7 ,  dbo.Carton_Serial.User_field8 ,    dbo.Carton_Serial.User_field9,  dbo.Carton_Serial.User_field10, dbo.Carton_Serial.Source "
sql_syntax += " FROM dbo.Carton_Serial, Delivery_Picking_Detail,	Delivery_Serial_Detail "
sql_syntax += "    WHERE  dbo.Carton_Serial.Project_ID = 'COMCAST'  and  	Delivery_picking_detail.do_no = '" + asdono + "' and 	Delivery_picking_detail.id_no = delivery_serial_Detail.id_no and carton_serial.serial_no = delivery_serial_detail.Serial_no; "

ldsSerial.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))

IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore forSerial Numbers" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsSerial.SetTransObject(SQLCA)
llRowCount = ldsSerial.retrieve()

For llRowPos = 1 to llRowCount
		
	lssku = ldsSerial.GetItemString(llRowPos, "sku")
	lssuppcode = ldsSerial.GetItemString(llRowPos, "supp_code")
	
	If lsSKU <> lsSKUHold Then
		
		 SELECT Item_Master.User_Field10  , grp
  			INTO :lsModel , :lsGroup
    			FROM Item_Master  
   			WHERE ( Item_Master.Project_ID = 'Comcast' ) AND  
         			( Item_Master.SKU = :lssku ) AND  
         			( Item_Master.Supp_Code = :lssuppcode )   ;
						
						lsSKUHold = lsSKU
						
	End If
	
	
	//Transaction Code  - Always TSU
	lsOutString = 'TSU|'
	
	//From Site ID 
	lsOutString += lsComcastwarehouse + "|"  // From Site ID $$HEX2$$13202000$$ENDHEX$$Ship From Warehouse User_Field1
	
	//To Site ID - Always 'CUST' ????
	lsOutString += "CUSTOMER|"
	
	//Ref Nbr (SIMS Order Nbr)
	lsOutString += idsdoMain.GetITemString(1,'invoice_no') + "|"
	
	 // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks	
	lsOutString += '' + '|' 	

	//Start Date (blanks)
	lsOutString+= '' + '|'  
	
	 //Status
	lsOutString+= '' + '|' 
	
	//Pallet ID 
	If ldsSerial.GetItemString(llRowPos, "Pallet_ID") <> '-'  Then
		lsOutString += ldsSerial.GetItemString(llRowPos, "Pallet_ID")	 + "|"
	Else
		lsOutString += '' + '|'
	End If
	
	//BOL Nbr (SIMS Order Nbr)
	lsOutString += idsdoMain.GetITemString(1,'invoice_no') + "|"
	
	//Serial No
	lsserial = uf_map_address(ldsSerial, llRowPos,"SERIAL_NO",lsGroup)
	If IsNull(lsserial) THEN lsserial = ''
	lsOutString += lsserial + '|' 
	
	//Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$
	lsOutString += 'S'  + '|'   
	
	//model
	if IsNull(lsModel) THEN lsModel = ''
	lsOutString += lsModel + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10
	
	// GWM - 6/3/2011 - Add Attribute Level Processing fields
	
	//Address 1->5
	lsAddress[1] = uf_map_address(ldsSerial, llRowPos,"ADDRESS1",lsGroup)
	lsAddress[2] = uf_map_address(ldsSerial, llRowPos,"ADDRESS2",lsGroup)
	lsAddress[3] = uf_map_address(ldsSerial, llRowPos,"ADDRESS3",lsGroup)
	lsAddress[4] = uf_map_address(ldsSerial, llRowPos,"ADDRESS4",lsGroup)
	lsAddress[5] = uf_map_address(ldsSerial, llRowPos,"ADDRESS5",lsGroup)
	lsAddress[6] = uf_map_address(ldsSerial, llRowPos,"ADDRESS6",lsGroup)
	lsAddress[7] = uf_map_address(ldsSerial, llRowPos,"ADDRESS7",lsGroup)
	lsAddress[8] = uf_map_address(ldsSerial, llRowPos,"ADDRESS8",lsGroup)
	lsAddress[9] = uf_map_address(ldsSerial, llRowPos,"ADDRESS9",lsGroup)
	lsAddress[10] = uf_map_address(ldsSerial, llRowPos,"ADDRESS10",lsGroup)
	
	if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
	if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
	if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
	if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
	if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
	if IsNull(lsAddress[6]) THEN lsAddress[6] = ""
	if IsNull(lsAddress[7]) THEN lsAddress[7] = ""
	if IsNull(lsAddress[8]) THEN lsAddress[8] = ""
	if IsNull(lsAddress[9]) THEN lsAddress[9] = ""
	if IsNull(lsAddress[10]) THEN lsAddress[10] = ""
	
	lsOutString += lsAddress[1] + '|'  
	lsOutString += lsAddress[2] + '|'  
	lsOutString += lsAddress[3] + '|'  
	lsOutString += lsAddress[4] + '|'  
	lsOutString += lsAddress[5] + '|'    
	lsOutString += lsAddress[6] + '|'  
	lsOutString += lsAddress[7] + '|'  
	lsOutString += lsAddress[8] + '|'  
	lsOutString += lsAddress[9] + '|'  
	lsOutString += lsAddress[10]   
	
	llNewRow = idsOut.InsertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000')   + '.DAT') 
	
next /*serial Record*/

//Write the Outbound File
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'COMCAST')

Destroy ldsProducts
Destroy ldsdevices
Destroy ldsSerial

Return 0
end function

public function integer uf_lms_gi (string asproject, string asdono);//Cloned from Phoenix Brands for Comast LMS file
//Prepare a Goods Issue Transaction for Comcast for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llRecSeq
				
String		lsFind, lsOutString_LMS,	lsMessage, lsSku,	lsSupplier, lsSkuSupplier,	lsInvType,	&
				lsInvoice, lsLogOut, lsWarehouse, lsCOMwarehouse, lsFileName, lsuccswhprefix, lsuccscompanyprefix,	&
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
	

lsLogOut = "        Creating LMS GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Convert our warehouse code to Comcast LMS Warehouse ID 
lsWarehouse = idsDOMain.GetITemString(1,'wh_code')
Select User_Field1,ucc_location_Prefix, wh_Name, address_1, address_2, city, state, zip, country 
Into :lsCOMWarehouse, :lsuccswhprefix, :lsWHName, :lsWHAddr1, :lsWHADdr2, :lsWHCity, :lsWHState, :lsWHZip, :lsWHCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsCOMWarehouse) Then lsCOMWarehouse = ''
lsWarehouse = right(lsWarehouse,6)

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

//Create a 945 (GI) for LMS, after the record is created for LMS, we will add a couple of columns for JVH
llRowCount = idsdoPack.RowCount()

llRecSeq = 0

For llRowPos = 1 to llRowCount /* each Pack Row */
	
	//We need some fields from Order Detail
	lsSKU = idsDOPack.GetItemString(llRowPos,'SKU')
	lsSupplier = idsDOPack.GetItemString(llRowPos,'Supp_Code')				/* Added supplier 4/5/2011 GWM */
	llLineITemNo = idsdoPack.GetItemNumber(llRowPos,'Line_Item_No')
	llFindRow = idsDoDetail.Find("Upper(SKU) = '" + Upper(lsSKU) + "' and Line_Item_No = " + String(llLineITemNo),1,idsdoDetail.RowCount())
	
	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	

	lsOutString_LMS += 'SHP' /*transaction Code */
	
	//lsOutString_LMS += lsCOMWarehouse + Space(6 - Len(lsCOMWarehouse)) /*warehouse*/
	lsOutString_LMS += lsWarehouse + Space(6 - Len(lsWarehouse)) /*LMS warehouse = SIMS warehouse minus COM-*/
	
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	lsOutString_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	
	/*Order Type   4/5/2011 GWM Added IsNull around UF12 */
	//	lsOutString_LMS += ordType
	If Not isnull(idsDoMain.GetItemString(1,'User_Field12')) Then
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field12'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field12')))
	Else
		lsOutString_LMS += Space(4)
	End If

	/*Line Item Number */
	If Not isnull(idsDoPack.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
		lsOutString_LMS += String(idsDoPack.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
	Else
		lsOutString_LMS += '000000'
	End If
	
	lsOutString_LMS += Space(1) /*Line Item Complete*/
	
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field14')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field14'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field14')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* AWB BOL */
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Original Qty = Need from Order Detail
	If llFindRow > 0 Then /*detail row found above */
		lsOutString_LMS += String(idsDoDetail.GetItemDecimal(llFindRow,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
	Else /*not found */
		lsOutString_LMS += '000000000.00'
	End If
	
	//Pack Qty
	lsOutString_LMS += String(idsdoPack.GetItemDecimal(llRowPos,'quantity'),'000000000.00') /*Explicit 2 decimal */
	
	//UOM - From ORder Detail
	If llFindRow > 0 Then /*detail row found above */
		If Not isnull(idsdoDetail.GetItemstring(llFindRow,'uom')) Then
			lsOutString_LMS += idsdoDetail.GetItemstring(llFindRow,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llFindRow,'uom')))
		Else
			lsOutString_LMS += Space(6)
		End If
	Else /* Not Found */
		lsOutString_LMS += Space(6)
	End If
	
	//Package Weight (Gross)
	If Not isnUll(idsDoPack.GetItemDecimal(llRowPos,'weight_Gross')) Then
		lsOutString_LMS += String(idsDoPack.GetItemDecimal(llRowPos,'weight_Gross'),'00000000.000') /* Explicit 3 decimals*/
	Else
		lsOutString_LMS += '00000000.000'
	End If
	
	//Shipment Weight - 0
	lsOutString_LMS += '00000000.000'
	
	//SKU		4/5/2011 GWM added  SKU^Supplier
	If isnull(lsSKU) then lsSKU = ''
	If isnull(lsSupplier) then lsSupplier = ''
	lsSkuSupplier = Left(lsSKU + "^" + lsSupplier + Space(20),20)
	lsOutString_LMS += lsSkuSupplier
	
	lsOutString_LMS += Space(6) /*package Code */
	
	/* lsChepIndicator logic */
	If (idsDoMain.GetItemString(1,'User_Field9') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field9'))) &
		or (idsDoMain.GetItemString(1,'User_Field11') <> '0' and isnumber(idsDoMain.GetItemString(1,'User_Field11'))) Then
		lsChepIndicator = 'Y'
	else
		lsChepIndicator = 'N'
	end if
	
	lsOutString_LMS += Space(15) /*User Code 1 */
	lsOutString_LMS += Space(15) /*User Code 2 */
	lsOutString_LMS += Space(15) /*User Code 3 */

	
	/* Carrier*/
	If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* Pro Number*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field16')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field16'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field16')))
	Else
		lsOutString_LMS += Space(20)
	End If
	
	/* Trailer*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field17')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field17'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field17')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship DAte
	lsOutString_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	
	lsOutString_LMS += Space(4) /*Order Status */
	
	/* Master Shipment (Group Code 1)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field15')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field15'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field15')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* End Leg Carrier for Maste Load (Group Code 2)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field13')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field13'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field13')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	lsOutString_LMS += Space(15) /* Group Code 3*/
	
	lsOutString_LMS += Space(15) /* Group Code 4*/
	
	lsOutString_LMS += Space(15) /* Group Code 5*/
	
	lsOutString_LMS += Space(15) /* Group Code 6*/
	
	lsOutString_LMS += Space(15) /* Group Code 7*/
	
	//Lot No - will be 30 spaces
	lsOutString_LMS += Space(30)

	// COO - will be 3 spaces
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
	
	//Carton_No - Will contain 20 spaces
	lsOutString_LMS += Space(20)

	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'N945' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
	
	
	//Handle the Carton

	//02/07 - PCONKL - Add CTN (Carton) records	

// MA	If lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no') Then Continue /* 1 record per carton*/
	
//MA  	lsCartonSave = idsDoPack.GetItemString(llRowPOs,'carton_no')
	
//	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	// Transaction Type - SH1 for Ready to Ship and SHP for Goods Issue
	lsOutString_LMS += 'CTN' 
	
	//lsOutString_LMS += lsCOMwarehouse + Space(6 - Len(lsCOMwarehouse)) /*warehouse*/
	lsOutString_LMS += lsWarehouse + Space(6 - Len(lsWarehouse)) /*LMS warehouse = SIMS warehouse minus COM-*/
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
	idsOut.SetItem(llNewRow,'file_name', 'N945' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
		
	//***** deleted phx fields
	
next /*next output record */

// 06/04 - PCONKL - We also want to include cancel records for any Order Details that did not ship (detail.Alloc_Qty = 0)
idsDODEtail.SetFilter("alloc_Qty = 0")
idsDoDetail.Filter()

llRowCount = idsdoDetail.RowCount()
For llRowPos = 1 to llRowCount /*Each 0 shipped Detail row */
		
	lsSKU = idsdoDetail.GetItemString(llRowPos,'SKU')
	llLineITemNo = idsdoDetail.GetItemNumber(llRowPos,'Line_Item_No')
	
		
		
	llRecSeq ++
	lsOutString_LMS = String(llRecSeq,'000000') /* Record Number*/
	
	lsOutString_LMS += 'LCN' /*CANCEL - transaction Code */
	
	//lsOutString_LMS += lsCOMWarehouse + Space(6 - Len(lsCOMWarehouse)) /*warehouse*/
	lsOutString_LMS += lsWarehouse + Space(6 - Len(lsWarehouse)) /* LMS warehouse = SIMS warehouse minus COM-*/
	
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	lsOutString_LMS += idsDoMain.GetItemString(1,'invoice_no') + Space(30 - Len(idsDoMain.GetItemString(1,'invoice_no'))) /* Order Number */
	
	/*Order Type */
	// pvh - 08/23/06 - Order Type 'Z' or 'T' 
	// moved the logic to set this outside the loop
	lsOutString_LMS += ordType
//	
//	If Not isnull(idsDoMain.GetItemString(1,'User_Field2')) Then 
//		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field2'),4) + Space(4 - Len(idsDoMain.GetItemString(1,'User_Field2')))
//	Else
//		lsOutString_LMS += Space(4)
//	End If
//
	
	/*Line Item Number */
	If Not isnull(idsDoDetail.GetItemNumber(llRowPos,'Line_ITem_No')) Then 
		lsOutString_LMS += String(idsDoDetail.GetItemNumber(llRowPos,'Line_ITem_No'),'000000')
	Else
		lsOutString_LMS += '000000'
	End If
	
	lsOutString_LMS += Space(1) /*Line Item Complete*/
	
	/* LMS Shipment */
	If Not isnull(idsDoMain.GetItemString(1,'User_Field4')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field4'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field4')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* AWB BOL */
	If Not isnull(idsDoMain.GetItemString(1,'awb_bol_no')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'awb_bol_no'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'awb_bol_no')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Original Qty  4/5/2011 - GWM Wrapped in IsNull
	If Not isnull(idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty')) Then
		lsOutString_LMS += String(idsDoDetail.GetItemDecimal(llRowPos,'Req_Qty'),'000000000.00') /* Explicit 2 decimal places for LMS*/
	Else
		lsOutString_LMS += '000000000.00'
	End If
	
	//Pack Qty - 0 (Not shipped)
	lsOutString_LMS += '000000000000'
	
	//UOM
	If Not isnull(idsdoDetail.GetItemstring(llRowPos,'uom')) Then
		lsOutString_LMS += idsdoDetail.GetItemstring(llRowPos,'uom') + Space(6 - Len(idsdoDetail.GetItemstring(llRowPos,'uom')))
	Else
		lsOutString_LMS += Space(6)
	End If
	
	//Package Weight (Gross) - 0 for 0 shipped
	lsOutString_LMS += '00000000.000'
		
	//Shipment Weight - 0
	lsOutString_LMS += '00000000.000'
	
	//SKU  4/5/2011 - GWM Wrapped in IsNull
	If Not isnull(idsDoDetail.GetItemString(llRowPos,'sku')) Then
		lsOutString_LMS += idsDoDetail.GetItemString(llRowPos,'sku') + Space(20 - Len(idsdoDetail.GetItemString(llRowPos,'sku')))
	Else
		lsOutString_LMS += Space(20)
	End If
	
	lsOutString_LMS += Space(6) /*package Code */
	
	lsOutString_LMS += Space(15) /*User Code 1 */
	
	lsOutString_LMS += Space(15) /*USer Code 2 */
	
	lsOutString_LMS+= Space(15) /*User Code 3 */
	
	/* Carrier*/
	If Not isnull(idsDoMain.GetItemString(1,'Carrier')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'Carrier'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'Carrier')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* Pro Number*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field6')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field6'),20) + Space(20 - Len(idsDoMain.GetItemString(1,'User_Field6')))
	Else
		lsOutString_LMS += Space(20)
	End If
	
	/* Trailer*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field7')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field7'),10) + Space(10 - Len(idsDoMain.GetItemString(1,'User_Field7')))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship DAte  4/5/2011 - GWM Wrapped in IsNull
	If Not isnull(idsDoMain.GetItemDateTime(1,'Complete_Date')) Then
		lsOutString_LMS += String(idsDoMain.GetItemDateTime(1,'Complete_Date'),'YYYYMMDD')
	Else
		lsOutString_LMS += Space(8)
	End If
	
	lsOutString_LMS += Space(4) /*Order Status */
	
	/* Master Shipment (Group Code 1)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field5')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field5'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field5')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	/* End Leg Carrier for Maste Load (Group Code 2)*/
	If Not isnull(idsDoMain.GetItemString(1,'User_Field3')) Then 
		lsOutString_LMS += Left(idsDoMain.GetItemString(1,'User_Field3'),15) + Space(15 - Len(idsDoMain.GetItemString(1,'User_Field3')))
	Else
		lsOutString_LMS += Space(15)
	End If
	
	lsOutString_LMS += Space(15) /* Group Code 3*/
	
	lsOutString_LMS += Space(15) /* Group Code 4*/
	
	lsOutString_LMS += Space(15) /* Group Code 5*/
	
	lsOutString_LMS += Space(15) /* Group Code 6*/
	
	lsOutString_LMS += Space(15) /* Group Code 7*/
	
	//Lot No - blanks
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
	
	//Ship From Addr 1 4/5/2011 GWM Added isnull to condition
	If Not isnull(lsWHaddr1) Or  lsWHaddr1 > ""  Then
		lsOutString_LMS += Left(lsWHaddr1,30) + Space(30 - Len(lsWHaddr1))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From Addr 2
	If Not isnull(lsWHaddr2) Or  lsWHaddr2 > "" Then
		lsOutString_LMS += Left(lsWHaddr2,30) + Space(30 - Len(lsWHaddr2))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From City
	If Not isnull(lsWHCity) Or lsWHCity > "" Then
		lsOutString_LMS += Left(lsWHCity,30) + Space(30 - Len(lsWHCity))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Ship From State
	If Not isnull(lsWHState) Or lsWHState > "" Then
		lsOutString_LMS += Left(lsWHState,2) + Space(2 - Len(lsWHState))
	Else
		lsOutString_LMS += Space(2)
	End If
	
	//Ship From Zip
	If Not isnull(lsWHZip) Or lsWHZip > "" Then
		lsOutString_LMS += Left(lsWHZip,10) + Space(10 - Len(lsWHZip))
	Else
		lsOutString_LMS += Space(10)
	End If
	
	//Ship From Country
	If Not isnull(lsWHCountry) Or lsWHCountry > "" Then
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
	idsOut.SetItem(llNewRow,'file_name', 'N945' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'LMS') /*routed to LMS folder*/
	
	
	//*****
	// 05/08 - PCONKL - We are now creating a 945 to LMS for Transfers (Ord Type = Z or T) but we don't want to send them to COM
	
	If idsDoMain.GetITemString(1,'ord_type') = 'Z' or idsDoMain.GetITemString(1,'ord_type') = 'T' Then Continue
	
	//*****
	
	
	
	//Add Phoenix only fields - blanks
	
	//Write record for Comcast 
	//llNewRow = idsOut.insertRow(0)
	//idsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
	//idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq2)) /* will be split into separate file in next step*/
	//idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	
	//File name is N945 + xxxxxxxxx 
	//lsFileName = 'N945' + String(ldBatchSeq2,'000000000')
	//idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /* 0 Shipped Detail Row*/

idsDODEtail.SetFilter("")
idsDoDetail.Filter()


///Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'COMCAST')

Return 0
end function

public function integer uf_lms_itemmaster ();//Create an Item master update file for LMS - all items that have changed since last run

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
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Create the Item Datastore...
ldsItem = Create Datastore
sql_syntax = "SELECT SKU, Supp_code, User_field4, User_field1, Description, Freight_Class, Shelf_Life, uom_1, uom_2, uom_3, uom_4, qty_2, qty_3, qty_4,  weight_1, weight_2, weight_3, weight_4, " 
sql_syntax += " Length_1, length_2, length_3, length_4, Width_1, width_2, width_3, width_4, height_1, height_2, height_3, height_4 "
sql_syntax += " From Item_Master "
sql_syntax += " Where Project_ID = 'COMCAST' and Interface_Upd_Req_Ind = 'Y';"
ldsItem.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for COMCAST Item Master extract (SIMS->LMS.~r~r" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

ldsItem.SetTransObject(SQLCA)


lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: SIMS -> LMS Item Master update for COMCAST... " 
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
Where Project_ID = 'COMCAST' and Interface_Upd_Req_Ind = 'Y';

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
	lsOutString_LMS += "ATLNTA" /*Warehouse - hardcoded for now as is not relevent to Item Master*/ /* Hard-coded to COM-ATLNTA */
	lsOutString_LMS += String(ldtToday,'YYYYMMDD') /* Transaction date*/
	lsOutString_LMS += String(ldtToday,'HHMMSS') /* Transaction Time*/
	
	// 03/16 - GXMOR - Send SKU + Supp_Code combination
	lsSKU =  ldsItem.GetItemString(lLRowPos,'Sku') + "^" + ldsItem.GetItemString(lLRowPos,'supp_code')

	lsOutString_LMS += Left(lsSKU,20) + Space(20 - len(lsSKU))
	
	//Package Code (UF4)
	/* 01/18 - GXMOR - Send spaces for package code for Comcast */
	//If ldsItem.GetItemString(lLRowPos,'User_field4') > "" Then
	//	lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'user_Field4'),6) + Space(6 - len(ldsItem.GetItemString(lLRowPos,'User_field4')))
	//Else
		lsOutString_LMS += Space(6)
	//End If
	
	//Description
	If ldsItem.GetItemString(lLRowPos,'Description') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'Description'),30) + Space(30 - len(ldsItem.GetItemString(lLRowPos,'Description')))
	Else
		lsOutString_LMS += Space(30)
	End If
	
	//Product Class (UF1)
	/* 01/18 - GXMOR - Send spaces for product code for Comcast */
	/* 03/01 - GXMOR - Pull Product Class from UF1 */
	If ldsItem.GetItemString(lLRowPos,'User_field1') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'user_Field1'),6) + Space(6 - len(ldsItem.GetItemString(lLRowPos,'User_field1')))
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
	/* 01/18 - GXMOR - Send zeros for shelf life for Comcast */
	//If ldsItem.GetITemNumber(llRowPos, 'shelf_life') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'shelf_life'),'00000000')
	//Else
		lsOutString_LMS += "00000000"
	//end If
		
	//UOM1
	If ldsItem.GetItemString(lLRowPos,'uom_1') > "" Then
		lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_1'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_1')))
	Else
		lsOutString_LMS += "EA "
	End If
	
	//UOM2
	// 03/03 - GXMOR - Force to blank 
	//If ldsItem.GetItemString(lLRowPos,'uom_2') > "" Then
	//	lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_2'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_2')))
	//Else
		lsOutString_LMS += "   "
	//End If
	
	//UOM3
	// 03/03 - GXMOR - Force to blank 
	//If ldsItem.GetItemString(lLRowPos,'uom_3') > "" Then
	//	lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_3'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_3')))
	//Else
		lsOutString_LMS += "   "
	//End If
	
	//UOM4
	// 03/03 - GXMOR - Force to blank 
	//If ldsItem.GetItemString(lLRowPos,'uom_4') > "" Then
	//	lsOutString_LMS +=  Left(ldsItem.GetItemString(lLRowPos,'uom_4'),3) + Space(3 - len(ldsItem.GetItemString(lLRowPos,'uom_4')))
	//Else
		lsOutString_LMS += "   "
	//End If
	
	
	
	//UOM Qty1 - Conversion facfor from UOM2 -> UOM1 (QTY1 is always 1)
	// 03/14 - GXMOR - Force to zero
	//If ldsItem.GetITemNumber(llRowPos, 'qty_2') > 0  Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'qty_2'),"0000000.00000000")
	//Else
		lsOutString_LMS += "0000000.00000000"
	//End If
	
	//UOm Qty 2 - Conversion facfor from UOM3 -> UOM2
	// 03/14 - GXMOR - Force to zero
	//If ldsItem.GetITemNumber(llRowPos, 'qty_3') > 0 and ldsItem.GetITemNumber(llRowPos, 'qty_2') > 0 Then
	//	ldQty = ldsItem.GetITemNumber(llRowPos, 'qty_3') / ldsItem.GetITemNumber(llRowPos, 'qty_2')
	//	lsOutString_LMS += String(ldQty,"0000000.00000000")
	//Else
		lsOutString_LMS += "0000000.00000000"
	//End If
	
	//UOm Qty 3 Conversion factor from UOM4 -> 3
	// 03/14 - GXMOR - Force to zero
	//If ldsItem.GetITemNumber(llRowPos, 'qty_4') > 0 and ldsItem.GetITemNumber(llRowPos, 'qty_3') > 0 Then
	//	ldQty = ldsItem.GetITemNumber(llRowPos, 'qty_4') / ldsItem.GetITemNumber(llRowPos, 'qty_3')
	//	lsOutString_LMS += String(ldQty,"0000000.00000000")
	//Else
		lsOutString_LMS += "0000000.00000000"
	//End If
	
	//Weight 1
	If ldsItem.GetITemNumber(llRowPos, 'weight_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Weight 2	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'weight_2') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_2'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Weight 3	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'weight_3') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_3'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Weight 4	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'weight_4') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'weight_4'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Height 1
	If ldsItem.GetITemNumber(llRowPos, 'height_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Height 2	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'height_2') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_2'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Height 3	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'height_3') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_3'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Height 4	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'height_4') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'height_4'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	
	//Width 1
	If ldsItem.GetITemNumber(llRowPos, 'Width_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Width 2	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'Width_2') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_2'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Width 3	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'Width_3') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_3'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Width 4	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'Width_4') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'Width_4'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	
	//Length 1
	If ldsItem.GetITemNumber(llRowPos, 'length_1') > 0 Then
		lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_1'),'0000000.0000')
	Else
		lsOutString_LMS += "0000000.0000"
	End If
	
	//Length 2	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'length_2') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_2'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Length 3	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'length_3') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_3'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	//Length 4	GXMOR 2/15/2011 do not send this to LMS
	//If ldsItem.GetITemNumber(llRowPos, 'length_4') > 0 Then
	//	lsOutString_LMS += String(ldsItem.GetITemNumber(llRowPos, 'length_4'),'0000000.0000')
	//Else
		lsOutString_LMS += "0000000.0000"
	//End If
	
	
	
	// Write the record for LMS
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', 'COMCAST')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString_LMS)
	idsOut.SetItem(llNewRow,'file_name', 'N832' + String(ldBatchSeq,'00000') + '.DAT') 
	idsOut.SetItem(llNewRow,'dest_cd', 'ICC') /*routed to LMS folder*/
		
Next /* Item Master Record*/

//Write the Outbound File 
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'COMCAST')

//Reset update status on rows processed
Update Item_Master
Set Interface_Upd_Req_Ind = 'N'
Where Project_ID = 'COMCAST' and Interface_Upd_Req_Ind = 'X';

Commit;


Return 0
end function

protected function string uf_map_address (ref datastore ldsserial, long alrow, string ascolumn, string asgroup);//If serial data has been mapped by ReportStore or EIS (ITH/ITD), then returngeneric address 1 - 5 fields, otherwise map based on Group
String	lsMappedValue

Choose Case Upper(asColumn)
		
	Case "SERIAL_NO"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue =  ldsSerial.GetItemString(alRow, "Serial_No")	
			
		Else /*map based on Group*/
			
				Choose Case Upper(asGroup)
			
					Case "CPE"
			
						lsMappedValue = ldsSerial.GetItemString(alRow, "user_field5")	/*field 19 - M-Card Serial*/
			
						// 07/10 - PCONKL - If a product is mislabeled as CPE, the M-Card Serial wont be available.
						If IsNull(lsMappedValue) or lsMappedValue = '' THEN
							lsMappedValue = ldsSerial.GetItemString(alRow, "Serial_No")	
						End If
			
					Case else /*Default to DTA */
			
						lsMappedValue = ldsSerial.GetItemString(alRow, "Serial_No")	
			
				End Choose

		End If
		
	Case "ADDRESS1"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field1")
			
		Else
			
			Choose Case Upper(asGroup)
			
					Case "CPE"
						lsMappedValue = ldsSerial.GetItemString(alRow, "user_field3")
					Case Else
						lsMappedValue =	 ldsSerial.GetItemString(alRow, "mac_id")
						 
			End Choose
			
		End If
		
	Case "ADDRESS2"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field2")
			
		Else
			
			Choose Case Upper(asGroup)
			
					Case "CPE"
						lsMappedValue = ldsSerial.GetItemString(alRow, "serial_no")
					Case Else
						lsMappedValue =  ldsSerial.GetItemString(alRow, "user_field1")
						 
			End Choose
			
		End If
		
	Case "ADDRESS3"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field3")
			
		Else
			
			Choose Case Upper(asGroup)
			
					Case "CPE"
						lsMappedValue = ldsSerial.GetItemString(alRow, "mac_id")
					Case Else
						 lsMappedValue = ""
						 
			End Choose
			
		End If
		
	Case "ADDRESS4"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field4")
			
		Else
			
			Choose Case Upper(asGroup)
			
					Case "CPE"
						lsMappedValue = ldsSerial.GetItemString(alRow, "user_field4")
					Case Else
						 lsMappedValue = ""
						 
			End Choose
			
		End If
		
	Case "ADDRESS5"
		
		If ldsSerial.GetITEmString(alRow,'source') = 'REPORTSTORE' or ldsSerial.GetITEmString(alRow,'source') = 'EIS' Then
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field5")
			
		Else
			
			Choose Case Upper(asGroup)
			
					Case "CPE"
						lsMappedValue = ldsSerial.GetItemString(alRow, "user_field2")
					Case Else
						 lsMappedValue = ""
						 
			End Choose
			
		End If
				
	Case "ADDRESS6"
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field6")
		
	Case "ADDRESS7"
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field7")
		
	Case "ADDRESS8"
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field8")
		
	Case "ADDRESS9"
			
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field9")
			
	Case "ADDRESS10"
		
			lsMappedValue = ldsSerial.GetItemString(alRow, "user_field10")
				
End Choose

REturn lsMappedValue



//Case "CPE"
//			
//				lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field3")
//				lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "serial_no")
//				lsAddress[3] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//				lsAddress[4] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field4")
//				lsAddress[5] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field2")
//
//		Case Else /* Default to DTA */
//			
//			//lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//			//lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field1")
//			
//			lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field1")
//			lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//			
//			lsAddress[3] = ""
//			lsAddress[4] = ""
//			lsAddress[5] = ""
//			
//	
//	End Choose
end function

public function integer uf_gi_oms_blk (string asdono);// 07/11  - PCONKL - This function sends a GA to Comcast OMS for Bulk Orders
//							This is the same postback we send for SIK orders but without Serial data so the looping is different


String		lsLogout, sql_syntax, errors,   lsOutString, lsCarton, lsCartonSave
String	 	lsSKU, lsSuppCode, lsSkuHold, lsModel, lsDevicesPerFile
Integer	liFileNo, liFileCnt, liThisFile			// GXMOR - 12/15/2011 - Break devices into chunks of 1,000 and send a thousand in each file
Long		llBegin, llEnd, llItemDevices
Long		lLDetailCount, llDetailPos, l, llAllocQty, llNewRow, llDeviceIdNO, llDeviceCount,lLDevicePos
lONG		llLineItem, llRowCount, llRowPos, llRC, llDevicesPerfile
Decimal	ldWEight, i, ldLineItem, ldLineItemSaved
Time		ltCompleteTime

/* GWM - 8/28/2012 - Change type of file from GI to BI to have bulk order posted differently */
lsLogOut = "        Creating BI for Comcast OMS Bulk order  For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

/* Get Number of Devices per File from SIMS Lookup Table - GXMOR - 12/19/2011 */
lsDevicesPerFile = ""

		Select code_descript
		Into	:lsDevicesPerFile
		From Lookup_Table
		Where Project_id = 'Comcast' and Code_Type = 'PBACK' and Code_ID = 'MAX_NUM_DEVICES';

If not isnull(lsDevicesPerFile) Then
	If IsNumber(lsDevicesPerFile) Then
		llDevicesPerFile = Long(Trim(lsDevicesPerFile))
	Else
		lsLogOut = "        *** Unable to create devices per file for Shipped Devices: " + lsDevicesPerFile
		FileWrite(gilogFileNo,lsLogOut)
  	 	RETURN - 1
	End if
End if

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

idsDODetail.SetSort("Line_Item_No")
idsDODetail.Sort()

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

idsdoPack.Reset()
idsdoDetail.Reset()

//Get THe devices records for this ORder (sent in Order request)
idsDevices = Create Datastore
sql_syntax = "Select * from comcast_devices where do_no = '" + asDONO + "'"

idsDevices.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ERRORS))
IF Len(ERRORS) > 0 THEN
   lsLogOut = "        *** Unable to create datastore for Shipped Devices" + Errors
	FileWrite(gilogFileNo,lsLogOut)
   RETURN - 1
END IF

idsDevices.SetTransObject(SQLCA)
idsDevices.Retrieve()

llDeviceCount = idsDevices.RowCount()
liFileCnt = Ceiling( llDeviceCount/llDevicesPerFile )		// GXMOR - 12/15/2011 - Number of files to send for large bulk orders

//Retreive Delivery Master
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Retreive Delivery Detail
Integer detailCnt
detailCnt = idsDODetail.Retrieve(asDoNo)
If detailCnt < 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Detail For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Need gross weight - first pack row of carton should have the total gross weight for the carton, not just that line's worth*/
idsDoPack.Retrieve(asDoNo)
idsDoPack.SetSort("carton_no A")
idsDOPack.Sort()

llRowCount = idsdoPack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsCarton = idsdoPack.GetITemString(llRowPos,'carton_no')
	If lsCarton <> lsCartonSave Then
		ldWeight += idsdoPack.GetITemNumber(llRowPos,'weight_gross')
		lsCartonSave = lsCarton
	End If
	
Next

//Update the weight onto the Delivery Master for reporting purposes
Update Delivery_MAster
Set Weight = :ldWeight
Where do_no = :asDONO;

Commit;

	/*********************Start of Header******************************************/

// XML Header info
isXMLHeader = "<?xml version=~"1.0~" encoding=~"UTF-8~"?>"
isXMLHeader += "<PostShipment xmlns=~"http://comcastonline.com/~">"
isXMLHeader += "<Request>"
isXMLHeader += "<OrderID>" + trim(idsDOMAin.GetITemString(1,'invoice_no')) +  "</OrderID>" /* SIMS Order NUmber*/

isXMLHeader += "<Shipments>"
isXMLHeader += "<Shipment>"

//Carrier - HARDCODED
isXMLHeader += "<Carrier>UPS</Carrier>"

//Date
//12/10 - PCONKL - For now, convert time to Pacific Time.
ltCompleteTime = Time(idsDOMain.GetITEmDateTime(1,'Complete_Date'))

Choose Case Upper(idsdoMain.GetITemString(1,'wh_code'))
		
	Case 'COM-MONROE', 'COM-ATLNTA' /*Monroe and Atlanta need to subtract 3 hours to get to PST*/
		ltCompleteTime = RelativeTime(ltCompletetime,-10800)
	Case 'COM-AURORA' /* Aurora - 2 */
		ltCompleteTime = RelativeTime(ltCompletetime,-7200)
	Case 'COM-FREMNT' /*Already PST*/
		
End Choose

 isXMLHeader += "<Date>" 
 isXMLHeader += String(idsDOMain.GetITEmDateTime(1,'Complete_Date'),"yyyy-mm-dd") + "T" + String(ltCompleteTime,'hh:mm:ss')
 isXMLHeader += "</Date>"
 
 //Method
isXMLHeader += "<Method>"

If idsdoMain.GetITemString(1,'ship_via') > '' Then
	
	Choose Case Upper(idsdoMain.GetITemString(1,'ship_via'))
		Case 'STANDARD'
			isXMLHeader += "Standard"
		Case 'OVERNIGHT'
			isXMLHeader += "Overnight"
		case else
			isXMLHeader += "Standard"
	End Choose
		
Else
	isXMLHeader += "Standard"
End If

isXMLHeader += "</Method>"

//Packages 
isXMLHeader += "<Packages>"
isXMLHeader += "<Package>"

//Cost
isXMLHeader += "<Cost>"

If idsdoMain.GetITemDecimal(1,'Freight_Cost') > 0 Then
	isXMLHeader += String(idsdoMain.GetITemDecimal(1,'Freight_Cost'),'####0.00')
Else
	isXMLHeader += "0.00"
	ibNoFreightCost = True /* 05/11 - PCONKL - Freight cost is sometimes not applied when their is a DB lock in the TRAX process. for a band-aid, we will suppress sending to Comcast until manually fixed...*/
End If

isXMLHeader += "</Cost>"

//Tracking Number
isXMLHeader += "<TrackingNumber>"

If Not isnull(idsdoMain.GetITemString(1,'awb_bol_no')) Then
	isXMLHeader += idsdoMain.GetITemString(1,'awb_bol_no')
End If

isXMLHeader += "</TrackingNumber>"

//Return Tracking Number - no value included
isXMLHeader += "<ReturnTrackingNumber></ReturnTrackingNumber>"


//Weight
isXMLHeader += "<Weight>"
isXMLHeader += String(ldWeight,'####0.00')
isXMLHeader += "</Weight>"

isXMLHeader += "</Package>"
isXMLHeader += "</Packages>"


//Products Shipped

isXMLHeader += "<ProductsShipped>"

/**********************End of Header******************************************/

/*********************Start of Footer******************************************/

isXMLFooter = "</ProductsShipped>"
isXMLFooter += "</Shipment>"
isXMLFooter += " </Shipments>"
isXMLFooter += "</Request>"
isXMLFooter += "</PostShipment>"

/**********************End of Footer******************************************/

// Write multiple files based on liFileCnt
// Moved file creation below header/footer code to loop through multiple files
		//Write a <ProductShipped> and <DeviceShipped> segment for each Device Record. 
		//There should be one for each unit of allocated Qty (if we shipped full). If we shipped Short, 
		//only create a segment for the allocated Qty
	
ldLineItem = 0			// Initialize line item no
ldLineItemSaved = 0		// Initial line item save

For liThisFile = 0 to liFileCnt - 1
	
	liFileNo = getFileOpen()
	if liFileNo > 0 then
		
		/* Get beginning and end for each file */
		llBegin =  (liThisFile * llDevicesPerFile) + 1
		llEnd =  ((liThisFile + 1) * llDevicesPerFile)
		
		If llEnd > llDeviceCount then llEnd = llDeviceCount
		
		/* Start this file with the header */
		llRC = FileWriteEx(liFileNo,blob(isXMLHeader)) /*Write the header*/
				
		For llDevicePos = llBegin to llEnd
				
			ldLineItem = idsDevices.getItemNumber(llDevicePos,"line_item_no")	
			If ldLineItem <> ldLineItemSaved then		// Change to next line item
				/* Get Detail Information for the Detail Line Item No */
				llAllocQty = getOMSProperties( ldLineItem )
				ldLineItemSaved = ldLineItem
				llItemDevices = 1
			else
				llItemDevices ++
			End if
			
			If llAllocQty <= 0 Then Continue
				
			/*If not shipped in full, don't write a device record*/
			If llItemDevices <= llAllocQty Then  
				/* Write this device to the file */
				setDeviceBody( llDevicePos )				
				llRC = FileWriteEx(liFileNo,blob(isXMLBody)) /*Write the detail record*/
			End if
			
		Next /*Device Record*/
					
	End if
	
	l = closeAndSendFile( liFileNo )
		
next	/* Go to next file */

Destroy idsDevices

lsLogOut = "         Completed BI for Comcast OMS Bulk order."
FileWrite(gilogFileNo,lsLogOut)

Return 0
end function

public function integer uf_gi (string asproject, string asdono);
//Send an email ASN notification to the Comcast customer


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llTotalQty
				
String		lsFind, lsLogOut, lsText, lsFromName, lsFromAddr1, lsFromCity, lsFromState, lsFromZip, lsWarehouse, lsCarrierCode, lsCarrierName, lsURL, lsFileName, lsCustCode, lsEmail, lsWarehouseType, lsWarehouseEmail, lsModel, lsOrdType, lsToSiteID, lsGroup, lsPalletSave

Decimal		ldBatchSeq

String lsComcastwarehouse, lsserial, lssku, lssuppcode, lsOutString, lsCusUser_field3, lsOrdNo, lsAddress[], lsSkuHold



Integer		liRC, liFileNo

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

//Retreive Delivery Master, Detail and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	Return -1
End If




//*****  08/10 - PCONKL - For the SIK Fullfillment project, we will send an XML GI, a seperate EIS TSU and NO ASN email - done through a seperate function

// 07/11 - PCONKL - Seperate GI for OMS Bulk orders being dropped to the corporate warehouse

if upper(idsDoMain.GetITemString(1,'Cust_Code')) = 'SIK-CUSTOMER' Then
	return uf_gi_sik(asDONO)
End If

if upper(idsDoMain.GetITemString(1,'Cust_Code')) = 'BLK-CUSTOMER' Then
	return uf_gi_oms_blk(asDONO)
End If


//****************************************************************************************************************




lsLogOut = "        Creating GI ASN Email to Comcast For DONO: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

idsDoPick.Retrieve(asDoNo)


lsOrdNo =  idsDoMain.GetITemString(1,'invoice_no')
lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')
lsOrdType = idsDoMain.GetITemString(1,'ord_type')
lsCustCode = idsDoMain.GetITemString(1,'cust_code')

//Need Ship From Address and warehouse email 
select wh_Type,  wh_name, address_1, city, state, zip, email_address, user_field1
into	:lsWarehouseType, :lsFromName, :lsFromAddr1, :lsFromCity, :lsFromState, :lsFromZip, :lswarehouseEmail, :lsComcastwarehouse
From Warehouse
Where wh_Code = :lsWarehouse;

If isnull(lsWarehouseType) then lsWarehouseType = ""

//Need Email from Customer Master or Warehouse Master if SIK
If lsWarehouseType =  'S' and left(lsCustCode,4) = 'COM-' Then
	lsEmail = lsWarehouseEmail
Else /*Non SIK */
		
	Select email_address, User_field3 into :lsEmail, :lsCusUser_field3
	From Customer
	Where Project_id = 'Comcast' and cust_Code = :lsCustCode;
	
End If

//If this is a warehouse transfer, we need the Site ID from the receiving warehouse instead of the Customer Master
If lsOrdType = 'Z' Then
	
	Select user_field1
	into : lsToSiteID
	From Warehouse
	Where wh_Code = :lsCustCode;
	
	If isnull(lstoSiteID) Then lsToSiteID = ''
	
End If

//Get Carrier Name from Code
lsCarrierCode =  idsDoMain.GetITemString(1,'carrier')
If isNull(lsCarrierCode) Then lsCarrierCode = ''

If lsCarrierCode > ''  Then
	
	Select Carrier_name into :lsCarrierName
	From Carrier_Master
	Where project_id = 'Comcast' and carrier_Code = :lsCarrierCode;
	
End If

If isNull(lsCarrierName) then
	lsCarrierName = ""
Else
	lsCarrierName += " (" + lsCarrierCode + ")"
End If


lsLogOut = "        Creating GI (ASN) Email For DONO: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

llRowCOunt = idsDOPick.RowCount()

//Add header info to email text

//Ship Date
lsText += "~n~n"
LsText = "Ship Date:~t~t"
lsText += String(idsDoMain.GetITemDateTime(1,"Complete_date"),"mm/dd/yyyy hh:mm")

lsText += "~n~n"

//Order Number
lsText += "Order Number:~t"
lsText += idsDoMain.GetItemString(1,'Invoice_no')

lsText += "~n~n"

//Ship From - If Warehouse TYpe is SIK ("S"), It is a virtual Shipment, don't show Ship From, Just Ship to (Which is also the warehouse address)
If lsWarehouseType <> 'S' Then
	
	lsText += "Ship From:~t~t"
	If Not isnull(lsFromName) Then
		lsText += lsFromName
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(lsFromAddr1) Then
		lsText += lsFromAddr1
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(lsFromCity) Then
		lsText += lsFromCity + ", "
	End If

	If Not isnull(lsFromState) Then
		lsText += lsFromState + " "
	End If

	If Not isnull(lsFromZip) Then
		lsText += lsFromZip 
	End If

	lsText += "~n~n"
	
End If /*Not an SIK warehouse */

//Ship To - Either the Customer Ship to, or if an SIK Warehouse, then it is the warehouse address
If lsWarehouseType <> 'S' Then 
	
	lsText += "ShipTo:~t~t"
	If Not isnull(idsDoMain.GetITemString(1,'cust_name')) Then
		lsText += idsDoMain.GetITemString(1,'cust_name')
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(idsDoMain.GetITemString(1,'address_1')) Then
		lsText += idsDoMain.GetITemString(1,'address_1')
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(idsDoMain.GetITemString(1,'city')) Then
		lsText += idsDoMain.GetITemString(1,'city') + ", "
	End If

	If Not isnull(idsDoMain.GetITemString(1,'state')) Then
		lsText += idsDoMain.GetITemString(1,'state') + " "
	End If

	If Not isnull(idsDoMain.GetITemString(1,'zip')) Then
		lsText += idsDoMain.GetITemString(1,'zip') 
	End If
	
Else /* SIK - Ship to is the Warehouse Address */
	
	lsText += "Ship To:~t~t"
	If Not isnull(lsFromName) Then
		lsText += lsFromName
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(lsFromAddr1) Then
		lsText += lsFromAddr1
	End If

	lsText += "~n"

	lsText += "~t~t~t"
	If Not isnull(lsFromCity) Then
		lsText += lsFromCity + ", "
	End If

	If Not isnull(lsFromState) Then
		lsText += lsFromState + " "
	End If

	If Not isnull(lsFromZip) Then
		lsText += lsFromZip 
	End If
	
End IF

lsText += "~n~n"

//Carrier
lsText += "Carrier:~t~t"
lsText += lsCarrierName

lsText += "~n"

//AWB
lsText += "Tracking Nbr:~t"
If Not isnull(idsDoMain.GetITemString(1,'awb_bol_no')) Then
	lsText += idsDoMain.GetITemString(1,'awb_bol_no') 
End If

lsText += "~n~n"

For llRowPos = 1 to llRowCount

	//Rollup to SKU/Pallet(Lot_NO)
	lsFind = "upper(sku) = '" + upper(idsDOPick.GetItemString(llRowPos,'SKU')) 
	lsFind += " and upper(lot_no) = '" + upper(idsDOPick.GetItemString(llRowPos,'lot_no')) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llRowPos,'quantity')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'po_number',idsDoMain.GetItemString(1,'invoice_no'))
		idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llRowPos,'SKU'))
		idsGR.SetItem(llNewRow,'supp_Code',idsDOPick.GetItemString(llRowPos,'supp_Code'))
		idsGR.SetItem(llNewRow,'lot_no',idsDOPick.GetItemString(llRowPos,'lot_no'))
		idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llRowPos,'quantity'))
				
	End If
	
	llTotalQty +=  idsDOPick.GetItemNumber(llRowPos,'quantity')
	
Next /* Next Pick record */

//Totals...
lsText += "Total Pallets/Cartons shipped: " + String(llRowCount,"#####0") + "~n"
lsText += "Total Units Shipped: " + String(llTotalQty,"#####0") + "~n~n"


//Detail Header...
lsText +=  "~tPallet/Carton~tSupplier/Sku/Model~t~t~tQty~n"
lsText +=  "~t-------------~t------------------~t~t~t---~n"


//Add detail info to Email
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	// *MEA 06/09 - Storing the model number in User_Field1
	
	string ls_sku, ls_supp_code, ls_User_Field10
	
	ls_sku= idsGr.GetITemString(llRowPos,'Sku')
	ls_supp_code = idsGr.GetITemString(llRowPos,'Supp_Code')
	
	select user_field10, grp
	into	:ls_User_Field10, :lsGroup
	From Item_Master
	Where sku = :ls_sku AND supp_code = :ls_supp_code AND project_id = 'Comcast' USING SQLCA;
	
	lsModel = ls_User_Field10
	
	IF IsNull(lsModel) THEN lsModel = ""
			
	lsText += "~t"
	lsText += idsGr.GetITemString(llRowPos,'lot_no')
	lsText += "~t~t"
	lsText += idsGr.GetITemString(llRowPos,'Supp_Code') + '/' +  idsGr.GetITemString(llRowPos,'Sku') + '/' + lsModel
	lsText += "~t~t"
	lsText += String(idsGr.GetITemNumber(llRowPos,'quantity'),'#######0')
	lsText += "~n"
	
next /*next output record */

//Footer - Either Prod or Test URL
If gsEnvironment = "PROD" Then
	lsURL = "https://web.menlolog.com/wms/"
Else
	lsURL = "https://menlotest.menlolog.com/wms/"
End If

lsText += "~n~n~nFor more information including Serial Numbers, MAC ID's and Unit ID's, please visit: " + lsURL

lsText += "~n~n*** IMPORTANT NOTICE *** The address fields on the export have changed. Addresses 1 through 5 are now mapped generically as provided by ReportStore. Please contact Comcast for the latest model mapping guide if necessary."

//Write the email...
If lsEmail > '' Then
	//TimA 04/24/13 what to show how long it took to send the email
	lsLogOut = "        Call Email function to send file: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Yield()
	
	gu_nvo_process_files.uf_send_email("COMCAST",lsEmail,"XPO Logistics Shipment Status Update",lsText,"")
	
	//TimA 04/24/13 what to show how long it took to send the email
	lsLogOut = "        Email Sent For DONO: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Yield()
Else
	lsLogOut = "        *** Email Address not present for Customer: '" + lsCustCode + "', Order: " +  idsDoMain.GetITemString(1,'invoice_no') + ". ASN email will not be sent. - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Yield()
End If

//1.1

lsLogOut = " Archive the file  Start " + gsinifile + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

//Archive the file...
lsFileName = ProfileString(gsinifile,"COMCAST","archivedirectory","") + '\' + "ASN-" + idsDoMain.GetITemString(1,'cust_Code') + "-" + idsDoMain.GetITemString(1,'invoice_no') + ".txt"
If FIleExists(lsFileName) Then
	lsFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')
End IF

//1.2

lsLogOut = " Archive the file  end  " + lsFileName + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()



liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockREadWrite!,Append!)
If liFileNo > 0 Then
	FileWrite(liFileNo,lsText)
	FileClose(liFileNo)
End If


//Mike Add

If Not isvalid(idsdoSerialCarton) Then
	idsdoSerialCarton = Create Datastore
	idsdoSerialCarton.Dataobject = 'd_do_serial_carton'
	idsdoSerialCarton.SetTransObject(SQLCA)
End If

idsOut.Reset()


lsWarehouse = idsDOMain.GetITemString(1,'wh_code')

//1.3

lsLogOut = "Warehouse   " + lsWarehouse + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

		
// **** 03/10 - PCONKL - If SIK warehoue, dont send transaction to EIS
// 05/10 - We now want to send a transaction for an SIK - we will set the type to TSN instead of TSU below
//If lsWarehouseType =  'S' Then
//	
//	lsLogOut = "        No Transaction to EIS for SIK shipment  For DONO: " + asDONO
//	FileWrite(gilogFileNo,lsLogOut)
//	Return 0
//	
//End If

//1.4

lsLogOut = "Retrieve the Carton serial Start  " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
Yield()



idsdoSerialCarton.Retrieve(asproject, asdono)


//1.5

lsLogOut = "Carton serial End time  " +string (idsdoSerialCarton ) + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()



 //Sort by Pallet so we can file break on Pallet
 idsdoSerialCarton.SetSort("pallet_ID A")
 
 //1.6

lsLogOut = "Carton serial  Sort  " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

 
 idsdoSerialCarton.Sort()

//   Loop through the existing Delivery_Derial_detail records. Each $$HEX1$$1c20$$ENDHEX$$serial_no$$HEX2$$1d202000$$ENDHEX$$may be a pallet_id (most likey), a $$HEX1$$1c20$$ENDHEX$$carton_id$$HEX2$$1d202000$$ENDHEX$$or a serial_no (least likely) from the $$HEX1$$1c20$$ENDHEX$$carton_serial$$HEX2$$1d202000$$ENDHEX$$table. Try retrieving the carton-serial records by Pallet first, then carton and then serial last.

// For each Carton_serial record retrieved, write an output record (same layout as GR above)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables

//1.7
lsLogOut = "Start Batch seq   " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()


ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//1.8
lsLogOut = "End  Batch seq   " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()


integer  liCurrentFileNum = 1, liCurrentFileCount = 0

llRowCount = idsdoSerialCarton.RowCount()


//1.8
lsLogOut = "Start Row count  " +string (llRowCount)  + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

//we dont want the first record to cause a file break on Pallet
If llRowCount > 0 Then
	lsPalletSave = idsdoSerialCarton.GetItemString(1, "pallet_id")
End If

For llRowPos = 1 to llRowCount
	
	lssku = idsdoSerialCarton.GetItemString(llRowPos, "sku")
	lssuppcode = idsdoSerialCarton.GetItemString(llRowPos, "supp_code")
	
//1
	lsLogOut = " Row count  " +string(llRowPos )+ " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	
	
	If lsSKU <> lsSKUHold Then
		
		 SELECT Item_Master.User_Field10  , grp
  			INTO :lsModel , :lsGroup
    			FROM Item_Master  
   			WHERE ( Item_Master.Project_ID = :asproject ) AND  
         			( Item_Master.SKU = :lssku ) AND  
         			( Item_Master.Supp_Code = :lssuppcode )   ;
						
					lsSKUHold = lsSKU
						
	End If
	
		
	//2
	lsLogOut = "   lsSKU " +string(lssku) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()

		
	liCurrentFileCount = liCurrentFileCount + 1
	
	
	//3
	lsLogOut = "   liCurrentFileCount 1 " +string (liCurrentFileCount) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()

	
	llNewRow = idsOut.insertRow(0)
	
	If IsNull(lsComcastwarehouse) THEN lsComcastwarehouse = ''
	If IsNull(lsCusUser_field3) THEN lsCusUser_field3 = ''
	

	// 05/10 - PCONKL - IF a virtual SIK transaction, send a TSN instead of a TSU
	If lsWarehouseType =  'S' Then
		lsOutString = 'TSN|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TSN$$HEX1$$1920$$ENDHEX$$
	Else
		lsOutString = 'TSU|'  //Tran type - $$HEX1$$1820$$ENDHEX$$TSU$$HEX1$$1920$$ENDHEX$$
	End If

	// 06/10 - PCONKL - For SIK virtual shipment, hardcode From Site ID to a Menlo Facility
	If lsWarehouseType =  'S' Then
		lsOutString += "VMEN01|"
	Else
		lsOutString += lsComcastwarehouse + "|"  // From Site ID $$HEX2$$13202000$$ENDHEX$$Ship From Warehouse User_Field1
	End If
	
	// 05/10 - PCONKL - For a warehouse Transfer, get the To Site ID from the Receiving Warehouse
	If lsOrdType = 'Z' Then
		lsOutString += lsToSiteID + '|' // To Site ID - Warehouse.User_Field1
	Else
		If lsWarehouseType =  'S' and left(lsCustCode,4) = 'COM-' Then /* If SIK, use warehouse Site ID instead of Customer (Which doesnt exist - Hardcoded since it oesnt matter which of Menlo's sites we use)*/
			lsOutString += lsComcastwarehouse + "|" /*The warehouse code in SIMS shipping is really the SIK warehouse we are shipping to*/
		Else
			lsOutString += lsCusUser_field3 + '|' // To Site ID -  Customer.User_field3
		End If
	End If
		
	
	If IsNull(lsOrdNo) THEN lsOrdNo = ''
	lsOutString += lsOrdNo + '|'  // Reference Number $$HEX2$$13202000$$ENDHEX$$SIMS Order Number (??)
	
	lsOutString += '' + '|'  // Container Temp ID $$HEX2$$13202000$$ENDHEX$$Blanks		

	lsOutString+= '' + '|'  //Start Date
	
	// 05/10 - PCONKL - ADding 3 new fields in the middle for Status, Pallet_ID and BOL
	lsOutString+= '' + '|'  //Status
		
	//Pallet ID 
	If idsdoSerialCarton.GetItemString(llRowPos, "Pallet_ID") <> '-'  Then
		lsOutString += idsdoSerialCarton.GetItemString(llRowPos, "Pallet_ID")	 + "|"
	Else
		lsOutString += '' + '|'
	End If
	
	lsOutString += lsOrdNo + '|'  /* BOL NO - SIMS Order?? */
		
	// ***  End New Fields ***

	// 05/10 - Serial No is mapped differently depending on Product type (CPE vs DTA)
	// 10/10 - PCONKL - Serial Numbers and addresses being mapped in reportstore, Serial will always be in the the serial_no field once data is cleansed. THere is a source field which will determine new or old mapping logic
	
	
//	Choose Case Upper(lsGroup)
//			
//		Case "CPE"
//			
//			lsserial = idsdoSerialCarton.GetItemString(llRowPos, "user_field5")	/*field 19 - M-Card Serial*/
//			
//			// 07/10 - PCONKL - If a product is mislabeled as CPE, the M-Card Serial wont be available.
//			If IsNull(lsserial) or lsSerial = '' THEN
//				lsserial = idsdoSerialCarton.GetItemString(llRowPos, "Serial_No")	
//			End If
//			
//		Case else /*Default to DTA */
//			
//			lsserial = idsdoSerialCarton.GetItemString(llRowPos, "Serial_No")	
//			
//	End Choose
	
	lsSerial = uf_map_address(idsdoSerialCarton, llRowPos,"SERIAL_NO",lsGroup)
	
	
	//4
	lsLogOut = "   lsSerial " +lsSerial + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	
	
	If IsNull(lsserial) THEN lsserial = ''
	
	lsOutString += lsserial + '|'  //Serial $$HEX2$$13202000$$ENDHEX$$
	lsOutString += 'S'  + '|'   //Detail Type $$HEX3$$132020001820$$ENDHEX$$S$$HEX1$$1920$$ENDHEX$$

//	lssku = idsdoSerialCarton.GetItemString(llRowPos, "sku")
//	lssuppcode = idsdoSerialCarton.GetItemString(llRowPos, "supp_code")
//	
//	If lsSKU <> lsSKUHold Then
//		
//		 SELECT Item_Master.User_Field10  , grp
//  			INTO :lsModel , :lsGroup
//    			FROM Item_Master  
//   			WHERE ( Item_Master.Project_ID = :asproject ) AND  
//         			( Item_Master.SKU = :lssku ) AND  
//         			( Item_Master.Supp_Code = :lssuppcode )   ;
//						
//						lsSKUHold = lsSKU
//						
//	End If
	
	
	if IsNull(lsModel) THEN lsModel = ''
	
	lsOutString += lsModel + '|'  // $$HEX1$$1820$$ENDHEX$$Model$$HEX4$$1920200013202000$$ENDHEX$$Item_Master.User_field10
	
	
	
	
	//5
	lsLogOut = "   lsOutString " +lsOutString + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	

	//Address1 -  CPE = Cable Card Unit Address Field 20 $$HEX2$$13202000$$ENDHEX$$M-Card Unit Address (UF3),   				DTA = MAC Address
	//Address2 - CPE = Host Embedded Serial Number Field 10 $$HEX2$$13202000$$ENDHEX$$Set-top Serial Number - (UF1?),		DTA = Unit Address
	//Address3 - CPE = Host Embedded STB MAC Field 15 $$HEX2$$13202000$$ENDHEX$$eSTB MAC - (mac_id)							DTA = Blank
	//Address4  - CPE =Host Embedded Cable Modem MAC Field 13 $$HEX2$$13202000$$ENDHEX$$eCM MAC (UF4)					DTA = Blank
	//Address5  - CPE =Host ID Field 12 $$HEX2$$13202000$$ENDHEX$$Host ID (UF2)
	
	// 08/10 - Per Chris Smolen and Jim martin, Address 1 and 2 need to be swapped for DTA product.
	// 10/10 - PCONKL -  addresses being mapped in reportstore, if data has been cleansed or laoded by REport Store, the Addresses will be mapped generically, otherwise mapped using exisiting group based logic

	// 05/10 - PCONKL - Mapping different for CPE or DTA product
//	Choose Case Upper(lsGroup)
//			
//		Case "CPE"
//			
//				lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field3")
//				lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "serial_no")
//				lsAddress[3] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//				lsAddress[4] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field4")
//				lsAddress[5] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field2")
//
//		Case Else /* Default to DTA */
//			
//			//lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//			//lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field1")
//			
//			lsAddress[1] =  idsdoSerialCarton.GetItemString(llRowPos, "user_field1")
//			lsAddress[2] =  idsdoSerialCarton.GetItemString(llRowPos, "mac_id")
//			
//			lsAddress[3] = ""
//			lsAddress[4] = ""
//			lsAddress[5] = ""
//			
//	
//	End Choose

// GWM - 6/3/2011 - Add Attribute Level Processing fields
	
	lsAddress[1] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS1",lsGroup)
	lsAddress[2] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS2",lsGroup)
	lsAddress[3] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS3",lsGroup)
	lsAddress[4] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS4",lsGroup)
	lsAddress[5] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS5",lsGroup)
	lsAddress[6] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS6",lsGroup)
	lsAddress[7] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS7",lsGroup)
	lsAddress[8] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS8",lsGroup)
	lsAddress[9] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS9",lsGroup)
	lsAddress[10] = uf_map_address(idsdoSerialCarton, llRowPos,"ADDRESS10",lsGroup)
	
	
	
	//6
	lsLogOut = "   lsAddress1  " +lsAddress[1] +lsAddress[2]+lsAddress[3]+lsAddress[4]+lsAddress[5]+ " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	
	
	
	//7
	lsLogOut = "   lsAddress2 " +lsAddress[6] +lsAddress[7]+lsAddress[8]+lsAddress[9]+lsAddress[10]+ " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
	
		
	
	if IsNull(lsAddress[1]) THEN lsAddress[1] = ""
	if IsNull(lsAddress[2]) THEN lsAddress[2] = ""
	if IsNull(lsAddress[3]) THEN lsAddress[3] = ""
	if IsNull(lsAddress[4]) THEN lsAddress[4] = ""
	if IsNull(lsAddress[5]) THEN lsAddress[5] = ""
	if IsNull(lsAddress[6]) THEN lsAddress[6] = ""
	if IsNull(lsAddress[7]) THEN lsAddress[7] = ""
	if IsNull(lsAddress[8]) THEN lsAddress[8] = ""
	if IsNull(lsAddress[9]) THEN lsAddress[9] = ""
	if IsNull(lsAddress[10]) THEN lsAddress[10] = ""
	
	lsOutString += lsAddress[1] + '|'  
	lsOutString += lsAddress[2] + '|'  
	lsOutString += lsAddress[3] + '|'  
	lsOutString += lsAddress[4] + '|'  
	lsOutString += lsAddress[5] + '|'    
	lsOutString += lsAddress[6] + '|'  
	lsOutString += lsAddress[7] + '|'  
	lsOutString += lsAddress[8] + '|'  
	lsOutString += lsAddress[9] + '|'  
	lsOutString += lsAddress[10]   


	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	// 05/10 - PCONKL - In addition to 1000 record limit per file, we also want a seperate file per Pallet
	IF liCurrentFileCount >= 1000 or idsdoSerialCarton.GetItemString(llRowPos, "Pallet_ID")  <> lsPalletSave THEN

	
	
	//8
	lsLogOut = "   liCurrentFileCount " + string (liCurrentFileCount) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()

	
	
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		
	//9
	lsLogOut = "   batch seq start  " + string (ldBatchSeq) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()

		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		
			
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Comcast!'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
//10
	lsLogOut = "   batch seq end   " + string (ldBatchSeq) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()
		
	
		liCurrentFileCount = 0
		
		liCurrentFileNum = liCurrentFileNum + 1
		
	//11
	lsLogOut = "   liCurrentFileCount next  " +string (liCurrentFileCount)+ " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()

		
		
		
	END IF	
	
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'file_name', 'GR' + String(ldBatchSeq,'00000')   + '-' +  string(liCurrentFileNum) + '.DAT') /* 7/10 - PCONKL - Moved from above so first rec of new pallet is in new file*/
	
	lsPalletSave = idsdoSerialCarton.GetItemString(llRowPos, "Pallet_ID") 
	
next /*next output record */

//Write the Outbound File


//12
	lsLogOut = " Start outbound flatfile in  " + string (idsOut) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()


gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


//13
	lsLogOut = " End  outbound flatfile in  " + string (idsOut) + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
	FileWrite(gilogFileNo,lsLogOut)
	Yield()


//Write LMS Outbound File

liRC = this.uf_lms_gi(asProject, asDONo)

//TimA 04/24/13 what to show how long it took to send the email
lsLogOut = "        End Function call Creating GI ASN Email to Comcast For DONO: " + asDONO + " - " + String(Today(), "mm/dd/yyyy hh:mm:ss")
FileWrite(gilogFileNo,lsLogOut)
Yield()

Return 0
end function

public function long getomsproperties (long _lineitemno);
String lsSKU, lsSuppCode

Long lLDetailCount, lLDetailPos, llAllocQty, llLineItem

llAllocQty = -1			// Will return an error if line item is not found in Detail

lLDetailCount = idsDODetail.RowCount()
For lLDetailPos = 1 to lLDetailCount

	llLineItem = idsdoDetail.GetItemNumber(llDetailPos,'Line_Item_No')
	If llLineItem = _lineitemno then
		lsSKU = idsdoDetail.GetITemString(llDetailPos,'SKU')
		lsSuppCode = idsdoDetail.GetITemString(llDetailPos,'Supp_Code')
		llAllocQty = idsdoDetail.GetITemNumber(llDetailPos,'alloc_qty')
		
//TAM 2012/03/37  Moved OMS Product (Fullfilment Code) to UF18
		
		//Retrieve the ItemMaster Values
		Select User_field11, USer_Field12, USer_Field13, USer_Field14, User_Field15, User_field16, User_Field18
		Into	:isOMSProductNbr, :isOMSCode, :isOMSMake, :isOMSName, :isOMSModel, :isDeviceType, :isOMSProduct
		From Item_MAster
		Where Project_id = 'Comcast' and sku = :lsSKU and Supp_Code = :lsSuppCode;
		
	End If

next

return llAllocQty

end function

public function integer getfileopen ();integer	liFileNo
string 	lsLogOut

	// 09/11 - PCONKL - Can't write too many records to a variable, bogs down - Open and stream to file for each record
	idBatchSeq = gu_nvo_process_files.uf_get_next_seq_no('COMCAST','EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If idBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor SIK Goods Issue Confirmation.~r~rConfirmation will not be sent to Comcast!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
	/* GWM - 8/28/2012 - Change type of file from GI to BI to have bulk order posted differently */
	isFileName = ProfileString(gsInifile,"Comcast","flatfiledirout","") + '\' +  'BI' + String( idBatchSeq,'00000' ) +  '.XML'
	
	liFileNo = FileOpen(isFileName,StreamMode!,Write!,LockReadWrite!,Append!)
	If liFileNo < 0 Then
		lsLogOut = "        *** Unable to open output file for Comcast OMS Bulk Orders. File will not be sent'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If


return liFileNo

end function

public function integer closeandsendfile (integer _fileno);string		lsLogOut
blob		lsBlob
long		llRC


	// 05/11 - PCONKL - Current DB issues are sometimes causing the TRAX process to timeout updating the Freight Cost. AS a band-aid, 
	//							send the file to me to manually add freight cost instead of dealing with the wrath of Comcast when they are 
	//							rejected on ther side
	If ibNoFreightCost Then
		
		isXML = isXMLHeader + isXMLBody + isXMLFooter
		//gu_nvo_process_files.uf_send_email("COMCAST","conklin.peter@con-way.com","*****Comcast OMS Bulk ORder Postback missing Freight charges - GI-"  + String(idBatchSeq,'00000') +  '.XML',isXML,"")
		gu_nvo_process_files.uf_send_email("COMCAST","morrison.gail@con-way.com","*****Comcast OMS Bulk Order Postback missing Freight charges - GI-"  + String(idBatchSeq,'00000') +  '.XML',isXML,"")
			
		/* Do not save file.  Will be corrected with the frieght cost and manually sent */
		isXML = ""
		FileClose(_fileNo)
		FileDelete(isFileName)
		Return -1
		
	Else
	
		llRC = FileWriteEx(_fileNo,blob(isXMLFooter)) /*Write the footer*/
			
		FileClose(_fileNo)
		
		//Read back the contents and convert to ANSI... I'm sure there is a better way but we can't write the XML out in Line Mode or we get a CR/LF after each record
		_fileNo = FileOpen(isFileName,StreamMode!,Read!,LockRead!)
		If _fileNo < 0 Then
			lsLogOut = "        *** Unable to open output file for Comcast OMS Bulk Orders. File will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
		
		FileReadEx(_fileNo,lsblob)
		FileClose(_fileNo)
		FileDelete(isFileName)
		isXML = String(lsBlob)
		
		_fileNo = FileOpen(isFileName,TextMode!,Write!,LockReadWrite!,Append!,EncodingANSI!)
		If _fileNo < 0 Then
			lsLogOut = "        *** Unable to open output file for Comcast OMS Bulk Orders. File will not be sent'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
		llRC = FileWriteEx(_fileNo,isXML)
		FileClose(_fileNo)

	End If
	
return 0

end function

public function integer setdevicebody (integer _devicenbr);integer 	retVal = 0
long 		llRC
	
isXMLBody = ''

isXMLBody += "<ProductShipped>"

	//Product Code
	isXMLBody += "<ProductCode>"
	
	If NOt isnull(isOMSCode) Then
		isXMLBody +=isOMSCode
	End If
	
	isXMLBody += "</ProductCode>"
	
	//Product ID
	isXMLBody += "<ProductID>"
	
	If Not isnull(idsDevices.GetITemString(_deviceNbr,'Product_id')) Then
		isXMLBody += idsDevices.GetITemString(_deviceNbr,'Product_id')
	End If
	
	isXMLBody += "</ProductID>"
	
	//FulFillment Code
	isXMLBody += "<FulfillmentCode>"
	
	If NOt isnull(isOMSProduct) Then
		isXMLBody += isOMSProduct
	End If
	
	isXMLBody += "</FulfillmentCode>"
	
	
	//Devices Shipped (for Line Item)
	isXMLBody += "<DevicesShipped>"
			
		isXMLBody += "<DeviceShipped>"
		
		//DEvice Name
		isXMLBody += "<Name>"
		
		If NOt isnull(isOMSName) Then
			isXMLBody += isOMSName
		End If
		
		isXMLBody += "</Name>"
		
		//Make
		isXMLBody += "<Make>"
		If NOt isnull(isOMSMake) Then
			isXMLBody +=isOMSMake
		End If
		
		isXMLBody += "</Make>"
		
		//Model
		isXMLBody += "<Model>"
		If NOt isnull(isOMSModel) Then
			isXMLBody += isOMSModel
		End If
		
		isXMLBody += "</Model>"
		
//			//Serial - Not serialized
//			isXMLBody += "<SerialNumber></SerialNumber>"
//											
//			//Unit ID - Not captured
//			isXMLBody += "<UnitID></UnitID>"
//						
//			//RFMACAddress - not captured
//			isXMLBody += "<RFMACAddress></RFMACAddress>"
			
		//Condition (Inv Type)
		isXMLBody += "<Condition>"
		
	//	If ldsProducts.GetITemString(llRowPos,'inventory_type') = 'N' Then
			isXMLBody += "New"
	//	Else
	//		isXMLBody += "Used"
	//	End If
		
		isXMLBody += "</Condition>"
		
		//Device Type
		isXMLBody += "<DeviceType>"
		
		If NOt isnull(idsDevices.GetITemString(_deviceNbr,'device_type')) Then
			isXMLBody += idsDevices.GetITemString(_deviceNbr,'device_type')
		End If
					
		isXMLBody += "</DeviceType>"
		
		//Device ID
		isXMLBody += "<DeviceID>"
		
		If NOt isnull(idsDevices.GetITemString(_deviceNbr,'device_id')) Then
			isXMLBody += idsDevices.GetITemString(_deviceNbr,'device_id')
		End If
					
		isXMLBody += "</DeviceID>"
		
		isXMLBody += "</DeviceShipped>"
				
	isXMLBody += "</DevicesShipped>"
	isXMLBody += "</ProductShipped>"
	
return retVal

end function

public function integer uf_multiple_mac_id (string asproject, string asorderid, long altransid);integer liRC, liRecCnt, liTo
long llNewRow
datetime ldtToday
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName, lsFileNamePath, lsEmail, lsText

liRC = 0
ldtToday = DateTime(Today(), Now())

If Not isvalid(idsMultiMac) Then
	idsMultiMac = Create Datastore
	idsMultiMac.Dataobject = 'd_comcast_multiplemacid'
	liTo = idsMultiMac.SetTransobject(sqlca)
End If

idsMultiMac.Reset()

lsLogOut = "      Creating TH For Multiple Mac ID report of: " + asOrderID
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)	/* wrtie to Screen */

liRecCnt = idsMultiMac.Retrieve(0)

If liRecCnt < 0 Then
	lsLogOut = "                  *** Unable to retrieve Multiple Mac ID for date: " + asOrderID
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
Else
	If liRecCnt = 0 Then
		llNewRow = idsMultiMac.InsertRow(1)
		idsMultiMac.SetItem(llNewRow, 1, "No records unprocessed")
	End If
	// Insert header row
	llNewRow = idsMultiMac.InsertRow(1)
	idsMultiMac.SetItem(llNewRow, 1, "Trans Nbr")
	idsMultiMac.SetItem(llNewRow, 2, "Serial No")
	idsMultiMac.SetItem(llNewRow, 3, "Model No")
	idsMultiMac.SetItem(llNewRow, 4, "ITD Addr 1")
	idsMultiMac.SetItem(llNewRow, 5, "ITD Pallet Id")
	idsMultiMac.SetItem(llNewRow, 6, "CS Serial No")
	idsMultiMac.SetItem(llNewRow, 7, "CS Pallet Id")
	idsMultiMac.SetItem(llNewRow, 8, "CS Mac Id")

	// Insert title row
	llNewRow = idsMultiMac.InsertRow(1)
	idsMultiMac.SetItem(llNewRow, 1, "Report of unprocessed multiple Mac Ids pending resolution")

	lsLogOut = '       -  ' + String(ldtToday, 'mm/dd/yyyy hh:mm:ss') + ' ' + String(liRecCnt) + ' records retrieved...'
	FileWrite(giLogFileNo, lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)	/* wrtie to Screen */	
	
	// Write file. . .
	lsFileName = 'Comcast_Multiple_Mac_IDs_' + String(DateTime( today(), now()), 'yyyymmddhhmmss') + '.xls'
	lsFileNamePath = ProfileString(gsInifile, 'Comcast', 'EIS-Recon-Directory','') + '\' + lsFileName
	idsMultiMac.SaveAs ( lsFileNamePath, Excel!, false )
	
	// Email the file
	lsText = 'Attached is a report of all unprocessed multiple Mac Id records for: ' + String(ldtToday, 'mm/dd/yyyy')
	lsEmail = ProfileString(gsInifile, 'Comcast', 'CUSTEMAIL','')
	If lsEmail > '' Then
		gu_nvo_process_files.uf_send_email('COMCAST', lsEmail, 'Comcast Multiple Mac IDs', lsText, lsFileNamePath)
	End if
	
End If

return liRC

end function

public function integer uf_missing_from_site (string asproject, string asorderid, long altranid);/* Gail - 4/4/2013 - Added function to send email to Comcast Ops to report a FromSiteID missing from SIMS */
integer liRC, liRecCnt, liTo
long llNewRow
datetime ldtToday
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName, lsFileNamePath, lsEmail, lsText

liRC = 0
ldtToday = DateTime(Today(), Now())

lsLogOut = "      Creating TH For Missing ITH/ITD FromSiteID from SIMS - Report of: " + asOrderID
lsFileNamePath = ''
lsFileName = ''

FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)	/* wrtie to Screen */
	
	// Email the file
	lsText = 'Comcast ITH-ITD processing for ' + asOrderID +  'GMT revealed that a file has been received containing a FromSiteID not found in ' + &
			'SIMS customer table.~n~rThe serial numbers for this file have not been added to SIMS.~n~rPlease ' + &
			'contact the Support Team to identify the missing site ID, enter the customer in SIMS and have the sending party ' + &
			'resubmit the records.~n~rThis is a notification only.  Please do not reply to this message.~n~rThank you, SIMS' 
			
	lsEmail = ProfileString(gsInifile, 'Comcast', 'CUSTEMAIL','')
	If lsEmail > '' Then
		gu_nvo_process_files.uf_send_email('COMCAST', lsEmail, 'Comcast ITH-ITD Missing FromSiteID Notification', lsText, lsFileNamePath)
	End if


return liRC

end function

public function integer uf_dupe_record (string asproject, string asorderid, long altranid);/* Gail - 4/4/2013 - Added function to report a Duplicate Record from ITH-ITD process. */
// Email message to be added at a later time
integer liRC, liRecCnt, liTo
long llNewRow
datetime ldtToday
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName, lsFileNamePath, lsEmail, lsText

liRC = 0
ldtToday = DateTime(Today(), Now())

return liRC
end function

public function integer uf_insert_error (string asproject, string asorderid, long altranid);/* Gail - 4/5/2013 - Added function to report an insert error from ITH-ITD process. */

integer liRC, liRecCnt, liTo
long llNewRow
datetime ldtToday
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName, lsFileNamePath, lsEmail, lsText

liRC = 0
ldtToday = DateTime(Today(), Now())

lsLogOut = "      Creating TH For Error on Insert to Carton/Serial from SIMS - Report of: " + asOrderID + &
				".  Error will not be reported at this time as requested by Comcast Operations."
lsFileNamePath = ''
lsFileName = ''
/*
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)	/* wrtie to Screen */
	
	// Email the file
	lsText = 'Comcast ITH-ITD processing for ' + asOrderID +  'GMT revealed that an error occurred on insert to the Carton/Serial table.~n~rThis is a notification only.  Please do not reply to this message.~n~rThank you, SIMS' 
			
	lsEmail = ProfileString(gsInifile, 'Comcast', 'CUSTEMAIL','')
	If lsEmail > '' Then
		gu_nvo_process_files.uf_send_email('COMCAST', lsEmail, 'Comcast Error on Insert to Carton/Serial  Notification', lsText, lsFileNamePath)
	End if
*/
return liRC
end function

public function integer uf_missing_sku_in_im (string asproject, string asorderid, long altranid);/* Gail - 4/4/2013 - Added function to send email to Comcast Ops to report a FromSiteID missing from SIMS */
integer liRC, liRecCnt, liTo
long llNewRow
datetime ldtToday
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName, lsFileNamePath, lsEmail, lsText

liRC = 0
ldtToday = DateTime(Today(), Now())

lsLogOut = "      Creating TH For Missing ITH/ITD SKU/SuppCode from SIMS - Report of: " + asOrderID
lsFileNamePath = ''
lsFileName = ''

FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)	/* wrtie to Screen */
	
	// Email the file
	lsText = 'Comcast ITH-ITD processing for ' + asOrderID +  'GMT revealed that an expected SKU/	SuppCode combination is ' + &
			'missing from SIMS item master.~n~rThe serial numbers for the transaction file have not been added to SIMS.~n~rPlease ' + &
			'contact the Support Team to identify the missing SKU/SuppCode, enter into SIMS and have the sending party ' + &
			'resubmit the records.~n~rThis is a notification only.  Please do not reply to this message.~n~rThank you, SIMS' 
			
	lsEmail = ProfileString(gsInifile, 'Comcast', 'CUSTEMAIL','')
	If lsEmail > '' Then
		gu_nvo_process_files.uf_send_email('COMCAST', lsEmail, 'Comcast ITH-ITD Missing SKU/SuppCode Notification', lsText, lsFileNamePath)
	End if


return liRC

end function

on u_nvo_edi_confirmations_comcast.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_comcast.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

