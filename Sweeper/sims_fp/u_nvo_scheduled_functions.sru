HA$PBExportHeader$u_nvo_scheduled_functions.sru
$PBExportComments$Non project specific scheduled functions
forward
global type u_nvo_scheduled_functions from nonvisualobject
end type
end forward

global type u_nvo_scheduled_functions from nonvisualobject
end type
global u_nvo_scheduled_functions u_nvo_scheduled_functions

forward prototypes
public function integer uf_movement_vs_boh_reconciliation (string asinifile, string asactivityid, string asparmstring)
end prototypes

public function integer uf_movement_vs_boh_reconciliation (string asinifile, string asactivityid, string asparmstring);
//Process the Stock Movement vs balance on Hand reconciliation report


Datastore	ldsOut,	&
				ldsMovement
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String		lsFind, lsOutString,	lslogOut, lsProject,	lsemail, &
				lsWarehouse, lsFileName

Integer		liRC, J
DateTime		ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - the next time to run is stored in the in the file Activity Schedule 

ldsOut = Create Datastore
ldsOut.Dataobject = 'd_edi_generic_out'
lirc = ldsOut.SetTransobject(sqlca)

ldsMovement = Create Datastore
ldsMovement.Dataobject = 'd_stock_movement_vs_boh'
lirc = ldsMovement.SetTransobject(sqlca)

 SELECT Project_ID,   
         email_string, 
        WH_Code
   INTO :lsProject,   
        :lsEmail,
        :lsWarehouse  
   FROM Activity_Schedule  
  WHERE Activity_Schedule.Activity_ID = :asactivityid;

	
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION: Stock Movement vs BOH reconciliation = " + asactivityid
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the PO Data
lsLogout = 'Retrieving Inventory and movement data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCOunt = ldsMovement.Retrieve(lsProject, lsWarehouse) 
	
lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)
	
// Check for discrepancies and report if present	
If ldsmovement.rowCount() > 0 Then
	If ldsMovement.Find("c_difference <> 0",1,ldsmovement.rowCount()) > 0 Then
		gu_nvo_process_files.uf_send_email(lsProject, lsEmail, "Inventory Discrepancies have been found", "Inventory Discrepancies have been found. Please run the Stock movement vs BOH report for more information.","")
	End If
End If



Return 0
end function

on u_nvo_scheduled_functions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_scheduled_functions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

