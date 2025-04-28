$PBExportHeader$w_scan_message.srw
$PBExportComments$scanning error message dialog
forward
global type w_scan_message from w_response_ancestor
end type
type mle_message from multilineedit within w_scan_message
end type
end forward

global type w_scan_message from w_response_ancestor
integer width = 2048
integer height = 760
boolean controlmenu = false
mle_message mle_message
end type
global w_scan_message w_scan_message

on w_scan_message.create
int iCurrent
call super::create
this.mle_message=create mle_message
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_message
end on

on w_scan_message.destroy
call super::destroy
destroy(this.mle_message)
end on

event open;call super::open;IstrParms = message.powerobjectparm

if isNull( IstrParms ) then event post ue_close()
if isNull( IstrParms.string_arg ) then event post ue_close()
if UpperBound( istrParms.string_arg ) < 1 then
	event post ue_close()
else
	this.title = istrParms.string_arg[1]
	mle_message.text = "~r~n" + istrParms.string_arg[2] + "~r~n~r~nClick OK or Press The Spacebar to Continue"
	beep( 3 )
end if

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_scan_message
boolean visible = false
integer x = 50
integer y = 908
end type

type cb_ok from w_response_ancestor`cb_ok within w_scan_message
integer x = 832
integer y = 548
boolean default = false
end type

type mle_message from multilineedit within w_scan_message
integer x = 9
integer y = 12
integer width = 1979
integer height = 480
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
alignment alignment = center!
end type

