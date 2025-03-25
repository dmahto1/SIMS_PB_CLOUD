HA$PBExportHeader$w_select_substitute_sku.srw
$PBExportComments$Select Substitute SKU
forward
global type w_select_substitute_sku from w_response_ancestor
end type
type dw_select from u_dw_ancestor within w_select_substitute_sku
end type
type st_2 from statictext within w_select_substitute_sku
end type
type cb_undo from commandbutton within w_select_substitute_sku
end type
end forward

global type w_select_substitute_sku from w_response_ancestor
integer width = 2213
integer height = 1244
string title = "Select Warehouse"
dw_select dw_select
st_2 st_2
cb_undo cb_undo
end type
global w_select_substitute_sku w_select_substitute_sku

type variables

//public str_parms istrparms

string isPrimary_Sku, isPrimary_Supplier
boolean ib_undo
end variables

on w_select_substitute_sku.create
int iCurrent
call super::create
this.dw_select=create dw_select
this.st_2=create st_2
this.cb_undo=create cb_undo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_select
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_undo
end on

on w_select_substitute_sku.destroy
call super::destroy
destroy(this.dw_select)
destroy(this.st_2)
destroy(this.cb_undo)
end on

event closequery;
//If Not Cancelled then return Selected Customer Code (if Any) to calling program

If Not Istrparms.Cancelled Then 
//If Not Cancelled then return Selected Customer Code (if Any) to calling program
	If ib_undo   then
		Istrparms.String_arg[3] = isPrimary_Sku
		Istrparms.String_arg[4] = isPrimary_Supplier
	Else
		If dw_select.GetRow() > 0 Then
			Istrparms.String_arg[3] = dw_select.getItemString(dw_select.GetRow(),"sku_substitute")
			Istrparms.String_arg[4] = dw_select.getItemString(dw_select.GetRow(),"supplier_substitute")
		Else
			Istrparms.Cancelled = True
		End If
	End If
End If /*not cancelled*/

Message.PowerObjectParm = Istrparms
end event

event open;call super::open;
istrparms = message.PowerobjectParm

isPrimary_Sku =istrparms.string_arg[1]
isPrimary_Supplier = istrparms.String_arg[2]
ib_undo = false

dw_select.Retrieve(gs_project, isPrimary_Sku, isPrimary_Supplier )

//If This.RowCount() <= 0 Then
//	MessageBox("Select Warehouse","No Warehouse records found matching your criteria!")
//End If




end event

type cb_cancel from w_response_ancestor`cb_cancel within w_select_substitute_sku
integer x = 997
integer y = 1020
integer taborder = 40
end type

type cb_ok from w_response_ancestor`cb_ok within w_select_substitute_sku
integer x = 626
integer y = 1020
boolean default = false
end type

type dw_select from u_dw_ancestor within w_select_substitute_sku
integer x = 41
integer y = 116
integer width = 2094
integer height = 824
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_select_sku_substitute"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;//If row is clicked then highlight the row
IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	cb_ok.Default=true
End If
end event

event doubleclicked;If Row > 0 Then
	Close(Parent)
End If
end event

type st_2 from statictext within w_select_substitute_sku
integer x = 41
integer y = 940
integer width = 1787
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
string text = "Double click on a the Substitute Sku to select or highlight and click ~'OK~'"
boolean focusrectangle = false
end type

type cb_undo from commandbutton within w_select_substitute_sku
integer x = 1367
integer y = 1020
integer width = 270
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Undo"
end type

event clicked;ib_undo = true
Close(parent)
end event

