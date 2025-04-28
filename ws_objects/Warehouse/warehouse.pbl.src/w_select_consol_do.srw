$PBExportHeader$w_select_consol_do.srw
$PBExportComments$Select Consolidation Delivery Orders
forward
global type w_select_consol_do from w_response_ancestor
end type
type dw_do from u_dw_ancestor within w_select_consol_do
end type
type dw_select from datawindow within w_select_consol_do
end type
type cb_1 from commandbutton within w_select_consol_do
end type
type cb_selectall from commandbutton within w_select_consol_do
end type
type cb_clearall from commandbutton within w_select_consol_do
end type
end forward

global type w_select_consol_do from w_response_ancestor
integer width = 2322
string title = "Select Consolidation Delivery Orders"
dw_do dw_do
dw_select dw_select
cb_1 cb_1
cb_selectall cb_selectall
cb_clearall cb_clearall
end type
global w_select_consol_do w_select_consol_do

type variables
String	isOrigSQL
end variables

on w_select_consol_do.create
int iCurrent
call super::create
this.dw_do=create dw_do
this.dw_select=create dw_select
this.cb_1=create cb_1
this.cb_selectall=create cb_selectall
this.cb_clearall=create cb_clearall
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_do
this.Control[iCurrent+2]=this.dw_select
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_selectall
this.Control[iCurrent+5]=this.cb_clearall
end on

on w_select_consol_do.destroy
call super::destroy
destroy(this.dw_do)
destroy(this.dw_select)
destroy(this.cb_1)
destroy(this.cb_selectall)
destroy(this.cb_clearall)
end on

event open;call super::open;
IstrParms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;

isOrigsQL = dw_do.getSQLSelect()
dw_select.InsertRow(0)

end event

event ue_retrieve;
String	lsWhere,	&
			lsNewSQL
			
Long		llRowCount
Integer	liRC
DateTime	ldtDate

dw_select.AcceptText()

//Always tackon Project and Order Type of Consolidation ('O')
lsWhere = " Where Project_id = '" + gs_project + "' and ord_type = 'O'"

//exclude orders already selected
lsWhere += " and (consolidation_no = '' or consolidation_no is null)"


//Tackon Dates if Present
ldtDate = dw_select.GetItemDateTime(1,"order_from_dt")
If  Not IsNull(ldtDate) Then
	lswhere += " and delivery_master.ord_date >= '" + &
		String(ldtdate, "yyyy-mm-dd hh:mm:ss") + "' "
End If

ldtDate = dw_select.GetItemDateTime(1,"order_to_dt")
If  Not IsNull(ldtDate) Then
	lswhere += " and delivery_master.ord_date >= '" + &
		String(ldtdate, "yyyy-mm-dd hh:mm:ss") + "' "
End If

lsNewSQL = isOrigSQL + lsWhere
liRC = dw_do.SetSqlSelect(lsNewSQL)
//Messagebox('??',liRC)

llRowCount = dw_do.Retrieve()
If llRowCount > 0 Then
	
Else
	messagebox('Select Orders','No Orders found!')
End If
end event

event closequery;
Long	llRowCount,	llRowPos, llResult

If istrparms.Cancelled Then 
	Message.PowerObjectParm = istrparms
	Return 0
End If

//at least one order must be selected
If dw_do.Find("c_select_ind='Y'",1,dw_do.RowCount()) <= 0 Then
	messagebox('select orders','At least one order must be selected!~r(Click Cancel Otherwise.)')
	Return 1
End If

//Set ths Consolidation Number for each Order
llRowCount = dw_do.Rowcount()
for llRowPos = 1 to llRowCount
	
	If dw_do.getITemString(llRowPos,'c_select_ind') <> 'Y' Then Continue
	
	dw_do.SetItem(llRowPos,'consolidation_no',Istrparms.String_arg[1])
	
next

//Update the DW

Execute Immediate "Begin Transaction" using SQLCA; /* 11/04 - PCONKL - Auto Commit Turned on to eliminate DB locks*/

lLResult = dw_do.Update()
If llResult = 1 Then
	Execute Immediate "COMMIT" using SQLCA;
Else
	Execute Immediate "ROLLBACK" using SQLCA;
	Messagebox('select Orders','Unable to select Orders for this Consolidation!')
	Return 1
End If

Message.PowerObjectParm = istrparms
Return 0


end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_consol_do
integer x = 1934
integer y = 992
integer width = 242
integer height = 100
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_consol_do
integer x = 1586
integer y = 992
integer width = 242
integer height = 100
integer textsize = -8
end type

type dw_do from u_dw_ancestor within w_select_consol_do
event ue_selectall ( )
event ue_clearall ( )
integer x = 27
integer y = 148
integer width = 2263
integer height = 808
boolean bringtotop = true
string dataobject = "d_consolidation_select_do"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_selectall;
Long	llRowCount,	llRowPos

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind','Y')
Next

This.SetRedraw(True)
end event

event ue_clearall;

Long	llRowCount,	llRowPos

This.SetRedraw(False)

llRowCount = This.RowCount()
For llRowPos = 1 to llRowCount
	This.SetITem(llRowPos,'c_select_ind','N')
Next

This.SetRedraw(True)
end event

event sqlpreview;call super::sqlpreview;//Messagebox('??',sqlsyntax)
end event

type dw_select from datawindow within w_select_consol_do
integer x = 18
integer y = 4
integer width = 1902
integer height = 128
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_consol_do_search"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_select_consol_do
integer x = 987
integer y = 992
integer width = 242
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
end type

event clicked;
PArent.TriggerEvent('ue_Retrieve')
end event

type cb_selectall from commandbutton within w_select_consol_do
integer x = 5
integer y = 992
integer width = 274
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select &All"
end type

event clicked;
dw_do.TriggerEvent('ue_selectall')
end event

type cb_clearall from commandbutton within w_select_consol_do
integer x = 320
integer y = 992
integer width = 279
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&lear All"
end type

event clicked;
dw_do.TriggerEvent('ue_clearall')
end event

