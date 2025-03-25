$PBExportHeader$u_nvo_edi_confirmations_friedrich.sru
$PBExportComments$Process outbound edi confirmation transactions for Friedrich
forward
global type u_nvo_edi_confirmations_friedrich from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_friedrich from nonvisualobject
end type
global u_nvo_edi_confirmations_friedrich u_nvo_edi_confirmations_friedrich

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate, idsDoSerial
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode


string lsDelimitChar
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_process_dboh (string asinifile, string asproject)
public function integer uf_process_orders_to_otm (string asinifile, string asproject, string aswarehouse)
end prototypes

public function integer uf_gi (string asproject, string asdono);
//-	Add Delivery_Master.Ship_Ref at the end of the RS/GI record (after DMUF22).
//-	We will always include the Pack Record (not dependant on ini file setting to include)
//-	WE will send both a Ready to Ship and Goods Issue transaction


//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed


//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

String		lsUserLineItemNo

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
	idsDoPick.Dataobject = 'd_do_Picking_detail_baseline' 
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
//	idsDoPack.Dataobject = 'd_friedrich_do_packing'
	idsDoPack.Dataobject = 'd_do_packing_physio'
	idsDoPack.SetTransObject(SQLCA)
End If


//MEA - 8/13 - Added for PK Serial Processing

If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create Datastore
//	idsDoSerial.Dataobject = 'd_friedrich_do_serial'
	idsDoSerial.Dataobject = 'd_do_serial_physio'
	idsDoSerial.SetTransObject(SQLCA)
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

idsDoSerial.Retrieve(asDoNo)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//// TAM Get total weight
//llRowCount = idsDoack.RowCount()
//For llRowPos = 1 to llRowCOunt
//	ldGrossWeight  =  ldGrossWeight + idsdoPack.GetItemNumber(llRowPos,'Weight_Gross' ) 
//next

//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo =string(idsdoPick.GetItemNumber(llRowPos,'line_item_no')) //19-Jun-2013 :Madhu added 
	
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())
	
	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

	lsUserLineItemNo = idsdoDetail.GetItemString(llDetailFind,'User_Line_item_No')
	
	If IsNull(lsUserLineItemNo) then lsUserLineItemNo = lsLineItemNo

	lsLogOut = "        UserLineItemNo: " + lsUserLineItemNo
	FileWrite(gilogFileNo,lsLogOut)

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
	
//		lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar  //MEA - Commented out
		lsOutString += lsUserLineItemNo + lsDelimitChar
		
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += lsSku  + lsDelimitChar	
	

	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	

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
		lsOutString += '-' + lsDelimitChar//tam added this as - so it matches the pk
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
	
	If string(idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'MM/DD/YYYY') <> "12/31/2999" and string(idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'MM/DD/YYYY') <> "01/01/1900" Then
		lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar	
	ELSE
		lsOutString +=lsDelimitChar
	End If

		

	//Price	N(12,4)	No	N/A	
	
	
	lsTemp = String(idsdoPick.GetItemDecimal(llRowPos, "Price"))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//Ship Date	Date	No	N/A	Actual Ship date

//	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') + 'T' + String(idsDoMain.GetItemDateTime(1,'complete_date'),'hh:mm:ss')
	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-ddThh:mm:ss') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery

	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	// 08/13 - PCONKL - Trim to 25 char. The client is concatenating multiple tracking numbers
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString += left(idsDoMain.GetItemString(1,'awb_bol_no'),25) + lsDelimitChar
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
	
	//Line Item Number	C(30)	No	N/A	User Field
	
//	If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
//		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + lsDelimitChar
		lsOutString += lsLineItemNo + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If			
	
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

	//Jxlim 03/20/2014 Replace Delivery_Master.User_field7 with Delivery_Master.Carrier_pro_no
	//Master User Field7	C(30)	No	N/A	User Field
	//If idsDoMain.GetItemString(1,'user_field7') <> '' Then
		//lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
	If idsDoMain.GetItemString(1,'carrier_pro_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'carrier_pro_no')) + lsDelimitChar
	Else
		//Jxlim 03/26/2014 During the transitioned of replacing pro no field in Sims Client we will continue to use user_field7
	    //until all client (document and report) are 100% replaced with carrier_pro_no field, then this user_field code will be removed from sweeper.
		If idsDoMain.GetItemString(1,'user_field7') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If
	End If	

	//Master User Field8	C(60)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field9	C(30)	No	N/A	User Field
	// TAM Changed toUF 5
//	If idsDoMain.GetItemString(1,'user_field9') <> '' Then
//		lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + lsDelimitChar
	If idsDoMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + lsDelimitChar
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

	lsOutString += 'LB' + lsDelimitChar

	//UnitOfMeasure (quantity)	

		lsOutString += 'EA' + lsDelimitChar

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
		lsOutString +=lsDelimitChar
	End If		
	
	
	//Delivery_Master.Ship_Ref 

	If idsDoMain.GetItemString(1,'Ship_Ref') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref'))  + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//GI068	Product Description
	
	string lsSkuDesc
	
	SELECT description INTO :lsSkuDesc FROM Item_Master Where 
	Sku = :lsSku and Supp_Code = :lsSuppCode and project_id = :asproject USING SQLCA;
	
	lsSkuDesc = trim(lsSkuDesc)

	If lsSkuDesc <> '' Then
		lsOutString += lsSkuDesc + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//GI069	Shipment Instruction     
	//
	If idsDoMain.GetItemString(1,'shipping_instructions') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'shipping_instructions')) //+ lsDelimitChar
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


//Get the Project / Warehouse defaults for UCC

lsWHCode = idsDoMain.GetItemString(1,'wh_code')

SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :asproject USING SQLCA;

IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''

SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;

IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''

//Prepare idsDoPack with Serial Data

String lsSerialNo
Decimal ldQuantity

llRowCount = idsDoSerial.RowCount()

//	Serial Numbers will have to come from Delivery_Serial_Detail which has carton number but not line_item_no. I would join delivery_serial_Detail to delivery_picking_detail (on ID_NO) to get the line_item_no.
//
//	We will need to do 2 passes:
//	
//	-	First loop through Delivery_Serial_Detail/Delivery_Picking_detail to get the serialized parts. There might be non-serialized parts on here as well so ignore if serial_no = ‘-‘. We will write a PK record for each serial number. We will also have to get the Lottables from Delivery_packing by doing a find on the packing row by Line_Item and Carton_no.
//	
//	-	The non serialized items will come just from Delivery_Packing. Make sure to exclude items processed from the Serial Tab. You can probably just take where serialized_ind = ‘N’.
//

For llRowPos = 1 to llRowCOunt

	lsSku = idsDoSerial.GetITEmString(llRowPos,'sku')
//	lsSuppCode =  Upper(idsDoSerial.GetITEmString(llRowPos,'supp_code'))
	llLineItemNo = idsDoSerial.GetITemNumber(llRowPos, 'Line_item_No')

	lsCartonNo =  idsDoSerial.GetITEmString(llRowPos,'Carton_No')
	lsSerialNo =  idsDoSerial.GetITEmString(llRowPos,'Serial_No')
	
	ldQuantity = idsDoSerial.GetITemNumber(llRowPos, 'Quantity')
	

long llpackcnt
llpackcnt = idsDoSerial.RowCount()

	llPackFind = idsDoPack.Find( "carton_no='"+lsCartonNo+"' and line_item_no = " + string(llLineItemNo), 1, idsDoPack.RowCount())

//+ "and serial_no='"+lsSerialNo + "'"
	if llPackFind > 0 then
		
		if idsDoPack.GetItemString( llPackFind, "pack_row_retreive" ) = 'Y' then
			
			//Do nothing, this row was orginally retrieved as part of the packing process. 
			
		else
			
			//Need to copy this row and insert another.
			//Insert At End
			
			idsDoPack.RowsCopy(llPackFind, llPackFind, Primary!, idsDoPack, (idsDoPack.RowCount() + 1), Primary!)
			llPackFind = idsDoPack.RowCount()
			
		end if

		 idsDoPack.SetItem( llPackFind, "quantity", ldQuantity )
		 idsDoPack.SetItem( llPackFind, "serial_no", lsSerialNo )
		 idsDoPack.SetItem( llPackFind, "pack_row_retreive", 'N' )
		
	else
		
		//Can't match up serial and carton. There is an error. We should log.
		
		lsLogOut = "        *** Unable to Pack Row (PK) for Caton No " + lsCartonNo + " and Line_Item_No = " + string(llLineItemNo) + "  and  DONO: " + asDONO
		FileWrite(gilogFileNo,lsLogOut)
		
	end if
	
Next

idsDoPack.SetSort("Carton_no, line_item_no")
idsDoPack.Sort()

//If there is  no serial data for a row, then still print the packing row so do not remove the row.

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
	
	lsCartonNo = trim(idsdoPack.GetITemString(llRowPos, 'Carton_No'))
	
	If IsNull(lsCartonNo) then lsCartonNo = ''
	
	If lsCartonNo <> '' Then
		
//		lsCartonNo = String( LONG (idsdoPack.GetITemString(llRowPos, 'Carton_No')) , "000000000" )
//		
//		lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
//		
//		//From BaseLine
//		
//		liCheck = f_calc_uccs_check_Digit(lsUCCS) 
//	
//		
//		If liCheck >=0 Then
//			lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
//		Else
//			lsUCCS = "00" + String(lsUCCS,'00000000000000000000') + "0"
//		End IF
		
//		lsOutString += lsUCCS  + lsDelimitChar
		
		lsOutString += lsCartonNo  + lsDelimitChar
		
	Else
		
		lsOutString +=lsDelimitChar

	END IF

	
	lsSku = idsDoPack.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsDoPack.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsDoPack.GetITemNumber(llRowPos, 'Line_item_No'))

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If	
	
	lsUserLineItemNo = idsdoDetail.GetItemString(llDetailFind,'User_Line_item_No')	
	
	If IsNull(lsUserLineItemNo) then lsUserLineItemNo = lsLineItemNo
	
	//Line Item Number
	
//	lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar    - MEA Comment Out
	lsOutString += lsUserLineItemNo + lsDelimitChar
	
	
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
	
	If idsDoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//User Field 2
	
	If idsDoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_field2'))  + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		

	//	PK018	Lot Number

	If idsDoPack.GetItemString(llRowPos,'pack_lot_no') <> '' Then
		lsOutString += String(idsDoPack.GetItemString(llRowPos,'pack_lot_no')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	 


	//	PK019	PO NBR  [ Reservation# / Inventory Allocation]

	If idsDoPack.GetItemString(llRowPos,'pack_po_no') <> '' Then
		lsOutString += String(idsDoPack.GetItemString(llRowPos,'pack_po_no')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	

	//	PK020	Serial Number
	
	//This should be prepared above.

	If idsDoPack.GetItemString(llRowPos,'serial_no') <> '' Then
		lsOutString += String(idsDoPack.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += '-' + lsDelimitChar//tam added this as blank so it matches the GI
	End If		
	
	
	//	PK021	Expiration Date
	
	If string(idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'MM/DD/YYYY') <> "12/31/2999" and string(idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'MM/DD/YYYY') <> "01/01/1900" Then
		lsOutString += String( idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	    



//	PK022 	Detail User Field6 [ Client Order Line Number ]

//	If idsDoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
//		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_field6'))  + lsDelimitChar
		lsOutString += lsLineItemNo + lsDelimitChar
//	Else
//		lsOutString +=lsDelimitChar
//	End If	



//	PK023 	Detail User Field3 [ Client Order Line Number ]

	If idsDoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_field3'))  //+ lsDelimitChar
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


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

public function integer uf_process_dboh (string asinifile, string asproject);////Process Daily Inventory Report
//
//string lsFilename ="DailyInventoryReport-"
//string lsPath,lsFileNamePath,msg,lsLogOut
//int returnCode,liRC
//long llRowCount
//
//Datastore	ldsdir
//
//
//FileWrite(gilogFileNo,"")
//msg = '**********************************'
//FileWrite(gilogFileNo,msg)
//msg = 'Started Daily Inventory Report'
//FileWrite(gilogFileNo,msg)
//
//
//// Create our filename and path
//lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
//lsPath = ProfileString(asInifile,asproject,"archivedirectory","")
//lsPath += '\' + lsFilename
//// log it
//msg = 'Confirmation Report Path & Filename: ' + lsPath
//FileWrite(gilogFileNo,msg)
//
//
//
//ldsdir = Create Datastore
//ldsdir.Dataobject = 'd_ariens_dboh'
//lirc = ldsdir.SetTransobject(sqlca)
//
//
//
//lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
//FileWrite(gilogFileNo,lsLogOut)
//gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
//
////Retrive the Daily Avail Inventory Data
//gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
//llRowCOunt = ldsdir.Retrieve(asProject,asProject)
//
//if llRowCOunt <= 0 then
//	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
//	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
//	FileWrite(gilogFileNo,msg)
//	msg = '**********************************'
//	FileWrite(gilogFileNo,msg)	
//	return 0 // nothing to see here...move along
//end if
//
//ldsDir.Sort()
//
//// Export the data to the file location
//returnCode = ldsdir.saveas(lsPath,CSV!,true)
//msg = 'Daily Inventory  Report Save As Return Code: ' + string(returnCode)
//FileWrite(gilogFileNo,msg)
//msg = 'Daily Inventory Report Finished'
//FileWrite(gilogFileNo,msg)
//msg = '**********************************'
//FileWrite(gilogFileNo,msg)
//
//
///* Now e-mailing the Short Shipped Report */
//gu_nvo_process_files.uf_send_email("Ariens",asEmail , "Daily Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inventory Report ", lsPath)
//
//Destroy ldsdir
//
//RETURN 0
//
//


//Process Daily Balance on Hand Confirmation File


Datastore	ldsOut,	&
				ldsboh
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsNextRunTime,	&
				lsNextRunDate,	&
				lsRunFreq, &
				lsFilename, &
				lsWarehouse, &
				lsLastWarehouse

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtNextRunTime
Date			ldtNextRunDate

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run



ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsboh = Create Datastore
ldsboh.Dataobject = 'd_friedrich_dboh'
lirc = ldsboh.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Balance On Hand Confirmation!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
commit;

If ldBatchSeq <= 0 Then
	lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	 Return -1
End If

//Retrive the BOH Data
gu_nvo_process_files.uf_write_log('Retrieving Balance on Hand Data.....') /*display msg to screen*/

llRowCOunt = ldsBOH.Retrieve(lsProject)

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by lsDelimitChar
gu_nvo_process_files.uf_write_log('Processing Balance on Hand Data.....') /*display msg to screen*/

For llRowPos = 1 to llRowCOunt

	llNewRow = ldsOut.insertRow(0)
	

	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“BH”	Balance on hand identifier
	
	lsOutString = 'BH' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString +=  asproject  + lsDelimitChar

	//Warehouse Code	C(10)	Yes	N/A	Warehouse ID

	lsWarehouse = left(ldsboh.GetItemString(llRowPos,'wh_code'),10)

	lsOutString +=  lsWarehouse + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += left(ldsboh.GetItemString(llRowPos,'inventory_type'),1) + lsDelimitChar

	//SKU	C(50)	Yes	N/A	Material number

	lsOutString += left(ldsboh.GetItemString(llRowPos,'sku'),26) + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Balance on hand
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'avail_qty')) + lsDelimitChar

	//Quantity Allocated	N(15,5)	No	N/A	Allocated to Outbound Order
	
	lsOutString += string(ldsboh.GetItemNumber(llRowPos,'alloc_qty')) + lsDelimitChar
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

//	if IsNull(ldsboh.GetItemString(llRowPos,'lot_no')) OR trim(ldsboh.GetItemString(llRowPos,'lot_no')) = '-' then
		lsOutString += lsDelimitChar
//	else	
//	   lsOutString +=  left(ldsboh.GetItemString(llRowPos,'lot_no'),50) + lsDelimitChar
//	end if	

	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	
//	if IsNull(ldsboh.GetItemString(llRowPos,'po_no')) OR trim(ldsboh.GetItemString(llRowPos,'po_no')) = '-' then
		lsOutString += lsDelimitChar
//	else	
//	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no') + lsDelimitChar
//	end if	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
//	if IsNull(ldsboh.GetItemString(llRowPos,'po_no2')) OR Trim(ldsboh.GetItemString(llRowPos,'po_no2')) = '-'  then
		lsOutString += lsDelimitChar
//	else	
//	   lsOutString += ldsboh.GetItemString(llRowPos,'po_no2') + lsDelimitChar
//	end if		
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	if IsNull(ldsboh.GetItemString(llRowPos,'serial_no')) OR Trim(ldsboh.GetItemString(llRowPos,'serial_no')) = '-'  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'serial_no') + lsDelimitChar
	end if			
	
	//Container ID	C(25)	No	N/A	Container ID
	
//	if IsNull(ldsboh.GetItemString(llRowPos,'container_ID')) OR trim(ldsboh.GetItemString(llRowPos,'container_ID')) = '-'  then
		lsOutString +=lsDelimitChar
//	else	
//	   lsOutString += ldsboh.GetItemString(llRowPos,'container_ID') + lsDelimitChar
//	end if
	
	//Expiration Date	Date	No	N/A	Expiration Date	

//	If string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'MM/DD/YYYY') <> "12/31/2999" Then
//		lsOutString += string(ldsboh.GetItemdatetime(llRowPos,'Expiration_date'),'YYYY-MM-DD') + lsDelimitChar
//	ELSE
		lsOutString +=lsDelimitChar
//	End If

	//Item Master UOM
	
	if IsNull(ldsboh.GetItemString(llRowPos,'uom_1')) OR Trim(ldsboh.GetItemString(llRowPos,'uom_1')) = ''  then
		lsOutString += lsDelimitChar
	else	
	   lsOutString += ldsboh.GetItemString(llRowPos,'uom_1') + lsDelimitChar
	end if		

	
	//Item Master User_Field1 - Size
	
//	if IsNull(ldsboh.GetItemString(llRowPos,'user_field1')) OR Trim(ldsboh.GetItemString(llRowPos,'user_field1')) = ''  then
		lsOutString += lsDelimitChar
//	else	
//	   lsOutString += ldsboh.GetItemString(llRowPos,'user_field1') // + lsDelimitChar
//	end if		
		
	
	
	
//	BHYYMDD.dat
	
	lsFilename = ("BH" + string(today(), "YYMMDD") + lsWarehouse + ".dat")
	
	ldsOut.SetItem(llNewRow,'file_name', lsFilename)
	ldsOut.SetItem(llNewRow,'Project_id', lsproject)
	
	if lsLastWarehouse <> lsWarehouse then

		//Get the Next Batch Seq Nbr - Used for all writing to generic tables
		sqlca.sp_next_avail_seq_no(lsproject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
		commit;
		
		If ldBatchSeq <= 0 Then
			lsLogOut = "   ***Unable to retrive next available sequence number for '+asproject+' BOH confirmation."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			 Return -1
		End If
		
		lsLastWarehouse = lsWarehouse
		
	end if	
	
	
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)

// TAM 2011/09  Added ability to email the report

lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  + ".txt"
gu_nvo_process_files.uf_send_email(lsProject,"BOHEMAIL", lsProject + " Daily Balance On Hand Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the BALANCE ON HAND REPORT run on" + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)


//Set the next time to run if freq is set in ini file
lsRunFreq = ProfileString(asIniFile, asproject,'DBOHFREQ','')
If isnumber(lsRunFreq) Then
	//ldtNextRunDate = relativeDate(Date(ldtNextRunTime),Long(lsRunFreq))
	ldtNextRunDate = relativeDate(today(),Long(lsRunFreq)) /*relative based on today*/
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE',String(ldtNextRunDate,'mm-dd-yyyy'))
Else
	SetProfileString(asIniFile, asproject,'DBOHNEXTDATE','')
End If

Return 0
end function

public function integer uf_process_orders_to_otm (string asinifile, string asproject, string aswarehouse);//// Send the orders in Picked status to OTM drop zone


Datastore	ldsOut,	&
				ldsPicked
				
Long			llRowPos,	&
				llRowCount,	&
				llFindRow,	&
				llNewRow
				
String		lsFind,	&
				lsOutString,	&
				lslogOut,	&
				lsProject,	&
				lsFilename, &
				lsWarehouse, &
				lsEmail

Integer		liRC

String lsFileNamePath

//This function runs on a scheduled basis - the next time to run is stored in the ini as well as the frequency for setting the next run

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_friedrich_orders_to_otm'
lirc = ldsOut.SetTransobject(sqlca)

ldsPicked = Create Datastore
ldsPicked.Dataobject = 'd_friedrich_picked_orders'
lirc = ldsPicked.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+asproject+" ORDERS SEND TO OTM!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = ProfileString(asInifile, asproject,"project","")

//Retrive the Processed Orders Data
gu_nvo_process_files.uf_write_log('Retrieving Processed Delivery Orders.....') /*display msg to screen*/

llRowCOunt = ldsPicked.Retrieve(lsProject, aswarehouse)

if llRowCOunt <= 0 then
	lsLogOut = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then lsLogOut = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = '**********************************'
	FileWrite(gilogFileNo,lsLogOut)	
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	return 0 // nothing to see here...move along
end if

gu_nvo_process_files.uf_write_log(String(llRowCount) + ' Rows were retrieved for processing.') /*display msg to screen*/

//Write the rows to the generic output table - delimited by ','
gu_nvo_process_files.uf_write_log('Processing Processed Delivery Orders Data.....') /*display msg to screen*/

lsFilename = ("SIMSProcessedOrders" + string(today(), "YYYYMMDDhhmmss") + asWarehouse + ".csv")
	
// TAM added a header Row
llNewRow = ldsOut.insertRow(0)
	
lsOutString = 'invoice_no,do_no,wh_code,cust_code,cust_name,address,city,state,zip,country,Early_Pickup_Date,Early_Pickup_Time,Late_Pickup_Date,Late_Pickup_Time,Early_Delivery_Date,Early_Delivery_Time,Late_Delivery_Date,Late_Delivery_Time,Freight_Terms,Bill_To,Transport_Mode,Date_Emphasis,remark,shipping_instructions,Carrier,carrier_pro,ZWF_NOLT,TOTVol,volumeUOM,awb_bol_no,Cust_Order_No,line_item_no,sku,Alloc_Qty,TotWght,WeightUOM,Hazard_Cd'
	
ldsOut.SetItem(llNewRow,'OutString', lsOutString)

For llRowPos = 1 to llRowCOunt

	llNewRow = ldsOut.insertRow(0)
	
	if IsNull(ldsPicked.GetItemString(llRowPos,'invoice_no')) Then		
		lsOutString = ','	
	else		
		lsOutString = '"' + ldsPicked.GetItemString(llRowPos,'invoice_no') + ','
	end if
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'do_no'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'do_no') + ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'wh_code')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'wh_code')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'cust_code')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'cust_code')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'cust_name')) Then			
		lsOutString += ','	
	else		
		lsOutString += '"' + ldsPicked.GetItemString(llRowPos,'cust_name')+ '",'
	end if

	string ls_add1,ls_add2, ls_add3,ls_add4

	if IsNull(ldsPicked.GetItemString(llRowPos,'address_1'))	 Then	
		ls_add1 = ''
	else
		ls_add1 = ldsPicked.GetItemString(llRowPos,'address_1')	
	end if

	if IsNull(ldsPicked.GetItemString(llRowPos,'address_2'))	 Then	
		ls_add2 = ''
	else
		ls_add2 = ldsPicked.GetItemString(llRowPos,'address_2')	 
	end if

	if IsNull(ldsPicked.GetItemString(llRowPos,'address_3'))	 Then	
		ls_add3 = ''
	else
		ls_add3 = ldsPicked.GetItemString(llRowPos,'address_3')
	end if

	if IsNull(ldsPicked.GetItemString(llRowPos,'address_4'))	 Then	
		ls_add4 = ''
	else
		ls_add4 = ldsPicked.GetItemString(llRowPos,'address_4') 	
	end if

	lsOutString += + '"' + ls_add1 + ' ' + ls_add2 + ' ' + ls_add3 + ' ' +  ls_add4 +  + '",'
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'city')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'city') + ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'state')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'state') + ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'zip'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'zip')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'country'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'country')+ ','
	end if

	lsOutString += '' + ',' //Early Pickup Date
	lsOutString += '' + ',' //Early Pickup Time
			
	if IsNull(ldsPicked.GetItemDateTime(llRowPos,'ord_date'))	 Then		
		lsOutString += ','	
		lsOutString += ','	
	else		
		lsOutString += String(ldsPicked.GetItemDateTime(llRowPos,'ord_date'),'MM.DD.YYYY') + ',' //Late Pickup Date
		lsOutString += String(ldsPicked.GetItemDateTime(llRowPos,'ord_date'),'hh:mm') + ',' // Late Pickup Time
	end if
	lsOutString += '' + ',' //Early Delivery Date
	lsOutString += '' + ',' //Early Delivery Time
	lsOutString += '' + ',' //Late Delivery Date
	lsOutString += '' + ',' //Late Delivery Time
	
	if (Upper(ldsPicked.GetItemString(llRowPos,'Freight_Terms')) = 'PREPAID') Then			
		lsOutString += 'PPD,'
	elseif (Upper(ldsPicked.GetItemString(llRowPos,'Freight_Terms')) = 'PREPAIDADD') Then		
		lsOutString += 'PPC,'
	else
		lsOutString += ','
	end if
	
	lsOutString += '' + ',' //Bill To
	
	if IsNull(ldsPicked.GetItemString(llRowPos,'Transport_Mode')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'Transport_Mode')+ ','
	end if
	
	lsOutString += '' + ',' //Date Emphasis
	
	if IsNull(ldsPicked.GetItemString(llRowPos,'remark'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'remark') + ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'shipping_instructions'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'shipping_instructions') + ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'Scac_Code'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'Scac_Code')+ ','
	end if		

	if IsNull(ldsPicked.GetItemString(llRowPos,'carrier_pro')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'carrier_pro')+ ','
	end if
	
	lsOutString += '' + ',' //ZWF_NOLT
			
	if IsNull(ldsPicked.GetItemNumber(llRowPos,'TOTVol'))	 Then		
		lsOutString += ','	
	else		

		lsOutString += String(ldsPicked.GetItemNumber(llRowPos,'TOTVol'))+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'volumeUOM'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'VolumeUOM')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'awb_bol_no')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'awb_bol_no')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'Cust_Order_No')) Then			
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'Cust_Order_No')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemNumber(llRowPos,'line_item_no'))	 Then		
		lsOutString += ','	
	else		
		lsOutString += String(ldsPicked.GetItemNumber(llRowPos,'line_item_no'))+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'sku'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'sku')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemNumber(llRowPos,'Alloc_Qty'))	 Then		
		lsOutString += ','	
	else		
		lsOutString += String(ldsPicked.GetItemNumber(llRowPos,'Alloc_Qty'))+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemNumber(llRowPos,'TotWght')) Then			
		lsOutString += ','	
	else		
		lsOutString += String(ldsPicked.GetItemNumber(llRowPos,'TotWght'))+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'WeightUOM'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'WeightUOM')+ ','
	end if		
			
	if IsNull(ldsPicked.GetItemString(llRowPos,'Hazard_Cd'))	 Then		
		lsOutString += ','	
	else		
		lsOutString +=  ldsPicked.GetItemString(llRowPos,'Hazard_Cd')+ ','
	end if	
	
	ldsOut.SetItem(llNewRow,'OutString', lsOutString)
	
next /*next output record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
//gu_nvo_process_files.uf_process_flatfile_outbound_unicode(ldsOut,lsProject)

// Export the data to the file location
lsFileNamePath = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsFileName  
liRC = ldsOut.saveas(lsFileNamePath,TEXT!,false)
lsLogOut = 'Processed Orders sent to OTM Report Save As Return Code: ' + string(liRC)
FileWrite(gilogFileNo,lsLogOut)
lsLogOut = 'Processed Orders to OTM Report Finished'
FileWrite(gilogFileNo,lsLogOut)
lsLogOut = '**********************************'
FileWrite(gilogFileNo,lsLogOut)


/* Now e-mailing the Report */

Select Code_Descript into :lsEmail
From Lookup_Table
Where Project_Id = :lsProject and code_type = 'OTMEXTRACTEMAIL';
	
If lsEmail > '' Then
	gu_nvo_process_files.uf_send_email(lsProject,lsemail , "Process Orders sent to OTM for Project = " + lsProject + ", Database = " + sqlca.database + ", File Name = " + lsfilename, "Attached is the file containing Orders sent to OTM ", lsFileNamePath)
End If

Return 0
end function

on u_nvo_edi_confirmations_friedrich.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_friedrich.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

