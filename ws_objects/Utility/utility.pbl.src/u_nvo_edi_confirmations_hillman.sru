$PBExportHeader$u_nvo_edi_confirmations_hillman.sru
$PBExportComments$Process outbound edi confirmation transactions for Ambit
forward
global type u_nvo_edi_confirmations_hillman from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_hillman from nonvisualobject
end type
global u_nvo_edi_confirmations_hillman u_nvo_edi_confirmations_hillman

forward prototypes
public function integer uf_process_boh (string asproject)
public function integer uf_process_or (string asproject)
public function integer uf_goods_issue (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick, ref datawindow adw_pack)
end prototypes

public function integer uf_process_boh (string asproject);
//GAP1203 Process the Hillman Balance on Hand Confirmation File

Datastore	ldsOut,	&
				ldsItems, &
				ldsContentSum, &
				ldsContent, &
				ldsReceive, &
				ldsDelivery
				
Long			llRowPos,llNewRow, llRowCount, llContentSum, llContent, llReceive, llDelivery, ll_found, llMAX, llMIN
				
String		lsOutString,lsSKU,lsFindSKU, lsMessage

DEcimal		ldBatchSeq, ldTotal, ldQTY1, ldQTY2
Integer		liRC

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsItems = Create Datastore
ldsItems.Dataobject = 'd_items'
lirc = ldsItems.SetTransobject(sqlca)

ldsContentSum = Create Datastore
ldsContentSum.Dataobject = 'd_hillman_content_summary'
lirc = ldsContentSum.SetTransobject(sqlca)

ldsContent = Create Datastore
ldsContent.Dataobject = 'd_hillman_Content'
lirc = ldsContent.SetTransobject(sqlca)

ldsReceive = Create Datastore
ldsReceive.Dataobject = 'd_hillman_Receive'
lirc = ldsReceive.SetTransobject(sqlca)

ldsDelivery = Create Datastore
ldsDelivery.Dataobject = 'd_hillman_Delivery'
lirc = ldsDelivery.SetTransobject(sqlca)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
Execute Immediate "COMMIT" using SQLCA;

If ldBatchSeq <= 0 Then
	lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN BOH confirmation."
	MESSAGEBOX("BATCH SEQUENCE ERROR",lsMessage)
	Return -1
End If

//Retrive ISKUS from Item master 
llRowCOunt = ldsItems.Retrieve(asProject) 

//Load Data Stores with  BOH Data
llContent = ldsContent.Retrieve(asProject) 
llContentSum = ldsContentSum.Retrieve(asProject) 
llDelivery = ldsDelivery.Retrieve(asProject) 
llReceive = ldsReceive.Retrieve(asProject) 

//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	
	//rec type = balance on Hand Confirmation
	lsOutString = 'BH' 
	
	//SKU
	lsSKU = ldsItems.GetItemString(llRowPos,'sku')
	lsOutString += lsSKU + space(50 - len(lsSKU))
	lsFindSKU = "sku = '" + lsSKU + "'"
	
	// Calculate ON HAND QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsContent.Find(lsFindSKU,1, llContent)
	if ll_found > 0 then ldQTY1 = ldsContent.GetItemNumber(ll_found,'c_avail_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_alloc_qty')	
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	// Calculate Open Orders QTY
	ldQTY1 = 0
	ldTotal = 0
	ll_found = ldsDelivery.Find(lsFindSKU,1, llDelivery)
	if ll_found > 0 then ldQTY1 = ldsDelivery.GetItemNumber(ll_found,'c_req_qty')
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	
	
	// Calculate ON Order QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsReceive.Find(lsFindSKU,1, llReceive)	
	if ll_found > 0 then ldQTY1 = ldsReceive.GetItemNumber(ll_found,'c_req_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)	
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_sit_qty')	
	ldTotal = ldQTY1 + ldQTY2
	ldTotal = ldTotal * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	

	// get min and Max from Reorder_point Table
	llMAX = 0
	llMIN = 0
	Select MAX_Supply_OnHand, MIN_ROP 
	into :llMAX, :llMIN
	From Reorder_Point
	where sku = :lsSKU and supp_code = "HILLMAN";
	llMIN = llMIN * 100000 // 5 implied decimals
	lsOutString += string(llMIN,'000000000000000')
	llMAX = llMAX * 100000 // 5 implied decimals
	lsOutString += string(llMAX,'000000000000000')

	ldsOut.SetItem(llNewRow,'Project_id', asProject)
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
	
next /*next output record */

//Save the changes to the generic output table - FP will write to flat file
If llRowCount > 0 Then
	liRC = ldsOut.Update()
	If liRC = 1 Then
		Execute Immediate "COMMIT" using SQLCA;
		Return 0
	Else
		lsMessage= SQLCA.SQLErrText
		Execute Immediate "ROLLBACK" using SQLCA;
	End If
else
		lsMessage = 'No inventory (Item Master) records found!'
End If

MessageBox('BOH', 'Unable to save/send BOH file: ' + lsMessage)
Return -1	
end function

public function integer uf_process_or (string asproject);
//GAP1203 Process the Hillman Order Replenishment Confirmation File

Datastore	ldsPOheader, 	&
				ldsPOdetail, 	&
				ldsOut,			&
				ldsItems, 		&
				ldsContentSum, &
				ldsContent, 	&
				ldsReceive, 	&
				ldsDelivery
				
Long			llRowPos,		&
				llNewRow,		&
				llNewRowPM,		&
				llNewRowPD,		&
				llRowCount,		&
				llContentSum,	&
				llContent,		&
				llReceive,		&
				llDelivery,		&
				ll_found,		&
				llMAX,			&
				llMIN,			&
				llReOrderQTY, 	&
				llOpenQTY, 		&
				llOnOrderQTY, 	&	
				llOnHandQTY, 	&	
				llLineItemNO, 	&
				llOwner, 		&
				llDetailSeq, 	&
				llOrderSeq
				
String		lsOutString, 	&
				lsPostString, 	&
				lsSKU,			&
				lsFindSKU,		&
				lsMessage,		&
				lsSuppInvNo,	&
				lsWarehouse, 	&
				lsArrivalDate
				
DEcimal		ldBatchSeq, 	&
				ldEDIBAtchSeq,	&
				ldTotal, 		&
				ldQTY1, 			&
				ldQTY2
			
Integer		liRC, liMo, liDay, liYear

Boolean 		lbOnce, lbError

 
Date	ldtToday


lbOnce = false
llLineItemNO = 0

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsItems = Create Datastore
ldsItems.Dataobject = 'd_items'
lirc = ldsItems.SetTransobject(sqlca)

ldsContentSum = Create Datastore
ldsContentSum.Dataobject = 'd_hillman_content_summary'
lirc = ldsContentSum.SetTransobject(sqlca)

ldsContent = Create Datastore
ldsContent.Dataobject = 'd_hillman_Content'
lirc = ldsContent.SetTransobject(sqlca)

ldsReceive = Create Datastore
ldsReceive.Dataobject = 'd_hillman_Receive'
lirc = ldsReceive.SetTransobject(sqlca)

ldsDelivery = Create Datastore
ldsDelivery.Dataobject = 'd_hillman_Delivery'
lirc = ldsDelivery.SetTransobject(sqlca)

ldsPOheader = Create Datastore
ldsPOheader.Dataobject = 'd_po_header'
lirc = ldsOut.SetTransobject(sqlca)

ldsPOdetail = Create Datastore
ldsPOdetail.Dataobject = 'd_po_detail'
lirc = ldsPOdetail.SetTransobject(sqlca)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
sqlca.sp_next_avail_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldBatchSeq)
Execute Immediate "COMMIT" using SQLCA;

If ldBatchSeq <= 0 Then
	lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN OR confirmation."
	MESSAGEBOX("BATCH SEQUENCE ERROR",lsMessage)
	Return -1
End If

//Retrive ISKUS from Item master 
llRowCOunt = ldsItems.Retrieve(asProject) 

//Load Data Stores with  OR Data
llContent = ldsContent.Retrieve(asProject) 
llContentSum = ldsContentSum.Retrieve(asProject) 
llDelivery = ldsDelivery.Retrieve(asProject) 
llReceive = ldsReceive.Retrieve(asProject) 

//Write the rows to the generic output table
For llRowPos = 1 to llRowCOunt
	
	llNewRow = ldsOut.insertRow(0)
	
	//SKU
	lsSKU = ldsItems.GetItemString(llRowPos,'sku')
	lsOutString = lsSKU + space(50 - len(lsSKU))
	lsFindSKU = "sku = '" + lsSKU + "'"
	
	// Calculate ON HAND QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsContent.Find(lsFindSKU,1, llContent)
	if ll_found > 0 then ldQTY1 = ldsContent.GetItemNumber(ll_found,'c_avail_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_alloc_qty')	
	llOnHandQTY = ldQTY1 + ldQTY2
	ldTotal = llOnHandQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	// Calculate Open Orders QTY
	ldQTY1 = 0
	ldTotal = 0
	ll_found = ldsDelivery.Find(lsFindSKU,1, llDelivery)
	if ll_found > 0 then ldQTY1 = ldsDelivery.GetItemNumber(ll_found,'c_req_qty')
	llOpenQTY = ldQTY1 + ldQTY2
	ldTotal = llOpenQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	
	
	// Calculate ON Order QTY
	ldQTY1 = 0
	ldQTY2 = 0
	ldTotal = 0
	ll_found = ldsReceive.Find(lsFindSKU,1, llReceive)	
	if ll_found > 0 then ldQTY1 = ldsReceive.GetItemNumber(ll_found,'c_req_qty')
	ll_found = ldsContentSum.Find(lsFindSKU,1, llContentSum)	
	if ll_found > 0 then ldQTY2 = ldsContentSum.GetItemNumber(ll_found,'c_sit_qty')	
	llOnOrderQTY = ldQTY1 + ldQTY2
	ldTotal = llOnOrderQTY * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')	

	// get min and Max from Reorder_point Table
	llMAX = 0
	llMIN = 0
	Select MAX_Supply_OnHand, MIN_ROP, ReOrder_QTY
	into :llMAX, :llMIN, :llReOrderQTY
	From Reorder_Point
	where sku = :lsSKU and supp_code = "HILLMAN";
	ldTotal = llMIN * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	ldTotal = llMAX * 100000 // 5 implied decimals
	lsOutString += string(ldTotal,'000000000000000')
	
	/* create a record when available QTY - requested qty drops below  the min_rop */
	If llMin > 0 and llReOrderQTY > 0 then
		
		ldTotal =  (llOnHandQTY + llOnOrderQTY) - llOpenQTY //Net QTY
		
		if ldTotal <= llMIN then //check to see if net quantity is less than Min ROP qty
		
			if lbOnce = false then // create PM header record Once!
				lbOnce = true
	
				//Warehouse defaulted from project master default warehouse - only need to retrieve once
				Select wh_code into :lsWarehouse
				From Project
				Where Project_id = :asProject;

				//Retrieve default Owner to be used for new items where we are defaulting to SS (not presnt in File)
				//Owner defaults to owner ID created for Supplier HILLMAN
				Select owner_id into :llOwner
				From Owner
				Where project_id = :asProject and owner_type = 'S' and Owner_cd = 'HILLMAN';
				
				llNewRowPM = ldsPOheader.InsertRow(0)
	
				//Get the next available Seq #
				sqlca.sp_next_avail_seq_no(asProject,'EDI_Inbound_Header','EDI_Batch_Seq_No',ldEDIBAtchSeq)
				If ldEDIBatchSeq < 0 Then
					lsMessage = "   ***Unable to retrive next available sequence number for HILLMAN OR confirmation."
					MESSAGEBOX("BATCH SEQUENCE ERROR",lsMessage)
					Return -1
				End If	
	
				//Header Defaults
				ldsPOheader.SetITem(llNewRowPM,'wh_code',lsWarehouse) /*default WH for Project */
				ldsPOheader.SetITem(llNewRowPM,'project_id',asProject)
				ldsPOheader.SetITem(llNewRowPM,'action_cd','X') /*Default - will add/update an Order*/
				ldsPOheader.SetITem(llNewRowPM,'Request_date',String(Today(),'MMDDYYYY'))
				ldsPOheader.SetItem(llNewRowPM,'Order_type','S') /*Supplier Order*/
				ldsPOheader.SetItem(llNewRowPM,'Inventory_Type','N') /*default to Normal*/
				ldsPOheader.SetItem(llNewRowPM,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
				llOrderSeq = llNewRowPM /*header seq */
				ldsPOheader.SetItem(llNewRowPM,'order_seq_no',llOrderSeq) 
				ldsPOheader.SetItem(llNewRowPM,'ftp_file_name','OR') /*FTP File Name*/
				ldsPOheader.SetItem(llNewRowPM,'Status_cd','N')
				ldsPOheader.SetItem(llNewRowPM,'Last_user','SIMSEDI')
		
				llDetailSeq = 0 /*detail seq within order for detail recs */	

				/*Add header items to PM *********************/
				
				//Supplier Invoice no - Using Stored procedure to get next available RO_NO
				lsSuppInvNo = string(g.of_next_db_seq(gs_project,'Receive_Master','RO_No'),'000000')
				ldsPOheader.SetITem(llNewRowPM,'order_no',lsSuppInvNo)
				
				//Supplier
				ldsPOheader.SetITem(llNewRowPM,'supp_code','HILLMAN')
				
				//Delivery/Arrival Date - convert to format to mm/dd/yyyy
				liYear = Year(Today())
				liDay = Day(Today()) + 7
				liMo = Month(Today())
				ldtToday = Date ( liYear, liMo, liDay ) 
				lsArrivalDate =  string(ldtToday,'mm/dd/yyyy') 
				ldsPOheader.SetITem(llNewRowPM,'arrival_date',lsArrivalDate)

			end if
	
	
	//Create PD detail record ************************/
			llNewRowPD = ldsPOdetail.InsertRow(0)
			
			//Defaults
			ldsPOdetail.SetItem(llNewRowPD,'project_id', asproject) /*project*/
			ldsPOdetail.SetItem(llNewRowPD,'status_cd', 'N') 
			ldsPOdetail.SetItem(llNewRowPD,'Inventory_Type', 'N') 
			ldsPOdetail.SetItem(llNewRowPD,'edi_batch_seq_no',ldEDIBAtchSeq) /*batch seq No*/
			ldsPOdetail.SetItem(llNewRowPD,'order_seq_no',llORderSeq) 
			lLDetailSeq ++
			ldsPOdetail.SetItem(llNewRowPD,"order_line_no",string(lLDetailSeq)) 
			ldsPOdetail.SetItem(llNewRowPD,'owner_id',string(llOwner)) //OwnerID if Present	
			
			/*Order Number */
			ldsPOdetail.SetItem(llNewRowPD,'order_no',lsSuppInvNo)
			
			/*Line Item Number */
			llLineItemNO ++
			ldsPOdetail.SetItem(llNewRowPD,'line_Item_No',llLineItemNO) 	
	
			/* SKU  */
			ldsPOdetail.SetITem(llNewRowPD,'sku', lsSKU) 
			
			// QTY 
			ldsPOdetail.SetITem(llNewRowPD,'quantity',string(llReOrderQTY))
		/* end of detail items to PD ********************/
			
		/* create OR record *******************************************/
			//rec type OR = Order Replenishment Confirmation
			lsPostString = 'OR' 
			
			//Supplier Invoice no     
			lsPostString += lsSuppInvNo + space(30 - len(lsSuppInvNo))
			
			//Line Item No
			lsPostString += string(llLineItemNO,'000000')

			//concatenate poststring with outstring 
			lsOutString = lsPostString + lsOutString		
			
			//ReOrder QTY
			llReOrderQTY = llReOrderQTY * 100000 // 5 implied decimals
			lsOutString += string(llReOrderQTY,'000000000000000')

			// create EDI OUT record
			ldsOut.SetItem(llNewRow,'Project_id', asProject)
			ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
			ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
			ldsOut.SetItem(llNewRow,'batch_data', lsOutString)			
		/* End of OR record ********************************************/			

		end if
		
	 end if 
	
next /*next output record */

//Save the changes to the generic output table - FP will write to flat file
If lbOnce = true Then
	liRC = ldsPOheader.Update()
	If liRC = 1 Then liRC = ldsPOdetail.Update()
	If liRC = 1 Then liRC = ldsOut.Update()
	If liRC = 1 Then
		Execute Immediate "COMMIT" using SQLCA;
		Return 0
	Else
		lsMessage= SQLCA.SQLErrText
		if lsMessage = "" then lsMessage = ' Unable to Save the changes to the generic output table.'
		MessageBox('OR', 'Unable to save/send OR file: ' + lsMessage)
		Execute Immediate "ROLLBACK" using SQLCA;
		Return -1
	End If
else
		lsMessage = 'No Order Repleneshments needed at this time.'
		MessageBox('OR', 'Unable to save/send OR file: ' + lsMessage)
		Return -1
End If

	
end function

public function integer uf_goods_issue (ref datawindow adw_main, ref datawindow adw_detail, ref datawindow adw_pick, ref datawindow adw_pack);
//Prepare a Goods Issue Transaction for HILLMAN for the order that was just confirmed - sent to EDI processor 

Datastore	ldsOut

Long			llRowPos, llRowCount, llDetailRow,	llNewRow, llLineItemNo,	llBatchSeq
				
String		lsFind,lsOutString,lsOutString2, lsMessage, lsSku, lsSupplier, lsInvoice,	lsTemp, lsCarrier, lsCurrencyCode, lsShipTo,	&
				lsShipFrom, lsCustCode, lsCustSKU, lsUCCSCode, lsFolder

DEcimal		ldBatchSeq, ldGrossWeight, ldnetWeight, ldTemp,ldFreight, ldTotalAmount, ldPrice, ldQTY, ldtax, ldOther
Integer		liRC

w_main.SetMicrohelp('Creating Goods Issue confirmation for HILLMAN...')

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = g.of_next_db_seq(gs_project,'EDI_Inbound_Header','EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	MessageBox('System Error','Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Hillman!')
	Return -1
End If

// ********************************* header record for the order -put this data in data_batch 

adw_main.AcceptText()

//Build and Write the Header
lsOutString = 'GI' 																					//record type

lsTemp = adw_main.GetITemString(1,'do_no')													//DO NO
lsOutString += lsTemp + space(16 - len(lsTemp))		

lsOutString += "HILLMAN   " 																		//Poject_ID

lsTemp = adw_main.GetITemString(1,'ord_type')
lsOutString += lsTemp + space(4 - len(lsTemp))	 											//order type 

lsOutString += String(adw_Main.GetITemDateTime(1,'ord_date'),'yyyymmdd')			//order date

lsOutString += String(adw_Main.GetITemDateTime(1,'complete_date')	,'yyyymmdd')	//complete date

lsTemp = adw_main.GetITemString(1,'wh_code')
lsOutString += lsTemp + space(10 - len(lsTemp))	 											//warehouse

lsTemp = adw_main.GetITemString(1,'invoice_no')
lsOutString += lsTemp + space(20 - len(lsTemp))	 											//Order Number (Invoice_No)

If not isnull(adw_main.GetITemString(1,'cust_code')) Then
	lsTemp = adw_main.GetITemString(1,'cust_code')
	lsOutString += lsTemp + space(20 - len(lsTemp))	 										//cust code
Else
	lsOutString += space(20)
end if

If not isnull(adw_main.GetITemString(1,'cust_name')) then 								//cust name
	lsTemp = adw_main.GetITemString(1,'cust_name')
	lsOutString +=  lsTemp + space(40 - len(lsTemp))	
else
	lsOutString += space(40)
end if
										
If not isnull(adw_main.GetITemString(1,'user_Field4')) Then								//HILLMAN INVOICE #
	lsTemp = adw_main.GetITemString(1,'user_field4')
	lsOutString +=  space(20 - len(lsTemp)) + lsTemp
else
	//lsOutString +=  space(20 - len(lsTemp)) + lsTemp 
	lsOutString += space(20)
End If

If not isnull(adw_main.GetITemString(1,'carrier')) Then									//carrier
	lsTemp = adw_main.GetITemString(1,'carrier')
	lsOutString +=  lsTemp + space(20 - len(lsTemp))	
else
	lsOutString += space(20) 
End If

If not isnull(adw_main.GetITemString(1,'freight_terms')) Then							//Freight Terms
	lsTemp = adw_main.GetITemString(1,'freight_terms')
	lsOutString += lsTemp + space(20 - len(lsTemp))	
else
	lsOutString += space(20) 
End If

If not isnull(adw_main.GetITemNumber(1,'freight_cost')) Then 							// Freight Costs
	ldFreight = adw_main.GetITemNumber(1,'freight_cost') 									// 3 implied decimals
else
	ldFreight = 0
End If
ldTemp = ldFreight * 1000	
lsOutString += string(ldTemp, "0000000000") 

If not isnull(adw_main.GetITemNumber(1,'ctn_cnt')) Then									// Carton Count
	ldTemp = adw_main.GetITemNumber(1,'ctn_cnt')
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'0000000')

//Total Shipment Weight - Sum gross weight and net weights from Packing 
ldGrossWeight = 0
ldNetWeight = 0
llRowCOunt = adw_Pack.RowCount()
For llRowPos = 1 to llRowCount
	ldGrossWEight += adw_pack.GetITemNumber(llRowPos,'weight_Gross')
	ldnetWEight += adw_pack.GetITemNumber(llRowPos,'weight_net')
Next
If not isnull(ldGrossWEight) Then																//Total Shipment Weight
	ldTemp = ldGrossWEight * 100000																// 5 implied decimals
Else
	ldTemp = 0
End If
lsOutString += String(ldTemp,'000000000000')

// ********************************************************** put this data in data_batch_2	

If not isnull(adw_main.GetITemString(1,'awb_bol_no')) Then								//AWB/BOL
	lsTemp = adw_main.GetITemString(1,'awb_bol_no') 
else
	lsTemp = "No AWB/BOL found"
end If
if lsTemp = "" then lsTemp = "No AWB/BOL found"
lsOutString2 = lsTemp + space(20 - len(lsTemp)) 

If not isnull(adw_main.GetITemString(1,'user_field2')) Then								//TAX (IVA)		
	ldTax = dec(adw_main.GetITemString(1,'user_field2')) 								//2 implied decimals
Else
	ldTax = 0
End If
ldTemp = ldTax * 100
lsOutString2 += string(ldTemp, "0000000000") 	


If not isnull(adw_main.GetITemString(1,'user_field3')) Then								//Other Charges						 
	ldOther = dec(adw_main.GetITemString(1,'user_field3')) 							//2 implied decimals
Else
	ldOther = 0
End If
ldTemp = ldOther * 100
lsOutString2 += string(ldTemp, "0000000000") 	

//Calculated totals using detail rows
llRowCOunt = adw_Detail.RowCount()
ldTemp = 0 
ldPrice = 0
ldQTY = 0
For llRowPos = 1 to llRowCount
	If not isnull(adw_Detail.GetITemNumber(llRowPos,'price')) then ldPrice = adw_Detail.GetITemNumber(llRowPos,'price')
	If not isnull(adw_Detail.GetITemNumber(llRowPos,'alloc_Qty')) then ldQTY = adw_Detail.GetITemNumber(llRowPos,'alloc_Qty')
	 ldTemp += round((ldPrice * ldQTY),2) // calculate price * qty round rounded to 2 decimals
next

//Calculate Total $ Amount
ldTemp += ldFreight + ldTax + ldOther
ldTemp = ldTemp * 100 
lsOutString2 += string(ldTemp, "000000000000000") 											//Total $ Amount with 2 implied decimals
lsOutString2 += string(llRowCOunt, "000000") 													//Total Lines with 0 decimals

//write to DB for sweeper to pick up
llNewRow = ldsOut.insertRow(0)
ldsOut.SetItem(llNewRow,'Project_id','HILLMAN') /* hardcoded to match entry in .ini file for file destination*/
ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
ldsOut.SetItem(llNewRow,'batch_data', lsOutString) 
ldsOut.SetItem(llNewRow,'batch_data_2', lsOutString2)


// *********************************    For each detail row, write a detail - 1 record per PACKING list row.
llRowCOunt = adw_Pack.RowCount()
For llRowPos = 1 to llRowCount
		
	//Some fields will need to come from Detail Record
	llLineItemNo = adw_Pack.GetITemNumber(llRowPos,'line_item_no')
	lsFind = "Line_Item_No = " + String(llLineItemNo)
	llDetailRow = adw_Detail.Find(lsFind,1,adw_detail.RowCount())
	
	//we should always have a detail row for this line item
	If llDetailRow <= 0 Then 
		lsMessage= "Unable to create a Goods Issue Confirmation for Line Item: " + string(llLineItemNo) + "does not have a matching Detail Line Item!"
	 	MessageBox('Goods Issue Confirmation', lsMessage )
		Return -1
	end if
	
	llNewRow = ldsOut.insertRow(0)
	lsOutString = 'GD' 																						//Detail ID
	
	lsTemp =  adw_main.GetITemString(1,'do_no')   													//DO NO
	lsOutString +=  lsTemp + space(16 - len(lsTemp))
	
	lsTemp = adw_Detail.GetITemString(llDetailRow,'SKU')											//SKU 
	lsOutString +=  lsTemp + space(50 - len(lsTemp))
	
	lsTemp = adw_Detail.GetITemString(llDetailRow,'Supp_Code')									//Supp_Code 
	lsOutString +=  lsTemp + space(20 - len(lsTemp))

	If not isnull(adw_Detail.GetITemNumber(llDetailRow,'Req_Qty')) Then						//Requested QTY 
		ldTemp =adw_Detail.GetITemNumber(llDetailRow,'Req_Qty') * 100000						// 5 implied decimals
	Else
		ldTemp = 0
	End If
	lsOutString += string(ldTemp,"000000000000000") 	
	
	If not isnull(adw_Detail.GetITemNumber(llDetailRow,'alloc_Qty')) Then					//alloc_Qty 
		ldTemp = adw_Detail.GetITemNumber(llDetailRow,'alloc_Qty') * 100000					// 5 implied decimals
	Else
		ldTemp = 0
	End If
	lsOutString += string(ldTemp,"000000000000000") 
	
	If not isnull(adw_detail.GetITemString(llDetailRow,'uom')) Then							//UOM 
		lsTemp = adw_detail.GetITemString(llDetailRow,'uom')
		lsOutString +=  lsTemp + space(4 - len(lsTemp))
	Else
		lsOutString += space(4)
	End If
	
	If not isnull(adw_detail.GetITemNumber(llDetailRow,'price')) Then							//Unit Price 
		ldTemp = adw_detail.GetITemNumber(llDetailRow,'price') * 10000							// 4 implied decimals
	Else
		ldTemp = 0
	End If
	lsOutString += string(ldTemp,"000000000000") 													
	
	If not isnull(adw_detail.GetITemNumber(llDetailRow,'Line_Item_NO')) Then				//Line_Item_NO
		ldTemp = adw_detail.GetITemNumber(llDetailRow,'Line_Item_NO')
	Else
		ldTemp = 0
	End If
	lsOutString += string(ldTemp,"000000") 	
	
	lsTemp = adw_main.GetITemString(1,'cust_code')													//cust code
	lsOutString +=  lsTemp + space(20 - len(lsTemp))
	
	lsTemp = adw_main.GetITemString(1,'invoice_no')													//Order Number (Invoice_No)
	lsOutString +=  lsTemp + space(20 - len(lsTemp))
	
	If not isnull(adw_main.GetITemString(1,'user_Field4')) Then									//HILLMAN INVOICE #
		lsTemp = adw_main.GetITemString(1,'user_field4')
		lsOutString +=  space(20 - len(lsTemp)) + lsTemp
	else
		lsOutString += space(20)  
	End If
	
	//write to DB for sweeper to pick up
	ldsOut.SetItem(llNewRow,'Project_id','HILLMAN') /* hardcoded to match entry in .ini file for file destination*/
	ldsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	ldsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	ldsOut.SetItem(llNewRow,'batch_data', lsOutString)
		
Next /* Next PACKING record */


//Save the changes to the generic output table - SP will write to flat file
liRC = ldsOut.Update()
If liRC = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	lsMessage= SQLCA.SQLErrText
	Execute Immediate "ROLLBACK" using SQLCA;
	MessageBox('Goods Issue', 'Unable to save Goods Issue Records: ' + lsMessage)
	Return -1
End If

w_main.SetMicrohelp('Goods Issue confirmation successfully created for HILLMAN.')

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

