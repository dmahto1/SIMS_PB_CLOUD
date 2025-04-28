HA$PBExportHeader$u_nvo_proc_dana_th.sru
forward
global type u_nvo_proc_dana_th from nonvisualobject
end type
end forward

global type u_nvo_proc_dana_th from nonvisualobject
end type
global u_nvo_proc_dana_th u_nvo_proc_dana_th

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				idsDoAddress,	&
				iu_DS
				
u_ds_datastore	idsItem 

				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_sum_inv_rpt (string asinifile, string asemail)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);
String	lsLogOut,lsSaveFileName, lsStringData

Integer	liRC, liFileNo

Boolean	bRet

//Just keep for place holder.


//If Left(asFile,2) = 'IS' Then /* PO File*/
//	
//		
//		liRC = uf_process_po(asPath, asProject)
//	
//		//Process any added PO's
//		liRC = gu_nvo_process_files.uf_process_purchase_order(asProject) 
//			
//ElseIf Left(asFile,2) =  'PR' Then /* Sales Order Files from LMS to SIMS*/
//		
//		liRC = uf_process_so(asPath, asProject)
//		
//		//Process any added SO's
//		liRC = gu_nvo_process_files.uf_process_Delivery_order() 
//		
//
//		
//Else /*Invalid file type*/
//		
//		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
//		FileWrite(gilogFileNo,lsLogOut)
//		gu_nvo_process_files.uf_writeError(lsLogout)
//		Return -1
//		
//	End If

Return liRC
end function

public function integer uf_process_sum_inv_rpt (string asinifile, string asemail);//Process the DANA-TH Daily Summary Inventory Report
//uf_process_sum_inv_rpt string asinifile, asemail return Integer

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
lsLogOut = "- PROCESSING FUNCTION: DANA-TH Summary Inventory Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

//Retrive the DANA-TH Summary Inventory Report
lsLogout = 'Retrieving DANA-TH Summary Inventory Report.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

//Retrieve main/row report
llRowCount = lds_SumInv.Retrieve('DANA-TH') 

lsLogOut = 'Processing DANA-TH Summary Inventory.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

///////////////after////////////////////////////////////////////////////////////
//report on external dw

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName = 'DANA-TH_Summary_Inventory_' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

/* Now SAVE  it so we can attach the file to email. */
lsFileNamePath = ProfileString(asInifile, 'DANA-TH', "archivedirectory","") + '\' + lsFileName

lds_SumInv.SaveAs ( lsFileNamePath, Excel!	, true )

/* Now e-mailing the DANA-TH Summary Inventory Report */
gu_nvo_process_files.uf_send_email("DANA-TH", asEmail, "DANA-TH Summary Inventory  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the DANA-TH Summary Inventory Report  -Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)

return 0

end function

on u_nvo_proc_dana_th.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_dana_th.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

