HA$PBExportHeader$u_nvo_edi_confirmations_ws.sru
forward
global type u_nvo_edi_confirmations_ws from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_ws from nonvisualobject
end type
global u_nvo_edi_confirmations_ws u_nvo_edi_confirmations_ws

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate, idsDoSerial, idsWODetail, idsWOPutaway
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode


string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_dst (string asproject, string asdono, string asstatus)
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for WS_PR  for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsFirstSuppCd,lsOrderType 
String		 lsIMUF6, lsIMUF7, lsIMUF8, lsIMUF11, lsTemp
Decimal	 ldLength, ldWidth, ldHeight, ldWeight   
DEcimal		ldBatchSeq
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

If Not isvalid(idsRODetail) Then
	idsRODetail = Create Datastore
	idsRODetail.Dataobject = 'd_ro_detail'
	idsRODetail.SetTransObject(SQLCA)
End If


If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()


lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)

lsFirstSuppCd =  Trim(idsRODetail.GetItemString(1,'supp_code'))
lsOrderType = idsROMain.GetItemString(1,'Ord_type') 
// Only send if Order Type is Supplier and Supplier Type of the first detail is in the list 
If idsROMain.GetItemString(1,'Ord_type') <> 'S' Then
	Return 99
Else 
	If lsFirstSuppCd <> 'PRS' and lsFirstSuppCd <> 'PRI' and lsFirstSuppCd <> 'PRP'and  lsFirstSuppCd <> 'PRL' and  lsFirstSuppCd <> 'PRM' and  lsFirstSuppCd <> 'PRC'and  lsFirstSuppCd <> 'PRMLY' and  lsFirstSuppCd <> 'PRV' and  lsFirstSuppCd <> 'PRV-INTERCO' and  lsFirstSuppCd <> 'PRP-INTERCO'  then 
		Return 99
	End If
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// Header Row
llNewRow = idsOut.insertRow(0)
	
lsOutString = 'Supp_Order_No' + lsDelimitChar+ 'Remark' + lsDelimitChar + 'Supp_Invoice_No' + lsDelimitChar + 'Ship_Ref' + lsDelimitChar + 'Request_Date' + lsDelimitChar
lsOutString += 'PR_GRN_No' + lsDelimitChar + 'PRS_Supplier_Name' + lsDelimitChar + 'SKU' + lsDelimitChar + 'Line_Item_No' + lsDelimitChar
lsOutString += 'Ord_UOM'  + lsDelimitChar + 'Ord_Qty'  + lsDelimitChar + 'Barcode-CTN'  + lsDelimitChar + 'Pack_Size'  + lsDelimitChar + 'Barcode-BOT'  + lsDelimitChar
lsOutString += 'Barcode-Gift'  + lsDelimitChar + 'Length' + lsDelimitChar + 'Width'   + lsDelimitChar + 'Height'  + lsDelimitChar + 'Weight' + lsDelimitChar + 'Lot_No' + lsDelimitChar
lsOutString += 'Alcohol' + lsDelimitChar + 'Label'  + lsDelimitChar + 'Stock_Format'  + lsDelimitChar + 'Giftbox'  + lsDelimitChar + 'Cap'  + lsDelimitChar + 'Special_Remark'
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
lsFileName = 'GRN' + String(Today(),'yyyymmddHHMMSS') + '.txt'
idsOut.SetItem(llNewRow,'file_name', lsFileName)


//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	//Master User Field11		
	If Not isNull(idsROMain.GetItemString(1,'Supp_Order_No')) Then
		lsOutString = idsROMain.GetItemString(1,'Supp_Order_No') + lsDelimitChar
	Else
		lsOutString = lsDelimitChar
	End If		

	//Remark	
	If Not isNull(idsROMain.GetItemString(1,'Remark')) Then
		lsOutString += idsROMain.GetItemString(1,'Remark') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Order Number
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar

	//Ship Ref	
	lsOutString += idsROMain.GetItemString(1,'ship_ref') + lsDelimitChar

	//Receipt Date	
	lsOutString += String(idsROMain.GetITemDateTime(1,'request_date'),'yyyy-mm-dd') + lsDelimitChar
	
	//Master User Field9	
	If Not isNull(idsROMain.GetItemString(1,'User_Field9')) Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field13 	
	If Not isNull(idsROMain.GetItemString(1,'User_Field13')) Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//SKU	
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')

	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar
	
	//Line Item Number	
	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	

	lsfind ="sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' and line_item_no = "+String(idsroputaway.GetItemNumber(llRowPos,'Line_Item_no'))+" " 
	llFindRow = idsRODetail.Find(lsfind , 1, idsRODetail.RowCount())	

	//Detail User Field2
	If (llFindRow > 0 and Not isNull(idsRODetail.GetItemString(llFindRow,'User_Field2'))) Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field1
	If (llFindRow > 0 and Not isNull(idsRODetail.GetItemString(llFindRow,'user_field1'))) Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	
	//Get from Item_Master Records
	Select User_field6, User_field7, User_field8, User_field11, Length_2, Width_2, Height_2, Weight_2
	INTO :lsIMUF6, :lsIMUF7, :lsIMUF8, :lsIMUF11, :ldLength, :ldWidth,  :ldHeight, :ldWeight 
	From Item_Master
	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
	USING SQLCA;
			
	If IsNull(lsIMUF6) then lsIMUF6 = ''
	lsOutString += lsIMUF6  + lsDelimitChar

	If IsNull(lsIMUF11) then lsIMUF11 = ''
	lsOutString += lsIMUF11  + lsDelimitChar

	If IsNull(lsIMUF7) then lsIMUF7 = ''
	lsOutString += lsIMUF7  + lsDelimitChar

	If IsNull(lsIMUF8) then lsIMUF8 = ''
	lsOutString += lsIMUF8  + lsDelimitChar

	If IsNull(ldlength) then
		lsTemp = ''
	Else
		lsTemp = String(ldlength, '#####.00')
	End If

	lsOutString += lsTemp  + lsDelimitChar

	If IsNull(ldwidth) then
		lsTemp = ''
	Else
		lsTemp = String(ldwidth, '#####.00')
	End If

	lsOutString += lsTemp  + lsDelimitChar

	If IsNull(ldHeight) then
		lsTemp = ''
	Else
		lsTemp = String(ldHeight, '#####.00')
	End If

	lsOutString += lsTemp  + lsDelimitChar

	If IsNull(ldWeight) then
		lsTemp = ''
	Else
		lsTemp = String(ldWeight, '#####.00')
	End If

	lsOutString += lsTemp  + lsDelimitChar

	//Lot Number
	If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR 2	
	If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Putaway User_Field7
	If Not isNull(idsroputaway.GetItemString(llRowPos,'User_Field7')) Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'User_Field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Putaway User_Field8 	
	If Not isNull(idsroputaway.GetItemString(llRowPos,'User_Field8')) Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'User_Field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Putaway User_Field9
	If Not isNull(idsroputaway.GetItemString(llRowPos,'User_Field9')) Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'User_Field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Putaway User_Field10
	If Not isNull(idsroputaway.GetItemString(llRowPos,'User_Field10')) Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'User_Field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Putaway User_Field11 
	If Not isNull(idsroputaway.GetItemString(llRowPos,'User_Field11')) Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'User_Field11')) 
	End If		
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GRN' + String(Today(),'yyyymmddHHMMSS') + '.txt'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

Return 0
end function

public function integer uf_dst (string asproject, string asdono, string asstatus);//Send an email notification that an order was picked

String		lsFind, lsLogOut, lsText, lsSupplier, lsOrder, lsCustOrder, lsCustName, lsShipInstruction, lsWarehouse, lsEmail, ls_code_Type, lsSubject, lsFileName
Integer		liRC, liFileNo

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_detail'
	idsDoDetail.SetTransObject(SQLCA)
End If


idsdoDetail.Reset()

//Retreive Delivery Master, Detail for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsLogOut = "        Creating Picking Notification Email  For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

idsDoDetail.Retrieve(asDoNo)

lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')
lsSupplier = idsDoDetail.GetITemString(1,'Supp_Code')
lsOrder =  idsDoMain.GetItemString(1,'Invoice_no')
lsCustOrder =  idsDoMain.GetItemString(1,'Cust_Order_No')
lsCustName =  idsDoMain.GetItemString(1,'Cust_Name')
lsShipInstruction =  idsDoMain.GetItemString(1,'Shipping_Instructions')

If lsWarehouse = 'WS-BONDED' then ls_code_Type = 'EMBOND'
If lsWarehouse = 'WS-DP' then ls_code_Type = 'EMDP'

//Get Email Address From lookup table
Select Code_Descript into :lsEmail
From Lookup_Table
Where Code_ID = :lsSupplier and
		Project_id = :asProject and 
      Code_Type = :ls_code_Type ;     

//If No Address then and email is Not sent.  Return 
If isnull(lsEmail) Then lsEmail = '' 

lsLogOut = "        Creating Picking Notification Email For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Subject 
lsSubject = "Order Acknowledgment - " 
If Not isnull(lsCustOrder) Then
	lsSubject += lsCustOrder
End If

//Body

//Customer Name
lsText += "~n~n"
lsText = "Customer Name:~t"
If Not isnull(lsCustName) Then
	lsText += lsCustName + "~t~t System/Warehouse "
End If

lsText += "~n~n"

//Shipping Instructions
lsText += "Shipping Instructions:~t"
If Not isnull(lsShipInstruction) Then
	lsText +=lsShipInstruction
End If

lsText += "~n~n"

//Order Number 	
lsText += "XPO Ref:~t"
If Not isnull(lsOrder) Then
	lsText += lsOrder
End If

//Write the email...
If lsEmail > '' Then
	gu_nvo_process_files.uf_send_email("WS-PR",lsEmail,lsSubject,lsText,"")
Else
	lsLogOut = "        *** Email Address not present for  Order: " +  idsDoMain.GetITemString(1,'invoice_no') + ". ASN email will not be sent."
	FileWrite(gilogFileNo,lsLogOut)
End If

//Archive the file...
lsFileName = ProfileString(gsinifile,"WS-PR","archivedirectory","") + '\' + "ACK-"  + idsDoMain.GetITemString(1,'invoice_no') + ".txt"
If FIleExists(lsFileName) Then
	lsFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')
End IF

liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockREadWrite!,Append!)
If liFileNo > 0 Then
	FileWrite(liFileNo,lsText)
	FileClose(liFileNo)
End If


Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Send an email notification that an order was Confirmd

String		lsFind, lsLogOut, lsText, lsSupplier, lsOrder, lsCustOrder, lsCustName, lsShipInstruction, lsWarehouse, lsEmail, ls_code_Type, lsSubject, lsFileName
Integer		liRC, liFileNo

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetail) Then
	idsDoDetail = Create Datastore
	idsDoDetail.Dataobject = 'd_do_detail'
	idsDoDetail.SetTransObject(SQLCA)
End If


idsdoDetail.Reset()

//Retreive Delivery Master, Detail for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsLogOut = "        Creating Confirm Notification Email  For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

idsDoDetail.Retrieve(asDoNo)

lsWarehouse = idsDoMain.GetITemString(1,'wh_Code')
lsSupplier = idsDoDetail.GetITemString(1,'Supp_Code')
lsOrder =  idsDoMain.GetItemString(1,'Invoice_no')
lsCustOrder =  idsDoMain.GetItemString(1,'Cust_Order_No')
lsCustName =  idsDoMain.GetItemString(1,'Cust_Name')
lsShipInstruction =  idsDoMain.GetItemString(1,'Shipping_Instructions')

If lsWarehouse = 'WS-BONDED' then ls_code_Type = 'EMBOND'
If lsWarehouse = 'WS-DP' then ls_code_Type = 'EMDP'

//Get Email Address From lookup table
Select Code_Descript into :lsEmail
From Lookup_Table
Where Code_ID = :lsSupplier and
		Project_id = :asProject and 
      Code_Type = :ls_code_Type ;     

//If No Address then and email is Not sent.  Return 
If isnull(lsEmail) Then lsEmail = '' 

lsLogOut = "        Creating Confirm Notification Email For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Subject 
lsSubject = "Order Delivered - " 
If Not isnull(lsCustOrder) Then
	lsSubject += lsCustOrder + "~t~t System/Warehouse "
End If

//Body

//Customer Name
lsText += "~n~n"
lsText = "Customer Name:~t"
If Not isnull(lsCustName) Then
	lsText += lsCustName
End If

lsText += "~n~n"

//Shipping Instructions
lsText += "Shipping Instructions:~t"
If Not isnull(lsShipInstruction) Then
	lsText +=lsShipInstruction
End If

lsText += "~n~n"

//Order Number 	
lsText += "XPO Ref:~t"
If Not isnull(lsOrder) Then
	lsText += lsOrder
End If

//Write the email...
If lsEmail > '' Then
	gu_nvo_process_files.uf_send_email("WS-PR",lsEmail,lsSubject,lsText,"")
Else
	lsLogOut = "        *** Email Address not present for  Order: " +  idsDoMain.GetITemString(1,'invoice_no') + ". ASN email will not be sent."
	FileWrite(gilogFileNo,lsLogOut)
End If

//Archive the file...
lsFileName = ProfileString(gsinifile,"WS-PR","archivedirectory","") + '\' + "ACK-"  + idsDoMain.GetITemString(1,'invoice_no') + ".txt"
If FIleExists(lsFileName) Then
	lsFileName += '.' + String(DAteTime(Today(),Now()),'yyyymmddhhss')
End IF

liFileNo = FileOpen(lsFileName,LineMode!,Write!,LockREadWrite!,Append!)
If liFileNo > 0 Then
	FileWrite(liFileNo,lsText)
	FileClose(liFileNo)
End If


Return 0
end function

on u_nvo_edi_confirmations_ws.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_ws.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

