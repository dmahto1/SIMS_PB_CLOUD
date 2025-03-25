HA$PBExportHeader$w_select_warehouse.srw
$PBExportComments$Select Customer
forward
global type w_select_warehouse from w_response_ancestor
end type
type dw_select from u_dw_ancestor within w_select_warehouse
end type
type cb_search from commandbutton within w_select_warehouse
end type
type sle_wh_name from singlelineedit within w_select_warehouse
end type
type st_1 from statictext within w_select_warehouse
end type
type st_2 from statictext within w_select_warehouse
end type
end forward

global type w_select_warehouse from w_response_ancestor
integer width = 2290
integer height = 1244
string title = "Select Warehouse"
dw_select dw_select
cb_search cb_search
sle_wh_name sle_wh_name
st_1 st_1
st_2 st_2
end type
global w_select_warehouse w_select_warehouse

type variables
string	isOrigSQL
string	is_Ignore_Wh_Code
end variables

on w_select_warehouse.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.cb_search=create cb_search
this.sle_wh_name=create sle_wh_name
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.cb_search
this.Control[iCurrent+3]=this.sle_wh_name
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
end on

on w_select_warehouse.destroy
call super::destroy
destroy(this.dw_select)
destroy(this.cb_search)
destroy(this.sle_wh_name)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_postopen;
isOrigSql = dw_select.GetSqlSelect()

sle_wh_name.Setfocus()
end event

event closequery;
//If Not Cancelled then return Selected Customer Code (if Any) to calling program

If Not Istrparms.Cancelled Then 
	If dw_select.GetRow() > 0 Then
		Istrparms.String_arg[1] = dw_select.getItemString(dw_select.GetRow(),"wh_code")
	Else
		Istrparms.String_arg[1] =''
	End If
End If /*not cancelled*/

Message.PowerObjectParm = Istrparms
end event

event open;call super::open;
is_Ignore_Wh_Code = message.StringParm
end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_warehouse
integer x = 965
integer y = 1020
integer taborder = 40
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_warehouse
integer y = 1020
boolean default = false
end type

type dw_select from u_dw_ancestor within w_select_warehouse
integer x = 41
integer y = 116
integer width = 2190
integer height = 824
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_select_warehouse"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_retrieve;String	lsWhere,	&
			lsNewSQL

//Always tackon Project ID to Sql
LsWhere = " Where Project_id = '" + gs_project + "'"

//If name is Present, tackon

If sle_wh_name.Text > '' Then
	lswhere += " and wh_name like '%" + sle_wh_name.Text + "%' "
End If

If IsNull(is_Ignore_Wh_Code) then is_Ignore_Wh_Code = ""

lsNewSql = isOrigSQL + lsWhere + " and Warehouse.wh_code <> '" + string(is_Ignore_Wh_Code) + "'"


This.SetSqlSelect(lsNewSql)

This.Retrieve()

If This.RowCount() <= 0 Then
	MessageBox("Select Warehouse","No Warehouse records found matching your criteria!")
End If

sle_wh_name.SetFocus()
	sle_wh_name.SelectText(1,Len(sle_wh_name.Text))
end event

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_ok.Default=true
	cb_search.Default=false
End If
end event

event doubleclicked;If Row > 0 Then
	Close(Parent)
End If
end event

type cb_search from commandbutton within w_select_warehouse
integer x = 1335
integer y = 1020
integer width = 270
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Search"
boolean default = true
end type

event clicked;
dw_select.TriggerEvent("ue_retrieve")
end event

type sle_wh_name from singlelineedit within w_select_warehouse
integer x = 553
integer y = 16
integer width = 818
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_select_warehouse
integer x = 41
integer y = 24
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Warehouse Name:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_select_warehouse
integer x = 41
integer y = 940
integer width = 1646
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "Double click on a Customer to select or highlight and click ~'OK~'"
boolean focusrectangle = false
end type

