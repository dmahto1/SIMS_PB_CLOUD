HA$PBExportHeader$u_autotask_tabpage_customer.sru
forward
global type u_autotask_tabpage_customer from u_tabpage
end type
type cb_1 from commandbutton within u_autotask_tabpage_customer
end type
end forward

global type u_autotask_tabpage_customer from u_tabpage
integer width = 1047
integer height = 620
string text = "Customer"
string picturename = "UserObject5!"
cb_1 cb_1
end type
global u_autotask_tabpage_customer u_autotask_tabpage_customer

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

on u_autotask_tabpage_customer.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on u_autotask_tabpage_customer.destroy
call super::destroy
destroy(this.cb_1)
end on

type cb_1 from commandbutton within u_autotask_tabpage_customer
integer x = 91
integer y = 64
integer width = 795
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import Customer Addresses"
end type

event clicked;// Import the customer address data.
f_impcustadd()
end event

