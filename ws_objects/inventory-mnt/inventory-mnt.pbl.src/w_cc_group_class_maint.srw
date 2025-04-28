$PBExportHeader$w_cc_group_class_maint.srw
forward
global type w_cc_group_class_maint from w_master
end type
type p_arrow from picture within w_cc_group_class_maint
end type
type st_cc_group_maint_selet_group from statictext within w_cc_group_class_maint
end type
type dw_2 from u_dw within w_cc_group_class_maint
end type
type dw_1 from u_dw within w_cc_group_class_maint
end type
type cb_cancel from commandbutton within w_cc_group_class_maint
end type
type cb_ok from commandbutton within w_cc_group_class_maint
end type
end forward

global type w_cc_group_class_maint from w_master
integer width = 2075
integer height = 2016
string title = "CC Group Class Maintenance"
string menuname = "m_simple_edit"
event ue_ok ( )
event ue_cancel ( )
event ue_retrieve ( )
event ue_new ( )
event ue_delete ( )
event ue_close ( )
p_arrow p_arrow
st_cc_group_maint_selet_group st_cc_group_maint_selet_group
dw_2 dw_2
dw_1 dw_1
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_cc_group_class_maint w_cc_group_class_maint

type variables
constant integer success = 0
constant integer failure = -1

string isTitle
string isGroupId
end variables

forward prototypes
public subroutine settitle (string _value)
public function string gettitle ()
public subroutine setgroupid (string _value)
public function string getgroupid ()
public function integer docountrows (string _id)
public function integer doduplicatecheck ()
end prototypes

event ue_ok();// ue_ok()

if event ue_save() <> success then
	beep( 1 )
	messagebox( getTitle(), "Save Failed!", stopsign! )
	return 
end if

close( this )


end event

event ue_cancel();// ue_cancel()

int 					index
int 					max
int						result
boolean 			ChangeFound
string				groupId
dwitemstatus 	theStatus

max = dw_1.rowcount()
for index = 1 to max
	theStatus = dw_1.getItemStatus( index, 0, primary! )
	if theStatus = DataModified! or theStatus = newModified! then
		ChangeFound = true
		exit
	end if
next


if changeFound then
	if messagebox( getTitle(), "Do You Wish To Save Changes?", question!, yesno! ) = 1 then	event ue_save() 
end if

close( this )



end event

event ue_retrieve();long rows

if isNull( getGroupId() ) or Len( getGroupId() ) = 0 then
	messagebox( getTitle(), "Please Select a Group", exclamation! )
	return
end if

rows = dw_1.retrieve( gs_project, getGroupId() )
if rows = 0 then dw_1.event trigger ue_insert()
dw_1.setfocus()


end event

event ue_new();dw_1.event ue_insert()
end event

event ue_delete();
if messagebox( getTitle(), "Are you sure you want to DELETE the current row?", question!, yesno! ) <> 1 then return

dw_1.deleterow( dw_1.getrow() )
if dw_1.rowcount() = 0 then dw_1.event ue_insert()



end event

event ue_close();close( this )

end event

public subroutine settitle (string _value);isTitle = _value

end subroutine

public function string gettitle ();return isTitle

end function

public subroutine setgroupid (string _value);isGroupId = _value

end subroutine

public function string getgroupid ();return isGroupID

end function

public function integer docountrows (string _id);// doCountRows( string _id )

string filterthis
integer result

filterthis = "class_code = '" + trim( _id ) + "'"

dw_1.setredraw( false )

dw_1.setFilter( filterthis )
dw_1.filter()

result = success
if dw_1.rowcount() > 1 then	result = failure

dw_1.setFilter( "" )
dw_1.filter()

dw_1.setredraw( true )

return result

end function

public function integer doduplicatecheck ();// int = doDuplicateCheck()

int 					index
int 					max
boolean 			errorFound
string				Id
dwitemstatus 	theStatus

max = dw_1.rowcount()

for index = 1 to max
	theStatus = dw_1.getItemStatus( index, 0, primary! )
	if theStatus <> new! or theStatus <> newmodified! then continue  // only test new rows.
	Id = dw_1.object.class_code[ index ]
	if isNull( Id ) or len( Id ) = 0 then continue
	if doCountRows( id ) = failure then
		errorFound = true
		exit
	end if
next

if errorFound then
	messagebox( getTitle(), "Duplicate Entries Found, Please Check!", exclamation! )
	dw_1.setRow( index )
	dw_1.setfocus()
	return failure
end if
return success

end function

on w_cc_group_class_maint.create
int iCurrent
call super::create
if this.MenuName = "m_simple_edit" then this.MenuID = create m_simple_edit
this.p_arrow=create p_arrow
this.st_cc_group_maint_selet_group=create st_cc_group_maint_selet_group
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_arrow
this.Control[iCurrent+2]=this.st_cc_group_maint_selet_group
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_ok
end on

on w_cc_group_class_maint.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_arrow)
destroy(this.st_cc_group_maint_selet_group)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event resize;call super::resize;
int index
int max

max = UpperBound( control )
for index = 1 to max
	choose case typeof( control[ index ] )
		case datawindow!, commandbutton!, userobject!
			control[index].event dynamic ue_resize()
	end choose
next


end event

event ue_postopen;call super::ue_postopen;datawindowchild ldc
datastore skuGroup

setTitle( this.title )

skuGroup = f_datastoreFactory('d_dddw_cc_group_by_project')
if skuGroup.retrieve( gs_project ) > 0 then
	getchild( dw_2, "groupselect", ldc )
	ldc.settransobject( sqlca )
	ldc.retrieve( gs_project )
	dw_2.insertrow(0)
else
	messagebox( getTitle(), "Please Create Cycle Count Groups First.",stopsign! )
	this.event post ue_close()
end if
this.show()
dw_1.setrowfocusindicator( p_arrow )



end event

event ue_preupdate;call super::ue_preupdate;// int = doDuplicateCheck()

int 					index
int 					max
boolean 			errorFound
string				groupId
dwitemstatus 	theStatus
datetime			ldtToday

ldtToday = f_getLocalWorldTime( gs_default_wh )

max = dw_1.rowcount()

// get rid of new...unmodified rows

for index = 1 to max
	theStatus = dw_1.getItemStatus( index, 0, primary! )
	if theStatus = New! then
		dw_1.deleterow( index )
		index --
		max --
	else
		if theStatus = notModified! then continue
		dw_1.object.last_user[ index ] = gs_userid
		dw_1.object.last_update[index] = ldtToday
	end if
next

// check for dups

if doDuplicateCheck() < 0 then return failure

return success

end event

event ue_save;call super::ue_save;if dw_1.update( ) <> 1 then
	Execute Immediate "ROLLBACK" using SQLCA;
	return failure
end if
Execute Immediate "COMMIT" using SQLCA;

return success


end event

event ue_preopen;call super::ue_preopen;this.hide()

end event

type p_arrow from picture within w_cc_group_class_maint
boolean visible = false
integer x = 1573
integer y = 32
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Next!"
boolean focusrectangle = false
end type

type st_cc_group_maint_selet_group from statictext within w_cc_group_class_maint
integer x = 18
integer width = 718
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Group"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_2 from u_dw within w_cc_group_class_maint
integer x = 9
integer y = 52
integer width = 1170
integer height = 104
string dataobject = "d_cc_group_select"
boolean border = false
boolean livescroll = false
end type

event itemchanged;call super::itemchanged;
setGroupId( data )
parent.event  ue_retrieve()

end event

type dw_1 from u_dw within w_cc_group_class_maint
integer y = 160
integer width = 2007
integer height = 1468
string dataobject = "d_cc_group_class_maint"
boolean vscrollbar = true
boolean border = false
end type

event ue_resize;call super::ue_resize;this.width = parent.width - 50
this.height = ( parent.height - 300 )

end event

event ue_insert;call super::ue_insert;// ue_insert()

long aRow

if getrow() = 0 then
	aRow = insertrow( 0 )
else
	aRow = insertrow( getrow() )
end if
dw_1.object.project_id[ aRow ] = gs_project
dw_1.object.wh_code[ aRow ] = '-'
dw_1.object.group_id[ aRow ] = getGroupId()
dw_1.setitemstatus( aRow, 0, primary!, Notmodified! )
dw_1.setRow( aRow )
dw_1.scrolltorow( aRow )



end event

type cb_cancel from commandbutton within w_cc_group_class_maint
event ue_resize ( )
integer x = 809
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event ue_resize();// ue_resize()
this.y = parent.height - this.height - 150
end event

event clicked;parent.event ue_cancel()

end event

type cb_ok from commandbutton within w_cc_group_class_maint
event ue_resize ( )
integer x = 315
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event ue_resize();// ue_resize()
this.y = parent.height - this.height - 150

end event

event clicked;parent.event ue_ok()

end event

