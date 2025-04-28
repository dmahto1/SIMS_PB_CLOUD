HA$PBExportHeader$w_smartcode_scan_supplier.srw
forward
global type w_smartcode_scan_supplier from w_response_ancestor
end type
type dw_1 from u_dw within w_smartcode_scan_supplier
end type
type st_1 from statictext within w_smartcode_scan_supplier
end type
type st_2 from statictext within w_smartcode_scan_supplier
end type
type sle_selectedsupplier from singlelineedit within w_smartcode_scan_supplier
end type
type gb_1 from groupbox within w_smartcode_scan_supplier
end type
end forward

global type w_smartcode_scan_supplier from w_response_ancestor
integer width = 1714
integer height = 1448
string title = "SmartCode Supplier Scan"
event ue_ok ( )
dw_1 dw_1
st_1 st_1
st_2 st_2
sle_selectedsupplier sle_selectedsupplier
gb_1 gb_1
end type
global w_smartcode_scan_supplier w_smartcode_scan_supplier

type variables
datastore idsPick

end variables

event ue_ok();// ue_ok()

string aSupplier
string findthis
long foundrow

// validate the entry
aSupplier = Upper( trim( sle_selectedSupplier.text ) )
findthis = "supplier = '" + aSupplier + "'"
foundrow = dw_1.find( findthis, 1, dw_1.rowcount() )
if foundrow <=0 then
	beep(1)
	messagebox( this.title,"Selected Supplier Invalid, Please Retry.",stopsign! )
	sle_selectedSupplier.text = ''
	return
end if
	
istrparms.string_arg[1] = aSupplier
closewithreturn( this, istrparms )




end event

on w_smartcode_scan_supplier.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.sle_selectedsupplier=create sle_selectedsupplier
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_selectedsupplier
this.Control[iCurrent+5]=this.gb_1
end on

on w_smartcode_scan_supplier.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_selectedsupplier)
destroy(this.gb_1)
end on

event open;call super::open;// w_smartcode_scan_supplier








end event

event ue_postopen;call super::ue_postopen;long index
long max
long insertRow
string supplier
string supplierbreak = "*"
decimal tQty = 0
decimal Qty
string supplierlist[]
decimal supplierqty[]
int cntr

idsPick = f_datastoreFactory('d_do_picking')

idsPick = message.PowerObjectParm

idsPick.setsort( "supp_code A" )
idsPick.sort()

string findthis
long foundrow

max = idsPick.rowcount()
for index = 1 to max
	supplier = idsPick.object.supp_code[ index ]
	Qty = idsPick.object.quantity[ index ]
	if supplier <> supplierbreak then
		cntr++
		supplierlist[ cntr ] = supplier
		supplierqty[ cntr ] = Qty 
		supplierbreak = supplier
	else
		supplierqty[ cntr ] += qty
	end if
next
max = UpperBound( supplierlist )
for index = 1 to max
		insertRow = dw_1.insertrow(0)
		dw_1.object.supplier[ insertRow ] = supplierlist[ index]
		dw_1.object.quantity[ insertRow ] = supplierqty[index]
next


end event

event ue_cancel;Istrparms.Cancelled = True
Closewithreturn(This, istrparms )
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_smartcode_scan_supplier
integer x = 1403
integer y = 1216
integer taborder = 40
end type

type cb_ok from w_response_ancestor`cb_ok within w_smartcode_scan_supplier
integer x = 14
integer y = 1220
integer taborder = 20
end type

event cb_ok::clicked;// why ue_close?

parent.event ue_ok()

end event

type dw_1 from u_dw within w_smartcode_scan_supplier
integer x = 9
integer y = 312
integer width = 928
integer height = 768
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_smartcode_scan_supplier_list"
boolean vscrollbar = true
end type

event clicked;call super::clicked;if row <=0 then return

this.setredraw( false )
this.selectrow( 0,false )
this.selectrow( row, true )
sle_selectedsupplier.text = dw_1.object.supplier[ row ]
this.setredraw( true )

end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.setredraw( false )
this.selectrow( 0,false )
this.selectrow( currentrow, true )
sle_selectedsupplier.text = dw_1.object.supplier[  currentrow  ]
this.setredraw( true )

end event

type st_1 from statictext within w_smartcode_scan_supplier
integer y = 8
integer width = 1454
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Multiple Suppliers Exist For the Scanned Sku..."
boolean focusrectangle = false
end type

type st_2 from statictext within w_smartcode_scan_supplier
integer x = 37
integer y = 204
integer width = 1637
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Click a Supplier From the list or Scan/Enter Your Choice"
boolean focusrectangle = false
end type

type sle_selectedsupplier from singlelineedit within w_smartcode_scan_supplier
integer x = 1042
integer y = 640
integer width = 521
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_smartcode_scan_supplier
integer x = 978
integer y = 540
integer width = 640
integer height = 280
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selected Supplier"
end type

