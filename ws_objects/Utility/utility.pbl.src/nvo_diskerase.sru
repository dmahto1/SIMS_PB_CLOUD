$PBExportHeader$nvo_diskerase.sru
forward
global type nvo_diskerase from nvo
end type
end forward

global type nvo_diskerase from nvo
end type
global nvo_diskerase nvo_diskerase

type variables
// Get Demians data
Private Constant string is_inpath = "//klrprfp001/pdashare/from_pandora"
//Private Constant string is_outpath = "//mwtkl002/SIMS3fp-QA/FlatFileOut"
Private Constant string is_outpath = "//klrprfp001/pdashare/to_pandora"
Private Constant string is_sweeperpath = "//Mwtkl001/Sims3fp-prod/flatfilein/pandora"
//Private Constant string is_outpath = "c:\zuv"
//Private Constant string is_sweeperpath = "c:\zuv"
Private Constant string is_archpath = "//klrprfp001/pdashare/from_pandora/Archive"

//// QA
//Private Constant string is_inpath = "//mwtkl002/SIMS3fp-QA/FlatFileIn"
////Private Constant string is_outpath = "//mwtkl002/SIMS3fp-QA/FlatFileOut"
//Private Constant string is_outpath = "c:\zuv"
//Private Constant string is_sweeperpath = "c:\zuv"
//Private Constant string is_archpath = "//mwtkl002/SIMS3fp-QA/Archive/Pandora"

//// Production Test
//Private Constant string is_inpath = "//Mwtkl001/Sims3fp-prod/FlatFileIn"
//Private Constant string is_outpath = "//Mwtkl001/Sims3fp-prod/FlatFileOut"
//Private Constant string is_sweeperpath = "//Mwtkl001/Sims3fp-prod/FlatFileIn"
//Private Constant string is_archpath = "//Mwtkl001/Sims3fp-prod/Archive"

//// Production
//Private Constant string is_inpath = "//Mwtkl001/Sims3fp-prod/FlatFileIn/Pandora"
//Private Constant string is_outpath = "//Mwtkl001/Sims3fp-prod/FlatFileOut/Pandora"
//Private Constant string is_sweeperpath = "//Mwtkl001/Sims3fp-prod/FlatFileIn/Pandora"
//Private Constant string is_archpath = "//Mwtkl001/Sims3fp-prod/Archive/Pandora"

//// Test
//Private Constant string is_inpath = "//klrprfp001/pdashare/test/from_pandora"
//Private Constant string is_outpath = "//klrprfp001/pdashare/test/to_pandora"
//Private Constant string is_sweeperpath = "c:\zuv"
//Private Constant string is_archpath = "//klrprfp001/pdashare/test/archive"

//// Get Demians data
//Private Constant string is_inpath = "c:\zuv\diskerase"
//Private Constant string is_outpath = "//mwtkl002/SIMS3fp-QA/FlatFileOut"
//Private Constant string is_outpath = "c:\zuv"
//Private Constant string is_sweeperpath = "c:\zuv"
//Private Constant string is_archpath = "//klrprfp001/pdashare/from_pandora/2010_Archives"

Private boolean ib_automode

Private nvo_diskerase_gggmim invo_mimggg[]
Private nvo_diskerase_sims invo_sims[]
Private nvo_gggmimsimscombo invo_combofile[]
Private nvo_dcmcleared invo_dcmcleared[]

Private nvo_diskerase_clearingfile invo_cf[]

//mwtkl002/SIMS3fp-QA/FlatFileIn/Pandora
end variables

forward prototypes
public function boolean f_dateastext (date adt_date, ref string as_dateastext)
public function boolean f_getnextfield (string as_record, string as_delimeter, ref long al_pos, ref string as_field)
public function boolean f_importgggmim (string as_gggmim)
public function boolean f_suckandspit ()
public function boolean f_importsims ()
public function boolean f_importcleared ()
public function boolean f_autosoc ()
public function boolean f_getsimsrecord (string as_boxno, ref nvo_diskerase_sims anvo_sims)
public function boolean f_exportclearingfile ()
public function boolean f_newcomborecord (nvo_diskerase_gggmim anvo_gggmim, nvo_diskerase_sims anvo_sims)
public function boolean f_findgggmim (ref nvo_diskerase_gggmim anvo_gggmim)
public function boolean f_destroysimsobjects ()
public function boolean f_readgggmimfromdb ()
public function boolean f_destroymimgggobjects ()
public function boolean f_getmimgggrecord (string as_lotno, ref nvo_diskerase_gggmim anvo_gggmim[])
public function boolean f_getcomborecord (string as_boxno, string as_location, ref nvo_gggmimsimscombo anvo_gggmimsimscombo)
public function boolean f_getclearingfilerecord (string as_boxno, string as_driveserialno, ref nvo_diskerase_clearingfile anvo_clearingfile)
public function boolean f_importclearingfile ()
public function boolean f_timeastext (time at_now, ref string as_timeastext)
public function boolean f_automode (boolean ab_automode)
end prototypes

public function boolean f_dateastext (date adt_date, ref string as_dateastext);string ls_element

// Create the text from the date.
ls_element = string(day(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = ls_element

// Create the text from the date.
ls_element = string(month(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = as_dateastext + ls_element

// Create the text from the date.
ls_element = string(year(adt_date))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_dateastext = as_dateastext + ls_element

// Return whether the date is valid.
return isdate(string(adt_date))
end function

public function boolean f_getnextfield (string as_record, string as_delimeter, ref long al_pos, ref string as_field);long ll_begpos, ll_recordlength
boolean lb_goodfield

// Get the record length
ll_recordlength = len(as_record)

// IF the beginning position is less than the record length,
If al_pos < ll_recordlength then
	
	// Set lb_goodfield to true
	lb_goodfield = true

	// Record the beginning position.
	ll_begpos = al_pos
	
	// Find the position of the next delimeter.
	al_pos = pos(as_record, as_delimeter, al_pos)
	
	// If there is no more delimeters,
	If al_pos = 0 then
		
		// Set the position to the end of the record.
		al_pos = ll_recordlength + 1
	End if
	
	// Extract the field.
	as_field = mid(as_record, ll_begpos, al_pos - ll_begpos)
	
	// Set the final value for al_pos.
	al_pos++
	
End IF

// Return lb_goodfield.
return lb_goodfield

end function

public function boolean f_importgggmim (string as_gggmim);boolean lb_goodimport = true, lb_ggg, lb_badrec
string ls_dateastext, ls_record, ls_field, ls_filename, ls_dirmask, ls_fullfilename, ls_archfilename, ls_now, ls_boxno
long ll_filenum, ll_fieldnum, ll_pos, ll_numfiles, ll_fileid, ll_numrecords, ll_rc
nvo_diskerase_gggmim lnvo_simsgggrecord
listbox lb
window lw

// Open the invisible window and listbox.
Open(lw)
lw.visible = false
lw.openUserObject(lb)

// Initialize ll_numrecords
ll_numrecords = upperbound(invo_mimggg)

// Is this GGG?
lb_ggg = as_gggmim = "GGG"

// Construct the import file name.
ls_dirmask = is_inpath + "/BOX_SERIAL_" + as_gggmim + "*.txt"

// Pull a list of files meeting the description.
if lb.dirlist(ls_dirmask, 0) then	

	// Get the number of files fitting the profile.
	ll_numfiles = lb.totalitems()
	
	// Loop through the items.
	For ll_filenum = 1 to ll_numfiles
		
		// Get the file name.
		ls_filename = lb.text(ll_filenum)
		
		// Construct the full file name and archive file name.
		ls_fullfilename = is_inpath + "/" + ls_filename
		ls_archfilename = is_archpath + "/" + ls_filename
			
		// Open the import file
		ll_fileid = fileopen(ls_fullfilename, linemode!, read!, lockreadwrite!)
		
		// If we have a valid file,
		If ll_fileid > 0 then
			
			// Set lb_goodimport to true
			lb_goodimport = true
		
			// Read the first line. (headers)
			fileread(ll_fileid, ls_record)
			
			// Loop through all the records.
			Do While fileread(ll_fileid, ls_record) > 0
				
				// Reset lb_badrec
				lb_badrec = false
					
				// Create a new GGGMIM object.
				lnvo_simsgggrecord = Create nvo_diskerase_gggmim
				
				// Reset ll_pos and ll_fieldnum
				ll_pos = 1
				ll_fieldnum = 0
				
				// Loop through and parse the record fields.
				Do while f_getnextfield(ls_record, "|", ll_pos, ls_field)
					
					// Trim up the data.
					ls_field = trim(ls_field)
					
					// Incriment the field number
					ll_fieldnum++
					
					// If this field is blank or contains only '-',
					If len(ls_field) = 0 or ls_field = '-' then
						
							// The second field of a GGG record will be blank.
							If not lb_ggg then
						
								// The entire record is bad.  Continue with the next record.
								lb_badrec = true
								exit
								
							Elseif ll_fieldnum <> 2 then
						
								// The entire record is bad.  Continue with the next record.
								lb_badrec = true
								exit
								
							End If
						
					End If
					
					// What field is this?
					Choose Case ll_fieldnum
							
						Case 1
							
							// Populate the record Box Number
							ls_boxno = ls_field
							lnvo_simsgggrecord.f_setboxnumber(ls_boxno)
							
						Case 2
							
							// Populate the Google Part Number
							lnvo_simsgggrecord.f_setgooglepartnumber(ls_field)
							
						Case 3
							
							// Populate the Manual Part Number
							lnvo_simsgggrecord.f_setmanpartnumber(ls_field)
							
						Case 4
							
							// Populate the Drive Serial Number
							lnvo_simsgggrecord.f_setdriveserialnumber(ls_field)
							
						Case 5
							
							// Populate the Box Creation Date
							lnvo_simsgggrecord.f_setboxcreationdate(date(ls_field))
							
						Case 6
							
							// Populate the Drive Serial Number
							lnvo_simsgggrecord.f_setlocked(ls_field = "1")
							
					End Choose
				
				// Next field
				Loop
				
				// If the last record was bad,
				if not lb_badrec then
				
					// Populate/Update the Drive Serial Number
					lnvo_simsgggrecord.f_setimportdate(today())
					
					// Populate/Update the Drive Serial Number
					lnvo_simsgggrecord.f_setfilename(ls_filename)
					
					// Populate/Update the Drive Serial Number
					lnvo_simsgggrecord.f_setsource(as_gggmim)	
	
					// Insert or Update the record.
					lnvo_simsgggrecord.f_insertupdate()
					
				// Otherwise, if there is a bad record,
				Else
		
					// Set the file as error.
					SetProfileString ( "C:\PB11_Devl\Dev\App\diskerase.ini", "GGGMIM", ls_fullfilename + ":" + ls_boxno, "ERROR" )
					
				// End if the last record was bad.
				End IF
				
				// Destroy the record object.
				Destroy lnvo_simsgggrecord
					
			// Next Record
			Loop
			
		// End if we have a valid import file.
		End IF
	
		// Close the file.
		fileclose(ll_fileid)
		
		// Move the file to the archive.
		ll_rc = filemove(ls_fullfilename, ls_archfilename)
		
	// Next file
	Next
	
// End if we can get a list of files.
End If

// Close the window and listbox.
lw.closeuserobject(lb)
close(lw)

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_suckandspit ();boolean lb_goodprocess

// If we can import the GGG files,
if f_importgggmim("GGG") then
	
	// If we can import the MIM files,
	lb_goodprocess = f_importgggmim("MIM")
	
// End if we can import the GGG files.
End If

// Return lb_goodprocess
return lb_goodprocess
end function

public function boolean f_importsims ();boolean lb_goodimport
string ls_lotno, ls_sku, ls_ownercd, ls_location, ls_whcode, ls_dateastext, ls_coo
long ll_numsims, ll_availqty
date ldt_stockdate

// Destroy the sims objects.
f_destroysimsobjects()

// Declare the cursor.
DECLARE NONCLEARED CURSOR FOR
	SELECT Content_Summary.Lot_No,  
	Content_Summary.SKU,
	Owner.Owner_Cd,   
	Content_Summary.L_Code , 
	Content_Summary.WH_Code , 
	Content_Summary.avail_qty , 
	Content_Summary.country_of_origin, 
	Receive_Master.Complete_Date  
	FROM dbo.Content_Summary LEFT OUTER JOIN dbo.Receive_Master ON dbo.Content_Summary.Project_ID = dbo.Receive_Master.Project_ID AND dbo.Content_Summary.RO_No = dbo.Receive_Master.RO_No,  
	Owner     with (nolock) 
	WHERE Content_Summary.owner_id = owner.owner_id
	and po_no = 'NON CLEARED HD'
	and (Avail_qty > 0 or alloc_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);
//	and (Avail_qty > 0 or alloc_qty > 0 or sit_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0);

// Open the cursor
OPEN NONCLEARED;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// lb_goodimport is true
	lb_goodimport = true
		
	// Fetch the record.
	Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
	
	// Loop through the SIMS records.
	Do While SQLCA.SQLCODE<> 100
		
		// Create a new record object.
		ll_numsims++
		invo_sims[ll_numsims] = Create nvo_diskerase_sims

		// Populate the Box Creation Date
		invo_sims[ll_numsims].f_setlotnumber(ls_lotno)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setsku(ls_sku)
		
		// Populate the Drive Serial Number
		invo_sims[ll_numsims].f_setownercode(ls_ownercd)
		
		// Populate the Google Part Number
		invo_sims[ll_numsims].f_setlcode(ls_location)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setwarehousecode(ls_whcode)
		
		// Populate the Available Quantity
		invo_sims[ll_numsims].f_setavailqty(ll_availqty)
		
		// Populate the record Box Number
		invo_sims[ll_numsims].f_setcoo(ls_coo)
		
		// Populate the Drive Stock Date
		invo_sims[ll_numsims].f_setcompletedate(ldt_stockdate)
		
		// Fetch the record.
		Fetch NONCLEARED into :ls_lotno, :ls_sku, :ls_ownercd, :ls_location, :ls_whcode, :ll_availqty, :ls_coo, :ldt_stockdate;
		
	// Next Sims record
	Loop
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE NONCLEARED;

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_importcleared ();boolean lb_goodimport, lb_ggg, lb_firstrecord
string ls_dateastext, ls_record, ls_field, ls_filename, ls_dirmask, ls_filepath, ls_archivepath
long ll_filenum, ll_fieldnum, ll_pos, ll_numfiles, ll_fileid, ll_numrecords
nvo_dcmcleared lnvo_dcmcleared
listbox lb
window lw

// Open the invisible window and listbox.
Open(lw)
lw.visible = false
lw.openUserObject(lb)

// Get todays date as text.
f_dateastext(today(), ls_dateastext)

// Construct the import file name.
ls_dirmask = is_inpath + "/dcm_clear_" + ls_dateastext + "*.csv"

// Pull a list of files meeting the description.
if lb.dirlist(ls_dirmask, 0) then	

	// Get the number of files fitting the profile.
	ll_numfiles = lb.totalitems()
	
	// Loop through the items.
	For ll_filenum = 1 to ll_numfiles
		
		// Reset lb_firstrecord
		lb_firstrecord = true
		
		// Get the file name.
		ls_filename = lb.text(ll_filenum)
		ls_filepath = is_inpath + "/" + ls_filename
		ls_archivepath = is_archpath + "/" + ls_filename
			
		// Open the import file
		ll_fileid = fileopen(ls_filepath, linemode!, read!, lockreadwrite!)
		
		// If we have a valid file,
		If ll_fileid > 0 then
			
			// Set lb_goodimport to true
			lb_goodimport = true
			
			// Loop through all the records.
			Do While fileread(ll_fileid, ls_record) > 0
		
				// If this is the first record,
				If lb_firstrecord then
					
					// Set lb_firstrecord to false
					lb_firstrecord = false
					
					// If the first 3 chars are NOT 'dcm',
					If left(ls_record, 3) = 'box' then
					
						// Skip the headers and go to the next line.
						continue
					End If
					
				// End if this is the first record.
				End If
				
				// Incriment the record counter.
				ll_numrecords++
					
				// Create a new GGG object.
				invo_dcmcleared[ll_numrecords] = Create nvo_dcmcleared
				lnvo_dcmcleared = invo_dcmcleared[ll_numrecords]
				
				// Reset ll_pos and ll_fieldnum
				ll_pos = 1
				ll_fieldnum = 0
				
				// Loop through and parse the record fields.
				Do while f_getnextfield(ls_record, ",", ll_pos, ls_field)
					
					// Incriment the field number
					ll_fieldnum++
					
					// What field is this?
					Choose Case ll_fieldnum
							
						Case 1
							
							// Populate the record Box Number
							lnvo_dcmcleared.f_setboxno(ls_field)
							
						Case 2
							
							// Populate the Google Part Number
							lnvo_dcmcleared.f_setlocation(ls_field)
							
						Case 3
							
							// Populate the Manual Part Number
							lnvo_dcmcleared.f_setstatus(ls_field)
							
					End Choose
				
				// Next field
				Loop	
					
			// Next Record
			Loop
			
		// End if we have a valid import file.
		End IF
	
		// Close the file.
		fileclose(ll_fileid)
		filemove(ls_filepath, ls_archivepath)
		
	// Next file
	Next
	
// End if we can get a list of files.
End If

// Close the window and listbox.
lw.closeuserobject(lb)
close(lw)

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_autosoc ();long ll_numcleared, ll_clearednum, ll_nummatches, ll_filenum, ll_availqty
string ls_status, ls_boxno, ls_location, ls_sku, ls_exportline, ls_notused, ls_filename, ls_dateastext, ls_lotno, ls_newlocation, ls_archfilename, ls_coo, ls_suffix
string ls_specialcase
boolean lb_goodautosoc = true
nvo_diskerase_sims lnvo_sims
nvo_diskerase_gggmim lnvo_ggg, lnvo_mim
nvo_gggmimsimscombo lnvo_comborec
nvo_diskerase_clearingfile lnvo_cf

// Set the filename suffix.
f_timeastext(now(), ls_suffix)

// if we can import the sims records,
if f_importsims() then

	// Import the clearing file.
	f_importclearingfile()

	// Import the Pandora Cleared file.
	f_importcleared()
	
	// Get the number of cleared drives.
	ll_numcleared = upperbound(invo_dcmcleared)
	
	// Get the date as text.
	f_dateastext(today(), ls_dateastext)
	
	// Loop through the cleared drives.
	For ll_clearednum = 1 to ll_numcleared
		
		// Get the drive box number, location and status.
		invo_dcmcleared[ll_clearednum].f_getboxno(ls_boxno)
		invo_dcmcleared[ll_clearednum].f_getlocation(ls_location)
		invo_dcmcleared[ll_clearednum].f_getstatus(ls_status)
		
		// What is the status?
		Choose Case ls_status
				
			Case "GOOD TO GO"
				
				// New Location is 'main'
				ls_newlocation = "MAIN"
				
			Case "PULL TO DISKERASE PERSONNEL"
				
				// New Location is 'rejected'
				ls_newlocation = "REJECTED HD"
				
			Case Else
				
				// Bad form messagebox from an NVO.
				messagebox("Problem creating Automated SOC's", "Unknown lot status " + + " for record #" + string(ll_clearednum))
				
			// End what is the status?
		End Choose
		
		// Construct a unique file name
		ls_filename = is_sweeperpath + "\OCR_diskeraseautosoc_" + ls_dateastext + "_" + string(ll_clearednum) + ls_suffix + ".DAT"
		ls_archfilename = is_archpath + "\OCR_diskeraseautosoc_" + ls_dateastext + "_" + string(ll_clearednum) + ls_suffix + ".DAT"
		
		// If we can get the corresponding combo record,
		If f_getclearingfilerecord(ls_boxno, ls_location, lnvo_cf) then
					
			// If we can get the corresponding SIMS record.
			if f_getsimsrecord(ls_boxno, lnvo_sims) then
				
				// Get the sims available quantity.
				lnvo_sims.f_getavailqty(ll_availqty)
				lnvo_sims.f_getcoo(ls_coo)
		
				// Open the export file.
				ll_filenum = fileopen(ls_filename, linemode!, write!, lockwrite!, replace!)
				
				// Construct the OC header record
				ls_exportline = "OC" + "|" + ls_notused + "|" + ls_location + "|" + ls_location + "|" + left(right(ls_filename, 20), 16) + "|" + "|" + "|" + "|"
				filewrite(ll_filenum, ls_exportline)
				
				// Get the sku, from po, to po, lineitemnumber and qty.
				lnvo_cf.f_getdrivepartno(ls_sku)
			
				// Construct the SOC auto-export file.
				ls_exportline = "OD" + "|" + ls_sku + "|diskerase|" + ls_boxno + ":" + ls_coo + "|"  + "NON CLEARED HD" + "|" + ls_newlocation + "|" + string(ll_clearednum) + "|" + string(ll_availqty)
				filewrite(ll_filenum, ls_exportline)
			
				// Close the file.
				fileclose(ll_filenum)
				filecopy(ls_filename, ls_archfilename)
				
			// End  If we can get the corresponding SIMS record.
			End IF
			
		// End if we can get the corresponding combo record.
		End If
		
	// Next cleared drive record.
	Next
	
// End if we can import the sims stock owner report.
End If

// Return lb_goodautosoc
return lb_goodautosoc
end function

public function boolean f_getsimsrecord (string as_boxno, ref nvo_diskerase_sims anvo_sims);long ll_numsims, ll_simsnum
string ls_simslotnumber
boolean lb_foundsims

// Get the number of sims records.
ll_numsims = upperbound(invo_sims)
			
// Loop through the sims records.
For ll_simsnum = 1 to ll_numsims
	
	// Get the sims lot number.
	invo_sims[ll_simsnum].f_getlotnumber(ls_simslotnumber)
	
	// If the MIMGGG and SIMS lot number and ownercode match,
	If as_boxno = ls_simslotnumber then
		
		// Set the argument to the instance.
		anvo_sims = invo_sims[ll_simsnum]
		
		// Set lb_foundsims to true
		lb_foundsims = true
		
	End If
	
// Next Sims Record.
Next

// Return lb_foundsims
return lb_foundsims
end function

public function boolean f_exportclearingfile ();long ll_nummimggg, ll_numsims, ll_filenum, ll_gggnum, ll_simsnum, ll_numgggmim, ll_gggmimnum, ll_hr
string ls_dateastext, ls_filename, ls_line, ls_gggboxnumber, ls_driveserialno, ls_manpartlno, ls_sku, ls_location, ls_archivename, ls_simslotnumber
string ls_lastclearingfilename, ls_localfilename
boolean lb_goodexport = true, lb_process = true
nvo_diskerase_gggmim lnvo_gggmim[]

// If we can import the sims stock owner report,
if f_importsims() then

	// Get the number of sims records.
	ll_numsims = upperbound(invo_sims)
	
	// Get the current time.
	ll_hr = hour(now())

	// If we have sims records,
	If ll_numsims > 0 then
	
		// Get todays date as a string.
		f_dateastext(today(), ls_dateastext)
		
		// Construct the import file name.
		ls_localfilename = "clh_menlo_" + ls_dateastext + ".csv"
		ls_filename = is_outpath + "/clh_menlo_" + ls_dateastext + ".csv"
		ls_archivename = is_archpath + "/clh_menlo_" + ls_dateastext + ".csv"
		ls_lastclearingfilename = is_inpath + "/lastclearingfile.csv"
		
		// Open the export file.
		ll_filenum = fileopen(ls_localfilename, linemode!, write!, lockwrite!, replace!)
		
		// If we have an open file to write to,
		If ll_filenum > 0 then
			
			// Write the file headers.
			ls_line = "Box Number,Google Box No,Drives Part Number,Manufacturer Part Number,Drive Serial Number,Location,Stock Date"
			filewrite(ll_filenum, ls_line)
			
			// Loop through the GGG records.
			For ll_simsnum = 1 to ll_numsims
		
				// Get the sims lot number.
				invo_sims[ll_simsnum].f_getlotnumber(ls_simslotnumber)
						
				// If we can get the corresponding SIMS record.
				if f_getmimgggrecord(ls_simslotnumber, lnvo_gggmim) then
					
					// Get the number of gggmim records.
					ll_numgggmim = upperbound(lnvo_gggmim)
					
					// Loop through the gggmim records.
					For ll_gggmimnum = 1 to ll_numgggmim
						
						// Get the sims sku,
						lnvo_gggmim[ll_gggmimnum].f_getdriveserialnumber(ls_driveserialno)
						lnvo_gggmim[ll_gggmimnum].f_getmanpartnumber(ls_manpartlno)
						invo_sims[ll_simsnum].f_getsku(ls_sku)
						invo_sims[ll_simsnum].f_getownercode(ls_location)
						
						// Construct the export line.
						ls_line = ls_simslotnumber + "," + ls_simslotnumber + "," + ls_sku + "," + ls_manpartlno + "," + ls_driveserialno + "," + ls_location + "," +  string(datetime(today(), now()))
						filewrite(ll_filenum, ls_line)	
					Next
					
				// End If we can get the corresponding SIMS record.
				End If
				
			// Next GGG record
			Next
			
		// End if we have an open file to write to.
		End If
		
		// Close the file
		fileclose(ll_filenum)
		
		filecopy(ls_localfilename, ls_filename)
		filecopy(ls_localfilename, ls_archivename)
		
//		// If we can delete the old last clearing file,
//		if filedelete(ls_lastclearingfilename) then
			
			// Copy over the new last clearing file.
			filemove(ls_localfilename, ls_lastclearingfilename)
			
//		// Otherwise, If we CANNOT delete the old last clearing file,
//		Else
//	
//			// Set the file as error.
//			SetProfileString ( "C:\PB11_Devl\Dev\App\diskerase.ini", "LASTCLEARINGFILE", ls_dateastext, "Could Not Delete Old Last Clearing File" )
//		End If
		
	// End if we have mimggg and sims records
	End If

// End if we can generate the stockowner report.
End If

// Return lb_goodexport
return lb_goodexport
end function

public function boolean f_newcomborecord (nvo_diskerase_gggmim anvo_gggmim, nvo_diskerase_sims anvo_sims);string ls_gggmimboxnumber, ls_driveserialno, ls_sku, ls_location, ls_line
long ll_numcomborecords

messagebox("process message", "nvo_diskerase.f_newcomborecord is still in use")

// Get the gggmim and sims data.
anvo_gggmim.f_getboxnumber(ls_gggmimboxnumber)
anvo_gggmim.f_getdriveserialnumber(ls_driveserialno)
anvo_sims.f_getsku(ls_sku)
anvo_sims.f_getlcode(ls_location)

// Create a new gggmimsims combo object.
ll_numcomborecords = upperbound(invo_combofile) + 1
invo_combofile[ll_numcomborecords] = Create nvo_gggmimsimscombo

// Insert values into new combo object.
invo_combofile[ll_numcomborecords].f_setboxno(ls_gggmimboxnumber)
invo_combofile[ll_numcomborecords].f_setgoogleboxno(ls_gggmimboxnumber)
invo_combofile[ll_numcomborecords].f_setdrivepartno(ls_sku)
invo_combofile[ll_numcomborecords].f_setdriveserialno(ls_driveserialno)
invo_combofile[ll_numcomborecords].f_setlocation(ls_location)
invo_combofile[ll_numcomborecords].f_setstockdatetime(datetime(today(), now()))

// Return true
return true
end function

public function boolean f_findgggmim (ref nvo_diskerase_gggmim anvo_gggmim);long ll_numggg, ll_nummim, ll_numsims, ll_mimnum, ll_gggnum, ll_simsnum, ll_numrec
string ls_mimboxnumber, ls_mimgooglepartnumber, ls_gggmanpartno, ls_ggggooglepartno
string ls_mimmanpartnumber, ls_mimdriveserialnumber, ls_gggboxno, ls_gggdriveserialno
boolean lb_foundmatch = true

// See if the record already exists.
anvo_gggmim.f_getboxnumber(ls_gggboxno)
anvo_gggmim.f_getdriveserialnumber(ls_gggdriveserialno)

// If we can retrieve the object,
if not anvo_gggmim.f_retrieve() then
//select count(*) 
//into :ll_numrec 
//from diskerase 
//where boxno = :ls_gggboxno 
//and driveserialno = :ls_gggdriveserialno 
//using sqlca;
		
//// If the google and MIM drive serial numbers match.
//If ll_numrec > 0 then
	
	// Update the new record.
	anvo_gggmim.f_insertupdate()
	
	// Set lb_foundmatch to true
	lb_foundmatch = false
	
//Else
	
	// Insert the new record.
	
// End If the google and MIM drive serial numbers match.
End If


//// Get the number of each type of record.
//ll_nummim = upperbound(invo_mimggg)
//
//// Get the google part number for the ggg record.
//anvo_gggmim.f_getboxnumber(ls_gggboxno)
//anvo_gggmim.f_getmanpartnumber(ls_gggmanpartno)
//anvo_gggmim.f_getdriveserialnumber(ls_gggdriveserialno)
//anvo_gggmim.f_getgooglepartnumber(ls_ggggooglepartno)
//	
//// Loop through the MIM records.
//For ll_mimnum = 1 to ll_nummim
//	
//	// Get the MIM box number and google part number.
//	invo_mimggg[ll_mimnum].f_getmanpartnumber(ls_mimmanpartnumber)
//	invo_mimggg[ll_mimnum].f_getdriveserialnumber(ls_mimdriveserialnumber)
//	invo_mimggg[ll_mimnum].f_getgooglepartnumber(ls_mimgooglepartnumber)
//	invo_mimggg[ll_mimnum].f_getboxnumber(ls_mimboxnumber)
//		
//	// If the box number and google part numbers match,
//	If ls_gggboxno = ls_mimboxnumber then
//		
//		// If the google and MIM drive serial numbers match.
//		If ls_gggdriveserialno = ls_mimdriveserialnumber then
//			
//			// Destroy the gggmim parameter object which is duplicate,
//			Destroy anvo_gggmim
//	
//			// Replace the gggmim argument with the instance.
//			invo_mimggg[ll_mimnum] = anvo_gggmim
//			
//			// Update the new record.
//			invo_mimggg[ll_mimnum].f_insertupdate()
//			
//			// Set lb_foundmatch to true
//			lb_foundmatch = true
//			exit
//			
//		// End If the google and MIM drive serial numbers match.
//		End If
//		
//	// End if the box number and google part numbers match,
//	End If
//	
//// Next MIM record.
//Next

// Return lb_foundmatch
return lb_foundmatch
end function

public function boolean f_destroysimsobjects ();long ll_numrecords, ll_recordnum

// How many sims records?
ll_numrecords = upperbound(invo_sims)

// Loop through the sims records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the sims record is valid,
	If isvalid(invo_sims[ll_recordnum]) then
	
		// Destroy the sims record.
		Destroy invo_sims[ll_recordnum]
		
	// End If the sims record is valid.
	End If
	
// Next sims record.
Next

// Return true
return true
end function

public function boolean f_readgggmimfromdb ();boolean lb_goodget
string ls_boxnumber, ls_googlepartnumber, ls_manpartnumber, ls_driveserialnumber, ls_source, ls_filename, ls_locked
date ldt_boxcreationdate, ldt_importdate
long ll_numrecords


// Read in all the gggmim data.
// Declare the cursor.
DECLARE getgggmim CURSOR FOR
SELECT boxnumber, googlepartnumber, manpartnumber, driveserialnumber, source, filename, boxcreationdate, importdate, locked from diskerase_gggmim;

// Open the cursor
OPEN getgggmim;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// lb_goodimport is true
	lb_goodget = true
	
	// Loop through the SIMS records.
	Do While SQLCA.SQLCODE<> 100
		
		// Fetch the record.
		Fetch getgggmim into :ls_boxnumber, :ls_googlepartnumber, :ls_manpartnumber, :ls_driveserialnumber, :ls_source, :ls_filename, :ldt_boxcreationdate, :ldt_importdate, :ls_locked;
		
		// Create a mimggg record.
		ll_numrecords++
		invo_mimggg[ll_numrecords] = Create nvo_diskerase_gggmim
		invo_mimggg[ll_numrecords].f_setboxnumber(ls_boxnumber)
		invo_mimggg[ll_numrecords].f_setgooglepartnumber(ls_googlepartnumber)
		invo_mimggg[ll_numrecords].f_setmanpartnumber(ls_manpartnumber)
		invo_mimggg[ll_numrecords].f_setdriveserialnumber(ls_driveserialnumber)
		invo_mimggg[ll_numrecords].f_setsource(ls_source)
		invo_mimggg[ll_numrecords].f_setfilename(ls_filename)
		invo_mimggg[ll_numrecords].f_setboxcreationdate(ldt_boxcreationdate)
		invo_mimggg[ll_numrecords].f_setimportdate(ldt_importdate)
		invo_mimggg[ll_numrecords].f_setlocked(ls_locked = "y")
		
	// Next sims record.
	Loop
	
// End if we can open the cursor.
End IF
	
// Close the cursor.
CLOSE getgggmim;

// Return lb_goodget
return lb_goodget
end function

public function boolean f_destroymimgggobjects ();long ll_numrecords, ll_recordnum
boolean lb_destroyed = true, lb_locked
string ls_boxnumber, ls_googlepartnumber, ls_manpartnumber, ls_driveserialnumber, ls_source, ls_filename, ls_locked
date ldt_importdate

// Purge the existing records.
Delete from diskerase_gggmim using sqlca;

// Get the number of mimggg records.
ll_numrecords = upperbound(invo_mimggg)

// Loop through the mimggg records.
for ll_recordnum = 1 to ll_numrecords
	
	// If the mimggg record is valid,
	if isvalid(invo_mimggg[ll_recordnum]) then
		
		// Get the mimggg record values.
		invo_mimggg[ll_recordnum].f_getboxnumber(ls_boxnumber)
		invo_mimggg[ll_recordnum].f_getgooglepartnumber(ls_googlepartnumber)
		invo_mimggg[ll_recordnum].f_getmanpartnumber(ls_manpartnumber)
		invo_mimggg[ll_recordnum].f_getdriveserialnumber(ls_driveserialnumber)
		invo_mimggg[ll_recordnum].f_getsource(ls_source)
		invo_mimggg[ll_recordnum].f_getfilename(ls_filename)
		invo_mimggg[ll_recordnum].f_getimportdate(ldt_importdate)
		invo_mimggg[ll_recordnum].f_getlocked(lb_locked)
		If lb_locked  then
			
			ls_locked = "y"
		Else
			
			ls_locked = "n"
		End IF
		
		// Insert the still valid record.
		Insert into diskerase_gggmim values(:ls_boxnumber, :ls_googlepartnumber, :ls_manpartnumber, :ls_driveserialnumber, :ls_source, :ls_filename, :ldt_importdate, :lb_locked);
		
		// Destroy the mimggg record.
		Destroy invo_mimggg[ll_recordnum]
		
	// End If the mimggg record is valid
	End If
	
// Next mimggg record.
Next

// Return lb_destroyed
return lb_destroyed
end function

public function boolean f_getmimgggrecord (string as_lotno, ref nvo_diskerase_gggmim anvo_gggmim[]);long ll_nummimggg, ll_mimgggnum
string ls_mimgggboxno, ls_driveserialno, ls_lastdriveserialno
boolean lb_foundmimggg, lb_continue = true
nvo_diskerase_gggmim lnvo_gggmimnull[]

anvo_gggmim = lnvo_gggmimnull







// Declare the cursor.
DECLARE GETGGGMIM CURSOR FOR
Select driveserialno
From diskerase
Where boxno = :as_lotno;

// Open the cursor
OPEN GETGGGMIM;

// If we can open the cursor,
If SQLCA.SQLCODE = 0 then
	
	// Loop through the SIMS records.
	Do While lb_continue
		
		// Fetch the record.
		Fetch GETGGGMIM into :ls_driveserialno;
		
		If ls_driveserialno = ls_lastdriveserialno then exit
	
		// Return is true
		lb_foundmimggg = true
		
		// Create the gggmim object.
		ll_nummimggg++
		invo_mimggg[upperbound(invo_mimggg) + 1] =  Create nvo_diskerase_gggmim
		anvo_gggmim[ll_nummimggg] = invo_mimggg[upperbound(invo_mimggg)]
		anvo_gggmim[ll_nummimggg].f_setboxnumber(as_lotno)
		anvo_gggmim[ll_nummimggg].f_setdriveserialnumber(ls_driveserialno)
		anvo_gggmim[ll_nummimggg].f_retrieve()
		
		ls_lastdriveserialno = ls_driveserialno
		
	// Next Sims record
	Loop
	
//	// Close the archive file.
//	fileclose(ll_fileid)
	
// End if we can open the cursor.
End If

// Close the cursor.
CLOSE GETGGGMIM;









//// See if there is a corresponding mimggg record.
//Select driveserialno
//Into :ls_driveserialno
//From diskerase
//Where boxno = :as_lotno
//Using SQLCA;
//
//IF sqlca.sqlcode = 0 then
//	
//	// Return is true
//	lb_foundmimggg = true
//	
//	// Create the gggmim object.
//	invo_mimggg[upperbound(invo_mimggg) + 1] =  Create nvo_diskerase_gggmim
//	anvo_gggmim = invo_mimggg[upperbound(invo_mimggg)]
//	anvo_gggmim.f_setboxnumber(as_lotno)
//	anvo_gggmim.f_setdriveserialnumber(ls_driveserialno)
//	anvo_gggmim.f_retrieve()
//	
//End If

return lb_foundmimggg
					
////					// Set the new record in the record set.
////					ll_numrecords++
//
//// Get the number of sims records.
//ll_nummimggg = upperbound(invo_mimggg)
//			
//// Loop through the sims records.
//For ll_mimgggnum = 1 to ll_nummimggg
//	
//	// Get the sims lot number.
//	invo_mimggg[ll_mimgggnum].f_getboxnumber(ls_mimgggboxno)
//	
//	// If the MIMGGG and SIMS lot number and ownercode match,
//	If as_lotno = ls_mimgggboxno then
//		
//		// Set the argument to the instance.
//		anvo_gggmim = invo_mimggg[ll_mimgggnum]
//		
//		// Set lb_foundsims to true
//		lb_foundmimggg = true
//		
//	End If
//	
//// Next Sims Record.
//Next
//
//// Return lb_foundsims
//return lb_foundmimggg
end function

public function boolean f_getcomborecord (string as_boxno, string as_location, ref nvo_gggmimsimscombo anvo_gggmimsimscombo);string ls_gggmimboxnumber, ls_driveserialno, ls_sku, ls_location, ls_line, ls_lcode
long ll_numcomborecords

messagebox("process message", "nvo_diskerase.f_getcomborecord is still in use")

//long ll_numcombo, ll_combonum
//string ls_boxno
boolean lb_foundcombo

SELECT Content_Summary.L_Code, sku
Into :ls_lcode, :ls_sku
FROM dbo.Content_Summary
WHERE po_no = 'NON CLEARED HD'
and (Avail_qty > 0 or alloc_qty > 0 or sit_qty > 0 or tfr_in > 0 or tfr_out > 0 or wip_qty > 0 or new_qty > 0)
and content_summary.lot_no = :as_boxno;

Select driveserialno
into :ls_driveserialno
From diskerase
Where boxno = :as_boxno;

if sqlca.sqlcode = 0 then
	
	lb_foundcombo = true
	
	anvo_gggmimsimscombo = Create nvo_gggmimsimscombo
	anvo_gggmimsimscombo.f_setboxno(as_boxno)
	anvo_gggmimsimscombo.f_setgoogleboxno(as_boxno)
	anvo_gggmimsimscombo.f_setdrivepartno(ls_sku)
	anvo_gggmimsimscombo.f_setdriveserialno(ls_driveserialno)
	anvo_gggmimsimscombo.f_setlocation(as_location)
	anvo_gggmimsimscombo.f_setstockdatetime(datetime(today(), now()))
	
End If





//
//// Get the gggmim and sims data.
//anvo_gggmim.f_getboxnumber(ls_gggmimboxnumber)
//anvo_gggmim.f_getdriveserialnumber(ls_driveserialno)
//anvo_sims.f_getsku(ls_sku)
//anvo_sims.f_getlcode(ls_location)
//
//// Create a new gggmimsims combo object.
//ll_numcomborecords = upperbound(invo_combofile) + 1
//invo_combofile[ll_numcomborecords] = Create nvo_gggmimsimscombo
//
//// Insert values into new combo object.
//invo_combofile[ll_numcomborecords].f_setboxno(ls_gggmimboxnumber)
//invo_combofile[ll_numcomborecords].f_setgoogleboxno(ls_gggmimboxnumber)
//invo_combofile[ll_numcomborecords].f_setdrivepartno(ls_sku)
//invo_combofile[ll_numcomborecords].f_setdriveserialno(ls_driveserialno)
//invo_combofile[ll_numcomborecords].f_setlocation(ls_location)
//invo_combofile[ll_numcomborecords].f_setstockdatetime(datetime(today(), now()))
//
//// Return true
//return true




//// Get the number of combo records.
//ll_numcombo = upperbound(invo_combofile)
//
//// Loop through the combo records.
//For ll_combonum = 1 to ll_numcombo
//	
//	// Get the box number and location for each combo record.
//	invo_combofile[ll_combonum].f_getboxno(ls_boxno)
//	invo_combofile[ll_combonum].f_getlocation(ls_location)
//	
//	// If the passed box number and location match this combo record,
//	If as_boxno = ls_boxno then //and as_location = ls_location then
//		
//		// Set the record to the argument.
//		anvo_gggmimsimscombo = invo_combofile[ll_combonum]
//		
//		// Quit looking.
//		lb_foundcombo = true
//		exit
//		
//	// End If the passed box number and location match this combo record.
//	End IF
//	
//// Next  combo record.
//Next
	
// Return lb_foundcombo
return lb_foundcombo
end function

public function boolean f_getclearingfilerecord (string as_boxno, string as_driveserialno, ref nvo_diskerase_clearingfile anvo_clearingfile);long ll_numrec, ll_recnum
string ls_boxno, ls_driveserialno
boolean lb_foundclearingfile

// Get the number of clearing file records.
ll_numrec = upperbound(invo_cf)

// Loop through the clearing file records.
For ll_recnum = 1 to ll_numrec
	
	// Get the clearing file box number and drive serial number
	invo_cf[ll_recnum].f_getboxno(ls_boxno)
	invo_cf[ll_recnum].f_getlocation(ls_driveserialno)
//	invo_cf[ll_recnum].f_getdrivesserialno(ls_driveserialno)
	
	// If the passed values match those of this record,
	If as_boxno = ls_boxno and as_driveserialno = ls_driveserialno then
		
		// Set the argument to the instance.
		anvo_clearingfile = invo_cf[ll_recnum]
		lb_foundclearingfile = true
		exit
		
	End If
	
Next

// Return lb_foundclearingfile
return lb_foundclearingfile
end function

public function boolean f_importclearingfile ();boolean lb_goodimport = true
string ls_record, ls_field, ls_dateastext, ls_filename
long ll_fileid, ll_numrecords, ll_pos, ll_fieldnum

// Get todays date as text and assemble the clearing file name.
f_dateastext(today(), ls_dateastext)
//ls_filename = is_inpath + "/clh_menlo_" + ls_dateastext + ".csv"
ls_filename = is_inpath + "/lastclearingfile.csv"

// Open the import file
ll_fileid = fileopen(ls_filename, linemode!, read!, lockreadwrite!)

// If we have a valid file,
If ll_fileid > 0 then
	
	// Set lb_goodimport to true
	lb_goodimport = true

	// Read the first line. (headers)
	fileread(ll_fileid, ls_record)
	
	// Loop through all the records.
	Do While fileread(ll_fileid, ls_record) > 0
			
		// Set the new record in the record set.
		ll_numrecords++
		invo_cf[ll_numrecords] = Create nvo_diskerase_clearingfile
		
		// Reset ll_pos and ll_fieldnum
		ll_pos = 1
		ll_fieldnum = 0
		
		// Loop through and parse the record fields.
		Do while f_getnextfield(ls_record, ",", ll_pos, ls_field)
			
			// Incriment the field number
			ll_fieldnum++
			
			// What field is this?
			Choose Case ll_fieldnum
					
				Case 1
					
					// Populate the record Box Number
					invo_cf[ll_numrecords].f_setboxno(ls_field)
					
				Case 2
					
					// Populate the Google Part Number
					invo_cf[ll_numrecords].f_setgoogleboxno(ls_field)
					
				Case 3
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setdrivepartno(ls_field)
					
				Case 4
					
					// Populate the Box Creation Date
					invo_cf[ll_numrecords].f_setmanpartno(ls_field)
					
				Case 5
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setdrivesserialno(ls_field)
					
				Case 6
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setlocation(ls_field)
					
				Case 7
					
					// Populate the Drive Serial Number
					invo_cf[ll_numrecords].f_setstockdate(date(ls_field))
					
			End Choose
		
		// Next field
		Loop
			
	// Next Record
	Loop
	
// End if we have a valid import file.
End IF

// Close the file.
fileclose(ll_fileid)

// Return lb_goodimport
return lb_goodimport
end function

public function boolean f_timeastext (time at_now, ref string as_timeastext);string ls_element

// Create the text from the date.
ls_element = string(hour(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext = ls_element

// Create the text from the date.
ls_element = string(minute(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext += ls_element

// Create the text from the date.
ls_element = string(second(at_now))

// If the month is only one digit,
If len(trim(ls_element)) = 1 then
	
	// Preceed with a 0.
	ls_element = "0" + ls_element
End IF

// Build the date as text.
as_timeastext += ls_element

// Return whether the date is valid.
return istime(string(at_now))
end function

public function boolean f_automode (boolean ab_automode);// Set the instance to the argument.
ib_automode = ab_automode

// Return true
return true
end function

on nvo_diskerase.create
call super::create
end on

on nvo_diskerase.destroy
call super::destroy
end on

event destructor;call super::destructor;long ll_numrecords, ll_recordnum

// Destroy the mimggg objects.
f_destroymimgggobjects()

// Destroy the sims objects.
f_destroysimsobjects()

// Destroy the combo objects.
ll_numrecords = upperbound(invo_combofile)
for ll_recordnum = 1 to ll_numrecords
	Destroy invo_combofile[ll_recordnum]
Next

// Destroy the dcmcleared objects.
ll_numrecords = upperbound(invo_dcmcleared)
for ll_recordnum = 1 to ll_numrecords
	Destroy invo_dcmcleared[ll_recordnum]
Next

// Destroy the clearingfile objects.
ll_numrecords = upperbound(invo_cf)
for ll_recordnum = 1 to ll_numrecords
	Destroy invo_cf[ll_recordnum]
Next
end event

event constructor;call super::constructor;// Read the existing GGG and MIM files from the database.
f_readgggmimfromdb()
end event

