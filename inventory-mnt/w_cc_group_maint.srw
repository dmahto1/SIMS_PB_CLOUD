HA$PBExportHeader$w_cc_group_maint.srw
forward
global type w_cc_group_maint from w_master
end type
type cb_cc_group_cancel from commandbutton within w_cc_group_maint
end type
type cb_cc_group_ok from commandbutton within w_cc_group_maint
end type
type dw_1 from u_dw within w_cc_group_maint
end type
type p_arrow from picture within w_cc_group_maint
end type
type dw_2 from u_dw within w_cc_group_maint
end type
type st_cc_group_select_warehouse from statictext within w_cc_group_maint
end type
end forward

global type w_cc_group_maint from w_master
integer width = 2263
integer height = 2036
string title = "Cycle Count Group Maintenance"
string menuname = "m_simple_edit"
event ue_retrieve ( )
event ue_cancel ( )
event ue_ok ( )
event ue_new ( )
event ue_delete ( )
event ue_file ( )
cb_cc_group_cancel cb_cc_group_cancel
cb_cc_group_ok cb_cc_group_ok
dw_1 dw_1
p_arrow p_arrow
dw_2 dw_2
st_cc_group_select_warehouse st_cc_group_select_warehouse
end type
global w_cc_group_maint w_cc_group_maint

type variables
constant integer failure = -1
constant integer success = 0

string iswarehouse
string isTitle
end variables

forward prototypes
public function string getwarehouse ()
public subroutine settitle (string _value)
public function string gettitle ()
public function integer doduplicatecheck ()
public function integer docountrows (string _groupid)
public subroutine setwarehouse (string _value)
public subroutine doexcelexport ()
end prototypes

event ue_retrieve();long rows

rows = dw_1.retrieve( gs_project  )
if rows = 0 then dw_1.event trigger ue_insert()
dw_1.setfocus()


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

event ue_ok();// ue_ok()

if event ue_save() <> success then
	beep( 1 )
	messagebox( getTitle(), "Save Failed!", stopsign! )
	return 
end if

close( this )



end event

event ue_new();dw_1.event ue_insert()

end event

event ue_delete();
if messagebox( getTitle(), "Are you sure you want to DELETE the current row?", question!, yesno! ) <> 1 then return

dw_1.deleterow( dw_1.getrow() )
if dw_1.rowcount() = 0 then dw_1.event ue_insert()



end event

event ue_file();if dw_1.rowcount() <=0 then return

if messagebox( "Save As", "Export to Excel?",question!,yesno!) = 1 then
	doExcelExport(  )
else
	dw_1.Saveas()
end if
	
end event

public function string getwarehouse ();// getwarehouse()
return isWarehouse

end function

public subroutine settitle (string _value);// setTitle( string _value )
isTitle = _value

end subroutine

public function string gettitle ();// getTitle()
return isTitle

end function

public function integer doduplicatecheck ();// int = doDuplicateCheck()

int 					index
int 					max
boolean 			errorFound
string				groupId
dwitemstatus 	theStatus

max = dw_1.rowcount()

for index = 1 to max
	theStatus = dw_1.getItemStatus( index, 0, primary! )
	if theStatus <> new! or theStatus <> newmodified! then continue  // only test new rows.
	
	groupId = dw_1.object.group_id[ index ]
	if isNull( groupId ) or len( groupId ) = 0 then continue
	if doCountRows( dw_1.object.group_id[ index ] ) = failure then
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

public function integer docountrows (string _groupid);// doCountRows( string _groupid )

string filterthis
integer result

filterthis = "group_id = '" + trim( _groupid ) + "'"

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

public subroutine setwarehouse (string _value);// setWarehouse( string _value )

if isNull( _value ) or len( _value ) = 0 then return

isWarehouse = _value

event trigger ue_retrieve( )

end subroutine

public subroutine doexcelexport ();// doExcelExport()
long rows

u_dwexporter exportr

rows = dw_1.rowcount()
if rows > 0 then 
	exportr.initialize()
	exportr.doExcelExport( dw_1, rows, true  )	
	exportr.cleanup()
end if


end subroutine

on w_cc_group_maint.create
int iCurrent
call super::create
if this.MenuName = "m_simple_edit" then this.MenuID = create m_simple_edit
this.cb_cc_group_cancel=create cb_cc_group_cancel
this.cb_cc_group_ok=create cb_cc_group_ok
this.dw_1=create dw_1
this.p_arrow=create p_arrow
this.dw_2=create dw_2
this.st_cc_group_select_warehouse=create st_cc_group_select_warehouse
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cc_group_cancel
this.Control[iCurrent+2]=this.cb_cc_group_ok
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.p_arrow
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.st_cc_group_select_warehouse
end on

on w_cc_group_maint.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_cc_group_cancel)
destroy(this.cb_cc_group_ok)
destroy(this.dw_1)
destroy(this.p_arrow)
destroy(this.dw_2)
destroy(this.st_cc_group_select_warehouse)
end on

event ue_postopen;call super::ue_postopen;datawindowchild ldc

setwarehouse( "-" )

setTitle( this.title )

//getchild( dw_2, "wh_code", ldc )
//ldc.settransobject( sqlca )
//ldc.retrieve( gs_project )
//dw_2.insertrow(0)

dw_1.setrowfocusindicator( p_arrow )
event ue_retrieve()


end event

event resize;call super::resize;
dw_1.event ue_resize()
cb_cc_group_ok.event ue_resize()
cb_cc_group_cancel.event ue_resize()

end event

event ue_save;call super::ue_save;
SQLCA.DBParm = "disablebind =0"
if dw_1.update( ) <> 1 then
	SQLCA.DBParm = "disablebind =1"
	Execute Immediate "ROLLBACK" using SQLCA;
	return failure
end if
SQLCA.DBParm = "disablebind =1"
Execute Immediate "COMMIT" using SQLCA;

return success


end event

event ue_preupdate;call super::ue_preupdate;// int = doDuplicateCheck()

int 					index
int 					max
boolean 			errorFound
string				groupId
dwitemstatus 	theStatus

max = dw_1.rowcount()

// get rid of new...unmodified rows

for index = 1 to max
	theStatus = dw_1.getItemStatus( index, 0, primary! )
	if theStatus = New! then
		dw_1.deleterow( index )
		index --
		max --
	end if
next

// check for dups

if doDuplicateCheck() < 0 then return failure

return success

end event

type cb_cc_group_cancel from commandbutton within w_cc_group_maint
event ue_resize ( )
integer x = 1257
integer y = 1720
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event ue_resize();this.y = parent.height - this.height - 150
end event

event clicked;parent.event ue_cancel()

end event

event constructor;

g.of_check_label_button(this)
end event

type cb_cc_group_ok from commandbutton within w_cc_group_maint
event ue_resize ( )
integer x = 462
integer y = 1720
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event ue_resize();
this.y = parent.height - this.height - 150

end event

event clicked;parent.event ue_ok()
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_1 from u_dw within w_cc_group_maint
integer y = 28
integer width = 2171
integer height = 1652
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cc_group_mnt"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_insert;call super::ue_insert;// ue_insert()

long aRow

if getrow() = 0 then
	aRow = insertrow( 0 )
else
	aRow = insertrow( getrow() )
end if
dw_1.object.project_id[ aRow ] = gs_project
dw_1.object.wh_code[ aRow ] = getwarehouse()
dw_1.setitemstatus( aRow, 0, primary!, Notmodified! )
dw_1.setRow( aRow )
dw_1.scrolltorow( aRow )



end event

event ue_resize;call super::ue_resize;
this.width = parent.width - 50
this.height = ( parent.height - 300 )

end event

type p_arrow from picture within w_cc_group_maint
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

type dw_2 from u_dw within w_cc_group_maint
boolean visible = false
integer y = 80
integer width = 1047
integer height = 84
boolean bringtotop = true
string dataobject = "d_dddw_warehouse_dropdown"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
//choose case dwo.name
//	case "wh_code"
//		setWarehouse( data )
//end choose
//
end event

type st_cc_group_select_warehouse from statictext within w_cc_group_maint
boolean visible = false
integer y = 12
integer width = 754
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Warehouse.."
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

