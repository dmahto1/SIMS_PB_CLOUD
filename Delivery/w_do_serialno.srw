HA$PBExportHeader$w_do_serialno.srw
$PBExportComments$-
forward
global type w_do_serialno from window
end type
type st_supplier from statictext within w_do_serialno
end type
type st_2 from statictext within w_do_serialno
end type
type cb_done from commandbutton within w_do_serialno
end type
type cb_1 from commandbutton within w_do_serialno
end type
type st_selected_qty from statictext within w_do_serialno
end type
type st_requiredqty from statictext within w_do_serialno
end type
type st_itemnumber from statictext within w_do_serialno
end type
type cb_cancel from commandbutton within w_do_serialno
end type
type st_selected_t from statictext within w_do_serialno
end type
type st_available_t from statictext within w_do_serialno
end type
type cb_selected from commandbutton within w_do_serialno
end type
type cb_available from commandbutton within w_do_serialno
end type
type dw_serialno_select from datawindow within w_do_serialno
end type
type dw_serialno_ava from datawindow within w_do_serialno
end type
type st_1 from statictext within w_do_serialno
end type
type r_1 from rectangle within w_do_serialno
end type
type gb_1 from groupbox within w_do_serialno
end type
end forward

global type w_do_serialno from window
integer x = 823
integer y = 360
integer width = 3118
integer height = 1592
boolean titlebar = true
string title = "Serial Numbers"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
event ue_open ( )
st_supplier st_supplier
st_2 st_2
cb_done cb_done
cb_1 cb_1
st_selected_qty st_selected_qty
st_requiredqty st_requiredqty
st_itemnumber st_itemnumber
cb_cancel cb_cancel
st_selected_t st_selected_t
st_available_t st_available_t
cb_selected cb_selected
cb_available cb_available
dw_serialno_select dw_serialno_select
dw_serialno_ava dw_serialno_ava
st_1 st_1
r_1 r_1
gb_1 gb_1
end type
global w_do_serialno w_do_serialno

type variables
str_parms istrparms
str_multiparms istrmultiparms
window iwCurrent
boolean ib_value
end variables

forward prototypes
public subroutine wf_window_center ()
public subroutine wf_select_all (ref datawindow adw_from, ref datawindow adw_to)
end prototypes

event ue_open;long ll_cnt
long ll_row

iwCurrent = This
istrparms = message.PowerobjectParm
dw_serialno_ava.SetTransObject(SQLCA)
dw_serialno_select.SetTransObject(SQLCA)
st_itemnumber.text =istrparms.string_arg[1]
st_supplier.text =istrparms.string_arg[3]

//st_location.TexT = istrparms.string_arg[2]
ll_cnt=dw_serialno_ava.Retrieve(istrparms.string_arg[1],istrparms.String_arg[3])


st_requiredqty.text = string(istrparms.Long_arg[1])
//dw_serialno_select.Retrieve()
end event

public subroutine wf_window_center ();long li_ScreenH,li_ScreenW
Environment le_Env
GetEnvironment(le_Env)

li_ScreenH = PixelsToUnits(le_Env.ScreenHeight, YPixelsToUnits!)
li_ScreenW = PixelsToUnits(le_Env.ScreenWidth, XPixelsToUnits!)

this.Y = (li_ScreenH - this.Height) / 2
this.X = (li_ScreenW - this.Width) / 2

end subroutine

public subroutine wf_select_all (ref datawindow adw_from, ref datawindow adw_to);		IF adw_from.RowCount() > 0 THEN 
			adw_from.SelectRow(0, ib_value)	
			adw_to.Object.Data=adw_from.Object.Data.Selected
			adw_from.RowsDiscard (1, adw_from.Rowcount(), Primary! )
		ELSE
			adw_to.SelectRow(0, ib_value)	
			adw_from.Object.Data=adw_to.Object.Data.Selected
			adw_to.RowsDiscard (1, adw_to.Rowcount(), Primary! )
		END IF	
	
end subroutine

on w_do_serialno.create
this.st_supplier=create st_supplier
this.st_2=create st_2
this.cb_done=create cb_done
this.cb_1=create cb_1
this.st_selected_qty=create st_selected_qty
this.st_requiredqty=create st_requiredqty
this.st_itemnumber=create st_itemnumber
this.cb_cancel=create cb_cancel
this.st_selected_t=create st_selected_t
this.st_available_t=create st_available_t
this.cb_selected=create cb_selected
this.cb_available=create cb_available
this.dw_serialno_select=create dw_serialno_select
this.dw_serialno_ava=create dw_serialno_ava
this.st_1=create st_1
this.r_1=create r_1
this.gb_1=create gb_1
this.Control[]={this.st_supplier,&
this.st_2,&
this.cb_done,&
this.cb_1,&
this.st_selected_qty,&
this.st_requiredqty,&
this.st_itemnumber,&
this.cb_cancel,&
this.st_selected_t,&
this.st_available_t,&
this.cb_selected,&
this.cb_available,&
this.dw_serialno_select,&
this.dw_serialno_ava,&
this.st_1,&
this.r_1,&
this.gb_1}
end on

on w_do_serialno.destroy
destroy(this.st_supplier)
destroy(this.st_2)
destroy(this.cb_done)
destroy(this.cb_1)
destroy(this.st_selected_qty)
destroy(this.st_requiredqty)
destroy(this.st_itemnumber)
destroy(this.cb_cancel)
destroy(this.st_selected_t)
destroy(this.st_available_t)
destroy(this.cb_selected)
destroy(this.cb_available)
destroy(this.dw_serialno_select)
destroy(this.dw_serialno_ava)
destroy(this.st_1)
destroy(this.r_1)
destroy(this.gb_1)
end on

event open;wf_window_center()
post event ue_open()
end event

event close;closewithreturn(this,  istrmultiparms)
end event

type st_supplier from statictext within w_do_serialno
integer x = 494
integer y = 148
integer width = 613
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
boolean focusrectangle = false
end type

type st_2 from statictext within w_do_serialno
integer x = 123
integer y = 148
integer width = 315
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

type cb_done from commandbutton within w_do_serialno
integer x = 951
integer y = 1332
integer width = 247
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
end type

event clicked;
long ll_upd,i,ll_status


IF st_requiredqty.text > string(dw_serialno_select.RowCount()) THEN
	ll_status=MessageBox(w_do_serialno.Title,"The number of serial numbers entered does not equal the number of serial numbers required. Would you like to exit anyway?" &
	           ,Question!,YesNo! )
ElseIF st_requiredqty.text < string(dw_serialno_select.RowCount()) THEN		
		MessageBox(w_do_serialno.Title,"The number of serial numbers entered cannot be more then the number of serial numbers required.")
	else
		FOR i = 1 TO dw_serialno_select.rowcount()
				istrmultiparms.string_arg1[i]=dw_serialno_select.GetItemString(i,'serial_no')
				istrmultiparms.string_arg2[i]=dw_serialno_select.GetItemString(i,'l_code')
				istrmultiparms.string_arg3[i]=dw_serialno_select.GetItemString(i,'lot_no')
				istrmultiparms.string_arg4[i]=dw_serialno_select.GetItemString(i,'po_no')
				istrmultiparms.string_arg5[i]=dw_serialno_select.GetItemString(i,'inventory_type')
				istrmultiparms.string_arg6[i]=dw_serialno_select.GetItemString(i,'country_of_origin') /* 12/00 PCONKL */
				istrmultiparms.long_arg1[i]=dw_serialno_select.GetItemNumber(i,'Owner_id') /* 12/00 PCONKL */
		NEXT  
	closewithreturn(parent,istrmultiparms)
END IF	
IF ll_status = 1 THEN
	 FOR i = 1 TO dw_serialno_select.rowcount()
				istrmultiparms.string_arg1[i]=dw_serialno_select.GetItemString(i,'serial_no')
				istrmultiparms.string_arg2[i]=dw_serialno_select.GetItemString(i,'l_code')
				istrmultiparms.string_arg3[i]=dw_serialno_select.GetItemString(i,'lot_no')
				istrmultiparms.string_arg4[i]=dw_serialno_select.GetItemString(i,'po_no')
				istrmultiparms.string_arg5[i]=dw_serialno_select.GetItemString(i,'inventory_type')
				istrmultiparms.string_arg6[i]=dw_serialno_select.GetItemString(i,'country_of_origin') /* 12/00 PCONKL */
				istrmultiparms.long_arg1[i]=dw_serialno_select.GetItemNumber(i,'Owner_id') /* 12/00 PCONKL */
		NEXT  
	closewithreturn(parent,istrmultiparms)
END IF	 
end event

type cb_1 from commandbutton within w_do_serialno
integer x = 1678
integer y = 1332
integer width = 247
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sel All"
end type

event clicked;long ll_rows
if  not ib_value THEN 
	ib_value = TRUE	
		wf_select_all(dw_serialno_ava,dw_serialno_select)
		ib_value = FALSE
Else
	ib_value = False
	dw_serialno_ava.SelectRow(0, ib_value)	 
END IF
st_selected_qty.text = string(dw_serialno_select.RowCount())


end event

event constructor;ib_value = False
end event

type st_selected_qty from statictext within w_do_serialno
integer x = 2510
integer y = 524
integer width = 247
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
boolean focusrectangle = false
end type

type st_requiredqty from statictext within w_do_serialno
integer x = 631
integer y = 524
integer width = 247
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
boolean focusrectangle = false
end type

type st_itemnumber from statictext within w_do_serialno
integer x = 494
integer y = 84
integer width = 613
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
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_do_serialno
integer x = 1285
integer y = 1332
integer width = 247
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_multiparms lstrmultiparms
istrmultiparms[] =lstrmultiparms[]
w_do_serialno.triggerevent(close!)

end event

type st_selected_t from statictext within w_do_serialno
integer x = 1746
integer y = 532
integer width = 530
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
string text = "Quantity Selected"
boolean focusrectangle = false
end type

type st_available_t from statictext within w_do_serialno
integer x = 59
integer y = 528
integer width = 539
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
string text = "Quantity Required"
boolean focusrectangle = false
end type

type cb_selected from commandbutton within w_do_serialno
integer x = 1371
integer y = 868
integer width = 247
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;dw_serialno_select.RowsMove(dw_serialno_select.Getrow(), dw_serialno_select.Getrow() &
, Primary!, dw_serialno_ava, dw_serialno_select.RowCount(), Primary!)
st_selected_qty.text = string(dw_serialno_select.RowCount())
end event

type cb_available from commandbutton within w_do_serialno
integer x = 1371
integer y = 696
integer width = 247
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;long ll_row
string ll_serial_no

dw_serialno_ava.RowsMove(dw_serialno_ava.Getrow(), dw_serialno_ava.getrow() &
, Primary!, dw_serialno_select, dw_serialno_select.RowCount()+1, Primary!)

ll_row = dw_serialno_select.RowCount()
st_selected_qty.text = string(ll_row)
dw_serialno_select.SCROLLTOROW(ll_row)



end event

type dw_serialno_select from datawindow within w_do_serialno
integer x = 1746
integer y = 616
integer width = 1193
integer height = 520
integer taborder = 30
string dataobject = "d_do_serialno_select"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_name
ls_name=dwo.name
this.SetItemStatus(row, ls_name, &
Primary!, NotModified!)
end event

event constructor;st_selected_qty.text = string(this.RowCount())
end event

event clicked;IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

type dw_serialno_ava from datawindow within w_do_serialno
integer x = 69
integer y = 628
integer width = 1193
integer height = 488
integer taborder = 20
string dataobject = "d_do_serialno_ava"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_name
ls_name=dwo.name
this.SetItemStatus(row, ls_name, &
Primary!, NotModified!)


end event

event clicked;IF row > 0 THEN
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
END IF
end event

event rowfocuschanged;//THIS.SelectRow(currentrow,False)
end event

type st_1 from statictext within w_do_serialno
integer x = 123
integer y = 84
integer width = 315
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
string text = "SKU:"
alignment alignment = right!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_do_serialno
integer linethickness = 8
long fillcolor = 79741120
integer x = 91
integer y = 20
integer width = 1157
integer height = 316
end type

type gb_1 from groupbox within w_do_serialno
integer x = 41
integer y = 472
integer width = 2944
integer height = 792
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Serial Numbers"
borderstyle borderstyle = stylelowered!
end type

