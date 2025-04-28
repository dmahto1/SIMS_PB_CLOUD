$PBExportHeader$u_nvo_proc_h2o.sru
$PBExportComments$+ New NVO for H2O.
forward
global type u_nvo_proc_h2o from nonvisualobject
end type
end forward

global type u_nvo_proc_h2o from nonvisualobject
end type
global u_nvo_proc_h2o u_nvo_proc_h2o

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
public function integer uf_process_po (string aspath, string asproject)
public function integer uf_process_so (string aspath, string asproject)
public function integer uf_process_im (string aspath, string asproject)
end prototypes

public function integer uf_process_files (string asproject, string aspath, string asfile, string asinifile);String	lsLogOut
Integer	liRC

Choose Case Upper(Left(asfile,2))
	Case 'PO'
		liRC = uf_process_po(asPath, asProject)
	Case 'SO'
		liRC = uf_process_so(asPath, asProject)
	Case 'IM'
		liRC = uf_process_im(asPath, asProject)
	Case Else /*Invalid file type*/
		lsLogOut = "        Invalid File Type: " + asFile + " - File will not be processed."
		FileWrite(gilogFileNo,lsLogOut)
		gu_nvo_process_files.uf_writeError(lsLogout)
		Return -1
		
End Choose

Return liRC
end function

public function integer uf_process_po (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_po'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for H2O PO Import Processing: ' + asPath
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

public function integer uf_process_so (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_so'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for H2O SO Import Processing: ' + asPath
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

public function integer uf_process_im (string aspath, string asproject);long ll_rc
String lsLogOut

u_ds_datastore lds_import
lds_import = Create u_ds_datastore
lds_import.dataobject= 'd_import_item_master'
lds_import.SetTransObject(SQLCA)

lsLogOut = '      - Opening File for H2O IM Import Processing: ' + asPath
FileWrite(giLogFileNo,lsLogOut)
gu_nvo_process_files.uf_write_log(lsLogOut) /*write to Screen*/

ll_rc = lds_import.ImportFile(aspath, 1)

// If Headers are present, import again and skip the header row
if ll_rc > 0 or ll_rc = -4 then
	if lds_import.RowCount() > 0 then
		if Upper(Left(lds_import.Object.Project_ID[1], 7)) = 'PROJECT' then
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

on u_nvo_proc_h2o.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_nvo_proc_h2o.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

