HA$PBExportHeader$w_workorder_text.srw
$PBExportComments$- Maintain WorkOrder Text
forward
global type w_workorder_text from w_response_ancestor
end type
type sle_new_text from singlelineedit within w_workorder_text
end type
type dw_avail from u_dw_ancestor within w_workorder_text
end type
type dw_selected from u_dw_ancestor within w_workorder_text
end type
type cb_add from commandbutton within w_workorder_text
end type
type cb_delete from commandbutton within w_workorder_text
end type
type st_avail_ins from statictext within w_workorder_text
end type
type st_wo_selected_ins_for_current_wo from statictext within w_workorder_text
end type
type cb_delete_avail from commandbutton within w_workorder_text
end type
type pb_sel_all from picturebutton within w_workorder_text
end type
type pb_clear_all from picturebutton within w_workorder_text
end type
end forward

global type w_workorder_text from w_response_ancestor
integer width = 3374
integer height = 1928
string title = "Work Order Instructions"
sle_new_text sle_new_text
dw_avail dw_avail
dw_selected dw_selected
cb_add cb_add
cb_delete cb_delete
st_avail_ins st_avail_ins
st_wo_selected_ins_for_current_wo st_wo_selected_ins_for_current_wo
cb_delete_avail cb_delete_avail
pb_sel_all pb_sel_all
pb_clear_all pb_clear_all
end type
global w_workorder_text w_workorder_text

on w_workorder_text.create
int iCurrent
call super::create
this.sle_new_text=create sle_new_text
this.dw_avail=create dw_avail
this.dw_selected=create dw_selected
this.cb_add=create cb_add
this.cb_delete=create cb_delete
this.st_avail_ins=create st_avail_ins
this.st_wo_selected_ins_for_current_wo=create st_wo_selected_ins_for_current_wo
this.cb_delete_avail=create cb_delete_avail
this.pb_sel_all=create pb_sel_all
this.pb_clear_all=create pb_clear_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_new_text
this.Control[iCurrent+2]=this.dw_avail
this.Control[iCurrent+3]=this.dw_selected
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.st_avail_ins
this.Control[iCurrent+7]=this.st_wo_selected_ins_for_current_wo
this.Control[iCurrent+8]=this.cb_delete_avail
this.Control[iCurrent+9]=this.pb_sel_all
this.Control[iCurrent+10]=this.pb_clear_all
end on

on w_workorder_text.destroy
call super::destroy
destroy(this.sle_new_text)
destroy(this.dw_avail)
destroy(this.dw_selected)
destroy(this.cb_add)
destroy(this.cb_delete)
destroy(this.st_avail_ins)
destroy(this.st_wo_selected_ins_for_current_wo)
destroy(this.cb_delete_avail)
destroy(this.pb_sel_all)
destroy(this.pb_clear_all)
end on

event ue_postopen;call super::ue_postopen;
Istrparms = Message.PowerobJectParm

//Retrieve available and currently selected

dw_avail.Retrieve(gs_project)
dw_selected.Retrieve(gs_project,Istrparms.String_arg[1])


sle_new_Text.SetFocus()
end event

event closequery;call super::closequery;
//Save Changes

Integer	liRC
String	lsErrTExt

If Not Istrparms.Cancelled Then
	
	Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

	liRC = dw_avail.Update()
	If liRC = 1 then dw_selected.Update()

	IF (liRC = 1) THEN
		Execute Immediate "COMMIT" using SQLCA;
		IF Sqlca.Sqlcode = 0 THEN
			SetMicroHelp("Record Saved!")
  		 ELSE
			lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
			Execute Immediate "ROLLBACK" using SQLCA;
     	 	MessageBox('BOM Text', "Unable to save BOM Text Changes!~r~r" + lsErrText)
			Return 1
	 	END IF
	ELSE
		lsErrText = sqlca.sqlerrtext /*text will be lost after rollback*/
	  	Execute Immediate "ROLLBACK" using SQLCA;
		SetMicroHelp("Save failed!")
		MessageBox('BOM Text', "Unable to save BOM Text Changes!~r~r" + lsErrText)
		Return 1
	END IF
	
End If /*Not cancelled */

MEssage.PowerObjectParm = IstrParms
end event

event open;call super::open;
if  Upper(gs_project) = 'CHINASIMS' then
	
	sle_new_text.text = '$$HEX9$$2857d98fcc91fb6da052b0658476f48b0e66$$ENDHEX$$'
	
end if
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_workorder_text
integer x = 1641
integer y = 1712
end type

event cb_cancel::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type cb_ok from w_response_ancestor`cb_ok within w_workorder_text
integer x = 1225
integer y = 1712
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
g.of_check_label_button(this)
end event

type sle_new_text from singlelineedit within w_workorder_text
string tag = "Add new instructions here..."
integer x = 37
integer y = 44
integer width = 2775
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Add new Instruction here..."
borderstyle borderstyle = stylelowered!
end type

event getfocus;
This.SelectText(1,len(this.Text))
end event

event modified;String	lsText
Long	llFindRow,	&
		llNExtID,	&
		llNewRow

//Make sure we don't already have this ID, If we don't add it

lsText = This.Text

llFindRow = dw_avail.Find("Upper(bom_text) = '" + Upper(lsText) + "'",1,dw_avail.RowCount())

If llFindRow > 0 Then
	dw_avail.SetRow(llFindRow)
	dw_avail.ScrollToRow(llFindRow)
	dw_selected.SetRow(dw_selected.RowCount()) /*insert at end*/
	dw_selected.PostEvent('ue_insert')
Else /*Add a new Row*/
	
	//Get the Next Available ID
	llNextID = g.of_next_db_seq(gs_project,'BOM_Text','BOM_Text_ID')
	If llNextID <= 0 Then
		messagebox('BOM Instructions',"Unable to retrieve the next available BOM Text ID!~rUnable to Insert a New Instruction.")
		Return
	End If
	
	llNewRow = dw_avail.InsertRow(0)
	dw_avail.SetItem(llNewRow,'Project_ID',gs_project)
	dw_avail.SetItem(llNewRow,'bom_text_id',string(llNextID))
	dw_avail.SetItem(llNewRow,'bom_Text',lsText)
	dw_avail.SetRow(llNewRow)
	dw_selected.SetRow(dw_selected.RowCount()) /*insert at end*/
	dw_selected.TriggerEvent('ue_insert')
	
End If

This.Text = ''
This.SetFocus()


end event

type dw_avail from u_dw_ancestor within w_workorder_text
integer x = 32
integer y = 264
integer width = 1467
integer height = 1360
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_workorder_text_avail"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_add.Enabled = True
END IF
end event

type dw_selected from u_dw_ancestor within w_workorder_text
event ue_resequence ( )
event ue_select_all ( )
event ue_clear_all ( )
integer x = 1783
integer y = 264
integer width = 1554
integer height = 1360
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_workorder_text_selected"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_resequence;
Long	llRowCount,	&
		llRowPos
	
	
llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'seq_no',llRowPos)
Next
end event

event ue_select_all;//Copy all rows from Available

Long ll_row,			&
		llAvailCount,	&
		llAvailPos

This.SetFocus()
If This.AcceptText() = -1 Then Return

This.TriggerEvent('ue_clear_all')/*clear existing rows */

This.SetRedraw(False)

llAvailCount = dw_avail.RowCOunt()

For llAvailPos = 1 to llAvailCount
	ll_row = This.InsertRow(0)
	This.SetITem(ll_row,'wo_no',istrparms.String_arg[1])
	This.SetITem(ll_row,'project_id',gs_project)
	This.SetITem(ll_row,'bom_text_id',dw_avail.GetITemString(llAvailPos,'bom_text_id'))
	This.SetITem(ll_row,'bom_text',dw_avail.GetITemString(llAvailPos,'bom_text'))
Next

//Resequence
This.TriggerEvent('ue_resequence')

This.SetRedraw(True)





end event

event ue_clear_all;
//Clear all rows

Long	llRowCount, llRowPos

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = llRowCount to 1 step - 1
	This.DEleteRow(llRowPos)
Next

This.SetRedraw(True)
end event

event clicked;call super::clicked;
If This.GetRow() > 0 Then
	cb_delete.Enabled = True
End If
end event

event ue_insert;call super::ue_insert;Long ll_row

This.SetFocus()
If This.AcceptText() = -1 Then Return

ll_row = This.GetRow()

If ll_row > 0 Then
	ll_row = This.InsertRow(ll_row + 1)
	This.ScrollToRow(ll_row)	
Else
	ll_row = This.InsertRow(0)
End If	

This.SetITem(ll_row,'wo_no',istrparms.String_arg[1])
This.SetITem(ll_row,'project_id',gs_project)
This.SetITem(ll_row,'bom_text_id',dw_avail.GetITemString(dw_avail.GetRow(),'bom_text_id'))
This.SetITem(ll_row,'bom_text',dw_avail.GetITemString(dw_avail.GetRow(),'bom_text'))

//Resequence
This.TriggerEvent('ue_resequence')





end event

event ue_delete;call super::ue_delete;
If this.GetRow() > 0 Then
	This.DEleteRow(This.GetRow())
	This.TriggerEvent('ue_resequence')
End If
end event

type cb_add from commandbutton within w_workorder_text
integer x = 1563
integer y = 640
integer width = 165
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = ">>>"
end type

event clicked;
dw_selected.TriggerEvent('ue_insert')
end event

type cb_delete from commandbutton within w_workorder_text
integer x = 1563
integer y = 820
integer width = 165
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "<<<"
end type

event clicked;
dw_selected.TriggerEvent('ue_delete')
end event

type st_avail_ins from statictext within w_workorder_text
integer x = 73
integer y = 192
integer width = 731
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Available Instructions"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type st_wo_selected_ins_for_current_wo from statictext within w_workorder_text
integer x = 1801
integer y = 192
integer width = 1253
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Selected Instructions for Current WO"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_avail from commandbutton within w_workorder_text
integer x = 293
integer y = 1712
integer width = 311
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;Long	llRow,	&
		llCount
		
String	lsTextID

//Make sure it's not being used before deleting

llRow = dw_avail.GetRow()

If llRow <=0 Then Return

lsTextID = dw_avail.GetITemString(llRow,'bom_text_id')

SElect COunt(*) into :llCount
From Workorder_bom_text
Where Project_id = :gs_Project and bom_text_id = :lsTextID;

If llCount > 0 or dw_selected.Find("bom_text_id = '" + lsTextID + "'",1,dw_selected.RowCOunt()) > 0 Then
	Messagebox('BOM Text','This Text can not be deleted because it is on one or more Work Orders!')
	Return
Else
	If MessageBox('Confirm Delete','Are you sure you want to delete this BOM Instruction?',Question!,YesNo!,2) = 1 Then
		dw_avail.DeleteRow(llRow)
	End If
End If


end event

event constructor;
g.of_check_label_button(this)
end event

type pb_sel_all from picturebutton within w_workorder_text
integer x = 1527
integer y = 1052
integer width = 233
integer height = 224
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All   >>>"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;
dw_selected.TriggerEvent('ue_select_all')
end event

event constructor;
g.of_check_label_button(this)
end event

type pb_clear_all from picturebutton within w_workorder_text
integer x = 1527
integer y = 1316
integer width = 233
integer height = 224
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&lear All <<<"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;
dw_selected.TriggerEvent('ue_Clear_all')
end event

event constructor;
g.of_check_label_button(this)
end event

