HA$PBExportHeader$u_nvo_proc_honda_th.sru
$PBExportComments$Process Honda files
forward
global type u_nvo_proc_honda_th from nonvisualobject
end type
end forward

global type u_nvo_proc_honda_th from nonvisualobject
end type
global u_nvo_proc_honda_th u_nvo_proc_honda_th

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				iu_DS
				
u_ds_datastore	idsItem 

				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_so_dom (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);String	lsLogOut
Integer	liRC, liFileNo
Boolean	bRet

If Left(asFile,5) = 'POEXP' or  Left(asFile,5) = 'PODOM' Then /* PO File*/
		
		liRC = uf_process_po(asPath, asProject)
				
//TAM 2014/11/18 -  Change domestic SO to call different function
//ElseIf Left(asFile,5) =  'SOEXP' or Left(asFile,5) =  'SODOM' Then /* Sales Order Files */
ElseIf Left(asFile,5) =  'SOEXP' or  Left(asFile,5) = 'SODOM' Then /* Sales Order Files */
		
		liRC = uf_process_so(asPath, asProject)

ElseIf Left(asFile,4) = 'ALCA' Then /* Sales Order Files */
		
		liRC = uf_process_so_dom(asPath, asProject)

Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
	End If

Return liRC

end function

public function integer uf_process_so (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_so'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for HONDA-TH SO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project_Id[1], 7)) = 'PROJECT' then
			lds_import.Reset()
			ll_rc = lds_import.ImportFile(aspath, 2)
		end if
	end if
end if

// Process import return
if ll_rc <= 0 then
	lsLogOut = '      - Error importing file, error code: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
else
	lsLogOut = '      - Rows imported from file: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

protected function integer uf_process_po (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_po_honda_th'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for HONDA-TH PO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project[1], 7)) = 'PROJECT' then
			lds_import.Reset()
			ll_rc = lds_import.ImportFile(aspath, 2)
		end if
	end if
end if

if ll_rc <= 0 then
	lsLogOut = '      - Error importing file, error code: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
else
	lsLogOut = '      - Rows imported from file: ' + String(ll_rc)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if

ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import.Object.DataWindow.Data.XML ) )

return ll_rc

end function

public function integer uf_process_so_dom (string aspath, string asproject);long llFilerowCount, llFileRowPos
String lsLogOut, lsTemp,lsbatchdata 

String		lsWhCode, lsOrdDate, lsActiveFlag, lsCompanyCode, lsInvoiceNo,lsScheduleDate, lsCustCode, lsShipTo, lsUF3, lsUF4, lsUF5, lsUF6, lsUF7, lsUf8, lsSku, lsUserItemNo
string ldLineItemNo, ldQty	

integer liNewRow

u_ds_datastore lds_import_so, lds_import_file 

lds_import_file = Create u_ds_datastore
lds_import_file.dataobject= 'd_honda_generic_import'
lds_import_file.SetTransObject(SQLCA)

lds_import_so = Create u_ds_datastore
lds_import_so.dataobject= 'd_import_so'
lds_import_so.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for HONDA-TH Domestic SO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

llFilerowCount = lds_import_file.ImportFile(aspath, 1)

//// If Headers are present, import again and skip the header row
//if llFilerowCount > 0 or llFilerowCount = -4 then
//	if lds_import_file.RowCount() > 0 then
//		if Upper(Left(lds_import_file.Object.Project_Id[1], 7)) = 'PROJECT' then
//			lds_import_so.Reset()
//			llFilerowCount = lds_import_so.ImportFile(aspath, 2)
//		end if
//	end if
//end if

// Process import return
if llFilerowCount <= 0 then
	lsLogOut = '      - Error importing file, error code: ' + String(llFilerowCount)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
	gu_nvo_process_files.uf_writeError(lsLogOut)
	return -1
else
	lsLogOut = '      - Rows imported from file: ' + String(llFilerowCount)
	FileWrite(giLogFileNo,lsLogOut)
	gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/
end if


// Move the import File Records into the IMPORT_SO format

//Defaults

lsWhCode = 'DOM-HONDA'

for llFileRowPos = 1 to llFilerowCount

	w_main.SetMicroHelp("Processing Sales Order Record " + String(llFileRowPos) + " of " + String(llFilerowCount))
	liNewRow = 	lds_import_so.InsertRow(0)
			
			//New Record Defaults
	lds_import_so.SetItem(liNewRow,'project_id',asProject)
	lds_import_so.SetItem(liNewRow,'wh_code',lsWhCode)

lsbatchdata =lds_import_file.GetItemString(llFileRowPos,"batch_data")

//lsOrdDate = String(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),1,14) ,'YYYY/MM/DD hh:mm:ss') 
lsOrdDate = Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),1,4) + '/' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),5,2) + '/' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),7,2) + ' ' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),9,2) + ':' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),11,2) + ':' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),13,2)
lds_import_so.SetItem(liNewRow,'order_date',lsOrdDate)

//lsActiveFlag	=	Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,15,1) 
//lds_import_so.SetItem(liNewRow,'project_id',lsOrdDate)

//lsCompanyCode = Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,16,2) 
//lds_import_so.SetItem(liNewRow,'project_id',lsOrdDate)

lsInvoiceNo = Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,18,7) 
lds_import_so.SetItem(liNewRow,'order_nbr',lsInvoiceNo)

// No order Id given
lds_import_so.SetItem(liNewRow,'order_id','1' )

//lsTemp =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,25,4)) 
//If Not isnumber(lsTemp) Then
//	ldLineItemNo = 1
//Else
//	ldLineItemNo =	Dec(lsTemp)
//End If
//lds_import_so.SetItem(liNewRow,'line_item_no',ldLineItemNo)

//lsScheduleDate = String(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),29,8),'YYYY/MM/DD' )  
lsScheduleDate = Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),29,4) + '/' + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),33,2) + '/'  + Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),35,2) 
lds_import_so.SetItem(liNewRow,'schedule_date',lsScheduleDate)

lsCustCode =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,37,5 ))
lds_import_so.SetItem(liNewRow,'cust_code',lsCustCode)

lsUf3 =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,42,3))  		
lds_import_so.SetItem(liNewRow,'detail_uf3',lsUF3)

lsShipTo = trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,45,5))
lds_import_so.SetItem(liNewRow,'user_field4',lsShipTo)

lsUf4 =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,50,7))  		
lds_import_so.SetItem(liNewRow,'detail_uf4',lsUf4)

lsUf5 =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,57,8))  		
lds_import_so.SetItem(liNewRow,'detail_uf5',lsUF5)

lsUf8 = Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,65,4))  		
lds_import_so.SetItem(liNewRow,'detail_uf8',lsUf8)

lsSku =  trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,69,10))  + '-' + trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,79,6)) + '-' + Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,85,3)) 
lds_import_so.SetItem(liNewRow,'sku',lsSku)

lsTemp=  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data"),88,6)) 
If Not isnumber(lsTemp) Then
	ldQTY = '0'
Else
	ldQTY =	lsTemp
End If
lds_import_so.SetItem(liNewRow,'req_qty',ldQty)

lsUf6 =  Trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,94,2))  		
lds_import_so.SetItem(liNewRow,'detail_uf6',lsUF6)

lsUf7 =  trim(Mid(lds_import_file.GetItemString(llFileRowPos,"batch_data") ,96,6))  		
lds_import_so.SetItem(liNewRow,'detail_uf7',lsUF7)


Next /*File record */


llFilerowCount =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( lds_import_so.Object.DataWindow.Data.XML ) )

return llFilerowCount

end function

on u_nvo_proc_honda_th.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_honda_th.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

