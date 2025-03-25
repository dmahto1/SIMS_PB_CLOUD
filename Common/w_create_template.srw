HA$PBExportHeader$w_create_template.srw
forward
global type w_create_template from window
end type
type sle_name from singlelineedit within w_create_template
end type
type st_2 from statictext within w_create_template
end type
type st_1 from statictext within w_create_template
end type
type dw_template from datawindow within w_create_template
end type
type cb_cancel from commandbutton within w_create_template
end type
type cb_ok from commandbutton within w_create_template
end type
end forward

global type w_create_template from window
integer width = 1975
integer height = 776
boolean titlebar = true
string title = "Create Template"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
boolean center = true
sle_name sle_name
st_2 st_2
st_1 st_1
dw_template dw_template
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_create_template w_create_template

type variables
m_simple_record curr_menu
Boolean record_changed
Boolean update_success
String win_title

string is_template
end variables

on w_create_template.create
this.sle_name=create sle_name
this.st_2=create st_2
this.st_1=create st_1
this.dw_template=create dw_template
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.sle_name,&
this.st_2,&
this.st_1,&
this.dw_template,&
this.cb_cancel,&
this.cb_ok}
end on

on w_create_template.destroy
destroy(this.sle_name)
destroy(this.st_2)
destroy(this.st_1)
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


sle_name.SetFocus()



end event

type sle_name from singlelineedit within w_create_template
integer x = 832
integer y = 72
integer width = 736
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_create_template
integer x = 1577
integer y = 312
integer width = 311
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to copy."
boolean focusrectangle = false
end type

type st_1 from statictext within w_create_template
integer x = 73
integer y = 96
integer width = 759
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Name for Template:"
boolean focusrectangle = false
end type

type dw_template from datawindow within w_create_template
integer x = 69
integer y = 300
integer width = 1527
integer height = 168
integer taborder = 20
string title = "none"
string dataobject = "d_template_select"
boolean border = false
boolean livescroll = true
end type

type cb_cancel from commandbutton within w_create_template
integer x = 1070
integer y = 504
integer width = 329
integer height = 108
integer taborder = 40
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

type cb_ok from commandbutton within w_create_template
integer x = 658
integer y = 504
integer width = 329
integer height = 108
integer taborder = 30
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
	
	
//	ls_str = "TEMPLATE:" + gs_userid
//	SetProfileString(gs_inifile,gs_project, ls_str,ls_template)
//	
	
//	g.of_get_label()
		
end if

string ls_name

ls_name = trim(upper(sle_name.text))

if IsNull(ls_name) or trim(ls_name) = '' then
	MessageBox ("Error", "Must enter a name")
	sle_name.SetFocus()
	RETURN -1
end if

if ls_name = 'BASELINE' then
	
	MessageBox ("Error", "Unable to use 'BASELINE' as name")
	RETURN -1
	
end if

integer li_count

SELECT Count(*) INTO :li_count From dbo.Column_Label
	WHERE template_name = :ls_name and project_id = :gs_project USING SQLCA;

IF li_count > 0 THEN
	MessageBox ("Error", "Name already exists for this project.")
	RETURN -1
END IF

datastore lds_template_from, lds_template_to

lds_template_from = create datastore
lds_template_to = create datastore

lds_template_from.dataobject = "d_column_labels"
lds_template_to.dataobject = "d_column_labels"

lds_template_from.SetTransObject(SQLCA)
lds_template_to.SetTransObject(SQLCA)

lds_template_from.Retrieve(gs_project, ls_template)

lds_template_from.RowsCopy(1,  lds_template_from.RowCount(), Primary!, lds_template_to, 1, Primary!)

integer li_idx

for li_idx = 1 to lds_template_to.RowCount()

	lds_template_to.SetItem( li_idx, "template_name", ls_name )
	lds_template_to.SetItem( li_idx, "template_ind", 'N' )
	

next


lds_template_to.Update()








Close(Parent)

end event

