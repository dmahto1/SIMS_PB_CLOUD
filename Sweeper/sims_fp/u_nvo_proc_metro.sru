HA$PBExportHeader$u_nvo_proc_metro.sru
$PBExportComments$Process Metro files
forward
global type u_nvo_proc_metro from nonvisualobject
end type
end forward

global type u_nvo_proc_metro from nonvisualobject
end type
global u_nvo_proc_metro u_nvo_proc_metro

type variables
datastore	idsPOHeader,	&
				idsPODetail,	&
				idsDOheader,	&
				idsDODetail,	&
				iu_DS
				
u_ds_datastore	idsItem 
u_ds_datastore ids_import
				



end variables

forward prototypes
public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile)
public function integer uf_process_so (string aspath, string asproject)
protected function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_ds (string aspath)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);//Process the correct file type based on the first 2 characters of the file name

String	lsLogOut
Integer	liRC, liFileNo
Boolean	bRet

u_nvo_proc_baseline_unicode		lu_nvo_proc_baseline_unicode

Choose Case Upper(Left(asFile,2))
		
	Case 'IM' /*Item Master File*/
		
		lu_nvo_proc_baseline_unicode = Create u_nvo_proc_baseline_unicode	
		
		liRC = lu_nvo_proc_baseline_unicode.uf_Process_ItemMaster(asPath, asProject)
		
	Case 'PO' /*Processed POR File */
		
		liRC = uf_process_po(asPath, asProject)
			
	Case 'SO' /* Sales Order Files*/
		
		liRC = uf_process_so(asPath, asProject)
		
	Case Else /*Invalid file type*/
		
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_so (string aspath, string asproject);Long ll_rc = 0
String lsLogOut

ids_import = Create u_ds_datastore
ids_import.dataobject= 'd_import_so_metro'
ids_import.SetTransObject(SQLCA)

/**************************************/
lsLogOut = '      - Opening File for Metro SO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = uf_process_ds(aspath)
If ll_rc = 0 Then
	ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( ids_import.Object.DataWindow.Data.XML ) )
End If

return ll_rc

end function

protected function integer uf_process_po (string aspath, string asproject);Long ll_rc = 0
String lsLogOut

ids_import = Create u_ds_datastore
ids_import.dataobject= 'd_import_po_metro'
ids_import.SetTransObject(SQLCA)

/**************************************/
lsLogOut = '      - Opening File for Metro PO Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = uf_process_ds(aspath)
If ll_rc = 0 Then
	ll_rc =  gu_nvo_process_files.uf_process_import_server( asproject, Trim( ids_import.Object.DataWindow.Data.XML ) )
End If

return ll_rc

end function

public function integer uf_process_ds (string aspath);Long llRtn = 0
long ll_rc, rtn, fId, llen
String lsLogOut, sLine
string thisColumn
datetime ldtToday, ldtTempDate
int lposComma, lposPipe, lposTab

string sCustCds[]
string quote = String(Blob(Char(34)), EncodingANSI!)
string comma = ','
string tabchar = '~t'
string pipechar = '|'
string delimiter = comma	// set up the system to use comma as the default delimiter

long lpos = 0			// used for pos search
long lpos2 = 0 			// find quotes

long lImportRow = 0
long cnt = 0         		// counter
long i = 0				// iterator
long ldr = 0
string ss = ''

/*********Get DW display columns*************/
  Long li_Loop, ll_columns
  String ls_ColName, lsa_ColNames[]
  
  Any la_colno
  la_colno = ids_import.object.datawindow.column.count
  ll_columns = long(la_colno)
  FOR li_Loop = 1 TO ll_columns
  	ls_ColName = ids_import.Describe("#" + String( li_Loop ) + ".Name")
	IF Long( ids_import.Describe( ls_ColName + ".Visible") ) > 0 THEN
    		lsa_ColNames[ UpperBound(lsa_ColNames[]) + 1] = ls_ColName
    END IF
 next
/*****************************************/
fId = fileopen ( asPath, LineMode!, Read!)

rtn = FileReadEx( fId, sLine )  
if IsNull(rtn) OR (rtn <= 0 ) then
		lsLogOut = "        Could not read: " + asPath + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
else
	llen = len(sLine)
end if

//ldtToday = f_getLocalWorldTime( gs_default_wh )

// determine the delimiter to use
lposComma = 0
lposPipe = 0
lposTab = 0

lposComma = pos(sLine, comma, 1)
lposPipe  = pos(sLine, PipeChar, 1)
lposTab   = pos(sLine, TabChar, 1)

IF lposComma > 0 THEN
	delimiter = comma
ELSEIF lposPipe > 0 THEN
	delimiter = PipeChar
ELSEIF lposTab > 0 THEN
	delimiter = TabChar
ELSE
		lsLogOut = "        Unable to determine delimiter. ~r~nPlease confirm that the file uses either the comma, tab or pipe characters as column markers."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
END IF

DO WHILE ( rtn > 0)
	
	lImportRow ++
	// write to the status line
	w_main.SetMicroHelp( 'Processing row: ' + string(lImportRow) + ': ' + sLine)
	
	llen = len(sLine)
	i = 1
	cnt = 0
	
	DO UNTIL (i >= llen)
		// get the columns
		cnt++ // increment column counter
		
		lpos = pos(sLine, delimiter, i)
		if lpos > 0 then
			ss = mid(sLine, i, lpos - i)
			// how to deal with embedded quotes and delimiters:
			// Test for quote and if found then find match and set i and lpos appropriately
			If left(ss,1) = quote Then
				lpos2 = pos(sLine, quote, lpos + 1)
				if lpos > 0 then
					ss = mid(sline, i + 1, lpos2 - i - 1) 
					i = lpos2 + 2
					//lpos = lpos2
				end if
			else
				i = lpos + 1
			End if
		elseif lpos = 0 and i = 0 then
			ss = ''
			i++
			cnt --
		else
			ss = mid(sLine, i)
			i = llen 
		end if
		
		thisColumn = upper(lsa_ColNames[cnt])
		
		//Change format of dates for web server (order_date & scheduled_date for purchase order; schedule_date and request_date for sales order)
		if thisColumn = 'ORDER_DATE' or thisColumn = 'SCHEDULED_DATE' &
				or thisColumn = 'SCHEDULE_DATE' or thisColumn = 'REQUEST_DATE' then
			if len(ss) = 8 then
				ss = left(ss,4) + '-' + mid(ss,5,2) + '-' + right(ss,2)
			end if
		end if
		
		
		// Add column data to DS
		If cnt = 1 Then 
			If left(upper(ss),4) = left(upper(thisColumn),4) Then
				// Header row - do not process
				EXIT
			Else
				ldr =ids_import.insertrow(0)
				ids_import.setitem( ldr, thisColumn, ss)
			End If
		Else
			ids_import.setitem( ldr, thisColumn, ss)
		End If
		
	LOOP // Parse through the colunns
	
	rtn = FileReadEx( fId, sLine )  // row 5+ data

LOOP  // Rows 4+

rtn = FileClose(fId)

return llRtn
end function

on u_nvo_proc_metro.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_metro.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

