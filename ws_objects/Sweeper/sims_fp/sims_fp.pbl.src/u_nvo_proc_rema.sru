$PBExportHeader$u_nvo_proc_rema.sru
$PBExportComments$+ Rema Foods
forward
global type u_nvo_proc_rema from nonvisualobject
end type
end forward

global type u_nvo_proc_rema from nonvisualobject
end type
global u_nvo_proc_rema u_nvo_proc_rema

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsASNHeader,	&
				idsASNPackage,	&
				idsASNItem, &
				idsDONotes, &
				idsRONotes, &
				idsROMain, &
				idsRODetail, &
				idsOrderDetail

//06-JUN-2017 :Madhu Added OM Respective Datastores for PINT
datastore idsOMPO, &
			idsOMPODetail, &
			idsOMCReceipt, &
			idsOMCReceiptDetail, &
			idsOMAReceiptQueue, &
			idsOMReceiptDetailSerial, &
			idsOMQROMain, &
			idsOMQRODetail
			
//2017-07 - TAM Added OM Respective Datastores for PINT
datastore idsOMCDelivery, &
			idsOMCDeliveryDetail, &
			idsOMADeliveryQueue, &
			idsOMASOCQueue, &
			idsOMQDelivery, &
			idsOMQDeliveryDetail, &
			idsOMQDeliveryAttr, &
			idsOMEXP, &
			idsOMCSOCDelivery, &
			idsOMCSOCDeliveryAttr, &
			idsOMCSOCDeliveryDetail, &
			idsOMCDeliveryAttr
			
//08-MAR-2018 :Madhu S16591 - Added OM Respective Datastore for PINT
datastore idsItem, &
			 idsOMCItem, &
			 idsOMCItemAttr, &
			 idsOMAItemQueue

//TAM 2018/11 S25784			
datastore idsOMQInvTran, idsOMAInvQtyOnHand
			
String is_om_client_id
end variables

forward prototypes
public function integer uf_process_om_inbound (string asproject)
public function integer uf_process_om_receipt (string asproject)
public function string nonull (string as_str)
public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction)
public function datetime getpacifictime (string aswh, datetime adtdatetime)
public function string uf_get_sequence_letter (long al_line_no)
public function integer uf_process_om_delivery (string asproject)
public function integer uf_process_om_warehouse_order (datastore adsorderlist)
public function integer uf_process_om_item (string asproject)
public function boolean uf_is_outbound_order_duplicated (string asproject, string asinvoice)
public function datastore uf_get_duplicated_order_detail_records (string asproject, string asinvoiceno)
public function long uf_find_duplicated_order_sku_record (string asinvoiceno, string assku)
public function string uf_get_alternate_sku (string as_project, string as_sku, string as_supp_code)
public function integer uf_sync_om_inventory (string asproject)
end prototypes

public function integer uf_process_om_inbound (string asproject);//03-Jan-2018 :Madhu - Pull/Process Orders from OM
long llRC

//connect to OM Database
gu_nvo_process_files.uf_connect_to_om(asproject)

//Get OM_Client_Id value
SELECT OM_Client_Id into :is_om_client_id 
FROM Project with(nolock) 
WHERE Project_Id =:asproject 
USING SQLCA;

//Pull Item Master Records from OM to load into SIMS
llRC = this.uf_process_om_item( asproject)

//Pull Orders from OM to load into SIMS
llRC = this.uf_process_om_receipt(upper(asProject)) //Inbound Orders (EDI 943)

If llRC = 0 Then llRC = gu_nvo_process_files.uf_process_purchase_order(upper(asProject))  //Write into SIMS

//Pull Delivery Orders from OM to load into SIMS
llRC = this.uf_process_om_delivery(upper(asProject)) //Outbound Orders (940)

If llRC = 0 Then llRC = gu_nvo_process_files.uf_process_delivery_order(upper(asProject))  //Write into SIMS

//disconnect from OM Database
gu_nvo_process_files.uf_disconnect_from_om( )

return llRC

end function

public function integer uf_process_om_receipt (string asproject);//03-Jan-2018 :Madhu - REMA - EDI -943 Pull Inbound Orders from OM.
Datastore  ldsRoNo
string		ls_om_threshold, lslogout, ls_org_sql, ls_change_request_nbrs, ls_omc_sql, lsFind, ls_errors
string		lsAction, ls_OrderNo, ls_error_msg, sql_syntax, lsSKU, lsSKU2, ls_user_Line_Item_No
long		ll_receipt_queue_count, ll_Row_Pos, ll_change_request_nbr, ll_receipt_count, llFindRow
long		ll_New_Row, llOrderSeq, llLineSeq, ll_Batch_Seq, ll_rm_count, llNewRoNoCount
long		ll_detail_error_count, ll_receipt_detail_count, ll_Row_Pos_RD, llNewDetailRow, llLineNum
long		llDeleteRowCount, llDeleteRowPos, lirc
boolean	lbError, lb_treat_adds_as_updates, lbDetailError
string		lsAltSku		//GailM 04/18

ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")

IF NOT isvalid(idsPOHeader) THEN						//EDI_Inbound_Header
	idsPOheader = Create u_ds_datastore
	idsPOheader.dataobject= 'd_po_header'
	idsPOheader.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsPOdetail) THEN							//EDI_Inbound_Detail
	idsPOdetail = Create u_ds_datastore
	idsPOdetail.dataobject= 'd_po_detail'
	idsPOdetail.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsOMCReceipt) THEN					//OMC_Receipt
	idsOMCReceipt = Create u_ds_datastore
	idsOMCReceipt.dataobject ='d_omc_receipt'
	idsOMCReceipt.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCReceiptDetail) THEN		 		//OMC_ReceiptDetail
	idsOMCReceiptDetail = Create u_ds_datastore
	idsOMCReceiptDetail.dataobject ='d_omc_receipt_detail'
	idsOMCReceiptDetail.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMAReceiptQueue) THEN		 		//OMA_Receipt_Queue
	idsOMAReceiptQueue = Create u_ds_datastore
	idsOMAReceiptQueue.dataobject ='d_oma_receipt_queue'
	idsOMAReceiptQueue.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(ldsRoNo) THEN
	ldsRoNo = Create Datastore
End If
			
//reset all datastores
idsPoheader.Reset()
idsPODetail.Reset()
idsOMCReceipt.reset()
idsOMCReceiptDetail.reset()
idsOMAReceiptQueue.reset()

lsLogOut ="   OM Inbound Start Processing of uf_process_om_receipt() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue
ls_org_sql =idsOMAReceiptQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMAReceiptQueue.setsqlselect( ls_org_sql)
ll_receipt_queue_count = idsOMAReceiptQueue.retrieve( )


lsLogOut =" RQ SQL query is -> "+ls_org_sql
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = " RQ count from OM -> "+string(ll_receipt_queue_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

FOR ll_Row_Pos =1 to ll_receipt_queue_count
	
	ll_change_request_nbr = idsOMAReceiptQueue.getitemnumber(ll_Row_Pos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
	
NEXT

IF ll_receipt_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	//Retrieving Orders from OM database	
	ls_omc_sql =idsOMCReceipt.getsqlselect( )
	ls_omc_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )" //Threshold
	idsOMCReceipt.setsqlselect( ls_omc_sql)
	ll_receipt_count = idsOMCReceipt.retrieve( )
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Query for OMC_Receipt : ' +ls_omc_sql
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	//Write to File and Screen
	lsLogOut = '      - OM Inbound - Getting count(Records) from OM Receipt Table for Processing: ' + string(ll_receipt_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	// Reset main window microhelp message
	w_main.SetMicroHelp("Processing Receipt Order (ROSE) from OM")
	
	//1.Receipt Header
	For ll_Row_Pos = 1 to ll_receipt_count
		
		ll_New_Row = idsPOheader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		
		CHOOSE CASE upper(idsOMCReceipt.getitemstring(ll_Row_Pos, 'CHANGE_REQUEST_INDICATOR'))
			CASE 'INSERT'
				lsAction ='A'
			CASE 'CANCEL'
				lsAction ='D'
			CASE 'UPDATE'
				lsAction ='U'
			CASE 'DELINS'
				lsAction ='U'
		END CHOOSE

		//Get the next available file sequence number
		ll_Batch_Seq = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'EDI_Inbound_Header', 'EDI_Batch_Seq_No')
		IF ll_Batch_Seq <= 0 THEN RETURN -1
	
		//New Record Defaults
		idsPOheader.SetItem(ll_New_Row, 'project_id', upper(asProject))
		idsPOheader.SetItem(ll_New_Row, 'Request_date',String(Today(), 'YYMMDD'))
		idsPOheader.SetItem(ll_New_Row, 'edi_batch_seq_no', ll_Batch_Seq)
		idsPOheader.SetItem(ll_New_Row, 'order_seq_no', llOrderSeq) 
		idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'N')
		idsPOheader.SetItem(ll_New_Row, 'Last_user', 'SIMSEDI')
		idsPOheader.SetItem(ll_New_Row, 'Order_type', 'S')
		idsPOheader.SetItem(ll_New_Row, 'Inventory_Type', 'N')
		idsPOheader.SetItem(ll_New_Row, 'OM_Order_Type', 'A') //A -> ASN
		idsPOheader.SetItem(ll_New_Row, 'OM_Confirmation_type', 'E') //E -> EDI
	
		//Action Code  /Change ID   
		idsPOheader.setitem( ll_New_Row, 'action_cd', lsAction) //Always A for ASN
		
		ll_change_request_nbr = idsOMCReceipt.getitemnumber(ll_Row_Pos, 'CHANGE_REQUEST_NBR')
		idsPOheader.SetItem(ll_New_Row, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR
		
		//Write to Log File and Screen
		lsLogOut = '      - OM Inbound - Processing Header Record for Change Request Nbr: ' + string(ll_change_request_nbr)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		//Inbound Order Number
		ls_OrderNo = Left(idsOMCReceipt.getitemstring( ll_Row_Pos,'EXTERNRECEIPTKEY'),30)
	
		IF len(ls_OrderNo) > 0 Then
			idsPOheader.setitem( ll_New_Row, 'order_no', ls_OrderNo)
		ELSE
			ls_error_msg = "Change_Request_Nbr ="+string(ll_change_request_nbr)+" -EXTERNRECEIPTKEY shouldn't be NULL. Record will not be processed."
			idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
			idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'EXTERNRECEIPTKEY should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( upper(asProject), 'E', ll_change_request_nbr,'IB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF
		
		SELECT COUNT(*)
			INTO :ll_rm_count
		FROM receive_master with(nolock)
		WHERE Project_ID = :asproject
		AND (Supp_Invoice_No = :ls_OrderNo)
		AND Ord_Status = 'N' 
		USING SQLCA;
		
		idsPOheader.SetItem(ll_New_Row, 'Order_No', ls_OrderNo)  /* Order No  */
		
		IF ll_rm_count = 1 and lsAction = 'A'  THEN	lb_treat_adds_as_updates = TRUE
		If lsAction = 'U' or lb_treat_adds_as_updates Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
		
			sql_syntax = "SELECT RO_No, SKU, line_item_no, user_line_Item_No FROM Receive_Detail"    
			sql_syntax += " Where RO_no in (select ro_no from receive_master with(nolock) where project_id ='"+asproject+"' and supp_invoice_no = '" + ls_OrderNo + "'  and (Ord_Status = 'N' or Ord_Status = 'P'  ));"  
									
			ldsRoNo.Create(SQLCA.SyntaxFromSQL(sql_syntax,"", ls_errors))
			IF Len(ls_errors) > 0 THEN
				lsLogOut = "        *** Unable to create datastore for Pandora Sales Order Process.~r~r" + ls_errors
				FileWrite(gilogFileNo,lsLogOut)
				RETURN - 1
			END IF
			ldsRoNO.SetTransObject(SQLCA)
			llNewRoNoCount =ldsRoNo.Retrieve()
		End If
		
		idsPOheader.SetItem(ll_New_Row, 'supp_code', 'REMA')   	// Supplier ID -default to REMA
		idsPOheader.SetItem(ll_New_Row, 'Ord_Date', string(idsOMCReceipt.getitemdatetime( ll_Row_Pos, 'EFFECTIVE_DATE'), 'mm/dd/yyyy hh:mm')) //Effective Date
		idsPOheader.SetItem(ll_New_Row, 'Arrival_Date', string(idsOMCReceipt.getitemdatetime( ll_Row_Pos, 'EXPECTED_RECEIPT_DATE'), 'mm/dd/yyyy hh:mm')) //Expected Arrival Date
		idsPOheader.SetItem(ll_New_Row,'from_wh_loc', idsOMCReceipt.getitemstring(ll_Row_Pos, 'DEST_WHS_ID'))  	//From wh loc
		idsPOheader.SetItem(ll_New_Row,'wh_code', 'REMA-NJ')  	//WH Code - Harcode for time being. It should pull from SITE_ID
		
		idsPOheader.SetItem(ll_New_Row, 'Carrier', idsOMCReceipt.getitemstring(ll_Row_Pos, 'CARRIERKEY'))  //Carrier Key
		idsPOheader.SetItem(ll_New_Row, 'User_Field6', idsOMCReceipt.getitemstring(ll_Row_Pos, 'CARRIERNAME'))  //Carrier Name

		idsPOheader.SetItem(ll_New_Row,'Awb_Bol_No', idsOMCReceipt.getitemstring( ll_Row_Pos, 'CARRIER_REFERENCE'))  	//Awb Bol No
		idsPOheader.SetItem(ll_New_Row, 'Transport_Mode', idsOMCReceipt.getitemstring(ll_Row_Pos, 'TRANSPORTATION_MODE'))  //Transport Mode
		idsPOheader.SetItem(ll_New_Row, 'Container_Nbr', idsOMCReceipt.getitemstring(ll_Row_Pos, 'Container_Key'))  //Container Key
		//GailM 4/25/2018 S18651 F7679 I845 Rema: Receiving order mapping changes - FS add container key to ship ref 
		idsPOheader.SetItem(ll_New_Row, 'Ship_Ref', idsOMCReceipt.getitemstring(ll_Row_Pos, 'Container_Key'))  //Container Key
		
		idsPOheader.SetItem(ll_New_Row, 'Seal_Nbr', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR1'))  //Seal Nbr
		idsPOheader.SetItem(ll_New_Row, 'User_field2', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR2'))  //UF2
		idsPOheader.SetItem(ll_New_Row, 'User_field3', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR3'))  //UF3
		idsPOheader.SetItem(ll_New_Row, 'User_field4', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR4'))  //UF4
		idsPOheader.SetItem(ll_New_Row, 'User_field5', idsOMCReceipt.getitemstring(ll_Row_Pos, 'SUSR5'))  //UF5
			
		ll_detail_error_count =0 //re-set detail error count value
		ls_error_msg ='' //re-set error msg value
		
		//2.RECEIPT_DETAIL STARTS
		ll_receipt_detail_count = idsOMCReceiptDetail.retrieve(ll_change_request_nbr )

		//Write to Log File and Screen
		lsLogOut = '      - OM Inbound - Processing Detail Record for Change Request Nbr: ' + string(ll_change_request_nbr) + " and count is: "+ string(ll_receipt_detail_count)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		llLineNum =0
		For ll_Row_Pos_RD =1 to ll_receipt_detail_count
			
			lbDetailError = False
			llNewDetailRow =  idsPODetail.InsertRow(0)
			
			llLineSeq ++
			llLineNum ++
			
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', upper(asProject)) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,'line_item_no', llLineNum)
			idsPODetail.SetItem(llNewDetailRow,'supp_code', 'REMA')
			
			IF lb_treat_adds_as_updates Then
				idsPODetail.SetItem(llNewDetailRow,'action_cd','U') 
			else
				idsPODetail.SetItem(llNewDetailRow,'action_cd',lsAction) //set Header Action Cd
			END IF

			idsPODetail.SetItem(llNewDetailRow, 'Order_No',ls_OrderNo) //Order No -Map with Header Order No
			
			IF not isnull(idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')) Then //User Line Item Number
				idsPODetail.SetItem(llNewDetailRow,'user_line_item_no',idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO'))
			else
				ls_error_msg +="Row: " + string(llNewDetailRow) + " - Line Item Number should not be NULL. Record will not be processed. ~n~r"
				idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
				idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'Errors exist on Header/Detail')
				idsPODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsPODetail.SetItem(llNewDetailRow, 'Status_Message', 'Line Item Number should not be NULL. Record will not be processed.')
				lbDetailError = True
			End If
			
			IF not isnull(idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ITEM')) Then //SKU
				lsSKU = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ITEM') //SKU
			else
				ls_error_msg +="Row: " + string(llNewDetailRow) + " -SKU should not be NULL. Record will not be processed. ~n~r"
				idsPOheader.SetItem(ll_New_Row, 'Status_cd', 'E')
				idsPOheader.SetItem(ll_New_Row, 'Status_Message', 'Errors exist on Header/Detail')
				idsPODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				idsPODetail.SetItem(llNewDetailRow, 'Status_Message', 'SKU should not be NULL. Record will not be processed.')
				lbDetailError = True
			End If
			
			//Write to Log File and Screen
			lsLogOut = '      - OM Inbound - Processing Detail Record for Change Request Nbr: ' + string(ll_change_request_nbr) +"  and Order No: "+ ls_OrderNo +"  and Line Item No: " + idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			
			/* may use to build itemmaster record 
			Need to check SKU in Item_Master and, if it's not there, check MFG SKU Look-up */
			Select distinct(SKU), alternate_sku into :lsSKU2,  :lsAltSku
			From Item_Master with(nolock)
			Where Project_id = :asProject
			and SKU = :lsSKU
			USING SQLCA;
			
			IF lsSKU2 = '' THEN
				gu_nvo_process_files.uf_writeError("Change_Request_Nbr ="+string(ll_change_request_nbr)+" - Missing REMA SKU....")
			END IF
			
			idsPODetail.SetItem(llNewDetailRow, 'SKU', lsSKU) //SKU
			idsPODetail.setitem(llNewDetailRow,'Quantity', string(idsOMCReceiptDetail.getitemnumber(ll_Row_Pos_RD, 'QTYEXPECTED'))) //Qty
			idsPODetail.SetItem(llNewDetailRow, 'Inventory_Type', 'N') //Inventory Type
			//GailM 4/25/2018 S18651 F7679 I845 Rema: Receiving order mapping changes - Pull alternate SKU from Item Master
			//idsPODetail.setitem(llNewDetailRow,'alternate_sku', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'ALTSKU')) //Alternate SKU
			idsPODetail.setitem(llNewDetailRow,'alternate_sku', lsAltSku ) //Alternate SKU
			If ll_receipt_detail_count > 1 Then	// sequencial letter only if there are more than one detail rows
				idsPODetail.SetItem(llNewDetailRow, 'Lot_no', ls_OrderNo+this.uf_get_sequence_letter( llLineNum)) //lot No
			Else
				idsPODetail.SetItem(llNewDetailRow, 'Lot_no', ls_OrderNo ) //lot No
			End If
			idsPODetail.setitem(llNewDetailRow,'UOM', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'UOM')) //UOM
			idsPODetail.setitem(llNewDetailRow,'User_Field1', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'SUSR1')) //SUSR1
			idsPODetail.setitem(llNewDetailRow,'User_Field2', idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'Notes')) //Notes
			idsPODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', idsOMCReceiptDetail.getitemnumber(ll_Row_Pos_RD, 'CHANGE_REQUEST_NBR'))  //CHANGE_REQUEST_NBR	
		
			// Find the Row in the Receive Detail Datastore and if Found Then Delete It from the DataStore.
			//  This will leave those records that need to be deleted from Receive Detail
			ls_user_Line_Item_No = idsOMCReceiptDetail.getitemstring(ll_Row_Pos_RD, 'EXTERNLINENO')
			
			If  idsPODetail.GetItemString(llNewDetailRow,'action_cd') = 'U' Then
				 lsFind = "upper(sku) = '" + upper(lsSKU) +"'"
				 lsFind += " and user_line_item_no = '" + ls_user_Line_Item_No + "'"
				 llFindRow = ldsRoNo.Find(lsFind, 1, ldsRoNo.RowCount())
			
				If llFindRow > 0 Then 
					  // TAM 2009/10/29 change line item number for updated row to original line number found. 
					  idsPODetail.SetItem(llNewDetailRow, 'line_item_no', ldsRoNo.GetItemNumber(llFindRow,'Line_Item_No'))
					  ldsRoNo.DeleteRow(llFindRow)
				 End If
			End If
			
			IF lbDetailError Then ll_detail_error_count++
		Next //Receipt Detail
		
		IF ll_detail_error_count > 0 Then 	gu_nvo_process_files.uf_process_om_writeerror( upper(asProject), 'E', ll_change_request_nbr,'IB', ls_error_msg)
		
	Next //Receipt Master
ELSE
	Return 0
END IF

// LTK 20120608  Pandora #353 Don't delete RD records when treating Adds as Updates
IF NOT lb_treat_adds_as_updates then
	// TAM 2009/10/29 Any Rows left in the Detail Datastore need to be deleted so create a delete detail Row for each on.
	llDeleteRowCount = ldsRoNo.RowCount()
	If  llDeleteRowCount > 0 Then
		For llDeleteRowPos = 1  to llDeleteRowCount 
			llNewDetailRow =  idsPODetail.InsertRow(0)
			llLineSeq ++
			//Add detail level defaults
			idsPODetail.SetItem(llNewDetailRow,'order_seq_no', llOrderSeq) 
			idsPODetail.SetItem(llNewDetailRow,'project_id', upper(asProject)) /*project*/
			idsPODetail.SetItem(llNewDetailRow,'status_cd', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'Inventory_Type', 'N') 
			idsPODetail.SetItem(llNewDetailRow,'edi_batch_seq_no', ll_Batch_Seq) /*batch seq No*/
			idsPODetail.SetItem(llNewDetailRow,"order_line_no", string(llLineSeq))
			idsPODetail.SetItem(llNewDetailRow,'action_cd','D') 
			idsPODetail.SetItem(llNewDetailRow,'line_item_no', ldsRoNo.GetItemNumber(llDeleteRowPos,'line_item_no'))
			idsPODetail.SetItem(llNewDetailRow,'SKU', ldsRoNo.GetItemString(llDeleteRowPos,'SKU'))
			idsPODetail.SetItem(llNewDetailRow,'Order_No', ls_OrderNo)
		Next
	End If
End IF

// Reset main window microhelp message
w_main.SetMicroHelp("Processing Purchase Order (ROSE) - Completed File Rows")

//Save the Changes 
lirc = idsPOHeader.Update()
 
If liRC = 1 Then
	liRC = idsPODetail.Update()
End If

If liRC = 1 then
 	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new PO Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new PO Records to database!")
	Return -1
End If

//Write to Log File and Screen
lsLogOut ="*** OM Inbound - End - Processing of uf_process_om_receipt() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//destroy all instances
destroy idsPoheader
destroy idsPODetail
destroy idsOMCReceipt
destroy idsOMCReceiptDetail
destroy idsOMAReceiptQueue
destroy ldsRoNo

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")

Return 0 //21-MAR-2018 :Madhu DE3461 - Removed "Return -1"
end function

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

public function integer uf_process_om_inbound_acknowledge (string asproject, string asrono, string asaction);//03-Jan-2018 :Madhu - REMA -943 - Goods Receipt Acknowledgement.
//Write records back into OMQ Tables.

String		lsFind,  lsLogOut, lsOwnerCD, lsGroup, lsWH
string		ls_client_id, lsSkipProcess
String 	lsToLoc, lsSkipProcess2
String		ls_OM_Type, lsOrderNo

Decimal	 ldOwnerID, ldOwnerID_Prev, ldTransID
DateTime ldtTemp, ldtToday
Long		llRowPos, llRowCount, llFindRow,	ll_detail_row
Long 		ll_change_req_no, ll_rc, ll_batch_seq_no, ll_orig_batch_seq_no

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- Start Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;


If Not isvalid(idsROMain) Then
	idsROMain = Create Datastore
	idsROMain.Dataobject = 'd_ro_master'
	idsROMain.SetTransObject(SQLCA)
End If

If Not isvalid(idsRODetail) Then
	idsRODetail = Create Datastore
	idsRODetail.Dataobject = 'd_ro_Detail'
	idsRODetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQROMain) Then
	idsOMQROMain =Create u_ds_datastore
	idsOMQROMain.Dataobject ='d_omq_receipt'
	idsOMQROMain.settransobject(om_sqlca)
End If

If Not isvalid(idsOMQRODetail) Then
	idsOMQRODetail =Create u_ds_datastore
	idsOMQRODetail.Dataobject ='d_omq_receipt_detail'
	idsOMQRODetail.settransobject(om_sqlca)
End If

idsOMQROMain.reset()
idsOMQRODetail.reset()

//Write to File and Screen
lsLogOut = "    OM Inbound Acknowledge - Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//Retrieve the Receive Header, Detail and Putaway records for this order
If idsROMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsWH = idsROMain.GetItemString(1, 'wh_code')
ll_change_req_no = idsROMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsROMain.getitemnumber(1,'EDI_Batch_Seq_No')

llRowCount = idsRODetail.Retrieve(asRONO) //Get Detail count

// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

//Write the rows to respective OMQ Tables
//1. ADD OMQ_RECEIPT Tables
idsOMQROMain.insertrow( 0)
ldtTemp = idsROMain.GetItemDateTime(1, 'complete_date')
ldtTemp = GetPacificTime(lsWH, ldtToday)

idsOMQROMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQROMain.setitem(1,'CLIENT_ID',ls_client_id)
idsOMQROMain.setitem(1, 'QACTION', asaction) //Action
idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
idsOMQROMain.setitem(1, 'QWMQID', ldTransID) //Next Transaction Id
idsOMQROMain.setitem(1, 'RECEIPTKEY', 'XXX' +Right(asrono,7)) //Receipt Key
idsOMQROMain.setitem(1, 'SITE_ID', lsWH) //site id
idsOMQROMain.setitem(1, 'STATUS', 'NOTRECVD') //Status

idsOMQROMain.setitem( 1, 'EXTERNALRECEIPTKEY', idsROMain.GetItemString(1, 'supp_invoice_no')) //supp_invoice_no
idsOMQROMain.setitem( 1, 'RECEIPTDATE', ldtTemp) //trans_date

idsOMQROMain.setitem( 1, 'EFFECTIVE_DATE', string(idsROMain.GetItemDateTime(1, 'Ord_Date'))) //Ord Date
idsOMQROMain.setitem( 1, 'EXPECTED_RECEIPT_DATE', Left(idsROMain.GetItemString(1, 'Arrival_Date'),10)) //Arrival Date
idsOMQROMain.setitem( 1, 'CARRIER_REFERENCE', Left(idsROMain.GetItemString(1, 'Awb_Bol_No'),10)) //Awb Bol No
idsOMQROMain.setitem( 1, 'TRANSPORTATION_MODE', Left(idsROMain.GetItemString(1, 'Transport_Mode'),10)) //Transport Mode
idsOMQROMain.setitem( 1, 'Container_Key', Left(idsROMain.GetItemString(1, 'Container_Nbr'),10)) //Container Nbr

idsOMQROMain.setitem( 1, 'SUSR1',  idsROMain.GetItemString(1, 'Seal_Nbr')) 	//Seal Nbr
idsOMQROMain.setitem( 1, 'SUSR2', idsROMain.GetItemString(1, 'User_Field2' )) //UF2
idsOMQROMain.setitem( 1, 'SUSR3',  idsROMain.GetItemString(1, 'User_Field3')) 	//UF3
idsOMQROMain.setitem( 1, 'SUSR4',  idsROMain.GetItemString(1, 'User_Field4')) 	//UF4
idsOMQROMain.setitem( 1, 'SUSR5',  idsROMain.GetItemString(1, 'User_Field5')) 	//UF5

idsOMQROMain.setitem( 1, 'ADDDATE', today()) //add_date
idsOMQROMain.setitem( 1, 'ADDWHO', 'SIMSUSER') //add_who
idsOMQROMain.setitem( 1, 'EDITDATE',today())
idsOMQROMain.setitem( 1, 'EDITWHO', 'SIMSUSER')


//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- Processing Header Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. ADD OMQ_RECEIPTDETAIL Tables
//Roll Up Detail records for same attribute values.
For llRowPos = 1 to llRowCount

	ll_detail_row = idsOMQRODetail.insertrow( 0)
	idsOMQRODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
	idsOMQRODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id) //client_Id
	idsOMQRODetail.setitem( ll_detail_row, 'QACTION', asaction) //Action
	idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
	idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', ldTransID) //Set with Batch_Transaction.Trans_Id
	idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTKEY', 'XXX'+Right(asrono,7)) //Receipt Key
	idsOMQRODetail.setitem( ll_detail_row, 'SITE_ID', lsWH) //site id
	idsOMQRODetail.setitem( ll_detail_row, 'STATUS', 'NOTRECVD') //Status
	
	idsOMQRODetail.setitem( ll_detail_row, 'EXTERNRECEIPTKEY', idsROMain.GetItemString(1, 'supp_invoice_no' )) //supp_Invoice_No
	idsOMQRODetail.setitem( ll_detail_row, 'EXTERNLINENO', string(idsRODetail.GetItemNumber(llRowPos, 'user_line_item_no'))) //user_line_item_no
	idsOMQRODetail.setitem( ll_detail_row, 'ITEM', upper(idsRODetail.GetItemString(llRowPos, 'sku'))) //sku
	idsOMQRODetail.setitem( ll_detail_row, 'ALTSKU', upper(idsRODetail.GetItemString(llRowPos, 'Alternate_SKU'))) //Altsku

	idsOMQRODetail.setitem( ll_detail_row, 'QTYEXPECTED', idsRODetail.GetItemNumber(llRowPos,'req_qty')) //QTY
	idsOMQRODetail.setitem( ll_detail_row, 'UOM', trim(idsRODetail.GetItemString(llRowPos, 'uom'))) //UOM
	idsOMQRODetail.setitem( ll_detail_row, 'ADDDATE', Date(today())) //add_date
	idsOMQRODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER') //add_who
	idsOMQRODetail.setitem( ll_detail_row, 'EDITDATE',today())
	idsOMQRODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound Acknowledge- Processing Detail Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+string(idsRODetail.GetItemNumber(llRowPos, 'line_item_no'))
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

next /*next output record */

idsOMQROMain.setitem( 1, 'LINECOUNT',   idsOMQRODetail.rowcount()) 	//Line Count - Set Detail Record count

//storing into DB
//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
If idsOMQROMain.rowcount( ) > 0 Then	ll_rc =idsOMQROMain.update( false, false);
If idsOMQRODetail.rowcount( ) > 0 and ll_rc =1 Then 	ll_rc =idsOMQRODetail.update( false, false);

If ll_rc =1 Then
	//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
	commit using om_sqlca;
	
	if om_sqlca.sqlcode = 0 then
		idsOMQROMain.resetupdate( )
		idsOMQRODetail.resetupdate( )
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
		rollback using om_sqlca;
		
		idsOMQROMain.reset( )
		idsOMQRODetail.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Acknowledge- Error Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono+" Error: "+om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if

else
	//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
	rollback using om_sqlca;
	
	//Write to File and Screen
	lsLogOut = '      - OM Inbound Acknowledge- Error Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono+" Error: "+om_sqlca.SQLErrText +" Record sav failed"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy idsOMQROMain
destroy idsOMQRODetail

//Write to File and Screen
lsLogOut = '      - OM Inbound Acknowledge- End Processing of uf_process_om_inbound_acknowledge() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function datetime getpacifictime (string aswh, datetime adtdatetime);string lsOffset, lsOffsetFremont
long   llNetOffset, llTimeSecs
date ldDate
time ltTime, ltTimeNew

select gmt_offset into :lsOffsetFremont
from warehouse
where wh_code = 'PND_FREMNT';

if asWH = 'GMT' then
	lsOffset = '0'
else
	select gmt_offset into :lsOffset
	from warehouse
	where wh_code = :asWH;
end if

// see if subtracting the offset would make it the previous day. If so, subtract a day and the remainder of the Offset.
// - if the offset is negative (West of Fremont), see if adding the offset would make it the next day. If so, add a day and the remainder of Offset
llNetOffset = long(lsOffset) - long(lsOffsetFremont)
llNetOffset = llNetOffset * 60 * 60  //convert the offset to seconds
ldDate = date(adtDateTime)
ltTime = time(adtDateTime)
ltTimeNew = ltTime
if llNetOffset > 0 then
	llTimeSecs = SecondsAfter(time('00:00'), ltTime)
	if llTimeSecs < llNetOffset then
		ldDate = RelativeDate(ldDate, -1)
		ltTimeNew = RelativeTime(time('23:59:59'), - (llNetOffset - llTimeSecs))
	else
		ltTimeNew = RelativeTime(ltTime, - llNetOffset)
	end if
elseif llNetOffset < 0 then  //Net Offset is negative - selected WH is West of Fremont. Going to add time to convert to Pacific
	llTimeSecs = SecondsAfter(ltTime, time('23:59:59')) //seconds remaining in the day
	if llTimeSecs < llNetOffset then // time remaining in the day is less than the net offset....
		//so add a day and add the remaing time
		ldDate = RelativeDate(ldDate, +1)
		ltTimeNew = RelativeTime(time('00:00'),  (llNetOffset - llTimeSecs))
	else
		// adding the net offset won't require adding another day
		ltTimeNew = RelativeTime(ltTime, llNetOffset)
	end if
end if

//ltTimeNew = RelativeTime(ltTime, - llNetOffset*60*60)
//if ltTimeNew > ltTime then  // are there any locations West of Pacific (Hawaii or other?)
//	ldDate = RelativeDate(ldDate, -1)
//end if
adtDateTime = DateTime(ldDate, ltTimeNew)
//adtDate = RelativeDate(adtDate, llNetOffset)
return adtDateTime
end function

public function string uf_get_sequence_letter (long al_line_no);//11-Jan-2018 :Madhu REMA Foods - Return Sequence Letter (A,B,C...)

CHOOSE CASE al_line_no
	CASE 1
		Return 'A'
	CASE 2
		Return 'B'
	CASE 3
		Return 'C'
	CASE 4
		Return 'D'
	CASE 5
		Return 'E'
	CASE 6
		Return 'F'
	CASE 7
		Return 'G'
	CASE 8
		Return 'H'
	CASE 9
		Return 'I'
	CASE 10
		Return 'J'
	CASE 11
		Return 'K'
	CASE 12
		Return 'L'
	CASE 13
		Return 'M'
	CASE 14
		Return 'N'
	CASE 15
		Return 'O'
	CASE 16
		Return 'P'
	CASE 17
		Return 'Q'
	CASE 18
		Return 'R'
	CASE 19
		Return 'S'
	CASE 20
		Return 'T'
	CASE 21
		Return 'U'
	CASE 22
		Return 'V'
	CASE 23
		Return 'W'
	CASE 24
		Return 'X'
	CASE 25
		Return 'Y'
	CASE 26
		Return 'Z'
END CHOOSE
end function

public function integer uf_process_om_delivery (string asproject);//30-Jan-2018 :Madhu  S15410 -EDI -940 - Pull Outbound Orders from OM

Datastore	ldsDOHeader, ldsDODetail, ldsDOAddress, ldsDONotes
				
String			lsLogout, ls_warehouse, ls_org_sql, ls_change_request_nbrs, lsAction, ls_error_msg
String			ls_om_threshold, lsInvoice, lsTemp, lsFind, ls_consolidation_no, ls_Orig_Invoice, ls_alt_sku
Integer		liRC
Long			llRowPos,llNewRow, llNewDetailRow ,llOrderSeq,	llBatchSeq,	llLineSeq, &
				llLineItemNo, ll_delivery_queue_count, ll_delivery_count, ll_delivery_detail_count, ll_change_request_nbr, ll_Row_Pos_Detail, &
				ll_detail_error_count, llNewNotesRow , llNewAddressRow, llCountInv, llDupRow, ll_return
Boolean		lbError, lbDetailError, lbSoldToAddress, lbDuplicate

datetime		ldtToday, ldtWHTime


ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")
ldtToday = DateTime(today(),Now())
				
ldsDOHeader = Create u_ds_datastore
ldsDOHeader.dataobject = 'd_shp_header'
ldsDOHeader.SetTransObject(SQLCA)

ldsDODetail = Create u_ds_datastore
ldsDODetail.dataobject = 'd_shp_detail'
ldsDODetail.SetTransObject(SQLCA)

ldsDOAddress = Create u_ds_datastore
ldsDOAddress.dataobject = 'd_mercator_do_address' //Delivery_Alt_Address
ldsDOAddress.SetTransObject(SQLCA)

ldsDONotes = Create u_ds_datastore
ldsDONotes.dataobject = 'd_mercator_do_notes'
ldsDONotes.SetTransObject(SQLCA)


IF NOT isvalid(idsOMCDelivery) THEN					//OMC_Warehouse_Order
	idsOMCDelivery = Create u_ds_datastore
	idsOMCDelivery.dataobject ='d_omc_warehouse_order'
	idsOMCDelivery.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCDeliveryDetail) THEN		 		//OMC_Warehouse_Order_Detail
	idsOMCDeliveryDetail = Create u_ds_datastore
	idsOMCDeliveryDetail.dataobject ='d_omc_warehouse_orderdetail'
	idsOMCDeliveryDetail.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCDeliveryAttr) THEN		 		//OMC_Warehouse_OrderAttr
	idsOMCDeliveryAttr = Create u_ds_datastore
	idsOMCDeliveryAttr.dataobject ='d_omc_warehouse_orderattr'
	idsOMCDeliveryAttr.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMADeliveryQueue) THEN		 		//OMA_Warehouse_Order_Queue
	idsOMADeliveryQueue = Create u_ds_datastore
	idsOMADeliveryQueue.dataobject ='d_oma_warehouse_order_queue'
	idsOMADeliveryQueue.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOrderDetail) THEN
	idsOrderDetail =create Datastore
END IF

idsOMCDelivery.reset()
idsOMCDeliveryDetail.reset()
idsOMADeliveryQueue.reset()
idsOMCDeliveryAttr.reset()

//Open the File
lsLogOut = '      - OM Outbound Start Processing of uf_process_om_delivery() ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue
ls_org_sql =idsOMADeliveryQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMADeliveryQueue.setsqlselect( ls_org_sql)
ll_delivery_queue_count = idsOMADeliveryQueue.retrieve( )

lsLogOut =" Warehouse Order Queue SQL query is -> "+ls_org_sql
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
lsLogOut = " Warehouse Order Queue count from OM -> "+string(ll_delivery_queue_count)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


// load Queue datastore for processing
FOR llRowPos =1 to ll_delivery_queue_count
	ll_change_request_nbr = idsOMADeliveryQueue.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
NEXT

IF ll_delivery_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	ls_org_sql =idsOMCDelivery.getsqlselect( )
	ls_org_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )" //Threshold
	idsOMCDelivery.setsqlselect( ls_org_sql)
	ll_delivery_count = idsOMCDelivery.retrieve( )
	
	//Retrieving Orders from OM database
	lsLogOut = '      - OM Outbound - Getting Count(Records) from OM Warehouse_Order Table for Processing: ' + string(ll_delivery_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	
	// Reset main window microhelp message
	w_main.SetMicroHelp("Processing Delivery Order from OM")
	
	llOrderSeq = 0
		
	// 1. LOAD HEADER RECORDS
	For llRowPos = 1 to ll_delivery_count
		ll_change_request_nbr = idsOMCDelivery.getitemnumber(llRowPos, 'CHANGE_REQUEST_NBR')
		
		//Write to Log File and Screen
		lsLogOut = '      -OM Outbound - Processing Header Record for Change Request Nbr: ' + string(ll_change_request_nbr)
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		
		choose case  Upper(idsOMCDelivery.GetItemString(llRowPos, 'CHANGE_REQUEST_INDICATOR'))
		case 'INSERT' ,'N'
			lsAction ='A'
		case 'UPDATE' ,'R'
			lsAction ='U'
		case 'CANCEL'
			lsAction ='D'
		case else
			lsAction ='A'
		end choose
		
		//Get the next available file sequence number
		llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
		If llBatchSeq <= 0 Then Return -1
		
		// Start Creating the Header	
		llNewRow = ldsDOHeader.InsertRow(0)
		llOrderSeq ++
		llLineSeq = 0
		lbSoldToAddress = False
		
		//Record Defaults
		ls_warehouse ='REMA-NJ'
		ldtWHTime = f_getLocalWorldTime(ls_warehouse) //Local Warehouse Time
		
		ldsDOHeader.SetItem(llNewRow, 'project_id', upper(asProject))
		ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N')
		ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq)
		ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
		ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
		ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S')
		ldsDOHeader.SetItem(llNewRow, 'wh_code', ls_warehouse)
		ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
		ldsDOHeader.SetItem(llNewRow, 'OM_Order_Type', 'A') //A -> ASN
		ldsDOHeader.SetItem(llNewRow, 'OM_Confirmation_type', 'E') //E -> EDI
		
		ldsDOHeader.setitem( llNewRow, 'action_cd', lsAction) //Action Code
		ldsDOHeader.SetItem(llNewRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR
		ldsDOHeader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
		
		lsInvoice = Left(trim(idsOMCDelivery.GetItemString(llRowPos, 'EXTERNORDERKEY')),30) //Invoice No
		IF len(lsInvoice) > 0 Then
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', lsInvoice)
			ldsDOHeader.SetItem(llNewRow, 'Order_no', lsInvoice)
		ELSE
			ls_error_msg = "OM Outbound - Change_Request_Nbr ="+string(ll_change_request_nbr)+" -EXTERNORDERKEY shouldn't be NULL. Record will not be processed."
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
			ldsDOHeader.SetItem(llNewRow, 'Status_Message', 'EXTERNORDERKEY should not be NULL')
			gu_nvo_process_files.uf_process_om_writeerror( upper(asProject), 'E', ll_change_request_nbr,'OB', ls_error_msg)
			lbError = True
			Continue //Process Next Record
		END IF

		ls_Orig_Invoice = lsInvoice	//store Original Invoice No
		
		//23-MAY-2018 :Madhu S19513 - Rema-Substitution Order
		If Pos(lsInvoice, '-') > 0 Then 	
			lsInvoice = Left(lsInvoice, Pos(lsInvoice, '-') -1) //Modified Invoice No
			ls_consolidation_no = lsInvoice	 //store Consolidation No
		else
			ls_consolidation_no = ls_Orig_Invoice	 //store Consolidation No
			lsInvoice = ls_Orig_Invoice //set Original Invoice No
		End If

		//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process
		If lsAction ='A' Then lbDuplicate = this.uf_is_outbound_order_duplicated( asproject, lsInvoice)		//validate duplicate order against Delivery Master
		If lbDuplicate Then  this.uf_get_duplicated_order_detail_records( asproject, lsInvoice)		//If Yes, get order detail records
		
		ldtToday = ldtWHTime // Get local system date
		
		IF lsAction = 'U' Then
			Select  Count(1) into :llCountInv
			From Delivery_master with(nolock)
			Where project_ID = :asproject and Invoice_No = :ls_Orig_Invoice and Ord_Status <> 'V'
			using sqlca;

			If llCountInv = 0 Then //No order found.  Change to 'A'
				lsAction = 'A'
				ldsDOHeader.SetItem(llNewRow, 'Action_cd', lsAction)
			End IF
		End IF
		
		IF lsAction = 'U' Then  //IF the Action is "U"pdate We need to issue a delete and then an Add for the entire order
		
			ldsDOHeader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'D') /*Delete */
			
			lsAction = 'A'
			llBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'EDI_Outbound_Header', 'EDI_Batch_Seq_No')
			If llBatchSeq <= 0 Then Return -1
			
			llOrderSeq = 0 /*order seq within file*/
			
			llNewRow = ldsDOHeader.InsertRow(0)
			llOrderSeq ++
			llLineSeq = 0
			lbSoldToAddress = False
			
			//Record Defaults
			ldsDOHeader.SetITem(llNewRow, 'project_id', upper(asProject))
			ldsDOHeader.SetItem(llNewRow, 'Inventory_Type', 'N')
			ldsDOHeader.SetItem(llNewRow, 'edi_batch_seq_no', llbatchseq)
			ldsDOHeader.SetItem(llNewRow, 'order_seq_no', llOrderSeq) 
			ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'N')
			ldsDOHeader.SetItem(llNewRow, 'order_Type', 'S')
			ldsDOHeader.SetItem(llNewRow, 'wh_code', ls_warehouse)
			ldsDOHeader.SetItem(llNewRow, 'Last_user', 'SIMSEDI')
			ldsDOHeader.SetItem(llNewRow, 'Action_cd', 'A')
			
			ldsDOHeader.SetItem(llNewRow, 'Invoice_no', ls_Orig_Invoice)
			ldsDOHeader.SetItem(llNewRow, 'Order_no', ls_Orig_Invoice)
			ldsDOHeader.SetItem(llNewRow, 'ord_date', string(ldtWHTime, 'mm-dd-yyyy hh:mm'))
		End IF
		
		ldsDOHeader.SetItem(llNewRow, 'client_cust_po_nbr', idsOMCDelivery.getItemString(llRowPos, 'BUYER_PO')) //Client_cust_Po_Nbr
		ldsDOHeader.SetItem(llNewRow, 'Consolidation_No', ls_consolidation_no) //Consolidation_No
		
		
		//1.(a) Sold To Information - Delivery Alt Address
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS1'))) > 0 Then lbSoldToAddress = True
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS2'))) > 0 Then lbSoldToAddress = True
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ZIP'))) > 0 Then lbSoldToAddress = True
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_CITY'))) > 0 Then lbSoldToAddress = True
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_STATE'))) > 0 Then lbSoldToAddress = True
		if Len(trim(idsOMCDelivery.GetItemString(llRowPos, 'B_COUNTRY'))) > 0 Then lbSoldToAddress = True
		
		If lbSoldToAddress Then
			llNewAddressRow = ldsDOAddress.InsertRow(0)
			ldsDOAddress.SetItem(llNewAddressRow,'project_id',upper(asProject))
			ldsDOAddress.SetItem(llNewAddressRow,'edi_batch_seq_no',llbatchseq)
			ldsDOAddress.SetItem(llNewAddressRow,'order_seq_no',llOrderSeq) 
			
			ldsDOAddress.SetItem(llNewAddressRow,'address_type','ST')
			ldsDOAddress.SetItem(llNewAddressRow,'Name', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_Company')))
			ldsDOAddress.SetItem(llNewAddressRow,'address_1', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS1'))) 
			ldsDOAddress.SetItem(llNewAddressRow,'address_2', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ADDRESS2'))) 
			ldsDOAddress.SetItem(llNewAddressRow,'City', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_CITY')))
			ldsDOAddress.SetItem(llNewAddressRow,'State', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_STATE')))
			ldsDOAddress.SetItem(llNewAddressRow,'Zip', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_ZIP'))) 
			ldsDOAddress.SetItem(llNewAddressRow,'Country', trim(idsOMCDelivery.GetItemString(llRowPos, 'B_COUNTRY')))
			
			lbSoldToAddress = False
		End If
		
		//1.(b) - ShipTo Information
		ldsDOHeader.SetItem(llNewRow, 'Cust_Code', 'REMACUST')
		ldsDOHeader.SetItem(llNewRow, 'Cust_Name', trim(idsOMCDelivery.getItemString(llRowPos, 'C_COMPANY')))
		ldsDOHeader.SetItem(llNewRow, 'address_1', trim(idsOMCDelivery.getItemString(llRowPos, 'C_Address1')))
		ldsDOHeader.SetItem(llNewRow, 'address_2', trim(idsOMCDelivery.getItemString(llRowPos, 'C_Address2')))
		ldsDOHeader.SetItem(llNewRow, 'City', trim(idsOMCDelivery.getItemString(llRowPos, 'C_City')))
		ldsDOHeader.SetItem(llNewRow, 'State', trim(idsOMCDelivery.getItemString(llRowPos, 'C_State')))
		ldsDOHeader.SetItem(llNewRow, 'Zip', trim(idsOMCDelivery.getItemString(llRowPos, 'C_Zip')))
		ldsDOHeader.SetItem(llNewRow, 'Country', trim(idsOMCDelivery.getItemString(llRowPos, 'C_Country')))
		
		ldsDOHeader.SetItem(llNewRow, 'Request_Date', idsOMCDelivery.getitemDateTime(llRowPos, 'REQUESTEDSHIPDATE'))		
		ldsDOHeader.SetItem(llNewRow, 'Schedule_Date', idsOMCDelivery.getitemDateTime(llRowPos, 'DELIVERYDATE2'))
		ldsDOHeader.SetItem(llNewRow, 'Remark', trim(idsOMCDelivery.getItemString(llRowPos, 'NOTES')))
		ldsDOHeader.SetItem(llNewRow, 'Freight_Terms', trim(idsOMCDelivery.getItemString(llRowPos, 'FREIGHTPAYMENTTERMS')))
		ldsDOHeader.SetItem(llNewRow, 'User_Field2', trim(idsOMCDelivery.getItemString(llRowPos, 'CLIENT_SHIPTO_ID'))) //TAM - 2018/07/03 - S20885
		
		// 1.(c) -Delivery Notes Table - Load up in Batches of 255 Chars
		lsTemp = trim(idsOMCDelivery.GetItemString(llRowPos, 'NOTES2'))
		if isNull(lsTemp) then lsTemp = ''
		
		Do While pos(lsTemp,"~t") > 0 /*tab*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~t"),1," ")
		Loop
		
		Do While pos(lsTemp,"~n") > 0 /*New line*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~n"),1," ")
		Loop
		
		Do While pos(lsTemp,"~r") > 0 /*CR*/
			lsTemp = Replace(lsTemp, pos(lsTemp,"~r"),1," ")
		Loop
		
		Do While lsTemp > ''
			llNewNotesRow = ldsDONotes.InsertRow(0)
			ldsDONotes.SetITem(llNewNotesRow,'project_id', upper(asProject))
			ldsDONotes.SetItem(llNewNotesRow,'edi_batch_seq_no',llbatchseq)
			ldsDONotes.SetItem(llNewNotesRow,'order_seq_no',llOrderSeq) 
			ldsDONotes.SetItem(llNewNotesRow,'note_seq_no',llNewNotesRow) 
			ldsDONotes.SetItem(llNewNotesRow,'invoice_no',ls_Orig_Invoice)
			ldsDONotes.SetItem(llNewNotesRow,'note_type','DR')
			ldsDONotes.SetItem(llNewNotesRow,'line_item_no',0)
			ldsDONotes.SetItem(llNewNotesRow,'note_Text',Left(lsTemp,255))
			lsTemp = Right(lsTemp,len(lsTemp)-254)
		LOOP
		
		//2. LOAD DETAIL RECORDS
		ll_detail_error_count =0 //re-set detail error count value
		ls_error_msg ='' //re-set error msg value
		ll_delivery_detail_count = idsOMCDeliveryDetail.retrieve(ll_change_request_nbr )
		
		FOR ll_Row_Pos_Detail =1 to ll_delivery_detail_count	
		
			lbDetailError = False
			llNewDetailRow = 	ldsDODetail.InsertRow(0)
			llLineSeq ++
			
			//Add detail level defaults
			ldsDODetail.SetITem(llNewDetailRow, 'supp_code', 'REMA')
			ldsDODetail.SetItem(llNewDetailRow, 'project_id', upper(asProject))
			ldsDODetail.SetItem(llNewDetailRow, 'edi_batch_seq_no', llbatchseq)
			ldsDODetail.SetItem(llNewDetailRow, 'order_seq_no', llOrderSeq) 
			ldsDODetail.SetItem(llNewDetailRow, "order_line_no", string(llLineSeq))
			ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'N')
			
			ldsDODetail.SetItem(llNewDetailRow, 'Invoice_no', ls_Orig_Invoice)  //Invoice No
			
			// Line_Number
			lsTemp = trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'EXTERNLINENO'))
			IF IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " - EXTERNLINENO(Line Item Number) should not be NULL. Record will not be processed. ~n~r"
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				ldsDOHeader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'EXTERNLINENO(Line Item Number) should not be NULL. Record will not be processed.')
				lbDetailError = True
			Else	
				ldsDODetail.SetItem(llNewDetailRow, 'User_Line_Item_No', lsTemp)
				ldsDODetail.SetItem(llNewDetailRow, 'Client_Cust_Line_No', dec(lsTemp))
			End IF

			// SKU
			lsTemp = trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ITEM'))
			IF IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -ITEM(SKU) should not be NULL. Record will not be processed. ~n~r"
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				ldsDOHeader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'ITEM(SKU) should not be NULL. Record will not be processed.')
				lbDetailError = True
			Else
				ldsDODetail.SetItem(llNewDetailRow, 'sku', lsTemp) 
			End IF
			
			//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process
			llDupRow = 0
			
			If lbDuplicate and idsOrderDetail.rowcount( ) > 0 Then 
				llDupRow = this.uf_find_duplicated_order_sku_record( lsInvoice, lsTemp)  //find duplicated sku record
			End If
			
			If llDupRow > 0 Then
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -ITEM(SKU) is duplicated. Record will not be processed. ~n~r"
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				ldsDOHeader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'ITEM(SKU) is duplicated. Record will not be processed.')
				lbDetailError = True
			End If
			
			//  Quantity
			lsTemp = String(idsOMCDeliveryDetail.GetItemNumber(ll_Row_Pos_Detail, 'ORDEREDSKUQTY'))
			IF IsNull(lsTemp) or lsTemp = '' Then //Error
				ls_error_msg +="OM Outbound - Row: " + string(llNewDetailRow) + " -ORDEREDSKUQTY(QTY) should not be NULL. Record will not be processed. ~n~r"
				ldsDOHeader.SetItem(llNewRow, 'Status_cd', 'E')
				ldsDOHeader.SetItem(llNewRow, 'Status_Message', 'Errors exist on Header/Detail')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_cd', 'E')
				ldsDODetail.SetItem(llNewDetailRow, 'Status_Message', 'ORDEREDSKUQTY(QTY) should not be NULL. Record will not be processed.')
				lbDetailError = True
			ELSE
				ldsDODetail.SetItem(llNewDetailRow, 'quantity', lsTemp) 
			End IF

			//08-JUNE-2018 :Madhu S20135 - Alternate SKU
			ls_alt_sku = this.uf_get_alternate_sku( asproject, trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ITEM')), 'REMA')
			ldsDODetail.SetItem(llNewDetailRow, 'alternate_sku', trim(ls_alt_sku)) //Alt_Sku

			ldsDODetail.SetItem(llNewDetailRow, 'Customer_Sku', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'SUSR2'))) //Alt_Sku
			ldsDODetail.SetItem(llNewDetailRow, 'UOM',  trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ORDERED_SKU_UOM'))) //  Unit_of_Measure
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field1', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'REFCHAR1'))) //User Field1
			ldsDODetail.SetItem(llNewDetailRow, 'Lot_No', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'LOTTABLE02'))) //Lot No
			
			lsTemp = trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'orderlinenumber'))
			ldsDODetail.SetItem(llNewDetailRow, 'Line_Item_No', dec(lsTemp)) //Line Item No
			ldsDODetail.SetItem(llNewDetailRow, 'User_Field8', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'INVACCOUNT'))) //User Field8
			ldsDODetail.SetItem(llNewDetailRow, 'Client_Cust_Invoice', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'NB_ORDER_NBR'))) //Client Cust Invoice
			ldsDODetail.SetItem(llNewDetailRow, 'Cust_Line_Nbr', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'NB_ORDER_LINENUMBER'))) //Cust Line Nbr
			ldsDODetail.SetItem(llNewDetailRow, 'GTIN', trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ALTSKU'))) //ALt SKU  //TAM - 2018/07/03 - S20885
			
			ldsDODetail.SetItem(llNewDetailRow, 'OM_CHANGE_REQUEST_NBR', ll_change_request_nbr)  //CHANGE_REQUEST_NBR
			
			lsLogOut = '      - OM Outbound Processing of uf_process_om_delivery() ' 
			lsLogOut +='Change Request Nbr: '+string(ll_change_request_nbr) +' - sku: '+nz( trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'ITEM')) , '-')
			lsLogOut +=' Extern Line Item No: '+nz(trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'EXTERNLINENO')), '-')
			lsLogOut +=' Qty: '+nz(String(idsOMCDeliveryDetail.GetItemNumber(ll_Row_Pos_Detail, 'ORDEREDSKUQTY')), '-')
			lsLogOut +=' User Line Item No: '+nz(trim(idsOMCDeliveryDetail.GetItemString(ll_Row_Pos_Detail, 'orderlinenumber')), '-')
			lsLogOut += ' Duplicate Row: '+nz( string(llDupRow),'-')

			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

			IF lbDetailError Then ll_detail_error_count++
		
		Next /*Detail record */
		
		IF ll_detail_error_count > 0 Then 	
			gu_nvo_process_files.uf_process_om_writeerror( upper(asProject), 'E', ll_change_request_nbr,'OB', ls_error_msg)
		END IF
	Next //Header Record
ELSE
	Return 0
END IF

//Save Changes to DB
//17-APR-2019 :Madhu DE9999 - Updated Transaction records
//a. Since, we're not making any changes, removed idsOMCDelivery.update() from transaction.

ll_return =0
//Execute Immediate "Begin Transaction" using SQLCA; 4/2020 - MikeA - DE15499

liRC = ldsDOHeader.Update(false, false)
If liRC = 1 Then	liRC = ldsDODetail.Update(false, false)
If liRC = 1 Then	liRC = ldsDOAddress.Update(false, false)
If liRC = 1 Then	liRC = ldsDONotes.Update(false, false)

If liRC = 1 Then
	//Execute Immediate "COMMIT" using SQLCA; 4/2020 - MikeA - DE15499
	commit using sqlca;
	If sqlca.sqlcode =0 Then
		ldsDOHeader.resetupdate( )
		ldsDODetail.resetupdate( )
		ldsDOAddress.resetupdate( )
		ldsDONotes.resetupdate( )
		ll_return =0
	else
		//Execute Immediate "ROLLBACK" using SQLCA;
		rollback using sqlca; 
		ldsDOHeader.reset( )
		ldsDODetail.reset( )
		ldsDOAddress.reset( )
		ldsDONotes.reset( )
		ll_return = -1
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Processing of uf_process_om_delivery()- Failed to create Outbound Order '+sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	End If

Else
	//Execute Immediate "ROLLBACK" using SQLCA;
	rollback using sqlca;
	ldsDOHeader.reset( )
	ldsDODetail.reset( )
	ldsDOAddress.reset( )
	ldsDONotes.reset( )
	ll_return = -1
	
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Processing of uf_process_om_delivery()- Failed to create Outbound Order '+sqlca.sqlerrtext
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
End If

destroy  ldsDOHeader
destroy  ldsDODetail
destroy  ldsDOAddress
destroy  ldsDONotes
destroy  idsOMCDelivery
destroy  idsOMCDeliveryDetail
destroy  idsOMADeliveryQueue
destroy  idsOrderDetail


//Write to Log File and Screen
lsLogOut ="*** OM Outbound - End - Processing of uf_process_om_delivery() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

// Reset main window microhelp message
w_main.SetMicroHelp("Ready")


Return ll_return
end function

public function integer uf_process_om_warehouse_order (datastore adsorderlist);//30-Jan-2018 :Madhu  S15410 -EDI -940 -Outbound Order Acknowledgement
//Write records back into OMQ Warehouse OrderTables.

DataStore ldsDOAddress, ldsDOHeader, ldsDOdetail
String		lsLogOut, ls_status_cd, lsDoNo, lsWh, lsFind, ls_client_id, lsInvoice, ls_line_Item_No
Long		llFindRow, llNewRow, ll_row
Long 		ll_change_req_no, ll_rc, ll_batch_seq_no

DateTime ldtToday
ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM 940 Acknowledgement- Start Processing of uf_process_om_warehouse_order: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= 'REMA'
using sqlca;

If Not isvalid(ldsDOHeader) Then
	ldsDOHeader = Create Datastore
	ldsDOHeader.Dataobject = 'd_do_master'
	ldsDOHeader.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDOdetail) Then
	ldsDOdetail = Create Datastore
	ldsDOdetail.Dataobject = 'd_do_Detail'
	ldsDOdetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDOAddress) Then
	ldsDOAddress = Create u_ds_datastore
	ldsDOAddress.dataobject = 'd_do_address' //Delivery_Alt_Address
	ldsDOAddress.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQDelivery) Then
	idsOMQDelivery =Create u_ds_datastore
	idsOMQDelivery.Dataobject ='d_omq_warehouse_order'
	idsOMQDelivery.settransobject(om_sqlca)
End If

idsOMQDelivery.reset()

// LOAD HEADER RECORDS - Loop through Ref datastore to update OM tables.
For ll_row = 1 to adsorderlist.rowcount()
	ll_change_req_no = adsorderlist.getitemnumber(ll_row, 'change_req_no')
	ls_status_cd =adsorderlist.getitemstring(ll_row, 'status_cd')

	//Get DONO
	SELECT DO_No	INTO :lsDoNo
	FROM Delivery_Master with(nolock)
	WHERE Project_Id = 'REMA'  and OM_CHANGE_REQUEST_NBR = :ll_change_req_no
	using SQLCA;

	//Retrieve the Receive Header, Detail and Putaway records for this order
	If ldsDOHeader.Retrieve(lsDoNo) <> 1 Then
		lsLogOut = "                  *** Unable to retrieve Delivery Order Header For DONO: " + lsDoNo
		FileWrite(gilogFileNo,lsLogOut)
		Return -1
	End If

	lsWh = ldsDOHeader.GetItemString(1, 'wh_code')
	ll_batch_seq_no =ldsDOHeader.getitemnumber(1,'EDI_Batch_Seq_No')
	lsInvoice = ldsDOHeader.GetItemString(1, 'Invoice_no')

	//1. ADD OMQ_DELIVERY Tables
	llNewRow =	idsOMQDelivery.insertrow( 0)
		
	idsOMQDelivery.setitem(llNewRow,'CHANGE_REQUEST_NBR',ll_change_req_no)
	idsOMQDelivery.setitem(llNewRow,'CLIENT_ID',ls_client_id)
	idsOMQDelivery.setitem(llNewRow, 'QACTION', 'I') //Action
	idsOMQDelivery.setitem(llNewRow, 'QSTATUS', 'NEW') //QStatus
	idsOMQDelivery.setitem(llNewRow, 'STATUS', 'RELEASED') //Status
	idsOMQDelivery.setitem(llNewRow, 'QWMQID', ll_batch_seq_no) //Set with Batch_Transaction.Trans_Id
	idsOMQDelivery.setitem(llNewRow, 'ORDERKEY', Right(lsDoNo,10)) //Do No
	idsOMQDelivery.setitem(llNewRow, 'SITE_ID',  lsWh) //site id
	idsOMQDelivery.setitem(llNewRow, 'ADDDATE', ldtToday) //add_date
	idsOMQDelivery.setitem(llNewRow, 'ADDWHO', 'SIMSUSER') //add_who
	idsOMQDelivery.setitem( llNewRow, 'EDITDATE', ldtToday) //Edit Date
	idsOMQDelivery.setitem( llNewRow, 'EDITWHO', 'SIMSUSER') //Edit Who

	//Load Records from Delivery Master	
	idsOMQDelivery.SetItem(llNewRow, 'C_COMPANY', ldsDOHeader.GetItemString(1,'Cust_Name'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS1', ldsDOHeader.GetItemString(1,'Address_1'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS2', ldsDOHeader.GetItemString(1,'Address_2'))
	idsOMQDelivery.SetItem(llNewRow, 'C_ZIP', ldsDOHeader.GetItemString(1,'zip'))
	idsOMQDelivery.SetItem(llNewRow, 'C_CITY', ldsDOHeader.GetItemString(1,'City'))
	idsOMQDelivery.SetItem(llNewRow, 'C_STATE', ldsDOHeader.GetItemString(1,'State'))
	idsOMQDelivery.SetItem(llNewRow, 'C_COUNTRY', ldsDOHeader.GetItemString(1,'Country'))

	idsOMQDelivery.SetItem(llNewRow, 'BUYER_PO', ldsDOHeader.GetItemString(1,'client_cust_po_nbr'))
	idsOMQDelivery.SetItem(llNewRow, 'NOTES', ldsDOHeader.GetItemString(1, 'remark'))
	idsOMQDelivery.SetItem(llNewRow, 'TYPE', 'S')

	idsOMQDelivery.SetItem(llNewRow, 'FREIGHTPAYMENTTERMS',  ldsDOHeader.GetItemString(1,'Freight_Terms'))
	idsOMQDelivery.setitem( llNewRow, 'EXTERNORDERKEY', ldsDOHeader.GetItemString(1, 'Invoice_no')) //supp_invoice_no
	idsOMQDelivery.setitem( llNewRow, 'SUSR3', ldsDOHeader.GetItemString(1, 'Client_Cust_Po_Nbr')) 
	idsOMQDelivery.setitem( llNewRow, 'DELIVERYDATE2', ldsDOHeader.GetItemDateTime(1, 'Schedule_Date')) 

	//Get SHIP_FROM from Delivery Alt address
	ldsDOAddress.Retrieve(lsDoNo)
	lsFind ="address_type ='ST'"
	llFindRow =ldsDOAddress.find(lsFind,1,ldsDOAddress.rowcount())
	
	If llfindRow > 0 Then
		idsOMQDelivery.SetItem(llNewRow,'B_COMPANY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Name'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS1',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_1'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_ADDRESS2',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_2'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_CITY',Trim(ldsDOAddress.GetItemString(llfindRow, 'City')))
		idsOMQDelivery.SetItem(llNewRow,'B_STATE',Trim(ldsDOAddress.GetItemString(llfindRow, 'State')))
		idsOMQDelivery.SetItem(llNewRow,'B_ZIP',Trim(ldsDOAddress.GetItemString(llfindRow, 'Zip'))) 
		idsOMQDelivery.SetItem(llNewRow,'B_COUNTRY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Country')))
	End if
		
	//Write to File and Screen
	lsLogOut = '      - OM Outbound 940C- Processed Header Record for Do_No: ' + lsDoNo +" and Change_Request_No: "+string(ll_change_req_no)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
next /*next header record */

//2. OMQ_Delivery Detail records will be inserted during confirmation process.

//storing into DB
//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
If idsOMQDelivery.rowcount( ) > 0  Then ll_rc =idsOMQDelivery.update( false, false);

If ll_rc =1 Then
	//Execute Immediate "COMMIT" using om_sqlca;4/2020 - MikeA - DE15499
	commit using om_sqlca;
	if om_sqlca.sqlcode = 0 then
		idsOMQDelivery.resetupdate( )
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
		rollback using om_sqlca;
		idsOMQDelivery.reset( )
		//Write to Log File and Screen
		lsLogOut = "      - OM Outbound 940C- Unable to Save new SO Records to database .!~r~r" + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		Return -1
	end if

else
	//Execute Immediate "ROLLBACK" using om_sqlca;'
	rollback using om_sqlca;
	//Write to Log File and Screen
	lsLogOut = "      - OM Outbound 940C- System error, record save failed! .!~r~r" + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy ldsDOHeader
destroy ldsDOdetail
destroy ldsDOAddress
destroy idsOMQDelivery

//Write to File and Screen
lsLogOut = '      - OM 940 Acknowledgement- End Processing of uf_process_om_warehouse_order: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_process_om_item (string asproject);//08-Mar-2018 :Madhu - S16591 - REMA - EDI -888 Pull Item Master Records from OM.

string 	ls_omc_Item_Attr_sql, ls_omc_Item_sql, ls_Item_List, ls_Mod_Item_Sql, ls_Mod_Item_List
string		ls_om_threshold, lslogout, ls_org_sql, ls_change_request_nbrs, ls_sku, ls_find
long 		ll_item_queue_count, ll_Row_Pos, ll_change_request_nbr, ll_om_item_count, ll_om_item_attr_count
long		ll_Row, ll_New_Row, ll_find_item_row, ll_find_attr_row, ll_owner_id, lirc

str_parms lstr_item_list


ls_om_threshold =ProfileString (gsinifile ,"SIMS3FP", "OMTHRESHOLD","")

IF NOT isvalid(idsItem) THEN						//Item Master
	idsItem = Create u_ds_datastore
	idsItem.dataobject= 'd_item_master_om'
	idsItem.SetTransObject(SQLCA)
END IF

IF NOT isvalid(idsOMCItem) THEN					//OMC_Item
	idsOMCItem = Create u_ds_datastore
	idsOMCItem.dataobject ='d_omc_item'
	idsOMCItem.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMCItemAttr) THEN		 		//OMC_Item_Attr
	idsOMCItemAttr = Create u_ds_datastore
	idsOMCItemAttr.dataobject ='d_omc_item_attr'
	idsOMCItemAttr.SetTransObject(om_sqlca)
END IF

IF NOT isvalid(idsOMAItemQueue) THEN		 		//OMA_Item_Queue
	idsOMAItemQueue = Create u_ds_datastore
	idsOMAItemQueue.dataobject ='d_oma_item_queue'
	idsOMAItemQueue.SetTransObject(om_sqlca)
END IF

//reset all datastores
idsItem.Reset()
idsOMCItem.reset()
idsOMCItemAttr.reset()
idsOMAItemQueue.reset()

	
lsLogOut ="   OM Item Master Records Start Processing of uf_process_om_item() "
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

//Retrieve eligible records from Queue
ls_org_sql =idsOMAItemQueue.getsqlselect( )
ls_org_sql +=" AND DIST_SEQ_ID IN (SELECT SEQ_ID FROM OPS$OMAUTH.OMA_DISTRIBUTION WHERE SYSTEM_TYPE='SIMS' AND CLIE_CLIENT_ID ='"+is_om_client_id+"') "
ls_org_sql +=" AND ROWNUM < " + ls_om_threshold //Threshold
ls_org_sql +=" ORDER BY CHANGE_REQUEST_NBR  "
idsOMAItemQueue.setsqlselect( ls_org_sql)
ll_item_queue_count = idsOMAItemQueue.retrieve( )

lsLogOut =" Item SQL query is -> "+ls_org_sql
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

lsLogOut = " Item count from OM -> "+string(ll_item_queue_count)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

FOR ll_Row_Pos =1 to ll_item_queue_count
	ll_change_request_nbr = idsOMAItemQueue.getitemnumber(ll_Row_Pos, 'CHANGE_REQUEST_NBR') 
	ls_change_request_nbrs += string(ll_change_request_nbr) +","
	
	lstr_item_list.long_arg[ll_Row_Pos] = ll_change_request_nbr  //Add change req Nbr into str_parm
NEXT

IF ll_item_queue_count > 0 Then
	ls_change_request_nbrs =left(ls_change_request_nbrs, len(ls_change_request_nbrs) -1)
	
	//A. Retrieving Item Records from OM database
	ls_omc_Item_sql =idsOMCItem.getsqlselect( )
	ls_omc_Item_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )"
	idsOMCItem.setsqlselect( ls_omc_Item_sql)
	ll_om_item_count = idsOMCItem.retrieve( )
	
	//B. Retrieving Item Attr Records from OM database
	ls_omc_Item_Attr_sql =idsOMCItemAttr.getsqlselect( )
	ls_omc_Item_Attr_sql +=" WHERE CHANGE_REQUEST_NBR IN ( " + ls_change_request_nbrs + " )"
	idsOMCItemAttr.setsqlselect( ls_omc_Item_Attr_sql)
	ll_om_item_attr_count = idsOMCItemAttr.retrieve( )
	
	//Write to File and Screen
	lsLogOut = '      - OM Item Master - Getting count(Records) from OMC Item Table for Processing: ' + string(ll_om_item_count)
	lsLogOut += ' OMC Item Attr Table: '+ string(ll_om_item_attr_count)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	//C. get List of Items which are being In-Process.
	For ll_Row =1 to ll_om_item_count
		ls_Item_List += "'"+trim(idsOMCItem.getItemString( ll_Row, 'ITEM'))+"',"
	Next
	
	ls_Mod_Item_List = "(" +Left(ls_Item_List, len(ls_Item_List) - 1)+" )" //strip off comma at the end.
	
	//D. Look for Item Master Records (already exists ?)
	ls_Mod_Item_Sql = idsItem.getsqlselect( )
	ls_Mod_Item_Sql += " WHERE Project_Id ='"+upper(asproject)+"'"
	ls_Mod_Item_Sql += " and SKU IN "+ls_Mod_Item_List
	
	idsItem.setsqlselect( ls_Mod_Item_Sql)
	idsItem.settransobject( SQLCA)
	idsItem.retrieve( )
	
	//get Owner Id
	select Owner_Id into :ll_owner_id 	from Owner with(nolock) 
	where Project_Id ='REMA' and Owner_Cd='REMA'
	using sqlca;
	
	//E. Loop through OM Item Records
	For ll_Row =1 to ll_om_item_count
		ll_change_request_nbr = idsOMCItem.getItemNumber( ll_Row, 'CHANGE_REQUEST_NBR')
		ls_sku = trim(idsOMCItem.getItemString( ll_Row, 'ITEM'))
		
		ls_find = "project_Id ='"+upper(asproject)+"' and sku ='"+ls_sku+"' and supp_code ='REMA'"
		ll_find_item_row = idsItem.find( ls_find, 1, idsItem.rowcount())
		
		IF ll_find_item_row > 0 Then
			ll_New_Row = ll_find_item_row //update existing Item Master Record
		else
			ll_New_Row = idsItem.insertrow( 0) //Insert Record into Item Master
		End IF
		
		//F. Insert /Update record into Item Master
		idsItem.setItem( ll_New_Row,'Project_Id', 'REMA')
		idsItem.setItem( ll_New_Row,'SKU', ls_sku)
		//GailM 4/26/2018 S18652 F7680 I842 Rema: SPC/ALT SKU & code to populate on labels - Ops will load AltSKU
		//idsItem.setItem( ll_New_Row,'Alternate_Sku', idsOMCItem.getItemString(ll_Row, 'ALTSKU'))
		idsItem.setItem( ll_New_Row,'Description', trim(idsOMCItem.getItemString( ll_Row, 'DESCR')))
		idsItem.setItem( ll_New_Row,'Supp_Code', 'REMA')
		idsItem.setItem( ll_New_Row,'owner_id', ll_owner_id)
		
		idsItem.setItem( ll_New_Row,'Country_Of_Origin_Default', 'XXX')
		idsItem.setItem( ll_New_Row,'Standard_Of_Measure', 'E')
		idsItem.setItem( ll_New_Row,'Shelf_Life', idsOMCItem.getItemNumber(ll_Row, 'SHELFLIFE'))
		
		idsItem.setItem( ll_New_Row,'Weight_1', idsOMCItem.getItemNumber(ll_Row, 'GROSSWEIGHT'))
		idsItem.setItem( ll_New_Row,'Length_1', idsOMCItem.getItemNumber(ll_Row, 'LENGTH'))
		idsItem.setItem( ll_New_Row,'Width_1', idsOMCItem.getItemNumber(ll_Row, 'WIDTH'))
		idsItem.setItem( ll_New_Row,'Height_1', idsOMCItem.getItemNumber(ll_Row, 'HEIGHT'))
		idsItem.setItem( ll_New_Row,'UOM_1',  idsOMCItem.getItemString(ll_Row, 'UOM'))
		
		idsItem.setItem( ll_New_Row,'Part_UPC_Code', idsOMCItem.getItemString(ll_Row, 'UDF1'))
		idsItem.setItem( ll_New_Row,'User_Field4', idsOMCItem.getItemString(ll_Row, 'UDF3'))
		idsItem.setItem( ll_New_Row,'User_Field6', idsOMCItem.getItemString(ll_Row, 'HTS'))
		
		idsItem.setItem( ll_New_Row,'Lot_Controlled_Ind', 'Y')
		idsItem.setItem( ll_New_Row,'Container_Tracking_Ind', 'Y')
		
		If isNull(idsOMCItem.getItemString(ll_Row, 'ICDFLAG')) Then
			idsItem.setItem( ll_New_Row,'Expiration_Controlled_Ind', 'N')
		else
			idsItem.setItem( ll_New_Row,'Expiration_Controlled_Ind', idsOMCItem.getItemString(ll_Row, 'ICDFLAG'))			
		End If
		
		ls_find = "ATTR_TYPE ='PALLETSTRU' and CHANGE_REQUEST_NBR ="+string(ll_change_request_nbr)
		ll_find_attr_row = idsOMCItemAttr.find( ls_find, 1, idsOMCItemAttr.rowcount())
		
		IF ll_find_attr_row > 0 Then
			idsItem.setItem( ll_New_Row,'User_Field7', string(idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM1'))	)
			idsItem.setItem( ll_New_Row,'User_Field8', string(idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM2'))	)
			idsItem.setItem( ll_New_Row,'User_Field9', string(idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM3'))	)
		End IF
		
		ls_find = "ATTR_TYPE ='PALLETMEAS' and CHANGE_REQUEST_NBR ="+string(ll_change_request_nbr)
		ll_find_attr_row = idsOMCItemAttr.find( ls_find, 1, idsOMCItemAttr.rowcount())
		
		IF ll_find_attr_row > 0 Then
			idsItem.setItem( ll_New_Row,'Length_3', idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM1'))
			idsItem.setItem( ll_New_Row,'Width_3',  idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM2'))
			idsItem.setItem( ll_New_Row,'Height_3', idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM3'))	
			idsItem.setItem( ll_New_Row,'User_Field10', string(idsOMCItemAttr.getItemNumber(ll_find_attr_row, 'REFNUM4')))
		End IF
	Next
END IF

//Save the Changes to DB
lirc = idsItem.Update()
If lirc = 1 then
	Commit;
Else
	Rollback;
	lsLogOut = Space(17) + "- ***System Error!  Unable to Save new Item Records to database!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError("- ***System Error!  Unable to Save new Item Records to database!")
	Return -1
End If

//G. Update OMA_Item_Queue records
IF lirc > 0 Then gu_nvo_process_files.uf_process_om_item_master_update( lstr_item_list)


destroy idsItem
destroy idsOMCItem
destroy idsOMCItemAttr
destroy idsOMAItemQueue

Return 0
end function

public function boolean uf_is_outbound_order_duplicated (string asproject, string asinvoice);//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process
//Does Order already exists?

long ll_Order_count

select count(*)  into :ll_Order_count from Delivery_Master with(nolock) 
where Project_Id =:asproject and Invoice_No =:asinvoice and Ord_Status NOT IN ('V')
using sqlca;

IF ll_Order_count > 0 Then
	Return TRUE
ELSE
	Return FALSE
END IF
end function

public function datastore uf_get_duplicated_order_detail_records (string asproject, string asinvoiceno);//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process
//get a list of order detail records, if order already exists

string ls_sql, ls_errors


If Not IsValid(idsOrderDetail) Then
	idsOrderDetail = create Datastore
End If

ls_sql =" select  B.Project_Id, B.Ord_Status, B.Invoice_No, A.SKU  from Delivery_Detail A with(nolock) "
ls_sql +=" INNER JOIN Delivery_Master B with(nolock) ON A.Do_No =B.Do_No "
ls_sql +=" where B.Project_Id ='"+asproject+"' and B.Invoice_No='"+asInvoiceNo+"'"
ls_sql +=" and B.Ord_Status NOT IN ( 'V') "

idsOrderDetail.create( SQLCA.syntaxfromsql( ls_sql, "", ls_errors))
idsOrderDetail.settransobject( SQLCA)
idsOrderDetail.retrieve( )


return idsOrderDetail
end function

public function long uf_find_duplicated_order_sku_record (string asinvoiceno, string assku);//03-MAY-2018 :Madhu S18653 - Back/Duplicate Order Process
//Find, Is SKU already associated with same Order?

string lsFind, lsLogOut
long llFindRow

lsFind =" Invoice_No ='"+asinvoiceno+"' and sku ='"+assku+"'"
llFindRow = idsOrderDetail.find( lsFind, 1, idsOrderDetail.rowcount())

lsLogOut = '      - OM Outbound Processing of uf_find_duplicated_order_sku_record() ' 
lsLogOut += ' Find: '+nz(lsFind, '-') +' - Found Row: '+nz(string(llFindRow) ,'-')

FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/


Return llFindRow
end function

public function string uf_get_alternate_sku (string as_project, string as_sku, string as_supp_code);//08-JUNE-2018 :Madhu S20135 - Alternate SKU

string lsAltSku

Select alternate_sku into  :lsAltSku
From Item_Master with(nolock)
Where Project_id = :as_project
and SKU = :as_sku
and Supp_code =:as_supp_code
USING SQLCA;

Return lsAltSku
end function

public function integer uf_sync_om_inventory (string asproject);//TAM 2018/11 - S25784 - Rema-OM to SIMS inventory sync

datetime		ldtToday
String			lsErrors, lsSku, ls_client_id, lsLogout, sql_syntax
Long			ll_inv_count, llAvail, ll_OM_Qty_On_Hand, ll_req_count, ll_Row, ll_Inv_Row, llRC
Decimal		ldOMQ_Inv_Tran
datastore	ldsInv, ldsOpenOrders 


//write to screen and Log File
lsLogOut = '      -  Start Processing Function - Rema OM to SIMS Inventory Reconcilliation - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//write to screen and Log File
lsLogOut = '     	 	-  Start Processing Function - Reconcile Available Inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


ldtToday = DateTime(today(),Now())

gu_nvo_process_files.uf_connect_to_om( 'REMA') //connect to OM DB.

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
	idsOMQInvTran.SetTransObject(om_sqlca)
End If

If Not isvalid(idsOMAInvQtyOnHand) Then
	idsOMAInvQtyOnHand = Create u_ds_datastore
	idsOMAInvQtyOnHand.Dataobject = 'd_oma_inventory_qtyonhand'
	idsOMAInvQtyOnHand.SetTransObject(om_sqlca)
End If


//1.	Reconcile Available inventory between SIMS and OM

//build SQL Qeury to pull all Inventory from SIMS.
ldsInv = create Datastore

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id='REMA' using sqlca;

sql_syntax   = "Select rtrim(cs.SKU) as SKU, SUM(cs.avail_qty + cs.alloc_qty + cs.tfr_In) as c_avail "
sql_syntax += "from content_summary cs with (nolock), inventory_type it with (nolock) "
sql_syntax += "where cs.project_id = 'REMA' and it.project_id = 'REMA' "
sql_syntax += "and it.inv_type = cs.inventory_type  and it.inventory_shippable_ind = 'Y' "
sql_syntax += "Group by cs.SKU order by cs.SKU "

ldsInv.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore to Pull Inventory Items of Rema .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ldsInv.SetTransObject(SQLCA)
ll_inv_count =ldsInv.retrieve( )

//	Loop through each datastore record and update the allocated qty in OM
FOR ll_row =1 to ll_inv_count

//	Retrieve the corresponding OM Inventory for the current SIMS SKU
		lsSku = ldsInv.getitemString(ll_row, 'SKU')
		llAvail = ldsInv.getitemNumber(ll_row, 'c_avail')

		If llAvail > 0 Then
//			SELECT sum(qtyonhand)  INTO :ll_OM_Qty_On_Hand FROM oma_inv_account_balance with(nolock)   WHERE Client_id = '1206' and account = 'MAIN' and Item = :lssku using om_sqlca  ;
			idsOMAInvQtyOnHand.reset()
			idsOMAInvQtyOnHand.retrieve(lsSku)
			ll_OM_Qty_On_Hand = idsOMAInvQtyOnHand.getitemNumber(1, 'QtyOnHand')
			
			If llAvail <> ll_OM_Qty_On_Hand Then

				//	insert OMQ Record
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', 'REMA-NJ') //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no('REMA', 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', ldOMQ_Inv_Tran) //Set Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01','')
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', '')
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03','') 
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llAvail - ll_OM_Qty_On_Hand) 
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', 'Recn' + string(ldtToday,'YYMMDD'))
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', 'Recon-' + string(ldtToday,'YYMMDD'))
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
				idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'RECON') //Reason code
			End If
		End If	

NEXT

//Save Inventory Transaction
If idsOMQInvTran.rowcount( ) > 0 Then
	//Execute Immediate "Begin Transaction" using om_sqlca; 4/2020 - MikeA - DE15499
	llRC =idsOMQInvTran.update( false, false);

	If llRC =1 Then
		//Execute Immediate "COMMIT" using om_sqlca; 4/2020 - MikeA - DE15499
		commit using om_sqlca;

		if om_sqlca.sqlcode = 0 then
			idsOMQInvTran.resetupdate( )
		else
			//Execute Immediate "ROLLBACK" using om_sqlca; 4/2020 - MikeA - DE15499
			rollback using om_sqlca;
			idsOMQInvTran.reset( )
		
			//Write to File and Screen
			lsLogOut = '      - Rema OM to SIMS Inventory Reconcilliation - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		//Execute Immediate "ROLLBACK" using om_sqlca; MikeA - DE15499
		rollback using om_sqlca;
		//Write to File and Screen
			lsLogOut = '      - Rema OM to SIMS Inventory Reconcilliation - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText+  "System error, record save failed!"
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
End IF
idsOMQInvTran.reset( )
idsOMAInvQtyOnHand.reset()

//write to screen and Log File
lsLogOut = '     	 	-  End Processing Function - Reconcile Available Inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsInv

//2.	Reconcile Allocated inventory between SIMS and OM

//write to screen and Log File
lsLogOut = '     		 -  Start Processing Function - Reconcile Allocated inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//	Clear the existing allocated qty in the OM Inventory table (we will rebuild it below)
Update oma_inv_account_balance  set qtyallocated = 0 WHERE Client_id = '1206' and account = 'MAIN' using om_sqlca  ;

//Execute Immediate "Begin Transaction" using om_sqlca; MikeA - DE15499
//Execute Immediate "COMMIT" using om_sqlca; MikeA - DE15499
commit using om_sqlca;
if om_sqlca.sqlcode = 0 then
else
	//Execute Immediate "ROLLBACK" using om_sqlca;
	rollback using om_sqlca;
	
	//Write to File and Screen
	lsLogOut = '      - Rema OM to SIMS Allocated Reconcilliation (Set to Zero) - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
end if


//	Retrieve the SIMS “open” inventory into a datastore
//build SQL Qeury to pull all Inventory from SIMS.
ldsOpenOrders = create Datastore

sql_syntax =	   "Select rtrim(SKU) as SKU, SUM(req_qty) as req_qty "
sql_syntax += "from dbo.jOpenOrders Group By SKU order by SKU "

ldsOpenOrders.create( SQLCA.SyntaxFromSql(sql_syntax, "", lsErrors))

IF len(lsErrors) > 0 THEN
 	lsLogOut = "        *** Unable to create datastore to Pull Inventory Items of Rema .~r~r" + lsErrors
	FileWrite(gilogFileNo,lsLogOut)
END IF

ldsOpenOrders.SetTransObject(SQLCA)
ll_req_count =ldsOpenOrders.retrieve( )

//	Loop through each datastore record and update the allocated qty in OM
//	SQL = Update oma_inv_account_balance set qtyallocated = <qty> where client_id = ‘1206’ and item = <sku> and account = ‘MAIN’   
FOR ll_row =1 to ll_req_count
	//	Update the corresponding OM Inventory for the current SIMS SKU
		lsSku = ldsOpenOrders.getitemString(ll_row, 'SKU')
		llAvail = ldsOpenOrders.getitemNumber(ll_row, 'req_qty')
		Update oma_inv_account_balance  set qtyallocated = :llAvail WHERE Client_id = '1206' and account = 'MAIN' and Item = :lssku using om_sqlca  ;
NEXT

//Execute Immediate "Begin Transaction" using om_sqlca; MikeA - DE15499
//Execute Immediate "COMMIT" using om_sqlca; MikeA - DE15499
commit using sqlca;
if om_sqlca.sqlcode = 0 then
else
	//Execute Immediate "ROLLBACK" using om_sqlca; MikeA - DE15499
	rollback using om_sqlca;
		
	//Write to File and Screen
	lsLogOut = '      - Rema OM to SIMS Allocated Reconcilliation (Set OM to SIMS Value) - Processing of- uf_sync_om_inventory failed to write/update OM Tables: ' + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
end if


//write to screen and Log File
lsLogOut = '     	 	-  End Processing Function - Reconcile Allocated inventory between SIMS and OM - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsOpenOrders

//write to screen and Log File
lsLogOut = '      -  End Processing Function - Rema OM to SIMS Inventory Reconcilliation - uf_sync_om_inventory. '
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0


end function

on u_nvo_proc_rema.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_rema.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

