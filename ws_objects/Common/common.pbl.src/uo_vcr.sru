$PBExportHeader$uo_vcr.sru
forward
global type uo_vcr from userobject
end type
type cb_last from commandbutton within uo_vcr
end type
type cb_advance from commandbutton within uo_vcr
end type
type cb_retreat from commandbutton within uo_vcr
end type
type cb_first from commandbutton within uo_vcr
end type
end forward

global type uo_vcr from userobject
integer width = 590
integer height = 108
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_advance ( )
event ue_retreat ( )
event ue_tolast ( )
event ue_tofirst ( )
cb_last cb_last
cb_advance cb_advance
cb_retreat cb_retreat
cb_first cb_first
end type
global uo_vcr uo_vcr

type variables
str_parms istrParms
long ilFirst
long ilLast
long ilCurrent


end variables

forward prototypes
public subroutine setfirst (long avalue)
public subroutine setlast (long avalue)
public subroutine setcurrent (long avalue)
public function long getfirst ()
public function long getlast ()
public function long getcurrent ()
public subroutine setdisplay ()
end prototypes

event ue_advance();// ue_advance
long whereami

whereami = getCurrent()
whereami ++
setCurrent( whereami )
setdisplay()

parent.event dynamic ue_setvcrmoved( getCurrent() )

	

end event

event ue_retreat();// ue_retreat
long whereami

whereami = getCurrent()
whereami --
setCurrent( whereami )
setdisplay()

parent.event dynamic ue_setvcrmoved( getCurrent() )

	

end event

event ue_tolast();// ue_tolast

setCurrent( getLast() )
setDisplay()
parent.event dynamic ue_setvcrmoved( getCurrent() )

	


end event

event ue_tofirst();// ue_toFirst

setCurrent( getfirst() )
setDisplay()
parent.event dynamic ue_setvcrmoved( getCurrent() )
end event

public subroutine setfirst (long avalue);// setFirst( long avalue )
ilFirst = avalue

end subroutine

public subroutine setlast (long avalue);// setlast( long avalue )
illast = avalue

end subroutine

public subroutine setcurrent (long avalue);// setCurrent( long avalue )
ilCurrent = avalue

end subroutine

public function long getfirst ();// int = getFirst()
return ilFirst

end function

public function long getlast ();// int = getlast()
return ilLast

end function

public function long getcurrent ();// int = getCurrent()
return ilCurrent
end function

public subroutine setdisplay ();// setDisplay()

this.setredraw( false )


cb_first.enabled = true
cb_retreat.enabled = true
cb_last.enabled = true
cb_advance.enabled = true

if getLast() = 1 then
	cb_first.enabled = false
	cb_retreat.enabled = false
	cb_last.enabled = false
	cb_advance.enabled = false
	return
end if


if getCurrent() = getLast() then
	cb_last.enabled = false
	cb_advance.enabled = false
elseif getCurrent() = getFirst() then
	cb_first.enabled = false
	cb_retreat.enabled = false
end if

this.setredraw( true )
end subroutine

on uo_vcr.create
this.cb_last=create cb_last
this.cb_advance=create cb_advance
this.cb_retreat=create cb_retreat
this.cb_first=create cb_first
this.Control[]={this.cb_last,&
this.cb_advance,&
this.cb_retreat,&
this.cb_first}
end on

on uo_vcr.destroy
destroy(this.cb_last)
destroy(this.cb_advance)
destroy(this.cb_retreat)
destroy(this.cb_first)
end on

event constructor;istrParms = message.powerobjectparm

setFirst( istrParms.long_arg[ 1 ]  )
setLast( istrParms.long_arg[ 2 ]  )
setCurrent( istrParms.long_arg[ 3 ]  )
setDisplay()

end event

type cb_last from commandbutton within uo_vcr
integer x = 439
integer y = 8
integer width = 142
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;parent.event ue_tolast()

end event

type cb_advance from commandbutton within uo_vcr
integer x = 297
integer y = 8
integer width = 142
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;parent.event ue_advance()

end event

type cb_retreat from commandbutton within uo_vcr
integer x = 155
integer y = 8
integer width = 142
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;parent.event ue_retreat()

end event

type cb_first from commandbutton within uo_vcr
integer x = 14
integer y = 8
integer width = 142
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;parent.event ue_toFirst()

end event

