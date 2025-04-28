$PBExportHeader$u_nvo_edi_confirmations_garmin.sru
$PBExportComments$Process outbound edi confirmation transactions for Warner
forward
global type u_nvo_edi_confirmations_garmin from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_garmin from nonvisualobject
end type
global u_nvo_edi_confirmations_garmin u_nvo_edi_confirmations_garmin

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR,  idsDOMainSC, idsDODetailSC, idsDOPickSC, idsDOPackSC
				
Datastore idsAdjustment

String lsDelimitChar
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_rt (string asproject, string asrono)
public function string getwarnerinvtype (string asinvtype)
public function integer uf_pod (string asproject, string asdono)
public function integer uf_adjustment (string asproject, long aladjustid, long altransid)
public function integer uf_sc (string asproject, string asdono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Jxlim 05/15/2014 Garmin
//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed
Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
String			lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  		lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo
DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound
Long llDetailFind, llPackFind, llPickFind

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

//TAM 04/2016 GI's are not sent for Shipments(Consolidation Number present).
IF idsDOMain.getitemstring(1,'Consolidation_No') <>'' and Not isNull(idsDOMain.getitemstring(1,'Consolidation_No'))  THEN
	lsLogOut = "        *** This order is part of a Garmin Shipment.  Goods Issues are not sent for Shipments~rConfirmation will not be sent to Garmin!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return 99
End If


For llRowPos = 1 to idsDoDetail.RowCount()	
	llLineItemNo =  idsDoDetail.getitemnumber(llRowPos,'line_item_no')
	llPickFind = idsDoPick.Find( "Line_item_no = " + string(llLIneItemNo), 1, idsDoPick.RowCount())
	If llPickFind > 0 Then	
		Continue		
	Else		
		llNewRow = idsDoPick.InsertRow(0)

		idsDoPick.SetItem( llNewRow, "do_no", asdono)	
		idsDoPick.SetItem( llNewRow, "sku", idsdoDetail.GetItemString(llRowPos,'sku'))
		idsDoPick.SetItem( llNewRow, "supp_code", idsdoDetail.GetItemString(llRowPos,'supp_code'))
		idsDoPick.SetItem( llNewRow, "Line_item_no", llLineItemNo)
		idsDoPick.SetItem( llNewRow, "lot_no", idsdoDetail.GetItemString(llRowPos,'User_Field5'))

		//Need to add for Sorting.
		idsDoPick.SetItem( llNewRow, "Component_No", 0)
		idsDoPick.SetItem( llNewRow, "Component_Ind", 'N')
		idsDoPick.SetItem( llNewRow, "SKU_Parent", idsdoDetail.GetItemString(llRowPos,'sku'))
	
		idsDoPick.SetItem( llNewRow, "quantity", 0)
	End If	
Next

idsDoPick.Sort()

//Write the rows to the generic output table - delimited by lsDelimitChar  //Jxlim specified at the contructor event

llRowCount = idsDoPick.RowCount()
For llRowPos = 1 to llRowCOunt
	llNewRow = idsOut.insertRow(0)

	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())

	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue		
	End If

	llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())

	//1Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“GI”	Goods issue confirmation identifier
	lsOutString = 'GI' + lsDelimitChar
	
	//2Project ID	C(10)	Yes	N/A	Project identifier	
	lsOutString +=  asproject + lsDelimitChar
	
	//3Warehouse	C(10)	Yes		Shipping Warehouse	
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
	//4Delivery Number	C(10)	Yes	N/A	Delivery Order Number
//	lsTemp =   idsdoDetail.GetItemString(llDetailFind,'user_field1')	
//	If IsNull(lsTemp) then lsTemp = ''	
//	lsOutString +=  lsTemp + lsDelimitChar	
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	

	//5Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number	
	lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar

	//lsOutString += String(idsdoDetail.GetITemString(llDetailFind, 'user_field6')) + lsDelimitChar
	
	//6SKU	C(50)	Yes	N/A	Material number
	lsOutString +=lsSku  + lsDelimitChar		
	
	//7Quantity	N(15,5)	Yes	N/A	Actual shipped quantity	
	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
	//8Inventory Type	C(1)	Yes	N/A	Item condition	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Inventory_Type')	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp + lsDelimitChar
	
	//9Lot Number	C(50)	No	N/A	1st User Defined Inventory field	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Lot_No')	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//10PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
	//11PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	lsTemp = idsdoPick.GetITemString(llRowPos,'PO_No2')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
	//12Serial Number	C(50)	No	N/A	Qty must be 1 if present
	lsTemp = idsdoPick.GetITemString(llRowPos,'Serial_No')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
	//13Container ID	C(25)	No	N/A	
	If llPackFind > 0 then 
		lsTemp = idsDoPack.GetItemString(llPackFind,'carton_no')
	End if
	lsOutString += lsTemp + lsDelimitChar
	
//	//lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')	
//	If IsNull(lsTemp) then lsTemp = ''
//	lsTemp =  mid(idsDoMain.GetItemString(1,'Invoice_no'), 4) + trim(lsTemp)
//	If  lsTemp <> '-' Then
//		lsOutString += lsTemp + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	
	
	//14Expiration Date	Date	No	N/A	
	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//15Price	N(12,4)	No	N/A		
	lsTemp = String(idsdoPick.GetItemDecimal(llDetailFind, "Price"))	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//16Ship Date	Date	No	N/A	Actual Ship date
	lsTemp = String( idsDoMain.GetItemDateTime(1,"schedule_date"),'yyyy-mm-dd') 	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar
	
	//17Package Count	N(5,0)	No	N/A	Total no. of package in delivery
	lsTemp = String(1)  		
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//18Ship Tracking Number	C(25)	No	N/A Garmin will manually enter Shipper tracking Number onto awb_bol_no on other info tab and Sims will send back this value vis GI(945)	05/29/2014
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//19Carrier	C (20)	No	N/A	Input by user	
	If idsDoMain.GetItemString(1,'Carrier') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		
	//20Freight Cost	N(10,3)	No	N/A		
	lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'))
	IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""	
	lsOutString += lsFreight_Cost + lsDelimitChar		
	
	//21Freight Terms	C(20)	No	N/A		
	If idsDoMain.GetItemString(1,'Freight_Terms') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Freight_Terms')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//22Total Weight	N(12,2)	No	N/A		
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'weight_gross')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//23Transportation Mode	C(10)	No	N/A		
	If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//24Delivery Date	Date	No	N/A		
	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//25Detail User Field1	C(20)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//26Detail User Field2	C(20)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//27Detail User Field3	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//28Detail User Field4	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//29Detail User Field5	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail30 User Field6	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//31Detail User Field7	C(30)	No	N/A	User Field	
	If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//32Detail User Field8	C(30)	No	N/A	User Field	
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
	
	//33Master User Field2	C(10)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//34Master User Field3	C(10)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//35Master User Field4	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//36Master User Field5	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//37Master User Field6	C(20)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'ord_type') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'ord_type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
//	If idsDoMain.GetItemString(1,'user_field6') <> '' Then
//		lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	

	//38Master User Field7	C(30)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//39Master User Field8	C(60)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//40Master User Field9	C(30)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//41Master User Field10	C(30)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//42Master User Field11	C(30)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//43Master User Field12	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//44Master User Field13	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//45Master User Field14	C(50)	No	N/A	User Field
	If idsDoMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//46Master User Field15	C(50)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//47Master User Field16	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field16') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//48Master User Field17	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field17') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//49Master User Field18	C(100)	No	N/A	User Field	
	If idsDoMain.GetItemString(1,'user_field18') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//50CustomerCode	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//51Ship To Name	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//52Ship Address 1		
	If idsDoMain.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//53Ship Address 2		
	If idsDoMain.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//54Ship Address 3		
	If idsDoMain.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//55Ship Address 4		
	If idsDoMain.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
		
	//56Ship City		
	If idsDoMain.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//57Ship State	
	If idsDoMain.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//58Ship Postal Code		
	If idsDoMain.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//59Ship Country
	If idsDoMain.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//60UnitOfMeasure (weight)	
	//EWMS has the Package Weight hardcoded to “1.0”. I am assuming that is the UPM (Weight) field.	
	//MEA - Outstand question to Pete - value of field - just pass place holder for now.
	lsOutString += "KG" + lsDelimitChar

	//61UnitOfMeasure (quantity)	//Jxlim 05/20/2014 Garmin Default UOM is Each
	lsOutString += 'EA' +  lsDelimitChar
//	If idsdoDetail.GetItemString(llDetailFind,'uom') <> '' Then
//		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'uom')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If

	//62CountryOfOrigin	
	lsTemp = idsdoPick.GetITemString(llRowPos,'country_of_origin')
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	

	//63Master User Field19		
	If idsDoMain.GetItemString(1,'user_field19') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field19')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//64Master User Field20	
	If idsDoMain.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//65Master User Field21		
	If idsDoMain.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If				
		
	//66Master User User Field22	
	If idsDoMain.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) //+ lsDelimitChar
//	Else
//		lsOutString +=lsDelimitChar  //Jxlim 05/15/2014 Don't need delimiter at the last filed
	End If				
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Jxlim 05/15/2014 Garmin
//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow				
String			lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp
DEcimal		ldBatchSeq
Integer		liRC
Long			 llLineItemNo

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

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar //Jxlim 05/15/2014 Garmin specified at contructor event
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	//1Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier		
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	//2Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString += asproject + lsDelimitChar

	//3Warehouse	C(10)	Yes	N/A	Receiving Warehouse
	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//4Order Number	C(20)	Yes	N/A	Purchase order number
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar

	//5Inventory Type	C(1)	Yes	N/A	Item condition
	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//6Receipt Date	Date	Yes	N/A	Receipt completion date	
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'YYYY-MM-DD') + lsDelimitChar
	
	//7SKU	C(50	Yes	N/A	Material Number
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar  
	
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	llLineItemNo = idsroputaway.GetItemNumber(llRowPos,'line_item_no')
//	lsCOO	
	
	//8Quantity	N(15,5)	Yes	N/A	Received quantity
	lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
	//9Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//10PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//11PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field	
	If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//12Serial Number	C(50)	No	N/A	Qty must be 1 if present
	If idsroputaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//13Container ID	C(25)	No	N/A	
	If idsroputaway.GetItemString(llRowPos,'container_id') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//14Expiration Date	Date	No	N/A	
	If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//15Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	//16Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
	If trim(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) <> '' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	llFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' and line_item_no = " + string(llLineItemNo), 1, idsRODetail.RowCount())
	
	//17Detail User Field1	C(50)	No	N/A	User Field
	If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'user_field1') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//18Detail User Field2	C(50)	No	N/A	User Field
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field2') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//19Detail User Field3	C(50)	No	N/A	User Field	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field3') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//20Detail User Field4	C(50)	No	N/A	User Field	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field4') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//21Detail User Field5	C(50)	No	N/A	User Field	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field5') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//22Detail User Field6	C(50)	No	N/A	User Field
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field6') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//23Master User Field1	C(10)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field1') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//24Master User Field2	C(10)	No	N/A	User Field2 ICC mandatory value for order type  'S' or 'X' 
	If idsROMain.GetItemString(1,'ord_type') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'ord_type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
//	If idsROMain.GetItemString(1,'user_field2') <> '' Then
//		lsOutString += String(idsROMain.GetItemString(1,'user_field2')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	

	//25Master User Field3	C(10)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//26Master User Field4	C(20)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//27Master User Field5	C(20)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//28Master User Field6	C(20)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//29Master User Field7	C(30)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//30Master User Field8	C(30)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//31Master User Field9	C(255)	No	N/A	User Field	
		If idsROMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//32Master User Field10	C(255)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//33Master User Field11	C(255)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//34Master User Field12	C(255)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//35Master User Field13	C(255)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//36Master User Field14	C(255)	No	N/A	User Field	
	If idsROMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//37Master User Field15	C(255)	No	N/A	User Field		
	If idsROMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//MEA 01-NOV-2011: Added Columns for Baseline

	//38Carrier		
	If idsROMain.GetItemString(1,'carrier') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//39Country Of Origin	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'country_of_origin') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'country_of_origin')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
		
	//40UnitOfMeasure	
	If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'uom') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//41AWB #	
	If idsROMain.GetItemString(1,'AWB_BOL_No') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'AWB_BOL_No')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
			
	//42Division
	//Get from Item_Master
	Select grp INTO :lsGrp From Item_Master
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
		USING SQLCA;
		
	If IsNull(lsGrp) then lsGrp = ''

	lsOutString += lsGrp  +  lsDelimitChar


	//43 Inventory location l_code  	
	lsOutString += idsroputaway.GetItemString(llRowPos,'l_code')  // Last item in GR so no Delimeter	
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

Return 0
end function

public function integer uf_rt (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Warner for the RETURN order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName

DEcimal		ldBatchSeq
Integer		liRC
String     lsCurrentRTBatchSeqNum	

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

If Not isvalid(idsrodetail) Then
	idsrodetail = Create Datastore
	idsrodetail.Dataobject = 'd_ro_Detail'
	idsrodetail.SetTransObject(SQLCA)
End If

idsOut.Reset()
idsGR.Reset()

lsLogOut = "      Creating RT For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
//If idsROMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsROMain.GetITemNumber(1,'edi_batch_seq_no'))   Then Return 0

idsroDetail.Retrieve(asRONO)

//For each Line/sku
llRowCOunt = idsroDetail.RowCount()

For llRowPos = 1 to llRowCount
	
	llLineItemNo = idsroDetail.GetItemNumber(llRowPos,'line_item_no')
	
	lsFind = "po_item_number = '" + String(llLineItemNo)  + "' and upper(sku) = '" + upper(idsroDetail.GetItemString(llRowPos,'SKU')) +  "'"
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())

	If llFindRow > 0 Then /*row already exists, add the qty*/
	
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsroDetail.GetItemNumber(llRowPos,'alloc_qty')))
		
	Else /*not found, add a new record*/
		
		llNewRow = idsGR.InsertRow(0)
	
		idsGR.SetItem(llNewRow,'sku',idsroDetail.GetItemString(llRowPos,'sku'))
		idsGR.SetItem(llNewRow,'quantity',idsroDetail.GetItemNumber(llRowPos,'alloc_qty'))
		idsGR.SetItem(llNewRow,'po_item_number',llLineItemNo)
								
	End If
	
Next /* Next Putaway record */

/* If there is a current batch seq number */
lsCurrentRTBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentRTBatchSeqNum","")

IF trim(lsCurrentRTBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Return_Confirm_File','Return_Confirm')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Return Confirmation Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentRTBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentRTBatchSeqNum)
END IF

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	lsOutString = 'RT|' /*rec type = Return Confirmation*/
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + '|' /*RMA Number*/
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + '|'
	lsOutString +="01|"/* warehouse hardcoded */
	
	If Not isnull(idsROMain.GetItemString(1,'User_field10') ) Then
		lsOutString += idsROMain.GetItemString(1,'User_field10') + '|' /*RMA Customer Code*/
	Else
		lsOutString += "|"
	End If
				
	lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|' /*RMA Line */
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) 
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'RT' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
End If

Return 0
end function

public function string getwarnerinvtype (string asinvtype);
//Convert the Menlo Onventory Type into the Warner code

String	lsWarnerInvTpe
Choose case upper(asInvType)
		
	Case 'N'
		lsWarnerInvTpe = 'A' /*saleable*/
	Case 'R'
		lsWarnerInvTpe = 'D' /*Rework*/
	Case Else
		lsWarnerInvTpe = asInvType
End Choose

Return lsWarnerInvTpe
end function

public function integer uf_pod (string asproject, string asdono);//Prepare aProof of Delivery Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsReceiptStatus
DEcimal		ldBatchSeq, ldAllocQty, ldAcceptQty, ldDWAllocQty, ldDWAcceptQty
Integer		liRC
String     lsCurrentPODBatchSeqNum		


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


idsOut.Reset()

lsLogOut = "        Creating POD For DONO: " + asDONO
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


/* If there is a current batch seq number */
lsCurrentPODBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentPODBatchSeqNum","")

IF trim(lsCurrentPODBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Proof_Of_Delivery_File','Proof_Of_Delivery')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Proof of Delivery Transaction Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentPODBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentPODBatchSeqNum)
END IF

//Sum The Alloc and Accpt Qty to determin the Order Status
llRowCount = idsDoDetail.RowCount()
ldAllocQty = 0
ldAcceptQty = 0

For llRowPos = 1 to llRowCOunt

	//MEA - 04/10 - Need to handle nulls
	
	ldDWAllocQty = idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')
	
	IF IsNull(ldDWAllocQty) THEN ldDWAllocQty = 0
	
	ldDWAcceptQty = idsdoDetail.GetITemNumber(llRowPos,'accepted_qty')
	
	IF IsNull(ldDWAcceptQty) THEN ldDWAcceptQty = 0	
	
	ldAllocQty += ldDWAllocQty
	ldAcceptQty += ldDWAcceptQty
	
Next

If ldAllocQty = 0 Then
	lsREceiptStatus = 'CX' /*Order Cancelled*/
ElseIf ldAllocQty = ldAcceptQty Then
	lsREceiptStatus = 'FR' /*Fully accepted*/
Else
	lsREceiptStatus = 'PR' /*partially accepted*/
End If

//Write the rows to the generic output table - delimited by '|'
For llRowPos = 1 to llRowCOunt
		
	//Dont include any rows that shipped canceled
	//If idsdoDetail.GetITemNumber(llRowPos,'alloc_qty') = 0 Then Continue
	
	//MEA - 04/10 - Need to handle nulls
	
	ldDWAllocQty = idsdoDetail.GetITemNumber(llRowPos,'alloc_qty')
	
	IF IsNull(ldDWAllocQty) THEN ldDWAllocQty = 0
	
	ldDWAcceptQty = idsdoDetail.GetITemNumber(llRowPos,'accepted_qty')
	
	IF IsNull(ldDWAcceptQty) THEN ldDWAcceptQty = 0	

	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'PD|' /*rec type = goods Issue*/
	lsOutString += "01|" /*warehouse hardcoded*/
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'yyyymmdd') + '|' /*Delivery DATE*/
	lsOutString += String(idsDoMain.GetItemdateTime(1,'Delivery_date'),'hhmm') + '|' /*Delivery TIME*/
	lsOutString += lsReceiptStatus + "|"
	lsOutString += String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No')) + "|" 
	lsOutString += idsDoDetail.GetITEmString(llRowPos,'SKU') + "|"
	
	lsOutString += String( ldDWAcceptQty) + "|"
	
	//Line Status
	If ldDWAcceptQty  = ldDWAllocQty Then
		lsOutString += "AC" /*Fully receipted*/
	Elseif ldDWAcceptQty = 0 Then
		lsOutString += "RE" /*Fully rejected*/
	Else
		lsOutString += "PT" /*Partially receipted*/
	End If
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'PD' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long altransid);//Prepare a Stock Adjustment Transaction for Warner for the Stock Adjustment just made

Long			llNewRow, llNewQty, lloldQty, llRowCount,	llAdjustID, llNetQty
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,	lsTranType, lsTransParm

Decimal		ldBatchSeq
Integer		liRC
String	lsLogOut

String lsCurrentAdjustBatchSeqNum


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

// For qualitative adjustments between 2 existing buckets, there is relevent info in the parm field that we need to properly report the adjustment
Select  Trans_parm into  :lsTransParm
From Batch_Transaction
Where Trans_ID = :alTransID;

If lsTransParm = 'SKIP' Then
	 Return 0
End If

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


lsSku = idsAdjustment.GetITemString(1,'sku')
lsOldInvType = idsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetITemString(1,"inventory_type")

llAdjustID = idsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetITemNumber(1,"quantity")
lloldQty = idsAdjustment.GetITemNumber(1,"old_quantity")
		
//We are only Sending a record for an Inventory Type or Qty Changes
If lsOldInvType = lsNewInvType and llNewQty = llOldQty Then Return 0

/* If there is a current batch seq number */
lsCurrentAdjustBatchSeqNum = ProfileString(gsinifile,'WARNER',"CurrentAdjustBatchSeqNum","")

IF trim(lsCurrentAdjustBatchSeqNum) = '' THEN

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Adjustment_File','Adjustment')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number~rfor Adjustment Confirmation.~r~rConfirmation will not be sent to Warner!'"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	SetProfileString(gsIniFile, 'WARNER', 'CurrentAdjustBatchSeqNum ', String(ldBatchSeq))

ELSE
	ldBatchSeq = Dec(lsCurrentAdjustBatchSeqNum)
END IF

		
lsOutString = 'MM' + '|' /*rec type = Material Movement*/
lsOutString += String(today(),'yyyymmdd') + '|'  
lsOutString += "01|" /*hardcoded warehouse*/

//From/To Inv Types - 
If idsAdjustment.GetITemString(1,"adjustment_type") = 'Q' Then
	
	If llNewQty > llOldQty Then
		lsOutString += "|" /* positive changes have blank in From Inv Type*/
		lsOutString +=getWarnerInvType(lsNewInvType) +  "|" 
		llNetQty = llNewQty - llOldQty
	ElseIf llOldQty > llNewQty Then
		lsOutString += getWarnerInvType(lsOldInvtype) + "|" /*negative changes show Type in Old Inv Type field*/
		lsOutString += "|"
		llNetQty = llOldQty - llNewQty
	End If
	
Else /*Inv Type Change*/
	
	/* if recombining a bucket, the adjustment will have the same value for old/new Inv Type but the balancing adjustment Inv Type is tored in the Trans_Parm*/
	If Pos(lsTransParm,'OLD_INVENTORY_TYPE') > 0 Then
		lsOldInvType = Mid(lsTransParm,(Pos(lsTransParm,'=') + 1),999)
		llnetQty = Abs(llNewQty - llOldQty)
	Else
		llnetQty = llNewQty
	End If
	
	lsOutString += getWarnerInvType(lsOldInvtype)  + "|"
	lsOutString +=getWarnerInvType(lsNewInvType) +  "|" 

End If

lsOutString += lsSku + '|' 
lsOutString += String(llNetQty)  

llNewRow = idsOut.insertRow(0)
	
	
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)

lsFileName = 'MM' + String(ldBatchSeq,'000000') + '.DAT'

idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
 //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
Return 0
end function

public function integer uf_sc (string asproject, string asdono);//Jxlim 05/15/2014 Garmin
//Prepare a Shipment ConfirmationTransaction for the order that was just confirmed
Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
String			lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  		lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsConsolNo, lsdono
DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound
Long llDetailFind, llPackFind, llPickFind

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsDOMainSC) Then
	idsDOMainSC = Create Datastore
	idsDOMainSC.Dataobject = 'd_do_master'
	idsDOMainSC.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoDetailSC) Then
	idsDoDetailSC = Create Datastore
	idsDoDetailSC.Dataobject = 'd_do_Detail_by_shipment'
	idsDoDetailSC.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPickSC) Then
	idsDOPickSC = Create Datastore
	idsDOPickSC.Dataobject = 'd_do_Picking_detail_by_shipment' 
	idsDOPickSC.SetTransObject(SQLCA)
End If

If Not isvalid(idsDOPackSC) Then
	idsDOPackSC = Create Datastore
	idsDOPackSC.Dataobject = 'd_do_Packing_by_shipment'
	idsDOPackSC.SetTransObject(SQLCA)
End If

idsOut.Reset()


//Retreive Delivery Master and Detail  records for this DONO
If idsDOMainSC.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsConsolNo = idsdoMainSC.GetItemString(1,'Consolidation_No' )

idsDoDetailSC.Retrieve(asProject, lsConsolNo)
idsDOPickSC.Retrieve(asProject, lsConsolNo)
idsDOPackSC.Retrieve(asProject, lsConsolNo)

llRowCount = idsDOPickSC.RowCount()
lsLogOut = '     ' + string(llRowCount) + ' Picking Rows were retrieved for flatfile output...'

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to GARMIN!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsLogOut = "        Creating SC For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)


For llRowPos = 1 to idsDoDetailSC.RowCount()	
	llLineItemNo =  idsDoDetailSC.getitemnumber(llRowPos,'line_item_no')
	lsDoNo =  idsDoDetailSC.getitemString(llRowPos,'Do_No')
	
	llPickFind = idsDOPickSC.Find("Do_No = '" + lsDoNo +  "' and Line_item_no = " + string(llLIneItemNo), 1, idsDOPickSC.RowCount())
	If llPickFind > 0 Then	
		Continue		
	Else		
		llNewRow = idsDOPickSC.InsertRow(0)

		idsDOPickSC.SetItem( llNewRow, "do_no", idsDoDetailSC.GetItemString(llRowPos,'Do_No'))	
		idsDOPickSC.SetItem( llNewRow, "sku", idsDoDetailSC.GetItemString(llRowPos,'sku'))
		idsDOPickSC.SetItem( llNewRow, "supp_code", idsDoDetailSC.GetItemString(llRowPos,'supp_code'))
		idsDOPickSC.SetItem( llNewRow, "Line_item_no", llLineItemNo)
		idsDOPickSC.SetItem( llNewRow, "lot_no", idsDoDetailSC.GetItemString(llRowPos,'User_Field5'))

		//Need to add for Sorting.
		idsDOPickSC.SetItem( llNewRow, "Component_No", 0)
		idsDOPickSC.SetItem( llNewRow, "Component_Ind", 'N')
		idsDOPickSC.SetItem( llNewRow, "SKU_Parent", idsDoDetailSC.GetItemString(llRowPos,'sku'))
	
		idsDOPickSC.SetItem( llNewRow, "quantity", 0)
	End If	
Next

idsDOPickSC.Sort()

//Write the rows to the generic output table - delimited by lsDelimitChar  //Jxlim specified at the contructor event

llRowCount = idsDOPickSC.RowCount()
lsLogOut = '     ' + string(llRowCount) + ' Picking Rows were retrieved for flatfile output...'

For llRowPos = 1 to llRowCOunt
	llNewRow = idsOut.insertRow(0)

	lsSku = idsDOPickSC.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsDOPickSC.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsDOPickSC.GetITemNumber(llRowPos, 'Line_item_No'))
	lsDoNo =  idsDoPickSC.getitemString(llRowPos,'Do_No')

	llDetailFind = idsDoDetailSC.Find("Do_No = '" + lsDoNo + "' and sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetailSC.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue		
	End If

	llPackFind = idsDOPackSC.Find("Do_No = '" + lsDoNo +  "' and sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDOPackSC.RowCount())

	//1Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“GI”	Goods issue confirmation identifier
	lsOutString = 'GI' + lsDelimitChar
	
	//2Project ID	C(10)	Yes	N/A	Project identifier	
	lsOutString +=  asproject + lsDelimitChar
	
	//3Warehouse	C(10)	Yes		Shipping Warehouse	
	lsOutString += idsDoMainSC.GetItemString(1,'wh_code') + lsDelimitChar
	
	//4Delivery Number	C(10)	Yes	N/A	Delivery Order Number
//	lsTemp =   idsDoDetailSC.GetItemString(llDetailFind,'user_field1')	
//	If IsNull(lsTemp) then lsTemp = ''	
//	lsOutString +=  lsTemp + lsDelimitChar	
	lsOutString += lsConsolNo + lsDelimitChar	

	//5Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number	
	lsOutString += String(idsDOPickSC.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar

	//lsOutString += String(idsDoDetailSC.GetITemString(llDetailFind, 'user_field6')) + lsDelimitChar
	
	//6SKU	C(50)	Yes	N/A	Material number
	lsOutString +=lsSku  + lsDelimitChar		
	
	//7Quantity	N(15,5)	Yes	N/A	Actual shipped quantity	
	lsOutString += String( idsDOPickSC.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
	//8Inventory Type	C(1)	Yes	N/A	Item condition	
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'Inventory_Type')	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp + lsDelimitChar
	
	//9Lot Number	C(50)	No	N/A	1st User Defined Inventory field	
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'Lot_No')	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//10PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'PO_No')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
	//11PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'PO_No2')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
	//12Serial Number	C(50)	No	N/A	Qty must be 1 if present
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'Serial_No')	
		If IsNull(lsTemp) then lsTemp = ''	
		If  lsTemp <> '-' Then
			lsOutString += lsTemp + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
	
	//13Container ID	C(25)	No	N/A	
	If llPackFind > 0 then 
//		lsTemp = idsDOPackSC.GetItemString(llPackFind,'carton_no')
		lstemp =String(llRowPos)
	End if
	lsOutString += lsTemp + lsDelimitChar
	
//	//lsTemp = idsDOPickSC.GetITemString(llRowPos,'Container_ID')	
//	If IsNull(lsTemp) then lsTemp = ''
//	lsTemp =  mid(idsDoMain.GetItemString(1,'Invoice_no'), 4) + trim(lsTemp)
//	If  lsTemp <> '-' Then
//		lsOutString += lsTemp + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	
	
	//14Expiration Date	Date	No	N/A	
	lsOutString += String( idsDOPickSC.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//15Price	N(12,4)	No	N/A		
	lsTemp = String(idsDOPickSC.GetItemDecimal(llDetailFind, "Price"))	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//16Ship Date	Date	No	N/A	Actual Ship date
	lsTemp = String( idsDoMainSC.GetItemDateTime(1,"schedule_date"),'yyyy-mm-dd') 	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar
	
	//17Package Count	N(5,0)	No	N/A	Total no. of package in delivery
	lsTemp = String(1)  		
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//18Ship Tracking Number	C(25)	No	N/A Garmin will manually enter Shipper tracking Number onto awb_bol_no on other info tab and Sims will send back this value vis GI(945)	05/29/2014
	If idsDoMainSC.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'awb_bol_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//19Carrier	C (20)	No	N/A	Input by user	
	If idsDoMainSC.GetItemString(1,'Carrier') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'Carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		
	//20Freight Cost	N(10,3)	No	N/A		
	lsFreight_Cost = String(idsDoMainSC.GetItemDecimal(1,'Freight_Cost'))
	IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""	
	lsOutString += lsFreight_Cost + lsDelimitChar		
	
	//21Freight Terms	C(20)	No	N/A		
	If idsDoMainSC.GetItemString(1,'Freight_Terms') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'Freight_Terms')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//22Total Weight	N(12,2)	No	N/A		
	IF llPackFind > 0 then
		lsTemp = String( idsDOPackSC.GetItemDecimal(llPackFind,'weight_gross')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar		
	
	//23Transportation Mode	C(10)	No	N/A		
	If idsDoMainSC.GetItemString(1,'transport_mode') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'transport_mode')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//24Delivery Date	Date	No	N/A		
	lsTemp =  String( idsDoMainSC.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 	
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//25Detail User Field1	C(20)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//26Detail User Field2	C(20)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//27Detail User Field3	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//28Detail User Field4	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field4') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//29Detail User Field5	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field5') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail30 User Field6	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//31Detail User Field7	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field7') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	//32Detail User Field8	C(30)	No	N/A	User Field	
	If idsDoDetailSC.GetItemString(llDetailFind,'user_field8') <> '' Then
		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			

//	//Master User Field1	C(10)	No	N/A	User Field	
//	
//	If idsDoMainSC.GetItemString(1,'user_field1') <> '' Then
//		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field1')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	
	
	//33Master User Field2	C(10)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//34Master User Field3	C(10)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//35Master User Field4	C(20)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//36Master User Field5	C(20)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//37Master User Field6	C(20)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'ord_type') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'ord_type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
//	If idsDoMainSC.GetItemString(1,'user_field6') <> '' Then
//		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field6')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If	

	//38Master User Field7	C(30)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//39Master User Field8	C(60)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//40Master User Field9	C(30)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//41Master User Field10	C(30)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//42Master User Field11	C(30)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//43Master User Field12	C(50)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//44Master User Field13	C(50)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//45Master User Field14	C(50)	No	N/A	User Field
	If idsDoMainSC.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//46Master User Field15	C(50)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//47Master User Field16	C(100)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field16') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field16')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//48Master User Field17	C(100)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field17') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field17')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//49Master User Field18	C(100)	No	N/A	User Field	
	If idsDoMainSC.GetItemString(1,'user_field18') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field18')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//50CustomerCode	
	If idsDoMainSC.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//51Ship To Name	
	If idsDoMainSC.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//52Ship Address 1		
	If idsDoMainSC.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//53Ship Address 2		
	If idsDoMainSC.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//54Ship Address 3		
	If idsDoMainSC.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//55Ship Address 4		
	If idsDoMainSC.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
		
	//56Ship City		
	If idsDoMainSC.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//57Ship State	
	If idsDoMainSC.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//58Ship Postal Code		
	If idsDoMainSC.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//59Ship Country
	If idsDoMainSC.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//60UnitOfMeasure (weight)	
	//EWMS has the Package Weight hardcoded to “1.0”. I am assuming that is the UPM (Weight) field.	
	//MEA - Outstand question to Pete - value of field - just pass place holder for now.
	lsOutString += "KG" + lsDelimitChar

	//61UnitOfMeasure (quantity)	//Jxlim 05/20/2014 Garmin Default UOM is Each
	lsOutString += 'EA' +  lsDelimitChar
//	If idsDoDetailSC.GetItemString(llDetailFind,'uom') <> '' Then
//		lsOutString += String(idsDoDetailSC.GetItemString(llDetailFind,'uom')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If

	//62CountryOfOrigin	
	lsTemp = idsDOPickSC.GetITemString(llRowPos,'country_of_origin')
	If IsNull(lsTemp) then lsTemp = ''	
	lsOutString += lsTemp+ lsDelimitChar	

	//63Master User Field19		
	If idsDoMainSC.GetItemString(1,'user_field19') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field19')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//64Master User Field20	
	If idsDoMainSC.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//65Master User Field21		
	If idsDoMainSC.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If				
		
	//66Master User User Field22	
	If idsDoMainSC.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMainSC.GetItemString(1,'user_field22')) //+ lsDelimitChar
//	Else
//		lsOutString +=lsDelimitChar  //Jxlim 05/15/2014 Don't need delimiter at the last filed
	End If				
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)


	
next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

Return 0
end function

on u_nvo_edi_confirmations_garmin.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_garmin.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//Jxlim 05/15/2014 Garmin use tab delimiter

//lsDelimitChar = '|'
//lsDelimitChar = char(9)  //this mean tab delimiter
lsDelimitChar =  '~t'  //Pete recommend to use tilde t for tab delimiter
end event

