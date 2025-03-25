HA$PBExportHeader$w_container_content_print.srw
$PBExportComments$Container Print
forward
global type w_container_content_print from w_main_ancestor
end type
type cb_print from commandbutton within w_container_content_print
end type
type dw_label from u_dw_ancestor within w_container_content_print
end type
type cb_selectall from commandbutton within w_container_content_print
end type
type cb_1 from commandbutton within w_container_content_print
end type
type rb_rono from radiobutton within w_container_content_print
end type
type rb_container from radiobutton within w_container_content_print
end type
type sle_retrieve from singlelineedit within w_container_content_print
end type
type st_1 from statictext within w_container_content_print
end type
type dw_container from datawindow within w_container_content_print
end type
type gb_1 from groupbox within w_container_content_print
end type
end forward

global type w_container_content_print from w_main_ancestor
integer width = 3410
integer height = 1852
string title = "Container labels"
event ue_print ( )
cb_print cb_print
dw_label dw_label
cb_selectall cb_selectall
cb_1 cb_1
rb_rono rb_rono
rb_container rb_container
sle_retrieve sle_retrieve
st_1 st_1
dw_container dw_container
gb_1 gb_1
end type
global w_container_content_print w_container_content_print

type variables

n_labels	invo_labels

constant int success = 0
constant int failure = -1

String is_ro_or_wo
String	isOrigSQL, isOrigPrintSQL
end variables

forward prototypes
public function integer uf_dolam (ref any _anyparm)
end prototypes

event ue_print();Str_Parms	lstrparms
Long	llQty,	&
		llRowCount,	ll_printCount, &
		llRowPos, llwherelength
		
Any	lsAny

String	lsFormat,	&
			lsUOM, 	&
			lsPrinterInfo, &
			lsRetrieveVal, &
			ls_Where, lsnewsql, ls_Groupby
Integer	liRC

Dw_Label.AcceptText()

//Print each detail Row 
llRowCount = dw_label.RowCount()
For llRowPos = 1 to llRowCount /*each detail row */
	
//If not selected for Printing, continue with next row
	If dw_label.GetITemString(llRowPos,'c_Print_Ind') <> 'Y' Then Continue

//Values in "IN" (for multiple values) statement must have quotes areound Values
	If lsRetrieveVal = '' Then
			lsRetrieveVal = "'" + dw_label.GetItemString(llRowPos,'container_Id') + "'"
		Else
			lsRetrieveVal += ",'" + dw_label.GetItemString(llRowPos,'container_Id') + "'"
	End If
	
Next	

// Check if Workorder, ReceiveOrder, Or Content

//If retrieving by Container, take from Content instead of Putaway (new containers won't exist in Putaway)
//change all joins on Receive_Putaway to Content
If rb_container.Checked Then
	dw_container.dataobject = "d_container_contents2"
	dw_container.SetTransObject(SQLCA)
	isOrigPrintSQL = dw_container.GetSQLSelect()
	lsNewSQL = isOrigPrintSql

//	llwherelength = pos(UPPER(isOrigPrintSql),"GROUP",1) - pos( UPPER(isOrigPrintSql),"WHERE",1)  //TAM 2011/07/08
//	ls_Where = mid(isOrigPrintSql, pos(UPPER(lsNEwSql),"WHERE",1), llwherelength  )  //TAM 2011/07/08
//	ls_Where += " and Content.Project_id = '" + gs_Project + "'" /*always tackon project */  //TAM 2011/07/08
	ls_Where = " and Content.Project_id = '" + gs_Project + "'" /*always tackon project */  //TAM 2011/07/08
	ls_Where += " and Content.Container_ID In (" + lsRetrieveVal + ")"	
	lsNewSQL = isOrigPrintSql + ls_Where //TAM 2011/07/08
	//	lsNEwSql = Replace (UPPER(lsNEwSql), pos( UPPER(isOrigPrintSql),"WHERE",1), len(isOrigPrintSql), ls_where )  //TAM 2011/07/08
 //TAM 2011/07/08
//	ls_Groupby = " GROUP BY Content.Wh_Code, Content.SKU,  Content.Supp_Code, Content.L_Code, Content.Inventory_Type, Content.Lot_No, Content.PO_No, Content.Component_No, Content.container_ID, Content.Expiration_Date, Item_Master.Description, Item_Master.UOM_1"
//	lsNEwSql += ls_Groupby

Else
// TAM 2010/10 added Receive Order
	ls_Where = " and Workorder_MASter.Project_id = '" + gs_Project + "'" /*always tackon project */
// TAM 2011/06 added WONO to where
	ls_Where += " and Workorder_Master.Wo_No = '" +  sle_Retrieve.Text + "'" /*always tackon WO_NO */

	ls_Where += " and Workorder_Putaway.Container_ID In (" + lsRetrieveVal + ")"
	lsNewSQL = isOrigPrintSql + ls_Where

	
	If is_ro_or_wo <> 'wo_no' Then
		Do While Pos(Upper(lsNewSQL),'WORKORDER') > 0
			lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'WORKORDER'), 9, 'Receive')
		Loop
		Do While Pos(Upper(lsNewSQL),'WO_NO') > 0
			lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'WO_NO'), 5, 'RO_NO')
		Loop
	End If
End If 
dw_container.SetTransObject(SQLCA)
dw_container.SetSqlSelect(lsNewSQL)
dw_container.Retrieve(gs_project)

ll_printCount = dw_Container.RowCOunt()
If dw_Container.RowCOunt() > 0 Then
	OpenWithParm(w_dw_print_options,dw_container) 
Else
	Messagebox('Container','No records found!')
	Return
End If	
	
	
	

	

	











end event

public function integer uf_dolam (ref any _anyparm);//
// int = uf_doLam( any _anyParm )
//
// Process Lam License Plate Tag
//

// if there are a billion labels to print for this detail line, prompt 
// them?

// Requirements state that there may or may not be serials for this detail
// if there serials print the label serial section
// if not, the label serial section should print blank
// So, there are two formats...guess which one is which
//
// LAM-SGLicenseTagSerial.DWN
// LAM-SGLicenseTag.DWN
//

string theSku
string thePkg
string theOwner


return success

end function

on w_container_content_print.create
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
this.dw_container=create dw_container
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
this.Control[iCurrent+9]=this.dw_container
this.Control[iCurrent+10]=this.gb_1
end on

on w_container_content_print.destroy
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
destroy(this.dw_container)
destroy(this.gb_1)
end on

event ue_postopen;call super::ue_postopen;
invo_labels = Create n_labels

cb_print.Enabled = False

isOrigSQL = dw_label.GetSQLSelect()
isOrigPrintSQL = dw_container.GetSQLSelect()

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
		
//Else
//  TAM 2010/10  Added workorder
	ElseIf isValid(w_workorder) Then /*Coming from menu, see if Workorder Order is open */
	
	if w_workorder.idw_main.rowCount() > 0 Then
		
		rb_roNo.Checked = True
		is_ro_or_wo = 'wo_no'
		sle_retrieve.Text = w_workorder.idw_main.getITemString(1,'wo_no')
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

if gs_project = "LOGITECH" then
	
	dw_label.dataobject = "d_logitech_license_label"
	dw_label.SetTransObject(SQLCA)
	
end if

//Modify SQL to retrieve by Sys Number (RONO) or Container ID

lsWhere = " and Receive_MASter.Project_id = '" + gs_Project + "'" /*always tackon project */

lsRetrieveVal = sle_Retrieve.Text

// TAM 2010/11/08 - Added a LIKE wildcard "%" instead of IN statement for NYCSP. (Could be used for everyone)
//If gs_project = "NYCSP" and Pos(lsRetrieveVal,'%') > 0 Then /*Wildcard Used*/ 
If gs_project = "NYCSP" and Pos(lsRetrieveVal,'%') > 0 and not rb_rono.Checked Then /*Wildcard Used*/ 
	//If retrieving by RoNO, tackon RONO Don't use if rono checked (must be project specific)
//	If rb_rono.Checked Then
//		lsWhere += " and Receive_Master.ro_no Like '" + lsRetrieveVal + "'"
//	Else /*retrieving by Container */
//		lsWhere += " and Receive_Putaway.Container_ID Like  '" + lsRetrieveVal + "'"
		lsWhere += " and Receive_Putaway.Container_ID Like  '" + lsRetrieveVal + "' and Avail_QTY > 0 "
//	End If
Else

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
End If

lsNewSQL = isOrigSql + lsWhere

//If retrieving by Container, take from Content instead of Putaway (new containers won't exist in Putaway)
//change all joins on Receive_Putaway to Content
If rb_container.Checked Then
//TAM 2011/06/02 Made Container check only use content	
//	Do While Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY') > 0
//		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RECEIVE_PUTAWAY'), 15, 'Content')
//	Loop
//	
//	lsNewSQL = Replace(lsNewSQL,Pos(lsNewSQL,'(Receive_Detail.Line_Item_No = Content.Line_Item_No) and'), 64, '') /*No join to Line Item in Content*/
//	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'QUANTITY'), 8, 'Avail_Qty') /*content qty field is named different then Putaway*/
	lsNEwSql = "SELECT Content.PO_No,Content.SKU,Content.Avail_Qty,Content.Expiration_Date,Content.Container_ID,Content.Lot_NO,Content.L_code,Content.serial_no,'NA' as UOM,Item_Master.Description,'Y' as c_Print_Ind,Item_Master.Part_Upc_Code,Item_Master.User_Field6,Item_Master.User_Field7,Item_Master.Supp_Code,Content.RO_No,Content.Inventory_Type "
	lsNEwSql += " FROM Item_Master, Content " 
	lsNEwSql += " WHERE ( Item_Master.Project_ID = Content.Project_ID ) and (Content.SKU = Item_Master.SKU ) and ( Content.Supp_Code = Item_Master.Supp_Code )" 
	lsNEwSql += " and Content.Project_id = '" + gs_Project + "'" /*optimize query a little more */
	If Pos(lsRetrieveVal,'%') > 0  Then /*Wildcard Used*/ 
		lsNEwSql += " and Content.Container_ID Like  '" + lsRetrieveVal + "' and Avail_QTY > 0 "
	Else
		lsNEwSql += " and Content.Container_ID In (" + lsRetrieveVal + ") and Avail_QTY > 0 "
	End If
End If
// TAM 2010/10 added Workorder processing
If is_ro_or_wo = 'wo_no' Then
	Do While Pos(Upper(lsNewSQL),'RECEIVE') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RECEIVE'), 7, 'WORKORDER')
	Loop
	Do While Pos(Upper(lsNewSQL),'RO_NO') > 0
		lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'RO_NO'), 5, 'WO_NO')
	Loop
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'SUPP_INVOICE_NO'), 15, 'WorkOrder_Number') /*content qty field is named different then Putaway*/
	lsNewSQL = Replace(lsNewSQL,Pos(Upper(lsNewSQL),'WORKORDER_DETAIL.UOM,'), 21, "'EA' as UOM,") /*No join to Line Item in Content*/
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
dw_container.Resize(workspacewidth() - 30,workspaceHeight()-310)
end event

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

type cb_cancel from w_main_ancestor`cb_cancel within w_container_content_print
boolean visible = false
integer x = 2373
integer y = 1408
integer height = 100
end type

type cb_ok from w_main_ancestor`cb_ok within w_container_content_print
integer x = 3026
integer y = 128
integer height = 84
boolean default = false
end type

type cb_print from commandbutton within w_container_content_print
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

type dw_label from u_dw_ancestor within w_container_content_print
event ue_check_enable ( )
integer x = 41
integer y = 252
integer width = 3310
integer height = 1380
boolean bringtotop = true
string dataobject = "d_license_label"
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

type cb_selectall from commandbutton within w_container_content_print
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

type cb_1 from commandbutton within w_container_content_print
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

type rb_rono from radiobutton within w_container_content_print
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
end type

event clicked;
sle_retrieve.Text = ''
dw_label.Reset()
end event

type rb_container from radiobutton within w_container_content_print
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
string text = "&Tag:"
end type

event clicked;sle_retrieve.Text = ''
dw_label.Reset()
end event

type sle_retrieve from singlelineedit within w_container_content_print
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

type st_1 from statictext within w_container_content_print
integer x = 791
integer y = 176
integer width = 1627
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
string text = "Enter Multiple values separated by Commas or ~'%~' for a Wildcard"
boolean focusrectangle = false
end type

type dw_container from datawindow within w_container_content_print
boolean visible = false
integer x = 2341
integer y = 1108
integer width = 686
integer height = 400
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_container_contents"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_container_content_print
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
end type

