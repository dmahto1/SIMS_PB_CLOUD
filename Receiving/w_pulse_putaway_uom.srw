HA$PBExportHeader$w_pulse_putaway_uom.srw
$PBExportComments$Pulse Putaway UOM Conversion
forward
global type w_pulse_putaway_uom from w_response_ancestor
end type
type dw_1 from u_dw_ancestor within w_pulse_putaway_uom
end type
end forward

global type w_pulse_putaway_uom from w_response_ancestor
integer width = 1550
integer height = 744
string title = "Putaway UOM Conversion"
dw_1 dw_1
end type
global w_pulse_putaway_uom w_pulse_putaway_uom

on w_pulse_putaway_uom.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_pulse_putaway_uom.destroy
call super::destroy
destroy(this.dw_1)
end on

event open;call super::open;
Istrparms = Message.PowerObjectParm
end event

event ue_postopen;call super::ue_postopen;
dw_1.InsertRow(0)

//load input parms to DW
dw_1.SetITem(1,'po_uom',Istrparms.String_arg[1])
dw_1.SetITem(1,'po_uom_1',Istrparms.String_arg[1])

dw_1.SetITem(1,'stock_uom',Istrparms.String_arg[2])
dw_1.SetITem(1,'stock_uom_1',Istrparms.String_arg[2])

dw_1.SetItem(1,'conv_factor',Istrparms.Decimal_arg[1])
dw_1.SetItem(1,'line_stock_qty',Istrparms.Decimal_arg[2])
dw_1.SetItem(1,'putaway_stock_qty',Istrparms.Decimal_arg[3])

//If Conv Factor and and Stock Qty present, calculate PO QTY
If Istrparms.Decimal_arg[1] > 0 Then
	
	dw_1.SetITem(1,'line_po_qty',(Istrparms.Decimal_arg[2] / Istrparms.Decimal_arg[1]))
	dw_1.SetITem(1,'putaway_po_qty',(Istrparms.Decimal_arg[3] / Istrparms.Decimal_arg[1]))
	
Else /* not present, set to Stock QTY */
	
	dw_1.SetITem(1,'line_po_qty',Istrparms.Decimal_arg[2])
	dw_1.SetITem(1,'putaway_po_qty',Istrparms.Decimal_arg[3])
	
End If /* Conversion factor present */

dw_1.SetFocus()
dw_1.SetColumn('putaway_po_qty')
end event

event closequery;call super::closequery;
dw_1.AcceptText()

//Return Stock QTY in Dec Arg 1
istrparms.Decimal_arg[1] = dw_1.GetITemNumber(1,'putaway_stock_qty')
Message.PowerObjectParm = Istrparms

end event

type cb_cancel from w_response_ancestor`cb_cancel within w_pulse_putaway_uom
integer x = 846
integer y = 536
integer height = 92
integer taborder = 30
integer textsize = -8
end type

type cb_ok from w_response_ancestor`cb_ok within w_pulse_putaway_uom
integer x = 379
integer y = 536
integer height = 92
integer taborder = 20
integer textsize = -8
end type

type dw_1 from u_dw_ancestor within w_pulse_putaway_uom
integer y = 12
integer width = 1550
integer height = 440
boolean bringtotop = true
string dataobject = "d_pulse_putaway_uom"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
//If PO QTY Changes, calc Stock QTY
If Upper(dwo.Name) = 'PUTAWAY_PO_QTY' Then
	If isnumber(data) Then
		If Istrparms.Decimal_arg[1] > 0 Then
			This.SetItem(1,'putaway_stock_qty',(dec(data) * Istrparms.Decimal_arg[1]))
		Else
			This.SetItem(1,'putaway_stock_qty',dec(data))
		End If
	End If
End If
end event

