$PBExportHeader$u_nvo_edi_confirmations_nike.sru
$PBExportComments$Process outbound edi confirmation transactions for Powerwave
forward
global type u_nvo_edi_confirmations_nike from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_nike from nonvisualobject
end type
global u_nvo_edi_confirmations_nike u_nvo_edi_confirmations_nike

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	idsDoDeliveryStatus, &
				idsOut
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_void (string asproject, string asdono)
public function integer uf_gr_adjustment (string asproject, string asrono)
public function string uf_pad_text (string as_text, integer ai_total_width, string as_type)
public function integer uf_dst (string asproject, string asdono, string asstatus)
public function integer uf_adjustment (string asproject, long aladjustid, long aitransid)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo

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
	idsDoPick.Dataobject = 'd_do_Picking'
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

//Write the rows to the generic output table - delimited by lsDelimitChar

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



	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	“GI”	Goods issue confirmation identifier
	lsOutString = 'GI' + lsDelimitChar

	
	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsOutString +=  asproject + lsDelimitChar

	
	//Warehouse	C(10)	Yes		Shipping Warehouse
	
	lsOutString += idsDoMain.GetItemString(1,'wh_code') + lsDelimitChar
	
	//Delivery Number	C(10)	Yes	N/A	Delivery Order Number

	lsTemp =   idsdoDetail.GetItemString(llDetailFind,'user_field1')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString +=  lsTemp + lsDelimitChar	


	//lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	


	//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
	
//	lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar

	lsOutString += String(idsdoDetail.GetITemString(llDetailFind, 'user_field6')) + lsDelimitChar
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += left(lsSku, 10)  + lsDelimitChar	
	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	
	
	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
	//Inventory Type	C(1)	Yes	N/A	Item condition
	
	lsTemp = idsdoPick.GetITemString(llRowPos,'Inventory_Type')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp + lsDelimitChar
	
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

	if llPackFind > 0 then 
		lsTemp = idsDoPack.GetItemString(llPackFind,'carton_no')
	end if
	
//	lsTemp = idsdoPick.GetITemString(llRowPos,'Container_ID')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsTemp =  mid(idsDoMain.GetItemString(1,'Invoice_no'), 4) + trim(lsTemp)

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar		

	//Price	N(12,4)	No	N/A	
	
	lsTemp = String(idsdoPick.GetItemDecimal(llDetailFind, "Price"))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//Ship Date	Date	No	N/A	Actual Ship date

	lsTemp = String( idsDoMain.GetItemDateTime(1,"schedule_date"),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery

	lsTemp = String(1)  	
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	
		
//	If idsDoMain.GetItemString(1,'Ship_Ref') <> '' Then
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	  //String(idsDoMain.GetItemString(1,'Ship_Ref'))
//	Else
//		lsOutString += lsDelimitChar
//	End If				
	
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

//	//Ship Address 4	
//	
//	If idsDoMain.GetItemString(1,'address_4') <> '' Then
//		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
//	Else
//		lsOutString +=lsDelimitChar
//	End If	
	
	
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

	lsOutString += "KG" + lsDelimitChar


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
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp

DEcimal		ldBatchSeq
Integer		liRC
Long llLineItemNo

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

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier
		
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar

	//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number

	lsOutString += idsROMain.GetItemString(1,'supp_order_no') + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number

	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	llLineItemNo = idsroputaway.GetItemNumber(llRowPos,'line_item_no')
//	lsCOO
	
	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity

	lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field

	If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field

	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
	If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present

	If idsroputaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Container ID	C(25)	No	N/A	

	If idsroputaway.GetItemString(llRowPos,'container_id') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Expiration Date	Date	No	N/A	

	If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document

	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
	
	If trim(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) <> '' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
	
	llFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' and line_item_no = " + string(llLineItemNo), 1, idsRODetail.RowCount())
	
	//Detail User Field1	C(50)	No	N/A	User Field

	If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'user_field1') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field2	C(50)	No	N/A	User Field

	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field2') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field3	C(50)	No	N/A	User Field
	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field3') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field4	C(50)	No	N/A	User Field
	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field4') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Detail User Field5	C(50)	No	N/A	User Field
	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field5') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field6	C(50)	No	N/A	User Field

	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'user_field6') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	//Master User Field1	C(10)	No	N/A	User Field

	If idsROMain.GetItemString(1,'user_field1') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field2	C(10)	No	N/A	User Field

	If idsROMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field3	C(10)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Master User Field4	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field5	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field6	C(20)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field7	C(30)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field8	C(30)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field9	C(255)	No	N/A	User Field
	
		If idsROMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field10	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field11	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field12	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field13	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Master User Field14	C(255)	No	N/A	User Field
	
	If idsROMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field15	C(255)	No	N/A	User Field
		
	If idsROMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//MEA 01-NOV-2011: Added Columns for Baseline

	//Carrier
		
	If idsROMain.GetItemString(1,'carrier') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Country Of Origin
	
	If llFindRow > 0 AND  idsRODetail.GetItemString(llFindRow,'country_of_origin') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'country_of_origin')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
		
	//UnitOfMeasure
	
	If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'uom') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
	
	//AWB #
	
	If idsROMain.GetItemString(1,'AWB_BOL_No') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'AWB_BOL_No')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
			
	//Division

	//Get from Item_Master

	Select grp INTO :lsGrp From Item_Master
		Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
		USING SQLCA;
		
	If IsNull(lsGrp) then lsGrp = ''

	lsOutString += lsGrp  // Last item in GR so no Delimeter


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

public function integer uf_void (string asproject, string asdono);////Prepare a Void Transaction for Baseline Unicode for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo

String 	ls_whcode, ls_invoice_no

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

String ls_field_text

//Long llDetailFind

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

//If Not isvalid(idsDoPick) Then
//	idsDoPick = Create Datastore
//	idsDoPick.Dataobject = 'd_do_Picking'
//	idsDoPick.SetTransObject(SQLCA)
//End If


idsOut.Reset()

lsLogOut = "        Creating Void For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0
idsDoDetail.Retrieve(asDoNo)

//idsDoPick.Retrieve(asDoNo)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoDetail.RowCount()

For llRowPos = 1 to llRowCount

	llNewRow = idsOut.insertRow(0)

	lsSku = idsDoDetail.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsDoDetail.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsDoDetail.GetITemNumber(llRowPos, 'Line_item_No'))

	ls_whcode = idsdoMain.GetITemString(1,'wh_code')
	ls_invoice_no = idsdoMain.GetITemString(1,'invoice_no')


//	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
//	IF llDetailFind <= 0 then 
//		continue
//	End If
//
	 // 1. Record Type set Default value 'TUA'        
	 
	 lsOutString = 'TUA' + lsDelimitChar
	 
	 // 2. Record number ( The value should be confirm rowcount N10 ) 

//	 ls_field_text = string(ll_index)
// 	 ls_field_text = wf_pad_text(ls_field_text,10,'N')
//	 lsOutString1 += ls_field_text

	 lsOutString += string(llRowCount) + lsDelimitChar
 
	 
	 // 3. Transaction code Default value 'SHIP'

//	 ls_field_text = "SHIP" 
//	 lsOutString1 += ls_field_text

	 lsOutString += "SHIP"  + lsDelimitChar

	 
	 // 4. Transaction Date (date format should be YYYYMMDD)

	 ls_field_text = string(today(),'YYYYMMDD')
	 lsOutString += ls_field_text + lsDelimitChar
	 
	 // 5. Transaction Time (time format is HHMMSS)
	 ls_field_text = string(now(),'HHMMSS')
	 lsOutString += ls_field_text + lsDelimitChar
	
 	 // 6. Actual unit shipped
	 ls_field_text = ".00"
//	 ls_field_text = wf_pad_text(ls_field_text,12,'N')  
	 lsOutString += ls_field_text + lsDelimitChar
	 
 		
	 // 7.MaterialNumber ( First 6 char SKU + "-"  	+ 3 char from 7th position of SKU 

	 ls_field_text = left(lsSku,10) 
	 lsOutString += ls_field_text + lsDelimitChar
		                               
	 // 8. ItemSizeDesc ( From 10-th pos of SKU to remaining characters.                        	 
	 ls_field_text = mid(lsSku,12)      
	 lsOutString += ls_field_text + lsDelimitChar
												 
	 //9. Stock Category  		 																																
	 ls_field_text =  idsdoDetail.GetITemString(llRowPos,'User_Field5')
 	 If isnull(ls_field_text) THEN ls_field_text = ''
	 lsOutString += ls_field_text + lsDelimitChar													
	 
	 //10. Nike DeliveryNo                   
	 ls_field_text =  idsdoDetail.GetITemString(llRowPos,'User_Field1')
	 
 	 If isnull(ls_field_text) THEN ls_field_text = ''
	 lsOutString += ls_field_text  + lsDelimitChar	                    

	 	                           
//Size_batch = Delivery_Detail.

											
	 //11. Delivery item sequence number

//	 ls_field_text = String(idsdoDetail.GetITemNumber(llRowPos,'Line_Item_No'))
	 
	 ls_field_text = String(idsdoDetail.GetITemString(llRowPos,'user_field6'))
	 
	 
	 If isnull(ls_field_text) THEN ls_field_text = ''
	lsOutString += ls_field_text + lsDelimitChar	
 
 	 //12.Nike Batch Number 
	 ls_field_text = idsdoDetail.GetITemString(llRowPos,'User_Field2')
	 If isnull(ls_field_text) THEN ls_field_text = ''
	lsOutString += ls_field_text + lsDelimitChar	
		
	 //13.Ship Date 
	 ls_field_text = string(today(),'YYYYMMDD')
 	 If isnull(ls_field_text) THEN ls_field_text = ''
	 lsOutString += ls_field_text  + lsDelimitChar	  
 
	 //14. Branch ID (WH Code)  
     ls_field_text = ls_whcode
 	 If isnull(ls_field_text) THEN ls_field_text = ''
	 lsOutString += ls_field_text + lsDelimitChar	 	 
	 	 
	 //15.Unit of Measure 
	 ls_field_text = idsdoDetail.GetITemString(llRowPos,'UOM')
	 If isnull(ls_field_text) THEN ls_field_text = ''
	lsOutString += ls_field_text 

		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	ls_whcode = idsdoMain.GetITemString(1,'wh_code')
	ls_invoice_no = idsdoMain.GetITemString(1,'invoice_no')

	lsFileName =  'CAN' + left(ls_whcode,4) + mid(ls_invoice_no,4) + ".DAT" 	//,10)

	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
next /*next Delivery Detail record */

llNewRow = idsOut.insertRow(0)

                                                                                      
// Write tranaction history about the file. It contains record header, Total number of records, date and time of transaction
 
lsOutString =''
 
// 1. Record TYPE (AN2)		
                         
ls_field_text = 'TR' 
lsOutString += ls_field_text  + lsDelimitChar	 
													
// 2. Total number of records (AN6)    	    
															
ls_field_text = string(llRowCount)						
lsOutString += ls_field_text + lsDelimitChar	  	   	

//3. Date ( AN8 )

ls_field_text=string(today(),'YYYYMMDD')  
lsOutString += ls_field_text + lsDelimitChar	    
												
// 4. TIME ( OPTIONAL AN6)	
	
ls_field_text=string(now(),'HHMMSS')  					
lsOutString += ls_field_text   	   	
	
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llRowCount + 1)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)



ls_whcode = idsdoMain.GetITemString(1,'wh_code')
ls_invoice_no = idsdoMain.GetITemString(1,'invoice_no')

lsFileName =  'CAN' + left(ls_whcode,4) + mid(ls_invoice_no,4) + ".DAT" 	//,10)

idsOut.SetItem(llNewRow,'file_name', lsFileName)

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

Return 0
end function

public function integer uf_gr_adjustment (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long		llRowPos, llRowCount, llFindRow,	llNewRow
String 	 lsUserID, lsSerial, lsLot, lsPO, lsPO2, lsContainer_ID, lsRef, lsOrdType
datetime  ldtToday
				
String		lsFind, lsOutString, lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lsRoNo, lsReason
String 	lsOldInvType, lsNewInvType,  lsOrderNo
Long		llOwnerID, llOrigOwnerID, llNewQty, llOldQty
String 	lsAdjustID, lsTranType, lsRemarks

DEcimal		ldBatchSeq, ldQuantity
Integer		liRC
string 	lsTemp

u_nvo_edi_confirmations_nike	lu_edi_confirmations_nike 

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

//If Not isvalid(idsRODetail) Then
//	idsRODetail = Create Datastore
//	idsRODetail.Dataobject = 'd_ro_detail'
//	idsRODetail.SetTransObject(SQLCA)
//End If


If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()


lsLogOut = "Creating GR - Adjustment For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If



idsroPutaway.Retrieve(asRONO)
//idsroDetail.Retrieve(asRONO)


long llAdjustID
string lsRONO20, lsWarehouse, lsLOC, lsType
u_nvo_edi_confirmations_baseline_unicode  lu_nvo_edi_confirmations_baseline_unicode
datetime ldtExpirationDate

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt

	//Create an Adjustment Record

	lsRONO	 = idsROMain.GetItemString(1,'ro_no')

	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')

	lsCOO = idsroputaway.GetItemString(llRowPos,'Country_of_Origin')
	
	lsWarehouse  = idsROMain.GetItemString(1,'wh_code')
		
	lsLoc = idsroputaway.GetItemString(llRowPos,'L_Code')
	
	
	lsOrderNo  = idsROMain.GetItemString(1,'supp_invoice_no')

	lsroNO = idsROMain.GetITemString(1,'ro_no')

	lsSerial = idsroputaway.GetItemString(llRowPos,'Serial_No')
	lsContainer_ID = idsroputaway.GetItemString(llRowPos,'container_ID')
	
	

	lsLot = idsroputaway.GetItemString(llRowPos,'Lot_No')
	lspo = idsroputaway.GetItemString(llRowPos,'PO_No')
	lspo2 = idsroputaway.GetItemString(llRowPos,'PO_No2')
	ldtExpirationDate= idsroputaway.GetItemDatetime(llRowPos,'Expiration_Date')

	lsOrdType = idsROMain.GetITemString(1,'ord_type')
	
	CHOOSE CASE trim(lsOrdType)
		CASE "1"
			lsReason = "NN1-ADJUST"	  //NN1-    //ADJ-UNIT INCREASE
		CASE "2"
			lsReason = "NN8-MISC"      //NN8-     //ADJ-MISC INCREASE
		CASE "3"
			lsReason = "N26-IMPORT"   //N26-  //ADJ-IMPORT SHIPPING INCREASE
	END CHOOSE
	
	If isnull(lsReason) then lsReason = ''

	lsType = idsroputaway.GetITemString(llRowPos,"inventory_type")

	llOwnerID = idsroputaway.GetITemNumber(llRowPos,"Owner_ID")

	lsAdjustID = lsroNO // idsroputaway.GetITemNumber(1,"adjust_no")

	llNewQty = idsroputaway.GetITemNumber(llRowPos,"quantity")
	lloldQty = 0

	lsRef = "GR-ADJ"

	lsUserID =sqlca.logid
	ldtToday = datetime( today(), now())

//	Insert Into Adjustment (project_id,sku,Supp_Code,old_owner, owner_id,country_of_origin, old_country_of_origin,&
//									wh_code,l_code,old_inventory_type,inventory_type,serial_no,lot_no,po_no,po_no2,old_po_no2,
//									container_ID, expiration_date, ro_no,old_quantity,quantity,ref_no,reason,last_user,last_update, Adjustment_Type,
//									old_lot_no,remarks) 
//	values						(:asProject,:lsSku,:lsSuppCode,:llOwnerID,:llOwnerID, :lsCOO,:lsCOO,:lsWarehouse,:lsLoc,:lsType,:lsType, &
//									:lsSerial,:lsLot,:lspo,:lspo2,:lspo2, :lsContainer_ID, :ldtExpirationDate,:lsRONO,:lloldQty,:llNewQty,:lsRef,:lsReason,:lsUserID,:ldtToday,:lsType,
//									:lsLot,:lsremarks)  //GAP 11/02 Added cont/exp.date here  --// TAM 2005/04/18  Added Adjustment type from radio button selected., 11/11 - PCONKL -Added remarks
//	Using SQLCA;
//	
//		
//	If Sqlca.sqlcode <> 0  Then
////		Execute Immediate "ROLLBACK" using SQLCA;
//		MessageBox("Stock Adjustment_Create","Unable to create new stock adjustment: ~r~r" + sqlca.sqlerrtext)
//		Return -1	
//	End IF

//	lsRONO20 = MID(lsRoNo,1,20)
//
//	// Since it is auto generated by the DB, we need to retrieve it
//	Select Max(Adjust_no) into :llAdjustID
//	From	 Adjustment
//	Where project_id = :asProject and ro_no = :lsrono20 and sku = :lsSku and supp_code = :lsSuppCode and last_user = :lsUserID and last_update = :ldtToday;
//
//	//Don't Need
//	//Insert Into Batch Transaction
//
//	//	Insert Into batch_Transaction (project_ID, Trans_Type, Trans_Order_ID, Trans_Status, Trans_Create_Date)
//	//					Values(:asProject, 'MM', :llAdjustID,'N',  getdate() ) USING SQLCA;
//	//
//	IF llAdjustID > 0 then
//
//		If Not isvalid(lu_edi_confirmations_nike) Then
//			lu_edi_confirmations_nike = Create u_nvo_edi_confirmations_nike
//		End If		
//		
//		liRC = lu_edi_confirmations_nike.uf_adjustment(asProject, llAdjustID, 0)
//		
//	END IF

///---

	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	“MM”	Material movement identifier

	lsOutString = 'MM' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar
		
	//Warehouse	C(10)	Yes	N/A	Shipping Warehouse
	
	lsOutString +=  lsWarehouse + lsDelimitChar
	
	//Movement Type	C(1)	Yes	N/A	Movement type
	
	lsOutString += left(lsTranType,1) + lsDelimitChar
	
	//Date	Date	Yes	N/A	Transaction date 
	
	lsOutString += String(today(),'yyyy-mm-dd') + lsDelimitChar
	
	//Reason	C(40)	No	N/A	Reason for movement
	
	If IsNull(lsReason) then lsReason = ''
	
	lsOutString += lsReason + lsDelimitChar /*reason*/	
	
	//SKU	C(26)	Yes	N/A	Material number
	
	lsOutString += left(lsSku, 10) + lsDelimitChar
	
	//Suppler Code	C(20)	Yes	N/A	
	
	lsOutString += lsSuppCode + lsDelimitChar	
	
	//Container ID	C(25)	No	N/A	
	
	If IsNull(lsContainer_ID) then lsContainer_ID = ''
	
	If  lsContainer_ID <> '-' Then
		lsOutString += lsContainer_ID  + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( ldtExpirationDate,'yyyy-mm-dd') + lsDelimitChar
	
	
	//Transaction Number	C(18)	No	N/A	Internal reference number
	
	lsOutString +=  Left(lsAdjustID, 18) + lsDelimitChar /*Internal Ref #*/ //Left(String(alAdjustID,'0000000000000000'),18) 
	 
	//Reference Number	C(16)	No	N/A	External reference number
	
	lsOutString += left(lsAdjustID,16) + lsDelimitChar /*External Ref #*/	 //String(alAdjustID,'0000000000000000')
	
	//Old Quantity	N(15,5)	No	N/A	Quantity before adjustment
	
	lsOutString += String(llOldQty,'0')  + lsDelimitChar 	
	
	//New Quantity	N(15,5)	No	N/A	Quantity after adjustment
	
	lsOutString += String(llNewQty,'0')  + lsDelimitChar	
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	lsTemp = lsSerial // ldsAdjustment.GetITemString(1,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	

	//Old Owner	  C(20)	No	N/A	Owner before adjustment

	
	lsTemp = String(llOwnerID)
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//New Owner	C(20)	No	N/A	Owner after adjustment

	lsTemp = String(llOwnerID)
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		

	
	//Old Inventory Type	C(1)	No	N/A	Original Inventory Type
	
	lsOutString += left(lsOldInvType,1) + lsDelimitChar  /*old Inv Type*/	
	
	//New Inventory Type 	C(1)	No	N/A	New Inventory Type
	
	lsOutString += left(lsNewInvType,1) + lsDelimitChar /*New Inv Type*/	
	
	//Old Country of Origin	C(3)	No	N/A	Country of origin before adjustment

	lsTemp =  lsCOO // ldsAdjustment.GetITemString(1,'old_country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Country of Origin	C(3)	No	N/A	Country of origin after adjustment
	
	lsTemp = lsCOO //ldsAdjustment.GetITemString(1,'country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//Old Lot NBR	C(50)	No	N/A	Lot before adjustment

	lsTemp = lsLot // ldsAdjustment.GetITemString(1,'old_lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Lot NBR	C(50)	No	N/A	Lot after adjustment

	lsTemp = lsLot // ldsAdjustment.GetITemString(1,'lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//Old PO NBR	C(50)	No	N/A	PO before adjustment
	
	lsTemp = lspo // ldsAdjustment.GetITemString(1,'old_po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR	C(50)	No	N/A	PO after adjustment

	lsTemp = lspo // ldsAdjustment.GetITemString(1,'po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Old PO NBR 2	C(50)	No	N/A	PO2 before adjustment

	lsTemp = lspo2 // ldsAdjustment.GetITemString(1,'old_po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR 2	C(50)	No	N/A	PO2 after adjustment		

	lsTemp =  lspo2 //ldsAdjustment.GetITemString(1,'po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp  + lsDelimitChar
	Else
		 lsOutString += lsDelimitChar
	End If			
	
	//BCR 28-DEC-2011: Added 3 more items as part of Geistlich coding...but still Baseline.
	
	//Per Pete: "You can default UOM to ‘EA’ and blanks for UF1. User ID can come from gs_userID"
	
	//MEA  01/12 - For Nike - Getting from Item_Master - UOM
	
	//UnitofMeasure	C(4)	No	N/A			

	lsTemp = idsroputaway.GetItemString(llRowPos,'uom_1')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar
	
	//MEA  01/12 - For Nike - Grabbing from Last_User

	//UserID	C(10)	No	N/A			

	lsTemp =  lsUserID //ldsAdjustment.GetITemString(1,'last_user')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar

	//MEA  01/12 - For Nike - Grabbing from Item_Master - User_Field1
	
	//UserField1	C(50)	No	N/A			
	//Size
	
	lsTemp = mid(lsSku, 12)

	
//	lsTemp = ldsAdjustment.GetITemString(1,'user_field1')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp  // + lsDelimitChar
		
	
	//End 28-DEC-2011
		
	idsOut.Reset()	
		
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
   //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)
	
//End If /* inv type changed*/
		





NEXT

Return 0


end function

public function string uf_pad_text (string as_text, integer ai_total_width, string as_type);// Date      : 19-Sep-2003
// Purpose   : To fill up empty spaces. In case of char data type fill up with empty spaces on the right of the text. In case of numerical values fill up with zeros on left side
    
Integer li_length, li_empty_spaces,li_fill_zero_cnt,li_index
String ls_pad_text,ls_zero_string
    
IF as_type = 'C' THEN 
	
	 li_length = Len(as_text)
                                                                                                
    If li_length = ai_total_width Then
        ls_pad_text=as_text
    End If
                                                                                    
    If li_length > ai_total_width Then
        ls_pad_text = Mid(as_text, 1, ai_total_width)
		  messagebox("DO file creation", " Pls note the data " + as_text + " exceeds the defined length and truncated" )
    End If
    
    li_empty_spaces = ai_total_width - li_length
    
    ls_pad_text = as_text + Space(li_empty_spaces) 
    	 

	 
END IF	 
                     
IF as_type = 'N' THEN 
  	 
	 li_length = Len(as_text)
                                                                                                
    If li_length = ai_total_width Then
        ls_pad_text=as_text
    End If
	 
	 If li_length > ai_total_width Then
        ls_pad_text = Mid(as_text, 1, ai_total_width)
		  messagebox("DO file creation", " Pls note the data " + as_text + " exceeds the defined length and truncated" )
    End If
	 
	 li_fill_zero_cnt = ai_total_width - li_length
	 
	 For li_index = 1 to li_fill_zero_cnt
		ls_zero_string = ls_zero_string + '0'
    END FOR		  
		
    ls_pad_text = ls_zero_string + as_text 
	
END IF	

Return ls_pad_text  

end function

public function integer uf_dst (string asproject, string asdono, string asstatus);//Prepare a DST Transaction for Baseline Unicode for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName
String  	lsTemp

String 	ls_whcode, ls_delivery_no

DEcimal		ldBatchSeq
Integer		liRC

//String ls_field_text

String ls_file_seq


//Long llDetailFind

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

If Not isvalid(idsDoDeliveryStatus) Then
	idsDoDeliveryStatus = Create Datastore
	idsDoDeliveryStatus.Dataobject = 'd_nike_delivery_status'
	idsDoDeliveryStatus.SetTransObject(SQLCA)
End If


idsOut.Reset()

lsLogOut = "        Creating DST For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no'))    Then Return 0

idsDoDeliveryStatus.Retrieve(asDoNo)

//idsDoPick.Retrieve(asDoNo)


//Get the Next Batch Seq Nbr - Used for all writing to generic tables

ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'DST_File','DST')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor DST File.~r~rConfirmation will not be sent to Nike!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoDeliveryStatus.RowCount()

If llRowCount = 0 then
	Return 0
End IF

For llRowPos = 1 to llRowCount

	llNewRow = idsOut.insertRow(0)

	ls_delivery_no = idsDoDeliveryStatus.GetITemString(llRowPos,'delivery_no')
	IF IsNull(ls_delivery_no) then ls_delivery_no = ''
	ls_whcode = idsdoMain.GetITemString(1,'wh_code')
	  
	ls_file_seq = uf_pad_text(string(ldBatchSeq),8,'N')
	lsFileName =   "DST" + left(ls_whcode,4) + ls_file_seq + ".DAT" 	
                 										
	lsOutString = ''
	
	//1. Status Code
	
	 lsOutString = 'DST'  + lsDelimitChar
	
	 // 2. Warehouse code                                            
	 
	 lsTemp = ls_whcode  
	 lsOutString +=  ls_whcode + lsDelimitChar //uf_pad_text(lsTemp,10,'C')
	 
	 //3. Nike DeliveryNo           
							  
	 lsTemp = ls_delivery_no			
	 If isnull(lsTemp) THEN lsTemp = ''
	// ls_field_text = uf_pad_text(lsTemp,15,'C')   
	 lsOutString += lsTemp  + lsDelimitChar                        

	 // 4. Status
	 
	 lsOutString +=  asstatus  + lsDelimitChar    // "AS"
	 
	 // 5. Transaction Date (date format should be YYYYMMDD)
	 lsTemp = string(today(),'YYYYMMDD')
	 lsOutString += lsTemp  + lsDelimitChar
	 
	 // 6. Transaction Time (time format is HHMMSS)
	 lsTemp = string(now(),'HHMMSS')
	 lsOutString += lsTemp  + lsDelimitChar
	
	 // 7. Filler
	 lsTemp = ""
	 //lsTemp = uf_pad_text(ls_field_text,30,'C')  
	 lsOutString += lsTemp 
	 
		 
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
NEXT
                                                                                      
// Write tranaction history about the file. It contains record header, Total number of records, date and time of transaction
 
lsOutString =''

 llNewRow = idsOut.insertRow(0)

 
// 1. Record TYPE (AN2)		
lsTemp = '\\' 
//lsTemp = uf_pad_text(lsTemp,2,'C')            
lsOutString += lsTemp  + lsDelimitChar 	   
													
// 2. Warehouse    	    
lsTemp = ls_whcode
//lsTemp = uf_pad_text(lsTemp,10,'C')      
lsOutString += lsTemp // + lsDelimitChar   	

//// EOF
//lsOutString += "EOF"  + lsDelimitChar
//
//// 4. Total number of records (AN6)    	    
//lsTemp = string(llRowCount)						
////lsTemp = uf_pad_text(lsTemp,8,'N')      	      
//lsOutString += lsTemp  
	
//5. ADD NEW LINE CHARACTER

//ls_field_text='~n'
//ls_trans += ls_field_text  	   
//


idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llRowCount + 1)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
idsOut.SetItem(llNewRow,'file_name', lsFileName)

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)

Return 0



end function

public function integer uf_adjustment (string asproject, long aladjustid, long aitransid);//Prepare a Stock Adjustment Transaction for Baseline Unicode Stock Adjustment just made


Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsRONO, lsOrder, lsPosNeg, lstemp,     &
				lsTransParm, lsFullReason

Decimal		ldBatchSeq, ldNetQty
Integer		liRC
String	lsLogOut
Datastore ldsAdjustment
lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = ldsAdjustment.GetITemString(1,'ro_no')

lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')

lsFullReason = ldsAdjustment.GetITemString(1,'reason') 

lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''

integer liPos

liPos =  Pos(lsReason, '-')

if liPos > 0 then
	
	lsReason = Mid(lsReason, liPos + 1)
	
end if

gu_nvo_process_files.uf_write_log(lsReason) /*display msg to screen*/
lsLogOut = lsReason
FileWrite(gilogFileNo,lsLogOut)	
	
lsOldInvType = ldsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = ldsAdjustment.GetITemString(1,"inventory_type")

llOwnerID = ldsAdjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = ldsAdjustment.GetITemNumber(1,"old_owner")

llAdjustID = ldsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = ldsAdjustment.GetITemNumber(1,"quantity")
lloldQty = ldsAdjustment.GetITemNumber(1,"old_quantity")

		
//We are only sending Qty Change or Breakage (New Inv Type = 'D')
/* dts - 05/22/06 - Now also sending transaction if coming OUT of 'D'.
       - should probably send when inventory moves from Pickable to Non-pickable or vice-versa (Inventory_Shippable_Ind)
		   but C. Geerts assures us that there will be only 'Normal' and 'Damaged' Inventory types */


//BCR 01-DEC-2011: Need to remove this IF statement in order to create the transaction for ALL Adjustments...

//If (lsOldInvType = 'N' and lsNewInvType = 'D') or (lsOldInvType = 'D' and lsNewInvType = 'N') or (llNewQTY <> llOldQTY)  Then
	
	//If lsNewInvType = 'D' Then /* set to Damage*/
	if lsOldInvType <> lsNewInvType then /* Inventory Type adjustment - either Normal-to-Damaged or Damaged-to-Normal */
		//BCR 01-DEC-2011: ICC now require single character for Transaction Types...
//		lsTranType = 'BRK'
		lsTranType = 'I'
	Else /* Process as a qty adjustment*/
//		lsTranType = 'QTY'
		lsTranType = 'Q'
	End If
	
	//BCR 01-DEC-2011: ICC now require single character for Transaction Types...and we have a TranType for Owner Change.
	IF llOrigOwnerID <> llOwnerID  THEN lsTranType = 'O'
	
	//BCR 01-DEC-2011: ...and we have a TranType for Other (i.e., none of the above).
	IF IsNull(lsTranType) OR lsTranType = '' THEN lsTranType = 'X'
		
	//If only the type changed, the qty is either qty, otherwise it is the abs of the difference
	If llNewQty < llOldQty Then
		ldNetQty = llOldQty - llNewQty
		lsPosNeg = '-'
	ElseIf llNewQty > llOldQty Then
		ldNetQty = llNewQty - llOldQty
		lsPosNeg = '+'
	Else /* qty not changed, only Inv Type Did*/
		ldNetQty = llOldQty
		lsPosNeg = '+'
	End If
	
	//MEA - 12/11
//	If lsOldInvType = 'N' OR lsOldInvType = 'T' OR lsNewInvType = 'N' OR lsNewInvType = 'T'  Then Return 0

	//02/12 - MEA - Don't create and MM files with parameter set to 'SKIP'
	// Includes invalid reason code
	// Second part of splits.

	if aitransid > 0 then

		Select Trans_parm into :lsTransParm
		From Batch_Transaction
		Where Trans_ID = :aitransid;
		
	end if

	//Reason = NN6-HOLD
	//Use the original row to generate the EDI

	//AND lsTranType = 'Q'

	If left(lsFullReason,3) = "NN6" AND upper(left(lsTransParm,4)) = 'ROW2'  then
		Return 0
	End IF  

	
	//Reason = NN7-HOLD
	//Use the new added row to generate the EDI

	// AND lsTranType = 'Q' 

	If left(lsFullReason,3) = "NN7" AND upper(left(lsTransParm,4)) = 'ROW1'  then
		Return 0
	End IF 



//	If Trim(Upper(lsReason)) = 'HOLD'  AND upper(left(lsTransParm,5)) = 'SPLIT' Then
//		//Only send for Quantity adjustments
//		If lsTranType <> 'Q' Then Return 0
//	END IF

	If upper(left(lsTransParm,4)) = 'SKIP' Then
		 Return 0
	END IF

	
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	“MM”	Material movement identifier

	lsOutString = 'MM' + lsDelimitChar
	
	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar
		
	//Warehouse	C(10)	Yes	N/A	Shipping Warehouse
	
	lsOutString +=  ldsAdjustment.GetITemString(1,"wh_code") + lsDelimitChar
	
	//Movement Type	C(1)	Yes	N/A	Movement type
	
	lsOutString += left(lsTranType,1) + lsDelimitChar
	
	//Date	Date	Yes	N/A	Transaction date 
	
	lsOutString += String(today(),'yyyy-mm-dd') + lsDelimitChar
	
	//Reason	C(40)	No	N/A	Reason for movement
	
	If IsNull(lsReason) then lsReason = ''
	
	lsOutString += lsReason + lsDelimitChar /*reason*/	
	
	//SKU	C(26)	Yes	N/A	Material number
	
	lsOutString += left(lsSku, 10) + lsDelimitChar
	
	//Suppler Code	C(20)	Yes	N/A	
	
	lsOutString += lsSupplier + lsDelimitChar	
	
	//Container ID	C(25)	No	N/A	
	
	If  ldsAdjustment.GetITemString(1,'Container_ID') <> '-' Then
		lsOutString += String( ldsAdjustment.GetITemString(1,'Container_ID')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	//Expiration Date	Date	No	N/A	

	lsOutString += String( ldsAdjustment.GetITemDateTime(1,'Expiration_Date'),'yyyy-mm-dd') + lsDelimitChar
	
	
	//Transaction Number	C(18)	No	N/A	Internal reference number
	
	lsOutString += Left(String(alAdjustID,'0000000000000000'),18) + lsDelimitChar /*Internal Ref #*/
	
	//Reference Number	C(16)	No	N/A	External reference number
	
	lsOutString += left(String(alAdjustID,'0000000000000000'),16) + lsDelimitChar /*External Ref #*/	
	
	//Old Quantity	N(15,5)	No	N/A	Quantity before adjustment
	
	lsOutString += String(llOldQty,'0')  + lsDelimitChar 	
	
	//New Quantity	N(15,5)	No	N/A	Quantity after adjustment
	
	lsOutString += String(llNewQty,'0')  + lsDelimitChar	
	
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
	lsTemp = ldsAdjustment.GetITemString(1,'Serial_No')
	
	If IsNull(lsTemp) then lsTemp = ''

	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	

	//Old Owner	  C(20)	No	N/A	Owner before adjustment

	
	lsTemp = ldsAdjustment.GetITemString(1,'old_owner_cd')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	
	//New Owner	C(20)	No	N/A	Owner after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'new_owner_cd')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar		

	
	//Old Inventory Type	C(1)	No	N/A	Original Inventory Type
	
	lsOutString += left(lsOldInvType,1) + lsDelimitChar  /*old Inv Type*/	
	
	//New Inventory Type 	C(1)	No	N/A	New Inventory Type
	
	lsOutString += left(lsNewInvType,1) + lsDelimitChar /*New Inv Type*/	
	
	//Old Country of Origin	C(3)	No	N/A	Country of origin before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Country of Origin	C(3)	No	N/A	Country of origin after adjustment
	
	lsTemp = ldsAdjustment.GetITemString(1,'country_of_origin')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar	
	
	//Old Lot NBR	C(50)	No	N/A	Lot before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//New Lot NBR	C(50)	No	N/A	Lot after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'lot_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	//Old PO NBR	C(50)	No	N/A	PO before adjustment
	
	lsTemp = ldsAdjustment.GetITemString(1,'old_po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR	C(50)	No	N/A	PO after adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'po_no')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Old PO NBR 2	C(50)	No	N/A	PO2 before adjustment

	lsTemp = ldsAdjustment.GetITemString(1,'old_po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//New PO NBR 2	C(50)	No	N/A	PO2 after adjustment		

	lsTemp = ldsAdjustment.GetITemString(1,'po_no2')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	If  lsTemp <> '-' Then
		lsOutString += lsTemp  + lsDelimitChar
	Else
		 lsOutString += lsDelimitChar
	End If			
	
	//BCR 28-DEC-2011: Added 3 more items as part of Geistlich coding...but still Baseline.
	
	//Per Pete: "You can default UOM to ‘EA’ and blanks for UF1. User ID can come from gs_userID"
	
	//MEA  01/12 - For Nike - Getting from Item_Master - UOM
	
	//UnitofMeasure	C(4)	No	N/A			

	lsTemp = ldsAdjustment.GetITemString(1,'uom_1')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar
	
	//MEA  01/12 - For Nike - Grabbing from Last_User

	//UserID	C(10)	No	N/A			

	lsTemp =ldsAdjustment.GetITemString(1,'last_user')
	
	If IsNull(lsTemp) then lsTemp = ''

	lsOutString += lsTemp  + lsDelimitChar

	//MEA  01/12 - For Nike - Grabbing from Item_Master - User_Field1
	
	//UserField1	C(50)	No	N/A			
	//Size
	
	lsTemp = mid(lsSku, 12)

	
//	lsTemp = ldsAdjustment.GetITemString(1,'user_field1')
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp  // + lsDelimitChar
		
	
	//End 28-DEC-2011
		
	lsLogOut = lsOutString + ":" + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)	
		
		
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
	lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
   //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)
	
//End If /* inv type changed*/
		


Return 0
end function

on u_nvo_edi_confirmations_nike.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_nike.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

