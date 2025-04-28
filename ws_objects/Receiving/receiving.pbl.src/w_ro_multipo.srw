$PBExportHeader$w_ro_multipo.srw
$PBExportComments$*
forward
global type w_ro_multipo from window
end type
type st_2 from statictext within w_ro_multipo
end type
type st_totrows from statictext within w_ro_multipo
end type
type cb_1 from commandbutton within w_ro_multipo
end type
type st_supplier from statictext within w_ro_multipo
end type
type st_6 from statictext within w_ro_multipo
end type
type cb_add from commandbutton within w_ro_multipo
end type
type st_5 from statictext within w_ro_multipo
end type
type sle_sku from singlelineedit within w_ro_multipo
end type
type cb_clear from commandbutton within w_ro_multipo
end type
type cb_delete from commandbutton within w_ro_multipo
end type
type cb_close from commandbutton within w_ro_multipo
end type
type cb_ok from commandbutton within w_ro_multipo
end type
type dw_1 from datawindow within w_ro_multipo
end type
type st_1 from statictext within w_ro_multipo
end type
type r_1 from rectangle within w_ro_multipo
end type
type sle_srno from singlelineedit within w_ro_multipo
end type
end forward

global type w_ro_multipo from window
integer x = 823
integer y = 360
integer width = 2281
integer height = 1456
boolean titlebar = true
string title = "PO Number Entry Screen"
windowtype windowtype = response!
long backcolor = 79741120
event ue_open ( )
st_2 st_2
st_totrows st_totrows
cb_1 cb_1
st_supplier st_supplier
st_6 st_6
cb_add cb_add
st_5 st_5
sle_sku sle_sku
cb_clear cb_clear
cb_delete cb_delete
cb_close cb_close
cb_ok cb_ok
dw_1 dw_1
st_1 st_1
r_1 r_1
sle_srno sle_srno
end type
global w_ro_multipo w_ro_multipo

type variables
public str_parms istrparms
window iwCurrent
boolean ib_value
n_warehouse i_nwarehouse
boolean ib_view = false

long il_line_item_num
end variables

forward prototypes
public subroutine wf_window_center ()
end prototypes

event ue_open;long i,ll_tot_rows, ll_line_item_no
decimal ld_cur,ld_tot //GAP 11/02 convert to decimal
String ls_l_code,ls_inventory_type,ls_lot_no,ls_ro_no



dw_1.SettransObject(SQLCA)
istrparms = message.PowerobjectParm
iwCurrent = This
sle_srno.Setfocus()
str_parms lstrparms
//structure is assigned values from put away windows in serial number command button 
//from w_ro window
sle_sku.text =istrparms.string_arg[1]
st_supplier.text = istrparms.String_arg[2]
ls_ro_no =istrparms.String_arg[3] 
ll_line_item_no = istrparms.Long_arg[1]

il_line_item_num = ll_line_item_no

if istrparms.String_arg[4] = "RO" OR istrparms.String_arg[4] = "DO" then
	
	ib_view = true
	
	cb_clear.visible = false
	cb_delete.visible = false
	sle_srno.visible = false
	st_1.visible = false
	cb_add.visible = false

	dw_1.width = dw_1.width + 350

	if istrparms.String_arg[4] = "RO" then

		dw_1.dataobject = "d_multi_po_no_detail_multi_line_item_ro"
		dw_1.SetTransObject(SQLCA)
	
	else

		dw_1.dataobject = "d_multi_po_no_detail_multi_line_item_do"
		dw_1.SetTransObject(SQLCA)
	
	
	end if
		
	ll_tot_rows = dw_1.retrieve(sle_sku.text, ls_ro_no)//retrieve the rows if already exist
	
else	

	if ll_line_item_no = 0 then
		
		dw_1.width = dw_1.width + 350
		this.width = this.width + 350
		r_1.width = r_1.width + 350
		
		cb_delete.x = cb_delete.x + 350
		cb_clear.x = cb_clear.x + 350
		
		dw_1.dataobject = "d_multi_po_no_detail_multi_line_item_ro"
		dw_1.SetTransObject(SQLCA)

		ll_tot_rows = dw_1.retrieve(sle_sku.text, ls_ro_no)//retrieve the rows if already exist

		
	else

		ll_tot_rows = dw_1.retrieve(sle_sku.text,ll_line_item_no,ls_ro_no)//retrieve the rows if already exist

	end if

end if

IF ll_tot_rows > 0 THEN
	st_totrows.text = string(ll_tot_rows)
	FOR i=1 TO dw_1.RowCount()
	ld_tot += ld_cur
	NEXT

//ElseIF istrparms.String_arg[6]	<> '-' THEN
//		 dw_1.insertrow(0)
//		 dw_1.Setitem(dw_1.Getrow(),'serial_no',istrparms.String_arg[6])
END IF 
st_totrows.text= string(dw_1.Rowcount())	
		 
istrparms[]=lstrparms[] //Reset the array 

this.SetRedraw(true)
end event

public subroutine wf_window_center ();long li_ScreenH,li_ScreenW
Environment le_Env
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

this.Y = (li_ScreenH - this.Height) / 2
this.X = (li_ScreenW - this.Width) / 2

end subroutine

on w_ro_multipo.create
this.st_2=create st_2
this.st_totrows=create st_totrows
this.cb_1=create cb_1
this.st_supplier=create st_supplier
this.st_6=create st_6
this.cb_add=create cb_add
this.st_5=create st_5
this.sle_sku=create sle_sku
this.cb_clear=create cb_clear
this.cb_delete=create cb_delete
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.dw_1=create dw_1
this.st_1=create st_1
this.r_1=create r_1
this.sle_srno=create sle_srno
this.Control[]={this.st_2,&
this.st_totrows,&
this.cb_1,&
this.st_supplier,&
this.st_6,&
this.cb_add,&
this.st_5,&
this.sle_sku,&
this.cb_clear,&
this.cb_delete,&
this.cb_close,&
this.cb_ok,&
this.dw_1,&
this.st_1,&
this.r_1,&
this.sle_srno}
end on

on w_ro_multipo.destroy
destroy(this.st_2)
destroy(this.st_totrows)
destroy(this.cb_1)
destroy(this.st_supplier)
destroy(this.st_6)
destroy(this.cb_add)
destroy(this.st_5)
destroy(this.sle_sku)
destroy(this.cb_clear)
destroy(this.cb_delete)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.r_1)
destroy(this.sle_srno)
end on

event open;wf_window_center()
i_nwarehouse = Create n_warehouse
this.SetRedraw(false)
Post event ue_open()
end event

event close;Destroy n_warehouse
ClosewithReturn(this,istrparms)
end event

type st_2 from statictext within w_ro_multipo
integer x = 1495
integer y = 84
integer width = 398
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
string text = "Qty Entered:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_totrows from statictext within w_ro_multipo
integer x = 1897
integer y = 84
integer width = 384
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ro_multipo
integer x = 1339
integer y = 1224
integer width = 247
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;
ShowHelp(g.is_helpFile,Topic!,551)
end event

type st_supplier from statictext within w_ro_multipo
integer x = 357
integer y = 84
integer width = 869
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_6 from statictext within w_ro_multipo
integer x = 46
integer y = 84
integer width = 279
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Supplier:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_add from commandbutton within w_ro_multipo
integer x = 219
integer y = 752
integer width = 247
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add"
end type

event clicked;sle_srno.SetFocus()
end event

type st_5 from statictext within w_ro_multipo
integer x = 133
integer y = 24
integer width = 192
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "SKU:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_sku from singlelineedit within w_ro_multipo
integer x = 352
integer y = 24
integer width = 869
integer height = 76
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean enabled = false
boolean border = false
boolean autohscroll = false
end type

type cb_clear from commandbutton within w_ro_multipo
integer x = 1865
integer y = 612
integer width = 279
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;//Clear the entire data after giving warning
long ll_status
ll_status = Messagebox("PO Numbers", "Are you sure you want to~CLEAR all entered PO's?",Question! ,YesNO!)
IF ll_status = 1 THEN //clears the data
	dw_1.RowsDiscard(1, dw_1.RowCount(), Primary!)
	st_totrows.text=string(dw_1.rowcount())
END IF
	
end event

type cb_delete from commandbutton within w_ro_multipo
integer x = 1865
integer y = 452
integer width = 279
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;//Delete the rows & calculate total rows again
dw_1.DeleteRow ( dw_1.GetRow())
st_totrows.text=string(dw_1.rowcount())
end event

type cb_close from commandbutton within w_ro_multipo
integer x = 960
integer y = 1224
integer width = 247
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;
istrparms.String_arg[1] = "-1"

parent.TriggerEvent(close!)



end event

type cb_ok from commandbutton within w_ro_multipo
integer x = 558
integer y = 1224
integer width = 247
integer height = 108
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
if ib_view then

	parent.triggerevent(Close!)
	
else

	IF i_nwarehouse.of_check_multipo(dw_1,istrparms) = 1 THEN	 ClosewithReturn(parent,istrparms)

end if




end event

type dw_1 from datawindow within w_ro_multipo
integer x = 1074
integer y = 228
integer width = 750
integer height = 788
integer taborder = 30
string dataobject = "d_multi_po_no_detail"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF row > 0 THEN
	THIS.SelectRow(0, FALSE)
	THIS.SelectRow(row, TRUE)
END IF	
end event

type st_1 from statictext within w_ro_multipo
integer x = 133
integer y = 644
integer width = 521
integer height = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
boolean enabled = false
string text = "PO Number"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_ro_multipo
long linecolor = 33554432
integer linethickness = 1
long fillcolor = 79741120
integer x = 32
integer y = 192
integer width = 2190
integer height = 956
end type

type sle_srno from singlelineedit within w_ro_multipo
integer x = 55
integer y = 540
integer width = 686
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;
long ll_row
String lsFind


// 01/07/05 TAM - Prevent Illegal Characters.  Currently COMMA(,) and PIPE(|) are only Illegal Chars
If pos(This.Text, ',') > 0 or pos(This.Text, '|') > 0 Then	
	MessageBox("Illegal Character found","COMMA(,) or PIPE(|) Cannot be used !")
	This.SetFocus()
//	This.SelectText(1, Len(Trim(This.Text)))
	Return
End If


// 07/00 PCONKL - Check for Dupplicates
If dw_1.RowCount() > 0 Then
	lsFind = "po_no = '" + This.Text + "'"
	If dw_1.Find(lsFind,1,dw_1.RowCount()) > 0 Then
		MessageBox("Duplicate found","This PO Number has already been entered!")
		This.SetFocus()
		This.SelectText(1, Len(Trim(This.Text)))
		Return
	End If
End If

this.SetRedraw ( FALSE )
dw_1.Insertrow(0)
ll_row = dw_1.rowcount() //count the total rows in datawindow
dw_1.Setitem(ll_row,"po_no",sle_srno.text) //asssign serial number entered in sle

dw_1.Setitem(ll_row,"line_item_no",il_line_item_num)

sle_srno.text = "" //clear sle
st_totrows.text=string(dw_1.rowcount()) //assign the total rows & display same
sle_srno.Setfocus()
sle_srno.SetRedraw( TRUE)
ll_row = dw_1.RowCount()
dw_1.SCROLLTOROW(ll_row)


end event

