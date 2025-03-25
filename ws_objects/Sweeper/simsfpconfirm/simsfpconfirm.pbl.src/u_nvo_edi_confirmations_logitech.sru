$PBExportHeader$u_nvo_edi_confirmations_logitech.sru
$PBExportComments$Process outbound edi confirmation transactions for Logitech
forward
global type u_nvo_edi_confirmations_logitech from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_logitech from nonvisualobject
end type
global u_nvo_edi_confirmations_logitech u_nvo_edi_confirmations_logitech

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsDOPickDTL, idsDOTracking, idsWOmain, &
				idsWODetail, idsWOPickDTL, idsWOPutaway, idsWOPick
end variables

forward prototypes
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_sr (string asproject, string asdono)
public function integer uf_wo_components_return (string asproject, string aswono, long aitransid)
public function integer uf_wo_components_issue (string asproject, string aswono, long aitransid)
public function integer uf_workorder_receipt (string asproject, string aswono, long altransid)
end prototypes

public function integer uf_adjustment (string asproject, long aladjustid);//TAM 07/04
//Prepare a Stock Adjustment Transaction for Logitech for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID
String		lsOutString, lsMessage,	lsSKU, lsOldInvCode,	lsNewInvCode, lsOldInvType, lsNewInvType, & 
				lsFileName, lsadjustmentind, lsUOM, lsAdjustmentType, lsSupplier, &
				lsWarehouse, lsDocType, lsUpdate, lsAcctAlias, &
				lsLineItemNo, lsqty
DEcimal		ldBatchSeq
Integer		liRC
String	lsLogOut

lsLogOut = "      Creating Interface Records For AdjustID: " + String(alAdjustID)
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

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsWarehouse = idsAdjustment.GetITemString(1,'Wh_Code')
lsUpdate = String(idsadjustment.GetItemDateTime(1,'last_update'),"yyyymmdd")
lsSku = idsAdjustment.GetITemString(1,'sku')
llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")
lsDocType = 'IA' //Default for Adjustments only not Workorder_Type.Ord_Type_Descript
lsSupplier = ' ' //Not used for Adjustments only for Workorder Number 
lsLineItemNo = '  ' // Not used for Adjustments only for Workorder line Item Number



//Old Inventory Type (From lookup table)
lsOldInvType = idsAdjustment.GetITemString(1,"Old_inventory_type")
Select Code_Descript into :lsOldInvCode
From Lookup_Table
Where Code_ID = :lsOldInvType and
		Project_id = :asProject and 
      Code_Type = 'SI' ;     

// TAM  Default Null to Space
	If IsNull(lsOldInvCode) then
		lsOldInvCode = '  '
	End If


//New Inventory Type (From lookup table)
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")
Select Code_Descript into :lsNewInvCode
From Lookup_Table
Where Code_ID = :lsNewInvType and
		Project_id = :asProject and 
      Code_Type = 'SI' ;     

// TAM  Default Null to Space
	If IsNull(lsNewInvCode) then
		lsNewInvCode = '  '
	End If

//Acct Alias Code (From lookup table)
lsAdjustmentType = idsAdjustment.GetITemString(1,'reason') 
Select Code_Descript into :lsAcctAlias
From Lookup_Table
Where Code_ID = :lsAdjustmentType and
		Project_id = :asProject and 
      Code_Type = 'IA' ;     

// TAM  Default Null to Space
	If IsNull(lsAcctAlias) then
		lsAcctAlias = '  '
	End If

lsUOM = 'EA  '
	
//We are only sending Adjustments if reason(Adjustment Type) <> 'OTHER'
If lsAdjustmentType <> 'OTHER' Then

	//We are sending 'IT' records Inventory Type Changes 
	If (lsNewInvCode <> lsOldInvCode) Then
		
		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If

		lsqty = string(llOldQty,'000000000.00000') 
	
		lsOutString = 'IT' /*rec type = Material Movement*/
		lsOutString += lsWarehouse + Space(10 - Len(lsWarehouse))
		lsOutString += asProject  + Space(10 - Len(asProject))
		lsOutString += String(alAdjustId)  + Space(18 - Len(String(alAdjustId)))
		lsOutString += lsUpdate  + Space(8 - Len(lsUpdate))
		lsOutString += lsSku + Space(50 - len(lsSKU))
		lsOutString += lsUOM
		lsOutString += lsqty + Space(15 - len(lsqty))
		lsOutString += lsOldInvCode + Space(2 - Len(lsOldInvCode))
		lsOutString += lsNewInvCode + Space(2 - Len(lsNewInvCode))

		llNewRow = idsOut.insertRow(0)
	
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
		//File name is IT + Counter 
		lsfilename = 'IT' + string(ldbatchseq,"0000000000") + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
		//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
		gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
	End If /* Inventory Type Changes */

	idsOut.Reset()

	//We are sending 'IA' records When Qty Changes 
	If (llNewQTY <> llOldQTY) Then
		
		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If

		lsqty = String(ABS(llOldQty - llNewQty),'000000000.00000')
	
		If (llNewQty - llOldQty) < 0 Then
			lsadjustmentind = '-'
		Else
			lsadjustmentind = '+'
		End If
		
		lsOutString = 'IA' /*rec type = Material Movement*/
		lsOutString += lsWarehouse + Space(10 - Len(lsWarehouse))
		lsOutString += asProject  + Space(10 - Len(asProject))
		lsOutString += lsDocType  + Space(2 - Len(lsDocType))
		lsOutString += String(alAdjustId)  + Space(18 - Len(String(alAdjustId)))
		lsOutString += lsSupplier  + Space(30 - Len(lsSupplier))
		lsOutString += lsUpdate  + Space(8 - Len(lsUpdate))
		lsOutString += lsLineItemNo + space(25 - Len(lsLineItemNo)) 
		lsOutString += lsSku + Space(50 - len(lsSKU))
		lsOutString += lsqty + Space(15 - len(lsqty))
		lsOutString += lsUOM
 		lsOutString += lsNewInvCode + Space(2 - Len(lsNewInvCode))
		lsOutString += lsadjustmentind 
		lsOutString += lsAcctAlias + Space(30 - Len(lsAcctAlias))
		lsOutString += lsAdjustmentType + Space(2 - Len(lsAdjustmentType))

		llNewRow = idsOut.insertRow(0)
	
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
		//File name is AW + Counter 
		lsfilename = 'AW' + string(ldbatchseq,"0000000000") + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
		//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
		gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
	End If /* Quantity Change*/
End If /* Reason <> Other*/
		


Return 0
end function

public function integer uf_gr (string asproject, string asrono);//TAM 07/04
//Prepare a Goods Received for Logitech for the order that was just confirmed

Long	llrowPos, llRowCount, llNewRow, llstringlength
Decimal	ldBatchSeq 
String	lsOutString, lsSKU, lsInvType, lsOrderNo, &
			lsMessage, &
			lsWarehouse,&
			lsLogOut
String	lsSuppInvoice, lsCompleteDate, lsOrdType, lsOrdTypeDescript, &
			lsUF7, lsSuppCode, lsSuppName, lsSkuDescript, lsQty, lsLineItemNo, &
			lsInvTypeDescript, lsUOM, lsFileName, lsdash	, lsID


			
Integer	liRC
Boolean	lbSendTrans


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
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

lsLogOut = "      Creating RE For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsroPutaway.Retrieve(asRONO)

llRowCount = idsroPutaway.RowCount()

lbSendTrans = False

lsOrderNo = idsroMain.GetITemString(1,'supp_invoice_no')
//Strip out line number from supplier invoice.  Put in to insure unique order number.
llstringlength = len(lsOrderNo)

DO UNTIL lsdash = '-' or llstringlength = 2   
	llstringlength = llstringlength - 1
	lsdash = mid(lsorderNo,llstringlength,1)
LOOP
llstringlength = llstringlength - 1

lssuppinvoice = left(lsOrderNo,llstringlength)

//lssuppinvoice = left(lsOrderNo,pos(lsOrderNo,'-')-1)



lsWarehouse = Upper(idsroMain.GetITemString(1,'wh_code'))
lsCompleteDate = string(idsroMain.GetITemDateTime(1,'Complete_Date'),'yyyymmdd')
lsOrdType = idsroMain.GetITemString(1,'Ord_Type')

If lsordType <> 'S' and lsordType <> 'X' and lsordType <> 'E' and lsordType <> 'I' Then
		lsLogOut = "        *** Order Type does not get a RE File sent for type : " + lsOrdType
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
Else
	SELECT Code_Descript  
   INTO :lsOrdTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'RO' AND Code_ID = :lsOrdType ;
End if

lsSuppCode = idsroMain.GetITemString(1,'Supp_Code')
lsUF7 = idsroMain.GetITemString(1,'User_Field7')

SELECT Supp_Name  
INTO :lsSuppName 
FROM Supplier  
WHERE Project_ID = :AsProject AND Supp_Code = :lsSuppCode ;

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//we want each record in a seperate file (each batch seq break causes a new file)
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

	lsOutString = 'RM'
	lsOutString += lsWarehouse + space(10 - len(lsWarehouse))
	lsOutString += asProject  + Space(10 - Len(asProject))
	lsOutString += lssuppinvoice  + Space(30 - Len(lssuppinvoice))
	
	// 08/04 - PCONKL - Need unique # for Receipt #, ro_no is not unique (may have same do_no/wo_no)
	lsID = 'RO' + Right(Trim(asRoNo),6)

//	lsOutString += asRoNo  + Space(16 - Len(asRoNo))
	lsOutString += lsID  + Space(16 - Len(lsID))
	
	lsOutString += lsCompleteDate
	lsOutString += lsOrdTypeDescript + Space(2 - Len(lsOrdTypeDescript))
	lsOutString += lsSuppCode + space(20 - len(lsSuppCode))
	lsOutString += lsUF7 + space(30 - len(lsUF7))
	lsOutString += lsSuppName + space(40 - len(lsSuppName))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//File name is RE + Counter 
	lsfilename = 'RE' + string(ldbatchseq,"0000000000") + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


For llRowPos = 1 to lLRowCount /* For each Putaway Row */

	lsLineItemNo = string(idsroPutaway.GetITemNumber(llRowPos,'Line_Item_no'))
	lsSKU = idsroPutaway.GetITemString(llRowPos,'SKU')
	SELECT Item_Master.Description  
   INTO :lsSkuDescript  
   FROM Item_Master  
   WHERE SKU = :lsSku   ;

	If lsOrdTypeDescript = 'PE' Then	
		lsSKU = 'VOID'
	End If
	
	lsQty = String(idsroPutaway.GetITemNumber(llRowPos,'Quantity'),'000000000.00000')
	lsUOM = 'EA  '
	lsInvType = idsroPutaway.GetITemString(llRowPos,'Inventory_Type')
	SELECT Code_Descript  
   INTO :lsInvTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;

	If IsNull(lsInvTypeDescript) then
		lsInvTypeDescript = '  '
	End If

	lsOutString = 'RD'
	lsOutString += lsLineItemNo + space(25 - len(lsLineItemNo))
	lsOutString += LsSku  + Space(50 - Len(LsSku))
	lsOutString += lsQty 
	lsOutString += lsUOM
	lsOutString += lsInvTypeDescript + Space(2 - Len(lsInvTypeDescript))
	lsOutString += lsSkuDescript + space(70 - len(lsSkuDescript))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*Putaway*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0


end function

public function integer uf_gi (string asproject, string asdono);//TAM 07/04
//Prepare a Ship Confirm Transaction for Logitech for the Delivery order that was just confirmed

Long			llRowPos, llRowCount, llSSRowPos, llSSRowCount, &
				llNewRow, llLineItemNo,	llBatchSeq
//llDetailRow,	
				
String		lsFind,lsOutString,lsOutString2, lsMessage, lsSku, lsSupplier, lsInvoice,	lsTemp, lsCurrencyCode, lsShipTo,	&
				lsShipFrom, lsCustCode, lsCustSKU, lsUCCSCode, lsFolder
String		lsOrderNo, lssuppinvoice, lsOrdType, lsOrdTypeDescript, lsAWBBOL, lscarriername, &
				lsCompleteDate, lsNotifyDate, lsScheduleDate, lsScac, lsCarrier, lsFileName, lsInvType, lsInvTypeDescript, lsID

Decimal		ldBatchSeq, ldTemp,ldFreight, ldTotalAmount, ldPrice, ldQTY, ldtax, ldOther
Integer		liRC

String	lsLogOut
long llAllocQty

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


If Not isvalid(idsDOPickDTL) Then
	idsDOPickDTL = Create Datastore
	idsDOPickDTL.Dataobject = 'd_do_Picking_Detail'
	idsDOPickDTL.SetTransObject(SQLCA)
End If

//If Not isvalid(idsWOPickDTL) Then
//	idsWOPickDTL = Create Datastore
//	idsWOPickDTL.Dataobject = 'd_wo_Picking_Detail'
//	idsWOPickDTL.SetTransObject(SQLCA)
//End If
//

If Not isvalid(idsDOTracking) Then
	idsDOTracking = Create Datastore
	idsDOTracking.Dataobject = 'd_do_Packing_Track_ID'
	idsDOTracking.SetTransObject(SQLCA)
End If


If Not isvalid(idsDODetail) Then
	idsDODetail = Create Datastore
	idsDODetail.Dataobject = 'd_do_detail'
	idsDODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPack) Then
	idsDOPack = Create Datastore
	idsDOPack.Dataobject = 'd_do_packing'
	idsDOPack.SetTransObject(SQLCA)
End If

idsOut.Reset()

//Retreive Delivery Master, and Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoDetail.Retrieve(asDoNo) /*detail Records*/
//idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*packing Records*/

lsLogOut = "        Creating SW For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Build and Write the Header
lsOutString = 'SH' 																				//record type

lsTemp = idsDOMain.GetITemString(1,'wh_code')
lsOutString += lsTemp + space(10 - len(lsTemp))	 										//warehouse

lsTemp = idsDOMain.GetITemString(1,'cust_code')
lsOutString += lsTemp + space(20 - len(lsTemp))	 										//cust code

lsOrderNo = idsDOMain.GetITemString(1,'invoice_no')
//Strip out line number from supplier invoice.  Put in to insure unique order number.
//lssuppinvoice = left(lsOrderNo,pos(lsOrderNo,'.')-1)
lsOutString += lsOrderNo + space(20 - len(lsOrderNo))	 					//Order Number (Invoice_No)

// 08/04 - PCONKL - Need unique # for Receipt #, do_no is not unique (may have same ro_no/wo_no)
lsID = 'DO' + Right(Trim(asDoNo),6)
	
//lsOutString += asDoNo + space(16 - len(asDoNo))											//DO NO
lsOutString += lsID + space(16 - len(lsID))	

lsOrdType = idsDOMain.GetITemString(1,'Ord_Type')										//Order Type
If lsordType <> 'S' and lsordType <> 'P' Then
	If lsordType <> 'X' and lsordType <> 'E' and lsordType <> 'I' Then
		lsLogOut = "        *** Order Type does not get a File sent for type : " + lsOrdType
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	Else
		// Send a PO Receipt for this delivery order		
		liRC = this.uf_sr(asProject, asDoNo)	
		If lirc < 0 Then
			lsLogOut = "        *** Receipt PO Not Sent for this Delivery Order  : " + asDONO
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		Else
			Return 0
		End If
	End If
Else
	SELECT Code_Descript  
   INTO :lsOrdTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'DO' AND Code_ID = :lsOrdType ;
End if
lsOutString += lsOrdTypeDescript + space(4 - len(lsOrdTypeDescript))	 			

//lsTemp = idsDOMain.GetITemString(1,'Standard_of_Measure')								//UOM
// TAM 08/04  Get UOM from 1st pack row.  All rows are the same
If idsdoPack.RowCount() > 0 Then
	lsTemp = trim(idsDOPack.GetITemString(1,'Standard_of_Measure'))						//UOM
Else
	lsTemp = 'M'
End If

//If English or Metric flag
If lsTemp = 'E' Then
	lsTemp = 'LB'
Else
	lsTemp = 'KG'
End if
lsOutString += lsTemp + space(2 - len(lsTemp))

lsOutString += String(idsDOMain.GetITemNumber(1,'Weight'),'000000.00000')				//Weight


lsTemp = String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmmss')
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If

lsTemp = String(idsDOMain.GetITemDateTime(1,'Carrier_notified_Date'),'yyyymmddhhmmss') 
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If

lsTemp = String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmmss') 
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If

lsTemp = String(idsDOMain.GetITemDateTime(1,'Schedule_Date'),'yyyymmddhhmmss')
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If

lsTemp = String(idsDOMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmmss') 
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If

lsTemp = String(idsDOMain.GetITemDateTime(1,'Schedule_Date'),'yyyymmddhhmmss') 
If lsTemp > '' Then
	lsOutString += lstemp
Else
	lsoutstring += '              '
End If


lscarrier = idsDOMain.GetITemString(1,'Carrier')												//Carrier
SELECT SCAC_Code, carrier_name  
INTO :lsSCAC, :lsCarriername 
FROM Carrier_Master  
WHERE ( Carrier_Code = :lsCarrier ) AND  
  	   ( Project_ID = :AsProject )   ;

If not isnull(lsCarriername) Then						
	lsOutString +=  lsCarriername + space(50 - len(lsCarriername))										
else
	lsOutString += space(50) 
End If

If not isnull(idsDOMain.GetITemString(1,'freight_terms')) Then						//Freight Terms
	lsTemp = idsDOMain.GetITemString(1,'freight_terms')
	lsOutString += lsTemp + space(20 - len(lsTemp))	
else
	lsOutString += space(20) 
End If

lsOutString += String(idsDOMain.GetITemNumber(1,'ctn_cnt'),'0000000')			// Carton Count

If not isnull(idsDOMain.GetITemNumber(1,'freight_cost')) Then 						// Freight Costs
	ldFreight = idsDOMain.GetITemNumber(1,'freight_cost') 									
else
	ldFreight = 0
End If
lsOutString += string(ldFreight, "000000.000") 

If not isnull(idsDOMain.GetITemString(1,'User_Field10')) Then 						
	lsTemp = idsDOMain.GetITemString(1,'User_Field10')								//User Field 10
	lsOutString += lsTemp + space(50 - len(lsTemp))	
else
	lsOutString += space(50) 
End If


If not isnull(idsDOMain.GetITemString(1,'Ship_Ref')) Then 					// Shipper Ref
	lsTemp = idsDOMain.GetITemString(1,'Ship_Ref')
	lsOutString += lsTemp + space(40 - len(lsTemp))	
Else
	lsOutString += space(40)	
End If


If not isnull(lsSCAC) Then 															// Scac
	lsOutString += lsScac + space(4 - len(lsScac))
Else
	lsOutString += space(4)
End If

If not isnull(idsDOMain.GetITemString(1,'User_Field9')) Then 				// User Field 9
	lsTemp = idsDOMain.GetITemString(1,'User_Field9')
	lsOutString += lsTemp + space(50 - len(lsTemp))	
Else
	lsOutString += space(50)	
End If

If not isnull(idsDOMain.GetITemString(1,'Cust_Name')) Then 				// Customer Name
	lsTemp = idsDOMain.GetITemString(1,'Cust_Name')
	lsOutString += lsTemp + space(40 - len(lsTemp))	
Else
	lsOutString += space(40)	
End If

//Get The AWB BOL from the Header to use at the end
	lsAWBBOL = idsDOMain.GetITemString(1,'AWB_BOL_No')

//write to DB for sweeper to pick up
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id',asProject) 
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString) 
idsOut.SetItem(llNewRow,'file_name', lsFileName)
//File name is SW + Counter 
lsfilename = 'SW' + string(ldbatchseq,"0000000000") + '.DAT'
idsOut.SetItem(llNewRow,'file_name', lsFileName)


// *********************************    For each detail row, write a detail - 1 record per Detail row.
llRowCOunt = idsDODetail.RowCount()
For llRowPos = 1 to llRowCount
	llAllocQty =	idsDODetail.GetITemNumber(llRowPos,'Alloc_Qty')
// TAM 07/04  Logitech wants to see Zero Quantity shipped
	If isNull(llAllocQty)  Then
		llAllocQty = 0
	End If
//	if llAllocQty > 0 then

		llLineItemNo = idsDODetail.GetITemNumber(llRowPos,'line_item_no')

		llNewRow = idsOut.insertRow(0)
		lsOutString = 'SD' 																		//Detail ID

		lsOutString += string(llLineItemNo,"000000") 									// Line Item No
		

		If not isnull(idsDODetail.GetITemString(llRowPos,'User_Field1')) Then 	// User Field 1
			lsTemp = idsDODetail.GetITemString(llRowPos,'User_Field1')				
			lsOutString +=  lsTemp + space(20 - len(lsTemp))	
		else
			lsOutString += space(20) 
		End If

		If not isnull(idsDODetail.GetITemString(llRowPos,'SKU')) Then 				
			lsTemp = idsDODetail.GetITemString(llRowPos,'SKU')								//SKU 
			lsOutString +=  lsTemp + space(50 - len(lsTemp))	
		else
			lsOutString += space(50) 
		End If
		
		If not isnull(idsDODetail.GetITemString(llRowPos,'UOM')) Then 				
			lsTemp = idsDODetail.GetITemString(llRowPos,'UOM')								//UOM
			lsOutString +=  lsTemp + space(4 - len(lsTemp))
		else
			lsOutString += space(4) 
		End If

		lsOutString += string(llAllocQTY,"000000000.00000") 							//alloc_Qty 
		
		lsInvType = trim(idsDoDetail.GetITemString(llRowPos,'User_Field5'))		//UF5 = Inventory Type
		SELECT Code_Descript  
   	INTO :lsInvTypeDescript  
   	FROM Lookup_Table  
   	WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;

		If not isnull(lsInvTypeDescript) Then 				
			lsTemp =  lsInvTypeDescript			   											//Inv Type 
			lsOutString +=  lsTemp + space(2 - len(lsTemp))
		else
			lsOutString += space(2) 
		End If
	
		If not isnull(idsDODetail.GetITemString(llRowPos,'User_Field6')) Then 				
		lsTemp = idsDODetail.GetITemString(llRowPos,'User_Field6')							// Currency Code
		lsOutString += lsTemp + space(3 - len(lsTemp))
		else
			lsOutString += space(3) 
		End If

		If not isnull(idsDODetail.GetITemString(llRowPos,'User_Field4')) Then 			// User Field 2
		 	lsTemp = idsDODetail.GetITemString(llRowPos,'user_field4')						// User Field 2
			lsOutString += lsTemp + space(20 - len(lsTemp)) 
		else
			lsOutString += space(20) 
		End If
		
		//write to DB for sweeper to pick up
		idsOut.SetItem(llNewRow,'Project_id',Asproject) /* hardcoded to match entry in .ini file for file destination*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)

		//Get Picking Details to get Pedimento Number From RONO

		llSSRowCOunt = idsDoPickDTL.Retrieve(asDoNo,llLineItemNo) /*Picking Detail Records */
//		llSSWORowCOunt = idsWoPickDTL.Retrieve(asDoNo,llLineItemNo) /*Workorder Picking Detail */

// Loop Through all WO picking details to see if there is a new RONOs to get PEDIMENTO Numbers
//		IF llSSWORowCount > 0 Then
//			For llSSRowPos = 1 to llSSWORowCount
//				lsWONORONO = idsWOPickDTL.GetITemString(llSSRowPos,'Receive_Master_RO_NO')
//				llSSFindRow = idsDoPickDTL.Find('Receive_Master_RO_NO = lsWONORONO', 1, idsDoPickDTL.RowCount())
//				If llSSFindRow <= 0 THen
//					llSSNewRow = idsOut.insertRow(0)
//					idsDoPickDTL.SetItem(llSSNewRow,'Receive_Master_User_Field4', idsWOPickDTL.GetITemString(llSSRowPos,'Receive_Master_User_Field4')) 
//					idsDoPickDTL.SetItem(llSSNewRow,'Receive_Master_User_Field5', idsWOPickDTL.GetITemString(llSSRowPos,'Receive_Master_User_Field5')) 
//					idsDoPickDTL.SetItem(llSSNewRow,'Receive_Master_User_Field6', idsWOPickDTL.GetITemString(llSSRowPos,'Receive_Master_User_Field6')) 
//					idsDoPickDTL.SetItem(llSSNewRow,'delivery_picking_detail_ro_no', lsWonoRono) 
//					idsDoPickDTL.SetItem(llSSNewRow,'qty_Sum', idsWOPickDTL.GetITemnumber(llSSRowPos,'qty_Sum')) 
//					idsDoPickDTL.SetItem(llSSNewRow,'delivery_picking_detail_do_no', asDoNo) 
//					idsDoPickDTL.SetItem(llSSNewRow,'delivery_picking_detail_line_item_no', lllineItemNo) 
//				End if	
//			Next
//		End If
	
//		llSSRowCount = idsDoPickDTL.RowCount()

		For llSSRowPos = 1 to llSSRowCount

			llNewRow = idsOut.insertRow(0)
			lsOutString = 'SS' 																		//Detail ID

			If not isnull(idsDOPickDTL.GetITemString(llSSRowPos,'Lot_No'))	Then
			lsTemp = left(idsDOPickDTL.GetITemString(llSSRowPos,'Lot_No'),20)					// (Pedimento)
				lsOutString +=  lsTemp + space(20 - len(lsTemp))	
			Else
				lsOutString +=  space(20)
			End If
				
			If not isnull(idsDOPickDTL.GetITemString(llSSRowPos,'Po_No'))	Then
				lsTemp = left(idsDOPickDTL.GetITemString(llSSRowPos,'Po_No'),20)					// (Port of Entry)
				lsOutString +=  lsTemp + space(20 - len(lsTemp))	
			Else
				lsOutString +=  space(20)
			End If

			lsTemp = String(idsDOPickDTL.GetITemDateTime(llSSRowPos,'Expiration_date'), 'YYYYMMDD')	// (Entry_Date)
			If lsTemp > '' Then
				lsOutString +=  lsTemp 	
			Else
				lsOutString +=  space(8)
			End If

			lsOutString += String(idsDOPickDTL.GetITemNumber(llSSRowPos,'QTY_SUM'),'000000000.00000')	// Quantity

			//write to DB for sweeper to pick up
			idsOut.SetItem(llNewRow,'Project_id',Asproject) /* hardcoded to match entry in .ini file for file destination*/
			idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			idsOut.SetItem(llNewRow,'batch_data', lsOutString)
			idsOut.SetItem(llNewRow,'file_name', lsFileName)

		Next
//	end if	// TAM 07/04
Next /* Next Detail record */

		//Get Picking Details to get Pedimento Number From RONO

llRowCOunt = idsDoTracking.Retrieve(asDoNo) /*Picking Detail Records Grouped by Track ID*/
// No Tracking IDs Entered then llrowcount = 0
If llRowCount < 1 Then
		llNewRow = idsOut.insertRow(0)
		lsOutString = 'ST' 																		//Detail ID
		lsOutString +=  space(50)			//Tracking Id not there
		If not isnull(lsAWBBOL)	Then
			lsOutString +=  lsAWBBOL + space(20 - len(lsAWBBOL))							// (AWBBOL)
		Else
			lsOutString +=  space(20)
		End If

			//write to DB for sweeper to pick up
		idsOut.SetItem(llNewRow,'Project_id',Asproject) /* hardcoded to match entry in .ini file for file destination*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)

Else


	For llRowPos = 1 to llRowCount

		llNewRow = idsOut.insertRow(0)
		lsOutString = 'ST' 																		//Detail ID

		If not isnull(idsDOTracking.GetITemString(llRowPos,'Shipper_Tracking_ID'))	Then
				lsTemp = idsDOTracking.GetITemString(llRowPos,'Shipper_Tracking_ID')		// (Tracking ID)
				lsOutString +=  lsTemp + space(50 - len(lsTemp))	
		Else
			lsOutString +=  space(50)
		End If

		If not isnull(lsAWBBOL)	Then
			//we only want AWB on the first ST record
			If llRowPos = 1 Then
				lsOutString +=  lsAWBBOL + space(20 - len(lsAWBBOL))							// (AWBBOL)
			Else
				lsOutString +=  space(20)
			End If
		Else
			lsOutString +=  space(20)
		End If


			//write to DB for sweeper to pick up
		idsOut.SetItem(llNewRow,'Project_id',Asproject) /* hardcoded to match entry in .ini file for file destination*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		idsOut.SetItem(llNewRow,'file_name', lsFileName)

	Next
End If

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DS
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0
end function

public function integer uf_sr (string asproject, string asdono);//TAM 07/04
// This is a GOODS ISSUE from a delivery order

Long	llrowPos, llRowCount, llNewRow
Decimal	ldBatchSeq 
String	lsOutString, lsSKU, lsInvType, lsOrderNo, &
			lsMessage, &
			lsWarehouse,&
			lsLogOut
String	lsSuppInvoice, lsCompleteDate, lsOrdType, lsOrdTypeDescript, &
			lsUF7, lsUF8, lsSuppCode, lsSuppName, lsSkuDescript, lsQty, lsLineItemNo, &
			lsInvTypeDescript, lsUOM, lsFileName, lsID


			
Integer	liRC
Boolean	lbSendTrans


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsdomain) Then
	idsdomain = Create Datastore
	idsdomain.Dataobject = 'd_do_master'
	idsdomain.SetTransobject(sqlca)
End If

If Not isvalid(idsDOPick) Then
	idsDOPick = Create Datastore
	idsDOPick.Dataobject = 'd_do_Picking'
	idsDOPick.SetTransobject(sqlca)
End If

idsOut.Reset()

lsLogOut = "      Creating RE For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDOPick.Retrieve(asDONO)

llRowCount = idsDOPick.RowCount()

lbSendTrans = False

lsOrderNo = idsdoMain.GetITemString(1,'invoice_no')

lsWarehouse = Upper(idsDOMain.GetITemString(1,'wh_code'))
lsCompleteDate = string(idsDOMain.GetITemDateTime(1,'Complete_Date'),'yyyymmdd')
lsOrdType = idsDOMain.GetITemString(1,'Ord_Type')

If lsordType <> 'X' and lsordType <> 'E' and lsordType <> 'I' Then
		lsLogOut = "   *** Delivery Order Type does not get a RE File sent for type : " + lsOrdType
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
Else
	SELECT Code_Descript  
   INTO :lsOrdTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'DO' AND Code_ID = :lsOrdType ;
End if

lsSuppCode = idsDOMain.GetITemString(1,'Cust_Code')
lsUF7 = idsDOMain.GetITemString(1,'User_Field7')
lsUF8 = idsDOMain.GetITemString(1,'User_Field8')

SELECT Supp_Name  
INTO :lsSuppName 
FROM Supplier  
WHERE Project_ID = :AsProject AND Supp_Code = :lsSuppCode ;

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
//we want each record in a seperate file (each batch seq break causes a new file)
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

	lsOutString = 'RM'
	lsOutString += lsWarehouse + space(10 - len(lsWarehouse))
	lsOutString += asProject  + Space(10 - Len(asProject))
	lsOutString += lsOrderNo  + Space(30 - Len(lsOrderNo))

// TAM user field 8 contains original RONO
	lsOutString += lsUF8 + space(16 - len(lsUF8))
//	
//	// 08/04 - PCONKL - Need unique # for Receipt #, do_no is not unique (may have same ro_no/wo_no)
//	lsID = 'DO' + Right(Trim(asDoNo),6)
//
//	lsOutString += lsID  + Space(16 - Len(lsID))
//		
	lsOutString += lsCompleteDate
	lsOutString += lsOrdTypeDescript + Space(2 - Len(lsOrdTypeDescript))
	lsOutString += lsSuppCode + space(20 - len(lsSuppCode))
	lsOutString += lsUF7 + space(30 - len(lsUF7))
	lsOutString += lsSuppName + space(40 - len(lsSuppName))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//File name is RE + Counter 
	lsfilename = 'RE' + string(ldbatchseq,"0000000000") + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


For llRowPos = 1 to lLRowCount /* For each Putaway Row */

	lsLineItemNo = string(idsDoPick.GetITemNumber(llRowPos,'Line_Item_no'))
	lsSKU = idsDOPick.GetITemString(llRowPos,'SKU')
	SELECT Item_Master.Description  
   INTO :lsSkuDescript  
   FROM Item_Master  
   WHERE SKU = :lsSku   ;

	If lsOrdTypeDescript = 'PE' Then	
		lsSKU = 'VOID'
	End If
	
	lsQty = String(idsDOPick.GetITemNumber(llRowPos,'Quantity') * -1 ,'000000000.00000;-00000000.00000')
	lsUOM = 'EA  '
	lsInvType = idsDOPick.GetITemString(llRowPos,'Inventory_Type')
	SELECT Code_Descript  
   INTO :lsInvTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;

	If IsNull(lsInvTypeDescript) then
		lsInvTypeDescript = '  '
	End If


	lsOutString = 'RD'
	lsOutString += lsLineItemNo + space(25 - len(lsLineItemNo))
	lsOutString += LsSku  + Space(50 - Len(LsSku))
	lsOutString += lsQty  
	lsOutString += lsUOM
	lsOutString += lsInvTypeDescript + Space(2 - Len(lsInvTypeDescript))
	lsOutString += lsSkuDescript + space(70 - len(lsSkuDescript))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*Putaway*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)


Return 0


end function

public function integer uf_wo_components_return (string asproject, string aswono, long aitransid);//TAM 07/04

Long	llrowPos, llRowCount, llNewRow, llstringlength, lladjustid, llqty
Decimal	ldBatchSeq 
String	lsOutString, lsSKU, lsInvType, lsOrderNo, &
			lsMessage, &
			lsWarehouse,&
			lsLogOut
String	lsSuppInvoice, lsCompleteDate, lsOrdType, lsOrdTypeDescript, &
			lsUF2, lsSuppCode, lsSuppName, lsSkuDescript, lsQty, lsLineItemNo, &
			lsInvTypeDescript, lsUOM, lsFileName, lsadjustmentind, lsadjustmentid, &
			lsdash

Integer	liRC
Boolean	lbSendTrans


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsWOMain) Then
	idsWOMain = Create Datastore
	idsWOMain.Dataobject = 'd_workorder_master'
	idsWOMain.SetTransobject(sqlca)
End If

//If Not isvalid(idsWODetail) Then
//	idsWODetail = Create Datastore
//	idsWODetail.Dataobject = 'd_workorder_detail_WONO'
//	idsWODetail.SetTransobject(sqlca)
//End If
If Not isvalid(idsWOPutaway) Then
	idsWOPutaway = Create Datastore
	idsWOPutaway.Dataobject = 'd_workorder_putaway'
	idsWOPutaway.SetTransobject(sqlca)
End If

idsOut.Reset()

lsLogOut = "      Creating Workorder Adjustments For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsWOMain.Retrieve(asProject,asWONO) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsWOPutaway.Retrieve(asWONO)

llRowCount = idsWOPutaway.RowCount()

lbSendTrans = False

lsOrderNo = idsWOMain.GetITemString(1,'Workorder_number')
//Strip out line number from supplier invoice.  Put in to insure unique order number.
llstringlength = len(lsOrderNo)

DO UNTIL lsdash = '-' or llstringlength = 2   
	llstringlength = llstringlength - 1
	lsdash = mid(lsorderNo,llstringlength,1)
LOOP
llstringlength = llstringlength - 1

lssuppinvoice = left(lsOrderNo,llstringlength)

//lssuppinvoice = left(lsOrderNo,pos(lsOrderNo,'-')-1)

lsWarehouse = Upper(idsWOMain.GetITemString(1,'wh_code'))
lsCompleteDate = string(idsWOMain.GetITemDateTime(1,'Complete_Date'),'yyyymmdd')
lsOrdType = idsWOMain.GetITemString(1,'User_Field3')
lladjustid = (aitransid * 10) + 1
If lsordType <> 'W2' Then
		lsLogOut = "        *** Order Type does not get a RE File sent for User_Field 3 type : " + lsOrdType 
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End if


For llRowPos = 1 to lLRowCount /* For each Putaway Row */

	idsOut.Reset()

// Pass all non finished goods in Component Return

	//If idsWOPutaway.GetITemString(llRowPos,'Inventory_Type') <> 'N' Then
	If idsWOPutaway.GetITemString(llRowPos,'user_field1') = 'R' Then /* 08/04/04 - PCONKL - Based on UF1 = 'R' (Return to Inventory) */
	

		//lsLineItemNo = string(idsWOPutaway.GetITemNumber(llRowPos,'Line_Item_no'))
		lsSKU = idsWOPutaway.GetITemString(llRowPos,'SKU')
		llqty = llqty + idsWOPutaway.GetITemNumber(llRowPos,'Quantity')

// Only Send if Short	
//	If idsWODetail.GetITemNumber(llRowPos,'Req_qty') > idsWODetail.GetITemNumber(llRowPos,'Alloc_Qty')	Then

//		lsQty = String(((idsWODetail.GetITemNumber(llRowPos,'Req_qty'))-(idsWODetail.GetITemNumber(llRowPos,'Alloc_Qty'))),'000000000.00000')
		lsUOM = 'EA  '
		lsInvType = idsWOPutaway.GetITemString(llRowPos,'Inventory_Type')
		SELECT Code_Descript  
 	  INTO :lsInvTypeDescript  
	   FROM Lookup_Table  
	   WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;
	End If
Next /*Putaway*/	

If llqty > 0 Then

	lsqty = string(llqty,'000000000.00000')
	
	//We are sending 'WA' records When Workorder is Confirmed
	//we want each record in a seperate file (each batch seq break causes a new file)
			//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If

	

	// Use the numeric part of wono for Adjustment ID
	//	lsadjustmentid = mid(asWONO,pos(asWONO,'0'),18)
	//
		lsadjustmentind = '+'
		
		lsOutString = 'IA' /*rec type = Material Movement*/
		lsOutString += lsWarehouse + Space(10 - Len(lsWarehouse))
		lsOutString += asProject  + Space(10 - Len(asProject))
		lsOutString += lsOrdType + Space(2 - Len(lsOrdType))
		lsOutString += string(lladjustid)  + Space(18 - Len(String(lladjustid)))
		lsOutString += lssuppinvoice  + Space(30 - Len(lssuppinvoice))
		lsOutString += lsCompletedate  + Space(8 - Len(lsCompletedate))
		lsOutString += lsLineItemNo + space(25 - Len(lsLineItemNo)) 
		lsOutString += lsSku + Space(50 - len(lsSKU))
		lsOutString += lsqty + Space(15 - len(lsqty))
		lsOutString += lsUOM
	 	lsOutString += lsInvTypeDescript + Space(2 - Len(lsInvTypeDescript))
		lsOutString += lsadjustmentind 
//		lsOutString += 'Not Applicable                '
		lsOutString += '                              '
		lsOutString += 'WA'

		llNewRow = idsOut.insertRow(0)
	
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
		//File name is AW + Counter 
		lsfilename = 'AW' + string(ldbatchseq,"0000000000") + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
		//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
		gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	End If

Return 0


end function

public function integer uf_wo_components_issue (string asproject, string aswono, long aitransid);// TAM 07/04

Long	llrowPos, llRowCount, llNewRow, llstringlength, lladjustid, llFindRow, lLineItemNo
Decimal	ldBatchSeq, ldQty
String	lsOutString, lsSKU, lsInvType, lsOrderNo, &
			lsMessage, &
			lsWarehouse,&
			lsLogOut
String	lsSuppInvoice, lsCompleteDate, lsOrdType, lsOrdTypeDescript, &
			lsUF2, lsSuppCode, lsSuppName, lsSkuDescript, lsQty, lsLineItemNo, &
			lsInvTypeDescript, lsUOM, lsFileName, lsadjustmentind, lsadjustmentid, lsdash, lsFind

Integer	liRC
Boolean	lbSendTrans


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsWOMain) Then
	idsWOMain = Create Datastore
	idsWOMain.Dataobject = 'd_workorder_master'
	idsWOMain.SetTransobject(sqlca)
End If

//If Not isvalid(idsWODetail) Then
//	idsWODetail = Create Datastore
//	idsWODetail.Dataobject = 'd_workorder_detail_WONO'
//	idsWODetail.SetTransobject(sqlca)
//End If

If Not isvalid(idsWOPick) Then
	idsWOPick = Create Datastore
	idsWOPick.Dataobject = 'd_workorder_picking'
	idsWOPick.SetTransobject(sqlca)
End If

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_gr_layout'
End If

idsOut.Reset()
idsgr.Reset()

lsLogOut = "      Creating Workorder Component Issue (Pick) For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Picking records for this order
If idsWOMain.Retrieve(asProject, asWONO) <> 1 Then
	lsLogOut = "        *** Unable to retreive Work Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//idsWODetail.Retrieve(asWONO)
idsWOPick.Retrieve(asWONO)

//llRowCount = idsWODetail.RowCount()
llRowCount = idsWOPick.RowCount()

lbSendTrans = False

lsOrderNo = idsWOMain.GetITemString(1,'Workorder_number')
//Strip out line number from supplier invoice.  Put in to insure unique order number.
llstringlength = len(lsOrderNo)

DO UNTIL lsdash = '-' or llstringlength = 2   
	llstringlength = llstringlength - 1
	lsdash = mid(lsorderNo,llstringlength,1)
LOOP
llstringlength = llstringlength - 1

lssuppinvoice = left(lsOrderNo,llstringlength)

//lssuppinvoice = left(lsOrderNo,pos(lsOrderNo,'-')-1)

lsWarehouse = Upper(idsWOMain.GetITemString(1,'wh_code'))
lsCompleteDate = string(idsWOMain.GetITemDateTime(1,'Complete_Date'),'yyyymmdd')
lsOrdType = idsWOMain.GetITemString(1,'User_Field3')
lladjustid = (aitransid * 10) 

If isnull(lsOrdType) Then lsOrdType = ''
If lsordType <> 'W2' Then
		lsLogOut = "        *** Order Type does not get a RE File sent for User_Field 3 type : " + lsOrdType 
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
End if

// FOr each pick row, roll up to Line/Sku/Inv Type Level
For llRowPos = 1 to llRowCount
	
	lLineItemNo = idsWOPick.GetITemNumber(llRowPos,'Line_Item_no')
	lsSKU = idsWOPick.GetITemString(llRowPos,'SKU')
	ldQty = idsWOPick.GetITemNumber(llRowPos,'quantity')
	lsInvType = idsWOPick.GetITemString(llRowPos,'Inventory_Type')
	
	lsFind = "po_item_number = " + String(lLineItemNo) + " and Upper(SKU) = '" + Upper(lsSKU) + "' and Upper(Inventory_Type) = '" + Upper(lsInvType) + "'"
	llFindRow = idsgr.Find(lsFind,1,idsgr.RowCOunt())
	
	If llFindRow > 0 Then
		
		idsgr.SetItem(llFindRow,'quantity', (idsgr.GetItemNumber(llFindRow,'quantity') + ldQty))
		
	Else /* insert a new row*/
		
		llNewRow = idsgr.InsertRow(0)
		idsgr.SetItem(llNewRow,'Inventory_type',lsInvType)
		idsgr.SetItem(llNewRow,'sku',lsSKU)
		idsgr.SetItem(llNewRow,'quantity',ldQty)
		idsgr.SetItem(llNewRow,'po_item_number',lLineItemNo)
		
	End If
	
NExt /*Picking Row*/

// write out summarized pick rows (summarized to line/sku/inv type above)
llRowCOunt = idsgr.RowCount()
For llRowPos = 1 to lLRowCount /* For each summarized Pick Row */
	
	lsLineItemNo = string(idsgr.GetITemNumber(llRowPos,'po_item_number'))
	lsSKU = idsGR.GetITemString(llRowPos,'SKU')
	lsQty = String(idsGR.GetITemNumber(llRowPos,'quantity'),'000000000.00000')
		
	lsUOM = 'EA  '
	lsInvType = idsGR.GetITemString(llRowPos,'Inventory_Type')
	
	SELECT Code_Descript  
   INTO :lsInvTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;
	
	If isnull(lsInvTypeDescript) Then lsInvTypeDescript = ''

//We are sending 'WX' records When Picking is Completed
//we want each record in a seperate file (each batch seq break causes a new file)
		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

//	// Use the numeric part of wono for Adjustment ID
//	lsadjustmentid = mid(asWONO,pos(asWONO,'0'),18)
//
	lsadjustmentind = '-'
		
	lsOutString = 'IA' /*rec type = Material Movement*/
	lsOutString += lsWarehouse + Space(10 - Len(lsWarehouse))
	lsOutString += asProject  + Space(10 - Len(asProject))
	lsOutString += lsOrdType + Space(2 - Len(lsOrdType))
	lsOutString += string(lladjustid)  + Space(18 - Len(String(lladjustid)))
	lsOutString += lssuppinvoice  + Space(30 - Len(lssuppinvoice))
	lsOutString += lsCompletedate  + Space(8 - Len(lsCompletedate))
	lsOutString += lsLineItemNo + space(25 - Len(lsLineItemNo)) 
	lsOutString += lsSku + Space(50 - len(lsSKU))
	lsOutString += lsqty + Space(15 - len(lsqty))
	lsOutString += lsUOM
 	lsOutString += lsInvTypeDescript + Space(2 - Len(lsInvTypeDescript))
	lsOutString += lsadjustmentind 
//	lsOutString += 'Not Applicable                '
	lsOutString += '                              '
	lsOutString += 'WX'

	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	//File name is AW + Counter 
	lsfilename = 'AW' + string(ldbatchseq,"0000000000") + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*summarized Pick*/

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)

Return 0


end function

public function integer uf_workorder_receipt (string asproject, string aswono, long altransid);//TAM 07/04

Long	llrowPos, llRowCount, llNewRow, llstringlength, llline_seq_no, llqty
 
Decimal	ldBatchSeq 
String	lsOutString, lsSKU, lsInvType, lsOrderNo, &
			lsMessage, &
			lsWarehouse,&
			lsLogOut
String	lsSuppInvoice, lsCompleteDate, lsOrdType, &
			lsUF2, lsSuppCode, lsSuppName, lsSkuDescript, lsQty, lsLineItemNo, &
			lsInvTypeDescript, lsUOM, lsFileName, lsdash, lsparm, lsConfirmType, lsID

			
Integer	liRC
Boolean	lbSendTrans


If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsWOMain) Then
	idsWOMain = Create Datastore
	idsWOMain.Dataobject = 'd_workorder_master'
	idsWOMain.SetTransobject(sqlca)
End If

//If Not isvalid(idsWODetail) Then
//	idsWODetail = Create Datastore
//	idsWODetail.Dataobject = 'd_workorder_detail_WONO'
//	idsWODetail.SetTransobject(sqlca)
//End If

idsOut.Reset()

lsLogOut = "      Creating RE For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsWOMain.Retrieve(asProject,asWONO) <> 1 Then
	lsLogOut = "        *** Unable to retreive Receive Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//idsWODetail.Retrieve(asWONO)

//llRowCount = idsWODetail.RowCount()

lbSendTrans = False

lsOrderNo = idsWOMain.GetITemString(1,'Workorder_number')
//Strip out line number from supplier invoice.  Put in to insure unique order number.
llstringlength = len(lsOrderNo)

DO UNTIL lsdash = '-' or llstringlength = 2   
	llstringlength = llstringlength - 1
	lsdash = mid(lsorderNo,llstringlength,1)
LOOP
llstringlength = llstringlength - 1

lssuppinvoice = left(lsOrderNo,llstringlength)

//lssuppinvoice = left(lsOrderNo,pos(lsOrderNo,'-')-1)

lsWarehouse = Upper(idsWOMain.GetITemString(1,'wh_code'))
//lsCompleteDate = string(idsWOMain.GetITemDateTime(1,'Complete_Date'),'yyyymmdd')
lsCompleteDate = String(Today(),'YYYYMMDD')

lsOrdType = idsWOMain.GetITemString(1,'User_Field3')

If lsordType <> 'W1' and lsordType <> 'W2' and lsordType <> 'W3' Then
	lsLogOut = "        *** Order Type does not get a RE File sent for Order type : " + lsOrdType 
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End if


//Need to get this still
lsSuppCode = idsWOMain.GetITemString(1,'User_Field1')
lsUF2 = idsWOMain.GetITemString(1,'User_Field2')

SELECT Supp_Name  
INTO :lsSuppName 
FROM Supplier  
WHERE Project_Id = :AsProject AND Supp_Code = :lsSuppCode ;

Select trans_parm Into :lsparm
From Batch_transaction
Where trans_ID = :altransid ;

If Not IsNull(lsparm) then
	llline_seq_no = long(trim(lsparm))
Else
	lsLogOut = "        *** Sequence Number Parm was not valid in Batch Transaction for Workorder Putaway: " + string(alTransID) 
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If
	
Select line_item_no, quantity, inventory_type, SKU, User_Field1 
Into :lslineItemNo, :llqty, :lsInvType, :lsSku, :lsConfirmType
From workorder_putaway
where WO_NO = :asWONO and sub_line_item_no = :llline_seq_no ;


// TAM  08/04 remove filter of what transactions get sent
//IF lsinvtype = 'N' or lsinvtype = 'Q' Then
If lsConfirmType = 'C' Then /* 08/04/04 - PCONKL - Based on UF1 = 'C' (Complete) */
	

	lsQty = String(llQty,"000000000.00000;-00000000.00000")


	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	//we want each record in a seperate file (each batch seq break causes a new file)
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Batch Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	// 08/04 - PCONKL - Need unique # for Receipt #, wo_no is not unique (may have same ro_no/do_no)
	// 09/04 - TAM - Need unique # for Receipt #, wo_no + Parm is unique (may multiple Receipts on WONO)
	lsID = 'WO' + Right(Trim(asWoNo),6) + '-' + Trim(lsparm)
	
	lsOutString = 'RM'
	lsOutString += lsWarehouse + space(10 - len(lsWarehouse))
	lsOutString += asProject  + Space(10 - Len(asProject))
	lsOutString += lssuppinvoice  + Space(30 - Len(lssuppinvoice))
//	lsOutString += asWONO  + Space(16 - Len(asWONO))
	lsOutString += lsID  + Space(16 - Len(lsID)) /*see above*/
	lsOutString += lsCompleteDate
	lsOutString += lsOrdType + Space(2 - Len(lsOrdType))
	lsOutString += lsSuppCode + space(20 - len(lsSuppCode))
	lsOutString += lsUF2 + space(30 - len(lsUF2))
	lsOutString += lsSuppName + space(40 - len(lsSuppName))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	//File name is RE + Counter 
	lsfilename = 'RE' + string(ldbatchseq,"0000000000") + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


//For llRowPos = 1 to lLRowCount /* For each Putaway Row */

//	lsLineItemNo = string(idsWODetail.GetITemNumber(llRowPos,'Line_Item_no'))
//	lsSKU = idsWODetail.GetITemString(llRowPos,'SKU')

	SELECT Description  
   INTO :lsSkuDescript  
   FROM Item_Master  
   WHERE SKU = :lsSku   ;


	lsUOM = 'EA  '

//	lsQty = String(idsWODetail.GetITemNumber(llRowPos,'Req_qty'),"000000000.00000;-00000000.00000")
//	lsInvType = idsWODetail.GetITemString(llRowPos,'User_Field1')

	SELECT Code_Descript  
   INTO :lsInvTypeDescript  
   FROM Lookup_Table  
   WHERE Code_Type = 'SI' AND Code_ID = :lsInvType ;


	lsOutString = 'RD'
	lsOutString += lsLineItemNo + space(25 - len(lsLineItemNo))
	lsOutString += LsSku  + Space(50 - Len(LsSku))
	lsOutString += lsQty 
	lsOutString += lsUOM
	lsOutString += lsInvTypeDescript + Space(2 - Len(lsInvTypeDescript))
	lsOutString += lsSkuDescript + space(70 - len(lsSkuDescript))
	
	llNewRow = idsOut.insertRow(0)
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	//Next /*Detail*/

	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
End if /* putaway type = 'C' (Complete) */

Return 0


end function

on u_nvo_edi_confirmations_logitech.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_logitech.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

