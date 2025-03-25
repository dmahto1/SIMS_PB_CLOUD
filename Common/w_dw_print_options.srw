HA$PBExportHeader$w_dw_print_options.srw
forward
global type w_dw_print_options from window
end type
type dw_saveas from datawindow within w_dw_print_options
end type
type ddlb_range from dropdownlistbox within w_dw_print_options
end type
type st_4 from statictext within w_dw_print_options
end type
type cb_printer from commandbutton within w_dw_print_options
end type
type cb_cancel from commandbutton within w_dw_print_options
end type
type cbx_collate from checkbox within w_dw_print_options
end type
type cbx_print_to_file from checkbox within w_dw_print_options
end type
type st_3 from statictext within w_dw_print_options
end type
type sle_page_range from singlelineedit within w_dw_print_options
end type
type rb_pages from radiobutton within w_dw_print_options
end type
type rb_current_page from radiobutton within w_dw_print_options
end type
type rb_all from radiobutton within w_dw_print_options
end type
type em_copies from editmask within w_dw_print_options
end type
type st_2 from statictext within w_dw_print_options
end type
type sle_printer from singlelineedit within w_dw_print_options
end type
type st_1 from statictext within w_dw_print_options
end type
type cb_ok from commandbutton within w_dw_print_options
end type
type gb_1 from groupbox within w_dw_print_options
end type
end forward

global type w_dw_print_options from window
integer x = 672
integer y = 268
integer width = 1856
integer height = 968
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
toolbaralignment toolbaralignment = alignatleft!
dw_saveas dw_saveas
ddlb_range ddlb_range
st_4 st_4
cb_printer cb_printer
cb_cancel cb_cancel
cbx_collate cbx_collate
cbx_print_to_file cbx_print_to_file
st_3 st_3
sle_page_range sle_page_range
rb_pages rb_pages
rb_current_page rb_current_page
rb_all rb_all
em_copies em_copies
st_2 st_2
sle_printer sle_printer
st_1 st_1
cb_ok cb_ok
gb_1 gb_1
end type
global w_dw_print_options w_dw_print_options

type variables
string is_page_range
datawindow idw_dw
datastore ids_dw
long il_ind
end variables

forward prototypes
private subroutine wf_page_range (radiobutton who)
public subroutine wf_select_dw ()
public subroutine wf_select_ds ()
end prototypes

private subroutine wf_page_range (radiobutton who);choose case who
	case rb_all
		sle_page_range.text = ''
		sle_page_range.enabled = false
		is_page_range = 'a'
	case rb_current_page
		sle_page_range.text = ''
		sle_page_range.enabled = false
		is_page_range = 'c'
	case rb_pages		
		sle_page_range.enabled = true
		is_page_range = 'p'
end choose
end subroutine

public subroutine wf_select_dw ();string tmp, command
long row 
string	docname, named
int	value


choose case lower(left(ddlb_range.text,1)) // determine rangeinclude (all,even,odd)
	case 'a' // all
		tmp = '0'
	case 'e' // even
		tmp = '1'
	case 'o' //odd
		tmp = '2'
end choose
command = 'datawindow.print.page.rangeinclude = '+tmp
if cbx_collate.checked then // collate output ?
	command = command +  " datawindow.print.collate = yes"
else
	command = command +  " datawindow.print.collate = no"
end if
choose case is_page_range // did they pick a page range?
	case 'a'  // all
		tmp = ''
	case 'c' // current page?
		row = idw_dw.getrow()
		tmp = idw_dw.describe("evaluate('page()',"+string(row)+")")
	case 'p' // a range?
		tmp = sle_page_range.text
end choose		
if len(tmp) > 0 then command = command +  " datawindow.print.page.range = '"+tmp+"'"

// number of copies ?

if len(em_copies.text) > 0 then command = command +  " datawindow.print.copies = "+em_copies.text

// now alter the datawindow

tmp = idw_dw.modify(command)
If len(tmp) > 0 Then // if error the display the 
	messagebox('Error Setting Print Options','Error message = ' + tmp + '~r~nCommand = ' + command)
	Return
End If
If cbx_print_to_file.checked Then // print to file ?
	idw_dw.SaveAs()
Else
	idw_dw.Print()
End If

CloseWithReturn(this,1)

end subroutine

public subroutine wf_select_ds ();string tmp, command
long row 
string	docname, named
int	value


choose case lower(left(ddlb_range.text,1)) // determine rangeinclude (all,even,odd)
	case 'a' // all
		tmp = '0'
	case 'e' // even
		tmp = '1'
	case 'o' //odd
		tmp = '2'
end choose
command = 'datawindow.print.page.rangeinclude = '+tmp
if cbx_collate.checked then // collate output ?
	command = command +  " datawindow.print.collate = yes"
else
	command = command +  " datawindow.print.collate = no"
end if
choose case is_page_range // did they pick a page range?
	case 'a'  // all
		tmp = ''
	case 'c' // current page?
		row = ids_dw.getrow()
		tmp = ids_dw.describe("evaluate('page()',"+string(row)+")")
	case 'p' // a range?
		tmp = sle_page_range.text
end choose		
if len(tmp) > 0 then command = command +  " datawindow.print.page.range = '"+tmp+"'"

// number of copies ?

if len(em_copies.text) > 0 then command = command +  " datawindow.print.copies = "+em_copies.text

// now alter the datawindow

tmp = ids_dw.modify(command)
If len(tmp) > 0 Then // if error the display the 
	messagebox('Error Setting Print Options','Error message = ' + tmp + '~r~nCommand = ' + command)
	Return
End If
If cbx_print_to_file.checked Then // print to file ?
	//MEA - 4/04/12
	//SaveAs was not working for a datastore.
	//Would return -1
	//Using this as a workaround
	
	
	dw_saveas.dataobject = ids_dw.dataobject
	ids_dw.RowsCopy( 1, ids_dw.RowCount(), Primary!, dw_saveas,1, Primary!)
	dw_saveas.SaveAs()
//	ids_dw.SaveAs()
Else
	ids_dw.Print()
End If

CloseWithReturn(this,1)

end subroutine

event open;//Modified by DGM 09/19/00
//Added code to handle both Datawindow & data store


Int	liCopies

CHOOSE CASE Message.PowerObjectParm.TypeOf()
	CASE DataWindow!
		idw_dw = message.powerobjectparm
		sle_printer.text = idw_dw.describe('datawindow.printer')
		liCopies = integer(idw_dw.describe('datawindow.print.Copies'))
		 il_ind = 1
   CASE DataStore!
		ids_dw = message.powerobjectparm
		sle_printer.text = ids_dw.describe('datawindow.printer')
		liCopies = integer(ids_dw.describe('datawindow.print.Copies'))
		il_ind = 2
END CHOOSE
is_page_range = 'a'

//01/07 - PCONKL - added code to change the default # of copies if dw Set to <> 1
if liCopies > 1 Then
	em_copies.text = String(liCopies)
End If
//		datawindow.print.copies 
end event

on w_dw_print_options.create
this.dw_saveas=create dw_saveas
this.ddlb_range=create ddlb_range
this.st_4=create st_4
this.cb_printer=create cb_printer
this.cb_cancel=create cb_cancel
this.cbx_collate=create cbx_collate
this.cbx_print_to_file=create cbx_print_to_file
this.st_3=create st_3
this.sle_page_range=create sle_page_range
this.rb_pages=create rb_pages
this.rb_current_page=create rb_current_page
this.rb_all=create rb_all
this.em_copies=create em_copies
this.st_2=create st_2
this.sle_printer=create sle_printer
this.st_1=create st_1
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.Control[]={this.dw_saveas,&
this.ddlb_range,&
this.st_4,&
this.cb_printer,&
this.cb_cancel,&
this.cbx_collate,&
this.cbx_print_to_file,&
this.st_3,&
this.sle_page_range,&
this.rb_pages,&
this.rb_current_page,&
this.rb_all,&
this.em_copies,&
this.st_2,&
this.sle_printer,&
this.st_1,&
this.cb_ok,&
this.gb_1}
end on

on w_dw_print_options.destroy
destroy(this.dw_saveas)
destroy(this.ddlb_range)
destroy(this.st_4)
destroy(this.cb_printer)
destroy(this.cb_cancel)
destroy(this.cbx_collate)
destroy(this.cbx_print_to_file)
destroy(this.st_3)
destroy(this.sle_page_range)
destroy(this.rb_pages)
destroy(this.rb_current_page)
destroy(this.rb_all)
destroy(this.em_copies)
destroy(this.st_2)
destroy(this.sle_printer)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

type dw_saveas from datawindow within w_dw_print_options
boolean visible = false
integer x = 1737
integer y = 992
integer width = 384
integer height = 224
integer taborder = 130
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type ddlb_range from dropdownlistbox within w_dw_print_options
integer x = 293
integer y = 712
integer width = 1065
integer height = 288
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 16777215
string text = "All Pages In Range"
boolean sorted = false
string item[] = {"All Pages in Range","Even Numbered Pages","Odd Numbered Pages"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_dw_print_options
integer x = 64
integer y = 724
integer width = 174
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "P&rint:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_printer from commandbutton within w_dw_print_options
integer x = 1445
integer y = 300
integer width = 338
integer height = 88
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Prin&ter..."
end type

event clicked;printsetup()
CHOOSE CASE il_ind
	CASE 1
		sle_printer.text = idw_dw.describe('datawindow.printer')
	Case 2
		sle_printer.text = ids_dw.describe('datawindow.printer')
END CHOOSE

 
end event

type cb_cancel from commandbutton within w_dw_print_options
integer x = 1445
integer y = 192
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

on clicked;closewithreturn(parent,-1)
end on

type cbx_collate from checkbox within w_dw_print_options
integer x = 1390
integer y = 576
integer width = 489
integer height = 68
integer taborder = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Collate Cop&ies"
boolean checked = true
end type

type cbx_print_to_file from checkbox within w_dw_print_options
integer x = 1390
integer y = 484
integer width = 434
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Print to Fi&le"
end type

type st_3 from statictext within w_dw_print_options
integer x = 105
integer y = 548
integer width = 1184
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Enter page numbers and/or page ranges separated by commas. For example, 2,5,8-10"
boolean focusrectangle = false
end type

type sle_page_range from singlelineedit within w_dw_print_options
integer x = 416
integer y = 448
integer width = 882
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;rb_pages.Checked = True
end event

type rb_pages from radiobutton within w_dw_print_options
integer x = 151
integer y = 452
integer width = 297
integer height = 68
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Pa&ges:"
end type

on clicked;wf_page_range(this)
end on

type rb_current_page from radiobutton within w_dw_print_options
integer x = 146
integer y = 384
integer width = 462
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Curr&ent Page"
end type

on clicked;wf_page_range(this)
end on

type rb_all from radiobutton within w_dw_print_options
integer x = 146
integer y = 316
integer width = 242
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "&All"
boolean checked = true
end type

on clicked;wf_page_range(this)
end on

type em_copies from editmask within w_dw_print_options
integer x = 306
integer y = 132
integer width = 242
integer height = 80
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

type st_2 from statictext within w_dw_print_options
integer x = 64
integer y = 140
integer width = 210
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Copies:"
boolean focusrectangle = false
end type

type sle_printer from singlelineedit within w_dw_print_options
integer x = 306
integer y = 48
integer width = 1083
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
boolean border = false
boolean autohscroll = false
end type

type st_1 from statictext within w_dw_print_options
integer x = 64
integer y = 52
integer width = 210
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
boolean enabled = false
string text = "Printer:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_dw_print_options
integer x = 1445
integer y = 80
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
CHOOSE CASE il_ind
	CASE 1
		wf_select_dw()
	Case 2
		wf_select_ds()
END CHOOSE


end event

type gb_1 from groupbox within w_dw_print_options
integer x = 55
integer y = 232
integer width = 1312
integer height = 444
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Page Range"
end type

