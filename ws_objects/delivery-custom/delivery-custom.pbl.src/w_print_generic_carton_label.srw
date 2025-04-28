$PBExportHeader$w_print_generic_carton_label.srw
$PBExportComments$+ Print Generic Carton Label
forward
global type w_print_generic_carton_label from window
end type
type cb_cancel from commandbutton within w_print_generic_carton_label
end type
type st_1 from statictext within w_print_generic_carton_label
end type
type cb_print from commandbutton within w_print_generic_carton_label
end type
type sle_label from singlelineedit within w_print_generic_carton_label
end type
type st_text from statictext within w_print_generic_carton_label
end type
end forward

global type w_print_generic_carton_label from window
integer width = 2025
integer height = 828
boolean titlebar = true
string title = "Carton Label"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
st_1 st_1
cb_print cb_print
sle_label sle_label
st_text st_text
end type
global w_print_generic_carton_label w_print_generic_carton_label

type variables
Datawindow idw_main
end variables

forward prototypes
public subroutine wf_prepare_label_data ()
end prototypes

public subroutine wf_prepare_label_data ();//26-MAR-2018 :Madhu Rema -Update process for printing pallet labels

Str_Parms	lstrparms
Any ls_Any
string  ls_no_of_labels, lsCityStateZip, ls_wh_code, ls_uccs_wh_prefix, ls_uccs_company_prefix
string  ls_wh_name, ls_wh_addr1, ls_wh_addr2, ls_wh_addr3, ls_wh_addr4, ls_wh_city, ls_wh_state, ls_wh_zip
long ll_no_of_labels, ll_seq_No, ll_row


n_labels	lnvo_labels
lnvo_labels =create n_labels

ls_no_of_labels =sle_label.text
ll_no_of_labels = long(ls_no_of_labels)

//select printer
OpenWithParm(w_label_print_options, lstrparms)
lstrparms = Message.PowerObjectParm		  
If lstrparms.Cancelled Then Return

//shipFrom
ls_wh_code = idw_main.getItemString(1,'wh_code')

select WH_Name, Address_1, Address_2, Address_3, Address_4, City, State, Zip , UCC_Location_Prefix
	into :ls_wh_name, :ls_wh_addr1, :ls_wh_addr2, :ls_wh_addr3, :ls_wh_addr4, :ls_wh_city, :ls_wh_state, :ls_wh_zip, :ls_uccs_wh_prefix
from Warehouse with(nolock) where wh_code= :ls_wh_code
using sqlca;

select UCC_Company_Prefix into :ls_uccs_company_prefix
from Project with(nolock) where Project_Id = :gs_project
using sqlca;

For ll_row =1 to ll_no_of_labels
	lstrparms.String_arg[2] = ls_wh_name
	lstrparms.String_arg[3] = ls_wh_addr1
	lstrparms.String_arg[4] = ls_wh_addr2
	lstrparms.String_arg[5] = ls_wh_addr3
	lstrparms.String_arg[31] = ls_wh_addr4
	
	//Compute FROM City,State & Zip
	lsCityStateZip = ''
	If Not isnull(ls_wh_city) Then lsCityStateZip = ls_wh_city + ', '
	If Not isnull(ls_wh_state) Then lsCityStateZip += ls_wh_state + ' '
	If Not isnull(ls_wh_zip) Then lsCityStateZip += ls_wh_zip + ' '
	lstrparms.String_arg[6] = lsCityStateZip
	
	//shipTo
	lstrparms.String_arg[7] = idw_main.getItemString(1,'Cust_Name')
	lstrparms.String_arg[8] = idw_main.getItemString(1,'Address_1')
	lstrparms.String_arg[9] = idw_main.getItemString(1,'Address_2')
	lstrparms.String_arg[10] = idw_main.getItemString(1,'Address_3')
	lstrparms.String_arg[32] = idw_main.getItemString(1,'Address_4')
	lstrparms.String_arg[33] = idw_main.getItemString(1,'Zip')
	
	//Compute TO City,State & Zip
	lsCityStateZip = ''
	If Not isnull(idw_main.getItemString(1,'City')) Then lsCityStateZip = idw_main.getItemString(1,'City') + ', '
	If Not isnull(idw_main.getItemString(1,'State')) Then lsCityStateZip += idw_main.getItemString(1,'State') + ' '
	If Not isnull(idw_main.getItemString(1,'Zip')) Then lsCityStateZip += idw_main.getItemString(1,'Zip') + ' '
	lstrparms.String_arg[11] = lsCityStateZip
	
	ll_seq_No++
	lstrparms.String_arg[12] = Right(idw_main.getItemString(1, 'DO_No'), 6) + string(ll_seq_No, '000') //carton No
	lstrparms.String_arg[13] = idw_main.getItemString(1,'Client_Cust_Po_Nbr') //Po No
	lstrparms.String_arg[25] = idw_main.getItemString(1, 'Carrier') //carrier
	
	lstrparms.String_arg[27] = idw_main.getItemString(1, 'Do_No') //carrier
	
	lstrparms.String_arg[17] = idw_main.getItemString(1, 'Invoice_No') //Invoice No
	lstrparms.String_arg[21] = idw_main.getItemString(1, 'DO_No') //Do No
	lstrparms.String_arg[34] = idw_main.getItemString(1, 'AWB_BOL_No') //Awb Bol No
	
	lstrparms.datetime_arg[1] = idw_main.getItemDateTime(1, 'request_date')
	
	// We need to pass the UCCS Prefix (Location + Company)
	lstrparms.String_arg[35] = ls_uccs_wh_prefix + ls_uccs_company_prefix
	
	ls_Any = lstrparms
	lnvo_labels.uf_generic_uccs_zebra(ls_Any)
Next

Return
end subroutine

on w_print_generic_carton_label.create
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.cb_print=create cb_print
this.sle_label=create sle_label
this.st_text=create st_text
this.Control[]={this.cb_cancel,&
this.st_1,&
this.cb_print,&
this.sle_label,&
this.st_text}
end on

on w_print_generic_carton_label.destroy
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.cb_print)
destroy(this.sle_label)
destroy(this.st_text)
end on

event open;//26-MAR-2018 :Madhu Rema -Update process for printing pallet labels

idw_main = Message.powerobjectparm //get idw_main
end event

event close;close(this)
end event

type cb_cancel from commandbutton within w_print_generic_carton_label
integer x = 1367
integer y = 576
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;Parent.triggerevent( "close")
end event

type st_1 from statictext within w_print_generic_carton_label
integer x = 306
integer y = 76
integer width = 1097
integer height = 160
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Carton Label"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_print from commandbutton within w_print_generic_carton_label
integer x = 809
integer y = 576
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//26-MAR-2018 :Madhu  Rema - Update process for printing pallet labels

//prepare Label Printing Data
wf_prepare_label_data()

//close the screen
Parent.triggerevent( "close")
end event

type sle_label from singlelineedit within w_print_generic_carton_label
integer x = 1056
integer y = 320
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_text from statictext within w_print_generic_carton_label
integer x = 123
integer y = 320
integer width = 869
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Number of labels to print"
boolean focusrectangle = false
end type

