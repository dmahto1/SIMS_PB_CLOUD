$PBExportHeader$u_select_available_report.sru
forward
global type u_select_available_report from u_select_available
end type
type cb_new from commandbutton within u_select_available_report
end type
type cb_select_avail_report_editmode from commandbutton within u_select_available_report
end type
type cb_editrpt from commandbutton within u_select_available_report
end type
type cb_delete from commandbutton within u_select_available_report
end type
type cb_select_avail_report_clear from commandbutton within u_select_available_report
end type
type cb_setseq from commandbutton within u_select_available_report
end type
type cb_select_avail_report_default from commandbutton within u_select_available_report
end type
type cb_select_avail_report_baseline_report from commandbutton within u_select_available_report
end type
end forward

global type u_select_available_report from u_select_available
integer width = 3433
integer height = 1844
event ue_newreport ( )
event ue_save ( )
event ue_editmode ( )
event ue_edit ( )
event ue_delete ( )
event ue_clear ( )
event ue_setseqequaltorow ( )
event ue_populatedefaults ( )
cb_new cb_new
cb_select_avail_report_editmode cb_select_avail_report_editmode
cb_editrpt cb_editrpt
cb_delete cb_delete
cb_select_avail_report_clear cb_select_avail_report_clear
cb_setseq cb_setseq
cb_select_avail_report_default cb_select_avail_report_default
cb_select_avail_report_baseline_report cb_select_avail_report_baseline_report
end type
global u_select_available_report u_select_available_report

type variables
boolean ibDeveloper

int iiMaxSequence

boolean ibEditMode
long selectedRows[]



end variables

forward prototypes
public function long doavailableretrieve ()
public function long doselectedretrieve ()
public subroutine doadditem (long addrow)
public function boolean doreportidcheck (string asreportid)
public subroutine doremoveitem (long removerow)
public function boolean dovalidate ()
public function integer dosequencecheck (decimal avalue)
public subroutine seteditmode (boolean mode)
public function boolean geteditmode ()
public subroutine setselections ()
public subroutine doresetselected ()
public subroutine setdeveloper (boolean abool)
public function boolean getdeveloper ()
public subroutine dodeveloperdisplay ()
public function integer docheckconstraints (string id, string asname)
public subroutine setmaxsequence (integer avalue)
public function integer getmaxsequence ()
end prototypes

event ue_newreport();// ue_newReport()
str_parms lstrparms

lstrParms.string_arg[1] = getProject() 
lstrParms.string_arg[2] = 'New'

openwithparm( w_new_report_edit, lstrParms )

lstrparms = message.PowerObjectParm
if NOT lstrparms.Cancelled then doAvailableRetrieve()

end event

event ue_save();// ue_save()

if NOT doValidate() then return

Execute Immediate "Begin Transaction" using SQLCA;

if dw_selected.Update() <> 1 then
	Execute Immediate "ROLLBACK" using SQLCA;
else
	Execute Immediate "COMMIT" using SQLCA;
end if
doAvailableRetrieve()
doSelectedRetrieve()
g.ids_reports.Retrieve( GetProject() )



end event

event ue_editmode();// ue_editMode

string  ls_edit_sequence = 'Edit Sequence'
string ls_select_mode = 'Select Mode'

if upper(gs_project) = 'CHINASIMS' then
	
	ls_edit_sequence = '编辑顺序'
	ls_select_mode = '选择形式'

	
end if

if cb_select_avail_report_editmode.text =ls_edit_sequence then
	setEditMode( true )
	cb_select_avail_report_editmode.text = ls_select_mode
	cb_uo_available_remove_all.enabled = false
	cb_2.enabled = false
	SetSelections()
	dw_selected.selectrow( 0, false )
	dw_selected.object.seq.border = 5
	dw_selected.object.seq.Protect = 0
	dw_selected.setfocus()
	dw_selected.setrow( 1 )
	dw_selected.scrolltorow(1)
	dw_selected.setcolumn( 'seq')
else
	cb_select_avail_report_editmode.text = ls_edit_sequence
	setEditMode( false)
	cb_uo_available_remove_all.enabled = true
	cb_2.enabled = true
	dw_selected.object.seq.border = 0
	dw_selected.object.seq.Protect =1
	doresetselected()
end if

	

end event

event ue_edit();// ue_edit 
long 			llRow

str_parms lstrparms

if dw_available.getrow() <=0 then return

llRow = dw_available.getselectedrow( 0 )
if llRow <=0 then return

lstrparms.string_arg[1] = getProject() 
lstrparms.string_arg[2] = dw_available.object.report_id[ llRow ]

openwithparm( w_new_report_edit, lstrparms )
lstrparms = message.PowerObjectParm
if  lstrparms.Cancelled then return

dw_available.selectrow( llRow, true )
dw_available.scrolltorow( llRow )
dw_available.setrow( llRow )



end event

event ue_delete();// ue_delete
long _selectedrow
string _reportName

_selectedrow = dw_available.getselectedrow(0)
if _selectedrow <= 0 then return

_reportName = dw_available.object.report_name[ _selectedrow ]

if doCheckConstraints( dw_available.object.report_id[ _selectedrow ] , _reportName ) < 0 then return

if messagebox("Delete Report","Are you sure you want to delete report " + _reportName + "?", question!,yesno!) = 2 then return

dw_available.deleterow( _selectedrow )

Execute Immediate "Begin Transaction" using SQLCA;
if dw_available.Update() <> 1 then
	Execute Immediate "ROLLBACK" using SQLCA;
else
	Execute Immediate "COMMIT" using SQLCA;
end if
doAvailableRetrieve()
doSelectedRetrieve()




end event

event ue_clear();
dw_available.selectrow( 0, false )
dw_selected.selectrow( 0, false )

end event

event ue_setseqequaltorow();//ue_setSeqEqualToRow()

// set the sequence number equal to the row number
int index
int max

max = dw_selected.rowcount()

for index = 1 to max
	dw_selected.object.seq[ index ] = index
next

end event

event ue_populatedefaults();// ue_populatedefaults()

// populate the report list with the default reports

string filterstring = "Upper( default_report ) = 'Y'"

dw_available.setfilter( filterstring )
dw_available.filter()

event ue_selectAll()
event ue_AddItem()

dw_available.setfilter( "" )
dw_available.filter()




end event

public function long doavailableretrieve ();return dw_available.retrieve(getProject() )

end function

public function long doselectedretrieve ();// doSelectedRetrieve()
long lRows

lRows = dw_selected.retrieve( getProject() )

if lRows <=0 or isNull( lRows ) then return 0

setMaxSequence( dw_selected.object.seq[ lRows ] )
return lRows

end function

public subroutine doadditem (long addrow);// doAddItem( long addRow )

long _newRow
int _newSeq

if doReportIDCheck( dw_available.object.report_id[ addRow] ) then
	return
end if

dw_selected.setredraw( false )

_newRow = dw_selected.insertrow( 0 )
_newSeq = getMaxSequence() + 1
setMaxSequence( _newseq )
dw_selected.object.project_id[ _newrow ] = getProject()
dw_selected.object.report_id[ _newrow ] = dw_available.object.report_id[ addRow ]
dw_selected.object.report_name[ _newrow ] = dw_available.object.report_name[ addRow ]
dw_selected.object.seq[ _newrow ] = _newSeq
dw_selected.scrolltorow( _newrow )
dw_selected.setrow( _newrow )
dw_selected.selectrow( _newrow, true )

dw_available.deleterow( addrow )

dw_selected.setredraw( true )


end subroutine

public function boolean doreportidcheck (string asreportid);// boolean doReportIDCheck()

string _begin = 'report_id = ~''
string _end = '~''
string _findthis
long _foundRow

_findthis = _begin + asReportid + _end

_foundRow = dw_selected.find( _findthis, 1, dw_selected.rowcount() )
if _foundRow <= 0 then return false

dw_selected.selectrow( _foundRow, true )
return true

end function

public subroutine doremoveitem (long removerow);long _newRow

dw_available.setredraw( false )

_newRow = dw_available.insertrow( 0 )

dw_available.object.report_id[ _newrow ] = dw_selected.object.report_id[ removeRow ]
dw_available.object.report_name[ _newrow ] = dw_selected.object.report_name[ removeRow ]

dw_selected.deleterow( removeRow )

dw_available.setredraw( true )

end subroutine

public function boolean dovalidate ();// sequence numbers must be unique..
long modRow
string sbegin = 'Seq = '
boolean returncode

dw_selected.accepttext()

returnCode = true
modRow = dw_selected.getNextModified( 0, primary! )
do while modRow > 0
	if  isNull(dw_selected.object.seq[ modRow]) then
		messagebox( "Error!","Missing or Invalid Sequence Number", exclamation! )
		returncode = false
		exit
	end if
	
	if  dw_selected.object.seq[ modRow]  <=0 then
		messagebox( "Error!","Sequence Number Can Not Be Less Than or Equal To Zero.,", exclamation! )
		returncode = false
		exit
	end if

	if DoSequenceCheck( dw_selected.object.seq[ modRow] ) <> success then
		messagebox( "Error!","Unable to Save, Duplicate Sequence Numbers!", exclamation! )
		returncode = false
		exit
	end if
	modRow = dw_selected.getNextModified( modRow, primary! )
loop

return returnCode

end function

public function integer dosequencecheck (decimal avalue);string sbegin = 'seq = '
string searchfor
int returncode

returncode = success

searchfor = sbegin + string ( avalue )

dw_selected.setredraw( false )

dw_selected.setfilter( searchfor )
dw_selected.filter()

if dw_selected.rowcount() > 1 then 
	returncode = failure
end if

dw_selected.setfilter( '' )
dw_selected.filter()
dw_selected.setsort( "seq a")
dw_selected.sort()

dw_selected.setredraw( true )
return returncode



end function

public subroutine seteditmode (boolean mode);// setEditMode()
ibEditMode = mode

end subroutine

public function boolean geteditmode ();// boolean = getEditMode()
return ibEditMode

end function

public subroutine setselections ();// SetSelections()
long arow
int cntr

arow = dw_selected.getselectedrow( arow )
do while arow > 0
	cntr++
	selectedrows[ cntr ] = arow
	arow = dw_selected.getselectedrow( arow )
loop


end subroutine

public subroutine doresetselected ();// doresetselected()

long arow
int cntr
int index
int max
long dummy[]

max = Upperbound( selectedrows )
for index = 1 to max
	dw_selected.selectrow( selectedrows[ index ], true )
next
selectedrows = dummy



end subroutine

public subroutine setdeveloper (boolean abool);ibdeveloper = abool

end subroutine

public function boolean getdeveloper ();return ibDeveloper

end function

public subroutine dodeveloperdisplay ();// doDeveloperDisplay()
boolean _developer

_developer = getDeveloper()
cb_new.visible = _developer
cb_editrpt.visible = _developer
cb_delete.visible = _developer
cb_setseq.visible = _developer

end subroutine

public function integer docheckconstraints (string id, string asname);// int = doCheckContraints( string id )

datastore ldsProjects
long index
long max
string _nl = '~r~n'
string sbegin
string sprojects= ''
string _send = '~r~nPlease Remove These References and Re-Try.'


sbegin = 'The Report: ' + asName + '~r~nIs Currently Used By...~r~n~r~n'

ldsProjects = create datastore
ldsProjects.dataobject = 'd_project_reports_by_report_id'
ldsProjects.settransobject( sqlca )

max = ldsProjects.retrieve( id )

if max <= 0 then return success

if max > 10 then max = 10

for index = 1 to max
	sprojects += Trim(  ldsProjects.object.project_id[ index ] ) + _nl
next

messagebox( "Report ID Contraint Check", sbegin + sprojects + _send, exclamation! )
return failure

end function

public subroutine setmaxsequence (integer avalue);// setMaxSequence( int avalue )
iiMaxSequence = avalue

end subroutine

public function integer getmaxsequence ();// int = getMaxSequence()
if isNull( iiMaxSequence  ) then iiMaxSequence = 0

return iiMaxSequence

end function

on u_select_available_report.create
int iCurrent
call super::create
this.cb_new=create cb_new
this.cb_select_avail_report_editmode=create cb_select_avail_report_editmode
this.cb_editrpt=create cb_editrpt
this.cb_delete=create cb_delete
this.cb_select_avail_report_clear=create cb_select_avail_report_clear
this.cb_setseq=create cb_setseq
this.cb_select_avail_report_default=create cb_select_avail_report_default
this.cb_select_avail_report_baseline_report=create cb_select_avail_report_baseline_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new
this.Control[iCurrent+2]=this.cb_select_avail_report_editmode
this.Control[iCurrent+3]=this.cb_editrpt
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_select_avail_report_clear
this.Control[iCurrent+6]=this.cb_setseq
this.Control[iCurrent+7]=this.cb_select_avail_report_default
this.Control[iCurrent+8]=this.cb_select_avail_report_baseline_report
end on

on u_select_available_report.destroy
call super::destroy
destroy(this.cb_new)
destroy(this.cb_select_avail_report_editmode)
destroy(this.cb_editrpt)
destroy(this.cb_delete)
destroy(this.cb_select_avail_report_clear)
destroy(this.cb_setseq)
destroy(this.cb_select_avail_report_default)
destroy(this.cb_select_avail_report_baseline_report)
end on

event constructor;call super::constructor;
setDeveloper( false )

If gs_role = '-1' Then setDeveloper( true )

setAvailableDW( 'd_available_reports')
setSelectedDW( 'd_report_selections')
setEditMode(  false )

doDeveloperDisplay()
 
end event

type cb_uo_available_remove_all from u_select_available`cb_uo_available_remove_all within u_select_available_report
integer x = 1518
integer y = 988
integer width = 398
integer taborder = 70
string text = "<Remove All"
end type

type cb_uo_available_select_all from u_select_available`cb_uo_available_select_all within u_select_available_report
integer x = 1518
integer y = 628
integer width = 398
integer taborder = 60
string text = "Select All>"
end type

type cb_2 from u_select_available`cb_2 within u_select_available_report
integer x = 1518
integer y = 900
integer width = 398
integer taborder = 40
end type

type cb_1 from u_select_available`cb_1 within u_select_available_report
integer x = 1518
integer y = 712
integer width = 398
integer taborder = 30
end type

type dw_selected from u_select_available`dw_selected within u_select_available_report
integer x = 1925
integer y = 68
integer width = 1509
integer height = 1652
end type

event dw_selected::clicked;if row <=0 then return

if  getEditMode() then return

if isSelected( row ) then
	selectrow( row, false )
else
	selectrow( row, true )
end if

end event

type dw_available from u_select_available`dw_available within u_select_available_report
integer y = 68
integer width = 1509
integer height = 1652
end type

type st_cb_uo_available_selected from u_select_available`st_cb_uo_available_selected within u_select_available_report
integer x = 1925
integer width = 1509
end type

type st_uo_available_available from u_select_available`st_uo_available_available within u_select_available_report
integer width = 1509
end type

type cb_new from commandbutton within u_select_available_report
boolean visible = false
integer x = 1262
integer y = 1740
integer width = 247
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New "
end type

event clicked;parent.event ue_newReport()

end event

type cb_select_avail_report_editmode from commandbutton within u_select_available_report
integer x = 2427
integer y = 1740
integer width = 517
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Sequence"
end type

event clicked;parent.event ue_editmode()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_editrpt from commandbutton within u_select_available_report
boolean visible = false
integer x = 23
integer y = 1740
integer width = 357
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Report"
end type

event clicked;parent.event ue_edit()
end event

type cb_delete from commandbutton within u_select_available_report
boolean visible = false
integer x = 448
integer y = 1740
integer width = 279
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;parent.event ue_delete()

end event

type cb_select_avail_report_clear from commandbutton within u_select_available_report
integer x = 1518
integer y = 1136
integer width = 398
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;parent.event ue_clear()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_setseq from commandbutton within u_select_available_report
boolean visible = false
integer x = 1929
integer y = 1740
integer width = 448
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Seq=Row"
end type

event clicked;parent.event ue_setSeqEqualToRow()

end event

type cb_select_avail_report_default from commandbutton within u_select_available_report
event ue_populatedefaults ( )
integer x = 1518
integer y = 416
integer width = 398
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Default >>"
end type

event clicked;parent.event ue_populateDefaults()
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_select_avail_report_baseline_report from commandbutton within u_select_available_report
integer x = 777
integer y = 1740
integer width = 430
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Baseline Report"
end type

event clicked;nvo_baseline lnvo_bl
string ls_reportid, ls_reportname
long ll_reportrow

// Get the row number of the selected report.
ll_reportrow = dw_available.getrow()

// If there is no report selected,
If ll_reportrow = 0 then
	
	// Warn the user
	messagebox("SIMS - Baseline Reports", "Please select a report from the available list before proceeding.")
	
	// Exit processing.
	return
End If

// Get the report name.
ls_reportid = dw_available.getitemstring(ll_reportrow, "report_id")
ls_reportname = dw_available.getitemstring(ll_reportrow, "report_name")

// Create the baseline object.
lnvo_bl = Create nvo_baseline

// If we can create an instance of the selected report across all projects,
If lnvo_bl.f_baselinereport(ls_reportid, ls_reportname) then
	
	// Re-retrieve the available and member dw's.
	doAvailableRetrieve()
	doSelectedRetrieve()
	g.ids_reports.Retrieve(GetProject())
	
	// Show success message.
	messagebox("Baseline Selected Report", "The baselining operation was successful")
	
// Otherwise, if we cannot create an instance of the selected report across all projects,
Else
	
	// Show failure message.
	messagebox("Baseline Selected Report", "The baselining operation failed")
	
// End if we cannot create an instance of the selected report across all projects.
End If

// Destroy the baseline object.
Destroy lnvo_bl
end event

event constructor;
g.of_check_label_button(this)

long ll_roleasnumber

// Get the users role as a number.
ll_roleasnumber = long(gs_role)

// What is the users role?
Choose Case long(gs_role)
		
	// Something less than a Super-User,
	Case is > 0
		
		// Make this option invisible.
		this.visible = false
		
	// IT or Super-User
	Case Else
		
		// This option is visible to IT and SuperUsers.
		
// End What is the users role.		
End Choose
end event

