HA$PBExportHeader$u_nvo_proc_dana_ray.sru
$PBExportComments$+ Added New Project.
forward
global type u_nvo_proc_dana_ray from nonvisualobject
end type
end forward

global type u_nvo_proc_dana_ray from nonvisualobject
end type
global u_nvo_proc_dana_ray u_nvo_proc_dana_ray

forward prototypes
public function integer uf_process_sum_inv_rpt (string asinifile, string asemail)
end prototypes

public function integer uf_process_sum_inv_rpt (string asinifile, string asemail);//Process the DANA-RAY Daily Summary Inventory Report

Datastore	lds_SumInv
Long			llRowCount
String		lsFind, lsOutString,	lslogOut, lsProject,	lsNextRunTime,	lsNextRunDate,	&
				lsRunFreq, lsInvTypeCd, lsInvTypeDesc, lsEmail, lsFileName,  &
				lsparmstring, lsparm1, lsparm2, lsparm3, lsparm4, lsparm5, lsparm6, lsparm7, &
				lsFileNamePath, lsLocalFromDate, lsLocalToDate
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate



//This function runs on a scheduled basis - Run from the scheduler, not the .ini file
lds_SumInv = Create Datastore
lds_SumInv.Dataobject = 'd_summary_inventory_rpt'
lirc = lds_SumInv.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: DANA-RAY Summary Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the DANA-TH Summary Inventory Report
lsLogout = 'Retrieving DANA-RAY Summary Inventory Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
llRowCount = lds_SumInv.Retrieve('DANA-RAY') 

lsLogOut = 'Processing DANA-RAY Summary Inventory.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

///////////////after////////////////////////////////////////////////////////////
//report on external dw

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'DANA-RAY_Summary_Inventory_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attach the file to email. */
lsFileNamePath = ProfileString(asInifile, 'DANA-RAY', "archivedirectory","") + '\' + lsFileName

lds_SumInv.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the DANA-RAY Summary Inventory Report */
gu_nvo_process_files.uf_send_email("DANA-RAY", asEmail, "DANA-RAY Summary Inventory  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the DANA-RAY Summary Inventory Report  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

return 0

end function

on u_nvo_proc_dana_ray.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_dana_ray.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

