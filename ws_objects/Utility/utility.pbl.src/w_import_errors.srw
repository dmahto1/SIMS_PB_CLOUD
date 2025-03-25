$PBExportHeader$w_import_errors.srw
$PBExportComments$Show Import validation Errors
forward
global type w_import_errors from w_main_ancestor
end type
type dw_errors from datawindow within w_import_errors
end type
type cb_1 from commandbutton within w_import_errors
end type
end forward

global type w_import_errors from w_main_ancestor
integer height = 1368
string title = "Import Validation Errors"
string menuname = ""
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
dw_errors dw_errors
cb_1 cb_1
end type
global w_import_errors w_import_errors

on w_import_errors.create
int iCurrent
call super::create
this.dw_errors=create dw_errors
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_errors
this.Control[iCurrent+2]=this.cb_1
end on

on w_import_errors.destroy
call super::destroy
destroy(this.dw_errors)
destroy(this.cb_1)
end on

event open;call super::open;
istrparms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;
//parse out based on pipe and load to DW
Long	llNewRow, llPos
String	lsError, lsErrorText


lsError = Mid(istrparms.String_arg[1],2,9999999) /*strip off first | */

llPOs = Pos(lsError,'|')

Do While llPos > 0
	
	lsErrorText = Left(lsError,(llPos - 1))
	llnewRow = dw_errors.InsertRow(0)
	dw_errors.SetITem(llNewRow,'error_text',lsErrorText)
	lsError = Mid(lsError,llPos + 1,99999999)
	
	llPOs = Pos(lsError,'|')
	
Loop

llnewRow = dw_errors.InsertRow(0)
dw_errors.SetITem(llNewRow,'error_text',lsError)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_import_errors
boolean visible = false
integer x = 1253
integer y = 1120
end type

type cb_ok from w_main_ancestor`cb_ok within w_import_errors
integer x = 841
integer y = 1120
end type

type dw_errors from datawindow within w_import_errors
integer x = 23
integer y = 32
integer width = 2345
integer height = 1044
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_import_errors"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_import_errors
integer x = 1353
integer y = 1120
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;
OpenWithParm(w_dw_print_options,dw_errors) 
end event

