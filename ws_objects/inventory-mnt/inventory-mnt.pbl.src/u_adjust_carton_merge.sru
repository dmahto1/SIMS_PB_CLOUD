$PBExportHeader$u_adjust_carton_merge.sru
forward
global type u_adjust_carton_merge from userobject
end type
type cb_print from commandbutton within u_adjust_carton_merge
end type
type st_3 from statictext within u_adjust_carton_merge
end type
type sle_serials_scanned from singlelineedit within u_adjust_carton_merge
end type
type sle_to_serial_count from singlelineedit within u_adjust_carton_merge
end type
type st_1 from statictext within u_adjust_carton_merge
end type
type lb_serial_list from listbox within u_adjust_carton_merge
end type
type st_sscc_or_carton from statictext within u_adjust_carton_merge
end type
type sle_to from singlelineedit within u_adjust_carton_merge
end type
type cb_cancel from commandbutton within u_adjust_carton_merge
end type
type cb_do_it from commandbutton within u_adjust_carton_merge
end type
type st_carton_count from statictext within u_adjust_carton_merge
end type
type sle_from_serial_count from singlelineedit within u_adjust_carton_merge
end type
type sle_from from singlelineedit within u_adjust_carton_merge
end type
type st_sscc from statictext within u_adjust_carton_merge
end type
type st_section_title from statictext within u_adjust_carton_merge
end type
type st_2 from statictext within u_adjust_carton_merge
end type
type gb_1 from groupbox within u_adjust_carton_merge
end type
type gb_2 from groupbox within u_adjust_carton_merge
end type
end forward

global type u_adjust_carton_merge from userobject
integer width = 2171
integer height = 1952
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_post_open ( )
event type long ue_print_labels ( )
cb_print cb_print
st_3 st_3
sle_serials_scanned sle_serials_scanned
sle_to_serial_count sle_to_serial_count
st_1 st_1
lb_serial_list lb_serial_list
st_sscc_or_carton st_sscc_or_carton
sle_to sle_to
cb_cancel cb_cancel
cb_do_it cb_do_it
st_carton_count st_carton_count
sle_from_serial_count sle_from_serial_count
sle_from sle_from
st_sscc st_sscc
st_section_title st_section_title
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global u_adjust_carton_merge u_adjust_carton_merge

type variables
w_adjust_pallet iw_parent
String is_pallet_id
String is_carton_id
String is_carton_id_new //TAM 2018/02 S14838
boolean ib_Print //05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode

end variables

forward prototypes
public function boolean of_carton_list_contains (string as_carton_id)
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
end event

event type long ue_print_labels();//05-MAR-2018 :Madhu  S16401 F6390 -Print 2D Barcode
//Print Part Label for New Container Id

String 	ls_To_containerId, ls_sku, ls_wh, ls_sql, ls_errors
long 		 ll_Return, ll_row
str_parms lstr_serialList

Datastore lds_serial

n_labels_pandora lu_pandora_labels
lu_pandora_labels =create n_labels_pandora

ls_To_containerId = sle_to.text
ls_sku = iw_parent.in_parms.is_sku
ls_wh =iw_parent.in_parms.is_warehouse

//get Serial No Records
lds_serial = create Datastore
ls_sql = " select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"' and sku ='"+ls_sku+"'"
ls_sql +=" and wh_code ='"+ls_wh+"' and carton_Id ='"+ls_To_containerId+"'"

lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
lds_serial.retrieve( )

IF (len(ls_errors) > 0  or lds_serial.rowcount( ) =0 )Then
	MessageBox("Carton Merge", "Unable to retrieve Serial Number Inventory records against container Id "+ls_To_containerId)
	Return -1
End IF

For ll_row =1 to lds_serial.rowcount( )
	lstr_serialList.string_arg[ll_row]   =lds_serial.getItemString( ll_row, 'serial_no')
Next

//get list of From Container Id Serial No's
If lb_serial_list.TotalItems() > 0 Then
	For ll_row =1 to lb_serial_list.Totalitems( )
		lstr_serialList.string_arg[UpperBound(lstr_serialList.string_arg) + 1] = lb_serial_list.text( ll_row)
	Next
End If

//Print 2D Barcode Labels
ll_Return =lu_pandora_labels.uf_print_2d_barcode_label( lstr_serialList, ls_sku, ls_wh, ls_To_containerId, 'CARTON LABEL')
If ll_Return < 0 Then Return -1

ib_Print =TRUE

destroy lds_serial
destroy lu_pandora_labels
end event

public function boolean of_carton_list_contains (string as_carton_id);String ls_carton
long j
for j = 1 to lb_serial_list.TotalItems()
	ls_carton = Upper(Trim(lb_serial_list.Text(j)))
	if Upper(Trim(as_carton_id)) = ls_carton then
		return true
	end if
next
return false

end function

on u_adjust_carton_merge.create
this.cb_print=create cb_print
this.st_3=create st_3
this.sle_serials_scanned=create sle_serials_scanned
this.sle_to_serial_count=create sle_to_serial_count
this.st_1=create st_1
this.lb_serial_list=create lb_serial_list
this.st_sscc_or_carton=create st_sscc_or_carton
this.sle_to=create sle_to
this.cb_cancel=create cb_cancel
this.cb_do_it=create cb_do_it
this.st_carton_count=create st_carton_count
this.sle_from_serial_count=create sle_from_serial_count
this.sle_from=create sle_from
this.st_sscc=create st_sscc
this.st_section_title=create st_section_title
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.cb_print,&
this.st_3,&
this.sle_serials_scanned,&
this.sle_to_serial_count,&
this.st_1,&
this.lb_serial_list,&
this.st_sscc_or_carton,&
this.sle_to,&
this.cb_cancel,&
this.cb_do_it,&
this.st_carton_count,&
this.sle_from_serial_count,&
this.sle_from,&
this.st_sscc,&
this.st_section_title,&
this.st_2,&
this.gb_1,&
this.gb_2}
end on

on u_adjust_carton_merge.destroy
destroy(this.cb_print)
destroy(this.st_3)
destroy(this.sle_serials_scanned)
destroy(this.sle_to_serial_count)
destroy(this.st_1)
destroy(this.lb_serial_list)
destroy(this.st_sscc_or_carton)
destroy(this.sle_to)
destroy(this.cb_cancel)
destroy(this.cb_do_it)
destroy(this.st_carton_count)
destroy(this.sle_from_serial_count)
destroy(this.sle_from)
destroy(this.st_sscc)
destroy(this.st_section_title)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event constructor;iw_parent = message.PowerObjectParm	
iw_parent.title = "Carton Adjust"
this.PostEvent("ue_post_open")
end event

type cb_print from commandbutton within u_adjust_carton_merge
integer x = 1550
integer y = 1828
integer width = 530
integer height = 92
integer taborder = 30
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

type st_3 from statictext within u_adjust_carton_merge
integer x = 402
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

type sle_serials_scanned from singlelineedit within u_adjust_carton_merge
integer x = 1001
integer y = 1708
integer width = 274
integer height = 64
integer taborder = 20
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

type sle_to_serial_count from singlelineedit within u_adjust_carton_merge
integer x = 1687
integer y = 448
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

type st_1 from statictext within u_adjust_carton_merge
integer x = 1472
integer y = 368
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
string text = "Serial Count"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type lb_serial_list from listbox within u_adjust_carton_merge
integer x = 407
integer y = 696
integer width = 1312
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

type st_sscc_or_carton from statictext within u_adjust_carton_merge
integer x = 46
integer y = 268
integer width = 274
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
string text = "Carton ID / Serial No:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_to from singlelineedit within u_adjust_carton_merge
integer x = 1403
integer y = 264
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

event modified;this.text = Trim(this.text)

if Len(this.text) > 0 then
	lb_serial_list.Reset()
	sle_to_serial_count.text = "0"

// TAM 2018/02 - S14838 Store the Carton Serial numbers are moving to
//	is_carton_id = Trim(this.text)
	is_carton_id_new = Trim(this.text)
//	iw_parent.in_parms.is_carton_id = is_carton_id
	iw_parent.in_parms.is_carton_id_new = is_carton_id_new
	
	// Get serial count for Carton ID and store pallet_id for later use
	long ll_row_count
	boolean lb_is_sscc_nr, lb_is_container_id

//TAM 2018/01 - s14838 - use serial_inventory instead of carton_serial
//	select count(*), max(pallet_id)
//	into :ll_row_count, :is_pallet_id
//	from carton_serial with (NOLOCK)
//	where project_id = :gs_project
//	and sku = :iw_parent.in_parms.is_sku
//	and carton_id = :is_carton_id;

	select count(*), max(po_no2)
	into :ll_row_count, :is_pallet_id
	from serial_number_inventory with (NOLOCK)
	where project_id = :gs_project
	and sku = :iw_parent.in_parms.is_sku
	and carton_id = :this.text;

	if ll_row_count > 0 then
		sle_to_serial_count.text = String(ll_row_count)
	elseif ll_row_count = 0 then
		MessageBox(iw_parent.title, "No inventory found for the following parameters: ~r~r" + iw_parent.in_parms.of_get_parms_display())
		SetFocus(sle_to)
	else
		MessageBox(iw_parent.title, "Error retrieving inventory for the following parameters:  ~r~r" + iw_parent.in_parms.of_get_parms_display())	
		SetFocus(sle_to)
	end if
end if

end event

type cb_cancel from commandbutton within u_adjust_carton_merge
integer x = 1065
integer y = 1828
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

type cb_do_it from commandbutton within u_adjust_carton_merge
integer x = 562
integer y = 1828
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

if Len(Trim(sle_to.text)) > 0 and lb_serial_list.TotalItems() > 0 then

	if MessageBox(iw_parent.title, "Are you sure you want to merge Carton: " + Trim(sle_to.text) + "?",question!, yesno!) = 1 then
	
//		String ls_carton
//		
//		iw_parent.in_parms.is_sscc_nr = Trim(sle_to.text)
//			
//		// Next, set the pallet list to send back to the Stock Adjustment Window
//		iw_parent.in_parms.ids_content_rs.Reset()
//		int j
//		long ll_row
//		for j = 1 to lb_serial_list.TotalItems()
//			if j = 1 then
//				iw_parent.in_parms.ib_some_cartons_broken = true		
//			end if
//
//			ls_carton = lb_serial_list.Text(j)	
//			ll_row = iw_parent.in_parms.ids_content_rs.InsertRow(0)
//			iw_parent.in_parms.ids_content_rs.Object.carton_id[ll_row] = ls_carton
//		next
//		
//		iw_parent.in_parms.is_sscc_nr_new = sle_to.text		// Used by Stock Adjust Create Window to set carton_serial.pallet_id's 
//
//		iw_parent.in_parms.of_set_status()
//		iw_parent.TriggerEvent("ue_closing")
//		
		
		iw_parent.in_parms.of_set_serial_in_string_merge(lb_serial_list)
		iw_parent.in_parms.is_sscc_nr = is_pallet_id

		iw_parent.in_parms.of_set_status()
		iw_parent.TriggerEvent("ue_closing")

	end if	
else	
	MessageBox(iw_parent.title, "Please enter a Carton ID and then scan serial numbers and or Carton IDs.")
	if Len(Trim(sle_to.text)) = 0 then 
		sle_to.SetFocus()
	elseif lb_serial_list.TotalItems() = 0 then 
			sle_from.SetFocus()
	end if
end if

end event

event constructor;g.of_check_label_button(this)
end event

type st_carton_count from statictext within u_adjust_carton_merge
integer x = 389
integer y = 368
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
string text = "Serial Count"
alignment alignment = center!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type sle_from_serial_count from singlelineedit within u_adjust_carton_merge
integer x = 603
integer y = 448
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

type sle_from from singlelineedit within u_adjust_carton_merge
integer x = 334
integer y = 264
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
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.SelectText(1, Len(this.text))
end event

event modified;Long llScanCount

this.text = Trim(this.text)


if Len(Trim(sle_to.text)) = 0 then
	MessageBox(iw_parent.title, "Please enter a To: Carton ID first.", Exclamation!)
	sle_to.SetFocus()
	return
end if

if Upper(this.text) = Upper(Trim(sle_to.text)) then
	MessageBox(iw_parent.title, "To: From: Carton IDs must not match.", Exclamation!)	
	sle_from.SetFocus()
	return
end if

//// Determine if a valid SSCC# or Carton ID was entered
//long ll_row_count
//boolean lb_is_sscc_nr, lb_is_container_id
//select count(*)
//into :ll_row_count
//from content with (NOLOCK)
//where project_id = :gs_project
//and sku = :iw_parent.in_parms.is_sku
//and po_no2 = :this.text;
//
//if sqlca.sqlcode = 0 and ll_row_count > 0 then
//	lb_is_sscc_nr = true
//	sle_from_serial_count.text = String(ll_row_count)
//else


// Determine if a Carton ID or a serial number was entered
String ls_from_pallet_id
long ll_row_count
boolean lb_is_serial_no, lb_is_container_id
long ll_content_qty
//datastore lds_carton_serial
//lds_carton_serial = Create datastore
//lds_carton_serial.Dataobject = 'd_content_pallet_adjust'
//lds_carton_serial.SetTransObject(sqlca)
//
//ll_row_count = lds_carton_serial.Retrieve(gs_project, iw_parent.in_parms.is_sku, this.text)

ll_row_count = iw_parent.in_parms.ids_carton_serial.Retrieve(gs_project, this.text)

if ll_row_count > 0 then
	lb_is_container_id = true
	sle_from_serial_count.text = String(ll_row_count)
	
	long i
	for i = 1 to ll_row_count
		//TimA 12/02/14 added a count to the screen.
		llScanCount = Long(sle_serials_scanned.text)
		lb_serial_list.AddItem(iw_parent.in_parms.ids_carton_serial.Object.serial_no[i])
		llScanCount = llScanCount + 1
		sle_serials_scanned.text = String(llScanCount)
		This.setfocus( )		
//		if iw_parent.in_parms.ids_carton_serial.Object.pallet_id[i] <> is_pallet_id then
			iw_parent.in_parms.of_add_pallet_from_merge(iw_parent.in_parms.ids_carton_serial.Object.pallet_id[i], is_pallet_id, 1)
//		end if
	next

	iw_parent.in_parms.of_add_carton(this.text) //09-JULY-2018 :Madhu DE4725 - Store the carton No.
	this.text = ""
	sle_from.setFocus()
else

	select count(*), max(pallet_id)
	into :ll_row_count, :ls_from_pallet_id
	from carton_serial with (NOLOCK)
	where project_id = :gs_project
	and sku = :iw_parent.in_parms.is_sku
	and serial_no = :this.text
	and status_cd <> 'D';

	if sqlca.sqlcode = 0 and ll_row_count > 0 then
		lb_is_serial_no = true
		sle_from_serial_count.text = "1"
		//ll_content_qty = ll_row_count
		llScanCount = Long(sle_serials_scanned.text)
		lb_serial_list.AddItem(this.text)
		llScanCount = llScanCount + 1
		sle_serials_scanned.text = String(llScanCount)
		This.setfocus( )
		iw_parent.in_parms.of_add_pallet_from_merge(ls_from_pallet_id, is_pallet_id, 1)
	end if
//TAM 2018/02 S14838 - Store the Carton that is moving
	iw_parent.in_parms.of_add_carton(this.text)
	this.text = ""
	sle_from.setFocus()
end if


if NOT lb_is_serial_no and NOT lb_is_container_id then
	MessageBox(iw_parent.title, "Number entered is neither a Carton ID nor a Serial Number.", Exclamation!)
	sle_from.SetFocus()
	return
end if

end event

type st_sscc from statictext within u_adjust_carton_merge
integer x = 1125
integer y = 268
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
string text = "Carton ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_section_title from statictext within u_adjust_carton_merge
integer x = 14
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
string text = "Merge a Carton"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;//
end event

type st_2 from statictext within u_adjust_carton_merge
integer x = 667
integer y = 620
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

type gb_1 from groupbox within u_adjust_carton_merge
integer x = 18
integer y = 148
integer width = 1038
integer height = 404
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From"
end type

type gb_2 from groupbox within u_adjust_carton_merge
integer x = 1097
integer y = 152
integer width = 1038
integer height = 404
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To"
end type

