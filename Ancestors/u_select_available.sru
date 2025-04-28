HA$PBExportHeader$u_select_available.sru
forward
global type u_select_available from userobject
end type
type cb_uo_available_remove_all from commandbutton within u_select_available
end type
type cb_uo_available_select_all from commandbutton within u_select_available
end type
type cb_2 from commandbutton within u_select_available
end type
type cb_1 from commandbutton within u_select_available
end type
type dw_selected from datawindow within u_select_available
end type
type dw_available from datawindow within u_select_available
end type
type st_cb_uo_available_selected from statictext within u_select_available
end type
type st_uo_available_available from statictext within u_select_available
end type
end forward

global type u_select_available from userobject
integer width = 2597
integer height = 1288
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_selectall ( )
event ue_removeall ( )
event ue_removeitem ( )
event ue_additem ( )
cb_uo_available_remove_all cb_uo_available_remove_all
cb_uo_available_select_all cb_uo_available_select_all
cb_2 cb_2
cb_1 cb_1
dw_selected dw_selected
dw_available dw_available
st_cb_uo_available_selected st_cb_uo_available_selected
st_uo_available_available st_uo_available_available
end type
global u_select_available u_select_available

type variables
string isProject

integer success = 1
integer failure = -1

end variables

forward prototypes
public subroutine setavailabledw (string asdw)
public subroutine setselecteddw (string asdw)
public function long doavailableretrieve ()
public function long doselectedretrieve ()
public subroutine setproject (string asproject)
public function string getproject ()
public subroutine doadditem (long addrow)
public subroutine doremoveitem (long removerow)
public function boolean dovalidate ()
end prototypes

event ue_selectall();// ue_selectAll()

dw_available.selectrow( 0 , true )

end event

event ue_removeall();// ue_removeAll()

dw_selected.selectrow( 0 , true )
end event

event ue_removeitem();// ue_removeitem
long selectedrow

selectedrow = dw_selected.GetSelectedRow(0)
do while selectedrow > 0
	doremoveItem( selectedrow )
	selectedrow = dw_selected.GetSelectedRow( 0 )
loop	

end event

event ue_additem();// ue_addItem

long selectedrow

selectedrow = dw_available.GetSelectedRow(0)
do while selectedrow > 0
	doAddItem( selectedrow )
	selectedrow = dw_available.GetSelectedRow( 0 )
loop	

end event

public subroutine setavailabledw (string asdw);// setAvailableDW( string adw )

dw_available.dataobject = asdw
dw_available.settransobject( sqlca )

end subroutine

public subroutine setselecteddw (string asdw);// setSelectedDW( string adw )

dw_selected.dataobject = asdw
dw_selected.settransobject( sqlca )

end subroutine

public function long doavailableretrieve ();// long = doAvailableRetrieve()

return 0

end function

public function long doselectedretrieve ();// long = doSelectedRetrieve()
return 0

end function

public subroutine setproject (string asproject);// setProject( asProject )
isProject = asProject

end subroutine

public function string getproject ();// string = getProject()
return isProject

end function

public subroutine doadditem (long addrow);// doAddItem( long addRow )


end subroutine

public subroutine doremoveitem (long removerow);// doRemoveItem( long removeRow )

end subroutine

public function boolean dovalidate ();// boolean = dovalidate()

return true
end function

on u_select_available.create
this.cb_uo_available_remove_all=create cb_uo_available_remove_all
this.cb_uo_available_select_all=create cb_uo_available_select_all
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_selected=create dw_selected
this.dw_available=create dw_available
this.st_cb_uo_available_selected=create st_cb_uo_available_selected
this.st_uo_available_available=create st_uo_available_available
this.Control[]={this.cb_uo_available_remove_all,&
this.cb_uo_available_select_all,&
this.cb_2,&
this.cb_1,&
this.dw_selected,&
this.dw_available,&
this.st_cb_uo_available_selected,&
this.st_uo_available_available}
end on

on u_select_available.destroy
destroy(this.cb_uo_available_remove_all)
destroy(this.cb_uo_available_select_all)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_selected)
destroy(this.dw_available)
destroy(this.st_cb_uo_available_selected)
destroy(this.st_uo_available_available)
end on

type cb_uo_available_remove_all from commandbutton within u_select_available
integer x = 1079
integer y = 868
integer width = 389
integer height = 84
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove All"
end type

event clicked;parent.event ue_removeAll()
end event

event constructor;
g.of_check_label_button(this)
end event

type cb_uo_available_select_all from commandbutton within u_select_available
integer x = 1074
integer y = 332
integer width = 389
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;parent.event ue_selectAll()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_2 from commandbutton within u_select_available
integer x = 1079
integer y = 756
integer width = 389
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;parent.event ue_removeItem()
end event

type cb_1 from commandbutton within u_select_available
integer x = 1074
integer y = 220
integer width = 389
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;parent.event ue_AddItem()
end event

type dw_selected from datawindow within u_select_available
integer x = 1486
integer y = 72
integer width = 1056
integer height = 1176
integer taborder = 20
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row <=0 then return

if isSelected( row ) then
	selectrow( row, false )
else
	selectrow( row, true )
end if

end event

type dw_available from datawindow within u_select_available
integer y = 72
integer width = 1056
integer height = 1176
integer taborder = 10
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row <=0 then return

if isSelected( row ) then
	selectrow( row, false )
else
	selectrow( row, true )
end if

end event

type st_cb_uo_available_selected from statictext within u_select_available
integer x = 1486
integer width = 1056
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selected"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_uo_available_available from statictext within u_select_available
integer width = 1056
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Available"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

