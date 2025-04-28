$PBExportHeader$w_diskerase.srw
forward
global type w_diskerase from w
end type
type cb_dummy from commandbutton within w_diskerase
end type
type cb_7 from commandbutton within w_diskerase
end type
type cb_6 from commandbutton within w_diskerase
end type
type rb_2 from radiobutton within w_diskerase
end type
type rb_1 from radiobutton within w_diskerase
end type
type st_2 from statictext within w_diskerase
end type
type st_1 from statictext within w_diskerase
end type
type cb_5 from commandbutton within w_diskerase
end type
type cb_4 from commandbutton within w_diskerase
end type
type cb_3 from commandbutton within w_diskerase
end type
type cb_2 from commandbutton within w_diskerase
end type
type cb_1 from commandbutton within w_diskerase
end type
type gb_1 from groupbox within w_diskerase
end type
type gb_2 from groupbox within w_diskerase
end type
end forward

global type w_diskerase from w
integer width = 2766
integer height = 1180
string title = "DiskErase"
cb_dummy cb_dummy
cb_7 cb_7
cb_6 cb_6
rb_2 rb_2
rb_1 rb_1
st_2 st_2
st_1 st_1
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_diskerase w_diskerase

type variables
Private boolean ib_auto
Private nvo_diskerase invo_diskerase
end variables

on w_diskerase.create
int iCurrent
call super::create
this.cb_dummy=create cb_dummy
this.cb_7=create cb_7
this.cb_6=create cb_6
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_2=create st_2
this.st_1=create st_1
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_dummy
this.Control[iCurrent+2]=this.cb_7
this.Control[iCurrent+3]=this.cb_6
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_diskerase.destroy
call super::destroy
destroy(this.cb_dummy)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event timer;call super::timer;string ls_now
long ll_hr
boolean lb_process = true

// Avoid the application timeout event.
cb_dummy.Event clicked()

// Compute the current time.
ls_now = string(datetime(today(), now()))
				
// Destroy the old diskerase object.
Destroy invo_diskerase
invo_diskerase = create nvo_diskerase

// If were in automode,
if ib_auto then
	
	// Get the current time.
	ll_hr = hour(now())
	
	// Derrive lb_process.  The clearing file should be generated between the hours of 5 and 6 am and 5 and 6 pm.
	lb_process = (ll_hr = 5  or ll_hr = 17)
End If
	
// If we should process the clearing file,
if lb_process then

	// Suck in the data and spit out the clearing file.
	if invo_diskerase.f_suckandspit() then	
			
		// Set the file as processed.
		SetProfileString ( "diskerase.ini", "DISKERASE", "Import GGG and MIM Files Success", ls_now)
			
		// Set the file as processed.
		SetProfileString ( "diskerase.ini", "DISKERASE", "Import SIMS Success", ls_now)
	
		// IF we can export the first response to Pandora.
		if invo_diskerase.f_exportclearingfile() then
			
		// Otherwise, iF we cannot export the first response to Pandora.
		Else
			
		// End iF we cannot export the first response to Pandora.
		End IF
		
	// Otherwise, if we cant generate the clearing file,
	Else
			
		// Set the file as processed.
		SetProfileString ( "diskerase.ini", "DISKERASE", "Import GGG and MIM Files Failure", ls_now)
		
	// End if we cant generate the clearing file,
	End If
	
// End If we should process the clearing file.
End If
	
// If we can generate the autosoc's
if invo_diskerase.f_autosoc() then	

	// Set the file as processed.
	SetProfileString ( "diskerase.ini", "DISKERASE", "Auto SOC Success", ls_now)
	
// Otherwise, if we cant generate the clearing file,
Else

	// Set the file as processed.
	SetProfileString ( "diskerase.ini", "DISKERASE", "Auto SOC Failure", ls_now)
	
// End if we cant generate the clearing file,
End If
end event

event open;call super::open;invo_diskerase = create nvo_diskerase
end event

event close;call super::close;Destroy invo_diskerase
end event

type cb_dummy from commandbutton within w_diskerase
integer x = 1920
integer y = 832
integer width = 462
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Idle Dummy"
end type

event clicked;// Click this button to avoid idle timeout.
end event

type cb_7 from commandbutton within w_diskerase
boolean visible = false
integer x = 1134
integer y = 912
integer width = 462
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Impor&t"
end type

event clicked;datastore lds_access //, lds_sybase
sqlcz lt_sqlcz
long ll_numrecords, ll_recordnum, ll_newrow, ll_numexisting
string ls_boxno, ls_gpn, ls_mpn, ls_driveserial, ls_locked, ls_source, ls_filename
datetime ldtm_importdate, ldtm_createdate
boolean lb_quit

lt_sqlcz = Create sqlcz

Connect using lt_sqlcz;

lds_access = Create datastore
//lds_sybase = Create datastore

lds_access.dataobject = "d_import_diskerase"
//lds_sybase.dataobject = "d_import_tosybase"

//lds_sybase.settransobject(sqlca)
lds_access.settransobject(lt_sqlcz)

ll_numrecords = lds_access.retrieve()

for ll_recordnum = 1 to ll_numrecords
	
	// Get the record values.
	ls_boxno = lds_access.getitemstring(ll_recordnum, "boxnumber")
	ls_gpn = lds_access.getitemstring(ll_recordnum, "googlepartnumber")
	ls_mpn = lds_access.getitemstring(ll_recordnum, "manufacturerpartnumber")
	ls_driveserial = lds_access.getitemstring(ll_recordnum, "driveserialnumber")
	ldtm_createdate = lds_access.getitemdatetime(ll_recordnum, "boxcreationdate")
	//ls_locked = lds_access.getitemstring(ll_recordnum, "locked")
	ls_source = lds_access.getitemstring(ll_recordnum, "source")
	ldtm_importdate = lds_access.getitemdatetime(ll_recordnum, "importdate")
	ls_filename = lds_access.getitemstring(ll_recordnum, "filename")
	
//	select count(*)
//	into :ll_numexisting
//	from diskerase
//	where boxno = :ls_boxno
//	and driveserialno = :ls_driveserial
//	using sqlca;
//	
//	if ll_numexisting > 0 then continue
	
//	// Create a new row in the sybase datastore.
//	ll_newrow = lds_sybase.insertrow(0)	
	
	if isnull(ls_filename) then ls_filename = ""
	if isnull(ls_source) then ls_source = ""
	if isnull(ls_boxno) then ls_boxno = ""
	if isnull(ls_gpn) then ls_gpn = ""
	if isnull(ls_mpn) then ls_mpn = ""
	if isnull(ls_driveserial) then ls_driveserial = ""
	if isnull(ldtm_createdate) then ldtm_createdate = datetime("1/1/1900 00:00:00")
	if isnull(ldtm_importdate) then ldtm_importdate = datetime("1/1/1900 00:00:00")
	
	Insert into diskerase values(:ls_filename, :ls_source, :ls_boxno, :ls_gpn, :ls_mpn, :ls_driveserial, :ldtm_createdate, :ldtm_importdate) using sqlca;
	
	If sqlca.sqlcode < 0 then
		
			// Set the record as processed.
			SetProfileString ( "diskerase.ini", "IMPORTERROR", string(ll_recordnum), "error" )
		
	ElseIf sqlca.SQLNRows <> 1 then
		
			// Set the record as processed.
			SetProfileString ( "diskerase.ini", "IMPORTERROR", string(ll_recordnum), "error" )
		
	End IF
	
//	// Input the date for the new row.
//	lds_sybase.setitem(ll_newrow, "filename", ls_filename)
//	lds_sybase.setitem(ll_newrow, "source", ls_source)
//	lds_sybase.setitem(ll_newrow, "boxno", ls_boxno)
//	lds_sybase.setitem(ll_newrow, "partno", ls_gpn)
//	lds_sybase.setitem(ll_newrow, "manpartno", ls_mpn)
//	lds_sybase.setitem(ll_newrow, "driveserialno", ls_driveserial)
//	lds_sybase.setitem(ll_newrow, "creationdate", ldtm_createdate)
//	lds_sybase.setitem(ll_newrow, "importdate", ldtm_importdate)
	
//	if mod(ll_recordnum, 10000) = 0 then
		
//		// Set the record as processed.
//		SetProfileString ( "diskerase.ini", "IMPORT", string(ll_recordnum), "processed" )

//		// Update the sybase database.
//		messagebox("updating db", lds_sybase.update())
//		if lds_sybase.update() < 0 then
//		
//			// Set the record as processed.
//			SetProfileString ( "diskerase.ini", "IMPORTERROR", string(ll_recordnum), "error" )
//			
//		End If
//		if sqlca.sqlcode < 0 then
//		
//			// Set the record as processed.
//			SetProfileString ( "diskerase.ini", "IMPORTERROR", string(ll_recordnum), "error" )
//			exit
//			
//		End If
		
//		Destroy lds_sybase
//		lds_sybase = Create datastore
//		lds_sybase.dataobject = "d_import_tosybase"
//		lds_sybase.settransobject(sqlca)
		
		if lb_quit then
		
			exit
		End If
		
//	End If
	
// Next Diskerase record.
Next

Destroy lds_access

Disconnect using lt_sqlcz;

Destroy lt_sqlcz

// Update the sybase database.
messagebox("Import operation complete", "")

//Destroy lds_sybase
end event

type cb_6 from commandbutton within w_diskerase
integer x = 1134
integer y = 784
integer width = 462
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Done"
end type

event clicked;// If were in auto mode,
If ib_auto then
	
	// Confirm shutdown intentions.
	If messagebox("Automated Diskerase Process Warning", "The DiskErase process is running in AutoMode.~rn If you shutdown this window the DiskErase process will be taken out of AutoMode.~rn Do you still want to close this window?", question!, yesno!, 2) = 1 then
			
		// Reset ib_auto
		ib_auto = false
		
		// Deactivate the timer.
		timer(0)
		
		// Reset the button text.
		text = "AutoMode Off"
		
		// Close the parent window.
		close(parent)
		
	// End confirm shutdown intenetions.
	End If
	
// Otherwise, if were not in auto mode,
Else
		
		// Close the parent window.
		close(parent)
	
// End if were in AutoMode.
End If

end event

type rb_2 from radiobutton within w_diskerase
integer x = 1792
integer y = 448
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 67108864
string text = "Every Hour"
boolean checked = true
end type

type rb_1 from radiobutton within w_diskerase
integer x = 1792
integer y = 528
integer width = 462
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 32768
long backcolor = 67108864
string text = "5AM and 5PM"
end type

type st_2 from statictext within w_diskerase
integer x = 549
integer y = 432
integer width = 274
integer height = 112
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "THEN"
boolean focusrectangle = false
end type

type st_1 from statictext within w_diskerase
integer x = 603
integer y = 208
integer width = 165
integer height = 112
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "OR"
boolean focusrectangle = false
end type

type cb_5 from commandbutton within w_diskerase
integer x = 786
integer y = 208
integer width = 494
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import Clearing"
end type

event clicked;boolean lb_goodprocess

//// if we can import the sims records,
//if invo_diskerase.f_importsims() then

	// Import the clearing file.
	if invo_diskerase.f_importclearingfile() then

		// Show success message.
		messagebox("Clearing File Export", "Clearing File Success.")
		
	// Otherwise, if we import the clearing file,
	Else

		// Show failure message.
		messagebox("Clearing File Export", "Clearing File Failure.")
		
	End If
	
//// Otherwise, if we cant import the sims records,
//Else
//
//	// Show failure message.
//	messagebox("SIMS Import", "SIMS import failure.")
//	
//// End if we cant import the sims records,
//End If
end event

type cb_4 from commandbutton within w_diskerase
integer x = 110
integer y = 144
integer width = 466
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&MIM && GGG"
end type

event clicked;// Suck in the data and spit out the clearing file.
if invo_diskerase.f_suckandspit() then	

	// Show success message.
	messagebox("MIM & GGG Import", "Import Success.")
	
// Otherwise, if we cant generate the clearing file,
Else

	// Show failure message.
	messagebox("MIM & GGG Import", "Import Failure.")
	
// End if we cant generate the clearing file,
End If
end event

type cb_3 from commandbutton within w_diskerase
integer x = 1792
integer y = 192
integer width = 462
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&AutoMode Off"
end type

event clicked;// If were in auto mode,
If ib_auto then
	
	// Set automode on the object.
	invo_diskerase.f_automode(false)
	
	// Reset ib_auto
	ib_auto = false
	
	// Deactivate the timer.
	timer(0)
	
	// Reset the button text.
	text = "AutoMode Off"
	
// Otherwise, if were not already in auto mode,
else
	
	// Set automode on the object.
	invo_diskerase.f_automode(true)
	
	// Reset ib_auto
	ib_auto = true
	
	// Activate the timer.
//	timer(36)
	timer(3600)
	
	// Reset the button text.
	text = "AutoMode On"
	
// End if were not already in auto mode.
End If
end event

type cb_2 from commandbutton within w_diskerase
integer x = 457
integer y = 560
integer width = 462
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cleare&d"
end type

event clicked;boolean lb_goodprocess

//// if we can import the sims records,
//if invo_diskerase.f_importsims() then

	// Export the first response to Pandora.
	if invo_diskerase.f_autosoc() then	

		// Show success message.
		messagebox("AutoSoc", "Finished creating automated SOC's.")
		
	// Otherwise, if we cant generate the clearing file,
	Else

		// Show failure message.
		messagebox("AutoSoc", "Could not create automated SOC's.")
		
	End If
	
//// Otherwise, if we cant import the sims records,
//Else
//
//	// Show failure message.
//	messagebox("SIMS Import", "SIMS import failure.")
//	
//// End if we cant import the sims records,
//End If
end event

type cb_1 from commandbutton within w_diskerase
integer x = 110
integer y = 272
integer width = 466
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Create Clearing"
end type

event clicked;boolean lb_goodprocess

//// if we can import the sims records,
//if invo_diskerase.f_importsims() then

	// Export the first response to Pandora.
	if invo_diskerase.f_exportclearingfile() then

		// Show success message.
		messagebox("Clearing File Export", "Clearing File Success.")
		
	// Otherwise, if we cant generate the clearing file,
	Else

		// Show failure message.
		messagebox("Clearing File Export", "Clearing File Failure.")
		
	End If
	
//// Otherwise, if we cant import the sims records,
//Else
//
//	// Show failure message.
//	messagebox("SIMS Import", "SIMS import failure.")
//	
//// End if we cant import the sims records,
//End If
end event

type gb_1 from groupbox within w_diskerase
integer x = 18
integer y = 16
integer width = 1335
integer height = 736
integer taborder = 10
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Manual Controls"
end type

type gb_2 from groupbox within w_diskerase
integer x = 1371
integer y = 16
integer width = 1335
integer height = 736
integer taborder = 20
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Automated Controls"
end type

