$PBExportHeader$u_adjust_carton.sru
forward
global type u_adjust_carton from userobject
end type
type cb_print from commandbutton within u_adjust_carton
end type
type sle_serials_scanned from singlelineedit within u_adjust_carton
end type
type st_3 from statictext within u_adjust_carton
end type
type lb_serial_list from listbox within u_adjust_carton
end type
type st_carton from statictext within u_adjust_carton
end type
type sle_serial from singlelineedit within u_adjust_carton
end type
type cb_cancel from commandbutton within u_adjust_carton
end type
type cb_do_it from commandbutton within u_adjust_carton
end type
type st_carton_count from statictext within u_adjust_carton
end type
type sle_serial_count from singlelineedit within u_adjust_carton
end type
type sle_carton from singlelineedit within u_adjust_carton
end type
type st_sscc from statictext within u_adjust_carton
end type
type st_section_title from statictext within u_adjust_carton
end type
type st_2 from statictext within u_adjust_carton
end type
end forward

global type u_adjust_carton from userobject
integer width = 2272
integer height = 1900
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_post_open ( )
event type long ue_print_labels ( )
cb_print cb_print
sle_serials_scanned sle_serials_scanned
st_3 st_3
lb_serial_list lb_serial_list
st_carton st_carton
sle_serial sle_serial
cb_cancel cb_cancel
cb_do_it cb_do_it
st_carton_count st_carton_count
sle_serial_count sle_serial_count
sle_carton sle_carton
st_sscc st_sscc
st_section_title st_section_title
st_2 st_2
end type
global u_adjust_carton u_adjust_carton

type variables
w_adjust_pallet iw_parent
string is_sscc_nr_new, is_carton_id_new //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
boolean ib_Print //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
end variables

event ue_post_open();sle_carton.SetFocus()

//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - START
ib_Print =FALSE

IF upper(gs_project) ='PANDORA' Then
	cb_print.visible =TRUE
else
	cb_print.visible =FALSE
End IF

n_warehouse ln_warehouse
ln_warehouse = create n_warehouse
is_sscc_nr_new = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
is_carton_id_new = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
destroy ln_warehouse
//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - END
end event

event type long ue_print_labels();//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
//print label for old contianer Id and new contianer Id.

string ls_sku, ls_wh, ls_from_containerId, ls_sql, ls_errors, ls_string_data
long ll_row, ll_Return
str_parms lstr_serial_List, lstr_serial_old_List

Datastore lds_serial
n_labels_pandora lu_pandora_labels
lu_pandora_labels = create n_labels_pandora

n_adjust_pallet_parms lu_pallet_parm
lu_pallet_parm = create n_adjust_pallet_parms

ls_from_containerId = sle_carton.text
ls_sku = iw_parent.in_parms.is_sku
ls_wh = iw_parent.in_parms.is_warehouse

//1. Print Label for Scanned Serial No's against NEW Container Id
//get a list of scanned serial no's. (which needs to be moved into different container)
If lb_serial_list.TotalItems() > 0 Then
	For ll_row =1 to lb_serial_list.TotalItems()
		lstr_serial_List.string_arg[ll_row] = lb_serial_list.text( ll_row)
	Next
End If

//print 2D Barcode Label for New Container Id
ll_Return = lu_pandora_labels.uf_print_2d_barcode_label( lstr_serial_List, ls_sku, ls_wh, is_carton_id_new, 'CARTON LABEL')
IF ll_Return < 0 Then Return -1


//2. Print Label for Remaining Serial No's against Old Container Id
//get String of scanned serial no's.
ls_string_data = lu_pallet_parm.of_set_serial_in_string_merge( lb_serial_list)

lds_serial =create Datastore
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and wh_code ='"+ls_wh+"' "
ls_sql +=" and sku ='"+ls_sku+"' and carton_Id ='"+ls_from_containerId+"'"
ls_sql +=" and serial_no NOT IN "+ls_string_data

lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

If (len(ls_errors) > 0 or lds_serial.rowcount( ) =0) Then
	MessageBox("Print 2D Barcode Label", "Unable to retrieve Serial No Inventory Records against Container Id# "+ls_from_containerId)
	Return -1
End If

For ll_row =1 to lds_serial.rowcount( )
	lstr_serial_old_List.string_Arg[ll_row] = lds_serial.getItemstring( ll_row, 'serial_no')
Next

//print 2D Barcode Label for Old Container Id
ll_Return = lu_pandora_labels.uf_print_2d_barcode_label( lstr_serial_old_List, ls_sku, ls_wh, ls_from_containerId, 'CARTON LABEL')
IF ll_Return < 0 Then Return -1

ib_Print =TRUE

destroy lds_serial
destroy lu_pandora_labels
destroy lu_pallet_parm
end event

on u_adjust_carton.create
this.cb_print=create cb_print
this.sle_serials_scanned=create sle_serials_scanned
this.st_3=create st_3
this.lb_serial_list=create lb_serial_list
this.st_carton=create st_carton
this.sle_serial=create sle_serial
this.cb_cancel=create cb_cancel
this.cb_do_it=create cb_do_it
this.st_carton_count=create st_carton_count
this.sle_serial_count=create sle_serial_count
this.sle_carton=create sle_carton
this.st_sscc=create st_sscc
this.st_section_title=create st_section_title
this.st_2=create st_2
this.Control[]={this.cb_print,&
this.sle_serials_scanned,&
this.st_3,&
this.lb_serial_list,&
this.st_carton,&
this.sle_serial,&
this.cb_cancel,&
this.cb_do_it,&
this.st_carton_count,&
this.sle_serial_count,&
this.sle_carton,&
this.st_sscc,&
this.st_section_title,&
this.st_2}
end on

on u_adjust_carton.destroy
destroy(this.cb_print)
destroy(this.sle_serials_scanned)
destroy(this.st_3)
destroy(this.lb_serial_list)
destroy(this.st_carton)
destroy(this.sle_serial)
destroy(this.cb_cancel)
destroy(this.cb_do_it)
destroy(this.st_carton_count)
destroy(this.sle_serial_count)
destroy(this.sle_carton)
destroy(this.st_sscc)
destroy(this.st_section_title)
destroy(this.st_2)
end on

event constructor;iw_parent = message.PowerObjectParm	
iw_parent.title = "Carton Adjust"
this.PostEvent("ue_post_open")
end event

type cb_print from commandbutton within u_adjust_carton
integer x = 1426
integer y = 1756
integer width = 521
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print 2D &Label"
end type

event clicked;//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
Parent.event ue_print_labels( )
end event

type sle_serials_scanned from singlelineedit within u_adjust_carton
integer x = 873
integer y = 1656
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

type st_3 from statictext within u_adjust_carton
integer x = 274
integer y = 1656
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

type lb_serial_list from listbox within u_adjust_carton
integer x = 293
integer y = 648
integer width = 1234
integer height = 1000
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_carton from statictext within u_adjust_carton
integer x = 5
integer y = 452
integer width = 279
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
string text = "Serial:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_serial from singlelineedit within u_adjust_carton
integer x = 293
integer y = 444
integer width = 1234
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
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.SelectText(1, Len(this.text))

end event

event modified;Long llScanCount
this.text = Trim(this.text)

if Len(this.text) > 0 then	
	long ll_serial_count
	if IsNumber(sle_serial_count.text) then
		ll_serial_count = Long(sle_serial_count.text)
		if ll_serial_count > 0 then
			if lb_serial_list.FindItem(this.text,0) > 0 then
				MessageBox("Error", "Serial: " + this.text + " already scanned into list.", Exclamation!)
				sle_serial.SetFocus()
			elseif iw_parent.in_parms.of_contains_serial(this.text) then
				llScanCount = Long(sle_serials_scanned.text)
				lb_serial_list.AddItem(Trim(this.text))
				sle_serial_count.text = String(ll_serial_count - 1)
				llScanCount = llScanCount + 1
				sle_serials_scanned.text = String(llScanCount)
				This.setfocus( )
				// Add 1 to the serial count summation
				iw_parent.in_parms.of_increment_serial_count(this.text)

				this.text = ""
			else
				MessageBox("Error", "Serial: " + this.text + " does not exist in this inventory result set.", Exclamation!)
				sle_serial.SetFocus()
			end if
		else
			MessageBox("Error", "All Serials have been scanned.", Exclamation!)
		end if
	end if
end if

end event

type cb_cancel from commandbutton within u_adjust_carton
integer x = 864
integer y = 1756
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

type cb_do_it from commandbutton within u_adjust_carton
integer x = 361
integer y = 1756
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

if Len(Trim(sle_carton.text)) > 0 and lb_serial_list.TotalItems() > 0 then

	if MessageBox(iw_parent.title, "Are you sure you want to break carton ID: " + Trim(sle_carton.text) + "?",question!, yesno!) = 1 then
	
		String ls_serial, ls_sscc_nr_1, ls_sscc_nr_new, ls_carton_id_new
		//05-MAR-2018 :Madhu  S16401 -Print 2D Barcode (Moved to Parent Post Open)
		/*n_warehouse ln_warehouse 
		ln_warehouse = create n_warehouse
		
		ls_sscc_nr_new = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
		ls_carton_id_new = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No') */
		ls_sscc_nr_new = is_sscc_nr_new
		ls_carton_id_new = is_carton_id_new
		//destroy ln_warehouse
	
		datastore lds_modified_rows
		lds_modified_rows = Create datastore
		lds_modified_rows.Dataobject = 'd_carton_serial_by_carton_id'
		lds_modified_rows.SetTransObject(sqlca)
		lds_modified_rows.Reset()

		// Next, set the new SSCC# and new carton ID for the selected serials
		int j
		for j = 1 to lb_serial_list.TotalItems()
			
			if j = 1 then
				iw_parent.in_parms.ib_some_serials_broken = true		
			end if
		
			ls_serial = lb_serial_list.Text(j)
			long ll_row_found
			ll_row_found = iw_parent.in_parms.ids_carton_serial.Find("serial_no = '" + ls_serial + "'", 1, iw_parent.in_parms.ids_carton_serial.RowCount())
			if ll_row_found > 0 then
				iw_parent.in_parms.ids_carton_serial.Object.pallet_id[ll_row_found] = ls_sscc_nr_new
				iw_parent.in_parms.ids_carton_serial.Object.carton_id[ll_row_found] = ls_carton_id_new
				int li_ret2
				li_ret2 = iw_parent.in_parms.ids_carton_serial.RowsCopy(ll_row_found,ll_row_found,Primary!,lds_modified_rows,1,Primary!)
			end if
		next		

		int li_rc
		li_rc = iw_parent.in_parms.ids_carton_serial.Reset()
		int li_ret
		li_ret = lds_modified_rows.RowsCopy(1,lds_modified_rows.RowCount(),Primary!,iw_parent.in_parms.ids_carton_serial,1,Primary!)
		iw_parent.in_parms.is_sscc_nr_new = ls_sscc_nr_new	// Not needed, the datastore has the new values already set
		iw_parent.in_parms.is_carton_id_new = ls_carton_id_new

		iw_parent.in_parms.of_set_status()
		iw_parent.TriggerEvent("ue_closing")
	end if	
else	
	MessageBox(iw_parent.title, "Please enter an Carton ID and then scan serial numbers.")
	if Len(Trim(sle_carton.text)) = 0 then 
		sle_carton.SetFocus()
	elseif lb_serial_list.TotalItems() = 0 then 
			sle_serial.SetFocus()
	end if
end if
end event

event constructor;g.of_check_label_button(this)
end event

type st_carton_count from statictext within u_adjust_carton
integer x = 1289
integer y = 248
integer width = 393
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
string text = "Serial Count"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_serial_count from singlelineedit within u_adjust_carton
integer x = 1481
integer y = 328
integer width = 155
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

type sle_carton from singlelineedit within u_adjust_carton
integer x = 293
integer y = 240
integer width = 987
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

event modified;this.text = Trim(this.text)

if Len(this.text) > 0 then
	lb_serial_list.Reset()
	sle_serial_count.text = "0"
	
	iw_parent.in_parms.is_carton_id = this.text
	long ll_serial_count
	ll_serial_count = iw_parent.in_parms.of_load_serials()

	if ll_serial_count > 0 then
		sle_serial_count.text = String(ll_serial_count)
		sle_serial.SetFocus()
		iw_parent.in_parms.is_carton_id = iw_parent.in_parms.ids_carton_serial.Object.carton_id[1]
		iw_parent.in_parms.is_sscc_nr = iw_parent.in_parms.ids_carton_serial.Object.pallet_id[1]
	elseif ll_serial_count = 0 then
		MessageBox(iw_parent.title, "No inventory found for the following parameters: ~r~r" + iw_parent.in_parms.of_get_parms_display())
		SetFocus(sle_carton)
	else
		MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
		SetFocus(sle_carton)
	end if
end if

end event

type st_sscc from statictext within u_adjust_carton
integer x = 5
integer y = 248
integer width = 279
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
string text = "Carton ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_section_title from statictext within u_adjust_carton
integer x = 14
integer y = 32
integer width = 1637
integer height = 144
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Break a Carton"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;//
end event

type st_2 from statictext within u_adjust_carton
integer x = 448
integer y = 572
integer width = 777
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
string text = "Scanned Serials"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

