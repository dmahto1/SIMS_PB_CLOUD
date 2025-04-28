$PBExportHeader$u_nvo_edi_confirmations_hillman.sru
$PBExportComments$Process outbound edi confirmation transactions for K&N Filters
forward
global type u_nvo_edi_confirmations_hillman from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_hillman from nonvisualobject
end type
global u_nvo_edi_confirmations_hillman u_nvo_edi_confirmations_hillman

type variables

Datastore	idsDOMain, idsDODetail, idsDOPack, idsOut, idsGR
//idsDOPick, 
				//idsROMain, idsRODetail, idsROPutaway, 
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Hillman for the order that was just confirmed
//(taken from client's EDI.pbl)
//Datastore	ldsOut

Long			llRowPos, llRowCount, llNewRow, llLineItemNo,	llBatchSeq, llDetailRow
//llDetailRow,	
				
String		lsFind,lsOutString,lsOutString2, lsMessage, lsSku, lsSupplier, lsInvoice,	lsTemp, lsCarrier, lsCurrencyCode, lsShipTo,	&
				lsShipFrom, lsCustCode, lsCustSKU, lsUCCSCode, lsFolder

Decimal		ldBatchSeq, ldGrossWeight, ldnetWeight, ldTemp,ldFreight, ldTotalAmount, ldPrice, ldQTY, ldtax, ldOther
Integer		liRC

String	lsLogOut
long llAllocQty

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

//If Not isvalid(idsGR) Then
//	idsGR = Create Datastore
//	idsGR.Dataobject = 'd_gr_layout'
//End If

If Not isvalid(idsDOMain) Then
	idsDOMain = Create Datastore
	idsDOMain.Dataobject = 'd_do_master'
	idsDOMain.SetTransObject(SQLCA)
End If

//If Not isvalid(idsDoPick) Then
//	idsDoPick = Create Datastore
//	idsDoPick.Dataobject = 'd_do_Picking'
//	idsDoPick.SetTransObject(SQLCA)
//End If

If Not isvalid(idsDOPack) Then
	idsDOPack = Create Datastore
	idsDOPack.Dataobject = 'd_do_Packing'
	idsDOPack.SetTransObject(SQLCA)
End If

If Not isvalid(idsDODetail) Then
	idsDODetail = Create Datastore
	idsDODetail.Dataobject = 'd_do_detail'
	idsDODetail.SetTransObject(SQLCA)
End If

idsOut.Reset()
//idsGR.Reset()

//Retreive Delivery Master, Detail Picking and Packing records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoDetail.Retrieve(asDoNo) /*detail Records*/
//idsDoPick.Retrieve(asDoNo) /*Pick Records */
idsDoPack.Retrieve(asDoNo) /*Pack Records */

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Phoenix!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Build and Write the Header
lsOutString = 'GI' 																					//record type

// 6/11/04 (dts) lsOutString += asdono + space(16 - len(lsTemp))		
// 10/09 - PCONKL - Instread of DO_NO, send Cust Order No + space + Folio Number (UF10)
//lsOutString += asDoNo + space(16 - len(asDoNo))

// Cust Order Number (11) + " " + Folio (4)

lsTemp = ''
If Not isnull( idsDOMain.GetITemString(1,'cust_order_no')) Then
	lsTemp = Left(idsDOMain.GetITemString(1,'cust_order_no'),11) 
End If

lsOutString +=   lsTemp + space(11 - len(lsTemp)) + " " /* Cust Order + blank*/

//If no Folio, take last 4 of DONO
If Not isnull( idsDOMain.GetITemString(1,'User_Field10')) and idsDOMain.GetITemString(1,'User_Field10') > ''  Then
	lsTemp = Left(idsDOMain.GetITemString(1,'User_Field10'),4) 
Else
	lsTEmp = Right(asDono,4)
End If

lsOutString += lsTemp + space(4 - len(lsTemp)) /*Folio # */


lsOutString += "HILLMAN   " 																		//Poject_ID

lsTemp = idsDOMain.GetITemString(1,'ord_type')
lsOutString += lsTemp + space(4 - len(lsTemp))	 											//order type 

lsOutString += String(idsDOMain.GetITemDateTime(1,'ord_date'),'yyyymmdd')			//order date

//lsOutString += String(idsDOMain.GetITemDateTime(1,'complete_date')	,'yyyymmdd')	//complete date
lsOutString += String(today()	,'yyyymmdd')	// 07/09 - PCONKL -Current Date, we are now sending GI at Ready to Ship so complete Date is empty

lsTemp = idsDOMain.GetITemString(1,'wh_code')
lsOutString += lsTemp + space(10 - len(lsTemp))	 											//warehouse

lsTemp = idsDOMain.GetITemString(1,'invoice_no')
lsOutString += lsTemp + space(20 - len(lsTemp))	 											//Order Number (Invoice_No)

If not isnull(idsDOMain.GetITemString(1,'cust_code')) Then
	lsTemp = idsDOMain.GetITemString(1,'cust_code')
	lsOutString += lsTemp + space(20 - len(lsTemp))	 										//cust code
Else
	lsOutString += space(20)
end if

If not isnull(idsDOMain.GetITemString(1,'cust_name')) then 								//cust name
	lsTemp = idsDOMain.GetITemString(1,'cust_name')
	lsOutString +=  lsTemp + space(40 - len(lsTemp))	
else
	lsOutString += space(40)
end if
										
If not isnull(idsDOMain.GetITemString(1,'user_Field4')) Then								//HILLMAN INVOICE #
	lsTemp = idsDOMain.GetITemString(1,'user_field4')
	lsOutString +=  space(20 - len(lsTemp)) + lsTemp
else
	//lsOutString +=  space(20 - len(lsTemp)) + lsTemp 
	lsOutString += space(20)
End If

If not isnull(idsDOMain.GetITemString(1,'carrier')) Then									//carrier
	lsTemp = idsDOMain.GetITemString(1,'carrier')
	lsOutString +=  lsTemp + space(20 - len(lsTemp))	
else
	lsOutString += space(20) 
End If

If not isnull(idsDOMain.GetITemString(1,'freight_terms')) Then							//Freight Terms
	lsTemp = idsDOMain.GetITemString(1,'freight_terms')
	lsOutString += lsTemp + space(20 - len(lsTemp))	
else
	lsOutString += space(20) 
End If

If not isnull(idsDOMain.GetITemNumber(1,'freight_cost')) Then 							// Freight Costs
	ldFreight = idsDOMain.GetITemNumber(1,'freight_cost') 									// 3 implied decimals
else
	ldFreight = 0
End If
ldTemp = ldFreight * 1000	
lsOutString += string(ldTemp, "0000000000") 

If not isnull(idsDOMain.GetITemNumber(1,'ctn_cnt')) Then									// Carton Count
	ldTemp = idsDOMain.GetITemNumber(1,'ctn_cnt')
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'0000000')

//Total Shipment Weight - Sum gross weight and net weights from Packing 
ldGrossWeight = 0
ldNetWeight = 0
llRowCOunt = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	ldGrossWEight += idsDOPack.GetITemNumber(llRowPos,'weight_Gross')
	ldnetWEight += idsDOPack.GetITemNumber(llRowPos,'weight_net')
Next
If not isnull(ldGrossWEight) Then																//Total Shipment Weight
	ldTemp = ldGrossWEight * 100000																// 5 implied decimals
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'000000000000')

// ********************************************************** put this data in data_batch_2	

If not isnull(idsDOMain.GetITemString(1,'awb_bol_no')) Then								//AWB/BOL
	lsTemp = idsDOMain.GetITemString(1,'awb_bol_no') 
else
	lsTemp = "No AWB/BOL found"
end If
if lsTemp = "" then lsTemp = "No AWB/BOL found"
lsOutString2 = lsTemp + space(20 - len(lsTemp)) 

If not isnull(idsDOMain.GetITemString(1,'user_field2')) Then								//TAX (IVA)		
	ldTax = dec(idsDOMain.GetITemString(1,'user_field2')) 								//2 implied decimals
Else
	ldTax = 0
End If
ldTemp = ldTax * 100
lsOutString2 += string(ldTemp, "0000000000") 	


If not isnull(idsDOMain.GetITemString(1,'user_field3')) Then								//Other Charges						 
	ldOther = dec(idsDOMain.GetITemString(1,'user_field3')) 							//2 implied decimals
Else
	ldOther = 0
End If
ldTemp = ldOther * 100
lsOutString2 += string(ldTemp, "0000000000") 	

//Calculated totals using detail rows
llRowCOunt = idsDODetail.RowCount()
ldTemp = 0 
ldPrice = 0
ldQTY = 0
For llRowPos = 1 to llRowCount
	If not isnull(idsDODetail.GetITemNumber(llRowPos,'price')) then ldPrice = idsDODetail.GetITemNumber(llRowPos,'price')
	If not isnull(idsDODetail.GetITemNumber(llRowPos,'alloc_Qty')) then ldQTY = idsDODetail.GetITemNumber(llRowPos,'alloc_Qty')
	 ldTemp += round((ldPrice * ldQTY),2) // calculate price * qty round rounded to 2 decimals
next

//Calculate Total $ Amount
ldTemp += ldFreight + ldTax + ldOther
ldTemp = ldTemp * 100 
lsOutString2 += string(ldTemp, "000000000000000") 											//Total $ Amount with 2 implied decimals
lsOutString2 += string(llRowCOunt, "000000") 													//Total Lines with 0 decimals

// 07/09 - PCONKL - Freight ETA
If NOt isnull(idsDOMain.GetITemDateTime(1,'freight_ETA')) Then
	lsOutString2 += String(idsDOMain.GetITemDateTime(1,'freight_ETA'),'yyyymmdd')			//Freight ETA
Else
	lsOutString2 += String(today(),'yyyymmdd')
End If

// 08/09 - PCONKL - Freight ETD
If NOt isnull(idsDOMain.GetITemDateTime(1,'freight_ETD')) Then
	lsOutString2 += String(idsDOMain.GetITemDateTime(1,'freight_ETD'),'yyyymmdd')			//Freight ETD
Else
	lsOutString2 += String(today(),'yyyymmdd')
End If


//write to DB for sweeper to pick up
llNewRow = idsOut.insertRow(0)
idsOut.SetItem(llNewRow,'Project_id','HILLMAN') /* hardcoded to match entry in .ini file for file destination*/
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString) 
idsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)


// *********************************    For each detail row, write a detail - 1 record per PACKING list row.
//dts - Now scrolling through Detail where alloc_qty > 0
// 07/09 - PCONKL - switching back to looping through Packing (with a link to Detail) since we need Carton ID and Box Count from Packing

llRowCOunt = idsDOPack.RowCount()
//llRowCOunt = idsDODetail.RowCount()

For llRowPos = 1 to llRowCount /*Each PAck Row*/
	
//	llAllocQty =	idsDODetail.GetITemNumber(llRowPos,'Alloc_Qty')

	//if llAllocQty > 0 then
		
		//Some fields will need to come from Detail Record
		//dts 'Some'? I think all come from detail...
		
		llLineItemNo = idsDOPack.GetITemNumber(llRowPos,'line_item_no')
		//llLineItemNo = idsDODetail.GetITemNumber(llRowPos,'line_item_no')
		
		lsFind = "Line_Item_No = " + String(llLineItemNo)
		llDetailRow = idsDODetail.Find(lsFind,1,idsDODetail.RowCount())
		
		//we should always have a detail row for this line item
		If llDetailRow <= 0 Then 
			//lsMessage= "Unable to create a Goods Issue Confirmation for Line Item: " + string(llLineItemNo) + "does not have a matching Detail Line Item!"
			//xMessageBox('Goods Issue Confirmation', lsMessage )
			lsLogOut = "        *** Unable to create a Goods Issue Confirmation for Line Item: " + string(llLineItemNo) + "does not have a matching Detail Line Item!"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		end if
			
		llNewRow = idsOut.insertRow(0)
		lsOutString = 'GD' 																						//Detail ID
		
		//lsTemp =  adw_main.GetITemString(1,'do_no')   													//DO NO
		lsTemp =  asdono			   																			//DO NO
		lsOutString +=  lsTemp + space(16 - len(lsTemp))
		
		lsTemp = idsDOPack.GetITemString(llRowPos,'SKU')											//SKU 
		lsOutString +=  lsTemp + space(50 - len(lsTemp))
		
		lsTemp = idsDOPack.GetITemString(llRowPos,'Supp_Code')									//Supp_Code 
		lsOutString +=  lsTemp + space(20 - len(lsTemp))
	
		If not isnull(idsDODetail.GetITemNumber(llDetailRow,'Req_Qty')) Then						//Requested QTY 
			ldTemp =idsDODetail.GetITemNumber(llDetailRow,'Req_Qty') * 100000						// 5 implied decimals
		Else
			ldTemp = 0
		End If
		lsOutString += string(ldTemp,"000000000000000") 	
		
//		If not isnull(idsDODetail.GetITemNumber(llDetailRow,'alloc_Qty')) Then					//alloc_Qty 
//			ldTemp = idsDODetail.GetITemNumber(llDetailRow,'alloc_Qty') * 100000					// 5 implied decimals
//		Else
//			ldTemp = 0
//		End If
		
		If not isnull(idsDOPAck.GetITemNumber(llRowPos,'quantity')) Then					//Qty in Carton
			ldTemp = idsDOPAck.GetITemNumber(llRowPos,'quantity') * 100000					// 5 implied decimals
		Else
			ldTemp = 0
		End If
		
		lsOutString += string(ldTemp,"000000000000000") 
		
		If not isnull(idsDODetail.GetITemString(llDetailRow,'uom')) Then							//UOM 
			lsTemp = idsDODetail.GetITemString(llDetailRow,'uom')
			lsOutString +=  lsTemp + space(4 - len(lsTemp))
		Else
			lsOutString += space(4)
		End If
		
		If not isnull(idsDODetail.GetITemNumber(llDetailRow,'price')) Then							//Unit Price 
			ldTemp = idsDODetail.GetITemNumber(llDetailRow,'price') * 10000							// 4 implied decimals
		Else
			ldTemp = 0
		End If
		lsOutString += string(ldTemp,"000000000000") 													
		
		If not isnull(idsDOPAck.GetITemNumber(llRowPos,'Line_Item_NO')) Then				//Line_Item_NO
			ldTemp = idsDOPAck.GetITemNumber(llRowPos,'Line_Item_NO')
		Else
			ldTemp = 0
		End If
		lsOutString += string(ldTemp,"000000") 	
		
		lsTemp = idsDOMain.GetITemString(1,'cust_code')													//cust code
		lsOutString +=  lsTemp + space(20 - len(lsTemp))
		
		lsTemp = idsDOMain.GetITemString(1,'invoice_no')													//Order Number (Invoice_No)
		lsOutString +=  lsTemp + space(20 - len(lsTemp))
		
		If not isnull(idsDODetail.GetITemString(llDetailRow,'user_Field4')) Then									//HILLMAN INVOICE #
			lsTemp = idsDODetail.GetITemString(llDetailRow,'user_field4')
			lsOutString +=  space(20 - len(lsTemp)) + lsTemp
		else
			lsOutString += space(20)  
		End If
		
		//07/09 - PCONKL - Adding Carton_no and Box Count (UF1)
		
		If Not isnull(idsDOMain.GetITemString(1,'User_field7')) Then
			lsTemp =   idsDOMain.GetITemString(1,'User_field7') +String(long( idsDOPack.GetITemString(llRowPos,'carton_no')),'00')											//PAllet ID = ASN Number header UF7) + 2 digit Carton Number
			lsOutString +=  lsTemp + space(12 - len(lsTemp))
		Else
			lsOutString += space(12)
		End If
		
		If not isnull(idsDOPack.GetITemString(llRowPos,'user_Field1')) Then									//Box Count
			lsTemp = idsDOPack.GetITemString(llRowPos,'user_field1')
			lsOutString +=  String(long(lsTemp),'00000')
		else
			lsOutString +="00000" 
		End If
		
		//write to DB for sweeper to pick up
		idsOut.SetItem(llNewRow,'Project_id','HILLMAN') /* hardcoded to match entry in .ini file for file destination*/
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
 // end if	
  
Next /* Next PAck record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DS
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'HILLMAN')

Return 0
end function

on u_nvo_edi_confirmations_hillman.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_hillman.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

