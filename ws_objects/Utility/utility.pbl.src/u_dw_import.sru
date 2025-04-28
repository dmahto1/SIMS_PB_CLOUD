$PBExportHeader$u_dw_import.sru
$PBExportComments$Generic DW for importing data
forward
global type u_dw_import from u_dw_ancestor
end type
end forward

global type u_dw_import from u_dw_ancestor
integer width = 2565
integer height = 2252
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean hsplitscroll = true
event ue_post_import ( )
event ue_cmd_option_1 ( )
event ue_pre_import ( )
event type integer ue_pre_validate ( )
end type
global u_dw_import u_dw_import

type variables
String	isCurrValColumn
String   isImportFile
String	isFilePath
String	isImportMode
end variables

forward prototypes
public function integer wf_save ()
public function string wf_validate (long al_row)
public subroutine dolockdw (boolean _lock)
public function string wf_export_xml ()
public function long setimportfile (string path, string filename)
end prototypes

event ue_post_import;
//There may be some manipulations necessary after importing the rows
end event

event ue_cmd_option_1;
//Triggered from Command Option 1 button for any user triggered optional processing
end event

event ue_pre_import();
//We may need to set some initial values before importing
end event

event type integer ue_pre_validate();//Set any validation indicators...
return 0

end event

public function integer wf_save ();long ll_returncode, ll_numrows, ll_rownum, ll_reccount, ll_fileid
string ls_projectid, ls_sku, ls_suppcode, ls_priceclass, ls_curcode
decimal ld_price1, ld_price2

// KRZ What is the dataobject?
Choose Case dataobject
		
	// d_import_price_data
	Case "d_import_price_data"
		
		ll_fileid = fileopen("c:\sims-mww\import.txt", linemode!, write!, lockwrite!, replace!)
		
		// Set the pointer to hourglass.
		setpointer(hourglass!)
		
		// Get the number of rows.
		ll_numrows = rowcount()
		
		// Loop through the rows.
		For ll_rownum = 1 to ll_numrows
			
			// Set microhelp.
			w_main.setmicrohelp("Vetting Import Record " + string(ll_rownum) + " of " + string(ll_numrows) + ".")
			
			// Get primary key values for the record.
			ls_projectid = getitemstring(ll_rownum, "project_id")
			ls_sku = getitemstring(ll_rownum, "sku")
			ls_suppcode = getitemstring(ll_rownum, "supp_code")
			ls_priceclass = getitemstring(ll_rownum, "price_class")
			ld_price1 = getitemnumber(ll_rownum, "price_1")
			ld_price2 = getitemnumber(ll_rownum, "price_2")
			ls_curcode = getitemstring(ll_rownum, "currency_cd")
			
			// See if this record already exists.
			Select count(*) into :ll_reccount from price_master where project_id = :ls_projectid and sku = :ls_sku and supp_code = :ls_suppcode and price_class = :ls_priceclass using sqlca;
			
			// If the record already exists,
			If ll_reccount > 0 then
				
				// Update the price.
				Update Price_Master set price_1 = :ld_price1, price_2 = :ld_price2, currency_cd = :ls_curcode where project_id = :ls_projectid and sku = :ls_sku and supp_code = :ls_suppcode and price_class = :ls_priceclass using sqlca;
			
				// Set microhelp.
				w_main.setmicrohelp("Updating import Record " + string(ll_rownum))
			
// 				// Set the status as datamodified.
//				SetItemStatus(ll_rownum, 0, Primary!, DataModified!)

			// Otherwise, if the record does not exist,
			Else
				
				// Insert a new price record.
				Insert into Price_Master values (:ls_projectid, :ls_sku, :ls_suppcode, :ls_priceclass, :ld_price1, :ld_price2, 0, 0, 0, 0, 0, :ls_curcode, '') using sqlca;
			
				// Set microhelp.
				w_main.setmicrohelp("Inserting import Record " + string(ll_rownum))
				
			End If
			
			filewrite(ll_fileid, string(ll_rownum))
			
		// Next Record.
		Next
		
		fileclose(ll_fileid)
		
//		// Save the data
//		ll_returncode = update()
		
		// Commit the changes.
		Execute Immediate "COMMIT" using SQLCA;
		
		// Set the pointer to arrow.
		setpointer(arrow!)
		
// End What is the dataobject.
End Choose

// Set microhelp to 'ready'.
w_main.setmicrohelp("Ready...")

// Return ll_returncode
Return ll_returncode
end function

public function string wf_validate (long al_row);Return ''
end function

public subroutine dolockdw (boolean _lock);// doLockDW( boolean _lock )
this.enabled = _lock

end subroutine

public function string wf_export_xml ();

//Export the XML
REturn  Trim( this.Object.DataWindow.Data.XML )
end function

public function long setimportfile (string path, string filename);long rtn = 1

if NOT IsNull(Filename) AND (Filename <> '') then
	isImportfile = TRIM(Filename)
else
	isImportFile = ''
	rtn = -1
end if

if NOT IsNull(path) AND (path <> '') then
	isFilePath = TRIM(path)
else
	isFilePath = ''
	rtn = -1
end if


RETURN rtn

end function

on u_dw_import.create
call super::create
end on

on u_dw_import.destroy
call super::destroy
end on

event constructor;This.SetRowFocusindicator(Hand!)
end event

