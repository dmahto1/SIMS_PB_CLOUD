$PBExportHeader$w_pallet_do_label.srw
$PBExportComments$Print Pallet labels with Delivery Order Information
forward
global type w_pallet_do_label from w_main_ancestor
end type
type cb_label_print from commandbutton within w_pallet_do_label
end type
type dw_label from u_dw_ancestor within w_pallet_do_label
end type
type cb_label_selectall from commandbutton within w_pallet_do_label
end type
type cb_label_clear from commandbutton within w_pallet_do_label
end type
type cbx_hide_gpn from checkbox within w_pallet_do_label
end type
end forward

global type w_pallet_do_label from w_main_ancestor
integer width = 2377
integer height = 1500
string title = "Delivery Order Barcode Label"
event ue_print ( )
cb_label_print cb_label_print
dw_label dw_label
cb_label_selectall cb_label_selectall
cb_label_clear cb_label_clear
cbx_hide_gpn cbx_hide_gpn
end type
global w_pallet_do_label w_pallet_do_label

type variables
String	isDONO
String   isInvoiceNo
String   isGPN
String   isClientCustPoNbr
n_labels invo_labels

end variables

event ue_print();Str_Parms	lstrparms
Long			llRowCount, llRowPos 
Any			lsAny

Dw_Label.AcceptText()

OpenWithParm( w_label_print_options, lStrParms)
Lstrparms = Message.PowerObjectParm		  

If lstrParms.Cancelled Then Return 

//We need the distinct carton count for "box x of y" count - we may have more than 1 row per packing

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
  
	LstrParms.String_arg[1] = isInvoiceNo		// use the Invoice No - not the DO_No
	lstrparms.date_arg[1] = today()

	// LTK  20150521  Incorporate the "Hide GPN" checkbox
	if NOT cbx_hide_gpn.checked then
		// ET3 2013-02-05 Pandora 570 - add GPN of row 1 to label
		LstrParms.string_arg[2] = isGPN
	end if

//TAM 216/08/16 Added new field for Pandora- *Note DONO = DONO
	LstrParms.String_arg[3] = isDoNo		
	LstrParms.String_arg[4] = isClientCustPoNbr		

	invo_labels.uf_pallet_do_info(lstrparms)

Next /*detail row to Print*/

end event

on w_pallet_do_label.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.dw_label=create dw_label
this.cb_label_selectall=create cb_label_selectall
this.cb_label_clear=create cb_label_clear
this.cbx_hide_gpn=create cbx_hide_gpn
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_label_selectall
this.Control[iCurrent+4]=this.cb_label_clear
this.Control[iCurrent+5]=this.cbx_hide_gpn
end on

on w_pallet_do_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.dw_label)
destroy(this.cb_label_selectall)
destroy(this.cb_label_clear)
destroy(this.cbx_hide_gpn)
end on

event ue_postopen;call super::ue_postopen;LONG lRow = 0

invo_labels = Create n_labels

//TAM 216/08/16 - Pandora uses a different DW with new field for Pandora 
if Upper( gs_project ) = 'PANDORA' then
	dw_label.dataobject = 'd_pandora_pallet_do_label'
	dw_label.settransobject( sqlca )
end if


//We can only print based on DO_NO - User must have valid order open to pass DO_NO in from w_DO
If isVAlid(w_do) Then
	if w_do.idw_main.RowCOunt() > 0 Then
		isDoNo 		= w_do.idw_main.GetITemString(1,'do_no')
		isInvoiceNo = w_do.idw_main.GetItemString(1,'invoice_no')
		isClientCustPoNbr = w_do.idw_main.GetItemString(1,'client_cust_po_nbr')  //TAM 216/08/16 Added new field for Pandora
		IF w_do.idw_detail.rowcount() > 0 THEN 
			isGPN    = w_do.idw_detail.GetItemString(1, 'sku')
		ELSE
			isGPN = 'not specified'
		END IF
		
	End If
End If

If isNUll(isDONO) or  isDoNO = '' Then
	Messagebox('Labels','You must have an order retrieved in the Delivery Order Window~rbefore you can print labels!')
Else
	// note: customer actually wants the invoice number
	lRow = this.dw_label.Insertrow( 0 )
	dw_label.setitem( lRow, 'DO_NO', isInvoiceNo )
	dw_label.setitem( lRow, 'DO_NO_BC', isInvoiceNo )
	dw_label.setitem( lRow, 'PRINT_DATE', today() )
	dw_label.setitem( lRow, 'GPN', isGPN )
//TAM 216/08/16 Added new field for Pandora- *Note DONO = DONO
	if Upper( gs_project ) = 'PANDORA' then
		dw_label.setitem( lRow, 'DO_NO', isDoNo )
		dw_label.setitem( lRow, 'DO_NO_BC', isDoNo )
		dw_label.setitem( lRow, 'INVOICE_NO', isInvoiceNo )
		dw_label.setitem( lRow, 'INVOICE_NO_BC', isInvoiceNo )
		dw_label.setitem( lRow, 'CLIENT_CUST_PO_NBR', isClientCustPoNbr )
		dw_label.setitem( lRow, 'CLIENT_CUST_PO_NBR_BC', isClientCustPoNbr )
	End If
	
	
End If

cb_label_print.Enabled = TRUE


end event

event ue_retrieve;call super::ue_retrieve;//String	lsDONO,	&
//			lsCartonNo
//
//Long		llRowCount,	&
//			llRowPos
//
//
//cb_label_print.Enabled = False
//
//If isdono > '' Then
//	dw_label.Retrieve(gs_project,isdono)
//End If
//
////BCR 07-SEP-2011: RUN-WORLD saves a 0 carton number row into Delivery_Packing. Need to filter it out.
//IF gs_project  = 'RUN-WORLD' THEN
//	dw_label.SetFilter("delivery_packing_carton_no > '0'")       
//	dw_label.Filter()
//END IF
//
//If dw_label.RowCOunt() > 0 Then
//Else
//	Messagebox('Labels','Order Not found!')
//	Return
//End If
//
//lsDoNo = dw_label.GetITemString(1,'delivery_Master_DO_NO')
//
////Default the Label Format and Starting Carton Number
//llRowCount = dw_label.RowCount()
//
//
////cb_print.Enabled = True
//
//// 12/03 - PCONKL - WE need the Project level UCCS Company prefix and the Warehouse level prefix
//Select ucc_Company_Prefix into :isuccscompanyprefix
//FRom Project
//Where Project_ID = :gs_Project;
//
//SElect ucc_location_Prefix into :isuccswhprefix
//From Warehouse
//Where wh_Code = (select wh_Code from Delivery_MASter where Project_ID = :gs_Project and do_no = :isdono);
//
//
end event

event ue_selectall;call super::ue_selectall;//Long	llRowPos,	&
//		llRowCount
//
//		
//dw_label.SetRedraw(False)
//
//llRowCount = dw_label.RowCount()
//For llRowPos = 1 to llRowCount
//	dw_label.SetITem(llRowPos,'c_print_ind','Y')
//Next
//
//dw_label.SetRedraw(True)
//
//cb_label_print.Enabled = True
//
end event

event ue_unselectall;call super::ue_unselectall;//Long	llRowPos,	&
//		llRowCount
//
//		
//dw_label.SetRedraw(False)
//
//llRowCount = dw_label.RowCount()
//For llRowPos = 1 to llRowCount
//	dw_label.SetITem(llRowPos,'c_print_ind','N')
//Next
//
//dw_label.SetRedraw(True)
//
//cb_label_print.Enabled = False
//
end event

event resize;call super::resize;//dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
dw_label.Resize(workspacewidth() - 174,workspaceHeight()-344)		// LTK 20150521  Reset size and added "Hide GPN" checkbox
cbx_hide_gpn.y = workspaceHeight() - 88
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pallet_do_label
boolean visible = false
integer x = 1792
integer y = 24
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_pallet_do_label
integer x = 1371
integer y = 24
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_pallet_do_label
integer x = 946
integer y = 24
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

event constructor;
g.of_check_label_button(this)
end event

type dw_label from u_dw_ancestor within w_pallet_do_label
integer x = 9
integer y = 180
integer width = 2167
integer height = 976
boolean bringtotop = true
string dataobject = "d_pallet_do_label"
boolean livescroll = false
end type

event retrieveend;call super::retrieveend;//As this is compute column needs to be assigned value 
// DGM 09/22/03
integer i
FOR i = 1 TO rowcount
 This.object.c_qty_per_carton[i]=1
NEXT


end event

event itemchanged;call super::itemchanged;
If upper(dwo.Name) = 'C_PRINT_IND' and data = 'Y' Then cb_label_print.Enabled = True
end event

type cb_label_selectall from commandbutton within w_pallet_do_label
boolean visible = false
integer x = 32
integer y = 24
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

event constructor;
g.of_check_label_button(this)
end event

type cb_label_clear from commandbutton within w_pallet_do_label
boolean visible = false
integer x = 393
integer y = 24
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

event constructor;
g.of_check_label_button(this)
end event

type cbx_hide_gpn from checkbox within w_pallet_do_label
integer x = 18
integer y = 1220
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide GPN"
end type

event clicked;if this.checked then
	dw_Label.Object.gpn.visible = FALSE
	dw_Label.Object.t_1.visible = FALSE	
else
	dw_Label.Object.gpn.visible = TRUE
	dw_Label.Object.t_1.visible = TRUE
end if

end event

