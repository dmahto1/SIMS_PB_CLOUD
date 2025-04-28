HA$PBExportHeader$w_pandora_cb_box_label.srw
$PBExportComments$Print Pandora CityBlock Box Labels
forward
global type w_pandora_cb_box_label from w_main_ancestor
end type
type cb_print from commandbutton within w_pandora_cb_box_label
end type
type dw_label from u_dw_ancestor within w_pandora_cb_box_label
end type
type cb_selectall from commandbutton within w_pandora_cb_box_label
end type
type cb_1 from commandbutton within w_pandora_cb_box_label
end type
end forward

global type w_pandora_cb_box_label from w_main_ancestor
integer width = 2171
integer height = 1400
string title = "City Block Box Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_1 cb_1
end type
global w_pandora_cb_box_label w_pandora_cb_box_label

type variables



String	isOrigSQL
end variables

event ue_print();Str_Parms	lstrparms
n_labels	lu_labels

Long	llQty,llRowCount,	llRowPos, llSerialPos, &
		ll_rtn, llPrintJob, llFindRow
		
Any	lsAny

String	lsformat, lsFormatSave, lsPrinter, lsLabel, lsLabelPrint, lsPrintText, lsSKU, lsSKUSave, lsDesc, &
			lsCurrentLabel, lsCreateIn, lsSerialPos, lsBoxID, lsFind, lsInvType, lsInvTypeSave, lsColor
Integer	liMsg


lu_labels = Create n_labels

Dw_Label.AcceptText()


lsformat = "Pandora_cb_Carton.Txt"
lsLabel = lu_labels.uf_read_label_Format(lsFormat)
If lsLabel = "" Then Return

OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then
	Return
End If
	
	
//Print each detail Row
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
			
	If dw_label.GetITEmString(llRowPos,'c_print_ind') <> 'Y' Then Continue
	
	lsSKU = dw_label.GetITemString(llRowPos,'sku')
	lsBOXID = dw_label.GetITemString(llRowPos,'container_ID')
	lsInvType = dw_label.GetITemString(llRowPos,'inv_type')
	
	//load current label from the template (we can resuse template until format changes)
	lsCurrentLabel= lsLabel
		
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id~~",dw_label.GetITemString(llRowPos,'container_id')) /* Box ID*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Carton_id_barcode~~",dw_label.GetITemString(llRowPos,'container_id')) /* Barcoded Box ID*/
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU~~",lsSKU) /* Part*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~SKU_Barcode~~",lsSKU) /* Barcoded Part*/
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Qty~~",String(dw_label.GetITemNumber(llRowPos,'qty'))) /* Qty*/
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~qty_barcode~~",String(dw_label.GetITemNumber(llRowPos,'qty'))) /* Qty Barcoded*/
		
	//Retrieve Desc if SKU changed
	If lsSKUSave <> lsSKU Then
		
		Select Description into :lsDesc
		From Item_Master
		Where project_Id = 'Pandora' and sku = :lsSKU and supp_Code = 'Pandora';
			
		lsSKUSave = lsSKU
		
	End If
	
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~Description~~",lsDesc) /* Description*/
		
	
	// Created In - Hardcoded against warehouse for now
	Choose Case Upper(w_ro.idw_Main.GetITEmString(1,'wh_code'))
			
		Case "PND_BRUSSH", "PND_BRUSSW" /*Belgium*/
			lsCreateIn = "BE"
		Case "PND_DALLES"
			lsCreateIn = "OR"
		Case Else
			lsCreateIn = ""
	End Choose
				
	lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~created_in~~",lsCreateIn) /* Created IN (Belgium or Oregon)*/
	
	//Label Title based on Inventory Type
	If lsInvType = 'W' Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~label_title~~","  CITYBLOCK STAGED DRIVES - BOX ID")
	Elseif lsInvType = 'Z' Then
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~label_title~~","  CITYBLOCK EMPTY DRIVES - BOX ID")
	End If
	
	//Serial Numbers - first 20 per carton (shouldn't be more)
	llSerialPos = 0
	lsFind = "Upper(SKU) = '" + upper(lsSKU) + "' and Upper(Container_ID) = '" + upper(lsBoxID) + "'"
	llFindRow = w_ro.idw_Putaway.Find(lsFind, 1, w_ro.idw_Putaway.RowCount())
	Do While llFindRow > 0
		
		llSerialPos ++
		lsSerialPos = "serial_" + string(llSerialPos)
		lsCurrentLabel = lu_labels.uf_replace(lsCurrentLabel,"~~" + lsSerialPos + "~~","(" + string(llSerialPos) + ") " + w_ro.idw_Putaway.GetITemString(llFindRow,'Serial_no')) /* Serial*/
		
		llFindRow ++
		If llSerialPos > 20 or llFindRow > w_ro.idw_Putaway.RowCount() Then
			llFindRow = 0
		Else
			llFindRow = w_ro.idw_Putaway.Find(lsFind, llFindRow, w_ro.idw_Putaway.RowCount())
		End If
		
	Loop
	
	
	//Open Printer File 
	
	//Prompt for proper Color if Colr (Inv Type Changes)
	If lsInvType <> lsInvTypeSave Then
		
		if lsInvType = 'W' Then
			lsColor = 'ORANGE'
		elseif lsInvType = 'Z' Then
			lsColor = 'BLUE'
		End If
		
		If MessageBox("Check Label Stock","Please ensure that the " + lsColor + " label stock is loaded before continuing!",Exclamation!,OkCancel!,1) = 2 Then
			Exit
		End If
		
	End If
	
	llPrintJob = PrintOpen(lsPrintText)
	
	If llPrintJob <0 Then 
		Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
		Return
	End If

	PrintSend(llPrintJob, lsCurrentLabel)	
	PrintClose(llPrintJob)
		
	lsInvTypeSave = lsInvType
		
Next /*detail row to Print*/












end event

on w_pandora_cb_box_label.create
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

on w_pandora_cb_box_label.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_1)
end on

event ue_postopen;call super::ue_postopen;

cb_print.Enabled = False

//Must be open to an Inbound Order and Putaway List generated
If not isvalid(w_ro) Then
	Messagebox("Box Labels","You must have an Inbound Order Open to print Box Labels.",StopSign!)
	Return
End If

If w_ro.idw_Putaway.RowCount() < 1 Then
	Messagebox("Box Labels","You must generate the Putaway List before printing Box Labels.",StopSign!)
	Return
End If

This.TriggerEvent('ue_retrieve')
end event

event ue_retrieve;call super::ue_retrieve;
Long	llRowCount, llRowPos, llFindRow, llNewRow
String	lsSKU, lsBoxID, lsFind

//Insert a row for each Box (Container_ID)/SKU

llRowCount = w_ro.idw_Putaway.rowCount()
For llRowPos = 1 to llRowCount
	
	lsSKU = w_ro.Idw_Putaway.GetITemString(llRowPos,'SKU')
	lsBoxID = w_ro.Idw_Putaway.GetITemString(llRowPos,'Container_id')
	
	lsFind = "Upper(SKU) = '" + upper(lsSKU) + "' and Upper(Container_ID) = '" + Upper(lsBoxID) + "'"
	llFindRow = dw_label.Find(lsFind,1,dw_label.RowCount())
	
	If llFindRow > 0 Then /*add qty to existing row */
	
		dw_Label.SetITem(llFindRow,'qty',dw_label.GetItemNumber(llFindRow,'qty') + w_ro.Idw_Putaway.GetITemNumber(llRowPos,'quantity'))
		
	Else /* add a new row*/
		
		llNewRow = dw_Label.InsertRow(0)
		dw_Label.SetITem(llNewRow,'SKU',lsSKU)
		dw_Label.SetITem(llNewRow,'Container_ID',lsBoxID)
		dw_Label.SetITem(llNewRow,'qty',w_ro.Idw_Putaway.GetITemNumber(llRowPos,'quantity'))
		dw_Label.SetITem(llNewRow,'inv_type',w_ro.Idw_Putaway.GetITemString(llRowPos,'inventory_Type'))
		dw_label.SetItem(llNewRow,'c_print_ind','Y')
		
	End If
	
Next /*Putaway Row */

cb_print.Enabled = True
end event

event resize;call super::resize;
dw_label.Resize(workspacewidth() - 50,workspaceHeight()-300)
end event

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pandora_cb_box_label
boolean visible = false
integer x = 2373
integer y = 1408
integer height = 100
end type

type cb_ok from w_main_ancestor`cb_ok within w_pandora_cb_box_label
integer x = 1275
integer y = 56
integer height = 84
boolean default = false
end type

type cb_print from commandbutton within w_pandora_cb_box_label
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

type dw_label from u_dw_ancestor within w_pandora_cb_box_label
event ue_check_enable ( )
integer x = 41
integer y = 196
integer width = 2002
integer height = 984
boolean bringtotop = true
string dataobject = "d_pandora_cityblock_box_label"
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

type cb_selectall from commandbutton within w_pandora_cb_box_label
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

type cb_1 from commandbutton within w_pandora_cb_box_label
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

