HA$PBExportHeader$u_nvo_proc_cree.sru
$PBExportComments$+CREE User Object
forward
global type u_nvo_proc_cree from nonvisualobject
end type
end forward

global type u_nvo_proc_cree from nonvisualobject
end type
global u_nvo_proc_cree u_nvo_proc_cree

forward prototypes
public function integer uf_process_delivery_report (string as_ini_file, string as_project, datetime ad_next_runtime_date)
end prototypes

public function integer uf_process_delivery_report (string as_ini_file, string as_project, datetime ad_next_runtime_date);//07-Jan-2019 :Madhu S27852 Daily Delivery Order Report
//CREE_LLA_08.22.2018_14.30.20.csv

string lsFilename ="CREE_LLA_"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode, liRC, llRowCount


Datastore ldsDOReport

date ld_StartDate, ld_EndDate
ld_StartDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)
ld_StartDate = RelativeDate(ld_StartDate, -1)  //Current Date (2017-11-04 00:00:00)
ld_EndDate = Date(ad_next_runtime_date) //current Date (2017-11-05 00:00:00)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MM.DD.YYYY_HH.MM.SS") + '.csv'
lsPath = ProfileString(as_ini_file, "CREE", "ftpfiledirout", "")
lsPath += '\' + lsFilename

ldsDOReport = Create u_ds_datastore
ldsDOReport.Dataobject = 'd_cree_delivery_report'
ldsDOReport.SetTransobject(sqlca)

lsLogOut = "- PROCESSING FUNCTION: "+as_project+" Daily Delivery Order Report! and Path: "+lsPath
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Delivery Order Report.....') /*display msg to screen*/
llRowCount = ldsDOReport.Retrieve(as_project, ld_StartDate,ld_EndDate)

if llRowCount <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCount)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsDOReport.saveas(lsPath,CSV!,true)
msg = 'Daily Delivery Order Report  Save As Return Code: ' + string(returnCode) + " and Successfully completed and Path: "+lsPath
FileWrite(gilogFileNo,msg)

Destroy ldsDOReport


RETURN 0
end function

on u_nvo_proc_cree.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_cree.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

