HA$PBExportHeader$u_nvo_proc_puma.sru
$PBExportComments$Process LMC files
forward
global type u_nvo_proc_puma from nonvisualobject
end type
end forward

global type u_nvo_proc_puma from nonvisualobject
end type
global u_nvo_proc_puma u_nvo_proc_puma

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
public function integer uf_process_outbound_order_rpt (string asinifile, string asemail)
public function integer uf_process_inventory_by_sku_rpt (string asinifile, string asemail, string aswhcode)
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

public function integer uf_process_outbound_order_rpt (string asinifile, string asemail);
//BCR 26-JAN-2012: Process the Puma Outbound Order Report.


Datastore	lds_Rpt
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsFileName, lsFileNamePath

String			ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp	

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_puma_outbound_order'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PUMA Outbound Order Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PUMA"

//Retrieve the Data
lsLogout = 'Retrieving  PUMA Outbound Order Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve()

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  PUMA Outbound Order Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

lsFileName =  'PUMA_Outbound_Order_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + '.XLS'

lsFileNamePath = ProfileString(asInifile, lsProject, "archivedirectory","") + '\' + lsFileName

lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )

//Send email...	
gu_nvo_process_files.uf_send_email("PUMA", "OUTBOUND_ORDER_REPORT_EMAIL", " PUMA Outbound Order Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PUMA Outbound Order Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)



Return 0
end function

public function integer uf_process_inventory_by_sku_rpt (string asinifile, string asemail, string aswhcode);
//Process the Puma Inventory By Sku


Datastore	lds_Rpt
				
Long			llRowPos, llRowCount, llFindRow,	llNewRow
				
String			lsFind, lsOutString, lslogOut, lsProject, lsNextRunTime, lsNextRunDate,	&
				lsRunFreq, lsFileName, lsFileNamePath

String			ls_PacificTime
String 		ERRORS, sql_syntax, lsTemp	

Decimal		ldBatchSeq, ldBatchSeq_NonGIG
Integer		liRC
DateTime	ldtNextRunTime
Date			ldtNextRunDate

//This function runs on a scheduled basis - Run from the scheduler, not the .ini file

lds_Rpt = Create Datastore
lds_Rpt.Dataobject = 'd_inventory_by_sku_puma'
lirc = lds_Rpt.SetTransobject(sqlca)

lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = "- PROCESSING FUNCTION:  PUMA Inventory by Sku Report!"
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
lsLogOut = ""
FileWrite(gilogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/

lsProject = "PUMA"

//Retrieve the Data
lsLogout = 'Retrieving  PUMA Inventory by Sku Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(giLogFileNo,lsLogOut)

llRowCount = lds_Rpt.Retrieve(aswhcode)

lsLogOut = String(llRowCount) + ' Rows were retrieved for processing.'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//Write the rows to the generic output table - delimited by '~t'
lsLogOut = 'Processing  PUMA Inventory by Sku Report Data.....'
gu_nvo_process_files.uf_write_log(lsLogOut) /*display msg to screen*/
FileWrite(gilogFileNo,lsLogOut)

//ls_Now = string(now(), 'yyyy-mm-dd hh:mm:ss')
//ls_PacificTime = string(GetPacificTime('GMT', datetime(today(), now())), 'yyyy-mm-dd hh:mm:ss')


lsFileName =  'PUMA_Inventory_By_Sku_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + "_" + aswhcode + '.XLS'

//TAM 2013/10 -  Changed the format of the file name
//lsFileName =  'PUMA_Inventory_By_Sku_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss") + "_" + aswhcode + '.XLS'
lsFileName =  aswhcode + '-Inventory_By_Sku_Report' + String(DateTime( today(), now()), "yyyymmddhhmmss")  + '.XLS'

//TAM 2013/10  Send the report to the outbound folder
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'ftpfiledirout','') + '\' + lsFileName
lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )

//TAM 2013/10  Send the report to the archive  folder
lsFileNamePath = ProfileString(gsInifile, 'Puma', 'archivedirectory','') + '\' + lsFileName
lds_Rpt.SaveAs ( lsFileNamePath, Excel!	, true )


//Using entry in file instead of database email field. 
//Google DL did not work and too many names to fit in column.

string lsEmail 

lsEmail = "INVENTORY_BY_SKU_EMAIL_" + aswhcode
	
	
gu_nvo_process_files.uf_send_email("PUMA", asemail, " PUMA Inventory by Sku  Report - Run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', "Attached is the  PUMA Inventory by Sku Report, run on " + string(Today(), 'YYYY/MM/DD HH:MM') + ' GMT', lsFileNamePath)



Return 0

end function

on u_nvo_proc_puma.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_puma.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

