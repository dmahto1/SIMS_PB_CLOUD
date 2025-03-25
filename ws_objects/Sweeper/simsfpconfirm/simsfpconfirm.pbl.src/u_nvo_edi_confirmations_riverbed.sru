$PBExportHeader$u_nvo_edi_confirmations_riverbed.sru
$PBExportComments$Process outbound edi confirmation transactions for River
forward
global type u_nvo_edi_confirmations_riverbed from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_riverbed from nonvisualobject
end type
global u_nvo_edi_confirmations_riverbed u_nvo_edi_confirmations_riverbed

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsWOMain, idsWODetail, idsWOPutaway, idsWOPick, idsDoBOM, idsOut
				
				
string lsDelimitChar
end variables

forward prototypes
public function integer uf_gi (string asproject, string asdono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function datetime getgmttime (string aswh, datetime adtdatetime)
public function integer uf_gi_save (string asproject, string asdono)
public function integer uf_gw (string asproject, string aswono)
end prototypes

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[], lltemp, llBOMCount
				
String		lsOutString,	lsOutString2, lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsskuparent, lsSuppCode, lsLineItemNo

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound
DateTime	ldtTemp

Long llDetailFind, llPackFind, llBOMFind, llDetailAsParentFind

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
	idsDoPick.Dataobject = 'd_do_Picking_riverbed'
	idsDoPick.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoPack) Then
	idsDoPack = Create Datastore
	idsDoPack.Dataobject = 'd_do_Packing'
	idsDoPack.SetTransObject(SQLCA)
End If

If Not isvalid(idsDoBOM) Then
	idsDoBOM = Create Datastore
	idsDoBOM.Dataobject = 'd_do_bom'
	idsDoBOM.SetTransObject(SQLCA)
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

idsDoBOM.Retrieve(asDoNo)
idsDoBOM.SetSort("user_field2")
idsDoBOM.Sort()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Write the rows to the generic output table - delimited by lsDelimitChar
llBOMCount = idsDoBOM.RowCount()

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSkuParent = idsdoPick.GetITEmString(llRowPos,'sku_parent')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
// Riverbed send a "shippable" flag stored in Detail Line Item Notes or BOM User Field3.  If this flag is "N" then we do not want to send this line
// If found in Detail
	llDetailAsParentFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())

	If llDetailAsParentFind > 0 Then
		If POS(Trim(idsDoDetail.GetItemString(llDetailAsParentFind, "line_item_notes")), "IsShippable:N") > 0 and POS(Trim(idsDoDetail.GetItemString(llDetailAsParentFind, "line_item_notes")), "IsSerialPresent:N") >0 Then
			Continue
		End If
	Else
// Else Look in BOM
string lsfind 
lsfind = "sku_Child='"+lsSku+"' and line_item_no = " + string(lsLineItemNo)
		llBOMFind = idsDoBom.Find(lsfind, 1, idsDoBOM.RowCount())
//		llBOMFind = idsDoBom.Find("sku_Child='"+lsSku+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoBOM.RowCount())
		If llBOMFind > 0 Then
			If  POS(Trim(idsDoBOM.GetItemString(llBOMFind, "user_field3")), "IsShippable:N") > 0  and POS(Trim(idsDoBOM.GetItemString(llBOMFind, "user_field3")), "IsSerialPresent:N") >0 Then
				Continue
			End If
		End If
	End If

	llNewRow = idsOut.insertRow(0)


	llDetailFind = idsDoDetail.Find("sku='"+lsSkuParent+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


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
	
//Strip off -UF9
	lltemp = LastPos ( idsDoMain.GetItemString(1,'Invoice_no'), '-' )
	If llTemp > 0 Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'Invoice_no'), lltemp - 1) + lsDelimitChar
	Else
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar
	End If

	
	//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
	
	lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += lsSku  + lsDelimitChar	
	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity  ***Note - if Serial Number is present then we will have multiple lines for same pick row and quantity must be one for each line
	
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

//	lsOutString += String( idsdoPick.GetITemDateTime(llRowPos,'Expiration_Date'),'yyyymmddhhmmss') + lsDelimitChar		
	lsOutString +=  String( idsDoPick.GetItemDateTime(llRowPos,'Expiration_Date'),'yyyymmdd') + 'T' + String( idsDoPick.GetItemDateTime(llRowPos,'Expiration_Date'),'hhmmss') + '.000Z' + lsDelimitChar	

	//Price	N(12,4)	No	N/A	
	
	//lsTemp = String(idsdoPick.GetItemDecimal(llDetailFind, "Price"))
	//If IsNull(lsTemp) then lsTemp = ''
	//lsOutString += lsTemp+ lsDelimitChar
	lsOutString += '0' + lsDelimitChar	
	
	//Ship Date	Date	No	N/A	Actual Ship date
//	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	ldtTemp = idsDoMain.GetItemDateTime(1, 'complete_date')
	ldtTemp = GetGMTTime(upper(idsDoMain.getItemString(1, 'wh_code')), ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmdd') + "T" + String(ldtTemp, 'hhmmss') + '.000Z' + lsDelimitChar
//	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmmss') + lsDelimitChar
//	If IsNull(lsTemp) then lsTemp = ''
//	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery

	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	
	If idsDoMain.GetItemString(1,'Awb_Bol_No') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Awb_Bol_No')) + lsDelimitChar
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
	
	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmdd') 
	
	If IsNull(lsTemp) then lsTemp = ''

	lsTemp =  String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyymmdd') + 'T' + String( idsDoMain.GetItemDateTime(1,'complete_date'),'hhmmss') + '.000Z'

	lsOutString += lsTemp+ lsDelimitChar	
	
	//Detail User Field1	C(20)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field1') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Serial Number 2	C(50)	No	N/A	Mac_ID
	
	If idsdoPick.GetItemString(llRowPos,'mac_id') <> '' Then
		lsOutString += String(idsdoPick.GetItemString(llRowPos,'mac_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field3	C(30)	No	N/A	User Field
	
	If idsdoDetail.GetItemString(llDetailFind,'user_field3') <> '' Then
		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Serial Number 3	C(50)	No	N/A	sku_substitute
	
	If idsdoPick.GetItemString(llRowPos,'sku_substitute') <> '' Then
		lsOutString += String(idsdoPick.GetItemString(llRowPos,'sku_substitute')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If
//	If idsdoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
//		lsOutString += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If		
	
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
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) //+ lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Master Ship To Name	C(50)	No	N/A	
	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString2 = String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString2 =lsDelimitChar
	End If		

	//Master Customer Code	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString2 += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString2 +=lsDelimitChar
	End If		
		
	
	//Volume 	N(12,2)	No	N/A	
	
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'cbm')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString2 += lsTemp+ lsDelimitChar
	
	//Detail User Field4	C(10)	No	N/A	User Field

// If line came from the Detail then used detail data.
	If llDetailAsParentFind > 0 Then
		If idsDoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
			lsOutString2 += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
		Else
			lsOutString2 += lsDelimitChar
		End If
	Else
// Else Look in BOM
		If llBOMFind > 0 Then
			If idsDoBOM.GetItemString(llBOMFind,'user_field2') <> '' Then
				lsOutString2 += String(idsdoBOM.GetItemString(llBOMFind,'user_field2')) + lsDelimitChar
			Else
				lsOutString2 += lsDelimitChar
			End If
		Else
			lsOutString2 += lsDelimitChar
		End If
	End If
	
	
//	If idsDoDetail.GetItemString(llDetailFind,'user_field4') <> '' Then
//		lsOutString2 += String(idsdoDetail.GetItemString(llDetailFind,'user_field4')) + lsDelimitChar
//	Else
//		lsOutString2 += lsDelimitChar
//	End If	
	
	//Detail Alt SKU	C(50)	No	N/A	
	
	If idsDoDetail.GetItemString(1,'alternate_sku') <> '' Then
		lsOutString2 += String(idsDoDetail.GetItemString(1,'alternate_sku')) + lsDelimitChar
	Else
		lsOutString2 +=lsDelimitChar
	End If		
		
	//Master AwBBOL	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString2 += String(idsDoMain.GetItemString(1,'awb_bol_no')) //+ lsDelimitChar
	Else
//		lsOutString +=lsDelimitChar
	End If		
		
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)
//	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	lsFileName = 'GI' + '_' + idsDoMain.GetItemString(1,'wh_code') + '_' + String(ldBatchSeq,'000000') + '.dat'

idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_gr (string asproject, string asrono);//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO
DateTime ldtTemp
DEcimal		ldBatchSeq
Integer		liRC
Datastore ldsSerial 

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

//12NOV2012: Sarun - No receipt confirmation file to be generated Requested by Tan BoonHee.
If idsROMain.GetItemString(1,'ord_type') =  'M' Then
	lsLogOut = "                  NO EDI generates for Maual Order Type for Inbound Order#" + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return 0
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

	lsOutString = ''
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	//Project ID	C(10)	Yes	N/A	Project identifier

	lsOutString += asproject + lsDelimitChar

	//Warehouse	C(10)	Yes	N/A	Receiving Warehouse

	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number

	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition

	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	
	ldtTemp = idsROMain.GetItemDateTime(1, 'complete_date')
	ldtTemp = GetGMTTime(upper(idsroMain.getItemString(1, 'wh_code')), ldtTemp)
//	lsOutString += String(ldtTemp, 'yyyymmddhhmmss') + lsDelimitChar
//	lsOutString += String(ldtTemp, 'YYYYMMDDTHHmmss.sssZ') + lsDelimitChar
	lsOutString += String(ldtTemp, 'yyyymmdd') + "T" + String(ldtTemp, 'hhmmss') + '.000Z' + lsDelimitChar
//	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmddhhmmss') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number

	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
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
//		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyymmdd') + lsDelimitChar
		lsOutString +=  String( idsroputaway.GetItemDateTime(llRowPos,'Expiration_Date'),'yyyymmdd') + 'T' + String(idsroputaway.GetItemDateTime(llRowPos,'Expiration_Date'),'hhmmss') + '.000Z' + lsDelimitChar
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
	
	llFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())
	
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
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) //+ lsDelimitChar
	Else
//		lsOutString += lsDelimitChar
	End If	
		
	//BCR 14-SEP-2011: Changes for Riverbed...
	
	IF Upper(asproject) = "RIVERBED" THEN
	
		lsOutString += lsDelimitChar
	
		//Order Type C(1)	No	N/A	
			
		If idsROMain.GetItemString(1,'ord_type') <> '' Then
			lsOutString += String(idsROMain.GetItemString(1,'ord_type')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Requested Quantity	C(16)	No	N/A	
			
		If idsRODetail.GetItemNumber(1,'req_qty') <> 0 Then
			lsOutString += String(idsRODetail.GetItemNumber(1,'req_qty')) //+ lsDelimitChar
		Else
			//lsOutString += lsDelimitChar
		End If	
	

	END IF //End Riverbed
	
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GR' + '_' + idsRoMain.GetItemString(1,'wh_code')  + '_' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
	
	
next /*next output record */


If idsOut.RowCount() > 0 Then
//	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)
End If

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Baseline Unicode Stock Adjustment just made


Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsRONO, lsOrder, lsPosNeg, lstemp

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


lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''

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

//If lsNewInvType = 'D' or (llNewQTY <> llOldQTY)  Then
If (lsOldInvType = 'N' and lsNewInvType = 'D') or (lsOldInvType = 'D' and lsNewInvType = 'N') or (llNewQTY <> llOldQTY)  Then
	
	//If lsNewInvType = 'D' Then /* set to Damage*/
	if lsOldInvType <> lsNewInvType then /* Inventory Type adjustment - either Normal-to-Damaged or Damaged-to-Normal */
		lsTranType = 'BRK'
	Else /* Process as a qty adjustment*/
		lsTranType = 'QTY'
	End If
		
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
	
	lsOutString += lsSku + lsDelimitChar
	
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
		lsOutString += lsTemp  //+ lsDelimitChar
	Else
		// lsOutString += lsDelimitChar
	End If				
		
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
	
End If /* inv type changed*/
		


Return 0
end function

public function datetime getgmttime (string aswh, datetime adtdatetime);string lsOffset, lsOffsetFremont
long   llGMTOffset, llTimeSecs
date ldDate
time ltTime, ltTimeNew

	select gmt_offset into :lsOffset
	from warehouse
	where wh_code = :asWH;

// see if subtracting the offset would make it the previous day. If so, subtract a day and the remainder of the Offset.
// - if the offset is negative (West of Fremont), see if adding the offset would make it the next day. If so, add a day and the remainder of Offset
llGMTOffset = long(lsOffset)
llGMTOffset = llGMTOffset * 60 * 60  //convert the offset to seconds
ldDate = date(adtDateTime)
ltTime = time(adtDateTime)
ltTimeNew = ltTime
if llGMTOffset > 0 then
	llTimeSecs = SecondsAfter(time('00:00'), ltTime)
	if llTimeSecs < llGMTOffset then
		ldDate = RelativeDate(ldDate, -1)
		ltTimeNew = RelativeTime(time('23:59:59'), - (llGMTOffset - llTimeSecs))
	else
		ltTimeNew = RelativeTime(ltTime, - llGMTOffset)
	end if
elseif llGMTOffset < 0 then  //Offset is negative
	llTimeSecs = SecondsAfter(ltTime, time('23:59:59')) //seconds remaining in the day
	if llTimeSecs < llGMTOffset then // time remaining in the day is less than the net offset....
		//so add a day and add the remaing time
		ldDate = RelativeDate(ldDate, +1)
		ltTimeNew = RelativeTime(time('00:00'),  (llGMTOffset - llTimeSecs))
	else
		// adding the net offset won't require adding another day
		ltTimeNew = RelativeTime(ltTime, llGMTOffset)
	end if
end if

adtDateTime = DateTime(ldDate, ltTimeNew)
return adtDateTime
end function

public function integer uf_gi_save (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed


Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[], lltemp
				
String		lsOutString,	lsOutString2, lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsskuparent, lsSuppCode, lsLineItemNo

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


//Write the rows to the generic output table - delimited by lsDelimitChar

llRowCount = idsDoPick.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)

	lsSku = idsdoPick.GetITEmString(llRowPos,'sku')
	lsSkuParent = idsdoPick.GetITEmString(llRowPos,'sku_parent')
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))

	llDetailFind = idsDoDetail.Find("sku='"+lsSkuParent+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


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
	
//Strip off -UF9
	lltemp = LastPos ( idsDoMain.GetItemString(1,'Invoice_no'), '-' )
	If llTemp > 0 Then 
		lsOutString += Left(idsDoMain.GetItemString(1,'Invoice_no'), lltemp - 1) + lsDelimitChar
	Else
		lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar
	End If

	
	//Delivery Line Item	N(6,0)	Yes	N/A	Delivery order item line number
	
	lsOutString += String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
	
	//SKU	C(50)	Yes	N/A	Material number


	lsOutString += lsSku  + lsDelimitChar	
	
	//Quantity	N(15,5)	Yes	N/A	Actual shipped quantity
	
	
	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
	
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
	
	lsTemp = String(idsdoPick.GetItemDecimal(llDetailFind, "Price"))
	
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
	
	If idsDoMain.GetItemString(1,'Ship_Ref') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
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
		lsOutString += String(idsDoMain.GetItemString(1,'user_field18')) //+ lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If		
	
	//Master Ship To Name	C(50)	No	N/A	
	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString2 = String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString2 =lsDelimitChar
	End If		

	//Master Customer Code	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString2 += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString2 +=lsDelimitChar
	End If		
		
	
	//Volume 	N(12,2)	No	N/A	
	
	IF llPackFind > 0 then
		lsTemp = String( idsDoPack.GetItemDecimal(llPackFind,'cbm')) 
	Else
		lsTemp = ""	
	End If
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString2 += lsTemp+ lsDelimitChar
	
	//Master User Field3	C(10)	No	N/A	User Field

	If idsDoMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString2 += String(idsDoMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString2 += lsDelimitChar
	End If	
	
	//Detail Alt SKU	C(50)	No	N/A	
	
	If idsDoDetail.GetItemString(1,'alternate_sku') <> '' Then
		lsOutString2 += String(idsDoDetail.GetItemString(1,'alternate_sku')) + lsDelimitChar
	Else
		lsOutString2 +=lsDelimitChar
	End If		
		
	//Master AwBBOL	C(20)	No	N/A	
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		lsOutString2 += String(idsDoMain.GetItemString(1,'awb_bol_no')) //+ lsDelimitChar
	Else
//		lsOutString +=lsDelimitChar
	End If		
		
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	idsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next Delivery Detail record */


//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)



Return 0
end function

public function integer uf_gw (string asproject, string aswono);
//Prepare a Workorder Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,  llPickCount,  llPickPos, llPickDetailCount, llPickDetailPos
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsTemp
DateTime ldtTemp
DEcimal		ldBatchSeq, ldTemp, lddtlqty, ldchildqty
Integer		liRC
Datastore ldsSerial 

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsWoMain) Then
	idsWoMain = Create Datastore
	idsWoMain.Dataobject = 'd_workorder_master'
	idsWoMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsWODetail) Then
	idsWODetail = Create Datastore
	idsWODetail.Dataobject = 'd_workorder_detail_wono'
	idsWODetail.SetTransObject(SQLCA)
End If


If Not isvalid(idsWOPutaway) Then
	idsWOPutaway = Create Datastore
	idsWOPutaway.Dataobject = 'd_workorder_Putaway'
	idsWOPutaway.SetTransObject(SQLCA)
End If

If Not isvalid(idsWOPick) Then
	idsWOPick = Create Datastore
	idsWOPick.Dataobject = 'd_workorder_picking'
	idsWOPick.SetTransObject(SQLCA)
End If

idsOut.Reset()


lsLogOut = "      Creating WO For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsWoMain.Retrieve(asProject, asWoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For WoNo: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If




idsWOPutaway.Retrieve(asWONO)
idsWODetail.Retrieve(asWONO)
idsWOPick.Retrieve(asWONO)


//Ops requested to use Work Order for manual work orders (meaning no EDI from Riverbed, \
//and hence we must not send back EDI to Riverbed). The current design is that EDI will be sent out once the order is confirmed. 
//I’m suggesting that we use Order Infor.User Field2 for ops to key in the wordings “Manual” and once the work order is confirmed, 
//SIMS Sweeper do not generate EDI for such work orders. Is this suggestion feasible, and if yes, what’s the additional IT hours required? 
//If no, do you have other alternatives?

String lsIsManual

lsIsManual = idsWoMain.GetItemString( 1, "user_field2")

IF Trim(Upper(lsIsManual)) = "MANUAL" THEN
	Return 0
End IF



//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	“WM”	Goods receipt confirmation identifier
lsOutString = ''
lsOutString = 'WM'  + lsDelimitChar /*rec type = goods receipt*/

//Project ID	C(10)	Yes	N/A	Project identifier
lsOutString += asproject + lsDelimitChar

//Order Type	Default   "S" (Kit-To-Stock)
lsOutString += 'S' + lsDelimitChar

//Order Date	Date	Yes	N/A	Order date
ldtTemp = idsWoMain.GetItemDateTime(1, 'ord_date')
If Not IsNull(ldtTemp) Then
	ldtTemp = GetGMTTime(upper(idsWoMain.getItemString(1, 'wh_code')), ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmdd') + "T" + String(ldtTemp, 'hhmmss') + '.000Z' + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If

//Schedule Date	Date	Yes	N/A	Schedule date
ldtTemp = idsWoMain.GetItemDateTime(1, 'sched_date')
If Not IsNull(ldtTemp) Then
	ldtTemp = GetGMTTime(upper(idsWoMain.getItemString(1, 'wh_code')), ldtTemp)
	lsOutString += String(ldtTemp, 'yyyymmdd') + "T" + String(ldtTemp, 'hhmmss') + '.000Z' + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If

//Delivery_Invoice_Number	C(20)	Yes	N/A	Delivery Invoice Number
If idsWoMain.GetItemString(1,'delivery_invoice_no') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'delivery_invoice_no')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	

//Workorder_Number	C(20)	Yes	N/A	Workorder Number
lsOutString += upper(idsWoMain.getItemString(1, 'workorder_number'))  + lsDelimitChar

//Priority	D(7.0)	Yes	N/A	Priority
lsOutString += String(idsWoMain.getItemNumber(1, 'priority'))  + lsDelimitChar

//Warehouse	C(10)	Yes	N/A	 Warehouse
lsOutString += upper(idsWoMain.getItemString(1, 'wh_code'))  + lsDelimitChar

//Master User Field1	C(10)	No	N/A	User Field
If idsWoMain.GetItemString(1,'user_field1') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'user_field1')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	
	
//Master User Field2	C(10)	No	N/A	User Field
If idsWoMain.GetItemString(1,'user_field2') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'user_field2')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	

//Master User Field3	C(10)	No	N/A	User Field
If idsWoMain.GetItemString(1,'user_field3') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'user_field3')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	

//Remarks	C(50)	No	N/A	Remarks
If idsWoMain.GetItemString(1,'remarks') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'remarks')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	
	
//Master User Field4	C(50)	No	N/A	User Field
If idsWoMain.GetItemString(1,'user_field4') <> '' Then
	lsOutString += String(idsWoMain.GetItemString(1,'user_field4')) + lsDelimitChar
Else
	lsOutString += lsDelimitChar
End If	

//Complete Date	Date	Yes	N/A	completion date
ldtTemp = idsWoMain.GetItemDateTime(1, 'complete_date')
ldtTemp = GetGMTTime(upper(idsWoMain.getItemString(1, 'wh_code')), ldtTemp)
lsOutString += String(ldtTemp, 'yyyymmdd') + "T" + String(ldtTemp, 'hhmmss') + '.000Z' 

idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
lsFileName = 'WO' + '_' + idsWoMain.GetItemString(1,'wh_code') + '_'+ String(ldBatchSeq,'00000000') + '.DAT'
idsOut.SetItem(llNewRow,'file_name', lsFileName)

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsWOPutaway.RowCount()
boolean bRolledUp = false
long llWDquantity;

For llRowPos = 1 to llRowCount
	lsOutString = 'WD'  + lsDelimitChar 
	llWDquantity = idsWOPutaway.GetItemNumber(llRowPos,'quantity')
	
	for llPickDetailPos = 1 to llRowCount  //see if there are any packing rows that should be rolled-up into this WD record; same sku/supplier/line no
		if llPickDetailPos = llRowPos then  //same record
			continue
		end if
			
		if idsWOPutaway.GetItemString(llPickDetailPos,'sku') = idsWOPutaway.GetItemString(llRowPos,'sku') and &
		idsWOPutaway.GetItemString(llPickDetailPos,'supp_code') = idsWOPutaway.GetItemString(llRowPos,'supp_code')  then
			if llRowPos > llPickDetailPos then //allready should have been rolled up; skip
				bRolledUp = true
				llPickDetailPos = llRowCount
			else
				llWDquantity = llWDquantity + idsWOPutaway.GetItemNumber(llPickDetailPos,'quantity')
			end if
		end if
	next 
			
	if bRolledUp = true then //if this record was already rolled up, then just skip it; otherwise write a new output row
		bRolledUp = false
		continue
	else
		llNewRow = idsOut.insertRow(0)
	end if
	
	//Workorder_Number	C(20)	Yes	N/A	Workorder Number
	lsOutString += upper(idsWoMain.getItemString(1, 'workorder_number'))  + lsDelimitChar

	//SKU	C(50)	Yes	N/A	Material Number

	lsSku =  idsWOPutaway.GetItemString(llRowPos,'sku')
	lsOutString += lsSku  + lsDelimitChar

	//Supplier	C(50)	Yes	N/A	
	lsSuppCode = idsWOPutaway.GetItemString(llRowPos,'supp_code')
	lsOutString += lsSuppCode  + lsDelimitChar

	//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
	llLineItemNo = idsWOPutaway.GetItemNumber(llRowPos,'line_item_no')
	lsOutString += String(llLineItemNo) + lsDelimitChar
	
	//OwnerCd	N(6,0)	Yes	N/A	Item number of purchase order document
	ldtemp += idsWOPutaway.GetItemNumber(llRowPos,'owner_id')
	select owner_cd into :lsTemp	from owner	where project_id = :asProject and owner_id = :ldTemp;

	If lsTemp <> '' Then
		lsOutString += lstemp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity
	// lddtlqty = idsWOPutaway.GetItemNumber(llRowPos,'quantity')
	lsOutString += string(llWDquantity) + lsDelimitChar	
	

//ToDo	**********
	llFindRow = idsWODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsWODetail.RowCount())

	//Detail User Field1	C(50)	No	N/A	User Field
	If llFindRow > 0 AND idsWODetail.GetItemString(llFindRow,'user_field1') <> '' Then
		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field2	C(50)	No	N/A	User Field

	If llFindRow > 0 AND  idsWODetail.GetItemString(llFindRow,'user_field2') <> '' Then
		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	//Serial Number	C(50)	No	N/A	Qty must be 1 if present

	If idsWOPutaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
//	If idsWOPutaway.GetItemString(llRowPos,'lot_no') <> '-' Then
//		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
//	Else
		lsOutString += lsDelimitChar
//	End If	
	
	//PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	If idsWOPutaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	If idsWOPutaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Container ID	C(25)	No	N/A	
	If idsWOPutaway.GetItemString(llRowPos,'container_id') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Expiration Date	Date	No	N/A	
//	If Not IsNull(idsWOPutaway.GetItemDateTime(llRowPos,'expiration_date')) Then
//		lsOutString +=  String( idsWOPutaway.GetItemDateTime(llRowPos,'Expiration_Date'),'yyyymmdd') + 'T' + String(idsWOPutaway.GetItemDateTime(llRowPos,'Expiration_Date'),'hhmmss') + '.000Z' + lsDelimitChar
//	Else
		lsOutString += lsDelimitChar
//	End If		
	
	
	//Putaway Serial NO  Not Used 	
	
		lsOutString += lsDelimitChar
	
		
	//Detail User Field3	C(50)	No	N/A	User Field
	
	If llFindRow > 0 AND  idsWODetail.GetItemString(llFindRow,'user_field3') <> '' Then
		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field3')) 
	End If		
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'WO' + '_' + idsWoMain.GetItemString(1,'wh_code') + '_'+ String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	// For each Putaway row get the picked children and create a new component line, unless the sku/supplier/line_item all match, then roll-up to one entry
	idsWOPick.Setfilter("Sku_Parent = '" + lsSku + "'  and line_item_no = '" +  String(llLineItemNo) + "'")
	idsWOPick.Filter()
	llPickCount = idsWOPick.Rowcount()	

	For llPickPos = 1 to llPickCount //scan ahead to see if there are any children that need to be rolled-up
		llWDquantity = idsWoPick.getItemNumber(llPickPos, 'quantity')
		for llPickDetailPos = 1 to llPickCount  //see if there are any packing rows that should be rolled-up into this WD record; same sku/supplier/line no
			if llPickDetailPos = llPickPos then  //same record; identity case, so skip it
				continue
			end if
			
			if idsWoPick.getItemString(llPickPos, 'sku') = idsWoPick.getItemString(llPickDetailPos, 'sku') and &
			idsWoPick.getItemString(llPickPos, 'supp_Code') = idsWoPick.getItemString(llPickDetailPos, 'supp_Code')  and &
			idsWoPick.getItemNumber(llPickPos, 'line_item_no') = idsWoPick.getItemNumber(llPickDetailPos, 'line_item_no') then //a rollup candidate
				if llPickPos > llPickDetailPos then //allready should have been rolled up; skip
					bRolledUp = true
					llPickDetailPos = llPickCount
				else //an actual child entry to be rolled up into the current one
					llWDquantity = llWDquantity + idsWoPick.getItemNumber(llPickDetailPos, 'quantity') 
				end if
			end if
		next 
			
		if bRolledUp = true then //if the row was already rolled up, continue without writing any output
			bRolledUp = false
			continue
		end if
		
		llNewRow = idsOut.insertRow(0)
		lsOutString = 'WC'  + lsDelimitChar 
		//Parent Sku	
		lsOutString += upper(idsWoPick.getItemString(llPickPos, 'Sku_Parent'))  + lsDelimitChar
		//Parent Supplier	Default
		lsOutString += 'RIVERBED'  + lsDelimitChar
		// Sku	
		lsOutString += upper(idsWoPick.getItemString(llPickPos, 'Sku'))  + lsDelimitChar
		// Supplier	
		lsOutString += upper(idsWoPick.getItemString(llPickPos, 'Supp_Code'))  + lsDelimitChar
		// Quantity	
//		ldchildqty = lddtlqty * idsWoPick.getItemNumber(llPickPos, 'quantity')
//		ldchildqty = idsWoPick.getItemNumber(llPickPos, 'quantity')
		lsOutString += string(llWDquantity)  + lsDelimitChar
//		lsOutString += string(idsWoPick.getItemNumber(llPickPos, 'quantity'))  + lsDelimitChar
		// The Rest	 
		lsOutString +=  lsDelimitChar + lsDelimitChar + lsDelimitChar + lsDelimitChar
		// User_Field 1 from Detail	
		If llFindRow > 0 AND idsWODetail.GetItemString(llFindRow,'user_field1') <> '' Then
			lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field1')) 
		End If		
		
	
		idsOut.SetItem(llNewRow,'Project_id', asproject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'WO' + '_' + idsWoMain.GetItemString(1,'wh_code') + '_' + String(ldBatchSeq,'00000000') + '.DAT'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)


	next /*next pick output record */

next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut, asproject)
End If

Return 0
end function

on u_nvo_edi_confirmations_riverbed.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_riverbed.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
//lsDelimitChar = char(9)
lsDelimitChar = '|'

end event

