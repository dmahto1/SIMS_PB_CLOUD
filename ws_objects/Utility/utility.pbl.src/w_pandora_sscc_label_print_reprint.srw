$PBExportHeader$w_pandora_sscc_label_print_reprint.srw
forward
global type w_pandora_sscc_label_print_reprint from window
end type
type st_single_part_label from statictext within w_pandora_sscc_label_print_reprint
end type
type st_parent_child from statictext within w_pandora_sscc_label_print_reprint
end type
type cb_print_bom_specific_serial_labels from commandbutton within w_pandora_sscc_label_print_reprint
end type
type cb_close from commandbutton within w_pandora_sscc_label_print_reprint
end type
type cb_ok from commandbutton within w_pandora_sscc_label_print_reprint
end type
type dw_pandora_part_label_print from datawindow within w_pandora_sscc_label_print_reprint
end type
type dw_print_bom_specific_serial_labels from u_dw_ancestor within w_pandora_sscc_label_print_reprint
end type
end forward

global type w_pandora_sscc_label_print_reprint from window
integer width = 3218
integer height = 1820
boolean titlebar = true
string title = "Part Label Print - Reprint"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_single_part_label st_single_part_label
st_parent_child st_parent_child
cb_print_bom_specific_serial_labels cb_print_bom_specific_serial_labels
cb_close cb_close
cb_ok cb_ok
dw_pandora_part_label_print dw_pandora_part_label_print
dw_print_bom_specific_serial_labels dw_print_bom_specific_serial_labels
end type
global w_pandora_sscc_label_print_reprint w_pandora_sscc_label_print_reprint

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
	cb_close.y								    				= 1500
	cb_print_bom_specific_serial_labels.visible		= TRUE
	cb_print_bom_specific_serial_labels.x  			= 1083
	cb_print_bom_specific_serial_labels.y  			= 1500
	w_pandora_sscc_label_print_reprint.height 		= 1844
	st_parent_child.visible								= TRUE
	st_single_part_label.visible							= TRUE
	
	
Else

	dw_pandora_part_label_print.height 				= 956
	cb_print_bom_specific_serial_labels.visible		= FALSE
	cb_print_bom_specific_serial_labels.x  			= 1970
	cb_print_bom_specific_serial_labels.y  			= 1076
	cb_close.y								   				= 1076
	w_pandora_sscc_label_print_reprint.height 		= 1228
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

on w_pandora_sscc_label_print_reprint.create
this.st_single_part_label=create st_single_part_label
this.st_parent_child=create st_parent_child
this.cb_print_bom_specific_serial_labels=create cb_print_bom_specific_serial_labels
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.dw_pandora_part_label_print=create dw_pandora_part_label_print
this.dw_print_bom_specific_serial_labels=create dw_print_bom_specific_serial_labels
this.Control[]={this.st_single_part_label,&
this.st_parent_child,&
this.cb_print_bom_specific_serial_labels,&
this.cb_close,&
this.cb_ok,&
this.dw_pandora_part_label_print,&
this.dw_print_bom_specific_serial_labels}
end on

on w_pandora_sscc_label_print_reprint.destroy
destroy(this.st_single_part_label)
destroy(this.st_parent_child)
destroy(this.cb_print_bom_specific_serial_labels)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.dw_pandora_part_label_print)
destroy(this.dw_print_bom_specific_serial_labels)
end on

type st_single_part_label from statictext within w_pandora_sscc_label_print_reprint
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

type st_parent_child from statictext within w_pandora_sscc_label_print_reprint
integer y = 1640
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

type cb_print_bom_specific_serial_labels from commandbutton within w_pandora_sscc_label_print_reprint
boolean visible = false
integer x = 1970
integer y = 1076
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

type cb_close from commandbutton within w_pandora_sscc_label_print_reprint
integer x = 128
integer y = 1076
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

type cb_ok from commandbutton within w_pandora_sscc_label_print_reprint
integer x = 1083
integer y = 1076
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

event clicked;
string ls_sku, ls_description, ls_coo, ls_country_description, ls_Owner, ls_UserField1, ls_UserField14
Str_Parms	lstrparms
n_labels	lu_labels
nvo_country lnvo_c

Long	llQty, llRowCount, llRowPos, ll_rtn, llPrintJob, llFindRow, llPrintPos, llPrintCount
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel, ls_qty, ls_Alternate_SKU, ls_Owner_Cd, ls_serial_no, ls_box_id
Integer	liMsg
Ulong 	ll_Owner_ID

dw_pandora_part_label_print.AcceptText()

ls_sku = dw_pandora_part_label_print.GetItemString(1, "sku")

if ls_sku = '' or isnull(ls_sku)  then
	messagebox("Part Label Reprint", "SKU is Required!")
	return -1
end if

SELECT description, Alternate_SKU, Owner_ID INTO :ls_description, :ls_Alternate_SKU, :ll_Owner_ID
	FROM item_master 
	WHERE sku = :ls_sku and project_id = :gs_project USING SQLCA;

IF SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid sku.")
	dw_pandora_part_label_print.SetColumn("sku")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
END IF

SELECT Owner_Cd INTO :ls_Owner_Cd
	FROM Owner 
	WHERE Owner_ID = :ll_Owner_ID and project_id = :gs_project USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	Messagebox ("DB ERror", SQLCA.SQLErrText )
END IF

ls_qty =  string(dw_pandora_part_label_print.GetItemNumber(1, "qty"))

If (IsNull(ls_qty) OR Integer(ls_qty) <= 0) THEN
	MessageBox ("Unable to print part label", "Quantity in container must be great than 0.")
	dw_pandora_part_label_print.SetColumn("qty")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
END IF

ls_coo =  dw_pandora_part_label_print.GetItemString(1, "coo")

//SELECT Country.Country_Name INTO :ls_country_description
//	FROM Country 
//	WHERE Country.ISO_Country_Cd = :ls_coo USING SQLCA;

//TimA 04/09/10 Pandora issue #560
SELECT Country.Country_Name INTO :ls_country_description
	FROM Country 
	WHERE Country.Designating_Code = :ls_coo USING SQLCA;
	
IF ISNull(ls_coo) OR SQLCA.SQLCode = 100 THEN
	MessageBox ("Unable to print part label", "This is an invalid coo.")
	dw_pandora_part_label_print.SetColumn("coo")
	dw_pandora_part_label_print.SetFocus()
	RETURN -1
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

IF ISNull(ls_serial_no) THEN ls_serial_no = ""

lu_labels = Create n_labels

lsformat = "pandora_part_label.txt"

lsLabel = lu_labels.uf_read_label_Format(lsFormat)
If lsLabel = "" Then Return

//load current label from the template (we can resuse template until format changes)
lsCurrentLabel= lsLabel

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~", ls_sku) /* Part*/
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKUBARCODE~~", ls_sku) /* Barcoded Part*/

ls_Owner = dw_pandora_part_label_print.Object.customer_code[1]

if ls_owner = '' or isnull(ls_owner) then
	messagebox("Part Label Reprint", "Owner CD is Required!")
	return -1
end if

// Get user_field1 for this owner.
if not IsNull ( ls_Owner ) then
	select user_field1
	   into :ls_UserField1
	  from customer
	where customer.project_id = 'PANDORA' and 
	          customer.cust_code = :ls_Owner;
else
	ls_UserField1 = ""
end if

// If this customer is NOT 'NPI',
if not Trim ( ls_UserField1 ) = "NPI" then
	// Get the description.
	select description, 
	         USER_FIELD14
	   into :ls_description, 
		     :ls_UserField14
	  from ITEM_MASTER
	where PROJECT_ID = 'PANDORA' and
	          SKU = :ls_sku and
	          supp_code = 'PANDORA' ;

	// Correct for Nulls.
	if IsNull ( ls_description ) then ls_description = ""
	if IsNull ( ls_UserField14 ) then ls_UserField14 = ""

	// Replace the label placeholder with the item description.
//	lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~DESCRIPTION~~", ls_description) // Description
	lsCurrentLabel = lu_labels.uf_replace ( lsCurrentLabel, "~~DESCRIPTION~~", ls_description + " " + ls_UserField14 )
end if
	
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COO~~", ls_coo) /* COO */

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~QTY~~", ls_qty) /* QTY */

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~OWNER~~", ls_Owner_Cd) /* OWNER CD */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~ALT_SKU~~", ls_Alternate_SKU) /* Alternate_SKU */

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIAL~~", ls_serial_no) /* BBBNum */
lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SERIALBARCODE~~", ls_serial_no) /* BBBNum Serial*/

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~DATE~~", string(today(),'YYYY-MM-DD')) 

ls_box_id = dw_pandora_part_label_print.GetITemString(1,'box_id')

If Isnull(ls_box_id) THEN ls_box_id = ''

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~BOX_ID~~", ls_box_id)


STRING ls_Comment, ls_Project_Code

ls_Comment = dw_pandora_part_label_print.GetItemString(1, "comments")
//ls_Project_Code = dw_pandora_part_label_print.GetItemString(1, "project_code")

If IsNull(ls_Comment) THEN ls_Comment = ""
IF IsNull(ls_Project_Code) THEN ls_Project_Code = ""

lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~COMMENT~~", ls_Comment) /* Comment */ 
//lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PROJECT_CODE~~", ls_Project_Code) /* Proejct_Code */


//	//Override Print Count if necessary
//	If dw_label.GetITemNUmber(llRowPos,'c_print_qty') > 1 Then
//		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"^PQ1,","^PQ" + string(dw_label.GetITemNUmber(llRowPos,'c_print_qty')) + ",")
//	End If
//		
// 11/07 - PONKL - Loop for each qty of label to print...
llPrintCount = dw_pandora_part_label_print.GetITemNUmber(1,'number_labels')
For llPrintPOs = 1 to llPrintCount
	lsLabelPrint += lsCurrentLabel
Next
		

//Send the format to the printer...
If lsLabelPrint > "" Then
		
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return
	End If
				
	lsPrintText = 'Pandora Part Label '

		//Open Printer File 
		llPrintJob = PrintOpen(lsPrintText)
	
		If llPrintJob <0 Then 
			Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
			Return
		End If

		PrintSend(llPrintJob, lsLabelPrint)	
		PrintClose(llPrintJob)
		
End If
		
end event

type dw_pandora_part_label_print from datawindow within w_pandora_sscc_label_print_reprint
integer x = 110
integer y = 80
integer width = 2917
integer height = 908
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

type dw_print_bom_specific_serial_labels from u_dw_ancestor within w_pandora_sscc_label_print_reprint
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

