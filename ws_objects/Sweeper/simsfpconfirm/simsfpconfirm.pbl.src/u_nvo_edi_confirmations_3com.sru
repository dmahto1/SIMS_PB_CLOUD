$PBExportHeader$u_nvo_edi_confirmations_3com.sru
$PBExportComments$Process outbound edi confirmation transactions for 3COM
forward
global type u_nvo_edi_confirmations_3com from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_3com from nonvisualobject
end type
global u_nvo_edi_confirmations_3com u_nvo_edi_confirmations_3com

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	

end variables

forward prototypes
public function integer uf_rt (string asproject, string asrono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_gi (string asproject, string asdono, long aitransid)
public function integer uf_owner_change (ref datastore adsmain, ref datastore adspick, long aitransid)
public function integer uf_owner_change_workorder (string asproject, string aswono, long aitransid)
public function integer uf_vendor_po_update (string asdono, long allineitemno, string assku, string asponumber, decimal adprice, string asowner, decimal adqty)
public function string uf_inv_adjust_type (string asoldinvtype, string asnewinvtype)
public function string uf_qty_adjust_type (string asinvtype, long aloldqty, long alnewqty)
public function boolean getok2process (string asproject, long transferid, datetime tranfercreated)
public function integer uf_gr_gls_rma (string asproject, string asrono)
public function integer uf_gr_gls_po (string asproject, string asrono)
public function integer uf_gr_gls_wa (string asproject, string asrono)
public function integer uf_gls_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_gi_rma (string asproject, string asdono, long aitransid)
end prototypes

public function integer uf_rt (string asproject, string asrono);
//Process Goods Return

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow
Decimal	ldBatchSeq, ldMMXNBR
String	lsOutString, lsSKU, lsDispType, lsOrderNo, lsFind, lsCarrier, lsUF9, lsSupplier, lsLogout, lswarehouse
Integer	liRC
DateTime ldtTranstime

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

// *** 07/07 - PCONKL - Temprorary code to exclude transactions for RMA Warehouses ***
If Upper(idsroMain.GetITemString(1,'wh_code')) = '3CGLSAMI' or Upper(idsroMain.GetITemString(1,'wh_code')) = '3CGLSEMEA' Then
	lsLogOut = "        Not creating RT for RMA Warehouse For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

idsroPutaway.Retrieve(asRONO)

// 03/2006 - TAM - We need the Complete Date from the Receive Master instead of using the current timestamp which is GMT on the server.
ldtTranstime = idsroMain.GetITemDateTime(1,'complete_date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

lsOrderNo = idsromain.GetITemString(1,'Supp_invoice_no')
lsSupplier = idsromain.GetITemString(1,'supp_code')

//TAM   - We need warehouse info
lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))


lsCarrier = idsromain.GetITemString(1,'Carrier')
If isNull(lsCarrier) then lsCarrier = ''

//Rollup to Line Item SKU level
llRowCount = idsroPutaway.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	llLineItemNo = idsroPutaway.GetITemNumber(llRowPos,'Line_Item_No')
	
//	//No transactions for line items > 90000
//	If llLineItemNo >= 90000 Then Continue
	
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	
	//Ignore if SKU set to not send for RMC//MMX (IM UF9)
	Select User_field9 into :lsUF9
	From ITem_MAster
	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
	
	If lsUF9 = 'Y' Then Continue
	
	lsDispType = idsroPutaway.GetITemString(llRowPos,'User_field1') /*disposition Type*/
	llQty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
		
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo)
	If NOt isnull(lsDisptype) then /* 09/04 - PCONKL - we need a seperate row per disp type */
		lsFind += " and Upper(user_field1) = '" + Upper(lsDispType) + "'"
	End If
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'user_field1',lsDispType)
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
	End If
	
Next /*Putaway Row*/

//Write to output

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//all records in a single file for RT
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
		
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsDispType = idsGR.GetITemString(llRowPos,'user_field1')
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')

	lsOutString = 'RT~t' /*Transaction type - RMA Confirmation */
	lsOutString += lsOrderNO + '~t'  /*Order Number */
//	lsOutString += String(today(),'yyyy-mm-dd') + '~t' 
   lsOutString += String(ldtTransTime,'yyyy-mm-dd') + '~t' 
	
	//If LineITem Number is >= 90,000, send back zeros
	If llLineItemNo >= 90000 Then
		lsOutString +="000000~t"
	Else
		lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
	End If
		
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsSku + '~t'
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asProject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
	lsOutString += lsCarrier + '~t'
	lsOutString += String(today(),'hhmmss') + '~t' 
	lsOutString += lsDispType /*disposition code*/
			
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
Next /*Putaway Row*/

//Add a trailer Row
If llRowCount > 0 Then
	lsOutString = "TR~t" + String(llRowCount,'#####0') + '~t' + String(today(),'yyyymmddhhmmss')
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
End If

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

//TAMCCLANAHAN 
//Process Mark GT interface

if lswarehouse = "3COM-NL" then
		If Not isvalid(iu_nvo_marc_transactions) Then	
			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
		End If
	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)
end if


Return 0
end function

public function integer uf_gr (string asproject, string asrono);
// Create an MMX for inventory received as 3COM Owned (Or any other that wants notification)

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llOWner, llFindRow
Decimal	ldBatchSeq, ldMMXNBR
String	lsOutString, lsSKU, lsInvType, lsOrderNo, lsMessage, lsShipRef, lsSupplier, lsUF9,	&
			lsWarehouse, lsAddress1, lsCity, lsState, lsZip, lsCountry, lsEmail, lsOwner, lsOwnerHold, &
			lsShipToAddress, lsUF1, lsLogOut, lsFind
			
Integer	liRC
Boolean	lbSendTrans
DateTime ldtTranstime

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

// *** 07/07 - PCONKL - Temprorary code to exclude transactions for RMA Warehouses ***
If Upper(idsroMain.GetITemString(1,'wh_code')) = '3CGLSAMI' or Upper(idsroMain.GetITemString(1,'wh_code')) = '3CGLSEMEA' Then
	lsLogOut = "        Not creating GR for RMA Warehouse For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

idsroPutaway.Retrieve(asRONO)

llRowCount = idsroPutaway.RowCount()

lsOwnerHold = ''
lbSendTrans = False

// 03/2006 - TAM - We need the Complete Date from the Receive Master instead of using the current timestamp which is GMT on the server.
ldtTranstime = idsroMain.GetITemDateTime(1,'complete_date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

lsOrderNo = idsroMain.GetITemString(1,'supp_invoice_no')
If isnull(lsORderNo) then lsOrderNo = ''

lsShipRef = idsroMain.GetITemString(1,'Ship_ref')
If isnull(lsShipRef) Then lsShipRef = ''

//We need warehouse info
lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))
Select email_address, address_1, city, State, Zip, Country Into :lsEmail, :lsAddress1, :lsCity, :lsState, :lsZip, :lsCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsEmail) Then lsEmail = ''
If isnull(lsCountry) Then lsCountry = ''

//Format Address
lsShipToAddress = ''
If Not isnull(lsAddress1) Then lsShipToAddress = lsAddress1
If NOt isNull(lsCity) Then
	lsShipToAddress += " " + lsCity + ", "
End If
If NOt isNull(lsState) Then
	lsShipToAddress += lsState + " "
End If
If NOt isNull(lsZip) Then
	lsShipToAddress += lsZip + " "
End If

For llRowPos = 1 to lLRowCount /* For each Putaway Row */
	
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	lsSupplier = idsroPutaway.GetITemString(llRowPos,'supp_code')
	lsInvType = idsroPutaway.GetITemString(llRowPos,'Inventory_Type')
	lsOwner = idsroPutaway.GetITemString(llRowPos,'Owner_cd')
	llQty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsroPutaway.GetITemNumber(llRowPos,'Line_Item_No')
		
	//We only want to send for Owners (Suppliers) that are set in Supplier Master UF1
	If lsOWnerHold <> lsOWner Then
		
		Select User_Field1 into :lsUF1
		From Supplier 
		Where project_id = :asProject and supp_code = :lsOwner;
		
		If lsUF1 = 'Y' Then
			lbSendTrans = True
		Else
			lbSendTrans = False
		End If
		
	End If /* Owner Changed*/
	
	lsOwnerHold = lsOwner
	
	//If not sending for this owner, continue*/
	If Not lbSendTrans Then Continue
	
	//Ignore if SKU set to not send for RMC//MMX (IM UF9)
	Select User_field9 into :lsUF9
	From ITem_MAster
	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
	
	If lsUF9 = 'Y' Then Continue
	
	// 08/04 - PCONKL - Rollup to the Line item/SKU/Inv Type level
	lsFind = "po_item_number = " + String(llLineItemNo) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
	llFindRow = idsgr.Find(lsFind,1,idsgr.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsgr.SetItem(llFindRow,'quantity', (idsgr.GetItemNumber(llFindRow,'quantity') + llQty))
		
	Else /*not found, add a new record*/
													
		llNewRow = idsgr.InsertRow(0)
		idsgr.SetItem(llNewRow,'Inventory_type',lsInvType)
		idsgr.SetItem(llNewRow,'sku',lsSKU)
		idsgr.SetItem(llNewRow,'quantity',llQty)
		idsgr.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsgr.SetItem(llNewRow,'owner_cd',lsowner)
		
	End If
		
Next /*Putaway Row*/

//Write to output
llRowCount = idsgr.RowCount()
For llRowPos = 1 to lLRowCount
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	//we want each record in a seperate file (each batch seq break causes a new file)
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
	lsOutString = 'MM~t'
	lsOutString+= lsWarehouse + '~t' /* 04/04 - PCONKL*/
	lsOutString += '120~t' /*Transaction type - Receipt against PO */
	lsOutString += idsgr.GetITemString(llRowPos,'Inventory_Type') + '~t' /* Old Inv Type*/
	lsOutString += idsgr.GetITemString(llRowPos,'Inventory_Type') + '~t' /* New Inv Type*/
//	lsOutString += String(today(),'yyyymmddhhmmss') + '~t' 
   lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
	lsOutString += '~t' /*reason*/
	lsOutString += idsgr.GetITemString(llRowPos,'SKU') + '~t'
	lsOutString += String(idsgr.GetITemNumber(llRowPos,'quantity'), '#########0') + '~t'
	lsOutString += lsOrderNo + '~t' /*Order Number */
	lsOutString += String(idsgr.GetITemNumber(llRowPos,'po_item_number'),'#######0') + '~t' /*Line ITem Number*/
	
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asProject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
		
	lsOutString += left(lsShipRef,20) + '~t' /*Ship Ref for External Reference Number */
	lsOutString += left(idsgr.GetITemString(llRowPos,'Owner_Cd'),20) + '~t' /* Owner*/
	lsOutString += left(lsShipRef,20) + '~t' /*Ship Ref (again) for Rcv Slip Number */
	lsOutstring += '~t' /* PO NUmber (olnly for OCH) */
	lsOutstring += '~t' /* Internal Delivery Number */
	lsOutstring += lsShipToAddress + '~t' /*Ship to Address*/
	lsOutstring += lsCountry + '~t' /*Ship to Country*/
	lsOutstring += lsEmail  /*Email*/
	lsOutString += '~t'   /* last delimeter is for Price (only on Vendor PO Update)*/
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
Next
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

//TAMCCLANAHAN 
//Process Mark GT interface

if lswarehouse = "3COM-NL" then
		If Not isvalid(iu_nvo_marc_transactions) Then	
			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
		End If
	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)
end if

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long aitransid);//Prepare a Stock Adjustment Transaction for 3COM NAshville for the Stock Adjustment just made - REVENUE SIDE OF THE HOUSE
// uf_adjustment

Long			llNewRow, llOldQty, llNewQty, llNetQty, llRowCount, llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType,		&
				lsReason, 	lsTranType, lsSupplier, lsUF9, lsLogOut, lsWarehouse, &
				lsoldcoo, lsnewcoo, lsoldPo_No2, lsnewPo_No2, lsNewOwnerCD, lsTransParm, lsOldOwnerCD, &
				lsRefNo

Decimal		ldBatchSeq, ldMMXNbr
Integer		liRC
DateTime	ldtTransTime

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

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
// 03/05 - For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment

Select Trans_create_date, Trans_parm into :ldtTranstime, :lsTransParm
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())
/*
	 pvh - 12/01/06 - MARL
	3com Marl requirements state that we need to send a stock adjustment if the MARL ( revision level ) of a product
	changes when a return is processed.  We need to send these 30 minutes after the Return.

*/
if Upper( asProject ) = '3COM_NASH' and lsTransParm = 'MARL Change' then
	if NOT getOK2process( asProject, aladjustid, ldtTransTime ) then return 1 // new return code...should do nothing
end if
// eom

// pvh - 01/15/2007 - MARL - moved here so as not to write to log if transaction fails previous test.
lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)
// eom

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// *** 07/07 - PCONKL - Temprorary code to exclude transactions for RMA Warehouses ***
If idsadjustment.GetITemString(1,'Wh_Code') = '3CGLSAMI' or idsadjustment.GetITemString(1,'Wh_Code') = '3CGLSEMEA' Then
	lsLogOut = "        Not creating MMX for RMA Warehouse for For Adjust ID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

lsSku = idsadjustment.GetITemString(1,'sku')
lsSupplier = idsadjustment.GetITemString(1,'supp_code')

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

//TAM 03/03/2006 Change inventory type ROHS (G) to Normal (N)
//If (lsOldInvType = 'G') Then lsOldInvType = 'N'

// pvh - 06/06/06 RoHS-2 comment out this bit 'G' will now get translated
//If (lsNewInvType = 'G') Then lsNewInvType = 'N'


llOwnerID = idsadjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsadjustment.GetITemNumber(1,"old_owner")

//llAdjustID = idsadjustment.GetITemNumber(1,"c_adjust_no")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
lloldQty = idsadjustment.GetITemNumber(1,"old_quantity")

lsOldCOO = idsadjustment.GetITemString(1,"old_country_of_origin") /*original value before update!*/
lsNewCOO = idsadjustment.GetITemString(1,"country_of_origin")

lsOldPO_NO2 = idsadjustment.GetITemString(1,"old_Po_No2") /*original value before update!*/
lsNewPO_NO2 = idsadjustment.GetITemString(1,"Po_No2")

lsNewOwnerCd = idsadjustment.GetITemString(1,"new_owner_cd")
lsOldOwnerCd = idsadjustment.GetITemString(1,"old_owner_Cd")

lsReason = Left(idsadjustment.GetITemString(1,"reason"), 4)
If Isnull(lsReason) THEN lsReason = ''

lsRefNo = idsadjustment.GetITemString(1,"ref_no")
If Isnull(lsRefNo) THEN lsRefNo = ''
		
//TAMCCLANAHAN 
//Begin Process Mark GT interface

// Call MARC GT Interface on Change in Inventory Type, Original Owner, Qty, Bonded, COO --- To Be Coded Later 
lsWarehouse = idsadjustment.GetITemString(1,'Wh_Code')


If (lsOldInvType <> lsNewInvType) or (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (lsOldPo_no2 <> lsNewPo_No2) or (lsOldCoo <> lsNewCoo) Then
	if lswarehouse = "3COM-NL" then
		// pvh - 12/01/06 - Marl
		if  lsTransParm <> 'MARL Change' then
			If Not isvalid(iu_nvo_marc_transactions) Then	
				iu_nvo_marc_transactions = Create u_nvo_marc_transactions
			End If
			iu_nvo_marc_transactions.uf_corrections(asProject,alAdjustID)
		end if
	end if
End If

//End Marc GT Process

//If not 3COM owned then continue
// 01/05 - PCONKL - Now sending adjustments for ALL Owners
//If Upper(left(idsadjustment.GetITemString(1,"old_owner_cd"),4)) <> '3COM' Then
//	Return 0
//End IF
		
//03/05 - PCONKL - If we are doing qualitative adjustments between 2 existing buckets, they are going to appear here
//						as 2 quantitative adjustments. This has been captured in the adjustment screen. The record that is being decremented
//						does not need to be reported - only the row being incremented. The parm has been set to 'SKIP' for the row being decremented

//						For the row being incremented, we have also capture the old inv type/owner from the row being decremented 
//						so it can be reported here

If lsTransParm = 'SKIP' Then
	 Return 0
ElseIf Pos(lsTransParm,'OLD_INVENTORY_TYPE') > 0 Then
	lsOldInvType = Mid(lsTransParm,(Pos(lsTransParm,'=') + 1),999)
ElseIf Pos(lsTransParm,'OLD_OWNER') > 0 Then
	llOrigOwnerID = Long(Mid(lsTransParm,(Pos(lsTransParm,'=') + 1),999))
End If

	
//Ignore if SKU set to not send for RMC//MMX (IM UF9)
Select User_field9 into :lsUF9
From Item_Master
Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
	
If lsUF9 = 'Y' Then
	Return 0
End If

//We are only sending a transaction for an inventory type (storage loc in SAP) change or an OWNER CHG to 3COM, no qty change transactions
// 03/05 - PCONKL - now sending Qty adjustments for NON 3COM owned

If lsOldInvType = lsNewInvType and llOwnerID = llOrigOwnerID and llNewQty = llOldQty Then Return 0
							
If (lsOldInvType <> lsNewInvType) Then	/*Inventory Type Changed*/
		
//	lsReason = ''
	lsTranType = ''
		
	//Combination of New/Old Inv Type will determine transaction type
	lsTranType = uf_inv_adjust_Type(lsOldInvType, lsNewInvType)

	If lsTranType = '' Then Return 0 /*no transaction if not an applicable change*/
		
ElseIf llOwnerID <> llOrigOWnerID THen /* owner changed*/
		
	//We only care of the owner is changing TO 3COM (or a qty chgd for existing 3COM)
	//If Upper(left(idsadjustment.GetITemString(llRowPos,"owner_owner_cd"),4)) = '3COM' Then
			
	lsTranType = 'OCH'
			
ElseIf llNewQty <> llOldQty Then /* Qty Changed - now being reported as of 03/05 */
	
	//Only reporting for Non 3COM owner
	If Upper(left(idsadjustment.GetItemString(1,"old_owner_cd"),4)) = '3COM' Then
		Return 0
	End IF
	
	//Trans Code based on inventory type
	lsTranType = uf_qty_adjust_Type(lsNewInvType,llOldQty,llNewQty)
	
	if lsTranType = '-1' then return 0 //dts - 08/29/06 - not sending transaction if lsTransType = -1
		
Else /*Inv Type, Owner and QTY Didn't change - no transaction necessary*/
		
	Return 0
		
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Calculate net qty chg
If llOldQty = llNewQty Then
	llnetQty = llNewQty
Else
	llnetQty = abs(llNewQty - llOldQty)
End If

lsOutString = 'MM~t' /*rec type = Material Movement*/
lsOutString += Upper(idsAdjustment.GetItemString(1,'wh_code')) + '~t' /* 04/04 - PCONKL */
lsOutString += lsTranType + '~t'
lsOutString += left(lsOldInvType,1) + '~t' /*old Inv Type*/
lsOutString += left(lsNewInvType,1) + '~t' /*New Inv Type*/
//lsOutString += String(today(),'yyyymmddhhmmss') + '~t' 
lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
lsOutString += lsReason + '~t' /*reason*/
lsOutString += lsSku + '~t'
lsOutString += String(llNetQty) + '~t'
lsOutString += '~t' /*Order Number not applicable*/
lsOutString += '~t' /*Line Item Number not applicable*/
	
ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asproject,'MMX','MMX_NBR') /* next available unique MMX Number */

lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
lsOutString += String(alAdjustID,'#########0') + '~t' /*Ref # */

//lsOutString +=  '~t' /*OWner*/
//lsOutString += lsNewOwnerCd + '~t' /* 01/05 - PCONKL - sending owner now */
lsOutString += lsOldOwnerCd + '~t' /* 02/10 - MEA - Dara reports bug */
lsOutString +=  '~t' /*Receive Slip Number*/
lsOutString +=  lsRefNo + '~t' /* Put value Refon in this column as per Dara */
									   /* Inbound Receipt PO Number*/
lsOutString +=  '~t' /*Internal Delivery Number ( MNxxxxxxx from UF6)*/
lsOutString +=  '~t' /*Ship To Address*/
lsOutString +=  '~t' /*Ship To Country*/
lsOutString += '~t'   /*Contact Email - last delimeter is for Price (only on Vendor PO Update)*/
		
llNewRow = idsout.insertRow(0)
	
idsout.SetItem(llNewRow,'Project_id', asproject)
idsout.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsout.SetItem(llNewRow,'line_seq_no', 1)
idsout.SetItem(llNewRow,'batch_data', lsOutString)
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_gi (string asproject, string asdono, long aitransid);String	lsLogOut
Datastore	ldsSerial
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow, llCartonPos, llLineItemNo, llLoopCount, llLoopPos, &
				llSerialCount
				
String		lsFind, 	lsOutString, lsMessage,	lsCarTonHold, lsConsignee, lsDono, lsSerialNo,	&
				lsSerial1, lsSerial2, lsSerial3, lsSerial4, lsAllserialNo, lsCartonNo, lsSKU, lsSuppCode, lsCOO, lsUOM,	&
				lsuccscompanyprefix, lsuccswhprefix, lsWarehouse, lsUCCCarton, lsSKUParent, lsSKUChild, lsProject, &
				ls_process_type, lsComponentInd

DEcimal		ldBatchSeq,	ldGrossWeight, ldSetQty, ldChildQty
				
Integer		liRC, liCheck

DateTime		ldtTranstime

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

// TAM 06/27/2005 COO_Translate
If Not isvalid(idsCOO_Translate) Then
	idsCOO_Translate = Create Datastore
	idsCOO_Translate.Dataobject = 'd_coo_translate'
	idsCOO_Translate.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

//Retreive Delivery Master, Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// *** 07/07 - PCONKL - Temprorary code to exclude transactions for RMA Warehouses ***
If Upper(idsDOmain.GetItemString(1,'wh_Code')) = '3CGLSAMI' or Upper(idsDOmain.GetItemString(1,'wh_Code')) = '3CGLSEMEA' Then
	lsLogOut = "        Not creating GI for RMA Warehouse for DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End If

idsDoDetail.Retrieve(asDoNo) /*detail Records*/
idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*PAck Records */
idsCOO_Translate.Retrieve(asproject) /* COO Tranlate Records */


lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
Select Trans_create_date into :ldtTranstime
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

llCartonPos = 0

//We need to report any owner changes (shipped Non 3COM as owner) first - transaction needs to be generated before ASN!!!
uf_owner_Change(idsDOmain,idsDOPick, aiTransID)

//Carton Serial Numbers
ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_do_carton_serial'
lirc = ldsSerial.SetTransobject(sqlca)

// Filter out rows with 0 Qty - Should only be for non-pickable Items
idsDOpack.Setfilter('quantity > 0')
idsDOpack.Filter()


lsDONO = idsDOmain.GetItemString(1,'do_no')
lsWarehouse = Upper(idsDOmain.GetItemString(1,'wh_Code'))

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix 
Select ucc_Company_Prefix into :lsuccscompanyprefix
FRom Project
Where Project_ID = :asProject;

If isnull(lsuccscompanyprefix) or lsuccscompanyprefix = '' Then
	lsuccscompanyprefix = "000000"
End If

SElect ucc_location_Prefix into :lsuccswhprefix
From Warehouse
Where wh_Code = :lsWarehouse;

If isnull(lsuccswhprefix) or lsuccswhprefix = '' Then
	lsuccswhprefix = "0"
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to 3COM!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 01/05 - PCONKL - Now sending child level information instead of just parent.
//							The PackList may not have all of the children retrieved - only thiose parents that are bundled
//							(Group = 'B') Non bundled Parents will need to have
//							the children retrieved here so we can write out in ASN file.

llRowCount = idsDoPack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = idsDOpack.GetItemString(llRowPos,'SKU')
	llLineItemNo = idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')
	
	lsFind = "Line_item_No = " + String(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) +  "'"
	llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
	If llFindRow > 0 Then
		
		If idsdoPick.getITemString(llFindRow,'Component_ind') = 'Y' Then /*parent*/
		
			idsdoPack.SetITem(llRowPos,'Component_ind','Y')
			
			//If Parent is Bundled, children should already be on the pack list, otherwise add them here
			// 07/09 - PCONKL - We don't need to retrieve for Tipping point either, they are already on the Pack list as well
			If idsdoPick.getITemString(llFindRow,'grp') = 'B' or  idsdoPick.getITemString(llFindRow,'grp') = 'TP' Then /*Bundled Parent */
			Else /*Unbundled parent - add children*/
				
				//lsFind =  "Line_item_No = " + String(llLineItemNo) + " and Upper(SKU_Parent) = '" + upper(lsSKU) +  "'"
				//lsFind += " and upper(sku_parent) <> Upper(SKU)"
				lsFind =  "Line_item_No = " + String(llLineItemNo) + " and (component_ind = 'W' or component_ind = '*')"
				llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
				Do While llFindRow > 0
					
					idsdoPack.RowsCopy(llRowPos,llRowPos,Primary!,idsdoPack,9999999,Primary!)
					// pvh - 11/07/06 - removed weight from copied row....getting duplicated totals.
					idsdoPack.object.weight_Gross[ idsdoPack.RowCount() ] = 0 // zap it!
					// eom
					idsdoPack.SetITem(idsdoPack.RowCount(),'sku',idsDoPick.GetITEmString(llFindRow,'sku'))

					idsdoPack.SetITem(idsdoPack.RowCount(),'supp_code',idsDoPick.GetITEmString(llFindRow,'supp_code'))
// TAM  06/24/2005  For non bundled children, use COO from packing parent sku instead of Picking Child 
//					idsdoPack.SetITem(idsdoPack.RowCount(),'country_of_Origin',idsDoPick.GetITEmString(llFindRow,'country_of_Origin'))
					idsdoPack.SetITem(idsdoPack.RowCount(),'country_of_Origin',idsDOpack.GetItemString(llRowPos,'country_of_Origin'))
					idsdoPack.SetITem(idsdoPack.RowCount(),'Component_ind','*')
					
					//Qty comes from Packing but may need to be adjusted if child Qty is > 1 - Supplier not included in search because child picked may not be same as on BOM
					lsProject = idsdoMain.GetITemString(1,'Project_id')
					lsSKUChild = idsDoPick.GetITEmString(llFindRow,'sku')
					
					Select Max(Child_Qty) into :ldChildQty
					From Item_Component
					Where Project_id = :lsProject and sku_parent = :lsSKU and sku_child = :lsSKUChild;
					
					If isNull(ldChildQty) or ldChildQty <= 0 Then ldChildQty = 1
	
					idsdoPack.SetITem(idsdoPack.RowCount(),'quantity',idsDoPack.GetITEmNumber(idsdoPack.RowCount(),'quantity') * ldChildQty)
					
					If llFindRow = idsdoPick.RowCount() Then
						llFindRow = 0
					Else
						lsFind += " and Upper(SKU) <> '" + idsDoPick.GetITEmString(llFindRow,'sku') + "'" /* We only need one occurance of this sku */
						llFindRow = idsdoPick.Find(lsFind,(llFindRow + 1),idsdoPick.RowCount())
					End If
					
				Loop
				
			End If /*Bundled*/
			
		Else /*Child*/
// TAM 11/23/2005  Flag as child with a "W" not an  "*"			
//			idsdoPack.SetITem(llRowPos,'Component_ind','*')
			idsdoPack.SetITem(llRowPos,'Component_ind','W')
			
		End If /*Component*/
	
	End If /*Pick Row found for Packing*/
	
Next /* Pack Record */

//Write the rows to the generic output table - delimited by '~t'

//Create the Shipment level header Record
lsOutString = 'EH~t' /* rec ID*/
lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Carrier'),10)) + '~t'    /*carrier*/

// 06/04 - PCONKL - using transaction date instead of order complete date
//lsOutString+= String(idsDOmain.GetItemDateTime(1,'Complete_Date'),'yyyy-mm-dd') + '~t' /*ship date - Complete date*/
lsOutString+= String(ldtTranstime,'yyyy-mm-dd') + '~t' /*Timestamp batch transaction generated*/

// 05/04- PCONKL - Need to sum across unique carton numbers in case we have multiple rows with the same carton Number
ldGrossWeight = 0
lsCartonHold = 'asdfadfadfadf'
llRowCount = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	If idsDOpack.GetITemString(llRowPos,'carton_no') <> lsCartonHold Then /*carton has changed, add weight to total*/
		ldGrossWeight += idsDoPack.GetITemNumber(llRowPos,'weight_Gross')
	End If
	
	lsCartonHold = idsDOpack.GetITemString(llRowPos,'carton_no')
	
Next /* Packing Row */

If isnull(ldGrossWeight) Then ldGrossWeight = 0

lsOutString+= String(ldGrossWeight,'################0') + '~t' 

If idsdoPack.RowCount() > 0 Then
	If idsDOpack.GetItemString(1,'standard_of_measure') > '' Then
		lsOutString+= idsDOpack.GetItemString(1,'standard_of_measure') + '~t' /*unit of Measure - take first row from pack, all will be the same*/
	Else
		lsOutString+= '~t'
	End If
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'transport_mode') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'transport_mode'),10)) + '~t' /*transport Mode*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'awb_bol_no') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'awb_bol_no'),35)) + '~t' /*AWB*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'User_field6') > '' Then
	lsOutString+= Trim(left(idsDOmain.GetItemString(1,'User_field6'),10)) + '~t' /*already formatted properly*/
Else
	lsOutString+= "MN" + String(Long(Mid(idsDOmain.GetItemString(1,'do_no'),10,7)),'0000000') + '~t' /*Delivery Note Number*/
End If

If idsDOmain.GetItemString(1,'cust_Code') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'CUst_Code'),10)) + '~t' /*Cust Code */
Else
	lsOutString+= '~t'
End If

//3/08 - PCONKL - Address fields changed to 60 char

If idsDOmain.GetItemString(1,'address_1') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_1'),60))  + '~t' /*address 1 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_2') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_2'),60)) + '~t' /*address 2 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_3') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_3'),60)) + '~t' /*address 3*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_4') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_4'),60)) + '~t' /*address 4 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'district') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'district'),35)) + '~t' /*district */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'zip') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'zip'),10)) + '~t' /*zip */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'City') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'city'),35)) + '~t' /*City */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'state') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'state'),35)) + '~t' /*state */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'Country') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Country'),35)) + '~t' /*Country */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'Tel') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Tel'),35)) + '~t' /*Tel */
Else
	lsOutString+= '~t'
End If

//Retrieve the Intermediate Consignee Code
Select Name into :lsConsignee
FRom Delivery_Alt_Address
Where do_no = :lsDoNo and Address_type = "IC";

If lsConsignee > '' Then
	lsOutString+= Trim(Left(lsConsignee,10)) + '~t' /*Intermediate Consignee */
Else
	lsOutString+= '~t'
End If

//Freight Cost
If idsDOmain.GetItemNumber(1,'Freight_Cost') > 0 Then
	lsOutString+= String(idsDOmain.GetItemNumber(1,'Freight_Cost'),'########.00')  /*Freight Cost */ /* LAST COLUMN, NO DELIMITER*/
Else
	lsOutString+= '0' /* LAST COLUMN, NO DELIMITER*/
End If


llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', '3COMNSHASN') /* Matches entry in ini file - ASN files are going to seperate folder so they can be processed last*/
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)


//Loop through Packing Rows and Create Package level and Detail level records

lsCartonHold = 'aewraeraewr' /*track change in carton*/
llCartonPos = 0 /*for carton weight array*/

idsdoPack.Sort()
llRowCount = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	//If this row is a component Child, then Skip Row
	// 01/05 - PCONKL - We are now sending child information on ASN for Bundling initiative
//	If idsDOpack.GetITemString(llRowPos,'component_ind') = '*' or &
//		idsDOpack.GetITemString(llRowPos,'component_ind') = '*' Then Continue
		
	If idsDOpack.GetITemString(llRowPos,'carton_no') <> lsCartonHold Then /*carton has changed, write new header*/
		
		lsOutString = 'EP~t'
		lsOutString += Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
		
		If idsDOpack.GetItemString(llRowPos,'Carton_no') > '' Then
			// 12/03 - PCONKL - Format carton Nbr with UCCS Company and location prefixes*/
			lsUCCCarton = "0" + lsuccswhprefix + lsuccscompanyprefix + String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'000000000')
			liCheck = f_calc_uccs_Check_Digit(lsUCCCarton) /*Calculate check digit*/
			If liCheck >= 0 Then
				lsUccCarton = "00" + lsUCCCarton + String(liCheck)
			Else
				lsUccCarton = String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'00000000000000000000')
			End If
			lsOutString += lsUCCCarton + '~t' /*carton Number*/
		Else
			lsOutString += '~t'
		End If
		
		If idsDOpack.GetItemString(llRowPos,'Carton_Type') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'Carton_Type'),10) + '~t' /*carton Type*/
		Else
			lsOutString += '~t'
		End If
		
		lsOutString += String(idsDOpack.GetItemNumber(llRowPos,'Weight_Gross'),'################0') + '~t' /*carton weights were stored in array during validation process*/
		lsOutString+= idsDOpack.GetItemString(llRowPos,'standard_of_measure') + '~t' /*unit of Measure*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Height'),'################0') + '~t' /*Height*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Length'),'################0') + '~t' /*Length*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Width'),'################0') + '~t' /*Width*/
		
		If idsDOpack.GetItemString(llRowPos,'shipper_tracking_id') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'shipper_tracking_id'),40)  /*shipper_tracking_id*/
		Else
		//	lsOutString += '~t' '* LAST FIELD *
		End If
		
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', '3COMNSHASN') /* Matches entry in ini file - ASN files are going to seperate folder so they can be processed last*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
		lsCartonHold = idsDOpack.GetITemString(llRowPos,'carton_no')
			
	End If /*carton changed */
		
	lsCartonno = idsDOpack.GetItemString(llRowPos,'Carton_no')
	lsSKU = idsDOpack.GetItemString(llRowPos,'SKU')
	lsSuppCode = idsDOpack.GetItemString(llRowPos,'Supp_code')
	lsCOO = idsDOpack.GetItemString(llRowPos,'Country_of_Origin')
	llLineItemNo = idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')
	
// TAM 11/18/2005	
/* Added logic to check if SKU is a child.  If it is then we need to exclude supplier from the SERIAL retrieve. 
	We were skipping Serial Numbers for kitted SKUs when more than one supplier was picked for the same SKU
	In addition to this change, the Datastore was changed to use "LIKE" for a wildcard */
	lsComponentInd = idsDOpack.GetItemString(llRowPos,'Component_ind')
	If lsComponentInd = '*' Then
		lsSuppCode = '%%'
	End If
	 
	//Serial Numbers are being retrieved from Delivey_Serial_Detail
		llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsSuppCode, llLineItemNo)
		
	//If we have any Serial numbers presnt, we will loop once for each Qty and set QTY to 1. we will parse one serial # per record
	If llSerialCount > 0 Then
		llLoopCount = Long(idsDOpack.GetItemNumber(llRowPos,'quantity')) /*loop once for each qty with qty = 1*/
		ldSetQty = 1
	Else /*no serial Numbers*/
		llLoopCount = 1 /*only one row for this carton row */
		ldSetQty = idsDOpack.GetItemNumber(llRowPos,'quantity')
		lsAllserialNo = ''
	End If
	
	For llLoopPos = 1 to llLoopCount
	
		lsOutString = 'ED~t'
		lsOutString += Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
		
		If idsDOpack.GetItemString(llRowPos,'Carton_no') > '' Then
			// 12/03 - PCONKL - Format carton Nbr with UCCS Company and location prefixes*/
			lsUCCCarton = "0" + lsuccswhprefix + lsuccscompanyprefix + String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'000000000')
			liCheck = f_calc_uccs_Check_Digit(lsUCCCarton) /*Calculate check digit*/
			If liCheck >= 0 Then
				lsUccCarton = "00" + lsUCCCarton + String(liCheck)
			Else
				lsUccCarton = String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'00000000000000000000')
			End If
			lsOutString += lsUCCCarton + '~t' /*carton Number*/
		Else
			lsOutString += '~t'
		End If
		
		lsOutString += String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_No')) + '~t' /*Line Item Number*/
		lsOutString += String(ldSetQty,'##########0') + '~t' /*Quantity - either one if serial numbers present*/

//TAM 06/27/2005 If a Serial Number is available, load COO from the COO_Translate table
// 					otherwise use what is on the packing list
//We should have a serial record for each qty, if not, send a blank
		If llLoopPos <= llSerialCount Then
			lsSerialNo = ldsSerial.getItemString(llLoopPos,'Serial_no')
			//TAM 06/30/2005 - exclusion list for serial check 
			IF mid(lsserialno,1,1) <> 'C' and mid(lsserialno,1,1) <> 'M' and &
				mid(lsserialno,1,1) <> 'A' and mid(lsserialno,1,1) <> 'P' and mid(lsserialno,1,1) <> '3' THEN 

			//TAM 07/28/2005 Item Master Inclusions for Serial Check					
  				SELECT Item_Master.User_Field4  
  			  	INTO :ls_process_type  
    			FROM Item_Master  
   			WHERE ( Item_Master.Project_ID = :asproject ) AND  
         			( Item_Master.SKU = :lssku ) AND  
         			( Item_Master.Supp_Code = :lssuppcode )   ;

				IF ls_process_type = 'BCC' or ls_process_type = 'BNC' Then		

					lsfind = "serial_division = '" + mid(lsserialNo,1,1) + "' and serial_supplier= '" + mid(lsSerialNo,4,1) + "'"
					llFindRow = idsCOO_Translate.Find(lsFind,1,idsCOO_Translate.RowCount())
				 	IF llFindRow > 0 Then 
						lsCOO = idsCOO_Translate.getItemString(llFindrow,'Designating_Code')
			  	 	Else 
						lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
					End If
			  	Else 
					lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
				End If
			Else 
				lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
			End If
		Else 
			lsSerialNo = ''
			lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
		End If		


// TAM 06/27/2005 COO has been loaded above so there is no need to get it from the Packlist here
//		If idsDOpack.GetItemString(llRowos,'country_of_origin') <> 'XXX' Then /*only include COO if not the default value (XXX)*/
			//If the 3 char COO was entered, we need tro convert to 2 char code
			//lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
		If lsCOO <> 'XXX' Then /*only include COO if not the default value (XXX)*/
			If len(lsCOO) > 2 Then
				Select designating_Code Into :lsCOO
				From Country
				Where iso_country_cd = :lsCOO;
			End If
			lsOutString += lsCOO + '~t' /*Country of Origin*/
		Else
			lsOutString += '~t'
		End If
		
		If idsDOpack.GetItemString(llRowPos,'sku') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'sku'),50) + '~t' /*SKU*/
		Else
			lsOutString += '~t'
		End If

		//We should have a serial record for each qty, if not, send a blank
//  TAM 06/27/2005  Move this code above and combined with COO Translate
//		If llLoopPos <= llSerialCount Then
//			lsSerialNo = ldsSerial.getItemString(llLoopPos,'Serial_no')
//		Else
//			lsSerialNo = ''
//		End If
			
		lsOutString += lsSerialNo + "~t"
		
		//For UOM, we need to get it from the Order Detail Tab
		lsFind = "Upper(SKU) = '" + Upper(lsSKU) +  "' and Line_Item_no = " + String(llLineItemNo)
		llFindRow = idsDODetail.Find(lsFind,1,idsDOdetail.RowCount())
		If llfindRow > 0 Then
			lsUOM = idsDOdetail.GetITemString(llFindRow,'uom')
		End If
		
		If lsUOM = '' or isnull(lsUOM) then lsUOM = 'EA'
		
		lsOutString += lsUOM + '~t'
		
		// 01/05 - PCONKL - Include Parent SKU
	//	lsFind = "Line_item_No = " + String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Upper(SKU) = '" + upper(idsDOpack.GetItemString(llRowPos,'SKU')) +  "'"
		lsFind = "Line_item_No = " + String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Component_ind = 'Y'"
		llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
		If llFindRow > 0 Then
			//lsSKUPArent = idsdoPick.getITemString(llFindRow,'sku_parent') 
			lsSKUPArent = idsdoPick.getITemString(llFindRow,'sku') 
		Else
			lsSKUParent = idsDOpack.GetItemString(llRowPos,'SKU')
		End If
	
		lsOutString += lsSKUParent
		
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', '3COMNSHASN') /* Matches entry in ini file - ASN files are going to seperate folder so they can be processed last*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)

	Next /* next serial Number */
	
Next /*Packing Record*/
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'3COMNSHASN')

//TAMCCLANAHAN 
//Process Mark GT interface

//if lswarehouse = "3COM-NL" then
//		If Not isvalid(iu_nvo_marc_transactions) Then	
//			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
//		End If
//	iu_nvo_marc_transactions.uf_shipments(asProject,asDoNo)
//end if


Return 0
end function

public function integer uf_owner_change (ref datastore adsmain, ref datastore adspick, long aitransid);//For 3COM, we will send a transaction if we are shipping for an owner other than 3COM
//All stock needs to be sent as 3COM owned - we don't need to physically change the owner though.

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow, llOwner
Decimal	ldBatchSeq, ldMMXNBR
String	lsOutString, lsSKU, lsInvType, lsOrderNo, lsDONO, lsMessage, lsFind, lsSupplier, lsUF9,	&
			lsEmail, lsAddress1, lsCity, lsState, lsZip, lsCountry, lsWarehouse, lsUF6, lsPONumber, lsOwner,	&
			lsShipToAddress, lsProject, lsLogOut
			
Integer	liRC
DateTime	ldtTransTime

Datastore	ldsOut, ldsGR

ldsGR = Create Datastore
ldsGR.Dataobject = 'd_gr_layout'

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

lsProject = adsMain.GetITemString(1,'project_ID')
lsOrderNo = adsMain.GetITemString(1,'invoice_no')
lsDONo = adsMain.GetITemString(1,'do_no')

lsUF6 = adsMain.GetITemString(1,'User_field6') /*Internal Delivery Number (MNxxxxxx) */
If isnull(lsUF6) Then lsUF6 = ''

lsLogOut = "        Creating OCH For DONO: " + lsDONO
FileWrite(gilogFileNo,lsLogOut)

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
Select Trans_create_date into :ldtTranstime
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

//We need warehouse info
lsWarehouse = Upper(adsMain.GetITemString(1,'wh_code'))
Select email_address, address_1, city, State, Zip, Country Into :lsEmail, :lsAddress1, :lsCity, :lsState, :lsZip, :lsCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsEmail) Then lsEmail = ''
If isnull(lsCountry) Then lsCountry = ''

//Format Address
lsShipToAddress = ''
If Not isnull(lsAddress1) Then lsShipToAddress = lsAddress1
If NOt isNull(lsCity) Then
	lsShipToAddress += " " + lsCity + ", "
End If
If NOt isNull(lsState) Then
	lsShipToAddress += lsState + " "
End If
If NOt isNull(lsZip) Then
	lsShipToAddress += lsZip + " "
End If

//Rollup to Line Item SKU level
llRowCount = adsPick.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	//If the owner of the pick row is 3COM, then ignore
	If Left(Upper(adsPick.GetItemString(llRowPos,'owner_owner_cd')),4) = '3COM' Then Continue
	
	// 08/04 - PCONKL - If The parent is just a placeholder for blown out children (replacing WO), ignore
	If adsPick.GetItemString(llRowPos,'component_Ind') = 'Y' and &
		adsPick.GetItemString(llRowPos,'component_Type') = 'D' and &
		adsPick.GetItemString(llRowPos,'l_Code') = 'N/A' Then Continue
		
	lsSKU = adsPick.GetITemString(llRowPos,'SKU')
	lssupplier = adsPick.GetITemString(llRowPos,'supp_code')
	lsInvType = adsPick.GetITemString(llRowPos,'Inventory_Type')
	lsOwner = Upper(adsPick.GetITemString(llRowPos,'owner_owner_cd'))
	llQty = adsPick.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = adsPick.GetITemNumber(llRowPos,'Line_Item_No')

	//Ignore if SKU set to not send for RMC//MMX (IM UF9)
	Select User_field9 into :lsUF9
	From ITem_MAster
	Where Project_id = :lsProject and sku = :lsSKU and Supp_code = :lsSupplier;
	
	If lsUF9 = 'Y' Then Continue
	
	//If the owner code is null, we need to retrieve it (it is only retrieved when the order is retrived from the DB, not there on insert)
	If isNull(lsOwner) or lsOwner = '' Then
		
		llOwner = adsPick.GetITemNumber(llRowPos,'owner_ID')
		
		Select Owner_cd into :lsOwner
		From OWner
		Where project_id = :lsProject and owner_id = :llOwner;
		
	End If
	
	// pvh - 12/02/05
	// break on line item/sku/owner
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo)+ " and owner_cd = '" + lsOwner + "'"
	//lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo)
	//
	llFindRow = ldsgr.Find(lsFind,1,ldsgr.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		ldsgr.SetItem(llFindRow,'quantity', (ldsgr.GetItemNumber(llFindRow,'quantity') + llQty))
		
	Else /*not found, add a new record*/
		
		// We need the Inbound PO Number (first if  multiple) that this inventory was pulled from
		Select Supp_invoice_No into :lsPONumber
		From Receive_Master
		Where RO_NO = (Select Min(ro_no) from Delivery_Picking_detail Where do_no = :lsDono and sku = :lsSKU and
										Supp_code = :lsSupplier and	Line_Item_no = :llLineITemNo and	Inventory_type = :lsInvType);

		If isnull(lsPONumber) then lsPONumber = ''
										
		llNewRow = ldsgr.InsertRow(0)
		ldsgr.SetItem(llNewRow,'Inventory_type',lsInvType)
		ldsgr.SetItem(llNewRow,'sku',lsSKU)
		ldsgr.SetItem(llNewRow,'quantity',llQty)
		ldsGr.SetItem(llNewRow,'po_item_number',llLineItemNo)
		ldsGr.SetItem(llNewRow,'po_number',lsPONumber) /*Inbound receipt PO */
		ldsGr.SetItem(llNewRow,'owner_cd',lsowner)
	
	End If
	
Next /*Picking Row*/

//Write to output
llRowCount = ldsGR.RowCount()
For llRowPos = 1 to lLRowCount
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	//we want each record in a seperate file (each batch seq break causes a new file)
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation. Confirmation will not be sent to 3COM!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
	lsSKU = ldsGR.GetITemString(llRowPos,'SKU')
	lsInvType = ldsGR.GetITemString(llRowPos,'Inventory_Type')
	lsOwner = ldsGR.GetITemString(llRowPos,'Owner_cd')
	lsPONumber = ldsGR.GetITemString(llRowPos,'po_number') /*inbound receipt PO Number */
	llQty = ldsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = ldsGR.GetITemNumber(llRowPos,'po_item_number')

	//TAM 03/03/2006 Change Inventory Type From ROHS (G) to Normal (N)
	If (lsInvType = 'G') Then lsInvType = 'N'


	lsOutString = 'MM~t' 
	lsOutString += lsWarehouse + '~t' /* 04/04 - PCONKL */
	lsOutString += 'OCH~t' /*Transaction type - Owner Chg */
	lsOutString += lsInvType + '~t' /* Old Inv Type*/
	lsOutString += lsInvType + '~t' /* New Inv Type*/
	lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' /*  06/04 - PCONKL using client timestamp instead of current time from server*/
	lsOutString += '~t' /*reason*/
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsOrderNo + '~t' /*Order Number */
	lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
	
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
		
	lsOutString += lsOrderNO + '~t' /*Order Number for External Reference Number */
	lsOutString += lsOwner + '~t' /*OWner*/
	lsOutString +=  '~t' /*empty Receive Slip Number*/
	lsOutString += lsPONumber + '~t' /*Inbound Receipt PO Number*/
	lsOutString += lsUF6 + '~t' /*Internal Delivery Number ( MNxxxxxxx from UF6)*/
	lsOutString += lsShipToAddress + '~t' /*Ship To Address*/
	lsOutString += lsCountry + '~t' /*Ship To Country*/
	lsOutString += lsEmail /*Contact Email */
	lsOutString += '~t'   /* last delimeter is for Price (only on Vendor PO Update)*/
	
			
	llNewRow = ldsOut.insertRow(0)
	ldsOut.SetItem(llNewRow,'Project_id', lsProject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
Next /*Picking Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(ldsOut,lsProject)

Return 0
end function

public function integer uf_owner_change_workorder (string asproject, string aswono, long aitransid);
// For Owner Changes in Work Orders

//For 3COM, we will send a transaction if we are shipping for an owner other than 3COM
//All stock needs to be sent as 3COM owned - we don't need to physically change the owner though.

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow, llOwner
Decimal	ldBatchSeq, ldMMXNBR
String	lsOutString, lsSKU, lsInvType, lsOrderNo, lsMessage, lsFind, lsSupplier, lsUF9,	&
			lsEmail, lsAddress1, lsCity, lsState, lsZip, lsCountry, lsWarehouse, lsUF6, lsPONumber, lsOwner,	&
			lsShipToAddress, lsDONO, lsWONO, lsLogOut
			
Integer	liRC
DateTime	ldtTransTime

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

If Not isvalid(idsWOMain) Then
	idsWOMain = Create Datastore
	idsWOMain.Dataobject = 'd_workorder_master'
	idsWOMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsWoPick) Then
	idsWoPick = Create Datastore
	idsWoPick.Dataobject = 'd_workorder_Picking'
	idsWoPick.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

//Retreive Workorder Master and Picking rows for this WONO
If idsWOMain.Retrieve(asProject,asWoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Work Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idswoPick.Retrieve(aswoNo) /*Picking Records*/

lsWONO = idsWOMain.GetITemString(1,'wo_no')
lsWarehouse = Upper(idsWOMain.GetITemString(1,'wh_code'))
lsdoNo = idsWOMain.GetITemString(1,'do_No')

//We want to send the Delivery ORder number that created this WO if present, otherwise send the WO Number
If idsWOMain.GetITemString(1,'do_no') > '' Then
		
	Select invoice_no, User_field6 into :lsOrderNo, :lsUF6
	From Delivery_MAster where do_no = :lsDono;
	
	If isnull(lsOrderNo) Then lsOrderNo = ''
	If isnull(lsUF6) then lsUF6 = ''
	
Else
	lsOrderNo = idsWOMain.GetITemString(1,'workorder_number')
	lsUF6 = ''
End If

//We need warehouse info
Select email_address, address_1, city, State, Zip, Country Into :lsEmail, :lsAddress1, :lsCity, :lsState, :lsZip, :lsCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsEmail) Then lsEmail = ''
If isnull(lsCountry) Then lsCountry = ''

//Format Address
lsShipToAddress = ''
If Not isnull(lsAddress1) Then lsShipToAddress = lsAddress1
If NOt isNull(lsCity) Then
	lsShipToAddress += " " + lsCity + ", "
End If
If NOt isNull(lsState) Then
	lsShipToAddress += lsState + " "
End If
If NOt isNull(lsZip) Then
	lsShipToAddress += lsZip + " "
End If

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
Select Trans_create_date into :ldtTranstime
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

//Rollup to Line Item/SKU level/Owner level
llRowCount = idsWOPick.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	//If the owner of the pick row is 3COM, then ignore
	If Left(Upper(idsWOPick.GetItemString(llRowPos,'owner_owner_Cd')),4) = '3COM' Then Continue
		
	lsSKU = idsWOPick.GetITemString(llRowPos,'SKU')
	lsSupplier = idsWOPick.GetITemString(llRowPos,'supp_code')
	lsInvType = idsWOPick.GetITemString(llRowPos,'Inventory_Type')
	lsOwner = Upper(idsWOPick.GetITemString(llRowPos,'owner_owner_cd'))
	
	llQty = idsWOPick.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsWOPick.GetITemNumber(llRowPos,'Line_Item_No')
	
	//Ignore if SKU set to not send for RMC//MMX (IM UF9)
	Select User_field9 into :lsUF9
	From ITem_MAster
	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
	
	If lsUF9 = 'Y' Then Continue
		
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo) + " and Upper(owner_Cd) = '" + Upper(lsOwner) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
	Else /*not found, add a new record*/
		
		// We need the Inbound PO Number (first if  multiple) that this inventory was pulled from
		Select Supp_invoice_No into :lsPONumber
		From Receive_Master
		Where RO_NO = (Select Min(ro_no) from WorkOrder_Picking_detail Where wo_no = :lswono and sku = :lsSKU and
										Supp_code = :lsSupplier and	Line_Item_no = :llLineITemNo and	Inventory_type = :lsInvType);
										
		If isnull(lsPONumber) then lsPONumber = ''
		
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'Inventory_type',lsInvType)
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsGR.SetItem(llNewRow,'po_number',lsPONumber) /*Inbound receipt PO */
		idsGR.SetItem(llNewRow,'owner_cd',lsowner)
		
	End If
	
Next /*Picking Row*/

//Write to output
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	//we want each record in a seperate file (each batch seq break causes a new file)
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Work Order Confirmation. Confirmation will not be sent'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsowner = idsGR.GetITemString(llRowPos,'owner_cd')
	lsInvType = idsGR.GetITemString(llRowPos,'Inventory_Type')
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')

	//TAM 03/03/2006 Change Inventory Type From ROHS (G) to Normal (N)
	If (lsInvType = 'G') Then lsInvType = 'N'
	
	lsOutString = 'MM~t'
	lsOutString += lsWarehouse + '~t' /* 04/04 - PCONKL */
	lsOutString += 'OCH~t' /*Transaction type - Owner Chg */
	lsOutString += lsInvType + '~t' /* Old Inv Type*/
	lsOutString += lsInvType + '~t' /* New Inv Type*/
//	lsOutString += String(today(),'yyyymmddhhmmss') + '~t' 
	lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
	lsOutString += '~t' /*reason*/
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsOrderNo + '~t' /*Order Number */
	lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
	
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asProject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
		
	lsOutString += lsOrderNO + '~t' /*Order Number for External Reference Number */
	lsOutString += lsOwner + '~t' /*OWner*/
	lsOutString +=  '~t' /*empty Receive Slip Number*/
	lsOutString += lsPONumber + '~t' /*Inbound Receipt PO Number*/
	lsOutString += lsUF6 + '~t' /*Internal Delivery Number ( MNxxxxxxx from UF6)*/
	lsOutString += lsShipToAddress + '~t' /*Ship To Address*/
	lsOutString += lsCountry + '~t' /*Ship To Country*/
	lsOutString += lsEmail /*Contact Email*/
	lsOutString += '~t'   /* last delimeter is for Price (only on Vendor PO Update)*/
			
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
Next /*Picking Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0

end function

public function integer uf_vendor_po_update (string asdono, long allineitemno, string assku, string asponumber, decimal adprice, string asowner, decimal adqty);
//3COM is ending us an updated PO number for an owner Change (OCH) that we returned to them. 
//We need to pass the PO Number back to the customer as an MMX of type PUR (instead of OCH)

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow, llOwner
Decimal	ldBatchSeq, ldMMXNBR, ldPrice

String	lsOutString, lsSKU, lsInvType, lsOrderNo, lsDONO, lsMessage, lsFind, lsSupplier, lsUF9,	&
			lsEmail, lsAddress1, lsCity, lsState, lsZip, lsCountry, lsWarehouse, lsUF6, lsPONumber, lsOwner,	&
			lsShipToAddress, lsProject, lsLogOut, lsFilter, lsWONO
			
Integer	liRC
DateTime	ldtTransTime, ldtWOComplete, ldtReadyToShip
Boolean	lbWO

//Datastore	ldsOut, ldsGR

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

//idsGR = Create Datastore
//idsGR.Dataobject = 'd_gr_layout'
//
//idsOut = Create Datastore
//idsOut.Dataobject = 'd_edi_generic_out'
//lirc = idsOut.SetTransobject(sqlca)

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
End If

//always set dataobject back to d_do_picking, it might have been reset to workorder_picking in last run (instance variable)
idsDoPick.Dataobject = 'd_do_Picking'
idsDoPick.SetTransObject(SQLCA)

idsOut.Reset()
idsGR.Reset()

lbWO = False
SetNull(ldtWOComplete)

//Retreive Delivery Master and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoPick.Retrieve(asDoNo) /*Pick Records */

lsProject = idsDOMain.GetITemString(1,'project_ID')
lsOrderNo = idsDOMain.GetITemString(1,'invoice_no')
lsDONo = idsDOMain.GetITemString(1,'do_no')
ldtReadyToShip = idsDOMain.GetITemdateTime(1,'Carrier_notified_Date')

lsUF6 = idsDOMain.GetITemString(1,'User_field6') /*Internal Delivery Number (MNxxxxxx) */
If isnull(lsUF6) Then lsUF6 = ''

//we want to filter picking for only this Line ITem and Owner
lsFilter =  "Line_Item_No = " + String(alLineItemNo) + " and Upper(SKU) = '" + Upper(asSKU) + "' and Upper(owner_owner_cd) = '" + Upper(asOwner) + "'"
idsdoPick.SetFilter(lsFilter)
idsdoPick.Filter()

//If This line ITem is a component, we will need to get the information from the WO Pick instead of the DO Pick
// If The SKU on the LIne ITem doesn't match the SKU passed in, we will assume that it is a WO
If idsDoPick.RowCount() = 0 Then /* SKU not found on line, assume it is component child*/

	idsDoPick.Dataobject = 'd_workorder_Picking'
	idsDoPick.SetTransObject(SQLCA)
	
	//We need the WO_no associated with this do_no - get the complete date too for the PO Update date
	Select wo_no, Complete_Date into :lsWONO, :ldtWOComplete
	From Workorder_master where Project_id = :lsPRoject and do_no = :lsDoNo;
	
	//Retrieve work order picking records for the WO for this DONO
	idsDoPick.Retrieve(lsWoNo)
	
	idsdoPick.SetFilter(lsFilter)
	idsdoPick.Filter()
	
	lbWO = True

End If

lsLogOut = "        Creating Vendor PO Update record (PUR) For DONO: " + lsDONO
FileWrite(gilogFileNo,lsLogOut)

// The Transaction DAte will either be the WO Complete DAte, the Ready to Ship (carrier_Notified) or the DO Complete Date
If lbWO and Not isnull(ldtWOComplete) Then
	ldtTransTime = ldtWOCOmplete
ElseIf Not isnull(ldtReadyToShip) Then
	ldtTransTime = ldtReadytoShip
Else
	ldtTransTime = idsdoMain.GetITemDateTime(1,'Complete_Date')
End If

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

//We need warehouse info
lsWarehouse = Upper(idsDOMain.GetITemString(1,'wh_code'))
Select email_address, address_1, city, State, Zip, Country Into :lsEmail, :lsAddress1, :lsCity, :lsState, :lsZip, :lsCountry
From Warehouse
Where wh_code = :lsWarehouse;

If isnull(lsEmail) Then lsEmail = ''
If isnull(lsCountry) Then lsCountry = ''

//Format Address
lsShipToAddress = ''
If Not isnull(lsAddress1) Then lsShipToAddress = lsAddress1
If NOt isNull(lsCity) Then
	lsShipToAddress += " " + lsCity + ", "
End If
If NOt isNull(lsState) Then
	lsShipToAddress += lsState + " "
End If
If NOt isNull(lsZip) Then
	lsShipToAddress += lsZip + " "
End If

//Rollup to Line Item/SKU/Inventory Type
llRowCount = idsDOPick.RowCount() /*Either from DO or WO depending on if it's a component child or not as determined above*/
For lLRowPos = 1 to llRowCOunt
			
	lsSKU = idsDOPick.GetITemString(llRowPos,'SKU')
	lssupplier = idsDOPick.GetITemString(llRowPos,'supp_code')
	
	lsInvType = idsDOPick.GetITemString(llRowPos,'Inventory_Type')
	
	// 07/07 - PCONKL - Rollup ROHS and NOrmal together (moved from below)
	If (lsInvType = 'G') Then lsInvType = 'N'
	
	lsOwner = Upper(idsDOPick.GetITemString(llRowPos,'owner_owner_cd'))
	llQty = idsDOPick.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsDOPick.GetITemNumber(llRowPos,'Line_Item_No')
		
	lsFind = "po_item_number = " + String(llLineItemNo) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
		
	Else /*not found, add a new record*/
													
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow,'Inventory_type',lsInvType)
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsGR.SetItem(llNewRow,'po_number',asPONumber) /*PO Number passed back from 3COM */
		idsGR.SetItem(llNewRow,'owner_cd',asowner) /* Owner passed back from 3COM*/
		
	End If
	
Next /*Picking Row*/

//Write to output
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	//we want each record in a seperate file (each batch seq break causes a new file)
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(lsproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Vendor PO Update confirmation.'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsInvType = idsGR.GetITemString(llRowPos,'Inventory_Type')
	lsOwner = idsGR.GetITemString(llRowPos,'Owner_cd')
	lsPONumber = idsGR.GetITemString(llRowPos,'po_number') /*inbound receipt PO Number */
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')

	//TAM 03/03/2006 Change Inventory Type From ROHS (G) to Normal (N)
	//07/07 - PCONKL - Moved to actually rollup above
	//If (lsInvType = 'G') Then lsInvType = 'N'
	

	lsOutString = 'MM~t' 
	lsOutString += lsWarehouse + '~t' /* 04/04 - PCONKL */
	lsOutString += 'PUR~t' /*Transaction type - PO Update */
	lsOutString += lsInvType + '~t' /* Old Inv Type*/
	lsOutString += lsInvType + '~t' /* New Inv Type*/
	lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
	lsOutString += '~t' /*reason*/
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsOrderNo + '~t' /*Order Number */
	lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
	
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(lsProject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
		
	lsOutString += lsOrderNO + '~t' /*Order Number for External Reference Number */
	lsOutString += lsOwner + '~t' /*OWner*/
	lsOutString +=  '~t' /*empty Receive Slip Number*/
	lsOutString += lsPONumber + '~t' /*PO Number passed back from 3COM in KCMPUR* file */
	lsOutString += lsUF6 + '~t' /*Internal Delivery Number ( MNxxxxxxx from UF6)*/
	lsOutString += lsShipToAddress + '~t' /*Ship To Address*/
	lsOutString += lsCountry + '~t' /*Ship To Country*/
	lsOutString += lsEmail + '~t' /*Contact Email*/
	
	ldPrice = AdPrice
	If isnull(ldPrice) Then ldPrice = 0
	
	lsOutString += String(ldPrice,'0000000.0000') /*Price from file from 3COM*/
			
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', lsProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
Next /*Picking Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,lsProject)

Return 0
end function

public function string uf_inv_adjust_type (string asoldinvtype, string asnewinvtype);String	lsTranType


// 3com inventory types as of 060606
//	B	BLOCKED (BLKD)
//	G	ROHS(GOOD)
//	H	HOLD
//	K	B-STOCK (BSTK)
//	L	BUNDLED ORDERS (BNDL)
//	N	NORMAL (GOOD)
//	O	OBSOLETE (OBS)
//	R	RETURNS (RETN)
//	S	SPECIAL ORDER (SPOR)
//	W	REWORK (REWK)
//	X	NRC - NON-ROHS COMPLIANT
//	Y	NRCB - NON-ROHS COMPLIANT BLOCKED
//	Z	HDNR - NON-ROHS COMPLIANT HOLD

lsTranType = ''

Choose Case Upper(asOldInvType)
		
			// pvh - 06/06/06 RoHS-2
				
			case 'X'  // NRC - NON-ROHS COMPLIANT
				
				Choose Case Upper(asNewInvType)
					// pvh - 06/27/06
					case 'N'
						lsTranType = '889'
					case 'B' //	BLOCKED (BLKD)
						lsTranType = '885'				
					case 'W' //	REWORK (REWK)
						lsTranType = '886'		
					case 'R' //	RETURNS (RETN)
						lsTranType = '887'
					case 'H' //	HOLD
						lsTranType = '888'
					case 'G' //	ROHS(GOOD)
						lsTranType = '889'
					case 'S' //	SPECIAL ORDER (SPOR)
						lsTranType = '893'
					case 'K' // B-STOCK (BSTK)
						lsTranType = '895'
					case 'L' // BUNDLED ORDERS (BNDL)
						lsTranType = '897'
					case 'O' // OBSOLETE (OBS)
						lsTranType = '899'
					case 'Z'  // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '900'
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED 
						lsTranType = '902'
				end choose
	
			case 'Y'  // NRCB - NON-ROHS COMPLIANT BLOCKED
			
				Choose Case Upper(asNewInvType)
					// pvh - 06/27/06
					case 'N'
						lsTranType = '859'
					case 'B' //	BLOCKED (BLKD)
						lsTranType = '855'				
					case 'W' //	REWORK (REWK)
						lsTranType = '856'		
					case 'R' //	RETURNS (RETN)
						lsTranType = '857'
					case 'H' //	HOLD
						lsTranType = '858'
					case 'G' //	ROHS(GOOD)
						lsTranType = '859'
					case 'S' //	SPECIAL ORDER (SPOR)
						lsTranType = '863'
					case 'K' // B-STOCK (BSTK)
						lsTranType = '865'
					case 'L' // BUNDLED ORDERS (BNDL)
						lsTranType = '867'
					case 'O' // OBSOLETE (OBS)
						lsTranType = '869'
					case 'X' // NRC - NON-ROHS COMPLIANT
						lsTranType = '903'						
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '870'						

				end choose

	
			case 'Z'  // HDNR - NON-ROHS COMPLIANT HOLD
			
				Choose Case Upper(asNewInvType)
					// pvh - 06/27/06
					case 'N'
						lsTranType = '809'
					case 'B' //	BLOCKED (BLKD)
						lsTranType = '805'				
					case 'W' //	REWORK (REWK)
						lsTranType = '806'		
					case 'R' //	RETURNS (RETN)
						lsTranType = '807'
					case 'H' //	HOLD
						lsTranType = '808'
					case 'G' //	ROHS(GOOD)
						lsTranType = '809'
					case 'S' //	SPECIAL ORDER (SPOR)
						lsTranType = '813'
					case 'K' // B-STOCK (BSTK)
						lsTranType = '815'
					case 'L' // BUNDLED ORDERS (BNDL)
						lsTranType = '817'
					case 'O' // OBSOLETE (OBS)
						lsTranType = '819'
					case 'X' // NRC - NON-ROHS COMPLIANT
						lsTranType = '901'						
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '871'						
				end choose
					
			case 'G'
				Choose Case Upper(asNewInvType)
					// pvh - 06/06/06 RoHS-2 - cya	
					case 'X'  // NRC - NON-ROHS COMPLIANT
						lsTranType = '880'				
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '850'		
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '800'
					// eom
					Case 'B' /* Good to Blocked*/
						lsTranType = '400'
					Case 'W' /* Good to Re-Work*/
						lsTranType = '401'
					Case 'R' /* Good to Return*/
						lsTranType = '402'
					Case 'H' /* Good to Hold*/
						lsTranType = '403'
					Case 'L' /* Good to BNDL*/
						lsTranType = '618'
					Case 'O' /* Good to Obsolete*/
						lsTranType = '404'
					Case 'K' /* Good to B-Stock*/
						lsTranType = '533'
					Case 'S' /* Good to Special Order*/
						lsTranType = '511'
			end choose
				
			// eom
			
			Case 'N' /*Normal*/
				
				Choose Case Upper(asNewInvType)

					case 'X'  // NRC - NON-ROHS COMPLIANT
						lsTranType = '880'				
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '850'		
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '800'						
					Case 'B' /* Good to Blocked*/
						lsTranType = '400'
					Case 'W' /* Good to Re-Work*/
						lsTranType = '401'
					Case 'R' /* Good to Return*/
						lsTranType = '402'
					Case 'H' /* Good to Hold*/
						lsTranType = '403'
					Case 'L' /* Good to BNDL*/
						lsTranType = '618'
					Case 'O' /* Good to Obsolete*/
						lsTranType = '404'
					Case 'K' /* Good to B-Stock*/
						lsTranType = '533'
					Case 'S' /* Good to Special Order*/
						lsTranType = '511'
						
				End Choose
						
			Case 'R' /*Return*/
				
					Choose Case Upper(asNewInvType)
						// pvh - 06/06/06 RoHS-2
						case 'X' // NRC - NON-ROHS COMPLIANT
							lsTranType = '881'
						case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
							lsTranType = '851'
						case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
							lsTranType = '801'							
						//
						
						Case 'B' /* Return to Blocked*/
							lsTranType = '420'
						Case 'W' /* Return to Re-Work*/
							lsTranType = '421'
						Case 'N' /*Normal*/
							lsTranType = '422'
						Case 'H' /* Return to Hold*/
							lsTranType = '423'
						Case 'L' /* Return to BNDL*/
							lsTranType = '610'
						Case 'O' /* Return to Obsolete*/
							lsTranType = '424'
						Case 'K' /* Return to B-Stock*/
							lsTranType = '530'
						Case 'S' /* Return to Special Order*/
							lsTranType = '513'
						Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
							lsTranType = '422'
						
					End Choose
				
			Case 'W' /*Re-Work*/
				
					Choose Case Upper(asNewInvType)
						// pvh - 06/06/06 RoHS-2
						case 'X' // NRC - NON-ROHS COMPLIANT
							lsTranType = '882'
						case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
							lsTranType = '852'
						case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
							lsTranType = '802'							
						//
					
						Case 'B' /* Rework to Blocked*/
							lsTranType = '440'
						Case 'R' /* Re-Work to Return*/
							lsTranType = '442'
						Case 'N'  /*Normal*/
							lsTranType = '441'
						Case 'H' /* Rework to Hold*/
							lsTranType = '443'
						Case 'L' /* Rework to BNDL*/
							lsTranType = '611'
						Case 'O' /* Rework to Obsolete*/
							lsTranType = '444'
						Case 'S' /* Re-work to Special Order*/
							lsTranType = '515'
						Case 'K' /* Re-work to b-Stock*/
							lsTranType = '541'
						Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
							lsTranType = '441'
							
					End Choose
				
			Case 'B' /*Blocked*/
				
					Choose Case Upper(asNewInvType)
							
						// pvh - 06/06/06 RoHS-2
						case 'X' // NRC - NON-ROHS COMPLIANT
							lsTranType = '883'
						case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
							lsTranType = '853'
						case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
							lsTranType = '803'							
						//
						
						Case 'W' /* Blocked to REwork*/
							lsTranType = '460'
						Case 'R' /* Blocked to Return*/
							lsTranType = '461'
						Case 'N' /*Normal*/
							lsTranType = '462'
						Case 'H' /* Blocked to Hold*/
							lsTranType = '463'
						Case 'L' /* Blocked to BNDL*/
							lsTranType = '612'
						Case 'O' /* Blocked to Obsolete*/
							lsTranType = '464'			
						Case 'S' /* Blocked to Special Order*/
							lsTranType = '517'
						Case 'K' /* Blocked to b-Stock*/
							lsTranType = '543'
						Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
							lsTranType = '462'
							
					End Choose
				
			Case 'H' /*Hold*/
				
					Choose Case Upper(asNewInvType)
							
						// pvh - 06/06/06 RoHS-2
						case 'X' // NRC - NON-ROHS COMPLIANT
							lsTranType = '884'
						case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
							lsTranType = '854'
						case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
							lsTranType = '804'							
						//
						
						Case 'W' /* Hold to REwork*/
							lsTranType = '481'
						Case 'R' /* Hold to Return*/
							lsTranType = '482'
						Case 'N' /*Normal*/
							lsTranType = '483'
						Case 'B' /* Hold to Blocked*/
							lsTranType = '480'
						Case 'O' /* Hold to Obsolete*/
							lsTranType = '484'	
						Case 'L' /* Hold to BNDL*/
							lsTranType = '613'	
						Case 'S' /* Hold to Special Order*/
							lsTranType = '537'	
						Case 'K' /* Hold to B-Stock*/
							lsTranType = '547'	
						Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
							lsTranType = '483'
							
					End Choose
				
			Case 'O' /*Obsolete*/
				
					Choose Case Upper(asNewInvType)
							
						// pvh - 06/06/06 RoHS-2
						case 'X' // NRC - NON-ROHS COMPLIANT
							lsTranType = '898'
						case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
							lsTranType = '868'
						case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
							lsTranType = '818'							
						//
						
						Case 'W' /* Obsolete to REwork*/
							lsTranType = '501'
						Case 'R' /* Obsolete to Return*/
							lsTranType = '502'
						Case 'N' /*Normal*/
							lsTranType = '504'
						Case 'B' /* Obsolete to Blocked*/
							lsTranType = '500'
						Case 'H' /* Obsolete to Hold*/
							lsTranType = '503'	
						Case 'L' /* Obsolete to BNDL*/
							lsTranType = '614'	
						Case 'S' /* Obsolete to Special Order*/
							lsTranType = '539'	
						Case 'K' /* Obsolete to B-Stock*/
							lsTranType = '549'	
						Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
							lsTranType = '504'
							
					End Choose
				
			Case 'K' /*B-Stock*/
					
				Choose Case Upper(asNewInvType)
						
					// pvh - 06/06/06 RoHS-2
					case 'X' // NRC - NON-ROHS COMPLIANT
						lsTranType = '894'
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '864'
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '814'							
					//
						
					Case 'R' /* B-stock to Return*/
						lsTranType = '531'
					Case 'N' /*Normal*/
						lsTranType = '532'
					Case 'W' /* B-Stock to REwork*/
						lsTranType = '540'
					Case 'B' /* B-Stock to Blocked*/
						lsTranType = '542'
					Case 'L' /* B-Stock to BNDL*/
						lsTranType = '617'
					Case 'S' /* B-Stock to Special Order*/
						lsTranType = '519'
					Case 'H' /* B-Stock to Hold*/
						lsTranType = '546'
					Case 'O' /* B-Stock to Obsolete*/
						lsTranType = '548'
					Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
						lsTranType = '532'
							
				End Choose
				
			Case 'S' /*Special ORder*/
					
				Choose Case Upper(asNewInvType)

					// pvh - 06/06/06 RoHS-2
					case 'X' // NRC - NON-ROHS COMPLIANT
						lsTranType = '892'
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '862'
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '812'							
					//
						
					Case 'N' /*Normal*/
						lsTranType = '510'
					Case 'R' /* Special Order to Return*/
						lsTranType = '512'
					Case 'W' /* Special Order to RE-Work*/
						lsTranType = '514'
					Case 'B' /* Special Order to Blocked*/
						lsTranType = '516'
					Case 'L' /* Special Order to BNDL*/
						lsTranType = '615'
					Case 'K' /* Special Order to B-Stock*/
						lsTranType = '518'
					Case 'H' /* Special Order to Hold*/
						lsTranType = '536'
					Case 'O' /* Special Order to Obsolete*/
						lsTranType = '538'
					Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
						lsTranType = '510'
						
				End Choose
				
			Case 'L' /*Bundled*/
				
				Choose Case Upper(asNewInvType)
						
					// pvh - 06/06/06 RoHS-2
					case 'X' // NRC - NON-ROHS COMPLIANT
						lsTranType = '896'
					case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
						lsTranType = '866'
					case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
						lsTranType = '816'							
					//
						
					Case 'N' /*Normal*/
						lsTranType = '609'
					Case 'K' /* BSTK */
						lsTranType = '608'
					Case 'S' /*SPOR*/
						lsTranType = '607'
					Case 'O' /*Obsolete*/
						lsTranType = '605'
					Case 'H' /*HOLD*/
						lsTranType = '604'
					Case 'R' /*Return*/
						lsTranType = '602'
					Case 'W' /*Re-Work*/
						lsTranType = '601'
					Case 'B' /*Blocked*/
						lsTranType = '600'
					Case 'G' /* ROHS (GOOD) (dts - added 08/02/06 */
						lsTranType = '609'
						
				End Choose
				
		End Choose

Return lsTranType
end function

public function string uf_qty_adjust_type (string asinvtype, long aloldqty, long alnewqty);
String	lsTransType


Choose Case asInvType
		
	Case 'N' /*Normal*/
	
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '701'
		Else /*Incremented*/
			lsTransType = '708'
		End If
		
	Case 'G' /* ROHS Normal*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '701'
		Else /*Incremented*/
			lsTransType = '708'
		End If
		
	Case 'R' /*Returns*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '702'
		Else /*Incremented*/
			lsTransType = '709'
		End If
		
	Case 'W' /*Re-Work*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '703'
		Else /*Incremented*/
			lsTransType = '710'
		End If
		
	Case 'B' /*Blocked*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '704'
		Else /*Incremented*/
			lsTransType = '711'
		End If
		
	Case 'H' /*Hold*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '705'
		Else /*Incremented*/
			lsTransType = '712'
		End If
		
	Case 'O' /*Obsolete*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '706'
		Else /*Incremented*/
			lsTransType = '713'
		End If
		
	Case 'S' /*Special Order*/
		
		If alOldQty > alNewQty Then /*Decremented*/
			lsTransType = '730'
		Else /*Incremented*/
			lsTransType = '729'
		End If

		// pvh 060606 - rohs 2
		case 'X'  // NRC - NON-ROHS COMPLIANT
			lsTransType = '905'
			If alOldQty > alNewQty Then lsTransType = '904' /*Decremented*/
		case 'Y' // NRCB - NON-ROHS COMPLIANT BLOCKED
			lsTransType = '873'
			If alOldQty > alNewQty Then lsTransType = '872' /*Decremented*/
		case 'Z' // HDNR - NON-ROHS COMPLIANT HOLD
			lsTransType = '821'
			If alOldQty > alNewQty Then lsTransType = '820' /*Decremented*/
		//
	//dts 08/29/06 - Now explicitly handling 'K' (and not creating MM record)
	Case 'K' /*BSTK*/ //dts
		lsTransType = '-1'
		
End Choose

Return lsTransType
end function

public function boolean getok2process (string asproject, long transferid, datetime tranfercreated);// boolean = getOK2Process( long transferId, datetime tranferCreated )

// we need to retrieve the transaction to get the ro_no.  With the ro_no, we can retrieve the rono's 
// batch transaction. We can  determine if it's been 30 minutes since it processed by comparing the 
// create date vs the transfercreated date.

datetime grTransDate
datetime grTransDatePlus
datetime transDateTime
string rono
date transdate
date grDate
time transtime
time grtime
int anhour
int  aminute
int asecond
boolean addAday

select ro_no
into :rono
from adjustment
where adjust_no = :transferId
using sqlca;

if sqlca.sqlcode <> 0 then return false // error?
if isNull( rono ) or len( rono ) = 0 then return false

select trans_complete_date
into :grTransDate
from batch_transaction
where project_id = :asProject and
trans_type = 'GR' and
trans_order_id = :rono and
trans_status = 'C';

if sqlca.sqlcode <> 0 then return false // error?
if isNull( grTransDate ) then return false

// add thirty minutes to the timestamp
grTime = TIme( grTransDate )
grDate = Date( grTransDate )

anhour = hour( grTime )
aminute = minute( grTIme )
asecond = second( grTIme )
if asecond = 0 then asecond = 1 // dateTime func does not work with a zero second.
if aminute + 30 > 59 then
	aminute =  ( aminute - 30 )
	anhour ++
	if anhour > 23 then
		anhour = 0
		addAday = true
	end if
else
	aminute += 30
end if

grTIme = Time( String( anhour ) + ":" + String(aminute) + ":" + String(asecond) )

if addAday then grDate = relativeDate( grDate, 1 )

grTransDate = dateTime( grDate, grTime )

transDateTime = datetime( today(), now() )

if transDateTime >= grTransDate then return true //  30 minutes

return false

end function

public function integer uf_gr_gls_rma (string asproject, string asrono);
//Process GR for GLS RMA

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow
Decimal	ldBatchSeq
String	lsOutString, lsSKU, lsOrderNo, lsFind,  lsSupplier, lsLogout, lswarehouse, lsSerialNo, lsInvType, lsFileName
Integer	liRC
DateTime ldtTranstime

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
	idsromain.SetTransobject(sqlca)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransobject(sqlca)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GLS RMA GR for 3COM RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

// We need the Complete Date from the Receive Master instead of using the current timestamp which is GMT on the server.
ldtTranstime = idsroMain.GetITemDateTime(1,'complete_date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

lsOrderNo = idsromain.GetITemString(1,'Supp_invoice_no')
lsSupplier = idsromain.GetITemString(1,'supp_code')
lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))

llRowCount = idsroPutaway.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	llLineItemNo = idsroPutaway.GetITemNumber(llRowPos,'Line_Item_No')
	lsSerialNo = idsroPutaway.GetItemString(llRowPos,'serial_No')
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	lsInvType = idsroPutaway.GetITemString(llRowPos,'Inventory_Type')
	
//	//No transactions for line items > 90000
//	If llLineItemNo >= 90000 Then Continue
	
//	//Ignore if SKU set to not send for RMC//MMX (IM UF9)
//	Select User_field9 into :lsUF9
//	From ITem_MAster
//	Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
//	
//	If lsUF9 = 'Y' Then Continue
	
	llQty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
		
	//Rollup to Line Item SKU, Inv Type, Serial Number level
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo) + " and upper(serial_number) = '" + Upper(lsSerialNo) + "'"
	lsFind += " and Upper(inventory_Type) = '" + Upper(lsInvType) + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsGR.SetItem(llNewRow,'serial_number',lsSerialNo)
		idsGR.SetItem(llNewRow,'inventory_type',lsInvType)
		
	End If
	
Next /*Putaway Row*/

//Write to output

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//all records in a single file for RT
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
		
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsSerialNo = idsGR.GetItemString(llRowPos,'serial_number')
	lsInvType = idsGR.GetITemString(llRowPos,'inventory_type')
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')

	lsOutString = 'GR~t' /*Transaction type - Goods Receipt */
	lsOutString += lsWarehouse + '~t' /*warehouse */
	lsOutString += lsInvType + '~t' /*Inv Type */
	lsOutString += String(ldtTransTime,'yyyy-mm-dd') + '~t' 
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsOrderNO + '~t'  /*Order Number */
  	lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
			
	If lsSerialNO <> '-' Then
		lsOutString += lsSerialNo + '~t'
	Else
		lsOutString += '~t'
	End If
		
	lsOutString += lsSku /*Expected SKU */
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'RMART' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
	
Next /*Putaway Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0
end function

public function integer uf_gr_gls_po (string asproject, string asrono);
//Process GR for GLS PO

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow
Decimal	ldBatchSeq
String	lsOutString, lsSKU, lsOrderNo, lsFind,  lsSupplier, lsLogout, lswarehouse, lsSerialNo, lsInvType, lsFileName
Integer	liRC
DateTime ldtTranstime

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
	idsromain.SetTransobject(sqlca)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransobject(sqlca)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GLS PO GR for 3COM RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

// We need the Complete Date from the Receive Master instead of using the current timestamp which is GMT on the server.
ldtTranstime = idsroMain.GetITemDateTime(1,'complete_date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

lsOrderNo = idsromain.GetITemString(1,'Supp_invoice_no')
lsSupplier = idsromain.GetITemString(1,'supp_code')
lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))

llRowCount = idsroPutaway.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	llLineItemNo = idsroPutaway.GetITemNumber(llRowPos,'Line_Item_No')
	lsSerialNo = idsroPutaway.GetItemString(llRowPos,'serial_No')
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	lsInvType = idsroPutaway.GetITemString(llRowPos,'Inventory_Type')
	
	llQty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
		
	//Rollup to Line Item SKU, Inv Type, Serial Number level
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo) + " and upper(serial_number) = '" + Upper(lsSerialNo) + "'"
	lsFind += " and Upper(inventory_Type) = '" + Upper(lsInvType) + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
		
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsGR.SetItem(llNewRow,'serial_number',lsSerialNo)
		idsGR.SetItem(llNewRow,'inventory_type',lsInvType)
		
	End If
	
Next /*Putaway Row*/

//Write to output

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//all records in a single file for RT
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
		
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsSerialNo = idsGR.GetITemString(llRowPos,'serial_number')
	lsInvType = idsGR.GetITemString(llRowPos,'inventory_type')
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')

	lsOutString = 'GR~t' /*Transaction type - Goods Receipt */
	lsOutString += lsWarehouse + '~t' /*warehouse */
	lsOutString += lsInvType + '~t' /*Inv Type */
	lsOutString += String(ldtTransTime,'yyyy-mm-dd') + '~t' 
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty, '#########0') + '~t'
	lsOutString += lsOrderNO + '~t'  /*Order Number */
  	lsOutString += String(llLineItemNo,'#######0') + '~t' /*Line ITem Number*/
	
	If lsSerialNO <> '-' Then
		lsOutString += lsSerialNo + '~t'
	Else
		lsOutString += '~t'
	End If
		
	lsOutString += lsSku /*Expected SKU */
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'RMAGR' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
	
Next /*Putaway Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0
end function

public function integer uf_gr_gls_wa (string asproject, string asrono);
//Process GR for GLS Repair Vendors 

Long	llrowPos, llRowCount, llNewRow, llQty, llLineItemNo, llFindRow
Decimal	ldBatchSeq, ldMMXNBR
String	lsOutString, lsSKU, lsOrderNo, lsFind,  lsSupplier, lsLogout, lswarehouse, lsSerialNo, lsInvType, lsFileName
Integer	liRC
DateTime ldtTranstime

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
	idsromain.SetTransobject(sqlca)
End If

If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransobject(sqlca)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating GLS PO GR for 3COM RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

// We need the Complete Date from the Receive Master instead of using the current timestamp which is GMT on the server.
ldtTranstime = idsroMain.GetITemDateTime(1,'complete_date')
If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

lsOrderNo = idsromain.GetITemString(1,'Supp_invoice_no')
lsSupplier = idsromain.GetITemString(1,'supp_code')
lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))

llRowCount = idsroPutaway.RowCount()
For lLRowPos = 1 to llRowCOunt
	
	llLineItemNo = idsroPutaway.GetITemNumber(llRowPos,'Line_Item_No')
	lsSerialNo = idsroPutaway.GetItemString(llRowPos,'serial_No')
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	lsInvType = idsroPutaway.GetITemString(llRowPos,'Inventory_Type')
	

	
	llQty = idsroPutaway.GetITemNumber(llRowPos,'Quantity')
		
	//Rollup to Line Item SKU, Inv Type
	lsFind = "upper(sku) = '" + upper(lsSKU) + "' and po_item_number = " + String(llLineItemNo) 
	lsFind += " and Upper(inventory_Type) = '" + Upper(lsInvType) + "'"
	
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + llQty))
	Else /*not found, add a new record*/
		llNewRow = idsGR.InsertRow(0)
		
		idsGR.SetItem(llNewRow,'sku',lsSKU)
		idsGR.SetItem(llNewRow,'quantity',llQty)
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
		idsGR.SetItem(llNewRow,'serial_number',lsSerialNo)
		idsGR.SetItem(llNewRow,'inventory_type',lsInvType)
		
	End If
	
Next /*Putaway Row*/

//Write to output

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//all records in a single file for RT
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
	
llRowCount = idsGR.RowCount()
For llRowPos = 1 to lLRowCount
		
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsInvType = idsGR.GetITemString(llRowPos,'inventory_type')
	
	llQty = idsGR.GetITemNumber(llRowPos,'Quantity')
	llLineItemNo = idsGR.GetITemNumber(llRowPos,'po_item_number')
	
	lsOutString = 'MM~t' /*rec type = Material Movement*/
	lsOutString += lsWarehouse + '~t' /*warehouse */
	lsOutString +=  '305~t'
	lsOutString += lsInvType + '~t' /*old Inv Type*/
	lsOutString += lsInvType + '~t' /*New Inv Type*/
	lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
	lsOutString +=  '~t' /*reason*/
	lsOutString += lsSku + '~t'
	lsOutString += String(llQty) + '~t' /*orig Qty*/
	lsOutString += String(llQty) + '~t' /*New Qty*/
		
	ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asproject,'MMX','MMX_NBR') /* next available unique MMX Number */
	lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
	
	lsOutString += lsOrderNo + "-" + String(llLineItemNo) + '~t' /*Ref # - Order + Line*/
	lsOutString += "3COM" /* always 3COM Owned */
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'RMAMM' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
	
Next /*Putaway Row*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0
end function

public function integer uf_gls_adjustment (string asproject, long aladjustid, long aitransid);//Prepare a Stock Adjustment Transaction for 3COM NAshville for the Stock Adjustment just made - RMA Side of the House
// uf_adjustment

Long			llNewRow, llOldQty, llNewQty, llNetQty, llRowCount, llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType,	lsFileName,	&
				lsReason, 	lsTranType, lsSupplier, lsUF9, lsLogOut, lsWarehouse, &
				 lsTransParm

Decimal		ldBatchSeq, ldMMXNbr
Integer		liRC
DateTime	ldtTransTime

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

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
// 03/05 - For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment

Select Trans_create_date, Trans_parm into :ldtTranstime, :lsTransParm
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())
/*
	 pvh - 12/01/06 - MARL
	3com Marl requirements state that we need to send a stock adjustment if the MARL ( revision level ) of a product
	changes when a return is processed.  We need to send these 30 minutes after the Return.

*/
if Upper( asProject ) = '3COM_NASH' and lsTransParm = 'MARL Change' then
	if NOT getOK2process( asProject, aladjustid, ldtTransTime ) then return 1 // new return code...should do nothing
end if
// eom

// pvh - 01/15/2007 - MARL - moved here so as not to write to log if transaction fails previous test.
lsLogOut = "      Creating RMA MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)
// eom

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsReason = idsadjustment.GetITemString(1,'Reason')
If isNUll(lsReason) Then lsReason = ""

lsSku = idsadjustment.GetITemString(1,'sku')
lsSupplier = idsadjustment.GetITemString(1,'supp_code')

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
lloldQty = idsadjustment.GetITemNumber(1,"old_quantity")


		
//03/05 - PCONKL - If we are doing qualitative adjustments between 2 existing buckets, they are going to appear here
//						as 2 quantitative adjustments. This has been captured in the adjustment screen. The record that is being decremented
//						does not need to be reported - only the row being incremented. The parm has been set to 'SKIP' for the row being decremented

//						For the row being incremented, we have also capture the old inv type/owner from the row being decremented 
//						so it can be reported here

If lsTransParm = 'SKIP' Then
	 Return 0
ElseIf Pos(lsTransParm,'OLD_INVENTORY_TYPE') > 0 Then
	lsOldInvType = Mid(lsTransParm,(Pos(lsTransParm,'=') + 1),999)
End If

	
////Ignore if SKU set to not send for RMC//MMX (IM UF9)
//Select User_field9 into :lsUF9
//From Item_Master
//Where Project_id = :asProject and sku = :lsSKU and Supp_code = :lsSupplier;
//	
//If lsUF9 = 'Y' Then
//	Return 0
//End If

//We are only sending a transaction for an inventory type (storage loc in SAP) change - no qty change transactions
//Qty Changes are being reported as a scrap movement if Reason Code is for Scrap


If lsOldInvType = lsNewInvType and  llNewQty = llOldQty Then Return 0
							
If (lsOldInvType <> lsNewInvType) Then	/*Inventory Type Changed*/
		
	lsTranType = '311'
				
ElseIf llNewQty <> llOldQty Then /* Qty Changed - Only send if Reason code is SPR (Scrap) */
	
	If lsReason = 'SPR' Then
		lsTranType = '551'
	Else
		Return 0 /* Only sending for Scrap*/
	End If

End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsOutString = 'MM~t' /*rec type = Material Movement*/
lsOutString += Upper(idsAdjustment.GetItemString(1,'wh_code')) + '~t' /* 04/04 - PCONKL */
lsOutString += lsTranType + '~t'
lsOutString += left(lsOldInvType,1) + '~t' /*old Inv Type*/
lsOutString += left(lsNewInvType,1) + '~t' /*New Inv Type*/
lsOutString += String(ldtTransTime,'yyyymmddhhmmss') + '~t' 
lsOutString += Left(lsReason,4) + '~t' /*reason*/
lsOutString += lsSku + '~t'
lsOutString += String(llOldQty) + '~t'
lsOutString += String(llNewQty) + '~t'
	
ldMMXNBR = gu_nvo_process_files.uf_get_next_seq_no(asproject,'MMX','MMX_NBR') /* next available unique MMX Number */

lsOutString += 'KCM' + String(ldMMXNBR,'000000') + '~t' /*Unique generated # for Transaction ID */
lsOutString += String(alAdjustID,'#########0') + '~t' /*Ref # */
lsOutString += '3COM' + '~t' /*Owner always 3COM */
llNewRow = idsout.insertRow(0)
	
idsout.SetItem(llNewRow,'Project_id', asproject)
idsout.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsout.SetItem(llNewRow,'line_seq_no', 1)
idsout.SetItem(llNewRow,'batch_data', lsOutString)

lsFileName = 'RMAMM' + String(ldBatchSeq,'00000000') + '.DAT'
idsOut.SetItem(llNewRow,'file_name', lsFileName)
idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_gi_rma (string asproject, string asdono, long aitransid);//Crete a GI for an RMA Sales Order (as opposed to Revenue side)

String	lsLogOut
Datastore	ldsSerial
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow, llCartonPos, llLineItemNo, llLoopCount, llLoopPos, &
				llSerialCount
				
String		lsFind, 	lsOutString, lsMessage,	lsCarTonHold, lsConsignee, lsDono, lsSerialNo,	lsFileName, &
				lsSerial1, lsSerial2, lsSerial3, lsSerial4, lsAllserialNo, lsCartonNo, lsSKU, lsSuppCode, lsCOO, lsUOM,	&
				lsuccscompanyprefix, lsuccswhprefix, lsWarehouse, lsUCCCarton, lsSKUParent, lsSKUChild, lsProject, &
				ls_process_type, lsComponentInd

DEcimal		ldBatchSeq,	ldGrossWeight, ldSetQty, ldChildQty
				
Integer		liRC, liCheck

DateTime		ldtTranstime

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

// TAM 06/27/2005 COO_Translate
If Not isvalid(idsCOO_Translate) Then
	idsCOO_Translate = Create Datastore
	idsCOO_Translate.Dataobject = 'd_coo_translate'
	idsCOO_Translate.SetTransObject(SQLCA)
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
idsCOO_Translate.Retrieve(asproject) /* COO Tranlate Records */


lsLogOut = "        Creating RMA GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

// 06/04 - PCONKL - We need the transaction stamp from the transaction file instead of using the current timestamp which is GMT on the server.
Select Trans_create_date into :ldtTranstime
From Batch_Transaction
Where Trans_ID = :aiTransID;

If isNull(ldtTranstime) Then ldtTranstime = DateTime(Today(),Now())

llCartonPos = 0

//We need to report any owner changes (shipped Non 3COM as owner) first - transaction needs to be generated before ASN!!!
//uf_owner_Change(idsDOmain,idsDOPick, aiTransID)

//Carton Serial Numbers
ldsSerial = Create Datastore
ldsSerial.Dataobject = 'd_do_carton_serial'
lirc = ldsSerial.SetTransobject(sqlca)

// Filter out rows with 0 Qty - Should only be for non-pickable Items
idsDOpack.Setfilter('quantity > 0')
idsDOpack.Filter()


lsDONO = idsDOmain.GetItemString(1,'do_no')
lsWarehouse = Upper(idsDOmain.GetItemString(1,'wh_Code'))

// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix 
Select ucc_Company_Prefix into :lsuccscompanyprefix
FRom Project
Where Project_ID = :asProject;

If isnull(lsuccscompanyprefix) or lsuccscompanyprefix = '' Then
	lsuccscompanyprefix = "000000"
End If

SElect ucc_location_Prefix into :lsuccswhprefix
From Warehouse
Where wh_Code = :lsWarehouse;

If isnull(lsuccswhprefix) or lsuccswhprefix = '' Then
	lsuccswhprefix = "0"
End If

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to 3COM!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsFileName = 'RMAEH' + String(ldBatchSeq,'00000000') + '.DAT'

// 01/05 - PCONKL - Now sending child level information instead of just parent.
//							The PackList may not have all of the children retrieved - only thiose parents that are bundled
//							(Group = 'B') Non bundled Parents will need to have
//							the children retrieved here so we can write out in ASN file.

llRowCount = idsDoPack.RowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = idsDOpack.GetItemString(llRowPos,'SKU')
	llLineItemNo = idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')
	
	lsFind = "Line_item_No = " + String(llLineItemNo) + " and Upper(SKU) = '" + upper(lsSKU) +  "'"
	llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
	If llFindRow > 0 Then
		
		If idsdoPick.getITemString(llFindRow,'Component_ind') = 'Y' Then /*parent*/
		
			idsdoPack.SetITem(llRowPos,'Component_ind','Y')
			
			//If Parent is Bundled, children should already be on the pack list, otherwise add them here
			If idsdoPick.getITemString(llFindRow,'grp') = 'B' Then /*Bundled Parent */
			Else /*Unbundled parent - add children*/
				
				//lsFind =  "Line_item_No = " + String(llLineItemNo) + " and Upper(SKU_Parent) = '" + upper(lsSKU) +  "'"
				//lsFind += " and upper(sku_parent) <> Upper(SKU)"
				lsFind =  "Line_item_No = " + String(llLineItemNo) + " and (component_ind = 'W' or component_ind = '*')"
				llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
				Do While llFindRow > 0
					
					idsdoPack.RowsCopy(llRowPos,llRowPos,Primary!,idsdoPack,9999999,Primary!)
					// pvh - 11/07/06 - removed weight from copied row....getting duplicated totals.
					idsdoPack.object.weight_Gross[ idsdoPack.RowCount() ] = 0 // zap it!
					// eom
					idsdoPack.SetITem(idsdoPack.RowCount(),'sku',idsDoPick.GetITEmString(llFindRow,'sku'))

					idsdoPack.SetITem(idsdoPack.RowCount(),'supp_code',idsDoPick.GetITEmString(llFindRow,'supp_code'))
// TAM  06/24/2005  For non bundled children, use COO from packing parent sku instead of Picking Child 
//					idsdoPack.SetITem(idsdoPack.RowCount(),'country_of_Origin',idsDoPick.GetITEmString(llFindRow,'country_of_Origin'))
					idsdoPack.SetITem(idsdoPack.RowCount(),'country_of_Origin',idsDOpack.GetItemString(llRowPos,'country_of_Origin'))
					idsdoPack.SetITem(idsdoPack.RowCount(),'Component_ind','*')
					
					//Qty comes from Packing but may need to be adjusted if child Qty is > 1 - Supplier not included in search because child picked may not be same as on BOM
					lsProject = idsdoMain.GetITemString(1,'Project_id')
					lsSKUChild = idsDoPick.GetITEmString(llFindRow,'sku')
					
					Select Max(Child_Qty) into :ldChildQty
					From Item_Component
					Where Project_id = :lsProject and sku_parent = :lsSKU and sku_child = :lsSKUChild;
					
					If isNull(ldChildQty) or ldChildQty <= 0 Then ldChildQty = 1
	
					idsdoPack.SetITem(idsdoPack.RowCount(),'quantity',idsDoPack.GetITEmNumber(idsdoPack.RowCount(),'quantity') * ldChildQty)
					
					If llFindRow = idsdoPick.RowCount() Then
						llFindRow = 0
					Else
						lsFind += " and Upper(SKU) <> '" + idsDoPick.GetITEmString(llFindRow,'sku') + "'" /* We only need one occurance of this sku */
						llFindRow = idsdoPick.Find(lsFind,(llFindRow + 1),idsdoPick.RowCount())
					End If
					
				Loop
				
			End If /*Bundled*/
			
		Else /*Child*/
// TAM 11/23/2005  Flag as child with a "W" not an  "*"			
//			idsdoPack.SetITem(llRowPos,'Component_ind','*')
			idsdoPack.SetITem(llRowPos,'Component_ind','W')
			
		End If /*Component*/
	
	End If /*Pick Row found for Packing*/
	
Next /* Pack Record */

//Write the rows to the generic output table - delimited by '~t'

//Create the Shipment level header Record
lsOutString = 'EH~t' /* rec ID*/
lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Carrier'),10)) + '~t'    /*carrier -*/

// 06/04 - PCONKL - using transaction date instead of order complete date
//lsOutString+= String(idsDOmain.GetItemDateTime(1,'Complete_Date'),'yyyy-mm-dd') + '~t' /*ship date - Complete date*/
lsOutString+= String(ldtTranstime,'yyyy-mm-dd') + '~t' /*Timestamp batch transaction generated*/

// 05/04- PCONKL - Need to sum across unique carton numbers in case we have multiple rows with the same carton Number
ldGrossWeight = 0
lsCartonHold = 'asdfadfadfadf'
llRowCount = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	If idsDOpack.GetITemString(llRowPos,'carton_no') <> lsCartonHold Then /*carton has changed, add weight to total*/
		ldGrossWeight += idsDoPack.GetITemNumber(llRowPos,'weight_Gross')
	End If
	
	lsCartonHold = idsDOpack.GetITemString(llRowPos,'carton_no')
	
Next /* Packing Row */

If isnull(ldGrossWeight) Then ldGrossWeight = 0

lsOutString+= String(ldGrossWeight,'################0') + '~t' 

If idsdoPack.RowCount() > 0 Then
	If idsDOpack.GetItemString(1,'standard_of_measure') > '' Then
		lsOutString+= idsDOpack.GetItemString(1,'standard_of_measure') + '~t' /*unit of Measure - take first row from pack, all will be the same*/
	Else
		lsOutString+= '~t'
	End If
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'transport_mode') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'transport_mode'),10)) + '~t' /*transport Mode*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'awb_bol_no') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'awb_bol_no'),35)) + '~t' /*AWB*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'User_field6') > '' Then
	lsOutString+= Trim(left(idsDOmain.GetItemString(1,'User_field6'),10)) + '~t' /*already formatted properly*/
Else
	lsOutString+= "MN" + String(Long(Mid(idsDOmain.GetItemString(1,'do_no'),10,7)),'0000000') + '~t' /*Delivery Note Number*/
End If

If idsDOmain.GetItemString(1,'cust_Code') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'CUst_Code'),10)) + '~t' /*Cust Code */
Else
	lsOutString+= '~t'
End If

// 03/08 - PCONKL - Address fields changed to 60

If idsDOmain.GetItemString(1,'address_1') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_1'),60))  + '~t' /*address 1 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_2') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_2'),60)) + '~t' /*address 2 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_3') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_3'),60)) + '~t' /*address 3*/
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'address_4') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'address_4'),60)) + '~t' /*address 4 */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'district') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'district'),35)) + '~t' /*district */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'zip') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'zip'),10)) + '~t' /*zip */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'City') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'city'),35)) + '~t' /*City */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'state') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'state'),35)) + '~t' /*state */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'Country') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Country'),35)) + '~t' /*Country */
Else
	lsOutString+= '~t'
End If

If idsDOmain.GetItemString(1,'Tel') > '' Then
	lsOutString+= Trim(Left(idsDOmain.GetItemString(1,'Tel'),35)) + '~t' /*Tel */
Else
	lsOutString+= '~t'
End If

//Retrieve the Intermediate Consignee Code
Select Name into :lsConsignee
FRom Delivery_Alt_Address
Where do_no = :lsDoNo and Address_type = "IC";

If lsConsignee > '' Then
	lsOutString+= Trim(Left(lsConsignee,10)) + '~t' /*Intermediate Consignee */
Else
	lsOutString+= '~t'
End If

//Freight Cost
If idsDOmain.GetItemNumber(1,'Freight_Cost') > 0 Then
	lsOutString+= String(idsDOmain.GetItemNumber(1,'Freight_Cost'),'########.00')  /*Freight Cost */ /* LAST COLUMN, NO DELIMITER*/
Else
	lsOutString+= '0' /* LAST COLUMN, NO DELIMITER*/
End If


llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id', asProject) 
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', lsFileName)
idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
	
//Loop through Packing Rows and Create Package level and Detail level records

lsCartonHold = 'aewraeraewr' /*track change in carton*/
llCartonPos = 0 /*for carton weight array*/

idsdoPack.Sort()
llRowCount = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	//If this row is a component Child, then Skip Row
	// 01/05 - PCONKL - We are now sending child information on ASN for Bundling initiative
//	If idsDOpack.GetITemString(llRowPos,'component_ind') = '*' or &
//		idsDOpack.GetITemString(llRowPos,'component_ind') = '*' Then Continue
		
	If idsDOpack.GetITemString(llRowPos,'carton_no') <> lsCartonHold Then /*carton has changed, write new header*/
		
		lsOutString = 'EP~t'
		lsOutString += Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
		
		If idsDOpack.GetItemString(llRowPos,'Carton_no') > '' Then
			// 12/03 - PCONKL - Format carton Nbr with UCCS Company and location prefixes*/
			lsUCCCarton = "0" + lsuccswhprefix + lsuccscompanyprefix + String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'000000000')
			liCheck = f_calc_uccs_Check_Digit(lsUCCCarton) /*Calculate check digit*/
			If liCheck >= 0 Then
				lsUccCarton = "00" + lsUCCCarton + String(liCheck)
			Else
				lsUccCarton = String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'00000000000000000000')
			End If
			lsOutString += lsUCCCarton + '~t' /*carton Number*/
		Else
			lsOutString += '~t'
		End If
		
		If idsDOpack.GetItemString(llRowPos,'Carton_Type') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'Carton_Type'),10) + '~t' /*carton Type*/
		Else
			lsOutString += '~t'
		End If
		
		lsOutString += String(idsDOpack.GetItemNumber(llRowPos,'Weight_Gross'),'################0') + '~t' /*carton weights were stored in array during validation process*/
		lsOutString+= idsDOpack.GetItemString(llRowPos,'standard_of_measure') + '~t' /*unit of Measure*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Height'),'################0') + '~t' /*Height*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Length'),'################0') + '~t' /*Length*/
		lsOutString += String(idsDOpack.GetITemDecimal(llRowPos,'Width'),'################0') + '~t' /*Width*/
		
		If idsDOpack.GetItemString(llRowPos,'shipper_tracking_id') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'shipper_tracking_id'),40)  /*shipper_tracking_id*/
		Else
		//	lsOutString += '~t' '* LAST FIELD *
		End If
		
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asProject) 
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/
		
		lsCartonHold = idsDOpack.GetITemString(llRowPos,'carton_no')
			
	End If /*carton changed */
		
	lsCartonno = idsDOpack.GetItemString(llRowPos,'Carton_no')
	lsSKU = idsDOpack.GetItemString(llRowPos,'SKU')
	lsSuppCode = idsDOpack.GetItemString(llRowPos,'Supp_code')
	lsCOO = idsDOpack.GetItemString(llRowPos,'Country_of_Origin')
	llLineItemNo = idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')
	
// TAM 11/18/2005	
/* Added logic to check if SKU is a child.  If it is then we need to exclude supplier from the SERIAL retrieve. 
	We were skipping Serial Numbers for kitted SKUs when more than one supplier was picked for the same SKU
	In addition to this change, the Datastore was changed to use "LIKE" for a wildcard */
	lsComponentInd = idsDOpack.GetItemString(llRowPos,'Component_ind')
	If lsComponentInd = '*' Then
		lsSuppCode = '%%'
	End If
	 
	//Serial Numbers are being retrieved from Delivey_Serial_Detail
		llSerialCount = ldsSerial.Retrieve(lsdono, lsCartonNo, lsSKU, lsSuppCode, llLineItemNo)
		
	//If we have any Serial numbers presnt, we will loop once for each Qty and set QTY to 1. we will parse one serial # per record
	If llSerialCount > 0 Then
		llLoopCount = Long(idsDOpack.GetItemNumber(llRowPos,'quantity')) /*loop once for each qty with qty = 1*/
		ldSetQty = 1
	Else /*no serial Numbers*/
		llLoopCount = 1 /*only one row for this carton row */
		ldSetQty = idsDOpack.GetItemNumber(llRowPos,'quantity')
		lsAllserialNo = ''
	End If
	
	For llLoopPos = 1 to llLoopCount
	
		lsOutString = 'ED~t'
		lsOutString += Trim(Left(idsDOmain.GetItemString(1,'Invoice_no'),10)) + '~t' /*delivery Order Number*/
		
		If idsDOpack.GetItemString(llRowPos,'Carton_no') > '' Then
			// 12/03 - PCONKL - Format carton Nbr with UCCS Company and location prefixes*/
			lsUCCCarton = "0" + lsuccswhprefix + lsuccscompanyprefix + String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'000000000')
			liCheck = f_calc_uccs_Check_Digit(lsUCCCarton) /*Calculate check digit*/
			If liCheck >= 0 Then
				lsUccCarton = "00" + lsUCCCarton + String(liCheck)
			Else
				lsUccCarton = String(Long(Right(idsDOpack.GetItemString(llRowPos,'Carton_no'),9)),'00000000000000000000')
			End If
			lsOutString += lsUCCCarton + '~t' /*carton Number*/
		Else
			lsOutString += '~t'
		End If
		
		lsOutString += String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_No')) + '~t' /*Line Item Number*/
		lsOutString += String(ldSetQty,'##########0') + '~t' /*Quantity - either one if serial numbers present*/

//TAM 06/27/2005 If a Serial Number is available, load COO from the COO_Translate table
// 					otherwise use what is on the packing list
//We should have a serial record for each qty, if not, send a blank
		If llLoopPos <= llSerialCount Then
			lsSerialNo = ldsSerial.getItemString(llLoopPos,'Serial_no')
			//TAM 06/30/2005 - exclusion list for serial check 
			IF mid(lsserialno,1,1) <> 'C' and mid(lsserialno,1,1) <> 'M' and &
				mid(lsserialno,1,1) <> 'A' and mid(lsserialno,1,1) <> 'P' and mid(lsserialno,1,1) <> '3' THEN 

			//TAM 07/28/2005 Item Master Inclusions for Serial Check					
  				SELECT Item_Master.User_Field4  
  			  	INTO :ls_process_type  
    			FROM Item_Master  
   			WHERE ( Item_Master.Project_ID = :asproject ) AND  
         			( Item_Master.SKU = :lssku ) AND  
         			( Item_Master.Supp_Code = :lssuppcode )   ;

				IF ls_process_type = 'BCC' or ls_process_type = 'BNC' Then		

					lsfind = "serial_division = '" + mid(lsserialNo,1,1) + "' and serial_supplier= '" + mid(lsSerialNo,4,1) + "'"
					llFindRow = idsCOO_Translate.Find(lsFind,1,idsCOO_Translate.RowCount())
				 	IF llFindRow > 0 Then 
						lsCOO = idsCOO_Translate.getItemString(llFindrow,'Designating_Code')
			  	 	Else 
						lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
					End If
			  	Else 
					lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
				End If
			Else 
				lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
			End If
		Else 
			lsSerialNo = ''
			lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
		End If		


// TAM 06/27/2005 COO has been loaded above so there is no need to get it from the Packlist here
//		If idsDOpack.GetItemString(llRowos,'country_of_origin') <> 'XXX' Then /*only include COO if not the default value (XXX)*/
			//If the 3 char COO was entered, we need tro convert to 2 char code
			//lsCOO = idsDOpack.GetItemString(llRowPos,'country_of_origin') 
		If lsCOO <> 'XXX' Then /*only include COO if not the default value (XXX)*/
			If len(lsCOO) > 2 Then
				Select designating_Code Into :lsCOO
				From Country
				Where iso_country_cd = :lsCOO;
			End If
			lsOutString += lsCOO + '~t' /*Country of Origin*/
		Else
			lsOutString += '~t'
		End If
		
		If idsDOpack.GetItemString(llRowPos,'sku') > '' Then
			lsOutString += Left(idsDOpack.GetItemString(llRowPos,'sku'),50) + '~t' /*SKU*/
		Else
			lsOutString += '~t'
		End If

		//We should have a serial record for each qty, if not, send a blank
//  TAM 06/27/2005  Move this code above and combined with COO Translate
//		If llLoopPos <= llSerialCount Then
//			lsSerialNo = ldsSerial.getItemString(llLoopPos,'Serial_no')
//		Else
//			lsSerialNo = ''
//		End If
			
		lsOutString += lsSerialNo + "~t"
		
		//For UOM, we need to get it from the Order Detail Tab
		lsFind = "Upper(SKU) = '" + Upper(lsSKU) +  "' and Line_Item_no = " + String(llLineItemNo)
		llFindRow = idsDODetail.Find(lsFind,1,idsDOdetail.RowCount())
		If llfindRow > 0 Then
			lsUOM = idsDOdetail.GetITemString(llFindRow,'uom')
		End If
		
		If lsUOM = '' or isnull(lsUOM) then lsUOM = 'EA'
		
		lsOutString += lsUOM + '~t'
		
		// 01/05 - PCONKL - Include Parent SKU
	//	lsFind = "Line_item_No = " + String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Upper(SKU) = '" + upper(idsDOpack.GetItemString(llRowPos,'SKU')) +  "'"
		lsFind = "Line_item_No = " + String(idsDOpack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Component_ind = 'Y'"
		llFindRow = idsdoPick.Find(lsFind,1,idsdoPick.RowCount())
		If llFindRow > 0 Then
			//lsSKUPArent = idsdoPick.getITemString(llFindRow,'sku_parent') 
			lsSKUPArent = idsdoPick.getITemString(llFindRow,'sku') 
		Else
			lsSKUParent = idsDOpack.GetItemString(llRowPos,'SKU')
		End If
	
		lsOutString += lsSKUParent
		
		llNewRow = idsOut.insertRow(0)
		idsOut.SetItem(llNewRow,'Project_id', asProject) /* Matches entry in ini file - ASN files are going to seperate folder so they can be processed last*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		idsOut.SetItem(llNewRow,'dest_cd', 'RMA') /*routed to RMA folder- different destination in ICC*/

	Next /* next serial Number */
	
Next /*Packing Record*/
	
//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)




Return 0
end function

on u_nvo_edi_confirmations_3com.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_3com.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// testing 
end event

