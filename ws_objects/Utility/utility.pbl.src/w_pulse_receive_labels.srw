$PBExportHeader$w_pulse_receive_labels.srw
$PBExportComments$Pulse Receiving Labels
forward
global type w_pulse_receive_labels from w_main_ancestor
end type
type cb_print from commandbutton within w_pulse_receive_labels
end type
type dw_label from u_dw_ancestor within w_pulse_receive_labels
end type
type cb_selectall from commandbutton within w_pulse_receive_labels
end type
type cb_1 from commandbutton within w_pulse_receive_labels
end type
type rb_rono from radiobutton within w_pulse_receive_labels
end type
type rb_container from radiobutton within w_pulse_receive_labels
end type
type sle_retrieve from singlelineedit within w_pulse_receive_labels
end type
type st_1 from statictext within w_pulse_receive_labels
end type
type gb_1 from groupbox within w_pulse_receive_labels
end type
end forward

global type w_pulse_receive_labels from w_main_ancestor
integer width = 3410
integer height = 1852
string title = "Pulse Receiving Labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_1 cb_1
rb_rono rb_rono
rb_container rb_container
sle_retrieve sle_retrieve
st_1 st_1
gb_1 gb_1
end type
global w_pulse_receive_labels w_pulse_receive_labels

type variables

n_labels	invo_labels

String	isOrigSQL
end variables

event ue_print;Str_Parms	lstrparms
Long	llQty,	&
		llRowCount,	&
		llRowPos
		
Any	lsAny

String	lsFormat,	&
			lsUOM
Integer	liRC

Dw_Label.AcceptText()

//Check for Duplicate Container ID's
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount
	If (dw_label.GetItemString(llRowPos,'container_ID') <> '-') and llRowPos < dw_label.RowCount() Then
		If dw_label.Find("Upper(Container_ID) = '" + Upper(dw_label.GetItemString(llRowPos,'container_ID')) + "'", (llRowPos + 1), (dw_label.RowCount() + 1)) > 0 Then
			If MessageBox('Labels', "Duplicate Container IDs Found! Do you want to continue?", Question!,YesNo!,2) = 2 Then
				Return 
			Else
				Exit
			End If
		End If
	End If
Next

//Load the format - only need to retrieve once - will pass to print routine
lsFormat = invo_labels.uf_read_label_Format("Pulse_Zebra_Receive.DWN")

//Format not loaded
If lsFormat = '' Then Return

//Get printer and Qty
lstrparms.String_arg[1] = "Pulse Receiving Label"
lstrparms.Long_arg[1] = 1 /*default qty on print options*/
OpenWithParm(w_label_print_options,lStrParms)

Lstrparms = Message.PowerObjectParm
If lstrParms.Cancelled Then Return

llQty = Lstrparms.Long_arg[1] /*Number of copies from Setup window*/
	
//Print each detail Row 
llRowCount = dw_label.RowCount()

For llRowPos = 1 to llRowCount /*each detail row */
	
	//If not selected for Printing, continue with next row
	If dw_label.GetITemString(llRowPos,'c_Print_Ind') <> 'Y' Then Continue
	
	lstrparms.String_arg[1] = lsFormat /*Zebra zpl file */
	LstrParms.String_arg[2] = dw_label.GetItemString(llRowPos,'Ship_Ref') /* Reference # */ 
	LstrParms.String_arg[3] = dw_label.object.c_exp_date[llRowPos] /* Exp DAte*/ 
	LstrParms.String_arg[4] = dw_label.GetItemString(llRowPos,'USer_field3') /* Inspection Cd */
	LstrParms.String_arg[5] = dw_label.GetItemString(llRowPos,'storage_code') /* Inspection Cd */
	If isnull(dw_label.GetItemString(llRowPos,'UOM')) Then
		lsUOM = 'EA'
	Else
		lsUOM = dw_label.GetItemString(llRowPos,'UOM')
	End If
	LstrParms.String_arg[6] = String(dw_label.GetItemNumber(llRowPos,'quantity'),'#######.#####') + ' ' + lsUOM /*Qty /UOM*/
	LstrParms.String_arg[7] = dw_label.GetItemString(llRowPos,'SKU') /* SKU */
	LstrParms.String_arg[8] = dw_label.GetItemString(llRowPos,'supp_invoice_no') /* PO Nbr */
	LstrParms.String_arg[9] = dw_label.GetItemString(llRowPos,'lot_no') /* ID #*/ 
	LstrParms.String_arg[10] = dw_label.GetItemString(llRowPos,'container_Id') /* Container ID */
	
	lStrparms.Long_arg[1] = llQty /*Copies to Print*/
	
	lsAny = lstrparms
	
	liRC = invo_labels.uf_pulse_zebra_receive(lsAny)
	If liRC < 0 Then Exit
	
Next /*detail row to Print*/











end event

on w_pulse_receive_labels.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.dw_label=create dw_label
this.cb_selectall=create cb_selectall
this.cb_1=create cb_1
this.rb_rono=create rb_rono
this.rb_container=create rb_container
this.sle_retrieve=create sle_retrieve
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.dw_label
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.rb_rono
this.Control[iCurrent+6]=this.rb_container
this.Control[iCurrent+7]=this.sle_retrieve
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_pulse_receive_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_print)
destroy(this.dw_label)
destroy(this.cb_selectall)
destroy(this.cb_1)
destroy(this.rb_rono)
destroy(this.rb_container)
destroy(this.sle_retrieve)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels

cb_print.Enabled = False

isOrigSQL = dw_label.GetSQLSelect()

If istrParms.String_arg[1] = 'A' Then /*Coming from Stock Adjustment*/
	
		rb_container.Checked = True
		sle_retrieve.Text = Istrparms.String_arg[2] /*list of containers that have changed*/
			
		This.TriggerEvent('ue_retrieve')
	
ElseIf isValid(w_ro) Then /*Coming from menu, see if Receive Order is open */
	
	if w_ro.idw_main.rowCount() > 0 Then
		
		rb_roNo.Checked = True
		sle_retrieve.Text = w_ro.idw_main.getITemString(1,'ro_no')
		This.TriggerEvent('ue_retrieve')
		
	End If
		
Else
	
	rb_Container.Checked = True
		
End If



end event

event ue_retrieve;call super::ue_retrieve;String	lsOrder,	&
			lsDONO,	&
			lsWhere,	&
			lsNewSQL,	&
			lsRetrieveVal,	&
			lsTemp

Long		llRowCount,	&
			llRowPos

cb_print.Enabled = False

//Modify SQL to retrieve by Sys Number (RONO) or Container ID

lsWhere = " and Receive_MASter.Project_id = '" + gs_Project + "'" /*always tackon project */

lsRetrieveVal = sle_Retrieve.Text

//Values in "IN" (for multiple values) statement must have quotes areound Values
If Pos(lsRetrieveVal,',') = 0 Then /*only one Value*/
	lsRetrieveVal = "'" + lsRetrieveVal + "'"
Else /*mult values - add quotes around each value*/
	lsTemp = sle_Retrieve.Text
	lsRetrieveVAl = ''
	Do While Pos(lsTemp,',') > 0
		lsRetrieveVal += " '" + Left(lsTemp,(Pos(lsTemp,',') - 1)) + "', "
		lsTemp = Trim(Right(lsTemp,(len(lsTemp) - Pos(lsTemp,','))))
	Loop
	lsRetrieveVal += "'" + Trim(lsTemp) + "'" /*last one*/
End If

//If retrieving by RoNO, tackon RONO
If rb_rono.Checked Then
	lsWhere += " and Receive_Master.ro_no In (" + lsRetrieveVal + ")"
Else /*retrieving by Container */
	lsWhere += " and Receive_Putaway.Container_ID In (" + lsRetrieveVal + ")"
End If

lsNewSQL = isOrigSql + lsWhere

//If retrieving by Container, take from Content instead of Putaway (new containers won't exist in Putaway)
//change all joins on Receive_Putaway to Content
If rb_container.Checked Then
	
	Do While Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY'), 15, 'Content')
	Loop
	
	lsNewSQL = Replace(lsNewSQL,Pos(lsNewSQL,'(Receive_Detail.Line_Item_No = Content.Line_Item_No) and'), 64, '') /*No join to Line Item in Content*/
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'QUANTITY'), 8, 'Avail_Qty') /*content qty field is named different then Putaway*/
	lsNEwSql += " and Content.Project_id = '" + gs_Project + "'" /*optimize query a little more */
End If

dw_label.SetSqlSelect(lsNewSQL)
dw_label.Retrieve()

If dw_label.RowCOunt() > 0 Then
Else
	Messagebox('Labels','No records found!')
	Return
End If

cb_print.Enabled = True
end event

event resize;call super::resize;
dw_label.Resize(workspacewidth() - 50,workspaceHeight()-300)
end event

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_pulse_receive_labels
boolean visible = false
integer x = 2373
integer y = 1408
integer height = 100
end type

type cb_ok from w_main_ancestor`cb_ok within w_pulse_receive_labels
integer x = 3026
integer y = 128
integer height = 84
boolean default = false
end type

type cb_print from commandbutton within w_pulse_receive_labels
integer x = 3026
integer y = 24
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

type dw_label from u_dw_ancestor within w_pulse_receive_labels
event ue_check_enable ( )
integer x = 41
integer y = 252
integer width = 3310
integer height = 1380
boolean bringtotop = true
string dataobject = "d_pulse_receive_label"
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

type cb_selectall from commandbutton within w_pulse_receive_labels
integer x = 2587
integer y = 24
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
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

type cb_1 from commandbutton within w_pulse_receive_labels
integer x = 2587
integer y = 128
integer width = 379
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
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

type rb_rono from radiobutton within w_pulse_receive_labels
integer x = 142
integer y = 68
integer width = 489
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Sys Number:"
borderstyle borderstyle = stylelowered!
end type

event clicked;
sle_retrieve.Text = ''
dw_label.Reset()
end event

type rb_container from radiobutton within w_pulse_receive_labels
integer x = 142
integer y = 136
integer width = 425
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "&Container:"
borderstyle borderstyle = stylelowered!
end type

event clicked;sle_retrieve.Text = ''
dw_label.Reset()
end event

type sle_retrieve from singlelineedit within w_pulse_receive_labels
integer x = 677
integer y = 72
integer width = 1819
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
parent.TriggerEvent('ue_retrieve')
end event

type st_1 from statictext within w_pulse_receive_labels
integer x = 905
integer y = 176
integer width = 1120
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Enter Multiple values separated by Commas"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pulse_receive_labels
integer x = 55
integer width = 599
integer height = 224
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Print By"
borderstyle borderstyle = stylelowered!
end type

