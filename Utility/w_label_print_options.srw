HA$PBExportHeader$w_label_print_options.srw
$PBExportComments$Options for Printing Labels
forward
global type w_label_print_options from window
end type
type dw_type from datawindow within w_label_print_options
end type
type st_label_format from statictext within w_label_print_options
end type
type st_4 from statictext within w_label_print_options
end type
type cb_printer from commandbutton within w_label_print_options
end type
type cb_cancel from commandbutton within w_label_print_options
end type
type em_copies from editmask within w_label_print_options
end type
type st_2 from statictext within w_label_print_options
end type
type sle_printer from singlelineedit within w_label_print_options
end type
type st_1 from statictext within w_label_print_options
end type
type cb_ok from commandbutton within w_label_print_options
end type
type gb_1 from groupbox within w_label_print_options
end type
end forward

global type w_label_print_options from window
integer x = 672
integer y = 268
integer width = 1710
integer height = 780
boolean titlebar = true
string title = "Print Labels"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
toolbaralignment toolbaralignment = alignatleft!
dw_type dw_type
st_label_format st_label_format
st_4 st_4
cb_printer cb_printer
cb_cancel cb_cancel
em_copies em_copies
st_2 st_2
sle_printer sle_printer
st_1 st_1
cb_ok cb_ok
gb_1 gb_1
end type
global w_label_print_options w_label_print_options

type variables
datastore ids_dw
str_parms	istrParms
long li_row, li_pos

end variables

event open;
Integer			li_ScreenH, li_ScreenW
Environment	le_Env

// Center window
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

This.Y = (li_ScreenH - This.Height) / 2
This.X = (li_ScreenW - This.Width) / 2

Istrparms = Message.PoweroBjectParm
IF UpperBound(Istrparms.String_arg) > 0 THEN 
	st_label_format.Text = Istrparms.String_arg[1]
END IF	
		

//May send a default # of copies in
If UpperBound(IstrParms.Long_arg) > 0 Then
	em_copies.Text = String(Istrparms.Long_arg[1])
End If

//Show current Printer
ids_dw = Create Datastore
ids_dw.dataobject = 'd_picking_prt'
sle_printer.text = ids_dw.describe('datawindow.printer')

//Show current Printer Type
dw_Type.SetTransObject(sqlca)
dw_Type.Retrieve(gs_project)
li_row = 1
if dw_type.rowcount() > 0 then 
	sle_printer.text = ids_dw.describe('datawindow.printer') + dw_type.getitemstring(li_row,"prt_code")
end if


		
end event

on w_label_print_options.create
this.dw_type=create dw_type
this.st_label_format=create st_label_format
this.st_4=create st_4
this.cb_printer=create cb_printer
this.cb_cancel=create cb_cancel
this.em_copies=create em_copies
this.st_2=create st_2
this.sle_printer=create sle_printer
this.st_1=create st_1
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.Control[]={this.dw_type,&
this.st_label_format,&
this.st_4,&
this.cb_printer,&
this.cb_cancel,&
this.em_copies,&
this.st_2,&
this.sle_printer,&
this.st_1,&
this.cb_ok,&
this.gb_1}
end on

on w_label_print_options.destroy
destroy(this.dw_type)
destroy(this.st_label_format)
destroy(this.st_4)
destroy(this.cb_printer)
destroy(this.cb_cancel)
destroy(this.em_copies)
destroy(this.st_2)
destroy(this.sle_printer)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

event closequery;
Istrparms.String_arg[1] = sle_printer.Text
Istrparms.Long_arg[1] = Long(em_copies.Text)

Message.PowerObjectParm = IstrParms
end event

type dw_type from datawindow within w_label_print_options
integer x = 731
integer y = 232
integer width = 887
integer height = 96
integer taborder = 20
string title = "none"
string dataobject = "d_printer_info"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;if not isnull(row) then 
	li_row = row
else
	li_row = dw_type.getrow()
end if

if dw_type.rowcount() > 0 then 
	sle_printer.text = ids_dw.describe('datawindow.printer') + dw_type.getitemstring(li_row,"prt_code")
else
	sle_printer.text = ids_dw.describe('datawindow.printer')
end if

end event

event scrollvertical;if scrollpos > li_pos then dw_type.scrollnextrow()
if scrollpos < li_pos then dw_type.scrollpriorrow()
li_pos = scrollpos
dw_type.triggerevent(itemchanged!)
end event

type st_label_format from statictext within w_label_print_options
integer x = 475
integer y = 56
integer width = 1125
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 78748035
string text = "none"
boolean focusrectangle = false
end type

type st_4 from statictext within w_label_print_options
integer x = 32
integer y = 56
integer width = 453
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 78748035
string text = "Label Format:"
boolean focusrectangle = false
end type

type cb_printer from commandbutton within w_label_print_options
integer x = 123
integer y = 248
integer width = 283
integer height = 88
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "C&hange..."
end type

event clicked;
printsetup()

if dw_type.rowcount() > 0 then 
	sle_printer.text = ids_dw.describe('datawindow.printer') + dw_type.getitemstring(li_row,"prt_code")
else
	sle_printer.text = ids_dw.describe('datawindow.printer')
end if


 
end event

type cb_cancel from commandbutton within w_label_print_options
integer x = 640
integer y = 572
integer width = 338
integer height = 88
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
IStrparms.Cancelled = True
Close(parent)
end event

type em_copies from editmask within w_label_print_options
integer x = 1367
integer y = 572
integer width = 242
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#####"
end type

type st_2 from statictext within w_label_print_options
integer x = 1125
integer y = 580
integer width = 210
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Copies:"
boolean focusrectangle = false
end type

type sle_printer from singlelineedit within w_label_print_options
integer x = 123
integer y = 380
integer width = 1490
integer height = 88
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
boolean border = false
boolean autohscroll = false
end type

type st_1 from statictext within w_label_print_options
integer x = 558
integer y = 244
integer width = 165
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Type:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_label_print_options
integer x = 178
integer y = 572
integer width = 338
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
boolean default = true
end type

event clicked;
Close(Parent)
end event

type gb_1 from groupbox within w_label_print_options
integer x = 32
integer y = 160
integer width = 1641
integer height = 372
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "PRINTER"
borderstyle borderstyle = stylelowered!
end type

