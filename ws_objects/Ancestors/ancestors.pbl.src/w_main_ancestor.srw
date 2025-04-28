$PBExportHeader$w_main_ancestor.srw
$PBExportComments$Ancestor window for Mainwindows
forward
global type w_main_ancestor from window
end type
type cb_cancel from commandbutton within w_main_ancestor
end type
type cb_ok from commandbutton within w_main_ancestor
end type
end forward

global type w_main_ancestor from window
integer x = 823
integer y = 360
integer width = 2455
integer height = 1424
boolean titlebar = true
string title = "Untitled"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
event ue_close ( )
event ue_cancel ( )
event ue_retrieve ( )
event ue_postopen ( )
event ue_help ( )
event ue_selectall ( )
event ue_unselectall ( )
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_main_ancestor w_main_ancestor

type variables
str_parms	IstrParms
String	isHelpKeyword
Long	ilHelpTopicID
end variables

event ue_close;
Close(This)
end event

event ue_cancel;
Istrparms.Cancelled = True
Close(This)
end event

event ue_help;Integer	liRC

//Help Topic ID is set in this event and passed to help file

//If you want to open by Topic ID, set the ilHelpTopicID to a valid Map #
// If you want to open by keyword, set the isHelpKeyord variable


If isHelpKeyword > ' ' Then
	lirc = ShowHelp(g.is_helpfile,Keyword!,isHelpKeyword) /*open by Keyword*/
ElseIf ilHelpTopicID > 0 Then
	lirc = ShowHelp(g.is_helpfile,topic!,ilHelpTopicID) /*open by topic ID*/
Else
	liRC = ShowHelp(g.is_HelpFile,Index!)
End If


end event

event open;
This.PostEvent("ue_postOpen")
end event

on w_main_ancestor.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.cb_cancel,&
this.cb_ok}
end on

on w_main_ancestor.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type cb_cancel from commandbutton within w_main_ancestor
integer x = 1381
integer y = 1128
integer width = 270
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;parent.TriggerEvent("ue_cancel")
end event

type cb_ok from commandbutton within w_main_ancestor
integer x = 946
integer y = 1128
integer width = 270
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;parent.TriggerEvent("ue_close")
end event

