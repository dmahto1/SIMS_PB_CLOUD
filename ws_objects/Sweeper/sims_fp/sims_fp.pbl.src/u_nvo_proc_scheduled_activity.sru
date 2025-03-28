$PBExportHeader$u_nvo_proc_scheduled_activity.sru
$PBExportComments$Process functions and reports that have been scheduled to run in the Activity Schedule table
forward
global type u_nvo_proc_scheduled_activity from nonvisualobject
end type
end forward

global type u_nvo_proc_scheduled_activity from nonvisualobject
end type
global u_nvo_proc_scheduled_activity u_nvo_proc_scheduled_activity

type variables

end variables

forward prototypes
public function integer uf_process_reports (string asinifile)
public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments)
public function integer uf_process_functions (string asinifile)
public function integer uf_process_trax_eod (string asproject, string aswarehouse, string asparmstring, datetime adtlastruntime, string asemailstring, string asemailsubject)
public function string uf_method_trace_archive ()
end prototypes

public function integer uf_process_reports (string asinifile);

/* 

Process the Reports scheduled to run in the table Activity_Schedule.  The Datastore only shows records where 
Current Server Time is > Next Run Time.  After a report is run the Next Run Time is updated to the same time tomorrow.

Activity Schedule contains a Local Run Time and a server offset. 
Local Run Time = Server Time + Offset .....  Server Time = Local Run Time - Offset
If report may need to run at 10pm PST (6:00am GMT), the database will have 22:00 for Local Run Time and a Server Offset of -8.
 

*/

Datastore	ldsOut,	&
				ldsReports, &
				ldsResults
				
Long			llRowPos, llRowCount, &
				llReportRowPos, llReportRowCount, llServerOffset, &
				llhour, llday, llmin, llstringpos
				
String		lsFind, lsOutString,	lslogOut, lsProject,	&
				lsNextRunTime,	&
				lsEmail, lsWarehouse, lsFileName, lsFilePrefix, &
				lsDwName, lsParmString, lsEmailString, lsEmailSubject,&
				lsOutputName, lsOutputFormat, lsactivityid, lssuppcode, &
				lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsmessage, lsdescription

DEcimal		ldBatchSeq
Integer		liRC, J
DateTime		ldtNextRunTime, ldtLastRunTime, ldtLocalFromDate, ldtLocalToDate
Date			ldtNextRunDate

Time			ltmLocalRunTime


ldsOut = Create u_ds_datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsreports = Create u_ds_datastore
ldsreports.Dataobject = 'd_reports_activity_schedule'
lirc = ldsreports.SetTransobject(sqlca)

// Get reports that need to be run 
llReportRowCount = ldsreports.Retrieve() 
	
lsLogOut = '   ' + String(llReportRowCount) + ' Report Rows were retrieved.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
	
//Run Each Report
For llReportRowPos = 1 to llReportRowCOunt

	// For each report load all the variables 
	lsproject = ldsreports.GetItemString(llReportRowPos, "project_id")
	lswarehouse = ldsreports.GetItemString(llReportRowPos, "wh_code")
	lsactivityid = ldsreports.GetItemString(llReportRowPos, "activity_id")
	lsDwName = ldsreports.GetItemString(llReportRowPos, "dw_name")
	lsParmString = ldsreports.GetItemString(llReportRowPos, "parm_string")
	lsEmailString = ldsreports.GetItemString(llReportRowPos, "email_string")
	lsEmailSubject = ldsreports.GetItemString(llReportRowPos, "email_subject")
	lsDescription = ldsreports.GetItemString(llReportRowPos, "description")
	lsOutputName = ldsreports.GetItemString(llReportRowPos, "output_name")
	lsOutputFormat = ldsreports.GetItemString(llReportRowPos, "output_format")
	ltmLocalRunTime = time(ldsreports.GetItemstring(llReportRowPos, "local_run_time"))
	ldtNextRunTime =   ldsreports.GetItemDateTime(llReportRowPos, "Next_Run_Time")
	llServerOffset =  ldsreports.GetItemNumber(llReportRowPos, "Server_Time_Offset")
	
/* At this time if reports are to be run over a date range, we assume 1 day 00:00 to 23:59 calculated by the
	prior full day local time.  Server time is GMT.  If the Local Time the report is run on a different day than server time
	then we must calculate the last full day.
	
	For example if the server time is 6:00am but the local offset is -8 then the Local time is 10:00pm the previous day.
	To Run report for a 24 hour period subtract 2 days from today(server date) 
*/
llHour = hour(now()) + llServerOffset

	If llHour > 24 then			//after midnight next day local time
		llDay = 0					//no adjustment needed on report date range
	ElseIf llhour <= 0 then 	//before midnight prior day local time
		llDay = -2					//adjustment 2 days ago on report date range
	Else 								// same day
		llDay = -1					//adjustment 1 day ago on report date range
	End If
	
	
	ldtLocalFromDate = datetime(relativeDate(today(),llday), time('00:00:00')) /*relative based on today*/
	ldtLocalToDate = datetime(relativeDate(today(),llday),time('23:59:59')) /*relative based on today*/

// Replace Where string from date place holder with actual from date
	llstringpos = pos(lsParmstring,'&from&')
	If llstringpos > 0 then
		lsparmstring = Replace(lsparmstring,llstringpos,6,string(ldtLocalFromDate,'yyyy/mm/dd hh:mm:ss'))
		lsdescription = lsdescription + ' from date: ' + string(ldtLocalFromDate,'yyyy/mm/dd hh:mm:ss')
	End If
	
	// Replace Parm string to date place holder with actual to date
	llstringpos = pos(lsparmstring,'&to&')
	If llstringpos > 0 then
		lsparmstring = Replace(lsparmstring,llstringpos,4,string(ldtLocalToDate,'yyyy/mm/dd hh:mm:ss'))
		lsdescription = lsdescription + ' to date: ' + string(ldtLocalToDate,'yyyy/mm/dd hh:mm:ss')
	End If
	
	//Create the results data store
	ldsResults = Create u_ds_datastore
	ldsResults.Dataobject = lsDwName
	lirc = ldsResults.SetTransobject(sqlca)
	
	lsparm1 = ''
	lsparm2 = ''
	lsparm3 = ''
	lsparm4 = ''
	lsparm5 = ''
	lsparm6 = ''
	lsparm7 = ''

	//Pull out Parm1
	If Pos(lsparmstring,',') > 0 Then // If comma found 
		lsparm1 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
	Else // If no comma found whole thing is parm
		lsparm1 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm1) + 1))) //Strip off parm and comma
	
	//Pull out Parm2
	If Pos(lsparmstring,',') > 0 Then
		lsparm2 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
	Else // If no comma found whole thing is parm
		lsparm2 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm2) + 1))) //Strip off until the next delimeter

	//Pull out Parm3
	If Pos(lsparmstring,',') > 0 Then
		lsparm3 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
	Else // If no comma found whole thing is parm
		lsparm3 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm3) + 1))) //Strip off until the next delimeter
	
	//Pull out Parm4
	If Pos(lsparmstring,',') > 0 Then
		lsparm4 = Left(lsparmstring,(pos(lsparmstring,',') - 1))
	Else
		lsparm4 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm4) + 1))) //Strip off until the next delimeter

	//Pull out Parm5
	If Pos(lsparmstring,',') > 0 Then // If comma found 
		lsparm5 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
	Else // If no comma found whole thing is parm
		lsparm5 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm5) + 1))) //Strip off parm and comma
	
	//Pull out Parm6
	If Pos(lsparmstring,',') > 0 Then // If comma found 
		lsparm6 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
	Else // If no comma found whole thing is parm
		lsparm6 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm6) + 1))) //Strip off parm and comma
	
	//Pull out Parm7
	If Pos(lsparmstring,',') > 0 Then // If comma found 
		lsparm7 = Left(lsparmstring,(pos(lsparmstring,',') - 1)) // Take everything left of the comma
	Else // If no comma found whole thing is parm
		lsparm7 = lsparmstring
	End If
	lsparmstring = Right(lsparmstring,(len(lsparmstring) - (Len(lsparm7) + 1))) //Strip off parm and comma
	
	llRowCOunt = ldsresults.Retrieve(lsparm1,lsparm2,lsparm3,lsparm4,lsparm5,lsparm6,lsparm7) 
	

	
	If llRowCOunt > 0 Then
	
		lsLogOut = '     ' + String(llRowCount) + '    Rows were retrieved for ' + lsDescription
		gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
		FileWrite(gilogFileNo,lsLogOut)
	
		//create a file in the archive directory and email it...
		lsFileName = ProfileString(asInifile,lsProject,"archivedirectory","") + '\' + lsOutputName + String(Today(),"mmddyy") + lsOutputFormat
		ldsresults.SaveAs(lsFileName,excel5!,True)
	
		//lsLogout = '     Attached is the ' + lsDescription + ' run on ' + string(today(),'mm-dd-yy')
		lsLogout = '     Attached is the ' + lsDescription + ' run on ' + string(today(),'mm-dd-yyyy hh:mm')

		gu_nvo_process_files.uf_send_email(lsProject,lsemailstring,'XPO Logistics WMS - ' + lsdescription,lsLogOut,lsFileName) 
	
	Else /* No inventory*/
			//Sarun2014Apr24: Email Alert for Expire Item of STBTH, BoonHee requested for No mails if there is no Rows
		if lsDwName = 'd_stock_expiry_report' then
			//No Email
		else
			lsLogout = 'There is no data for ' + lsdescription + ' run on ' + string(today(),'mm-dd-yyyy hh:mm')
			gu_nvo_process_files.uf_send_email(lsProject,lsemailstring,'XPO Logistics WMS - ' + lsdescription,lsLogOut,'') 	
		end if	
	End If

	Destroy ldsResults


	// Reset the Last Run Time(Current Server Time) and Next Run Time (in Server Time)
	
	ldsReports.SetItem(llReportRowPos,'Last_Run_Time',dateTime(today(),now()))
	
	// Calculate the Next Run Time to run the report based on (today + 1 day) + (local run time(hh:mm) + server offset)
	llHour = hour(ltmLocalRunTime) - llServerOffset
	llMin  = Minute(ltmLocalRunTime)
	If llHour >= 24 then
		llhour = llhour - 24
	ElseIf llhour < 0 then
		llhour = 24 + llhour
	End If
	lsnextruntime = string(llhour) + ':' + String(llmin,'##') + ':00.000'
	ldtnextRunTime= datetime(relativeDate(today(),1),time(LsNextRunTime))

	ldsReports.SetItem(llReportRowPos,'Next_Run_Time', ldtnextRunTime)

// tam 04/13/2005  Add a delay in the reports untill the BLAT(send email) issue is resolved.  BLAT issue has to do with Emails not
// 					being received when a high volumn of Emails are sent at one time.
//sleep (5)

Next /* Report to Process*/


//jla 01/12/2010

If llReportRowCount > 0 Then
	liRC = ldsreports.Update()
	If liRC = 1 Then
			Commit;
	Else
		Rollback;
		lsMessage= SQLCA.SQLErrText
		lsLogOut =  "  ***System Error!  Unable to save the Run Dates  to the database file: Activity_Schedule" + lsMessage
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
//		Return -1
	End If
	
End If



Return 0
end function

public function integer uf_send_email (string asproject, string asdistriblist, string assubject, string astext, string asattachments);String	lsDistribList,	&
			lsTemp,			&
			lsOutPut,		&
			lsReturn
			
Long		llArrayPos

mailMessage lmMailMsg
MailFileDescription	mAttach

		
lsDistribList = AsDistriblist
		

//08/02 - Pconkl - Get out if no Dist List
If isNull(lsDistribList) or lsDistribList = '' Then
	lsOutput = "          - No entries in distribution list for this project. Email notification not sent."
	FileWrite(gilogFileNo,lsOutput)
	gu_nvo_process_files.uf_write_log(lsOutput) /*display msg to screen*/
	
	Return 0
End If

//parse out the email distrib list for the proper distribution list (from input parm)
If lsDistribList > '' Then
	lsTEmp = lsDistribList
	If Pos(lsTEmp,';') > 0 Then /*multiple recipients*/
		llArrayPos = 0
		Do While Pos(lsTEmp,';') > 0
			llArrayPos ++
			lmMailMsg.REcipient[llArrayPos].Name = Left(lsTEmp,Pos(lsTEmp,';') - 1)
			lsTEmp = Right(lsTEmp,len(lsTEmp) - Pos(lsTEmp,';'))
		Loop
	
		llArrayPos ++
		lmMailMsg.REcipient[llArrayPos].Name = lsTEmp
	Else /*only 1 recipient */
		lmMailMsg.REcipient[1].Name = lsTEmp
	End If
End If /*email list present in ini file*/

//Parse out any attachments if they exist
If asAttachments > '' Then
	lsTEmp = asAttachments
	If Pos(lsTEmp,';') > 0 Then /*multiple attachments*/
		llArrayPos = 0
		Do While Pos(lsTEmp,';') > 0
			llArrayPos ++
			mAttach.Pathname = Left(lsTEmp,Pos(lsTEmp,';') - 1)
			mAttach.Position = llArrayPos
			lmMailMsg.AttachmentFile[llArrayPos] = mAttach
			lsTEmp = Right(lsTEmp,len(lsTEmp) - Pos(lsTEmp,';'))
		Loop
	
		llArrayPos ++
		mAttach.PathName = lsTemp
		mAttach.Position = llArrayPos
		lmMailMsg.AttachmentFile[llArrayPos] = mAttach
		
	Else /*only 1 attachment */
		mAttach.PathNAme = lsTemp
		mAttach.Position = 1
		lmMailMsg.AttachmentFile[1] = mAttach
	End If
End If /*attachment list presentin parm*/

//Set subject and Text - add environment (test/prod) and Project to end of subject
lmMailMsg.Subject = assubject + ' (' + gsEnvironment + '/' + asProject +  ')'
lmMailMsg.NoteText = asText 

//Send the Message
gmmailret = gmmailsession.MailSend(lmMailMsg)

If gmmailRet <> MailReturnSuccess! Then
	
	Choose Case gmMailRet
		Case mailReturnFailure!
			lsREturn = "mailReturnFailure!"
		Case mailReturnInsufficientMemory!
			lsReturn = "mailReturnInsufficientMemory!"
		Case mailReturnUserAbort!
			lsReturn = "mailReturnUserAbort!"
		Case mailReturnDiskFull!
			lsReturn = "mailReturnDiskFull!"
		Case mailReturnTooManySessions!
			lsReturn = "mailReturnTooManySessions!"
		Case mailReturnTooManyFiles!
			lsReturn = "mailReturnTooManyFiles!"
		Case mailReturnTooManyRecipients!
			lsREturn = "mailReturnTooManyRecipients!"
		Case mailReturnUnknownRecipient!
			lsReturn = "mailReturnUnknownRecipient!"
		CAse mailReturnAttachmentNotFound!
			lsReturn = "mailReturnAttachmentNotFound!"
		Case Else
			lsReturn = "Unknown"
	End Choose
	
	lsOutput = "          - Unable to send mail to: (" + asDistribList + "): " + lsDistribList + "~rREason: " + lsReturn
	FileWrite(gilogFileNo,lsOutput)
	gu_nvo_process_files.uf_write_Log(lsOutput) /*display msg to screen*/
	Return -1
Else
	lsOutput = "          - Mail sent to: (" + asDistribList + "): " + lsDistribList
	FileWrite(gilogFileNo,lsOutput)
	gu_nvo_process_files.uf_write_Log(lsOutput) /*display msg to screen*/
End If

Return 0
end function

public function integer uf_process_functions (string asinifile);// Process the Reports scheduled to run in the table Activity_Schedule.  The Datastore only shows records where 
// Current Server Time is > Next Run Time.  After a report is run the Next Run Time is updated to the same time tomorrow.
//uf_write_log
// Activity Schedule contains a Local Run Time and a server offset. 
// Local Run Time = Server Time + Offset .....  Server Time = Local Run Time - Offset
// If report may need to run at 10pm PST (6:00am GMT), the database will have 22:00 for Local Run Time and a Server Offset of -8.

//Modified: 04/15/2011 TimA Pandora Issue #190

Datastore	ldsOut,	&
				ldsfunctions, &
				ldsResults
Datastore 	ldsWarehouseTime
	string lsMessage_archive


u_nvo_scheduled_functions	lu_scheduled_functions
u_nvo_edi_confirmations_maquet lu_nvo_edi_confirmations_maquet
u_nvo_proc_phoenix lu_nvo_proc_phoenix
u_nvo_proc_pandora	lu_nvo_proc_Pandora	
u_nvo_proc_pandora2 lu_nvo_proc_Pandora2
u_nvo_edi_confirmations_pandora	lu_nvo_edi_confirmations_pandora
u_nvo_proc_philips_sg lu_nvo_proc_philips_sg
u_nvo_proc_philips_th lu_nvo_proc_philips_th
u_nvo_proc_philips_cls lu_nvo_proc_philips_cls //TAM 2019/02/14 S29551
u_nvo_proc_lmc lu_nvo_proc_lmc
u_nvo_proc_bosch lu_nvo_proc_bosch
u_nvo_edi_confirmations_bosch lu_nvo_edi_confirmations_bosch	//GWM 10/3/2019 S38447
u_nvo_proc_sg_muser lu_nvo_proc_sg_muser
u_nvo_proc_ncr lu_nvo_proc_ncr 	
u_nvo_proc_ford lu_nvo_proc_ford
u_nvo_proc_puma lu_nvo_proc_puma 
u_nvo_proc_baseline_unicode lu_nvo_proc_baseline_unicode
u_nvo_proc_newera	lu_nvo_proc_newera
u_nvo_proc_riverbed lu_nvo_proc_riverbed
u_nvo_proc_dana_th lu_nvo_proc_dana_th
u_nvo_proc_stryker  lu_nvo_proc_stryker 
u_nvo_proc_ws  lu_nvo_proc_ws
u_nvo_proc_physio	lu_nvo_proc_physio  //07-Feb-2013 :Madhu  Outbound confirmation Weekly Report
u_nvo_proc_tpv  lu_nvo_proc_tpv
u_nvo_proc_nycsp  lu_nvo_proc_nycsp //TAM 2012/11/09 
u_nvo_edi_confirmations_starbucks_th  lu_nvo_proc_starbucks_th /* 04/13 - PCONKL */
u_nvo_proc_starbucks_th lu_nvo_proc_starbucks  //28-May-2013 :Madhu  Added to generate Daily Inventory Report
u_nvo_proc_petha  lu_nvo_proc_petha  //11-feb-2014: Nxjain   Added to generate Daily Inventory Report
u_nvo_proc_friedrich lu_nvo_proc_friedrich   //20-Jan-2014 :Madhu Added new funtion for Friedrich
u_nvo_proc_kinderdijk lu_nvo_proc_kinderdijk		/*Jxlim 05/12/2013 Kinderdijk */
u_nvo_proc_funai lu_nvo_proc_funai /* 6/13 MEA - Added funai */
u_nvo_edi_confirmations_friedrich	lu_nvo_edi_confirmations_friedrich //TAM  2013/11/2 
u_nvo_proc_garmin lu_nvo_proc_garmin		/*Jxlim 04/30/2014 Garmin */
u_nvo_proc_nyx lu_nvo_proc_nyx		/*TAM 05/7/2014 NYX */
u_nvo_proc_th_muser  lu_nvo_proc_th_muser // th_muser Daily inventory report
u_nvo_proc_anki lu_nvo_proc_anki		/*Jxlim 08/28/2014 15 minutes BOH */
u_nvo_proc_gibson lu_nvo_proc_gibson /* 01/2015 TAM - Added gibson */
u_nvo_edi_confirmations_h2o	lu_nvo_edi_confirmations_h2o //TAM  2016/04
u_nvo_proc_kendo lu_nvo_proc_kendo   /* 04/16 - PCONKL */
u_nvo_proc_kendo lu_nvo_proc_kendo_xerox   /* Dhirendra*/
u_nvo_proc_dana_ray lu_nvo_proc_dana_ray	//20-May-2016 :Madhu- Added to generate Daily Summary Inv Rpt
u_nvo_proc_hager_my lu_nvo_proc_hager_my
u_nvo_proc_coty 	lu_nvo_proc_coty 	//18-APR-2018 :Madhu S18357 - COTY - Inventory Snapshot
u_nvo_proc_rema 	lu_nvo_proc_rema 	//TAM 2018/11/29  S25784 - REMA - OM inventory Sync
u_nvo_proc_cree lu_nvo_proc_cree //07-Jan-2019 :Madhu S27852 - CREE Delivery Order Report
u_nvo_proc_scheduled_activity lu_nvo_proc_scheduled_activity // Dinesh - 11/21/2022- Adding METHOD_TRACE_ARCHIVE                              

Long			llRowPos, llRowCount, llWHRow, llWHRowCount, &
				llFunctionRowPos, llFunctionRowCount, llServerOffset, llWHServerOffset, &
				llhour, llday, llmin, llstringpos
				
String		lsFind, lsOutString,	lslogOut, lsProject,	&
				lsNextRunTime,	lsactivityid, &
				lsEmail, lsWarehouse, lsFileName, lsFilePrefix, &
				lsDwName, lsfunctionName, lsParmString, lsEmailString, lsEmailSubject,&
				lsOutputName, lsOutputFormat, &
				lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsmessage, lsdescription, lsDayName

DEcimal		ldBatchSeq
Integer		liRC, J,liReturn //05-Oct-2015 :Madhu- Added liReturn
DateTime		ldtNextRunTime, ldtLastRunTime, ldtLocalFromDate, ldtLocalToDate
Date			ldtNextRunDate

Time			ltmLocalRunTime
Boolean		lbRunToday, lbRC

String 		lsRunToday

//ldsOut = Create u_ds_datastore
//ldsOut.Dataobject = 'd_edi_generic_out'
//lirc = ldsOut.SetTransobject(sqlca)

//GailM - 02/27/2018 - DE3035 error calculating day of week in activity scheduler
ldsWarehouseTime = Create u_ds_datastore
ldsWarehouseTime.DataObject = 'd_warehouse_time'
ldsWarehouseTime.SetTransObject( SQLCA )

llWHRowCount = ldsWarehouseTime.Retrieve( )				//Retrieve all warehouse

ldsFunctions = Create u_ds_datastore
ldsFunctions.Dataobject = 'd_functions_activity_schedule'
lirc = ldsFunctions.SetTransobject(sqlca)

// Get Functions that need to be run 
llFunctionRowCount = ldsFunctions.Retrieve() 

	
lsLogOut = '   ' + String(llFunctionRowCount) + ' Function Rows were retrieved.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
	
//Run Each Function
For llFunctionRowPos = 1 to llFunctionRowCOunt
	
	
	// For each Function load all the variables 
	lsproject = ldsFunctions.GetItemString(llFunctionRowPos, "project_id")
	lsactivityid = ldsFunctions.GetItemString(llFunctionRowPos, "activity_id")
	lswarehouse = ldsFunctions.GetItemString(llFunctionRowPos, "wh_code")
	lsfunctionName = ldsFunctions.GetItemString(llFunctionRowPos, "function_name")
	lsDwName = ldsFunctions.GetItemString(llFunctionRowPos, "dw_name")
	lsParmString = ldsFunctions.GetItemString(llFunctionRowPos, "parm_string")
	lsEmailString = ldsFunctions.GetItemString(llFunctionRowPos, "email_string")
	lsEmailSubject = ldsFunctions.GetItemString(llFunctionRowPos, "email_subject")
	lsDescription = ldsFunctions.GetItemString(llFunctionRowPos, "description")
	lsOutputName = ldsFunctions.GetItemString(llFunctionRowPos, "output_name")
	lsOutputFormat = ldsFunctions.GetItemString(llFunctionRowPos, "output_format")
	ltmLocalRunTime = time(ldsFunctions.GetItemString(llFunctionRowPos, "local_run_time"))
	ldtLastRunTime = ldsFunctions.GetItemDateTime(llFunctionRowPos, "Last_Run_Time")
	ldtNextRunTime =   ldsFunctions.GetItemDateTime(llFunctionRowPos, "Next_Run_Time")
	llServerOffset =  ldsFunctions.GetItemNumber(llFunctionRowPos, "Server_Time_Offset") 
	
	// At this time if Functions are to be run over a date range, we assume 1 day 00:00 to 23:59 calculated by the
	//	prior full day local time.  Server time is GMT.  If the Local Time the Function is run on a different day than server time
	//	then we must calculate the last full day.
	//	
	//	For example if the server time is 6:00am but the local offset is -8 then the Local time is 10:00pm the previous day.
	//	To Run Function for a 24 hour period subtract 2 days from today(server date) 

	//GailM - 02/27/2018 - DE3035 error calculating day of week in activity scheduler
	If Not isNull( lsWarehouse ) and lsWarehouse <> '' Then
		lsFind = "Wh_Code = '" + lsWarehouse + "' "
		llWHRow = ldsWarehouseTime.Find( lsFind, 1, llWHRowCount )
		If llWHRow > 0 Then
			llWHServerOffset = ldsWarehouseTime.GetItemNumber( llWHRow, 'GMT_Offset' )
			// Tasks to Do - Determine if DST Flag is on, when daylight saving starts and ends and is this warehouse in daylight savings time.
			
			llServerOffset = llWHServerOffset		//Take WH table entry over activity schedule offset
			
		End If
	End If

	// At this point it is determined that Next Run Time is GMT and to determine local WH time we should add the server offset

	llHour = hour(now()) + llServerOffset

	// GailM 3/12/2018 DE3035 - Calculate local day of the week
	// GailM 5/18/2018 DE3035 - Make llHour equal to or greater than 24 and less than or equal to 0
	If llHour >24 then		// midnight OR after next day local time
		llDay = 1					
	ElseIf llhour < 0 then 	// midnight or before prior day local time
		llDay = -1					
	Else 							// same day
		If hour(now()) = 0 Then	// If server time is midnight treat as tomorrow day
			llDay = 1
		Else
			llDay = 0		
		End if
	End If

// Original calculations	
//	If llHour > 24 then			//after midnight next day local time
//		llDay = 0					//no adjustment needed on Function date range
//	ElseIf llhour <= 0 then 	//before midnight prior day local time
//		llDay = -2					//adjustment 2 days ago on Function date range
//	Else 								// same day
//		llDay = -1					//adjustment 1 day ago on report date range
//	End If

	ldtLocalFromDate = datetime(relativeDate(today(),llday), time('00:00:00')) /*relative based on today*/
	ldtLocalToDate = datetime(relativeDate(today(),llday),time('23:59:59')) /*relative based on today*/
     
	// Replace Where string from date place holder with actual from date
	llstringpos = pos(lsParmstring,'&from&')
	If llstringpos > 0 then
		lsparmstring = Replace(lsparmstring,llstringpos,6,string(ldtLocalFromDate,'yyyy/mm/dd hh:mm:ss'))
	End If
	
	// Replace Parm string to date place holder with actual to date
	llstringpos = pos(lsparmstring,'&to&')
	If llstringpos > 0 then
		lsparmstring = Replace(lsparmstring,llstringpos,4,string(ldtLocalToDate,'yyyy/mm/dd hh:mm:ss'))
	End If
	
	//Call Function the results data store

	// 06/08 - PCONKL - Added logic to process individual day of the week run
	//							If not running for this day, we will still calculate next run time for tomorrow
	
	
	lsDayName = DayName(Date(ldtLocalFromDate))
	lbRunToday = False
	
	Choose Case Upper(lsDayName)
			Case 'SUNDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "sunday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'MONDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "monday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'TUESDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "tuesday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'WEDNESDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "wednesday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'THURSDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "thursday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'FRIDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "friday_run")) = 'Y' Then
				lbRunToday = True
			End If
		Case 'SATURDAY'
			If Upper(ldsFunctions.GetItemString(llFunctionRowPos, "saturday_run")) = 'Y' Then
				lbRunToday = True
			End If
		
	End Choose

	//GailM - 02/27/2018 - DE3035 error calculating day of week in activity scheduler for 3PL scheduled report
	If isNull( lsWarehouse ) Then lsWarehouse = ''
	If isNull( lsFunctionName ) Then lsFunctionName = ''
	If lbRunToday = True Then 
		lsRunToday = 'Yes' 
	Else
		lsRunToday = 'No' 
	End If
	
//	If lsWarehouse = 'PND_SVILLE' Then		//Check PND_SVILLE for Monday thru Friday - 5/18/2018 method trace for all
		lsMessage =  'Sweeper Day Calculation for WH:' + lsWarehouse +  ' - Day picked: ' + lsDayName + &
			' - RunToday: ' + lsRunToday + &
			' - DateTime: ' + string(Now(),'yyyy/mm/dd hh:mm:ss' ) + &
			' - llHour: ' + string(llHour) + ' - llDay: ' + String( llDay ) + &
			' - LocalFromDate:' +  string( ldtLocalFromDate ,'yyyy/mm/dd hh:mm:ss' ) + &
			' - FunctionName: ' + lsFunctionName
			
		f_method_trace_special( lsproject, 'u_nvo_proc_scheduled_activity.uf_process_functions', lsMessage, lsWarehouse, ' ',' ', lsproject ) 
		gu_nvo_process_files.uf_write_log(lsMessage) /*display msg to screen*/
		FileWrite(gilogFileNo,lsMessage)
//	End If

	If lbRunToday Then
		Choose Case (lsfunctionname)
			// Begin -Dinesh - 11/21/2022- SIMS-125 -  METHOD_TRACE_ARCHIVE to Archive method_trace_log_archive table                             
			Case 'uf_method_trace_archive'
				 if lsproject='DEMO' or lsproject='PANDORA' then
					lsMessage_archive=uf_method_trace_archive()
				 	gu_nvo_process_files.uf_write_log(lsMessage_archive) /*display msg to screen*/
				 	FileWrite(gilogFileNo,lsMessage_archive)
				end if
			// End -Dinesh - 11/21/2022- SIMS-125-    METHOD_TRACE_ARCHIVE to Archive method_trace_log_archive table
			// pvh - Ford
			Case 'u_nvo_proc_ford.uf_process_inventory_snapshot'
				If Not isvalid(u_nvo_proc_ncr) Then	
					lu_nvo_proc_ford = Create u_nvo_proc_ford
				End If
				lirC = lu_nvo_proc_ford.uf_process_inventory_snapshot()	
				
			Case 'u_nvo_proc_ford.uf_process_weekly_pick_rpt'
				If Not isvalid(u_nvo_proc_ncr) Then	
					lu_nvo_proc_ford = Create u_nvo_proc_ford
				End If
				lirC = lu_nvo_proc_ford.uf_process_weekly_pick_rpt()					
			// pvh - Ford 
			//
			// pvh - NCR
			Case 'u_nvo_proc_ncr.uf_process_inventory_snapshot'
				If Not isvalid(u_nvo_proc_ncr) Then	
					lu_nvo_proc_ncr = Create u_nvo_proc_ncr
				End If
				lu_nvo_proc_ncr.setWarehouse(lswarehouse)
				lirC = lu_nvo_proc_ncr.uf_process_inventory_snapshot()				
			// pvh - NCR
			
			//07-Feb-2013 :Madhu  Outbound confirmation Weekly Report -START
			Case 'u_nvo_proc_physio.uf_process_outbound_confirm_rpt'
				If Not isvalid(u_nvo_proc_physio) Then	
					lu_nvo_proc_physio = Create u_nvo_proc_physio
				End If
				lirC = lu_nvo_proc_physio.uf_process_outbound_confirm_rpt(asinifile,lsproject, lsemailString)			
			//07-Feb-2013 :Madhu  Outbound confirmation Weekly Report -END
				
			
			Case 'u_nvo_scheduled_functions.uf_movement_vs_boh_recon'
							
				If Not isvalid(lu_scheduled_functions) Then	
					lu_scheduled_functions = Create u_nvo_scheduled_functions
				End If
			
				lirc = lu_scheduled_functions.uf_movement_vs_boh_reconciliation(asinifile,lsactivityid,lsparmstring)

			Case 'u_nvo_edi_confirmations_maquet.uf_daily_files'
		
				If Not isvalid(lu_nvo_edi_confirmations_maquet) Then	
					lu_nvo_edi_confirmations_maquet = Create u_nvo_edi_confirmations_maquet
				End If
			
				lirC = lu_nvo_edi_confirmations_maquet.uf_process_daily_files(asinifile,lsemailString)
					
	
			//MAS - PHXBRANDS - 42611 - Short Shipped rpt process
			Case 'u_nvo_proc_phoenix.uf_process_short_shipped_rpt'
				
				If Not isvalid(lu_nvo_proc_phoenix) Then	
					lu_nvo_proc_phoenix = Create u_nvo_proc_phoenix
				End If
			
				liRC =  lu_nvo_proc_phoenix.uf_process_short_shipped_rpt(asinifile, lsemailString)

			Case 'u_nvo_proc_phoenix.uf_process_exception_rpt'
				
				If Not isvalid(lu_nvo_proc_phoenix) Then	
					lu_nvo_proc_phoenix = Create u_nvo_proc_phoenix
				End If
			
				liRC =  lu_nvo_proc_phoenix.uf_process_exception_rpt(asinifile, lsemailString)

			//Jxlim 11/09/2010 Phoenix Brands Warehouse Transfer Report
			Case 'u_nvo_proc_phoenix.uf_process_whtransf_rpt'
				
				If Not isvalid(lu_nvo_proc_phoenix) Then	
					lu_nvo_proc_phoenix = Create u_nvo_proc_phoenix
				End If
			
				liRC =  lu_nvo_proc_phoenix.uf_process_whtransf_rpt(asinifile, lsemailString)
						
			Case 'u_nvo_proc_pandora.uf_process_boh'
				
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_boh() 
				//Begin - Dinesh - 07/08/2021- S59147-Google - SIMS - Need to create new inventory snapshot				
			Case 'u_nvo_proc_pandora.uf_process_boh_sap'
				
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_boh_sap() 
				//End - Dinesh - 07/08/2021- S59147-Google - SIMS - Need to create new inventory snapshot	
// TAM 2009/11/20
			Case 'u_nvo_proc_pandora.uf_process_boh_rose'
				
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_boh_rose() 
				
				//08-Oct-2015 Madhu- As discussed with Tim, send notification alert to User -START
				liReturn =lu_nvo_proc_pandora.il_returnvalue 
				//If Return value 2 means, error out and send an email alert.
				If liReturn =2 THEN
					lsLogOut = "      Error ocurred to generate BIR and e-mail notification has sent to Pandora Onsite IT team " 
					FileWrite(gilogFileNo,lsLogOut)
					gu_nvo_process_files.uf_send_email("PANDORA",lsemailString , "Daily Inventory snapshot file (BIR)  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "There was a problem in the application that creates the BIR file and as a result the file was not generated."+&
					"There will be a re-try sent in next sweeper cycle in approximately 10 min.", "")
				End If
				//08-Oct-2015 Madhu- As discussed with Tim, send notification alert to User -END
		
////Jxlim 03/09/2012 Re-open BRD #366Pandora Hourly Inventory Snapshot
//Jxlim 02/20/2012 	commente out  BRD #366Pandora Hourly Inventory Snapshot; ICC could not accept the file with the same name and over sized.
////Jxlim 02/08/2012 BRD #366Pandora Hourly Inventory Snapshot
			Case 'u_nvo_proc_pandora.uf_process_boh_hourly'
				
				// ET3 Pandora 422 - don't run queued hourly reports
				if ( (hour(now()) + llServerOffset) - hour(ltmLocalRunTime)) > 1  then				
					// skip this particular running of the report
					lsLogOut = "      Skipping redundant Pandora Hourly Inventory Report ... " 
					FileWrite(gilogFileNo,lsLogOut)

				else
					If Not isvalid(lu_nvo_proc_pandora) Then	
						lu_nvo_proc_pandora = Create u_nvo_proc_pandora
					End If
					liRC =  lu_nvo_proc_pandora.uf_process_boh_hourly() 
					
				end if

			// LTK 20140911  Added Pandora hourly Receiving Report
			Case 'u_nvo_proc_pandora.uf_process_hourly_receiving'
				
				if ( (hour(now()) + llServerOffset) - hour(ltmLocalRunTime)) > 1  then				
					// skip this particular running of the report
					lsLogOut = "      Skipping redundant Pandora Hourly Receiving Report ... " 
					FileWrite(gilogFileNo,lsLogOut)

				else
					If Not isvalid(lu_nvo_proc_pandora) Then	
						lu_nvo_proc_pandora = Create u_nvo_proc_pandora
					End If
					liRC =  lu_nvo_proc_pandora.uf_process_hourly_receiving() 
					
				end if

			// LTK 20141020  Added Pandora MIM Outbound Report
			Case 'u_nvo_proc_pandora.uf_process_mim_outbound_report'

				if ( (hour(now()) + llServerOffset) - hour(ltmLocalRunTime)) > 1  then				
					// skip this particular running of the report
					lsLogOut = "      Skipping redundant Pandora MIM Outbound Report ... " 
					FileWrite(gilogFileNo,lsLogOut)

				else
					If Not isvalid(lu_nvo_proc_pandora) Then	
						lu_nvo_proc_pandora = Create u_nvo_proc_pandora
					End If
					liRC =  lu_nvo_proc_pandora.uf_process_mim_outbound_report() 

				end if

			Case 'u_nvo_proc_pandora.uf_process_data_dump'
				//8/2014 - now using proc pandora2
				If Not isvalid(lu_nvo_proc_pandora2) Then	
					lu_nvo_proc_pandora2 = Create u_nvo_proc_pandora2
				End If
				liRC =  lu_nvo_proc_pandora2.uf_process_data_dump(asinifile)

				//TimA 04/15/2011 Pandora Issue #190
			Case 'uf_process_cityblock_inbound_rpt'
				
				If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
					lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
				End If
				liRC =  lu_nvo_edi_confirmations_pandora.uf_process_cityblock_Inbound_rpt(lsproject)
				
			Case 'uf_process_cityblock_inventory_rpt'
				 
				If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
					lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
				End If
				liRC =  lu_nvo_edi_confirmations_pandora.uf_process_cityblock_inventory_rpt()
				
			Case 'uf_process_cityblock_outbound_rpt'
				
				If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
					lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
				End If
				liRC =  lu_nvo_edi_confirmations_pandora.uf_process_cityblock_outbound_rpt()
				
			Case 'uf_process_kittyhawk_daily_rpt'
				
				If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
					lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
				End If
				liRC =  lu_nvo_edi_confirmations_pandora.uf_process_kittyhawk_daily_rpt()
				
			Case 'uf_process_kittyhawk_movement_rpt'
				
				If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
					lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
				End If
				liRC =  lu_nvo_edi_confirmations_pandora.uf_process_kittyhawk_movement_rpt()
	
	//jla 2010/01/10
	
			Case 'u_nvo_edi_confirmations_pandora.uf_decom_inv_rpt'
				
				// ET3 Pandora 422 - don't run queued hourly reports
				if ( (hour(now()) + llServerOffset) - hour(ltmLocalRunTime)) > 1  then				
					// skip this particular running of the report
					lsLogOut = "      Skipping redundant Pandora Hourly DECOM Inventory Report ... " 
					FileWrite(gilogFileNo,lsLogOut)

				else
					If Not isvalid(lu_nvo_edi_confirmations_pandora) Then	
						lu_nvo_edi_confirmations_pandora = Create u_nvo_edi_confirmations_pandora
					End If
					liRC =  lu_nvo_edi_confirmations_pandora.uf_decom_inv_rpt()
					
				end if
			
			Case 'uf_process_pandora_decom_mrb_aging_rpt'
				
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_pandora_decom_mrb_aging_rpt(asinifile, lsEmailString) 

				
			Case 'uf_process_pandora_open_rma_po_receipt_rpt'
				
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_pandora_open_rma_po_rpt(asinifile, lsEmailString) 
										
				
				
			Case 'u_nvo_proc_philips_sg.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_philips_sg) Then	
					lu_nvo_proc_philips_sg = Create u_nvo_proc_philips_sg
				End If
			
				liRC =  lu_nvo_proc_philips_sg.uf_process_dboh()

			Case 'u_nvo_proc_philips_sg.uf_process_dboh_volume'
				
				If Not isvalid(lu_nvo_proc_philips_sg) Then	
					lu_nvo_proc_philips_sg = Create u_nvo_proc_philips_sg
				End If
			
				liRC =  lu_nvo_proc_philips_sg.uf_process_dboh_volume()				
				
				
			Case 'u_nvo_proc_philips_th.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_philips_th) Then	
					lu_nvo_proc_philips_th = Create u_nvo_proc_philips_th
				End If
			
				liRC =  lu_nvo_proc_philips_th.uf_process_dboh()
			
				
			Case 'u_nvo_proc_philips_th.uf_process_dboh_volume'
				
				If Not isvalid(lu_nvo_proc_philips_th) Then	
					lu_nvo_proc_philips_th = Create u_nvo_proc_philips_th
				End If
			
				liRC =  lu_nvo_proc_philips_th.uf_process_dboh_volume()				

			Case 'u_nvo_proc_philips_cls.uf_process_dboh'  // TAM 2019/02/14 S29551
				
				If Not isvalid(lu_nvo_proc_philips_cls) Then	
					lu_nvo_proc_philips_cls = Create u_nvo_proc_philips_cls
				End If
			
				//dts - 10/29/2020 - S50979 - added project parameter as we're now using this for PHILIPS-DA as well
				//liRC =  lu_nvo_proc_philips_cls.uf_process_dboh()
				liRC =  lu_nvo_proc_philips_cls.uf_process_dboh(lsProject)


			Case 'u_nvo_proc_lmc.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_lmc) Then	
					lu_nvo_proc_lmc = Create u_nvo_proc_lmc
				End If
			
				liRC =  lu_nvo_proc_lmc.uf_process_dboh(lsParmString)
				
			Case 'u_nvo_proc_bosch.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_bosch) Then	
					lu_nvo_proc_bosch = Create u_nvo_proc_bosch
				End If
			
//TAM 4/2015 - Changed parameters for the call
//				liRC =  lu_nvo_proc_bosch.uf_process_dboh(asinifile,lsemailString)
				liRC = lu_nvo_proc_bosch.uf_process_dboh(lsproject, asinifile)
				
			Case 'u_nvo_proc_sg_muser.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_sg_muser) Then	
					lu_nvo_proc_sg_muser = Create u_nvo_proc_sg_muser
				End If
			
				liRC =  lu_nvo_proc_sg_muser.uf_process_dboh()

			
			Case 'uf_process_inventory_by_sku_rpt'
				
				If Not isvalid(lu_nvo_proc_puma) Then	
					lu_nvo_proc_puma = Create u_nvo_proc_puma
				End If
				liRC =  lu_nvo_proc_puma.uf_process_inventory_by_sku_rpt(asinifile, lsEmailString, lsParmString) 		
				
			//MEA 12-2012: Process the W&S Inventory By Sku Report.	
			Case 'uf_process_inventory_by_sku_ws_rpt'
				
				If Not isvalid(lu_nvo_proc_ws) Then	
					lu_nvo_proc_ws = Create u_nvo_proc_ws
				End If
				liRC =  lu_nvo_proc_ws.uf_process_inventory_by_sku_rpt(lsProject, asinifile, lsEmailString, lsParmString) 						
								
				
				
			//BCR 26-JAN-2012: Process the Puma Outbound Order Report.	
			Case 'uf_process_outbound_order_rpt'
				
				If Not isvalid(lu_nvo_proc_puma) Then	
					lu_nvo_proc_puma = Create u_nvo_proc_puma
				End If
				liRC =  lu_nvo_proc_puma.uf_process_outbound_order_rpt(asinifile, lsEmailString) 	
				
			//BCR 20-MAR-2012: Process the DANA-TH Summary Inventory Report.	
			Case 'u_nvo_proc_dana_th.uf_process_sum_inv_rpt'
				
				If Not isvalid(u_nvo_proc_dana_th) Then	
					lu_nvo_proc_dana_th = Create u_nvo_proc_dana_th
				End If
				liRC =  lu_nvo_proc_dana_th.uf_process_sum_inv_rpt(asinifile, lsEmailString) 
				
			//20-May-2016 :Madhu Process the DANA-RAY Summary Inventory Report.
			Case 'u_nvo_proc_dana_ray.uf_process_sum_inv_rpt'
				If Not isvalid(u_nvo_proc_dana_ray) Then	
					lu_nvo_proc_dana_ray = Create u_nvo_proc_dana_ray
				End If
				liRC =  lu_nvo_proc_dana_ray.uf_process_sum_inv_rpt(asinifile, lsEmailString) 
			
			Case 'u_nvo_proc_pandora2.f_exportclearingfile'
				If Not isvalid(lu_nvo_proc_pandora2) Then	
					lu_nvo_proc_pandora2 = Create u_nvo_proc_pandora2
				End If 
				lbRC =  lu_nvo_proc_pandora2.f_exportclearingfile()
				
			// BCR 04-AUG-2011: TRAX EOD Auto-Posting
			Case 'uf_process_trax_eod'
				
				liRC =  THIS.uf_process_trax_eod(lsproject,lswarehouse,lsparmstring,ldtLastRunTime,lsEmailString,lsEmailSubject)	

			//MEA - 09/11 - Added DBOH for generic
			
			Case 'u_nvo_proc_baseline_unicode.uf_process_dboh'

				If Not isvalid(lu_nvo_proc_baseline_unicode) Then	
					lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode
				End If 
				
				liRC = lu_nvo_proc_baseline_unicode.uf_process_dboh(lsproject, asinifile)


			//TAM - 01/2012 - Added DBOH for riverbed
			
			Case 'u_nvo_proc_riverbed.uf_process_dboh'

				If Not isvalid(lu_nvo_proc_riverbed) Then	
					lu_nvo_proc_riverbed = Create u_nvo_proc_riverbed
				End If 
				
				liRC = lu_nvo_proc_riverbed.uf_process_dboh(lsproject, asinifile)

			//MEA - 12/11 - Added to reset Inbound/Outbound Sequence Numbers
				
			Case 'u_nvo_proc_newera.uf_process_mww_csv_export'
				
				If Not isvalid(lu_nvo_proc_newera) Then	
					lu_nvo_proc_newera = Create u_nvo_proc_newera
				End If 
				
				liRC = lu_nvo_proc_newera.uf_process_mww_csv_export(lsproject, asinifile)


			Case 'u_nvo_proc_newera.uf_process_mww_csv_export_mx'
				
				If Not isvalid(lu_nvo_proc_newera) Then	
					lu_nvo_proc_newera = Create u_nvo_proc_newera
				End If 
				
				liRC = lu_nvo_proc_newera.uf_process_mww_csv_export_mx(lsproject, asinifile)
				
			Case 'u_nvo_proc_stryker.uf_process_dboh'

				If Not isvalid(lu_nvo_proc_stryker) Then	
					lu_nvo_proc_stryker = Create u_nvo_proc_stryker
				End If 
				
				liRC = lu_nvo_proc_stryker.uf_process_dboh(lsproject, asinifile)

			Case 'u_nvo_proc_tpv.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_tpv) Then	
					lu_nvo_proc_tpv = Create u_nvo_proc_tpv
				End If
			
				liRC =  lu_nvo_proc_tpv.uf_process_dboh()
				
			//28-May-2013 : Madhu - Daily Avail Inventory Report- START
			Case  'u_nvo_proc_stryker.uf_process_daily_inventory_rpt'
				If Not isvalid(lu_nvo_proc_stryker) Then
					lu_nvo_proc_stryker =Create u_nvo_proc_stryker
				End If
				
				liRC =lu_nvo_proc_stryker.uf_process_daily_inventory_rpt(asinifile,lsproject, lsemailString)
			
			//28-May-2013 : Madhu - Daily Avail Inventory Report- END

			Case 'u_nvo_proc_tpv.uf_process_dboh_volume'
				
				If Not isvalid(lu_nvo_proc_tpv) Then	
					lu_nvo_proc_tpv = Create u_nvo_proc_tpv
				End If
			
				liRC =  lu_nvo_proc_tpv.uf_process_dboh_volume()	
				
			Case 'u_nvo_proc_nycsp.uf_process_dboh' //TAM 2012/11/09
				
				If Not isvalid(lu_nvo_proc_nycsp) Then	
					lu_nvo_proc_nycsp = Create u_nvo_proc_nycsp
				End If
			
				liRC =  lu_nvo_proc_nycsp.uf_process_dboh(lsproject, asinifile)
				
			Case 'u_nvo_proc_nycsp.uf_process_inventory_snapshot' //TAM 2016/06
				
				If Not isvalid(lu_nvo_proc_nycsp) Then	
					lu_nvo_proc_nycsp = Create u_nvo_proc_nycsp
				End If
			
				liRC =  lu_nvo_proc_nycsp.uf_process_inventory_snapshot(lsproject, asinifile)
				
			Case 'u_nvo_proc_starbucks_th.uf_gr' // 04/13 - PCONKL - Starbucks Daily GR file
				
				lsLogOut = '  Calling u_nvo_edi_confirmations_starbucks_th.uf_gr'
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
				FileWrite(gilogFileNo,lsLogOut)
				
				If Not isvalid(lu_nvo_proc_starbucks_th) Then	
					lu_nvo_proc_starbucks_th = Create u_nvo_edi_confirmations_starbucks_th

				lsLogOut = '  CREATED u_nvo_edi_confirmations_starbucks_th.uf_gr#1'
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
				FileWrite(gilogFileNo,lsLogOut)
					
				End If

				lsLogOut = '  Calling u_nvo_edi_confirmations_starbucks_th.uf_gr#1'
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
				FileWrite(gilogFileNo,lsLogOut)
			
				liRC =  lu_nvo_proc_starbucks_th.uf_gr()
				
				lsLogOut = '  Calling u_nvo_edi_confirmations_starbucks_th.uf_gr : ' + STRING(LIRC)
				gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
				FileWrite(gilogFileNo,lsLogOut)				
				
			Case 'u_nvo_proc_starbucks_th.uf_gi' // 04/13 - PCONKL - Starbucks Daily GI file
				
				If Not isvalid(lu_nvo_proc_starbucks_th) Then	
					lu_nvo_proc_starbucks_th = Create u_nvo_edi_confirmations_starbucks_th
				End If
			
				liRC =  lu_nvo_proc_starbucks_th.uf_gi()
				
			
			//28-May-2013 : Madhu - Daily Avail Inventory Report- START
			Case  'u_nvo_proc_starbucks_th.uf_process_daily_inv_rpt'
				If Not isvalid( lu_nvo_proc_starbucks) Then
					 lu_nvo_proc_starbucks =Create u_nvo_proc_starbucks_th
				End If
				
				liRC = lu_nvo_proc_starbucks.uf_process_daily_inventory_rpt(asinifile,lsproject, lsemailString)
			//28-May-2013 : Madhu - Daily Avail Inventory Report- END
			
			//20-Jan-2014 :Madhu - Daily Inventory Reports for FRIEDRICH -START
			//Daily Avail Inventory Report
			Case  'u_nvo_proc_friedrich.uf_process_daily_all_inv_rpt'
				If Not isvalid(lu_nvo_proc_friedrich) Then
					lu_nvo_proc_friedrich = Create u_nvo_proc_friedrich
				End If
	
			liRC =lu_nvo_proc_friedrich.uf_process_daily_all_inv_rpt(asinifile,lsproject,lsemailString)
			
			//Daily Serial Inventory Report
			Case  'u_nvo_proc_friedrich.uf_process_serial_inv_rpt'
				If Not isvalid(lu_nvo_proc_friedrich) Then
					lu_nvo_proc_friedrich = Create u_nvo_proc_friedrich
				End If
	
			liRC =lu_nvo_proc_friedrich.uf_process_serial_inv_rpt(asinifile,lsproject,lsemailString)
			
			//Daily Outbound Report
			Case 'u_nvo_proc_friedrich.uf_process_outbound_rpt'
			If Not isvalid(lu_nvo_proc_friedrich) Then
				lu_nvo_proc_friedrich = Create u_nvo_proc_friedrich
			End If
			
			liRC = lu_nvo_proc_friedrich.uf_process_outbound_rpt(asinifile,lsproject,lsemailString)
			
			//Daily Inbound Report
			Case 'u_nvo_proc_friedrich.uf_process_inbound_rpt'
			If Not isvalid(lu_nvo_proc_friedrich) Then
				lu_nvo_proc_friedrich = Create u_nvo_proc_friedrich
			End If
			
			liRC = lu_nvo_proc_friedrich.uf_process_inbound_rpt(asinifile,lsproject,lsemailString)
			//20-Jan-2014 :Madhu - Daily Inventory Report for FRIEDRICH -END
			
			
			//11-feb-2014  Neha  - Daily Avail Inventory Report- START
			Case  'u_nvo_proc_petha.uf_process_daily_inventory_petha'
				If Not isvalid( lu_nvo_proc_petha) Then
					 lu_nvo_proc_petha =Create u_nvo_proc_petha
				End If
				
				liRC = lu_nvo_proc_petha.uf_process_daily_inventory_petha(asinifile,lsproject, lsemailString)
			
			//08-08-2014  Neha - Daily Avail Inventory Report TH-MUSER 
			Case  'u_nvo_proc_th_muser.uf_process_daily_inv_th_muser'
				If Not isvalid( lu_nvo_proc_th_muser) Then
					 lu_nvo_proc_th_muser =Create u_nvo_proc_th_muser
				End If
				
				liRC = lu_nvo_proc_th_muser.uf_process_daily_inv_th_muser(asinifile,lsproject, lsemailString,lswarehouse)
			//08-08-2014  Neha - Daily Avail Inventory Report TH-MUSER- END

			Case 'u_nvo_proc_physio.uf_process_dboh' //MEA 3/2012
				
				If Not isvalid(lu_nvo_proc_physio) Then	
					lu_nvo_proc_physio = Create u_nvo_proc_physio
				End If
			
				liRC =  lu_nvo_proc_physio.uf_process_dboh(lsproject, asinifile)			
				
			Case 'u_nvo_proc_kinderdijk.uf_process_dboh_volume'		//Jxlim 05/12/2013 Kinderdijk Boh volume
				
				If Not isvalid(lu_nvo_proc_kinderdijk) Then	
					lu_nvo_proc_kinderdijk = Create u_nvo_proc_kinderdijk
				End If
			
				liRC =  lu_nvo_proc_kinderdijk.uf_process_dboh_volume()	
				
			Case 'u_nvo_proc_kinderdijk.uf_process_daily_recon'		//Jxlim 05/12/2013 Kinderdijk Daily reconcialition
				
				If Not isvalid(lu_nvo_proc_kinderdijk) Then	
					lu_nvo_proc_kinderdijk = Create u_nvo_proc_kinderdijk
				End If
			
				liRC =  lu_nvo_proc_kinderdijk.uf_process_daily_recon(lsproject, asinifile)	
				
			Case 'u_nvo_proc_funai.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_funai) Then	
					lu_nvo_proc_funai= Create u_nvo_proc_funai
				End If
			
				liRC =  lu_nvo_proc_funai.uf_process_dboh()				

			Case 'u_nvo_proc_funai.uf_process_dboh_volume'
				
				If Not isvalid(lu_nvo_proc_funai) Then	
					lu_nvo_proc_funai = Create u_nvo_proc_funai
				End If
			
				liRC =  lu_nvo_proc_funai.uf_process_dboh_volume()				
				
			Case 'u_nvo_proc_gibson.uf_process_dboh'
				
				If Not isvalid(lu_nvo_proc_gibson) Then	
					lu_nvo_proc_gibson= Create u_nvo_proc_gibson
				End If
			
				liRC =  lu_nvo_proc_gibson.uf_process_dboh()				

			Case 'u_nvo_proc_gibson.uf_process_dboh_volume'
				
				If Not isvalid(lu_nvo_proc_gibson) Then	
					lu_nvo_proc_gibson = Create u_nvo_proc_gibson
				End If
			
				liRC =  lu_nvo_proc_gibson.uf_process_dboh_volume()				
				
			Case  'u_nvo_proc_friedrich.uf_process_dboh' /* 11/13 - PCONKL*/
				
				If Not isvalid( lu_nvo_edi_confirmations_friedrich) Then
					 lu_nvo_edi_confirmations_friedrich =Create u_nvo_edi_confirmations_friedrich
				End If
				
				liRC = lu_nvo_edi_confirmations_friedrich.uf_process_dboh(asinifile,lsproject)
				
			Case  'u_nvo_proc_friedrich.uf_process_orders_to_otm' /* 11/13 - PCONKL*/
				
				If Not isvalid( lu_nvo_edi_confirmations_friedrich) Then
					 lu_nvo_edi_confirmations_friedrich =Create u_nvo_edi_confirmations_friedrich
				End If
				
				liRC = lu_nvo_edi_confirmations_friedrich.uf_process_orders_to_otm(asinifile,lsproject,lswarehouse)
				
			Case 'u_nvo_proc_garmin.uf_process_dboh'		//Jxlim 04/30/2014 Garmin Boh volume
				
				If Not isvalid(lu_nvo_proc_garmin) Then	
					lu_nvo_proc_garmin = Create u_nvo_proc_garmin
				End If
			
				liRC = lu_nvo_proc_garmin.uf_process_dboh(lsproject, asinifile,lsemailString)
				
			Case 'u_nvo_proc_nyx.uf_process_dboh'		//TAM 05/7/2014 NYX Boh volume
				
				If Not isvalid(lu_nvo_proc_nyx) Then	
					lu_nvo_proc_nyx = Create u_nvo_proc_nyx
				End If
			
				liRC = lu_nvo_proc_nyx.uf_process_dboh(lsproject, asinifile)

			Case 'u_nvo_proc_nyx.uf_process_dboh_kits'		//TAM 01/1/2016 NYX Boh volume for Kit Inventory
				
				If Not isvalid(lu_nvo_proc_nyx) Then	
					lu_nvo_proc_nyx = Create u_nvo_proc_nyx
				End If
			
				liRC = lu_nvo_proc_nyx.uf_process_dboh_kits(lsproject, asinifile)

			Case 'u_nvo_proc_anki.uf_process_dboh'		//Jxlim 08/28/2014 15 minutes BOH
				
				If Not isvalid(lu_nvo_proc_anki) Then	
					lu_nvo_proc_anki = Create u_nvo_proc_anki
				End If
			
				liRC = lu_nvo_proc_anki.uf_process_dboh(lsproject, asinifile)

			Case 'u_nvo_proc_pandora.uf_process_confirmation_check'
				//12/19/14 - dts - check for orders that were confirmed but didn't create the confirmation batch_transaction record
				If Not isvalid(lu_nvo_proc_pandora) Then	
					lu_nvo_proc_pandora = Create u_nvo_proc_pandora
				End If
				liRC =  lu_nvo_proc_pandora.uf_process_confirmation_check()

			Case  'u_nvo_edi_confirmations_h2o.uf_process_dboh' /* 2016/04 - TAM*/
				
				If Not isvalid( lu_nvo_edi_confirmations_h2o) Then
					 lu_nvo_edi_confirmations_h2o =Create u_nvo_edi_confirmations_h2o
				End If
				
				liRC = lu_nvo_edi_confirmations_h2o.uf_process_dboh(lsproject, asinifile)
				
			Case 'u_nvo_proc_kendo.uf_process_dboh'		// 04/16 - PCONKL
				
				If Not isvalid(lu_nvo_proc_kendo) Then	
					lu_nvo_proc_kendo = Create u_nvo_proc_kendo
				End If
			
				liRC = lu_nvo_proc_kendo.uf_process_dboh(lsproject, asinifile, lswarehouse)
				
			//    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -Start 
	      // Case 'u_nvo_proc_kendo.uf_process_inv_type_update'
				
				//If Not isvalid(lu_nvo_proc_kendo) Then	
					//lu_nvo_proc_kendo = Create u_nvo_proc_kendo
				//End If
              // liRC =  lu_nvo_proc_kendo.uf_process_inv_type_update(lsproject) 
		//    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -End 
 
          //    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -Start 
	       Case 'u_nvo_proc_kendo.uf_process_inv_type_update'
				
				If Not isvalid(lu_nvo_proc_kendo_xerox) Then	
					lu_nvo_proc_kendo_xerox = Create u_nvo_proc_kendo
				End If
               liRC =  lu_nvo_proc_kendo_xerox.uf_process_inv_type_update(lsproject) 
		//    Dhirendra-  S57452  KDO - Kendo:  SIMS New Inventory Type, update process and messages -End 
 
			Case 'u_nvo_proc_hager_my.uf_process_boh'
								
				If Not isvalid(lu_nvo_proc_hager_my) Then	
					lu_nvo_proc_hager_my = Create u_nvo_proc_hager_my
				End If
			
				liRC = lu_nvo_proc_hager_my.uf_process_boh(asinifile, lsEmailString)
				
			//14-Nov-2017 :Madhu PEVS-806 - 3PL Cycle Count Orders
			Case 'u_nvo_proc_pandora2.uf_create_system_cycle_counts'
				If Not isvalid(lu_nvo_proc_Pandora2) Then
					lu_nvo_proc_Pandora2 = Create u_nvo_proc_Pandora2
				End If
				//SIMS-80 Added by Dhirendra , lsParmString parameter added to drive dc_class_code and dc_frequency 
				// with same function lu_nvo_proc_Pandora2.uf_create_system_cycle_counts
				
			   //  liRC = lu_nvo_proc_Pandora2.uf_create_system_cycle_counts( lsproject, lswarehouse)
				liRC = lu_nvo_proc_Pandora2.uf_create_system_cycle_counts( lsproject, lswarehouse,lsParmString)

			Case 'u_nvo_proc_pandora2.uf_process_cc_inv_snapshot'
				If Not isvalid(lu_nvo_proc_Pandora2) Then
					lu_nvo_proc_Pandora2 = Create u_nvo_proc_Pandora2
				End If
				
				liRC = lu_nvo_proc_Pandora2.uf_process_cc_inv_snapshot( asinifile, lsproject)
				
			Case 'u_nvo_proc_pandora2.uf_process_cc_eod_report'
				If Not isvalid(lu_nvo_proc_Pandora2) Then
					lu_nvo_proc_Pandora2 = Create u_nvo_proc_Pandora2
				End If
				
				liRC = lu_nvo_proc_Pandora2.uf_process_cc_eod_report( asinifile, lsproject, ldtNextRunTime)

			//18-APR-2018 :Madhu S18357 - COTY - Inventory Snapshot	
			Case 'u_nvo_proc_coty.uf_process_dboh'
				If Not isValid(lu_nvo_proc_coty) Then
					lu_nvo_proc_coty = Create u_nvo_proc_coty
				End If
				liRC = lu_nvo_proc_coty.uf_process_dboh(lsproject, asinifile)
				
			//TAM 2018/11/29  S25784 - REMA - OM inventory Sync
			Case 'u_nvo_proc_rema.uf_sync_om_inventory'
				
				If Not isvalid(lu_nvo_proc_rema) Then	
					lu_nvo_proc_rema = Create u_nvo_proc_rema
				End If
				liRC =  lu_nvo_proc_rema.uf_sync_om_inventory(lsproject)
				
			//07-Jan-2019 :Madhu S27852 - CREE Delivery Order Report
		Case 'u_nvo_proc_cree.uf_process_delivery_report'
			If Not isValid(lu_nvo_proc_cree) Then
				lu_nvo_proc_cree = Create u_nvo_proc_cree
			End If
			
			lu_nvo_proc_cree.uf_process_delivery_report( asinifile, lsproject, ldtNextRunTime)
		
		//1-MAR-2019 :Madhu S29975 PhilipsBlueHeart Daily Lot Info
		Case 'u_nvo_proc_philips_cls.uf_process_daily_lot_info'
			If Not isValid(lu_nvo_proc_philips_cls) Then
				lu_nvo_proc_philips_cls = create u_nvo_proc_philips_cls
			End If
			lu_nvo_proc_philips_cls.uf_process_daily_lot_info( lsproject, asinifile, ldtNextRunTime)

		//GailM 9/30/2019 S38447 F18587 Bosch retrigger 945 on socket error
		Case 'u_nvo_edi_confirmations_bosch.uf_process_945error'
			If Not isValid(lu_nvo_edi_confirmations_bosch) Then
				lu_nvo_edi_confirmations_bosch = create u_nvo_edi_confirmations_bosch
			End If
			lu_nvo_edi_confirmations_bosch.uf_process_945error( lsproject, asinifile)

	End Choose
		
		
		
	End If /*Scheduled to run today*/

	// Reset the Last Run Time(Current Server Time) and Next Run Time (in Server Time)
	
	ldsFunctions.SetItem(llFunctionRowPos,'Last_Run_Time',dateTime(today(),now()))
	
	// Calculate the Next Run Time to run the Function based on (today + 1 day) + (local run time(hh:mm) + server offset)
	llHour = hour(ltmLocalRunTime) - llServerOffset
	llMin  = Minute(ltmLocalRunTime)
	If llHour >= 24 then
		llhour = llhour - 24
	ElseIf llhour < 0 then
		llhour = 24 + llhour
	End If
	
	//05-Oct-2015 :Madhu- As discussed with Tim, 
	//If Pandora DBOH Return value is 2, instead to change Next Run Time Date, retry to generate BOH in next Loop -START
	If liReturn <> 2 THEN
		lsnextruntime = string(llhour) + ':' + String(llmin,'##') + ':00.000'
		ldtnextRunTime= datetime(relativeDate(today(),1),time(LsNextRunTime))
		ldsFunctions.SetItem(llFunctionRowPos,'Next_Run_Time', ldtnextRunTime)
	END IF
	//05-Oct-2015 :Madhu- If Pandora DBOH Return value is 2, instead to change Next Run Time Date, retry to generate BOH in next Loop -END

Next /* Function to Process*/

// JLA 01/12/2010


IF llFunctionRowCount > 0 Then
	
	liRC = ldsFunctions.Update()
	If liRC = 1 Then
		Commit;
	Else
		Rollback;
		lsMessage= SQLCA.SQLErrText
		lsLogOut =  "  ***System Error!  Unable to save the Run Dates  to the database file: Activity_Schedule" + lsMessage
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
//		Return -1
	End If
End If


Return 0
end function

public function integer uf_process_trax_eod (string asproject, string aswarehouse, string asparmstring, datetime adtlastruntime, string asemailstring, string asemailsubject);//BCR 4-AUG-11: Create a TRAX End of Day auto-posting transaction to Websphere for one or more project/wh/carrier combination...

Long		llRowCount, llRowPos, llBeginPos, llEndPos
String 	lsXML, lsXMLResponse, lsReturnCode, lsReturnDesc, lsBeginTag, lsEndTag, lsBatchID, lsLabels, lsWarehouse, lsLocale, lsMessage
String     lsLogOut
Boolean	lbvalid
integer  lirc

u_nvo_websphere_post	lu_websphere

lu_websphere = Create u_nvo_websphere_post

//add the Header segment
lsXML = lu_websphere.uf_request_header("TraxEODShipmentRequest")

//For each Project/WH/Carrier row, create an XML segment to pass to Websphere
lsXML += "<EOD>"
lsXML += "<Project>" + asProject + "</Project>"
lsXML += "<Warehouse>" + asWarehouse + "</Warehouse>"



//MEA - 11/12 - Added Packlocation to ParmString (seperated by ,)
//Example: UPS,A3118     (Carrier),(PackLocation) - Pass if different than default. PackLocation not required.

integer liPos

liPos= Pos(asParmString, ",", 1)

if liPos > 0 then
	
	lsXML += "<Carrier>" + left(asParmString, liPos -1) + "</Carrier>"
	lsXML += "<PackLocation>" + mid(asParmString, liPos +1) + "</PackLocation>"
	
else

	lsXML += "<Carrier>" + asParmString + "</Carrier>"

end if

lsXML += "<FromDate>" + String((adtLastRunTime),"MM/dd/yyyy HH:mm") + "</FromDate>"
lsXML += "<ToDate>" + String(dateTime(today(),now()),"MM/dd/yyyy HH:mm") + "</ToDate>"
lsXML += "</EOD>"
	
//Add the footer
lsXML = lu_websphere.uf_request_footer(lsXML)

//post the transaction to Websphere
lsXMLResponse = lu_websphere.uf_post_url(lsXML)

//Write out the response...just for reference in case of error
FileWrite(gilogFileNo,lsXMLResponse)

//Process the response...

//If we didn't receive an XML back, there is a fatal exception error
If pos(Upper(lsXMLResponse),"SIMSRESPONSE") = 0 Then
	lsLogOut =  "  ***Websphere Fatal Exception Error!  Unable to auto-post TRAX EOD for " + asproject + "/" + aswarehouse + "/" + asparmstring
	FileWrite(gilogFileNo,lsLogOut)
	gu_nvo_process_files.uf_writeError(lsLogOut)
	gu_nvo_process_files.uf_send_email(asProject,asEmailString,asEmailSubject,lsLogOut,'') 
	Return -1
End If

//Check the return code and return description for any trapped errors
lsReturnCode = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"returncode")
lsReturnDesc = lu_websphere.uf_get_xml_single_Element(lsXMLResponse,"errormessage")

Choose Case lsReturnCode
		
	Case "-99" /* Websphere non fatal exception error*/
		
		lsLogOut =  "  ***Websphere Operational Exception Error!  Unable to auto-post TRAX EOD for " + asproject + "/" + aswarehouse + "/" + asparmstring + " due to " + lsReturnDesc
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
		gu_nvo_process_files.uf_send_email(asProject,asEmailString,asEmailSubject,lsLogOut,'')
		Return -1

	Case "-1" /* unable to process EOD on one or more carriers*/
		
		lsLogOut =  "  ***TRAX EOD processing error!  Unable to auto-post TRAX EOD for " + asproject + "/" + aswarehouse + "/" + asparmstring + " due to " + lsReturnDesc
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogOut)
		gu_nvo_process_files.uf_send_email(asProject,asEmailString,asEmailSubject,lsLogOut,'')
		Return -1
		
	Case Else
		
		If lsReturnDesc > '' Then
			lsLogOut =  "  ***TRAX EOD Undefined processing error!  Unable to auto-post TRAX EOD for " + asproject + "/" + aswarehouse + "/" + asparmstring + " due to " + lsReturnDesc
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_writeError(lsLogOut)
			gu_nvo_process_files.uf_send_email(asProject,asEmailString,asEmailSubject,lsLogOut,'')
			Return -1
		Else
			lsLogOut =  "  ***TRAX EOD processing Successful!  Able to auto-post TRAX EOD for " + asproject + "/" + aswarehouse + "/" + asparmstring 
			FileWrite(gilogFileNo,lsLogOut)
			gu_nvo_process_files.uf_send_email(asProject,asEmailString,asEmailSubject,lsLogOut,'')
		End If
		
End Choose

Return 0


end function

public function string uf_method_trace_archive ();// Begin -Dinesh - 11/23/2022- SIMS-125   METHOD_TRACE_ARCHIVE to Archive method_trace_log_archive table
long ll_count,ll_days,llrc,lirc1,llcount
string ls_msg
date ldate_method_trace
datastore lds_Method_Trace_Log
datastore lds_Method_Trace_Log_archive
long ll_Trans_Id,ll_Spid,i,llcountarchive
string ls_Project_ID,ls_UserId,ls_Login_Name,ls_Application_Name,ls_Object_Name
String ls_Method_Desc_Enter,ls_System_No
date ld_Method_Enter_Dt,ld_Method_Exit_Dt,ld_calculate_date_to
string ls_Method_Desc_Exit,ls_Purge_Flg
//create datastore lds_Method_Trace_Log
//select  code_id into :ll_days from lookup_table where code_type='METHOD_TRACE_ARCHIVE_DAYS' and project_id='*ALL';
select count(*) into :ll_count from method_trace_SP_log where Method_Enter_Dt < getdate()- 7 ;
//ldate_method_trace= today()
//ld_calculate_date_to = date(RelativeDate(ldate_method_trace, - ll_days ))

		DECLARE lsp_method_trace_SP_log_archive PROCEDURE FOR dbo.sp_method_trace_SP_log_archive 
		USING SQLCA;
		
		EXECUTE lsp_method_trace_SP_log_archive;
		 
		IF SQLCA.SQLCode = -1 THEN
			ls_msg = 'METHOD TRACE ARCHIVE is unsuccessful with this error' + ' ' + SQLCA.SQLErrText
		ELSE
			ls_msg ='METHOD TRACE ARCHIVE is successfully completed, Total record(s) ' + String(ll_count) + ' is/are archived on method_trace_log_archive table.'
			
		END IF

return ls_msg
// End -Dinesh - 11/23/2022- SIMS-125 -   METHOD_TRACE_ARCHIVE to Archive method_trace_log_archive table
end function

on u_nvo_proc_scheduled_activity.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_scheduled_activity.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

