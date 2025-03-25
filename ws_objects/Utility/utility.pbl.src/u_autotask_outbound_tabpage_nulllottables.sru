$PBExportHeader$u_autotask_outbound_tabpage_nulllottables.sru
forward
global type u_autotask_outbound_tabpage_nulllottables from u_tabpage
end type
type cb_1 from commandbutton within u_autotask_outbound_tabpage_nulllottables
end type
type sle_custinvoiceno from singlelineedit within u_autotask_outbound_tabpage_nulllottables
end type
type sle_sku from singlelineedit within u_autotask_outbound_tabpage_nulllottables
end type
type dw_nulllotno from u_dw within u_autotask_outbound_tabpage_nulllottables
end type
type sle_ronum from singlelineedit within u_autotask_outbound_tabpage_nulllottables
end type
type cb_reconfirm from commandbutton within u_autotask_outbound_tabpage_nulllottables
end type
end forward

global type u_autotask_outbound_tabpage_nulllottables from u_tabpage
integer width = 3867
integer height = 1996
string text = "Null Lottables"
string picturename = "EAServerProfile!"
cb_1 cb_1
sle_custinvoiceno sle_custinvoiceno
sle_sku sle_sku
dw_nulllotno dw_nulllotno
sle_ronum sle_ronum
cb_reconfirm cb_reconfirm
end type
global u_autotask_outbound_tabpage_nulllottables u_autotask_outbound_tabpage_nulllottables

forward prototypes
public function boolean f_impcustadd ()
end prototypes

public function boolean f_impcustadd ();datastore lds
string ls_pathname, ls_filename, ls_message
boolean lb_goodimport

// If we can get the CSV file to import.
If getfileopenname("Open Customer Address File", ls_pathname, ls_filename) > 0 then
	
	// Create the datastore.
	lds = Create datastore
	lds.dataobject = 'd_import_cust_address'
	lds.settransobject(sqlca)
	
	// Import the selected file.
	Choose Case lds.importfile(CSV!, ls_filename)
			
		Case -1  
			
			ls_message = "No rows or startrow value supplied is greater than the number of rows in the file"
			
		Case -2
			
			ls_message = "Empty file"
			
		Case -3
			
			ls_message = "Invalid argument"
			
		Case -4
			
			ls_message = "Invalid input"
			
		Case -5
			
			ls_message = "Could not open the file"
			
		Case -6
			
			ls_message = "Could not close the file"
			
		Case -7
			
			ls_message = "Error reading the text"
			
		Case -8
			
			ls_message = "Unsupported file name suffix (must be *.txt, *.csv, *.dbf or *.xml)"
			
		Case -10
			
			ls_message = "Unsupported dBase file format (not version 2 or 3)"
			
		Case -11
			
			ls_message = "XML Parsing Error; XML parser libraries not found or XML not well formed"
			
		Case -12
			
			ls_message = "XML Template does not exist or does not match the DataWindow"
			
		Case -13
			
			ls_message = "Unsupported DataWindow style for import"
			
		Case -14
			
			ls_message = "Error resolving DataWindow nesting"
			
		Case -15
			
			ls_message = "File size exceeds limit"
			
		Case is > 0
	
			// Update the database.
			lb_goodimport = lds.update() = 1
			ls_message = "Customer Addresses Imported Successfully."
			
		Case Else
			
			ls_message = "Unexpected return value for filegetopenname"
			
	End Choose 
	
	// Destroy the datastore.
	Destroy lds
	
// End if we can get the CSV file to import.
End If

// Show the message.
messagebox("Import Customer Address Data", ls_message)

// Return lb_goodimport
return lb_goodimport
end function

on u_autotask_outbound_tabpage_nulllottables.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_custinvoiceno=create sle_custinvoiceno
this.sle_sku=create sle_sku
this.dw_nulllotno=create dw_nulllotno
this.sle_ronum=create sle_ronum
this.cb_reconfirm=create cb_reconfirm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_custinvoiceno
this.Control[iCurrent+3]=this.sle_sku
this.Control[iCurrent+4]=this.dw_nulllotno
this.Control[iCurrent+5]=this.sle_ronum
this.Control[iCurrent+6]=this.cb_reconfirm
end on

on u_autotask_outbound_tabpage_nulllottables.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.sle_custinvoiceno)
destroy(this.sle_sku)
destroy(this.dw_nulllotno)
destroy(this.sle_ronum)
destroy(this.cb_reconfirm)
end on

type cb_1 from commandbutton within u_autotask_outbound_tabpage_nulllottables
integer x = 823
integer y = 16
integer width = 786
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get System Number"
end type

event clicked;string ls_rono

select do_no into :ls_rono from delivery_master where invoice_no = :sle_custinvoiceno.text;

sle_ronum.text = ls_rono
end event

type sle_custinvoiceno from singlelineedit within u_autotask_outbound_tabpage_nulllottables
integer x = 18
integer y = 16
integer width = 786
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Enter Order Number"
borderstyle borderstyle = stylelowered!
end type

type sle_sku from singlelineedit within u_autotask_outbound_tabpage_nulllottables
integer x = 18
integer y = 144
integer width = 786
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Enter SKU"
borderstyle borderstyle = stylelowered!
end type

type dw_nulllotno from u_dw within u_autotask_outbound_tabpage_nulllottables
integer x = 73
integer y = 464
integer width = 3639
integer height = 352
integer taborder = 30
end type

type sle_ronum from singlelineedit within u_autotask_outbound_tabpage_nulllottables
integer x = 18
integer y = 272
integer width = 786
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_reconfirm from commandbutton within u_autotask_outbound_tabpage_nulllottables
integer x = 823
integer y = 272
integer width = 786
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Check for NULL lottables"
end type

event clicked;
dw_nulllotno.setsqlselect("select * from content where project_id = 'pandora' and sku = '" + sle_sku.text + "'")
dw_nulllotno.settransobject(sqlca)
dw_nulllotno.retrieve()


//select ro_no from content where project_id = 'pandora' and sku = '07008618-r'

end event

