$PBExportHeader$u_nvo_edi_confirmations_nyx.sru
forward
global type u_nvo_edi_confirmations_nyx from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_nyx from nonvisualobject
end type
global u_nvo_edi_confirmations_nyx u_nvo_edi_confirmations_nyx

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate, idsDoSerial, idsWODetail, idsWOPutaway
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode


string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_process_gr (string asproject, string asrono)
public function integer uf_gi (string asproject, string asdono)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gw (string asproject, string aswono)
end prototypes

public function integer uf_gr (string asproject, string asrono);// Replace uf_process_gr
//uf_process_gr(asProject, asrono)	
//Prepare a Goods Receipt Transaction for Baseline Unicode for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp

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
	idsroputaway.Dataobject = 'd_ro_Putaway_baseline'		//GailM 9/2/2015 - NYX, like starbucks, want one row per line item number
	idsroputaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
gsRoNo =asrono //29-Sep-2014 :Madhu- KLN B2B Conversion to SPS

lsLogOut = "      Creating GR For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//If not received elctronically, don't send a confirmation
//30-Jul-2013 :Madhu - Added code to don't generate GR, if ord_type='R' -START
If (idsroMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsroMain.GetITemNumber(1,'edi_batch_seq_no')))  or idsroMain.GetItemstring(1,'Ord_Type') ='R' Then 
	lsLogOut ="Order not received electronically or Ord_Type=R. Not creating GR"
	FileWrite(gilogFileNo,lsLogOut)
	//30-Jul-2013 :Madhu - Added code to don't generate GR, if ord_type='R' -END
	Return 0
ENd If  //30-Jul-2013 :Madhu Added
//OR   idsroMain.GetITemString(1,'create_user')  <> 'SIMSFP'  

idsroPutaway.Retrieve(asRONO)
idsroDetail.Retrieve(asRONO)

//GailM - 9/10/2015 - Sort putaway by SKU and SSCC No (PONo2)
idsroPutaway.SetSort("sku, po_no2")
idsroPutaway.Sort()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to Powerwave!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsroPutaway.RowCount()

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
	lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition
	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsOutString += idsroputaway.GetItemString(llRowPos,'sku') + lsDelimitChar

	//Supp Code
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	lsOutString += idsroputaway.GetItemString(llRowPos,'supp_code') + lsDelimitChar
	
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
		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyymmdd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
	lsOutString += String(idsroputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	//Customer  Line Item Number 	C(25)	No	N/A	Customer  Line Item Number
	
// TAM 2012/07/23 Moved down below to pull from detail.  User Line Item Number might not be present they did a manual entry instead of a generate.	
//	If trim(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) <> '' Then
//		lsOutString += String(idsroputaway.GetItemString(llRowPos,'user_line_item_no')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If			
	
	llFindRow = idsRODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsRODetail.RowCount())
	
	//Detail User Customer Line Number	C(25)	No	N/A	User Line Item No
	If llFindRow > 0 AND idsRODetail.GetItemString(llFindRow,'user_line_item_no') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llFindRow,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
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
		lsOutString += lsDelimitChar // TAM 2012/07 Remove comment.   Since new fields were add we need this delimeter
//		lsOutString += lsDelimitChar
	End If	
		
	//BCR 14-SEP-2011: Changes for Riverbed...
	//MEA 01-NOV-2011: Added Columns for Baseline
	
	// 08/12 - PCOnkl - ** DO NOT ADD PROJECT SPECIFIC VALUES. THIS IS BASELINE **
	
	
//	IF Upper(asproject) = "RIVERBED" THEN
//	
//		lsOutString += lsDelimitChar
//	
//		//Order Type C(1)	No	N/A	
//			
//		If idsROMain.GetItemString(1,'ord_type') <> '' Then
//			lsOutString += String(idsROMain.GetItemString(1,'ord_type')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//		
//		//Requested Quantity	C(16)	No	N/A	
//			
//		If idsRODetail.GetItemNumber(1,'req_qty') <> 0 Then
//			lsOutString += String(idsRODetail.GetItemNumber(1,'req_qty')) + lsDelimitChar
//		Else
//			lsOutString += lsDelimitChar
//		End If	
//
//	ELSE

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
				
//Get from Item_Master
Select grp INTO :lsGrp From Item_Master
	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
	USING SQLCA;
			
If IsNull(lsGrp) then lsGrp = ''

lsOutString += lsGrp + lsDelimitChar 

/**********************************************************************************************/
/*20150508 - GailM -- Adding new named fields...  New named fields for Klonelab will be entered ahead of cononical named fields */
/* New ICC fields will be 107 columns after adding 41 named fields                                                                                           */
/**********************************************************************************************/

// 44 - Client_Cust_PO_NBR
	If idsROMain.GetItemString(1,'Client_Cust_PO_NBR') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Client_Cust_PO_NBR')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 45 - Client_Invoice_Nbr
	If idsROMain.GetItemString(1,'Client_Invoice_Nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Client_Invoice_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 46 - Container_Nbr
	If idsROMain.GetItemString(1,'Container_Nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Container_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 47 - Client_Order_Type
	If idsROMain.GetItemString(1,'Client_Order_Type') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Client_Order_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 48 - Container_Type
	If idsROMain.GetItemString(1,'Container_Type') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Container_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 49 - From_Wh_Loc
	If idsROMain.GetItemString(1,'From_Wh_Loc') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'From_Wh_Loc')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 50 - Seal_Nbr
	If idsROMain.GetItemString(1,'Seal_Nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Seal_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 51 - Vendor_Invoice_Nbr
	If idsROMain.GetItemString(1,'Vendor_Invoice_Nbr') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'Vendor_Invoice_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 52 - Currency_Code
	If idsRODetail.GetItemString(1,'Currency_Code') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Currency_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 53 - Supplier_Order_Number
	If idsRODetail.GetItemString(1,'Supplier_Order_Number') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Supplier_Order_Number')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 54 - Cust_PO_Nbr
	If idsRODetail.GetItemString(1,'Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 55 - Line_Container_Nbr
	If idsRODetail.GetItemString(1,'Line_Container_Nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Line_Container_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 56 -Vendor_Line_Nbr
	If idsRODetail.GetItemString(1,'Vendor_Line_Nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Vendor_Line_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 57 - Client_Line_Nbr
	If idsRODetail.GetItemString(1,'Client_Line_Nbr') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Client_Line_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

// 58 - Detail Client_Cust_PO_NBR 
	If idsRODetail.GetItemString(1,'Client_Cust_PO_NBR') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Client_Cust_PO_NBR')) + lsDelimitChar
	Else
		 lsOutString += lsDelimitChar		
	End If	

// 59 - SSCC Bbr 
	If idsRODetail.GetItemString(1,'SSCC_Nbr') <> '' Then
		lsOutString += idsRODetail.GetItemString(1,'SSCC_Nbr') 	//+ lsDelimitChar
	Else
		// += lsDelimitChar		//  Last element does not record delimiter for next element
	End If	

/* End of 41 additional named fields ********************************************************************/

	
	
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

public function integer uf_process_gr (string asproject, string asrono);

Return 0
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Baseline Unicode for the order that was just confirmed

//Prepare a Goods Issue Transaction for Warner for the order that was just confirmed

//Added asType

Long			llRowPos, llRowCount, llFindRow,	llNewRow, llLineItemNo,	llBatchSeq, llArrayPos, llArrayCount, llCartonCount, llPalletCount, llQtyarray[]
				
String		lsOutString,	lsMessage, 	 lsLogOut, lsFileName, lsCarton, lsCartonSave, lsDim, lsdimsarray[], lsSOM, lsCarrier, lsSCAC, lsShipRef, lsWarehouse
String  	lsFreight_Cost, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsCartonNo, lsUCCCompanyPrefix, lsUCCLocationPrefix, lsWHCode
String    lsUCCS
Integer   liCheck

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
gsDoNo =asdono //29-Sep-2014 :Madhu -KLN B2B Conversion to SPS

lsLogOut = "        Creating GI For DONO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

//Retreive Delivery Master and Detail  records for this DONO
If idsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retreive Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//If not received elctronically, don't send a confirmation
If (idsDOMain.GetITemNumber(1,'edi_batch_seq_no') = 0 or isNull(idsDOMain.GetITemNumber(1,'edi_batch_seq_no')))    Then Return 0

//OR  idsDOMain.GetITemString(1,'create_user')  <> 'SIMSFP'  

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
	lsSuppCode =  Upper(idsdoPick.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPick.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())


	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
		
	End If

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
	
	If idsDoMain.GetItemString(1,'awb_bol_no') <> '' Then
		//BCR 30-DEC-2011: Geistlich UAT fix...
//		lsOutString += String(idsDoMain.GetItemString(1,'Ship_Ref')) + lsDelimitChar
		lsOutString += String(idsDoMain.GetItemString(1,'awb_bol_no')) + lsDelimitChar
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
	
	lsTemp = Trim(idsDoMain.GetItemString(1,'Freight_Terms'))
	
	If IsNull(lsTemp) then lsTemp = ''
	
	CHOOSE CASE Upper(Trim(lsTemp))
	CASE 'PREPAID'
		lsTemp = 'PP'                    
	CASE 'COLLECT'
		lsTemp = 'CC'
	CASE  'THIRDPARTY'
		lsTemp = 'TP'	
	CASE 'PP THIRD PARTY'
		lsTemp = 'PC'
	CASE ELSE
		lsTemp = Left(lsTemp,2)
	END CHOOSE
	
	
	If lsTemp <> '' Then
		lsOutString += String(lsTemp) + lsDelimitChar
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
		lsOutString += lsDelimitChar
	End If		
	
	//CustomerCode	
	
	If idsDoMain.GetItemString(1,'cust_code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Ship To Name
	
	If idsDoMain.GetItemString(1,'cust_name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'cust_name')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Ship Address 1	
	
	If idsDoMain.GetItemString(1,'address_1') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Ship Address 2	
	
	If idsDoMain.GetItemString(1,'address_2') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	//Ship Address 3	
	
	If idsDoMain.GetItemString(1,'address_3') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//BCR 14-DEC-2011: Data Map requires address_4
	
	//Ship Address 4	
	
	If idsDoMain.GetItemString(1,'address_4') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'address_4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Ship City	
	
	If idsDoMain.GetItemString(1,'city') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'city')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Ship State	

		If idsDoMain.GetItemString(1,'state') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'state')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Ship Postal Code	
	
	If idsDoMain.GetItemString(1,'zip') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'zip')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Ship Country

	If idsDoMain.GetItemString(1,'country') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'country')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//UnitOfMeasure (weight)
	
	//EWMS has the Package Weight hardcoded to “1.0”. I am assuming that is the UPM (Weight) field.
	
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
		lsOutString += lsDelimitChar
	End If		
		
	
	//Master User Field20	

	If idsDoMain.GetItemString(1,'user_field20') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field20')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field21		col65
	
	If idsDoMain.GetItemString(1,'user_field21') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field21')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		

	//Master User User Field22		col66

	If idsDoMain.GetItemString(1,'user_field22') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) + lsDelimitChar //04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes.
	Else
		lsOutString += lsDelimitChar //04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes. 8May15 gwm uncommented to add named fields
	End If		
	
//04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes - START
	// 08/13 - PCONKL - Added Freight-ETA	
//	lsTemp = String( idsDoMain.GetItemDateTime(1,'freight_eta'),'yyyy-mm-dd') 
//	If IsNull(lsTemp) then lsTemp = ''
//	lsOutString += lsTemp /* No delimiter on last column*/
////04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes - END

/**********************************************************************************************/
/*20150508 - GailM -- Adding new named fields...  New named fields for Klonelab will be entered ahead of cononical named fields */
/* New ICC fields will be 107 columns after adding 41 named fields                                                                                           */
/**********************************************************************************************/
	//Master Department Code
	If idsDoMain.GetItemString(1,'Department_Code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Department_Name
	If idsDoMain.GetItemString(1,'Department_Name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Name')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Division
	If idsDoMain.GetItemString(1,'Division') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Division') ) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
    //Master Vendor
	If idsDoMain.GetItemString(1,'Vendor') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Vendor')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Buyer_Part 
	If idsDoDetail.GetItemString(llDetailFind,'Buyer_Part') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Buyer_Part')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Vendor_Part
	If idsDoDetail.GetItemString(llDetailFind,'Vendor_Part') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Vendor_Part')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail UPC
	If idsDoDetail.GetItemString(llDetailFind,'UPC') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'UPC')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail EAN
	If idsDoDetail.GetItemString(llDetailFind,'EAN') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'EAN')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail GTIN
	If idsDoDetail.GetItemString(llDetailFind,'GTIN') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'GTIN')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Department_Name
	If idsDoDetail.GetItemString(llDetailFind,'Department_Name') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Department_Name')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Division
	If idsDoDetail.GetItemString(llDetailFind,'Division') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Division')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Detail Packaging_Characteristics	
	If idsDoDetail.GetItemString(llDetailFind,'Packaging_Characteristics') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Packaging_Characteristics')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master Account_Nbr                   
	If idsDoMain.GetItemString(1,'Account_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Account_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master ASN_Number                    
	If idsDoMain.GetItemString(1,'ASN_Number') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'ASN_Number')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Client_Cust_PO_Nbr            
	If idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Client_Cust_SO_Nbr            
	If idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Container_Nbr                 
	If idsDoMain.GetItemString(1,'Container_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Container_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Dock_Code                     
	If idsDoMain.GetItemString(1,'Dock_Code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Dock_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Document_Codes                
	If idsDoMain.GetItemString(1,'Document_Codes') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Document_Codes')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Equipment_Nbr                 
	If 	string(idsDoMain.GetItemNumber(1,'Equipment_Nbr')) <> '' Then
		lsOutString += String(idsDoMain.GetItemNumber(1,'Equipment_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master FOB                           
	If idsDoMain.GetItemString(1,'FOB') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master FOB_Bill_Duty_Acct            
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master FOB_Bill_Duty_Party           
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master FOB_Bill_Freight_Party        
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master FOB_Bill_Freight_To_Acct      
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_To_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Freight_To_Acct')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master From_Wh_Loc                   
	If idsDoMain.GetItemString(1,'From_Wh_Loc') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'From_Wh_Loc')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Routing_Nbr                   
	If idsDoMain.GetItemString(1,'Routing_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Routing_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Seal_Nbr                      
	If idsDoMain.GetItemString(1,'Seal_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Seal_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master Shipping_Route                
	If idsDoMain.GetItemString(1,'Shipping_Route') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Shipping_Route')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master SLI_Nbr                       
	If idsDoMain.GetItemString(1,'SLI_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'SLI_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail client_cust_line_no   
	If idsDoDetail.GetItemString(llDetailFind,'client_cust_line_no') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'client_cust_line_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail vat_identifier        
	If idsDoDetail.GetItemString(llDetailFind,'vat_identifier') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'vat_identifier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail CI_Value              
	If idsDoDetail.GetItemString(llDetailFind,'CI_Value') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'CI_Value')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Currency              
	If idsDoDetail.GetItemString(llDetailFind,'Currency') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Currency')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Cust_Line_Nbr         
	If idsDoDetail.GetItemString(llDetailFind,'Cust_Line_Nbr') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Department_Code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Client_Cust_Invoice   
	If idsDoDetail.GetItemString(llDetailFind,'Client_Cust_Invoice') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Client_Cust_Invoice')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Cust_PO_Nbr           
	If idsDoDetail.GetItemString(llDetailFind,'Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Delivery_Nbr          
	If idsDoDetail.GetItemString(llDetailFind,'Delivery_Nbr') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Delivery_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Internal_Price        
	If idsDoDetail.GetItemString(llDetailFind,'Internal_Price') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Internal_Price')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Client_Inv_Type       
	If idsDoDetail.GetItemString(llDetailFind,'Client_Inv_Type') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'Client_Inv_Type')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Detail Permit_Nbr            
	If idsDoDetail.GetItemString(1,'Permit_Nbr') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(1,'Permit_Nbr')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar 
	End If	
	
	//Detail Supplier Code        
	If idsDoDetail.GetItemString(llDetailFind,'supp_code') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'supp_code')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar		
	End If	
	
	//Detail User Line Item No        
	If idsDoDetail.GetItemString(llDetailFind,'user_line_item_no') <> '' Then
		lsOutString += String(idsDoDetail.GetItemString(llDetailFind,'user_line_item_no')) 		//+ lsDelimitChar
	Else
		//lsOutString += lsDelimitChar - Last element does not record delimiter for next element
	End If	
	
/* End of 41 additional named fields ********************************************************************/

	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next Delivery Detail record */


IF ProfileString(gsinifile, asproject, "IncludeGIPackDetail",'N')  = 'Y' THEN

	//Get the Project / Warehouse defaults for UCC
	
	lsWHCode = idsDoMain.GetItemString(1,'wh_code')
	
	SELECT Project.UCC_Company_Prefix INTO :lsUCCCompanyPrefix FROM Project WHERE Project_ID = :asproject USING SQLCA;
	
	IF IsNull(lsUCCCompanyPrefix) Then lsUCCCompanyPrefix = ''
	
	SELECT Warehouse.UCC_Location_Prefix INTO :lsUCCLocationPrefix FROM Warehouse WHERE WH_Code = :lsWHCode USING SQLCA;
	
	IF IsNull(lsUCCLocationPrefix) Then lsUCCLocationPrefix = ''
			
	
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
		
		lsCartonNo = idsdoPack.GetITemString(llRowPos, 'Carton_No')
		
		If IsNull(lsCartonNo) then lsCartonNo = ''
		
		If lsCartonNo <> '' Then
			/*
			lsCartonNo = String( LONG (idsdoPack.GetITemString(llRowPos, 'Carton_No')) , "000000000" )
			
			lsUCCS =  trim((lsUCCCompanyPrefix + lsUCCLocationPrefix + lsCartonNo))
			
			//From BaseLine
			
			liCheck = f_calc_uccs_check_Digit(lsUCCS) 
		
			
			If liCheck >=0 Then
				lsUCCS = "00" + lsUCCS + String(liCheck) /* add 00 at beginning (not part of check digit calculation but included as tag */
			Else
				lsUCCS = "00" + String(lsUCCS,'00000000000000000000') + "0"
			End IF
			
			lsOutString += lsUCCS  + lsDelimitChar
			*/
			lsOutString += lsCartonNo + lsDelimitChar
		Else
			
			lsOutString += lsDelimitChar
	
		END IF
		
		
		//Line Item Number
		
		lsOutString += String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No')) + lsDelimitChar
		
		//SKU
		
		lsOutString += lsSku  + lsDelimitChar	
		
		//Qty
		
		lsOutString += String( idsdoPack.GetITemNumber(llRowPos,'quantity')) + lsDelimitChar
		
		//Weight (Gross for carton, repeated for all records)
		
		//Need to validate. - Make sure this is summing up correctly.
		
		If String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Weight_Gross')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	 
						
		
		//Weight Unit (for the current line/SKU) KG or LB
		 
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString += lsDelimitChar
		End If	
	
		
		//Weight SOM (standard of meas)
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'LB' + lsDelimitChar
			ELSE
				lsOutString += 'KG' + lsDelimitChar
			END IF
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Carton Length
	 
		If String(idsDoPack.GetItemNumber(llRowPos,'Length')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Length')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	 			 
					 
					 
		
		//Carton Width
		 
		 If String(idsDoPack.GetItemNumber(llRowPos,'Width')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Width')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	 			
						 
		 
		
		//Carton Height
					
		 If String(idsDoPack.GetItemNumber(llRowPos,'Height')) <> '' Then
			lsOutString += String(idsDoPack.GetItemNumber(llRowPos,'Height')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	 			
							
		
		//Carton DIM SOM (standard of meas) IN or CM
		
		 If lsSOM <> '' Then
			IF Trim(lsSOM) = 'E' THEN
				lsOutString += 'IN' + lsDelimitChar
			ELSE
				lsOutString += 'CM' + lsDelimitChar
			END IF
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//Ship Tracking Number
		
	
		 If idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Shipper_Tracking_ID')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	    
	
		
		//User Field 1
		
		If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If	
		
		//User Field 2
		If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//InterPack_Count      
		If idsDoPack.GetItemString(llRowPos,'InterPack_Count') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'InterPack_Count'))  + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//InterPack_Type       
		If idsDoPack.GetItemString(llRowPos,'InterPack_Type') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'InterPack_Type'))  + lsDelimitChar
		Else
			lsOutString += lsDelimitChar
		End If		
	
		//Packing Pack_SSCC_No          
		If idsDoPack.GetItemString(llRowPos,'Pack_SSCC_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_SSCC_No')) 	+ lsDelimitChar
		Else
			lsOutString += lsDelimitChar			// - Last element does not record delimiter for next element
		End If	
			
		//Packing Pack_Lot_No          
		If idsDoPack.GetItemString(llRowPos,'Pack_Lot_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_Lot_No')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar 		//- Last element does not record delimiter for next element
		End If	
			
		//Packing Pack_PO_No          
		If idsDoPack.GetItemString(llRowPos,'Pack_PO_No') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_PO_No')) 	+ lsDelimitChar
		Else
			lsOutString += lsDelimitChar 		//- Last element does not record delimiter for next element
		End If	
			
		//Packing Pack_PO_No2         
		If idsDoPack.GetItemString(llRowPos,'Pack_PO_No2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Pack_PO_No2')) + lsDelimitChar
		Else
			lsOutString += lsDelimitChar		// - Last element does not record delimiter for next element
		End If	
			
		//Packing Outerpack_SSCC_NO          
		If idsDoPack.GetItemString(llRowPos,'Outerpack_SSCC_NO') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'Outerpack_SSCC_NO')) 		//+ lsDelimitChar
		Else
			//lsOutString += lsDelimitChar - Last element does not record delimiter for next element
		End If	
			
		idsOut.SetItem(llNewRow,'Project_id', asProject)
		idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
		idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
		idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.dat'
		idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	
	next /*next Delivery Pack record */

END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for Selectron for the Stock Adjustment just made

Long			llNewRow, llNewQty, lloldQty, llRowCount,	llAdjustID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, lsTranType, lsSupplier,  lsUOM, lsWHCode, lsContainerID, lsExpirationDate,  &
				lsSerialNo, lsOldOwner, lsNewOwner, lsOldCoo, lsNewCoo, lsOldLotNo, lsNewLotNo,  &
				lsOldPONo, lsNewPONo, lsOldPONo2, lsNewPONo2, lsUserID, lsUserField1
				
String		lsAdjustmentType		// Movement Type
Datetime		ldtExpirationDt		// Expiration date
Decimal		ldBatchSeq
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

lsWHCode = ldsAdjustment.GetITemString(1,'wh_code')
lsAdjustmentType = ldsAdjustment.GetITemString(1,'Adjustment_Type')
lsSku = ldsAdjustment.GetITemString(1,'sku')
lsSupplier = ldsAdjustment.GetITemString(1,'supp_code')
lsContainerID  = ldsAdjustment.GetITemString(1,'container_id')
ldtExpirationDt = ldsAdjustment.GetITemDatetime(1,"expiration_date")
lsExpirationDate = String(ldsAdjustment.GetITemDatetime(1,"expiration_date"),'yyyymmddhhmm')
lsSerialNo = ldsAdjustment.GetITemString(1,'serial_no')
lsOldOwner =  ldsAdjustment.GetITemString(1,'old_owner_cd')
lsNewOwner =  ldsAdjustment.GetITemString(1,'new_owner_cd')
lsOldInvType = ldsAdjustment.GetITemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = ldsAdjustment.GetITemString(1,"inventory_type")
lsOldCoo = ldsAdjustment.GetITemString(1,'Old_Country_of_Origin')
If isnull(lsOldCoo) then lsOldCoo = ''
lsNewCoo = ldsAdjustment.GetITemString(1,'Country_of_Origin')
If isnull(lsNewCoo) then lsNewCoo = ''
lsOldLotNo = ldsAdjustment.GetITemString(1,'old_lot_no')
If isnull(lsOldLotNo) then lsOldLotNo = ''
lsNewLotNo = ldsAdjustment.GetITemString(1,'lot_no')
If isnull(lsNewLotNo) then lsNewLotNo = ''
lsOldPONo = ldsAdjustment.GetITemString(1,'old_po_no')
If isnull(lsOldPONo) then lsOldPONo = ''
lsNewPONo = ldsAdjustment.GetITemString(1,'po_no')
If isnull(lsNewPONo) then lsNewPONo = ''
lsOldPONo2 = ldsAdjustment.GetITemString(1,'old_po_no2')
If isnull(lsOldPONo2) then lsOldPONo2 = ''
lsNewPONo2 = ldsAdjustment.GetITemString(1,'po_no2')
If isnull(lsNewPONo2) then lsNewPONo2 = ''
lsUserID =  ldsAdjustment.GetITemString(1,'last_user')
lsUserField1 = ldsAdjustment.GetITemString(1,'user_field1')
If isnull(lsUserField1) then lsUserField1 = ''

//We need the Level one UOM from Item Master
Select uom_1 into :lsUOM
From Item_MAster
Where project_id = :asProject and sku = :lsSKU and supp_code = :lsSupplier;

If isNull(lsUOM) Then lsUOM = ""

lsReason = ldsAdjustment.GetITemString(1,'reason')
If isnull(lsReason) then lsReason = ''
	
llAdjustID = ldsAdjustment.GetITemNumber(1,"adjust_no")

llNewQty = ldsAdjustment.GetITemNumber(1,"quantity")
lloldQty = ldsAdjustment.GetITemNumber(1,"old_quantity")
		
// If we are only Sending a record for an Inventory Type Change then un-rem the below.....
//If lsOldInvType = lsNewInvType Then Return 0


//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar

lsOutString = 'MM' + lsDelimitChar /*rec type = Material Movement*/
lsOutString += asproject + lsDelimitChar
lsOutString += lsWhCode + lsDelimitChar
lsOutString += lsAdjustmentType + lsDelimitChar
lsOutString += String(today(),'yyyymmddhhmm') + lsDelimitChar  		// Transaction date
lsOutString += Left(lsReason,4) + lsDelimitChar   /*reason*/
lsOutString += lsSku + lsDelimitChar 
lsOutString += lsContainerID + lsDelimitChar
lsOutString += lsExpirationDate + lsDelimitChar  		// Expiration date
lsOutString += String(alAdjustID,'0000000000000000') + lsDelimitChar /*Internal Ref #*/
lsOutString += String(alAdjustID,'00000000000000000000') + lsDelimitChar /*External Ref #*/
lsOutString += String(lloldQty)  + lsDelimitChar  
lsOutString += String(llNewQty)  + lsDelimitChar 
lsOutString += lsSerialNo + lsDelimitChar  
lsOutString +=lsOldOwner + lsDelimitChar 
lsOutString +=lsNewOwner + lsDelimitChar 
lsOutString +=lsOldInvType + lsDelimitChar 
lsOutString +=lsNewInvType + lsDelimitChar 
lsOutString +=lsOldCoo + lsDelimitChar 
lsOutString +=lsNewCoo + lsDelimitChar 
lsOutString +=lsOldLotNo + lsDelimitChar 
lsOutString +=lsNewLotNo + lsDelimitChar 
lsOutString +=lsOldPONo + lsDelimitChar 
lsOutString +=lsNewPONo + lsDelimitChar 
lsOutString +=lsOldPONo2 + lsDelimitChar 
lsOutString +=lsNewPONo2 + lsDelimitChar 
lsOutString += lsUOM + lsDelimitChar 
lsOutString += lsUserField1				// Last field - No delimitor

//lsOutString += lsSupplier + lsDelimitChar 

llNewRow = idsOut.insertRow(0)
	
idsOut.SetItem(llNewRow,'Project_id', asproject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)

lsFileName = 'MM' + String(ldBatchSeq,'00000000') + '.DAT'
idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
  //Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	

		


Return 0
end function

public function integer uf_gw (string asproject, string aswono);

//Prepare a Workorder Transaction in the GR format  for the workorder order that was just confirmed

Long			llRowPos, llRowCount, llFindRow,	llNewRow,  llWONO
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lsSSCC

DEcimal		ldBatchSeq
Integer		liRC

If Not isvalid(idsOut) Then
	idsOut = Create Datastore
	idsOut.Dataobject = 'd_edi_generic_out'
	lirc = idsOut.SetTransobject(sqlca)
End If

If Not isvalid(idsromain) Then
	idswomain = Create Datastore
	idswomain.Dataobject = 'd_workorder_master'
	idswomain.SetTransObject(SQLCA)
End If

If Not isvalid(idsWODetail) Then
	idsWODetail = Create Datastore
	idsWODetail.Dataobject = 'd_workorder_detail_wono'
	idsWODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsWOPutaway) Then
	idsWOPutaway = Create Datastore
	idsWOPutaway.Dataobject = 'd_workorder_Putaway'		//GailM 9/2/2015 - NYX, like starbucks, want one row per line item number
	idsWOPutaway.SetTransObject(SQLCA)
End If

idsOut.Reset()
//gsWONO =asWONO //29-Sep-2014 :Madhu- KLN B2B Conversion to SPS

lsLogOut = "      Creating GR For WONO: " + asWONO
FileWrite(gilogFileNo,lsLogOut)
	
//Retreive the Receive Header and Putaway records for this order
If idswomain.Retrieve(asProject, asWONO) <> 1 Then
	lsLogOut = "                  *** Unable to retreive Receive Order Header For WONO: " + asWONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


idsWOPutaway.Retrieve(asWONO)
idsWODetail.Retrieve(asWONO)

//GailM - 9/10/2015 - Sort putaway by SKU and SSCC No (PONo2)
idswoPutaway.SetSort("sku, po_no2")
idswoPutaway.Sort()

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Workorder Confirmation.~r~rConfirmation will not be sent!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar
llRowCount = idsWOPutaway.RowCount()

For llRowPos = 1 to llRowCOunt
	
	llNewRow = idsOut.insertRow(0)
	
	
// TAM 2016/02/10 - Get SSCC number using the WO_NO
	llWONO = long(Right ( idswomain.GetItemString(1,'WO_NO' ),7))
	lsSSCC = 'SUB98' + String(llWONO,'0000000000000')

	
	
	//Field Name	Type	Req.	Default	Description
	
	//Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier
	lsOutString = 'SC'  + lsDelimitChar /*rec type = goods receipt*/

	//Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString += asproject + lsDelimitChar

	//Warehouse	C(10)	Yes	N/A	Receiving Warehouse
	lsOutString += upper(idswomain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number
	lsOutString += idswomain.GetItemString(1,'Workorder_Number') + lsDelimitChar

	//Inventory Type	C(1)	Yes	N/A	Item condition
	lsOutString += idsWOPutaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	//Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString += String(idswomain.GetITemDateTime(1,'complete_date'),'yyyymmdd') + lsDelimitChar
	
	//SKU	C(50	Yes	N/A	Material Number
	lsSku =  idsWOPutaway.GetItemString(llRowPos,'sku')
	lsOutString += idsWOPutaway.GetItemString(llRowPos,'sku') + lsDelimitChar

	//Supp Code
	lsSuppCode = idsWOPutaway.GetItemString(llRowPos,'supp_code')
	lsOutString += idsWOPutaway.GetItemString(llRowPos,'supp_code') + lsDelimitChar
	
	//Quantity	N(15,5)	Yes	N/A	Received quantity
	lsOutString += string(idsWOPutaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
	//Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	If idsWOPutaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
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

	//Serial Number	C(50)	No	N/A	Qty must be 1 if present
	If idsWOPutaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsWOPutaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
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
	If Not IsNull(idsWOPutaway.GetItemDateTime(llRowPos,'expiration_date')) Then
		lsOutString += String(idsWOPutaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyymmdd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	//Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
	lsOutString += String(idswoputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
	
	
	llFindRow = idsWODetail.Find("sku='"+lsSku+"' and supp_code = '"+lsSuppCode+"' ", 1, idsWODetail.RowCount())
	
	//Detail User Customer Line Number	C(25)	No	N/A	Line Item No  17
		lsOutString += lsDelimitChar

	//Detail User Field1	C(50)	No	N/A	User Field  18
	If llFindRow > 0 AND idsWODetail.GetItemString(llFindRow,'user_field1') <> '' Then
		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field2	C(50)	No	N/A	User Field  19
	If llFindRow > 0 AND  idsWODetail.GetItemString(llFindRow,'user_field2') <> '' Then
		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	//Detail User Field3	C(50)	No	N/A	User Field  20
// TAM 2016/02/08 - Using WO_NO to create a "SSCC" number per the Following Format.  
	llWONO = long(Right ( idswomain.GetItemString(1,'WO_NO' ),7))
	lsSSCC = 'SUB98' + String(llWONO,'0000000000000')
		lsOutString += lsSSCC + lsDelimitChar
//	If llFindRow > 0 AND  idsWODetail.GetItemString(llFindRow,'user_field3') <> '' Then
//		lsOutString += String(idsWODetail.GetItemString(llFindRow,'user_field3')) + lsDelimitChar
//	Else
//		lsOutString += lsDelimitChar
//	End If		
	
	//Detail User Field4	C(50)	No	N/A	User Field  24
		lsOutString += lsDelimitChar
	//Detail User Field5	C(50)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Detail User Field6	C(50)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field1	C(10)	No	N/A	User Field
	If idswomain.GetItemString(1,'user_field1') <> '' Then
		lsOutString += String(idswomain.GetItemString(1,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field2	C(10)	No	N/A	User Field
	If idswomain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idswomain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	//Master User Field3	C(10)	No	N/A	User Field
	If idswomain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idswomain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	//Master User Field4	C(20)	No	N/A	User Field
	If idswomain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idswomain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	//Master User Field5	C(20)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field6	C(20)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field7	C(30)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field8	C(30)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field9	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field10	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field11	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field12	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field13	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field14	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
	//Master User Field15	C(255)	No	N/A	User Field
		lsOutString += lsDelimitChar
		
	//BCR 14-SEP-2011: Changes for Riverbed...
	//MEA 01-NOV-2011: Added Columns for Baseline
	
	// 08/12 - PCOnkl - ** DO NOT ADD PROJECT SPECIFIC VALUES. THIS IS BASELINE **

//Carrier
	lsOutString += lsDelimitChar
//Country Of Origin
	lsOutString += lsDelimitChar
//UnitOfMeasure
	lsOutString += 'EA' + lsDelimitChar
//AWB #
	lsOutString += lsDelimitChar
//Get from Item_Master
Select grp INTO :lsGrp From Item_Master
	Where sku = :lsSku and supp_code = :lsSuppCode and project_id = :asproject
	USING SQLCA;
			
If IsNull(lsGrp) then lsGrp = ''

lsOutString += lsGrp + lsDelimitChar 

/**********************************************************************************************/
/*20150508 - GailM -- Adding new named fields...  New named fields for Klonelab will be entered ahead of cononical named fields */
/* New ICC fields will be 107 columns after adding 41 named fields                                                                                           */
/**********************************************************************************************/

// 44 - Client_Cust_PO_NBR
		lsOutString += lsDelimitChar
// 45 - Client_Invoice_Nbr
		lsOutString += lsDelimitChar
// 46 - Container_Nbr
		lsOutString += lsDelimitChar
// 47 - Client_Order_Type
		If idswomain.GetItemString(1,'Ord_Type') <> '' Then
			lsOutString += String(idswomain.GetItemString(1,'Ord_Type')) + lsDelimitChar
		Else
			lsOutString += 'S' + lsDelimitChar
		End If	
		lsOutString += lsDelimitChar
// 48 - Container_Type
		lsOutString += lsDelimitChar
// 49 - From_Wh_Loc
		lsOutString += lsDelimitChar
// 50 - Seal_Nbr
		lsOutString += lsDelimitChar
// 51 - Vendor_Invoice_Nbr
		lsOutString += lsDelimitChar
// 52 - Currency_Code
		lsOutString += lsDelimitChar
// 53 - Supplier_Order_Number
		lsOutString += lsDelimitChar
// 54 - Cust_PO_Nbr
		lsOutString += lsDelimitChar
// 55 - Line_Container_Nbr
		lsOutString += lsDelimitChar
// 56 -Vendor_Line_Nbr
		lsOutString += String(idswoputaway.GetItemNumber(llRowPos,'line_item_no')) + lsDelimitChar
// 57 - Client_Line_Nbr
		lsOutString += lsDelimitChar
// 58 - Detail Client_Cust_PO_NBR 
		 lsOutString += lsDelimitChar		
// 59 - SSCC Bbr 
		// += lsDelimitChar		//  Last element does not record delimiter for next element

	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'SC' + String(ldBatchSeq,'00000000') + '.DAT'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)

	
	
	
next /*next output record */


If idsOut.RowCount() > 0 Then
	gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
End If

Return 0

end function

on u_nvo_edi_confirmations_nyx.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_nyx.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

