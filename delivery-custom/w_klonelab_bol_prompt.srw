HA$PBExportHeader$w_klonelab_bol_prompt.srw
forward
global type w_klonelab_bol_prompt from window
end type
type cb_cancel from commandbutton within w_klonelab_bol_prompt
end type
type cb_ok from commandbutton within w_klonelab_bol_prompt
end type
type dw_klonelab_bol_data_entry from datawindow within w_klonelab_bol_prompt
end type
end forward

global type w_klonelab_bol_prompt from window
integer width = 2533
integer height = 872
boolean titlebar = true
string title = "KloneLab BOL"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
cb_ok cb_ok
dw_klonelab_bol_data_entry dw_klonelab_bol_data_entry
end type
global w_klonelab_bol_prompt w_klonelab_bol_prompt

on w_klonelab_bol_prompt.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_klonelab_bol_data_entry=create dw_klonelab_bol_data_entry
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.dw_klonelab_bol_data_entry}
end on

on w_klonelab_bol_prompt.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_klonelab_bol_data_entry)
end on

event open;

dw_klonelab_bol_data_entry.InsertRow(0)

dw_klonelab_bol_data_entry.SetFocus()
end event

type cb_cancel from commandbutton within w_klonelab_bol_prompt
integer x = 1463
integer y = 644
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(parent)
end event

type cb_ok from commandbutton within w_klonelab_bol_prompt
integer x = 686
integer y = 644
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;
 str_parms lstr_parms
 
lstr_parms.string_arg[1] = dw_klonelab_bol_data_entry.GetItemString( 1, "trailer_number")
lstr_parms.string_arg[2] =  dw_klonelab_bol_data_entry.GetItemString( 1, "seal_number")
lstr_parms.string_arg[3] =  dw_klonelab_bol_data_entry.GetItemString( 1, "trailer_loaded")
lstr_parms.string_arg[4] =  dw_klonelab_bol_data_entry.GetItemString( 1, "freight_counted")

CloseWithReturn(parent, lstr_parms)
end event

type dw_klonelab_bol_data_entry from datawindow within w_klonelab_bol_prompt
integer x = 91
integer y = 56
integer width = 2363
integer height = 452
integer taborder = 10
string title = "none"
string dataobject = "d_klonelab_bol_data_entry"
boolean border = false
boolean livescroll = true
end type

