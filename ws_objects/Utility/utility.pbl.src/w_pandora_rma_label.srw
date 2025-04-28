$PBExportHeader$w_pandora_rma_label.srw
$PBExportComments$Print Pandora RMA Labels
forward
global type w_pandora_rma_label from w_main_ancestor
end type
type cb_print from commandbutton within w_pandora_rma_label
end type
type dw_label from u_dw_ancestor within w_pandora_rma_label
end type
type cb_selectall from commandbutton within w_pandora_rma_label
end type
type cb_1 from commandbutton within w_pandora_rma_label
end type
end forward

global type w_pandora_rma_label from w_main_ancestor
integer width = 1883
integer height = 1408
string title = "RMA Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_1 cb_1
end type
global w_pandora_rma_label w_pandora_rma_label

type variables



String	isOrigSQL
end variables

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llQty,llRowCount,	llRowPos, lllabelPos, &
		ll_rtn, llPrintJob, llEndPos, llStartPos
		
Any	lsAny

String	lsformat,  lsPrinter, lsLabel, lsLabelPrint, lsPrintText, lsCurrentLabel, lsField


lu_labels = Create n_labels

Dw_Label.AcceptText()

//Load either the single or multiple line format depending on the Detail Count
If w_do.idw_detail.RowCount() = 1 Then
	lsformat = "Pandora_rma_single_zebra.Txt"
Else
	lsformat = "Pandora_rma_multiple_zebra.Txt"
End If

lsLabel = lu_labels.uf_read_label_Format(lsFormat)
If lsLabel = "" Then Return

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
	
lsCurrentLabel= lsLabel
	
//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	llLabelPos ++
	
	//We can print 4 on a label, print new label if more
	If llLabelPos > 4 Then
		
		llPrintJob = PrintOpen(lsPrintText)
	
		If llPrintJob <0 Then 
			Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
			Return
		End If

		PrintSend(llPrintJob, lsCurrentLabel)	
		PrintClose(llPrintJob)
	
		llLabelPos = 1
		
		//load current label from the template 
		lsCurrentLabel= lsLabel
		
	End If /*previous label full*/
	
	lsField = "sku_" + string(llLabelPos)
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~" + lsField + "~~",dw_label.GetITemString(llRowPos,'sku')) /* Part*/
	
	lsField = "qty_" + string(llLabelPos)
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~" + lsField + "~~",String(dw_label.GetITemNumber(llRowPos,'qty'),'###00')) /* Qty*/
		
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~rma_number~~",dw_label.GetITEmString(llRowPos,'rma_nbr')) /* RMA Nbr*/
		
				
Next /*detail row to Print*/

//Print last/only
If lsCurrentLabel > '' Then
	
	//remove any empy rows so we dont print any extra barcodes...
	Do While Pos(lsCurrentLabel,"sku_2") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"sku_2") - 45)) /*will position us to find the beginning of the row*/
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) /*End of the row*/
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
	Loop
	
	Do While Pos(lsCurrentLabel,"qty_2") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"qty_2") - 45)) 
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) 
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
	Loop
		
	Do While Pos(lsCurrentLabel,"sku_3") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"sku_3") - 45)) 
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) 
		
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
		
	Loop
	
	Do While Pos(lsCurrentLabel,"qty_3") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"qty_3") - 45)) 
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) 
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
	Loop
	
	Do While Pos(lsCurrentLabel,"sku_4") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"sku_4") - 45)) 
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) 
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
	Loop
	
	Do While Pos(lsCurrentLabel,"qty_4") > 0
		
		llStartPos = Pos(lsCurrentLabel,"^FO",(Pos(lsCurrentLabel,"qty_4") - 45)) 
		llEndPos =   Pos(lsCurrentLabel,"^FS",llStartPos) 
		If llStartPos > 0 Then
			lsCurrentLabel = Replace(lsCurrentLabel,llStartPos, (llEndPos - llStartPos) + 2,'')
		End If
	Loop
	
	llPrintJob = PrintOpen(lsPrintText)
	
	If llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return
	End If

	PrintSend(llPrintJob, lsCurrentLabel)	
	PrintClose(llPrintJob)
	
End If /*LAst/Only label */










end event

on w_pandora_rma_label.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_1
end on

on w_pandora_rma_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_1)
end on

event ue_postopen;call super::ue_postopen;

cb_print.Enabled = False

//Must be open to an Outbound Order 
If not isvalid(w_do) Then
	Messagebox("RMA Labels","You must have an Outbound Order Open to print RMA Labels.",StopSign!)
	Return
End If

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
Long	llRowCount, llRowPos, llNewRow


//Insert a row for Detail Row (SKU/Qty)

llRowCount = w_do.idw_detail.rowCount()
For llRowPos = 1 to llRowCount
	
	llNewRow = dw_Label.InsertRow(0)
	dw_Label.SetITem(llNewRow,'rma_nbr',w_do.idw_Main.GetItemString(1,'User_Field4'))
	dw_Label.SetITem(llNewRow,'SKU',w_do.idw_detail.GetITemString(llRowPos,'SKU'))
	
	//Take from allocated qty if present, otherwise requested
	If w_do.idw_detail.GetITemNumber(llRowPos,'alloc_Qty') > 0 Then
		dw_Label.SetITem(llNewRow,'qty',w_do.idw_detail.GetITemNumber(llRowPos,'alloc_Qty'))
	Else
		dw_Label.SetITem(llNewRow,'qty',w_do.idw_detail.GetITemNumber(llRowPos,'req_Qty'))
	End If
	
	dw_label.SetItem(llNewRow,'c_print_ind','Y')
		
Next /*Detail Row */

cb_print.Enabled = True
end event

event resize;call super::resize;
dw_label.Resize(workspacewidth() - 50,workspaceHeight()-300)
end event

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pandora_rma_label
boolean visible = false
integer x = 2373
integer y = 1408
integer height = 100
end type

type cb_ok from w_main_ancestor`cb_ok within w_pandora_rma_label
integer x = 1275
integer y = 56
integer height = 84
boolean default = false
end type

type cb_print from commandbutton within w_pandora_rma_label
integer x = 640
integer y = 56
integer width = 270
integer height = 84
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

type dw_label from u_dw_ancestor within w_pandora_rma_label
event ue_check_enable ( )
integer x = 41
integer y = 196
integer width = 1755
integer height = 984
boolean bringtotop = true
string dataobject = "d_pandora_rma_label"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_check_enable;
If This.Find("c_print_ind = 'Y'",1,This.RowCount()) <= 0 Then
	cb_Print.Enabled = False
End If
end event

event itemchanged;call super::itemchanged;
If dwo.Name = 'c_print_ind' Then
	If data = 'Y' Then
		cb_Print.Enabled = True
	Else
		This.PostEvent('ue_check_enable')
	End If
End If
end event

event sqlpreview;call super::sqlpreview;
//Messagebox('??',sqlsyntax)
end event

type cb_selectall from commandbutton within w_pandora_rma_label
integer x = 64
integer y = 8
integer width = 334
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All"
end type

event clicked;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','Y')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = True

end event

type cb_1 from commandbutton within w_pandora_rma_label
integer x = 64
integer y = 100
integer width = 334
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear All"
end type

event clicked;Long	llRowPos,	&
		llRowCount

		
dw_label.SetRedraw(False)

llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	dw_label.SetITem(llRowPos,'c_print_ind','N')
Next

dw_label.SetRedraw(True)

cb_print.Enabled = False

end event

