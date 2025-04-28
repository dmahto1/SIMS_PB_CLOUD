$PBExportHeader$w_socputawaylist.srw
forward
global type w_socputawaylist from w_master
end type
type cb_putaway from commandbutton within w_socputawaylist
end type
type cb_pick from commandbutton within w_socputawaylist
end type
type cb_export from commandbutton within w_socputawaylist
end type
type cb_print from commandbutton within w_socputawaylist
end type
type dw_report from u_dw within w_socputawaylist
end type
end forward

global type w_socputawaylist from w_master
integer width = 4325
integer height = 1784
string title = "SOC Putaway List"
cb_putaway cb_putaway
cb_pick cb_pick
cb_export cb_export
cb_print cb_print
dw_report dw_report
end type
global w_socputawaylist w_socputawaylist

type variables
private datawindow idw_source
private string is_fromlocation
private string  is_lotno[]
private string is_serialno[]
string isorderno = ''
end variables

on w_socputawaylist.create
int iCurrent
call super::create
this.cb_putaway=create cb_putaway
this.cb_pick=create cb_pick
this.cb_export=create cb_export
this.cb_print=create cb_print
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_putaway
this.Control[iCurrent+2]=this.cb_pick
this.Control[iCurrent+3]=this.cb_export
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.dw_report
end on

on w_socputawaylist.destroy
call super::destroy
destroy(this.cb_putaway)
destroy(this.cb_pick)
destroy(this.cb_export)
destroy(this.cb_print)
destroy(this.dw_report)
end on

event open;call super::open;str_parms lstr_parms

// Capture the passed parameters.
lstr_parms = message.powerobjectparm

// Set the detail datawindow and source warehouse.
idw_source = lstr_parms.datawindow_arg[1]
is_fromlocation = lstr_parms.string_arg[1]
isorderno = lstr_parms.string_arg_2[1]   //ET3 2012-08-28

//is_serialno = lstr_parms.string_arg_2
//is_lotno =  lstr_parms.string_arg_3

//messagebox("", upperbound(is_serialno))
//messagebox("", upperbound(is_lotno))

end event

event ue_postopen;call super::ue_postopen;long ll_rownum, ll_numrows, ll_numcontentrows

// Get the number of content rows.
ll_numcontentrows = upperbound(is_lotno)

// Get the number of row.
ll_numrows = idw_source.rowcount()



// Loop through the rows,
For ll_rownum = 1 to ll_numrows
	
	// Insert a new row.
	dw_report.insertrow(0)
	
	// Set the report datawindow values.
	dw_report.setitem(ll_rownum, "warehouse", is_fromlocation) 
	dw_report.setitem(ll_rownum, "to_no", idw_source.getitemstring(ll_rownum, "to_no")) 		// line item number
	dw_report.setitem(ll_rownum, "lineitemnumber", idw_source.getitemnumber(ll_rownum, "user_line_item_no")) 		// line item number
	dw_report.setitem(ll_rownum, "sku", idw_source.getitemstring(ll_rownum, "sku")) 									// SKU
	dw_report.setitem(ll_rownum, "suppliercode", idw_source.getitemstring(ll_rownum, "supp_code")) 					// Supply Code
	dw_report.setitem(ll_rownum, "quantity", idw_source.getitemnumber(ll_rownum, "quantity")) 					// Quantity
	dw_report.setitem(ll_rownum, "inventorytype", idw_source.getitemstring(ll_rownum, "inventory_type")) 	// Inventory Type
	dw_report.setitem(ll_rownum, "old_owner", idw_source.getitemstring(ll_rownum, "c_owner_name")) 			// Old Owner
	dw_report.setitem(ll_rownum, "new_owner", idw_source.getitemstring(ll_rownum, "c_new_owner_name"))// New Owner
	dw_report.setitem(ll_rownum, "oldpo", idw_source.getitemstring(ll_rownum, "po_no")) 							// Old PO Number
	dw_report.setitem(ll_rownum, "newpo", idw_source.getitemstring(ll_rownum, "new_po_no")) 					// New PO Number
	dw_report.setitem(ll_rownum, "fromlocation", idw_source.getitemstring(ll_rownum, "s_location")) 				// From Location
	dw_report.setitem(ll_rownum, "tolocation", idw_source.getitemstring(ll_rownum, "d_location")) 				// To Location
	
	// LTK 20110110 Now setting the following variables via the detail dw	
	dw_report.setitem(ll_rownum, "lot", idw_source.getitemstring(ll_rownum, "lot_no")) 							// Lot No
	dw_report.setitem(ll_rownum, "serial_no", idw_source.getitemstring(ll_rownum, "serial_no")) 				// Serial No
	
	//ET3 2012-08-28 Add Order_no to header
	dw_report.setitem(1, 'order_no', isorderno )
	dw_report.setitem(ll_rownum, 'description', idw_source.getitemstring( ll_rownum, 'item_master_description') )
	dw_report.setitem(ll_rownum, 'container_id', idw_source.getitemstring( ll_rownum, 'container_id') )
	dw_report.setitem(ll_rownum, 'po_no2', idw_source.getitemstring( ll_rownum, 'po_no2') )
	
//	// If we have a corresponding content record,
//	If ll_numcontentrows >= ll_rownum then
//		
//		dw_report.setitem(ll_rownum, "lot", is_lotno[ll_rownum]) 				// Lot No
//		dw_report.setitem(ll_rownum, "serial_no", is_serialno[ll_rownum]) 				// Serial No
//	End IF

// Next Record
Next

dw_report.setRowFocusIndicator( hand! )


end event

event resize;call super::resize;dw_report.x = 10
dw_report.y = 144
dw_report.width = width - 58
dw_report.height = height - 150 - cb_print.height
end event

type cb_putaway from commandbutton within w_socputawaylist
integer x = 1403
integer y = 16
integer width = 581
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Put&away List"
end type

event clicked;//Jxlim 08/16/2011 sort To Location/SKU
String ls_dloc

//Change report header
dw_report.Modify("header_t.Text='Soc Putaway List'")

dw_report.SetRedraw(false)
dw_report.SetSort("tolocation A, Sku A, lineitemnumber A, ownerid A, lot A, serial_no A,oldpo A, newpo A")
dw_report.Sort()
dw_report.SetRedraw(true)

//dw_report.print()
//TimA 08/24/11 Show the print dialog box
Openwithparm(w_dw_print_options, dw_report) 


end event

type cb_pick from commandbutton within w_socputawaylist
integer x = 873
integer y = 16
integer width = 512
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print P&ick List"
end type

event clicked;//Jxlim 08/16/2011 sort From Location/Sku
String ls_sloc

//Change report header
dw_report.Modify("header_t.Text='Soc Pick List'")

dw_report.SetRedraw(false)
dw_report.SetSort("fromlocation A, Sku A, lineitemnumber A, ownerid A, lot A, serial_no A,oldpo A, newpo A")
dw_report.Sort()
dw_report.SetRedraw(true)

//dw_report.print()
//TimA 08/24/11 Show the print dialog box
Openwithparm(w_dw_print_options, dw_report) 

end event

type cb_export from commandbutton within w_socputawaylist
integer x = 453
integer y = 16
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Export"
end type

event clicked;dw_report.saveas()
end event

type cb_print from commandbutton within w_socputawaylist
integer x = 32
integer y = 16
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//dw_report.print()
//TimA 08/24/11 Show the print dialog box
Openwithparm(w_dw_print_options, dw_report) 
end event

type dw_report from u_dw within w_socputawaylist
integer x = 37
integer y = 144
integer width = 4229
integer height = 1376
boolean enabled = false
string dataobject = "d_socputawaylist"
boolean controlmenu = true
borderstyle borderstyle = styleraised!
end type

