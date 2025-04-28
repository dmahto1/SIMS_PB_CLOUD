HA$PBExportHeader$u_nvo_proc_phc.sru
forward
global type u_nvo_proc_phc from nonvisualobject
end type
end forward

global type u_nvo_proc_phc from nonvisualobject
end type
global u_nvo_proc_phc u_nvo_proc_phc

type variables
string theProject
end variables

forward prototypes
public function string getproject ()
public function integer uf_process_outbound_confirm_rpt (string asinifile, string lsproject, string asemail)
end prototypes

public function string getproject ();return theProject
end function

public function integer uf_process_outbound_confirm_rpt (string asinifile, string lsproject, string asemail);//07-Feb-2013 :Madhu  Outbound confirmation Weekly Report
// Create the SAT Weekly Report

string lsFilename ="wklyoutboundconfirmationreport"
string lsPath,ls_sql_Select,ls_where,lsFileNamePath
string msg
int returnCode
long rows
datetime pickFrom,pickTo,start_date,end_date
date aweekago 
time zero1
date yesterday
time lastsec

FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started PHC Outbound Confirmation Weekly  Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(gsinifile,getproject(),"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

// Create our datastore

Datastore 	idsPHCWeeklyReport
idsPHCWeeklyReport = f_datastoreFactory( 'd_outbound_confirmation' )


aweekago = RelativeDate ( today(), -7 )
zero1 = time("00:00:01")
start_date = datetime( aweekago,zero1 )
yesterday = RelativeDate ( today(), -1 )
lastsec = time("23:59:59")
end_date = datetime( yesterday,lastsec)

// Testing - 
/*start_date = datetime('10/01/12 00:00:01')
end_date = datetime(today(),now())*/
// End Testing -

idsPHCWeeklyReport.SetTransObject(SQLCA)
ls_sql_Select = idsPHCWeeklyReport.GetSQLSelect()
ls_where = "where Delivery_Master.Project_id = '" + lsproject + "' and Delivery_Master.Ord_Date >= '" + String(start_date) + "' and Delivery_Master.Ord_Date <= '" + String(end_date) + "'"

idsPHCWeeklyReport.SetSqlSelect(ls_sql_Select +ls_where )			

msg = 'Outbound Confirmation Report  From: ' + string( start_date) + ' To: ' + string(end_date)
FileWrite(gilogFileNo,msg)
rows= idsPHCWeeklyReport.retrieve(getProject(),start_date,end_date)

if rows <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(rows)
	if rows = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = idsPHCWeeklyReport.saveas(lsPath,CSV!,true)
msg = 'PHC Weekly Outbound Confirmation Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'PHC Weekly Outbound Confirmation Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)

lsFileName = "wklyoutboundconfirmationreport" + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attached the file to email. */
IF lsproject ='PHYSIO-MAA' THEN
lsFileNamePath = ProfileString(asInifile, 'PHYSIO-MAA', "archivedirectory","") + '\' + lsFileName
ELSE
lsFileNamePath = ProfileString(asInifile, 'PHYSIO-XD', "archivedirectory","") + '\' + lsFileName	
END IF
idsPHCWeeklyReport.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the Short Shipped Report */
IF lsproject ='PHYSIO-MAA' THEN
gu_nvo_process_files.uf_send_email("PHYSIO-MAA", asEmail, "PHC Weekly Outbound Confirmation Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound confirmation Report From: " +   string(start_date) +  " To: " +  string(end_date) +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
ELSE
gu_nvo_process_files.uf_send_email("PHYSIO-XD", asEmail, "PHC Weekly Outbound Confirmation Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Outbound confirmation Report From: " +   string(start_date) +  " To: " +  string(end_date) +  " -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)
END IF
Destroy idsPHCWeeklyReport


RETURN 0
end function

on u_nvo_proc_phc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_phc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

