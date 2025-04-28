HA$PBExportHeader$u_nvo_edi_confirmations_physio_maa.sru
$PBExportComments$Process outbound edi confirmation transactions for AMS-MUSER
forward
global type u_nvo_edi_confirmations_physio_maa from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_physio_maa from nonvisualobject
end type
global u_nvo_edi_confirmations_physio_maa u_nvo_edi_confirmations_physio_maa

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate, idsDoSerial
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode


string lsDelimitChar
end variables

forward prototypes
public function integer uf_rt (string asproject, string asrono)
public function integer uf_gr (string asproject, string asrono)
public function integer uf_adjustment (string asproject, long aladjustid, long aitransid)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_rs (string asproject, string asdono, long altransid)
public function integer uf_process_gr (string asproject, string asrono)
public function integer uf_process_gi_email (datastore asdomain, datastore asdopack)
end prototypes

public function integer uf_rt (string asproject, string asrono);If Not isvalid(iu_nvo_marc_transactions) Then	
		iu_nvo_marc_transactions = Create u_nvo_marc_transactions
	End If
	iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)

Return 0
end function

public function integer uf_gr (string asproject, string asrono);

uf_process_gr(asProject, asrono)	

//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -START
//If Not isvalid(iu_nvo_marc_transactions) Then	
//	iu_nvo_marc_transactions = Create u_nvo_marc_transactions
//End If
//iu_nvo_marc_transactions.uf_receipts(asProject,asRoNo)
//17-Feb-2014 :Madhu- C13-135 - PHC - Split re-trigger interface files (SIMS- MARC GT) -END

Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid, long aitransid);//Jxlim 08/07/2012 CR12 Created 2 interfaces for PHYSIO-MAA mimic AMS_MUSER
//Prepare a Marc GT Stock Adjustment Transaction for AMS-USER for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llNetQty, llRowCount, llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOldInvType,	lsNewInvType,		&
				lsLogOut, lsWarehouse, &
				lsoldcoo, lsnewcoo, lsoldPo_No2, lsnewPo_No2, lsNewOwnerCD, lsTransParm

DateTime	ldtTransTime

lsLogOut = "      Creating MM For AdjustID: " + String(alAdjustID)
FileWrite(gilogFileNo,lsLogOut)

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

//Retreive the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsOldInvType = idsadjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsadjustment.GetITemString(1,"inventory_type")

llOwnerID = idsadjustment.GetITemNumber(1,"owner_ID")
llOrigOwnerID = idsadjustment.GetITemNumber(1,"old_owner")

llNewQty = idsadjustment.GetITemNumber(1,"quantity")
lloldQty = idsadjustment.GetITemNumber(1,"old_quantity")

lsOldCOO = idsadjustment.GetITemString(1,"old_country_of_origin") /*original value before update!*/
lsNewCOO = idsadjustment.GetITemString(1,"country_of_origin")

lsOldPO_NO2 = idsadjustment.GetITemString(1,"old_Po_No2") /*original value before update!*/
lsNewPO_NO2 = idsadjustment.GetITemString(1,"Po_No2")

lsNewOwnerCd = idsadjustment.GetITemString(1,"new_owner_cd")
		
//TAMCCLANAHAN 
//Begin Process Mark GT interface

// Call MARC GT Interface on Change in Inventory Type, Original Owner, Qty, Bonded, COO --- To Be Coded Later 
lsWarehouse = idsadjustment.GetITemString(1,'Wh_Code')


If (lsOldInvType <> lsNewInvType) or (llOwnerID <> llOrigOwnerID) or (llOldQty <> llNewQty) or (lsOldPo_no2 <> lsNewPo_No2) or (lsOldCoo <> lsNewCoo) Then
		If Not isvalid(iu_nvo_marc_transactions) Then	
			iu_nvo_marc_transactions = Create u_nvo_marc_transactions
		End If
		iu_nvo_marc_transactions.uf_corrections(asProject,alAdjustID)
End If
//End Marc GT Process


Return 0
end function

public function integer uf_gi (string asproject, string asdono);
//-	Add Delivery_Master.Ship_Ref at the end of the RS/GI record (after DMUF22).
//-	We will always include the Pack Record (not dependant on ini file setting to include)
//-	WE will send both a Ready to Ship and Goods Issue transaction


//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed

//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode, lsUCCS
integer    liCheck

DEcimal		ldBatchSeq, ldNetWeight, ldGrossWeight, ldCBM
Integer		liRC
Boolean		lbFound

String		lsUserLineItemNo,ls_email,ls_uf16 //16-Jan-2015 :Madhu- Added ls_email, ls_uf16

Long llDetailFind, llPackFind

//******************************************************************************************
// 08/13 - PCONKL - Temporarily disable GI for XD. Can't just turn off because we need to send GI's 

//If asProject = 'PHYSIO-XD' Then
//	lsLogOut = "                  Purposely Not creating Physio GI for PHYSIO-XD For DONO: " + asDONO
//	FileWrite(gilogFileNo,lsLogOut)
//	Return 0
//End If

//******************************************************************************************


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
	idsDoPack.Dataobject = 'd_do_packing_physio'
	idsDoPack.SetTransObject(SQLCA)
End If


//MEA - 8/13 - Added for PK Serial Processing

If Not isvalid(idsDoSerial) Then
	idsDoSerial = Create Datastore
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

//	lsLineItemNo = idsdoDetail.GetItemString(llDetailFind,'User_Line_item_No')    //19-Jun-2013 :Madhu commented
	lsUserLineItemNo = idsdoDetail.GetItemString(llDetailFind,'User_Line_item_No')
	
	If IsNull(lsUserLineItemNo) then lsUserLineItemNo = lsLineItemNo

	lsLogOut = "        UserLineItemNo: " + lsUserLineItemNo
	FileWrite(gilogFileNo,lsLogOut)

	llPackFind = idsDoPack.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no=" + string(lsLineItemNo), 1, idsDoPack.RowCount())



	//Field Name	Type	Req.	Default	Description
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GI$$HEX2$$1d200900$$ENDHEX$$Goods issue confirmation identifier
	
	//MEA - 8/12 - If the file is being generated from a $$HEX1$$1820$$ENDHEX$$Ready to Ship$$HEX2$$19202000$$ENDHEX$$transaction, the Record ID will be $$HEX1$$1820$$ENDHEX$$RS$$HEX2$$19202000$$ENDHEX$$instead of $$HEX1$$1820$$ENDHEX$$GI$$HEX1$$1920$$ENDHEX$$. This is a baseline change.
	
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
	
//  TAM 07/19/2012 Changed the datawindow to look at Picking Detail with an out Join to Delivery_serial_detail.  This is so we can populate scanned serial numbers on the GI file

//MEA -  Commented out for Babycare. // TAM 9/26/12 FIxed the datawindow to return rows

//	lsOutString += String( idsdoPick.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar

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

	lsTemp = String( idsDoMain.GetItemDateTime(1,'complete_date'),'yyyy-mm-dd') 
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar

	
	//Package Count	N(5,0)	No	N/A	Total no. of package in delivery

	lsTemp = String(1)  	  //if idsDoPack > 0 then idsDoPack.GetItemDecimal(llPackFind,'complete_date'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	lsOutString += lsTemp+ lsDelimitChar
	
	
	
	//Ship Tracking Number	C(25)	No	N/A	
	// 08/13 - PCONKL - Trim to 25 char. The client is concatenating multiple tracking numbers
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		//BCR 30-DEC-2011: Geistlich UAT fix...
//		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
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
	
	//EWMS has the Package Weight hardcoded to $$HEX1$$1c20$$ENDHEX$$1.0$$HEX1$$1d20$$ENDHEX$$. I am assuming that is the UPM (Weight) field.
	
	//MEA - Outstand question to Pete - value of field - just pass place holder for now.

	lsOutString += lsDelimitChar

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
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar
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
//	-	First loop through Delivery_Serial_Detail/Delivery_Picking_detail to get the serialized parts. There might be non-serialized parts on here as well so ignore if serial_no = $$HEX1$$1820$$ENDHEX$$-$$HEX1$$1820$$ENDHEX$$. We will write a PK record for each serial number. We will also have to get the Lottables from Delivery_packing by doing a find on the packing row by Line_Item and Carton_no.
//	
//	-	The non serialized items will come just from Delivery_Packing. Make sure to exclude items processed from the Serial Tab. You can probably just take where serialized_ind = $$HEX1$$1820$$ENDHEX$$N$$HEX1$$1920$$ENDHEX$$.
//

For llRowPos = 1 to llRowCOunt

	lsSku = idsDoSerial.GetITEmString(llRowPos,'sku')
//	lsSuppCode =  Upper(idsDoSerial.GetITEmString(llRowPos,'supp_code'))
	llLineItemNo = idsDoSerial.GetITemNumber(llRowPos, 'Line_item_No')

	lsCartonNo =  idsDoSerial.GetITEmString(llRowPos,'Carton_No')
	lsSerialNo =  idsDoSerial.GetITEmString(llRowPos,'Serial_No')
	
	ldQuantity = idsDoSerial.GetITemNumber(llRowPos, 'Quantity')
	
	llPackFind = idsDoPack.Find( "carton_no='"+lsCartonNo+"' and line_item_no = " + string(llLineItemNo), 1, idsDoPack.RowCount())

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
		
	else
		
		//Can't match up serial and carton. There is an error. We should log.
		
		lsLogOut = "        *** Unable to Pack Row (PK) for Caton No " + lsCartonNo + " and Line_Item_No = " + string(llLineItemNo) + "  and  DONO: " + asDONO
		FileWrite(gilogFileNo,lsLogOut)
		
	end if
	
Next


//If there is  no serial data for a row, then still print the packing row so do not remove the row.

llRowCount = idsDoPack.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 
	lsSOM = idsdoPack.GetITEmString(llRowPos,'standard_of_measure')

	//Record_ID ($$HEX1$$1820$$ENDHEX$$PK$$HEX1$$1920$$ENDHEX$$)

	lsOutString = 'PK' + lsDelimitChar	

	//Project ID	C(10)	Yes	N/A	Project identifier
	
	lsOutString +=  asproject + lsDelimitChar
	
	//Delivery Number	C(10)	Yes	N/A	Delivery Order Number
	
	lsOutString += idsDoMain.GetItemString(1,'Invoice_no') + lsDelimitChar	
	
	//Carton Number 
	
	//On the Packing Segment, we need to prefix the carton number with the Project level and Warehouse level UCC values. 
	//Carton Number will end up being an 18 digit value consisting of $$HEX1$$1820$$ENDHEX$$Project.UCC_Company_Prefix$$HEX2$$19202000$$ENDHEX$$(8) + $$HEX1$$1820$$ENDHEX$$Warehouse.UCC_Location_Prefix$$HEX1$$1920$$ENDHEX$$(1) + $$HEX1$$1820$$ENDHEX$$Delivery_Packing.Carton_No$$HEX2$$19202000$$ENDHEX$$(9).  This can be baseline as those fields will be blank if not used.
	
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
		lsOutString +=lsDelimitChar
	End If		
	
	
	//	PK021	Expiration Date
	
	If string(idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'MM/DD/YYYY') <> "12/31/2999" and string(idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'MM/DD/YYYY') <> "01/01/1900" Then
		lsOutString += String( idsDoPack.GetITemDateTime(llRowPos,'pack_expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	    



//	PK022 	Detail User Field6 [ Client Order Line Number ]

	If idsDoDetail.GetItemString(llDetailFind,'user_field6') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_field6'))  + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	



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

//16-Jan-2015 :Madhu- Send E-mail notification template based on country code - START
ls_email = idsDoMain.getItemString(1,'Email_Address')
ls_uf16 =idsDoMain.getItemString(1,'User_Field16')

IF (ls_email >' ' and (ls_uf16='DDU' OR ls_uf16 ='DDP')) THEN
	uf_process_gi_email(idsDoMain,idsDoPack)
END IF

//16-Jan-2015 :Madhu- Send E-mail notification template based on country code - END
Return 0
end function

public function integer uf_rs (string asproject, string asdono, long altransid);//Jxlim 08/07/2012 Added RS interface for PHYSIO-MAA
//Prepare a Ready to Ship Transaction for PHYSIO-MAA for the order that was just set to Ready to Ship


Long			llRowPos, llRowCount, llFindRow,	llDetailFindRow, llPickFindRow, llNewRow, llLineItemNo, llLineItemNoHold,	llBatchSeq, llCartonCount, &
				llSerialCount, llSerialPos, llPAckLine, llPackLineSave
				
String		lsFind, lsOutString,	lsMessage, lsSku,	lsSKUHold, lsSupplier, lsSupplierHold,	lsInvType,	&
				lsInvoice, lsLogOut, lsFileName, lsPickFind, lsCarton, lsCartonHold, lsID, lsCarrier, lsSCAC, lsWarehouse

DEcimal		ldBatchSeq
Integer		liRC
DateTime		ldtReadyDate
Datastore	ldsSerial

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
ldsSerial = Create Datastore
//ldsSerial.Dataobject = 'd_do_carton_serial'
ldsSerial.Dataobject = 'd_do_carton_serial_by_dono' /* 02/07 - PCONKL - Retrieving by entire dono instead of by carton/sku */
lirc = ldsSerial.SetTransobject(sqlca)

idsOut.Reset()
idsGR.Reset()

//Trans Create Date is Ready to Ship Date
select trans_create_date into :ldtReadyDate
From Batch_transaction
Where Trans_id = :alTransID;

//Retreive Delivery Master, Detail, Picking Packing and Picking records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

// 03/07 - PCONKL - If not received elctronically, don't send a confirmation
If idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')) Then Return 0

idsDoDetail.Retrieve(asDoNo)
idsDoPick.Retrieve(asDoNo)
idsDoPack.Retrieve(asDoNo)

//// 01/08 - Need to include SUZ warehouse
// 6/12 - MEA - Added PCH
If upper(idsDoMain.getItemString(1, 'wh_code')) = 'PHYSIO-MAA' Then
	lsWarehouse = 'PHYSIO-MAA'
Else
	lsWarehouse = ''
End If


//We need the Carton Count from Packing
Select Count(Distinct carton_no) Into :llCartonCount
From Delivery_Packing
Where do_no = :asDoNo;

If isnull(llCartonCount) then llCartonCount = 0

//Convert Carrier to PHYSIO-MAA Carrier (SCAC)
lsCarrier = idsDoMain.GetItemString(1,'carrier')
		
Select scac_code into :lsSCAC
From Carrier_Master
Where project_id = "PHYSIO-MAA" and carrier_code = :lscarrier;

If isnull(lsSCAC) or lsSCAC = "" Then lsSCAC = lsCarrier


//For each sku/line Item/inventory type/Lot/Serial Nbr  in Picking, write an output record - 
//multiple Picking records may be combined in a single output record (multiple locs, etc for an inv type)

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Loop Thru Packing for Line/Parent SKU/Supplier and Process all Parent/Child Items from Pick List for that Parent

// 11/06 - PCONKL - want to roll into a sinlg LPN (carton No) per Line Item even if Line is packed in multiple cartons. 
//                  This may be short term until PHYSIO-MAA can accept multiple LN's per Line ITem.

idsDoPack.SetSort("Line_Item_No A, Carton_No A, SKU A, Supp_Code A")
idsDoPack.Sort()
llPAckLineSave = 0

llRowCOunt = idsDOPack.RowCount()
For llRowPos = 1 to llRowCount
	
	llPAckLine = idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')
	
	If llPackLine = llPackLineSave Then Continue
		
	lsPickFind = "Line_Item_No = " + String(llPAckLine) 
	llPickFindRow = idsDOPick.Find(lsPickFind,1,idsDOPick.RowCount())
	
	Do While llPickFindRow > 0
		
		If idsDoPick.GetITemString(llPickFindRow,'Component_ind') <> 'Y' Then /*Don't include component Parents*/
		
			//Roll up to Line and sku only
			lsFind = " po_item_number = " + String(idsDOPick.GetItemNumber(llPickFindRow,'Line_Item_no')) 
			lsFind += " and upper(sku) = '" + upper(idsDOPick.GetItemString(llPickFindRow,'SKU')) + "'"
			//lsFind += " and upper(inventory_type) = '" + upper(idsDOPick.GetItemString(llPickFindRow,'inventory_type')) + "'"
			//lsFind += " and upper(lot_no) = '" + upper(idsDOPack.GetItemString(llRowPos,'carton_no')) + "'" /*from packing*/
	
			llFindRow = idsGR.Find(lsFind,1,idsGR.RowCOunt())
	
			If llFindRow > 0 Then /*row already exists, add the qty*/
	
				idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsDOPick.GetItemNumber(llPickFindRow,'quantity')))
		
			Else /*not found, add a new record*/
		
				llNewRow = idsGR.InsertRow(0)
				idsGR.SetItem(llNewRow,'SKU',idsDOPick.GetItemString(llPickFindRow,'SKU'))
				idsGR.SetItem(llNewRow,'Inventory_type',idsDOPick.GetItemString(llPickFindRow,'inventory_type'))
				idsGR.SetItem(llNewRow,'quantity',idsDOPick.GetItemNumber(llPickFindRow,'quantity'))
				idsGR.SetItem(llNewRow,'po_item_number',idsDOPick.GetItemNumber(llPickFindRow,'line_item_no'))
				
				idsGR.SetItem(llNewRow,'lot_no',idsDOPack.GetItemString(llRowPos,'carton_no')) /*Lot No = LPN = Packing Carton Number*/
				
				//For Non kitted parts, Delivery Detail ID is in Detail UF 1.
				// For kitted children, it is stored in UF 1 on the Delivery_BOM record since we don't have children on the Delivery Detail record
				
				llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')) + " and Upper(SKU) = '" + Upper(idsDOPick.GetItemString(llPickFindRow,'SKU')) + "'",1,idsDoDetail.RowCount())
				If lLDetailFindRow > 0 Then
					
					If idsDoDetail.GetITemString(llDetailFindRow,'User_field8') > "" Then
						idsGR.SetItem(llNewRow,'user_field8',idsDoDetail.GetITemString(llDetailFindRow,'User_field8'))
					Else
						idsGR.SetItem(llNewRow,'user_field8','')
					end If
					
					//Line ITem should come from Oracle LIne (UF5) instead of Line Item NUmber
					If idsDoDetail.GetITemString(llDetailFindRow,'User_field5') > "" Then
						idsGR.SetItem(llNewRow,'user_field5',Trim(idsDoDetail.GetITemString(llDetailFindRow,'User_field5')))
					Else
						idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
					end If
					
				Else /* not found, must be a child record */
					
					lsSKU = idsDOPick.GetItemString(llPickFindRow,'SKU')
					llLineItemNo = idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')
					
					lsID = ""
					
					Select User_Field1 into :lsID
					From Delivery_BOM
					Where do_no = :asDONO and sku_Child = :lsSKU and line_item_No = :llLineItemNO;
					
					If lsID > "" Then
						idsGR.SetItem(llNewRow,'user_field8',lsID)
					Else
						idsGR.SetItem(llNewRow,'user_field8','')
					End If
					
					//Get THe line ITem from the Parent
					llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(idsDOPack.GetItemNumber(llRowPos,'Line_Item_no')),1,idsDoDetail.RowCount())
					If llDetailFindROw > 0 Then
						If idsDoDetail.GetITemString(llDetailFindRow,'User_field5') > "" Then
							idsGR.SetItem(llNewRow,'user_field5',Trim(idsDoDetail.GetITemString(llDetailFindRow,'User_field5')))
						Else
							idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
						end If
					Else
						idsGR.SetItem(llNewRow,'user_field5',String(idsDOPick.GetItemNumber(llPickFindRow,'line_item_no')))
					End If
					
				End If /*detail found*/
				
			End If /*new or updated row*/
			
		End If /*Not a component parent*/
			
		If llPickFIndRow = idsDoPick.RowCount() Then
			llPickFindRow = 0
		Else
			llPickFindRow ++
			llPickFindRow = idsDOPick.Find(lsPickFind,llPickFindRow,idsDOPick.RowCount())
		End If
		
	Loop /* Next chiild/standalone Sku for Parent*/
	
	llPackLineSave = llPackLine
		
Next /* Next Pack record */


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to PHYSIO-MAA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by '|'
llRowCount = idsGR.RowCount()
For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'RS|' /*rec type = Ready to Ship*/
	
	// 01/08 - Need to include SUZ warehouse
	//lsOutString += 'MER|' /*default warehouse for now*/
	lsOutString += lsWarehouse + "|"
	
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'user_Field8') + '|'
	lsOutString += Left(idsGR.GetItemString(llRowPos,'inventory_type'),1) + '|'
	lsOutString += String(ldtReadyDate,'yyyy-mm-dd') + '|'
	lsOutString += String(llCartonCount) + '|'
		
	If Not isnull(lsSCAC) Then /*Carrier (SCAC)*/
		lsOutString += lsSCAC + '|'
	Else
		lsOutString +='|'
	End IF
	
	lsOutString += idsGR.GetItemString(llRowPos,'sku') + '|'
	//lsOutString += String(idsGR.GetItemNumber(llRowPos,'po_item_number')) + '|'
	lsOutString += idsGR.GetItemString(llRowPos,'user_field5') + '|' /*oracle LIne ITem*/
	lsOutString += string(idsGR.GetItemNumber(llRowPos,'quantity')) + '|'
	lsOutString += string(idsGR.GetItemString(llRowPos,'Lot_no'))

	idsOut.SetItem(llNewRow,'Project_id', 'PHYSIO-MAA')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'rs' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

next /*next output record */

//Add any serial nummber records...

//02/07 - PCONKL - Retrieving Serials for entire order instead of looping by Pack/Pick Rows
llRowCount = ldsSerial.Retrieve(asdono)

For llRowPOs = 1 to llRowCount
	
	lsSKU = ldsSerial.GEtITEmString(llRowPos,'Sku')
	lsCarton = ldsSerial.getITemString(llRowPos,'carton_no')
	llLineItemNo = ldsSerial.GEtITEmNumber(llRowPos,'Line_Item_No')
	
	llNewRow = idsOut.insertRow(0)
	lsOutString = 'OS|' /*rec type = Outbound Serial Rec*/
	lsOutString += idsDoMain.GetItemString(1,'invoice_no') + '|'

	//For Non kitted parts, Delivery Detail ID is in Detail UF 1.
	// For kitted children, it is stored in UF 1 on the Delivery_BOM record since we don't have children on the Delivery Detail record
			
	llDetailFindRow = idsDoDetail.Find("Line_Item_No = " + String(llLineItemNo) + " and Upper(sku) = '" + upper(lsSKU) + "'",1,idsDoDetail.RowCount())
	If lLDetailFindRow > 0 Then
				
		If idsDoDetail.GetITemString(llDetailFindRow,'User_field8') > "" Then
			lsOutString += idsDoDetail.GetITemString(llDetailFindRow,'User_field8') + "|"
		Else
			lsOutString += "|"
		End If
				
	Else /* not found, must be a child record */
										
		lsID = ""
				
		Select User_Field1 into :lsID
		From Delivery_BOM
		Where do_no = :asDONO and sku_Child = :lsSKU and line_item_No = :llLineItemNO;
				
		If lsID > "" Then
			lsOutString += lsID + "|"
		Else
				lsOutString += "|"
		End If
		
	End If
			
	lsOutString += lsCarton + "|"
	lsOutString += lsSku + "|"
	lsOutString += ldsSerial.getITemString(llRowPos,'serial_no') + "|"
	
	idsOut.SetItem(llNewRow,'Project_id', 'PHYSIO-MAA')
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'rs' + String(ldBatchSeq,'00000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
Next /*Serial Record */



//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,'PHYSIO-MAA')

Return 0
end function

public function integer uf_process_gr (string asproject, string asrono);
//Prepare a Goods Receipt Transaction for Physio MAA/XD for the order that was just confirmed

// 08/13 - PCONKL - Consolidating Inbound Orders, need to split them back out in the GR
//						Physio Order NUmber is stored in Detail UF3 and we need a sperate file per Physio Order

Long			llRowPos, llRowCount, llDetailFindRow,	llNewRow, llLineItemNo
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lSOrderSave, lsOrder

DEcimal		ldBatchSeq
Integer		liRC

//******************************************************************************************
// 08/13 - PCONKL - Temporarily disable GR for PHYSIO. Can't just turn off because we need to send GI's 

//lsLogOut = "                  Purposely Not creating Physio GR For RONO: " + asRONO
//FileWrite(gilogFileNo,lsLogOut)
//Return 0
//******************************************************************************************


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

// 08/13 - PCONKL - We are breaking on Physio Order Number in RD UF3 but we are looping on Putaway.
//							Copy Order Number to UF5 on Putaway so we can sort and break appropriately

llRowCount = idsroputaway.RowCount()
For llRowPos = 1 to llRowCount
	
	llLineItemNo =  idsroputaway.GetItemNumber(llRowPos,'line_Item_No')
	llDetailFindRow = idsRODetail.Find("Line_Item_No = " + string(llLineItemNo), 1, idsRODetail.RowCount())
	If lLDetailFindROw > 0 Then
		
		lsOrder = idsRoDetail.GetITemString(llDetailFindRow,'User_Field3')
		
		If isNull(lsOrder) or lsOrder = '' Then
			lsOrder = idsroMain.GetITemString(1,'supp_invoice_no')
		End If
		
	Else
		lsOrder = idsroMain.GetITemString(1,'supp_invoice_no')
	End If
	
	idsRoPutaway.SetItem(llRowPos,'user_Field5',lsOrder)
	
Next

idsRoPutaway.SetSort("User_Field5 A, Line_item_No A")
idsRoPutaway.Sort()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Physio!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroputaway.RowCount()

For llRowPos = 1 to llRowCOunt
		
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	llLineItemNo =  idsroputaway.GetItemNumber(llRowPos,'line_Item_No')
	
	// 08/13 - PCONKL - Find corresponding Detail Row - moving up top as we use it often and retrieving by Line Item Number instead of SKU/Supp Code as was being done previously
	llDetailFindRow = idsRODetail.Find("Line_Item_No = " + string(llLineItemNo), 1, idsRODetail.RowCount())
	
	
	// 08/13 - PCONKL - Physio Order Number loaded in to UF13 above either from Detail UF3 or Header ORder Number
	lsOrder = idsRoPutaway.GetITemString(llRowPos,'User_Field5')
	
	//If Order has changed, write existing Data
	if lsOrder <> lsOrderSave and idsOut.RowCount() > 0 Then
		
		gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
		idsOut.Reset()
		
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Physio!'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
	End If /* New Order */
	
	lsOrderSave = lsOrder
	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	$$HEX1$$1c20$$ENDHEX$$GR$$HEX2$$1d200900$$ENDHEX$$Goods receipt confirmation identifier
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString += asproject + lsDelimitChar

	//Warehouse	C(10)	Yes	N/A	Receiving Warehouse
	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number
	// 08/13 - PCONKL - ORder NUmber now coming from Detail UF 3 (retrieved above) since we are consolidating Orders
	
	//lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar
	lsOutString += lsOrder + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition
	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number
//	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
//	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
		
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
	//llDetailFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())

	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	End If	

//	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
	
// TAM 2012/07/23 Moved down below to pull from detail.  User Line Item Number might not be present they did a manual entry instead of a generate.	
//	If trim(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) <> '' Then
//		lsOutString += String(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If			
	
	//llDetailFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())
	
	//Detail User Customer Line Number	C(25)	No	N/A	User Line Item No
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	//Detail User Field1	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_field1') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field2	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field2') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field3	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field3') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field4	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field4') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Detail User Field5	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field5') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Detail User Field6	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field6') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field6')) + lsDelimitChar
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
		lsOutString += lsDelimitChar 
	End If	
		
	//Carrier
	If idsROMain.GetItemString(1,'carrier') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Country Of Origin
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'country_of_origin') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'country_of_origin')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
			
	//UnitOfMeasure
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'uom') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'uom')) + lsDelimitChar
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

//	Select grp INTO :lsGrp From Item_Master
//	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
//	USING SQLCA;
			
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

public function integer uf_process_gi_email (datastore asdomain, datastore asdopack);//16-Jan-2015 :Madhu- Send E-mail notification template based on country code

String ls_country,ls_project,ls_language,ls_email_string,ls_carrier,ls_carrier_name, ls_tracking_url,ls_trackingId,ls_email_address,ls_logoname,ls_UF4,ls_prev_trackingId
String ls_sub,ls_tag1,ls_tag2,ls_tag3,ls_tag4,ls_tag5,ls_tag6,ls_tag7,ls_tag8,ls_tag9,ls_tag10,Invoice_No,ls_trackingId_total,ls_tracking_dynamic_url,ls_update_url
long il_row,ll_Pos

u_nvo_process_files lu_nvo_process_files

SetPointer(HourGlass!)

ls_logoname="Physio.png" //pass logo name as parameter
ls_prev_trackingId=''

ls_country =asdomain.GetITemString(1,'Country')
ls_project =asdomain.GetItemString(1,'Project_Id')
Invoice_No =asdomain.GetItemString(1,'Invoice_No')
ls_carrier = asdomain.GetItemString(1,'Carrier')
ls_email_address = asdomain.GetITemString(1,'Email_Address')

//select language template
CHOOSE CASE Upper(ls_country)
	CASE 'BE'
		ls_language ='BELGIUM'
	CASE 'CH'
		ls_language ='SWITZERLAND'
	CASE 'DE','AT','LI'
		ls_language='GERMAN'
	CASE 'ES'
		ls_language ='SPANISH'
	CASE 'FR'
		ls_language='FRENCH'
	CASE 'IT'
		ls_language ='ITALIAN'
	CASE 'NL'
		ls_language='DUTCH'
	CASE 'PT'
		ls_language='PORTUGUESE'
	CASE ELSE
		ls_language ='ENGLISH'
END CHOOSE

//Get Carrier Information
Select Carrier_Name, Carrier_Tracking_URL into :ls_carrier_name, :ls_tracking_url
From Carrier_Master where Project_Id=:ls_project and Carrier_Code=:ls_carrier;

//Retrieve required template information.
Select Email_Subject,Tag_1,Tag_2,Tag_3,Tag_4,Tag_5,Tag_6,Tag_7,Tag_8,Tag_9,Tag_10
	into :ls_sub,:ls_tag1,:ls_tag2,:ls_tag3,:ls_tag4,:ls_tag5,:ls_tag6,:ls_tag7,:ls_tag8,:ls_tag9,:ls_tag10
FROM Email_Template with (nolock) where Project_Id=:ls_project and Language_Id=:ls_language;

ls_email_string ="<HTML>"
ls_email_string +="<Body>"
ls_email_string +="<pre style ="+"font-family: Calibri" +","+"font-size: 10"+">"
ls_email_string += ls_tag1 +"~n~n"
ls_email_string += ls_tag2 + "~n~n"

CHOOSE CASE Upper(ls_language)
	CASE 'BELGIUM'
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP
				
			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t~t~t~t~t~t~t"+ "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id
	
	CASE 'DUTCH'
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP
			
			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+ nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+ls_update_url+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id
		
	CASE 'ENGLISH'
			ls_email_string += ls_tag3 + "		" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string +=  ls_tag4 + "~t~t"+ nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "	~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=   "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name

			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP

			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.					
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id

	CASE 'FRENCH'
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP
		
			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.								
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id

	CASE 'GERMAN'
			ls_email_string += ls_tag3 + "~t~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP
			
			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.								
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t"+ "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value	
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id

	CASE 'ITALIAN'
			ls_email_string += ls_tag3 + "~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP

			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t"+ "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total +="<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id

	CASE 'PORTUGUESE'	
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t~t~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP

			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.								
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id

	CASE 'SPANISH'
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t" + nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t~t"  + nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP

			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.								
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id
			
	CASE 'SWITZERLAND'
			ls_email_string += ls_tag3 + "~t~t" + nz(asdomain.GetItemString(1,'User_Field4'),'') +"~n" // your reference
			ls_email_string += ls_tag4 + "~t~t~t~t"+  nz(asdomain.GetItemString(1,'Cust_Order_No'),'') +"~n" //our reference
			ls_email_string += ls_tag5 + "~t~t~t~t"+ nz(asdomain.GetItemString(1,'Ship_Ref'),'') +"~n" //ship ref
			ls_email_string += ls_tag6 + "~t~t~t~t" + nz(asdomain.GetItemString(1,'Address_1'),'') +"~n" //ship to Address
			If  asdomain.getitemstring(1,'Address_2') >' ' THEN ls_email_string +=  "~t~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_2'),'') +"~n" //Address2
			If  asdomain.getitemstring(1,'Address_3') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_3'),'') +"~n" //Address3
			If  asdomain.getitemstring(1,'Address_4') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Address_4'),'') +"~n" //Address4
			If  asdomain.getitemstring(1,'Zip') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t~t"  + nz(asdomain.getitemstring(1,'Zip'),'') +"~n" //Zip
			If  asdomain.getitemstring(1,'City') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'City'),'') +"~n" //city
			If  asdomain.getitemstring(1,'Country') >' ' THEN ls_email_string += "~t~t~t~t~t~t~t~t~t~t~t~t" + nz(asdomain.getitemstring(1,'Country'),'') +"~n" //country
			
			ls_email_string += ls_tag7 + "~t~t~t~t~t~t~t"+ nz(ls_carrier_name,'') +"~n" //carrier name
			
			//Get the shipper tracking Id and append line by line 
			FOR il_row =1 to asdopack.rowcount()
				ls_trackingId= asdopack.GetITemString(il_row,'Shipper_Tracking_Id')
				//Replace <tracking_id> by Shipper Tracking ID value on URL
				ll_Pos =Pos(ls_tracking_url,"<tracking_id>",1)
				DO WHILE ll_Pos > 0 and len(ls_trackingId) > 0
					ls_update_url=Replace(ls_tracking_url,ll_Pos,13,ls_trackingId)
					//Find next occurance
					ll_Pos =Pos(ls_tracking_url,"<tracking_id>", ll_Pos + len(ls_trackingId))
				LOOP

			IF	ls_prev_trackingId <> ls_trackingId THEN //Avoid to repeat duplicate trackingID's.								
				IF ls_trackingId >' ' and il_row > 1 THEN
					ls_trackingId_total += "~n" +"~t~t~t~t~t~t~t~t~t~t~t~t"+"<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>" //2nd row onwards, put trackingId on new line with required tabs.
				ELSE 
					ls_trackingId_total += "<a href="+nz(ls_update_url,'')+">"+nz(ls_trackingId,'')+"</a>"
				END IF
			END IF
			ls_prev_trackingId =ls_trackingId //set previous tracking id value
			NEXT
			ls_email_string += ls_tag8 + "~t~t~t~t~t" + nz(ls_trackingId_total,'') +"~n~n" //tracking Id
			
END CHOOSE

ls_email_string += ls_tag10 +"~n"

CHOOSE CASE ls_language
	CASE 'SPANISH'
		ls_email_string +="Por favor, no contesten a este correo electr$$HEX1$$f300$$ENDHEX$$nico ya que se trata de un respuesta autom$$HEX1$$e100$$ENDHEX$$tica. ~n"
	CASE 'ITALIAN'
		ls_email_string +="Si prega cortesemente di non rispondere alla presente email poich$$HEX2$$e8002000$$ENDHEX$$generata automaticamente. ~n"
	CASE 'BELGIUM'
		ls_email_string +="Veuillez prendre note qu$$HEX1$$1920$$ENDHEX$$il pourrait y avoir un d$$HEX1$$e900$$ENDHEX$$lai avant que le num$$HEX1$$e900$$ENDHEX$$ro de suivi soit visible sur le site du transporteur. ~n"+&
		"Bitte beachten sie das es ein wenig Zeit in Anspruch nimmt, bevor die Tracking Nummer auf der Webseite des jeweiligen Lieferranten sichtbar wird. ~n~n"+&
		"Dit is een automatisch gegenereerd e-mail bericht. ~n"+&
		"Merci de ne pas r$$HEX1$$e900$$ENDHEX$$pondre $$HEX2$$e0002000$$ENDHEX$$ce mail g$$HEX1$$e900$$ENDHEX$$n$$HEX1$$e900$$ENDHEX$$r$$HEX2$$e9002000$$ENDHEX$$automatiquement. ~n"+&
		"Bitte antworten sie nicht auf diese Email, da dies eine automatisierte Nachricht ist. ~n"
		
	CASE "SWITZERLAND"
		ls_email_string +="Bitte beachten sie das es ein wenig Zeit in Anspruch nimmt, bevor die Tracking Nummer auf der Webseite des jeweiligen Lieferranten sichtbar wird.~n"+&
		"Vi informiamo che il numero di spedizione sar$$HEX2$$e0002000$$ENDHEX$$consultabile sul sito del corriere. Precisiamo che non sar$$HEX2$$e0002000$$ENDHEX$$visibile nell$$HEX1$$1920$$ENDHEX$$immediato ma secondo i tempi di elaborazione del sistema di ciascun corriere. ~n~n"+&
		"Merci de ne pas r$$HEX1$$e900$$ENDHEX$$pondre $$HEX2$$e0002000$$ENDHEX$$ce mail g$$HEX1$$e900$$ENDHEX$$n$$HEX1$$e900$$ENDHEX$$r$$HEX2$$e9002000$$ENDHEX$$automatiquement. ~n"+&
		"Bitte antworten sie nicht auf diese Email, da dies eine automatisierte Nachricht ist. ~n"+&
		"Si prega cortesemente di non rispondere alla presente email poich$$HEX2$$e8002000$$ENDHEX$$generata automaticamente. ~n"
END CHOOSE

//Pass Logo to print on email
ls_email_string +="~n<img src="+"cid:"+ls_logoname+">"
ls_email_string += "</Body></HTML>"

//Replace %Invoice_No% by value on subject
ll_Pos =Pos(ls_sub,"%Invoice_No%",1)
ls_UF4 =nz(asdomain.GetItemString(1,'User_Field4'),'')
DO WHILE ll_Pos > 0
	ls_sub=Replace(ls_sub,ll_Pos,12, ls_UF4)
	//Find next occurance
	ll_Pos =Pos(ls_sub,"%Invoice_No%", ll_Pos + len(ls_UF4))
LOOP

lu_nvo_process_files = CREATE u_nvo_process_files
lu_nvo_process_files.uf_send_email_with_from_Address( ls_project,ls_email_address, ls_sub, ls_email_string, '','physio-control@menloworldwide.com',ls_logoname)

Return 0
end function

on u_nvo_edi_confirmations_physio_maa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_physio_maa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

