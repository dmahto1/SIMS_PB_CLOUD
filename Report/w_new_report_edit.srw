HA$PBExportHeader$w_new_report_edit.srw
forward
global type w_new_report_edit from w_response_ancestor
end type
type dw_report_edit from datawindow within w_new_report_edit
end type
end forward

global type w_new_report_edit from w_response_ancestor
integer height = 1156
string title = "New Report Edit"
event type boolean ue_save ( )
dw_report_edit dw_report_edit
end type
global w_new_report_edit w_new_report_edit

type variables
string 			isProject
datastore 		idsReports
boolean		ibnew

//str_parms istr_parms


end variables

forward prototypes
public function boolean dovalidate ()
public subroutine setproject (string asproject)
public function string getproject ()
public function long doretrieve (string id)
public subroutine setnew (boolean abool)
public function boolean getnew ()
end prototypes

event type boolean ue_save();// boolean ue_save()

boolean successful

successful = true

if doValidate() then
	Execute Immediate "Begin Transaction" using SQLCA;
	if dw_report_edit.Update() <> 1 then
		Execute Immediate "ROLLBACK" using SQLCA;
		successful = false
	else
		Execute Immediate "COMMIT" using SQLCA;
	end if
else
	successful = false
end if

return successful

end event

public function boolean dovalidate ();
string sTester
long lRows

dw_report_edit.accepttext()

sTester = dw_report_edit.object.report_id[ 1 ]
if IsNull( sTester ) or len( sTester ) = 0 then
	messagebox( "Missing Value","Report ID is a Required Field.", exclamation! )
	dw_report_edit.setfocus()
	dw_report_edit.setcolumn( "report_id" )
	return false
end if

sTester = dw_report_edit.object.report_name[ 1 ]
if IsNull( sTester ) or len( sTester ) = 0 then
	messagebox( "Missing Value","Report Name is a Required Field.", exclamation! )
	dw_report_edit.setfocus()
	dw_report_edit.setcolumn( "report_id" )
	return false
end if

sTester = dw_report_edit.object.report_window[ 1 ]
if IsNull( sTester ) or len( sTester ) = 0 then
	messagebox( "Missing Value","Report Window is a Required Field.", exclamation! )
	dw_report_edit.setfocus()
	dw_report_edit.setcolumn( "report_id" )
	return false
end if

sTester = dw_report_edit.object.report_access[ 1 ]
if IsNull( sTester ) or len( sTester ) = 0 then
	messagebox( "Missing Value","Report Access is a Required Field.", exclamation! )
	dw_report_edit.setfocus()
	dw_report_edit.setcolumn( "report_id" )
	return false
end if

if getNew() then 
	lRows = idsreports.retrieve(  dw_report_edit.object.report_id[ 1 ]  )
	if lRows > 0 then 
		messagebox( "Duplicate Report ID", "Unable to save, Report ID already exists.",exclamation! )
		dw_report_edit.setfocus()
		dw_report_edit.setcolumn( "report_id" )
		return false
	end if
end if


return true

end function

public subroutine setproject (string asproject);// setProject( string asProject )
isProject = asProject

end subroutine

public function string getproject ();return isProject

end function

public function long doretrieve (string id);// doRetrieve( string id )
long llRows

if IsNull( id ) or len( id ) = 0 then return 0

llRows =  dw_report_edit.retrieve( id )
if llRows <= 0 then return llRows

this.title = "Edit Report " + string( id ) + " for " + getproject()

return llRows


end function

public subroutine setnew (boolean abool);// setNew( boolean abool )
ibNew = abool

end subroutine

public function boolean getnew ();// boolean = getNew()
return ibNew

end function

on w_new_report_edit.create
int iCurrent
call super::create
this.dw_report_edit=create dw_report_edit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report_edit
end on

on w_new_report_edit.destroy
call super::destroy
destroy(this.dw_report_edit)
end on

event ue_close;
if NOT this.event ue_save() then return

closewithreturn( this, istrparms )

end event

event ue_postopen;call super::ue_postopen;string asProject

istrparms = message.PowerObjectParm

idsreports = create datastore
idsreports.dataobject = 'd_report_detail_by_report_id'
idsreports.settransobject( sqlca )

setProject( istrparms.string_arg[1] )

if istrparms.string_arg[2] = 'New' then
	this.title = "New Report for: " + getproject()
	dw_report_edit.insertrow(0)
	setNew( true )
else
	setnew( false )
	doRetrieve( istrparms.string_arg[2] )
	dw_report_edit.setfocus()
end if
istrparms.Cancelled = false
dw_report_edit.setfocus()


end event

event ue_cancel;dwItemStatus _status

dw_report_edit.accepttext()

_status = dw_report_edit.getItemStatus( 1,0,primary! )
if _status = NotModified! or _status = New! then
	istrparms.Cancelled = True
	closewithreturn( this, istrparms )
	return
end if

if messagebox( "Save Changes?","Do you want to save changes?",question!,yesno!) = 1 then
	if NOT this.event ue_save() then return
end if

closewithreturn( this, istrparms )
	
	
end event

event close;call super::close;if isValid( idsreports) then destroy idsreports

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_new_report_edit
end type

type cb_ok from w_response_ancestor`cb_ok within w_new_report_edit
end type

type dw_report_edit from datawindow within w_new_report_edit
integer x = 9
integer y = 12
integer width = 1961
integer height = 928
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_new_report_edit"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event constructor;this.settransobject(sqlca)

end event

