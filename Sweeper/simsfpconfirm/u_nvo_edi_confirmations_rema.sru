HA$PBExportHeader$u_nvo_edi_confirmations_rema.sru
$PBExportComments$Process outbound edi confirmation transactions for Rema
forward
global type u_nvo_edi_confirmations_rema from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_rema from nonvisualobject
end type
global u_nvo_edi_confirmations_rema u_nvo_edi_confirmations_rema

type variables

Datastore idsGR, idsROMain, idsRODetail, idsROPutaway, idsInvTypes   //GailM 3/14/2019 S31049
Datastore idsOMQROMain, idsOMQRODetail, idsOMQROSerial, idsOMExp, idsOMQInvTran, idsOMQInvTxnSernum
Datastore idsOMQWhDOMain, idsOMQWhDODetail, idsOMQWhDOSerial
Datastore idsOMQWhDOAttr, idsOMQWhDoDetailAttr

// TAM 2018/07/03 - S20885
Datastore	idsDOMain, idsDODetail, idsDOPick, idsDOPack,	idsOut
string lsDelimitChar

n_string_util in_string_util
String is_ToNo_List[]
end variables

forward prototypes
public function string nonull (string as_str)
public function integer uf_process_gr_om (string asproject, string asrono, long aitransid, string astransparm, string asaction)
public function string gmtformatoffset (string asgmtoffset)
public function string uf_process_om_receipt_type (string asproject, string asrono, string ascust_po_no)
public function long uf_process_create_batch_transaction (string as_project, string as_trans_type, long al_trans_order_id, string as_trans_parm)
public function integer uf_process_gi_om (string asproject, string asdono, long aitransid, string astransparm)
public function integer uf_process_om_warehouse_order (string asdono, long aitransid)
public function integer uf_process_om_adjustment (string asproject, long aladjustid, long altransid)
public function integer uf_process_gi_void_om (string asproject, string asdono, long altransid)
public function integer uf_gi (string asproject, string asdono)
end prototypes

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if

end function

public function integer uf_process_gr_om (string asproject, string asrono, long aitransid, string astransparm, string asaction);//2018/01/04 :TAM  - Added - Rema Goods Receipt Confirmation.
//Write records back into OMQ Tables.

String		lsFind,  lsLogOut,  lsTransYN,lsLineParm
String   	lsTransType, lsRemarks, lsDetailFind, ls_line_no
string		lsInvoice, lsRONO, lsSku, lsPrevSku, ls_client_id
String 	lsClientCustPONbr, ls_awb_bol, ls_carrier, ls_carrier_name

Decimal	 ldOwnerID, ldOwnerID_Prev, ldTransID, ldOMQ_Inv_Tran
Date 		 ld_exp_date
DateTime ldtTemp, ldtToday
Long		llRowPos, llRowCount, llFindRow,	llNewRow, llDetailFindRow, ll_detail_row, ll_return_code
Long 		ll_change_req_no, ll_rc, ll_batch_seq_no, ll_Inv_Row, llDetailQty, ll_orig_batch_seq_no
Long		ll_Inv_Types
Boolean 	lbParmFound, lbAddHeader

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- Start Processing of uf_process_gr_om() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

If Not isvalid(idsGR) Then
	idsGR = Create Datastore
	idsGR.Dataobject = 'd_rema_inv_trans'
End If

If Not isvalid(idsROmain) Then
	idsROmain = Create Datastore
	idsROmain.Dataobject = 'd_ro_master'
End If
idsROMain.SetTransObject(SQLCA)
	
If Not isvalid(idsroDetail) Then
	idsroDetail = Create Datastore
	idsroDetail.Dataobject = 'd_ro_Detail'
End If
idsroDetail.SetTransObject(SQLCA)
	
If Not isvalid(idsroputaway) Then
	idsroputaway = Create Datastore
	idsroputaway.Dataobject = 'd_ro_Putaway'
End If
idsroputaway.SetTransObject(SQLCA)
	
If Not isvalid(idsOMQROMain) Then
	idsOMQROMain =Create u_ds_datastore
	idsOMQROMain.Dataobject ='d_omq_receipt'
End If
idsOMQROMain.settransobject(om_sqlca)
	
If Not isvalid(idsOMQRODetail) Then
	idsOMQRODetail =Create u_ds_datastore
	idsOMQRODetail.Dataobject ='d_omq_receipt_detail'
End If
idsOMQRODetail.settransobject(om_sqlca)
	
If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =Create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)

If Not isvalid(idsInvTypes) Then
	idsInvTypes = Create Datastore
	idsInvTypes.Dataobject = 'd_inventory_types'
End If
idsInvTypes.SetTransObject(SQLCA)
	
idsGR.Reset()
idsOMQROMain.reset()
idsOMQRODetail.reset()
idsOMQInvTran.reset()

//Write to File and Screen
lsLogOut = "    OM Inbound Confirmation - Creating Inventory Transaction (GR) For RONO: " + asRONO
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
//Retrieve the Receive Header, Detail and Putaway records for this order
If idsroMain.Retrieve(asRoNo) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Receive Order Header For RONO: " + asRONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//GailM 03/14/2019 S31049 F13036 I1917 Rema Order Manager inventory types
ll_Inv_Types = idsInvTypes.Retrieve(asProject)

ll_change_req_no = idsROMain.getitemnumber(1,'OM_Change_request_nbr')
ll_batch_seq_no =idsROMain.getitemnumber(1,'EDI_Batch_Seq_No')
ls_carrier = idsROMain.getItemString( 1, 'Carrier')	//carrier

idsroDetail.Retrieve(asRONO)
idsroPutaway.Retrieve(asRONO)

llRowCount = idsROPutaway.RowCount()

If IsNull(ll_change_req_no) Then ll_change_req_no =0

// 03-09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

For llRowPos = 1 to llRowCount
	ls_line_no =  string(idsROPutaway.GetItemNumber(llRowPos, 'line_item_no' ) )
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )

	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if

	lsDetailFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU' ) ) + "'"
	lsDetailFind += " and line_item_no = " + ls_line_no
	llDetailFindRow = idsRODetail.Find(lsDetailFind, 1, idsRODetail.RowCount())

	if llDetailFindRow > 0 then
		If isnull(idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')) or idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no') = '' Then
			ls_line_no =  string(idsRODetail.GetItemNumber(llDetailFindRow, 'line_item_no'))
		Else
			ls_line_no =  idsRODetail.GetItemString(llDetailFindRow, 'user_line_item_no')
		End If
	end if
	
	lsFind = "upper(sku) = '" + upper(idsROPutaway.GetItemString(llRowPos, 'SKU')) + "'"
	lsFind += " and trans_line_no = '" + ls_line_no + "'"
	//GailM 11/05/2018 de7047 Add search for LotNo.  Report one line per LotNo.
	lsFind += " and lot_no= '" + upper(idsROPutaway.GetItemString(llRowPos, 'lot_no')) + "' "
	llFindRow = idsGR.Find(lsFind,1,idsGR.RowCount())

	If llFindRow > 0 Then /*row already exists, add the qty*/
		idsGR.SetItem(llFindRow,'quantity', (idsGR.GetItemNumber(llFindRow,'quantity') + idsROPutaway.GetItemNumber(llRowPos,'quantity')))
		lsTransYN ='N' //re-set value
	Else /*not found, add a new record*/
			lsTransYN = 'Y'	
	end if

	if lsTransYN = 'Y' then
		llNewRow = idsGR.InsertRow(0)
		idsGR.SetItem(llNewRow, 'trans_id', right(trim(idsROMain.GetItemString(1, 'ro_no')), 10)) // ro_no 
		idsGR.SetItem(llNewRow, 'trans_source_no', trim(idsROMain.GetItemString(1, 'supp_invoice_no')))
		idsGR.SetItem(llNewRow, 'wh_code', trim(idsROMain.GetItemString(1, 'wh_code'))) // wh_code 
		idsGR.SetItem(llNewRow, 'complete_date', idsROMain.GetItemDateTime(1, 'complete_date'))
		idsGR.SetItem(llNewRow, 'transport_mode', trim(idsROMain.GetItemString(1, 'transport_mode')))
		idsGR.SetItem(llNewRow, 'Container_Nbr', trim(idsROMain.GetItemString(1, 'Container_Nbr')))
		idsGR.SetItem(llNewRow, 'h_user_field2', idsROmain.GetItemString(1, 'user_field2')) //RM.UF1
		idsGR.SetItem(llNewRow, 'd_user_field2', idsRODetail.GetItemString(llDetailFindRow, 'user_field2')) //RD.UF2
		
		idsGR.SetItem(llNewRow, 'user_field3', idsROmain.GetItemString(1, 'user_field3'))
		idsGR.SetItem(llNewRow, 'user_field4', idsROmain.GetItemString(1, 'user_field4'))
		idsGR.SetItem(llNewRow, 'user_field5', idsROmain.GetItemString(1, 'user_field5'))
		idsGR.SetItem(llNewRow, 'user_field6', idsROmain.GetItemString(1, 'user_field6'))
		idsGR.SetItem(llNewRow, 'seal_nbr', idsROmain.GetItemString(1, 'seal_nbr'))
		idsGR.SetItem(llNewRow, 'awb_bol_no', idsROMain.GetItemString(1, 'awb_bol_no'))
		idsGR.SetItem(llNewRow, 'uom', idsRODetail.GetItemString(llDetailFindRow, 'uom'))
		idsGR.SetItem(llNewRow, 'alternate_sku', idsRODetail.GetItemString(llDetailFindRow, 'alternate_sku'))
		idsGR.SetItem(llNewRow, 'from_wh_loc', idsROMain.GetItemString(1, 'from_wh_loc'))
			
		idsGR.SetItem(llNewRow, 'sku', idsROPutaway.GetItemString(llRowPos, 'sku'))
		idsGR.SetItem(llNewRow, 'lot_no', idsROPutaway.GetItemString(llRowPos, 'lot_no'))
		idsGR.SetItem(llNewRow, 'quantity', idsROPutaway.GetItemNumber(llRowPos, 'quantity'))
		If isnull(ls_line_no) or ls_line_no = '' Then
			idsGR.SetItem(llNewRow, 'trans_line_no', idsroDetail.GetItemString(llDetailFindRow, 'user_line_item_no'))
		Else
			idsGR.SetItem(llNewRow, 'trans_line_no', ls_line_no)
		End If
	
		idsGR.setItem( llNewRow, 'expiration_date', idsROPutaway.GetItemDateTime(llRowPos, 'expiration_date')) //26-APR-2018 :Madhu S18747 -RP.Exp_Date
		idsGR.SetItem( llNewRow, 'inventory_type', idsROPutaway.GetItemString(llRowPos, 'inventory_type'))  //GailM 2/14/2019 S31049 InvType
	end if

	skipDetailRow:
Next /* Next Putaway record */

lbAddHeader =TRUE

//Write the rows to respective OMQ Tables
IF ll_change_req_no > 0 Then
	llRowCount = idsGR.RowCount()
	For llRowPos = 1 to llRowCount
		
		//1. ADD OMQ_RECEIPT Tables
		IF lbAddHeader =TRUE Then //Add Header Record against 1st row.
	
			idsOMQROMain.insertrow( 0)
			ldtTemp = idsGR.GetItemDateTime(llRowPos, 'complete_date')
			
			idsOMQROMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
			idsOMQROMain.setitem(1,'CLIENT_ID',ls_client_id)
			idsOMQROMain.setitem(1, 'QACTION', asaction) //Action
			
			If upper(asaction) ='I' Then
				idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
				idsOMQROMain.setitem(1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
				idsOMQROMain.setitem(1, 'STATUS', 'NOTRECVD') //Status
			else
				idsOMQROMain.setitem(1, 'QSTATUS', 'NEW') //QStatus
				idsOMQROMain.setitem(1, 'QWMQID', aitransid +.1) //Set with Batch_Transaction.Trans_Id
				idsOMQROMain.setitem(1, 'STATUS', '9') //Status
			End If
			
			idsOMQROMain.setitem(1, 'RECEIPTKEY', Right(asrono,10)) //Receipt Key
			idsOMQROMain.setitem(1, 'SITE_ID', idsGR.GetItemString(llRowPos, 'wh_code')) //site id
			idsOMQROMain.setitem(1, 'DEST_WHS_ID', idsGR.GetItemString(llRowPos, 'From_Wh_Loc')) //DEST_WHS_ID
				
			idsOMQROMain.setitem( 1, 'EXTERNRECEIPTKEY', idsGR.GetItemString(llRowPos, 'trans_source_no' )) //supp_invoice_no
			idsOMQROMain.setitem( 1, 'EXTERNALRECEIPTKEY2', idsGR.GetItemString(llRowPos, 'trans_source_no')) //supp_invoice_no
			idsOMQROMain.setitem( 1, 'RECEIPTDATE', ldtTemp) //trans_date
			idsOMQROMain.setitem( 1, 'TYPE', 'ASN') //Type
			
			idsOMQROMain.setitem( 1, 'CARRIERKEY',  ls_carrier) 	//Carrier
			idsOMQROMain.setitem( 1, 'CARRIERNAME',   idsGR.GetItemString(llRowPos, 'user_field6')) 	//CARRIERNAME
	
			idsOMQROMain.setitem( 1, 'CARRIER_REFERENCE',  idsGR.GetItemString(llRowPos, 'awb_bol_no')) 	//Awb Bol No
			idsOMQROMain.setitem( 1, 'TRANSPORTATION_MODE',  idsGR.GetItemString(llRowPos, 'transport_mode')) 	//transport_mode
			idsOMQROMain.setitem( 1, 'CONTAINER_KEY',  idsGR.GetItemString(llRowPos, 'Container_Nbr')) 	//container_nbr
			idsOMQROMain.setitem( 1, 'SUSR1',  idsGR.GetItemString(llRowPos, 'seal_nbr')) 	//Seal Nbr
			idsOMQROMain.setitem( 1, 'SUSR2', idsGR.GetItemString(llRowPos, 'h_user_field2' )) 
			idsOMQROMain.setitem( 1, 'SUSR3', idsGR.GetItemString(llRowPos, 'user_field3' )) 
			idsOMQROMain.setitem( 1, 'SUSR4', idsGR.GetItemString(llRowPos, 'user_field4' )) 
			idsOMQROMain.setitem( 1, 'SUSR5', idsGR.GetItemString(llRowPos, 'user_field5' )) 
			
			idsOMQROMain.setitem(1, 'ADDDATE', today()) //add_date
			idsOMQROMain.setitem(1, 'ADDWHO', 'SIMSUSER') //add_who
			idsOMQROMain.setitem(1, 'EDITDATE', today()) //edit_date
			idsOMQROMain.setitem(1, 'EDITWHO', 'SIMSUSER') //edit_who
			
			//Write to File and Screen
			lsLogOut = '      - OM Inbound Confirmation- Processing Header Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no)
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
		End IF
		
		//2. ADD OMQ_RECEIPTDETAIL Tables
		//Roll Up Detail records for same attribute values.
		
		If (not isnull(idsGR.GetItemString(llRowPos, 'trans_source_no')) and len(idsGR.GetItemString(llRowPos, 'trans_source_no')) > 0) Then lsFind = "EXTERNRECEIPTKEY = '" + idsGR.GetItemString(llRowPos, 'trans_source_no') + "'"
		If (not isnull(idsGR.GetItemString(llRowPos, 'sku')) and len(idsGR.GetItemString(llRowPos, 'sku')) > 0) Then lsFind += " and ITEM = '" + upper(idsGR.GetItemString(llRowPos, 'sku')) + "'"
		If (not isnull(idsGR.GetItemString(llRowPos, 'trans_line_no')) and len(idsGR.GetItemString(llRowPos, 'trans_line_no')) > 0) Then lsFind += " and EXTERNLINENO = '" +  idsGR.GetItemString(llRowPos, 'trans_line_no') + "'"
		If (not isnull(idsGR.GetItemString(llRowPos, 'lot_no')) and len(idsGR.GetItemString(llRowPos, 'lot_no')) > 0) Then lsFind += " and LOTTABLE02 = '" +  idsGR.GetItemString(llRowPos, 'lot_no') + "'"
	
		IF idsOMQRODetail.RowCount() > 0 Then 	
			llDetailFindRow = idsOMQRODetail.Find(lsFind,1,idsOMQRODetail.RowCount())
			If llDetailFindRow >0 Then 
				llDetailQty = idsOMQRODetail.GetItemNumber(llDetailFindRow,'QTYRECEIVED')
			else
				llDetailFindRow = 0
			End If
			
		else
			llDetailFindRow = 0
		End IF
		
		If llDetailFindRow = 0 Then
			ll_detail_row = idsOMQRODetail.insertrow( 0)
			idsOMQRODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR', ll_change_req_no) //change_request_no
			idsOMQRODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id) //client_Id
			idsOMQRODetail.setitem( ll_detail_row, 'QACTION', asaction) //Action
			
			If upper(asaction) ='I' Then
				idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
				idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
				idsOMQRODetail.setitem(ll_detail_row, 'STATUS', 'NOTRECVD') //Status
			else
				idsOMQRODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW') //QStatus
				idsOMQRODetail.setitem( ll_detail_row, 'QWMQID', aitransid +.1) //Set with Batch_Transaction.Trans_Id
				idsOMQRODetail.setitem(ll_detail_row, 'STATUS', '9') //Status
			End If
				
			idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTKEY', Right(asrono,10)) //Receipt Key
			idsOMQRODetail.setitem( ll_detail_row, 'SITE_ID', idsGR.GetItemString(llRowPos, 'wh_code')) //site id
			
			idsOMQRODetail.setitem( ll_detail_row, 'EXTERNRECEIPTKEY', idsGR.GetItemString(llRowPos, 'trans_source_no')) //client cust po nbr
			idsOMQRODetail.setitem( ll_detail_row, 'EXTERNLINENO', idsGR.GetItemString(llRowPos, 'trans_line_no')) //user_line_item_no
			idsOMQRODetail.setitem( ll_detail_row, 'ITEM', upper(idsGR.GetItemString(llRowPos, 'sku'))) //sku
			idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE02', upper(idsGR.GetItemString(llRowPos, 'lot_no'))) //lot_no
			idsOMQRODetail.setitem( ll_detail_row, 'QTYRECEIVED', idsGR.GetItemNumber(llRowPos,'quantity')) //QTY
			idsOMQRODetail.setitem( ll_detail_row, 'ALTSKU', upper(idsGR.GetItemString(llRowPos, 'alternate_sku'))) //alternate_sku
			idsOMQRODetail.setitem( ll_detail_row, 'RECEIPTLINENUMBER', string(ll_detail_row)) //Receipt Line Nbr
			idsOMQRODetail.setitem( ll_detail_row, 'UOM',upper(idsGR.GetItemString(llRowPos, 'uom'))) //UOM
			idsOMQRODetail.setitem( ll_detail_row, 'NOTES',upper(idsGR.GetItemString(llRowPos, 'd_user_field2'))) //RD.User_Field2
			idsOMQRODetail.setitem( ll_detail_row, 'ADDDATE', Date(today())) //add_date
			idsOMQRODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER') //add_who
			idsOMQRODetail.setitem( ll_detail_row, 'EDITDATE', Date(today())) //edit_date
			idsOMQRODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER') //edit_who
			
			ld_exp_date = Date(idsGR.getItemdatetime( llRowPos, 'expiration_date')) //26-APR-2018 :Madhu S18747 -RP.Exp_Date
			If String(ld_exp_date, 'MM/DD/YYYY') <> '12/31/2099' Then  idsOMQRODetail.setitem( ll_detail_row, 'LOTTABLE05', ld_exp_date) //Expiration Date
		else
			idsOMQRODetail.setitem( ll_detail_row, 'QTYRECEIVED', idsGR.GetItemNumber(llRowPos,'quantity') +llDetailQty) //QTY
		End If
		
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+idsGR.GetItemString(llRowPos, 'trans_line_no')
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
	
		lbAddHeader =FALSE //only one time
		
	next /*next output record */
	
	idsOMQROMain.setitem( 1, 'LINECOUNT',   idsOMQRODetail.rowcount()) 	//Line Count - Set Detail Record count
	
	//storing into DB
	Execute Immediate "Begin Transaction" using om_sqlca;
	If idsOMQROMain.rowcount( ) > 0 Then	ll_rc =idsOMQROMain.update( false, false);
	If idsOMQRODetail.rowcount( ) > 0 and ll_rc =1 Then 	ll_rc =idsOMQRODetail.update( false, false);
	
	IF ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQROMain.resetupdate( )
			idsOMQRODetail.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQROMain.reset( )
			idsOMQRODetail.reset( )
			
			//Write to File and Screen
			lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " is failed to write records to OM: "+ om_sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
	
			Return -1
		end if
	
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		Return -1
	End IF
END IF

//Write to File and Screen
lsLogOut = '      - OM Inbound Transaction- Writing Inventory Transaction record for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

If upper(asaction) ='U' Then
	//OMQ_Inventory_Transaction
	For llRowPos =1 to  idsROPutaway.RowCount()
		lsFind = "Inv_Type = '" + idsROPutaway.GetItemString(llRowPos, "inventory_type") + "' "
		llFindRow = idsInvTypes.Find(lsFind, 1, idsInvTypes.RowCount())
		
		If llFindRow > 0 Then
			If idsInvTypes.GetItemString(llFindRow, "Inventory_Shippable_Ind") = "Y" Then 
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
				
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', trim(idsROMain.GetItemString(1, 'wh_code'))) //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Edit Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Edit who
			
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
			
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'DP') //Tran Type as DP (Deposit)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', idsROPutaway.getitemstring(llRowPos ,'sku')) //RP.Sku
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', idsROPutaway.getitemstring(llRowPos ,'lot_no')) //RP.Lot_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', idsROPutaway.GetItemNumber(llRowPos,'quantity')) //ITRNKey
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(trim(idsROMain.GetItemString(1, 'supp_invoice_no')),10)) //RM.Supp_Invoice_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(asrono,10)) //Receipt Key
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', string(ll_Inv_Row)) //RP.Line_Item_No		//GailM 11/05/2018 DE7047 One line per lot number
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', idsROPutaway.getitemstring(llRowPos ,'ro_no') + string (idsROPutaway.GetItemNumber(llRowPos,'line_item_no') ,'0000')) //RP.Ro_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'PUTAWAY') //Putaway
			End If
		Else
			lsLogOut = "                  *** Unable to find inventory type: " +  idsROPutaway.GetItemString(llRowPos, "inventory_type") + ".  OMQ Inv Tran not created."
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	Next
	
	//storing into DB
	Execute Immediate "Begin Transaction" using om_sqlca;
	
	If idsOMQInvTran.rowcount( ) > 0 Then
		ll_rc =idsOMQInvTran.update( false, false);
	End IF
	
	If ll_rc =1 Then
		Execute Immediate "COMMIT" using om_sqlca;
	
		if om_sqlca.sqlcode = 0 then
			idsOMQInvTran.resetupdate( )
		else
			Execute Immediate "ROLLBACK" using om_sqlca;
			idsOMQInvTran.reset( )
			//Write to File and Screen
			lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Error:  "+ om_sqlca.sqlerrtext
			FileWrite(giLogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut)
			Return -1
		end if
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		//Write to File and Screen
		lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Error: "+ om_sqlca.sqlerrtext
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	End If
End If //QACTION ='U'

ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- Processing Detail Record for Ro_No: ' + asrono +"  Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code "+ string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy idsOMQROMain
destroy idsOMQRODetail
destroy idsOMQInvTran

gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OT29 DB

//Write to File and Screen
lsLogOut = '      - OM Inbound Confirmation- End Processing of uf_process_gr_om() for Ro_No: ' + asrono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return ll_return_code
end function

public function string gmtformatoffset (string asgmtoffset);//22-SEP-2017 :Madhu PINT- 945 Format GMT OffSet
//It should be -0400 instead -4:00

long  ll_Pos, ll_Sign_Pos, ll_gmtoffset
String ls_gmt_offset, ls_left, ls_right, ls_Sign

ll_gmtoffset = len(asgmtoffset) //length of gmt

ll_Sign_Pos = Pos(asgmtoffset, '+') //sign position
If ll_Sign_Pos =0 Then ll_Sign_Pos = Pos(asgmtoffset, '-')

ls_Sign =left(asgmtoffset, (ll_gmtoffset - (ll_gmtoffset - ll_Sign_Pos))) //sign value

If isNull(ls_Sign) or ls_Sign='' or len(ls_Sign) =0 Then ls_Sign ='+' //set default value to Sign

If ll_Sign_Pos = 0 Then //Default (+)
	ll_Pos = Pos(asgmtoffset, '.')
else 						 //Sign could be (-)
	asgmtoffset = Right(asgmtoffset, (ll_gmtoffset - ll_Sign_Pos))
	ll_Pos = Pos(asgmtoffset, '.')
End If

If ll_Pos > 0 Then
	ls_left = left(asgmtoffset, (ll_Pos -1))
	ls_right = Right(asgmtoffset, (len(asgmtoffset) - ll_Pos)) 
	
	ls_left =String(long(ls_left),'00')
	ls_right =String(long(ls_right),'00')
	ls_gmt_offset =  ls_Sign +ls_left + ls_right
	
End If


return ls_gmt_offset

end function

public function string uf_process_om_receipt_type (string asproject, string asrono, string ascust_po_no);//26-Oct-2017 :Madhu PINT-861 - Return TYPE based on following rules.
String ls_source_type, ls_om_type

select Source_Type into :ls_source_type 
from Receive_Master with(nolock)
where Project_Id=:asproject and Ro_No=:asrono
using sqlca;


If upper(ls_source_type) ='WEB' Then  //If Order is loaded through WEB
	ls_om_type ='MANORD'
elseIf (Pos(ascust_po_no,'MOR') > 0 OR Pos(ascust_po_no,'MTR') > 0 OR Pos(ascust_po_no,'CMOR') > 0 &
			OR Pos(ascust_po_no,'CMTR') > 0 OR Pos(ascust_po_no,'FMOR') > 0 OR Pos(ascust_po_no,'FMTR') > 0) Then //If Order Prefix containes
	ls_om_type ='DLVORD'
else
	ls_om_type ='ASN'
End If

Return ls_om_type
end function

public function long uf_process_create_batch_transaction (string as_project, string as_trans_type, long al_trans_order_id, string as_trans_parm);string ls_trans_order_Id
long 	ll_Batch_Row, ll_rc, ll_batch_Id
DateTime ldtToday

Datastore ldsBatchTran

If Not IsValid(ldsBatchTran) Then
	ldsBatchTran = create u_ds_datastore
	ldsBatchTran.dataobject='d_batch_transaction'
	ldsBatchTran.settransobject( SQLCA)
End If

ldtToday =DateTime(Today(), Now())
ls_trans_order_Id = string(al_trans_order_Id)

//Create Batch Transaction Record
Insert into Batch_Transaction (Project_Id, Trans_Type, Trans_Order_Id, Trans_Status, Trans_Parm,Trans_Create_Date)
values (:as_project, :as_trans_type, :ls_trans_order_Id, 'N',:as_trans_parm, :ldtToday)
using sqlca;

select Max(Trans_Id) into :ll_Batch_Id from Batch_Transaction with(nolock)
where Project_Id=:as_project and Trans_Type=:as_trans_type
and Trans_Order_Id =:ls_trans_order_Id
using sqlca;


Return ll_Batch_Id
end function

public function integer uf_process_gi_om (string asproject, string asdono, long aitransid, string astransparm);//02-FEB-2018 :Madhu S15431- REMA 945 Ship confirmation
//Write records back into OMQ Tables
//20-MAR-2018 :Madhu DE3522 - Write Inventory Txn records against ldsGI Datastore

String		lsFind, lsLogOut, lsWH, lsElectronicYN, ls_prev_carton_No, lsInvoice, lsDONO, lsOrdType, lsLineParm,ls_line_no, ls_client_id
String 	ls_wh_name, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_city, ls_state, ls_zip, ls_country, ls_tel, ls_fax, ls_contact, ls_email
String		ls_sql_syntax, ls_carton_No, ls_carton_type, ls_detail_Find, ls_gmt_offset, lsCarrier, ls_dd_uf8

Long		llRowPos, llRowCount, llNewRow, ll_attr_row, llDetailFindRow, llDetailQty,  ll_return_code, llFindRow, ll_Pick_Qty
Long 		ll_change_req_no, ll_batch_seq_no, ll_rc, ll_detail_row, ll_Inv_Row,  llPackRowCount, ll_Pack_Row, ll_Order_Line_No
Long		ll_Inv_Types		//GailM 3/14/2019

Decimal		ldBatchSeq, ldTransID, ldOMQ_Inv_Tran, ld_total_weight
DateTime 	 ldtToday
Boolean 		lbParmFound

ldtToday = DateTime(Today(), Now())

Datastore ldsDOMain, ldsDoDetail, ldsDoPick, ldsDoPack, ldsGI

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Start Processing of uf_process_gi_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_connect_to_om( upper(asProject)) //connect to OP39 DB.


If Not isvalid(ldsGI) Then
	ldsGI = Create u_ds_datastore
	ldsGI.Dataobject = 'd_rema_inv_trans'
End If

If Not isvalid(ldsDOMain) Then
	ldsDOMain = Create u_ds_datastore
	ldsDOMain.Dataobject = 'd_do_master'
	ldsDOMain.SetTransObject(SQLCA)
End If
	
If Not isvalid(ldsDoDetail) Then
	ldsDoDetail = Create u_ds_datastore
	ldsDoDetail.Dataobject = 'd_do_Detail'
	ldsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(ldsDoPick) Then
	ldsDoPick = Create Datastore
	ldsDoPick.Dataobject = 'd_do_Picking'			
	ldsDoPick.SetTransObject(SQLCA)	
End if

If Not isvalid(ldsDoPack) Then
	ldsDoPack = Create u_ds_datastore
	ldsDoPack.Dataobject = 'd_do_packing_track_id_pandora'
	ldsDoPack.SetTransObject(SQLCA)
End If
	
If Not isvalid(idsOMQWhDOMain) Then
	idsOMQWhDOMain =create u_ds_datastore
	idsOMQWhDOMain.Dataobject ='d_omq_warehouse_order'
End If
idsOMQWhDOMain.settransobject(om_sqlca)

If Not isvalid(idsOMQWhDODetail) Then
	idsOMQWhDODetail =create u_ds_datastore
	idsOMQWhDODetail.Dataobject ='d_omq_warehouse_order_detail'
End If
idsOMQWhDODetail.settransobject(om_sqlca)

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran =Create u_ds_datastore
	idsOMQInvTran.Dataobject ='d_omq_inventory_transaction'
End If
idsOMQInvTran.settransobject(om_sqlca)
	
If Not isvalid(idsOMQWhDOAttr) Then
	idsOMQWhDOAttr =Create u_ds_datastore
	idsOMQWhDOAttr.Dataobject ='d_omq_warehouse_order_attr'
End If
idsOMQWhDOAttr.settransobject(om_sqlca)
	
If Not isvalid(idsInvTypes) Then
	idsInvTypes = Create Datastore
	idsInvTypes.Dataobject = 'd_inventory_types'
End If
idsInvTypes.SetTransObject(SQLCA)
	

ldsGI.Reset()
idsOMQWhDOMain.reset()
idsOMQWhDODetail.reset()
idsOMQWhDOAttr.reset()
idsOMQInvTran.reset()

lsLogOut = "      OM Outbound Confirmation -Creating Inventory Transaction (GI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

If ldsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//GailM 03/14/2019 S31049 F13036 I1917 Rema Order Manager inventory types
ll_Inv_Types = idsInvTypes.Retrieve(asProject)

w_main.SetMicroHelp("Processing Purchase Order (EDI - OM)")

lsOrdType = NoNull(ldsDOMain.GetItemString(1, 'ord_type'))
lsWH = ldsDOMain.GetItemString(1, 'wh_code')
ll_change_req_no = ldsDOMain.getitemnumber(1,'OM_CHANGE_REQUEST_NBR')
ll_batch_seq_no =ldsDOMain.getitemnumber(1,'EDI_Batch_Seq_No')

If IsNull(ll_change_req_no)  Then 
	ll_rc = this.uf_process_om_warehouse_order( asdono, aitransid) //create OMQ Orders for Manual Orders.
	If ll_rc <> 0 Then Return -1
End If

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

select wh_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, Fax, Contact_Person, Email_Address, GMT_Offset
into :ls_wh_name, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_city, :ls_state, :ls_zip, :ls_country, :ls_tel, :ls_fax, :ls_contact, :ls_email, :ls_gmt_offset
from Warehouse with(nolock)
where wh_Code=:lsWH
using sqlca;

//Now using Create_User = 'SIMSFP' to determine Electronic order
if ldsDOMain.GetItemString(1, 'Create_User')  = 'SIMSFP' then
	lsElectronicYN = 'Y'
else
	lsElectronicYN = 'N'
	lsInvoice = ldsDOMain.GetItemString(1, 'Invoice_no')
	
	select do_no into :lsDONO from Delivery_master with(nolock) 
	where project_id = 'REMA' and invoice_no = :lsInvoice 
	and wh_code = :lsWH and create_user = 'SIMSFP'
	using sqlca;
	
	if lsDONO > '' then
		lsElectronicYN = 'Y'
	end if
end if

ldsDoDetail.Retrieve(asDoNo)
ldsDoPick.Retrieve(asDoNo)
ldsDoPack.Retrieve(asDoNo)

// TAm 2010/06/09 - Filter out Children
ldsDoPick.Setfilter("Component_Ind <> '*'")
ldsDoPick.Filter()

llRowCount = ldsDoPick.RowCount()

// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1
lsLogOut = "             Populate GI datastore at: '"  + String(f_getLocalWorldTime(lsWH))
FileWrite(gilogFileNo,lsLogOut)

For llRowPos = 1 to llRowCount
	//Refresh screen willl looping
	if llRowPos = 10000 or llRowPos = 20000 or llRowPos = 30000 or llRowPos = 40000 then
		yield()
	End if
	
	ls_line_no = string(ldsDoPick.GetItemNumber(llRowPos, 'line_item_no') )
	lsLineParm = f_validate_transparm(ls_line_no, astransparm, lbParmFound )
	
	If ls_line_no <> lsLineParm  and lbParmFound = True then 
		GOTO skipDetailRow  //Note: Goto is right before the Next statement
	End if
	
	If ldsDoPick.GetItemString(llRowPos,'component_ind') = 'Y' and ldsDoPick.GetItemNumber(llRowPos,'Component_no') = 0 Then Continue 
	
	//Roll Up Detail records for same attribute values.
	lsFind = "trans_source_no ='"+trim(ldsDOMain.GetItemString(1, 'invoice_no'))+ "' and sku ='"+ ldsDoPick.GetItemString(llRowPos, 'sku')+"'"
	lsFind += " and lot_no ='"+ldsDoPick.GetItemString(llRowPos, 'lot_no')+ "' and trans_line_no ='"+ string(ldsDoPick.GetItemNumber(llRowPos, 'line_item_no'))+"'"
	
	IF ldsGI.rowcount( ) > 0 Then 	llFindRow = ldsGI.find( lsFind, 1, ldsGI.rowcount())
	
	IF llFindRow > 0 Then
		ll_Pick_Qty = ldsGI.getItemNumber( llFindRow, 'quantity')
		ldsGI.SetItem(llFindRow, 'quantity', ldsDoPick.GetItemNumber(llRowPos, 'quantity') +ll_Pick_Qty)
	ELSE
		
		llNewRow = ldsGI.InsertRow(0)
		ldsGI.SetItem(llNewRow, 'trans_id', right(trim(ldsDOMain.GetItemString(1, 'do_no')) + string(ldTransID), 15)) // do_no for outbound + Trans_ID Sequence
		ldsGI.SetItem(llNewRow, 'trans_source_no', trim(ldsDOMain.GetItemString(1, 'invoice_no')))
		ldsGI.SetItem(llNewRow, 'trans_line_no', string(ldsDoPick.GetItemNumber(llRowPos, 'line_item_no')))
		
		ldsGI.SetItem(llNewRow, 'sku', ldsDoPick.GetItemString(llRowPos, 'sku'))
		ldsGI.SetItem(llNewRow, 'quantity', ldsDoPick.GetItemNumber(llRowPos, 'quantity'))
		ldsGI.SetItem(llNewRow, 'uom', ldsDoPick.GetItemString(llRowPos, 'uom')) //uom
		ldsGI.SetItem(llNewRow, 'lot_no', ldsDoPick.GetItemString(llRowPos, 'lot_no')) //lot No
		ldsGI.SetItem(llNewRow, 'customer_sku', ldsDoPick.GetItemString(llRowPos, 'customer_sku')) //customer sku
		
		ldsGI.SetItem(llNewRow, 'dd_user_line_item_no', ldsDoPick.GetItemString(llRowPos, 'User_Line_Item_No')) //user line item no
		ldsGI.SetItem(llNewRow, 'dd_client_cust_invoice', ldsDoPick.GetItemString(llRowPos, 'Client_Cust_Invoice')) //client cust invoice
		ldsGI.SetItem(llNewRow, 'dd_cust_line_nbr', ldsDoPick.GetItemString(llRowPos, 'Cust_Line_Nbr')) //cust line nbr
		ldsGI.SetItem(llNewRow, 'dd_user_field1', ldsDoPick.GetItemString(llRowPos, 'dd_user_field1')) //user field1
		ldsGI.SetItem(llNewRow, 'dd_user_field8', ldsDoPick.GetItemString(llRowPos, 'User_Field8')) //user field8
		
		ldsGI.SetItem( llNewRow, 'inventory_type', ldsDoPick.GetItemString(llRowPos, 'inventory_type'))  //GailM 2/14/2019 S31049 InvType

	END IF
	skipDetailRow:
Next /* Next Picking record */

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to PANDORA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

llRowCount = ldsGI.RowCount()
if llRowCount <= 0 then return 0

lsCarrier = ldsDOMain.GetItemString(1, 'carrier')

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Header Record for Do_No: ' + asdono +" and Change_Request_No: "+nz(string(ll_change_req_no),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


//1.Build and Write  Header Records
llNewRow = idsOMQWhDOMain.insertRow(0)
idsOMQWhDOMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQWhDOMain.setitem( 1, 'CLIENT_ID', ls_client_id)
idsOMQWhDOMain.setitem(1, 'SITE_ID', lsWH) //site id

idsOMQWhDOMain.setitem( 1, 'QACTION', 'U') //Action- U (Update)
idsOMQWhDOMain.setitem( 1, 'QSTATUS', 'NEW')
idsOMQWhDOMain.setitem( 1, 'QSTATUSDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'QSTATUSSOURCE', 'SIMSSWEEPER')
idsOMQWhDOMain.setitem( 1, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id

idsOMQWhDOMain.setitem( 1, 'ADDDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'ADDWHO', 'SIMSUSER')
idsOMQWhDOMain.setitem( 1, 'EDITDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'EDITWHO', 'SIMSUSER')

idsOMQWhDOMain.setitem( 1, 'ACTUALSHIPDATE', ldsDOMain.GetItemDateTime(1, 'complete_date'))
idsOMQWhDOMain.setitem(1, 'EXTERNORDERKEY', trim(ldsDOMain.GetItemString(1, 'invoice_no'))) //Invoice No
idsOMQWhDOMain.setitem(1, 'TYPE', trim(ldsDOMain.GetItemString(1, 'ord_type'))) //Type
idsOMQWhDOMain.setitem(1, 'ORDERKEY', Right(trim(upper(ldsDOMain.GetItemString(1, 'do_no'))),10)) //Order Key (Do No)
idsOMQWhDOMain.setitem(1, 'STATUS', 'SHIPPED') //Status - Complete (95)

idsOMQWhDOMain.setitem(1, 'CARRIERKEY', left(lsCarrier,10)) //Carrier Key
idsOMQWhDOMain.setitem(1, 'C_COMPANY', left(trim(ldsDOMain.GetItemString(1, 'cust_name')), 45)) //Customer Name
idsOMQWhDOMain.setitem(1, 'C_ADDRESS1', left(trim(ldsDOMain.GetItemString(1, 'address_1')), 45)) //Address1
idsOMQWhDOMain.setitem(1, 'C_ADDRESS2', left(trim(ldsDOMain.GetItemString(1, 'address_2')), 45)) //Address2
idsOMQWhDOMain.setitem(1, 'C_CITY', trim(ldsDOMain.GetItemString(1, 'city'))) //City
idsOMQWhDOMain.setitem(1, 'C_State', Left(trim(ldsDOMain.GetItemString(1, 'state')),2)) //State
idsOMQWhDOMain.setitem(1, 'C_ZIP', trim(ldsDOMain.GetItemString(1, 'zip'))) //Zip
idsOMQWhDOMain.setitem(1, 'C_COUNTRY', trim(ldsDOMain.GetItemString(1, 'country'))) //Country

idsOMQWhDOMain.setitem(1, 'BUYER_PO', trim(ldsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr
idsOMQWhDOMain.setitem(1, 'DELIVERYDATE2', ldsDOMain.GetItemDateTime(1, 'Freight_ETA')) //Freight_ETA
idsOMQWhDOMain.setitem(1, 'TRANSPORTATIONMODE', trim(ldsDOMain.GetItemString(1, 'Transport_Mode'))) //Transport_Mode

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. Write Detail Records into OMQ_Warehouse_Order_Detail Table
ll_Order_Line_No =0
llRowCount = ldsGI.RowCount()
For llRowPos = 1 to llRowCount
	ll_Order_Line_No++
	ll_detail_row =idsOMQWhDODetail.insertrow( 0)
	idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR',ll_change_req_no)
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'I') //Action- I (Insert)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
	idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', lsWH) //site id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')

	idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(ldsDOMain.GetItemString(1, 'invoice_no')))
	
	If IsNull(ll_change_req_no) Then
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', left(ldsGI.getitemstring( llRowPos, 'trans_line_no') ,5))
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', ldsGI.getitemstring( llRowPos, 'dd_user_line_item_no'))
	End If
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(upper(ldsDOMain.GetItemString(1, 'do_no'))),10))
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', string(ll_Order_Line_No, '00000'))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', ldsGI.getitemnumber( llRowPos, 'quantity'))
	idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', ldsGI.getitemnumber( llRowPos, 'quantity'))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', ldsGI.GetItemString(llRowPos, 'sku')) //sku
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERED_SKU_UOM', ldsGI.GetItemString(llRowPos, 'uom')) //uom
	idsOMQWhDODetail.setitem( ll_detail_row, 'LOTTABLE02', ldsGI.GetItemString(llRowPos, 'Lot_No')) //Lot No
	idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR2', ldsGI.GetItemString(llRowPos, 'Customer_SKU')) //Customer_SKU
	idsOMQWhDODetail.setitem( ll_detail_row, 'REFCHAR1', Trim(ldsGI.GetItemString(llRowPos, 'dd_user_field1')))
	
	ls_dd_uf8 = ldsGI.GetItemString(llRowPos, 'dd_user_field8')
	
	IF IsNull(ls_dd_uf8) or ls_dd_uf8 ='' or ls_dd_uf8 =' ' THEN
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', 'MAIN') //UF8
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', ls_dd_uf8) //UF8
	End IF
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_NBR', ldsGI.GetItemString(llRowPos, 'dd_client_cust_invoice')) //client cust invoice
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_LINENUMBER', ldsGI.GetItemString(llRowPos, 'dd_cust_line_nbr')) //cust line nbr
	idsOMQWhDODetail.setitem( ll_detail_row, 'STATUS', 'SHIPPED')
		
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+ldsGI.GetItemString(llRowPos, 'trans_line_no')
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
Next //Next Detail Record

//23-May-2018 :Madhu  S19513 - Rema-Substitution
//2 (a). Write  "Alloc Qty =0" detail records into OMQ_Warehouse_Order_Detail Table
ldsDoDetail.setfilter( "Alloc_Qty =0 ")
ldsDoDetail.filter( )
llRowCount = ldsDoDetail.rowcount( )

For llRowPos = 1 to llRowCount
	ll_Order_Line_No++
	ll_detail_row =idsOMQWhDODetail.insertrow( 0)
	idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR', ll_change_req_no)
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'I') //Action- I (Insert)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
	idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', lsWH) //site id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')

	idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(ldsDOMain.GetItemString(1, 'invoice_no')))
	idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', string(ldsDoDetail.getitemnumber( llRowPos, 'Line_Item_no')))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(upper(ldsDOMain.GetItemString(1, 'do_no'))),10))
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', string(ll_Order_Line_No, '00000'))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', ldsDoDetail.getitemnumber( llRowPos, 'Req_Qty'))
	idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', 0)
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', ldsDoDetail.GetItemString(llRowPos, 'sku')) //sku
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERED_SKU_UOM', ldsDoDetail.GetItemString(llRowPos, 'uom')) //uom
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR2', ldsDoDetail.GetItemString(llRowPos, 'Customer_Sku')) //Customer_SKU
	idsOMQWhDODetail.setitem( ll_detail_row, 'REFCHAR1', Trim(ldsDoDetail.GetItemString(llRowPos, 'User_Field1')))
	
	ls_dd_uf8 = ldsDoDetail.GetItemString(llRowPos, 'User_Field8')
	
	IF IsNull(ls_dd_uf8) or ls_dd_uf8 ='' or ls_dd_uf8 =' ' THEN
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', 'MAIN') //UF8
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', ls_dd_uf8) //UF8
	End IF
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_NBR', ldsDoDetail.GetItemString(llRowPos, 'Client_Cust_Invoice')) //client cust invoice
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_LINENUMBER', ldsDoDetail.GetItemString(llRowPos, 'Cust_Line_Nbr')) //cust line nbr
	idsOMQWhDODetail.setitem( ll_detail_row, 'STATUS', 'SHIPPED') //10-JULY-2018 DE5182 - change status to SHIPPED instead CANCELLED
		
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing (Alloc_Qty = 0 ) Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+string(ldsDoDetail.GetItemNumber(llRowPos, 'Line_Item_no'))
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
Next //Next Detail Record

//Remove filter
ldsDoDetail.setfilter( " ")
ldsDoDetail.filter( )

IF ldsGI.RowCount() = 0 THEN idsOMQWhDOMain.setitem(1, 'STATUS', 'CANCELLED') //Status - Cancelled

idsOMQWhDOMain.setitem(1, 'LINECOUNT', idsOMQWhDODetail.rowcount( )) //Order Detail count

//3. Write Packaging Information into OMQ_WAREHOUSE_ORDERATTR
llPackRowCount = ldsDoPack.RowCount()

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Building Package Information of uf_process_gi_om() for Do_No: ' + asdono + '  and Pack Row Count: '+ string(llPackRowCount)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

IF llPackRowCount > 0 Then
	//Shipment Measures Construct
	FOR ll_Pack_Row =1 to ldsDoPack.RowCount()
		ls_carton_No = upper(ldsDoPack.GetItemString(ll_Pack_Row, 'carton_no'))
	
		if ls_prev_carton_No <> ls_carton_No Then //don't sumup duplicate carton No.
			ld_total_weight += ldsDoPack.GetItemNumber(ll_Pack_Row, 'Weight_Gross')
		end if
	
		ls_prev_carton_No =ls_carton_No //store carton No into Previous value.
	Next
	
	ll_attr_row =idsOMQWhDOAttr.insertrow(0)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QACTION','U')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUS','NEW')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QSTATUSSOURCE','SIMSSWEEPER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'QWMQID',aitransid)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_ID', 'SHM1')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ATTR_TYPE','ShipmentMeasures') 
	idsOMQWhDOAttr.setitem(ll_attr_row, 'CLIENT_ID', long(ls_client_id))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'SITE_ID', lsWH)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ORDERKEY', Right(upper(asdono), 10))
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFCHAR1', 'LB')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'REFNUM1', ld_total_weight) //Total_Weight_Gross
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'ADDWHO','SIMSUSER')
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITDATE', ldtToday)
	idsOMQWhDOAttr.setitem(ll_attr_row, 'EDITWHO','SIMSUSER')
End IF

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;

If idsOMQWhDOMain.rowcount( ) > 0 Then 	ll_rc =idsOMQWhDOMain.update( false, false);		//OMQ_Warehouse_Order
If idsOMQWhDODetail.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQWhDODetail.update( false, false); //OMQ_Warehouse_OrderDetail
If idsOMQWhDOAttr.rowcount( ) > 0 and ll_rc =1 Then	ll_rc =idsOMQWhDOAttr.update( false, false); //OMQ_WAREHOUSE_ORDERATTR

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQWhDOMain.resetupdate( )
		idsOMQWhDODetail.resetupdate( )
		idsOMQWhDOAttr.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQWhDOMain.reset( )
		idsOMQWhDODetail.reset()
		idsOMQWhDOAttr.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//4. OMQ_Inventory_Transaction
ll_Order_Line_No =0
For llRowPos =1 to ldsGI.RowCount()
		lsFind = "Inv_Type = '" + ldsDoPick.GetItemString(llRowPos, "inventory_type") + "' "
		llFindRow = idsInvTypes.Find(lsFind, 1, idsInvTypes.RowCount())
		
		If llFindRow > 0 Then
			If idsInvTypes.GetItemString(llFindRow, "Inventory_Shippable_Ind") = "Y" Then 
				ll_Order_Line_No++
				ll_Inv_Row = idsOMQInvTran.insertrow(0)
				
				idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
				idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
				idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
				idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
				idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWH) //site id
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
			
				ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'OMQ_Inv_Tran', 'ITRNKey')
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
			
				idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'WD') //Tran Type as WD (Withdrawal)
				idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
				idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM',ldsGI.getitemstring(llRowPos ,'sku')) //DP.Sku
				idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', ldsGI.getitemstring(llRowPos ,'lot_no')) //DP.Lot_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (0 - ldsGI.GetItemNumber(llRowPos,'quantity'))) //Quantity
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(trim(ldsDOMain.GetItemString(1, 'invoice_no')),10)) //DM.Invoice_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', ldsGI.GetItemString(llRowPos,'trans_line_no')) //DP.Line_Item_No
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', Right(trim(ldsDOMain.GetItemString(1, 'do_no')),10) + string (ll_Order_Line_No ,'00000')) //Do_No + Order Line No
				idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'PICKING') //Picking
			End If
		Else
			lsLogOut = "                  *** Unable to find inventory type: " +  ldsDoPick.GetItemString(llRowPos, "inventory_type") + ".  OMQ Inv Tran not created."
			FileWrite(gilogFileNo,lsLogOut)
			Return -1
		End If
	
Next

//OMQ_Inventory_Transaction
Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then
	ll_rc =idsOMQInvTran.update( false, false);
End IF

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " +  "System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processed Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code: " + string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsGI
destroy ldsDOMain
destroy ldsDODetail
destroy ldsDoPick
destroy ldsDoPack

destroy idsOMQWhDOMain
destroy idsOMQWhDODetail
destroy idsOMQWhDOAttr
destroy idsOMQInvTran


gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM

Return ll_return_code
end function

public function integer uf_process_om_warehouse_order (string asdono, long aitransid);//21-Feb-2018 :Madhu  S15410 -EDI -940 -Outbound Order Acknowledgement
//Write records back into OMQ Warehouse OrderTables for Manual Orders

DataStore ldsDOAddress, ldsDOHeader, ldsOMQDelivery
String		lsLogOut, ls_status_cd, lsWh, lsFind, ls_client_id, lsInvoice, ls_line_Item_No
Long		llFindRow,	llNewRow, llNewDetailRow, ll_row,  ll_detail_row
Long 		ll_change_req_no, ll_rc

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

If Not isvalid(ldsDOAddress) Then
	ldsDOAddress = Create u_ds_datastore
	ldsDOAddress.dataobject = 'd_do_address' //Delivery_Alt_Address
	ldsDOAddress.SetTransObject(SQLCA)
End If

If Not isvalid(ldsOMQDelivery) Then
	ldsOMQDelivery =Create u_ds_datastore
	ldsOMQDelivery.Dataobject ='d_omq_warehouse_order'
	ldsOMQDelivery.settransobject(om_sqlca)
End If

ldsOMQDelivery.reset()

//Retrieve the Deliver Header records for this order
If ldsDOHeader.Retrieve(asdono) <> 1 Then
	lsLogOut = "                  *** Unable to retrieve Delivery Order Header For DONO: " + asdono
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsWh = ldsDOHeader.GetItemString(1, 'wh_code')
lsInvoice = ldsDOHeader.GetItemString(1, 'Invoice_no')
ll_change_req_no = ldsDOHeader.GetItemNumber(1, 'OM_CHANGE_REQUEST_NBR')

//1. ADD OMQ_DELIVERY Tables
llNewRow =	ldsOMQDelivery.insertrow( 0)
	
ldsOMQDelivery.setitem(llNewRow,'CHANGE_REQUEST_NBR',ll_change_req_no)
ldsOMQDelivery.setitem(llNewRow,'CLIENT_ID',ls_client_id)
ldsOMQDelivery.setitem(llNewRow, 'QACTION', 'I') //Action
ldsOMQDelivery.setitem(llNewRow, 'QSTATUS', 'NEW') //QStatus
ldsOMQDelivery.setitem(llNewRow, 'STATUS', 'RELEASED') //Status
ldsOMQDelivery.setitem(llNewRow, 'QWMQID', aitransid) //Set with Batch_Transaction.Trans_Id
ldsOMQDelivery.setitem(llNewRow, 'ORDERKEY', Right(upper(asdono),10)) //Do No
ldsOMQDelivery.setitem(llNewRow, 'SITE_ID',  lsWh) //site id
ldsOMQDelivery.setitem(llNewRow, 'ADDDATE', ldtToday) //add_date
ldsOMQDelivery.setitem(llNewRow, 'ADDWHO', 'SIMSUSER') //add_who
ldsOMQDelivery.setitem( llNewRow, 'EDITDATE', ldtToday) //Edit Date
ldsOMQDelivery.setitem( llNewRow, 'EDITWHO', 'SIMSUSER') //Edit Who

//Load Records from Delivery Master	
ldsOMQDelivery.SetItem(llNewRow, 'C_COMPANY', ldsDOHeader.GetItemString(1,'Cust_Name'))
ldsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS1', ldsDOHeader.GetItemString(1,'Address_1'))
ldsOMQDelivery.SetItem(llNewRow, 'C_ADDRESS2', ldsDOHeader.GetItemString(1,'Address_2'))
ldsOMQDelivery.SetItem(llNewRow, 'C_ZIP', ldsDOHeader.GetItemString(1,'zip'))
ldsOMQDelivery.SetItem(llNewRow, 'C_CITY', ldsDOHeader.GetItemString(1,'City'))
ldsOMQDelivery.SetItem(llNewRow, 'C_STATE', ldsDOHeader.GetItemString(1,'State'))
ldsOMQDelivery.SetItem(llNewRow, 'C_COUNTRY', ldsDOHeader.GetItemString(1,'Country'))

ldsOMQDelivery.SetItem(llNewRow, 'BUYER_PO', ldsDOHeader.GetItemString(1,'client_cust_po_nbr'))
ldsOMQDelivery.SetItem(llNewRow, 'NOTES', ldsDOHeader.GetItemString(1, 'remark'))
ldsOMQDelivery.SetItem(llNewRow, 'TYPE', 'S')

ldsOMQDelivery.SetItem(llNewRow, 'FREIGHTPAYMENTTERMS',  ldsDOHeader.GetItemString(1,'Freight_Terms'))
ldsOMQDelivery.setitem( llNewRow, 'EXTERNORDERKEY', ldsDOHeader.GetItemString(1, 'Invoice_no')) //supp_invoice_no
ldsOMQDelivery.setitem( llNewRow, 'SUSR3', ldsDOHeader.GetItemString(1, 'Client_Cust_Po_Nbr')) 
ldsOMQDelivery.setitem( llNewRow, 'DELIVERYDATE2', ldsDOHeader.GetItemDateTime(1, 'Schedule_Date')) 

//Get SHIP_FROM from Delivery Alt address
ldsDOAddress.Retrieve(asdono)
lsFind ="address_type ='ST'"
llFindRow =ldsDOAddress.find(lsFind,1,ldsDOAddress.rowcount())

If llfindRow > 0 Then
	ldsOMQDelivery.SetItem(llNewRow,'B_COMPANY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Name'))) 
	ldsOMQDelivery.SetItem(llNewRow,'B_ADDRESS1',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_1'))) 
	ldsOMQDelivery.SetItem(llNewRow,'B_ADDRESS2',Trim(ldsDOAddress.GetItemString(llfindRow, 'Address_2'))) 
	ldsOMQDelivery.SetItem(llNewRow,'B_CITY',Trim(ldsDOAddress.GetItemString(llfindRow, 'City')))
	ldsOMQDelivery.SetItem(llNewRow,'B_STATE',Trim(ldsDOAddress.GetItemString(llfindRow, 'State')))
	ldsOMQDelivery.SetItem(llNewRow,'B_ZIP',Trim(ldsDOAddress.GetItemString(llfindRow, 'Zip'))) 
	ldsOMQDelivery.SetItem(llNewRow,'B_COUNTRY',Trim(ldsDOAddress.GetItemString(llfindRow, 'Country')))
End if
	
//Write to File and Screen
lsLogOut = '      - OM Outbound 940C- Processed Header Record for Do_No: ' + asdono +" and Change_Request_No: "+nz(string(ll_change_req_no),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

	
//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;
If ldsOMQDelivery.rowcount( ) > 0  Then ll_rc =ldsOMQDelivery.update( false, false);

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		ldsOMQDelivery.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		ldsOMQDelivery.reset( )
		//Write to Log File and Screen
		lsLogOut = "      - OM Outbound 940C- Unable to Save new SO Records to database .!~r~r" + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)

		Return -1
	end if

else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to Log File and Screen
	lsLogOut = "      - OM Outbound 940C- System error, record save failed! .!~r~r" + om_sqlca.SQLErrText
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

destroy ldsDOHeader
destroy ldsDOAddress
destroy ldsOMQDelivery

//Write to File and Screen
lsLogOut = '      - OM 940 Acknowledgement- End Processing of uf_process_om_warehouse_order: ' 
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0

end function

public function integer uf_process_om_adjustment (string asproject, long aladjustid, long altransid);//05-APR-2018 :Madhu S17944 - (947) Stock Adjustment

long		llOldQty, llNewQty, llAdjustID, ll_Inv_Row, llRC, llOldOwnerId, llNewOwnerId
string	 	lsSKU, lsWhcode, lsRONO, lsOldPoNo, lsNewPoNo, lsOldOwner_Cd, lsNewOwner_Cd, ls_client_id, lsLogOut, ls_om_enabled, lsAdjType
string		lsOldLotNo, lsNewLotNo
decimal	ldOMQ_Inv_Tran
boolean  lbIncrementTrans, lbDecrementTrans, lbQtyTrans
datetime ldtToday
long		ll_Inv_Types	, llFindRow					//GailM 3/14/2019
string		lsOldInvType, lsNewInvType, lsOldAllocatable, lsNewAllocatable, lsFind

Datastore ldsAdjustment

ldtToday = DateTime(Today(), Now())

//Write to File and Screen
lsLogOut = '      - OM Adjustment- Start Processing of uf_process_om_adjustment() for AdjustId: ' + string(alAdjustID)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)
	
gu_nvo_process_files.uf_connect_to_om( asproject) //connect to OT29 DB.

If Not isvalid(ldsAdjustment) Then
	ldsAdjustment = Create Datastore
	ldsAdjustment.Dataobject = 'd_adjustment'
	ldsAdjustment.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQInvTran) Then
	idsOMQInvTran = Create u_ds_datastore
	idsOMQInvTran.Dataobject = 'd_omq_inventory_transaction'
	idsOMQInvTran.SetTransObject(om_sqlca)
End If

//Retreive the adjustment record
If ldsAdjustment.Retrieve(asProject, alAdjustID) <= 0 Then
	lsLogOut = "        *** Unable to retreive Adjustment Record for AdjustID: " + String(alAdjustID)
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

If Not isvalid(idsInvTypes) Then
	idsInvTypes = Create Datastore
	idsInvTypes.Dataobject = 'd_inventory_types'
End If
idsInvTypes.SetTransObject(SQLCA)

//GailM 03/14/2019 S31049 F13036 I1917 Rema Order Manager inventory types
ll_Inv_Types = idsInvTypes.Retrieve(asProject)

select OM_Client_Id into :ls_client_id from Project with(nolock) where Project_Id=:asproject using sqlca;

//Original values are coming from the field being retrieved twice instead of getting it from the original buffer since Copyrow (used in Split) has no original values
lsroNO = ldsAdjustment.GetITemString(1,'ro_no')

lsSku = ldsAdjustment.GetITemString(1,'sku')
lsWhcode =ldsAdjustment.getItemString(1,'wh_code')
lsAdjType= ldsAdjustment.getItemString( 1, 'Adjustment_Type')

lsOldOwner_Cd = ldsAdjustment.getItemString(1,'old_owner_cd')
lsOldPoNo = ldsAdjustment.getitemstring(1, 'old_po_no')
lsOldLotNo = ldsAdjustment.getitemstring(1, 'old_lot_no')
llOldQty = ldsAdjustment.GetITemNumber(1,'old_quantity')
llOldOwnerId = ldsAdjustment.GetITemNumber(1,'old_owner')

llNewOwnerId = ldsAdjustment.GetITemNumber(1,'owner_Id')
lsNewOwner_Cd = ldsAdjustment.getItemString(1,'new_owner_cd')
lsNewPoNo = ldsAdjustment.getitemstring(1, 'po_no')
lsNewLotNo = ldsAdjustment.getitemstring(1, 'lot_no')
llNewQty = ldsAdjustment.GetITemNumber(1,'quantity')

lsOldInvType = ldsAdjustment.GetITemString(1,'old_inventory_type')
lsNewInvType = ldsAdjustment.GetITemString(1,'inventory_type')

//GailM 03/14/2019 S31049 F13036 I1917 Rema Order Manager inventory types
lsFind = "Inv_Type = '" + lsOldInvType + "' "
llFindRow = idsInvTypes.Find(lsFind, 1, idsInvTypes.RowCount())
If llFindRow > 0 Then
	lsOldAllocatable = idsInvTypes.GetItemString(llFindRow, "Inventory_Shippable_Ind")
End If
lsFind = "Inv_Type = '" + lsNewInvType + "' "
llFindRow = idsInvTypes.Find(lsFind, 1, idsInvTypes.RowCount())
If llFindRow > 0 Then
	lsNewAllocatable = idsInvTypes.GetItemString(llFindRow, "Inventory_Shippable_Ind")
End If

llAdjustID = ldsAdjustment.GetITemNumber(1,'adjust_no')

select OM_Enabled_Ind into :ls_om_enabled from Warehouse with(nolock) where wh_code =:lsWhcode using sqlca;

If upper(ls_om_enabled) <> 'Y' Then
	//Write to File and Screen
	lsLogOut = '      - OM Adjustment- Processing of uf_process_om_adjustment() for AdjustId: ' + string(alAdjustID) + ' Warehouse: '+lsWhcode+' is not enabled for OM'
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If

//Initialize variables
lbIncrementTrans =FALSE 
lbDecrementTrans = FALSE
lbQtyTrans =FALSE

//Adjustment Transaction criteria
IF  ((llNewQty <> lloldQty)  and upper(lsAdjType) = 'Q' ) Then //Qty changes 
	lbQtyTrans =TRUE	
elseif (upper(lsAdjType) = 'I') Then		//GailM S31049 If inv type change and qty changes 
	If lsOldAllocatable = 'Y' Then
		lbDecrementTrans = TRUE
	End If
	If lsNewAllocatable = 'Y' Then
		lbIncrementTrans = TRUE
	End If
elseIf (lsNewLotNo <> lsOldLotNo) Then //Lot No change
	lbIncrementTrans =FALSE //13-Dec-2018 :Madhu DE7688 changed from TRUE to FALSE
	lbDecrementTrans = FALSE //13-Dec-2018 :Madhu DE7688 changed from TRUE to FALSE
else
	//Write to File and Screen
	lsLogOut = '      - OM Adjustment - Processing of uf_process_om_adjustment() for AdjustId: ' + string(alAdjustID) +"  is neither QTY Adjustment nor Lot No change! "
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End IF

//Write records into OMQ_Inventory_Transaction Table

//Decrement Adjustment Record	
If (lbDecrementTrans = TRUE) Then
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	If llNewQty = llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - llOldQty) //Adjustment.Old_Qty
	elseIf llOldQty > llNewQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - (llOldQty - llNewQty)) //Adjustment.Old_Qty - Adjustment.Qty
	elseIf llNewQty > llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', 0 - (llNewQty - llOldQty)) //Adjustment.Old_Qty - Adjustment.Qty
	End If
	
	//12-Dec-2018 :Madhu DE7688 change Trantype from WD to AJ
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Withdrawl)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01', lsOldOwner_Cd) //Adjustment.Old_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', lsOldLotNo) //Adjustment.Old_Lot_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsOldPoNo) //Adjustment.Old_Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjustment Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', string(aladjustid)) //Adjustment.Adjustment Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
End If

//Increment Adjustment Record
If (lbIncrementTrans = TRUE) Then
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', today()) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	If llNewQty = llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llNewQty) //Adjustment.Qty
	elseIf llOldQty > llNewQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (llOldQty - llNewQty)) //Adjustment.Old_Qty - Adjustment.Qty
	elseIf llNewQty > llOldQty Then
		idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', (llNewQty - llOldQty)) //Adjustment.Qty - Adjustment.Old_Qty
	End If
	
	//12-Dec-2018 :Madhu DE7688 change Trantype from DP to AJ
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Deposit)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwner_Cd) //Adjustment.New_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02',lsNewLotNo) //Adjustment.New_Lot_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsNewPoNo) //Adjustment.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	
End If

//Qty change Adjustment Record
If (lbQtyTrans =TRUE) and (lsNewAllocatable = "Y") Then		//GailM S31049 must be allocatable
	ll_Inv_Row = idsOMQInvTran.insertrow(0)
	
	idsOMQInvTran.setitem( ll_Inv_Row,'CLIENT_ID',ls_client_id)
	idsOMQInvTran.setitem( ll_Inv_Row, 'QACTION', 'I') //Action
	idsOMQInvTran.setitem( ll_Inv_Row, 'QADDWHO', 'SIMSUSER') //Add Who
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUS', 'NEW') //Status
	idsOMQInvTran.setitem( ll_Inv_Row, 'QSTATUSSOURCE', 'SIMSSWEEPER') //Status Source
	idsOMQInvTran.setitem( ll_Inv_Row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SITE_ID', lsWhcode) //site id
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ADDWHO', 'SIMSUSER') //Add who
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITDATE', ldtToday) //Add Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'EDITWHO', 'SIMSUSER') //Add who
	
	
	ldOMQ_Inv_Tran = gu_nvo_process_files.uf_get_next_seq_no(asProject, 'OMQ_Inv_Tran', 'ITRNKey')
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITRNKEY', string(ldOMQ_Inv_Tran)) //ITRNKey
	
	idsOMQInvTran.setitem( ll_Inv_Row, 'TRANTYPE', 'AJ') //Tran Type as AJ (Adjustment)
	idsOMQInvTran.setitem( ll_Inv_Row, 'EFFECTIVEDATE', ldtToday) //Effective Date
	idsOMQInvTran.setitem( ll_Inv_Row, 'ITEM', lsSku) //Adjustment.Sku
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE01',lsNewOwner_Cd) //Adjustment.New_Owner_Cd
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE02', lsNewLotNo) //Adjustment.New_Lot_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'LOTTABLE03', lsNewPoNo) //Adjustment.Po_No
	idsOMQInvTran.setitem( ll_Inv_Row, 'QTY', llNewQty - llOldQty) //Adjustment.Qty - Adjustment.Old_Qty
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTKEY', Right(string(aladjustid),10)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'RECEIPTLINENUMBER', '0')
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCEKEY', string(aladjustid)) //Adjustment.Adjust_Id
	idsOMQInvTran.setitem( ll_Inv_Row, 'SOURCETYPE', 'ADJUSTMENT') //Adjustment
	idsOMQInvTran.setitem( ll_Inv_Row, 'REASONCODE', 'CYCLE') //Reason code
End If

Execute Immediate "Begin Transaction" using om_sqlca;
If idsOMQInvTran.rowcount( ) > 0 Then
	llRC =idsOMQInvTran.update( false, false);
End IF

If llRC =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQInvTran.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQInvTran.reset( )
		
		//Write to File and Screen
		lsLogOut = '      - OM Adjustment - Processing of uf_process_om_adjustment() for AdjustId: ' + string(alAdjustID) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Adjustment - Processing of uf_process_om_adjustment() for AdjustId: ' + string(alAdjustID) +"  is failed to write/update OM Tables: " + om_sqlca.SQLErrText +  "System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If


destroy idsOMQInvTran
gu_nvo_process_files.uf_disconnect_from_om() //Disconnect from OM.

Return 0
end function

public function integer uf_process_gi_void_om (string asproject, string asdono, long altransid);//03-MAY-2018 :Madhu S18653 - REMA 945 Void Ship confirmation
//Write records back into OMQ Tables

String		lsLogOut, lsWH, lsOrdType,  ls_client_id
String 	ls_wh_name, ls_addr1, ls_addr2, ls_addr3, ls_addr4, ls_city, ls_state, ls_zip, ls_country, ls_tel, ls_fax, ls_contact, ls_email
String		ls_gmt_offset, lsCarrier, ls_dd_uf8

Long		llRowPos, llRowCount, llNewRow, ll_return_code
Long 		ll_change_req_no, ll_batch_seq_no, ll_rc, ll_detail_row, ll_Order_Line_No

Decimal		ldBatchSeq, ldTransID
DateTime 	 ldtToday

ldtToday = DateTime(Today(), Now())

Datastore ldsDOMain, ldsDoDetail

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Start Processing of uf_process_gi_void_om() for Do_No: ' + asdono
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

gu_nvo_process_files.uf_connect_to_om( upper(asProject)) //connect to OP39 DB.

If Not isvalid(ldsDOMain) Then
	ldsDOMain = Create u_ds_datastore
	ldsDOMain.Dataobject = 'd_do_master'
	ldsDOMain.SetTransObject(SQLCA)
End If
	
If Not isvalid(ldsDoDetail) Then
	ldsDoDetail = Create u_ds_datastore
	ldsDoDetail.Dataobject = 'd_do_Detail'
	ldsDoDetail.SetTransObject(SQLCA)
End If

If Not isvalid(idsOMQWhDOMain) Then
	idsOMQWhDOMain =create u_ds_datastore
	idsOMQWhDOMain.Dataobject ='d_omq_warehouse_order'
End If
idsOMQWhDOMain.settransobject(om_sqlca)

If Not isvalid(idsOMQWhDODetail) Then
	idsOMQWhDODetail =create u_ds_datastore
	idsOMQWhDODetail.Dataobject ='d_omq_warehouse_order_detail'
End If
idsOMQWhDODetail.settransobject(om_sqlca)


idsOMQWhDOMain.reset()
idsOMQWhDODetail.reset()

lsLogOut = "      OM Outbound Confirmation -Creating Void Transaction (GI) For DO_NO: " + asDONO
FileWrite(gilogFileNo,lsLogOut)

If ldsDOMain.Retrieve(asDoNo) <> 1 Then
	lsLogOut = "        *** Unable to retrieve Delivery Order Header For DONO: " + asDONO
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

w_main.SetMicroHelp("Processing Purchase Order (EDI - OM)")

lsOrdType = NoNull(ldsDOMain.GetItemString(1, 'ord_type'))
lsWH = ldsDOMain.GetItemString(1, 'wh_code')
ll_change_req_no = ldsDOMain.getitemnumber(1,'OM_CHANGE_REQUEST_NBR')
ll_batch_seq_no =ldsDOMain.getitemnumber(1,'EDI_Batch_Seq_No')

select OM_Client_Id into :ls_client_id
from Project with(nolock)
where Project_Id= :asproject
using sqlca;

select wh_name, Address_1, Address_2, Address_3, Address_4, City, State, Zip, Country, Tel, Fax, Contact_Person, Email_Address, GMT_Offset
into :ls_wh_name, :ls_addr1, :ls_addr2, :ls_addr3, :ls_addr4, :ls_city, :ls_state, :ls_zip, :ls_country, :ls_tel, :ls_fax, :ls_contact, :ls_email, :ls_gmt_offset
from Warehouse with(nolock)
where wh_Code=:lsWH
using sqlca;


// 03/09 - Get the next available Trans_ID sequence number 
ldTransID = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'Transactions', 'Trans_ID')
If ldTransID <= 0 Then Return -1

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(upper(asProject), 'EDI_Generic_Outbound', 'EDI_Batch_Seq_No')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor (Outbound) Inventory Transfer Confirmation.~r~rConfirmation will not be sent to REMA!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

lsCarrier = ldsDOMain.GetItemString(1, 'carrier')

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Header Record for Do_No: ' + asdono +" and Change_Request_No: "+nz(string(ll_change_req_no),'-')
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)


//1.Build and Write  Header Records
llNewRow = idsOMQWhDOMain.insertRow(0)
idsOMQWhDOMain.setitem(1,'CHANGE_REQUEST_NBR',ll_change_req_no)
idsOMQWhDOMain.setitem( 1, 'CLIENT_ID', ls_client_id)
idsOMQWhDOMain.setitem(1, 'SITE_ID', lsWH) //site id

idsOMQWhDOMain.setitem( 1, 'QACTION', 'U') //Action- U (Update)
idsOMQWhDOMain.setitem( 1, 'QSTATUS', 'NEW')
idsOMQWhDOMain.setitem( 1, 'QSTATUSDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'QSTATUSSOURCE', 'SIMSSWEEPER')
idsOMQWhDOMain.setitem( 1, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id

idsOMQWhDOMain.setitem( 1, 'ADDDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'ADDWHO', 'SIMSUSER')
idsOMQWhDOMain.setitem( 1, 'EDITDATE', ldtToday)
idsOMQWhDOMain.setitem( 1, 'EDITWHO', 'SIMSUSER')

idsOMQWhDOMain.setitem( 1, 'ACTUALSHIPDATE', ldsDOMain.GetItemDateTime(1, 'complete_date'))
idsOMQWhDOMain.setitem(1, 'EXTERNORDERKEY', trim(ldsDOMain.GetItemString(1, 'invoice_no'))) //Invoice No
idsOMQWhDOMain.setitem(1, 'TYPE', trim(ldsDOMain.GetItemString(1, 'ord_type'))) //Type
idsOMQWhDOMain.setitem(1, 'ORDERKEY', Right(trim(upper(ldsDOMain.GetItemString(1, 'do_no'))),10)) //Order Key (Do No)
idsOMQWhDOMain.setitem(1, 'STATUS', 'CANCELLED') //Status - Cancelled

idsOMQWhDOMain.setitem(1, 'CARRIERKEY', left(lsCarrier,10)) //Carrier Key
idsOMQWhDOMain.setitem(1, 'C_COMPANY', left(trim(ldsDOMain.GetItemString(1, 'cust_name')), 45)) //Customer Name
idsOMQWhDOMain.setitem(1, 'C_ADDRESS1', left(trim(ldsDOMain.GetItemString(1, 'address_1')), 45)) //Address1
idsOMQWhDOMain.setitem(1, 'C_ADDRESS2', left(trim(ldsDOMain.GetItemString(1, 'address_2')), 45)) //Address2
idsOMQWhDOMain.setitem(1, 'C_CITY', trim(ldsDOMain.GetItemString(1, 'city'))) //City
idsOMQWhDOMain.setitem(1, 'C_State', Left(trim(ldsDOMain.GetItemString(1, 'state')),2)) //State
idsOMQWhDOMain.setitem(1, 'C_ZIP', trim(ldsDOMain.GetItemString(1, 'zip'))) //Zip
idsOMQWhDOMain.setitem(1, 'C_COUNTRY', trim(ldsDOMain.GetItemString(1, 'country'))) //Country

idsOMQWhDOMain.setitem(1, 'BUYER_PO', trim(ldsDOMain.GetItemString(1, 'client_cust_po_nbr'))) //Client Cust PO Nbr
idsOMQWhDOMain.setitem(1, 'DELIVERYDATE2', ldsDOMain.GetItemDateTime(1, 'Freight_ETA')) //Freight_ETA
idsOMQWhDOMain.setitem(1, 'TRANSPORTATIONMODE', trim(ldsDOMain.GetItemString(1, 'Transport_Mode'))) //Transport_Mode

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

//2. Write Detail Records into OMQ_Warehouse_Order_Detail Table
ll_Order_Line_No =0
llRowCount = ldsDoDetail.Retrieve(asDoNo)
For llRowPos = 1 to llRowCount
	ll_Order_Line_No++
	ll_detail_row =idsOMQWhDODetail.insertrow( 0)
	idsOMQWhDODetail.setitem( ll_detail_row, 'CHANGE_REQUEST_NBR',ll_change_req_no)
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'QACTION', 'I') //Action- I (Insert)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUS', 'NEW')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'QSTATUSSOURCE', 'SIMSSWEEPER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'QWMQID', altransid) //Set with Batch_Transaction.Trans_Id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'CLIENT_ID', ls_client_id)
	idsOMQWhDODetail.setitem(ll_detail_row, 'SITE_ID', lsWH) //site id
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'ADDWHO', 'SIMSUSER')
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITDATE', ldtToday)
	idsOMQWhDODetail.setitem( ll_detail_row, 'EDITWHO', 'SIMSUSER')

	idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNORDERKEY', trim(ldsDOMain.GetItemString(1, 'invoice_no')))
	idsOMQWhDODetail.setitem( ll_detail_row, 'EXTERNLINENO', string(ldsDoDetail.getitemnumber( llRowPos, 'Line_Item_no')))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERKEY', Right(trim(upper(ldsDOMain.GetItemString(1, 'do_no'))),10))
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERLINENUMBER', string(ll_Order_Line_No, '00000'))
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORIGINALQTY', ldsDoDetail.getitemnumber( llRowPos, 'Req_Qty'))
	idsOMQWhDODetail.setitem( ll_detail_row, 'SHIPPEDQTY', 0)
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'ITEM', ldsDoDetail.GetItemString(llRowPos, 'sku')) //sku
	idsOMQWhDODetail.setitem( ll_detail_row, 'ORDERED_SKU_UOM', ldsDoDetail.GetItemString(llRowPos, 'uom')) //uom
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'SUSR2', ldsDoDetail.GetItemString(llRowPos, 'Customer_Sku')) //Customer_SKU
	idsOMQWhDODetail.setitem( ll_detail_row, 'REFCHAR1', Trim(ldsDoDetail.GetItemString(llRowPos, 'User_Field1')))
	
	ls_dd_uf8 = ldsDoDetail.GetItemString(llRowPos, 'User_Field8')
	
	IF IsNull(ls_dd_uf8) or ls_dd_uf8 ='' or ls_dd_uf8 =' ' THEN
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', 'MAIN') //UF8
	else
		idsOMQWhDODetail.setitem( ll_detail_row, 'INVACCOUNT', ls_dd_uf8) //UF8
	End IF
	
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_NBR', ldsDoDetail.GetItemString(llRowPos, 'Client_Cust_Invoice')) //client cust invoice
	idsOMQWhDODetail.setitem( ll_detail_row, 'NB_ORDER_LINENUMBER', ldsDoDetail.GetItemString(llRowPos, 'Cust_Line_Nbr')) //cust line nbr
	idsOMQWhDODetail.setitem( ll_detail_row, 'STATUS', 'CANCELLED')
		
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" and Line_Item_No: "+string(ldsDoDetail.GetItemNumber(llRowPos, 'Line_Item_no'))
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
Next //Next Detail Record

idsOMQWhDOMain.setitem(1, 'LINECOUNT', llRowCount) //Order Detail count

//storing into DB
Execute Immediate "Begin Transaction" using om_sqlca;

If idsOMQWhDOMain.rowcount( ) > 0 Then 	ll_rc =idsOMQWhDOMain.update( false, false);		//OMQ_Warehouse_Order
If idsOMQWhDODetail.rowcount( ) > 0 and ll_rc =1 Then ll_rc =idsOMQWhDODetail.update( false, false); //OMQ_Warehouse_OrderDetail

If ll_rc =1 Then
	Execute Immediate "COMMIT" using om_sqlca;

	if om_sqlca.sqlcode = 0 then
		idsOMQWhDOMain.resetupdate( )
		idsOMQWhDODetail.resetupdate( )
	else
		Execute Immediate "ROLLBACK" using om_sqlca;
		idsOMQWhDOMain.reset( )
		idsOMQWhDODetail.reset()
		
		//Write to File and Screen
		lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables: " + om_sqlca.SQLErrText
		FileWrite(giLogFileNo,lsLogOut)
		gu_nvo_process_files.uf_write_log(lsLogOut)
		Return -1
	end if
else
	Execute Immediate "ROLLBACK" using om_sqlca;
	//Write to File and Screen
	lsLogOut = '      - OM Outbound Confirmation- Processing Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) +" is failed to write/update OM Tables:   System error, record save failed!"
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	Return -1
End If


ll_return_code = om_sqlca.sqlcode

//Write to File and Screen
lsLogOut = '      - OM Outbound Confirmation- Processed Detail Record for Do_No: ' + asdono +" and Change_Request_No: "+string(ll_change_req_no) + " OM SQL Return Code: " + string(ll_return_code)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

destroy ldsDOMain
destroy ldsDODetail

destroy idsOMQWhDOMain
destroy idsOMQWhDODetail


gu_nvo_process_files.uf_disconnect_from_om( ) //disconnect from OM

Return ll_return_code
end function

public function integer uf_gi (string asproject, string asdono);//Prepare a Goods Issue Transaction for Rema for the order that was just confirmed

Long			llRowPos, llRowCount, llFindRow, llNewRow, llLineItemNo, llBatchSeq, llDetailFind, ll_gi_count
String		lsOutString,	lsMessage, lsLogOut, lsFileName, lsTemp, lssku, lsSuppCode, lsLineItemNo, lsOrdStatus, lsGLN, lswh_code
DEcimal		ldBatchSeq
Integer		liRC


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

// Skip if not specific customers
//11-JULY-2018 :Madhu DE5196 - If Cust Name is contains 'SWS' then generate GI else NO.
//If  idsdoMain.GetItemString(1,'Cust_Name') <> 'SWS TX' and  idsdoMain.GetItemString(1,'Cust_Name') <> 'SWS IN'  Then Return 0
If Pos(idsdoMain.GetItemString(1,'Cust_Name') ,'SWS') = 0 Then Return 0

//Get the GLN
lsWh_Code = idsdoMain.GetITemString(1,'Wh_Code') 
SELECT dbo.Warehouse.User_Field1   INTO :lsGLN  FROM dbo.Warehouse  WHERE dbo.Warehouse.WH_Code = :lswh_code   ;

idsDoDetail.Retrieve(asDoNo)

idsDoPack.Retrieve(asDoNo)

//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar

// Write a header record
llNewRow = idsOut.insertRow(0)
lsOutString = 'Date' + lsDelimitChar + 'SSCC' + lsDelimitChar + 'GLN (ship from)' + lsDelimitChar + 'GLN Extension (ship from)' + lsDelimitChar + 'Destination GLN' + lsDelimitChar + 'Destination GLN Extension' + lsDelimitChar + 'GTIN' + lsDelimitChar + 'Product Lot' + lsDelimitChar + 'Product Serial Number' + lsDelimitChar + 'Product Quantity Units' + lsDelimitChar + 'Product Quantity Amount' + lsDelimitChar + 'poNumber' + lsDelimitChar + 'packDate' + lsDelimitChar + 'useThruDate' + lsDelimitChar + 'expirationDate' + lsDelimitChar + 'productionDate' + lsDelimitChar + 'bestBeforeDate' + lsDelimitChar + 'poNumber2'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.csv'
idsOut.SetItem(llNewRow,'file_name', lsFileName)
 

llRowCount = idsDoPack.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)


	lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())

	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
	End If

	//Complete Date	Date	No	N/A	
	lsTemp = String( idsdoMain.GetITemDateTime(1,'Complete_Date'),'mm/dd/yyyy') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString = lsTemp+ lsDelimitChar	

	//Pack SSCC	N(6,0)	Yes	N/A	
	lsTemp = right(String(idsdoPack.GetITemString(llRowPos, 'Pack_SSCC_No')),18) //Get right 18 
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//tam TODO
	//GLN - HARDCODED (TBD)
	lsOutString += lsGLN + lsDelimitChar	

	//GLN EXTENSION - BLANK
	lsOutString += lsDelimitChar	

	//Destination GLN - 
	lsTemp = idsdoMain.GetItemString(1,'user_Field2') 		
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//GLN EXTENSION - BLANK
	lsOutString += lsDelimitChar	

	//Detail GTIN	
	lsTemp = idsdoDetail.GetItemString(llDetailFind,'GTIN')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//Lot Number		
	lsTemp = idsdoPack.GetItemString(llRowPos,'Pack_Lot_No')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//SERIAL NO - BLANK
	lsOutString += lsDelimitChar	
 
	//UOM - "Cases'
	lsOutString += 'Cases' + lsDelimitChar	

	//Pack Quantity
	lsTemp = String(idsdoPack.GetItemDecimal(llRowPos, "Quantity"),'#####0')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//client_cust_po_nbr		
	lsTemp = idsdoMain.GetItemString(1,'client_cust_po_nbr') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//Pack Date - BLANK
	lsOutString += lsDelimitChar	
 
	//Use Thru Date		
	lsTemp = String( idsdoPack.GetITemDateTime(llRowPos,'Pack_Expiration_Date'),'mm/dd/yyyy') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//Expiration Date - BLANK
	lsOutString += lsDelimitChar	
 
	//Production Date - BLANK
	lsOutString += lsDelimitChar	
 
	//Best Before Date - BLANK
	lsOutString += lsDelimitChar	
 
	//PONO2 - BLANK - Not needed because last field
//	lsOutString += lsDelimitChar	
		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'GI' + String(ldBatchSeq,'000000') + '.csv'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next DeliveryPack record */

//2018/11/02 :TAM S24369 Create a New SWG File (along with GI) - START
//Get the Next Batch Seq Nbr - Used for all writing to generic tables
ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
If ldBatchSeq <= 0 Then
	lsLogOut = "        *** Unable to retrieve the next available sequence number~rfor Goods Issue Confirmation.~r~rConfirmation will not be sent to Warner!'"
	FileWrite(gilogFileNo,lsLogOut)
	Return -1
End If

//Write the rows to the generic output table - delimited by lsDelimitChar

// Write a header record
llNewRow = idsOut.insertRow(0)
lsOutString = 'Date' + lsDelimitChar + 'SSCC' + lsDelimitChar + 'GLN (ship from)' + lsDelimitChar + 'Destination GLN' + lsDelimitChar + 'GTIN' + lsDelimitChar + 'Product Lot' + lsDelimitChar + 'Units' + lsDelimitChar + 'Qty' + lsDelimitChar + 'poNumber' + lsDelimitChar + 'Date ID' + lsDelimitChar + 'GS1-128 Date'
idsOut.SetItem(llNewRow,'Project_id', asProject)
idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
idsOut.SetItem(llNewRow,'batch_data', lsOutString)
lsFileName = 'SWG' + String(ldBatchSeq,'000000') + '.csv'
idsOut.SetItem(llNewRow,'file_name', lsFileName)
llRowCount = idsDoPack.RowCount()

For llRowPos = 1 to llRowCOunt

	llNewRow = idsOut.insertRow(0)

	lsSku = idsdoPack.GetITEmString(llRowPos,'sku')
	lsSuppCode =  Upper(idsdoPack.GetITEmString(llRowPos,'supp_code'))
	lsLineItemNo = String(idsdoPack.GetITemNumber(llRowPos, 'Line_item_No'))
	lsOrdStatus = idsDoMain.GetItemString(1,'Ord_Status') 

	llDetailFind = idsDoDetail.Find("sku='"+lsSku+"' and Upper(supp_code) = '"+lsSuppCode+"' and line_item_no = " + string(lsLineItemNo), 1, idsDoDetail.RowCount())

	//Can't Find Detail
	IF llDetailFind <= 0 then 
		continue
	End If

	//Complete Date	Date	No	N/A	
	lsTemp = String( idsdoMain.GetITemDateTime(1,'Complete_Date'),'YYMMDD') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString = lsTemp+ lsDelimitChar	

	//Pack SSCC	N(6,0)	Yes	N/A	
	lsTemp = right(String(idsdoPack.GetITemString(llRowPos, 'Pack_SSCC_No')),18) //Get right 18 
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//GLN - 
	lsOutString += lsGLN+ lsDelimitChar	

	//Destination GLN - 
	lsTemp = idsdoMain.GetItemString(1,'user_Field2') 		
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar


	//Detail GTIN	
	lsTemp = idsdoDetail.GetItemString(llDetailFind,'GTIN')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//Lot Number		
	lsTemp = idsdoPack.GetItemString(llRowPos,'Pack_Lot_No')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//UOM - "Cases'
	lsOutString += 'Cases' + lsDelimitChar	

	//Pack Quantity
	lsTemp = String(idsdoPack.GetItemDecimal(llRowPos, "Quantity"),'#####0')
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//client_cust_po_nbr		
	lsTemp = idsdoMain.GetItemString(1,'client_cust_po_nbr') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp+ lsDelimitChar	

	//Date ID		
	lsOutString += '17' + lsDelimitChar	

	//Use Thru Date		
	lsTemp = String( idsdoPack.GetITemDateTime(llRowPos,'Pack_Expiration_Date'),'YYMMDD') 	
	If IsNull(lsTemp) then lsTemp = ''
	lsOutString += lsTemp	

		
	idsOut.SetItem(llNewRow,'Project_id', asProject)
	idsOut.SetItem(llNewRow,'edi_batch_seq_no', Long(ldBatchSeq))
	idsOut.SetItem(llNewRow,'line_seq_no', llNewRow)
	idsOut.SetItem(llNewRow,'batch_data', lsOutString)
	lsFileName = 'SWG' + String(ldBatchSeq,'000000') + '.csv'
	idsOut.SetItem(llNewRow,'file_name', lsFileName)
	

next /*next DeliveryPack record */


////09-Oct-2018 :Madhu S24369 Create a New SWG File (along with GI) - START
//ldBatchSeq = gu_nvo_process_files.uf_get_next_seq_no(asproject,'Good_Issue_File','Good_Issue')
//lsFileName = 'SWG' + String(ldBatchSeq,'000000') + '.csv'
//
//ll_gi_count= idsOut.rowcount( )
//
//idsOut.rowscopy( idsOut.getrow( ),  idsOut.rowcount( ),  Primary!, idsOut, (ll_gi_count +1), Primary!)
//For llRowPos = (ll_gi_count+1) to idsOut.rowcount( )
//	idsOut.setItem( llRowPos, 'edi_batch_seq_no', Long(ldBatchSeq))
//	idsOut.setItem( llRowPos, 'file_name', lsFileName)
//Next

//09-Oct-2018 :Madhu S24369 Create a New SWG File (along with GI) - END
//2018/11/02 :TAM S24369 Create a New SWG File (along with GI) - END

//Write the Outbound File - no need to save and re-retrieve - just use the currently loaded DW
gu_nvo_process_files.uf_process_flatfile_outbound_unicode(idsOut,asProject)


Return 0
end function

on u_nvo_edi_confirmations_rema.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_rema.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_string_util = CREATE n_string_util
string ls_empty[]
is_ToNo_List= ls_empty

lsDelimitChar = ','
end event

