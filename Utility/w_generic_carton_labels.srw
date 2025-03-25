HA$PBExportHeader$w_generic_carton_labels.srw
$PBExportComments$Print a generic barcoded carton label
forward
global type w_generic_carton_labels from w_main_ancestor
end type
type cb_label_print from commandbutton within w_generic_carton_labels
end type
type sle_start from singlelineedit within w_generic_carton_labels
end type
type st_1 from statictext within w_generic_carton_labels
end type
type sle_print_count from singlelineedit within w_generic_carton_labels
end type
type st_2 from statictext within w_generic_carton_labels
end type
end forward

global type w_generic_carton_labels from w_main_ancestor
integer width = 1569
integer height = 870
string title = "Shipping Labels"
event ue_print ( )
event ue_print_carton ( )
event ue_sort ( )
cb_label_print cb_label_print
sle_start sle_start
st_1 st_1
sle_print_count sle_print_count
st_2 st_2
end type
global w_generic_carton_labels w_generic_carton_labels

type variables

end variables

event ue_print_carton();

Str_Parms	lstrparms
Long	 llRowCount, llRowPos, llCartonNbr, llPrintJob
//Long ll_rowcount,ll_Findrow,ll_Nextrow,ll_sumQty,ll_carton_count
//Any	lsAny
String	lsformat, lsPrinter, lsFormatTemp
n_labels	ln_labels


ln_labels = Create n_labels

If not isNumber(sle_start.Text) Then
	Messagebox("","carton Number must be numeric",StopSign!)
	sle_start.SetFocus()
	sle_start.SelectText(1,999)
	return
End If

If not isNumber(sle_print_count.Text) Then
	Messagebox("","Print Count must be numeric",StopSign!)
	sle_print_count.SetFocus()
	sle_print_count.SelectText(1,999)
	return
End If

If len(sle_start.Text) > 9 Then
	Messagebox("","Starting Carton Number must be < 999999999",StopSign!)
	sle_start.SetFocus()
	sle_start.SelectText(1,999)
	return
End If

//Load the template
lsformat = ln_labels.uf_read_label_Format('generic_carton_zebra.txt') 

//  If we have a default printer for Kendo Labels, Load now
lsPrinter = ProfileString(gs_iniFile,'PRINTERS','GENERICCARTONLABELS','')
If lsPrinter > '' Then PrintSetPrinter(lsPrinter)
 	
OpenWithParm(w_label_print_options,lStrParms)
Lstrparms = Message.PowerObjectParm		  
If lstrParms.Cancelled Then Return 

//Open Printer File 
llPrintJob = PrintOpen("")

If llPrintJob <0 Then 
	Messagebox('Labels', 'Unable to open Printer file. Labels will not be printed')
	Return 
End If

sle_start.Enabled = False
sle_print_count.Enabled = False
cb_label_print.Enabled = False


//Print each detail Row 

llCartonNbr = Long(sle_start.Text) - 1 /* will get bumped back up on first loop*/
llRowCount = Long(sle_print_count.Text)

For llRowPos = 1 to llRowCount /*each detail row */
	
	SetMicroHelp("Printing Label " + String(llRowPos) + " of " + String(llRowCount))
	
	llCartonNbr ++
	
	If llCartonNbr > 999999999 Then
		llcartonNbr = 100000001
	End If
	
	lsFormatTemp = lsFormat
	
	lsFormatTemp = ln_labels.uf_Replace(lsFormatTemp,"~~carton_no~~",String(llCartonNbr))
	
	PrintSend(llPrintJob, lsFormatTemp)	
	
Next /*detail row to Print*/

PrintClose(llPrintJob)

//Save the Next Starting label to the DB
llCartonNbr ++

Update  Next_Sequence_no
Set next_avail_Seq_No =  :llCartonNbr
Where Project_id = :gs_project and Table_Name= "Delivery_Packing" and column_Name = 'Carton_No' ;


sle_start.Text = String(llCartonNbr)

sle_start.Enabled = True
sle_print_count.Enabled = True
cb_label_print.Enabled = True
SetMicroHelp("Ready")

// We want to store the last printer used for Printing the Kendo label for defaulting later
lsPrinter = PrintGetPrinter()
SetProfileString(gs_inifile,'PRINTERS','GENERICCARTONLABELS',lsPrinter)

end event

on w_generic_carton_labels.create
int iCurrent
call super::create
this.cb_label_print=create cb_label_print
this.sle_start=create sle_start
this.st_1=create st_1
this.sle_print_count=create sle_print_count
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_label_print
this.Control[iCurrent+2]=this.sle_start
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_print_count
this.Control[iCurrent+5]=this.st_2
end on

on w_generic_carton_labels.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_label_print)
destroy(this.sle_start)
destroy(this.st_1)
destroy(this.sle_print_count)
destroy(this.st_2)
end on

event ue_postopen;call super::ue_postopen;
Long	ldStartingCartonNbr

//Get the Starting Label form the DB

Select next_avail_Seq_No into :ldStartingCartonNbr
From Next_Sequence_no
Where Project_id = :gs_project and Table_Name= "Delivery_Packing" and column_Name = 'Carton_No' ;

//ldStartingCartonNbr = 100000001 /*temp*/
sle_start.Text = String(ldStartingCartonNbr)

end event

event ue_retrieve;call super::ue_retrieve;//String		lsWhere, lsModify, lsNewSql
//Long		llPos
//
//
//
//cb_label_print.Enabled = False
//
////If coming from W_DO, retrieve for DO_NO, If coming from batch_pick, retrieve for all DO_No's for BAtch Pick ID
//If isValid(W_DO) Then
//	lsWhere = " and Delivery_Master.do_no = '" + w_do.idw_main.GetITemString(1,'do_no') + "' "
//Else /* batch Pick*/
//	lsWhere = " and Delivery_Master.do_no in (select do_no from Delivery_Master where Project_id = '" + gs_Project + "'  and batch_pick_id = " + String(w_batch_Pick.idw_Master.GetItemNumber(1,'batch_pick_id')) + ") "
//End If
//
//lsNewSql  = is_sql
//
//llPos = Pos(lsNewSql,'Group By')
//
//If llPos > 0 Then
//	lsNewSql = replace(lsNewSql,llPos - 1,1,lsWhere)
//End If
//
//lsModify = 'DataWindow.Table.Select="' + lsNewSQL + '"'
//dw_label.Modify(lsModify)	
//
//dw_label.Retrieve()
//
////If isdono > '' Then
////	dw_label.Retrieve(gs_project,isdono)
////End If
//
//
//If dw_label.RowCOunt() > 0 Then
//Else
//	Messagebox('Labels','Order Not found or Packing List not yet generated!')
//	Return
//End If
//
//
//
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_generic_carton_labels
boolean visible = false
integer x = 1068
integer y = 474
integer height = 80
end type

type cb_ok from w_main_ancestor`cb_ok within w_generic_carton_labels
integer x = 688
integer y = 474
integer height = 80
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_label_print from commandbutton within w_generic_carton_labels
integer x = 252
integer y = 470
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

event clicked;Parent.Triggerevent( 'ue_print_carton')
end event

event constructor;
g.of_check_label_button(this)
end event

type sle_start from singlelineedit within w_generic_carton_labels
integer x = 680
integer y = 106
integer width = 483
integer height = 83
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;
If not isNumber(this.Text) Then
	Messagebox("","carton Number must be numeric",StopSign!)
	sle_start.SetFocus()
	sle_start.SelectText(1,999)
End If

If len(this.Text) > 9 Then
	Messagebox("","Starting Carton Number must be < 999999999",StopSign!)
	sle_start.SetFocus()
	sle_start.SelectText(1,999)
End If
end event

type st_1 from statictext within w_generic_carton_labels
integer x = 106
integer y = 118
integer width = 512
integer height = 61
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Starting Ctn Nbr:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_print_count from singlelineedit within w_generic_carton_labels
integer x = 680
integer y = 205
integer width = 318
integer height = 83
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;If not isNumber(this.Text) Then
	Messagebox("","Print Count must be numeric",StopSign!)
	sle_print_count.SetFocus()
	sle_print_count.SelectText(1,999)
End If
end event

type st_2 from statictext within w_generic_carton_labels
integer x = 29
integer y = 218
integer width = 589
integer height = 61
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "# of labels to Print:"
alignment alignment = right!
boolean focusrectangle = false
end type

