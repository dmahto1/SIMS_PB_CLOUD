HA$PBExportHeader$w_physio_scan_or_generate.srw
forward
global type w_physio_scan_or_generate from w_response_ancestor
end type
type rb_generate from radiobutton within w_physio_scan_or_generate
end type
type rb_scan from radiobutton within w_physio_scan_or_generate
end type
type gb_1 from groupbox within w_physio_scan_or_generate
end type
end forward

global type w_physio_scan_or_generate from w_response_ancestor
integer width = 1262
integer height = 880
string title = "Scan Or Generate?"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event uf_setexitstatus ( boolean bstatus )
rb_generate rb_generate
rb_scan rb_scan
gb_1 gb_1
end type
global w_physio_scan_or_generate w_physio_scan_or_generate

type variables
str_pscan_resp user_choices
end variables

forward prototypes
public function integer uf_setexitstatus (boolean bstatus)
end prototypes

event uf_setexitstatus(boolean bstatus);user_choices.bok = bstatus
end event

public function integer uf_setexitstatus (boolean bstatus);user_choices.bok = bStatus
return 0
end function

on w_physio_scan_or_generate.create
int iCurrent
call super::create
this.rb_generate=create rb_generate
this.rb_scan=create rb_scan
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_generate
this.Control[iCurrent+2]=this.rb_scan
this.Control[iCurrent+3]=this.gb_1
end on

on w_physio_scan_or_generate.destroy
call super::destroy
destroy(this.rb_generate)
destroy(this.rb_scan)
destroy(this.gb_1)
end on

event open;call super::open;user_choices.action="scan"
user_choices.bok = false
end event

event close;call super::close;if IstrParms.cancelled = false then  //it's true by default in case they hit the x or <alt><space>close; they have to hit OK to get an OK hdc 10/05/2012
	user_choices.bok = true
end if
CloseWithReturn(this, user_choices)

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_physio_scan_or_generate
integer x = 686
integer y = 552
integer width = 265
end type

type cb_ok from w_response_ancestor`cb_ok within w_physio_scan_or_generate
integer x = 251
integer y = 552
integer width = 265
end type

type rb_generate from radiobutton within w_physio_scan_or_generate
integer x = 261
integer y = 264
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generate"
end type

event clicked;user_choices.action="generate"
end event

type rb_scan from radiobutton within w_physio_scan_or_generate
integer x = 256
integer y = 140
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scan"
boolean checked = true
end type

event clicked;user_choices.action="scan"
end event

type gb_1 from groupbox within w_physio_scan_or_generate
integer x = 206
integer y = 32
integer width = 777
integer height = 420
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Operation"
end type

