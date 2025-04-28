$PBExportHeader$w_shipment_orders.srw
$PBExportComments$+Delivery Order
forward
global type w_shipment_orders from w_response_ancestor
end type
type sle_new_text from singlelineedit within w_shipment_orders
end type
type dw_avail from u_dw_ancestor within w_shipment_orders
end type
type dw_selected from u_dw_ancestor within w_shipment_orders
end type
type cb_add from commandbutton within w_shipment_orders
end type
type cb_delete from commandbutton within w_shipment_orders
end type
type st_selected_users from statictext within w_shipment_orders
end type
type cb_delete_avail from commandbutton within w_shipment_orders
end type
type pb_clear_all from picturebutton within w_shipment_orders
end type
type st_unlock_user from statictext within w_shipment_orders
end type
type cb_search from commandbutton within w_shipment_orders
end type
type st_user from statictext within w_shipment_orders
end type
type cb_1 from commandbutton within w_shipment_orders
end type
type cbx_1 from checkbox within w_shipment_orders
end type
type cbx_2 from checkbox within w_shipment_orders
end type
type cbx_3 from checkbox within w_shipment_orders
end type
type cbx_4 from checkbox within w_shipment_orders
end type
type sle_1 from singlelineedit within w_shipment_orders
end type
type st_1 from statictext within w_shipment_orders
end type
type gb_options from groupbox within w_shipment_orders
end type
type gb_1 from groupbox within w_shipment_orders
end type
end forward

global type w_shipment_orders from w_response_ancestor
integer x = 119
integer y = 120
integer width = 4032
integer height = 1924
string title = "Screen Unlock for the Orders"
sle_new_text sle_new_text
dw_avail dw_avail
dw_selected dw_selected
cb_add cb_add
cb_delete cb_delete
st_selected_users st_selected_users
cb_delete_avail cb_delete_avail
pb_clear_all pb_clear_all
st_unlock_user st_unlock_user
cb_search cb_search
st_user st_user
cb_1 cb_1
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
sle_1 sle_1
st_1 st_1
gb_options gb_options
gb_1 gb_1
end type
global w_shipment_orders w_shipment_orders

type variables
string is_userid
long il_row

end variables

on w_shipment_orders.create
int iCurrent
call super::create
this.sle_new_text=create sle_new_text
this.dw_avail=create dw_avail
this.dw_selected=create dw_selected
this.cb_add=create cb_add
this.cb_delete=create cb_delete
this.st_selected_users=create st_selected_users
this.cb_delete_avail=create cb_delete_avail
this.pb_clear_all=create pb_clear_all
this.st_unlock_user=create st_unlock_user
this.cb_search=create cb_search
this.st_user=create st_user
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.sle_1=create sle_1
this.st_1=create st_1
this.gb_options=create gb_options
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_new_text
this.Control[iCurrent+2]=this.dw_avail
this.Control[iCurrent+3]=this.dw_selected
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.st_selected_users
this.Control[iCurrent+7]=this.cb_delete_avail
this.Control[iCurrent+8]=this.pb_clear_all
this.Control[iCurrent+9]=this.st_unlock_user
this.Control[iCurrent+10]=this.cb_search
this.Control[iCurrent+11]=this.st_user
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.cbx_1
this.Control[iCurrent+14]=this.cbx_2
this.Control[iCurrent+15]=this.cbx_3
this.Control[iCurrent+16]=this.cbx_4
this.Control[iCurrent+17]=this.sle_1
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.gb_options
this.Control[iCurrent+20]=this.gb_1
end on

on w_shipment_orders.destroy
call super::destroy
destroy(this.sle_new_text)
destroy(this.dw_avail)
destroy(this.dw_selected)
destroy(this.cb_add)
destroy(this.cb_delete)
destroy(this.st_selected_users)
destroy(this.cb_delete_avail)
destroy(this.pb_clear_all)
destroy(this.st_unlock_user)
destroy(this.cb_search)
destroy(this.st_user)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.gb_options)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;// Dinesh - 07/11/2023- SIMS-198- Google read only
//Istrparms = Message.PowerobJectParm

//Retrieve available and currently selected
// Dinesh - 07/11/2023- SIMS-198- Google read only
dw_avail.Retrieve()
dw_selected.Retrieve()
dw_selected.SelectRow(0, FALSE)


sle_new_Text.SetFocus()
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_shipment_orders
integer x = 2158
integer y = 1448
end type

event cb_cancel::constructor;call super::constructor;// Dinesh - 07/13/2023- SIMS-198- Google read only
g.of_check_label_button(this)
end event

type cb_ok from w_response_ancestor`cb_ok within w_shipment_orders
integer x = 1824
integer y = 1448
boolean default = false
end type

event cb_ok::constructor;call super::constructor;
//g.of_check_label_button(this)
end event

type sle_new_text from singlelineedit within w_shipment_orders
string tag = "Search user here..."
integer x = 32
integer y = 140
integer width = 539
integer height = 84
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

event getfocus;// Dinesh - 07/12/2023- SIMS-198- Google read only
This.SelectText(1,len(this.Text))
end event

event modified;String	lsText
Long	llFindRow,	&
		llNExtID,	&
		llNewRow

//Make sure we don't already have this ID, If we don't add it

is_userid = This.Text
//
//llFindRow = dw_avail.Find("Upper(user_id) = '" + Upper(lsText) + "'",1,dw_avail.RowCount())
//
//If llFindRow > 0 Then
//	dw_avail.SetRow(llFindRow)
//	dw_avail.ScrollToRow(llFindRow)
//	dw_selected.SetRow(dw_selected.RowCount()) /*insert at end*/
//	dw_selected.PostEvent('ue_insert')
//Else /*Add a new Row*/
//	
//	//Get the Next Available ID
//	llNextID = g.of_next_db_seq(gs_project,'BOM_Text','BOM_Text_ID')
//	If llNextID <= 0 Then
//		messagebox('BOM Instructions',"Unable to retrieve the next available BOM Text ID!~rUnable to Insert a New Instruction.")
//		Return
//	End If
//	
//	llNewRow = dw_avail.InsertRow(0)
//	dw_avail.SetItem(llNewRow,'Project_ID',gs_project)
//	dw_avail.SetItem(llNewRow,'bom_text_id',string(llNextID))
//	dw_avail.SetItem(llNewRow,'bom_Text',lsText)
//	dw_avail.SetRow(llNewRow)
//	dw_selected.SetRow(dw_selected.RowCount()) /*insert at end*/
//	dw_selected.TriggerEvent('ue_insert')
//	
//End If
//
//This.Text = ''
//This.SetFocus()


end event

type dw_avail from u_dw_ancestor within w_shipment_orders
integer x = 32
integer y = 416
integer width = 1797
integer height = 916
integer taborder = 20
boolean bringtotop = true
string title = "Order to Unlock"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_add.Enabled = True
END IF
end event

type dw_selected from u_dw_ancestor within w_shipment_orders
event ue_resequence ( )
event ue_select_all ( )
event ue_clear_all ( )
integer x = 2062
integer y = 416
integer width = 1915
integer height = 920
integer taborder = 20
boolean bringtotop = true
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

event ue_select_all();//Copy all rows from Available

Long ll_row,			&
		llAvailCount,	&
		llAvailPos

This.SetFocus()
If This.AcceptText() = -1 Then Return

This.TriggerEvent('ue_clear_all')/*clear existing rows */

This.SetRedraw(False)

llAvailCount = dw_avail.RowCOunt()

For llAvailPos = 1 to llAvailCount
	ll_row = This.InsertRow(llAvailPos)
	This.SetITem(ll_row,'user_id',dw_avail.GetITemString(llAvailPos,'user_id'))
	This.SetITem(ll_row,'order_no',dw_avail.GetITemString(llAvailPos,'order_no'))
	This.SetITem(ll_row,'screen_name',dw_avail.GetITemString(llAvailPos,'screen_name'))
	This.SetITem(ll_row,'userspid',dw_avail.GetITemString(llAvailPos,'userspid'))
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

event clicked;call super::clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
il_row=This.GetRow()
If This.GetRow() > 0 Then
		This.SelectRow(0, FALSE)
		This.SelectRow(row, TRUE)
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
//if This.rowcount() < 1 then
	This.SetITem(ll_row,'user_id',dw_avail.GetITemString(dw_avail.GetRow(),'user_id'))
	This.SetITem(ll_row,'order_no',dw_avail.GetITemString(dw_avail.GetRow(),'order_no'))
	This.SetITem(ll_row,'screen_name',dw_avail.GetITemString(dw_avail.GetRow(),'screen_name'))
	This.SetITem(ll_row,'userspid',dw_avail.GetITemString(dw_avail.GetRow(),'userspid'))
	//Resequence

This.TriggerEvent('ue_resequence')
	
	






end event

event ue_delete;call super::ue_delete;
If this.GetRow() > 0 Then
	This.DEleteRow(This.GetRow())
	This.TriggerEvent('ue_resequence')
End If
end event

type cb_add from commandbutton within w_shipment_orders
integer x = 1865
integer y = 456
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

event clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
if dw_selected.rowcount()  =1 or dw_selected.rowcount()  > 1 then
	messagebox('','Only One user can be removed at one time, Please push back the previous entry first to end another users session')
else
dw_selected.TriggerEvent('ue_insert')
end if
end event

type cb_delete from commandbutton within w_shipment_orders
integer x = 1856
integer y = 584
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

event clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
dw_selected.TriggerEvent('ue_delete')
end event

type st_selected_users from statictext within w_shipment_orders
integer x = 2062
integer y = 344
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
string text = "Shuttle Consolidation"
boolean focusrectangle = false
end type

event constructor;
g.of_check_label_button(this)
end event

type cb_delete_avail from commandbutton within w_shipment_orders
integer x = 1445
integer y = 1448
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

event clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
Long	llRow,	&
		llCount
		
Long ll_userspid,i

//Make sure it's not being used before deleting

llRow = dw_avail.GetRow()

if llRow=0 then
	messagebox("Warning","No Order is selected, Kindly select at lease one order to kill the session")
else

ll_userspid = dw_avail.GetITemnumber(llRow,'userspid')

SElect count(*) into :llCount
From Screen_unlock_order
Where userspid = :ll_userspid;

if dw_selected.rowcount() > 0   then
	if gs_role = '-1' then
		If MessageBox('Confirm Delete','Are you sure you want to remove this session?',Question!,YesNo!,2) = 1 Then
				dw_avail.DeleteRow(llRow)
				dw_avail.update()
		End If
	else
		messagebox('Warning','You are not Super Duper user hence you have no rights to unlock the orders')
	end if
else
	messagebox('Screen Lock',"Please select atleast one row to remove the session of a locked orders")
	return
end if
end if

dw_avail.retrieve()
dw_selected.retrieve()


end event

event constructor;
g.of_check_label_button(this)
end event

type pb_clear_all from picturebutton within w_shipment_orders
integer x = 1842
integer y = 740
integer width = 206
integer height = 212
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&lear All <<<"
boolean originalsize = true
vtextalign vtextalign = multiline!
end type

event clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
dw_selected.TriggerEvent('ue_Clear_all')
end event

event constructor;
g.of_check_label_button(this)
end event

type st_unlock_user from statictext within w_shipment_orders
integer x = 32
integer y = 332
integer width = 1184
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Shuttle Orders"
boolean focusrectangle = false
end type

type cb_search from commandbutton within w_shipment_orders
integer x = 2779
integer y = 100
integer width = 247
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;// Dinesh - 07/11/2023- SIMS-198- Google read only
//dw_avail.reset()
string lsFilter,ls_userid
long ll_ret
	select User_id into : ls_userid from Screen_Lock where User_id =:is_userid using sqlca;

	lsFilter = "user_id = '" + is_userid + "' or order_no = '" + is_userid + "'" 
	dw_avail.SetFilter(lsFilter)
	ll_ret=dw_avail.Filter()
	ll_ret=dw_avail.RowCount()

	if ll_ret = 0 then
		messagebox('Order Number','Sorry !!,No order is locked for the User ID/Order Number you are searching for. ')
	connect using sqlca;
	dw_avail.dataobject='d_screen_locked_user_list'
	dw_avail.settrans(sqlca)
	dw_avail.Retrieve()
	end if
	






end event

type st_user from statictext within w_shipment_orders
integer x = 32
integer y = 60
integer width = 649
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
string text = "Warehouse"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_shipment_orders
integer x = 1111
integer y = 1452
integer width = 274
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;// Dinesh - 07/13/2023- SIMS-198- Google read only
connect using sqlca;
dw_avail.dataobject='d_screen_locked_user_list'
dw_avail.settrans(sqlca)
dw_avail.Retrieve()
end event

type cbx_1 from checkbox within w_shipment_orders
integer x = 987
integer y = 112
integer width = 402
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
string text = "New"
end type

type cbx_2 from checkbox within w_shipment_orders
integer x = 1390
integer y = 108
integer width = 402
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
string text = "Packing"
end type

type cbx_3 from checkbox within w_shipment_orders
integer x = 987
integer y = 212
integer width = 402
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
string text = "Picking"
end type

type cbx_4 from checkbox within w_shipment_orders
integer x = 1390
integer y = 212
integer width = 402
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
string text = "Loading"
end type

type sle_1 from singlelineedit within w_shipment_orders
string tag = "Search user here..."
integer x = 2153
integer y = 104
integer width = 539
integer height = 84
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

type st_1 from statictext within w_shipment_orders
integer x = 2149
integer y = 32
integer width = 402
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
string text = "Shipment ID"
boolean focusrectangle = false
end type

type gb_options from groupbox within w_shipment_orders
integer x = 1079
integer y = 1372
integer width = 1394
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
end type

type gb_1 from groupbox within w_shipment_orders
integer x = 896
integer y = 40
integer width = 905
integer height = 280
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Order Status"
end type

