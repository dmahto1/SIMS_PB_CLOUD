$PBExportHeader$w_change_template.srw
forward
global type w_change_template from window
end type
type dw_template from datawindow within w_change_template
end type
type cb_cancel from commandbutton within w_change_template
end type
type cb_ok from commandbutton within w_change_template
end type
end forward

global type w_change_template from window
integer width = 1687
integer height = 644
boolean titlebar = true
string title = "Change Template"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79741120
dw_template dw_template
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_change_template w_change_template

type variables
m_simple_record curr_menu
Boolean record_changed
Boolean update_success
String win_title

string is_template
end variables

on w_change_template.create
this.dw_template=create dw_template
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.dw_template,&
this.cb_cancel,&
this.cb_ok}
end on

on w_change_template.destroy
destroy(this.dw_template)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;curr_menu = This.MenuId
win_title = This.Title
This.move(0,0)

datawindowchild ldw_child

dw_template.InsertRow(0)

dw_template.GetChild( "template_name", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve(gs_project)

string ls_str

ls_str = "TEMPLATE:" + gs_userid

is_template = ProfileString(gs_inifile,gs_project, ls_str,"")

if Not IsNull(is_template) and trim(is_template) <> '' then
	dw_template.SetItem( 1, "template_name", is_template )
end if






end event

type dw_template from datawindow within w_change_template
integer x = 69
integer y = 100
integer width = 1527
integer height = 168
integer taborder = 10
string title = "none"
string dataobject = "d_template_select"
boolean border = false
boolean livescroll = true
end type

type cb_cancel from commandbutton within w_change_template
integer x = 896
integer y = 332
integer width = 329
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

type cb_ok from commandbutton within w_change_template
integer x = 485
integer y = 332
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;
string ls_str, ls_template

ls_template =  dw_template.GetItemString(1,  "template_name")

if trim(is_template) <> trim(ls_template) then

	if IsNull(ls_template) OR trim(ls_template) = '' then
		
		MessageBox ("Error", "Must select template.")
		
		RETURN -1
		
	end if
	
	
	ls_str = "TEMPLATE:" + gs_userid
	SetProfileString(gs_inifile,gs_project, ls_str,ls_template)
	
	g.of_get_label()
		
end if

Close(Parent)

end event

