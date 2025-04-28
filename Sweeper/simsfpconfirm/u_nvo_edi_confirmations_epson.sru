HA$PBExportHeader$u_nvo_edi_confirmations_epson.sru
$PBExportComments$Process outbound edi confirmation transactions for Powerwave
forward
global type u_nvo_edi_confirmations_epson from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_epson from nonvisualobject
end type
global u_nvo_edi_confirmations_epson u_nvo_edi_confirmations_epson

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsSerial
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
Long 		llSerialCount, llRowPos2, llDetailCount		
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsCarrierCode, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsSkuDescript

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound, lbIsPackage = false
Long			llNewRowSerial

long llqty_3
long ll_Remainder
Decimal ldQty, ldDifference

Long llDetailFind, llPickFind

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

//Carton Serial Numbers
If Not isvalid(idsSerial) Then
	idsSerial = Create Datastore
	idsSerial.Dataobject = 'd_do_carton_serial_by_dono'
	idsSerial.SetTransObject(SQLCA)
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

llSerialCount = idsSerial.Retrieve(asDoNo)



//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

idsDoPick.SetSort("line_item_no A sku A")
idsDoPick.Sort()

//Write the rows to the generic output table - delimited by '|'

llRowCount = idsDoPack.RowCount()

For llRowPos = 1 to llRowCOunt

	lsSku = idsDoPack.GetITEmString(llRowPos,'sku')
	lsSuppCode =  idsDoPack.GetITEmString(llRowPos,'supp_code')
	lsLineItemNo = String(idsDoPack.GetITemNumber(llRowPos, 'Line_item_No'))
	lscarton = idsDoPack.GetITEmString(llRowPos,'carton_no')
	ldQty =  idsDoPack.GetITemNumber(llRowPos,'quantity') 
	
	SELECT Item_Master.Description,  qty_3 
	   INTO :lsSkuDescript, :llqty_3  
   	FROM Item_Master  
	Where project_id = :asproject and sku = :lsSku and supp_code = :lsSuppCode;

	if IsNull(llqty_3) then llqty_3 = 0

	ll_Remainder = Mod ( ldQty, llqty_3 )   

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())

//	MessageBox ("llDetailFind" + string(llRowPos), string(llDetailFind))

	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

	llPickFind = idsDoPick.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPick.RowCount())

//	MessageBox ("llPackFind" + string(llRowPos), string(llPickFind))


//	idsSerial.SetFilter("line_item_no="+lsLineItemNo)
	idsSerial.SetFilter("line_item_no="+lsLineItemNo + " and Upper(carton_no) = '" + upper(lsCarton) + "'" ) /* 05/11 - added Carton*/
	idsSerial.Filter()

	if idsSerial.RowCount() > 0 AND ll_Remainder > 0   then
			
		if ll_Remainder > idsSerial.RowCount() then
		
			ldDifference = 	ll_Remainder - idsSerial.RowCount()
			
			 llNewRowSerial = idsSerial.InsertRow( idsSerial.RowCount()+1)
			
			idsSerial.SetItem( llNewRowSerial, "quantity", ldDifference )
			idsSerial.SetItem( llNewRowSerial, "serial_no", "" )
			
		end if		
	
		llDetailCount = idsSerial.RowCount()
		llSerialCount = idsSerial.RowCount()
		
		lbIsPackage = true

		
	else

		llDetailCount = 1
		llSerialCount = 0
		
		lbIsPackage = false		
		
	end if

//	MessageBox (string(llRowPos), llDetailCount)

	for llRowPos2 = 1 to llDetailCount

		llNewRow = idsOut.insertRow(0)
	
	
		//Field Name	Type	Req.	Default	Description
		//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GI$$HEX2$$1d200900$$ENDHEX$$Goods issue confirmation identifier
		lsOutString = 'GI|' 
		
		//Project ID	C(10)	Yes	N/A	Project identifier
		
		lsOutString +=  asproject + '|'
		
		//Warehouse	C(10)	Yes		Shipping Warehouse
		
		lsOutString += idsDoMain.GetItemString(1,'wh_code') + '|'
		
		//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
		
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + '|'	
		
		//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
		
		lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + "|" 
		
		//SKU	C(50)	Yes	N/A	Material number
	
		lsOutString += lsSku  + "|"	
		
		//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
		
		if llSerialCount > 0 then

			lsOutString += String(idsSerial.GetItemNumber( llRowPos2,'quantity'), "0.00000") + "|"
		
			
		else
		
			lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity'), "0.00000") + "|"
			
		end if
		
		//Inventory Type	C(1)	Yes	N/A	Item condition
		
	
		lsOutString += String( idsdoPick.GetITemString(llPickFind,'Inventory_Type')) + "|"
		
		//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
		
		lsTemp = idsdoPick.GetITemString(llPickFind,'Lot_No')
		
		If IsNull(lsTemp) OR trim(lsTemp) = '-' then lsTemp = ''
		
		lsOutString += lsTemp+ "|"	
			
		//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	
		lsTemp =  idsDoMain.GetItemString(1,'cust_order_no') 
		
		If IsNull(lsTemp) OR trim(lsTemp) = '-' then lsTemp = ''
		
		lsOutString += lsTemp+ "|"		
		
		//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	
		lsTemp = idsdoPick.GetITemString(llPickFind,'PO_No2')
		
		If IsNull(lsTemp)  OR trim(lsTemp) = '-' then lsTemp = ''
		
		lsOutString += lsTemp+ "|"			
		
		//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	
		if llSerialCount > 0 then
			
			lsTemp = idsSerial.GetITemString( llRowPos2,'serial_no')

			
		else
	
			lsTemp = idsdoPick.GetITemString(llPickFind,'Serial_No')
		
		end if
		
		If IsNull(lsTemp) OR trim(lsTemp) = '-' then lsTemp = ''
		
		lsOutString += lsTemp+ "|"		
		
		//Container ID	C(25)	No	N/A	
	

		lsTemp =  idsDoPack.GetItemString(llRowPos,'carton_no')
		
		//	lsTemp = String( idsdoPick.GetITemString(llRowPos,'Container_ID'))
	
		If IsNull(lsTemp) OR trim(lsTemp) = '-' or lbIsPackage then lsTemp = ''
	
		lsOutString += lsTemp + "|"		
		
		//Expiration Date	Date	No	N/A	
	
		lsOutString += String( idsdoPick.GetITemDateTime(llPickFind,'Expiration_Date'),'yyyymmdd') + "|"	
	
		//Price	N(12,4)	No	N/A	
		
		lsTemp = String(idsDoDetail.GetItemDecimal(llDetailFind, "Price"))
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"	
		
		
		//Ship Date	Date	No	N/A	Actual Ship date
	
		lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmdd') 
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"	
	
		//Ship Time	No	N/A	Actual Ship time
	
		lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'hh:mm') 
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"	
		
		//Package Count	N(5,0)	No	N/A	Total no. of package in delivery
	
		lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"	
		
		
		
		//Ship Tracking Number	C(25)	No	N/A	
		
		If idsDoMain.GetItemString(1,'Ship_Ref') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + '|'
		Else
			lsOutString += "|"
		End If				
		
		//Carrier	C (20)	No	N/A	Input by user
		
		lsTemp = trim(idsDoMain.GetItemString(1,'Carrier'))
		
		If lsTemp  <> '' Then
						
			select carrier_code INTO :lsCarrierCode from carrier_master
				where project_id = :asproject AND carrier_name = :lsTemp ;
				
			IF SQLCA.SQLCode = 100 OR SQLCA.SQLCode < 0 THEN
				lsCarrierCode = lsTemp
			END IF
			
			If IsNull(lsCarrierCode) then lsCarrierCode = ''
				
			lsOutString += lsCarrierCode + '|'
		Else
			lsOutString += "|"
		End If				
		
		
		//Freight Cost	N(10,3)	No	N/A	
		
		lsFreight_Cost = String(idsDoMain.GetItemDecimal(1,'Freight_Cost'), "0.000")
	
		IF IsNull(lsFreight_Cost) then lsFreight_Cost = ""
		
		lsOutString += lsFreight_Cost + '|'
			
		
		//Freight Terms	C(20)	No	N/A	
		
		If idsDoMain.GetItemString(1,'Freight_Terms') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'Freight_Terms')) + '|'
		Else
			lsOutString += "|"
		End If				
		
		//Total Weight	N(12,2)	No	N/A	
		
		if  lbIsPackage then

			lsTemp = String( idsDoPack.GetItemDecimal(llRowPos,'weight_net'), "0.00") 
		
		else 
		
			lsTemp = String( idsDoPack.GetItemDecimal(llRowPos,'weight_gross'), "0.00") 

		end if
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"		
		
		
		//Transportation Mode	C(10)	No	N/A	
		
		If idsDoMain.GetItemString(1,'transport_mode') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'transport_mode')) + '|'
		Else
			lsOutString += "|"
		End If			
	
		
		//Delivery Date	Date	No	N/A	
		
		lsTemp = String( idsDoMain.GetItemDateTime(1,'Delivery_Date'),'yyyymmdd') 
		
		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString += lsTemp+ "|"		
		
	//	//Detail User Field1	C(20)	No	N/A	User Field
		
	//	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
	//		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + '|'
	//	Else
	//		lsOutString += "|"
	//	End If	
	
		//Detail User Field1	C(20)	No	N/A	User Field
		
		lsTemp =  idsDoPack.GetItemString(llRowPos,'carton_no')

		IF lbIsPackage then lsTemp = ""
		
	//	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		If lsTemp <> '' Then
			lsOutString += lsTemp + '|'
		Else
			lsOutString += "|"
		End If	
	
	
		
		//Detail User Field2	C(20)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field2') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field2')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Detail User Field3	C(30)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Detail User Field4	C(30)	No	N/A	User Field
	
		//Storing SSCC Number on Packing List. (Was UF4)
		
		lsTemp =  idsDoPack.GetItemString(llRowPos,'user_field2')

		If IsNull(lsTemp) then lsTemp = ''
		
		lsOutString +=  lsTemp +  "|"
		
	//	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
	//		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + '|'
	//	Else
	//		lsOutString += "|"
	//	End If		
		
		//Detail User Field5	C(30)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field5') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field5')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Detail User Field6	C(30)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field6')) + '|'
		Else
			lsOutString += "|"
		End If			
		
		//Detail User Field7	C(30)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field7') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field7')) + '|'
		Else
			lsOutString += "|"
		End If			
		
		//Detail User Field8	C(30)	No	N/A	User Field
		
		If idsdoDetail.GetItemString(llDetailFind,'user_field8') <> '' Then
			lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field8')) + '|'
		Else
			lsOutString += "|"
		End If			
		
	
		//Master User Field1	C(10)	No	N/A	User Field	
		
		If idsDoMain.GetItemString(1,'user_field1') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field1')) + '|'
		Else
			lsOutString += "|"
		End If	
		
		//Master User Field2	C(10)	No	N/A	User Field
		
		
		If idsDoMain.GetItemString(1,'user_field2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field2')) + '|'
		Else
			lsOutString += "|"
		End If		
	
		//Master User Field3	C(10)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field3') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field3')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Master User Field4	C(20)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field4') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field4')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Master User Field5	C(20)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field5') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field5')) + '|'
		Else
			lsOutString += "|"
		End If	
			
		//Master User Field6	C(20)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field6') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field6')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Master User Field7	C(30)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field7') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field7')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Master User Field8	C(60)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field8') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field8')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Master User Field9	C(30)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field9') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field9')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field10	C(30)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field10') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field11	C(30)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field11') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field11')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field12	C(50)	No	N/A	User Field

		
		//Ship Tracking Number	C(25)	No	N/A	
		
		IF lbIsPackage Then
		
			If idsDoMain.GetItemString(1,'Ship_Ref') <> '' Then
				lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + '|'
			Else
				lsOutString += "|"
			End If			
		
//		If idsDoMain.GetItemString(1,'user_field12') <> '' Then
//			lsOutString += String(idsDoMain.GetItemString(1,'user_field12')) + '|'

		Else
			lsOutString += "|"
		End If		
		
		//Master User Field13	C(50)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field13') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field13')) + '|'
		Else
			lsOutString += "|"
		End If	
		
		//Master User Field14	C(50)	No	N/A	User Field
	
		If idsDoMain.GetItemString(1,'user_field14') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field14')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field15	C(50)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field15') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field15')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field16	C(100)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field16') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field16')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field17	C(100)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field17') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field17')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//Master User Field18	C(100)	No	N/A	User Field
		
		If idsDoMain.GetItemString(1,'user_field18') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) + '|'
		Else
			lsOutString += "|"
		End If		
	
		//Customer_Name
		
		If idsDoMain.GetItemString(1,'Cust_Name') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'Cust_Name')) + '|'
		Else
			lsOutString += "|"
		End If			
		
		//Customer_Code_Qualifier
		
	//	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
	//		lsOutString += String(left(idsdoDetail.GetItemString(llDetailFind,'user_field4'),2)) + '|'
	//	Else
			lsOutString += "1|"
	//	End If			
	
	//	If idsDoMain.GetItemString(1,'Cust_Code') <> '' Then
	//		lsOutString += String(idsDoMain.GetItemString(1,'Cust_Code')) + '|'
	//	Else
	//		lsOutString += "|"
	//	End If			
		
		//Customer_Code_Code
		
	//	If idsDoMain.GetItemString(1,'Cust_Code') <> '' Then
	//		lsOutString += String(idsDoMain.GetItemString(1,'Cust_Code')) + '|'
	//	Else
	//		lsOutString += "|"
	//	End If		
	
		If idsDoMain.GetItemString(1,'user_field10') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'user_field10')) + '|'
		Else
			lsOutString += "|"
		End If		
		
	
		//Customer_Address_1
		
		If idsDoMain.GetItemString(1,'address_1') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + '|'
		Else
			lsOutString += "|"
		End If		
	
		//Customer_Address_2
		
		If idsDoMain.GetItemString(1,'address_2') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//City
		
		If idsDoMain.GetItemString(1,'city') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'city')) + '|'
		Else
			lsOutString += "|"
		End If		
		
		//State
		
		If idsDoMain.GetItemString(1,'state') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'state')) + '|'
		Else
			lsOutString += "|"
		End If			
	
		//Postal Code
		
		If idsDoMain.GetItemString(1,'zip') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'zip')) + '|'
		Else
			lsOutString += "|"
		End If			
	
		//BOL Number
		
		If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
			lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + '|'
		Else
			lsOutString += "|"
		End If	
	
		//Sku Description
		
		If lsSkuDescript <> '' Then
			lsOutString += lsSkuDescript + '|'
		Else
			lsOutString += "|"
		End If			
	
		
		//PO_Date
		
		
		If String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmdd')  <> '' Then
			lsOutString += String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmdd') 
	//	Else
	//		lsOutString += "|"
		End If	
				
				
			
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'N856' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	next

next /*next Delivery Detail record */

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

on u_nvo_edi_confirmations_epson.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_epson.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

