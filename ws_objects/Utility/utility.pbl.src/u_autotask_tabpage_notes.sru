$PBExportHeader$u_autotask_tabpage_notes.sru
forward
global type u_autotask_tabpage_notes from u_tabpage
end type
type shl_1 from statichyperlink within u_autotask_tabpage_notes
end type
type st_1 from statictext within u_autotask_tabpage_notes
end type
end forward

global type u_autotask_tabpage_notes from u_tabpage
integer width = 2482
integer height = 1088
string text = "Notes"
string picturename = "Copy!"
shl_1 shl_1
st_1 st_1
end type
global u_autotask_tabpage_notes u_autotask_tabpage_notes

on u_autotask_tabpage_notes.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
end on

on u_autotask_tabpage_notes.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
end on

type shl_1 from statichyperlink within u_autotask_tabpage_notes
integer x = 1097
integer y = 16
integer width = 891
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "\\mwtkl001\Sims-Updates\PND.  "
boolean focusrectangle = false
end type

type st_1 from statictext within u_autotask_tabpage_notes
integer x = 18
integer y = 16
integer width = 1056
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Good place to upload large files (builds)"
boolean focusrectangle = false
end type

