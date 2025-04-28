HA$PBExportHeader$u_nvo_edi_confirmations_bosch.sru
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


lsLogOut = '      - Bosch GI Confirmation- Start Processing of uf_gi() for Trans_Id: ' + string(al_trans_Id)
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut)

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
				
				Execute Immediate "Begin Transaction" using SQLCA;
				
				Update batch_transaction Set trans_status = 'N', filename = :lsTemp
				Where project_id = 'BOSCH' and trans_id = :llTransId and trans_type = 'GI' Using SQLCA;
	
				If SQLCA.SqlCode = 0 Then
					// Update SIMS_Log entries that it has been retried.  Put entry into SKU field (unused for SKU)
					Update SIMS_Log Set SKU = :lsTemp
					Where project_id = 'BOSCH' and do_no = :lsDoNo and log_id = :llLogId Using SQLCA;
					
					If SQLCA.SqlCode = 0 Then
						Execute Immediate "COMMIT" using SQLCA;
						lsLogOut = " Found batch transaction TransOrderId: " + lsDoNo + " with new number of retries: '" + lsTemp + "'." 
						llReturnCode = 1
					Else
						Execute Immediate "ROLLBACK" using SQLCA;
						lsLogOut = " Update SQL_Log failed.  Reason: " + SQLCA.SqlErrText
					End If
				Else
					Execute Immediate "ROLLBACK" using SQLCA;
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
		
		Execute Immediate "Begin Transaction" using SQLCA;
		
		Update lookup_table Set user_field1 = :lsNextDate
		Where project_id = 'BOSCH' and code_type = 'LAST_CHECK' and code_id = 'GoodsIssueThread' Using SQLCA;

		If SQLCA.SqlCode = 0 Then
			Execute Immediate "COMMIT" using SQLCA;
			lsLogOut = " Found batch transaction TransOrderId: " + lsDoNo + " with new number of retries: '" + lsTemp + "'." 
		Else
			Execute Immediate "ROLLBACK" using SQLCA;
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

