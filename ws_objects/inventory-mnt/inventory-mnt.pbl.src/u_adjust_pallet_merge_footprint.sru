$PBExportHeader$u_adjust_pallet_merge_footprint.sru
forward
global type u_adjust_pallet_merge_footprint from userobject
end type
type st_6 from statictext within u_adjust_pallet_merge_footprint
end type
type sle_carton_qty from singlelineedit within u_adjust_pallet_merge_footprint
end type
type sle_serial_scanned from singlelineedit within u_adjust_pallet_merge_footprint
end type
type st_5 from statictext within u_adjust_pallet_merge_footprint
end type
type st_4 from statictext within u_adjust_pallet_merge_footprint
end type
type dw_scanned_cartons from datawindow within u_adjust_pallet_merge_footprint
end type
type cb_print from commandbutton within u_adjust_pallet_merge_footprint
end type
type sle_carton_scanned from singlelineedit within u_adjust_pallet_merge_footprint
end type
type st_3 from statictext within u_adjust_pallet_merge_footprint
end type
type sle_to_carton_count from singlelineedit within u_adjust_pallet_merge_footprint
end type
type st_1 from statictext within u_adjust_pallet_merge_footprint
end type
type lb_carton_list from listbox within u_adjust_pallet_merge_footprint
end type
type sf_sscc from statictext within u_adjust_pallet_merge_footprint
end type
type sle_to from singlelineedit within u_adjust_pallet_merge_footprint
end type
type cb_cancel from commandbutton within u_adjust_pallet_merge_footprint
end type
type cb_do_it from commandbutton within u_adjust_pallet_merge_footprint
end type
type sle_from from singlelineedit within u_adjust_pallet_merge_footprint
end type
type st_sscc from statictext within u_adjust_pallet_merge_footprint
end type
type st_section_title from statictext within u_adjust_pallet_merge_footprint
end type
type st_2 from statictext within u_adjust_pallet_merge_footprint
end type
type gb_2 from groupbox within u_adjust_pallet_merge_footprint
end type
type gb_1 from groupbox within u_adjust_pallet_merge_footprint
end type
end forward

global type u_adjust_pallet_merge_footprint from userobject
integer width = 4475
integer height = 1996
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_post_open ( )
event type long ue_print_labels ( )
st_6 st_6
sle_carton_qty sle_carton_qty
sle_serial_scanned sle_serial_scanned
st_5 st_5
st_4 st_4
dw_scanned_cartons dw_scanned_cartons
cb_print cb_print
sle_carton_scanned sle_carton_scanned
st_3 st_3
sle_to_carton_count sle_to_carton_count
st_1 st_1
lb_carton_list lb_carton_list
sf_sscc sf_sscc
sle_to sle_to
cb_cancel cb_cancel
cb_do_it cb_do_it
sle_from sle_from
st_sscc st_sscc
st_section_title st_section_title
st_2 st_2
gb_2 gb_2
gb_1 gb_1
end type
global u_adjust_pallet_merge_footprint u_adjust_pallet_merge_footprint

type variables
w_adjust_pallet iw_parent
boolean ib_Print //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode

String IsContainerType, IsPalletType, isToPallet, isToCarton, is_print_cartons[], is_print_pallets[]
Datawindow idw_scanned_cartons
end variables

forward prototypes
public function boolean of_serial_list_contains (string as_serial_id)
public function boolean of_carton_list_contains (string as_pallet_id, string as_carton_id)
public subroutine of_add_serial_count_to_carton (string as_pallet_id, string as_carton_id, long as_carton_count)
public function string of_build_carton_in_string (string as_print_cartons[])
public function long uf_print_pallet ()
public function long uf_print_carton ()
public subroutine of_add_carton (string as_pallet_id, string as_carton_id, long as_carton_count)
public subroutine of_add_serial (string as_pallet_id, string as_carton_id)
end prototypes

event ue_post_open();sle_to.SetFocus()

//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - START
ib_Print =FALSE

IF upper(gs_project) ='PANDORA' Then
	cb_print.visible =TRUE
else
	cb_print.visible =FALSE
End IF
//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - END

idw_scanned_cartons = this.dw_scanned_cartons


end event

event type long ue_print_labels();long llRC

//Print the Pallet Label(s)
If IsContainerType = 'P' then
	llrc = uf_print_pallet()
Else //Print Carton
	llrc = uf_print_carton()
End IF

return llrc


end event

public function boolean of_serial_list_contains (string as_serial_id);String ls_serial
long j
for j = 1 to lb_carton_list.TotalItems()
	ls_serial = Upper(Trim(lb_carton_list.Text(j)))
	if Upper(Trim(as_serial_id)) = ls_serial then
		return true
	end if
next
return false

end function

public function boolean of_carton_list_contains (string as_pallet_id, string as_carton_id);String ls_find
long ll_row, llcount
 
llcount = idw_scanned_cartons.RowCount()

ls_find = "po_no2 = '" + as_pallet_id + "' and carton_id = '" + as_carton_id + "'"
ll_row = idw_scanned_cartons.Find(ls_find, 1, llcount)

if ll_row > 0 then
	return true
else
	return false
end if

end function

public subroutine of_add_serial_count_to_carton (string as_pallet_id, string as_carton_id, long as_carton_count);long ll_row,  llScanCount

llScanCount = Long(this.sle_carton_scanned.text)
iw_parent.in_parms.of_add_footprint_carton(as_pallet_id, as_carton_id, as_carton_count )	// add to the list of content records to reconcile to the parms

//add scanned carton to the screen
ll_row = idw_scanned_cartons.InsertRow(0)
idw_scanned_cartons.Object.po_no2[ll_row] = as_pallet_id
idw_scanned_cartons.Object.carton_id[ll_row] = as_carton_id
idw_scanned_cartons.Object.qty[ll_row] = long(as_carton_count)
								
llScanCount = llScanCount + 1
this.sle_Carton_scanned.text = String(llScanCount)
This.setfocus( )
iw_parent.SetMicroHelp("Scanned ID: " + this.text)
								
//ToDo -Load the list of serial numbers to Move


end subroutine

public function string of_build_carton_in_string (string as_print_cartons[]);String ls_values
integer llArrayCount

llArrayCount = UpperBound(is_print_cartons[])

if llArrayCount < 1 then
	return "(null)"
end if

long i
for i = 1 to llArrayCount
	
	if i = 1 then
		ls_values = "'" + is_print_cartons[i] + "'"
	else
		ls_values += ", '" + is_print_cartons[i] + "'"	
	end if
next

return "(" + ls_values + ")"

end function

public function long uf_print_pallet ();//Print Part Label for New Container Id

String 	ls_To_PalletId, ls_sku, ls_wh, ls_sql, ls_errors, ls_sscc, ls_serial_string_data, ls_carton_string_data
long 		ll_row
str_parms lstr_serialList

Datastore lds_serial

n_labels_pandora lu_pandora_labels
n_adjust_pallet_parms lu_pallet_parm

lu_pandora_labels =create n_labels_pandora
lu_pallet_parm = create n_adjust_pallet_parms

ls_sku = iw_parent.in_parms.is_sku
ls_wh =iw_parent.in_parms.is_warehouse

lds_serial = create Datastore

//Print the Pallet Label(s)
ls_To_PalletId = isToPallet

//get Serial No Records from the Cartons and Serials scanned in
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"'"
ls_sql +=" and wh_code ='"+ls_wh+"' and po_no2 ='"+ls_To_PalletId+"'"
lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))		
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
	MessageBox("Footprint Merge", "Unable to retrieve Serial Number Inventory records against Pallet Id "+ls_To_PalletId)	
	Return -1
End IF

For ll_row =1 to lds_serial.rowcount( )
	lstr_serialList.string_arg[ll_row]   =lds_serial.getItemString( ll_row, 'serial_no')
Next

//Build list of From Container Id Serial No's
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"'"
ls_sql +=" and wh_code ='"+ls_wh+"'"

ls_carton_string_data = of_build_carton_in_string(is_print_cartons[])

ls_serial_string_data = lu_pallet_parm.of_set_serial_in_string_merge( lb_carton_list)

//If IsNull(ls_carton_string_data) and IsNull(ls_serial_string_data) then
//	MessageBox("Footprint Merge", "Unable to retrieve Serial Number Inventory records against Carton Id - From Serial Numbers could not be loaded")
//	Return -1
//	
//ElseIf Not IsNull(ls_carton_string_data) and Not IsNull(ls_serial_string_data) then
	ls_sql += " and (Carton_Id  IN "+ ls_Carton_string_data +" or Serial_No  IN "+ ls_serial_string_data +")"
	
//ElseIf Not IsNull(ls_carton_string_data) then
//	ls_sql += " and Carton_Id  IN "+ ls_Carton_string_data +""
//
//ElseIf Not IsNull(ls_serial_string_data) then
//	ls_sql += " and Serial_Id  IN "+ ls_serial_string_data +""
//End If

lds_serial.setsqlselect( ls_sql)
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
	MessageBox("Footprint Merge", "Unable to retrieve Serial Number Inventory records against Carton Id "+ls_serial_string_data)
	Return -1
End IF

For ll_row =1 to lds_serial.rowcount( )
	lstr_serialList.string_arg[UpperBound(lstr_serialList.string_arg) + 1]   =lds_serial.getItemString( ll_row, 'serial_no')
Next

//Print 2D Barcode Label
lu_pandora_labels.uf_print_2d_barcode_label( lstr_serialList, ls_sku, ls_wh, ls_To_PalletId , 'PALLET LABEL')

ib_Print =TRUE

destroy lds_serial
destroy lu_pandora_labels

Return -1


end function

public function long uf_print_carton ();//Print Part Label for New Container Id

String 	ls_To_containerId, ls_sku, ls_wh, ls_sql, ls_errors, ls_sscc, ls_serial_string_data, ls_carton_string_data
long 		ll_row
str_parms lstr_serialList

Datastore lds_serial

n_labels_pandora lu_pandora_labels
n_adjust_pallet_parms lu_pallet_parm

lu_pandora_labels =create n_labels_pandora
lu_pallet_parm = create n_adjust_pallet_parms

ls_sku = iw_parent.in_parms.is_sku
ls_wh =iw_parent.in_parms.is_warehouse

lds_serial = create Datastore

//Print the Pallet Label(s)
ls_To_containerId = isToCarton

//get Serial No Records from the Cartons and Serials scanned in
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"'"
ls_sql +=" and wh_code ='"+ls_wh+"' and carton_id ='"+ls_To_containerId+"'"
lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))		
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )


IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
	MessageBox("Footprint Merge", "Unable to retrieve Serial Number Inventory records against Carton Id "+ls_To_containerId)	
	Return -1
End IF

For ll_row =1 to lds_serial.rowcount( )
	lstr_serialList.string_arg[ll_row]   =lds_serial.getItemString( ll_row, 'serial_no')
Next

//Build list of From Container Id Serial No's
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"'"
ls_sql +=" and wh_code ='"+ls_wh+"'"

ls_carton_string_data = of_build_carton_in_string(is_print_cartons[])

ls_serial_string_data = lu_pallet_parm.of_set_serial_in_string_merge( lb_carton_list)

ls_sql += " and (Carton_Id  IN "+ ls_Carton_string_data +" or Serial_No  IN "+ ls_serial_string_data +")"
	

lds_serial.setsqlselect( ls_sql)
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
	MessageBox("Footprint Merge", "Unable to retrieve Serial Number Inventory records against Carton Id "+ls_serial_string_data)
	Return -1
End IF

For ll_row =1 to lds_serial.rowcount( )
	lstr_serialList.string_arg[UpperBound(lstr_serialList.string_arg) + 1]   =lds_serial.getItemString( ll_row, 'serial_no')
Next

//Print 2D Barcode Label
lu_pandora_labels.uf_print_2d_barcode_label( lstr_serialList, ls_sku, ls_wh, ls_To_containerId , 'CARTON LABEL')

ib_Print =TRUE

destroy lds_serial
destroy lu_pandora_labels

Return -1


end function

public subroutine of_add_carton (string as_pallet_id, string as_carton_id, long as_carton_count);long ll_row

iw_parent.in_parms.of_add_footprint_carton(as_pallet_id, as_carton_id, as_carton_count )	// add to the list of content records to reconcile to the parms

//add scanned carton to the screen
ll_row = idw_scanned_cartons.InsertRow(0)
idw_scanned_cartons.Object.po_no2[ll_row] = as_pallet_id
idw_scanned_cartons.Object.carton_id[ll_row] = as_carton_id
idw_scanned_cartons.Object.qty[ll_row] = long(as_carton_count)
								
This.setfocus( )
iw_parent.SetMicroHelp("Scanned ID: " + this.text)
								


end subroutine

public subroutine of_add_serial (string as_pallet_id, string as_carton_id);long ll_row,  llScanCount

llScanCount = Long(this.sle_carton_scanned.text)

ll_row = idw_scanned_cartons.Find("po_no2 = '" + as_pallet_id + "' and carton_id = '" + as_carton_id + "'", 1, idw_scanned_cartons.RowCount())

iw_parent.in_parms.of_add_footprint_serial(as_pallet_id, as_carton_id)

if ll_row > 0 then //increment carton quantity
	idw_scanned_cartons.Object.qty[ll_row] = idw_scanned_cartons.Object.qty[ll_row] + 1
else	//add scanned carton to the screen
	ll_row = idw_scanned_cartons.InsertRow(0)
	this.sle_carton_scanned.text = string(ll_row)
	idw_scanned_cartons.Object.po_no2[ll_row] = as_pallet_id
	idw_scanned_cartons.Object.carton_id[ll_row] = as_carton_id
	idw_scanned_cartons.Object.qty[ll_row] = 1
end if

end subroutine

on u_adjust_pallet_merge_footprint.create
this.st_6=create st_6
this.sle_carton_qty=create sle_carton_qty
this.sle_serial_scanned=create sle_serial_scanned
this.st_5=create st_5
this.st_4=create st_4
this.dw_scanned_cartons=create dw_scanned_cartons
this.cb_print=create cb_print
this.sle_carton_scanned=create sle_carton_scanned
this.st_3=create st_3
this.sle_to_carton_count=create sle_to_carton_count
this.st_1=create st_1
this.lb_carton_list=create lb_carton_list
this.sf_sscc=create sf_sscc
this.sle_to=create sle_to
this.cb_cancel=create cb_cancel
this.cb_do_it=create cb_do_it
this.sle_from=create sle_from
this.st_sscc=create st_sscc
this.st_section_title=create st_section_title
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.st_6,&
this.sle_carton_qty,&
this.sle_serial_scanned,&
this.st_5,&
this.st_4,&
this.dw_scanned_cartons,&
this.cb_print,&
this.sle_carton_scanned,&
this.st_3,&
this.sle_to_carton_count,&
this.st_1,&
this.lb_carton_list,&
this.sf_sscc,&
this.sle_to,&
this.cb_cancel,&
this.cb_do_it,&
this.sle_from,&
this.st_sscc,&
this.st_section_title,&
this.st_2,&
this.gb_2,&
this.gb_1}
end on

on u_adjust_pallet_merge_footprint.destroy
destroy(this.st_6)
destroy(this.sle_carton_qty)
destroy(this.sle_serial_scanned)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.dw_scanned_cartons)
destroy(this.cb_print)
destroy(this.sle_carton_scanned)
destroy(this.st_3)
destroy(this.sle_to_carton_count)
destroy(this.st_1)
destroy(this.lb_carton_list)
destroy(this.sf_sscc)
destroy(this.sle_to)
destroy(this.cb_cancel)
destroy(this.cb_do_it)
destroy(this.sle_from)
destroy(this.st_sscc)
destroy(this.st_section_title)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event constructor;iw_parent = message.PowerObjectParm	
iw_parent.title = "Pallet Adjust"
this.PostEvent("ue_post_open")
end event

type st_6 from statictext within u_adjust_pallet_merge_footprint
integer x = 1211
integer y = 1708
integer width = 585
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Carton Scan Qty:"
boolean focusrectangle = false
end type

type sle_carton_qty from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 1819
integer y = 1708
integer width = 274
integer height = 64
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean border = false
end type

type sle_serial_scanned from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 2871
integer y = 1708
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean border = false
end type

type st_5 from statictext within u_adjust_pallet_merge_footprint
integer x = 2272
integer y = 1708
integer width = 585
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Serial Scan Count:"
boolean focusrectangle = false
end type

type st_4 from statictext within u_adjust_pallet_merge_footprint
integer x = 2245
integer y = 640
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Scanned Serials"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type dw_scanned_cartons from datawindow within u_adjust_pallet_merge_footprint
integer x = 288
integer y = 732
integer width = 1829
integer height = 944
string title = "none"
string dataobject = "d_pallet_carton_move_list"
boolean vscrollbar = true
boolean livescroll = true
end type

type cb_print from commandbutton within u_adjust_pallet_merge_footprint
integer x = 1975
integer y = 1804
integer width = 512
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print &2D &Label"
end type

event clicked;//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
//Print Part Label for New Container Id
Parent.event ue_print_labels( )

end event

type sle_carton_scanned from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 901
integer y = 1708
integer width = 274
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean border = false
end type

type st_3 from statictext within u_adjust_pallet_merge_footprint
integer x = 302
integer y = 1708
integer width = 585
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Carton Scan Count:"
boolean focusrectangle = false
end type

type sle_to_carton_count from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 1915
integer y = 276
integer width = 210
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " 0"
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
integer limit = 20
boolean displayonly = true
end type

event getfocus;If This.text <> '' then
	This.SelectText(1, Len(Trim(This.Text)))
end If
end event

type st_1 from statictext within u_adjust_pallet_merge_footprint
integer x = 1298
integer y = 280
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Carton Count"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type lb_carton_list from listbox within u_adjust_pallet_merge_footprint
integer x = 2272
integer y = 728
integer width = 777
integer height = 944
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type sf_sscc from statictext within u_adjust_pallet_merge_footprint
integer x = 64
integer y = 432
integer width = 453
integer height = 180
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "SSCC ID / Carton/  Serial:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_to from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 553
integer y = 268
integer width = 695
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.SelectText(1, Len(this.text))

end event

event modified;String lsFromScannedValue, lsWarehouse, lsNull[] 

long ll_carton_count, ll_row_count

this.text = Trim(this.text)
lsFromScannedValue = this.text

if Len(lsFromScannedValue) > 0 then
	idw_scanned_cartons.Reset()
	lb_carton_list.Reset()
	iw_parent.in_parms.ids_pallet_carton_list.reset( )
	is_print_cartons[] = lsNull[]
	is_print_pallets[] = lsNull[]
	
	lsWarehouse = iw_parent.in_parms.is_warehouse

//Determine if Pallet or Carton is scanned
	//First Check Pallet(PoNo2)

	SELECT count(*), Max(PO_No2), Max(Container_id)
	INTO :ll_row_count, :isToPallet, :isToCarton
	FROM Content  
	WHERE ( Project_Id = :gs_Project ) AND (PO_No2 = :lsFromScannedValue ) AND (WH_Code = :lsWarehouse )  ;

	if ll_row_count > 0 then //Pallet Found

		isContainerType = 'P' // Container is Pallet
		//Check if Pallet contains Cartons or Loose Serial Number'
		If isToCarton = '-' or UPPER(isToCarton) = 'DUMMY' or UPPER(isToCarton) = 'NA' Then //Pallet type is Loose Serial Numbers
			isPalletType = 'S' 
			select count(*), max(po_no2)
			into :ll_row_count, :isToPallet
			from serial_number_inventory with (NOLOCK)
			where project_id = :gs_project
			and sku = :iw_parent.in_parms.is_sku
			and po_no2 = :this.text;

			if ll_row_count > 0 then 
			// Set Screen to scan pallets cartons or Serial Numbers
				st_section_title.text = 'Merge Cartons and Serials to a Pallet'
				gb_2.text = 'Target Container is a Pallet with loose Serial numbers' 
				st_sscc.text = 'Pallet ID:'
				st_1.text = 'Serial Count:'
				sle_to_carton_count.text = String(ll_row_count)
				sf_sscc.text = 'Pallet/ Carton or Serial:'

			elseif ll_row_count = 0 then
				MessageBox(iw_parent.title, "No inventory found for the following parameters: ~r~r" + iw_parent.in_parms.of_get_parms_display())
				SetFocus(sle_to)
			else
				MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
				SetFocus(sle_to)
			end If
		Else  //Pallet type is Cartons
			isPalletType = 'C'
			// Set Screen to scan Pallets or Cartons
			st_section_title.text = 'Merge Pallets and Cartons to a Pallet'
			gb_2.text = 'Target Container is a Pallet with Cartons' 
			st_sscc.text = 'Pallet ID:'
			st_1.text = 'Serial Count:'
			sle_to_carton_count.text = String(ll_row_count)
			sf_sscc.text = 'Pallet or Carton:'
		End If
	
	//Not Pallet then check if Carton
	elseif ll_row_count = 0 then
		select count(*), max(po_no2),  Max(Carton_id)
		into :ll_row_count, :isToPallet, :isToCarton
		from serial_number_inventory with (NOLOCK)
		where project_id = :gs_project
		and sku = :iw_parent.in_parms.is_sku
		and carton_id = :this.text;

		if ll_row_count > 0 then
			isPalletType = '' //Pallet type blank
			isContainerType = 'C' // Container is Carton
			// Set Screen to scan cartons or Serial Numbers
			st_section_title.text = 'Merge Cartons or Serials to a Carton'
			gb_2.text = 'Target Container is a Carton' 
			st_sscc.text = 'Carton ID:'
			st_1.text = 'Serial Count:'
			sle_to_carton_count.text = String(ll_row_count)
			sf_sscc.text = 'Carton/Serial:'
		elseif ll_row_count = 0 then
			MessageBox(iw_parent.title, "No inventory found for the following parameters: ~r~r" + iw_parent.in_parms.of_get_parms_display())
			SetFocus(sle_to)
		else
			MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
			SetFocus(sle_to)
		end if
	else
		MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
		SetFocus(sle_to)
	end if

end if




end event

type cb_cancel from commandbutton within u_adjust_pallet_merge_footprint
integer x = 1472
integer y = 1804
integer width = 462
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;iw_parent.in_parms.ib_cancelled = true
iw_parent.in_parms.of_set_status()
iw_parent.TriggerEvent("ue_closing")

end event

event constructor;g.of_check_label_button(this)
end event

type cb_do_it from commandbutton within u_adjust_pallet_merge_footprint
integer x = 969
integer y = 1804
integer width = 462
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
If upper(gs_project) ='PANDORA' and ib_Print =FALSE Then
	If MessageBox("Print 2D Barcode Labels"," 2D Barcode Labels are NOT printed, Would you like to print Labels? ", question!, YESNO!) = 1 Then
		Parent.event ue_print_labels( )
	End If
End If

if Len(Trim(sle_to.text)) > 0 and (iw_parent.in_parms.ids_pallet_carton_list.rowcount( ) > 0 or lb_carton_list.TotalItems() > 0) then 	

	if MessageBox(iw_parent.title, "Are you sure you want to merge pallet: " + Trim(sle_to.text) + "?",question!, yesno!) = 1 then
	
		String ls_carton, ls_pallet
		
		// Both the selected group of cartons will receive a Target SSCC# 

		datastore lds_modified_rows
		lds_modified_rows = Create datastore
		lds_modified_rows.Dataobject = 'd_pallet_carton_move_list'
		lds_modified_rows.SetTransObject(sqlca)
		lds_modified_rows.Reset()

		// Next, set the SSCC# for the selected cartons to the Target SSCC#
		int j

long llcount
llcount = iw_parent.in_parms.ids_pallet_carton_list.rowcount( )
		for j = 1 to iw_parent.in_parms.ids_pallet_carton_list.rowcount( )
			
			if j = 1 then
				iw_parent.in_parms.ib_some_cartons_broken = true		
			end if
		
			ls_carton = dw_scanned_cartons.getItemString(j,'Carton_Id')
			ls_pallet = dw_scanned_cartons.getItemString(j,'Po_No2')

			long ll_row_found
			ll_row_found = iw_parent.in_parms.ids_pallet_carton_list.Find("po_no2 = '" + ls_pallet + "' and carton_id = '" + ls_carton + "'", 1, iw_parent.in_parms.ids_pallet_carton_list.RowCount())
			if ll_row_found > 0 then
				int li_ret2
				li_ret2 = iw_parent.in_parms.ids_pallet_carton_list.RowsCopy(ll_row_found,ll_row_found,Primary!,lds_modified_rows,1,Primary!)
			end if
		next		

		int li_rc
		li_rc = iw_parent.in_parms.ids_pallet_carton_list.Reset()
		int li_ret
		li_ret = lds_modified_rows.RowsCopy(1,lds_modified_rows.RowCount(),Primary!,iw_parent.in_parms.ids_pallet_carton_list,1,Primary!)
		iw_parent.in_parms.of_set_serial_in_string_merge(lb_carton_list)
		iw_parent.in_parms.is_sscc_nr = isToPallet //To Pallet returned in Parm
		iw_parent.in_parms.is_carton_id = isToCarton //To Carton returned in Parm
		iw_parent.in_parms.is_to_scan_type = isContainerType
		iw_parent.in_parms.is_to_Pallet_type = isPalletType

		iw_parent.in_parms.of_set_status()
		iw_parent.TriggerEvent("ue_closing")
	end if	
end if



end event

event constructor;g.of_check_label_button(this)
end event

type sle_from from singlelineedit within u_adjust_pallet_merge_footprint
integer x = 558
integer y = 484
integer width = 695
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.SelectText(1, Len(this.text))
end event

event modified;Long llScanCount, llSerialScanCount, ll_row 
Integer	i, llArrayCountPallet, llArrayPosPallet, llArrayCountCarton, llArrayPosCarton

String ls_pallet_id //TAM 2018/02
String ls_from_pallet_id, ls_from_carton_id, ls_error_carton_list
string ls_sql_syntax, errors		
long ll_carton_row_count, ll_serial_row_count
boolean lb_palletscan, lb_cartonscan, lb_serialscan
long ll_content_qty


ls_pallet_id = Trim(this.text)

llArrayPosPallet = UpperBound(is_print_pallets[])
llArrayPosCarton = UpperBound(is_print_cartons[])

this.text = Trim(this.text)
if Len(Trim(sle_to.text)) = 0 then
	MessageBox(iw_parent.title, "Please enter a To: SSCC ID first.", Exclamation!)
	sle_to.SetFocus()
	return
end if

if Upper(this.text) = Upper(Trim(sle_to.text)) then
	MessageBox(iw_parent.title, "To: From: SSCC IDs must not match.", Exclamation!)	
	sle_from.SetFocus()
	return
end if

// Determine if a valid SSCC# or Carton ID or Serial was entered
datastore lds_pallet_carton
lds_pallet_carton = Create datastore
//lds_pallet_carton.Dataobject = 'd_content_pallet_adjust_footprint'
//lds_pallet_carton.SetTransObject(sqlca)


ls_sql_syntax = " SELECT COUNT(*) AS Carton_Count, po_no2, Carton_Id "
ls_sql_syntax += " FROM Serial_Number_Inventory WITH (NOLOCK) "
ls_sql_syntax += " WHERE Project_Id = '" + gs_project + "'"
ls_sql_syntax += " AND SKU = '" + iw_parent.in_parms.is_sku + "'"
ls_sql_syntax += " AND Po_No2 like '" + ls_pallet_id + "'"
ls_sql_syntax += " AND Carton_Id like '%'"
ls_sql_syntax += " group by po_no2, Carton_Id"		
		
lds_pallet_carton.Create(SQLCA.SyntaxFromSQL(ls_sql_syntax, "", ERRORS))
		IF Len(Errors) > 0 THEN
			messagebox(iw_parent.title, "*** Unable to create datastore ~r~r" + Errors)
			return
		END IF
lds_pallet_carton.SetTransObject(SQLCA)
ll_carton_row_count = lds_pallet_carton.Retrieve()

if ll_carton_row_count > 0 then //From Pallet Scanned
	lb_palletscan = true
else

	//If not Pallet check if Carton
	ls_sql_syntax = Replace(ls_sql_syntax,pos(ls_sql_syntax,this.text),len(this.text),"%")	
	ls_sql_syntax = Replace(ls_sql_syntax,pos(ls_sql_syntax,"Carton_Id like '%'" ),18,"Carton_Id like '" + this.text + "'")	

	lds_pallet_carton.setsqlselect(ls_sql_syntax)
	ll_carton_row_count = lds_pallet_carton.Retrieve()

	if  ll_carton_row_count > 0 then
		lb_cartonscan = true
	else

	//If not Carton check if serial number

		select count(*), po_no2, carton_id
		into :ll_carton_row_count, :ls_from_pallet_id, :ls_from_carton_id
		from serial_number_inventory with (NOLOCK)
		where project_id = :gs_project
		and sku = :iw_parent.in_parms.is_sku
		and serial_no = :this.text
		Group By po_no2, carton_id
		;

		//Add carton to pallet_carton
		if ll_carton_row_count > 0 then
			ll_row = lds_pallet_carton.InsertRow(0)
			lds_pallet_carton.Object.po_no2[ll_row] = ls_from_pallet_id
			lds_pallet_carton.Object.carton_id[ll_row] = ls_from_carton_id
			lds_pallet_carton.Object.Carton_Count[ll_row] = ll_carton_row_count
			lb_serialscan = true
		end if
	end if
	
end if

if NOT lb_palletscan and NOT lb_cartonscan and NOT lb_serialscan then
	MessageBox(iw_parent.title, "Number entered is not a Pallet Number,Carton ID or Serial Number", Exclamation!)
	sle_from.SetFocus()
	return
end if

if lb_palletscan then
	
/* If the From Pallet was scanned Then we need to check the TO Value that was scan to determine if it is allowed
	If TO Value is a Carton then this is an Error - can't scan a pallet into carton
	If TO Value is a Pallet that has Cartons then check if the FROM Pallet also has Cartons
		If it does then Merge Pallet
		If is does not then this is an error - Cannot move loose serial number to a containerized Pallet
	If TO Value is a Pallet that does NOT have Cartons then check if the FROM Pallet has Cartons
		If FROM Pallet has cartons then display a (Y/N)message that carton numbers will be removed On 'Yes' Merge Pallet
		If FROM Pallet does not have cartons then Merge Pallet */
	
	If IsContainerType = 'C' then // this is an Error - can't scan a pallet into carton
		MessageBox(iw_parent.title, "The scanned TO container is a carton.  You cannot scan a Pallet into a carton! ", Exclamation!)
		sle_from.SetFocus()
		return
	Else //Validate the To Pallet Type against the From Pallet Type

		If IsPalletType = 'C' Then //TO Pallet has Cartons
			If UPPER(lds_pallet_carton.Object.Carton_Id[1]) = 'DUMMY' or lds_pallet_carton.Object.Carton_Id[1] = '-' or UPPER(lds_pallet_carton.Object.Carton_Id[1]) = 'NA' Then // From Pallet Does Not Have Cartons
				MessageBox(iw_parent.title, "The TO Pallet is containerized but the FROM Pallet is Not.  You cannot mix loose serial numbers on a containerized Pallet! ", Exclamation!)
				sle_from.SetFocus()
				return
			Else // From Pallet has Cartons
				//Load the list of cartons to Move
				if ll_carton_row_count > 0 then
					for i = 1 to ll_carton_row_count
						if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
							ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
						else
							if of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
								ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
							else
								of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

								//Build Array used to print Pallet labels
								If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
									llArrayPosCarton ++
									is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
								End If

							end if
						end if
					next
					this.text = ""
				end if	

				if Len(ls_error_carton_list) > 0 then
					if(Right(Trim(ls_error_carton_list),1) = ",") then
						ls_error_carton_list = Left(ls_error_carton_list, Len(ls_error_carton_list) -1)
					end if
					MessageBox(iw_parent.title, "The following carton IDs were not added to the scanned carton list because they already exist on the list or the destination pallet: ~r~r" +&
					ls_error_carton_list, Exclamation!)
					return
				end if	

			End If
		Else //TO Pallet is Serialized
			
			// From Pallet is also Serialized then Allow merge
			If lds_pallet_carton.Object.Carton_Id[1] = 'DUMMY' or lds_pallet_carton.Object.Carton_Id[1] = '-'  or UPPER(lds_pallet_carton.Object.Carton_Id[1]) = 'NA' Then // From Pallet Does Not Have Cartons


				if ll_carton_row_count > 0 then
	
					for i = 1 to ll_carton_row_count
						//If carton already exists then increment existing pallet/carton qty by 1
						if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) or &
						of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
							MessageBox(iw_parent.title, "The Pallet or Carton number was already scanned! ", Exclamation!)
							sle_from.SetFocus()
							return
						else //add a carton row
							of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

							//Build Array used to print Pallet labels
							If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
								llArrayPosCarton ++
								is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
							End If

						end if
					next
					this.text = ""
					sle_from.setFocus()
				end if

			Else // From Pallet has Cartons - Send a response messged asking to remove cartons
				If MessageBox(iw_parent.title, "The TO Pallet is NOT containerized. If you continue you will lose your container IDs.  Do you want to proceed?", Exclamation!, YesNo!,2 ) <> 1 Then
					sle_from.SetFocus()
					return
				Else
					//ToDo -Load the list of cartons to Move
					//Load the list of cartons to Move
					if ll_carton_row_count > 0 then
						for i = 1 to ll_carton_row_count
						//If carton already exists then increment existing pallet/carton qty by 1
							if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) or &
							of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
								ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
							else
							
								of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

								//Build Array used to print Pallet labels
								If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
									llArrayPosCarton ++
									is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
								End If

							end if
						next
						this.text = ""
					End If
					
					if Len(ls_error_carton_list) > 0 then
						if(Right(Trim(ls_error_carton_list),1) = ",") then
							ls_error_carton_list = Left(ls_error_carton_list, Len(ls_error_carton_list) -1)
						end if
						MessageBox(iw_parent.title, "The following carton IDs were not added to the scanned carton list because they already exist on the list or the destination pallet: ~r~r" +&
						ls_error_carton_list, Exclamation!)
						return
					end if	

				End If
			End If
		End If
	End If


ElseIf lb_cartonscan then
/* If the From Carton was scanned hen we need to check the TO Value that was scan to determine if it is allowed
	If TO Value is a Carton Merge the Cartons
	If TO Value is a Pallet that has Cartons Move the Carton
	If TO Value is a Pallet that does NOT have Cartons then this is an error - Cannot move a container on to a loose serial pallet
*/

	If IsContainerType = 'C' then //To Container is a Carton
		//ToDo -Load the list of cartons to Move
		//Load the list of cartons to Move
		if ll_carton_row_count > 0 then
			for i = 1 to ll_carton_row_count
				if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
					ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
				else
					if of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
						ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
					else
						of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

						//Build Array used to print Pallet labels
						If UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'DUMMY' and lds_pallet_carton.Object.Po_No2[1] <> '-'  and UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'NA' and i = 1 Then 
							llArrayPosPallet ++
							is_print_pallets[llArrayPosPallet] = lds_pallet_carton.Object.Po_No2[1]
						End If
						//Build Array used to print Pallet labels
						If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
							llArrayPosCarton ++
							is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
						End If

					end if
				end if
			next
			this.text = ""
		End If
					
		if Len(ls_error_carton_list) > 0 then
			if(Right(Trim(ls_error_carton_list),1) = ",") then
				ls_error_carton_list = Left(ls_error_carton_list, Len(ls_error_carton_list) -1)
			end if
			MessageBox(iw_parent.title, "The following carton IDs were not added to the scanned carton list because they already exist on the list or the destination pallet: ~r~r" +&
			ls_error_carton_list, Exclamation!)
			return
		end if	

	Else // To Container is a Pallet
		If IsPalletType = 'S' then //TO Pallet does NOT have Cartons
			If MessageBox(iw_parent.title, "The TO Pallet is NOT containerized. If you continue you will lose your container IDs.  Do you want to proceed?", Exclamation!,YesNo!,2 ) <> 1 Then
				sle_from.SetFocus()
				return
			Else // From Cartons will be lost
				//ToDo -Load the list of cartons to Move
				//Load the list of cartons to Move
				if ll_carton_row_count > 0 then
					for i = 1 to ll_carton_row_count
						if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
							ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
						else
							if of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
								ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
							else
								of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

								//Build Array used to print Pallet labels
								If UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'DUMMY' and lds_pallet_carton.Object.Po_No2[1] <> '-'  and UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'NA' and i = 1 Then 
									llArrayPosPallet ++
									is_print_pallets[llArrayPosPallet] = lds_pallet_carton.Object.Po_No2[i]
								End If
								//Build Array used to print Pallet labels
								If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
									llArrayPosCarton ++
									is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
								End If

							end if
						end if
					next
					this.text = ""
				End If
					
				if Len(ls_error_carton_list) > 0 then
					if(Right(Trim(ls_error_carton_list),1) = ",") then
						ls_error_carton_list = Left(ls_error_carton_list, Len(ls_error_carton_list) -1)
					end if
					MessageBox(iw_parent.title, "The following carton IDs were not added to the scanned carton list because they already exist on the list or the destination pallet: ~r~r" +&
					ls_error_carton_list, Exclamation!)
					return
				end if	

			End If
		Else //TO Pallet has Cartons
			//Load the carton to Move
			if ll_carton_row_count > 0 then
				for i = 1 to ll_carton_row_count
					if iw_parent.in_parms.of_contains_footprint_carton(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
						ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
					else
						if of_carton_list_contains(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i]) then
							ls_error_carton_list += lds_pallet_carton.Object.Carton_Id[i] + ","
						else
							of_add_carton(lds_pallet_carton.Object.Po_no2[i], lds_pallet_carton.Object.Carton_id[i], lds_pallet_carton.Object.Carton_Count[i] )	// Move the carton to the needed Datastores

							//Build Array used to print Pallet labels
							If UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'DUMMY' and lds_pallet_carton.Object.Po_No2[1] <> '-'  and UPPER(lds_pallet_carton.Object.Po_No2[1]) <> 'NA' and i = 1 Then 
								llArrayPosPallet ++
								is_print_pallets[llArrayPosPallet] = lds_pallet_carton.Object.Po_No2[1]
							End If
							//Build Array used to print Pallet labels
							If UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'DUMMY' and lds_pallet_carton.Object.Carton_id[i] <> '-'  and UPPER(lds_pallet_carton.Object.Carton_id[i]) <> 'NA' Then 
								llArrayPosCarton ++
								is_print_cartons[llArrayPosCarton] = lds_pallet_carton.Object.Carton_id[i]
							End If

						end if
					end if
				next
				this.text = ""
			End If
			if Len(ls_error_carton_list) > 0 then
				if(Right(Trim(ls_error_carton_list),1) = ",") then
					ls_error_carton_list = Left(ls_error_carton_list, Len(ls_error_carton_list) -1)
				end if
				MessageBox(iw_parent.title, "The following carton IDs were not added to the scanned carton list because they already exist on the list or the destination pallet: ~r~r" +&
				ls_error_carton_list, Exclamation!)
				return
			end if	

		End If
	End If 
	
/* If the From Serial was scanned then we need to check the TO Value that was scan to determine if it is allowed - Dont Break an existing carton or pallet from here
	If TO Value is a Carton Add the Serial to the Carton
	If TO Value is a Pallet does NOT have Cartons then Add the serial number to the pallet
	If TO Value is a Pallet has Cartons this is an error - Cannot move a loose serial number to a containerize pallet
*/

Else //Serial Number scanned
	//Only Allow loose serial numbers - IE don't break another carton or Pallet
	If((UPPER(ls_from_pallet_id) <> 'DUMMY' and UPPER(ls_from_pallet_id) <> 'NA' and ls_from_pallet_id <> '-') or (UPPER(ls_from_carton_id) <> 'DUMMY' and UPPER(ls_from_carton_id) <> 'NA' and ls_from_carton_id <> '-' )) Then	
		MessageBox(iw_parent.title, "The Serial Number scanned is on an existing Pallet or Container.  You cannot break the container from here! ", Exclamation!)
		sle_from.SetFocus()
		return
	End If
	
	If IsContainerType = 'P' and IsPalletType = 'C' then //Can't put Serial Numbers on Containerized pallet
		MessageBox(iw_parent.title, "The TO Pallet is containerized.  You cannot mix loose serial numbers on a containerized Pallet! ", Exclamation!)
		sle_from.SetFocus()
		return
	End If

	if ll_carton_row_count > 0 then
	
		for i = 1 to ll_carton_row_count
			//If carton already exists then increment existing pallet/carton qty by 1
			if of_serial_list_contains(this.text) then
				MessageBox(iw_parent.title, "The Serial Number has already been scanned! ", Exclamation!)
				sle_from.SetFocus()
				return
			end if
			of_add_serial(lds_pallet_carton.Object.Po_No2[i], lds_pallet_carton.Object.Carton_Id[i])
			//increment the serial screen count
			lb_carton_list.AddItem(this.text)
		next
		this.text = ""
		sle_from.setFocus()
	end if
End If	

sle_serial_scanned.text = string(lb_carton_list.totalitems( ))
sle_carton_scanned.text = string(idw_scanned_cartons.rowcount( ))

long llcartonqty
llcartonqty = 0
if idw_scanned_cartons.rowcount( ) > 0 then 
	for i = 1 to idw_scanned_cartons.rowcount( )
		llcartonqty = llcartonqty + 	idw_scanned_cartons.getitemnumber( i, 'qty')
	next
end if
sle_carton_qty.text = string(llcartonqty)

destroy lds_pallet_carton
end event

type st_sscc from statictext within u_adjust_pallet_merge_footprint
integer x = 247
integer y = 272
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "SSCC ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_section_title from statictext within u_adjust_pallet_merge_footprint
integer x = 553
integer y = 32
integer width = 2126
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Merge Cartons and Serials to a Pallet"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;//
end event

type st_2 from statictext within u_adjust_pallet_merge_footprint
integer x = 773
integer y = 640
integer width = 777
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Scanned Cartons"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type gb_2 from groupbox within u_adjust_pallet_merge_footprint
integer x = 41
integer y = 156
integer width = 2482
integer height = 228
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Designation Pallet or Carton"
end type

type gb_1 from groupbox within u_adjust_pallet_merge_footprint
integer x = 50
integer y = 372
integer width = 2469
integer height = 268
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From "
end type

