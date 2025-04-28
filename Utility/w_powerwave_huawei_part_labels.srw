HA$PBExportHeader$w_powerwave_huawei_part_labels.srw
$PBExportComments$Powerwave huawei Part Label
forward
global type w_powerwave_huawei_part_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_powerwave_huawei_part_labels
end type
type dw_label from u_dw_ancestor within w_powerwave_huawei_part_labels
end type
type cb_selectall from commandbutton within w_powerwave_huawei_part_labels
end type
type cb_clear from commandbutton within w_powerwave_huawei_part_labels
end type
end forward

global type w_powerwave_huawei_part_labels from w_main_ancestor
integer width = 3237
integer height = 1812
string title = "Powerwave huawei Part Labels"
string menuname = ""
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_clear cb_clear
end type
global w_powerwave_huawei_part_labels w_powerwave_huawei_part_labels

type variables
n_warehouse i_nwarehouse
n_labels	invo_labels
n_3com_labels	invo_3com_labels
n_labels in_labels   // restructured to hold the label in the instance variable
string isLabel       // holds label format

String	isOrigSql


end variables

event ue_print();Str_Parms	lstrparms

Long	llQty,	&
		llRowCount,	&
		llRowPos, &
		ll_rtn, llPrintJob, llFindRow
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText,  &
			lsCurrentLabel
Integer	liMsg


n_labels	lu_labels
//lu_labels = Create n_labels

If IsValid(in_labels) Then
	lu_labels = in_labels
Else
	return
End If

If isLabel = "" Then 
	Return
Else
	lsLabel = isLabel
End If

Dw_Label.AcceptText()

//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	//load current label from the template (we can reuse template until format changes)
	lsCurrentLabel= lsLabel
	
	// Powerwave uses the PO_NO2 (PO NO) and User_field1 (Huawei item) values from the query on the labe
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PO NO~~",dw_label.GetITemString(llRowPos,'delivery_picking_po_no')) /* ORder Number*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~PartNumber~~",dw_label.GetITemString(llRowPos,'delivery_detail_huawei_item')) /* ORder Number*/

	/*
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~order_no~~",dw_label.GetITemString(llRowPos,'supp_invoice_no')) /* ORder Number*/
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Line_item~~",String(dw_label.GetITemNumber(llRowPos,'Line_Item_No'))) /* Line Item*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~line_item_barcode~~",String(dw_label.GetITemNumber(llRowPos,'Line_Item_No'))) /* Barcoded Line Item*/
	
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~",dw_label.GetITemString(llRowPos,'sku')) /* Part*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU_Barcode~~",dw_label.GetITemString(llRowPos,'sku')) /* Barcoded Part*/
		
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Description~~",dw_label.GetITemString(llRowPos,'Description')) /* Description*/
	
	If dw_label.GetITemString(llRowPos,'Lot_No') <> '-' Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~lot_no~~",dw_label.GetITemString(llRowPos,'Lot_No')) /* Lot No*/
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~lot_no_barcode~~",dw_label.GetITemString(llRowPos,'Lot_No')) /* Barcoded Lot No*/
	Else
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~lot_no~~","") /* Lot No*/
	//	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~lot_no_barcode~~","") /* Barcoded Lot No*/
	End If
	*/
		
	//Override Print Count if necessary
	If dw_label.GetITemNUmber(llRowPos,'c_print_qty') > 1 Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"^PQ1,","^PQ" + string(dw_label.GetITemNUmber(llRowPos,'c_print_qty')) + ",")
	End If
		
	lsLabelPrint += lsCurrentLabel
			
Next /*detail row to Print*/

//Send the format to the printer...
If lsLabelPrint > "" Then
		
	OpenWithParm(w_label_print_options,lStrParms)
	Lstrparms = Message.PowerObjectParm		  
	If lstrParms.Cancelled Then
		Return
	End If
				
	lsPrintText = 'Huawei part Labels'

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

on w_powerwave_huawei_part_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_clear=create cb_clear
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_clear
end on

on w_powerwave_huawei_part_labels.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_clear)
end on

event ue_postopen;call super::ue_postopen;string lsFormat = "Powerwave_Huawei_Part_Zebra.Txt"

IF not isvalid(w_do) Then
	Messagebox("Labels","You must have an open Delivery Order to print part labels.")
	event close( )

else
	invo_labels = Create n_labels
	i_nwarehouse = Create n_warehouse
	
	cb_print.Enabled = False
	
	isOrigSql = dw_label.GetSqlSelect()
	
	// read the label format once and store to instance 
	in_labels = create n_labels
	isLabel = in_labels.uf_read_label_Format(lsFormat)
	
	This.TriggerEvent('ue_retrieve')	

End If


end event

event ue_retrieve;call super::ue_retrieve;long llRowCount = 0
long llRowPos = 0
long llShipQty = 0
string  ls_dono  , ls_pono2

If not isvalid(w_do) Then Return
If w_do.idw_main.RowCount() < 1 then return

llRowCount = dw_label.Retrieve(w_do.idw_main.GetITemString(1,'do_no'))
 ls_dono = w_do.idw_main.GetITemString(1,'do_no')

cb_print.Enabled = True

// default print qty to be the same as the shipping qty
For llRowPos = 1 to llRowCount /*each detail row */
			
	llShipQty = dw_label.GetItemNumber( llRowPos, 'delivery_picking_ship_qty' )

	dw_label.setitem( llRowPos, 'c_print_qty', llShipQty )
	//Change has been done for  Powerwave project  , Printing the PONO on the label

	//Start (Neha jain 02-oct -2012)
	if (gs_project ='POWERWAVE') then 
		select PO_No2  into :ls_pono2 from EDI_Outbound_Detail 
		where  Invoice_No in  ( select  Invoice_No from Delivery_Master where DO_No  =:ls_dono);
  		dw_label.setitem( llRowPos, 'delivery_picking_po_no',  ls_pono2 )
	end if 
	//end 

Next




end event

event ue_selectall;call super::ue_selectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event ue_unselectall;call super::ue_unselectall;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

event resize;call super::resize;dw_label.Resize(workspacewidth() - 50,workspaceHeight()-150)
end event

event close;call super::close;IF ISVALID(i_nwarehouse) THEN Destroy(i_nwarehouse)
IF IsValid(in_labels) THEN Destroy(in_labels)
IF IsValid(invo_labels) THEN Destroy(invo_labels)
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_powerwave_huawei_part_labels
boolean visible = false
integer x = 1938
integer y = 1392
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_powerwave_huawei_part_labels
integer x = 1769
integer y = 32
integer height = 80
integer textsize = -9
boolean default = false
end type

type cb_print from commandbutton within w_powerwave_huawei_part_labels
integer x = 946
integer y = 32
integer width = 329
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;Parent.TriggerEvent('ue_Print')
end event

type dw_label from u_dw_ancestor within w_powerwave_huawei_part_labels
integer x = 9
integer y = 140
integer width = 3145
integer height = 1516
boolean bringtotop = true
string dataobject = "d_powerwave_huawei_part_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;
Choose Case Upper(dwo.name)
		
	Case "COUNTRY_OF_ORIGIN_DEFAULT"
		
		If data > "" Then
			
			If f_get_country_name(data) = "" Then
				Messagebox("Labels", "Invalid Country of Origin")
				Return 1
			End If
			
		End If
		
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event constructor;call super::constructor;
DatawindowChild	ldwc

This.GetChild('user_field11',ldwc)

ldwc.SetTransObject(SQLCA)

ldwc.Retrieve(gs_project,'PTLBL')
end event

event process_enter;call super::process_enter;
Send(Handle(This),256,9,Long(0,0))
end event

type cb_selectall from commandbutton within w_powerwave_huawei_part_labels
integer x = 37
integer y = 32
integer width = 338
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;Parent.Event ue_selectall()

end event

type cb_clear from commandbutton within w_powerwave_huawei_part_labels
integer x = 393
integer y = 32
integer width = 338
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;Parent.Event ue_unselectall()
end event

