HA$PBExportHeader$u_adjust_pallet.sru
forward
global type u_adjust_pallet from userobject
end type
type cb_print from commandbutton within u_adjust_pallet
end type
type st_3 from statictext within u_adjust_pallet
end type
type sle_carton_scanned from singlelineedit within u_adjust_pallet
end type
type lb_carton_list from listbox within u_adjust_pallet
end type
type st_carton from statictext within u_adjust_pallet
end type
type sle_carton from singlelineedit within u_adjust_pallet
end type
type cb_cancel from commandbutton within u_adjust_pallet
end type
type cb_do_it from commandbutton within u_adjust_pallet
end type
type st_carton_count from statictext within u_adjust_pallet
end type
type sle_carton_count from singlelineedit within u_adjust_pallet
end type
type sle_sscc from singlelineedit within u_adjust_pallet
end type
type st_sscc from statictext within u_adjust_pallet
end type
type st_section_title from statictext within u_adjust_pallet
end type
type st_2 from statictext within u_adjust_pallet
end type
end forward

global type u_adjust_pallet from userobject
integer width = 2062
integer height = 1864
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_post_open ( )
event type long ue_print_labels ( )
cb_print cb_print
st_3 st_3
sle_carton_scanned sle_carton_scanned
lb_carton_list lb_carton_list
st_carton st_carton
sle_carton sle_carton
cb_cancel cb_cancel
cb_do_it cb_do_it
st_carton_count st_carton_count
sle_carton_count sle_carton_count
sle_sscc sle_sscc
st_sscc st_sscc
st_section_title st_section_title
st_2 st_2
end type
global u_adjust_pallet u_adjust_pallet

type variables
w_adjust_pallet iw_parent
string is_sscc_nr_2 //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
boolean ib_Print //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
end variables
event ue_post_open();sle_sscc.SetFocus()

//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - START
ib_Print =FALSE

IF upper(gs_project) ='PANDORA' Then
	cb_print.visible =TRUE
else
	cb_print.visible =FALSE
End IF

n_warehouse ln_warehouse
ln_warehouse = create n_warehouse
is_sscc_nr_2 = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
destroy ln_warehouse
//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode - END
end event

event type long ue_print_labels();//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
//print label for old Pallet Id and new Pallet Id.

string ls_sku, ls_wh, ls_from_palletId, ls_sql, ls_errors, ls_string_data, ls_filter
long ll_row, ll_Return
str_parms  lstr_Orig_Pallet_serial_List, lstr_New_Pallet_serial_List, lstr_carton_List

Datastore lds_serial
n_labels_pandora lu_pandora_labels
lu_pandora_labels = create n_labels_pandora

n_adjust_pallet_parms lu_pallet_parm
lu_pallet_parm = create n_adjust_pallet_parms

ls_from_palletId = sle_sscc.text
ls_sku = iw_parent.in_parms.is_sku
ls_wh = iw_parent.in_parms.is_warehouse

//get list of Serial No's associated with Pallet Id.
lds_serial =create Datastore
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and wh_code ='"+ls_wh+"' and sku ='"+ls_sku+"'"
ls_sql += " and Po_No2='"+ls_from_palletId+"'"

lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

If (len(ls_errors) > 0 or lds_serial.rowcount( ) =0) Then
	MessageBox("Print 2D Barcode Label", "Unable to retrieve Serial No Inventory Records against Pallet Id# "+ls_from_palletId)
	Return -1
End If

//1. Print Label for NEW Pallet Id
//(a) get a list of scanned carton no's. (which needs to be moved into different Pallet)
If lb_carton_list.TotalItems() > 0 Then
	For ll_row =1 to lb_carton_list.TotalItems()
		lstr_carton_List.string_arg[ll_row] = lb_carton_list.text( ll_row)
	Next
End If

ls_string_data = lu_pallet_parm.of_set_serial_in_string_merge( lb_carton_list)

//(b) apply filter against above moved container Id
ls_filter =" carton_Id IN "+ls_string_data
lds_serial.setfilter( ls_filter)
lds_serial.filter( )
lds_serial.rowcount( )

For ll_row =1 to lds_serial.rowcount( )
	lstr_New_Pallet_serial_List.string_Arg[ll_row] = lds_serial.getItemstring( ll_row, 'serial_no')
Next

//(c) print 2D Barcode Label for New Pallet Id
ll_Return = lu_pandora_labels.uf_print_2d_barcode_label( lstr_New_Pallet_serial_List, ls_sku, ls_wh, is_sscc_nr_2, 'PALLET LABEL')
IF ll_Return < 0 Then Return -1

//clear filter
lds_serial.setfilter( "")
lds_serial.filter( )
lds_serial.rowcount( )

//2. Print Label for Remaining Serial No's against Old Container Id

//(a) apply filter against above non-moved container Id's
ls_filter =" carton_Id NOT IN "+ls_string_data
lds_serial.setfilter( ls_filter)
lds_serial.filter( )
lds_serial.rowcount( )

For ll_row =1 to lds_serial.rowcount( )
	lstr_Orig_Pallet_serial_List.string_Arg[ll_row] = lds_serial.getItemstring( ll_row, 'serial_no')
Next

//(b) print 2D Barcode Label for Old Container Id
ll_Return = lu_pandora_labels.uf_print_2d_barcode_label( lstr_Orig_Pallet_serial_List, ls_sku, ls_wh, ls_from_palletId, 'PALLET LABEL')
IF ll_Return < 0 Then Return -1

ib_Print =TRUE

destroy lds_serial
destroy lu_pandora_labels
destroy lu_pallet_parm
end event

on u_adjust_pallet.create
this.cb_print=create cb_print
this.st_3=create st_3
this.sle_carton_scanned=create sle_carton_scanned
this.lb_carton_list=create lb_carton_list
this.st_carton=create st_carton
this.sle_carton=create sle_carton
this.cb_cancel=create cb_cancel
this.cb_do_it=create cb_do_it
this.st_carton_count=create st_carton_count
this.sle_carton_count=create sle_carton_count
this.sle_sscc=create sle_sscc
this.st_sscc=create st_sscc
this.st_section_title=create st_section_title
this.st_2=create st_2
this.Control[]={this.cb_print,&
this.st_3,&
this.sle_carton_scanned,&
this.lb_carton_list,&
this.st_carton,&
this.sle_carton,&
this.cb_cancel,&
this.cb_do_it,&
this.st_carton_count,&
this.sle_carton_count,&
this.sle_sscc,&
this.st_sscc,&
this.st_section_title,&
this.st_2}
end on

on u_adjust_pallet.destroy
destroy(this.cb_print)
destroy(this.st_3)
destroy(this.sle_carton_scanned)
destroy(this.lb_carton_list)
destroy(this.st_carton)
destroy(this.sle_carton)
destroy(this.cb_cancel)
destroy(this.cb_do_it)
destroy(this.st_carton_count)
destroy(this.sle_carton_count)
destroy(this.sle_sscc)
destroy(this.st_sscc)
destroy(this.st_section_title)
destroy(this.st_2)
end on

event constructor;iw_parent = message.PowerObjectParm	
this.PostEvent("ue_post_open")

n_warehouse ln_warehouse
ln_warehouse = create n_warehouse
is_sscc_nr_2 = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
destroy ln_warehouse

end event

type cb_print from commandbutton within u_adjust_pallet
integer x = 1312
integer y = 1756
integer width = 562
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print &2D &Labels"
end type

event clicked;//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
Parent.event ue_print_labels( )

end event

type st_3 from statictext within u_adjust_pallet
integer x = 343
integer y = 1660
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

type sle_carton_scanned from singlelineedit within u_adjust_pallet
integer x = 942
integer y = 1660
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

type lb_carton_list from listbox within u_adjust_pallet
integer x = 370
integer y = 648
integer width = 777
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

type st_carton from statictext within u_adjust_pallet
integer x = 41
integer y = 452
integer width = 302
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
string text = "Carton:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_carton from singlelineedit within u_adjust_pallet
integer x = 347
integer y = 444
integer width = 809
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

event modified;Long llScanCount
this.text = Trim(this.text)

if Len(this.text) > 0 then	
	long ll_carton_count
	if IsNumber(sle_carton_count.text) then
		ll_carton_count = Long(sle_carton_count.text)
		if ll_carton_count > 0 then
			if lb_carton_list.FindItem(this.text,0) > 0 then
				MessageBox("Error", "Carton: " + this.text + " already scanned into list.", Exclamation!)
				sle_carton.SetFocus()
			elseif iw_parent.in_parms.of_contains_carton(this.text) then
				llScanCount = Long(sle_carton_scanned.text)
				lb_carton_list.AddItem(Trim(this.text))
				sle_carton_count.text = String(ll_carton_count - 1)
				llScanCount = llScanCount + 1
				sle_Carton_scanned.text = String(llScanCount)
				This.setfocus( )
				// Add this carton count to the carton count summation
				iw_parent.in_parms.of_increment_carton_count(this.text)

				this.text = ""
			else
				MessageBox("Error", "Carton: " + this.text + " does not exist in this inventory result set.", Exclamation!)
				sle_carton.SetFocus()
			end if
		else
			MessageBox("Error", "All cartons have been scanned.", Exclamation!)
		end if
	end if
end if

end event

type cb_cancel from commandbutton within u_adjust_pallet
integer x = 768
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

type cb_do_it from commandbutton within u_adjust_pallet
integer x = 265
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

event clicked;//05-MAR-2018 :Madhu  S16401 -Print 2D Barcode
If upper(gs_project) ='PANDORA' and ib_Print =FALSE Then
	If MessageBox("Print 2D Barcode Labels"," 2D Barcode Labels are NOT printed, Would you like to print Labels? ", question!, YESNO!) = 1 Then
		Parent.event ue_print_labels( )
	End If
End If

if Len(Trim(sle_sscc.text)) > 0 and lb_carton_list.TotalItems() > 0 then

	if MessageBox(iw_parent.title, "Are you sure you want to break pallet: " + Trim(sle_sscc.text) + "?",question!, yesno!) = 1 then
	
		String ls_carton, ls_sscc_nr_1, ls_sscc_nr_2
		//n_warehouse ln_warehouse //05-MAR-2018 :Madhu  S16401 -Print 2D Barcode (Moved to Parent Post Open)
		//ln_warehouse = create n_warehouse //05-MAR-2018 :Madhu  S16401 -Print 2D Barcode
		
		//ls_sscc_nr_1 = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')		// LTK 20131018  No longer give the old group a new SSCC#
		//ls_sscc_nr_2 = ln_warehouse.of_get_sscc_bol(gs_project, 'SSCC_No')
		ls_sscc_nr_2 = is_sscc_nr_2 //05-MAR-2018 :Madhu  S16401 -Print 2D Barcode
		//destroy ln_warehouse //05-MAR-2018 :Madhu  S16401 -Print 2D Barcode
		
		// Both the selected group of cartons will receive a new SSCC# and the remaing group of cartons will receive a new SSCC#
		
		// LTK 20131018  Users only want the newly selected group to get a new SSCC#, not the old group
		//
		//// First, set the entire datastore's SSCC# to one of the two new SSCC#'s generated 
		//long i
		//for i = 1 to iw_parent.in_parms.ids_content_rs.RowCount()
		//	iw_parent.in_parms.ids_content_rs.Object.po_no2[i] = ls_sscc_nr_1
		//next

		datastore lds_modified_rows
		lds_modified_rows = Create datastore
		lds_modified_rows.Dataobject = 'd_content_pallet_adjust'
		lds_modified_rows.SetTransObject(sqlca)
		lds_modified_rows.Reset()

		// Next, set the SSCC# for the selected cartons to the new SSCC#
		int j
		for j = 1 to lb_carton_list.TotalItems()
			
			if j = 1 then
				iw_parent.in_parms.ib_some_cartons_broken = true		
			end if
		
			ls_carton = lb_carton_list.Text(j)
			long ll_row_found
			//ll_row_found = iw_parent.in_parms.ids_content_rs.Find("container_id = '" + ls_carton + "'", 1, iw_parent.in_parms.ids_content_rs.RowCount())
			ll_row_found = iw_parent.in_parms.ids_content_rs.Find("carton_id = '" + ls_carton + "'", 1, iw_parent.in_parms.ids_content_rs.RowCount())
			if ll_row_found > 0 then
				//iw_parent.in_parms.ids_content_rs.Object.po_no2[ll_row_found] = ls_sscc_nr_2
				int li_ret2
				li_ret2 = iw_parent.in_parms.ids_content_rs.RowsCopy(ll_row_found,ll_row_found,Primary!,lds_modified_rows,1,Primary!)
				//TAM 2018/02 - S14383  - create a carton list to facilitate Merging and Breaking Pallets
				iw_parent.in_parms.of_add_carton(ls_carton)
			end if
		next		

		int li_rc
		li_rc = iw_parent.in_parms.ids_content_rs.Reset()
		int li_ret
		li_ret = lds_modified_rows.RowsCopy(1,lds_modified_rows.RowCount(),Primary!,iw_parent.in_parms.ids_content_rs,1,Primary!)
		iw_parent.in_parms.is_sscc_nr_new = ls_sscc_nr_2

		iw_parent.in_parms.of_set_status()
		iw_parent.TriggerEvent("ue_closing")
	end if	
else	
	MessageBox(iw_parent.title, "Please enter an SSCC ID and then scan cartons.")
	if Len(Trim(sle_sscc.text)) = 0 then 
		sle_sscc.SetFocus()
	elseif lb_carton_list.TotalItems() = 0 then 
			sle_carton.SetFocus()
	end if
end if

end event

event constructor;g.of_check_label_button(this)

end event

type st_carton_count from statictext within u_adjust_pallet
integer x = 1152
integer y = 248
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

type sle_carton_count from singlelineedit within u_adjust_pallet
integer x = 1367
integer y = 328
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

type sle_sscc from singlelineedit within u_adjust_pallet
integer x = 347
integer y = 240
integer width = 809
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
	lb_carton_list.Reset()
	sle_carton_count.text = "0"
	
	iw_parent.in_parms.is_sscc_nr = this.text
	long ll_carton_count
	ll_carton_count = iw_parent.in_parms.of_load_datastores()

	if ll_carton_count > 0 then
		sle_carton_count.text = String(ll_carton_count)
		sle_carton.SetFocus()
	elseif ll_carton_count = 0 then
		MessageBox(iw_parent.title, "No inventory found for the following parameters: ~r~r" + iw_parent.in_parms.of_get_parms_display())
		SetFocus(sle_sscc)
	else
		MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
		SetFocus(sle_sscc)
	end if
end if

end event

type st_sscc from statictext within u_adjust_pallet
integer x = 41
integer y = 248
integer width = 302
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

type st_section_title from statictext within u_adjust_pallet
integer x = 14
integer y = 32
integer width = 1435
integer height = 144
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Break a Pallet"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;//
end event

type st_2 from statictext within u_adjust_pallet
integer x = 370
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
string text = "Scanned Cartons"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

