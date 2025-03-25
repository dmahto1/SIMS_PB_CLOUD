HA$PBExportHeader$u_nvo_proc_friedrich.sru
$PBExportComments$+ Added new function for Friedrich project
forward
global type u_nvo_proc_friedrich from nonvisualobject
end type
end forward

global type u_nvo_proc_friedrich from nonvisualobject
end type
global u_nvo_proc_friedrich u_nvo_proc_friedrich

forward prototypes
public function integer uf_process_daily_all_inv_rpt (string asinifile, string asproject, string asemail)
public function integer uf_process_serial_inv_rpt (string asinifile, string asproject, string asemail)
public function integer uf_process_outbound_rpt (string asinifile, string asproject, string asemail)
public function integer uf_process_inbound_rpt (string asinifile, string asproject, string asemail)
end prototypes

public function integer uf_process_daily_all_inv_rpt (string asinifile, string asproject, string asemail);//20-Jan-2014 :Madhu - Generate Daily All Inventory Report
//Process Daily All Inventory Report

string lsFilename ="Daily_All_Inventory_Report-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily All Inventory Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_stock_inquiry'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily All Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily All Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily All Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject,asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily All Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily All Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("FRIEDRICH",asEmail , "Daily All Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily All Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0

end function

public function integer uf_process_serial_inv_rpt (string asinifile, string asproject, string asemail);//20-Jan-2014 :Madhu - Generate Daily Serial Inventory Report
//Process Daily Serial Inventory Report

string lsFilename ="Daily_Serial_Inventory_Report-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Serial Inventory Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_si_serialinventory'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Serial Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily All Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily All Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily All Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Serial Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("FRIEDRICH",asEmail , "Daily Serial Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Serial Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0



end function

public function integer uf_process_outbound_rpt (string asinifile, string asproject, string asemail);//20-Jan-2014 :Madhu - Generate Daily Outbound Report
//Process Daily Outbound Report

string lsFilename ="Daily_Outbound_Report-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Outbound Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_friedrich_outbound_rpt'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Outbound Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Outbound Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily Outbound  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Outbound Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("FRIEDRICH",asEmail , "Daily Outbound Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Outbound Report ", lsPath)

Destroy ldsdir

RETURN 0
end function

public function integer uf_process_inbound_rpt (string asinifile, string asproject, string asemail);//20-Jan-2014 :Madhu - Generate Daily Inbound Report
//Process Daily Inbound Report

string lsFilename ="Daily_Inbound_Report-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inbound Report'
FileWrite(gilogFileNo,msg)


// Create our filename and path
lsFilename +=string(datetime(today(),now()),"MMDDYYYYHHMM") + '.csv'
lsPath = ProfileString(asInifile,asproject,"ftpfiledirout","")
lsPath += '\' + lsFilename
// log it
msg = 'Confirmation Report Path & Filename: ' + lsPath
FileWrite(gilogFileNo,msg)

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsdir = Create Datastore
ldsdir.Dataobject = 'd_friedrich_inbound_rpt'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inbound Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily All Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily All Inventory Data.....') /*display msg to screen*/
llRowCOunt = ldsdir.Retrieve(asProject)

if llRowCOunt <= 0 then
	msg = 'Retrieve Unsuccessful! Return Code: ' + string(llRowCOunt)
	if llRowCOunt = 0 then msg = 'Retrieved zero rows.  No output file was created.'
	FileWrite(gilogFileNo,msg)
	msg = '**********************************'
	FileWrite(gilogFileNo,msg)	
	return 0 // nothing to see here...move along
end if

// Export the data to the file location
returnCode = ldsdir.saveas(lsPath,CSV!,true)
msg = 'Daily All Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Inbound Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("FRIEDRICH",asEmail , "Daily Inbound Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inbound Report ", lsPath)

Destroy ldsdir

RETURN 0

end function

on u_nvo_proc_friedrich.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_friedrich.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

