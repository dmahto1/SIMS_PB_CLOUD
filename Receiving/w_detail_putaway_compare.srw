HA$PBExportHeader$w_detail_putaway_compare.srw
forward
global type w_detail_putaway_compare from window
end type
type dw_detail_putaway_compare from datawindow within w_detail_putaway_compare
end type
type cb_close from commandbutton within w_detail_putaway_compare
end type
type st_header from statictext within w_detail_putaway_compare
end type
end forward

global type w_detail_putaway_compare from window
integer width = 4805
integer height = 1232
boolean titlebar = true
boolean controlmenu = true
boolean resizable = true
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
boolean center = true
dw_detail_putaway_compare dw_detail_putaway_compare
cb_close cb_close
st_header st_header
end type
global w_detail_putaway_compare w_detail_putaway_compare

type variables
 str_parms istr_parms
end variables

on w_detail_putaway_compare.create
this.dw_detail_putaway_compare=create dw_detail_putaway_compare
this.cb_close=create cb_close
this.st_header=create st_header
this.Control[]={this.dw_detail_putaway_compare,&
this.cb_close,&
this.st_header}
end on

on w_detail_putaway_compare.destroy
destroy(this.dw_detail_putaway_compare)
destroy(this.cb_close)
destroy(this.st_header)
end on

event open;long i_ndx, k_ndx
Datawindow ldw_detail
//str_parms lstr_parms
//lstr_parms = message.PowerobjectParm 

If IsValid( Message.PowerObjectParm ) Then
   ldw_detail = Message.PowerObjectParm
Else
   Close ( This )
End If


k_ndx = 1  // initialize rows for the not equal items
for i_ndx = 1 to ldw_detail.rowcount()
	if ldw_detail.GetItemNumber(i_ndx, 'alloc_qty') &
		<> ldw_detail.GetItemNumber(i_ndx, 'req_qty') then
		
		dw_detail_putaway_compare.InsertRow(k_ndx)
		dw_detail_putaway_compare.SetItem(k_ndx, 'rownum', ldw_detail.GetItemNumber(i_ndx, 'Compute_1'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'line_item_no', ldw_detail.GetItemNumber(i_ndx, 'line_item_no'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'sku', ldw_detail.GetItemString(i_ndx, 'sku'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'description_1', ldw_detail.GetItemString(i_ndx, 'description_1'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'req_qty', ldw_detail.GetItemNumber(i_ndx, 'req_qty'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'alloc_qty', ldw_detail.GetItemNumber(i_ndx, 'alloc_qty'))
		dw_detail_putaway_compare.SetItem(k_ndx, 'diff', ldw_detail.GetItemNumber(i_ndx, 'alloc_qty') &
			-   ldw_detail.GetItemNumber(i_ndx, 'req_qty') )
		dw_detail_putaway_compare.SetItem(k_ndx, 'damage_qty', ldw_detail.GetItemNumber(i_ndx, 'damage_qty'))
		k_ndx ++
	end if

next
end event

type dw_detail_putaway_compare from datawindow within w_detail_putaway_compare
integer x = 128
integer y = 448
integer width = 4480
integer height = 572
integer taborder = 30
string title = "none"
string dataobject = "d_detail_putaway_order_compare"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type cb_close from commandbutton within w_detail_putaway_compare
integer x = 1993
integer y = 236
integer width = 576
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;//
//istr_parms.Long_arg[1] = 1
//
//closeWithReturn(parent, istr_parms)

close(parent)
end event

type st_header from statictext within w_detail_putaway_compare
integer x = 1426
integer y = 64
integer width = 1669
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detail vs Putaway Comparison"
alignment alignment = center!
boolean focusrectangle = false
end type

