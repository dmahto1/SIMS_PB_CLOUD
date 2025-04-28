$PBExportHeader$u_nvo_edi_confirmations_loreal.sru
forward
global type u_nvo_edi_confirmations_loreal from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_loreal from nonvisualobject
end type
global u_nvo_edi_confirmations_loreal u_nvo_edi_confirmations_loreal

type variables

Datastore	idsROMain, idsRODetail, idsROPutaway, idsDOMain, idsDODetail, idsDOPick, idsDOPack,	&
				idsOut, idsGR, idsAdjustment, idsWOMain, idsWOPick, idsCOO_Translate, idsDoSerial
				
u_nvo_marc_transactions		iu_nvo_marc_transactions	
u_nvo_edi_confirmations_baseline_unicode	iu_edi_confirmations_baseline_unicode


string lsDelimitChar
end variables

forward prototypes
public function integer uf_gr (string asproject, string asrono)
public function integer uf_process_gr (string asproject, string asrono)
public function integer uf_process_boh (string asinifile, string asproject)
public function integer uf_adjustment (string asproject, long aladjustid)
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function integer uf_gr (string asproject, string asrono);

uf_process_gr(asProject, asrono)	


Return 0
end function

public function integer uf_process_gr (string asproject, string asrono);
//Prepare a Goods Receipt Transaction for NYX\L'Oreal for the order that was just confirmed

// 08/13 - PCONKL - Consolidating Inbound Orders, need to split them back out in the GR
//	NYX Order NUmber is stored in Detail UF3 and we need a sperate file per NYX Order

Long			llRowPos, llRowCount, llDetailFindRow,	llNewRow, llLineItemNo
				
String		lsFind, lsOutString,	lsMessage, lsLogOut, lsFileName,  lsSku, lsSuppCode, lsCOO, lsGrp, lSOrderSave, lsOrder

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

// 08/13 - PCONKL - We are breaking on NYX Order Number in RD UF3 but we are looping on Putaway.
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
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to NYX!'"
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
	
	
	// 08/13 - PCONKL - NYX Order Number loaded in to UF13 above either from Detail UF3 or Header ORder Number
	lsOrder = idsRoPutaway.GetITemString(llRowPos,'User_Field5')
	
	//If Order has changed, write existing Data
	if lsOrder <> lsOrderSave and idsOut.RowCount() > 0 Then
		
		gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut, asproject)
		idsOut.Reset()
		
		ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
		If ldBatchSeq <= 0 Then
			lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Receipt Confirmation.~r~rConfirmation will not be sent to NYX!'"
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
		
	End If /* New Order */
	
	lsOrderSave = lsOrder
	
	llNewRow = idsOut.insertRow(0)
	
	//Field Name	Type	Req.	Default	Description
	
	// 1 - Record_ID	C(2)	Yes	“GR”	Goods receipt confirmation identifier
	lsOutString = 'GR'  + lsDelimitChar /*rec type = goods receipt*/

	// 2 - Project ID	C(10)	Yes	N/A	Project identifier
	lsOutString += asproject + lsDelimitChar

	// 3 -Warehouse	C(10)	Yes	N/A	Receiving Warehouse
	lsOutString += upper(idsroMain.getItemString(1, 'wh_code'))  + lsDelimitChar

	//Order Number	C(20)	Yes	N/A	Purchase order number
	// 08/13 - PCONKL - ORder NUmber now coming from Detail UF 3 (retrieved above) since we are consolidating Orders
	
	//` 4 - lsOutString += idsROMain.GetItemString(1,'supp_invoice_no') + lsDelimitChar
	lsOutString += lsOrder + lsDelimitChar

	// 5 - Inventory Type	C(1)	Yes	N/A	Item condition
	lsOutString += idsroputaway.GetItemString(llRowPos,'inventory_type') + lsDelimitChar
	
	// 6 - Receipt Date	Date	Yes	N/A	Receipt completion date
	lsOutString += String(idsROMain.GetITemDateTime(1,'complete_date'),'yyyy-mm-dd') + lsDelimitChar
	
	// 7 - SKU	C(50	Yes	N/A	Material Number
	lsSku =  idsroputaway.GetItemString(llRowPos,'sku')
	lsOutString +=lsSku + lsDelimitChar

	// 8 - Supplier Code	C(20	Yes	N/A	Supplier Code
	lsSuppCode = idsroputaway.GetItemString(llRowPos,'supp_code')
	lsOutString += lsSuppCode + lsDelimitChar		
	
	// 9 - Quantity	N(15,5)	Yes	N/A	Received quantity
	lsOutString += string(idsroputaway.GetItemNumber(llRowPos,'quantity')) + lsDelimitChar	
	
	// 10 - Lot Number	C(50)	No	N/A	1st User Defined Inventory field
	If idsroputaway.GetItemString(llRowPos,'lot_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'lot_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 11 - PO NBR	C(50)	No	N/A	2nd User Defined Inventory field
	If idsroputaway.GetItemString(llRowPos,'po_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 12 - PO NBR 2	C(50)	No	N/A	3rd User Defined Inventory Field
	If idsroputaway.GetItemString(llRowPos,'po_no2') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'po_no2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	
	// 13 - Serial Number	C(50)	No	N/A	Qty must be 1 if present
	If idsroputaway.GetItemString(llRowPos,'serial_no') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'serial_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	// 14 -Container ID	C(25)	No	N/A	
	If idsroputaway.GetItemString(llRowPos,'container_id') <> '-' Then
		lsOutString += String(idsroputaway.GetItemString(llRowPos,'container_id')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		

	// 15 - Expiration Date	Date	No	N/A	
	If Not IsNull(idsroputaway.GetItemDateTime(llRowPos,'expiration_date')) Then
		lsOutString += String(idsroputaway.GetItemDateTime(llRowPos,'expiration_date'),'yyyy-mm-dd') + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	// 16 - Line Item Number	N(6,0)	Yes	N/A	Item number of purchase order document
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
	
	// 17 - Detail User Customer Line Number	C(25)	No	N/A	User Line Item No
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_line_item_no')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	
	// 18 - Detail User Field1	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'user_field1') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	// 19 - Detail User Field2	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field2') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
		
	// 20 - Detail User Field3	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field3') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	// 21 - Detail User Field4	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field4') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	// 22 -Detail User Field5	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field5') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	// 23 - Detail User Field6	C(50)	No	N/A	User Field
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'user_field6') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	
	// 24 -Master User Field1	C(10)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field1') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field1')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 25 - Master User Field2	C(10)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field2') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field2')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

	// 26 - Master User Field3	C(10)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field3') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field3')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	// 27 - Master User Field4	C(20)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field4') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field4')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 28 -Master User Field5	C(20)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field5') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field5')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	// 29 = Master User Field6	C(20)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field6') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field6')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 30 - Master User Field7	C(30)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field7') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field7')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 31 - Master User Field8	C(30)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field8') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field8')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 32 - Master User Field9	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field9') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field9')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 33 -Master User Field10	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field10') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field10')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 34 -Master User Field11	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field11') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field11')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 35 - Master User Field12	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field12') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field12')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	// 36 - Master User Field13	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field13') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field13')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If		
	
	// 37 - Master User Field14	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field14') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field14')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
	
	// 38 - Master User Field15	C(255)	No	N/A	User Field
	If idsROMain.GetItemString(1,'user_field15') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'user_field15')) //+ lsDelimitChar
	Else
		lsOutString += lsDelimitChar 
	End If	
		
	// 39 - Carrier
	If idsROMain.GetItemString(1,'carrier') <> '' Then
		lsOutString += String(idsROMain.GetItemString(1,'carrier')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	
		
	// 40 - Country Of Origin
	If llDetailFindRow > 0 AND  idsRODetail.GetItemString(llDetailFindRow,'country_of_origin') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'country_of_origin')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If			
			
	// 41 - UnitOfMeasure
	If llDetailFindRow > 0 AND idsRODetail.GetItemString(llDetailFindRow,'uom') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(llDetailFindRow,'uom')) + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If				
		
	// 42 - AWB #
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
	//lsOutString += lsGrp  // Last item in GR so no Delimeter

	// 43 - Item Master Group
	If lsGrp<> '' Then
		lsOutString += lsGrp + lsDelimitChar
	Else
		lsOutString += lsDelimitChar
	End If	

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

// 58 - Client_Cust_PO_NBR 
	If idsRODetail.GetItemString(1,'Client_Cust_PO_NBR') <> '' Then
		lsOutString += String(idsRODetail.GetItemString(1,'Client_Cust_PO_NBR')) 	//+ lsDelimitChar
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

public function integer uf_process_boh (string asinifile, string asproject);//Process Daily Balance on Hand Confirmation File

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
ldsboh.Dataobject = 'd_loreal_dboh'
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

public function integer uf_adjustment (string asproject, long aladjustid);//Prepare a Stock Adjustment Transaction for NYX / L'Oreal for the Stock Adjustment just made

Long			llNewRow, llOldQty, llNewQty, llRowCount,	llAdjustID, llOwnerID, llOrigOwnerID
				
String		lsOutString, lsMessage,	lsSKU, lsOldInvType,	lsNewInvType, lsFileName,		&
				lsReason, 	lsTranType, lsSupplier, lsWarehouse, lsMaquetwarehouse, lsRONO, lsOrder, lsPosNeg, lsExpDate, lsSerial

Decimal		ldBatchSeq, ldNetQty
Integer		liRC
String	lsLogOut

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

//Retrieve the adjustment record
If idsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If


//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = idsAdjustment.GetItemString(1,'ro_no')

lsSku = idsAdjustment.GetItemString(1,'sku')
lsSupplier = idsAdjustment.GetItemString(1,'supp_code')

//If Supplier <> 'Maquet' then concatonate with SKU
If Upper(lsSupplier) <> 'MAQUET' Then
	lsSKU = lsSupplier + "#" + lsSKU
End If

lsReason = idsAdjustment.GetItemString(1,'reason')
If isnull(lsReason) then lsReason = ''
	
lsOldInvType = idsAdjustment.GetItemString(1,"old_inventory_type") /*original value before update!*/
lsNewInvType = idsAdjustment.GetItemString(1,"inventory_type")

llOwnerID = idsAdjustment.GetItemNumber(1,"owner_ID")
llOrigOwnerID = idsAdjustment.GetItemNumber(1,"old_owner")

llAdjustID = idsAdjustment.GetItemNumber(1,"adjust_no")

llNewQty = idsAdjustment.GetItemNumber(1,"quantity")
lloldQty = idsAdjustment.GetItemNumber(1,"old_quantity")

lsExpDate = String(idsAdjustment.GetItemDateTime(1,"expiration_date"),'YYYYMMDD')

		
//We are only sending Qty Change or Breakage (New Inv Type = 'D')
//If lsNewInvType = 'D' or (llNewQTY <> llOldQTY)  Then

// If (llNewQTY <> llOldQTY)  Then Send //MA - 5/09
If (llNewQTY <> llOldQTY) Then	
	
	//Set TransType
	If llOldQty <> llNewQty Then
		lsTranType = 'QTY'
	Elseif lsOldInvType <> lsNewInvType Then
		lsTranType = 'INV'
	Else
		lsTranType = 'OTH'
	End If
		
	//Get the Next Batch Seq Nbr - Used for all writing to generic tables
	ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'EDI_Generic_Outbound','EDI_Batch_Seq_No')
	If ldBatchSeq <= 0 Then
		lsLogOut = "        *** Unable to retreive Next Available Sequence Number"
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If
		
	//Convert our WH to Their Code
	lsWarehouse = idsAdjustment.GetItemString(1,'wh_code')
		
	Select user_field1 into :lsMaquetwarehouse
	From Warehouse
	Where wh_code = :lsWarehouse;
	
	If isnull(lsMaquetwarehouse) Then lsMaquetwarehouse = lswarehouse
	
	lsOutString = 'MM|' /*rec type = Material Movement*/
	lsOutString += lsTranType + "|" 
	lsOutString += left(lsOldInvType,1) + "|" /*old Inv Type*/
	lsOutString += left(lsNewInvType,1) + "|" /*New Inv Type*/
	lsOutString += String(today(),'yyyymmddHHMMSS') + "|" 
	lsOutString += Left(lsReason,20) + "|"  /*reason*/
	lsOutString += Left(lsSku,50) + "|" 
	lsOutString += String(llOldQty) + "|" 
	lsOutString += String(llNewQty) + "|" 
	lsOutString += String(alAdjustID) + "|" /*Transaction Number*/
	lsOutString += lsRONO + "|"  /* Ref NUmber*/
	lsOutString += + "|"  /*Owner*/
	lsOutString += lsMaquetwarehouse + "|" 
	
	// Package Code (PO_NO)
	If idsAdjustment.GetItemString(1,"PO_No") <> '-' Then
		lsOutString += idsAdjustment.GetItemString(1,"PO_No") + "|"
	Else
		lsOutString += "|"
	End If
	
	// Lot_NO
	If idsAdjustment.GetItemString(1,"Lot_No") <> '-' Then
		lsOutString += idsAdjustment.GetItemString(1,"Lot_No") + "|"
	Else
		lsOutString += "|"
	End If
		
	//Expiration Date
	If lsExpDate <> "29991231" Then
		lsOutString += lsExpDate + "|"
	Else
		lsOutString += "|"
	End If
	
// dts - 08/27/08 - added Serial # for End-to-End serial tracking
	//Serial #
	If idsAdjustment.GetItemString(1,"Serial_No") <> '-' Then
		lsOutString += idsAdjustment.GetItemString(1,"Serial_No") //+ "|"
	End If
	
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'N947' + String(ldBatchSeq,'000000') + ".DAT"
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
		
	// Add a trailer Row
	lsOutString = '1|TR| |' /*record count always = 1, action code is blank */
	lsOutString += String(today(),'HHMMSS') + "|"
	lsOutString += " |"
	lsOutString += String(today(),'YYYYMMDD') 
	
	llNewRow = idsOut.insertRow(0)
	
	idsOut.SetItem(llNewRow,'Project_id', asproject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
	lsFileName = 'N947' + String(ldBatchSeq,'000000') + ".DAT"
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	
	
	//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
	gu_nvo_process_files.uf_process_flatfile_outbound(idsOut,asProject)
	
//End If /* inv type changed*/
		
End If

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
		lsOutString += String(idsDoMain.GetItemString(1,'user_field22')) //+ lsDelimitChar //04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes.
	Else
		lsOutString +=lsDelimitChar //04-Nov-2014 :Madhu- commented- As ICC is expecting only 66 attributes. 8May15 gwm uncommented to add named fields
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
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Department_Name
	If idsDoMain.GetItemString(1,'Department_Name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Division
	If idsDoMain.GetItemString(1,' Division') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,' Division')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
    //Master Vendor
	If idsDoMain.GetItemString(1,'Vendor') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Vendor')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Buyer_Part 
	If idsDoMain.GetItemString(1,'Buyer_Part ') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Buyer_Part ')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Vendor_Part
	If idsDoMain.GetItemString(1,'Vendor_Part') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Vendor_Part')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail UPC
	If idsDoMain.GetItemString(1,'UPC') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'UPC')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail EAN
	If idsDoMain.GetItemString(1,'EAN') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'EAN')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail GTIN
	If idsDoMain.GetItemString(1,'GTIN') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'GTIN')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Department_Name
	If idsDoMain.GetItemString(1,'Department_Name') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Name')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Division
	If idsDoMain.GetItemString(1,'Division') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Division')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail SSCC_No
	If idsDoMain.GetItemString(1,'SSCC_No') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'SSCC_No')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Account_Nbr                   
	If idsDoMain.GetItemString(1,'Account_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Account_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master ASN_Number                    
	If idsDoMain.GetItemString(1,'ASN_Number') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'ASN_Number')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Client_Cust_PO_Nbr            
	If idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Client_Cust_SO_Nbr            
	If idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_SO_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Container_Nbr                 
	If idsDoMain.GetItemString(1,'Container_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Container_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Dock_Code                     
	If idsDoMain.GetItemString(1,'Dock_Code') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Dock_Code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Document_Codes                
	If idsDoMain.GetItemString(1,'Document_Codes') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Document_Codes')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Equipment_Nbr                 
	If idsDoMain.GetItemString(1,'Equipment_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Equipment_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master FOB                           
	If idsDoMain.GetItemString(1,'FOB') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master FOB_Bill_Duty_Acct            
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Acct')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master FOB_Bill_Duty_Party           
	If idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Duty_Party')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master FOB_Bill_Freight_Party        
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'FOB_Bill_Freight_Party')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master FOB_Bill_Freight_To_Acct      
	If idsDoMain.GetItemString(1,'FOB_Bill_Freight_To_Acct') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master From_Wh_Loc                   
	If idsDoMain.GetItemString(1,'From_Wh_Loc') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'From_Wh_Loc')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Routing_Nbr                   
	If idsDoMain.GetItemString(1,'Routing_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Routing_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Seal_Nbr                      
	If idsDoMain.GetItemString(1,'Seal_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Seal_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master Shipping_Route                
	If idsDoMain.GetItemString(1,'Shipping_Route') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Shipping_Route')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Master SLI_Nbr                       
	If idsDoMain.GetItemString(1,'SLI_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'SLI_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail client_cust_line_no   
	If idsDoMain.GetItemString(1,'client_cust_line_no') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'client_cust_line_no')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail vat_identifier        
	If idsDoMain.GetItemString(1,'vat_identifier') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'vat_identifier')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail CI_Value              
	If idsDoMain.GetItemString(1,'CI_Value') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'CI_Value')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Currency              
	If idsDoMain.GetItemString(1,'Currency') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Currency')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Cust_Line_Nbr         
	If idsDoMain.GetItemString(1,'Cust_Line_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Department_Code')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Client_Cust_Invoice   
	If idsDoMain.GetItemString(1,'Client_Cust_Invoice') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Cust_Invoice')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Cust_PO_Nbr           
	If idsDoMain.GetItemString(1,'Cust_PO_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Cust_PO_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Delivery_Nbr          
	If idsDoMain.GetItemString(1,'Delivery_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Delivery_Nbr')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Internal_Price        
	If idsDoMain.GetItemString(1,'Internal_Price') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Internal_Price')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Client_Inv_Type       
	If idsDoMain.GetItemString(1,'Client_Inv_Type') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Client_Inv_Type')) + lsDelimitChar
	Else
		lsOutString +=lsDelimitChar
	End If	
	
	//Detail Permit_Nbr            
	If idsDoMain.GetItemString(1,'Permit_Nbr') <> '' Then
		lsOutString += String(idsDoMain.GetItemString(1,'Permit_Nbr')) 		//+ lsDelimitChar
	Else
		//lsOutString +=lsDelimitChar - Last element does not record delimiter for next element
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
			
		Else
			
			lsOutString +=lsDelimitChar
	
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
		
		If idsDoPack.GetItemString(llRowPos,'user_field1') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field1')) + lsDelimitChar
		Else
			lsOutString +=lsDelimitChar
		End If	
		
		//User Field 2
		
		If idsDoPack.GetItemString(llRowPos,'user_field2') <> '' Then
			lsOutString += String(idsDoPack.GetItemString(llRowPos,'user_field2'))  //+ lsDelimitChar
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

END IF

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)



Return 0
end function

on u_nvo_edi_confirmations_loreal.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_loreal.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

