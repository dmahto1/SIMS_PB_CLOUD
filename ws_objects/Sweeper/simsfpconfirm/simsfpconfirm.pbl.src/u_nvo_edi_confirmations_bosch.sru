$PBExportHeader$u_nvo_edi_confirmations_bosch.sru
$PBExportComments$+ Bosch EDI Confirmations
forward
global type u_nvo_edi_confirmations_bosch from nonvisualobject
end type
end forward

global type u_nvo_edi_confirmations_bosch from nonvisualobject
end type
global u_nvo_edi_confirmations_bosch u_nvo_edi_confirmations_bosch

forward prototypes
public function integer uf_gi (string as_project, long al_trans_id)
public function integer uf_process_945error (string as_project, string as_inifile)
end prototypes

public function integer uf_gi (string as_project, long al_trans_id);//16-Jan-2019 :Madhu S28196 Bosch Post GoodsIssueRequest to Websphere.
String ls_trans_parm, ls_email, ls_xml_request, ls_xml_response
String lsLogOut, ls_return_value, ls_trans_order, ls_error_msg
long ll_rc, ll_pos1, ll_pos2, ll_return_code, ll_count
string ls_trans_order_id,ls_ro_no,ls_sku ,ls_coo,ls_uf1,lsZone,ls_po_no2,lsCont,ls_sku_parent,ls_zone// Dinesh - 07/03/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 
datetime ldtExpDate
decimal ld_ro_no,ldOwnerID
string ls_rono_next_seq,ls_error_message,ls_supp_code,ls_loc,ls_serial,ls_lot,ls_po,ls_type,ls_Owner_Id,ls_sku_alternate // Dinesh - 07/03/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 
long ll_cnt,i,ll_owner_id,llLineItemNo,llCompNo,ll_owner,ll_count_pick,ll_alloc_qty// Dinesh - 07/03/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 
//datastore lds_pick  // Dinesh - 07/03/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 - commented this as to obsolete this approach for inserting 0 Qty record
datastore lds_details // Dinesh - 07/28/2025- SIMS-774-IFB-SIMS Bosch - Unable to delete the picking list after saving for 0 qty pick
lsLogOut = '      - Bosch GI Confirmation- Start Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

// Begin - Dinesh- 07/03/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 
long llFindRow,ll_lineitem,ll_allocated_qty
select trans_order_id into :ls_trans_order_id from batch_transaction where project_id=:as_project and trans_id = :al_trans_Id and trans_type='GI' using sqlca;
lds_details = create datastore 
lds_details.dataobject ="d_do_detail"  
lds_details.SetTransObject(SQLCA)
lds_details.retrieve(ls_trans_order_id)
//lds_details.setfilter("alloc_qty = " + string(ll_allocated_qty)) // Dinesh - 07/29/2025- SIMS-774-IFB-SIMS Bosch - Unable to delete the picking list after saving for 0 qty pick
lds_details.setfilter("alloc_qty ="+string(ll_allocated_qty)+" or alloc_qty="+""+" or alloc_qty="+"NULL"+"") // Dinesh - 07/29/2025- SIMS-774-IFB-SIMS Bosch - Unable to delete the picking list after saving for 0 qty pick
lds_details.filter() // Dinesh - 07/29/2025- SIMS-774-IFB-SIMS Bosch - Unable to delete the picking list after saving for 0 qty pick
	ll_count = lds_details.rowcount()
	Do While ll_count > 0
		ls_sku = lds_details.GetItemString(ll_count, "sku")
		ls_sku_alternate= lds_details.GetItemString(ll_count, "alternate_sku")
		ls_supp_code = lds_details.GetItemString(ll_count, "supp_code")
		ll_alloc_qty = lds_details.GetItemnumber(ll_count, "alloc_qty")
		llLineItemNo = lds_details.getitemnumber(ll_count,"line_item_no")
		ll_owner = lds_details.getitemnumber(ll_count,"owner_id")
		select count(*) into :ll_count_pick from delivery_picking where do_no= :ls_trans_order_id and sku=:ls_sku and supp_code=:ls_supp_code and owner_id=:ll_Owner_Id and l_code= :ls_loc and country_of_origin=:ls_coo and line_item_no=:llLineItemNo and inventory_type = 'N'  using sqlca; 
		if ll_count_pick > 0 then
		else			
			insert into delivery_picking(do_no,sku,quantity,line_item_no,supp_code,owner_id,country_of_origin,l_code,inventory_type,serial_no,lot_no,po_no,po_no2,component_no,container_id,expiration_date,zone_id)
			values(:ls_trans_order_id,:ls_sku,0,:llLineItemNo,'BH',:ll_owner,'XXX','NA','N','-','-','-','-',0,'-','2999-12-31','-') using sqlca;
			commit using sqlca;
			
			if sqlca.SQlcode <> 0 then
				ls_error_message = SQLCA.SQLErrText
				lsLogOut = '      - Bosch GI (Entry for the quantity Zero in the delivery_picking) - Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id) + " - Order "+ls_trans_order_id+" has been rejected due to this reason "+ls_error_message+"."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
			end if
						
			insert into delivery_picking_detail(do_no,sku,quantity,line_item_no,supp_code,owner_id,country_of_origin,l_code,inventory_type,serial_no,lot_no,po_no,po_no2,component_no,container_id,expiration_date,zone_id,ro_no)
			values (:ls_trans_order_id,:ls_sku,0,:llLineItemNo,'BH',:ll_owner,'XXX','NA','N','-','-','-','-',0,'-','2999-12-31','-','-')
			commit using sqlca;
			
			if sqlca.SQlcode <> 0 then
				ls_error_message = SQLCA.SQLErrText
				lsLogOut = '      - Bosch GI (Entry for the quantity Zero in the delivery_pick_details) - Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id) + " - Order "+ls_trans_order_id+" has been rejected due to this reason "+ls_error_message+"."
				FileWrite(giLogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut)
			end if
		End if
		ll_count --
	loop
// End - Dinesh- 03/07/2025- SIMS-738-Development for IFB-SIMS Bosch - Handle 0 picked/shipped qty for 945 


//get email address from ini file.
ls_email = ProfileString(gsIniFile, as_project, "GOODSISSUEEMAIL", "")

//get XML value from Batch_transaction table
select Trans_Order_Id, Trans_Parm into :ls_trans_order, :ls_trans_parm 
from Batch_Transaction with(nolock) 
where Project_Id=:as_project and Trans_Id=:al_trans_Id
using SQLCA;

/*
select count(*) into :ll_count from Batch_Transaction with(nolock)
where Project_Id =:as_project and Trans_Order_Id =:ls_trans_order
and Trans_Status='G' and Trans_Type='GI'
using SQLCA;
*/
IF ll_count > 0 THEN
	lsLogOut = '      - Bosch GI Confirmation- Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id) + " - same Order "+ls_trans_order+" has been already processed. Hence, skipping this transaction."
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)
	
	Return 0	
END IF


IF IsNull(ls_trans_parm) or ls_trans_parm ='' THEN
	ls_trans_parm = "<Id_No>" + ls_trans_order  + "</Id_No><Id_Type>order</Id_Type>"
END IF

//create an object for Websphere
u_nvo_websphere_post  lu_nvo_websphere_post
lu_nvo_websphere_post = create u_nvo_websphere_post

ls_xml_request = lu_nvo_websphere_post.uf_request_header( "GoodsIssueRequest", "ProjectID='" + as_project + "'")
ls_xml_request += ls_trans_parm
ls_xml_request = lu_nvo_websphere_post.uf_request_footer( ls_xml_request)

//post xml to Websphere
ls_xml_response = lu_nvo_websphere_post.uf_post_url( ls_xml_request)


//validate response code
If pos(Upper(ls_xml_response),"SIMSRESPONSE") = 0  Then

	lsLogOut = '      - Bosch GI Confirmation- Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id) + ' XML Response: '+ls_xml_response
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut)

	ls_error_msg ="Unable to Post (GoodsIssue Request) and Batch Transaction Details are following: Trans_Id: " + string(al_trans_Id) +" Trans_Order_Id: "+ls_trans_order
	
	//send an email notification
	gu_nvo_process_files.uf_send_email( as_project, ls_email, "Goods Issue File", ls_error_msg, "")
	Return -1
End If

lsLogOut = '      - Bosch GI Confirmation- End Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

Return 0
end function

public function integer uf_process_945error (string as_project, string as_inifile);//GailM 9/30/2019 S38447 F18587 Bosch retrigger 945 on socket error
//1.  Check for last sweeper run to determine which errors to check and retry
//2.  Pull records from SIMS_Log table from the datetime to present and update last run for the next run
//3.  Loop through the SIMS_Log records for the DoNos to retry.
//4.  Update the Batch Transaction for the GI record of the DoNo for trans_status to "N" and increment filename with Retries: n
//		This will send a retry.  If that one errors, then next cycle will pick it up and retry again until the 945 gets posted.
String ls_trans_parm, ls_email, ls_xml_request, ls_xml_response, lsSqlSyntax, lsError, lsWhere, lsTemp
String lsLogOut, ls_return_value, ls_trans_order, ls_error_msg, lsInterval, lsNextDate, lsDoNo, lsNbrRetries
long llRC, llPos1, llPos2, llReturnCode, llCount, llRow, llTransId, llTries, llLogId

Decimal			ldBatchSeq
DateTime		ldtToday, ldtMaxComplDate
DateTime		ldtNextRunTime
Date				ldtNextRunDate
Time				ldtNow
u_ds_datastore	ldsSimsLog, ldsLookupTable

If Not isvalid(ldsLookupTable) Then
	ldsLookupTable = Create u_ds_datastore
	ldsLookupTable.dataobject = 'd_lookup_table_search'
End If
ldsLookupTable.SetTransObject(SQLCA)

ldsSimsLog = create u_ds_datastore
ldsSimsLog.dataobject = "d_sims_log"
ldsSimsLog.SetTransObJect(SQLCA)

ldtToday = DateTime(Today(), Now())
ldtNextRunDate = RelativeDate(Date(ldtToday), -1) /*relative based on today*/
ldtNextRunTime = Datetime(ldtNextRunDate,Now() )		/*relative based on now*/

llRC = ldsLookupTable.Retrieve("BOSCH","LAST_CHECK")
If llRC = 1 Then
	lsNextDate = ldsLookupTable.GetItemString(1, "user_field1")		//Holds next run data/time
	ldtNextRunTime = DateTime(lsNextDate)
End If

lsSqlSyntax = ldsSimsLog.GetSqlSelect()
lsWhere = " WHERE project_id = '" + as_project + "' and response_code = 'ERROR' and request_id = 'GoodsIssueThread' and response_date >= '" + lsNextDate + "' "
lsSqlSyntax = lsSqlSyntax + lsWhere

ldsSimsLog.setsqlselect( lsSqlSyntax )
ldsSimsLog.SetTransObJect(SQLCA)

llRC = ldsSimsLog.Retrieve()
If llRC > 0 Then
	lsLogOut = ""
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	lsLogOut = "- PROCESSING FUNCTION: BOSCH Hourly 945 Socket Error for Retry!"
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
	
	For llRow = 1 to llRC
		lsDoNo = ldsSimsLog.GetItemString(llRow, "do_no")
		llLogId = ldsSimsLog.GetItemNumber(llRow, "log_id")
		ldtNextRunTime = ldsSimsLog.GetItemDatetime(llRow, "response_date")
		
		Select Max(Trans_Complete_Date), Max(trans_id), Max(filename) Into :ldtMaxComplDate, :llTransId, :lsNbrRetries 
		From Batch_Transaction with (nolock) 
		where project_id = 'BOSCH' and trans_type = 'GI' and trans_status = 'E' 
		and trans_order_id = :lsDoNo Using SQLCA;
		
		If llTransId <> 0 Then
			//Check whether a trans_status C for this dono/GI has been successful, then do not process retry
			Select count(*) into :llCount From batch_transaction with (nolock) where project_id = 'BOSCH' 
			and trans_type = 'GI' and trans_status = 'C' and trans_order_id = :lsDoNo and trans_complete_date > :ldtMaxComplDate
			Using SQLCA;
			
			If llCount = 0 Then
				If lsNbrRetries = '' Then
					lsNbrRetries = "Retries: 1"
					llTries = 1
				Else
					If Left(lsNbrRetries,9) = "Retries: " Then
						lsTemp = Right(lsNbrRetries, Len(lsNbrRetries) - 9)
						llTries = Long(lsTemp) + 1
					End If
				End If
				lsTemp = "Retries: " + String(llTries)
				
				//Execute Immediate "Begin Transaction" using SQLCA; MikeA - DE15499
				
				Update batch_transaction Set trans_status = 'N', filename = :lsTemp
				Where project_id = 'BOSCH' and trans_id = :llTransId and trans_type = 'GI' Using SQLCA;
	
				If SQLCA.SqlCode = 0 Then
					// Update SIMS_Log entries that it has been retried.  Put entry into SKU field (unused for SKU)
					Update SIMS_Log Set SKU = :lsTemp
					Where project_id = 'BOSCH' and do_no = :lsDoNo and log_id = :llLogId Using SQLCA;
					
					If SQLCA.SqlCode = 0 Then
						//Execute Immediate "COMMIT" using SQLCA; MikeA - DE15499
						commit using sqlca;
						lsLogOut = " Found batch transaction TransOrderId: " + lsDoNo + " with new number of retries: '" + lsTemp + "'." 
						llReturnCode = 1
					Else
						//Execute Immediate "ROLLBACK" using SQLCA; MikeA - DE15499
						rollback using sqlca;
						lsLogOut = " Update SQL_Log failed.  Reason: " + SQLCA.SqlErrText
					End If
				Else
					//Execute Immediate "ROLLBACK" using SQLCA; MikeA - DE15499
					rollback using sqlca;
					lsLogOut = " Update batch_transaction failed.  Reason: " + SQLCA.SqlErrText
				End If
				
				FileWrite(gilogFileNo,lsLogOut)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
			End If
		Else
			lsLogOut = " Could not find batch transaction TransOrderId: " + lsDoNo + " and could not resend 945."
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		End If
	Next
	
	If llReturnCode = 1 Then
		ldtNow = RelativeTime(Time(ldtNextRunTime),3)	//3 seconds forward
		ldtNextRunDate = RelativeDate(Date(ldtNextRunTime),0)
		ldtNextRunTime = DateTime(ldtNextRunDate, ldtNow)
		lsNextDate = String(ldtNextRunTime)
		
		//Execute Immediate "Begin Transaction" using SQLCA; MikeA - DE15499
		
		Update lookup_table Set user_field1 = :lsNextDate
		Where project_id = 'BOSCH' and code_type = 'LAST_CHECK' and code_id = 'GoodsIssueThread' Using SQLCA;

		If SQLCA.SqlCode = 0 Then
			//Execute Immediate "COMMIT" using SQLCA; MikeA - DE15499
			commit using sqlca;
			lsLogOut = " Found batch transaction TransOrderId: " + lsDoNo + " with new number of retries: '" + lsTemp + "'." 
		Else
			//Execute Immediate "ROLLBACK" using SQLCA; MikeA - DE15499
			rollback using sqlca;
			lsLogOut = " Update Lookup_Table failed.  Reason: " + SQLCA.SqlErrText
		End If
	End If
End If

return 0

end function

on u_nvo_edi_confirmations_bosch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_edi_confirmations_bosch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

