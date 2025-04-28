HA$PBExportHeader$w_pandora_part_label_print_reprint.srw
forward
global type w_pandora_part_label_print_reprint from window
end type
type cbx_2d_barcode from checkbox within w_pandora_part_label_print_reprint
end type
type st_single_part_label from statictext within w_pandora_part_label_print_reprint
end type
type st_parent_child from statictext within w_pandora_part_label_print_reprint
end type
type cb_print_bom_specific_serial_labels from commandbutton within w_pandora_part_label_print_reprint
end type
type cb_close from commandbutton within w_pandora_part_label_print_reprint
end type
type cb_ok from commandbutton within w_pandora_part_label_print_reprint
end type
type dw_pandora_part_label_print from datawindow within w_pandora_part_label_print_reprint
end type
type dw_print_bom_specific_serial_labels from u_dw_ancestor within w_pandora_part_label_print_reprint
end type
end forward

global type w_pandora_part_label_print_reprint from window
integer width = 3250
integer height = 1904
boolean titlebar = true
string title = "Part Label Print - Reprint"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cbx_2d_barcode cbx_2d_barcode
st_single_part_label st_single_part_label
st_parent_child st_parent_child
cb_print_bom_specific_serial_labels cb_print_bom_specific_serial_labels
cb_close cb_close
cb_ok cb_ok
dw_pandora_part_label_print dw_pandora_part_label_print
dw_print_bom_specific_serial_labels dw_print_bom_specific_serial_labels
end type
global w_pandora_part_label_print_reprint w_pandora_part_label_print_reprint

type variables

Str_parms	istrparms

DatawindowChild idwc_Customer
//TimA 04/09/13 Pandora issue #560
//New DDW Child for COO
Datawindowchild idwc_Coo
end variables

event open;
//datawindowchild ldw_child, &
datawindowchild ldwc_Warehouse

If gs_project ='PANDORA' Then
	cb_print_bom_specific_serial_labels.visible = TRUE
	dw_pandora_part_label_print.Modify ( "parent_bom_serial_number.visible 		= TRUE" )
	dw_pandora_part_label_print.Modify ( "t_parent_bom_serial_number.visible 	= TRUE" )
	
	dw_pandora_part_label_print.height 				= 1488
	cb_close.y								    				= 1580
	cb_print_bom_specific_serial_labels.visible		= TRUE
	cb_print_bom_specific_serial_labels.x  			= 1133
	cb_print_bom_specific_serial_labels.y  			= 1550
	w_pandora_part_label_print_reprint.height 		= 1994
	st_parent_child.visible								= TRUE
	st_single_part_label.visible							= TRUE
	st_parent_child.y										=1728
	
Else

	dw_pandora_part_label_print.height 				= 956
	cb_print_bom_specific_serial_labels.visible		= FALSE
	cb_print_bom_specific_serial_labels.x  			= 1970
	cb_print_bom_specific_serial_labels.y  			= 1076
	cb_close.y								   				= 1076
	w_pandora_part_label_print_reprint.height 		= 1228
	st_parent_child.visible								= FALSE
	st_single_part_label.visible							= FALSE
	
End If

dw_pandora_part_label_print.InsertRow(0)


dw_pandora_part_label_print.SetItem( 1, "number_labels", 1)

//TimA 04/09/13 Pandora issue #560  use instance varable
//dw_pandora_part_label_print.GetChild( "coo", ldw_child)
dw_pandora_part_label_print.GetChild( "coo", idwc_Coo)
dw_pandora_part_label_print.GetChild ( "warehouse_code", ldwc_Warehouse )
dw_pandora_part_label_print.GetChild ( "customer_code", idwc_Customer )

idwc_Coo.SetTransObject(SQLCA)
//ldw_child.SetTransObject(SQLCA)
ldwc_Warehouse.SetTransObject ( SQLCA )
idwc_Customer.SetTransObject ( SQLCA )

//TimA 04/09/13 pandora issue #560 the retrieve is now on the Itemchanged event
//ldw_child.Retrieve() 
ldwc_Warehouse.Retrieve ( )
 
//istrparms = message.PowerObjectParm
//
//
//
//if len(istrparms.String_arg[40]) > 0 then
//	st_sku.text = istrparms.String_arg[40]
//end if
//
//
//if istrparms.Long_arg[10] > 0 then
//	sle_qty.text = string(istrparms.Long_arg[10])
//end if
//
//if istrparms.Long_arg[11] > 0 then
//	sle_weight.text = string(istrparms.Long_arg[11])
//end if
//
end event

on w_pandora_part_label_print_reprint.create
this.cbx_2d_barcode=create cbx_2d_barcode
this.st_single_part_label=create st_single_part_label
this.st_parent_child=create st_parent_child
this.cb_print_bom_specific_serial_labels=create cb_print_bom_specific_serial_labels
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.dw_pandora_part_label_print=create dw_pandora_part_label_print
this.dw_print_bom_specific_serial_labels=create dw_print_bom_specific_serial_labels
this.Control[]={this.cbx_2d_barcode,&
this.st_single_part_label,&
this.st_parent_child,&
this.cb_print_bom_specific_serial_labels,&
this.cb_close,&
this.cb_ok,&
this.dw_pandora_part_label_print,&
this.dw_print_bom_specific_serial_labels}
end on

on w_pandora_part_label_print_reprint.destroy
destroy(this.cbx_2d_barcode)
destroy(this.st_single_part_label)
destroy(this.st_parent_child)
destroy(this.cb_print_bom_specific_serial_labels)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.dw_pandora_part_label_print)
destroy(this.dw_print_bom_specific_serial_labels)
end on

type cbx_2d_barcode from checkbox within w_pandora_part_label_print_reprint
integer x = 1865
integer width = 1253
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Pallet/Carton (2D) Label"
end type

type st_single_part_label from statictext within w_pandora_part_label_print_reprint
integer width = 905
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Single Part Label"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_parent_child from statictext within w_pandora_part_label_print_reprint
integer y = 1692
integer width = 905
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Parent / Child Part Labels"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_print_bom_specific_serial_labels from commandbutton within w_pandora_part_label_print_reprint
boolean visible = false
integer x = 1970
integer y = 1168
integer width = 923
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print BOM Specific Serial Labels"
end type

event clicked;Str_Parms	lstrparms
n_labels_pandora	lu_labels
n_labels_pandora	lu_Child_Labels


Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, llPrintJob, llFindRow
		
Any	lsAny

String	lsFormat, 		lsFormatSave, 			lsPrinter
String	lsChildFormat, 	lsChildFormatSave, 	ls_parent_bom_serial_number

String lsLabel, 			lsLabelPrint, 		lsPrintText, 			lsCurrentLabel
String lsChildLabel,	lsChildLabelPrint,	lsChildPrintText, 	lsChildCurrentLabel

string ls_serial_no, ls_alt_sku, ls_comment, ls_lot_no, ls_box_id, ls_SKU, ls_Child_SKU

string ls_Child_SKU1,  ls_Child_SKU2,  ls_Child_SKU3,  ls_Child_SKU4 
string ls_Child_Serial_Number1,  ls_Child_Serial_Number2,  ls_Child_Serial_Number3,  ls_Child_Serial_Number4 
string ls_XOFY, ls_filter

Integer	liMsg, li_quantity, li_Number_Of_Child_Labels,  li_Child_Label_Counter, li_Number_Of_Children, li_X, li_Y, li_component_no

lu_labels 		= Create n_labels_pandora
lu_child_labels  = Create n_labels_pandora

dw_pandora_part_label_print.AcceptText()

ls_parent_bom_serial_number = dw_pandora_part_label_print.GetItemString(1,"parent_bom_serial_number")

If Not (Trim(ls_parent_bom_serial_number) = '' or IsNULL( ls_parent_bom_serial_number  )) Then

	lsFormat 		= "pandora_part_label.txt"
	lsChildFormat 	= "PANDORA_child_PART_LABEL_XOFY.txt"

	lsLabel 		= lu_Labels.uf_read_label_Format(			lsFormat)
	lsChildLabel 	= lu_Child_Labels.uf_read_label_Format(	lsChildFormat)

	If lsLabel 		= "" Then Return
	If lsChildLabel 	= "" Then Return
	
	dw_print_bom_specific_serial_labels.Retrieve( ls_parent_bom_serial_number )

	dw_print_bom_specific_serial_labels.SetFilter("component_ind = 'Y'")
	dw_print_bom_specific_serial_labels.Filter()

	//Print each detail Row
	llRowCount = dw_print_bom_specific_serial_labels.RowCount()

	If llRowCount > 0 Then

		For llRowPos = 1 to llRowCount /*each detail row */
	
			//load current label from the template (we can resuse template until format changes)
			lsCurrentLabel			= lsLabel
			lsChildCurrentLabel 	= lsChildLabel 
	
	
			ls_SKU = dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'sku')
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~",					ls_SKU) /* Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKUBARCODE~~",	ls_SKU) /* Barcoded Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~",				dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'country_of_origin')) /* Part*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~QTY~~", 				String(dw_print_bom_specific_serial_labels.GetITemNumber(llRowPos,'quantity'))) /* Part*/
			
			ls_serial_no 	=dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'serial_no')
			
			If Isnull(ls_serial_no) OR trim(ls_serial_no) = '-' THEN ls_serial_no = ''
			
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIAL~~", 				ls_serial_no) /* Serial*/
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIALBARCODE~~", 	ls_serial_no) /* Barcoded Serial*/


			li_component_no 	= 	dw_print_bom_specific_serial_labels.GetITemNumber(llRowPos,'Component_no')

			ls_alt_sku 			= 	dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'alternate_sku')
			
			If Isnull(ls_alt_sku)	THEN ls_alt_sku = ''
			
			lsCurrentLabel 		= 	lu_labels.uf_replace(lsCurrentLabel,"~~ALT_SKU~~", ls_alt_sku)

			ls_comment 		=	dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'comment')	
			If Isnull(ls_comment) THEN ls_comment = ''
			lsCurrentLabel 		= lu_labels.uf_replace(lsCurrentLabel,"~~COMMENT~~", ls_comment)	
	
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DATE~~", string(today(),'YYYY-MM-DD')) 

			ls_box_id 			= dw_print_bom_specific_serial_labels.GetITemString(llRowPos,'container_id')
			If Isnull(ls_box_id) THEN ls_box_id = ''
			lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOX_ID~~", ls_box_id)
	
			li_quantity = dw_print_bom_specific_serial_labels.GetITemNUmber(llRowPos,'Quantity')
	
			If li_quantity >= 1 Then
				lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"^PQ1,","^PQ" + string(li_quantity) + ",")
			End If

			lsLabelPrint += lsCurrentLabel		
			
			ls_filter = 'SKU <> SKU_Parent and  Component_no='+Trim(String(li_component_no))
			
			dw_print_bom_specific_serial_labels.SetFilter(ls_filter)
			dw_print_bom_specific_serial_labels.Filter()
			
			li_Number_Of_Children = dw_print_bom_specific_serial_labels.RowCount()
			
			li_Child_Label_Counter = 0
			
//			li_Y =  li_Number_Of_Children / 4
//			
//			If Mod(li_Number_Of_Children,  4 ) > 0 Then li_Y = li_Y + 1
//								
			li_Y =  li_Number_Of_Children / 3
			
			If Mod(li_Number_Of_Children,  3 ) > 0 Then li_Y = li_Y + 1

			For li_X = 1 To li_Y
				
				lsChildCurrentLabel  = lsChildLabel
				
				ls_Child_SKU1					= 	''
			 	ls_Child_Serial_Number1		= 	''			  
			 	ls_Child_SKU2					=	''
				ls_Child_Serial_Number2 	=	''				 
			 	ls_Child_SKU3 					=	''
			     ls_Child_Serial_Number3		=	''			 
			     ls_Child_SKU4					=	''
			     ls_Child_Serial_Number4		=	''
							
				li_Child_Label_Counter =  li_Child_Label_Counter + 1
						
				IF li_Child_Label_Counter <=	li_Number_Of_Children Then
				
			 		ls_Child_SKU1					= 	dw_print_bom_specific_serial_labels.GetITemString(	li_Child_Label_Counter,		'sku')
			 		ls_Child_Serial_Number1		=	dw_print_bom_specific_serial_labels.GetITemString( li_Child_Label_Counter,		'serial_no')
					 
				End If
					
				li_Child_Label_Counter =  li_Child_Label_Counter + 1
			  
				IF li_Child_Label_Counter <=	li_Number_Of_Children Then
							  
			 		ls_Child_SKU2					=	dw_print_bom_specific_serial_labels.GetITemString( li_Child_Label_Counter,	'sku')
					ls_Child_Serial_Number2 	=	dw_print_bom_specific_serial_labels.GetITemString( li_Child_Label_Counter,	'serial_no')

				End If
					
				li_Child_Label_Counter =  li_Child_Label_Counter + 1
				 
				IF li_Child_Label_Counter <=	li_Number_Of_Children Then
							  
			 	 	ls_Child_SKU3 					=	dw_print_bom_specific_serial_labels.GetITemString(li_Child_Label_Counter,	'sku')
			     	ls_Child_Serial_Number3		=	dw_print_bom_specific_serial_labels.GetITemString(li_Child_Label_Counter,	'serial_no')
					  
				End If  
					
//				li_Child_Label_Counter =  li_Child_Label_Counter + 1  
//			 
//				IF li_Child_Label_Counter <=	li_Number_Of_Children Then
//							  
//			      	ls_Child_SKU4					=	dw_print_bom_specific_serial_labels.GetITemString( li_Child_Label_Counter,	'sku')
//			      	ls_Child_Serial_Number4		=	dw_print_bom_specific_serial_labels.GetITemString( li_Child_Label_Counter,	'serial_no')
//						
//				End If  
						
				lsChildCurrentLabel 	=lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSKUTEXT~~",							ls_SKU) /* Parent Part*/
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSKUBARCODE~~",					ls_SKU) /* Parent Barcoded Part*/

				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSERIALNUMBERTEXT~~", 		ls_serial_no) /* Parent Serial*/
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~PARENTSERIALNUMBERBARCODE~~", 	ls_serial_no) /* Parent Barcoded Serial*/
					
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU1~~',								ls_Child_SKU1 ) /* Part*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE1~~", 					ls_Child_SKU1 ) /* Barcoded Part*/
			
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL1~~",							ls_Child_Serial_Number1) /* Serial*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE1~~",				ls_Child_Serial_Number1) /* Barcoded Serial*/
	
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU2~~',								ls_Child_SKU2 ) /* Part*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE2~~", 					ls_Child_SKU2 ) /* Barcoded Part*/
			
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL2~~",							ls_Child_Serial_Number2) /* Serial*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE2~~",				ls_Child_Serial_Number2) /* Barcoded Serial*/
					
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU3~~',								ls_Child_SKU3 ) /* Part*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE3~~", 					ls_Child_SKU3 ) /* Barcoded Part*/
			
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL3~~",							ls_Child_Serial_Number3) /* Serial*/
				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE3~~",				ls_Child_Serial_Number3) /* Barcoded Serial*/
					
//				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,'~~CHILDSKU4~~',					ls_Child_SKU4 ) /* Part*/
//				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel ,"~~CHILDSKUBARCODE4~~", 		ls_Child_SKU4 ) /* Barcoded Part*/
//			
//				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIAL4~~",				ls_Child_Serial_Number4) /* Serial*/
//				lsChildCurrentLabel	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~CHILDSERIALBARCODE4~~",	ls_Child_Serial_Number4) /* Barcoded Serial*/
					
				ls_XOFY = String( li_X ) + ' Of ' +String( li_Y	)	
					 
				lsChildCurrentLabel 	= lu_Child_Labels.uf_replace(lsChildCurrentLabel,"~~Box~~",								ls_XOFY )

				lsLabelPrint += lsChildCurrentLabel	
					
			Next
			
			dw_print_bom_specific_serial_labels.SetFilter("component_ind = 'Y'")
			dw_print_bom_specific_serial_labels.Filter()
			
		Next /*detail row to Print*/
		
//		Send the format to the printer...
		If lsLabelPrint > "" Then
		
			OpenWithParm(w_label_print_options,lStrParms)

			lsPrintText = 'Part Label Print - Reprint'
		
//			Open Printer File 
			llPrintJob = PrintOpen(lsPrintText)
			
			If llPrintJob <0 Then 
				Messagebox('Part Label Print - Reprint', 'Unable to open Printer file. Labels will not be printed')
				Return
			End If 
		
			PrintSend(llPrintJob, lsLabelPrint)	
			PrintClose(llPrintJob)
				
		End If

	Else
	
		MessageBox("Label Print - Reprint", " No Parent Exists for the Specified BOM Serial Number!")
		
	End If
	
Else
	
	MessageBox("Label Print - Reprint", "BOM Serial Number Cannot Be BLANK or NULL")

End If

dw_pandora_part_label_print.SetColumn("parent_bom_serial_number")
dw_pandora_part_label_print.SelectText(1,Len("parent_bom_serial_number"))
dw_pandora_part_label_print.SetFocus()


end event

type cb_close from commandbutton within w_pandora_part_label_print_reprint
integer x = 128
integer y = 1168
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
end type

event clicked;


Close(parent)
end event

type cb_ok from commandbutton within w_pandora_part_label_print_reprint
event ue_reprint_part_label ( )
event type long ue_reprint_2d_barcode_label ( )
event ue_reprint_inventory_part_label ( )
integer x = 1083
integer y = 1168
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event ue_reprint_part_label();//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode
Any	lsAny
String		lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel, ls_qty, ls_Alternate_SKU, ls_Owner_Cd, ls_serial_no, ls_box_id ,ls_wh_code
String 	ls_sku, ls_description, ls_coo, ls_country_description, ls_Owner, ls_UserField1, ls_UserField14,ls_customer_code
String 	ls_l_code, ls_project_code, ls_Comment
Integer	liMsg
Long		llQty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount
Ulong 	ll_Owner_ID

Str_Parms	lstrparms
nvo_country lnvo_c

n_labels	lu_labels
lu_labels = Create n_labels

dw_pandora_part_label_print.AcceptText()

ls_sku = dw_pandora_part_label_print.GetItemString(1, "sku")

IF ls_sku = '' or isnull(ls_sku)  Then
	MessageBox("Part Label Reprint", "SKU is Required!")
	Return
END IF

SELECT description, Alternate_SKU, Owner_ID 
INTO :ls_description, :ls_Alternate_SKU, :ll_Owner_ID
FROM item_master with(nolock)
WHERE sku = :ls_sku and project_id = :gs_project 
USING SQLCA;

IF SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid sku.")
	dw_pandora_part_label_print.SetColumn("sku")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

SELECT Owner_Cd INTO :ls_Owner_Cd
FROM Owner with(nolock)
WHERE Owner_ID = :ll_Owner_ID and project_id = :gs_project 
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox ("DB ERror", SQLCA.SQLErrText )
END IF

ls_qty =  string(dw_pandora_part_label_print.GetItemNumber(1, "qty"))

If (IsNull(ls_qty) OR Integer(ls_qty) <= 0) THEN
	MessageBox ("Unable to print part label", "Quantity in container must be great than 0.")
	dw_pandora_part_label_print.SetColumn("qty")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

ls_coo =  dw_pandora_part_label_print.GetItemString(1, "coo")

//TimA 04/09/10 Pandora issue #560
SELECT Country.Country_Name INTO :ls_country_description
FROM Country with(nolock)
WHERE Country.Designating_Code = :ls_coo 
USING SQLCA;

IF ISNull(ls_coo) OR SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid coo.")
	dw_pandora_part_label_print.SetColumn("coo")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

// If the COO is 3 chars,
IF len(ls_coo) = 3 then
	// Create the country object. - KZUV.COM
	lnvo_c = Create nvo_country
	// Convert to 2 char COO.
	lnvo_c.f_exchangecodes(ls_coo, ls_coo)
	// Destroy the country object. - KZUV.COM
	Destroy lnvo_c
End If

ls_serial_no =  dw_pandora_part_label_print.GetItemString(1, "serial_no")
ls_wh_code =dw_pandora_part_label_print.GetItemString(1, "warehouse_code")
ls_customer_code =dw_pandora_part_label_print.GetItemString(1, "customer_code")

// TAM 04/2017 - Change label to us a standard label for Print and Reprint
ls_l_code =dw_pandora_part_label_print.GetItemString(1, "l_code")
IF ISNull(ls_l_code) THEN ls_l_code = ""

ls_project_code =dw_pandora_part_label_print.GetItemString(1, "project_code")
IF ISNull(ls_project_code) THEN ls_project_code = ""

// TAM 04/2017 - Change label to us a standard label for Print and Reprint
lsFormat 		= "pandora_part_label_owner_common.txt"

lsLabel = lu_labels.uf_read_label_Format(lsFormat)
If lsLabel = "" Then Return

//load current label from the template (we can resuse template until format changes)
lsCurrentLabel= lsLabel

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~", ls_sku) /* Part*/
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKUBARCODE~~", ls_sku) /* Barcoded Part*/

ls_Owner = dw_pandora_part_label_print.Object.customer_code[1]

IF ls_owner = '' or isnull(ls_owner) Then
	MessageBox("Part Label Reprint", "Owner CD is Required!")
	Return
END IF

// Get user_field1 for this owner.
IF NOT IsNull ( ls_Owner ) Then
	select user_field1
	into :ls_UserField1
	from customer with(nolock)
	where customer.project_id = 'PANDORA' 
	and customer.cust_code = :ls_Owner
	using sqlca;
else
	ls_UserField1 = ""
END IF

// If this customer is NOT 'NPI',
IF NOT Trim ( ls_UserField1 ) = "NPI" Then
	// Get the description.
	select description, 	USER_FIELD14
	into :ls_description, :ls_UserField14
	from ITEM_MASTER with(nolock)
	where PROJECT_ID = 'PANDORA' 
	and SKU = :ls_sku 
	and supp_code = 'PANDORA' 
	using sqlca;
	
	// Correct for Nulls.
	if IsNull ( ls_description ) then ls_description = ""
	if IsNull ( ls_UserField14 ) then ls_UserField14 = ""
	
	// Replace the label placeholder with the item description.
//	lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~DESCRIPTION~~", ls_description + " " + ls_UserField14 )
END IF

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~", ls_coo) /* COO */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~QTY~~", ls_qty) /* QTY */

IF (ls_wh_code ='PND_AMSTER' OR ls_wh_code='PND_WESTP' OR ls_wh_code='PND_SRIJK') Then
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER~~", ls_customer_code)
else
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER~~", ls_Owner_Cd) /* OWNER CD */	
END IF

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~ALT_SKU~~", ls_Alternate_SKU) /* Alternate_SKU */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIAL~~", ls_serial_no) /* BBBNum */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIALBARCODE~~", ls_serial_no) /* BBBNum Serial*/
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DATE~~", string(today(),'YYYY-MM-DD')) 

ls_box_id = dw_pandora_part_label_print.GetITemString(1,'box_id')

IF Isnull(ls_box_id) THEN ls_box_id = ''

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOX_ID~~", ls_box_id)

// TAM 04/2017 - Change label to us a standard label for Print and Reprint
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXID~~", ls_box_id)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOXIDBARCODE~~", ls_box_id)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~L_CODE~~", ls_l_code)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER_CD~~", ls_customer_code)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PROJECT_CODE~~", ls_project_code)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COOBARCODE~~", ls_coo) /* COO */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~", ls_qty) /* QTY */
IF isnull(ls_userfield14) Then ls_userfield14 = ""
lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~description~~", ls_description )
lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~description1~~",ls_UserField14 )
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU_barcode~~", ls_sku) /* Barcoded Part*/

ls_Comment = dw_pandora_part_label_print.GetItemString(1, "comments")
If IsNull(ls_Comment) THEN ls_Comment = ""
IF IsNull(ls_Project_Code) THEN ls_Project_Code = ""

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COMMENT~~", ls_Comment) /* Comment */ 
// TAM 2017/04 - Added "reprint" to the label to identify it was a reprinted label and not an original
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~reprint~~", 'REPRINT' ) 

// 11/07 - PONKL - Loop for each qty of label to print...
llPrintCount = dw_pandora_part_label_print.GetITemNUmber(1,'number_labels')
For llPrintPOs = 1 to llPrintCount
	lsLabelPrint += lsCurrentLabel
Next

//Send the format to the printer...
If lsLabelPrint > "" Then
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	IF lstrParms.Cancelled Then
		Return
	End IF
	
	lsPrintText = 'Pandora Part Label '
	
	//Open Printer File 
	llPrintJob = PrintOpen(lsPrintText)
	If llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return
	End IF
	
	PrintSend(llPrintJob, lsLabelPrint)	
	PrintClose(llPrintJob)
End IF
end event

event type long ue_reprint_2d_barcode_label();//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode
string 	ls_sku, ls_qty, ls_coo, ls_country_description, ls_wh_code, ls_pallet_Id, ls_container_Id, ls_sscc, ls_label_carton_Id
string		lsFormat, lsLabel, lsCurrentLabel, lsLabelPrint, lsLabelRePrint,  lsPrintText, ls_sql, ls_errors, ls_msg, ls_label_text, ls_max_limit
long		llPrintCount, llPrintPos, llPrintJob, ll_return, ll_Row_count, ll_row, ll_max_limit
str_parms lStrParms, lstr_serial_parm, lstr_empty_parm, ls_str_serial_label_parm

Datastore lds_serial

nvo_country 	lnvo_c
n_labels			lu_labels
n_labels_pandora		lu_labels_pandora
n_warehouse 	lu_warehouse

lds_serial = create Datastore
lnvo_c = Create nvo_country
lu_labels = Create n_labels
lu_labels_pandora = Create n_labels_pandora
lu_warehouse = Create n_warehouse

dw_pandora_part_label_print.AcceptText()

//get MAX Limit of QR Barcode from Look Up Table
ls_max_limit =f_retrieve_parm(gs_project, 'QRBARCODE','MAX')
If IsNumber(ls_max_limit) Then ll_max_limit =long(ls_max_limit)

//sku validation
ls_sku = dw_pandora_part_label_print.GetItemString(1, "sku")

IF ls_sku = '' or isnull(ls_sku)  Then
	MessageBox("Part Label 2D Barcode Reprint", "SKU is Required!")
	Return -1
END IF

IF lu_warehouse.of_item_sku( gs_project, ls_sku) < 0 Then
	MessageBox ("Unable to print part label", "This is an invalid sku.")
	dw_pandora_part_label_print.SetColumn("sku")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
End IF

//Qty validation
ls_qty =  string(dw_pandora_part_label_print.GetItemNumber(1, "qty"))
If (IsNull(ls_qty) OR Integer(ls_qty) <= 0) THEN
	MessageBox ("Unable to print part label", "Quantity in container must be great than 0.")
	dw_pandora_part_label_print.SetColumn("qty")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
END IF

ls_coo =  dw_pandora_part_label_print.GetItemString(1, "coo")

//TimA 04/09/10 Pandora issue #560
SELECT Country.Country_Name INTO :ls_country_description
FROM Country with(nolock)
WHERE Country.Designating_Code = :ls_coo 
USING SQLCA;

IF IsNull(ls_coo) OR SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an Invalid COO.")
	dw_pandora_part_label_print.SetColumn("coo")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
END IF

IF len(ls_coo) = 3 Then 	lnvo_c.f_exchangecodes(ls_coo, ls_coo) 	// Convert to 2 char COO.

//PalletId /Box Id  - At lease one value must be present
ls_pallet_Id = dw_pandora_part_label_print.getItemString( 1, "pallet_Id") //Po No2
ls_container_Id = dw_pandora_part_label_print.getItemString( 1, "box_Id") //Container Id

IF (IsNull(ls_pallet_Id) or ls_pallet_Id ='' or ls_pallet_Id=' ' )  &
	and (IsNull(ls_container_Id) or ls_container_Id ='' or ls_container_Id=' ') THEN
		MessageBox ("Unable to print part label", "Box Id or Pallet Id value should be present.!")
		dw_pandora_part_label_print.SetColumn("box_Id")
		dw_pandora_part_label_print.SetFocus()
		RETURN -1
END IF

ls_wh_code =dw_pandora_part_label_print.GetItemString(1, "warehouse_code")

//get Serial No's from Serial Number Inventory Table.
ls_sql =" select * from Serial_Number_Inventory with(nolock) "
ls_sql += " where Project_Id ='"+gs_project+"'  and sku ='"+ls_sku+"' and wh_code ='"+ls_wh_code +"' "
If (not isnull(ls_pallet_Id) and len(ls_pallet_Id) > 0) Then ls_sql += " and Po_No2 = '" + ls_pallet_Id + "' "
If (not isnull(ls_container_Id) and len(ls_container_Id) > 0) Then ls_sql += " and Carton_Id = '" + ls_container_Id + "'"

//create runtime datastore
lds_serial.create( SQLCA.SyntaxFromSql(ls_sql, "", ls_errors))
lds_serial.settransobject( SQLCA)
ll_Row_count = lds_serial.retrieve( )

IF len(ls_errors) > 0 THEN
	MessageBox("Part Label 2D Barcode Reprint","Unable to retrieve Serial Number Inventory records!")
	Return -1
END IF

IF ll_Row_count = 0 THEN
	ls_msg = " Serial No Records are not available against SKU# "+nz(ls_sku, '-') + " ,Wh_Code # " +nz(ls_wh_code, '-') + " , Pallet Id# "+ nz(ls_pallet_Id ,'-') +" , Container Id# "+nz(ls_container_Id, '-')
	MessageBox("Part Label 2D Barcode Reprint", ls_msg)
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

llPrintCount = dw_pandora_part_label_print.GetITemNUmber(1,'number_labels')
IF llPrintCount > 0 Then
	For llPrintPos = 1 to llPrintCount
		lsLabelRePrint +=lsLabelPrint
	Next
else
	lsLabelRePrint =lsLabelPrint
End IF

//Print Label
lu_labels_pandora.uf_print_label_data( 'Pandora Pallet/Carton (2D) Label ', lsLabelRePrint)

Destroy lds_serial
Destroy lnvo_c
Destroy lu_labels
Destroy lu_labels_pandora
Destroy lu_warehouse
end event

event ue_reprint_inventory_part_label();//01-AUG-2018 Madhu S21780 - Label Consolidation - Reprint Inventory Part Label

string ls_sku, ls_alt_sku, ls_coo, ls_country_description, ls_owner, ls_owner_cd, ls_qty, ls_box_id
string ls_format, lslabel, lscurrentlabel, lslabelprint, lsprinttext

string ls_QA_Check_Ind, ls_serialized_Ind, ls_uf14, ls_project_code, ls_customer_code
string ls_complete_description, ls_description, ls_description1, ls_description2, ls_description3, ls_description4, ls_exp_ind
Long	ll_qty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount
long   ll_count, ll_remain_length
Ulong ll_Owner_ID

Str_Parms	lstrparms
nvo_country lnvo_c

n_labels	lu_labels
lu_labels = Create n_labels

dw_pandora_part_label_print.AcceptText()

ls_sku = dw_pandora_part_label_print.GetItemString(1, "sku")
IF ls_sku = '' or isnull(ls_sku)  Then
	MessageBox("Part Label Reprint", "SKU is Required!")
	Return
END IF

SELECT description, Alternate_SKU, Owner_ID , QA_Check_Ind, Serialized_Ind, User_Field14, Expiration_Controlled_Ind, serialized_ind
INTO :ls_description, :ls_alt_sku, :ll_Owner_ID, :ls_QA_Check_Ind, :ls_serialized_Ind, :ls_uf14, :ls_exp_ind, :ls_serialized_ind
FROM item_master with(nolock)
WHERE sku = :ls_sku and project_id = :gs_project 
USING SQLCA;

IF SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid sku.")
	dw_pandora_part_label_print.SetColumn("sku")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

SELECT Owner_Cd INTO :ls_Owner_Cd
FROM Owner with(nolock)
WHERE Owner_ID = :ll_Owner_ID and project_id = :gs_project 
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox ("DB ERror", SQLCA.SQLErrText )
END IF

ll_qty =  dw_pandora_part_label_print.GetItemNumber(1, "qty")

If (ll_qty <= 0) THEN
	MessageBox ("Unable to print part label", "Quantity in container must be great than 0.")
	dw_pandora_part_label_print.SetColumn("qty")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

ls_coo =  dw_pandora_part_label_print.GetItemString(1, "coo")

SELECT Country.Country_Name INTO :ls_country_description
FROM Country with(nolock)
WHERE Country.Designating_Code = :ls_coo 
USING SQLCA;

IF ISNull(ls_coo) OR SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid coo.")
	dw_pandora_part_label_print.SetColumn("coo")
	dw_pandora_part_label_print.SetFocus()
	RETURN
END IF

// If the COO is 3 chars,
IF len(ls_coo) = 3 then
	lnvo_c = Create nvo_country
	lnvo_c.f_exchangecodes(ls_coo, ls_coo)
	Destroy lnvo_c
End If

ls_customer_code =dw_pandora_part_label_print.GetItemString(1, "customer_code")
ls_project_code =dw_pandora_part_label_print.GetItemString(1, "project_code")
IF IsNull(ls_project_code) THEN ls_project_code = ""

IF ls_QA_Check_Ind ='M' Then
	ls_format ="Pandora_Inventory_Label_DG_Logo_200_DPI.txt"
ELSE
	ls_format ="Pandora_Inventory_Label_No_DG_Logo_200_DPI.txt"
END IF

lsLabel = lu_labels.uf_read_label_Format(ls_format)
If lsLabel = "" Then Return

//load current label from the template (we can resuse template until format changes)
lsCurrentLabel= lsLabel

If (not isnull(ls_description) and len(ls_description) > 0 ) Then ls_complete_description = ls_description
If (not isnull(ls_uf14) and len(ls_uf14) > 0 ) Then ls_complete_description += ls_uf14

//split the description into multiple fields. Each field can hold upto 50 chars.
ll_count =0
ll_remain_length = len(ls_complete_description)

DO WHILE ll_remain_length > 0
	ll_count++
	
	CHOOSE CASE ll_count
	
	CASE 1  //1-50
		IF ll_remain_length > 50 Then
			ls_description = left(ls_complete_description, 50)
			ll_remain_length = ll_remain_length -50
		ELSE
			ls_description = left(ls_complete_description, ll_remain_length)
			ll_remain_length = 0
		END IF
	
	CASE 2 //51-100
		IF ll_remain_length > 50 Then
			ls_description1 = Mid(ls_complete_description, 51, 50)
			ll_remain_length = ll_remain_length -50
		ELSE
			ls_description1 = Mid(ls_complete_description, 51, ll_remain_length)
			ll_remain_length = 0
		END IF
	
	CASE 3 //101-150
		IF ll_remain_length > 50 Then
			ls_description2 = Mid(ls_complete_description, 101, 50)
			ll_remain_length = ll_remain_length -50
		ELSE
			ls_description2 = Mid(ls_complete_description, 101, ll_remain_length)
			ll_remain_length = 0
		END IF
	
	CASE 4 //151-200
		IF ll_remain_length > 50 Then
			ls_description3 = Mid(ls_complete_description, 151, 50)
			ll_remain_length = ll_remain_length -50
		ELSE
			ls_description3 = Mid(ls_complete_description, 151, ll_remain_length)
			ll_remain_length = 0
		END IF
	
	CASE 5 //201-250
		IF ll_remain_length > 50 Then
			ls_description4 = Mid(ls_complete_description, 201, 50)
			ll_remain_length = ll_remain_length -50
		ELSE
			ls_description4 = Mid(ls_complete_description, 201, ll_remain_length)
			ll_remain_length = 0
		END IF
	END CHOOSE
LOOP

ls_Owner = dw_pandora_part_label_print.Object.customer_code[1]

IF ls_owner = '' or isnull(ls_owner) Then
	MessageBox("Part Label Reprint", "Owner CD is Required!")
	Return
END IF

ls_box_id = dw_pandora_part_label_print.GetITemString(1,'box_id')
IF Isnull(ls_box_id) THEN ls_box_id = ''

//replace label format data
If ls_box_id <> '-' Then lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~container_id~~",  ls_box_id)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku~~", ls_sku) 
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku_desc~~", ls_description)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku_desc1~~", ls_description1)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku_desc2~~", ls_description2)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku_desc3~~", ls_description3)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~sku_desc4~~", ls_description4)

If ll_qty < 10 Then
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~qty~~", string(ll_qty ,'00'))
else
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~qty~~", string(ll_qty))
End If

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~uc3~~", ls_coo)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~owner_code~~", ls_customer_code)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~alt_sku~~", ls_alt_sku)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~po_no~~", ls_project_code)

//If ls_exp_Ind ='Y' and string(ldt_exp_date, 'MM/DD/YYYY') <> '12/31/2999' Then 
//	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~dt_expire~~", string(ldt_exp_date, 'MM/DD/YYYY'))
//else
//	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel, "", "^FD^FS") //make Invisible
//End If
	
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~user_name~~", gs_userid)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~route_cmt1~~", ls_serialized_Ind)
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~dt_print~~", string(today(),'MM/DD/YYYY'))


// 11/07 - PONKL - Loop for each qty of label to print...
llPrintCount = dw_pandora_part_label_print.GetITemNUmber(1,'number_labels')
For llPrintPOs = 1 to llPrintCount
	lsLabelPrint += lsCurrentLabel
Next

//Send the format to the printer...
If lsLabelPrint > "" Then
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	IF lstrParms.Cancelled Then
		Return
	End IF
	
	lsPrintText = 'Pandora Part Label '
	
	//Open Printer File 
	llPrintJob = PrintOpen(lsPrintText)
	If llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return
	End IF
	
	PrintSend(llPrintJob, lsLabelPrint)	
	PrintClose(llPrintJob)
End IF

destroy lu_labels
end event

event clicked;//27-FEB-2018 Madhu S16401 F6390 - 2D Barcode
//Wrapped existing code into a method.

IF cbx_2d_barcode.checked =TRUE THEN
	this.event ue_reprint_2d_barcode_label( )
ELSE
	IF f_retrieve_parm("PANDORA", "FOOTPRINT", "FOOTPRINT_LABELS" ,"USER_UPDATEABLE_IND") = 'N'  THEN
		this.event ue_reprint_part_label( ) //old format
	ELSE
		this.event ue_reprint_inventory_part_label() //new format
	END IF
END IF
end event

type dw_pandora_part_label_print from datawindow within w_pandora_part_label_print_reprint
integer x = 110
integer y = 124
integer width = 2926
integer height = 1036
integer taborder = 10
string title = "none"
string dataobject = "d_pandora_part_label_print"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String ls_Null

Choose Case Upper(dwo.name)
		
	Case "QTY"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("qty")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			dw_pandora_part_label_print.SetColumn("sku")
			dw_pandora_part_label_print.SetFocus()
			 
		End If

	Case "SKU"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("sku")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			dw_pandora_part_label_print.SetColumn("serial_no")
			dw_pandora_part_label_print.SetFocus()
			 
		End If

	Case "SERIAL_NO"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("serial_no")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			dw_pandora_part_label_print.SetColumn("box_id")
			dw_pandora_part_label_print.SetFocus()
			 
		End If

	Case "BOX_ID"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("box_id")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			dw_pandora_part_label_print.SetColumn("coo")
			dw_pandora_part_label_print.SetFocus()
			 
		End If
		
	Case "COO"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("coo")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			
			dw_pandora_part_label_print.SetColumn("comments")
			dw_pandora_part_label_print.SetFocus()
			 
		End If
		
	Case "COMMENTS"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("comments")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			
			dw_pandora_part_label_print.SetColumn("number_labels")
			dw_pandora_part_label_print.SetFocus()
			 
		End If
	
	Case "number_labels"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("number_labels")
			dw_pandora_part_label_print.SetFocus()
			
		else	
			
			dw_pandora_part_label_print.SetColumn("qty")
			dw_pandora_part_label_print.SetFocus()
			 
		End If
		
	Case "PARENT_BOM_SERIAL_NUMBER"	
			
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("parent_bom_serial_number")
			dw_pandora_part_label_print.SetFocus()
			cb_print_bom_specific_serial_labels.default = FALSE
			
		else	
			cb_print_bom_specific_serial_labels.default = TRUE
			cb_print_bom_specific_serial_labels.SetFocus()
			 
		End If





	Case "PARENT_BOM_SERIAL_NUMBER"	
		
		
		If data = "" Then
			
			dw_pandora_part_label_print.SetColumn("parent_bom_serial_number")
			dw_pandora_part_label_print.SetFocus()
			cb_print_bom_specific_serial_labels.default = FALSE
			
		else	
			cb_print_bom_specific_serial_labels.default = TRUE
			cb_print_bom_specific_serial_labels.SetFocus()
			 
		End If
		
	case "WAREHOUSE_CODE"
		SetNull ( ls_Null )
		
		idwc_Customer.Retrieve ( data )
		
		this.Object.customer_code[1] = ls_Null
		
End Choose
end event

event itemfocuschanged;
//TimA 04/09/13 Pandora issue #560
//Get the data from the new Item_Master_Coo table
Choose Case dwo.name
	Case 'coo'
		If gs_project = 'PANDORA' Then
				idwc_Coo.Retrieve(gs_project,This.GetITemString(row,'sku'),'PANDORA')
		End If		
End choose
end event

type dw_print_bom_specific_serial_labels from u_dw_ancestor within w_pandora_part_label_print_reprint
boolean visible = false
integer x = 279
integer y = 224
integer width = 2656
integer height = 668
integer taborder = 20
string dataobject = "d_parent_bom_serial_labels"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('user_field11',ldwc)

ldwc.SetTransObject(SQLCA)

ldwc.Retrieve(gs_project,'PTLBL')
end event

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
	Case "parent_bom_serial_number"	
		
		If data <> "" Then
			
			cb_print_bom_specific_serial_labels.SetFocus()
			
		else	
			
			dw_pandora_part_label_print.SetColumn("parent_bom_serial_number")
			dw_pandora_part_label_print.SetFocus()
			
		End If
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

