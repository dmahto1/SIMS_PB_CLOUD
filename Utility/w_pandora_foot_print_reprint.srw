HA$PBExportHeader$w_pandora_foot_print_reprint.srw
$PBExportComments$+ Foot Print Re Print Labels.
forward
global type w_pandora_foot_print_reprint from window
end type
type dw_label from datawindow within w_pandora_foot_print_reprint
end type
type cb_close from commandbutton within w_pandora_foot_print_reprint
end type
type cb_print from commandbutton within w_pandora_foot_print_reprint
end type
type st_1 from statictext within w_pandora_foot_print_reprint
end type
type tab_1 from tab within w_pandora_foot_print_reprint
end type
type tab_1 from tab within w_pandora_foot_print_reprint
end type
end forward

global type w_pandora_foot_print_reprint from window
integer width = 3072
integer height = 1924
boolean titlebar = true
string title = "Foot Print Label"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_label dw_label
cb_close cb_close
cb_print cb_print
st_1 st_1
tab_1 tab_1
end type
global w_pandora_foot_print_reprint w_pandora_foot_print_reprint

on w_pandora_foot_print_reprint.create
this.dw_label=create dw_label
this.cb_close=create cb_close
this.cb_print=create cb_print
this.st_1=create st_1
this.tab_1=create tab_1
this.Control[]={this.dw_label,&
this.cb_close,&
this.cb_print,&
this.st_1,&
this.tab_1}
end on

on w_pandora_foot_print_reprint.destroy
destroy(this.dw_label)
destroy(this.cb_close)
destroy(this.cb_print)
destroy(this.st_1)
destroy(this.tab_1)
end on

event open;datawindowchild ldwc_Warehouse

dw_label.InsertRow(0)

dw_label.GetChild ( "warehouse_code", ldwc_Warehouse )
ldwc_Warehouse.SetTransObject ( SQLCA )
ldwc_Warehouse.Retrieve ( )
end event

type dw_label from datawindow within w_pandora_foot_print_reprint
integer x = 9
integer y = 212
integer width = 3017
integer height = 832
integer taborder = 20
string dataobject = "d_pandora_foot_print_label"
boolean livescroll = true
borderstyle borderstyle = StyleLowered!
end type

type cb_close from commandbutton within w_pandora_foot_print_reprint
integer x = 1902
integer y = 1056
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(Parent)
end event

type cb_print from commandbutton within w_pandora_foot_print_reprint
integer x = 1330
integer y = 1056
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode
string 	 ls_wh_code, ls_pallet_Id, ls_container_Id, ls_sscc, ls_label_carton_Id
string		lsFormat, lsLabel, lsCurrentLabel, lsLabelPrint, lsLabelRePrint, ls_sql, ls_errors, ls_msg, ls_label_text, ls_max_limit
long		llPrintCount, llPrintPos, llPrintJob, ll_return, ll_Row_count, ll_row, ll_max_limit
str_parms lStrParms, lstr_serial_parm, lstr_empty_parm, ls_str_serial_label_parm

Datastore lds_serial
n_labels lu_labels
n_labels_pandora	lu_labels_pandora

lds_serial = create Datastore
lu_labels = Create n_labels
lu_labels_pandora = Create n_labels_pandora

dw_label.AcceptText()

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

//PalletId /Box Id  - At lease one value must be present
ls_pallet_Id = dw_label.getItemString( 1, "pallet_Id") //Po No2
ls_container_Id = dw_label.getItemString( 1, "container_id") //Container Id

IF (IsNull(ls_pallet_Id) or ls_pallet_Id ='' or ls_pallet_Id=' ' )  &
	and (IsNull(ls_container_Id) or ls_container_Id ='' or ls_container_Id=' ') THEN
		MessageBox ("Unable to print Foot Print label", "Container Id or Pallet Id value should be present.!")
		dw_label.SetColumn("container_id")
		dw_label.SetFocus()
		RETURN -1
END IF

ls_wh_code =dw_label.GetItemString(1, "warehouse_code")

IF IsNull(ls_wh_code) THEN
	MessageBox ("Unable to print Foot Print label", "Please select Warehouse.!")
	dw_label.SetColumn("warehouse_code")
	dw_label.SetFocus()
	RETURN -1
END IF

//get Serial No's from Serial Number Inventory Table.
ls_sql =" select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"'  and wh_code ='"+ls_wh_code +"' "
If (not isnull(ls_pallet_Id) and len(ls_pallet_Id) > 0) Then ls_sql += " and Po_No2 = '" + ls_pallet_Id + "' "
If (not isnull(ls_container_Id) and len(ls_container_Id) > 0) Then ls_sql += " and Carton_Id = '" + ls_container_Id + "'"

//create runtime datastore
lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
ll_Row_count = lds_serial.retrieve( )

IF len(ls_errors) > 0 THEN
	MessageBox("Foot Print Label 2D Barcode Reprint","Unable to retrieve Serial Number Inventory records!")
	Return -1
END IF

IF ll_Row_count = 0 THEN
	ls_msg = " Serial No Records are not available against  Wh_Code # " +nz(ls_wh_code, '-') + " , Pallet Id# "+ nz(ls_pallet_Id ,'-') +" , Container Id# "+nz(ls_container_Id, '-')
	MessageBox("Foot Print Label 2D Barcode Reprint", ls_msg)
	Return -1
END IF

//loop through serial no records
For ll_row =1 to ll_Row_count
	lstr_serial_parm.String_arg[ll_row] = lds_serial.getItemString( ll_row, 'serial_no')
Next

//split serial No's into multiple labels.
ls_str_serial_label_parm = lu_labels_pandora.uf_split_serialno_by_length( lstr_serial_parm,  ll_max_limit)

ll_Row_count = UpperBound(ls_str_serial_label_parm.String_arg[])

//generate SSCC No.
IF (not isnull(ls_pallet_Id) and len(ls_pallet_Id) > 0) Then
	ls_label_text = 'PALLET LABEL'
	ls_label_carton_Id = ls_pallet_Id
	ls_sscc = lu_labels_pandora.uf_generate_sscc(ls_pallet_Id)
else
	ls_label_text = 'CARTON LABEL'
	ls_label_carton_Id = ls_container_Id
	ls_sscc = lu_labels_pandora.uf_generate_sscc(ls_container_Id)
End IF

//load current label from the template
lsFormat = "Pandora_QR_Barcode_Label_200_DPI.txt"
lsLabel = lu_labels.uf_read_label_Format(lsFormat)
If lsLabel = "" Then Return -1

For ll_row =1 to ll_Row_count
	lsCurrentLabel= lsLabel
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~label_name~~", ls_label_text)
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"_7eserial_5fno_7e", ls_str_serial_label_parm.String_arg[ll_row])
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~pallet_id~~", ls_pallet_Id)

	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~print_x_of_y~~", string(ll_row) + ' OF ' + string(ll_Row_count))
	lsLabelPrint += lsCurrentLabel
Next

lsLabelRePrint =lsLabelPrint

//Print Label
lu_labels_pandora.uf_print_label_data( 'Pandora Pallet/Carton (2D) Label ', lsLabelRePrint)

Destroy lds_serial
Destroy lu_labels
Destroy lu_labels_pandora
end event

type st_1 from statictext within w_pandora_foot_print_reprint
integer x = 210
integer y = 124
integer width = 1710
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217857
long backcolor = 67108864
string text = "Foot Print Labels - RePrint"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_1 from tab within w_pandora_foot_print_reprint
integer width = 3040
integer height = 1816
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
end type

