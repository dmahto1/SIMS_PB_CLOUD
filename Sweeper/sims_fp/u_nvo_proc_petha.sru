HA$PBExportHeader$u_nvo_proc_petha.sru
$PBExportComments$Process files for Physio Control
forward
global type u_nvo_proc_petha from nonvisualobject
end type
end forward

global type u_nvo_proc_petha from nonvisualobject
end type
global u_nvo_proc_petha u_nvo_proc_petha

type prototypes

Function Long MultiByteToWideChar(UnsignedLong CodePage, Ulong dwFlags, string lpMultiByteStr, Long cbMultiByte,  REF blob lpWideCharStr, Long cchWideChar) Library "kernel32.dll" alias for "MultiByteToWideChar;Ansi" 

end prototypes

type variables

string lsDelimitChar

end variables

forward prototypes
public function string nonull (string as_str)
public function integer uf_process_daily_inventory_petha (string asinifile, string asproject, string asemail)
end prototypes

public function string nonull (string as_str);as_str = trim(as_str)
if isnull(as_str) or as_str = '-' then
	return ""
else
	return as_str
end if
end function

public function integer uf_process_daily_inventory_petha (string asinifile, string asproject, string asemail);//28-May-2013 :Madhu - Generate Daily Inventory Report
//Process Daily Inventory Report

string lsFilename ="DailyInventoryReport-"
string lsPath,lsFileNamePath,msg,lsLogOut
int returnCode,liRC
long llRowCount

Datastore	ldsOut,ldsdir


FileWrite(gilogFileNo,"")
msg = '**********************************'
FileWrite(gilogFileNo,msg)
msg = 'Started Daily Inventory Report'
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
ldsdir.Dataobject = 'd_stock_inquiry_petha'
lirc = ldsdir.SetTransobject(sqlca)



lsLogOut = "- PROCESSING FUNCTION: "+asproject+" Daily Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the Daily Avail Inventory Data
gu_nvo_process_files.uf_write_log('Retrieving Daily Inventory Data.....') /*display msg to screen*/
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
msg = 'Daily Inventory  Report Save As Return Code: ' + string(returnCode)
FileWrite(gilogFileNo,msg)
msg = 'Daily Inventory Report Finished'
FileWrite(gilogFileNo,msg)
msg = '**********************************'
FileWrite(gilogFileNo,msg)


/* Now e-mailing the Short Shipped Report */
gu_nvo_process_files.uf_send_email("PE-THA",asEmail , "Daily Inventory Report.  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the Daily Inventory Report ", lsPath)

Destroy ldsdir

RETURN 0
end function

on u_nvo_proc_petha.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_petha.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
lsDelimitChar = char(9)
end event

